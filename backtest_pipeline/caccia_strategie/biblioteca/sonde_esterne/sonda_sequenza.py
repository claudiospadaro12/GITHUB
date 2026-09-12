#!/usr/bin/env python3
# ---------------------------------------------------------------------------
# SONDA DI CONTEGGIO ESTERNA -- "SEQUENZA DI INVERSIONE" (candela madre + N
# candele monotone contrarie) su INDICI, M30 e H1, SESSIONE CASH.
#
# Nata il 12/09/2026 nella caccia CACCIA_SUPREV_ALTERNATIVE (regola della
# seconda caccia, dopo il verdetto A6 sui blocchi B e C di ABTG_SupRev).
#
# GEOMETRIA MISURATA (letta nel sorgente Pine di "Momentum Sequence Strategy
# [Herman]", helmans13, MPL-2.0, TradingView PUB;11d65a5fe0724173b72c230c576947fc)
#   LONG : la barra i-N e' BEARISH (close<open) = candela madre;
#          le N barre successive sono TUTTE bullish, TUTTE con low > low(madre),
#          e con chiusure STRETTAMENTE crescenti; ingresso al close della barra i;
#          SL = low(madre); 1R = entry - SL; TP = entry + RR x 1R.
#   SHORT: specchio esatto.
#
# COSA MISURA E COSA NON MISURA
#   MISURA: occasioni per giorno per lato, 1R in punti indice, costo in R,
#           TP-prima-di-SL contro CONTROLLO APPAIATO (stessa barra, lato
#           opposto, stessa geometria -- regola del 05/09), E in R netta.
#   NON MISURA: il nostro broker, i nostri spread veri su SPXUSD, lo slippage,
#           il regime 2024-2026. Nessun numero di qui e' un verdetto: e' una
#           misura di OCCASIONI e di TAGLIA (LEGGIMI.md, limiti 1-6).
#
# FONTE DATI: github FutureSharks/financial-data (histdata M1, GPL-3.0).
#   OROLOGIO: ora file + 5 = ora server BCM (collaudato il 05/09, e ricollaudato
#   da questa sonda con --clock: DAX picca a 03:00 file, SPX a 09:30 file).
#
# AMBIGUITA' INTRABARRA: sempre A SFAVORE (se TP e SL cadono nella stessa
# barra -> perdita). Zero costi dentro la sonda: il costo si aggiunge dopo,
# in R, ed e' dichiarato in testa all'uscita.
#
# USO: export S=<cartella con dati/>; python3 sonda_sequenza.py [--clock]
# ---------------------------------------------------------------------------
import os, sys, glob
from statistics import median

S = os.environ.get('S', '.')

# --- spread MISURATI di casa (SPREAD_FLOTTA_MISURA_2026-09-03.md), in punti indice
SPREAD = {
    'GRXEUR': 1.65,   # mappa su D30EUR: 1,6-1,7 misurati in sessione
    'SPXUSD': 1.95,   # [NON MISURATO su BCM] -- usato il valore U30USD come PROXY
}
SESSIONE_FILE = {     # finestra CASH in ORA FILE (ora file + 5 = ora server)
    'GRXEUR': (3.0, 11.5),    # server 08:00 - 16:30
    'SPXUSD': (9.5, 16.0),    # server 14:30 - 21:00
}


def load_m1(paths):
    bars = []
    for p in sorted(paths):
        with open(p) as f:
            for line in f:
                line = line.strip()
                if not line:
                    continue
                parts = line.split(';')
                if len(parts) < 5:
                    continue
                ts = parts[0]
                o, h, l, c = float(parts[1]), float(parts[2]), float(parts[3]), float(parts[4])
                d = ts[0:8]
                hh = int(ts[9:11])
                mm = int(ts[11:13])
                bars.append((d, hh, mm, o, h, l, c))
    return bars


def aggregate(bars, minutes):
    out = []
    cur = None
    for (d, hh, mm, o, h, l, c) in bars:
        slot = (d, hh, (mm // minutes) * minutes)
        if cur is None or cur[0] != slot:
            if cur is not None:
                out.append(cur[1])
            cur = (slot, [slot[0], slot[1], slot[2], o, h, l, c])
        else:
            b = cur[1]
            if h > b[4]:
                b[4] = h
            if l < b[5]:
                b[5] = l
            b[6] = c
    if cur is not None:
        out.append(cur[1])
    return out


def collaudo_orologio(bars, sym):
    """Minuto del giorno a piu' alta |variazione| media M1: deve ritrovare
    l'apertura cash. E' il CONTRO-ESEMPIO dell'orologio (lezione del 10/09)."""
    acc = {}
    for (d, hh, mm, o, h, l, c) in bars:
        k = (hh, mm)
        a = acc.setdefault(k, [0.0, 0])
        a[0] += abs(c - o)
        a[1] += 1
    tab = sorted(((v[0] / v[1], k) for k, v in acc.items() if v[1] > 200), reverse=True)
    print(f"  {sym}: i 3 minuti file piu' mossi = " +
          " | ".join(f"{k[0]:02d}:{k[1]:02d} ({m:.2f})" for m, k in tab[:3]))


def in_sessione(b, sym):
    lo, hi = SESSIONE_FILE[sym]
    t = b[1] + b[2] / 60.0
    return lo <= t < hi


ALLIN = os.environ.get('ALLIN', '0') == '1'


def pattern_in_sessione(b, i, N, sym):
    """Con ALLIN=1 pretende che TUTTE le barre del pattern (madre inclusa) stiano
    nella sessione cash: e' il contro-esempio contro i pattern che cominciano
    nella notte e finiscono all'apertura."""
    if not ALLIN:
        return True
    return all(in_sessione(b[j], sym) for j in range(i - N, i + 1))


def setup_long(b, i, N):
    """True se la sequenza LONG e' completa alla barra i (ingresso al close di i)."""
    m = i - N
    if b[m][6] >= b[m][3]:          # la madre deve essere bearish
        return False
    lowm = b[m][5]
    for k in range(1, N + 1):
        j = m + k
        if b[j][6] <= b[j][3]:      # ogni barra seguente bullish
            return False
        if b[j][5] <= lowm:         # nessuna viola il minimo della madre
            return False
        if k > 1 and b[j][6] <= b[j - 1][6]:   # chiusure strettamente crescenti
            return False
    return True


def setup_short(b, i, N):
    m = i - N
    if b[m][6] <= b[m][3]:
        return False
    highm = b[m][4]
    for k in range(1, N + 1):
        j = m + k
        if b[j][6] >= b[j][3]:
            return False
        if b[j][4] >= highm:
            return False
        if k > 1 and b[j][6] >= b[j - 1][6]:
            return False
    return True


def esito(b, i, entry, R, side, RR, maxbars):
    """1 = TP prima di SL, 0 = SL, -1 = non deciso entro maxbars.
    Ambiguita' intrabarra SEMPRE a sfavore: lo SL si controlla PRIMA del TP."""
    if R <= 0:
        return -1
    sl = R
    tp = RR * R
    for j in range(i + 1, min(i + 1 + maxbars, len(b))):
        h, l = b[j][4], b[j][5]
        if side == 'L':
            if l <= entry - sl:
                return 0
            if h >= entry + tp:
                return 1
        else:
            if h >= entry + sl:
                return 0
            if l <= entry - tp:
                return 1
    return -1


def main():
    RR = float(os.environ.get('RR', '1.5'))
    print("SONDA SEQUENZA -- candela madre + N candele monotone contrarie")
    print(f"RR = {RR}  |  ambiguita' intrabarra A SFAVORE  |  zero costi dentro la sonda")
    print("Il costo si aggiunge DOPO, in R, con gli spread misurati di casa.\n")

    for sym in ('GRXEUR', 'SPXUSD'):
        files = sorted(glob.glob(f"{S}/dati/{sym}_*.csv"))
        if not files:
            print(f"{sym}: NESSUN DATO")
            continue
        bars = load_m1(files)
        anni = ", ".join(os.path.basename(f).split('_')[1].split('.')[0] for f in files)
        print(f"=== {sym}  ({len(bars)} barre M1, anni {anni}) ===")
        if '--clock' in sys.argv:
            collaudo_orologio(bars, sym)

        mb30 = int(os.environ.get('MB30', '16'))
        mb60 = int(os.environ.get('MB60', '8'))
        for tf, maxbars in ((30, mb30), (60, mb60)):
            b = aggregate(bars, tf)
            giorni = len(set(x[0] for x in b if in_sessione(x, sym)))
            for N in (2, 3, 4, 5):
                for side in ('L', 'S'):
                    sig = []
                    for i in range(N + 1, len(b) - 1):
                        if not in_sessione(b[i], sym):
                            continue
                        if not pattern_in_sessione(b, i, N, sym):
                            continue
                        ok = setup_long(b, i, N) if side == 'L' else setup_short(b, i, N)
                        if not ok:
                            continue
                        entry = b[i][6]
                        m = i - N
                        R = (entry - b[m][5]) if side == 'L' else (b[m][4] - entry)
                        if R <= 0:
                            continue
                        sig.append((i, entry, R))
                    if not sig:
                        print(f"  M{tf} N={N} {side}: nessun segnale")
                        continue
                    Rs = [x[2] for x in sig]
                    E = [esito(b, i, e, R, side, RR, maxbars) for (i, e, R) in sig]
                    # CONTROLLO APPAIATO: stessa barra, stessa R, LATO OPPOSTO
                    opp = 'S' if side == 'L' else 'L'
                    Ec = [esito(b, i, e, R, opp, RR, maxbars) for (i, e, R) in sig]
                    w = sum(1 for x in E if x == 1)
                    lo = sum(1 for x in E if x == 0)
                    nd = sum(1 for x in E if x == -1)
                    wc = sum(1 for x in Ec if x == 1)
                    lc = sum(1 for x in Ec if x == 0)
                    wr = w / (w + lo) if w + lo else 0.0
                    wrc = wc / (wc + lc) if wc + lc else 0.0
                    R1 = median(Rs)
                    cost = SPREAD[sym] / R1 if R1 > 0 else 0.0
                    # E in R sulle sole operazioni DECISE, e poi netta del costo
                    Eg = wr * RR - (1 - wr) * 1.0
                    Ec_ = wrc * RR - (1 - wrc) * 1.0
                    freq = len(sig) / giorni if giorni else 0.0
                    print(f"  M{tf} N={N} {side}: n={len(sig):5d} ({freq:.3f}/gg) "
                          f"1R_med={R1:7.2f} pti costo={cost:.4f}R | "
                          f"TP={w:4d} SL={lo:4d} aperti={nd:4d} WR={wr*100:5.1f}% "
                          f"(appaiato {wrc*100:5.1f}%) | E={Eg:+.4f}R "
                          f"netta={Eg - cost:+.4f}R  (appaiata {Ec_:+.4f}R)")
            print(f"  -- M{tf}: {giorni} giorni di sessione, maxbars={maxbars}")
        print()


if __name__ == '__main__':
    main()
