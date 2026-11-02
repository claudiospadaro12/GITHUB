#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""agg_indipendente.py - riscrittura da zero (A7, ciclo 2) del calcolo dei criteri 1-5 e del verdetto di
congelati/criteri_conferma_forex_v1.md + D010, leggendo SOLO il documento dei criteri e il formato dei JSON di run_test.py.
NON legge CSV. Non ha visto agents/A4/agg_conferma.py quando e stato scritto.

LETTURE ADOTTATE (dichiarate; D010 conferma quelle marcate [D010]):
  - trade = tutte le voci LOG_TRADE 'CONT_H1_<periodo>' e 'INV_H1_<periodo>' delle 4 coppie (H1 primario, CONT+INV pooled);
  - win rate = quota di trade con R > 0 ; pareggio atteso medio = 100 * media_i[(S + c_i)/(S + D_i)] con S = STOP_ATR (3),
    D_i = 'D_atr', c_i = 'c_atr' dal log dei trade [D010: pareggio con costo dal log];
  - IC90: bootstrap a blocchi settimanali, 10.000 replicati, blocco = settimana di ingresso (int((entry_time//1440+3)//7)),
    CONDIVISO fra le coppie [D010], media del replicato = somma R / numero trade dei blocchi estratti, percentili 5 e 95
    (numpy 'linear'), seme 20261101 (stesso di run_test; il documento non lo fissa -> verificato per sensibilita);
  - leave-one-pair-out = media semplice dei trade rimasti [D010]; costo extra = media R - 0,05 [D010];
  - verdetto: N<30 INCONCLUSIVO; tutte le condizioni 2-5 -> CONFERMATO; altrimenti IC90 sup < +0,05 -> NESSUN VANTAGGIO RILEVANTE
    (prevale su NON DIMOSTRATO anche se l'IC contiene 0 [D010]); altrimenti NON DIMOSTRATO (resto: anche IC>0 ma una condizione 3-5 falsa).
  - integrita: sha256_risultati ricalcolato (JSON canonico) = dichiarato; sha256_codice = HASH_CODICE_V2; PARAMETRI_NON_CONGELATI_PROVA falso;
    simbolo atteso e una sola volta ciascuna delle 4 coppie; periodi del LOG = anni attesi; tf contiene H1; hash_dati_coincidono tutti veri.
"""
import copy, hashlib, json, math, os
import numpy as np

COPPIE = ("EURUSD", "GBPUSD", "USDJPY", "EURJPY")
ANNI = ("2015", "2017", "2019", "2022")
SEED, N_BOOT, ALPHA = 20261101, 10000, 0.05
EXTRA, EPS, N_MIN, PP = 0.05, 0.05, 30, 5.0


def _pulisci(x):
    if isinstance(x, dict): return {str(k): _pulisci(v) for k, v in x.items()}
    if isinstance(x, (list, tuple)): return [_pulisci(v) for v in x]
    if isinstance(x, float):
        if math.isnan(x): return None
        if math.isinf(x): return "inf" if x > 0 else "-inf"
    return x


def canon(o):
    return json.dumps(_pulisci(o), sort_keys=True, ensure_ascii=True, allow_nan=False, separators=(",", ":"))


def hash_risultati(j):
    d = {k: v for k, v in j.items() if k != "sha256_risultati"}
    return hashlib.sha256(canon(d).encode()).hexdigest()


def leggi_hash_codice(path):
    out = {}
    for ln in open(path):
        p = ln.split()
        if len(p) == 2: out[p[1]] = p[0]
    return out


def integrita(j, sym_dichiarato, hash_codice, anni=ANNI):
    """Restituisce lista (nome, ok, dettaglio)."""
    I = j.get("intestazione", {}); T = j.get("tabelle", {}); r = []
    r.append(("sha256_risultati_ricalcolato", j.get("sha256_risultati") == hash_risultati(j), ""))
    cod = I.get("sha256_codice", {})
    r.append(("codice_uguale_v2", all(cod.get(k) == v for k, v in hash_codice.items() if k in ("engine.py", "signals.py", "params.py", "run_test.py")) and
              all(k in cod for k in ("engine.py", "signals.py", "params.py", "run_test.py")), ""))
    r.append(("non_prova", I.get("PARAMETRI_NON_CONGELATI_PROVA") is False, ""))
    r.append(("simbolo_coerente", I.get("simbolo") == sym_dichiarato, "%s vs %s" % (I.get("simbolo"), sym_dichiarato)))
    pers = sorted({k.split("_", 2)[2] for k in T.get("LOG_TRADE", {})})
    r.append(("periodi_attesi", pers == sorted(anni), str(pers)))
    r.append(("tf_H1_M30", I.get("tf") == ["H1", "M30"], str(I.get("tf"))))
    hd = I.get("hash_dati_coincidono")
    r.append(("hash_dati_coincidono", isinstance(hd, dict) and len(hd) > 0 and all(v is True for v in hd.values()), str(hd)))
    return r


def trade_h1(j):
    out = []
    for k, lst in j["tabelle"]["LOG_TRADE"].items():
        var, tf, per = k.split("_", 2)
        if tf == "H1":
            for t in lst:
                out.append(dict(t, _var=var, _per=per))
    return out


def settimana(t):
    return int((int(t["entry_time"]) // 1440 + 3) // 7)


def bootstrap_condiviso(trades, seed=SEED, n_boot=N_BOOT):
    sett = sorted({settimana(t) for t in trades}); idx = {w: k for k, w in enumerate(sett)}
    somma = np.zeros(len(sett)); cnt = np.zeros(len(sett))
    for t in trades:
        k = idx[settimana(t)]; somma[k] += t["R"]; cnt[k] += 1
    rng = np.random.default_rng(seed); K = len(sett)
    sel = rng.integers(0, K, size=(n_boot, K)); m = somma[sel].sum(axis=1) / cnt[sel].sum(axis=1)
    lo, hi = np.quantile(m, [ALPHA, 1 - ALPHA])
    return float(lo), float(hi), K


def calcola(per_coppia, stop=3.0, seed=SEED):
    """per_coppia: {sym: json}. Ritorna dict con condizioni ed esito."""
    tr = []
    for sym, j in per_coppia.items():
        for t in trade_h1(j): tr.append(dict(t, _sym=sym))
    N = len(tr); R = np.array([t["R"] for t in tr], dtype=float)
    res = {"N": N}
    if N == 0:
        res.update(esito="INCONCLUSIVO", condizioni={"1": False}); return res
    mean = float(R.mean()); wr = 100.0 * float((R > 0).mean())
    pareggio = 100.0 * float(np.mean([(stop + t["c_atr"]) / (stop + t["D_atr"]) for t in tr]))
    lo, hi, K = bootstrap_condiviso(tr, seed)
    lopo = {s: float(np.mean([t["R"] for t in tr if t["_sym"] != s])) for s in per_coppia if any(t["_sym"] != s for t in tr)}
    cond = {"1": N >= N_MIN, "2": bool(mean > 0 and lo > 0), "3": bool(wr >= pareggio + PP), "4": bool(all(v > 0 for v in lopo.values())), "5": bool(mean - EXTRA > 0)}
    if not cond["1"]: esito = "INCONCLUSIVO"
    elif all(cond.values()): esito = "CONFERMATO"
    elif hi < EPS: esito = "NESSUN VANTAGGIO RILEVANTE"
    else: esito = "NON DIMOSTRATO"
    alt = "INCONCLUSIVO" if not cond["1"] else ("CONFERMATO" if all(cond.values()) else ("NON DIMOSTRATO" if lo <= 0 <= hi else ("NESSUN VANTAGGIO RILEVANTE" if hi < EPS else "NON DIMOSTRATO")))
    res.update(media=mean, win_rate_pct=wr, pareggio_pct=pareggio, soglia_wr=pareggio + PP, ic90=(lo, hi), settimane=K, lopo=lopo,
               media_con_costo=mean - EXTRA, condizioni=cond, esito=esito, esito_lettura_alternativa=alt)
    return res
