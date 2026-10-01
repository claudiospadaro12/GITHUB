#!/usr/bin/env python3
# =====================================================================
#  MARCATORE_EMA200_D1_SU_M5_v1
#  ema200_d1_su_m5.py -- la EMA200 del D1 letta su barre M5 / M15 / H1
#  (rimbalzo "multi-timeframe" come FENOMENO, come la usa Paolo)
#
#  Criteri CONGELATI prima dei numeri:
#    report/EMA200_D1_SU_M5_CRITERI_2026-10-02.md
#  Se il codice e il file divergono, VINCE IL FILE e il codice e' sbagliato.
#
#  Riusa lettura feed, orologio, ATR, Wilson, regimi e sintetici di
#  ema200_rimbalzo.py (MARCATORE_EMA200_RIMBALZO_v1). Cambia SOLO:
#   - il LIVELLO: EMA200 delle chiusure D1 (giorno UTC+1, weekend -> lunedi')
#       FERMA     = valore dell'ultimo giorno CHIUSO, costante nella giornata
#       VIVA      = EMA D1 con la barra D1 in formazione (close della barra
#                   del TF di lettura come close provvisorio del giorno)
#       RIDIPINTA = valore FINALE del giorno stesso (look-ahead: e' cio' che
#                   un grafico STORICO disegna; solo contro-esempio)
#       placebo   = EMA D1 100/150/250 e SMA D1 200 (alla FERMA)
#   - il NULL N1: surrogato a blocchi di GIORNI INTERI (memoria del livello
#     ~100 giorni; il blocco e' 1 giorno = 1% della memoria: classe 1034)
#   - l'IC del verdetto: il piu' largo fra Wilson e bootstrap a grappoli
#     per giorno (gli eventi dello stesso giorno non sono indipendenti)
#   - il filtro di qualita' del feed dichiarato PRIMA: evento scartato se
#     l'ATR del TF di lettura < 0,1 x mediana del dataset (classe 1037/1054)
#
#  NON e' un backtest: niente PF, niente equity, niente costo nella P.
#  Uso:
#    python3 ema200_d1_su_m5.py --autotest
#    python3 ema200_d1_su_m5.py --dataset DAX --cache DIR --uscita DIR
#    python3 ema200_d1_su_m5.py --dataset DAX --giorno NYCLOSE ...  (sensibilita')
#  Codici d'uscita: 0 ok, 2 invalido (autotest o cancello orologio falliti).
#  File ASCII puro.
# =====================================================================
import argparse, csv, math, os, sys, time
import datetime as dt
import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import ema200_rimbalzo as R   # noqa: E402

VERSIONE = "EMA200_D1_SU_M5_v1"
CRITERI = "report/EMA200_D1_SU_M5_CRITERI_2026-10-02.md"
TF_MIN = {"M5": 5, "M15": 15, "H1": 60}
ALPHA = 2.0 / 201.0
WARMUP_D1 = 600
N_SEP, D_MIN, HORIZON = 20, 1.0, 20
XS, YS = (0.25, 0.5, 1.0), (0.5, 1.0)
CELLE = [(x, y) for y in YS for x in XS]
PRIMARIA, COLLEGA = (1.0, 1.0), (0.25, 1.0)
IPRIM, ICOLL = CELLE.index(PRIMARIA), CELLE.index(COLLEGA)
B_BRK, TOL, Z_ESC = 0.5, 0.10, 1.5
N_MIN = 150
ATR_FILTRO = 0.1
N_BOOT = 2000
LIVELLI = ("FERMA", "VIVA", "RIDIPINTA", "EMA100", "EMA150", "EMA250", "SMA200")
GRIGLIA = {"D30EUR": 100.0, "SPXUSD": 50.0, "XAUUSD": 10.0}
ANCORE = {"DAX": (420, 480, 810, 870), "SPX": (810, 870, 900), "XAU_A": (810, 900), "XAU_B": (810, 900)}
ES = {"B": 0, "P": 1, "AMB": 2, "TO": 3}


def log(s=""):
    sys.stdout.write(s + "\n")
    sys.stdout.flush()


# ---------------------------------------------------------------------
# 1. GIORNI
# ---------------------------------------------------------------------
def giorno_label(t, modo="UTC1"):
    """etichetta di giorno (giorni dall'epoch) per ogni minuto UTC; sabato/domenica -> lunedi'."""
    t = np.asarray(t, dtype=np.int64)
    if modo == "UTC1":
        d = (t + 60) // 1440
    elif modo == "NYCLOSE":   # giorno che chiude alle 17:00 di New York (= mezzanotte server UTC+2/+3)
        off = np.full(len(t), 300, dtype=np.int64)
        if len(t):
            y0 = (R.EPOCH + dt.timedelta(minutes=int(t.min()))).year
            y1 = (R.EPOCH + dt.timedelta(minutes=int(t.max()))).year
            for y in range(y0 - 1, y1 + 1):
                s, e = R._us_dst_bounds(y)
                off[(t >= s + 300) & (t < e + 240)] = 240
        d = (t - off + 420) // 1440
    else:
        raise ValueError(modo)
    wd = (d + 3) % 7                       # 0 = lunedi'
    return d + np.where(wd == 5, 2, np.where(wd == 6, 1, 0))


def indice_giorni(g):
    ch = np.empty(len(g), bool); ch[0] = True; ch[1:] = g[1:] != g[:-1]
    st = np.flatnonzero(ch)
    en = np.append(st[1:], len(g))
    return np.cumsum(ch) - 1, st, en


def barre(o, h, l, c, dayidx, torig, tfm):
    bin_id = dayidx.astype(np.int64) * 2000 + ((torig + 60) % 1440) // tfm
    b = R.barre_da_m1(bin_id, o, h, l, c, tfm, bin_id=bin_id)
    b["day"] = dayidx[b["st"]]
    return b


def livello_giornaliero(Cd, tipo):
    if tipo == "SMA200":
        return R.sma(Cd, 200)
    n = 200 if tipo in ("FERMA", "VIVA", "RIDIPINTA") else int(tipo[3:])
    return R.ema(Cd, n)


def livelli_barra(b, Ed, tipo, alpha=ALPHA):
    """ritorna (Eref, Edist): Eref[k] = linea con cui si giudica il contatto della barra k
       (nota PRIMA della barra k); Edist[k] = linea alla chiusura della barra k."""
    d = b["day"]
    prev = np.where(d >= 1, Ed[np.maximum(d - 1, 0)], np.nan)
    if tipo == "VIVA":
        ev = prev + alpha * (b["c"] - prev)
        ref = np.insert(ev[:-1], 0, np.nan)
        return ref, ev
    if tipo == "RIDIPINTA":
        cur = Ed[d]
        return cur, cur
    return prev, prev


# ---------------------------------------------------------------------
# 2. EVENTI
# ---------------------------------------------------------------------
def _primo(a, thr, cresc):
    return R._primo(a, thr, cresc)


def eventi_h1(m1o, m1h, m1l, b, Eref, Edist, A, yrs, valid_bar, amin, griglia=None):
    """primo tocco (criteri sez. 3): ritorna dict di array (uno per evento)."""
    nb = len(b["c"])
    Ap = np.insert(A[:-1], 0, np.nan)
    with np.errstate(invalid="ignore", divide="ignore"):
        clean_up = b["l"] > Eref
        clean_dn = b["h"] < Eref
        okA = np.isfinite(A) & (A >= amin) & (A > 0)
        dist = np.where(okA & np.isfinite(Edist), (b["c"] - Edist) / np.where(okA, A, 1.0), 0.0)
    clean_up &= np.isfinite(Eref); clean_dn &= np.isfinite(Eref)
    clean_up[:1] = False; clean_dn[:1] = False
    ru = R._run_len(clean_up); rd = R._run_len(clean_dn)
    dmax = R._roll_ext(dist, N_SEP, np.max); dmin = R._roll_ext(dist, N_SEP, np.min)
    arm_up = np.zeros(nb, bool); arm_dn = np.zeros(nb, bool)
    arm_up[1:] = (ru[:-1] >= N_SEP) & (dmax[:-1] >= D_MIN)
    arm_dn[1:] = (rd[:-1] >= N_SEP) & (dmin[:-1] <= -D_MIN)
    with np.errstate(invalid="ignore"):
        valid = valid_bar & np.isfinite(Ap) & (Ap >= amin) & (Ap > 0) & np.isfinite(Eref)
        tu = np.flatnonzero(arm_up & valid & (b["l"] <= Eref))
        td = np.flatnonzero(arm_dn & valid & (b["h"] >= Eref))
    first_bar_day = np.ones(nb, bool); first_bar_day[1:] = b["day"][1:] != b["day"][:-1]
    out = dict(lato=[], anno=[], giorno=[], es=[], pt0=[], gap=[], tondo=[], k=[], L=[], A=[])
    for lato, ks in ((0, tu), (1, td)):
        for kk in ks:
            L = Eref[kk]; a = Ap[kk]
            s0, e0 = b["st"][kk], b["en"][kk]
            eh = b["en"][min(kk + HORIZON - 1, nb - 1)]
            if lato == 0:
                hi = m1h[s0:eh]; lo = m1l[s0:eh]; Lx = L; op = m1o[s0:e0]
            else:
                hi = -m1l[s0:eh]; lo = -m1h[s0:eh]; Lx = -L; op = -m1o[s0:e0]
            w = np.flatnonzero(lo[: e0 - s0] <= Lx)
            if len(w) == 0:
                continue
            t0 = int(w[0])
            runmin = np.minimum.accumulate(lo[t0:])
            runmax = np.maximum.accumulate(hi[t0 + 1:]) if t0 + 1 < len(hi) else np.array([])
            nrest = len(runmin)
            es = []
            p_t0 = False
            for (X, Y) in CELLE:
                ip = _primo(runmin, Lx - Y * a, False)
                ib = _primo(runmax, Lx + X * a, True) + 1 if len(runmax) else nrest
                ib = ib if ib <= nrest - 1 else nrest
                ipp = ip if ip < nrest else nrest
                if ib == nrest and ipp == nrest:
                    r = 3
                elif ib < ipp:
                    r = 0
                elif ipp < ib:
                    r = 1
                else:
                    r = 2
                es.append(r)
                if (X, Y) == PRIMARIA:
                    p_t0 = (ip == 0)
            gap = bool(first_bar_day[kk] and t0 == 0 and op[0] <= Lx)
            tondo = False
            if griglia:
                tondo = abs(L - round(L / griglia) * griglia) <= 0.25 * a
            out["lato"].append(lato); out["anno"].append(int(yrs[s0 + t0])); out["giorno"].append(int(b["day"][kk]))
            out["es"].append(es); out["pt0"].append(p_t0); out["gap"].append(gap); out["tondo"].append(tondo)
            out["k"].append(int(kk)); out["L"].append(float(L)); out["A"].append(float(a))
    tipi = dict(lato=np.int64, anno=np.int64, giorno=np.int64, pt0=bool, gap=bool, tondo=bool, k=np.int64,
                L=np.float64, A=np.float64)
    ev = {k: (np.array(v, dtype=tipi[k]) if k in tipi else np.array(v)) for k, v in out.items()}
    if len(ev["k"]) == 0:
        ev["es"] = np.zeros((0, len(CELLE)), dtype=np.int64)
    # ordina per tempo e marca il primo del giorno per lato
    o = np.lexsort((ev["k"], ev["lato"])) if len(ev["k"]) else np.array([], dtype=np.int64)
    for k in ev:
        ev[k] = ev[k][o]
    pg = np.ones(len(ev["k"]), bool)
    if len(pg) > 1:
        pg[1:] = ~((ev["lato"][1:] == ev["lato"][:-1]) & (ev["giorno"][1:] == ev["giorno"][:-1]))
    ev["primo_giorno"] = pg
    return ev


def _next_true(mask):
    """nx[i] = primo indice j >= i con mask[j], len(mask) se nessuno."""
    n = len(mask)
    idx = np.where(mask, np.arange(n), n)
    return np.append(np.minimum.accumulate(idx[::-1])[::-1], n)


def eventi_h2(m1h, m1l, b, Edist, A, yrs, valid_bar, amin):
    """sfondamento e ritest (criteri sez. 4), macchina a stati percorsa a salti
       (equivalente al ciclo di ema200_rimbalzo.eventi_h2: autotest T9)."""
    nb = len(b["c"])
    c = b["c"]
    with np.errstate(invalid="ignore"):
        up = c > Edist; dn = c < Edist
        okk = valid_bar & np.isfinite(A) & (A >= amin) & (A > 0) & np.isfinite(Edist)
        brk_dn = okk & (c <= Edist - B_BRK * A)
        brk_up = okk & (c >= Edist + B_BRK * A)
    ru = R._run_len(up); rd = R._run_len(dn)
    nx_ru = _next_true(ru >= N_SEP); nx_rd = _next_true(rd >= N_SEP)
    nx_bd = _next_true(brk_dn); nx_bu = _next_true(brk_up)
    out = dict(lato=[], anno=[], giorno=[], es=[], null=[], sc=[])
    regime = 0; pos = 0; r0 = -1   # r0 = barra dell'ultimo azzeramento dei contatori
    while pos < nb:
        if regime == 0:
            j0 = max(pos, r0 + N_SEP) if r0 >= 0 else pos
            if j0 >= nb:
                break
            ju = nx_ru[j0]; jd = nx_rd[j0]
            j = min(ju, jd)
            if j >= nb:
                break
            regime = 1 if ju <= jd else -1
            pos = j + 1
            continue
        if regime == 1:
            kb = nx_bd[pos]; ks = nx_rd[pos]
        else:
            kb = nx_bu[pos]; ks = nx_ru[pos]
        if kb >= nb and ks >= nb:
            break
        if ks < kb:
            regime = -regime; pos = ks + 1
            continue
        k = kb
        ek = Edist[k]; ak = A[k]; ck = c[k]
        brk = regime
        regime = 0; r0 = k; pos = k + 1
        if k + 1 >= nb:
            continue
        s0 = b["st"][k + 1]; eh = b["en"][min(k + HORIZON, nb - 1)]
        if brk == 1:
            hi = m1h[s0:eh]; lo = m1l[s0:eh]; L = ek; d0 = (ek - ck) / ak; lato = 0
        else:
            hi = -m1l[s0:eh]; lo = -m1h[s0:eh]; L = -ek; d0 = (ck - ek) / ak; lato = 1
        rt_thr = L - TOL * ak; ra_thr = L - Z_ESC * ak
        null = max(0.0, (Z_ESC - d0) / (Z_ESC - TOL)) if d0 < Z_ESC else 0.0
        anno = int(yrs[b["st"][k]]); gio = int(b["day"][k])
        if d0 >= Z_ESC:
            r = 1; sc = True
        else:
            sc = False
            irt = _primo(np.maximum.accumulate(hi), rt_thr, True) if len(hi) else 0
            ira = _primo(np.minimum.accumulate(lo), ra_thr, False) if len(lo) else 0
            n = len(hi)
            if irt >= n and ira >= n:
                r = 3
            elif irt < ira:
                r = 0
            elif ira < irt:
                r = 1
            else:
                r = 2
        out["lato"].append(lato); out["anno"].append(anno); out["giorno"].append(gio)
        out["es"].append(r); out["null"].append(null); out["sc"].append(sc)
    tipi = dict(lato=np.int64, anno=np.int64, giorno=np.int64, es=np.int64, null=np.float64, sc=bool)
    return {k: np.array(v, dtype=tipi[k]) for k, v in out.items()}


# ---------------------------------------------------------------------
# 3. UNA PASSATA COMPLETA (vero o surrogato)
# ---------------------------------------------------------------------
def passata(o, h, l, c, torig, dayidx, st_d, en_d, yrs, livelli, amed=None, griglia=None, tfs=("M5", "M15", "H1")):
    Cd = c[en_d - 1]
    nd = len(st_d)
    Ed = {tipo: livello_giornaliero(Cd, tipo) for tipo in set(livelli)}
    out = {}
    amed_out = {}
    for tf in tfs:
        b = barre(o, h, l, c, dayidx, torig, TF_MIN[tf])
        A = R.atr(b)
        med = float(np.nanmedian(A[b["day"] >= WARMUP_D1])) if np.any(b["day"] >= WARMUP_D1) else float("nan")
        amed_out[tf] = med
        ref_med = amed[tf] if amed is not None else med
        amin = ATR_FILTRO * ref_med if ref_med == ref_med else 0.0
        valid_bar = b["day"] >= WARMUP_D1
        for tipo in livelli:
            Eref, Edist = livelli_barra(b, Ed[tipo], tipo)
            e1 = eventi_h1(o, h, l, b, Eref, Edist, A, yrs, valid_bar, amin, griglia)
            e2 = eventi_h2(h, l, b, Edist, A, yrs, valid_bar, amin)
            out[(tipo, tf)] = (e1, e2)
    return out, amed_out, nd


def surrogato_giorni(m, st_d, en_d, rng, rx):
    """blocchi = GIORNI INTERI permutati; prezzi dai rendimenti log minuto per minuto (gap compresi)."""
    nd = len(st_d)
    perm = rng.permutation(nd)
    lens = en_d - st_d
    idx = np.concatenate([np.arange(st_d[p], en_d[p]) for p in perm])
    rc, ro, rh, rl, lp0 = rx
    lc = lp0 + np.cumsum(rc[idx])
    lpc = np.insert(lc[:-1], 0, lp0)
    o = np.exp(lpc + ro[idx]); h = np.exp(lpc + rh[idx]); l = np.exp(lpc + rl[idx]); c = np.exp(lc)
    dayidx = np.repeat(np.arange(nd), lens[perm])
    stn = np.insert(np.cumsum(lens[perm])[:-1], 0, 0); enn = stn + lens[perm]
    return o, h, l, c, m["t"][idx], dayidx, stn, enn, idx


def rendimenti(m):
    c = m["c"]; pc = np.insert(c[:-1], 0, m["o"][0])
    return (np.log(c / pc), np.log(m["o"] / pc), np.log(m["h"] / pc), np.log(m["l"] / pc), float(np.log(m["o"][0])))


# ---------------------------------------------------------------------
# 4. CONTEGGI, IC, VERDETTI
# ---------------------------------------------------------------------
SOTTO_H1 = ("TUTTO", "PRIMO_GIORNO", "SENZA_GAP", "SENZA_TONDI", "SOLO_GAP", "SOLO_TONDI")


def maschera_h1(e1, lato, sotto, regimi):
    m = e1["lato"] == lato if len(e1["k"]) else np.zeros(0, bool)
    if sotto == "PRIMO_GIORNO":
        m = m & e1["primo_giorno"]
    elif sotto == "SENZA_GAP":
        m = m & ~e1["gap"]
    elif sotto == "SENZA_TONDI":
        m = m & ~e1["tondo"]
    elif sotto == "SOLO_GAP":
        m = m & e1["gap"]
    elif sotto == "SOLO_TONDI":
        m = m & e1["tondo"]
    elif sotto in ("TORO", "LATERALE", "ORSO"):
        an = [y for y, cl in regimi.items() if cl == sotto]
        m = m & np.isin(e1["anno"], an)
    return m


def maschera_h2(e2, lato, sotto, regimi):
    m = e2["lato"] == lato if len(e2["es"]) else np.zeros(0, bool)
    if sotto in ("TORO", "LATERALE", "ORSO"):
        an = [y for y, cl in regimi.items() if cl == sotto]
        m = m & np.isin(e2["anno"], an)
    return m


def chiavi(livelli, tfs, regimi):
    K = []
    regs = [r for r in ("TORO", "LATERALE", "ORSO") if r in set(regimi.values())]
    for tipo in livelli:
        for tf in tfs:
            for lato in (0, 1):
                for ic in range(len(CELLE)):
                    K.append(("H1", tipo, tf, lato, ic, "TUTTO"))
                for sotto in SOTTO_H1[1:] + tuple(regs):
                    for ic in (IPRIM, ICOLL):
                        if sotto in regs and ic != IPRIM:
                            continue
                        K.append(("H1", tipo, tf, lato, ic, sotto))
                for sotto in ("TUTTO",) + tuple(regs):
                    K.append(("H2", tipo, tf, lato, 0, sotto))
    return K


def riassunto(res, K, regimi):
    """per ogni chiave: (B, P, AMB, TO) e, per IC, conteggi per giorno."""
    S = {}
    for key in K:
        ip, tipo, tf, lato, ic, sotto = key
        e1, e2 = res[(tipo, tf)]
        if ip == "H1":
            m = maschera_h1(e1, lato, sotto, regimi)
            es = e1["es"][m, ic] if m.any() else np.zeros(0, dtype=np.int64)
            g = e1["giorno"][m]
            extra = None
        else:
            m = maschera_h2(e2, lato, sotto, regimi)
            es = e2["es"][m] if m.any() else np.zeros(0, dtype=np.int64)
            g = e2["giorno"][m]
            extra = (float(np.mean(e2["null"][m][es < 2])) if np.any(es < 2) else float("nan"), int(e2["sc"][m].sum()))
        cnt = np.bincount(es.astype(np.int64), minlength=4)[:4] if len(es) else np.zeros(4, dtype=np.int64)
        S[key] = (cnt, es, g, extra)
    return S


def p_di(cnt):
    n = cnt[0] + cnt[1]
    return (cnt[0] / n) if n else float("nan"), int(n)


def boot_giorni(es, g, rng, nb=N_BOOT):
    sel = es < 2
    if sel.sum() == 0:
        return float("nan"), float("nan"), 0
    es = es[sel]; g = g[sel]
    ug, inv = np.unique(g, return_inverse=True)
    bd = np.bincount(inv, weights=(es == 0).astype(float))
    nd_ = np.bincount(inv).astype(float)
    D = len(ug)
    W = rng.multinomial(D, np.full(D, 1.0 / D), size=nb).astype(float)
    num = W @ bd; den = W @ nd_
    ps = num[den > 0] / den[den > 0]
    return float(np.quantile(ps, 0.025)), float(np.quantile(ps, 0.975)), D


def verdetto(p, n, lo, hi, med, q025, q975):
    return R.verdetto(p, n, lo, hi, med, q025, q975)


# ---------------------------------------------------------------------
# 5. CORSA
# ---------------------------------------------------------------------
def misura(m, simbolo, modo, livelli, nsurr, seed, griglia=None, tfs=("M5", "M15", "H1"), regimi=None, verbose=True):
    t0 = time.time()
    g = giorno_label(m["t"], modo)
    dayidx, st_d, en_d = indice_giorni(g)
    yrs = R.anni_di(m["t"])
    regimi = regimi if regimi is not None else R.regimi_annuali(m)[0]
    res, amed, nd = passata(m["o"], m["h"], m["l"], m["c"], m["t"], dayidx, st_d, en_d, yrs, livelli,
                            griglia=griglia, tfs=tfs)
    K = chiavi(livelli, tfs, regimi)
    S_vero = riassunto(res, K, regimi)
    if verbose:
        log("   passata vera: %d giorni, %.0f s" % (nd, time.time() - t0))
    rng = np.random.default_rng(seed)
    rx = rendimenti(m)
    SURR = {key: [] for key in K}
    SURR_BN = {key: [] for key in K}
    for i in range(nsurr):
        o, h, l, c, ts, di, stn, enn, _ = surrogato_giorni(m, st_d, en_d, rng, rx)
        ys = R.anni_di(ts)
        rs, _, _ = passata(o, h, l, c, ts, di, stn, enn, ys, livelli, amed=amed, griglia=griglia, tfs=tfs)
        Ss = riassunto(rs, K, regimi)
        for key in K:
            SURR[key].append(p_di(Ss[key][0])[0])
            SURR_BN[key].append((int(Ss[key][0][0]), int(Ss[key][0][0] + Ss[key][0][1])))
        if verbose and (i + 1) % 20 == 0:
            log("   surrogati %d/%d (%.0f s)" % (i + 1, nsurr, time.time() - t0))
    rngb = np.random.default_rng(seed + 7)
    righe = []
    for key in K:
        ip, tipo, tf, lato, ic, sotto = key
        cnt, es, gg, extra = S_vero[key]
        p, n = p_di(cnt)
        lw, hw = R.wilson(int(cnt[0]), n)
        lb, hb, ndays = boot_giorni(es, gg, rngb)
        lo = min(lw, lb) if lb == lb else lw
        hi = max(hw, hb) if hb == hb else hw
        med, q1, q2 = R._q(SURR[key]) if nsurr else (float("nan"),) * 3
        if ip == "H1":
            X, Y = CELLE[ic]
            cella = "X%.2f_Y%.2f" % (X, Y); n0 = Y / (X + Y)
            lat = ("long", "short")[lato]
        else:
            cella = "b0.5_tol0.10_Z1.5"; n0 = extra[0]
            lat = ("giu", "su")[lato]
        r = dict(simbolo=simbolo, giorno=modo, ipotesi=ip, livello=tipo, tf=tf, lato=lat, cella=cella, sotto=sotto,
                 n=n, n_giorni=ndays, B=int(cnt[0]), P=int(cnt[1]), AMB=int(cnt[2]), TO=int(cnt[3]), p=p,
                 w_lo=lw, w_hi=hw, b_lo=lb, b_hi=hb, lo=lo, hi=hi, n0=n0, smed=med, sq025=q1, sq975=q2,
                 eff=(p - med) if (n and med == med) else float("nan"),
                 scappati=(extra[1] if extra else ""))
        r["verdetto"] = verdetto(p, n, lo, hi, med, q1, q2)
        righe.append(r)
    diag = {}
    for tipo in livelli:
        for tf in tfs:
            e1, e2 = res[(tipo, tf)]
            diag[(tipo, tf)] = dict(
                n_ev=len(e1["k"]), n_gap=int(e1["gap"].sum()) if len(e1["k"]) else 0,
                n_tondo=int(e1["tondo"].sum()) if len(e1["k"]) else 0,
                n_pt0=int(np.sum(e1["pt0"] & (e1["es"][:, IPRIM] == 1))) if len(e1["k"]) else 0,
                n_P=int(np.sum(e1["es"][:, IPRIM] == 1)) if len(e1["k"]) else 0,
                n_h2=len(e2["es"]), giorni=len(np.unique(e1["giorno"])) if len(e1["k"]) else 0,
                anni_eventi=sorted(set(int(x) for x in e1["anno"])) if len(e1["k"]) else [],
                k=e1["k"], lato_k=e1["lato"])
    grezzi = dict(K=K, vero={key: (S_vero[key][1], S_vero[key][2]) for key in K}, surr_bn=SURR_BN)
    return righe, diag, amed, nd, res, grezzi


def salva_grezzi(fn, simbolo, grezzi):
    """per la lettura aggregata (criteri sez. 7.3): esiti per evento e conteggi dei surrogati per chiave."""
    D = {}
    for i, key in enumerate(grezzi["K"]):
        es, g = grezzi["vero"][key]
        D["k%d_es" % i] = np.asarray(es, dtype=np.int8)
        D["k%d_g" % i] = np.asarray(g, dtype=np.int64)
        D["k%d_s" % i] = np.asarray(grezzi["surr_bn"][key], dtype=np.int64).reshape(-1, 2)
    D["chiavi"] = np.array(["|".join(str(x) for x in key) for key in grezzi["K"]])
    D["simbolo"] = np.array([simbolo])
    np.savez_compressed(fn, **D)


CAMPI = ["simbolo", "giorno", "ipotesi", "livello", "tf", "lato", "cella", "sotto", "n", "n_giorni", "B", "P", "AMB",
         "TO", "p", "w_lo", "w_hi", "b_lo", "b_hi", "lo", "hi", "n0", "smed", "sq025", "sq975", "eff", "scappati",
         "verdetto"]


def fmt(x):
    if isinstance(x, (float, np.floating)):
        return "" if x != x else "%.4f" % x
    return str(x)


def corri(nome, cache, uscita, modo, nsurr, livelli, repo):
    ds = R.DATASETS[nome]
    simbolo = ds["simbolo"] + ("" if nome[:3] != "XAU" else "_" + nome[-1])
    os.makedirs(uscita, exist_ok=True)
    rep = []

    def add(s=""):
        rep.append(s); log(s)
    add("=" * 78)
    add(" %s -- %s -- feed %s -- giorno %s" % (VERSIONE, simbolo, ds["feed"], modo))
    add(" criteri: %s (congelati)" % CRITERI)
    add("=" * 78)
    m = R.carica_dataset(nome, cache, repo)
    t = m["t"]
    add(" barre M1: %s   da %s a %s (UTC)" % (format(len(t), ","), R.EPOCH + dt.timedelta(minutes=int(t[0])),
                                               R.EPOCH + dt.timedelta(minutes=int(t[-1]))))
    anc = ANCORE[nome]
    ok, w, s, nw, ns = R.cancello_orologio(m, anc)
    add(" G-OROLOGIO: picco inverno %s (n %d)  estate %s (n %d)  ancore %s -> %s%s" %
        (R.hhmm(w), nw, R.hhmm(s), ns, ",".join(R.hhmm(a) for a in anc), "PASSA" if ok else "FALLISCE",
         "  [S&P: ancora 15:00 dichiarata nei criteri; lettura SECONDARIA]" if nome == "SPX" else ""))
    if not ok:
        add(" !!! orologio non confermato: nessun numero (codice 2)")
        open(os.path.join(uscita, "REFERTO_%s_%s.txt" % (simbolo, modo)), "w").write("\n".join(rep) + "\n")
        return None
    g = giorno_label(t, modo)
    wd_raw = ((((t + 60) // 1440) + 3) % 7) if modo == "UTC1" else None
    if wd_raw is not None:
        add(" minuti di sabato/domenica (UTC+1) attribuiti al lunedi': %d su %d" % (int(np.sum(wd_raw >= 5)), len(t)))
    reg, rend = R.regimi_annuali(m)
    add(" regimi per anno: " + "  ".join("%d %s %+.1f%%" % (y, reg[y], 100 * rend[y]) for y in sorted(reg)))
    righe, diag, amed, nd, res, grezzi = misura(m, simbolo, modo, livelli, nsurr, seed=4242,
                                                griglia=GRIGLIA[ds["simbolo"]], regimi=reg)
    salva_grezzi(os.path.join(uscita, "GREZZI_%s_%s.npz" % (simbolo, modo)), simbolo, grezzi)
    _, st_d, en_d = indice_giorni(g)
    dstart = R.EPOCH + dt.timedelta(minutes=int(t[st_d[min(WARMUP_D1, nd - 1)]]))
    anni_eff = (t[-1] - t[st_d[min(WARMUP_D1, nd - 1)]]) / 1440.0 / 365.25
    add(" giorni D1: %d; eventi dal giorno %d = %s (riscaldamento EMA D1); anni utili %.2f" %
        (nd, WARMUP_D1, dstart.date(), anni_eff))
    for (tipo, tf), dg in diag.items():
        if tipo not in ("FERMA", "VIVA", "RIDIPINTA"):
            continue
        add("   %-9s %-3s eventi H1 %4d (%.1f/anno) in %3d giorni; tocchi in gap d'apertura %d; linea a <=0,25 ATR da un tondo %d;"
            " sfondamenti primaria %d, nel minuto del tocco %d; eventi H2 %d" %
            (tipo, tf, dg["n_ev"], dg["n_ev"] / anni_eff if anni_eff > 0 else 0, dg["giorni"], dg["n_gap"],
             dg["n_tondo"], dg["n_P"], dg["n_pt0"], dg["n_h2"]))
    # FERMA contro VIVA: eventi identici
    for tf in TF_MIN:
        if ("FERMA", tf) in diag and ("VIVA", tf) in diag:
            a = set(zip(diag[("FERMA", tf)]["k"].tolist(), diag[("FERMA", tf)]["lato_k"].tolist()))
            b = set(zip(diag[("VIVA", tf)]["k"].tolist(), diag[("VIVA", tf)]["lato_k"].tolist()))
            add("   FERMA vs VIVA %s: eventi comuni %d, solo FERMA %d, solo VIVA %d" % (tf, len(a & b), len(a - b), len(b - a)))
    add(" ATR mediano (dal giorno %d): %s; filtro feed: evento scartato se ATR < %.1f x mediana" %
        (WARMUP_D1, "  ".join("%s %.4f" % (k, v) for k, v in amed.items()), ATR_FILTRO))
    if ds["spread"]:
        add(" COSTO (costo pieno %.4f, fonte sonda_supertrend_segnali.py; NON entra nella P): " % ds["spread"] +
            "  ".join("%s 1 ATR = %.1fx" % (k, v / ds["spread"]) for k, v in amed.items()))
    fn = os.path.join(uscita, "EMA200_D1_%s_%s.csv" % (simbolo, modo))
    with open(fn, "w", newline="") as fh:
        wr = csv.writer(fh); wr.writerow(CAMPI)
        for r in righe:
            wr.writerow([fmt(r[k]) for k in CAMPI])
    add("")
    add(" PRIMARIA H1 (X=Y=1) e H2, sottoinsieme TUTTO:")
    for r in righe:
        if r["sotto"] != "TUTTO" or (r["ipotesi"] == "H1" and r["cella"] != "X1.00_Y1.00"):
            continue
        add("  %-2s %-9s %-3s %-5s n %4d (%3d g)  P %.3f  IC [%.3f;%.3f]  N0 %.3f  surr %.3f [%.3f;%.3f]  eff %+.3f  %s" %
            (r["ipotesi"], r["livello"], r["tf"], r["lato"], r["n"], r["n_giorni"], r["p"], r["lo"], r["hi"], r["n0"],
             r["smed"], r["sq025"], r["sq975"], r["eff"], r["verdetto"]))
    open(os.path.join(uscita, "REFERTO_%s_%s.txt" % (simbolo, modo)), "w").write("\n".join(rep) + "\n")
    return righe


# ---------------------------------------------------------------------
# 5-bis. LETTURA AGGREGATA (criteri sez. 7.3): secondaria, dichiarata prima
# ---------------------------------------------------------------------
INSIEMI = {"DAX+ORO_A+ORO_B": ("D30EUR", "XAUUSD_A", "XAUUSD_B"),
           "DAX+ORO_A+ORO_B+SPX[sec.]": ("D30EUR", "XAUUSD_A", "XAUUSD_B", "SPXUSD")}


def aggrega(cartella, modo="UTC1"):
    dati = {}
    for sim in ("D30EUR", "XAUUSD_A", "XAUUSD_B", "SPXUSD"):
        fn = os.path.join(cartella, "GREZZI_%s_%s.npz" % (sim, modo))
        if os.path.exists(fn):
            z = np.load(fn)
            ch = [str(x) for x in z["chiavi"]]
            dati[sim] = {c: (z["k%d_es" % i], z["k%d_g" % i], z["k%d_s" % i]) for i, c in enumerate(ch)}
    righe = []
    rng = np.random.default_rng(99)
    for nome, sims in INSIEMI.items():
        if not all(s_ in dati for s_ in sims):
            continue
        comuni = set.intersection(*[set(dati[s_]) for s_ in sims])
        for c in sorted(comuni):
            ip, tipo, tf, lato, ic, sotto = c.split("|")
            if sotto not in ("TUTTO", "PRIMO_GIORNO"):
                continue
            if ip == "H1" and int(ic) not in (IPRIM, ICOLL):
                continue
            es = np.concatenate([dati[s_][c][0] for s_ in sims]).astype(np.int64)
            gg = np.concatenate([dati[s_][c][1] + 10_000_000 * j for j, s_ in enumerate(sims)])
            sb = sum(dati[s_][c][2] for s_ in sims)
            cnt = np.bincount(es, minlength=4)[:4] if len(es) else np.zeros(4, dtype=np.int64)
            p, n = p_di(cnt)
            ps = [b / nn for b, nn in sb if nn > 0]
            med, q1, q2 = R._q(ps)
            lw, hw = R.wilson(int(cnt[0]), n)
            lb, hb, nd_ = boot_giorni(es, gg, rng)
            lo = min(lw, lb) if lb == lb else lw
            hi = max(hw, hb) if hb == hb else hw
            if ip == "H1":
                X, Y = CELLE[int(ic)]; cella = "X%.2f_Y%.2f" % (X, Y); lat = ("long", "short")[int(lato)]; n0 = Y / (X + Y)
            else:
                cella = "b0.5_tol0.10_Z1.5"; lat = ("giu", "su")[int(lato)]; n0 = float("nan")
            r = dict(simbolo=nome, giorno=modo, ipotesi=ip, livello=tipo, tf=tf, lato=lat, cella=cella, sotto=sotto,
                     n=n, n_giorni=nd_, B=int(cnt[0]), P=int(cnt[1]), AMB=int(cnt[2]), TO=int(cnt[3]), p=p,
                     w_lo=lw, w_hi=hw, b_lo=lb, b_hi=hb, lo=lo, hi=hi, n0=n0, smed=med, sq025=q1, sq975=q2,
                     eff=(p - med) if (n and med == med) else float("nan"), scappati="")
            r["verdetto"] = verdetto(p, n, lo, hi, med, q1, q2)
            righe.append(r)
    fn = os.path.join(cartella, "EMA200_D1_AGGREGATO_%s.csv" % modo)
    with open(fn, "w", newline="") as fh:
        wr = csv.writer(fh); wr.writerow(CAMPI)
        for r in righe:
            wr.writerow([fmt(r[k]) for k in CAMPI])
    log(" lettura aggregata: %d righe -> %s" % (len(righe), fn))
    return righe


# ---------------------------------------------------------------------
# 6. SINTETICI E AUTOTEST
# ---------------------------------------------------------------------
def minuti_feriali(ngiorni, t_inizio=dt.datetime(2000, 1, 3)):
    """minuti UTC dei soli giorni feriali UTC+1 (00:00-23:59 UTC+1), per ngiorni feriali."""
    out = []
    d = t_inizio; k = 0
    base = []
    while k < ngiorni:
        if d.weekday() < 5:
            base.append(R._minuti(d) - 60)
            k += 1
        d += dt.timedelta(days=1)
    base = np.array(base, dtype=np.int64)
    return (base[:, None] + np.arange(1440, dtype=np.int64)[None, :]).ravel()


def sint_rw(ngiorni, sig=1.0, seed=1, p0=20000.0, drift_giorno_sd=0.0, gap_sd=0.0):
    rng = np.random.default_rng(seed)
    t = minuti_feriali(ngiorni)
    n = len(t)
    inc = rng.normal(0, sig, n)
    if drift_giorno_sd > 0:
        inc += np.repeat(rng.normal(0, drift_giorno_sd, ngiorni), 1440)
    if gap_sd > 0:
        inc[::1440] += rng.normal(0, gap_sd, ngiorni)
    c = p0 + np.cumsum(inc)
    o = np.insert(c[:-1], 0, p0)
    h, l = R._bridge_hl(o, c, sig, rng)
    if gap_sd > 0:   # il minuto del gap: apertura gia' spostata
        o[::1440] = o[::1440] + (c[::1440] - o[::1440]) * 0.999
        h = np.maximum(h, np.maximum(o, c)); l = np.minimum(l, np.minimum(o, c))
    return dict(t=t, o=o, h=h, l=l, c=c)


def sint_piantato(ngiorni, sig=1.0, seed=2, p0=20000.0, forza=0.6, zona=0.15, tfm=5, periodo=200):
    """spinta di ritorno quando il prezzo e' entro 'zona' ATR(TF) dalla EMA D1 (FERMA, periodo dato)
       dal lato di provenienza; lato aggiornato alla chiusura di ogni barra del TF."""
    rng = np.random.default_rng(seed)
    t = minuti_feriali(ngiorni)
    n = len(t)
    z = rng.normal(0, sig, n).tolist()
    a = 2.0 / (periodo + 1.0)
    atr_c = 1.25 * sig * math.sqrt(tfm)
    p = p0; e = p0; side = 1
    cl = [0.0] * n
    for i in range(n):
        if i % 1440 == 0 and i > 0:
            e = e + a * (cl[i - 1] - e)
        d = (p - e) / atr_c
        drift = 0.0
        if side == 1 and d < zona:
            drift = forza * sig
        elif side == -1 and d > -zona:
            drift = -forza * sig
        p = p + drift + z[i]
        cl[i] = p
        if (i + 1) % tfm == 0:
            side = 1 if p > e else -1
    c = np.array(cl)
    o = np.insert(c[:-1], 0, p0)
    h, l = R._bridge_hl(o, c, sig, rng)
    return dict(t=t, o=o, h=h, l=l, c=c)


def autotest(nsurr=30, scala=1.0):
    log("=" * 70)
    log(" AUTOTEST " + VERSIONE)
    log("=" * 70)
    ok = 0; tot = 0
    t0 = time.time()

    def chk(nome, cond, det):
        nonlocal ok, tot
        tot += 1; ok += 1 if cond else 0
        log(" [%s] %s -- %s" % ("PASS" if cond else "FAIL", nome, det))

    def riga(R_, ip, liv, tf, lato, cella="X1.00_Y1.00", sotto="TUTTO"):
        x = [r for r in R_ if r["ipotesi"] == ip and r["livello"] == liv and r["tf"] == tf and r["lato"] == lato
             and (ip == "H2" or r["cella"] == cella) and r["sotto"] == sotto]
        return x[0]

    # T12 weekend -> lunedi'
    dom = R._minuti(dt.datetime(2015, 6, 7, 22, 30))       # domenica 23:30 UTC+1
    lun = R._minuti(dt.datetime(2015, 6, 8, 8, 0))
    sab = R._minuti(dt.datetime(2015, 6, 6, 10, 0))
    gl = giorno_label(np.array([sab, dom, lun]))
    chk("T12 sabato e domenica sera -> lunedi'", gl[0] == gl[1] == gl[2], "etichette %s" % gl.tolist())
    gny = giorno_label(np.array([R._minuti(dt.datetime(2015, 6, 8, 20, 59)), R._minuti(dt.datetime(2015, 6, 8, 21, 1))]), "NYCLOSE")
    chk("T12b giorno NYCLOSE cambia alle 17:00 NY (21:00 UTC d'estate)", gny[1] == gny[0] + 1, "%s" % gny.tolist())

    # T1-T2 random walk
    ND = int(7000 * scala)
    rw = sint_rw(ND, seed=11)
    Rr, diag, amed, nd, res, _ = misura(rw, "RW", "UTC1", ("FERMA", "VIVA"), nsurr, seed=5, regimi={}, verbose=False)
    for tf in ("M5", "M15"):
        for lato in ("long", "short"):
            r = riga(Rr, "H1", "FERMA", tf, lato); rc = riga(Rr, "H1", "FERMA", tf, lato, "X0.25_Y1.00")
            log("   [INFO] RW %s %s: primaria P %.3f n %d (%d giorni)  collega %.3f  surr %.3f [%.3f;%.3f] -> %s" %
                (tf, lato, r["p"], r["n"], r["n_giorni"], rc["p"], r["smed"], r["sq025"], r["sq975"], r["verdetto"]))
    nprim = sum(riga(Rr, "H1", "FERMA", "M5", l)["n"] for l in ("long", "short"))
    chk("T1 RW M5 n primaria (due lati) >= 1000", nprim >= 1000, "n=%d" % nprim)
    for lato in ("long", "short"):
        r = riga(Rr, "H1", "FERMA", "M5", lato)
        chk("T1 RW M5 %s primaria ~0,500 (+/-0,04)" % lato, abs(r["p"] - 0.5) <= 0.04, "P=%.3f n=%d" % (r["p"], r["n"]))
    for tf in ("M5", "M15", "H1"):
        for lato in ("long", "short"):
            r = riga(Rr, "H1", "FERMA", tf, lato)
            chk("T2 RW %s %s niente falso positivo contro N1 giorni" % (tf, lato), r["verdetto"] not in ("EFFETTO", "CONTRARIO"),
                "P %.3f n %d surr %.3f [%.3f;%.3f] %s" % (r["p"], r["n"], r["smed"], r["sq025"], r["sq975"], r["verdetto"]))
        for lato in ("giu", "su"):
            r = riga(Rr, "H2", "FERMA", tf, lato)
            chk("T2 RW H2 %s %s niente falso positivo" % (tf, lato), r["verdetto"] not in ("EFFETTO", "CONTRARIO"),
                "P_RT %.3f null %.3f n %d %s" % (r["p"], r["n0"], r["n"], r["verdetto"]))
    # T6 FERMA vs VIVA
    for tf in ("M5", "M15", "H1"):
        a = set(zip(diag[("FERMA", tf)]["k"].tolist(), diag[("FERMA", tf)]["lato_k"].tolist()))
        b = set(zip(diag[("VIVA", tf)]["k"].tolist(), diag[("VIVA", tf)]["lato_k"].tolist()))
        quota = len(a & b) / max(1, len(a | b))
        pf = riga(Rr, "H1", "FERMA", tf, "long")["p"]; pv = riga(Rr, "H1", "VIVA", tf, "long")["p"]
        chk("T6 FERMA~VIVA %s: eventi comuni fra 85%% e 100%% esclusi (vicine ma non identiche)" % tf,
            0.85 <= quota < 1.0, "comuni %.3f, P long %.3f vs %.3f (dP senza soglia)" % (quota, pf, pv))
    log("   (%.0f s)" % (time.time() - t0))

    # T3 rimbalzo piantato alla EMA200 D1 FERMA
    pr = sint_piantato(int(7000 * scala), seed=21)
    Rp, _, _, _, _, _ = misura(pr, "PIANT", "UTC1", ("FERMA", "EMA100"), nsurr, seed=6, regimi={}, verbose=False, tfs=("M5",))
    for lato in ("long", "short"):
        r = riga(Rp, "H1", "FERMA", "M5", lato)
        chk("T3 PIANTATO M5 %s: effetto >= +0,10 e EFFETTO contro N1 giorni" % lato,
            r["eff"] >= 0.10 and r["verdetto"] == "EFFETTO",
            "P %.3f n %d surr %.3f [%.3f;%.3f] %s" % (r["p"], r["n"], r["smed"], r["sq025"], r["sq975"], r["verdetto"]))
        rp = riga(Rp, "H1", "EMA100", "M5", lato)
        log("   [INFO] piantato sulla 200, letto con la EMA100 D1 (placebo) %s: P %.3f n %d -> %s" % (lato, rp["p"], rp["n"], rp["verdetto"]))
    log("   (%.0f s)" % (time.time() - t0))

    # T5 giorni di trend + gap, nessun livello: contro N0 puo' scostarsi, contro N1 NO
    tg = sint_rw(int(5200 * scala), seed=31, drift_giorno_sd=0.03, gap_sd=10.0)
    Rt, dgt, _, _, _, _ = misura(tg, "TREND", "UTC1", ("FERMA",), nsurr, seed=7, regimi={}, verbose=False, tfs=("M5", "M15"))
    for tf in ("M5", "M15"):
        for lato in ("long", "short"):
            r = riga(Rt, "H1", "FERMA", tf, lato)
            chk("T5 TREND+GAP %s %s: niente EFFETTO/CONTRARIO contro N1 giorni" % (tf, lato),
                r["verdetto"] not in ("EFFETTO", "CONTRARIO"),
                "P %.3f (N0 0,500, scarto %+.3f) n %d surr %.3f [%.3f;%.3f] %s" %
                (r["p"], r["p"] - 0.5, r["n"], r["smed"], r["sq025"], r["sq975"], r["verdetto"]))
    log("   [INFO] TREND+GAP M5: tocchi in gap d'apertura %d su %d" % (dgt[("FERMA", "M5")]["n_gap"], dgt[("FERMA", "M5")]["n_ev"]))
    log("   (%.0f s)" % (time.time() - t0))

    # T7 look-ahead: cambiare il giorno i non cambia la FERMA dei giorni <= i; la VIVA della barra k
    #    non dipende dalla barra k
    small = sint_rw(900, seed=41)
    g = giorno_label(small["t"]); di, st_d, en_d = indice_giorni(g)
    Cd = small["c"][en_d - 1]
    b = barre(small["o"], small["h"], small["l"], small["c"], di, small["t"], 5)
    Ed = R.ema(Cd, 200)
    rf, _ = livelli_barra(b, Ed, "FERMA"); rv, _ = livelli_barra(b, Ed, "VIVA")
    gi = 700
    c2 = small["c"].copy(); c2[st_d[gi]:en_d[gi]] += 500.0
    b2 = dict(b); b2["c"] = c2[b["en"] - 1]
    Ed2 = R.ema(c2[en_d - 1], 200)
    rf2, _ = livelli_barra(b2, Ed2, "FERMA"); rv2, _ = livelli_barra(b2, Ed2, "VIVA")
    mk = b["day"] <= gi
    kk = np.flatnonzero(b["day"] == gi)[10]
    chk("T7 FERMA: cambiare il giorno i non tocca la linea dei giorni <= i", np.allclose(rf[mk], rf2[mk], equal_nan=True),
        "giorno %d" % gi)
    chk("T7 FERMA: la linea del giorno i+1 invece cambia (lo strumento non e' cieco)",
        not np.allclose(rf[b["day"] == gi + 1], rf2[b["day"] == gi + 1]), "")
    c3 = small["c"].copy(); c3[b["st"][kk]:b["en"][kk]] += 300.0
    b3 = dict(b); b3["c"] = c3[b["en"] - 1]
    rv3, _ = livelli_barra(b3, Ed, "VIVA")
    chk("T7 VIVA: la linea di contatto della barra k non dipende dalla barra k", rv3[kk] == rv[kk] and rv3[kk + 1] != rv[kk + 1],
        "k=%d" % kk)

    # T8 orologio: +60 min cambia i giorni D1 e quindi gli eventi FERMA M5
    sh = dict(rw); sh["t"] = rw["t"] + 60
    rA, dA, _, _, _, _ = misura(rw, "A", "UTC1", ("FERMA",), 0, 1, regimi={}, verbose=False, tfs=("M5",))
    rB, dB, _, _, _, _ = misura(sh, "B", "UTC1", ("FERMA",), 0, 1, regimi={}, verbose=False, tfs=("M5",))
    chk("T8 OROLOGIO: feed spostato di 1 h cambia gli eventi FERMA M5",
        dA[("FERMA", "M5")]["n_ev"] != dB[("FERMA", "M5")]["n_ev"] or
        not np.array_equal(dA[("FERMA", "M5")]["k"], dB[("FERMA", "M5")]["k"]),
        "eventi %d -> %d" % (dA[("FERMA", "M5")]["n_ev"], dB[("FERMA", "M5")]["n_ev"]))

    # T9/T10 equivalenza con ema200_rimbalzo (EMA del TF, stesso input, filtro spento)
    rw2 = R.sintetico_rw(3_000_000, seed=13)
    bb = R.barre_da_m1(rw2["t"], rw2["o"], rw2["h"], rw2["l"], rw2["c"], 60)
    bb["day"] = np.arange(len(bb["c"]))
    A = R.atr(bb); E = R.ema(bb["c"], 200); yrs = R.anni_di(rw2["t"])
    vb = np.arange(len(bb["c"])) >= R.WARMUP
    old2 = R.eventi_h2(rw2["h"], rw2["l"], bb, E, A, yrs)
    new2 = eventi_h2(rw2["h"], rw2["l"], bb, E, A, yrs, vb, 0.0)
    cod2 = {"RT": 0, "RA": 1, "AMB": 2, "TO": 3}
    o2 = [(0 if x[0] == "giu" else 1, cod2[x[2]], round(x[3], 9)) for x in old2]
    n2 = list(zip(new2["lato"].tolist(), new2["es"].tolist(), [round(v, 9) for v in new2["null"].tolist()]))
    chk("T9 H2 a salti == H2 a ciclo di ema200_rimbalzo", o2 == n2, "eventi %d vs %d" % (len(o2), len(n2)))
    old1 = R.eventi_h1(rw2["h"], rw2["l"], bb, E, A, yrs)
    Ep = np.insert(E[:-1], 0, np.nan)
    new1 = eventi_h1(rw2["o"], rw2["h"], rw2["l"], bb, Ep, E, A, yrs, vb, 0.0)
    cod1 = {"B": 0, "P": 1, "AMB": 2, "TO": 3}
    o1 = sorted([(0 if x[0] == "long" else 1, tuple(cod1[x[2][c]] for c in CELLE)) for x in old1])
    n1 = sorted(zip(new1["lato"].tolist(), [tuple(r) for r in new1["es"].tolist()]))
    chk("T10 H1 == ema200_rimbalzo (stessi esiti su tutte le 6 celle)", o1 == n1, "eventi %d vs %d" % (len(o1), len(n1)))

    # T11 il surrogato conserva i giorni interi
    g = giorno_label(rw["t"]); di, st_d, en_d = indice_giorni(g)
    o, h, l, c, ts, dn, stn, enn, idx = surrogato_giorni(rw, st_d, en_d, np.random.default_rng(3), rendimenti(rw))
    r0 = np.sort(np.log(np.maximum.reduceat(rw["h"], st_d) / np.minimum.reduceat(rw["l"], st_d)))
    r1 = np.sort(np.log(np.maximum.reduceat(h, stn) / np.minimum.reduceat(l, stn)))
    chk("T11 surrogato a giorni: escursione di ogni giorno conservata", np.allclose(r0, r1, atol=1e-9),
        "giorni %d" % len(st_d))
    chk("T11b surrogato: minuto del giorno conservato", np.array_equal(((ts + 60) % 1440), ((rw["t"][idx] + 60) % 1440)), "")

    # T13 mutazione X
    r1 = riga(Rr, "H1", "FERMA", "M5", "long"); r2 = riga(Rr, "H1", "FERMA", "M5", "long", "X0.25_Y1.00")
    chk("T13 MUTAZIONE X 1,0 -> 0,25 sposta P di > 0,15", r2["p"] - r1["p"] > 0.15, "%.3f -> %.3f" % (r1["p"], r2["p"]))

    # T14 feed piatto: un tratto senza movimento non arma eventi con ATR ~ 0
    fl = sint_rw(900, seed=51)
    i0 = 650 * 1440; i1 = i0 + 3 * 1440
    for k_ in ("o", "h", "l", "c"):
        fl[k_] = fl[k_].copy(); fl[k_][i0:i1] = fl["c"][i0 - 1]
    gF = giorno_label(fl["t"]); diF, stF, enF = indice_giorni(gF)
    resF, amF, _ = passata(fl["o"], fl["h"], fl["l"], fl["c"], fl["t"], diF, stF, enF, R.anni_di(fl["t"]), ("FERMA",))
    e1 = resF[("FERMA", "M5")][0]
    chk("T14 FEED PIATTO: nessun evento con ATR sotto il filtro", bool(np.all(e1["A"] >= ATR_FILTRO * amF["M5"])) if len(e1["A"]) else True,
        "eventi %d, ATR min %.3f, soglia %.3f" % (len(e1["A"]), float(e1["A"].min()) if len(e1["A"]) else float("nan"), ATR_FILTRO * amF["M5"]))

    log("AUTOTEST: %d/%d  (%.0f s)" % (ok, tot, time.time() - t0))
    return ok == tot


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--autotest", action="store_true")
    ap.add_argument("--scala", type=float, default=1.0)
    ap.add_argument("--nsurr-autotest", type=int, default=30)
    ap.add_argument("--dataset", choices=list(R.DATASETS))
    ap.add_argument("--giorno", default="UTC1", choices=["UTC1", "NYCLOSE"])
    ap.add_argument("--cache", default=os.path.join(os.getcwd(), "cache_m1"))
    ap.add_argument("--uscita", default=os.getcwd())
    ap.add_argument("--nsurr", type=int, default=200)
    ap.add_argument("--aggrega", default="", help="cartella con i GREZZI_*.npz: lettura aggregata")
    a = ap.parse_args()
    if a.aggrega:
        aggrega(a.aggrega, a.giorno)
        sys.exit(0)
    if a.autotest:
        sys.exit(0 if autotest(a.nsurr_autotest, a.scala) else 2)
    repo = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    livelli = LIVELLI if a.giorno == "UTC1" else ("FERMA",)
    r = corri(a.dataset, a.cache, a.uscita, a.giorno, a.nsurr, livelli, repo)
    sys.exit(2 if r is None else 0)


if __name__ == "__main__":
    main()
