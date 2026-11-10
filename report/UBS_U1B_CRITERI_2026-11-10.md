# UBS tappa U1b: il "max DD storico a 0,01 lotti" su BCM per TUTTI i set oro, e fuori campione — CRITERI e PREVISIONI (10/11/2026, scritti PRIMA dei numeri)

**Natura: CRITERI, non ancora lanciato.** Segue `RISULTATI_UBS_U1_PILOTA_2026-11-10.md` (6 set su 6 passate valide; 4 su 6 con DD BCM da 1,4 a 4,6 volte il dichiarato). Manuale UBS letto il 10/11 (`ultimate-breakout-manual.pdf`, 4/11): conferma che il metodo di Wim e quello che abbiamo usato (0,1 lotti su oro con "Adjust Lotsize to Variable Values", poi DD diviso 10 per riportarlo a 0,01) e che lo "use Max Risk Per Strategy" dimensiona il lotto in modo che il DD storico resti dentro la percentuale scelta. Wim dice anche di ottimizzare sui dati MetaQuotes ("molti broker non hanno buoni dati storici") e di testare dal 2020-2025, ma anche dal 2000-2025 "dovrebbero essere stabili". Solo tester; reale, trial FTMO e VPS non si toccano; nessun lotto ne taglia.

## Domande
1. **U1b**: su tutti i set oro dei quattro EA (non solo 6), quanto il DD su BCM si discosta dal dichiarato?
2. **Fuori campione**: il rapporto R tiene fra due periodi (2005-2012 contro 2013-2025)? Se R cambia molto, il numero di Wim non e una proprieta del set ma del periodo.
3. **U1c (dopo)**: i set combaciano meglio con i dati MetaQuotes? (richiede un terminale MetaQuotes-Demo sul PC, passo manuale di Claudio).

## Cosa si testa (U1b)
**37 set oro** del pacchetto `Ultimate-Breakout-System-Set-Files.zip` (283 file, gia inventariato), cosi come consegnati (`Risk=0`, `StartLots=0,1`): Gold Phantom (daily) Gold_a/b/c (3); Gold Reaper strategy1-9 (9); Gold Phantom strat1-9 (9); Goldbot One dailyA/B/C/D/E/H/I/K (8); Goldtrade Pro H4_b, E, F, G, H, a, c, d (8). Esclusi i set "optimization" (DD None) e ScalpH1_C. **Dei 37, 6 sono gia nel pilota** (dailyA, GOLDTRADEPRO_a, Phantom_strat1, Reaper strategy1/4/5): il periodo 2013-2025 per quei 6 e gia fatto, quindi restano **31 passate 2013-2025 piu 37 passate 2005-2012 = 68 passate**, circa 2-3 minuti l'una (pilota: 1,5-3): **2-3,5 ore** sul PC di backtest.
EA `Ultimate_Breakout_EA_WSC_V9.5.ex5` (cartella WIM), XAUUSD, BCM, Modello 1, deposito 100.000 EUR, **una passata continua per periodo** (2013-01-01 -> 2026-01-01; 2005-01-01 -> 2013-01-01).
**Validita di una passata**: report presente, deposito 100.000, input uguali al set (`HistoricalMaxDD`, `StartLots`, `Risk`, `ForceSymbol`, magic), qualita storico >= 98% (per 2005-2012 la soglia e **>= 95%**, dichiarato: i dati piu vecchi possono essere peggiori), almeno 1 operazione, licenza accettata, nessuno stop out.

## Misure e regole di lettura (fissate ora, uguali al pilota)
R = DD equity BCM a 0,01 (DD del report / 10) / `HistoricalMaxDD` del set, in EUR e in USD (1,15, ipotesi). **CONFERMA** |R-1| <= 25%; **DIFFERENTE** 25-50%; **DIVERSO** oltre 50%. Ripartiti per set, per EA e per timeframe (D1, H4, H1). Fuori campione: per ogni set, **R2005-12 contro R2013-25**: **STABILE** se i due R differiscono meno del 50% fra loro; **INSTABILE** altrimenti.
**Decisione di uso (scritta ora):**
- se almeno il **60%** dei set e CONFERMA o DIFFERENTE nei due periodi, il DD dichiarato si usa **con un margine** (R mediano per EA);
- altrimenti si usa per ogni set il **DD misurato su BCM** (`DD_BCM = dichiarato x R`, il piu alto dei due periodi) al posto del dichiarato quando si imposta `MaxRiskPerStrategy`;
- un set INSTABILE non entra in un portafoglio senza un test dedicato.

## Previsioni dichiarate ORA (non misurate)
- **U1b-1** >= 60 passate su 68 valide: 80%.
- **U1b-2** Almeno il 65% dei 37 set ha R > 1 (DD BCM piu alto del dichiarato): 70%.
- **U1b-3** R mediano nel 2013-2025 fra 1,2 e 2,0: 50% (sotto 1,2: 25%, sopra 2,0: 25%).
- **U1b-4** Almeno il 50% dei set e CONFERMA o DIFFERENTE nel 2013-2025: 45%.
- **U1b-5** Gli H1 hanno R mediano piu alto dei D1: 55%.
- **U1b-6** Nel 2005-2012 R mediano piu basso del 2013-2025: 50% (non so se la crisi del 2008 pesi di piu del 2013).
- **U1b-7** Almeno il 60% dei set STABILE: 50%.
- **U1b-8** I set con `HistoricalMaxDD` basso (<= 40 $) hanno R piu alto di quelli alti (>= 100 $): 60% (DD piccolo = piu sensibile a costi e spread).
- **U1b-9** Il lavoro finisce in meno di 4 ore: 70%.
- **U1c (previsione per dopo)** Su dati MetaQuotes R mediano piu vicino a 1 di quello su BCM: 55%.

## Limiti dichiarati
Un percorso per periodo (i set hanno Randomization 0); Modello 1; cambio EUR/USD ipotesi; lotti variabili con `AdjustLotsizeToVariableValues`; il periodo e i dati di Wim non sono noti (MetaQuotes secondo il manuale); non si prova il lotto da rischio (e la tappa U2); nessun giudizio su acquisti, taglie o lotti.

## Tappa U2 (dopo, solo outline)
Con `Risk = use Max Risk Per Strategy` e `MaxRiskPerStrategy_Value` fisso (per esempio 2%), per un campione di set: il DD in % del deposito che esce dal test e vicino al 2%? E con il `HistoricalMaxDD` corretto (DD_BCM) invece del dichiarato? Il manuale dice anche che esiste `Max Daily Drawdown` dentro l'EA (chiude tutto e sospende il giorno, conta il flottante): da valutare come protezione prop accanto al Guardian.
