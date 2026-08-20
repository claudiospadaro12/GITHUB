# =====================================================================
#  dukascopy_m1.py  --  STORICO INDICI DA DUKASCOPY: tick .bi5 -> M1 CSV
# ---------------------------------------------------------------------
#  PERCHE' ESISTE (18/08/2026)
#    Lo storico BCM degli indici parte dal 26/09/2024: 21 mesi, UN solo
#    regime. La sonda del 15/08 (REFERTO_SONDA_DUKASCOPY.md) ha MISURATO
#    che Dukascopy ha i tick degli indici dal 2012 (Nikkei dal 2013).
#    Questo script scarica quei tick, li decodifica e produce CSV M1 nel
#    "Formato 1" che ABTG_ImportaStoricoEsterno legge gia':
#        YYYY.MM.DD HH:MM,Open,High,Low,Close,VolumeTick
#
#  PERCHE' GIRA SUL PC E NON NEL CLOUD
#    Il proxy dell'ambiente cloud BLOCCA datafeed.dukascopy.com (403 sul
#    CONNECT, misurato il 18/08). Quindi: PC di backtest.
#
#  REGOLA D'USO (congelata, report/ASPETTATIVE_REALISTICHE.md)
#    I dati importati servono SOLO come PROVA DI REGIME a parametri
#    CONGELATI. Non si tara MAI un parametro su un feed esterno.
#
#  COSA MISURA DA SOLO (invece di fidarsi della documentazione)
#    1. CONTROLLO POSITIVO: un'ora di EURUSD che la sonda del 15/08 ha
#       gia' visto rispondere (24.043 byte). Se non risponde, si ferma.
#    2. ORDINE DEI CAMPI del record tick: la documentazione pubblica
#       dice ask-prima-di-bid, ma qui si CONTA su un campione quante
#       righe hanno campo2>=campo3. Sotto il 95% di coerenza si ferma.
#    3. DIVISORE DEL PREZZO: il prezzo nei .bi5 e' un intero da dividere
#       per 10^k. k si sceglie mettendo la mediana del prezzo nella
#       banda plausibile dello strumento (DAX 4000-30000 ecc.). Se piu'
#       di un k cade in banda, si ferma e chiede --divisore.
#
#  FUSO ORARIO (la trappola vera di questo lavoro)
#    I .bi5 sono in UTC. Ma il calibratore di ABTG_ImportaStoricoEsterno
#    applica UNO shift fisso a tutto il file, e il server BCM segue l'ora
#    legale AMERICANA (misurato: 8 import HistData su 8, feed in ora di
#    New York, hanno calibrato tutti +5 con differenze 0,005-0,011% su
#    7 anni -- impossibile se il DST non coincidesse). UTC invece NON ha
#    ora legale: uno shift fisso da UTC sbaglierebbe di un'ora per meta'
#    anno. Percio' il default e' --fuso ny: i timestamp escono in ORA DI
#    NEW YORK (regola DST USA 2007+, implementata qui sotto, senza
#    dipendenze), identica convenzione di HistData. CONTROPROVA ATTESA:
#    il calibratore deve trovare +5 anche su questi file. Se trova un
#    altro numero, fermarsi e capire. Con --fuso utc escono in UTC.
#
#  USO (PC di backtest; serve python 3.8+)
#    ATTENZIONE, non si incollano righe sciolte: due comandi uno sotto
#    l'altro sono DUE comandi indipendenti, e il secondo parte anche se
#    il primo e' morto (checklist punto 21). La riga di lancio vera e'
#    UN SOLO blocco "& { ... }" che (1) trova python.exe vero -- non lo
#    stub del Microsoft Store -- (2) riscarica QUESTO file pinnato
#    all'hash del commit, (3) verifica il marcatore VERSIONE qui sotto,
#    (4) controlla il codice d'uscita di OGNI passo.
#    Il presente file NON e' un interprete di se stesso: python 3.8+ e'
#    una dipendenza MISURATA dalla riga, mai data per presente
#    (run_all.ps1 lo tratta da OPZIONALE: non e' una prova di presenza).
#    La raccolta sul Desktop (cartella dukascopy_m1 + zip) la fa lo
#    script da solo a fine corsa. Se lo stesso blocco lo chiama PIU' DI
#    UNA VOLTA, il referto ha sempre lo stesso nome e la seconda corsa
#    sovrascrive la prima: e' la riga che deve mettere ogni referto in
#    una cartella di sosta con un nome PROPRIO (checklist punto 26).
#
#  MODI
#    --autotest            round-trip sintetico del decoder, senza rete
#                          (dal 20/08 include l'audit delle BANDE)
#    --validazione         UN giorno di DAX (2025-06-16) + controlli.
#                          IGNORA --simboli: e' cablato su DEUIDXEUR.
#                          Per un giorno solo di un ALTRO simbolo si usa
#                          la corsa normale con --da/--a sullo stesso
#                          giorno (fa gli stessi controlli).
#    (niente)              missione piena: 4 indici, 2019-01-01 -> oggi
#    --simboli DEUIDXEUR   solo questi (nomi Dukascopy, virgole)
#    --da/--a YYYY-MM-DD   finestra date
#    --fuso ny|utc         default ny (vedi sopra)
#    --pausa-ms 250        respiro fra richieste (il 15/08 le raffiche
#                          hanno preso 503: e' rate limiting)
#
#  RIPRESA
#    Ogni ora scaricata resta in cache su disco (anche i 404, come file
#    vuoti .assente). Rilanciare NON riscarica: riparte da dove era.
#    LIMITE NOTO (20/08/2026): il CSV si scrive solo a FINE SIMBOLO, e
#    non esiste un modo di ricostruirlo dalla sola cache. Una corsa
#    lunga interrotta a meta' lascia la cache piena e ZERO CSV.
#
#  VELOCITA' MISURATA (18/08/2026, PC di backtest, non una stima)
#    Corsa DEUIDXEUR 2019->oggi: 25 giorni su 2389 in 1h43m (596 ore,
#    7,4 MB) con 503/reset/timeout continui = ~4 minuti PER GIORNO di
#    storico, proiezione ~7 GIORNI di crawl per un simbolo. Prima di
#    lanciare una finestra lunga si rifa' questa misura: se il ritmo e'
#    quello, la strada non e' percorribile cosi' com'e'.
# =====================================================================

import argparse
import io
import lzma
import os
import struct
import sys
import time
import urllib.error
import urllib.request
import zipfile
from datetime import datetime, timedelta, timezone

BASE = "https://datafeed.dukascopy.com/datafeed"
VERSIONE = "DUKA-M1-v3"            # marcatore: la riga di lancio lo cerca PRIMA di eseguire
RECORD = struct.Struct(">IIIff")   # ms-offset, p1, p2, vol1, vol2 (big-endian)
ATTESE_RETRY = [2, 5, 15, 30]      # secondi, come sonda_dukascopy.ps1
MAX_ERR_CONSEC = 20                # 15/08: quando Dukascopy bandisce risponde 503 a TUTTO

# Controllo positivo: URL che la sonda del 15/08 ha VISTO rispondere
# (giro3: EURUSD 2025 OK 24043 byte, ora 15 UTC del 16 giugno).
# ATTENZIONE: nel path il mese e' ZERO-BASED (giugno = 05).
CONTROLLO_URL = BASE + "/EURUSD/2025/05/16/15h_ticks.bi5"

# nome Dukascopy -> (nome simbolo BCM, banda plausibile del prezzo)
# Le bande coprono il minimo e il massimo storici 2012-2026 con margine:
# servono SOLO a scegliere il divisore 10^k, non a giudicare i dati.
#
# REGOLA DELLA BANDA (misurata il 20/08/2026, difetto RIPRODOTTO)
#   Il rapporto max/min deve essere < 10, e il tetto deve stare SOPRA il
#   prezzo di oggi con margine. Motivo: se il prezzo SFONDA il tetto,
#   l'unico 10^k che resta in banda e' quello che divide per DIECI VOLTE
#   TROPPO -- e lo script non se ne accorge, perche' il candidato e'
#   UNICO. Con la vecchia banda Dow 6000-60000 (rapporto ESATTAMENTE 10)
#   una mediana 60.100 usciva "divisore 1000 -> 6010.00": CSV con il Dow
#   a 6.010 punti, referto ESITO OK, codice d'uscita 0.
#   La finestra (tetto , 10*pavimento) e' l'unica zona in cui uno
#   sfondamento si ferma PULITO: con rapporto >= 10 quella finestra e'
#   VUOTA. Il divisore scelto finisce anche nel referto: si controlla a
#   occhio l'ordine di grandezza, sempre.
STRUMENTI = {
    "DEUIDXEUR":    ("D30EUR", 4000.0, 36000.0),    # DAX  (misurato 23.715 il 16/06/2025)
    "USA30IDXUSD":  ("U30USD", 8000.0, 70000.0),    # Dow  (~53.400 il 20/08/2026; 2012: ~12.000)
    "USATECHIDXUSD": ("NASUSD", 1500.0, 30000.0),   # Nasdaq 100  <-- BANDA DA RIFARE (rapporto 20)
    "JPNIDXJPY":    ("225JPY", 8000.0, 70000.0),    # Nikkei (2013: ~10.500)
    "USA500IDXUSD": ("S500USD", 600.0, 8000.0),     # S&P    <-- BANDA DA RIFARE (rapporto 13,3)
    "EURUSD":       ("EURUSD", 0.8, 1.8),           # controllo di schema
}
SIMBOLI_MISSIONE = ["DEUIDXEUR", "USA30IDXUSD", "USATECHIDXUSD", "JPNIDXJPY"]


def log(msg):
    print(msg, flush=True)


# ---------------------------------------------------------------------
#  ORA LEGALE USA (regola 2007+): DST dal secondo dom. di marzo 02:00
#  locali (= 07:00 UTC) al primo dom. di novembre 02:00 locali
#  (= 06:00 UTC). New York: UTC-4 in DST, UTC-5 fuori.
# ---------------------------------------------------------------------
def _ennesima_domenica(anno, mese, n):
    d = datetime(anno, mese, 1, tzinfo=timezone.utc)
    primo_dom = 1 + (6 - d.weekday()) % 7
    return datetime(anno, mese, primo_dom + 7 * (n - 1), tzinfo=timezone.utc)


def offset_ny(dt_utc):
    inizio = _ennesima_domenica(dt_utc.year, 3, 2).replace(hour=7)
    fine = _ennesima_domenica(dt_utc.year, 11, 1).replace(hour=6)
    return timedelta(hours=-4) if inizio <= dt_utc < fine else timedelta(hours=-5)


def converti_fuso(dt_utc, fuso):
    if fuso == "utc":
        return dt_utc
    return dt_utc + offset_ny(dt_utc)   # "ny": ora locale di New York


# ---------------------------------------------------------------------
#  RETE: una richiesta con retry sui codici temporanei.
#  Torna (esito, byte): esito in {"OK", "ASSENTE", "ERRORE ..."}.
#  Il 404 e' una risposta vera (il file non esiste); 429/5xx e i guasti
#  di rete sono "adesso no" e si ritentano (lezione del 15/08).
# ---------------------------------------------------------------------
def scarica_url(url, pausa_ms):
    ultimo = "ERRORE sconosciuto"
    for tentativo in range(len(ATTESE_RETRY) + 1):
        if pausa_ms > 0:
            time.sleep(pausa_ms / 1000.0)
        try:
            req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
            with urllib.request.urlopen(req, timeout=30) as r:
                dati = r.read()
            return ("OK", dati)
        except urllib.error.HTTPError as e:
            if e.code == 404:
                return ("ASSENTE", b"")
            ultimo = "ERRORE %d" % e.code
            if not (e.code == 429 or 500 <= e.code <= 504):
                return (ultimo, b"")
        except Exception as e:
            ultimo = "ERRORE rete: %s" % e
        if tentativo < len(ATTESE_RETRY):
            att = ATTESE_RETRY[tentativo]
            log("      (il server dice '%s', riprovo fra %d s)" % (ultimo, att))
            time.sleep(att)
    return (ultimo, b"")


def url_ora(sym, dt_utc):
    # MESE ZERO-BASED: gennaio = 00 (verificato dalla sonda del 15/08)
    return "%s/%s/%04d/%02d/%02d/%02dh_ticks.bi5" % (
        BASE, sym, dt_utc.year, dt_utc.month - 1, dt_utc.day, dt_utc.hour)


def decodificabile(dati):
    """Un .bi5 valido si apre. Serve a NON mettere in cache spazzatura (pagina
    d'errore servita con 200, risposta troncata) e a scoprire una cache
    AVVELENATA da un Ctrl+C preso a meta' scrittura: senza questo controllo
    quell'ora e' persa per sempre, perche' ogni rilancio la rilegge dalla
    cache, fallisce la decodifica e tira dritto."""
    if not dati:
        return True
    try:
        decodifica_bi5(dati)
        return True
    except Exception:
        return False


def scarica_ora_con_cache(sym, dt_utc, cartella_raw, pausa_ms, contatori):
    """Torna i byte .bi5 dell'ora (b'' se assente/vuota), usando la cache."""
    d = os.path.join(cartella_raw, sym, "%04d" % dt_utc.year,
                     "%02d" % dt_utc.month, "%02d" % dt_utc.day)
    f_ok = os.path.join(d, "%02dh_ticks.bi5" % dt_utc.hour)
    f_no = f_ok + ".assente"
    if os.path.exists(f_ok):
        with open(f_ok, "rb") as fh:
            dati = fh.read()
        if decodificabile(dati):
            contatori["cache"] += 1
            return dati
        log("      cache illeggibile (%d byte): la butto e riscarico -> %s"
            % (len(dati), f_ok))
        os.remove(f_ok)
    if os.path.exists(f_no):
        contatori["cache"] += 1
        return b""
    esito, dati = scarica_url(url_ora(sym, dt_utc), pausa_ms)
    if esito == "OK":
        if not decodificabile(dati):
            contatori["errori"] += 1
            contatori["consecutivi"] += 1
            contatori["ultimo_errore"] = ("risposta di %d byte non decodificabile su %s"
                                          % (len(dati), url_ora(sym, dt_utc)))
            return b""
        os.makedirs(d, exist_ok=True)
        tmp = f_ok + ".tmp"
        with open(tmp, "wb") as fh:
            fh.write(dati)
            fh.flush()
            os.fsync(fh.fileno())
        os.replace(tmp, f_ok)          # ATOMICA: o c'e' tutto o non c'e' niente
        contatori["scaricate"] += 1
        contatori["byte"] += len(dati)
        contatori["consecutivi"] = 0
        return dati
    if esito == "ASSENTE":
        os.makedirs(d, exist_ok=True)
        with open(f_no, "wb"):
            pass
        contatori["assenti"] += 1
        contatori["consecutivi"] = 0
        return b""
    contatori["errori"] += 1
    contatori["consecutivi"] += 1
    contatori["ultimo_errore"] = "%s su %s" % (esito, url_ora(sym, dt_utc))
    return b""


# ---------------------------------------------------------------------
#  DECODER .bi5: LZMA -> record da 20 byte big-endian.
#  I nomi p1/p2 restano anonimi finche' l'ordine ask/bid non e' MISURATO.
# ---------------------------------------------------------------------
def decodifica_bi5(dati):
    """Torna lista di tuple (ms, p1, p2, v1, v2). Vuoto se niente dati."""
    if not dati:
        return []
    grezzo = lzma.decompress(dati)
    if len(grezzo) % RECORD.size != 0:
        raise ValueError("lunghezza %d non multipla di %d: formato inatteso"
                         % (len(grezzo), RECORD.size))
    return list(RECORD.iter_unpack(grezzo))


def misura_ordine_campi(ticks):
    """Conta su un campione se p1>=p2 (atteso: p1=ask, p2=bid).
    Torna ("p1_ask" | "p2_ask", frazione_coerente)."""
    n = ge = le_ = 0
    for t in ticks[:20000]:
        if t[1] >= t[2]:
            ge += 1
        if t[2] >= t[1]:
            le_ += 1
        n += 1
    if n == 0:
        return (None, 0.0)
    if ge / n >= 0.95:
        return ("p1_ask", ge / n)
    if le_ / n >= 0.95:
        return ("p2_ask", le_ / n)
    return (None, max(ge, le_) / n)


def misura_divisore(prezzi_interi, banda_min, banda_max):
    """Sceglie 10^k che mette la MEDIANA del prezzo nella banda.
    Torna (divisore, mediana_scalata) o (None, candidati)."""
    ordinati = sorted(prezzi_interi)
    med = ordinati[len(ordinati) // 2]
    buoni = []
    for k in range(0, 6):
        div = 10 ** k
        if banda_min <= med / div <= banda_max:
            buoni.append((div, med / div))
    if len(buoni) == 1:
        return (buoni[0][0], buoni[0][1])
    # in caso di dubbio si torna la LISTA dei candidati con la mediana
    # GIA' scalata: chi legge deve poter scegliere a occhio in 5 secondi.
    return (None, buoni)


def banda_sospetta(banda_min, banda_max):
    """Torna una frase se la banda non si ferma pulita su uno sfondamento."""
    if banda_max >= 10 * banda_min:
        return ("rapporto %.1f >= 10: uno sfondamento del tetto NON si ferma, "
                "rientra in banda una decade sotto (divisore 10x sbagliato, "
                "accettato in silenzio)" % (banda_max / banda_min))
    return ""


# ---------------------------------------------------------------------
#  COSTRUTTORE M1: OHLC sul BID, volume = numero di tick.
#  I timestamp entrano in UTC ed escono nel fuso scelto.
# ---------------------------------------------------------------------
def ticks_in_m1(barre, ticks, ora_utc, divisore, ordine, fuso):
    idx_bid = 2 if ordine == "p1_ask" else 1
    for t in ticks:
        dt = converti_fuso(ora_utc + timedelta(milliseconds=t[0]), fuso)
        chiave = dt.replace(second=0, microsecond=0)
        bid = t[idx_bid] / divisore
        b = barre.get(chiave)
        if b is None:
            barre[chiave] = [bid, bid, bid, bid, 1]
        else:
            if bid > b[1]:
                b[1] = bid
            if bid < b[2]:
                b[2] = bid
            b[3] = bid
            b[4] += 1


def scrivi_atomico(percorso, testo):
    """Un file di uscita o c'e' TUTTO o non c'e': un CSV/referto troncato da
    un Ctrl+C e' un artefatto che il passo dopo mangia senza accorgersene."""
    tmp = percorso + ".tmp"
    with open(tmp, "w", newline="") as f:
        f.write(testo)
        f.flush()
        os.fsync(f.fileno())
    os.replace(tmp, percorso)


def scrivi_csv(percorso, barre, decimali):
    fmt = "%%.%df" % decimali
    buf = io.StringIO()
    buf.write("Time,Open,High,Low,Close,Volume\n")
    for chiave in sorted(barre.keys()):
        o, h, l, c, v = barre[chiave]
        buf.write("%s,%s,%s,%s,%s,%d\n" % (
            chiave.strftime("%Y.%m.%d %H:%M"),
            fmt % o, fmt % h, fmt % l, fmt % c, v))
    scrivi_atomico(percorso, buf.getvalue())


def referto_barre(sym_bcm, barre, fuso):
    """Statistiche di sanita': righe pronte da stampare e da salvare."""
    righe = []
    if not barre:
        righe.append("%s: NESSUNA BARRA." % sym_bcm)
        return righe
    chiavi = sorted(barre.keys())
    per_anno = {}
    for k in chiavi:
        per_anno[k.year] = per_anno.get(k.year, 0) + 1
    prezzi_min = min(b[2] for b in barre.values())
    prezzi_max = max(b[1] for b in barre.values())
    righe.append("%s: %d barre M1, dal %s al %s (fuso: %s)" % (
        sym_bcm, len(chiavi),
        chiavi[0].strftime("%Y.%m.%d %H:%M"),
        chiavi[-1].strftime("%Y.%m.%d %H:%M"),
        "ora di New York (convenzione HistData)" if fuso == "ny" else "UTC"))
    righe.append("  prezzo minimo %.2f  massimo %.2f" % (prezzi_min, prezzi_max))
    for anno in sorted(per_anno):
        righe.append("  %d: %d barre" % (anno, per_anno[anno]))
    # buchi > 60 minuti dentro la stessa giornata (i weekend non contano)
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
    return righe


# ---------------------------------------------------------------------
#  RACCOLTA SUL DESKTOP (regola delle righe di lancio, punto 2)
# ---------------------------------------------------------------------
def trova_desktop():
    """Il Desktop VERO: con OneDrive attivo ~/Desktop puo' non esistere piu'."""
    casa = os.path.expanduser("~")
    for c in (os.path.join(casa, "Desktop"),
              os.path.join(casa, "OneDrive", "Desktop"),
              os.path.join(casa, "OneDrive - Personale", "Desktop")):
        if os.path.isdir(c):
            return c
    return None


def raccogli_desktop(file_da_copiare, nome_zip):
    desktop = trova_desktop()
    base = desktop if desktop else os.getcwd()
    if not desktop:
        log("ATTENZIONE: nessun Desktop trovato, raccolgo nella cartella corrente.")
    dest = os.path.join(base, "dukascopy_m1")
    os.makedirs(dest, exist_ok=True)
    import shutil
    for f in file_da_copiare:
        if os.path.exists(f):
            shutil.copy2(f, dest)
    zip_path = os.path.join(base, nome_zip)
    with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED) as z:
        for f in file_da_copiare:
            if os.path.exists(f):
                z.write(f, os.path.basename(f))
    log("")
    log("RACCOLTA: " + dest)
    log("ZIP PRONTO: " + zip_path)
    log("Attesi dentro: " + ", ".join(os.path.basename(f) for f in file_da_copiare))


# ---------------------------------------------------------------------
#  AUTOTEST: round-trip sintetico del decoder, SENZA rete.
#  Non dimostra che il formato Dukascopy sia questo (quello lo misura
#  la corsa vera); dimostra che QUESTO codice non si morde la coda.
# ---------------------------------------------------------------------
def autotest():
    log("=== AUTOTEST (sintetico, senza rete) ===")
    # 1. round-trip: 3 tick noti -> lzma -> decodifica -> confronto
    tick_noti = [
        (1000, 1812345, 1812245, 1.5, 2.5),      # ms, ask, bid, volA, volB
        (59999, 1812400, 1812300, 0.1, 0.2),
        (3599999, 1813000, 1812900, 3.0, 1.0),
    ]
    grezzo = b"".join(RECORD.pack(*t) for t in tick_noti)
    compresso = lzma.compress(grezzo, format=lzma.FORMAT_ALONE)
    letti = decodifica_bi5(compresso)
    assert len(letti) == 3, "round-trip: numero tick sbagliato"
    for a, b in zip(tick_noti, letti):
        assert a[0] == b[0] and a[1] == b[1] and a[2] == b[2], "round-trip: campi"
        assert abs(a[3] - b[3]) < 1e-6 and abs(a[4] - b[4]) < 1e-6, "round-trip: volumi"
    log("1. round-trip pack->lzma->decodifica: OK (3 tick identici)")

    # 2. ordine campi: nel campione ask>=bid sempre -> p1_ask
    ordine, quota = misura_ordine_campi(letti)
    assert ordine == "p1_ask" and quota == 1.0, "ordine campi"
    log("2. misura ordine campi su campione coerente: OK (p1_ask, 100%)")

    # 3. divisore: mediana 1812400, banda DAX 4000-30000 -> 100 unico
    div, med = misura_divisore([t[1] for t in tick_noti], 4000.0, 30000.0)
    assert div == 100 and abs(med - 18124.0) < 0.01, "divisore"
    log("3. misura divisore (mediana in banda, unico k): OK (100 -> %.1f)" % med)

    # 4. barre M1: i primi due tick stanno in minuti diversi (0 e 0:59?):
    #    1000 ms -> minuto 0; 59999 ms -> minuto 0; 3599999 ms -> minuto 59.
    barre = {}
    ora = datetime(2025, 6, 16, 15, 0, tzinfo=timezone.utc)
    ticks_in_m1(barre, letti, ora, 100, "p1_ask", "utc")
    assert len(barre) == 2, "numero barre"
    b0 = barre[datetime(2025, 6, 16, 15, 0, tzinfo=timezone.utc)]
    assert b0[4] == 2 and abs(b0[0] - 18122.45) < 1e-9, "barra 0 (bid open)"
    assert abs(b0[3] - 18123.00) < 1e-9, "barra 0 close"
    log("4. costruttore M1 (OHLC bid, volume tick): OK (2 barre attese)")

    # 5. DST USA: 2025 inizia 9 marzo, finisce 2 novembre.
    assert offset_ny(datetime(2025, 3, 9, 6, 59, tzinfo=timezone.utc)) == timedelta(hours=-5)
    assert offset_ny(datetime(2025, 3, 9, 7, 0, tzinfo=timezone.utc)) == timedelta(hours=-4)
    assert offset_ny(datetime(2025, 11, 2, 5, 59, tzinfo=timezone.utc)) == timedelta(hours=-4)
    assert offset_ny(datetime(2025, 11, 2, 6, 0, tzinfo=timezone.utc)) == timedelta(hours=-5)
    assert offset_ny(datetime(2020, 7, 1, tzinfo=timezone.utc)) == timedelta(hours=-4)
    assert offset_ny(datetime(2020, 1, 15, tzinfo=timezone.utc)) == timedelta(hours=-5)
    log("5. regola DST USA (confini 2025 al minuto + estate/inverno 2020): OK")

    # 6. formato riga CSV = Formato 1 di ABTG_ImportaStoricoEsterno
    import tempfile
    with tempfile.TemporaryDirectory() as td:
        p = os.path.join(td, "t.csv")
        scrivi_csv(p, barre, 2)
        with open(p) as f:
            righe = f.read().splitlines()
    assert righe[0] == "Time,Open,High,Low,Close,Volume", "intestazione"
    assert righe[1].startswith("2025.06.16 15:00,18122.45,"), "riga dati: " + righe[1]
    assert righe[1].split(",")[5] == "2", "volume tick"
    log("6. riga CSV nel Formato 1 atteso da ABTG_ImportaStoricoEsterno: OK")

    # 7. LA BANDA CHE SFONDA IN SILENZIO (difetto riprodotto il 20/08/2026)
    #    Vecchia banda Dow 6000-60000, rapporto ESATTAMENTE 10: una mediana
    #    60.100 (Dow a +13% da oggi) trovava UN SOLO candidato -- quello
    #    sbagliato di 10 volte -- e usciva ESITO OK.
    div_v, med_v = misura_divisore([6010000], 6000.0, 60000.0)
    assert div_v == 1000 and abs(med_v - 6010.0) < 1e-9, "riproduzione del difetto"
    div_n, med_n = misura_divisore([6010000], *STRUMENTI["USA30IDXUSD"][1:])
    assert div_n == 100 and abs(med_n - 60100.0) < 1e-9, "banda Dow nuova: mediana 60.100"
    div_o, cand_o = misura_divisore([7500000], *STRUMENTI["USA30IDXUSD"][1:])
    assert div_o is None and cand_o == [], "banda Dow nuova: sopra il tetto si ferma PULITO"
    log("7. banda che sfonda in silenzio: riprodotta sulla vecchia (6010.00) e")
    log("   chiusa sulla nuova (60100.00; sopra 70.000 si ferma pulito): OK")

    # 8. audit di TUTTE le bande: quelle col rapporto >= 10 non si fermano
    #    pulite. Non e' un errore bloccante (il round in corso non le usa),
    #    ma non puo' restare invisibile.
    sospette = []
    for nome in sorted(STRUMENTI):
        bcm, lo, hi = STRUMENTI[nome]
        motivo = banda_sospetta(lo, hi)
        if motivo:
            sospette.append("   ATTENZIONE %s (%s) banda %g-%g: %s" % (nome, bcm, lo, hi, motivo))
    if sospette:
        log("8. audit bande: %d DA RIFARE prima di usarle (misurare il prezzo di oggi):"
            % len(sospette))
        for r in sospette:
            log(r)
    else:
        log("8. audit bande: tutte con rapporto < 10: OK")
    log("")
    log("AUTOTEST: TUTTO OK.")
    return 0


# ---------------------------------------------------------------------
#  CORSA VERA
# ---------------------------------------------------------------------
def giorni(da, a):
    d = da
    while d <= a:
        # Sabato UTC: nessun mercato indici. Domenica si tiene (riaperture serali).
        if d.weekday() != 5:
            yield d
        d += timedelta(days=1)


def corri(argv):
    ap = argparse.ArgumentParser()
    ap.add_argument("--autotest", action="store_true")
    ap.add_argument("--validazione", action="store_true")
    ap.add_argument("--simboli", default=",".join(SIMBOLI_MISSIONE))
    ap.add_argument("--da", default="2019-01-01")
    ap.add_argument("--a", default=datetime.now(timezone.utc).strftime("%Y-%m-%d"))
    ap.add_argument("--fuso", choices=["ny", "utc"], default="ny")
    ap.add_argument("--pausa-ms", type=int, default=250)
    ap.add_argument("--divisore", type=int, default=0,
                    help="forza il divisore del prezzo (0 = misuralo)")
    ap.add_argument("--cartella", default="",
                    help="dove lavorare (default: ~/dukascopy_lavoro)")
    ap.add_argument("--salta-controllo", action="store_true")
    args = ap.parse_args(argv)

    if args.autotest:
        return autotest()

    lavoro = args.cartella or os.path.join(os.path.expanduser("~"), "dukascopy_lavoro")
    raw = os.path.join(lavoro, "raw")
    out = os.path.join(lavoro, "m1")
    os.makedirs(raw, exist_ok=True)
    os.makedirs(out, exist_ok=True)

    log("=== DUKASCOPY -> M1 (%s) ===" % ("VALIDAZIONE 1 GIORNO" if args.validazione else "corsa"))
    log("cartella di lavoro: " + lavoro)
    log("fuso in uscita    : " + ("ora di New York (come HistData; il calibratore deve trovare +5)"
                                  if args.fuso == "ny" else "UTC (shift fisso NON copre il DST: solo per confronti)"))

    # --- fase 0: controllo positivo --------------------------------
    if not args.salta_controllo:
        log("")
        log("0) controllo positivo (EURUSD 2025-06-16 15 UTC, atteso ~24 KB)")
        esito, dati = scarica_url(CONTROLLO_URL, args.pausa_ms)
        if esito != "OK" or len(dati) == 0:
            log("   FALLITO (%s). Se il metro non funziona, non si misura niente." % esito)
            log("   Aspetta qualche minuto e rilancia (o --salta-controllo per forzare).")
            return 1
        try:
            ticks = decodifica_bi5(dati)
        except Exception as e:
            log("   RISPOSTA DI %d BYTE NON DECODIFICABILE (%s)." % (len(dati), e))
            log("   Non e' un .bi5: probabile pagina d'errore del CDN. MI FERMO.")
            return 1
        ordine, quota = misura_ordine_campi(ticks)
        div, med = misura_divisore([t[1] for t in ticks], 0.8, 1.8)
        log("   OK: %d byte, %d tick. Ordine campi: %s (%.1f%%). EURUSD mediana %s con divisore %s."
            % (len(dati), len(ticks), ordine, quota * 100,
               ("%.5f" % med) if div else "?", div))
        if ordine is None or div is None:
            log("   IL CONTROLLO NON TORNA: formato diverso dall'atteso. MI FERMO.")
            return 1

    if args.validazione:
        simboli = ["DEUIDXEUR"]
        da = a = datetime(2025, 6, 16, tzinfo=timezone.utc)
        log("")
        log("VALIDAZIONE: DAX del 2025-06-16 (lunedi'; la sonda ha gia' visto")
        log("l'ora 15 UTC rispondere con 17.875 byte). A fine corsa confronta")
        log("le barre con il grafico D30EUR nativo BCM dello stesso giorno:")
        log("quella data STA nello storico BCM (parte dal 2024-09-26).")
    else:
        simboli = [s.strip() for s in args.simboli.split(",") if s.strip()]
        da = datetime.strptime(args.da, "%Y-%m-%d").replace(tzinfo=timezone.utc)
        a = datetime.strptime(args.a, "%Y-%m-%d").replace(tzinfo=timezone.utc)

    righe_referto = []
    file_prodotti = []
    falliti = []
    incompleti = []
    for sym in simboli:
        if sym not in STRUMENTI:
            log("SALTO %s: strumento non in tabella (aggiungi banda plausibile)." % sym)
            falliti.append(sym)
            continue
        bcm, banda_min, banda_max = STRUMENTI[sym]
        log("")
        log("--- %s -> %s ---" % (sym, bcm))
        contatori = {"scaricate": 0, "assenti": 0, "errori": 0, "cache": 0,
                     "byte": 0, "ultimo_errore": "", "consecutivi": 0}
        barre = {}
        ordine_deciso = None
        divisore_deciso = args.divisore if args.divisore > 0 else None
        campione_prezzi = []
        t0 = time.time()
        n_giorni = sum(1 for _ in giorni(da, a))
        fatti = 0
        stop_totale = False
        for giorno in giorni(da, a):
            ticks_del_giorno = []
            for h in range(24):
                ora = giorno.replace(hour=h)
                dati = scarica_ora_con_cache(sym, ora, raw, args.pausa_ms, contatori)
                if contatori["consecutivi"] >= MAX_ERR_CONSEC:
                    log("STOP: %d errori DI FILA. Ultimo: %s"
                        % (contatori["consecutivi"], contatori["ultimo_errore"]))
                    log("     Il 15/08 Dukascopy ha risposto 503 a TUTTO: e' un ban")
                    log("     temporaneo, non un buco di storico. Aspetta e rilancia la")
                    log("     STESSA riga: la cache riparte da dove era.")
                    stop_totale = True
                    break
                if not dati:
                    continue
                try:
                    ticks = decodifica_bi5(dati)
                except Exception as e:
                    log("   %s %02dh: DECODIFICA FALLITA (%s) - ora saltata"
                        % (giorno.strftime("%Y-%m-%d"), h, e))
                    contatori["errori"] += 1
                    continue
                ticks_del_giorno.append((ora, ticks))
            if stop_totale:
                falliti.append(sym)
                break
            # misure una tantum sul primo giorno con dati
            if ticks_del_giorno and ordine_deciso is None:
                tutti = [t for _, tt in ticks_del_giorno for t in tt]
                ordine_deciso, quota = misura_ordine_campi(tutti)
                if ordine_deciso is None:
                    log("ORDINE CAMPI NON DECIDIBILE (coerenza %.1f%%). MI FERMO su %s."
                        % (quota * 100, sym))
                    falliti.append(sym)
                    break
                log("   ordine campi misurato: %s (coerenza %.1f%% su %d tick)"
                    % (ordine_deciso, quota * 100, len(tutti)))
                if divisore_deciso is None:
                    campione_prezzi = [t[1] for t in tutti]
                    divisore_deciso, med = misura_divisore(campione_prezzi, banda_min, banda_max)
                    if divisore_deciso is None:
                        if not med:
                            perche = ("NESSUN 10^k mette la mediana (%d) nella banda %g-%g: "
                                      "o il formato e' diverso dall'atteso, o la BANDA E' "
                                      "STANTIA (il prezzo di oggi ha sfondato il tetto)"
                                      % (sorted(campione_prezzi)[len(campione_prezzi) // 2],
                                         banda_min, banda_max))
                        else:
                            perche = ("piu' candidati in banda: " +
                                      "  ".join("divisore %d -> %.2f" % (d, m) for d, m in med))
                        log("DIVISORE NON DECIDIBILE (%s). Rilancia con --divisore. MI FERMO su %s."
                            % (perche, sym))
                        falliti.append(sym)
                        break
                    log("   divisore misurato: %d (mediana %.2f, banda %g-%g)"
                        % (divisore_deciso, med, banda_min, banda_max))
            for ora, ticks in ticks_del_giorno:
                ticks_in_m1(barre, ticks, ora, divisore_deciso, ordine_deciso, args.fuso)
            fatti += 1
            if fatti % 25 == 0 or fatti == n_giorni:
                trascorso = time.time() - t0
                log("   %d/%d giorni  (%d ore scaricate, %d in cache, %d assenti, %d errori; %.1f MB; %.0f s)"
                    % (fatti, n_giorni, contatori["scaricate"], contatori["cache"],
                       contatori["assenti"], contatori["errori"],
                       contatori["byte"] / 1e6, trascorso))
        decimali = {1: 0, 10: 1, 100: 2, 1000: 3, 10000: 4}.get(divisore_deciso, 5)
        csv_path = os.path.join(out, bcm + "_M1.csv")
        if barre:
            scrivi_csv(csv_path, barre, decimali)
            file_prodotti.append(csv_path)
        righe = referto_barre(bcm, barre, args.fuso)
        righe.append("  divisore usato %s, ordine campi %s  <-- CONTROLLA L'ORDINE DI GRANDEZZA"
                     % (divisore_deciso, ordine_deciso))
        righe.append("  scaricate %d ore (%.1f MB .bi5), %d dalla cache, %d assenti (404), %d errori"
                     % (contatori["scaricate"], contatori["byte"] / 1e6,
                        contatori["cache"], contatori["assenti"], contatori["errori"]))
        if contatori["ultimo_errore"]:
            righe.append("  ULTIMO ERRORE: " + contatori["ultimo_errore"])
            righe.append("  (con errori > 0 la copertura NON e' garantita: rilancia,")
            righe.append("   la cache evita di riscaricare quello che c'e' gia')")
        if not barre and sym not in falliti:
            falliti.append(sym)
        if contatori["errori"] > 0 and sym not in falliti and sym not in incompleti:
            incompleti.append(sym)
        for r in righe:
            log(r)
        righe_referto.extend(righe + [""])

    # --- referto + raccolta Desktop --------------------------------
    esito = ("FALLITO: " + ", ".join(falliti)) if falliti else (
            ("COMPLETO MA CON BUCHI (rilancia): " + ", ".join(incompleti)) if incompleti else "OK")
    ref_path = os.path.join(out, "referto_dukascopy_m1.txt")
    testa = io.StringIO()
    testa.write("=== DUKASCOPY -> M1: referto ===\n")
    testa.write("versione: %s\n" % VERSIONE)
    testa.write("comando : %s\n" % " ".join(argv))
    testa.write("ESITO   : %s\n" % esito)
    testa.write("data: %s (ora del PC)  =  %s UTC\n" % (
        datetime.now().strftime("%Y-%m-%d %H:%M"),
        datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M")))
    testa.write("fuso timestamp: %s\n\n" % ("ora di New York (convenzione HistData, shift atteso +5)"
                                            if args.fuso == "ny" else "UTC"))
    testa.write("\n".join(righe_referto))
    scrivi_atomico(ref_path, testa.getvalue())
    file_prodotti.append(ref_path)
    raccogli_desktop(file_prodotti, "dukascopy_m1.zip")
    log("")
    log("ESITO: " + esito)
    if falliti:
        return 1
    if incompleti:
        log("Rilancia la STESSA riga: la cache non riscarica quello che c'e' gia'.")
        return 3
    log("PROSSIMO PASSO: i CSV vanno in MQL5\\Files del terminale BCM di backtest,")
    log("poi ABTG_ImportaStoricoEsterno con InpFormato=1 (procedura nel referto")
    log("REFERTO_DUKASCOPY_FATTIBILITA.md, sezione 'ultimo miglio').")
    return 0


if __name__ == "__main__":
    try:
        sys.exit(corri(sys.argv[1:]))
    except KeyboardInterrupt:
        log("")
        log("INTERROTTA A MANO. La cache su disco resta valida (scritture atomiche):")
        log("rilancia la STESSA riga e riparte da dove era. Il CSV si scrive solo a")
        log("fine simbolo, quindi ora NON c'e': e' normale.")
        sys.exit(130)
