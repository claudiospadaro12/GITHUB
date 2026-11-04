# Round 2 – #automated-support (testo integrale bot), immagini support/general/newbies (01/10 → 03/11/2026)

Sola lettura. Fonte: scheda Chrome 1934569287. Raccolta ripetuta del canale #automated-support: 1310 msg caricati (1285 nel periodo), 578 risposte Digital_Wim (bot), 471 mai lette per intero + 16 con coda oltre 1500 caratteri → ora lette INTEGRALMENTE (≈290k caratteri).
Nota: il bot è un'AI con KB in parte obsoleto; quando Wim lo corregge, vale Wim. Qui sotto solo informazioni NUOVE rispetto a support_general_newbies.md.

## A. #automated-support – informazioni nuove dalle risposte integrali del bot

### 01/10 – 06/10
- 01/10 SL/TP virtuali vs normali (GR): normali = sul server broker, funzionano anche se MT5/VPS è offline; virtuali = invisibili al broker ma inattivi se MT5/EA/VPS è giù. Il virtuale da solo NON rende un setup "prop safe": contano i limiti DD totale/giornaliero su equity.
- 01/10 MaxAllowedTotalDD=50 vs MaxRiskPerStrategy=50 non sono equivalenti né si sommano: "50 total" = rischio per strategia molto più basso; "50 per strategy" = estremamente aggressivo.
- 01/10 Deposito su GR: i lotti salgono col balance; due opzioni: depositare e abbassare MaxAllowedDD (o set più conservativo), oppure ricaricare il set e regolare MaxAllowedDD.
- 01/10 Disattivare una strategia (es. RunStrat9) NON chiude trade aperti né cancella pending già piazzate.
- 01/10 Metodo portafoglio di Wim (bot): backtest di ogni EA a 0.01 → annotare Max DD in $ → regolare i lotti perché tutti abbiano DD in $ simile → combinare (es. 4 EA con DD 300 ciascuno → portafoglio ~370, non 1200). Formula: **LotsizeStep = MaxDD_at_0.01 / TargetMaxDD%** (ripetuta il 04/10 per UBS). Target tipico portafoglio UBS ~20% DD; combinare in QuantAnalyzer.
- 01/10 Video UBS: canale YouTube @forexeasolutions; nel manuale UBS V7.0 la sezione "Your First Optimization" spiega passo-passo come creare una strategia.
- 01/10 "La maggior parte dei portafogli va bene da ~3.000"; DTP + Luna + 1 gold EA adatti a conti piccoli. Luna e GR: ciascuno "medium risk" di default = DD storico ~25–30% da solo → se insieme ridurre il rischio di ciascuno (regola: dividere per n. EA).
- 01/10 **TradeFrequency Auto funziona SOLO con Lotsize method = Max Allowed Total Drawdown**; soglie (budget = balance × MaxAllowedDD%): >$810 Intense, >$560 Moderate, >$330 Conservative, sotto = Extreme conservative. (Wim l'08/10 ha precisato che questi valori sono i max DD dei tier e non "budget"; vedi file precedente.)
- 01/10 UBS + GR sullo stesso conto: GR su XAUUSD H1, UBS soprattutto su forex/indici per diversificare (non altri set solo-oro); conto >5k.
- 01/10 Con $1K: meglio un solo EA (GR a rischio ridotto) che UBS+GR; aggressivo: 1 gold EA da $1.000; 3–4 EA ~$3.000.
- 01/10 Set prop: "Propfirm unique trades settings" tutti a 0 di default (Randomization, AdjustEntry/SL/TP/TrailSL/BE) → va impostato a mano Randomization (Wim: 75), gli Adjust sono offset fissi in pip.
- 02/10 **Fake Breakout Filter GR**: Off/Medium/High; per un buy, se la candela chiude negativa e sotto l'entry = falso breakout → esce; Medium controlla M1 + M15 + chiusura H1 della candela di entrata; High più timeframe.
- 02/10 UBS ora: non conta l'orologio del PC ma l'ora server + impostazioni UBS; URL worldtimeserver in MT5.
- 02/10 "Invalid price": livello troppo vicino al prezzo (stop level broker), suffisso simbolo diverso (XAUUSD+), spike di spread.
- 02/10 UBS modello Breakout Support/Resistance non piazza ordini subito: scansiona massimi/minimi, "inferior candles LEFT/RIGHT", distanza minima dal livello e tra ordini, max pending/trade, scadenza.
- 02/10 **GR: "DO NOT RUN MANUAL STRATEGIES WHILE USING 'MAX ALLOWED TOTAL DD' OPTION"** (avviso nel set): Manual Strategy Selection + MaxAllowedTotalDD → problema di divisione per zero (come Gold Phantom), lotti rotti/nessun trade. Per escludere una strategia: cambiare metodo lotti (Manual o Max Risk Per Strategy) + Manual Strategy Selection.
- 02/10 GR: DD storico "~350$ a 0.01 su extreme conservative"; "**Moderate al 30% richiede ~$2.350**" (sintesi supporto).
- 02/10 Set per grafico: documenti vecchi "20 consigliati / 50 limite"; Wim ora: nessun limite codificato, max ~50 per grafico; salvare tanti .set su disco non costa nulla; meglio più grafici.
- 02/10 Conto USD o EUR: nessuna differenza per gli EA; gli EA non leggono la leva (1:500 vs 1:5000 cambia solo margine).
- 02/10 GR cancella tutte le pending col Friday stop hour? non documentato → Wim.
- 03/10 UBS "Lots per balance" = metodo base (non guarda SL né DD storico); per portafogli UBS Wim preferisce "Max Risk Per Strategy".
- 03/10 Ottimizzazione/revisione set UBS: non rimescolare ogni mese; rivedere solo dopo un campione significativo se il live devia dal backtest.
- 03/10 **UBS Virtual SL**: "Use Virtual SL" (stop nascosto) + "Hard SL distance when using virtual SL" (stop reale di sicurezza più lontano) + "Move hard SL to virtual SL after X seconds" (0 = subito). Non esiste opzione per eliminare del tutto lo SL reale. GR: setSL_TP_After_Entry (SL/TP solo dopo l'entrata, pending senza SL), UseVirtualSL/Entry/Exit, Virtual_expiration.
- 03/10 GR + Luna: ~$2.000 = 1 gold EA + DTP + Luna; ~$3.000 = 2 gold EA + DTP + Luna. Luna sets: highRisk step 70, MediumRisk 150, Lowrisk 300 (set file); guida setup: 500/200/100.
- 03/10 **GR con StartLots fissi**: Lotsize calculation method = "use StartLots"; il lotto reale differisce se AdjustLotsizeToVariableValues=ON (normalizza sul prezzo oro) → OFF solo per lotto rigorosamente fisso; con Auto + MaxAllowedTotalDD deve restare ON.
- 04/10 UBS Max Risk per Strategy (KB): standard 1%, conservativo 0,5%, moderato 5% ≈ DD totale <15% (portafogli diversificati), **aggressivo 10% → DD storico poco sopra 30%**; 20 strategie moderate ≈ 3.
- 04/10 **Bot SBAGLIA su "Max risk per strategy in $ = 50"**: dice prima "budget totale per la strategia, non per trade", poi ammette di non sapere → Wim corregge: è rischio PER TRADE (vedi file precedente).
- 04/10 Caricare un set sul VPS: RDP → MT5 → proprietà EA → Inputs → Load; se il clipboard RDP è bloccato, email o cloud.
- 04/10 URL MT5 raccomandati (quick setup guide): worldtimeserver.com, forexeasolutions.org, forexeasolutions.services, nfs.faireconomy.media + "Allow algorithmic trading".
- 04/10 Filtro Interest Rate: default tipico **60 min prima / 120 dopo** (conferenza stampa); CPI per inflazione; si possono attivare insieme.
- 04/10 Luna mostra balance vecchio (3005 vs 1958): bot pensa a cache/bug → la causa vera era OnlyUp (Ash/Wim, già nel file).
- 04/10 Gold Phantom set: NFP 100/60 on, IR e CPI off.
- 05/10 **UBS mostra ancora "FixedLotsize"** con override: verificare UseAutoLoad=true + Override Autoload Lotsize Settings=true; menu "Risk" sul grafico principale = "use Max Risk Per Strategy" (non Manual Lotsize); set con "max historical drawdown (in $) at 0.01 lots" = 0 girano a 0.01 fissi.
- 05/10 **UBS chiusura pending venerdì**: UseTradingTimeZones=true, Time_Source (es. Broker), orari del venerdì, **KillPending=true** (KillOpen=false per lasciare i trade aperti).
- 05/10 UBS MaxPendingOrders=1: una sola pending attiva; non spezza il volume in più ordini.
- 05/10 Pending TSLA a mercato chiuso: stanno sul server broker, al riavvio MT5 si risincronizzano e l'EA le riprende.
- 05/10 GTP low risk set: Fake Breakout Filter di fatto OFF (UseConfirmationCandle=false); nelle versioni nuove c'è un comando semplificato "Fake Breakout Filter: Low" non documentato.
- 05/10 GR + GTP stesso conto: complementari (idea del Gold Bundle); ~metà del rischio ciascuno.
- 05/10 GR strategia 9 = "high risk", DD storico più alto di tutte; è il motivo del salto di rischio nel tier Extreme.
- 05/10 Set GR nel pack: gold_reaper_10%maxrisk (10), _15%maxrisk (15), _60%maxrisk_HighRisk (60), _default (30), live signal settings, **GoldReaper.set "ICMarkets Multi GrowthD" (MaxAllowedDD 15)**; nessun file "low risk 7%" (va chiesto a Wim).
- 05/10 Portfolio E: GR/GP MaxAllowedDD 7; gli altri (Goldtrade, GoldBot, Indicement) con MaxRiskPerStrategy; DD <6% non garantibile.
- 06/10 Pannello GR: "Account Balance" = balance di partenza della run corrente; "Total P&L so far" = realizzato+aperto dalla run; "Next NFP" si aggiorna solo al cambio mese (data passata = normale).
- 06/10 Wim non spegne GR in periodi specifici (lo tiene anche durante le news); per ridurre rischio abbassare MaxAllowedDD.
- 06/10 Non togliere SL/TP a mano: l'EA non li ripristina.
- 06/10 **L'unico input che chiude tutto in perdita è PropFirmMaxDailyDD** (MaxAllowedDD non chiude nulla).
- 06/10 Crash GR 5.1 su VPS MQL5 (meanroaster): diagnostica proposta: solo URL ufficiali, 1 grafico GOLD H1, test con NFP/calendario MQL5/AutoGMT disattivati, inviare log a Wim (nessuna incompatibilità nota).
- 06/10 Cambio email membership $99/mese: scrivere a info@forexeasolutions.com con nome, email sbagliata/corretta, dettagli ordine.
- 06/10 Gold Bundle consigliato come starter: forexeasolutions.com/bundles/gold; BBB come secondo passo.

### 06/10 – 09/10
- 06/10 GR conti piccoli: unico limite "duro" = pavimento 0.01 lot (es. $1.000 con MaxAllowedDD 6 → sotto 0.01 non scende, rischio reale > target). 25k con 6% ok, nessun caveat.
- 06/10 GR "high risk" = MaxAllowedDD 60 (gold_reaper_60%maxrisk_HighRisk.set); Intense + 60 "non low risk"; Extreme + 204 "molto rischioso, non raccomandato". 30→60 ≈ "2× rischio", profitto non lineare. Nessuna tabella "30% DD = X% al mese" (Wim: nessuna promessa %/mese).
- 06/10 Nei set ufficiali (anche GR 3GOLD) EnableNFP_Filter=true, EnableIR_Filter=false, EnableCPI_Filter=false; motivo non documentato.
- 06/10 **GR tier: Conservative = strategie 1–5 (DD portafoglio @0.01 ≈ $330); Moderate = 1–7 (≈ $560)**; Extreme conservative 1–3; Intense 1–8; Extreme 1–9 (07/10). Auto non sceglie mai Extreme.
- 06/10 Guida robustezza backtest (royst1, DTP EURUSD): PF >2 "forte", PF 7+ o win 90%+ su 10 anni = sospetto curve-fit; forward PF >1,4 "buono", min 100 trade; confronto 1M OHLC vs real ticks: curve "cugine", DD simile (se DD esplode su real ticks → non robusto); "nudge" di 1–2 parametri (es. MaxRiskMaxDD 6 → 4 e 8; LotPerBalance_step 2500 → 2000/3000; TrailSL 1000 → 800/1200): PF e DD devono restare simili. DTP auto lot: MaxRiskMaxDD ~2,7–3, LotPerBalance_step 2500–5000. DTP progettato per **13 coppie + oro**: le altre coppie "non tradare".
- 06/10 Rischio per strategia (KB): standard/conservativo ~1%, partenza conservativa 0,5%, moderato 2–3%, aggressivo >5%; "normale" negli esempi di Wim 1–3%.
- 06/10 Buy Limit non eseguito: si riempie sull'Ask, il grafico mostra il Bid.
- 07/10 Esempi KB: combo conservativa UBS+GR = UBS 1–1,5% per strategia + GR MaxAllowedDD 8–10%; esempio portafoglio UBS 20K: Gold Phantom strategie 1–7 a 3 + Gold Reaper 1–7 a 3 + alcuni set Volatility a 1 (tutto dentro UBS). "Mai entrambi a pieno rischio standalone sullo stesso conto."
- 07/10 Pannello GR fermo: deve ricevere tick; refresh grafico; riattaccare; **UpdateInfoTesting deve essere 0** (false).
- 07/10 **Scalp C "lotsperbalance=inf"**: calcolo balance per 0.01 = infinito perché il balance usato è 0/invalido → fallback a 0.01; controllare input balance/"force balance".
- 07/10 GR live signal settings: TradeFrequency 2 fisso (Moderate), NON Auto.
- 07/10 GR news filter solo NFP "perché lo slippage sull'oro è peggiore lì"; CPI e tassi testati e non tenuti; nel giorno NFP cancella le pending prima e le ripiazza dopo (book vuoto = normale).
- 08/10 Nessun minimo ufficiale per il 44 UBS; range pratici di Wim: GR "yolo" da $1.000; 3–4 EA ~$3.000 (max 2 gold EA); 5+ EA ~$5.000; **portafoglio UBS 40–80 strategie ~$3–4k "fattibile"; tutte le ~150 strategie ~$10k**. Set dei portafogli live in cartella "my live portfolio accounts sets"; combo in "recommended combo setup".
- 08/10 Scalp C con conti grandi: lotti grandi → ridurre rischio o lotto fisso; frequenza: vedere segnale MQL5 "UBS Scalp Set C". Allegare al TF del set (H1 per gli Scalp H1).
- 08/10 **UBS trailing (sez. 17)**: Trail SL distance (distanza dietro al prezzo), Trail SL start distance (profitto in pip per iniziare), Trail SL stop distance (profitto oltre cui smette di muovere lo SL), Trail SL step size (incremento minimo).
- 08/10 UBS virtual: useVirtualStops = SL nascosto (serve hard SL più lontano); Virtual_expiration = scadenza gestita dall'EA; per i limit retest S/R "Expiration (hours) for limit order" (0 = nessuna). TP sempre reale.
- 09/10 UBS: il TF di esecuzione è quello del grafico; nel set c'è "Timeframe to use for High/Low detection".
- 09/10 TGR: Max Risk Per Strategy dimensiona solo i lotti, non SL/trailing.

### 09/10 – 14/10
- 09/10 **Set GR "prodotto finito" ≠ set GR per UBS**: i .set normali di Gold Reaper NON girano su UBS; per UBS usare i set della cartella Gold Reaper dentro lo zip UBS.
- 09/10 GR FridayStopHour=25 = off; per chiudere/fermare venerdì alle 24 → 24; per chiudere subito: manualmente.
- 10/10 Exness "ok", ma broker ufficiali: IC Markets, IC Trading, Vantage, sempre conto **Raw Spread/ECN** (0.0 + commissione), non Standard; Vantage citato come "buona scelta a basso slippage". Pagina broker: forexeasolutions.com/brokers. Leva negli esempi di Wim fino a 1:500 (serve solo per il margine).
- 10/10 LotsizeStep: esempio guida setup LotsizeStep 100 → 0.01 ogni 100 di balance (500 → 0.05 lot).
- 10/10 GKE = sistema breakout flagship di Wim su Darwinex, live da nov 2020; portafoglio DARWIN >3 milioni di capitale investitori.
- 10/10 **CheckMargin**: rifiuta solo l'ordine che il conto non può sostenere; nessuna soglia di margin level, nessun retry (il segnale viene perso); lo stop-out del broker (es. 50%) resta possibile.
- 10/10 Più EA sullo stesso conto: rischio di ogni EA ridotto; regola di Wim: con 5 EA ~1/3 del rischio "solo" (non 1/5) — altrove "3–5 volte più basso"; conti: 3–4 EA ≥$3.000, 5+ ≥$5.000 (6+ $7.000).
- 10/10 **OnlyUp (reference set file)**: "ON per conti personali a lungo termine (quello che usa Wim), OFF per prop così il lotto segue il balance che scende". Avvertenza: **"Mai passare un terminale MT5 da demo a live mentre gira un EA con OnlyUp: il massimo del demo avvelena il sizing live."** UseEquity = dimensiona su equity invece che balance.
- 10/10 Weighted lots: lotto per strategia proporzionale al proprio profilo di DD. Set multi-EA di Wim: "My live portfolio accounts sets/ICMarkets Multi GrowthD/GoldReaper.set" e ".../daytrade pro.set". Nessun template a 13 EA.
- 10/10 Motivi per cui un EA non apre trade: mercato chiuso, simbolo "close only", margine, max lotti/ordini broker; orari EA/venerdì, news filter, spread, altri filtri.
- 10/10 Indicement: breakout su US500/US30/NAS100; periodi di live peggiore dei backtest, Wim sta rielaborando le strategie.
- 10/10 Contatto Wim: tag su Discord o profilo MQL5 mql5.com/en/users/strueli.
- 11/10 Luna set di riferimento: low 300 / medium 150 / high 70 / prop 700, tutti StartLots 0.01 e Risk_Per_Trade 0.5.
- 11/10 Bot: "Risk è solo un codice che seleziona la modalità"; Manual_RiskPerTrade/Risk_Per_Trade = % per trade; LotsizeStep = balance per 0.01; StartLots = lotto minimo o fisso.
- 11/10 **ReverseTrades UBS** (solo modello Breakout S/R): buy → sell limit allo stesso livello, sell → buy limit; SL/TP stesse distanze specchiate. Trattarlo come strategia nuova: duplicare il set, attivare, riottimizzare entrate/uscite/trailing, grafico separato; invertire un set forte di solito lo peggiora (taglia i grandi vincitori). Broker con limite 150–200 pending → ordini rifiutati.
- 12/10 Recovery Factor = uno dei criteri più importanti nell'ottimizzazione UBS (insieme a min trade e min expected payoff); nessuna soglia numerica.
- 12/10 GR Weighted Lotsize: sempre attivo, non regolabile.
- 12/10 UBS da MQL5: l'EA non è un file ex5 nello zip; si installa da MT5 → Market → Purchased → Install (login MQL5 in Tools→Options→Community).
- 12/10 **"max historical drawdown (in $) at 0.01 lots"**: si prende dal report di backtest a 0.01 fissi (peggior DD in valuta, non %).
- 13/10 UBS può stare notti o giorni senza trade: normale.
- 13/10 **Due gold EA insieme (GR+GP)**: "da 1500, meglio 2K, ~3K zona confortevole"; ciascuno a ~60% del rischio normale.
- 14/10 **Bot SBAGLIA su ReverseTrades** (05:09: "resta BUY STOP, è normale") → si corregge alle 05:12 citando Wim UBS v8.2 ("buy stop diventano sell limit"); Wim: va attivato in ogni set (vedi file precedente).
- 14/10 KillOpen: il bot dice di non avere la definizione (ma il 05/10 l'aveva usato: KillPending chiude pending a fine finestra, KillOpen i trade aperti).
- 14/10 Procedura update GR su VPS MQL5 / con trade aperti: non documentata → info@ / wim@forexeasolutions.com. Prodotti MQL5 per lo più acquisti una tantum.

### 14/10 – 19/10
- 14/10 GR: breakout puro su XAUUSD, fino a 9 strategie, pending BUY_STOP/SELL_STOP, SL/TP fissi + trailing dinamico, niente grid/martingala/media; logica identica per tutti ma livelli/riempimenti diversi per feed/spread/slippage. Nessun interruttore "no overnight" (solo FridayStopHour).
- 14/10 UBS ottimizzazione "Custom Max": usa n. trade, Recovery Factor, Expected Payoff; "il Recovery Factor ha il peso maggiore"; formula esatta non documentata (Andrew Soma vede EP³ dominare).
- 15/10 **Update EA su VPS MQL5**: aggiornare in locale → Tools → VPS → Details → Stop → Migrate (all) → Start; gli update non arrivano da soli al VPS.
- 15/10 3Gold/4Gold: bot non sa la differenza → ripete la correzione dell'utente/Wim (3Gold per 3 gold EA, 4Gold per 4, con 2 gold EA i set low risk; non per prop).
- 15/10 GR Auto: secondo il manuale sceglie il tier una volta all'avvio (nessuna discesa documentata) — Wim il 16/10: scende anche, ma con OnlyUp no.
- 15/10 Errore ottimizzazione "nessun parametro da ottimizzare": spuntare almeno un input con Start/Step/Stop.
- 16/10 UBS Variable Values: "Default ATR value" >0 → tutti gli input in pip moltiplicati per un fattore ATR di lungo periodo (più larghi con volatilità alta).
- 16/10 sdeyter (OnlyUp + risk per strategy, calo balance ~50%): il bot non conferma la formula, rimanda a Wim (domande su LotsAdjustMinChangePercent).
- 16/10 **Broker con contract size/lotto minimo diverso (es. min 1.00)**: rifare il backtest sul proprio broker al lotto base reale, prendere il max DD in $ e inserirlo direttamente in HistoricalMaxDD (non moltiplicare i set ×100). Stesso Max Risk Per Strategy per tutte le strategie per bilanciarle.
- 16/10 Max Risk per Strategy 200 = "yolo estremo" (ogni strategia può perdere storicamente il 200% del balance); valori sensati = bassa doppia cifra al massimo.
- 16/10 Leva 1:1000 non migliora l'EA, cambia solo il margine.
- 16/10 **Correlazione**: i 4 gold EA sono naturalmente correlati nei grandi movimenti dell'oro; i set UBS che ricreano i gold EA sono fortemente sovrapposti → NON far girare entrambe le "famiglie" sull'oro; usare UBS per forex/indici/BTC.
- 17/10 Scalp C: set live con LotsizeStep 80; **versione funded/prop LotsizeStep 1000** (da usare solo dopo averne parlato con Wim).
- 17/10 Update GR da MQL5: Tools→Options→Community login → Market → My Purchases → Update → riavvio MT5. Changelog v5.4: tab "What's new" su MQL5.
- 17/10 **Randomization GR**: offset dei livelli; per i prezzi attuali dell'oro Wim preferisce **75–100**, specie per prop; "Unique Trade" resta 0.
- 17/10 GR con $600: minimo "sul lato basso"; default + metodo Max Allowed Total DD; demo prima.
- 17/10 "Wrong step or stop value": valore fuori range/step; PropFirmMaxDailyDD interi (es. 3 o 4); orbmaster_combo_setup.set: MaxRisk_Strategy=2 (valori 2/3/4 interi).
- 18/10 UBS set propri: ST1_Timeframe ed Entry_Timing fanno parte della strategia ottimizzata (non cambiarli); "Time (minutes) for entry-window" = 0 = nessun limite; ST1 Timeframe 0 = TF del grafico.
- 18/10 CheckMargin: false solo per broker con specifiche contratto strane; altrimenti lasciarlo on. "Allow modification of Signals settings" non serve.
- 18/10 UBS TF: robustezza preferita H1 e superiori (H4/D1 spesso migliori); molti set ottimizzati su H1.
- 18/10 **HistoricalMaxDD = 0 in modalità Max Risk per Strategy → la strategia gira a 0.01 fissi** (FAQ). Non copiare il "Max DD" di un cliente come Max Risk per Strategy.
- 18/10 GR 5k/30% vs 10k/15%: stesso numero di trade se resta nello stesso tier; cambia solo il lotto.
- 18/10 Aggiornare EA: stesse pending gestite se magic+commento uguali. **Cambiare magic o commento → cancellare prima tutte le pending** (altrimenti "orfane"). Rimuovere un EA non cancella le sue pending.
- 19/10 Real ticks: modeling quality più bassa e risultati peggiori di 1M OHLC (ottimistico): normale; flusso Wim: ottimizzare in 1M OHLC, confermare in real ticks su periodo più corto.
- 19/10 UBS: backtest sul TF indicato nel nome del set (es. 1H → grafico H1), anche se internamente usa M15 per la volatilità; test su TF diverso = risultati senza senso. Parametri chiave Range Breakout: Timeframe to monitor, min/max candele range, ATR period/TF, max altezza range (×ATR o pip), misura High/Low o Open/Close, breakout buffer (×ATR), extra pips, entry-window.
- 19/10 UBS gold scalp: singola strategia da ~$200; multi-strategia Max Risk Per Strategy 3; **mai sopra 6 sul portafoglio 44**.

### 19/10 – 26/10
- 19/10 Bot propone a un utente il testo da mandare a Wim per sapere il lotto del primo trade GR default su $3.000 (nessuna tabella).
- 19/10 La riga "saved on 2026.07.28" in un .set = data di salvataggio, non la versione UBS.
- 20/10 **Backtest UBS a lotto fisso**: Risk = "Manual Lotsize" + manual lotsize (StartLots); gli altri metodi vengono ignorati. Caso Anan22 (bk_TESLA, broker min lot 1, 160 lotti): nel set AdjustLotsizeToVariableValues=true, LotPerBalance_step 1000, **MaxLots 1000**, LotsAdjFactorsSize 1.0 → per lotto fisso: ManualLotsize=1, AdjustLotsizeToVariableValues=false, **MaxLots=1 (o 2)**. Con broker min lot 1.0 tutte le modalità finiscono ad almeno 1.0.
- 20/10 Nessuna classifica dei set UBS a DD più basso: backtest a 0.01 dei set gold "core" (non gli ORB aggressivi), confrontare DD storico, forward test dei 2–3 migliori.
- 21/10 **UBS Max Risk per Strategy (guida doc): 3 = basso, 6 = medio, 10 = alto**, per strategia, NON si adatta al numero di set; portafoglio Christmas/client = **32 set**; 44 strategie: 3 (lato basso), **mai oltre 6**. Il set contiene il DD a 0.01 della strategia; il valore % lo sceglie l'utente nell'EA.
- 21/10 ~$5.000: Wim tipicamente 4 gold EA + 2–3 EA non correlati; combo base preferita per conti piccoli/medi: **Gold Reaper + Daytrade Pro + Luna AI**; default "medium" ≈ DD storico 25–30% per EA; stessa Max Daily DD % su ogni EA.
- 21/10 GR "tranquillo": su impostazioni non-Extreme può fare in media ~1 trade a settimana; per più attività affiancare UBS Gold Scalp C invece di spingere GR su Extreme.
- 21/10 (bot risponde anche a un utente che si sente solo, con consigli generici di supporto.)
- 21/10 **UseTradingTimeZones** (UBS/Range Breakout): False = tutti gli orari (check time, "Close trades at this hour") in ora server broker; True = ora della sessione scelta (New York o Londra, con ora legale). KillPending/KillOpen=True: a quell'ora cancella le pending e chiude i trade del range. La posizione del VPS non conta.
- 22/10 **GR – le 9 strategie (KB, Variable Values=true)**: 1 low, DD $60 @0.01, max 5 pending/5 open; 2 low $30, 1 pending; 3 low $35, 1 pending; 4 medium $52, 2 pending; 5 medium $110, 3 pending; 6 medium $140, 5/5; 7 medium $90, 5/5; 8 high $130, 5 pending/20 open; **9 high $700, 3 pending** (DD > strategie 1–7 insieme). Ognuna con proprio magic. Guida tipica: fino a Intense (1–8), la 9 solo accettando il rischio extra.
- 22/10 Kit UBS: EA MT5 + 100+ set (dalla logica di GR, Bitcoin Reaper ecc.) + manuale + video.
- 22/10 GTP = 8 sistemi breakout indipendenti su Daily, poco correlati con GR (H1). Nessuna tabella di correlazione per strategia.
- 22/10 Bundle sul sito: FAQ "l'acquisto è a vita", $1.249 una tantum, aggiornamenti a vita (l'opzione "subscription" su Shopify esiste ma non per i bundle secondo il bot).
- 23/10 UBS: non si possono disattivare le pending globalmente; servirebbe un modello a mercato (non documentato).
- 23/10 UBS Christmas set: secondo il KB "un set creato da una persona di fiducia di Wim", extra per acquirenti nel Telegram UBS (Wim poi: è nello zip set UBS).
- 23/10 Bot non conosce "combo.zip"; solo la cartella "recommended combo setup" dentro lo zip AllSets (Wim: è AllSetsAndManuals.zip).
- 23/10 **UBS lotti al minimo con Risk per trade** (Ukrit): cause: lotto calcolato sotto il minimo broker → arrotondato a 0.01; rischio troppo piccolo rispetto a SL × valore pip sugli indici; un'altra modalità (HistoricalMaxDD/Variable Values/LotsizeStep) controlla il lotto; contract size diverso. KB: **"Variable Values: abilitare per Oro, Indici, Petrolio, BTC; disabilitare per le coppie forex normali."** Regola KB: "determinare prima il max DD storico a 0.01, poi calcolare LotsizeStep; il lotto è lo strumento di bilanciamento principale". 3,4 vs 0,1 lotti su US500 tra due conti: confrontare set, simbolo (ForceSymbol), HistoricalMaxDD, Max Risk per Strategy, metodo.
- 23/10 **Formula Lots per balance: lots = 0.01 × (Balance / LotsizeStep)** (10.000/1.000 → 0,10; 10.000/5.000 → 0,02).
- 24/10 GR: StartLots = lotto base (di solito 0.01); Max Risk Per Strategy in GR = % di DD per strategia sul DD storico a 0.01.
- 24/10 Nessun editor batch di set (si può fare con editor di testo esterno, a proprio rischio).
- 24/10 Broker con XAUUSD 1 lotto = 1 oncia: rifare backtest e DD a 0.01; caso da far verificare a Wim.
- 24/10 GR pannello 0.0 lot dopo update: il set vecchio non contiene i nuovi input / metodo rischio a 0 → ricaricare il set ufficiale della versione corrente.
- 24/10 RNG_MeasureMode (UBS) non documentato nel glossario (probabilmente come misurare il range).
- 24/10 GoldTradePro_a/_b…: mappatura su strategie 1–8 non documentata.
- 24/10 GR "alto rischio": 60 ≈ 2× di 30; **100 = dimensiona come se fosse accettabile la perdita dell'intero conto**; Extreme + 204 "molto rischioso". Nessuna equivalenza ufficiale "GR 60% = UBS X%" (risposta in francese): backtest del portafoglio UBS e regolare.
- 25/10 GR preset per $2.000: 10% conservativo, 15% medio, default 30% "moderato-aggressivo", 60% HighRisk; "molti utenti 10–30%".
- 25/10 **UBS Scalp C – LotsizeStep: 80 ≈ alto rischio, 300 basso, 1000 molto basso (stile prop)**; disattivare trailing: Trail SL start distance = 0.

### 26/10 – 03/11
- 26/10 UBS Breakeven: distanze BE/SL/TP/trailing piccole = più sensibili a qualità tick e slippage; distanze più "larghe" = più robuste.
- 26/10 UBS maxHistoricalDD sempre a **0.01** (non 0.1).
- 26/10 Scalp C da LotsizeStep 80 (DD ~20–25%) a 40–50% DD: dimezzare lo step è solo euristica → backtest a 60/50/40. Leva 25 nel tester → limiti di margine: step più alto o balance maggiore.
- 27/10 GR non piazza "buy stop + sell stop ogni giorno": ordini condizionati alla struttura; giorni senza ordini normali.
- 27/10 GTP: "meglio far girare tutte le strategie anche se alcune sembrano peggiori nel breve"; nota vecchia "small account 3+4+7 / 2+4+7" non è la raccomandazione principale.
- 27/10 Backtest per singola strategia GR: nessun pacchetto ufficiale; farli a 0.01, una strategia alla volta, ≥5 anni.
- 27/10 Canale #share-your-performance sparito per un utente: permessi/ruoli o filtri dell'app.
- 27/10 Input di rischio (non codici): StartLots (fisso in manuale / minimo in automatico), **Manual_RiskPerTrade = % per singolo trade (range breakout e Luna)**, **MaxRiskInDollar_input = importo per trade in valuta**.
- 27/10 Cambiare set non fa "dimenticare" i trade: se magic uguale, l'EA li riprende.
- 27/10 **Broker (pagina broker del sito)**: IC Markets (ASIC + CySEC; non-EU/AU; leva UE/AU limitata a 1:30), IC Trading (FSC Mauritius; UE/AU fino 1:500; Raw Spread da 0.0 pip, **$3,50/lotto per lato**; islamico/swap-free su richiesta); 25+ LP, esecuzione <40 ms; "Open a Raw Spread account for best EA performance". Slippage: "Vantage o IC Markets Precision" entrambi buoni. Set non ottimizzati per Vantage ma "dovrebbe andare". (Il 30/10 il bot dice invece che Vantage "non è coperto" → incoerente.)
- 28/10 GTP con target DD <7% su $1.500: Goldtrade_V4.0_low_risk.set (medium/high: MaxRiskPerStrategy 3 e 6).
- 28/10 UBS Max Risk Per Strategy vs ottimizzazione vs lot step: l'ottimizzazione sceglie QUALI strategie; Max Risk Per Strategy equalizza il contributo di rischio; lot step = semplice balance→lotti. Il KB sconsiglia di cambiare portafoglio a "fasce" secondo chi va meglio: un portafoglio robusto bilanciato sul DD.
- 28/10 Luna: AutoGMT 1, GMT_Offset_Winter 2, GMT_Offset_Summer 3 → nessun intervento per l'ora legale.
- 29/10 **Rischio per trade superato di 2–3 volte** (chrisc0720): cause: slippage/gap, spread e commissioni, stop strutturali variabili, "Risk per trade %" con strategie a SL molto diversi (vietato dalla doc), arrotondamento al lotto minimo. Diagnosi: esportare 20–30 trade persi e confrontare SL teorico vs perdita reale. Portafoglio misto oro+FX: bilanciare prima ogni strategia con DD storico a 0.01, poi scalare con LotsizeStep o Max Risk Per Strategy, non un unico Risk%.
- 29/10 Gold EA standalone: righe lotto 0.00 nel pannello = solo display; GTP default Manual lotsize 0.01 per tutte le strategie. Set UBS caricati su un EA standalone → righe vuote (usare i set plug-and-play).
- 30/10 VPS di Wim: ForexVPS (link affiliato); se piano dedicato o standard non è documentato.
- 30/10 Filtri news gold EA: GTP solo NFP (EnableNFP_Filter true); **GR quick-start: EnableNFP_Filter = true e UseMQL5Calendar = true**; Goldbot One NFP=1; CPI off di default (GR 3GOLD/4GOLD, Phantom).
- 30/10 UBS SL rigido e trailing: "Initial stoploss distance"/"Initial takeprofit distance" (Trade Exit Settings) + 4 input di trailing + "Breakeven start distance"/"Breakeven extra distance". **L'EA non modifica le pending esistenti**: cancellarle e ricaricare per applicare nuovi SL. Exit_stop, Exit_TrailSL_Start ecc.: unità non documentata per il bot (Wim 31/10: in PIPS).
- 30/10 GR: minimo $600, consigliato $2.000+.
- 31/10 **Avviso UBS "wants 0.0259 lots … broker minimum 0.1 – will risk about 3.9x its share"** (Ukrit): Force Fixed Manual Balance 8000 × 0,25% = 20 a trade; US500/NAS100 Pepperstone → lotto calcolato 0,0259 < minimo 0,1 → 0,1/0,0259 ≈ 3,9 volte il rischio voluto. Lo 0,25% è PER TRADE, non diviso tra i 12 set. I metodi risk-based usano la distanza SL reale (Range Breakout con SL al lato opposto → lotto variabile). StartLots in modalità automatica = lotto minimo; AdjustLotsizeToVariableValues e OnlyUp sono modificatori sopra qualsiasi metodo automatico.
- 01/11 Backtest: Model 1 (real ticks) per scalper come Scalp C; Model 0 (1M OHLC) ok per breakout H1 (GR, GP).
- 01/11 Percorso per nuovo utente UBS (Claudio): partire dal 44 (o sottoinsieme) a rischio basso-medio, imparare l'Autoloader e i backtest di portafoglio; versione prop con ~0,5% per strategia e meno set; mini-portafoglio "major FX + 1–2 indici, risk per trade ~1% personale, 0,5% prop", backtest su simboli IC Markets. Plug-and-play set: compatibilità con UBS non documentata (UBS può usare sottocartelle con "Sets Folder").
- 01/11 GR Moderate 0.01 su $2.500: profilo live signal (TF 2, StartLots 0.01, MaxAllowedDD 30, MaxRiskPerStrategy 1) "pensato attorno a ~$2.000".
- 01/11 **GTP: default Manual lotsize 0.01 per strategia; le 8 strategie a 0.01 hanno DD storico combinato $322** → ~32% su $1.000, ~16% su $2.000, ~11% su $3.000. Su conti piccoli meglio 0.01 fisso.
- 01/11 News MT5 (Tools→Options→Server) non va disattivato; contano URL e filtro dell'EA.
- 01/11 UBS: nessuna opzione documentata "cancella pending 1 ora prima della chiusura del venerdì" (solo Trading Hours/KillPending).
- 01/11 Confronto Gold Bundle: GR = motore H1 intraday, trailing TP; GTP = Daily, 8 sistemi, più lento; Goldbot One = 8 varianti con adattamento automatico al prezzo dell'oro; Gold Phantom = 8+ strategie H1/H4/D1, più attivo, protezione NFP. Nessun ranking di sensibilità allo slippage.
- 02/11 "Request failed [Market closed]" nel Journal: cancellazione rifiutata a mercato chiuso, normale.
- 02/11 GR: raw o standard indifferente ("lo spread non conta molto", conta lo slippage); 1:500 non obbligatoria; con 1:20 almeno 3K e MaxAllowedDD ~10.
- 02/11 "GMT: unconfirmed offset GMT+2 (source: platform clock)": non è un errore; problema worldtimeserver risolto in UBS 9.0+/9.5; se il trading è normale non è critico.
- 02/11 "trade disabled" + "unknown error 4756": MT5/broker rifiuta (password investor, simbolo non negoziabile, algo trading off).
- 02/11 **Contract size diverso (TMGM NAS100 10× Pepperstone)**: con "Risk per trade %" o "in $/€" il campo "max historical drawdown at 0.01" NON serve (si usa la distanza SL); serve solo per "use Max Risk Per Strategy" → rifare il backtest a 0.01 sul nuovo broker (FAQ: "non copiare i numeri alla cieca"). Il bot si contraddice in parte tra le due risposte.
- 03/11 GR/UBS MaxDD 50→100: non cambia segnali né frequenza, solo i lotti.
- 03/11 Update GR: MQL5 → Market → My Purchases → Update; dal portale → scaricare il nuovo file e sostituirlo.

## B. #automated-support – immagini (aperte nel visualizzatore)
Su 116 messaggi con `img`, la maggior parte sono emoji di reazione o anteprime di link (YouTube, MQL5, worldtimeserver, ForexVPS, Karnek, sito FES): non sono screenshot. Sotto, gli allegati reali analizzati (dal più recente).

| Data | Autore | Cosa mostra | Problema / soluzione |
|---|---|---|---|
| 02/11 | finpotaatti | Log MT5 (Experts): GoldReaper_MT5_WSC_V4.6, "License found! EA starting up", "Next NFP: 2026.11.06 15:30", poi ripetuti "CTrade::OrderSend: buy stop 0.29 XAUUSD at 4691.25 sl 4569.60 tp 4720.25 [trade disabled]" + "unknown error 4756" | Trading disabilitato lato conto/broker (utente con conti FTMO; probabile conto prop non più abilitato o password investor). Notare: gira ancora GR **V4.6** (non 5.x). SL ~121 $ di prezzo sotto l'entry. |
| 02/11 | Michael_ | Log Experts di UBS: righe ripetute "GMT: unconfirmed offset GMT+2 (source: platform clock (agrees with the manual offset))" | Avviso informativo (worldtimeserver); UBS 9.5; non critico se l'offset concorda. |
| 02/11 | Michael_ | MT5 Options → Experts: Allow algorithmic trading ✓, Allow WebRequest ✓, URL visibile https://www.worldtimeserver.com/ (le schede di MT5 mostrano anche "AI Assistant" e "MCP", build recente) | WebRequest già consentito → avviso GMT resta comunque. |
| 01/11 | arielguti2547 | Finestra MetaTrader VPS (MQL5, London LD6 05, ping 1,58 ms) collegata a un conto FTMO "$100k FTMO Challenge Swing 2-Step", piano 1 mese $15, stato "stopped", "Last migration: not migrated yet" | L'EA "non funziona" sul VPS perché non è mai stato fatto il Migrate (e il VPS è fermo). Numero di conto non riportato. |
| 01/11 | arielguti2547 | MT5 FTMO-Server2 con 4 grafici XAUUSD H1: **GoldReaper V5.6** (Trade Frequency moderate, Max allowed DD 2.0%), **Gold Phantom V2.5** (intense, Max allowed DD 2.5%), **GoldBot One V3.5** (Max Risk Per Strategy 0.5%), **Gold Trade Pro V7.2** (Max Risk Per Strategy 0.2%); balance 103.973,92 USD, nessun trade, Next NFP 06/11 15:30 | Esempio concreto di configurazione 4 gold EA su challenge FTMO 100k con rischi molto bassi. Versioni attuali: GR 5.6, GP 2.5, GBO 3.5, GTP 7.2. |
| 01/11 | arielguti2547 | Stesso terminale: Alert "License not found!" di Gold Trade Pro: "Error retrieving license! Make sure the following URLs…: https://forexeasolutions.org, https://forexeasolutions.services" | Mancano gli URL WebRequest .org e .services → soluzione (idsme): aggiungerli in Tools→Options→Expert Advisors. |
| 24/10 | Mr.B | Foto di Esplora risorse: cartella "UPDATED SETS UBS_V7.7 > Breakout…" con GOLDTRADEPRO_a, _c, _d, _E, _F, _G, _H, GOLDTRADEPROH4_b, optimization_gold (.set) | Domanda: GoldTradePro_a = strategia 1 di GTP? Bot: mappatura non documentata. Si vede che i set UBS "GoldTradePro" sono 8 varianti (a–H, b su H4). |
| 23/10 | maverick817729 | Due righe di log: "Gold Trade Pro_WSC_V7.1 … Max number of pending sell orders reached… deleting lowest sellstop order" e "lotsize changed more than 5.0%… adjusting lotsize of pending orders" | Messaggi normali di GTP 7.1 (limite pending raggiunto; ricalcolo lotti quando il balance varia >5%). |
| 21/10 | Wim | (nessun allegato: solo emoji di reazione) | – |
| 20/10 | Anan22 (4 foto) | Foto dello schermo: testo del set bk_TESLA e **set-file editor HTML v7.3** (dallo zip "UPDATED SETS UBS_V8.3") con colonne 991001_SPO_UBS-XAUUSD-H1-C1, 9637014_BK_TSLA_VOL_D1ATR, 9637015_BK_TSLA_VOL_M15, 9637024_BK_US30_1H_Scalp_D, 9637040_Tilt_UBS-XAUUSD-H2-H2A10. Sezione LotSize: tutti "Manual Lotsize" (nel testo **Risk=0**); TSLA: StartLots 1, Manual_RiskPerTrade 0.1, MaxRiskInDollar 100, LotPerBalance_step 1000, MaxRiskPerStrategy 2.0, HistoricalMaxDD 53.741 / 50.364, **MaxLots 1000**; US30 Scalp_D HistoricalMaxDD ~115, MaxLots 99; UseEquity/OnlyUp/CheckMargin true; GMT Summer 3 / Winter 2, AutoGMT true; Grid disattivato; filtri news UseMQL5Calendar e NFP false (lettura sfocata) | Broker con min lot 1 → backtest a 160 lotti: AdjustLotsizeToVariableValues=true + MaxLots 1000 → mettere MaxLots 1–2 e Adjust…=false. Deduzione (non confermata): nel .set testuale **Risk=0 corrisponde a "Manual Lotsize"**. |
| 19/10 | Anan22 | Foto del pannello UBS (OneChart): tabella Symbol/TF – Strategy – Magic – Comment: XAGUSD H8 Sup/Res (AGX09); XAUUSD H1–H6 Sup/Res (UBS_E606, UBS_MIN05, UBS_G404, UBS_E604, UBS_X604, UBS_X601…); USOIL.c H1/H2/H4 (XTO06, Oil_SR_D1_A…); USTEC.c, DJ30.c Daily/M15, US500.c M1/M5 RANGE BR e VOL BR (US500_A/B/D/H/I_RISK, US500_RB2_04_RISK, US30_VOL_M15_g); USDJPY H1/M1 RANGE BR (USDJPY_B/C_RISK); USTEC M1/M12/M5 RANGE BR (USTEC_A/G_RISK) | Domanda "come so su che TF fare il backtest?": il pannello UBS mostra per ogni set simbolo e TF interno; i set "…_RISK" sono Range Breakout su indici/USDJPY (probabilmente il portafoglio 44). |
| 19/10 | sujal_fx | Grafico mobile BTCUSD# M15 con BUY STOP 0.5 (≈82.920) e SELL STOP 0.5 (≈80.665) e diversi trade | Chiede a WindBull se è il suo EA bitcoin breakout; nessuna risposta tecnica. |
| 18/10 | TCLEONG | Finestra proprietà "GoldReaper_MT5_WSC_V5.5 5.5 (XAUUSD,H1)" scheda Common: "Allow modification of Signals settings" (cerchiato, non spuntato) e "Allow Algo Trading" ✓ | Non serve spuntare "Signals settings" (bot corretto). Versione GR 5.5. |
| 18/10 | Mr.B | Ingrandimento del .set: **ST1_Timeframe=16385**, Entry_Timing=5, ST1_HL_strength… | 16385 è il codice MT5 di **H1** (non "0 = TF del grafico" come risposto dal bot, che ha letto male); Entry_Timing=5. Valori ottimizzati: non cambiarli. |
| 14/10 | Mr.B | Parametri UBS Trading hours: Enable Filter_E false, UseTradingTimeZones true, **KillPending true, KillOpen true**, Time_Source Broker; lun–gio 00:00–14:59 | Chiede cosa fa KillOpen; il bot non ha la definizione (rimanda a Wim). Dal 21/10: KillOpen chiude i trade aperti all'ora di chiusura. |
| 14/10 | Mr.B | Screenshot dell'annuncio di Wim "UBS v8.2" (11/10): ReverseTrades per Breakout S/R (buy→sell limit, sell→buy limit, stesse distanze SL/TP specchiate, off di default); **nuova colonna "Trades" nel pannello autoloader con trade chiusi per strategia e totale**; **fix: distanze grid ora in pips**; update su MQL5, dashboard FES e portale tradewithwim | Usato per correggere il bot (che aveva detto "resta BUY STOP"). |
| 14/10 | Mr.B (2 img) | Pannello UBS v8.2 su EURUSD-ECN H1 che esegue 1 strategia "ScalpH1_A" (XAUUSD-ECN H1, Sup/Res, magic 2101); input: Reverse trades (Breakout model only) = true, Timeframe current, inferior candles L/R 2/2, max candles 250, min distance from High/Low 90, extra pips above High 20 / below Low 40, max pending 1, max open 1; tab trade: 2 **buy stop** 0.09 xauusd-ecn "ScalpH1_A, Placed by expert id 2101" | ReverseTrades messo negli input del grafico ma gli ordini restano stop → va cambiato nel .set caricato dall'autoloader (Wim). |
| 07/10 | Vendetta (2 img, ripetute in 2 msg) | Pannello **The Gold Reaper V4.6**: Trade Frequency intense, Max allowed DD 60%, Account Balance 6.329,09, Total P/L −748,46, **Next NFP 2025.10.02** (data vecchia), lotti 0.02–0.11 per strategia; storico 06/10: 8 sell XAUUSDp 0.01–0.05 chiusi in perdita (−679,89), deposito 5.000, prelievo −1.320,11 (trasferimento), balance 3.000 | Pannello "bloccato" su 6.329 con balance reale 3.000: tipico effetto OnlyUp (massimo storico) dopo prelievo + versione vecchia 4.6. Il bot non lo riconosce e rimanda a Wim (vedi Wim 07/10: reset highest balance). |
| 06/10 | BIGDEX | Grafico mobile AUDCAD.m M15 con SELL LIMIT e BUY LIMIT (prezzo 0,9915) | Buy limit non eseguito: si riempie sull'Ask (spread ~9 pip letto dal bot nella 2ª foto: Bid 0,99154 / Ask 0,99247). Probabilmente Luna AI. |
| 06/10 | royst1 (5 foto) | Report Strategy Tester DTP EURUSD 10 anni a 0.01: **deposito iniziale 100.000**, History Quality 99%, 17.101 barre, netto 1.695,30, profitto lordo 3.124,11, perdita lorda −1.428,81, PF 2,19, **Recovery Factor 8,81**, 1.445 trade; equity in salita con un grande salto a metà; istogramma entrate per ora | Il "DD 0,19%" elogiato dal bot è calcolato su 100.000 $ con 0,01 lot (≈ poche centinaia di $): percentuale non significativa. |
| 06/10 | Gaetan | Foto MT5: 4 trade aperti in perdita (−27,42, −13,74 ×3) e 3 pending "placed" | Chiede perché il segnale MQL5 di GR ha l'ultimo trade al 02/10 mentre lui ha perdite oggi (nessuna risposta chiara). |
| 05/10 | Vision | Esplora risorse: set GR nel pack: gold_reaper_10%maxrisk, _15%maxrisk, _60%maxrisk_HighRisk, _default, **Gold_reaper_propfirm**, live signal settings | Non esiste un file "low risk": scegliere per % DD. |
| 05/10 | Vision | Input **Gold Trade Pro MT5 6.74** (XAUUSD.ra, Daily): Backtest Speed normal, run strategy 1–8 = 1, Max Allowed Spread 500, UseVariableValues 1, UseHL_TrailingSL 1, Friday stop hour 25, setSL_TP_After_Entry 0, Use Virtual Expiration 1, Randomization 0, **Fake Breakout Filter Low**, Virtual SL/TP false, "Seconds before the real SL is pulled" 99, Base Magic 1000 | Versione vecchia (6.74) con comando semplificato del Fake Breakout Filter. |
| 05/10 | Vision (2 img) | Input GTP 6.74 (set low risk): CPI filter false (100/60), Adjust* 0, StartLots 0.01, **Lotsize method "use Max Risk Per Strategy"**, Max risk per trade 1.2, **Max Risk Per Strategy 1.5**, Max Daily DD 0, LotsizeStep 600, OnlyUp true, CheckMargin true, UseEquity false, AdjustLotsizeToVariableValues true. Pannello: balance **140.638,28**, lotti per strategia S1 0.10, S2 0.06, S3 0.34, S4 0.22, S5 0.41, S6 0.25, S7 0.25, S8 0.12 | Esempio reale di sizing GTP all'1,5% per strategia su ~140k. Stima ricavata (non ufficiale, assumendo lotto = 0,01 × balance × 1,5% / DD@0,01): DD a 0,01 ≈ S1 $211, S2 $352, S3 $62, S4 $96, S5 $51, S6/S7 $84, S8 $176. |
| 05/10 | Wim (2 img) | Test UBS v8.1 con 3 strategie "Gold Reaper 3/4/5" (strategy3_Daily XAUUSD D1, strategy4_H4, strategy5_H1; magic 2003–2005): (a) Lot Method **MaxRiskStrat(2.00%)** su 101.328 → lotti 0.29 / 0.15 / 0.12; (b) **RiskPerTrade(100 EUR)** su 100.000 → 0.09 / 0.05 / 0.01 | Prova che l'override globale dell'AutoLoader funziona (rischio comune impostato una volta). Mostra anche che con "risk per trade" i lotti sono molto più piccoli che con 2% per strategia. |
| 04/10 | HT112 | Input **The_Gold_Phantom_V2.1_WSC 2.1 (GOLD#, H1)**: NFP close open/pending true, 100/60; **EnableIR_Filter false**, EnableCPI_Filter false (entrambi 100/60 se attivati); **Fake Breakout Filter = Intense**; Propfirm settings (Randomization, AdjustEntry/SL/TP/TrailSL/TrailTP/BreakEven) tutti 0 | Il bot aveva detto che IR e CPI erano attivi nello screenshot: in realtà sono false (solo i sotto-parametri sono true) → impostazione corrisponde al set ufficiale (solo NFP). Esiste l'opzione FBF "Intense". |
| 04/10 | BIGDEX | Foto: conto Vantage live, a sinistra **Luna AI PRO V1.51 – OneChartSetup** su EURUSD H1 (balance pannello 3.005,89), a destra **The Gold Reaper V5.1** (moderate, Max allowed DD ~35%?, balance 1.958,67) | Balance diverso sui due pannelli = OnlyUp di Luna (massimo storico in Global Variables) → reset (Ash/Wim). |
| 03/10 | BIGDEX | Foto Strategy Tester Luna AI Pro: AutoLotMode "use LotsizeStep", StartLots 0.01, Risk_Per_Trade 0.5, **LotsizeStep 100**, balance selection "use account balance", ManualBalance 0, OnlyUp true, Reset Highest Balance false, "Split up trade into X smaller trades" 1, "Split up trade based on max lotsize Y" 0, sezione "Performance Based Risk settings"; news "Event names: AUD CPI, CAD Cash Rate, AUD Trimmed Mean…" | Chiede se usare step 100 su $2.000 → Wim: "piuttosto aggressivo"; poi step 200 + GR moderate ok. Luna ha opzioni di split dei trade e rischio basato sulla performance. |
| 02/10 | Ash | Pagina del manuale UBS (telefono): **Risk – Default: Manual_Lotsize**; opzioni Manual_Lotsize (StartLots), Lots_Per_Balance (LotsizeStep), Risk Per Trade (%), Risk Per Trade in $/€; manual lotsize default 0.01; Max Risk Per Trade % default 0; in $ default 0; **LotsizeStep default 500** ("500 → 0.01 per 500$; con 3.000$ → 0.06"); **maximum lotsize per trade default 99**; Use Equity default false; **OnlyUp default: true** | Conferma da manuale che in UBS OnlyUp esiste ed è ON di default (il bot il 19/10 diceva "non documentato"). "Lot step" è di UBS, non di GR. |
| 02/10 | Classicaltrading | Grafico XAUUSD+ M5 con pannello **UBS V7.7**: running set "Reversal_1_5min_-1.96", magic 991, lotto fisso 0.01, balance 10.000, Next News NFP 02/10 | Errore "invalid price" su sell stop limit: versione vecchia, simbolo con suffisso "+"; nessuna soluzione pubblica. |
| 01/10 | BIGDEX (6 foto) | Foto di MT5 su Mac (Vantage): Market con pagina "Luna AI Pro" (Buy/Download demo), "My Purchases" vuoto; 4 foto delle proprietà **Luna AI Pro MT5 1.51** (EURUSD H1): parametri entry, filtri news, lotsize (LotsizeStep ~200?), "Performance based risk settings", GMT (testo in gran parte illeggibile) | Licenza "invalid": MT5 non vedeva l'acquisto MQL5 (login Community diverso) → risolto lo stesso giorno. |

Non aperti (non sono allegati o già descritti): messaggi con sole emoji di reazione o anteprime link (circa 75 dei 116), il file "Gold Reaper my_live signal settings.set" (non scaricato), eyalperel 06/10 (pannello GR già trascritto dal bot: balance 2.909,49, open P&L −45,49, total −211,38), BIGDEX 06/10 seconda foto (Bid 0,99154 / Ask 0,99247 trascritti dal bot), royst1 06/10 altre 2 foto dello stesso report.

## C. #general-trade-talk – immagini non analizzate nel giro 1
Messaggi con `img` nel periodo: 253 (in gran parte emoji di reazione, anteprime link, meme). Analizzati gli allegati di trading.

| Data | Autore | Cosa mostra | Numeri leggibili | Interpretazione |
|---|---|---|---|---|
| 19/10 | Jeremy (Mentor) (4 img) | Backtest di un portafoglio (Quant Analyzer): equity, statistiche, tabelle annuali/mensili. Testo: portafoglio ipotetico "BTC, Gold, Oil, poi Luna AI, Gold Reaper, Gold Phantom / Trade Pro couple sets, Daytrade Pro, Range breakout UJ/XAUUSD…" → Wim: "anything is possible" | Equity da 0 a ~$239.000, mar-2018 → set-2026; **profitto totale $239.435,27**; 29.336 trade; PF 2,25; Return/DD 112,49; win 68,38%; **DD max $2.128,52 (1,6%)**; media giornaliera $87,71, mensile $2.280,34; trade medio $8,16; profitto annuo medio $27.363,98 (27,36%), CAGR 14,54%; Annual%/MaxDD 9,09; SQN 57; stagnazione max 50 giorni (fine 2019); max lots exposure 6,29; gross profit 431.419,59 / gross loss −191.984,32; largest win 966,44 / loss −442,15; max 56 vincite / 36 perdite consecutive; long 56% / short 44%; anni: 2018 $16.562 (PF 1,69), 2019 $23.195 (1,94), 2020 $41.504 (2,91), 2021 $23.221 (1,90), 2022 $29.248 (2,17), 2023 $26.573 (2,42), 2024 $27.322 (2,41), 2025 $26.638 (2,51), 2026 YTD $25.170 (2,68); mesi negativi rari (es. set-2018 −506,88; giu-2022 −191,05; giu-2023 −359,33; feb-2025 −131,58); P/L concentrato nelle ore 15–17 | Backtest di portafoglio (non live), probabilmente a lotti fissi su base ~100k (DD 1,6%); curva molto regolare: molti set combinati. Prestazioni passate, non garanzia. |
| 21/10 | Mistermember (2 img) | Strategy Ledger Pro su un EA venduto altrove, "Apex Gold Breakout Commercial Release Original" (2 strategie BuyStop/SellStop, XAUUSD+) | Backtest: realizzato $1.015.526,43 in 3.062 giorni, PF 1,17, max DD $102.043, ~7.500 trade, win 55%, annualizzato +73,7%, 444 giorni max sotto il massimo. Simulazione "What-if" con $10.000 e costi del proprio broker: **−$9.998 (−100%)**, 118 trade forzati al lotto minimo, 6.856 saltati per margine | Esempio di "EA magico 10k→1M" che con slippage/costi reali azzera il conto. Mostra a cosa serve il tool di Mistermember. |
| 21/10 | Eugen | Ritaglio dello stesso tool: "Apex Gold Breakout Commercial…, 2 strategies (2 confirmed), Strategy 36050201 BuyStop" | – | Contesto della discussione sopra. |
| 21/10 | champ | Foto di un pannello "**Gold X9 by MrCapFree**" (clone di GR): Trading active, Trade frequency Extreme, balance 3.572,76, Max allowed DD 30%, Max DD (equity) 4,7%, 9 strategie, 4.511 trade, chiuso totale 2.572,76 | Wim: "copia truffaldina di uno youtuber… probabilmente AI su copia decompilata". |
| 24/10 | Anan22 | Screenshot di commenti YouTube che accusano Wim di non aver moderato un utente deriso il 12/10 nel canale "Pro Forex Algos" | – | Polemica sulla community (non di trading). |
| 29/10 | JOHN | Grafico Barchart "Alphabet (GOOGL) on track for its biggest loss in history" | ~−12% in un giorno | Notizia di mercato (gap sulle azioni). |
| 02/11 | Sebastian | Testo in risposta a Wessel (quale set usa il track record Myfxbook di GR): "Running Latest Version of the EA – **Fake Breakout Filter = Medium – Moderate trade frequency – 30% max DD**" | – | Impostazioni del track record GR (probabilmente dalla descrizione Myfxbook di Wim). |
| 15/10 | Ákos [CB] | Scheda "**Portfolio setup D**" dal sito di Wim (LIVE PORTFOLIO, verificato Myfxbook, 15/10/26): EA **The Gold Reaper + Goldbot One + Daytrade Pro Algo + Luna AI Pro**; "portafoglio aggressivo con strategie non correlate e più peso sui sistemi oro" | **Crescita totale +181,3%** (da gen-2025), media giornaliera +0,16%, **media mensile +4,9%**, **max drawdown 14,5%**; coppie XAUUSD + 15 forex (EURUSD, GBPUSD, USDJPY, … AUDCAD); TF H1, D1, M5; strategie Breakout, Price Action, Night Scalping; ultimo tratto in calo da ~210% a ~180% | Dato ufficiale live più utile del periodo per un portafoglio multi-EA; il "4,9%/mese" citato nel file precedente viene da qui. |
| 15/10 | Sebastian | Telefono: contenuto di "UPDATED SETS UBS_V7.7.zip": cartelle Breakout_Support_Resistance, Client sets, Range Breakout, **UBS live portfolio** (freccia), Volatility Breakout; file Metatrader Set File Editor.html (66,55 KB), metatrader-setfile-editor v7.2.html (129,9 KB), Ultimate_Breakout_System_Manual_V7_7.pdf (1,62 MB) | – | Risposta a "dove sono i 44 set?": cartella "UBS live portfolio". |
| 14/10 | Dennisfyc | Esplora risorse di un altro pacchetto set: Advanced Scalper, Bitcoin Reaper, bitcoin Scalp Pro(H1), client sets, Daytrade Pro, GOLD, Indicement, ORB Master, Other sets, Range Breakout, volatility breakout | – | Chiede se il 44/Xmas è lì: non è in questo pacchetto (è nello zip set UBS). |
| 12/10 | langesi | Report Strategy Tester (MT5 in tedesco) dei 5 set di "Huy Tran" insieme, XAUUSD, 01/01/2024 → oggi, 10% DD per set con interesse composto | Deposito 233.000; **utile netto 3.642.312,85**; lordo +4.922.470,25 / −1.280.157,40; **PF 3,85**; Recovery factor 11,95; Sharpe 5,27; LR correlation 0,90; DD saldo max 114.010,69 (2,86%) / relativo 10,16%; **DD equity max 304.740,27 (7,78%) / relativo 18,75%**; 543 trade (vinti 62,62%; sell 58,38%, buy 65,03%); trade migliore 196.763,79, peggiore −44.023; qualità storico 99% | Numeri enormi dovuti al compounding; langesi: "rischio/rendimento non male ma niente di nuovo" (sono set GR/GP/GTP riconfezionati). |
| 12/10 | Лох Кандибобирович1 | Nomi dei file venduti da Tran: GR_MaxRisk_W01_Daily_DD37p01_CONFIRMED.set, W02_Daily_DD44p10, W03_Daily_DD41p77, W04_Daily_DD80p43, W05_H4_DD84p70 | DD a 0,01 nel nome: 37,01 / 44,10 / 41,77 / 80,43 / 84,70 $ | Conferma che erano set "Gold Reaper" per UBS rinominati. |
| 12/10 | Лох Кандибобирович1 | Screenshot di messaggi di Tran (chat) | – | Contesto truffa, non di trading. |
| 09/10 | DiiZi | Storico MT5 mobile: 7 **sell TSLA.NAS** (0,8–2,9 lotti) chiusi tutti a 385,18 alle 16:35 del 09/10 (apertura con gap) | Perdite −5,19…−27,20; **totale −87,54** (commissione −0,40, swap +0,18) | Gap di Tesla all'apertura: perdita contenuta perché erano posizioni in profitto/pareggio. Domanda: il backtest simula i gap? |
| 07/10 | markushka99 (3 img) | Storico MT5 mobile di GR con set "YOLO" (quello del "400$→130k"): deposito 1.394–1.403 USD (USDC) il 02/10; dal 02 al 07/10 molti trade XAUUSD da 0,01 a **0,07 lotti**; il 06/10 serie di sell stoppati con l'oro in salita 4.110→4.171: −162,82, −172,98, −109,65, −89,04, −64,41, −56,66, −54,96 | **Profitto −712,94; balance 690,06 (−51% in una settimana)**; il 07/10 piccoli recuperi (+10…+26) | Lotti fino a 0,07 su $1.400 = rischio estremo; conferma il consiglio "ritira i profitti / non usare yolo". |
| 07/10 | Coi [SFL] | Chat di gruppo "Quantum Queen-King MT5" (EA grid di terzi): "low risk blew up", "2 accounts on low risk gone", "MC", "**All money gone. 77000 usd**" | – | Crollo di un EA grid/martingala altrui (segnale MQL5 2234595). |
| 07/10 | Лох Кандибобирович1 | Grafico di un segnale (equity in crescita poi drawdown) e link a segnale; ritaglio di un messaggio | – | Esempi di EA grid che "bruciano conti". |
| 11/10 | Лох Кандибобирович1 | Schede EasyAlgos "Nano Machine" e "Micro Machine" (EA grid) | – | "EasyAlgos ha rimosso l'EA di Bogdan". |
| 10/10 | !R7 | "Today's PnL −7.629,23 USDT" | – | Perdita crypto (non EA di Wim). |
| 11/10 | Zena | Risposta ChatGPT: NYSE e Nasdaq aperti nel Columbus Day, banche chiuse 12/10 | – | Festività USA. |
| 16/10 | langesi | Grafico debito/PIL USA 1790–2030 (≈180%) | – | "Carburante per l'oro" (macro). |
| 27/10 | Лох Кандибобирович1 | Barchart: "Chinese stock market… longest losing streak" | – | Notizia macro. |
| 18/10 | Лох Кандибобирович1 | Elenco di decine di "MetaTrader 5 Strategy Tester" agent attivi | "tutti i 20 core occupati due volte, 2 terminali" | Ottimizzazioni pesanti in corso (non per GR). |
| vari | Stocksncats, langesi (04/10 "Let's go to Mars", 17–18/10 foto vacanze/hotel), Jonathan e Eugen (16/10 meme Tesla auto volante / grafico TSLA a forma di loop), Dey (13/10), maindfriik (13/10 "It's a me"), !R7 (08/10 GIF) e altri senza testo | – | – | Meme / foto personali, non pertinenti. |

Messaggi indicati nel compito ma senza allegato nel DOM (solo testo o emoji): Gaetan 19/10 (backtest GR anno intero: solo testo), Jeremy 25/10 (Scalp C: risponde a un'immagine altrui), Rainy- 15/10 (nessuna immagine allegata ai suoi messaggi), SaidHamid 25/10, RazorsEdgeCH 26/10.

## D. #newbies-corner
| Data | Autore | Cosa mostra | Interpretazione |
|---|---|---|---|
| 22/10 | meanroaster | Meme (faccia che piange dietro una maschera sorridente) allegato al messaggio "il mio primo trade dal 9 ottobre: −$89" | Meme, non pertinente: nessun dato di trading nell'immagine. Gli altri `img` del canale nel periodo sono emoji di reazione o il file AllSetsAndManuals.zip (Wim 19/10). |

## E. Dove il bot sbaglia o si contraddice (correzioni)
- 04/10 "Max risk per strategy in $" → il bot dice "budget per strategia", Wim: è per TRADE.
- 08/10 Auto TradeFrequency: Wim corregge, i valori 330/560/810 sono i DD storici dei tier a 0.01 (vedi 06/10: Conservative ≈ $330, Moderate ≈ $560), il bot poi si adegua.
- 14/10 ReverseTrades: il bot prima dice "è normale vedere BUY STOP", poi si corregge citando l'annuncio di Wim v8.2.
- 14/10 KillOpen: dice di non conoscerlo, ma l'aveva già spiegato il 05/10.
- 15/10 GR Auto "sceglie il tier solo all'avvio" → Wim 16/10: scende anche, ma non con OnlyUp.
- 18/10 ST1_Timeframe: il bot legge "0" dove lo screenshot mostra 16385 (= H1 in MT5).
- 19/10 OnlyUp su UBS "non documentato" → il manuale UBS (foto di Ash 02/10) dice OnlyUp default true.
- 04/10 news filter Gold Phantom: dice che nello screenshot IR e CPI sono attivi; in realtà Enable…=false.
- 06/10 royst1: elogia "DD 0,19%" senza notare il deposito di 100.000 $.
- Luna LotsizeStep: 500/200/100 (guida) vs 300/150/70 (set) vs 400 conservativo, a seconda della risposta.
- Broker: il 27/10 Vantage "fine (Wim lo usa)", il 30/10 "Vantage non coperto".
- 02/11 contract size: prima "non serve cambiare HistoricalMaxDD con Risk per trade", poi "rifare comunque il backtest".
- Per tutto ciò che non sa, il bot rimanda a info@forexeasolutions.com / wim@forexeasolutions.com.

## Copertura round 2
- #automated-support: 1.285 messaggi del periodo ricaricati; tutte le 578 risposte del bot ora lette per intero (le 471 mancanti + la parte oltre 1.500 caratteri di 16 risposte lunghe); ~44 allegati reali aperti nel visualizzatore (gli altri ~70 messaggi con `img` sono emoji/anteprime link).
- #general-trade-talk: 772 messaggi, 253 con `img`; aperti/controllati ~45 allegati (tutti quelli di trading richiesti + campione dei meme).
- #newbies-corner: immagine di meanroaster aperta (meme).
- Non scaricato nulla, nessun messaggio/reazione, nessun link esterno aperto. Numeri di conto visti negli screenshot (FTMO, VPS) NON riportati.
