# =====================================================================
#  histdata_m1.py  --  LA STRADA HISTDATA per lo storico M1 degli INDICI
#  ---------------------------------------------------------------------
#  VERSIONE: HD-M1-v4        (marcatore: la riga di lancio lo stampa
#                             PRIMA di fare qualunque altra cosa)
#
#  v4 (19/08, missione dati): tre modi OFFLINE nuovi, per la diagnosi
#    chiesta dal par. 15-16 del REFERTO_HISTDATA_FATTIBILITA.md:
#      --estrai "AAAA.MM.GG HH:MM" --ore N
#          stampa le barre M1 intorno a quell'istante (riepilogo per
#          ora, buchi fra barre consecutive, salto prezzo massimo,
#          barre M1 una per una vicino al centro). ATTENZIONE: l'ora
#          va data COME E' SCRITTA NEL CSV, cioe' ora locale di New
#          York per i CSV HistData (NON ora server: server = NY+5,
#          oppure NY+4 dentro le finestre DST sfasate di marzo e
#          ottobre/novembre).
#      --diagnosi
#          scandisce le barre di un simbolo e stampa: i GIORNI con
#          prezzi fuori dalla banda attesa (per anno e per giorno,
#          con i valori), la mappa mese-per-mese dell'ora di apertura
#          (riusa misura_fuso) e i conteggi per anno. Trovare barre
#          marce QUI e' il mestiere della diagnosi, NON un errore:
#          l'exit code e' 0 se la scansione e' riuscita.
#      --vol-oraria
#          misura il range orario medio in % del prezzo (per anno e
#          totale, solo ore con almeno 30 barre M1): serve al metro
#          relativo del cancello (par. 16 del referto), per sostituire
#          le volatilita' [INFERITO] con numeri misurati.
#    I tre modi leggono <SIMBOLO>_M1.csv nella cartella (default
#    ~/histdata_m1); se il CSV non c'e', --diagnosi e --vol-oraria
#    ripiegano sugli ZIP presenti. Nessuna rete.
#
#  v2 (18/08 sera, verifica del verificatore-stringhe -- 16 difetti):
#    cache ZIP verificata e scrittura atomica (.parziale + replace),
#    zip corrotto CANCELLATO invece che lasciato a bucare per sempre,
#    CSV/referto atomici con encoding dichiarato, exit code legato ai
#    problemi reali (esplorazione fallita, zero barre, zip rotti,
#    ALLARME banda, EST FISSO, falliti di rete), mese in corso escluso
#    (NOTOKEN sull'anno corrente = assente, non fallito), autotest che
#    ritorna il conteggio vero, Desktop dal registro di Windows,
#    referto con ora nel nome e nella cartella degli ZIP, PROSSIMO
#    PASSO stampato solo se i CSV esistono davvero.
#  v3 (18/08 notte): bande di prezzo aggiornate ai massimi 2026.
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

VERSIONE = "HD-M1-v4"

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
    # Le bande servono a beccare ERRORI DI UNITA' (un indice letto come un
    # cambio: fattore 1000+), NON i tori. v3 (18/08 sera): i tetti v2 erano
    # tarati sui prezzi vecchi e la corsa vera li ha sfondati al rialzo
    # (Nikkei 66.253 a schermo contro tetto 60.000; Nasdaq 29.514 contro
    # 30.000; SPX 7.702 contro 8.000): tre ALLARMI su prezzi GIUSTI.
    "grxeur": ("D30EUR", 4000.0, 45000.0, "DAX 30/40 in EUR"),
    "nsxusd": ("NASUSD", 1500.0, 45000.0, "NASDAQ 100 in USD"),
    "jpxjpy": ("225JPY", 6000.0, 100000.0, "NIKKEI 225 in JPY"),
    "spxusd": ("SPXUSD", 600.0, 12000.0, "S&P 500 in USD"),
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


def _zip_valido(percorso):
    """Un file in cache o appena scaricato e' buono SOLO se si apre,
    supera il test CRC e contiene almeno un CSV. Lezione del gemello
    dukascopy_m1.py (punto 16 della checklist): la cache non verificata
    diventa un buco permanente che nessun rilancio ripara."""
    try:
        with zipfile.ZipFile(percorso) as z:
            if z.testzip() is not None:
                return False
            return any(n.lower().endswith(".csv") for n in z.namelist())
    except Exception:
        return False


def scarica_zip(pair, anno, mese, cartella, pausa_ms, contatori):
    dest = os.path.join(cartella, nome_zip(pair, anno, mese))
    if os.path.exists(dest):
        if os.path.getsize(dest) > 1000 and _zip_valido(dest):
            contatori["cache"] += 1
            return ("CACHE", dest, "")
        # rotto o troncato: si CANCELLA, cosi' il rilancio lo riscarica
        try:
            os.remove(dest)
        except OSError:
            return ("NO", "", "cache corrotta e non cancellabile: " + dest)
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
    tmp = dest + ".parziale"
    with open(tmp, "wb") as f:
        f.write(corpo)
    if not _zip_valido(tmp):
        os.remove(tmp)
        return ("NO", "", "risposta non decodificabile come ZIP")
    os.replace(tmp, dest)
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
        except Exception as e:
            # non solo BadZipFile: un membro corrotto solleva zlib.error
            # o RuntimeError a meta' lettura. Qualunque cosa sia, il file
            # si CANCELLA: lasciarlo li' significa rifallire per sempre.
            log("  %s: ZIP ILLEGGIBILE (%s) -- lo CANCELLO, riscaricalo" %
                (nz, type(e).__name__))
            contatori["zip_rotti"] += 1
            try:
                os.remove(percorso)
            except OSError:
                log("  %s: e non riesco nemmeno a cancellarlo" % nz)
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
#  ANALISI OFFLINE (v4) -- estrazione, diagnosi, volatilita' oraria.
#  Leggono i CSV gia' prodotti (Formato 1) o, in mancanza, gli ZIP.
#  Nessuna rete. L'ora e' SEMPRE quella scritta nel file.
# ---------------------------------------------------------------------
def leggi_csv_formato1(percorso, da=None, a=None):
    """Legge un CSV Formato 1 (Time,Open,High,Low,Close,Volume) e torna
    lo stesso dizionario di leggi_righe_histdata. Se da/a sono dati,
    tiene SOLO le barre nella finestra (lettura veloce: filtro sul
    prefisso data della riga, niente strptime fuori finestra)."""
    barre = {}
    giorni_ok = None
    if da is not None and a is not None:
        giorni_ok = set()
        g = da.date()
        while g <= a.date():
            giorni_ok.add(g.strftime("%Y.%m.%d"))
            g = g + timedelta(days=1)
    with open(percorso, "r", encoding="ascii", errors="replace") as f:
        for riga in f:
            riga = riga.strip()
            if len(riga) < 16 or riga[0] == "T":
                continue
            if giorni_ok is not None and riga[0:10] not in giorni_ok:
                continue
            campi = riga.split(",")
            if len(campi) < 5:
                continue
            s = campi[0]
            try:
                t = datetime(int(s[0:4]), int(s[5:7]), int(s[8:10]),
                             int(s[11:13]), int(s[14:16]))
            except ValueError:
                continue
            if da is not None and t < da:
                continue
            if a is not None and t > a:
                continue
            o, h, l, c = campi[1], campi[2], campi[3], campi[4]
            v = campi[5] if len(campi) > 5 else "0"
            try:
                fo, fh, fl, fc = float(o), float(h), float(l), float(c)
            except ValueError:
                continue
            if t not in barre:
                barre[t] = (o, h, l, c, v, fo, fh, fl, fc)
    return barre


def estrai_finestra(barre, centro, ore):
    """Le barre M1 intorno a un istante: riepilogo per ORA (n, OHLC,
    range in punti e in %), i buchi fra barre consecutive col salto di
    prezzo, il salto massimo close->open, e le barre M1 una per una da
    -30 a +60 minuti dal centro. Torna (righe, trovato_qualcosa)."""
    righe = []
    da = centro - timedelta(hours=ore)
    a = centro + timedelta(hours=ore)
    sel = sorted(k for k in barre if da <= k <= a)
    righe.append("ESTRAZIONE intorno a %s (+/- %d ore, ora COME SCRITTA nel file)" %
                 (centro.strftime("%Y.%m.%d %H:%M"), ore))
    righe.append("  (per i CSV HistData l'ora e' quella locale di NEW YORK:")
    righe.append("   ora server BCM = NY+5, oppure NY+4 dentro le finestre DST")
    righe.append("   sfasate di marzo e ottobre/novembre.)")
    if not sel:
        righe.append("  NESSUNA BARRA nella finestra %s -> %s." %
                     (da.strftime("%Y.%m.%d %H:%M"), a.strftime("%Y.%m.%d %H:%M")))
        return righe, False
    per_ora = {}
    for k in sel:
        per_ora.setdefault(k.replace(minute=0), []).append(k)
    righe.append("  riepilogo per ORA:")
    righe.append("    ora               n   open        min         max         close       range (pt e %)")
    for h in sorted(per_ora.keys()):
        ks = per_ora[h]
        lo = min(barre[k][7] for k in ks)
        hi = max(barre[k][6] for k in ks)
        op = barre[ks[0]][5]
        cl = barre[ks[-1]][8]
        med = (hi + lo) / 2.0
        pct = (hi - lo) / med * 100.0 if med > 0 else 0.0
        righe.append("    %s  %2d  %-10.2f  %-10.2f  %-10.2f  %-10.2f  %.2f (%.3f%%)" %
                     (h.strftime("%Y.%m.%d %H:%M"), len(ks), op, lo, hi, cl,
                      hi - lo, pct))
    buchi = []
    salto_max = (0.0, None, None)
    for x, y in zip(sel, sel[1:]):
        dmin = (y - x).total_seconds() / 60.0
        salto = abs(barre[y][5] - barre[x][8])
        if salto > salto_max[0]:
            salto_max = (salto, x, y)
        if dmin > 1:
            buchi.append("    BUCO %4d min: %s -> %s  (salto prezzo close->open %.2f)" %
                         (int(dmin), x.strftime("%Y.%m.%d %H:%M"),
                          y.strftime("%Y.%m.%d %H:%M"),
                          barre[y][5] - barre[x][8]))
    righe.append("  buchi > 1 min fra barre consecutive: %d" % len(buchi))
    righe += buchi[:30]
    if len(buchi) > 30:
        righe.append("    (... e altri %d)" % (len(buchi) - 30))
    if salto_max[1] is not None:
        righe.append("  salto massimo close->open fra barre consecutive: %.2f (%s -> %s)" %
                     (salto_max[0], salto_max[1].strftime("%Y.%m.%d %H:%M"),
                      salto_max[2].strftime("%Y.%m.%d %H:%M")))
    vicine = [k for k in sel
              if centro - timedelta(minutes=30) <= k <= centro + timedelta(minutes=60)]
    righe.append("  barre M1 da -30 a +60 minuti dal centro (%d):" % len(vicine))
    for k in vicine:
        o, h, l, c, v = barre[k][0:5]
        righe.append("    %s  O=%s  H=%s  L=%s  C=%s  V=%s" %
                     (k.strftime("%Y.%m.%d %H:%M"), o, h, l, c, v))
    return righe, True


def diagnosi_fuori_banda(sym, pair, barre, banda):
    """I giorni con prezzi fuori dalla banda attesa: quali anni, quante
    barre, che valori. Trovarne e' il MESTIERE della diagnosi (par. 13
    del referto: min 2.906 su GRXEUR), non un errore di questo modo."""
    lo, hi = banda
    righe = []
    righe.append("DIAGNOSI FUORI BANDA -- %s (%s), banda attesa %.1f-%.1f" %
                 (sym, pair, lo, hi))
    per_giorno = {}
    for k, val in barre.items():
        fl, fh = val[7], val[6]
        if fl < lo or fh > hi:
            g = k.date()
            e = per_giorno.get(g)
            if e is None:
                per_giorno[g] = [1, fl, fh]
            else:
                e[0] += 1
                e[1] = min(e[1], fl)
                e[2] = max(e[2], fh)
    if not per_giorno:
        righe.append("  nessuna barra fuori banda su %d barre." % len(barre))
        return righe, 0
    tot = sum(e[0] for e in per_giorno.values())
    righe.append("  barre fuori banda: %d, in %d giorni." % (tot, len(per_giorno)))
    per_anno = {}
    for g, (n, mn, mx) in per_giorno.items():
        a = per_anno.get(g.year)
        if a is None:
            per_anno[g.year] = [1, n, mn, mx]
        else:
            a[0] += 1
            a[1] += n
            a[2] = min(a[2], mn)
            a[3] = max(a[3], mx)
    righe.append("  per ANNO (giorni colpiti, barre, minimo e massimo visti):")
    for anno in sorted(per_anno.keys()):
        gg, nn, mn, mx = per_anno[anno]
        righe.append("    %d: %3d giorni, %6d barre, min %.3f, max %.3f" %
                     (anno, gg, nn, mn, mx))
    righe.append("  i GIORNI peggiori (max 40, ordinati per barre fuori banda):")
    ordinati = sorted(per_giorno.keys(), key=lambda g: -per_giorno[g][0])
    for g in sorted(ordinati[:40]):
        n, mn, mx = per_giorno[g]
        righe.append("    %s  %5d barre  min %.3f  max %.3f" % (g, n, mn, mx))
    if len(per_giorno) > 40:
        righe.append("    (... e altri %d giorni)" % (len(per_giorno) - 40))
    return righe, tot


def vol_oraria(sym, barre, minimo_barre=30):
    """Range orario medio in % del prezzo, per anno e totale. Conta solo
    le ore con almeno `minimo_barre` barre M1 (le nottate sottili con 2
    barre non sono 'un'ora di mercato' e annacquerebbero la media).
    Serve al metro relativo del cancello (par. 16 del referto)."""
    righe = []
    per_ora = {}
    for k, val in barre.items():
        h = (k.year, k.month, k.day, k.hour)
        e = per_ora.get(h)
        if e is None:
            per_ora[h] = [val[7], val[6], 1]
        else:
            if val[7] < e[0]:
                e[0] = val[7]
            if val[6] > e[1]:
                e[1] = val[6]
            e[2] += 1
    per_anno = {}
    tot = []
    scartate_sottili = 0
    for h, (lo, hi, n) in per_ora.items():
        if n < minimo_barre:
            scartate_sottili += 1
            continue
        med = (hi + lo) / 2.0
        if med <= 0:
            continue
        pct = (hi - lo) / med * 100.0
        per_anno.setdefault(h[0], []).append(pct)
        tot.append(pct)
    righe.append("VOLATILITA' ORARIA -- %s: range H1 medio in %% del prezzo" % sym)
    righe.append("  (solo ore con >= %d barre M1: ore piene %d, sottili scartate %d)" %
                 (minimo_barre, len(tot), scartate_sottili))
    if not tot:
        righe.append("  nessuna ora piena: non misurabile.")
        return righe, None
    for anno in sorted(per_anno.keys()):
        v = per_anno[anno]
        righe.append("    %d: media %.4f%%  (su %d ore)" %
                     (anno, sum(v) / len(v), len(v)))
    media = sum(tot) / len(tot)
    ordinate = sorted(tot)
    mediana = ordinate[len(ordinate) // 2]
    righe.append("  TOTALE: media %.4f%%  mediana %.4f%%  (su %d ore)" %
                 (media, mediana, len(tot)))
    return righe, media


def carica_barre_offline(pair, cartella, contatori):
    """Per i modi offline: prima il CSV gia' prodotto (<SIMBOLO>_M1.csv),
    altrimenti gli ZIP nella cartella. Torna (barre, descrizione fonte)."""
    sym = STRUMENTI[pair][0]
    percorso = os.path.join(cartella, "%s_M1.csv" % sym)
    if os.path.exists(percorso):
        return leggi_csv_formato1(percorso), "CSV " + percorso
    dati = ingerisci_zip(cartella, {pair}, contatori)
    return dati.get(pair, {}), "ZIP in " + cartella


def analisi_offline(args, pairs, cartella, stampa):
    """Il flusso dei modi offline v4 (--estrai / --diagnosi /
    --vol-oraria): niente rete, exit 0 se OGNI simbolo chiesto e' stato
    analizzato (le barre marce TROVATE dalla diagnosi non sono un
    problema: sono il risultato). Referto e raccolta come sempre."""
    problemi = []
    contatori = {"scartate": 0, "duplicate": 0, "ohlc_incoerenti": 0,
                 "zip_rotti": 0}
    centro = None
    if args.estrai:
        try:
            centro = datetime.strptime(args.estrai, "%Y.%m.%d %H:%M")
        except ValueError:
            log("--estrai: data non valida (attesa \"AAAA.MM.GG HH:MM\"): %s"
                % args.estrai)
            return 2
    for pair in pairs:
        sym, lo, hi, che = STRUMENTI[pair]
        stampa.append("")
        stampa.append("================ %s (%s) ================" % (sym, pair))
        if args.estrai and not (args.diagnosi or args.vol_oraria):
            # solo estrazione: si legge SOLO la finestra (veloce)
            percorso = os.path.join(cartella, "%s_M1.csv" % sym)
            if os.path.exists(percorso):
                margine = timedelta(hours=args.ore + 1)
                barre = leggi_csv_formato1(percorso, centro - margine,
                                           centro + margine)
                fonte = "CSV " + percorso
            else:
                barre, fonte = carica_barre_offline(pair, cartella, contatori)
        else:
            barre, fonte = carica_barre_offline(pair, cartella, contatori)
        stampa.append("fonte: %s" % fonte)
        if not barre:
            stampa.append("NESSUNA BARRA: manca %s_M1.csv e non ci sono ZIP utili." % sym)
            problemi.append("%s: nessuna barra da analizzare" % sym)
            continue
        if args.estrai:
            righe, trovato = estrai_finestra(barre, centro, args.ore)
            stampa += righe
            if not trovato:
                problemi.append("%s: nessuna barra nella finestra chiesta" % sym)
        if args.diagnosi:
            righe, _fuori = diagnosi_fuori_banda(sym, pair, barre, (lo, hi))
            stampa += righe
            stampa.append("")
            stampa.append("MAPPA MESE-PER-MESE DELL'ORA DI APERTURA (riuso di misura_fuso):")
            stampa += misura_fuso(barre)
            stampa.append("")
            stampa += referto_barre(sym, pair, barre, (lo, hi))
        if args.vol_oraria:
            stampa.append("")
            righe, media = vol_oraria(sym, barre)
            stampa += righe
            if media is None:
                problemi.append("%s: volatilita' oraria non misurabile" % sym)
    stampa.append("")
    if problemi:
        stampa.append("ESITO: FALLITO -- %d problemi:" % len(problemi))
        for p in problemi:
            stampa.append("  - " + p)
    else:
        stampa.append("ESITO: OK")
        if args.diagnosi:
            stampa.append("(le barre fuori banda TROVATE sono il risultato della")
            stampa.append(" diagnosi, non un guasto di questa corsa)")
    for r in stampa:
        log(r)
    percorso_referto = scrivi_referto(stampa, cartella)
    raccogli_desktop([percorso_referto], "histdata_m1", "histdata_m1.zip")
    return 1 if problemi else 0


# ---------------------------------------------------------------------
#  SCRITTURA DEL CSV -- Formato 1 di ABTG_ImportaStoricoEsterno
#  "Time,Open,High,Low,Close,Volume" con data "YYYY.MM.DD HH:MM".
#  I prezzi passano COME SONO NEL FILE SORGENTE (stringhe): nessun
#  arrotondamento, nessuna conversione.
#  Il volume di HistData sugli indici e' 0; lo script MQL5 lo porta a 1
#  da solo (riga "tick_volume = (v>0 ? v : 1)"): qui si lascia com'e'.
# ---------------------------------------------------------------------
def scrivi_csv(percorso, barre, sposta_ore=0):
    # atomico: mai lasciare un CSV troncato che poi finisce in MQL5\Files
    # come storico monco silenzioso. encoding esplicito: senza, Windows
    # usa cp1252 e un carattere non mappabile fa esplodere la scrittura.
    tmp = percorso + ".parziale"
    with open(tmp, "w", newline="", encoding="ascii", errors="replace") as f:
        f.write("Time,Open,High,Low,Close,Volume\n")
        for k in sorted(barre.keys()):
            o, h, l, c, v = barre[k][0:5]
            t = k + timedelta(hours=sposta_ore) if sposta_ore else k
            f.write("%s,%s,%s,%s,%s,%s\n" %
                    (t.strftime("%Y.%m.%d %H:%M"), o, h, l, c, v))
    os.replace(tmp, percorso)


# ---------------------------------------------------------------------
#  RACCOLTA SUL DESKTOP (regola delle righe di lancio, punto 2)
# ---------------------------------------------------------------------
def trova_desktop():
    # la verita' sta nel registro (Shell Folders\Desktop): quando OneDrive
    # ridirige la cartella lascia un guscio vuoto in ~/Desktop, e
    # l'euristica vecchia raccoglieva li' -- referto invisibile a Claudio.
    try:
        import winreg
        chiave = winreg.OpenKey(
            winreg.HKEY_CURRENT_USER,
            r"Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders")
        valore, _ = winreg.QueryValueEx(chiave, "Desktop")
        winreg.CloseKey(chiave)
        valore = os.path.expandvars(valore)
        if os.path.isdir(valore):
            return valore
    except Exception:
        pass
    casa = os.path.expanduser("~")
    for c in (os.path.join(casa, "OneDrive", "Desktop"),
              os.path.join(casa, "OneDrive - Personale", "Desktop"),
              os.path.join(casa, "Desktop")):
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

    # 9. --estrai su una serie con un BUCO di 30 min e un salto di prezzo:
    #    deve contare le barre giuste per ora, trovare il buco e il salto
    ser = {}
    base = datetime(2026, 3, 23, 10, 0)
    for m in range(0, 120):
        if 45 <= m < 75:            # buco 10:45 -> 11:15 (mancano 30 barre)
            continue
        prezzo = 100.0 + (50.0 if m >= 75 else 0.0)   # salto dopo il buco
        s = "%.2f" % prezzo
        ser[base + timedelta(minutes=m)] = (s, s, s, s, "0",
                                            prezzo, prezzo, prezzo, prezzo)
    r5, trovato = estrai_finestra(ser, datetime(2026, 3, 23, 11, 0), 1)
    assert trovato, r5
    assert any("buchi > 1 min fra barre consecutive: 1" in x for x in r5), r5
    assert any("BUCO   31 min" in x for x in r5), [x for x in r5 if "BUCO" in x]
    assert any("salto massimo close->open" in x and "50.00" in x for x in r5), r5
    r5b, trovato_b = estrai_finestra(ser, datetime(2020, 1, 1, 0, 0), 1)
    assert not trovato_b and any("NESSUNA BARRA" in x for x in r5b), r5b
    log("9. --estrai: conta per ora, trova il buco (31 min) e il salto 50.00: OK")
    ok += 1

    # 10. --diagnosi fuori banda: 2 giorni marci su 3 devono uscire con
    #     anno, conteggio barre e valori; il giorno sano no
    ser2 = {}
    for giorno, prezzo in ((1, 12000.0), (2, 2906.949), (3, 2950.0)):
        for m in range(0, 90):
            p = "%.3f" % prezzo
            ser2[datetime(2021, 6, giorno, 9, 0) + timedelta(minutes=m)] = (
                p, p, p, p, "0", prezzo, prezzo, prezzo, prezzo)
    r6, fuori = diagnosi_fuori_banda("D30EUR", "grxeur", ser2, (4000.0, 45000.0))
    assert fuori == 180, fuori
    assert any("2021:" in x and "180 barre" in x and "2906.949" in x for x in r6), r6
    assert any("2021-06-02" in x for x in r6), r6
    assert not any("2021-06-01 " in x for x in r6), r6
    r6b, fuori_b = diagnosi_fuori_banda("D30EUR", "grxeur",
                                        {k: v for k, v in ser2.items()
                                         if v[5] > 4000}, (4000.0, 45000.0))
    assert fuori_b == 0 and any("nessuna barra fuori banda" in x for x in r6b), r6b
    log("10. --diagnosi: 180 barre marce in 2 giorni, min 2906.949 stampato: OK")
    ok += 1

    # 11. --vol-oraria: un'ora piena con range noto (100 -> 102 su mid 101
    #     = 1.9802%) e un'ora sottile (2 barre) che va SCARTATA
    ser3 = {}
    for m in range(0, 60):
        lo_, hi_ = (100.0, 102.0) if m == 30 else (100.5, 101.5)
        ser3[datetime(2022, 5, 2, 14, 0) + timedelta(minutes=m)] = (
            "1", "%.1f" % hi_, "%.1f" % lo_, "1", "0", 1.0, hi_, lo_, 1.0)
    for m in range(0, 2):
        ser3[datetime(2022, 5, 2, 3, 0) + timedelta(minutes=m)] = (
            "1", "500", "1", "1", "0", 1.0, 500.0, 1.0, 1.0)
    r7, media = vol_oraria("PROVA", ser3)
    assert media is not None and abs(media - 1.9802) < 0.001, (media, r7)
    assert any("sottili scartate 1" in x for x in r7), r7
    log("11. --vol-oraria: range 2/101 = 1.9802 pct e ora sottile scartata: OK")
    ok += 1

    log("")
    log("AUTOTEST: %d/11 passati." % ok)
    log("NOTA ONESTA: qui non c'e' NIENTE di rete. Che HistData risponda,")
    log("e quali anni abbia davvero, lo dice --esplora sul PC di Claudio.")
    return 0 if ok == 11 else 1


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
                # il mese IN CORSO non e' ancora pubblicato: chiederlo
                # produce un NOTOKEN garantito che sporca la misura
                for mese in range(1, oggi.month):
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
                for mese in range(1, oggi.month):
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
    ap.add_argument("--estrai", default="",
                    help="istante \"AAAA.MM.GG HH:MM\" NELL'ORA DEL FILE "
                         "(= ora locale di New York per i CSV HistData): "
                         "stampa le barre M1 intorno, coi buchi e i salti")
    ap.add_argument("--ore", type=int, default=2,
                    help="semiampiezza della finestra di --estrai, in ore")
    ap.add_argument("--diagnosi", action="store_true",
                    help="giorni con prezzi fuori banda + mappa mese-per-mese "
                         "dell'ora di apertura (la malattia GRXEUR, par. 13)")
    ap.add_argument("--vol-oraria", action="store_true", dest="vol_oraria",
                    help="range orario medio in %% del prezzo, per anno "
                         "(serve al metro relativo del cancello, par. 16)")
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

    if args.estrai or args.diagnosi or args.vol_oraria:
        # modi OFFLINE v4: niente rete, niente scarica/converti
        return analisi_offline(args, pairs, cartella, stampa)

    problemi = []

    if args.esplora:
        righe, ok = esplora(pairs, args.da, args.a, args.pausa_ms)
        stampa += righe
        if not ok:
            problemi.append("esplorazione fallita (controllo positivo KO)")
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
            scrivi_referto(stampa, cartella)
            return 1
        log("CONTROLLO POSITIVO: OK")
        stampa.append("CONTROLLO POSITIVO (eurusd 2019, token trovato): OK")

        oggi = datetime.now()
        falliti = []
        assenti = []
        for pair in pairs:
            log("--- scarico %s ---" % pair)
            for anno in range(args.da, args.a + 1):
                periodi = ([(anno, None)] if anno < oggi.year
                           else [(anno, m) for m in range(1, oggi.month)])
                for (a_, m_) in periodi:
                    esito, dest, nota = scarica_zip(pair, a_, m_, cartella,
                                                    args.pausa_ms, contatori)
                    etichetta = "%s %d%s" % (pair, a_, ("/%02d" % m_) if m_ else "")
                    if esito in ("OK", "CACHE"):
                        log("  %s: %s" % (etichetta, esito))
                    elif esito == "NOTOKEN":
                        # non pubblicato = ASSENTE (informativo), non un
                        # guasto: altrimenti il gate scatta sempre a torto
                        log("  %s: assente (nessun token: non pubblicato)" % etichetta)
                        assenti.append(etichetta)
                    else:
                        log("  %s: %s (%s)" % (etichetta, esito, nota))
                        falliti.append((pair, a_, m_, esito + " " + nota))
        stampa.append("scaricati %d ZIP (%.1f MB), %d gia' in cache, %d assenti, %d falliti" % (
            contatori["scaricati"], contatori["byte"] / 1048576.0,
            contatori["cache"], len(assenti), len(falliti)))
        if assenti:
            stampa.append("ASSENTI (non pubblicati, informativo): " + ", ".join(assenti))
        if falliti:
            problemi.append("%d download falliti" % len(falliti))
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
            problemi.append("nessuno ZIP utile in cartella")
        for pair in pairs:
            barre = dati.get(pair)
            if not barre:
                stampa.append("")
                stampa.append("%s: nessuna barra (zip mancante?)." % pair)
                problemi.append("%s: zero barre" % pair)
                continue
            sym, lo, hi, che = STRUMENTI[pair]
            stampa.append("")
            righe_barre = referto_barre(sym, pair, barre, (lo, hi))
            stampa += righe_barre
            if any("ALLARME" in r for r in righe_barre):
                problemi.append("%s: ALLARME banda di prezzo" % pair)
            stampa.append("")
            righe_fuso = misura_fuso(barre)
            stampa += righe_fuso
            # match sul VERDETTO, non su "EST FISSO" nudo: la legenda
            # della misura contiene quelle parole in OGNI corsa
            if any("VERDETTO FUSO: EST FISSO" in r for r in righe_fuso):
                problemi.append("%s: VERDETTO FUSO EST FISSO (convenzione "
                                "diversa dagli 8 import promossi)" % pair)
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
        if contatori["zip_rotti"] > 0:
            problemi.append("%d zip rotti (cancellati: rilanciare per riscaricarli)"
                            % contatori["zip_rotti"])

    # il PROSSIMO PASSO si stampa SOLO se i CSV esistono davvero (punto 22
    # della checklist: mai istruire sul passo dopo senza gli artefatti)
    if csv_prodotti:
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

    stampa.append("")
    if problemi:
        stampa.append("ESITO: FALLITO -- %d problemi:" % len(problemi))
        for p in problemi:
            stampa.append("  - " + p)
    else:
        stampa.append("ESITO: OK")

    for r in stampa:
        log(r)
    percorso_referto = scrivi_referto(stampa, cartella)
    raccogli_desktop([percorso_referto] + csv_prodotti[:4],
                     "histdata_m1", "histdata_m1.zip")
    return 1 if problemi else 0


def scrivi_referto(righe, cartella=None):
    # nome con l'ORA: due corse lo stesso giorno non si mascherano a
    # vicenda, e un referto stantio non puo' piu' sembrare fresco.
    # cartella degli ZIP, non os.getcwd(): la corsa parte da dove capita.
    nome = "referto_histdata_%s.txt" % datetime.now().strftime("%Y-%m-%d_%H%M")
    base = cartella if cartella else os.getcwd()
    percorso = os.path.join(base, nome)
    tmp = percorso + ".parziale"
    with open(tmp, "w", encoding="ascii", errors="replace") as f:
        f.write("\n".join(righe) + "\n")
    os.replace(tmp, percorso)
    log("")
    log("REFERTO: " + percorso)
    return percorso


if __name__ == "__main__":
    sys.exit(corri(sys.argv[1:]))
