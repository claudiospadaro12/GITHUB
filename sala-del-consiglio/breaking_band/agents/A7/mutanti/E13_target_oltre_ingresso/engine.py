"""Motore di simulazione generico per Breaking Band (R003, A4).

Solo libreria standard + numpy. NON contiene le regole del pattern (arrivano da A2):
fornisce dati M1 -> barre H1/M15 -> indicatori (senza look-ahead) -> simulazione di un
trade dato un segnale -> filtro "una posizione alla volta" -> statistiche.

Convenzioni (tutte dichiarate, vedi README.md):
- I prezzi dei CSV sono BID. ask = bid + spread. spread in punti, 1 punto = 0,01 USD.
- Tempo: minuti interi dall'epoca (int64), come nel CSV (ora server, nessuna conversione).
- Un segnale alla chiusura della barra j -> ingresso all'apertura della PRIMA M1 della barra j+1.
- Long: entra ask (open + spread), esce a bid. Short: entra bid (open), esce ask (bid + spread).
- Stop a stop_atr * ATR(j) dal prezzo di ingresso (non muove). Target = SMA20(j), poi
  ricalcolata alla chiusura delle barre j+r, j+2r, ... (r = ricalcolo_ogni, default 3) e attiva
  dalla M1 successiva.
- Minuto per minuto: SL controllato PRIMA di TP nello stesso minuto.
- Fill (specifica_v1 sez. 6.7): lo STOP si riempie all'apertura del minuto se questa e' gia oltre il
  livello (gap, peggiore); il TARGET si riempie SEMPRE AL LIVELLO (nessun miglioramento di prezzo;
  opzione target_gap_improve=True solo per confronto con il vecchio comportamento).
- Target ricalcolato che risulta GIA superato dal prezzo all'apertura della M1 successiva al ricalcolo:
  uscita a mercato a quell'apertura, motivo 'MKT' (specifica sez. 6.4b), classificata dal P&L.
- Chiusura forzata dopo maxhold barre (da params.MAXHOLD = 1000; 150 e' la sensibilita Sc): motivo 'TF'.
  Se i dati finiscono prima: 'FINE_DATI'.
- Tutti i valori di default vengono da params.py (unica fonte).
"""
from __future__ import annotations

import math
from dataclasses import dataclass, field

import numpy as np
from numpy.lib.stride_tricks import sliding_window_view

from params import PARAMS as _P, ricalcolo_barre as _ricalcolo_barre

PUNTO_DEFAULT = _P["PUNTO"]
COLONNE = ["time", "open", "high", "low", "close", "tickvol", "spread"]


# --------------------------------------------------------------------------- dati

@dataclass
class M1:
    t: np.ndarray    # int64, minuti dall'epoca
    o: np.ndarray    # float64 (bid)
    h: np.ndarray
    l: np.ndarray
    c: np.ndarray
    tv: np.ndarray   # int64
    sp: np.ndarray   # float64, spread in PUNTI
    info: dict = field(default_factory=dict)
    sp_sost: np.ndarray | None = None   # bool: True dove lo spread 0 e' stato sostituito (sostituisci_spread_zero)

    @property
    def n(self) -> int:
        return int(self.t.size)


def costruisci_m1(t, o, h, l, c, sp, tv=None) -> M1:
    """Costruisce un M1 da array (utile per dati sintetici). t in minuti dall'epoca."""
    t = np.asarray(t, dtype=np.int64)
    n = t.size
    return M1(
        t=t,
        o=np.asarray(o, dtype=np.float64),
        h=np.asarray(h, dtype=np.float64),
        l=np.asarray(l, dtype=np.float64),
        c=np.asarray(c, dtype=np.float64),
        tv=np.zeros(n, dtype=np.int64) if tv is None else np.asarray(tv, dtype=np.int64),
        sp=np.asarray(sp, dtype=np.float64),
        info={},
    )


def carica(path: str) -> M1:
    """Carica un CSV M1 `time;open;high;low;close;tickvol;spread` (time 'YYYY.MM.DD HH:MM').

    Righe malformate scartate e contate in info. Se i timestamp non sono strettamente crescenti
    si ordina (stabile) e si eliminano i duplicati (si tiene il primo): conteggi in info.
    """
    ts, o, h, l, c, tv, sp = [], [], [], [], [], [], []
    scartate = 0
    letti = 0
    with open(path, "r", encoding="utf-8-sig", errors="replace") as f:
        intest = f.readline().strip().lower().split(";")
        if intest != COLONNE:
            raise ValueError(f"intestazione inattesa: {intest}")
        for ln in f:
            ln = ln.strip()
            if not ln:
                continue
            letti += 1
            p = ln.split(";")
            if len(p) != 7:
                scartate += 1
                continue
            s = p[0]
            if not (len(s) >= 16 and s[4] == "." and s[7] == "." and s[10] == " " and s[13] == ":"):
                scartate += 1
                continue
            try:
                vals = (float(p[1]), float(p[2]), float(p[3]), float(p[4]), int(float(p[5])), float(p[6]))
            except ValueError:
                scartate += 1
                continue
            if not all(math.isfinite(v) for v in vals):
                scartate += 1
                continue
            ts.append(s[0:4] + "-" + s[5:7] + "-" + s[8:10] + "T" + s[11:16])
            o.append(vals[0]); h.append(vals[1]); l.append(vals[2]); c.append(vals[3])
            tv.append(vals[4]); sp.append(vals[5])
    try:
        tm = np.array(ts, dtype="datetime64[m]").astype(np.int64)
    except ValueError as e:
        raise ValueError(f"timestamp non valido in {path}: {e}")
    arr = [np.array(x, dtype=np.float64) for x in (o, h, l, c)]
    tvv = np.array(tv, dtype=np.int64)
    spv = np.array(sp, dtype=np.float64)
    disordinati = 0
    duplicati = 0
    if tm.size > 1 and np.any(np.diff(tm) <= 0):
        disordinati = int(np.sum(np.diff(tm) < 0))
        ordine = np.argsort(tm, kind="stable")
        tm = tm[ordine]; arr = [a[ordine] for a in arr]; tvv = tvv[ordine]; spv = spv[ordine]
        keep = np.concatenate(([True], np.diff(tm) > 0))
        duplicati = int(np.sum(~keep))
        tm = tm[keep]; arr = [a[keep] for a in arr]; tvv = tvv[keep]; spv = spv[keep]
    o_, h_, l_, c_ = arr
    incoerenti = int(np.sum((h_ < l_) | (o_ > h_) | (o_ < l_) | (c_ > h_) | (c_ < l_)))
    info = {
        "path": path,
        "righe_lette": letti,
        "righe_scartate_formato": scartate,
        "salti_indietro_nel_tempo": disordinati,
        "duplicati_rimossi": duplicati,
        "righe_ohlc_incoerenti": incoerenti,
        "righe_finali": int(tm.size),
    }
    return M1(t=tm, o=o_, h=h_, l=l_, c=c_, tv=tvv, sp=spv, info=info)


def sostituisci_spread_zero(m1: M1) -> M1:
    """Specifica sez. 6.9: spread == 0 -> MEDIANA degli spread non nulli dello STESSO periodo (il file) e
    della STESSA ora server (ora = (t // 60) % 24). Se per un'ora non esiste nessuno spread non nullo
    si usa la mediana di tutti gli spread non nulli del periodo. Ritorna un NUOVO M1 (l'originale non
    cambia) con la maschera `sp_sost`; il conteggio e' in info['spread0_sostituiti']."""
    sp = m1.sp.copy()
    zero = sp == 0
    ore = ((m1.t // 60) % 24).astype(np.int64)
    nz = ~zero
    mediana_tot = float(np.median(sp[nz])) if nz.any() else 0.0
    if zero.any():
        for h in range(24):
            sel = zero & (ore == h)
            if not sel.any():
                continue
            ok = nz & (ore == h)
            sp[sel] = float(np.median(m1.sp[ok])) if ok.any() else mediana_tot
    info = dict(m1.info)
    info["spread0_sostituiti"] = int(zero.sum())
    return M1(t=m1.t, o=m1.o, h=m1.h, l=m1.l, c=m1.c, tv=m1.tv, sp=sp, info=info, sp_sost=zero)


def scala_spread(m1: M1, k: float) -> M1:
    """Copia di m1 con spread moltiplicato per k (sensibilita Sd: x1,5)."""
    return M1(t=m1.t, o=m1.o, h=m1.h, l=m1.l, c=m1.c, tv=m1.tv, sp=m1.sp * k, info=dict(m1.info),
              sp_sost=m1.sp_sost)


# --------------------------------------------------------------------------- barre

@dataclass
class Barre:
    periodo: int          # minuti (60 = H1, 15 = M15)
    t: np.ndarray         # int64, minuto di inizio nominale della barra
    o: np.ndarray
    h: np.ndarray
    l: np.ndarray
    c: np.ndarray
    tv: np.ndarray
    i0: np.ndarray        # indice della PRIMA M1 della barra
    i1: np.ndarray        # indice ESCLUSO (ultima M1 = i1-1)

    @property
    def n(self) -> int:
        return int(self.t.size)


def costruisci_barre(m1: M1, periodo_min: int) -> Barre:
    """Aggrega M1 in barre da `periodo_min` minuti. Una barra esiste solo se ha almeno una M1;
    gli indici delle barre sono consecutivi sulle barre ESISTENTI (i buchi di calendario non
    producono barre vuote). open = open prima M1; close = close ultima M1."""
    n = m1.n
    if n == 0:
        raise ValueError("M1 vuoto")
    key = m1.t // periodo_min
    cambi = np.flatnonzero(key[1:] != key[:-1]) + 1
    i0 = np.concatenate(([0], cambi)).astype(np.int64)
    i1 = np.concatenate((cambi, [n])).astype(np.int64)
    return Barre(
        periodo=int(periodo_min),
        t=key[i0] * periodo_min,
        o=m1.o[i0],
        h=np.maximum.reduceat(m1.h, i0),
        l=np.minimum.reduceat(m1.l, i0),
        c=m1.c[i1 - 1],
        tv=np.add.reduceat(m1.tv, i0),
        i0=i0,
        i1=i1,
    )


# --------------------------------------------------------------------------- indicatori

@dataclass
class Indicatori:
    """Array allineati alle barre; NaN dove non ancora definiti. Il valore all'indice i usa
    SOLO barre <= i. Nomi riferiti ai parametri di default (20/2/50/14)."""
    sma20: np.ndarray
    std20: np.ndarray        # deviazione standard di POPOLAZIONE (ddof=0) delle ultime 20 chiusure
    bb_up: np.ndarray        # sma20 + 2*std20
    bb_lo: np.ndarray        # sma20 - 2*std20
    std20_sma50: np.ndarray  # SMA a 50 barre di std20
    atr14: np.ndarray
    params: dict = field(default_factory=dict)


def _rolling_mean_std(x: np.ndarray, n: int, ddof: int = 0):
    out_m = np.full(x.size, np.nan)
    out_s = np.full(x.size, np.nan)
    if x.size >= n:
        w = sliding_window_view(x, n)
        out_m[n - 1:] = w.mean(axis=1)
        out_s[n - 1:] = w.std(axis=1, ddof=ddof)  # ddof=0: popolazione (params.SD_DDOF)
    return out_m, out_s


def true_range(barre: Barre) -> np.ndarray:
    tr = barre.h - barre.l
    if barre.n > 1:
        pc = barre.c[:-1]
        tr[1:] = np.maximum(tr[1:], np.maximum(np.abs(barre.h[1:] - pc), np.abs(barre.l[1:] - pc)))
    return tr


def atr(barre: Barre, n: int = _P["ATR_N"], metodo: str = _P["ATR_METODO"]) -> np.ndarray:
    """ATR. metodo='wilder' (default): seme = media semplice di TR[1..n] all'indice n, poi
    ATR[i] = (ATR[i-1]*(n-1) + TR[i]) / n. metodo='semplice': media mobile semplice di TR[i-n+1..i]
    (primo valore valido all'indice n, per coerenza con Wilder). TR[0] (senza chiusura
    precedente) non e usato."""
    if metodo not in ("wilder", "semplice"):
        raise ValueError("metodo ATR: 'wilder' o 'semplice'")
    tr = true_range(barre)
    out = np.full(barre.n, np.nan)
    if barre.n <= n:
        return out
    if metodo == "wilder":
        a = float(np.mean(tr[1:n + 1]))
        out[n] = a
        for i in range(n + 1, barre.n):
            a = (a * (n - 1) + tr[i]) / n
            out[i] = a
    else:
        w = sliding_window_view(tr[1:], n)
        out[n:] = w.mean(axis=1)
    return out


def indicatori(barre: Barre, bb_n: int = _P["BB_N"], bb_k: float = _P["BB_K"], std_sma_n: int = _P["S50_N"],
               atr_n: int = _P["ATR_N"], atr_metodo: str = _P["ATR_METODO"], ddof: int = _P["SD_DDOF"]) -> Indicatori:
    sma, sd = _rolling_mean_std(barre.c, bb_n, ddof)
    sd_sma = np.full(barre.n, np.nan)
    ok = barre.n - (bb_n - 1)
    if ok >= std_sma_n:
        w = sliding_window_view(sd[bb_n - 1:], std_sma_n)
        sd_sma[bb_n - 1 + std_sma_n - 1:] = w.mean(axis=1)
    return Indicatori(
        sma20=sma, std20=sd, bb_up=sma + bb_k * sd, bb_lo=sma - bb_k * sd,
        std20_sma50=sd_sma, atr14=atr(barre, atr_n, atr_metodo),
        params=dict(bb_n=bb_n, bb_k=bb_k, std_sma_n=std_sma_n, atr_n=atr_n, atr_metodo=atr_metodo),
    )


# --------------------------------------------------------------------------- simulazione

def _lato(side) -> int:
    if side in (1, "L", "l", "long", "LONG", "buy", "BUY"):
        return 1
    if side in (-1, "S", "s", "short", "SHORT", "sell", "SELL"):
        return -1
    raise ValueError(f"lato non valido: {side!r}")


def _scarto(j, s, codice):
    return {"eseguito": False, "scarto": codice, "j": int(j), "side": s}


def simula_trade(m1: M1, barre: Barre, ind: Indicatori, j: int, side, stop_atr: float = _P["STOP_ATR"],
                 maxhold: int = _P["MAXHOLD"], ricalcolo_ogni="auto", punto: float = PUNTO_DEFAULT,
                 max_gap_ingresso_min: float | None = _P["MAX_GAP_INGRESSO_MIN"],
                 target_gap_improve: bool = _P["FILL_TARGET_MIGLIORE"]) -> dict:
    """Simula UN trade da un segnale alla chiusura della barra j. Vedi docstring del modulo.

    ricalcolo_ogni: 'auto' = params.RICALCOLO_ORE ore (H1 -> 3 barre, M30 -> 6); intero = barre;
    None/0 = target fisso.

    Ritorna un dict. Se non eseguito: {'eseguito': False, 'scarto': CODICE, ...} con CODICE in
    NO_BARRA_SUCCESSIVA, INDICATORI_NON_PRONTI, GAP_INGRESSO, TARGET_OLTRE_INGRESSO.
    Se eseguito: eseguito=True, j, side, entry_m1, entry_time, entry, stop, target0, target_finale,
    n_agg_target, targets (SCHEDULE completa [(minuto_da_cui_vale, livello), ...], la prima voce e il
    target iniziale valido dalla M1 di ingresso), rischio (D in USD), exit_m1, exit_time, exit,
    motivo ('SL'|'TP'|'MKT'|'TF'|'FINE_DATI'), R (netto), R_lordo (senza spread), costo_spread_R,
    durata_barre, durata_minuti, bar_ingresso, bar_uscita, gap_ingresso_min, sl_e_tp_stesso_minuto,
    spread0_ingresso / spread0_uscita (spread sostituito da sostituisci_spread_zero), spread_ingresso
    (USD), atr (ATR della barra segnale).
    """
    s = _lato(side)
    if maxhold < 1:
        raise ValueError("maxhold >= 1")
    nb = barre.n
    if not (0 <= j < nb):
        raise IndexError("j fuori dalle barre")
    if j + 1 >= nb:
        return _scarto(j, s, "NO_BARRA_SUCCESSIVA")
    atr_j = float(ind.atr14[j])
    sma_j = float(ind.sma20[j])
    if not (math.isfinite(atr_j) and atr_j > 0 and math.isfinite(sma_j)):
        return _scarto(j, s, "INDICATORI_NON_PRONTI")
    e = int(barre.i0[j + 1])
    gap = int(m1.t[e] - (barre.t[j] + barre.periodo))
    if max_gap_ingresso_min is not None and gap > max_gap_ingresso_min:
        return _scarto(j, s, "GAP_INGRESSO")
    sp_e = float(m1.sp[e]) * punto
    entry = float(m1.o[e]) + (sp_e if s == 1 else 0.0)
    if False:
        return _scarto(j, s, "TARGET_OLTRE_INGRESSO")
    D = stop_atr * atr_j
    stop = entry - s * D
    target = sma_j
    targets = [(int(m1.t[e]), float(target))]
    kend = min(j + maxhold, nb - 1)
    if ricalcolo_ogni == "auto":
        r = _ricalcolo_barre(barre.periodo)
    else:
        r = int(ricalcolo_ogni) if ricalcolo_ogni else 0

    x = None          # indice M1 di uscita
    fill = None
    motivo = None
    sp_x = 0.0        # spread (USD) alla M1 di uscita
    both = False
    n_agg = 0
    bar_a = j + 1
    while bar_a <= kend:
        m = 0
        if r:
            m = (bar_a - 1 - j) // r
            bar_b = min(j + r * (m + 1), kend)
        else:
            bar_b = kend
        a = int(barre.i0[bar_a])
        b = int(barre.i1[bar_b])
        if m > 0:
            v = float(ind.sma20[j + r * m])
            if math.isfinite(v):
                target = v
                n_agg += 1
                targets.append((int(m1.t[a]), float(target)))
                # target ricalcolato gia superato dal prezzo all'apertura: uscita a mercato (sez. 6.4b)
                sp_a = float(m1.sp[a]) * punto
                passato = (float(m1.o[a]) >= target) if s == 1 else (float(m1.o[a]) + sp_a <= target)
                if passato:
                    x = a
                    sp_x = sp_a
                    motivo = "MKT"
                    fill = float(m1.o[a]) + (0.0 if s == 1 else sp_a)
                    break
        o_s, h_s, l_s = m1.o[a:b], m1.h[a:b], m1.l[a:b]
        sp_s = m1.sp[a:b] * punto
        if s == 1:
            sl_hit = l_s <= stop
            tp_hit = h_s >= target
        else:
            sl_hit = (h_s + sp_s) >= stop
            tp_hit = (l_s + sp_s) <= target
        qualsiasi = sl_hit | tp_hit
        if qualsiasi.any():
            k = int(np.argmax(qualsiasi))
            x = a + k
            sp_x = float(sp_s[k])
            if sl_hit[k]:                       # SL prima di TP nello stesso minuto
                motivo = "SL"
                both = bool(tp_hit[k])
                fill = min(stop, float(o_s[k])) if s == 1 else max(stop, float(o_s[k] + sp_s[k]))
            else:
                motivo = "TP"
                if target_gap_improve:
                    fill = max(target, float(o_s[k])) if s == 1 else min(target, float(o_s[k] + sp_s[k]))
                else:
                    fill = float(target)         # AL LIVELLO (sez. 6.7)
            break
        bar_a = bar_b + 1

    if x is None:
        x = int(barre.i1[kend]) - 1
        sp_x = float(m1.sp[x]) * punto
        fill = float(m1.c[x]) + (0.0 if s == 1 else sp_x)
        motivo = "TF" if kend == j + maxhold else "FINE_DATI"

    R = s * (fill - entry) / D
    costo = (sp_e if s == 1 else sp_x) / D
    bar_x = int(np.searchsorted(barre.i0, x, side="right") - 1)
    z0 = m1.sp_sost
    return {
        "eseguito": True, "j": int(j), "side": s,
        "entry_m1": e, "entry_time": int(m1.t[e]), "entry": entry, "stop": stop,
        "target0": sma_j, "target_finale": target, "n_agg_target": n_agg, "targets": targets,
        "rischio": D, "atr": atr_j, "spread_ingresso": sp_e,
        "exit_m1": int(x), "exit_time": int(m1.t[x]), "exit": float(fill), "motivo": motivo,
        "R": float(R), "R_lordo": float(R + costo), "costo_spread_R": float(costo),
        "bar_ingresso": j + 1, "bar_uscita": bar_x,
        "durata_barre": bar_x - (j + 1) + 1, "durata_minuti": int(m1.t[x] - m1.t[e]),
        "gap_ingresso_min": gap, "sl_e_tp_stesso_minuto": both,
        "spread0_ingresso": bool(z0[e]) if z0 is not None else False,
        "spread0_uscita": bool(z0[x]) if z0 is not None else False,
    }


def esegui_segnali(m1: M1, barre: Barre, ind: Indicatori, segnali, **kw):
    """Filtra una lista di segnali in ordine di barra e li simula UNO ALLA VOLTA.

    segnali: iterabile di (j, side) oppure (j, side, dict_di_override_per_simula_trade).
    Un segnale e scartato se alla M1 di ingresso (prima M1 della barra j+1) c'e ancora una
    posizione aperta (uscita >= ingresso). Ritorna (trades, contatori).
    contatori: segnali, eseguiti, scartati_posizione_aperta, scartati_target_oltre_ingresso,
    scartati_indicatori_non_pronti, scartati_no_barra_successiva, scartati_gap_ingresso.
    """
    cont = {
        "segnali": 0, "eseguiti": 0, "scartati_posizione_aperta": 0,
        "scartati_target_oltre_ingresso": 0, "scartati_indicatori_non_pronti": 0,
        "scartati_no_barra_successiva": 0, "scartati_gap_ingresso": 0,
    }
    mappa = {
        "TARGET_OLTRE_INGRESSO": "scartati_target_oltre_ingresso",
        "INDICATORI_NON_PRONTI": "scartati_indicatori_non_pronti",
        "NO_BARRA_SUCCESSIVA": "scartati_no_barra_successiva",
        "GAP_INGRESSO": "scartati_gap_ingresso",
    }
    norm = []
    for sg in segnali:
        extra = sg[2] if len(sg) > 2 else {}
        norm.append((int(sg[0]), sg[1], extra))
    norm.sort(key=lambda z: z[0])  # sort stabile: ordine di barra
    trades = []
    ultima_uscita = -1
    for j, side, extra in norm:
        cont["segnali"] += 1
        if j + 1 < barre.n and int(barre.i0[j + 1]) <= ultima_uscita:
            cont["scartati_posizione_aperta"] += 1
            continue
        args = dict(kw)
        args.update(extra)
        t = simula_trade(m1, barre, ind, j, side, **args)
        if not t["eseguito"]:
            cont[mappa[t["scarto"]]] += 1
            continue
        cont["eseguiti"] += 1
        trades.append(t)
        ultima_uscita = t["exit_m1"]
    return trades, cont


# --------------------------------------------------------------------------- statistiche

def statistiche(trades) -> dict:
    """n, win%, PF netto (e lordo), netto R, costo spread R, media vincita/perdita R, drawdown
    massimo in R (curva cumulata dei R in ordine di ingresso, parte da 0), conteggio per motivo."""
    n = len(trades)
    motivi: dict = {}
    for t in trades:
        motivi[t["motivo"]] = motivi.get(t["motivo"], 0) + 1
    if n == 0:
        return {"n": 0, "win_pct": float("nan"), "pf_netto": float("nan"), "pf_lordo": float("nan"),
                "netto_R": 0.0, "lordo_R": 0.0, "costo_spread_R": 0.0, "attesa_R": float("nan"),
                "media_vincita_R": float("nan"), "media_perdita_R": float("nan"),
                "dd_max_R": 0.0, "per_motivo": motivi}
    ordine = sorted(trades, key=lambda t: t["entry_m1"])
    R = np.array([t["R"] for t in ordine], dtype=np.float64)
    Rl = np.array([t["R_lordo"] for t in ordine], dtype=np.float64)
    costo = np.array([t["costo_spread_R"] for t in ordine], dtype=np.float64)
    vinc = R[R > 0]
    perd = R[R < 0]

    def pf(x):
        g = float(x[x > 0].sum())
        p = float(-x[x < 0].sum())
        if p == 0:
            return float("inf") if g > 0 else float("nan")
        return g / p

    eq = np.concatenate(([0.0], np.cumsum(R)))
    dd = float(np.max(np.maximum.accumulate(eq) - eq))
    return {
        "n": n,
        "win_pct": 100.0 * vinc.size / n,
        "pf_netto": pf(R),
        "pf_lordo": pf(Rl),
        "netto_R": float(R.sum()),
        "lordo_R": float(Rl.sum()),
        "costo_spread_R": float(costo.sum()),
        "attesa_R": float(R.mean()),
        "media_vincita_R": float(vinc.mean()) if vinc.size else float("nan"),
        "media_perdita_R": float(perd.mean()) if perd.size else float("nan"),
        "dd_max_R": dd,
        "per_motivo": motivi,
    }
