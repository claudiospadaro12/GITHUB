#!/usr/bin/env python3
# =====================================================================
#  MARCATORE_EMA200_FOREX28_v1
#  ema200_forex28.py -- EMA200 a H4 e D1 sulle coppie forex: il PRIMO TOCCO
#  misurato come FENOMENO, pooled su piu' coppie (involucro).
#
#  Criteri CONGELATI prima dei numeri:
#    report/EMA200_H4_D1_FOREX28_CRITERI_2026-10-03.md  (commit 1576e01b, errata 0205a221)
#  Se il codice e il file divergono, VINCE IL FILE e il codice e' sbagliato.
#
#  IMPORTA (mai modificati) backtest_pipeline/ema200_rimbalzo.py (R) e
#  backtest_pipeline/ema200_d1_su_m5.py (D). Aggiunge SOLO: dati forex pooled,
#  tempo/livello/cluster degli eventi, asse di allineamento, IC a blocchi di
#  mese, M30, D1 con weekend->lunedi', G-OROLOGIO per feed, G-DATI.
#  NON e' un backtest: niente PF, equity, stop in pip, costo nella P, taglie.
#
#  Uso:
#    python3 ema200_forex28.py --autotest
#    python3 ema200_forex28.py --corri A6 --cache DIR --uscita DIR   (autotest PRIMA)
#  Richiede numpy. File ASCII puro. Codici: 0 ok, 2 invalido (autotest/cancello).
# =====================================================================
import argparse, csv, math, os, sys, time, urllib.request
import concurrent.futures as cf
import multiprocessing as mp
import datetime as dt
import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import ema200_rimbalzo as R   # noqa: E402
import ema200_d1_su_m5 as D   # noqa: E402

VERSIONE = "EMA200_FOREX28_v1"
CRITERI = "report/EMA200_H4_D1_FOREX28_CRITERI_2026-10-03.md"
TF_MIN = {"M30": 30, "H1": 60, "H4": 240, "D1": 1440}
TF_PRIM = ("H4", "D1")
TF_RIF = ("M30", "H1")
CTX = {"M30": "H1", "H1": "H4", "H4": "D1", "D1": "H4"}       # criteri sez. 8
NSURR = {"H4": 100, "D1": 100, "M30": 40, "H1": 40}            # criteri sez. 5
WARMUP, N_SEP, D_MIN, HORIZON = R.WARMUP, R.N_SEP, R.D_MIN, R.HORIZON
XS, YS = R.XS, R.YS
CELLE = [(x, y) for y in YS for x in XS]                       # stesso ordine di D.CELLE
IPRIM = CELLE.index((1.0, 1.0))
ICOLL = CELLE.index((0.25, 1.0))
ES = {"B": 0, "P": 1, "AMB": 2, "TO": 3}
ATR_FILTRO = 0.1
N_MIN = 150
N_BOOT = 2000
SOGLIA_REG = 0.05                                              # criteri 7.2 (coppia-anno)
ANCORE_FX = (420, 480, 795, 810, 900, 960, 1140)               # criteri 2.3 (minuti UTC d'inverno)
CLS_NOME = ("TORO", "LATERALE", "ORSO")

# --- fonte A: mirror Oanda FutureSharks (criteri sez. 1.1) ------------
URL_A = R.BASE + "/currencies/oanda/%s/%d/oanda-%s-%d-%d.csv"
COPPIE_A = {"EURUSD": "EUR_USD", "EURJPY": "EUR_JPY", "GBPUSD": "GBP_USD",
            "AUDUSD": "AUD_USD", "AUDJPY": "AUD_JPY", "USDCAD": "USD_CAD"}
MESI_A = [(y, m) for y in range(2005, 2021) for m in range(1, 13) if (y, m) <= (2020, 5)]
UNIVERSO28 = ("AUDCAD AUDCHF AUDJPY AUDNZD AUDUSD CADCHF CADJPY CHFJPY EURAUD EURCAD EURCHF EURGBP EURJPY EURNZD "
              "EURUSD GBPAUD GBPCAD GBPCHF GBPJPY GBPNZD GBPUSD NZDCAD NZDCHF NZDJPY NZDUSD USDCAD USDCHF USDJPY").split()


def log(s=""):
    sys.stdout.write(s + "\n")
    sys.stdout.flush()


# ---------------------------------------------------------------------
# 1. DATI
# ---------------------------------------------------------------------
def scarica(url, cache):
    fn = os.path.join(cache, url.rsplit("/", 1)[-1])
    if os.path.exists(fn) and os.path.getsize(fn) > 0:
        return fn
    err = None
    for _ in range(4):
        try:
            with urllib.request.urlopen(url, timeout=180) as r:
                d = r.read()
            with open(fn + ".part", "wb") as fh:
                fh.write(d)
            os.replace(fn + ".part", fn)
            return fn
        except Exception as e:      # noqa: BLE001
            err = e
            time.sleep(2)
    log("   NON RAGGIUNTO: %s (%s)" % (url, err))
    return None


def scarica_a(cache, nthread=8):
    os.makedirs(cache, exist_ok=True)
    jobs = []
    for nome, sym in COPPIE_A.items():
        for (y, m) in MESI_A:
            jobs.append(URL_A % (sym, y, sym, y, m))
    mancano = 0
    with cf.ThreadPoolExecutor(nthread) as ex:
        for fn in ex.map(lambda u: scarica(u, cache), jobs):
            if fn is None:
                mancano += 1
    return len(jobs), mancano


def carica_coppia_a(nome, cache):
    """M1 UTC della coppia (cache .npz). Ritorna dict t,o,h,l,c e il numero di file letti."""
    npz = os.path.join(cache, "m1fx_%s.npz" % nome)
    if os.path.exists(npz):
        z = np.load(npz)
        return {k: z[k] for k in ("t", "o", "h", "l", "c")}
    sym = COPPIE_A[nome]
    parti = []
    for (y, m) in MESI_A:
        fn = scarica(URL_A % (sym, y, sym, y, m), cache)
        if fn is None:
            continue
        tx = open(fn, "rb").read().decode("ascii", "replace")
        T, O, H, L, C = R.leggi_testo(tx, "nome")
        parti.append((np.array(T, dtype=np.int64), np.array(O), np.array(H), np.array(L), np.array(C)))
    T = np.concatenate([p[0] for p in parti]); O = np.concatenate([p[1] for p in parti])
    H = np.concatenate([p[2] for p in parti]); L = np.concatenate([p[3] for p in parti])
    C = np.concatenate([p[4] for p in parti])
    m = R._pulisci(T, O, H, L, C, "UTC")
    np.savez(npz, **m)
    return m


def mesi_di(t):
    """indice di mese di calendario UTC per minuti-epoch."""
    return np.asarray(t, dtype="int64").astype("datetime64[m]").astype("datetime64[M]").astype(np.int64)


def classi_anno(m):
    """classe per anno solare della coppia: 0 TORO >= +5%, 1 LATERALE, 2 ORSO <= -5% (criteri 7.2)."""
    yrs = R.anni_di(m["t"])
    out = {}
    for y in np.unique(yrs):
        sel = np.flatnonzero(yrs == y)
        if len(sel) < 1000:
            continue
        r = m["c"][sel[-1]] / m["o"][sel[0]] - 1
        out[int(y)] = 0 if r >= SOGLIA_REG else (2 if r <= -SOGLIA_REG else 1)
    return out


def mesi_esclusi(m):
    """G-DATI (errata 1): mesi con barre M1 < 50% della mediana dei mesi della coppia."""
    mm = mesi_di(m["t"])
    um, cnt = np.unique(mm, return_counts=True)
    med = float(np.median(cnt))
    bad = um[cnt < 0.5 * med]
    return set(int(x) for x in bad), um, cnt, med


def nome_mese(k):
    return str(np.datetime64(int(k), "M"))


# --- fonte B: HistData M1 forex (zip) dal PC di backtest (criteri sez. 1.2) ------
ANNO_MIN_B = 2007          # regola USA dal 2007: prima non e' implementata (criteri 1.2)


def carica_coppia_histdata(nome, cartella, cache=None):
    """zip HistData `HISTDATA_COM_ASCII_<COPPIA>_M1_<AAAA|AAAAMM>.zip` -> M1 UTC (NY con ora legale), solo anni >= 2007."""
    import glob, zipfile
    npz = os.path.join(cache or cartella, "m1hd_%s.npz" % nome)
    if os.path.exists(npz):
        z = np.load(npz)
        return {k: z[k] for k in ("t", "o", "h", "l", "c")}
    parti = []
    for fn in sorted(glob.glob(os.path.join(cartella, "HISTDATA_COM_ASCII_%s_M1_*.zip" % nome))):
        per = os.path.basename(fn).split("_M1_")[1].split(".")[0]
        if int(per[:4]) < ANNO_MIN_B:
            continue
        with zipfile.ZipFile(fn) as z:
            for nm in z.namelist():
                if not nm.lower().endswith(".csv"):
                    continue
                tx = z.read(nm).decode("ascii", "replace")
                T, O, H, L, C = R.leggi_testo(tx, "histdata")
                parti.append((np.array(T, dtype=np.int64), np.array(O), np.array(H), np.array(L), np.array(C)))
    if not parti:
        return None
    T = np.concatenate([x[0] for x in parti]); O = np.concatenate([x[1] for x in parti])
    H = np.concatenate([x[2] for x in parti]); L = np.concatenate([x[3] for x in parti])
    C = np.concatenate([x[4] for x in parti])
    m = R._pulisci(T, O, H, L, C, "NY")
    np.savez(npz, **m)
    return m


# ---------------------------------------------------------------------
# 2. OROLOGIO E BARRE
# ---------------------------------------------------------------------
def off_ny(t):
    off = np.full(len(t), 300, dtype=np.int64)
    if len(t):
        y0 = (R.EPOCH + dt.timedelta(minutes=int(t.min()))).year
        y1 = (R.EPOCH + dt.timedelta(minutes=int(t.max()))).year
        for y in range(y0 - 1, y1 + 1):
            s, e = R._us_dst_bounds(y)
            off[(t >= s + 300) & (t < e + 240)] = 240
    return off


def bin_ids(t, tf, modo="UTC1"):
    t = np.asarray(t, dtype=np.int64)
    if tf == "D1":
        return D.giorno_label(t, modo)            # sabato/domenica -> lunedi' (criteri 2.2)
    tfm = TF_MIN[tf]
    if modo == "UTC1":
        return (t + R.CLOCK_OFFSET_MIN) // tfm
    return (t - off_ny(t) + 420) // tfm           # NYCLOSE: bordi dalle 17:00 di New York


def costruisci_barre(m, tf, modo="UTC1"):
    return R.barre_da_m1(m["t"], m["o"], m["h"], m["l"], m["c"], TF_MIN[tf], bin_id=bin_ids(m["t"], tf, modo))


def cancello_feed(pool_m, ancore=ANCORE_FX):
    """G-OROLOGIO sul profilo POOLED (criteri 2.3)."""
    t = np.concatenate([x["t"] for x in pool_m]); o = np.concatenate([x["o"] for x in pool_m])
    c = np.concatenate([x["c"] for x in pool_m])
    return R.cancello_orologio(dict(t=t, o=o, c=c), ancore)


# ---------------------------------------------------------------------
# 3. EVENTI CON TEMPO E LIVELLO (copia di R.eventi_h1 + filtro ATR + contesto)
# ---------------------------------------------------------------------
def eventi_t(m1h, m1l, b, E, A, thr, yrs, ctx=None):
    """ritorna dict: lato (0 long,1 short), anno, pos (indice M1 del tocco), L, es (n,6 codici), ali (0 contro,1 ali,2 NA).
       thr = soglia ATR (criteri 2.4); thr = 0 -> identico a R.eventi_h1 (autotest F1)."""
    nb = len(b["c"])
    Ep = np.insert(E[:-1], 0, np.nan)
    Ap = np.insert(A[:-1], 0, np.nan)
    with np.errstate(invalid="ignore", divide="ignore"):
        clean_up = b["l"] > Ep
        clean_dn = b["h"] < Ep
        okA = (A > 0) & (A >= thr)
        dist = np.where(okA, (b["c"] - E) / np.where(okA, A, 1.0), np.nan)
    clean_up[:1] = False
    clean_dn[:1] = False
    ru = R._run_len(clean_up)
    rd = R._run_len(clean_dn)
    dmax = R._roll_ext(np.nan_to_num(dist, nan=0.0), N_SEP, np.max)
    dmin = R._roll_ext(np.nan_to_num(dist, nan=0.0), N_SEP, np.min)
    k = np.arange(nb)
    arm_up = np.zeros(nb, bool)
    arm_dn = np.zeros(nb, bool)
    arm_up[1:] = (ru[:-1] >= N_SEP) & (dmax[:-1] >= D_MIN)
    arm_dn[1:] = (rd[:-1] >= N_SEP) & (dmin[:-1] <= -D_MIN)
    with np.errstate(invalid="ignore"):
        valid = (k >= WARMUP) & np.isfinite(Ap) & (Ap > 0) & (Ap >= thr)
        tu = np.flatnonzero(arm_up & valid & (b["l"] <= Ep))
        td = np.flatnonzero(arm_dn & valid & (b["h"] >= Ep))
    lato_l, pos_l, L_l, es_l = [], [], [], []
    for lato, ks in ((0, tu), (1, td)):
        for kk in ks:
            L = Ep[kk]
            a = Ap[kk]
            s0, e0 = b["st"][kk], b["en"][kk]
            eh = b["en"][min(kk + HORIZON - 1, nb - 1)]
            if lato == 0:
                hi = m1h[s0:eh]; lo = m1l[s0:eh]; Lx = L
            else:
                hi = -m1l[s0:eh]; lo = -m1h[s0:eh]; Lx = -L
            w = np.flatnonzero(lo[: e0 - s0] <= Lx)
            if len(w) == 0:
                continue
            t0 = int(w[0])
            runmin = np.minimum.accumulate(lo[t0:])
            runmax = np.maximum.accumulate(hi[t0 + 1:]) if t0 + 1 < len(hi) else np.array([])
            nrest = len(runmin)
            codici = []
            for Y in YS:
                ip = R._primo(runmin, Lx - Y * a, False)
                for X in XS:
                    ib = R._primo(runmax, Lx + X * a, True) + 1 if len(runmax) else nrest
                    ib = ib if ib <= nrest - 1 else nrest
                    ipp = ip if ip < nrest else nrest
                    if ib == nrest and ipp == nrest:
                        r = "TO"
                    elif ib < ipp:
                        r = "B"
                    elif ipp < ib:
                        r = "P"
                    else:
                        r = "AMB"
                    codici.append(ES[r])
            lato_l.append(lato); pos_l.append(s0 + t0); L_l.append(float(L)); es_l.append(codici)
    n = len(lato_l)
    ev = dict(lato=np.array(lato_l, dtype=np.int8), pos=np.array(pos_l, dtype=np.int64),
              L=np.array(L_l, dtype=np.float64), es=np.array(es_l, dtype=np.int8).reshape(n, len(CELLE)))
    ev["anno"] = np.array([int(yrs[p]) for p in pos_l], dtype=np.int16) if n else np.zeros(0, np.int16)
    ev["ali"] = np.full(n, 2, dtype=np.int8)
    if ctx is not None and n:
        cst, Ec = ctx
        j = np.searchsorted(cst, ev["pos"], side="right") - 1
        jc = j - 1
        ok = jc >= WARMUP
        Ecv = Ec[np.maximum(jc, 0)]
        lg = ev["lato"] == 0
        al = np.where(lg, Ecv < ev["L"], Ecv > ev["L"]).astype(np.int8)
        ev["ali"] = np.where(ok, al, 2).astype(np.int8)
    return ev


def eventi_come_R(m1h, m1l, b, E, A, yrs):
    """gli eventi di R.eventi_h1 trasformati in (lato, codici) per il confronto F1."""
    out = []
    for (ld, an, es) in R.eventi_h1(m1h, m1l, b, E, A, yrs):
        out.append((0 if ld == "long" else 1, tuple(ES[es[c]] for c in CELLE)))
    return out


# ---------------------------------------------------------------------
# 4. LAVORO PER COPPIA (reale + surrogati)
# ---------------------------------------------------------------------
def riassumi(ev, cls_anno):
    """compatta gli eventi di UN surrogato: cells (2,6,2), reg (2,3,2), ax (2,4)."""
    cells = np.zeros((2, len(CELLE), 2), dtype=np.int64)
    reg = np.zeros((2, 3, 2), dtype=np.int64)
    ax = np.zeros((2, 4), dtype=np.int64)
    if len(ev["lato"]) == 0:
        return cells, reg, ax
    cl = np.array([cls_anno.get(int(a), -1) for a in ev["anno"]], dtype=np.int64)
    for lato in (0, 1):
        sl = ev["lato"] == lato
        es = ev["es"][sl]
        for c in range(len(CELLE)):
            cells[lato, c, 0] = int((es[:, c] == 0).sum())
            cells[lato, c, 1] = int((es[:, c] == 1).sum())
        ep = ev["es"][sl, IPRIM]
        for q in range(3):
            mk = cl[sl] == q
            reg[lato, q, 0] = int(((ep == 0) & mk).sum())
            reg[lato, q, 1] = int(((ep == 1) & mk).sum())
        al = ev["ali"][sl]
        ax[lato, 0] = int(((ep == 0) & (al == 1)).sum()); ax[lato, 1] = int(((ep == 1) & (al == 1)).sum())
        ax[lato, 2] = int(((ep == 0) & (al == 0)).sum()); ax[lato, 3] = int(((ep == 1) & (al == 0)).sum())
    return cells, reg, ax


def _prepara(m, tf, modo, ctx_on):
    b = costruisci_barre(m, tf, modo)
    A = R.atr(b)
    E = R.livello(b, "EMA200")
    amed = float(np.nanmedian(A[WARMUP:])) if len(A) > WARMUP else float("nan")
    ctx = None
    if ctx_on:
        bc = costruisci_barre(m, CTX[tf], modo)
        ctx = (bc["st"], R.livello(bc, "EMA200"))
    return b, A, E, amed, ctx


def calcola_coppia(nome, m, tf, nsurr, seed, idx_coppia=0, varianti=True, cls_anno=None, verbose=False):
    """reale (PRIM, NOFILT, NYCLOSE) + riassunti dei surrogati. m: dict M1 UTC."""
    t0 = time.time()
    cls_anno = cls_anno if cls_anno is not None else classi_anno(m)
    yrs = R.anni_di(m["t"])
    b, A, E, amed, ctx = _prepara(m, tf, "UTC1", True)
    thr = ATR_FILTRO * amed
    res = dict(nome=nome, tf=tf, nbar=len(b["c"]), amed=amed, thr=thr, cls=cls_anno)
    ev = {}
    ev["PRIM"] = eventi_t(m["h"], m["l"], b, E, A, thr, yrs, ctx)
    if varianti:
        ev["NOFILT"] = eventi_t(m["h"], m["l"], b, E, A, 0.0, yrs, ctx)
        if tf in TF_PRIM:
            bn, An, En, amn, _ = _prepara(m, tf, "NYCLOSE", False)
            ev["NYCLOSE"] = eventi_t(m["h"], m["l"], bn, En, An, ATR_FILTRO * amn, yrs, None)
            res["nbar_nyclose"] = len(bn["c"])
    for v in ev:
        e = ev[v]
        e["tmin"] = m["t"][e["pos"]] if len(e["pos"]) else np.zeros(0, np.int64)
        e["reg"] = np.array([cls_anno.get(int(a), -1) for a in e["anno"]], dtype=np.int8)
        e["pair"] = np.full(len(e["lato"]), idx_coppia, dtype=np.int16)
    res["ev"] = ev
    S = np.zeros((nsurr, 2, len(CELLE), 2), dtype=np.int64)
    SR = np.zeros((nsurr, 2, 3, 2), dtype=np.int64)
    SA = np.zeros((nsurr, 2, 4), dtype=np.int64)
    rng = np.random.default_rng(seed)
    for i in range(nsurr):
        s, bs = R.surrogato(m, b, rng)
        As = R.atr(bs)
        Es = R.livello(bs, "EMA200")
        ys = R.anni_di(s["t"])
        bcs = costruisci_barre(s, CTX[tf], "UTC1")
        ctxs = (bcs["st"], R.livello(bcs, "EMA200"))
        e = eventi_t(s["h"], s["l"], bs, Es, As, thr, ys, ctxs)
        S[i], SR[i], SA[i] = riassumi(e, cls_anno)
        del s, bs
    res["S"], res["SR"], res["SA"] = S, SR, SA
    res["sec"] = time.time() - t0
    if verbose:
        log("   %s %s: barre %d, eventi PRIM %d, %d surrogati, %.0f s" % (nome, tf, res["nbar"], len(ev["PRIM"]["lato"]), nsurr, res["sec"]))
    return res


def calcola_placebo(nome, m, tf, tipo, nsurr, seed, idx_coppia=0, cls_anno=None):
    """placebo (criteri 5): livello EMA100/150/250/SMA200 al posto della EMA200, CON surrogati propri."""
    cls_anno = cls_anno if cls_anno is not None else classi_anno(m)
    yrs = R.anni_di(m["t"])
    b = costruisci_barre(m, tf, "UTC1")
    A = R.atr(b)
    amed = float(np.nanmedian(A[WARMUP:])) if len(A) > WARMUP else float("nan")
    thr = ATR_FILTRO * amed
    E = R.livello(b, tipo)
    ev = eventi_t(m["h"], m["l"], b, E, A, thr, yrs, None)
    ev["tmin"] = m["t"][ev["pos"]] if len(ev["pos"]) else np.zeros(0, np.int64)
    ev["pair"] = np.full(len(ev["lato"]), idx_coppia, dtype=np.int16)
    S = np.zeros((nsurr, 2, 2), dtype=np.int64)
    rng = np.random.default_rng(seed)
    for i in range(nsurr):
        s, bs = R.surrogato(m, b, rng)
        As = R.atr(bs)
        Es = R.livello(bs, tipo)
        e = eventi_t(s["h"], s["l"], bs, Es, As, thr, R.anni_di(s["t"]), None)
        for lato in (0, 1):
            ep = e["es"][e["lato"] == lato][:, IPRIM] if len(e["lato"]) else np.zeros(0, np.int8)
            S[i, lato, 0] = int((ep == 0).sum()); S[i, lato, 1] = int((ep == 1).sum())
        del s, bs
    return dict(nome=nome, tf=tf, tipo=tipo, ev=ev, S=S)


def carica_generico(fonte, nome, cache, zipdir=None):
    if fonte == "A":
        return carica_coppia_a(nome, cache)
    return carica_coppia_histdata(nome, zipdir, cache)


def _task_coppia(a):
    fonte, zipdir, nome, cache, tf, nsurr, seed, idx = a
    m = carica_generico(fonte, nome, cache, zipdir)
    return calcola_coppia(nome, m, tf, nsurr, seed, idx)


def _task_placebo(a):
    fonte, zipdir, nome, cache, tf, tipo, nsurr, seed, idx = a
    m = carica_generico(fonte, nome, cache, zipdir)
    return calcola_placebo(nome, m, tf, tipo, nsurr, seed, idx)


# ---------------------------------------------------------------------
# 5. CLUSTER, IC A BLOCCHI DI MESE, CONTEGGI
# ---------------------------------------------------------------------
def valute(nome_coppia):
    return nome_coppia[:3], nome_coppia[3:]


def n_cluster(days, pair_idx, nomi):
    """cluster = componenti connesse (stesso giorno, coppie che condividono una valuta). Ogni coppia e' un arco
       fra le sue due valute; le componenti del grafo delle valute = i cluster."""
    days = np.asarray(days); pair_idx = np.asarray(pair_idx)
    if len(days) == 0:
        return 0
    tot = 0
    ordine = np.argsort(days, kind="stable")
    d_s = days[ordine]; p_s = pair_idx[ordine]
    bordi = np.flatnonzero(np.diff(d_s)) + 1
    for blocco in np.split(p_s, bordi):
        par = {}

        def trova(x):
            while par[x] != x:
                par[x] = par[par[x]]
                x = par[x]
            return x
        for p in set(int(x) for x in blocco):
            a, b2 = valute(nomi[p])
            par.setdefault(a, a); par.setdefault(b2, b2)
            ra, rb = trova(a), trova(b2)
            if ra != rb:
                par[ra] = rb
        tot += len(set(trova(x) for x in par))
    return tot


def boot_mesi(mese, bind, rng, nb=N_BOOT):
    """bootstrap a blocchi di mese su P = sum B / sum (B+P). bind: 1 se B, 0 se P (solo eventi risolti)."""
    if len(mese) == 0:
        return float("nan"), float("nan"), 0
    um, inv = np.unique(mese, return_inverse=True)
    bd = np.bincount(inv, weights=bind.astype(float))
    nd = np.bincount(inv).astype(float)
    M = len(um)
    W = rng.multinomial(M, np.full(M, 1.0 / M), size=nb).astype(float)
    num = W @ bd
    den = W @ nd
    ok = den > 0
    ps = num[ok] / den[ok]
    return float(np.quantile(ps, 0.025)), float(np.quantile(ps, 0.975)), M


def boot_mesi_delta(mese, bind, ali, rng, nb=N_BOOT):
    """bootstrap a blocchi di mese su Delta = P_allineato - P_contro."""
    if len(mese) == 0:
        return float("nan"), float("nan")
    um, inv = np.unique(mese, return_inverse=True)
    M = len(um)
    b1 = np.bincount(inv, weights=((bind == 1) & (ali == 1)).astype(float), minlength=M)
    n1 = np.bincount(inv, weights=(ali == 1).astype(float), minlength=M)
    b0 = np.bincount(inv, weights=((bind == 1) & (ali == 0)).astype(float), minlength=M)
    n0 = np.bincount(inv, weights=(ali == 0).astype(float), minlength=M)
    W = rng.multinomial(M, np.full(M, 1.0 / M), size=nb).astype(float)
    d1 = W @ n1; d0 = W @ n0
    ok = (d1 > 0) & (d0 > 0)
    ds = (W @ b1)[ok] / d1[ok] - (W @ b0)[ok] / d0[ok]
    return float(np.quantile(ds, 0.025)), float(np.quantile(ds, 0.975))


def banda(vals):
    v = np.array([x for x in vals if x == x])
    if len(v) == 0:
        return (float("nan"),) * 3
    return float(np.median(v)), float(np.quantile(v, 0.025)), float(np.quantile(v, 0.975))


def concatena(evs):
    keys = ("lato", "anno", "tmin", "es", "ali", "reg", "pair")
    return {k: np.concatenate([e[k] for e in evs]) for k in keys}


def _p_surr(B, P):
    B = np.asarray(B, dtype=float); P = np.asarray(P, dtype=float)
    with np.errstate(invalid="ignore", divide="ignore"):
        return np.where(B + P > 0, B / (B + P), np.nan)


def ic_verdetto(p, ncl, boot_lo, boot_hi):
    """IC del verdetto = il PIU' LARGO fra Wilson su n_cluster e bootstrap a blocchi di mese (criteri 6)."""
    los, his = [], []
    if ncl > 0 and p == p:
        lo_w, hi_w = R.wilson(p * ncl, ncl)
        los.append(lo_w); his.append(hi_w)
    if boot_lo == boot_lo:
        los.append(boot_lo)
    if boot_hi == boot_hi:
        his.append(boot_hi)
    return (min(los) if los else float("nan")), (max(his) if his else float("nan"))


def riga_pool(E, mask, c, nomi, rng, Sb, Sp, extra):
    """una riga: eventi E filtrati da mask, cella c; Sb/Sp = array (nsurr,) di B e P pooled dei surrogati."""
    es = E["es"][mask][:, c]
    B = int((es == 0).sum()); P = int((es == 1).sum())
    AMB = int((es == 2).sum()); TO = int((es == 3).sum())
    n = B + P
    r = dict(n=n, B=B, P=P, AMB=AMB, TO=TO)
    r.update(extra)
    ris = (es == 0) | (es == 1)
    tm = E["tmin"][mask][ris]
    pr = E["pair"][mask][ris]
    r["n_cluster"] = n_cluster((tm + 60) // 1440, pr, nomi)
    r["n_coppie"] = len(set(int(x) for x in pr))
    p = B / n if n else float("nan")
    r["p"] = p
    mese = mesi_di(tm)
    lo_b, hi_b, M = boot_mesi(mese, (es[ris] == 0).astype(int), rng) if n else (float("nan"),) * 2 + (0,)
    r["n_mesi"] = M
    r["ic_boot_lo"], r["ic_boot_hi"] = lo_b, hi_b
    lo, hi = ic_verdetto(p, r["n_cluster"], lo_b, hi_b) if n else (float("nan"), float("nan"))
    r["ic_lo"], r["ic_hi"] = lo, hi
    if Sb is not None:
        ps = _p_surr(Sb, Sp)
        med, q1, q2 = banda(ps)
    else:
        med = q1 = q2 = float("nan")
    r["smed"], r["sq025"], r["sq975"] = med, q1, q2
    r["eff"] = (p - med) if (n and med == med) else float("nan")
    r["verdetto"] = R.verdetto(p, r["n_cluster"], lo, hi, med, q1, q2) if Sb is not None else "descrittivo"
    return r


def aggrega(res, tf, seme=20261003):
    """res: dict nome -> risultato calcola_coppia (stesso tf). Ritorna (righe, righe_asse, righe_coppie)."""
    nomi = sorted(res)
    idx = {n: i for i, n in enumerate(nomi)}
    for n in nomi:                         # indice coppia coerente fra le coppie aggregate
        for v in res[n]["ev"].values():
            v["pair"] = np.full(len(v["lato"]), idx[n], dtype=np.int16)
    rng = np.random.default_rng(seme + TF_MIN[tf])
    S = sum(res[n]["S"] for n in nomi)          # (nsurr,2,6,2)
    SR = sum(res[n]["SR"] for n in nomi)
    SA = sum(res[n]["SA"] for n in nomi)
    righe, asse, coppie = [], [], []
    for var in ("PRIM", "NOFILT", "NYCLOSE"):
        if any(var not in res[n]["ev"] for n in nomi):
            continue
        E = concatena([res[n]["ev"][var] for n in nomi])
        for lato in (0, 1):
            ln = "long" if lato == 0 else "short"
            ml = E["lato"] == lato
            for c, (X, Y) in enumerate(CELLE):
                if var != "PRIM" and c != IPRIM:
                    continue
                r = riga_pool(E, ml, c, nomi, rng, S[:, lato, c, 0], S[:, lato, c, 1],
                              dict(tf=tf, var=var, lato=ln, cella="X%.2f_Y%.2f" % (X, Y), regime="TUTTO", n0=Y / (X + Y)))
                righe.append(r)
            if var == "PRIM":
                for q in range(3):
                    mk = ml & (E["reg"] == q)
                    righe.append(riga_pool(E, mk, IPRIM, nomi, rng, SR[:, lato, q, 0], SR[:, lato, q, 1],
                                           dict(tf=tf, var=var, lato=ln, cella="X1.00_Y1.00", regime=CLS_NOME[q], n0=0.5)))
        if var != "PRIM":
            continue
        # ---- asse allineamento (criteri 8) ----
        for lato in (0, 1):
            ln = "long" if lato == 0 else "short"
            ml = E["lato"] == lato
            ep = E["es"][:, IPRIM]
            ris = ml & ((ep == 0) | (ep == 1)) & (E["ali"] != 2)
            na = int((ml & ((ep == 0) | (ep == 1)) & (E["ali"] == 2)).sum())
            out = dict(tf=tf, lato=ln, na=na)
            for nm, v in (("ali", 1), ("co", 0)):
                mk = ris & (E["ali"] == v)
                B = int((ep[mk] == 0).sum()); P = int((ep[mk] == 1).sum())
                out["B_" + nm], out["P_" + nm] = B, P
                out["p_" + nm] = B / (B + P) if B + P else float("nan")
                out["ncl_" + nm] = n_cluster((E["tmin"][mk] + 60) // 1440, E["pair"][mk], nomi)
            out["delta"] = out["p_ali"] - out["p_co"]
            bind = (ep[ris] == 0).astype(int)
            lo, hi = boot_mesi_delta(mesi_di(E["tmin"][ris]), bind, E["ali"][ris], rng)
            out["ic_lo"], out["ic_hi"] = lo, hi
            ds = []
            for i in range(SA.shape[0]):
                a1 = SA[i, lato, 0] + SA[i, lato, 1]; a0 = SA[i, lato, 2] + SA[i, lato, 3]
                if a1 > 0 and a0 > 0:
                    ds.append(SA[i, lato, 0] / a1 - SA[i, lato, 2] / a0)
            out["smed"], out["sq025"], out["sq975"] = banda(ds)
            nmin = min(out["ncl_ali"], out["ncl_co"])
            out["ncl_min"] = nmin
            out["eff"] = out["delta"] - out["smed"] if out["delta"] == out["delta"] and out["smed"] == out["smed"] else float("nan")
            out["verdetto"] = R.verdetto(out["delta"], nmin, lo, hi, out["smed"], out["sq025"], out["sq975"])
            asse.append(out)
        # ---- per coppia (concordanza, criteri 7.2) ----
        for n in nomi:
            ev = res[n]["ev"]["PRIM"]
            for lato in (0, 1):
                ep = ev["es"][ev["lato"] == lato][:, IPRIM] if len(ev["lato"]) else np.zeros(0, np.int8)
                B = int((ep == 0).sum()); P = int((ep == 1).sum())
                ps = _p_surr(res[n]["S"][:, lato, IPRIM, 0], res[n]["S"][:, lato, IPRIM, 1])
                med, q1, q2 = banda(ps)
                p = B / (B + P) if B + P else float("nan")
                coppie.append(dict(tf=tf, coppia=n, lato="long" if lato == 0 else "short", n=B + P, B=B, P=P, p=p,
                                   smed=med, sq025=q1, sq975=q2, eff=(p - med) if (B + P and med == med) else float("nan")))
    return righe, asse, coppie


# ---------------------------------------------------------------------
# 6. VERDETTO SUL FENOMENO (criteri 7.2), PLACEBO
# ---------------------------------------------------------------------
def segno(x):
    return 0 if (x != x or x == 0) else (1 if x > 0 else -1)


def verdetto_fenomeno(tf, righe, coppie, placebo_verdetti=None, n_coppie_misurate=0):
    """VERO / SENZA CONTENUTO / NON ANCORA MISURATO + motivi (criteri 7.2). Il verdetto usa solo righe PRIM."""
    prim = {(r["lato"], r["regime"]): r for r in righe if r["var"] == "PRIM" and r["cella"] == "X1.00_Y1.00"}
    mot = []
    vl = [prim[(l, "TUTTO")]["verdetto"] for l in ("long", "short")]
    if all(v == "EFFETTO" for v in vl):
        ok = True
        for lato in ("long", "short"):
            e = prim[(lato, "TUTTO")]["eff"]
            for q in CCLS:
                r = prim[(lato, q)]
                if r["n_cluster"] >= N_MIN and segno(r["eff"]) != segno(e):
                    ok = False; mot.append("regime %s %s: segno discorde" % (q, lato))
            cp = [c for c in coppie if c["tf"] == tf and c["lato"] == lato and c["n"] >= 15]
            if cp:
                conc = sum(1 for c in cp if segno(c["eff"]) == segno(e))
                if conc < (2.0 / 3.0) * len(cp):
                    ok = False; mot.append("coppie %s: concordi %d su %d (< 2/3)" % (lato, conc, len(cp)))
        if placebo_verdetti and any(v == "EFFETTO" for v in placebo_verdetti):
            ok = False; mot.append("un placebo esce EFFETTO: effetto di una linea lenta qualsiasi")
        return ("VERO" if ok else "NON ANCORA MISURATO"), mot
    nulli = all(v == "NULLO" for v in vl)
    if nulli and n_coppie_misurate >= 4:
        for lato in ("long", "short"):
            for q in CCLS:
                r = prim[(lato, q)]
                if r["n_cluster"] >= N_MIN and r["verdetto"] != "NULLO":
                    nulli = False; mot.append("regime %s %s non NULLO (%s)" % (q, lato, r["verdetto"]))
        if nulli:
            return "SENZA CONTENUTO (dentro il null)", mot
    for l, v in zip(("long", "short"), vl):
        mot.append("%s: %s (n_cluster %d)" % (l, v, prim[(l, "TUTTO")]["n_cluster"]))
    return "NON ANCORA MISURATO", mot


CCLS = CLS_NOME


def placebo_dovuto(righe, lato):
    """regola criteri 5: placebo con surrogati propri se la primaria e' EFFETTO, o ZONA GRIGIA con |effetto| >= 0,03."""
    r = [x for x in righe if x["var"] == "PRIM" and x["cella"] == "X1.00_Y1.00" and x["regime"] == "TUTTO" and x["lato"] == lato][0]
    return r["verdetto"] == "EFFETTO" or (r["verdetto"] == "ZONA GRIGIA" and r["eff"] == r["eff"] and abs(r["eff"]) >= 0.03)


def aggrega_placebo(pl, tf, tipo, seme=20261003):
    """pl: dict nome -> calcola_placebo. Ritorna righe (long, short) con verdetto proprio."""
    nomi = sorted(pl)
    for i, n in enumerate(nomi):
        pl[n]["ev"]["pair"] = np.full(len(pl[n]["ev"]["lato"]), i, dtype=np.int16)
    E = concatena_semplice([pl[n]["ev"] for n in nomi])
    S = sum(pl[n]["S"] for n in nomi)
    rng = np.random.default_rng(seme + TF_MIN[tf] + 99)
    out = []
    for lato in (0, 1):
        ml = E["lato"] == lato
        r = riga_pool(E, ml, IPRIM, nomi, rng, S[:, lato, 0], S[:, lato, 1],
                      dict(tf=tf, var="PLACEBO", lato="long" if lato == 0 else "short", cella=tipo, regime="TUTTO", n0=0.5))
        out.append(r)
    return out


def concatena_semplice(evs):
    out = {}
    for k in ("lato", "tmin", "es", "pair"):
        out[k] = np.concatenate([e[k] for e in evs])
    return out


# ---------------------------------------------------------------------
# 7. SINTETICI E AUTOTEST
# ---------------------------------------------------------------------
def gen_rw_k(k, ngiorni, rho=0.0, sig=1.0, seed=1, p0=1.0e6):
    """la coppia k (su asse feriale UTC+1, D.minuti_feriali); rho = quota di varianza condivisa col fattore comune."""
    t = D.minuti_feriali(ngiorni)
    n = len(t)
    zc = np.random.default_rng(seed).normal(0, 1, n)
    r2 = np.random.default_rng(seed * 1000 + k + 1)
    inc = sig * (math.sqrt(rho) * zc + math.sqrt(1 - rho) * r2.normal(0, 1, n))
    c = p0 + np.cumsum(inc)
    o = np.insert(c[:-1], 0, p0)
    h, l = R._bridge_hl(o, c, sig, r2)
    return dict(t=t, o=o, h=h, l=l, c=c)


def gen_rw(K, ngiorni, rho=0.0, sig=1.0, seed=1, p0=1.0e6):
    return [gen_rw_k(k, ngiorni, rho, sig, seed, p0) for k in range(K)]


def gen_piantato(ngiorni, forza, tfm=240, ctxm=None, solo_ali=False, sig=1.0, seed=2, p0=1.0e6, kappa=0.0):
    """come R.sintetico_piantato ma su asse feriale allineato ai bordi UTC+1; con condizione di allineamento opzionale."""
    rng = np.random.default_rng(seed)
    t = D.minuti_feriali(ngiorni)
    n = len(t)
    z = rng.normal(0, sig, n).tolist()
    a = 2.0 / 201.0
    atr_c = 1.25 * sig * math.sqrt(tfm)
    p = p0; e = p0; ec = p0; side = 1
    cl = [0.0] * n
    for i in range(n):
        d = (p - e) / atr_c
        drift = 0.0
        if side == 1 and d < 0.15:
            if (not solo_ali) or (ec < p):
                drift = forza * sig
        elif side == -1 and d > -0.15:
            if (not solo_ali) or (ec > p):
                drift = -forza * sig
        p = p + drift + z[i] - kappa * (p - ec)
        cl[i] = p
        j = i + 1
        if j % tfm == 0:
            e = e + a * (p - e)
            side = 1 if p > e else -1
        if ctxm and j % ctxm == 0:
            ec = ec + a * (p - ec)
    c = np.array(cl)
    o = np.insert(c[:-1], 0, p0)
    h, l = R._bridge_hl(o, c, sig, rng)
    return dict(t=t, o=o, h=h, l=l, c=c)


NOMI_TEST = ["EURUSD", "GBPUSD", "AUDUSD", "USDCAD"]


def pool_sintetico(serie, tf, nsurr, seme, nomi=None, varianti=False):
    nomi = nomi or NOMI_TEST[:len(serie)]
    res = {}
    for i, (nm, m) in enumerate(zip(nomi, serie)):
        res[nm] = calcola_coppia(nm, m, tf, nsurr, seme + 7 * i, i, varianti=varianti, cls_anno={})
    return res


def pool_gen(genfun, K, tf, nsurr, seme, varianti=False):
    """come pool_sintetico ma genera una coppia alla volta (memoria): genfun(k) -> dict M1."""
    res = {}
    for i in range(K):
        m = genfun(i)
        res[NOMI_TEST[i]] = calcola_coppia(NOMI_TEST[i], m, tf, nsurr, seme + 7 * i, i, varianti=varianti, cls_anno={})
        del m
    return res


def riga_primaria(righe, lato):
    return [r for r in righe if r["var"] == "PRIM" and r["cella"] == "X1.00_Y1.00" and r["regime"] == "TUTTO" and r["lato"] == lato][0]


class _Cattura:
    """raccoglie i chk() di un blocco: lista di (nome, cond, dettaglio)."""
    def __init__(self):
        self.v = []

    def __call__(self, nome, cond, det):
        self.v.append((nome, bool(cond), det))


def _blk_f0():
    import io, contextlib
    buf = io.StringIO()
    with contextlib.redirect_stdout(buf):
        f0 = R.autotest()
    return [("F0 autotest ema200_rimbalzo.py (21/21)", f0, "importato e rieseguito tale e quale; ultime righe: %s" % " | ".join(buf.getvalue().strip().splitlines()[-3:]))]


def _blk_f1(scala):
    chk = _Cattura()
    rw = gen_rw_k(0, int(5000 * scala), seed=5)
    yrs = R.anni_di(rw["t"])
    for tf in ("H1", "H4", "D1"):
        b = costruisci_barre(rw, tf)
        A = R.atr(b); E = R.livello(b, "EMA200")
        mio = eventi_t(rw["h"], rw["l"], b, E, A, 0.0, yrs, None)
        lista_mia = [(int(mio["lato"][i]), tuple(int(x) for x in mio["es"][i])) for i in range(len(mio["lato"]))]
        lista_R = eventi_come_R(rw["h"], rw["l"], b, E, A, yrs)
        chk("F1 identita' con R.eventi_h1 a %s (6 celle, filtro spento)" % tf, lista_mia == lista_R and len(lista_R) > 0,
            "eventi %d / %d" % (len(lista_mia), len(lista_R)))
    return chk.v


def _blk_f2(rho, scala):
    chk = _Cattura()
    nd2 = int(11400 * scala)
    res = pool_gen(lambda k: gen_rw_k(k, nd2, rho=rho, seed=11 + int(rho * 10)), 4, "H4", 30, 100)
    righe, asse, coppie = aggrega(res, "H4")
    for lato in ("long", "short"):
        r = riga_primaria(righe, lato)
        chk("F2 RW H4 pooled rho=%.1f %s: P ~0,500 (+/-0,04), non EFFETTO/CONTRARIO" % (rho, lato),
            abs(r["p"] - 0.5) <= 0.04 and r["verdetto"] not in ("EFFETTO", "CONTRARIO"),
            "P=%.3f n=%d n_cluster=%d surr %.3f [%.3f;%.3f] %s" % (r["p"], r["n"], r["n_cluster"], r["smed"], r["sq025"], r["sq975"], r["verdetto"]))
    if rho > 0:
        for lato in ("long", "short"):
            r = riga_primaria(righe, lato)
            chk("F2b RW con fattore comune %s: n_cluster < n di almeno il 10%%" % lato, r["n_cluster"] <= 0.9 * r["n"],
                "n=%d n_cluster=%d" % (r["n"], r["n_cluster"]))
    else:
        ntot = sum(riga_primaria(righe, l)["n"] for l in ("long", "short"))
        chk("F2c RW indipendenti: n totale primaria >= 2.000 (>= 1.000 per lato circa)", ntot >= 2000, "n=%d" % ntot)
        # F11 mutazione sugli stessi dati
        rr = riga_primaria(righe, "long")
        rc = [r for r in righe if r["var"] == "PRIM" and r["cella"] == "X0.25_Y1.00" and r["regime"] == "TUTTO" and r["lato"] == "long"][0]
        chk("F11 MUTAZIONE X sposta P di > 0,15", rc["p"] - rr["p"] > 0.15, "%.3f -> %.3f" % (rr["p"], rc["p"]))
    return chk.v


def _blk_f3(scala):
    chk = _Cattura()
    ndp = int(5000 * scala)
    resp = pool_gen(lambda k: gen_piantato(ndp, 0.6, tfm=240, seed=21 + k), 4, "H4", 30, 200)
    righe_p, _, _ = aggrega(resp, "H4")
    for lato in ("long", "short"):
        r = riga_primaria(righe_p, lato)
        chk("F3 PIANTATO rimbalzo H4 %s: EFFETTO e effetto >= +0,10" % lato, r["verdetto"] == "EFFETTO" and r["eff"] >= 0.10,
            "P=%.3f n=%d n_cluster=%d surr %.3f [%.3f;%.3f] %s" % (r["p"], r["n"], r["n_cluster"], r["smed"], r["sq025"], r["sq975"], r["verdetto"]))
    # F3/F12 placebo: il rimbalzo e' sulla 200, EMA100 e EMA250 non lo devono vedere
    for tipo in ("EMA100", "EMA150", "EMA250"):
        pl = {}
        for i in range(4):
            m = gen_piantato(ndp, 0.6, tfm=240, seed=21 + i)
            pl[NOMI_TEST[i]] = calcola_placebo(NOMI_TEST[i], m, "H4", tipo, 20, 300 + 7 * i, i, cls_anno={})
            del m
        for r in aggrega_placebo(pl, "H4", tipo):
            if tipo == "EMA100":
                chk("F12 placebo EMA100 su rimbalzo piantato %s: non EFFETTO, P entro 0,500 +/- 0,05" % r["lato"],
                    r["verdetto"] != "EFFETTO" and abs(r["p"] - 0.5) <= 0.05,
                    "P=%.3f n=%d n_cluster=%d %s" % (r["p"], r["n"], r["n_cluster"], r["verdetto"]))
            elif tipo == "EMA150":
                chk("F12 placebo EMA150 (linea GEMELLA) su rimbalzo piantato %s: LEGGE l'effetto (P >= 0,70, EFFETTO)" % r["lato"],
                    r["verdetto"] == "EFFETTO" and r["p"] >= 0.70,
                    "P=%.3f n=%d n_cluster=%d %s" % (r["p"], r["n"], r["n_cluster"], r["verdetto"]))
            else:
                log("   [INFO] F12 placebo %s su rimbalzo piantato %s: P=%.3f n=%d n_cluster=%d %s (nessuna soglia: n < 150)" %
                    (tipo, r["lato"], r["p"], r["n"], r["n_cluster"], r["verdetto"]))
                chk("F12 placebo EMA250 %s: non EFFETTO" % r["lato"], r["verdetto"] != "EFFETTO",
                    "P=%.3f n=%d n_cluster=%d %s" % (r["p"], r["n"], r["n_cluster"], r["verdetto"]))
    # F10 copertura / n minimo
    Eall = concatena([resp[n]["ev"]["PRIM"] for n in NOMI_TEST])
    sogl = np.percentile(Eall["tmin"], 4)
    mk_piccolo = (Eall["lato"] == 0) & (Eall["tmin"] < sogl)
    mk_pieno = Eall["lato"] == 0
    Sp = sum(resp[n]["S"] for n in NOMI_TEST)
    rp = riga_pool(Eall, mk_piccolo, IPRIM, NOMI_TEST, np.random.default_rng(1), Sp[:, 0, IPRIM, 0], Sp[:, 0, IPRIM, 1],
                   dict(tf="H4", var="PRIM", lato="long", cella="x", regime="TUTTO", n0=0.5))
    rg = riga_pool(Eall, mk_pieno, IPRIM, NOMI_TEST, np.random.default_rng(1), Sp[:, 0, IPRIM, 0], Sp[:, 0, IPRIM, 1],
                   dict(tf="H4", var="PRIM", lato="long", cella="x", regime="TUTTO", n0=0.5))
    chk("F10 n_cluster < 150 -> NON ANCORA MISURATO (e con n_cluster >= 150 no)",
        rp["n_cluster"] < N_MIN and rp["verdetto"] == "NON ANCORA MISURATO" and rg["n_cluster"] >= N_MIN and rg["verdetto"] != "NON ANCORA MISURATO",
        "piccolo: n %d n_cluster %d %s | pieno: n %d n_cluster %d %s" % (rp["n"], rp["n_cluster"], rp["verdetto"], rg["n"], rg["n_cluster"], rg["verdetto"]))
    chk("F10 etichetta di copertura", copertura("A6", 6, "Oanda", "2005-2020") == "6 coppie su 28, Oanda, 2005-2020", copertura("A6", 6, "Oanda", "2005-2020"))
    return chk.v


def _blk_f4(scala):
    chk = _Cattura()
    ndp = int(5000 * scala)
    resn = pool_gen(lambda k: gen_piantato(ndp, -0.6, tfm=240, seed=41 + k), 4, "H4", 30, 400)
    righe_n, _, _ = aggrega(resn, "H4")
    for lato in ("long", "short"):
        r = riga_primaria(righe_n, lato)
        chk("F4 PIANTATO sfondamento H4 %s: CONTRARIO" % lato, r["verdetto"] == "CONTRARIO",
            "P=%.3f n=%d n_cluster=%d surr %.3f [%.3f;%.3f] %s" % (r["p"], r["n"], r["n_cluster"], r["smed"], r["sq025"], r["sq975"], r["verdetto"]))
    return chk.v


def tag_indipendente(m, ev):
    """ricalcola a mano (cicli espliciti) l'etichetta di allineamento H4 -> contesto D1 (asse feriale, giorno = (t+60)//1440)."""
    t = m["t"]; c = m["c"]
    g = (t + 60) // 1440
    ug = np.unique(g)
    ult = np.searchsorted(g, ug, side="right") - 1
    chiusure = [float(c[i]) for i in ult]
    a = 2.0 / 201.0
    emas = []
    e = chiusure[0]
    for x in chiusure:
        e = e + a * (x - e)
        emas.append(e)
    out = []
    for i in range(len(ev["lato"])):
        j = int(np.searchsorted(ug, g[ev["pos"][i]]))
        jc = j - 1
        if jc < WARMUP:
            out.append(2)
        else:
            Ec = emas[jc]
            L = ev["L"][i]
            out.append(int((Ec < L) if ev["lato"][i] == 0 else (Ec > L)))
    return np.array(out, dtype=np.int8)


def _blk_f5(scala):
    chk = _Cattura()
    nda = int(7000 * scala)
    # F5a: etichetta calcolata a mano, indipendente, su random walk
    rw = gen_rw_k(0, int(6000 * scala), seed=15)
    yrs = R.anni_di(rw["t"])
    b = costruisci_barre(rw, "H4"); A = R.atr(b); E = R.livello(b, "EMA200")
    bc = costruisci_barre(rw, "D1"); Ec = R.livello(bc, "EMA200")
    ev = eventi_t(rw["h"], rw["l"], b, E, A, 0.0, yrs, (bc["st"], Ec))
    ind = tag_indipendente(rw, ev)
    chk("F5a etichetta di allineamento = ricalcolo a mano (cicli espliciti)", np.array_equal(ind, ev["ali"]) and len(ev["lato"]) > 50,
        "eventi %d, allineati %d, contro %d, NA %d" % (len(ev["lato"]), int((ev["ali"] == 1).sum()), int((ev["ali"] == 0).sum()), int((ev["ali"] == 2).sum())))
    del rw
    # F5: piantato SOLO se allineato (forza 0,05, vedi errata) contro piantato SEMPRE
    ra = pool_gen(lambda k: gen_piantato(nda, 0.05, tfm=240, ctxm=1440, solo_ali=True, seed=51 + k), 4, "H4", 30, 500)
    _, asse_a, _ = aggrega(ra, "H4")
    rb = pool_gen(lambda k: gen_piantato(nda, 0.05, tfm=240, ctxm=1440, solo_ali=False, seed=61 + k), 4, "H4", 30, 600)
    _, asse_b, _ = aggrega(rb, "H4")
    for a_ in asse_a:
        chk("F5 asse: piantato SOLO se allineato -> Delta EFFETTO (%s)" % a_["lato"], a_["verdetto"] == "EFFETTO",
            "P_ali %.3f (ncl %d) P_co %.3f (ncl %d) Delta %+.3f surr %.3f [%.3f;%.3f] %s" %
            (a_["p_ali"], a_["ncl_ali"], a_["p_co"], a_["ncl_co"], a_["delta"], a_["smed"], a_["sq025"], a_["sq975"], a_["verdetto"]))
    for a_ in asse_b:
        chk("F5b asse: piantato SEMPRE -> Delta non EFFETTO (%s)" % a_["lato"], a_["verdetto"] not in ("EFFETTO", "CONTRARIO"),
            "P_ali %.3f (ncl %d) P_co %.3f (ncl %d) Delta %+.3f surr %.3f [%.3f;%.3f] %s" %
            (a_["p_ali"], a_["ncl_ali"], a_["p_co"], a_["ncl_co"], a_["delta"], a_["smed"], a_["sq025"], a_["sq975"], a_["verdetto"]))
    return chk.v


def _blk_misc(scala):
    chk = _Cattura()
    # F6 orologio
    rwc = gen_rw_k(0, int(2500 * scala), seed=7)
    for tf in ("H4", "D1"):
        a = calcola_coppia("T", rwc, tf, 0, 1, 0, varianti=False, cls_anno={})
        sh = dict(rwc); sh["t"] = rwc["t"] + 60
        bb = calcola_coppia("T", sh, tf, 0, 1, 0, varianti=False, cls_anno={})
        ea, eb = a["ev"]["PRIM"], bb["ev"]["PRIM"]
        diff = (a["nbar"] != bb["nbar"]) or len(ea["lato"]) != len(eb["lato"]) or not np.array_equal(ea["pos"], eb["pos"])
        chk("F6 OROLOGIO %s: +1h cambia barre o eventi" % tf, diff, "barre %d -> %d, eventi %d -> %d" % (a["nbar"], bb["nbar"], len(ea["lato"]), len(eb["lato"])))

    def file_picco(est_fisso):
        base = R._minuti(dt.datetime(2015, 1, 1))
        t = base + np.arange(400 * 1440, dtype=np.int64)
        loc = t - 300
        for y in (2015, 2016):
            s_, e_ = R._us_dst_bounds(y)
            loc[(t - 300 >= s_ - 60) & (t - 300 < e_ - 60)] += 60
        amp = np.where((loc % 1440) == 510, 1.0, 0.01)            # picco vero: 8:30 ora di New York
        scritto = (t - 300) if est_fisso else loc
        o = np.full(len(t), 100.0); c = o + amp
        return dict(t=R.ny_to_utc(scritto), o=o, h=c, l=o, c=c)
    g_ok = cancello_feed([file_picco(False)])
    g_ko = cancello_feed([file_picco(True)])
    base_utc = file_picco(False)
    nyletto = dict(t=R.ny_to_utc(base_utc["t"]), o=base_utc["o"], h=base_utc["h"], l=base_utc["l"], c=base_utc["c"])
    g_ko2 = cancello_feed([nyletto])
    chk("F6 G-OROLOGIO (ancore forex) passa sul file NY corretto", g_ok[0], "inverno %s estate %s" % (R.hhmm(g_ok[1]), R.hhmm(g_ok[2])))
    chk("F6 G-OROLOGIO boccia il file in EST fisso", not g_ko[0], "inverno %s estate %s" % (R.hhmm(g_ko[1]), R.hhmm(g_ko[2])))
    chk("F6 G-OROLOGIO boccia un feed UTC letto come NY", not g_ko2[0], "inverno %s estate %s" % (R.hhmm(g_ko2[1]), R.hhmm(g_ko2[2])))
    # F7 domenica
    lun0 = R._minuti(dt.datetime(2015, 6, 8)) - 60                  # lunedi' 00:00 UTC+1
    tt = []
    for w in range(10):
        dom = lun0 + w * 10080 - 60                                  # domenica 23:00 UTC+1 (22:00 UTC)
        tt.append(np.arange(dom, dom + 60, dtype=np.int64))
        for g in range(5):
            tt.append(np.arange(lun0 + w * 10080 + g * 1440, lun0 + w * 10080 + (g + 1) * 1440, dtype=np.int64))
    tt = np.concatenate(tt)
    dummy = dict(t=tt, o=np.full(len(tt), 1.0), h=np.full(len(tt), 1.0), l=np.full(len(tt), 1.0), c=np.full(len(tt), 1.0))
    bd = costruisci_barre(dummy, "D1"); bh = costruisci_barre(dummy, "H4")
    chk("F7 D1 = 5 barre a settimana (domenica sera nel lunedi')", len(bd["c"]) == 50, "barre D1 %d (attese 50)" % len(bd["c"]))
    chk("F7 H4: 6 barre x 5 giorni + 1 stub domenicale = 31 a settimana, mai unite al lunedi'", len(bh["c"]) == 310, "barre H4 %d (attese 310)" % len(bh["c"]))
    # F8 cluster a mano
    nomi8 = ["EURUSD", "GBPUSD", "USDJPY", "AUDJPY", "GBPJPY", "AUDUSD"]
    ix = {n: i for i, n in enumerate(nomi8)}
    d1 = 100
    c1 = n_cluster([d1, d1, d1], [ix["EURUSD"], ix["GBPUSD"], ix["USDJPY"]], nomi8)
    c2 = n_cluster([d1, d1], [ix["AUDJPY"], ix["EURUSD"]], nomi8)
    c3 = n_cluster([d1, d1 + 1, d1 + 2], [ix["EURUSD"]] * 3, nomi8)
    c4 = n_cluster([d1, d1, d1], [ix["EURUSD"], ix["GBPJPY"], ix["AUDJPY"]], nomi8)
    c5 = n_cluster([d1, d1, d1, d1], [ix["EURUSD"], ix["GBPJPY"], ix["AUDJPY"], ix["AUDUSD"]], nomi8)
    c6 = n_cluster([d1, d1], [ix["EURUSD"], ix["EURUSD"]], nomi8)
    chk("F8 cluster a mano", (c1, c2, c3, c4, c5, c6) == (1, 2, 3, 2, 1, 1), "ottenuti %s attesi (1, 2, 3, 2, 1, 1)" % str((c1, c2, c3, c4, c5, c6)))
    # F9 IC a blocchi di mese
    rng9 = np.random.default_rng(3)
    mesi = np.repeat(np.arange(24), 10)
    bind_alt = np.repeat(np.arange(24) % 2, 10)
    lo, hi, M = boot_mesi(mesi, bind_alt, rng9)
    wlo, whi = R.wilson(120, 240)
    chk("F9 IC di mese >= 3 x Wilson con mesi tutti-B / tutti-P", (hi - lo) >= 3 * (whi - wlo), "IC mese %.3f contro Wilson %.3f" % (hi - lo, whi - wlo))
    bind_iid = (np.random.default_rng(4).random(240) < 0.5).astype(int)
    lo, hi, M = boot_mesi(mesi, bind_iid, rng9)
    wlo, whi = R.wilson(bind_iid.sum(), 240)
    chk("F9b IC di mese entro +/-30% di Wilson con eventi i.i.d.", 0.7 * (whi - wlo) <= (hi - lo) <= 1.3 * (whi - wlo),
        "IC mese %.3f contro Wilson %.3f" % (hi - lo, whi - wlo))
    # F13 look-ahead del contesto
    f13 = f13_lookahead(scala)
    chk("F13 look-ahead del contesto", f13[0], f13[1])
    return chk.v


def _esegui_blocco(a):
    nome = a[0]
    t0 = time.time()
    if nome == "F0":
        v = _blk_f0()
    elif nome == "F1":
        v = _blk_f1(a[1])
    elif nome == "F2":
        v = _blk_f2(a[1], a[2])
    elif nome == "F3":
        v = _blk_f3(a[1])
    elif nome == "F4":
        v = _blk_f4(a[1])
    elif nome == "F5":
        v = _blk_f5(a[1])
    else:
        v = _blk_misc(a[1])
    return nome, v, time.time() - t0


def autotest(scala=1.0, salta_f0=False, nproc=4):
    """blocchi indipendenti in parallelo (ognuno con i suoi semi: il risultato non dipende dall'ordine)."""
    log("=" * 70)
    log(" AUTOTEST " + VERSIONE)
    log("=" * 70)
    t0 = time.time()
    lavori = [("F3", scala), ("F5", scala), ("F2", 0.0, scala), ("F2", 0.7, scala), ("F4", scala), ("F1", scala), ("MISC", scala)]
    if not salta_f0:
        lavori.insert(0, ("F0",))
    out = {}
    with mp.get_context("fork").Pool(nproc) as pl:
        for nome_, v, sec in pl.imap_unordered(_esegui_blocco, lavori):
            out[(nome_, len(out))] = (v, sec)
            log("   [blocco %s finito in %.0f s]" % (nome_, sec))
    ok = 0; tot = 0
    for (k, (v, sec)) in sorted(out.items(), key=lambda kv: kv[1][0][0][0] if kv[1][0] else ""):
        for (nome, cond, det) in v:
            tot += 1; ok += 1 if cond else 0
            log(" [%s] %s -- %s" % ("PASS" if cond else "FAIL", nome, det))
    log("AUTOTEST FOREX28: %d/%d  (%.0f s)" % (ok, tot, time.time() - t0))
    return ok == tot and tot > 0


def copertura(tranche, k, feed, anni):
    return "%d coppie su 28, %s, %s" % (k, feed, anni)


def f13_lookahead(scala=1.0):
    """cambiare una barra di contesto DOPO il tocco non sposta l'etichetta; cambiare quella chiusa subito PRIMA si'."""
    rw = gen_rw(1, int(3000 * scala), seed=9)[0]
    yrs = R.anni_di(rw["t"])
    b = costruisci_barre(rw, "H4"); A = R.atr(b); E = R.livello(b, "EMA200")
    bc = costruisci_barre(rw, "D1"); Ec = R.livello(bc, "EMA200")
    base = eventi_t(rw["h"], rw["l"], b, E, A, 0.0, yrs, (bc["st"], Ec))
    sel = np.flatnonzero(base["ali"] != 2)
    if len(sel) < 5:
        return False, "pochi eventi con contesto (%d)" % len(sel)
    cambiate = 0; dopo_ok = True
    for i in sel[:60]:
        j = np.searchsorted(bc["st"], base["pos"][i], side="right") - 1      # barra di contesto che contiene il tocco
        # (1) EMA perturbata dalla barra j (ancora aperta al tocco) in poi: l'etichetta dell'evento e di quelli PRECEDENTI NON deve cambiare
        Ec2 = Ec.copy(); Ec2[j:] = Ec2[j:] + 1e6
        e2 = eventi_t(rw["h"], rw["l"], b, E, A, 0.0, yrs, (bc["st"], Ec2))
        mk = base["pos"] <= base["pos"][i]          # gli eventi fino a questo incluso: dipendono solo da barre di contesto CHIUSE prima
        if not np.array_equal(base["ali"][mk], e2["ali"][mk]):
            dopo_ok = False
            break
    # (2) perturbazione sulla barra chiusa subito prima (j-1): l'etichetta di quell'evento deve poter cambiare
    i = sel[0]
    j = np.searchsorted(bc["st"], base["pos"][i], side="right") - 1
    Ec3 = Ec.copy(); Ec3[j - 1] = Ec3[j - 1] + (1e6 if base["lato"][i] == 1 else -1e6)
    e3 = eventi_t(rw["h"], rw["l"], b, E, A, 0.0, yrs, (bc["st"], Ec3))
    cambia = e3["ali"][i] != base["ali"][i]
    return bool(dopo_ok and cambia), "dopo il tocco: etichette %s; barra chiusa subito prima: evento %d %s" % (
        "invariate" if dopo_ok else "CAMBIATE", int(i), "cambia" if cambia else "NON cambia")


# ---------------------------------------------------------------------
# 8. CORSA SUI DATI
# ---------------------------------------------------------------------
CAMPI = ["tf", "var", "lato", "cella", "regime", "n", "B", "P", "AMB", "TO", "n_cluster", "n_coppie", "n_mesi", "p",
         "ic_lo", "ic_hi", "ic_boot_lo", "ic_boot_hi", "n0", "smed", "sq025", "sq975", "eff", "verdetto"]
CAMPI_ASSE = ["tf", "lato", "na", "B_ali", "P_ali", "p_ali", "ncl_ali", "B_co", "P_co", "p_co", "ncl_co", "ncl_min", "delta",
              "ic_lo", "ic_hi", "smed", "sq025", "sq975", "eff", "verdetto"]
CAMPI_COPPIE = ["tf", "coppia", "lato", "n", "B", "P", "p", "smed", "sq025", "sq975", "eff"]


def fmt(x):
    if isinstance(x, float):
        return "" if x != x else "%.4f" % x
    return str(x)


def scrivi_csv(fn, campi, righe):
    with open(fn, "w", newline="") as fh:
        wr = csv.writer(fh)
        wr.writerow(campi)
        for r in righe:
            wr.writerow([fmt(r.get(k, "")) for k in campi])


def corri(tranche, cache, uscita, nproc=4, zipdir=None):
    os.makedirs(uscita, exist_ok=True)
    rep = []

    def add(s=""):
        rep.append(s)
        log(s)
    add("=" * 78)
    add(" %s -- tranche %s -- criteri %s" % (VERSIONE, tranche, CRITERI))
    add("=" * 78)
    t_inizio = time.time()
    fonte = "A" if tranche == "A6" else "B"
    if fonte == "A":
        n_file, mancano = scarica_a(cache)
        add(" file mensili richiesti %d, non raggiunti %d" % (n_file, mancano))
        if mancano:
            add(" !!! file mancanti: i dati NON sono completi, nessun numero (codice 2)")
            return 2
        nomi = sorted(COPPIE_A)
        feed = "Oanda"
    else:
        import glob
        trovati = set(os.path.basename(f).split("_")[3] for f in glob.glob(os.path.join(zipdir, "HISTDATA_COM_ASCII_*_M1_*.zip")))
        nomi = sorted(n for n in UNIVERSO28 if n in trovati)
        feed = "HistData"
        add(" coppie con zip nella cartella: %d su 28 (%s)" % (len(nomi), " ".join(nomi)))
        if len(nomi) < 4:
            add(" !!! meno di 4 coppie: nessun verdetto sul fenomeno (codice 2)")
            return 2
    with cf.ProcessPoolExecutor(nproc) as ex:
        list(ex.map(_carica_solo, [(fonte, zipdir, n, cache) for n in nomi]))
    pool = {n: carica_generico(fonte, n, cache, zipdir) for n in nomi}
    anni_txt = "%d-%d" % (min(int(R.anni_di(pool[n]["t"][:1])[0]) for n in nomi), max(int(R.anni_di(pool[n]["t"][-1:])[0]) for n in nomi))
    add("")
    add(" DATI (barre M1 UTC): primo e ultimo minuto REALI per coppia")
    for n in nomi:
        t = pool[n]["t"]
        add("   %-7s %9s barre  %s -> %s" % (n, format(len(t), ","), R.EPOCH + dt.timedelta(minutes=int(t[0])), R.EPOCH + dt.timedelta(minutes=int(t[-1]))))
    ok, w, s, nw, ns = cancello_feed([pool[n] for n in nomi])
    add(" G-OROLOGIO (pooled, feed %s): picco inverno %s (n %d)  estate %s (n %d)  ancore %s -> %s" %
        (feed, R.hhmm(w), nw, R.hhmm(s), ns, ",".join(R.hhmm(a) for a in ANCORE_FX), "PASSA" if ok else "FALLISCE"))
    for n in nomi:
        okp, wp, sp, _, _ = R.cancello_orologio(pool[n], ANCORE_FX)
        add("   (informativo) %-7s picco inverno %s estate %s %s" % (n, R.hhmm(wp), R.hhmm(sp), "" if okp else "[fuori dalle ancore]"))
    if not ok:
        add(" !!! orologio non confermato: nessun numero (codice 2)")
        open(os.path.join(uscita, "REFERTO_%s.txt" % tranche), "w").write("\n".join(rep) + "\n")
        return 2
    # G-DATI
    esclusi = {}
    add("")
    add(" G-DATI (errata 1): mesi con barre M1 < 50% della mediana dei mesi della coppia")
    for n in nomi:
        bad, um, cnt, med = mesi_esclusi(pool[n])
        esclusi[n] = bad
        add("   %-7s mediana mensile %d barre; mesi esclusi: %s" % (n, int(med), ", ".join(nome_mese(k) for k in sorted(bad)) if bad else "nessuno"))
    # regimi
    add("")
    add(" REGIMI per coppia-anno (rendimento close-to-close; TORO >= +5%, ORSO <= -5%):")
    for n in nomi:
        cl = classi_anno(pool[n])
        add("   %-7s %s" % (n, "  ".join("%d %s" % (y, CLS_NOME[c][:3]) for y, c in sorted(cl.items()))))
    tutte = dict(righe=[], asse=[], coppie=[], fen=[], placebo=[])
    risultati = {}
    for tf in ("H4", "D1", "H1", "M30"):
        t1 = time.time()
        add("")
        add(" === TF %s (%s) ===" % (tf, "primario" if tf in TF_PRIM else "riferimento"))
        tasks = [(fonte, zipdir, n, cache, tf, NSURR[tf], 1000 + TF_MIN[tf] + 7 * i, i) for i, n in enumerate(nomi)]
        with mp.get_context("fork").Pool(nproc) as pl:
            out = pl.map(_task_coppia, tasks, chunksize=1)
        res = {o["nome"]: o for o in out}
        # esclusione G-DATI dagli eventi della serie vera (surrogati intatti)
        for n in nomi:
            if esclusi[n]:
                for v, e in res[n]["ev"].items():
                    mm = mesi_di(e["tmin"]) if len(e["tmin"]) else np.zeros(0, np.int64)
                    keep = ~np.isin(mm, list(esclusi[n]))
                    for k in list(e):
                        if isinstance(e[k], np.ndarray) and len(e[k]) == len(keep):
                            e[k] = e[k][keep]
        righe, asse, coppie = aggrega(res, tf)
        for n in nomi:
            ev = res[n]["ev"]
            add("   %-7s barre %d, ATR mediano %.6f (%.1f pip), eventi PRIM %d, NOFILT %d" %
                (n, res[n]["nbar"], res[n]["amed"], res[n]["amed"] / (0.01 if n.endswith("JPY") else 0.0001),
                 len(ev["PRIM"]["lato"]), len(ev["NOFILT"]["lato"])))
        # placebo condizionali
        pb_verdetti = []
        for lato in ("long", "short"):
            if placebo_dovuto(righe, lato):
                add("   placebo dovuti per %s %s (primaria EFFETTO o ZONA GRIGIA con |effetto| >= 0,03)" % (tf, lato))
        if any(placebo_dovuto(righe, l) for l in ("long", "short")):
            for tipo in ("EMA100", "EMA150", "EMA250", "SMA200"):
                tasks_p = [(fonte, zipdir, n, cache, tf, tipo, NSURR[tf], 5000 + TF_MIN[tf] + 7 * i, i) for i, n in enumerate(nomi)]
                with mp.get_context("fork").Pool(nproc) as pl:
                    outp = pl.map(_task_placebo, tasks_p, chunksize=1)
                rows = aggrega_placebo({o["nome"]: o for o in outp}, tf, tipo)
                tutte["placebo"].extend(rows)
                pb_verdetti.extend(r["verdetto"] for r in rows)
        fen, mot = verdetto_fenomeno(tf, righe, coppie, pb_verdetti or None, len(nomi))
        tutte["righe"].extend(righe); tutte["asse"].extend(asse); tutte["coppie"].extend(coppie)
        tutte["fen"].append((tf, fen, mot))
        for r in righe:
            if r["var"] == "PRIM" and r["cella"] in ("X1.00_Y1.00", "X0.25_Y1.00") and r["regime"] == "TUTTO":
                add("   %-3s %-5s %-12s n %5d n_cl %5d P %.3f IC [%.3f;%.3f] surr %.3f [%.3f;%.3f] eff %+.3f %s" %
                    (tf, r["lato"], r["cella"], r["n"], r["n_cluster"], r["p"], r["ic_lo"], r["ic_hi"], r["smed"], r["sq025"], r["sq975"], r["eff"], r["verdetto"]))
        add("   %s: verdetto sul fenomeno: %s [%s]" % (tf, fen, copertura(tranche, len(nomi), feed, anni_txt)))
        add("   (%.0f s)" % (time.time() - t1))
        # eventi grezzi (nessun prezzo) per questo TF
        np.savez_compressed(os.path.join(uscita, "EVENTI_%s.npz" % tf),
                            **{"%s_%s_%s" % (n, v, k): res[n]["ev"][v][k] for n in nomi for v in res[n]["ev"] for k in ("lato", "tmin", "es", "ali", "reg")})
        risultati[tf] = res
    scrivi_csv(os.path.join(uscita, "EMA200_FOREX28_" + tranche + "_SINTESI.csv"), CAMPI, tutte["righe"])
    scrivi_csv(os.path.join(uscita, "EMA200_FOREX28_" + tranche + "_ASSE.csv"), CAMPI_ASSE, tutte["asse"])
    scrivi_csv(os.path.join(uscita, "EMA200_FOREX28_" + tranche + "_COPPIE.csv"), CAMPI_COPPIE, tutte["coppie"])
    if tutte["placebo"]:
        scrivi_csv(os.path.join(uscita, "EMA200_FOREX28_" + tranche + "_PLACEBO.csv"), CAMPI, tutte["placebo"])
    add("")
    add(" VERDETTI SUL FENOMENO (con l'etichetta di copertura):")
    for tf, fen, mot in tutte["fen"]:
        add("   %s: %s [%s] -- %s" % (tf, fen, copertura(tranche, len(nomi), feed, anni_txt), "; ".join(mot)))
    add(" tempo totale %.0f s" % (time.time() - t_inizio))
    open(os.path.join(uscita, "REFERTO_%s.txt" % tranche), "w").write("\n".join(rep) + "\n")
    return 0


def _carica_solo(a):
    fonte, zipdir, nome, cache = a
    m = carica_generico(fonte, nome, cache, zipdir)
    return len(m["t"])


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--autotest", action="store_true")
    ap.add_argument("--salta-f0", action="store_true", help="solo sviluppo: salta F0 (R.autotest, ~3 minuti)")
    ap.add_argument("--corri", choices=["A6", "B"])
    ap.add_argument("--zip", default=None, help="cartella degli zip HistData (solo per --corri B)")
    ap.add_argument("--cache", default=os.path.join(os.getcwd(), "cache_fx"))
    ap.add_argument("--uscita", default=os.getcwd())
    ap.add_argument("--nproc", type=int, default=4)
    a = ap.parse_args()
    if a.autotest:
        sys.exit(0 if autotest(salta_f0=a.salta_f0) else 2)
    if a.corri:
        if not autotest():
            log("AUTOTEST FALLITO: nessun dato vero (codice 2)")
            sys.exit(2)
        sys.exit(corri(a.corri, a.cache, a.uscita, a.nproc, a.zip))
    ap.print_help()


if __name__ == "__main__":
    main()
