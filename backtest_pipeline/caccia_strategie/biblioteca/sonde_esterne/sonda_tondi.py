#!/usr/bin/env python3
# SONDA NUMERI TONDI (M23, Osler JF 2003 / JIMF 2005) -- cancelli R1..R6
# congelati il 03/09 in CACCIA_FREQUENZA5_TASSONOMIA_2026-09-03.md par. 4.2.
# NON toccati. TF di lavoro M5, orizzonte 12 barre = 60 minuti.
# Dati: FutureSharks/financial-data (GPL-3.0), Oanda M1 -> M5, timestamp UTC->Londra.
# LIMITI: non e' BCM, OHLC (non tick), ZERO costi/spread, 2011-2019.
import csv, os, glob, random, statistics as st, datetime as dt

S = os.environ.get("S", ".")
random.seed(20260905)
ORIZZ = 12          # 12 barre M5 = 60 minuti
COOLDOWN = 12       # stesso livello non ricontato entro 12 barre
ROMPI = 0.5         # rottura = chiusura oltre il livello di >= 0,5 pip


def ultima_domenica(a, m):
    d = dt.date(a, m, 31)
    while d.weekday() != 6:
        d -= dt.timedelta(days=1)
    return d


def dst(t):
    return dt.datetime.combine(ultima_domenica(t.year, 3), dt.time(1)) <= t < \
           dt.datetime.combine(ultima_domenica(t.year, 10), dt.time(1))


def carica_m5(sym, anni):
    """M1 -> M5 (ora di Londra). Ritorna lista ordinata (t, o, h, l, c)."""
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
                if k in agg:
                    a = agg[k]
                    agg[k] = (a[0], max(a[1], h), min(a[2], l), c)
                else:
                    agg[k] = (o, h, l, c)
    return [(k,) + v for k, v in sorted(agg.items())]


def esc(bars, i0, verso, prezzo, n):
    """MFE/MAE in prezzo su n barre M5. Ambiguita' intrabarra a sfavore."""
    mfe = mae = 0.0
    for j in range(i0, min(i0 + n, len(bars))):
        _, o, h, l, c = bars[j]
        if verso > 0:
            mae = min(mae, l - prezzo); mfe = max(mfe, h - prezzo)
        else:
            mae = min(mae, prezzo - h); mfe = max(mfe, prezzo - l)
    return mfe, -mae


def corri(sym, pip, grid_pips, anni, etichetta):
    bars = carica_m5(sym, anni)
    if not bars:
        print(f"[{sym}] NESSUN DATO"); return
    gg = len({b[0].date() for b in bars if b[0].weekday() < 5})
    print(f"\n{'='*76}\n{sym} {etichetta} — {len(bars):,} barre M5, {gg} giorni "
          f"({bars[0][0].date()} -> {bars[-1][0].date()})\n{'='*76}")
    for g in grid_pips:
        passo = g * pip
        ultimo = {}
        rimb_mfe, rimb_mae, casc_mfe, casc_mae = [], [], [], []
        n_rimb = n_casc = n_tocchi = 0
        for i in range(1, len(bars) - ORIZZ):
            t, o, h, l, c = bars[i]
            if t.weekday() >= 5:
                continue
            hp, lp = bars[i - 1][2], bars[i - 1][3]
            # livelli della griglia attraversati da QUESTA barra e non dalla precedente
            k0 = int(l / passo) + 1
            k1 = int(h / passo)
            for k in range(k0, k1 + 1):
                liv = k * passo
                if hp >= liv >= lp:       # gia' toccato dalla barra prima
                    continue
                if i - ultimo.get(k, -999) < COOLDOWN:
                    continue
                ultimo[k] = i
                n_tocchi += 1
                dal_basso = o < liv
                verso_rimb = -1 if dal_basso else 1     # RIMBALZO = fade del livello
                # esito a fine barra: rottura o rimbalzo?
                rotto = (c - liv) / pip >= ROMPI if dal_basso else (liv - c) / pip >= ROMPI
                if rotto:
                    n_casc += 1
                    m, a = esc(bars, i + 1, -verso_rimb, c, ORIZZ)
                    casc_mfe.append(m / pip); casc_mae.append(a / pip)
                else:
                    n_rimb += 1
                    m, a = esc(bars, i + 1, verso_rimb, c, ORIZZ)
                    rimb_mfe.append(m / pip); rimb_mae.append(a / pip)
        if n_tocchi == 0:
            continue
        print(f"\n--- griglia {g} pip   (livelli x.xx{'00' if g==100 else ('50' if g==50 else 'x0')})")
        print(f"  R1  tocchi/giorno (due lati sommati) ...... {n_tocchi/gg:6.2f}"
              f"   {'PASSA' if n_tocchi/gg >= 2.0 else 'SOTTO IL PAVIMENTO 2,00'}")
        print(f"  R2  RIMBALZI {n_rimb:6d} ({100*n_rimb/n_tocchi:4.1f}%)  |  ROTTURE {n_casc:6d} ({100*n_casc/n_tocchi:4.1f}%)")
        if rimb_mfe:
            f3, f5 = st.median(rimb_mfe), st.median(rimb_mae)
            print(f"  R3  RIMBALZO: MFE med {f3:5.2f} pip | MAE med {f5:5.2f} | RR {f3/max(f5,1e-9):5.3f}")
        if casc_mfe:
            f4, f5b = st.median(casc_mfe), st.median(casc_mae)
            print(f"  R4  CASCATA : MFE med {f4:5.2f} pip | MAE med {f5b:5.2f} | RR {f4/max(f5b,1e-9):5.3f}")
    # controllo casuale, stessa geometria
    camp = random.sample(range(1, len(bars) - ORIZZ), min(8000, len(bars) - ORIZZ - 2))
    cm, ca = [], []
    for i in camp:
        v = random.choice((1, -1))
        m, a = esc(bars, i + 1, v, bars[i][4], ORIZZ)
        cm.append(m / pip); ca.append(a / pip)
    print(f"\n  >>> CONTROLLO CASUALE (n={len(cm)}, stessa geometria 12 barre M5):")
    print(f"      MFE mediana {st.median(cm):5.2f} pip | MAE mediana {st.median(ca):5.2f} | RR {st.median(cm)/st.median(ca):5.3f}")


anni = set(range(2011, 2020))
corri("EUR_USD", 0.0001, (100, 50, 10), anni, "(tondi FX)")
