#!/usr/bin/env python3
# -*- coding: ascii -*-
# =====================================================================
#  MARCATORE_SCHEDA_SIMBOLO_v1
#  scheda_simbolo.py -- la SCHEDA di ogni simbolo, dai NOSTRI dati M1
#
#  PERCHE' ESISTE (richiesta di Claudio, 05/10/2026): "analizzare ogni
#  simbolo che usiamo, conoscerlo a memoria: come si muove, come ritraccia,
#  quanti punti fa di media al giorno, quali sono i piu' volatili e quali
#  i meno". TradingView non e' raggiungibile da noi e comunque non e'
#  riproducibile: questi numeri escono da barre M1 di cui si conosce
#  fonte, fuso e profondita', e si rifanno identici.
#
#  NON E' UN BACKTEST e NON E' UN TEST DI EDGE: DESCRIVE come si muove un
#  prezzo. Nessun PF, nessuna equity, nessun costo dentro una probabilita'.
#  Dove una misura ha un'attesa "a caso", la scheda stampa accanto il
#  numero del RANDOM WALK passato dalla STESSA procedura (riferimento
#  simulato, seme fisso): una misura senza il suo nullo non dice niente.
#
#  Piano e specifica: report/SCHEDE_SIMBOLO_PIANO_2026-10-05.md
#
#  INPUT (un file o una cartella o uno .zip di barre M1, uno per serie):
#   - senza intestazione, HistData:  AAAAMMGG HHMMSS;O;H;L;C;V
#   - con intestazione (qualunque ordine, , o ;): colonne time|date, open,
#     high, low, close (volume ignorato). Tempo AAAA-MM-GG HH:MM[:SS] oppure
#     AAAA.MM.GG HH:MM[:SS]. (Oanda: time,close,high,low,open,volume;
#     export MT5: Time,Open,High,Low,Close,Volume.)
#   - FUSO del file, DICHIARATO da chi lancia (mai dedotto):
#       UTC | NY (ora locale New York, DST USA: HistData) |
#       BCM_UTC1 (server BCM dal 2025: UTC+1 fisso) |
#       BCM_VECCHIO (server BCM fino a dic 2024: UTC+0 inverno, +1 estate) |
#       BCM_MISTO (file di FOREX BCM che attraversa il cambio d'orologio: vecchio prima del
#                  26/12/2024 23:03, UTC+1 fisso dopo il 02/02/2025 23:05, righe in mezzo SCARTATE e contate)
#
#  USO
#    python3 scheda_simbolo.py --autotest
#    python3 scheda_simbolo.py --serie XAUUSD:HistData:NY:cartella_o_zip \
#            [--serie ...] --uscita DIR [--spread SPREAD_VIVO_orario.csv]
#    python3 scheda_simbolo.py --manifest m.csv --uscita DIR
#       manifest: simbolo,feed,fuso,percorso[,unita]   (percorso: glob)
#    python3 scheda_simbolo.py --verifica-mese XAUUSD:HistData:NY:percorso:2024-03
#       (ricalcola l'ADR di UN mese in python puro, senza numpy, e lo
#        confronta con quello della procedura: il controllo indipendente)
#  Codici d'uscita: 0 ok, 2 invalido (autotest o controllo fallito).
#  File ASCII puro. Solo numpy. Nessuna rete, nessun terminale, nessun
#  file scritto fuori da --uscita.
# =====================================================================
import argparse, csv, datetime as dt, glob, io, math, os, re, sys, warnings, zipfile
import numpy as np

VERSIONE = "SCHEDA_SIMBOLO_v1"
EPOCH = dt.datetime(1970, 1, 1)

# ---- parametri DICHIARATI (stanno anche nel piano; se divergono vince il piano)
TFS = (("M15", 15), ("H1", 60), ("H4", 240))
ATR_N = 14
FRAZ_GIORNO_PIENO = 0.5       # giorno "pieno": minuti M1 >= 50% della mediana
SOGLIA_BUCO_NOTTE = 60        # minuti: un buco >= 60 min e' una pausa (gap di apertura)
SOGLIA_BUCO_WEEKEND = 36 * 60  # minuti: >= 36 ore = weekend/festivo lungo
RHO = 0.5                     # inversione dello zigzag, in ATR del TF
KS = (2.0, 3.0, 4.0)          # soglie d'impulso, in ATR del TF
LIVELLI_FIBO = (0.236, 0.382, 0.5, 0.618, 0.786)
ER_N = {"H1": 24, "H4": 20, "D1": 20}
ER_TREND, ER_LATERALE = 0.30, 0.15
EMA_N = 200
EMA_WARMUP = 600              # barre del TF senza misure (riscaldamento)
EMA_SEP, EMA_HOR = 20, 20     # come ema200_rimbalzo.py: separazione e orizzonte
STOP_X_SPREAD = 40.0          # frontiera del costo di casa: stop >= 40 x spread
SEME = 12345

FOREX_CCY = ("EUR", "USD", "GBP", "JPY", "CHF", "CAD", "AUD", "NZD")
# Cambio d'orologio del FOREX BCM (report/OROLOGIO_BCM_2026-09-24.md): dopo il 26/12/2024 23:03 e entro il 02/02/2025 23:05
# (ora server). Il giorno esatto e' [NON MISURATO]: per un file in ora server che attraversa il cambio, le righe nella
# finestra dubbia si SCARTANO (e si contano), prima vale il vecchio orologio, dopo l'UTC+1 fisso.
CAMBIO_OROLOGIO_FOREX = None   # valorizzata sotto, dopo giorni_da_civile()


def log(s=""):
    sys.stdout.write(s + "\n")
    sys.stdout.flush()


# ---------------------------------------------------------------------
# 1. CALENDARIO E FUSI
# ---------------------------------------------------------------------
def _minuti(d):
    return int((d - EPOCH).total_seconds() // 60)


def _nth_sunday(y, m, n):
    d1 = dt.datetime(y, m, 1)
    first = d1 + dt.timedelta(days=(6 - d1.weekday()) % 7)
    return first + dt.timedelta(days=7 * (n - 1))


def _last_sunday(y, m):
    d = dt.datetime(y, m + 1, 1) if m < 12 else dt.datetime(y + 1, 1, 1)
    d -= dt.timedelta(days=1)
    return d - dt.timedelta(days=(d.weekday() + 1) % 7)


def us_dst_bounds_utc(y):
    """(inizio, fine) dell'ora legale USA in minuti UTC dall'epoch.
    Regola dal 2007: 2a domenica di marzo 02:00 EST (=07:00 UTC) -> 1a
    domenica di novembre 02:00 EDT (=06:00 UTC). Prima del 2007: 1a domenica
    di aprile -> ultima domenica di ottobre."""
    if y >= 2007:
        s = _nth_sunday(y, 3, 2) + dt.timedelta(hours=7)
        e = _nth_sunday(y, 11, 1) + dt.timedelta(hours=6)
    else:
        s = _nth_sunday(y, 4, 1) + dt.timedelta(hours=7)
        e = _last_sunday(y, 10) + dt.timedelta(hours=6)
    return _minuti(s), _minuti(e)


def eu_dst_bounds_utc(y):
    """ultima domenica di marzo 01:00 UTC -> ultima domenica di ottobre 01:00 UTC."""
    return (_minuti(_last_sunday(y, 3) + dt.timedelta(hours=1)),
            _minuti(_last_sunday(y, 10) + dt.timedelta(hours=1)))


def _anni(t):
    return (EPOCH + dt.timedelta(minutes=int(t.min()))).year, (EPOCH + dt.timedelta(minutes=int(t.max()))).year


def flag_dst(t_utc, quale):
    """array bool: True se l'ora legale (US o EU) e' attiva a quel minuto UTC."""
    t = np.asarray(t_utc, dtype=np.int64)
    out = np.zeros(len(t), bool)
    if len(t) == 0:
        return out
    y0, y1 = _anni(t)
    for y in range(y0, y1 + 1):
        s, e = (us_dst_bounds_utc(y) if quale == "US" else eu_dst_bounds_utc(y))
        out |= (t >= s) & (t < e)
    return out


def ny_to_utc(tloc):
    """minuti locali New York -> minuti UTC (EST +5h, EDT +4h). Le soglie
    sono date in ora locale: inizio 02:00 EST, fine 02:00 EDT."""
    tloc = np.asarray(tloc, dtype=np.int64)
    out = tloc + 300
    if len(tloc) == 0:
        return out
    y0, y1 = _anni(tloc)
    for y in range(y0, y1 + 1):
        s, e = us_dst_bounds_utc(y)
        # locale: inizio = s - 300 (EST); fine = e - 240 (EDT)
        m = (tloc >= s - 300) & (tloc < e - 240)
        out[m] -= 60
    return out


def verso_utc(tfile, fuso):
    """minuti del file -> minuti UTC, secondo il fuso DICHIARATO."""
    t = np.asarray(tfile, dtype=np.int64)
    if fuso == "UTC":
        return t.copy()
    if fuso == "NY":
        return ny_to_utc(t)
    if fuso == "BCM_UTC1":
        return t - 60
    if fuso == "BCM_VECCHIO":
        # server = UTC+0 d'inverno, UTC+1 d'estate (calendario europeo)
        u = t.copy()
        y0, y1 = _anni(t)
        for y in range(y0, y1 + 1):
            s, e = eu_dst_bounds_utc(y)
            m = (t >= s) & (t < e + 60)
            u[m] -= 60
        return u
    if fuso == "BCM_MISTO":
        # le righe nella finestra dubbia vanno scartate PRIMA (carica_serie); qui: vecchio prima, UTC+1 dopo
        lo = CAMBIO_OROLOGIO_FOREX[0]
        return np.where(t < lo, verso_utc(t, "BCM_VECCHIO"), t - 60)
    raise ValueError("fuso sconosciuto: %s" % fuso)


def a_server(t_utc, orologio="utc1"):
    """minuti UTC -> minuti SERVER BCM. 'utc1' = UTC+1 fisso (dal 2025, e
    indici da sempre); 'vecchio' = UTC+0 inverno / +1 estate (forex fino a
    dicembre 2024). Misura di casa: report/OROLOGIO_BCM_2026-09-24.md."""
    t = np.asarray(t_utc, dtype=np.int64)
    if orologio == "utc1":
        return t + 60
    if orologio == "vecchio":
        return t + np.where(flag_dst(t, "EU"), 60, 0)
    raise ValueError("orologio sconosciuto: %s" % orologio)


def giorni_da_civile(y, m, d):
    y = np.asarray(y, dtype=np.int64); m = np.asarray(m, dtype=np.int64); d = np.asarray(d, dtype=np.int64)
    y = y - (m <= 2)
    era = np.floor_divide(y, 400)
    yoe = y - era * 400
    mp = (m + 9) % 12
    doy = (153 * mp + 2) // 5 + d - 1
    doe = yoe * 365 + yoe // 4 - yoe // 100 + doy
    return era * 146097 + doe - 719468


CAMBIO_OROLOGIO_FOREX = (int(giorni_da_civile(2024, 12, 26)) * 1440 + 23 * 60 + 3, int(giorni_da_civile(2025, 2, 2)) * 1440 + 23 * 60 + 5)


def anno_da_giorni(g):
    g = np.asarray(g, dtype=np.int64)
    return np.array(g, dtype="datetime64[D]").astype("datetime64[Y]").astype(np.int64) + 1970


def data_da_giorno(g):
    return (EPOCH + dt.timedelta(days=int(g))).strftime("%Y-%m-%d")


# ---------------------------------------------------------------------
# 2. LETTURA DEI FILE M1
# ---------------------------------------------------------------------
_RE_SEC = re.compile(rb"^(\d{4}[-./]\d{2}[-./]\d{2}[ T]\d{2}:\d{2})(?=[,;])", re.M)
_RE_TS = re.compile(rb"^(\d{4})[-./](\d{2})[-./](\d{2})[ T](\d{2}):(\d{2}):(\d{2})", re.M)
_RE_RIGA_H = re.compile(r"^\s*(\d{8}) (\d{6})[;,]")
_RE_RIGA_T = re.compile(r"^\s*(\d{4})[-./](\d{2})[-./](\d{2})[ T](\d{2}):(\d{2})(?::(\d{2}))?")


def _minuti_da_ymdhm(Y, M, D, h, mi):
    return giorni_da_civile(Y, M, D) * 1440 + np.asarray(h, dtype=np.int64) * 60 + np.asarray(mi, dtype=np.int64)


def leggi_bytes(data):
    """ritorna (t_file_min, o, h, l, c, info). info: righe, scartate, secondi_non_zero."""
    data = data.replace(b"\r", b"")
    righe = [x for x in data.split(b"\n", 3)[:3]]
    prima = righe[0] if righe else b""
    intest = bool(re.search(rb"[A-Za-z]", prima))
    sep = b";" if prima.count(b";") > prima.count(b",") else b","
    if intest:
        nomi = [x.strip().lower() for x in prima.decode("ascii", "replace").split(sep.decode())]
        corpo = data.split(b"\n", 1)[1] if b"\n" in data else b""
        try:
            ix = {k: nomi.index(k) for k in ("open", "high", "low", "close")}
        except ValueError:
            raise ValueError("intestazione senza open/high/low/close: %s" % nomi)
        if nomi[0] not in ("time", "date", "datetime", "<date>", "timestamp"):
            raise ValueError("la prima colonna deve essere il tempo (time/date): %s" % nomi[0])
    else:
        nomi = None
        corpo = data
        ix = {"open": 1, "high": 2, "low": 3, "close": 4}
    corpo = corpo.strip(b"\n")
    nrighe = corpo.count(b"\n") + 1 if corpo else 0
    info = {"righe": nrighe, "scartate": 0, "secondi_non_zero": 0}
    if nrighe == 0:
        return (np.zeros(0, np.int64),) + tuple(np.zeros(0) for _ in range(4)) + (info,)
    arr = None
    try:
        if intest:
            c1 = _RE_SEC.sub(rb"\1:00", corpo)
            c2 = _RE_TS.sub(rb"\1 \2 \3 \4 \5 \6", c1)
            c2 = c2.replace(sep, b" ")
            ncol = 6 + (len(nomi) - 1)
            with warnings.catch_warnings():
                warnings.simplefilter("error")          # un dato non letto fino in fondo NON passa in silenzio
                toks = np.fromstring(c2, dtype=np.float64, sep=" ")
            if toks.size == nrighe * ncol:
                A = toks.reshape(nrighe, ncol)
                Y, M, D, hh, mi, ss = (A[:, k] for k in range(6))
                col = {k: A[:, 5 + v] for k, v in ix.items()}
                arr = (Y, M, D, hh, mi, ss, col)
        else:
            primarg = corpo.split(b"\n", 1)[0]
            ncol = primarg.count(sep) + 2
            with warnings.catch_warnings():
                warnings.simplefilter("error")
                toks = np.fromstring(corpo.replace(sep, b" "), dtype=np.float64, sep=" ")
            if toks.size == nrighe * ncol and ncol >= 6:
                A = toks.reshape(nrighe, ncol)
                dd = A[:, 0].astype(np.int64)
                tt = A[:, 1].astype(np.int64)
                Y, M, D = dd // 10000, (dd // 100) % 100, dd % 100
                hh, mi, ss = tt // 10000, (tt // 100) % 100, tt % 100
                col = {k: A[:, 1 + v] for k, v in ix.items()}
                arr = (Y, M, D, hh, mi, ss, col)
    except Exception:
        arr = None
    if arr is None:
        # via lenta: riga per riga, le malformate si contano (non spariscono)
        T, O, H, L, C, S = [], [], [], [], [], 0
        scart = 0
        for ln in corpo.decode("ascii", "replace").split("\n"):
            p = ln.strip().split(sep.decode())
            try:
                if intest:
                    mt = _RE_RIGA_T.match(ln)
                    y, mo, d, h_, m_ = (int(mt.group(k)) for k in range(1, 6))
                    s_ = int(mt.group(6) or 0)
                    vals = {k: float(p[ix[k]]) for k in ix}
                else:
                    mt = _RE_RIGA_H.match(ln)
                    y, mo, d = int(mt.group(1)[:4]), int(mt.group(1)[4:6]), int(mt.group(1)[6:8])
                    h_, m_, s_ = int(mt.group(2)[:2]), int(mt.group(2)[2:4]), int(mt.group(2)[4:6])
                    vals = {k: float(p[ix[k]]) for k in ix}
                T.append(int(giorni_da_civile(y, mo, d)) * 1440 + h_ * 60 + m_)
                O.append(vals["open"]); H.append(vals["high"]); L.append(vals["low"]); C.append(vals["close"])
                S += 1 if s_ != 0 else 0
            except Exception:
                scart += 1
        info["scartate"] = scart
        info["secondi_non_zero"] = S
        return (np.array(T, dtype=np.int64), np.array(O), np.array(H), np.array(L), np.array(C), info)
    Y, M, D, hh, mi, ss, col = arr
    info["secondi_non_zero"] = int(np.count_nonzero(np.asarray(ss) != 0))
    t = _minuti_da_ymdhm(np.asarray(Y, np.int64), np.asarray(M, np.int64), np.asarray(D, np.int64),
                         np.asarray(hh, np.int64), np.asarray(mi, np.int64))
    return t, col["open"].copy(), col["high"].copy(), col["low"].copy(), col["close"].copy(), info


def _membri(percorso):
    """espande percorso -> lista di (nome, bytes): file, cartella, zip, glob."""
    out = []
    cand = []
    for p in sorted(glob.glob(percorso)) if any(ch in percorso for ch in "*?[") else [percorso]:
        if os.path.isdir(p):
            for q in sorted(os.listdir(p)):
                cand.append(os.path.join(p, q))
        else:
            cand.append(p)
    for p in cand:
        lp = p.lower()
        if lp.endswith(".zip"):
            with zipfile.ZipFile(p) as z:
                for n in sorted(z.namelist()):
                    if n.lower().endswith(".csv"):
                        out.append((p + "!" + n, z.read(n)))
        elif lp.endswith(".csv"):
            with open(p, "rb") as f:
                out.append((p, f.read()))
    return out


def carica_serie(simbolo, feed, fuso, percorso, orologio="utc1", unita=None, log_=log):
    """legge tutti i file di `percorso`, converte, pulisce. Ritorna dict serie."""
    mem = _membri(percorso)
    if not mem:
        raise FileNotFoundError("nessun file M1 in: %s" % percorso)
    T, O, H, L, C = [], [], [], [], []
    info = {"file": 0, "righe": 0, "scartate_parse": 0, "secondi_non_zero": 0}
    for nome, b in mem:
        t, o, h, l, c, i = leggi_bytes(b)
        if len(t) == 0:
            continue
        T.append(t); O.append(o); H.append(h); L.append(l); C.append(c)
        info["file"] += 1
        info["righe"] += i["righe"]
        info["scartate_parse"] += i["scartate"]
        info["secondi_non_zero"] += i["secondi_non_zero"]
    if not T:
        raise ValueError("file vuoti: %s" % percorso)
    tf_ = np.concatenate(T)
    a = np.array([np.concatenate(O), np.concatenate(H), np.concatenate(L), np.concatenate(C)])
    info["scartate_cambio_orologio"] = 0
    if fuso == "BCM_MISTO":
        dubbia = (tf_ >= CAMBIO_OROLOGIO_FOREX[0]) & (tf_ < CAMBIO_OROLOGIO_FOREX[1])
        info["scartate_cambio_orologio"] = int(dubbia.sum())
        tf_, a = tf_[~dubbia], a[:, ~dubbia]
    t = verso_utc(tf_, fuso)
    ok = (a[2] <= a[0]) & (a[0] <= a[1]) & (a[2] <= a[3]) & (a[3] <= a[1]) & (a[2] > 0)
    info["scartate_ohlc"] = int((~ok).sum())
    t, a = t[ok], a[:, ok]
    info["fuori_ordine"] = int(np.count_nonzero(np.diff(t) < 0))
    o_ = np.argsort(t, kind="stable")
    t, a = t[o_], a[:, o_]
    keep = np.ones(len(t), bool)
    keep[1:] = t[1:] != t[:-1]
    info["doppi"] = int((~keep).sum())
    t, a = t[keep], a[:, keep]
    s = dict(simbolo=simbolo, feed=feed, fuso=fuso, orologio=orologio, percorso=percorso, info=info,
             t=t, o=a[0], h=a[1], l=a[2], c=a[3])
    s["unita"] = unita if unita else unita_di(simbolo)
    return s


def unita_di(simbolo):
    """pip per il forex (0,01 se c'e' JPY, altrimenti 0,0001), 1,0 per tutto il resto
    (indici e metalli a punti di prezzo). Come PipSize del dashboard EMA200."""
    s = simbolo.upper()
    if len(s) == 6 and s[:3] in FOREX_CCY and s[3:] in FOREX_CCY:
        return 0.01 if "JPY" in s else 0.0001
    return 1.0


# ---------------------------------------------------------------------
# 3. GIORNI, BARRE, INDICATORI
# ---------------------------------------------------------------------
def etichette_giorno(t_utc, orologio="utc1", modo="utc1"):
    """(giorno, minuto_nel_giorno) per ogni M1. modo 'utc1' = giorno del SERVER
    BCM (mezzanotte server); 'nyclose' = giorno che chiude alle 17:00 di New
    York (stesse formule di ema200_d1_su_m5.py). Sabato/domenica -> lunedi'."""
    t = np.asarray(t_utc, dtype=np.int64)
    if modo == "utc1":
        ts = a_server(t, orologio)
        d = ts // 1440
        md = ts % 1440
    elif modo == "nyclose":
        off = np.where(flag_dst(t, "US"), 240, 300)
        x = t - off + 420
        d = x // 1440
        md = x % 1440
    else:
        raise ValueError(modo)
    wd = (d + 3) % 7                     # 0 = lunedi'
    d = d + np.where(wd == 5, 2, np.where(wd == 6, 1, 0))
    return d, md


def segmenti(g):
    ch = np.empty(len(g), bool)
    ch[0] = True
    ch[1:] = g[1:] != g[:-1]
    st = np.flatnonzero(ch)
    en = np.append(st[1:], len(g))
    return st, en


def sma(x, n):
    cs = np.cumsum(np.insert(np.asarray(x, dtype=np.float64), 0, 0.0))
    out = np.full(len(x), np.nan)
    if len(x) >= n:
        out[n - 1:] = (cs[n:] - cs[:-n]) / n
    return out


def ema(x, n):
    a = 2.0 / (n + 1.0)
    out = np.empty(len(x))
    xs = np.asarray(x, dtype=np.float64).tolist()
    e = xs[0]
    for i, v in enumerate(xs):
        e = e + a * (v - e)
        out[i] = e
    return out


def true_range(o, h, l, c):
    pc = np.insert(c[:-1], 0, o[0])
    return np.maximum(h - l, np.maximum(np.abs(h - pc), np.abs(l - pc)))


def atr_sma(o, h, l, c, n=ATR_N):
    """ATR come iATR di MT5: media SEMPLICE del true range su n barre (non Wilder)."""
    return sma(true_range(o, h, l, c), n)


def costruisci(s, modo_giorno="utc1"):
    """aggiunge a `s` giorni D1 e barre per TF. Tutto in una passata."""
    t = s["t"]
    g, md = etichette_giorno(t, s["orologio"], modo_giorno)
    st, en = segmenti(g)
    n = en - st
    d1 = dict(st=st, en=en, giorno=g[st], n=n,
              o=s["o"][st], c=s["c"][en - 1],
              h=np.maximum.reduceat(s["h"], st), l=np.minimum.reduceat(s["l"], st))
    med = float(np.median(n))
    d1["pieno"] = n >= FRAZ_GIORNO_PIENO * med
    s["g"], s["md"], s["d1"], s["modo_giorno"] = g, md, d1, modo_giorno
    didx = np.cumsum(np.r_[True, g[1:] != g[:-1]]) - 1
    s["didx"] = didx
    s["barre"] = {}
    for nome, tfm in TFS:
        s["barre"][nome] = barre_tf(s, tfm)
    return s


def barre_tf(s, tfm):
    bin_id = s["didx"].astype(np.int64) * 2000 + s["md"] // tfm
    st, en = segmenti(bin_id)
    b = dict(st=st, en=en, o=s["o"][st], c=s["c"][en - 1],
             h=np.maximum.reduceat(s["h"], st), l=np.minimum.reduceat(s["l"], st),
             tu=s["t"][st], day=s["didx"][st], nm1=en - st)
    return b


# ---------------------------------------------------------------------
# 4. QUALITA' E OROLOGIO (i cancelli prima dei numeri)
# ---------------------------------------------------------------------
def picco_minuto(t, o, c, mesi, finestra=5):
    """Minuto-del-giorno (UTC) di massima ampiezza media |c-o|/c nei mesi dati, su un profilo LISCIATO su
    `finestra` minuti (circolare): su un campione corto il singolo minuto piu' alto e' rumore.
    Ritorna (minuto, giorni_distinti, decisivita) con decisivita = picco / mediana del profilo."""
    dd = np.array(t // 1440, dtype="datetime64[D]")
    mm = (dd.astype("datetime64[M]").astype(np.int64) % 12) + 1
    sel = np.isin(mm, mesi)
    if not sel.any():
        return None, 0, 0.0
    mod = (t[sel] % 1440).astype(np.int64)
    amp = np.abs(c[sel] - o[sel]) / np.maximum(c[sel], 1e-12)
    ssum = np.bincount(mod, weights=amp, minlength=1440)
    nn = np.bincount(mod, minlength=1440)
    mean = np.where(nn >= 30, ssum / np.maximum(nn, 1), 0.0)
    sm = np.zeros(1440)
    for k in range(-(finestra // 2), finestra // 2 + 1):
        sm += np.roll(mean, k)
    sm /= finestra
    valido = sm[sm > 0]
    dec = float(sm.max() / np.median(valido)) if len(valido) else 0.0
    k0 = int(np.argmax(sm))
    # il profilo liscio trova DOVE sta il picco; il minuto esatto si rilegge sul profilo grezzo (+-3 minuti):
    # lisciare una coda che decade sposta il massimo in avanti di 1-2 minuti (misurato sul S&P: 14:33 invece di 14:30)
    cand = [(k0 + j) % 1440 for j in range(-3, 4)]
    kk = max(cand, key=lambda x: mean[x])
    return int(kk), int(len(np.unique(t[sel] // 1440))), dec


# ancore ASSOLUTE dell'orologio (minuti UTC d'INVERNO, ora solare). Un controllo solo relativo
# (inverno - estate = 60) NON vede un offset costante sbagliato (lezione del 10/09): serve un
# evento del mondo a ora fissa. LIMITE DICHIARATO: 13:30 (dati USA 8:30 ET) e 14:30 (apertura
# cash NY 9:30 ET) distano esattamente 1 ora, quindi un errore di 1 ora fra questi DUE non e' visto.
ANCORE_UTC = ((420, "07:00 apertura Europa pre-cash"), (480, "08:00 apertura Londra / Xetra 09:00 CET"),
              (810, "13:30 dati USA 8:30 ET"), (870, "14:30 apertura cash NY 9:30 ET"), (900, "15:00 dati USA 10:00 ET"))
ANCORE_SENZA_DST = ((0, "00:00 apertura Tokyo 09:00 JST"), (360, "06:00 chiusura Tokyo 15:00 JST"))


def ancora_vicina(minuto, tol=5):
    if minuto is None:
        return None
    for m, nome in ANCORE_UTC + ANCORE_SENZA_DST:
        if abs(minuto - m) <= tol:
            return nome
    return None


def ancora_senza_dst(nome):
    return nome is not None and nome in [n for _, n in ANCORE_SENZA_DST]


def hhmm(x):
    return "--:--" if x is None else "%02d:%02d" % (x // 60, x % 60)


def qualita(s):
    t = s["t"]
    inf = s["info"]
    dif = np.diff(t)
    buchi_int = int(np.count_nonzero((dif > 1) & (dif < SOGLIA_BUCO_NOTTE)))
    minuti_mancanti = int(dif[(dif > 1) & (dif < SOGLIA_BUCO_NOTTE)].sum() - np.count_nonzero((dif > 1) & (dif < SOGLIA_BUCO_NOTTE)))
    w, nw, dw = picco_minuto(t, s["o"], s["c"], (1, 2))
    e, ne, de = picco_minuto(t, s["o"], s["c"], (6, 7, 8))
    d1 = s["d1"]
    q = dict(
        n_m1=len(t),
        da=(EPOCH + dt.timedelta(minutes=int(t[0]))).strftime("%Y-%m-%d %H:%M"),
        a=(EPOCH + dt.timedelta(minutes=int(t[-1]))).strftime("%Y-%m-%d %H:%M"),
        file=inf["file"], righe=inf["righe"], scartate_parse=inf["scartate_parse"],
        scartate_ohlc=inf["scartate_ohlc"], doppi=inf["doppi"], fuori_ordine=inf["fuori_ordine"],
        secondi_non_zero=inf["secondi_non_zero"], scartate_cambio_orologio=inf.get("scartate_cambio_orologio", 0),
        barre_range_zero_pct=float(100.0 * np.count_nonzero(s["h"] == s["l"]) / len(t)),
        prezzo_min=float(s["l"].min()), prezzo_max=float(s["h"].max()),
        buchi_interni_1_59min=buchi_int, minuti_mancanti_interni=minuti_mancanti,
        giorni=len(d1["st"]), giorni_pieni=int(d1["pieno"].sum()),
        m1_per_giorno_mediana=float(np.median(d1["n"])),
        picco_inverno_utc=w, picco_estate_utc=e, giorni_inverno=nw, giorni_estate=ne, decisivita_inverno=dw, decisivita_estate=de,
    )
    anni_d = anno_da_giorni(d1["giorno"])
    q["m1_giorno_per_anno"] = {int(y): float(np.median(d1["n"][anni_d == y])) for y in sorted(set(anni_d.tolist()))}
    q["ancora_inverno"] = ancora_vicina(w)
    # coerenza inverno/estate: un evento a ora fissa USA/Europa si sposta di 60 minuti (UTC) con l'ora legale;
    # un evento di Tokyo (niente ora legale) NON si sposta
    if w is not None and e is not None:
        q["orologio_dst_ok"] = (abs(w - e) <= 5) if ancora_senza_dst(q["ancora_inverno"]) else (abs((w - 60) - e) <= 5)
    else:
        q["orologio_dst_ok"] = False
    # il verdetto: INDECISO se il campione e' corto (< 40 giorni per stagione) o il picco non spicca (< 1,5 x mediana)
    q["orologio_indeciso"] = bool(nw < 40 or ne < 40 or dw < 1.5 or de < 1.5)
    q["orologio_ok"] = bool(q["orologio_dst_ok"] and q["ancora_inverno"] and not q["orologio_indeciso"])
    q["orologio_verdetto"] = "ok" if q["orologio_ok"] else ("INDECISO (campione corto o picco poco netto: il singolo minuto e' rumore)" if q["orologio_indeciso"] else "DA GUARDARE (fuso, feed, o picco dominato da un evento locale con ora legale propria, es. Australia: in quel caso il controllo non si applica a questo simbolo)")
    return q


# ---------------------------------------------------------------------
# 5. MISURE GIORNALIERE: ADR, ATR, distribuzione, per anno, per giorno-settimana
# ---------------------------------------------------------------------
def stat(x, qs=(10, 25, 50, 75, 90, 95)):
    x = np.asarray(x, dtype=np.float64)
    x = x[np.isfinite(x)]
    if len(x) == 0:
        return dict(n=0, media=float("nan"), **{"p%d" % q: float("nan") for q in qs})
    d = dict(n=len(x), media=float(x.mean()))
    for q in qs:
        d["p%d" % q] = float(np.percentile(x, q))
    return d


def misure_giornaliere(s):
    d1 = s["d1"]
    u = s["unita"]
    p = d1["pieno"]
    rng = (d1["h"] - d1["l"])
    rng_pct = 100.0 * rng / d1["o"]
    # true range D1 con la chiusura del giorno pieno precedente
    pcl = np.r_[d1["o"][0], d1["c"][:-1]]
    tr = np.maximum(rng, np.maximum(np.abs(d1["h"] - pcl), np.abs(d1["l"] - pcl)))
    # ATR D1 sui soli giorni pieni
    idx = np.flatnonzero(p)
    o_, h_, l_, c_ = d1["o"][idx], d1["h"][idx], d1["l"][idx], d1["c"][idx]
    atr_p = atr_sma(o_, h_, l_, c_, ATR_N)
    atr_full = np.full(len(rng), np.nan)
    atr_full[idx] = atr_p
    giorno = d1["giorno"]
    anno = anno_da_giorni(giorno)
    wd = (giorno + 3) % 7
    M = dict(rng=rng, rng_pct=rng_pct, tr=tr, atr_d1=atr_full, anno=anno, wd=wd, pieno=p, unita=u)
    M["adr_pt"] = stat(rng[p] / u)
    M["adr_pct"] = stat(rng_pct[p])
    M["tr_pt"] = stat(tr[p] / u)
    M["atr_d1_pt"] = stat(atr_full[p] / u)
    M["atr_d1_pct"] = stat(100.0 * atr_full[p] / d1["c"][p])
    # estensione: quanti giorni > k x mediana
    med = np.median(rng[p])
    M["frac_giorni_gt_1_5_mediana"] = float(np.mean(rng[p] > 1.5 * med))
    M["frac_giorni_gt_2_mediana"] = float(np.mean(rng[p] > 2.0 * med))
    M["frac_giorni_lt_0_5_mediana"] = float(np.mean(rng[p] < 0.5 * med))
    # per anno
    per_anno = []
    for y in sorted(set(anno.tolist())):
        m = p & (anno == y)
        if m.sum() < 1:
            continue
        per_anno.append(dict(anno=int(y), n=int(m.sum()), adr_pt_med=float(np.median(rng[m]) / u),
                             adr_pt_media=float(rng[m].mean() / u), adr_pct_med=float(np.median(rng_pct[m])),
                             adr_pct_media=float(rng_pct[m].mean())))
    M["per_anno"] = per_anno
    # per giorno della settimana (0=lun ... 4=ven; sab/dom attribuiti al lunedi' dall'etichetta)
    per_wd = []
    for k in range(5):
        m = p & (wd == k)
        if m.sum() < 1:
            continue
        per_wd.append(dict(wd=k, n=int(m.sum()), med=float(np.median(rng[m]) / u), media=float(rng[m].mean() / u)))
    mm = np.mean([r["media"] for r in per_wd]) if per_wd else float("nan")
    for r in per_wd:
        r["indice"] = r["media"] / mm
    M["per_wd"] = per_wd
    # volatilita' realizzata annualizzata dai rendimenti log close-close D1 (giorni pieni consecutivi)
    cc = d1["c"][p]
    r = np.diff(np.log(cc))
    M["rv_ann_pct"] = float(100.0 * r.std(ddof=1) * math.sqrt(252.0)) if len(r) > 2 else float("nan")
    # ultimi ~252 giorni pieni
    ult = np.flatnonzero(p)[-252:]
    M["adr_pct_med_ult252"] = float(np.median(rng_pct[ult])) if len(ult) else float("nan")
    M["adr_pt_med_ult252"] = float(np.median(rng[ult]) / u) if len(ult) else float("nan")
    return M


# ---------------------------------------------------------------------
# 6. ATR PER TF
# ---------------------------------------------------------------------
def misure_atr_tf(s, M):
    u = s["unita"]
    out = {}
    for nome, tfm in TFS:
        b = s["barre"][nome]
        a = atr_sma(b["o"], b["h"], b["l"], b["c"], ATR_N)
        ok = np.isfinite(a)
        anni = anno_da_giorni(b["tu"] // 1440)
        pa = {}
        for y in sorted(set(anni[ok].tolist())):
            pa[int(y)] = float(np.median(a[ok & (anni == y)]) / u)
        # ultimi 252 giorni: barre dei giorni degli ultimi 252 pieni
        d1 = s["d1"]
        ult_days = np.flatnonzero(d1["pieno"])[-252:]
        mu = np.isin(b["day"], ult_days)
        out[nome] = dict(tfm=tfm, n_barre=int(len(b["o"])), atr_med=float(np.median(a[ok]) / u),
                         atr_media=float(np.mean(a[ok]) / u),
                         atr_pct_med=float(100.0 * np.median(a[ok] / b["c"][ok])),
                         atr_ult252=float(np.median(a[ok & mu]) / u) if (ok & mu).any() else float("nan"),
                         per_anno=pa, serie=a)
    # legge radice-di-T: ATR(H4)/ATR(H1) atteso 2 se i rendimenti sono indipendenti
    out["rapporto_H1_M15"] = out["H1"]["atr_med"] / out["M15"]["atr_med"]
    out["rapporto_H4_H1"] = out["H4"]["atr_med"] / out["H1"]["atr_med"]
    out["adr_su_atr_h1"] = M["adr_pt"]["p50"] / out["H1"]["atr_med"]
    return out


# ---------------------------------------------------------------------
# 7. SESSIONI, ORE, GAP
# ---------------------------------------------------------------------
SESSIONI = (
    # nome, (inverno_utc_ini, fine), (estate_utc_ini, fine), dst di riferimento, descrizione
    ("ASIA", (0, 360), (0, 360), None, "Tokyo 09:00-15:00 JST (UTC+9, niente ora legale)"),
    ("LONDRA", (480, 990), (420, 930), "EU", "Londra 08:00-16:30 locale"),
    ("NY", (870, 1260), (810, 1200), "US", "New York 09:30-16:00 locale"),
)


def misure_sessioni(s):
    t = s["t"]
    u = s["unita"]
    du = t // 1440
    mu = t % 1440
    eu = flag_dst(t, "EU")
    us = flag_dst(t, "US")
    rows = []
    stu, enu = segmenti(du)
    # range intero della data UTC (denominatore)
    for nome, inv, est, ref, desc in SESSIONI:
        if ref is None:
            ini = np.full(len(t), inv[0]); fin = np.full(len(t), inv[1])
        else:
            dst = eu if ref == "EU" else us
            ini = np.where(dst, est[0], inv[0]); fin = np.where(dst, est[1], inv[1])
        mask = (mu >= ini) & (mu < fin)
        durata = (fin - ini)
        if not mask.any():
            continue
        du_m = du[mask]
        st, en = segmenti(du_m)
        hh = np.maximum.reduceat(s["h"][mask], st)
        ll = np.minimum.reduceat(s["l"][mask], st)
        nn = en - st
        oo = s["o"][mask][st]
        dur = durata[mask][st]
        ok = nn >= 0.5 * dur
        giorno_u = du_m[st]
        wd = (giorno_u + 3) % 7
        ok &= wd < 5
        r = (hh - ll)[ok]
        rp = (100.0 * (hh - ll) / oo)[ok]
        rows.append(dict(nome=nome, desc=desc, n=int(ok.sum()), med=float(np.median(r) / u) if ok.any() else float("nan"),
                         media=float(r.mean() / u) if ok.any() else float("nan"),
                         p90=float(np.percentile(r, 90) / u) if ok.any() else float("nan"),
                         med_pct=float(np.median(rp)) if ok.any() else float("nan"),
                         ini_inv=inv[0], fin_inv=inv[1], ini_est=est[0], fin_est=est[1]))
    return rows


def misure_ore(s):
    """range per ORA SERVER: mediana e media per ora, inverno (dic-feb), estate (giu-ago), anno."""
    t = s["t"]
    u = s["unita"]
    ts = a_server(t, s["orologio"])
    ora = (ts % 1440) // 60
    dgs = ts // 1440
    key = dgs * 24 + ora
    st, en = segmenti(key)
    hh = np.maximum.reduceat(s["h"], st)
    ll = np.minimum.reduceat(s["l"], st)
    k = key[st]
    orav = (k % 24).astype(int)
    dg = k // 24
    dd = np.array(dg, dtype="datetime64[D]")
    mese = (dd.astype("datetime64[M]").astype(np.int64) % 12) + 1
    wd = (dg + 3) % 7
    nn = en - st
    ok = (nn >= 30) & (wd < 5)
    r = (hh - ll) / u
    rows = []
    tot = 0.0
    for h in range(24):
        m = ok & (orav == h)
        if m.sum() < 5:
            rows.append(dict(ora=h, n=int(m.sum()), med=float("nan"), media=float("nan"), inv=float("nan"), est=float("nan")))
            continue
        mi = m & np.isin(mese, (12, 1, 2))
        me = m & np.isin(mese, (6, 7, 8))
        rows.append(dict(ora=h, n=int(m.sum()), med=float(np.median(r[m])), media=float(r[m].mean()),
                         inv=float(np.median(r[mi])) if mi.sum() >= 5 else float("nan"),
                         est=float(np.median(r[me])) if me.sum() >= 5 else float("nan")))
        tot += r[m].mean()
    for x in rows:
        x["quota_pct"] = 100.0 * x["media"] / tot if (tot > 0 and np.isfinite(x["media"])) else float("nan")
    return rows


def misure_gap(s, M):
    """gap di apertura: primo open dopo un buco >= 60 min contro l'ultima chiusura. Classe:
    'pausa' (60 min - 36 ore) e 'weekend' (>= 36 ore). Riempito = nel segmento che segue il buco
    il prezzo torna alla chiusura precedente."""
    t = s["t"]
    u = s["unita"]
    dif = np.diff(t)
    ev = np.flatnonzero(dif >= SOGLIA_BUCO_NOTTE) + 1       # indice del primo M1 dopo il buco
    atr_med = M["atr_d1_pt"]["p50"] * u
    out = {}
    if len(ev) == 0:
        return out
    fine_seg = np.append(ev[1:], len(t))
    gap = s["o"][ev] - s["c"][ev - 1]
    buco = dif[ev - 1]
    # riempimento: nel segmento [ev, fine_seg) il minimo <= c_prec (gap su) o il massimo >= c_prec (gap giu)
    segmin = np.minimum.reduceat(s["l"], ev)
    segmax = np.maximum.reduceat(s["h"], ev)
    # reduceat con indici ev: l'ultimo segmento corre fino alla fine, e' coerente con fine_seg
    riemp = np.where(gap > 0, segmin <= s["c"][ev - 1], segmax >= s["c"][ev - 1])
    for nome, m in (("pausa", buco < SOGLIA_BUCO_WEEKEND), ("weekend", buco >= SOGLIA_BUCO_WEEKEND)):
        if m.sum() < 3:
            out[nome] = dict(n=int(m.sum()))
            continue
        a = np.abs(gap[m])
        out[nome] = dict(n=int(m.sum()), med_pt=float(np.median(a) / u), media_pt=float(a.mean() / u),
                         p95_pt=float(np.percentile(a, 95) / u),
                         med_atr=float(np.median(a) / atr_med) if atr_med > 0 else float("nan"),
                         p95_atr=float(np.percentile(a, 95) / atr_med) if atr_med > 0 else float("nan"),
                         frac_gt_025atr=float(np.mean(a > 0.25 * atr_med)),
                         su_pct=float(100.0 * np.mean(gap[m] > 0)),
                         riempito_pct=float(100.0 * np.mean(riemp[m])),
                         riempito_gt025_pct=float(100.0 * np.mean(riemp[m & (np.abs(gap) > 0.25 * atr_med)])) if (m & (np.abs(gap) > 0.25 * atr_med)).sum() >= 3 else float("nan"),
                         buco_med_ore=float(np.median(buco[m]) / 60.0))
    return out


# ---------------------------------------------------------------------
# 8. RITRACCIAMENTO (zigzag a soglia ATR) E RAPPORTO TREND/LATERALE
# ---------------------------------------------------------------------
def zigzag(h, l, atrv, rho):
    """Pivot di uno zigzag a inversione rho*ATR. Una barra che fa un nuovo estremo
    non puo' anche confermare l'inversione (convenzione dichiarata: l'ordine
    interno H/L della barra non e' noto). Ritorna lista (indice, prezzo, +1 massimo/-1 minimo)
    dei soli pivot CONFERMATI. Descrittivo: il pivot si conosce in ritardo, non e' operabile."""
    n = len(h)
    piv = []
    i0 = 0
    while i0 < n and not np.isfinite(atrv[i0]):
        i0 += 1
    if i0 >= n:
        return piv
    hl = h.tolist(); ll = l.tolist(); av = atrv.tolist()
    d = 0
    hi, hi_i, lo, lo_i = hl[i0], i0, ll[i0], i0
    ext, ext_i = 0.0, 0
    for i in range(i0 + 1, n):
        thr = rho * av[i]
        if d == 0:
            if hl[i] - lo >= thr and lo_i < i:        # e' salito di thr dal minimo: il minimo e' un pivot
                piv.append((lo_i, lo, -1)); d = +1; ext, ext_i = hl[i], i
                continue
            if hi - ll[i] >= thr and hi_i < i:        # e' sceso di thr dal massimo: il massimo e' un pivot
                piv.append((hi_i, hi, +1)); d = -1; ext, ext_i = ll[i], i
                continue
            if hl[i] > hi:
                hi, hi_i = hl[i], i
            if ll[i] < lo:
                lo, lo_i = ll[i], i
            continue
        if d == +1:
            if hl[i] > ext:
                ext, ext_i = hl[i], i
            elif ext - ll[i] >= thr:
                piv.append((ext_i, ext, +1)); d = -1; ext, ext_i = ll[i], i
        else:
            if ll[i] < ext:
                ext, ext_i = ll[i], i
            elif hl[i] - ext >= thr:
                piv.append((ext_i, ext, -1)); d = +1; ext, ext_i = hl[i], i
    return piv


def ritracciamenti(h, l, atrv, rho=RHO, ks=KS, livelli=LIVELLI_FIBO):
    """Per ogni soglia k: gli impulsi (gamba di zigzag >= k*ATR al suo termine) e il ritracciamento
    della gamba successiva, come frazione dell'impulso. Ritorna dict k -> statistiche."""
    piv = zigzag(h, l, atrv, rho)
    out = {}
    if len(piv) < 3:
        return {k: dict(n=0) for k in ks}
    idx = np.array([p[0] for p in piv]); pr = np.array([p[1] for p in piv]); di = np.array([p[2] for p in piv])
    leg = np.abs(np.diff(pr))                    # leg[j]: da pivot j a j+1
    atr_fine = atrv[idx[1:]]                     # ATR al termine della gamba j
    ok_atr = np.isfinite(atr_fine) & (atr_fine > 0)
    ratio = np.full(len(leg), np.nan)
    ratio[:-1] = leg[1:] / np.where(leg[:-1] > 0, leg[:-1], np.nan)
    tempo = np.full(len(leg), np.nan)
    tempo[:-1] = (idx[2:] - idx[1:-1]).astype(float)
    dirv = np.sign(np.diff(pr))                  # +1 impulso rialzista, -1 ribassista
    for k in ks:
        m = ok_atr & (leg >= k * atr_fine) & np.isfinite(ratio)
        n = int(m.sum())
        if n == 0:
            out[k] = dict(n=0)
            continue
        r = ratio[m]
        floor = rho / k
        d = dict(n=n, media=float(r.mean()), mediana=float(np.median(r)), p25=float(np.percentile(r, 25)),
                 p75=float(np.percentile(r, 75)), floor=floor,
                 tempo_med=float(np.median(tempo[m])), tempo_media=float(tempo[m].mean()),
                 inversione=float(np.mean(r >= 1.0)),
                 su_n=int((m & (dirv > 0)).sum()), giu_n=int((m & (dirv < 0)).sum()),
                 ritr_su=float(np.mean(ratio[m & (dirv > 0)])) if (m & (dirv > 0)).sum() >= 5 else float("nan"),
                 ritr_giu=float(np.mean(ratio[m & (dirv < 0)])) if (m & (dirv < 0)).sum() >= 5 else float("nan"))
        d["tocco"] = {lv: (float(np.mean(r >= lv)) if lv > floor + 1e-9 else None) for lv in livelli}
        out[k] = d
    return out


def efficiency_ratio(c, n):
    c = np.asarray(c, dtype=np.float64)
    if len(c) <= n:
        return np.zeros(0)
    net = np.abs(c[n:] - c[:-n])
    path = np.convolve(np.abs(np.diff(c)), np.ones(n), mode="valid")
    with np.errstate(divide="ignore", invalid="ignore"):
        er = np.where(path > 0, net / path, np.nan)
    return er


def misure_er(s):
    out = {}
    series = {"H1": s["barre"]["H1"]["c"], "H4": s["barre"]["H4"]["c"], "D1": s["d1"]["c"][s["d1"]["pieno"]]}
    for nome, n in ER_N.items():
        er = efficiency_ratio(series[nome], n)
        er = er[np.isfinite(er)]
        if len(er) == 0:
            out[nome] = dict(n=0)
            continue
        out[nome] = dict(n=len(er), N=n, med=float(np.median(er)), media=float(er.mean()),
                         trend=float(np.mean(er >= ER_TREND)), laterale=float(np.mean(er <= ER_LATERALE)),
                         rif_rw=1.0 / math.sqrt(n))
    return out


# ---------------------------------------------------------------------
# 9. COMPORTAMENTO ALLA EMA200 (DESCRITTIVO, NON UN TEST DI EDGE)
# ---------------------------------------------------------------------
def comportamento_ema(o, h, l, c, n=EMA_N, warm=EMA_WARMUP, sep=EMA_SEP, hor=EMA_HOR):
    """Su barre di un TF. Ritorna distanza (in ATR) dalla EMA, tempo sopra, durata delle serie,
    frequenza di tocco, e l'esito di 'tocco da lontano' (rimbalzo/rottura/ambiguo) con la regola
    descritta nel piano. NON e' il marcatore di edge ema200_rimbalzo.py."""
    N = len(c)
    if N < warm + hor + 10:
        return dict(n=0)
    E = ema(c, n)
    A = atr_sma(o, h, l, c, ATR_N)
    idx = np.arange(warm, N - hor - 1)
    ok = np.isfinite(A[idx]) & (A[idx] > 0)
    idx = idx[ok]
    dist = (c[idx] - E[idx]) / A[idx]
    sopra = c[warm:] > E[warm:]
    # serie consecutive sullo stesso lato
    ch = np.flatnonzero(np.diff(sopra.astype(np.int8)) != 0)
    lens = np.diff(np.r_[-1, ch, len(sopra) - 1])
    toc = (l[idx] <= E[idx]) & (E[idx] <= h[idx])
    cross = np.count_nonzero(np.diff(sopra.astype(np.int8)) != 0)
    d = dict(n=len(idx), sopra_pct=float(100.0 * sopra.mean()), serie_med=float(np.median(lens)), serie_media=float(lens.mean()),
             dist_abs_p50=float(np.percentile(np.abs(dist), 50)), dist_abs_p75=float(np.percentile(np.abs(dist), 75)),
             dist_abs_p90=float(np.percentile(np.abs(dist), 90)), dist_abs_p95=float(np.percentile(np.abs(dist), 95)),
             entro_1atr_pct=float(100.0 * np.mean(np.abs(dist) <= 1.0)),
             tocchi_per_100=float(100.0 * toc.mean()), incroci_per_100=float(100.0 * cross / len(sopra)))
    # tocco da lontano: l'EMA viene toccata (low<=E<=high) mentre le `sep` barre precedenti stanno
    # tutte dallo stesso lato e almeno una a >= 1 ATR di distanza (stessa idea di ema200_rimbalzo.py).
    side = np.sign(c - E)
    B = P = AMB = 0
    j = warm + sep
    while j < N - hor - 1:
        if not (np.isfinite(A[j]) and A[j] > 0 and l[j] <= E[j] <= h[j]):
            j += 1
            continue
        lato = side[j - sep:j]
        if not (np.all(lato == lato[0]) and lato[0] != 0):
            j += 1
            continue
        s_ = lato[0]
        da = np.abs(c[j - sep:j] - E[j - sep:j]) / np.where(A[j - sep:j] > 0, A[j - sep:j], np.nan)
        if not (np.nanmax(da) >= 1.0):
            j += 1
            continue
        a_ = A[j]
        esito = 0
        for q in range(j + 1, j + hor + 1):
            away = s_ * ((h[q] if s_ > 0 else l[q]) - E[q]) / a_      # lontano dalla linea sul lato di origine
            beyond = -s_ * (c[q] - E[q]) / a_                         # chiusura OLTRE la linea
            if away >= 1.0 and not (beyond >= 0.5):
                esito = 1; break
            if beyond >= 0.5:
                esito = 2; break
        if esito == 1:
            B += 1
        elif esito == 2:
            P += 1
        else:
            AMB += 1
        j += hor            # un evento per volta: niente sovrapposizioni
    d.update(B=B, P=P, AMB=AMB, n_eventi=B + P + AMB, rimbalzo_quota=(B / (B + P) if (B + P) else float("nan")))
    return d


# ---------------------------------------------------------------------
# 10. IL NULLO: RANDOM WALK PASSATO DALLA STESSA PROCEDURA
# ---------------------------------------------------------------------
def rw_barre(nbarre, sub=60, seme=SEME, vol=1.0):
    """barre OHLC di un random walk gaussiano a passi fini (sub passi per barra)."""
    rng = np.random.default_rng(seme)
    inc = rng.standard_normal((nbarre, sub)) * (vol / math.sqrt(sub))
    path = np.cumsum(inc, axis=1)
    base = np.concatenate([[0.0], path[:-1, -1]]).cumsum() if False else None
    last = np.cumsum(path[:, -1])
    start = np.concatenate([[0.0], last[:-1]])
    full = path + start[:, None] + 1000.0
    o = start + 1000.0
    c = full[:, -1]
    h = np.maximum(full.max(axis=1), o)
    l = np.minimum(full.min(axis=1), o)
    return o, h, l, c


_RIF_CACHE = {}


def riferimento_rw():
    """Tabella di riferimento (ritracciamento, ER, EMA) di un RW passato dalle STESSE funzioni.
    Seme fisso: stesso numero ad ogni lancio. 40.000 barre."""
    if "rw" in _RIF_CACHE:
        return _RIF_CACHE["rw"]
    o, h, l, c = rw_barre(40000)
    a = atr_sma(o, h, l, c, ATR_N)
    ritr = ritracciamenti(h, l, a)
    er = {nome: float(np.nanmedian(efficiency_ratio(c, n))) for nome, n in ER_N.items()}
    em = comportamento_ema(o, h, l, c)
    _RIF_CACHE["rw"] = dict(ritr=ritr, er=er, ema=em)
    return _RIF_CACHE["rw"]


# ---------------------------------------------------------------------
# 11. SPREAD E COSTO (frontiera 40 x spread)
# ---------------------------------------------------------------------
def leggi_spread(path):
    """SPREAD_VIVO_*_orario.csv -> {simbolo: [(ora_server, mediana_unita, p95_unita, campioni, giornate)]}."""
    out = {}
    with open(path, newline="") as f:
        for r in csv.DictReader(f):
            try:
                out.setdefault(r["simbolo"], []).append((int(r["ora_server"]), float(r["mediana_unita"]), float(r["p95_unita"]),
                                                         int(r["campioni"]), int(r["giornate"])))
            except Exception:
                continue
    return out


def misure_costo(s, atrtf, spread_righe):
    if not spread_righe:
        return None
    med = float(np.median([x[1] for x in spread_righe]))
    p95 = float(np.median([x[2] for x in spread_righe]))
    rows = []
    for nome, tfm in TFS + (("D1", 1440),):
        if nome == "D1":
            a = float("nan")
        else:
            a = atrtf[nome]["atr_ult252"]
        rows.append(dict(tf=nome, atr=a, atr_su_spread=(a / med if med > 0 else float("nan")),
                         atr_su_spread_p95=(a / p95 if p95 > 0 else float("nan")),
                         stop_min_atr=(STOP_X_SPREAD * med / a if a > 0 else float("nan")),
                         fuori_costo=bool(a > 0 and a < STOP_X_SPREAD * med)))
    return dict(med=med, p95=p95, righe=rows, orario=sorted(spread_righe))


# ---------------------------------------------------------------------
# 12. CORRELAZIONI E CLUSTER
# ---------------------------------------------------------------------
def rendimenti_giornalieri(s):
    d1 = s["d1"]
    p = d1["pieno"]
    g = d1["giorno"][p]
    c = d1["c"][p]
    return g[1:], np.diff(np.log(c))


def rendimenti_orari(s):
    b = s["barre"]["H1"]
    # chiave oraria UTC della barra (la barra H1 server coincide con l'ora UTC: offset di 1 ora intero)
    k = b["tu"] // 60
    c = b["c"]
    ok = (k[1:] - k[:-1]) == 1
    return k[1:][ok], np.log(c[1:][ok] / c[:-1][ok])


def corr_su(coppia_a, coppia_b, minimo):
    ka, ra = coppia_a
    kb, rb = coppia_b
    comuni, ia, ib = np.intersect1d(ka, kb, return_indices=True)
    if len(comuni) < minimo:
        return float("nan"), len(comuni)
    x, y = ra[ia], rb[ib]
    if x.std() == 0 or y.std() == 0:
        return float("nan"), len(comuni)
    return float(np.corrcoef(x, y)[0, 1]), len(comuni)


def matrici_correlazione(serie, finestra=None):
    nomi = [x["simbolo"] for x in serie]
    G = [rendimenti_giornalieri(x) for x in serie]
    Hh = [rendimenti_orari(x) for x in serie]
    if finestra:
        G = [(k[(k >= finestra[0]) & (k <= finestra[1])], r[(k >= finestra[0]) & (k <= finestra[1])]) for k, r in G]
        lo, hi = finestra[0] * 24, finestra[1] * 24 + 23
        Hh = [(k[(k >= lo) & (k <= hi)], r[(k >= lo) & (k <= hi)]) for k, r in Hh]
    nn = len(serie)
    Rg = np.full((nn, nn), np.nan); Ng = np.zeros((nn, nn), int)
    Rh = np.full((nn, nn), np.nan); Nh = np.zeros((nn, nn), int)
    for i in range(nn):
        for j in range(nn):
            if i == j:
                Rg[i, j] = Rh[i, j] = 1.0
                Ng[i, j], Nh[i, j] = len(G[i][0]), len(Hh[i][0])
                continue
            Rg[i, j], Ng[i, j] = corr_su(G[i], G[j], 60)
            Rh[i, j], Nh[i, j] = corr_su(Hh[i], Hh[j], 500)
    return nomi, Rg, Ng, Rh, Nh


def cluster_media(nomi, R, soglia):
    """Cluster per COLLEGAMENTO MEDIO sulla correlazione assoluta: si fondono i due gruppi con la correlazione
    media piu' alta finche' resta >= soglia. (Il collegamento singolo, a catena, fondeva tutto in un blocco
    solo: A-B 0,9 e B-C 0,55 mettevano insieme A e C anche con A-C 0,1.) NaN conta come 0."""
    n = len(nomi)
    M = np.abs(np.nan_to_num(np.asarray(R, dtype=float), nan=0.0))
    gruppi = [[i] for i in range(n)]
    while len(gruppi) > 1:
        best, bi, bj = -1.0, -1, -1
        for i in range(len(gruppi)):
            for j in range(i + 1, len(gruppi)):
                v = float(np.mean([M[a, b] for a in gruppi[i] for b in gruppi[j]]))
                if v > best:
                    best, bi, bj = v, i, j
        if best < soglia:
            break
        gruppi[bi] = gruppi[bi] + gruppi[bj]
        del gruppi[bj]
    return sorted([sorted(nomi[i] for i in g) for g in gruppi], key=lambda g: (-len(g), g[0]))


CLUSTER_NOMINALI = {
    # da report/CLUSTER_PROPOSTA.md (proposta del 07/09, NON firmata): qui serve solo a ETICHETTARE
    "USD": ("EURUSD", "GBPUSD", "USDJPY", "USDCHF", "USDCAD", "NZDUSD", "AUDUSD"),
    "EUR": ("EURUSD", "EURJPY", "EURGBP", "EURNZD"),
    "GBP": ("GBPUSD", "GBPJPY", "EURGBP", "GBPAUD", "GBPCAD", "GBPNZD"),
    "JPY": ("USDJPY", "EURJPY", "GBPJPY", "AUDJPY", "CHFJPY", "NZDJPY", "CADJPY"),
    "AUD": ("AUDUSD", "AUDJPY", "AUDCAD", "AUDNZD", "GBPAUD"),
    "METALLI": ("XAUUSD", "XAGUSD"),
    "AZ_US": ("U30USD", "SPXUSD", "NASUSD"),
    "AZ_EU": ("D30EUR",),
    "AZ_APAC": ("225JPY", "200AUD"),
}


def cluster_di(sim):
    return [k for k, v in CLUSTER_NOMINALI.items() if sim in v]


# ---------------------------------------------------------------------
# 13. LA SCHEDA
# ---------------------------------------------------------------------
def f(x, nd=2):
    if x is None:
        return "n.d."
    try:
        if not np.isfinite(x):
            return "n.d."
    except TypeError:
        return str(x)
    return ("%." + str(nd) + "f") % x


def scheda(s, M, A, S, O, G, R, E, EMA, costo, rw, finestra_nota, ranking_riga):
    q = s["q"]
    u = s["unita"]
    un = "pip" if u < 1 else "punti"
    L = []
    w = L.append
    w("# SCHEDA SIMBOLO -- %s (%s)" % (s["simbolo"], s["feed"]))
    w("")
    w("Generata da `backtest_pipeline/scheda_simbolo.py` (%s). **DESCRITTIVA: non e' un test di edge, non e' un backtest.**" % VERSIONE)
    w("Unita': **%s** = %s di prezzo. Giorno: **%s**; orologio server: **%s**; fuso del file: **%s**." % (
        un, f(u, 4), "giorno server BCM (mezzanotte server)" if s["modo_giorno"] == "utc1" else "giorno che chiude alle 17:00 New York",
        "UTC+1 fisso" if s["orologio"] == "utc1" else "vecchio (UTC+0 inverno / +1 estate)", s["fuso"]))
    w("")
    w("## 0. Chi sono i dati (i cancelli prima dei numeri)")
    w("")
    w("| voce | valore |")
    w("|---|---|")
    w("| barre M1 | **%s** da %s a %s (UTC) |" % (format(q["n_m1"], ","), q["da"], q["a"]))
    w("| file / righe / scartate (parse, OHLC, doppi, fuori ordine) | %d / %s / %d, %d, %d, %d |" % (
        q["file"], format(q["righe"], ","), q["scartate_parse"], q["scartate_ohlc"], q["doppi"], q["fuori_ordine"]))
    if q["scartate_cambio_orologio"]:
        w("| righe scartate nella finestra dubbia del cambio d'orologio BCM (26/12/2024 - 02/02/2025) | %d |" % q["scartate_cambio_orologio"])
    w("| giorni / giorni pieni (>= %d%% della mediana di M1) | %d / %d (mediana %d M1 al giorno) |" % (
        int(FRAZ_GIORNO_PIENO * 100), q["giorni"], q["giorni_pieni"], q["m1_per_giorno_mediana"]))
    w("| buchi interni 2-59 min | %d eventi, %d minuti mancanti |" % (q["buchi_interni_1_59min"], q["minuti_mancanti_interni"]))
    w("| M1 mediane per giorno, per anno (copertura: un anno molto sotto gli altri ha buchi, e l'ATR di quell'anno e' leggermente per difetto) | %s |" % " ; ".join("%d: %d" % (y, v) for y, v in q["m1_giorno_per_anno"].items()))
    w("| barre a range zero | %s%% |" % f(q["barre_range_zero_pct"], 2))
    w("| prezzo min / max | %s / %s |" % (f(q["prezzo_min"], 4), f(q["prezzo_max"], 4)))
    w("| picco di volatilita' del minuto (UTC): inverno gen-feb / estate giu-ago | %s / %s ; differenza %s min (attesa: 60 +/- 5 per un evento USA/Europa, 0 +/- 5 per un evento di Tokyo; la tolleranza di 5 minuti serve a non confondere un picco largo con un errore, il controllo cerca errori di ORE) ; ancora assoluta d'inverno: %s ; giorni inverno/estate %d/%d, nettezza del picco %.1f/%.1f volte la mediana -> **%s** |" % (
        hhmm(q["picco_inverno_utc"]), hhmm(q["picco_estate_utc"]),
        (str(q["picco_inverno_utc"] - q["picco_estate_utc"]) if q["picco_inverno_utc"] is not None and q["picco_estate_utc"] is not None else "n.d."),
        q["ancora_inverno"] or "NESSUNA", q["giorni_inverno"], q["giorni_estate"], q["decisivita_inverno"], q["decisivita_estate"], q["orologio_verdetto"]))
    w("")
    w("_Cosa dice_: se il picco non cade su un'ancora nota (apertura cash, dati USA 8:30 ET) il fuso dichiarato e' sbagliato e **tutte** le etichette orarie sotto sono sbagliate. _Decisione informata_: fidarsi o no delle sezioni 3-4. Limite del controllo: non separa 13:30 da 14:30 UTC (dati USA 8:30 contro apertura cash 9:30), quindi un errore di esattamente un'ora fra questi due non si vede.")
    if finestra_nota:
        w("")
        w("> %s" % finestra_nota)
    # --- 1 ADR
    w("")
    w("## 1. Range medio giornaliero (ADR)")
    w("")
    a = M["adr_pt"]; ap = M["adr_pct"]
    w("Formula: `range = H - L` del giorno (giorni pieni), in %s; in %% del prezzo = `100 x (H-L) / open del giorno`." % un)
    w("")
    w("| | mediana | media | p10 | p25 | p75 | p90 | p95 |")
    w("|---|---:|---:|---:|---:|---:|---:|---:|")
    w("| ADR (%s) | **%s** | %s | %s | %s | %s | %s | %s |" % (un, f(a["p50"]), f(a["media"]), f(a["p10"]), f(a["p25"]), f(a["p75"]), f(a["p90"]), f(a["p95"])))
    w("| ADR (%% prezzo) | **%s** | %s | %s | %s | %s | %s | %s |" % (f(ap["p50"], 3), f(ap["media"], 3), f(ap["p10"], 3), f(ap["p25"], 3), f(ap["p75"], 3), f(ap["p90"], 3), f(ap["p95"], 3)))
    w("")
    w("n = %d giorni pieni. Ultimi ~252 giorni pieni: ADR mediano %s %s (%s%%). Volatilita' realizzata annua (close-close D1): %s%%." % (
        a["n"], f(M["adr_pt_med_ult252"]), un, f(M["adr_pct_med_ult252"], 3), f(M["rv_ann_pct"], 1)))
    w("Giorni con range > 1,5 x mediana: %s%% ; > 2 x mediana: %s%% ; < 0,5 x mediana: %s%%." % (
        f(100 * M["frac_giorni_gt_1_5_mediana"], 1), f(100 * M["frac_giorni_gt_2_mediana"], 1), f(100 * M["frac_giorni_lt_0_5_mediana"], 1)))
    w("")
    w("**Per anno** (mediana del range, giorni pieni)")
    w("")
    w("| anno | n | ADR mediano (%s) | ADR medio (%s) | ADR mediano (%%) |" % (un, un))
    w("|---:|---:|---:|---:|---:|")
    for r in M["per_anno"]:
        w("| %d | %d | %s | %s | %s |" % (r["anno"], r["n"], f(r["adr_pt_med"]), f(r["adr_pt_media"]), f(r["adr_pct_med"], 3)))
    w("")
    w("_Cosa dice_: quanta strada fa il prezzo in un giorno tipico e quanto e' coda grassa (media >> mediana = giornate esplosive). _Decisione informata_: lo stop in ATR/ADR, un TP che stia dentro il giorno (un TP a 1,5 x ADR mediano si raggiunge in una minoranza dei giorni), e la lettura di una giornata anomala. Il confronto fra anni dice se il numero e' di un regime.")
    # --- 2 ATR per TF
    w("")
    w("## 2. ATR per timeframe")
    w("")
    w("Formula: `ATR(14)` = media SEMPLICE del true range su 14 barre (come `iATR` di MT5, non Wilder); barre costruite sull'orologio server, mai a cavallo di due giorni. Valori in %s." % un)
    w("")
    w("| TF | barre | ATR mediano | ATR medio | ATR % prezzo (mediana) | ATR ultimi 252 gg |")
    w("|---|---:|---:|---:|---:|---:|")
    for nome, _ in TFS:
        x = A[nome]
        w("| %s | %s | **%s** | %s | %s | %s |" % (nome, format(x["n_barre"], ","), f(x["atr_med"]), f(x["atr_media"]), f(x["atr_pct_med"], 4), f(x["atr_ult252"])))
    w("| D1 | %d | **%s** | %s | %s | %s |" % (M["atr_d1_pt"]["n"], f(M["atr_d1_pt"]["p50"]), f(M["atr_d1_pt"]["media"]), f(M["atr_d1_pct"]["p50"], 4), "-"))
    w("")
    w("Rapporti: ATR(H1)/ATR(M15) = %s (radice di T atteso 2,00 se i rendimenti fossero indipendenti) ; ATR(H4)/ATR(H1) = %s (atteso 2,00) ; ADR mediano / ATR(H1) = %s." % (
        f(A["rapporto_H1_M15"]), f(A["rapporto_H4_H1"]), f(A["adr_su_atr_h1"], 1)))
    w("")
    w("_Cosa dice_: la scala di ogni TF e quanto il simbolo si scosta dalla legge radice-di-T (sopra 2 = tendenza che si accumula, sotto 2 = rumore che si compensa). _Decisione informata_: lo stop in ATR su quel TF, il TF minimo che passa la frontiera del costo (sezione 9).")
    # --- 3 sessioni
    w("")
    w("## 3. Range per sessione (orari reali di borsa, convertiti in ora server UTC+1 fisso)")
    w("")
    w("| sessione | giorni | range mediano | medio | p90 | mediana % prezzo | quota dell'ADR mediano | finestra in ora server inverno | estate |")
    w("|---|---:|---:|---:|---:|---:|---:|---|---|")
    for x in S:
        def hs(m):
            m = (m + 60) % 1440
            return "%02d:%02d" % (m // 60, m % 60)
        qd = 100.0 * x["med"] / M["adr_pt"]["p50"] if M["adr_pt"]["p50"] > 0 else float("nan")
        if x["n"] < 30:
            w("| %s | %d | n.d. (campione < 30 giorni: il feed non copre questa finestra) | | | | | %s-%s | %s-%s |" % (x["nome"], x["n"], hs(x["ini_inv"]), hs(x["fin_inv"]), hs(x["ini_est"]), hs(x["fin_est"])))
            continue
        w("| %s | %d | **%s** | %s | %s | %s | %s%% | %s-%s | %s-%s |" % (x["nome"], x["n"], f(x["med"]), f(x["media"]), f(x["p90"]), f(x["med_pct"], 3), f(qd, 0),
                                                                       hs(x["ini_inv"]), hs(x["fin_inv"]), hs(x["ini_est"]), hs(x["fin_est"])))
    w("")
    w("Le sessioni si SOVRAPPONGONO (Londra/NY 15:30-17:30 server d'inverno) e non sommano al 100%: sono finestre indipendenti, ognuna con la sua ora legale (Tokyo non ce l'ha). Un simbolo che non scambia in una finestra mostra pochi giorni validi (>= 50% dei minuti presenti).")
    w("")
    w("_Cosa dice_: in quale sessione il simbolo fa il suo movimento. _Decisione informata_: la fascia oraria di un EA (e quanto spazio ha il TP dentro quella fascia).")
    # --- 4 ore
    w("")
    w("## 4. Range per ora server e per giorno della settimana")
    w("")
    w("Range = H-L dentro l'ora server (UTC+1 fisso), solo giorni feriali con >= 30 M1 nell'ora. Inverno = dic-feb, estate = giu-ago: gli eventi a ora fissa USA/Europa si spostano di 1 ora fra le due colonne.")
    w("")
    w("| ora server | n | mediana | inverno | estate | quota % del totale |")
    w("|---:|---:|---:|---:|---:|---:|")
    for x in O:
        if x["n"] < 5:
            continue
        w("| %02d | %d | %s | %s | %s | %s |" % (x["ora"], x["n"], f(x["med"]), f(x["inv"]), f(x["est"]), f(x["quota_pct"], 1)))
    w("")
    w("| giorno | n | range mediano | range medio | indice (media / media dei 5 giorni) |")
    w("|---|---:|---:|---:|---:|")
    nomi_g = ("lun", "mar", "mer", "gio", "ven")
    for x in M["per_wd"]:
        w("| %s | %d | %s | %s | %s |" % (nomi_g[x["wd"]], x["n"], f(x["med"]), f(x["media"]), f(x["indice"], 2)))
    w("")
    w("Domenica sera e sabato sono attribuiti al lunedi'.")
    w("_Cosa dice_: dove sta il movimento nella giornata e nella settimana. _Decisione informata_: la finestra oraria, i giorni da escludere/pesare, dove NON mettere un ordine.")
    # --- 5 gap
    w("")
    w("## 5. Gap di apertura")
    w("")
    w("Gap = primo open dopo un buco di quotazioni >= %d minuti meno l'ultima chiusura. 'pausa' = buco < 36 ore (la notte/la pausa giornaliera), 'weekend' = buco >= 36 ore. Riempito = nel segmento che segue il buco il prezzo torna alla chiusura precedente." % SOGLIA_BUCO_NOTTE)
    w("")
    if not G:
        w("Nessun buco >= 60 minuti nei dati: gap non misurabile.")
    else:
        w("| classe | n | buco mediano (ore) | gap assoluto mediano (%s) | p95 (%s) | mediano in ATR D1 | p95 in ATR D1 | %% con gap > 0,25 ATR D1 | %% gap su | %% riempito | %% riempito se > 0,25 ATR |" % (un, un))
        w("|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|")
        for nome in ("pausa", "weekend"):
            x = G.get(nome)
            if not x or x["n"] < 3:
                w("| %s | %d | n.d. | | | | | | | | |" % (nome, x["n"] if x else 0))
                continue
            w("| %s | %d | %s | %s | %s | %s | %s | %s%% | %s%% | %s%% | %s |" % (
                nome, x["n"], f(x["buco_med_ore"], 1), f(x["med_pt"]), f(x["p95_pt"]), f(x["med_atr"], 3), f(x["p95_atr"], 2),
                f(100 * x["frac_gt_025atr"], 1), f(x["su_pct"], 0), f(x["riempito_pct"], 0), f(x["riempito_gt025_pct"], 0) + ("%" if np.isfinite(x["riempito_gt025_pct"]) else "")))
    w("")
    w("_Cosa dice_: quanto salta il prezzo fra una sessione e l'altra e se il salto si ritira. _Decisione informata_: gap-fade o gap-continuation (le sedie GapFill/GapContinuation), il rischio di stop saltato nel weekend, la distanza minima dello stop dall'overnight.")
    # --- 6 ritracciamento
    w("")
    w("## 6. Ritracciamento dopo un impulso (zigzag a soglia ATR, TF %s)" % s.get("tf_ritr", "H1"))
    w("")
    w("Procedura: pivot di uno zigzag che inverte quando il prezzo si muove di **%s ATR(14) %s** contro l'ultimo estremo (una barra che fa un nuovo estremo non conferma anche l'inversione). **Impulso k** = gamba tra due pivot lunga >= k ATR al suo termine. **Ritracciamento** = la gamba successiva / l'impulso (il massimo ritracciamento prima che il movimento riprenda per %s ATR). Tocco di un livello = frazione di impulsi con ritracciamento >= livello. Un livello <= %s/k e' troncato per costruzione (la gamba successiva non puo' essere piu' corta della soglia di inversione): mostrato 'n.d.'." % (f(RHO, 1), s.get("tf_ritr", "H1"), f(RHO, 1), f(RHO, 1)))
    w("")
    w("Misura DESCRITTIVA, i pivot si conoscono in ritardo: **non e' un segnale**. Accanto, il RANDOM WALK passato dalla stessa procedura (seme fisso, 40.000 barre): se il simbolo ritraccia come il RW, quel numero non e' una proprieta' del simbolo.")
    w("")
    hd = "| k (ATR) | impulsi (su/giu) | ritr. medio | mediana | p25-p75 | " + " | ".join("tocco %s%%" % f(100 * lv, 1) for lv in LIVELLI_FIBO) + " | inversione (>=100%) | tempo mediano (barre) |"
    w(hd)
    w("|---|---:|---:|---:|---:|" + "---:|" * len(LIVELLI_FIBO) + "---:|---:|")
    for k in KS:
        x = R.get(k, {"n": 0})
        if x["n"] == 0:
            w("| %s | 0 |" % f(k, 0))
            continue
        tc = " | ".join((f(100 * x["tocco"][lv], 0) if x["tocco"][lv] is not None else "n.d.") for lv in LIVELLI_FIBO)
        w("| %s | %d (%d/%d) | **%s** | %s | %s-%s | %s | %s%% | %s |" % (f(k, 0), x["n"], x["su_n"], x["giu_n"], f(x["media"], 3), f(x["mediana"], 3),
                                                                           f(x["p25"], 2), f(x["p75"], 2), tc, f(100 * x["inversione"], 0), f(x["tempo_med"], 1)))
    w("")
    w("RW di riferimento:")
    w("")
    w(hd)
    w("|---|---:|---:|---:|---:|" + "---:|" * len(LIVELLI_FIBO) + "---:|---:|")
    for k in KS:
        x = rw["ritr"].get(k, {"n": 0})
        if x["n"] == 0:
            continue
        tc = " | ".join((f(100 * x["tocco"][lv], 0) if x["tocco"][lv] is not None else "n.d.") for lv in LIVELLI_FIBO)
        w("| %s | %d | %s | %s | %s-%s | %s | %s%% | %s |" % (f(k, 0), x["n"], f(x["media"], 3), f(x["mediana"], 3), f(x["p25"], 2), f(x["p75"], 2), tc, f(100 * x["inversione"], 0), f(x["tempo_med"], 1)))
    w("")
    w("_Cosa dice_: quanto, tipicamente, un movimento forte viene riassorbito prima di riprendere, e dopo quanto tempo. _Decisione informata_: dove piazzare un ingresso su ritracciamento (limit al 38,2/50/61,8), quanto aspettare, e se lo stop deve stare oltre il 78,6%.")
    # --- 7 ER
    w("")
    w("## 7. Trend o laterale (Efficiency Ratio)")
    w("")
    w("`ER(N) = |close_t - close_(t-N)| / somma |variazioni| nelle N barre`: 1 = linea retta, 0 = andata e ritorno. Trend = ER >= %s, laterale = ER <= %s (soglie MIE, dichiarate prima dei numeri). Riferimento random walk: ER ~ 1/radice(N)." % (f(ER_TREND, 2), f(ER_LATERALE, 2)))
    w("")
    w("| serie | N | n finestre | ER mediano | ER medio | % trend | % laterale | rif. RW 1/radice(N) | RW simulato (mediano) |")
    w("|---|---:|---:|---:|---:|---:|---:|---:|---:|")
    for nome in ("H1", "H4", "D1"):
        x = E.get(nome, {"n": 0})
        if x["n"] == 0:
            continue
        w("| %s | %d | %s | **%s** | %s | %s%% | %s%% | %s | %s |" % (nome, x["N"], format(x["n"], ","), f(x["med"], 3), f(x["media"], 3), f(100 * x["trend"], 0), f(100 * x["laterale"], 0), f(x["rif_rw"], 3), f(rw["er"][nome], 3)))
    w("")
    w("_Cosa dice_: se il simbolo e' piu' direzionale (ER sopra il RW) o piu' di ritorno alla media (sotto). _Decisione informata_: motore a trend (sopra il RW) o a ritorno (sotto) su quel TF; quanto filtro-trend serve.")
    # --- 8 EMA200
    w("")
    w("## 8. Comportamento alla EMA200 (DESCRITTIVO)")
    w("")
    w("**Non e' un test di edge** (regola di casa): conta quanto il prezzo sta vicino/lontano dalla linea e cosa fa dopo un tocco da lontano. Il test vero, col nullo a blocchi, e' `ema200_rimbalzo.py`/`ema200_d1_su_m5.py`. Tocco da lontano = low<=EMA<=high con le %d barre precedenti tutte dallo stesso lato e almeno una a >= 1 ATR; esito entro %d barre: **rimbalzo** = ritorna a >= 1 ATR dal lato di origine senza chiudere a >= 0,5 ATR oltre la linea; **rottura** = chiude a >= 0,5 ATR oltre; il resto ambiguo. Un evento ogni %d barre." % (EMA_SEP, EMA_HOR, EMA_HOR))
    w("")
    w("| TF | barre | % sopra la EMA | serie sullo stesso lato (mediana, barre) | distanza assoluta mediana (ATR) | p90 | entro 1 ATR | tocchi per 100 barre | incroci per 100 barre | eventi (B/P/amb) | rimbalzo B/(B+P) |")
    w("|---|---:|---:|---:|---:|---:|---:|---:|---:|---|---:|")
    for nome in ("H1", "H4", "D1"):
        x = EMA.get(nome, {"n": 0})
        if x["n"] == 0:
            w("| %s | campione troppo corto | | | | | | | | | |" % nome)
            continue
        w("| %s | %s | %s%% | %s | %s | %s | %s%% | %s | %s | %d (%d/%d/%d) | **%s** |" % (
            nome, format(x["n"], ","), f(x["sopra_pct"], 1), f(x["serie_med"], 0), f(x["dist_abs_p50"], 2), f(x["dist_abs_p90"], 2), f(x["entro_1atr_pct"], 0),
            f(x["tocchi_per_100"], 1), f(x["incroci_per_100"], 1), x["n_eventi"], x["B"], x["P"], x["AMB"], f(x["rimbalzo_quota"], 2)))
    rwe = rw["ema"]
    if rwe.get("n", 0):
        w("| RW (H1-like) | %s | %s%% | %s | %s | %s | %s%% | %s | %s | %d (%d/%d/%d) | %s |" % (
            format(rwe["n"], ","), f(rwe["sopra_pct"], 1), f(rwe["serie_med"], 0), f(rwe["dist_abs_p50"], 2), f(rwe["dist_abs_p90"], 2), f(rwe["entro_1atr_pct"], 0),
            f(rwe["tocchi_per_100"], 1), f(rwe["incroci_per_100"], 1), rwe["n_eventi"], rwe["B"], rwe["P"], rwe["AMB"], f(rwe["rimbalzo_quota"], 2)))
    w("")
    w("_Cosa dice_: quanto 'tiene' la EMA200 come linea e quanto il simbolo ci vive attorno. _Decisione informata_: la distanza-soglia in ATR per gli ingressi sulla EMA (cella O1/O2 del dashboard), se ha senso un limit alla linea. NON dice che rimbalzare sia profittevole.")
    # --- 9 costo
    w("")
    w("## 9. Spread medio per ora e costo in ATR (frontiera 40 x spread)")
    w("")
    if not costo:
        w("[NON MISURATO] per questa serie: serve un file di spread (`--spread`, formato SPREAD_VIVO orario) con lo stesso simbolo. Lo spread storico del feed esterno non e' lo spread BCM.")
    else:
        w("Spread (unita' %s): mediana sulle 24 ore **%s**, p95 mediano %s (fonte: file di spread passato a `--spread`, orario). ATR = **ultimi 252 giorni** dei dati (non l'intera storia: lo spread e' di oggi). Frontiera: uno stop di 1 ATR deve valere >= %d x spread." % (un, f(costo["med"], 3), f(costo["p95"], 3), STOP_X_SPREAD))
        w("")
        w("| TF | ATR (ult. 252 gg) | ATR / spread | ATR / spread p95 | stop minimo in ATR per 40 x spread | esito |")
        w("|---|---:|---:|---:|---:|---|")
        for x in costo["righe"]:
            if x["tf"] == "D1":
                continue
            w("| %s | %s | **%s** | %s | %s | %s |" % (x["tf"], f(x["atr"], 3), f(x["atr_su_spread"], 1), f(x["atr_su_spread_p95"], 1), f(x["stop_min_atr"], 2),
                                                       "FUORI COSTO (1 ATR < 40 x spread: ATR/spread = %s)" % f(x["atr_su_spread"], 1) if x["fuori_costo"] else "dentro"))
        w("")
        w("Spread per ora server (mediana, p95, giornate):")
        w("")
        w("| ora | " + " | ".join("%02d" % r[0] for r in costo["orario"]) + " |")
        w("|---|" + "---:|" * len(costo["orario"]))
        w("| mediana | " + " | ".join(f(r[1], 2) for r in costo["orario"]) + " |")
        w("| p95 | " + " | ".join(f(r[2], 2) for r in costo["orario"]) + " |")
        w("")
        w("_Cosa dice_: il pedaggio e la fascia in cui costa di piu'. _Decisione informata_: il TF minimo schierabile, e le ore da evitare per ordini a mercato.")
    # --- 10 ranking
    w("")
    w("## 10. Dove sta nel ranking (stessa finestra per tutti)")
    w("")
    if ranking_riga:
        w(ranking_riga)
    else:
        w("[NON MISURATO] ranking solo con due o piu' simboli nella stessa corsa.")
    w("")
    w("---")
    w("_Riproducibile_: stessa serie di M1 + stesso `%s` -> stessi numeri (nessun elemento casuale tranne il RW di riferimento, a seme fisso %d)._" % (VERSIONE, SEME))
    return "\n".join(L) + "\n"


# ---------------------------------------------------------------------
# 14. ORCHESTRAZIONE
# ---------------------------------------------------------------------
def analizza(s, modo_giorno="utc1", spread=None, tf_ritr="H1"):
    costruisci(s, modo_giorno)
    s["q"] = qualita(s)
    M = misure_giornaliere(s)
    A = misure_atr_tf(s, M)
    S = misure_sessioni(s)
    O = misure_ore(s)
    G = misure_gap(s, M)
    b = s["barre"][tf_ritr]
    R = ritracciamenti(b["h"], b["l"], A[tf_ritr]["serie"])
    s["tf_ritr"] = tf_ritr
    E = misure_er(s)
    EMA = {}
    for nome in ("H1", "H4"):
        bb = s["barre"][nome]
        EMA[nome] = comportamento_ema(bb["o"], bb["h"], bb["l"], bb["c"])
    d1 = s["d1"]
    pi = d1["pieno"]
    EMA["D1"] = comportamento_ema(d1["o"][pi], d1["h"][pi], d1["l"][pi], d1["c"][pi])
    costo = misure_costo(s, A, (spread or {}).get(s["simbolo"]))
    return dict(M=M, A=A, S=S, O=O, G=G, R=R, E=E, EMA=EMA, costo=costo)


def riga_ranking(serie, ris, finestra):
    """ranking sulla finestra comune: ADR % mediano. finestra = (g0,g1) o None."""
    righe = []
    for s in serie:
        d1 = s["d1"]; M = ris[s["simbolo"] + "|" + s["feed"]]["M"]
        p = d1["pieno"]
        if finestra:
            p = p & (d1["giorno"] >= finestra[0]) & (d1["giorno"] <= finestra[1])
        rng = d1["h"] - d1["l"]
        rp = 100.0 * rng / d1["o"]
        u = s["unita"]
        pcl = d1["c"][p]
        cc = np.diff(np.log(pcl)) if p.sum() > 3 else np.array([])
        righe.append(dict(
            simbolo=s["simbolo"], feed=s["feed"], giorni_finestra=int(p.sum()),
            da=data_da_giorno(d1["giorno"][p][0]) if p.any() else "", a=data_da_giorno(d1["giorno"][p][-1]) if p.any() else "",
            adr_pt_med=float(np.median(rng[p]) / u) if p.any() else float("nan"),
            adr_pct_med=float(np.median(rp[p])) if p.any() else float("nan"),
            adr_pct_media=float(rp[p].mean()) if p.any() else float("nan"),
            rv_ann_pct=float(100.0 * cc.std(ddof=1) * math.sqrt(252.0)) if len(cc) > 2 else float("nan"),
            atr_h1_pct_serie_intera=float(ris[s["simbolo"] + "|" + s["feed"]]["A"]["H1"]["atr_pct_med"]),
            er_d1_20_serie_intera=float(ris[s["simbolo"] + "|" + s["feed"]]["E"].get("D1", {}).get("med", float("nan"))),
            adr_pct_med_serie_intera=float(M["adr_pct"]["p50"]), giorni_serie_intera=int(M["adr_pt"]["n"]), unita=u))
    for r in righe:
        r["finestra_comune"] = "SI" if finestra else "NO"
        r["rank_adr_pct"] = ""
        r["rank_rv"] = ""
    if finestra:
        order = sorted(range(len(righe)), key=lambda i: -righe[i]["adr_pct_med"] if np.isfinite(righe[i]["adr_pct_med"]) else 1e9)
        for r_, i in enumerate(order, 1):
            righe[i]["rank_adr_pct"] = r_
        order = sorted(range(len(righe)), key=lambda i: -righe[i]["rv_ann_pct"] if np.isfinite(righe[i]["rv_ann_pct"]) else 1e9)
        for r_, i in enumerate(order, 1):
            righe[i]["rank_rv"] = r_
    return righe


CAMPI_RANK = ["simbolo", "feed", "unita", "finestra_comune", "da", "a", "giorni_finestra", "adr_pt_med", "adr_pct_med", "adr_pct_media", "rv_ann_pct",
              "atr_h1_pct_serie_intera", "er_d1_20_serie_intera", "rank_adr_pct", "rank_rv", "adr_pct_med_serie_intera", "giorni_serie_intera"]


def scrivi_csv(path, campi, righe):
    with open(path, "w", newline="") as fh:
        w = csv.writer(fh)
        w.writerow(campi)
        for r in righe:
            w.writerow([("%.6g" % r[k] if isinstance(r[k], float) else r[k]) for k in campi])


def scrivi_matrice(path, nomi, R, N):
    with open(path, "w", newline="") as fh:
        w = csv.writer(fh)
        w.writerow([""] + nomi)
        for i, n in enumerate(nomi):
            w.writerow([n] + [("%.3f" % R[i, j] if np.isfinite(R[i, j]) else "") for j in range(len(nomi))])
        w.writerow([])
        w.writerow(["n_osservazioni"] + nomi)
        for i, n in enumerate(nomi):
            w.writerow([n] + [int(N[i, j]) for j in range(len(nomi))])


def finestra_comune(serie, esplicita=None):
    """finestra su cui si CONFRONTANO le serie: quella data con --finestra (AAAA-MM-GG:AAAA-MM-GG) oppure
    l'intersezione delle serie. Se l'intersezione e' vuota (o < 60 giorni) -> None: il ranking NON si fa."""
    if esplicita:
        a, b = esplicita.split(":")
        g = lambda x: int(giorni_da_civile(int(x[:4]), int(x[5:7]), int(x[8:10])))
        return (g(a), g(b))
    g0 = max(int(s["d1"]["giorno"][s["d1"]["pieno"]][0]) for s in serie)
    g1 = min(int(s["d1"]["giorno"][s["d1"]["pieno"]][-1]) for s in serie)
    return (g0, g1) if (g1 - g0) >= 60 else None


def esegui(specs, uscita, spread_path=None, modo_giorno="utc1", orologio="utc1", soglia_cluster=0.5, log_=log, finestra=None, tf_ritr="H1"):
    os.makedirs(uscita, exist_ok=True)
    spread = leggi_spread(spread_path) if spread_path else None
    serie = []
    for (sim, feed, fuso, perc, unita) in specs:
        log_("lettura %s (%s, fuso %s): %s" % (sim, feed, fuso, perc))
        s = carica_serie(sim, feed, fuso, perc, orologio=orologio, unita=unita)
        log_("   M1 %s, file %d" % (format(len(s["t"]), ","), s["info"]["file"]))
        serie.append(s)
    ris = {}
    rw = riferimento_rw()
    for s in serie:
        k = s["simbolo"] + "|" + s["feed"]
        log_("analisi %s" % k)
        ris[k] = analizza(s, modo_giorno, spread, tf_ritr)
    fin = finestra_comune(serie, finestra) if len(serie) >= 2 else None
    rank = riga_ranking(serie, ris, fin)
    scrivi_csv(os.path.join(uscita, "ranking_volatilita.csv"), CAMPI_RANK, rank)
    fin_nota = None
    if fin:
        fin_nota = "Ranking e correlazioni sulla finestra %s a tutte le serie della corsa: %s -> %s." % ("indicata" if finestra else "comune", data_da_giorno(fin[0]), data_da_giorno(fin[1]))
    elif len(serie) >= 2:
        fin_nota = "Le serie di questa corsa NON hanno una finestra comune di almeno 60 giorni: il ranking e' [NON CONFRONTABILE] e resta vuoto."
    for s in serie:
        k = s["simbolo"] + "|" + s["feed"]
        r = ris[k]
        mio = [x for x in rank if x["simbolo"] == s["simbolo"] and x["feed"] == s["feed"]][0]
        rr = None
        if len(serie) >= 2 and not fin:
            rr = "[NON CONFRONTABILE] nessuna finestra comune di almeno 60 giorni fra le serie di questa corsa: i numeri di ADR sono di periodi diversi e non si mettono in classifica."
        elif len(serie) >= 2:
            rr = "Su %d serie della corsa, finestra %s -> %s (%d giorni): **ADR %% mediano %s -> posto %d su %d** ; volatilita' realizzata annua %s%% -> posto %d su %d. Tabella: `ranking_volatilita.csv`." % (
                len(serie), mio["da"], mio["a"], mio["giorni_finestra"], f(mio["adr_pct_med"], 3), mio["rank_adr_pct"], len(serie),
                f(mio["rv_ann_pct"], 1), mio["rank_rv"], len(serie))
        md = scheda(s, r["M"], r["A"], r["S"], r["O"], r["G"], r["R"], r["E"], r["EMA"], r["costo"], rw, fin_nota, rr)
        nome = "SCHEDA_%s_%s.md" % (s["simbolo"], re.sub(r"[^A-Za-z0-9]+", "_", s["feed"]))
        with open(os.path.join(uscita, nome), "w") as fh:
            fh.write(md)
        log_("   scheda: %s" % nome)
    if len(serie) >= 2:
        nomi, Rg, Ng, Rh, Nh = matrici_correlazione(serie, fin)
        nomi_e = ["%s|%s" % (s["simbolo"], s["feed"]) for s in serie]
        scrivi_matrice(os.path.join(uscita, "correlazioni_giornaliere.csv"), nomi_e, Rg, Ng)
        scrivi_matrice(os.path.join(uscita, "correlazioni_orarie.csv"), nomi_e, Rh, Nh)
        cl = cluster_media(nomi_e, Rg, soglia_cluster)
        with open(os.path.join(uscita, "cluster.txt"), "w") as fh:
            fh.write("cluster per correlazione giornaliera, collegamento MEDIO, correlazione media assoluta >= %.2f, finestra %s\n" % (
                soglia_cluster, ("%s -> %s" % (data_da_giorno(fin[0]), data_da_giorno(fin[1]))) if fin else "tutta"))
            for c in cl:
                fh.write("  " + ", ".join(c) + "\n")
            fh.write("etichette nominali (proposta 07/09, NON firmata):\n")
            for s in serie:
                fh.write("  %s: %s\n" % (s["simbolo"], ",".join(cluster_di(s["simbolo"])) or "-"))
        log_("   correlazioni e cluster scritti")
    return serie, ris, rank


# ---------------------------------------------------------------------
# 15. CONTROLLO INDIPENDENTE (python puro, niente numpy)
# ---------------------------------------------------------------------
def verifica_mese_python_puro(percorso, fuso, mese, orologio="utc1"):
    """Ricalcola l'ADR di UN mese leggendo le righe a mano con la libreria standard.
    Ritorna (lista range per giorno, giorni) con la STESSA definizione di giorno server."""
    righe = []
    for nome, b in _membri(percorso):
        for ln in b.decode("ascii", "replace").splitlines():
            ln = ln.strip()
            m = re.match(r"^(\d{8}) (\d{6});([^;]+);([^;]+);([^;]+);([^;]+)", ln)
            if m:
                d, tt = m.group(1), m.group(2)
                dtl = dt.datetime(int(d[:4]), int(d[4:6]), int(d[6:8]), int(tt[:2]), int(tt[2:4]))
                o, h, l, c = (float(m.group(k)) for k in (3, 4, 5, 6))
            else:
                m = re.match(r"^(\d{4})[-./](\d{2})[-./](\d{2})[ T](\d{2}):(\d{2})[^,;]*[,;](.*)$", ln)
                if not m:
                    continue
                dtl = dt.datetime(int(m.group(1)), int(m.group(2)), int(m.group(3)), int(m.group(4)), int(m.group(5)))
                p = m.group(6).split(",") if "," in m.group(6) else m.group(6).split(";")
                try:
                    o, h, l, c = float(p[0]), float(p[1]), float(p[2]), float(p[3])
                except Exception:
                    continue
            if not (l <= o <= h and l <= c <= h and l > 0):
                continue                                    # OHLC incoerente: scartata come nella procedura
            righe.append((dtl, h, l))
    gio = {}
    visti = set()
    for dtl, h, l in righe:
        # fuso -> UTC con le regole di calendario in python puro
        if fuso == "NY":
            y = dtl.year
            ini = _nth_sunday(y, 3, 2) + dt.timedelta(hours=2)       # 02:00 locale EST
            fin = _nth_sunday(y, 11, 1) + dt.timedelta(hours=2)      # 02:00 locale EDT
            if y < 2007:
                ini = _nth_sunday(y, 4, 1) + dt.timedelta(hours=2)
                fin = _last_sunday(y, 10) + dt.timedelta(hours=2)
            utc = dtl + dt.timedelta(hours=4 if ini <= dtl < fin else 5)
        elif fuso == "UTC":
            utc = dtl
        else:
            raise ValueError("verifica: fuso non gestito %s" % fuso)
        if orologio != "utc1":
            raise ValueError("verifica: solo orologio utc1")
        if utc in visti:
            continue                                        # doppio sullo stesso minuto UTC: vale il primo, come nella procedura
        visti.add(utc)
        srv = utc + dt.timedelta(hours=1)
        giorno = srv.date()
        wd = giorno.weekday()
        if wd == 5:
            giorno += dt.timedelta(days=2)
        elif wd == 6:
            giorno += dt.timedelta(days=1)
        g = gio.setdefault(giorno, [h, l, 0])
        g[0] = max(g[0], h); g[1] = min(g[1], l); g[2] += 1
    ym = mese.split("-")
    sel = {d: v for d, v in gio.items() if d.year == int(ym[0]) and d.month == int(ym[1])}
    return sel


def verifica_mese(sim, feed, fuso, perc, mese):
    ref = verifica_mese_python_puro(perc, fuso, mese)
    s = carica_serie(sim, feed, fuso, perc)
    costruisci(s)
    d1 = s["d1"]
    ours = {}
    for i in range(len(d1["st"])):
        d = (EPOCH + dt.timedelta(days=int(d1["giorno"][i]))).date()
        if d.year == int(mese[:4]) and d.month == int(mese[5:7]):
            ours[d] = (float(d1["h"][i]), float(d1["l"][i]), int(d1["n"][i]), bool(d1["pieno"][i]))
    log("verifica mese %s: giorni (python puro) %d, giorni (procedura) %d" % (mese, len(ref), len(ours)))
    bad = 0
    for d in sorted(set(ref) | set(ours)):
        a = ref.get(d); b = ours.get(d)
        if a is None or b is None or abs(a[0] - b[0]) > 1e-9 or abs(a[1] - b[1]) > 1e-9 or a[2] != b[2]:
            bad += 1
            log("   DIVERSO %s: puro=%s procedura=%s" % (d, a, b))
    # ADR mediano sui giorni pieni (stessa definizione), a mano
    rp = sorted(v[0] - v[1] for d, v in ref.items() if d in ours and ours[d][3])
    n = len(rp)
    med_puro = (rp[n // 2] if n % 2 else 0.5 * (rp[n // 2 - 1] + rp[n // 2])) if n else float("nan")
    rn = sorted(v[0] - v[1] for d, v in ours.items() if v[3])
    n2 = len(rn)
    med_proc = (rn[n2 // 2] if n2 % 2 else 0.5 * (rn[n2 // 2 - 1] + rn[n2 // 2])) if n2 else float("nan")
    media_puro = sum(rp) / n if n else float("nan")
    log("   ADR mediano mese %s: puro %.6f  procedura %.6f  (giorni pieni %d) ; ADR medio puro %.6f" % (mese, med_puro, med_proc, n, media_puro))
    ok = (bad == 0) and abs(med_puro - med_proc) < 1e-9
    log("   -> %s" % ("COINCIDONO" if ok else "DIFFERISCONO"))
    return ok, ref, ours, med_puro, med_proc


def ispeziona(percorso, log_=log):
    """Inventario veloce di file M1: per ogni file/membro di zip, righe, periodo (come scritto nel file,
    SENZA convertire il fuso), M1 mediani per giorno di calendario, buchi, prezzo min/max. Nessuna misura."""
    out = []
    for nome, b in _membri(percorso):
        try:
            t, o, h, l, c, i = leggi_bytes(b)
        except Exception as e:
            log_("  %s: NON LEGGIBILE (%s)" % (nome, e))
            continue
        if len(t) == 0:
            log_("  %s: vuoto" % nome)
            continue
        d = t // 1440
        _, cnt = np.unique(d, return_counts=True)
        dif = np.diff(t)
        r = dict(nome=nome, righe=i["righe"], scartate=i["scartate"], da=(EPOCH + dt.timedelta(minutes=int(t.min()))).strftime("%Y-%m-%d %H:%M"),
                 a=(EPOCH + dt.timedelta(minutes=int(t.max()))).strftime("%Y-%m-%d %H:%M"), m1_giorno_med=float(np.median(cnt)),
                 giorni=len(cnt), buchi_gt_5min=int(np.count_nonzero(dif > 5)), pmin=float(l.min()), pmax=float(h.max()),
                 secondi_non_zero=i["secondi_non_zero"])
        out.append(r)
        log_("  %s: %s righe (scartate %d), dal %s al %s (ora del file), %d giorni, M1/giorno mediano %d, buchi > 5 min %d, prezzo %.4f-%.4f, secondi diversi da zero %d" % (
            nome, format(r["righe"], ","), r["scartate"], r["da"], r["a"], r["giorni"], r["m1_giorno_med"], r["buchi_gt_5min"], r["pmin"], r["pmax"], r["secondi_non_zero"]))
    return out


# ---------------------------------------------------------------------
# 16. AUTOTEST
# ---------------------------------------------------------------------
def _fail(msg):
    log("AUTOTEST FALLITO: " + msg)
    sys.exit(2)


def _check(cond, msg):
    if not cond:
        _fail(msg)
    log("   ok: " + msg)


def _serie_sintetica(giorni, f_giorno, tmin=1440, t0_giorno=16436, nm1=1440):
    """M1 con prezzo dato da f_giorno(i_giorno, minuto_server)->prezzo. t0_giorno = giorno epoch (lunedi' 2015-01-05)
    Minuto server 0 = 23:00 UTC del giorno prima."""
    T, P = [], []
    for k in range(giorni):
        d = t0_giorno + k
        if (d + 3) % 7 >= 5:
            continue
        for m in range(nm1):
            T.append((d * 1440 + m) - 60)       # minuto UTC: server = UTC+1
            P.append(f_giorno(k, m))
    T = np.array(T, np.int64); P = np.array(P, float)
    return T, P


def _mk_serie(T, P, sim="TEST", unita=1.0, orologio="utc1", continuo=True):
    c = P.copy()
    # continuo: open = prezzo del minuto precedente (la barra congiunge). Non continuo: open = close (nessun gap interno).
    o = np.r_[P[0], P[:-1]] if continuo else P.copy()
    h = np.maximum(o, c); l = np.minimum(o, c)
    s = dict(simbolo=sim, feed="sintetico", fuso="UTC", orologio=orologio, percorso="-", t=T, o=o, h=h, l=l, c=c, unita=unita,
             info=dict(file=1, righe=len(T), scartate_parse=0, scartate_ohlc=0, fuori_ordine=0, doppi=0, secondi_non_zero=0))
    return s


def autotest():
    log("AUTOTEST %s" % VERSIONE)
    # --- calendario
    log("1. calendario e fusi")
    a, b = us_dst_bounds_utc(2015)
    _check(a == _minuti(dt.datetime(2015, 3, 8, 7, 0)) and b == _minuti(dt.datetime(2015, 11, 1, 6, 0)), "ora legale USA 2015: 8 marzo 07:00 UTC -> 1 novembre 06:00 UTC")
    a, b = eu_dst_bounds_utc(2015)
    _check(a == _minuti(dt.datetime(2015, 3, 29, 1, 0)) and b == _minuti(dt.datetime(2015, 10, 25, 1, 0)), "ora legale EU 2015: 29 marzo 01:00 UTC -> 25 ottobre 01:00 UTC")
    a, b = us_dst_bounds_utc(2005)
    _check(a == _minuti(dt.datetime(2005, 4, 3, 7, 0)) and b == _minuti(dt.datetime(2005, 10, 30, 6, 0)), "ora legale USA 2005 (regola vecchia): 3 aprile -> 30 ottobre")
    t = np.array([_minuti(dt.datetime(2015, 7, 1, 9, 30)), _minuti(dt.datetime(2015, 1, 2, 9, 30))])
    u = ny_to_utc(t)
    _check(u[0] == _minuti(dt.datetime(2015, 7, 1, 13, 30)) and u[1] == _minuti(dt.datetime(2015, 1, 2, 14, 30)),
           "09:30 New York = 13:30 UTC d'estate e 14:30 UTC d'inverno")
    # bordi: 2015-03-08 01:59 locale e' ancora EST (+5); 03:00 locale e' EDT (+4)
    t = np.array([_minuti(dt.datetime(2015, 3, 8, 1, 59)), _minuti(dt.datetime(2015, 3, 8, 3, 0)),
                  _minuti(dt.datetime(2015, 11, 1, 0, 59)), _minuti(dt.datetime(2015, 11, 1, 2, 0))])
    u = ny_to_utc(t) - t
    _check(list(u) == [300, 240, 240, 300], "bordi del cambio ora (EST/EDT) nei minuti locali: %s" % list(u))
    t = np.array([_minuti(dt.datetime(2015, 1, 15, 12, 0)), _minuti(dt.datetime(2015, 7, 15, 12, 0))])
    _check(list(a_server(t, "utc1") - t) == [60, 60], "server BCM nuovo: UTC+1 fisso")
    _check(list(a_server(t, "vecchio") - t) == [0, 60], "server BCM vecchio: UTC+0 inverno, UTC+1 estate")
    # --- parser: i tre formati, stessi valori
    log("2. lettura dei formati")
    hd = b"20150102 023000;100.5;101.5;99.5;101.0;0\n20150102 023100;101.0;102.0;100.0;100.5;0\n"
    t1, o1, h1, l1, c1, i1 = leggi_bytes(hd)
    _check(list(t1) == [_minuti(dt.datetime(2015, 1, 2, 2, 30)), _minuti(dt.datetime(2015, 1, 2, 2, 31))] and list(h1) == [101.5, 102.0] and list(c1) == [101.0, 100.5],
           "HistData senza intestazione")
    oa = b"time,close,high,low,open,volume\n2015-01-02 02:30:00,101.0,101.5,99.5,100.5,7\n2015-01-02 02:31:00,100.5,102.0,100.0,101.0,3\n"
    t2, o2, h2, l2, c2, i2 = leggi_bytes(oa)
    _check(list(t2) == list(t1) and list(o2) == [100.5, 101.0] and list(l2) == [99.5, 100.0], "Oanda con intestazione e colonne in ordine diverso")
    mt = b"Time,Open,High,Low,Close,Volume\r\n2015.01.02 02:30,100.5,101.5,99.5,101.0,7\r\n2015.01.02 02:31,101.0,102.0,100.0,100.5,3\r\n"
    t3, o3, h3, l3, c3, i3 = leggi_bytes(mt)
    _check(list(t3) == list(t1) and list(c3) == list(c1), "export MT5 con data a punti e senza secondi")
    sporco = hd + b"RIGA ROTTA\n20150102 023200;1;2\n"
    t4, o4, h4, l4, c4, i4 = leggi_bytes(sporco)
    _check(len(t4) == 2 and i4["scartate"] == 2, "righe malformate CONTATE (%d), non sparite" % i4["scartate"])
    # fuso BCM_MISTO: vecchio prima del cambio, UTC+1 dopo, finestra dubbia scartata
    ts_ = np.array([_minuti(dt.datetime(2024, 7, 1, 12, 0)), _minuti(dt.datetime(2024, 12, 1, 12, 0)),
                    _minuti(dt.datetime(2025, 3, 1, 12, 0)), _minuti(dt.datetime(2025, 7, 1, 12, 0))])
    _check(list(verso_utc(ts_, "BCM_MISTO") - ts_) == [-60, 0, -60, -60], "BCM_MISTO: 2024-07 estate vecchio -60, 2024-12 inverno vecchio 0, 2025 UTC+1 fisso -60/-60")
    tmpm = os.path.join(os.environ.get("TMPDIR", "/tmp"), "scheda_misto_%d.csv" % os.getpid())
    with open(tmpm, "wb") as fh:
        fh.write(b"Time,Open,High,Low,Close,Volume\n2024.12.20 12:00,1,2,1,1,0\n2025.01.10 12:00,1,2,1,1,0\n2025.02.10 12:00,1,2,1,1,0\n")
    sm_ = carica_serie("EURUSD", "x", "BCM_MISTO", tmpm)
    _check(len(sm_["t"]) == 2 and sm_["info"]["scartate_cambio_orologio"] == 1, "BCM_MISTO: la riga del 10/01/2025 (finestra dubbia) e' scartata e contata")
    os.remove(tmpm)
    # --- pulizia: OHLC incoerente scartata, doppio scartato, fuori ordine contato
    log("3. pulizia")
    tmp = os.path.join(os.environ.get("TMPDIR", "/tmp"), "scheda_autotest_%d" % os.getpid())
    os.makedirs(tmp, exist_ok=True)
    fn = os.path.join(tmp, "x.csv")
    with open(fn, "wb") as fh:
        fh.write(b"20150105 000200;100;101;99;100\n20150105 000100;100;101;99;100\n20150105 000100;100;101;99;100\n20150105 000300;100;99;101;100\n")
    s = carica_serie("TEST", "x", "UTC", fn)
    _check(len(s["t"]) == 2 and s["info"]["scartate_ohlc"] == 1 and s["info"]["doppi"] == 1 and s["info"]["fuori_ordine"] >= 1,
           "pulizia: 1 OHLC incoerente, 1 doppio, fuori ordine contato, 2 barre valide")
    # --- ADR piantato: range per giorno della settimana noto
    log("4. ADR e giorno della settimana su dati con la risposta nota")
    R = {0: 10.0, 1: 20.0, 2: 30.0, 3: 40.0, 4: 50.0}

    def tri(k, m, base=100.0):
        d = 16436 + k
        wd = (d + 3) % 7
        r = R[wd]
        # triangolo: sale r in 720 minuti e scende r in 720 minuti, parte dal base
        return base + (r * m / 720.0 if m <= 720 else r * (1440 - m) / 720.0)
    T, P = _serie_sintetica(35, tri)
    s = _mk_serie(T, P)
    costruisci(s)
    M = misure_giornaliere(s)
    exp = np.mean(list(R.values()))
    _check(abs(M["adr_pt"]["media"] - exp) < 0.05, "ADR medio piantato = %.1f, misurato %.4f" % (exp, M["adr_pt"]["media"]))
    _check(abs(M["adr_pt"]["p50"] - 30.0) < 0.05, "ADR mediano piantato 30, misurato %.4f" % M["adr_pt"]["p50"])
    ws = {x["wd"]: x["media"] for x in M["per_wd"]}
    _check(all(abs(ws[k] - R[k]) < 0.05 for k in R), "range per giorno della settimana: %s" % {k: round(v, 2) for k, v in ws.items()})
    _check(abs(M["per_wd"][4]["indice"] - 50.0 / 30.0) < 0.01, "indice del venerdi' = 50/30")
    # controllo indipendente: lo stesso ADR in python puro
    giorni_py = {}
    for tt, pp in zip(T.tolist(), P.tolist()):
        d = (tt + 60) // 1440
        giorni_py.setdefault(d, []).append(pp)
    rp = [max(v) - min(v) for v in giorni_py.values()]
    _check(abs(sum(rp) / len(rp) - M["adr_pt"]["media"]) < 1e-9, "ADR numpy = ADR python puro (media)")
    # in unita' pip: stesso dato /0.0001 e prezzo /1000
    s2 = _mk_serie(T, P / 1000.0, "EURUSD", unita=0.0001)
    costruisci(s2)
    M2 = misure_giornaliere(s2)
    _check(abs(M2["adr_pt"]["media"] - exp * 10.0) < 0.5, "conversione in pip: 30 punti / 1000 / 0,0001 = 300 pip? (misurato %.2f, atteso %.2f)" % (M2["adr_pt"]["media"], exp * 10.0))
    # --- sessioni piantate: volatilita' solo dentro la finestra NY d'inverno
    log("5. sessioni e ore: un'onda solo nella finestra NY invernale")
    def onda(k, m):
        # d'inverno 2015 (k< 60): server minuti 930-1320 = 15:30-22:00 server = 14:30-21:00 UTC
        if 930 <= m < 1320:
            return 100.0 + 10.0 * ((m - 930) / 390.0)
        if m >= 1320:
            return 110.0
        return 100.0
    T, P = _serie_sintetica(20, onda)          # 2015-01-05 .. inverno
    s = _mk_serie(T, P)
    costruisci(s)
    S = misure_sessioni(s)
    ny = [x for x in S if x["nome"] == "NY"][0]
    asia = [x for x in S if x["nome"] == "ASIA"][0]
    _check(abs(ny["med"] - 10.0) < 0.1 and asia["med"] < 0.01, "sessione NY = 10 (tutta la salita), ASIA = 0 (misurato NY %.3f, ASIA %.3f)" % (ny["med"], asia["med"]))
    Oh = misure_ore(s)
    _check(abs(Oh[15]["med"] - 10.0 * 30.0 / 390.0) < 0.01 or abs(Oh[16]["med"] - 10.0 * 60.0 / 390.0) < 0.01, "ora 16 server = 10 x 60/390 = 1.538 (misurato %.3f)" % Oh[16]["med"])
    # contro-esempio: se il fuso fosse dichiarato NY quando i dati sono UTC la sessione NY verrebbe sbagliata
    # (la stessa serie letta con un fuso sbagliato sposta l'onda fuori dalla finestra NY)
    T2 = verso_utc(T + 60, "NY")  # 'T' e' UTC; trattarlo come NY lo sposta di +5h
    s2 = _mk_serie(T2, P)
    costruisci(s2)
    S2 = misure_sessioni(s2)
    ny2 = [x for x in S2 if x["nome"] == "NY"][0]
    _check(ny2["med"] < 9.0 or ny2["n"] == 0 or abs(ny2["med"] - ny["med"]) > 0.5,
           "CONTRO-ESEMPIO: con il fuso sbagliato la sessione NY non misura piu' 10 (misurato %s)" % f(ny2["med"], 3))
    # cancello dell'orologio: lo spike di volatilita' 14:30 UTC inverno / 13:30 UTC estate
    log("6. cancello dell'orologio (picco di volatilita' inverno/estate)")
    rng = np.random.default_rng(7)
    giorni = []
    for gg in range(16436 - 5 * 365, 16436 + 365):
        if (gg + 3) % 7 < 5:
            giorni.append(gg)
    T, C, Oo = [], [], []
    for gg in giorni:
        y, mth = (EPOCH + dt.timedelta(days=gg)).year, (EPOCH + dt.timedelta(days=gg)).month
        s0, e0 = us_dst_bounds_utc(y)
        estate = s0 <= gg * 1440 + 800 < e0
        spike = 810 if estate else 870
        base = np.arange(0, 1440, 1)
        amp = np.where(np.abs(base - spike) <= 1, 5.0, 0.1)
        T.append(gg * 1440 + base)
        Oo.append(np.full(1440, 100.0)); C.append(100.0 + amp * np.where(rng.random(1440) < 0.5, 1, -1))
    T = np.concatenate(T); Oo = np.concatenate(Oo); C = np.concatenate(C)
    w, nw, dw_ = picco_minuto(T, Oo, C, (1, 2)); e, ne, de_ = picco_minuto(T, Oo, C, (6, 7, 8))
    _check(w in (869, 870, 871) and e in (809, 810, 811) and abs((w - 60) - e) <= 2, "picco invernale %s e estivo %s UTC -> differenza 60" % (hhmm(w), hhmm(e)))
    # CONTRO-ESEMPIO (10/09): un feed spostato di UN'ORA (picco 09:00 d'inverno, 08:00 d'estate) supera il
    # controllo relativo (differenza 60) ma NON l'ancora assoluta: la scheda deve dire 'DA GUARDARE'.
    T2_, C2_, O2_ = [], [], []
    rng2 = np.random.default_rng(9)
    for gg in giorni:
        y2 = (EPOCH + dt.timedelta(days=gg)).year
        s2_, e2_ = us_dst_bounds_utc(y2)
        est2 = s2_ <= gg * 1440 + 800 < e2_
        sp2 = 480 if est2 else 540
        b2 = np.arange(0, 1440, 1)
        am2 = np.where(np.abs(b2 - sp2) <= 1, 5.0, 0.1)
        T2_.append(gg * 1440 + b2); O2_.append(np.full(1440, 100.0)); C2_.append(100.0 + am2 * np.where(rng2.random(1440) < 0.5, 1, -1))
    T2_ = np.concatenate(T2_); O2_ = np.concatenate(O2_); C2_ = np.concatenate(C2_)
    w3, _, _ = picco_minuto(T2_, O2_, C2_, (1, 2)); e3, _, _ = picco_minuto(T2_, O2_, C2_, (6, 7, 8))
    _check(abs((w3 - 60) - e3) <= 2 and ancora_vicina(w3) is None, "CONTRO-ESEMPIO: feed spostato di un'ora: relativo ok (%s/%s) ma NESSUNA ancora assoluta" % (hhmm(w3), hhmm(e3)))
    _check(ancora_vicina(w) is not None and ancora_vicina(870) == "14:30 apertura cash NY 9:30 ET", "il feed corretto cade su un'ancora nota (%s)" % ancora_vicina(w))
    # sessione NY d'ESTATE: finestra server 14:30-21:00 (810-1200 UTC = 870-1260 server); l'onda e' li'
    def onda_estate(k, m):
        if 870 <= m < 1260:
            return 100.0 + 10.0 * ((m - 870) / 390.0)
        if m >= 1260:
            return 110.0
        return 100.0
    Te_, Pe_ = _serie_sintetica(20, onda_estate, t0_giorno=16436 + 175)    # luglio 2015 (176 = 7 x 25 + 1: stessa regola feriale)
    se_ = _mk_serie(Te_, Pe_)
    costruisci(se_)
    Se_ = misure_sessioni(se_)
    nye_ = [x for x in Se_ if x["nome"] == "NY"][0]
    _check(abs(nye_["med"] - 10.0) < 0.1, "sessione NY d'estate = 10 con la finestra d'estate (misurato %.3f)" % nye_["med"])
    # il verdetto della SCHEDA (qualita) segue lo stesso criterio: feed giusto ok, feed spostato 'DA GUARDARE'
    def _q_da(Tx, Ox, Cx):
        sx = _mk_serie(Tx, Cx)
        sx["o"] = Ox.copy(); sx["h"] = np.maximum(Ox, Cx); sx["l"] = np.minimum(Ox, Cx)
        costruisci(sx)
        return qualita(sx)
    q_ok = _q_da(T, Oo, C)
    q_ko = _q_da(T2_, O2_, C2_)
    _check(q_ok["orologio_ok"] and q_ko["orologio_dst_ok"] and not q_ko["orologio_ok"],
           "qualita(): feed giusto -> orologio_ok; feed spostato di un'ora -> relativo ok ma orologio_ok=False")
    # evento di Tokyo (09:00 JST = 00:00 UTC tutto l'anno, niente ora legale): picco identico d'inverno e d'estate -> ok
    rj = np.random.default_rng(21)
    Cj = np.concatenate([100.0 + np.where(np.abs(np.arange(1440) - 0) <= 1, 5.0, 0.1) * np.where(rj.random(1440) < 0.5, 1, -1) for g_ in giorni])
    Tj = np.concatenate([np.arange(g_ * 1440, g_ * 1440 + 1440) for g_ in giorni])
    q_j = _q_da(Tj, np.full(len(Tj), 100.0), Cj)
    _check(q_j["orologio_ok"] and q_j["ancora_inverno"].startswith("00:00"), "evento di Tokyo senza ora legale (differenza 0): orologio ok (%s)" % q_j["ancora_inverno"])
    # campione corto (solo gen-feb): il verdetto e' INDECISO, non un "ok" per caso
    ddm = np.array(T // 1440, dtype="datetime64[D]").astype("datetime64[M]").astype(np.int64) % 12 + 1
    msk = np.isin(ddm, (1, 2)) & (T < T[0] + 400 * 1440)
    q_corto = _q_da(T[msk], Oo[msk], C[msk])
    _check(q_corto["orologio_indeciso"] and not q_corto["orologio_ok"], "campione di soli gen-feb: orologio INDECISO (giorni inverno %d, estate %d)" % (q_corto["giorni_inverno"], q_corto["giorni_estate"]))
    # rumore puro: picco poco netto -> INDECISO
    rr_ = np.random.default_rng(3)
    Tn = np.concatenate([np.arange(g_ * 1440, g_ * 1440 + 1440) for g_ in giorni])
    Cn = 100.0 + 0.1 * rr_.standard_normal(len(Tn))
    q_rum = _q_da(Tn, np.full(len(Tn), 100.0), Cn)
    _check(q_rum["orologio_indeciso"] and not q_rum["orologio_ok"], "rumore puro: nettezza del picco %.2f/%.2f -> INDECISO" % (q_rum["decisivita_inverno"], q_rum["decisivita_estate"]))
    # contro-esempio: gli stessi dati trattati come ora di New York (fuso sbagliato) NON danno la coppia 14:30/13:30
    w2, _, _ = picco_minuto(ny_to_utc(T), Oo, C, (1, 2))
    e2, _, _ = picco_minuto(ny_to_utc(T), Oo, C, (6, 7, 8))
    _check(abs((w2 - 60) - e2) > 2 or w2 not in (869, 870, 871), "CONTRO-ESEMPIO: un fuso sbagliato sposta i picchi a %s/%s e il cancello non passa" % (hhmm(w2), hhmm(e2)))
    # --- gap piantato
    log("7. gap di apertura")
    # costruzione diretta: 08:00-18:00 server, buco notturno di 14 ore, un salto piantato fra i giorni
    T, P, K = [], [], []
    for k in range(10):
        d = 16436 + k
        if (d + 3) % 7 >= 5:
            continue
        for m in range(480, 1080):
            T.append(d * 1440 + m - 60)
            P.append(100.0 + (10.0 * (m - 480) / 600.0) + (3.0 if (k % 2) else 0.0))
            K.append(k)
    T = np.array(T, np.int64); P = np.array(P)
    s = _mk_serie(T, P, continuo=False)
    costruisci(s)
    M = misure_giornaliere(s)
    G = misure_gap(s, M)
    # attesi, dalla formula che ha generato i dati (indipendente dalle matrici della procedura)
    attesi_p, attesi_w = [], []
    for k in range(9):
        d0, d1_ = 16436 + k, 16436 + k + 1
        if (d0 + 3) % 7 >= 5:
            continue
        chiusa = 100.0 + 10.0 * (1079 - 480) / 600.0 + (3.0 if (k % 2) else 0.0)
        apre = 100.0 + (3.0 if ((k + 1) % 2) else 0.0)
        # giorno seguente feriale? se d1_ e' sabato il buco e' weekend e il prossimo giorno e' il lunedi' k+3
        if (d1_ + 3) % 7 >= 5:
            kk = k + 3
            apre = 100.0 + (3.0 if (kk % 2) else 0.0)
            attesi_w.append(abs(apre - chiusa))
        else:
            attesi_p.append(abs(apre - chiusa))
    _check(G["pausa"]["n"] == len(attesi_p), "gap 'pausa': %d eventi trovati, %d attesi" % (G["pausa"]["n"], len(attesi_p)))
    _check(abs(G["pausa"]["media_pt"] - sum(attesi_p) / len(attesi_p)) < 1e-9, "gap 'pausa' medio = %.4f (atteso dalla formula %.4f)" % (G["pausa"]["media_pt"], sum(attesi_p) / len(attesi_p)))
    if attesi_w and "media_pt" in G.get("weekend", {}):
        _check(abs(G["weekend"]["media_pt"] - sum(attesi_w) / len(attesi_w)) < 1e-9, "gap 'weekend' medio = atteso")
    _check(G["pausa"]["buco_med_ore"] == 14.0 or abs(G["pausa"]["buco_med_ore"] - 14.0) < 0.05, "buco notturno mediano 14 ore (misurato %.2f)" % G["pausa"]["buco_med_ore"])
    # --- true range: il gap entra nell'ATR
    tr_ = true_range(np.array([100.0, 110.0]), np.array([101.0, 111.0]), np.array([99.0, 109.0]), np.array([100.0, 110.0]))
    _check(list(tr_) == [2.0, 11.0], "true range con gap: [2, 11] (misurato %s)" % list(tr_))
    _check(abs(atr_sma(np.array([100.0, 110.0]), np.array([101.0, 111.0]), np.array([99.0, 109.0]), np.array([100.0, 110.0]), 2)[1] - 6.5) < 1e-12, "ATR(2) = 6,5")
    # --- zigzag e ritracciamento piantati
    log("8. zigzag e ritracciamento con la risposta nota")
    path = [0.0]
    for _ in range(10):
        path.append(path[-1] + 1.0)           # 0 -> 10
    for _ in range(5):
        path.append(path[-1] - 1.0)           # 10 -> 5
    for _ in range(15):
        path.append(path[-1] + 1.0)           # 5 -> 20
    for _ in range(8):
        path.append(path[-1] - 1.0)           # 20 -> 12
    for _ in range(10):
        path.append(path[-1] + 1.0)           # 12 -> 22
    for _ in range(3):
        path.append(path[-1] - 1.0)           # 22 -> 19
    p = np.array(path)
    atr_c = np.full(len(p), 2.0)                # rho*ATR = 1.0
    piv = zigzag(p, p, atr_c, 0.5)
    prezzi = [x[1] for x in piv]
    _check(prezzi[:5] == [0.0, 10.0, 5.0, 20.0, 12.0], "pivot confermati %s (attesi 0,10,5,20,12 prima del tratto finale)" % prezzi)
    rr = ritracciamenti(p, p, atr_c, 0.5, ks=(2.0,))
    x = rr[2.0]
    # gambe: 10 (0->10), 5 (10->5), 15 (5->20), 8 (20->12), 10 (12->22 pivot non confermato?) ; rapporti: 5/10, 15/5, 8/15
    _check(x["n"] >= 3, "impulsi >= 4 ATR trovati: %d" % x["n"])
    # misura diretta dei rapporti
    idx = np.array([q[0] for q in piv]); pr = np.array([q[1] for q in piv])
    leg = np.abs(np.diff(pr))
    rat = leg[1:] / leg[:-1]
    _check(np.allclose(rat[:3], [0.5, 3.0, 8.0 / 15.0]), "rapporti di ritracciamento 0,5 / 3,0 / 0,5333 (misurati %s)" % np.round(rat[:3], 4).tolist())
    _check(x["tocco"][0.236] is None and x["tocco"][0.382] is not None, "livelli <= rho/k (0,25) mostrati come troncati per costruzione")
    # il rumore SOTTO soglia non crea pivot: salita 0 -> 10 con ritracci di 0,4 (< soglia 1,0) in mezzo
    w_ = [0.0]
    for q_ in range(10):
        w_.append(w_[-1] + 1.0)
        if q_ % 3 == 2:
            w_.append(w_[-1] - 0.4)
    w_ = np.array(w_)
    pv = zigzag(w_, w_, np.full(len(w_), 2.0), 0.5)
    _check(len(pv) == 0 or all(abs(x_[1]) >= 0 for x_ in pv) and not any(abs(pv[i_ + 1][1] - pv[i_][1]) < 1.0 for i_ in range(len(pv) - 1)),
           "ritracci di 0,4 (sotto la soglia 1,0) non creano pivot: pivot trovati %s" % [round(x_[1], 2) for x_ in pv])
    # con una soglia piu' bassa (0,2) gli stessi ritracci DIVENTANO pivot: la soglia conta
    pv2 = zigzag(w_, w_, np.full(len(w_), 0.4), 0.5)
    _check(len(pv2) > len(pv), "con soglia 0,2 gli stessi ritracci diventano pivot (%d contro %d)" % (len(pv2), len(pv)))
    # RW di riferimento: riproducibile
    log("9. random walk di riferimento")
    o, h, l, c = rw_barre(2000, seme=SEME)
    o2, h2, l2, c2 = rw_barre(2000, seme=SEME)
    _check(np.array_equal(c, c2), "il RW a seme fisso e' identico ad ogni lancio")
    o3, h3, l3, c3 = rw_barre(2000, seme=SEME + 1)
    _check(not np.array_equal(c, c3), "semi diversi -> serie diverse (il seme conta)")
    _check(np.all(h >= np.maximum(o, c) - 1e-12) and np.all(l <= np.minimum(o, c) + 1e-12), "barre RW coerenti (H>=max(O,C), L<=min(O,C))")
    # --- ER
    log("10. efficiency ratio")
    line = np.arange(100.0)
    er = efficiency_ratio(line, 20)
    _check(np.allclose(er, 1.0), "linea retta -> ER = 1")
    alt = np.tile([0.0, 1.0], 60)
    er = efficiency_ratio(alt, 20)
    _check(np.allclose(er, 0.0), "andata e ritorno -> ER = 0")
    oo, hh, ll, cc = rw_barre(20000, seme=3)
    erm = float(np.nanmean(efficiency_ratio(cc, 20)))
    _check(abs(erm - 1.0 / math.sqrt(20)) / (1.0 / math.sqrt(20)) < 0.15, "RW: ER medio %.4f vicino a 1/radice(20) = %.4f (entro 15%%)" % (erm, 1.0 / math.sqrt(20)))
    # CONTRO-ESEMPIO: la misura deve distinguere un RW da un trend piantato
    trend = np.cumsum(np.full(5000, 0.3) + np.random.default_rng(5).standard_normal(5000))
    ert = float(np.nanmedian(efficiency_ratio(trend, 20)))
    _check(ert > float(np.nanmedian(efficiency_ratio(cc, 20))) + 0.05, "CONTRO-ESEMPIO: un trend piantato (deriva 0,3) ha ER %.3f > RW" % ert)
    # --- EMA200
    log("11. comportamento alla EMA200")
    o, h, l, c = rw_barre(8000, seme=11)
    ce = comportamento_ema(o, h, l, c)
    _check(ce["n"] > 5000 and 0 <= ce["sopra_pct"] <= 100, "EMA200 su RW: %d barre, %.1f%% sopra" % (ce["n"], ce["sopra_pct"]))
    rbq = ce["rimbalzo_quota"]
    # un feed che RIMBALZA davvero sulla linea: onda sinusoidale lenta attorno a una media, ampiezza grande
    n = 8000
    tt = np.arange(n)
    c_s = 1000.0 + 50.0 * np.sin(tt / 40.0)
    o_s = np.r_[c_s[0], c_s[:-1]]
    h_s = np.maximum(o_s, c_s) + 0.5; l_s = np.minimum(o_s, c_s) - 0.5
    # con atr ~ costante, la sinusoide oscilla attorno alla EMA: tocchi regolari, incroci regolari
    ces = comportamento_ema(o_s, h_s, l_s, c_s, sep=5)
    _check(ces["n"] > 5000 and ces["incroci_per_100"] > 0.5, "sinusoide: incroci regolari (%.2f per 100 barre)" % ces["incroci_per_100"])
    # oracolo indipendente (python puro, ricodificato dalla descrizione del piano) contro la funzione vettoriale
    def oracolo(o_, h_, l_, c_, n_, warm_, sep_, hor_):
        N_ = len(c_); al = 2.0 / (n_ + 1.0)
        E_ = []; e_ = c_[0]
        for v in c_:
            e_ = e_ + al * (v - e_); E_.append(e_)
        tr_ = []
        for i in range(N_):
            pc_ = o_[0] if i == 0 else c_[i - 1]
            tr_.append(max(h_[i] - l_[i], abs(h_[i] - pc_), abs(l_[i] - pc_)))
        A_ = [None] * N_
        for i in range(ATR_N - 1, N_):
            A_[i] = sum(tr_[i - ATR_N + 1:i + 1]) / ATR_N
        B_ = P_ = X_ = 0
        j = warm_ + sep_
        while j < N_ - hor_ - 1:
            if not (A_[j] and A_[j] > 0 and l_[j] <= E_[j] <= h_[j]):
                j += 1; continue
            sd = [(1 if c_[q] - E_[q] > 0 else (-1 if c_[q] - E_[q] < 0 else 0)) for q in range(j - sep_, j)]
            if len(set(sd)) != 1 or sd[0] == 0:
                j += 1; continue
            far = False
            for q in range(j - sep_, j):
                if A_[q] and abs(c_[q] - E_[q]) / A_[q] >= 1.0:
                    far = True
            if not far:
                j += 1; continue
            s0 = sd[0]; esito = 0
            for q in range(j + 1, j + hor_ + 1):
                away = s0 * ((h_[q] if s0 > 0 else l_[q]) - E_[q]) / A_[j]
                beyond = -s0 * (c_[q] - E_[q]) / A_[j]
                if away >= 1.0 and not (beyond >= 0.5):
                    esito = 1; break
                if beyond >= 0.5:
                    esito = 2; break
            if esito == 1: B_ += 1
            elif esito == 2: P_ += 1
            else: X_ += 1
            j += hor_
        return B_, P_, X_
    o_, h_, l_, c_ = rw_barre(3000, seme=17)
    cm = comportamento_ema(o_, h_, l_, c_, n=20, warm=50, sep=5, hor=10)
    orc = oracolo(o_.tolist(), h_.tolist(), l_.tolist(), c_.tolist(), 20, 50, 5, 10)
    _check((cm["B"], cm["P"], cm["AMB"]) == orc and cm["B"] + cm["P"] > 10, "EMA: eventi (rimbalzo/rottura/ambiguo) = oracolo python puro %s" % (orc,))
    _check(abs(cm["rimbalzo_quota"] - orc[0] / (orc[0] + orc[1])) < 1e-12, "EMA: quota di rimbalzo = B/(B+P) dell'oracolo")
    # percentili
    st_ = stat(np.arange(1, 101))
    _check(abs(st_["p50"] - 50.5) < 1e-9 and abs(st_["p10"] - 10.9) < 1e-9 and abs(st_["p90"] - 90.1) < 1e-9 and st_["n"] == 100, "stat(): percentili di 1..100 = 10,9 / 50,5 / 90,1")
    # --- correlazioni
    log("12. correlazioni")
    r1 = np.random.default_rng(1).standard_normal(500)
    r2 = np.random.default_rng(2).standard_normal(500)
    k = np.arange(500)
    _check(abs(corr_su((k, r1), (k, r1), 60)[0] - 1.0) < 1e-12, "serie identica -> rho = 1")
    _check(abs(corr_su((k, r1), (k, -r1), 60)[0] + 1.0) < 1e-12, "serie opposta -> rho = -1")
    _check(abs(corr_su((k, r1), (k, r2), 60)[0]) < 0.2, "serie indipendenti -> |rho| piccolo")
    _check(np.isnan(corr_su((k[:30], r1[:30]), (k[:30], r2[:30]), 60)[0]), "campione sotto il minimo -> NaN, non un numero")
    # il campione si interseca per CHIAVE, non per posizione: spostare una serie di 5 giorni cambia il risultato
    kk = k + 5
    _check(abs(corr_su((k, r1), (kk, r1), 60)[0] - 1.0) > 0.05, "CONTRO-ESEMPIO: serie identiche sfasate di 5 chiavi NON danno rho=1 (allineamento per chiave)")
    cl = cluster_media(["A", "B", "C"], np.array([[1, .9, .1], [.9, 1, .2], [.1, .2, 1]]), 0.5)
    _check(sorted(map(tuple, cl)) == [("A", "B"), ("C",)], "cluster per soglia: {A,B},{C}")
    # CONTRO-ESEMPIO della catena: A-B 0,9, B-C 0,55, A-C 0,1: a collegamento singolo diventerebbe {A,B,C}
    cl = cluster_media(["A", "B", "C"], np.array([[1, .9, .1], [.9, 1, .55], [.1, .55, 1]]), 0.5)
    _check(sorted(map(tuple, cl)) == [("A", "B"), ("C",)], "CONTRO-ESEMPIO catena: A-C 0,1 NON finiscono nello stesso cluster solo perche' B-C vale 0,55")
    cl = cluster_media(["A", "B"], np.array([[1, np.nan], [np.nan, 1]]), 0.5)
    _check(sorted(map(tuple, cl)) == [("A",), ("B",)], "correlazione NaN (campione troppo corto) non fonde nessun gruppo")
    # --- ranking: senza finestra comune NON si fa
    log("12b. ranking e finestra comune")
    sa = _mk_serie(*_serie_sintetica(100, tri), sim="A")
    sb = _mk_serie(*_serie_sintetica(100, lambda k, m: tri(k, m) * 2.0), sim="B")
    costruisci(sa); costruisci(sb)
    ris_ = {}
    for x_ in (sa, sb):
        x_["q"] = qualita(x_)
        mm_ = misure_giornaliere(x_)
        aa_ = misure_atr_tf(x_, mm_)
        ris_[x_["simbolo"] + "|" + x_["feed"]] = dict(M=mm_, A=aa_, E=misure_er(x_))
    fin_ = finestra_comune([sa, sb])
    rk = riga_ranking([sa, sb], ris_, fin_)
    _check(fin_ is not None and rk[0]["rank_adr_pct"] != "" and rk[1]["rank_adr_pct"] != "", "serie sovrapposte: ranking fatto")
    # B ha lo stesso % di A? B = 2x prezzo e 2x range => stesso % ; l'ordine puo' essere qualunque ma entrambi hanno un rango
    # serie NON sovrapposte: ranking vuoto
    sc = _mk_serie(*_serie_sintetica(100, tri, t0_giorno=16436 + 399), sim="C")
    costruisci(sc)
    ris_["C|sintetico"] = dict(M=misure_giornaliere(sc), A=misure_atr_tf(sc, misure_giornaliere(sc)), E=misure_er(sc))
    ris_["C|sintetico"]["M"]["adr_pct"]["p50"] = ris_["C|sintetico"]["M"]["adr_pct"]["p50"]
    fin2 = finestra_comune([sa, sc])
    _check(fin2 is None, "CONTRO-ESEMPIO: serie di periodi diversi -> nessuna finestra comune (None), non una classifica fra mele e pere")
    rk2 = riga_ranking([sa, sc], ris_, fin2)
    _check(all(r_["rank_adr_pct"] == "" and r_["finestra_comune"] == "NO" for r_ in rk2), "ranking vuoto e marcato finestra_comune=NO")
    fin3 = finestra_comune([sa, sc], "2015-01-05:2015-02-05")
    _check(fin3 is not None and fin3[1] - fin3[0] == 31, "finestra esplicita 2015-01-05:2015-02-05 = 31 giorni")
    # --- costo
    log("13. frontiera del costo")
    sp = [(h_, 0.30, 0.5, 3600, 5) for h_ in range(24)]
    fake_atr = {"M15": {"atr_ult252": 6.0}, "H1": {"atr_ult252": 12.0}, "H4": {"atr_ult252": 24.0}}
    cst = misure_costo(None, fake_atr, sp)
    fc = {x["tf"]: x["fuori_costo"] for x in cst["righe"]}
    _check(fc == {"M15": True, "H1": False, "H4": False, "D1": False}, "con spread 0,30 e ATR 6 / 12 / 24: M15 fuori costo (6 < 40x0,30=12), H1 al confine, H4 dentro")
    # --- indipendenza dal fuso: stesso movimento in file NY e in file UTC -> stessa scheda
    log("14. riproducibilita'")
    T, P = _serie_sintetica(30, tri)
    sA = _mk_serie(T, P); sB = _mk_serie(T.copy(), P.copy())
    costruisci(sA); costruisci(sB)
    _check(np.array_equal(misure_giornaliere(sA)["rng"], misure_giornaliere(sB)["rng"]), "stessi dati -> stesse misure")
    try:
        os.remove(fn)
        os.rmdir(tmp)
    except OSError:
        pass
    log("AUTOTEST OK")
    return True


# ---------------------------------------------------------------------
# 17. MAIN
# ---------------------------------------------------------------------
def _parse_serie(x):
    p = x.split(":", 3)
    if len(p) != 4:
        raise SystemExit("--serie vuole SIMBOLO:FEED:FUSO:PERCORSO (letto: %s)" % x)
    if p[2] not in ("UTC", "NY", "BCM_UTC1", "BCM_VECCHIO", "BCM_MISTO"):
        raise SystemExit("fuso non valido: %s (UTC|NY|BCM_UTC1|BCM_VECCHIO|BCM_MISTO)" % p[2])
    return (p[0], p[1], p[2], p[3], None)


def main():
    ap = argparse.ArgumentParser(description=__doc__ if False else "scheda simbolo da barre M1")
    ap.add_argument("--autotest", action="store_true")
    ap.add_argument("--serie", action="append", default=[], help="SIMBOLO:FEED:FUSO:PERCORSO (ripetibile)")
    ap.add_argument("--manifest", help="CSV: simbolo,feed,fuso,percorso[,unita]")
    ap.add_argument("--uscita", help="cartella dove scrivere schede, ranking, correlazioni")
    ap.add_argument("--spread", help="file SPREAD_VIVO_*_orario.csv")
    ap.add_argument("--giorno", default="utc1", choices=["utc1", "nyclose"])
    ap.add_argument("--orologio", default="utc1", choices=["utc1", "vecchio"])
    ap.add_argument("--verifica-mese", help="SIMBOLO:FEED:FUSO:PERCORSO:AAAA-MM")
    ap.add_argument("--ispeziona", help="PERCORSO: inventario veloce dei file M1 (righe, periodo, buchi), senza misure")
    ap.add_argument("--finestra", help="AAAA-MM-GG:AAAA-MM-GG, finestra di confronto per ranking e correlazioni (default: intersezione delle serie)")
    ap.add_argument("--tf-ritr", default="H1", choices=["M15", "H1", "H4"], help="TF dello zigzag del ritracciamento")
    a = ap.parse_args()
    if a.autotest:
        autotest()
        return 0
    if a.ispeziona:
        r = ispeziona(a.ispeziona)
        return 0 if r else 2
    if a.verifica_mese:
        p = a.verifica_mese.rsplit(":", 1)
        sp = _parse_serie(p[0])
        ok = verifica_mese(sp[0], sp[1], sp[2], sp[3], p[1])[0]
        return 0 if ok else 2
    specs = [_parse_serie(x) for x in a.serie]
    if a.manifest:
        with open(a.manifest, newline="") as fh:
            for r in csv.DictReader(fh):
                specs.append((r["simbolo"], r["feed"], r["fuso"], r["percorso"], float(r["unita"]) if r.get("unita") else None))
    if not specs or not a.uscita:
        ap.error("servono --serie o --manifest, e --uscita (oppure --autotest)")
    esegui(specs, a.uscita, a.spread, a.giorno, a.orologio, finestra=a.finestra, tf_ritr=a.tf_ritr)
    return 0


if __name__ == "__main__":
    sys.exit(main())
