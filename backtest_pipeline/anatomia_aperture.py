# =====================================================================
#  MARCATORE_ANATOMIA_APERTURE_v1
#  anatomia_aperture.py  --  STUDIO ANATOMIA APERTURE, 16 ANNI DI NASDAQ
#                            (FASE 1: descrittiva. 26/08/2026)
# ---------------------------------------------------------------------
#  PERCHE' ESISTE (richiesta di Claudio, 26/08/2026)
#    "creare agenti che da 0 analizzano gli ultimi 10 anni di trade su
#     apertura del Nasdaq, Dax, Dow e in base al numero maggiore di
#     setup creino il motore giusto".
#    La casa lo esegue nel verso ANTI-OVERFITTING, in DUE FASI:
#      FASE 1 (questo strumento) = ANATOMIA DESCRITTIVA. Si MISURA cosa
#              fa il mercato all'apertura. Nessun motore, nessun PF,
#              nessuna equity, nessuna promozione.
#      FASE 2 (round futuri) = le IPOTESI si scrivono SOLO su 2010-2020
#              e si validano su 2021-2026 + tick BCM.
#    L'ordine non e' un dettaglio: se le ipotesi nascono guardando anche
#    il 2021-2026, quella finestra non e' piu' una validazione, e' un
#    secondo campione d'addestramento travestito.
#
#  ###################################################################
#  #  QUELLO CHE QUESTO STRUMENTO **NON** FA:                        #
#  #  NON costruisce motori. NON calcola un PROFIT FACTOR. NON       #
#  #  calcola un'EQUITY. NON promuove niente e non firma niente.     #
#  #  NON tocca MT5, non apre nessun terminale, non scrive un byte   #
#  #  dentro MetaQuotes\Terminal. Legge un CSV e conta.              #
#  #  Un numero di questo strumento NON e' mai un risultato di       #
#  #  strategia: e' una DESCRIZIONE del mercato.                     #
#  ###################################################################
#
#  ##  IL CANCELLO QUALITA' DEL FEED E' IN VERIFICA (dichiarato)  ####
#  #  Le MISURE LAMPO del cancello _EXT (RIGA_MISURE_LAMPO.ps1,      #
#  #  26/08) stanno decidendo se il feed HistData e' sano: tre        #
#  #  eventi anomali sotto esame, e il cancello ZERO e' ancora       #
#  #  CHIUSO (diff media H1 0,061-0,101% contro <=0,05% richiesto).  #
#  #  Questo studio GIRA LO STESSO -- e' descrittivo e non autorizza #
#  #  niente -- ma L'INTERPRETAZIONE DEI SUOI NUMERI DIPENDE         #
#  #  DALL'ESITO DI QUELLE MISURE, e ogni referto lo ripete in testa.#
#  #  Contromisura interna: i giorni con COPERTURA ORARIA ANOMALA    #
#  #  sono ESCLUSI dai conteggi e contati a parte (GIORNI SOSPETTI), #
#  #  cosi' lo studio misura da solo quanto pesa la malattia.        #
#  ###################################################################
#
#  IL FUSO -- letto dal file, e MISURATO da questo strumento
#    Il CSV e' quello prodotto da histdata_m1.py --converti ("Formato
#    1": Time,Open,High,Low,Close,Volume con Time "AAAA.MM.GG HH:MM").
#    I suoi timestamp sono ORA LOCALE DI NEW YORK: non e' un'assunzione,
#    e' la misura di casa (histdata_m1.py righe 81-103, REFERTO_IMPORT_
#    6_SIMBOLI.md -- 8 import su 8 hanno calibrato uno shift FISSO +5
#    contro il nativo BCM, e uno shift fisso su 7 anni e' possibile solo
#    se il feed segue il DST americano come il server).
#      apertura cash Nasdaq = 09:30 NEW YORK
#                           = 14:30 ora server BCM   (server = NY+5,
#                             oppure NY+4 nelle settimane in cui i due
#                             calendari DST sono sfasati: marzo e
#                             ottobre/novembre)
#                           = 15:30 ora italiana
#    ==> QUI NON SI CONVERTE NIENTE: l'ora si legge COME E' SCRITTA NEL
#        FILE e --ora-apertura vale 09:30, che E' l'apertura cash.
#        Chi passasse 14:30 misurerebbe il primo pomeriggio di New York.
#    E per non fidarsi nemmeno di questo, lo strumento MISURA la
#    convenzione da solo: il CANARINO DEL FUSO guarda mese per mese
#    l'ora d'inizio della pausa giornaliera del feed (la manutenzione
#    17:00-18:00 NY) e l'ora dell'ultima barra del giorno. Se GENNAIO e
#    LUGLIO danno la stessa ora -> il feed segue il DST -> 09:30 e'
#    l'apertura tutto l'anno. Se LUGLIO scivola di un'ora -> EST FISSO
#    -> meta' anno sarebbe misurato un'ora fuori: lo strumento lo
#    DICHIARA e alza il codice d'uscita, non tira dritto.
#
#  LA MEMORIA: SI LEGGE IN STREAMING, ED E' UNA SCELTA DICHIARATA
#    Il CSV NASUSD_M1.csv ha 5.233.590 barre M1 (referto storico indici
#    del 25/08). Il metro di casa e' 690 byte di RAM per barra M1
#    MISURATI sul parser di histdata_m1.py (checklist 74): tenerle tutte
#    in un dizionario costerebbe ~3,6 GB, e il MemoryError arriverebbe
#    IN FONDO, dopo la parte lunga.
#    Qui NON si tiene niente in memoria: si legge riga per riga, si
#    tengono solo gli aggregati DEL GIORNO IN CORSO (al massimo ~420
#    barre) e si emette una riga per giornata. La RAM non dipende dalla
#    lunghezza del file. Misurata su un file sintetico da 5,2 M righe:
#    vedi la riga "RAM di picco" che lo strumento stampa da solo a fine
#    corsa (e che finisce nel referto).
#
#  I MODI
#    --autotest    giornate SINTETICHE costruite a mano, coi conteggi
#                  attesi scritti nel codice. Nessun file vero, niente
#                  rete. E' il controllo positivo dello strumento.
#    (default)     scandisce il CSV e scrive CSV per-giorno + 3 referti
#
#  I TRE REFERTI, e perche' sono TRE
#    ANATOMIA_APERTURE_IS_<da>_<a>.txt          <- QUI si scrivono le ipotesi
#    ANATOMIA_APERTURE_CASSAFORTE_<da>_<a>.txt  <- la cassaforte: NON si guarda
#                                                  per costruire ipotesi
#    ANATOMIA_APERTURE_COMPLETO.txt             <- contesto, tutti gli anni
#    La regola delle DUE FASI e' scritta in testa a tutti e tre. I file
#    sono separati apposta: una regola che vive solo nella prosa e' una
#    regola che qualcuno leggera' di fretta.
#
#  CODICI D'USCITA (li legge la riga di lancio)
#    0 = misurato, nessun rilievo
#    1 = MISURATO CON RILIEVI (canarino del fuso incerto, troppi giorni
#        sospetti, righe fuori ordine, date ripetute...). Gli artefatti
#        CI SONO e vanno mandati lo stesso: un rilievo E' una risposta.
#    2 = NON PARTITO (file assente, file in un ALTRO formato, zero barre,
#        parametri incoerenti): non c'e' niente da leggere.
#
#  NOTA DI CULTURA NUMERICA: qui si parsa e si formatta SEMPRE col PUNTO
#  decimale (float() di Python e "%.*f" sono gia' invarianti: non si usa
#  locale, non si usa il modulo locale, mai). Il CSV prodotto ha il
#  punto decimale e la virgola come separatore di campo, e NESSUN campo
#  di testo contiene una virgola (checklist 75).
# =====================================================================

import argparse
import os
import sys
from datetime import date, timedelta

VERSIONE = "ANATOMIA_APERTURE_v1"

# ---------------------------------------------------------------------
#  I DEFAULT DELLE SOGLIE. Sono INPUT, non numeri magici: ognuno ha il
#  suo motivo scritto qui accanto e ripetuto nel referto.
# ---------------------------------------------------------------------
DEF_ORA_APERTURA   = "09:30"   # apertura CASH del Nasdaq, ora di New York = ora del file
DEF_ORA_CHIUSURA   = "16:00"   # chiusura cash, serve solo per il GAP
DEF_MINUTI_PRE     = 60        # "l'ora prima" dell'apertura
DEF_FINESTRE       = "5,15,30,60"
DEF_FIN_CLASSE     = 15        # il range di riferimento e' quello dei primi 15'
DEF_FIN_GIUDIZIO   = 60        # la classe si decide guardando i primi 60'
DEF_K_MARGINE      = 0.10      # rottura = superare il bordo di >= 10% dell'ampiezza 15'
DEF_PAVIMENTO_PCT  = 0.02      # ...e comunque di almeno lo 0,02% del prezzo
DEF_DEADBAND_PCT   = 0.05      # banda morta per dire "i primi 15' sono andati SU/GIU'"
DEF_MIN_BARRE_ORA  = 55        # sotto: giorno SOSPETTO (copertura oraria anomala)
DEF_MAX_BUCO_MIN   = 3         # buco interno all'ora d'apertura oltre il quale e' SOSPETTO
DEF_MIN_BARRE_PRE  = 30        # copertura della pre-apertura (solo INFORMATIVA, non esclude)
DEF_CASSAFORTE_DA  = 2021      # da questo anno in poi: cassaforte della FASE 2
DEF_QUOTA_SOSPETTI = 20.0      # se in un anno i sospetti superano questa %, e' un RILIEVO
DEF_MIN_GIORNI_ANNO = 150      # sotto: la distribuzione di quell'anno NON e' leggibile


# ---------------------------------------------------------------------
#  ATTREZZI
# ---------------------------------------------------------------------
def log(msg):
    print(msg, flush=True)


def mm_da_ora(testo, nome):
    """'09:30' -> 570 minuti dalla mezzanotte. Solo due cifre e due
    punti: un orario scritto male e' un motivo per NON partire."""
    t = (testo or "").strip()
    if len(t) != 5 or t[2] != ":" or not t[0:2].isdigit() or not t[3:5].isdigit():
        raise ValueError("%s: orario non valido '%s' (atteso HH:MM)" % (nome, testo))
    h = int(t[0:2])
    m = int(t[3:5])
    if h > 23 or m > 59:
        raise ValueError("%s: orario fuori scala '%s'" % (nome, testo))
    return h * 60 + m


def hhmm(minuti):
    minuti = int(minuti) % (24 * 60)
    return "%02d:%02d" % (minuti // 60, minuti % 60)


def mediana(valori):
    if not valori:
        return None
    v = sorted(valori)
    n = len(v)
    if n % 2 == 1:
        return v[n // 2]
    return (v[n // 2 - 1] + v[n // 2]) / 2.0


def quantile(valori, q):
    """Quantile per interpolazione lineare. Serve ai quartili del
    referto: una mediana da sola non dice quanto e' larga la coda."""
    if not valori:
        return None
    v = sorted(valori)
    if len(v) == 1:
        return v[0]
    pos = (len(v) - 1) * q
    basso = int(pos)
    alto = min(basso + 1, len(v) - 1)
    frazione = pos - basso
    return v[basso] + (v[alto] - v[basso]) * frazione


def f(valore, cifre=3):
    """Un numero NON MISURATO si scrive n/d, MAI 0: un numero plausibile
    al posto di un buco e' il peggior refuso possibile (checklist 66)."""
    if valore is None:
        return "n/d"
    return ("%." + str(cifre) + "f") % valore


def pct(parte, totale, cifre=1):
    if not totale:
        return "n/d"
    return ("%." + str(cifre) + "f") % (100.0 * parte / totale)


def moda(valori):
    """Torna (valore, quante). Le chiavi si scorrono ORDINATE, cosi' un
    pareggio non fa cambiare risposta da una corsa all'altra: le chiavi
    di un dizionario non sono un ordine (checklist 70-bis)."""
    if not valori:
        return None, 0
    conta = {}
    for v in valori:
        conta[v] = conta.get(v, 0) + 1
    migliore = None
    quante = -1
    for k in sorted(conta.keys()):
        if conta[k] > quante:
            migliore = k
            quante = conta[k]
    return migliore, quante


def ram_picco_mb():
    """La RAM di picco del processo, se la macchina la sa dire. Tre
    strade e un 'non misurabile' onesto: mai un numero inventato."""
    try:
        import resource
        picco = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss
        # Linux: kilobyte. macOS: byte.
        if sys.platform == "darwin":
            return picco / (1024.0 * 1024.0)
        return picco / 1024.0
    except Exception:
        pass
    try:
        import ctypes
        import ctypes.wintypes

        class CONTATORI(ctypes.Structure):
            _fields_ = [("cb", ctypes.wintypes.DWORD),
                        ("PageFaultCount", ctypes.wintypes.DWORD),
                        ("PeakWorkingSetSize", ctypes.c_size_t),
                        ("WorkingSetSize", ctypes.c_size_t),
                        ("QuotaPeakPagedPoolUsage", ctypes.c_size_t),
                        ("QuotaPagedPoolUsage", ctypes.c_size_t),
                        ("QuotaPeakNonPagedPoolUsage", ctypes.c_size_t),
                        ("QuotaNonPagedPoolUsage", ctypes.c_size_t),
                        ("PagefileUsage", ctypes.c_size_t),
                        ("PeakPagefileUsage", ctypes.c_size_t)]

        c = CONTATORI()
        c.cb = ctypes.sizeof(CONTATORI)
        ok = ctypes.windll.psapi.GetProcessMemoryInfo(
            ctypes.windll.kernel32.GetCurrentProcess(), ctypes.byref(c), c.cb)
        if ok:
            return c.PeakWorkingSetSize / (1024.0 * 1024.0)
    except Exception:
        pass
    return None


def scrivi_atomico(percorso, righe):
    """tmp + replace: mai lasciare sul disco un referto TRONCATO che poi
    qualcuno legge come se fosse intero (checklist 16, pezzo 3)."""
    tmp = percorso + ".parziale"
    with open(tmp, "w", newline="", encoding="ascii", errors="replace") as fh:
        for r in righe:
            fh.write(r + "\n")
    os.replace(tmp, percorso)


# ---------------------------------------------------------------------
#  LA CONFIGURAZIONE, in un oggetto solo: cosi' l'autotest gira sullo
#  STESSO codice della corsa vera, con altri numeri.
# ---------------------------------------------------------------------
class Config(object):
    def __init__(self, args):
        self.apertura = mm_da_ora(args.ora_apertura, "--ora-apertura")
        self.chiusura = mm_da_ora(args.ora_chiusura, "--ora-chiusura")
        self.minuti_pre = int(args.minuti_pre)
        self.finestre = []
        for pezzo in str(args.finestre).split(","):
            pezzo = pezzo.strip()
            if pezzo:
                self.finestre.append(int(pezzo))
        self.finestre = sorted(set(self.finestre))
        self.fin_classe = int(args.finestra_classe)
        self.fin_giudizio = int(args.finestra_giudizio)
        self.k_margine = float(args.k_margine)
        self.pavimento_pct = float(args.pavimento_pct)
        self.deadband_pct = float(args.deadband_pct)
        self.min_barre_ora = int(args.min_barre_ora)
        self.max_buco_min = int(args.max_buco_min)
        self.min_barre_pre = int(args.min_barre_pre)
        self.cassaforte_da = int(args.cassaforte_da)
        self.quota_sospetti = float(args.quota_sospetti)
        self.min_giorni_anno = int(args.min_giorni_anno)
        # finestre derivate, in minuti dalla mezzanotte
        self.pre_da = self.apertura - self.minuti_pre
        self.pre_a = self.apertura - 1
        self.durata_apr = max(self.finestre + [self.fin_classe, self.fin_giudizio])
        self.apr_da = self.apertura
        self.apr_a = self.apertura + self.durata_apr - 1
        # candidati alla chiusura cash: le 5 ore prima della chiusura.
        # Cinque e non una perche' i giorni di mezza seduta (vigilia di
        # Natale, venerdi' dopo il Ringraziamento) chiudono alle 13:00:
        # con una finestra stretta il gap del giorno dopo sarebbe n/d
        # proprio nei giorni piu' particolari.
        self.chi_da = self.chiusura - 300
        self.chi_a = self.chiusura
        self.problemi_config = []
        if self.pre_da < 0:
            self.problemi_config.append(
                "la pre-apertura comincia prima della mezzanotte: --minuti-pre troppo grande")
        if self.apr_a >= 24 * 60:
            self.problemi_config.append(
                "la finestra d'apertura sfora la mezzanotte: --finestre troppo lunga")
        if self.chi_da < 0:
            self.problemi_config.append("--ora-chiusura troppo presto")
        if self.fin_classe not in self.finestre:
            self.problemi_config.append(
                "--finestra-classe %d non e' fra le --finestre" % self.fin_classe)
        if self.fin_giudizio not in self.finestre:
            self.problemi_config.append(
                "--finestra-giudizio %d non e' fra le --finestre" % self.fin_giudizio)
        if self.fin_giudizio <= self.fin_classe:
            self.problemi_config.append(
                "--finestra-giudizio deve essere PIU' LUNGA di --finestra-classe")


def regime_di(anno):
    """I REGIMI SONO UNA DICHIARAZIONE DI CALENDARIO, non una misura.
    Nessuno qui ha datato le fasi di mercato barra per barra: si sono
    presi gli anni cosi' come li nomina la storia. Va letto come
    un'etichetta, non come un verdetto."""
    if anno <= 2019:
        return "2010-2019"
    if anno == 2020:
        return "2020_covid"
    if anno == 2021:
        return "2021"
    if anno == 2022:
        return "2022_orso"
    return "2023-2026"


ORDINE_REGIMI = ["2010-2019", "2020_covid", "2021", "2022_orso", "2023-2026"]
ORDINE_CLASSI = ["DRIVE-UP", "DRIVE-DOWN", "FADE-UP", "FADE-DOWN", "RANGE", "RIENTRO"]


# =====================================================================
#  LA CLASSIFICAZIONE -- MECCANICA, e in un posto solo.
#
#  IL SUFFISSO NOMINA SEMPRE IL LATO DELLA ROTTURA. Sempre, in tutte e
#  quattro le classi direzionali. Cioe':
#    DRIVE-UP    ha rotto AL RIALZO e ha chiuso la finestra SOPRA
#    DRIVE-DOWN  ha rotto AL RIBASSO e ha chiuso SOTTO
#    FADE-UP     ha rotto AL RIALZO e ha chiuso SOTTO il minimo del
#                range di riferimento (la rottura rialzista e' stata
#                rimangiata)
#    FADE-DOWN   ha rotto AL RIBASSO e ha chiuso SOPRA il massimo
#  Questa e' la sola convenzione possibile senza ambiguita', ed e'
#  scritta qui, nei criteri e in testa a ogni referto.
#
#  LA CASCATA E' ORDINATA E DETERMINISTICA. Un giorno puo' rompere DA
#  TUTTI E DUE I LATI: in quel caso vince la regola del FADE (una
#  rottura rimangiata dice piu' di una rottura riuscita), e il giorno
#  porta la bandiera DUE_LATI=1 nel CSV. Il referto conta quanti sono,
#  cosi' il peso della regola di priorita' si MISURA invece di restare
#  una scelta nascosta.
# =====================================================================
def classifica(hi_rif, lo_rif, hi_post, lo_post, chiusura, margine):
    rott_up = (hi_post is not None) and (hi_post >= hi_rif + margine)
    rott_dn = (lo_post is not None) and (lo_post <= lo_rif - margine)
    chiude_sopra = chiusura >= hi_rif + margine
    chiude_sotto = chiusura <= lo_rif - margine
    due_lati = 1 if (rott_up and rott_dn) else 0

    if not rott_up and not rott_dn:
        return "RANGE", due_lati, rott_up, rott_dn
    if rott_dn and chiude_sopra:
        return "FADE-DOWN", due_lati, rott_up, rott_dn
    if rott_up and chiude_sotto:
        return "FADE-UP", due_lati, rott_up, rott_dn
    if rott_up and chiude_sopra:
        return "DRIVE-UP", due_lati, rott_up, rott_dn
    if rott_dn and chiude_sotto:
        return "DRIVE-DOWN", due_lati, rott_up, rott_dn
    return "RIENTRO", due_lati, rott_up, rott_dn


# =====================================================================
#  IL GIORNO: dagli aggregati grezzi alla riga finita.
#  `barre` e' un dizionario offset(minuti dall'apertura) -> (o,h,l,c).
#  La chiave e' UNICA per costruzione (una barra M1 per minuto), quindi
#  scorrerla ordinata e' deterministico e non ha pari da riordinare
#  (checklist 81).
# =====================================================================
def costruisci_giorno(cfg, giorno):
    r = {}
    r["data"] = giorno["data"]
    d = giorno["dt"]
    r["anno"] = d.year
    r["mese"] = d.month
    r["giorno_sett"] = ["lun", "mar", "mer", "gio", "ven", "sab", "dom"][d.weekday()]
    r["regime"] = regime_di(d.year)
    r["fase"] = "CASSAFORTE" if d.year >= cfg.cassaforte_da else "IS"
    r["barre_giorno"] = giorno["n_barre"]
    r["barre_pre"] = giorno["pre_n"]
    r["motivo"] = ""

    barre = giorno["apr"]
    offsets = sorted(barre.keys())
    dentro_ora = [o for o in offsets if o < cfg.fin_giudizio]
    r["barre_ora"] = len(dentro_ora)

    # ---- il buco piu' largo DENTRO la finestra di giudizio
    buco = 0
    if len(dentro_ora) >= 2:
        for a, b in zip(dentro_ora, dentro_ora[1:]):
            if (b - a) > buco:
                buco = b - a
    r["buco_max_min"] = buco

    # ---- l'APERTURA. Se la barra dell'offset 0 manca, il prezzo
    #      d'apertura NON e' osservato: si ripiega sulla prima barra dei
    #      primi 5 minuti e il giorno diventa SOSPETTO. Se non c'e'
    #      nemmeno quella, il giorno non ha apertura: non si misura.
    motivi = []
    apertura = None
    if 0 in barre:
        apertura = barre[0][0]
    else:
        primo = None
        for o in offsets:
            if 0 <= o < 5:
                primo = o
                break
        if primo is not None:
            apertura = barre[primo][0]
            # NIENTE " - " qui dentro: e' il separatore con cui il referto
            # spezza i motivi. Un motivo che contiene il separatore si
            # frantuma in due voci, e la seconda (col numero del giorno)
            # inquina l'elenco delle FAMIGLIE con una riga per giornata.
            motivi.append("apertura non osservata (prima barra a +%d min)" % primo)

    if apertura is None or apertura <= 0:
        r["stato"] = "SENZA_APERTURA"
        r["motivo"] = "nessuna barra nei primi 5 minuti dell'apertura"
        r["classe"] = ""
        return r

    r["apertura"] = apertura

    # ---- copertura: e' QUI che si decide se il giorno e' sospetto
    if r["barre_ora"] < cfg.min_barre_ora:
        motivi.append("copertura oraria %d barre su %d attese" %
                      (r["barre_ora"], cfg.fin_giudizio))
    if buco > cfg.max_buco_min:
        motivi.append("buco di %d minuti dentro la finestra" % buco)
    r["stato"] = "SOSPETTO" if motivi else "OK"
    r["motivo"] = " - ".join(motivi)          # MAI una virgola: il CSV e' a virgole

    # ---- il GAP dalla chiusura cash precedente
    r["chiusura_prec"] = giorno["chiusura_prec"]
    r["data_chiusura_prec"] = giorno["data_chiusura_prec"]
    if giorno["chiusura_prec"] is not None and giorno["chiusura_prec"] > 0:
        r["gap_pt"] = apertura - giorno["chiusura_prec"]
        r["gap_pct"] = 100.0 * r["gap_pt"] / giorno["chiusura_prec"]
    else:
        r["gap_pt"] = None
        r["gap_pct"] = None

    # ---- la PRE-APERTURA (l'ora prima)
    r["pre_hi"] = giorno["pre_hi"]
    r["pre_lo"] = giorno["pre_lo"]
    if giorno["pre_hi"] is not None and giorno["pre_lo"] is not None:
        r["pre_amp_pt"] = giorno["pre_hi"] - giorno["pre_lo"]
        r["pre_amp_pct"] = 100.0 * r["pre_amp_pt"] / apertura
    else:
        r["pre_amp_pt"] = None
        r["pre_amp_pct"] = None

    # ---- le finestre 5/15/30/60: escursione SU, escursione GIU',
    #      e dove chiude la finestra. Tutto DAL PREZZO DI APERTURA,
    #      in punti indice e in % del prezzo (il % e' l'unico metro
    #      confrontabile fra il Nasdaq a 2.135 del 2010 e quello a
    #      28.272 del 2026).
    r["fin"] = {}
    for w in cfg.finestre:
        hi = None
        lo = None
        ultimo = None
        n = 0
        for o in offsets:
            if o < 0 or o >= w:
                continue
            _o, _h, _l, _c = barre[o]
            hi = _h if hi is None or _h > hi else hi
            lo = _l if lo is None or _l < lo else lo
            ultimo = _c
            n += 1
        if n == 0:
            r["fin"][w] = {"up_pt": None, "up_pct": None, "dn_pt": None,
                           "dn_pct": None, "cl_pt": None, "cl_pct": None,
                           "hi": None, "lo": None, "cl": None, "n": 0}
            continue
        r["fin"][w] = {
            "up_pt": hi - apertura,
            "up_pct": 100.0 * (hi - apertura) / apertura,
            "dn_pt": lo - apertura,
            "dn_pct": 100.0 * (lo - apertura) / apertura,
            "cl_pt": ultimo - apertura,
            "cl_pct": 100.0 * (ultimo - apertura) / apertura,
            "hi": hi, "lo": lo, "cl": ultimo, "n": n,
        }

    # ---- LA CLASSE.
    rif = r["fin"].get(cfg.fin_classe)
    giu = r["fin"].get(cfg.fin_giudizio)
    if not rif or rif["n"] == 0 or not giu or giu["n"] == 0:
        r["classe"] = ""
        r["due_lati"] = 0
        r["amp_rif_pt"] = None
        r["amp_rif_pct"] = None
        r["margine_pt"] = None
        if r["stato"] == "OK":
            r["stato"] = "SOSPETTO"
            r["motivo"] = "finestra di riferimento o di giudizio senza barre"
        return r

    hi_rif = rif["hi"]
    lo_rif = rif["lo"]
    r["amp_rif_pt"] = hi_rif - lo_rif
    r["amp_rif_pct"] = 100.0 * (hi_rif - lo_rif) / apertura

    # il MARGINE di rottura: il piu' grande fra una frazione
    # dell'ampiezza del range di riferimento e un pavimento in % del
    # prezzo. Serve il pavimento perche' un range di riferimento quasi
    # nullo renderebbe "rottura" qualunque tick.
    margine = max(cfg.k_margine * (hi_rif - lo_rif),
                  cfg.pavimento_pct / 100.0 * apertura)
    r["margine_pt"] = margine

    # l'escursione DOPO la formazione del range di riferimento
    hi_post = None
    lo_post = None
    for o in offsets:
        if o < cfg.fin_classe or o >= cfg.fin_giudizio:
            continue
        _o, _h, _l, _c = barre[o]
        hi_post = _h if hi_post is None or _h > hi_post else hi_post
        lo_post = _l if lo_post is None or _l < lo_post else lo_post

    classe, due_lati, rott_up, rott_dn = classifica(
        hi_rif, lo_rif, hi_post, lo_post, giu["cl"], margine)
    r["classe"] = classe
    r["due_lati"] = due_lati
    r["rott_up"] = 1 if rott_up else 0
    r["rott_dn"] = 1 if rott_dn else 0

    # ---- PERSISTENZA: la direzione dei primi <fin_classe> minuti
    #      continua nei <fin_giudizio>?
    #      dir = segno di (chiusura del range di riferimento - apertura),
    #      con una banda morta in % del prezzo per non chiamare
    #      "direzione" un movimento da niente.
    soglia = cfg.deadband_pct / 100.0 * apertura
    delta_rif = rif["cl"] - apertura
    if delta_rif > soglia:
        r["dir_rif"] = "SU"
    elif delta_rif < -soglia:
        r["dir_rif"] = "GIU"
    else:
        r["dir_rif"] = "PIATTO"
    if r["dir_rif"] == "PIATTO":
        r["persiste"] = None
        r["estensione_pct"] = None
    else:
        avanti = giu["cl"] - rif["cl"]
        if r["dir_rif"] == "GIU":
            avanti = -avanti
        r["persiste"] = 1 if avanti > 0 else 0
        r["estensione_pct"] = 100.0 * avanti / apertura
    return r


# =====================================================================
#  LA SCANSIONE. Una sola passata, in streaming.
# =====================================================================
def nuovo_giorno(testo_data, dt):
    return {
        "data": testo_data, "dt": dt,
        "pre_hi": None, "pre_lo": None, "pre_n": 0,
        "apr": {}, "apr_dup": 0,
        "chi_min": None, "chi_close": None,
        "chiusura_prec": None, "data_chiusura_prec": "",
        "n_barre": 0,
        "prec_min": None, "buco_max": 0, "buco_inizio": None,
    }


def riconosci_formato(percorso):
    """Un artefatto non si identifica dal NOME: si apre e si guarda la
    prima riga (checklist 83). Nel repo ci sono DUE strumenti che
    scrivono un file chiamato <SIMBOLO>_M1.csv, in due formati diversi:
    dire 'il file manca' quando il file c'e' ma e' dell'altro gemello e'
    l'errore che manda a riscaricare per niente."""
    try:
        with open(percorso, "r", encoding="ascii", errors="replace") as fh:
            for _ in range(6):
                riga = fh.readline()
                if not riga:
                    break
                riga = riga.strip()
                if not riga:
                    continue
                if riga.startswith("Time,"):
                    continue
                if (len(riga) > 16 and riga[4] == "." and riga[7] == "."
                        and riga[10] == " " and riga[13] == ":" and riga[16] == ","):
                    return "FORMATO1", riga
                if len(riga) > 15 and riga[8] == " " and ";" in riga:
                    return "HISTDATA_GREZZO", riga
                return "NON_RICONOSCIUTO", riga
    except Exception as e:
        return "NON_LEGGIBILE", type(e).__name__ + ": " + str(e)[:120]
    return "VUOTO", ""


def scandisci(cfg, percorso, ogni=1000000):
    """Torna (righe, diagnostica). RAM: gli aggregati di UN giorno."""
    diag = {
        "righe": 0, "barre": 0, "scartate": 0, "duplicate": 0,
        "fuori_ordine": 0, "date_ripetute": 0, "giorni": 0,
        "prima": "", "ultima": "",
        "gap_sessione": {},     # (anno,mese) -> [minuto d'inizio del buco piu' largo]
        "apertura_sett": {},    # (anno,mese) -> [minuto della prima barra dopo >=12 h]
    }
    righe_out = []
    corrente = None
    viste = set()
    ultima_chiusura = None
    ultima_chiusura_data = ""
    prec_stamp = ""
    # per l'apertura di SETTIMANA serve il tempo assoluto, non quello del
    # giorno: si tiene l'ordinale della data (calcolato UNA volta per
    # giornata, non per barra) e il minuto dell'ultima barra vista.
    ord_corrente = 0
    ultimo_ord = None
    ultimo_mdg = None

    def chiudi(g):
        if g is None:
            return
        diag["giorni"] += 1
        # il canarino del fuso vuole solo le giornate PIENE: un lembo di
        # domenica sera con 200 barre non descrive nessuna sessione
        if g["n_barre"] >= 500:
            chiave = (g["dt"].year, g["dt"].month)
            if g["buco_inizio"] is not None and g["buco_max"] >= 30:
                diag["gap_sessione"].setdefault(chiave, []).append(g["buco_inizio"])
        g["chiusura_prec"] = ultima_chiusura
        g["data_chiusura_prec"] = ultima_chiusura_data
        righe_out.append(costruisci_giorno(cfg, g))

    with open(percorso, "r", encoding="ascii", errors="replace") as fh:
        for riga in fh:
            diag["righe"] += 1
            if ogni and diag["righe"] % ogni == 0:
                log("    ... %d milioni di righe lette" % (diag["righe"] // 1000000))
            if len(riga) < 17:
                continue
            if riga[0] == "T":            # l'intestazione
                continue
            # parsing per posizione: niente strptime, niente split, sulle
            # righe che non servono. Su 5,2 M righe la differenza si sente.
            stamp = riga[0:16]
            try:
                anno = int(riga[0:4])
                mese = int(riga[5:7])
                gio = int(riga[8:10])
                ore = int(riga[11:13])
                minu = int(riga[14:16])
            except ValueError:
                diag["scartate"] += 1
                continue
            if riga[4] != "." or riga[7] != "." or riga[13] != ":":
                diag["scartate"] += 1
                continue
            if stamp < prec_stamp:
                diag["fuori_ordine"] += 1
            prec_stamp = stamp
            mdg = ore * 60 + minu
            testo_data = riga[0:10]

            if corrente is None or corrente["data"] != testo_data:
                if corrente is not None:
                    # PRIMA si chiude la giornata (che legge la chiusura
                    # cash PRECEDENTE), POI si aggiorna il testimone. Al
                    # contrario, il gap di ogni giorno verrebbe calcolato
                    # contro la chiusura di SE STESSO -- cioe' sempre
                    # quasi zero, e plausibile.
                    chiudi(corrente)
                    if corrente["chi_close"] is not None:
                        ultima_chiusura = corrente["chi_close"]
                        ultima_chiusura_data = corrente["data"]
                if testo_data in viste:
                    diag["date_ripetute"] += 1
                viste.add(testo_data)
                try:
                    dt = date(anno, mese, gio)
                except ValueError:
                    diag["scartate"] += 1
                    corrente = None
                    continue
                corrente = nuovo_giorno(testo_data, dt)
                ord_corrente = dt.toordinal()
                if not diag["prima"]:
                    diag["prima"] = stamp

            diag["barre"] += 1
            diag["ultima"] = stamp
            # APERTURA DI SETTIMANA: la prima barra dopo un silenzio di
            # almeno 12 ore (il weekend). E' la seconda misura del fuso, ed
            # e' INDIPENDENTE dalla prima: guarda un'altra transizione.
            if ultimo_ord is not None:
                salto_ass = (ord_corrente - ultimo_ord) * 1440 + (mdg - ultimo_mdg)
                if salto_ass >= 720:
                    diag["apertura_sett"].setdefault(
                        (corrente["dt"].year, corrente["dt"].month), []).append(mdg)
            ultimo_ord = ord_corrente
            ultimo_mdg = mdg
            corrente["n_barre"] += 1
            if corrente["prec_min"] is not None:
                salto = mdg - corrente["prec_min"]
                if salto > corrente["buco_max"]:
                    corrente["buco_max"] = salto
                    corrente["buco_inizio"] = corrente["prec_min"]
            corrente["prec_min"] = mdg

            # solo le tre finestre che servono vengono davvero parsate
            in_pre = (cfg.pre_da <= mdg <= cfg.pre_a)
            in_apr = (cfg.apr_da <= mdg <= cfg.apr_a)
            in_chi = (cfg.chi_da <= mdg <= cfg.chi_a)
            if not (in_pre or in_apr or in_chi):
                continue

            campi = riga.rstrip("\r\n").split(",")
            if len(campi) < 5:
                diag["scartate"] += 1
                continue
            try:
                po = float(campi[1])
                ph = float(campi[2])
                pl = float(campi[3])
                pc = float(campi[4])
            except ValueError:
                diag["scartate"] += 1
                continue
            if po <= 0 or ph <= 0 or pl <= 0 or pc <= 0 or ph < pl:
                diag["scartate"] += 1
                continue

            if in_pre:
                corrente["pre_n"] += 1
                if corrente["pre_hi"] is None or ph > corrente["pre_hi"]:
                    corrente["pre_hi"] = ph
                if corrente["pre_lo"] is None or pl < corrente["pre_lo"]:
                    corrente["pre_lo"] = pl
            if in_apr:
                off = mdg - cfg.apertura
                if off in corrente["apr"]:
                    corrente["apr_dup"] += 1
                    diag["duplicate"] += 1
                else:
                    corrente["apr"][off] = (po, ph, pl, pc)
            if in_chi:
                if corrente["chi_min"] is None or mdg >= corrente["chi_min"]:
                    corrente["chi_min"] = mdg
                    corrente["chi_close"] = pc

    if corrente is not None:
        chiudi(corrente)
    return righe_out, diag


# =====================================================================
#  IL CANARINO DEL FUSO. Misura, non assume.
# =====================================================================
def canarino_fuso(diag):
    """Torna (righe, rilievi) con rilievi = LISTA, una voce per MISURA.

    E' una lista e non una voce sola perche' il referto stesso dichiara
    che le due misure sono INDIPENDENTI e che 'se una sola delle due si
    muove, non e' il fuso: e' quella transizione'. Con una variabile sola
    l'ultima misura sovrascriveva la prima, e il caso PIU' GRAVE (tutte e
    due dicono EST FISSO = e' proprio il fuso) si leggeva identico al caso
    lieve (ne ha parlato una). L'informazione che distingue i due casi e'
    esattamente quella che serve per decidere."""
    righe = []
    rilievi = []
    righe.append("CANARINO DEL FUSO -- il feed segue il DST americano?")
    righe.append("  Si guarda, mese per mese, (a) l'ora d'inizio della PAUSA piu' larga")
    righe.append("  della giornata (la manutenzione del feed, ~17:00-18:00 New York) e")
    righe.append("  (b) l'ora della RIAPERTURA DI SETTIMANA, cioe' la prima barra dopo")
    righe.append("  un silenzio di almeno 12 ore. Se GENNAIO e LUGLIO danno la")
    righe.append("  STESSA ora -> il feed segue il DST = ORA LOCALE DI NEW YORK, e allora")
    righe.append("  l'apertura cash sta alle 09:30 del file TUTTO L'ANNO.")
    righe.append("  Se LUGLIO e' un'ora PRIMA -> feed a EST FISSO: meta' anno verrebbe")
    righe.append("  misurato un'ora fuori bersaglio. In quel caso lo studio NON e' valido")
    righe.append("  cosi' com'e' e va rifatto con l'ora corretta mese per mese.")
    righe.append("  Le due misure sono INDIPENDENTI: guardano due transizioni diverse")
    righe.append("  del feed (la pausa di ogni giorno e la riapertura della domenica")
    righe.append("  sera). Se una sola delle due si muove, non e' il fuso: e' quella")
    righe.append("  transizione, e va guardata a parte.")
    for etichetta, mappa in (("pausa giornaliera", diag["gap_sessione"]),
                             ("apertura settimana", diag["apertura_sett"])):
        per_mese = {}
        inverno = []
        estate = []
        for chiave in sorted(mappa.keys()):
            anno, mese = chiave
            m, quante = moda(mappa[chiave])
            if m is None:
                continue
            per_mese.setdefault(mese, []).append(m)
            if mese in (1, 2, 12):
                inverno.append(m)
            if mese in (6, 7, 8):
                estate.append(m)
        # la mappa dei 12 mesi: e' li' che si vede se lo scivolamento c'e'
        # e QUANDO comincia. Un verdetto senza la mappa non e' verificabile.
        pezzi = []
        for mese in range(1, 13):
            m, _q = moda(per_mese.get(mese, []))
            pezzi.append("%02d=%s" % (mese, hhmm(m) if m is not None else "n/d"))
        righe.append("  %-19s mese per mese: %s" % (etichetta, " ".join(pezzi[0:6])))
        righe.append("  %-19s                %s" % ("", " ".join(pezzi[6:12])))
        mi, _ = moda(inverno)
        me, _ = moda(estate)
        if mi is None or me is None:
            righe.append("  %-19s NON MISURABILE (servono mesi invernali E estivi)" % etichetta)
            rilievi.append("canarino del fuso non misurabile su '%s'" % etichetta)
            continue
        delta = me - mi
        righe.append("  %-19s INVERNO %s   ESTATE %s   differenza %+d min" %
                     (etichetta, hhmm(mi), hhmm(me), delta))
        if abs(delta) <= 5:
            righe.append("      -> coerente col DST: ora locale di NEW YORK.")
        elif -75 <= delta <= -45:
            righe.append("      -> EST FISSO: FERMARSI. L'apertura cash NON e' alle 09:30")
            righe.append("         del file da meta' marzo a inizio novembre (NON meta' anno:")
            righe.append("         il DST americano dura otto mesi su dodici).")
            rilievi.append("il canarino del fuso dice EST FISSO su '%s': lo studio va rifatto" % etichetta)
        else:
            righe.append("      -> INCERTO (differenza anomala): guardare i mesi uno per uno.")
            rilievi.append("canarino del fuso INCERTO su '%s' (differenza %+d min)" % (etichetta, delta))
    if len([x for x in rilievi if "EST FISSO" in x]) >= 2:
        rilievi.append("EST FISSO su TUTTE E DUE le misure indipendenti: non e' una "
                       "transizione storta, e' il FUSO. Lo studio non si legge.")
    return righe, rilievi


# =====================================================================
#  IL CSV PER-GIORNO. Nessun campo di testo contiene una virgola
#  (checklist 75); il punto decimale e' quello di Python, invariante.
# =====================================================================
def intestazione_csv(cfg):
    testa = ["data", "giorno_sett", "anno", "regime", "fase", "stato", "motivo",
             "barre_giorno", "barre_pre", "barre_ora", "buco_max_min",
             "apertura", "chiusura_prec", "data_chiusura_prec", "gap_pt", "gap_pct",
             "pre_hi", "pre_lo", "pre_amp_pt", "pre_amp_pct",
             "amp_rif_pt", "amp_rif_pct", "margine_pt",
             "classe", "due_lati", "rott_up", "rott_dn",
             "dir_rif", "persiste", "estensione_pct"]
    for w in cfg.finestre:
        testa += ["up%d_pt" % w, "up%d_pct" % w, "dn%d_pt" % w, "dn%d_pct" % w,
                  "cl%d_pt" % w, "cl%d_pct" % w]
    return testa


def riga_csv(cfg, r):
    def n(v, c=5):
        return "" if v is None else ("%." + str(c) + "f") % v
    campi = [
        r.get("data", ""), r.get("giorno_sett", ""), str(r.get("anno", "")),
        r.get("regime", ""), r.get("fase", ""), r.get("stato", ""),
        (r.get("motivo", "") or "").replace(",", " -"),
        str(r.get("barre_giorno", 0)), str(r.get("barre_pre", 0)),
        str(r.get("barre_ora", 0)), str(r.get("buco_max_min", 0)),
        n(r.get("apertura")), n(r.get("chiusura_prec")), r.get("data_chiusura_prec", ""),
        n(r.get("gap_pt")), n(r.get("gap_pct")),
        n(r.get("pre_hi")), n(r.get("pre_lo")), n(r.get("pre_amp_pt")), n(r.get("pre_amp_pct")),
        n(r.get("amp_rif_pt")), n(r.get("amp_rif_pct")), n(r.get("margine_pt")),
        r.get("classe", ""), str(r.get("due_lati", "")), str(r.get("rott_up", "")),
        str(r.get("rott_dn", "")), r.get("dir_rif", ""),
        "" if r.get("persiste") is None else str(r.get("persiste")),
        n(r.get("estensione_pct")),
    ]
    fin = r.get("fin", {})
    for w in cfg.finestre:
        d = fin.get(w)
        if not d:
            campi += ["", "", "", "", "", ""]
        else:
            campi += [n(d["up_pt"]), n(d["up_pct"]), n(d["dn_pt"]), n(d["dn_pct"]),
                      n(d["cl_pt"]), n(d["cl_pct"])]
    return ",".join(campi)


# =====================================================================
#  I REFERTI
# =====================================================================
def testata(cfg, titolo, percorso_dati, diag, note_fase):
    r = []
    r.append("=====================================================================")
    r.append(" " + titolo)
    r.append("=====================================================================")
    r.append("strumento: " + VERSIONE + "   (FASE 1: ANATOMIA DESCRITTIVA)")
    r.append("dati     : " + percorso_dati)
    r.append("barre lette: %d   giorni di calendario visti: %d" % (diag["barre"], diag["giorni"]))
    r.append("            (questi due numeri, il CANARINO DEL FUSO e i conteggi di")
    r.append("             igiene del file valgono su TUTTO il file: sono diagnostica")
    r.append("             del DATO. Le tabelle piu' sotto valgono sulla finestra di")
    r.append("             QUESTO referto.)")
    r.append("prima barra: %s    ultima barra: %s   (ORA DEL FILE = NEW YORK)" %
             (diag["prima"], diag["ultima"]))
    r.append("")
    r.append("!!! QUESTO NON E' UN BACKTEST. Qui dentro non c'e' e non ci sara' MAI")
    r.append("    un profit factor, un'equity, un drawdown o un numero di trade.")
    r.append("    Sono CONTEGGI su quello che il mercato ha fatto all'apertura.")
    r.append("    Nessun motore, nessuna promozione, nessuna firma.")
    r.append("")
    r.append("!!! IL CANCELLO QUALITA' DEL FEED E' IN VERIFICA (26/08/2026).")
    r.append("    Le MISURE LAMPO del cancello _EXT stanno esaminando TRE eventi")
    r.append("    anomali, e il cancello ZERO e' ancora CHIUSO (diff media H1")
    r.append("    0,061-0,101% contro <=0,05% richiesto). Questo studio GIRA LO")
    r.append("    STESSO, ma L'INTERPRETAZIONE DI QUESTI NUMERI DIPENDE DALL'ESITO")
    r.append("    DI QUELLE MISURE. Se il feed risultasse malato in un periodo, i")
    r.append("    conteggi di quel periodo vanno riletti, non riusati com'e'.")
    r.append("    Contromisura gia' dentro: i giorni con copertura oraria anomala")
    r.append("    sono ESCLUSI dai conteggi e contati a parte (GIORNI SOSPETTI).")
    r.append("")
    r.append("!!! I DATI SONO DI HISTDATA, NON DI BCM. Spread, orari di seduta e")
    r.append("    prezzi non sono quelli su cui si opera. Un'anatomia del feed")
    r.append("    esterno descrive il MERCATO, non il conto.")
    r.append("")
    r.append("--- LA REGOLA DELLE DUE FASI (vincolo, non consiglio) ---")
    r.append("  FASE 1 (questo file): si MISURA. Nessuna ipotesi di motore.")
    r.append("  FASE 2 (round futuri): le IPOTESI si scrivono guardando SOLO gli")
    r.append("    anni fino al %d, e si validano su %d-oggi + tick BCM." %
             (cfg.cassaforte_da - 1, cfg.cassaforte_da))
    r.append("  Percio' i referti sono TRE e separati: quello dell'addestramento,")
    r.append("  quello della CASSAFORTE e quello completo di contesto. Se una")
    r.append("  ipotesi nasce guardando la cassaforte, la cassaforte non e' piu'")
    r.append("  una validazione: e' un secondo campione d'addestramento.")
    r.append("  " + note_fase)
    r.append("")
    r.append("--- IL FUSO, DICHIARATO ---")
    r.append("  L'ora scritta nel CSV e' ORA LOCALE DI NEW YORK (misura di casa:")
    r.append("  8 import HistData su 8 hanno calibrato shift FISSO +5 contro il")
    r.append("  nativo BCM, possibile solo se il feed segue il DST americano).")
    r.append("  apertura cash Nasdaq = %s New York = %s ora server BCM = %s italiana." %
             (hhmm(cfg.apertura), hhmm(cfg.apertura + 300), hhmm(cfg.apertura + 360)))
    r.append("  (server = NY+5, oppure NY+4 nelle settimane DST sfasate di marzo e")
    r.append("   ottobre/novembre: e' il +5 che vale per la maggioranza dell'anno.)")
    r.append("  QUI NON SI CONVERTE NIENTE: si legge l'ora com'e' scritta.")
    r.append("")
    r.append("--- LE SENTINELLE, UNA SOLA CONVENZIONE ---")
    r.append("  Nei REFERTI: n/d = NON MISURATO. Mai uno zero al posto di un buco.")
    r.append("  Nel CSV per-giorno: il campo NON MISURATO e' VUOTO, non zero.")
    r.append("  Chi lo apre con un foglio di calcolo o con Import-Csv deve leggere")
    r.append("  la cella vuota come 'non misurato', non come 'zero': su un gap o su")
    r.append("  un'escursione lo zero sarebbe un numero perfettamente plausibile.")
    r.append("")
    return r


def blocco_definizioni(cfg):
    r = []
    r.append("--- LE DEFINIZIONI, CONGELATE PRIMA DI GUARDARE I NUMERI ---")
    r.append("  apertura      = Open della barra delle %s (ora del file = New York)" % hhmm(cfg.apertura))
    r.append("  pre-apertura  = i %d minuti prima (%s-%s): massimo e minimo" %
             (cfg.minuti_pre, hhmm(cfg.pre_da), hhmm(cfg.pre_a)))
    r.append("  gap           = apertura meno l'ULTIMA CHIUSURA CASH precedente (ultima")
    r.append("                  barra con orario <= %s del giorno di borsa prima)" % hhmm(cfg.chiusura))
    r.append("  range di rif. = massimo e minimo dei primi %d minuti" % cfg.fin_classe)
    r.append("  finestra di giudizio = i primi %d minuti" % cfg.fin_giudizio)
    r.append("  margine di rottura = max( %.2f x ampiezza del range di rif. ;" % cfg.k_margine)
    r.append("                            %.3f%% del prezzo d'apertura )" % cfg.pavimento_pct)
    r.append("                  (la frazione perche' la rottura si misuri sulla")
    r.append("                   volatilita' del giorno; il pavimento perche' con un")
    r.append("                   range quasi nullo qualunque tick sarebbe 'rottura')")
    r.append("")
    r.append("  IL SUFFISSO NOMINA SEMPRE IL LATO DELLA ROTTURA:")
    r.append("   DRIVE-UP    rompe AL RIALZO dopo il minuto %d e CHIUDE la finestra" % cfg.fin_classe)
    r.append("               sopra il massimo del range di rif. + margine")
    r.append("   DRIVE-DOWN  rompe AL RIBASSO e chiude sotto il minimo - margine")
    r.append("   FADE-UP     rompe AL RIALZO e chiude SOTTO il minimo - margine")
    r.append("               (la rottura rialzista e' stata rimangiata)")
    r.append("   FADE-DOWN   rompe AL RIBASSO e chiude SOPRA il massimo + margine")
    r.append("   RANGE       non rompe da nessuno dei due lati")
    r.append("   RIENTRO     rompe, ma chiude DENTRO il range di riferimento")
    r.append("  Cascata deterministica: RANGE -> FADE -> DRIVE -> RIENTRO. Un giorno")
    r.append("  che rompe DA TUTTI E DUE I LATI finisce nel FADE (una rottura")
    r.append("  rimangiata dice piu' di una riuscita) e porta la bandiera DUE_LATI:")
    r.append("  il referto li CONTA, cosi' il peso della regola di priorita' si legge")
    r.append("  invece di restare una scelta nascosta.")
    r.append("")
    r.append("  escursioni: SU e GIU' DAL PREZZO D'APERTURA, in punti indice e in %")
    r.append("  del prezzo. Il % e' l'unico metro confrontabile fra il Nasdaq a 2.135")
    r.append("  del 2010 e quello a 28.272 del 2026: una soglia in PUNTI su 16 anni")
    r.append("  non e' la stessa soglia.")
    r.append("  'favorevole/contraria' non esiste senza una posizione: qui si")
    r.append("  misurano SU e GIU', e la lettura per classe usa la direzione della")
    r.append("  classe (per un DRIVE-UP il favorevole e' il SU).")
    r.append("")
    r.append("  GIORNO SOSPETTO (escluso dai conteggi, contato a parte):")
    r.append("   - meno di %d barre nella finestra di giudizio (su %d attese), oppure" %
             (cfg.min_barre_ora, cfg.fin_giudizio))
    r.append("   - un buco interno di piu' di %d minuti, oppure" % cfg.max_buco_min)
    r.append("   - la barra dell'apertura manca (prezzo d'apertura non osservato)")
    r.append("  GIORNO SENZA APERTURA (feste, weekend, buchi di feed): nessuna barra")
    r.append("  nei primi 5 minuti. Non e' un giorno di borsa misurabile.")
    r.append("  copertura della pre-apertura: sotto %d barre su %d e' solo un'INFO," %
             (cfg.min_barre_pre, cfg.minuti_pre))
    r.append("  non esclude il giorno (il gap e il range pre restano leggibili).")
    r.append("")
    r.append("  I REGIMI SONO UN'ETICHETTA DI CALENDARIO, non una misura: nessuno ha")
    r.append("  datato le fasi barra per barra. 2010-2019 / 2020 covid / 2021 /")
    r.append("  2022 orso / 2023-2026.")
    r.append("")
    return r


def tabella_classi(cfg, righe, titolo, chiave):
    """Distribuzione delle classi per <chiave> (anno o regime), con i
    giorni sospetti e senza apertura in colonne PROPRIE: nessun giorno
    sparisce dal conto."""
    out = []
    gruppi = {}
    for r in righe:
        k = r.get(chiave)
        if k is None:
            continue
        gruppi.setdefault(k, []).append(r)
    ordine = sorted(gruppi.keys())
    if chiave == "regime":
        ordine = [x for x in ORDINE_REGIMI if x in gruppi] + \
                 [x for x in sorted(gruppi.keys()) if x not in ORDINE_REGIMI]
    out.append(titolo)
    sotto_g1 = []
    intest = "  %-12s %7s %7s" % (chiave.upper(), "GIORNI", "BUONI")
    for c in ORDINE_CLASSI:
        intest += " %10s" % c
    intest += " %8s %8s %9s" % ("2LATI", "SOSPETTI", "NO-APERT")
    out.append(intest)
    for k in ordine:
        gg = gruppi[k]
        buoni = [x for x in gg if x.get("stato") == "OK" and x.get("classe")]
        sosp = len([x for x in gg if x.get("stato") == "SOSPETTO"])
        noap = len([x for x in gg if x.get("stato") == "SENZA_APERTURA"])
        riga = "  %-12s %7d %7d" % (str(k), len(gg), len(buoni))
        for c in ORDINE_CLASSI:
            n = len([x for x in buoni if x["classe"] == c])
            riga += " %5d/%4s" % (n, pct(n, len(buoni), 0))
        due = len([x for x in buoni if x.get("due_lati")])
        riga += " %8d %8d %9d" % (due, sosp, noap)
        #  IL CANCELLO G1 E' IMPOSTO QUI, non solo scritto nei criteri: una
        #  regola che vive nella prosa e non nel codice e' una regola che
        #  qualcuno leggera' di fretta (checklist 67). La riga si stampa
        #  LO STESSO -- nessun gruppo sparisce -- ma porta il marchio.
        if len(buoni) < cfg.min_giorni_anno:
            riga += "   <-- SOTTO G1: NON LEGGIBILE"
            sotto_g1.append(str(k))
        out.append(riga)
    out.append("  (per ogni classe: conteggio / % sui GIORNI BUONI. 2LATI = giorni che")
    out.append("   hanno rotto da tutti e due i lati. SOSPETTI e NO-APERT sono ESCLUSI")
    out.append("   dai conteggi delle classi ma restano scritti qui: nessun giorno")
    out.append("   sparisce dall'elenco.)")
    if sotto_g1:
        out.append("  CANCELLO G1 (>= %d giorni buoni): NON LEGGIBILI -> %s" %
                   (cfg.min_giorni_anno, ", ".join(sotto_g1)))
        out.append("   Quelle righe si stampano lo stesso, ma le loro percentuali NON")
        out.append("   si citano: su un campione cosi' sottile sono rumore. (Il 2010 e'")
        out.append("   un moncone di novembre-dicembre: e' atteso che ci finisca.)")
    else:
        out.append("  CANCELLO G1 (>= %d giorni buoni): superato da tutti." % cfg.min_giorni_anno)
    out.append("")
    return out


def tabella_mfe_per_classe(cfg, righe, titolo):
    out = [titolo]
    out.append("  Mediana (e quartili) dell'escursione DAL PREZZO D'APERTURA, in % del")
    out.append("  prezzo, sui giorni BUONI di ciascuna classe. FAVOREVOLE = nel verso")
    out.append("  della classe; CONTRARIA = nel verso opposto. Per RANGE/RIENTRO, che")
    out.append("  non hanno un verso, si stampano SU e GIU' cosi' come sono.")
    out.append("  %-11s %6s %8s %10s %10s %10s %10s %10s" %
               ("CLASSE", "n", "amp15%", "MFE15%", "MAE15%", "MFE60%", "MAE60%", "chius60%"))
    buoni = [x for x in righe if x.get("stato") == "OK" and x.get("classe")]
    w1 = cfg.fin_classe
    w2 = cfg.fin_giudizio
    for c in ORDINE_CLASSI:
        gg = [x for x in buoni if x["classe"] == c]
        if not gg:
            out.append("  %-11s %6d %8s %10s %10s %10s %10s %10s" %
                       (c, 0, "n/d", "n/d", "n/d", "n/d", "n/d", "n/d"))
            continue
        verso = 0
        if c in ("DRIVE-UP", "FADE-DOWN"):
            verso = 1
        elif c in ("DRIVE-DOWN", "FADE-UP"):
            verso = -1

        def prendi(x, w, quale):
            d = x.get("fin", {}).get(w)
            if not d:
                return None
            if verso >= 0:
                return d["up_pct"] if quale == "fav" else d["dn_pct"]
            return -d["dn_pct"] if quale == "fav" else -d["up_pct"]

        amp = [x["amp_rif_pct"] for x in gg if x.get("amp_rif_pct") is not None]
        f1 = [v for v in (prendi(x, w1, "fav") for x in gg) if v is not None]
        a1 = [v for v in (prendi(x, w1, "avv") for x in gg) if v is not None]
        f2 = [v for v in (prendi(x, w2, "fav") for x in gg) if v is not None]
        a2 = [v for v in (prendi(x, w2, "avv") for x in gg) if v is not None]
        ch = []
        for x in gg:
            d = x.get("fin", {}).get(w2)
            if d and d["cl_pct"] is not None:
                ch.append(d["cl_pct"] if verso >= 0 else -d["cl_pct"])
        out.append("  %-11s %6d %8s %10s %10s %10s %10s %10s" %
                   (c, len(gg), f(mediana(amp)), f(mediana(f1)), f(mediana(a1)),
                    f(mediana(f2)), f(mediana(a2)), f(mediana(ch))))
    out.append("")
    out.append("  Le CODE (quartili) sulle due classi di spinta, finestra %d':" % w2)
    for c in ("DRIVE-UP", "DRIVE-DOWN"):
        gg = [x for x in buoni if x["classe"] == c]
        verso = 1 if c == "DRIVE-UP" else -1
        vals = []
        for x in gg:
            d = x.get("fin", {}).get(w2)
            if not d or d["up_pct"] is None:
                continue
            vals.append(d["up_pct"] if verso > 0 else -d["dn_pct"])
        if not vals:
            out.append("   %-11s n/d" % c)
            continue
        out.append("   %-11s n=%d  Q1 %s  mediana %s  Q3 %s  massimo %s" %
                   (c, len(vals), f(quantile(vals, 0.25)), f(mediana(vals)),
                    f(quantile(vals, 0.75)), f(max(vals))))
    out.append("")
    return out


def tabella_finestre(cfg, righe, titolo):
    out = [titolo]
    out.append("  Mediana dell'escursione massima SU e GIU' dal prezzo d'apertura e")
    out.append("  della chiusura di finestra, in % del prezzo, su TUTTI i giorni buoni")
    out.append("  (nessun condizionamento: e' la fotografia grezza del movimento).")
    out.append("  %8s %6s %10s %10s %12s %12s" %
               ("FINESTRA", "n", "SU med%", "GIU med%", "|chius| med%", "ampiezza med%"))
    buoni = [x for x in righe if x.get("stato") == "OK" and x.get("classe")]
    for w in cfg.finestre:
        su = []
        giu = []
        ch = []
        amp = []
        for x in buoni:
            d = x.get("fin", {}).get(w)
            if not d or d["n"] == 0:
                continue
            su.append(d["up_pct"])
            giu.append(d["dn_pct"])
            ch.append(abs(d["cl_pct"]))
            amp.append(d["up_pct"] - d["dn_pct"])
        out.append("  %8d %6d %10s %10s %12s %12s" %
                   (w, len(su), f(mediana(su)), f(mediana(giu)),
                    f(mediana(ch)), f(mediana(amp))))
    out.append("")
    return out


def tabella_persistenza(cfg, righe, titolo):
    out = [titolo]
    out.append("  Domanda: la direzione dei primi %d minuti CONTINUA fino al minuto %d?" %
               (cfg.fin_classe, cfg.fin_giudizio))
    out.append("  direzione dei primi %d' = segno di (chiusura %d' - apertura), con banda" %
               (cfg.fin_classe, cfg.fin_classe))
    out.append("  morta di %.3f%% del prezzo. PERSISTE = la chiusura a %d' e' PIU' AVANTI" %
               (cfg.deadband_pct, cfg.fin_giudizio))
    out.append("  nello stesso verso della chiusura a %d'." % cfg.fin_classe)
    out.append("  %-12s %8s %8s %10s %14s" %
               ("DIREZIONE", "n", "persiste", "% persiste", "estens. med%"))
    buoni = [x for x in righe if x.get("stato") == "OK" and x.get("classe")]
    for d in ("SU", "GIU", "PIATTO"):
        gg = [x for x in buoni if x.get("dir_rif") == d]
        if d == "PIATTO":
            out.append("  %-12s %8d %8s %10s %14s" % (d, len(gg), "n/d", "n/d", "n/d"))
            continue
        pers = [x for x in gg if x.get("persiste")]
        est = [x["estensione_pct"] for x in gg if x.get("estensione_pct") is not None]
        out.append("  %-12s %8d %8d %10s %14s" %
                   (d, len(gg), len(pers), pct(len(pers), len(gg)), f(mediana(est))))
    out.append("  (estensione = quanto ancora si muove nel verso, in % del prezzo:")
    out.append("   negativa vuol dire che e' tornata indietro.)")
    out.append("")
    return out


def tabella_gap(cfg, righe, titolo):
    out = [titolo]
    out.append("  Le classi condizionate al GAP d'apertura (apertura contro l'ultima")
    out.append("  chiusura cash). Le soglie del gap sono in % del prezzo e sono le")
    out.append("  stesse tre di sempre: sotto -0,25%, dentro, sopra +0,25%.")
    buoni = [x for x in righe if x.get("stato") == "OK" and x.get("classe")]
    fasce = [("GAP GIU < -0.25%", lambda g: g is not None and g < -0.25),
             ("PIATTO -0.25..0.25", lambda g: g is not None and -0.25 <= g <= 0.25),
             ("GAP SU  > +0.25%", lambda g: g is not None and g > 0.25),
             ("gap n/d", lambda g: g is None)]
    intest = "  %-20s %7s" % ("FASCIA", "n")
    for c in ORDINE_CLASSI:
        intest += " %10s" % c
    out.append(intest)
    for nome, prova in fasce:
        gg = [x for x in buoni if prova(x.get("gap_pct"))]
        riga = "  %-20s %7d" % (nome, len(gg))
        for c in ORDINE_CLASSI:
            n = len([x for x in gg if x["classe"] == c])
            riga += " %5d/%4s" % (n, pct(n, len(gg), 0))
        out.append(riga)
    tutti = [x["gap_pct"] for x in buoni if x.get("gap_pct") is not None]
    ass = [abs(v) for v in tutti]
    out.append("  gap mediano %s%%   |gap| mediano %s%%   |gap| Q3 %s%%   n=%d" %
               (f(mediana(tutti)), f(mediana(ass)), f(quantile(ass, 0.75)), len(tutti)))
    out.append("")
    return out


def quota_sospetti_anno(righe):
    """anno -> (giorni, buoni, sospetti, senza apertura, quota%).

    LA QUOTA HA UN DENOMINATORE, E VA DETTO QUAL E': sospetti sui giorni
    MISURABILI (buoni + sospetti), NON sui giorni di calendario. I giorni
    SENZA APERTURA sono feste e domeniche del feed 24h: contarli sotto
    farebbe scendere la quota proprio negli anni con piu' buchi. Il
    referto stampa la formula accanto alla colonna, o il numero si legge
    per quello che non e' (checklist 83)."""
    anni = {}
    for r in righe:
        anni.setdefault(r.get("anno"), []).append(r)
    fuori = []
    for anno in sorted(k for k in anni.keys() if k is not None):
        gg = anni[anno]
        buoni = len([x for x in gg if x.get("stato") == "OK" and x.get("classe")])
        sosp = len([x for x in gg if x.get("stato") == "SOSPETTO"])
        noap = len([x for x in gg if x.get("stato") == "SENZA_APERTURA"])
        misurabili = buoni + sosp
        quota = (100.0 * sosp / misurabili) if misurabili else None
        fuori.append((anno, len(gg), buoni, sosp, noap, quota))
    return fuori


def rilievi_quota(cfg, righe):
    """I RILIEVI SULLA QUOTA DEI SOSPETTI, IN UN POSTO SOLO.

    Esiste come funzione a se' perche' questi rilievi devono finire in DUE
    posti che prima divergevano: il testo del referto E il CODICE
    D'USCITA. Prima nascevano dentro blocco_copertura, cioe' dentro UN
    referto, e il codice d'uscita non li vedeva mai: un anno al 38,7% di
    giorni malati usciva 0 = 'ESITO: OK' mentre il referto scriveva
    'MISURATO CON RILIEVI'. Le due cose non possono divergere
    (checklist 14 e 22)."""
    fuori = []
    for anno, _gg, _buoni, _sosp, _noap, quota in quota_sospetti_anno(righe):
        if quota is not None and quota > cfg.quota_sospetti:
            fuori.append("anno %d: %s%% di giorni sospetti (soglia %.1f%%)" %
                         (anno, f(quota, 1), cfg.quota_sospetti))
    return fuori


def blocco_copertura(cfg, righe, diag, titolo):
    out = [titolo]
    out.append("  Il conto della malattia: quanti giorni sono stati ESCLUSI e perche'.")
    out.append("  %6s %8s %8s %10s %10s %12s" %
               ("ANNO", "GIORNI", "BUONI", "SOSPETTI", "NO-APERT", "%SOSPETTI"))
    for anno, tot, buoni, sosp, noap, quota in quota_sospetti_anno(righe):
        out.append("  %6d %8d %8d %10d %10d %12s" %
                   (anno, tot, buoni, sosp, noap, f(quota, 1)))
    out.append("  %SOSPETTI = SOSPETTI / (BUONI + SOSPETTI), cioe' sui giorni")
    out.append("   MISURABILI: NON su GIORNI, che comprende feste e domeniche del")
    out.append("   feed 24h. E' la stessa quota su cui morde --quota-sospetti.")
    out.append("")
    out.append("  I giorni SENZA APERTURA, per giorno della settimana. Le domeniche e")
    out.append("  le feste di borsa stanno LEGITTIMAMENTE in quel conto (il feed e' 24h")
    out.append("  e la domenica sera ha barre, ma non ha un'apertura cash); un mucchio")
    out.append("  di giorni INFRASETTIMANALI li' dentro sarebbe invece un buco di feed.")
    conta_dow = {}
    for r in righe:
        if r.get("stato") == "SENZA_APERTURA":
            d = r.get("giorno_sett", "?")
            conta_dow[d] = conta_dow.get(d, 0) + 1
    if not conta_dow:
        out.append("    nessuno")
    for d in ["lun", "mar", "mer", "gio", "ven", "sab", "dom"]:
        if d in conta_dow:
            out.append("    %-6s %6d" % (d, conta_dow[d]))
    infra = sum(conta_dow.get(d, 0) for d in ("lun", "mar", "mer", "gio", "ven"))
    out.append("    -> infrasettimanali senza apertura: %d (feste di borsa + eventuali" % infra)
    out.append("       buchi di feed: qui NON si distinguono, e va detto)")
    out.append("")
    out.append("  I MOTIVI dei giorni sospetti (un giorno puo' averne piu' d'uno):")
    conta = {}
    for r in righe:
        if r.get("stato") != "SOSPETTO":
            continue
        for pezzo in (r.get("motivo") or "").split(" - "):
            pezzo = pezzo.strip()
            if not pezzo:
                continue
            # si raggruppa per FAMIGLIA, non per numero esatto
            if pezzo.startswith("copertura oraria"):
                pezzo = "copertura oraria sotto la soglia"
            elif pezzo.startswith("buco di"):
                pezzo = "buco interno oltre la soglia"
            elif pezzo.startswith("apertura non osservata"):
                pezzo = "barra d'apertura mancante"
            conta[pezzo] = conta.get(pezzo, 0) + 1
    if not conta:
        out.append("    nessuno")
    for k in sorted(conta.keys()):
        out.append("    %-45s %6d" % (k, conta[k]))
    out.append("")
    out.append("  righe del file scartate (formato/OHLC incoerente): %d" % diag["scartate"])
    out.append("  barre duplicate nella finestra d'apertura (tenuta la prima): %d" % diag["duplicate"])
    out.append("  righe FUORI ORDINE cronologico: %d" % diag["fuori_ordine"])
    out.append("  date che ricompaiono dopo essere gia' state chiuse: %d" % diag["date_ripetute"])
    out.append("  (l'ordinamento del file e' un'ASSUNZIONE e qui viene MISURATA. Le")
    out.append("   barre della finestra d'apertura sono indicizzate per MINUTO, che e'")
    out.append("   una chiave unica: nessun riordino alla cieca, nessun pari da")
    out.append("   sciogliere.)")
    out.append("")
    return out


def costruisci_referto(cfg, righe, diag, percorso_dati, titolo, note_fase,
                       righe_fuso, con_copertura=True):
    r = testata(cfg, titolo, percorso_dati, diag, note_fase)
    r += righe_fuso
    r.append("")
    r += blocco_definizioni(cfg)
    if con_copertura:
        r += blocco_copertura(cfg, righe, diag, "--- COPERTURA E GIORNI SOSPETTI ---")
    r += tabella_classi(cfg, righe, "--- DISTRIBUZIONE DELLE CLASSI, PER ANNO ---", "anno")
    r += tabella_classi(cfg, righe, "--- DISTRIBUZIONE DELLE CLASSI, PER REGIME DICHIARATO ---", "regime")
    r += tabella_mfe_per_classe(cfg, righe, "--- ESCURSIONI MEDIANE PER CLASSE ---")
    r += tabella_finestre(cfg, righe, "--- IL MOVIMENTO GREZZO, FINESTRA PER FINESTRA ---")
    r += tabella_persistenza(cfg, righe, "--- PERSISTENZA ---")
    r += tabella_gap(cfg, righe, "--- LE CLASSI CONDIZIONATE AL GAP ---")
    return r


# =====================================================================
#  AUTOTEST -- giornate SINTETICHE costruite a mano, coi conteggi attesi
#  scritti qui dentro. Nessun file vero, nessuna rete.
# =====================================================================
def _barre_giorno(giorno, prezzi, apertura_min=570):
    """prezzi = lista di (offset, o,h,l,c) rispetto all'apertura."""
    righe = []
    for off, o, h, l, c in prezzi:
        m = apertura_min + off
        righe.append("%s %02d:%02d,%.6f,%.6f,%.6f,%.6f,0" %
                     (giorno, m // 60, m % 60, o, h, l, c))
    return righe


def _riempi(base, da, a, passo=0.0, ampiezza=1.0):
    """Barre 'tranquille' che oscillano di +/- ampiezza attorno a una
    retta che sale di `passo` al minuto."""
    fuori = []
    for off in range(da, a + 1):
        p = base + passo * off
        fuori.append((off, p, p + ampiezza, p - ampiezza, p))
    return fuori


def autotest():
    log("=== AUTOTEST %s (offline, nessun file vero) ===" % VERSIONE)
    ok = 0

    class A(object):
        pass

    a = A()
    a.ora_apertura = "09:30"
    a.ora_chiusura = "16:00"
    a.minuti_pre = 60
    a.finestre = "5,15,30,60"
    a.finestra_classe = 15
    a.finestra_giudizio = 60
    a.k_margine = 0.10
    a.pavimento_pct = 0.02
    a.deadband_pct = 0.05
    a.min_barre_ora = 55
    a.max_buco_min = 3
    a.min_barre_pre = 30
    a.cassaforte_da = 2021
    a.quota_sospetti = 20.0
    a.min_giorni_anno = 150
    cfg = Config(a)
    assert not cfg.problemi_config, cfg.problemi_config
    log("1. configurazione di default coerente: OK")
    log("   apertura %s NY = %s server = %s italiana" %
        (hhmm(cfg.apertura), hhmm(cfg.apertura + 300), hhmm(cfg.apertura + 360)))
    ok += 1

    # ---- la CLASSIFICAZIONE, provata sulla funzione pura, caso per caso
    # range di riferimento 100-110, margine 1.0
    casi = [
        # (hi_post, lo_post, chiusura, classe attesa, due lati attesi)
        (115.0, 105.0, 114.0, "DRIVE-UP", 0),
        (105.0, 95.0, 96.0, "DRIVE-DOWN", 0),
        (115.0, 95.0, 96.0, "FADE-UP", 1),
        (115.0, 95.0, 114.0, "FADE-DOWN", 1),
        (110.5, 99.5, 105.0, "RANGE", 0),
        (115.0, 105.0, 105.0, "RIENTRO", 0),
    ]
    for hp, lp, cl, atteso, due in casi:
        c, d, _u, _g = classifica(110.0, 100.0, hp, lp, cl, 1.0)
        assert c == atteso, (hp, lp, cl, c, atteso)
        assert d == due, (hp, lp, cl, d, due)
    log("2. cascata di classificazione, 6 casi su 6 (compresi i DUE LATI): OK")
    ok += 1

    # ---- QUATTRO GIORNATE SINTETICHE, coi conteggi attesi scritti
    #  G1 2015.03.02 lunedi : DRIVE-UP perfetto
    #  G2 2015.03.03 martedi: FADE-UP perfetto (rompe su, chiude sotto)
    #  G3 2015.03.04 mercoledi: RANGE perfetto
    #  G4 2015.03.05 giovedi: BUCATO (solo 20 barre nell'ora) -> SOSPETTO
    righe = []
    righe.append("Time,Open,High,Low,Close,Volume")

    # chiusura cash del venerdi precedente, per il gap di G1
    righe.append("2015.02.27 15:59,1000.000000,1000.500000,999.500000,1000.000000,0")

    # G1: apre a 1002 (gap +0,2%), sale piano nei primi 15' (direzione SU
    #     dichiarata) e poi sale dritto fino a 1020: DRIVE-UP che PERSISTE
    p = []
    p += _riempi(1002.0, 0, 14, passo=0.1, ampiezza=1.0)
    for off in range(15, 60):
        base = 1002.0 + (off - 14) * 0.4
        p.append((off, base, base + 0.5, base - 0.5, base))
    righe += _barre_giorno("2015.03.02", p)
    righe.append("2015.03.02 15:59,1020.000000,1020.500000,1019.500000,1020.000000,0")

    # G2: apre a 1020, sale nei primi 15' (direzione SU), rompe ancora su
    #     fino a 1026, poi crolla e chiude sotto il minimo dei 15':
    #     FADE-UP che NON persiste
    p = []
    p += _riempi(1020.0, 0, 14, passo=0.1, ampiezza=1.0)
    for off in range(15, 30):
        base = 1021.0 + (off - 14) * 0.35
        p.append((off, base, base + 0.3, base - 0.3, base))
    for off in range(30, 60):
        base = 1026.0 - (off - 29) * 0.55
        p.append((off, base, base + 0.3, base - 0.3, base))
    righe += _barre_giorno("2015.03.03", p)
    righe.append("2015.03.03 15:59,1010.000000,1010.500000,1009.500000,1010.000000,0")

    # G3: apre a 1010, oscilla dentro 1008-1012 per un'ora: RANGE
    p = _riempi(1010.0, 0, 59, passo=0.0, ampiezza=2.0)
    righe += _barre_giorno("2015.03.04", p)
    righe.append("2015.03.04 15:59,1010.000000,1010.500000,1009.500000,1010.000000,0")

    # G4: il giorno BUCATO: solo 20 barre (0-19), il resto non c'e'
    p = _riempi(1010.0, 0, 19, passo=0.05, ampiezza=1.0)
    righe += _barre_giorno("2015.03.05", p)

    percorso = os.path.join(_cartella_tmp(), "autotest_anatomia.csv")
    scrivi_atomico(percorso, righe)

    forma, prima = riconosci_formato(percorso)
    assert forma == "FORMATO1", (forma, prima)
    log("3. riconoscimento del formato del file (FORMATO1): OK")
    ok += 1

    fuori, diag = scandisci(cfg, percorso, ogni=0)
    per_data = {}
    for r in fuori:
        per_data[r["data"]] = r
    assert "2015.03.02" in per_data, sorted(per_data.keys())
    g1 = per_data["2015.03.02"]
    g2 = per_data["2015.03.03"]
    g3 = per_data["2015.03.04"]
    g4 = per_data["2015.03.05"]
    assert g1["classe"] == "DRIVE-UP", g1["classe"]
    assert g2["classe"] == "FADE-UP", g2["classe"]
    assert g3["classe"] == "RANGE", g3["classe"]
    assert g1["stato"] == "OK" and g2["stato"] == "OK" and g3["stato"] == "OK", \
        (g1["stato"], g2["stato"], g3["stato"])
    log("4. tre giornate sintetiche classificate DRIVE-UP / FADE-UP / RANGE: OK")
    ok += 1

    assert g4["stato"] == "SOSPETTO", g4["stato"]
    assert "copertura oraria" in g4["motivo"], g4["motivo"]
    assert g4["barre_ora"] == 20, g4["barre_ora"]
    log("5. il giorno BUCATO (20 barre su 60) esce SOSPETTO ed e' escluso: OK")
    log("   motivo scritto: " + g4["motivo"])
    ok += 1

    buoni = [r for r in fuori if r["stato"] == "OK" and r["classe"]]
    sospetti = [r for r in fuori if r["stato"] == "SOSPETTO"]
    assert len(buoni) == 3, [(r["data"], r["stato"], r["classe"]) for r in fuori]
    assert len(sospetti) == 1, len(sospetti)
    log("6. conteggi attesi: 3 giorni buoni + 1 sospetto -> misurati %d + %d: OK" %
        (len(buoni), len(sospetti)))
    ok += 1

    # il GAP di G1: apre 1002 contro chiusura 1000 del 27/02 = +0,2%
    assert g1["data_chiusura_prec"] == "2015.02.27", g1["data_chiusura_prec"]
    assert abs(g1["gap_pct"] - 0.2) < 0.0001, g1["gap_pct"]
    log("7. gap letto dalla chiusura cash del giorno di borsa prima (+0.200%): OK")
    ok += 1

    # le escursioni di G1: massimo 1020.5 -> +1,847%
    su60 = g1["fin"][60]["up_pct"]
    assert 1.83 < su60 < 1.86, su60
    assert g1["fin"][5]["up_pct"] > 0, g1["fin"][5]["up_pct"]
    assert g1["persiste"] == 1, g1["persiste"]
    assert g2["persiste"] == 0, g2["persiste"]
    log("8. escursione a 60' di G1 = %s%% e persistenza SU=1 / FADE=0: OK" % f(su60))
    ok += 1

    # regime e fase
    assert g1["regime"] == "2010-2019" and g1["fase"] == "IS", (g1["regime"], g1["fase"])
    assert regime_di(2020) == "2020_covid" and regime_di(2022) == "2022_orso"
    log("9. etichette di regime e di fase (IS / CASSAFORTE): OK")
    ok += 1

    # il CSV: nessun campo di testo con una virgola dentro
    testa = intestazione_csv(cfg)
    for r in fuori:
        campi = riga_csv(cfg, r).split(",")
        assert len(campi) == len(testa), (len(campi), len(testa), r["data"])
    log("10. CSV per-giorno: %d colonne, tutte le righe le rispettano: OK" % len(testa))
    ok += 1

    # il file dell'ALTRO gemello NON deve passare per FORMATO1
    # (checklist 83: si prova col formato sbagliato, non solo col giusto)
    grezzo = os.path.join(_cartella_tmp(), "autotest_grezzo.csv")
    scrivi_atomico(grezzo, ["20120201 000000;1.306600;1.306600;1.306560;1.306560;0",
                            "20120201 000100;1.306570;1.306570;1.306470;1.306560;0"])
    forma2, _ = riconosci_formato(grezzo)
    assert forma2 == "HISTDATA_GREZZO", forma2
    log("11. un CSV nel formato HistData GREZZO viene riconosciuto come tale")
    log("    (e NON scambiato per 'file mancante'): OK")
    ok += 1

    # il canarino del fuso, provato NEI DUE VERSI (checklist 55): un
    # canarino che non puo' diventare rosso non e' un canarino.
    diag_finto = {"gap_sessione": {}, "apertura_sett": {}}
    for mese in (1, 7):
        for g in range(1, 16):
            diag_finto["gap_sessione"].setdefault((2015, mese), []).append(17 * 60)
            diag_finto["apertura_sett"].setdefault((2015, mese), []).append(18 * 60)
    testo, ril = canarino_fuso(diag_finto)
    assert ril == [], ril
    assert any("NEW YORK" in x for x in testo)
    diag_est = {"gap_sessione": {}, "apertura_sett": {}}
    for mese, ora in ((1, 17 * 60), (7, 16 * 60)):
        for g in range(1, 16):
            diag_est["gap_sessione"].setdefault((2015, mese), []).append(ora)
            diag_est["apertura_sett"].setdefault((2015, mese), []).append(ora + 60)
    _t2, ril2 = canarino_fuso(diag_est)
    assert any("EST FISSO" in x for x in ril2), ril2
    # tutte e due le misure si sono mosse: il rilievo deve DIRLO, non
    # ridursi a quello dell'ultima misura letta
    assert any("TUTTE E DUE" in x for x in ril2), ril2
    # e una misura sola che si muove NON deve diventare "e' il fuso"
    diag_meta = {"gap_sessione": {}, "apertura_sett": {}}
    for mese, ora in ((1, 17 * 60), (7, 16 * 60)):
        for g in range(1, 16):
            diag_meta["gap_sessione"].setdefault((2015, mese), []).append(ora)
            diag_meta["apertura_sett"].setdefault((2015, mese), []).append(18 * 60)
    _t3, ril3 = canarino_fuso(diag_meta)
    assert any("EST FISSO" in x for x in ril3), ril3
    assert not any("TUTTE E DUE" in x for x in ril3), ril3
    log("12. canarino del fuso provato nei DUE versi: DST -> nessun rilievo;")
    log("    EST fisso -> RILIEVO; e UNA misura sola non diventa 'e' il fuso': OK")
    ok += 1

    # ---- IL RILIEVO SULLA QUOTA DEI SOSPETTI DEVE ESISTERE COME FATTO
    #      SEPARATO DAL TESTO DEL REFERTO. Se vive solo dentro un referto,
    #      il codice d'uscita non lo vede: e' il difetto trovato in
    #      verifica (un anno al 38,7% usciva "ESITO: OK").
    finti = []
    for i in range(100):
        finti.append({"anno": 2016, "stato": "OK", "classe": "RANGE"})
    for i in range(40):
        finti.append({"anno": 2016, "stato": "SOSPETTO", "classe": ""})
    for i in range(300):
        finti.append({"anno": 2017, "stato": "SENZA_APERTURA", "classe": ""})
    for i in range(100):
        finti.append({"anno": 2017, "stato": "OK", "classe": "RANGE"})
    ril_q = rilievi_quota(cfg, finti)
    assert len(ril_q) == 1 and "2016" in ril_q[0], ril_q
    # il 2017 NON deve suonare: ha 0 sospetti su 100 misurabili, e le 300
    # giornate senza apertura non entrano nel denominatore
    assert "2017" not in " ".join(ril_q), ril_q
    tab = quota_sospetti_anno(finti)
    assert tab[0][5] is not None and abs(tab[0][5] - 100.0 * 40 / 140) < 0.001, tab[0]
    assert tab[1][5] == 0.0, tab[1]
    log("13. quota dei sospetti: 40/140 = %.1f%% -> RILIEVO che arriva al CODICE" %
        tab[0][5])
    log("    D'USCITA (e le 300 giornate senza apertura NON diluiscono): OK")
    ok += 1

    for tmp in (percorso, grezzo):
        try:
            os.remove(tmp)
        except OSError:
            pass

    log("")
    log("AUTOTEST: %d/%d prove superate." % (ok, 13))
    return 0 if ok == 13 else 2


def _cartella_tmp():
    import tempfile
    return tempfile.gettempdir()


# =====================================================================
#  MAIN
# =====================================================================
def main():
    ap = argparse.ArgumentParser(
        description="Anatomia descrittiva delle aperture (FASE 1). "
                    "NON e' un backtest: niente PF, niente equity.")
    ap.add_argument("--file", default="",
                    help="il CSV Formato 1 (Time,Open,High,Low,Close,Volume)")
    ap.add_argument("--simbolo", default="NASUSD", help="solo per i nomi dei file prodotti")
    ap.add_argument("--uscita", default="", help="cartella dove scrivere CSV e referti")
    ap.add_argument("--autotest", action="store_true",
                    help="giornate sintetiche coi conteggi attesi. Niente file vero.")
    ap.add_argument("--ora-apertura", dest="ora_apertura", default=DEF_ORA_APERTURA)
    ap.add_argument("--ora-chiusura", dest="ora_chiusura", default=DEF_ORA_CHIUSURA)
    ap.add_argument("--minuti-pre", dest="minuti_pre", type=int, default=DEF_MINUTI_PRE)
    ap.add_argument("--finestre", default=DEF_FINESTRE)
    ap.add_argument("--finestra-classe", dest="finestra_classe", type=int, default=DEF_FIN_CLASSE)
    ap.add_argument("--finestra-giudizio", dest="finestra_giudizio", type=int,
                    default=DEF_FIN_GIUDIZIO)
    ap.add_argument("--k-margine", dest="k_margine", type=float, default=DEF_K_MARGINE)
    ap.add_argument("--pavimento-pct", dest="pavimento_pct", type=float, default=DEF_PAVIMENTO_PCT)
    ap.add_argument("--deadband-pct", dest="deadband_pct", type=float, default=DEF_DEADBAND_PCT)
    ap.add_argument("--min-barre-ora", dest="min_barre_ora", type=int, default=DEF_MIN_BARRE_ORA)
    ap.add_argument("--max-buco-min", dest="max_buco_min", type=int, default=DEF_MAX_BUCO_MIN)
    ap.add_argument("--min-barre-pre", dest="min_barre_pre", type=int, default=DEF_MIN_BARRE_PRE)
    ap.add_argument("--cassaforte-da", dest="cassaforte_da", type=int, default=DEF_CASSAFORTE_DA)
    ap.add_argument("--quota-sospetti", dest="quota_sospetti", type=float,
                    default=DEF_QUOTA_SOSPETTI)
    ap.add_argument("--min-giorni-anno", dest="min_giorni_anno", type=int,
                    default=DEF_MIN_GIORNI_ANNO)
    args = ap.parse_args()

    log("=====================================================================")
    log(" ANATOMIA DELLE APERTURE -- %s (FASE 1: DESCRITTIVA)" % VERSIONE)
    log("=====================================================================")
    log(" NON e' un backtest: niente profit factor, niente equity, niente")
    log(" motori, niente promozioni. Si contano i fatti dell'apertura.")
    log("")

    if args.autotest:
        return autotest()

    try:
        cfg = Config(args)
    except ValueError as e:
        log("!!! PARAMETRI NON VALIDI: " + str(e))
        return 2
    if cfg.problemi_config:
        log("!!! PARAMETRI INCOERENTI:")
        for p in cfg.problemi_config:
            log("    - " + p)
        return 2

    if not args.file:
        log("!!! MANCA --file: non c'e' niente da leggere.")
        return 2
    percorso = args.file
    if not os.path.exists(percorso):
        log("!!! IL FILE NON ESISTE: " + percorso)
        log("    (questo e' il caso 'il file NON C'E''. E' diverso dal caso 'il file")
        log("     c'e' ma e' in un altro formato': la differenza e' scritta apposta.)")
        return 2
    forma, prima = riconosci_formato(percorso)
    if forma != "FORMATO1":
        log("!!! IL FILE C'E' MA NON E' NEL FORMATO GIUSTO: " + percorso)
        log("    formato riconosciuto: " + forma)
        log("    prima riga di dati  : " + str(prima)[:120])
        log("    Atteso il 'Formato 1' di histdata_m1.py --converti:")
        log("      Time,Open,High,Low,Close,Volume")
        log("      2010.11.14 18:01,2135.000000,2135.000000,2134.500000,2134.500000,0")
        if forma == "HISTDATA_GREZZO":
            log("    Questo e' il formato HistData GREZZO che scrive")
            log("    importa_storico_esterno.ps1: e' un ALTRO file con lo stesso nome.")
            log("    Serve quello prodotto da histdata_m1.py --converti.")
        log("    NON e' un file mancante: e' il file sbagliato. Non riscaricare a vuoto.")
        return 2

    cartella = args.uscita or os.path.dirname(os.path.abspath(percorso))
    if not os.path.isdir(cartella):
        os.makedirs(cartella, exist_ok=True)

    # ####################################################################
    #  IL VERSACCIO NOTO: passare l'ORA SERVER al posto dell'ora del file.
    #  I referti d'import parlano in ORA SERVER, il CSV e' in ORA NEW YORK,
    #  e le due si somigliano abbastanza da non accorgersene. Chi passasse
    #  14:30 misurerebbe il PRIMO POMERIGGIO di New York e otterrebbe
    #  numeri perfettamente plausibili -- che e' il caso peggiore.
    #  Niente qui dentro puo' sapere cosa VOLEVA l'utente: quello che si
    #  puo' fare e' NON lasciarlo passare in silenzio.
    # ####################################################################
    avviso_ora = None
    if args.ora_apertura.strip() != DEF_ORA_APERTURA:
        avviso_ora = ("--ora-apertura vale %s invece del default %s. L'ora di "
                      "questo CSV e' ORA DI NEW YORK: se il numero e' stato preso "
                      "da un referto in ORA SERVER, il bersaglio e' sbagliato di "
                      "cinque ore e i risultati saranno PLAUSIBILI lo stesso."
                      % (args.ora_apertura.strip(), DEF_ORA_APERTURA))
        log("!!! ATTENZIONE: " + avviso_ora)
        log("    (apertura cash Nasdaq = 09:30 New York = 14:30 server BCM =")
        log("     15:30 italiana. Il file e' in ora NEW YORK.)")
        log("")

    log(" file      : " + percorso)
    log(" formato   : FORMATO1 (verificato aprendolo, non dal nome)")
    log(" apertura  : %s ora del file = NEW YORK = %s server BCM = %s italiana" %
        (hhmm(cfg.apertura), hhmm(cfg.apertura + 300), hhmm(cfg.apertura + 360)))
    log(" finestre  : " + ",".join(str(w) for w in cfg.finestre) +
        "   classe su %d'   giudizio su %d'" % (cfg.fin_classe, cfg.fin_giudizio))
    log(" uscita in : " + cartella)
    log("")
    log(" lettura in STREAMING (una passata, aggregati del solo giorno in corso):")
    log(" la RAM non cresce con la lunghezza del file. Attesa: qualche decina di")
    log(" secondi su 5,2 milioni di barre.")
    log("")

    righe, diag = scandisci(cfg, percorso)
    if diag["barre"] == 0:
        log("!!! ZERO BARRE LETTE dal file (che pero' esiste ed e' in Formato 1).")
        log("    Non e' un file mancante: e' un file senza dati utilizzabili.")
        return 2

    log(" barre lette: %d   giorni di calendario: %d" % (diag["barre"], diag["giorni"]))
    buoni = [r for r in righe if r.get("stato") == "OK" and r.get("classe")]
    sosp = [r for r in righe if r.get("stato") == "SOSPETTO"]
    noap = [r for r in righe if r.get("stato") == "SENZA_APERTURA"]
    log(" giorni BUONI %d   SOSPETTI %d   SENZA APERTURA %d" %
        (len(buoni), len(sosp), len(noap)))

    righe_fuso, rilievi_fuso = canarino_fuso(diag)
    for x in righe_fuso:
        log("  " + x)

    rilievi = []
    if avviso_ora:
        rilievi.append(avviso_ora)
    rilievi += rilievi_fuso
    #  I RILIEVI SULLA QUOTA DEI SOSPETTI SI CALCOLANO **QUI**, sui giorni
    #  di TUTTO il file, e finiscono nella stessa lista che decide il
    #  CODICE D'USCITA. Prima nascevano dentro il singolo referto e il
    #  codice d'uscita non li vedeva mai: un anno al 38,7% di giorni
    #  malati usciva 0 (= "ESITO: OK" anche nel referto del driver e
    #  niente giallo in chat) mentre il referto scriveva "MISURATO CON
    #  RILIEVI". Il testo e il codice d'uscita non possono divergere
    #  (checklist 22), e un cancello che non puo' alzare il codice e' un
    #  cancello decorativo (checklist 14).
    rilievi += rilievi_quota(cfg, righe)
    if diag["fuori_ordine"] > 0:
        rilievi.append("%d righe FUORI ORDINE cronologico nel file: dichiarato, non "
                       "riordinato alla cieca" % diag["fuori_ordine"])
    if diag["date_ripetute"] > 0:
        rilievi.append("%d date ricompaiono dopo essere gia' state chiuse: il file non "
                       "e' raggruppato per giornata" % diag["date_ripetute"])
    if not buoni:
        rilievi.append("NESSUN giorno buono: non c'e' niente da distribuire")

    # ---- il CSV per-giorno
    nome_csv = "ANATOMIA_APERTURE_PERGIORNO_%s.csv" % args.simbolo
    percorso_csv = os.path.join(cartella, nome_csv)
    fuori_csv = [",".join(intestazione_csv(cfg))]
    for r in righe:
        fuori_csv.append(riga_csv(cfg, r))
    scrivi_atomico(percorso_csv, fuori_csv)
    log("")
    log(" CSV per-giorno: %s  (%d righe di dati)" % (percorso_csv, len(righe)))

    # ---- i TRE referti
    is_righe = [r for r in righe if r.get("fase") == "IS"]
    cs_righe = [r for r in righe if r.get("fase") == "CASSAFORTE"]
    anni_is = sorted(set(r["anno"] for r in is_righe if r.get("anno")))
    anni_cs = sorted(set(r["anno"] for r in cs_righe if r.get("anno")))

    prodotti = []
    blocchi = []
    if is_righe:
        nota = ("QUESTO E' IL FILE DELL'ADDESTRAMENTO (%d-%d): le ipotesi di motore "
                "si scrivono QUI e SOLO QUI." % (anni_is[0], anni_is[-1]))
        titolo = ("ANATOMIA DELLE APERTURE -- %s -- ADDESTRAMENTO %d-%d" %
                  (args.simbolo, anni_is[0], anni_is[-1]))
        nome = "ANATOMIA_APERTURE_IS_%d_%d.txt" % (anni_is[0], anni_is[-1])
        blocchi.append((nome, titolo, nota, is_righe))
    else:
        rilievi.append("nessun anno nella finestra d'addestramento: referto IS non prodotto")
    if cs_righe:
        nota = ("QUESTA E' LA CASSAFORTE (%d-%d). NON SI GUARDA per costruire ipotesi: "
                "serve a validarle DOPO che sono state congelate." % (anni_cs[0], anni_cs[-1]))
        titolo = ("ANATOMIA DELLE APERTURE -- %s -- CASSAFORTE %d-%d  [NON PER LE IPOTESI]" %
                  (args.simbolo, anni_cs[0], anni_cs[-1]))
        nome = "ANATOMIA_APERTURE_CASSAFORTE_%d_%d.txt" % (anni_cs[0], anni_cs[-1])
        blocchi.append((nome, titolo, nota, cs_righe))
    else:
        rilievi.append("nessun anno nella cassaforte: referto CASSAFORTE non prodotto")
    blocchi.append(("ANATOMIA_APERTURE_COMPLETO.txt",
                    "ANATOMIA DELLE APERTURE -- %s -- TUTTI GLI ANNI (CONTESTO)" % args.simbolo,
                    "QUESTO E' IL FILE DI CONTESTO: mescola addestramento e cassaforte. "
                    "Serve a leggere la storia, NON a scrivere ipotesi.",
                    righe))

    for nome, titolo, nota, sotto in blocchi:
        testo = costruisci_referto(cfg, sotto, diag, percorso, titolo, nota, righe_fuso)
        testo.append("--- RILIEVI DI QUESTA CORSA ---")
        #  la STESSA lista in tutti e tre i referti, ed e' la stessa che
        #  decide il codice d'uscita: cosi' il conto scritto in fondo al
        #  referto e il numero che legge la riga di lancio non possono
        #  raccontare due storie diverse.
        if not rilievi:
            testo.append("  nessuno")
        for x in rilievi:
            testo.append("  - " + x)
        testo.append("")
        testo.append("--- QUELLO CHE QUESTO STUDIO NON PUO' DIRE ---")
        testo.append("  Non dice se un motore guadagnerebbe: non ci sono spread, non ci")
        testo.append("  sono fill, non ci sono costi, non c'e' una posizione. Una classe")
        testo.append("  frequente NON e' un edge: e' una frequenza.")
        testo.append("  Non dice niente su DAX e Dow: qui c'e' un simbolo solo.")
        testo.append("  Non sostituisce il cancello qualita' del feed, che e' in verifica.")
        testo.append("")
        testo.append("ESITO: " + ("OK" if not rilievi else
                                  "MISURATO CON RILIEVI (%d)" % len(rilievi)))
        percorso_ref = os.path.join(cartella, nome)
        scrivi_atomico(percorso_ref, testo)
        prodotti.append(percorso_ref)
        log(" referto: " + percorso_ref)

    picco = ram_picco_mb()
    log("")
    log(" RAM di picco del processo: %s" %
        ("non misurabile su questa macchina" if picco is None else "%.0f MB" % picco))
    log(" (letta in streaming: NON cresce con la lunghezza del file. Il metro di")
    log("  casa dei 690 byte/barra vale per chi tiene tutte le barre in memoria,")
    log("  cioe' histdata_m1.py --converti, non per questo strumento.)")

    log("")
    log(" FILE PRODOTTI (elenco dal codice, non scritto a mano):")
    for p in [percorso_csv] + prodotti:
        log("   " + os.path.basename(p))
    log("")
    if rilievi:
        log(" ESITO: MISURATO CON RILIEVI -- %d. Gli artefatti CI SONO e vanno" % len(rilievi))
        log(" mandati lo stesso: un rilievo e' gia' una risposta.")
        for x in rilievi:
            log("   - " + x)
        return 1
    log(" ESITO: OK")
    return 0


if __name__ == "__main__":
    sys.exit(main())
