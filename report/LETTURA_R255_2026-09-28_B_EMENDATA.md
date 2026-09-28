LETTURA B -- S1 EMENDATA DOPO I NUMERI, IN ATTESA DELLA FIRMA DI CLAUDIO
  CLASSE 900: criterio cambiato A NUMERO VISTO. La S1 della testa (par. 8, congelata prima dei numeri) ha annullato 19 file su 24,
  ognuno per UNA uscita (due nel trail0 14:30) alla riapertura CME dopo un festivo USA. Questa lettura applica una S1 emendata
  scritta DOPO aver visto quei numeri: e uno strumento tarato sul caso, NON una prova indipendente. La lettura valida senza firma
  resta la A (stesso lettore senza --s1-festivi: report/LETTURA_R255_2026-09-28.md, 19 file NULLI).
  EMENDAMENTO: una uscita fuori finestra e ESENTE solo se TUTTE: (a) cade nella sessione di riapertura CME dopo una chiusura festiva
  USA ELENCATA PER NOME (t >= riapertura e stesso giorno di calendario BCM della riapertura; riapertura = 18:00 ET del festivo,
  di venerdi la domenica = 23:00 BCM stesso giorno in estate USA, 00:00 BCM del giorno dopo in inverno USA; BCM = UTC+1 fisso);
  (b) entro 1h30 dalla riapertura, oppure prima uscita del per-trade dopo la riapertura; (c) al massimo 2 esenti per per-trade
  (oltre: nessuna). Tutto il resto resta NULLO come in A. Il NULLO della riga si toglie solo se il suo UNICO motivo e S1, col
  conteggio uguale a quello del lettore e tutte le uscite esentate.
  DEVIAZIONE DICHIARATA dalla stesura del 28/09: la condizione (a) era "giorno di calendario SUCCESSIVO al festivo". Misurato: in
  estate USA la riapertura (18:00 ET) cade alle 23:00 BCM DELLO STESSO GIORNO (Juneteenth 2025.06.19 23:05, Memorial Day 2026.05.25
  23:05): alla lettera quelle due NON sarebbero esenti. La (a) qui e la sessione di riapertura, piu STRETTA di "23:00-01:30 di un
  giorno qualunque": ogni esenzione sotto riporta anche se soddisfa la stesura letterale.

LETTURA R255 -- IL LATO SHORT DELL APERTURA DOW A DUE OROLOGI (criteri: prove/R255a_short_DOW_ancora_1430.txt par. 7-17, congelati prima dei numeri)
raccolta: backtest_pipeline/risultati_archivio/ROUND_R255_SHORT_DOW_INFASE_2026-09-28
cartelle ROUND_R255a..x trovate: 24 su 24; SHA256 del pin per i file prova: 24 letti dalla riga
RIEPILOGO_R255.txt letto: 56 righe; le sue pre-letture si RILEGGONO qui sotto dai per-trade (la riga non e il verdetto)
  [riga] CARTELLE ATTESE: 24   TROVATE: 24   -> CATENA COMPLETA
  [riga] PERTRADE (Common Files, abtg_trades_ABTG_Dow_Apertura_US_U30USD_<magic>.csv, magic 793101-793124 e 793151-793174, scritti DOPO l avvio del proprio job; UNO per magic = la gamba CONTINUA 2024.09.27 -> 2026.06.30, che gira per seconda e sovrascrive il moncone, classe 455): 48 su 48
  [riga] ROUND PARTITI (rc diverso da 1): 24 su 24
  [riga] CLASSE 166 (EA e include arrivano dal RAMO lavoro, non dal pin; SHA256 dopo ogni job: ABTG_Dow_Apertura_US.mq5 + ABTG_PausaGuardian.mqh, unico include nostro dell EA; piu il file prova scaricato dal pin): MOTORE = PIN in tutti i 24 round partiti su 24
  [riga] TETTO BARRE (riga del REFERTO_ROUND, job per job; atteso MaxBars=100000000): R255w [tetto barre : MaxBars=100000000] | R255a [tetto barre : MaxBars=100000000] | R255c [tetto barre : MaxBars=100000000] | R255b [tetto barre : MaxBars=100000000] | R255d [tetto barre : MaxBars=100000000] | R255e [tetto barre : MaxBars=100000000] | R255f [tetto barre : MaxBars=100000000] | R255g [tetto barre : MaxBars=
archivio R246 per-trade 794603: 74 righe, 56 posizioni, somma 2811.84, chiusure 2024.09.30 -> 2025.06.05 (deposito 100000)
archivio R246 per-trade 794601: 130 righe, 96 posizioni, somma 6721.93, chiusure 2025.06.10 -> 2026.06.29 (deposito 100000)

1. PRE-LETTURA PER FILE (E0, P0, G1, C0, L0, S1; moncone IS; classe 772: un file KO = NULLO, la sua configurazione = NULLA)
  R255a ancora 1430  ok | Trades 146 Profit 308.41 PF 1.10790 EqDD 8.5112% Pegg -1.0584% DD_fisso 917.10 | _IS assente o 0 byte (moncone di UN giorno: vuoto ATTESO, non conta) | prova = pin (SHA256 12CFC180..., letta da raccolta); P0 154 confronti numerici/bool su 2 righe (77 pin per riga; pin stringa non confrontati: InpCorrSymbol,InpNewsFile) | tetto barre : MaxBars=100000000
  R255b ancora 1530  ok | Trades 115 Profit -781.41 PF 0.60921 EqDD 8.9400% Pegg -2.1642% DD_fisso 903.90 | _IS assente o 0 byte (moncone di UN giorno: vuoto ATTESO, non conta) | prova = pin (SHA256 08F6D0FC..., letta da raccolta); P0 154 confronti numerici/bool su 2 righe (77 pin per riga; pin stringa non confrontati: InpCorrSymbol,InpNewsFile) | tetto barre : MaxBars=100000000
  R255c nudo   1430  ok | Trades 319 Profit -454.42 PF 0.92923 EqDD 11.0611% Pegg -1.0313% DD_fisso 1124.00 | _IS assente o 0 byte (moncone di UN giorno: vuoto ATTESO, non conta) | prova = pin (SHA256 056F8C1F..., letta da raccolta); P0 154 confronti numerici/bool su 2 righe (77 pin per riga; pin stringa non confrontati: InpCorrSymbol,InpNewsFile) | tetto barre : MaxBars=100000000
  R255d nudo   1530  ok | Trades 274 Profit -635.81 PF 0.83900 EqDD 8.9748% Pegg -2.2605% DD_fisso 908.14 | _IS assente o 0 byte (moncone di UN giorno: vuoto ATTESO, non conta) | prova = pin (SHA256 E133F8A4..., letta da raccolta); P0 154 confronti numerici/bool su 2 righe (77 pin per riga; pin stringa non confrontati: InpCorrSymbol,InpNewsFile) | tetto barre : MaxBars=100000000
  R255e parz0  1430  ok | Trades 111 Profit 119.67 PF 1.04098 EqDD 8.4328% Pegg -1.0304% DD_fisso 904.26 | _IS assente o 0 byte (moncone di UN giorno: vuoto ATTESO, non conta) | prova = pin (SHA256 8B67418D..., letta da raccolta); P0 154 confronti numerici/bool su 2 righe (77 pin per riga; pin stringa non confrontati: InpCorrSymbol,InpNewsFile) | tetto barre : MaxBars=100000000
  R255f parz0  1530  ok | Trades 99 Profit -807.38 PF 0.59375 EqDD 9.0887% Pegg -2.1665% DD_fisso 918.17 | _IS assente o 0 byte (moncone di UN giorno: vuoto ATTESO, non conta) | prova = pin (SHA256 02C693E2..., letta da raccolta); P0 154 confronti numerici/bool su 2 righe (77 pin per riga; pin stringa non confrontati: InpCorrSymbol,InpNewsFile) | tetto barre : MaxBars=100000000
  R255g tp05   1430  ok | Trades 167 Profit 393.44 PF 1.16669 EqDD 8.3788% Pegg -1.0095% DD_fisso 906.25 | _IS assente o 0 byte (moncone di UN giorno: vuoto ATTESO, non conta) | prova = pin (SHA256 823D6977..., letta da raccolta); P0 154 confronti numerici/bool su 2 righe (77 pin per riga; pin stringa non confrontati: InpCorrSymbol,InpNewsFile) | tetto barre : MaxBars=100000000
  R255h tp05   1530  ok | Trades 144 Profit -447.12 PF 0.75538 EqDD 6.3719% Pegg -1.0022% DD_fisso 645.31 | _IS assente o 0 byte (moncone di UN giorno: vuoto ATTESO, non conta) | prova = pin (SHA256 E6739F72..., letta da raccolta); P0 154 confronti numerici/bool su 2 righe (77 pin per riga; pin stringa non confrontati: InpCorrSymbol,InpNewsFile) | tetto barre : MaxBars=100000000
  R255i tp15   1430  ok | Trades 140 Profit 503.22 PF 1.16792 EqDD 7.1516% Pegg -1.0581% DD_fisso 777.35 | _IS assente o 0 byte (moncone di UN giorno: vuoto ATTESO, non conta) | prova = pin (SHA256 CE34189F..., letta da raccolta); P0 154 confronti numerici/bool su 2 righe (77 pin per riga; pin stringa non confrontati: InpCorrSymbol,InpNewsFile) | tetto barre : MaxBars=100000000
  R255j tp15   1530  ok | Trades 103 Profit -801.52 PF 0.59670 EqDD 9.0261% Pegg -2.1644% DD_fisso 911.84 | _IS assente o 0 byte (moncone di UN giorno: vuoto ATTESO, non conta) | prova = pin (SHA256 82A50430..., letta da raccolta); P0 154 confronti numerici/bool su 2 righe (77 pin per riga; pin stringa non confrontati: InpCorrSymbol,InpNewsFile) | tetto barre : MaxBars=100000000
  R255k trail0 1430  NULLO: S1 per-trade 793111: 1 uscite fuori da [15:05:00, 17:30:59] NON ESENTI con la S1 emendata (prima 2025.01.10 03:26:04: 2025.01.10 03:26:04) | S1 per-trade 793161: 1 uscite fuori da [15:05:00, 17:30:59] NON ESENTI con la S1 emendata (prima 2025.01.10 03:26:04: 2025.01.10 03:26:04) | Trades 150 Profit -1332.84 PF 0.66819 EqDD 19.1049% Pegg -1.0401% DD_fisso 1984.93 | _IS assente o 0 byte (moncone di UN giorno: vuoto ATTESO, non conta) | prova = pin (SHA256 3810B934..., letta da raccolta); P0 154 confronti numerici/bool su 2 righe (77 pin per riga; pin stringa non confrontati: InpCorrSymbol,InpNewsFile) | tetto barre : MaxBars=100000000
  R255l trail0 1530  ok | Trades 117 Profit -352.82 PF 0.87331 EqDD 7.9158% Pegg -2.1787% DD_fisso 825.14 | _IS assente o 0 byte (moncone di UN giorno: vuoto ATTESO, non conta) | prova = pin (SHA256 2A4DC49F..., letta da raccolta); P0 154 confronti numerici/bool su 2 righe (77 pin per riga; pin stringa non confrontati: InpCorrSymbol,InpNewsFile) | tetto barre : MaxBars=100000000
  R255m stH4   1430  ok | Trades 159 Profit 300.75 PF 1.09876 EqDD 7.7497% Pegg -1.0307% DD_fisso 836.76 | _IS assente o 0 byte (moncone di UN giorno: vuoto ATTESO, non conta) | prova = pin (SHA256 527A7770..., letta da raccolta); P0 154 confronti numerici/bool su 2 righe (77 pin per riga; pin stringa non confrontati: InpCorrSymbol,InpNewsFile) | tetto barre : MaxBars=100000000
  R255n stH4   1530  ok | Trades 114 Profit -807.38 PF 0.58527 EqDD 9.0196% Pegg -2.2568% DD_fisso 911.34 | _IS assente o 0 byte (moncone di UN giorno: vuoto ATTESO, non conta) | prova = pin (SHA256 A3C88BA7..., letta da raccolta); P0 154 confronti numerici/bool su 2 righe (77 pin per riga; pin stringa non confrontati: InpCorrSymbol,InpNewsFile) | tetto barre : MaxBars=100000000
  R255o stH6   1430  ok | Trades 166 Profit 920.48 PF 1.29718 EqDD 5.9645% Pegg -0.9983% DD_fisso 657.79 | _IS assente o 0 byte (moncone di UN giorno: vuoto ATTESO, non conta) | prova = pin (SHA256 FDEF3900..., letta da raccolta); P0 154 confronti numerici/bool su 2 righe (77 pin per riga; pin stringa non confrontati: InpCorrSymbol,InpNewsFile) | tetto barre : MaxBars=100000000
  R255p stH6   1530  ok | Trades 108 Profit -901.28 PF 0.56932 EqDD 9.9490% Pegg -2.1724% DD_fisso 1005.24 | _IS assente o 0 byte (moncone di UN giorno: vuoto ATTESO, non conta) | prova = pin (SHA256 07D918FA..., letta da raccolta); P0 154 confronti numerici/bool su 2 righe (77 pin per riga; pin stringa non confrontati: InpCorrSymbol,InpNewsFile) | tetto barre : MaxBars=100000000
  R255q stH8   1430  ok | Trades 156 Profit 1315.26 PF 1.50267 EqDD 7.3013% Pegg -1.0343% DD_fisso 832.84 | _IS assente o 0 byte (moncone di UN giorno: vuoto ATTESO, non conta) | prova = pin (SHA256 425303C9..., letta da raccolta); P0 154 confronti numerici/bool su 2 righe (77 pin per riga; pin stringa non confrontati: InpCorrSymbol,InpNewsFile) | tetto barre : MaxBars=100000000
  R255r stH8   1530  ok | Trades 110 Profit -627.52 PF 0.66355 EqDD 8.3072% Pegg -2.3118% DD_fisso 838.29 | _IS assente o 0 byte (moncone di UN giorno: vuoto ATTESO, non conta) | prova = pin (SHA256 EAF83354..., letta da raccolta); P0 154 confronti numerici/bool su 2 righe (77 pin per riga; pin stringa non confrontati: InpCorrSymbol,InpNewsFile) | tetto barre : MaxBars=100000000
  R255s stH12  1430  ok | Trades 129 Profit 296.69 PF 1.11744 EqDD 7.7159% Pegg -1.0381% DD_fisso 822.29 | _IS assente o 0 byte (moncone di UN giorno: vuoto ATTESO, non conta) | prova = pin (SHA256 B8176CDF..., letta da raccolta); P0 154 confronti numerici/bool su 2 righe (77 pin per riga; pin stringa non confrontati: InpCorrSymbol,InpNewsFile) | tetto barre : MaxBars=100000000
  R255t stH12  1530  ok | Trades 91 Profit -485.25 PF 0.69979 EqDD 5.8740% Pegg -2.2522% DD_fisso 590.65 | _IS assente o 0 byte (moncone di UN giorno: vuoto ATTESO, non conta) | prova = pin (SHA256 88AED430..., letta da raccolta); P0 154 confronti numerici/bool su 2 righe (77 pin per riga; pin stringa non confrontati: InpCorrSymbol,InpNewsFile) | tetto barre : MaxBars=100000000
  R255u stD1   1430  ok | Trades 100 Profit -236.74 PF 0.87784 EqDD 4.4532% Pegg -1.0396% DD_fisso 452.41 | _IS assente o 0 byte (moncone di UN giorno: vuoto ATTESO, non conta) | prova = pin (SHA256 8D158CB0..., letta da raccolta); P0 154 confronti numerici/bool su 2 righe (77 pin per riga; pin stringa non confrontati: InpCorrSymbol,InpNewsFile) | tetto barre : MaxBars=100000000
  R255v stD1   1530  ok | Trades 72 Profit -357.94 PF 0.69260 EqDD 5.1682% Pegg -0.9941% DD_fisso 521.32 | _IS assente o 0 byte (moncone di UN giorno: vuoto ATTESO, non conta) | prova = pin (SHA256 22C97EAF..., letta da raccolta); P0 154 confronti numerici/bool su 2 righe (77 pin per riga; pin stringa non confrontati: InpCorrSymbol,InpNewsFile) | tetto barre : MaxBars=100000000
  R255w long   1430  ok | Trades 204 Profit 920.48 PF 1.25245 EqDD 5.5763% Pegg -1.0114% DD_fisso 566.31 | _IS assente o 0 byte (moncone di UN giorno: vuoto ATTESO, non conta) | prova = pin (SHA256 FE5897D1..., letta da raccolta); P0 154 confronti numerici/bool su 2 righe (77 pin per riga; pin stringa non confrontati: InpCorrSymbol,InpNewsFile) | tetto barre : MaxBars=100000000
  R255x long   1530  ok | Trades 177 Profit 205.32 PF 1.08895 EqDD 4.2102% Pegg -1.0826% DD_fisso 432.41 | _IS assente o 0 byte (moncone di UN giorno: vuoto ATTESO, non conta) | prova = pin (SHA256 DE3C1EE6..., letta da raccolta); P0 154 confronti numerici/bool su 2 righe (77 pin per riga; pin stringa non confrontati: InpCorrSymbol,InpNewsFile) | tetto barre : MaxBars=100000000
  FILE NULLI (ricalcolati qui UNITI a quelli della riga): R255k
  [riga] FILE NULLI (rc 1, motore diverso dal pin, prova diversa dal pin, E0 _OOS non buono, asse o P0 pin dal CSV diversi, C0 per-trade non buoni, G1, L0 o S1 falliti; escono da OGNI conteggio, classi 772/775/781): R255a (S1 KO: 2 uscite fuori 15:05:00-17:30:59 (file 14:30: il default compilato 14 qui NON spiega niente, leggere P0 e il REFERTO_ROUND, testa par. 8)) | R255c (S1 KO: 2 uscite fuori 15:05:00-17:30:59 (file 14:30: il default compilato 14 qui NON spiega niente, leggere P0 e il REFERTO_ROUND, testa par. 8)) | R255b (S1 KO: 2 uscite fuori 16:05:00-18:30:59 (ora 15 non arrivata? default compil

1-bis. S1 EMENDATA (LETTURA B): ESENZIONI PER NOME (file, magic, data, ora, festivo, condizione, P/L della posizione)
  ESENTE R255a ancora 1430 magic 793101: uscita 2025.01.10 00:25:27 dopo 2025.01.09 lutto nazionale USA (J. Carter), borse chiuse (b: entro 1h30 dalla riapertura CME 2025.01.10 00:00:00); posizione 75: 1 deal, P/L +8.35; stesura letterale: (a) giorno successivo SI, 23:00-01:30 SI
  ESENTE R255a ancora 1430 magic 793151: uscita 2025.01.10 00:25:27 dopo 2025.01.09 lutto nazionale USA (J. Carter), borse chiuse (b: entro 1h30 dalla riapertura CME 2025.01.10 00:00:00); posizione 75: 1 deal, P/L +8.35; stesura letterale: (a) giorno successivo SI, 23:00-01:30 SI
  ESENTE R255b ancora 1530 magic 793102: uscita 2025.06.19 23:05:00 dopo 2025.06.19 Juneteenth (b: entro 1h30 dalla riapertura CME 2025.06.19 23:00:00); posizione 111: 1 deal, P/L -207.27; stesura letterale: (a) giorno successivo NO, 23:00-01:30 SI
  ESENTE R255b ancora 1530 magic 793152: uscita 2025.06.19 23:05:00 dopo 2025.06.19 Juneteenth (b: entro 1h30 dalla riapertura CME 2025.06.19 23:00:00); posizione 111: 1 deal, P/L -207.27; stesura letterale: (a) giorno successivo NO, 23:00-01:30 SI
  ESENTE R255c nudo   1430 magic 793103: uscita 2025.01.10 00:25:27 dopo 2025.01.09 lutto nazionale USA (J. Carter), borse chiuse (b: entro 1h30 dalla riapertura CME 2025.01.10 00:00:00); posizione 106: 1 deal, P/L +7.52; stesura letterale: (a) giorno successivo SI, 23:00-01:30 SI
  ESENTE R255c nudo   1430 magic 793153: uscita 2025.01.10 00:25:27 dopo 2025.01.09 lutto nazionale USA (J. Carter), borse chiuse (b: entro 1h30 dalla riapertura CME 2025.01.10 00:00:00); posizione 106: 1 deal, P/L +7.52; stesura letterale: (a) giorno successivo SI, 23:00-01:30 SI
  ESENTE R255d nudo   1530 magic 793104: uscita 2025.06.19 23:05:00 dopo 2025.06.19 Juneteenth (b: entro 1h30 dalla riapertura CME 2025.06.19 23:00:00); posizione 220: 1 deal, P/L -223.22; stesura letterale: (a) giorno successivo NO, 23:00-01:30 SI
  ESENTE R255d nudo   1530 magic 793154: uscita 2025.06.19 23:05:00 dopo 2025.06.19 Juneteenth (b: entro 1h30 dalla riapertura CME 2025.06.19 23:00:00); posizione 220: 1 deal, P/L -223.22; stesura letterale: (a) giorno successivo NO, 23:00-01:30 SI
  ESENTE R255e parz0  1430 magic 793105: uscita 2025.01.10 00:25:27 dopo 2025.01.09 lutto nazionale USA (J. Carter), borse chiuse (b: entro 1h30 dalla riapertura CME 2025.01.10 00:00:00); posizione 63: 1 deal, P/L +8.35; stesura letterale: (a) giorno successivo SI, 23:00-01:30 SI
  ESENTE R255e parz0  1430 magic 793155: uscita 2025.01.10 00:25:27 dopo 2025.01.09 lutto nazionale USA (J. Carter), borse chiuse (b: entro 1h30 dalla riapertura CME 2025.01.10 00:00:00); posizione 63: 1 deal, P/L +8.35; stesura letterale: (a) giorno successivo SI, 23:00-01:30 SI
  ESENTE R255f parz0  1530 magic 793106: uscita 2025.06.19 23:05:00 dopo 2025.06.19 Juneteenth (b: entro 1h30 dalla riapertura CME 2025.06.19 23:00:00); posizione 103: 1 deal, P/L -207.27; stesura letterale: (a) giorno successivo NO, 23:00-01:30 SI
  ESENTE R255f parz0  1530 magic 793156: uscita 2025.06.19 23:05:00 dopo 2025.06.19 Juneteenth (b: entro 1h30 dalla riapertura CME 2025.06.19 23:00:00); posizione 103: 1 deal, P/L -207.27; stesura letterale: (a) giorno successivo NO, 23:00-01:30 SI
  ESENTE R255g tp05   1430 magic 793107: uscita 2025.01.10 00:25:27 dopo 2025.01.09 lutto nazionale USA (J. Carter), borse chiuse (b: entro 1h30 dalla riapertura CME 2025.01.10 00:00:00); posizione 80: 1 deal, P/L +8.35; stesura letterale: (a) giorno successivo SI, 23:00-01:30 SI
  ESENTE R255g tp05   1430 magic 793157: uscita 2025.01.10 00:25:27 dopo 2025.01.09 lutto nazionale USA (J. Carter), borse chiuse (b: entro 1h30 dalla riapertura CME 2025.01.10 00:00:00); posizione 80: 1 deal, P/L +8.35; stesura letterale: (a) giorno successivo SI, 23:00-01:30 SI
  ESENTE R255i tp15   1430 magic 793109: uscita 2025.01.10 00:25:27 dopo 2025.01.09 lutto nazionale USA (J. Carter), borse chiuse (b: entro 1h30 dalla riapertura CME 2025.01.10 00:00:00); posizione 73: 1 deal, P/L +8.35; stesura letterale: (a) giorno successivo SI, 23:00-01:30 SI
  ESENTE R255i tp15   1430 magic 793159: uscita 2025.01.10 00:25:27 dopo 2025.01.09 lutto nazionale USA (J. Carter), borse chiuse (b: entro 1h30 dalla riapertura CME 2025.01.10 00:00:00); posizione 73: 1 deal, P/L +8.35; stesura letterale: (a) giorno successivo SI, 23:00-01:30 SI
  ESENTE R255j tp15   1530 magic 793110: uscita 2025.06.19 23:05:00 dopo 2025.06.19 Juneteenth (b: entro 1h30 dalla riapertura CME 2025.06.19 23:00:00); posizione 106: 1 deal, P/L -207.27; stesura letterale: (a) giorno successivo NO, 23:00-01:30 SI
  ESENTE R255j tp15   1530 magic 793160: uscita 2025.06.19 23:05:00 dopo 2025.06.19 Juneteenth (b: entro 1h30 dalla riapertura CME 2025.06.19 23:00:00); posizione 106: 1 deal, P/L -207.27; stesura letterale: (a) giorno successivo NO, 23:00-01:30 SI
  ESENTE R255k trail0 1430 magic 793111: uscita 2025.01.10 01:19:52 dopo 2025.01.09 lutto nazionale USA (J. Carter), borse chiuse (b: entro 1h30 dalla riapertura CME 2025.01.10 00:00:00); posizione 75: 2 deal, P/L +39.18; stesura letterale: (a) giorno successivo SI, 23:00-01:30 SI
  ESENTE R255k trail0 1430 magic 793161: uscita 2025.01.10 01:19:52 dopo 2025.01.09 lutto nazionale USA (J. Carter), borse chiuse (b: entro 1h30 dalla riapertura CME 2025.01.10 00:00:00); posizione 75: 2 deal, P/L +39.18; stesura letterale: (a) giorno successivo SI, 23:00-01:30 SI
  ESENTE R255l trail0 1530 magic 793112: uscita 2025.06.19 23:05:00 dopo 2025.06.19 Juneteenth (b: entro 1h30 dalla riapertura CME 2025.06.19 23:00:00); posizione 115: 1 deal, P/L -223.22; stesura letterale: (a) giorno successivo NO, 23:00-01:30 SI
  ESENTE R255l trail0 1530 magic 793162: uscita 2025.06.19 23:05:00 dopo 2025.06.19 Juneteenth (b: entro 1h30 dalla riapertura CME 2025.06.19 23:00:00); posizione 115: 1 deal, P/L -223.22; stesura letterale: (a) giorno successivo NO, 23:00-01:30 SI
  ESENTE R255m stH4   1430 magic 793113: uscita 2025.01.10 00:25:27 dopo 2025.01.09 lutto nazionale USA (J. Carter), borse chiuse (b: entro 1h30 dalla riapertura CME 2025.01.10 00:00:00); posizione 58: 1 deal, P/L +8.35; stesura letterale: (a) giorno successivo SI, 23:00-01:30 SI
  ESENTE R255m stH4   1430 magic 793163: uscita 2025.01.10 00:25:27 dopo 2025.01.09 lutto nazionale USA (J. Carter), borse chiuse (b: entro 1h30 dalla riapertura CME 2025.01.10 00:00:00); posizione 58: 1 deal, P/L +8.35; stesura letterale: (a) giorno successivo SI, 23:00-01:30 SI
  ESENTE R255n stH4   1530 magic 793114: uscita 2025.06.19 23:05:00 dopo 2025.06.19 Juneteenth (b: entro 1h30 dalla riapertura CME 2025.06.19 23:00:00); posizione 98: 1 deal, P/L -223.22; stesura letterale: (a) giorno successivo NO, 23:00-01:30 SI
  ESENTE R255n stH4   1530 magic 793164: uscita 2025.06.19 23:05:00 dopo 2025.06.19 Juneteenth (b: entro 1h30 dalla riapertura CME 2025.06.19 23:00:00); posizione 98: 1 deal, P/L -223.22; stesura letterale: (a) giorno successivo NO, 23:00-01:30 SI
  ESENTE R255p stH6   1530 magic 793116: uscita 2025.06.19 23:05:00 dopo 2025.06.19 Juneteenth (b: entro 1h30 dalla riapertura CME 2025.06.19 23:00:00); posizione 109: 1 deal, P/L -207.27; stesura letterale: (a) giorno successivo NO, 23:00-01:30 SI
  ESENTE R255p stH6   1530 magic 793166: uscita 2025.06.19 23:05:00 dopo 2025.06.19 Juneteenth (b: entro 1h30 dalla riapertura CME 2025.06.19 23:00:00); posizione 109: 1 deal, P/L -207.27; stesura letterale: (a) giorno successivo NO, 23:00-01:30 SI
  ESENTE R255q stH8   1430 magic 793117: uscita 2025.01.10 00:25:27 dopo 2025.01.09 lutto nazionale USA (J. Carter), borse chiuse (b: entro 1h30 dalla riapertura CME 2025.01.10 00:00:00); posizione 65: 1 deal, P/L +8.35; stesura letterale: (a) giorno successivo SI, 23:00-01:30 SI
  ESENTE R255q stH8   1430 magic 793167: uscita 2025.01.10 00:25:27 dopo 2025.01.09 lutto nazionale USA (J. Carter), borse chiuse (b: entro 1h30 dalla riapertura CME 2025.01.10 00:00:00); posizione 65: 1 deal, P/L +8.35; stesura letterale: (a) giorno successivo SI, 23:00-01:30 SI
  ESENTE R255r stH8   1530 magic 793118: uscita 2025.06.19 23:05:00 dopo 2025.06.19 Juneteenth (b: entro 1h30 dalla riapertura CME 2025.06.19 23:00:00); posizione 106: 1 deal, P/L -223.22; stesura letterale: (a) giorno successivo NO, 23:00-01:30 SI
  ESENTE R255r stH8   1530 magic 793168: uscita 2025.06.19 23:05:00 dopo 2025.06.19 Juneteenth (b: entro 1h30 dalla riapertura CME 2025.06.19 23:00:00); posizione 106: 1 deal, P/L -223.22; stesura letterale: (a) giorno successivo NO, 23:00-01:30 SI
  ESENTE R255t stH12  1530 magic 793120: uscita 2025.06.19 23:05:00 dopo 2025.06.19 Juneteenth (b: entro 1h30 dalla riapertura CME 2025.06.19 23:00:00); posizione 93: 1 deal, P/L -223.22; stesura letterale: (a) giorno successivo NO, 23:00-01:30 SI
  ESENTE R255t stH12  1530 magic 793170: uscita 2025.06.19 23:05:00 dopo 2025.06.19 Juneteenth (b: entro 1h30 dalla riapertura CME 2025.06.19 23:00:00); posizione 93: 1 deal, P/L -223.22; stesura letterale: (a) giorno successivo NO, 23:00-01:30 SI
  ESENTE R255u stD1   1430 magic 793121: uscita 2025.01.10 00:25:27 dopo 2025.01.09 lutto nazionale USA (J. Carter), borse chiuse (b: entro 1h30 dalla riapertura CME 2025.01.10 00:00:00); posizione 54: 1 deal, P/L +8.35; stesura letterale: (a) giorno successivo SI, 23:00-01:30 SI
  ESENTE R255u stD1   1430 magic 793171: uscita 2025.01.10 00:25:27 dopo 2025.01.09 lutto nazionale USA (J. Carter), borse chiuse (b: entro 1h30 dalla riapertura CME 2025.01.10 00:00:00); posizione 54: 1 deal, P/L +8.35; stesura letterale: (a) giorno successivo SI, 23:00-01:30 SI
  ESENTE R255x long   1530 magic 793124: uscita 2026.05.25 23:05:00 dopo 2026.05.25 Memorial Day (b: entro 1h30 dalla riapertura CME 2026.05.25 23:00:00); posizione 311: 1 deal, P/L -72.17; stesura letterale: (a) giorno successivo NO, 23:00-01:30 SI
  ESENTE R255x long   1530 magic 793174: uscita 2026.05.25 23:05:00 dopo 2026.05.25 Memorial Day (b: entro 1h30 dalla riapertura CME 2026.05.25 23:00:00); posizione 311: 1 deal, P/L -72.17; stesura letterale: (a) giorno successivo NO, 23:00-01:30 SI
  uscite esentate: 38; file che restano NULLI per S1 anche con l emendamento: R255k
    R255k: S1 per-trade 793111: 1 uscite fuori da [15:05:00, 17:30:59] NON ESENTI con la S1 emendata (prima 2025.01.10 03:26:04: 2025.01.10 03:26:04) | S1 per-trade 793161: 1 uscite fuori da [15:05:00, 17:30:59] NON ESENTI con la S1 emendata (prima 2025.01.10 03:26:04: 2025.01.10 03:26:04)
  NULLI DELLA RIGA TOLTI (unico motivo S1, conteggio uguale, tutte esentate): R255a, R255b, R255c, R255d, R255e, R255f, R255g, R255i, R255j, R255l, R255m, R255n, R255p, R255q, R255r, R255t, R255u, R255x
  festivo in elenco 2025.01.09 lutto nazionale USA (J. Carter), borse chiuse: riapertura CME 2025.01.10 00:00:00 BCM -> osservato: 18 uscite esentate
  festivo in elenco 2025.06.19 Juneteenth: riapertura CME 2025.06.19 23:00:00 BCM -> osservato: 18 uscite esentate
  festivo in elenco 2026.05.25 Memorial Day: riapertura CME 2026.05.25 23:00:00 BCM -> osservato: 2 uscite esentate
  festivo previsto 2024.11.28 Thanksgiving (riapertura CME 2024.11.29 00:00:00 BCM): previsto, non osservato
  festivo previsto 2024.12.25 Natale (riapertura CME 2024.12.26 00:00:00 BCM): previsto, non osservato
  festivo previsto 2025.01.01 Capodanno (riapertura CME 2025.01.02 00:00:00 BCM): previsto, non osservato
  festivo previsto 2025.01.20 Martin Luther King Day (riapertura CME 2025.01.21 00:00:00 BCM): previsto, non osservato
  festivo previsto 2025.02.17 Presidents Day (riapertura CME 2025.02.18 00:00:00 BCM): previsto, non osservato
  festivo previsto 2025.04.18 Venerdi Santo (riapertura CME 2025.04.20 23:00:00 BCM): previsto, non osservato
  festivo previsto 2025.05.26 Memorial Day (riapertura CME 2025.05.26 23:00:00 BCM): previsto, non osservato
  festivo previsto 2025.07.04 Independence Day (riapertura CME 2025.07.06 23:00:00 BCM): previsto, non osservato
  festivo previsto 2025.09.01 Labor Day (riapertura CME 2025.09.01 23:00:00 BCM): previsto, non osservato
  festivo previsto 2025.11.27 Thanksgiving (riapertura CME 2025.11.28 00:00:00 BCM): previsto, non osservato
  festivo previsto 2025.12.25 Natale (riapertura CME 2025.12.26 00:00:00 BCM): previsto, non osservato
  festivo previsto 2026.01.01 Capodanno (riapertura CME 2026.01.02 00:00:00 BCM): previsto, non osservato
  festivo previsto 2026.01.19 Martin Luther King Day (riapertura CME 2026.01.20 00:00:00 BCM): previsto, non osservato
  festivo previsto 2026.02.16 Presidents Day (riapertura CME 2026.02.17 00:00:00 BCM): previsto, non osservato
  festivo previsto 2026.04.03 Venerdi Santo (riapertura CME 2026.04.05 23:00:00 BCM): previsto, non osservato
  festivo previsto 2026.06.19 Juneteenth (riapertura CME 2026.06.21 23:00:00 BCM): previsto, non osservato
  CONTRO-ESEMPIO DELLA B: "pin dell ora non arrivato" (corsa a ora 14 nel file 15:30) sposta TUTTE le uscite di un ora: finirebbero prima di lo
  in giorni feriali qualunque e nessuna sarebbe esente -> NULLO anche qui (autotest). Lo misura anche G2 L OROLOGIO sotto: righe d inverno
  15:30 IDENTICHE a quelle 14:30 = l ora 15 non e arrivata. Il peso delle esenzioni nelle curve e stampato per configurazione (riga S1-B).

2. G0 E G2 (ricalcolati dai per-trade e dai CSV; accanto, quello che ha stampato la riga)
  G0-LONG R255w: era IS (<= 2025.06.09): 74 deal, 56 posizioni, somma 260.71 contro r6 74 deal / 260.71; struttura contro 794603: 74 contro 74 righe, confrontate 74, DIVERSE 0 -> VERDE | era OOS (>= 2025.06.10) contro 794601: 130 deal (96 posizioni) contro 130 (96), confrontate 130, DIVERSE 0 -> VERDE-STRUTTURA
  [riga] G0-LONG R255w (magic 793123) contro r6 e gli archivi R246 (VERDE = 74 deal, somma 260,71 entro 0,05 E struttura identica a 794603; GIALLO = 74 deal e |delta| <= 2,61; ROSSO il resto; era OOS VERDE-STRUTTURA = 130 righe identiche a 794601 in close_time, deal_type, price; ROSSO NON annulla il round: R1/R2 diventano NON CONFRONTABILI e e_IS/e_OOS illeggibili, classe 750): era IS (chiusure <= 2025.06.09): 74 deal, 56 posizioni, somma 260.71 contro r6 74 deal / 260,71 (56 posizioni); struttura contro 794603 riga per riga (close_time, deal_type, price): 74 contro 74, confrontate 74, DIVERSE 0 -> VERDE | era OOS (>= 2025.06.10) contro 794601: 130 deal (96 posizioni) contro 130 (96), confrontate 130
  G0-ANCORA R255a: era IS: 73 deal (54 posizioni, a 0,10 con un solo deal 0) contro R54a 73 -> VERDE-STRUTTURA | era OOS: 73 deal (57 posizioni, a 0,10 con un solo deal 0) contro R54a 73 -> VERDE-STRUTTURA | prima riga 2024.10.01 15:20:09 (Profit e DD NON si confrontano: R54a girava a 100000)
  [riga] G0-ANCORA R255a (magic 793101) contro R54a (73 deal IS e 73 OOS a meno dei deal di parziale mancanti sulle posizioni a 0,10 lotti; VERDE-STRUTTURA o ROSSO): NON VERIFICABILE (R255a NULLO)
  G0-SOTTOINSIEME (stesso orologio, per posizione, eccezione del lotto 0,10 par. 8):
    R255a in R255c: 111 pos. (146 deal) contro nudo 248 pos. (319 deal), senza gemello 0 -> VERDE-SOTTOINSIEME
    R255b in R255d: 99 pos. (115 deal) contro nudo 227 pos. (274 deal), senza gemello 0 -> VERDE-SOTTOINSIEME
    R255m in R255c: 119 pos. (159 deal) contro nudo 248 pos. (319 deal), senza gemello 0 -> VERDE-SOTTOINSIEME
    R255n in R255d: 99 pos. (114 deal) contro nudo 227 pos. (274 deal), senza gemello 0 -> VERDE-SOTTOINSIEME
    R255o in R255c: 120 pos. (166 deal) contro nudo 248 pos. (319 deal), senza gemello 0 -> VERDE-SOTTOINSIEME
    R255p in R255d: 92 pos. (108 deal) contro nudo 227 pos. (274 deal), senza gemello 0 -> VERDE-SOTTOINSIEME
    R255q in R255c: 115 pos. (156 deal) contro nudo 248 pos. (319 deal), senza gemello 0 -> VERDE-SOTTOINSIEME
    R255r in R255d: 92 pos. (110 deal) contro nudo 227 pos. (274 deal), senza gemello 0 -> VERDE-SOTTOINSIEME
    R255s in R255c: 98 pos. (129 deal) contro nudo 248 pos. (319 deal), senza gemello 0 -> VERDE-SOTTOINSIEME
    R255t in R255d: 77 pos. (91 deal) contro nudo 227 pos. (274 deal), senza gemello 0 -> VERDE-SOTTOINSIEME
    R255u in R255c: 79 pos. (100 deal) contro nudo 248 pos. (319 deal), senza gemello 0 -> VERDE-SOTTOINSIEME
    R255v in R255d: 62 pos. (72 deal) contro nudo 227 pos. (274 deal), senza gemello 0 -> VERDE-SOTTOINSIEME
  [riga] G0-SOTTOINSIEME dentro lo stesso orologio (ogni deal dell ancora e dei Supertrend ha un gemello nel NUDO dello stesso orologio con close_time, deal_type e price identici): R255a in R255c: NON VERIFICABILE (un file della coppia e NULLO, classe 781) | R255b in R255d: NON VERIFICABILE (un file della coppia e NULLO, classe 781) | R255m in R255c: NON VERIFICABILE (un file della coppia e NULLO, classe 781) | R255n in R255d: NON VERIFICABILE (un file della coppia e NULLO, classe 781) | R255o in R255c: NON VERIFICABILE (un file della coppia e NULLO, classe 781) | R255p in R255d: NON VERIFICABILE (un file della coppia e NULLO, classe 781) | R255q in R255c: NON VERIFICABILE (un file della coppia e NULLO, classe 781) | R255r in R255d: NON VERIFICABILE (un file della coppia e NULLO, classe 781) | R255s in R255c: NON VERIFICABILE (un file della coppia e NULLO, classe 781) | R255t in R255d: NON VERIFI
  G0-INGRESSI (uscite contro l ancora dello stesso orologio):
    R255e contro R255a: giornate con posizione 111 contro 111 (non in comune 0), posizioni 111 contro 111 -> ok (stessi ingressi)
    R255f contro R255b: giornate con posizione 99 contro 99 (non in comune 0), posizioni 99 contro 99 -> ok (stessi ingressi)
    R255g contro R255a: giornate con posizione 111 contro 111 (non in comune 0), posizioni 111 contro 111 -> ok (stessi ingressi)
    R255h contro R255b: giornate con posizione 99 contro 99 (non in comune 0), posizioni 99 contro 99 -> ok (stessi ingressi)
    R255i contro R255a: giornate con posizione 111 contro 111 (non in comune 0), posizioni 111 contro 111 -> ok (stessi ingressi)
    R255j contro R255b: giornate con posizione 99 contro 99 (non in comune 0), posizioni 99 contro 99 -> ok (stessi ingressi)
    R255k contro R255a: NON VERIFICABILE (un file della coppia e NULLO, classe 781)
    R255l contro R255b: giornate con posizione 99 contro 99 (non in comune 0), posizioni 99 contro 99 -> ok (stessi ingressi)
  [riga] G0-INGRESSI (parz0, tp05, tp15, trail0: stesse giornate con posizione e stesso numero di posizioni dell ancora dello stesso orologio): R255e contro R255a: NON VERIFICABILE (un file della coppia e NULLO, classe 781) | R255f contro R255b: NON VERIFICABILE (un file della coppia e NULLO, classe 781) | R255g contro R255a: NON VERIFICABILE (un file della coppia e NULLO, classe 781) | R255h contro R255b: NON VERIFICABILE (un file della coppia e NULLO, classe 781) | R255i contro R255a: NON VERIFICABILE (un file della coppia e NULLO, classe 781) | R255j contro R255b: NON VERIFICABILE (un file della coppia e NULLO, classe 781) | R255k contro R255a: NON VERIFICABILE (un file della coppia e NULLO, classe 781) | R255l contro R255b: NON VERIFICABILE (un file della coppia e NULLO, classe 781)
  G2 LE MANOPOLE MORDONO (CSV _OOS, gemella g1):
    EMA 14:30: Trades R255a 146 contro R255c 319 -> MORDE
    Supertrend stH4 14:30: Trades R255m 159 contro R255c 319 -> MORDE
    Supertrend stH6 14:30: Trades R255o 166 contro R255c 319 -> MORDE
    Supertrend stH8 14:30: Trades R255q 156 contro R255c 319 -> MORDE
    Supertrend stH12 14:30: Trades R255s 129 contro R255c 319 -> MORDE
    Supertrend stD1 14:30: Trades R255u 100 contro R255c 319 -> MORDE
    parz0 14:30: Trades R255e 111 contro R255a 146 -> MORDE
    TP1_R 14:30: Trades tp05 167 >= ancora 146 >= tp15 140 con tp05 > tp15 -> ordine ok; Profit 393.44 / 308.41 / 503.22 -> non identici = ok
    trail0 14:30: NON VERIFICABILE (un file e NULLO)
    EMA 15:30: Trades R255b 115 contro R255d 274 -> MORDE
    Supertrend stH4 15:30: Trades R255n 114 contro R255d 274 -> MORDE
    Supertrend stH6 15:30: Trades R255p 108 contro R255d 274 -> MORDE
    Supertrend stH8 15:30: Trades R255r 110 contro R255d 274 -> MORDE
    Supertrend stH12 15:30: Trades R255t 91 contro R255d 274 -> MORDE
    Supertrend stD1 15:30: Trades R255v 72 contro R255d 274 -> MORDE
    parz0 15:30: Trades R255f 99 contro R255b 115 -> MORDE
    TP1_R 15:30: Trades tp05 144 >= ancora 115 >= tp15 103 con tp05 > tp15 -> ordine ok; Profit -447.12 / -781.41 / -801.52 -> non identici = ok
    trail0 15:30: Profit trail0 -352.82 contro ancora -781.41 -> MORDE
  G2 L OROLOGIO MORDE (righe d inverno USA 15:30 contro 14:30, per close_time/deal_type/price):
    R255a/R255b (ancora): inverno USA 14:30 95 deal, 15:30 52 deal, righe d inverno DIVERSE = ok; estate 14:30 51 deal, 15:30 63 deal (un ora DOPO la cash: descrizione)
    R255c/R255d (nudo): inverno USA 14:30 179 deal, 15:30 100 deal, righe d inverno DIVERSE = ok; estate 14:30 140 deal, 15:30 174 deal (un ora DOPO la cash: descrizione)
    R255e/R255f (parz0): inverno USA 14:30 69 deal, 15:30 44 deal, righe d inverno DIVERSE = ok; estate 14:30 42 deal, 15:30 55 deal (un ora DOPO la cash: descrizione)
    R255g/R255h (tp05): inverno USA 14:30 107 deal, 15:30 62 deal, righe d inverno DIVERSE = ok; estate 14:30 60 deal, 15:30 82 deal (un ora DOPO la cash: descrizione)
    R255i/R255j (tp15): inverno USA 14:30 92 deal, 15:30 46 deal, righe d inverno DIVERSE = ok; estate 14:30 48 deal, 15:30 57 deal (un ora DOPO la cash: descrizione)
    R255k/R255l: NON VERIFICABILE (un file della coppia e NULLO, classe 781)
    R255m/R255n (stH4): inverno USA 14:30 98 deal, 15:30 51 deal, righe d inverno DIVERSE = ok; estate 14:30 61 deal, 15:30 63 deal (un ora DOPO la cash: descrizione)
    R255o/R255p (stH6): inverno USA 14:30 121 deal, 15:30 60 deal, righe d inverno DIVERSE = ok; estate 14:30 45 deal, 15:30 48 deal (un ora DOPO la cash: descrizione)
    R255q/R255r (stH8): inverno USA 14:30 101 deal, 15:30 52 deal, righe d inverno DIVERSE = ok; estate 14:30 55 deal, 15:30 58 deal (un ora DOPO la cash: descrizione)
    R255s/R255t (stH12): inverno USA 14:30 76 deal, 15:30 35 deal, righe d inverno DIVERSE = ok; estate 14:30 53 deal, 15:30 56 deal (un ora DOPO la cash: descrizione)
    R255u/R255v (stD1): inverno USA 14:30 53 deal, 15:30 26 deal, righe d inverno DIVERSE = ok; estate 14:30 47 deal, 15:30 46 deal (un ora DOPO la cash: descrizione)
    R255w/R255x (long): inverno USA 14:30 98 deal, 15:30 46 deal, righe d inverno DIVERSE = ok; estate 14:30 106 deal, 15:30 131 deal (un ora DOPO la cash: descrizione)
  [riga] G2 LE MANOPOLE MORDONO (CSV _OOS della gamba continua, gemella g1; uguali = NON ESEGUITA, classi 31-bis e 156): EMA 14:30: NON VERIFICABILE (un file e NULLO) | Supertrend stH4 14:30: NON VERIFICABILE (un file e NULLO) | Supertrend stH6 14:30: NON VERIFICABILE (un file e NULLO) | Supertrend stH8 14:30: NON VERIFICABILE (un file e NULLO) | Supertrend stH12 14:30: NON VERIFICABILE (un file e NULLO) | Supertrend stD1 14:30: NON VERIFICABILE (un file e NULLO) | parz0 14:30: NON VERIFICABILE (un file e NULLO) | TP1_R 14:30: NON VERIFICABILE (un file e NULLO) | trail0 14:30: NON VERIFICABILE (un file e NULLO) | EMA 15:30: NON VERIFICABILE (un file e NULLO) | Supertrend stH4 15:30: NON VERIFICABILE (un file e NULLO) | Supertrend stH6 15:30: NON VERIFICABILE (un file e NULLO) | Supertrend stH8 15:30: NON VERIFICABILE (un file e NULLO) | Supertrend stH12 15:30: NON VERIFICABILE (un file e NULLO) |
  [riga] G2 L OROLOGIO MORDE (righe d inverno USA del file 15:30 NON identiche a quelle del file 14:30; inverno USA = 2024.11.03 <= d < 2025.03.09 e 2025.11.02 <= d < 2026.03.08, per data di chiusura, testa par. 6): R255a/R255b: NON VERIFICABILE (un file della coppia e NULLO, classe 781) | R255c/R255d: NON VERIFICABILE (un file della coppia e NULLO, classe 781) | R255e/R255f: NON VERIFICABILE (un file della coppia e NULLO, classe 781) | R255g/R255h: NON VERIFICABILE (un file della coppia e NULLO, classe 781) | R255i/R255j: NON VERIFICABILE (un file della coppia e NULLO, classe 781) | R255k/R255l: NON VERIFICABILE (un file della coppia e NULLO, classe 781) | R255m/R255n: NON VERIFICABILE (un file della coppia e NULLO, classe 781) | R255o/R255p: NON VERIFICABILE (un file della coppia e NULLO, classe 781) | R255q/R255r: NON VERIFICABILE (un file della coppia e NULLO, classe 781) | R255s/R255t: NON V

3. IL MARGINE D ERRORE DELLA RICOMPOSIZIONE (par. 7, classe 800): e_IS = |4.6123 - 4.6935| / 4.6935 = 0.0173 (R255w era IS contro 794603, DD metodo A %); e_OOS = |4.1639 - 4.2716| / 4.2716 = 0.0252 (contro 794601); e_eff = max(e_IS, e_OOS, 0.1266) = 0.1266
   DD_fisso (|Profit/RF|) del CSV _OOS di R255w (long, gamba continua, banco 10000): 566.31 EUR

4. LE TRE CURVE PER CONFIGURAZIONE (par. 7), per era; IN FASE decide, CONTROLLO = BCM a ora fissa, FTMO-DOC descrittiva
   tetti (par. 9, a saldo chiuso, denominatore 10000 fisso per il DD; saldo di inizio giornata per la giornata): R1 IS <= 4.694%, R2 OOS <= 4.272%, R3 >= -1.10%; e_eff 0.1266

=== ANCORA  (R255a 14:30 / R255b 15:30)
  IN FASE (posizioni 86):
   era IS  estate 16 + inverno 24 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2025.03.10 +5.01
  A ribas.  40 pos ( 50 deal) Profit   -168.18  PF pos 0.771 / deal 0.771  EP   -4.20  vinte 29  DD chiuso  376.36 EUR =  3.764%  pegg. giorno -0.922% (2025.02.19)  serie 2  scarto saldo max 7.93%
  B denaro  40 pos ( 50 deal) Profit   -164.89  PF pos 0.779 / deal 0.779  EP   -4.12  vinte 29  DD chiuso  374.26 EUR =  3.743%  pegg. giorno -0.961% (2025.03.21)  serie 2  scarto saldo max 7.95%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 7.95%
   era OOS estate 26 + inverno 20 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2026.03.09 +3.89
  A ribas.  46 pos ( 53 deal) Profit   -157.49  PF pos 0.775 / deal 0.775  EP   -3.42  vinte 32  DD chiuso  512.67 EUR =  5.127%  pegg. giorno -0.926% (2025.08.06)  serie 3  scarto saldo max 6.12%
  B denaro  46 pos ( 53 deal) Profit   -173.40  PF pos 0.760 / deal 0.760  EP   -3.77  vinte 32  DD chiuso  530.57 EUR =  5.306%  pegg. giorno -0.982% (2025.08.06)  serie 3  scarto saldo max 6.22%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 8.04%
  CONTROLLO (posizioni 111):
   era IS  estate 16 + inverno 38 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2024.11.04 +39.29, 2025.03.10 +5.01
  A ribas.  54 pos ( 73 deal) Profit    611.65  PF pos 1.507 / deal 1.507  EP  +11.33  vinte 41  DD chiuso  259.55 EUR =  2.596%  pegg. giorno -1.058% (2024.12.24)  serie 2  scarto saldo max 0.00%
  B denaro  54 pos ( 73 deal) Profit    611.65  PF pos 1.507 / deal 1.507  EP  +11.33  vinte 41  DD chiuso  259.55 EUR =  2.596%  pegg. giorno -1.058% (2024.12.24)  serie 2  scarto saldo max 0.00%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 0.00%
   era OOS estate 26 + inverno 31 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2026.03.09 +3.89
  A ribas.  57 pos ( 73 deal) Profit   -285.76  PF pos 0.816 / deal 0.816  EP   -5.01  vinte 36  DD chiuso  838.33 EUR =  8.383%  pegg. giorno -1.015% (2026.01.20)  serie 3  scarto saldo max 6.12%
  B denaro  57 pos ( 73 deal) Profit   -303.24  PF pos 0.816 / deal 0.816  EP   -5.32  vinte 36  DD chiuso  889.61 EUR =  8.896%  pegg. giorno -1.080% (2026.01.20)  serie 3  scarto saldo max 6.61%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 0.00%
  FTMO-DOC (posizioni 89):
   era IS  estate 21 + inverno 24 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2025.03.10 +0.61
  A ribas.  45 pos ( 54 deal) Profit   -405.54  PF pos 0.581 / deal 0.581  EP   -9.01  vinte 31  DD chiuso  612.73 EUR =  6.127%  pegg. giorno -0.983% (2025.03.19)  serie 2  scarto saldo max 10.60%
  B denaro  45 pos ( 54 deal) Profit   -397.31  PF pos 0.592 / deal 0.592  EP   -8.83  vinte 31  DD chiuso  610.80 EUR =  6.108%  pegg. giorno -0.979% (2025.03.19)  serie 2  scarto saldo max 10.58%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 10.60%
   era OOS estate 24 + inverno 20 posizioni; sedute di confine (classe 805, RESTANO nella curva): nessuna con posizione
  A ribas.  44 pos ( 50 deal) Profit   -412.93  PF pos 0.513 / deal 0.513  EP   -9.38  vinte 28  DD chiuso  541.16 EUR =  5.412%  pegg. giorno -0.983% (2026.03.12)  serie 3  scarto saldo max 7.52%
  B denaro  44 pos ( 50 deal) Profit   -430.07  PF pos 0.503 / deal 0.503  EP   -9.77  vinte 28  DD chiuso  566.15 EUR =  5.661%  pegg. giorno -0.982% (2025.08.06)  serie 3  scarto saldo max 7.71%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 12.37%
  S1-B posizioni ESENTATE dentro le curve (gemella g1): IN FASE 0 (nessuna); CONTROLLO 1 (R255a era IS 2025.01.10 P/L +8.35); FTMO-DOC 0 (nessuna) [esentate nei file: R255a 1, R255b 1]
  S1-B COMPOSIZIONE IN FASE, R255a 1430 (ESTATE USA PRESO nella curva che decide, l altra stagione fuori): IS PRESA n 16 P/L +142.23 PF 1.759 | IS fuori n 38 P/L +469.42 PF 1.461 | OOS PRESA n 26 P/L -228.13 PF 0.582 | OOS fuori n 31 P/L -75.11 PF 0.932
  S1-B COMPOSIZIONE IN FASE, R255b 1530 (INVERNO USA PRESO nella curva che decide, l altra stagione fuori): IS PRESA n 24 P/L -307.12 PF 0.451 | IS fuori n 23 P/L -133.87 PF 0.685 | OOS PRESA n 20 P/L +54.73 PF 1.307 | OOS fuori n 32 P/L -395.15 PF 0.528
  gamba intera R255a (corsa continua, denaro): 111 pos, 146 deal, Profit 308.41, DD chiuso 889.61 EUR (8.896%), pegg -1.058%, serie 3 | CSV: EqDD 8.5112%, DD_fisso 917.10 -> k = 1.0309, Pegg CSV -1.0584%
    descrittivo (par. 12, NON cancello): valore del punto dal per-trade (posizioni a 2 deal, ingresso eliminato) n 35, mediana 0.907 EUR/pt/lotto (min 0.843 max 0.970); stop pieno mediano 70.8 (n 34; in EUR/lotto, cambio EURUSD dentro: classe 823)
  gamba intera R255b (corsa continua, denaro): 99 pos, 115 deal, Profit -781.41, DD chiuso 897.38 EUR (8.974%), pegg -2.164%, serie 2 | CSV: EqDD 8.9400%, DD_fisso 903.90 -> k = 1.0073, Pegg CSV -2.1642%
    descrittivo (par. 12, NON cancello): valore del punto dal per-trade (posizioni a 2 deal, ingresso eliminato) n 16, mediana 0.870 EUR/pt/lotto (min 0.843 max 0.967); stop pieno mediano 123.0 (n 31; in EUR/lotto, cambio EURUSD dentro: classe 823)
  RISCALDAMENTO classe 834 (ancora, primi 9 feriali dal 2024.09.27 SENZA filtro maturo): R255a: 2 posizioni, P/L +59.11 (2024.10.01 +0.38, 2024.10.04 +58.73)
  RISCALDAMENTO classe 834 (ancora, primi 9 feriali dal 2024.09.27 SENZA filtro maturo): R255b: 4 posizioni, P/L +7.06 (2024.09.30 +0.24, 2024.10.02 -9.70, 2024.10.03 +8.16, 2024.10.07 +8.36)
  R3-A (CSV _OOS Peggior Giornata %): -1.0584 / -2.1642 -> NON sufficiente: R3 solo dalla curva
  R1 DD chiuso era IS: A 3.764% / B 3.743% contro 4.694% con e_eff 0.1266 [min x (1-e) = 3.269, max x (1+e) = 4.240] -> NON VIOLATO su n = 40 posizioni (P che un motore senza edge lo passi: 0.55; RISCHIO PASSATO solo da n >= 60) A SALDO CHIUSO [EQUITY PEGGIO DEL LONG: DD_fisso R255a 917.10 > R255w 566.31]
  R2 DD chiuso era OOS: A 5.127% / B 5.306% contro 4.272% con e_eff 0.1266 [min x (1-e) = 4.478, max x (1+e) = 5.977] -> VIOLATO
  R3 peggior giornata (denominatore = saldo della curva a inizio giornata): A -0.922% / -0.926%, B -0.961% / -0.982% (IS / OOS)
  SERIE PERDENTE (riportata, NON cancello, classe 804): IS 2 / OOS 3 (long 770202: 3 e 3 su 56 e 96)
  sul CONTROLLO (il BCM a ora fissa, un fatto per QUELLA sedia): R1 NON VIOLATO (A 2.596 / B 2.596, n 54); R2 VIOLATO (A 8.383 / B 8.896, n 57); R3 RISPETTATO
  M1 PF OOS >= 1,10 (A e B): per posizione A 0.775 / B 0.760, sui deal A 0.775 / B 0.760 -> fallisce
  M2 vs ancora CONTROLLO: PF OOS per posizione 0.775 vs 0.816, sui deal 0.775 vs 0.816 (+0,10), EP -3.42 vs -5.01 -> fallisce
  M3 concordanza: PF IS 0.771 vs 1.507, PF OOS 0.775 vs 0.816 (per posizione; sui deal IS 0.771 vs 1.507, OOS 0.775 vs 0.816) -> fallisce
  ESITO ancora: BOCCIATA PER RISCHIO (R2; vale a qualunque n)

=== NUDO  (R255c 14:30 / R255d 15:30)
  IN FASE (posizioni 200):
   era IS  estate 38 + inverno 43 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2025.03.10 +5.01
  A ribas.  81 pos (100 deal) Profit   -380.06  PF pos 0.739 / deal 0.739  EP   -4.69  vinte 59  DD chiuso  452.78 EUR =  4.528%  pegg. giorno -0.968% (2025.05.07)  serie 3  scarto saldo max 2.84%
  B denaro  81 pos (100 deal) Profit   -384.70  PF pos 0.740 / deal 0.740  EP   -4.75  vinte 59  DD chiuso  457.81 EUR =  4.578%  pegg. giorno -0.995% (2025.05.07)  serie 3  scarto saldo max 2.90%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 2.90%
   era OOS estate 80 + inverno 39 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2025.11.03 +0.42, 2026.03.09 +2.59
  A ribas. 119 pos (140 deal) Profit   -215.48  PF pos 0.874 / deal 0.874  EP   -1.81  vinte 83  DD chiuso  639.95 EUR =  6.399%  pegg. giorno -0.986% (2025.08.08)  serie 4  scarto saldo max 2.44%
  B denaro 119 pos (140 deal) Profit   -214.22  PF pos 0.873 / deal 0.873  EP   -1.80  vinte 83  DD chiuso  631.98 EUR =  6.320%  pegg. giorno -0.975% (2025.08.08)  serie 4  scarto saldo max 2.45%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 3.03%
  CONTROLLO (posizioni 248):
   era IS  estate 38 + inverno 64 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2024.11.04 +37.42, 2025.03.10 +5.01
  A ribas. 102 pos (133 deal) Profit   -106.48  PF pos 0.961 / deal 0.961  EP   -1.04  vinte 67  DD chiuso  665.38 EUR =  6.654%  pegg. giorno -1.027% (2024.12.24)  serie 6  scarto saldo max 0.00%
  B denaro 102 pos (133 deal) Profit   -106.48  PF pos 0.961 / deal 0.961  EP   -1.04  vinte 67  DD chiuso  665.38 EUR =  6.654%  pegg. giorno -1.027% (2024.12.24)  serie 6  scarto saldo max 0.00%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 0.00%
   era OOS estate 80 + inverno 66 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2025.11.03 +127.17, 2026.03.09 +2.59
  A ribas. 146 pos (186 deal) Profit   -351.68  PF pos 0.906 / deal 0.906  EP   -2.41  vinte 92  DD chiuso  883.53 EUR =  8.835%  pegg. giorno -1.031% (2026.01.23)  serie 4  scarto saldo max 1.06%
  B denaro 146 pos (186 deal) Profit   -347.94  PF pos 0.906 / deal 0.906  EP   -2.38  vinte 92  DD chiuso  874.12 EUR =  8.741%  pegg. giorno -1.020% (2026.01.23)  serie 4  scarto saldo max 1.16%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 0.00%
  FTMO-DOC (posizioni 208):
   era IS  estate 43 + inverno 43 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2025.03.10 +0.61
  A ribas.  86 pos (105 deal) Profit   -515.97  PF pos 0.692 / deal 0.692  EP   -6.00  vinte 61  DD chiuso  614.68 EUR =  6.147%  pegg. giorno -0.980% (2025.03.19)  serie 3  scarto saldo max 4.32%
  B denaro  86 pos (105 deal) Profit   -522.81  PF pos 0.693 / deal 0.693  EP   -6.08  vinte 61  DD chiuso  618.91 EUR =  6.189%  pegg. giorno -1.009% (2025.05.07)  serie 3  scarto saldo max 4.40%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 4.40%
   era OOS estate 83 + inverno 39 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2025.11.03 +0.42
  A ribas. 122 pos (144 deal) Profit   -385.79  PF pos 0.798 / deal 0.798  EP   -3.16  vinte 84  DD chiuso  680.87 EUR =  6.809%  pegg. giorno -0.986% (2025.08.08)  serie 4  scarto saldo max 1.27%
  B denaro 122 pos (144 deal) Profit   -382.47  PF pos 0.797 / deal 0.797  EP   -3.14  vinte 84  DD chiuso  673.16 EUR =  6.732%  pegg. giorno -0.975% (2025.08.08)  serie 4  scarto saldo max 1.35%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 4.94%
  S1-B posizioni ESENTATE dentro le curve (gemella g1): IN FASE 0 (nessuna); CONTROLLO 1 (R255c era IS 2025.01.10 P/L +7.52); FTMO-DOC 0 (nessuna) [esentate nei file: R255c 1, R255d 1]
  S1-B COMPOSIZIONE IN FASE, R255c 1430 (ESTATE USA PRESO nella curva che decide, l altra stagione fuori): IS PRESA n 38 P/L -92.67 PF 0.862 | IS fuori n 64 P/L -13.81 PF 0.993 | OOS PRESA n 80 P/L -461.94 PF 0.666 | OOS fuori n 66 P/L +114.00 PF 1.050
  S1-B COMPOSIZIONE IN FASE, R255d 1530 (INVERNO USA PRESO nella curva che decide, l altra stagione fuori): IS PRESA n 43 P/L -292.03 PF 0.637 | IS fuori n 44 P/L +187.23 PF 1.296 | OOS PRESA n 39 P/L +247.72 PF 1.822 | OOS fuori n 101 P/L -778.73 PF 0.648
  gamba intera R255c (corsa continua, denaro): 248 pos, 319 deal, Profit -454.42, DD chiuso 1087.86 EUR (10.879%), pegg -1.031%, serie 6 | CSV: EqDD 11.0611%, DD_fisso 1124.00 -> k = 1.0332, Pegg CSV -1.0313%
    descrittivo (par. 12, NON cancello): valore del punto dal per-trade (posizioni a 2 deal, ingresso eliminato) n 71, mediana 0.868 EUR/pt/lotto (min 0.843 max 0.970); stop pieno mediano 68.0 (n 89; in EUR/lotto, cambio EURUSD dentro: classe 823)
  gamba intera R255d (corsa continua, denaro): 227 pos, 274 deal, Profit -635.81, DD chiuso 884.48 EUR (8.845%), pegg -2.261%, serie 3 | CSV: EqDD 8.9748%, DD_fisso 908.14 -> k = 1.0268, Pegg CSV -2.2605%
    descrittivo (par. 12, NON cancello): valore del punto dal per-trade (posizioni a 2 deal, ingresso eliminato) n 47, mediana 0.868 EUR/pt/lotto (min 0.843 max 0.966); stop pieno mediano 84.5 (n 63; in EUR/lotto, cambio EURUSD dentro: classe 823)
  R3-A (CSV _OOS Peggior Giornata %): -1.0313 / -2.2605 -> NON sufficiente: R3 solo dalla curva
  R1 DD chiuso era IS: A 4.528% / B 4.578% contro 4.694% con e_eff 0.1266 [min x (1-e) = 3.955, max x (1+e) = 5.158] -> NON RISOLTO
  R2 DD chiuso era OOS: A 6.399% / B 6.320% contro 4.272% con e_eff 0.1266 [min x (1-e) = 5.520, max x (1+e) = 7.210] -> VIOLATO
  R3 peggior giornata (denominatore = saldo della curva a inizio giornata): A -0.968% / -0.986%, B -0.995% / -0.975% (IS / OOS)
  SERIE PERDENTE (riportata, NON cancello, classe 804): IS 3 / OOS 4 (long 770202: 3 e 3 su 56 e 96)
  sul CONTROLLO (il BCM a ora fissa, un fatto per QUELLA sedia): R1 VIOLATO (A 6.654 / B 6.654, n 102); R2 VIOLATO (A 8.835 / B 8.741, n 146); R3 RISPETTATO
  M1 PF OOS >= 1,10 (A e B): per posizione A 0.874 / B 0.873, sui deal A 0.874 / B 0.873 -> fallisce
  M2 vs ancora IN FASE: PF OOS per posizione 0.874 vs 0.775, sui deal 0.874 vs 0.775 (+0,10), EP -1.81 vs -3.42 -> fallisce
  M3 concordanza: PF IS 0.739 vs 0.771, PF OOS 0.874 vs 0.775 (per posizione; sui deal IS 0.739 vs 0.771, OOS 0.874 vs 0.775) -> fallisce
  ESITO nudo: BOCCIATA PER RISCHIO (R2; vale a qualunque n)

=== PARZ0  (R255e 14:30 / R255f 15:30)
  IN FASE (posizioni 86):
   era IS  estate 16 + inverno 24 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2025.03.10 +5.01
  A ribas.  40 pos ( 40 deal) Profit   -187.78  PF pos 0.745 / deal 0.745  EP   -4.69  vinte 29  DD chiuso  378.64 EUR =  3.786%  pegg. giorno -0.924% (2025.02.19)  serie 2  scarto saldo max 7.66%
  B denaro  40 pos ( 40 deal) Profit   -185.17  PF pos 0.752 / deal 0.752  EP   -4.63  vinte 29  DD chiuso  376.03 EUR =  3.760%  pegg. giorno -0.961% (2025.03.21)  serie 2  scarto saldo max 7.67%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 7.67%
   era OOS estate 26 + inverno 20 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2026.03.09 +2.59
  A ribas.  46 pos ( 46 deal) Profit   -193.55  PF pos 0.725 / deal 0.725  EP   -4.21  vinte 32  DD chiuso  514.46 EUR =  5.145%  pegg. giorno -0.931% (2025.08.06)  serie 3  scarto saldo max 5.64%
  B denaro  46 pos ( 46 deal) Profit   -211.17  PF pos 0.708 / deal 0.708  EP   -4.59  vinte 32  DD chiuso  530.57 EUR =  5.306%  pegg. giorno -0.984% (2025.08.06)  serie 3  scarto saldo max 5.75%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 7.78%
  CONTROLLO (posizioni 111):
   era IS  estate 16 + inverno 38 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2024.11.04 +39.29, 2025.03.10 +5.01
  A ribas.  54 pos ( 54 deal) Profit    564.05  PF pos 1.469 / deal 1.469  EP  +10.45  vinte 41  DD chiuso  289.63 EUR =  2.896%  pegg. giorno -1.030% (2024.12.24)  serie 2  scarto saldo max 0.00%
  B denaro  54 pos ( 54 deal) Profit    564.05  PF pos 1.469 / deal 1.469  EP  +10.45  vinte 41  DD chiuso  289.63 EUR =  2.896%  pegg. giorno -1.030% (2024.12.24)  serie 2  scarto saldo max 0.00%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 0.00%
   era OOS estate 26 + inverno 31 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2026.03.09 +2.59
  A ribas.  57 pos ( 57 deal) Profit   -420.65  PF pos 0.741 / deal 0.741  EP   -7.38  vinte 35  DD chiuso  817.44 EUR =  8.174%  pegg. giorno -1.001% (2026.01.29)  serie 3  scarto saldo max 5.64%
  B denaro  57 pos ( 57 deal) Profit   -444.38  PF pos 0.741 / deal 0.741  EP   -7.80  vinte 35  DD chiuso  863.55 EUR =  8.635%  pegg. giorno -1.061% (2026.01.29)  serie 3  scarto saldo max 6.09%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 0.00%
  FTMO-DOC (posizioni 89):
   era IS  estate 21 + inverno 24 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2025.03.10 +0.61
  A ribas.  45 pos ( 45 deal) Profit   -429.04  PF pos 0.557 / deal 0.557  EP   -9.53  vinte 31  DD chiuso  622.79 EUR =  6.228%  pegg. giorno -0.984% (2025.03.19)  serie 2  scarto saldo max 10.38%
  B denaro  45 pos ( 45 deal) Profit   -421.89  PF pos 0.567 / deal 0.567  EP   -9.38  vinte 31  DD chiuso  620.28 EUR =  6.203%  pegg. giorno -0.980% (2025.03.19)  serie 2  scarto saldo max 10.35%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 10.38%
   era OOS estate 24 + inverno 20 posizioni; sedute di confine (classe 805, RESTANO nella curva): nessuna con posizione
  A ribas.  44 pos ( 44 deal) Profit   -443.61  PF pos 0.479 / deal 0.479  EP  -10.08  vinte 28  DD chiuso  555.97 EUR =  5.560%  pegg. giorno -0.984% (2026.03.12)  serie 3  scarto saldo max 5.89%
  B denaro  44 pos ( 44 deal) Profit   -461.07  PF pos 0.467 / deal 0.467  EP  -10.48  vinte 28  DD chiuso  579.76 EUR =  5.798%  pegg. giorno -0.984% (2025.08.06)  serie 3  scarto saldo max 6.07%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 10.96%
  S1-B posizioni ESENTATE dentro le curve (gemella g1): IN FASE 0 (nessuna); CONTROLLO 1 (R255e era IS 2025.01.10 P/L +8.35); FTMO-DOC 0 (nessuna) [esentate nei file: R255e 1, R255f 1]
  S1-B COMPOSIZIONE IN FASE, R255e 1430 (ESTATE USA PRESO nella curva che decide, l altra stagione fuori): IS PRESA n 16 P/L +131.43 PF 1.702 | IS fuori n 38 P/L +432.62 PF 1.426 | OOS PRESA n 26 P/L -275.32 PF 0.495 | OOS fuori n 31 P/L -169.06 PF 0.856
  S1-B COMPOSIZIONE IN FASE, R255f 1530 (INVERNO USA PRESO nella curva che decide, l altra stagione fuori): IS PRESA n 24 P/L -316.60 PF 0.434 | IS fuori n 23 P/L -134.37 PF 0.684 | OOS PRESA n 20 P/L +64.15 PF 1.360 | OOS fuori n 32 P/L -420.56 PF 0.491
  gamba intera R255e (corsa continua, denaro): 111 pos, 111 deal, Profit 119.67, DD chiuso 863.55 EUR (8.635%), pegg -1.030%, serie 3 | CSV: EqDD 8.4328%, DD_fisso 904.26 -> k = 1.0471, Pegg CSV -1.0304%
    descrittivo (par. 12, NON cancello): valore del punto dal per-trade (posizioni a 2 deal, ingresso eliminato) n 0; stop pieno mediano 71.1 (n 35; in EUR/lotto, cambio EURUSD dentro: classe 823)
  gamba intera R255f (corsa continua, denaro): 99 pos, 99 deal, Profit -807.38, DD chiuso 914.84 EUR (9.148%), pegg -2.166%, serie 2 | CSV: EqDD 9.0887%, DD_fisso 918.17 -> k = 1.0036, Pegg CSV -2.1665%
    descrittivo (par. 12, NON cancello): valore del punto dal per-trade (posizioni a 2 deal, ingresso eliminato) n 0; stop pieno mediano 123.0 (n 31; in EUR/lotto, cambio EURUSD dentro: classe 823)
  R3-A (CSV _OOS Peggior Giornata %): -1.0304 / -2.1665 -> NON sufficiente: R3 solo dalla curva
  R1 DD chiuso era IS: A 3.786% / B 3.760% contro 4.694% con e_eff 0.1266 [min x (1-e) = 3.284, max x (1+e) = 4.266] -> NON VIOLATO su n = 40 posizioni (P che un motore senza edge lo passi: 0.55; RISCHIO PASSATO solo da n >= 60) A SALDO CHIUSO [EQUITY PEGGIO DEL LONG: DD_fisso R255e 904.26 > R255w 566.31]
  R2 DD chiuso era OOS: A 5.145% / B 5.306% contro 4.272% con e_eff 0.1266 [min x (1-e) = 4.493, max x (1+e) = 5.977] -> VIOLATO
  R3 peggior giornata (denominatore = saldo della curva a inizio giornata): A -0.924% / -0.931%, B -0.961% / -0.984% (IS / OOS)
  SERIE PERDENTE (riportata, NON cancello, classe 804): IS 2 / OOS 3 (long 770202: 3 e 3 su 56 e 96)
  sul CONTROLLO (il BCM a ora fissa, un fatto per QUELLA sedia): R1 NON VIOLATO (A 2.896 / B 2.896, n 54); R2 VIOLATO (A 8.174 / B 8.635, n 57); R3 RISPETTATO
  M1 PF OOS >= 1,10 (A e B): per posizione A 0.725 / B 0.708, sui deal A 0.725 / B 0.708 -> fallisce
  M2 vs ancora IN FASE: PF OOS per posizione 0.725 vs 0.775, sui deal 0.725 vs 0.775 (+0,10), EP -4.21 vs -3.42, Profit -193.55 vs -157.49, DD 5.145 vs 5.127 (uscite: valgono anche Profit e DD) -> fallisce
  M3 concordanza: PF IS 0.745 vs 0.771, PF OOS 0.725 vs 0.775 (per posizione; sui deal IS 0.745 vs 0.771, OOS 0.725 vs 0.775) -> fallisce
  ESITO parz0: BOCCIATA PER RISCHIO (R2; vale a qualunque n)

=== TP05  (R255g 14:30 / R255h 15:30)
  IN FASE (posizioni 86):
   era IS  estate 16 + inverno 24 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2025.03.10 +5.01
  A ribas.  40 pos ( 60 deal) Profit   -183.47  PF pos 0.752 / deal 0.752  EP   -4.59  vinte 29  DD chiuso  361.60 EUR =  3.616%  pegg. giorno -1.002% (2025.02.19)  serie 2  scarto saldo max 8.65%
  B denaro  40 pos ( 60 deal) Profit   -182.15  PF pos 0.759 / deal 0.759  EP   -4.55  vinte 29  DD chiuso  360.74 EUR =  3.607%  pegg. giorno -1.000% (2025.02.19)  serie 2  scarto saldo max 8.67%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 8.67%
   era OOS estate 26 + inverno 20 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2026.03.09 +3.89
  A ribas.  46 pos ( 62 deal) Profit   -122.24  PF pos 0.824 / deal 0.824  EP   -2.66  vinte 32  DD chiuso  481.72 EUR =  4.817%  pegg. giorno -0.922% (2025.08.06)  serie 3  scarto saldo max 6.65%
  B denaro  46 pos ( 62 deal) Profit   -136.78  PF pos 0.811 / deal 0.811  EP   -2.97  vinte 32  DD chiuso  504.95 EUR =  5.049%  pegg. giorno -0.983% (2025.08.06)  serie 3  scarto saldo max 6.78%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 8.79%
  CONTROLLO (posizioni 111):
   era IS  estate 16 + inverno 38 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2024.11.04 +39.71, 2025.03.10 +5.01
  A ribas.  54 pos ( 85 deal) Profit    665.39  PF pos 1.832 / deal 1.825  EP  +12.32  vinte 45  DD chiuso  119.69 EUR =  1.197%  pegg. giorno -0.997% (2025.02.25)  serie 1  scarto saldo max 0.00%
  B denaro  54 pos ( 85 deal) Profit    665.39  PF pos 1.832 / deal 1.825  EP  +12.32  vinte 45  DD chiuso  119.69 EUR =  1.197%  pegg. giorno -0.997% (2025.02.25)  serie 1  scarto saldo max 0.00%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 0.00%
   era OOS estate 26 + inverno 31 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2026.03.09 +3.89
  A ribas.  57 pos ( 82 deal) Profit   -254.98  PF pos 0.825 / deal 0.825  EP   -4.47  vinte 37  DD chiuso  824.25 EUR =  8.242%  pegg. giorno -1.010% (2026.01.20)  serie 3  scarto saldo max 6.65%
  B denaro  57 pos ( 82 deal) Profit   -271.95  PF pos 0.825 / deal 0.825  EP   -4.77  vinte 37  DD chiuso  879.09 EUR =  8.791%  pegg. giorno -1.080% (2026.01.20)  serie 3  scarto saldo max 7.20%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 0.00%
  FTMO-DOC (posizioni 89):
   era IS  estate 21 + inverno 24 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2025.03.10 +0.61
  A ribas.  45 pos ( 64 deal) Profit   -394.71  PF pos 0.595 / deal 0.595  EP   -8.77  vinte 31  DD chiuso  588.74 EUR =  5.887%  pegg. giorno -1.002% (2025.02.19)  serie 2  scarto saldo max 11.04%
  B denaro  45 pos ( 64 deal) Profit   -388.98  PF pos 0.604 / deal 0.604  EP   -8.64  vinte 31  DD chiuso  587.48 EUR =  5.875%  pegg. giorno -1.000% (2025.02.19)  serie 2  scarto saldo max 11.02%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 11.04%
   era OOS estate 24 + inverno 20 posizioni; sedute di confine (classe 805, RESTANO nella curva): nessuna con posizione
  A ribas.  44 pos ( 59 deal) Profit   -375.27  PF pos 0.550 / deal 0.550  EP   -8.53  vinte 28  DD chiuso  491.04 EUR =  4.910%  pegg. giorno -0.949% (2026.03.12)  serie 3  scarto saldo max 7.99%
  B denaro  44 pos ( 59 deal) Profit   -397.41  PF pos 0.540 / deal 0.540  EP   -9.03  vinte 28  DD chiuso  520.88 EUR =  5.209%  pegg. giorno -0.983% (2025.08.06)  serie 3  scarto saldo max 8.23%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 12.79%
  S1-B posizioni ESENTATE dentro le curve (gemella g1): IN FASE 0 (nessuna); CONTROLLO 1 (R255g era IS 2025.01.10 P/L +8.35); FTMO-DOC 0 (nessuna) [esentate nei file: R255g 1, R255h 0]
  S1-B COMPOSIZIONE IN FASE, R255g 1430 (ESTATE USA PRESO nella curva che decide, l altra stagione fuori): IS PRESA n 16 P/L +112.71 PF 1.602 | IS fuori n 38 P/L +552.68 PF 1.902 | OOS PRESA n 26 P/L -211.90 PF 0.611 | OOS fuori n 31 P/L -60.05 PF 0.940
  S1-B COMPOSIZIONE IN FASE, R255h 1530 (INVERNO USA PRESO nella curva che decide, l altra stagione fuori): IS PRESA n 24 P/L -294.86 PF 0.480 | IS fuori n 23 P/L -98.11 PF 0.769 | OOS PRESA n 20 P/L +75.12 PF 1.421 | OOS fuori n 32 P/L -129.27 PF 0.803
  gamba intera R255g (corsa continua, denaro): 111 pos, 167 deal, Profit 393.44, DD chiuso 879.09 EUR (8.791%), pegg -1.010%, serie 3 | CSV: EqDD 8.3788%, DD_fisso 906.25 -> k = 1.0309, Pegg CSV -1.0095%
    descrittivo (par. 12, NON cancello): valore del punto dal per-trade (posizioni a 2 deal, ingresso eliminato) n 56, mediana 0.907 EUR/pt/lotto (min 0.800 max 0.979); stop pieno mediano 77.1 (n 29; in EUR/lotto, cambio EURUSD dentro: classe 823)
  gamba intera R255h (corsa continua, denaro): 99 pos, 144 deal, Profit -447.12, DD chiuso 643.66 EUR (6.437%), pegg -1.002%, serie 2 | CSV: EqDD 6.3719%, DD_fisso 645.31 -> k = 1.0026, Pegg CSV -1.0022%
    descrittivo (par. 12, NON cancello): valore del punto dal per-trade (posizioni a 2 deal, ingresso eliminato) n 45, mediana 0.870 EUR/pt/lotto (min 0.842 max 0.973); stop pieno mediano 122.5 (n 30; in EUR/lotto, cambio EURUSD dentro: classe 823)
  R3-A (CSV _OOS Peggior Giornata %): -1.0095 / -1.0022 -> condizione sufficiente per il SOLO metodo A
  R1 DD chiuso era IS: A 3.616% / B 3.607% contro 4.694% con e_eff 0.1266 [min x (1-e) = 3.151, max x (1+e) = 4.074] -> NON VIOLATO su n = 40 posizioni (P che un motore senza edge lo passi: 0.55; RISCHIO PASSATO solo da n >= 60) A SALDO CHIUSO [EQUITY PEGGIO DEL LONG: DD_fisso R255g 906.25 > R255w 566.31]
  R2 DD chiuso era OOS: A 4.817% / B 5.049% contro 4.272% con e_eff 0.1266 [min x (1-e) = 4.207, max x (1+e) = 5.689] -> NON RISOLTO
  R3 peggior giornata (denominatore = saldo della curva a inizio giornata): A -1.002% / -0.922%, B -1.000% / -0.983% (IS / OOS); condizione sufficiente del CSV (metodo A) soddisfatta, B calcolato e >= -1,10
  SERIE PERDENTE (riportata, NON cancello, classe 804): IS 2 / OOS 3 (long 770202: 3 e 3 su 56 e 96)
  sul CONTROLLO (il BCM a ora fissa, un fatto per QUELLA sedia): R1 NON VIOLATO (A 1.197 / B 1.197, n 54); R2 VIOLATO (A 8.242 / B 8.791, n 57); R3 RISPETTATO
  M1 PF OOS >= 1,10 (A e B): per posizione A 0.824 / B 0.811, sui deal A 0.824 / B 0.811 -> fallisce
  M2 vs ancora IN FASE: PF OOS per posizione 0.824 vs 0.775, sui deal 0.824 vs 0.775 (+0,10), EP -2.66 vs -3.42, Profit -122.24 vs -157.49, DD 4.817 vs 5.127 (uscite: valgono anche Profit e DD) -> fallisce
  M3 concordanza: PF IS 0.752 vs 0.771, PF OOS 0.824 vs 0.775 (per posizione; sui deal IS 0.752 vs 0.771, OOS 0.824 vs 0.775) -> fallisce
  ESITO tp05: RISCHIO NON RISOLTO (R2)

=== TP15  (R255i 14:30 / R255j 15:30)
  IN FASE (posizioni 86):
   era IS  estate 16 + inverno 24 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2025.03.10 +5.01
  A ribas.  40 pos ( 45 deal) Profit   -159.33  PF pos 0.788 / deal 0.788  EP   -3.98  vinte 29  DD chiuso  377.33 EUR =  3.773%  pegg. giorno -0.999% (2025.05.22)  serie 2  scarto saldo max 8.69%
  B denaro  40 pos ( 45 deal) Profit   -155.38  PF pos 0.796 / deal 0.796  EP   -3.88  vinte 29  DD chiuso  374.03 EUR =  3.740%  pegg. giorno -1.084% (2025.05.22)  serie 2  scarto saldo max 8.70%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 8.70%
   era OOS estate 26 + inverno 20 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2026.03.09 +3.89
  A ribas.  46 pos ( 49 deal) Profit   -181.76  PF pos 0.746 / deal 0.746  EP   -3.95  vinte 32  DD chiuso  509.98 EUR =  5.100%  pegg. giorno -0.918% (2025.08.06)  serie 3  scarto saldo max 6.98%
  B denaro  46 pos ( 49 deal) Profit   -201.50  PF pos 0.729 / deal 0.729  EP   -4.38  vinte 32  DD chiuso  530.57 EUR =  5.306%  pegg. giorno -0.981% (2025.08.06)  serie 3  scarto saldo max 7.19%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 8.92%
  CONTROLLO (posizioni 111):
   era IS  estate 16 + inverno 38 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2024.11.04 +39.29, 2025.03.10 +5.01
  A ribas.  54 pos ( 70 deal) Profit    695.80  PF pos 1.569 / deal 1.569  EP  +12.89  vinte 41  DD chiuso  273.92 EUR =  2.739%  pegg. giorno -1.058% (2024.12.24)  serie 2  scarto saldo max 0.00%
  B denaro  54 pos ( 70 deal) Profit    695.80  PF pos 1.569 / deal 1.569  EP  +12.89  vinte 41  DD chiuso  273.92 EUR =  2.739%  pegg. giorno -1.058% (2024.12.24)  serie 2  scarto saldo max 0.00%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 0.00%
   era OOS estate 26 + inverno 31 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2026.03.09 +3.89
  A ribas.  57 pos ( 70 deal) Profit   -180.05  PF pos 0.891 / deal 0.891  EP   -3.16  vinte 35  DD chiuso  697.69 EUR =  6.977%  pegg. giorno -0.994% (2026.02.24)  serie 3  scarto saldo max 6.96%
  B denaro  57 pos ( 70 deal) Profit   -192.58  PF pos 0.891 / deal 0.891  EP   -3.38  vinte 35  DD chiuso  746.24 EUR =  7.462%  pegg. giorno -1.064% (2026.02.24)  serie 3  scarto saldo max 7.40%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 0.00%
  FTMO-DOC (posizioni 89):
   era IS  estate 21 + inverno 24 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2025.03.10 +0.61
  A ribas.  45 pos ( 49 deal) Profit   -408.20  PF pos 0.584 / deal 0.584  EP   -9.07  vinte 31  DD chiuso  621.53 EUR =  6.215%  pegg. giorno -0.999% (2025.05.22)  serie 2  scarto saldo max 11.51%
  B denaro  45 pos ( 49 deal) Profit   -399.02  PF pos 0.596 / deal 0.596  EP   -8.87  vinte 31  DD chiuso  618.28 EUR =  6.183%  pegg. giorno -1.112% (2025.05.22)  serie 2  scarto saldo max 11.48%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 11.51%
   era OOS estate 24 + inverno 20 posizioni; sedute di confine (classe 805, RESTANO nella curva): nessuna con posizione
  A ribas.  44 pos ( 47 deal) Profit   -427.77  PF pos 0.499 / deal 0.499  EP   -9.72  vinte 28  DD chiuso  561.13 EUR =  5.611%  pegg. giorno -0.983% (2026.03.12)  serie 3  scarto saldo max 9.73%
  B denaro  44 pos ( 47 deal) Profit   -450.91  PF pos 0.485 / deal 0.485  EP  -10.25  vinte 28  DD chiuso  593.55 EUR =  5.935%  pegg. giorno -0.981% (2025.08.06)  serie 3  scarto saldo max 9.95%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 14.72%
  S1-B posizioni ESENTATE dentro le curve (gemella g1): IN FASE 0 (nessuna); CONTROLLO 1 (R255i era IS 2025.01.10 P/L +8.35); FTMO-DOC 0 (nessuna) [esentate nei file: R255i 1, R255j 1]
  S1-B COMPOSIZIONE IN FASE, R255i 1430 (ESTATE USA PRESO nella curva che decide, l altra stagione fuori): IS PRESA n 16 P/L +159.22 PF 1.786 | IS fuori n 38 P/L +536.58 PF 1.526 | OOS PRESA n 26 P/L -262.29 PF 0.536 | OOS fuori n 31 P/L +69.71 PF 1.058
  S1-B COMPOSIZIONE IN FASE, R255j 1530 (INVERNO USA PRESO nella curva che decide, l altra stagione fuori): IS PRESA n 24 P/L -314.60 PF 0.437 | IS fuori n 23 P/L -127.15 PF 0.701 | OOS PRESA n 20 P/L +60.79 PF 1.341 | OOS fuori n 32 P/L -420.56 PF 0.491
  gamba intera R255i (corsa continua, denaro): 111 pos, 140 deal, Profit 503.22, DD chiuso 746.24 EUR (7.462%), pegg -1.058%, serie 3 | CSV: EqDD 7.1516%, DD_fisso 777.35 -> k = 1.0417, Pegg CSV -1.0581%
    descrittivo (par. 12, NON cancello): valore del punto dal per-trade (posizioni a 2 deal, ingresso eliminato) n 29, mediana 0.913 EUR/pt/lotto (min 0.843 max 0.970); stop pieno mediano 71.1 (n 35; in EUR/lotto, cambio EURUSD dentro: classe 823)
  gamba intera R255j (corsa continua, denaro): 99 pos, 103 deal, Profit -801.52, DD chiuso 908.98 EUR (9.090%), pegg -2.164%, serie 2 | CSV: EqDD 9.0261%, DD_fisso 911.84 -> k = 1.0032, Pegg CSV -2.1644%
    descrittivo (par. 12, NON cancello): valore del punto dal per-trade (posizioni a 2 deal, ingresso eliminato) n 4, mediana 0.879 EUR/pt/lotto (min 0.842 max 0.955); stop pieno mediano 123.0 (n 31; in EUR/lotto, cambio EURUSD dentro: classe 823)
  R3-A (CSV _OOS Peggior Giornata %): -1.0581 / -2.1644 -> NON sufficiente: R3 solo dalla curva
  R1 DD chiuso era IS: A 3.773% / B 3.740% contro 4.694% con e_eff 0.1266 [min x (1-e) = 3.267, max x (1+e) = 4.251] -> NON VIOLATO su n = 40 posizioni (P che un motore senza edge lo passi: 0.55; RISCHIO PASSATO solo da n >= 60) A SALDO CHIUSO [EQUITY PEGGIO DEL LONG: DD_fisso R255i 777.35 > R255w 566.31]
  R2 DD chiuso era OOS: A 5.100% / B 5.306% contro 4.272% con e_eff 0.1266 [min x (1-e) = 4.454, max x (1+e) = 5.977] -> VIOLATO
  R3 peggior giornata (denominatore = saldo della curva a inizio giornata): A -0.999% / -0.918%, B -1.084% / -0.981% (IS / OOS)
  SERIE PERDENTE (riportata, NON cancello, classe 804): IS 2 / OOS 3 (long 770202: 3 e 3 su 56 e 96)
  sul CONTROLLO (il BCM a ora fissa, un fatto per QUELLA sedia): R1 NON VIOLATO (A 2.739 / B 2.739, n 54); R2 VIOLATO (A 6.977 / B 7.462, n 57); R3 RISPETTATO
  M1 PF OOS >= 1,10 (A e B): per posizione A 0.746 / B 0.729, sui deal A 0.746 / B 0.729 -> fallisce
  M2 vs ancora IN FASE: PF OOS per posizione 0.746 vs 0.775, sui deal 0.746 vs 0.775 (+0,10), EP -3.95 vs -3.42, Profit -181.76 vs -157.49, DD 5.100 vs 5.127 (uscite: valgono anche Profit e DD) -> fallisce
  M3 concordanza: PF IS 0.788 vs 0.771, PF OOS 0.746 vs 0.775 (per posizione; sui deal IS 0.788 vs 0.771, OOS 0.746 vs 0.775) -> fallisce
  ESITO tp15: BOCCIATA PER RISCHIO (R2; vale a qualunque n)

=== TRAIL0  (R255k 14:30 / R255l 15:30)  [NULLA: R255k]
  NULLA: nessuna curva (classe 772: un file che fallisce un cancello della catena non vota)

=== STH4  (R255m 14:30 / R255n 15:30)
  IN FASE (posizioni 90):
   era IS  estate 14 + inverno 23 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2025.03.10 +5.01
  A ribas.  37 pos ( 49 deal) Profit      4.52  PF pos 1.008 / deal 1.008  EP   +0.12  vinte 28  DD chiuso  228.84 EUR =  2.288%  pegg. giorno -0.936% (2024.11.13)  serie 2  scarto saldo max 5.72%
  B denaro  37 pos ( 49 deal) Profit     10.07  PF pos 1.017 / deal 1.017  EP   +0.27  vinte 28  DD chiuso  229.80 EUR =  2.298%  pegg. giorno -0.940% (2024.11.13)  serie 2  scarto saldo max 5.73%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 5.73%
   era OOS estate 34 + inverno 19 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2025.11.03 +0.42, 2026.03.09 +3.89
  A ribas.  53 pos ( 63 deal) Profit    -76.52  PF pos 0.899 / deal 0.899  EP   -1.44  vinte 38  DD chiuso  535.99 EUR =  5.360%  pegg. giorno -0.918% (2025.09.09)  serie 3  scarto saldo max 5.77%
  B denaro  53 pos ( 63 deal) Profit    -89.66  PF pos 0.886 / deal 0.886  EP   -1.69  vinte 38  DD chiuso  556.86 EUR =  5.569%  pegg. giorno -0.971% (2025.09.09)  serie 3  scarto saldo max 5.88%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 5.77%
  CONTROLLO (posizioni 119):
   era IS  estate 14 + inverno 35 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2025.03.10 +5.01
  A ribas.  49 pos ( 68 deal) Profit    576.88  PF pos 1.523 / deal 1.523  EP  +11.77  vinte 37  DD chiuso  280.86 EUR =  2.809%  pegg. giorno -1.031% (2025.02.25)  serie 2  scarto saldo max 0.00%
  B denaro  49 pos ( 68 deal) Profit    576.88  PF pos 1.523 / deal 1.523  EP  +11.77  vinte 37  DD chiuso  280.86 EUR =  2.809%  pegg. giorno -1.031% (2025.02.25)  serie 2  scarto saldo max 0.00%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 0.00%
   era OOS estate 34 + inverno 36 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2026.03.09 +3.89
  A ribas.  70 pos ( 91 deal) Profit   -261.07  PF pos 0.858 / deal 0.858  EP   -3.73  vinte 45  DD chiuso  735.01 EUR =  7.350%  pegg. giorno -1.008% (2026.01.20)  serie 3  scarto saldo max 5.77%
  B denaro  70 pos ( 91 deal) Profit   -276.13  PF pos 0.858 / deal 0.858  EP   -3.94  vinte 45  DD chiuso  777.41 EUR =  7.774%  pegg. giorno -1.068% (2026.01.20)  serie 3  scarto saldo max 6.11%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 0.00%
  FTMO-DOC (posizioni 90):
   era IS  estate 16 + inverno 23 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2025.03.10 +0.61
  A ribas.  39 pos ( 49 deal) Profit   -127.19  PF pos 0.812 / deal 0.812  EP   -3.26  vinte 29  DD chiuso  253.27 EUR =  2.533%  pegg. giorno -0.957% (2025.03.12)  serie 2  scarto saldo max 7.13%
  B denaro  39 pos ( 49 deal) Profit   -124.65  PF pos 0.820 / deal 0.820  EP   -3.20  vinte 29  DD chiuso  253.79 EUR =  2.538%  pegg. giorno -0.959% (2025.03.12)  serie 2  scarto saldo max 7.14%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 7.14%
   era OOS estate 32 + inverno 19 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2025.11.03 +0.42
  A ribas.  51 pos ( 60 deal) Profit   -307.91  PF pos 0.659 / deal 0.659  EP   -6.04  vinte 34  DD chiuso  559.33 EUR =  5.593%  pegg. giorno -0.974% (2026.03.12)  serie 3  scarto saldo max 6.28%
  B denaro  51 pos ( 60 deal) Profit   -318.74  PF pos 0.655 / deal 0.655  EP   -6.25  vinte 34  DD chiuso  584.92 EUR =  5.849%  pegg. giorno -0.971% (2025.09.09)  serie 3  scarto saldo max 6.43%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 7.83%
  S1-B posizioni ESENTATE dentro le curve (gemella g1): IN FASE 0 (nessuna); CONTROLLO 1 (R255m era IS 2025.01.10 P/L +8.35); FTMO-DOC 0 (nessuna) [esentate nei file: R255m 1, R255n 1]
  S1-B COMPOSIZIONE IN FASE, R255m 1430 (ESTATE USA PRESO nella curva che decide, l altra stagione fuori): IS PRESA n 14 P/L +177.19 PF 1.953 | IS fuori n 35 P/L +399.69 PF 1.436 | OOS PRESA n 34 P/L -164.79 PF 0.741 | OOS fuori n 36 P/L -111.34 PF 0.915
  S1-B COMPOSIZIONE IN FASE, R255n 1530 (INVERNO USA PRESO nella curva che decide, l altra stagione fuori): IS PRESA n 23 P/L -167.12 PF 0.592 | IS fuori n 16 P/L +32.81 PF 1.174 | OOS PRESA n 19 P/L +75.13 PF 1.506 | OOS fuori n 41 P/L -748.20 PF 0.377
  gamba intera R255m (corsa continua, denaro): 119 pos, 159 deal, Profit 300.75, DD chiuso 777.41 EUR (7.774%), pegg -1.031%, serie 3 | CSV: EqDD 7.7497%, DD_fisso 836.76 -> k = 1.0763, Pegg CSV -1.0307%
    descrittivo (par. 12, NON cancello): valore del punto dal per-trade (posizioni a 2 deal, ingresso eliminato) n 40, mediana 0.873 EUR/pt/lotto (min 0.843 max 0.970); stop pieno mediano 71.1 (n 37; in EUR/lotto, cambio EURUSD dentro: classe 823)
  gamba intera R255n (corsa continua, denaro): 99 pos, 114 deal, Profit -807.38, DD chiuso 911.34 EUR (9.113%), pegg -2.257%, serie 3 | CSV: EqDD 9.0196%, DD_fisso 911.34 -> k = 1.0000, Pegg CSV -2.2568%
    descrittivo (par. 12, NON cancello): valore del punto dal per-trade (posizioni a 2 deal, ingresso eliminato) n 15, mediana 0.870 EUR/pt/lotto (min 0.843 max 0.965); stop pieno mediano 111.5 (n 31; in EUR/lotto, cambio EURUSD dentro: classe 823)
  RISCALDAMENTO classe 834 (stH4, primi 3 feriali dal 2024.09.27 SENZA filtro maturo): R255m: 0 posizioni, P/L +0.00
  RISCALDAMENTO classe 834 (stH4, primi 3 feriali dal 2024.09.27 SENZA filtro maturo): R255n: 1 posizioni, P/L +0.24 (2024.09.30 +0.24)
  R3-A (CSV _OOS Peggior Giornata %): -1.0307 / -2.2568 -> NON sufficiente: R3 solo dalla curva
  R1 DD chiuso era IS: A 2.288% / B 2.298% contro 4.694% con e_eff 0.1266 [min x (1-e) = 1.999, max x (1+e) = 2.589] -> NON VIOLATO su n = 37 posizioni (P che un motore senza edge lo passi: 0.59; RISCHIO PASSATO solo da n >= 60) A SALDO CHIUSO [EQUITY PEGGIO DEL LONG: DD_fisso R255m 836.76 > R255w 566.31]
  R2 DD chiuso era OOS: A 5.360% / B 5.569% contro 4.272% con e_eff 0.1266 [min x (1-e) = 4.681, max x (1+e) = 6.274] -> VIOLATO
  R3 peggior giornata (denominatore = saldo della curva a inizio giornata): A -0.936% / -0.918%, B -0.940% / -0.971% (IS / OOS)
  SERIE PERDENTE (riportata, NON cancello, classe 804): IS 2 / OOS 3 (long 770202: 3 e 3 su 56 e 96)
  sul CONTROLLO (il BCM a ora fissa, un fatto per QUELLA sedia): R1 NON VIOLATO (A 2.809 / B 2.809, n 49); R2 VIOLATO (A 7.350 / B 7.774, n 70); R3 RISPETTATO
  M1 PF OOS >= 1,10 (A e B): per posizione A 0.899 / B 0.886, sui deal A 0.899 / B 0.886 -> fallisce
  M2 vs nudo IN FASE: PF OOS per posizione 0.899 vs 0.874, sui deal 0.899 vs 0.874 (+0,10), EP -1.44 vs -1.81 -> fallisce
  M3 concordanza: PF IS 1.008 vs 0.739, PF OOS 0.899 vs 0.874 (per posizione; sui deal IS 1.008 vs 0.739, OOS 0.899 vs 0.874) -> passa
  ESITO stH4: BOCCIATA PER RISCHIO (R2; vale a qualunque n)

=== STH6  (R255o 14:30 / R255p 15:30)
  IN FASE (posizioni 84):
   era IS  estate 14 + inverno 29 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2025.03.10 +5.01
  A ribas.  43 pos ( 55 deal) Profit   -147.62  PF pos 0.809 / deal 0.809  EP   -3.43  vinte 32  DD chiuso  462.95 EUR =  4.630%  pegg. giorno -0.965% (2025.02.17)  serie 3  scarto saldo max 7.41%
  B denaro  43 pos ( 55 deal) Profit   -135.66  PF pos 0.825 / deal 0.825  EP   -3.15  vinte 32  DD chiuso  462.74 EUR =  4.627%  pegg. giorno -0.965% (2025.02.17)  serie 3  scarto saldo max 7.41%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 7.41%
   era OOS estate 21 + inverno 20 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2025.11.03 +0.42, 2026.03.09 +3.89
  A ribas.  41 pos ( 50 deal) Profit    -62.94  PF pos 0.903 / deal 0.903  EP   -1.54  vinte 27  DD chiuso  429.69 EUR =  4.297%  pegg. giorno -0.925% (2025.08.06)  serie 3  scarto saldo max 9.90%
  B denaro  41 pos ( 50 deal) Profit    -73.14  PF pos 0.889 / deal 0.889  EP   -1.78  vinte 27  DD chiuso  428.17 EUR =  4.282%  pegg. giorno -0.979% (2025.08.06)  serie 3  scarto saldo max 10.04%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 11.56%
  CONTROLLO (posizioni 120):
   era IS  estate 14 + inverno 44 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2024.11.04 +37.42, 2025.03.10 +5.01
  A ribas.  58 pos ( 80 deal) Profit    582.82  PF pos 1.434 / deal 1.433  EP  +10.05  vinte 41  DD chiuso  338.74 EUR =  3.387%  pegg. giorno -0.995% (2025.02.11)  serie 2  scarto saldo max 0.00%
  B denaro  58 pos ( 80 deal) Profit    582.82  PF pos 1.434 / deal 1.433  EP  +10.05  vinte 41  DD chiuso  338.74 EUR =  3.387%  pegg. giorno -0.995% (2025.02.11)  serie 2  scarto saldo max 0.00%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 0.00%
   era OOS estate 21 + inverno 41 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2025.11.03 +132.03, 2026.03.09 +3.89
  A ribas.  62 pos ( 86 deal) Profit    319.06  PF pos 1.193 / deal 1.193  EP   +5.15  vinte 40  DD chiuso  538.61 EUR =  5.386%  pegg. giorno -0.998% (2025.11.25)  serie 2  scarto saldo max 5.83%
  B denaro  62 pos ( 86 deal) Profit    337.66  PF pos 1.193 / deal 1.193  EP   +5.45  vinte 40  DD chiuso  570.00 EUR =  5.700%  pegg. giorno -1.054% (2025.11.25)  serie 2  scarto saldo max 5.92%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 0.00%
  FTMO-DOC (posizioni 87):
   era IS  estate 18 + inverno 29 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2025.03.10 +0.61
  A ribas.  47 pos ( 58 deal) Profit   -376.54  PF pos 0.621 / deal 0.621  EP   -8.01  vinte 33  DD chiuso  586.66 EUR =  5.867%  pegg. giorno -0.982% (2025.03.12)  serie 3  scarto saldo max 9.97%
  B denaro  47 pos ( 58 deal) Profit   -364.94  PF pos 0.637 / deal 0.637  EP   -7.76  vinte 33  DD chiuso  587.85 EUR =  5.879%  pegg. giorno -0.984% (2025.03.12)  serie 3  scarto saldo max 9.98%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 9.98%
   era OOS estate 20 + inverno 20 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2025.11.03 +0.42
  A ribas.  40 pos ( 50 deal) Profit    -41.35  PF pos 0.937 / deal 0.937  EP   -1.03  vinte 26  DD chiuso  429.69 EUR =  4.297%  pegg. giorno -0.925% (2025.08.06)  serie 3  scarto saldo max 9.66%
  B denaro  40 pos ( 50 deal) Profit    -49.57  PF pos 0.925 / deal 0.925  EP   -1.24  vinte 26  DD chiuso  428.17 EUR =  4.282%  pegg. giorno -0.979% (2025.08.06)  serie 3  scarto saldo max 9.77%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 13.97%
  S1-B posizioni ESENTATE dentro le curve (gemella g1): IN FASE 0 (nessuna); CONTROLLO 0 (nessuna); FTMO-DOC 0 (nessuna) [esentate nei file: R255o 0, R255p 1]
  S1-B COMPOSIZIONE IN FASE, R255o 1430 (ESTATE USA PRESO nella curva che decide, l altra stagione fuori): IS PRESA n 14 P/L +232.94 PF 3.518 | IS fuori n 44 P/L +349.88 PF 1.280 | OOS PRESA n 21 P/L -106.84 PF 0.736 | OOS fuori n 41 P/L +444.50 PF 1.331
  S1-B COMPOSIZIONE IN FASE, R255p 1530 (INVERNO USA PRESO nella curva che decide, l altra stagione fuori): IS PRESA n 29 P/L -368.60 PF 0.462 | IS fuori n 15 P/L -115.89 PF 0.639 | OOS PRESA n 20 P/L +33.70 PF 1.132 | OOS fuori n 28 P/L -450.49 PF 0.459
  gamba intera R255o (corsa continua, denaro): 120 pos, 166 deal, Profit 920.48, DD chiuso 570.00 EUR (5.700%), pegg -0.998%, serie 2 | CSV: EqDD 5.9645%, DD_fisso 657.79 -> k = 1.1540, Pegg CSV -0.9983%
    descrittivo (par. 12, NON cancello): valore del punto dal per-trade (posizioni a 2 deal, ingresso eliminato) n 46, mediana 0.874 EUR/pt/lotto (min 0.843 max 0.970); stop pieno mediano 65.6 (n 39; in EUR/lotto, cambio EURUSD dentro: classe 823)
  gamba intera R255p (corsa continua, denaro): 92 pos, 108 deal, Profit -901.28, DD chiuso 1005.24 EUR (10.052%), pegg -2.172%, serie 3 | CSV: EqDD 9.9490%, DD_fisso 1005.24 -> k = 1.0000, Pegg CSV -2.1724%
    descrittivo (par. 12, NON cancello): valore del punto dal per-trade (posizioni a 2 deal, ingresso eliminato) n 16, mediana 0.897 EUR/pt/lotto (min 0.843 max 0.955); stop pieno mediano 120.1 (n 30; in EUR/lotto, cambio EURUSD dentro: classe 823)
  RISCALDAMENTO classe 834 (stH6, primi 4 feriali dal 2024.09.27 SENZA filtro maturo): R255o: 1 posizioni, P/L +0.38 (2024.10.01 +0.38)
  RISCALDAMENTO classe 834 (stH6, primi 4 feriali dal 2024.09.27 SENZA filtro maturo): R255p: 1 posizioni, P/L +0.24 (2024.09.30 +0.24)
  R3-A (CSV _OOS Peggior Giornata %): -0.9983 / -2.1724 -> NON sufficiente: R3 solo dalla curva
  R1 DD chiuso era IS: A 4.630% / B 4.627% contro 4.694% con e_eff 0.1266 [min x (1-e) = 4.042, max x (1+e) = 5.216] -> NON RISOLTO
  R2 DD chiuso era OOS: A 4.297% / B 4.282% contro 4.272% con e_eff 0.1266 [min x (1-e) = 3.740, max x (1+e) = 4.841] -> NON RISOLTO (d ufficio: scarto di saldo 10.0% > 10% e DD fra 0,8 e 1,2 volte la soglia)
  R3 peggior giornata (denominatore = saldo della curva a inizio giornata): A -0.965% / -0.925%, B -0.965% / -0.979% (IS / OOS)
  SERIE PERDENTE (riportata, NON cancello, classe 804): IS 3 / OOS 3 (long 770202: 3 e 3 su 56 e 96)
  sul CONTROLLO (il BCM a ora fissa, un fatto per QUELLA sedia): R1 NON VIOLATO (A 3.387 / B 3.387, n 58); R2 VIOLATO (A 5.386 / B 5.700, n 62); R3 RISPETTATO
  M1 PF OOS >= 1,10 (A e B): per posizione A 0.903 / B 0.889, sui deal A 0.903 / B 0.889 -> fallisce
  M2 vs nudo IN FASE: PF OOS per posizione 0.903 vs 0.874, sui deal 0.903 vs 0.874 (+0,10), EP -1.54 vs -1.81 -> fallisce
  M3 concordanza: PF IS 0.809 vs 0.739, PF OOS 0.903 vs 0.874 (per posizione; sui deal IS 0.809 vs 0.739, OOS 0.903 vs 0.874) -> passa
  ESITO stH6: RISCHIO NON RISOLTO (R1, R2)

=== STH8  (R255q 14:30 / R255r 15:30)
  IN FASE (posizioni 83):
   era IS  estate 15 + inverno 22 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2025.03.10 +5.01
  A ribas.  37 pos ( 48 deal) Profit    -18.16  PF pos 0.968 / deal 0.968  EP   -0.49  vinte 28  DD chiuso  319.26 EUR =  3.193%  pegg. giorno -0.999% (2025.05.22)  serie 2  scarto saldo max 7.95%
  B denaro  37 pos ( 48 deal) Profit     -8.99  PF pos 0.985 / deal 0.985  EP   -0.24  vinte 28  DD chiuso  318.70 EUR =  3.187%  pegg. giorno -1.077% (2025.05.22)  serie 2  scarto saldo max 7.94%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 7.95%
   era OOS estate 28 + inverno 18 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2026.03.09 +3.89
  A ribas.  46 pos ( 59 deal) Profit    512.48  PF pos 2.404 / deal 2.404  EP  +11.14  vinte 36  DD chiuso  143.22 EUR =  1.432%  pegg. giorno -0.881% (2026.01.20)  serie 2  scarto saldo max 8.51%
  B denaro  46 pos ( 59 deal) Profit    522.59  PF pos 2.425 / deal 2.425  EP  +11.36  vinte 36  DD chiuso  131.04 EUR =  1.310%  pegg. giorno -0.805% (2026.01.20)  serie 2  scarto saldo max 8.77%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 8.69%
  CONTROLLO (posizioni 115):
   era IS  estate 15 + inverno 37 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2024.11.04 +37.42, 2025.03.10 +5.01
  A ribas.  52 pos ( 70 deal) Profit    775.04  PF pos 1.761 / deal 1.760  EP  +14.90  vinte 41  DD chiuso  322.27 EUR =  3.223%  pegg. giorno -1.034% (2024.12.24)  serie 2  scarto saldo max 0.00%
  B denaro  52 pos ( 70 deal) Profit    775.04  PF pos 1.761 / deal 1.760  EP  +14.90  vinte 41  DD chiuso  322.27 EUR =  3.223%  pegg. giorno -1.034% (2024.12.24)  serie 2  scarto saldo max 0.00%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 0.00%
   era OOS estate 28 + inverno 35 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2026.03.09 +3.89
  A ribas.  63 pos ( 86 deal) Profit    501.36  PF pos 1.339 / deal 1.338  EP   +7.96  vinte 43  DD chiuso  715.47 EUR =  7.155%  pegg. giorno -0.990% (2025.12.24)  serie 6  scarto saldo max 7.75%
  B denaro  63 pos ( 86 deal) Profit    540.22  PF pos 1.339 / deal 1.338  EP   +8.57  vinte 43  DD chiuso  770.92 EUR =  7.709%  pegg. giorno -1.064% (2025.12.24)  serie 6  scarto saldo max 7.89%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 0.00%
  FTMO-DOC (posizioni 88):
   era IS  estate 21 + inverno 22 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2025.03.10 +0.61
  A ribas.  43 pos ( 53 deal) Profit   -358.83  PF pos 0.603 / deal 0.603  EP   -8.34  vinte 30  DD chiuso  507.10 EUR =  5.071%  pegg. giorno -1.008% (2025.03.17)  serie 2  scarto saldo max 11.76%
  B denaro  43 pos ( 53 deal) Profit   -351.66  PF pos 0.616 / deal 0.616  EP   -8.18  vinte 30  DD chiuso  508.00 EUR =  5.080%  pegg. giorno -1.115% (2025.05.22)  serie 2  scarto saldo max 11.77%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 11.77%
   era OOS estate 27 + inverno 18 posizioni; sedute di confine (classe 805, RESTANO nella curva): nessuna con posizione
  A ribas.  45 pos ( 59 deal) Profit    375.84  PF pos 1.769 / deal 1.769  EP   +8.35  vinte 34  DD chiuso  161.24 EUR =  1.612%  pegg. giorno -0.970% (2026.03.12)  serie 2  scarto saldo max 9.05%
  B denaro  45 pos ( 59 deal) Profit    383.26  PF pos 1.812 / deal 1.812  EP   +8.52  vinte 34  DD chiuso  147.52 EUR =  1.475%  pegg. giorno -0.887% (2026.03.12)  serie 2  scarto saldo max 9.04%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 13.11%
  S1-B posizioni ESENTATE dentro le curve (gemella g1): IN FASE 0 (nessuna); CONTROLLO 1 (R255q era IS 2025.01.10 P/L +8.35); FTMO-DOC 0 (nessuna) [esentate nei file: R255q 1, R255r 1]
  S1-B COMPOSIZIONE IN FASE, R255q 1430 (ESTATE USA PRESO nella curva che decide, l altra stagione fuori): IS PRESA n 15 P/L +182.13 PF 2.687 | IS fuori n 37 P/L +592.91 PF 1.651 | OOS PRESA n 28 P/L +356.55 PF 2.634 | OOS fuori n 35 P/L +183.67 PF 1.133
  S1-B COMPOSIZIONE IN FASE, R255r 1530 (INVERNO USA PRESO nella curva che decide, l altra stagione fuori): IS PRESA n 22 P/L -191.12 PF 0.597 | IS fuori n 20 P/L -178.62 PF 0.591 | OOS PRESA n 18 P/L +166.04 PF 2.119 | OOS fuori n 32 P/L -423.82 PF 0.474
  gamba intera R255q (corsa continua, denaro): 115 pos, 156 deal, Profit 1315.26, DD chiuso 770.92 EUR (7.709%), pegg -1.034%, serie 6 | CSV: EqDD 7.3013%, DD_fisso 832.84 -> k = 1.0803, Pegg CSV -1.0343%
    descrittivo (par. 12, NON cancello): valore del punto dal per-trade (posizioni a 2 deal, ingresso eliminato) n 41, mediana 0.869 EUR/pt/lotto (min 0.843 max 0.970); stop pieno mediano 68.3 (n 31; in EUR/lotto, cambio EURUSD dentro: classe 823)
  gamba intera R255r (corsa continua, denaro): 92 pos, 110 deal, Profit -627.52, DD chiuso 834.48 EUR (8.345%), pegg -2.312%, serie 2 | CSV: EqDD 8.3072%, DD_fisso 838.29 -> k = 1.0046, Pegg CSV -2.3118%
    descrittivo (par. 12, NON cancello): valore del punto dal per-trade (posizioni a 2 deal, ingresso eliminato) n 18, mediana 0.877 EUR/pt/lotto (min 0.843 max 0.967); stop pieno mediano 122.3 (n 28; in EUR/lotto, cambio EURUSD dentro: classe 823)
  RISCALDAMENTO classe 834 (stH8, primi 5 feriali dal 2024.09.27 SENZA filtro maturo): R255q: 1 posizioni, P/L +0.38 (2024.10.01 +0.38)
  RISCALDAMENTO classe 834 (stH8, primi 5 feriali dal 2024.09.27 SENZA filtro maturo): R255r: 2 posizioni, P/L -9.46 (2024.09.30 +0.24, 2024.10.02 -9.70)
  R3-A (CSV _OOS Peggior Giornata %): -1.0343 / -2.3118 -> NON sufficiente: R3 solo dalla curva
  R1 DD chiuso era IS: A 3.193% / B 3.187% contro 4.694% con e_eff 0.1266 [min x (1-e) = 2.784, max x (1+e) = 3.597] -> NON VIOLATO su n = 37 posizioni (P che un motore senza edge lo passi: 0.59; RISCHIO PASSATO solo da n >= 60) A SALDO CHIUSO [EQUITY PEGGIO DEL LONG: DD_fisso R255q 832.84 > R255w 566.31]
  R2 DD chiuso era OOS: A 1.432% / B 1.310% contro 4.272% con e_eff 0.1266 [min x (1-e) = 1.145, max x (1+e) = 1.614] -> RISPETTATO su n = 46 posizioni (>= 40, classe 804) A SALDO CHIUSO [EQUITY PEGGIO DEL LONG: DD_fisso R255q 832.84 > R255w 566.31]
  R3 peggior giornata (denominatore = saldo della curva a inizio giornata): A -0.999% / -0.881%, B -1.077% / -0.805% (IS / OOS)
  RISCHIO DELLA CONFIGURAZIONE: rischio NON VIOLATO su n IS = 37 / n OOS = 46 (RISCHIO PASSATO solo con n IS >= 60 E n OOS >= 40, classe 804)
  SERIE PERDENTE (riportata, NON cancello, classe 804): IS 2 / OOS 2 (long 770202: 3 e 3 su 56 e 96)
  sul CONTROLLO (il BCM a ora fissa, un fatto per QUELLA sedia): R1 NON VIOLATO (A 3.223 / B 3.223, n 52); R2 VIOLATO (A 7.155 / B 7.709, n 63); R3 RISPETTATO
  M1 PF OOS >= 1,10 (A e B): per posizione A 2.404 / B 2.425, sui deal A 2.404 / B 2.425 -> passa
  M2 vs nudo IN FASE: PF OOS per posizione 2.404 vs 0.874, sui deal 2.404 vs 0.874 (+0,10), EP 11.14 vs -1.81 -> passa
  M3 concordanza: PF IS 0.968 vs 0.739, PF OOS 2.404 vs 0.874 (per posizione; sui deal IS 0.968 vs 0.739, OOS 2.404 vs 0.874) -> passa
  ESITO stH8: SOSPESA (posizioni OOS in fase 46 < 150: merito SOSPESO) -- INDIZIO FAVOREVOLE, merito sospeso (M1-M3 passati su n = 46) | rischio NON VIOLATO su n IS = 37 / n OOS = 46 (RISCHIO PASSATO solo con n IS >= 60 E n OOS >= 40, classe 804)

=== STH12  (R255s 14:30 / R255t 15:30)
  IN FASE (posizioni 70):
   era IS  estate 17 + inverno 14 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2025.03.10 +5.01
  A ribas.  31 pos ( 41 deal) Profit     42.00  PF pos 1.082 / deal 1.082  EP   +1.35  vinte 23  DD chiuso  138.15 EUR =  1.382%  pegg. giorno -0.914% (2024.11.18)  serie 2  scarto saldo max 2.77%
  B denaro  31 pos ( 41 deal) Profit     40.66  PF pos 1.079 / deal 1.079  EP   +1.31  vinte 23  DD chiuso  136.63 EUR =  1.366%  pegg. giorno -0.934% (2025.03.21)  serie 2  scarto saldo max 2.78%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 2.78%
   era OOS estate 25 + inverno 14 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2026.03.09 +2.59
  A ribas.  39 pos ( 47 deal) Profit    127.18  PF pos 1.262 / deal 1.262  EP   +3.26  vinte 30  DD chiuso  253.85 EUR =  2.538%  pegg. giorno -0.942% (2025.08.06)  serie 2  scarto saldo max 3.54%
  B denaro  39 pos ( 47 deal) Profit    126.49  PF pos 1.259 / deal 1.259  EP   +3.24  vinte 30  DD chiuso  255.15 EUR =  2.551%  pegg. giorno -0.972% (2025.08.06)  serie 2  scarto saldo max 3.57%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 3.97%
  CONTROLLO (posizioni 98):
   era IS  estate 17 + inverno 27 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2024.11.04 +39.29, 2025.03.10 +5.01
  A ribas.  44 pos ( 58 deal) Profit    320.03  PF pos 1.322 / deal 1.322  EP   +7.27  vinte 33  DD chiuso  301.31 EUR =  3.013%  pegg. giorno -1.038% (2024.12.24)  serie 2  scarto saldo max 0.00%
  B denaro  44 pos ( 58 deal) Profit    320.03  PF pos 1.322 / deal 1.322  EP   +7.27  vinte 33  DD chiuso  301.31 EUR =  3.013%  pegg. giorno -1.038% (2024.12.24)  serie 2  scarto saldo max 0.00%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 0.00%
   era OOS estate 25 + inverno 29 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2026.03.09 +2.59
  A ribas.  54 pos ( 71 deal) Profit    -22.62  PF pos 0.985 / deal 0.985  EP   -0.42  vinte 35  DD chiuso  715.40 EUR =  7.154%  pegg. giorno -1.029% (2026.01.23)  serie 4  scarto saldo max 3.20%
  B denaro  54 pos ( 71 deal) Profit    -23.34  PF pos 0.985 / deal 0.985  EP   -0.43  vinte 35  DD chiuso  738.29 EUR =  7.383%  pegg. giorno -1.063% (2026.01.23)  serie 4  scarto saldo max 3.35%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 0.00%
  FTMO-DOC (posizioni 75):
   era IS  estate 23 + inverno 14 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2025.03.10 +0.61
  A ribas.  37 pos ( 48 deal) Profit    -78.18  PF pos 0.896 / deal 0.896  EP   -2.11  vinte 26  DD chiuso  340.14 EUR =  3.401%  pegg. giorno -0.994% (2025.03.17)  serie 2  scarto saldo max 4.01%
  B denaro  37 pos ( 48 deal) Profit    -77.31  PF pos 0.898 / deal 0.898  EP   -2.09  vinte 26  DD chiuso  337.32 EUR =  3.373%  pegg. giorno -0.986% (2025.03.17)  serie 2  scarto saldo max 4.00%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 4.01%
   era OOS estate 24 + inverno 14 posizioni; sedute di confine (classe 805, RESTANO nella curva): nessuna con posizione
  A ribas.  38 pos ( 47 deal) Profit    -12.55  PF pos 0.980 / deal 0.980  EP   -0.33  vinte 28  DD chiuso  256.20 EUR =  2.562%  pegg. giorno -0.956% (2026.03.12)  serie 2  scarto saldo max 3.54%
  B denaro  38 pos ( 47 deal) Profit    -13.21  PF pos 0.978 / deal 0.978  EP   -0.35  vinte 28  DD chiuso  257.42 EUR =  2.574%  pegg. giorno -0.972% (2025.08.06)  serie 2  scarto saldo max 3.57%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 4.01%
  S1-B posizioni ESENTATE dentro le curve (gemella g1): IN FASE 0 (nessuna); CONTROLLO 0 (nessuna); FTMO-DOC 0 (nessuna) [esentate nei file: R255s 0, R255t 1]
  S1-B COMPOSIZIONE IN FASE, R255s 1430 (ESTATE USA PRESO nella curva che decide, l altra stagione fuori): IS PRESA n 17 P/L +62.00 PF 1.221 | IS fuori n 27 P/L +258.03 PF 1.362 | OOS PRESA n 25 P/L +79.09 PF 1.232 | OOS fuori n 29 P/L -102.43 PF 0.914
  S1-B COMPOSIZIONE IN FASE, R255t 1530 (INVERNO USA PRESO nella curva che decide, l altra stagione fuori): IS PRESA n 14 P/L -21.34 PF 0.910 | IS fuori n 23 P/L -92.80 PF 0.788 | OOS PRESA n 14 P/L +47.40 PF 1.320 | OOS fuori n 26 P/L -418.51 PF 0.473
  gamba intera R255s (corsa continua, denaro): 98 pos, 129 deal, Profit 296.69, DD chiuso 738.29 EUR (7.383%), pegg -1.038%, serie 4 | CSV: EqDD 7.7159%, DD_fisso 822.29 -> k = 1.1138, Pegg CSV -1.0381%
    descrittivo (par. 12, NON cancello): valore del punto dal per-trade (posizioni a 2 deal, ingresso eliminato) n 31, mediana 0.871 EUR/pt/lotto (min 0.848 max 0.962); stop pieno mediano 73.1 (n 30; in EUR/lotto, cambio EURUSD dentro: classe 823)
  gamba intera R255t (corsa continua, denaro): 77 pos, 91 deal, Profit -485.25, DD chiuso 556.14 EUR (5.561%), pegg -2.252%, serie 2 | CSV: EqDD 5.8740%, DD_fisso 590.65 -> k = 1.0621, Pegg CSV -2.2522%
    descrittivo (par. 12, NON cancello): valore del punto dal per-trade (posizioni a 2 deal, ingresso eliminato) n 14, mediana 0.904 EUR/pt/lotto (min 0.851 max 0.966); stop pieno mediano 122.7 (n 23; in EUR/lotto, cambio EURUSD dentro: classe 823)
  RISCALDAMENTO classe 834 (stH12, primi 8 feriali dal 2024.09.27 SENZA filtro maturo): R255s: 2 posizioni, P/L +59.11 (2024.10.01 +0.38, 2024.10.04 +58.73)
  RISCALDAMENTO classe 834 (stH12, primi 8 feriali dal 2024.09.27 SENZA filtro maturo): R255t: 3 posizioni, P/L -1.30 (2024.09.30 +0.24, 2024.10.02 -9.70, 2024.10.03 +8.16)
  R3-A (CSV _OOS Peggior Giornata %): -1.0381 / -2.2522 -> NON sufficiente: R3 solo dalla curva
  R1 DD chiuso era IS: A 1.382% / B 1.366% contro 4.694% con e_eff 0.1266 [min x (1-e) = 1.193, max x (1+e) = 1.556] -> NON VIOLATO su n = 31 posizioni (P che un motore senza edge lo passi: 0.66; RISCHIO PASSATO solo da n >= 60) A SALDO CHIUSO [EQUITY PEGGIO DEL LONG: DD_fisso R255s 822.29 > R255w 566.31]
  R2 DD chiuso era OOS: A 2.538% / B 2.551% contro 4.272% con e_eff 0.1266 [min x (1-e) = 2.217, max x (1+e) = 2.875] -> NON VIOLATO su n = 39 posizioni (P che un motore senza edge lo passi: 0.48; RISCHIO PASSATO solo da n >= 40) A SALDO CHIUSO [EQUITY PEGGIO DEL LONG: DD_fisso R255s 822.29 > R255w 566.31]
  R3 peggior giornata (denominatore = saldo della curva a inizio giornata): A -0.914% / -0.942%, B -0.934% / -0.972% (IS / OOS)
  RISCHIO DELLA CONFIGURAZIONE: rischio NON VIOLATO su n IS = 31 / n OOS = 39 (RISCHIO PASSATO solo con n IS >= 60 E n OOS >= 40, classe 804)
  SERIE PERDENTE (riportata, NON cancello, classe 804): IS 2 / OOS 2 (long 770202: 3 e 3 su 56 e 96)
  sul CONTROLLO (il BCM a ora fissa, un fatto per QUELLA sedia): R1 NON VIOLATO (A 3.013 / B 3.013, n 44); R2 VIOLATO (A 7.154 / B 7.383, n 54); R3 RISPETTATO
  M1 PF OOS >= 1,10 (A e B): per posizione A 1.262 / B 1.259, sui deal A 1.262 / B 1.259 -> passa
  M2 vs nudo IN FASE: PF OOS per posizione 1.262 vs 0.874, sui deal 1.262 vs 0.874 (+0,10), EP 3.26 vs -1.81 -> passa
  M3 concordanza: PF IS 1.082 vs 0.739, PF OOS 1.262 vs 0.874 (per posizione; sui deal IS 1.082 vs 0.739, OOS 1.262 vs 0.874) -> passa
  ESITO stH12: SOSPESA (posizioni OOS in fase 39 < 150: merito SOSPESO) -- INDIZIO FAVOREVOLE, merito sospeso (M1-M3 passati su n = 39) | rischio NON VIOLATO su n IS = 31 / n OOS = 39 (RISCHIO PASSATO solo con n IS >= 60 E n OOS >= 40, classe 804)

=== STD1  (R255u 14:30 / R255v 15:30)
  IN FASE (posizioni 60):
   era IS  estate 15 + inverno 17 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2025.03.10 +5.01
  A ribas.  32 pos ( 42 deal) Profit     35.96  PF pos 1.075 / deal 1.075  EP   +1.12  vinte 24  DD chiuso  220.22 EUR =  2.202%  pegg. giorno -0.951% (2024.10.10)  serie 2  scarto saldo max 0.91%
  B denaro  32 pos ( 42 deal) Profit     36.43  PF pos 1.076 / deal 1.076  EP   +1.14  vinte 24  DD chiuso  220.52 EUR =  2.205%  pegg. giorno -0.951% (2024.10.10)  serie 2  scarto saldo max 0.92%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 0.92%
   era OOS estate 24 + inverno 4 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2026.03.09 +2.59
  A ribas.  28 pos ( 31 deal) Profit   -215.19  PF pos 0.555 / deal 0.555  EP   -7.69  vinte 19  DD chiuso  243.79 EUR =  2.438%  pegg. giorno -0.972% (2025.08.06)  serie 1  scarto saldo max 1.28%
  B denaro  28 pos ( 31 deal) Profit   -218.28  PF pos 0.553 / deal 0.553  EP   -7.80  vinte 19  DD chiuso  246.90 EUR =  2.469%  pegg. giorno -0.984% (2025.08.06)  serie 1  scarto saldo max 1.30%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 1.05%
  CONTROLLO (posizioni 79):
   era IS  estate 15 + inverno 29 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2024.11.04 +37.42, 2025.03.10 +5.01
  A ribas.  44 pos ( 58 deal) Profit    127.56  PF pos 1.119 / deal 1.119  EP   +2.90  vinte 32  DD chiuso  414.31 EUR =  4.143%  pegg. giorno -1.040% (2024.12.24)  serie 2  scarto saldo max 0.00%
  B denaro  44 pos ( 58 deal) Profit    127.56  PF pos 1.119 / deal 1.119  EP   +2.90  vinte 32  DD chiuso  414.31 EUR =  4.143%  pegg. giorno -1.040% (2024.12.24)  serie 2  scarto saldo max 0.00%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 0.00%
   era OOS estate 24 + inverno 11 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2026.03.09 +2.59
  A ribas.  35 pos ( 42 deal) Profit   -359.71  PF pos 0.578 / deal 0.579  EP  -10.28  vinte 22  DD chiuso  409.32 EUR =  4.093%  pegg. giorno -0.993% (2025.12.02)  serie 3  scarto saldo max 1.28%
  B denaro  35 pos ( 42 deal) Profit   -364.30  PF pos 0.578 / deal 0.579  EP  -10.41  vinte 22  DD chiuso  414.54 EUR =  4.145%  pegg. giorno -1.006% (2025.12.02)  serie 3  scarto saldo max 1.33%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 0.00%
  FTMO-DOC (posizioni 64):
   era IS  estate 20 + inverno 17 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2025.03.10 +0.61
  A ribas.  37 pos ( 47 deal) Profit   -113.77  PF pos 0.841 / deal 0.841  EP   -3.07  vinte 26  DD chiuso  379.78 EUR =  3.798%  pegg. giorno -0.994% (2025.03.17)  serie 3  scarto saldo max 2.44%
  B denaro  37 pos ( 47 deal) Profit   -112.55  PF pos 0.843 / deal 0.843  EP   -3.04  vinte 26  DD chiuso  381.04 EUR =  3.810%  pegg. giorno -0.998% (2025.03.17)  serie 3  scarto saldo max 2.45%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 2.45%
   era OOS estate 23 + inverno 4 posizioni; sedute di confine (classe 805, RESTANO nella curva): nessuna con posizione
  A ribas.  27 pos ( 31 deal) Profit   -341.61  PF pos 0.437 / deal 0.437  EP  -12.65  vinte 17  DD chiuso  371.24 EUR =  3.712%  pegg. giorno -0.972% (2025.08.06)  serie 1  scarto saldo max 1.28%
  B denaro  27 pos ( 31 deal) Profit   -345.35  PF pos 0.435 / deal 0.435  EP  -12.79  vinte 17  DD chiuso  373.47 EUR =  3.735%  pegg. giorno -0.984% (2025.08.06)  serie 1  scarto saldo max 1.30%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 2.48%
  S1-B posizioni ESENTATE dentro le curve (gemella g1): IN FASE 0 (nessuna); CONTROLLO 1 (R255u era IS 2025.01.10 P/L +8.35); FTMO-DOC 0 (nessuna) [esentate nei file: R255u 1, R255v 0]
  S1-B COMPOSIZIONE IN FASE, R255u 1430 (ESTATE USA PRESO nella curva che decide, l altra stagione fuori): IS PRESA n 15 P/L +85.43 PF 1.449 | IS fuori n 29 P/L +42.13 PF 1.048 | OOS PRESA n 24 P/L -238.97 PF 0.509 | OOS fuori n 11 P/L -125.33 PF 0.668
  S1-B COMPOSIZIONE IN FASE, R255v 1530 (INVERNO USA PRESO nella curva che decide, l altra stagione fuori): IS PRESA n 17 P/L -49.00 PF 0.830 | IS fuori n 21 P/L -137.17 PF 0.669 | OOS PRESA n 4 P/L +20.69 PF 12.124 | OOS fuori n 20 P/L -192.46 PF 0.582
  gamba intera R255u (corsa continua, denaro): 79 pos, 100 deal, Profit -236.74, DD chiuso 414.54 EUR (4.145%), pegg -1.040%, serie 3 | CSV: EqDD 4.4532%, DD_fisso 452.41 -> k = 1.0913, Pegg CSV -1.0396%
    descrittivo (par. 12, NON cancello): valore del punto dal per-trade (posizioni a 2 deal, ingresso eliminato) n 21, mediana 0.924 EUR/pt/lotto (min 0.858 max 0.970); stop pieno mediano 75.8 (n 25; in EUR/lotto, cambio EURUSD dentro: classe 823)
  gamba intera R255v (corsa continua, denaro): 62 pos, 72 deal, Profit -357.94, DD chiuso 512.68 EUR (5.127%), pegg -0.994%, serie 3 | CSV: EqDD 5.1682%, DD_fisso 521.32 -> k = 1.0169, Pegg CSV -0.9941%
    descrittivo (par. 12, NON cancello): valore del punto dal per-trade (posizioni a 2 deal, ingresso eliminato) n 10, mediana 0.929 EUR/pt/lotto (min 0.860 max 0.966); stop pieno mediano 122.0 (n 21; in EUR/lotto, cambio EURUSD dentro: classe 823)
  RISCALDAMENTO classe 834 (stD1, primi 15 feriali dal 2024.09.27 SENZA filtro maturo): R255u: 3 posizioni, P/L -36.60 (2024.10.01 +0.38, 2024.10.04 +58.73, 2024.10.10 -95.71)
  RISCALDAMENTO classe 834 (stD1, primi 15 feriali dal 2024.09.27 SENZA filtro maturo): R255v: 5 posizioni, P/L +7.50 (2024.09.30 +0.24, 2024.10.02 -9.70, 2024.10.03 +8.16, 2024.10.07 +8.36, 2024.10.11 +0.44)
  R3-A (CSV _OOS Peggior Giornata %): -1.0396 / -0.9941 -> condizione sufficiente per il SOLO metodo A
  R1 DD chiuso era IS: A 2.202% / B 2.205% contro 4.694% con e_eff 0.1266 [min x (1-e) = 1.923, max x (1+e) = 2.484] -> NON VIOLATO su n = 32 posizioni (P che un motore senza edge lo passi: 0.65; RISCHIO PASSATO solo da n >= 60) A SALDO CHIUSO
  R2 DD chiuso era OOS: A 2.438% / B 2.469% contro 4.272% con e_eff 0.1266 [min x (1-e) = 2.129, max x (1+e) = 2.782] -> NON VIOLATO su n = 28 posizioni (P che un motore senza edge lo passi: 0.64; RISCHIO PASSATO solo da n >= 40) A SALDO CHIUSO
  R3 peggior giornata (denominatore = saldo della curva a inizio giornata): A -0.951% / -0.972%, B -0.951% / -0.984% (IS / OOS); condizione sufficiente del CSV (metodo A) soddisfatta, B calcolato e >= -1,10
  RISCHIO DELLA CONFIGURAZIONE: rischio NON VIOLATO su n IS = 32 / n OOS = 28 (RISCHIO PASSATO solo con n IS >= 60 E n OOS >= 40, classe 804)
  SERIE PERDENTE (riportata, NON cancello, classe 804): IS 2 / OOS 1 (long 770202: 3 e 3 su 56 e 96)
  sul CONTROLLO (il BCM a ora fissa, un fatto per QUELLA sedia): R1 NON VIOLATO (A 4.143 / B 4.143, n 44); R2 NON RISOLTO (A 4.093 / B 4.145, n 35); R3 RISPETTATO
  M1 PF OOS >= 1,10 (A e B): per posizione A 0.555 / B 0.553, sui deal A 0.555 / B 0.553 -> fallisce
  M2 vs nudo IN FASE: PF OOS per posizione 0.555 vs 0.874, sui deal 0.555 vs 0.874 (+0,10), EP -7.69 vs -1.81 -> fallisce
  M3 concordanza: PF IS 1.075 vs 0.739, PF OOS 0.555 vs 0.874 (per posizione; sui deal IS 1.075 vs 0.739, OOS 0.555 vs 0.874) -> fallisce
  ESITO stD1: SOSPESA (posizioni OOS in fase 28 < 150: merito SOSPESO) | rischio NON VIOLATO su n IS = 32 / n OOS = 28 (RISCHIO PASSATO solo con n IS >= 60 E n OOS >= 40, classe 804)

=== LONG  (R255w 14:30 / R255x 15:30)
  IN FASE (posizioni 124):
   era IS  estate 26 + inverno 17 posizioni; sedute di confine (classe 805, RESTANO nella curva): nessuna con posizione
  A ribas.  43 pos ( 54 deal) Profit     23.30  PF pos 1.041 / deal 1.041  EP   +0.54  vinte 34  DD chiuso  276.07 EUR =  2.761%  pegg. giorno -1.000% (2025.05.08)  serie 2  scarto saldo max 2.37%
  B denaro  43 pos ( 54 deal) Profit     26.39  PF pos 1.046 / deal 1.046  EP   +0.61  vinte 34  DD chiuso  282.57 EUR =  2.826%  pegg. giorno -1.023% (2025.05.08)  serie 2  scarto saldo max 2.40%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 2.40%
   era OOS estate 58 + inverno 23 posizioni; sedute di confine (classe 805, RESTANO nella curva): nessuna con posizione
  A ribas.  81 pos ( 98 deal) Profit   -261.63  PF pos 0.787 / deal 0.787  EP   -3.23  vinte 57  DD chiuso  448.48 EUR =  4.485%  pegg. giorno -0.993% (2025.10.31)  serie 2  scarto saldo max 12.14%
  B denaro  81 pos ( 98 deal) Profit   -271.27  PF pos 0.792 / deal 0.792  EP   -3.35  vinte 57  DD chiuso  470.79 EUR =  4.708%  pegg. giorno -1.059% (2026.05.25)  serie 2  scarto saldo max 12.37%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 12.06%
  CONTROLLO (posizioni 152):
   era IS  estate 26 + inverno 30 posizioni; sedute di confine (classe 805, RESTANO nella curva): nessuna con posizione
  A ribas.  56 pos ( 74 deal) Profit    260.71  PF pos 1.215 / deal 1.215  EP   +4.66  vinte 39  DD chiuso  461.23 EUR =  4.612%  pegg. giorno -1.000% (2025.05.08)  serie 3  scarto saldo max 0.00%
  B denaro  56 pos ( 74 deal) Profit    260.71  PF pos 1.215 / deal 1.215  EP   +4.66  vinte 39  DD chiuso  461.23 EUR =  4.612%  pegg. giorno -1.000% (2025.05.08)  serie 3  scarto saldo max 0.00%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 0.00%
   era OOS estate 58 + inverno 38 posizioni; sedute di confine (classe 805, RESTANO nella curva): 2025.11.03 -97.75
  A ribas.  96 pos (130 deal) Profit    643.01  PF pos 1.272 / deal 1.271  EP   +6.70  vinte 64  DD chiuso  416.39 EUR =  4.164%  pegg. giorno -1.011% (2025.12.12)  serie 3  scarto saldo max 2.61%
  B denaro  96 pos (130 deal) Profit    659.77  PF pos 1.272 / deal 1.271  EP   +6.87  vinte 64  DD chiuso  427.25 EUR =  4.272%  pegg. giorno -1.036% (2025.12.12)  serie 3  scarto saldo max 2.69%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 0.00%
  FTMO-DOC (posizioni 123):
   era IS  estate 25 + inverno 17 posizioni; sedute di confine (classe 805, RESTANO nella curva): nessuna con posizione
  A ribas.  42 pos ( 53 deal) Profit     12.88  PF pos 1.023 / deal 1.023  EP   +0.31  vinte 33  DD chiuso  286.21 EUR =  2.862%  pegg. giorno -1.000% (2025.05.08)  serie 2  scarto saldo max 2.48%
  B denaro  42 pos ( 53 deal) Profit     15.88  PF pos 1.027 / deal 1.027  EP   +0.38  vinte 33  DD chiuso  293.08 EUR =  2.931%  pegg. giorno -1.024% (2025.05.08)  serie 2  scarto saldo max 2.51%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 2.51%
   era OOS estate 58 + inverno 23 posizioni; sedute di confine (classe 805, RESTANO nella curva): nessuna con posizione
  A ribas.  81 pos ( 98 deal) Profit   -358.46  PF pos 0.727 / deal 0.727  EP   -4.43  vinte 56  DD chiuso  544.49 EUR =  5.445%  pegg. giorno -0.997% (2025.10.29)  serie 2  scarto saldo max 13.26%
  B denaro  81 pos ( 98 deal) Profit   -376.14  PF pos 0.732 / deal 0.732  EP   -4.64  vinte 56  DD chiuso  575.66 EUR =  5.757%  pegg. giorno -1.070% (2026.05.25)  serie 2  scarto saldo max 13.60%
  scarto di saldo a curva CONTINUA (classe 876, solo errore di lotto): 13.41%
  S1-B posizioni ESENTATE dentro le curve (gemella g1): IN FASE 0 (nessuna); CONTROLLO 0 (nessuna); FTMO-DOC 0 (nessuna) [esentate nei file: R255w 0, R255x 1]
  S1-B COMPOSIZIONE IN FASE, R255w 1430 (ESTATE USA PRESO nella curva che decide, l altra stagione fuori): IS PRESA n 26 P/L +66.08 PF 1.195 | IS fuori n 30 P/L +194.63 PF 1.223 | OOS PRESA n 58 P/L -251.25 PF 0.762 | OOS fuori n 38 P/L +911.02 PF 1.663
  S1-B COMPOSIZIONE IN FASE, R255x 1530 (INVERNO USA PRESO nella curva che decide, l altra stagione fuori): IS PRESA n 17 P/L -39.69 PF 0.834 | IS fuori n 33 P/L -18.90 PF 0.969 | OOS PRESA n 23 P/L -20.02 PF 0.920 | OOS fuori n 68 P/L +283.93 PF 1.234
  gamba intera R255w (corsa continua, denaro): 152 pos, 204 deal, Profit 920.48, DD chiuso 461.23 EUR (4.612%), pegg -1.011%, serie 3 | CSV: EqDD 5.5763%, DD_fisso 566.31 -> k = 1.2278, Pegg CSV -1.0114%
    descrittivo (par. 12, NON cancello): valore del punto dal per-trade (posizioni a 2 deal, ingresso eliminato) n 50, mediana 0.863 EUR/pt/lotto (min 0.841 max 0.972); stop pieno mediano 66.4 (n 48; in EUR/lotto, cambio EURUSD dentro: classe 823)
  gamba intera R255x (corsa continua, denaro): 141 pos, 177 deal, Profit 205.32, DD chiuso 413.70 EUR (4.137%), pegg -1.083%, serie 3 | CSV: EqDD 4.2102%, DD_fisso 432.41 -> k = 1.0452, Pegg CSV -1.0826%
    descrittivo (par. 12, NON cancello): valore del punto dal per-trade (posizioni a 2 deal, ingresso eliminato) n 35, mediana 0.861 EUR/pt/lotto (min 0.816 max 0.961); stop pieno mediano 71.9 (n 35; in EUR/lotto, cambio EURUSD dentro: classe 823)
  ESITO: RIFERIMENTO (nessun esito: il long non decide e non sposta i tetti; R255x = la casella d+1 del Dow, descrittiva)

5. M4 ALTOPIANO, MAI IL PICCO (par. 10)
   Supertrend stH4/stH6/stH8/stH12/stD1: celle che passano R1-R3 E M1-M3 (con n >= 150): stH4=no stH6=no stH8=no stH12=no stD1=no
   -> NON C E UNA CONFIGURAZIONE ROBUSTA fra i Supertrend (tratto contiguo piu lungo: 0) [merito sospeso ovunque: M4 non valutabile]
   TP1_R: nessuna cella passa rischio e merito -> nessun centro
   EMA, parziale, trailing, orologio: interruttori, nessun altopiano (li sostituisce M3 piu il passo dopo)

6. ESITI PER CONFIGURAZIONE (ordine del par. 10)
   ancora  BOCCIATA PER RISCHIO (R2; vale a qualunque n)
   nudo    BOCCIATA PER RISCHIO (R2; vale a qualunque n)
   parz0   BOCCIATA PER RISCHIO (R2; vale a qualunque n)
   tp05    RISCHIO NON RISOLTO (R2)
   tp15    BOCCIATA PER RISCHIO (R2; vale a qualunque n)
   trail0  NULLO
   stH4    BOCCIATA PER RISCHIO (R2; vale a qualunque n)
   stH6    RISCHIO NON RISOLTO (R1, R2)
   stH8    SOSPESA (posizioni OOS in fase 46 < 150: merito SOSPESO) -- INDIZIO FAVOREVOLE, merito sospeso (M1-M3 passati su n = 46) | rischio NON VIOLATO su n IS = 37 / n OOS = 46 (RISCHIO PASSATO solo con n IS >= 60 E n OOS >= 40, classe 804)
   stH12   SOSPESA (posizioni OOS in fase 39 < 150: merito SOSPESO) -- INDIZIO FAVOREVOLE, merito sospeso (M1-M3 passati su n = 39) | rischio NON VIOLATO su n IS = 31 / n OOS = 39 (RISCHIO PASSATO solo con n IS >= 60 E n OOS >= 40, classe 804)
   stD1    SOSPESA (posizioni OOS in fase 28 < 150: merito SOSPESO) | rischio NON VIOLATO su n IS = 32 / n OOS = 28 (RISCHIO PASSATO solo con n IS >= 60 E n OOS >= 40, classe 804)
   long    RIFERIMENTO (nessun esito: il long non decide e non sposta i tetti; R255x = la casella d+1 del Dow, descrittiva)
   LA MANOPOLA BATTE IL RIFERIMENTO (M2, oltre il rumore, calcolato anche sotto 150 ma allora e un INDIZIO): stH8, stH12
   [LETTURA B: esiti con la S1 EMENDATA DOPO I NUMERI (classe 900), in attesa della firma di Claudio; la lettura valida senza firma e la A]
   CONTRO-ESEMPIO DELLA B (se le esenzioni fossero sbagliate): posizioni esentate dentro la curva IN FASE = 0 in tutte le 11 configurazioni lette (ancora 0, nudo 0, parz0 0, tp05 0, tp15 0, stH4 0, stH6 0, stH8 0, stH12 0, stD1 0, long 0); sbagliate, i numeri IN FASE non cambierebbero di un centesimo: cambierebbe SOLO se esistono (file NULLO -> configurazione NULLA, come in A). L alternativa "ora 15 non arrivata" la misura G2 L OROLOGIO: righe d inverno 15:30 contro 14:30 DIVERSE in 11 coppie su 11 leggibili.
   CERTIFICATO (09/09, par. 13): NON ANCORA MISURATO, MAI morto -- mancano i gemelli NASUSD/SPXUSD (punto 4) e il TF del grafico (punto 5); PF, n e DD e uscita ad asse: SI da questo round

7. COSA DICE PER LA 770212 (la sedia in firma = la configurazione ANCORA; curva FTMO-DOC, DESCRITTIVA: regola dell orologio FTMO documentata e NON misurata, griglia H4 diversa [NON MISURATO])
   era IS: A         45 pos ( 54 deal) Profit   -405.54  PF pos 0.581 / deal 0.581  EP   -9.01  vinte 31  DD chiuso  612.73 EUR =  6.127%  pegg. giorno -0.983% (2025.03.19)  serie 2  scarto saldo max 10.60%
           B         45 pos ( 54 deal) Profit   -397.31  PF pos 0.592 / deal 0.592  EP   -8.83  vinte 31  DD chiuso  610.80 EUR =  6.108%  pegg. giorno -0.979% (2025.03.19)  serie 2  scarto saldo max 10.58%
   era OOS: A         44 pos ( 50 deal) Profit   -412.93  PF pos 0.513 / deal 0.513  EP   -9.38  vinte 28  DD chiuso  541.16 EUR =  5.412%  pegg. giorno -0.983% (2026.03.12)  serie 3  scarto saldo max 7.52%
           B         44 pos ( 50 deal) Profit   -430.07  PF pos 0.503 / deal 0.503  EP   -9.77  vinte 28  DD chiuso  566.15 EUR =  5.661%  pegg. giorno -0.982% (2025.08.06)  serie 3  scarto saldo max 7.71%
   letti coi tetti del long (descrittivi): R1 VIOLATO; R2 VIOLATO; R3 RISPETTATO (A -0.983% / -0.983%, B -0.979% / -0.982% (IS / OOS))
   esito della configurazione ancora sulla curva IN FASE (quella che decide): BOCCIATA PER RISCHIO (R2; vale a qualunque n)
   differenza FTMO-DOC / IN FASE: i 40 feriali UE solare-USA legale presi dal file 15:30 (un ora DOPO la cash su FTMO col preset a 16:30, par. 6)
   NESSUNA PROPOSTA DI TAGLIA: i DD sono al banco 1% (deposito 10000); la scala alla taglia FTMO/BCM e un LIMITE SUPERIORE, non un identita (classe 547). Ogni esito e materiale per Claudio.

8. COSA RESTA A MANO: classe 166 (SHA256 del motore) e rc dei job si leggono SOLO dal RIEPILOGO/REFERTO della riga; la data del cambio d ora FTMO e la sua griglia H4; i gemelli NASUSD/SPXUSD e il TF; il DD vero di un EA che cambia ora da solo (la curva in fase e RICOMPOSTA, par. 15).
