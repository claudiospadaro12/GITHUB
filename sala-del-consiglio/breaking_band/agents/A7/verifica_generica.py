#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
verifica_generica.py - Verificatore indipendente (A7), progetto Breaking Band, R004 fase 1.

SCOPO
  Controlli riutilizzabili che prendono una FUNZIONE DI SEGNALE e dei dati, piu un
  ricalcolatore indipendente di una simulazione di trade da barre M1.
  NON importa il motore di A4 e non conosce le regole numeriche di A2: e scritto da zero.
  Dipendenze: solo libreria standard + numpy.

CONVENZIONI (da rispettare, altrimenti i controlli non sono significativi)
  * "bars" = dict di array numpy della stessa lunghezza n, chiavi minime:
        time (minuti dall'epoca, int64), open, high, low, close, spread (punti; 1 punto = 0,01 USD).
  * "signal_fn(bars)" = funzione che restituisce un array (n,) di int (+1 / -1 / 0) oppure un dict di
    array con primo asse n. Il valore alla posizione j DEVE dipendere solo dalle barre 0..j (barra j chiusa).
    L'ingresso, se c'e, avviene all'apertura della barra j+1.
  * prezzi del grafico = BID (come nei dati MT5); ask = bid + spread.
  * stato dei controlli: SUPERATO / FALLITO / NON_CONCLUSIVO (controllo vuoto o non eseguibile:
    un controllo non concluso NON e superato).

ESECUZIONE AUTO-TEST:   python3 -I verifica_generica.py
"""
import copy
import hashlib
import math
import os
import random
import subprocess
import sys
import tempfile
import time as _time

import numpy as np

SUPERATO = "SUPERATO"
FALLITO = "FALLITO"
NON_CONCLUSIVO = "NON_CONCLUSIVO"


# ----------------------------------------------------------------------------------------------
# Utilita di base
# ----------------------------------------------------------------------------------------------
class CheckResult:
    def __init__(self, name, status, detail="", data=None):
        self.name = name
        self.status = status
        self.detail = detail
        self.data = data or {}

    @property
    def passed(self):
        return self.status == SUPERATO

    def __str__(self):
        return "[%s] %s - %s" % (self.status, self.name, self.detail)

    __repr__ = __str__


def to_minutes(x):
    """Converte int / np.datetime64 / datetime / stringa 'YYYY.MM.DD HH:MM' o ISO in minuti dall'epoca."""
    if isinstance(x, (bool, np.bool_)):
        raise TypeError("bool non e un tempo")
    if isinstance(x, (int, np.integer)):
        return int(x)
    if isinstance(x, np.datetime64):
        return int(x.astype("datetime64[m]").astype(np.int64))
    if isinstance(x, str):
        s = x.strip()
        if len(s) >= 10 and s[4] == "." and s[7] == ".":
            s = s[:4] + "-" + s[5:7] + "-" + s[8:]
        s = s.replace(" ", "T")
        return int(np.datetime64(s[:16], "m").astype(np.int64))
    if hasattr(x, "isoformat"):
        return int(np.datetime64(x.isoformat()[:16], "m").astype(np.int64))
    raise TypeError("tempo non convertibile: %r" % (x,))


def minutes_to_str(m):
    return str(np.datetime64(int(m), "m")).replace("T", " ")


def sha256_file(path, chunk=1 << 20):
    h = hashlib.sha256()
    with open(path, "rb") as f:
        while True:
            b = f.read(chunk)
            if not b:
                break
            h.update(b)
    return h.hexdigest()


def hash_output(obj):
    """sha256 canonico di un risultato (ndarray / dict / list / tuple / scalari / stringhe)."""
    h = hashlib.sha256()

    def upd(o):
        if isinstance(o, np.ndarray):
            h.update(b"A" + str(o.dtype).encode() + str(o.shape).encode())
            h.update(np.ascontiguousarray(o).tobytes())
        elif isinstance(o, dict):
            h.update(b"D%d" % len(o))
            for k in sorted(o, key=lambda z: str(z)):
                upd(str(k))
                upd(o[k])
        elif isinstance(o, (list, tuple)):
            h.update(b"L%d" % len(o))
            for e in o:
                upd(e)
        elif isinstance(o, (float, np.floating)):
            h.update(b"F" + repr(float(o)).encode())
        elif isinstance(o, (bool, np.bool_)):
            h.update(b"B" + (b"1" if o else b"0"))
        elif isinstance(o, (int, np.integer)):
            h.update(b"I" + str(int(o)).encode())
        elif o is None:
            h.update(b"N")
        else:
            h.update(b"S" + str(o).encode("utf-8", "replace"))

    upd(obj)
    return h.hexdigest()


# ----------------------------------------------------------------------------------------------
# Dati M1
# ----------------------------------------------------------------------------------------------
class M1:
    """Barre M1 (bid) con spread. spread_pts in punti; point = valore di un punto in prezzo (oro: 0,01)."""

    def __init__(self, t, o, h, l, c, spread_pts, point=0.01):
        self.t = np.asarray(t, dtype=np.int64)
        self.o = np.asarray(o, dtype=float)
        self.h = np.asarray(h, dtype=float)
        self.l = np.asarray(l, dtype=float)
        self.c = np.asarray(c, dtype=float)
        self.sp_pts = np.asarray(spread_pts, dtype=float)
        self.point = float(point)
        n = len(self.t)
        for a in (self.o, self.h, self.l, self.c, self.sp_pts):
            if len(a) != n:
                raise ValueError("lunghezze diverse")
        if n == 0:
            raise ValueError("M1 vuoto")
        for a in (self.o, self.h, self.l, self.c, self.sp_pts):
            if not np.all(np.isfinite(a)):
                raise ValueError("valori non finiti nei dati M1")
        if n > 1 and not np.all(np.diff(self.t) > 0):
            raise ValueError("tempi M1 non strettamente crescenti")
        self.spread = self.sp_pts * self.point  # spread in unita di prezzo
        # liste Python per il ciclo del simulatore (piu veloci dello scalare numpy)
        self._t = self.t.tolist()
        self._o = self.o.tolist()
        self._h = self.h.tolist()
        self._l = self.l.tolist()
        self._c = self.c.tolist()
        self._s = self.spread.tolist()
        self.n = n

    def first_index_at_or_after(self, minute):
        return int(np.searchsorted(self.t, int(minute), side="left"))

    def validate(self):
        """Elenco di anomalie OHLC (non solleva)."""
        issues = []
        if np.any(self.h < np.maximum(self.o, self.c) - 1e-12):
            issues.append("high < max(open, close) in %d barre" % int(np.sum(self.h < np.maximum(self.o, self.c) - 1e-12)))
        if np.any(self.l > np.minimum(self.o, self.c) + 1e-12):
            issues.append("low > min(open, close) in %d barre" % int(np.sum(self.l > np.minimum(self.o, self.c) + 1e-12)))
        if np.any(self.sp_pts < 0):
            issues.append("spread negativo")
        return issues

    def to_bars(self):
        return {"time": self.t.copy(), "open": self.o.copy(), "high": self.h.copy(),
                "low": self.l.copy(), "close": self.c.copy(), "spread": self.sp_pts.copy()}


def load_m1_csv(path, point=0.01):
    """Legge un CSV 'time;open;high;low;close;tickvol;spread' (time 'YYYY.MM.DD HH:MM'). I dati sono NON fidati:
    solo parsing numerico, nessuna esecuzione."""
    tt, o, h, l, c, sp = [], [], [], [], [], []
    with open(path, "r", encoding="utf-8", errors="replace") as f:
        header = f.readline().strip().split(";")
        if header[:5] != ["time", "open", "high", "low", "close"] or header[-1] != "spread":
            raise ValueError("intestazione CSV inattesa: %r" % header)
        for ln in f:
            ln = ln.strip()
            if not ln:
                continue
            p = ln.split(";")
            ts = p[0]
            tt.append(ts[:4] + "-" + ts[5:7] + "-" + ts[8:10] + "T" + ts[11:16])
            o.append(float(p[1])); h.append(float(p[2])); l.append(float(p[3])); c.append(float(p[4]))
            sp.append(float(p[-1]))
    t = np.array(tt, dtype="datetime64[m]").astype(np.int64)
    return M1(t, o, h, l, c, sp, point=point)


def aggregate_m1(m1, tf_minutes, min_m1=1):
    """M1 -> barre di timeframe tf (bucket = floor(minuti_epoca / tf) * tf). Scritta da zero, indipendente da A4.
    Restituisce dict 'bars' (+ n_m1 = numero di M1 per barra). Le barre con meno di min_m1 minuti sono scartate."""
    bucket = (m1.t // tf_minutes) * tf_minutes
    change = np.flatnonzero(np.diff(bucket)) + 1
    starts = np.concatenate(([0], change))
    ends = np.concatenate((change, [m1.n]))
    k = len(starts)
    out = {key: np.empty(k) for key in ("open", "high", "low", "close", "spread")}
    tm = np.empty(k, dtype=np.int64)
    cnt = np.empty(k, dtype=np.int64)
    for i, (a, b) in enumerate(zip(starts, ends)):
        tm[i] = bucket[a]
        out["open"][i] = m1.o[a]
        out["high"][i] = m1.h[a:b].max()
        out["low"][i] = m1.l[a:b].min()
        out["close"][i] = m1.c[b - 1]
        out["spread"][i] = m1.sp_pts[b - 1]
        cnt[i] = b - a
    keep = cnt >= min_m1
    res = {"time": tm[keep]}
    for key in out:
        res[key] = out[key][keep]
    res["n_m1"] = cnt[keep]
    return res


def true_range(h, l, c):
    pc = np.concatenate(([np.nan], c[:-1]))
    tr = np.maximum.reduce([h - l, np.abs(h - pc), np.abs(l - pc)])
    tr[0] = h[0] - l[0]
    return tr


def atr_sma(h, l, c, period):
    """ATR a media semplice del True Range (convenzione MT5 iATR). NaN fino a period barre."""
    tr = true_range(h, l, c)
    out = np.full(len(tr), np.nan)
    for i in range(period - 1, len(tr)):
        out[i] = tr[i - period + 1:i + 1].mean()
    return out


def atr_wilder(h, l, c, period):
    """ATR con smoothing di Wilder (RMA). Inizializzato con la media dei primi 'period' TR."""
    tr = true_range(h, l, c)
    out = np.full(len(tr), np.nan)
    if len(tr) < period:
        return out
    out[period - 1] = tr[:period].mean()
    for i in range(period, len(tr)):
        out[i] = (out[i - 1] * (period - 1) + tr[i]) / period
    return out


# ----------------------------------------------------------------------------------------------
# Manipolazione di "bars": troncamento, specchio
# ----------------------------------------------------------------------------------------------
def _n_bars(bars):
    return len(bars["close"])


def slice_bars(bars, n):
    """Primi n elementi di ogni array di lunghezza n_tot (copie)."""
    N = _n_bars(bars)
    out = {}
    for k, v in bars.items():
        if isinstance(v, np.ndarray) and v.ndim >= 1 and v.shape[0] == N:
            out[k] = v[:n].copy()
        else:
            out[k] = copy.deepcopy(v)
    return out


def mirror_bars(bars, offset=0.0, spread_shift=False, point=0.01):
    """Specchia i prezzi: p' = offset - p ; open'=-open, high'=-low, low'=-high, close'=-close (con offset).
    spread_shift=True: p' = offset - (p + spread*point), cioe il bid dello specchio e l'ASK dell'originale
    (specchio corretto per un simulatore con trigger sul lato eseguibile). Lo spread resta invariato."""
    out = {k: (v.copy() if isinstance(v, np.ndarray) else copy.deepcopy(v)) for k, v in bars.items()}
    sh = bars["spread"] * point if spread_shift else 0.0
    o, h, l, c = bars["open"] + sh, bars["high"] + sh, bars["low"] + sh, bars["close"] + sh
    out["open"] = offset - o
    out["high"] = offset - l
    out["low"] = offset - h
    out["close"] = offset - c
    return out


def mirror_m1(m1, mode="negate", offset=0.0):
    """Specchio di un oggetto M1. mode='negate': p'=offset-p ; mode='bid_ask': p'=offset-(p+spread)."""
    b = mirror_bars(m1.to_bars(), offset=offset, spread_shift=(mode == "bid_ask"), point=m1.point)
    return M1(m1.t, b["open"], b["high"], b["low"], b["close"], m1.sp_pts, point=m1.point)


# ----------------------------------------------------------------------------------------------
# Confronto di output
# ----------------------------------------------------------------------------------------------
def _as_dict(out):
    if isinstance(out, dict):
        return {str(k): np.asarray(v) for k, v in out.items()}
    if isinstance(out, (tuple, list)):
        return {str(i): np.asarray(v) for i, v in enumerate(out)}
    return {"signal": np.asarray(out)}


def _bad_mask(a, b, atol=0.0):
    """Maschera (lungh. asse 0) delle posizioni diverse; None se le forme non coincidono."""
    a = np.asarray(a)
    b = np.asarray(b)
    if a.shape != b.shape:
        return None
    if a.dtype.kind in "fc" or b.dtype.kind in "fc":
        a = a.astype(float)
        b = b.astype(float)
        same = (a == b) | (np.isnan(a) & np.isnan(b))
        if atol > 0:
            same = same | (np.abs(a - b) <= atol)
    else:
        same = a == b
    bad = ~same
    if bad.ndim > 1:
        bad = bad.reshape(bad.shape[0], -1).any(axis=1)
    return bad


def _n_nonzero_signals(outd, signal_key):
    if signal_key not in outd:
        return 0, 0
    s = outd[signal_key]
    return int(np.sum(s > 0)), int(np.sum(s < 0))


# ----------------------------------------------------------------------------------------------
# CONTROLLO 1: invarianza al troncamento del futuro
# ----------------------------------------------------------------------------------------------
def choose_cuts(full_signal, n, n_cuts=200, seed=0, min_cut=None, exhaustive_max=3000):
    """Posizioni k (ultima barra tenuta). Esaustivo se n <= exhaustive_max; altrimenti casuali + intorno ai segnali."""
    if min_cut is None:
        min_cut = min(max(30, n // 20), max(n - 2, 1))
    last = n - 2
    if last < min_cut:
        return []
    if n <= exhaustive_max:
        return list(range(min_cut, last + 1))
    rng = random.Random(seed)
    cuts = set(rng.sample(range(min_cut, last + 1), min(n_cuts, last - min_cut + 1)))
    cuts.update([min_cut, last])
    if full_signal is not None:
        idx = np.flatnonzero(np.asarray(full_signal) != 0)
        idx = [int(i) for i in idx if min_cut <= i <= last + 1]
        if len(idx) > 100:
            idx = rng.sample(idx, 100)
        for j in idx:
            for k in (j - 1, j, j + 1):
                if min_cut <= k <= last:
                    cuts.add(k)
    return sorted(cuts)


def check_truncation_invariance(signal_fn, bars, cuts=None, n_cuts=200, seed=0, min_cut=None,
                                signal_key="signal", min_signals=5, atol=0.0, exhaustive_max=3000):
    """Per ogni taglio k: cancella le barre dopo k e verifica che l'output su 0..k coincida con quello pieno.
    Verifica TUTTE le posizioni 0..k, compresa la k (ultima barra rimasta).
    NON_CONCLUSIVO se i segnali nella regione sono meno di min_signals (controllo vuoto)."""
    name = "invarianza_troncamento"
    n = _n_bars(bars)
    full = _as_dict(signal_fn(slice_bars(bars, n)))
    sig = full.get(signal_key)
    if sig is None:
        return CheckResult(name, NON_CONCLUSIVO, "chiave segnale '%s' assente nell'output" % signal_key)
    if cuts is None:
        cuts = choose_cuts(sig, n, n_cuts=n_cuts, seed=seed, min_cut=min_cut, exhaustive_max=exhaustive_max)
    if not cuts:
        return CheckResult(name, NON_CONCLUSIVO, "nessun punto di taglio disponibile (dati troppo corti)")
    fails = []
    for k in cuts:
        part = _as_dict(signal_fn(slice_bars(bars, k + 1)))
        if set(part) != set(full):
            fails.append((k, "chiavi diverse", None))
            continue
        for key in full:
            bad = _bad_mask(full[key][:k + 1], part[key])
            if bad is None:
                fails.append((k, "forma/lunghezza diversa su '%s': %s vs %s" % (key, full[key][:k + 1].shape, part[key].shape), None))
            elif bad.any():
                j = int(np.flatnonzero(bad)[0])
                fails.append((k, "mismatch su '%s' alla barra j=%d" % (key, j), j))
    n_sig = int(np.sum(sig != 0))
    kmax = max(cuts)
    n_sig_region = int(np.sum(sig[:kmax + 1] != 0))
    data = {"n_cuts": len(cuts), "n_fail": len(fails), "n_signals_full": n_sig, "n_signals_region": n_sig_region,
            "first_fails": fails[:5]}
    if fails:
        return CheckResult(name, FALLITO, "%d/%d tagli con output diverso; primo: taglio k=%d, %s" %
                           (len(fails), len(cuts), fails[0][0], fails[0][1]), data)
    if n_sig_region < min_signals:
        return CheckResult(name, NON_CONCLUSIVO, "nessuna differenza ma solo %d segnali nella regione testata (<%d): controllo vuoto" %
                           (n_sig_region, min_signals), data)
    return CheckResult(name, SUPERATO, "%d tagli, %d segnali nella regione, nessuna differenza" % (len(cuts), n_sig_region), data)


def check_future_perturbation(signal_fn, bars, n_trials=40, seed=0, min_cut=None, signal_key="signal",
                              min_signals=5, atol=0.0):
    """Variante piu aggressiva: invece di cancellare il futuro lo SOSTITUISCE (barre invertite di ordine e traslate
    di un livello casuale). L'output su 0..k deve restare identico. Individua anche statistiche globali sul campione."""
    name = "invarianza_perturbazione_futuro"
    n = _n_bars(bars)
    full = _as_dict(signal_fn(slice_bars(bars, n)))
    sig = full.get(signal_key)
    if sig is None:
        return CheckResult(name, NON_CONCLUSIVO, "chiave segnale '%s' assente" % signal_key)
    if min_cut is None:
        min_cut = min(max(30, n // 20), max(n - 2, 1))
    last = n - 2
    if last < min_cut:
        return CheckResult(name, NON_CONCLUSIVO, "dati troppo corti")
    rng = random.Random(seed)
    cand = list(range(min_cut, last + 1))
    ks = sorted(rng.sample(cand, min(n_trials, len(cand))))
    mean_c = float(np.mean(bars["close"]))
    price_keys = ("open", "high", "low", "close")
    fails = []
    for k in ks:
        pb = slice_bars(bars, n)
        for key in price_keys:
            pb[key][k + 1:] = pb[key][k + 1:][::-1]
        # le barre invertite mantengono OHLC coerente per barra (si inverte solo l'ordine delle barre)
        shift = rng.uniform(-0.3, 0.6) * abs(mean_c)
        for key in price_keys:
            pb[key][k + 1:] = pb[key][k + 1:] + shift
        part = _as_dict(signal_fn(pb))
        for key in full:
            if key not in part:
                fails.append((k, "chiave '%s' mancante" % key, None))
                continue
            bad = _bad_mask(full[key][:k + 1], part[key][:k + 1])
            if bad is None:
                fails.append((k, "forma diversa su '%s'" % key, None))
            elif bad.any():
                j = int(np.flatnonzero(bad)[0])
                fails.append((k, "mismatch su '%s' alla barra j=%d" % (key, j), j))
    n_sig_region = int(np.sum(sig[:max(ks) + 1] != 0))
    data = {"n_trials": len(ks), "n_fail": len(fails), "n_signals_region": n_sig_region, "first_fails": fails[:5]}
    if fails:
        return CheckResult(name, FALLITO, "%d/%d perturbazioni cambiano il passato; primo: k=%d, %s" %
                           (len(fails), len(ks), fails[0][0], fails[0][1]), data)
    if n_sig_region < min_signals:
        return CheckResult(name, NON_CONCLUSIVO, "pochi segnali (%d) per concludere" % n_sig_region, data)
    return CheckResult(name, SUPERATO, "%d perturbazioni del futuro, passato invariato" % len(ks), data)


# ----------------------------------------------------------------------------------------------
# CONTROLLO 2: simmetria rialzo/ribasso (specchio dei prezzi)
# ----------------------------------------------------------------------------------------------
def check_mirror_symmetry(signal_fn, bars, offset=0.0, spread_shift=False, flip_keys=("signal",),
                          price_keys=(), signal_key="signal", min_signals=5, min_each_side=1, atol=0.0):
    """Specchia i prezzi (p' = offset - p). Attesi: segnale' = -segnale; chiavi in price_keys: x' = offset - x;
    altre chiavi invariate. NON_CONCLUSIVO se non ci sono segnali (o manca un lato) nell'originale."""
    name = "simmetria_specchio"
    out = _as_dict(signal_fn(slice_bars(bars, _n_bars(bars))))
    outm = _as_dict(signal_fn(mirror_bars(bars, offset=offset, spread_shift=spread_shift)))
    if signal_key not in out:
        return CheckResult(name, NON_CONCLUSIVO, "chiave segnale assente")
    problems = []
    for key in out:
        if key not in outm:
            problems.append("chiave '%s' mancante nell'output specchiato" % key)
            continue
        exp = out[key]
        if key in flip_keys:
            exp = -exp
        elif key in price_keys:
            exp = offset - exp
        bad = _bad_mask(exp, outm[key], atol=atol)
        if bad is None:
            problems.append("forma diversa su '%s'" % key)
        elif bad.any():
            problems.append("'%s': %d barre non speculari (prima j=%d)" % (key, int(bad.sum()), int(np.flatnonzero(bad)[0])))
    nl, ns = _n_nonzero_signals(out, signal_key)
    nlm, nsm = _n_nonzero_signals(outm, signal_key)
    data = {"orig_long": nl, "orig_short": ns, "mirror_long": nlm, "mirror_short": nsm, "problems": problems}
    if problems:
        return CheckResult(name, FALLITO, "; ".join(problems[:3]) + " | segnali orig L/S=%d/%d, specchio L/S=%d/%d" % (nl, ns, nlm, nsm), data)
    if nl + ns < min_signals or nl < min_each_side or ns < min_each_side:
        return CheckResult(name, NON_CONCLUSIVO, "segnali insufficienti per concludere (L=%d, S=%d)" % (nl, ns), data)
    return CheckResult(name, SUPERATO, "specchio coerente: orig L/S=%d/%d -> specchio L/S=%d/%d" % (nl, ns, nlm, nsm), data)


# ----------------------------------------------------------------------------------------------
# CONTROLLO 3: riproducibilita
# ----------------------------------------------------------------------------------------------
def check_reproducibility(fn, *args, runs=2, **kwargs):
    """Esegue fn(*args, **kwargs) 'runs' volte su copie profonde degli argomenti; confronta l'hash dell'output."""
    name = "riproducibilita"
    digests = []
    for _ in range(runs):
        a = copy.deepcopy(args)
        kw = copy.deepcopy(kwargs)
        digests.append(hash_output(fn(*a, **kw)))
    same = len(set(digests)) == 1
    return CheckResult(name, SUPERATO if same else FALLITO,
                       ("%d esecuzioni, hash identico %s" % (runs, digests[0][:16])) if same else
                       "hash diversi: " + ", ".join(d[:12] for d in digests), {"digests": digests})


def check_reproducibility_subprocess(cmd, out_path, runs=2, hashseeds=("0", "1")):
    """Esegue il comando 'cmd' (lista argv, fornita da chi verifica) 'runs' volte con PYTHONHASHSEED diversi e
    confronta l'sha256 del file di output. Cancella il file prima di ogni esecuzione."""
    name = "riproducibilita_processo"
    digests = []
    for r in range(runs):
        if os.path.exists(out_path):
            os.remove(out_path)
        env = dict(os.environ)
        env["PYTHONHASHSEED"] = hashseeds[r % len(hashseeds)]
        p = subprocess.run(cmd, env=env, capture_output=True, text=True)
        if p.returncode != 0 or not os.path.exists(out_path):
            return CheckResult(name, NON_CONCLUSIVO, "esecuzione %d fallita (rc=%s): %s" % (r, p.returncode, p.stderr[-300:]))
        digests.append(sha256_file(out_path))
    same = len(set(digests)) == 1
    return CheckResult(name, SUPERATO if same else FALLITO,
                       ("%d esecuzioni (PYTHONHASHSEED diversi), sha256 uguale %s" % (runs, digests[0][:16])) if same else
                       "sha256 diversi: " + ", ".join(d[:12] for d in digests), {"digests": digests})


# ----------------------------------------------------------------------------------------------
# CONTROLLO 4: criteri congelati (hash) e ordine temporale
# ----------------------------------------------------------------------------------------------
def check_frozen_hash(path, expected_sha256):
    name = "criteri_congelati_hash"
    if not os.path.exists(path):
        return CheckResult(name, FALLITO, "file criteri assente: %s" % path)
    cur = sha256_file(path)
    ok = cur.lower() == expected_sha256.strip().lower()
    return CheckResult(name, SUPERATO if ok else FALLITO,
                       "sha256 attuale %s %s atteso %s" % (cur[:16], "==" if ok else "!=", expected_sha256.strip()[:16]),
                       {"current": cur})


def check_freeze_before_results(criteria_path, results_paths):
    """Evidenza DEBOLE (mtime modificabile): il file criteri non deve essere piu recente dei file risultati."""
    name = "criteri_precedenti_ai_risultati"
    mc = os.path.getmtime(criteria_path)
    later = [p for p in results_paths if os.path.getmtime(p) < mc]
    missing = [p for p in results_paths if not os.path.exists(p)]
    if missing:
        return CheckResult(name, NON_CONCLUSIVO, "file risultati assenti: %s" % missing[:3])
    if later:
        return CheckResult(name, FALLITO, "criteri modificati DOPO %d file risultati (es. %s)" % (len(later), later[0]))
    return CheckResult(name, SUPERATO, "mtime criteri <= mtime di tutti i %d file risultati (evidenza debole)" % len(results_paths))


# ----------------------------------------------------------------------------------------------
# CONTROLLO 5: imbuto, sovrapposizioni, ingresso alla barra successiva
# ----------------------------------------------------------------------------------------------
def funnel_recount(conditions):
    """conditions = lista ordinata di (nome, maschera bool). Restituisce [(nome, marginale, cumulativo)]."""
    rows = []
    cum = None
    for nm, mask in conditions:
        m = np.asarray(mask, dtype=bool)
        cum = m.copy() if cum is None else (cum & m)
        rows.append((nm, int(m.sum()), int(cum.sum())))
    return rows


def check_funnel(reported, recount=None, n_signals=None, n_trades=None, n_skipped=None, cumulative=True):
    """reported = [(nome, conteggio)]. Controlli: interi >= 0; se cumulativo non crescente; coincide con il
    ricalcolo (funnel_recount, colonna cumulativa); ultimo stadio == n_signals; n_signals == n_trades + n_skipped."""
    name = "coerenza_imbuto"
    probs = []
    cnts = [c for _, c in reported]
    if any((not isinstance(c, (int, np.integer))) or c < 0 for c in cnts):
        probs.append("conteggi non interi o negativi")
    if cumulative:
        for i in range(1, len(cnts)):
            if cnts[i] > cnts[i - 1]:
                probs.append("stadio '%s' (%d) > stadio '%s' (%d)" % (reported[i][0], cnts[i], reported[i - 1][0], cnts[i - 1]))
    if recount is not None:
        if [r[0] for r in recount] != [r[0] for r in reported]:
            probs.append("nomi/ordine stadi diversi dal ricalcolo")
        else:
            for (nm, c), (_, marg, cum) in zip(reported, recount):
                ref = cum if cumulative else marg
                if c != ref:
                    probs.append("stadio '%s': riportato %d, ricalcolato %d" % (nm, c, ref))
    if n_signals is not None and cnts and cnts[-1] != n_signals:
        probs.append("ultimo stadio %d != n_signals %d" % (cnts[-1], n_signals))
    if n_signals is not None and n_trades is not None and n_skipped is not None and n_signals != n_trades + n_skipped:
        probs.append("n_signals %d != n_trades %d + n_skipped %d" % (n_signals, n_trades, n_skipped))
    return CheckResult(name, FALLITO if probs else SUPERATO, "; ".join(probs[:4]) if probs else "imbuto coerente (%d stadi)" % len(reported),
                       {"problems": probs})


def check_no_overlap(trades, entry_key="entry_time", exit_key="exit_time", signal_key=None):
    """Nessun trade con ingresso prima della chiusura del precedente (posizione singola). Se signal_key e
    dato (istante in cui il segnale era noto = chiusura della barra segnale), anche il segnale deve cadere
    quando nessun trade e aperto."""
    name = "nessuna_sovrapposizione"
    if len(trades) < 2:
        return CheckResult(name, NON_CONCLUSIVO, "meno di 2 trade: controllo vuoto")
    rows = sorted(((to_minutes(t[entry_key]), to_minutes(t[exit_key]),
                    to_minutes(t[signal_key]) if signal_key else None, i) for i, t in enumerate(trades)))
    probs = []
    for e, x, s, i in rows:
        if x < e:
            probs.append("trade #%d: uscita prima dell'ingresso" % i)
    for a, b in zip(rows[:-1], rows[1:]):
        if b[0] < a[1]:
            probs.append("trade #%d entra alle %s mentre #%d e aperto fino a %s" % (b[3], minutes_to_str(b[0]), a[3], minutes_to_str(a[1])))
        if signal_key and b[2] < a[1]:
            probs.append("trade #%d: segnale noto alle %s con #%d ancora aperto (uscita %s)" % (b[3], minutes_to_str(b[2]), a[3], minutes_to_str(a[1])))
    return CheckResult(name, FALLITO if probs else SUPERATO, "; ".join(probs[:3]) if probs else "%d trade, nessuna sovrapposizione" % len(trades),
                       {"problems": probs})


def check_entry_next_bar(trades, bar_times, signal_key="signal_bar_time", entry_key="entry_time"):
    """Per ogni trade: entry_time deve essere il tempo di apertura della barra IMMEDIATAMENTE successiva alla
    barra segnale (bar_times = tempi di apertura delle barre del timeframe del segnale, ordinati)."""
    name = "ingresso_barra_successiva"
    bt = np.asarray([to_minutes(x) for x in bar_times], dtype=np.int64)
    if len(trades) == 0:
        return CheckResult(name, NON_CONCLUSIVO, "nessun trade")
    probs = []
    for i, t in enumerate(trades):
        s = to_minutes(t[signal_key])
        e = to_minutes(t[entry_key])
        j = int(np.searchsorted(bt, s))
        if j >= len(bt) or bt[j] != s:
            probs.append("trade #%d: barra segnale %s non e una barra dei dati" % (i, minutes_to_str(s)))
        elif j + 1 >= len(bt) or bt[j + 1] != e:
            probs.append("trade #%d: ingresso %s != barra successiva %s" % (i, minutes_to_str(e), minutes_to_str(bt[j + 1]) if j + 1 < len(bt) else "n/d"))
    return CheckResult(name, FALLITO if probs else SUPERATO, "; ".join(probs[:3]) if probs else "%d trade, ingresso sempre alla barra successiva" % len(trades),
                       {"problems": probs})


# ----------------------------------------------------------------------------------------------
# RICALCOLATORE INDIPENDENTE DI UN TRADE DA M1
# ----------------------------------------------------------------------------------------------
SPREAD_MODELS = ("executable", "chart_bid_cost")


def _targets(spec):
    if "targets" in spec and spec["targets"]:
        sch = [(to_minutes(t), float(p)) for t, p in spec["targets"]]
    elif "target" in spec:
        sch = [(-(1 << 60), float(spec["target"]))]
    else:
        raise ValueError("spec senza target")
    for a, b in zip(sch[:-1], sch[1:]):
        if b[0] < a[0]:
            raise ValueError("schedule dei target non ordinato")
    return sch


def simulate_trade(m1, spec, spread_model="executable", stop_gap_worse=True, target_gap_improve=False,
                   check_entry_bar=True, fixed_spread_pts=None):
    """Ricalcolo da zero di UN trade su barre M1. NON usa il motore di A4.

    spec: direction (+1/-1), entry_time (apertura della barra successiva alla barra segnale),
          stop (livello, scala del grafico/bid), target (float) oppure targets=[(effettivo_da, livello), ...]
          (il target in vigore per la barra M1 di tempo t e l'ultimo con effettivo_da <= t),
          force_close_time opzionale (chiusura forzata all'apertura della prima M1 con tempo >= force_close_time).

    Convenzioni (dichiarate; se il motore ne usa altre vanno dichiarate e parametrizzate, non nascoste):
      * ingresso all'OPEN della prima M1 con tempo >= entry_time; i controlli stop/target iniziano dalla stessa barra
        (check_entry_bar=True).
      * spread di ogni barra = campo 'spread' di quella M1 (o fixed_spread_pts); long entra a ask = open + spread.
      * spread_model 'executable': trigger sul lato eseguibile. Long: stop se low <= stop, target se high >= target
        (uscita al bid). Short: ask = bid + spread; stop se high+spread >= stop, target se low+spread <= target
        (uscita all'ask). Fill al livello; gap: lo stop si riempie al prezzo di apertura se peggiore
        (stop_gap_worse); il target al livello (nessun miglioramento, salvo target_gap_improve).
      * spread_model 'chart_bid_cost': trigger sui prezzi del grafico (bid) per entrambi i lati; short entra al bid e
        esce a ask = livello + spread.
      * STOP PRIMA DEL TARGET se nella stessa M1 sono toccati entrambi.
      * chiusura forzata: all'open della M1 (lato eseguibile); fine dati: close dell'ultima M1.
    Restituisce dict con prezzi, tempi, motivo ('stop'|'target'|'forced'|'end_of_data'), pnl (unita di prezzo, spread
    incluso), both_touched (stop e target toccati nella barra di uscita), warnings."""
    if spread_model not in SPREAD_MODELS:
        raise ValueError("spread_model sconosciuto")
    d = int(spec["direction"])
    if d not in (1, -1):
        raise ValueError("direction deve essere +1 o -1")
    stop = float(spec["stop"])
    sched = _targets(spec)
    ft = to_minutes(spec["force_close_time"]) if spec.get("force_close_time") is not None else None
    t, o, h, l, c = m1._t, m1._o, m1._h, m1._l, m1._c
    spr = m1._s if fixed_spread_pts is None else [fixed_spread_pts * m1.point] * m1.n
    e_t = to_minutes(spec["entry_time"])
    i0 = m1.first_index_at_or_after(e_t)
    if i0 >= m1.n:
        return {"status": "no_entry_bar", "id": spec.get("id")}
    warnings = []
    s_e = spr[i0]
    entry = o[i0] + s_e if d == 1 else o[i0]
    # puntatore sulla schedule dei target
    p = 0
    while p + 1 < len(sched) and sched[p + 1][0] <= t[i0]:
        p += 1
    if sched[p][0] > t[i0]:
        raise ValueError("nessun target in vigore alla barra di ingresso")
    if d == 1 and (stop >= entry or sched[p][1] <= entry):
        warnings.append("long con stop >= prezzo di ingresso o target <= ingresso")
    if d == -1 and (stop <= entry or sched[p][1] >= entry):
        warnings.append("short con stop <= prezzo di ingresso o target >= ingresso")
    res = {"id": spec.get("id"), "direction": d, "entry_idx": i0, "entry_time": t[i0],
           "entry_gap_min": t[i0] - e_t, "entry_price": entry, "spread_entry": s_e, "warnings": warnings,
           "status": "ok"}
    for i in range(i0, m1.n):
        s = spr[i]
        if ft is not None and t[i] >= ft:
            px = o[i] if d == 1 else o[i] + s
            return _close(res, i, t[i], px, "forced", False, d, entry, s)
        while p + 1 < len(sched) and sched[p + 1][0] <= t[i]:
            p += 1
        tgt = sched[p][1]
        if i == i0 and not check_entry_bar:
            continue
        if spread_model == "executable":
            if d == 1:
                stop_hit = l[i] <= stop
                tgt_hit = h[i] >= tgt
                stop_fill = min(stop, o[i]) if stop_gap_worse else stop
                tgt_fill = max(tgt, o[i]) if target_gap_improve else tgt
            else:
                stop_hit = h[i] + s >= stop
                tgt_hit = l[i] + s <= tgt
                stop_fill = max(stop, o[i] + s) if stop_gap_worse else stop
                tgt_fill = min(tgt, o[i] + s) if target_gap_improve else tgt
            stop_px, tgt_px = stop_fill, tgt_fill
        else:  # chart_bid_cost
            if d == 1:
                stop_hit = l[i] <= stop
                tgt_hit = h[i] >= tgt
                stop_px = min(stop, o[i]) if stop_gap_worse else stop
                tgt_px = max(tgt, o[i]) if target_gap_improve else tgt
            else:
                stop_hit = h[i] >= stop
                tgt_hit = l[i] <= tgt
                stop_px = (max(stop, o[i]) if stop_gap_worse else stop) + s
                tgt_px = (min(tgt, o[i]) if target_gap_improve else tgt) + s
        if stop_hit:  # stop PRIMA del target
            return _close(res, i, t[i], stop_px, "stop", bool(stop_hit and tgt_hit), d, entry, s)
        if tgt_hit:
            return _close(res, i, t[i], tgt_px, "target", False, d, entry, s)
    i = m1.n - 1
    px = c[i] if d == 1 else c[i] + spr[i]
    return _close(res, i, t[i], px, "end_of_data", False, d, entry, spr[i])


def _close(res, i, ti, px, reason, both, d, entry, s):
    res["exit_idx"] = i
    res["exit_time"] = ti
    res["exit_price"] = px
    res["exit_reason"] = reason
    res["both_touched"] = both
    res["spread_exit"] = s
    res["pnl"] = (px - entry) if d == 1 else (entry - px)
    res["bars_held"] = i - res["entry_idx"] + 1
    return res


def recalc_trades(m1, specs, **kw):
    return [simulate_trade(m1, sp, **kw) for sp in specs]


def summarize_pnls(pnls):
    """n, vincite (pnl > 0 dopo spread), win rate, profit factor = profitto lordo / |perdita lorda|."""
    p = np.asarray(list(pnls), dtype=float)
    n = int(len(p))
    gp = float(p[p > 0].sum()) if n else 0.0
    gl = float(-p[p < 0].sum()) if n else 0.0
    pf = (gp / gl) if gl > 0 else (math.inf if gp > 0 else float("nan"))
    return {"n": n, "wins": int((p > 0).sum()) if n else 0, "win_rate": (float((p > 0).mean()) if n else float("nan")),
            "gross_profit": gp, "gross_loss": gl, "net": float(p.sum()) if n else 0.0, "pf": pf}


def seed_from_file(path):
    """Seme per il campionamento, derivato dal sha256 del file del log trade: il motore non puo prevederlo."""
    return int(sha256_file(path)[:15], 16)


def select_sample(n_total, k=20, seed=0):
    rng = random.Random(seed)
    return sorted(rng.sample(range(n_total), min(k, n_total)))


_REASON_SYN = {"sl": "stop", "stop_loss": "stop", "stoploss": "stop", "tp": "target", "take_profit": "target",
               "takeprofit": "target", "forced": "forced", "force": "forced", "time": "forced", "timeout": "forced",
               "eod": "end_of_data", "end": "end_of_data", "end_of_data": "end_of_data", "stop": "stop", "target": "target"}


def compare_with_engine(engine_trades, recalculated, key_map=None, tol=1e-6, pnl_scale=1.0):
    """Confronta, trade per trade, log del motore (lista di dict) e ricalcolo. key_map mappa i nomi canonici
    (entry_time, entry_price, exit_time, exit_price, exit_reason, pnl) sui nomi del log del motore.
    pnl_scale: moltiplicatore per portare il pnl del motore in unita di prezzo."""
    name = "ricalcolo_indipendente"
    km = {"entry_time": "entry_time", "entry_price": "entry_price", "exit_time": "exit_time",
          "exit_price": "exit_price", "exit_reason": "exit_reason", "pnl": "pnl"}
    if key_map:
        km.update(key_map)
    if len(engine_trades) != len(recalculated):
        return CheckResult(name, FALLITO, "numero trade diverso: motore %d, ricalcolo %d" % (len(engine_trades), len(recalculated)))
    diffs = []
    for i, (e, r) in enumerate(zip(engine_trades, recalculated)):
        if r.get("status") != "ok":
            diffs.append((i, "ricalcolo non riuscito: %s" % r.get("status")))
            continue
        for field in ("entry_time", "exit_time"):
            if field in km and km[field] in e and to_minutes(e[km[field]]) != r[field]:
                diffs.append((i, "%s motore %s != ricalcolo %s" % (field, minutes_to_str(to_minutes(e[km[field]])), minutes_to_str(r[field]))))
        for field in ("entry_price", "exit_price"):
            if km[field] in e and abs(float(e[km[field]]) - r[field]) > tol:
                diffs.append((i, "%s motore %.5f != ricalcolo %.5f" % (field, float(e[km[field]]), r[field])))
        if km["pnl"] in e and abs(float(e[km["pnl"]]) * pnl_scale - r["pnl"]) > tol:
            diffs.append((i, "pnl motore %.5f != ricalcolo %.5f" % (float(e[km["pnl"]]) * pnl_scale, r["pnl"])))
        if km["exit_reason"] in e:
            er = _REASON_SYN.get(str(e[km["exit_reason"]]).strip().lower(), str(e[km["exit_reason"]]).strip().lower())
            if er != r["exit_reason"]:
                diffs.append((i, "motivo uscita motore '%s' != ricalcolo '%s'" % (er, r["exit_reason"])))
    se = summarize_pnls([float(e[km["pnl"]]) * pnl_scale for e in engine_trades if km["pnl"] in e])
    sr = summarize_pnls([r["pnl"] for r in recalculated if r.get("status") == "ok"])
    data = {"engine": se, "recalc": sr, "diffs": diffs[:20]}
    if diffs:
        return CheckResult(name, FALLITO, "%d differenze su %d trade; prima: trade #%d %s" % (len(diffs), len(recalculated), diffs[0][0], diffs[0][1]), data)
    return CheckResult(name, SUPERATO, "%d trade identici entro %g; motore n/win/PF=%d/%d/%.4f, ricalcolo=%d/%d/%.4f" %
                       (len(recalculated), tol, se["n"], se["wins"], se["pf"], sr["n"], sr["wins"], sr["pf"]), data)


def compare_summary(engine_summary, recalc_summary, pf_rtol=1e-9):
    """engine_summary / recalc_summary: dict con n, wins, pf. Esatto su n e wins, relativo su PF."""
    name = "ricalcolo_statistiche_finali"
    probs = []
    for k in ("n", "wins"):
        if engine_summary.get(k) != recalc_summary.get(k):
            probs.append("%s: motore %s != ricalcolo %s" % (k, engine_summary.get(k), recalc_summary.get(k)))
    a, b = engine_summary.get("pf"), recalc_summary.get("pf")
    if not (a == b or (a is not None and b is not None and abs(a - b) <= pf_rtol * max(1.0, abs(b)))):
        probs.append("pf: motore %s != ricalcolo %s" % (a, b))
    return CheckResult(name, FALLITO if probs else SUPERATO, "; ".join(probs) if probs else "n/wins/PF coincidono", {"problems": probs})


def trace_trade(m1, result, spec=None, before=2, after=1, max_rows=60):
    """Tabella M1 per la ricostruzione A MANO di un trade (open, high, low, close, spread, ask-high, ask-low)."""
    if result.get("status") != "ok":
        return "trade non ricostruibile: %s" % result.get("status")
    a = max(0, result["entry_idx"] - before)
    b = min(m1.n, result["exit_idx"] + 1 + after)
    rows = ["idx   tempo             open     high     low      close    spr(usd) askH    askL"]
    n = 0
    for i in range(a, b):
        if n >= max_rows:
            rows.append("... (%d righe omesse)" % (b - i))
            break
        rows.append("%-5d %s %-8.2f %-8.2f %-8.2f %-8.2f %-8.2f %-8.2f %-8.2f%s" % (
            i, minutes_to_str(m1._t[i]), m1._o[i], m1._h[i], m1._l[i], m1._c[i], m1._s[i], m1._h[i] + m1._s[i], m1._l[i] + m1._s[i],
            "  <-ingresso" if i == result["entry_idx"] else ("  <-uscita(%s)" % result["exit_reason"] if i == result["exit_idx"] else "")))
        n += 1
    rows.append("entry=%.4f exit=%.4f pnl=%.4f direzione=%+d" % (result["entry_price"], result["exit_price"], result["pnl"], result["direction"]))
    if spec is not None:
        rows.append("stop=%s target=%s" % (spec.get("stop"), spec.get("targets") or spec.get("target")))
    return "\n".join(rows)


# ----------------------------------------------------------------------------------------------
# Convenienza: tutti i controlli sul segnale
# ----------------------------------------------------------------------------------------------
def run_signal_checks(signal_fn, bars, mirror_offset=0.0, **kw):
    return [check_truncation_invariance(signal_fn, bars, **kw.get("trunc", {})),
            check_future_perturbation(signal_fn, bars, **kw.get("perturb", {})),
            check_mirror_symmetry(signal_fn, bars, offset=mirror_offset, **kw.get("mirror", {})),
            check_reproducibility(signal_fn, bars)]


def print_report(results, out=sys.stdout):
    for r in results:
        out.write(str(r) + "\n")
    bad = [r for r in results if not r.passed]
    out.write("ESITO: %d/%d SUPERATI; non superati: %s\n" % (len(results) - len(bad), len(results), [r.name for r in bad]))
    return not bad


# ==============================================================================================
# AUTO-TEST SU DATI SINTETICI
# ==============================================================================================
def _synth_m1(seed=12345, weeks=6, step=0.35):
    """M1 sintetico: random walk, giorni feriali continui (sab/dom assenti), spread casuale 10-40 punti."""
    rng = np.random.default_rng(seed)
    base = int(np.datetime64("2020-01-06T00:00", "m").astype(np.int64))  # lunedi
    tt = []
    for d in range(weeks * 7):
        if d % 7 in (5, 6):
            continue
        tt.extend(range(base + d * 1440, base + (d + 1) * 1440))
    t = np.array(tt, dtype=np.int64)
    n = len(t)
    close = 1500.0 + np.cumsum(rng.normal(0, step, n))
    open_ = np.concatenate(([1500.0], close[:-1]))
    hi = np.maximum(open_, close) + np.abs(rng.normal(0, step * 0.5, n))
    lo = np.minimum(open_, close) - np.abs(rng.normal(0, step * 0.5, n))
    open_, hi, lo, close = [np.round(x, 2) for x in (open_, hi, lo, close)]
    hi = np.maximum.reduce([hi, open_, close])
    lo = np.minimum.reduce([lo, open_, close])
    sp = rng.integers(10, 41, n).astype(float)
    return M1(t, open_, hi, lo, close, sp)


def _donchian(bars, wl=20, ws=20, peek=0, global_norm=False, noise=False):
    """Segnale giocattolo: breakout del massimo (long) / minimo (short) delle wl/ws barre precedenti sulla chiusura.
    Varianti DIFETTOSE per provare i controlli: peek (guarda peek barre avanti), ws!=wl (asimmetria),
    global_norm (soglia su statistica dell'intero campione), noise (casualita non seminata)."""
    c, h, l = bars["close"], bars["high"], bars["low"]
    n = len(c)
    sig = np.zeros(n, dtype=np.int8)
    rng = np.random.default_rng() if noise else None
    gmed = float(np.median(h - l)) if global_norm else 0.0
    for j in range(max(wl, ws), n):
        s = 0
        if c[j] > h[j - wl:j].max():
            s = 1
        elif c[j] < l[j - ws:j].min():
            s = -1
        if s != 0 and peek and j + peek < n:
            if (s > 0 and not c[j + peek] > c[j]) or (s < 0 and not c[j + peek] < c[j]):
                s = 0
        if s != 0 and global_norm and (h[j] - l[j]) < 0.9 * gmed:
            s = 0
        if noise and s == 0 and rng.random() < 0.01:
            s = 1
        sig[j] = s
    return sig


def selftest(verbose=True):
    results = []  # (descrizione, bool)

    def rec(desc, ok, extra=""):
        results.append((desc, bool(ok)))
        if verbose:
            print("%s  %s%s" % ("PASS" if ok else "FAIL", desc, (" | " + extra) if extra else ""))

    t0 = _time.time()
    m1 = _synth_m1()
    issues = m1.validate()
    rec("dati sintetici M1 coerenti (OHLC, tempi crescenti)", not issues, "%d barre M1; %s" % (m1.n, issues or "nessuna anomalia"))
    bars = aggregate_m1(m1, 60, min_m1=60)
    rec("aggregazione M1->H1 (barre complete)", len(bars["time"]) > 500 and np.all(bars["n_m1"] == 60),
        "%d barre H1" % len(bars["time"]))
    # aggregazione: controllo a mano su una barra
    b0 = 100
    a, bnd = b0 * 60, (b0 + 1) * 60
    rec("aggregazione H1: open/high/low/close della barra #100 = M1 corrispondenti",
        bars["open"][b0] == m1.o[a] and bars["high"][b0] == m1.h[a:bnd].max() and bars["low"][b0] == m1.l[a:bnd].min()
        and bars["close"][b0] == m1.c[bnd - 1] and bars["time"][b0] == m1.t[a])
    # ATR su caso a mano: h=[2,3,4], l=[1,1,2], c=[1.5,2.5,3] -> TR0=1, TR1=max(2,|3-1.5|,|1-1.5|)=2, TR2=max(2,|4-2.5|,|2-2.5|)=2
    h_ = np.array([2.0, 3.0, 4.0]); l_ = np.array([1.0, 1.0, 2.0]); c_ = np.array([1.5, 2.5, 3.0])
    a2 = atr_sma(h_, l_, c_, 2)
    w2 = atr_wilder(h_, l_, c_, 2)
    rec("ATR a mano (SMA: [nan,1.5,2.0]; Wilder: [nan,1.5,1.75])",
        np.isnan(a2[0]) and abs(a2[1] - 1.5) < 1e-12 and abs(a2[2] - 2.0) < 1e-12 and abs(w2[1] - 1.5) < 1e-12 and abs(w2[2] - 1.75) < 1e-12)

    # --- controlli sul segnale: funzione CORRETTA ---
    good = lambda b: _donchian(b)
    r = check_truncation_invariance(good, bars)
    rec("troncamento: segnale corretto -> SUPERATO", r.status == SUPERATO, r.detail)
    r = check_future_perturbation(good, bars)
    rec("perturbazione futuro: segnale corretto -> SUPERATO", r.status == SUPERATO, r.detail)
    r = check_mirror_symmetry(good, bars)
    rec("specchio: segnale simmetrico corretto -> SUPERATO", r.status == SUPERATO, r.detail)
    r = check_mirror_symmetry(good, bars, offset=float(2 * bars["high"].max()))
    rec("specchio con offset positivo (p'=K-p): segnale corretto -> SUPERATO", r.status == SUPERATO, r.detail)
    r = check_reproducibility(good, bars)
    rec("riproducibilita: segnale deterministico -> SUPERATO", r.status == SUPERATO, r.detail)

    # --- difetti iniettati: i controlli DEVONO dare FALLITO (test del test) ---
    r = check_truncation_invariance(lambda b: _donchian(b, peek=1), bars)
    rec("difetto look-ahead di 1 barra -> troncamento FALLITO", r.status == FALLITO, r.detail)
    r = check_future_perturbation(lambda b: _donchian(b, peek=1), bars, n_trials=200)
    if verbose:  # solo informativo, NON conteggiato: la perturbazione a campione puo mancare un look-ahead di 1 barra
        print("INFO  look-ahead di 1 barra con 200 perturbazioni casuali -> esito=%s (%s); con le 40 di default puo mancare" % (r.status, r.detail))
    r = check_truncation_invariance(lambda b: _donchian(b, peek=5), bars)
    rec("difetto look-ahead di 5 barre -> troncamento FALLITO", r.status == FALLITO, r.detail)
    r = check_future_perturbation(lambda b: _donchian(b, peek=5), bars)
    rec("difetto look-ahead di 5 barre -> perturbazione FALLITO", r.status == FALLITO, r.detail)
    r = check_truncation_invariance(lambda b: _donchian(b, global_norm=True), bars)
    rg1 = r.status
    r2 = check_future_perturbation(lambda b: _donchian(b, global_norm=True), bars)
    rec("difetto statistica globale sul campione -> almeno uno tra troncamento e perturbazione FALLITO",
        FALLITO in (rg1, r2.status), "troncamento=%s, perturbazione=%s" % (rg1, r2.status))
    r = check_mirror_symmetry(lambda b: _donchian(b, ws=30), bars)
    rec("difetto asimmetria long/short (finestre 20 vs 30) -> specchio FALLITO", r.status == FALLITO, r.detail)
    r = check_reproducibility(lambda b: _donchian(b, noise=True), bars)
    rec("difetto non determinismo (rumore non seminato) -> riproducibilita FALLITO", r.status == FALLITO, r.detail)
    # controllo vuoto: funzione che non emette mai segnali -> NON_CONCLUSIVO, non SUPERATO
    r = check_truncation_invariance(lambda b: np.zeros(len(b["close"]), dtype=np.int8), bars)
    rec("segnale sempre nullo -> troncamento NON_CONCLUSIVO (mai SUPERATO)", r.status == NON_CONCLUSIVO, r.detail)
    r = check_mirror_symmetry(lambda b: np.zeros(len(b["close"]), dtype=np.int8), bars)
    rec("segnale sempre nullo -> specchio NON_CONCLUSIVO", r.status == NON_CONCLUSIVO, r.detail)

    # --- riproducibilita su processo ---
    with tempfile.TemporaryDirectory() as td:
        outp = os.path.join(td, "out.txt")
        script_ok = os.path.join(td, "ok.py")
        script_bad = os.path.join(td, "bad.py")
        with open(script_ok, "w") as f:
            f.write("import sys\nopen(sys.argv[1],'w').write('\\n'.join(str(i*i) for i in range(100)))\n")
        with open(script_bad, "w") as f:
            f.write("import sys,os\nopen(sys.argv[1],'w').write(os.urandom(8).hex())\n")
        r = check_reproducibility_subprocess([sys.executable, "-I", script_ok, outp], outp)
        rec("riproducibilita su processo (script deterministico) -> SUPERATO", r.status == SUPERATO, r.detail)
        r = check_reproducibility_subprocess([sys.executable, "-I", script_bad, outp], outp)
        rec("riproducibilita su processo (script casuale) -> FALLITO", r.status == FALLITO, r.detail)

        # --- hash criteri ---
        crit = os.path.join(td, "criteri.md")
        with open(crit, "w") as f:
            f.write("soglia PF >= 1.20\n")
        h0 = sha256_file(crit)
        r = check_frozen_hash(crit, h0)
        rec("hash criteri invariato -> SUPERATO", r.status == SUPERATO, r.detail)
        with open(crit, "w") as f:
            f.write("soglia PF >= 1.10\n")
        r = check_frozen_hash(crit, h0)
        rec("hash criteri dopo modifica della soglia -> FALLITO", r.status == FALLITO, r.detail)
        res_file = os.path.join(td, "ris.csv")
        with open(res_file, "w") as f:
            f.write("x\n")
        os.utime(crit, (_time.time() + 100, _time.time() + 100))
        r = check_freeze_before_results(crit, [res_file])
        rec("criteri piu recenti dei risultati -> FALLITO (evidenza debole)", r.status == FALLITO, r.detail)
        os.utime(crit, (_time.time() - 100, _time.time() - 100))
        r = check_freeze_before_results(crit, [res_file])
        rec("criteri precedenti ai risultati -> SUPERATO (evidenza debole)", r.status == SUPERATO, r.detail)
        s1 = seed_from_file(res_file)
        rec("seme da file riproducibile e campione di 20 deterministico e ordinato",
            s1 == seed_from_file(res_file) and select_sample(500, 20, s1) == select_sample(500, 20, s1)
            and len(set(select_sample(500, 20, s1))) == 20 and select_sample(500, 20, s1) == sorted(select_sample(500, 20, s1))
            and len(select_sample(7, 20, 1)) == 7)

    # --- imbuto ---
    rng = np.random.default_rng(7)
    conds = [("bulge", rng.random(1000) < 0.3), ("congestione", rng.random(1000) < 0.4), ("rientro", rng.random(1000) < 0.5)]
    rc = funnel_recount(conds)
    rep = [(nm, cum) for nm, _, cum in rc]
    r = check_funnel(rep, recount=rc, n_signals=rep[-1][1], n_trades=rep[-1][1] - 2, n_skipped=2)
    rec("imbuto coerente (cumulativo, ricalcolo, riconciliazione segnali=trade+scartati) -> SUPERATO", r.status == SUPERATO, r.detail)
    bad = list(rep); bad[1] = (bad[1][0], bad[1][1] + 3)
    r = check_funnel(bad, recount=rc)
    rec("imbuto con conteggio alterato -> FALLITO", r.status == FALLITO, r.detail)
    bad2 = list(rep); bad2[2] = (bad2[2][0], bad2[1][1] + 1)
    r = check_funnel(bad2)
    rec("imbuto con stadio finale > stadio precedente -> FALLITO", r.status == FALLITO, r.detail)
    r = check_funnel(rep, n_signals=rep[-1][1], n_trades=3, n_skipped=2)
    rec("imbuto che non riconcilia segnali = trade + scartati -> FALLITO", r.status == FALLITO, r.detail)

    # --- sovrapposizioni / ingresso barra successiva ---
    T = lambda s: to_minutes(s)
    trades_ok = [{"entry_time": T("2020.01.06 10:00"), "exit_time": T("2020.01.06 12:30"), "signal_time": T("2020.01.06 10:00")},
                 {"entry_time": T("2020.01.06 13:00"), "exit_time": T("2020.01.06 14:00"), "signal_time": T("2020.01.06 13:00")}]
    r = check_no_overlap(trades_ok, signal_key="signal_time")
    rec("nessuna sovrapposizione (trade disgiunti) -> SUPERATO", r.status == SUPERATO, r.detail)
    trades_bad = [dict(trades_ok[0]), {"entry_time": T("2020.01.06 11:00"), "exit_time": T("2020.01.06 14:00"), "signal_time": T("2020.01.06 11:00")}]
    r = check_no_overlap(trades_bad)
    rec("trade che entra con un altro aperto -> FALLITO", r.status == FALLITO, r.detail)
    trades_sig = [dict(trades_ok[0]), {"entry_time": T("2020.01.06 13:00"), "exit_time": T("2020.01.06 14:00"), "signal_time": T("2020.01.06 12:00")}]
    r = check_no_overlap(trades_sig, signal_key="signal_time")
    rec("segnale noto mentre il trade precedente e aperto (ingresso dopo l'uscita) -> FALLITO", r.status == FALLITO, r.detail)
    bt = bars["time"]
    tr_nb = [{"signal_bar_time": int(bt[50]), "entry_time": int(bt[51])}, {"signal_bar_time": int(bt[80]), "entry_time": int(bt[81])}]
    r = check_entry_next_bar(tr_nb, bt)
    rec("ingresso alla barra successiva -> SUPERATO", r.status == SUPERATO, r.detail)
    tr_nb_bad = [{"signal_bar_time": int(bt[50]), "entry_time": int(bt[50])}, {"signal_bar_time": int(bt[80]), "entry_time": int(bt[82])}]
    r = check_entry_next_bar(tr_nb_bad, bt)
    rec("ingresso sulla stessa barra o in ritardo -> FALLITO", r.status == FALLITO and len(r.data["problems"]) == 2, r.detail)

    # --- simulatore: casi a mano ---
    def mk(rows, spread_pts=20.0):
        # rows: (open, high, low, close) ; tempi 10:00, 10:01, ...
        t = np.arange(len(rows), dtype=np.int64) + to_minutes("2020.01.06 10:00")
        arr = np.array(rows, dtype=float)
        return M1(t, arr[:, 0], arr[:, 1], arr[:, 2], arr[:, 3], np.full(len(rows), spread_pts))

    T0 = "2020.01.06 10:00"
    # L1: long, spread 0,20; entry ask 100.20; target 101 colpito alla barra 2 -> pnl 0,80
    mL1 = mk([(100.0, 100.5, 99.8, 100.3), (100.3, 100.9, 100.1, 100.7), (100.7, 101.2, 100.6, 101.0)])
    x = simulate_trade(mL1, {"direction": 1, "entry_time": T0, "stop": 99.0, "target": 101.0})
    rec("sim a mano: long a target, ask 100,20 -> uscita 101,00 pnl +0,80",
        x["exit_reason"] == "target" and x["exit_idx"] == 2 and abs(x["entry_price"] - 100.20) < 1e-9 and abs(x["pnl"] - 0.80) < 1e-9, "pnl=%.4f" % x["pnl"])
    # S1: short; target 99; barra1 low 98.9 -> askL 99.10 > 99 non colpito; barra2 low 98.7 -> askL 98.90 <= 99 colpito
    mS1 = mk([(100.0, 100.3, 99.7, 99.9), (99.9, 100.0, 98.9, 99.0), (99.0, 99.2, 98.7, 98.8)])
    x = simulate_trade(mS1, {"direction": -1, "entry_time": T0, "stop": 101.0, "target": 99.0})
    rec("sim a mano: short, lo spread impedisce il target alla barra 1 e lo concede alla 2 (pnl +1,00)",
        x["exit_reason"] == "target" and x["exit_idx"] == 2 and abs(x["entry_price"] - 100.0) < 1e-9 and abs(x["pnl"] - 1.00) < 1e-9, "idx=%s pnl=%.4f" % (x["exit_idx"], x["pnl"]))
    x = simulate_trade(mS1, {"direction": -1, "entry_time": T0, "stop": 101.0, "target": 99.0}, spread_model="chart_bid_cost")
    rec("sim a mano (chart_bid_cost): short colpisce il target in barra 1 sul grafico, paga lo spread in uscita (pnl +0,80)",
        x["exit_reason"] == "target" and x["exit_idx"] == 1 and abs(x["pnl"] - 0.80) < 1e-9, "idx=%s pnl=%.4f" % (x["exit_idx"], x["pnl"]))
    # stop prima del target nella stessa barra (long): barra 1 tocca sia 98.9 (stop 99) sia 101.5 (target 101)
    mSF = mk([(100.0, 100.4, 99.8, 100.2), (100.2, 101.5, 98.9, 100.0)])
    x = simulate_trade(mSF, {"direction": 1, "entry_time": T0, "stop": 99.0, "target": 101.0})
    rec("stop-first: barra con stop e target -> esce a STOP, both_touched=True, pnl = 99,00-100,20 = -1,20",
        x["exit_reason"] == "stop" and x["both_touched"] and abs(x["pnl"] + 1.20) < 1e-9, "reason=%s pnl=%.4f" % (x["exit_reason"], x["pnl"]))
    # stop-first short
    mSFs = mk([(100.0, 100.2, 99.8, 100.0), (100.0, 101.5, 98.5, 100.0)])
    x = simulate_trade(mSFs, {"direction": -1, "entry_time": T0, "stop": 101.0, "target": 99.0})
    rec("stop-first (short): stop e target nella stessa barra -> STOP, pnl = 100,00-101,00 = -1,00",
        x["exit_reason"] == "stop" and x["both_touched"] and abs(x["pnl"] + 1.00) < 1e-9, "reason=%s pnl=%.4f" % (x["exit_reason"], x["pnl"]))
    # entry bar: stop toccato nella barra di ingresso (check_entry_bar)
    mEB = mk([(100.0, 100.1, 98.5, 99.0), (99.0, 99.5, 98.0, 98.2)])
    x = simulate_trade(mEB, {"direction": 1, "entry_time": T0, "stop": 99.0, "target": 105.0})
    rec("la barra di ingresso e controllata (stop toccato in barra 0, uscita idx 0)", x["exit_idx"] == 0 and x["exit_reason"] == "stop")
    # gap sullo stop: barra 1 apre a 98.50 sotto lo stop 99 -> fill 98,50
    mGP = mk([(100.0, 100.2, 99.9, 100.0), (98.5, 98.9, 98.0, 98.2)])
    x = simulate_trade(mGP, {"direction": 1, "entry_time": T0, "stop": 99.0, "target": 105.0})
    rec("gap oltre lo stop: fill all'open peggiore 98,50 (pnl = 98,50-100,20 = -1,70)", abs(x["exit_price"] - 98.5) < 1e-9 and abs(x["pnl"] + 1.70) < 1e-9, "exit=%.2f" % x["exit_price"])
    # schedule target: aggiornamento effettivo da barra 2 (10:02): target scende a 100.5; barra 2 high 100.6
    mTS = mk([(100.0, 100.2, 99.8, 100.1), (100.1, 100.3, 99.9, 100.2), (100.2, 100.6, 100.0, 100.4)])
    sp = {"direction": 1, "entry_time": T0, "stop": 99.0, "targets": [(T0, 101.0), ("2020.01.06 10:02", 100.5)]}
    x = simulate_trade(mTS, sp)
    rec("target ricalcolato: nuovo livello efficace dalla barra 10:02 -> uscita a target 100,50 in idx 2", x["exit_reason"] == "target" and x["exit_idx"] == 2 and abs(x["exit_price"] - 100.5) < 1e-9)
    sp["targets"] = [(T0, 101.0), ("2020.01.06 10:03", 100.5)]
    x = simulate_trade(mTS, sp)
    rec("target ricalcolato: se il nuovo livello vale dalla barra dopo, NON scatta in idx 2 (fine dati)", x["exit_reason"] == "end_of_data")
    # chiusura forzata: all'open della barra 2 (bid per long: 100.20)
    x = simulate_trade(mTS, {"direction": 1, "entry_time": T0, "stop": 99.0, "target": 110.0, "force_close_time": "2020.01.06 10:02"})
    rec("chiusura forzata all'open della barra: long esce a bid 100,20 pnl 100,20-100,20 = 0 (spread pagato)", x["exit_reason"] == "forced" and abs(x["exit_price"] - 100.2) < 1e-9 and abs(x["pnl"]) < 1e-9, "pnl=%.4f" % x["pnl"])
    x = simulate_trade(mTS, {"direction": -1, "entry_time": T0, "stop": 105.0, "target": 90.0, "force_close_time": "2020.01.06 10:02"})
    rec("chiusura forzata short: entry bid 100,00, uscita ask 100,40 -> pnl -0,40", x["exit_reason"] == "forced" and abs(x["pnl"] + 0.40) < 1e-9, "pnl=%.4f" % x["pnl"])
    # entry con gap: entry_time in un buco -> prima M1 successiva
    x = simulate_trade(mTS, {"direction": 1, "entry_time": "2020.01.06 09:30", "stop": 90.0, "target": 120.0})
    rec("entry_time prima dei dati -> prima M1 disponibile, entry_gap_min riportato", x["entry_idx"] == 0 and x["entry_gap_min"] == 30)

    # --- contabilita spread long vs short: stesso movimento (50 punti), stesso spread -> costi uguali ---
    mU = mk([(100.0, 100.2, 99.9, 100.1), (100.1, 101.1, 100.0, 101.0)])      # sale
    mD = mk([(100.0, 100.1, 99.8, 99.9), (99.9, 100.0, 98.8, 99.0)])          # scende
    xl = simulate_trade(mU, {"direction": 1, "entry_time": T0, "stop": 99.0, "target": 101.0}, spread_model="chart_bid_cost")
    xs = simulate_trade(mD, {"direction": -1, "entry_time": T0, "stop": 101.0, "target": 99.0}, spread_model="chart_bid_cost")
    rec("spread (chart_bid_cost): long e short su movimenti speculari pagano lo stesso costo (pnl uguali = 0,80)", abs(xl["pnl"] - xs["pnl"]) < 1e-9 and abs(xl["pnl"] - 0.80) < 1e-9, "L=%.4f S=%.4f" % (xl["pnl"], xs["pnl"]))

    # --- simmetria del simulatore su 400 trade casuali ---
    # 'executable' e esattamente speculare con specchio bid<->ask (spread variabile per barra).
    # 'chart_bid_cost' e speculare solo a spread COSTANTE (il long paga lo spread all'ingresso, lo short all'uscita).
    rng = np.random.default_rng(99)
    idxs = rng.integers(0, m1.n - 5000, 400)

    def sym_run(model, mode, fixed):
        mm = mirror_m1(m1, mode=mode)
        nbad = nstop = ntgt = nfor = 0
        for i in idxs:
            d = int(rng.choice([-1, 1]))
            et = int(m1.t[i])
            ref = m1.o[i]
            stop = ref - d * 9.0
            tgt = ref + d * rng.uniform(2, 12)
            fc = et + int(rng.integers(30, 3000))
            a = simulate_trade(m1, {"direction": d, "entry_time": et, "stop": stop, "target": tgt, "force_close_time": fc},
                               spread_model=model, fixed_spread_pts=fixed)
            b = simulate_trade(mm, {"direction": -d, "entry_time": et, "stop": -stop, "target": -tgt, "force_close_time": fc},
                               spread_model=model, fixed_spread_pts=fixed)
            same = (a["exit_idx"] == b["exit_idx"] and a["exit_reason"] == b["exit_reason"] and abs(a["pnl"] - b["pnl"]) < 1e-9)
            if model == "executable":
                same = same and abs(a["entry_price"] + b["entry_price"]) < 1e-9
            nbad += (not same)
            nstop += a["exit_reason"] == "stop"
            ntgt += a["exit_reason"] == "target"
            nfor += a["exit_reason"] == "forced"
        return nbad, nstop, ntgt, nfor

    nbad, nstop, ntgt, nfor = sym_run("executable", "bid_ask", None)
    rec("simmetria del simulatore (executable, specchio bid/ask, spread variabile): 400 trade, pnl/uscita identici",
        nbad == 0 and nstop > 10 and ntgt > 10 and nfor > 10, "differenze=%d; uscite stop/target/forzata=%d/%d/%d" % (nbad, nstop, ntgt, nfor))
    nbad, nstop, ntgt, nfor = sym_run("chart_bid_cost", "negate", 25.0)
    rec("simmetria del simulatore (chart_bid_cost, specchio negate, spread costante 25 punti): 400 trade identici",
        nbad == 0 and nstop > 10 and ntgt > 10 and nfor > 10, "differenze=%d; uscite stop/target/forzata=%d/%d/%d" % (nbad, nstop, ntgt, nfor))
    nbad, _, _, _ = sym_run("chart_bid_cost", "negate", None)
    rec("proprieta documentata: chart_bid_cost con spread VARIABILE NON e speculare (il test lo rileva)",
        nbad > 0, "trade non speculari=%d/400" % nbad)

    # --- confronto con un finto "motore" (log) ---
    specs = []
    for i in rng.integers(0, m1.n - 4000, 20):
        d = int(rng.choice([-1, 1])); ref = m1.o[i]
        specs.append({"direction": d, "entry_time": int(m1.t[i]), "stop": ref - d * 8, "target": ref + d * 5, "force_close_time": int(m1.t[i]) + 2000})
    recalc = recalc_trades(m1, specs)
    log = [{"entry_time": r["entry_time"], "entry_price": r["entry_price"], "exit_time": r["exit_time"], "exit_price": r["exit_price"],
            "exit_reason": {"stop": "SL", "target": "TP", "forced": "forced", "end_of_data": "end"}[r["exit_reason"]], "pnl": r["pnl"]} for r in recalc]
    r = compare_with_engine(log, recalc)
    rec("confronto log/ricalcolo su 20 trade identici -> SUPERATO", r.status == SUPERATO, r.detail)
    log_bad = copy.deepcopy(log); log_bad[3]["pnl"] += 0.05
    r = compare_with_engine(log_bad, recalc)
    rec("log con un pnl alterato di 0,05 -> FALLITO", r.status == FALLITO, r.detail)
    log_bad2 = copy.deepcopy(log); log_bad2[5]["exit_reason"] = "TP" if log_bad2[5]["exit_reason"] != "TP" else "SL"
    r = compare_with_engine(log_bad2, recalc)
    rec("log con motivo di uscita alterato -> FALLITO", r.status == FALLITO, r.detail)
    sm = summarize_pnls([x["pnl"] for x in recalc])
    r = compare_summary(sm, dict(sm))
    rec("compare_summary n/wins/PF identici -> SUPERATO", r.status == SUPERATO)
    sm2 = dict(sm); sm2["pf"] = sm["pf"] * 1.01
    r = compare_summary(sm, sm2)
    rec("compare_summary con PF diverso dell'1% -> FALLITO", r.status == FALLITO)
    # statistiche a mano: pnl [2,-1,3,-1,0.5] -> n=5 wins=3 gp=5.5 gl=2 pf=2.75
    s = summarize_pnls([2, -1, 3, -1, 0.5])
    rec("summarize_pnls a mano (n=5, wins=3, PF=2,75)", s["n"] == 5 and s["wins"] == 3 and abs(s["pf"] - 2.75) < 1e-12 and abs(s["win_rate"] - 0.6) < 1e-12)
    tr = trace_trade(m1, recalc[0], specs[0])
    rec("trace_trade produce una tabella per la ricostruzione a mano", "<-ingresso" in tr and "pnl=" in tr)

    n_ok = sum(1 for _, ok in results if ok)
    if verbose:
        print("\nAUTO-TEST: %d/%d controlli riusciti in %.1f s - ESITO GLOBALE: %s" %
              (n_ok, len(results), _time.time() - t0, SUPERATO if n_ok == len(results) else FALLITO))
    return n_ok == len(results), results


def main(argv):
    if len(argv) >= 3 and argv[1] == "--sha256":
        print(sha256_file(argv[2]))
        return 0
    ok, _ = selftest(verbose=True)
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main(sys.argv))
