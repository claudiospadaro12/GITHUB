#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
R267_GENERA.py -- 27/09/2026 -- genera i 12 file prova del round R267
(le proposte "a costo zero di codice" della caccia parametri del 26/09:
backtest_pipeline/caccia_strategie/CACCIA_PARAMETRI_SEI_FAMIGLIE_2026-09-26.md,
commit 1a2f80ce). ASCII puro.

PERCHE' UN GENERATORE: ogni file R267 e' "la sua base + UNA manopola".
I pin NON si ricopiano a mano: si leggono dal file base (gia' passato dal
cancello), si cambiano SOLO le righe dichiarate qui sotto, e lo script
VERIFICA che le righe cambiate siano esattamente quelle dichiarate (un
pin cambiato in piu' = eccezione, il file non si scrive).

USO:  python3 backtest_pipeline/prove/R267_GENERA.py            (scrive)
      python3 backtest_pipeline/prove/R267_GENERA.py --verifica (non scrive:
            rigenera in memoria e confronta byte per byte col disco)
"""
import os
import sys

QUI = os.path.dirname(os.path.abspath(__file__))


def leggi_pin(base):
    """Le righe dal primo '@' in fondo (direttive + pin) del file base."""
    righe = open(os.path.join(QUI, base), encoding="ascii").read().split("\n")
    i = next(k for k, r in enumerate(righe) if r.startswith("@"))
    corpo = righe[i:]
    while corpo and corpo[-1] == "":
        corpo.pop()
    return corpo


def nome(r):
    return r.split("=", 1)[0].strip() if "=" in r and not r.startswith("@") else None


def applica(base, cambi, inserisci=None):
    """cambi: {input: riga nuova}. inserisci: [(dopo_input, riga nuova)]."""
    corpo = leggi_pin(base)
    nomi = [nome(r) for r in corpo]
    for k in cambi:
        if nomi.count(k) != 1:
            raise SystemExit("R267_GENERA: %s non compare UNA volta in %s" % (k, base))
    nuovo = []
    for r in corpo:
        k = nome(r)
        nuovo.append(cambi.get(k, r) if k else r)
    for dopo, riga in (inserisci or []):
        j = [nome(r) for r in nuovo].index(dopo)
        if riga.split("=", 1)[0] in [nome(r) for r in nuovo]:
            raise SystemExit("R267_GENERA: inserimento doppio di " + riga)
        nuovo.insert(j + 1, riga)
    # CONTROLLO: cambiate SOLO le righe dichiarate, e davvero cambiate
    vecchie = dict((nome(r), r) for r in corpo if nome(r))
    for r in nuovo:
        k = nome(r)
        if not k:
            continue
        dichiarata = k in cambi or k in [x[1].split("=", 1)[0] for x in (inserisci or [])]
        if k in vecchie and vecchie[k] != r and not dichiarata:
            raise SystemExit("R267_GENERA: riga cambiata e NON dichiarata: " + r)
        if k in cambi and vecchie[k] == r:
            raise SystemExit("R267_GENERA: riga dichiarata ma IDENTICA alla base: " + r)
    assi = [r for r in nuovo if r.endswith("||Y")]
    if len(assi) != 1:
        raise SystemExit("R267_GENERA: %d assi Y in un file da %s" % (len(assi), base))
    return nuovo


# =====================================================================
#  LE INTESTAZIONI. Ogni file porta: bersaglio, base, cosa cambia, attesa
#  scritta PRIMA, cancelli, costo, buchi. La parte comune del round sta
#  nella TESTA (R267a, par. 0).
# =====================================================================

BERSAGLIO = """\
#  GIRA SOLO SUL PC DI BACKTEST DESKTOP-H4D7CAJ. MAI SUL VPS (firma di
#  Claudio del 21/09/2026). NE' sul banco 50504400 (C:\\MT5_Backtest,
#  SPENTO), NE' su nessun terminale di conto: 50503392, 50504263,
#  10105439 (REALE), 541452707 (FTMO). Il terminale del PC e' loggato sul
#  demo 50503392: prima si controlla che non abbia SEDIE attaccate
#  (avvertenza di R246/R255). QUESTO FILE NON CONTIENE E NON AUTORIZZA
#  NESSUNA RIGA DI LANCIO. Non tocca EA, preset, sedie, conti, taglie o
#  forward, e non promuove niente: ogni esito e' materiale per Claudio."""

TESTA_COMUNE = """\
# =====================================================================
#  0. IL ROUND R267 -- PARTE COMUNE A TUTTI I 12 FILE (qui e solo qui)
# =====================================================================
#  ORIGINE: Claudio, 26-27/09/2026: "NON FERMIAMOCI DAVANTI A QUALCHE
#  PARAMENTRO BASSO. SI CERCA SUL WEB SE QUALCHE PARAMETRO C'E' DA
#  MIGLIORARE." La caccia (CACCIA_PARAMETRI_SEI_FAMIGLIE_2026-09-26.md,
#  commit 1a2f80ce) ha mappato 14 proposte sui nostri input. R267 scrive
#  in FILE PROVA quelle che girano a ZERO righe di codice e che non
#  dipendono da un round non ancora girato. Un file = UNA manopola.
#  Ogni numero della caccia qui e' citato come [SONDA OANDA, screening]
#  (Oanda M1 2015-01 -> 2020-05, OHLC, niente BCM, niente 2021-2026) o
#  [DICHIARATO dal vendor]: MAI come misura di casa.
#
#  I 12 FILE (tutti generati da prove/R267_GENERA.py, pin DIFFATI dallo
#  script contro la base, non ricopiati a mano):
#   file    EA / simbolo / TF          base      manopola (asse)            celle magic
#   R267a   MaxMinNotte XAUUSD H2 OHLC R260c     InpNewsFlatten 0/1 (news)  2  796701  NON LANCIARE
#   R267b   MaxMinNotte XAUUSD H2 OHLC R260c     InpMinBoxPts 0..2600       5  796702
#   R267c   Dow_Apertura U30USD M5 tick R255a    InpCloseHour 16/17 (:00)   2  796711
#   R267d   Dow_Apertura U30USD M5 tick R255a    InpVolMult 0..2,0 (vol ON) 5  796712
#   R267e1  EMA200 GBPJPY H4 tick      R264c     InpUseAdrFilter 0/1        2  796721
#   R267e2  EMA200 XAUUSD H4 tick      R264d     InpUseAdrFilter 0/1        2  796722
#   R267f1  EMA200 GBPJPY H4 tick      R264c     InpFridayClose 0/1         2  796731
#   R267f2  EMA200 XAUUSD H4 tick      R264d     InpFridayClose 0/1         2  796732
#   R267g1  MaxMinNotte D30EUR M15 tick R261a    InpCorrTF H4..D1 (DAX)     5  796741
#   R267g2  MaxMinNotte D30EUR M15 tick R261a    InpUseTrailing 0/1         2  796742
#   R267g3  MaxMinNotte D30EUR M15 tick R261a    InpBreakeven 0/1           2  796743
#   R267g4  MaxMinNotte D30EUR M15 tick R261a    InpTP1Pct 0..75            4  796744
#  35 celle, 70 passate per il conto del cancello (celle x 2 finestre);
#  finestre PIENE vere: 35 (i file a moncone hanno una gamba di 1 giorno,
#  i DAX hanno @FRAZIONEIS 1.0 e la gamba OOS degenere).
#
#  LA REGOLA DI LETTURA CHE VALE PER TUTTI (classi 455 e 850): il magic
#  e' FISSO nei file R267 (l'asse e' la manopola), quindi il per-trade
#  abtg_trades_<EA>_<SIM>_<magic>.csv lo riscrive ogni passata: ne resta
#  UNO, gamba lunga, e QUALE CELLA sia NON E' FISSATO (l'ordine di FINE
#  delle passate non e' garantito: classe 850, corretta dal cancello del
#  27/09 su tutti i file R267). Il per-trade quindi si IDENTIFICA prima
#  di leggerlo: righe = Trades di UNA riga del CSV _OOS e somma dei net
#  = Profit di quella riga (U30USD entro 0,05, commissione misurata
#  0,000; D30EUR [NON MISURATA]: se non torna entro 0,05 si usa il k;
#  XAUUSD e forex: k = (somma net - Profit) / somma volumi in [1,00 ;
#  3,00] EUR/lotto, classe 844). La cella che il file ASPETTA -> si legge
#  come scritto. UN'ALTRA cella -> si scrive quale, e i cancelli sul
#  per-trade si leggono su QUELLA cella (soglie d'ora e di valore prese
#  dalla cella identificata) o, dove il file lo dice, non si fanno: MAI
#  il file NULLO per questo. NULLO solo se il per-trade non corrisponde
#  a NESSUNA cella. Celle identiche (manopola inerte) = indifferente.
#  Il per-trade ha SOLO close_time: nessuna ora d'APERTURA (classe 847).
#  Nessun criterio R267 chiama "n" la colonna Trades: e' [DEAL] (454).
#  L'ANCORA G0 DI OGNI FILE: dove la manopola ha un valore INERTE, quella
#  cella sta DENTRO il file e deve rifare la base al centesimo (il magic
#  non entra nel trading: provato dai G1 di R255/R260/R264). Dove non ce
#  l'ha (R267c, R267g1) il G0 e' la base stessa, girata PRIMA nello
#  stesso giro, piu' un controllo di struttura scritto nel file.
#
#  MAGIC, VERGINI -- cercati il 27/09/2026, comandi eseguiti:
#     grep -rIE --exclude-dir=.git -o "\\b7967[0-9]{2}\\b" /home/user -> 0
#     git grep -E "\\b7967[0-9]{2}\\b" $(git for-each-ref --format=
#        '%(refname)' refs/heads refs/remotes)                   -> 0
#  (7968xx scartato: 11 occorrenze sui rami remoti.) Anche "R267" non
#  compariva ne' sul disco ne' su nessun ramo prima di questi file.
#  Esclusi per mandato: 7704xx (sedie), 7931xx (R255), 7925xx, 7926xx.
#
#  IL COSTO, FILE PER FILE (metri dichiarati, nessuno inventato):
#   metro OHLC oro ~0,7 min/passata (dal mandato; r151a sul banco VPS
#     dava 20,4 s: la velocita' del PC su oro OHLC e' [NON MISURATA]);
#   metro tick U30USD 0,333 min/passata (dal mandato) e 93-102 s per un
#     file R255 da 2 celle (R255a par. 14, stesso PC, stesso carico);
#   metro tick 135 s/passata: MISURATO su R240 (U30USD H1 tick, ALTRO
#     EA, stesso PC; prove/R214f par. 7), NON sull'EMA200 H4: su GBPJPY/
#     XAUUSD a tick e' [NON MISURATO] (classe 751). Lo misura il G0
#     R264c/d, che gira PRIMA (ordine sotto): li' si rilegge il tetto;
#   metro tick D30EUR M15 0,28-0,70 min per finestra piena (R261 par. 9).
#     R267a  0 (NON LANCIARE; sbloccato: vedi par. 6 -- costo APERTO)
#     R267b  5 finestre piene x 0,7        = ~3,5 min (+ avvio)  ~4-5 min
#     R267c  2 celle, carico di un file R255             ~1,3-1,7 min
#     R267d  5 celle (2,5 volte R267c)                    ~3,3-4,3 min
#     R267e1/e2/f1/f2  2 finestre piene x 135 s = 4,5 min x 4 = ~18 min
#     R267g1-g4  13 finestre piene x 0,28-0,70           ~3,6-9,1 min
#   TOTALE LANCIABILE (senza R267a): ~30-38 MINUTI. TETTO LARGO 2 ORE:
#   oltre, ci si ferma e si guarda (caso lento del 21/09). ESCLUSI dal
#   totale i G0 ESTERNI (R255a, R261d/c/a, R264c/d): sono dei loro round;
#   se non sono gia' girati si aggiungono, e girano PRIMA.
#   EMA200: con 4 simboli x 2 manopole sarebbero 8 file = ~36 min, sopra
#   i ~10 min chiesti -> SOLO GBPJPY e XAUUSD (par. 0 di R267e1). E anche
#   cosi' sono ~18 min: dichiarato, e spezzato in due onde da ~9 min.
#
#  ORDINE CONSIGLIATO (le basi PRIMA, perche' sono i G0):
#   1. R267b  (la sedia piu' vicina al campo; auto-ancorata a R103)
#   2. R255a -> R267d -> R267c  (Dow: R255a e' il G0 di tutti e due)
#   3. R261d -> R261c -> R261a -> R267g2, g3, g4, poi R267g1 (DAX)
#   4. R264c -> R267e1, R267f1  (GBPJPY, onda da ~9 min)
#   5. R264d -> R267e2, R267f2  (XAUUSD, onda da ~9 min)
#   6. R267a: NON LANCIARE finche' il suo par. 6-A non e' chiuso.
#
#  COSA R267 NON SCRIVE, E PERCHE' (lo stesso elenco sta in REGISTRO_TEST):
#   - P6 VWAP di lato sul Dow: SCARTATA PER COSTRUZIONE. VwapBias()
#     (ABTG_Dow_Apertura_US.mq5 r.1464-1485) somma le barre con lo STESSO
#     GIORNO del server, cioe' dalla mezzanotte BCM: alle 15:05 BCM la
#     "VWAP" contiene ~15 ore di notte e pre-mercato. Non e' la VWAP della
#     seduta cash che la proposta intendeva: misurarla darebbe un numero
#     su un'altra cosa. Serve codice (ancora all'ora d'apertura).
#   - P3 trend dell'oro come cancello: e' R260d, di un altro agente. Qui
#     NON si scrive. Solo la nota del prior (par. 6).
#   - P9a InpCloseAtCutoff e P9b AUDNZD/AUDCAD (Nightly): in coda DOPO
#     R259, che non e' ancora girato (le celle sarebbero una casella su
#     un banco non ancora letto).
#   - P8 (London breakout sul box asiatico via MaxMinNotte): e' R266,
#     di un altro agente, gia' in coda. P7 (Londra, blocco S di R258):
#     non in questo mandato; R258 non e' ancora girato.
#   - Stop in ATR sull'oro (InpSLMode=1): gia' CADUTO in casa A BUFFER
#     200, vicino al pin 250 (oro_maxmin_fase1_*.csv: DD 9,3-26,5% contro
#     3,7-5,7%; caccia par. 0 punto 2).
#   - Ampiezza del box in ATR, ADX/pendenza EMA: servono input nuovi
#     (codice), fuori da "costo zero"."""

HEAD_A = """\
#  EA: ABTG_MaxMinNotte
# =====================================================================
#  R267a -- ORO 770402: IL FILTRO NOTIZIE USD (blocco / chiusura)
#  EA: ABTG_MaxMinNotte (generico, due lati), XAUUSD H2, OHLC M1
#  FILE DI TESTA DEL ROUND R267 (par. 0, parte comune) e cella R267a.
#
#  >>> CANCELLO: NON LANCIARE. <<<  Il file e' scritto e passa il
#  cancello meccanico, ma nel tester IL FILTRO NON VEDE IL FILE NEWS
#  (par. 6, letto nel sorgente, e gia' pagato due volte in casa). Se si
#  lancia cosi', le due celle escono IDENTICHE a R260c e sembrera' che
#  "le notizie non contano": sarebbe una misura del NULLA.
#
""" + BERSAGLIO + """
#  VINCOLI DI BANCO (stanno nella riga, non qui): -Deposito 100000,
#    -Modello 1 (OHLC M1), niente -Spread/-Ritardo/-FrazioneIS: identici
#    a R260c (prove/R260c_oro_770402_due_lati_ancora.txt, testa di R260).
#  Scritto il 27/09/2026. Attese e soglie CONGELATE PRIMA DEI NUMERI.
""" + TESTA_COMUNE + """
#
# =====================================================================
#  1. LA DOMANDA
# =====================================================================
#  Il tappo della sedia 770402 NON e' il PF (R103: 1,308 su 693 deal),
#  e' il DD alla taglia: 5,32% a 0,5% -> 19,6-21,3% a 2,00% (R260c par.
#  8), e per stare sotto S3 di R193b servirebbe DD a 0,5% <= 2,06%. La
#  caccia (par. 3.3, P1) propone di chiudere/bloccare sulle notizie USD:
#  la posizione resta aperta fino alle 17:30 BCM, cioe' ATTRAVERSO i dati
#  USA delle 8:30 ET. Fonti [DICHIARATE dai vendor, nessun numero]: Range
#  Breakout Day Trader (chiusura N' prima), Range Breakout Beast (3'/3').
#
# =====================================================================
#  2. BASE, E COSA CAMBIA (diff eseguito da R267_GENERA.py)
# =====================================================================
#  BASE = R260c (DUE LATI = la cella R103 = la sedia come e' schierata).
#  Perche' R260c e non R260a (solo long): il tappo e' il DD della SEDIA,
#  che su FTMO e' a due lati; e il long da solo e' una domanda APERTA
#  (R260a, non girato): partire da li' impilerebbe due incognite.
#  Cambiano SOLO:
#    InpUseNewsFilter    false -> true
#    InpNewsFile         abtg_news.csv -> abtg_news_2021_2025_UTC.csv
#    InpNewsCurrencies   (omesso nella base) -> USD
#    InpNewsShiftMinutes 0 -> 60 (il file e' in UTC; par. 6-C)
#    InpNewsFlatten      true (pin) -> ASSE 0/1
#    InpComment MAXMINR267A, InpMagic 796701 fisso (niente gemelle)
#  Restano: InpNewsMinImpact 3, InpNewsBeforeMin 30, InpNewsAfterMin 30.
#  COSA FA IL CODICE (ABTG_MaxMinNotte.mq5 a HEAD 7d0da9f9, letto):
#    r.250-251 newsBlk ad ogni tick; con InpNewsFlatten=true cancella i
#      pendenti E CHIUDE la posizione; r.276 con newsBlk non PIAZZA.
#    Cella 0 (blocca): tocca SOLO il piazzamento delle 07:00 BCM.
#    Cella 1 (chiude): chiude le posizioni vive a [evento-30', evento+30'].
#
# =====================================================================
#  3. L'ATTESA, SCRITTA PRIMA (vale SOLO a par. 6 chiuso)
# =====================================================================
#  MISURATO QUI sul file news (script, 27/09): 2971 eventi, tutti High;
#  2311 USD. Ora UTC degli eventi USD: 12h 629, 13h 548, 14h 475, 15h
#  248, 18h 157, 17h 85, 11h 61, 19h 51, 16h 36 -- e alle 06h UNO solo
#  in 5 anni. I feriali 2021.01.04-2025.12.19 con un evento USD fra le
#  11 e le 16 UTC sono 804 su 1295 = 62,1%.
#  CELLA 0 (blocca): alle 07:00 BCM (06:00/07:00 UTC) c'e' UN evento USD
#    in 5 anni -> ATTESA: identica a R260c salvo al piu' UNA giornata
#    (Trades 693 +-3, PF entro 0,005). E' anche l'ANCORA in-file.
#  CELLA 1 (chiude): agisce sul 62% dei feriali, su ogni posizione ancora
#    viva all'ora del dato, ~12-17 BCM (i runner). Tre esiti, una
#    PARTIZIONE:
#    LEVA      PF >= 1,20 E DD <= 0,75 x DD(cella 0)
#    TAGLIA    PF < 1,20 (chiude proprio i giorni grossi, che sono i
#              vincenti: rischio scritto dalla caccia par. 10.3)
#    NULLA     il resto (PF >= 1,20 e DD > 0,75 x DD(cella 0))
#    Previsione mia: TAGLIA. Motivo: il PF di R103 sta nei runner (TP2 a
#    2,5R, target EMA200, TP finale 4R) e i runner sono vivi a meta'
#    giornata. [NESSUNA MISURA DI CASA sul verso: e' una previsione.]
#  PRIOR DI UN'ALTRA MISURA, SCRITTO PERCHE' CONTRADDICE UN FILE VICINO:
#    la sonda della caccia (par. 2.3) [SONDA OANDA, screening, 2015-2020,
#    uscita semplificata, n piccoli] trova sul LONG CONTRO il trend D1
#    (EMA14 < EMA100) E +0,179 R (n 54, t +1,78, PF 1,88) e sul long A
#    FAVORE del trend E -0,031 R (n 97, PF 0,89). R260d (file di un altro
#    agente: il trend dell'oro come cancello, NON scritto qui) e questa
#    sonda SI CONTRADDICONO: IL ROUND DECIDE, non questa nota.
#
# =====================================================================
#  4. I CANCELLI (congelati prima; si citano come N<n> [R267a])
# =====================================================================
#  N0 PRONTO: par. 6-A chiuso per iscritto. Altrimenti NON si lancia.
#  N1 CANARINO NEL LOG (InpVerbose=true, pinnato) -- SI LEGGE SOLO IN
#     TEST SINGOLO, PRIMA del round. Il driver scrive sempre
#     Optimization=1 (walkforward_generico.ps1) e in ottimizzazione
#     Print() non esiste (classi 526 e 847): nella corsa del round la
#     riga NON C'E' e la sua assenza non dice niente. Nella passata
#     singola (la cella della via A2, o una cella dopo A1) Log r.210
#     deve stampare "[MaxMinNotte] news caricate: N." (LoadNews r.798)
#     con N = 2971, o 2972 se la riga d'intestazione "Data Ora;..."
#     passasse lo StringToTime [NON VERIFICATO; innocua: impatto 0, non
#     supera InpNewsMinImpact 3]. Se stampa "file news non trovato:
#     filtro di fatto spento." -> NON SI LANCIA. Nella corsa ottimizzata
#     il canarino e' N3, non il log.
#  N2 G0 IN-FILE: cella 0 contro R260c/R103 (Trades 693, PF 1.308, DD
#     5.32, Profit 24736) entro UNA giornata (par. 3). Se no -> NULLO.
#  N3 LA MANOPOLA MORDE: cella 1 con Profit diverso dalla cella 0. Uguali
#     al centesimo = il filtro non ha visto niente -> NULLO.
#  N4 MERITO: 693 deal ~512 posizioni: si legge. RISCHIO: DD a 0,5%
#     contro la soglia 2,06% di R260c par. 8 (DD OHLC = LIMITE INFERIORE).
#  N5 NESSUNA CELLA SI PROMUOVE: una LEVA diventa una proposta a Claudio
#     con la riprova a tick sulla coda 2024.07.05 -> 2026.06.30.
#
# =====================================================================
#  5. LA FINESTRA
# =====================================================================
#  Identica a R260c: @DAQUANDO 2019.12.30, @FINOA 2026.06.30,
#  @FRAZIONEIS 0.0005 -> moncone di 1 giorno + OOS 2020.01.01-2026.06.30
#  (= R103). Si legge SOLO il CSV _OOS.
#
# =====================================================================
#  6. PERCHE' NON SI LANCIA -- UN DIFETTO BLOCCANTE, DUE BUCHI, UN COSTO
# =====================================================================
#  A (BLOCCANTE, il canale). LoadNews (r.777-799) apre il file con
#    FileOpen(InpNewsFile, FILE_READ|FILE_CSV|FILE_ANSI, ';'): SENZA
#    FILE_COMMON, e l'EA NON ha "#property tester_file" (grep: zero
#    righe). Nel tester ogni agente ha la SUA sandbox MQL5\\Files e il
#    driver di casa non ci copia niente (walkforward_generico.ps1 copia
#    solo Experts e Include, r.1886-1912). Quindi FileOpen fallisce,
#    LoadNews logga "file news non trovato" e il filtro SI SPEGNE DA
#    SOLO. NON e' un'ipotesi: e' il difetto gia' pagato su ABTG_PostNews
#    (REGISTRO_TEST, "IL CANALE", 4 CSV a Trades 0) e su ABTG_FiboH4_
#    Multi (commento r.105-110, corretto con InpNewsCommon/FILE_COMMON).
#    VIE D'USCITA, per nome:
#     (A1) CODICE: aggiungere a ABTG_MaxMinNotte l'apertura in Common\\
#          Files come FiboH4_Multi (InpNewsCommon, default true, ripiego
#          sulla sandbox). E' una modifica all'EA della sedia 770402: non
#          e' "costo zero", passa dai cancelli ed e' una scelta di
#          Claudio. Con quell'input nuovo questo file va RIGENERATO (un
#          pin in piu').
#     (A2) COSTO ZERO, MAI PROVATA IN CASA: copiare a mano il CSV nella
#          sandbox dell'agente del PC (...\\Tester\\Agent-127.0.0.1-300x\\
#          MQL5\\Files\\) prima del job, e lanciare UNA cella in test
#          singolo per leggere il canarino N1. R93_CRITERI par. 8
#          (piano B, punti 1 e 3) elenca due varianti VICINE -- il CSV
#          nella cartella Files del TERMINALE + test singolo; un solo
#          agente --, MAI misurate. [NON VERIFICATA]
#  B (BUCO, la copertura). Il file news copre 2021.01.04 -> 2025.12.19;
#    la finestra di R103 e' 2020.01.01 -> 2026.06.30. Sui ~18,5 mesi
#    fuori (tutto il 2020 e 2025.12.20-2026.06.30), cioe' ~24% dei 78
#    mesi, la cella 1 opera IDENTICA alla cella 0: l'effetto misurato
#    e' DILUITO verso zero. Accettato per tenere il G0 contro R103.
#  C (BUCO, l'orologio). Lo shift e' UNO per tutta la corsa (+60). Il
#    feed forex BCM era ora italiana - 1 fino a dic. 2024 e UTC+1 fisso
#    dopo (OROLOGIO_BCM_2026-09-24.md; per l'oro [INFERITO] = forex):
#    +60 e' GIUSTO d'estate e dal 2025, SBAGLIATO di un'ora negli inverni
#    2021-2024 (~20 dei ~60 mesi coperti). Li' la finestra [ev-30, ev+30]
#    cade a [ev+30, ev+90]: la chiusura avviene DOPO il dato, non prima.
#    0 sarebbe sbagliato su ~40 mesi: +60 e' il minore dei due errori.
#  D (COSTO APERTO). InNewsBlackout (r.810-821) scorre TUTTI i 2971
#    eventi a OGNI tick, con uno StringFind per evento: su ~13 milioni di
#    tick OHLC a passata sono ~10^10 iterazioni. Il tempo per passata e'
#    [NON STIMATO]: potrebbe essere di molte volte il metro 0,7 min. La
#    prima cella in test singolo (A2) lo misura.
#
# =====================================================================
#  7. BUCHI NON LEGATI AL CANALE
# =====================================================================
#  OHLC: DD limite inferiore. Spread [NON PINNATO DA QUESTA CORSIA]
#  (classe 394, come R260c). Commissione FTMO oro [NON MISURATA].
#  InpNewsBeforeMin/AfterMin 30/30 NON sono ad asse (una variabile).
# ====================================================================="""

HEAD_B = """\
#  EA: ABTG_MaxMinNotte
# =====================================================================
#  R267b -- ORO 770402: AMPIEZZA MINIMA DEL BOX (il ripiego senza codice
#           del filtro d'ampiezza "relativo" dei vendor)
#  EA: ABTG_MaxMinNotte (generico, due lati), XAUUSD H2, OHLC M1
#  La parte comune del round (magic, costi, ordine, cosa non si scrive)
#  sta in prove/R267a_news_oro_770402.txt par. 0.
""" + BERSAGLIO + """
#  VINCOLI DI BANCO (nella riga): -Deposito 100000, -Modello 1 (OHLC M1),
#    niente -Spread/-Ritardo/-FrazioneIS: identici a R260c.
#  Scritto il 27/09/2026. Attese e soglie CONGELATE PRIMA DEI NUMERI.
# =====================================================================
#
#  1. DOMANDA. Tre fonti pubbliche mettono un'ampiezza MINIMA al box
#  (GoldLondonBreakout 0,15-0,70 x ATR D1, code/75586; Range Breakout
#  Beast 0,10-0,50% del prezzo; nsclk 10-100 pip) [DICHIARATO, nessun
#  numero]. La versione giusta (in ATR) e' CODICE (2 input nuovi). Qui
#  il ripiego a costo zero: InpMinBoxPts in PUNTI ASSOLUTI (r.122, test
#  r.331: box < soglia -> niente trade quel giorno).
#
#  2. BASE = R260c (due lati = R103 = la sedia schierata; stesso motivo
#  di R267a par. 2). Cambiano SOLO: InpMinBoxPts 0 -> ASSE 0..2600 passo
#  650 (0 / 650 / 1300 / 1950 / 2600 punti = 0 / 6,50 / 13,00 / 19,50 /
#  26,00 $, punto XAUUSD = 0,01 $: il buffer 250 = 2,50 $ di R260c),
#  InpComment MAXMINR267B, InpMagic 796702 fisso.
#
#  3. PERCHE' QUESTI CINQUE VALORI (ragionati, non una griglia fitta).
#  Lo stop del long con InpSLMode=0 e' buyPx - sellPx = BOX + 2 x buffer
#  = BOX + 5,00 $ (TryPlace r.336-337 e SLforLong r.374-380). Allora il cancello
#  di costo di casa "stop >= 40 x costo" si traduce in un box minimo:
#    0     = ANCORA G0 (filtro spento, = R260c = R103 al centesimo)
#    650   sopra la frontiera 40x del costo BCM: 0,2503 $ x 40 = 10,01 $
#          di stop -> box >= 5,01 $ (MAPPA_COSTO_SIMBOLI_TF r.242)
#    1300  = ESATTAMENTE la frontiera 40x dello spread FTMO (0,45 $ x 40
#          = 18 $ di stop -> box >= 13,00 $; spread FTMO [MISURATO GG=1,
#          ora 10], MAPPA r.623). La sedia vive su FTMO.
#    1950  frontiera FTMO con commissione [IPOTESI della caccia: 0,10 $
#          -> 0,55 $ x 40 = 22 $ -> box >= 17 $] piu' un margine
#    2600  ~P25 del box 2025-26 (sotto), = il 2500 proposto dalla caccia
#  E' anche la risposta a "la cella verde per caso": cinque valori con
#  una ragione ciascuno, letti come CURVA, mai come picco.
#
#  4. LA DISTRIBUZIONE DEL BOX, E IL FATTO DI REGIME DA DICHIARARE.
#  (a) 2025-2026, MISURATA in casa (script 27/09 su risultati_archivio/
#      MaxMin_Oro/ABTG_Notte_Study_XAUUSD.csv, 371 notti 2025.02.28 ->
#      2026.08.04, box 22:00-06:59, PIU' LARGO del preset 23:00-04:59):
#      P5 1334 . P10 1685 . P25 2609 . P50 4156 . P75 6044 . P90 8666.
#      Quota sotto soglia: 650 -> 0,3% . 1300 -> 4,6% . 1950 -> 14,8% .
#      2600 -> 24,3%. Col box VERO (piu' corto) queste quote sono un
#      PAVIMENTO [DERIVATO].
#  (b) 2015-2020 [SONDA OANDA, screening] (caccia par. 2.3): stop mediano
#      10,26 $ e il 94,5% degli stop < 18 $ = il 94% dei giorni sarebbe
#      ESCLUSO PER COSTO a FTMO. Stop = box + 5 $, quindi box mediano
#      ~5,3 $ [DERIVATO] (la caccia arrotonda a "box ~10 $").
#  (c) 2020-2024: [NON MISURATO]. E' il pezzo che pesa di piu' in R103
#      (~5 anni su 6,5).
#  >>> CONSEGUENZA, detta prima: in punti ASSOLUTI il filtro SELEZIONA
#      L'EPOCA prima che il giorno. A 1300 e sopra tiene [DERIVATO] quasi
#      solo il 2024-2026. Un PF che sale col filtro puo' essere SOLO il
#      mix d'epoca. Per questo il par. 6 legge DENTRO un'epoca.
#
#  5. L'ATTESA SUL NUMERO DI OPERAZIONI (DEAL, classe 454), scritta prima:
#     cella 0 = 693 esatto (G0). 650: 450-620. 1300: 250-400.
#     1950: 180-300. 2600: 140-260. [DERIVATO LARGO dal par. 4: tagli
#     del 40-55% (650) e 85-95% (1300) sui giorni 2020-2023, pavimenti
#     del par. 4a sul 2025-26.] 150 posizioni = ~203 deal (k = 693/512 =
#     1,354, R103): sopra, il MERITO si legge; sotto, SOSPESO.
#
#  6. IL MERITO -- TRE IPOTESI, UNA PARTIZIONE, LETTE DENTRO UN'EPOCA.
#  Dal per-trade di R260c (magic 795303, 6,5 anni) e da quello di questo
#  file, IDENTIFICATO come dice R267a par. 0 (classe 850: la cella che
#  sopravvive NON e' fissata; oro = regola del k, classe 844). Sia S la
#  soglia della cella identificata. Nella finestra 2024.01.01 ->
#  2026.06.30 (data di CHIUSURA) le posizioni di R260c si dividono in
#  TENUTE (stessa data e stesso close_time presenti nel per-trade della
#  cella S) e TOLTE (box < S). Tarata su S = 2600; S = 1950 o 1300 si
#  legge uguale, con meno TOLTE; S = 650 o 0 -> TOLTE quasi vuote o
#  vuote: NON MISURABILE (si scrive con S e n). PF per posizione delle
#  due, dallo STESSO file R260c (stesse taglie, stessa curva):
#    H_GIORNO   PF_tenute >= PF_tolte + 0,30  (il box stretto e' un
#               giorno peggiore anche a parita' d'epoca: il filtro e' una
#               leva vera)
#    H_EPOCA    |PF_tenute - PF_tolte| < 0,30  (il filtro sceglie solo
#               l'epoca; il PF dell'insieme si muove per il mix)
#    H_ROVESCIO PF_tolte >= PF_tenute + 0,30
#    Con n_tolte < 30 posizioni: NON MISURABILE (si scrive con n).
#  Previsione mia: H_EPOCA. Motivo: la sonda (caccia par. 2.3) da' il
#  quintile piu' stretto E -0,132 R ma a t -0,81 = rumore; e la banda del
#  vendor tagliava il 9% e non cambiava niente [SONDA OANDA, screening].
#  0,30 di PF: dell'ordine di uno scarto tipo del PF a n 30-60 per parte
#  [DERIVATO, NON simulato]: e' un INDIZIO, non un certificato.
#  Senza R260c girato (e il suo per-trade 795303) questa lettura e' NON
#  MISURABILE: restano B3-B5 sul CSV.
#  PRIOR SUL TREND (stessa nota di R267a par. 3): long CONTRO il trend D1
#  E +0,179 R, A FAVORE -0,031 R [SONDA OANDA, screening]. R260d (altro
#  agente, trend come cancello, NON scritto qui) e questa sonda si
#  contraddicono: il round decide.
#
#  7. I CANCELLI (congelati prima; si citano come B<n> [R267b])
#  B0 -SoloControllo: 5 celle per finestra. Altrimenti STOP.
#  B1 G0 IN-FILE, cella 0 contro R103 con le bande di R260c R1: VERDE =
#     Trades 693, PF che arrotonda a 1.308, Profit a 24736, DD a 5.32;
#     GIALLO = Trades 693 e |Profit - 24736| <= 1%; ROSSO il resto. Se
#     R260c e' gia' girato: cella 0 == R260c AL CENTESIMO (il magic non
#     tocca il trading). ROSSO -> le celle si leggono SOLO fra loro, mai
#     contro R103; cause concorrenti per nome come R260c R1 (guardia,
#     spread in memoria, storico M1).
#  B2 P0: la colonna InpMinBoxPts del CSV _OOS = 0/650/1300/1950/2600.
#  B3 MORDE E TOGLIE SOLTANTO: Trades(2600) < Trades(0) (altrimenti il pin
#     non e' arrivato -> NULLO), e Trades non crescente con la soglia
#     (una giornata tolta non ne crea un'altra: un ciclo al giorno,
#     InpCloseAtEnd). Una violazione > 2 deal = NON LEGGIBILE (i deal di
#     parziale dipendono dal lotto, da cui la tolleranza).
#  B4 RISCHIO, a qualunque n (Emendamento B): DD a 0,5% di ogni cella
#     contro 2,06% (soglia S3 di R193b tradotta, R260c par. 8). Un DD che
#     scende IN PROPORZIONE a n (meno giorni, meno anni esposti) NON e'
#     una leva: si scrive accanto il rapporto DD(cella)/DD(0) e
#     Trades(cella)/Trades(0). OHLC = DD limite inferiore.
#  B5 ALTOPIANO, MAI IL PICCO: si porta avanti (se mai) la cella CENTRALE
#     di un tratto di >= 3 celle contigue che passano B4 e hanno PF >=
#     1,10 con >= 203 deal. Una cella che sporge = "NON C'E' UNA
#     CONFIGURAZIONE ROBUSTA". Se nessuna batte la cella 0 oltre 0,10 di
#     PF, la frase e' "IL DEFAULT (filtro spento) VA BENE".
#  B6 NESSUNA CELLA SI PROMUOVE: materiale per Claudio, con riprova a tick.
#
#  8. FINESTRA: identica a R260c (moncone 1 giorno + OOS 2020.01.01 ->
#  2026.06.30). Si legge SOLO il CSV _OOS.
#
#  9. COSTO: 5 finestre piene x ~0,7 min + 5 monconi + avvio = ~4-5 MIN
#  (metro OHLC oro del mandato; la velocita' del PC su oro OHLC e' [NON
#  MISURATA]).
#
#  10. BUCHI: box 2020-2024 [NON MISURATO]; il filtro in PUNTI non e'
#  quello in ATR dei vendor (serve codice); InpMaxBoxPts non e' ad asse
#  (una variabile); OHLC; spread [NON PINNATO DA QUESTA CORSIA] come
#  R260c; per-trade di UNA sola cella (classi 455/850): la lettura per anno
#  delle altre quattro celle NON esiste.
# ====================================================================="""

HEAD_C = """\
#  EA: ABTG_Dow_Apertura_US
# =====================================================================
#  R267c -- DOW SHORT (motore della 770202, lato SHORT): USCITA A TEMPO
#  EA: ABTG_Dow_Apertura_US, U30USD M5, TICK REALI
#  La parte comune del round sta in prove/R267a_news_oro_770402.txt par. 0.
""" + BERSAGLIO + """
#  VINCOLI DI BANCO (nella riga, classe 692): identici a R255a:
#    -Deposito 10000, -Modello 4 (tick reali), MaxBars 100000000, niente
#    -Spread/-Ritardo/-FrazioneIS. Modello di riga = RIGA_R252 (moncone,
#    rc 2 e rc 0 ammessi se il CSV _OOS ha 2 righe con Trades > 0).
#  Scritto il 27/09/2026. Attese e soglie CONGELATE PRIMA DEI NUMERI.
# =====================================================================
#
#  1. DOMANDA. L'unica uscita pubblica che R255 non ha: lo stop a tempo
#  a open+90' (ORB V2, mql5.com/en/blogs/post/751385: ordini chiusi alle
#  18:00 server con apertura 16:30 = 90' [DICHIARATO, 1 anno di dati]).
#
#  2. BASE = R255a (SHORT, ancora, orologio 14:30 = la 770202 a lati
#  invertiti, EMA H4 acceso): testa del ragionamento in
#  prove/R255a_short_DOW_ancora_1430.txt. Cambiano SOLO:
#    InpCloseMin   30 -> 0
#    InpCloseHour  17 -> ASSE 16/17  (celle 16:00 e 17:00 BCM)
#    InpMagic      asse gemello -> 796711 fisso
#  COSA SONO LE DUE CELLE (orologio BCM UTC+1 fisso, R255a par. 6):
#    16:00 BCM = open cash + 90' D'ESTATE USA (14:30 = 9:30 EDT);
#              d'inverno USA = 10:00 EST = cash + 30'.
#    17:00 BCM = cash + 150' d'estate; D'INVERNO = 11:00 EST = cash + 90'.
#  Cioe' sul file 14:30 ogni cella e' "cash + 90'" in UNA stagione.
#  La base (17:30) NON e' nell'asse: il suo G0 e' R255a (par. 5).
#
#  3. LA MANOPOLA TOCCA ANCHE GLI INGRESSI -- letto, non assunto.
#  A InpCloseHour:InpCloseMin EndOfSession() (r.1929-1940) cancella i
#  PENDENTI e chiude la posizione; e da li' in poi OnTick esce prima dello
#  switch (r.613-617). Il SELL LIMIT del retest nasce alla rottura dopo le
#  15:05 con scadenza 120' (R255a par. 4): i limiti riempiti o le rotture
#  avvenute DOPO le 16:00 (o 17:00) SPARISCONO. Quindi NON vale il
#  G0-INGRESSI di R255 (stesse giornate): vale un G0-SOTTOINSIEME (par. 5).
#
#  4. L'ATTESA, SCRITTA PRIMA.
#  Proxy MISURATO SUL LONG (non trasferito allo short: e' solo l'ordine
#  di grandezza di quante uscite la manopola sposta). Per-trade R246 del
#  long 14:30 (risultati_archivio/R246/PERTRADE/..._794603 e _794601,
#  script 27/09), posizioni la cui ULTIMA uscita e' alle/ dopo:
#       era IS  (794603, 56 pos.):  16:00 -> 24 (42,9%)  17:00 -> 15 (26,8%)
#       era OOS (794601, 96 pos.):  16:00 -> 50 (52,1%)  17:00 -> 20 (20,8%)
#  Quindi la cella 16:00 cambia l'uscita di ~40-50% delle posizioni, la
#  17:00 di ~20-27% [PROXY DAL LONG].
#  n: R255a atteso = R54a, 73 + 73 deal (~55 posizioni per era, R255a
#  par. 11): MERITO SOSPESO PER ARITMETICA in ogni cella. Si legge il
#  RISCHIO. Trades: 16:00 <= 17:00 <= R255a (G2).
#  IL PF (CSV _OOS = la corsa continua 2024.09.27 -> 2026.06.30), tre
#  esiti, una PARTIZIONE, cella per cella contro R255a:
#    CODA      PF >= PF(R255a) + 0,10  (il pomeriggio restituiva)
#    CORSA     PF <= PF(R255a) - 0,10  (i runner erano il margine)
#    DENTRO    il resto: "il default (17:30) va bene" -- ed e' un esito.
#  Previsione mia: DENTRO sulla 17:00, CORSA sulla 16:00. Motivo: sul
#  long 770202 il trailing M5 e' stato la vittoria (PF 1,24 -> 1,37,
#  caccia par. 5.3) e la replica pubblica dell'ORB 5' da' il Dow NETTO
#  -0,081 R (Krueger 25/09/2026 [DICHIARATO]).
#
#  5. I CANCELLI (congelati prima; si citano come C<n> [R267c]).
#  C0 CATENA di R255a par. 8: E0 (moncone), P0 (tutti i pin dal CSV _OOS,
#     InpCloseHour 16/17 e InpCloseMin 0 compresi), C0 del per-trade
#     (abtg_trades_ABTG_Dow_Apertura_US_U30USD_796711.csv, UNO,
#     IDENTIFICATO: R267a par. 0, classe 850; sia H l'ora della cella
#     identificata, 16 o 17), L0 (tutte le uscite deal_type 0 = chiudono uno
#     short). G1 non esiste qui (niente gemelle): se serve, dopo.
#  C1 G0 ESTERNO = R255a, girato PRIMA nello stesso giro, con i suoi G0
#     verdi (G0-ANCORA contro R54a). Senza R255a questo file NON SI LEGGE.
#  C2 SOTTOINSIEME (cella H:00 identificata, dal per-trade): ogni deal con
#     close_time < H:00:00 deve avere un gemello in R255a (793101) con close_time,
#     deal_type e price IDENTICI (volume e net no: saldo diverso); a
#     parte le parziali mancanti al lotto 0,10 (R255a par. 5). Un deal
#     senza gemello = ROSSO: la manopola ha toccato qualcosa che non
#     doveva -> NON LEGGIBILE.
#  C3 S1 L'OROLOGIO MORDE (cella H:00 identificata): zero uscite dopo le
#     H:00:59. L'ALTRA cella si controlla solo col P0 (niente per-trade).
#  C4 G2: Trades(16) <= Trades(17) <= Trades(R255a), e Profit(16) !=
#     Profit(17). Rovesciato o identico = NON ESEGUITA.
#  C5 RISCHIO (a qualunque n): DD equity del CSV _OOS di ogni cella e
#     "Peggior Giornata %" contro R255a (stesso banco, stessa gamba). Il
#     tetto di casa R2 (4,272% a saldo chiuso, R255a par. 9) si legge
#     SOLO sulla cella con per-trade (quella identificata), curva CONTROLLO (tutto il
#     file 14:30). La curva IN FASE NON si ricompone qui (servirebbe il
#     file 15:30 e un per-trade per cella): buco dichiarato.
#  C6 NESSUNA CELLA SI PROMUOVE. Due celle = un interruttore, non un
#     altopiano.
#
#  6. FINESTRA: identica a R255a (@DAQUANDO 2024.09.26, @FINOA 2026.06.30,
#  @FRAZIONEIS 0.001: moncone di 1 giorno + corsa continua).
#
#  7. COSTO: stesso carico di un file R255 (2 celle x moncone + 641
#  giorni): 93-102 s (R255a par. 14) / 4 passate x 0,333 min = 1,3 min
#  -> ~1,3-1,7 MIN.
#
#  8. BUCHI: la curva IN FASE (file 15:30) NON e' qui; l'uscita a tempo
#  sul NUDO (EMA spento) no; InpCloseMin ad asse no; il per-trade
#  dell'ALTRA cella non esiste (classi 455/850); l'effetto sugli INGRESSI (par. 3)
#  non si separa da quello sulle uscite senza un per-trade per cella.
# ====================================================================="""

HEAD_D = """\
#  EA: ABTG_Dow_Apertura_US
# =====================================================================
#  R267d -- DOW SHORT (motore della 770202, lato SHORT): FILTRO VOLUMI
#  EA: ABTG_Dow_Apertura_US, U30USD M5, TICK REALI
#  La parte comune del round sta in prove/R267a_news_oro_770402.txt par. 0.
""" + BERSAGLIO + """
#  VINCOLI DI BANCO (nella riga): identici a R255a (-Deposito 10000,
#    -Modello 4, MaxBars 100000000, niente -Spread/-Ritardo/-FrazioneIS).
#  Scritto il 27/09/2026. Attese e soglie CONGELATE PRIMA DEI NUMERI.
# =====================================================================
#
#  1. DOMANDA. "Volume relativo" (ORB stocks in play, QuantConnect, da
#  Zarattini-Barbon-Aziz [DICHIARATO]) = il nostro InpUseVolumeFilter,
#  MAI acceso sullo short del Dow (grep dei 24 file R255: false ovunque).
#
#  2. BASE = R255a (short, ancora, 14:30, EMA H4 acceso). Cambiano SOLO:
#    InpUseVolumeFilter  false -> true
#    InpVolMult          1.5 (pin inerte) -> ASSE 0,0 .. 2,0 passo 0,5
#                        (celle 0,0 / 0,5 / 1,0 / 1,5 / 2,0)
#    InpMagic            asse gemello -> 796712 fisso
#  InpVolAvgBars resta 20 (default = regola Emiliano).
#  NOMI E UNITA', LETTI NEL SORGENTE (ABTG_Dow_Apertura_US.mq5):
#    InpUseVolumeFilter (r.317) bool; InpVolMult (r.318) MOLTIPLICATORE
#    senza unita'; InpVolAvgBars (r.319) numero di BARRE del TF del
#    grafico (M5). VolumeOKtf (r.2074-2087): tick volume dell'ultima M5
#    CHIUSA (shift 1) >= InpVolMult x media delle 20 M5 PRIMA di lei;
#    dati insufficienti o media 0 -> passa. Chiamata nel RETEST alla
#    rottura (r.1348 short): gBrokeLow diventa true PRIMA del controllo,
#    quindi un volume insufficiente SALTA LA GIORNATA (niente seconda
#    occasione). ATTENZIONE: la barra letta e' la M5 chiusa PRIMA del
#    tick di rottura, non la barra della rottura.
#  LA CELLA 0,0 E' L'ANCORA IN-FILE: v[0] >= 0 x media e' sempre vero,
#  quindi il filtro acceso a 0,0 = filtro spento = R255a AL CENTESIMO.
#
#  3. L'ATTESA, SCRITTA PRIMA.
#  PRECEDENTE DI CASA (R84b, NASUSD, InpEntryMode 0 = BREAKOUT, non
#  retest; risultati_archivio/r84_csv, ricontato il 27/09): filtro 1,5/20
#  contro spento: IS PF 1,25367 -> 0,87623, Trades 156 -> 62 (x0,397),
#  DD 6,14 -> 5,86%; OOS PF 0,87315 -> 0,95032, Trades 291 -> 92
#  (x0,316), DD 17,07 -> 4,59%. Lezione: un AMMAZZA-DD (in OOS; in IS il
#  DD quasi non si muove), NON un generatore di PF.
#  PERCHE' SUL DOW PUO' MORDERE MENO [INFERITO, da battere]: per una
#  rottura nei primi minuti dopo le 15:05 BCM (file 14:30, estate) le 20
#  M5 della media sono ~13:20-15:00, per ~70% PRE-MERCATO (14 su 20) a
#  volume basso: la media e' diluita e il rapporto tende a stare sopra 1
#  -> a 1,5 il filtro toglie meno. Per le rotture piu' tardi la media e'
#  tutta di seduta e l'argomento cade.
#  DUE IPOTESI SUL RAPPORTO r = Trades(1,5) / Trades(0,0), NON
#  sovrapposte (classe 178):
#    H_R84      r in [0,25 ; 0,50]  (il precedente si trasferisce)
#    H_DILUITO  r >= 0,70           (la media col pre-mercato)
#    fra 0,50 e 0,70: NESSUNA DELLE DUE, si scrive il numero.
#    r < 0,25: OLTRE R84 (morde PIU' del precedente): nessuna delle due,
#    si scrive il numero (cosi' l'asse di r e' coperto tutto).
#  IL DD: il precedente stesso NON ha un verso unico (R84b: DD x0,27 in
#  OOS, x0,95 in IS). Attesa scritta: sotto H_R84 DD(1,5)/DD(0,0) fra
#  0,27 e 0,95; sotto H_DILUITO vicino a 1.
#  IL PF: ATTESO sotto 1 in tutte le celle (R54a short OOS PF 0,84;
#  R84b PF sotto 1). n: R255a ~73 + 73 deal: MERITO SOSPESO in ogni cella.
#
#  4. I CANCELLI (congelati prima; si citano come V<n> [R267d]).
#  V0 CATENA di R255a par. 8 (E0, P0 con InpVolMult dal CSV, C0 del
#     per-trade ..._U30USD_796712.csv, UNO, IDENTIFICATO: R267a par. 0,
#     classe 850 -- atteso 2,0, puo' essere un'altra cella; L0 short).
#  V1 G0 IN-FILE: la cella 0,0 deve essere == R255a AL CENTESIMO
#     (Trades, Profit, PF, DD del CSV _OOS; il magic non entra nel
#     trading). Il legame con l'archivio (G0-ANCORA contro R54a, 73 deal
#     per era) lo porta R255a, che ha il per-trade: la cella 0,0 qui non
#     ce l'ha (classe 455). R255a NON girato -> la cella 0,0 vale solo
#     come ancora INTERNA del file, e si scrive cosi'.
#  V2 MORDE E TOGLIE SOLTANTO: Trades non crescente con InpVolMult (una
#     giornata saltata non ne crea un'altra: un ciclo al giorno), con
#     tolleranza 2 deal (parziali al lotto 0,10); Trades(2,0) < Trades(0,0)
#     altrimenti il pin non e' arrivato -> NULLO.
#  V3 SOTTOINSIEME (cella identificata, dal per-trade): ogni deal ha un
#     gemello in R255a (793101) con close_time, deal_type e price identici
#     (volume e net no), salvo le parziali mancanti al lotto 0,10. Un deal
#     senza gemello = NON LEGGIBILE. Se la cella identificata e' la 0,0 il
#     confronto e' con R255a stesso: non informa, si scrive cosi'.
#  V4 RISCHIO (a qualunque n): DD equity e Peggior Giornata % del CSV
#     _OOS di ogni cella contro la cella 0,0; il tetto R2 di R255a (4,272%
#     a saldo chiuso) si legge SOLO sulla cella identificata (unico per-trade).
#     Un DD che scende IN PROPORZIONE ai deal NON e' una leva: si scrive
#     accanto DD(c)/DD(0) e Trades(c)/Trades(0).
#  V5 ALTOPIANO, MAI IL PICCO; e se nessuna cella batte la 0,0 oltre il
#     rumore: "IL DEFAULT (filtro spento) VA BENE". NESSUNA PROMOZIONE.
#
#  5. FINESTRA: identica a R255a (moncone 1 giorno + 2024.09.27 ->
#  2026.06.30).
#  6. COSTO: 5 celle x (moncone + 641 giorni) = 2,5 volte R267c:
#  5 x 2 x 0,333 = 3,3 min / R255 scalato 47-51 s per cella = 3,9-4,3 min
#  -> ~3,3-4,3 MIN.
#  7. BUCHI: il filtro sul NUDO (EMA spento, piu' campione) no;
#  InpVolAvgBars ad asse no (una variabile); InpUseAtrFilter no (su
#  NASUSD R84c OOS PF 0,97: stesso ruolo); la curva IN FASE (file 15:30)
#  no; per-trade di UNA sola cella (classi 455/850).
# ====================================================================="""


def head_ema(lettera, sim, base, manopola):
    anc = {
        "GBPJPY": ("O1 0.10 / O2 0.4 / TP 1.5", "Pass 55: PF 1,24037, n 221 deal, DD 4,4220%, +609,52"),
        "XAUUSD": ("O1 0.30 / O2 0.4 / TP 2.5", "Pass 311: PF 1,38074, n 187 deal, DD 6,1446%, +991,09"),
    }[sim]
    magic = {"e1": "796721", "e2": "796722", "f1": "796731", "f2": "796732"}[lettera]
    t = ("""\
#  EA: ABTG_EMA200
# =====================================================================
#  R267%s -- EMA200 H4 %s: %s
#  EA: ABTG_EMA200 (due lati), %s H4, TICK REALI
#  La parte comune del round sta in prove/R267a_news_oro_770402.txt par. 0.
""" % (lettera, sim, "FILTRO ADR (mai acceso)" if manopola == "adr" else "CHIUSURA DEL VENERDI' (mai accesa)", sim)) + BERSAGLIO + ("""
#  VINCOLI DI BANCO (nella riga, classe 692): IDENTICI al G0 di R264
#    (prove/R264a_controllo_EMA200_GBPUSD.txt = testa, par. 5):
#    -Deposito 10000, -Modello 4 (tick reali), niente -Spread/-Ritardo/
#    -FrazioneIS. E' il banco del genetico: il confronto con l'archivio
#    E' il G0.
#  Scritto il 27/09/2026. Attese e soglie CONGELATE PRIMA DEI NUMERI.
# =====================================================================
#
#  1. BASE = prove/%s
#  (PASS 8bca2cbd), la cella G0 di %s (%s).
#  Ancora d'archivio del genetico (R264 par. 1a):
#    %s.
#  Cambiano SOLO: %s, InpComment R267%s,
#  InpMagic %s fisso (niente gemelle: l'asse e' la manopola).
#  LA CELLA 0 (manopola spenta) E' L'ANCORA IN-FILE: tutti i pin uguali a
#  %s, magic a parte -> Trades, Profit, PF, DD IDENTICI al centesimo a
#  quelli di %s girato sullo stesso PC (il magic non entra nel trading:
#  G1 di R264) e, contro il genetico, le bande VERDE/GIALLO/ROSSO di R264
#  par. 5.
#
#  PERCHE' SOLO GBPJPY E XAUUSD (e non i 4 simboli di R264): a 135 s per
#  passata tick (metro R240: U30USD H1, ALTRO EA; sull'EMA200 H4 e'
#  [NON MISURATO], classe 751) un file = 2 finestre piene = ~4,5 min; 4
#  simboli x 2 manopole = 8 file = ~36 min, sopra i ~10 min del mandato.
#  Scelti per numero: GBPJPY = DD PIU' BASSO dei quattro (4,42%%); XAUUSD =
#  PF piu' alto fra i VIVI (1,381). AUDJPY ha il PF piu' alto in assoluto
#  (1,514) ma e' MORTO su campione pieno (R139a) e la regola del 19/08
#  vieta di allargarne i filtri d'ingresso; GBPUSD ha DD 7,20%% e PF
#  1,231 (ultimo su tutti e due). Anche cosi' sono 4 file = ~18 min:
#  dichiarato, e spezzato in due onde da ~9 min (una per simbolo).
""" % (base, sim, anc[0], anc[1],
       "InpUseAdrFilter 0 -> ASSE 0/1" if manopola == "adr" else "InpFridayClose 0 -> ASSE 0/1",
       lettera.upper(), magic, base[:5], base[:5]))
    if manopola == "adr":
        t += """\
#
#  2. LA MANOPOLA, LETTA NEL SORGENTE (ABTG_EMA200.mq5, HEAD b45dd009).
#  InpUseAdrFilter (r.62), InpAdrDays 50 (r.63), InpAdrDistMin 0,0
#  (r.64), InpAdrDistMax 0,8 (r.65, "guida Paolo ~0,8x ADR"). OnNewBar
#  (r.332-336): dopo la fascia in ATR (dist = |chiusura - EMA200| fra
#  0,3 e 1,5 x ATR14 H4, r.331) scarta la candidata se dist > 0,8 x ADR,
#  ADR = media di (massimo - minimo) delle ultime 50 D1 CHIUSE (r.309-
#  317). In NESSUN file prova e' mai stato acceso (caccia par. 8).
#  NON E' UN SOTTOINSIEME: una candidata scartata lascia libero il posto
#  (HasPosition/HasPending, r.322) e la barra dopo puo' entrare: gli
#  ingressi SUCCESSIVI possono cambiare.
#
#  3. L'ATTESA, SCRITTA PRIMA -- E PERCHE' PREVEDO CHE SIA INERTE.
#  Il filtro morde solo se 1,5 x ATR14(H4) > 0,8 x ADR50, cioe' se
#  ATR(H4)/ADR > 0,533. Su una coppia che gira ~24 ore, 6 candele H4 per
#  giorno: se il prezzo fosse un cammino casuale ATR(H4) ~ ADR/radice(6)
#  = 0,41 x ADR [INFERITO, NON MISURATO su BCM: il K1 di R264 misura
#  l'ATR H4 per la prima volta]. Allora 1,5 x ATR ~ 0,61 x ADR < 0,8:
#  la fascia in ATR taglia PRIMA dell'ADR. Il filtro morde solo quando
#  l'ATR a 14 candele H4 (~2,3 giorni) corre avanti all'ADR a 50 giorni
#  (shock di volatilita').
#  DUE IPOTESI NON SOVRAPPOSTE (classe 178), cella 1 contro cella 0:
#    H_INERTE  |Trades(1) - Trades(0)| <= 2%% di Trades(0) E |dPF| < 0,02
#              -> "casella MISURATA, manopola INERTE a 0,8": non si
#              riprova a 0,8; la manopola che morderebbe e' InpAdrDistMax
#              ~0,5 (NON qui).
#    H_MORDE   IL RESTO (Trades fuori di +-2% O |dPF| >= 0,02): allora
#              il rapporto 0,41 e' sbagliato o gli shock sono frequenti,
#              e si scrive quale. (Trades(1) > Trades(0) e' possibile
#              per il posto liberato: si scrive, non e' un errore.)
#  Previsione mia: H_INERTE.
#  Se MORDE: tre esiti, una PARTIZIONE: LEVA (DD <= 0,85 x DD(0) e PF >=
#  PF(0) - 0,05) . PEGGIORA (PF < PF(0) - 0,05) . NULLA (il resto).
#
"""
    else:
        t += """\
#
#  2. LA MANOPOLA, LETTA NEL SORGENTE (ABTG_EMA200.mq5, HEAD b45dd009).
#  InpFridayClose (r.102) bool, InpFridayCloseHour 20 (r.103, ora SERVER,
#  pinnato uguale alla base). FridayCloseCheck (r.277-287), in testa a
#  OnTick (r.290): il venerdi' dalle 20:00 server CANCELLA i pendenti e
#  CHIUDE le posizioni del magic, e fino a fine giornata non gestisce ne'
#  piazza niente. Tocca uscite E ingressi (i pendenti del venerdi' sera).
#  Fonte pubblica: London Breakout GbpUsd M15 (Kupka) chiude il venerdi'
#  alle 21:00 UTC+2 "contro i gap del weekend" [DICHIARATO, niente numeri].
#  L'OROLOGIO: la finestra 2024.01.01-2026.06.30 attraversa il cambio del
#  feed forex BCM (fra 26/12/2024 e 02/02/2025; OROLOGIO_BCM_2026-09-24):
#  20:00 BCM = 20:00 UTC prima (inverno) / 19:00 UTC (estate e dopo il
#  cambio). La chiusura del forex del venerdi' e' alle 21:00 UTC (estate
#  USA) / 22:00 UTC (inverno USA): il taglio cade 1-3 ore PRIMA [DERIVATO].
#  Oro: l'ora di chiusura del venerdi' a BCM e' [NON VERIFICATA]; se fosse
#  prima delle 20:00 BCM la manopola sarebbe inerte (lo vede G2).
#
#  3. L'ATTESA, SCRITTA PRIMA. La leva e' sul DD (il tappo di R139), non
#  sul PF. Quante posizioni attraversano il venerdi' sera: [NON MISURATO]
#  e il per-trade NON lo dice (solo close_time, nessuna ora d'apertura:
#  classe 847); lo dice la DIFFERENZA fra le due celle. TRE ESITI, UNA
#  PARTIZIONE, cella 1 contro cella 0:
#    LEVA           DD(1) <= 0,85 x DD(0)  E  PF(1) >= PF(0) - 0,05
#    COSTO          PF(1) < PF(0) - 0,05   (qualunque DD: taglia i trend
#                   H4 che attraversano il weekend)
#    NULLA          il resto
#  Previsione mia: NULLA. Motivo [INFERITO]: le uscite del motore
#  (parziale su EMA14, BE, trailing su EMA14, r.410-436) chiudono in
#  pochi giorni, e un venerdi' sera ha una frazione piccola delle
#  posizioni vive; su 2,5 anni ci sono ~130 venerdi'.
#
"""
    t += """\
#  n: il G0 ha %s deal ~ %s posizioni (1,838 deal/posizione, R264 par.
#  1b): SOTTO 150 -> MERITO SOSPESO. Il RISCHIO si legge a qualunque n.
""" % (anc[1].split("n ")[1].split(" deal")[0],
       {"GBPJPY": "120", "XAUUSD": "102"}[sim])
    if sim == "XAUUSD":
        t += """\
#  ORO A 10000 (detto da R264 par. 5 e 11, e vale qui): le gambe stanno a
#  0,01-0,03 lotti, il pavimento MathMax (r.495) alza il rischio oltre lo
#  0,5%% per gamba e la parziale al 50%% non parte: il DD%% di questo file
#  NON e' quello a 1%% dichiarato. Il confronto cella 1 / cella 0 resta
#  valido (stesso banco); il numero assoluto no. Il G0 d'oro e' atteso
#  GIALLO o ROSSO (R264 par. 5, causa nominata): con ROSSO questo file si
#  legge SOLO al suo interno.
""".replace("%%", "%")
    t += """\
#
#  4. I CANCELLI (congelati prima; si citano come E<n> [R267%s]).
#  E0 CATENA di R264 par. 5: E0 (moncone: CSV _IS vuoto e rc 2 attesi),
#     P0 (ogni colonna Inp del CSV _OOS uguale al file, %s compresa),
#     C0 del per-trade (UNO, IDENTIFICATO: R267a par. 0, classe 850;
#     abtg_trades_ABTG_EMA200_%s_%s.csv; regola del k di commissione in
#     [1,00 ; 3,00] EUR/lotto, classe 844).
#  E1 G0 IN-FILE: cella 0 == %s al centesimo se girato; contro il
#     genetico, bande di R264 par. 5. ROSSO -> il file si legge solo al
#     suo interno.
#  E2 LA MANOPOLA MORDE: Profit(1) != Profit(0). Identici = %s.
#  E3 RISCHIO (a qualunque n, Emendamento B): DD di ogni cella <= 10,0%%
#     a rischio 1%% (S3 di R264); accanto il derivato a 2,00%%
#     (x1,956-1,990). Tick, quindi niente riserva OHLC; ma n piccolo.
#  E4 NESSUNA CELLA SI PROMUOVE: interruttore a due stati, niente
#     altopiano. Se la cella 1 non batte la 0 oltre il rumore: "IL
#     DEFAULT (spento) VA BENE", ed e' un esito.
#  E5 K1 (costo): la manopola non tocca lo stop; K1 e' quello di R264.
#
#  5. FINESTRA: identica a %s (@DAQUANDO 2023.12.31, @FINOA
#  2026.06.30, @FRAZIONEIS 0.001: moncone di 1 giorno + OOS 2024.01.01
#  -> 2026.06.30 = la finestra del genetico, NON cieca a livello di
#  vicinato: R264 par. 4).
#  6. COSTO: 2 finestre piene x 135 s + 2 monconi = ~4,5 MIN [metro di
#  un ALTRO EA, classe 751: il G0 %s, che gira prima, lo misura].
#  7. BUCHI: il campione pieno OHLC (2017/2019 -> 2023) con la manopola
#  no (sarebbe il passo dopo, sul centro di R264 se passa); GBPUSD,
#  AUDJPY, EURUSD no (par. 1); commissioni/swap FTMO e griglia H4 di FTMO
#  [NON MISURATI]; per-trade di UNA sola cella (classi 455/850).
# =====================================================================""" % (
        lettera,
        "InpUseAdrFilter" if manopola == "adr" else "InpFridayClose",
        sim, magic, base[:5],
        "casella INERTE MISURATA\n#     (non un difetto: e' H_INERTE)" if manopola == "adr"
        else "(con P0 verde) nessuna posizione ne'\n#     pendente viva il venerdi' dopo le 20:00: casella INERTE MISURATA.\n#     Conferma dal per-trade (identiche = uguali): zero chiusure di\n#     venerdi' dalle 20:00:00 in poi",
        base[:5], base[:5])
    return t.replace("%%", "%")


HEAD_G1 = """\
#  EA: ABTG_MaxMinNotte
# =====================================================================
#  R267g1 -- DAX LONG (770411 a lati invertiti): IL TREND DEL DAX STESSO
#  EA: ABTG_MaxMinNotte (generico), D30EUR M15, TICK REALI
#  La parte comune del round sta in prove/R267a_news_oro_770402.txt par. 0.
#  Le uscite sul long stanno in R267g2 (trailing), g3 (breakeven), g4
#  (parziale), un asse per file.
""" + BERSAGLIO + """
#  VINCOLI DI BANCO (nella riga): identici a R261a (-Deposito 100000,
#    -Modello 4, niente -Spread/-Ritardo/-FrazioneIS; @FRAZIONEIS 1.0 =
#    una tranche, gamba OOS degenere, rc 2 ATTESO come R242/R244/R261).
#  Scritto il 27/09/2026. Attese e soglie CONGELATE PRIMA DEI NUMERI.
# =====================================================================
#
#  1. DOMANDA. Ger40 Morning Breakout (Terpstra, mql5 Market 131037
#  [DICHIARATO]) apre il long "solo in mercato rialzista" del DAX stesso.
#  R261a guarda lo S&P (lo specchio di 770411); questo file guarda il
#  DAX. Stesso meccanismo, CorrBias (r.698-709): EMA14 contro EMA100 di
#  InpCorrSymbol su InpCorrTF, ultima candela CHIUSA, +1 = solo long.
#
#  2. BASE = prove/R261a_dax_long_correlazione.txt (PASS f0e6f66e), la
#  cella corr=1 (la "versione long" di 770411). Cambiano SOLO:
#    InpUseCorrelation  asse 0/1 -> 1 fisso
#    InpCorrSymbol      SPXUSD -> D30EUR
#    InpCorrTF          H1 fisso -> ASSE H4..D1
#    InpComment MAXMINR267G1, InpMagic 796741 fisso
#  L'ASSE E' UN ENUM (classe 287): 16388||1||16408 NON fa "H4 e D1": il
#  driver spazzola i MEMBRI fra i due, cioe' H4, H6, H8, H12, D1 = 5
#  CELLE. Non e' un errore: sono i TF fra i due chiesti, e danno la curva
#  per l'altopiano (centro = H8).
#
#  3. IL RISCALDAMENTO, DETTO PRIMA (classe 834). Lo storico D30EUR parte
#  il 2024.09.26 e prima non c'e' niente. L'EMA100 matura dopo ~100
#  candele del SUO TF: su D1 ~100 sedute = fino a ~febbraio 2025, cioe'
#  ~1/4 della finestra con un'EMA100 IMMATURA; su H4 poche settimane
#  [INFERITO: le candele H4 per giorno del D30EUR BCM NON sono contate].
#  Le celle alte hanno piu' giorni "filtrati male": si scrive accanto.
#  E COSA VALE L'EMA100 PRIMA DI MATURARE e' [NON VERIFICATO]: se il
#  buffer vale un seme calcolato, il filtro e' solo IMPRECISO; se vale 0
#  il bias e' +1 (long SEMPRE ammesso, = corr=0); se vale EMPTY_VALUE il
#  bias e' -1 (long MAI). Sulla cella D1 sono ~4-5 mesi su 21: si guarda
#  il mese del primo deal (se la cella D1 e' quella identificata).
#
#  4. L'ATTESA, SCRITTA PRIMA.
#  n: la cella corr=0 di R261a e' attesa ~135 deal (banda 115-160, R261a
#  par. 6). Il DAX sulla finestra e' "in maggioranza al rialzo" (R261a
#  par. 6 [INFERITO]): il bias +1 terra' PIU' giornate dello specchio
#  S&P -> 60-85% delle giornate -> ~80-115 deal ~55-80 posizioni
#  [DERIVATO LARGO]. SOTTO 150 in ogni cella: MERITO SOSPESO PER
#  COSTRUZIONE. Si legge il RISCHIO.
#  IL PF, CONTRO DUE IPOTESI (partizione sulla cella centrale H8):
#    HP  "il trend del DAX salva il long": PF(H8) >= 1,10 E >= 3 celle
#        contigue >= 1,10 -> "INDIZIO FAVOREVOLE, merito sospeso".
#    H0  "il filtro non salva il long": PF(H8) < 1,00.
#    In mezzo (1,00 <= PF(H8) < 1,10, o H8 >= 1,10 senza 3 contigue):
#        "NON C'E' UNA CONFIGURAZIONE ROBUSTA".
#  Previsione mia: H0. Motivo: 0 celle su 33 distinte >= PF 1,00 sul long
#  DAX a tick (REGISTRO_TEST, R260/R261), e dal web nessuna ragione per
#  un ribaltamento (caccia par. 0 punto 6). La sonda notturna esterna sul
#  DAX e' NULLA (caccia par. 2.5): nessun prior misurato fuori.
#
#  5. I CANCELLI (congelati prima; si citano come D<n> [R267g1]).
#  D0 -SoloControllo: 5 celle. Altrimenti STOP.
#  D1 G0 ESTERNO: R261d e R261c VERDI e R261a girato prima nello stesso
#     giro. Nessuna cella di questo file e' inerte (tutte filtrano), quindi
#     il G0 in-file non esiste: si scrive, non si finge.
#  D2 SOTTOINSIEME DI STRUTTURA: Trades(ogni cella) <= Trades(R261a
#     corr=0) + 2 (il filtro toglie giornate, un ciclo al giorno).
#  D3 MORDE (T3 di R261a): una cella con Trades IDENTICI a R261a corr=0 =
#     il bias e' tornato 0 (CopyBuffer fallito: r.704) -> NON ESEGUITA.
#  D4 L0 dal per-trade (abtg_trades_ABTG_MaxMinNotte_D30EUR_796741.csv,
#     UNO, IDENTIFICATO: R267a par. 0, classe 850): tutte le chiusure
#     deal_type 1 (vale per qualunque cella).
#  D5 RISCHIO (a qualunque n): DD a 1% di ogni cella; soglia di casa T5 di
#     R261a (DD > 4,0% lineare / 4,08% moltiplicativo = fuori da S3 a
#     2,00%), [DERIVATO].
#  D6 NESSUNA CELLA SI PROMUOVE.
#
#  6. FINESTRA: identica a R261a (2024.09.26 -> 2026.06.30, @FRAZIONEIS
#  1.0). 7. COSTO: 5 finestre piene x 0,28-0,70 min = ~1,4-3,5 MIN.
#  8. BUCHI: l'orologio sul long (inverno un'ora prima della cash) [NON
#  MISURATO]; EMA 14/100 non ad asse (una variabile); il riscaldamento
#  (par. 3); per-trade di UNA sola cella (classi 455/850); commissione FTMO
#  GER40 [NON MISURATA].
# ====================================================================="""


def head_uscita(lettera, manopola, asse_txt, celle_txt, codice_txt, attesa_txt, g2_txt, costo):
    return (("""\
#  EA: ABTG_MaxMinNotte
# =====================================================================
#  R267%s -- DAX LONG (770411 a lati invertiti, filtro S&P acceso):
#            L'USCITA, casella (3) del certificato -- %s
#  EA: ABTG_MaxMinNotte (generico), D30EUR M15, TICK REALI
#  La parte comune del round sta in prove/R267a_news_oro_770402.txt par. 0.
""" % (lettera, manopola)) + BERSAGLIO + ("""
#  VINCOLI DI BANCO (nella riga): identici a R261a (-Deposito 100000,
#    -Modello 4, @FRAZIONEIS 1.0: una tranche, rc 2 ATTESO).
#  Scritto il 27/09/2026. Attese e soglie CONGELATE PRIMA DEI NUMERI.
# =====================================================================
#
#  1. DOMANDA. Sul long DAX la gestione dell'uscita NON e' MAI stata
#  messa ad asse (certificato del 09/09, casella (3); caccia P11b). Un
#  asse per file: trailing (g2), breakeven (g3), parziale (g4).
#
#  2. BASE = prove/R261a_dax_long_correlazione.txt (PASS f0e6f66e), cella
#  corr=1 (filtro S&P ACCESO: la "versione long" di 770411). Cambiano SOLO:
#    InpUseCorrelation  asse 0/1 -> 1 fisso
#    %s
#    InpComment MAXMINR267%s, InpMagic %s fisso
#  LA CELLA DELLA BASE STA NELL'ASSE (%s): e' l'ANCORA IN-FILE e deve
#  rifare R261a corr=1 AL CENTESIMO (Profit, PF, DD, Trades): il magic
#  non entra nel trading. E' anche == la cella M15 di R261b (G2 di R261),
#  e le celle-ancora di g2, g3, g4 sono IDENTICHE fra loro.
#
#  3. COSA FA IL CODICE (ABTG_MaxMinNotte.mq5, HEAD 7d0da9f9, ManagePos:
#  primo target r.411, breakeven r.428, trailing r.459):
#  %s
#
#  4. L'ATTESA, SCRITTA PRIMA.
#  n: la cella base e' attesa 50-90 deal = ~35-63 posizioni (R261a par.
#  6): MERITO SOSPESO PER COSTRUZIONE in ogni cella; sotto 50 posizioni
#  "NON MISURATO -- campione". Si legge il RISCHIO.
#  %s
#  Tre esiti, una PARTIZIONE, ogni cella contro la cella-ancora:
#    LEVA      DD <= 0,85 x DD(ancora) E PF >= PF(ancora) - 0,05
#    PEGGIORA  PF < PF(ancora) - 0,05
#    NULLA     il resto
#  Attesa onesta sul livello: TUTTE LE CELLE SOTTO PF 1 (0 celle su 33
#  distinte >= 1,00 sul long DAX a tick; un'uscita non crea un edge che
#  l'ingresso non ha). Se la cella-ancora esce >= 1,10 (HP di R261a), la
#  lettura delle uscite diventa interessante: si scrive, non si promuove.
#
#  5. I CANCELLI (congelati prima; si citano come U<n> [R267%s]).
#  U0 -SoloControllo: %s celle. Altrimenti STOP.
#  U1 G0 IN-FILE: cella-ancora == R261a corr=1 al centesimo (se R261a e'
#     girato, e con T1/T2 di R261 VERDI). Se no -> NULLO.
#  U2 LA MANOPOLA MORDE: %s
#  U3 L0 dal per-trade (abtg_trades_ABTG_MaxMinNotte_D30EUR_%s.csv,
#     UNO, IDENTIFICATO: R267a par. 0, classe 850): tutte le chiusure
#     deal_type 1.
#  U4 STESSI INGRESSI: le celle cambiano solo l'uscita, e con un ciclo al
#     giorno e InpCloseAtEnd le giornate operate sono le stesse. Non c'e'
#     un per-trade per cella: si controlla sulla cella identificata contro
#     il per-trade di R261a (stesse date di prima chiusura), e SOLO se
#     anche quello e' identificato come la cella corr=1 (R261a ha lo
#     stesso difetto: classe 850, asse corr 0/1 a magic fisso). Se R261a
#     ha scritto la corr=0, U4 NON SI FA (si scrive), il file non e'
#     NULLO. Diverso = NON LEGGIBILE.
#  U5 RISCHIO (a qualunque n): soglia T5 di R261a (DD a 1%% > 4,0%% /
#     4,08%% = fuori da S3 a 2,00%%) [DERIVATO].
#  U6 NESSUNA CELLA SI PROMUOVE. Se nessuna batte l'ancora oltre il
#     rumore: "IL DEFAULT VA BENE" -- ed e' la casella (3) riempita.
#
#  6. FINESTRA: identica a R261a. 7. COSTO: %s
#  8. BUCHI: l'uscita sulla cella corr=0 no (e' l'altra base); le altre
#  manopole d'uscita (InpTP2_R, InpTrailAtrMult, InpUseEMA200Target) no;
#  l'orologio sul long [NON MISURATO]; per-trade di UNA sola cella
#  (classi 455/850). E UN EFFETTO DI LATO GIA' LETTO IN CASA (R151a):
#  ManagePos r.407-408 ricalcola risk dallo stop CORRENTE e, se <= 0
#  (stop in pari o sopra l'ingresso), lo sostituisce con ATR x 2,5:
#  BE e trailing spostano quindi ANCHE il bersaglio della seconda
#  parziale (TP2 = 3 x risk). La manopola non e' pura: si scrive.
# =====================================================================""" % (
        asse_txt, lettera.upper(), {"g2": "796742", "g3": "796743", "g4": "796744"}[lettera],
        celle_txt, codice_txt, attesa_txt, lettera,
        {"g2": "2", "g3": "2", "g4": "4"}[lettera], g2_txt,
        {"g2": "796742", "g3": "796743", "g4": "796744"}[lettera], costo))).replace("%%", "%")


# =====================================================================
#  I FILE: (nome, base, testa, cambi, inserimenti)
# =====================================================================
FILES = [
    ("R267a_news_oro_770402.txt", "R260c_oro_770402_due_lati_ancora.txt", HEAD_A,
     {"InpUseNewsFilter": "InpUseNewsFilter=true||true||0||true||N",
      "InpNewsFile": "InpNewsFile=abtg_news_2021_2025_UTC.csv",
      "InpNewsShiftMinutes": "InpNewsShiftMinutes=60||60||0||60||N",
      "InpNewsFlatten": "InpNewsFlatten=0||0||1||1||Y",
      "InpComment": "InpComment=MAXMINR267A",
      "InpMagic": "InpMagic=796701||796701||0||796701||N"},
     [("InpNewsShiftMinutes", "InpNewsCurrencies=USD")]),
    ("R267b_minbox_oro_770402.txt", "R260c_oro_770402_due_lati_ancora.txt", HEAD_B,
     {"InpMinBoxPts": "InpMinBoxPts=0||0||650||2600||Y",
      "InpComment": "InpComment=MAXMINR267B",
      "InpMagic": "InpMagic=796702||796702||0||796702||N"}, []),
    ("R267c_short_DOW_uscita90_1430.txt", "R255a_short_DOW_ancora_1430.txt", HEAD_C,
     {"InpCloseHour": "InpCloseHour=16||16||1||17||Y",
      "InpCloseMin": "InpCloseMin=0||0||0||0||N",
      "InpMagic": "InpMagic=796711||796711||0||796711||N"}, []),
    ("R267d_short_DOW_volumi_1430.txt", "R255a_short_DOW_ancora_1430.txt", HEAD_D,
     {"InpUseVolumeFilter": "InpUseVolumeFilter=true||true||0||true||N",
      "InpVolMult": "InpVolMult=0.0||0.0||0.5||2.0||Y",
      "InpMagic": "InpMagic=796712||796712||0||796712||N"}, []),
    ("R267e1_adr_EMA200_GBPJPY.txt", "R264c_controllo_EMA200_GBPJPY.txt",
     head_ema("e1", "GBPJPY", "R264c_controllo_EMA200_GBPJPY.txt", "adr"),
     {"InpUseAdrFilter": "InpUseAdrFilter=0||0||1||1||Y",
      "InpComment": "InpComment=R267E1",
      "InpMagic": "InpMagic=796721||796721||0||796721||N"}, []),
    ("R267e2_adr_EMA200_XAUUSD.txt", "R264d_controllo_EMA200_XAUUSD.txt",
     head_ema("e2", "XAUUSD", "R264d_controllo_EMA200_XAUUSD.txt", "adr"),
     {"InpUseAdrFilter": "InpUseAdrFilter=0||0||1||1||Y",
      "InpComment": "InpComment=R267E2",
      "InpMagic": "InpMagic=796722||796722||0||796722||N"}, []),
    ("R267f1_venerdi_EMA200_GBPJPY.txt", "R264c_controllo_EMA200_GBPJPY.txt",
     head_ema("f1", "GBPJPY", "R264c_controllo_EMA200_GBPJPY.txt", "venerdi"),
     {"InpFridayClose": "InpFridayClose=0||0||1||1||Y",
      "InpComment": "InpComment=R267F1",
      "InpMagic": "InpMagic=796731||796731||0||796731||N"}, []),
    ("R267f2_venerdi_EMA200_XAUUSD.txt", "R264d_controllo_EMA200_XAUUSD.txt",
     head_ema("f2", "XAUUSD", "R264d_controllo_EMA200_XAUUSD.txt", "venerdi"),
     {"InpFridayClose": "InpFridayClose=0||0||1||1||Y",
      "InpComment": "InpComment=R267F2",
      "InpMagic": "InpMagic=796732||796732||0||796732||N"}, []),
    ("R267g1_dax_long_trend_DAX.txt", "R261a_dax_long_correlazione.txt", HEAD_G1,
     {"InpUseCorrelation": "InpUseCorrelation=1||1||0||1||N",
      "InpCorrSymbol": "InpCorrSymbol=D30EUR",
      "InpCorrTF": "InpCorrTF=16388||16388||1||16408||Y",
      "InpComment": "InpComment=MAXMINR267G1",
      "InpMagic": "InpMagic=796741||796741||0||796741||N"}, []),
    ("R267g2_dax_long_trailing.txt", "R261a_dax_long_correlazione.txt",
     head_uscita("g2", "IL TRAILING",
                 "InpUseTrailing     true (pin) -> ASSE 0/1",
                 "cella 1 = trailing acceso",
                 "il trailing (ultimo blocco) sposta lo stop a bid - 2 x ATR(M15)\n"
                 "#  SOLO se migliora lo stop E sta sopra l'ingresso: indipendente dalla\n"
                 "#  parziale e dal breakeven. Cella 0 = stop fermo dopo il BE: la\n"
                 "#  posizione esce a SL, BE, TP2 (parziale), target EMA200, TP 4R o\n"
                 "#  alle 17:30.",
                 "Trades: uguali o quasi (la parziale TP2 puo' scattare di piu' senza\n"
                 "#  trailing). Precedente del motore sul DAX SHORT (R251, trail0): IS\n"
                 "#  peggio, OOS meglio -- NON trasferibile al long.",
                 "Profit(0) != Profit(1). Identici = il trailing non ha mai\n"
                 "#     agito sul campione -> casella INERTE MISURATA, non un difetto.",
                 "2 finestre piene x 0,28-0,70 min = ~0,6-1,4 MIN."),
     {"InpUseCorrelation": "InpUseCorrelation=1||1||0||1||N",
      "InpUseTrailing": "InpUseTrailing=0||0||1||1||Y",
      "InpComment": "InpComment=MAXMINR267G2",
      "InpMagic": "InpMagic=796742||796742||0||796742||N"}, []),
    ("R267g3_dax_long_breakeven.txt", "R261a_dax_long_correlazione.txt",
     head_uscita("g3", "IL BREAKEVEN",
                 "InpBreakeven       true (pin) -> ASSE 0/1",
                 "cella 1 = breakeven acceso",
                 "al primo target (1R) la parziale del 50% parte comunque; con\n"
                 "#  InpBreakeven=false lo stop NON va in pari (beFatto falso). Il BE e'\n"
                 "#  fuori dal ramo 'parziale riuscita' (fix 07/08). Il trailing resta\n"
                 "#  acceso in tutte e due le celle e sposta comunque lo stop sopra\n"
                 "#  l'ingresso quando puo'.",
                 "Trades: uguali o quasi (senza BE qualche runner arriva a TP2 invece\n"
                 "#  di uscire in pari, o torna a SL). Nessun precedente di casa.",
                 "Profit(0) != Profit(1). Identici = il BE e' coperto dal\n"
                 "#     trailing (che porta lo stop sopra l'ingresso prima) -> INERTE\n"
                 "#     MISURATA: si scrive, e vuol dire qualcosa sul motore.",
                 "2 finestre piene x 0,28-0,70 min = ~0,6-1,4 MIN."),
     {"InpUseCorrelation": "InpUseCorrelation=1||1||0||1||N",
      "InpBreakeven": "InpBreakeven=0||0||1||1||Y",
      "InpComment": "InpComment=MAXMINR267G3",
      "InpMagic": "InpMagic=796743||796743||0||796743||N"}, []),
    ("R267g4_dax_long_parziale.txt", "R261a_dax_long_correlazione.txt",
     head_uscita("g4", "LA PARZIALE AL PRIMO TARGET",
                 "InpTP1Pct          50 (pin) -> ASSE 0 / 25 / 50 / 75",
                 "cella 50",
                 "con InpTP1Pct=0 l'intero blocco del primo target salta\n"
                 "#  (condizione InpTP1Pct>0): NIENTE parziale, NIENTE breakeven, e\n"
                 "#  quindi NIENTE seconda parziale (richiede gPart1). Restano SL, target\n"
                 "#  EMA200, trailing, TP finale 4R, chiusura 17:30. Le celle 25/50/75\n"
                 "#  cambiano solo la quota chiusa a 1R (il BE resta).",
                 "Trades: cella 0 PIU' BASSA (niente deal di parziale: deal ~\n"
                 "#  posizioni); 25/50/75 uguali o quasi. Sul Dow EMA200 (R136c) la\n"
                 "#  parziale 0 ha fatto IS 0,93 contro 1,20 e DD OOS 13,94% contro\n"
                 "#  7,83%: altro motore, stesso verso atteso qui.",
                 "Trades(0) < Trades(50), e Profit NON identico fra 25, 50\n"
                 "#     e 75. Rovesciato o identico = NON ESEGUITA.",
                 "4 finestre piene x 0,28-0,70 min = ~1,1-2,8 MIN."),
     {"InpUseCorrelation": "InpUseCorrelation=1||1||0||1||N",
      "InpTP1Pct": "InpTP1Pct=0||0||25||75||Y",
      "InpComment": "InpComment=MAXMINR267G4",
      "InpMagic": "InpMagic=796744||796744||0||796744||N"}, []),
]


def costruisci():
    out = {}
    for nomef, base, testa, cambi, ins in FILES:
        corpo = applica(base, cambi, ins)
        testo = testa.rstrip("\n") + "\n" + "\n".join(corpo) + "\n"
        testo.encode("ascii")  # ASCII puro o eccezione
        out[nomef] = testo
    return out


def main():
    verifica = "--verifica" in sys.argv
    out = costruisci()
    male = 0
    for nomef, testo in out.items():
        p = os.path.join(QUI, nomef)
        if verifica:
            ok = os.path.exists(p) and open(p, encoding="ascii").read() == testo
            print(("OK      " if ok else "DIVERSO ") + nomef)
            male += 0 if ok else 1
        else:
            open(p, "w", encoding="ascii", newline="\n").write(testo)
            print("scritto " + nomef)
    return 1 if male else 0


if __name__ == "__main__":
    sys.exit(main())
