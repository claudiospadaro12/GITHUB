#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
leggi_gba_r2s_c3g.py -- STRUMENTO D2 del lotto GBA R2S stadio A (simboli gemelli, sonda dei costi, Modello 1, tranche T1).
v2: strato 2 del cancello (controllo-preventivo, 12/10/2026) PASS sulla v2 (SHA256 14384d87...), dopo 5 correzioni (mediana pari al bordo in virgola mobile,
varianti senza la dicitura di chiusura, pin ed EA dal RIEPILOGO, orologio e date delle righe, cella doppia nel manifest).
v3 (12/10 sera, BOZZA per il cancello: il PASS della v2 NON vale per questa versione): legge ANCHE il lotto del RILANCIO DELL'ARGENTO R2SXAG2 (file prova
backtest_pipeline/prove/GBA_R2S_XAGUSD2_2026-10-12.txt, SHA256 dbe11bc3..., pin della riga d53493a9...; scheda report/GBA_R2S_XAG2_SCHEDA_2026-10-12.md sez. 4):
  - PIN PER LOTTO: R2SANC/R2SXAG/R2SNAS/R2SD30/R2SU30 SOLO col pin cc9bcda0, R2SXAG2 SOLO col pin d53493a9 (RIEPILOGO_R0.txt e ESITI_*.txt); un altro pin = RIFIUTO;
  - X2: nel manifest la M15 viene PRIMA (R2SXAG2_01_M15_T1_m775800, poi R2SXAG2_02_REPL_T1_m775800: tag e ordine verificati); gli esiti restano quelli della prova
    (E1-E4 + ordine di E3), e l'esito della M15 dipende dal CE7 della REPL (X6), che si calcola PRIMA di stampare qualunque esito;
  - CE7 (determinismo della REPL, tolleranza ZERO sulle cifre stampate da D2 rispetto al giornale del 12/10: 6611 righe, EA 6611/0/6611/0/0, C3G cella 2.40, BUY 2.50
    n 3364, SELL 2.30 n 3247, fasce 2149 2.10 / 1458 2.40 / 680 2.80 / 802 4.20 / 1251 2.10 / 271 1.40); NON VALUTABILE se la REPL non e' lanciata, se il giornale
    non ha UNA riga [GBA-CONTA] FINE o se la prova d'accettazione di D2 non passa (il PASS del cancello su QUESTO SHA e' una precondizione ESTERNA, come il G0);
  - X6: CE1 del lotto R2SXAG2 VERDE solo se l'ancora del 12/10 e' verde (GBA_R0_R2SANC.zip con lo SHA256 dello zip archiviato in
    risultati_archivio/GBA_R2S_A_20261012/GBA_R2S_A.zip, pin cc9bcda0) E CE7 e' VERDE; altrimenti TUTTE E DUE le celle (C), senza appello;
  - CE8 (causa dello stallo): SOLO DESCRIZIONE (t_avvio, ora di 'Test passed' / 'total time' rispetto a t_avvio, riga 'last test passed', durata, n): nessun esito ne dipende;
  - il lotto R2SXAG2 si legge col SOLO zip dell'ancora del 12/10 (nessun altro lotto dello stadio A nella stessa lettura: RIFIUTO).
  La lettura dello stadio A (senza R2SXAG2) e' IDENTICA a quella della v2 riga per riga, salvo la riga dell'intestazione con versione e SHA256 di D2.
REGOLA E3(3), dichiarata e stampata in testa a ogni lettura del lotto R2SXAG2: una conferma a tick reali letta con uno strumento D2 di SHA256 DIVERSO da quello che ha
letto la passata a Modello 1 e' 'conferma non data' (casella 4 aperta). Lo SHA256 di D2 si stampa per intero. Qualunque modifica invalida il PASS: si ripassa.

COSA FA (e niente altro). Legge il giornale dell'EA (log\\GBA_<passata>.txt) di ogni passata dei 5 lotti R2SANC / R2SXAG / R2SNAS / R2SD30 / R2SU30 e stampa,
per ogni cella (simbolo, TF), il C3G = MEDIANA VERA del campo 'stop/spread' delle righe segnale (scheda report/GBA_R2S_A_SCHEDA_2026-10-12.md, decisione D2; blocco L3
e ESITI (A)(B)(C) dei file prova backtest_pipeline/prove/GBA_R2S_*_2026-10-12.txt; emendamenti E1-E4 in docs/RISPOSTA_A_GEMINI_GBA_R2S_STADIO_A_2026-10-12.md):
  - righe segnale (segnali grezzi), ingressi del giornale (righe senza SALTATO) e quelli a SPREAD ZERO (righe '-1.0x' con esito ok), n del report, tentati e
    scartati per spread dalla riga [GBA-CONTA] FINE dell'EA;
  - C3G della cella, delle 6 fasce orarie (definizione COPIATA dal lettore leggi_gba_r0.py r.52, ora = campo 'ora server' della riga, come nelle righe (6) del lettore)
    e dei due lati BUY/SELL, ciascuno col suo n; per cella e fascia anche il C3G per lato, le righe a >= 40x e a >= 50x e gli ingressi con la loro quota (E2);
  - le condizioni (i)-(iv) dell'esito (B) valutate LETTERALMENTE, con la soglia delle fasce della (ii) come PARAMETRO (100 = testo pinnato, 30 = E1), e la (v)
    di E4: righe della CELLA con stop/spread >= 40,0x (inclusivo; -1.0x = INFINITO e conta) < 30. S = 13,3x indici, 6,65x argento. Si stampano TRE righe: due
    VARIANTI DESCRITTIVE NON IN VIGORE (testo pinnato: (i)-(iv), (ii) a 100; E1: (i)-(iv), (ii) a 30), che NON portano mai una dicitura di chiusura (E1-E4 sono
    ADOTTATI: col solo Modello 1 l'unica dicitura e' quella di E3), e l'ESITO DI RIFERIMENTO = E1 + E4 ((i)-(v)) con la dicitura di E3;
  - la CASELLA 4 secondo E3: 'ESCLUSA (Modello 1)' -> NON ANCORA MISURATO finche' una passata a TICK REALI della stessa cella e tranche non da' n netto < 30 E
    (i)-(v) sul suo giornale (allora 'ESCLUSA PER COSTO (Modello 1 e tick reali)', casella CHIUSA); esiti IN ORDINE (storia a tick mancante; eccezione n=0;
    altro KO / CE rosse / SHA di D2 diverso = conferma non data; n netto >= 30 = conferma smentita per n, resta (B), mai (A); condizione falsa; conferma). casella4();
    lo zip a tick reali di conferma NON ha ancora un file prova, quindi da riga di comando la conferma non si legge e la casella resta NON ANCORA MISURATO;
  - la porta dello stadio B (n del report meno gli ingressi a spread zero >= 30), l'eccezione n = 0, i controlli CE1 (ancora) CE2 (firma dell'oro) CE3 CE4 CE6;
  - l'esito A / B / C con la dicitura prescritta. Ogni ESCLUSA esce SOLO se valgono le condizioni E la prova d'accettazione di questo strumento (sui giornali
    archiviati di S0_01 e R1A T1, rifatta a OGNI lancio, righe >= 40x e >= 50x comprese) e' passata.
REGOLE DI CONTO (scritte prima dei numeri):
  - le righe '-1.0x' (spread zero, EA r.711) valgono stop/spread INFINITO e NON si scartano; qualunque altro valore negativo = ERRORE (non si indovina);
    le righe 'ATR non valido' (campo 0,0x) entrano nel C3G col loro valore e non contano nella (v); con spread zero stampano -1,0x = INFINITO e contano (E4);
  - mediana su un numero PARI di valori = media delle due centrali (se una delle due e' INFINITO la mediana e' INFINITO), ARROTONDATA a 9 decimali: i valori sono
    stampati a 1 decimale e la media in virgola mobile di due di essi puo' cadere un ulp SOTTO la soglia (es. (10,2 + 16,4) / 2 = 13,299999999999999 < 13,3),
    cioe' verso 'ESCLUSA' (strato 2 del cancello, 12/10);
  - deduplica delle righe del giornale con la STESSA chiave del driver (GBA_R0_PASSATE.ps1 r.719-723: ora simulata al secondo + primi 70 caratteri del messaggio,
    si tiene il messaggio piu' lungo): sul giornale scritto dal driver deve togliere ZERO righe; se ne toglie anche una, lo zip e' RIFIUTATO.
  - lo zip e' RIFIUTATO (nessun numero) se: lotto sconosciuto o caricato due volte; file prova assente o con SHA256 diverso da quello pinnato nella riga di lancio;
    RIEPILOGO_R0.txt assente, o con un pin diverso da quello della riga (cc9bcda0) o con lo SHA256 dell'EA diverso da 1381E3DC; ESITI_R2S_A.txt con un altro pin;
    simbolo/TF/tranche/modello/magic del manifest, dell'ini, della riga AVVIO, della riga FINESTRA o del report diversi da quelli del file prova; input dell'ini diversi
    dai pin del file prova; la stessa cella due volte nel manifest; giornale assente per una passata lanciata; una riga '[GBA] segnale' che il parser non legge;
    ora server fuori da 0-23 o DIVERSA dall'ora dell'orario simulato della riga; data di una riga segnale fuori dalla tranche.
NON FA: non legge PF, DD, deal; non stampa la L3 (la stampa il lettore, righe (6)); non valuta il G0 del lettore (precondizione esterna: si legge in leggi_gba_r0.py
sezione (1)); non valuta l'A3 dell'ancora (doppione con GBA_R0_S0.zip: e' del lettore); non promuove niente; non scrive la parola vietata del certificato.

USO (sempre con -I)
  python3 -I backtest_pipeline/leggi_gba_r2s_c3g.py GBA_R2S_A.zip [--csv-out D2_C3G_R2S_A.csv]
  python3 -I backtest_pipeline/leggi_gba_r2s_c3g.py GBA_R0_R2SANC.zip GBA_R0_R2SXAG.zip ... [--csv-out F]
  python3 -I backtest_pipeline/leggi_gba_r2s_c3g.py GBA_R0_R2SANC.zip GBA_R2S_XAG2.zip [--csv-out D2_C3G_R2S_XAG2.csv]   (ancora del 12/10 + raccolta del rilancio;
       oppure GBA_R0_R2SXAG2.zip al posto della raccolta. GBA_R0_R2SANC.zip e' DENTRO risultati_archivio/GBA_R2S_A_20261012/GBA_R2S_A.zip: si estrae, non si rigira)
  python3 -I backtest_pipeline/leggi_gba_r2s_c3g.py --autotest
  uscita: 0 letto; 1 autotest fallito; 2 ERRORE / zip RIFIUTATO (nessun numero).
"""
import csv, hashlib, io, math, os, re, statistics, sys, zipfile

sys.dont_write_bytecode = True

QD = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(QD, ".."))
VERSIONE = "leggi_gba_r2s_c3g v3 (D2 + lotto R2SXAG2, rilancio dell'argento)"

# ---------------------------------------------------------------------------------------------------------------------
#  DEFINIZIONI COPIATE (l'autotest verifica che siano identiche a quelle del lettore leggi_gba_r0.py, SHA256 9CD02D2A...)
# ---------------------------------------------------------------------------------------------------------------------
FASCE = [(0, 7, "asia"), (7, 12, "europa"), (12, 14, "pausa"), (14, 17, "USA apertura"), (17, 22, "USA pomeriggio"), (22, 24, "rollover")]
RE_SEG = re.compile(r"^\[GBA\] segnale (?P<lato>BUY|SELL)(?: SALTATO \((?P<motivo>[^)]*)\))? \| close (?P<close>[0-9.]+) canale (?P<ll>[0-9.]+)-(?P<hh>[0-9.]+) EMA (?P<ema>[0-9.]+) "
                    r"ATR (?P<atr>[0-9.]+) spread (?P<spread>[0-9.]+) = (?P<pct>-?[0-9.]+)% ATR \(max (?P<max>[0-9.]+)%\) \| stop/spread (?P<rap>-?[0-9.]+)x \| ora server (?P<ora>[0-9]+)")
RE_ING = re.compile(r"^\[GBA\] (?P<lato>BUY|SELL) (?P<lotti>[0-9.]+) lotti @ (?P<prezzo>[0-9.]+) \| SL (?P<sl>[0-9.]+) \((?P<k>[0-9.]+) x ATR (?P<atr>[0-9.]+)\) \| spread (?P<spread>[0-9.]+) \| perdita a SL ~(?P<perdita>-?[0-9.]+) (?P<valuta>\w+)")
# riga del giornale: come $reGba del driver (r.552) e leggi_log del lettore (r.260)
RE_RIGA = re.compile(r"^(?P<st>\d{4}\.\d\d\.\d\d \d\d:\d\d:\d\d)\s+(?P<msg>\[GBA.*)$")
# [GBA-CONTA] FINE con TUTTI i contatori dell'EA (EA r.735; il lettore ne legge solo i primi quattro)
RE_CONTA = re.compile(r"^\[GBA-CONTA\] FINE \| segnali (?P<seg>[0-9]+) \| ingressi tentati (?P<ing>[0-9]+) \| scartati: SPREAD (?P<spr>[0-9]+) \(spread max [0-9.]+ x ATR\) \| "
                      r"posizione aperta (?P<pos>[0-9]+) \| ora (?P<ora>[0-9]+) \| perdita giornaliera (?P<giorno>[0-9]+) \| lato spento (?P<lato>[0-9]+) \| ATR non valido (?P<dati>[0-9]+) \| "
                      r"tetto giornaliero (?P<tetto>[0-9]+)")
RE_AVVIO = re.compile(r'^\[GBA\] AVVIO v[0-9.]+ \| InpSymbol="(?P<sim>[^"]*)" -> simbolo (?P<sim2>\S+) \| InpSignalTF=(?P<tf>\S+) -> PERIOD_(?P<tf2>[A-Z0-9]+)')
RE_FINESTRA = re.compile(r"^# FINESTRA (?P<sim>[^|]+)\|(?P<tf>[^|]+)\|(?P<da>[^|]+)\|(?P<ha>[^|]+)\|(?P<a>[^|]+)\|(?P<hb>[^|]+)$")
MOTIVI_EA = ("ok", "posizione gia' aperta", "fuori orario", "perdita giornaliera raggiunta", "spread oltre il limite", "ATR non valido", "lato spento",
             "tetto di operazioni del giorno")   # EA GbaMotivoTesto r.741-752

# ---------------------------------------------------------------------------------------------------------------------
#  IL LOTTO R2S STADIO A, COME E' STATO LANCIATO (riga backtest_pipeline/righe/RIGA_LANCIA_GBA_R2S_A.txt, PASS, pin cc9bcda0; SHA dei file prova = $LOTTI della riga)
# ---------------------------------------------------------------------------------------------------------------------
TRANCHE = ("T1", "2026.07.01", "2026.09.30")
MODELLO = "1"
MAGIC = "775800"
PIN_A = "cc9bcda0b64943b1e02ae8f52af68ccff81012d4"      # pin della riga RIGA_LANCIA_GBA_R2S_A (il driver lo scrive minuscolo nel RIEPILOGO, r.142 e r.877)
PIN_XAG2 = "d53493a92901b82c6b4c12c1d79ec3cb4ebfa5bb"   # pin della riga RIGA_LANCIA_GBA_R2S_XAG2 (PASS al 4o giro, scheda XAG2 in fondo)
PIN_AMMESSI = (PIN_A, PIN_XAG2)                          # ammessi SOLO PER LOTTO (LOTTI[L]["pin"]): lo zip del 12/10 resta leggibile, nessun pin vale per un altro lotto
SHA_EA = "1381E3DC9B4B4E44BCDC0319F023CB1990900CE0D1A6B6A3EC1DF5DF99E601B1"   # EA v1.10 (-ShaEA della riga; il driver lo scrive maiuscolo, r.151 e r.878)
TF_NUM = {"M1": "1", "M5": "5", "M15": "15"}
LOTTI = {
    "R2SANC": {"prova": "GBA_R2S_ANCORA_2026-10-12.txt", "sha": "42773ac50e3665e8a1b0fca038bdf2da3faf9c24ed42a2184f90f03eeb0d05ae", "simbolo": "XAUUSD",
               "celle": [("REPL", "M1")], "S": None, "pin": PIN_A},
    "R2SXAG": {"prova": "GBA_R2S_XAGUSD_2026-10-12.txt", "sha": "019c99bb53c45cfe92434e363e716bc409f408ece0299b1b49584d563dbe46de", "simbolo": "XAGUSD",
               "celle": [("REPL", "M1"), ("M15", "M15")], "S": 6.65, "pin": PIN_A},
    # RILANCIO DELL'ARGENTO (X1-X6 del file prova): M15 PRIMA nel manifest (X2), tag verificati
    "R2SXAG2": {"prova": "GBA_R2S_XAGUSD2_2026-10-12.txt", "sha": "dbe11bc3b219fdc13464e1a8531552658f2b62b42e7e871e3a377b7b6e6c57b3", "simbolo": "XAGUSD",
                "celle": [("M15", "M15"), ("REPL", "M1")], "S": 6.65, "pin": PIN_XAG2,
                "tag": {"M15": "R2SXAG2_01_M15_T1_m775800", "REPL": "R2SXAG2_02_REPL_T1_m775800"}},
    "R2SNAS": {"prova": "GBA_R2S_NASUSD_2026-10-12.txt", "sha": "3eabed3d735cf162c69afe90cc420af7533933f5669155c8d46e5e47a69cfe4c", "simbolo": "NASUSD",
               "celle": [("M5", "M5"), ("M15", "M15")], "S": 13.3, "pin": PIN_A},
    "R2SD30": {"prova": "GBA_R2S_D30EUR_2026-10-12.txt", "sha": "3c8cf14be362ae1373b69c4a6bb309568a29d743978814d570417a52646b2507", "simbolo": "D30EUR",
               "celle": [("M5", "M5"), ("M15", "M15")], "S": 13.3, "pin": PIN_A},
    "R2SU30": {"prova": "GBA_R2S_U30USD_2026-10-12.txt", "sha": "5c7e8e4d250f54310a6f4b3b6876e9cc496a0546330bc3d07dfb982983ce6c28", "simbolo": "U30USD",
               "celle": [("M5", "M5"), ("M15", "M15")], "S": 13.3, "pin": PIN_A},
}
ORDINE = ["R2SANC", "R2SXAG", "R2SXAG2", "R2SNAS", "R2SD30", "R2SU30"]
# DUE GIRI, letti separati: lo stadio A del 12/10 (pin cc9bcda0) e il rilancio dell'argento (pin d53493a9) con la SOLA ancora del 12/10 (X6). Un lotto di un giro
# non si stampa (nemmeno come 'NON CARICATO') nella lettura dell'altro: la lettura dello stadio A resta quella della v2.
GIRO_A = ("R2SANC", "R2SXAG", "R2SNAS", "R2SD30", "R2SU30")
GIRO_XAG2 = ("R2SANC", "R2SXAG2")
ESITI_FILE = {"ESITI_R2S_A.txt": (PIN_A, set(GIRO_A)), "ESITI_R2S_XAG2.txt": (PIN_XAG2, {"R2SXAG2"})}   # raccolta: pin e lotti ammessi
# X6 (1): l'ancora del lotto R2SXAG2 e' QUELLA del 12/10: GBA_R0_R2SANC.zip dentro risultati_archivio/GBA_R2S_A_20261012/GBA_R2S_A.zip (SHA256 dello zip interno)
SHA_ANCORA_1210 = "259f4ba0922b4406dc58847b29525ea7467b1043565e3e8cc10148d1d2f4b980"
ARCH_R2S_A = os.path.join(QD, "risultati_archivio", "GBA_R2S_A_20261012", "GBA_R2S_A.zip")
# REGRESSIONE (autotest): la lettura v2 archiviata dello stadio A deve uscire IDENTICA dalla v3, salvo la riga 2 (versione e SHA256 di D2) e la riga del percorso del CSV
SHA_ARCH_R2S_A = "ae62e772345fa531cc7a5f6f041b248923e52f48a1f804904669368e82ce2814"
ARCH_LETTURA_A = (os.path.join(QD, "risultati_archivio", "GBA_R2S_A_20261012", "LETTURA_D2_R2S_A.txt"), "d3359c0960e7653013e26f60e39b917602e6815d4f1ba2007eeee1bafbf0419d")
ARCH_CSV_A = (os.path.join(QD, "risultati_archivio", "GBA_R2S_A_20261012", "D2_C3G_R2S_A.csv"), "910109693cab047407c3355a7b63f6e13f77ab41a84297928f5025e78f335efb")
# CE7 del file prova XAG2 (r.68-78): i numeri del giornale della REPL del 12/10 COME LI STAMPA D2 (LETTURA_D2_R2S_A.txt r.35-45), tolleranza ZERO sulle cifre stampate
CE7_ATTESA = {"righe": 6611, "conta": {"seg": 6611, "ing": 0, "spr": 6611, "pos": 0, "dati": 0}, "cella": "2.40", "BUY": ("2.50", 3364), "SELL": ("2.30", 3247),
              "fasce": [("asia", 2149, "2.10"), ("europa", 1458, "2.40"), ("pausa", 680, "2.80"), ("USA apertura", 802, "4.20"), ("USA pomeriggio", 1251, "2.10"),
                        ("rollover", 271, "1.40")]}
DEPOSITO = "1000000.00"      # CE8: 'final balance' uguale al deposito = zero operazioni chiuse (file prova XAG2, CE8)
CE8_ENTRO_S = 60             # CE8: 'test finito entro ~1 minuto' dall'avvio (12/10: +13 s); oltre = 'test finito TARDI' (DESCRIZIONE, nessun esito ne dipende)
# SOGLIE (copiate dagli ESITI dei file prova e dagli emendamenti E1-E3 di docs/RISPOSTA_A_GEMINI_GBA_R2S_STADIO_A_2026-10-12.md)
N_PORTA = 30                 # (A): n >= 30, al netto degli ingressi a spread zero
COSTO_LAVORO = 40.0          # S2: >= 40 PASSA ('solo spread' sugli ingressi); frase dell'esito (A) sul C3G
COSTO_DURO = 13.3            # frase 'SOTTO 13,3x' dell'esito (A)
N_FASCIA_I = 100             # (i): almeno una fascia con >= 100 righe (non cambia con E1)
N_LATO_IV = 100              # (iv): ciascun lato con >= 100 righe (non cambia con E1)
SOGLIA_II_PINNATA = 100      # (ii) secondo il testo pinnato
SOGLIA_II_E1 = 30            # (ii) con l'emendamento E1
SOGLIA_V_X = 40.0            # (v) di E4: righe della cella con stop/spread >= 40,0x (frontiera di casa, inclusivo; -1.0x = INFINITO e conta)
N_RIGHE_V = 30               # (v): quelle righe devono essere < 30
CE3_MEDIANA_MIN, CE3_P10_MIN, CE3_SOGLIA_QUOTA = 50.0, 49.0, 40.0
FIRMA_ORO_SPREAD = (0.15, 0.30)   # CE2: spread mediano di fascia dell'oro (S0 0,17-0,25)
FIRMA_ORO_ATR_XAG = 0.60          # CE2 argento: e ATR mediana > 0,60
INF = float("inf")

# PROVA D'ACCETTAZIONE (numeri gia' scritti nella scheda, sez. 8 D2, e nella verifica Gemini; giornali archiviati, SHA256 pinnati)
ARCH = os.path.join(QD, "risultati_archivio")
ACC_S0 = {"zip": os.path.join(ARCH, "GBA_R0_S0_20261010", "GBA_R0_S0.zip"), "sha": "0cbaa6e82cd612558f0234741f0abdd54634e587ffe45a53a644d076befbbe6c",
          "log": "log/GBA_S0_01_REPL_T1_m775800.txt"}
ACC_R1A = {"zip": os.path.join(ARCH, "GBA_R0_R1A_20261010", "GBA_R0_R1A.zip"), "sha": "76837ce60c53d4806c79db2d0f3a5754b84a227c878f6f92b8e2d783d7d5014f",
           "log": "log/GBA_R1A_01_REPL_T1_m775800.txt"}
ATTESA_S0 = {"righe": 6973, "cella": 22.80, "ingressi": 158, "tentati": 158, "spread_zero": 0, "ge40": 740, "ge50": 355,   # ge40/ge50: E4 (doc. RISPOSTA_A_GEMINI)
             "fasce": {"asia": 19.80, "europa": 24.50, "pausa": 26.20, "USA apertura": 39.20, "USA pomeriggio": 20.60, "rollover": 10.65},
             "asia_buy": (21.40, 1139), "asia_sell": (18.50, 1175),
             # CE1 dell'ancora (file prova ANCORA, A1/A2): manifest di S0_01 e costo 'solo spread' sugli ingressi del lettore (55,9x)
             "trades": 158, "profitto": "-6364.79", "pf": "0.86", "solo_spread_1d": "55.9", "conta": (6973, 158, 6520, 295)}
ATTESA_R1A = {"cella": 21.60, "ingressi": 128, "ge40": 651, "ge50": 280}
LETTORE_SHA256 = "9cd02d2a3bd30e3df555f20fc0342cfcccab80222ad671f0bf727be1deaf862f"


class Rifiuto(Exception):
    """Lo zip non si legge: nessun numero esce (non si indovina)."""


# ---------------------------------------------------------------------------------------------------------------------
#  STATISTICHE
# ---------------------------------------------------------------------------------------------------------------------
def mediana(v):
    """Mediana VERA: n dispari = il valore centrale; n PARI = media delle due centrali (dichiarato). INF entra come valore. Vuota -> None."""
    if not v:
        return None
    s = sorted(v)
    n = len(s)
    if n % 2 == 1:
        return s[n // 2]
    a, b = s[n // 2 - 1], s[n // 2]
    if a == INF or b == INF:
        return INF
    return round((a + b) / 2.0, 9)   # niente ulp sotto la soglia: (10.2 + 16.4) / 2 = 13.299999999999999 senza round


def percentile(v, p):
    """Come il lettore (r.316): indice int(p x (n-1)) sui valori ordinati."""
    if not v:
        return None
    s = sorted(v)
    return s[min(len(s) - 1, int(p * (len(s) - 1)))]


def fx(x, d=2):
    if x is None:
        return "n.d."
    if x == INF:
        return "INF"
    return ("%." + str(d) + "f") % x


def uguale(a, b):
    return a is not None and b is not None and abs(a - b) < 0.005


def _norm(v):
    """Copiata dal lettore (r.506): '1.0' e '1.00' sono lo stesso input."""
    try:
        if re.fullmatch(r"-?[0-9]+(\.[0-9]+)?", str(v)):
            return repr(float(v))
    except ValueError:
        pass
    return str(v)


# ---------------------------------------------------------------------------------------------------------------------
#  IL GIORNALE DELL'EA
# ---------------------------------------------------------------------------------------------------------------------
def leggi_giornale(testo, etich="giornale"):
    """Restituisce {righe, ingressi_eseguiti, conta, avvio, finestre, doppioni, ridotti}. Rifiuto su ogni riga che non si sa leggere."""
    msgs, ordine, testa = {}, [], []
    for riga in testo.splitlines():
        riga = riga.rstrip()
        if not riga:
            continue
        if riga.startswith("#"):
            testa.append(riga)
            continue
        m = RE_RIGA.match(riga)
        if not m:
            continue
        st, msg = m.group("st"), m.group("msg").rstrip()
        k = st + "|" + msg[:70]                       # chiave del driver r.719-721
        if k not in msgs:
            msgs[k] = [st, msg]
            ordine.append(k)
        else:
            if len(msg) > len(msgs[k][1]):
                msgs[k][1] = msg
            msgs[k].append(None)                    # segna il doppione
    doppioni = sum(len(msgs[k]) - 2 for k in ordine)
    out = {"righe": [], "ingressi_eseguiti": [], "conta": None, "avvio": [], "finestre": [], "doppioni": doppioni, "ridotti": 0, "conta_n": 0,
           "tester": [t for t in testa if t.startswith("# TESTER ")]}    # righe del tester raccolte dal driver (r.735, r.823): servono SOLO al CE8 (descrizione)
    for t in testa:
        mf = RE_FINESTRA.match(t)
        if mf:
            out["finestre"].append(mf.groupdict())
    for k in ordine:
        st, msg = msgs[k][0], msgs[k][1]
        if msg.startswith("[GBA] segnale "):
            ms = RE_SEG.match(msg)
            if not ms:
                raise Rifiuto("%s: riga segnale che il parser NON legge (non si indovina): %s" % (etich, msg[:160]))
            d = ms.groupdict()
            rap = float(d["rap"])
            if rap < 0 and rap != -1.0:
                raise Rifiuto("%s: stop/spread negativo diverso da -1.0x (%s): sentinella sconosciuta" % (etich, d["rap"]))
            ora = int(d["ora"])
            if not 0 <= ora <= 23:
                raise Rifiuto("%s: ora server %d fuori da 0-23" % (etich, ora))
            # OROLOGIO: il campo 'ora server' e' dt.hour dell'apertura della barra (EA r.695-696, r.726); l'orario della riga e' quello simulato del tester (driver
            # $reGba r.552), nella stessa barra. Sui giornali dell'oro coincidono su 6973 righe su 6973 (S0_01 e R1A T1): se differiscono, il giornale non si legge.
            if int(st[11:13]) != ora:
                raise Rifiuto("%s: ora server %d diversa dall'ora dell'orario simulato della riga (%s): orologio incoerente, non si indovina la fascia" % (etich, ora, st))
            motivo = d["motivo"] or ""
            if d["motivo"] is not None and motivo not in MOTIVI_EA:
                raise Rifiuto("%s: motivo SALTATO sconosciuto '%s'" % (etich, motivo))
            out["righe"].append({"st": st, "lato": d["lato"], "preso": d["motivo"] is None, "motivo": motivo, "atr": float(d["atr"]), "spread": float(d["spread"]),
                                 "rap": rap, "val": INF if rap == -1.0 else rap, "ora": ora})
            continue
        mi = RE_ING.match(msg)
        if mi:
            d = mi.groupdict()
            out["ingressi_eseguiti"].append({"lato": d["lato"], "lotti": float(d["lotti"]), "atr": float(d["atr"]), "spread": float(d["spread"])})
            continue
        if msg.startswith("[GBA-CONTA] FINE"):
            mc = RE_CONTA.match(msg)
            if not mc:
                raise Rifiuto("%s: riga [GBA-CONTA] FINE che il parser NON legge: %s" % (etich, msg[:160]))
            out["conta"] = {kk: int(v) for kk, v in mc.groupdict().items()}
            out["conta_n"] += 1
            continue
        if msg.startswith("[GBA] AVVIO v"):
            ma = RE_AVVIO.match(msg)
            if not ma:
                raise Rifiuto("%s: riga AVVIO che il parser NON legge: %s" % (etich, msg[:160]))
            out["avvio"].append(ma.groupdict())
            continue
        if "lotto richiesto" in msg and "ridotto" in msg:
            out["ridotti"] += 1
    return out


def analizza(righe):
    """C3G della cella, dei lati, delle fasce (e per lato dentro la fascia), righe >= 50x, ingressi e spread zero."""
    def blocco(rr):
        return {"n": len(rr), "c3g": mediana([r["val"] for r in rr])}
    ing = [r for r in righe if r["preso"]]
    A = {"n": len(righe), "c3g": mediana([r["val"] for r in righe]), "ingressi": len(ing),
         "ingressi_spread_zero": sum(1 for r in ing if r["rap"] == -1.0), "righe_spread_zero": sum(1 for r in righe if r["rap"] == -1.0),
         "ge50": sum(1 for r in righe if r["val"] >= 50.0), "ge40": sum(1 for r in righe if r["val"] >= SOGLIA_V_X), "spread_cella": mediana([r["spread"] for r in righe]),
         "lati": {l: blocco([r for r in righe if r["lato"] == l]) for l in ("BUY", "SELL")}, "fasce": [], "motivi": {}}
    for r in righe:
        A["motivi"][r["motivo"] or "ok"] = A["motivi"].get(r["motivo"] or "ok", 0) + 1
    liberi = [r for r in righe if r["preso"] or r["motivo"].startswith("spread")]
    A["liberi"] = len(liberi)
    A["scartati_spread"] = sum(1 for r in righe if (not r["preso"]) and r["motivo"].startswith("spread"))
    for lo, hi, nome in FASCE:
        rr = [r for r in righe if lo <= r["ora"] < hi]
        f = blocco(rr)
        f.update({"nome": nome, "lo": lo, "hi": hi, "ge50": sum(1 for r in rr if r["val"] >= 50.0), "ge40": sum(1 for r in rr if r["val"] >= SOGLIA_V_X), "ingressi": sum(1 for r in rr if r["preso"]),
                  "BUY": blocco([r for r in rr if r["lato"] == "BUY"]), "SELL": blocco([r for r in rr if r["lato"] == "SELL"]),
                  "atr_med": mediana([r["atr"] for r in rr]), "spread_med": mediana([r["spread"] for r in rr])})
        f["quota_ingressi"] = (f["ingressi"] / float(A["ingressi"])) if A["ingressi"] else None
        A["fasce"].append(f)
    return A


def condizioni_b(A, S, soglia_ii, usa_e4=True):
    """Le condizioni di 'ESCLUSA' dell'esito (B), LETTERALI. soglia_ii = 100 (testo pinnato) o 30 (E1). (v) = E4: righe della CELLA con stop/spread >= 40,0x
    (inclusivo; -1.0x = INFINITO, conta) < 30. 'tutte' = (i)-(iv) senza E4, (i)-(v) con E4. (v) si calcola e si stampa sempre."""
    i = any(f["n"] >= N_FASCIA_I for f in A["fasce"])
    sel = [f for f in A["fasce"] if f["n"] >= soglia_ii]
    ii = all(f["c3g"] < S for f in sel)
    iii = A["c3g"] is not None and A["c3g"] < S
    iv = all(A["lati"][l]["n"] >= N_LATO_IV and A["lati"][l]["c3g"] is not None and A["lati"][l]["c3g"] < S for l in ("BUY", "SELL"))
    v = A["ge40"] < N_RIGHE_V
    base = i and ii and iii and iv
    return {"i": i, "ii": ii, "iii": iii, "iv": iv, "v": v, "tutte": base and (v if usa_e4 else True), "fasce_ii": [f["nome"] for f in sel]}


def costo_solo_spread(ingressi):
    """Come il lettore costo_ingressi (r.430), riga 'solo spread': 2,5 x ATR / spread sulle righe d'ingresso, spread 0,00 scartato."""
    v = [2.5 * e["atr"] / e["spread"] for e in ingressi if e["spread"] > 0]
    return v


# ---------------------------------------------------------------------------------------------------------------------
#  REPORT, INI, PROVA
# ---------------------------------------------------------------------------------------------------------------------
def decodifica(raw):
    if raw[:2] in (b"\xff\xfe", b"\xfe\xff"):
        return raw.decode("utf-16", "replace")
    if len(raw) > 4 and raw[1:2] == b"\x00" and raw[3:4] == b"\x00":
        return raw.decode("utf-16-le", "replace")
    return raw.decode("utf-8", "replace").lstrip("\ufeff")


def leggi_report_min(raw):
    t = decodifica(raw)
    p = re.sub(r"<[^>]+>", "|", t)
    p = re.sub(r"\s*\|[\s|]*", "|", p)

    def cella(et):
        for e in et:
            m = re.search(r"\|" + e + r":\|([^|]*)\|", p)
            if m:
                return m.group(1).strip()
        return None
    tr = cella(["Numero di Operazioni di Trading Totali", "Total Trades"])
    return {"simbolo": cella(["Simbolo", "Symbol"]), "periodo": cella(["Periodo", "Period"]),
            "trades": int(re.sub(r"\s", "", tr)) if tr and re.sub(r"\s", "", tr).isdigit() else None}


def leggi_ini(testo):
    sez, out = None, {"tester": {}, "inputs": {}}
    for riga in testo.splitlines():
        riga = riga.strip()
        if not riga or riga.startswith(";"):
            continue
        if riga.startswith("[") and riga.endswith("]"):
            sez = riga[1:-1]
            continue
        if "=" in riga:
            k, v = riga.split("=", 1)
            if sez == "Tester":
                out["tester"][k.strip()] = v.strip()
            elif sez == "TesterInputs":
                out["inputs"][k.strip()] = v.strip()
    return out


def pin_della_prova(testo):
    pin = {}
    for riga in testo.splitlines():
        s = riga.strip()
        if not s or s.startswith("#") or "=" not in s:
            continue
        k, v = s.split("=", 1)
        pin[k.strip()] = v.strip()
    return pin


# ---------------------------------------------------------------------------------------------------------------------
#  CARICAMENTO DI UNO ZIP DI LOTTO (o della raccolta GBA_R2S_A.zip)
# ---------------------------------------------------------------------------------------------------------------------
def _nomi(z):
    return {n.replace("\\", "/"): n for n in z.namelist() if not n.endswith("/")}


def leggi_lotto(nome_zip, dati):
    """Uno zip di lotto (bytes). Restituisce {lotto, passate:[P]}. Rifiuto su ogni non corrispondenza col file prova."""
    try:
        z = zipfile.ZipFile(io.BytesIO(dati))
    except zipfile.BadZipFile:
        raise Rifiuto("%s: non e' uno zip leggibile" % nome_zip)
    N = _nomi(z)
    if "MANIFEST_R0.csv" not in N:
        raise Rifiuto("%s: manca MANIFEST_R0.csv (non e' uno zip di lotto del driver)" % nome_zip)
    man = list(csv.DictReader(io.StringIO(z.read(N["MANIFEST_R0.csv"]).decode("ascii", "replace")), delimiter=";"))
    if not man:
        raise Rifiuto("%s: manifest vuoto" % nome_zip)
    servono = ("lotto", "passata", "cella", "tranche", "da", "a", "modello", "magic", "stato", "trades_report", "profitto_report", "pf_report", "avvio_ok", "autotest",
               "finestra", "motivi", "asse", "valore_asse", "simbolo", "periodo", "prova")
    manca = [c for c in servono if c not in man[0]]
    if manca:
        raise Rifiuto("%s: il manifest non e' del driver v5 (mancano le colonne %s)" % (nome_zip, ", ".join(manca)))
    lotti = set(r["lotto"] for r in man)
    if len(lotti) != 1:
        raise Rifiuto("%s: piu' lotti nello stesso manifest (%s)" % (nome_zip, ", ".join(sorted(lotti))))
    L = lotti.pop()
    if L not in LOTTI:
        raise Rifiuto("%s: lotto '%s' NON e' uno dei lotti R2S che D2 sa leggere (%s)" % (nome_zip, L, ", ".join(ORDINE)))
    base = os.path.basename(nome_zip.replace("\\", "/").split("!")[-1])
    if base.startswith("GBA_R0_") and base.lower().endswith(".zip") and base[7:-4] != L:
        raise Rifiuto("%s: il nome dello zip dice lotto %s, il manifest dice %s" % (nome_zip, base[7:-4], L))
    D = LOTTI[L]
    if D["prova"] not in N:
        raise Rifiuto("%s: il file prova %s NON e' nello zip" % (nome_zip, D["prova"]))
    raw_prova = z.read(N[D["prova"]])
    sha = hashlib.sha256(raw_prova).hexdigest()
    if sha != D["sha"]:
        raise Rifiuto("%s: il file prova %s ha SHA256 %s, la riga di lancio ha pinnato %s" % (nome_zip, D["prova"], sha[:12], D["sha"][:12]))
    # PROVENIENZA: pin della riga e SHA256 dell'EA, dal RIEPILOGO_R0.txt che il driver scrive nello zip (r.875-888). Un zip di un altro giro (altro pin, altro EA)
    # con lo stesso file prova NON e' questa misura.
    if "RIEPILOGO_R0.txt" not in N:
        raise Rifiuto("%s: manca RIEPILOGO_R0.txt: pin e EA della passata non verificabili" % nome_zip)
    rie = z.read(N["RIEPILOGO_R0.txt"]).decode("ascii", "replace")
    pins = set(re.findall(r"\bpin: ([0-9a-fA-F]{40})\b", rie))
    if len(pins) != 1 or next(iter(pins)).lower() != D["pin"]:      # pin PER LOTTO (v3): un pin ammesso per un altro lotto NON vale qui
        raise Rifiuto("%s: il RIEPILOGO dice pin %s, la riga di lancio del lotto %s e' al pin %s" % (nome_zip, ", ".join(sorted(pins)) or "assente", L, D["pin"]))
    if ("ABTG_GoldBreakoutATR.mq5 SHA256 " + SHA_EA) not in rie:
        raise Rifiuto("%s: il RIEPILOGO non dice ABTG_GoldBreakoutATR.mq5 SHA256 %s...: un altro EA" % (nome_zip, SHA_EA[:12]))
    pin = pin_della_prova(raw_prova.decode("ascii", "replace"))
    if pin.get("InpSymbol") != D["simbolo"]:
        raise Rifiuto("%s: il file prova pinna InpSymbol=%s, il lotto %s e' %s" % (nome_zip, pin.get("InpSymbol"), L, D["simbolo"]))
    celle_att = dict(D["celle"])
    celle_man = [r["cella"] for r in man]
    doppie = sorted(set(c for c in celle_man if celle_man.count(c) > 1))
    if doppie:
        raise Rifiuto("%s: la cella %s compare PIU' volte nel manifest: ogni numero sarebbe doppio" % (nome_zip, ", ".join(doppie)))
    if D.get("tag"):
        # X1-X2 (lotto R2SXAG2): tag delle passate della riga e ordine del manifest = ordine delle passate del file prova (M15 PRIMA, poi REPL)
        for r in man:
            if r["cella"] in D["tag"] and r["passata"] != D["tag"][r["cella"]]:
                raise Rifiuto("%s: la passata della cella %s si chiama %s, il file prova (X1-X2) dice %s" % (nome_zip, r["cella"], r["passata"], D["tag"][r["cella"]]))
        ordine_att = [c for c, _tf in D["celle"] if c in celle_man]
        if [c for c in celle_man if c in celle_att] != ordine_att:
            raise Rifiuto("%s: ordine delle celle nel manifest %s, il file prova (X2) dice %s" % (nome_zip, " -> ".join(celle_man), " -> ".join(ordine_att)))
    passate = []
    for r in man:
        tag = r["passata"]
        e = "%s %s" % (L, tag)
        if r["lotto"] != L or r["cella"] not in celle_att:
            raise Rifiuto("%s: cella '%s' NON dichiarata nel file prova %s (attese: %s)" % (e, r["cella"], D["prova"], ", ".join(celle_att)))
        tf = celle_att[r["cella"]]
        att = {"simbolo": D["simbolo"], "periodo": tf, "prova": D["prova"], "asse": "InpSignalTF", "valore_asse": TF_NUM[tf], "tranche": TRANCHE[0], "da": TRANCHE[1],
               "a": TRANCHE[2], "modello": MODELLO, "magic": MAGIC}
        for k, v in att.items():
            if (r.get(k) or "").strip() != v:
                raise Rifiuto("%s: manifest %s='%s', il file prova dice '%s'" % (e, k, r.get(k), v))
        P = {"lotto": L, "tag": tag, "cella": r["cella"], "tf": tf, "simbolo": D["simbolo"], "riga": r, "stato": r["stato"], "giornale": None, "report": None, "ini": None}
        if r["stato"] == "NON_LANCIATA":
            passate.append(P)
            continue
        # ini: input identici ai pin del file prova (InpSignalTF = la cella), tester col simbolo/TF/finestra/modello della cella
        ni = "ini/gba_" + tag + ".ini"
        if ni not in N:
            raise Rifiuto("%s: ini %s assente: simbolo e TF non verificabili" % (e, ni))
        ini = leggi_ini(z.read(N[ni]).decode("ascii", "replace"))
        te, inp = ini["tester"], ini["inputs"]
        for k, v in (("Symbol", D["simbolo"]), ("Period", tf), ("Model", MODELLO), ("FromDate", TRANCHE[1]), ("ToDate", TRANCHE[2])):
            if te.get(k) != v:
                raise Rifiuto("%s: ini [Tester] %s=%s, il file prova dice %s" % (e, k, te.get(k), v))
        attesi = dict(pin)
        attesi["InpSignalTF"] = TF_NUM[tf]
        attesi["InpMagic"] = MAGIC
        if set(inp) != set(attesi):
            raise Rifiuto("%s: input dell'ini diversi da quelli del file prova (in piu': %s; mancano: %s)" % (
                e, ", ".join(sorted(set(inp) - set(attesi))) or "-", ", ".join(sorted(set(attesi) - set(inp))) or "-"))
        for k in sorted(attesi):
            if _norm(inp[k]) != _norm(attesi[k]):
                raise Rifiuto("%s: ini %s=%s, il file prova dice %s" % (e, k, inp[k], attesi[k]))
        P["ini"] = ini
        # giornale
        nl = "log/GBA_" + tag + ".txt"
        if nl not in N:
            raise Rifiuto("%s: giornale %s ASSENTE: il C3G non si legge e non si indovina" % (e, nl))
        G = leggi_giornale(z.read(N[nl]).decode("ascii", "replace"), e)
        fuori = [x["st"] for x in G["righe"] if not (TRANCHE[1] <= x["st"][:10] <= TRANCHE[2])]
        if fuori:
            raise Rifiuto("%s: %d righe segnale fuori dalla tranche %s-%s (prima: %s): giornale di un'altra finestra" % (e, len(fuori), TRANCHE[1], TRANCHE[2], fuori[0]))
        if G["doppioni"]:
            raise Rifiuto("%s: la deduplica con la chiave del driver toglie %d righe: il giornale NON e' quello scritto dal driver" % (e, G["doppioni"]))
        for a in G["avvio"]:
            if not (a["sim"] == D["simbolo"] and a["sim2"] == D["simbolo"] and a["tf2"] == tf and a["tf"] == "PERIOD_" + tf):
                raise Rifiuto("%s: la riga AVVIO dell'EA dice %s %s (%s), il file prova dice %s %s" % (e, a["sim2"], a["tf2"], a["sim"], D["simbolo"], tf))
        for f in G["finestre"]:
            if not (f["sim"] == D["simbolo"] and f["tf"] == tf and f["da"] == TRANCHE[1] and f["a"] == TRANCHE[2]):
                raise Rifiuto("%s: la riga FINESTRA del tester dice %s,%s %s-%s, il file prova dice %s,%s %s-%s" % (
                    e, f["sim"], f["tf"], f["da"], f["a"], D["simbolo"], tf, TRANCHE[1], TRANCHE[2]))
        P["giornale"] = G
        cand = [n for n in N if n.startswith("report/GBA_R0_" + tag) and n.lower().endswith((".htm", ".html"))]
        if cand:
            rep = leggi_report_min(z.read(N[cand[0]]))
            if rep["simbolo"] is not None and rep["simbolo"] != D["simbolo"]:
                raise Rifiuto("%s: il report dice simbolo %s, il file prova %s" % (e, rep["simbolo"], D["simbolo"]))
            if rep["periodo"] is not None and not rep["periodo"].startswith(tf + " "):
                raise Rifiuto("%s: il report dice periodo '%s', il file prova %s" % (e, rep["periodo"], tf))
            P["report"] = rep
        passate.append(P)
    return {"lotto": L, "passate": passate, "zip": nome_zip, "sha_zip": hashlib.sha256(dati).hexdigest()}


def carica(percorsi):
    """Zip di lotto o raccolta GBA_R2S_A.zip / GBA_R2S_XAG2.zip (zip annidati). Restituisce ({lotto: lettura}, [note])."""
    lotti, note = {}, []

    def aggiungi(nome, dati):
        Lz = leggi_lotto(nome, dati)
        if Lz["lotto"] in lotti:
            raise Rifiuto("lotto %s caricato DUE volte (%s e %s): ogni numero sarebbe doppio" % (Lz["lotto"], lotti[Lz["lotto"]]["zip"], nome))
        lotti[Lz["lotto"]] = Lz
        return Lz["lotto"]
    for p in percorsi:
        try:
            dati = open(p, "rb").read()
            z = zipfile.ZipFile(io.BytesIO(dati))
        except (OSError, zipfile.BadZipFile) as ex:
            raise Rifiuto("%s: non leggibile (%s)" % (p, ex))
        N = _nomi(z)
        if "MANIFEST_R0.csv" in N:
            aggiungi(p, dati)
            continue
        interni = sorted(n for n in N if n.lower().endswith(".zip"))
        if not interni:
            raise Rifiuto("%s: ne' zip di lotto (MANIFEST_R0.csv) ne' raccolta (zip annidati)" % p)
        dentro = []
        for n in interni:
            if n.endswith("_COMPILAZIONE_FALLITA.zip"):
                note.append("%s: %s -> quel lotto si e' fermato alla COMPILAZIONE: nessuna passata, esito (C)" % (p, n))
                continue
            dentro.append(aggiungi(p + "!" + n, z.read(N[n])))
        for ne in ("ESITI_R2S_A.txt", "ESITI_R2S_XAG2.txt"):
            if ne not in N:
                continue
            pin_es, lotti_es = ESITI_FILE[ne]
            es = z.read(N[ne]).decode("ascii", "replace")
            pe = set(re.findall(r"\bpin ([0-9a-fA-F]{40})\b", es))
            if len(pe) != 1 or next(iter(pe)).lower() != pin_es:
                raise Rifiuto("%s: %s dice pin %s, la riga di lancio e' al pin %s" % (p, ne, ", ".join(sorted(pe)) or "assente", pin_es))
            estranei = sorted(set(dentro) - lotti_es)
            if estranei:
                raise Rifiuto("%s: la raccolta con %s contiene lotti di un altro giro (%s)" % (p, ne, ", ".join(estranei)))
            note.append(ne + ": " + " / ".join(x.strip() for x in es.splitlines() if x.strip()))
    if "R2SXAG2" in lotti:
        altri = sorted(L for L in lotti if L not in GIRO_XAG2)
        if altri:
            raise Rifiuto("il lotto R2SXAG2 (rilancio, pin %s) si legge SOLO con l'ancora del 12/10 GBA_R0_R2SANC.zip; caricati anche %s: due giri nella stessa "
                          "lettura (estrarre GBA_R0_R2SANC.zip da GBA_R2S_A.zip e rileggere)" % (PIN_XAG2[:8], ", ".join(altri)))
    return lotti, note


# ---------------------------------------------------------------------------------------------------------------------
#  ACCETTAZIONE (rifatta a ogni lancio, sui giornali archiviati)
# ---------------------------------------------------------------------------------------------------------------------
def _giornale_archivio(acc):
    raw = open(acc["zip"], "rb").read()
    if hashlib.sha256(raw).hexdigest() != acc["sha"]:
        raise Rifiuto("archivio %s con SHA256 diverso da quello pinnato" % acc["zip"])
    z = zipfile.ZipFile(io.BytesIO(raw))
    N = _nomi(z)
    return leggi_giornale(z.read(N[acc["log"]]).decode("ascii", "replace"), acc["log"]), z, N


def confronta_ancora(A, G, att):
    """Confronto delle misure D2 con i numeri gia' scritti dell'oro S0_01. Restituisce la lista dei disaccordi (vuota = identico)."""
    err = []
    if A["n"] != att["righe"]:
        err.append("righe segnale %d invece di %d" % (A["n"], att["righe"]))
    if not uguale(A["c3g"], att["cella"]):
        err.append("C3G cella %s invece di %.2f" % (fx(A["c3g"]), att["cella"]))
    for f in A["fasce"]:
        if not uguale(f["c3g"], att["fasce"][f["nome"]]):
            err.append("C3G %s %s invece di %.2f" % (f["nome"], fx(f["c3g"]), att["fasce"][f["nome"]]))
    asia = A["fasce"][0]
    if not (uguale(asia["BUY"]["c3g"], att["asia_buy"][0]) and asia["BUY"]["n"] == att["asia_buy"][1]):
        err.append("asia BUY %s (n %d) invece di %.2f (n %d)" % (fx(asia["BUY"]["c3g"]), asia["BUY"]["n"], att["asia_buy"][0], att["asia_buy"][1]))
    if not (uguale(asia["SELL"]["c3g"], att["asia_sell"][0]) and asia["SELL"]["n"] == att["asia_sell"][1]):
        err.append("asia SELL %s (n %d) invece di %.2f (n %d)" % (fx(asia["SELL"]["c3g"]), asia["SELL"]["n"], att["asia_sell"][0], att["asia_sell"][1]))
    if A["ingressi"] != att["ingressi"]:
        err.append("ingressi %d invece di %d" % (A["ingressi"], att["ingressi"]))
    if G["conta"] is None or G["conta"]["ing"] != att["tentati"]:
        err.append("tentati %s invece di %d" % (G["conta"]["ing"] if G["conta"] else "n.d.", att["tentati"]))
    if A["righe_spread_zero"] != att["spread_zero"]:
        err.append("righe -1.0x %d invece di %d" % (A["righe_spread_zero"], att["spread_zero"]))
    if (A["ge40"], A["ge50"]) != (att["ge40"], att["ge50"]):
        err.append("righe >= 40x / >= 50x %d / %d invece di %d / %d" % (A["ge40"], A["ge50"], att["ge40"], att["ge50"]))
    return err


def accettazione():
    """Restituisce (ok, righe di testo)."""
    out = []
    try:
        G, _z, _N = _giornale_archivio(ACC_S0)
        A = analizza(G["righe"])
        err = confronta_ancora(A, G, ATTESA_S0)
        out.append("   S0_01 (Modello 1): cella %s; fasce %s; asia BUY %s (n %d) SELL %s (n %d); ingressi %d, tentati %s, righe -1.0x %d, righe >= 40x %d, >= 50x %d -> %s" % (
            fx(A["c3g"]), " / ".join("%s %s" % (f["nome"], fx(f["c3g"])) for f in A["fasce"]), fx(A["fasce"][0]["BUY"]["c3g"]), A["fasce"][0]["BUY"]["n"],
            fx(A["fasce"][0]["SELL"]["c3g"]), A["fasce"][0]["SELL"]["n"], A["ingressi"], G["conta"]["ing"] if G["conta"] else "n.d.", A["righe_spread_zero"], A["ge40"], A["ge50"],
            "IDENTICI ai numeri scritti" if not err else "DIVERSI: " + "; ".join(err)))
        G2, _z2, _N2 = _giornale_archivio(ACC_R1A)
        A2 = analizza(G2["righe"])
        err2 = []
        if not uguale(A2["c3g"], ATTESA_R1A["cella"]):
            err2.append("cella %s invece di %.2f" % (fx(A2["c3g"]), ATTESA_R1A["cella"]))
        if A2["ingressi"] != ATTESA_R1A["ingressi"]:
            err2.append("ingressi %d invece di %d" % (A2["ingressi"], ATTESA_R1A["ingressi"]))
        if (A2["ge40"], A2["ge50"]) != (ATTESA_R1A["ge40"], ATTESA_R1A["ge50"]):
            err2.append("righe >= 40x / >= 50x %d / %d invece di %d / %d" % (A2["ge40"], A2["ge50"], ATTESA_R1A["ge40"], ATTESA_R1A["ge50"]))
        out.append("   R1A T1 (tick reali): cella %s, ingressi %d, righe >= 40x %d, >= 50x %d -> %s" % (fx(A2["c3g"]), A2["ingressi"], A2["ge40"], A2["ge50"],
                                                                                              "IDENTICI" if not err2 else "DIVERSI: " + "; ".join(err2)))
        return (not err and not err2), out
    except (OSError, KeyError, Rifiuto) as ex:
        out.append("   accettazione NON eseguita: %s" % ex)
        return False, out


# ---------------------------------------------------------------------------------------------------------------------
#  I CONTROLLI E L'ESITO DI UNA PASSATA
# ---------------------------------------------------------------------------------------------------------------------
_SHA_D2 = []


def sha_d2():
    """SHA256 di questo file (lo strumento che ha letto la passata): E3 lo confronta fra la passata a Modello 1 e quella a tick reali."""
    if not _SHA_D2:
        _SHA_D2.append(hashlib.sha256(open(os.path.abspath(__file__), "rb").read()).hexdigest())
    return _SHA_D2[0]


def controlli(P):
    """Calcola A, n, CE2-CE6 di una passata lanciata. Scrive in P (anche lo SHA256 di D2 che l'ha letta)."""
    P["sha_d2"] = sha_d2()
    G = P["giornale"]
    A = analizza(G["righe"])
    P["A"] = A
    r = P["riga"]
    tr = r.get("trades_report", "").strip()
    P["n"] = int(tr) if tr.isdigit() else None
    if P["report"] and P["report"]["trades"] is not None and P["n"] is not None and P["report"]["trades"] != P["n"]:
        P["n"] = None
        P["nota_n"] = "operazioni del report %d contro manifest %s" % (P["report"]["trades"], tr)
    c = G["conta"]
    ce = {}
    # CE2: firma dell'oro su OGNI fascia stampata (almeno una)
    stampate = [f for f in A["fasce"] if f["n"] > 0]
    if P["simbolo"] == "XAUUSD":
        ce["CE2"] = (True, "ancora: e' oro")
    else:
        def firma(f):
            s_ok = f["spread_med"] is not None and FIRMA_ORO_SPREAD[0] <= f["spread_med"] <= FIRMA_ORO_SPREAD[1]
            if P["simbolo"] == "XAGUSD":
                return s_ok and f["atr_med"] is not None and f["atr_med"] > FIRMA_ORO_ATR_XAG
            return s_ok
        rosso = bool(stampate) and all(firma(f) for f in stampate)
        ce["CE2"] = (not rosso, "firma dell'ORO su ogni fascia (letta come XAUUSD)" if rosso else "firma dell'oro assente")
    # CE3: costo 'solo spread' sugli ingressi (per costruzione >= 50x)
    v = costo_solo_spread(G["ingressi_eseguiti"])
    P["solo_spread"] = v
    if not v:
        ce["CE3"] = (True, "nessun ingresso con spread: non applicabile")
    else:
        m, p10 = mediana(v), percentile(v, 0.10)
        q40 = sum(1 for x in v if x < CE3_SOGLIA_QUOTA) / float(len(v))
        ok3 = m >= CE3_MEDIANA_MIN and p10 >= CE3_P10_MIN and q40 == 0
        ce["CE3"] = (ok3, "solo spread n=%d mediana %.1f p10 %.1f quota <40x %.0f%%" % (len(v), m, p10, 100 * q40))
    # CE4: segnali(EA) = somma dei motivi; e (D2) il giornale ha tutte le righe dell'EA
    if c is None or G["conta_n"] != 1:
        ce["CE4"] = (False, "riga [GBA-CONTA] FINE assente o ripetuta (%d)" % G["conta_n"])
        ce["CE6"] = (False, "tentati non leggibili")
    else:
        somma = c["ing"] + c["spr"] + c["pos"] + c["ora"] + c["giorno"] + c["lato"] + c["dati"] + c["tetto"]
        ok4 = c["seg"] == somma and A["n"] == c["seg"] and A["ingressi"] == c["ing"] and A["scartati_spread"] == c["spr"]
        ce["CE4"] = (ok4, "segnali(EA) %d = tentati %d + spread %d + posizione %d + altri %d (somma %d); righe del giornale %d, senza SALTATO %d, SALTATO per spread %d" % (
            c["seg"], c["ing"], c["spr"], c["pos"], c["ora"] + c["giorno"] + c["lato"] + c["dati"] + c["tetto"], somma, A["n"], A["ingressi"], A["scartati_spread"]))
        if P["n"] is None:
            ce["CE6"] = (False, "n del report non leggibile%s" % (": " + P["nota_n"] if P.get("nota_n") else ""))
        else:
            d = c["ing"] - P["n"]
            ce["CE6"] = (d in (0, 1), "tentati %d - n %d = %d (ammesso 0 o 1)" % (c["ing"], P["n"], d))
    P["ce"] = ce
    return P


def eccezione_n0(P):
    r, c = P["riga"], P["giornale"]["conta"]
    return (r["stato"] == "KO" and r["motivi"].strip() == "ZERO operazioni nel report" and r["avvio_ok"] == "si" and r["autotest"] == "si"
            and r["finestra"] == TRANCHE[1] + "-" + TRANCHE[2] and P["n"] == 0 and c is not None and c["ing"] == 0 and c["spr"] >= 1)


VARIANTI = {
    # nome: (soglia della (ii), (v) di E4, dicitura di ESCLUSA)
    # Le due VARIANTI sono descrizione (quanto mordono E1 ed E4): E1-E4 sono ADOTTATI, quindi NON portano mai la dicitura di chiusura 'ESCLUSA PER COSTO'
    # (E3: a Modello 1 da solo l'esito si scrive 'ESCLUSA (Modello 1)' e la casella resta aperta). Strato 2 del cancello, 12/10.
    "pinnato": (SOGLIA_II_PINNATA, False, "VARIANTE NON IN VIGORE (solo descrizione, NON un esito, casella 4 NON chiusa): col testo pinnato senza E1-E4 le condizioni varrebbero"),
    "E1": (SOGLIA_II_E1, False, "VARIANTE NON IN VIGORE (solo descrizione, NON un esito, casella 4 NON chiusa): con E1 senza E4 le condizioni varrebbero"),
    "riferimento": (SOGLIA_II_E1, True, "ESCLUSA (Modello 1)"),   # E1 + E4, dicitura di E3
}


def _leggibile(P, ce1):
    """None se la passata si legge (con flag n0), altrimenti la frase dell'esito (C)."""
    r = P["riga"]
    if r["stato"] == "NON_LANCIATA":
        return "NON SI LEGGE: passata non lanciata", False
    if ce1 is not None and not ce1[0]:
        return "NON SI LEGGE: CE1 (ancora) %s" % ce1[1], False
    n0 = False
    if not r["stato"].startswith("OK"):
        if eccezione_n0(P):
            n0 = True
        else:
            return "NON SI LEGGE: passata KO (%s)" % (r["motivi"] or "nessun motivo"), False
    rossi = [k for k in ("CE2", "CE3", "CE4", "CE6") if not P["ce"][k][0]]
    if rossi:
        return "NON SI LEGGE: %s rossi (%s)" % (", ".join(rossi), "; ".join(P["ce"][k][1] for k in rossi)), False
    return None, n0


def esito(P, S, variante, acc_ok, ce1):
    """(lettera, frase, esclusa). Lettera A/B/C. variante: 'pinnato' ((ii) su >= 100 righe, senza (v)), 'E1' ((ii) su >= 30, senza (v)),
    'riferimento' (E1 + E4: (ii) su >= 30 e (v); dicitura di E3 'ESCLUSA (Modello 1)')."""
    soglia_ii, usa_e4, dicitura = VARIANTI[variante]
    no, n0 = _leggibile(P, ce1)
    if no:
        return "C", no, False
    A = P["A"]
    n_porta = P["n"] - A["ingressi_spread_zero"]
    if n_porta >= N_PORTA:
        v = P["solo_spread"]
        if not v or mediana(v) < COSTO_LAVORO:
            return "C", "NON SI LEGGE: n >= 30 ma 'solo spread' sugli ingressi < 40x (non previsto con CE3 verde)", False
        cg = A["c3g"]
        if cg >= COSTO_LAVORO:
            fr = "costo grezzo C3G %s >= 40x" % fx(cg)
        elif cg >= COSTO_DURO:
            fr = "C3G %s: FRA sui segnali grezzi, PASSA solo grazie al filtro" % fx(cg)
        else:
            fr = "C3G %s: SOTTO 13,3x sui segnali grezzi, PASSA solo grazie al filtro" % fx(cg)
        return "A", "PASSA ALLO STADIO B (n %d, al netto di %d ingressi a spread zero = %d; solo spread %.1fx); %s" % (P["n"], A["ingressi_spread_zero"], n_porta, mediana(v), fr), False
    cond = condizioni_b(A, S, soglia_ii, usa_e4)
    nomi = "(i)-(v)" if usa_e4 else "(i)-(iv)"
    esclusa = False
    if cond["tutte"] and acc_ok:
        esclusa = True
        testa = "%s: C3G cella %s < S %s, righe >= 40x %d (< 30: %s)" % (dicitura, fx(A["c3g"]), fx(S), A["ge40"], "SI" if cond["v"] else "no")
    elif cond["tutte"]:
        testa = "n insufficiente a Modello 1 su una tranche (le condizioni %s valgono ma la prova d'accettazione di D2 NON e' passata -> niente ESCLUSA)" % nomi
    else:
        testa = "n insufficiente a Modello 1 su una tranche (NON 'escluso')"
    if n0:
        testa = ("la REPL non apre nessuna operazione su questo (simbolo, TF) in T1: %d segnali, tutti i liberi scartati dal filtro (nessuno con stop/spread >= 50x); "
                 "costo grezzo: C3G %s -> " % (P["giornale"]["conta"]["seg"], fx(A["c3g"]))) + testa
    return "B", "NON PASSA PER n (n %d, al netto di %d ingressi a spread zero = %d < 30): %s | COSTO: %s" % (
        P["n"], A["ingressi_spread_zero"], n_porta, testa, costo_testo(A)), esclusa


def casella4(es_rif, P_m1, P_tick, S, acc_ok):
    """E3 piena. es_rif = esito 'riferimento' a Modello 1. P_tick = passata a TICK REALI della stessa cella e tranche (gia' passata da controlli()) o None."""
    if not es_rif[2]:
        if es_rif[0] == "A":
            return "NON ANCORA MISURATO, casella 4 aperta: la cella va allo stadio B (A)"
        return "NON ANCORA MISURATO, casella 4 aperta: nessuna ESCLUSA (Modello 1) da confermare"
    if P_tick is None:
        return ("NON ANCORA MISURATO: ESCLUSA (Modello 1) da confermare con UNA passata a tick reali della stessa cella e tranche (n netto < 30 e (i)-(v) sul suo "
                "giornale); se la storia a tick reali del simbolo manca, resta NON ANCORA MISURATO e si scrive cosa manca")
    for k in ("simbolo", "tf", "lotto", "cella"):
        if P_tick[k] != P_m1[k]:
            raise Rifiuto("E3: la passata a tick reali ha %s=%s, la cella a Modello 1 %s" % (k, P_tick[k], P_m1[k]))
    rt, rm = P_tick["riga"], P_m1["riga"]
    if (rt["tranche"], rt["da"], rt["a"]) != (rm["tranche"], rm["da"], rm["a"]):
        raise Rifiuto("E3: la passata a tick reali e' su un'altra tranche (%s %s-%s)" % (rt["tranche"], rt["da"], rt["a"]))
    if rt["modello"] != "4":
        raise Rifiuto("E3: la passata di conferma ha modello %s, non 4 (tick reali)" % rt["modello"])
    # Esiti della passata a tick reali IN ORDINE, decide il PRIMO che vale (E3 del documento, quarto giro del cancello)
    # 1) KO per storia a tick mancante (motivi del driver r.786 / r.815, qualita' != 100% ticks reali, ticks_inizio dopo l'inizio della tranche) -> NON ANCORA MISURATO
    st = storia_tick_mancante(P_tick)
    if st:
        return "NON ANCORA MISURATO: storia a tick mancante, la conferma non c'e' (manca: %s)" % "; ".join(st)
    # 2) KO per il SOLO 'ZERO operazioni' sotto l'ECCEZIONE n = 0 (tentati 0, scartati spread >= 1, AVVIO/AUTOTEST/finestra/CONTA a posto): NON e' un KO per E3,
    #    si prosegue con n = 0 (dentro _leggibile); 'ZERO operazioni' con tentati > 0 o segnali(EA) = 0 -> conferma non data (punto 3)
    # 3) qualunque altro KO, CE rosse, o giornale letto da un D2 con SHA256 diverso da quello che ha letto la passata a Modello 1 -> conferma NON data
    if P_tick.get("sha_d2") != P_m1.get("sha_d2"):
        return "NON ANCORA MISURATO: conferma NON data, casella aperta: la passata a tick reali e' stata letta da D2 %s, quella a Modello 1 da D2 %s" % (
            (P_tick.get("sha_d2") or "n.d.")[:12], (P_m1.get("sha_d2") or "n.d.")[:12])
    no, _n0 = _leggibile(P_tick, None)
    if no:
        return "NON ANCORA MISURATO: conferma NON data, casella aperta, si legge il giornale (%s)" % no
    At = P_tick["A"]
    nn = P_tick["n"] - At["ingressi_spread_zero"]
    # 4) n netto >= 30 -> conferma SMENTITA PER n: NON ESCLUSA, resta (B) 'n insufficiente a Modello 1', NESSUN passaggio allo stadio B da E3
    if nn >= N_PORTA:
        return ("NON ANCORA MISURATO: conferma SMENTITA PER n -- la cella NON e' ESCLUSA, l'esito dello stadio A resta (B) 'n insufficiente a Modello 1', "
                "n netto a tick reali %d >= 30; nessun passaggio allo stadio B da E3 (serve un file prova suo che passa dal cancello)" % nn)
    # 5) una delle cinque condizioni rilette sul giornale a tick reali non vale (o accettazione di D2 non passata) -> n insufficiente / da rimisurare
    c = condizioni_b(At, S, SOGLIA_II_E1, True)
    if not (c["tutte"] and acc_ok):
        manca = [k for k in ("i", "ii", "iii", "iv", "v") if not c[k]] or ["accettazione di D2"]
        return "NON ANCORA MISURATO: n insufficiente / da rimisurare (a tick reali %s, n netto %d; non vale: %s)" % (costo_testo(At), nn, ", ".join(manca))
    # 6) conferma
    return "CHIUSA: ESCLUSA PER COSTO (Modello 1 e tick reali) col numero: C3G Modello 1 %s, tick reali %s < S %s, n netto a tick reali %d, righe >= 40x %d" % (
        fx(P_m1["A"]["c3g"]), fx(At["c3g"]), fx(S), nn, At["ge40"])


def storia_tick_mancante(P):
    """Lista di cosa manca della storia a tick (vuota = presente). Fonti: motivi del driver v5 (r.786 'ticks data begins from ... DOPO l inizio della tranche',
    r.815 'qualita dello storico ... invece di 100% ticks reali'), colonne 'qualita' e 'ticks_inizio' del manifest."""
    r = P["riga"]
    out = []
    for m in (r.get("motivi") or "").split(" | "):
        if m.startswith("qualita dello storico") or (m.startswith("ticks data begins from") and "DOPO l inizio della tranche" in m):
            out.append(m.strip())
    q = re.sub(r"\s", "", r.get("qualita") or "").lower()
    if r["stato"] != "NON_LANCIATA" and q and not (q.startswith("100%") and "tick" in q):
        out.append("qualita' dello storico '%s' invece di '100%% ticks reali'" % r.get("qualita"))
    for tk in (r.get("ticks_inizio") or "").split(" / "):
        pz = tk.strip().split(" ")
        if len(pz) == 2 and pz[0] == P["simbolo"] and pz[1] > r["da"]:
            out.append("tick reali di %s solo dal %s, dopo l'inizio della tranche %s" % (pz[0], pz[1], r["da"]))
    return out


def costo_testo(A):
    """Il numero del costo accanto a ogni esito (B): C3G della cella, dei lati e delle fasce col loro n, righe >= 40x e >= 50x."""
    return "C3G cella %s (n %d), BUY %s (n %d), SELL %s (n %d); fasce %s; righe >= 40x %d, >= 50x %d" % (
        fx(A["c3g"]), A["n"], fx(A["lati"]["BUY"]["c3g"]), A["lati"]["BUY"]["n"], fx(A["lati"]["SELL"]["c3g"]), A["lati"]["SELL"]["n"],
        " / ".join("%s %s (n %d)" % (f["nome"], fx(f["c3g"]), f["n"]) for f in A["fasce"]), A["ge40"], A["ge50"])


# ---------------------------------------------------------------------------------------------------------------------
#  STAMPA
# ---------------------------------------------------------------------------------------------------------------------
def stato_ce1(lotti):
    if "R2SANC" not in lotti:
        return (False, "NON LETTO: lo zip dell'ancora GBA_R0_R2SANC.zip non e' caricato")
    P = lotti["R2SANC"]["passate"][0] if lotti["R2SANC"]["passate"] else None
    if P is None or P["stato"] == "NON_LANCIATA" or P["giornale"] is None:
        return (False, "ROSSO: passata dell'ancora non lanciata")
    r = P["riga"]
    err = []
    if not r["stato"].startswith("OK"):
        err.append("stato %s" % r["stato"])
    if (r["trades_report"], r["profitto_report"], r["pf_report"]) != (str(ATTESA_S0["trades"]), ATTESA_S0["profitto"], ATTESA_S0["pf"]):
        err.append("manifest %s / %s / %s invece di 158 / -6364.79 / 0.86" % (r["trades_report"], r["profitto_report"], r["pf_report"]))
    err += confronta_ancora(P["A"], P["giornale"], ATTESA_S0)
    c = P["giornale"]["conta"]
    if c is None or (c["seg"], c["ing"], c["spr"], c["pos"]) != ATTESA_S0["conta"]:
        err.append("conteggi EA %s invece di 6973 / 158 / 6520 / 295" % (str((c["seg"], c["ing"], c["spr"], c["pos"])) if c else "n.d."))
    v = P["solo_spread"]
    if not v or "%.1f" % mediana(v) != ATTESA_S0["solo_spread_1d"]:
        err.append("solo spread %s invece di 55.9" % ("n.d." if not v else "%.1f" % mediana(v)))
    if err:
        return (False, "ROSSO: l'ancora NON rifa' S0_01 (" + "; ".join(err) + ")")
    return (True, "VERDE (parte D2: manifest 158/-6364.79/0.86, conteggi EA, C3G cella/fasce/lati asia, solo spread 55.9 identici a S0_01; l'A3 doppione la verifica il lettore)")


# ---------------------------------------------------------------------------------------------------------------------
#  LOTTO R2SXAG2 (rilancio dell'argento): CE7, X6, CE8 del file prova GBA_R2S_XAGUSD2_2026-10-12.txt
# ---------------------------------------------------------------------------------------------------------------------
def _passata(lotti, L, cella):
    if L not in lotti:
        return None
    for P in lotti[L]["passate"]:
        if P["cella"] == cella:
            return P
    return None


def stato_ce7(lotti, acc_ok):
    """CE7 DETERMINISMO DELLA REPL: ('VERDE' | 'ROSSA' | 'NON VALUTABILE', testo). Tolleranza ZERO sulle cifre STAMPATE da D2 (stringhe '%.2f' e interi)."""
    P = _passata(lotti, "R2SXAG2", "REPL")
    if P is None or P["stato"] == "NON_LANCIATA" or P["giornale"] is None:
        return ("NON VALUTABILE", "la REPL R2SXAG2_02 non e' lanciata (o assente dal manifest): niente giornale da confrontare")
    G = P["giornale"]
    if G["conta"] is None or G["conta_n"] != 1:
        return ("NON VALUTABILE", "il giornale della REPL non ha UNA riga [GBA-CONTA] FINE (%d)" % G["conta_n"])
    if not acc_ok:
        return ("NON VALUTABILE", "la prova d'accettazione di D2 NON e' passata: lo strumento non e' quello accettato")
    A = P["A"] if "A" in P else analizza(G["righe"])
    att = CE7_ATTESA
    diff = []

    def cmp(nome, letto, atteso):
        if letto != atteso:
            diff.append("%s %s invece di %s" % (nome, letto, atteso))
    cmp("righe segnale", A["n"], att["righe"])
    for k, nome in (("seg", "EA segnali"), ("ing", "ingressi tentati"), ("spr", "scartati spread"), ("pos", "posizione aperta"), ("dati", "ATR non valido")):
        cmp(nome, G["conta"][k], att["conta"][k])
    cmp("C3G cella", fx(A["c3g"]), att["cella"])
    for lato in ("BUY", "SELL"):
        cmp("C3G " + lato, fx(A["lati"][lato]["c3g"]), att[lato][0])
        cmp("n " + lato, A["lati"][lato]["n"], att[lato][1])
    for f, (nome, n_att, c_att) in zip(A["fasce"], att["fasce"]):
        cmp("righe " + nome, f["n"], n_att)
        cmp("C3G " + nome, fx(f["c3g"]), c_att)
    if diff:
        return ("ROSSA", "la REPL NON rifa' il giornale del 12/10 (" + "; ".join(diff) + "): la REPL di questo lotto e' (C), senza appello, e il giornale del "
                "12/10 NON si usa al suo posto")
    return ("VERDE", "la REPL rifa' il giornale del 12/10 a tolleranza zero (6611 righe; EA 6611/0/6611/0/0; C3G cella 2.40, BUY 2.50 n 3364, SELL 2.30 n 3247; "
            "fasce 2149 2.10 / 1458 2.40 / 680 2.80 / 802 4.20 / 1251 2.10 / 271 1.40): l'esito si legge sul giornale NUOVO")


def stato_ce1_x6(lotti, ce1_anc, ce7):
    """X6: CE1 del lotto R2SXAG2 VERDE solo se l'ancora del 12/10 e' verde (e lo zip e' quello del 12/10) E CE7 e' VERDE."""
    err = []
    if not ce1_anc[0]:
        err.append("ancora del 12/10 NON verde (" + ce1_anc[1] + ")")
    elif lotti["R2SANC"].get("sha_zip") != SHA_ANCORA_1210:
        err.append("lo zip dell'ancora NON e' GBA_R0_R2SANC.zip del 12/10 (SHA256 %s, quello archiviato in GBA_R2S_A.zip e' %s)" % (
            (lotti["R2SANC"].get("sha_zip") or "n.d.")[:12], SHA_ANCORA_1210[:12]))
    if ce7[0] != "VERDE":
        err.append("CE7 " + ce7[0])
    if err:
        return (False, "NON VERDE -> TUTTE E DUE le celle del lotto R2SXAG2 (M15 e REPL) sono (C), senza appello: " + "; ".join(err))
    return (True, "VERDE (ancora del 12/10 verde, zip archiviato SHA256 %s..., E CE7 verde)" % SHA_ANCORA_1210[:12])


RE_TESTER = re.compile(r"^# TESTER \S+\t[^\t]*\t(?P<ora>\d\d):(?P<mi>\d\d):(?P<se>\d\d(?:\.\d+)?)\t[^\t]*\t(?P<msg>.*)$")


def ce8_passata(P):
    """CE8 (DESCRIZIONE, nessun esito ne dipende): t_avvio, ora di 'Test passed' / 'total time' rispetto a t_avvio, riga 'last test passed', durata, n.
    Ore: t_avvio del MANIFEST e righe del tester raccolte dal driver sono tutte e due ore del PC. Restituisce un dict."""
    r = P["riga"]
    d = {"lanciata": P["stato"] != "NON_LANCIATA" and P["giornale"] is not None, "t_avvio": (r.get("t_avvio") or "").strip(), "durata": (r.get("durata_s") or "").strip(),
         "n": (r.get("trades_report") or "").strip(), "report": P["report"] is not None or (r.get("trades_report") or "").strip().isdigit(),
         "test_s": None, "last_s": None, "last": False, "balance": None, "tentati": None, "classe": "non lanciata"}
    if not d["lanciata"]:
        return d
    G = P["giornale"]
    d["tentati"] = G["conta"]["ing"] if G["conta"] else None
    m0 = re.search(r"(\d\d):(\d\d):(\d\d)$", d["t_avvio"])
    t0 = int(m0.group(1)) * 3600 + int(m0.group(2)) * 60 + int(m0.group(3)) if m0 else None

    def rel(m):
        if t0 is None:
            return None
        s = int(m.group("ora")) * 3600 + int(m.group("mi")) * 60 + float(m.group("se")) - t0
        return s + 86400 if s < 0 else s
    for riga in G["tester"]:
        m = RE_TESTER.match(riga)
        if not m:
            continue
        msg = m.group("msg")
        if msg.startswith("last test passed with result"):
            d["last"] = True
            s = rel(m)
            d["last_s"] = s if d["last_s"] is None or (s is not None and s < d["last_s"]) else d["last_s"]
        elif "Test passed in" in msg or "total time from login to stop testing" in msg:
            s = rel(m)
            if s is not None and (d["test_s"] is None or s < d["test_s"]):
                d["test_s"] = s
        mb = re.search(r"final balance ([0-9.]+)", msg)
        if mb:
            d["balance"] = mb.group(1)
    if d["report"]:
        d["classe"] = "report scritto"
    elif d["test_s"] is None:
        d["classe"] = "nessuna riga di fine test nel giornale: non classificata"
    elif d["test_s"] > CE8_ENTRO_S:
        d["classe"] = "test finito TARDI (+%d s dall'avvio): causa a monte del test (storia, sincronizzazione), non lo stallo del 12/10" % int(d["test_s"])
    elif not d["last"]:
        d["classe"] = "BLOCCATA DOPO IL TEST (test finito a +%d s, nessuna riga 'last test passed', report non scritto)" % int(d["test_s"])
    else:
        d["classe"] = "report non scritto con la riga 'last test passed' presente: firma DIVERSA dallo stallo del 12/10"
    return d


def ce8_testo(d):
    if not d["lanciata"]:
        return "passata non lanciata: nessun dato"
    return "t_avvio %s | fine del test ('Test passed' / 'total time') %s | 'last test passed' %s | durata %s s | n del report %s | final balance %s | tentati (EA) %s -> %s" % (
        d["t_avvio"] or "n.d.", "n.d." if d["test_s"] is None else "+%d s" % int(d["test_s"]),
        ("SI (+%d s)" % int(d["last_s"]) if d["last_s"] is not None else "SI") if d["last"] else "ASSENTE", d["durata"] or "n.d.", d["n"] or "n.d.",
        d["balance"] or "n.d.", "n.d." if d["tentati"] is None else d["tentati"], d["classe"])


def ce8_lettura(lotti):
    """La lettura del CE8 scritta nel file prova PRIMA dei numeri (r.79-92), applicata alla lettera. DESCRIZIONE: nessun esito ne dipende."""
    PR, PM = _passata(lotti, "R2SXAG2", "REPL"), _passata(lotti, "R2SXAG2", "M15")
    dr = ce8_passata(PR) if PR else None
    dm = ce8_passata(PM) if PM else None
    out = []

    def bloccata(d):
        return d is not None and d["classe"].startswith("BLOCCATA DOPO IL TEST")
    if dr and dr["lanciata"]:
        if dr["report"] and dr["n"] == "0" and PR["riga"]["motivi"].strip() == "ZERO operazioni nel report":
            out.append("REPL con n = 0 e report scritto (KO per il SOLO 'ZERO operazioni nel report') -> H-ZERO-R SMENTITA: lo stallo del 12/10 non dipendeva dalle zero "
                       "operazioni col report; resta lo stallo occasionale (F5)")
        elif bloccata(dr):
            out.append("REPL di nuovo senza report, test finito entro ~1 minuto, nessuna 'last test passed' -> stallo RIPRODOTTO 2 volte su 2 sulla stessa passata: causa "
                       "legata alla passata (H-ZERO-R o altro della REPL argento M1, NON si sa quale); NON si rilancia una terza volta con un timeout piu' lungo: si porta "
                       "a Claudio (decisione aperta 1 della scheda)")
        elif dr["classe"].startswith("test finito TARDI"):
            out.append("REPL: test finito TARDI -> la causa e' a monte del test (storia, sincronizzazione), non lo stallo del 12/10")
    if dm and dm["lanciata"]:
        if dm["report"]:
            if dm["n"].isdigit() and int(dm["n"]) >= 1 and bloccata(dr):
                out.append("M15 con n >= 1 e report scritto, REPL bloccata -> coerente con H-ZERO-R (NON la prova)")
            elif dm["n"] == "0":
                out.append("M15 con n = 0 e report scritto -> H-ZERO-R SMENTITA")
        elif bloccata(dm):
            if dm["tentati"] == 0 and dm["balance"] == DEPOSITO:
                out.append("M15 con n = 0 e bloccata (final balance = deposito, [GBA-CONTA] FINE con ingressi tentati 0) -> coerente con H-ZERO-R (NON la prova)")
            elif dm["tentati"] is not None and dm["tentati"] >= 1:
                out.append("M15 con ingressi tentati %d (>= 1) e bloccata -> H-ZERO-R SMENTITA (lo stallo non e' legato alle zero operazioni): resta lo stallo "
                           "occasionale" % dm["tentati"])
        elif dm["classe"].startswith("test finito TARDI"):
            out.append("M15: test finito TARDI -> la causa e' a monte del test (storia, sincronizzazione), non lo stallo del 12/10")
    if not out:
        out.append("nessuno dei casi scritti nel file prova (CE8) si applica: niente da leggere sulla causa")
    return out


def stampa(lotti, note, acc_ok, acc_righe, csv_out=None):
    out = []
    W = out.append
    righe_csv = []
    xag2 = "R2SXAG2" in lotti
    giro = GIRO_XAG2 if xag2 else GIRO_A
    W("=" * 110)
    W(" %s -- GBA R2S stadio A, C3G (mediana vera del campo stop/spread delle righe segnale). SHA256 di questo file: %s" % (
        VERSIONE, hashlib.sha256(open(os.path.abspath(__file__), "rb").read()).hexdigest()[:16]))
    W(" Regole: righe -1.0x = INFINITO (contate, non scartate); mediana con n PARI = media delle due centrali (INF se una delle due e' INF); fasce = lettore r.52, campo 'ora server'.")
    W(" Precondizione FUORI da D2: il G0 del lettore leggi_gba_r0.py (sezione (1)) per ogni passata; l'A3 dell'ancora (doppione con GBA_R0_S0.zip).")
    if xag2:
        W(" LOTTO R2SXAG2 (rilancio dell'argento, pin %s): SHA256 di D2 PER INTERO: %s" % (PIN_XAG2, sha_d2()))
        W(" REGOLA E3(3): una conferma a tick reali letta con uno strumento D2 di SHA256 DIVERSO da quello qui sopra (che legge la passata a Modello 1) e' 'conferma non")
        W("   data' (casella 4 aperta). Precondizione FUORI da D2: il PASS del cancello su QUESTO SHA256 PRIMA di aprire lo zip (senza: CE7 non valutabile, tutto (C)).")
        W(" X6: CE1 del lotto = ancora del 12/10 (zip archiviato, pin %s) E CE7; CE7 rossa o non valutabile -> M15 e REPL (C). CE8 = sola descrizione." % PIN_A[:8])
    W("=" * 110)
    W("(0) PROVA D'ACCETTAZIONE di D2 (giornali archiviati, rifatta adesso): %s" % ("PASSATA" if acc_ok else "NON PASSATA -> nessuna cella esce 'ESCLUSA'"))
    for x in acc_righe:
        W(x)
    for x in note:
        W("   nota: " + x)
    for L in ORDINE:
        if L not in lotti:
            continue
        for P in lotti[L]["passate"]:
            if P["giornale"] is not None:
                controlli(P)
    ce1 = stato_ce1(lotti)
    W("   CE1 ancora: " + ce1[1])
    ce1_lotto = {}
    if xag2:
        # X6 e CE7 PRIMA di qualunque esito: l'esito della M15 (prima nel manifest) dipende dal CE7 della REPL (seconda)
        ce7 = stato_ce7(lotti, acc_ok)
        ce1_lotto["R2SXAG2"] = stato_ce1_x6(lotti, ce1, ce7)
        W("   CE7 (determinismo della REPL, tolleranza zero sulle cifre stampate): %s: %s" % (ce7[0], ce7[1]))
        W("   CE1 del lotto R2SXAG2 (X6): " + ce1_lotto["R2SXAG2"][1])
        W("   CE8 (causa dello stallo, DESCRIZIONE, nessun esito ne dipende; lettura scritta nel file prova prima dei numeri):")
        for x in ce8_lettura(lotti):
            W("      - " + x)
    for L in ORDINE:
        if L not in giro:
            continue
        if L not in lotti:
            W("")
            W("-" * 110)
            W(" LOTTO %s: NON CARICATO (zip assente o compilazione fallita) -> nessun esito" % L)
            continue
        D = LOTTI[L]
        mancanti = [c for c, _tf in D["celle"] if c not in [P["cella"] for P in lotti[L]["passate"]]]
        if mancanti:
            W("")
            W(" LOTTO %s: celle dichiarate nel file prova ASSENTI dal manifest: %s -> per quelle nessun esito (C)" % (L, ", ".join(mancanti)))
        for P in lotti[L]["passate"]:
            W("")
            W("-" * 110)
            W(" LOTTO %s  CELLA %s = %s %s  (passata %s, stato driver %s%s)%s" % (L, P["cella"], P["simbolo"], P["tf"], P["tag"], P["stato"],
                                                                         "" if not P["riga"]["motivi"] else ": " + P["riga"]["motivi"], "  [ANCORA]" if L == "R2SANC" else ""))
            W("-" * 110)
            if L == "R2SXAG2":
                W("   CE8 (descrizione): " + ce8_testo(ce8_passata(P)))
            if P["giornale"] is None:
                W("   passata non lanciata: niente da leggere -> esito (C)")
                righe_csv.append({"lotto": L, "cella": P["cella"], "simbolo": P["simbolo"], "tf": P["tf"], "livello": "CELLA", "nome": "-", "esito_pinnato": "C", "esito_E1": "C",
                                  "esito_riferimento": "C", "casella4_E3": "NON ANCORA MISURATO: passata non lanciata"})
                continue
            A, G, c = P["A"], P["giornale"], P["giornale"]["conta"]
            W("   righe segnale (segnali grezzi) %d | ingressi del giornale (senza SALTATO) %d, di cui a SPREAD ZERO (-1.0x) %d | righe -1.0x in tutto %d | righe d'ingresso eseguite %d" % (
                A["n"], A["ingressi"], A["ingressi_spread_zero"], A["righe_spread_zero"], len(G["ingressi_eseguiti"])))
            W("   n del report %s | EA: segnali %s, ingressi tentati %s, scartati spread %s, posizione aperta %s, ATR non valido %s | quota dei liberi scartata per spread %s" % (
                "n.d." if P["n"] is None else P["n"], *(("n.d.",) * 5 if c is None else (c["seg"], c["ing"], c["spr"], c["pos"], c["dati"])),
                "n.d." if not A["liberi"] else "%.1f%% (%d su %d)" % (100.0 * A["scartati_spread"] / A["liberi"], A["scartati_spread"], A["liberi"])))
            W("   motivi delle righe: %s | lotti degli ingressi: %s%s" % (", ".join("%s %d" % (k, v) for k, v in sorted(A["motivi"].items())),
                                                                        ", ".join(sorted(set("%.2f" % e["lotti"] for e in G["ingressi_eseguiti"]))) or "-",
                                                                        " | ATTENZIONE: %d righe 'lotto ridotto' (CE5)" % G["ridotti"] if G["ridotti"] else ""))
            W("   C3G CELLA %s (n %d)   BUY %s (n %d)   SELL %s (n %d)   righe >= 40x %d (la (v) di E4)   righe >= 50x %d   spread della cella (mediana del campo spread) %s" % (
                fx(A["c3g"]), A["n"], fx(A["lati"]["BUY"]["c3g"]), A["lati"]["BUY"]["n"], fx(A["lati"]["SELL"]["c3g"]), A["lati"]["SELL"]["n"], A["ge40"], A["ge50"],
                fx(A["spread_cella"], 3)))
            if c is not None and c["dati"]:
                W("   nota: %d righe 'ATR non valido' (campo 0,0x: entrano nel C3G col loro valore e NON contano nella (v); a spread zero -1,0x = INFINITO)" % c["dati"])
            W("   %-15s %-5s %6s %8s %8s %6s %8s %6s %7s %7s %9s %8s %8s" % ("fascia", "ore", "righe", "C3G", "BUY", "n", "SELL", "n", ">=40x", ">=50x", "ingressi", "quota", "spread"))
            for f in A["fasce"]:
                W("   %-15s %02d-%02d %6d %8s %8s %6d %8s %6d %7d %7d %9d %8s %8s" % (f["nome"], f["lo"], f["hi"], f["n"], fx(f["c3g"]), fx(f["BUY"]["c3g"]), f["BUY"]["n"],
                                                                         fx(f["SELL"]["c3g"]), f["SELL"]["n"], f["ge40"], f["ge50"], f["ingressi"],
                                                                         "n.d." if f["quota_ingressi"] is None else "%.1f%%" % (100 * f["quota_ingressi"]), fx(f["spread_med"])))
                righe_csv.append({"lotto": L, "cella": P["cella"], "simbolo": P["simbolo"], "tf": P["tf"], "livello": "FASCIA", "nome": f["nome"], "righe": f["n"], "c3g": fx(f["c3g"]),
                                  "buy_n": f["BUY"]["n"], "buy_c3g": fx(f["BUY"]["c3g"]), "sell_n": f["SELL"]["n"], "sell_c3g": fx(f["SELL"]["c3g"]), "ge40": f["ge40"],
                                  "ge50": f["ge50"], "ingressi": f["ingressi"], "quota_ingressi": "" if f["quota_ingressi"] is None else "%.4f" % f["quota_ingressi"]})
            for k in ("CE2", "CE3", "CE4", "CE6"):
                W("   %s %s: %s" % (k, "verde" if P["ce"][k][0] else "ROSSO", P["ce"][k][1]))
            rc = {"lotto": L, "cella": P["cella"], "simbolo": P["simbolo"], "tf": P["tf"], "livello": "CELLA", "nome": "-", "righe": A["n"], "c3g": fx(A["c3g"]),
                  "buy_n": A["lati"]["BUY"]["n"], "buy_c3g": fx(A["lati"]["BUY"]["c3g"]), "sell_n": A["lati"]["SELL"]["n"], "sell_c3g": fx(A["lati"]["SELL"]["c3g"]),
                  "ge40": A["ge40"], "ge50": A["ge50"], "ingressi": A["ingressi"], "ingressi_spread_zero": A["ingressi_spread_zero"], "righe_spread_zero": A["righe_spread_zero"],
                  "n_report": "" if P["n"] is None else P["n"], "tentati": "" if c is None else c["ing"], "scartati_spread": "" if c is None else c["spr"],
                  "solo_spread_mediana": "" if not P["solo_spread"] else "%.2f" % mediana(P["solo_spread"]), "spread_cella": fx(A["spread_cella"], 3)}
            if L == "R2SANC":
                W("   ANCORA: nessun esito; vedi CE1 in testa.")
                righe_csv.append(rc)
                continue
            S = D["S"]
            if P["n"] is not None:
                np_ = P["n"] - A["ingressi_spread_zero"]
                W("   PORTA STADIO B: n %d - ingressi a spread zero %d = %d %s 30" % (P["n"], A["ingressi_spread_zero"], np_, ">=" if np_ >= N_PORTA else "<"))
            W("   eccezione n = 0 (KO solo per ZERO operazioni, tentati 0, scartati spread >= 1): %s" % ("SI" if (not P["riga"]["stato"].startswith("OK") and P["n"] is not None and eccezione_n0(P)) else "no"))
            for nome_s, soglia in (("testo pinnato", SOGLIA_II_PINNATA), ("con E1", SOGLIA_II_E1)):
                cd = condizioni_b(A, S, soglia)
                W("   condizioni di ESCLUSA, S = %sx, %s ((ii) su fasce >= %d righe: %s): (i) %s  (ii) %s  (iii) %s  (iv) %s  | (v) E4 righe >= 40x %d < 30: %s" % (
                    fx(S), nome_s, soglia, ", ".join(cd["fasce_ii"]) or "nessuna", *(["SI" if cd[k] else "no" for k in ("i", "ii", "iii", "iv")] + [A["ge40"], "SI" if cd["v"] else "no"])))
            ce1_p = ce1_lotto.get(L, ce1)          # R2SXAG2: X6 (ancora del 12/10 E CE7); gli altri lotti: CE1 dell'ancora come nella v2
            e_p = esito(P, S, "pinnato", acc_ok, ce1_p)
            e_1 = esito(P, S, "E1", acc_ok, ce1_p)
            e_r = esito(P, S, "riferimento", acc_ok, ce1_p)
            c4 = casella4(e_r, P, None, S, acc_ok)
            W("   (variante) ESITO secondo il testo pinnato, (i)-(iv), (ii) >= 100: (%s) %s" % (e_p[0], e_p[1]))
            W("   (variante) ESITO con E1, (i)-(iv), (ii) >= 30:                  (%s) %s" % (e_1[0], e_1[1]))
            W("   ESITO DI RIFERIMENTO (E1 + E4, (i)-(v), dicitura E3):          (%s) %s" % (e_r[0], e_r[1]))
            W("   CASELLA 4 (E3): %s" % c4)
            rc.update({"esito_pinnato": e_p[0] + " " + e_p[1], "esito_E1": e_1[0] + " " + e_1[1], "esito_riferimento": e_r[0] + " " + e_r[1], "casella4_E3": c4})
            if L == "R2SXAG2":
                rc.update({"ce1_x6": ("VERDE " if ce1_p[0] else "NON VERDE ") + ce1_p[1], "ce8": ce8_testo(ce8_passata(P))})
            righe_csv.append(rc)
    W("")
    W(" NON giudica il merito, NON promuove, NON legge PF. Ogni esito vale solo con il G0 del lettore OK sulla stessa passata.")
    testo = "\n".join(out)
    if csv_out:
        campi = ["lotto", "cella", "simbolo", "tf", "livello", "nome", "righe", "c3g", "buy_n", "buy_c3g", "sell_n", "sell_c3g", "ge40", "ge50", "ingressi", "quota_ingressi",
                 "ingressi_spread_zero", "righe_spread_zero", "n_report", "tentati", "scartati_spread", "solo_spread_mediana", "spread_cella", "esito_pinnato", "esito_E1",
                 "esito_riferimento", "casella4_E3"]
        if xag2:
            campi += ["ce1_x6", "ce8"]           # solo nella lettura del rilancio: il CSV dello stadio A resta quello della v2
        with open(csv_out, "w", newline="", encoding="ascii", errors="replace") as fh:
            w = csv.DictWriter(fh, fieldnames=campi, delimiter=";")
            w.writeheader()
            for rr in righe_csv:
                w.writerow(rr)
    return testo


# ---------------------------------------------------------------------------------------------------------------------
#  AUTOTEST
# ---------------------------------------------------------------------------------------------------------------------
def _riga_seg(i, lato, preso, motivo, rap, ora, atr=1.0, spread=0.10):
    g = 1 + i // (24 * 60)
    mi = i % 60
    st = "2026.07.%02d %02d:%02d:%02d" % (min(g, 28), ora, mi, (i // 60) % 60)
    sal = "" if preso else " SALTATO (%s)" % motivo
    rs = "%.4f" % rap if rap != -1.0 else "-1.0"
    return "%s   [GBA] segnale %s%s | close 100.00 canale 90.00-99.00 EMA 95.00 ATR %.2f spread %.2f = 1.0%% ATR (max 5.0%%) | stop/spread %sx | ora server %d" % (
        st, lato, sal, atr, spread, rs, ora)


def _log(simbolo, tf, righe, conta=None, avvio_sim=None, fin_sim=None, ingressi=None):
    """righe = [(lato, preso, motivo, rap, ora)]. conta=None -> coerente coi motivi."""
    L = ["# passata finta", "# FINESTRA %s|%s|2026.07.01|00:00|2026.09.30|00:00" % (fin_sim or simbolo, tf),
         '2026.07.01 00:00:00   [GBA] AVVIO v1.10 | InpSymbol="%s" -> simbolo %s | InpSignalTF=PERIOD_%s -> PERIOD_%s | InpTrendTF=PERIOD_CURRENT -> PERIOD_%s' % (
             avvio_sim or simbolo, avvio_sim or simbolo, tf, tf, tf)]
    for i, (lato, preso, motivo, rap, ora) in enumerate(righe):
        L.append(_riga_seg(i, lato, preso, motivo, rap, ora, spread=0.0 if rap == -1.0 else 0.10))
    ning = sum(1 for x in righe if x[1]) if ingressi is None else ingressi
    for k in range(ning):
        L.append("2026.08.%02d 10:%02d:00   [GBA] BUY 1.00 lotti @ 100.00 | SL 97.50 (2.50 x ATR 1.00) | spread 0.02 | perdita a SL ~250.00 EUR" % (1 + k // 60, k % 60))
    if conta is None:
        conta = {"seg": len(righe), "ing": sum(1 for x in righe if x[1]), "spr": sum(1 for x in righe if not x[1] and x[2].startswith("spread")),
                 "pos": sum(1 for x in righe if not x[1] and x[2].startswith("posizione"))}
    L.append("2026.09.29 23:59:59   [GBA-CONTA] FINE | segnali %d | ingressi tentati %d | scartati: SPREAD %d (spread max 0.05 x ATR) | posizione aperta %d | ora 0 | "
             "perdita giornaliera 0 | lato spento 0 | ATR non valido %d | tetto giornaliero 0 (max 0)" % (conta["seg"], conta["ing"], conta["spr"], conta["pos"], conta.get("dati", 0)))
    return "\r\n".join(L)


def _report(simbolo, tf, trades):
    t = ("<html><body><table><tr><td>Simbolo:</td><td>%s</td></tr><tr><td>Periodo:</td><td>%s (2026.07.01 - 2026.09.30)</td></tr>"
         "<tr><td>Numero di Operazioni di Trading Totali:</td><td>%d</td></tr></table></body></html>") % (simbolo, tf, trades)
    return b"\xff\xfe" + t.encode("utf-16-le")


def _zip_lotto(L, celle, prova_bytes=None, togli=(), ini_mod=None, nome_prova=None, rep_sim=None, riepilogo=None):
    """celle = {nome_cella: dict(righe=..., n=..., stato='OK', motivi='', conta=None, avvio_sim=None, fin_sim=None, log=None, ingressi=None)}"""
    D = LOTTI[L]
    b = io.BytesIO()
    z = zipfile.ZipFile(b, "w")
    pr = prova_bytes if prova_bytes is not None else open(os.path.join(QD, "prove", D["prova"]), "rb").read()
    z.writestr(nome_prova or D["prova"], pr)
    pin = pin_della_prova(pr.decode("ascii", "replace"))
    man = ["lotto;passata;cella;spread_max_atr;tranche;da;a;modello;magic;t_avvio;durata_s;stato;trades_report;profitto_report;pf_report;qualita;barre_report;ticks_report;"
           "barre_gen;ticks_gen;ticks_inizio;righe_gba;ingressi_log;avvio_ok;autotest;finestra;motivi;asse;valore_asse;simbolo;periodo;prova"]
    tfm = dict(D["celle"])
    for k, (cn, spec) in enumerate(celle.items()):
        tf = spec.get("tf", tfm.get(cn, "M5"))
        tag = "%s_%02d_%s_T1_m775800" % (L, k + 1, cn)
        man.append("%s;%s;%s;0.05;T1;2026.07.01;2026.09.30;1;775800;%s;%s;%s;%s;%s;%s;%s;1;1;1;1;%s;1;%s;si;si;2026.07.01-2026.09.30;%s;InpSignalTF;%s;%s;%s;%s" % (
            L, tag, cn, spec.get("t_avvio", "2026-10-12 10:00:00"), spec.get("durata", "30"), spec.get("stato", "OK"), spec["n"], spec.get("profitto", "-1.00"), spec.get("pf", "0.90"), spec.get("qualita", "100%"), spec.get("ticks_inizio", ""),
            spec["n"], spec.get("motivi", ""),
            spec.get("valore", TF_NUM.get(tf, "5")), spec.get("simbolo", D["simbolo"]), tf, D["prova"]))
        if "ini" not in togli:
            inp = dict(pin)
            inp["InpSignalTF"] = TF_NUM.get(tf, "5")
            inp["InpMagic"] = "775800"
            te = {"Expert": "ABTG_GoldBreakoutATR.ex5", "Symbol": D["simbolo"], "Period": tf, "Model": "1", "FromDate": "2026.07.01", "ToDate": "2026.09.30"}
            if ini_mod:
                ini_mod(te, inp)
            z.writestr("ini\\gba_%s.ini" % tag, "[Tester]\r\n" + "".join("%s=%s\r\n" % kv for kv in te.items()) + "\r\n[TesterInputs]\r\n" + "".join("%s=%s\r\n" % kv for kv in inp.items()))
        if "log" not in togli:
            lg = spec.get("log") or _log(D["simbolo"], tf, spec["righe"], spec.get("conta"), spec.get("avvio_sim"), spec.get("fin_sim"), spec.get("ingressi"))
            z.writestr("log\\GBA_%s.txt" % tag, lg)
        if not spec.get("senza_report"):
            z.writestr("report\\GBA_R0_%s.htm" % tag, spec.get("report") or _report(rep_sim or D["simbolo"], tf, spec["n"]))
    z.writestr("MANIFEST_R0.csv", "\r\n".join(man))
    if "riepilogo" not in togli:
        z.writestr("RIEPILOGO_R0.txt", riepilogo if riepilogo is not None else _riepilogo(L))
    z.close()
    return b.getvalue()


def _riepilogo(L, pin=None, sha_ea=None):
    """Testa del RIEPILOGO_R0.txt come la scrive il driver v5 (r.875-878)."""
    return ("GBA R0 -- lotto %s: ABTG_GoldBreakoutATR v1.10\r\ndata: 2026-10-12 10:00:00   pc: DESKTOP-H4D7CAJ   pin: %s\r\n"
            "ABTG_GoldBreakoutATR.mq5 SHA256 %s   compilazione: 0 errori, 0 avvisi (-1 = non letto)\r\n") % (L, pin or LOTTI[L]["pin"], sha_ea or SHA_EA)


def autotest():
    ok_tot = [0, 0]

    def ck(nome, cond, extra=""):
        ok_tot[0 if cond else 1] += 1
        print("  [%s] %s%s" % ("OK " if cond else "FAIL", nome, ("   (" + extra + ")") if extra else ""))

    def rifiuta(nome, fn):
        try:
            fn()
            ck(nome, False, "NON rifiutato")
        except Rifiuto as ex:
            ck(nome, True, str(ex)[:150])

    print("AUTOTEST %s" % VERSIONE)
    # --- 0. definizioni copiate == quelle del lettore (SHA pinnato), parse riga per riga identico
    import importlib.util
    lp = os.path.join(QD, "leggi_gba_r0.py")
    sha_l = hashlib.sha256(open(lp, "rb").read()).hexdigest()
    ck("lettore leggi_gba_r0.py con lo SHA256 pinnato (9CD02D2A...)", sha_l == LETTORE_SHA256, sha_l[:12])
    spec = importlib.util.spec_from_file_location("leggi_gba_r0_d2", lp)
    lg = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(lg)
    ck("FASCE identiche al lettore (r.52)", lg.FASCE == FASCE)
    ck("RE_SEG identica al lettore (r.242)", lg.RE_SEG.pattern == RE_SEG.pattern)
    ck("RE_ING identica al lettore (r.244)", lg.RE_ING.pattern == RE_ING.pattern)
    # --- 1. statistica
    ck("mediana dispari [3,1,2] = 2", mediana([3, 1, 2]) == 2)
    ck("mediana PARI [1,2,3,4] = 2,5 (media delle due centrali)", mediana([1, 2, 3, 4]) == 2.5)
    ck("mediana pari con una centrale INF = INF", mediana([1, 2, INF, INF]) == INF)
    ck("mediana pari [1, INF] = INF", mediana([1, INF]) == INF)
    # --- 2. ACCETTAZIONE sui dati veri
    acc_ok, acc_r = accettazione()
    for x in acc_r:
        print("     " + x.strip())
    ck("PROVA D'ACCETTAZIONE (S0_01: cella 22,80; asia 19,80 europa 24,50 pausa 26,20 USA apertura 39,20 USA pomeriggio 20,60 rollover 10,65; asia BUY 21,40 n 1139, "
       "SELL 18,50 n 1175; ingressi 158 = tentati 158; righe -1.0x 0. R1A T1: cella 21,60, ingressi 128)", acc_ok)
    G, _z, _N = _giornale_archivio(ACC_S0)
    lgl = lg.leggi_log(_z.read(_N[ACC_S0["log"]]).decode("ascii", "replace"))
    ck("S0_01: stesse righe segnale del lettore, stesso ordine, stesso campo stop/spread e ora (indipendente dalla dedup)",
       [(s["lato"], s["rap"], s["ora"], s["preso"]) for s in lgl["segnali"]] == [(r["lato"], r["rap"], r["ora"], r["preso"]) for r in G["righe"]], "%d righe" % len(G["righe"]))
    ck("S0_01: la dedup con la chiave del driver toglie 0 righe", G["doppioni"] == 0)
    ck("S0_01: conteggi EA 6973/158/6520/295", G["conta"] and (G["conta"]["seg"], G["conta"]["ing"], G["conta"]["spr"], G["conta"]["pos"]) == (6973, 158, 6520, 295))
    A0 = analizza(G["righe"])
    ck("S0_01: ingressi per fascia 9/12/30/90/17/0 (E2, verifica Gemini)", [f["ingressi"] for f in A0["fasce"]] == [9, 12, 30, 90, 17, 0])
    ck("S0_01: righe >= 50x 355", A0["ge50"] == 355, str(A0["ge50"]))
    acc_falsa = dict(ATTESA_S0)
    acc_falsa["cella"] = 22.81
    ck("CONTRO-ESEMPIO accettazione: un numero atteso spostato di 0,01 -> DIVERSO", confronta_ancora(A0, G, acc_falsa) != [])
    # --- 3. CONTRO-ESEMPI SINTETICI di regola
    S_ind, S_xag = 13.3, 6.65
    sp = "spread oltre il limite"
    # 3a. classe 1376: 150 righe scartate 3,00..8,96 + 90 a spread zero (29 ingressi, 61 a posizione aperta)
    rr = [("BUY" if i % 2 else "SELL", False, sp, 3.0 + 0.04 * i, i % 7) for i in range(150)]
    rr += [("BUY" if i % 2 else "SELL", i < 29, "" if i < 29 else "posizione gia' aperta", -1.0, 7 + i % 5) for i in range(90)]
    righe = leggi_giornale(_log("XAGUSD", "M1", rr))["righe"]
    A = analizza(righe)
    escl = mediana([r["val"] for r in righe if r["rap"] >= 0])
    ck("classe 1376: 90 righe a spread zero -> C3G 7,78x (contate INF), NON 5,98x (scartate)", uguale(A["c3g"], 7.78) and uguale(escl, 5.98), "%s / %s" % (fx(A["c3g"]), fx(escl)))
    ck("classe 1376: (iii) argento NON vale (7,78 >= 6,65) -> niente ESCLUSA anche senza la (v)", not condizioni_b(A, S_xag, 100, False)["iii"] and not condizioni_b(A, S_xag, 100, False)["tutte"])
    ck("classe 1376: ingressi a spread zero contati = 29", A["ingressi_spread_zero"] == 29 and A["righe_spread_zero"] == 90)
    # 3b. fasce a cavallo di S (indice): asia 200 righe a 10x, europa 150 a 20x; cella 10x
    rr = [("BUY" if i % 2 else "SELL", False, sp, 10.0, 3) for i in range(200)] + [("BUY" if i % 2 else "SELL", False, sp, 20.0, 9) for i in range(150)]
    A = analizza(leggi_giornale(_log("NASUSD", "M5", rr))["righe"])
    c = condizioni_b(A, S_ind, 100)
    ck("fasce a cavallo di S: asia 10x (200) e europa 20x (150), cella 10x -> (ii) NO -> niente ESCLUSA", c["i"] and not c["ii"] and c["iii"] and not c["tutte"], fx(A["c3g"]))
    rr2 = [("BUY" if i % 2 else "SELL", False, sp, 10.0, 3) for i in range(200)] + [("BUY" if i % 2 else "SELL", False, sp, 13.2, 9) for i in range(150)]
    A2 = analizza(leggi_giornale(_log("NASUSD", "M5", rr2))["righe"])
    ck("controprova: le stesse fasce tutte sotto S (10x e 13,2x) -> (i)-(iv) SI", condizioni_b(A2, S_ind, 100)["tutte"])
    rr3 = [("BUY" if i % 2 else "SELL", False, sp, 10.0, 3) for i in range(200)] + [("BUY" if i % 2 else "SELL", False, sp, 13.3, 9) for i in range(150)]
    ck("bordo: una fascia ESATTAMENTE a 13,3x (= S) non e' '< S' -> (ii) NO", not condizioni_b(analizza(leggi_giornale(_log("NASUSD", "M5", rr3))["righe"]), S_ind, 100)["ii"])
    # 3c. lato sotto 100 righe
    rr = [("BUY", False, sp, 8.0, 3) for i in range(150)] + [("SELL", False, sp, 9.0, 3) for i in range(80)]
    A = analizza(leggi_giornale(_log("NASUSD", "M5", rr))["righe"])
    c = condizioni_b(A, S_ind, 100)
    ck("lato SELL con 80 righe (< 100), tutto sotto S -> (iv) NO -> 'n insufficiente'", c["i"] and c["ii"] and c["iii"] and not c["iv"])
    # 3d. due lati che separano (contro-esempio del quinto giro): fascia asia BUY 150 a 8-14x e SELL 130 a 12-18x; fuori fascia 10 BUY a 10x e 10 SELL a 14x
    rr = [("BUY", False, sp, 8.0 + 6.0 * i / 149, 3) for i in range(150)] + [("SELL", False, sp, 12.0 + 6.0 * i / 129, 3) for i in range(130)]
    rr += [("BUY", False, sp, 10.0, 15) for i in range(10)] + [("SELL", False, sp, 14.0, 15) for i in range(10)]
    A = analizza(leggi_giornale(_log("D30EUR", "M5", rr))["righe"])
    c = condizioni_b(A, S_ind, 100)
    ck("due lati: fascia e cella 12,85x < 13,3, SELL da solo 14,77x -> (iv) NO -> niente ESCLUSA",
       uguale(A["c3g"], 12.85) and uguale(A["fasce"][0]["c3g"], 12.85) and uguale(A["lati"]["SELL"]["c3g"], 14.77) and c["i"] and c["ii"] and c["iii"] and not c["iv"],
       "cella %s asia %s SELL %s BUY %s" % (fx(A["c3g"]), fx(A["fasce"][0]["c3g"]), fx(A["lati"]["SELL"]["c3g"]), fx(A["lati"]["BUY"]["c3g"])))
    # 3e. una fascia sotto 30 righe (sopra S) non conta ne' col testo pinnato ne' con E1; una fascia da 90 righe a 45x conta SOLO con E1
    base = [("BUY" if i % 2 else "SELL", False, sp, 8.0, 3) for i in range(400)]
    rr = base + [("BUY" if i % 2 else "SELL", False, sp, 45.0, 15) for i in range(25)]
    A = analizza(leggi_giornale(_log("D30EUR", "M5", rr))["righe"])
    ck("fascia USA apertura con 25 righe (< 30) a 45x: ESCLUSA sia col testo pinnato sia con E1 (non conta in (ii))",
       condizioni_b(A, S_ind, 100)["tutte"] and condizioni_b(A, S_ind, 30)["tutte"])
    rr = base + [("BUY" if i % 2 else "SELL", False, sp, 45.0, 15) for i in range(90)]
    A = analizza(leggi_giornale(_log("D30EUR", "M5", rr))["righe"])
    ck("contro-esempio E1: fascia con 90 righe a 45x -> testo pinnato (ii) SI (ESCLUSA), con E1 (ii) NO",
       condizioni_b(A, S_ind, 100, False)["tutte"] and not condizioni_b(A, S_ind, 30, False)["ii"])
    # 3f. nessuna fascia a 100 righe: (ii) vera a vuoto, ma (i) NO
    rr = [("BUY" if i % 2 else "SELL", False, sp, 5.0, [0, 8, 12, 15, 18, 23][i % 6]) for i in range(300)]
    A = analizza(leggi_giornale(_log("NASUSD", "M5", rr))["righe"])
    c = condizioni_b(A, S_ind, 100)
    ck("nessuna fascia con >= 100 righe (6 fasce da 50): (ii) vera A VUOTO ma (i) NO -> niente ESCLUSA", c["ii"] and not c["i"] and not c["tutte"], str([f["n"] for f in A["fasce"]]))
    # --- 4. ESITI end-to-end su zip finti (con l'ancora vera, rifatta da S0_01)
    raw0 = open(ACC_S0["zip"], "rb").read()
    z0 = zipfile.ZipFile(io.BytesIO(raw0))
    N0 = _nomi(z0)
    log_s0 = z0.read(N0[ACC_S0["log"]]).decode("ascii")
    ini_s0 = z0.read(N0["ini/gba_S0_01_REPL_T1_m775800.ini"]).decode("ascii")
    rep_s0 = z0.read(N0["report/GBA_R0_S0_01_REPL_T1_m775800.htm"])

    def zip_ancora(log_txt):
        b = io.BytesIO()
        z = zipfile.ZipFile(b, "w")
        z.writestr(LOTTI["R2SANC"]["prova"], open(os.path.join(QD, "prove", LOTTI["R2SANC"]["prova"]), "rb").read())
        z.writestr("MANIFEST_R0.csv", "lotto;passata;cella;spread_max_atr;tranche;da;a;modello;magic;t_avvio;durata_s;stato;trades_report;profitto_report;pf_report;qualita;"
                   "barre_report;ticks_report;barre_gen;ticks_gen;ticks_inizio;righe_gba;ingressi_log;avvio_ok;autotest;finestra;motivi;asse;valore_asse;simbolo;periodo;prova\r\n"
                   "R2SANC;R2SANC_01_REPL_T1_m775800;REPL;0.05;T1;2026.07.01;2026.09.30;1;775800;2026-10-12 10:00:00;36;OK;158;-6364.79;0.86;100%;88416;353661;88416;353661;;7211;158;"
                   "si;si;2026.07.01-2026.09.30;;InpSignalTF;1;XAUUSD;M1;GBA_R2S_ANCORA_2026-10-12.txt")
        z.writestr("ini\\gba_R2SANC_01_REPL_T1_m775800.ini", ini_s0)
        z.writestr("log\\GBA_R2SANC_01_REPL_T1_m775800.txt", log_txt)
        z.writestr("report\\GBA_R0_R2SANC_01_REPL_T1_m775800.htm", rep_s0)
        z.writestr("RIEPILOGO_R0.txt", _riepilogo("R2SANC"))
        z.close()
        return b.getvalue()
    anc = leggi_lotto("GBA_R0_R2SANC.zip", zip_ancora(log_s0))
    for P in anc["passate"]:
        controlli(P)
    lotti = {"R2SANC": anc}
    ce1 = stato_ce1(lotti)
    ck("CE1 ancora rifatta dai file veri di S0_01 -> VERDE", ce1[0], ce1[1][:90])
    raw1 = open(ACC_R1A["zip"], "rb").read()
    z1 = zipfile.ZipFile(io.BytesIO(raw1))
    log_r1 = z1.read(_nomi(z1)[ACC_R1A["log"]]).decode("ascii")
    anc_r = leggi_lotto("GBA_R0_R2SANC.zip", zip_ancora(log_r1))
    for P in anc_r["passate"]:
        controlli(P)
    ce1r = stato_ce1({"R2SANC": anc_r})
    ck("CONTRO-ESEMPIO CE1: ancora col giornale di R1A (tick reali, cella 21,60) -> ROSSO", not ce1r[0], ce1r[1][:120])
    ck("CE1 senza lo zip dell'ancora -> NON LETTO (esiti (C))", not stato_ce1({})[0])

    def esiti_di(L, celle, acc=True, ce=None, **kw):
        """{cella: (esito pinnato, esito E1, esito di riferimento E1+E4, P)}; ogni esito = (lettera, frase, esclusa)."""
        Lz = leggi_lotto("GBA_R0_%s.zip" % L, _zip_lotto(L, celle, **kw))
        res = {}
        for P in Lz["passate"]:
            if P["giornale"] is not None:
                controlli(P)
            res[P["cella"]] = tuple(esito(P, LOTTI[L]["S"], v, acc, ce or ce1) for v in ("pinnato", "E1", "riferimento")) + (P,)
        return res
    KOZ = {"stato": "KO", "motivi": "ZERO operazioni nel report"}
    sp_xag = [("BUY" if i % 2 else "SELL", False, sp, 2.0 + 0.01 * (i % 300), (i % 24)) for i in range(2400)]
    # 4a. argento n = 0, eccezione valida -> (B) con la frase n = 0; varianti 'ESCLUSA PER COSTO', riferimento 'ESCLUSA (Modello 1)', casella NON ANCORA MISURATO
    r = esiti_di("R2SXAG", {"REPL": dict(KOZ, righe=sp_xag, n=0)})
    e_p, e_1, e_r, P_xag = r["REPL"]
    ck("argento n=0 (KO solo ZERO operazioni, tentati 0, scartati 2400): (B) con la frase n=0; variante col testo pinnato -> 'VARIANTE NON IN VIGORE', MAI la dicitura 'ESCLUSA PER COSTO'",
       e_p[0] == "B" and "nessuna operazione" in e_p[1] and "VARIANTE NON IN VIGORE" in e_p[1] and "ESCLUSA PER COSTO" not in e_p[1] and e_p[2]
       and "VARIANTE NON IN VIGORE" in e_1[1] and "ESCLUSA PER COSTO" not in e_1[1], e_p[1][:150])
    ck("stessa cella, ESITO DI RIFERIMENTO (E1+E4): 'ESCLUSA (Modello 1)', MAI 'ESCLUSA PER COSTO' a Modello 1 da solo",
       e_r[0] == "B" and e_r[2] and "ESCLUSA (Modello 1)" in e_r[1] and "ESCLUSA PER COSTO" not in e_r[1], e_r[1][-100:])
    c4 = casella4(e_r, P_xag, None, 6.65, True)
    ck("E3: senza passata a tick reali la casella 4 e' NON ANCORA MISURATO", c4.startswith("NON ANCORA MISURATO"), c4[:80])
    r = esiti_di("R2SXAG", {"REPL": dict(KOZ, righe=sp_xag, n=0)}, acc=False)
    ck("stessa cella con l'accettazione NON passata -> 'n insufficiente' in TUTTE le varianti, mai ESCLUSA", all(r["REPL"][k][0] == "B" and not r["REPL"][k][2] and "ESCLUSA PER COSTO" not in r["REPL"][k][1] and "ESCLUSA (Modello 1)" not in r["REPL"][k][1] for k in range(3)))
    r = esiti_di("R2SXAG", {"REPL": dict(KOZ, righe=sp_xag, n=0)}, ce=(False, "NON LETTO"))
    ck("stessa cella senza CE1 verde -> (C)", all(r["REPL"][k][0] == "C" for k in range(3)))
    # 4a-bis. E3 PIENA: la conferma a tick reali (stessa cella, stessa tranche, modello 4)

    def p_tick(righe, n=0, ko=True, cella="REPL", ingressi=None, modello="4", motivi=None, qualita="100% ticks reali", ticks_inizio="EURUSD 2024.07.05 / XAGUSD 2024.07.10"):
        spec = dict(KOZ, righe=righe, n=n) if ko else {"righe": righe, "n": n}
        spec.update({"qualita": qualita, "ticks_inizio": ticks_inizio})
        if motivi is not None:
            spec["motivi"] = motivi
        if ingressi is not None:
            spec["ingressi"] = ingressi
        Pt = leggi_lotto("t.zip", _zip_lotto("R2SXAG", {cella: spec}))["passate"][0]
        controlli(Pt)
        Pt["riga"]["modello"] = modello
        return Pt
    c4 = casella4(e_r, P_xag, p_tick([(a, b, m, 7.0 + (x - 2.0), o) for (a, b, m, x, o) in sp_xag]), 6.65, True)
    ck("E3: a tick reali C3G 8,5x >= S 6,65 -> 'n insufficiente / da rimisurare', casella NON ANCORA MISURATO", c4.startswith("NON ANCORA MISURATO: n insufficiente / da rimisurare"), c4[:120])
    c4 = casella4(e_r, P_xag, p_tick(sp_xag), 6.65, True)
    ck("E3: a tick reali KO solo 'ZERO operazioni' sotto l'ECCEZIONE n=0 (tentati 0, scartati 2400) e (i)-(v) valgono -> 'ESCLUSA PER COSTO (Modello 1 e tick reali)', CHIUSA", c4.startswith("CHIUSA: ESCLUSA PER COSTO (Modello 1 e tick reali)"), c4[:120])
    c4 = casella4(e_r, P_xag, p_tick(sp_xag), 6.65, False)
    ck("E3: conferma con l'accettazione NON passata -> NON ANCORA MISURATO", c4.startswith("NON ANCORA MISURATO"), c4[:100])
    Pt31 = p_tick(sp_xag + [("BUY", True, "", 60.0, 15) for i in range(31)], n=31, ko=False)
    c4 = casella4(e_r, P_xag, Pt31, 6.65, True)
    ck("E3 in ORDINE: a tick reali n netto 31 (la (v) cade per costruzione: 31 righe >= 40x) -> conferma SMENTITA PER n, resta (B) 'n insufficiente a Modello 1', MAI (A)",
       "SMENTITA PER n" in c4 and "n insufficiente a Modello 1" in c4 and "n netto a tick reali 31 >= 30" in c4 and "(A)" not in c4 and "da rimisurare" not in c4
       and "CHIUSA" not in c4 and not condizioni_b(Pt31["A"], 6.65, 30)["v"], c4[:120])
    c4 = casella4(e_r, P_xag, p_tick(sp_xag, n=0, ko=True, motivi='qualita dello storico "100%" invece di 100% ticks reali: il verdetto a ticks reali NON vale'), 6.65, True)
    ck("E3 (1): KO per qualita' dello storico (non tick reali) -> NON ANCORA MISURATO, storia a tick mancante, con scritto cosa manca",
       c4.startswith("NON ANCORA MISURATO: storia a tick mancante") and "qualita dello storico" in c4, c4[:120])
    c4 = casella4(e_r, P_xag, p_tick(sp_xag, n=0, ko=True, motivi="ticks data begins from XAGUSD 2026.08.01: DOPO l inizio della tranche 2026.07.01 (prima di quella data MT5 genera i tick: non sono reali)"), 6.65, True)
    ck("E3 (1): KO per 'ticks data begins from' dopo l'inizio della tranche -> NON ANCORA MISURATO, storia a tick mancante", c4.startswith("NON ANCORA MISURATO: storia a tick mancante"), c4[:120])
    c4 = casella4(e_r, P_xag, p_tick(sp_xag, n=0, ko=True, qualita="100%"), 6.65, True)
    ck("E3 (1): qualita' del manifest '100%' (non '100% ticks reali') -> storia a tick mancante anche se il driver non l'ha messa KO per quello", c4.startswith("NON ANCORA MISURATO: storia a tick mancante"), c4[:120])
    c4 = casella4(e_r, P_xag, p_tick(sp_xag, n=0, ko=True, ticks_inizio="EURUSD 2024.07.05 / XAGUSD 2026.08.01"), 6.65, True)
    ck("E3 (1): colonna ticks_inizio col simbolo dopo l'inizio della tranche -> storia a tick mancante", c4.startswith("NON ANCORA MISURATO: storia a tick mancante") and "2026.08.01" in c4, c4[:120])
    c4 = casella4(e_r, P_xag, p_tick(sp_xag, n=0, ko=True, motivi="ZERO operazioni nel report | AUTOTEST dell EA: FAIL (1 righe)"), 6.65, True)
    c4z = casella4(e_r, P_xag, p_tick(sp_xag[:-1] + [("BUY", True, "", 60.0, 10)], n=0, ko=True, ingressi=0), 6.65, True)
    ck("E3: KO 'ZERO operazioni' con tentati 1 (> 0) -> conferma NON data (non e' l'eccezione)", c4z.startswith("NON ANCORA MISURATO: conferma NON data") and "CHIUSA" not in c4z, c4z[:120])
    c4z = casella4(e_r, P_xag, p_tick([], n=0, ko=True), 6.65, True)
    ck("E3: KO 'ZERO operazioni' con segnali(EA) = 0 -> conferma NON data", c4z.startswith("NON ANCORA MISURATO: conferma NON data"), c4z[:120])
    Pts = p_tick(sp_xag)
    Pts["sha_d2"] = "0" * 64
    c4z = casella4(e_r, P_xag, Pts, 6.65, True)
    ck("E3: passata a tick reali letta da un D2 con SHA256 diverso -> conferma NON data (anche con (i)-(v) che varrebbero)", c4z.startswith("NON ANCORA MISURATO: conferma NON data") and "D2" in c4z, c4z[:130])
    ck("E3: la stessa passata letta dallo STESSO D2 -> CHIUSA (controprova del test SHA)", casella4(e_r, P_xag, p_tick(sp_xag), 6.65, True).startswith("CHIUSA"))
    ck("E3 (1): KO per un ALTRO motivo -> conferma NON data, casella aperta (mai CHIUSA)", c4.startswith("NON ANCORA MISURATO: conferma NON data") and "CHIUSA" not in c4, c4[:120])
    c4 = casella4(e_r, P_xag, p_tick(sp_xag + [("BUY" if i % 2 else "SELL", False, sp, 45.0, i % 24) for i in range(30)]), 6.65, True)
    ck("E3: a tick reali 30 righe a 45x -> (v) NO -> da rimisurare", c4.startswith("NON ANCORA MISURATO") and "v" in c4.split("non vale:")[-1], c4[-60:])
    rifiuta("E3 RIFIUTO: passata 'a tick reali' di un'altra cella (M15)", lambda: casella4(e_r, P_xag, p_tick(sp_xag, cella="M15"), 6.65, True))
    rifiuta("E3 RIFIUTO: passata di conferma a Modello 1 (non tick reali)", lambda: casella4(e_r, P_xag, p_tick(sp_xag, modello="1"), 6.65, True))
    # 4b. n = 0 con tentati 1 -> (C)
    rr = sp_xag[:-1] + [("BUY", True, "", 60.0, 10)]
    r = esiti_di("R2SXAG", {"REPL": dict(KOZ, righe=rr, n=0, ingressi=0)})
    ck("n=0 con tentati 1 (ordine rifiutato, non filtrato) -> (C)", r["REPL"][2][0] == "C", r["REPL"][2][1][:120])
    # 4c. segnali(EA) = 0 -> (C)
    r = esiti_di("R2SXAG", {"REPL": dict(KOZ, righe=[], n=0)})
    ck("n=0 con ZERO segnali (scartati spread 0) -> (C), non 'tutti i liberi scartati' a vuoto", r["REPL"][2][0] == "C")
    # 4d. KO con un secondo motivo -> (C)
    r = esiti_di("R2SXAG", {"REPL": {"righe": sp_xag, "n": 0, "stato": "KO", "motivi": "ZERO operazioni nel report | AUTOTEST dell EA: FAIL (1 righe)"}})
    ck("KO con un motivo in piu' oltre ZERO operazioni -> (C)", r["REPL"][2][0] == "C")
    # 4e. CE6: tentati - n = 2 -> (C)
    rr = [("BUY" if i % 2 else "SELL", False, sp, 30.0, i % 24) for i in range(300)] + [("BUY", True, "", 60.0, 15) for i in range(12)]
    r = esiti_di("R2SNAS", {"M5": {"righe": rr, "n": 10, "ingressi": 10}})
    ck("CE6: tentati 12 - n 10 = 2 -> (C)", r["M5"][2][0] == "C" and "CE6" in r["M5"][2][1])
    # 4f. porta: 40 ingressi, 15 a spread zero -> (B)
    rr = [("BUY" if i % 2 else "SELL", False, sp, 30.0, i % 24) for i in range(400)] + [("BUY", True, "", 60.0, 15) for i in range(25)] + [("SELL", True, "", -1.0, 15) for i in range(15)]
    r = esiti_di("R2SNAS", {"M5": {"righe": rr, "n": 40, "ingressi": 40}})
    ck("porta (A): 40 ingressi di cui 15 a spread zero -> 25 < 30 -> (B), non (A)", r["M5"][2][0] == "B" and "= 25 <" in r["M5"][2][1], r["M5"][2][1][:110])
    ck("il numero del costo (C3G cella, lati, fasce) e' accanto a OGNI esito (B), anche 'n insufficiente', in tutte e tre le versioni",
       all(r["M5"][k][0] == "B" and "| COSTO: C3G cella 30.00 (n 440), BUY" in r["M5"][k][1] and "asia" in r["M5"][k][1].split("| COSTO:")[1] for k in range(3)), r["M5"][2][1][-120:])
    # 4g. (A) con la frase FRA
    rr = [("BUY" if i % 2 else "SELL", False, sp, 30.0, i % 24) for i in range(400)] + [("BUY", True, "", 60.0, 15) for i in range(40)]
    r = esiti_di("R2SNAS", {"M5": {"righe": rr, "n": 40, "ingressi": 40}})
    ck("(A) n 40 con C3G 30x -> PASSA ALLO STADIO B con 'FRA sui segnali grezzi, PASSA solo grazie al filtro'", r["M5"][2][0] == "A" and "FRA sui segnali grezzi" in r["M5"][2][1], r["M5"][2][1][:120])
    ck("(A): casella 4 aperta, la cella va allo stadio B", "la cella va allo stadio B (A)" in casella4(r["M5"][2], r["M5"][3], None, 13.3, True))
    # 4h. 'ATR non valido' come dice il documento (E4): il campo 0,0x entra nel C3G col suo valore e NON conta nella (v); ATR nullo e spread zero = -1,0x = INFINITO e conta
    cc = {"seg": 2401, "ing": 0, "spr": 2400, "pos": 0, "dati": 1}
    lg_atr = _log("XAGUSD", "M1", sp_xag + [("BUY", False, "ATR non valido", 0.0, 3)], conta=cc)
    r = esiti_di("R2SXAG", {"REPL": dict(KOZ, righe=None, log=lg_atr, n=0)})
    ck("una riga 'ATR non valido' a 0,0x: (v) non la conta (righe >= 40x 0), esito di riferimento ESCLUSA (Modello 1) come da documento",
       r["REPL"][3]["A"]["ge40"] == 0 and r["REPL"][2][2], r["REPL"][2][1][-90:])
    rows30 = sp_xag + [("BUY", False, "ATR non valido", -1.0, 3) for i in range(30)]
    cc30 = {"seg": 2430, "ing": 0, "spr": 2400, "pos": 0, "dati": 30}
    r = esiti_di("R2SXAG", {"REPL": dict(KOZ, righe=None, log=_log("XAGUSD", "M1", rows30, conta=cc30), n=0)})
    ck("30 righe 'ATR non valido' a spread zero (-1,0x = INFINITO) contano nella (v): 30 >= 30 -> 'n insufficiente' (di riferimento), ESCLUSA nelle varianti senza E4",
       r["REPL"][3]["A"]["ge40"] == 30 and not r["REPL"][2][2] and r["REPL"][1][2], "ge40 %d" % r["REPL"][3]["A"]["ge40"])
    # 4j. E4, contro-esempi del documento
    # (1) D30EUR M5: asia 300 righe a 8x di cui 40 a >= 50x (25 ingressi + 15 a posizione aperta); europa 20 righe a 10x; n = 25
    rr = [("BUY" if i % 2 else "SELL", False, sp, 7.5 + 0.004 * i, 3) for i in range(260)]
    rr += [("BUY" if i % 2 else "SELL", i < 25, "" if i < 25 else "posizione gia' aperta", 55.0, 3) for i in range(40)]
    rr += [("BUY" if i % 2 else "SELL", False, sp, 10.0, 9) for i in range(20)]
    r = esiti_di("R2SD30", {"M5": {"righe": rr, "n": 25}})
    e_p, e_1, e_r, P4 = r["M5"]
    ck("E4 (1): asia 300 a 8x con 40 righe >= 50x, n 25 -> senza (v) ESCLUSA (varianti), con (v) 'n insufficiente' (riferimento)",
       e_p[2] and e_1[2] and e_r[0] == "B" and not e_r[2] and P4["A"]["ge40"] == 40 and condizioni_b(P4["A"], 13.3, 30)["iii"], "cella %s ge40 %d; %s" % (fx(P4["A"]["c3g"]), P4["A"]["ge40"], e_r[1][-60:]))
    # (2) perche' non 50x: asia 300 a 8x (30 fra 40 e 50x, 10 a >= 50x), USA pomeriggio 180 a 10x (30 fra 40 e 50x, 10 a >= 50x); n = 15
    rr = [("BUY" if i % 2 else "SELL", False, sp, 7.5 + 0.004 * i, 3) for i in range(260)] + [("BUY" if i % 2 else "SELL", False, sp, 45.0, 3) for i in range(30)]
    rr += [("BUY" if i % 2 else "SELL", i < 8, "" if i < 8 else "posizione gia' aperta", 55.0, 3) for i in range(10)]
    rr += [("BUY" if i % 2 else "SELL", False, sp, 9.5 + 0.004 * i, 18) for i in range(140)] + [("BUY" if i % 2 else "SELL", False, sp, 45.0, 18) for i in range(30)]
    rr += [("BUY" if i % 2 else "SELL", i < 7, "" if i < 7 else "posizione gia' aperta", 55.0, 18) for i in range(10)]
    r = esiti_di("R2SD30", {"M5": {"righe": rr, "n": 15}})
    e_p, e_1, e_r, P4 = r["M5"]
    A4 = P4["A"]
    ck("E4 (2): righe >= 50x 20 (< 30: la (v) a 50x direbbe ESCLUSA PER COSTO), righe >= 40x 80 (>= 30) -> riferimento 'n insufficiente'",
       A4["ge50"] == 20 and A4["ge40"] == 80 and e_1[2] and e_r[0] == "B" and not e_r[2] and "n insufficiente" in e_r[1],
       "ge50 %d ge40 %d cella %s asia %s pom %s" % (A4["ge50"], A4["ge40"], fx(A4["c3g"]), fx(A4["fasce"][0]["c3g"]), fx(A4["fasce"][4]["c3g"])))
    # sessione spezzata (buco di E1 chiuso da E4): europa 28, pausa 20, USA apertura 25 righe a 45x; asia 300 a 8x; USA pomeriggio 150 a 9x
    rr = [("BUY" if i % 2 else "SELL", False, sp, 8.0, 3) for i in range(300)] + [("BUY" if i % 2 else "SELL", False, sp, 9.0, 18) for i in range(150)]
    rr += [("BUY" if i % 2 else "SELL", False, sp, 45.0, h) for h, k in ((9, 28), (12, 20), (15, 25)) for i in range(k)]
    As = analizza(leggi_giornale(_log("D30EUR", "M5", rr))["righe"])
    ck("sessione spezzata in fasce < 30 righe a 45x: E1 da sola ESCLUSA, con E4 (73 righe >= 40x) NO",
       condizioni_b(As, 13.3, 30, False)["tutte"] and not condizioni_b(As, 13.3, 30, True)["tutte"] and As["ge40"] == 73)
    # bordo della (v): 29 righe a 40,0x -> (v) SI; 30 -> NO (>= 40,0 inclusivo, < 30)
    base = [("BUY" if i % 2 else "SELL", False, sp, 8.0, 3) for i in range(300)]
    ck("bordo (v): 29 righe a 40,0x -> (v) SI; 30 righe -> (v) NO; 30 righe a 39,9x -> (v) SI",
       condizioni_b(analizza(leggi_giornale(_log("D30EUR", "M5", base + [("BUY", False, sp, 40.0, 3)] * 29))["righe"]), 13.3, 30)["v"]
       and not condizioni_b(analizza(leggi_giornale(_log("D30EUR", "M5", base + [("BUY", False, sp, 40.0, 3)] * 30))["righe"]), 13.3, 30)["v"]
       and condizioni_b(analizza(leggi_giornale(_log("D30EUR", "M5", base + [("BUY", False, sp, 39.9, 3)] * 30))["righe"]), 13.3, 30)["v"])
    ck("sull'ORO la (v) non vale: S0_01 righe >= 40x %d (740), >= 50x %d (355)" % (A0["ge40"], A0["ge50"]), A0["ge40"] == 740 and A0["ge50"] == 355 and not condizioni_b(A0, 13.3, 30)["v"])
    A1r = analizza(_giornale_archivio(ACC_R1A)[0]["righe"])
    ck("sull'ORO la (v) non vale: R1A T1 righe >= 40x %d (651), >= 50x %d (280)" % (A1r["ge40"], A1r["ge50"]), A1r["ge40"] == 651 and A1r["ge50"] == 280 and not condizioni_b(A1r, 13.3, 30)["v"])
    # 4i. CE2: oro rietichettato come argento in tutti i file (AVVIO, FINESTRA, ini, report) -> firma dell'oro -> (C)
    lg_oro = log_s0.replace('InpSymbol="XAUUSD" -> simbolo XAUUSD', 'InpSymbol="XAGUSD" -> simbolo XAGUSD').replace("# FINESTRA XAUUSD|", "# FINESTRA XAGUSD|")
    r = esiti_di("R2SXAG", {"REPL": {"righe": None, "log": lg_oro, "n": 158}})
    ck("CE2: giornale VERO dell'oro rietichettato XAGUSD ovunque -> firma dell'oro -> (C)", r["REPL"][2][0] == "C" and "CE2" in r["REPL"][2][1], r["REPL"][2][1][:120])
    # --- 5. RIFIUTI (nessun numero)
    rr = [("BUY" if i % 2 else "SELL", False, sp, 30.0, i % 24) for i in range(50)]
    rifiuta("RIFIUTO: lo zip d'oro S0_01 sotto l'etichetta R2SXAG (AVVIO dice XAUUSD)", lambda: leggi_lotto("GBA_R0_R2SXAG.zip", _zip_lotto("R2SXAG", {"REPL": {"righe": None, "log": log_s0, "n": 158}})))
    rifiuta("RIFIUTO: riga FINESTRA di un altro simbolo", lambda: leggi_lotto("x.zip", _zip_lotto("R2SNAS", {"M5": {"righe": rr, "n": 0, "fin_sim": "U30USD"}})))
    rifiuta("RIFIUTO: report di un altro simbolo", lambda: leggi_lotto("x.zip", _zip_lotto("R2SNAS", {"M5": {"righe": rr, "n": 0}}, rep_sim="XAUUSD")))
    rifiuta("RIFIUTO: ini con Symbol diverso", lambda: leggi_lotto("x.zip", _zip_lotto("R2SNAS", {"M5": {"righe": rr, "n": 0}}, ini_mod=lambda te, inp: te.update({"Symbol": "XAUUSD"}))))
    rifiuta("RIFIUTO: ini con InpSignalTF diverso dalla cella (TF sbagliato)", lambda: leggi_lotto("x.zip", _zip_lotto("R2SNAS", {"M5": {"righe": rr, "n": 0}}, ini_mod=lambda te, inp: inp.update({"InpSignalTF": "15"}))))
    rifiuta("RIFIUTO: ini con un pin diverso dal file prova (InpSpreadMaxATR 0.10)", lambda: leggi_lotto("x.zip", _zip_lotto("R2SNAS", {"M5": {"righe": rr, "n": 0}}, ini_mod=lambda te, inp: inp.update({"InpSpreadMaxATR": "0.10"}))))
    rifiuta("RIFIUTO: manifest con periodo M15 per la cella M5", lambda: leggi_lotto("x.zip", _zip_lotto("R2SNAS", {"M5": {"righe": rr, "n": 0, "tf": "M15", "valore": "5"}})))
    rifiuta("RIFIUTO: manifest con simbolo XAUUSD nel lotto R2SNAS", lambda: leggi_lotto("x.zip", _zip_lotto("R2SNAS", {"M5": {"righe": rr, "n": 0, "simbolo": "XAUUSD"}})))
    rifiuta("RIFIUTO: cella non dichiarata nel file prova (M1 nel lotto Nasdaq)", lambda: leggi_lotto("x.zip", _zip_lotto("R2SNAS", {"M1": {"righe": rr, "n": 0, "tf": "M1"}})))
    rifiuta("RIFIUTO: giornale ASSENTE", lambda: leggi_lotto("x.zip", _zip_lotto("R2SNAS", {"M5": {"righe": rr, "n": 0}}, togli=("log",))))
    rifiuta("RIFIUTO: ini ASSENTE", lambda: leggi_lotto("x.zip", _zip_lotto("R2SNAS", {"M5": {"righe": rr, "n": 0}}, togli=("ini",))))
    rifiuta("RIFIUTO: file prova con un byte diverso (SHA256 non pinnato)", lambda: leggi_lotto("x.zip", _zip_lotto("R2SNAS", {"M5": {"righe": rr, "n": 0}},
                                                                                                                prova_bytes=open(os.path.join(QD, "prove", LOTTI["R2SNAS"]["prova"]), "rb").read() + b"\n")))
    rifiuta("RIFIUTO: file prova di un altro lotto (argento nello zip Nasdaq)", lambda: leggi_lotto("x.zip", _zip_lotto("R2SNAS", {"M5": {"righe": rr, "n": 0}},
                                                                                                               prova_bytes=open(os.path.join(QD, "prove", LOTTI["R2SXAG"]["prova"]), "rb").read())))
    rifiuta("RIFIUTO: nome dello zip con un altro lotto", lambda: leggi_lotto("GBA_R0_R2SD30.zip", _zip_lotto("R2SNAS", {"M5": {"righe": rr, "n": 0}})))
    lg_d = _log("NASUSD", "M5", rr)
    righe_lg = lg_d.split("\r\n")
    lg_dup = "\r\n".join(righe_lg[:4] + [righe_lg[3]] + righe_lg[4:])
    rifiuta("RIFIUTO: giornale con una riga doppia (stessa chiave del driver)", lambda: leggi_lotto("x.zip", _zip_lotto("R2SNAS", {"M5": {"righe": None, "log": lg_dup, "n": 0}})))
    rifiuta("RIFIUTO: riga segnale che il parser non legge", lambda: leggi_giornale("2026.07.01 00:01:00   [GBA] segnale BUY | close 1 canale X"))
    rifiuta("RIFIUTO: stop/spread -2.0x (sentinella sconosciuta)", lambda: leggi_giornale(_riga_seg(0, "BUY", False, sp, 5.0, 3).replace("5.0000x", "-2.0x")))
    rifiuta("RIFIUTO: ora server 24", lambda: leggi_giornale(_riga_seg(0, "BUY", False, sp, 5.0, 3).replace("ora server 3", "ora server 24")))
    rifiuta("RIFIUTO: RIEPILOGO di un altro pin (zip di un altro giro con lo stesso file prova)",
            lambda: leggi_lotto("x.zip", _zip_lotto("R2SNAS", {"M5": {"righe": rr, "n": 0}}, riepilogo=_riepilogo("R2SNAS", pin="2f4a2a5b786bdc2dd5eddd883ac9d63bacbef02f"))))
    rifiuta("RIFIUTO: RIEPILOGO con lo SHA256 di un altro EA", lambda: leggi_lotto("x.zip", _zip_lotto("R2SNAS", {"M5": {"righe": rr, "n": 0}}, riepilogo=_riepilogo("R2SNAS", sha_ea="0" * 64))))
    rifiuta("RIFIUTO: RIEPILOGO_R0.txt ASSENTE", lambda: leggi_lotto("x.zip", _zip_lotto("R2SNAS", {"M5": {"righe": rr, "n": 0}}, togli=("riepilogo",))))
    rifiuta("RIFIUTO: OROLOGIO, ora server della riga diversa dall'ora dell'orario simulato",
            lambda: leggi_giornale(_riga_seg(0, "BUY", False, sp, 5.0, 3).replace("ora server 3", "ora server 4")))
    lg_old = _log("NASUSD", "M5", rr).replace("2026.07.", "2025.07.")
    rifiuta("RIFIUTO: righe segnale di un'altra finestra (2025) sotto un manifest T1 2026", lambda: leggi_lotto("x.zip", _zip_lotto("R2SNAS", {"M5": {"righe": None, "log": lg_old, "n": 0}})))
    zdup = _zip_lotto("R2SNAS", {"M5": {"righe": rr, "n": 0}})
    bz = io.BytesIO()
    with zipfile.ZipFile(io.BytesIO(zdup)) as zi, zipfile.ZipFile(bz, "w") as zo:
        for it in zi.namelist():
            dati = zi.read(it)
            if it == "MANIFEST_R0.csv":
                rr_m = dati.decode("ascii").split("\r\n")
                dati = "\r\n".join(rr_m + [rr_m[1]]).encode("ascii")
            zo.writestr(it, dati)
    rifiuta("RIFIUTO: la stessa cella due volte nel manifest", lambda: leggi_lotto("x.zip", bz.getvalue()))
    # mediana PARI al bordo, in virgola mobile: 50 righe a 10,2x e 50 a 16,4x -> 13,3 esatto, NON '< 13,3' (senza arrotondamento: 13,299999999999999)
    vb = [10.2] * 50 + [16.4] * 50
    ck("mediana pari al bordo: (10,2 + 16,4) / 2 = 13,3 esatto (non un ulp sotto) -> '< S' FALSO", mediana(vb) == 13.3 and not mediana(vb) < 13.3 and (10.2 + 16.4) / 2 < 13.3,
       repr(mediana(vb)))
    vb2 = [2.6] * 50 + [10.7] * 50
    ck("mediana pari al bordo dell'argento: (2,6 + 10,7) / 2 = 6,65 esatto -> '< 6,65' FALSO", mediana(vb2) == 6.65 and not mediana(vb2) < 6.65, repr(mediana(vb2)))
    rrb = [("BUY", False, sp, 10.2, 3)] * 50 + [("BUY", False, sp, 16.4, 3)] * 50 + [("SELL", False, sp, 10.2, 3)] * 50 + [("SELL", False, sp, 16.4, 3)] * 50
    cb = condizioni_b(analizza(leggi_giornale(_log("D30EUR", "M5", rrb))["righe"]), 13.3, 30)
    ck("bordo in un giornale: cella, fascia e lati a 13,3 esatti -> (ii) (iii) (iv) NO, niente ESCLUSA", not cb["ii"] and not cb["iii"] and not cb["iv"] and not cb["tutte"])
    # fasce al bordo di E1: 29 righe a 45x non entrano nella (ii), 30 si'
    b29 = [("BUY" if i % 2 else "SELL", False, sp, 8.0, 3) for i in range(400)] + [("BUY" if i % 2 else "SELL", False, sp, 45.0, 15) for i in range(29)]
    b30 = [("BUY" if i % 2 else "SELL", False, sp, 8.0, 3) for i in range(400)] + [("BUY" if i % 2 else "SELL", False, sp, 45.0, 15) for i in range(30)]
    ck("bordo E1: fascia di 29 righe a 45x fuori dalla (ii) ((ii) SI), di 30 righe dentro ((ii) NO)",
       condizioni_b(analizza(leggi_giornale(_log("D30EUR", "M5", b29))["righe"]), 13.3, 30)["ii"]
       and not condizioni_b(analizza(leggi_giornale(_log("D30EUR", "M5", b30))["righe"]), 13.3, 30)["ii"])
    # --- 6. lancio vero su un file (main) con raccolta annidata: stampa e CSV
    import tempfile
    td = tempfile.mkdtemp(prefix="d2_")
    raccolta = os.path.join(td, "GBA_R2S_A.zip")
    with zipfile.ZipFile(raccolta, "w") as zr:
        zr.writestr("GBA_R0_R2SANC.zip", zip_ancora(log_s0))
        zr.writestr("GBA_R0_R2SXAG.zip", _zip_lotto("R2SXAG", {"REPL": {"righe": sp_xag, "n": 0, "stato": "KO", "motivi": "ZERO operazioni nel report"},
                                                              "M15": {"righe": [("BUY" if i % 2 else "SELL", False, sp, 9.0, i % 24) for i in range(600)], "n": 0, "stato": "KO",
                                                                      "motivi": "ZERO operazioni nel report"}}))
        zr.writestr("GBA_R0_R2SNAS_COMPILAZIONE_FALLITA.zip", b"x")
        zr.writestr("ESITI_R2S_A.txt", "GBA R2S A -- pin %s   pc DESKTOP-H4D7CAJ\r\nR2SANC rc 0" % PIN_AMMESSI[0])
    lotti_m, note_m = carica([raccolta])
    acc2, accr2 = accettazione()
    csvp = os.path.join(td, "d2.csv")
    testo = stampa(lotti_m, note_m, acc2, accr2, csvp)
    ck("raccolta annidata: lotti R2SANC e R2SXAG letti, COMPILAZIONE_FALLITA in nota", set(lotti_m) == {"R2SANC", "R2SXAG"} and any("COMPILAZIONE" in x for x in note_m))
    ck("stampa: ESITO pinnato e con E1 per ogni cella dei gemelli, ASCII puro, mai la parola vietata",
       testo.count("ESITO secondo il testo pinnato") == 2 and testo.count("ESITO con E1") == 2 and testo.count("ESITO DI RIFERIMENTO") == 2 and testo.count("CASELLA 4 (E3)") == 2
       and all(ord(ch) < 128 for ch in testo) and "morto" not in testo.lower())
    ck("argento M15 a 9,0x: (iii) NO con S 6,65 -> 'n insufficiente' (di riferimento)", "n insufficiente" in [l for l in testo.splitlines() if "ESITO DI RIFERIMENTO" in l][1])
    ck("argento M1 in stampa: riferimento 'ESCLUSA (Modello 1)' e casella 4 NON ANCORA MISURATO; mai 'ESCLUSA PER COSTO (Modello 1 e tick reali)' senza conferma",
       "ESCLUSA (Modello 1)" in [l for l in testo.splitlines() if "ESITO DI RIFERIMENTO" in l][0] and "NON ANCORA MISURATO" in [l for l in testo.splitlines() if "CASELLA 4" in l][0]
       and "Modello 1 e tick reali" not in testo)
    rows = list(csv.DictReader(open(csvp, encoding="ascii"), delimiter=";"))
    ck("CSV: 1 riga CELLA + 6 FASCIA per ciascuna delle 3 celle", len(rows) == 21 and sum(1 for x in rows if x["livello"] == "CELLA") == 3, str(len(rows)))
    rifiuta("RIFIUTO: lo stesso lotto caricato due volte", lambda: carica([raccolta, raccolta]))
    ck("stampa della raccolta: la dicitura di chiusura 'ESCLUSA PER COSTO' non compare MAI senza conferma a tick reali (E3), nemmeno nelle varianti e nel CSV",
       "ESCLUSA PER COSTO" not in testo and "ESCLUSA PER COSTO" not in open(csvp, encoding="ascii").read())
    raccolta2 = os.path.join(td, "GBA_R2S_A_altro_pin.zip")
    with zipfile.ZipFile(raccolta2, "w") as zr:
        zr.writestr("GBA_R0_R2SANC.zip", zip_ancora(log_s0))
        zr.writestr("ESITI_R2S_A.txt", "GBA R2S A -- pin %s   pc DESKTOP-H4D7CAJ\r\nR2SANC rc 0" % ("2f4a2a5b786bdc2dd5eddd883ac9d63bacbef02f"))
    rifiuta("RIFIUTO: raccolta con ESITI_R2S_A.txt di un altro pin", lambda: carica([raccolta2]))
    # --- 7. lotto R2SXAG2 (v3): regressione dello stadio A, CE7, X6, CE8, pin per lotto, ordine
    _autotest_xag2(ck, rifiuta, td, zip_ancora, log_s0, KOZ)
    ck("il lettore non e' stato modificato dall'autotest", hashlib.sha256(open(lp, "rb").read()).hexdigest() == LETTORE_SHA256)
    import shutil
    shutil.rmtree(td, ignore_errors=True)
    ck("i 6 file prova non sono stati toccati", all(hashlib.sha256(open(os.path.join(QD, "prove", D["prova"]), "rb").read()).hexdigest() == D["sha"] for D in LOTTI.values()))
    print("AUTOTEST: %d OK, %d FAIL -> %s" % (ok_tot[0], ok_tot[1], "PASS" if ok_tot[1] == 0 else "FAIL"))
    return 0 if ok_tot[1] == 0 else 1


def _autotest_xag2(ck, rifiuta, td, zip_ancora, log_s0, KOZ):
    """Contro-esempi del lotto R2SXAG2 (v3). Ogni lettura passa da carica() + stampa() come da riga di comando."""
    print("  --- lotto R2SXAG2 (rilancio dell'argento, v3) ---")
    D = LOTTI["R2SXAG2"]
    ck("R2SXAG2: file prova GBA_R2S_XAGUSD2 con lo SHA256 pinnato (dbe11bc3...), XAGUSD, S 6,65, celle M15 -> REPL, tag R2SXAG2_01_M15 / R2SXAG2_02_REPL",
       hashlib.sha256(open(os.path.join(QD, "prove", D["prova"]), "rb").read()).hexdigest() == D["sha"] and D["S"] == 6.65 and D["simbolo"] == "XAGUSD"
       and [c for c, _t in D["celle"]] == ["M15", "REPL"] and D["tag"] == {"M15": "R2SXAG2_01_M15_T1_m775800", "REPL": "R2SXAG2_02_REPL_T1_m775800"})
    ck("pin PER LOTTO: i 5 lotti dello stadio A solo cc9bcda0, R2SXAG2 solo d53493a9; PIN_AMMESSI = (cc9bcda0, d53493a9)",
       all(LOTTI[L]["pin"] == PIN_A for L in GIRO_A) and LOTTI["R2SXAG2"]["pin"] == PIN_XAG2 and set(PIN_AMMESSI) == {PIN_A, PIN_XAG2}
       and PIN_XAG2 == "d53493a92901b82c6b4c12c1d79ec3cb4ebfa5bb")
    acc_ok, acc_r = accettazione()
    # 7a. REGRESSIONE: la lettura archiviata dello stadio A (v2) riga per riga
    raw = open(ARCH_R2S_A, "rb").read()
    ck("archivio GBA_R2S_A.zip del 12/10 con lo SHA256 pinnato (ae62e772...)", hashlib.sha256(raw).hexdigest() == SHA_ARCH_R2S_A)
    arch = open(ARCH_LETTURA_A[0], "rb").read()
    ck("lettura archiviata LETTURA_D2_R2S_A.txt (v2) con lo SHA256 pinnato (d3359c09...)", hashlib.sha256(arch).hexdigest() == ARCH_LETTURA_A[1])
    la, na = carica([ARCH_R2S_A])
    csv_a = os.path.join(td, "regr_A.csv")
    testo_a = stampa(la, na, acc_ok, acc_r, csv_a).splitlines()
    vecchie = arch.decode("ascii").splitlines()
    diverse = [i + 1 for i in range(min(len(vecchie) - 1, len(testo_a))) if vecchie[i] != testo_a[i]]
    ck("REGRESSIONE stadio A: la v3 rilegge GBA_R2S_A.zip e stampa le %d righe della v2 IDENTICHE, salvo la riga 2 (versione + SHA256 di D2); l'ultima riga archiviata "
       "e' il percorso del CSV (stampato da main)" % (len(vecchie) - 1),
       len(testo_a) == len(vecchie) - 1 and diverse == [2] and vecchie[-1].startswith(" CSV: ") and testo_a[1].startswith(" leggi_gba_r2s_c3g v3 ")
       and testo_a[1].endswith(sha_d2()[:16]) and vecchie[1].endswith("14384d874d124021"), "righe diverse: %s" % diverse)
    ck("REGRESSIONE stadio A: il CSV della v3 e' IDENTICO byte per byte a D2_C3G_R2S_A.csv archiviato (91010969...)",
       hashlib.sha256(open(csv_a, "rb").read()).hexdigest() == ARCH_CSV_A[1] == hashlib.sha256(open(ARCH_CSV_A[0], "rb").read()).hexdigest())
    ck("stadio A: nessuna riga del rilancio (E3(3), CE7, X6, CE8) nella lettura dello stadio A", not any(("E3(3)" in x or "CE7" in x or "X6" in x or "CE8" in x) for x in testo_a))
    # 7b. dati VERI del 12/10: l'ancora e il giornale della REPL argento
    zA = zipfile.ZipFile(io.BytesIO(raw))
    NA = _nomi(zA)
    anc = zA.read(NA["GBA_R0_R2SANC.zip"])
    ck("ancora del 12/10: GBA_R0_R2SANC.zip dentro GBA_R2S_A.zip ha lo SHA256 pinnato in D2 (259f4ba0...)", hashlib.sha256(anc).hexdigest() == SHA_ANCORA_1210)
    zx_raw = zA.read(NA["GBA_R0_R2SXAG.zip"])
    zx = zipfile.ZipFile(io.BytesIO(zx_raw))
    log1210 = zx.read(_nomi(zx)["log/GBA_R2SXAG_01_REPL_T1_m775800.txt"]).decode("ascii")
    vera = leggi_lotto("GBA_R0_R2SXAG.zip", zx_raw)
    d8 = ce8_passata(vera["passate"][0])
    ck("CE8 sui dati VERI del 12/10 (F1-F3 del file prova): REPL argento avvio 16:31:36, fine del test +13 s, 'last test passed' ASSENTE, durata 1215 -> BLOCCATA DOPO IL TEST",
       d8["t_avvio"] == "2026-10-12 16:31:36" and d8["test_s"] is not None and int(d8["test_s"]) == 13 and not d8["last"] and d8["durata"] == "1215"
       and d8["classe"].startswith("BLOCCATA DOPO IL TEST") and d8["balance"] == DEPOSITO, ce8_testo(d8)[:160])
    va = leggi_lotto("GBA_R0_R2SANC.zip", anc)
    controlli(va["passate"][0])
    da = ce8_passata(va["passate"][0])
    ck("CE8 sui dati VERI del 12/10, controprova: l'ancora R2SANC ha il report, 'last test passed' presente 2,96-3,98 s dopo la fine del test (F2)",
       da["classe"] == "report scritto" and da["last"] and 2.9 <= da["last_s"] - da["test_s"] <= 4.0, ce8_testo(da)[:160])
    m15_righe = [("BUY" if i % 2 else "SELL", False, "spread oltre il limite", 9.0, i % 24) for i in range(600)]
    STALLO = "timeout di 45 minuti | report .htm della passata NON trovato (Report=GBA_R0_R2SXAG2_02_REPL_T1_m775800): senza report non c e misura"

    def repl_spec(log=None, **kw):
        s = dict(KOZ, righe=None, log=log or log1210, n=0, t_avvio="2026-10-12 16:31:36", durata="20")
        s.update(kw)
        return s

    def leggi(m15=None, repl=None, ancora=None, acc=None, nome="x"):
        celle = {"M15": m15 if m15 is not None else dict(KOZ, righe=m15_righe, n=0)}
        if repl is not False:
            celle["REPL"] = repl if repl is not None else repl_spec()
        pz = os.path.join(td, nome)
        os.makedirs(pz, exist_ok=True)
        pa, px = os.path.join(pz, "GBA_R0_R2SANC.zip"), os.path.join(pz, "GBA_R0_R2SXAG2.zip")
        open(pa, "wb").write(ancora if ancora is not None else anc)
        open(px, "wb").write(_zip_lotto("R2SXAG2", celle))
        lt, nt = carica([pa, px])
        cp = os.path.join(pz, "d2.csv")
        t = stampa(lt, nt, acc_ok if acc is None else acc, acc_r, cp)
        return t, open(cp, encoding="ascii").read()

    def blocco(t, cella):
        parti = t.split("-" * 110)
        for i, p in enumerate(parti):
            if p.strip().startswith("LOTTO R2SXAG2  CELLA %s " % cella):
                return parti[i + 1] if i + 1 < len(parti) else ""
        return ""

    def rif(t, cella):
        r = [x for x in blocco(t, cella).splitlines() if "ESITO DI RIFERIMENTO" in x]
        return r[0] if r else "(assente)"
    # 7c. il caso argento M1 deterministico: D2 accettato, ancora del 12/10 verde, CE7 verde -> REPL 'ESCLUSA (Modello 1)', casella 4 NON ANCORA MISURATO
    t, c = leggi(nome="det")
    ck("argento DETERMINISTICO: CE7 VERDE e CE1 del lotto (X6) VERDE", "CE7 (determinismo della REPL, tolleranza zero sulle cifre stampate): VERDE" in t
       and "CE1 del lotto R2SXAG2 (X6): VERDE" in t, [x for x in t.splitlines() if x.startswith("   CE7 (")][0][:150])
    rv = vecchie[34:35] + vecchie[36:45]
    ck("argento DETERMINISTICO: il blocco della REPL ristampa le righe del 12/10 (LETTURA r.35, r.37-45: righe, motivi, C3G cella/lati, le 6 fasce) IDENTICHE",
       all(x in blocco(t, "REPL").splitlines() for x in rv), "%d righe" % len(rv))
    ck("argento DETERMINISTICO, n = 0 col report (eccezione n = 0), (i)-(v) con S 6,65: ESITO DI RIFERIMENTO (B) 'ESCLUSA (Modello 1)'",
       "(B)" in rif(t, "REPL") and "ESCLUSA (Modello 1)" in rif(t, "REPL") and "S 6.65" in rif(t, "REPL"), rif(t, "REPL")[-110:])
    ck("argento DETERMINISTICO: CASELLA 4 (E3) resta NON ANCORA MISURATO (la conferma a tick reali non c'e'); MAI 'ESCLUSA PER COSTO' nel testo e nel CSV",
       "CASELLA 4 (E3): NON ANCORA MISURATO: ESCLUSA (Modello 1) da confermare" in blocco(t, "REPL") and "ESCLUSA PER COSTO" not in t and "ESCLUSA PER COSTO" not in c
       and "Modello 1 e tick reali" not in t)
    ck("argento DETERMINISTICO: M15 a 9,0x (n = 0 col report) -> (B) 'n insufficiente' ((iii) NO con S 6,65)", "(B)" in rif(t, "M15") and "n insufficiente" in rif(t, "M15"),
       rif(t, "M15")[:110])
    ck("ORDINE: M15 PRIMA della REPL nel testo (come nel manifest, X2), e CE7/X6 stampati PRIMA di ogni esito",
       0 < t.find("LOTTO R2SXAG2  CELLA M15 ") < t.find("LOTTO R2SXAG2  CELLA REPL ") and t.find("CE1 del lotto R2SXAG2 (X6)") < t.find("LOTTO R2SXAG2  CELLA M15 "))
    ck("intestazione del rilancio: SHA256 di D2 PER INTERO e la regola E3(3) ('conferma non data' con uno SHA diverso)",
       ("SHA256 di D2 PER INTERO: " + sha_d2()) in t and "REGOLA E3(3)" in t and "conferma non" in t and len(sha_d2()) == 64)
    ck("CE8 (descrizione): REPL e M15 con n = 0 e report scritto -> 'H-ZERO-R SMENTITA' (lettura del file prova), nessun esito cambia",
       "REPL con n = 0 e report scritto" in t and "M15 con n = 0 e report scritto -> H-ZERO-R SMENTITA" in t)
    ck("CSV del rilancio: colonne ce1_x6 e ce8 sulle due celle; lettura dello stadio A senza quelle colonne",
       c.splitlines()[0].endswith(";ce1_x6;ce8") and c.count("VERDE VERDE (ancora del 12/10") == 2 and not open(csv_a).read().splitlines()[0].endswith("ce8"))
    # 7d. CE7 ROSSA: cifre diverse dal 12/10 -> (C) per TUTTE E DUE le celle, senza appello
    i_buy = log1210.index("[GBA] segnale BUY SALTATO")
    log_lato = log1210[:i_buy] + "[GBA] segnale SELL SALTATO" + log1210[i_buy + len("[GBA] segnale BUY SALTATO"):]
    t, c = leggi(repl=repl_spec(log=log_lato), nome="ce7lato")
    ck("CE7 ROSSA: una riga BUY diventata SELL (n BUY 3363 invece di 3364) -> M15 e REPL (C) per CE1 (X6), nessuna ESCLUSA",
       "CE7 (determinismo della REPL, tolleranza zero sulle cifre stampate): ROSSA" in t and "n BUY 3363 invece di 3364" in t
       and rif(t, "M15").find("(C) NON SI LEGGE: CE1") > 0 and rif(t, "REPL").find("(C) NON SI LEGGE: CE1") > 0 and "ESCLUSA (Modello 1)" not in rif(t, "REPL"))
    righe_log = log1210.split("\r\n") if "\r\n" in log1210 else log1210.split("\n")
    sep = "\r\n" if "\r\n" in log1210 else "\n"
    ultima = max(i for i, x in enumerate(righe_log) if "[GBA] segnale " in x)
    log_meno = sep.join(righe_log[:ultima] + righe_log[ultima + 1:]).replace("| segnali 6611 |", "| segnali 6610 |").replace("SPREAD 6611 (", "SPREAD 6610 (")
    t, c = leggi(repl=repl_spec(log=log_meno), nome="ce7meno")
    ck("CE7 ROSSA: una riga segnale in meno (6610, EA coerente 6610/0/6610) -> (C) per tutte e due le celle", "ROSSA" in t and "righe segnale 6610 invece di 6611" in t
       and "(C)" in rif(t, "M15") and "(C)" in rif(t, "REPL"))
    # 7e. CE7 NON VALUTABILE -> (C) per tutte e due
    t, c = leggi(repl={"righe": [], "n": "", "stato": "NON_LANCIATA", "motivi": "tetto di 50 minuti", "senza_report": True}, nome="nonlanc")
    ck("REPL NON LANCIATA -> CE7 NON VALUTABILE -> anche la M15 e' (C) (X6)", "CE7 (determinismo della REPL, tolleranza zero sulle cifre stampate): NON VALUTABILE" in t
       and "(C) NON SI LEGGE: CE1" in rif(t, "M15"), rif(t, "M15")[:120])
    t, c = leggi(repl=False, nome="senzarepl")
    ck("REPL ASSENTE dal manifest -> CE7 NON VALUTABILE -> M15 (C)", "NON VALUTABILE" in t and "(C) NON SI LEGGE: CE1" in rif(t, "M15"))
    log_senza = sep.join(x for x in righe_log if "[GBA-CONTA] FINE" not in x)
    t, c = leggi(repl=repl_spec(log=log_senza), nome="senzaconta")
    ck("giornale della REPL SENZA la riga [GBA-CONTA] FINE -> CE7 NON VALUTABILE -> (C) tutte e due", "NON VALUTABILE: il giornale della REPL non ha UNA riga" in t
       and "(C)" in rif(t, "M15") and "(C)" in rif(t, "REPL"))
    t, c = leggi(acc=False, nome="noacc")
    ck("D2 NON accettato (prova d'accettazione non passata) -> CE7 NON VALUTABILE -> (C) tutte e due, anche coi dati deterministici",
       "NON VALUTABILE: la prova d'accettazione di D2 NON e' passata" in t and "(C)" in rif(t, "M15") and "(C)" in rif(t, "REPL") and "ESCLUSA" not in rif(t, "REPL"))
    # 7f. X6: l'ancora deve essere QUELLA del 12/10
    t, c = leggi(ancora=zip_ancora(log_s0), nome="altraancora")
    ck("X6: ancora verde nei numeri (rifatta da S0_01) ma NON lo zip del 12/10 -> CE1 del lotto NON VERDE -> (C) tutte e due, anche con CE7 verde",
       "CE1 ancora: VERDE" in t and "CE7 (determinismo della REPL, tolleranza zero sulle cifre stampate): VERDE" in t and "NON e' GBA_R0_R2SANC.zip del 12/10" in t
       and "(C)" in rif(t, "M15") and "(C)" in rif(t, "REPL"))
    raw1 = open(ACC_R1A["zip"], "rb").read()
    log_r1 = zipfile.ZipFile(io.BytesIO(raw1)).read(_nomi(zipfile.ZipFile(io.BytesIO(raw1)))[ACC_R1A["log"]]).decode("ascii")
    t, c = leggi(ancora=zip_ancora(log_r1), nome="ancorarossa")
    ck("X6: ancora ROSSA (giornale di R1A) -> (C) tutte e due", "CE1 ancora: ROSSO" in t and "(C)" in rif(t, "M15") and "(C)" in rif(t, "REPL"))
    # 7g. lo stallo: REPL bloccata di nuovo, M15 bloccata, M15 con n >= 1, test finito tardi (CE8 = descrizione, gli esiti non cambiano)
    m15_ok = {"righe": m15_righe + [("BUY", True, "", 60.0, 15) for _i in range(3)], "n": 3}
    t, c = leggi(m15=m15_ok, repl=repl_spec(stato="KO", motivi=STALLO, n="", senza_report=True), nome="repl_stallo")
    ck("REPL BLOCCATA di nuovo (test a +13 s, niente 'last test passed', niente report), CE7 VERDE: REPL (C) per KO, M15 LETTA (X6 verde) -> (B) n 3",
       "CE1 del lotto R2SXAG2 (X6): VERDE" in t and "(C) NON SI LEGGE: passata KO (timeout di 45 minuti" in rif(t, "REPL") and "(B)" in rif(t, "M15")
       and "(n 3," in rif(t, "M15"), rif(t, "M15")[:100])
    ck("CE8: REPL bloccata 2 su 2 -> 'stallo RIPRODOTTO', 'NON si rilancia una terza volta'; M15 n >= 1 col report -> 'coerente con H-ZERO-R (NON la prova)'",
       "stallo RIPRODOTTO 2 volte su 2" in t and "NON si rilancia una terza volta" in t and "M15 con n >= 1 e report scritto, REPL bloccata -> coerente con H-ZERO-R" in t
       and "BLOCCATA DOPO IL TEST (test finito a +13 s" in blocco(t, "REPL"))
    tl = ("# TESTER CS\t0\t10:00:12.400\tTester\tfinal balance 1000000.00 EUR\r\n"
          "# TESTER CS\t0\t10:00:12.500\tTester\tXAGUSD,M15: total time from login to stop testing 0:00:00.400 (including 0:00:00.010 for history data synchronization)\r\n")
    m15_blocc = dict(stato="KO", motivi=STALLO.replace("_02_REPL", "_01_M15"), n="", senza_report=True, righe=None, log=tl + _log("XAGUSD", "M15", m15_righe))
    t, c = leggi(m15=m15_blocc, nome="m15_stallo")
    ck("M15 BLOCCATA (n = 0, final balance = deposito, tentati 0): M15 (C) per KO; REPL letta (ESCLUSA (Modello 1)); CE8 'coerente con H-ZERO-R (NON la prova)'",
       "(C) NON SI LEGGE: passata KO (timeout" in rif(t, "M15") and "ESCLUSA (Modello 1)" in rif(t, "REPL")
       and "M15 con n = 0 e bloccata (final balance = deposito" in t and "BLOCCATA DOPO IL TEST (test finito a +12 s" in blocco(t, "M15"))
    m15_rows_ing = m15_righe + [("BUY", True, "", 60.0, 15)]
    m15_blocc1 = dict(m15_blocc, log=tl.replace("1000000.00", "999990.00") + _log("XAGUSD", "M15", m15_rows_ing))
    t, c = leggi(m15=m15_blocc1, nome="m15_stallo1")
    ck("M15 BLOCCATA con 1 ingresso tentato -> CE8 'H-ZERO-R SMENTITA (lo stallo non e' legato alle zero operazioni)'; M15 (C)",
       "M15 con ingressi tentati 1 (>= 1) e bloccata -> H-ZERO-R SMENTITA" in t and "(C)" in rif(t, "M15"))
    m15_tardi = dict(m15_blocc, log=tl.replace("10:00:12", "10:05:00") + _log("XAGUSD", "M15", m15_righe))
    t, c = leggi(m15=m15_tardi, nome="m15_tardi")
    ck("M15 col test finito a +300 s -> CE8 'test finito TARDI': causa a monte del test (descrizione)", "M15: test finito TARDI" in t and "test finito TARDI (+300 s" in t)
    ck("CE8 e' sola DESCRIZIONE: con lo stesso REPL deterministico l'esito della REPL e' lo stesso con la M15 bloccata, tardi o letta",
       all("ESCLUSA (Modello 1)" in rif(leggi(m15=mm, nome="d%d" % k)[0], "REPL") for k, mm in enumerate((m15_blocc, m15_tardi, m15_ok))))
    # 7h. RIFIUTI del lotto nuovo
    rr = [("BUY" if i % 2 else "SELL", False, "spread oltre il limite", 9.0, i % 24) for i in range(50)]
    rifiuta("RIFIUTO: zip R2SXAG2 col RIEPILOGO al pin cc9bcda0 (il pin dello stadio A NON vale per il rilancio)",
            lambda: leggi_lotto("GBA_R0_R2SXAG2.zip", _zip_lotto("R2SXAG2", {"M15": dict(KOZ, righe=rr, n=0), "REPL": repl_spec()}, riepilogo=_riepilogo("R2SXAG2", pin=PIN_A))))
    rifiuta("RIFIUTO: zip R2SANC (ancora) col RIEPILOGO al pin d53493a9 (il pin del rilancio NON vale per lo stadio A)",
            lambda: leggi_lotto("GBA_R0_R2SANC.zip", _zip_lotto("R2SANC", {"REPL": {"righe": rr, "n": 0}}, riepilogo=_riepilogo("R2SANC", pin=PIN_XAG2))))
    rifiuta("RIFIUTO: zip R2SNAS col RIEPILOGO al pin d53493a9", lambda: leggi_lotto("x.zip", _zip_lotto("R2SNAS", {"M5": {"righe": rr, "n": 0}}, riepilogo=_riepilogo("R2SNAS", pin=PIN_XAG2))))
    rifiuta("RIFIUTO: manifest R2SXAG2 con la REPL PRIMA (tag R2SXAG2_01_REPL, contro X1-X2)",
            lambda: leggi_lotto("x.zip", _zip_lotto("R2SXAG2", {"REPL": repl_spec(), "M15": dict(KOZ, righe=rr, n=0)})))
    zb = _zip_lotto("R2SXAG2", {"M15": dict(KOZ, righe=rr, n=0), "REPL": repl_spec()})
    bz = io.BytesIO()
    with zipfile.ZipFile(io.BytesIO(zb)) as zi, zipfile.ZipFile(bz, "w") as zo:
        for it in zi.namelist():
            dati = zi.read(it)
            if it == "MANIFEST_R0.csv":
                rm = dati.decode("ascii").split("\r\n")
                dati = "\r\n".join([rm[0], rm[2], rm[1]]).encode("ascii")
            zo.writestr(it, dati)
    rifiuta("RIFIUTO: manifest R2SXAG2 coi tag giusti ma le righe in ordine REPL -> M15 (X2)", lambda: leggi_lotto("x.zip", bz.getvalue()))
    rifiuta("RIFIUTO: zip del lotto R2SXAG2 chiamato GBA_R0_R2SXAG.zip", lambda: leggi_lotto("GBA_R0_R2SXAG.zip", zb))
    rifiuta("RIFIUTO: zip R2SXAG2 col file prova del 12/10 (GBA_R2S_XAGUSD, non XAGUSD2)",
            lambda: leggi_lotto("x.zip", _zip_lotto("R2SXAG2", {"M15": dict(KOZ, righe=rr, n=0)}, nome_prova=LOTTI["R2SXAG2"]["prova"],
                                                     prova_bytes=open(os.path.join(QD, "prove", LOTTI["R2SXAG"]["prova"]), "rb").read())))
    pz = os.path.join(td, "rif")
    os.makedirs(pz, exist_ok=True)
    pa, px = os.path.join(pz, "GBA_R0_R2SANC.zip"), os.path.join(pz, "GBA_R0_R2SXAG2.zip")
    open(pa, "wb").write(anc)
    open(px, "wb").write(zb)

    def raccolta(nome, esiti, testo_es, lotti_dentro=("GBA_R0_R2SXAG2.zip",)):
        p = os.path.join(pz, nome)
        with zipfile.ZipFile(p, "w") as zr:
            for n in lotti_dentro:
                zr.writestr(n, zb if n == "GBA_R0_R2SXAG2.zip" else anc)
            if esiti:
                zr.writestr(esiti, testo_es)
        return p
    rx = raccolta("GBA_R2S_XAG2.zip", "ESITI_R2S_XAG2.txt", "GBA R2S XAG2 -- pin %s   pc DESKTOP-H4D7CAJ\r\nR2SXAG2 rc 3   minuti 2" % PIN_XAG2)
    lt, nt = carica([pa, rx])
    ck("raccolta GBA_R2S_XAG2.zip (con ESITI_R2S_XAG2.txt al pin d53493a9) + ancora del 12/10: letta, ESITI in nota", set(lt) == {"R2SANC", "R2SXAG2"}
       and any(x.startswith("ESITI_R2S_XAG2.txt: GBA R2S XAG2 -- pin d53493a9") for x in nt))
    rifiuta("RIFIUTO: lotto R2SXAG2 caricato DUE volte (zip del lotto + raccolta)", lambda: carica([pa, px, rx]))
    rifiuta("RIFIUTO: ancora caricata DUE volte", lambda: carica([pa, pa, px]))
    rifiuta("RIFIUTO: ESITI_R2S_XAG2.txt al pin cc9bcda0 (un ESITI di un altro pin)",
            lambda: carica([pa, raccolta("r2.zip", "ESITI_R2S_XAG2.txt", "GBA R2S XAG2 -- pin %s   pc X\r\n" % PIN_A)]))
    rifiuta("RIFIUTO: raccolta con ESITI_R2S_A.txt (pin cc9bcda0) che contiene il lotto R2SXAG2 (altro giro)",
            lambda: carica([pa, raccolta("r3.zip", "ESITI_R2S_A.txt", "GBA R2S A -- pin %s   pc X\r\n" % PIN_A)]))
    rifiuta("RIFIUTO: R2SXAG2 letto insieme a TUTTO lo stadio A (GBA_R2S_A.zip): due giri nella stessa lettura", lambda: carica([ARCH_R2S_A, px]))
    rifiuta("RIFIUTO: R2SXAG2 insieme a un lotto dello stadio A diverso dall'ancora (R2SNAS)",
            lambda: carica([pa, px, _scrivi(pz, "GBA_R0_R2SNAS.zip", zA.read(NA["GBA_R0_R2SNAS.zip"]))]))


def _scrivi(d, nome, dati):
    p = os.path.join(d, nome)
    open(p, "wb").write(dati)
    return p


def main(argv):
    if "--autotest" in argv:
        return autotest()
    csv_out = None
    args = []
    i = 0
    while i < len(argv):
        if argv[i] == "--csv-out" and i + 1 < len(argv):
            csv_out = argv[i + 1]
            i += 2
            continue
        args.append(argv[i])
        i += 1
    if not args:
        print(__doc__)
        return 2
    try:
        lotti, note = carica(args)
    except Rifiuto as ex:
        print("ERRORE -- zip RIFIUTATO, nessun numero si stampa: %s" % ex)
        return 2
    if csv_out is None:
        csv_out = "D2_C3G_R2S_XAG2.csv" if "R2SXAG2" in lotti else "D2_C3G_R2S_A.csv"
    acc_ok, acc_r = accettazione()
    print(stampa(lotti, note, acc_ok, acc_r, csv_out))
    print(" CSV: %s" % os.path.abspath(csv_out))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
