# UBS tappa U1: ricalibrare il "max drawdown storico a 0,01 lotti" su BCM — CRITERI e PREVISIONI (09/11/2026, scritti PRIMA dei numeri)

**Natura: CRITERI, non ancora lanciato.** Riga di ricerca fatta il 09/11 (`RIGA_CERCA_UBS.txt`): sul PC di backtest ci sono due EA UBS: `Market\Ultimate Breakout System.ex5` (423.028 byte, 18/10/2026, versione NON NOTA) e `WIM\Ultimate_Breakout_EA_WSC_V9.5.ex5` (485.274 byte, 04/11/2026, dal dashboard di Wim); nei Download anche V5.7, V5.8, V6.0, `UPDATED_SETS_UBS_V9_0.zip` e `Ultimate_Breakout_System_Manual.zip`. La cartella `Common\Files\Sets` non esiste (OneChartSetup mai usato). Prima tappa di UBS decisa nel cancello (`CANCELLO_MINIMO_PRIMA_DI_UBS_2026-11-08.md`, "Cosa cambia quando il cancello e chiuso"). Solo tester; reale, trial FTMO e VPS non si toccano; nessuna taglia ne lotto; nessuna strategia nostra in questa tappa.

## Domanda
Ogni set UBS porta scritto `HistoricalMaxDD` (in $ a 0,01 lotti, misurato da Wim su MetaQuotes o IC Markets). UBS usa quel numero per calcolare il lotto da `MaxRiskPerStrategy_Value`. **Su BCM (dati diversi) lo stesso set da' lo stesso DD?** Se no, il rischio nominale e sbagliato per la stessa percentuale.

## Cosa si testa (pilota di 6 passate, poi si estende)
Set dei quattro EA oro in formato UBS, dal pacchetto `Ultimate-Breakout-System-Set-Files.zip`, **cosi come consegnati** (lotto fisso `StartLots=0,1`, `Risk=0`: nessun input cambiato): `GOLD/Goldbot One/dailyA`, `GOLD/Goldtrade Pro/GOLDTRADEPRO_a`, `GOLD/Gold_Phantom_strat1`, `GOLD/Gold Reaper/strategy1_Daily`, `strategy4_H4`, `strategy5_H1`. **EA: `Ultimate_Breakout_EA_WSC_V9.5.ex5`** (cartella WIM; la versione Market non si usa in questo pilota), XAUUSD, BCM, **Modello 1**, deposito 100.000 EUR (Wim usa 100k), **un'unica passata continua 2013-01-01 -> 2025-12-31** per set (13 anni; il periodo di Wim per il DD e NON NOTO: il periodo in-sample dichiarato e 2013-2023). Dopo il pilota, estensione ai 34 set oro (Reaper 9, Phantom 9, Goldbot 8, Gold Trade Pro 8) e, se utile, 2005-2012.
**Validita di una passata**: report presente, deposito 100.000, `ForceSymbol` e input uguali al set, qualita storico >= 98%, almeno 1 operazione, nessuna licenza rifiutata nel giornale.

## Misure
DD equity assoluto massimo del report **diviso 10** (il test e a 0,1 lotti, il set dichiara il DD a 0,01), netto, operazioni, PF, lotto massimo, peggior giorno. Rapporto **R = DD(BCM, a 0,01) / HistoricalMaxDD del set**. Confronto anche in USD (cambio medio EUR/USD del periodo, **ipotesi**) per togliere l'effetto valuta.

## Regole di lettura (fissate ora)
- **CONFERMA**: |R - 1| <= 25%. **DIFFERENTE**: fra 25% e 50%. **DIVERSO**: oltre 50% (dati BCM, periodo o set diversi da quelli di Wim).
- Se R e circa 10 o circa 0,1 su tutti i set, l'**unita del DD** non e quella che assumiamo (0,01 contro 0,1 lotti): si legge dal manuale e si rifa il calcolo, non si giudica.
- Una passata o un set non decide: si riporta il quadro per set.

## Previsioni dichiarate ORA (non misurate)
- **U1a** 6 passate valide (licenza e caricamento del set funzionano nel tester): 65%.
- **U1b** Almeno 4 set su 6 CONFERMA: 35%; almeno 2 DIVERSO: 25%.
- **U1c** Il DD BCM e piu alto di quello dichiarato in almeno 4 set su 6 (spread e dati BCM piu cattivi, periodo piu lungo): 60%.
- **U1d** I set giornalieri (Goldbot, Gold Trade Pro, Reaper daily) sono piu vicini al dichiarato dello H1 (strategy5): 60%.
- **U1e** `strategy5_H1` e DIVERSO: 40%.
- **U1f** R e circa 10 o circa 0,1 su tutti i set (unita diversa): 15%.
- **U1g** La licenza o il caricamento di un set UBS nel tester fallisce: 25%.

## Limiti dichiarati
Un percorso (i set hanno Randomization 0), Modello 1 (barre da 1 minuto; il DD di Wim e anch'esso a 1M OHLC), periodo e broker di Wim non noti, EUR contro USD, lotti a 0,1 con `AdjustLotsizeToVariableValues=true` (il lotto cambia col prezzo, quindi DD(0,1)/10 e un'approssimazione del DD a 0,01 dichiarato). Nessun giudizio su acquisti, taglie o lotti. UBS non e ancora stato provato nel tester del PC. I set sono di maggio-agosto 2026 e l'EA e V9.5 (4 novembre): input nuovi della V9.5 non presenti nei set prendono il default dell'EA (NON VERIFICATO quali). Il manuale (`Ultimate_Breakout_System_Manual.zip`) non e stato ancora letto: il significato di `Risk` e dell'unita del DD va confermato li.
