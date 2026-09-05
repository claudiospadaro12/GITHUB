#!/usr/bin/env python3
# SONDA POST-NEWS -- misura di OCCASIONI, mai un verdetto.
# Dati: FutureSharks/financial-data (GPL-3.0), Oanda EUR_USD M1, timestamp UTC.
# Calendario: CALENDARIO_FF_High_2010-2023_UTC.csv (UTC).
# LIMITI dichiarati: non e' BCM, e' OHLC M1 (non tick), ZERO costi/spread,
# finestra 2010-2020. Ambiguita' intrabarra risolta SEMPRE a sfavore.
import csv, os, glob, random, datetime as dt
from collections import defaultdict

DIR = os.path.dirname(os.path.abspath(__file__))
CAL = "/home/user/GITHUB/backtest_pipeline/caccia_strategie/biblioteca/dati/CALENDARIO_FF_High_2010-2023_UTC.csv"
PIP = 0.0001
random.seed(12345)

def carica_barre():
    bars = {}
    for f in sorted(glob.glob(os.path.join(DIR, "dati", "EUR_USD", "*.csv"))):
        with open(f) as fh:
            r = csv.DictReader(fh)
            for row in r:
                t = dt.datetime.strptime(row["time"], "%Y-%m-%d %H:%M:%S")
                bars[t] = (float(row["open"]), float(row["high"]),
                           float(row["low"]), float(row["close"]))
    return bars

def carica_eventi(titoli):
    ev = []
    with open(CAL, encoding="utf-8", errors="replace") as fh:
        r = csv.reader(fh, delimiter=";")
        next(r)
        for row in r:
            if len(row) < 4: continue
            if row[2] != "USD": continue
            if row[3].strip() not in titoli: continue
            t = dt.datetime.strptime(row[0], "%Y.%m.%d %H:%M")
            ev.append((t, row[3].strip()))
    # una sola occasione al giorno (gPlacedDay del motore): tieni la prima
    per_giorno = {}
    for t, tit in sorted(ev):
        per_giorno.setdefault(t.date(), (t, tit))
    return [v for _, v in sorted(per_giorno.items())]

def range_finestra(bars, t_ev, off_ini, off_fin):
    """max/min sulle barre M1 in [t_ev+off_ini, t_ev+off_fin) -- equivale alle
    due candele M5 chiuse che il motore legge all'ora d'azione."""
    hi, lo, n = -1e9, 1e9, 0
    t = t_ev + dt.timedelta(minutes=off_ini)
    fine = t_ev + dt.timedelta(minutes=off_fin)
    while t < fine:
        b = bars.get(t)
        if b:
            hi = max(hi, b[1]); lo = min(lo, b[2]); n += 1
        t += dt.timedelta(minutes=1)
    if n < off_fin - off_ini - 2:   # finestra troppo bucata
        return None
    return hi, lo

def simula(bars, t_start, t_exp, px_up, px_dn, verso_up, verso_dn,
           sl_pip, tp_pip, oco, exit_min=None):
    """verso_up = +1 se al superamento di px_up si va LONG, -1 se SHORT.
    Ritorna (pips_totali, n_fill, lista_esiti)."""
    pend = {"up": (px_up, verso_up), "dn": (px_dn, verso_dn)}
    pos = []          # (verso, entry, sl, tp)
    pips = 0.0; nfill = 0; esiti = []
    t = t_start
    t_exit = t_exp if exit_min is None else min(t_exp, t_start + dt.timedelta(minutes=exit_min))
    while t < t_exit:
        b = bars.get(t)
        if not b:
            t += dt.timedelta(minutes=1); continue
        o, h, l, c = b
        # 1) uscite delle posizioni gia' aperte -- SFAVOREVOLE PRIMA
        vive = []
        for (v, e, sl, tp) in pos:
            if v > 0:
                if l <= sl:   pips += (sl - e) / PIP; esiti.append("SL")
                elif h >= tp: pips += (tp - e) / PIP; esiti.append("TP")
                else: vive.append((v, e, sl, tp))
            else:
                if h >= sl:   pips += (e - sl) / PIP; esiti.append("SL")
                elif l <= tp: pips += (e - tp) / PIP; esiti.append("TP")
                else: vive.append((v, e, sl, tp))
        pos = vive
        # 2) scatti dei pendenti
        for k in list(pend.keys()):
            if k not in pend: continue
            px, v = pend[k]
            colpito = (h >= px) if k == "up" else (l <= px)
            if not colpito: continue
            del pend[k]
            nfill += 1
            sl = px - v * sl_pip * PIP
            tp = px + v * tp_pip * PIP
            # stesso minuto: risolvi a sfavore
            if v > 0 and l <= sl:   pips += (sl - px) / PIP; esiti.append("SL")
            elif v < 0 and h >= sl: pips += (px - sl) / PIP; esiti.append("SL")
            elif v > 0 and h >= tp: pips += (tp - px) / PIP; esiti.append("TP")
            elif v < 0 and l <= tp: pips += (px - tp) / PIP; esiti.append("TP")
            else: pos.append((v, px, sl, tp))
            if oco: pend.clear()
        t += dt.timedelta(minutes=1)
    # 3) chiusura forzata a scadenza
    tc = t_exit
    for _ in range(30):
        if bars.get(tc): break
        tc -= dt.timedelta(minutes=1)
    b = bars.get(tc)
    if b:
        for (v, e, sl, tp) in pos:
            pips += v * (b[3] - e) / PIP; esiti.append("TEMPO")
    return pips, nfill, esiti

def riassunto(nome, res):
    n = len(res)
    if n == 0:
        print(f"{nome:34s}  nessun evento"); return
    tot = sum(r[0] for r in res)
    vinc = [r[0] for r in res if r[0] > 0]; pers = [r[0] for r in res if r[0] < 0]
    gw = sum(vinc); gl = -sum(pers)
    pf = (gw / gl) if gl > 0 else float("inf")
    dop = sum(1 for r in res if r[1] >= 2)
    nf = sum(1 for r in res if r[1] >= 1)
    print(f"{nome:34s} ev={n:4d} fill={nf:4d} 2gambe={dop:4d} ({100*dop/n:4.1f}%) "
          f"pip_tot={tot:9.1f} pip/ev={tot/n:6.2f} PF={pf:5.2f} vinc={len(vinc):4d}/{len(vinc)+len(pers):4d}")

def main():
    print("carico barre M1 EUR_USD ...")
    bars = carica_barre()
    print(f"barre M1 caricate: {len(bars):,}  dal {min(bars):%Y-%m-%d} al {max(bars):%Y-%m-%d}\n")

    BLOCCHI = {
        "ISM/CB 15:00": (["ISM Manufacturing PMI", "ISM Services PMI", "CB Consumer Confidence"], 70),
        "13:30 (CPI/Retail/PPI)": (["CPI m/m", "Core CPI m/m", "Retail Sales m/m",
                                    "Core Retail Sales m/m", "PPI m/m"], 60),
    }
    for nomeblocco, (titoli, durata) in BLOCCHI.items():
        eventi = carica_eventi(titoli)
        print("=" * 118)
        print(f"BLOCCO {nomeblocco}   eventi-giorno nel calendario: {len(eventi)}   "
              f"finestra viva: azione+{durata} min")
        print("=" * 118)
        varianti = defaultdict(list)
        usati = 0
        for t_ev, tit in eventi:
            rng = range_finestra(bars, t_ev, 5, 15)
            if rng is None: continue
            hi, lo = rng
            usati += 1
            t_act = t_ev + dt.timedelta(minutes=15)
            t_exp = t_act + dt.timedelta(minutes=durata)
            up = hi + 3.0 * PIP      # BUY STOP  = max + 3 pip
            dn = lo - 2.0 * PIP      # SELL STOP = min - 2 pip
            # A) replica esatta della cella bocciata: breakout, OCO OFF
            varianti["A breakout OCO=off (replica)"].append(
                simula(bars, t_act, t_exp, up, dn, +1, -1, 25, 30, False))
            # B) breakout con OCO acceso
            varianti["B breakout OCO=ON"].append(
                simula(bars, t_act, t_exp, up, dn, +1, -1, 25, 30, True))
            # C) FADE (limit): stessi prezzi, versi invertiti
            varianti["C fade OCO=off"].append(
                simula(bars, t_act, t_exp, up, dn, -1, +1, 25, 30, False))
            varianti["D fade OCO=ON"].append(
                simula(bars, t_act, t_exp, up, dn, -1, +1, 25, 30, True))
            # E) breakout, uscita a TEMPO a +30 min (niente TP: TP irraggiungibile)
            varianti["E breakout uscita a tempo 30'"].append(
                simula(bars, t_act, t_exp, up, dn, +1, -1, 25, 9999, True, exit_min=30))
            # F) fade con uscita a tempo 30'
            varianti["F fade uscita a tempo 30'"].append(
                simula(bars, t_act, t_exp, up, dn, -1, +1, 25, 9999, True, exit_min=30))
            # G) CONTROLLO A INGRESSI CASUALI, stessa geometria
            m = random.randint(0, max(0, durata - 5))
            t_r = t_act + dt.timedelta(minutes=m)
            br = bars.get(t_r)
            k = 0
            while br is None and k < 20:
                t_r += dt.timedelta(minutes=1); br = bars.get(t_r); k += 1
            if br:
                v = random.choice([+1, -1])
                px = br[0]
                varianti["G CASUALE stessa geometria"].append(
                    simula(bars, t_r, t_exp, px if v > 0 else 1e9,
                           px if v < 0 else -1e9, +1, -1, 25, 30, True))
        print(f"eventi con barre sufficienti: {usati}/{len(eventi)}\n")
        for k in sorted(varianti): riassunto(k, varianti[k])
        print()

main()
