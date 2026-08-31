# =====================================================================
#  dukascopy_tick.py  --  TICK DUKASCOPY -> CSV TICK per import MT5
#  ================== PASSO 0: STRUMENTO, NON LANCIO ==================
#  Le righe di lancio NON esistono ancora: arriveranno con verificatore
#  quando Claudio decidera' di lanciare (DUKASCOPY_PASSO0.md, punto 4).
# ---------------------------------------------------------------------
#  PERCHE' ESISTE (31/08/2026, DUKASCOPY_PASSO0.md in questa cartella)
#    Due verdetti sono PARCHEGGIATI per mancanza di tick:
#    1. NY Session Retest: cella slope75 PF 1.37-1.43 ma n=114 < muro
#       R59 (tick BCM solo dal 2024.09.26). Tick Dow pre-2024 =
#       campione piu' lungo, tagliando anticipato di anni.
#       (REFERTO_NYRETEST_2026-08-31.md)
#    2. CRT Turtle Soup: vive nel chop 2022-2023 su OHLC, ma il
#       verdetto tick nel SUO regime e' impossibile su BCM.
#       (REFERTO_CRT_2026-08-30.md)
#    Il fratello dukascopy_m1.py produce M1 (OHLC). QUESTO script
#    produce TICK (time, msec, bid, ask) per CustomTicksAdd/Replace:
#    solo cosi' il tester Modello 4 su simbolo custom ha tick VERI.
#
#  PERCHE' GIRA SUL PC E NON NEL CLOUD
#    Il proxy cloud BLOCCA datafeed.dukascopy.com (403 sul CONNECT,
#    misurato il 18/08). Quindi: PC di backtest.
#
#  IL MOTORE DI RETE (v2, misurato il 31/08 pomeriggio dal PC di backtest)
#    Il server datafeed.dukascopy.com STRANGOLA le connessioni di
#    Python-urllib (WinError 10060/10054 + 503 a raffica, anche con
#    User-Agent Mozilla) ma fa passare curl.exe e Invoke-WebRequest.
#    MISURATO: curl.exe sul canarino EURUSD/2025/05/16/15h_ticks.bi5
#    = HTTP 200, 24043 byte, mentre NELLO STESSO MINUTO questo script
#    con urllib moriva. E' discriminazione dell'IMPRONTA TLS, non un ban.
#    Cura: --motore curl (subprocess su curl/curl.exe). Il default resta
#    urllib (comportamento storico invariato); la riga di lancio passa
#    SEMPRE --motore curl. Retry/backoff/contatori/log sono IDENTICI e
#    CONDIVISI fra i due motori: cambia solo la richiesta grezza.
#
#  REGOLA D'USO (congelata, report/ASPETTATIVE_REALISTICHE.md)
#    I dati importati servono SOLO per VERDETTI A PARAMETRI CONGELATI
#    (prova di regime, allungamento del campione di una cella gia'
#    tarata su BCM). Non si tara MAI un parametro su un feed esterno.
#
#  IL MURO GIA' PAGATO (18/08/2026, misurato, non teoria)
#    La corsa M1 DEUIDXEUR 2019->oggi e' stata strozzata dal server:
#    25 giorni su 2389 in 1h43m con 503/reset continui = ~4 min PER
#    GIORNO di storico. Le missioni tick di questo script sono FINESTRE
#    DICHIARATE (non "tutto dal 2012"), la cache rende la corsa
#    interrompibile gratis, e ogni 25 giorni lo script stampa la
#    PROIEZIONE: se il ritmo e' quello del 18/08, ci si ferma e si
#    ridiscute, non si insiste.
#
#  COSA MISURA DA SOLO (invece di fidarsi della documentazione)
#    1. CONTROLLO POSITIVO: l'ora EURUSD che la sonda del 15/08 ha
#       gia' visto rispondere (24.043 byte). Se non risponde, stop.
#    2. ORDINE DEI CAMPI del record (ask/bid): contato su campione,
#       sotto il 95% di coerenza si ferma.
#    3. DIVISORE DEL PREZZO: 10^k scelto mettendo la mediana nella
#       banda plausibile (regola della banda: rapporto max/min < 10,
#       tetto sopra il prezzo di oggi -- difetto del 20/08 chiuso).
#
#  FUSO ORARIO (LA trappola -- qui la conversione e' NEL CONVERTITORE)
#    I .bi5 sono in UTC (certo). Il server BCM d'estate piena e
#    d'inverno pieno sta a "ora italiana - 1" (= UTC+1 / UTC+0).
#    Il punto APERTO sono le settimane in cui DST USA e DST EUROPEO
#    non coincidono (marzo e fine ottobre/inizio novembre):
#      - gli 8 import forex HistData (feed in ora di New York) hanno
#        calibrato +5 PIATTO con diff 0,005-0,011% su 7 anni;
#      - la cura DST-aware NY->EU della v2 ha PEGGIORATO la diff
#        sugli indici del 7,7-8,6% (REFERTO_HISTDATA par. 15) -- ma
#        quella misura e' contaminata dall'evento del 23/03/2026.
#    QUINDI: default --dst usa (l'ipotesi meglio supportata: server =
#    UTC + 1h quando il DST USA e' attivo), --dst europa disponibile
#    (server = UTC + 1h quando il DST EU e' attivo), --fuso utc per i
#    confronti. LA SONDA DECIDE (DUKASCOPY_PASSO0.md, criterio
#    congelato): confronto tick contro il nativo BCM NELLE settimane
#    sfasate della sovrapposizione 2024.10+. Se vince "europa", si
#    rilancia con --solo-cache --dst europa: zero riscarichi.
#
#  USO (PC di backtest; python 3.8+, come dukascopy_m1.py)
#    --autotest              round-trip + fusi + CSV + motore curl su
#                            server HTTP locale (niente rete esterna)
#    --motore urllib|curl    motore di rete (default urllib = storico;
#                            curl = il motore misurato-passante 31/08)
#    --simboli USA30IDXUSD   nomi Dukascopy, virgole
#    --da/--a YYYY-MM-DD     finestra DICHIARATA (obbligatoria in corsa)
#    --dst usa|europa        calendario del server (default usa)
#    --fuso server|utc       default server
#    --pausa-ms 250          respiro fra richieste (503 = rate limit)
#    --divisore N            forza il divisore (0 = misuralo)
#    --solo-cache            niente rete: riconverte dalla cache
#    --cartella DIR          lavoro (default ~/dukascopy_lavoro, la
#                            STESSA cache raw/ di dukascopy_m1.py)
#
#  USCITA
#    m1/../tick/<BCM>_ticks_YYYY-MM.csv   un file PER MESE (ora server),
#      intestazione: Time,Msec,Bid,Ask
#      riga:         2022.03.14 15:30:07,842,32941.5,32944.0
#    Il file del mese si scrive ATOMICO appena il mese e' completo:
#    una corsa interrotta conserva i mesi finiti (il mese in corso si
#    rifa' dalla cache al rilancio, gratis). Referto + raccolta
#    Desktop + zip a fine corsa, come da regola delle righe di lancio.
#
#  RIPRESA
#    Cache su disco per ora scaricata (anche i 404 come .assente),
#    scritture atomiche, cache avvelenata riscaricata da sola.
#    Rilanciare NON riscarica: riparte da dove era.
# =====================================================================

import argparse
import io
import lzma
import os
import shutil
import struct
import subprocess
import sys
import tempfile
import time
import urllib.error
import urllib.request
import zipfile
from datetime import datetime, timedelta, timezone

BASE = "https://datafeed.dukascopy.com/datafeed"
VERSIONE = "DUKA-TICK-v2"          # marcatore: la riga di lancio lo cerchera' PRIMA di eseguire
RECORD = struct.Struct(">IIIff")   # ms-offset, p1, p2, vol1, vol2 (big-endian)
ATTESE_RETRY = [2, 5, 15, 30]      # secondi, come sonda_dukascopy.ps1
MAX_ERR_CONSEC = 20                # 15/08: quando Dukascopy bandisce risponde 503 a TUTTO

# Controllo positivo: URL che la sonda del 15/08 ha VISTO rispondere
# (giro3: EURUSD 2025 OK 24043 byte, ora 15 UTC del 16 giugno).
# ATTENZIONE: nel path il mese e' ZERO-BASED (giugno = 05).
CONTROLLO_URL = BASE + "/EURUSD/2025/05/16/15h_ticks.bi5"

# nome Dukascopy -> (nome BCM di base, banda min, banda max)
# Il simbolo custom di destinazione sara' <BCM>_DK (es. U30USD_DK).
# REGOLA DELLA BANDA (20/08/2026): rapporto max/min < 10 e tetto sopra
# il prezzo di oggi, altrimenti uno sfondamento accetta in silenzio un
# divisore 10x sbagliato. Le bande qui sotto valgono per le MISSIONI
# DICHIARATE (2019+): una finestra piu' vecchia (Nasdaq 2012 ~2500)
# esce di banda e lo script SI FERMA chiedendo --divisore. Voluto.
STRUMENTI = {
    "USA30IDXUSD":   ("U30USD", 8000.0, 70000.0),   # Dow    (~53.400 il 20/08/2026; min missione ~18.600 mar 2020)
    "USATECHIDXUSD": ("NASUSD", 5000.0, 45000.0),   # Nasdaq (min missione ~6.600 mar 2020; oggi ~25.000)
    "EURUSD":        ("EURUSD", 0.8, 1.8),          # controllo di schema
}


def log(msg):
    print(msg, flush=True)


# ---------------------------------------------------------------------
#  DST: le DUE regole di calendario, entrambe implementate e autotestate.
#  USA (2007+): 2a domenica di marzo 07:00 UTC -> 1a domenica di
#               novembre 06:00 UTC.
#  EU:          ultima domenica di marzo 01:00 UTC -> ultima domenica
#               di ottobre 01:00 UTC.
#  server = UTC + 1h quando il DST del calendario scelto e' attivo.
#  (Estate piena e inverno pieno: i due calendari coincidono e danno
#   la regola di casa "ora italiana - 1". Divergono solo nelle
#   settimane sfasate: e' la sonda a decidere quale regge sui tick.)
# ---------------------------------------------------------------------
def _ennesima_domenica(anno, mese, n):
    d = datetime(anno, mese, 1, tzinfo=timezone.utc)
    primo_dom = 1 + (6 - d.weekday()) % 7
    return datetime(anno, mese, primo_dom + 7 * (n - 1), tzinfo=timezone.utc)


def _ultima_domenica(anno, mese):
    # ultimo giorno del mese, poi indietro fino alla domenica
    if mese == 12:
        d = datetime(anno + 1, 1, 1, tzinfo=timezone.utc) - timedelta(days=1)
    else:
        d = datetime(anno, mese + 1, 1, tzinfo=timezone.utc) - timedelta(days=1)
    return d - timedelta(days=(d.weekday() + 1) % 7)


def dst_usa_attivo(dt_utc):
    inizio = _ennesima_domenica(dt_utc.year, 3, 2).replace(hour=7)
    fine = _ennesima_domenica(dt_utc.year, 11, 1).replace(hour=6)
    return inizio <= dt_utc < fine


def dst_eu_attivo(dt_utc):
    inizio = _ultima_domenica(dt_utc.year, 3).replace(hour=1)
    fine = _ultima_domenica(dt_utc.year, 10).replace(hour=1)
    return inizio <= dt_utc < fine


def offset_server(dt_utc, dst):
    if dst == "usa":
        return timedelta(hours=1) if dst_usa_attivo(dt_utc) else timedelta(0)
    return timedelta(hours=1) if dst_eu_attivo(dt_utc) else timedelta(0)


def converti_fuso(dt_utc, fuso, dst):
    if fuso == "utc":
        return dt_utc
    return dt_utc + offset_server(dt_utc, dst)


# ---------------------------------------------------------------------
#  RETE + CACHE: identiche per costruzione a dukascopy_m1.py (stessa
#  cartella raw/, stessi .assente): quello che l'M1 ha gia' scaricato
#  il tick NON lo riscarica, e viceversa.
#
#  DUE MOTORI, UNA SOLA LOGICA (v2, 31/08): la richiesta GREZZA ha due
#  implementazioni (urllib storico, curl misurato-passante); il giro di
#  retry/backoff/log sta in UN punto solo (scarica_url) ed e' identico
#  per costruzione. Ogni richiesta grezza torna (classe, dati, msg):
#    OK      -> byte validi
#    ASSENTE -> 404 vero (si memorizza .assente)
#    RIPROVA -> errore di rete / 429 / 5xx: si ritenta con backoff
#    FERMO   -> errore HTTP non ritentabile: si molla subito
# ---------------------------------------------------------------------
MOTORE = {"nome": "urllib", "tmpdir": ""}   # impostato da imposta_motore()


def imposta_motore(nome, tmpdir):
    MOTORE["nome"] = nome
    MOTORE["tmpdir"] = tmpdir


def binario_curl():
    return "curl.exe" if os.name == "nt" else "curl"


def _richiesta_urllib(url):
    try:
        req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
        with urllib.request.urlopen(req, timeout=30) as r:
            dati = r.read()
        return ("OK", dati, "")
    except urllib.error.HTTPError as e:
        if e.code == 404:
            return ("ASSENTE", b"", "")
        msg = "ERRORE %d" % e.code
        if e.code == 429 or 500 <= e.code <= 504:
            return ("RIPROVA", b"", msg)
        return ("FERMO", b"", msg)
    except Exception as e:
        return ("RIPROVA", b"", "ERRORE rete: %s" % e)


def _richiesta_curl(url):
    # Il tempfile sta in una dir DENTRO la cartella di lavoro (mai il /tmp
    # di sistema) e viene SEMPRE rimosso (finally).
    dtmp = MOTORE["tmpdir"] or os.getcwd()
    os.makedirs(dtmp, exist_ok=True)
    fd, tmp = tempfile.mkstemp(prefix="curl_", suffix=".bin", dir=dtmp)
    os.close(fd)
    try:
        cmd = [binario_curl(), "-s", "-o", tmp, "-w", "%{http_code}",
               "--max-time", "30", url]
        # lista di argomenti, MAI shell=True
        proc = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        if proc.returncode != 0:
            # errore di connessione/timeout di curl -> stessa via dei
            # retry di rete di urllib
            return ("RIPROVA", b"", "ERRORE curl exit %d" % proc.returncode)
        codice = proc.stdout.decode("ascii", "replace").strip()
        if codice == "200":
            with open(tmp, "rb") as fh:
                return ("OK", fh.read(), "")
        if codice == "404":
            return ("ASSENTE", b"", "")
        # 5xx e ogni altro codice: si ritenta come un 503
        return ("RIPROVA", b"", "ERRORE %s" % codice)
    finally:
        try:
            os.remove(tmp)
        except OSError:
            pass


def scarica_url(url, pausa_ms):
    ultimo = "ERRORE sconosciuto"
    richiesta = _richiesta_curl if MOTORE["nome"] == "curl" else _richiesta_urllib
    for tentativo in range(len(ATTESE_RETRY) + 1):
        if pausa_ms > 0:
            time.sleep(pausa_ms / 1000.0)
        classe, dati, msg = richiesta(url)
        if classe == "OK":
            return ("OK", dati)
        if classe == "ASSENTE":
            return ("ASSENTE", b"")
        ultimo = msg
        if classe == "FERMO":
            return (ultimo, b"")
        if tentativo < len(ATTESE_RETRY):
            att = ATTESE_RETRY[tentativo]
            log("      (il server dice '%s', riprovo fra %d s)" % (ultimo, att))
            time.sleep(att)
    return (ultimo, b"")


def url_ora(sym, dt_utc):
    # MESE ZERO-BASED: gennaio = 00 (verificato dalla sonda del 15/08)
    return "%s/%s/%04d/%02d/%02d/%02dh_ticks.bi5" % (
        BASE, sym, dt_utc.year, dt_utc.month - 1, dt_utc.day, dt_utc.hour)


def decodifica_bi5(dati):
    """Torna lista di tuple (ms, p1, p2, v1, v2). Vuoto se niente dati."""
    if not dati:
        return []
    grezzo = lzma.decompress(dati)
    if len(grezzo) % RECORD.size != 0:
        raise ValueError("lunghezza %d non multipla di %d: formato inatteso"
                         % (len(grezzo), RECORD.size))
    return list(RECORD.iter_unpack(grezzo))


def decodificabile(dati):
    if not dati:
        return True
    try:
        decodifica_bi5(dati)
        return True
    except Exception:
        return False


def scarica_ora_con_cache(sym, dt_utc, cartella_raw, pausa_ms, contatori, solo_cache):
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
        log("      cache illeggibile (%d byte): la butto%s -> %s"
            % (len(dati), "" if solo_cache else " e riscarico", f_ok))
        os.remove(f_ok)
    if os.path.exists(f_no):
        contatori["cache"] += 1
        return b""
    if solo_cache:
        contatori["buchi_cache"] += 1
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
#  MISURE (ordine campi, divisore): stesse regole del fratello M1.
# ---------------------------------------------------------------------
def misura_ordine_campi(ticks):
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
    ordinati = sorted(prezzi_interi)
    med = ordinati[len(ordinati) // 2]
    buoni = []
    for k in range(0, 6):
        div = 10 ** k
        if banda_min <= med / div <= banda_max:
            buoni.append((div, med / div))
    if len(buoni) == 1:
        return (buoni[0][0], buoni[0][1])
    return (None, buoni)


def banda_sospetta(banda_min, banda_max):
    if banda_max >= 10 * banda_min:
        return ("rapporto %.1f >= 10: uno sfondamento del tetto NON si ferma, "
                "rientra in banda una decade sotto" % (banda_max / banda_min))
    return ""


# ---------------------------------------------------------------------
#  SCRITTURA CSV TICK, un file per MESE (in ora d'uscita), ATOMICA.
#  Formato congelato (lo legge ABTG_ImportaTickEsterno.mq5):
#      Time,Msec,Bid,Ask
#      2022.03.14 15:30:07,842,32941.5,32944.0
#  Msec separato apposta: il parser MQL5 usa StringToTime sul campo 1
#  e somma i millisecondi, senza substring fragili.
# ---------------------------------------------------------------------
def scrivi_atomico(percorso, testo):
    tmp = percorso + ".tmp"
    with open(tmp, "w", newline="") as f:
        f.write(testo)
        f.flush()
        os.fsync(f.fileno())
    os.replace(tmp, percorso)


class ScrittoreMensile:
    def __init__(self, cartella_out, bcm, fmt_prezzo):
        self.cartella = cartella_out
        self.bcm = bcm
        self.fmt = fmt_prezzo
        self.chiave = None          # (anno, mese) del buffer corrente
        self.righe = []
        self.file_scritti = []
        self.n_tick = 0

    def _flush(self):
        if self.chiave is None or not self.righe:
            self.chiave = None
            self.righe = []
            return
        nome = "%s_ticks_%04d-%02d.csv" % (self.bcm, self.chiave[0], self.chiave[1])
        percorso = os.path.join(self.cartella, nome)
        buf = io.StringIO()
        buf.write("Time,Msec,Bid,Ask\n")
        for r in self.righe:
            buf.write(r)
        scrivi_atomico(percorso, buf.getvalue())
        self.file_scritti.append(percorso)
        log("   scritto %s (%d tick)" % (nome, len(self.righe)))
        self.chiave = None
        self.righe = []

    def aggiungi(self, dt, ms, bid, ask):
        chiave = (dt.year, dt.month)
        if self.chiave is not None and chiave != self.chiave:
            self._flush()
        if self.chiave is None:
            self.chiave = chiave
        self.righe.append("%s,%03d,%s,%s\n" % (
            dt.strftime("%Y.%m.%d %H:%M:%S"), ms, self.fmt % bid, self.fmt % ask))
        self.n_tick += 1

    def chiudi(self):
        self._flush()


# ---------------------------------------------------------------------
#  STATISTICHE DI SANITA' per il referto (e per il tester: la mediana
#  dello SPREAD serve a dichiarare lo spread nel tester -- lezione R55).
# ---------------------------------------------------------------------
class Statistiche:
    def __init__(self):
        self.per_anno = {}
        self.prezzo_min = None
        self.prezzo_max = None
        self.spread_campione = []      # 1 tick ogni 100, tetto 2M
        self.invertiti = 0             # ask < bid dopo la decodifica
        self.contati = 0

    def tick(self, dt, bid, ask):
        self.contati += 1
        self.per_anno[dt.year] = self.per_anno.get(dt.year, 0) + 1
        if self.prezzo_min is None or bid < self.prezzo_min:
            self.prezzo_min = bid
        if self.prezzo_max is None or ask > self.prezzo_max:
            self.prezzo_max = ask
        if ask < bid:
            self.invertiti += 1
        if self.contati % 100 == 0 and len(self.spread_campione) < 2000000:
            self.spread_campione.append(ask - bid)

    def righe(self, bcm):
        out = []
        if self.contati == 0:
            out.append("%s: NESSUN TICK." % bcm)
            return out
        out.append("%s: %d tick totali" % (bcm, self.contati))
        out.append("  prezzo minimo %.2f  massimo %.2f" % (self.prezzo_min, self.prezzo_max))
        for anno in sorted(self.per_anno):
            out.append("  %d: %d tick" % (anno, self.per_anno[anno]))
        if self.spread_campione:
            ordinato = sorted(self.spread_campione)
            med = ordinato[len(ordinato) // 2]
            p90 = ordinato[int(len(ordinato) * 0.9)]
            out.append("  spread (campione 1/100): mediana %.2f  p90 %.2f  <-- da confrontare con lo spread del tester (R55)"
                       % (med, p90))
        if self.invertiti > 0:
            out.append("  ATTENZIONE: %d tick con ask < bid (%.4f%%)"
                       % (self.invertiti, 100.0 * self.invertiti / self.contati))
        return out


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


def raccogli_desktop(file_da_copiare, nome_zip):
    # NB: qui si raccolgono REFERTO e ultimo CSV di controllo, NON tutti i
    # CSV tick (possono essere gigabyte: quelli restano nella cartella di
    # lavoro e vanno in MQL5\Files a mano o con la riga dedicata).
    desktop = trova_desktop()
    base = desktop if desktop else os.getcwd()
    if not desktop:
        log("ATTENZIONE: nessun Desktop trovato, raccolgo nella cartella corrente.")
    dest = os.path.join(base, "dukascopy_tick")
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
#  AUTOTEST: senza rete. Non dimostra il formato Dukascopy (quello lo
#  misura la corsa vera): dimostra che QUESTO codice non si morde la coda.
# ---------------------------------------------------------------------
def autotest():
    log("=== AUTOTEST dukascopy_tick (%s, sintetico, senza rete esterna) ===" % VERSIONE)
    # 1. round-trip: 3 tick noti -> lzma -> decodifica -> confronto
    tick_noti = [
        (1000, 3294400, 3294150, 1.5, 2.5),      # ms, ask, bid, volA, volB
        (59999, 3294500, 3294300, 0.1, 0.2),
        (3599999, 3295000, 3294900, 3.0, 1.0),
    ]
    grezzo = b"".join(RECORD.pack(*t) for t in tick_noti)
    compresso = lzma.compress(grezzo, format=lzma.FORMAT_ALONE)
    letti = decodifica_bi5(compresso)
    assert len(letti) == 3, "round-trip: numero tick sbagliato"
    for a, b in zip(tick_noti, letti):
        assert a[0] == b[0] and a[1] == b[1] and a[2] == b[2], "round-trip: campi"
    log("1. round-trip pack->lzma->decodifica: OK (3 tick identici)")

    # 2. ordine campi
    ordine, quota = misura_ordine_campi(letti)
    assert ordine == "p1_ask" and quota == 1.0, "ordine campi"
    log("2. misura ordine campi: OK (p1_ask, 100%)")

    # 3. divisore: mediana 3294500, banda Dow 8000-70000 -> 100 unico
    div, med = misura_divisore([t[1] for t in tick_noti], *STRUMENTI["USA30IDXUSD"][1:])
    assert div == 100 and abs(med - 32945.0) < 0.01, "divisore Dow"
    # sopra il tetto ci si ferma PULITO (regola della banda, 20/08)
    div_o, cand_o = misura_divisore([7500000], *STRUMENTI["USA30IDXUSD"][1:])
    assert div_o is None and cand_o == [], "sfondamento tetto Dow: deve fermarsi"
    log("3. misura divisore + banda che si ferma pulita: OK")

    # 4. DST USA 2025: confini al minuto (9 marzo / 2 novembre)
    assert not dst_usa_attivo(datetime(2025, 3, 9, 6, 59, tzinfo=timezone.utc))
    assert dst_usa_attivo(datetime(2025, 3, 9, 7, 0, tzinfo=timezone.utc))
    assert dst_usa_attivo(datetime(2025, 11, 2, 5, 59, tzinfo=timezone.utc))
    assert not dst_usa_attivo(datetime(2025, 11, 2, 6, 0, tzinfo=timezone.utc))
    log("4. DST USA (confini 2025 al minuto): OK")

    # 5. DST EU 2025: confini al minuto (30 marzo / 26 ottobre, 01:00 UTC)
    assert not dst_eu_attivo(datetime(2025, 3, 30, 0, 59, tzinfo=timezone.utc))
    assert dst_eu_attivo(datetime(2025, 3, 30, 1, 0, tzinfo=timezone.utc))
    assert dst_eu_attivo(datetime(2025, 10, 26, 0, 59, tzinfo=timezone.utc))
    assert not dst_eu_attivo(datetime(2025, 10, 26, 1, 0, tzinfo=timezone.utc))
    log("5. DST EU (confini 2025 al minuto): OK")

    # 6. le settimane SFASATE: dentro (9-30/03/2025) i due calendari
    #    danno ore server DIVERSE; in estate piena identiche.
    t_sfasato = datetime(2025, 3, 15, 12, 0, tzinfo=timezone.utc)
    assert converti_fuso(t_sfasato, "server", "usa").hour == 13
    assert converti_fuso(t_sfasato, "server", "europa").hour == 12
    t_estate = datetime(2025, 7, 15, 12, 0, tzinfo=timezone.utc)
    assert converti_fuso(t_estate, "server", "usa") == converti_fuso(t_estate, "server", "europa")
    assert converti_fuso(t_estate, "server", "usa").hour == 13   # ora italiana 14 - 1
    t_inverno = datetime(2025, 1, 15, 12, 0, tzinfo=timezone.utc)
    assert converti_fuso(t_inverno, "server", "usa").hour == 12  # ora italiana 13 - 1
    log("6. settimane sfasate USA/EU + regola 'ora italiana - 1': OK")

    # 7. scrittore mensile: cambio mese a cavallo della conversione
    import tempfile
    with tempfile.TemporaryDirectory() as td:
        w = ScrittoreMensile(td, "U30USD", "%.1f")
        # 31/03 23:30 UTC +1h server (DST) -> 01/04 00:30 server: mese NUOVO
        t1 = datetime(2025, 3, 31, 22, 30, tzinfo=timezone.utc)
        t2 = datetime(2025, 3, 31, 23, 30, tzinfo=timezone.utc)
        d1 = converti_fuso(t1, "server", "usa")
        d2 = converti_fuso(t2, "server", "usa")
        assert d1.month == 3 and d2.month == 4, "conversione a cavallo di mese"
        w.aggiungi(d1, 5, 32941.5, 32944.0)
        w.aggiungi(d2, 42, 32950.0, 32952.5)
        w.chiudi()
        assert len(w.file_scritti) == 2, "attesi 2 file mensili"
        with open(w.file_scritti[0]) as f:
            righe = f.read().splitlines()
        assert righe[0] == "Time,Msec,Bid,Ask", "intestazione"
        assert righe[1] == "2025.03.31 23:30:00,005,32941.5,32944.0", "riga dati: " + righe[1]
    log("7. scrittore mensile (split sul mese SERVER, riga CSV congelata): OK")

    # 8. audit bande: tutte con rapporto < 10 e dichiarate
    sospette = []
    for nome in sorted(STRUMENTI):
        bcm, lo, hi = STRUMENTI[nome]
        motivo = banda_sospetta(lo, hi)
        if motivo:
            sospette.append("   ATTENZIONE %s (%s) banda %g-%g: %s" % (nome, bcm, lo, hi, motivo))
    assert not sospette, "bande sospette:\n" + "\n".join(sospette)
    log("8. audit bande (rapporto < 10 su tutte): OK")

    # 9. statistiche: spread mediano e ask<bid contati
    st = Statistiche()
    st.tick(datetime(2022, 3, 14, 15, 30), 32941.5, 32944.0)
    st.tick(datetime(2022, 3, 14, 15, 30), 32944.0, 32941.5)   # invertito
    assert st.invertiti == 1, "conteggio ask<bid"
    log("9. statistiche di sanita' (ask<bid contati): OK")

    # 10. MOTORE CURL contro un server HTTP LOCALE (127.0.0.1, porta
    #     effimera, avviato QUI dentro): 200 con byte noti, 404, e
    #     503-poi-200 (il retry condiviso). Niente rete esterna.
    #     Se curl non c'e' nell'ambiente dell'autotest: SALTATO, non rosso.
    if shutil.which(binario_curl()) is None:
        log("10. motore curl: SALTATO (binario '%s' non presente in questo ambiente)"
            % binario_curl())
    else:
        import http.server
        import threading
        contenuto = b"BYTES-NOTI-DUKA-TICK-v2"

        class _Handler(http.server.BaseHTTPRequestHandler):
            colpi_flaky = 0

            def _manda(self, codice, corpo):
                self.send_response(codice)
                self.send_header("Content-Length", str(len(corpo)))
                self.end_headers()
                if corpo:
                    self.wfile.write(corpo)

            def do_GET(self):
                if self.path == "/ok":
                    self._manda(200, contenuto)
                elif self.path == "/flaky":
                    type(self).colpi_flaky += 1
                    if type(self).colpi_flaky == 1:
                        self._manda(503, b"")
                    else:
                        self._manda(200, contenuto)
                else:
                    self._manda(404, b"")

            def log_message(self, *a):   # zitto: il referto e' il nostro log
                pass

        srv = http.server.ThreadingHTTPServer(("127.0.0.1", 0), _Handler)
        porta = srv.server_address[1]
        threading.Thread(target=srv.serve_forever, daemon=True).start()
        motore_prima = dict(MOTORE)
        attese_prima = ATTESE_RETRY[:]
        try:
            with tempfile.TemporaryDirectory() as td:
                imposta_motore("curl", td)
                # attese azzerate SOLO qui: la LOGICA di retry e' la stessa
                # per costruzione, cambia il tempo (il test non dorme 2 s)
                ATTESE_RETRY[:] = [0] * len(ATTESE_RETRY)
                base = "http://127.0.0.1:%d" % porta
                esito, dati = scarica_url(base + "/ok", 0)
                assert esito == "OK" and dati == contenuto, "curl 200: %s" % esito
                esito, dati = scarica_url(base + "/manca", 0)
                assert esito == "ASSENTE" and dati == b"", "curl 404: %s" % esito
                esito, dati = scarica_url(base + "/flaky", 0)
                assert esito == "OK" and dati == contenuto, "curl 503-poi-200: %s" % esito
                assert _Handler.colpi_flaky == 2, \
                    "attese 2 richieste su /flaky, viste %d" % _Handler.colpi_flaky
                resti = os.listdir(td)
                assert resti == [], "tempfile curl non rimossi: %s" % resti
            log("10. motore curl (server locale: 200 byte noti, 404 -> ASSENTE, "
                "503-poi-200 col retry, tempfile puliti): OK")
        finally:
            MOTORE.update(motore_prima)
            ATTESE_RETRY[:] = attese_prima
            srv.shutdown()
            srv.server_close()

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
    ap.add_argument("--simboli", default="")
    ap.add_argument("--da", default="")
    ap.add_argument("--a", default="")
    ap.add_argument("--dst", choices=["usa", "europa"], default="usa")
    ap.add_argument("--fuso", choices=["server", "utc"], default="server")
    ap.add_argument("--motore", choices=["urllib", "curl"], default="urllib")
    ap.add_argument("--pausa-ms", type=int, default=250)
    ap.add_argument("--divisore", type=int, default=0)
    ap.add_argument("--solo-cache", action="store_true")
    ap.add_argument("--cartella", default="")
    ap.add_argument("--salta-controllo", action="store_true")
    args = ap.parse_args(argv)

    if args.autotest:
        return autotest()

    # PASSO 0: la finestra e' DICHIARATA, mai implicita (il muro del
    # ritmo misurato il 18/08 vieta i "tutto dal 2012" per sbaglio).
    if not args.simboli or not args.da or not args.a:
        log("ERRORE: in corsa servono --simboli, --da e --a (finestra DICHIARATA).")
        log("Esempio: --simboli USA30IDXUSD --da 2019-09-01 --a 2024-09-26")
        return 2

    lavoro = args.cartella or os.path.join(os.path.expanduser("~"), "dukascopy_lavoro")
    raw = os.path.join(lavoro, "raw")      # STESSA cache di dukascopy_m1.py
    out = os.path.join(lavoro, "tick")
    os.makedirs(raw, exist_ok=True)
    os.makedirs(out, exist_ok=True)

    # --- il MOTORE DI RETE, verificato PRIMA di toccare il server ------
    versione_curl = ""
    if args.motore == "curl":
        percorso_curl = shutil.which(binario_curl())
        if not percorso_curl:
            log("ERRORE: --motore curl ma il binario '%s' NON e' nel PATH." % binario_curl())
            log("        Senza curl questo motore non esiste: installa curl")
            log("        (su Windows 10 1803+ e' gia' in C:\\Windows\\System32)")
            log("        oppure usa --motore urllib. MI FERMO.")
            return 2
        try:
            vv = subprocess.run([binario_curl(), "--version"],
                                stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            versione_curl = vv.stdout.decode("ascii", "replace").splitlines()[0].strip()
        except Exception as e:
            log("ERRORE: '%s --version' non parte (%s). MI FERMO." % (binario_curl(), e))
            return 2
    imposta_motore(args.motore, os.path.join(lavoro, "tmp_curl"))

    log("=== DUKASCOPY -> TICK CSV (%s) ===" % VERSIONE)
    log("cartella di lavoro: " + lavoro)
    if args.motore == "curl":
        log("motore di rete    : curl [%s]" % versione_curl)
        log("                    (l'impronta TLS di python-urllib e' strozzata dal")
        log("                     server: WinError 10060/10054 + 503, misurato 31/08)")
    else:
        log("motore di rete    : urllib (storico; se il server strozza, --motore curl)")
    if args.fuso == "utc":
        log("fuso in uscita    : UTC (solo per confronti: l'import usa 'server')")
    else:
        log("fuso in uscita    : ORA SERVER BCM, calendario DST '%s'" % args.dst)
        log("                    (usa = ipotesi meglio supportata; la SONDA decide,")
        log("                     criterio congelato in DUKASCOPY_PASSO0.md)")
    if args.solo_cache:
        log("modo              : SOLO CACHE (zero rete, riconversione)")

    # --- fase 0: controllo positivo --------------------------------
    if not args.salta_controllo and not args.solo_cache:
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
            log("   RISPOSTA DI %d BYTE NON DECODIFICABILE (%s). MI FERMO." % (len(dati), e))
            return 1
        ordine, quota = misura_ordine_campi(ticks)
        div, med = misura_divisore([t[1] for t in ticks], 0.8, 1.8)
        log("   OK: %d byte, %d tick. Ordine campi: %s (%.1f%%). EURUSD mediana %s con divisore %s."
            % (len(dati), len(ticks), ordine, quota * 100,
               ("%.5f" % med) if div else "?", div))
        if ordine is None or div is None:
            log("   IL CONTROLLO NON TORNA: formato diverso dall'atteso. MI FERMO.")
            return 1

    simboli = [s.strip() for s in args.simboli.split(",") if s.strip()]
    da = datetime.strptime(args.da, "%Y-%m-%d").replace(tzinfo=timezone.utc)
    a = datetime.strptime(args.a, "%Y-%m-%d").replace(tzinfo=timezone.utc)

    righe_referto = []
    file_referto = []
    falliti = []
    incompleti = []
    for sym in simboli:
        if sym not in STRUMENTI:
            log("SALTO %s: strumento non in tabella (aggiungi banda plausibile)." % sym)
            falliti.append(sym)
            continue
        bcm, banda_min, banda_max = STRUMENTI[sym]
        log("")
        log("--- %s -> %s_DK (finestra %s -> %s) ---" % (sym, bcm, args.da, args.a))
        contatori = {"scaricate": 0, "assenti": 0, "errori": 0, "cache": 0,
                     "buchi_cache": 0, "byte": 0, "ultimo_errore": "", "consecutivi": 0}
        stat = Statistiche()
        scrittore = None
        ordine_deciso = None
        divisore_deciso = args.divisore if args.divisore > 0 else None
        t0 = time.time()
        n_giorni = sum(1 for _ in giorni(da, a))
        fatti = 0
        stop_totale = False
        for giorno in giorni(da, a):
            ticks_del_giorno = []
            for h in range(24):
                ora = giorno.replace(hour=h)
                dati = scarica_ora_con_cache(sym, ora, raw, args.pausa_ms,
                                             contatori, args.solo_cache)
                if contatori["consecutivi"] >= MAX_ERR_CONSEC:
                    log("STOP: %d errori DI FILA. Ultimo: %s"
                        % (contatori["consecutivi"], contatori["ultimo_errore"]))
                    log("     Il 15/08 Dukascopy ha risposto 503 a TUTTO: e' un ban")
                    log("     temporaneo. Aspetta e rilancia la STESSA riga: la cache")
                    log("     riparte da dove era e i mesi gia' scritti restano.")
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
                    campione = [t[1] for t in tutti]
                    divisore_deciso, med = misura_divisore(campione, banda_min, banda_max)
                    if divisore_deciso is None:
                        if not med:
                            perche = ("NESSUN 10^k mette la mediana (%d) nella banda %g-%g: "
                                      "formato diverso O banda stantia O finestra pre-2019 "
                                      "(bande tarate sulle missioni dichiarate)"
                                      % (sorted(campione)[len(campione) // 2],
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
                decimali = {1: 0, 10: 1, 100: 2, 1000: 3, 10000: 4}.get(divisore_deciso, 5)
                # i prezzi indice hanno 1-2 decimali veri: col divisore 100
                # si scrive %.2f, con 1000 %.3f -- il formato segue la misura
                scrittore = ScrittoreMensile(out, bcm + "_DK", "%%.%df" % decimali)
            idx_ask = 1 if ordine_deciso == "p1_ask" else 2
            idx_bid = 2 if ordine_deciso == "p1_ask" else 1
            for ora, ticks in ticks_del_giorno:
                for t in ticks:
                    dt_utc = ora + timedelta(milliseconds=t[0])
                    dt = converti_fuso(dt_utc, args.fuso, args.dst)
                    bid = t[idx_bid] / divisore_deciso
                    ask = t[idx_ask] / divisore_deciso
                    stat.tick(dt, bid, ask)
                    scrittore.aggiungi(dt, dt_utc.microsecond // 1000, bid, ask)
            fatti += 1
            if fatti % 25 == 0 or fatti == n_giorni:
                trascorso = time.time() - t0
                proiezione = (trascorso / fatti) * (n_giorni - fatti) / 3600.0
                log("   %d/%d giorni  (%d scaricate, %d cache, %d assenti, %d errori; %.1f MB; %.0f s; RESTANO ~%.1f ORE)"
                    % (fatti, n_giorni, contatori["scaricate"], contatori["cache"],
                       contatori["assenti"], contatori["errori"],
                       contatori["byte"] / 1e6, trascorso, proiezione))
        if scrittore is not None:
            scrittore.chiudi()
        righe = stat.righe(bcm + "_DK")
        righe.append("  divisore usato %s, ordine campi %s  <-- CONTROLLA L'ORDINE DI GRANDEZZA"
                     % (divisore_deciso, ordine_deciso))
        righe.append("  fuso: %s%s" % (args.fuso,
                     "" if args.fuso == "utc" else " (calendario DST %s)" % args.dst))
        righe.append("  scaricate %d ore (%.1f MB .bi5), %d cache, %d assenti (404), %d errori, %d buchi cache"
                     % (contatori["scaricate"], contatori["byte"] / 1e6,
                        contatori["cache"], contatori["assenti"], contatori["errori"],
                        contatori["buchi_cache"]))
        if scrittore is not None:
            righe.append("  file mensili scritti: %d (in %s)" % (len(scrittore.file_scritti), out))
        if contatori["ultimo_errore"]:
            righe.append("  ULTIMO ERRORE: " + contatori["ultimo_errore"])
            righe.append("  (con errori > 0 la copertura NON e' garantita: rilancia,")
            righe.append("   la cache evita di riscaricare quello che c'e' gia')")
        if stat.contati == 0 and sym not in falliti:
            falliti.append(sym)
        if (contatori["errori"] > 0 or contatori["buchi_cache"] > 0) \
                and sym not in falliti and sym not in incompleti:
            incompleti.append(sym)
        for r in righe:
            log(r)
        righe_referto.extend(righe + [""])

    # --- referto + raccolta Desktop --------------------------------
    esito = ("FALLITO: " + ", ".join(falliti)) if falliti else (
            ("COMPLETO MA CON BUCHI (rilancia): " + ", ".join(incompleti)) if incompleti else "OK")
    ref_path = os.path.join(out, "referto_dukascopy_tick.txt")
    testa = io.StringIO()
    testa.write("=== DUKASCOPY -> TICK CSV: referto ===\n")
    testa.write("versione: %s\n" % VERSIONE)
    testa.write("comando : %s\n" % " ".join(argv))
    testa.write("motore  : %s%s\n" % (args.motore,
                (" [" + versione_curl + "]") if versione_curl else ""))
    testa.write("ESITO   : %s\n" % esito)
    testa.write("data: %s (ora del PC)  =  %s UTC\n" % (
        datetime.now().strftime("%Y-%m-%d %H:%M"),
        datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M")))
    testa.write("fuso timestamp: %s%s\n\n" % (args.fuso,
                "" if args.fuso == "utc" else " (calendario DST %s -- la sonda decide, criterio congelato)" % args.dst))
    testa.write("\n".join(righe_referto))
    scrivi_atomico(ref_path, testa.getvalue())
    file_referto.append(ref_path)
    raccogli_desktop(file_referto, "dukascopy_tick.zip")
    log("")
    log("ESITO: " + esito)
    if falliti:
        return 1
    if incompleti:
        log("Rilancia la STESSA riga: la cache non riscarica quello che c'e' gia'.")
        return 3
    log("PROSSIMO PASSO (PASSO 0, procedura in DUKASCOPY_PASSO0.md): i CSV mensili")
    log("vanno in MQL5\\Files del terminale BCM di backtest, poi lo Script")
    log("ABTG_ImportaTickEsterno (bozza nel repo) con la SONDA di sovrapposizione")
    log("PRIMA di qualunque uso nei round.")
    return 0


if __name__ == "__main__":
    try:
        sys.exit(corri(sys.argv[1:]))
    except KeyboardInterrupt:
        log("")
        log("INTERROTTA A MANO. Cache valida (scritture atomiche) e MESI GIA'")
        log("SCRITTI validi: rilancia la STESSA riga, il mese in corso si rifa'")
        log("dalla cache senza riscaricare.")
        sys.exit(130)
