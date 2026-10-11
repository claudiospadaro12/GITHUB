#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
collaudo_export_barre_h1.py -- il COLLAUDO del CSV scritto da CLAU12_EXPORT_BARRE_H1 (barre H1 di U30USD, feed BCM).

USO
  python3 backtest_pipeline/collaudo_export_barre_h1.py <csv> [--run <12 esadecimali>]
  python3 backtest_pipeline/collaudo_export_barre_h1.py --autotest
Esce 0 = PASS, 1 = FAIL (ogni motivo stampato), 2 = errore d'uso. Non scrive niente.

ATTESE SCRITTE PRIMA DEI NUMERI (11/10/2026), con la fonte
  A1. PRIMA BARRA il 2024.09.26 (+-1 giorno). Fonte: sonda del 17/08/2026,
      backtest_pipeline/risultati_archivio/sonda_storico_17-08/215D85D7_ABTG_InfoBroker.csv, riga U30USD:
      PrimaDataTF 2024.09.26, Stato COMPLETO. Una prima barra PIU' VECCHIA non e' un guasto: e' una NOTIZIA (storico
      piu' profondo di quello misurato il 17/08) e si stampa come AVVISO. Una prima barra piu' RECENTE e' un taglio: FAIL.
  A2. ANCORA DI CONTEGGIO: nella stessa riga BarreTF = 10859 barre H1 alle 17:34 server del 17/08/2026, cioe' le barre
      con apertura in [2024.09.26 00:00 ; 2026.08.17 17:00] (Bars() conta anche la barra in formazione). Banda +-1%
      (PROPOSTA, non criterio di casa). E' un numero scritto da UN ALTRO strumento: non e' una banda tarata su se stessa.
  A3. RITMO: 10859 / 690,75 giorni x 365,25 = ~5.742 barre H1 per anno di calendario (DERIVATO da A2). Si applica solo
      agli anni INTERI presenti nel file, ELENCATI PER NOME (oggi: ANNO_2025), banda +-5% (PROPOSTA).
      Il "6.000-6.200 barre/anno" scritto a memoria nel compito NON torna con A2: e' il forex (24 x 5 x 52 = 6.240,
      REFERTO_SONDA_STORICO_17-08.md par. 3-bis), non il Dow di BCM.
  A4. OROLOGIO: le aperture cash di Wall Street (9:30 ET) cadono alle 14:30 server d'estate USA e alle 15:30 d'inverno
      USA (report/OROLOGIO_BCM_2026-09-24.md par. 3.2: indici BCM UTC+1 fisso su tutto l'arco dal 2024.09.26, misurato
      dagli affari). In barre H1: la barra 14 d'estate, la 15 d'inverno. Firma cercata: l'ora h fra 11 e 18 in cui la
      mediana dell'escursione (high-low)/open fa il SALTO piu' grande rispetto all'ora prima (giorni lun-ven). Si misura
      PER SEGMENTO di calendario USA, elencato per nome; un segmento con meno di 40 giorni feriali e' NON VALUTABILE.
      Il salto vincente deve superare il secondo di almeno il 10% (PROPOSTA). Che la firma sia l'apertura cash e non i
      dati delle 8:30 ET e' [INFERITO]: se sui dati veri non regge, il collaudo dice FAIL e stampa il profilo intero.
      Le ALTRE spiegazioni e il numero che producono (classe 178):
        feed spostato di +1 ora        -> estate 15, inverno 16
        feed spostato di -1 ora        -> estate 13, inverno 14
        vecchio orologio (UTC+0 d'inverno europeo, IT-1 tutto l'anno) -> estate 14, inverno 14
      Per questo serve ALMENO un segmento d'inverno valutabile: d'estate UTC+1 fisso e vecchio orologio coincidono.
  A5. BUCHI: nessuna sequenza di 2 o piu' giorni feriali consecutivi senza barre (FAIL). Chiusure (buchi di 3 ore o
      piu' fuori dal fine settimana normale, o fine settimana di oltre 60 ore mancanti): al massimo 15 ogni 365 giorni
      (PROPOSTA; [INFERITO] ~9-10 festivita' NYSE + 2-3 chiusure anticipate all'anno).
  A6. OHLC: high >= max(open, close), low <= min(open, close), tutti > 0; prezzo dentro 30.000-70.000 (Dow 2024-26).
  A7. FORMA: tempo strettamente crescente, allineato all'ora (mm = 00), nessun doppione; intestazione dell'EA v1.00,
      simbolo U30USD, periodo H1, '#orologio;ORA_SERVER_DEL_FEED_NON_CONVERTITA', riga #FINE con n = righe di barra ed
      errori_copia = 0; nessuna traccia di CONTO nell'intestazione (parole e numeri di conto elencati per nome).

CHE COSA LE BANDE NON VEDONO (classe 178, scritto prima):
  - un feed spostato di un'ora ha lo STESSO n: A2 e A3 sono cieche all'orologio -> lo prende solo A4;
  - lo 0,5% di barre doppie sta dentro A2 (+-1%) -> lo prende solo A7 (monotonia);
  - una barra mancante al giorno (-4,5%) sta sotto i 3 h di A5 -> la prende A2;
  - un venerdi pomeriggio tagliato si FONDE col fine settimana (<= 60 h mancanti) e A5 non lo vede -> lo prende A2
    (trovato dall'autotest stesso, caso P: e' un limite di A5, scritto qui e non nascosto).
  L'autotest costruisce questi casi e verifica che il controllo GIUSTO li prenda (e che la banda NON li veda).

INVERNI DELLA DOMANDA H3 (report/MIGLIORA_EMA200_DOW_H1_2026-10-11.md, sez. 3 H3): il collaudo stampa, per nome, quali
inverni nov-mar dal 2012/13 al 2025/26 il CSV copre. Con il feed BCM ci si aspetta SOLO 2024/25 e 2025/26: gli altri
stanno nei dati Dukascopy (report/PIANO_REGIME_DOW_DUKASCOPY_2026-10-05.md), non qui.

ASCII puro.
"""
import argparse
import datetime as dt
import random
import statistics
import sys

# ------------------------------------------------------------------ attese (vedi docstring)
VERSIONE_EA = "1.00"
SIMBOLO = "U30USD"
PRIMA_ATTESA = dt.datetime(2024, 9, 26, 0, 0)
ANCORA_N = 10859
ANCORA_DA = dt.datetime(2024, 9, 26, 0, 0)
ANCORA_FINO = dt.datetime(2026, 8, 17, 17, 0)
ANCORA_TOLL = 0.01
_GIORNI_ANCORA = (ANCORA_FINO - ANCORA_DA).total_seconds() / 86400.0 + 1.0 / 24.0
RITMO_ANNO = ANCORA_N / _GIORNI_ANCORA * 365.25
RITMO_TOLL = 0.05
PREZZO_MIN, PREZZO_MAX = 30000.0, 70000.0
OROLOGIO_FINESTRA = range(11, 19)
OROLOGIO_ATTESO = {"ESTATE": 14, "INVERNO": 15}
OROLOGIO_MARGINE = 1.10
SEG_MIN_GIORNI = 40
ORA_MIN_BARRE = 20
CHIUSURE_PER_365 = 15.0
ORE_BUCO = 3
WEEKEND_MAX_ORE = 60
INTESTAZIONE_ATTESA = "#CLAU12_EXPORT_BARRE_H1;v" + VERSIONE_EA
OROLOGIO_RIGA = "#orologio;ORA_SERVER_DEL_FEED_NON_CONVERTITA"
COLONNE = "time_server;open;high;low;close;tick_volume;spread;real_volume"
PAROLE_CONTO = ("conto", "account", "login", "balance", "saldo", "equity", "margin")
NUMERI_CONTO = ("50503392", "50504263", "10105439", "50504400", "50503635", "541452707", "1514806751")
INVERNI_H3 = ["%d/%02d" % (a, (a + 1) % 100) for a in range(2012, 2026)]


# ------------------------------------------------------------------ calendario
def domenica_n(anno, mese, n):
    d = dt.date(anno, mese, 1)
    while d.weekday() != 6:
        d += dt.timedelta(days=1)
    return d + dt.timedelta(days=7 * (n - 1))


def ultima_domenica(anno, mese):
    d = dt.date(anno + (mese // 12), mese % 12 + 1, 1) - dt.timedelta(days=1)
    while d.weekday() != 6:
        d -= dt.timedelta(days=1)
    return d


def ora_legale_usa(d):
    return domenica_n(d.year, 3, 2) <= d < domenica_n(d.year, 11, 1)


def ora_legale_eu(d):
    return ultima_domenica(d.year, 3) <= d < ultima_domenica(d.year, 10)


def nome_segmento(d):
    if ora_legale_usa(d):
        return "ESTATE_USA_%d" % d.year
    a = d.year if d.month >= 11 else d.year - 1
    return "INVERNO_USA_%d_%02d" % (a, (a + 1) % 100)


# ------------------------------------------------------------------ lettura
def leggi(testo):
    righe = testo.splitlines()
    meta, barre, errori = [], [], []
    header_visto = False
    for i, ln in enumerate(righe, 1):
        if ln.strip() == "":
            continue
        if ln.startswith("#"):
            meta.append((i, ln))
            continue
        if ln == COLONNE:
            if header_visto:
                errori.append("riga %d: intestazione delle colonne ripetuta" % i)
            header_visto = True
            continue
        c = ln.split(";")
        if len(c) != 8:
            errori.append("riga %d: %d campi invece di 8" % (i, len(c)))
            continue
        try:
            t = dt.datetime.strptime(c[0], "%Y.%m.%d %H:%M")
            o, h, l, cl = (float(x) for x in c[1:5])
            int(c[5]); int(c[6]); int(c[7])
        except ValueError:
            errori.append("riga %d: campo non leggibile: %s" % (i, ln[:60]))
            continue
        barre.append((t, o, h, l, cl, int(c[5])))
    if not header_visto:
        errori.append("intestazione delle colonne '%s' assente" % COLONNE)
    return meta, barre, errori


# ------------------------------------------------------------------ i controlli
def collauda(testo, run=None, ancora=None, stampa=True):
    """Ritorna (pass, motivi, info). ancora = (n, da, fino) per l'autotest; default = A2."""
    an_n, an_da, an_fino = ancora if ancora else (ANCORA_N, ANCORA_DA, ANCORA_FINO)
    out = []
    motivi = []
    info = {"ancora_ok": None, "orologio": {}, "monotonia_ok": None}

    def dico(s):
        out.append(s)

    meta, barre, err = leggi(testo)
    motivi += err
    # --- A7 intestazione
    righe_meta = [m[1] for m in meta]
    if not righe_meta or righe_meta[0] != INTESTAZIONE_ATTESA:
        motivi.append("prima riga diversa da '%s'" % INTESTAZIONE_ATTESA)
    for attesa in ("#simbolo;" + SIMBOLO, "#periodo;H1", OROLOGIO_RIGA, "#solo_barre_chiuse;si"):
        if righe_meta.count(attesa) != 1:
            motivi.append("riga d'intestazione '%s' presente %d volte invece di 1" % (attesa, righe_meta.count(attesa)))
    runs = [r[5:] for r in righe_meta if r.startswith("#run;")]
    if len(runs) != 1:
        motivi.append("righe #run: %d invece di 1" % len(runs))
    elif run is not None and runs[0] != run:
        motivi.append("run del CSV '%s' diverso da quello atteso '%s'" % (runs[0], run))
    for r in righe_meta:
        bassa = r.lower()
        for p in PAROLE_CONTO:
            if p in bassa:
                motivi.append("traccia di CONTO nell'intestazione ('%s'): %s" % (p, r[:80]))
        for n in NUMERI_CONTO:
            if n in r:
                motivi.append("NUMERO DI CONTO %s nell'intestazione: %s" % (n, r[:80]))
    fine = [m for m in meta if m[1].startswith("#FINE;")]
    if len(fine) != 1:
        motivi.append("righe #FINE: %d invece di 1 (file troncato o doppio)" % len(fine))
    else:
        campi = dict(kv.split("=", 1) for kv in fine[0][1].split(";")[1:] if "=" in kv)
        if campi.get("n") != str(len(barre)):
            motivi.append("#FINE dice n=%s ma le barre lette sono %d" % (campi.get("n"), len(barre)))
        if campi.get("errori_copia") != "0":
            motivi.append("#FINE dice errori_copia=%s (atteso 0)" % campi.get("errori_copia"))
        ultima_riga = [ln for ln in testo.splitlines() if ln.strip() != ""][-1]
        if not ultima_riga.startswith("#FINE;"):
            motivi.append("#FINE non e' l'ultima riga del file")
    if not barre:
        motivi.append("nessuna barra")
        return finale(False, motivi, out, info, stampa)

    # --- A7 forma del tempo
    nondup = 0
    for i in range(1, len(barre)):
        if barre[i][0] <= barre[i - 1][0]:
            nondup += 1
    disall = sum(1 for b in barre if b[0].minute != 0 or b[0].second != 0)
    info["monotonia_ok"] = (nondup == 0)
    if nondup:
        motivi.append("tempo NON strettamente crescente in %d punti (doppioni o disordine)" % nondup)
    if disall:
        motivi.append("%d barre non allineate all'ora (minuti != 00)" % disall)
    # --- A6 OHLC
    rotte = [b for b in barre if not (b[2] >= max(b[1], b[4]) and b[3] <= min(b[1], b[4]) and min(b[1:5]) > 0)]
    if rotte:
        motivi.append("%d barre con OHLC incoerente (prima: %s)" % (len(rotte), rotte[0][0].strftime("%Y.%m.%d %H:%M")))
    fuori = [b for b in barre if b[3] < PREZZO_MIN or b[2] > PREZZO_MAX]
    if fuori:
        motivi.append("%d barre fuori dalla banda di prezzo %.0f-%.0f" % (len(fuori), PREZZO_MIN, PREZZO_MAX))

    prima, ultima = barre[0][0], barre[-1][0]
    dico("barre: %d   prima %s   ultima %s" % (len(barre), prima.strftime("%Y.%m.%d %H:%M"), ultima.strftime("%Y.%m.%d %H:%M")))
    # --- A1
    if prima.date() < PRIMA_ATTESA.date() - dt.timedelta(days=1):
        dico("AVVISO (A1): la prima barra e' PIU' VECCHIA del 2024.09.26 misurato il 17/08: storico piu' profondo, da rimisurare con la sonda")
    elif prima.date() > PRIMA_ATTESA.date() + dt.timedelta(days=1):
        motivi.append("prima barra %s: piu' recente del 2024.09.26 (+-1 giorno) misurato il 17/08 (A1)" % prima.strftime("%Y.%m.%d"))
    # --- A2
    if ultima >= an_fino:
        n_an = sum(1 for b in barre if an_da <= b[0] <= an_fino)
        scarto = (n_an - an_n) / float(an_n)
        info["ancora_ok"] = abs(scarto) <= ANCORA_TOLL
        dico("ancora A2: barre in [%s ; %s] = %d contro %d della sonda (%+.2f%%, banda +-%.0f%%)" % (
            an_da.strftime("%Y.%m.%d %H:%M"), an_fino.strftime("%Y.%m.%d %H:%M"), n_an, an_n, 100 * scarto, 100 * ANCORA_TOLL))
        if not info["ancora_ok"]:
            motivi.append("ancora A2 fuori banda: %d contro %d (%+.2f%%)" % (n_an, an_n, 100 * scarto))
    else:
        motivi.append("il CSV finisce prima del %s: l'ancora A2 non e' verificabile" % an_fino.strftime("%Y.%m.%d %H:%M"))
    # --- A3 per anno, per nome
    per_anno = {}
    for b in barre:
        per_anno[b[0].year] = per_anno.get(b[0].year, 0) + 1
    for a in sorted(per_anno):
        intero = prima <= dt.datetime(a, 1, 1, 0, 0) and ultima >= dt.datetime(a, 12, 31, 0, 0)
        if intero:
            lo, hi = RITMO_ANNO * (1 - RITMO_TOLL), RITMO_ANNO * (1 + RITMO_TOLL)
            esito = "OK" if lo <= per_anno[a] <= hi else "FUORI"
            dico("ANNO_%d (intero): %d barre, attese %.0f-%.0f (A3) -> %s" % (a, per_anno[a], lo, hi, esito))
            if esito != "OK":
                motivi.append("ANNO_%d: %d barre fuori da %.0f-%.0f (A3)" % (a, per_anno[a], lo, hi))
        else:
            dico("ANNO_%d (parziale): %d barre (A3 non si applica)" % (a, per_anno[a]))
    # --- A5 buchi
    date_con_barre = set(b[0].date() for b in barre)
    d = prima.date()
    feriali_vuoti = []
    while d <= ultima.date():
        if d.weekday() < 5 and d not in date_con_barre:
            feriali_vuoti.append(d)
        d += dt.timedelta(days=1)
    serie = []
    for g in feriali_vuoti:
        if serie and serie[-1][-1] + dt.timedelta(days=1 if g.weekday() > 0 else 3) == g:
            serie[-1].append(g)
        else:
            serie.append([g])
    lunghe = [s for s in serie if len(s) >= 2]
    dico("giorni feriali senza barre (%d): %s" % (len(feriali_vuoti), ", ".join(g.strftime("%Y.%m.%d") for g in feriali_vuoti) or "nessuno"))
    for s in lunghe:
        motivi.append("BUCO: %d giorni feriali consecutivi senza barre da %s a %s (A5)" % (len(s), s[0].strftime("%Y.%m.%d"), s[-1].strftime("%Y.%m.%d")))
    chiusure = []
    for i in range(1, len(barre)):
        manca = int((barre[i][0] - barre[i - 1][0]).total_seconds() // 3600) - 1
        if manca < ORE_BUCO:
            continue
        t, sab = barre[i - 1][0], False
        while t < barre[i][0]:
            if t.weekday() == 5:
                sab = True
                break
            t += dt.timedelta(hours=1)
        if sab and manca <= WEEKEND_MAX_ORE:
            continue
        chiusure.append((barre[i - 1][0], manca))
    giorni = max(1.0, (ultima - prima).total_seconds() / 86400.0)
    tetto = CHIUSURE_PER_365 * giorni / 365.0
    dico("chiusure (buchi >= %d h fuori dal fine settimana normale): %d, tetto %.1f su %.0f giorni (A5)" % (ORE_BUCO, len(chiusure), tetto, giorni))
    for t, m in chiusure[:40]:
        dico("   chiusura dopo %s: %d ore mancanti" % (t.strftime("%Y.%m.%d %H:%M"), m))
    if len(chiusure) > tetto:
        motivi.append("chiusure %d oltre il tetto %.1f (A5)" % (len(chiusure), tetto))
    # --- A4 orologio, per segmento
    segm = {}
    for b in barre:
        if b[0].weekday() >= 5:
            continue
        segm.setdefault(nome_segmento(b[0].date()), []).append(b)
    valutati = {"ESTATE": 0, "INVERNO": 0}
    for nome in sorted(segm, key=lambda k: segm[k][0][0]):
        bs = segm[nome]
        stag = "ESTATE" if nome.startswith("ESTATE") else "INVERNO"
        ngiorni = len(set(b[0].date() for b in bs))
        per_ora = {}
        for b in bs:
            per_ora.setdefault(b[0].hour, []).append((b[2] - b[3]) / b[1])
        med = {h: statistics.median(v) for h, v in per_ora.items() if len(v) >= ORA_MIN_BARRE}
        salti = {h: med[h] / med[h - 1] for h in OROLOGIO_FINESTRA if h in med and (h - 1) in med and med[h - 1] > 0}
        profilo = " ".join("%02d:%.5f" % (h, med[h]) for h in sorted(med))
        if ngiorni < SEG_MIN_GIORNI or len(salti) < 2:
            dico("orologio %s: NON VALUTABILE (%d giorni feriali, %d salti misurabili)" % (nome, ngiorni, len(salti)))
            info["orologio"][nome] = "NON VALUTABILE"
            continue
        ordine = sorted(salti, key=lambda h: salti[h], reverse=True)
        hs, h2 = ordine[0], ordine[1]
        netto = salti[hs] >= OROLOGIO_MARGINE * salti[h2]
        atteso = OROLOGIO_ATTESO[stag]
        if hs == atteso:
            lettura = "UTC+1 FISSO (dichiarato)" if stag == "INVERNO" else "coerente con UTC+1 (d'estate coincide col vecchio orologio)"
        elif hs == atteso + 1:
            lettura = "SPOSTATO DI +1 ORA"
        elif stag == "INVERNO" and hs == 14:
            lettura = "VECCHIO OROLOGIO (UTC+0 d'inverno) o SPOSTATO DI -1 ORA"
        elif hs == atteso - 1:
            lettura = "SPOSTATO DI -1 ORA"
        else:
            lettura = "NON CLASSIFICATO"
        info["orologio"][nome] = lettura
        dico("orologio %s: %d giorni feriali, salto massimo alla barra %02d (x%.2f), secondo alla %02d (x%.2f), atteso %02d -> %s%s" % (
            nome, ngiorni, hs, salti[hs], h2, salti[h2], atteso, lettura, "" if netto else "  [SALTO NON NETTO]"))
        dico("   profilo mediano (high-low)/open per ora server: " + profilo)
        if hs != atteso:
            motivi.append("orologio %s: salto alla barra %02d invece di %02d -> %s (A4)" % (nome, hs, atteso, lettura))
        elif not netto:
            motivi.append("orologio %s: salto alla barra attesa ma NON netto (x%.2f contro x%.2f, margine %.2f) (A4)" % (nome, salti[hs], salti[h2], OROLOGIO_MARGINE))
        else:
            valutati[stag] += 1
    if valutati["ESTATE"] < 1 or valutati["INVERNO"] < 1:
        motivi.append("orologio: segmenti confermati estate %d, inverno %d: serve almeno uno per stagione (A4)" % (valutati["ESTATE"], valutati["INVERNO"]))
    # --- inverni H3, per nome
    for nome in INVERNI_H3:
        a = int(nome[:4])
        da, a_ = dt.date(a, 11, 1), dt.date(a + 1, 3, 31)
        fer = [da + dt.timedelta(days=k) for k in range((a_ - da).days + 1)]
        fer = [g for g in fer if g.weekday() < 5]
        cop = sum(1 for g in fer if g in date_con_barre) / float(len(fer))
        stato = "COPERTO" if cop >= 0.90 else ("ASSENTE" if cop == 0 else "PARZIALE")
        dico("inverno H3 %s (nov-mar): %s (%.0f%% dei giorni feriali con barre)" % (nome, stato, 100 * cop))
    return finale(not motivi, motivi, out, info, stampa)


def finale(ok, motivi, out, info, stampa):
    if stampa:
        for s in out:
            print(s)
        print("")
        for m in motivi:
            print("FAIL: " + m)
        print("VERDETTO: " + ("PASS" if ok else "FAIL (%d motivi)" % len(motivi)))
    return ok, motivi, info


# ------------------------------------------------------------------ autotest: serie sintetica e contro-esempi
PROFILO_ET = {18: .45, 19: .45, 20: .45, 21: .45, 22: .45, 23: .45, 0: .5, 1: .5, 2: .5, 3: .7, 4: .7, 5: .7, 6: .7, 7: .7,
              8: .85, 9: 2.0, 10: 1.7, 11: 1.4, 12: 1.3, 13: 1.3, 14: 1.3, 15: 1.4, 16: .8}
FESTE_ET = {dt.date(2024, 11, 28), dt.date(2024, 12, 25), dt.date(2025, 1, 1), dt.date(2025, 4, 18),
            dt.date(2025, 12, 25), dt.date(2026, 1, 1), dt.date(2026, 4, 3)}


def genera(orologio="utc1", seme=7, da=dt.datetime(2024, 9, 26), a=dt.datetime(2026, 10, 9, 23), run="0123456789ab"):
    """Serie H1 sintetica con il profilo di volatilita' ancorato all'ora di New York. orologio: utc1 | piu1 | eu."""
    rnd = random.Random(seme)
    giorni_dati = set()
    righe = []
    prezzo = 42000.0
    t = da
    while t <= a:
        if orologio == "utc1":
            utc = t - dt.timedelta(hours=1)
        elif orologio == "piu1":
            utc = t - dt.timedelta(hours=2)
        else:
            utc = t - dt.timedelta(hours=1 if ora_legale_eu(t.date()) else 0)
        et = utc - dt.timedelta(hours=4 if ora_legale_usa(utc.date()) else 5)
        chiuso = (et.weekday() == 4 and et.hour >= 17) or et.weekday() == 5 or (et.weekday() == 6 and et.hour < 18) \
            or et.hour == 17 or et.date() in FESTE_ET
        if not chiuso:
            p = PROFILO_ET[et.hour]
            if et.hour == 8:
                if et.date() not in giorni_dati and rnd.random() < 0.3:
                    giorni_dati.add(et.date())
                if et.date() in giorni_dati:
                    p *= 1.6
            o = prezzo
            c = o * (1 + rnd.gauss(0, 0.0004 * p))
            h = max(o, c) + abs(rnd.gauss(0, 0.0006 * p)) * o
            l = min(o, c) - abs(rnd.gauss(0, 0.0006 * p)) * o
            righe.append("%s;%.2f;%.2f;%.2f;%.2f;%d;%d;0" % (t.strftime("%Y.%m.%d %H:%M"), o, h, l, c, rnd.randint(500, 5000), 200))
            prezzo = c
        t += dt.timedelta(hours=1)
    return righe


def componi(righe, run="0123456789ab", testa_extra=(), fine=True, n_fine=None, errori=0):
    testa = [INTESTAZIONE_ATTESA, "#run;" + run, "#simbolo;" + SIMBOLO, "#periodo;H1", "#digits;2", "#point;0.01000000",
             "#feed;BCM Markets Ltd", OROLOGIO_RIGA, "#nota_orologio;sintetico", "#solo_barre_chiuse;si"] + list(testa_extra) + [COLONNE]
    corpo = list(righe)
    if fine:
        p, u = corpo[0][:16], corpo[-1][:16]
        corpo.append("#FINE;n=%d;prima=%s;ultima=%s;errori_copia=%d;scartate=0;motivo_deinit=1" % (len(righe) if n_fine is None else n_fine, p, u, errori))
    return "\r\n".join(testa + corpo) + "\r\n"


def autotest():
    base = genera("utc1")
    def an(righe):
        n = sum(1 for r in righe if ANCORA_DA <= dt.datetime.strptime(r[:16], "%Y.%m.%d %H:%M") <= ANCORA_FINO)
        return (n, ANCORA_DA, ANCORA_FINO)
    ANC = an(base)   # l'ancora del sintetico e' il SUO conteggio: il caso positivo e' banale, i negativi no
    casi = []
    casi.append(("A base UTC+1 fisso", componi(base), True, None, {}))
    piu1 = genera("piu1")
    casi.append(("B feed spostato +1h (stesso n: l'ancora NON lo vede)", componi(piu1), False, "SPOSTATO DI +1 ORA", {"ancora_ok": True}))
    eu = genera("eu")
    casi.append(("C vecchio orologio UTC+0 d'inverno", componi(eu), False, "VECCHIO OROLOGIO", {}))
    rnd = random.Random(11)
    dup = []
    for r in base:
        dup.append(r)
        if rnd.random() < 0.005:
            dup.append(r)
    casi.append(("D 0,5%% di barre doppie (dentro la banda dell'ancora)", componi(dup), False, "NON strettamente crescente", {"ancora_ok": True, "monotonia_ok": False}))
    dup3 = [x for r in base for x in ((r, r) if rnd.random() < 0.03 else (r,))]
    casi.append(("D3 3% di barre doppie", componi(dup3), False, "NON strettamente crescente", {"ancora_ok": False}))
    rotta = list(base)
    c = rotta[500].split(";")
    c[2] = "%.2f" % (float(c[4]) - 5.0)
    rotta[500] = ";".join(c)
    casi.append(("E una barra con high < close", componi(rotta), False, "OHLC incoerente", {}))
    tolti = {dt.date(2025, 7, 15), dt.date(2025, 7, 16), dt.date(2025, 7, 17)}
    buco = [r for r in base if dt.datetime.strptime(r[:16], "%Y.%m.%d %H:%M").date() not in tolti]
    casi.append(("F tre giorni feriali tolti", componi(buco), False, "giorni feriali consecutivi", {}))
    casi.append(("G numero di conto nell'intestazione", componi(base, testa_extra=("#info;50503392",)), False, "NUMERO DI CONTO", {}))
    casi.append(("G2 parola 'login' nell'intestazione", componi(base, testa_extra=("#login;123",)), False, "traccia di CONTO", {}))
    casi.append(("H senza #FINE (troncato)", componi(base, fine=False), False, "righe #FINE: 0", {}))
    casi.append(("I #FINE con n sbagliato", componi(base, n_fine=len(base) + 1), False, "#FINE dice n=", {}))
    casi.append(("J errori_copia 2", componi(base, errori=2), False, "errori_copia=2", {}))
    mezz = [r[:14] + "30" + r[16:] for r in base]
    casi.append(("K barre alle :30", componi(mezz), False, "non allineate all'ora", {}))
    tardi = [r for r in base if r[:10] >= "2024.10.15"]
    casi.append(("L prima barra al 2024.10.15", componi(tardi), False, "piu' recente del 2024.09.26", {}))
    senza_or = componi(base).replace(OROLOGIO_RIGA + "\r\n", "")
    casi.append(("M senza la riga #orologio", senza_or, False, "#orologio;ORA_SERVER", {}))
    casi.append(("N run diverso", componi(base, run="ffffffffffff"), False, "run del CSV", {}))
    meno = [r for r in base if not r[11:13] == "03"]
    casi.append(("O una barra in meno al giorno (sotto i 3 h: la prende l'ancora)", componi(meno), False, "ancora A2 fuori banda", {"ancora_ok": False}))
    venerdi = [r for r in base if not (dt.datetime.strptime(r[:16], "%Y.%m.%d %H:%M").weekday() == 4 and r[11:13] >= "15")]
    casi.append(("P ogni venerdi senza pomeriggio (si fonde col fine settimana: A5 NON lo vede, lo prende l'ancora)", componi(venerdi), False, "ancora A2 fuori banda", {"ancora_ok": False}))
    merc = [r for r in base if not (dt.datetime.strptime(r[:16], "%Y.%m.%d %H:%M").weekday() == 2 and "15" <= r[11:13] <= "17")]
    casi.append(("P2 ogni mercoledi 3 ore tolte (chiusure A5)", componi(merc), False, "chiusure", {}))
    scala = []
    for r in base:
        c = r.split(";")
        scala.append(";".join([c[0]] + ["%.2f" % (float(x) / 10.0) for x in c[1:5]] + c[5:]))
    casi.append(("Q prezzi /10 (un altro simbolo)", componi(scala), False, "banda di prezzo", {}))
    falliti = 0
    for nome, testo, atteso_ok, frase, chiavi in casi:
        ok, motivi, info = collauda(testo, run="0123456789ab", ancora=ANC, stampa=False)
        bene = (ok == atteso_ok) and (frase is None or any(frase in m for m in motivi))
        for k, v in chiavi.items():
            if info.get(k) != v:
                bene = False
        if nome.startswith("B"):
            bene = bene and any(v == "SPOSTATO DI +1 ORA" for v in info["orologio"].values())
        print("%s  %s  -> %s%s" % ("OK " if bene else "KO ", nome, "PASS" if ok else "FAIL", "" if ok else "  [" + "; ".join(motivi)[:160] + "]"))
        if not bene:
            falliti += 1
            for m in motivi:
                print("      " + m)
    print("")
    print("AUTOTEST: %d casi, %d come atteso, %d NO" % (len(casi), len(casi) - falliti, falliti))
    return falliti == 0


def main():
    ap = argparse.ArgumentParser(description="Collaudo del CSV di CLAU12_EXPORT_BARRE_H1 (U30USD H1, feed BCM).")
    ap.add_argument("csv", nargs="?")
    ap.add_argument("--run", default=None, help="i 12 esadecimali della corsa (dal RIEPILOGO.txt)")
    ap.add_argument("--autotest", action="store_true")
    a = ap.parse_args()
    if a.autotest:
        sys.exit(0 if autotest() else 1)
    if not a.csv:
        ap.print_usage()
        sys.exit(2)
    with open(a.csv, "r", encoding="ascii", errors="strict", newline="") as f:
        testo = f.read()
    ok, _, _ = collauda(testo, run=a.run)
    sys.exit(0 if ok else 1)


if __name__ == "__main__":
    main()
