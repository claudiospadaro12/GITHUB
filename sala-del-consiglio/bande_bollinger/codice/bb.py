"""Bande di Bollinger 37/3 + S/R su indici — implementazione di specifica_v1.md (C0).
Solo libreria standard + numpy. Nessun accesso a risultati: le regole sono quelle congelate."""
from __future__ import annotations
import numpy as np

SHIFT_MIN = 60  # i _EXT sono 1h indietro rispetto al server BCM
DEF = dict(PERIOD=37, NSIGMA=3.0, ATR_N=14, TOL=0.5, K=1.5, MAXHOLD=100, SPREAD_BP=1.0,
           SPREAD_MULT=1.0, TF=60, FILTRO=True, SR=True, MAXGAP=None, SHIFT_SR=None)


def carica(path):
    rows = []
    with open(path) as f:
        next(f)
        for ln in f:
            p = ln.rstrip("\n").split(";")
            if len(p) < 5:
                continue
            ymd, hm = p[0].split(" ")
            y, mo, d = ymd.split(".")
            h, mi = hm.split(":")
            dt = np.datetime64(f"{y}-{mo}-{d}T{h}:{mi}")
            rows.append((int(dt.astype("datetime64[m]").astype(np.int64)), float(p[1]), float(p[2]), float(p[3]), float(p[4])))
    a = np.array(rows, dtype=np.float64)
    t = a[:, 0].astype(np.int64) + SHIFT_MIN
    return dict(t=t, o=a[:, 1], h=a[:, 2], l=a[:, 3], c=a[:, 4])


def concat(parts):
    return {k: np.concatenate([p[k] for p in parts]) for k in ("t", "o", "h", "l", "c")}


def barre(m1, tf):
    key = m1["t"] // tf
    chg = np.flatnonzero(np.diff(key)) + 1
    st = np.concatenate([[0], chg])
    en = np.concatenate([chg, [m1["t"].size]])
    o = m1["o"][st]; c = m1["c"][en - 1]
    h = np.maximum.reduceat(m1["h"], st); l = np.minimum.reduceat(m1["l"], st)
    return dict(st=st, en=en, t=key[st] * tf, o=o, h=h, l=l, c=c)


def _prev_levels(m1, bt, keyfun):
    k = keyfun(m1["t"])
    chg = np.flatnonzero(np.diff(k)) + 1
    st = np.concatenate([[0], chg])
    keys = k[st]
    hi = np.maximum.reduceat(m1["h"], st); lo = np.minimum.reduceat(m1["l"], st)
    idx = np.searchsorted(keys, keyfun(bt), side="left") - 1
    ok = idx >= 0
    idc = np.where(ok, idx, 0)
    return np.where(ok, hi[idc], np.nan), np.where(ok, lo[idc], np.nan)


def livelli(m1, bt):
    day = lambda t: t // 1440
    week = lambda t: (t // 1440 + 3) // 7
    month = lambda t: (t * 60).astype("datetime64[s]").astype("datetime64[M]").astype(np.int64)
    out = []
    for kf in (day, week, month):
        out.append(_prev_levels(m1, bt, kf))
    res = np.stack([x[0] for x in out], axis=1)  # resistenze (high)
    sup = np.stack([x[1] for x in out], axis=1)  # supporti (low)
    return sup, res


def indicatori(b, P):
    n = b["c"].size; N = P["PERIOD"]
    c = b["c"]
    sma = np.full(n, np.nan); sd = np.full(n, np.nan)
    if n >= N:
        from numpy.lib.stride_tricks import sliding_window_view as swv
        w = swv(c, N)
        sma[N - 1:] = w.mean(axis=1); sd[N - 1:] = w.std(axis=1, ddof=0)
    pc = np.concatenate([[np.nan], c[:-1]])
    tr = np.maximum(b["h"] - b["l"], np.maximum(np.abs(b["h"] - pc), np.abs(b["l"] - pc)))
    atr = np.full(n, np.nan); A = P["ATR_N"]
    if n >= A + 1:
        from numpy.lib.stride_tricks import sliding_window_view as swv
        atr[A:] = swv(tr[1:], A).mean(axis=1)  # TR_k per k=j-13..j (richiede close precedente)
    return sma, sd, atr


def segnali(b, m1, P, sup, res, sma, sd, atr, shifts=None):
    """Lista (j, lato) di segnali candidati, senza ancora la regola 'una posizione alla volta'."""
    n = b["c"].size; N = P["PERIOD"]; tol = P["TOL"]
    up = sma + P["NSIGMA"] * sd; lo = sma - P["NSIGMA"] * sd
    maxgap = P["MAXGAP"] if P["MAXGAP"] is not None else (120 if P["TF"] == 60 else 2 * P["TF"])
    hour = (b["t"] // 60) % 24
    out = []
    for j in range(N + 1, n - 1):  # almeno 38 barre precedenti nell'elenco (j>=38 con 0-based => N+1)
        if not (np.isfinite(sma[j]) and np.isfinite(atr[j])):
            continue
        if P["FILTRO"] and int(hour[j]) in (13, 14):
            continue
        if b["t"][j + 1] - b["t"][j] > maxgap:
            continue
        a = atr[j]
        long_ = b["l"][j] <= lo[j]
        short_ = b["h"][j] >= up[j]
        if long_:
            if P["SR"]:
                L = sup[j]
                if shifts is not None:
                    L = L + shifts[j, :3]
                if not np.any(np.abs(L[np.isfinite(L)] - b["l"][j]) <= tol * a):
                    long_ = False
        if short_:
            if P["SR"]:
                L = res[j]
                if shifts is not None:
                    L = L + shifts[j, 3:]
                if not np.any(np.abs(L[np.isfinite(L)] - b["h"][j]) <= tol * a):
                    short_ = False
        if long_ and not short_:
            out.append((j, 1))
        elif short_ and not long_:
            out.append((j, -1))
    return out


def simula(m1, b, sma, atr, j, lato, P, start_min_ref=None):
    """Simula il trade dal segnale a barra j. Ritorna dict trade, oppure None se scartato."""
    sp_f = P["SPREAD_BP"] * P["SPREAD_MULT"] * 1e-4
    O, H, L, C, T = m1["o"], m1["h"], m1["l"], m1["c"], m1["t"]
    e = j + 1
    a0 = b["st"][e]
    sp0 = sp_f * O[a0]
    if lato == 1:
        entry = O[a0] + sp0
        sl = b["l"][j] - P["K"] * atr[j]
        if entry <= sl: return None
        tgt = sma[j]
        if tgt <= entry: return None
        r0 = entry - sl
    else:
        entry = O[a0]
        sl = b["h"][j] + P["K"] * atr[j]
        if entry >= sl: return None
        tgt = sma[j]
        if tgt >= entry: return None
        r0 = sl - entry
    nb = b["c"].size
    exit_px = None; motivo = None; exit_bar = None; exit_min = None
    i = e
    while i < nb:
        a, z = b["st"][i], b["en"][i]
        if i > e:
            tgt = sma[i - 1]
            if i - e >= P["MAXHOLD"]:
                exit_px = O[a] if lato == 1 else O[a] + sp_f * O[a]
                motivo = "TF"; exit_bar = i; exit_min = T[a]; break
            if lato == 1 and O[a] >= tgt:
                exit_px = O[a]; motivo = "MKT"; exit_bar = i; exit_min = T[a]; break
            if lato == -1 and O[a] + sp_f * O[a] <= tgt:
                exit_px = O[a] + sp_f * O[a]; motivo = "MKT"; exit_bar = i; exit_min = T[a]; break
        o_ = O[a:z]; h_ = H[a:z]; l_ = L[a:z]
        if lato == 1:
            slhit = l_ <= sl; tphit = h_ >= tgt
        else:
            sp_ = sp_f * o_
            slhit = h_ + sp_ >= sl; tphit = l_ + sp_ <= tgt
        ev = slhit | tphit
        if ev.any():
            k = int(np.argmax(ev))
            if slhit[k]:
                if lato == 1: exit_px = min(o_[k], sl)
                else: exit_px = max(o_[k] + sp_f * o_[k], sl)
                motivo = "SL"
            else:
                exit_px = tgt; motivo = "TP"
            exit_bar = i; exit_min = T[a + k]; break
        i += 1
    if exit_px is None:
        a = b["en"][nb - 1] - 1
        exit_px = C[a] if lato == 1 else C[a] + sp_f * O[a]
        motivo = "FINE_DATI"; exit_bar = nb - 1; exit_min = T[a]
    r = (exit_px - entry) / r0 if lato == 1 else (entry - exit_px) / r0
    return dict(j=int(j), lato=int(lato), t_in=int(T[a0]), t_out=int(exit_min), entry=float(entry), sl=float(sl),
                r0=float(r0), exit=float(exit_px), motivo=motivo, R=float(r), barre=int(exit_bar - e),
                exit_bar=int(exit_bar), sett=int((T[a0] // 1440 + 3) // 7))


def esegui(m1, P, shifts_seed=None, tutti_candidati=False):
    b = barre(m1, P["TF"])
    sup, res = livelli(m1, b["t"])
    sma, sd, atr = indicatori(b, P)
    shifts = None
    if shifts_seed is not None:
        rng = np.random.default_rng(shifts_seed)
        n = b["c"].size
        s = rng.choice([-1.0, 1.0], size=(n, 6)) * rng.uniform(1.0, 3.0, size=(n, 6))
        a = np.where(np.isfinite(atr), atr, 0.0)[:, None]
        shifts = s * a
    cand = segnali(b, m1, P, sup, res, sma, sd, atr, shifts)
    trades = []; libero = 0
    for j, lato in cand:
        if j < libero:
            continue
        t = simula(m1, b, sma, atr, j, lato, P)
        if t is None:
            continue
        trades.append(t)
        libero = t["exit_bar"]
    return trades, dict(n_barre=int(b["c"].size), n_candidati=len(cand))
