#!/usr/bin/env python3
# =====================================================================
#  MARCATORE_EMA200_RIMBALZO_v1
#  ema200_rimbalzo.py -- il RIMBALZO sulla EMA200 misurato come FENOMENO
#
#  Criteri CONGELATI prima dei numeri: report/EMA200_RIMBALZO_CRITERI_2026-10-01.md
#  (commit c23bfe61). Ogni definizione qui sotto rimanda a una sezione di
#  quel file; se il codice e il file divergono, VINCE IL FILE e il codice
#  e' sbagliato.
#
#  NON e' un backtest: niente PF, niente equity, niente costo dentro la P.
#  Conta EVENTI (primo tocco, sfondamento) su barre M1 e li confronta con
#  tre null: N0 analitico (random walk), N1 surrogato a blocchi di 40 barre
#  del TF, N2 placebo di livello (EMA100/150/250, SMA200).
#
#  Uso:
#    python3 ema200_rimbalzo.py --autotest
#    python3 ema200_rimbalzo.py --dataset DAX   --cache DIR --uscita DIR
#    python3 ema200_rimbalzo.py --dataset SPX | XAU_A | XAU_B
#    python3 ema200_rimbalzo.py --dataset FILE --file NASUSD_M1.csv \
#        --formato f1 --fuso NY --simbolo NASUSD --ancore 870,810
#  Richiede numpy. File ASCII puro (gira anche in console Windows).
#  Codici d'uscita: 0 ok, 1 misurato con rilievi, 2 invalido (autotest o
#  cancello dell'orologio falliti: nessun numero).
# =====================================================================
import argparse, csv, io, math, os, sys, time, urllib.request
import datetime as dt
import numpy as np

VERSIONE = "EMA200_RIMBALZO_v1"
BASE = "https://raw.githubusercontent.com/FutureSharks/financial-data/master/pyfinancialdata/data"
IDX_URL = BASE + "/stocks/histdata/%s/DAT_ASCII_%s_M1_%d.csv"
ORO_URL = BASE + "/currencies/oanda/XAU_USD/%d/oanda-XAU_USD-%d-%d.csv"

TF_MIN = {"M5": 5, "M15": 15, "H1": 60, "H4": 240, "D1": 1440}
CLOCK_OFFSET_MIN = 60          # barre costruite su UTC+1 fisso (criteri sez. 1)
WARMUP = 600                   # barre del TF senza eventi (sez. 1)
N_SEP = 20                     # barre pulite / chiusure per armare (sez. 3, 4)
D_MIN = 1.0                    # distanza minima raggiunta durante la separazione (ATR)
HORIZON = 20                   # barre del TF per risolvere (sez. 3, 4)
XS = (0.25, 0.5, 1.0)
YS = (0.5, 1.0)
PRIMARIA = (1.0, 1.0)
COLLEGA = (0.25, 1.0)
B_BRK, TOL, Z_ESC = 0.5, 0.10, 1.5
K_BLOCCO = 40                  # blocco del surrogato in barre del TF (sez. 6.2)
N_MIN = 150

# dataset raggiungibili da questa sessione (criteri sez. 1)
DATASETS = {
    "DAX":   dict(simbolo="D30EUR", feed="HistData GRXEUR (FutureSharks)", tipo="idx", sym="GRXEUR",
                  anni=range(2010, 2019), fuso="NY", ancore=(420, 480, 810, 870), spread=1.7676),
    "SPX":   dict(simbolo="SPXUSD", feed="HistData SPXUSD (FutureSharks)", tipo="idx", sym="SPXUSD",
                  anni=range(2010, 2019), fuso="NY", ancore=(810, 870), spread=None),
    "XAU_A": dict(simbolo="XAUUSD", feed="Oanda XAU_USD (FutureSharks)", tipo="oanda",
                  anni=range(2006, 2021), fuso="UTC", ancore=(810, 900), spread=0.2003),
    "XAU_B": dict(simbolo="XAUUSD", feed="HistData XAUUSD -> UTC (repo)", tipo="utcdir",
                  anni=range(2021, 2027), fuso="UTC", ancore=(810, 900), spread=0.2003),
}


def log(s=""):
    sys.stdout.write(s + "\n")
    sys.stdout.flush()


# ---------------------------------------------------------------------
# 1. LETTURA E OROLOGIO
# ---------------------------------------------------------------------
EPOCH = dt.datetime(1970, 1, 1)


def _minuti(d):
    return int((d - EPOCH).total_seconds() // 60)


def _us_dst_bounds(y):
    """inizio/fine ora legale USA in minuti LOCALI dall'epoch (regola dal 2007)."""
    mar1 = dt.datetime(y, 3, 1)
    first_sun = mar1 + dt.timedelta(days=(6 - mar1.weekday()) % 7)
    start = first_sun + dt.timedelta(days=7, hours=2)
    nov1 = dt.datetime(y, 11, 1)
    end = nov1 + dt.timedelta(days=(6 - nov1.weekday()) % 7, hours=2)
    return _minuti(start), _minuti(end)


def ny_to_utc(tloc):
    """minuti locali New York -> minuti UTC (EST +5h, EDT +4h)."""
    tloc = np.asarray(tloc, dtype=np.int64)
    out = tloc + 300
    if len(tloc) == 0:
        return out
    y0 = (EPOCH + dt.timedelta(minutes=int(tloc.min()))).year
    y1 = (EPOCH + dt.timedelta(minutes=int(tloc.max()))).year
    for y in range(y0, y1 + 1):
        s, e = _us_dst_bounds(y)
        m = (tloc >= s) & (tloc < e)
        out[m] -= 60
    return out


def _parse_time(s):
    s = s.strip()
    if len(s) >= 15 and s[8] == " " and s[:8].isdigit():          # 20150102 020000
        d = dt.datetime(int(s[0:4]), int(s[4:6]), int(s[6:8]), int(s[9:11]), int(s[11:13]))
    elif s[4] == ".":                                               # 2015.01.02 02:00
        d = dt.datetime(int(s[0:4]), int(s[5:7]), int(s[8:10]), int(s[11:13]), int(s[14:16]))
    else:                                                           # 2015-01-02 02:00[:00]
        d = dt.datetime(int(s[0:4]), int(s[5:7]), int(s[8:10]), int(s[11:13]), int(s[14:16]))
    return _minuti(d)


def leggi_testo(testo, formato):
    """ritorna liste t(min locali del file), o, h, l, c. formato: 'histdata' (;), 'f1', 'nome'."""
    T, O, H, L, C = [], [], [], [], []
    righe = testo.splitlines()
    if formato == "nome":
        rd = csv.reader(righe)
        head = [x.strip().lower() for x in next(rd)]
        it, io_, ih, il, ic = (head.index(k) for k in ("time", "open", "high", "low", "close"))
        for r in rd:
            try:
                t = _parse_time(r[it]); o = float(r[io_]); h = float(r[ih]); l = float(r[il]); c = float(r[ic])
            except Exception:
                continue
            T.append(t); O.append(o); H.append(h); L.append(l); C.append(c)
    else:
        sep = ";" if formato == "histdata" else ","
        for line in righe:
            p = line.split(sep)
            if len(p) < 5:
                continue
            try:
                t = _parse_time(p[0]); o = float(p[1]); h = float(p[2]); l = float(p[3]); c = float(p[4])
            except Exception:
                continue
            T.append(t); O.append(o); H.append(h); L.append(l); C.append(c)
    return T, O, H, L, C


def _get(url, cache):
    fn = os.path.join(cache, url.rsplit("/", 1)[-1])
    if os.path.exists(fn) and os.path.getsize(fn) > 0:
        return open(fn, "rb").read().decode("ascii", "replace")
    try:
        with urllib.request.urlopen(url, timeout=180) as r:
            d = r.read()
    except Exception as e:
        log("   non raggiunto: %s (%s)" % (url, e))
        return ""
    open(fn, "wb").write(d)
    return d.decode("ascii", "replace")


def _pulisci(T, O, H, L, C, fuso):
    t = np.array(T, dtype=np.int64)
    a = np.array([O, H, L, C], dtype=np.float64)
    if fuso == "NY":
        t = ny_to_utc(t)
    ok = (a[2] <= a[0]) & (a[0] <= a[1]) & (a[2] <= a[3]) & (a[3] <= a[1]) & (a[2] > 0)
    t, a = t[ok], a[:, ok]
    o = np.argsort(t, kind="stable")
    t, a = t[o], a[:, o]
    keep = np.ones(len(t), bool)
    keep[1:] = t[1:] != t[:-1]
    return dict(t=t[keep], o=a[0][keep], h=a[1][keep], l=a[2][keep], c=a[3][keep])


def carica_dataset(nome, cache, repo):
    ds = DATASETS[nome]
    os.makedirs(cache, exist_ok=True)
    npz = os.path.join(cache, "m1_%s.npz" % nome)
    if os.path.exists(npz):
        z = np.load(npz)
        return {k: z[k] for k in ("t", "o", "h", "l", "c")}
    T, O, H, L, C = [], [], [], [], []
    nfile = 0
    if ds["tipo"] == "idx":
        for y in ds["anni"]:
            tx = _get(IDX_URL % (ds["sym"], ds["sym"], y), cache)
            if tx:
                nfile += 1
                r = leggi_testo(tx, "histdata")
                for A, B in zip((T, O, H, L, C), r):
                    A.extend(B)
    elif ds["tipo"] == "oanda":
        for y in ds["anni"]:
            for m in range(1, 13):
                tx = _get(ORO_URL % (y, y, m), cache)
                if tx:
                    nfile += 1
                    r = leggi_testo(tx, "nome")
                    for A, B in zip((T, O, H, L, C), r):
                        A.extend(B)
    elif ds["tipo"] == "utcdir":
        d = os.path.join(repo, "backtest_pipeline", "risultati_prove", "oro_m1_utc_2021_2026")
        for y in ds["anni"]:
            fn = os.path.join(d, "XAUUSD_M1_UTC_%d.csv" % y)
            if os.path.exists(fn):
                nfile += 1
                r = leggi_testo(open(fn).read(), "nome")
                for A, B in zip((T, O, H, L, C), r):
                    A.extend(B)
    log("   %s: file letti %d, righe %s" % (nome, nfile, format(len(T), ",")))
    m = _pulisci(T, O, H, L, C, ds["fuso"])
    np.savez(npz, **m)
    return m


def carica_file(path, formato, fuso):
    fmt = {"f1": "f1", "histdata": "histdata", "nome": "nome"}[formato]
    T, O, H, L, C = leggi_testo(open(path, encoding="ascii", errors="replace").read(), fmt)
    return _pulisci(T, O, H, L, C, fuso)


# ---------------------------------------------------------------------
# 2. CANCELLO DELL'OROLOGIO (criteri sez. 1)
# ---------------------------------------------------------------------
def picco_minuto(t, o, c, mesi):
    dd = np.array(t // 1440, dtype="datetime64[D]")
    mm = (dd.astype("datetime64[M]").astype(np.int64) % 12) + 1
    sel = np.isin(mm, mesi)
    mod = (t[sel] % 1440).astype(np.int64)
    amp = np.abs(c[sel] - o[sel]) / np.maximum(c[sel], 1e-12)
    s = np.bincount(mod, weights=amp, minlength=1440)
    n = np.bincount(mod, minlength=1440)
    mean = np.where(n >= 30, s / np.maximum(n, 1), 0.0)
    return int(np.argmax(mean)), int(n.sum())


def cancello_orologio(m, ancore, tol=2):
    w, nw = picco_minuto(m["t"], m["o"], m["c"], (1, 2))
    s, ns = picco_minuto(m["t"], m["o"], m["c"], (6, 7, 8))
    ok_w = any(abs(w - a) <= tol for a in ancore)
    ok_s = abs((w - 60) - s) <= tol
    return (ok_w and ok_s), w, s, nw, ns


def hhmm(x):
    return "%02d:%02d" % (x // 60, x % 60)


# ---------------------------------------------------------------------
# 3. BARRE, EMA, ATR
# ---------------------------------------------------------------------
def barre_da_m1(t, o, h, l, c, tfm, shift=0, bin_id=None):
    if bin_id is None:
        bin_id = (t + CLOCK_OFFSET_MIN + shift) // tfm
    cambio = np.empty(len(bin_id), bool)
    cambio[0] = True
    cambio[1:] = bin_id[1:] != bin_id[:-1]
    st = np.flatnonzero(cambio)
    en = np.append(st[1:], len(t))
    return dict(st=st, en=en, o=o[st], c=c[en - 1],
                h=np.maximum.reduceat(h, st), l=np.minimum.reduceat(l, st))


def ema(x, n):
    a = 2.0 / (n + 1.0)
    out = np.empty(len(x))
    xs = x.tolist()
    e = xs[0]
    for i, v in enumerate(xs):
        e = e + a * (v - e)
        out[i] = e
    return out


def sma(x, n):
    cs = np.cumsum(np.insert(x, 0, 0.0))
    out = np.full(len(x), np.nan)
    if len(x) >= n:
        out[n - 1:] = (cs[n:] - cs[:-n]) / n
    return out


def atr(b, n=14):
    pc = np.insert(b["c"][:-1], 0, b["o"][0])
    tr = np.maximum(b["h"] - b["l"], np.maximum(np.abs(b["h"] - pc), np.abs(b["l"] - pc)))
    return sma(tr, n)


def livello(b, tipo):
    if tipo == "SMA200":
        x = sma(b["c"], 200)
        x[:199] = b["c"][:199]
        return x
    return ema(b["c"], int(tipo[3:]))


# ---------------------------------------------------------------------
# 4. EVENTI H1 (primo tocco) e H2 (sfondamento)
# ---------------------------------------------------------------------
def _run_len(mask):
    """lunghezza della serie di True consecutivi che termina in ogni posizione."""
    m = mask.astype(np.int64)
    idx = np.arange(len(m))
    reset = np.where(m == 0, idx, -1)
    last0 = np.maximum.accumulate(reset)
    return idx - last0


def _roll_ext(x, n, fun):
    out = np.full(len(x), np.nan)
    if len(x) >= n:
        w = np.lib.stride_tricks.sliding_window_view(x, n)
        out[n - 1:] = fun(w, axis=1)
    return out


def _primo(arr_mono, thr, crescente):
    """primo indice in cui un array monotono raggiunge thr (len se mai)."""
    if crescente:
        return int(np.searchsorted(arr_mono, thr, side="left"))
    return int(np.searchsorted(-arr_mono, -thr, side="left"))


def eventi_h1(m1h, m1l, b, E, A, yrs=None):
    """ritorna lista di eventi: (lato, anno, {(X,Y): esito}) esito in B,P,AMB,TO."""
    nb = len(b["c"])
    Ep = np.insert(E[:-1], 0, np.nan)
    Ap = np.insert(A[:-1], 0, np.nan)
    with np.errstate(invalid="ignore", divide="ignore"):
        clean_up = b["l"] > Ep
        clean_dn = b["h"] < Ep
        # ATR <= 0 (feed piatto: Oanda ha tratti senza movimento) -> distanza NON definita,
        # contata 0 (mai "lontano"): senza questa riga c/0 = inf armava la separazione per finta
        dist = np.where(A > 0, (b["c"] - E) / np.where(A > 0, A, 1.0), np.nan)
    clean_up[:1] = False
    clean_dn[:1] = False
    ru = _run_len(clean_up)
    rd = _run_len(clean_dn)
    dmax = _roll_ext(np.nan_to_num(dist, nan=0.0), N_SEP, np.max)
    dmin = _roll_ext(np.nan_to_num(dist, nan=0.0), N_SEP, np.min)
    k = np.arange(nb)
    arm_up = np.zeros(nb, bool); arm_dn = np.zeros(nb, bool)
    arm_up[1:] = (ru[:-1] >= N_SEP) & (dmax[:-1] >= D_MIN)
    arm_dn[1:] = (rd[:-1] >= N_SEP) & (dmin[:-1] <= -D_MIN)
    valid = (k >= WARMUP) & np.isfinite(Ap) & (Ap > 0)
    tu = np.flatnonzero(arm_up & valid & (b["l"] <= Ep))
    td = np.flatnonzero(arm_dn & valid & (b["h"] >= Ep))
    out = []
    for lato, ks in (("long", tu), ("short", td)):
        for kk in ks:
            L = Ep[kk]; a = Ap[kk]
            s0, e0 = b["st"][kk], b["en"][kk]
            eh = b["en"][min(kk + HORIZON - 1, nb - 1)]
            if lato == "long":
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
            esiti = {}
            for Y in YS:
                ip = _primo(runmin, Lx - Y * a, False)
                for X in XS:
                    ib = _primo(runmax, Lx + X * a, True) + 1 if len(runmax) else nrest
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
                    esiti[(X, Y)] = r
                if Y == 1.0:
                    esiti["P_t0"] = (ip == 0)      # sfondamento di 1 ATR GIA' nel minuto del tocco
            anno = int(yrs[s0 + t0]) if yrs is not None else 0
            out.append((lato, anno, esiti))
    return out


def eventi_h2(m1h, m1l, b, E, A, yrs=None):
    nb = len(b["c"])
    c = b["c"].tolist(); El = E.tolist(); Al = A.tolist()
    out = []
    regime = 0; ru = 0; rd = 0
    for k in range(nb):
        ck, ek = c[k], El[k]
        if ck > ek:
            ru += 1; rd = 0
        elif ck < ek:
            rd += 1; ru = 0
        else:
            ru = rd = 0
        ak = Al[k]
        brk = 0
        if k >= WARMUP and ak == ak and ak > 0:
            if regime == 1 and ck <= ek - B_BRK * ak:
                brk = 1          # sfondamento in giu' da un regime sopra
            elif regime == -1 and ck >= ek + B_BRK * ak:
                brk = -1
        if brk != 0:
            regime = 0; ru = rd = 0
            if k + 1 < nb:
                s0 = b["st"][k + 1]; eh = b["en"][min(k + HORIZON, nb - 1)]
                if brk == 1:   # sotto: ritest = high >= L - tol*A ; fuga = low <= L - Z*A
                    hi = m1h[s0:eh]; lo = m1l[s0:eh]; L = ek; d0 = (ek - ck) / ak
                    rt_thr = L - TOL * ak; ra_thr = L - Z_ESC * ak
                    lato = "giu"
                else:          # specchio
                    hi = -m1l[s0:eh]; lo = -m1h[s0:eh]; L = -ek; d0 = (ck - ek) / ak
                    rt_thr = L - TOL * ak; ra_thr = L - Z_ESC * ak
                    lato = "su"
                # nel mondo specchiato: sfondamento sempre "in giu'": ritest = hi >= rt_thr
                null = max(0.0, (Z_ESC - d0) / (Z_ESC - TOL)) if d0 < Z_ESC else 0.0
                anno = int(yrs[b["st"][k]]) if yrs is not None else 0
                if d0 >= Z_ESC:
                    out.append((lato, anno, "RA", null, True)); continue
                irt = _primo(np.maximum.accumulate(hi), rt_thr, True) if len(hi) else 0
                ira = _primo(np.minimum.accumulate(lo), ra_thr, False) if len(lo) else 0
                n = len(hi)
                if irt >= n and ira >= n:
                    r = "TO"
                elif irt < ira:
                    r = "RT"
                elif ira < irt:
                    r = "RA"
                else:
                    r = "AMB"
                out.append((lato, anno, r, null, False))
            continue
        if regime == 0:
            if ru >= N_SEP:
                regime = 1
            elif rd >= N_SEP:
                regime = -1
        elif regime == 1 and rd >= N_SEP:
            regime = -1
        elif regime == -1 and ru >= N_SEP:
            regime = 1
    return out


# ---------------------------------------------------------------------
# 5. CONTEGGI, SURROGATI, VERDETTI
# ---------------------------------------------------------------------
def wilson(k, n, z=1.96):
    if n == 0:
        return (float("nan"), float("nan"))
    p = k / n
    den = 1 + z * z / n
    c = (p + z * z / (2 * n)) / den
    h = z * math.sqrt(p * (1 - p) / n + z * z / (4 * n * n)) / den
    return (c - h, c + h)


def conta_h1(ev, lato, cella, filtro_anno=None):
    cnt = {"B": 0, "P": 0, "AMB": 0, "TO": 0}
    for (ld, an, es) in ev:
        if ld != lato or (filtro_anno is not None and an not in filtro_anno):
            continue
        cnt[es[cella]] += 1
    n = cnt["B"] + cnt["P"]
    return cnt, (cnt["B"] / n if n else float("nan")), n


def conta_h2(ev, lato, filtro_anno=None):
    cnt = {"RT": 0, "RA": 0, "AMB": 0, "TO": 0}
    nulls = []; scappati = 0
    for (ld, an, r, nu, sc) in ev:
        if ld != lato or (filtro_anno is not None and an not in filtro_anno):
            continue
        cnt[r] += 1
        if r in ("RT", "RA"):
            nulls.append(nu)
        scappati += 1 if sc else 0
    n = cnt["RT"] + cnt["RA"]
    return cnt, (cnt["RT"] / n if n else float("nan")), n, (float(np.mean(nulls)) if nulls else float("nan")), scappati


def surrogato(m, b, rng, k=K_BLOCCO):
    """blocchi di k barre INTERE del TF; prezzi ricostruiti dai rendimenti log minuto per minuto."""
    nb = len(b["st"])
    nblk = (nb + k - 1) // k
    perm = rng.permutation(nblk)
    st, en = b["st"], b["en"]
    pezzi = []; lens_bar = []
    for p in perm:
        b0 = p * k; b1 = min(nb, b0 + k)
        pezzi.append(np.arange(st[b0], en[b1 - 1]))
        lens_bar.append(en[b0:b1] - st[b0:b1])
    idx = np.concatenate(pezzi)
    lb = np.concatenate(lens_bar)
    c = m["c"]; pc = np.insert(c[:-1], 0, m["o"][0])
    rc = np.log(c / pc)[idx]
    ro = np.log(m["o"] / pc)[idx]; rh = np.log(m["h"] / pc)[idx]; rl = np.log(m["l"] / pc)[idx]
    lc = np.log(m["o"][0]) + np.cumsum(rc)
    lpc = np.insert(lc[:-1], 0, np.log(m["o"][0]))
    s = dict(o=np.exp(lpc + ro), h=np.exp(lpc + rh), l=np.exp(lpc + rl), c=np.exp(lc), t=m["t"][idx])
    stn = np.insert(np.cumsum(lb)[:-1], 0, 0)
    bn = dict(st=stn, en=stn + lb, o=s["o"][stn], c=s["c"][stn + lb - 1],
              h=np.maximum.reduceat(s["h"], stn), l=np.minimum.reduceat(s["l"], stn))
    return s, bn


def anni_di(t):
    return (np.array(t // 1440, dtype="datetime64[D]").astype("datetime64[Y]").astype(np.int64) + 1970)


def verdetto(p, n, lo, hi, med, q025, q975):
    if n < N_MIN or not (p == p) or not (med == med):
        return "NON ANCORA MISURATO"
    eff = p - med
    if p > q975 and eff >= 0.05 and lo > med:
        return "EFFETTO"
    if p < q025 and eff <= -0.05 and hi < med:
        return "CONTRARIO"
    if abs(eff) < 0.03 and q025 <= p <= q975 and (hi - lo) / 2 <= 0.06:
        return "NULLO"
    return "ZONA GRIGIA"


def misura_tf(m, tf, nsurr, seed=12345, placebo=True, regimi=None, shift=0):
    """ritorna righe di risultato per un TF."""
    tfm = TF_MIN[tf]
    b = barre_da_m1(m["t"], m["o"], m["h"], m["l"], m["c"], tfm, shift=shift)
    yrs = anni_di(m["t"])
    A = atr(b)
    E = livello(b, "EMA200")
    ev1 = eventi_h1(m["h"], m["l"], b, E, A, yrs)
    ev2 = eventi_h2(m["h"], m["l"], b, E, A, yrs)
    plac = {}
    if placebo:
        for tipo in ("EMA100", "EMA150", "EMA250", "SMA200"):
            Ex = livello(b, tipo)
            plac[tipo] = (eventi_h1(m["h"], m["l"], b, Ex, A, yrs), eventi_h2(m["h"], m["l"], b, Ex, A, yrs))
    # surrogati
    rng = np.random.default_rng(seed)
    S1 = []; S2 = []
    for i in range(nsurr):
        s, bs = surrogato(m, b, rng)
        As = atr(bs); Es = livello(bs, "EMA200")
        ys = anni_di(s["t"])
        S1.append(eventi_h1(s["h"], s["l"], bs, Es, As, ys))
        S2.append(eventi_h2(s["h"], s["l"], bs, Es, As, ys))
    atr_med = float(np.nanmedian(A[WARMUP:])) if len(A) > WARMUP else float("nan")
    return dict(tf=tf, nbar=len(b["c"]), ev1=ev1, ev2=ev2, S1=S1, S2=S2, plac=plac, atr_med=atr_med)


def _q(vals):
    v = np.array([x for x in vals if x == x])
    if len(v) == 0:
        return (float("nan"),) * 3
    return float(np.median(v)), float(np.quantile(v, 0.025)), float(np.quantile(v, 0.975))


def righe_risultato(res, regimi):
    """trasforma il risultato di un TF in righe tabellari."""
    R = []
    tf = res["tf"]
    filtri = [("TUTTO", None)]
    for cl in ("TORO", "LATERALE", "ORSO"):
        an = set(y for y, c in regimi.items() if c == cl)
        if an:
            filtri.append((cl, an))
    for lato in ("long", "short"):
        for (X, Y) in [(x, y) for y in YS for x in XS]:
            for (nomef, fa) in filtri:
                if nomef != "TUTTO" and (X, Y) != PRIMARIA:
                    continue
                cnt, p, n = conta_h1(res["ev1"], lato, (X, Y), fa)
                sp = [conta_h1(S, lato, (X, Y), fa)[1] for S in res["S1"]]
                med, q1, q2 = _q(sp)
                lo, hi = wilson(cnt["B"], n)
                r = dict(ipotesi="H1", tf=tf, lato=lato, cella="X%.2f_Y%.2f" % (X, Y), regime=nomef,
                         n=n, B=cnt["B"], P=cnt["P"], AMB=cnt["AMB"], TO=cnt["TO"], p=p, lo=lo, hi=hi,
                         n0=Y / (X + Y), smed=med, sq025=q1, sq975=q2, eff=(p - med) if n else float("nan"),
                         p_cons=(cnt["B"] / (n + cnt["AMB"]) if n + cnt["AMB"] else float("nan")))
                r["verdetto"] = verdetto(p, n, lo, hi, med, q1, q2)
                R.append(r)
        if res["plac"]:
            for tipo, (e1, e2) in res["plac"].items():
                cnt, p, n = conta_h1(e1, lato, PRIMARIA)
                lo, hi = wilson(cnt["B"], n)
                R.append(dict(ipotesi="H1-PLACEBO", tf=tf, lato=lato, cella=tipo, regime="TUTTO", n=n,
                              B=cnt["B"], P=cnt["P"], AMB=cnt["AMB"], TO=cnt["TO"], p=p, lo=lo, hi=hi,
                              n0=0.5, smed=float("nan"), sq025=float("nan"), sq975=float("nan"),
                              eff=float("nan"), p_cons=float("nan"), verdetto="placebo"))
    for lato in ("giu", "su"):
        for (nomef, fa) in filtri:
            cnt, p, n, nu, sc = conta_h2(res["ev2"], lato, fa)
            sp = [conta_h2(S, lato, fa)[1] for S in res["S2"]]
            med, q1, q2 = _q(sp)
            lo, hi = wilson(cnt["RT"], n)
            r = dict(ipotesi="H2", tf=tf, lato=lato, cella="b0.5_tol0.10_Z1.5", regime=nomef, n=n,
                     B=cnt["RT"], P=cnt["RA"], AMB=cnt["AMB"], TO=cnt["TO"], p=p, lo=lo, hi=hi, n0=nu,
                     smed=med, sq025=q1, sq975=q2, eff=(p - med) if n else float("nan"),
                     p_cons=float(sc))
            r["verdetto"] = verdetto(p, n, lo, hi, med, q1, q2)
            R.append(r)
        if res["plac"]:
            for tipo, (e1, e2) in res["plac"].items():
                cnt, p, n, nu, sc = conta_h2(e2, lato)
                lo, hi = wilson(cnt["RT"], n)
                R.append(dict(ipotesi="H2-PLACEBO", tf=tf, lato=lato, cella=tipo, regime="TUTTO", n=n,
                              B=cnt["RT"], P=cnt["RA"], AMB=cnt["AMB"], TO=cnt["TO"], p=p, lo=lo, hi=hi,
                              n0=nu, smed=float("nan"), sq025=float("nan"), sq975=float("nan"),
                              eff=float("nan"), p_cons=float(sc), verdetto="placebo"))
    return R


def regimi_annuali(m):
    yrs = anni_di(m["t"])
    out = {}; rend = {}
    for y in np.unique(yrs):
        sel = np.flatnonzero(yrs == y)
        if len(sel) < 1000:
            continue
        r = m["c"][sel[-1]] / m["o"][sel[0]] - 1
        rend[int(y)] = r
        out[int(y)] = "TORO" if r >= 0.10 else ("ORSO" if r <= -0.05 else "LATERALE")
    return out, rend


# ---------------------------------------------------------------------
# 6. DATI SINTETICI (autotest)
# ---------------------------------------------------------------------
def _bridge_hl(o, c, sig, rng):
    u1 = rng.random(len(o)); u2 = rng.random(len(o))
    d = (c - o) ** 2
    h = (o + c + np.sqrt(d - 2 * sig * sig * np.log(u1))) / 2
    l = (o + c - np.sqrt(d - 2 * sig * sig * np.log(u2))) / 2
    return h, l


def sintetico_rw(nmin, sig=1.0, seed=1, p0=20000.0, t0=None):
    rng = np.random.default_rng(seed)
    inc = rng.normal(0, sig, nmin)
    c = p0 + np.cumsum(inc)
    o = np.insert(c[:-1], 0, p0)
    h, l = _bridge_hl(o, c, sig, rng)
    t0 = _minuti(dt.datetime(2015, 1, 5)) if t0 is None else t0
    return dict(t=t0 + np.arange(nmin, dtype=np.int64), o=o, h=h, l=l, c=c)


def sintetico_piantato(nmin, modo, sig=1.0, seed=2, p0=20000.0, tfm=60, forza=0.6):
    """modo 'rimbalzo': spinta di ritorno dal lato di provenienza entro 0,15 ATR dalla EMA200 del TF.
       modo 'rottura': dopo un attraversamento di chiusura, spinta via dalla EMA finche' non e' a 1,5 ATR."""
    rng = np.random.default_rng(seed)
    z = rng.normal(0, sig, nmin).tolist()
    a = 2.0 / 201.0
    atr_c = 1.25 * sig * math.sqrt(tfm)   # ATR tipico di un random walk sul TF (ordine di grandezza)
    p = p0; e = p0; side = 1; prev_side = 1; esc = 0
    cl = [0.0] * nmin
    for i in range(nmin):
        d = (p - e) / atr_c
        drift = 0.0
        if modo == "rimbalzo":
            if side == 1 and d < 0.15:
                drift = forza * sig
            elif side == -1 and d > -0.15:
                drift = -forza * sig
        elif modo == "rottura" and esc != 0:
            if esc * d < 1.6:
                drift = esc * forza * sig
            else:
                esc = 0
        p = p + drift + z[i]
        cl[i] = p
        if (i + 1) % tfm == 0:
            e = e + a * (p - e)
            ns = 1 if p > e else -1
            if modo == "rottura" and ns != side:
                esc = ns
            side = ns
    c = np.array(cl)
    o = np.insert(c[:-1], 0, p0)
    h, l = _bridge_hl(o, c, sig, rng)
    t0 = _minuti(dt.datetime(2015, 1, 5))
    return dict(t=t0 + np.arange(nmin, dtype=np.int64), o=o, h=h, l=l, c=c)


def autotest():
    log("=" * 70)
    log(" AUTOTEST " + VERSIONE)
    log("=" * 70)
    ok = 0; tot = 0
    def chk(nome, cond, det):
        nonlocal ok, tot
        tot += 1; ok += 1 if cond else 0
        log(" [%s] %s -- %s" % ("PASS" if cond else "FAIL", nome, det))
    t0 = time.time()
    # 1. random walk, H1
    rw = sintetico_rw(12_000_000, seed=11)
    res = misura_tf(rw, "H1", nsurr=30, placebo=False)
    R = righe_risultato(res, {})
    def get(ip, lato, cella, reg="TUTTO"):
        return [r for r in R if r["ipotesi"] == ip and r["lato"] == lato and r["cella"] == cella and r["regime"] == reg][0]
    for lato in ("long", "short"):
        rp = get("H1", lato, "X1.00_Y1.00"); rc = get("H1", lato, "X0.25_Y1.00")
        chk("RW H1 %s primaria ~0,500" % lato, abs(rp["p"] - 0.5) <= 0.03,
            "P=%.3f n=%d" % (rp["p"], rp["n"]))
        chk("RW H1 %s collega ~0,800" % lato, abs(rc["p"] - 0.8) <= 0.03,
            "P=%.3f n=%d" % (rc["p"], rc["n"]))
        chk("RW H1 %s niente falso positivo contro N1" % lato, rp["verdetto"] not in ("EFFETTO", "CONTRARIO"),
            "verdetto %s eff %+.3f banda [%.3f;%.3f]" % (rp["verdetto"], rp["eff"], rp["sq025"], rp["sq975"]))
    ntot = sum(get("H1", l, "X1.00_Y1.00")["n"] for l in ("long", "short"))
    chk("RW H1 n totale primaria >= 1000", ntot >= 1000, "n=%d" % ntot)
    for lato in ("giu", "su"):
        r2 = get("H2", lato, "b0.5_tol0.10_Z1.5")
        chk("RW H2 %s ~ null per evento" % lato, abs(r2["p"] - r2["n0"]) <= 0.04,
            "P_RT=%.3f null=%.3f n=%d TO=%d" % (r2["p"], r2["n0"], r2["n"], r2["TO"]))
        chk("RW H2 %s niente falso positivo" % lato, r2["verdetto"] not in ("EFFETTO", "CONTRARIO"),
            "verdetto %s" % r2["verdetto"])
    log("   (%.0f s)" % (time.time() - t0))
    # 2. rimbalzo piantato
    pr = sintetico_piantato(2_400_000, "rimbalzo", seed=21)
    resp = misura_tf(pr, "H1", nsurr=30, placebo=False)
    Rp = righe_risultato(resp, {})
    for lato in ("long", "short"):
        r = [x for x in Rp if x["ipotesi"] == "H1" and x["lato"] == lato and x["cella"] == "X1.00_Y1.00" and x["regime"] == "TUTTO"][0]
        chk("PIANTATO rimbalzo %s: P>=0,70 e EFFETTO" % lato, r["p"] >= 0.70 and r["verdetto"] == "EFFETTO",
            "P=%.3f n=%d surr med %.3f verdetto %s" % (r["p"], r["n"], r["smed"], r["verdetto"]))
    # 3. rottura piantata
    br = sintetico_piantato(2_400_000, "rottura", seed=31)
    resb = misura_tf(br, "H1", nsurr=30, placebo=False)
    Rb = righe_risultato(resb, {})
    for lato in ("giu", "su"):
        r = [x for x in Rb if x["ipotesi"] == "H2" and x["lato"] == lato and x["regime"] == "TUTTO"][0]
        chk("PIANTATO rottura %s: P_RT<0,30 e CONTRARIO" % lato, r["p"] < 0.30 and r["verdetto"] == "CONTRARIO",
            "P_RT=%.3f n=%d surr med %.3f verdetto %s" % (r["p"], r["n"], r["smed"], r["verdetto"]))
    log("   (%.0f s)" % (time.time() - t0))
    # 4. orologio: lo spostamento di 1 ora DEVE cambiare H4/D1
    for tf in ("H4", "D1"):
        a = misura_tf(rw, tf, nsurr=0, placebo=False)
        bb = misura_tf(rw, tf, nsurr=0, placebo=False, shift=60)
        sa = (len(a["ev1"]), len(a["ev2"]), a["nbar"]); sb = (len(bb["ev1"]), len(bb["ev2"]), bb["nbar"])
        diff = sa != sb or any(x[2] != y[2] for x, y in zip(a["ev1"], bb["ev1"]))
        chk("OROLOGIO %s: +1h cambia gli eventi" % tf, diff, "eventi H1/H2/barre %s -> %s" % (sa, sb))
    # 4b. cancello orologio: picco 8:30 NY scritto in ora NY (con DST) passa; EST fisso letto come NY fallisce
    def file_picco(est_fisso):
        base = _minuti(dt.datetime(2015, 1, 1))
        t = base + np.arange(400 * 1440, dtype=np.int64)        # minuti UTC veri
        loc = t - 300                                            # NY in EST
        for y in (2015, 2016):
            s_, e_ = _us_dst_bounds(y)
            loc[(t - 300 >= s_ - 60) & (t - 300 < e_ - 60)] += 60   # NY in EDT
        amp = np.where((loc % 1440) == 510, 1.0, 0.01)           # picco vero: 8:30 ora di New York
        scritto = (t - 300) if est_fisso else loc                # cosa c'e' scritto nel file
        o = np.full(len(t), 100.0); c = o + amp
        return dict(t=ny_to_utc(scritto), o=o, h=c, l=o, c=c)
    g_ok = cancello_orologio(file_picco(False), (810, 900))
    g_ko = cancello_orologio(file_picco(True), (810, 900))
    chk("G-OROLOGIO passa sul file NY corretto", g_ok[0], "inverno %s estate %s" % (hhmm(g_ok[1]), hhmm(g_ok[2])))
    chk("G-OROLOGIO boccia il file in EST fisso", not g_ko[0], "inverno %s estate %s" % (hhmm(g_ko[1]), hhmm(g_ko[2])))
    # 5. lettura per nome (colonne Oanda C,H,L,O)
    tx = "time,close,high,low,open,volume\n2015-06-01 13:30:00,1200.304,1200.434,1199.326,1199.47,445\n"
    T, O, H, L, C = leggi_testo(tx, "nome")
    chk("LETTURA per nome: open/close giusti", O == [1199.47] and C == [1200.304], "O=%s C=%s" % (O, C))
    # 6. mutazione: X 1,0 -> 0,25 sposta P
    r1 = [x for x in R if x["ipotesi"] == "H1" and x["lato"] == "long" and x["cella"] == "X1.00_Y1.00" and x["regime"] == "TUTTO"][0]
    r2 = [x for x in R if x["ipotesi"] == "H1" and x["lato"] == "long" and x["cella"] == "X0.25_Y1.00" and x["regime"] == "TUTTO"][0]
    chk("MUTAZIONE X sposta P", r2["p"] - r1["p"] > 0.15, "%.3f -> %.3f" % (r1["p"], r2["p"]))
    # 7. random walk a M5: scarto da N0 stampato (nessuna soglia)
    rw5 = sintetico_rw(1_500_000, seed=13)
    res5 = misura_tf(rw5, "M5", nsurr=0, placebo=False)
    R5 = righe_risultato(res5, {})
    for cella, n0 in (("X1.00_Y1.00", 0.5), ("X0.25_Y1.00", 0.8)):
        ps = [x for x in R5 if x["ipotesi"] == "H1" and x["cella"] == cella and x["regime"] == "TUTTO"]
        log("   [INFO] RW a M5 %s: long %.3f (n %d) short %.3f (n %d) contro N0 %.3f" %
            (cella, ps[0]["p"], ps[0]["n"], ps[1]["p"], ps[1]["n"], n0))
    log("AUTOTEST: %d/%d  (%.0f s)" % (ok, tot, time.time() - t0))
    return ok == tot


# ---------------------------------------------------------------------
# 7. CORSA SU DATI VERI
# ---------------------------------------------------------------------
CAMPI = ["simbolo", "feed", "ipotesi", "tf", "lato", "cella", "regime", "n", "B", "P", "AMB", "TO", "p", "lo", "hi",
         "n0", "smed", "sq025", "sq975", "eff", "p_cons", "verdetto"]


def fmt(x):
    if isinstance(x, float):
        return "" if x != x else "%.4f" % x
    return str(x)


def corri(m, simbolo, feed, ancore, spread, uscita, tfs, ns_alto, ns_basso):
    os.makedirs(uscita, exist_ok=True)
    rep = []
    def add(s=""):
        rep.append(s); log(s)
    add("=" * 78)
    add(" %s -- %s -- feed %s" % (VERSIONE, simbolo, feed))
    add(" criteri: report/EMA200_RIMBALZO_CRITERI_2026-10-01.md (congelati, commit c23bfe61)")
    add("=" * 78)
    t = m["t"]
    add(" barre M1: %s   da %s a %s (UTC)" % (format(len(t), ","),
        EPOCH + dt.timedelta(minutes=int(t[0])), EPOCH + dt.timedelta(minutes=int(t[-1]))))
    ok, w, s, nw, ns = cancello_orologio(m, ancore)
    add(" G-OROLOGIO: picco inverno %s (n %d)  estate %s (n %d)  ancore %s -> %s" %
        (hhmm(w), nw, hhmm(s), ns, ",".join(hhmm(a) for a in ancore), "PASSA" if ok else "FALLISCE"))
    if not ok:
        add(" !!! orologio non confermato: nessun numero (codice 2)")
        open(os.path.join(uscita, "REFERTO_%s.txt" % simbolo), "w").write("\n".join(rep) + "\n")
        return None
    reg, rend = regimi_annuali(m)
    add(" regimi per anno (rendimento close-to-close): " +
        "  ".join("%d %s %+.1f%%" % (y, reg[y], 100 * rend[y]) for y in sorted(reg)))
    righe = []
    costo = []
    for tf in tfs:
        t1 = time.time()
        ns_ = ns_basso if tf in ("M5", "M15") else ns_alto
        res = misura_tf(m, tf, ns_, seed=1000 + TF_MIN[tf])
        R = righe_risultato(res, reg)
        for r in R:
            r["simbolo"] = simbolo; r["feed"] = feed
        righe.extend(R)
        costo.append((tf, res["atr_med"]))
        for lato in ("long", "short"):
            cnt, p, n = conta_h1(res["ev1"], lato, PRIMARIA)
            p0 = sum(1 for (ld, an, es) in res["ev1"] if ld == lato and es.get("P_t0") and es[PRIMARIA] == "P")
            add("    %s %-5s primaria: P (sfondamenti) %d, di cui GIA' nel minuto del tocco %d (%.0f%%)" %
                (tf, lato, cnt["P"], p0, 100.0 * p0 / cnt["P"] if cnt["P"] else 0.0))
        add(" %s: barre %d, eventi H1 %d, H2 %d, surrogati %d (%.0f s)" %
            (tf, res["nbar"], len(res["ev1"]), len(res["ev2"]), ns_, time.time() - t1))
    with open(os.path.join(uscita, "EMA200_RIMBALZO_%s.csv" % simbolo), "w", newline="") as fh:
        wr = csv.writer(fh)
        wr.writerow(CAMPI)
        for r in righe:
            wr.writerow([fmt(r[k]) for k in CAMPI])
    add("")
    add(" COSTO (non entra nella P): ATR mediano del TF in prezzo e rapporto X*ATR/spread")
    for tf, a in costo:
        if spread:
            add("   %-4s ATR %.4f   0,25 ATR / spread = %.1fx   1,0 ATR / spread = %.1fx" % (tf, a, 0.25 * a / spread, a / spread))
        else:
            add("   %-4s ATR %.4f   spread [NON MISURATO]" % (tf, a))
    add("")
    add(" TABELLA (primaria H1 X=Y=1,0; cella collega X=0,25 Y=1,0; H2 b=0,5 tol=0,10 Z=1,5)")
    add("  ip  tf   lato  cella          regime      n     P     IC95          N0    surr med [p2.5;p97.5]  eff    verdetto")
    for r in righe:
        if r["ipotesi"] in ("H1",) and r["cella"] not in ("X1.00_Y1.00", "X0.25_Y1.00"):
            continue
        add("  %-3s %-4s %-5s %-14s %-9s %5d  %.3f  [%.3f;%.3f]  %.3f  %.3f [%.3f;%.3f]  %+.3f  %s" % (
            r["ipotesi"][:3] if "PLAC" not in r["ipotesi"] else "PL" + r["ipotesi"][1], r["tf"], r["lato"], r["cella"], r["regime"],
            r["n"], r["p"], r["lo"], r["hi"], r["n0"], r["smed"], r["sq025"], r["sq975"], r["eff"], r["verdetto"]))
    open(os.path.join(uscita, "REFERTO_%s.txt" % simbolo), "w").write("\n".join(rep) + "\n")
    return righe


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--autotest", action="store_true")
    ap.add_argument("--dataset", choices=list(DATASETS) + ["FILE"])
    ap.add_argument("--file"); ap.add_argument("--formato", default="f1", choices=["f1", "histdata", "nome"])
    ap.add_argument("--fuso", default="NY", choices=["NY", "UTC"])
    ap.add_argument("--simbolo", default="FILE")
    ap.add_argument("--ancore", default="810,870", help="minuti UTC d'inverno del picco atteso, es. 810,870")
    ap.add_argument("--spread", type=float, default=0.0)
    ap.add_argument("--ancore-extra", default="", help="ancore AGGIUNTE a posteriori (lettura secondaria, dichiarata nel referto)")
    ap.add_argument("--cache", default=os.path.join(os.getcwd(), "cache_m1"))
    ap.add_argument("--uscita", default=os.getcwd())
    ap.add_argument("--tf", default="M5,M15,H1,H4,D1")
    ap.add_argument("--nsurr-alto", type=int, default=100)
    ap.add_argument("--nsurr-basso", type=int, default=40)
    a = ap.parse_args()
    if a.autotest:
        sys.exit(0 if autotest() else 2)
    repo = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    tfs = [x.strip() for x in a.tf.split(",")]
    if a.dataset == "FILE":
        m = carica_file(a.file, a.formato, a.fuso)
        simbolo, feed = a.simbolo, "file %s (%s, fuso %s)" % (os.path.basename(a.file), a.formato, a.fuso)
        ancore = tuple(int(x) for x in a.ancore.split(",")); spread = a.spread or None
    else:
        ds = DATASETS[a.dataset]
        m = carica_dataset(a.dataset, a.cache, repo)
        simbolo, feed, ancore, spread = ds["simbolo"] + ("" if a.dataset[:3] != "XAU" else "_" + a.dataset[-1]), ds["feed"], ds["ancore"], ds["spread"]
        if a.ancore_extra:
            ancore = tuple(ancore) + tuple(int(x) for x in a.ancore_extra.split(","))
            feed += " [ANCORA AGGIUNTA A POSTERIORI: " + a.ancore_extra + " min UTC -- lettura SECONDARIA]"
    r = corri(m, simbolo, feed, ancore, spread, a.uscita, tfs, a.nsurr_alto, a.nsurr_basso)
    sys.exit(2 if r is None else 0)


if __name__ == "__main__":
    main()
