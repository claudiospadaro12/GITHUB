#!/usr/bin/env python3
# =====================================================================
#  MARCATORE_ANATOMIA_ESPLOSIONI_ORO_v1
#  anatomia_esplosioni_oro.py
#  CHE COSA DISTINGUE LE ORE ESPLOSIVE DELL'ORO DA TUTTE LE ALTRE ORE
# ---------------------------------------------------------------------
#  PERCHE' ESISTE (richiesta di Claudio, 22/09/2026, testuale)
#    "Vorrei che un agente analizzasse questi screen dove l'oro corre e
#     fa questi punti, che cosa c'e' in comune, xche avviene, se c'e'
#     un orario comune durante il giorno, se c'e' ATR simile, volumi
#     simili che possano ricondurre a una esplosione di prezzo cosi'.
#     Come si puo' misurare, dobbiamo misurare anche il lato short."
#
#  ###################################################################
#  #  LA TRAPPOLA, DICHIARATA PRIMA DI TUTTO:                        #
#  #  le tre schermate sono state scelte PERCHE' esplosive. E'       #
#  #  SELEZIONE SULL'ESITO. Qualunque cosa abbiano "in comune" la si #
#  #  trova per costruzione. Quindi questo strumento NON guarda le   #
#  #  tre schermate: misura la POPOLAZIONE INTERA e chiede che cosa  #
#  #  DISTINGUE le ore esplosive dalle altre. Le tre schermate       #
#  #  entrano SOLO alla fine, come percentile.                       #
#  ###################################################################
#
#  ###################################################################
#  #  QUELLO CHE QUESTO STRUMENTO **NON** FA:                        #
#  #  NON e' un backtest. NON calcola PF, NON calcola equity, NON    #
#  #  simula uscite, NON promuove niente, NON tocca MT5, non scrive  #
#  #  preset, non sfiora il forward. Legge barre M1 e CONTA.         #
#  ###################################################################
#
#  ==================================================================
#  LA DEFINIZIONE DI "ESPLOSIONE", CONGELATA PRIMA DI VEDERE I NUMERI
#  ==================================================================
#  GRIGLIA BASE   blocchi da 15 minuti allineati all'orologio UTC
#                 (:00 :15 :30 :45). Un blocco base e' VALIDO se
#                 contiene almeno 12 dei 15 minuti.
#  FINESTRA       N = 30 minuti = DUE blocchi base consecutivi
#                 allineati a :00 e :30. NON si sovrappongono: il
#                 denominatore della tavola oraria e' cosi' un
#                 conteggio esatto di finestre, non una stima.
#                 PERCHE' 30: le schermate di Claudio mostrano corse
#                 verticali "in meno di un'ora"; 30 minuti e' la
#                 finestra piu' stretta che le contiene tutte e tre e
#                 che si assegna a un'ora senza ambiguita'.
#                 VARIANTE DICHIARATA: N = 60 (quattro blocchi base),
#                 calcolata sempre, mai al posto della principale.
#  MOVIMENTO      close(ultimo minuto) - open(primo minuto) della
#                 finestra. Nessun prezzo migliore, mai.
#  METRO          ATR14 GIORNALIERO: media dei true range dei 14
#                 giorni di contrattazione PRECEDENTI (gap incluso),
#                 noto alla chiusura del giorno prima. NESSUNA barra
#                 futura entra nel metro.
#                 PERCHE' GIORNALIERO E NON "DELLA STESSA ORA":
#                 normalizzare sull'ATR della stessa ora CANCELLA per
#                 costruzione l'effetto che stiamo cercando (un'ora
#                 sempre agitata alzerebbe da se' la propria
#                 asticella). L'ATR giornaliero normalizza le EPOCHE
#                 (oro a 600 $ contro oro a 4.300 $) e lascia intatta
#                 la stagionalita' oraria, che e' la domanda.
#  ESPLOSIONE     |movimento| >= k * ATR14_giornaliero,  k = 0,40.
#                 PERCHE' k = 0,40, e il motivo NON viene dalle
#                 schermate: "in mezz'ora fa quasi meta' di quello che
#                 un giorno intero fa normalmente". E' un principio
#                 leggibile e indipendente dall'esito.
#                 SENSIBILITA' DICHIARATA: k = 0,25 e k = 0,60,
#                 calcolate sempre; se la classifica oraria cambia, si
#                 dice.
#  LATO           segno del movimento: RIALZO e RIBASSO contati
#                 SEPARATAMENTE (regola di casa del 25/08).
#  ISTANTE DI     la FINE della finestra. Un'esplosione non e'
#  RICONOSCIMENTO riconoscibile prima: il suo inizio lo si sa solo col
#                 senno di poi. Tutti i movimenti successivi partono
#                 dal close di quell'istante.
#  ORA            ora UTC di INIZIO della finestra. Il file e' in UTC:
#                 e' COLLAUDATO qui sotto, non assunto.
#
#  ==================================================================
#  IL COSTO -- come viene applicato, dichiarato prima
#  ==================================================================
#  Costo pieno di un giro completo sull'oro BCM, MISURATO il 10/09/2026
#  (report/ORO_1530_CANCELLO_COSTO_2026-09-10.md): 0,2003 $/oncia
#  = spread 0,1600 + commissione 0,0403. Letto a oro ~4.300-4.535 $.
#  Il campione storico e' a oro 600-2.000 $: applicare 0,2003 $ PIATTI
#  ai dollari del 2010 sarebbe un pedaggio finto. Quindi il costo si
#  applica in RELATIVO: 0,2003 / 4.400 = 0,004552% del prezzo, e i
#  risultati si riportano anche in dollari di OGGI (oro 4.330 $).
#  La versione a dollari piatti e' stampata come sensibilita'.
# =====================================================================

import argparse
import csv
import os
import random
import sys
from datetime import date, datetime, timedelta

VERSIONE = "MARCATORE_ANATOMIA_ESPLOSIONI_ORO_v1"

MIN_MINUTI_BLOCCO = 12          # su 15
K_PRINCIPALE = 0.40
K_SENSIBILITA = (0.25, 0.40, 0.60)
ATR_GIORNI = 14
ANNO_CASSAFORTE = 2016

COSTO_ORO_DOLLARI = 0.2003      # giro completo, MISURATO 10/09/2026
PREZZO_ORO_MISURA = 4400.0      # oro all'epoca della misura di costo
PREZZO_ORO_OGGI = 4330.0        # schermate di Claudio, 22/09/2026
COSTO_RELATIVO = COSTO_ORO_DOLLARI / PREZZO_ORO_MISURA

# finestra di esclusione attorno a un evento di calendario, in minuti
NEWS_PRIMA, NEWS_DOPO = 5, 30

EPOCA = datetime(2000, 1, 1)


def log(m):
    print(m, flush=True)


def em(t):
    """minuti dall'epoca"""
    return int((t - EPOCA).total_seconds()) // 60


# ---------------------------------------------------------------------
#  LETTURA -- formato oanda: time,close,high,low,open,volume  (C,H,L,O!)
# ---------------------------------------------------------------------
def leggi_tutto(cartella, contatori):
    files = sorted(n for n in os.listdir(cartella) if n.lower().endswith(".csv"))
    for nome in files:
        p = os.path.join(cartella, nome)
        with open(p, "r", encoding="ascii", errors="replace") as f:
            prima = f.readline()
            if not prima.strip().lower().startswith("time,close,high,low,open"):
                contatori["file_formato_ignoto"] += 1
                continue
            for riga in f:
                p2 = riga.split(",")
                if len(p2) < 5:
                    contatori["righe_scartate"] += 1
                    continue
                try:
                    s = p2[0]
                    t = datetime(int(s[0:4]), int(s[5:7]), int(s[8:10]),
                                 int(s[11:13]), int(s[14:16]))
                    c, h, l, o = float(p2[1]), float(p2[2]), float(p2[3]), float(p2[4])
                    v = float(p2[5]) if len(p2) > 5 and p2[5].strip() != "" else 0.0
                except (ValueError, IndexError):
                    contatori["righe_scartate"] += 1
                    continue
                if o <= 0 or h <= 0 or l <= 0 or c <= 0 or h < l:
                    contatori["righe_scartate"] += 1
                    continue
                if h < o or h < c or l > o or l > c:
                    contatori["ohlc_incoerenti"] += 1
                    continue
                contatori["barre"] += 1
                yield (t, o, h, l, c, v)


# ---------------------------------------------------------------------
#  COLLAUDO DELL'OROLOGIO -- il file e' in UTC? si misura, non si assume.
#  Metodo del 10/09: il minuto del giorno con |close-open| media piu'
#  alta, mesi invernali contro mesi estivi. Il dato USA delle 8:30 di
#  New York cade alle 13:30 UTC d'inverno e alle 12:30 UTC d'estate:
#  se lo spostamento e' -60 minuti, il file e' in UTC.
# ---------------------------------------------------------------------
def collauda_orologio(inv, est):
    """Il minuto del giorno piu' mosso, mesi invernali (12-1-2) contro
    mesi estivi (6-7-8), su TUTTO il campione. Si usa la MEDIANA di
    |close-open| e non la media: un solo giorno di gap (la riapertura
    della domenica sera) sposta una media e NON sposta una mediana. La
    scelta e' di robustezza, non un'esclusione a mano di minuti scomodi.
    Serve n >= 200 osservazioni per minuto."""
    def cima(d, quanti=5):
        v = [(mediana(x), m, len(x)) for m, x in d.items() if len(x) >= 200]
        v.sort(reverse=True)
        return v[:quanti]
    ci, ce = cima(inv), cima(est)
    if not ci or not ce:
        return False, 0, [ci, ce]
    spost = ce[0][1] - ci[0][1]
    return (-62 <= spost <= -58), spost, [ci, ce]


# ---------------------------------------------------------------------
#  CALENDARIO NOTIZIE
# ---------------------------------------------------------------------
def carica_news(percorsi):
    ev = set()
    per_anno = {}
    for p in percorsi:
        if not os.path.exists(p):
            continue
        with open(p, "r", encoding="utf-8", errors="replace") as f:
            r = csv.reader(f, delimiter=";")
            next(r, None)
            for rg in r:
                if len(rg) < 3:
                    continue
                try:
                    s = rg[0].strip()
                    t = datetime(int(s[0:4]), int(s[5:7]), int(s[8:10]),
                                 int(s[11:13]), int(s[14:16]))
                except (ValueError, IndexError):
                    continue
                if rg[1].strip().lower() != "high":
                    continue
                ev.add(t)
                per_anno[t.year] = per_anno.get(t.year, 0) + 1
    minuti = set()
    for t in ev:
        b = em(t)
        for d in range(-NEWS_PRIMA, NEWS_DOPO + 1):
            minuti.add(b + d)
    return ev, minuti, per_anno


# ---------------------------------------------------------------------
#  STATISTICA di servizio
# ---------------------------------------------------------------------
def mediana(v):
    if not v:
        return float("nan")
    s = sorted(v)
    n = len(s)
    return s[n // 2] if n % 2 else 0.5 * (s[n // 2 - 1] + s[n // 2])


def quantile(v, q):
    if not v:
        return float("nan")
    s = sorted(v)
    i = int(q * (len(s) - 1))
    return s[i]


def se_binom(k, n):
    if n <= 0:
        return float("nan")
    p = k / n
    return (p * (1 - p) / n) ** 0.5


def percentile_di(v_ordinato, x):
    """frazione di valori <= x, su una lista GIA' ordinata"""
    lo, hi = 0, len(v_ordinato)
    while lo < hi:
        mid = (lo + hi) // 2
        if v_ordinato[mid] <= x:
            lo = mid + 1
        else:
            hi = mid
    return lo / len(v_ordinato) if v_ordinato else float("nan")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dati", required=True)
    ap.add_argument("--news", default="")
    ap.add_argument("--seme", type=int, default=20260922)
    ap.add_argument("--fuori", default="")
    a = ap.parse_args()

    uscita = open(a.fuori, "w", encoding="utf-8") if a.fuori else None

    def out(m):
        log(m)
        if uscita:
            uscita.write(m + "\n")

    out("=" * 70)
    out(VERSIONE)
    out("=" * 70)

    cont = {"barre": 0, "righe_scartate": 0, "ohlc_incoerenti": 0,
            "file_formato_ignoto": 0}

    # -----------------------------------------------------------------
    # PASSO 1 -- lettura, blocchi base da 15', giorni, collaudo orologio
    # -----------------------------------------------------------------
    blocchi = {}          # indice blocco 15' -> [o,h,l,c,vol,n]
    giorni = {}           # date -> [h, l, c_ultimo, n]
    inv, est = {}, {}     # collaudo orologio (liste di |close-open| per minuto)

    for (t, o, h, l, c, v) in leggi_tutto(a.dati, cont):
        m = em(t)
        b = m // 15
        r = blocchi.get(b)
        if r is None:
            blocchi[b] = [o, h, l, c, v, 1]
        else:
            if h > r[1]:
                r[1] = h
            if l < r[2]:
                r[2] = l
            r[3] = c
            r[4] += v
            r[5] += 1
        d = t.date()
        g = giorni.get(d)
        if g is None:
            giorni[d] = [h, l, c, 1]
        else:
            if h > g[0]:
                g[0] = h
            if l < g[1]:
                g[1] = l
            g[2] = c
            g[3] += 1
        if t.month in (12, 1, 2):
            inv.setdefault(t.hour * 60 + t.minute, []).append(abs(c - o))
        elif t.month in (6, 7, 8):
            est.setdefault(t.hour * 60 + t.minute, []).append(abs(c - o))

    out("")
    out("LETTURA: barre M1 = %d | righe scartate = %d | OHLC incoerenti = %d"
        % (cont["barre"], cont["righe_scartate"], cont["ohlc_incoerenti"]))
    out("         blocchi base 15' = %d | giornate = %d" % (len(blocchi), len(giorni)))
    out("")
    ok, spost, picchi = collauda_orologio(inv, est)
    out("  COLLAUDO OROLOGIO -- minuto piu' mosso, MEDIANA di |close-open|, n>=200")
    if not picchi[0] or not picchi[1]:
        out("  NON MISURABILE: servono mesi invernali E estivi con n>=200. Ci si FERMA.")
        sys.exit(2)
    for eti, c in (("inverno (12-1-2)", picchi[0]), ("estate  (6-7-8)", picchi[1])):
        out("    %-17s %s" % (eti, "  ".join(
            "%02d:%02d (%.4f n=%d)" % (m // 60, m % 60, v, n) for v, m, n in c)))
    out("    spostamento estate-inverno = %+d minuti" % spost)
    if not ok:
        out("  FALLITO: spostamento %+d invece di -60. Il file NON e' in UTC." % spost)
        sys.exit(2)
    out("  ESITO: PASSATO -- il file e' in UTC. Tutte le ore sotto sono UTC.")
    inv.clear(); est.clear()

    # -----------------------------------------------------------------
    # PASSO 2 -- ATR14 giornaliero, noto alla fine del giorno PRIMA
    # -----------------------------------------------------------------
    date_ord = sorted(d for d, g in giorni.items() if g[3] >= 300)  # >=5h di barre
    tr = {}
    prec_c = None
    for d in date_ord:
        g = giorni[d]
        if prec_c is None:
            tr[d] = g[0] - g[1]
        else:
            tr[d] = max(g[0] - g[1], abs(g[0] - prec_c), abs(g[1] - prec_c))
        prec_c = g[2]
    atr = {}
    for i, d in enumerate(date_ord):
        if i < ATR_GIORNI:
            continue
        fin = [tr[date_ord[j]] for j in range(i - ATR_GIORNI, i)]
        atr[d] = sum(fin) / ATR_GIORNI
    out("")
    out("ATR14 GIORNALIERO: giornate con metro valido = %d (su %d complete)"
        % (len(atr), len(date_ord)))
    a_med = mediana(list(atr.values()))
    out("         ATR14 mediano sul campione = %.3f $" % a_med)

    # -----------------------------------------------------------------
    # PASSO 3 -- finestre da 30' (:00 e :30) e da 60' (:00)
    # -----------------------------------------------------------------
    def costruisci(nmin):
        """nmin = 30 o 60. Restituisce lista di finestre valide."""
        passo = nmin // 15
        fin = []
        for b in sorted(blocchi):
            if (b % passo) != 0:
                continue
            pezzi = [blocchi.get(b + i) for i in range(passo)]
            if any(p is None or p[5] < MIN_MINUTI_BLOCCO for p in pezzi):
                continue
            t0 = EPOCA + timedelta(minutes=b * 15)
            d = t0.date()
            if d not in atr:
                continue
            o = pezzi[0][0]
            c = pezzi[-1][3]
            hi = max(p[1] for p in pezzi)
            lo = min(p[2] for p in pezzi)
            vol = sum(p[4] for p in pezzi)
            fin.append({"b": b, "t": t0, "d": d, "o": o, "c": c, "h": hi, "l": lo,
                        "vol": vol, "mov": c - o, "rng": hi - lo,
                        "atr": atr[d], "ora": t0.hour, "anno": t0.year})
        return fin

    f30 = costruisci(30)
    f60 = costruisci(60)
    out("")
    out("FINESTRE VALIDE: N=30' -> %d   N=60' -> %d" % (len(f30), len(f60)))
    out("         (denominatore reale: e' su QUESTE che si calcola ogni tasso)")

    # -----------------------------------------------------------------
    # PASSO 4 -- notizie
    # -----------------------------------------------------------------
    perc_news = [p for p in a.news.split(",") if p.strip()]
    ev, min_news, news_anno = carica_news(perc_news)
    out("")
    if ev:
        anni = sorted(news_anno)
        out("CALENDARIO NOTIZIE ad alto impatto: %d eventi distinti, %d-%d"
            % (len(ev), anni[0], anni[-1]))
        out("         finestra di esclusione: da -%d a +%d minuti attorno all'evento"
            % (NEWS_PRIMA, NEWS_DOPO))
        out("         eventi per anno: " + " ".join("%d:%d" % (y, news_anno[y])
                                                     for y in anni))
    else:
        out("CALENDARIO NOTIZIE: NESSUNO CARICATO")

    def tocca_news(f, nmin):
        b0 = f["b"] * 15
        for m in range(b0, b0 + nmin):
            if m in min_news:
                return True
        return False

    for f in f30:
        f["news"] = tocca_news(f, 30)
    for f in f60:
        f["news"] = tocca_news(f, 60)

    # -----------------------------------------------------------------
    # PASSO 5 -- LA TAVOLA ORARIA, sui due lati separati
    # -----------------------------------------------------------------
    def tavola(fin, k, titolo, filtro=None, nmin=30):
        sel = [f for f in fin if (filtro is None or filtro(f))]
        tot = len(sel)
        if tot == 0:
            out("  (nessuna finestra)")
            return {}
        n_ora, su_ora, giu_ora = {}, {}, {}
        rng_ora, vol_ora = {}, {}
        rng_esp, vol_esp = {}, {}
        for f in sel:
            o = f["ora"]
            n_ora[o] = n_ora.get(o, 0) + 1
            rng_ora.setdefault(o, []).append(f["rng"])
            vol_ora.setdefault(o, []).append(f["vol"])
            s = 1 if f["mov"] >= k * f["atr"] else (-1 if f["mov"] <= -k * f["atr"] else 0)
            if s > 0:
                su_ora[o] = su_ora.get(o, 0) + 1
            elif s < 0:
                giu_ora[o] = giu_ora.get(o, 0) + 1
            if s != 0:
                rng_esp.setdefault(o, []).append(f["rng"])
                vol_esp.setdefault(o, []).append(f["vol"])
        tot_esp = sum(su_ora.values()) + sum(giu_ora.values())
        tasso_medio = tot_esp / tot
        out("")
        out(titolo)
        out("  finestre N=%d' totali = %d | esplosioni = %d | TASSO MEDIO = %.3f%%"
            % (nmin, tot, tot_esp, 100 * tasso_medio))
        out("  ora  |  finestre |  RIALZO        |  RIBASSO       |  TOT   | x medio | range med | tickvol med | rng ESP | vol ESP")
        out("  " + "-" * 116)
        ris = {}
        for o in range(24):
            n = n_ora.get(o, 0)
            if n == 0:
                continue
            su, giu = su_ora.get(o, 0), giu_ora.get(o, 0)
            tt = su + giu
            p = tt / n
            ris[o] = (n, su, giu, p)
            out("   %02d  | %9d | %5d (%5.2f%%) | %5d (%5.2f%%) | %5d | %6.2fx | %9.3f | %11.0f | %7.3f | %7.0f"
                % (o, n, su, 100 * su / n, giu, 100 * giu / n, tt,
                   p / tasso_medio if tasso_medio > 0 else 0,
                   mediana(rng_ora.get(o, [])), mediana(vol_ora.get(o, [])),
                   mediana(rng_esp.get(o, [])) if rng_esp.get(o) else float("nan"),
                   mediana(vol_esp.get(o, [])) if vol_esp.get(o) else float("nan")))
        return ris

    out("")
    out("=" * 70)
    out("5. LA TAVOLA ORARIA -- ora UTC di inizio finestra, due lati separati")
    out("=" * 70)
    r_tutto = tavola(f30, K_PRINCIPALE,
                     ">>> A. TUTTE LE FINESTRE, tutto il campione, k=0,40, N=30'")

    out("")
    out(">>> B. SENSIBILITA' SU k -- la classifica oraria regge?")
    for k in K_SENSIBILITA:
        if k == K_PRINCIPALE:
            continue
        r = tavola(f30, k, ">>> k = %.2f" % k)
        comune = sorted(set(r_tutto) & set(r))
        cl_p = sorted(comune, key=lambda o: -r_tutto[o][3])[:5]
        cl_k = sorted(comune, key=lambda o: -r[o][3])[:5]
        out("  TOP-5 ore   k=0,40: %s" % " ".join("%02d" % o for o in cl_p))
        out("  TOP-5 ore   k=%.2f: %s" % (k, " ".join("%02d" % o for o in cl_k)))
        out("  ore in comune nella TOP-5: %d su 5" % len(set(cl_p) & set(cl_k)))

    out("")
    r60 = tavola(f60, K_PRINCIPALE, ">>> C. VARIANTE N=60', k=0,40", nmin=60)
    cl_p = sorted(r_tutto, key=lambda o: -r_tutto[o][3])[:5]
    cl_6 = sorted(r60, key=lambda o: -r60[o][3])[:5]
    out("  TOP-5 ore  N=30': %s" % " ".join("%02d" % o for o in cl_p))
    out("  TOP-5 ore  N=60': %s" % " ".join("%02d" % o for o in cl_6))
    out("  in comune: %d su 5" % len(set(cl_p) & set(cl_6)))

    # -----------------------------------------------------------------
    # PASSO 6 -- IL CONFONDENTE: LE NOTIZIE
    # -----------------------------------------------------------------
    out("")
    out("=" * 70)
    out("6. IL CONFONDENTE DA UCCIDERE PER PRIMO: LE NOTIZIE")
    out("=" * 70)
    anni_news = sorted(news_anno) if news_anno else []
    if anni_news:
        y0, y1 = anni_news[0], anni_news[-1]
        campo = lambda f: y0 <= f["anno"] <= y1
        out("  Confronto ristretto agli anni coperti dal calendario: %d-%d" % (y0, y1))
        r_con = tavola(f30, K_PRINCIPALE,
                       ">>> D. anni %d-%d, TUTTE le finestre (news comprese)" % (y0, y1),
                       filtro=campo)
        r_senza = tavola(f30, K_PRINCIPALE,
                         ">>> E. anni %d-%d, ESCLUSE le finestre di notizia" % (y0, y1),
                         filtro=lambda f: campo(f) and not f["news"])
        out("")
        out("  >>> EFFETTO DELL'ESCLUSIONE, ora per ora")
        out("  ora | tasso CON news | tasso SENZA news | variazione | n escluse")
        out("  " + "-" * 70)
        for o in range(24):
            if o not in r_con or o not in r_senza:
                continue
            nc, _, _, pc = r_con[o]
            ns, _, _, ps = r_senza[o]
            out("   %02d | %13.3f%% | %15.3f%% | %+9.3f pt | %9d"
                % (o, 100 * pc, 100 * ps, 100 * (ps - pc), nc - ns))
        med_c = sum(r_con[o][1] + r_con[o][2] for o in r_con) / sum(r_con[o][0] for o in r_con)
        med_s = sum(r_senza[o][1] + r_senza[o][2] for o in r_senza) / sum(r_senza[o][0] for o in r_senza)
        out("  TASSO MEDIO   con news %.3f%%   senza news %.3f%%" % (100 * med_c, 100 * med_s))
        out("")
        out("  >>> RAPPORTO all'ora media (x medio): se l'ora sopravvive, il x resta alto")
        out("  ora |  x medio CON news |  x medio SENZA news")
        for o in sorted(r_con, key=lambda o: -r_con[o][3])[:8]:
            if o not in r_senza:
                continue
            out("   %02d | %16.2fx | %18.2fx"
                % (o, r_con[o][3] / med_c, r_senza[o][3] / med_s))

    # -----------------------------------------------------------------
    # PASSO 7 -- SFRUTTABILITA'
    # -----------------------------------------------------------------
    out("")
    out("=" * 70)
    out("7. SFRUTTABILITA' -- dall'ISTANTE DI RICONOSCIMENTO in avanti")
    out("=" * 70)
    out("  Riferimento: close alla FINE della finestra. Orizzonti +15 +30 +60 min.")
    out("  Il segno e' preso NEL VERSO dell'esplosione (continuazione > 0).")
    out("  Costo relativo applicato: %.6f%% del prezzo (= %.4f $ su oro %.0f $)"
        % (100 * COSTO_RELATIVO, COSTO_ORO_DOLLARI, PREZZO_ORO_MISURA))

    def avanti(f, nblocchi):
        """estremi e chiusura nei prossimi nblocchi blocchi base da 15'"""
        b_fine = f["b"] + (f["nb"])
        pezzi = [blocchi.get(b_fine + i) for i in range(nblocchi)]
        if any(p is None or p[5] < MIN_MINUTI_BLOCCO for p in pezzi):
            return None
        return (max(p[1] for p in pezzi), min(p[2] for p in pezzi), pezzi[-1][3])

    for f in f30:
        f["nb"] = 2
    for f in f60:
        f["nb"] = 4

    def sfrutta(fin, k, titolo, filtro=None):
        sel = [f for f in fin if (filtro is None or filtro(f))]
        esp = []
        non = {}
        for f in sel:
            s = 1 if f["mov"] >= k * f["atr"] else (-1 if f["mov"] <= -k * f["atr"] else 0)
            if s != 0:
                f["lato"] = s
                esp.append(f)
            else:
                non.setdefault((f["ora"], f["anno"]), []).append(f)
        out("")
        out(titolo)
        out("  esplosioni = %d" % len(esp))
        if not esp:
            return
        rng = random.Random(a.seme)
        controlli = []
        for f in esp:
            pool = non.get((f["ora"], f["anno"]))
            if not pool:
                continue
            g = rng.choice(pool)
            if g["mov"] == 0:
                continue
            g2 = dict(g)
            g2["lato"] = 1 if g["mov"] > 0 else -1
            controlli.append(g2)
        out("  controlli appaiati (stessa ORA, stesso ANNO, NON esplosivi) = %d"
            % len(controlli))

        for eti, gruppo in (("ESPLOSIONI", esp), ("CONTROLLO", controlli)):
            out("  --- %s" % eti)
            out("     orizz | n     | cont. MEDIANA | >0     | cont. LORDA $oggi | NETTA $oggi | MFE med | MAE med")
            for orizz, nb in ((15, 1), (30, 2), (60, 4)):
                cont_rel, mfe_rel, mae_rel = [], [], []
                for f in gruppo:
                    r = avanti(f, nb)
                    if r is None:
                        continue
                    hi, lo, cc = r
                    p0 = f["c"]
                    d = f["lato"] * (cc - p0) / p0
                    cont_rel.append(d)
                    if f["lato"] > 0:
                        mfe_rel.append((hi - p0) / p0)
                        mae_rel.append((p0 - lo) / p0)
                    else:
                        mfe_rel.append((p0 - lo) / p0)
                        mae_rel.append((hi - p0) / p0)
                if not cont_rel:
                    continue
                m = mediana(cont_rel)
                pos = sum(1 for x in cont_rel if x > 0) / len(cont_rel)
                out("     +%2d m | %5d | %+12.5f%% | %5.2f%% | %+16.3f | %+11.3f | %7.3f | %7.3f"
                    % (orizz, len(cont_rel), 100 * m, 100 * pos,
                       m * PREZZO_ORO_OGGI,
                       (m - COSTO_RELATIVO) * PREZZO_ORO_OGGI,
                       mediana(mfe_rel) * PREZZO_ORO_OGGI,
                       mediana(mae_rel) * PREZZO_ORO_OGGI))

    sfrutta(f30, K_PRINCIPALE, ">>> F. TUTTO IL CAMPIONE, N=30', k=0,40")
    sfrutta(f30, K_PRINCIPALE, ">>> G. IS 2006-2015",
            filtro=lambda f: f["anno"] < ANNO_CASSAFORTE)
    sfrutta(f30, K_PRINCIPALE, ">>> H. CASSAFORTE OOS 2016-2020",
            filtro=lambda f: f["anno"] >= ANNO_CASSAFORTE)
    if min_news:
        sfrutta(f30, K_PRINCIPALE, ">>> I. SOLO esplosioni SENZA notizia",
                filtro=lambda f: not f["news"])
        sfrutta(f30, K_PRINCIPALE, ">>> L. SOLO esplosioni SU notizia",
                filtro=lambda f: f["news"])

    # -----------------------------------------------------------------
    # PASSO 8 -- DOVE CADONO LE TRE SCHERMATE DI CLAUDIO
    # -----------------------------------------------------------------
    out("")
    out("=" * 70)
    out("8. DOVE CADONO LE TRE SCHERMATE -- alla fine, non all'inizio")
    out("=" * 70)
    for nome, fin, nmin in (("N=30'", f30, 30), ("N=60'", f60, 60)):
        movs = sorted(abs(f["mov"]) / f["o"] for f in fin)
        out("")
        out("  Distribuzione di |movimento| in %% del prezzo -- %s, n = %d" % (nome, len(movs)))
        for q in (0.50, 0.75, 0.90, 0.95, 0.99, 0.999, 0.9999):
            v = quantile(movs, q)
            out("    P%-7s %8.4f%%  =  %7.2f $ a oro %.0f $"
                % (("%.2f" % (100 * q)).rstrip("0").rstrip("."), 100 * v,
                   v * PREZZO_ORO_OGGI, PREZZO_ORO_OGGI))
        out("    MAX      %8.4f%%  =  %7.2f $ a oro %.0f $"
            % (100 * movs[-1], movs[-1] * PREZZO_ORO_OGGI, PREZZO_ORO_OGGI))
        giorni_tot = len(set(f["d"] for f in fin))
        for dollari in (35.0, 40.0):
            x = dollari / PREZZO_ORO_OGGI
            pc = percentile_di(movs, x)
            n_sopra = sum(1 for v in movs if v >= x)
            out("    >>> una corsa di %.0f $ a oro %.0f $ = %.4f%% -> percentile %.4f%% "
                "| sopra: %d finestre su %d | %.2f volte al mese (mesi = %.0f)"
                % (dollari, PREZZO_ORO_OGGI, 100 * x, 100 * pc, n_sopra, len(movs),
                   n_sopra / (giorni_tot / 21.0) if giorni_tot else 0,
                   giorni_tot / 21.0))


    out("")
    out("  >>> CONTRO-ESEMPIO alla domanda 'e' raro?': e se il 2026 fosse un")
    out("      regime CALDO? Stessa distribuzione, ma solo sul DECILE PIU' ALTO")
    out("      di ATR14 RELATIVO (ATR in %% del prezzo) -- il regime piu' agitato")
    out("      che il campione contenga.")
    rel = sorted(f["atr"] / f["o"] for f in f30)
    soglia_caldo = quantile(rel, 0.90)
    caldi = [f for f in f30 if f["atr"] / f["o"] >= soglia_caldo]
    movs_c = sorted(abs(f["mov"]) / f["o"] for f in caldi)
    out("      soglia ATR14 relativo del decile caldo = %.4f%% | finestre = %d"
        % (100 * soglia_caldo, len(caldi)))
    for dollari in (35.0, 40.0):
        x = dollari / PREZZO_ORO_OGGI
        pc = percentile_di(movs_c, x)
        n_sopra = sum(1 for v in movs_c if v >= x)
        gg = len(set(f["d"] for f in caldi))
        out("      %.0f $ (= %.4f%%) -> percentile %.4f%% nel regime CALDO | %d su %d | %.2f volte al mese"
            % (dollari, 100 * x, 100 * pc, n_sopra, len(movs_c),
               n_sopra / (gg / 21.0) if gg else 0))

    # quante di quelle corse sono "esplosioni" secondo la nostra definizione
    out("")
    out("  >>> E le corse da 35-40 $ (in %% di prezzo) sono ESPLOSIONI secondo k=0,40?")
    for dollari in (35.0, 40.0):
        x = dollari / PREZZO_ORO_OGGI
        sopra = [f for f in f30 if abs(f["mov"]) / f["o"] >= x]
        if not sopra:
            continue
        esp = sum(1 for f in sopra if abs(f["mov"]) >= K_PRINCIPALE * f["atr"])
        out("     %.0f $: %d finestre, di cui esplosioni per k=0,40: %d (%.1f%%)"
            % (dollari, len(sopra), esp, 100 * esp / len(sopra)))
        oree = {}
        for f in sopra:
            oree[f["ora"]] = oree.get(f["ora"], 0) + 1
        top = sorted(oree.items(), key=lambda kv: -kv[1])[:6]
        out("     ore UTC piu' frequenti: %s"
            % " ".join("%02d(%d)" % (o, n) for o, n in top))


    # -----------------------------------------------------------------
    # PASSO 8-bis -- IL CONTRO-ESEMPIO: e se fosse SOLO l'orologio della
    # volatilita'? Definizione E2: |mov| >= k * RANGE MEDIANO DELLA SUA
    # ORA (invece che dell'ATR giornaliero). Se sotto E2 NESSUNA ora
    # sporge piu', allora "l'ora esplosiva" non dice niente in piu' di
    # "a quell'ora l'oro si muove sempre di piu'".
    # -----------------------------------------------------------------
    out("")
    out("=" * 70)
    out("8-bis. CONTRO-ESEMPIO -- l'ipotesi ALTERNATIVA: e' solo l'orologio")
    out("       della volatilita'? (E2: soglia = k2 x range mediano DELLA SUA ORA)")
    out("=" * 70)
    rng_per_ora = {}
    for f in f30:
        rng_per_ora.setdefault(f["ora"], []).append(f["rng"])
    rng_per_ora = {o: mediana(v) for o, v in rng_per_ora.items()}
    # k2 scelto per dare LO STESSO tasso medio della definizione principale,
    # cosi' i due quadri sono confrontabili riga per riga.
    tasso_base = sum(1 for f in f30 if abs(f["mov"]) >= K_PRINCIPALE * f["atr"]) / len(f30)
    lo_k, hi_k = 0.1, 20.0
    for _ in range(60):
        mid = 0.5 * (lo_k + hi_k)
        t = sum(1 for f in f30 if abs(f["mov"]) >= mid * rng_per_ora[f["ora"]]) / len(f30)
        if t > tasso_base:
            lo_k = mid
        else:
            hi_k = mid
    k2 = 0.5 * (lo_k + hi_k)
    out("  k2 calibrato = %.4f  -> stesso tasso medio della principale (%.3f%%)"
        % (k2, 100 * tasso_base))
    n_ora2, su2, giu2 = {}, {}, {}
    for f in f30:
        o = f["ora"]
        n_ora2[o] = n_ora2.get(o, 0) + 1
        s2 = 1 if f["mov"] >= k2 * rng_per_ora[o] else (-1 if f["mov"] <= -k2 * rng_per_ora[o] else 0)
        if s2 > 0:
            su2[o] = su2.get(o, 0) + 1
        elif s2 < 0:
            giu2[o] = giu2.get(o, 0) + 1
    out("  ora | finestre | RIALZO | RIBASSO |  tasso | x medio  || tasso E1 (ATR giorn.) | x E1")
    out("  " + "-" * 88)
    r2 = {}
    for o in range(24):
        n = n_ora2.get(o, 0)
        if n == 0:
            continue
        tt = su2.get(o, 0) + giu2.get(o, 0)
        p = tt / n
        r2[o] = p
        p1 = r_tutto[o][3] if o in r_tutto else float("nan")
        tm = sum(r_tutto[x][1] + r_tutto[x][2] for x in r_tutto) / sum(r_tutto[x][0] for x in r_tutto)
        out("   %02d | %8d | %6d | %7d | %6.3f%% | %6.2fx || %20.3f%% | %5.2fx"
            % (o, n, su2.get(o, 0), giu2.get(o, 0), 100 * p, p / tasso_base,
               100 * p1, p1 / tm))
    disp1 = max(r_tutto[o][3] for o in r_tutto) / min(r_tutto[o][3] for o in r_tutto if r_tutto[o][3] > 0)
    disp2 = max(r2.values()) / min(v for v in r2.values() if v > 0)
    out("")
    out("  DISPERSIONE fra le ore (max/min):  E1 ATR-giornaliero = %.1fx   E2 ora-su-se-stessa = %.1fx"
        % (disp1, disp2))
    out("  Se E2 e' piatta (vicina a 1x) l'ora NON aggiunge niente all'orologio della volatilita'.")

    # -----------------------------------------------------------------
    # PASSO 9 -- ATR e VOLUME: esplosive contro tutte
    # -----------------------------------------------------------------
    out("")
    out("=" * 70)
    out("9. ATR E TICK VOLUME -- esplosive contro la popolazione")
    out("=" * 70)
    out("  ATTENZIONE: sul feed CFD/spot il 'volume' e' TICK VOLUME (conteggio")
    out("  aggiornamenti di prezzo), NON volume scambiato. Etichettato ovunque.")
    esp = [f for f in f30 if abs(f["mov"]) >= K_PRINCIPALE * f["atr"]]
    tut = f30
    out("")
    out("  grandezza                   | ESPLOSIVE  | TUTTE      | rapporto")
    for eti, key in (("ATR14 giorn. del giorno ($)", "atr"),
                     ("range della finestra ($)", "rng"),
                     ("TICK VOLUME della finestra", "vol")):
        a1, a2 = mediana([f[key] for f in esp]), mediana([f[key] for f in tut])
        out("  %-27s | %10.2f | %10.2f | %7.2fx" % (eti, a1, a2, a1 / a2 if a2 else 0))
    # ATR RELATIVO: l'ATR e' piu' alto perche' l'oro costa di piu'?
    a1 = mediana([f["atr"] / f["o"] for f in esp])
    a2 = mediana([f["atr"] / f["o"] for f in tut])
    out("  %-27s | %9.4f%% | %9.4f%% | %7.2fx"
        % ("ATR14 in % del prezzo", 100 * a1, 100 * a2, a1 / a2 if a2 else 0))
    # e il volume normalizzato alla mediana della SUA ora
    vmed = {}
    for f in tut:
        vmed.setdefault(f["ora"], []).append(f["vol"])
    vmed = {o: mediana(v) for o, v in vmed.items()}
    r1 = mediana([f["vol"] / vmed[f["ora"]] for f in esp if vmed.get(f["ora"])])
    r2 = mediana([f["vol"] / vmed[f["ora"]] for f in tut if vmed.get(f["ora"])])
    out("  %-27s | %10.2f | %10.2f | %7.2fx"
        % ("tick vol / mediana DELLA SUA ORA", r1, r2, r1 / r2 if r2 else 0))

    # -----------------------------------------------------------------
    # PASSO 10 -- il tasso di base per anno (e' un fenomeno stabile?)
    # -----------------------------------------------------------------
    out("")
    out("=" * 70)
    out("10. STABILITA' NEL TEMPO -- tasso di esplosione per anno")
    out("=" * 70)
    per_anno = {}
    for f in f30:
        d = per_anno.setdefault(f["anno"], [0, 0, 0])
        d[0] += 1
        if f["mov"] >= K_PRINCIPALE * f["atr"]:
            d[1] += 1
        elif f["mov"] <= -K_PRINCIPALE * f["atr"]:
            d[2] += 1
    out("  anno | finestre | RIALZO | RIBASSO | tasso")
    for y in sorted(per_anno):
        n, su, giu = per_anno[y]
        out("  %4d | %8d | %6d | %7d | %6.3f%%" % (y, n, su, giu, 100 * (su + giu) / n))

    if uscita:
        uscita.close()
    log("")
    log("FATTO.")


if __name__ == "__main__":
    main()
