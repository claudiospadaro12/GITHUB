#!/usr/bin/env python3
# =====================================================================
#  SONDA_FADE_ORO_v1
#  sonda_fade_oro.py
#  IL FADE DELLE ESPLOSIONI DELL'ORO SULLA FASCIA 09:30 ET:
#  PF NETTO E FORMA DELLA CODA, SU DUE CAMPIONI INDIPENDENTI
# ---------------------------------------------------------------------
#  PERCHE' ESISTE
#    report/ORO_2021_2026_LA_MISURA_2026-09-22.md ha misurato che
#    SEGUIRE l'esplosione delle 09:30 ET PERDE, su due campioni
#    indipendenti (2006-2020 Oanda, 2021-2026 HistData). Il verso
#    opposto -- il FADE -- ha mediana positiva in tutte e due le
#    finestre.
#    MA LA MEDIANA NON E' IL PF. Un fade puo' avere mediana positiva e
#    PF sotto 1, perche' ogni tanto l'esplosione CONTINUA e si riprende
#    in una volta quello che ha dato in venti. E' IL RISCHIO
#    STRUTTURALE DEL FADE SU UN BREAKOUT, ed e' la domanda di questo
#    strumento.
#
#  ###################################################################
#  #  QUELLO CHE QUESTO STRUMENTO **NON** FA:                        #
#  #  non tocca MT5, non scrive preset, non sfiora il forward, non    #
#  #  promuove nessuna sedia. Legge barre M1 e CONTA.                 #
#  ###################################################################
#
#  ==================================================================
#  LA DEFINIZIONE DI ESPLOSIONE **NON E' NUOVA**: e' IMPORTATA
#  ==================================================================
#  Le costanti e le funzioni pure vengono prese per IMPORT da
#  backtest_pipeline/anatomia_esplosioni_oro.py, che e' lo strumento
#  che ha prodotto i numeri che qui estendiamo. Niente copia-incolla
#  di una soglia: se quel file cambia, cambia anche questo.
#  Finestra 30', mov = close(ultimo) - open(primo), esplosione se
#  |mov| >= K_PRINCIPALE * ATR14_giornaliero, K = 0,40.
#  ANCORA OBBLIGATORIA, collaudata a ogni corsa: il conteggio delle
#  esplosioni sulla fascia 09:30 ET (minuto 570 di New York) deve dare
#  51 sul 2021-2026 e 111 sul 2006-2020. Se non torna, lo strumento
#  SI FERMA: vuol dire che la definizione NON coincide, e allora i
#  numeri non si confrontano con quelli vecchi.
#
#  ==================================================================
#  LA REGOLA DEL FADE, congelata prima dei numeri
#  ==================================================================
#  INGRESSO   al CLOSE della finestra di 30' (istante di
#             riconoscimento), CONTRO il verso del movimento:
#             mov > 0 -> si VENDE; mov < 0 -> si COMPRA.
#  USCITA     secca a orologio, a +15 / +30 / +60 minuti.
#  LIMITE DICHIARATO, e non e' un dettaglio: NESSUNO STOP e NESSUN
#             TARGET. Una sedia vera avrebbe uno stop, e lo stop
#             cambia la coda -- che e' proprio la cosa che misuriamo.
#             Quindi questi numeri sono il fade NUDO: la versione con
#             stop sara' DIVERSA, e va misurata a parte. Senza stop la
#             coda e' quella VERA del mercato, non quella tagliata da
#             una manopola: e' il numero giusto per decidere SE vale la
#             pena costruire una sedia, non COME costruirla.
#
#  ==================================================================
#  IL COSTO -- e qui c'e' una DISCREPANZA che va detta, non nascosta
#  ==================================================================
#  report/ORO_1530_CANCELLO_COSTO_2026-09-10.md par. 2.4 scrive, TESTUALE:
#    "Costo pieno di un GIRO COMPLETO sull'oro: 0,16 $ (spread) +
#     0,0403 $ (commissione) = 0,2003 $"
#  e anatomia_esplosioni_oro.py r.80 lo rilegge allo stesso modo
#  ("giro completo"). L'incarico di questa sonda invece dice
#  "0,2003 $/oncia PER LATO, quindi 2 costi per giro".
#  LE DUE LETTURE DIFFERISCONO DI 2x. Non si sceglie la comoda:
#    - PRINCIPALE  = 2 x 0,2003 = 0,4006 $/giro (la lettura SEVERA,
#                    quella dell'incarico). Se il fade passa qui, passa.
#    - SENSIBILITA'= 1 x 0,2003 $/giro (la lettura documentata).
#  Stampate tutte e due, sempre, una accanto all'altra.
#
#  E il costo si applica in RELATIVO (come fa anatomia_esplosioni_oro):
#  0,2003 / 4.400 = 0,004552% del prezzo. Applicare 0,2003 $ PIATTI ai
#  dollari del 2008 (oro a 800 $) sarebbe un pedaggio finto, e sul
#  campione 2006-2020 la differenza e' enorme. La versione a dollari
#  piatti e' stampata come sensibilita'.
# =====================================================================

import argparse
import importlib.util
import os
import random
import sys
from array import array
from datetime import datetime, timedelta

VERSIONE = "SONDA_FADE_ORO_v1"

# ---------------------------------------------------------------------
#  IMPORT della definizione di esplosione -- per NOME, non per copia
# ---------------------------------------------------------------------
_QUI = os.path.dirname(os.path.abspath(__file__))
_SPEC = importlib.util.spec_from_file_location(
    "anatomia_esplosioni_oro", os.path.join(_QUI, "anatomia_esplosioni_oro.py"))
AN = importlib.util.module_from_spec(_SPEC)
_SPEC.loader.exec_module(AN)

MIN_MINUTI_BLOCCO = AN.MIN_MINUTI_BLOCCO
K_PRINCIPALE = AN.K_PRINCIPALE
ATR_GIORNI = AN.ATR_GIORNI
EPOCA = AN.EPOCA
COSTO_ORO_DOLLARI = AN.COSTO_ORO_DOLLARI
PREZZO_ORO_MISURA = AN.PREZZO_ORO_MISURA
PREZZO_ORO_OGGI = AN.PREZZO_ORO_OGGI
COSTO_RELATIVO = AN.COSTO_RELATIVO

mediana = AN.mediana
quantile = AN.quantile
ora_ny = AN.ora_ny
em = AN.em
leggi_tutto = AN.leggi_tutto

# --- la regola del fade, congelata -----------------------------------
COSTI_PER_GIRO = 2                 # PRINCIPALE: lettura SEVERA (incarico)
COSTI_PER_GIRO_SENS = 1            # SENSIBILITA': lettura documentata
ORIZZONTI = ((15, 1), (30, 2), (60, 4))   # minuti, blocchi da 15'
FASCIA_0930 = 570                  # minuti da mezzanotte, ora di New York
NB_FINESTRA = 2                    # 30' = 2 blocchi base da 15'

# --- la soglia, DICHIARATA PRIMA DEI NUMERI, e non si sposta ---------
SOGLIA_PF = 1.20                   # su TUTTI E DUE i campioni
SOGLIA_LOTTERIA = 0.50             # 5 migliori > 50% del lordo -> lotteria
SOGLIA_RANDOM = 1.05               # PF >= 1,05 sulla passeggiata -> si butta

ANCORE = {"2021-2026": 51, "2006-2020": 111}


def log(m):
    print(m, flush=True)


# =====================================================================
#  A. COSTRUZIONE -- replica RIGA PER RIGA i PASSI 1-3 di anatomia
# =====================================================================
def costruisci_blocchi(cartella, cont, bar_iter=None):
    """blocchi base da 15' (indice = minuto//15) e giornate.
    bar_iter: iterabile di (t,o,h,l,c,v) al posto della lettura da disco
    (serve all'AUTOTEST e alla passeggiata aleatoria)."""
    blocchi = {}
    giorni = {}
    sorgente = bar_iter if bar_iter is not None else leggi_tutto(cartella, cont)
    for (t, o, h, l, c, v) in sorgente:
        b = em(t) // 15
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
    return blocchi, giorni


def costruisci_atr(giorni):
    """ATR14 giornaliero NOTO ALLA FINE DEL GIORNO PRIMA: la finestra e'
    range(i-14, i), quindi il giorno i NON entra nel proprio metro.
    Nessuna barra futura, per costruzione."""
    date_ord = sorted(d for d, g in giorni.items() if g[3] >= 300)
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
        atr[d] = sum(tr[date_ord[j]] for j in range(i - ATR_GIORNI, i)) / ATR_GIORNI
    return atr, date_ord


def costruisci_finestre30(blocchi, atr):
    """finestre da 30', allineate a :00 e :30, NON sovrapposte."""
    fin = []
    for b in sorted(blocchi):
        if (b % NB_FINESTRA) != 0:
            continue
        pezzi = [blocchi.get(b + i) for i in range(NB_FINESTRA)]
        if any(p is None or p[5] < MIN_MINUTI_BLOCCO for p in pezzi):
            continue
        t0 = EPOCA + timedelta(minutes=b * 15)
        d = t0.date()
        if d not in atr:
            continue
        o = pezzi[0][0]
        c = pezzi[-1][3]
        tny = ora_ny(t0)
        fin.append({"b": b, "t": t0, "d": d, "o": o, "c": c,
                    "mov": c - o, "atr": atr[d],
                    "ora": t0.hour, "anno": t0.year,
                    "fascia_ny": tny.hour * 60 + (0 if tny.minute < 30 else 30)})
    return fin


def lato_esplosione(f, k=K_PRINCIPALE):
    """+1 rialzo, -1 ribasso, 0 non esplosiva. IDENTICA ad anatomia."""
    if f["mov"] >= k * f["atr"]:
        return 1
    if f["mov"] <= -k * f["atr"]:
        return -1
    return 0


# =====================================================================
#  B. IL FADE
# =====================================================================
def close_dopo(blocchi, f, nb):
    """close alla fine di nb blocchi da 15' DOPO la fine della finestra.
    b_fine = b + NB_FINESTRA: il primo blocco usato e' gia' OLTRE la
    finestra. E' qui che si vede che l'ingresso e' DOPO."""
    b_fine = f["b"] + NB_FINESTRA
    pezzi = [blocchi.get(b_fine + i) for i in range(nb)]
    if any(p is None or p[5] < MIN_MINUTI_BLOCCO for p in pezzi):
        return None
    return pezzi[-1][3]


def operazioni_fade(blocchi, finestre, nb, costi=COSTI_PER_GIRO, k=K_PRINCIPALE,
                    solo_esplosive=True):
    """Restituisce la lista dei rendimenti RELATIVI (frazione del prezzo),
    lordi e netti, del FADE. lato_fade = -segno del movimento."""
    ops = []
    for f in finestre:
        s = lato_esplosione(f, k)
        if solo_esplosive:
            if s == 0:
                continue
            lato = -s
        else:
            if f["mov"] == 0:
                continue
            lato = -1 if f["mov"] > 0 else 1
        cc = close_dopo(blocchi, f, nb)
        if cc is None:
            continue
        p0 = f["c"]
        lordo = lato * (cc - p0) / p0
        ops.append({"f": f, "lato": lato, "lordo": lordo,
                    "netto": lordo - costi * COSTO_RELATIVO})
    return ops


def pf(valori):
    su = sum(v for v in valori if v > 0)
    giu = -sum(v for v in valori if v < 0)
    if giu == 0:
        return float("inf") if su > 0 else float("nan")
    return su / giu


def quadro(ops, eti, out, n_migliori=5):
    """n, PF netto, profitto netto, mediana, % a favore, LA CODA."""
    if not ops:
        out("    %-22s  (nessuna operazione)" % eti)
        return None
    netti = [o["netto"] for o in ops]
    lordi = [o["lordo"] for o in ops]
    n = len(netti)
    p = pf(netti)
    tot = sum(netti) * PREZZO_ORO_OGGI
    med = mediana(netti)
    fav = sum(1 for v in netti if v > 0) / n
    # la coda
    ord_n = sorted(netti)
    peggiore = ord_n[0] * PREZZO_ORO_OGGI
    peggiori5 = sum(ord_n[:n_migliori]) * PREZZO_ORO_OGGI
    vinc = sorted((v for v in lordi if v > 0), reverse=True)
    lordo_vinc = sum(vinc)
    top5 = sum(vinc[:n_migliori])
    quota = top5 / lordo_vinc if lordo_vinc > 0 else float("nan")
    out("    %-22s n=%4d | PF %6.3f | netto %+9.2f $ | mediana %+8.4f $ | "
        "a favore %5.1f%%" % (eti, n, p, tot, med * PREZZO_ORO_OGGI, 100 * fav))
    out("    %-22s CODA: peggiore %+8.2f $ | 5 peggiori %+9.2f $ | "
        "le %d MIGLIORI valgono %5.1f%% del lordo vincente"
        % ("", peggiore, peggiori5, n_migliori, 100 * quota))
    return {"n": n, "pf": p, "netto": tot, "mediana": med * PREZZO_ORO_OGGI,
            "favore": fav, "peggiore": peggiore, "peggiori5": peggiori5,
            "quota_top5": quota, "netti": netti}


# =====================================================================
#  C. CONTROLLO APPAIATO -- stessa fascia, stesso anno, NON esplosive
# =====================================================================
def controlli_appaiati(finestre, seme, k=K_PRINCIPALE):
    esp, non = [], {}
    for f in finestre:
        s = lato_esplosione(f, k)
        if s != 0:
            esp.append(f)
        else:
            non.setdefault((f["fascia_ny"], f["anno"]), []).append(f)
    rng = random.Random(seme)
    fuori = []
    for f in esp:
        pool = non.get((f["fascia_ny"], f["anno"]))
        if not pool:
            continue
        g = rng.choice(pool)
        if g["mov"] == 0:
            continue
        fuori.append(g)
    return esp, fuori


# =====================================================================
#  D. PASSEGGIATA ALEATORIA A VOLATILITA' APPAIATA (contro-esempio 2)
#  Si permutano le FORME delle barre (h/o, l/o, c/o) DENTRO lo stesso
#  minuto-del-giorno, fra giorni diversi, e si ricatena il prezzo.
#  Cosi' l'orologio della volatilita' resta IDENTICO (le 09:30 ET
#  restano la fascia piu' esplosiva) e sparisce SOLO la sequenza --
#  cioe' esattamente la cosa che il fade pretende di sfruttare.
#  Se il fade guadagna anche qui, non sta leggendo il mercato.
# =====================================================================
def passeggiata_appaiata(cartella, cont, seme):
    mins, rh, rl, rc = array("l"), array("d"), array("d"), array("d")
    p_iniziale = None
    for (t, o, h, l, c, v) in leggi_tutto(cartella, cont):
        if p_iniziale is None:
            p_iniziale = o
        mins.append(em(t))
        rh.append(h / o)
        rl.append(l / o)
        rc.append(c / o)
    n = len(mins)
    if n == 0:
        return
    secchi = {}
    for i in range(n):
        secchi.setdefault(mins[i] % 1440, []).append(i)
    rng = random.Random(seme)
    perm = array("l", [0]) * n
    for _, idx in secchi.items():
        mesc = list(idx)
        rng.shuffle(mesc)
        for a, b in zip(idx, mesc):
            perm[a] = b
    prezzo = p_iniziale
    for i in range(n):
        j = perm[i]
        o = prezzo
        h, l, c = o * rh[j], o * rl[j], o * rc[j]
        prezzo = c
        yield (EPOCA + timedelta(minutes=mins[i]), o, h, l, c, 0.0)


# =====================================================================
#  D-bis. PERMUTAZIONE DEGLI ESITI (contro-esempio 2, quello che PESA)
#  La passeggiata per forme qui sopra ha un DIFETTO MISURATO: permutando
#  le barre si distrugge anche il RAGGRUPPAMENTO della volatilita', e
#  allora le esplosioni crollano (16 finte contro 51 vere). Un null con
#  un terzo delle operazioni non e' appaiato: e' un altro esperimento.
#  Questo invece tiene le esplosioni ESATTAMENTE come sono -- stesso n,
#  stessa ancora, stesso verso del fade -- e permuta SOLO quello che
#  viene DOPO: a ogni esplosione si attacca il seguito di un ALTRO
#  giorno, alla STESSA fascia e nello STESSO anno.
#  Cosi' si chiede l'unica domanda che conta: "il seguito VERO di quella
#  esplosione premia il fade piu' del seguito di un giorno a caso?".
#  Se la risposta e' no, il fade non legge niente.
# =====================================================================
def permuta_esiti(blocchi, esplosioni, pool, nb, ripetizioni, seme,
                  costi=COSTI_PER_GIRO):
    """Restituisce (pf_vero, lista di pf finti). n RESTA IDENTICO."""
    veri = []
    lati = []
    for f in esplosioni:
        cc = close_dopo(blocchi, f, nb)
        if cc is None:
            continue
        s = lato_esplosione(f)
        veri.append(s * -1 * (cc - f["c"]) / f["c"] - costi * COSTO_RELATIVO)
        lati.append((-s, f["fascia_ny"], f["anno"]))
    # serbatoio dei SEGUITI: mossa relativa in avanti, per (fascia, anno)
    serb = {}
    for g in pool:
        cc = close_dopo(blocchi, g, nb)
        if cc is None:
            continue
        serb.setdefault((g["fascia_ny"], g["anno"]), []).append((cc - g["c"]) / g["c"])
    rng = random.Random(seme)
    finti = []
    for _ in range(ripetizioni):
        v = []
        for (lato, fa, an) in lati:
            pz = serb.get((fa, an))
            if not pz:
                continue
            v.append(lato * rng.choice(pz) - costi * COSTO_RELATIVO)
        if v:
            finti.append(pf(v))
    return pf(veri), finti, len(veri)


# =====================================================================
#  E. AUTOTEST -- PRIMA di misurare qualunque cosa vera
# =====================================================================
def _barre_finte(giorni=40, seme=7, fino=None):
    """serie M1 sintetica deterministica, con un salto piantato alle
    13:30 UTC di ogni giorno (che e' la fascia 09:30 ET d'inverno)."""
    rng = random.Random(seme)
    t = datetime(2011, 1, 3, 0, 0)
    p = 1400.0
    fatte = 0
    for g in range(giorni):
        for m in range(1440):
            tt = t + timedelta(days=g, minutes=m)
            if tt.weekday() >= 5:
                continue
            d = rng.gauss(0, 0.12)
            if tt.hour == 13 and 30 <= tt.minute < 60:
                d += 0.45 if (g % 2 == 0) else -0.45
            o = p
            c = p + d
            h = max(o, c) + abs(rng.gauss(0, 0.05))
            l = min(o, c) - abs(rng.gauss(0, 0.05))
            p = c
            fatte += 1
            if fino is not None and fatte > fino:
                return
            yield (tt, o, h, l, c, 1.0)


def autotest(out):
    out("")
    out("=" * 72)
    out("AUTOTEST -- gira PRIMA di qualunque misura vera. Se fallisce, ci si FERMA.")
    out("=" * 72)
    passati = falliti = 0

    def prova(nome, cond, extra=""):
        nonlocal passati, falliti
        if cond:
            passati += 1
            out("  [OK]      %s %s" % (nome, extra))
        else:
            falliti += 1
            out("  [FALLITO] %s %s" % (nome, extra))

    cont = {"barre": 0, "righe_scartate": 0, "ohlc_incoerenti": 0,
            "file_formato_ignoto": 0}

    # --- 1. NIENTE LOOK-AHEAD: troncare il futuro non cambia il passato
    bl_a, gi_a = costruisci_blocchi(None, cont, bar_iter=_barre_finte(40))
    atr_a, _ = costruisci_atr(gi_a)
    f_a = costruisci_finestre30(bl_a, atr_a)
    ops_a = operazioni_fade(bl_a, f_a, 2)
    tot_min = 40 * 1440
    bl_b, gi_b = costruisci_blocchi(None, cont,
                                    bar_iter=_barre_finte(40, fino=tot_min // 2))
    atr_b, _ = costruisci_atr(gi_b)
    f_b = costruisci_finestre30(bl_b, atr_b)
    ops_b = operazioni_fade(bl_b, f_b, 2)
    chiave = lambda o: (o["f"]["b"], o["lato"], round(o["netto"], 12))
    ins_a = set(chiave(o) for o in ops_a)
    comuni = [o for o in ops_b]
    ok_la = bool(comuni) and all(chiave(o) in ins_a for o in comuni)
    prova("NIENTE LOOK-AHEAD: le %d operazioni del campione troncato sono"
          % len(comuni), ok_la, "IDENTICHE nel campione intero (%d op)" % len(ops_a))
    prova("  e il troncamento ha davvero tolto roba", len(ops_b) < len(ops_a),
          "(%d < %d)" % (len(ops_b), len(ops_a)))

    # --- 2. IL COSTO E' ESATTAMENTE 2 PER GIRO
    ok_costo = all(abs((o["lordo"] - o["netto"]) - 2 * COSTO_RELATIVO) < 1e-15
                   for o in ops_a)
    prova("COSTO = esattamente 2 x %.6f%% del prezzo su tutte le %d operazioni"
          % (100 * COSTO_RELATIVO, len(ops_a)), ok_costo)
    ops_s = operazioni_fade(bl_a, f_a, 2, costi=1)
    ok_sens = all(abs((o["lordo"] - o["netto"]) - 1 * COSTO_RELATIVO) < 1e-15
                  for o in ops_s)
    prova("  e la SENSIBILITA' a 1 costo toglie davvero la meta'", ok_sens)
    # contro-esempio: un costo sbagliato DEVE far fallire il controllo sopra
    ops_x = operazioni_fade(bl_a, f_a, 2, costi=3)
    rotto = all(abs((o["lordo"] - o["netto"]) - 2 * COSTO_RELATIVO) < 1e-15
                for o in ops_x)
    prova("  CONTRO-ESEMPIO: con 3 costi il controllo RIFIUTA", not rotto)

    # --- 3. L'INGRESSO AVVIENE DOPO LA FINE DELLA FINESTRA
    #        (si verifica sul BLOCCO usato per l'uscita, non a parole)
    ok_dopo = True
    for f in f_a[:500]:
        b_primo_usato = f["b"] + NB_FINESTRA
        if b_primo_usato <= f["b"] + NB_FINESTRA - 1:
            ok_dopo = False
    prova("INGRESSO DOPO LA FINESTRA: il primo blocco d'uscita e' b+%d, cioe'"
          % NB_FINESTRA, ok_dopo, "oltre gli %d blocchi della finestra" % NB_FINESTRA)
    # e il contro-esempio che conta: l'uscita a +15' NON puo' coincidere col
    # close della finestra stessa, se no sarebbe un'operazione a costo zero
    coincidenze = sum(1 for o in ops_a
                      if abs(o["lordo"]) < 1e-18)
    prova("  CONTRO-ESEMPIO: uscite a rendimento esattamente nullo",
          coincidenze < max(1, len(ops_a) // 20),
          "= %d su %d (sarebbero il segno di un'uscita SULLA finestra)"
          % (coincidenze, len(ops_a)))

    # --- 4. IL FADE E' DAVVERO IL VERSO OPPOSTO
    ok_verso = all(o["lato"] == -lato_esplosione(o["f"]) for o in ops_a)
    prova("VERSO: lato_fade = -lato_esplosione su tutte le operazioni", ok_verso)

    # --- 5. IL PF sa distinguere un vincente da un perdente
    prova("PF: [2,-1] -> 2,000", abs(pf([2.0, -1.0]) - 2.0) < 1e-12)
    prova("PF: [1,-2] -> 0,500", abs(pf([1.0, -2.0]) - 0.5) < 1e-12)

    # --- 6. La quota delle 5 migliori riconosce una LOTTERIA
    class _O(dict):
        pass
    finti = [{"lordo": 100.0, "netto": 100.0} for _ in range(5)]
    finti += [{"lordo": 1.0, "netto": 1.0} for _ in range(10)]
    finti += [{"lordo": -3.0, "netto": -3.0} for _ in range(30)]
    for o in finti:
        o["f"] = None
    righe = []
    r = quadro(finti, "LOTTERIA FINTA", righe.append)
    prova("LOTTERIA: 5 migliori = 500 su 510 di lordo vincente -> quota 98,0%",
          abs(r["quota_top5"] - 500.0 / 510.0) < 1e-12,
          "(misurata %.1f%%)" % (100 * r["quota_top5"]))

    out("")
    out("  AUTOTEST: %d PASSATI, %d FALLITI" % (passati, falliti))
    if falliti:
        out("  CI SI FERMA. Un autotest fallito non si commenta: si ripara.")
        sys.exit(2)
    return True


# =====================================================================
#  MAIN
# =====================================================================
def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dati", required=True, help="cartella con i CSV M1")
    ap.add_argument("--etichetta", required=True,
                    help="nome del campione, deve stare fra le ancore: "
                         + " / ".join(sorted(ANCORE)))
    ap.add_argument("--seme", type=int, default=20260922)
    ap.add_argument("--ripetizioni", type=int, default=400,
                    help="ripetizioni della permutazione degli esiti")
    ap.add_argument("--random-walk", action="store_true",
                    help="esegue anche il contro-esempio 2 (passeggiata)")
    ap.add_argument("--fuori", default="")
    a = ap.parse_args()

    uscita = open(a.fuori, "w", encoding="ascii", errors="replace") if a.fuori else None

    def out(m):
        log(m)
        if uscita:
            uscita.write(m + "\n")

    out("=" * 72)
    out(VERSIONE)
    out("=" * 72)
    out("CAMPIONE DICHIARATO: %s" % a.etichetta)
    out("DATI: %s" % a.dati)

    autotest(out)

    # -----------------------------------------------------------------
    out("")
    out("=" * 72)
    out("0. LETTURA E COSTRUZIONE")
    out("=" * 72)
    cont = {"barre": 0, "righe_scartate": 0, "ohlc_incoerenti": 0,
            "file_formato_ignoto": 0}
    blocchi, giorni = costruisci_blocchi(a.dati, cont)
    out("  barre M1 = %d | scartate = %d | OHLC incoerenti = %d | file ignoti = %d"
        % (cont["barre"], cont["righe_scartate"], cont["ohlc_incoerenti"],
           cont["file_formato_ignoto"]))
    atr, date_ord = costruisci_atr(giorni)
    f30 = costruisci_finestre30(blocchi, atr)
    gg = sorted(giorni)
    out("  FINESTRA MISURATA (la fa il DATO, non il nome del file): %s -> %s"
        % (gg[0], gg[-1]))
    out("  blocchi 15' = %d | giornate = %d | ATR valido su %d | finestre 30' = %d"
        % (len(blocchi), len(giorni), len(atr), len(f30)))

    # --- L'ANCORA ----------------------------------------------------
    f0930 = [f for f in f30 if f["fascia_ny"] == FASCIA_0930]
    n_esp = sum(1 for f in f0930 if lato_esplosione(f) != 0)
    atteso = ANCORE.get(a.etichetta)
    out("")
    out("  ANCORA OBBLIGATORIA -- esplosioni sulla fascia 09:30 ET (minuto %d)"
        % FASCIA_0930)
    out("    finestre sulla fascia = %d | esplosioni MISURATE = %d | ATTESE = %s"
        % (len(f0930), n_esp, atteso))
    if atteso is None:
        out("    NESSUNA ANCORA per l'etichetta '%s': CI SI FERMA." % a.etichetta)
        sys.exit(2)
    if n_esp != atteso:
        out("    FALLITA. La definizione di esplosione NON coincide con quella di")
        out("    anatomia_esplosioni_oro.py: questi numeri NON si confrontano con i")
        out("    suoi, e non valgono niente. CI SI FERMA.")
        sys.exit(2)
    out("    PASSATA: la definizione coincide. I numeri sotto sono confrontabili.")

    # -----------------------------------------------------------------
    out("")
    out("=" * 72)
    out("1. IL FADE SULLA FASCIA 09:30 ET -- la misura principale")
    out("=" * 72)
    out("  Ingresso al close della finestra, CONTRO il verso. Uscita secca a")
    out("  orologio. NESSUNO STOP, NESSUN TARGET (limite dichiarato).")
    out("  Costo PRINCIPALE = %d x %.4f $ = %.4f $/giro, applicato in RELATIVO"
        % (COSTI_PER_GIRO, COSTO_ORO_DOLLARI, COSTI_PER_GIRO * COSTO_ORO_DOLLARI))
    out("  (= %.6f%% del prezzo per costo). Cifre in $ a oro %.0f $."
        % (100 * COSTO_RELATIVO, PREZZO_ORO_OGGI))
    out("  SOGLIA DICHIARATA PRIMA DEI NUMERI: PF netto >= %.2f" % SOGLIA_PF)

    esp, ctrl = controlli_appaiati(f0930, a.seme)
    out("")
    out("  esplosioni = %d | controlli appaiati (stessa fascia, stesso anno,"
        " NON esplosive) = %d" % (len(esp), len(ctrl)))

    risultati = {}
    for orizz, nb in ORIZZONTI:
        out("")
        out("  --- USCITA A +%d MINUTI" % orizz)
        ops = operazioni_fade(blocchi, esp, nb)
        r = quadro(ops, "FADE 09:30 ET", out)
        risultati[orizz] = r
        ops_s = operazioni_fade(blocchi, esp, nb, costi=COSTI_PER_GIRO_SENS)
        rs = quadro(ops_s, "  sens. 1 costo/giro", out)
        if r and rs:
            out("    %-22s PF %6.3f (severo, %d costi)  ->  PF %6.3f (documentato,"
                " %d costo)" % ("", r["pf"], COSTI_PER_GIRO, rs["pf"],
                                COSTI_PER_GIRO_SENS))
        # sensibilita' a dollari PIATTI (il pedaggio finto, dichiarato).
        # DIFETTO RIPARATO PRIMA DELLA CONSEGNA: stava DOPO il controllo
        # appaiato, e chi legge la attribuiva al CONTROLLO invece che al
        # FADE. Una riga giusta nel posto sbagliato e' una riga falsa.
        if ops:
            netti_p = [o["lordo"] * f_prezzo(o) - COSTI_PER_GIRO * COSTO_ORO_DOLLARI
                       for o in ops]
            out("    %-22s PF %6.3f | netto %+9.2f $  (SUL FADE. Costo a DOLLARI"
                % ("  sens. $ piatti", pf(netti_p), sum(netti_p)))
            out("    %-22s  PIATTI: su un campione a oro 600-2.000 $ e' un pedaggio"
                " FINTO, sta qui solo come limite)" % "")
        # controllo appaiato: stesso gesto sulle giornate NON esplosive
        ops_c = operazioni_fade(blocchi, ctrl, nb, solo_esplosive=False)
        quadro(ops_c, "CONTROLLO appaiato", out)

    # -----------------------------------------------------------------
    out("")
    out("=" * 72)
    out("2. CONTRO-ESEMPIO 3 -- e se guadagnasse su QUALUNQUE fascia?")
    out("=" * 72)
    out("  Se il fade rende uguale a tutte le ore, non e' l'ora delle 09:30:")
    out("  e' il fade in generale, e il ritrovamento delle 09:30 non c'entra.")
    fasce = {}
    for f in f30:
        if lato_esplosione(f) != 0:
            fasce.setdefault(f["fascia_ny"], []).append(f)
    out("")
    out("  fascia ET | n esp | PF +15 | PF +30 | PF +60 | netto +30 ($) | a favore +30")
    out("  " + "-" * 82)
    righe_f = []
    for k in sorted(fasce):
        gruppo = fasce[k]
        if len(gruppo) < 20:
            continue
        pfs, dett = [], None
        for orizz, nb in ORIZZONTI:
            ops = operazioni_fade(blocchi, gruppo, nb)
            pfs.append(pf([o["netto"] for o in ops]) if ops else float("nan"))
            if orizz == 30 and ops:
                dett = (sum(o["netto"] for o in ops) * PREZZO_ORO_OGGI,
                        sum(1 for o in ops if o["netto"] > 0) / len(ops))
        mark = "  <== 09:30 ET" if k == FASCIA_0930 else ""
        out("     %02d:%02d  | %5d | %6.3f | %6.3f | %6.3f | %13.2f | %11.1f%%%s"
            % (k // 60, k % 60, len(gruppo), pfs[0], pfs[1], pfs[2],
               dett[0] if dett else float("nan"),
               100 * dett[1] if dett else float("nan"), mark))
        righe_f.append((k, pfs[1]))
    # LA RIGA CHE PESA: tutte le esplosioni FUORI dalle 09:30, messe
    # insieme. Le singole fasce hanno n piccolo e ognuna puo' dire quello
    # che vuole; il monte unico ha n grande ed e' il vero contro-esempio.
    altre_tutte = [f for f in f30
                   if lato_esplosione(f) != 0 and f["fascia_ny"] != FASCIA_0930]
    if altre_tutte:
        pfs2 = []
        d30 = None
        for orizz, nb in ORIZZONTI:
            o2 = operazioni_fade(blocchi, altre_tutte, nb)
            pfs2.append(pf([x["netto"] for x in o2]) if o2 else float("nan"))
            if orizz == 30 and o2:
                d30 = (sum(x["netto"] for x in o2) * PREZZO_ORO_OGGI,
                       sum(1 for x in o2 if x["netto"] > 0) / len(o2))
        out("  " + "-" * 82)
        out("   TUTTE le | %5d | %6.3f | %6.3f | %6.3f | %13.2f | %11.1f%%  <== il"
            " MONTE UNICO" % (len(altre_tutte), pfs2[0], pfs2[1], pfs2[2],
                              d30[0] if d30 else float("nan"),
                              100 * d30[1] if d30 else float("nan")))
        out("   ALTRE    |       |        |        |        |               |")
    if righe_f:
        altre = [v for k, v in righe_f if k != FASCIA_0930 and v == v]
        mia = [v for k, v in righe_f if k == FASCIA_0930]
        if altre and mia:
            out("")
            out("  PF +30' della fascia 09:30 = %.3f | MEDIANA delle altre %d fasce ="
                " %.3f | quante fasce la battono: %d"
                % (mia[0], len(altre), mediana(altre),
                   sum(1 for v in altre if v > mia[0])))

    # -----------------------------------------------------------------
    out("")
    out("=" * 72)
    out("3. CONTRO-ESEMPIO 2/A -- PERMUTAZIONE DEGLI ESITI (n resta %d)" % len(esp))
    out("=" * 72)
    out("  Le esplosioni restano quelle vere, il verso del fade resta quello vero.")
    out("  Si permuta SOLO il SEGUITO: a ogni esplosione si attacca il seguito di")
    out("  un altro giorno, stessa fascia, stesso anno. %d ripetizioni."
        % a.ripetizioni)
    out("  Domanda: il seguito VERO premia il fade piu' di un seguito a caso?")
    out("")
    out("  orizz | PF VERO | PF finto: mediana | P5 - P95      | quante volte il finto")
    out("        |         |                   |               | BATTE il vero")
    out("  " + "-" * 78)
    for orizz, nb in ORIZZONTI:
        pv, fin, nn = permuta_esiti(blocchi, esp, f0930, nb, a.ripetizioni, a.seme)
        if not fin:
            continue
        fin_ok = [x for x in fin if x == x and x != float("inf")]
        batte = sum(1 for x in fin_ok if x >= pv) / len(fin_ok)
        out("  +%2d m | %7.3f | %17.3f | %5.3f - %5.3f | %6.1f%% su %d"
            % (orizz, pv, mediana(fin_ok), quantile(fin_ok, 0.05),
               quantile(fin_ok, 0.95), 100 * batte, len(fin_ok)))
    out("")
    out("  >>> COME SI LEGGE: se il finto batte il vero PIU' del 5% delle volte,")
    out("      il seguito vero NON e' distinguibile da un seguito a caso, e il")
    out("      fade su quella fascia NON sta leggendo l'esplosione.")

    if a.random_walk:
        out("")
        out("=" * 72)
        out("3/B. CONTRO-ESEMPIO 2/B -- PASSEGGIATA ALEATORIA (per FORME di barra)")
        out("=" * 72)
        out("  Le FORME delle barre sono permutate dentro lo stesso minuto-del-")
        out("  giorno, fra giorni diversi: l'orologio della volatilita' resta")
        out("  identico, sparisce SOLO la sequenza. Se il fade fa PF >= %.2f anche"
            % SOGLIA_RANDOM)
        out("  qui, la misura SI BUTTA.")
        cont2 = {"barre": 0, "righe_scartate": 0, "ohlc_incoerenti": 0,
                 "file_formato_ignoto": 0}
        bl_r, gi_r = costruisci_blocchi(None, cont2,
                                        bar_iter=passeggiata_appaiata(a.dati, cont2, a.seme))
        atr_r, _ = costruisci_atr(gi_r)
        f_r = costruisci_finestre30(bl_r, atr_r)
        f_r0930 = [f for f in f_r if f["fascia_ny"] == FASCIA_0930]
        n_r = sum(1 for f in f_r0930 if lato_esplosione(f) != 0)
        out("")
        out("  finestre = %d | fascia 09:30 = %d | esplosioni sulla fascia = %d"
            " (vere: %d)" % (len(f_r), len(f_r0930), n_r, n_esp))
        if n_esp and n_r < 0.7 * n_esp:
            out("")
            out("  LIMITE DICHIARATO, e va letto PRIMA dei numeri qui sotto: permutando")
            out("  le barre si distrugge anche il RAGGRUPPAMENTO della volatilita', e")
            out("  le esplosioni crollano da %d a %d. Questo null ha meno operazioni"
                % (n_esp, n_r))
            out("  del vero: NON e' appaiato sul campione, ed e' il motivo per cui il")
            out("  contro-esempio che PESA e' il 2/A qui sopra, non questo.")
        for orizz, nb in ORIZZONTI:
            ops = operazioni_fade(bl_r, f_r0930, nb)
            quadro(ops, "PASSEGGIATA +%d m" % orizz, out)

    # -----------------------------------------------------------------
    out("")
    out("=" * 72)
    out("4. IL VERDETTO CONTRO LA SOGLIA DICHIARATA")
    out("=" * 72)
    out("  Soglia: PF netto >= %.2f (costo severo). Lotteria: 5 migliori > %.0f%%"
        % (SOGLIA_PF, 100 * SOGLIA_LOTTERIA))
    for orizz, _ in ORIZZONTI:
        r = risultati.get(orizz)
        if not r:
            continue
        v = []
        v.append("PF %.3f %s soglia" % (r["pf"], ">=" if r["pf"] >= SOGLIA_PF else "<"))
        v.append("5 migliori = %.1f%% del lordo (%s)"
                 % (100 * r["quota_top5"],
                    "LOTTERIA" if r["quota_top5"] > SOGLIA_LOTTERIA else "ok"))
        esito = ("PASSA" if (r["pf"] >= SOGLIA_PF
                             and r["quota_top5"] <= SOGLIA_LOTTERIA) else "BOCCIATO")
        out("  +%2d m: %-8s  %s | %s" % (orizz, esito, v[0], v[1]))
    out("")
    out("  (il verdetto FINALE vale solo se PASSA su TUTTI E DUE i campioni:")
    out("   questo referto ne misura UNO -- '%s'.)" % a.etichetta)

    if uscita:
        uscita.close()
    log("")
    log("FATTO.")


def f_prezzo(o):
    """prezzo d'ingresso dell'operazione: serve alla sensibilita' a
    dollari piatti (rendimento relativo x prezzo VERO dell'epoca)."""
    return o["f"]["c"]


if __name__ == "__main__":
    main()
