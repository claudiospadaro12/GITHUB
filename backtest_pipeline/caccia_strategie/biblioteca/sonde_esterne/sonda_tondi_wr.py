#!/usr/bin/env python3
# SONDA NUMERI TONDI -- tasso TP-PRIMA-DI-SL contro CONTROLLO A INGRESSI CASUALI
# con la STESSA geometria, sugli STESSI dati (regola di metodo di casa, 03/09).
# Geometria: TP = SL = 8,0 pip (le mediane MFE/MAE misurate), orizzonte 12 barre M5.
# Ambiguita' intrabarra risolta SEMPRE a sfavore (SL prima del TP).
import csv, os, glob, random, datetime as dt

S = os.environ.get("S", ".")
random.seed(20260905)
ORIZZ, COOLDOWN, ROMPI = 12, 12, 0.5
TP = SL = 8.0


def ultima_domenica(a, m):
    d = dt.date(a, m, 31)
    while d.weekday() != 6:
        d -= dt.timedelta(days=1)
    return d


def dst(t):
    return dt.datetime.combine(ultima_domenica(t.year, 3), dt.time(1)) <= t < \
           dt.datetime.combine(ultima_domenica(t.year, 10), dt.time(1))


def carica_m5(sym, anni):
    agg = {}
    for f in sorted(glob.glob(os.path.join(S, "dati", sym, "*.csv"))):
        b = os.path.basename(f)
        anno = int(b.split("-")[0]) if "-" in b else int(b.split("_")[1][:4])
        if anno not in anni:
            continue
        with open(f) as fh:
            for r in csv.DictReader(fh):
                t = dt.datetime.strptime(r["time"], "%Y-%m-%d %H:%M:%S")
                if dst(t):
                    t += dt.timedelta(hours=1)
                k = t.replace(minute=(t.minute // 5) * 5, second=0)
                o, h, l, c = float(r["open"]), float(r["high"]), float(r["low"]), float(r["close"])
                agg[k] = (agg[k][0], max(agg[k][1], h), min(agg[k][2], l), c) if k in agg else (o, h, l, c)
    return [(k,) + v for k, v in sorted(agg.items())]


def esito(bars, i0, verso, prezzo, pip):
    """1 = TP prima di SL, 0 = SL prima o scadenza. A sfavore: SL vince i pari."""
    tp = prezzo + verso * TP * pip
    sl = prezzo - verso * SL * pip
    for j in range(i0, min(i0 + ORIZZ, len(bars))):
        _, o, h, l, c = bars[j]
        if verso > 0:
            if l <= sl:
                return 0
            if h >= tp:
                return 1
        else:
            if h >= sl:
                return 0
            if l <= tp:
                return 1
    return 0


def corri(sym, pip, grid_pips, anni):
    bars = carica_m5(sym, anni)
    if not bars:
        print(f"[{sym}] NESSUN DATO"); return
    gg = len({b[0].date() for b in bars if b[0].weekday() < 5})
    print(f"\n{'='*72}\n{sym} — {len(bars):,} barre M5, {gg} giorni  |  TP=SL={TP} pip, {ORIZZ} barre\n{'='*72}")
    for g in grid_pips:
        passo, ultimo = g * pip, {}
        r_ok = r_n = c_ok = c_n = 0
        for i in range(1, len(bars) - ORIZZ):
            t, o, h, l, c = bars[i]
            if t.weekday() >= 5:
                continue
            hp, lp = bars[i - 1][2], bars[i - 1][3]
            for k in range(int(l / passo) + 1, int(h / passo) + 1):
                liv = k * passo
                if hp >= liv >= lp or i - ultimo.get(k, -999) < COOLDOWN:
                    continue
                ultimo[k] = i
                dal_basso = o < liv
                v_rimb = -1 if dal_basso else 1
                rotto = (c - liv) / pip >= ROMPI if dal_basso else (liv - c) / pip >= ROMPI
                if rotto:
                    c_ok += esito(bars, i + 1, -v_rimb, c, pip); c_n += 1
                else:
                    r_ok += esito(bars, i + 1, v_rimb, c, pip); r_n += 1
        # controllo casuale sullo STESSO numero di ingressi
        tot = r_n + c_n
        camp = random.sample(range(1, len(bars) - ORIZZ), min(tot, len(bars) - ORIZZ - 2))
        k_ok = sum(esito(bars, i + 1, random.choice((1, -1)), bars[i][4], pip) for i in camp)
        wr_r = 100 * r_ok / max(r_n, 1)
        wr_c = 100 * c_ok / max(c_n, 1)
        wr_k = 100 * k_ok / max(len(camp), 1)
        print(f"\n--- griglia {g} pip  ({tot} segnali)")
        print(f"  RIMBALZO (fade del livello) TP-prima-di-SL = {wr_r:5.2f}%  (n={r_n})   delta vs caso {wr_r-wr_k:+5.2f} pt")
        print(f"  CASCATA  (rottura)          TP-prima-di-SL = {wr_c:5.2f}%  (n={c_n})   delta vs caso {wr_c-wr_k:+5.2f} pt")
        print(f"  CONTROLLO CASUALE                          = {wr_k:5.2f}%  (n={len(camp)})")


corri("EUR_USD", 0.0001, (100, 50, 10), set(range(2011, 2020)))
