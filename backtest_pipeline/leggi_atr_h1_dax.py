#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
leggi_atr_h1_dax.py -- il LETTORE dell'ATR(14) H1 del DAX (D30EUR, feed BCM) dal CSV di CLAU12_EXPORT_BARRE_H1.

USO
  python3 backtest_pipeline/leggi_atr_h1_dax.py <csv> --riepilogo <RIEPILOGO.txt> --pin <40 esadecimali della riga>
  python3 backtest_pipeline/leggi_atr_h1_dax.py <csv> --esplora          (nessun controllo di provenienza: NESSUN verdetto)
  python3 backtest_pipeline/leggi_atr_h1_dax.py --autotest
Esce 0 = misura letta (verdetto stampato), 1 = RIFIUTO (provenienza, integrita', simbolo), 3 = MISURA MANCANTE
(storico D30EUR del terminale piu' corto della finestra: non e' un errore, e' un numero che manca), 2 = errore d'uso.
Non scrive niente.

PERCHE' (14/10/2026, si' di Claudio alla misura a costo zero)
  Il nostro ATR(14) H1 del DAX, 53,6 punti indice, e' DERIVATO: ATR(14) M15 26,8 (riconciliazione 25,7-29,2) x sqrt(4),
  mai letto con iATR (report/APERTURE_DAX_MAPPA_2026-10-03.md par. 3.2; report/ATR_DAX_M30_RICONCILIAZIONE_2026-09-17.md).
  Nella live del 14/10 Emiliano legge ATR(H1) 37 (r.261), Luca 40 (r.523), ATR(M15) 26 (r.263), e lo stop "ATR + 4" = 41
  (r.285) (report/ANALISI_LIVE_EMILIANO_2026-10-14.md, N1). La riga H1 del cancello di costo della mappa (stop RANGE_FADE
  = 1,5 x ATR, spread BCM 1,70) da' 80,4 / 1,70 = 47,3x con 53,6; con 37-40 darebbe 55,5-60 / 1,70 = 32,6-35,3x, SOTTO
  la frontiera di casa 40x. Emiliano e' UN istante di UNA mattina ("adesso e' 37, magari tra poco sara' 22"), e l'ATR(14)
  H1 copre 14 ore: al mattino quelle ore sono quasi tutte notte.

DEFINIZIONE (dichiarata): l'ATR di MetaTrader 5 (indicatore ATR.mq5 di MetaQuotes, la stessa serie di iATR):
  TR[i]  = max(high[i], close[i-1]) - min(low[i], close[i-1])         per i >= 1 (la barra 0 non entra)
  ATR[i] = (TR[i-13] + ... + TR[i]) / 14                               per i >= 14: MEDIA SEMPLICE, non la media di Wilder
  (in ATR.mq5: primo valore = media di TR[1..14], poi ATR[i] = ATR[i-1] + (TR[i] - TR[i-14]) / 14, identico).
  [DA MEMORIA del sorgente ATR.mq5: non riletto in sessione; l'autotest verifica che le due scritture coincidano.]
  Conseguenze dichiarate, uguali a iATR: la "barra prima" e' la riga prima nel file, NON l'ora prima: il TR della prima
  barra del lunedi' contiene il buco del fine settimana, quello della prima barra dopo una festa il buco della festa, e una
  barra mancante non esiste per l'ATR (non vale zero). L'ATR si calcola sull'intera serie esportata; le statistiche
  usano solo le barre con apertura in 2024.09.26 -> 2026.09.30 INCLUSA, giorni feriali, con ATR definito.
  Unita': punti indice (= prezzo; D30EUR digits 2, "idx = punti MT5 / 100"), la stessa della mappa.
  "ATR alla barra h" = valore dell'indicatore a barra h CHIUSA (= quello che iATR(...,1) mostra durante l'ora h+1).
  Percentili: interpolazione lineare fra i due ranghi vicini (statistics.quantiles, method='inclusive').

ATTESE SCRITTE PRIMA DEI NUMERI (14/10/2026), ognuna col numero dell'alternativa
  E1. MEDIANA DELL'ATR(14) H1 SU TUTTO IL PERIODO (tutte le ore, giorni feriali). Partizione della retta, scritta prima:
        <= 42,0          SOVRASTIMA: la scala sqrt(T) sovrastima; la riga H1 del cancello scende sotto 40x
                         (1,5 x 42 / 1,70 = 37,1x). Numero dell'alternativa "Emiliano descrive il valore tipico": 37-40.
        (42,0 ; 48,0)    ZONA GRIGIA (dentro c'e' la frontiera: ATR 45,33 = 40 x 1,70 / 1,5).
        [48,0 ; 60,0]    IL DERIVATO REGGE (banda attorno a 53,6; 1,5 x 48 / 1,70 = 42,4x).
        > 60,0           SOPRA LA BANDA: il derivato SOTTOSTIMA.
      Numero dell'altra spiegazione, "Emiliano vede un'ora bassa" [INFERITO, aritmetica d'esempio, non misura]: con una
      notte a ~0,4 e una sera a ~0,6 della volatilita' del giorno, l'ATR(14) letto alle 08:30-10:00 IT copre ~9 ore di notte e
      ~5 di sera e vale ~0,7-0,75 della media su tutte le ore: con la mediana a 53,6 darebbe ~37-40 al mattino. Quindi
      questa spiegazione PREDICE E1 in [48 ; 60] E E2 <= 44; la "sovrastima" predice E1 <= 42 (e E2 ancora piu' basso).
      Distorsione dichiarata: il 53,6 viene da un ADR (MEDIA delle escursioni giornaliere), l'ATR ha coda a destra:
      la MEDIANA sta sotto la media. Si stampano tutte e due; il verdetto E1 e' sulla mediana (compito del 14/10).
      ANALOGO GIA' MISURATO SUL DOW (14/10, prima di qualunque numero del DAX, con QUESTE funzioni sul CSV dell'11/10,
      backtest_pipeline/risultati_archivio/EXPORT_BARRE_DOW_H1_20261011/U30USD_H1_91fbb7cf1900.csv, stessa finestra fino al
      30/09, giorni feriali): ATR(14) H1 di U30USD mediana 94,56, media 105,81 (n 11521); per ora: minimo 62,63 alla barra
      12, massimo 121,71 alla barra 00; minimo / mediana = 0,662. La "validazione a -1%" della scala sqrt(T) sul Dow
      (report/ATR_DAX_M30_RICONCILIAZIONE_2026-09-17.md par. 3: 77,5 contro 78,0-88,2) era contro ATR letti AGLI INGRESSI
      della sedia, non su tutte le ore: contro la mediana di tutte le ore il 77,5 sta SOTTO del 18% (94,56 / 77,5 = 1,22).
      Portato sul DAX [INFERITO: altro simbolo, altre ore di sessione]: E1 ~ 53,6 x 1,22 = 65,4 -> SOPRA LA BANDA, e il
      minimo del giorno ~ 0,662 x E1 = 35,5 (se E1 = 53,6) - 43,3 (se E1 = 65,4). Quindi il ramo "> 60" NON e' un ramo
      teorico: e' quello che il Dow predice, e la lettura di Emiliano starebbe vicino al minimo del giorno in tutti e due.
  E2. "COME LO VEDE UN TRADER ALLE 08:30-10:00 ITALIANE" (la live: file LIVE_EMILIANO_14.10.26_2026-10-14_08-30-00,
      "c'e' l'apertura tra cinque minuti" a r.101): ATR alle barre CHIUSE delle 07:00 e 08:00 IT (le ultime chiuse in
      quella finestra: e' l'ATR(14) che copre la notte) = barre 06 e 07 server d'ESTATE UE, 07 e 08 d'INVERNO UE
      (corretto dal cancello il 14/10: la prima stesura diceva "08:30-10:00 SERVER, barre 7 e 8" fisse, che d'estate
      mettono dentro la barra 08 server CHIUSA = l'apertura Xetra, mai vista chiusa da chi legge alle 09:00-10:00 IT).
      Partizione (bande della scheda N1, scritte li' per la barra delle 09:00
      italiane): < 33 SOTTO EMILIANO; [33 ; 44] NELLA BANDA DI EMILIANO; (44 ; 50) GRIGIA; [50 ; 57] NELLA BANDA DEL
      DERIVATO; > 57 SOPRA. Si stampa anche la FORCHETTA della barra in formazione (Emiliano legge di giorno, a barra
      aperta: barre delle 08:00 e 09:00 IT = 07 e 08 server d'estate, 08 e 09 d'inverno): valore mostrato fra (somma dei
      13 TR chiusi)/14 e l'ATR a barra chiusa.
  E3. "09:00 ITALIANE" (scheda N1): con l'orologio UTC+1 fisso la barra delle 09:00 italiane e' la 08 server d'ESTATE UE
      e la 09 d'INVERNO UE. Si stampa l'ATR alla barra delle 09:00 IT chiusa (contiene il TR dell'apertura cash) e alla
      barra delle 08:00 IT chiusa (quello mostrato fra le 09:00 e le 10:00), con le bande della scheda: H0 50-57,
      smentita 33-44 (stessa partizione di E2).
  E4. PER ORA SERVER (0-23): mediana e n. Attesa [INFERITO]: minimo fra le 5 e le 8 (la finestra di 14 ore e' tutta
      notte), massimo nel pomeriggio (la finestra contiene la cash e l'apertura USA). Se il minimo e' di pomeriggio, la
      spiegazione "finestra notturna" e' SMENTITA.
  E5. PER MESE: la stagionalita' e i regimi (aprile 2025 [INFERITO alto]). Nessuna soglia: si legge e basta.
  E6. CANCELLO DI COSTO H1 (mappa par. 3.2): stop = 1,5 x ATR (RANGE_FADE) e 2,5 x ATR (770411), diviso per lo spread
      BCM 1,70 e FTMO 1,23. Controllo di riproduzione PRIMA dei numeri: 53,6 -> 47,3x / 65,4x e 78,8x / 108,9x come la
      riga H1 della mappa (se non torna, il lettore si ferma). Piu' la QUOTA delle letture sopra la frontiera (ATR >= 45,33)
      e, per ora d'ingresso, lo spread mediano DI QUELL'ORA (spread_orario_D30EUR.csv, tick 2024.09.26-2026.06.30,
      stagioni miste [MISURATO]) con l'ATR della barra chiusa prima.
  REGOLE DI LETTURA: le letture PER ORA (E2, E3, E4, il mattino della live) dipendono dall'orologio; se il collaudo non
  lo conferma (esce 4) si stampano con la scritta SOSPESA e non danno verdetto. E1, E5, E6 sull'intero periodo NON
  dipendono dall'orologio e restano. La provenienza (classe 1381) si verifica PRIMA di qualunque numero: pin della riga,
  SHA256 dell'EA e del .ini, run, SHA256 del CSV e STATO nel RIEPILOGO; se uno non torna: RIFIUTO, non una lettura.
  Il mattino della live (14/10/2026): se il CSV arriva fin li' (lancio dal 15/10), si stampano le barre 5-10 server di
  quel giorno; e' UN giorno: e' una taratura dello strumento (la stessa grandezza di Emiliano?), non una misura.
ASCII puro.
"""
import argparse
import datetime as dt
import hashlib
import os
import random
import re
import statistics
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import collaudo_export_barre_dax_h1 as COLL  # noqa: E402

PERIODO = 14
DA_MISURA = dt.date(2024, 9, 26)
A_MISURA = dt.date(2026, 9, 30)
ATR_DERIVATO = 53.6
ATR_M15_DERIVATO = 26.8
EMILIANO_H1 = (37.0, 40.0)
SPREAD_BCM = 1.70
SPREAD_FTMO = 1.23
FRONTIERA = 40.0
DURO = 13.3
K_FADE = 1.5
K_770411 = 2.5
SOGLIA_BASSA = 42.0
SOGLIA_ALTA = 48.0
TETTO_BANDA = 60.0
ATR_FRONTIERA = FRONTIERA * SPREAD_BCM / K_FADE      # 45,33
RIGA_MAPPA = {"fade_bcm": 47.3, "fade_ftmo": 65.4, "g770411_bcm": 78.8, "g770411_ftmo": 108.9}
SHA_EA_ATTESO = "2F65C46067E4B9E0E868D974BE94C1239FD9CB01C5A62FD2DA6D0A055CD1523D"
SHA_INI_ATTESO = "2D2ABFBBCA6892908A4C15596F59E868B9E2D1C0D4278A07A9AE2BE1A66A04E1"
LIVE = dt.date(2026, 10, 14)
# mediana dello spread per ora server, punti indice: backtest_pipeline/risultati_archivio/spread_flotta/spread_orario_D30EUR.csv
SPREAD_ORA = {0: 3.8, 1: 3.9, 2: 3.7, 3: 3.6, 4: 3.5, 5: 3.5, 6: 3.7, 7: 2.8, 8: 1.7, 9: 1.7, 10: 1.7, 11: 1.6, 12: 1.6,
              13: 1.6, 14: 1.7, 15: 1.7, 16: 1.7, 17: 2.6, 18: 2.7, 19: 2.7, 20: 2.7, 21: 2.8, 22: 4.0, 23: 2.8}


# ------------------------------------------------------------------ la grandezza
def true_range(barre):
    """TR[i] per i >= 1, TR[0] = None (come ATR.mq5). barre = tuple (t, o, h, l, c, tv)."""
    tr = [None]
    for i in range(1, len(barre)):
        cp = barre[i - 1][4]
        tr.append(max(barre[i][2], cp) - min(barre[i][3], cp))
    return tr


def atr_mt5(barre, periodo=PERIODO):
    """Scrittura ricorsiva di ATR.mq5: primo valore a i = periodo, poi somma scorrevole."""
    tr = true_range(barre)
    atr = [None] * len(barre)
    if len(barre) <= periodo:
        return atr, tr
    atr[periodo] = sum(tr[1:periodo + 1]) / periodo
    for i in range(periodo + 1, len(barre)):
        atr[i] = atr[i - 1] + (tr[i] - tr[i - periodo]) / periodo
    return atr, tr


def atr_diretto(barre, periodo=PERIODO):
    tr = true_range(barre)
    return [None if i < periodo else sum(tr[i - periodo + 1:i + 1]) / periodo for i in range(len(barre))]


def quantile(v, q):
    v = sorted(v)
    if len(v) == 1:
        return v[0]
    pos = q * (len(v) - 1)
    lo = int(pos)
    hi = min(lo + 1, len(v) - 1)
    return v[lo] + (v[hi] - v[lo]) * (pos - lo)


def riassunto(v):
    if not v:
        return None
    return {"n": len(v), "med": statistics.median(v), "media": sum(v) / len(v), "p10": quantile(v, .10),
            "p25": quantile(v, .25), "p75": quantile(v, .75), "p90": quantile(v, .90)}


def fmt(r):
    if r is None:
        return "n 0"
    return "n %5d  mediana %6.2f  media %6.2f  p10 %6.2f  p25 %6.2f  p75 %6.2f  p90 %6.2f" % (
        r["n"], r["med"], r["media"], r["p10"], r["p25"], r["p75"], r["p90"])


def x_costo(atr, k, spread):
    return k * atr / spread


def etichetta_e1(m):
    if m <= SOGLIA_BASSA:
        return "SOVRASTIMA"
    if m < SOGLIA_ALTA:
        return "ZONA GRIGIA"
    if m <= TETTO_BANDA:
        return "IL DERIVATO REGGE"
    return "SOPRA LA BANDA"


def etichetta_e2(m):
    if m < 33.0:
        return "SOTTO EMILIANO"
    if m <= 44.0:
        return "NELLA BANDA DI EMILIANO"
    if m < 50.0:
        return "GRIGIA"
    if m <= 57.0:
        return "NELLA BANDA DEL DERIVATO"
    return "SOPRA"


def barra_cash(d):
    """Ora server della barra delle 09:00 italiane (apertura Xetra), orologio UTC+1 fisso."""
    return 8 if COLL.ora_legale_eu(d) else 9


def ore_e2(d):
    """E2, trader alle 08:30-10:00 ITALIANE: (barre CHIUSE viste, barre IN FORMAZIONE) in ora server.
    Estate UE: chiuse 06 e 07, in formazione 07 e 08. Inverno UE: chiuse 07 e 08, in formazione 08 e 09."""
    c = barra_cash(d)
    return (c - 2, c - 1), (c - 1, c)


# ------------------------------------------------------------------ provenienza (classe 1381)
def controlla_provenienza(riep, pin, run_csv, sha_csv):
    motivi = []
    if not re.fullmatch(r"[0-9a-f]{40}", pin or ""):
        motivi.append("--pin deve essere di 40 esadecimali minuscoli (il pin della riga che ha passato il cancello)")
    m = re.search(r"pin: ([0-9a-fA-F]{40})\s+run: ([0-9a-f]{12})", riep)
    if not m:
        motivi.append("RIEPILOGO senza la riga 'pin: ... run: ...'")
    else:
        if m.group(1).lower() != (pin or "").lower():
            motivi.append("pin del RIEPILOGO %s diverso da quello della riga %s" % (m.group(1)[:8], (pin or "")[:8]))
        if m.group(2) != run_csv:
            motivi.append("run del RIEPILOGO %s diverso da quello del CSV %s" % (m.group(2), run_csv))
    m = re.search(r"EA SHA256 ([0-9A-Fa-f]{64})\s+ini SHA256 ([0-9A-Fa-f]{64})", riep)
    if not m:
        motivi.append("RIEPILOGO senza gli SHA256 dell'EA e del .ini")
    else:
        if m.group(1).upper() != SHA_EA_ATTESO:
            motivi.append("SHA256 dell'EA nel RIEPILOGO %s diverso da quello atteso %s" % (m.group(1)[:12], SHA_EA_ATTESO[:12]))
        if m.group(2).upper() != SHA_INI_ATTESO:
            motivi.append("SHA256 del .ini nel RIEPILOGO %s diverso da quello atteso %s" % (m.group(2)[:12], SHA_INI_ATTESO[:12]))
    m = re.search(r"CSV: D30EUR_H1_([0-9a-f]{12})\.csv\s+SHA256 ([0-9A-Fa-f]{64})", riep)
    if not m:
        motivi.append("RIEPILOGO senza la riga 'CSV: D30EUR_H1_<run>.csv   SHA256 ...'")
    else:
        if m.group(1) != run_csv:
            motivi.append("il RIEPILOGO nomina il CSV del run %s, il CSV letto e' del run %s" % (m.group(1), run_csv))
        if m.group(2).upper() != sha_csv.upper():
            motivi.append("SHA256 del CSV letto %s diverso da quello scritto nel RIEPILOGO %s" % (sha_csv[:12], m.group(2)[:12]))
    if not re.search(r"^STATO: OK\s*$", riep, re.M):
        motivi.append("il RIEPILOGO non dice 'STATO: OK'")
    return motivi


# ------------------------------------------------------------------ la lettura
def misura(testo, riep=None, pin=None, sha_csv=None, esplora=False, stampa=True):
    """Ritorna (codice d'uscita, risultati, righe stampate)."""
    out = []
    res = {"e1": None, "e2": None, "e3": None, "orologio_ok": None, "sospese": False}

    def dico(s=""):
        out.append(s)

    def fine(code):
        if stampa:
            for s in out:
                print(s)
        return code, res, out

    # 0. il controllo di riproduzione della riga H1 della mappa (prima dei numeri)
    rip = {"fade_bcm": x_costo(ATR_DERIVATO, K_FADE, SPREAD_BCM), "fade_ftmo": x_costo(ATR_DERIVATO, K_FADE, SPREAD_FTMO),
           "g770411_bcm": x_costo(ATR_DERIVATO, K_770411, SPREAD_BCM), "g770411_ftmo": x_costo(ATR_DERIVATO, K_770411, SPREAD_FTMO)}
    for k, v in RIGA_MAPPA.items():
        if abs(round(rip[k], 1) - v) > 1e-9:
            dico("RIFIUTO: la riga H1 della mappa NON si riproduce (%s: %.2f contro %.1f): la formula del cancello non e' quella della mappa" % (k, rip[k], v))
            return fine(1)
    # 1. collaudo (integrita' + orologio)
    ok, motivi, info = COLL.collauda(testo, run=None, stampa=False)
    res["orologio_ok"] = info["orologio_ok"]
    dico("=== COLLAUDO (collaudo_export_barre_dax_h1.py) ===")
    for m in info["motivi_integrita"]:
        dico("  integrita': " + m)
    for m in info["motivi_orologio"]:
        dico("  orologio  : " + m)
    dico("  integrita' %s, orologio %s" % ("PASS" if not info["motivi_integrita"] else "FAIL", "CONFERMATO" if info["orologio_ok"] else "NON CONFERMATO"))
    # 2. provenienza
    if not esplora:
        mp = controlla_provenienza(riep or "", pin, info["run"] or "", sha_csv or "")
        if mp:
            dico("RIFIUTO: provenienza non verificata (classe 1381):")
            for m in mp:
                dico("   - " + m)
            return fine(1)
        dico("  provenienza: pin, SHA256 EA e .ini, run, SHA256 del CSV e STATO OK coincidono col RIEPILOGO")
    else:
        dico("  ESPLORAZIONE: provenienza NON verificata: i numeri si leggono, NESSUN verdetto")
    barre = info["barre"]
    corto = info["storico_corto"] or info["finestra_scoperta"]
    altri = [m for m in info["motivi_integrita"] if not ("(A1)" in m or "(A2)" in m or "ancora A2" in m or "(A3)" in m or "(A8)" in m)]
    if altri or (info["motivi_integrita"] and not corto) or info["simbolo"] != COLL.SIMBOLO:
        dico("RIFIUTO: il CSV non passa l'integrita' (motivi sopra): nessun numero")
        return fine(1)
    # 3. ATR sull'intera serie
    atr, tr = atr_mt5(barre)
    idx = [i for i, b in enumerate(barre) if DA_MISURA <= b[0].date() <= A_MISURA and b[0].weekday() < 5 and atr[i] is not None]
    tutti = [atr[i] for i in idx]
    dico("")
    dico("=== ATR(14) H1 D30EUR (iATR di MT5: media SEMPLICE di 14 TR) -- finestra %s -> %s inclusa, giorni feriali ===" % (DA_MISURA, A_MISURA))
    dico("barre nel file %d (prima %s, ultima %s); barre nella finestra con ATR definito %d" % (
        len(barre), barre[0][0].strftime("%Y.%m.%d %H:%M"), barre[-1][0].strftime("%Y.%m.%d %H:%M"), len(tutti)))
    if corto:
        dico("MISURA MANCANTE: lo storico D30EUR di questo export non copre la finestra (prima barra %s, ultima %s). Non e' un errore: "
             "il numero manca. Si rimisura dopo aver scaricato lo storico (sonda), nessun verdetto." % (
                 barre[0][0].strftime("%Y.%m.%d"), barre[-1][0].strftime("%Y.%m.%d")))
        r = riassunto(tutti)
        dico("   (solo per sapere cosa c'e': %s)" % fmt(r))
        return fine(3)
    r_all = riassunto(tutti)
    res["e1"] = r_all["med"]
    dico("E1 TUTTE LE ORE: " + fmt(r_all))
    # 4. per ora
    sosp = not info["orologio_ok"]
    res["sospese"] = sosp
    tag = "  [SOSPESA: orologio NON confermato]" if sosp else ""
    per_ora = {}
    for i in idx:
        per_ora.setdefault(barre[i][0].hour, []).append(atr[i])
    dico("")
    dico("E4 PER ORA SERVER (ATR alla barra h CHIUSA; e' quello che un ingresso nell'ora h+1 legge)" + tag)
    dico("   ora   n     mediana  p25     p75    | ingresso nell'ora h+1: spread mediano dell'ora, 1,5xATR/spread")
    for h in range(24):
        v = per_ora.get(h, [])
        if not v:
            dico("   %02d    0" % h)
            continue
        r = riassunto(v)
        hs = (h + 1) % 24
        dico("   %02d  %5d  %6.2f  %6.2f  %6.2f  | ore %02d: spread %.1f -> %5.1fx" % (
            h, r["n"], r["med"], r["p25"], r["p75"], hs, SPREAD_ORA[hs], x_costo(r["med"], K_FADE, SPREAD_ORA[hs])))
    meds = {h: statistics.median(v) for h, v in per_ora.items() if len(v) >= 20}
    if meds:
        hmin = min(meds, key=meds.get)
        hmax = max(meds, key=meds.get)
        dico("   minimo alla barra %02d (%.2f), massimo alla barra %02d (%.2f); E4 attesa: minimo fra 5 e 8 -> %s%s" % (
            hmin, meds[hmin], hmax, meds[hmax], "COERENTE" if 5 <= hmin <= 8 else "SMENTITA la finestra notturna", tag))
    # 5. trader 08:30-10:00 ITALIANE: barre chiuse delle 07:00 e 08:00 IT (06-07 server d'estate, 07-08 d'inverno),
    #    e forchetta delle barre in formazione delle 08:00 e 09:00 IT (07-08 server d'estate, 08-09 d'inverno)
    dico("")
    dico("E2 COME LO VEDE UN TRADER ALLE 08:30-10:00 ITALIANE (barre CHIUSE delle 07:00 e 08:00 IT = 06-07 server d'estate UE, 07-08 d'inverno UE)" + tag)
    v7 = [atr[i] for i in idx if barre[i][0].hour == ore_e2(barre[i][0].date())[0][0]]
    v8 = [atr[i] for i in idx if barre[i][0].hour == ore_e2(barre[i][0].date())[0][1]]
    r7, r8, r78 = riassunto(v7), riassunto(v8), riassunto(v7 + v8)
    dico("   barra 07:00 IT  " + fmt(r7))
    dico("   barra 08:00 IT  " + fmt(r8))
    dico("   le due          " + fmt(r78))
    for k, nome_f in ((0, "08:00 IT"), (1, "09:00 IT")):
        lo, hi = forchetta(barre, atr, tr, idx, lambda d, k=k: ore_e2(d)[1][k])
        if lo:
            dico("   barra %s IN FORMAZIONE: valore mostrato fra (13 TR chiusi)/14 = mediana %.2f e ATR a barra chiusa = mediana %.2f" % (nome_f, statistics.median(lo), statistics.median(hi)))
    if r78:
        res["e2"] = r78["med"]
        dico("   E2 -> %s (mediana %.2f; bande: <33 / 33-44 / 44-50 / 50-57 / >57)%s" % (etichetta_e2(r78["med"]), r78["med"], tag))
        dico("   quota delle letture alle barre delle 07:00-08:00 IT con ATR >= %.2f (1,5 x ATR / 1,70 >= 40x): %.1f%%" % (
            ATR_FRONTIERA, 100.0 * sum(1 for x in v7 + v8 if x >= ATR_FRONTIERA) / len(v7 + v8)))
    # 6. 09:00 italiane per stagione
    dico("")
    dico("E3 ALLE 09:00 ITALIANE (scheda N1): barra delle 09:00 IT = 08 server d'estate UE, 09 d'inverno UE" + tag)
    a_cash = [atr[i] for i in idx if barre[i][0].hour == barra_cash(barre[i][0].date())]
    a_prima = [atr[i] for i in idx if barre[i][0].hour == barra_cash(barre[i][0].date()) - 1]
    rc, rp = riassunto(a_cash), riassunto(a_prima)
    dico("   barra delle 09:00 IT CHIUSA (contiene l'apertura cash)   " + fmt(rc))
    dico("   barra delle 08:00 IT CHIUSA (mostrata fra 09:00 e 10:00) " + fmt(rp))
    for stg in ("ESTATE", "INVERNO"):
        vs = [atr[i] for i in idx if COLL.stagione(barre[i][0].date()) == stg and barre[i][0].hour == barra_cash(barre[i][0].date()) - 1]
        if vs:
            dico("   %-7s barra delle 08:00 IT chiusa: %s" % (stg, fmt(riassunto(vs))))
    if rc:
        res["e3"] = (rc["med"], rp["med"] if rp else None)
        dico("   E3 -> barra 09:00 IT: %s (%.2f); barra 08:00 IT: %s (%.2f); H0 della scheda 50-57, smentita 33-44%s" % (
            etichetta_e2(rc["med"]), rc["med"], etichetta_e2(rp["med"]) if rp else "-", rp["med"] if rp else float("nan"), tag))
    # 7. per mese
    dico("")
    dico("E5 PER MESE (tutte le ore; e barre CHIUSE delle 07:00-08:00 IT di E2)")
    mesi = {}
    for i in idx:
        mesi.setdefault(barre[i][0].strftime("%Y-%m"), []).append(i)
    for k in sorted(mesi):
        v = [atr[i] for i in mesi[k]]
        vm = [atr[i] for i in mesi[k] if barre[i][0].hour in ore_e2(barre[i][0].date())[0]]
        r = riassunto(v)
        dico("   %s  n %4d  mediana %6.2f  p25 %6.2f  p75 %6.2f   | barre E2: n %3d mediana %s" % (
            k, r["n"], r["med"], r["p25"], r["p75"], len(vm), ("%6.2f" % statistics.median(vm)) if vm else "   -"))
    # 8. cancello di costo
    dico("")
    dico("E6 CANCELLO DI COSTO H1 (mappa par. 3.2): riproduzione 53,6 -> %.1fx / %.1fx (1,5x) e %.1fx / %.1fx (2,5x): OK" % (
        rip["fade_bcm"], rip["fade_ftmo"], rip["g770411_bcm"], rip["g770411_ftmo"]))
    dico("   ATR                                  valore   1,5xATR  x su 1,70  x su 1,23 | 2,5xATR  x su 1,70  x su 1,23")
    righe_c = [("derivato della mappa", ATR_DERIVATO), ("Emiliano r.261", EMILIANO_H1[0]), ("Luca r.523", EMILIANO_H1[1]),
               ("MISURATO mediana tutte le ore", r_all["med"]), ("MISURATO media tutte le ore", r_all["media"]),
               ("MISURATO p25 tutte le ore", r_all["p25"]), ("MISURATO p75 tutte le ore", r_all["p75"])]
    if r78:
        righe_c.append(("MISURATO mediana E2 07-08 IT" + (" [SOSP.]" if sosp else ""), r78["med"]))
    for nome, a in righe_c:
        dico("   %-36s %6.2f   %6.1f   %6.1fx   %6.1fx  | %6.1f   %6.1fx   %6.1fx" % (
            nome, a, K_FADE * a, x_costo(a, K_FADE, SPREAD_BCM), x_costo(a, K_FADE, SPREAD_FTMO),
            K_770411 * a, x_costo(a, K_770411, SPREAD_BCM), x_costo(a, K_770411, SPREAD_FTMO)))
    dico("   frontiera 40x a BCM 1,70 con 1,5xATR = ATR %.2f; pavimento duro 13,3x = ATR %.2f" % (ATR_FRONTIERA, DURO * SPREAD_BCM / K_FADE))
    dico("   quota delle letture (tutte le ore) con ATR >= %.2f: %.1f%%" % (ATR_FRONTIERA, 100.0 * sum(1 for x in tutti if x >= ATR_FRONTIERA) / len(tutti)))
    # 9. il mattino della live
    dico("")
    dico("IL MATTINO DELLA LIVE (%s, estate UE: cash = barra 08 server)%s" % (LIVE.strftime("%d/%m/%Y"), tag))
    il = [i for i, b in enumerate(barre) if b[0].date() == LIVE and 5 <= b[0].hour <= 10 and atr[i] is not None]
    if not il:
        dico("   NON PRESENTE nel CSV (export lanciato prima del 15/10/2026, o barre mancanti): nessuna taratura")
    else:
        for i in il:
            s13 = sum(tr[i - PERIODO + 1:i]) / PERIODO
            dico("   barra %02d server (%02d IT): ATR a barra chiusa %.2f; a barra aperta fra %.2f e %.2f" % (
                barre[i][0].hour, barre[i][0].hour + 1, atr[i], s13, atr[i]))
        dico("   Emiliano 37 (r.261) e Luca 40 (r.523), ora esatta NON nota [INFERITO 09-10 IT = 08-09 server: barra 08 in formazione, 07 l'ultima chiusa]: UN giorno, taratura, non misura")
    # 10. verdetti
    dico("")
    if esplora:
        dico("VERDETTO: NESSUNO (esplorazione: provenienza non verificata). E1 sarebbe %s (%.2f)" % (etichetta_e1(r_all["med"]), r_all["med"]))
        return fine(0)
    e1 = etichetta_e1(r_all["med"])
    dico("VERDETTO E1 (mediana ATR(14) H1 su tutte le ore, %s -> %s): %.2f -> %s" % (DA_MISURA, A_MISURA, r_all["med"], e1))
    dico("   riga H1 del cancello con la mediana misurata: 1,5 x %.2f / 1,70 = %.1fx (%s la frontiera 40x)" % (
        r_all["med"], x_costo(r_all["med"], K_FADE, SPREAD_BCM), "SOPRA" if x_costo(r_all["med"], K_FADE, SPREAD_BCM) >= FRONTIERA else "SOTTO"))
    if r78 and not sosp:
        e2 = etichetta_e2(r78["med"])
        if e1 in ("IL DERIVATO REGGE", "SOPRA LA BANDA") and r78["med"] <= 44.0:
            spieg = "Emiliano vede un'ORA BASSA: su tutte le ore l'ATR %s, e il mattino sta nella sua banda o sotto" % (
                "regge il derivato" if e1 == "IL DERIVATO REGGE" else "sta SOPRA il derivato")
        elif e1 == "SOVRASTIMA":
            spieg = "la scala sqrt(T) sovrastima: il valore basso non e' solo del mattino"
        else:
            spieg = "nessuna delle due spiegazioni scritte prima descrive da sola i due numeri: si legge la tabella per ora"
        dico("VERDETTO E2 (barre chiuse delle 07:00-08:00 IT): %.2f -> %s; insieme a E1: %s" % (r78["med"], e2, spieg))
    else:
        dico("VERDETTO E2: SOSPESO (orologio NON confermato dal collaudo): resta solo E1")
    return fine(0)


def forchetta(barre, atr, tr, idx, ora):
    lo, hi = [], []
    for i in idx:
        h = ora(barre[i][0].date()) if callable(ora) else ora
        if barre[i][0].hour == h and i >= PERIODO + 1:
            lo.append(sum(tr[i - PERIODO + 1:i]) / PERIODO)
            hi.append(atr[i])
    return lo, hi


# ------------------------------------------------------------------ autotest
def _b(t, o, h, l, c):
    return (t, o, h, l, c, 100)


def _scala(righe, k, p0=18000.0):  # centro del sentiero sintetico (16.875-19.261): scalato x2 resta nella banda 15.000-32.000
    out = []
    for r in righe:
        c = r.split(";")
        out.append(";".join([c[0]] + ["%.2f" % (p0 + k * (float(x) - p0)) for x in c[1:5]] + c[5:]))
    return out


def _riep(testo, pin, run="0123456789ab", sha_ea=SHA_EA_ATTESO, sha_ini=SHA_INI_ATTESO, stato="OK", sha_csv=None):
    sc = sha_csv or hashlib.sha256(testo.encode("ascii")).hexdigest().upper()
    return "\r\n".join([
        "EXPORT_BARRE_DAX_H1 -- export delle barre H1 di D30EUR dal tester",
        "data: 2026-10-15 10:00:00   pc: DESKTOP-H4D7CAJ   pin: %s   run: %s" % (pin, run),
        "EA SHA256 %s   ini SHA256 %s   compilazione: 0 errori, 0 avvisi (-1 = non letto)" % (sha_ea, sha_ini),
        "finestra chiesta: 2024.09.26 -> 2026.10.15   durata passata 30 s",
        "CSV: D30EUR_H1_%s.csv   SHA256 %s   barre 1   prima x   ultima y" % (run, sc),
        "riga #FINE: x", "STATO: %s" % stato, "motivi: "])


def autotest():
    falliti = []

    def verifica(nome, cond, dettaglio=""):
        print("%s  %s%s" % ("OK " if cond else "KO ", nome, ("  [" + dettaglio + "]") if dettaglio else ""))
        if not cond:
            falliti.append(nome)

    t0 = dt.datetime(2025, 3, 3, 1)
    # T1 barre costanti con H-L = 50 e nessun buco: ATR = 50 esatto
    bc = [_b(t0 + dt.timedelta(hours=i), 20000, 20025, 19975, 20000) for i in range(40)]
    a, _ = atr_mt5(bc)
    verifica("T1 ATR di barre costanti (H-L=50, nessun buco) = 50,00", a[13] is None and all(abs(x - 50) < 1e-9 for x in a[14:]))
    # T2 un buco di prezzo: barra che apre 100 sopra la chiusura precedente con H-L = 10 -> TR = 110
    bg = bc[:20] + [_b(t0 + dt.timedelta(hours=20), 20100, 20110, 20100, 20105)] + \
        [_b(t0 + dt.timedelta(hours=21 + i), 20105, 20130, 20080, 20105) for i in range(20)]
    a, tr = atr_mt5(bg)
    verifica("T2 TR della barra col buco = 110 (max(H, C-1) - min(L, C-1))", abs(tr[20] - 110) < 1e-9, "%.2f" % tr[20])
    verifica("T2b ATR alla barra del buco = (13 x 50 + 110) / 14 = 54,29", abs(a[20] - (13 * 50 + 110) / 14.0) < 1e-9, "%.4f" % a[20])
    # T3 ricorsiva (ATR.mq5) == media diretta su 5000 barre casuali
    rnd = random.Random(3)
    br, p = [], 20000.0
    for i in range(5000):
        o = p + rnd.gauss(0, 5)
        c = o + rnd.gauss(0, 20)
        br.append(_b(t0 + dt.timedelta(hours=i), o, max(o, c) + abs(rnd.gauss(0, 10)), min(o, c) - abs(rnd.gauss(0, 10)), c))
        p = c
    a1, _ = atr_mt5(br)
    a2 = atr_diretto(br)
    dmax = max(abs(x - y) for x, y in zip(a1[14:], a2[14:]))
    verifica("T3 scrittura ricorsiva di ATR.mq5 = media semplice diretta (5000 barre)", dmax < 1e-6, "scarto massimo %.2e" % dmax)
    # T4 una barra mancante: l'ATR usa la riga prima, non l'ora prima (come iATR)
    bm = br[:100] + br[101:200]
    a3, tr3 = atr_mt5(bm)
    attteso = max(br[101][2], br[99][4]) - min(br[101][3], br[99][4])
    verifica("T4 barra mancante: il TR dopo il buco usa la chiusura della riga prima", abs(tr3[100] - attteso) < 1e-9)
    # T5 fine settimana: il TR della prima barra del lunedi' contiene il buco del venerdi'
    ven = dt.datetime(2025, 3, 7, 20)
    bw = [_b(ven - dt.timedelta(hours=20 - i), 20000, 20025, 19975, 20000) for i in range(21)] + \
        [_b(dt.datetime(2025, 3, 10, 0), 20200, 20210, 20190, 20200)] + [_b(dt.datetime(2025, 3, 10, 1 + i), 20200, 20225, 20175, 20200) for i in range(15)]
    a4, tr4 = atr_mt5(bw)
    verifica("T5 lunedi': TR = 210 (buco del fine settimana 200 + 10), come iATR", abs(tr4[21] - 210) < 1e-9, "%.2f" % tr4[21])
    # T6 forchetta della barra in formazione: costante 50 -> (13 x 50)/14 = 46,43 e 50
    a5, tr5 = atr_mt5(bc)
    lo, hi = forchetta(bc, a5, tr5, list(range(len(bc))), bc[30][0].hour)
    verifica("T6 forchetta a barra aperta su barre costanti = [46,43 ; 50,00]", lo and abs(lo[0] - 650 / 14.0) < 1e-9 and abs(hi[0] - 50) < 1e-9)
    # T7 partizioni scritte prima: ogni valore ha UNA etichetta, e i bordi stanno dove dichiarato
    verifica("T7 bordi E1: 42,00 SOVRASTIMA, 42,01 GRIGIA, 47,99 GRIGIA, 48,00 REGGE, 60,00 REGGE, 60,01 SOPRA",
             [etichetta_e1(x) for x in (42.0, 42.01, 47.99, 48.0, 60.0, 60.01)] == ["SOVRASTIMA", "ZONA GRIGIA", "ZONA GRIGIA", "IL DERIVATO REGGE", "IL DERIVATO REGGE", "SOPRA LA BANDA"])
    verifica("T7b bordi E2: 32,99 SOTTO, 33 BANDA EMILIANO, 44 BANDA EMILIANO, 44,01 GRIGIA, 50 DERIVATO, 57 DERIVATO, 57,01 SOPRA",
             [etichetta_e2(x) for x in (32.99, 33.0, 44.0, 44.01, 50.0, 57.0, 57.01)] == ["SOTTO EMILIANO", "NELLA BANDA DI EMILIANO", "NELLA BANDA DI EMILIANO", "GRIGIA", "NELLA BANDA DEL DERIVATO", "NELLA BANDA DEL DERIVATO", "SOPRA"])
    # T8 riproduzione della riga H1 della mappa, e dei numeri di Emiliano della scheda (32,6-35,3x)
    verifica("T8 53,6 -> 47,3x / 65,4x / 78,8x / 108,9x; 37 -> 32,6x; 40 -> 35,3x; frontiera ATR 45,33",
             round(x_costo(53.6, 1.5, 1.70), 1) == 47.3 and round(x_costo(53.6, 1.5, 1.23), 1) == 65.4 and round(x_costo(53.6, 2.5, 1.70), 1) == 78.8
             and round(x_costo(53.6, 2.5, 1.23), 1) == 108.9 and round(x_costo(37, 1.5, 1.70), 1) == 32.6 and round(x_costo(40, 1.5, 1.70), 1) == 35.3
             and abs(ATR_FRONTIERA - 45.333) < 1e-3)
    # T9 la barra delle 09:00 IT ai bordi dell'ora legale UE
    verifica("T9 barra delle 09:00 IT: ven 28/03/2025 -> 09, lun 31/03/2025 -> 08, ven 24/10/2025 -> 08, lun 27/10/2025 -> 09, 14/10/2026 -> 08",
             [barra_cash(d) for d in (dt.date(2025, 3, 28), dt.date(2025, 3, 31), dt.date(2025, 10, 24), dt.date(2025, 10, 27), dt.date(2026, 10, 14))] == [9, 8, 8, 9, 8])
    # T9b E2 = trader alle 08:30-10:00 ITALIANE: d'estate le barre server 06-07 chiuse (07-08 in formazione), d'inverno
    # 07-08 (08-09). Contro-esempio: la prima stesura (07-08 server fisse) sbaglia d'estate, e T9b la boccerebbe.
    verifica("T9b E2 per stagione: 14/10/2026 chiuse (6,7) in formazione (7,8); 27/10/2025 chiuse (7,8) in formazione (8,9); 31/03/2025 (6,7)",
             ore_e2(dt.date(2026, 10, 14)) == ((6, 7), (7, 8)) and ore_e2(dt.date(2025, 10, 27)) == ((7, 8), (8, 9))
             and ore_e2(dt.date(2025, 3, 31))[0] == (6, 7) and ore_e2(dt.date(2025, 3, 28))[0] == (7, 8))
    # --- da qui, CSV interi sintetici (generatore del collaudo, orologio UTC+1 fisso)
    pin = "0123456789abcdef0123456789abcdef01234567"
    base = COLL.genera("utc1", a=dt.datetime(2026, 10, 14, 23))
    # l'ancora del sintetico: il collaudo vero confronta con 10553, il sintetico ne ha un altro numero: lo si adegua QUI
    n_an = sum(1 for r in base if COLL.ANCORA_DA <= COLL._t(r) <= COLL.ANCORA_FINO)
    COLL.ANCORA_N, vecchia = n_an, COLL.ANCORA_N
    try:
        t_base = COLL.componi(base)
        c, r, _ = misura(t_base, esplora=True, stampa=False)
        m0 = r["e1"]
        verifica("T10 sintetico: si legge (esplorazione), mediana E1 %.2f" % m0, c == 0 and m0 > 0)
        for nome, target, attesa in (("REGGE", 54.0, "IL DERIVATO REGGE"), ("SOVRASTIMA", 38.0, "SOVRASTIMA"), ("GRIGIA", 45.0, "ZONA GRIGIA"), ("SOPRA", 66.0, "SOPRA LA BANDA")):
            t = COLL.componi(_scala(base, target / m0))
            c, r, out = misura(t, riep=_riep(t, pin), pin=pin, sha_csv=hashlib.sha256(t.encode("ascii")).hexdigest(), stampa=False)
            verifica("T11 %s: volatilita' scalata a mediana %.0f -> verdetto E1 '%s'" % (nome, target, attesa),
                     c == 0 and r["e1"] is not None and abs(r["e1"] - target) < 0.05 and etichetta_e1(r["e1"]) == attesa and any(("-> " + attesa) in s for s in out),
                     "E1 %.2f, codice %d" % (r["e1"] or -1, c))
        # T12 la spiegazione "ora bassa": E1 nella banda e mattino <= 44 -> la frase giusta
        t = COLL.componi(_scala(base, 54.0 / m0))
        c, r, out = misura(t, riep=_riep(t, pin), pin=pin, sha_csv=hashlib.sha256(t.encode("ascii")).hexdigest(), stampa=False)
        verifica("T12 mattino del sintetico (profilo notturno basso) sotto 44 con E1 a 54: frase 'ORA BASSA'",
                 r["e2"] is not None and r["e2"] <= 44.0 and any("ORA BASSA" in s for s in out), "E2 %.2f" % (r["e2"] or -1))
        verifica("T12b il minimo per ora cade fra 5 e 8 nel sintetico (E4 COERENTE)", any("-> COERENTE" in s for s in out))
        verifica("T12c il mattino della live 14/10/2026 c'e' nel sintetico e si stampa", any("barra 08 server (09 IT)" in s for s in out))
        # T13 finestra: barre di ottobre con escursioni enormi NON cambiano E1
        dopo = []
        for x in _scala(base, 54.0 / m0):
            if x[:10] >= "2026.10.01":
                cc = x.split(";")
                o = float(cc[1])
                dopo.append(";".join([cc[0], cc[1], "%.2f" % (o + 900), "%.2f" % (o - 900), cc[4]] + cc[5:]))
            else:
                dopo.append(x)
        t2 = COLL.componi(dopo)
        c2, r2, _ = misura(t2, esplora=True, stampa=False)
        verifica("T13 barre dopo il 30/09 con escursioni di 1800 punti: E1 invariata (la finestra taglia)", abs(r2["e1"] - r["e1"]) < 1e-9, "%.2f contro %.2f" % (r2["e1"], r["e1"]))
        # T14 provenienza: ogni campo sbagliato -> RIFIUTO (codice 1)
        sha_t = hashlib.sha256(t.encode("ascii")).hexdigest()
        for nome, rie, pp, sc in (
                ("pin diverso", _riep(t, "f" * 40), pin, sha_t),
                ("SHA EA diverso", _riep(t, pin, sha_ea="A" * 64), pin, sha_t),
                ("SHA ini diverso", _riep(t, pin, sha_ini="B" * 64), pin, sha_t),
                ("run diverso", _riep(t, pin, run="ffffffffffff"), pin, sha_t),
                ("CSV con SHA diverso", _riep(t, pin), pin, "C" * 64),
                ("STATO KO", _riep(t, pin, stato="KO"), pin, sha_t),
                ("pin della riga non valido", _riep(t, pin), "0" * 39, sha_t),
                ("RIEPILOGO vuoto", "", pin, sha_t)):
            c3, _, out3 = misura(t, riep=rie, pin=pp, sha_csv=sc, stampa=False)
            verifica("T14 provenienza: %s -> RIFIUTO" % nome, c3 == 1 and any("RIFIUTO: provenienza" in s for s in out3))
        # T15 senza #FINE -> RIFIUTO; simbolo diverso -> RIFIUTO; prezzi del Dow -> RIFIUTO
        tt = COLL.componi(_scala(base, 54.0 / m0), fine=False)
        c4, _, _ = misura(tt, riep=_riep(tt, pin), pin=pin, sha_csv=hashlib.sha256(tt.encode("ascii")).hexdigest(), stampa=False)
        verifica("T15 CSV troncato senza #FINE -> RIFIUTO", c4 == 1)
        tn = COLL.componi(_scala(base, 54.0 / m0), simbolo="NASUSD")
        c5, _, _ = misura(tn, riep=_riep(tn, pin), pin=pin, sha_csv=hashlib.sha256(tn.encode("ascii")).hexdigest(), stampa=False)
        verifica("T15b CSV di un altro simbolo (#simbolo;NASUSD) -> RIFIUTO", c5 == 1)
        td = COLL.componi([";".join([x.split(";")[0]] + ["%.2f" % (float(y) * 2.3) for y in x.split(";")[1:5]] + x.split(";")[5:]) for x in base])
        c6, _, _ = misura(td, riep=_riep(td, pin), pin=pin, sha_csv=hashlib.sha256(td.encode("ascii")).hexdigest(), stampa=False)
        verifica("T15c prezzi del Dow sotto l'intestazione D30EUR -> RIFIUTO", c6 == 1)
        # T16 storico corto (prima barra 2025.06.02) -> MISURA MANCANTE (codice 3), non RIFIUTO
        tc = COLL.componi([x for x in _scala(base, 54.0 / m0) if x[:10] >= "2025.06.02"])
        c7, _, out7 = misura(tc, riep=_riep(tc, pin), pin=pin, sha_csv=hashlib.sha256(tc.encode("ascii")).hexdigest(), stampa=False)
        verifica("T16 storico D30EUR corto -> MISURA MANCANTE (codice 3)", c7 == 3 and any("MISURA MANCANTE" in s for s in out7))
        # T16b buco di 3 giorni feriali con la prima barra giusta -> RIFIUTO (non e' storico corto)
        tolti = {dt.date(2025, 7, 15), dt.date(2025, 7, 16), dt.date(2025, 7, 17)}
        tb = COLL.componi([x for x in _scala(base, 54.0 / m0) if COLL._t(x).date() not in tolti])
        c8, _, _ = misura(tb, riep=_riep(tb, pin), pin=pin, sha_csv=hashlib.sha256(tb.encode("ascii")).hexdigest(), stampa=False)
        verifica("T16b tre giorni feriali mancanti (storico non corto) -> RIFIUTO", c8 == 1)
        # T17 orologio NON confermato (feed +1h): E1 resta, le letture per ora sono SOSPESE
        tp = COLL.componi(_scala(COLL.genera("piu1", a=dt.datetime(2026, 10, 14, 23)), 54.0 / m0))
        c9, r9, out9 = misura(tp, riep=_riep(tp, pin), pin=pin, sha_csv=hashlib.sha256(tp.encode("ascii")).hexdigest(), stampa=False)
        verifica("T17 orologio spostato +1h: E1 letto, letture per ora SOSPESE, E2 senza verdetto",
                 c9 == 0 and r9["sospese"] and any("VERDETTO E1" in s for s in out9) and any("VERDETTO E2: SOSPESO" in s for s in out9))
        # T18 export lanciato prima del 15/10: il mattino della live NON PRESENTE (e non e' un errore)
        tq = COLL.componi([x for x in _scala(base, 54.0 / m0) if x[:10] <= "2026.10.12"])
        c10, _, out10 = misura(tq, riep=_riep(tq, pin), pin=pin, sha_csv=hashlib.sha256(tq.encode("ascii")).hexdigest(), stampa=False)
        verifica("T18 CSV fino al 12/10: mattino della live NON PRESENTE, codice 0", c10 == 0 and any("NON PRESENTE" in s for s in out10))
    finally:
        COLL.ANCORA_N = vecchia
    print("")
    print("AUTOTEST: %d NO%s" % (len(falliti), (": " + "; ".join(falliti)) if falliti else ""))
    return not falliti


def main():
    ap = argparse.ArgumentParser(description="Lettore dell'ATR(14) H1 di D30EUR dal CSV di CLAU12_EXPORT_BARRE_H1.")
    ap.add_argument("csv", nargs="?")
    ap.add_argument("--riepilogo", help="RIEPILOGO.txt dello stesso zip")
    ap.add_argument("--pin", help="pin (40 esadecimali) della riga che ha passato il cancello")
    ap.add_argument("--esplora", action="store_true", help="salta la provenienza: numeri senza verdetto")
    ap.add_argument("--autotest", action="store_true")
    a = ap.parse_args()
    if a.autotest:
        sys.exit(0 if autotest() else 1)
    if not a.csv or (not a.esplora and (not a.riepilogo or not a.pin)):
        ap.print_usage()
        sys.exit(2)
    grezzo = open(a.csv, "rb").read()
    try:
        testo = grezzo.decode("ascii")
    except UnicodeDecodeError as e:
        print("RIFIUTO: il CSV non e' ASCII puro (byte %d)" % e.start)
        sys.exit(1)
    riep = ""
    if a.riepilogo:
        rb = open(a.riepilogo, "rb").read()
        riep = rb.decode("ascii", "replace")
    codice, _, _ = misura(testo, riep=riep, pin=(a.pin or "").lower(), sha_csv=hashlib.sha256(grezzo).hexdigest(), esplora=a.esplora)
    sys.exit(codice)


if __name__ == "__main__":
    main()
