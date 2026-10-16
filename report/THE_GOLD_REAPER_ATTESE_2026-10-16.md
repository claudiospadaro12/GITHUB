# The Gold Reaper MT5 -- attese scritte PRIMA di avere un solo numero nostro (16/10/2026)

Cosa si prova: la versione DEMO del Market nel nostro Strategy Tester (XAUUSD, feed BCM, ticks reali, deposito 5.000 EUR, set di Claudio completato dai default dell'EA: gli input effettivi li scrive il REPORT). Mesi: luglio, agosto, settembre 2026 (gli stessi dell'Arena) + un mese fuori campione da scegliere prima di guardare.
Riferimenti DICHIARATI DA TERZI (recensione MQL5 del 14/10/2026, v4.6, 0,01 lotti per strategia, conto di riferimento 4.000 USD): profitto 9.578,50 USD in 6,6 anni (circa 121 USD al mese), DD storico peggiore 8,46% (339 USD), P95 stress 14,34% (574 USD), win rate 78,3% a barre e 71,4% a tick reali.

## Ipotesi con smentita, scritte ora
- **H1 (non perde nei mesi normali)**: netto positivo in almeno 2 mesi su 3. *Smentita*: positivo in 0 o 1 mese su 3.
- **H2 (il DD dichiarato regge)**: in ogni mese DD massimo di equita' <= 600 USD (circa il P95 dichiarato, a lotti fissi 0,01). *Smentita*: anche un solo mese sopra 600 USD.
- **H3 (niente griglia/martingala, a differenza dell'Arena)**: picco di lotti vivi <= 0,08 (8 strategie x 0,01) e profondita' di scala assente (nessun aumento di lotto dopo una perdita). *Smentita*: picco di lotti vivi > 0,08 o lotti crescenti dopo perdite, in qualunque mese.
- **H4 (la protezione giornaliera funziona)**: in nessun giorno la perdita di equita' supera il 4% del deposito (200 EUR su 5.000) come dichiara `PropFirmMaxDailyDD=4`. *Smentita*: un giorno oltre 200 EUR di perdita di equita' (calcolo con replay M1 come per l'Arena).
- **H5 (win rate dichiarato)**: win rate a tick reali fra 65% e 80%. *Smentita*: fuori da quella banda.
**Quando non si decide**: ogni ipotesi si legge solo sui mesi con giro CONFORME (input, deposito, finestra, ticks reali 100%, `.ex5` uguale fra i mesi). Un solo mese = descrittivo. Con meno di 150 operazioni totali il merito non si giudica, il rischio si'.
**Un esito favorevole restera' "candidato da misurare ancora", mai "pronto per una prop"**: tre mesi di un anno solo e un feed solo.

## Prerequisiti da chiudere con Claudio
Nome esatto del file `.ex5` nel terminale; scheda Parametri completa col set caricato (significato di `Risk=1234` e `TradeFrequency=2`, parametri ST1-ST8); versione dell'EA (4.6/4.7); eventuali limiti della demo del Market nel tester [NON VERIFICATI].

## AGGIORNAMENTO (16/10 mattina, DOPO lo screenshot dei Parametri e PRIMA di qualunque numero nostro)
Letto dalla finestra Dati in ingresso della DEMO installata da Claudio (titolo «The Gold Reaper MT5 5.4 (XAUUSD,H1)»):
- **Versione 5.4 con NOVE strategie** (1-3 «low risk», 4-7 «med risk», 8-9 «high risk»): la recensione citata e' sulla v4.6/4.7 con OTTO strategie, i suoi numeri NON valgono per la 5.4.
- Metodo di lotto di default: **«Max Allowed Total Drawdown»** con Max Allowed TOTAL Drawdown = **30,0** (default), StartLots 0,01, **Weighted Lotsize true**, Max Risk Per Strat 1,0, **OnlyUp true**, Use Equity Instead of Balance **false**, Set Max DAILY Drawdown **0,0** (nel set di Claudio: 9, 4, OnlyUp 0). Quindi i lotti NON sono fissi a 0,01: li dimensiona l'EA dal DD ammesso e dal saldo. Le soglie in USD della recensione (lotti fissi 0,01) NON sono confrontabili.
- Filtri news: NFP attivo (chiude ordini aperti e pendenti da 100 minuti prima a 60 dopo, usa il calendario MQL5 con AutoGMT), tassi e CPI spenti; **Friday stop hour 25 = spento**; Max Allowed Spread 500; Fake Breakout Filter Medium; UseHL_TrailingSL true; Randomization 0.
- Gruppo «**Propfirm unique trades settings**» (AdjustEntry, SL, TP, TrailSL, TrailTP, BreakEven, tutti 0,0): modifica le caratteristiche dei trade perche' risultino diversi da un conto all'altro. Non si usa e non si propone: puo' violare le regole delle prop su trading identico/copia fra conti [DA LEGGERE nelle regole di ogni firm, NON VERIFICATO qui].
- Il calendario MQL5 NON e' disponibile nel Strategy Tester: nel test i filtri news possono non agire come dal vivo (il backtest puo' sottostimare la protezione del live o il contrario) [NON VERIFICATO].

### Ipotesi RISCRITTE (sostituiscono H2 e H3 sopra; H1, H4, H5 restano)
- **H2'** (DD): in ogni mese DD massimo di equita' <= **14% del deposito** (700 EUR su 5.000, il P95 dichiarato dalla recensione in percentuale). *Smentita*: anche un solo mese sopra 14%.
- **H3'** (niente scala dopo perdite): in ogni mese rapporto fra lotto d'ingresso massimo e minimo <= **2** (la crescita del saldo con OnlyUp sposta i lotti poco). *Smentita*: rapporto > 2 in un mese, o lotti che crescono dopo perdite consecutive.
- **H6** (la protezione giornaliera del set agisce): con `PropFirmMaxDailyDD=4` nessun giorno oltre -200 EUR (stessa cosa di H4, valutata sul set di Claudio e, separatamente, sui default 0,0 per vedere quanto conta).
Le prove si leggono SOLO sui mesi con giro conforme e con gli input effettivi scritti dal report: se il set di Claudio e i default divergono, il report e' la fonte, non lo screenshot.

## RIGA DEL TESTER (16/10 sera, prima di ogni numero)
Script `backtest_pipeline/righe/GOLDREAPER_TESTER_TRANCHE.ps1` (pin 95fa410e, derivato dall'Arena v4) + `RIGA_LANCIA_GOLDREAPER_TESTER_TRANCHE.txt`. Passate: luglio, agosto, settembre 2026, XAUUSD H1, ticks reali, 5.000 EUR, leva 1:100, **nessun input imposto** (default dell'EA; fanno fede gli input scritti dal report). Gate: solo controlla_riga.py (0 difetti meccanici) + parser PowerShell + prova del lettore di report su un report sintetico; **nessun controllo-agente** (non disponibili). La seconda variante (set di Claudio: MaxAllowedDD=9, PropFirmMaxDailyDD=4, OnlyUp=0) si prepara coi nomi veri degli input letti dal primo report. Fuori campione: un mese da scegliere PRIMA di guardare (non ancora scelto).
