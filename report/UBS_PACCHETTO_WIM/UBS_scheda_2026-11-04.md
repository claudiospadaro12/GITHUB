# Scheda "Ultimate Breakout System (UBS)" V9.5 (pacchetto Wim) — 04/11/2026
Fonte: manuale ufficiale (38 pagine, v8.3, 14/10/2026) + `Ultimate-Breakout-System-Set-Files.zip` (50 set "client sets"). L'`.ex5` non è stato aperto e non è nel repository; i set originali restano fuori dal repo (qui solo l'inventario).

## Cosa è
Il **motore** da cui Wim dichiara di aver ricavato 60+ strategie e i suoi prodotti MQL5 (Daytrade Pro, Goldtrade Pro, Gold Reaper, Goldbot One, Indicement). Non è un singolo sistema: è un **costruttore di strategie di breakout** con 3 modelli d'ingresso:
1. **Breakout di supporto/resistenza** (ordini pendenti ai massimi/minimi che "sporgono", con forza a sinistra/destra e conteggio all'indietro).
2. **Breakout di volatilità** (candele grandi rispetto all'ATR dopo un periodo calmo).
3. **Breakout di range** (una volta al giorno, misura il range prima di un'ora scelta, es. apertura sessione; scarta se il range era già "in moto"; altezza massima in multipli di ATR).
Uscite: SL/TP, trailing SL e TP, breakeven, trailing sugli estremi, trailing "magico" da scalping, recupero a tempo, griglia opzionale. Filtri: spread, notizie, NFP/tassi/CPI, fake breakout, orari. Sezione Prop Firm: min/max equity, **Max Daily Drawdown (conta anche le perdite flottanti)**, randomizzazione degli ingressi in pips.

## Funzioni che ci servono (dal manuale)
- **AutoLoad / OneChartSetup**: da un grafico fa girare molte strategie caricando i set dalla cartella `Common/Files/Sets`. Ogni set ha magic e commento unici e `ForceSymbol` col nome ESATTO del simbolo del broker. Pannello riepilogativo di tutte le strategie.
- **Variable Values**: scala SL/TP/trailing sul prezzo o sull'ATR (per oro, indici, BTC) → backtest a 0,1 lotti fissi sensati su 15+ anni.
- **Rischio per strategia**: lotto da `MaxRiskPerStrategy_Value` (% del conto) e `HistoricalMaxDD` (in $ per 0,01 lotti) di ogni set: serve per bilanciare un portafoglio e vedere il drawdown totale in un solo test.
- Metodo di Wim: ottimizzazione 2013–2023, fuori campione 2000–2012 e 2024–25, 0,01 lotti fissi, deposito 100k, algoritmo genetico veloce, criterio "custom max" (n. trade, recovery factor, expected payoff), modellazione "1 minute OHLC" confermata con "ogni tick reale" su un periodo breve.
- Il manuale avverte che i dati dei broker variano molto (lui usa MetaQuotes demo per forex/oro, ICMarkets per indici): importante per il nostro PC di backtest.

## I 50 set client
| Simbolo | n | Modelli | Note |
|---|---|---|---|

| XAUUSD | 16 | S/R | |
| TSLA.NAS | 14 | S/R, Volatilità | |
| US30 | 7 | S/R, Volatilità | |
| USDJPY | 6 | S/R | |
| XAGUSD | 3 | S/R | |
| DE40 | 2 | Range | |
| XTIUSD | 2 | S/R | |

### Elenco completo
| Simbolo | Strategia | Modello | TF | Magic | DD storico ($/0,01 lotti)* | Rischio % | Buy | Sell |
|---|---|---|---|---|---|---|---|---|
| TSLA.NAS | TSLA.NAS VOL A 1H | Volatilita | M15 | 9637008 | 87 | 2 | sì | sì |
| TSLA.NAS | TSLA.NAS VOL B 1H | Volatilita | M15 | 9637009 | 51 | 2 | sì | sì |
| TSLA.NAS | TSLA.NAS VOL C 1H | Volatilita | M15 | 9637010 | 97 | 2 | sì | sì |
| TSLA.NAS | TSLA.NAS VOL D 1H | Volatilita | M15 | 9637011 | 36 | 2 | sì | sì |
| TSLA.NAS | TSLA.NAS SR H4 | S/R | H4 | 9637012 | 33 | 2 | sì | sì |
| TSLA.NAS | TSLA.NAS SR D1 | S/R | D1 | 9637013 | 21 | 2 | sì | sì |
| TSLA.NAS | TSLA.NAS VOL D1ATR | Volatilita | M15 | 9637014 | 53 | 2 | sì | sì |
| TSLA.NAS | TSLA.NAS VOL M15 | Volatilita | M15 | 9637015 | 43 | 2 | sì | sì |
| DE40 | DE40 S1 | Range | corrente | 9637019 | 25 | 2 | sì | sì |
| DE40 | DE40 S5 | Range | corrente | 9637020 | 25 | 2 | sì | sì |
| US30 | US30 1H SCALP A | S/R | H1 | 9637021 | 83 | 2 | sì | sì |
| US30 | US30 1H SCALP B | S/R | H1 | 9637022 | 107 | 2 | sì | sì |
| US30 | US30 1H SCALP C | S/R | H1 | 9637023 | 82 | 2 | sì | sì |
| US30 | US30 1H SCALP D | S/R | H1 | 9637024 | 115 | 2 | sì | sì |
| US30 | US30 1H SCALP E | S/R | H1 | 9637025 | 265 | 2 | sì | sì |
| TSLA.NAS | TSLA.NAS H1 TSV01 | Volatilita | M15 | 9637026 | 212.4 | 2 | sì | sì |
| TSLA.NAS | TSLA.NAS H1 TSV02 | Volatilita | M15 | 9637027 | 111.7 | 2 | sì | sì |
| TSLA.NAS | TSLA.NAS H1 TSV07 | Volatilita | M15 | 9637028 | 53.7 | 2 | sì | sì |
| TSLA.NAS | TSLA.NAS H1 TSV08 | Volatilita | M15 | 9637029 | 34.3 | 2 | sì | sì |
| TSLA.NAS | TSLA.NAS H1 TSV09 | Volatilita | M15 | 9637030 | 45.8 | 2 | sì | sì |
| TSLA.NAS | TSLA.NAS H1 TSV12 | Volatilita | M15 | 9637031 | 153.9 | 2 | sì | sì |
| US30 | US30 D1 IU03 SHORT 1 | S/R | D1 | 9637032 | 11.108 | 2 | no | sì |
| US30 | US30 M15 U3V12 | Volatilita | M15 | 9637033 | 22.8 | 2 | sì | sì |
| USDJPY | USDJPY D1 HJP09 | S/R | D1 | 9637034 | 1.65 | 0.7 | sì | sì |
| USDJPY | USDJPY D1 HJP10 | S/R | D1 | 9637035 | 1.75 | 0.7 | sì | sì |
| XAGUSD | XAGUSD H2 AGA04 | S/R | H2 | 9637036 | 53.0 | 2.0 | sì | sì |
| XAGUSD | XAGUSD H2 AGA06 | S/R | H2 | 9637037 | 72.18 | 2.0 | sì | sì |
| XAGUSD | XAGUSD H2 AGA09 | S/R | H2 | 9637038 | 50.9 | 2.0 | sì | sì |
| XAUUSD | XAUUSD H1 H1E04 | S/R | H1 | 9637039 | 59.3 | 2.0 | sì | sì |
| XAUUSD | XAUUSD H2 H2A10 | S/R | H2 | 9637040 | 99.1 | 2.0 | sì | sì |
| XAUUSD | XAUUSD H3 H3V113 | S/R | H3 | 9637041 | 90 | 2.0 | sì | sì |
| XAUUSD | XAUUSD H4 H4A05 | S/R | H4 | 9637042 | 101.7 | 2.0 | sì | sì |
| XTIUSD | XTIUSD H1 XTO06 | S/R | H1 | 9637043 | 116.7 | 2 | sì | sì |
| XTIUSD | XTIUSD H4 XTW07 | S/R | H4 | 9637044 | 13.5 | 2 | sì | sì |
| XAUUSD | XAUUSD D1 SR 11 | S/R | D1 | 9637045 | 30 | 2 | sì | sì |
| XAUUSD | XAUUSD D1 SR 14 | S/R | D1 | 9637046 | 30 | 2 | sì | sì |
| XAUUSD | XAUUSD D1 SR 5 | S/R | D1 | 9637047 | 30 | 2 | sì | sì |
| XAUUSD | XAUUSD D1 SR 9 | S/R | D1 | 9637048 | 30 | 2 | sì | sì |
| XAUUSD | XAUUSD H1 SR SCALP 1 | S/R | H1 | 9637049 | 104 | 2 | sì | sì |
| XAUUSD | XAUUSD H1 SR SCALP 11 | S/R | H1 | 9637050 | 153 | 2 | sì | sì |
| XAUUSD | XAUUSD H1 SR SCALP 5 | S/R | H1 | 9637051 | 69 | 2 | sì | sì |
| XAUUSD | XAUUSD H1 SR SCALP 9 | S/R | H1 | 9637052 | 76 | 2 | sì | sì |
| XAUUSD | XAUUSD H1 1 | S/R | H1 | 9637053 | 118 | 2 | sì | sì |
| XAUUSD | XAUUSD H1 2 | S/R | H1 | 9637054 | 150 | 2 | sì | sì |
| XAUUSD | XAUUSD H1 3 | S/R | H1 | 9637055 | 146 | 2 | sì | sì |
| XAUUSD | XAUUSD H1 4 | S/R | H1 | 9637056 | 145 | 2 | sì | sì |
| USDJPY | USDJPY 1 | S/R | D1 | 9637057 | 900 | 0.7 | sì | sì |
| USDJPY | USDJPY 4 | S/R | D1 | 9637058 | 570 | 0.7 | sì | sì |
| USDJPY | USDJPY JPYC | S/R | D1 | 9637059 | 500 | 0.7 | sì | sì |
| USDJPY | USDJPY R3 | S/R | H4 | 9637060 | 625 | 0.6 | sì | sì |

*I valori `HistoricalMaxDD` non sono confrontabili tra simboli (unità diverse: es. USDJPY ha 1,65–1,75 per D1 HJP09/10 e 500–900 per hangsan_*). **Da verificare nel tester prima di usarli per dimensionare.**

## Letture di C0 (non misurate)
1. **Questo è il pacchetto che conta**: gli altri tre EA (Apex, Stability Pro, Bitcoin Scalp) sono prodotti chiusi; UBS permette di costruire e **ottimizzare i nostri EA** con un metodo dichiarato e un'architettura già adatta a portafogli.
2. **14 set XAUUSD + 3 XAGUSD = 17 su 50 sono metalli**: stessa famiglia del nostro trio, non diversificano. I diversificanti sono: **TSLA.NAS (14, azione CFD)**, **US30 (7)**, **DE40 (2)**, **USDJPY (7)**, **XTIUSD (2, petrolio)**.
3. **TSLA.NAS**: serve che BCM e FTMO la offrano (e con che orari/spread/leva/overnight); è una singola azione molto volatile → concentrazione su un solo titolo.
4. **Autori diversi** (prefissi Till, BK, basa, hangsan): sono set di clienti di Wim, non verificati da lui; i nomi `2007-2023` / `2008-2024` indicano il periodo di ottimizzazione: il fuori campione dichiarato è il metodo, non un risultato.
5. Pre-condizioni pratiche: nomi simbolo BCM per ogni `ForceSymbol` (DE40, US30, XTIUSD, TSLA.NAS…), orari dei set (i set DE40 usano orari/notizie; **regola server GMT+1 fisso** e storico `_EXT`: vedi CLAUDE.md), URL consentiti in MT5 (worldtimeserver, tradewithwim per la licenza se l'EA è arrivato direttamente da Wim).
6. **Randomizzazione "anti-copy-trading"**: il manuale la presenta per rendere gli ordini meno identici agli occhi del monitoraggio delle prop firm. Non è una funzione che consiglio di usare per eludere controlli; prima di usarla su FTMO vanno lette le loro regole (copy trading, EA, identità delle strategie).
7. I set "ufficiali" dei prodotti MQL5 di Wim (Gold Reaper ecc.) e i set di ottimizzazione che il manuale dice di ricevere **non sono in questo zip** (c'è solo `client sets`, e `setfile-editor.html` è citato ma non incluso): da chiedere/verificare.

## Da misurare (criteri da congelare prima di guardare i risultati)
Per ogni set, a 0,1 lotti fissi (o 0,01 per forex) e tick reali BCM: profit factor, DD massimo, peggior giorno/sequenza, recupero, n. trade per anno, risultati per anno e regime, sensibilità allo spread; poi correlazione dei P&L giornalieri con Reaper/Goldbot/Phantom/GTP e tra set; selezione dei set non correlati e del peggior giorno combinato col Guardian. Test in due tempi come per le altre analisi: periodo di scelta e periodo separato non usato.
Stato: **nessun test eseguito**.

