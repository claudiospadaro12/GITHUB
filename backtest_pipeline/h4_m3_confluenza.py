#!/usr/bin/env python3
# =====================================================================
#  MARCATORE_H4_M3_CONFLUENZA_v1
#  h4_m3_confluenza.py -- la CONFLUENZA H4/M3 della SuperWave v4.1
#  misurata come FENOMENO (event study), non come motore.
#
#  Criteri CONGELATI prima dei numeri:
#    report/H4_M3_CONFLUENZA_CRITERI_2026-10-01.md (commit 0523b049,
#    emendamento PRIMA dei dati e122978a; filtro di qualita' del feed
#    A_MIN_FRAZ aggiunto DOPO la prima corsa, dichiarato nel referto)
#  Se il codice e il file divergono, VINCE IL FILE.
#
#  Evento: inversione del Supertrend (ATR 10, mult 3,5, SW_STCore della
#  v4.1) su barra M3 CHIUSA. Gruppi: ALLINEATO (nel verso di un H4 stabile,
#  = la dashboard si accende), CONTRO (controllo A), CASUALE (controllo B,
#  istanti con H4 stabile nello stesso verso, appaiati per anno-mese e
#  ora), CASUALE-GIORNO (B', stesso giorno), PLACEBO (mult 2,5 / 3,0 /
#  ATR 14). Esiti sulle M1 a 30/60/120/240 minuti in ATR(14) di H1.
#
#  Riusa caricatore, orologio, ATR e regimi di ema200_rimbalzo.py e lo
#  specchio py_stcore/py_confl di collaudo_superwave_v41.py (collaudato
#  al bit contro il C++ della v4.1).
#
#  Uso:
#    python3 h4_m3_confluenza.py --autotest
#    python3 h4_m3_confluenza.py --dataset DAX --cache DIR --uscita DIR
#    (dataset: DAX, XAU_A, XAU_B, SPX)
#  Richiede numpy. ASCII puro.
#  Codici d'uscita: 0 ok, 2 invalido (autotest o cancello d'orologio).
# =====================================================================
import argparse, csv, math, os, sys, time
import datetime as dt
import numpy as np

QUI = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, QUI)
import ema200_rimbalzo as ER            # noqa: E402
import collaudo_superwave_v41 as CS     # noqa: E402

VERSIONE = "H4_M3_CONFLUENZA_v1"
CRITERI = "report/H4_M3_CONFLUENZA_CRITERI_2026-10-01.md (commit 0523b049, emendamento prima dei dati e122978a)"
REPO = os.path.dirname(QUI)
MQ5 = os.path.join(REPO, "mql5", "Indicators", "ABTG_SuperWave_Dashboard_v41.mq5")

CLOCK = ER.CLOCK_OFFSET_MIN             # barre su UTC+1 fisso
PER, MULT = 10, 3.5
STABLE_H4 = 3
FLIP_M3 = 3
TRUST = 300
HORIZ = (30, 60, 120, 240)
H_DEC = 60
A_MIN_FRAZ = 0.1          # filtro di qualita' del feed (vedi sistema())
N_MIN = 150
NDRAW = 20
NBOOT = 2000
VARIANTI = (("ST10x3.5", 10, 3.5), ("ST10x2.5", 10, 2.5), ("ST10x3.0", 10, 3.0), ("ST14x3.5", 14, 3.5))
PRIMARIA = "ST10x3.5"

ANCORE = {"DAX": (420, 480, 810, 870), "XAU_A": (810, 900), "XAU_B": (810, 900), "SPX": (810, 870, 900)}
RUOLO = {"DAX": "primario", "XAU_A": "primario", "XAU_B": "primario", "SPX": "SECONDARIO"}
SPREAD_FISSO = {"XAU_A": 0.2003, "XAU_B": 0.2003, "SPX": None, "DAX": None}
SPREAD_SENS = {"DAX": 1.7676, "XAU_A": 0.45, "XAU_B": 0.45, "SPX": 0.60}
SPREAD_ORARIO_CSV = os.path.join(QUI, "risultati_archivio", "spread_flotta", "spread_orario_D30EUR.csv")
FASCE = (("notte22-07", (22, 23, 0, 1, 2, 3, 4, 5, 6, 7)), ("giorno08-16", tuple(range(8, 17))),
         ("sera17-21", tuple(range(17, 22))))


def log(s=""):
    sys.stdout.write(s + "\n")
    sys.stdout.flush()


# ---------------------------------------------------------------------
# 1. SUPERTREND: stessa aritmetica di SW_STCore / py_stcore
# ---------------------------------------------------------------------
def st_fast(h, l, c, per, mult):
    """ritorna atr, up, dn, dir, val (numpy). ATR sommato nello STESSO ordine di SW_STCore."""
    h = np.asarray(h, dtype=np.float64); l = np.asarray(l, dtype=np.float64); c = np.asarray(c, dtype=np.float64)
    n = len(c)
    atr = np.zeros(n); up = np.zeros(n); dn = np.zeros(n); dr = np.zeros(n); val = np.zeros(n)
    if per < 1 or n <= per:
        return atr, up, dn, dr, val
    tr = np.zeros(n)
    tr[1:] = np.maximum(h[1:], c[:-1]) - np.minimum(l[1:], c[:-1])
    m = n - per
    s = np.zeros(m)
    for j in range(per):                      # k = i-per+1+j, in ordine crescente come il ciclo MQL5
        s = s + tr[1 + j: 1 + j + m]
    a = s / per
    atr[per:] = a
    mid = (h[per:] + l[per:]) / 2.0
    ub = (mid + mult * a).tolist(); lb = (mid - mult * a).tolist()
    cl = c.tolist(); midl = mid.tolist()
    U = [0.0] * n; D = [0.0] * n; R = [0.0] * n
    i = per
    U[i] = ub[0]; D[i] = lb[0]; R[i] = 1.0 if cl[i] >= midl[0] else -1.0
    for i in range(per + 1, n):
        q = i - per
        pu = U[i - 1]; pd = D[i - 1]; cp = cl[i - 1]; ci = cl[i]
        U[i] = ub[q] if (ub[q] < pu or cp > pu) else pu
        D[i] = lb[q] if (lb[q] > pd or cp < pd) else pd
        if ci > pu:
            R[i] = 1.0
        elif ci < pd:
            R[i] = -1.0
        else:
            R[i] = R[i - 1]
    up = np.array(U); dn = np.array(D); dr = np.array(R)
    val[per:] = np.where(dr[per:] > 0.0, dn[per:], up[per:])
    return atr, up, dn, dr, val


def bars_since_flip(dr, per):
    """bs per ogni barra come SW_BarsSinceFlip(dir, i, per+1) (storico intero). -1 = nessuna inversione."""
    n = len(dr)
    idx = np.arange(n)
    flip = np.zeros(n, bool)
    if n > per + 2:
        flip[per + 2:] = dr[per + 2:] != dr[per + 1:-1]
    lf = np.maximum.accumulate(np.where(flip, idx, -1))
    return np.where(lf >= 0, idx - lf, -1), flip


def confl_vec(dH4, bsH4, dM3, bsM3):
    """SW_Confl modo 1 vettoriale (verificata contro CS.py_confl nell'autotest)."""
    ok = (dH4 != 0) & (dM3 != 0) & (bsM3 >= 0) & (bsM3 < FLIP_M3) & (dM3 == dH4)
    ok &= ~((bsH4 >= 0) & (bsH4 < STABLE_H4))
    return np.where(ok, dH4, 0).astype(int)


# ---------------------------------------------------------------------
# 2. BARRE, ISTANTI, ESITI
# ---------------------------------------------------------------------
def barre(m, tfm, shift=0):
    bid = (m["t"] + CLOCK + shift) // tfm
    b = ER.barre_da_m1(m["t"], m["o"], m["h"], m["l"], m["c"], tfm, bin_id=bid)
    b["start"] = bid[b["st"]] * tfm - CLOCK - shift          # minuti UTC di apertura (orologio)
    b["end"] = b["start"] + tfm
    return b


def prepara(m, spread_ora=None, spread_fisso=None):
    """tutto cio' che NON dipende dal Supertrend: M3, H1, esiti di ogni chiusura M3."""
    t = m["t"]
    b3 = barre(m, 3)
    b1 = barre(m, 60)
    A1 = ER.atr(b1)
    tE = b3["end"]
    entry = b3["c"]
    jh = np.searchsorted(b1["end"], tE, side="right") - 1
    A = np.where(jh >= 0, A1[np.maximum(jh, 0)], np.nan)
    i0 = np.searchsorted(t, tE, side="left")
    P = dict(b3=b3, b1=b1, tE=tE, entry=entry, jh=jh, A=A, i0=i0)
    nt = len(t)
    for H in HORIZ:
        i1 = np.searchsorted(t, tE + H, side="left")
        ok = (i1 - i0 >= H // 2) & (i1 < nt) & (i1 > i0)
        a = np.minimum(i0, nt - 1); bb = np.minimum(i1, nt - 1)
        pairs = np.empty(2 * len(a), dtype=np.int64)
        pairs[0::2] = a; pairs[1::2] = np.maximum(bb, a + 1)
        pairs = np.minimum(pairs, nt - 1)
        mx = np.maximum.reduceat(m["h"], pairs)[0::2]
        mn = np.minimum.reduceat(m["l"], pairs)[0::2]
        ce = m["c"][np.maximum(bb - 1, 0)]
        P["i1_%d" % H] = i1
        P["ok_%d" % H] = ok
        P["dC_%d" % H] = ce - entry
        P["up_%d" % H] = mx - entry
        P["dn_%d" % H] = entry - mn
    tl = tE + CLOCK
    P["ora"] = ((tl // 60) % 24).astype(int)
    P["giorno"] = (tl // 1440).astype(np.int64)
    dd = np.array(tE // 1440, dtype="datetime64[D]")
    P["anno"] = (dd.astype("datetime64[Y]").astype(np.int64) + 1970).astype(int)
    P["ym"] = dd.astype("datetime64[M]").astype(np.int64)
    if spread_ora is not None:
        P["spread"] = np.array(spread_ora)[P["ora"]]
    else:
        P["spread"] = np.full(len(tE), spread_fisso if spread_fisso else np.nan)
    return P


def sistema(m, P, per, mult, shift=0, lookahead=False, b3st=None):
    """Supertrend su M3 e H4 e stato per ogni chiusura M3."""
    b3 = P["b3"]
    if b3st is None:
        a3, u3, d3, r3, v3 = st_fast(b3["h"], b3["l"], b3["c"], per, mult)
    else:
        a3, u3, d3, r3, v3 = b3st
    bs3, flip3 = bars_since_flip(r3, per)
    b4 = barre(m, 240, shift)
    a4, u4, d4, r4, v4 = st_fast(b4["h"], b4["l"], b4["c"], per, mult)
    bs4, _ = bars_since_flip(r4, per)
    tE = P["tE"]
    if lookahead:      # MUTANTE: barra H4 in formazione (contiene tE)
        j4 = np.searchsorted(b4["start"], tE, side="right") - 1
    else:              # ultima H4 CHIUSA: inizio + 240 <= tE
        j4 = np.searchsorted(b4["end"], tE, side="right") - 1
    j4c = np.maximum(j4, 0)
    k = np.arange(len(tE))
    # filtro di QUALITA' DEL FEED (aggiunto DOPO la prima corsa, dichiarato nel referto, classe 1037 estesa):
    # ATR(14) H1 >= 0,1 x mediana del dataset. Nei tratti piatti dell'Oanda l'ATR vale 0,0014 $ contro 2,92
    # di mediana e un movimento normale diventa R = 2.350 ATR. Deciso sulla distribuzione dell'ATR, NON sugli esiti.
    Afin = np.isfinite(P["A"]) & (P["A"] > 0)
    a_med = float(np.median(P["A"][Afin & (k >= TRUST)])) if (Afin & (k >= TRUST)).any() else 0.0
    valid = (k >= TRUST) & (j4 >= TRUST) & (P["jh"] >= TRUST) & Afin & (P["A"] >= A_MIN_FRAZ * a_med)
    dH4 = np.where(j4 >= 0, r4[j4c], 0).astype(int)
    bsH4 = np.where(j4 >= 0, bs4[j4c], -1)
    stab = ~((bsH4 >= 0) & (bsH4 < STABLE_H4)) & (dH4 != 0)
    s = r3.astype(int)
    ev = flip3 & valid & (s != 0)
    S = dict(r3=r3, v3=v3, bs3=bs3, flip3=flip3, r4=r4, v4=v4, bs4=bs4, j4=j4, dH4=dH4, bsH4=bsH4, stab=stab,
             s=s, valid=valid, nb4=len(b4["c"]), b4=b4, a_med=a_med,
             escl_feed=int(((k >= TRUST) & (j4 >= TRUST) & (P["jh"] >= TRUST) & Afin & (P["A"] < A_MIN_FRAZ * a_med)).sum()))
    S["ALL"] = ev & stab & (dH4 == s)
    S["CON"] = ev & stab & (dH4 == -s)
    S["INS"] = ev & ~stab
    S["cand"] = valid & stab & P["ok_%d" % H_DEC]
    return S


def segnati(P, idx, sgn, H):
    A = P["A"][idx]
    dC = P["dC_%d" % H][idx]; up = P["up_%d" % H][idx]; dn = P["dn_%d" % H][idx]
    R = sgn * dC / A
    fav = np.where(sgn > 0, up, dn); adv = np.where(sgn > 0, dn, up)
    return dict(R=R, pts=sgn * dC, MFE=np.maximum(fav, 0) / A, MAE=np.maximum(adv, 0) / A,
                net=R - P["spread"][idx] / A, ok=P["ok_%d" % H][idx])


# ---------------------------------------------------------------------
# 3. CONTROLLO B (appaiato) e bootstrap a blocchi di giorni
# ---------------------------------------------------------------------
def estrai(P, cand_idx, ev_idx, rng, livello="ora"):
    """per ogni evento un candidato a caso con la stessa ORA (UTC+1) su tutto il dataset.
    livello 'ym_ora' e 'giorno' esistono SOLO come contro-esempio dell'autotest: il peso di un mese
    (o di un giorno) = numero di eventi in quel mese, che dipende dal percorso INTERO del mese, cioe'
    anche dal FUTURO dell'istante estratto -> controllo distorto (misurato: +0,02/+0,03 ATR su random walk)."""
    out = np.full(len(ev_idx), -1, dtype=np.int64)
    if len(cand_idx) == 0 or len(ev_idx) == 0:
        return out
    if livello == "giorno":
        chiavi = [lambda ix: P["giorno"][ix]]
    elif livello == "ym_ora":
        chiavi = [lambda ix: P["ym"][ix] * 24 + P["ora"][ix],
                  lambda ix: P["anno"][ix] * 24 + P["ora"][ix],
                  lambda ix: P["ora"][ix]]
    else:
        chiavi = [lambda ix: P["ora"][ix]]
    resto = np.arange(len(ev_idx))
    for f in chiavi:
        if len(resto) == 0:
            break
        kc = f(cand_idx); o = np.argsort(kc, kind="stable"); kc = kc[o]; cs = cand_idx[o]
        ke = f(ev_idx[resto])
        lo = np.searchsorted(kc, ke, side="left"); hi = np.searchsorted(kc, ke, side="right")
        has = hi > lo
        pick = lo[has] + (rng.random(has.sum()) * (hi[has] - lo[has])).astype(np.int64)
        out[resto[has]] = cs[pick]
        resto = resto[~has]
    return out


class Boot:
    """ricampionamento dei GIORNI (stesse repliche per tutte le celle di un dataset)."""
    def __init__(self, giorni, seed, nboot=NBOOT):
        self.g = np.unique(giorni)
        rng = np.random.default_rng(seed)
        nd = len(self.g)
        self.C = np.zeros((nboot, nd), dtype=np.float32)
        for r in range(nboot):
            self.C[r] = np.bincount(rng.integers(0, nd, nd), minlength=nd)

    def somme(self, giorni, x):
        p = np.searchsorted(self.g, giorni)
        sx = np.bincount(p, weights=x, minlength=len(self.g)); nx = np.bincount(p, minlength=len(self.g))
        return self.C @ sx.astype(np.float32), self.C @ nx.astype(np.float32)

    def media(self, giorni, x):
        s, n = self.somme(giorni, x)
        with np.errstate(invalid="ignore", divide="ignore"):
            v = s / n
        return np.nanquantile(v, 0.025), np.nanquantile(v, 0.975)

    def diff(self, gA, xA, gB, xB):
        sA, nA = self.somme(gA, xA); sB, nB = self.somme(gB, xB)
        with np.errstate(invalid="ignore", divide="ignore"):
            v = sA / nA - sB / nB
        return np.nanquantile(v, 0.025), np.nanquantile(v, 0.975)


def verdetto(n, eff, lo, hi, mA, q025, q975):
    if n < N_MIN or not (eff == eff):
        return "NON ANCORA MISURATO"
    if eff >= 0.05 and lo > 0 and mA > q975:
        return "EFFETTO"
    if eff <= -0.05 and hi < 0 and mA < q025:
        return "CONTRARIO"
    if abs(eff) < 0.02 and lo >= -0.05 and hi <= 0.05:
        return "NULLO"
    return "ZONA GRIGIA"


def wilson(k, n, z=1.96):
    if n == 0:
        return (float("nan"), float("nan"))
    p = k / n; den = 1 + z * z / n
    c = (p + z * z / (2 * n)) / den
    h = z * math.sqrt(p * (1 - p) / n + z * z / (4 * n * n)) / den
    return (c - h, c + h)


# ---------------------------------------------------------------------
# 4. STOP e primo passaggio (+1R prima di -1R entro 240 minuti)
# ---------------------------------------------------------------------
def primo_passaggio(m, i0, i1, entry, sgn, D, L=240, chunk=20000):
    nt = len(m["t"])
    n = len(i0)
    code = np.full(n, 3, dtype=np.int8)      # 0 TP, 1 SL, 2 AMB, 3 TO
    rto = np.zeros(n)
    ar = np.arange(L)
    for a in range(0, n, chunk):
        b = min(n, a + chunk)
        ii = i0[a:b]; ln = np.minimum(i1[a:b] - ii, L)
        idx = np.minimum(ii[:, None] + ar[None, :], nt - 1)
        msk = ar[None, :] < ln[:, None]
        Hh = m["h"][idx]; Ll = m["l"][idx]
        e = entry[a:b][:, None]; d = D[a:b][:, None]; sg = sgn[a:b][:, None]
        tp = np.where(sg > 0, Hh >= e + d, Ll <= e - d) & msk
        sl = np.where(sg > 0, Ll <= e - d, Hh >= e + d) & msk
        ft = np.where(tp.any(1), tp.argmax(1), L + 1); fs = np.where(sl.any(1), sl.argmax(1), L + 1)
        cc = np.full(b - a, 3, dtype=np.int8)
        cc[ft < fs] = 0; cc[fs < ft] = 1; cc[(ft == fs) & (ft <= L)] = 2
        code[a:b] = cc
        last = np.minimum(ii + np.maximum(ln, 1) - 1, nt - 1)
        rto[a:b] = sgn[a:b] * (m["c"][last] - entry[a:b]) / D[a:b]
    return code, rto


def esito_stop(code, rto, spread, D):
    tp = int((code == 0).sum()); sl = int((code == 1).sum()); amb = int((code == 2).sum()); to = int((code == 3).sum())
    val = np.where(code == 0, 1.0, np.where(code == 3, rto, -1.0))
    return dict(TP=tp, SL=sl, AMB=amb, TO=to, val=val, net=val - spread / D)


# ---------------------------------------------------------------------
# 5. ANALISI DI UN DATASET
# ---------------------------------------------------------------------
def gruppo_stats(P, idx, sgn, H, boot):
    x = segnati(P, idx, sgn, H)
    ok = x["ok"]
    g = P["giorno"][idx][ok]
    r = dict(n=int(ok.sum()))
    for kk in ("R", "net", "MFE", "MAE", "pts"):
        v = x[kk][ok]
        r[kk] = float(np.mean(v)) if len(v) else float("nan")
    r["R_med"] = float(np.median(x["R"][ok])) if ok.any() else float("nan")
    if boot is not None and r["n"] > 0:
        r["lo"], r["hi"] = boot.media(g, x["R"][ok])
    else:
        r["lo"] = r["hi"] = float("nan")
    return r, x, g


def analizza(m, P, S, boot, seed, nome_var, orologio, righe, dettagli=False, fasce=False, regimi=None, livello="ora"):
    """confronti per lato su tutti gli orizzonti; ritorna la cella che decide per lato."""
    rng = np.random.default_rng(seed)
    decide = {}
    for lato, sl in (("long", 1), ("short", -1)):
        all_idx = np.flatnonzero(S["ALL"] & (S["s"] == sl))
        con_idx = np.flatnonzero(S["CON"] & (S["s"] == sl))
        ins_idx = np.flatnonzero(S["INS"] & (S["s"] == sl))
        cand = np.flatnonzero(S["cand"] & (S["dH4"] == sl))
        candc = np.flatnonzero(S["cand"] & (S["dH4"] == -sl))     # base del CONTRO: H4 opposto al segnale
        draws = [estrai(P, cand, all_idx, rng, livello) for _ in range(NDRAW)]
        drawsC = [estrai(P, candc, con_idx, rng, livello) for _ in range(NDRAW)]
        pair_ev = np.concatenate([np.arange(len(all_idx))[d >= 0] for d in draws]) if len(all_idx) else np.array([], int)
        B = np.concatenate([d[d >= 0] for d in draws]) if len(all_idx) else np.array([], int)
        BC = np.concatenate([d[d >= 0] for d in drawsC]) if len(con_idx) else np.array([], int)
        for H in HORIZ:
            ra, xa, ga = gruppo_stats(P, all_idx, sl, H, boot)
            rc, xc, gc = gruppo_stats(P, con_idx, sl, H, boot)
            ri, _, _ = gruppo_stats(P, ins_idx, sl, H, None)
            rb, xb, gb = gruppo_stats(P, B, sl, H, boot)
            rg, xg, gg = gruppo_stats(P, BC, sl, H, None)       # CASUALE_CON: istanti con H4 = -segnale, segno del segnale
            mdraw = []
            for d in draws:
                dd = d[d >= 0]
                xx = segnati(P, dd, sl, H)
                mdraw.append(float(np.mean(xx["R"][xx["ok"]])) if xx["ok"].any() else float("nan"))
            q025, q975 = (float(np.nanquantile(mdraw, 0.025)), float(np.nanquantile(mdraw, 0.975))) if mdraw else (np.nan, np.nan)
            eff = ra["R"] - rb["R"]
            lo, hi = boot.diff(ga, xa["R"][xa["ok"]], gb, xb["R"][xb["ok"]]) if ra["n"] and rb["n"] else (np.nan, np.nan)
            ver = verdetto(ra["n"], eff, lo, hi, ra["R"], q025, q975)
            effc = ra["R"] - rc["R"]
            loc, hic = boot.diff(ga, xa["R"][xa["ok"]], gc, xc["R"][xc["ok"]]) if ra["n"] and rc["n"] else (np.nan, np.nan)
            incr = eff - (rc["R"] - rg["R"])       # (ALL - B) - (CON - B_con): il filtro H4 cambia l'INCREMENTO M3?
            for nomeg, rr in (("ALLINEATO", ra), ("CONTRO", rc), ("H4_INSTABILE", ri), ("CASUALE_B", rb), ("CASUALE_CON", rg)):
                righe.append(dict(tipo="GRUPPO", variante=nome_var, orologio=orologio, lato=lato, H=H, filtro="TUTTO",
                                  gruppo=nomeg, n=rr["n"], media=rr["R"], lo=rr["lo"], hi=rr["hi"], mediana=rr["R_med"],
                                  netto=rr["net"], MFE=rr["MFE"], MAE=rr["MAE"], punti=rr["pts"]))
            righe.append(dict(tipo="EFFETTO", variante=nome_var, orologio=orologio, lato=lato, H=H, filtro="TUTTO",
                              gruppo="ALL-B", n=ra["n"], media=eff, lo=lo, hi=hi, q025=q025, q975=q975,
                              mA=ra["R"], mB=rb["R"], verdetto=ver))
            righe.append(dict(tipo="EFFETTO", variante=nome_var, orologio=orologio, lato=lato, H=H, filtro="TUTTO",
                              gruppo="ALL-CON", n=min(ra["n"], rc["n"]), media=effc, lo=loc, hi=hic, mA=ra["R"], mB=rc["R"]))
            righe.append(dict(tipo="EFFETTO", variante=nome_var, orologio=orologio, lato=lato, H=H, filtro="TUTTO",
                              gruppo="INCR_ALL-INCR_CON", n=min(ra["n"], rc["n"]), media=incr, mA=ra["R"] - rb["R"], mB=rc["R"] - rg["R"]))
            if H == H_DEC:
                decide[lato] = dict(n=ra["n"], eff=eff, lo=lo, hi=hi, q025=q025, q975=q975, mA=ra["R"], mB=rb["R"],
                                    mC=rc["R"], effc=effc, loc=loc, hic=hic, verdetto=ver, nC=rc["n"], mBC=rg["R"], incr=incr,
                                    netA=ra["net"], netB=rb["net"], all_idx=all_idx, B=B, pair_ev=pair_ev,
                                    con_idx=con_idx, nI=ri["n"], mI=ri["R"])
                # filtri: regimi e fasce orarie (solo sulla cella che decide)
                filtri = []
                if regimi:
                    for cl in ("TORO", "LATERALE", "ORSO"):
                        an = [y for y, c in regimi.items() if c == cl]
                        if an:
                            filtri.append((cl, lambda ix, an=an: np.isin(P["anno"][ix], an)))
                if fasce:
                    for nf, hs in FASCE:
                        filtri.append((nf, lambda ix, hs=hs: np.isin(P["ora"][ix], hs)))
                for nf, f in filtri:
                    fa = f(all_idx)[xa["ok"]] if len(all_idx) else np.array([], bool)
                    fb = f(B)[xb["ok"]] if len(B) else np.array([], bool)
                    na = int(fa.sum())
                    if na == 0 or fb.sum() == 0:
                        righe.append(dict(tipo="EFFETTO", variante=nome_var, orologio=orologio, lato=lato, H=H, filtro=nf,
                                          gruppo="ALL-B", n=na, verdetto="NON ANCORA MISURATO"))
                        continue
                    va = xa["R"][xa["ok"]][fa]; vb = xb["R"][xb["ok"]][fb]
                    e2 = float(va.mean() - vb.mean())
                    l2, h2 = boot.diff(ga[fa], va, gb[fb], vb)
                    na_net = float(xa["net"][xa["ok"]][fa].mean())
                    v2 = "NON ANCORA MISURATO" if na < N_MIN else ("EFFETTO" if (e2 >= 0.05 and l2 > 0) else
                         ("CONTRARIO" if (e2 <= -0.05 and h2 < 0) else ("NULLO" if (abs(e2) < 0.02 and l2 >= -0.05 and h2 <= 0.05) else "ZONA GRIGIA")))
                    righe.append(dict(tipo="EFFETTO", variante=nome_var, orologio=orologio, lato=lato, H=H, filtro=nf,
                                      gruppo="ALL-B", n=na, media=e2, lo=l2, hi=h2, mA=float(va.mean()), mB=float(vb.mean()),
                                      netto=na_net, verdetto=v2 + " (senza banda delle estrazioni)"))
    return decide


def analisi_stop(m, P, S, decide, boot, righe, spread_sens):
    out = {}
    for lato, sl in (("long", 1), ("short", -1)):
        dc = decide[lato]
        all_idx, B, pair_ev, con_idx = dc["all_idx"], dc["B"], dc["pair_ev"], dc["con_idx"]
        ok240 = P["ok_240"]
        e3 = P["entry"]; A = P["A"]
        Da_all = np.abs(e3[all_idx] - S["v3"][all_idx])
        oka_all = (sl * (e3[all_idx] - S["v3"][all_idx]) > 0)
        ratio_a = np.where(oka_all, Da_all / A[all_idx], np.nan)
        j4 = np.maximum(S["j4"], 0)
        gruppi = {}
        # ALLINEATO
        gruppi[("ALLINEATO", "a_ST_M3")] = (all_idx, Da_all, oka_all)
        gruppi[("ALLINEATO", "b_1ATR_H1")] = (all_idx, A[all_idx], np.ones(len(all_idx), bool))
        Dc = np.abs(e3[all_idx] - S["v4"][j4[all_idx]])
        gruppi[("ALLINEATO", "c_ST_H4")] = (all_idx, Dc, sl * (e3[all_idx] - S["v4"][j4[all_idx]]) > 0)
        # CONTRO (stop a e b)
        Dac = np.abs(e3[con_idx] - S["v3"][con_idx])
        gruppi[("CONTRO", "a_ST_M3")] = (con_idx, Dac, sl * (e3[con_idx] - S["v3"][con_idx]) > 0)
        gruppi[("CONTRO", "b_1ATR_H1")] = (con_idx, A[con_idx], np.ones(len(con_idx), bool))
        # CASUALE B (a: D/A appaiata all'evento; b; c dal ST H4 vero)
        rB = ratio_a[pair_ev] if len(pair_ev) else np.array([])
        gruppi[("CASUALE_B", "a_ST_M3")] = (B, rB * A[B], np.isfinite(rB))
        gruppi[("CASUALE_B", "b_1ATR_H1")] = (B, A[B], np.ones(len(B), bool))
        DcB = np.abs(e3[B] - S["v4"][j4[B]])
        gruppi[("CASUALE_B", "c_ST_H4")] = (B, DcB, sl * (e3[B] - S["v4"][j4[B]]) > 0)
        for (g, var), (idx, D, okD) in gruppi.items():
            sel = okD & ok240[idx] & (D > 0)
            ii = idx[sel]; DD = D[sel]
            sp = P["spread"][ii]
            code, rto = primo_passaggio(m, P["i0"][ii], P["i1_240"][ii], e3[ii], np.full(len(ii), sl), DD)
            es = esito_stop(code, rto, sp, DD)
            n1 = es["TP"] + es["SL"]
            wl, wh = wilson(es["TP"], n1)
            rat = DD / sp
            gi = P["giorno"][ii]
            elo, ehi = boot.media(gi, es["net"]) if len(ii) else (np.nan, np.nan)
            esens = float(np.mean(es["val"] - spread_sens / DD)) if (len(ii) and spread_sens) else float("nan")
            r = dict(tipo="STOP", variante=PRIMARIA, orologio="BCM", lato=lato, H=240, filtro="TUTTO", gruppo=g, stop=var,
                     n=len(ii), escl=int((~sel).sum()), TP=es["TP"], SL=es["SL"], AMB=es["AMB"], TO=es["TO"],
                     P1R=(es["TP"] / n1 if n1 else float("nan")), lo=wl, hi=wh,
                     P1R_cons=(es["TP"] / (n1 + es["AMB"]) if n1 + es["AMB"] else float("nan")),
                     E_lordo=float(np.mean(es["val"])) if len(ii) else float("nan"),
                     E_netto=float(np.mean(es["net"])) if len(ii) else float("nan"), E_lo=elo, E_hi=ehi,
                     E_netto_sens=esens,
                     D_A_med=float(np.nanmedian(DD / A[ii])) if len(ii) else float("nan"),
                     D_pts_med=float(np.nanmedian(DD)) if len(ii) else float("nan"),
                     rap_med=float(np.nanmedian(rat)) if len(ii) and np.isfinite(rat).any() else float("nan"),
                     rap_p10=float(np.nanquantile(rat, 0.10)) if len(ii) and np.isfinite(rat).any() else float("nan"),
                     rap_p90=float(np.nanquantile(rat, 0.90)) if len(ii) and np.isfinite(rat).any() else float("nan"),
                     quota40=float(np.mean(rat >= 40)) if len(ii) and np.isfinite(rat).any() else float("nan"))
            righe.append(r)
            out[(lato, g, var)] = r
    return out


def fedelta_finestra(P, S, m, per, mult, nsamp, rng):
    """ricalcola M3 e H4 su 1000 barre che finiscono sulla barra dell'evento: discordanze di classificazione."""
    b3 = P["b3"]; b4 = S["b4"]
    ev = np.flatnonzero((S["ALL"] | S["CON"] | S["INS"]))
    ev = ev[ev >= 1000]
    ev = ev[S["j4"][ev] >= 1000]
    if len(ev) == 0:
        return 0, 0, []
    pick = rng.choice(ev, size=min(nsamp, len(ev)), replace=False)
    disc = 0; dett = []
    for k in pick:
        s0 = k - 999
        _, _, _, r3, _ = st_fast(b3["h"][s0:k + 1], b3["l"][s0:k + 1], b3["c"][s0:k + 1], per, mult)
        bs3 = CS.py_bsf(list(r3), 999, per + 1)
        j = int(S["j4"][k]); s4 = j - 999
        _, _, _, r4, _ = st_fast(b4["h"][s4:j + 1], b4["l"][s4:j + 1], b4["c"][s4:j + 1], per, mult)
        bs4 = CS.py_bsf(list(r4), 999, per + 1)
        cw = CS.py_confl(1, int(r4[-1]), bs4, int(r3[-1]), bs3, FLIP_M3, STABLE_H4)
        cf = CS.py_confl(1, int(S["dH4"][k]), int(S["bsH4"][k]), int(S["s"][k]), 0, FLIP_M3, STABLE_H4)
        same = (int(r3[-1]) == int(S["s"][k])) and (bs3 == 0) and (int(r4[-1]) == int(S["dH4"][k])) and (cw == cf)
        if not same:
            disc += 1
            dett.append((int(k), int(r3[-1]), bs3, int(r4[-1]), bs4, int(S["dH4"][k]), int(S["bsH4"][k])))
    return disc, len(pick), dett


def identita_reale(P, per, mult, nmax=20000):
    b3 = P["b3"]
    n = min(nmax, len(b3["c"]))
    h = b3["h"][:n].tolist(); l = b3["l"][:n].tolist(); c = b3["c"][:n].tolist()
    a, u, d, r, v = CS.st_full(h, l, c, per, mult)
    fa, fu, fd, fr, fv = st_fast(b3["h"][:n], b3["l"][:n], b3["c"][:n], per, mult)
    return (np.array_equal(np.array(a), fa) and np.array_equal(np.array(u), fu) and np.array_equal(np.array(d), fd)
            and np.array_equal(np.array(r), fr) and np.array_equal(np.array(v), fv)), n


# ---------------------------------------------------------------------
# 6. CORSA SU DATI VERI
# ---------------------------------------------------------------------
CAMPI = ["simbolo", "tipo", "variante", "orologio", "lato", "H", "filtro", "gruppo", "stop", "n", "escl", "media", "lo", "hi",
         "q025", "q975", "mA", "mB", "mediana", "netto", "MFE", "MAE", "punti", "TP", "SL", "AMB", "TO", "P1R", "P1R_cons",
         "E_lordo", "E_netto", "E_lo", "E_hi", "E_netto_sens", "D_A_med", "D_pts_med", "rap_med", "rap_p10", "rap_p90",
         "quota40", "verdetto"]


def fmt(x):
    if isinstance(x, (float, np.floating)):
        return "" if x != x else "%.4f" % x
    return "" if x is None else str(x)


def leggi_spread_orario():
    out = [None] * 24
    with open(SPREAD_ORARIO_CSV) as fh:
        for r in csv.DictReader(fh):
            if r["ora_server"].isdigit():
                out[int(r["ora_server"])] = float(r["mediana_idx"])
    return out


def corri(nome, m, uscita, nvar=None):
    os.makedirs(uscita, exist_ok=True)
    rep = []
    def add(s=""):
        rep.append(s); log(s)
    simbolo = ER.DATASETS[nome]["simbolo"] + ("" if nome[:3] != "XAU" else "_" + nome[-1])
    add("=" * 78)
    add(" %s -- %s (%s) -- feed %s -- ruolo %s" % (VERSIONE, simbolo, nome, ER.DATASETS[nome]["feed"], RUOLO[nome]))
    add(" criteri: " + CRITERI)
    add("=" * 78)
    t = m["t"]
    add(" barre M1: %s   da %s a %s (UTC)" % (format(len(t), ","), ER.EPOCH + dt.timedelta(minutes=int(t[0])),
                                               ER.EPOCH + dt.timedelta(minutes=int(t[-1]))))
    ok, w, s, nw, ns = ER.cancello_orologio(m, ANCORE[nome])
    add(" G-OROLOGIO: picco inverno %s (n %d)  estate %s (n %d)  ancore %s -> %s" %
        (ER.hhmm(w), nw, ER.hhmm(s), ns, ",".join(ER.hhmm(a) for a in ANCORE[nome]), "PASSA" if ok else "FALLISCE"))
    if not ok:
        add(" !!! orologio non confermato: nessun numero (codice 2)")
        open(os.path.join(uscita, "REFERTO_%s.txt" % simbolo), "w").write("\n".join(rep) + "\n")
        return None
    reg, rend = ER.regimi_annuali(m)
    add(" regimi per anno: " + "  ".join("%d %s %+.1f%%" % (y, reg[y], 100 * rend[y]) for y in sorted(reg)))
    sp_ora = leggi_spread_orario() if nome == "DAX" else None
    P = prepara(m, sp_ora, SPREAD_FISSO[nome])
    if nome == "DAX":
        add(" costo: spread mediano per ORA SERVER BCM (UTC+1) da spread_orario_D30EUR.csv: " +
            " ".join("%d:%.1f" % (h, v) for h, v in enumerate(sp_ora)))
    else:
        add(" costo: spread fisso %s (sensibilita' %s)" % (SPREAD_FISSO[nome], SPREAD_SENS[nome]))
    idt, nid = identita_reale(P, PER, MULT)
    add(" IDENTITA' st_fast == py_stcore (collaudo v4.1) sulle prime %d barre M3 vere: %s" % (nid, "SI" if idt else "NO"))
    if not idt:
        add(" !!! Supertrend non identico: nessun numero (codice 2)")
        open(os.path.join(uscita, "REFERTO_%s.txt" % simbolo), "w").write("\n".join(rep) + "\n")
        return None
    righe = []
    boot = Boot(P["giorno"], seed=777)
    giorni_merc = len(np.unique(P["giorno"][TRUST:]))
    b3st_cache = {}
    risultati = {}
    varianti = VARIANTI if nvar is None else VARIANTI[:nvar]
    for (nv, per, mult) in varianti:
        t1 = time.time()
        b3 = P["b3"]
        st3 = st_fast(b3["h"], b3["l"], b3["c"], per, mult)
        b3st_cache[nv] = st3
        S = sistema(m, P, per, mult, b3st=st3)
        prim = nv == PRIMARIA
        dec = analizza(m, P, S, boot, 4242 + per * 10 + int(mult * 10), nv, "BCM", righe,
                       fasce=prim, regimi=reg if prim else None)
        risultati[(nv, "BCM")] = dec
        nall = int(S["ALL"].sum()); ncon = int(S["CON"].sum()); nins = int(S["INS"].sum())
        add(" %s: eventi M3 (inversioni valide) %d = ALLINEATO %d + CONTRO %d + H4 INSTABILE %d; "
            "ALLINEATO per giorno di mercato %.2f (giorni %d) (%.0f s)" %
            (nv, nall + ncon + nins, nall, ncon, nins, nall / max(giorni_merc, 1), giorni_merc, time.time() - t1))
        if prim:
            # stop
            stp = analisi_stop(m, P, S, dec, boot, righe, SPREAD_SENS[nome])
            risultati["stop"] = stp
            # fedelta' della finestra di 1000 barre
            disc, nsm, dett = fedelta_finestra(P, S, m, per, mult, 300, np.random.default_rng(99))
            add(" FILTRO FEED: chiusure M3 escluse per ATR H1 < %.1f x mediana (%.4f): %d su %d" %
                (A_MIN_FRAZ, S["a_med"], S["escl_feed"], int(S["valid"].sum()) + S["escl_feed"]))
            add(" FINESTRA 1000 barre (come la dashboard) contro storico intero: %d discordanze su %d eventi campionati"
                % (disc, nsm))
            for d_ in dett[:5]:
                add("    discordanza k=%d: finestra dirM3 %d bsM3 %d dirH4 %d bsH4 %d | storico dirH4 %d bsH4 %d" % d_)
            risultati["finestra"] = (disc, nsm)
            # verifica SW_Confl vettoriale contro lo specchio
            ev = np.flatnonzero(S["ALL"] | S["CON"] | S["INS"])
            vv = confl_vec(S["dH4"][ev], S["bsH4"][ev], S["s"][ev], np.zeros(len(ev), int))
            pp = np.array([CS.py_confl(1, int(S["dH4"][k]), int(S["bsH4"][k]), int(S["s"][k]), 0, FLIP_M3, STABLE_H4)
                           for k in ev])
            same = np.array_equal(vv, pp) and np.array_equal(vv != 0, S["ALL"][ev])
            add(" SW_Confl (py_confl del collaudo) == classificazione ALLINEATO su %d eventi: %s" % (len(ev), "SI" if same else "NO"))
            risultati["confl_ok"] = same
            # variante d'orologio FTMO (H4 +60 min), descrittiva
            S2 = sistema(m, P, per, mult, shift=60, b3st=st3)
            dec2 = analizza(m, P, S2, boot, 5151, nv, "H4+60(FTMO~)", righe)
            risultati[(nv, "FTMO")] = dec2
            add(" variante orologio H4+60 min: ALLINEATO %d (BCM %d)" % (int(S2["ALL"].sum()), nall))
            risultati["freq"] = (nall / max(giorni_merc, 1), giorni_merc,
                                 int((S["ALL"] & (S["s"] == 1)).sum()), int((S["ALL"] & (S["s"] == -1)).sum()))
            risultati["Amed"] = float(np.nanmedian(P["A"][S["valid"]]))
            spA = P["spread"][S["ALL"]]
            risultati["spread_med"] = float(np.median(spA[np.isfinite(spA)])) if np.isfinite(spA).any() else float("nan")
    for r in righe:
        r["simbolo"] = simbolo
    with open(os.path.join(uscita, "H4M3_%s.csv" % simbolo), "w", newline="") as fh:
        wr = csv.writer(fh)
        wr.writerow(CAMPI)
        for r in righe:
            wr.writerow([fmt(r.get(k)) for k in CAMPI])
    add("")
    add(" ATR(14) H1 mediano %.4f, spread mediano agli eventi ALLINEATO %.4f -> spread = %.3f ATR H1" %
        (risultati["Amed"], risultati["spread_med"], risultati["spread_med"] / risultati["Amed"]))
    add(" CELLA CHE DECIDE (R_60 lordo, ATR H1): ALLINEATO - CASUALE B, IC bootstrap giorni, banda 20 estrazioni")
    for (nv, oro) in [k for k in risultati if isinstance(k, tuple) and len(k) == 2 and k[1] in ("BCM", "FTMO")]:
        for lato in ("long", "short"):
            d = risultati[(nv, oro)][lato]
            add("  %-9s %-4s %-5s n %5d  ALL %+.3f  B %+.3f  CON %+.3f (n %d)  eff %+.3f [%+.3f;%+.3f] banda B [%+.3f;%+.3f]"
                "  ALL-CON %+.3f [%+.3f;%+.3f]  incrALL-incrCON %+.3f  netto ALL %+.3f  -> %s" %
                (nv, oro, lato, d["n"], d["mA"], d["mB"], d["mC"], d["nC"], d["eff"], d["lo"], d["hi"], d["q025"], d["q975"],
                 d["effc"], d["loc"], d["hic"], d["incr"], d["netA"], d["verdetto"]))
    add("")
    add(" STOP (primo passaggio +1R/-1R entro 240 min; AMB = SL nell'aspettativa; TO chiuso a mercato)")
    for (lato, g, var), r in sorted(risultati["stop"].items()):
        add("  %-5s %-10s %-10s n %5d escl %4d  D/A %.2f  D %.2f pt  D/spread med %.1fx [p10 %.1f p90 %.1f] >=40x %4.1f%%"
            "  P1R %.3f [%.3f;%.3f] TO %d  E lordo %+.3f R  netto %+.3f [%+.3f;%+.3f]  netto(sens) %+.3f" %
            (lato, g, var, r["n"], r["escl"], r["D_A_med"], r["D_pts_med"], r["rap_med"], r["rap_p10"], r["rap_p90"],
             100 * r["quota40"], r["P1R"], r["lo"], r["hi"], r["TO"], r["E_lordo"], r["E_netto"], r["E_lo"], r["E_hi"],
             r["E_netto_sens"]))
    open(os.path.join(uscita, "REFERTO_%s.txt" % simbolo), "w").write("\n".join(rep) + "\n")
    return risultati


# ---------------------------------------------------------------------
# 7. DATI SINTETICI E AUTOTEST
# ---------------------------------------------------------------------
SIG_ORA = [0.5, 0.45, 0.4, 0.4, 0.45, 0.5, 0.6, 0.9, 1.8, 1.4, 1.1, 1.0, 1.0, 1.1, 1.3, 2.0,
           1.6, 1.3, 1.0, 0.8, 0.7, 0.6, 0.55, 0.5]


class STInc:
    """Supertrend incrementale: stessa ricorsione di SW_STCore (somma del TR nello stesso ordine)."""
    def __init__(self, per, mult):
        self.per = per; self.mult = mult
        self.H = []; self.L = []; self.C = []; self.U = []; self.D = []; self.R = []; self.lf = -1

    def add(self, h, l, c):
        per = self.per; i = len(self.C)
        self.H.append(h); self.L.append(l); self.C.append(c)
        if i < per:
            self.U.append(0.0); self.D.append(0.0); self.R.append(0.0)
            return
        s = 0.0
        for k in range(i - per + 1, i + 1):
            s += max(self.H[k], self.C[k - 1]) - min(self.L[k], self.C[k - 1])
        a = s / per
        mid = (h + l) / 2.0; ub = mid + self.mult * a; lb = mid - self.mult * a
        if i == per:
            u = ub; d = lb; r = 1.0 if c >= mid else -1.0
        else:
            pu = self.U[i - 1]; pd = self.D[i - 1]; cp = self.C[i - 1]
            u = ub if (ub < pu or cp > pu) else pu
            d = lb if (lb > pd or cp < pd) else pd
            r = 1.0 if c > pu else (-1.0 if c < pd else self.R[i - 1])
        self.U.append(u); self.D.append(d); self.R.append(r)
        if i >= per + 2 and r != self.R[i - 1]:
            self.lf = i

    def bs(self):
        return (len(self.C) - 1 - self.lf) if self.lf >= 0 else -1


def genera(ngiorni, seed, modo="rw", k=0.05, mu=0.0, p0=10000.0, base=1.0):
    """M1 sintetiche, lun-ven 24h, volatilita' oraria stagionale. modo: rw | piantato | momentum | deriva."""
    rng = np.random.default_rng(seed)
    t0 = ER._minuti(dt.datetime(2015, 1, 5)) - CLOCK      # lunedi' 00:00 UTC+1
    giorni = [d for d in range(ngiorni * 7 // 5 + 7) if d % 7 < 5][:ngiorni]
    T = (t0 + np.array(giorni, dtype=np.int64)[:, None] * 1440 + np.arange(1440)[None, :]).ravel()
    n = len(T)
    ora = (((T + CLOCK) // 60) % 24).astype(int)
    sig = (np.array(SIG_ORA) * base)[ora].tolist()
    z = rng.standard_normal(n).tolist(); u1 = rng.random(n).tolist(); u2 = rng.random(n).tolist()
    Tl = T.tolist()
    O = [0.0] * n; Hh = [0.0] * n; Ll = [0.0] * n; Cc = [0.0] * n
    st3 = STInc(PER, MULT); st4 = STInc(PER, MULT)
    p = p0
    cur3 = None; cur4 = None; b3 = None; b4 = None
    fine_drift = -1; dir_drift = 0
    for i in range(n):
        t = Tl[i]
        k3 = (t + CLOCK) // 3; k4 = (t + CLOCK) // 240
        if cur4 is not None and k4 != cur4:
            st4.add(b4[0], b4[1], b4[2])
        if cur3 is not None and k3 != cur3:
            st3.add(b3[0], b3[1], b3[2])
            j = len(st3.C) - 1
            if j >= PER + 2 and st3.R[j] != st3.R[j - 1] and modo in ("piantato", "momentum"):
                sgn = int(st3.R[j])
                dH4 = int(st4.R[-1]) if st4.R else 0
                bsH4 = st4.bs()
                stab = not (bsH4 >= 0 and bsH4 < STABLE_H4)
                if modo == "momentum" or (dH4 == sgn and stab and dH4 != 0):
                    fine_drift = cur3 * 3 - CLOCK + 3 + 60
                    dir_drift = sgn
        sg = sig[i]
        drift = 0.0
        if modo == "deriva":
            drift = mu * sg
        elif t < fine_drift:
            drift = dir_drift * k * sg
        o = p; c = p + drift + sg * z[i]
        d2 = (c - o) ** 2
        hh = (o + c + math.sqrt(d2 - 2 * sg * sg * math.log(u1[i]))) / 2
        ll = (o + c - math.sqrt(d2 - 2 * sg * sg * math.log(u2[i]))) / 2
        O[i] = o; Hh[i] = hh; Ll[i] = ll; Cc[i] = c
        p = c
        if k3 != cur3:
            cur3 = k3; b3 = [hh, ll, c]
        else:
            if hh > b3[0]: b3[0] = hh
            if ll < b3[1]: b3[1] = ll
            b3[2] = c
        if k4 != cur4:
            cur4 = k4; b4 = [hh, ll, c]
        else:
            if hh > b4[0]: b4[0] = hh
            if ll < b4[1]: b4[1] = ll
            b4[2] = c
    return dict(t=T, o=np.array(O), h=np.array(Hh), l=np.array(Ll), c=np.array(Cc))


def autotest(ngiorni=2600):
    log("=" * 70)
    log(" AUTOTEST " + VERSIONE)
    log("=" * 70)
    ok = 0; tot = 0
    def chk(nome, cond, det):
        nonlocal ok, tot
        tot += 1; ok += 1 if cond else 0
        log(" [%s] %s -- %s" % ("PASS" if cond else "FAIL", nome, det))
    t0 = time.time()
    # 1. identita' del Supertrend
    rng = np.random.default_rng(5)
    nn = 3000
    c = 100 + np.cumsum(rng.normal(0, 1, nn)); c[500:540] = c[499]; c[1200] += 30; c[2000:2005] -= 25
    h = c + np.abs(rng.normal(0, 0.5, nn)); l = c - np.abs(rng.normal(0, 0.5, nn)); h[500:540] = c[499]; l[500:540] = c[499]
    tutto = True
    for per, mult in ((10, 3.5), (10, 2.5), (14, 3.5), (1, 3.0)):
        a, u, d, r, v = CS.st_full(h.tolist(), l.tolist(), c.tolist(), per, mult)
        fa, fu, fd, fr, fv = st_fast(h, l, c, per, mult)
        same = all(np.array_equal(np.array(x), y) for x, y in ((a, fa), (u, fu), (d, fd), (r, fr), (v, fv)))
        inc = STInc(per, mult)
        for i in range(nn):
            inc.add(float(h[i]), float(l[i]), float(c[i]))
        same_inc = np.array_equal(np.array(inc.R), fr) and np.array_equal(np.array(inc.U), fu)
        tutto = tutto and same and same_inc
        chk("IDENTITA' st_fast/STInc == py_stcore (%d; %.1f)" % (per, mult), same and same_inc,
            "inversioni %d" % int((np.diff(fr[per:]) != 0).sum()))
    src = open(MQ5, encoding="latin-1").read()
    righe_chiave = ["s+=MathMax(h[k],c[k-1])-MathMin(l[k],c[k-1]);",
                    "upF[i]=(ub<upF[i-1] || c[i-1]>upF[i-1]) ? ub : upF[i-1];",
                    "dnF[i]=(lb>dnF[i-1] || c[i-1]<dnF[i-1]) ? lb : dnF[i-1];",
                    "dir[i]=(c[i]>=mid) ? 1.0 : -1.0;",
                    "if(stableH4>0 && bsH4>=0 && bsH4<stableH4) return 0;",
                    "input int    InpAtrPeriod = 10;", "input double InpMult1     = 3.5;",
                    "input int    InpConflH4Stable = 3;"]
    manca = [x for x in righe_chiave if x not in src]
    chk("SORGENTE v4.1: righe chiave di SW_STCore/SW_Confl e default presenti", not manca, "mancano %s" % manca)
    # confl vettoriale contro lo specchio
    casi = [(dh, bh, dm, bm) for dh in (-1, 0, 1) for bh in (-1, 0, 1, 2, 3, 7) for dm in (-1, 0, 1) for bm in (-1, 0, 1, 2, 3)]
    vv = confl_vec(np.array([x[0] for x in casi]), np.array([x[1] for x in casi]), np.array([x[2] for x in casi]),
                   np.array([x[3] for x in casi]))
    pp = [CS.py_confl(1, a_, b_, c_, d_, FLIP_M3, STABLE_H4) for (a_, b_, c_, d_) in casi]
    chk("SW_Confl vettoriale == py_confl (modo 1, 270 casi)", list(vv) == pp, "")
    # 9. primo passaggio su percorso a mano
    mm = dict(t=np.arange(10, dtype=np.int64), o=np.full(10, 100.0),
              h=np.array([100.5, 101, 102.1, 100, 100, 100, 100, 100, 100, 100.0]),
              l=np.array([99.5, 99, 99.5, 97.9, 100, 100, 100, 100, 100, 100.0]), c=np.full(10, 100.0))
    cd, rt = primo_passaggio(mm, np.array([0, 0, 0, 0]), np.array([10, 10, 10, 2]), np.full(4, 100.0),
                             np.array([1, -1, 1, 1]), np.array([2.0, 2.0, 1.0, 5.0]), L=10)
    # long D2: TP a m2 (102,1), SL a m3 -> TP; short D2: SL a m2 (102,1) prima del TP a m3 -> SL;
    # long D1: 101 e 99 nello stesso minuto m1 -> AMB; finestra di 2 minuti con D5 -> TO
    chk("PRIMO PASSAGGIO: TP / SL-short / AMB / TO", list(cd) == [0, 1, 2, 3], "codici %s" % [int(x) for x in cd])
    log("   (%.0f s)" % (time.time() - t0))

    def misura(mx, lookahead=False, mult=MULT, shift=0, livello="ora"):
        P = prepara(mx, None, 1e-9)
        S = sistema(mx, P, PER, mult, shift=shift, lookahead=lookahead)
        boot = Boot(P["giorno"], seed=3, nboot=500)
        rr = []
        dec = analizza(mx, P, S, boot, 11, "T", "T", rr, livello=livello)
        return dec, S
    # 2. random walk con volatilita' oraria stagionale
    rw = genera(ngiorni, 101, "rw")
    dec, S = misura(rw)
    for lato in ("long", "short"):
        d = dec[lato]
        chk("RW %s: ALL, B, CON entro +/-0,03" % lato, max(abs(d["mA"]), abs(d["mB"]), abs(d["mC"])) <= 0.03,
            "ALL %+.3f B %+.3f CON %+.3f n %d" % (d["mA"], d["mB"], d["mC"], d["n"]))
        chk("RW %s: B entro +/-0,02" % lato, abs(d["mB"]) <= 0.02, "B %+.3f" % d["mB"])
        chk("RW %s: niente falso positivo" % lato, d["verdetto"] not in ("EFFETTO", "CONTRARIO"),
            "%s eff %+.3f [%+.3f;%+.3f]" % (d["verdetto"], d["eff"], d["lo"], d["hi"]))
    nrw = int(S["ALL"].sum())
    log("   RW: ALLINEATO %d, CONTRO %d, INSTABILE %d su %d giorni (%.0f s)" %
        (nrw, int(S["CON"].sum()), int(S["INS"].sum()), ngiorni, time.time() - t0))
    # 2b. contro-esempio del CONTROLLO: appaiato per (anno-mese, ora) il peso del mese dipende dal futuro
    decM, _ = misura(rw, livello="ym_ora")
    bo = (dec["long"]["mB"] + dec["short"]["mB"]) / 2; bm = (decM["long"]["mB"] + decM["short"]["mB"]) / 2
    chk("CONTROLLO appaiato per MESE distorto (contro-esempio): B(mese) - B(ora) > +0,01", bm - bo > 0.01,
        "B per ora %+.3f, B per anno-mese+ora %+.3f" % (bo, bm))
    # 6. look-ahead mutante (stesso random walk)
    #    (a) guardia deterministica: per OGNI chiusura M3 la barra H4 usata e' chiusa (fine <= tE) ed e'
    #        l'ULTIMA chiusa (la successiva finisce dopo tE): nessuna barra in formazione, mai.
    b4 = S["b4"]; j4 = S["j4"]; tE_ = prepara(rw, None, 1e-9)["tE"]
    okj = j4 >= 0
    chiusa = np.all(b4["end"][j4[okj]] <= tE_[okj])
    nxt = np.minimum(j4[okj] + 1, len(b4["end"]) - 1)
    ultima = np.all((j4[okj] + 1 >= len(b4["end"])) | (b4["end"][nxt] > tE_[okj]))
    sul_bordo = int(np.isin(tE_[okj], b4["end"]).sum())
    chk("H4 = ultima barra CHIUSA per ogni chiusura M3 (guardia deterministica)", bool(chiusa and ultima),
        "%d chiusure M3, di cui %d esattamente su un bordo H4" % (int(okj.sum()), sul_bordo))
    #    (b) mutante misurato: la barra in formazione sposta B verso l'alto, ma POCO (il filtro di stabilita'
    #        scarta proprio i casi in cui la barra in formazione si gira): il test RW da solo non basterebbe.
    decL, _ = misura(rw, lookahead=True)
    dmut = ((decL["long"]["mB"] - dec["long"]["mB"]) + (decL["short"]["mB"] - dec["short"]["mB"])) / 2
    chk("LOOK-AHEAD mutante (H4 in formazione): B si sposta verso l'alto (> +0,008, media dei lati)", dmut > 0.008,
        "spostamento %+.3f (B long %+.3f -> %+.3f, short %+.3f -> %+.3f)" %
        (dmut, dec["long"]["mB"], decL["long"]["mB"], dec["short"]["mB"], decL["short"]["mB"]))
    # 7. orologio: H4 spostato di 1 ora cambia gli eventi
    _, S1h = misura(rw, shift=60)
    chk("OROLOGIO: H4 +1h cambia il numero di ALLINEATO", int(S1h["ALL"].sum()) != nrw,
        "%d -> %d" % (nrw, int(S1h["ALL"].sum())))
    def file_picco(est_fisso):
        base = ER._minuti(dt.datetime(2015, 1, 1))
        t = base + np.arange(400 * 1440, dtype=np.int64)
        loc = t - 300
        for y in (2015, 2016):
            s_, e_ = ER._us_dst_bounds(y)
            loc[(t - 300 >= s_ - 60) & (t - 300 < e_ - 60)] += 60
        amp = np.where((loc % 1440) == 510, 1.0, 0.01)
        scritto = (t - 300) if est_fisso else loc
        o = np.full(len(t), 100.0); cc = o + amp
        return dict(t=ER.ny_to_utc(scritto), o=o, h=cc, l=o, c=cc)
    chk("G-OROLOGIO boccia il file in EST fisso", not ER.cancello_orologio(file_picco(True), (810, 900))[0], "")
    chk("G-OROLOGIO passa il file NY corretto", ER.cancello_orologio(file_picco(False), (810, 900))[0], "")
    # 8. mutazione della manopola
    _, S25 = misura(rw, mult=2.5)
    ev35 = int((S["ALL"] | S["CON"] | S["INS"]).sum()); ev25 = int((S25["ALL"] | S25["CON"] | S25["INS"]).sum())
    chk("MANOPOLA: mult 3,5 -> 2,5 cambia gli eventi >= 20%", abs(ev25 - ev35) >= 0.2 * ev35, "%d -> %d" % (ev35, ev25))
    log("   (%.0f s)" % (time.time() - t0))
    # 3. effetto piantato
    pl = genera(ngiorni, 202, "piantato", k=0.05)
    decp, _ = misura(pl)
    for lato in ("long", "short"):
        d = decp[lato]
        chk("PIANTATO %s: EFFETTO" % lato, d["verdetto"] == "EFFETTO",
            "%s eff %+.3f [%+.3f;%+.3f] ALL %+.3f B %+.3f n %d" % (d["verdetto"], d["eff"], d["lo"], d["hi"], d["mA"], d["mB"], d["n"]))
    effc = (decp["long"]["effc"] * decp["long"]["n"] + decp["short"]["effc"] * decp["short"]["n"]) / max(1, decp["long"]["n"] + decp["short"]["n"])
    chk("PIANTATO: ALL - CON > +0,05", effc > 0.05, "%+.3f" % effc)
    # 4. solo deriva H4
    dr_ = genera(ngiorni, 303, "deriva", mu=0.02)
    decd, _ = misura(dr_)
    d = decd["long"]
    chk("DERIVA (A2): B long > +0,03", d["mB"] > 0.03, "B %+.3f ALL %+.3f" % (d["mB"], d["mA"]))
    chk("DERIVA (A2): cella long NON EFFETTO", d["verdetto"] != "EFFETTO",
        "%s eff %+.3f [%+.3f;%+.3f] n %d" % (d["verdetto"], d["eff"], d["lo"], d["hi"], d["n"]))
    # 5. momentum M3 senza H4
    mo = genera(ngiorni, 404, "momentum", k=0.05)
    decm, _ = misura(mo)
    nA = decm["long"]["n"] + decm["short"]["n"]
    effB = (decm["long"]["eff"] * decm["long"]["n"] + decm["short"]["eff"] * decm["short"]["n"]) / max(1, nA)
    effC = (decm["long"]["effc"] * decm["long"]["n"] + decm["short"]["effc"] * decm["short"]["n"]) / max(1, nA)
    chk("MOMENTUM (A3): ALL - B >= +0,05", effB >= 0.05, "%+.3f" % effB)
    incr = (decm["long"]["incr"] * decm["long"]["n"] + decm["short"]["incr"] * decm["short"]["n"]) / max(1, nA)
    chk("MOMENTUM (A3): |ALL - CON| < 0,03", abs(effC) < 0.03, "%+.3f (CON long %+.3f short %+.3f)" %
        (effC, decm["long"]["mC"], decm["short"]["mC"]))
    chk("MOMENTUM (A3): |(ALL-B) - (CON-B_con)| < 0,03", abs(incr) < 0.03, "%+.3f" % incr)
    incp = (decp["long"]["incr"] * decp["long"]["n"] + decp["short"]["incr"] * decp["short"]["n"]) / max(1, decp["long"]["n"] + decp["short"]["n"])
    chk("PIANTATO: (ALL-B) - (CON-B_con) > +0,05", incp > 0.05, "%+.3f" % incp)
    log("AUTOTEST: %d/%d  (%.0f s)" % (ok, tot, time.time() - t0))
    return ok == tot


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--autotest", action="store_true")
    ap.add_argument("--giorni", type=int, default=2600, help="giorni sintetici dell'autotest")
    ap.add_argument("--dataset", choices=list(ER.DATASETS))
    ap.add_argument("--cache", default=os.path.join(os.getcwd(), "cache_m1"))
    ap.add_argument("--uscita", default=os.getcwd())
    ap.add_argument("--nvar", type=int, default=None, help="solo le prime N varianti (prova)")
    a = ap.parse_args()
    if a.autotest:
        sys.exit(0 if autotest(a.giorni) else 2)
    m = ER.carica_dataset(a.dataset, a.cache, REPO)
    r = corri(a.dataset, m, a.uscita, a.nvar)
    sys.exit(2 if r is None else 0)


if __name__ == "__main__":
    main()
