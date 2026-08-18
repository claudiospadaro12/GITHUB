# =====================================================================
#  histdata_m1.py  --  LA STRADA HISTDATA per lo storico M1 degli INDICI
#  ---------------------------------------------------------------------
#  VERSIONE: HD-M1-v1        (marcatore: la riga di lancio lo stampa
#                             PRIMA di fare qualunque altra cosa)
#
#  PERCHE' ESISTE (18/08/2026)
#    Lo storico BCM degli indici parte dal 26/09/2024: niente 2020
#    (crollo), niente 2022 (orso). Il piano A era Dukascopy, ma dal PC
#    di Claudio il crawl e' strozzato dal server (25 giorni su 2389 in
#    1h43m, 503/reset/timeout: proiezione ~7 giorni di corsa).
#    HistData pubblica le M1 in ZIP ANNUALI (un file per anno) invece
#    che in 24 file all'ora al giorno: lo stesso anno di DAX passa da
#    ~6.200 richieste HTTP a UNA.
#
#  COSA PRODUCE
#    Lo STESSO CSV "Formato 1" che produce dukascopy_m1.py e che
#    ABTG_ImportaStoricoEsterno legge gia':
#        Time,Open,High,Low,Close,Volume
#        2025.06.16 09:31,23512.40,23515.10,23509.80,23514.20,1
#    Cosi' l'ULTIMO MIGLIO (import in MT5, calibrazione dello shift,
#    cancello ZERO) NON CAMBIA fra le due strade.
#
#  I QUATTRO MODI
#    --autotest        prove offline del parser/costruttore (niente rete)
#    --esplora         MISURA la copertura: per ogni simbolo e anno dice
#                      se la pagina risponde e se c'e' il token (= file
#                      scaricabile). E' anche il controllo positivo.
#    --scarica         scarica gli ZIP (annuali per gli anni passati,
#                      mensili per l'anno in corso) con cache e retry
#    --converti        ingerisce gli ZIP presenti in cartella (scaricati
#                      dallo script O A MANO DAL BROWSER), concatena,
#                      MISURA fuso e continuita', scrive il CSV
#
#  LA STRADA MANUALE E' DI PRIMA CLASSE
#    Se il POST automatico non passa (il sito cambia, il token cambia
#    nome, c'e' un captcha), --scarica stampa l'elenco esatto dei link
#    da aprire nel browser: sono POCHI (un click per anno per simbolo).
#    Si salvano gli ZIP nella cartella, e --converti fa tutto il resto.
#    NON serve rinominarli: l'ingestione legge il nome del CSV DENTRO
#    lo zip, non il nome dello zip.
#
#  IL FUSO -- misurato, non assunto
#    La specifica pubblica di HistData (citata dal repo philipperemy/
#    FX-1-Minute-Data, README) dice: "TimeZone: Eastern Standard Time
#    (EST) time-zone WITHOUT Day Light Savings adjustments".
#    MA la misura di casa dice un'altra cosa: 8 import HistData su 8
#    (REFERTO_IMPORT_6_SIMBOLI.md) hanno calibrato UNO SHIFT FISSO +5
#    contro lo storico nativo BCM, con differenza media 0,005-0,011%.
#    Uno shift FISSO che funziona su 7 anni e' possibile solo se il
#    feed segue il DST americano come il server (che sta a UTC+0/+1:
#    "ora italiana -1"), cioe' se i timestamp sono ORA LOCALE DI NEW
#    YORK. Se fossero EST fisso, meta' anno sarebbe sbagliato di un'ora
#    e la differenza media non sarebbe 0,006%.
#    -> Quindi qui NON si converte niente (--fuso nativo, default):
#       i timestamp escono come li scrive HistData, esattamente come
#       nei 6 import forex gia' promossi, e la calibrazione automatica
#       di ABTG_ImportaStoricoEsterno DEVE ritrovare +5.
#       SE TROVA UN ALTRO NUMERO: FERMARSI E CAPIRE.
#    -> E in piu' --converti MISURA la convenzione da solo (funzione
#       misura_fuso): guarda l'ora di apertura di seduta mese per mese.
#       Se l'ora di apertura di luglio e' UGUALE a quella di gennaio ->
#       il feed segue il DST (ora locale NY). Se e' un'ora PRIMA ->
#       il feed e' EST fisso e va detto forte, perche' allora lo shift
#       unico dell'importatore NON basta.
#
#  CONTROPROVA A TRE FEED (chiesta il 18/08)
#    --confronto stampa min/max/n di una FINESTRA di timestamp, cosi'
#    lo stesso giorno si legge su tre feed:
#      Dukascopy  D30EUR 2025.06.15 20:00 -> 2025.06.16 19:59 (ora NY):
#                 1294 barre, minimo 23400.56, massimo 23715.65
#                 (referto_dukascopy_validazione_2026-08-18.txt)
#      HistData   questa riga, sullo stesso intervallo
#      BCM nativo il grafico D30EUR dello stesso giorno (lo storico
#                 nativo parte dal 26/09/2024, quindi c'e')
#    Poiche' un dubbio di un'ora resta possibile finche' misura_fuso non
#    parla, --confronto stampa la finestra chiesta E le due finestre
#    spostate di -1h e +1h: se una delle tre combacia con Dukascopy si
#    sa anche QUALE.
#
#  ATTENZIONE, IL DOW NON C'E'
#    La lista strumenti di HistData (verificata su DUE repository
#    indipendenti, vedi REFERTO_HISTDATA_FATTIBILITA.md) contiene
#    10 indici e il Dow Jones NON e' fra questi. UDX/USD e' l'INDICE
#    DEL DOLLARO, non il Dow. Per U30USD resta solo la strada
#    Dukascopy (USA30IDXUSD).
#
#  REGOLA D'USO, CONGELATA
#    I simboli _EXT che nascono da qui servono SOLO come PROVA DI
#    REGIME a parametri CONGELATI. Qui non si tara NIENTE.
# =====================================================================

import argparse
import os
import re
import sys
import time
import urllib.error
import urllib.parse
import urllib.request
import zipfile
from datetime import datetime, timedelta

VERSIONE = "HD-M1-v1"

BASE_PAGINA = ("https://www.histdata.com/download-free-forex-historical-data/"
               "?/ascii/1-minute-bar-quotes/")
URL_POST = "https://www.histdata.com/get.php"
UA = ("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 "
      "(KHTML, like Gecko) Chrome/120.0 Safari/537.36")

ATTESE_RETRY = [2, 5, 15, 30]      # stessa scala della sonda Dukascopy
PAUSA_MS_DEFAULT = 1500            # HistData e' un sito, non un datafeed:
                                   # si va PIANO. Sono poche richieste.

# codice HistData -> (simbolo BCM, banda plausibile del prezzo, che cos'e')
# La banda serve SOLO al controllo di sanita' (ordine di grandezza),
# non a scegliere divisori: le quote HistData sono gia' decimali.
STRUMENTI = {
    "grxeur": ("D30EUR", 4000.0, 30000.0, "DAX 30/40 in EUR"),
    "nsxusd": ("NASUSD", 1500.0, 30000.0, "NASDAQ 100 in USD"),
    "jpxjpy": ("225JPY", 6000.0, 60000.0, "NIKKEI 225 in JPY"),
    "spxusd": ("SPXUSD", 600.0, 8000.0, "S&P 500 in USD"),
    "auxaud": ("200AUD", 2500.0, 12000.0, "ASX 200 in AUD"),
    "etxeur": ("ETXEUR", 1500.0, 7000.0, "EUROSTOXX 50 in EUR (nome BCM DA VERIFICARE)"),
    "ukxgbp": ("UKXGBP", 3000.0, 12000.0, "FTSE 100 in GBP (nome BCM DA VERIFICARE)"),
    "frxeur": ("FRXEUR", 2000.0, 10000.0, "CAC 40 in EUR (nome BCM DA VERIFICARE)"),
    "eurusd": ("EURUSD", 0.8, 1.8, "controllo positivo (feed gia' importato 15/08)"),
}

# I quattro che servono alla missione, in ordine di priorita'.
# Il Dow NON C'E' su HistData: resta a Dukascopy.
SIMBOLI_MISSIONE = ["grxeur", "nsxusd", "jpxjpy", "spxusd"]

# Primo mese pubblicato, da pairs.csv del repo philipperemy/FX-1-Minute-Data
# [VERIFICATO su GitHub raw il 18/08/2026 - ma e' una fonte TERZA:
#  la verita' la dice --esplora sul PC].
PRIMO_MESE = {
    "grxeur": 201011, "nsxusd": 201011, "jpxjpy": 201011, "spxusd": 201011,
    "auxaud": 201011, "etxeur": 201011, "ukxgbp": 201011, "frxeur": 201011,
    "eurusd": 200005,
}


def log(msg):
    print(msg, flush=True)


# ---------------------------------------------------------------------
#  RETE
#  Torna (esito, contenuto). esito in {"OK", "ASSENTE", "ERRORE ..."}.
#  404 = risposta vera (non esiste). 429/5xx/timeout = "adesso no",
#  si ritenta con attese crescenti (regola di casa).
# ---------------------------------------------------------------------
def _apri(req, timeout):
    ctx = None
    try:
        import ssl
        ca = os.environ.get("REQUESTS_CA_BUNDLE") or os.environ.get("SSL_CERT_FILE")
        if ca and os.path.exists(ca):
            ctx = ssl.create_default_context(cafile=ca)
    except Exception:
        ctx = None
    if ctx is not None:
        return urllib.request.urlopen(req, timeout=timeout, context=ctx)
    return urllib.request.urlopen(req, timeout=timeout)


def richiesta(url, dati=None, referer=None, timeout=180, pausa_ms=PAUSA_MS_DEFAULT):
    intestazioni = {
        "User-Agent": UA,
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
        "Accept-Language": "en-US,en;q=0.9",
        "Connection": "keep-alive",
    }
    if referer:
        intestazioni["Referer"] = referer
        intestazioni["Origin"] = "https://www.histdata.com"
    corpo = None
    if dati is not None:
        corpo = urllib.parse.urlencode(dati).encode("ascii")
        intestazioni["Content-Type"] = "application/x-www-form-urlencoded"
    ultimo = ""
    for tentativo in range(len(ATTESE_RETRY) + 1):
        try:
            req = urllib.request.Request(url, data=corpo, headers=intestazioni)
            with _apri(req, timeout) as r:
                contenuto = r.read()
            if pausa_ms > 0:
                time.sleep(pausa_ms / 1000.0)
            return ("OK", contenuto)
        except urllib.error.HTTPError as e:
            if e.code == 404:
                return ("ASSENTE", b"")
            ultimo = "HTTP %d" % e.code
            if e.code not in (408, 425, 429, 500, 502, 503, 504):
                return ("ERRORE " + ultimo, b"")
        except Exception as e:
            ultimo = type(e).__name__ + ": " + str(e)[:120]
        if tentativo < len(ATTESE_RETRY):
            attesa = ATTESE_RETRY[tentativo]
            log("    %s -> riprovo fra %d s" % (ultimo, attesa))
            time.sleep(attesa)
    return ("ERRORE " + ultimo, b"")


def url_pagina(pair, anno, mese=None):
    if mese is None:
        return BASE_PAGINA + "%s/%d" % (pair.lower(), anno)
    return BASE_PAGINA + "%s/%d/%d" % (pair.lower(), anno, mese)


# Il bottone DOWNLOAD e' un form: campo nascosto id="tk" (token) e POST
# a get.php con il Referer della pagina. Meccanismo LETTO nel sorgente
# di philipperemy/FX-1-Minute-Data (histdata/api.py, GitHub raw,
# 18/08/2026) e identico a quello gia' scritto nel nostro
# importa_storico_esterno.ps1. NON copiato: riscritto qui in stdlib.
RE_TK = [
    re.compile(br'id="tk"[^>]*value="([^"]+)"'),
    re.compile(br'name="tk"[^>]*value="([^"]+)"'),
    re.compile(br'value="([^"]+)"[^>]*id="tk"'),
]


def estrai_token(html):
    for rx in RE_TK:
        m = rx.search(html)
        if m:
            return m.group(1).decode("ascii", "ignore")
    return ""


def nome_zip(pair, anno, mese=None):
    if mese is None:
        return "DAT_ASCII_%s_M1_%d.zip" % (pair.upper(), anno)
    return "DAT_ASCII_%s_M1_%d%02d.zip" % (pair.upper(), anno, mese)


def scarica_zip(pair, anno, mese, cartella, pausa_ms, contatori):
    dest = os.path.join(cartella, nome_zip(pair, anno, mese))
    if os.path.exists(dest) and os.path.getsize(dest) > 1000:
        contatori["cache"] += 1
        return ("CACHE", dest, "")
    pagina = url_pagina(pair, anno, mese)
    esito, html = richiesta(pagina, timeout=90, pausa_ms=pausa_ms)
    if esito != "OK":
        return ("NO", "", "pagina: " + esito)
    token = estrai_token(html)
    if not token:
        # niente token = niente file per quel periodo (o pagina cambiata)
        return ("NOTOKEN", "", "nessun token nella pagina")
    periodo = "%d%02d" % (anno, mese) if mese else "%d" % anno
    dati = {
        "tk": token,
        "date": str(anno),
        "datemonth": periodo,
        "platform": "ASCII",
        "timeframe": "M1",
        "fxpair": pair.upper(),
    }
    esito, corpo = richiesta(URL_POST, dati=dati, referer=pagina,
                             timeout=900, pausa_ms=pausa_ms)
    if esito != "OK":
        return ("NO", "", "post: " + esito)
    if len(corpo) < 2 or corpo[0:2] != b"PK":
        return ("NO", "", "risposta non ZIP (%d byte)" % len(corpo))
    if len(corpo) < 20000:
        return ("NO", "", "ZIP troppo piccolo (%d byte)" % len(corpo))
    with open(dest, "wb") as f:
        f.write(corpo)
    contatori["scaricati"] += 1
    contatori["byte"] += len(corpo)
    return ("OK", dest, "")


# ---------------------------------------------------------------------
#  LETTURA DEL CSV HISTDATA
#  Riga: "20120201 000000;1.306600;1.306600;1.306560;1.306560;0"
#  separatore ';' (nel Generic ASCII M1), niente intestazione.
#  I PREZZI SI TENGONO COME STRINGHE: nessun round-trip in float, cosi'
#  non si perde una cifra e non c'e' nessuna questione di cultura
#  numerica (il punto decimale del file finisce identico nel CSV).
# ---------------------------------------------------------------------
def leggi_righe_histdata(testo, contatori):
    barre = {}
    for riga in testo.splitlines():
        riga = riga.strip()
        if len(riga) < 20:
            continue
        campi = riga.replace(",", ";").split(";")
        if len(campi) < 5:
            contatori["scartate"] += 1
            continue
        stamp = campi[0].strip()
        if len(stamp) < 15 or not stamp[0:8].isdigit():
            contatori["scartate"] += 1
            continue
        try:
            t = datetime(int(stamp[0:4]), int(stamp[4:6]), int(stamp[6:8]),
                         int(stamp[9:11]), int(stamp[11:13]))
        except ValueError:
            contatori["scartate"] += 1
            continue
        o, h, l, c = (campi[1].strip(), campi[2].strip(),
                      campi[3].strip(), campi[4].strip())
        v = campi[5].strip() if len(campi) > 5 else "0"
        try:
            fo, fh, fl, fc = float(o), float(h), float(l), float(c)
        except ValueError:
            contatori["scartate"] += 1
            continue
        if fo <= 0 or fh <= 0 or fl <= 0 or fc <= 0 or fh < fl:
            contatori["scartate"] += 1
            continue
        if fh < fo or fh < fc or fl > fo or fl > fc:
            contatori["ohlc_incoerenti"] += 1
            continue
        if t in barre:
            contatori["duplicate"] += 1
            continue
        barre[t] = (o, h, l, c, v, fo, fh, fl, fc)
    return barre


def ingerisci_zip(cartella, filtro_pair, contatori):
    """Apre TUTTI gli zip della cartella e li smista per simbolo.
    Il simbolo si legge dal nome del CSV DENTRO lo zip
    (DAT_ASCII_GRXEUR_M1_2020.csv), quindi lo zip puo' chiamarsi come
    vuole: e' la strada manuale che resta comoda."""
    per_simbolo = {}
    if not os.path.isdir(cartella):
        return per_simbolo
    zips = sorted([f for f in os.listdir(cartella) if f.lower().endswith(".zip")])
    for nz in zips:
        percorso = os.path.join(cartella, nz)
        try:
            with zipfile.ZipFile(percorso) as z:
                nomi = [n for n in z.namelist() if n.lower().endswith(".csv")]
                if not nomi:
                    log("  %s: nessun CSV dentro, salto" % nz)
                    continue
                for n in nomi:
                    base = os.path.basename(n).upper()
                    m = re.search(r"DAT_ASCII_([A-Z]{6})_M1_(\d{4})(\d{2})?", base)
                    if m:
                        pair = m.group(1).lower()
                    else:
                        m2 = re.search(r"([A-Z]{6})", base)
                        if not m2:
                            log("  %s / %s: simbolo non riconosciuto, salto" % (nz, n))
                            continue
                        pair = m2.group(1).lower()
                    if filtro_pair and pair not in filtro_pair:
                        continue
                    testo = z.read(n).decode("ascii", "ignore")
                    parziali = leggi_righe_histdata(testo, contatori)
                    d = per_simbolo.setdefault(pair, {})
                    prima = len(d)
                    for k, val in parziali.items():
                        if k in d:
                            contatori["duplicate"] += 1
                        else:
                            d[k] = val
                    log("  %s -> %s: %d barre (nuove %d)" %
                        (nz, pair, len(parziali), len(d) - prima))
        except zipfile.BadZipFile:
            log("  %s: ZIP ILLEGGIBILE (riscaricalo)" % nz)
            contatori["zip_rotti"] += 1
    return per_simbolo


# ---------------------------------------------------------------------
#  MISURA DEL FUSO (la trappola vera)
#  Per ogni mese si guarda l'ORA DELLA PRIMA BARRA di ogni giornata di
#  contrattazione e si prende la moda. Un indice europeo apre a ora
#  FISSA locale: se i timestamp del file seguono il DST americano
#  l'ora modale resta la STESSA in gennaio e in luglio; se il file e'
#  EST fisso, in luglio l'apertura scivola indietro di un'ora.
#  (Sul forex 24h la stessa misura si fa sulla prima barra della
#  settimana: l'apertura della domenica sera.)
# ---------------------------------------------------------------------
def _moda(valori):
    if not valori:
        return None, 0
    conta = {}
    for v in valori:
        conta[v] = conta.get(v, 0) + 1
    migliore = max(conta.items(), key=lambda kv: kv[1])
    return migliore[0], migliore[1]


def misura_fuso(barre):
    righe = []
    if not barre:
        return ["FUSO: nessuna barra da misurare."]
    chiavi = sorted(barre.keys())
    # prima barra di ogni giornata
    prima_del_giorno = {}
    for k in chiavi:
        g = k.date()
        if g not in prima_del_giorno or k < prima_del_giorno[g]:
            prima_del_giorno[g] = k
    # prima barra dopo un buco >= 12 ore (apertura di settimana)
    aperture_settimana = []
    for a, b in zip(chiavi, chiavi[1:]):
        if (b - a).total_seconds() >= 12 * 3600:
            aperture_settimana.append(b)

    per_mese = {}
    for g, k in prima_del_giorno.items():
        per_mese.setdefault((g.year, g.month), []).append(k.hour * 60 + k.minute)

    righe.append("MISURA DEL FUSO -- ora di apertura di seduta, mese per mese")
    righe.append("  (se GENNAIO e LUGLIO danno la STESSA ora -> il feed segue il")
    righe.append("   DST americano = ORA LOCALE DI NEW YORK -> shift unico OK.")
    righe.append("   Se LUGLIO e' un'ora PRIMA -> feed EST FISSO -> lo shift unico")
    righe.append("   dell'importatore sbaglia meta' anno: FERMARSI.)")
    inverno = []
    estate = []
    for chiave in sorted(per_mese.keys()):
        anno, mese = chiave
        moda, quante = _moda(per_mese[chiave])
        if moda is None:
            continue
        righe.append("  %04d-%02d  apertura modale %02d:%02d  (su %d giorni)" %
                     (anno, mese, moda // 60, moda % 60, quante))
        if mese in (1, 2, 12):
            inverno.append(moda)
        if mese in (6, 7, 8):
            estate.append(moda)
    mi, _ = _moda(inverno)
    me, _ = _moda(estate)
    if mi is not None and me is not None:
        delta = me - mi
        righe.append("  INVERNO %02d:%02d   ESTATE %02d:%02d   differenza %+d min" %
                     (mi // 60, mi % 60, me // 60, me % 60, delta))
        if abs(delta) <= 5:
            righe.append("  VERDETTO FUSO: il feed SEGUE il DST -> ora locale di New York.")
            righe.append("  Atteso all'import: shift unico +5 (come gli 8 forex del 15/08).")
        elif -75 <= delta <= -45:
            righe.append("  VERDETTO FUSO: EST FISSO (l'estate scivola di un'ora).")
            righe.append("  ATTENZIONE: uno shift unico NON basta. FERMARSI e riferire.")
        else:
            righe.append("  VERDETTO FUSO: INCERTO (differenza anomala). Guardare i mesi.")
    else:
        righe.append("  VERDETTO FUSO: non misurabile (servono mesi invernali E estivi).")
    if aperture_settimana:
        ore = [k.hour * 60 + k.minute for k in aperture_settimana]
        moda, quante = _moda(ore)
        righe.append("  apertura di SETTIMANA modale %02d:%02d (su %d settimane)" %
                     (moda // 60, moda % 60, quante))
    return righe


# ---------------------------------------------------------------------
#  CONTINUITA' E SANITA'
# ---------------------------------------------------------------------
def referto_barre(sym_bcm, pair, barre, banda):
    righe = []
    if not barre:
        righe.append("%s (%s): NESSUNA BARRA." % (sym_bcm, pair))
        return righe
    chiavi = sorted(barre.keys())
    per_anno = {}
    for k in chiavi:
        per_anno[k.year] = per_anno.get(k.year, 0) + 1
    pmin = min(b[7] for b in barre.values())
    pmax = max(b[6] for b in barre.values())
    righe.append("%s (%s): %d barre M1, dal %s al %s" % (
        sym_bcm, pair, len(chiavi),
        chiavi[0].strftime("%Y.%m.%d %H:%M"),
        chiavi[-1].strftime("%Y.%m.%d %H:%M")))
    righe.append("  prezzo minimo %.5f  massimo %.5f" % (pmin, pmax))
    if banda:
        lo, hi = banda
        if pmin < lo or pmax > hi:
            righe.append("  ALLARME: prezzi FUORI dalla banda attesa %.1f-%.1f."
                         " Simbolo sbagliato o unita' diverse: NON IMPORTARE." % (lo, hi))
        else:
            righe.append("  ordine di grandezza dentro la banda attesa %.1f-%.1f: OK" % (lo, hi))
    for anno in sorted(per_anno):
        righe.append("  %d: %d barre" % (anno, per_anno[anno]))
    # buchi intragiornalieri e giorni feriali mancanti
    buchi = 0
    peggior = None
    for a, b in zip(chiavi, chiavi[1:]):
        delta = (b - a).total_seconds() / 60.0
        if delta > 60 and a.date() == b.date():
            buchi += 1
            if peggior is None or delta > peggior[0]:
                peggior = (delta, a)
    righe.append("  buchi intragiornalieri > 60 min: %d%s" % (
        buchi, ("  (peggiore: %.0f min dopo %s)" %
                (peggior[0], peggior[1].strftime("%Y.%m.%d %H:%M"))) if peggior else ""))
    giorni = sorted(set(k.date() for k in chiavi))
    mancanti = []
    g = giorni[0]
    presenti = set(giorni)
    while g <= giorni[-1]:
        if g.weekday() < 5 and g not in presenti:
            mancanti.append(g)
        g = g + timedelta(days=1)
    righe.append("  giorni feriali SENZA nessuna barra: %d%s" % (
        len(mancanti),
        ("  (primi: " + ", ".join(str(x) for x in mancanti[:5]) + ")") if mancanti else ""))
    righe.append("  NOTA: i giorni di festa di borsa stanno legittimamente in quel conto.")
    return righe


def confronto_finestra(barre, da_txt, a_txt):
    """Controprova a tre feed: min/max/n su una finestra di timestamp,
    piu' le stesse finestre spostate di -1h e +1h (perche' finche' il
    fuso non e' misurato un'ora di dubbio va mostrata, non nascosta)."""
    righe = []
    try:
        da = datetime.strptime(da_txt, "%Y.%m.%d %H:%M")
        a = datetime.strptime(a_txt, "%Y.%m.%d %H:%M")
    except ValueError:
        return ["CONFRONTO: date non valide (attese YYYY.MM.DD HH:MM)."]
    righe.append("CONFRONTO su finestra %s -> %s (timestamp del file HistData)" % (da_txt, a_txt))
    for spost in (0, -1, 1):
        d = da + timedelta(hours=spost)
        b = a + timedelta(hours=spost)
        sel = [v for k, v in barre.items() if d <= k <= b]
        if not sel:
            righe.append("  spostamento %+dh: nessuna barra" % spost)
            continue
        pmin = min(x[7] for x in sel)
        pmax = max(x[6] for x in sel)
        righe.append("  spostamento %+dh: %d barre, minimo %.2f, massimo %.2f" %
                     (spost, len(sel), pmin, pmax))
    righe.append("  metro Dukascopy gia' agli atti (D30EUR, referto 18/08):")
    righe.append("    2025.06.15 20:00 -> 2025.06.16 19:59 = 1294 barre, min 23400.56, max 23715.65")
    righe.append("  terzo feed: il grafico D30EUR NATIVO di BCM sullo stesso giorno.")
    return righe


# ---------------------------------------------------------------------
#  SCRITTURA DEL CSV -- Formato 1 di ABTG_ImportaStoricoEsterno
#  "Time,Open,High,Low,Close,Volume" con data "YYYY.MM.DD HH:MM".
#  I prezzi passano COME SONO NEL FILE SORGENTE (stringhe): nessun
#  arrotondamento, nessuna conversione.
#  Il volume di HistData sugli indici e' 0; lo script MQL5 lo porta a 1
#  da solo (riga "tick_volume = (v>0 ? v : 1)"): qui si lascia com'e'.
# ---------------------------------------------------------------------
def scrivi_csv(percorso, barre, sposta_ore=0):
    with open(percorso, "w", newline="") as f:
        f.write("Time,Open,High,Low,Close,Volume\n")
        for k in sorted(barre.keys()):
            o, h, l, c, v = barre[k][0:5]
            t = k + timedelta(hours=sposta_ore) if sposta_ore else k
            f.write("%s,%s,%s,%s,%s,%s\n" %
                    (t.strftime("%Y.%m.%d %H:%M"), o, h, l, c, v))


# ---------------------------------------------------------------------
#  RACCOLTA SUL DESKTOP (regola delle righe di lancio, punto 2)
# ---------------------------------------------------------------------
def trova_desktop():
    casa = os.path.expanduser("~")
    for c in (os.path.join(casa, "Desktop"),
              os.path.join(casa, "OneDrive", "Desktop"),
              os.path.join(casa, "OneDrive - Personale", "Desktop")):
        if os.path.isdir(c):
            return c
    return None


def raccogli_desktop(file_da_copiare, nome_cartella, nome_zip_out):
    import shutil
    desktop = trova_desktop()
    base = desktop if desktop else os.getcwd()
    if not desktop:
        log("ATTENZIONE: nessun Desktop trovato, raccolgo nella cartella corrente.")
    dest = os.path.join(base, nome_cartella)
    os.makedirs(dest, exist_ok=True)
    for f in file_da_copiare:
        if os.path.exists(f):
            shutil.copy2(f, dest)
    zip_path = os.path.join(base, nome_zip_out)
    with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED) as z:
        for f in file_da_copiare:
            if os.path.exists(f):
                z.write(f, os.path.basename(f))
    log("")
    log("RACCOLTA: " + dest)
    log("ZIP PRONTO DA MANDARE: " + zip_path)
    log("Attesi dentro: " + ", ".join(os.path.basename(f) for f in file_da_copiare))


# ---------------------------------------------------------------------
#  AUTOTEST -- offline, nessuna rete.
#  Non dimostra che HistData risponda: dimostra che questo codice non
#  si morde la coda. La rete la prova --esplora sul PC.
# ---------------------------------------------------------------------
def autotest():
    log("=== AUTOTEST %s (offline) ===" % VERSIONE)
    ok = 0

    # 1. parser di una riga HistData vera (formato del README ufficiale)
    testo = ("20120201 000000;1.306600;1.306600;1.306560;1.306560;0\n"
             "20120201 000100;1.306570;1.306570;1.306470;1.306560;0\n"
             "20120201 000200;1.306520;1.306560;1.306520;1.306560;0\n")
    c = {"scartate": 0, "duplicate": 0, "ohlc_incoerenti": 0, "zip_rotti": 0}
    b = leggi_righe_histdata(testo, c)
    assert len(b) == 3, len(b)
    assert c["scartate"] == 0
    k = datetime(2012, 2, 1, 0, 1)
    assert b[k][0] == "1.306570" and b[k][3] == "1.306560", b[k]
    log("1. parser riga HistData 'YYYYMMDD HHMMSS;o;h;l;c;v': OK (3/3, 0 scarti)")
    ok += 1

    # 2. righe malate: OHLC incoerenti, duplicati, spazzatura
    testo2 = ("20120201 000000;1.30;1.29;1.31;1.30;0\n"      # high<low -> scartata
              "20120201 000100;1.30;1.31;1.29;1.30;0\n"
              "20120201 000100;1.40;1.41;1.39;1.40;0\n"      # duplicato
              "pippo\n"
              "20120201 000200;1.30;1.35;1.29;1.36;0\n")     # close>high
    c2 = {"scartate": 0, "duplicate": 0, "ohlc_incoerenti": 0, "zip_rotti": 0}
    b2 = leggi_righe_histdata(testo2, c2)
    assert len(b2) == 1, (len(b2), c2)
    assert c2["duplicate"] == 1 and c2["scartate"] >= 1 and c2["ohlc_incoerenti"] >= 1, c2
    log("2. righe malate riconosciute (high<low, close>high, duplicato, spazzatura): OK")
    ok += 1

    # 3. CSV Formato 1 byte per byte
    import tempfile
    tmp = os.path.join(tempfile.gettempdir(), "hd_autotest.csv")
    scrivi_csv(tmp, b)
    with open(tmp) as f:
        righe = f.read().splitlines()
    atteso0 = "Time,Open,High,Low,Close,Volume"
    atteso1 = "2012.02.01 00:00,1.306600,1.306600,1.306560,1.306560,0"
    assert righe[0] == atteso0, righe[0]
    assert righe[1] == atteso1, righe[1]
    log("3. riga CSV nel Formato 1 di ABTG_ImportaStoricoEsterno: OK")
    log("   " + righe[1])
    ok += 1

    # 4. misura del fuso: serie sintetica che APRE SEMPRE alle 03:00
    #    (feed che segue il DST) -> deve dire "segue il DST"
    sint = {}
    for mese in (1, 7):
        for giorno in range(1, 21):
            g = datetime(2021, mese, giorno)
            if g.weekday() >= 5:
                continue
            for m in range(0, 120):
                t = g.replace(hour=3) + timedelta(minutes=m)
                sint[t] = ("1", "1", "1", "1", "0", 1.0, 1.0, 1.0, 1.0)
    r = misura_fuso(sint)
    assert any("SEGUE il DST" in x for x in r), r[-3:]
    log("4. misura fuso su serie 'apre sempre 03:00': dice SEGUE il DST: OK")
    ok += 1

    # 5. e la controprova opposta: apertura 03:00 d'inverno e 02:00
    #    d'estate = EST fisso -> deve dire FERMARSI
    sint2 = {}
    for mese, ora in ((1, 3), (7, 2)):
        for giorno in range(1, 21):
            g = datetime(2021, mese, giorno)
            if g.weekday() >= 5:
                continue
            for m in range(0, 120):
                t = g.replace(hour=ora) + timedelta(minutes=m)
                sint2[t] = ("1", "1", "1", "1", "0", 1.0, 1.0, 1.0, 1.0)
    r2 = misura_fuso(sint2)
    assert any("EST FISSO" in x for x in r2), r2[-3:]
    log("5. misura fuso su serie 'estate un'ora prima': dice EST FISSO: OK")
    ok += 1

    # 6. ingestione da uno ZIP costruito qui, col nome interno vero
    zt = os.path.join(tempfile.gettempdir(), "hd_autotest.zip")
    with zipfile.ZipFile(zt, "w") as z:
        z.writestr("DAT_ASCII_GRXEUR_M1_2020.csv",
                   "20200602 093000;12345.60;12350.10;12340.20;12348.30;0\n"
                   "20200602 093100;12348.30;12352.00;12347.00;12351.00;0\n")
        z.writestr("DAT_ASCII_GRXEUR_M1_2020.txt", "status report, da ignorare")
    cart = os.path.join(tempfile.gettempdir(), "hd_autotest_zip")
    os.makedirs(cart, exist_ok=True)
    import shutil
    shutil.copy2(zt, os.path.join(cart, "qualsiasi_nome.zip"))
    c3 = {"scartate": 0, "duplicate": 0, "ohlc_incoerenti": 0, "zip_rotti": 0}
    dati = ingerisci_zip(cart, None, c3)
    assert "grxeur" in dati and len(dati["grxeur"]) == 2, dati.keys()
    log("6. ingestione ZIP (simbolo letto DENTRO, zip rinominato a caso): OK")
    ok += 1

    # 7. confronto a finestra
    r3 = confronto_finestra(dati["grxeur"], "2020.06.02 09:00", "2020.06.02 10:00")
    assert any("2 barre" in x for x in r3), r3
    log("7. confronto a finestra con spostamenti -1h/0/+1h: OK")
    ok += 1

    # 8. banda di prezzo: un DAX letto come se fosse un cambio deve urlare
    r4 = referto_barre("D30EUR", "grxeur", dati["grxeur"], (0.8, 1.8))
    assert any("ALLARME" in x for x in r4), r4
    log("8. allarme banda di prezzo (unita' sbagliate): OK")
    ok += 1

    log("")
    log("AUTOTEST: %d/8 passati." % ok)
    log("NOTA ONESTA: qui non c'e' NIENTE di rete. Che HistData risponda,")
    log("e quali anni abbia davvero, lo dice --esplora sul PC di Claudio.")
    return 0


# ---------------------------------------------------------------------
#  ESPLORAZIONE: la copertura si MISURA, non si ricorda
# ---------------------------------------------------------------------
def esplora(pairs, da_anno, a_anno, pausa_ms):
    righe = []
    righe.append("ESPLORAZIONE COPERTURA (pagina risponde? c'e' il token?)")
    righe.append("  legenda: TOKEN = file scaricabile | VUOTA = pagina senza")
    righe.append("           token (anno non pubblicato) | 404 = non esiste")
    # CONTROLLO POSITIVO: eurusd 2019 e' un bersaglio di cui sappiamo la
    # risposta (il feed forex 2018-2024 e' gia' stato scaricato e importato
    # il 15/08, 8 simboli su 8). Se questo fallisce, il canale e' NULLO e
    # tutto il resto della corsa non vuol dire niente.
    log("--- CONTROLLO POSITIVO: eurusd 2019 (gia' scaricato e importato il 15/08) ---")
    esito, html = richiesta(url_pagina("eurusd", 2019), timeout=90, pausa_ms=pausa_ms)
    tok = estrai_token(html) if esito == "OK" else ""
    if esito != "OK" or not tok:
        righe.append("CONTROLLO POSITIVO FALLITO (%s, token=%s)." % (esito, "si" if tok else "no"))
        righe.append("  -> la fonte e' NULLA da questa macchina: NON si misura niente.")
        righe.append("  -> passare alla STRADA MANUALE (browser), vedi --scarica --manuale.")
        for r in righe:
            log(r)
        return righe, False
    righe.append("CONTROLLO POSITIVO: OK (eurusd 2019, token presente, %d byte di pagina)" % len(html))
    log(righe[-1])

    oggi = datetime.now()
    for pair in pairs:
        sym = STRUMENTI.get(pair, (pair, 0, 0, "?"))[0]
        righe.append("")
        righe.append("%s -> %s  (primo mese dichiarato da fonte terza: %s)" %
                     (pair, sym, PRIMO_MESE.get(pair, "?")))
        log("--- %s ---" % pair)
        for anno in range(da_anno, a_anno + 1):
            if anno < oggi.year:
                esito, html = richiesta(url_pagina(pair, anno), timeout=90, pausa_ms=pausa_ms)
                if esito == "ASSENTE":
                    stato = "404"
                elif esito != "OK":
                    stato = esito
                else:
                    stato = "TOKEN" if estrai_token(html) else "VUOTA"
                righe.append("  %d  annuale: %s" % (anno, stato))
                log("  %d annuale: %s" % (anno, stato))
            else:
                mesi_ok = []
                mesi_no = []
                for mese in range(1, oggi.month + 1):
                    esito, html = richiesta(url_pagina(pair, anno, mese),
                                            timeout=90, pausa_ms=pausa_ms)
                    if esito == "OK" and estrai_token(html):
                        mesi_ok.append(mese)
                    else:
                        mesi_no.append(mese)
                righe.append("  %d  mensili con token: %s | senza: %s" % (
                    anno,
                    ",".join(str(m) for m in mesi_ok) if mesi_ok else "-",
                    ",".join(str(m) for m in mesi_no) if mesi_no else "-"))
                log(righe[-1])
    return righe, True


def elenco_manuale(pairs, da_anno, a_anno, cartella):
    righe = []
    oggi = datetime.now()
    righe.append("STRADA MANUALE (browser) -- e' accettabile e sono pochi click.")
    righe.append("Per ognuno: apri il link, premi il bottone DOWNLOAD, salva lo ZIP")
    righe.append("in questa cartella (il nome NON conta, lo script legge dentro):")
    righe.append("   " + cartella)
    for pair in pairs:
        righe.append("")
        righe.append("  %s (%s):" % (pair, STRUMENTI.get(pair, (pair,))[0]))
        for anno in range(da_anno, a_anno + 1):
            if anno < oggi.year:
                righe.append("    " + url_pagina(pair, anno))
            else:
                for mese in range(1, oggi.month + 1):
                    righe.append("    " + url_pagina(pair, anno, mese))
    righe.append("")
    righe.append("Poi: python histdata_m1.py --converti --cartella \"%s\"" % cartella)
    return righe


# ---------------------------------------------------------------------
def corri(argv):
    ap = argparse.ArgumentParser()
    ap.add_argument("--autotest", action="store_true")
    ap.add_argument("--esplora", action="store_true")
    ap.add_argument("--scarica", action="store_true")
    ap.add_argument("--converti", action="store_true")
    ap.add_argument("--manuale", action="store_true",
                    help="stampa solo l'elenco dei link da aprire nel browser")
    ap.add_argument("--simboli", default=",".join(SIMBOLI_MISSIONE))
    ap.add_argument("--da", type=int, default=2019)
    ap.add_argument("--a", type=int, default=datetime.now().year)
    ap.add_argument("--cartella", default="",
                    help="dove stanno/vanno gli ZIP (default ~/histdata_m1)")
    ap.add_argument("--pausa-ms", type=int, default=PAUSA_MS_DEFAULT)
    ap.add_argument("--sposta-ore", type=int, default=0,
                    help="shift manuale dei timestamp. DEFAULT 0 = si lasciano "
                         "come li scrive HistData, e la calibrazione la fa "
                         "ABTG_ImportaStoricoEsterno (atteso +5).")
    ap.add_argument("--confronto-da", default="")
    ap.add_argument("--confronto-a", default="")
    ap.add_argument("--validazione", action="store_true",
                    help="scorciatoia: GRXEUR 2025 + confronto sul giorno "
                         "campione gia' misurato da Dukascopy")
    args = ap.parse_args(argv)

    log("=== HISTDATA -> M1 ===  versione %s" % VERSIONE)
    log("data: %s (ora del PC)" % datetime.now().strftime("%Y-%m-%d %H:%M"))

    if args.autotest:
        return autotest()

    pairs = [p.strip().lower() for p in args.simboli.split(",") if p.strip()]
    sconosciuti = [p for p in pairs if p not in STRUMENTI]
    if sconosciuti:
        log("SIMBOLI NON IN MAPPA: %s" % ", ".join(sconosciuti))
        log("Quelli noti sono: %s" % ", ".join(sorted(STRUMENTI.keys())))
        log("Il Dow NON esiste su HistData: per U30USD usare dukascopy_m1.py.")
        return 2

    cartella = args.cartella or os.path.join(os.path.expanduser("~"), "histdata_m1")
    os.makedirs(cartella, exist_ok=True)

    if args.validazione:
        pairs = ["grxeur"]
        args.da = 2025
        args.a = 2025
        if not args.confronto_da:
            args.confronto_da = "2025.06.15 20:00"
            args.confronto_a = "2025.06.16 19:59"
        args.scarica = True
        args.converti = True

    stampa = []
    stampa.append("=== HISTDATA -> M1: referto ===")
    stampa.append("versione: %s" % VERSIONE)
    stampa.append("comando : %s" % " ".join(argv))
    stampa.append("data: %s (ora del PC)" % datetime.now().strftime("%Y-%m-%d %H:%M"))
    stampa.append("cartella ZIP: %s" % cartella)
    stampa.append("")

    if args.manuale:
        stampa += elenco_manuale(pairs, args.da, args.a, cartella)
        for r in stampa:
            log(r)
        return 0

    if args.esplora:
        righe, ok = esplora(pairs, args.da, args.a, args.pausa_ms)
        stampa += righe
        if not ok:
            stampa.append("")
            stampa += elenco_manuale(pairs, args.da, args.a, cartella)

    contatori = {"scaricati": 0, "cache": 0, "byte": 0, "scartate": 0,
                 "duplicate": 0, "ohlc_incoerenti": 0, "zip_rotti": 0}

    if args.scarica:
        log("")
        log("--- CONTROLLO POSITIVO prima di scaricare ---")
        esito, html = richiesta(url_pagina("eurusd", 2019), timeout=90,
                                pausa_ms=args.pausa_ms)
        if esito != "OK" or not estrai_token(html):
            stampa.append("CONTROLLO POSITIVO FALLITO (%s): il canale automatico" % esito)
            stampa.append("non funziona da questa macchina. NON si insiste.")
            stampa.append("")
            stampa += elenco_manuale(pairs, args.da, args.a, cartella)
            for r in stampa:
                log(r)
            scrivi_referto(stampa)
            return 1
        log("CONTROLLO POSITIVO: OK")
        stampa.append("CONTROLLO POSITIVO (eurusd 2019, token trovato): OK")

        oggi = datetime.now()
        falliti = []
        for pair in pairs:
            log("--- scarico %s ---" % pair)
            for anno in range(args.da, args.a + 1):
                periodi = ([(anno, None)] if anno < oggi.year
                           else [(anno, m) for m in range(1, oggi.month + 1)])
                for (a_, m_) in periodi:
                    esito, dest, nota = scarica_zip(pair, a_, m_, cartella,
                                                    args.pausa_ms, contatori)
                    etichetta = "%s %d%s" % (pair, a_, ("/%02d" % m_) if m_ else "")
                    if esito in ("OK", "CACHE"):
                        log("  %s: %s" % (etichetta, esito))
                    else:
                        log("  %s: %s (%s)" % (etichetta, esito, nota))
                        falliti.append((pair, a_, m_, esito + " " + nota))
        stampa.append("scaricati %d ZIP (%.1f MB), %d gia' in cache, %d falliti" % (
            contatori["scaricati"], contatori["byte"] / 1048576.0,
            contatori["cache"], len(falliti)))
        if falliti:
            stampa.append("FALLITI (di questi si fa la strada manuale):")
            for f in falliti:
                stampa.append("  %s %d%s  %s" % (f[0], f[1],
                                                 ("/%02d" % f[2]) if f[2] else "", f[3]))
            stampa.append("")
            stampa += elenco_manuale([f[0] for f in falliti], args.da, args.a, cartella)

    csv_prodotti = []
    if args.converti:
        log("")
        log("--- ingerisco gli ZIP in %s ---" % cartella)
        dati = ingerisci_zip(cartella, set(pairs), contatori)
        if not dati:
            stampa.append("NESSUNO ZIP UTILE nella cartella. Niente da convertire.")
        for pair in pairs:
            barre = dati.get(pair)
            if not barre:
                stampa.append("")
                stampa.append("%s: nessuna barra (zip mancante?)." % pair)
                continue
            sym, lo, hi, che = STRUMENTI[pair]
            stampa.append("")
            stampa += referto_barre(sym, pair, barre, (lo, hi))
            stampa.append("")
            stampa += misura_fuso(barre)
            if args.confronto_da and args.confronto_a:
                stampa.append("")
                stampa += confronto_finestra(barre, args.confronto_da, args.confronto_a)
            out = os.path.join(cartella, "%s_M1.csv" % sym)
            scrivi_csv(out, barre, args.sposta_ore)
            csv_prodotti.append(out)
            stampa.append("")
            stampa.append("CSV scritto: %s  (%d barre, shift applicato %+d h)" %
                          (out, len(barre), args.sposta_ore))
        stampa.append("")
        stampa.append("righe scartate %d | OHLC incoerenti %d | duplicate %d | zip rotti %d" %
                      (contatori["scartate"], contatori["ohlc_incoerenti"],
                       contatori["duplicate"], contatori["zip_rotti"]))

    stampa.append("")
    stampa.append("PROSSIMO PASSO (ultimo miglio, IDENTICO alla strada Dukascopy):")
    stampa.append("  1. copiare il/i CSV in MQL5\\Files del terminale BCM DI BACKTEST")
    stampa.append("  2. lanciare ABTG_ImportaStoricoEsterno con InpFormato=1,")
    stampa.append("     InpSimboloSorgente=<simbolo BCM>, InpSimboloNuovo=<simbolo>_EXT,")
    stampa.append("     InpAutoShift=true, InpShiftMax=6")
    stampa.append("  3. lo shift calibrato DEVE uscire +5 (come gli 8 forex del 15/08).")
    stampa.append("     Un altro numero = fermarsi e capire, NON importare.")
    stampa.append("  4. cancello ZERO: diff media > 0,05% o copertura < 80% -> non si usa.")
    stampa.append("  5. chiusura PULITA di MT5 (lezione 14/08).")

    for r in stampa:
        log(r)
    percorso_referto = scrivi_referto(stampa)
    raccogli_desktop([percorso_referto] + csv_prodotti[:4],
                     "histdata_m1", "histdata_m1.zip")
    return 0


def scrivi_referto(righe):
    nome = "referto_histdata_%s.txt" % datetime.now().strftime("%Y-%m-%d")
    percorso = os.path.join(os.getcwd(), nome)
    with open(percorso, "w") as f:
        f.write("\n".join(righe) + "\n")
    log("")
    log("REFERTO: " + percorso)
    return percorso


if __name__ == "__main__":
    sys.exit(corri(sys.argv[1:]))
