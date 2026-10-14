#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
collaudo_export_barre_dax_h1.py -- il COLLAUDO del CSV scritto da CLAU12_EXPORT_BARRE_H1 su D30EUR (DAX, feed BCM).

COPIA ADATTATA di collaudo_export_barre_h1.py (il collaudo del Dow, SHA256 7AFC123B..., PASS sullo zip dell'11/10/2026),
che NON si tocca: quello resta legato al suo zip. Qui cambiano simbolo, ancora, banda di prezzo, la FIRMA dell'orologio
(apertura cash di Francoforte, non di New York), il calendario delle feste e il modo di contare le chiusure (vedi A5).

USO
  python3 backtest_pipeline/collaudo_export_barre_dax_h1.py <csv> [--run <12 esadecimali>]
  python3 backtest_pipeline/collaudo_export_barre_dax_h1.py --autotest
Esce 0 = PASS (integrita' E orologio), 1 = FAIL d'integrita' (ogni motivo stampato), 4 = integrita' PASS ma orologio
NON confermato (le letture PER ORA del lettore si sospendono, quelle sull'intero periodo no), 2 = errore d'uso.
Non scrive niente. Il lettore backtest_pipeline/leggi_atr_h1_dax.py importa collauda() e ne usa le due meta'.

ATTESE SCRITTE PRIMA DEI NUMERI (14/10/2026), con la fonte
  A1. PRIMA BARRA il 2024.09.26 (+-1 giorno). Fonte: sonda del 17/08/2026,
      backtest_pipeline/risultati_archivio/sonda_storico_17-08/215D85D7_ABTG_InfoBroker.csv, riga D30EUR:
      BarreTF 10553, PrimaDataTF 2024.09.26, Stato COMPLETO. Piu' VECCHIA = AVVISO (notizia); piu' RECENTE = FAIL
      (e per il lettore e' una MISURA MANCANTE, non un errore: lo storico di quel terminale e' corto).
  A2. ANCORA DI CONTEGGIO: 10553 barre H1 con apertura in [2024.09.26 00:00 ; 2026.08.17 17:00] (OraServer della sonda
      2026.08.17 17:34:09; Bars() conta anche la barra in formazione: stessa convenzione che sul Dow ha dato 10859 contro
      10859, +0,00%). Banda +-1% (PROPOSTA, la stessa del Dow). Numero scritto da UN ALTRO strumento.
  A3. RITMO: 10553 / 690,75 giorni x 365,25 = ~5.580 barre per anno di calendario (DERIVATO da A2), cioe' ~21,4 barre per
      giorno feriale (10553 / 493 feriali). Si applica solo agli anni INTERI presenti, ELENCATI PER NOME (oggi: ANNO_2025),
      banda +-5% (PROPOSTA). Finestra della misura 2024.09.26 -> 2026.09.30 = 525 feriali -> ~11.238 barre (DERIVATO).
  A4. OROLOGIO. Firma: l'apertura cash Xetra delle 09:00 di Francoforte. Con BCM indici = UTC+1 FISSO
      (report/OROLOGIO_BCM_2026-09-24.md par. 3.2, e confermato sulle barre del Dow l'11/10:
      report/EXPORT_BARRE_DOW_H1_LETTURA_2026-10-11.md) la barra dell'apertura e' la 08 d'ESTATE UE e la 09 d'INVERNO UE.
      Si cerca, per SEGMENTO di calendario UE (elencato per nome, i giorni lun-ven), l'ora h fra 5 e 12 in cui la mediana
      fa il SALTO piu' grande rispetto all'ora prima, su DUE grandezze indipendenti: (high-low)/open e tick_volume.
      Il segmento e' CONFERMATO solo se le due grandezze danno la STESSA ora, quell'ora e' l'attesa, e il salto supera il
      secondo di almeno il 10% su tutte e due (PROPOSTA). Meno di 40 giorni feriali = NON VALUTABILE.
      Le ALTRE spiegazioni e il numero che producono (classe 178):
        feed spostato di +1 ora                           -> estate 09, inverno 10
        feed spostato di -1 ora                           -> estate 07, inverno 08
        vecchio orologio (IT-1 tutto l'anno, UTC+0 d'inverno) -> estate 08, inverno 08
        il salto e' il PRE-MERCATO (08:00 locali) e non la cash -> estate 07, inverno 08 = come -1 ora: NON distinguibile
      Per questo serve ALMENO un segmento d'inverno confermato: d'estate UTC+1 fisso e vecchio orologio coincidono.
      Che il salto piu' grande sia la cash e non il pre-mercato e' [INFERITO] per analogia col Dow: sul CSV del Dow
      dell'11/10 il salto del tick_volume all'apertura cash e' x2,08-x4,27 per segmento, il secondo (l'ora dei dati
      USA) x1,29-x1,46 (misurato in sessione il 14/10 col collaudo del Dow). Se sul DAX non regge, il collaudo NON boccia
      l'integrita': esce 4 e il lettore sospende le sole letture per ora.
  A5. BUCHI E CHIUSURE, per GIORNO (il DAX ha una pausa serale ogni giorno: un criterio a "buchi di 3 ore" come quello del
      Dow la conterebbe come chiusura ogni sera). Feste Eurex/Xetra ELENCATE PER NOME in FESTE_DAX [DA MEMORIA del
      calendario Eurex: Capodanno, Venerdi' Santo, Lunedi' dell'Angelo, 1 maggio, 24-25-26 e 31 dicembre; NON verificato
      in sessione]. FAIL se 2 o piu' giorni feriali consecutivi senza barre FUORI da quell'elenco. Chiusura = giorno
      feriale fuori elenco senza barre, oppure con 3 o piu' "ore di sessione" mancanti, dove le ore di sessione sono
      quelle presenti in almeno l'80% dei giorni dello stesso (stagione UE, giorno della settimana): la norma la da' il
      file stesso, per stagione e per giorno, e si STAMPA (orario della sessione D30EUR, FATTO dal file). Tetto: 15
      chiusure ogni 365 giorni (PROPOSTA, la stessa del Dow).
  A6. OHLC: high >= max(open, close), low <= min(open, close), tutti > 0; prezzo dentro 15.000-32.000 (DAX 2024-26:
      ~18.500-25.500 [DA MEMORIA], margine largo). Il Dow (42.000-51.000) cade FUORI; il Nasdaq (~17.000-26.000) cade
      DENTRO: un CSV del Nasdaq lo prendono l'intestazione #simbolo (A7) e il nome del file cercato dal driver, non A6.
  A7. FORMA: tempo strettamente crescente, allineato all'ora, nessun doppione; intestazione dell'EA v1.00, simbolo D30EUR,
      periodo H1, '#orologio;ORA_SERVER_DEL_FEED_NON_CONVERTITA', riga #FINE ULTIMA con n = righe di barra ed
      errori_copia = 0; nessuna traccia di CONTO nell'intestazione.
  A8. COPERTURA DELLA FINESTRA DI MISURA (2024.09.26 -> 2026.09.30 inclusa): l'ultima barra deve essere del 2026.10.01 o
      dopo, altrimenti il 30/09 potrebbe essere incompleto (il tester lascia fuori l'ultima barra dell'ultimo giorno:
      Dow 11/10, venerdi 09/10 senza la barra delle 21:00).

CHE COSA LE BANDE NON VEDONO (classe 178, scritto prima):
  - un feed spostato di un'ora ha lo STESSO n: A2 e A3 sono cieche all'orologio -> lo prende solo A4;
  - lo 0,5% di barre doppie sta dentro A2 -> lo prende solo A7;
  - una barra mancante al giorno (-4,7%) sta sotto le 3 ore di A5 -> la prende A2;
  - un venerdi' pomeriggio tagliato: con la norma per giorno della settimana, se manca su TUTTI i venerdi' diventa la
    norma e A5 non lo vede -> lo prende A2 (stesso limite del Dow, scritto qui e provato dall'autotest, caso P).
ASCII puro.
"""
import argparse
import datetime as dt
import random
import statistics
import sys

# ------------------------------------------------------------------ attese (vedi docstring)
VERSIONE_EA = "1.00"
SIMBOLO = "D30EUR"
PRIMA_ATTESA = dt.datetime(2024, 9, 26, 0, 0)
ANCORA_N = 10553
ANCORA_DA = dt.datetime(2024, 9, 26, 0, 0)
ANCORA_FINO = dt.datetime(2026, 8, 17, 17, 0)
ANCORA_TOLL = 0.01
_GIORNI_ANCORA = (ANCORA_FINO - ANCORA_DA).total_seconds() / 86400.0 + 1.0 / 24.0
RITMO_ANNO = ANCORA_N / _GIORNI_ANCORA * 365.25
RITMO_TOLL = 0.05
PREZZO_MIN, PREZZO_MAX = 15000.0, 32000.0
FINE_MISURA = dt.date(2026, 9, 30)
COPERTURA_MIN = dt.datetime(2026, 10, 1, 0, 0)
OROLOGIO_FINESTRA = range(5, 13)
OROLOGIO_ATTESO = {"ESTATE": 8, "INVERNO": 9}
OROLOGIO_MARGINE = 1.10
SEG_MIN_GIORNI = 40
ORA_MIN_BARRE = 20
CHIUSURE_PER_365 = 15.0
ORE_CHIUSURA = 3
QUOTA_SESSIONE = 0.80
INTESTAZIONE_ATTESA = "#CLAU12_EXPORT_BARRE_H1;v" + VERSIONE_EA
OROLOGIO_RIGA = "#orologio;ORA_SERVER_DEL_FEED_NON_CONVERTITA"
COLONNE = "time_server;open;high;low;close;tick_volume;spread;real_volume"
PAROLE_CONTO = ("conto", "account", "login", "balance", "saldo", "equity", "margin")
NUMERI_CONTO = ("50503392", "50504263", "10105439", "50504400", "50503635", "541452707", "1514806751")
FESTE_DAX = {  # [DA MEMORIA] calendario Eurex/Xetra, elencato per nome
    dt.date(2024, 12, 24): "Vigilia 2024", dt.date(2024, 12, 25): "Natale 2024", dt.date(2024, 12, 26): "S.Stefano 2024",
    dt.date(2024, 12, 31): "S.Silvestro 2024", dt.date(2025, 1, 1): "Capodanno 2025", dt.date(2025, 4, 18): "Venerdi Santo 2025",
    dt.date(2025, 4, 21): "Pasquetta 2025", dt.date(2025, 5, 1): "1 maggio 2025", dt.date(2025, 12, 24): "Vigilia 2025",
    dt.date(2025, 12, 25): "Natale 2025", dt.date(2025, 12, 26): "S.Stefano 2025", dt.date(2025, 12, 31): "S.Silvestro 2025",
    dt.date(2026, 1, 1): "Capodanno 2026", dt.date(2026, 4, 3): "Venerdi Santo 2026", dt.date(2026, 4, 6): "Pasquetta 2026",
    dt.date(2026, 5, 1): "1 maggio 2026"}


# ------------------------------------------------------------------ calendario
def ultima_domenica(anno, mese):
    d = dt.date(anno + (mese // 12), mese % 12 + 1, 1) - dt.timedelta(days=1)
    while d.weekday() != 6:
        d -= dt.timedelta(days=1)
    return d


def ora_legale_eu(d):
    """d = data (si usa la data del server: il cambio cade di domenica, quando il DAX e' chiuso)."""
    return ultima_domenica(d.year, 3) <= d < ultima_domenica(d.year, 10)


def stagione(d):
    return "ESTATE" if ora_legale_eu(d) else "INVERNO"


def nome_segmento(d):
    if ora_legale_eu(d):
        return "ESTATE_UE_%d" % d.year
    a = d.year if d.month >= 10 else d.year - 1
    return "INVERNO_UE_%d_%02d" % (a, (a + 1) % 100)


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
            tv = int(c[5]); int(c[6]); int(c[7])
        except ValueError:
            errori.append("riga %d: campo non leggibile: %s" % (i, ln[:60]))
            continue
        barre.append((t, o, h, l, cl, tv))
    if not header_visto:
        errori.append("intestazione delle colonne '%s' assente" % COLONNE)
    return meta, barre, errori


# ------------------------------------------------------------------ orologio: un segmento
def firma_segmento(bs):
    """Ritorna (ngiorni, esito per grandezza) dove esito = (ora del salto, salto, seconda ora, secondo salto) o None."""
    ngiorni = len(set(b[0].date() for b in bs))
    out = {}
    for nome, f in (("escursione", lambda b: (b[2] - b[3]) / b[1]), ("tick_volume", lambda b: float(b[5]))):
        per_ora = {}
        for b in bs:
            per_ora.setdefault(b[0].hour, []).append(f(b))
        med = {h: statistics.median(v) for h, v in per_ora.items() if len(v) >= ORA_MIN_BARRE}
        salti = {h: med[h] / med[h - 1] for h in OROLOGIO_FINESTRA if h in med and (h - 1) in med and med[h - 1] > 0}
        if len(salti) < 2:
            out[nome] = None
            continue
        o = sorted(salti, key=lambda h: salti[h], reverse=True)
        out[nome] = (o[0], salti[o[0]], o[1], salti[o[1]])
    return ngiorni, out


def lettura_ora(stag, hs):
    atteso = OROLOGIO_ATTESO[stag]
    if hs == atteso:
        return "UTC+1 FISSO (dichiarato)" if stag == "INVERNO" else "coerente con UTC+1 (d'estate coincide col vecchio orologio)"
    if hs == atteso + 1:
        return "SPOSTATO DI +1 ORA"
    if stag == "INVERNO" and hs == 8:
        return "VECCHIO OROLOGIO (UTC+0 d'inverno), SPOSTATO DI -1 ORA o PRE-MERCATO"
    if hs == atteso - 1:
        return "SPOSTATO DI -1 ORA o PRE-MERCATO"
    return "NON CLASSIFICATO"


# ------------------------------------------------------------------ i controlli
def collauda(testo, run=None, ancora=None, stampa=True):
    """Ritorna (pass, motivi, info). info: motivi_integrita, motivi_orologio, orologio_ok, barre, ...
    ancora = (n, da, fino) per l'autotest; default = A2."""
    an_n, an_da, an_fino = ancora if ancora else (ANCORA_N, ANCORA_DA, ANCORA_FINO)
    out = []
    mi = []          # motivi d'integrita'
    mo = []          # motivi d'orologio
    info = {"ancora_ok": None, "orologio": {}, "monotonia_ok": None, "orologio_ok": False, "barre": [],
            "motivi_integrita": mi, "motivi_orologio": mo, "prima": None, "ultima": None, "run": None, "simbolo": None,
            "ore_sessione": {}, "storico_corto": False, "finestra_scoperta": False}

    def dico(s):
        out.append(s)

    meta, barre, err = leggi(testo)
    info["barre"] = barre
    mi += err
    righe_meta = [m[1] for m in meta]
    if not righe_meta or righe_meta[0] != INTESTAZIONE_ATTESA:
        mi.append("prima riga diversa da '%s'" % INTESTAZIONE_ATTESA)
    simb = [r[9:] for r in righe_meta if r.startswith("#simbolo;")]
    info["simbolo"] = simb[0] if len(simb) == 1 else None
    for attesa in ("#simbolo;" + SIMBOLO, "#periodo;H1", OROLOGIO_RIGA, "#solo_barre_chiuse;si"):
        if righe_meta.count(attesa) != 1:
            mi.append("riga d'intestazione '%s' presente %d volte invece di 1%s" % (
                attesa, righe_meta.count(attesa), (" (il file dichiara %s)" % ",".join(simb)) if attesa.startswith("#simbolo") else ""))
    runs = [r[5:] for r in righe_meta if r.startswith("#run;")]
    if len(runs) != 1:
        mi.append("righe #run: %d invece di 1" % len(runs))
    else:
        info["run"] = runs[0]
        if run is not None and runs[0] != run:
            mi.append("run del CSV '%s' diverso da quello atteso '%s'" % (runs[0], run))
    for r in righe_meta:
        bassa = r.lower()
        for p in PAROLE_CONTO:
            if p in bassa:
                mi.append("traccia di CONTO nell'intestazione ('%s'): %s" % (p, r[:80]))
        for n in NUMERI_CONTO:
            if n in r:
                mi.append("NUMERO DI CONTO %s nell'intestazione: %s" % (n, r[:80]))
    fine = [m for m in meta if m[1].startswith("#FINE;")]
    if len(fine) != 1:
        mi.append("righe #FINE: %d invece di 1 (file troncato o doppio)" % len(fine))
    else:
        campi = dict(kv.split("=", 1) for kv in fine[0][1].split(";")[1:] if "=" in kv)
        if campi.get("n") != str(len(barre)):
            mi.append("#FINE dice n=%s ma le barre lette sono %d" % (campi.get("n"), len(barre)))
        if campi.get("errori_copia") != "0":
            mi.append("#FINE dice errori_copia=%s (atteso 0)" % campi.get("errori_copia"))
        ultima_riga = [ln for ln in testo.splitlines() if ln.strip() != ""][-1]
        if not ultima_riga.startswith("#FINE;"):
            mi.append("#FINE non e' l'ultima riga del file")
    if not barre:
        mi.append("nessuna barra")
        return finale(False, out, info, stampa)

    # --- A7 forma del tempo
    nondup = sum(1 for i in range(1, len(barre)) if barre[i][0] <= barre[i - 1][0])
    disall = sum(1 for b in barre if b[0].minute != 0 or b[0].second != 0)
    info["monotonia_ok"] = (nondup == 0)
    if nondup:
        mi.append("tempo NON strettamente crescente in %d punti (doppioni o disordine)" % nondup)
    if disall:
        mi.append("%d barre non allineate all'ora (minuti != 00)" % disall)
    # --- A6 OHLC
    rotte = [b for b in barre if not (b[2] >= max(b[1], b[4]) and b[3] <= min(b[1], b[4]) and min(b[1:5]) > 0)]
    if rotte:
        mi.append("%d barre con OHLC incoerente (prima: %s)" % (len(rotte), rotte[0][0].strftime("%Y.%m.%d %H:%M")))
    fuori = [b for b in barre if b[3] < PREZZO_MIN or b[2] > PREZZO_MAX]
    if fuori:
        mi.append("%d barre fuori dalla banda di prezzo %.0f-%.0f (un altro simbolo?)" % (len(fuori), PREZZO_MIN, PREZZO_MAX))

    prima, ultima = barre[0][0], barre[-1][0]
    info["prima"], info["ultima"] = prima, ultima
    dico("barre: %d   prima %s   ultima %s" % (len(barre), prima.strftime("%Y.%m.%d %H:%M"), ultima.strftime("%Y.%m.%d %H:%M")))
    # --- A1
    if prima.date() < PRIMA_ATTESA.date() - dt.timedelta(days=1):
        dico("AVVISO (A1): la prima barra e' PIU' VECCHIA del 2024.09.26 misurato il 17/08: storico piu' profondo, da rimisurare con la sonda")
    elif prima.date() > PRIMA_ATTESA.date() + dt.timedelta(days=1):
        info["storico_corto"] = True
        mi.append("prima barra %s: piu' recente del 2024.09.26 (+-1 giorno) misurato il 17/08 (A1): storico CORTO" % prima.strftime("%Y.%m.%d"))
    # --- A8
    if ultima < COPERTURA_MIN:
        info["finestra_scoperta"] = True
        mi.append("ultima barra %s: prima del %s, il 30/09/2026 puo' essere incompleto (A8)" % (
            ultima.strftime("%Y.%m.%d %H:%M"), COPERTURA_MIN.strftime("%Y.%m.%d")))
    n_misura = sum(1 for b in barre if b[0].date() <= FINE_MISURA)
    dico("barre nella finestra di misura 2024.09.26 -> 2026.09.30: %d (attese ~11.238 dal ritmo della sonda, DERIVATO)" % n_misura)
    # --- A2
    if ultima >= an_fino:
        n_an = sum(1 for b in barre if an_da <= b[0] <= an_fino)
        scarto = (n_an - an_n) / float(an_n)
        info["ancora_ok"] = abs(scarto) <= ANCORA_TOLL
        dico("ancora A2: barre in [%s ; %s] = %d contro %d della sonda (%+.2f%%, banda +-%.0f%%)" % (
            an_da.strftime("%Y.%m.%d %H:%M"), an_fino.strftime("%Y.%m.%d %H:%M"), n_an, an_n, 100 * scarto, 100 * ANCORA_TOLL))
        if not info["ancora_ok"]:
            mi.append("ancora A2 fuori banda: %d contro %d (%+.2f%%)" % (n_an, an_n, 100 * scarto))
    else:
        mi.append("il CSV finisce prima del %s: l'ancora A2 non e' verificabile" % an_fino.strftime("%Y.%m.%d %H:%M"))
    # --- A3 (il ritmo e' DERIVATO dall'ancora in uso: quella della sonda, o quella del sintetico nell'autotest)
    ritmo = an_n / ((an_fino - an_da).total_seconds() / 86400.0 + 1.0 / 24.0) * 365.25
    per_anno = {}
    for b in barre:
        per_anno[b[0].year] = per_anno.get(b[0].year, 0) + 1
    for a in sorted(per_anno):
        intero = prima <= dt.datetime(a, 1, 1, 0, 0) and ultima >= dt.datetime(a, 12, 31, 0, 0)
        if intero:
            lo, hi = ritmo * (1 - RITMO_TOLL), ritmo * (1 + RITMO_TOLL)
            esito = "OK" if lo <= per_anno[a] <= hi else "FUORI"
            dico("ANNO_%d (intero): %d barre, attese %.0f-%.0f (A3) -> %s" % (a, per_anno[a], lo, hi, esito))
            if esito != "OK":
                mi.append("ANNO_%d: %d barre fuori da %.0f-%.0f (A3)" % (a, per_anno[a], lo, hi))
        else:
            dico("ANNO_%d (parziale): %d barre (A3 non si applica)" % (a, per_anno[a]))
    # --- A5 giorni, per nome
    ore_giorno = {}
    for b in barre:
        ore_giorno.setdefault(b[0].date(), set()).add(b[0].hour)
    feriali = []
    d = prima.date()
    while d <= ultima.date():
        if d.weekday() < 5:
            feriali.append(d)
        d += dt.timedelta(days=1)
    vuoti = [g for g in feriali if g not in ore_giorno]
    vuoti_fuori = [g for g in vuoti if g not in FESTE_DAX]
    feste_con_barre = [g for g in feriali if g in FESTE_DAX and g in ore_giorno]
    dico("feste dell'elenco SENZA barre: %s" % (", ".join("%s (%s)" % (g.strftime("%Y.%m.%d"), FESTE_DAX[g]) for g in vuoti if g in FESTE_DAX) or "nessuna"))
    dico("feste dell'elenco CON barre (BCM quota lo stesso, FATTO): %s" % (", ".join("%s (%d barre)" % (g.strftime("%Y.%m.%d"), len(ore_giorno[g])) for g in feste_con_barre) or "nessuna"))
    dico("giorni feriali senza barre FUORI dall'elenco delle feste (%d): %s" % (len(vuoti_fuori), ", ".join(g.strftime("%Y.%m.%d") for g in vuoti_fuori) or "nessuno"))
    serie = []
    for g in vuoti_fuori:
        if serie and serie[-1][-1] + dt.timedelta(days=1 if g.weekday() > 0 else 3) == g:
            serie[-1].append(g)
        else:
            serie.append([g])
    for s in serie:
        if len(s) >= 2:
            mi.append("BUCO: %d giorni feriali consecutivi senza barre, fuori dalle feste, da %s a %s (A5)" % (
                len(s), s[0].strftime("%Y.%m.%d"), s[-1].strftime("%Y.%m.%d")))
    # norma per (stagione, giorno della settimana): ore presenti in almeno QUOTA_SESSIONE dei giorni con barre
    gruppi = {}
    for g in feriali:
        if g in ore_giorno and g not in FESTE_DAX:
            gruppi.setdefault((stagione(g), g.weekday()), []).append(g)
    norma = {}
    for k, gs in gruppi.items():
        conta = {}
        for g in gs:
            for h in ore_giorno[g]:
                conta[h] = conta.get(h, 0) + 1
        norma[k] = set(h for h, c in conta.items() if c >= QUOTA_SESSIONE * len(gs))
    nomi_gg = ["lun", "mar", "mer", "gio", "ven"]
    for stg in ("ESTATE", "INVERNO"):
        pezzi = []
        for wd in range(5):
            o = sorted(norma.get((stg, wd), set()))
            pezzi.append("%s %s" % (nomi_gg[wd], ("%02d-%02d (%d ore)" % (o[0], o[-1], len(o))) if o else "-"))
        info["ore_sessione"][stg] = {wd: sorted(norma.get((stg, wd), set())) for wd in range(5)}
        dico("ore di sessione %s (presenti in >= %.0f%% dei giorni, FATTO dal file): %s" % (stg, 100 * QUOTA_SESSIONE, "; ".join(pezzi)))
    chiusure = []
    for g in feriali:
        if g in FESTE_DAX:
            continue
        nrm = norma.get((stagione(g), g.weekday()), set())
        presenti = ore_giorno.get(g, set())
        manca = len(nrm - presenti)
        if g not in ore_giorno or manca >= ORE_CHIUSURA:
            chiusure.append((g, manca, len(presenti)))
    giorni = max(1.0, (ultima - prima).total_seconds() / 86400.0)
    tetto = CHIUSURE_PER_365 * giorni / 365.0
    dico("chiusure (giorni fuori elenco con >= %d ore di sessione mancanti): %d, tetto %.1f su %.0f giorni (A5)" % (ORE_CHIUSURA, len(chiusure), tetto, giorni))
    for g, m, p in chiusure[:40]:
        dico("   chiusura %s (%s): %d ore di sessione mancanti, %d barre" % (g.strftime("%Y.%m.%d"), nomi_gg[g.weekday()], m, p))
    if len(chiusure) > tetto:
        mi.append("chiusure %d oltre il tetto %.1f (A5)" % (len(chiusure), tetto))

    # --- A4 orologio, per segmento UE (non tocca l'integrita')
    segm = {}
    for b in barre:
        if b[0].weekday() >= 5:
            continue
        segm.setdefault(nome_segmento(b[0].date()), []).append(b)
    confermati = {"ESTATE": 0, "INVERNO": 0}
    for nome in sorted(segm, key=lambda k: segm[k][0][0]):
        stg = "ESTATE" if nome.startswith("ESTATE") else "INVERNO"
        ngiorni, f = firma_segmento(segm[nome])
        if ngiorni < SEG_MIN_GIORNI or f["escursione"] is None or f["tick_volume"] is None:
            dico("orologio %s: NON VALUTABILE (%d giorni feriali)" % (nome, ngiorni))
            info["orologio"][nome] = "NON VALUTABILE"
            continue
        e, t = f["escursione"], f["tick_volume"]
        atteso = OROLOGIO_ATTESO[stg]
        dico("orologio %s: %d giorni feriali; escursione salto max alla %02d (x%.2f, secondo %02d x%.2f); tick_volume salto max alla %02d (x%.2f, secondo %02d x%.2f); atteso %02d" % (
            nome, ngiorni, e[0], e[1], e[2], e[3], t[0], t[1], t[2], t[3], atteso))
        if e[0] != t[0]:
            info["orologio"][nome] = "NON CONCORDE"
            mo.append("orologio %s: le due grandezze NON concordano (escursione %02d, tick_volume %02d) (A4)" % (nome, e[0], t[0]))
            continue
        lettura = lettura_ora(stg, e[0])
        netto = e[1] >= OROLOGIO_MARGINE * e[3] and t[1] >= OROLOGIO_MARGINE * t[3]
        info["orologio"][nome] = lettura
        dico("   -> %s%s" % (lettura, "" if netto else "  [SALTO NON NETTO]"))
        if e[0] != atteso:
            mo.append("orologio %s: salto alla barra %02d invece di %02d -> %s (A4)" % (nome, e[0], atteso, lettura))
        elif not netto:
            mo.append("orologio %s: salto alla barra attesa ma NON netto (margine %.2f) (A4)" % (nome, OROLOGIO_MARGINE))
        else:
            confermati[stg] += 1
    if confermati["ESTATE"] < 1 or confermati["INVERNO"] < 1:
        mo.append("orologio: segmenti confermati estate %d, inverno %d: serve almeno uno per stagione (A4)" % (confermati["ESTATE"], confermati["INVERNO"]))
    info["orologio_ok"] = not mo
    return finale(not mi and not mo, out, info, stampa)


def finale(ok, out, info, stampa):
    motivi = list(info["motivi_integrita"]) + list(info["motivi_orologio"])
    if stampa:
        for s in out:
            print(s)
        print("")
        for m in info["motivi_integrita"]:
            print("FAIL (integrita'): " + m)
        for m in info["motivi_orologio"]:
            print("NON CONFERMATO (orologio): " + m)
        print("INTEGRITA': " + ("PASS" if not info["motivi_integrita"] else "FAIL (%d motivi)" % len(info["motivi_integrita"])))
        print("OROLOGIO : " + ("CONFERMATO UTC+1 FISSO" if info["orologio_ok"] else "NON CONFERMATO: le letture PER ORA del lettore si sospendono"))
        print("VERDETTO: " + ("PASS" if ok else ("FAIL" if info["motivi_integrita"] else "PASS SOLO INTEGRITA' (esce 4)")))
    return ok, motivi, info


# ------------------------------------------------------------------ autotest: serie sintetica e contro-esempi
# profilo per ORA LOCALE DI FRANCOFORTE (escursione, tick): sessione 01-21 locali [INFERITO dall'orario FDAX 01:10-22:00]
PROFILO_LOC = {1: .45, 2: .4, 3: .4, 4: .4, 5: .45, 6: .5, 7: .6, 8: .9, 9: 2.2, 10: 1.6, 11: 1.2, 12: 1.0, 13: 1.0,
               14: 1.2, 15: 1.6, 16: 1.4, 17: 1.1, 18: .8, 19: .7, 20: .7, 21: .6}


def genera(orologio="utc1", seme=7, da=dt.datetime(2024, 9, 26, 8), a=dt.datetime(2026, 10, 13, 23), run="0123456789ab",
           prezzo0=19000.0, profilo=None):
    """Serie H1 sintetica ancorata all'ora di Francoforte. orologio: utc1 | vecchio | piu1 | meno1."""
    prof = profilo or PROFILO_LOC
    rnd = random.Random(seme)
    righe = []
    prezzo = prezzo0
    t = da
    while t <= a:
        if orologio == "utc1":
            utc = t - dt.timedelta(hours=1)
        elif orologio == "piu1":
            utc = t - dt.timedelta(hours=2)
        elif orologio == "meno1":
            utc = t
        else:  # vecchio: server = ora italiana - 1
            utc = t - dt.timedelta(hours=1) if ora_legale_eu(t.date()) else t
        loc = utc + dt.timedelta(hours=2 if ora_legale_eu(utc.date()) else 1)
        aperto = loc.weekday() < 5 and loc.hour in prof and loc.date() not in FESTE_DAX
        if aperto:
            p = prof[loc.hour]
            o = prezzo
            c = o * (1 + rnd.gauss(0, 0.0007 * p))
            h = max(o, c) + abs(rnd.gauss(0, 0.0009 * p)) * o
            l = min(o, c) - abs(rnd.gauss(0, 0.0009 * p)) * o
            tv = max(1, int(rnd.gauss(3000 * p * p, 300 * p)))
            righe.append("%s;%.2f;%.2f;%.2f;%.2f;%d;%d;0" % (t.strftime("%Y.%m.%d %H:%M"), o, h, l, c, tv, 170))
            prezzo = c
        t += dt.timedelta(hours=1)
    return righe


def componi(righe, run="0123456789ab", testa_extra=(), fine=True, n_fine=None, errori=0, simbolo=SIMBOLO):
    testa = [INTESTAZIONE_ATTESA, "#run;" + run, "#simbolo;" + simbolo, "#periodo;H1", "#digits;2", "#point;0.01000000",
             "#feed;MetaTrader Tester Inc", OROLOGIO_RIGA, "#nota_orologio;sintetico", "#solo_barre_chiuse;si"] + list(testa_extra) + [COLONNE]
    corpo = list(righe)
    if fine:
        p, u = corpo[0][:16], corpo[-1][:16]
        corpo.append("#FINE;n=%d;prima=%s;ultima=%s;errori_copia=%d;scartate=0;motivo_deinit=1" % (len(righe) if n_fine is None else n_fine, p, u, errori))
    return "\r\n".join(testa + corpo) + "\r\n"


def _t(r):
    return dt.datetime.strptime(r[:16], "%Y.%m.%d %H:%M")


def autotest():
    base = genera("utc1")

    def an(righe):
        n = sum(1 for r in righe if ANCORA_DA <= _t(r) <= ANCORA_FINO)
        return (n, ANCORA_DA, ANCORA_FINO)
    ANC = an(base)   # l'ancora del sintetico e' il SUO conteggio: il caso positivo e' banale, i negativi no
    casi = []
    # (nome, testo, esito atteso: "PASS" | "FAIL" | "OROLOGIO", frase attesa in un motivo, chiavi di info)
    casi.append(("A base UTC+1 fisso", componi(base), "PASS", None, {"orologio_ok": True}))
    casi.append(("B feed spostato +1h (stesso n: l'ancora NON lo vede)", componi(genera("piu1")), "OROLOGIO", "SPOSTATO DI +1 ORA", {"ancora_ok": True}))
    casi.append(("C vecchio orologio IT-1 tutto l'anno", componi(genera("vecchio")), "OROLOGIO", "VECCHIO OROLOGIO", {}))
    casi.append(("C2 feed spostato -1h", componi(genera("meno1")), "OROLOGIO", "SPOSTATO DI -1 ORA", {}))
    pre = dict(PROFILO_LOC)
    pre[8], pre[9] = 2.0, 2.2   # pre-mercato quasi come la cash: il salto piu' grande diventa quello delle 08 locali
    pre[7] = .5
    casi.append(("C3 il salto e' il PRE-MERCATO (firma diversa): integrita' PASS, orologio NON confermato", componi(genera("utc1", profilo=pre)), "OROLOGIO", "PRE-MERCATO", {}))
    rnd = random.Random(11)
    dup = []
    for r in base:
        dup.append(r)
        if rnd.random() < 0.005:
            dup.append(r)
    casi.append(("D 0,5% di barre doppie (dentro la banda dell'ancora)", componi(dup), "FAIL", "NON strettamente crescente", {"ancora_ok": True, "monotonia_ok": False}))
    rotta = list(base)
    c = rotta[500].split(";")
    c[2] = "%.2f" % (float(c[4]) - 5.0)
    rotta[500] = ";".join(c)
    casi.append(("E una barra con high < close", componi(rotta), "FAIL", "OHLC incoerente", {}))
    tolti = {dt.date(2025, 7, 15), dt.date(2025, 7, 16), dt.date(2025, 7, 17)}
    casi.append(("F tre giorni feriali tolti (fuori dalle feste)", componi([r for r in base if _t(r).date() not in tolti]), "FAIL", "giorni feriali consecutivi", {}))
    casi.append(("F2 le feste di Natale 24-26/12 vuote NON sono un buco (sono in elenco)", componi(base), "PASS", None, {}))
    casi.append(("G numero di conto nell'intestazione", componi(base, testa_extra=("#info;50503392",)), "FAIL", "NUMERO DI CONTO", {}))
    casi.append(("H senza #FINE (troncato)", componi(base, fine=False), "FAIL", "righe #FINE: 0", {}))
    casi.append(("I #FINE con n sbagliato", componi(base, n_fine=len(base) + 1), "FAIL", "#FINE dice n=", {}))
    casi.append(("J errori_copia 2", componi(base, errori=2), "FAIL", "errori_copia=2", {}))
    casi.append(("K barre alle :30", componi([r[:14] + "30" + r[16:] for r in base]), "FAIL", "non allineate all'ora", {}))
    casi.append(("L storico corto: prima barra al 2025.06.02 (misura mancante)", componi([r for r in base if r[:10] >= "2025.06.02"]), "FAIL", "storico CORTO", {}))
    casi.append(("M senza la riga #orologio", componi(base).replace(OROLOGIO_RIGA + "\r\n", ""), "FAIL", "#orologio;ORA_SERVER", {}))
    casi.append(("N run diverso", componi(base, run="ffffffffffff"), "FAIL", "run del CSV", {}))
    casi.append(("O una barra in meno al giorno (sotto le 3 ore: la prende l'ancora)", componi([r for r in base if r[11:13] != "03"]), "FAIL", "ancora A2 fuori banda", {"ancora_ok": False}))
    ven = [r for r in base if not (_t(r).weekday() == 4 and r[11:13] >= "15")]
    casi.append(("P ogni venerdi' senza pomeriggio (diventa la NORMA: A5 non lo vede, lo prende l'ancora)", componi(ven), "FAIL", "ancora A2 fuori banda", {"ancora_ok": False}))
    mer = [r for r in base if not (_t(r).day in (15, 16) and "12" <= r[11:13] <= "15")]
    casi.append(("P2 4 ore tolte nei giorni 15 e 16 di ogni mese (~7% di ogni gruppo: chiusure A5 oltre il tetto)", componi(mer), "FAIL", "chiusure", {}))
    dow = []
    for r in base:
        c = r.split(";")
        dow.append(";".join([c[0]] + ["%.2f" % (float(x) * 2.3) for x in c[1:5]] + c[5:]))
    casi.append(("Q prezzi del Dow (x2,3) sotto l'intestazione D30EUR", componi(dow), "FAIL", "banda di prezzo", {}))
    casi.append(("R intestazione #simbolo;NASUSD (prezzi nella banda del DAX)", componi(base, simbolo="NASUSD"), "FAIL", "#simbolo;D30EUR", {}))
    casi.append(("S finisce il 2026.09.30 22:00 (30/09 forse incompleto)", componi([r for r in base if _t(r) <= dt.datetime(2026, 9, 30, 22)]), "FAIL", "(A8)", {}))
    falliti = 0
    for nome, testo, atteso, frase, chiavi in casi:
        ok, motivi, info = collauda(testo, run="0123456789ab", ancora=ANC, stampa=False)
        esito = "PASS" if ok else ("FAIL" if info["motivi_integrita"] else "OROLOGIO")
        bene = (esito == atteso) and (frase is None or any(frase in m for m in motivi))
        for k, v in chiavi.items():
            if info.get(k) != v:
                bene = False
        print("%s  %s  -> %s%s" % ("OK " if bene else "KO ", nome, esito, "" if ok else "  [" + "; ".join(motivi)[:170] + "]"))
        if not bene:
            falliti += 1
            for m in motivi:
                print("      " + m)
    print("")
    print("AUTOTEST: %d casi, %d come atteso, %d NO" % (len(casi), len(casi) - falliti, falliti))
    return falliti == 0


def main():
    ap = argparse.ArgumentParser(description="Collaudo del CSV di CLAU12_EXPORT_BARRE_H1 su D30EUR H1, feed BCM.")
    ap.add_argument("csv", nargs="?")
    ap.add_argument("--run", default=None, help="i 12 esadecimali della corsa (dal RIEPILOGO.txt)")
    ap.add_argument("--autotest", action="store_true")
    a = ap.parse_args()
    if a.autotest:
        sys.exit(0 if autotest() else 1)
    if not a.csv:
        ap.print_usage()
        sys.exit(2)
    with open(a.csv, "rb") as f:
        grezzo = f.read()
    try:
        testo = grezzo.decode("ascii")
    except UnicodeDecodeError as e:
        print("FAIL: il CSV non e' ASCII puro (byte %d): l'EA scrive FILE_ANSI con soli caratteri ASCII" % e.start)
        print("VERDETTO: FAIL")
        sys.exit(1)
    ok, _, info = collauda(testo, run=a.run)
    sys.exit(0 if ok else (1 if info["motivi_integrita"] else 4))


if __name__ == "__main__":
    main()
