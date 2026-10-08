#!/usr/bin/env python3
"""
analizza_trades.py — la pagella giornaliera dal CSV del TradeExporter.

Legge  data/statements/trades_auto.csv  (che l'EA ABTG_TradeExporter scrive
in Common\\Files e pubblica_trades.ps1 carica nel repo) e produce il report
di giornata in  report/giornata_AAAA-MM-GG.md.

Nasce dal 03/08/2026: quel giorno cinque operazioni hanno insegnato più di
una settimana di backtest, ma le ho ricostruite a mano da cinque screenshot.
Questo script fa lo stesso lavoro da solo, tutti i giorni.

Uso:
    python3 backtest_pipeline/analizza_trades.py            # ultimo giorno con trade
    python3 backtest_pipeline/analizza_trades.py 2026-08-03 # un giorno preciso
"""
import csv, sys, os, subprocess
from collections import defaultdict
from datetime import datetime, timedelta, date

CSV_IN  = "data/statements/trades_auto.csv"
OUT_DIR = "report"

# --- pagella DOPPIA (HANDOFF 0-ter, 11/08): il secondo CSV e' il conto
#     100k del dry-run FTMO (50504263). Lo scrive il TradeExporter sul -V3
#     (InpFile=ABTG_Trades_100k.csv) e lo pubblica pubblica_trades.ps1.
CSV_100K  = "data/statements/trades_100k.csv"
DEP_100K  = 100000.0
# --- 05/10/2026: la FONTE VIVA per separare "non ha operato" da "il dato non e'
#     arrivato", senza toccare il .chr (che e' una foto al salvataggio del
#     profilo, non lo stato corrente -- classe 834).
#     Il runner delle 03:30 scrive ogni notte CODA_09, il "giornale operativo":
#     per ogni terminale elenca i GIORNI in cui MT5 ha scritto un log Esperti
#     (MT5 ne scrive uno solo per i giorni in cui gira con EA attaccati) e
#     quante righe di ordine/deal c'erano. Se per un conto l'ultimo giorno di
#     log e' vecchio, su quel terminale NESSUN EA ha operato da allora.
#     🔴 E il limite va detto con il numero: la sonda delle 03:30 di oggi NON
#     puo' coprire la seduta di oggi (la vedra' la corsa di domani notte).
CODA_REFERTI = os.path.join("backtest_pipeline", "coda", "referti")
# La clausola di validita' e' scritta nel referto che leggiamo e va tradotta in
# un `if`, non lasciata in prosa (classe 1142): "'RIGHE DI ORDINE/DEAL = 0' su un
# log NON vuoto vuol dire che quel giorno il conto non ha operato. Su un log
# QUASI VUOTO non vuol dire niente: il giorno e' appena cominciato (classe 162)".
SOGLIA_LOG_PIENO = 20   # righe totali: sotto questo il log non dice niente
# 🔴 E l'assenza di un log NON dice che il conto non ha operato: dice che quel
#    TERMINALE non e' girato con EA attaccati (spento, o senza EA). Le due
#    ipotesi producono la STESSA evidenza, quindi il silenzio non discrimina
#    (classe 1141). Per dire che non ha operato servono fonti VIVE in quella
#    finestra: la sospensione delle sedie e `rischioAperto=0.00%` del Guardian.


# L'ora a cui il CSV viene pubblicato, DETTA IN ORA SERVER, e NON cablata.
# BCM e' UTC+1 FISSO (correzione del 24/09), l'Italia fa l'ora legale: quindi
# d'ESTATE le 22:45 italiane di `pubblica_trades.ps1` sono le 21:45 server,
# d'INVERNO sono le 22:45. Dal 25/10/2026 una stringa cablata stamperebbe il
# falso **dentro la challenge**, ed e' il motivo per cui questa funzione esiste.
# 🔴 L'orologio di QUESTA macchina non serve (il container gira in UTC, il
# task gira sul VPS): l'ora legale italiana si ricava dalla DATA, con la regola
# che la fa — dall'ultima domenica di marzo all'ultima domenica di ottobre.
def _ultima_domenica(anno, mese):
    """Ultima domenica del mese. Usata solo per marzo e ottobre (ora legale):
    la guardia c'e' perche' un `None` silenzioso qui diventerebbe un orario
    sbagliato in un rilevatore di allarmi."""
    assert mese in (3, 10), "ora legale: servono solo marzo e ottobre"
    d = date(anno, mese, 31)
    while d.weekday() != 6:
        d -= timedelta(days=1)
    return d


def _ora_pubblicazione_server_hhmm(giorno_iso):
    """Il DATO, non la frase: '21:45' d'estate, '22:45' d'inverno, None se la
    data non e' valida. Separato dal testo per umani di proposito: una soglia
    che si ricava con un substring-match su una frase cambia in silenzio il
    giorno in cui qualcuno riscrive la frase (e nel verso che fa falsi
    allarmi)."""
    try:
        g = datetime.strptime(giorno_iso, "%Y-%m-%d").date()
    except (ValueError, TypeError):
        return None
    return ("21:45" if _ultima_domenica(g.year, 3) <= g < _ultima_domenica(g.year, 10)
            else "22:45")


def _ora_pubblicazione_server(giorno_iso):
    """La FRASE, per i referti."""
    hh = _ora_pubblicazione_server_hhmm(giorno_iso)
    if hh is None:
        return "22:45 italiane (ora server NON determinata: data non valida)"
    return ("22:45 italiane = **%s ora server** %s"
            % (hh, "(ora legale)" if hh == "21:45"
               else "(inverno: BCM e' UTC+1 fisso)"))


FTMO_PAV_TOTALE = 90000.0   # pavimento statico -10%
FTMO_LIM_GIORNO = 5000.0    # perdita massima giornaliera -5%

# --- pagella TRIPLA (08/09/2026): il terzo CSV e' il CONTO REALE 10105439,
#     l'unico con soldi veri e - fino a oggi - l'unico SENZA pagella.
#     Lo scrivera' il TradeExporter sul terminale C:\BCM_Reale con
#     InpFile=ABTG_Trades_Reale.csv (nome DIVERSO dagli altri due: la
#     Common\Files e' condivisa fra i terminali dello stesso VPS, stesso
#     nome = tre conti che si sovrascrivono a vicenda).
#     Al 08/09/2026 il file NON esiste ancora: la sezione lo dichiara.
CSV_REALE     = "data/statements/trades_reale.csv"
CSV_REALE_MT5 = "ABTG_Trades_Reale.csv"   # nome in Common\Files (input InpFile)

# Colonne senza le quali la sezione del REALE non stampa NIENTE.
# Non e' pignoleria: su un conto vero un totale che salta una colonna e'
# un numero sbagliato, e un numero sbagliato costa soldi.
COLONNE_MINIME = ("open_time", "close_time", "profit", "swap", "commission",
                  "symbol", "strategy", "magic")

# soglie di lettura, dalle regole del progetto
FRAZIONE_BASSA = 0.30   # sotto il 30% del movimento catturato = la gestione taglia troppo presto
DURATA_SOSPETTA = 120   # secondi: sotto = quasi certamente trailing/BE troppo stretti

# --- FUORI DAL TOTALE: le righe a MAGIC 0 del conto piccolo -------
#
# Claudio, 07/09/2026: "sul conto piccolo demo avevo iniziato a farlo manuale.
# Da quando vedi costanza nei commenti, vuol dire che siamo partiti solo con
# EA. I trade senza commenti non li calcolare nel conto piccolo."
#
# MISURATO su trades_auto.csv (30/03 -> 07/09/2026), non assunto:
#   - 661 operazioni hanno  strategy=""  e  magic=0 ;
#   - AL 07/09/2026 la corrispondenza era ESATTA nei due sensi -- zero righe
#     con strategy vuota e magic != 0, zero righe con strategy piena e magic 0
#     -- e da QUELLA misura nacque un filtro che pretendeva ENTRAMBI i criteri.
#   🔴 QUELLA MISURA E' SCADUTA, e il 07/10/2026 ha presentato il conto: dal
#     01/10 esistono righe con strategy PIENA e magic 0 (cinque: 01/10 x1,
#     02/10 x3, 07/10 x1, taglie 1,00-10,00 lotti battute a mano). I due
#     insiemi NON coincidono piu', e il filtro pretendeva l'INTERSEZIONE: il
#     07/10 una riga a mano da 10,00 lotti col commento `reversale su st 3.0`
#     e' restata DENTRO il "Totale giornata", e valeva il 98,3% della giornata
#     (+724,93 su +737,45; flotta vera +12,52).
#   🔴 E la clausola "segnala se un giorno dovessero divergere" E' STATA
#     ONORATA E NON E' BASTATA: il 01/10 e il 02/10 lo strumento LO HA
#     SEGNALATO ("operazioni con commento e magic DISCORDI ... restano nel
#     totale", pid 3537169/3538850/3539766/3545427) e il segnale e' stato
#     letto come "caso da capire", non come "il filtro e' sbagliato".
#     Un avviso che non cambia il numero non e' una guardia: e' una nota.
#     Classe 1174.
#   👉 Dal 07/10/2026 il criterio e' UNO SOLO: `magic == 0` -> fuori.
#     Una premessa misurata su una finestra si RIMISURA, non si eredita.
#   - valgono -18.706,94 EUR contro i -1.235,41 EUR di TUTTA la flotta: se
#     entrano nel totale, il netto del piccolo non e' il netto della flotta.
#   - AL 07/09/2026 l'ULTIMA era del 27/07 e dal 28/07 il conto era solo EA
#     (264 operazioni, tutte con commento): da li' il confine, che era una
#     misura e non una data scelta a mano.
#   🔴 SCADUTA ANCHE QUESTA, e il 07/10/2026 la rimisuro: dal 28/07 il piccolo
#     ha 396 righe, di cui 15 a magic 0 su QUATTRO giornate (01/10 x4,
#     02/10 x9, 06/10 x1, 07/10 x1) e flotta 381. L'ultima a magic 0 e' di
#     OGGI, 07/10 08:32:24. "Il conto e' solo EA" non e' piu' vero dal 01/10.
#   👉 E CAMBIO_SOLO_EA NON si sposta per far tacere l'avviso: non e' una
#     constatazione, e' l'ATTESA (zero manuali da quella data). Spostarlo
#     spegnerebbe l'unico cartello che dice che la mano e' tornata, ed e' il
#     perimetro aperto dal 23/09 -- una firma di Claudio, non una manopola.
#     🟢 E la guardia ha funzionato: stasera il blocco e' comparso ed e' stato
#     guardato. Era la prosa qui sopra a essere vecchia, non il meccanismo.
#
# Non si cancellano: si mostrano FUORI dal totale, come i "RESIDUI SU DISCO"
# del censimento. Un numero che mescola due cose non e' un numero.
CAMBIO_SOLO_EA = "2026-07-28"   # primo giorno senza piu' operazioni manuali


def freschezza(path):
    """Quando il CONTENUTO di questo CSV e' cambiato l'ultima volta nel repo.

    NATO DA UN ERRORE PAGATO (04/09/2026): la pagella ha pubblicato
    "100k: netto di oggi +0,00" mentre il CSV del 100k era fermo al giorno
    prima. Il conto quel giorno aveva fatto **+30,78** (riga gemella della
    `DAX Apertura EU RETEST`, arrivata solo il 05/09 alle 17:32). Fino al
    07/09 la sezione controllava soltanto che il file ESISTESSE: un dato che
    non arriva e uno zero vero venivano stampati **identici**.
    Ricorrenze: 04/09, 07/09, 09/09.

    PERCHE' NON BASTA LA DATA DEL FILE: in un clone fresco tutti i file
    prendono l'ora del checkout, quindi l'mtime direbbe "arrivato adesso"
    anche per un CSV fermo da giorni. La data del commit che l'ha toccato
    per ultimo e' invece un fatto scritto una volta sola. L'mtime resta
    come rete di sicurezza se git non c'e' (e allora la fonte lo dichiara).

    ⚠️ IL LIMITE, dichiarato perche' conta: un CSV che arriva IDENTICO —
    il conto non ha chiuso niente di nuovo — **non lascia traccia in git**.
    Quindi "fermo al giorno X" vuol dire *"da X non arriva CONTENUTO
    NUOVO"*, NON *"la consegna e' rotta"*. Sono due cose diverse e **da qui
    dentro** non si distinguono.
    Ed e' esattamente per questo che il verdetto non e' "zero" ne' "guasto",
    ma **DATO NON ARRIVATO**: dice quello che sappiamo e si ferma li'.

    ✏️ CORRETTO IL 25/09/2026, e la correzione cambia cosa si va a guardare.
    Qui c'era scritto che per distinguerle "serve un timbro scritto DENTRO il
    file dall'esportatore, che oggi non esiste". **Falso**: il timbro non e'
    dentro il file, e' ACCANTO. Sul piccolo 50503392 muto dal 23/09 la
    separazione l'hanno fatta tre referti di SOLA LETTURA gia' scritti dal
    runner delle 03:30 (classe 824): il **log Esperti** giornaliero
    (MQL5\\Logs, non il Giornale del terminale: nessun 20260924 ne' 20260925
    per quella cartella, mentre FTMO/100k/REALE li avevano tutti e due), la
    **data del file** in Common\\Files rispetto ai due gemelli scritti dallo
    stesso EA la stessa notte, e il conteggio dei terminal64 vivi.
    Verdetto vero: **TERMINALE DEL VPS fermo dal 23/09 19:35** — e non "il
    conto", che e' loggato anche sul PC di backtest e resta [NON MISURATO]
    (classe 826: il terminale fermo non e' il conto fermo).
    Referto: report/giornata_2026-09-25.md §1.

    Torna (data 'AAAA-MM-GG' o None, fonte).
    """
    if not os.path.exists(path):
        return None, "assente"
    try:
        # %as = data dell'AUTORE, %cs = data del COMMITTER. Si prende la PIU'
        # VECCHIA delle due, ed e' un difetto pagato: la prima stesura usava
        # solo %cs, e un rebase o un cherry-pick RISCRIVONO quella data a oggi.
        # Su un timbro di freschezza vuol dire falso VERDE — il fallimento
        # peggiore possibile, quello silenzioso e nella direzione che
        # rassicura. Questo progetto sposta lavoro fra branch di continuo.
        p = subprocess.run(["git", "log", "-1", "--format=%as %cs", "--", path],
                           capture_output=True, text=True, timeout=15)
        if p.returncode == 0:
            date = [x for x in (p.stdout or "").split() if len(x) == 10 and x[4] == x[7] == "-"]
            if date:
                return min(date), "git"
    except Exception:
        pass    # git assente o repo strano: si ripiega, dichiarandolo
    return datetime.fromtimestamp(os.path.getmtime(path)).strftime("%Y-%m-%d"), "data del file"


def giorni_fra(da, a):
    """Giorni di calendario fra due 'AAAA-MM-GG'. None se una non si legge."""
    try:
        return (datetime.strptime(a, "%Y-%m-%d") - datetime.strptime(da, "%Y-%m-%d")).days
    except Exception:
        return None


def fuori_flotta(r):
    """True se la riga NON e' di un nostro EA, cioe' se il `magic` e' 0.

    🔴 RISCRITTA IL 07/10/2026.
    Prima pretendeva **due** criteri -- commento vuoto **E** magic 0 -- e quindi
    una riga a mano **con un commento battuto a mano** restava dentro il
    "Totale giornata". Il fatto era **misurato e scritto** il **02/10** (il
    `DIARIO` di quel giorno: *"VERA FLOTTA (magic != 0): -94,74 ... il «Totale
    giornata +623,13» dello strumento **mescola i due**"*) ma era stato
    **giudicato "non un difetto"**, con la correzione delegata alla mano. Il
    **07/10** ha presentato il conto: una riga a mano da **10,00 lotti** col
    commento `reversale su st 3.0` valeva **+724,93** su **+737,45**, il
    **98,3%** -- la flotta vera era **+12,52**.
    📊 Contabilita' del danno, esatta: **un solo** totale pubblicato era
    sbagliato (**02/10**, +623,13 contro -94,74); il **07/10** e' stato preso
    prima di uscire; il **01/10** fu pubblicato **giusto** (-118,36) per un
    **caso d'orario** -- la riga a mano col commento chiuse alle 23:01:30, dopo
    la pubblicazione delle 22:45.
    👉 Il criterio giusto e' **UNO**: nessun nostro EA gira a magic 0, quindi
    `magic == 0` -> fuori dalla flotta, **qualunque cosa ci sia scritta nel
    commento**. Il verso opposto (commento vuoto ma magic valorizzato) e' un
    nostro EA che non scrive il commento: **resta dentro**.
    📌 Il nome e' cambiato da `senza_commento` a `fuori_flotta` di proposito: il
    vecchio nome diceva il criterio sbagliato."""
    return (str(r.get("magic", "0")) or "0").strip() in ("", "0")


_CACHE_GIORNALE = {}


def giornale_runner(conto):
    """Dal piu' recente CODA_09 del runner: per `conto`, l'ultimo giorno in cui
    MT5 ha scritto un log Esperti su quel terminale e quante righe di ordine
    aveva. Ritorna un dizionario oppure **None quando non si puo' dire** --
    cartella assente, nessun CODA_09, blocco del conto assente, formato diverso.
    Non indovina mai: senza una riga letta, torna None e chi chiama tace.
    Memoizzata: la pagella la interroga in quattro punti e il referto non cambia
    mentre lo script gira."""
    if conto in _CACHE_GIORNALE:
        return _CACHE_GIORNALE[conto]
    _CACHE_GIORNALE[conto] = _leggi_giornale_runner(conto)
    return _CACHE_GIORNALE[conto]


def _leggi_giornale_runner(conto):
    try:
        files = [f for f in os.listdir(CODA_REFERTI)
                 if f.startswith("CODA_09_") and f.endswith(".log")]
    except OSError:
        return None
    if not files:
        return None
    ultimo = sorted(files)[-1]
    try:
        with open(os.path.join(CODA_REFERTI, ultimo), encoding="utf-8",
                  errors="replace") as f:
            righe = f.read().split("\n")
    except OSError:
        return None
    # 🔴 CINTURA (classe 1143): tutto il valore dell'ASSENZA di un giorno sta
    #    nel fatto che la sonda stampa i DUE GIORNI PIU' RECENTI -- cosi' un
    #    giorno piu' nuovo, se esistesse, sarebbe stampato. Su una sonda che
    #    stampasse i due piu' VECCHI questo lettore si comporterebbe identico e
    #    mentirebbe in silenzio. Quindi la premessa si CONTROLLA, non si assume.
    if not any("ultimi due giorni" in r for r in righe[:5]):
        return None
    # la data della SONDA sta nel nome: CODA_09_giornale_operativo_AAAAMMGG_hhmmss.log
    parti = ultimo.replace(".log", "").split("_")
    sonda = None
    for p in parti:
        if len(p) == 8 and p.isdigit():
            sonda = "%s-%s-%s" % (p[:4], p[4:6], p[6:])
    # il blocco del conto va da "=== conto: N" fino al prossimo "=== conto:"
    inizio = None
    for i, r in enumerate(righe):
        if r.strip() == "=== conto: %s" % conto:
            inizio = i
            break
    if inizio is None:
        return None
    fine = len(righe)
    for i in range(inizio + 1, len(righe)):
        if righe[i].strip().startswith("=== conto:"):
            fine = i
            break
    giorni = []
    g = scritta = None
    tot = None
    for r in righe[inizio:fine]:
        s = r.strip()
        if s.startswith("--- GIORNO "):
            tok = s.split()
            g = tok[2] if len(tok) > 2 and tok[2].isdigit() else None
            tot = None
            # "--- GIORNO 20260928   (38.4 KB, ultima scrittura 2026-09-28 09:07) ---"
            scritta = None
            if "ultima scrittura" in s:
                scritta = s.split("ultima scrittura", 1)[1]
                scritta = scritta.split(")")[0].strip()
        elif g and s.startswith("righe totali:"):
            try:
                tot = int(s.split(":")[-1].strip())
            except ValueError:
                tot = None
        elif g and s.startswith("RIGHE DI ORDINE / DEAL:"):
            try:
                giorni.append((g, int(s.split(":")[-1].strip()), tot, scritta))
            except ValueError:
                pass
            g = None
    if not giorni:
        return None
    # ordina sulla SOLA data: le 4-tuple contengono `tot` che puo' essere
    # None, e su due blocchi con la stessa data e gli stessi ordini il
    # confronto arriverebbe a `None < int` -> TypeError, cioe' la pagella
    # non esce affatto. Uno strumento che ha imparato a non certificare
    # deve anche non morire.
    giorni.sort(key=lambda x: x[0])
    ultimo_g, ordini, tot, scritta = giorni[-1]
    return {"sonda": sonda, "referto": ultimo,
            "giorno": "%s-%s-%s" % (ultimo_g[:4], ultimo_g[4:6], ultimo_g[6:]),
            "ordini": ordini, "righe": tot, "ultima_scrittura": scritta,
            "giorni": len(giorni)}


def discordi(righe):
    """Righe in cui i due criteri NON coincidono, **nel verso che resta**.

    🔴 RISCRITTA IL 07/10/2026 insieme a `fuori_flotta`. Finche' il filtro
    pretendeva commento vuoto **E** magic 0, i "discordi" erano DUE insiemi e
    restavano tutti nel totale. Adesso il criterio e' il solo `magic`, quindi:
      - `magic 0` **con** un commento -> **FUORI** dalla flotta, e il commento
        serve solo a riconoscere la riga (il 07/10: `reversale su st 3.0`);
      - commento **vuoto** con `magic` valorizzato -> **DENTRO**: e' un nostro
        EA che non scrive il commento, e questa e' l'unica ambiguita' che
        resta da guardare.
    Quindi questa funzione torna il **secondo** caso, non piu' entrambi."""
    fuori = []
    for r in righe:
        vuoto = not (r.get("strategy") or "").strip()
        magic0 = (str(r.get("magic", "0")) or "0").strip() in ("", "0")
        if vuoto and not magic0:
            fuori.append(r)
    return fuori

def leggi(path):
    if not os.path.exists(path):
        sys.exit("Manca %s — lancia pubblica_trades.ps1 sul VPS (o carica il CSV a mano)." % path)
    with open(path, encoding="utf-8-sig", newline="") as f:
        # il TradeExporter usa ';' come separatore
        righe = list(csv.DictReader(f, delimiter=";"))
    if not righe:
        sys.exit("Il CSV è vuoto.")
    return righe


def num(r, k, default=0.0):
    try:
        return float(str(r.get(k, "")).replace(",", "."))
    except (TypeError, ValueError):
        return default


def leggibile(r, k):
    """True se il campo k c'e' ed e' un numero VERO.

    `num()` in caso di guaio ripiega su 0.0, e va benissimo per i due conti
    demo: una riga storta li' sposta una lettura. Sul conto REALE no — uno
    zero silenzioso al posto di una perdita e' esattamente il modo in cui un
    totale sbagliato sembra giusto. Qui il guaio si vede.
    """
    v = r.get(k, None)
    if v is None:
        return False
    v = str(v).strip()
    if v == "":
        return False
    try:
        float(v.replace(",", "."))
        return True
    except ValueError:
        return False


def tempo(s):
    for fmt in ("%Y.%m.%d %H:%M:%S", "%Y.%m.%d %H:%M", "%Y-%m-%d %H:%M:%S"):
        try:
            return datetime.strptime(s.strip(), fmt)
        except (ValueError, AttributeError):
            continue
    return None


def valori_punto(righe):
    """EUR per punto di prezzo per lotto, STIMATO per simbolo dai dati stessi.

    Serve alla frazione catturata, che dal 15/09/2026 si calcola sui SOLDI
    e non sui prezzi (classe 358). Il valore punto non e' scritto da
    nessuna parte nel CSV: lo si ricava da `profit / (delta_prezzo x lotti)`.

    >>> SI USANO SOLO I PERDENTI, ed e' il punto di tutto il metodo.
        Su una posizione col PARZIALE il `profit` e' cumulativo su piu'
        deal mentre `close_price` e' il prezzo dell'ULTIMO deal: il
        rapporto non vale il valore punto, vale un'altra cosa. Ma il
        parziale scatta in PROFITTO: su un perdente quasi sempre non c'e',
        e il rapporto torna esatto. E' un campione sporco solo dove non
        guarda.

    >>> MEDIANA E NON MEDIA, e cancello sull'IQR: fra i perdenti ci sono
        le operazioni MANUALI di Claudio (colonna `strategy` vuota), che
        hanno coperture e chiusure a mano e sbandano di 250 volte. Sul
        campione vero di XAUUSD (207 perdenti) la mediana e' 86,742 con
        un IQR relativo dell'1,6%, mentre min e max sono 1,37 e 341,47.
        La mediana non le sente; la media si'.

    >>> IL CONTRO-ESEMPIO, ed e' quello che rende usabile questa stima:
        due valori punto di questi simboli sono stati misurati PRIMA e per
        ALTRA VIA (D30EUR 1,0000 su ~140 trade; U30USD/NASUSD 0,8607).
        Questo stimatore, che non li conosce, restituisce **1,00000** e
        **0,86071**. Se un domani non li riproducesse piu', la stima e'
        rotta e va guardata: vedi CONTROLLO_VALORI_PUNTO.
    """
    grezzi = defaultdict(list)
    for r in righe:
        lot, op, cp = num(r, "volume"), num(r, "open_price"), num(r, "close_price")
        pr = num(r, "profit")
        if lot <= 0 or op <= 0 or cp <= 0 or pr >= 0:
            continue
        d = (cp - op) if r.get("side", "").lower().startswith("b") else (op - cp)
        if d >= 0:                      # perdente con delta a favore = dato incoerente
            continue
        grezzi[r.get("symbol")].append(pr / (d * lot))
    out = {}
    for sym, vs in grezzi.items():
        vs.sort()
        n = len(vs)
        if n < 4:                       # campione troppo sottile per una mediana
            continue
        med = vs[n // 2]
        iqr = vs[(3 * n) // 4] - vs[n // 4]
        if med <= 0 or iqr / med > 0.10:   # dispersione grossa = non mi fido
            continue
        out[sym] = med
    return out


# Valori punto misurati PRIMA e per altra via. Non si usano nel conto: servono
# SOLO a far fallire rumorosamente lo stimatore se un giorno smette di
# riprodurli (il contro-esempio, non la conferma).
CONTROLLO_VALORI_PUNTO = {"D30EUR": 1.0000, "U30USD": 0.8607}
# ⚠️ E la tolleranza del 2% qui sotto e' larga QUANTO IL RUMORE FISIOLOGICO, non
#    di piu': 0,8607 non e' una costante, dipende da EUR/USD, e sui 35 perdenti
#    di U30USD il rapporto oscilla fra 0,8558 e 0,8819 (+-1,5%). Prima o poi
#    questo controllo gridera' per un movimento dell'euro, non per uno
#    stimatore rotto. Quando succede, si guarda il cambio prima del codice.


def frazione_catturata(r, vpunto=None):
    """Quanta parte del movimento disponibile ha preso il trade, IN SOLDI.

    🔴 RISCRITTA IL 15/09/2026 (classe 358). La versione precedente faceva
    `(close_price - open_price) / (session_high - open_price)`, cioe'
    metteva al numeratore il prezzo dell'**ULTIMO deal**. Ma `profit` e'
    **cumulativo su tutti i deal**: con un parziale i due campi descrivono
    cose diverse, e l'errore **non ha un verso fisso**. Misurato il
    15/09 su due operazioni della stessa giornata:
        DAX Apertura EU RETEST BUY : stampava 23%  -> vero 29,9%  (sottostima)
        STREV NAS H1 S 1/3         : stampava 77%  -> vero 45,5%  (SOVRASTIMA)
    Il verso e' il segno di (prezzo ultimo deal - prezzo del parziale). E il
    verso che SOVRASTIMA e' il piu' costoso: un falso allarme lo si guarda e
    lo si scarta, un falso "ha preso il 77%" non lo si guarda affatto — e
    nasconde proprio i casi in cui il runner ha corso e il parziale ha
    tagliato, cioe' l'imputato che il progetto insegue da R46 (14/08).

    Ora: numeratore = `profit` (la posizione INTERA, parziale compreso),
    denominatore = escursione favorevole x lotti x valore punto. Le due
    grandezze parlano della stessa posizione e sono tutte e due in euro.

    ATTENZIONE al denominatore: session_high/low li misura l'EA da
    ingresso fino alle 23:59, cioe' su TUTTA la giornata. Per gli EA di
    apertura, che chiudono entro mezz'ora, e' una finestra molto piu'
    lunga della loro vita: le percentuali escono basse per costruzione e
    vanno lette come "quanto ha preso di cio' che la giornata offriva",
    non come "quanto ha preso del suo movimento".

    🔴 E VALE SOLO PER LE POSIZIONI NATE E MORTE LO STESSO GIORNO. Su una
    multi-giorno la finestra di session_high/low si chiude alle 23:59 del
    giorno d'INGRESSO, quindi quei due numeri NON sono l'MFE/MAE: il 14/09
    `GAP AUDUSD L` e' morto a un prezzo che stava FUORI dalla sua banda di
    sessione. Prima era un avviso scritto nel referto; adesso e' un
    cancello, e la funzione restituisce None.

    Si calcola SOLO sui trade in profitto. Su un perdente il
    denominatore e' l'escursione a favore, che puo' essere quasi zero:
    il 04/08 un trade dava -1679%, un numero senza significato.
    """
    profit = num(r, "profit")
    if profit <= 0:
        return None
    if not r.get("_ot") or not r.get("_ct"):
        return None
    if r["_ot"].date() != r["_ct"].date():      # multi-giorno: la banda non e' l'MFE
        return None
    hi, lo = num(r, "session_high"), num(r, "session_low")
    op, lot = num(r, "open_price"), num(r, "volume")
    if hi <= 0 or lo <= 0 or op <= 0 or lot <= 0:
        return None
    disponibile = (hi - op) if r.get("side", "").lower().startswith("b") else (op - lo)
    if disponibile <= 0:
        return None
    v = (vpunto or {}).get(r.get("symbol"))
    if not v:                       # valore punto non stimabile: meglio niente che un numero
        return None
    disponibile_eur = disponibile * lot * v
    if disponibile_eur <= 0:
        return None
    f = profit / disponibile_eur
    # f > 1 e' possibile in piccolo (l'EA campiona session_high a tick, puo'
    # perdere uno spike), ma molto sopra 1 vuol dire dato rotto, non gestione.
    return f if 0 < f <= 1.5 else None


def main():
    righe = leggi(CSV_IN)
    # Valore punto per simbolo, stimato dai PERDENTI di tutto lo storico
    # (serve alla frazione catturata, che dal 15/09 si calcola in EUR).
    vpunto = valori_punto(righe)
    # IL CONTRO-ESEMPIO, e deve gridare se cade: lo stimatore non conosce
    # questi due numeri, misurati prima e per altra via. Se smette di
    # riprodurli, la stima e' rotta e le frazioni non vanno lette.
    for sym, atteso in CONTROLLO_VALORI_PUNTO.items():
        v = vpunto.get(sym)
        if v is None:
            # 🔴 IL CASO PIU' PROBABILE, e la prima stesura lo lasciava passare MUTO.
            # Bastano i perdenti sotto 4, un IQR che sfonda, o il broker che
            # rinomina D30EUR in GER40, e l'intera colonna di quel simbolo
            # diventa '—' senza una riga di avvertimento. E' lo stesso difetto
            # che freschezza() descrive 200 righe piu' su: il fallimento
            # silenzioso, nella direzione che rassicura.
            print("ATTENZIONE: il valore punto di %s NON E' PIU' STIMABILE (meno di 4 "
                  "perdenti, IQR oltre il 10%%, o simbolo rinominato dal broker). Le "
                  "frazioni catturate di quel simbolo spariscono senza altro avviso."
                  % sym, file=sys.stderr)
        elif abs(v - atteso) / atteso > 0.02:
            print("ATTENZIONE: il valore punto stimato di %s (%.5f) non riproduce "
                  "quello misurato (%.4f). Le frazioni catturate NON sono affidabili."
                  % (sym, v, atteso), file=sys.stderr)
    # Le opzioni (--forza) non sono una data: senza questo filtro
    # `analizza_trades.py --forza` cercherebbe i trade del giorno "--forza".
    argomenti = [a for a in sys.argv[1:] if not a.startswith("-")]
    giorno = argomenti[0] if argomenti else None
    if giorno:
        # Il formato conta davvero: il confronto di freschezza e' fra STRINGHE
        # ISO, e '2026-09-09' >= '2026-9-8' e' **False** ('0' < '9'). Una data
        # senza lo zero davanti farebbe diventare rosso tutto, in silenzio.
        # Il giro di andata e ritorno serve: `strptime` ACCETTA '2026-9-8'
        # (Python non pretende gli zeri), quindi il solo parse non basta a
        # garantire la forma che il confronto fra stringhe richiede.
        try:
            if datetime.strptime(giorno, "%Y-%m-%d").strftime("%Y-%m-%d") != giorno:
                raise ValueError(giorno)
        except ValueError:
            sys.exit("Data '%s' non valida: serve AAAA-MM-GG con lo zero "
                     "davanti (es. 2026-09-08)." % giorno)

    for r in righe:
        r["_ot"] = tempo(r.get("open_time", ""))
        r["_ct"] = tempo(r.get("close_time", ""))
    righe = [r for r in righe if r["_ot"] and r["_ct"]]

    # --- FUORI DAL TOTALE: le righe a MAGIC 0 (non di un nostro EA).
    #     Si tolgono PRIMA di scegliere la giornata: altrimenti un giorno di
    #     sole manuali diventerebbe "la giornata" e la pagella parlerebbe di
    #     un lavoro che nessun EA ha fatto.
    manuali_tutte = [r for r in righe if fuori_flotta(r)]
    ambigue = discordi(righe)
    righe = [r for r in righe if not fuori_flotta(r)]
    if not righe:
        sys.exit("Nel CSV non c'e' nessuna riga con un magic nostro: "
                 "solo righe a magic 0.")

    # La giornata si sceglie sulla CHIUSURA, non sull'apertura.
    # Il 05/08 questo filtro girava su open_time e ha buttato fuori due
    # posizioni aperte il 31/07 e chiuse quel giorno: -61,59 euro spariti
    # dal netto (-227,17 riportato contro -288,76 reale). Il P&L realizzato
    # appartiene al giorno in cui si realizza, non a quello in cui si apre.
    if not giorno:
        giorno = max(r["_ct"] for r in righe).strftime("%Y-%m-%d")
    oggi = [r for r in righe if r["_ct"].strftime("%Y-%m-%d") == giorno]
    if not oggi:
        # Distinguere i due casi: "giornata vuota" e "giornata di sole
        # manuali" sono cose diverse, e dirle uguali nasconde un fatto.
        soloman = [r for r in manuali_tutte
                   if r["_ct"].strftime("%Y-%m-%d") == giorno]
        if soloman:
            sys.exit("Il %s ha SOLO %d righe a magic 0 (non di un nostro EA, "
                     "fuori dal conto della flotta): nessun EA ha operato."
                     % (giorno, len(soloman)))
        sys.exit("Nessun trade chiuso il %s." % giorno)

    # Le posizioni aperte nei giorni precedenti si segnalano: la durata media
    # e la "frazione del giorno" per loro non vogliono dire niente.
    ereditate = [r for r in oggi if r["_ot"].strftime("%Y-%m-%d") != giorno]

    # ---------- IL BUCO DELLA PUBBLICAZIONE (misurato il 01/10, CORRETTO il 02/10) ----------
    #
    # `pubblica_trades.ps1` gira alle 22:45 e la pagella alle 23:00: una
    # posizione che chiude in mezzo NON e' nel CSV quando la sua pagella viene
    # scritta. Arriva nel CSV del giorno dopo portando la data di chiusura del
    # giorno prima, e la pagella del giorno dopo si aggancia alla PROPRIA
    # data: quelle righe cadono in un buco che nessuna pagella copre.
    #
    # 🔴 CORREZIONE DEL 02/10, E SPOSTA IL CONFINE DI UN'ORA INTERA.
    # La prima stesura tagliava a `>= "22:45:00"`. Sbagliato: **22:45 e' ora
    # VPS, cioe' ITALIANA** (provato: `pubblica_trades.ps1` r.169 scrive il
    # messaggio di commit con `Get-Date` locale e GitHub lo timbra in UTC ->
    # 36 commit di fila dicono 22:45 contro 20:45 UTC = UTC+2 = CEST), mentre
    # la colonna `close_time` e' **ora SERVER** (`ABTG_TradeExporter.mq5`
    # r.165: `HistoryDealGetInteger(tk, DEAL_TIME)`, provato sui dati: le
    # `DAX Apertura` aprono all'ora 08 e le `Nasdaq Apertura`/`ORB` all'ora
    # 14, cioe' 09:00 e 15:00 italiane). Server = IT - 1, quindi **la
    # pubblicazione cade alle 21:45 in QUESTA colonna**, e il buco e'
    # [21:45 ; 23:59] di ora server = **2h15m, non 15 minuti**.
    # Effetto della correzione sull'archivio: da 28 righe misurate a **60**.
    # Classe 1078.
    #
    # 🔴 E DUE ALTRE CORREZIONI DELLO STESSO GIRO:
    # - si guardano ANCHE le manuali: `righe` a questo punto le ha gia' perse
    #   (r.395), e la riga piu' grossa del buco in tutto l'archivio e' proprio
    #   una manuale (oro, -147,78, 28/06 23:40). Classe 1079.
    # - NON si guarda solo l'ultimo giorno con dati: se la consegna si rompe
    #   per piu' giorni (succede: 23->29/09) arrivano piu' giornate in blocco
    #   e le precedenti verrebbero saltate. Si guardano TUTTI i giorni
    #   precedenti che hanno una pagella scritta. Classe 1081.
    #
    # ⚠️ E l'avviso non afferma piu' "la pagella non poteva averla" senza
    # guardare se quella pagella ESISTE: se il file non c'e', lo dice.
    # 🔴 06/10/2026: la soglia NON e' cablata. Il task gira alle 22:45 ITALIANE,
    #    la colonna `close_time` e' in ora SERVER, e BCM e' UTC+1 FISSO: d'estate
    #    la soglia e' 21:45, d'INVERNO e' 22:45. Dal 25/10 un "21:45" cablato
    #    avrebbe segnalato come "rimaste fuori" tutte le righe fra le 21:45 e le
    #    22:45 server, che invece la pubblicazione LE PRENDE: un'ora di falsi
    #    allarmi ogni sera, dentro la challenge. La soglia si ricava dalla DATA
    #    DI OGNI GIORNATA esaminata, non dalla data di oggi, perche' lo stesso
    #    file contiene giornate d'estate e d'inverno.
    def _soglia_server(gg):
        return (_ora_pubblicazione_server_hhmm(gg) or "22:45") + ":00"
    tutte = righe + manuali_tutte
    in_ritardo = []
    for g in sorted({r["_ct"].strftime("%Y-%m-%d") for r in tutte
                     if r["_ct"].strftime("%Y-%m-%d") < giorno}):
        tardive = sorted([r for r in tutte
                          if r["_ct"].strftime("%Y-%m-%d") == g
                          and r["_ct"].strftime("%H:%M:%S") >= _soglia_server(g)],
                         key=lambda r: r["_ct"])
        if not tardive:
            continue
        # La pagella di quel giorno esiste? Se no, non si puo' dire che "non
        # poteva averle": non e' mai stata scritta, ed e' un fatto diverso.
        esiste = os.path.exists(os.path.join(OUT_DIR, "giornata_%s.md" % g))
        in_ritardo.append((g, tardive, esiste))
    # Si avvisa solo sul giorno precedente piu' recente: i piu' vecchi sono
    # storia, e l'avviso serve a correggere la pagella di IERI. Gli altri
    # restano contati qui sotto, dichiarati.
    # 🔴 E i giorni piu' vecchi si contano SOLO se hanno una pagella: dove la
    # pagella non esiste non c'e' nessun numero da correggere, e metterli
    # insieme gonfia l'avviso con storia. Misurato il 02/10: 33 giornate
    # hanno righe oltre le 21:45, ma solo **4** hanno anche una pagella
    # (15/09, 16/09, 30/09, 01/10) -- la pagella e' nata il 03/08. Classe 1080.
    # 🔴 CORREZIONE TROVATA DALLA PROVA NEGATIVA (02/10): l'avviso principale
    # deve parlare del giorno IMMEDIATAMENTE PRECEDENTE CON DATI -- quello la
    # cui pagella e' stata scritta poco prima di questa -- non dell'ultimo
    # giorno che *ha* righe tardive. Prendendo `in_ritardo[-1]` la pagella del
    # 22/09 avvisava sul **16/09**, sei giorni prima: un allarme stantio, che
    # e' il modo in cui un allarme smette di essere guardato.
    # Gli altri giorni restano nella nota di coda, e solo se hanno una pagella.
    giorni_con_dati = sorted({r["_ct"].strftime("%Y-%m-%d") for r in tutte
                              if r["_ct"].strftime("%Y-%m-%d") < giorno})
    prec = giorni_con_dati[-1] if giorni_con_dati else None
    piu_vecchi = [x for x in in_ritardo if x[0] != prec and x[2]]
    in_ritardo = [x for x in in_ritardo if x[0] == prec]

    out = ["# 📅 Giornata %s — pagella automatica" % giorno, "",
           "_Generato da `analizza_trades.py` sul CSV del TradeExporter. "
           "Posizioni **chiuse** in giornata._", ""]
    # ---------- TIMBRO DI FRESCHEZZA (09/09/2026) ----------
    #
    # Sta IN TESTA apposta: e' la prima cosa da sapere prima di credere a un
    # qualunque numero sotto. Un dato che non arriva non e' uno zero.
    # LA DATA DI RIFERIMENTO E' L'OROLOGIO, NON I DATI (difetto trovato dal
    # controllo-preventivo, 09/09): `giorno` viene da max(close_time) del CSV
    # del PICCOLO. Se l'esportatore del piccolo muore, `giorno` scivola
    # indietro da solo e **tutte le righe tornano verdi**, proprio nel caso in
    # cui il timbro servirebbe. Un timbro di freschezza non puo' misurarsi sui
    # dati che deve giudicare.
    #   - pagella SERALE automatica (nessuna data a mano) -> riferimento = OGGI;
    #   - pagella RETROATTIVA chiesta a mano  -> riferimento = quel giorno,
    #     perche' li' la domanda e' "il CSV copriva quella data?".
    oggi_data = datetime.now().strftime("%Y-%m-%d")
    su_richiesta = bool(argomenti)
    rif = giorno if su_richiesta else oggi_data

    # ---------- LA RICADUTA SU UN GIORNO PASSATO NON LO RISCRIVE ----------
    #
    # Difetto MECCANICO, terza occorrenza: 15/09 (evitata a mano), 24/09,
    # 25/09 (tornato da solo). Nella corsa SERALE automatica `giorno` viene da
    # max(close_time) del CSV del PICCOLO: se quel conto non consegna, `giorno`
    # scivola indietro da solo e la pagella di stasera si scrive **sopra**
    # quella di un giorno passato, timbrandoci dentro lo STATO DI OGGI — il
    # saldo del 100k e la tabella di freschezza, che sono calcolati su
    # `rif = oggi_data` proprio due righe qui sopra.
    # Il 24/09 ha messo `100.081,32` dove stava `101.341,30`; il 25/09 ha
    # riscritto giornata_2026-09-23.md con "Saldo realizzato AL 2026-09-24".
    # Tutte e due annullate a mano con `git checkout` prima della consegna:
    # una toppa che sta nell'attenzione di chi guarda non e' una toppa.
    #
    # Quel file e' gia' stato scritto, giusto, la sua sera: non si tocca.
    # Con la data passata a mano (`su_richiesta`) la rigenerazione resta
    # possibile, ed e' corretta: li' `rif = giorno`, quindi la freschezza
    # risponde alla domanda giusta ("il CSV copriva quella data?").
    if (not su_richiesta) and giorno != oggi_data and os.path.exists(
            os.path.join(OUT_DIR, "giornata_%s.md" % giorno)):
        sys.exit(
            "PAGELLA NON SCRITTA, ed e' voluto.\n"
            "  Oggi e' il %s, ma l'ultima chiusura nel CSV del piccolo\n"
            "  50503392 e' del %s: la pagella ricadrebbe su un giorno PASSATO\n"
            "  e riscriverebbe report/giornata_%s.md con lo STATO DI OGGI\n"
            "  (saldo del 100k, tabella di freschezza).\n"
            "  -> La pagella di stasera si scrive A MANO, dicendo che e' a mano.\n"
            "  -> Per rigenerare DAVVERO quel giorno, con la sua data:\n"
            "       python3 backtest_pipeline/analizza_trades.py %s"
            % (oggi_data, giorno, giorno, giorno))

    CONTI = (("piccolo 50503392", CSV_IN),
             ("100k 50504263",    CSV_100K),
             ("reale 10105439",   CSV_REALE))
    fresco, quando = {}, {}
    righe_timbro, fermi = [], []
    for etichetta, percorso in CONTI:
        d, fonte = freschezza(percorso)      # una sola chiamata a git per file
        quando[percorso] = d
        fresco[percorso] = bool(d) and d >= rif
        if d is None:
            righe_timbro.append("| %s | `%s` | — | ⚪ **CSV ASSENTE** |"
                                % (etichetta, os.path.basename(percorso)))
        elif fresco[percorso]:
            righe_timbro.append("| %s | `%s` | %s _(%s)_ | ✅ aggiornato |"
                                % (etichetta, os.path.basename(percorso), d, fonte))
        else:
            n = giorni_fra(d, rif)
            righe_timbro.append("| %s | `%s` | %s _(%s)_ | ⚠️ **fermo%s** |"
                                % (etichetta, os.path.basename(percorso), d, fonte,
                                   "" if n is None else " da %d giorn%s%s" % (
                                       n, "o" if n == 1 else "i",
                                       " (weekend compreso)" if n and n >= 3 else "")))
            fermi.append(etichetta)

    # --- SOSPETTO VERO contro RUMORE (misurato, non stimato) --------------
    # Il controllo-preventivo ha contato: sui CSV veri di agosto-settembre il
    # 100k risulterebbe "fermo" **13 sere su 30**, ma i guasti di consegna
    # noti sono **1** (04/09). Segnale/rumore 1:13 = un allarme che si impara
    # a ignorare, e la sera che conta si salta.
    # Il discriminante che REGGE alla misura sono le GEMELLE: le strategie che
    # nella storia hanno operato su TUTTI E DUE i conti. Se una gemella chiude
    # sul piccolo e sul 100k non compare, il dato manca DAVVERO. Sul 04/09 si
    # accende (DAX Apertura EU RETEST BUY chiusa sul piccolo, assente sul
    # 100k); in 40 giorni sbaglia 3 volte invece di 13.
    gemelle_mancanti = set()
    if not fresco.get(CSV_100K, True) and os.path.exists(CSV_100K):
        try:
            with open(CSV_100K, encoding="utf-8-sig", newline="") as f:
                r100_t = list(csv.DictReader(f, delimiter=";"))
            gemelle = ({r.get("strategy") for r in righe if r.get("strategy")} &
                       {r.get("strategy") for r in r100_t if r.get("strategy")})
            chiuse_100k = {r.get("strategy") for r in r100_t
                           if (r.get("close_time") or "")[:10].replace(".", "-") == giorno}
            gemelle_mancanti = ({r.get("strategy") for r in oggi} & gemelle) - chiuse_100k
        except Exception:
            pass    # se non si riesce a leggere, si resta sul verdetto prudente

    out += ["## 🕐 Freschezza dei dati", "",
            "| Conto | File | Contenuto aggiornato al | Stato |",
            "|---|---|---|---|"] + righe_timbro + [""]
    if not su_richiesta and giorno != oggi_data:
        n = giorni_fra(giorno, oggi_data) or 0
        if not fresco[CSV_IN]:
            # Il FILE del piccolo non e' arrivato: qui il rosso e' meritato.
            out += ["> 🔴 **IL PICCOLO `50503392` NON CONSEGNA PIU'.** Pagella "
                    "generata il %s ma datata **%s** (%d giorn%s indietro), e "
                    "`trades_auto.csv` risulta fermo **anche come file**: non e' "
                    "che il conto non ha operato, e' che **il dato non arriva**."
                    % (oggi_data, giorno, n, "o" if n == 1 else "i"), ""]
        else:
            # Il file E' arrivato oggi, solo senza chiusure nuove: weekend,
            # festivo, o giornata senza trade. Gridare al lupo qui insegna a
            # ignorare i rossi veri — lo stesso errore corretto sul 100k, e
            # misurato: capiterebbe 10 sere su 40, quasi tutte di sabato.
            out += ["> ⚠️ **Pagella del %s, generata il %s.** Il CSV del piccolo "
                    "`50503392` **e' arrivato oggi** (vedi tabella qui sopra) ma "
                    "non ha chiusure dopo il %s: con ogni probabilita' il conto "
                    "non ha chiuso nulla — weekend o festivo. **Nessun dato "
                    "mancante accertato.**" % (giorno, oggi_data, giorno), ""]
    if gemelle_mancanti:
        out += ["> 🔴 **DATO NON ARRIVATO DAL 100k — e stavolta e' un sospetto "
                "VERO, non rumore.** %s ha chiuso sul piccolo `50503392` ed e' "
                "una **gemella** (opera su tutti e due i conti), ma sul 100k "
                "`50504263` non compare. E' la firma esatta del 04/09/2026, "
                "quando la pagella pubblico' `+0,00` su un giorno da **+30,78**."
                % " · ".join("`%s`" % s for s in sorted(gemelle_mancanti)), ""]
    elif fermi:
        out += ["> ⚠️ **%s: nessun contenuto nuovo.** Puo' voler dire due cose "
                "diverse — **o il conto non ha operato, o il dato non e' "
                "arrivato** — e da qui non si distinguono. Nessuna gemella "
                "risulta mancante, quindi **con ogni probabilita' e' la prima**."
                % " · ".join(fermi), ""]
        # 05/10: se per il 100k il giornale del runner SCIOGLIE il dubbio, il
        # banner generico qui sopra non deve restare l'ultima parola: lo dice e
        # rimanda alla sezione, dove il fatto e' misurato (classe 1136).
        _gr100 = giornale_runner("50504263")
        if (any("50504263" in x for x in fermi) and _gr100
                and _gr100["giorno"] < giorno and _gr100["ordini"] == 0
                and (_gr100["righe"] or 0) >= SOGLIA_LOG_PIENO):
            out += ["> 🔴 **Per il 100k `50504263` la frase qui sopra e' "
                    "SUPERATA dalla fonte viva, e la risposta non e' una "
                    "rassicurazione: il TERMINALE di quel conto non scrive un "
                    "log Esperti dal %s**, mentre nello stesso referto gli "
                    "altri terminali hanno il log di **ieri e di oggi**. Quindi "
                    "il CSV **non poteva** arrivare, e li' non girano nemmeno "
                    "l'esportatore e il Guardian. Vedi la sezione 🛡️ — c'e' "
                    "anche cosa dimostra davvero che il conto non ha operato, e "
                    "il limite della sonda." % _gr100["giorno"], ""]
    if fermi:
        out += ["> 🚧 **Attenzione a cosa e' gia' implementato:** la soppressione "
                "del netto di giornata vale per il **100k `50504263`** e per il "
                "**REALE `10105439`**. Per il **piccolo `50503392`** non c'e' "
                "ancora: se risulta fermo qui sopra, i numeri delle sezioni "
                "sopra sono **gli ultimi noti, non quelli di oggi** — ma il "
                "banner qui sopra lo dice.", ""]
    out += ["> ℹ️ La data e' la piu' vecchia fra data d'autore e data di commit "
            "dell'**ultimo cambiamento di contenuto nel repo**. Un CSV che "
            "arriva **identico** (nessuna posizione chiusa nuova) non lascia "
            "traccia: `fermo` vuol dire *\"da li' non arriva contenuto "
            "nuovo\"*, **non** *\"la consegna e' rotta\"*. Da **dentro il "
            "repo** i due casi non si separano — ma **sul VPS si', e senza "
            "riga nuova**: il runner delle 03:30 scrive gia' il **log "
            "Esperti** giornaliero di ogni terminale (`CODA_09`, `MQL5\\Logs`: "
            "MT5 ne scrive uno per ogni giorno in cui gira con EA attaccati) "
            "e la **data dei file** in "
            "`Common\\Files` (`CODA_05`, da confrontare con i CSV gemelli "
            "scritti dallo stesso esportatore la stessa notte). Cosi' il "
            "25/09 si e' accertato che il **terminale VPS** del piccolo era "
            "**fermo dal 23/09 19:35** (il **conto**, loggato anche sul PC di "
            "backtest, resta [NON MISURATO]) — vedi "
            "`report/giornata_2026-09-25.md` §1.", ""]

    if in_ritardo:
        g, tardive, esiste = in_ritardo[0]
        netto_rit = sum(num(r, "profit") + num(r, "swap") + num(r, "commission")
                        for r in tardive)
        gg = "/".join(reversed(g.split("-")[1:]))
        if esiste:
            testa = ("**IL BUCO DELLA PUBBLICAZIONE: %d posizion%s del %s %s chius%s "
                     "DOPO le 21:45 ora server**, cioe' dopo che "
                     "`pubblica_trades.ps1` aveva gia' pubblicato (gira alle **22:45 "
                     "italiane = 21:45 server**): la pagella di quel giorno, scritta "
                     "alle 23:00 italiane, **non poteva averl%s**."
                     % (len(tardive), "i" if len(tardive) > 1 else "e", gg,
                        "si sono" if len(tardive) > 1 else "si e'",
                        "e" if len(tardive) > 1 else "a",
                        "e" if len(tardive) > 1 else "a"))
        else:
            testa = ("**IL BUCO DELLA PUBBLICAZIONE: %d posizion%s del %s %s chius%s "
                     "dopo le 21:45 ora server**, e per quel giorno **non esiste "
                     "nessuna pagella**: non ci sono numeri da correggere, si "
                     "segnalano perche' nessun referto le ha mai contate."
                     % (len(tardive), "i" if len(tardive) > 1 else "e", gg,
                        "si sono" if len(tardive) > 1 else "si e'",
                        "e" if len(tardive) > 1 else "a"))
        out += ["> 🔴 " + testa + " Netto non contato li': **%+.2f**. %s"
                % (netto_rit,
                   " · ".join("`%s` %s %+.2f (%s)" % (
                       r.get("strategy") or "manuale", r.get("symbol"),
                       num(r, "profit") + num(r, "swap") + num(r, "commission"),
                       r["_ct"].strftime("%H:%M:%S")) for r in tardive)),
                "",
                "> 👉 Il totale di **oggi** qui sotto **non le include** (la loro data "
                "di chiusura e' di un altro giorno) ed e' giusto cosi': servono per "
                "**correggere quella pagella**, non per gonfiare questa. Misura "
                "dell'archivio, 02/10, **tre denominatori che non vanno confusi**: tasso "
                "strutturale **4,21% della flotta** (30 righe su 713); "
                "controfattuale d'archivio **-683,55** su 62 righe e 33 giornate; "
                "**danno effettivo sulle pagelle che esistono: 5 righe su 4 "
                "giornate, -116,24** (la pagella e' nata il 03/08). Dettaglio in "
                "`report/giornata_2026-10-02.md`.", ""]
        if piu_vecchi:
            out += ["> ⚠️ E ci sono **altre %d giornate** piu' vecchie con righe oltre "
                    "le 21:45 server (%s): non le riporto qui perche' l'avviso serve a "
                    "correggere la pagella **piu' recente**, ma sono contate."
                    % (len(piu_vecchi),
                       ", ".join("/".join(reversed(x[0].split("-")[1:])) for x in piu_vecchi[-6:])),
                    ""]

    if ereditate:
        out += ["> ⚠️ %d posizion%s apert%s in giorni precedenti e chius%s oggi "
                "(%s). Per quelle la durata media non e' indicativa; la frazione "
                "catturata, dal 15/09, per quelle non viene proprio calcolata "
                "(la banda session_high/low si chiude alle 23:59 del giorno "
                "d'INGRESSO, quindi non e' il loro MFE)." %
                (len(ereditate), "i" if len(ereditate) > 1 else "e",
                 "e" if len(ereditate) > 1 else "a",
                 "e" if len(ereditate) > 1 else "a",
                 ", ".join(sorted({r.get("strategy", "?") for r in ereditate}))), ""]

    # ---------- riepilogo per EA ----------
    #  18/09/2026 -- SI RAGGRUPPA PER (commento, MAGIC), NON PER SOLO COMMENTO.
    #  Motivo misurato: `770250` (GatedShort, viva) e `770201` (spenta dall'11/08)
    #  scrivono la STESSA identica stringa "Nasdaq Apertura US SELL".
    #  MISURATO prima di scrivere la patch, e il numero ridimensiona il caso:
    #    - commenti condivisi da piu' di un magic in tutto il CSV: TRE
    #      ("DAX Apertura EU OTT BUY" 770102/770111 - "DAX M3 L" 770501/770502 -
    #       "Nasdaq Apertura US SELL" 770201/770250);
    #    - GIORNI in cui la pagella ha davvero fuso due magic: UNO SOLO,
    #      il 27/07 su "DAX M3 L".
    #  Quindi il danno passato e' piccolo; il motivo per cui la patch vale e'
    #  che la collisione Nasdaq scatta il giorno in cui si riarma una seconda
    #  sedia su quel simbolo -- cioe' esattamente quello che stiamo per fare.
    #  Stessa famiglia della classe 426 (li' bastavano le maiuscole a
    #  distinguerle, qui nemmeno quelle).
    #  L'etichetta resta il commento NUDO quando quel commento appartiene a un
    #  magic solo -- cosi' le pagelle vecchie restano confrontabili. Il magic si
    #  aggiunge fra parentesi quadre SOLO quando serve davvero a disambiguare.
    magic_per_commento = defaultdict(set)
    for r in oggi:
        c = (r.get("strategy") or "").strip()
        if c:
            magic_per_commento[c].add(str(r.get("magic", "?")).strip())

    def etichetta_ea(r):
        c = (r.get("strategy") or "").strip()
        m = str(r.get("magic", "?")).strip()
        if not c:
            return "magic " + m
        return c if len(magic_per_commento[c]) == 1 else "%s [%s]" % (c, m)

    perEA = defaultdict(list)
    for r in oggi:
        perEA[etichetta_ea(r)].append(r)

    out += ["## Chi ha operato", "",
            "| EA | Trade | P&L | Durata media | Come sono usciti | Frazione dall'ingresso a fine giornata (solo vincenti) ⬆️ |",
            "|---|---|---|---|---|---|"]
    for ea, tr in sorted(perEA.items(), key=lambda x: -sum(num(r, "profit") for r in x[1])):
        pnl = sum(num(r, "profit") + num(r, "swap") + num(r, "commission") for r in tr)
        dur = [(r["_ct"] - r["_ot"]).total_seconds() for r in tr if r["_ct"]]
        dmed = sum(dur) / len(dur) if dur else 0
        motivi = defaultdict(int)
        for r in tr:
            motivi[r.get("close_reason") or "?"] += 1
        # 07/10/2026: la media per EA **scartava righe in silenzio** (quando il
        # valore punto del simbolo non e' stimabile), e quindi l'`n` su cui
        # poggia l'unita' dichiarata ("n>=3 vincenti dello stesso preset")
        # NON era leggibile dalla tabella. Due sere di fila e' capitato su
        # `USDCHF` dentro `BULGE_V520_VIOLA_S`: la media sembrava su 3 righe ed
        # era su 2. Ora la tabella stampa **su quante di quante**.
        vinc = [r for r in tr if num(r, "profit") + num(r, "swap")
                + num(r, "commission") > 0]
        fr = [f for f in (frazione_catturata(r, vpunto) for r in vinc)
              if f is not None]
        if not fr:
            # N5 (cancello del 07/10): se TUTTE le vincenti sono scartate, un
            # "—" muto e' lo stesso scarto silenzioso nel caso peggiore (100%).
            frm = "—" if not vinc else "— _(0 di %d vincenti)_" % len(vinc)
        elif len(fr) == len(vinc):
            frm = "%.0f%%" % (100 * sum(fr) / len(fr))
        else:
            frm = ("%.0f%% _(su %d di %d vincenti)_"
                   % (100 * sum(fr) / len(fr), len(fr), len(vinc)))
        out.append("| %s | %d | **%+.2f** | %s | %s | %s |" % (
            ea, len(tr), pnl,
            ("%.0f s" % dmed) if dmed < 120 else ("%.1f min" % (dmed / 60)),
            " · ".join("%s×%d" % (k, v) for k, v in sorted(motivi.items())), frm))

    # 06/10/2026 (riscritto dopo il FAIL del cancello): la frazione e' un limite
    # SUPERIORE **solo se la posizione e' chiusa in un colpo solo**.
    # `ABTG_TradeExporter.mq5` riscrive TUTTO il file a ogni `OnTimer` (r.106,
    # InpExportMinutes=30) e RICALCOLA `SessionRange` per ogni riga (r.184), con
    # la finestra dall'ingresso alle 23:59 del giorno d'ingresso (r.79-96); il CSV
    # si pubblica alle 22:45 ITALIANE -> l'ora server la da'
    # `_ora_pubblicazione_server()`, NON cablata (d'estate 21:45, dal 25/10
    # 22:45). A numeratore fermo la frazione puo' solo SCENDERE. Misurato il
    # 06/10/2026 sul CSV del piccolo 50503392 (47 pubblicazioni con la colonna
    # banda, 05/08-06/10, data di commit convertita in ora SERVER): 211 righe
    # pubblicate la prima volta nel loro giorno d'ingresso con banda valorizzata
    # -> 36 (17,1%) poi ALLARGATE, ZERO ristrette, fattore sull'ampiezza mediano
    # x1,050 e massimo x7,239.
    # 🔴 MA IL NUMERATORE NON E' SEMPRE FERMO: `ExportAll` scrive la riga appena
    # esiste un deal in uscita e un PARZIALE basta, quindi una posizione a
    # scaletta viene pubblicata col profit del solo primo terzo e al giro dopo la
    # frazione SALE (3119062: 31,8% -> 44,5%; 5 righe su 1.406 hanno cambiato
    # profit). Vedi la docstring di `frazione_catturata` (classe 358) e DIARIO
    # r.14 del 04/09: la casa lo aveva gia' scritto due volte.
    # Classi 1161 (+ emendamento) e 1162.
    out += ["", "_⬆️ **La frazione e' un LIMITE SUPERIORE finche' la "
            "posizione e' chiusa in un colpo solo.** Il CSV si pubblica alle "
            "%s (e l'esportatore riscrive ogni 30 minuti) mentre la banda "
            "`session_high/low` arriva alle **23:59 del giorno d'ingresso**: le "
            "barre che mancano, a storico invariato o piu' completo, possono "
            "solo **allargare** la banda, quindi **a numeratore fermo** la "
            "frazione puo' solo **scendere**. Misurato il **06/10/2026** sul CSV "
            "del **piccolo 50503392** (47 pubblicazioni con la colonna banda, "
            "05/08-06/10): su **211** righe pubblicate la prima volta nel loro "
            "giorno d'ingresso con banda valorizzata, **36 (17,1%%) si sono poi "
            "allargate e ZERO ristrette** — fattore sull'ampiezza mediano "
            "**x1,050**, massimo **x7,239**. "
            "🔴 **MA il verso NON e' garantito sulle posizioni col PARZIALE**: "
            "una riga pubblicata quando e' uscito solo il primo terzo porta il "
            "`profit` del parziale, e al giro dopo la frazione **SALE** "
            "(misurato: `3119062` da **31,8%% a 44,5%%**; 5 righe su 1.406 hanno "
            "cambiato `profit` dopo la prima pubblicazione). 👉 Un **`expert`** "
            "nella colonna delle uscite vuol dire **frazione non leggibile in "
            "nessun verso**; sulle altre il pavimento del 30%% si giudica **il "
            "giorno dopo**. 📌 Un **`(0 di N vincenti)`** sulle righe **ereditate** "
            "e' la regola **multi-giorno** del 15/09 (vedi l'avviso in "
            "testa), **non** il valore punto non stimabile: i due motivi oggi "
            "condividono la notazione, e distinguerli e' **aperto**. 📌 E vale "
            "per la pagella scritta **la sera stessa**: "
            "su una pagella **rigenerata** a giorni di distanza la banda e' gia' "
            "completa e la frazione e' una misura._" % _ora_pubblicazione_server(giorno)]

    # ---------- netto per simbolo ----------
    perSym = defaultdict(float)
    for r in oggi:
        perSym[r.get("symbol", "?")] += num(r, "profit") + num(r, "swap") + num(r, "commission")
    out += ["", "## Netto per simbolo", "",
            "| Simbolo | Netto |", "|---|---|"]
    for sym, v in sorted(perSym.items(), key=lambda x: -x[1]):
        out.append("| %s | **%+.2f** |" % (sym, v))
    out.append("")
    out.append("**Totale giornata: %+.2f**" % sum(perSym.values()))
    out.append("")
    out.append("_Totale della **sola flotta**: le righe a `magic` 0 (non di un "
               "nostro EA) stanno fuori — vedi sotto, e il criterio e' **solo** "
               "il magic, qualunque sia il commento._")

    # ---------- FUORI DAL TOTALE: le righe a MAGIC 0 ----------
    manuali_oggi = [r for r in manuali_tutte
                    if r["_ct"].strftime("%Y-%m-%d") == giorno]
    # --- 05/10/2026: `ambigue` e' calcolato su TUTTO il file (vedi r.394),
    #     PRIMA che la giornata sia scelta. Stampato cosi' dentro una pagella
    #     GIORNALIERA dichiarava "restano nel totale" di pid che in quel totale
    #     non ci sono: la sera del 05/10 i quattro pid elencati (3537169,
    #     3538850, 3539766, 3545427) erano dell'01 e del 02/10, mentre le righe
    #     di oggi erano SETTE e tutte con magic != 0 -> discordi di oggi: ZERO.
    #     Si separa per giornata, con la stessa forma usata per il buco della
    #     pubblicazione: OGGI -> "restano nel totale (di oggi)"; PRECEDENTI ->
    #     "sono rimaste nel totale della LORO giornata"; piu' RECENTI della
    #     giornata in esame -> non si nominano, appartengono a un'altra pagella
    #     (serve per le rigenerazioni retroattive, dove il file contiene anche
    #     il futuro di quella data).
    #     NB: la sezione del REALE (r.~1151) resta cumulativa ed e' coerente
    #     con se stessa, perche' quella sezione somma tutto il file ignorando
    #     `giorno`: e' un difetto DICHIARATO e non misurabile oggi (quel CSV
    #     non esiste ancora), non lo tocco di nascosto.
    amb_oggi  = [r for r in ambigue if r["_ct"].strftime("%Y-%m-%d") == giorno]
    amb_prima = [r for r in ambigue if r["_ct"].strftime("%Y-%m-%d") < giorno]
    # 05/10 (seconda limatura, dal cancello): il titolo contraddiceva il suo
    # contenuto. Senza manuali di giornata la sezione conteneva SOLO i discordi,
    # che il commento CE L'HANNO e che stanno DENTRO il totale della loro
    # giornata: l'opposto di "senza commento" e di "fuori dal totale".
    CAPPELLO_DISCORDI = ("_Qui sotto non c'e' nessuna riga fuori dalla flotta "
                         "di oggi: i **discordi** sono righe con il commento "
                         "**vuoto** e il `magic` valorizzato, cioe' nostri EA "
                         "che non scrivono il commento, e **restano dentro** il "
                         "totale della loro giornata._")
    if manuali_oggi:
        out += ["", "## 🚫 Fuori dal totale — operazioni NON della flotta "
                "(`magic` 0)", ""]
        if amb_oggi or amb_prima:
            out += ["_⚠️ Nel blocco in fondo ci sono anche i **discordi**, che "
                    "sono un'ALTRA cosa: commento **vuoto** con `magic` "
                    "valorizzato, cioe' nostri EA senza commento, e quelli "
                    "**restano dentro** il totale._", ""]
    elif amb_oggi or amb_prima:
        out += ["", "## 🚫 Fuori dal totale, e i casi da capire", "",
                CAPPELLO_DISCORDI]
    if manuali_oggi:
        netto_man = sum(num(r, "profit") + num(r, "swap") + num(r, "commission")
                        for r in manuali_oggi)
        out += ["Righe **non della flotta**: `magic` **0**, cioe' nessun nostro "
                "EA (il criterio e' **solo** il magic dal 07/10/2026 — una mano "
                "che scrive un commento restava dentro il totale, e il 07/10 "
                "valeva il **98,3%** della giornata). **Non entrano nel totale "
                "della flotta** qui sopra — Claudio, 07/09/2026.", "",
                "| Simbolo | Trade | Commento | Netto |", "|---|---|---|---|"]
        perSymMan = defaultdict(lambda: [0, 0.0, set()])
        for r in manuali_oggi:
            v = perSymMan[r.get("symbol", "?")]
            v[0] += 1
            v[1] += num(r, "profit") + num(r, "swap") + num(r, "commission")
            c = (r.get("strategy") or "").strip()
            v[2].add("`%s`" % c if c else "_(vuoto)_")
        for sym, (nn, v, cc) in sorted(perSymMan.items(), key=lambda x: x[1][1]):
            out.append("| %s | %d | %s | **%+.2f** |"
                       % (sym, nn, " · ".join(sorted(cc)), v))
        out += ["", "**Totale manuale (fuori dal conto): %+.2f** su %d operazioni."
                % (netto_man, len(manuali_oggi)), "",
                "> ⚠️ Attese **zero** manuali dal **%s** in poi: se questo blocco "
                "compare per una data successiva, o il confine e' cambiato o "
                "qualcuno ha operato a mano. **Va guardato, non ignorato.**"
                % CAMBIO_SOLO_EA]
    if amb_oggi:
        _pid_oggi = ", ".join(str(r.get("pid", "?")) for r in amb_oggi[:10])
        if len(amb_oggi) > 1:
            out += ["", "> ⚠️ **%d operazioni DI OGGI con il commento VUOTO ma "
                    "il `magic` valorizzato**: sono nostri EA che non scrivono "
                    "il commento, quindi **restano nel totale di oggi** ed e' "
                    "giusto. Si elencano per poterle attribuire. pid: %s"
                    % (len(amb_oggi), _pid_oggi)]
        else:
            out += ["", "> ⚠️ **1 operazione DI OGGI con il commento VUOTO ma "
                    "il `magic` valorizzato**: e' un nostro EA che non scrive "
                    "il commento, quindi **resta nel totale di oggi** ed e' "
                    "giusto. Si elenca per poterla attribuire. pid: %s"
                    % _pid_oggi]
    if amb_prima:
        _ult = max(r["_ct"] for r in amb_prima).strftime("%Y-%m-%d")
        _pid_prima = ", ".join(str(r.get("pid", "?")) for r in amb_prima[:10])
        if len(amb_prima) > 1:
            out += ["", "> ⚠️ **%d operazioni con commento e magic discordi in "
                    "giornate PRECEDENTI** (la piu' recente il %s): commento vuoto e "
                    "`magic` valorizzato. Sono contate nel totale **della "
                    "giornata in cui si sono chiuse** ed e' giusto. pid: %s" % (len(amb_prima), _ult, _pid_prima)]
        else:
            out += ["", "> ⚠️ **1 operazione con commento e magic discordi in "
                    "una giornata PRECEDENTE** (il %s). E' contata nel totale "
                    "**della giornata in cui si e' chiusa**, non in quello di "
                    "stasera: si elenca qui perche' il nodo non e' chiuso, non "
                    "perche' pesi su oggi. pid: %s" % (_ult, _pid_prima)]

    # ---------- segnalazioni ----------
    avvisi = []

    # 1) sovrapposizioni: stesso simbolo, FINESTRE che si sovrappongono
    #    (oppure ingressi entro 10 minuti, per continuare a vedere i whipsaw)
    #
    # ⚠️ 06/08: "DIREZIONI OPPOSTE" va detto SOLO se le due posizioni erano
    #    aperte NELLO STESSO ISTANTE. Prima bastava che gli ingressi fossero
    #    vicini, e oggi ha prodotto due falsi allarmi su NASUSD: l'`ORB` che
    #    si gira DOPO essere stato stoppato non e' una copertura, e' un
    #    whipsaw. E' lo stesso errore che avevo gia' fatto due volte a mano
    #    leggendo lo Storico invece delle posizioni aperte: qui lo chiude
    #    il codice, non la memoria.
    # ⚠️ 31/08: il filtro "ingressi entro 600 s" era un SURROGATO della
    #    sovrapposizione e falliva proprio sulle posizioni tenute per ore:
    #    GAP long 01:00 + SUPERWAVE short 06:00 = 8,5 ORE opposte sul Dow,
    #    scartate perche' gli ingressi distavano 5 ore. Stessa radice dei
    #    tre casi persi a cavallo di due giorni (19, 21, 25/08). Ora la
    #    coppia entra se le FINESTRE si toccano, a qualunque distanza
    #    d'ingresso; il criterio dei 600 s resta solo per le sequenze
    #    ravvicinate (whipsaw), che per definizione non si sovrappongono.
    persym = defaultdict(list)
    for r in oggi:
        persym[r.get("symbol", "?")].append(r)
    for sym, tr in persym.items():
        tr = sorted(tr, key=lambda r: r["_ot"])
        for i in range(len(tr)):
            for j in range(i + 1, len(tr)):
                dt = (tr[j]["_ot"] - tr[i]["_ot"]).total_seconds()
                a, b = tr[i], tr[j]
                # sovrapposizione vera: l'ultimo ad aprire lo fa prima che il primo chiuda
                sovrapposte = True
                if a["_ct"] and b["_ct"]:
                    sovrapposte = max(a["_ot"], b["_ot"]) < min(a["_ct"], b["_ct"])
                if not sovrapposte and dt > 600:
                    continue
                if a.get("side") != b.get("side"):
                    coda = (" — ⚠️ **DIREZIONI OPPOSTE, contemporanee**" if sovrapposte
                            else " — direzioni opposte ma **in sequenza**: la seconda apre "
                                 "dopo la chiusura della prima (inversione, non copertura)")
                else:
                    coda = ("" if sovrapposte
                            else " — **in sequenza**, non contemporanee")
                dist = ("%.0f s" % dt) if dt <= 600 else ("%.1f ore" % (dt / 3600.0))
                avvisi.append(
                    "🔶 **%s**: `%s` (%s) e `%s` (%s) a **%s** di distanza d'ingresso%s" % (
                        sym, a.get("strategy"), a.get("side"), b.get("strategy"),
                        b.get("side"), dist, coda))

    # 2) uscite troppo rapide o frazione bassa
    #    (la frazione e' in SOLDI dal 15/09: vedi frazione_catturata)
    for r in oggi:
        if not r["_ct"]:
            continue
        d = (r["_ct"] - r["_ot"]).total_seconds()
        f = frazione_catturata(r, vpunto)
        # 07/10/2026 (cancello, N4): "vincente" si legge sul NETTO, come nella
        # media per EA. Era sul LORDO, e l'allarme sparava su righe che sono
        # SCRATCH: `giornata_2026-09-30.md` dice "BLU_L su USDJPY: preso il 1%"
        # su un trade con lordo +0,22 e **netto -0,14**. Un allarme che fischia
        # li' insegna a ignorare quelli veri, e FRAZIONE_BASSA e' l'allarme che
        # apre un round. Raggio misurato: **3 bullet su 128** in tutto lo
        # storico, tutti e tre a frazione 1% e netto fra -0,08 e -0,14 (01/04
        # ARANCIO_S e BLU_S su NZDUSD, 30/09 BLU_L su USDJPY). Una decisione
        # sola, applicata ai due siti che la usavano in modo diverso.
        netto_r = num(r, "profit") + num(r, "swap") + num(r, "commission")
        if netto_r > 0 and d < DURATA_SOSPETTA:
            avvisi.append("⏱️ **%s** su %s: chiuso in **%.0f s** in profitto (%s) — "
                          "gestione probabilmente troppo stretta" % (
                              r.get("strategy"), r.get("symbol"), d,
                              r.get("close_reason") or "?"))
        elif netto_r > 0 and f is not None and f < FRAZIONE_BASSA:
            avvisi.append("📉 **%s** su %s: preso il **%.0f%%** di quanto la giornata offriva "
                          "dopo il suo ingresso (uscito con `%s`)" % (
                              r.get("strategy"), r.get("symbol"), 100 * f,
                              r.get("close_reason") or "?"))

    if avvisi:
        out += ["", "## ⚠️ Da guardare", ""] + ["- " + a for a in dict.fromkeys(avvisi)]
    else:
        out += ["", "_Nessuna anomalia rilevata: nessuna sovrapposizione, "
                "nessuna uscita anomala._"]

    # ---------- CONTO 100K (dry-run FTMO col Guardiano) ----------
    # Perimetro dichiarato SEMPRE: la lettura del 10/08 e' nata proprio dal
    # fatto che la pagella vedeva solo il piccolo mentre la giornata vera
    # era sul 100k.
    out += ["", "## 🛡️ Conto 100k — dry-run FTMO (50504263)", ""]
    if not os.path.exists(CSV_100K):
        out += ["_CSV del 100k non ancora sul repo: questa sezione si accende "
                "quando sul VPS gira il `pubblica_trades.ps1` aggiornato "
                "(pubblica anche `ABTG_Trades_100k.csv`)._"]
    else:
        with open(CSV_100K, encoding="utf-8-sig", newline="") as f:
            r100 = list(csv.DictReader(f, delimiter=";"))
        for r in r100:
            r["_ot"] = tempo(r.get("open_time", ""))
            r["_ct"] = tempo(r.get("close_time", ""))
        r100 = [r for r in r100 if r["_ot"] and r["_ct"]]

        # ---------- IL SALDO DI UNA PAGELLA E' QUELLO DI QUEL GIORNO --------
        #
        # Trovato il 25/09 provando a ROMPERE la toppa appena scritta, non
        # confermandola: rigenerato a mano il 23/09 con la data esplicita, la
        # sezione stampava **100.081,32**, cioe' il saldo DOPO le tre
        # operazioni del 24/09, invece di **101.341,30**. Causa: `netto_storico`
        # sommava il file INTERO, `giorno` non lo guardava nessuno.
        # 🔴 Quindi il difetto non era solo la ricaduta automatica: **qualunque**
        # rigenerazione di un giorno passato timbrava il saldo di OGGI. La
        # guardia messa sopra chiudeva la porta e lasciava aperta la finestra.
        # Nel caso normale (giorno = oggi) questo filtro non toglie niente:
        # nessuna riga puo' chiudere dopo oggi.
        # 📌 La sezione del conto REALE ha la stessa forma (`netto storico`
        # sommato su tutto il file) e le servira' lo stesso filtro: oggi quel
        # CSV non esiste, quindi la modifica **non e' provabile** e non la
        # faccio alla cieca. Dichiarato, non dimenticato.
        r100 = [r for r in r100 if r["_ct"].strftime("%Y-%m-%d") <= giorno]

        def _netto(r):
            return num(r, "profit") + num(r, "swap") + num(r, "commission")

        netto_storico = sum(_netto(r) for r in r100)
        saldo = DEP_100K + netto_storico
        oggi100 = [r for r in r100 if r["_ct"].strftime("%Y-%m-%d") == giorno]
        netto_oggi = sum(_netto(r) for r in oggi100)

        perGiorno100 = defaultdict(float)
        for r in r100:
            perGiorno100[r["_ct"].strftime("%Y-%m-%d")] += _netto(r)

        if oggi100:
            perEA100 = defaultdict(list)
            for r in oggi100:
                perEA100[r.get("strategy") or ("magic " + str(r.get("magic", "?")))].append(r)
            out += ["| EA | Trade | P&L | Come sono usciti |", "|---|---|---|---|"]
            for ea, tr in sorted(perEA100.items(), key=lambda x: -sum(_netto(r) for r in x[1])):
                motivi = defaultdict(int)
                for r in tr:
                    motivi[r.get("close_reason") or "?"] += 1
                out.append("| %s | %d | **%+.2f** | %s |" % (
                    ea, len(tr), sum(_netto(r) for r in tr),
                    " · ".join("%s×%d" % (k, v) for k, v in sorted(motivi.items()))))
            out.append("")
        elif not fresco[CSV_100K]:
            # Il caso che il 04/09 e' costato un numero pubblicato sbagliato:
            # qui NON si scrive "nessuna posizione chiusa" e NON si scrive
            # "+0,00". Non lo sappiamo, e si dice.
            d100 = quando[CSV_100K]
            # 05/10/2026: prima di dare l'allarme si guarda la FONTE VIVA. Il
            # giornale del runner (CODA_09) dice se su quel terminale un EA ha
            # scritto un log: se l'ultimo giorno di log e' vecchio, il conto NON
            # ha operato, e l'allarme rosso diventa una constatazione.
            # Nato da un difetto misurato: il banner rosso e' uscito CINQUE
            # pagelle di fila su un conto da cui l'ultima sedia l'avevamo tolta
            # NOI il 25/09 (classe 1136).
            gr = giornale_runner("50504263")
            if (gr and gr["giorno"] < giorno and gr["ordini"] == 0
                    and (gr["righe"] or 0) >= SOGLIA_LOG_PIENO):
                # Il fallback va DENTRO la guardia: `("[ora non letta]").split()[-1]`
                # stampava "letta]" dentro un banner rosso (famiglia 1144: fa
                # spazzatura visibile, non certifica il falso). Trovato dal
                # cancello alla 5a passata con un referto senza `ultima scrittura`.
                _ora_log = (gr["ultima_scrittura"].split()[-1]
                            if gr["ultima_scrittura"] else "[ora non letta]")
                out += ["> 🔴 **NESSUN EA HA POTUTO OPERARE su `50504263` — ma "
                        "il fatto MISURATO e' un altro, e va detto per primo: "
                        "l'ultimo log Esperti del TERMINALE del 100k e' quello "
                        "del %s e si ferma a %s; dal giorno DOPO non ne esiste "
                        "nessuno.** Il CSV ha contenuto fermo al **%s**, e il "
                        "giornale del runner (`%s`, sonda delle 03:30 del "
                        "**%s**) su quell'ultimo giorno con log da' **0** righe "
                        "di ordine su **%s** righe totali."
                        % (gr["giorno"], _ora_log, d100, gr["referto"],
                           gr["sonda"], gr["righe"]), "",
                        "> 🔴 **E qui il salto NON si fa**: MT5 scrive un log "
                        "per ogni giorno in cui gira **con EA attaccati**, "
                        "quindi *nessun log* dice che quel **TERMINALE era "
                        "spento o senza EA** — **non** che il conto sia "
                        "tranquillo. Le due ipotesi producono **la stessa "
                        "evidenza**, e nello stesso referto gli **altri** "
                        "terminali hanno il log di **ieri e di oggi**. "
                        "🔴 Conseguenze: con quel terminale giu' "
                        "l'`ABTG_TradeExporter` **non gira** (il CSV **non PUO' "
                        "aggiornarsi**: *\"dato non arrivato\"* e' letterale) e "
                        "l'`ABTG_Guardian` **non gira** su quel conto.", "",
                        "> 🟢 **Che il conto non abbia operato lo dimostrano DUE "
                        "fatti, non il silenzio del log**: (1) l'ultima sedia "
                        "operativa l'abbiamo **tolta noi** il 25/09 "
                        "(`ABTG_SupertrendReversal` 225JPY H2, magic `770901`, "
                        "ore 13:14:47 — `report/SOSPENSIONE_SEDIE_DEMO_2026-09-25.md`), "
                        "quindi **niente poteva aprire**; (2) l'ultima riga del "
                        "Guardian nel referto da' **`rischioAperto=0.00%`**, "
                        "quindi **nessuna posizione restava aperta** che potesse "
                        "chiudersi a SL/TP sul server col terminale spento.", "",
                        "> 🔴 **E resta un'AZIONE, non una constatazione**: un "
                        "terminale fermo da **%s** sul VPS della challenge va "
                        "**riacceso oppure dichiarato spento di proposito**. "
                        "⚠️ E la sonda delle 03:30 di oggi **non copre la seduta "
                        "di oggi** (la vedra' domani notte): da li' a stasera e' "
                        "**[NON ANCORA COPERTO]**. Resta **nessun netto di "
                        "giornata** per questo conto."
                        % (("%d giorni" % giorni_fra(gr["giorno"], giorno))
                           if giorni_fra(gr["giorno"], giorno) else
                           "piu' giorni"), ""]
            else:
                out += ["> 🔴 **DATO NON ARRIVATO.** Il CSV del 100k ha contenuto "
                        "fermo al **%s**: non posso dire ne' che il conto abbia "
                        "operato, ne' che non l'abbia fatto. **Nessun netto di "
                        "giornata per questo conto.**" % d100, ""]
                if gr:
                    _perche = ""
                    if (gr["righe"] or 0) < SOGLIA_LOG_PIENO:
                        # 🔴 08/10/2026: la prosa fu corretta il 07/10 ("la
                        # soglia e' NOSTRA, non del referto: era uno
                        # SCAVALCAMENTO") e il GENERATORE no, quindi la frase
                        # falsa e' tornata la sera dopo. Seconda sera di classe
                        # 1174. Il referto, su quel blocco, conclude il
                        # CONTRARIO ("nessuna riga di ordine in un log NON
                        # vuoto: questo giorno il conto NON ha operato"): il suo
                        # test di vuotezza e' kb < 1 e il file e' 1,7 KB.
                        _perche = (" — e **%s righe totali** stanno **sotto la "
                                   "soglia di %d**: su un log quasi vuoto lo "
                                   "zero **non vuol dire niente**, e **la "
                                   "soglia e' NOSTRA** (principio della classe "
                                   "162): su questo blocco il referto conclude "
                                   "il **CONTRARIO**"
                                   % (gr["righe"], SOGLIA_LOG_PIENO))
                    out += ["> ℹ️ Il giornale del runner (`%s`) c'e' ma **non "
                            "scioglie il dubbio**: ultimo giorno di log "
                            "**%s** con **%d** righe di ordine%s. L'allarme "
                            "resta rosso." % (gr["referto"], gr["giorno"],
                                              gr["ordini"], _perche), ""]
                else:
                    out += ["> ℹ️ Il giornale del runner (`CODA_09`) **non e' "
                            "leggibile da qui** (referto assente o formato "
                            "diverso): senza quella fonte il dubbio non si "
                            "scioglie, e l'allarme resta rosso.", ""]
            out += ["_Cosa guardare sul VPS: terminale **100k, conto `50504263`, "
                    "cartella `... -V3`** (NON il piccolo `50503392` in "
                    "`BCM Markets MT5 Terminal`, NON il reale `10105439` in "
                    "`C:\\BCM_Reale`) — l'`ABTG_TradeExporter` gira? e "
                    "`pubblica_trades.ps1` prende `ABTG_Trades_100k.csv`?_", "",
                    "_Per riconoscere la finestra senza andare a occhio "
                    "(regola dei terminali multipli, 06/09), riga di SOLA "
                    "LETTURA:_ `Get-Process terminal64 | select Id, "
                    "MainWindowTitle, Path`", ""]
        else:
            out += ["_Nessuna posizione chiusa oggi sul 100k._", ""]

        margine_tot = saldo - FTMO_PAV_TOTALE
        usato_oggi = max(0.0, -netto_oggi)
        margine_giorno = FTMO_LIM_GIORNO - usato_oggi
        peggior_g = min(perGiorno100.values()) if perGiorno100 else 0.0
        if fresco[CSV_100K]:
            out += ["**Saldo realizzato: %.2f**  (netto di oggi: %+.2f · dal via: %+.2f)" % (
                        saldo, netto_oggi, netto_storico), ""]
        else:
            # Il saldo cumulato resta un fatto vero, ma va DATATO: e' fermo
            # all'ultima consegna, non a stasera. Il "netto di oggi" sparisce.
            d100 = quando[CSV_100K]
            out += ["**Saldo realizzato AL %s: %.2f**  (dal via: %+.2f) — "
                    "⚠️ **fermo all'ultima consegna, non a stasera; il netto di "
                    "oggi NON e' noto.**" % (d100, saldo, netto_storico), ""]
        # La riga della perdita giornaliera: tre casi, scritti in chiaro invece
        # che in un ternario annidato (05/10, seconda limatura del cancello).
        _g100 = giornale_runner("50504263")
        if fresco[CSV_100K]:
            riga_giorno_100k = ("| Perdita giornaliera (-5%%) | -5.000/giorno | "
                                "oggi usati %.2f -> restano **%.2f** |"
                                % (usato_oggi, margine_giorno))
        elif (_g100 and _g100["giorno"] < giorno and _g100["ordini"] == 0
                and (_g100["righe"] or 0) >= SOGLIA_LOG_PIENO):
            riga_giorno_100k = ("| Perdita giornaliera (-5%%) | -5.000/giorno | "
                                "🔴 **NON CALCOLABILE**: nessun EA poteva "
                                "operare; il **terminale** non scrive log dal "
                                "%s — vedi il banner |" % _g100["giorno"])
        else:
            riga_giorno_100k = ("| Perdita giornaliera (-5%) | -5.000/giorno | "
                                "🔴 **NON CALCOLABILE**: dato non arrivato |")
        out += ["| Regola FTMO | Pavimento | Margine attuale |", "|---|---|---|",
                "| Perdita totale (statico -10%%) | 90.000 | **%+.2f** (%.2f%% del conto)%s |" % (
                    margine_tot, 100.0 * margine_tot / DEP_100K,
                    "" if fresco[CSV_100K] else " _(all'ultima consegna)_"),
                riga_giorno_100k,
                "",
                "Peggior giornata dal via: **%+.2f**. _Numeri dal solo REALIZZATO " % peggior_g +
                "(il CSV non vede il floating): l'arbitro vero dei pavimenti resta "
                "il Guardian, che legge l'equity._"]

    # ---------- CONTO REALE (10105439) ----------
    # Terza sezione, 08/09/2026, su richiesta di Claudio: "voglio che monitori
    # automaticamente il conto reale come fai con gli altri".
    #
    # 🔴 QUI SI E' PIU' PRUDENTI CHE ALTROVE, e non e' un vezzo: sugli altri due
    #    conti un numero sbagliato costa una lettura, qui costa dei soldi. Per
    #    questo la sezione, prima di stampare QUALSIASI totale:
    #      1) controlla che ci siano tutte le colonne che le servono;
    #      2) pretende che OGNI riga sia leggibile (date e importi);
    #      3) se anche una sola non lo e', DICHIARA e NON stampa il totale.
    #    Un totale a meta' su un conto vero e' peggio di nessun totale: sembra
    #    un numero, e invece e' un'opinione.
    out += ["", "## 💶 Conto REALE 10105439 — soldi veri", ""]
    if not os.path.exists(CSV_REALE):
        out += ["_CSV del conto reale **non ancora sul repo**: la sezione si accende "
                "da sola quando il file arriva._", "",
                "**Perche' non c'e' (misurato l'08/09/2026):** sul terminale del "
                "reale (`C:\\BCM_Reale`) **non gira nessun `ABTG_TradeExporter`**. "
                "Il censimento dei `.chr` di quel terminale trova tre EA "
                "(`ABTG_DAX_Apertura_EU` 770101, `ABTG_ORB_Ottimizzato` 770611, "
                "`ABTG_SlippageLogger`) e nessun esportatore. Senza esportatore "
                "non esiste `%s` in `Common\\Files`, e `pubblica_trades.ps1` non "
                "ha niente da caricare." % CSV_REALE_MT5, "",
                "> ⚠️ Il censimento legge i `.chr`, cioe' una **foto al salvataggio "
                "del profilo**: e' un indizio forte, non un fatto certo. "
                "Istruzioni per accendere l'esportatore (gesto di Claudio sul "
                "terminale reale): `report/PAGELLA_CONTO_REALE_2026-09-08.md`."]
    else:
        with open(CSV_REALE, encoding="utf-8-sig", newline="") as f:
            lettore = csv.DictReader(f, delimiter=";")
            intestazione = lettore.fieldnames or []
            rreale = list(lettore)
        mancanti = [c for c in COLONNE_MINIME if c not in intestazione]
        if mancanti:
            # 🔴 colonna mancante = niente totale. Dichiarato, non aggirato.
            out += ["> 🔴 **Il CSV del reale non ha le colonne che servono: "
                    "manca%s `%s`.** Su un conto vero non stampo un totale a "
                    "meta': la sezione si ferma qui. Colonne trovate: `%s`."
                    % ("no" if len(mancanti) > 1 else "",
                       "`, `".join(mancanti),
                       "`, `".join(intestazione) if intestazione else "(nessuna)")]
        elif not rreale:
            out += ["_Il CSV del reale c'e' ma e' **vuoto** (solo intestazione): "
                    "nessuna posizione chiusa esportata. Nessun totale da dare._"]
        else:
            # 1) leggibilita' RIGA PER RIGA: date e importi.
            illeggibili = []
            for r in rreale:
                r["_ot"] = tempo(r.get("open_time", ""))
                r["_ct"] = tempo(r.get("close_time", ""))
                r["_num_ok"] = all(leggibile(r, k)
                                   for k in ("profit", "swap", "commission"))
                if not (r["_ot"] and r["_ct"] and r["_num_ok"]):
                    illeggibili.append(r)

            if illeggibili:
                # 🔴 nessun totale finche' non si capiscono: sono soldi veri.
                out += ["> 🔴 **%d rig%s del CSV del reale non %s leggibil%s** "
                        "(data o importo non interpretabile). Su un conto vero "
                        "**non stampo un totale che le salta**: vanno capite "
                        "prima. pid: %s"
                        % (len(illeggibili),
                           "he" if len(illeggibili) > 1 else "a",
                           "sono" if len(illeggibili) > 1 else "e'",
                           "i" if len(illeggibili) > 1 else "e",
                           ", ".join(str(r.get("pid", "?")) for r in illeggibili[:10])),
                        "",
                        "_Il resto della sezione resta spento fino ad allora: "
                        "una sezione muta e' un'informazione, un totale "
                        "sbagliato no._"]
            else:
                # 2) stesso filtro del piccolo: le righe a MAGIC 0 (non di
                #    un nostro EA) stanno FUORI dal totale, ma si
                #    mostrano. Firma di Claudio del 07/09: non e' una regola
                #    "del piccolo", e' come si legge un conto.
                man_reale = [r for r in rreale if fuori_flotta(r)]
                amb_reale = discordi(rreale)
                flotta_reale = [r for r in rreale if not fuori_flotta(r)]

                def _netto_r(r):
                    return num(r, "profit") + num(r, "swap") + num(r, "commission")

                netto_storico_re = sum(_netto_r(r) for r in flotta_reale)
                oggi_re = [r for r in flotta_reale
                           if r["_ct"].strftime("%Y-%m-%d") == giorno]
                netto_oggi_re = sum(_netto_r(r) for r in oggi_re)

                perGiorno_re = defaultdict(float)
                for r in flotta_reale:
                    perGiorno_re[r["_ct"].strftime("%Y-%m-%d")] += _netto_r(r)
                peggior_re = min(perGiorno_re.values()) if perGiorno_re else 0.0

                if oggi_re:
                    perEA_re = defaultdict(list)
                    for r in oggi_re:
                        perEA_re[r.get("strategy") or ("magic " + str(r.get("magic", "?")))].append(r)
                    out += ["| EA | Trade | P&L | Come sono usciti |", "|---|---|---|---|"]
                    for ea, tr in sorted(perEA_re.items(),
                                         key=lambda x: -sum(_netto_r(r) for r in x[1])):
                        motivi = defaultdict(int)
                        for r in tr:
                            motivi[r.get("close_reason") or "?"] += 1
                        out.append("| %s | %d | **%+.2f** | %s |" % (
                            ea, len(tr), sum(_netto_r(r) for r in tr),
                            " · ".join("%s×%d" % (k, v) for k, v in sorted(motivi.items()))))
                    out.append("")
                elif not fresco[CSV_REALE]:
                    # Stessa protezione del 100k, e qui vale di piu': su un
                    # conto con SOLDI VERI uno zero finto non e' una lettura
                    # sbagliata, e' un numero sbagliato. Messa PRIMA che il
                    # CSV arrivi apposta: il file compare nel momento in cui
                    # Claudio accende l'esportatore su C:\BCM_Reale, senza
                    # preavviso, e la finestra fra "arriva" e "c'e' la
                    # protezione" e' l'unica in cui si puo' pubblicare uno
                    # zero falso sul conto vero.
                    out += ["> 🔴 **DATO NON ARRIVATO.** Il CSV del reale ha "
                            "contenuto fermo al **%s**: non posso dire ne' che "
                            "il conto abbia operato, ne' che non l'abbia fatto. "
                            "**Nessun netto di giornata per questo conto.**"
                            % quando[CSV_REALE], "",
                            "_Terminale da guardare: **reale `10105439`, cartella "
                            "`C:\\BCM_Reale`** (NON il piccolo `50503392` in "
                            "`BCM Markets MT5 Terminal`, NON il 100k `50504263` "
                            "in `... -V3`). Riga di SOLA LETTURA per riconoscere "
                            "la finestra:_ `Get-Process terminal64 | select Id, "
                            "MainWindowTitle, Path`", ""]
                else:
                    out += ["_Nessuna posizione chiusa oggi sul reale._", ""]

                if fresco[CSV_REALE]:
                    out += ["**Netto REALIZZATO della flotta sul reale: "
                            "%+.2f** (oggi: %+.2f · su %d operazioni dal via)"
                            % (netto_storico_re, netto_oggi_re, len(flotta_reale)),
                            "",
                            "Peggior giornata dal via: **%+.2f**." % peggior_re]
                else:
                    out += ["**Netto REALIZZATO della flotta sul reale AL %s: "
                            "%+.2f** (su %d operazioni dal via) — ⚠️ **fermo "
                            "all'ultima consegna, non a stasera; il netto di "
                            "oggi NON e' noto.**"
                            % (quando[CSV_REALE], netto_storico_re, len(flotta_reale)),
                            "",
                            "Peggior giornata dal via: **%+.2f** _(all'ultima "
                            "consegna)_." % peggior_re]

                # 🔴 Il SALDO non si stampa: il deposito iniziale del reale non
                #    e' un dato di questo CSV. Inventarlo (come DEP_100K, che
                #    li' e' un fatto del dry-run) sarebbe un numero finto su un
                #    conto vero. Si dice, non si indovina.
                out += ["", "> ⚠️ Qui c'e' il **netto realizzato**, non il saldo: "
                        "il deposito iniziale del reale non sta in questo CSV e "
                        "**non lo invento**. E come per il 100k, il CSV **non "
                        "vede il floating**: l'arbitro dei pavimenti resta chi "
                        "legge l'equity."]

                if man_reale:
                    netto_man_re = sum(_netto_r(r) for r in man_reale)
                    ultima = max(r["_ct"] for r in man_reale).strftime("%Y-%m-%d")
                    out += ["", "### 🚫 Fuori dal totale — operazioni NON della flotta (`magic` 0, reale)", "",
                            "`magic` **0**: non appartengono a nessuna nostra "
                            "sedia (il criterio e' **solo** il magic dal 07/10/2026, qualunque sia il commento). **%d operazion%s, %+.2f** "
                            "(ultima il %s). **Non entrano** nel netto qui sopra "
                            "— stessa regola del piccolo, Claudio 07/09/2026."
                            % (len(man_reale), "i" if len(man_reale) > 1 else "e",
                               netto_man_re, ultima)]
                if amb_reale:
                    out += ["", "> ⚠️ **%d operazion%s col commento VUOTO ma il `magic` "
                            "valorizzato sul CONTO REALE**: sono nostri EA che non "
                            "scrivono il commento, quindi **restano nel totale** ed "
                            "e' giusto. Si elencano per attribuirle: pid %s"
                            % (len(amb_reale), "i" if len(amb_reale) > 1 else "e",
                               ", ".join(str(r.get("pid", "?")) for r in amb_reale[:10]))]

    os.makedirs(OUT_DIR, exist_ok=True)
    dest = os.path.join(OUT_DIR, "giornata_%s.md" % giorno)

    # --- LA PARTE SCRITTA A MANO NON SI TOCCA (09/09/2026, imparata male) ---
    #
    # Questo file lo scrive uno script, ma sotto ci vive anche la "## 🧠 Lettura",
    # che e' scritta a mano ed e' la parte che vale. Il 09/09 due rigenerazioni
    # di PROVA hanno cancellato **282 righe** di analisi da
    # giornata_2026-09-08.md e giornata_2026-09-09.md -- fra cui il calcolo al
    # centesimo della perdita certa da -26,57 sull'oro e la lettura della
    # giornata record -- e il commit se le e' portate via su GitHub.
    # Un `open(..., "w")` su un file dove vive anche testo umano e' una mina.
    #
    # Regola: si ricuce la coda dal marcatore in poi. Se il file esiste ma il
    # marcatore non c'e', NON si sovrascrive alla cieca: si esce e lo si dice.
    MARCATORE = "\n## \U0001f9e0 Lettura"
    # Le intestazioni di secondo livello che questo script genera da solo.
    # Tutto il resto, in un giornata_*.md, l'ha scritto un umano.
    GENERATE = ("## Chi ha operato", "## Netto per simbolo",
                "## ⚠️ Da guardare",
                "## \U0001f4b6 Conto REALE", "## \U0001f550 Freschezza dei dati",
                "## \U0001f6ab Fuori dal totale", "## \U0001f6e1️ Conto 100k",
                "## \U0001f9e0 Lettura")
    coda = ""
    if os.path.exists(dest):
        with open(dest, encoding="utf-8") as f:
            vecchio = f.read()

        # Cintura: una copia di quello che c'era, prima di toccarlo. Costa
        # niente e vale per i casi che non abbiamo previsto.
        if vecchio.strip():
            bdir = os.path.join(OUT_DIR, ".backup")
            os.makedirs(bdir, exist_ok=True)
            with open(os.path.join(bdir, "giornata_%s_%s.md" % (
                          giorno, datetime.now().strftime("%H%M%S"))),
                      "w", encoding="utf-8") as b:
                b.write(vecchio)

        i = vecchio.find(MARCATORE)
        if i >= 0:
            coda = vecchio[i:].strip("\n")

        # La domanda giusta NON e' "c'e' il marcatore?" ma "c'e' qualcosa che
        # questo script non ha scritto?". La prima stesura guardava solo il
        # marcatore e aveva due buchi, tutti e due riprodotti dal
        # controllo-preventivo: (a) cancellava IN SILENZIO le sezioni a mano
        # messe SOPRA il marcatore — e non e' un caso di scuola, oggi
        # giornata_2026-08-21.md ne ha SEI ("I gemelli ORB hanno divergito di
        # nuovo", "Quali EA spegnere oggi", ...); (b) chiedeva --forza per
        # rigenerare due volte lo stesso giorno un file tutto generato, cioe'
        # addestrava a scrivere --forza per abitudine, che e' il modo in cui
        # una guardia smette di guardare.
        orfane = [l for l in (vecchio[:i] if i >= 0 else vecchio).splitlines()
                  if l.startswith("## ") and not any(l.startswith(g) for g in GENERATE)]
        if orfane and "--forza" not in sys.argv:
            sys.exit("%s contiene %d sezion%s scritte a mano FUORI dalla coda "
                     "'## Lettura': rigenerare le perderebbe.\n  %s\n"
                     "Spostale sotto '## Lettura', oppure rilancia con --forza "
                     "se sai quello che fai. (Una copia e' gia' in "
                     "report/.backup/.)" % (
                         dest, len(orfane), "i" if len(orfane) > 1 else "e",
                         "\n  ".join(orfane[:6])))

    with open(dest, "w", encoding="utf-8") as f:
        f.write("\n".join(out) + "\n")
        if coda:
            f.write("\n" + coda + "\n")
    if coda:
        print("\n[i] Coda scritta a mano PRESERVATA: %d righe dal marcatore "
              "'## Lettura' in poi." % (coda.count("\n") + 1))
    print("\n".join(out))
    print("\n-> scritto %s" % dest)


if __name__ == "__main__":
    main()
