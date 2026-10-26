#!/usr/bin/env python3
"""A7 - Replica indipendente (solo dalla guida) del MULTI TF BIAS DASHBOARD, limitata a W1 e D1.

Solo libreria standard. Uso:
    python3 replica_indipendente.py            # autotest + calcolo + CSV
    python3 replica_indipendente.py --test     # solo autotest
    python3 replica_indipendente.py --run      # solo calcolo + CSV

Convenzioni: barra = (data, open, high, low, close, tickvol). Tutti gli score interni sono in [-1,+1]
e il punteggio di un timeframe e 100 * media pesata (pesi 30/25/20/15/10 -> struttura, trend,
momentum, price action, volume). Vedi NOTE_A7.md per ogni scelta di formula.
"""
import csv
import datetime as dt
import math
import os
import random
import sys

AQUI = os.path.dirname(os.path.abspath(__file__))
BASE = "/tmp/claude-0/-home-user-GITHUB/c2d73886-9ef2-5105-8937-d770bc36d6df/scratchpad/lavoro_wt"
DATA_CSV = BASE + "/data/prezzi/XAUUSD_D1_BCM_2004-06-11_2026-10-21.csv"
OUT_CSV = os.path.join(AQUI, "out_A7_score_giornaliero.csv")

# ---- parametri (input letti dagli screenshot) ----
EMA_P = (20, 50, 200)
RSI_P = 14
MACD_F, MACD_S, MACD_SIG = 12, 26, 9
ATR_P = 14
SLOPE_BARS = 5
LOOKBACK = 150
SWING = 3
PA_BARS = 8
W_COMP = {"struct": 30.0, "trend": 25.0, "mom": 20.0, "pa": 15.0, "vol": 10.0}
NEUTRAL_TH = 15.0
W_TF = {"W1": 30.0, "D1": 25.0}
FIRST_VALID = EMA_P[-1] - 1 + SLOPE_BARS  # EMA200 disponibile a idx 199, serve anche EMA a t-5

# ---------------------------------------------------------------- utilita


def clamp(x, lo=-1.0, hi=1.0):
    return lo if x < lo else hi if x > hi else x


def sgn(x):
    return 1.0 if x > 0 else -1.0 if x < 0 else 0.0


# ---------------------------------------------------------------- dati


def leggi_d1(path=DATA_CSV):
    """Legge il CSV e fonde le barre della domenica nella prima barra feriale successiva
    (sessione di apertura del lunedi), cosi la D1 e lun-ven."""
    out = []
    pend = None
    with open(path, newline="") as f:
        rd = csv.reader(f, delimiter="\t")
        next(rd)
        for r in rd:
            d = dt.datetime.strptime(r[0], "%Y.%m.%d").date()
            o, h, l, c, v = float(r[1]), float(r[2]), float(r[3]), float(r[4]), float(r[5])
            if d.weekday() >= 5:  # sabato/domenica: accantonata e fusa nella barra feriale successiva
                if pend is None:
                    pend = [o, h, l, c, v]
                else:
                    pend[1] = max(pend[1], h)
                    pend[2] = min(pend[2], l)
                    pend[3] = c
                    pend[4] += v
                continue
            if pend is not None:
                o = pend[0]
                h = max(h, pend[1])
                l = min(l, pend[2])
                v += pend[4]
                pend = None
            out.append((d, o, h, l, c, v))
    return out


def settimane(d1):
    """Raggruppa le barre D1 (lun-ven) in barre W1 per data. Ritorna lista di
    (venerdi_della_settimana, o, h, l, c, v). La barra W1 e 'chiusa' al giorno t se venerdi <= t."""
    w = []
    cur = None
    for d, o, h, l, c, v in d1:
        mon = d - dt.timedelta(days=d.weekday())
        fri = mon + dt.timedelta(days=4)
        if cur is None or cur[0] != fri:
            if cur is not None:
                w.append(tuple(cur))
            cur = [fri, o, h, l, c, v]
        else:
            cur[2] = max(cur[2], h)
            cur[3] = min(cur[3], l)
            cur[4] = c
            cur[5] += v
    if cur is not None:
        w.append(tuple(cur))
    return w


# ---------------------------------------------------------------- indicatori (tutti causali)


def ema_series(vals, n, start=0):
    """EMA con seme = SMA dei primi n valori validi (dall'indice `start`). None prima."""
    out = [None] * len(vals)
    if len(vals) - start < n:
        return out
    k = 2.0 / (n + 1)
    e = sum(vals[start:start + n]) / n
    out[start + n - 1] = e
    for i in range(start + n, len(vals)):
        e = vals[i] * k + e * (1 - k)
        out[i] = e
    return out


def atr_series(bars, n=ATR_P):
    tr = [bars[0][2] - bars[0][3]]
    for i in range(1, len(bars)):
        pc = bars[i - 1][4]
        tr.append(max(bars[i][2] - bars[i][3], abs(bars[i][2] - pc), abs(bars[i][3] - pc)))
    out = [None] * len(bars)
    if len(bars) <= n:
        return out
    a = sum(tr[1:n + 1]) / n
    out[n] = a
    for i in range(n + 1, len(bars)):
        a = (a * (n - 1) + tr[i]) / n
        out[i] = a
    return out


def rsi_series(closes, n=RSI_P):
    out = [None] * len(closes)
    if len(closes) <= n:
        return out
    g = l = 0.0
    for i in range(1, n + 1):
        d = closes[i] - closes[i - 1]
        g += max(d, 0.0)
        l += max(-d, 0.0)
    g /= n
    l /= n

    def val(g, l):
        if l == 0:
            return 100.0 if g > 0 else 50.0
        return 100.0 - 100.0 / (1.0 + g / l)

    out[n] = val(g, l)
    for i in range(n + 1, len(closes)):
        d = closes[i] - closes[i - 1]
        g = (g * (n - 1) + max(d, 0.0)) / n
        l = (l * (n - 1) + max(-d, 0.0)) / n
        out[i] = val(g, l)
    return out


def macd_series(closes):
    ef = ema_series(closes, MACD_F)
    es = ema_series(closes, MACD_S)
    macd = [None if (a is None or b is None) else a - b for a, b in zip(ef, es)]
    first = next((i for i, v in enumerate(macd) if v is not None), None)
    sig = [None] * len(closes)
    if first is not None:
        sig = ema_series([0.0 if v is None else v for v in macd], MACD_SIG, start=first)
    hist = [None if (m is None or s is None) else m - s for m, s in zip(macd, sig)]
    return macd, sig, hist


def pivots(bars, k=SWING):
    """Flag di pivot (alto, basso) con k barre per lato. Il pivot in i e noto solo da i+k."""
    n = len(bars)
    ph = [False] * n
    pl = [False] * n
    for i in range(k, n - k):
        h = bars[i][2]
        l = bars[i][3]
        left_h = max(bars[j][2] for j in range(i - k, i))
        right_h = max(bars[j][2] for j in range(i + 1, i + k + 1))
        left_l = min(bars[j][3] for j in range(i - k, i))
        right_l = min(bars[j][3] for j in range(i + 1, i + k + 1))
        ph[i] = h > left_h and h >= right_h
        pl[i] = l < left_l and l <= right_l
    return ph, pl


# ---------------------------------------------------------------- componenti


def comp_struct(bars, ph, pl, t):
    """Struttura: HH/HL vs LH/LL sugli ultimi due swing confermati + rottura (BOS/CHoCH) in chiusura."""
    lo = max(SWING, t - LOOKBACK + 1)
    hi = t - SWING  # pivot confermato solo se i+SWING <= t
    highs, lows = [], []
    for i in range(hi, lo - 1, -1):
        if len(highs) < 2 and ph[i]:
            highs.append(bars[i][2])
        if len(lows) < 2 and pl[i]:
            lows.append(bars[i][3])
        if len(highs) == 2 and len(lows) == 2:
            break
    s_h = sgn(highs[0] - highs[1]) if len(highs) == 2 else 0.0
    s_l = sgn(lows[0] - lows[1]) if len(lows) == 2 else 0.0
    swing = 0.5 * s_h + 0.5 * s_l
    c = bars[t][4]
    brk = 0.0
    if highs and c > highs[0]:
        brk += 1.0
    if lows and c < lows[0]:
        brk -= 1.0
    return 0.6 * swing + 0.4 * brk


def comp_trend(bars, ind, t):
    c = bars[t][4]
    a = ind["atr"][t]
    e = [ind["ema"][p][t] for p in EMA_P]
    ep = [ind["ema"][p][t - SLOPE_BARS] for p in EMA_P]
    pos = sum(clamp((c - x) / a) for x in e) / 3.0
    order = (sgn(e[0] - e[1]) + sgn(e[1] - e[2]) + sgn(e[0] - e[2])) / 3.0
    slope = sum(clamp((x - y) / (0.5 * a)) for x, y in zip(e, ep)) / 3.0
    sp = [(e[0] - e[1], ep[0] - ep[1]), (e[1] - e[2], ep[1] - ep[2])]
    widen = sum(clamp((s - sp_) / (0.5 * a)) for s, sp_ in sp) / 2.0
    return 0.30 * pos + 0.25 * order + 0.25 * slope + 0.20 * widen


def comp_mom(ind, t):
    a = ind["atr"][t]
    r = ind["rsi"][t]
    if r > 55:
        lvl = (r - 55) / 15.0
    elif r < 45:
        lvl = (r - 45) / 15.0
    else:
        lvl = 0.0
    lvl = clamp(lvl)
    rdir = clamp((r - ind["rsi"][t - 3]) / 10.0)
    rsi_part = 0.7 * lvl + 0.3 * rdir
    m = ind["macd"][t]
    line = clamp(m / a)
    hist = clamp(ind["hist"][t] / (0.3 * a))
    mdir = clamp((m - ind["macd"][t - 3]) / (0.5 * a))
    macd_part = 0.4 * line + 0.3 * hist + 0.3 * mdir
    return 0.5 * rsi_part + 0.5 * macd_part


def comp_pa(bars, ind, t):
    a = ind["atr"][t]
    num = den = 0.0
    for k in range(PA_BARS):
        _, o, h, l, c, _v = bars[t - PA_BARS + 1 + k]
        rng = h - l
        w = k + 1.0  # peso lineare: l'ultima candela conta di piu
        if rng <= 0:
            s = 0.0
        else:
            cl = (c - (h + l) / 2.0) / (rng / 2.0)
            body = (c - o) / rng
            wick = ((min(o, c) - l) - (h - max(o, c))) / rng
            s = 0.4 * cl + 0.4 * body + 0.2 * wick
        num += w * s
        den += w
    candles = num / den
    disp = clamp((bars[t][4] - bars[t - PA_BARS][4]) / (3.0 * a))
    return 0.7 * candles + 0.3 * disp


def comp_vol(bars, t):
    vols = [bars[i][5] for i in range(t - PA_BARS + 1, t + 1)]
    tot = sum(vols)
    if tot <= 0:
        return 0.0
    bal = sum(v * sgn(bars[i][4] - bars[i][1]) for v, i in zip(vols, range(t - PA_BARS + 1, t + 1))) / tot
    base = sum(bars[i][5] for i in range(t - 49, t + 1)) / 50.0
    if base <= 0:
        return 0.0
    ratio = (tot / PA_BARS) / base
    return bal * min(ratio, 1.5) / 1.5


def indicatori(bars):
    closes = [b[4] for b in bars]
    macd, sig, hist = macd_series(closes)
    return {
        "atr": atr_series(bars),
        "ema": {p: ema_series(closes, p) for p in EMA_P},
        "rsi": rsi_series(closes),
        "macd": macd,
        "hist": hist,
    }


def tf_scores(bars):
    """Score firmato [-100,100] per ogni barra (None se storico insufficiente). Causale."""
    n = len(bars)
    out = [None] * n
    if n <= FIRST_VALID:
        return out
    ind = indicatori(bars)
    ph, pl = pivots(bars)
    wsum = sum(W_COMP.values())
    for t in range(FIRST_VALID, n):
        a = ind["atr"][t]
        if a is None or a <= 0 or ind["hist"][t] is None or ind["ema"][EMA_P[-1]][t - SLOPE_BARS] is None:
            continue
        comps = {
            "struct": comp_struct(bars, ph, pl, t),
            "trend": comp_trend(bars, ind, t),
            "mom": comp_mom(ind, t),
            "pa": comp_pa(bars, ind, t),
            "vol": comp_vol(bars, t),
        }
        s = sum(W_COMP[k] * comps[k] for k in comps) / wsum * 100.0
        out[t] = max(-100.0, min(100.0, s))
    return out


# ---------------------------------------------------------------- calcolo giornaliero


def bias(score):
    if score is None:
        return "N/A"
    return "BULLISH" if score >= NEUTRAL_TH else "BEARISH" if score <= -NEUTRAL_TH else "NEUTRAL"


def punteggi_giornalieri(d1):
    """Per ogni barra D1 (giorno t): (data, score_W1, score_D1, overall) usando solo dati <= t."""
    sd = tf_scores(d1)
    wk = settimane(d1)
    sw = tf_scores(wk)
    wfri = [w[0] for w in wk]
    wsum = W_TF["W1"] + W_TF["D1"]
    res = []
    j = -1  # ultimo indice settimana con venerdi <= t
    for i, b in enumerate(d1):
        t = b[0]
        while j + 1 < len(wk) and wfri[j + 1] <= t:
            j += 1
        w1 = sw[j] if j >= 0 else None
        d1s = sd[i]
        ov = None
        if w1 is not None and d1s is not None:
            ov = (W_TF["W1"] * w1 + W_TF["D1"] * d1s) / wsum
        res.append((t, w1, d1s, ov))
    return res


def scrivi_csv(res, path=OUT_CSV, da=dt.date(2005, 1, 3), a=dt.date(2026, 10, 16)):
    def f(x):
        return "" if x is None else "%.2f" % x

    n = 0
    with open(path, "w", newline="") as fh:
        fh.write("data;score_W1;score_D1;score_overall;bias_overall\n")
        for t, w1, d1s, ov in res:
            if da <= t <= a:
                fh.write("%s;%s;%s;%s;%s\n" % (t.isoformat(), f(w1), f(d1s), f(ov), bias(ov)))
                n += 1
    return n


# ---------------------------------------------------------------- autotest


def specchia(bars, C=10000.0):
    return [(d, C - o, C - l, C - h, C - c, v) for d, o, h, l, c, v in bars]


def _uguali(a, b, tol=1e-6):
    if a is None or b is None:
        return a is None and b is None
    return abs(a - b) <= tol


def autotest(verbose=True):
    d1 = leggi_d1()
    ok = True

    def rep(nome, cond, extra=""):
        nonlocal ok
        ok = ok and cond
        if verbose:
            print("[%s] %s %s" % ("OK " if cond else "KO ", nome, extra))

    base = punteggi_giornalieri(d1)

    # 1) range [-100,100] su tutti gli score (D1, W1, overall)
    vals = [x for r in base for x in r[1:] if x is not None]
    rep("range [-100,100]", all(-100.0 <= x <= 100.0 for x in vals),
        "(n=%d, min=%.2f, max=%.2f)" % (len(vals), min(vals), max(vals)))
    rep("copertura score non nulli", len(vals) > 10000)

    # 2) assenza di lookahead: (a) troncamento, (b) barre future sostituite da rumore
    rnd = random.Random(7)
    idxs = [i for i in (400, 1500, 2999, 3000, 4100, 5200) if i < len(d1) - 40]
    # includi un venerdi e un mercoledi espliciti
    for k in (3000, 3001, 3002, 3003, 3004, 3005):
        if d1[k][0].weekday() == 4:
            idxs.append(k)
            break
    for k in (4000, 4001, 4002, 4003, 4004, 4005):
        if d1[k][0].weekday() == 2:
            idxs.append(k)
            break
    for t in idxs:
        trunc = punteggi_giornalieri(d1[:t + 1])
        okt = all(_uguali(trunc[t][k], base[t][k]) for k in (1, 2, 3))
        okt = okt and all(all(_uguali(trunc[i][k], base[i][k]) for k in (1, 2, 3)) for i in range(0, t + 1, 7))
        fut = list(d1[:t + 1])
        for d, o, h, l, c, v in d1[t + 1:]:
            m = rnd.uniform(500, 6000)
            oo = m + rnd.uniform(-50, 50)
            cc = m + rnd.uniform(-50, 50)
            fut.append((d, oo, max(oo, cc) + 20, min(oo, cc) - 20, cc, rnd.uniform(1, 9e5)))
        mut = punteggi_giornalieri(fut)
        okm = all(_uguali(mut[t][k], base[t][k]) for k in (1, 2, 3))
        okm = okm and all(all(_uguali(mut[i][k], base[i][k]) for k in (1, 2, 3)) for i in range(0, t + 1, 7))
        rep("no-lookahead t=%s (%s)" % (d1[t][0], d1[t][0].strftime("%a")), okt and okm,
            "troncamento=%s futuro-casuale=%s" % (okt, okm))

    # 3) simmetria: specchiando i prezzi lo score cambia segno
    mir = punteggi_giornalieri(specchia(d1))
    maxdiff = 0.0
    nn = 0
    for r, m in zip(base, mir):
        for k in (1, 2, 3):
            if r[k] is None or m[k] is None:
                if (r[k] is None) != (m[k] is None):
                    maxdiff = float("inf")
                continue
            maxdiff = max(maxdiff, abs(r[k] + m[k]))
            nn += 1
    rep("simmetria (specchio -> segno opposto)", maxdiff < 1e-6, "(confronti=%d, max|s+s'|=%.2e)" % (nn, maxdiff))

    # 4) W1 cambia solo a fine settimana (venerdi): lun-gio uguale al venerdi precedente
    viol = 0
    for i in range(1, len(base)):
        if base[i][0].weekday() in (1, 2, 3) and base[i][0] - base[i - 1][0] == dt.timedelta(days=1):
            if not _uguali(base[i][1], base[i - 1][1]):
                viol += 1
    rep("W1 costante tra lunedi e giovedi", viol == 0, "(violazioni=%d)" % viol)

    # 5) sanita direzionale: trend sintetico con ritracciamenti (HH/HL) -> score alto, ribassista -> basso
    rr = random.Random(3)
    p = 1000.0
    syn = []
    day = dt.date(2010, 1, 4)
    for i in range(700):
        if day.weekday() < 5:
            o = p
            c = p * (1 + 0.004 + 0.012 * math.sin(i / 3.0) + rr.uniform(-0.002, 0.002))  # deriva + ritracciamenti
            syn.append((day, o, max(o, c) * 1.001, min(o, c) * 0.999, c, 1000 + rr.uniform(0, 200)))
            p = c
        day += dt.timedelta(days=1)
    su = [x for x in tf_scores(syn)[-150:] if x is not None]
    sdn = [x for x in tf_scores(specchia(syn, 100000.0))[-150:] if x is not None]
    msu, mdn = sum(su) / len(su), sum(sdn) / len(sdn)
    rep("trend sintetico rialzista/ribassista (media ultimi 150 gg)", msu > 30 and mdn < -30 and min(su) > -20,
        "(su=%.1f giu=%.1f, min su=%.1f)" % (msu, mdn, min(su)))

    if verbose:
        print("AUTOTEST:", "SUPERATO" if ok else "FALLITO")
    return ok, base


def main():
    arg = sys.argv[1] if len(sys.argv) > 1 else ""
    base = None
    if arg in ("", "--test"):
        ok, base = autotest()
        if not ok:
            sys.exit(1)
    if arg in ("", "--run"):
        if base is None:
            base = punteggi_giornalieri(leggi_d1())
        n = scrivi_csv(base)
        print("scritte %d righe in %s" % (n, OUT_CSV))
        cnt = {"BULLISH": 0, "BEARISH": 0, "NEUTRAL": 0}
        for t, w1, d1s, ov in base:
            if dt.date(2008, 7, 1) <= t <= dt.date(2026, 10, 16) and ov is not None:
                cnt[bias(ov)] += 1
        tot = sum(cnt.values())
        print("dal 2008-07-01 (n=%d giorni): " % tot +
              "  ".join("%s %.1f%%" % (k, 100.0 * v / tot) for k, v in cnt.items()))


if __name__ == "__main__":
    main()
