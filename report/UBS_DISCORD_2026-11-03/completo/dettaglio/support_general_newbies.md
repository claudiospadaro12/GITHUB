# ForexEASolutions Discord – #automated-support, #general-trade-talk, #newbies-corner (01/10/2026 → 03/11/2026)

Lettura in sola lettura, nessun messaggio/reazione/download. Fonte: scheda Chrome dedicata.

## Copertura
| Canale | Periodo coperto | Messaggi raccolti | Messaggi con immagini | Immagini analizzate |
|---|---|---|---|---|
| #automated-support (1535874664566358016) | 01/10 00:01 → 03/11 19:55 (completo) | 1285 (578 Digital_Wim bot, 63 Wim The Algo Trader, ~640 utenti) | 116 (conteggio comprende anche emoji di reazione) | 0 aperte singolarmente (solo testo/descrizione) |
| #general-trade-talk (1463074497992069161) | 01/10 04:08 → 03/11 14:03 (completo) | 772 | 42 (allegati reali) | 7 (Wim 06/10, Wessel 03/11, Mistermember 25/10, Wim 24/10, Gaetan 21/10, maindfriik + Tom 12/10); Jeremy 19/10 viewer non caricato |
| #newbies-corner (1465418420936904915) | 01/10 15:55 → 02/11 08:19 (completo) | 141 | 1 | 0 (descritta dal testo) |

Note di metodo (importante per l'affidabilità):
- Tutti i messaggi di utenti e di Wim (vero) sono stati letti integralmente.
- #automated-support: le 578 risposte del bot Digital_Wim (368k caratteri) sono state lette INTEGRALMENTE (fino a 1500 caratteri) quando contenevano parole chiave (licen/activat/autoloader/onechart/onlyup/demo account/999/9999/123/minimum balance: 109 risposte); le altre ~470 solo nei primi 220 caratteri (incipit). Le risposte del bot spesso sono generiche o contraddittorie e sono state corrette più volte da Wim: le correzioni di Wim prevalgono.
- Il bot si basa su un KB in parte obsoleto (es. manuale GR v4.3, UBS V7.0) mentre le versioni correnti sono GR 5.x, UBS 9.5.
- Nessuna credenziale personale trovata; la chiave universale "EA_DOWNLOADS_WSC" è stata pubblicata da Wim apposta per gli update degli EA bonus (non è una credenziale privata).

## Sintesi tematica (focus richiesto)

### Licenze / conti / demo / attivazione
- Acquisto sul SITO ForexEASolutions/tradewithwim: **10 slot conto per EA**, modificabili nella dashboard; **il conto DEMO conta come uno slot** (FAQ citata dal bot 10/10; confermato da utente KoSSaKi 12/10 in #newbies-corner, rimando a tradewithwim.com/faq). Non legato a VPS o PC. Kumar vede 20 slot nel portale con bundle "10 license": motivo non documentato.
- Attivazione licenza sito: tradewithwim.com/manageaccounts → chiave → SEARCH → numero conto MT5 in uno slot → Update; chiave nell'input EA; URL in MT5 (forexeasolutions.com, tradewithwim.com, worldtimeserver.com, nfs.faireconomy.media). Caricare un set default può cancellare la chiave (caso 3372, 20/10).
- Acquisto MQL5: lasciare VUOTO il campo licenza non-MQL5. Limiti di attivazione MQL5: **nessun numero specifico menzionato nel periodo** (non trovato). AutoLoader **non gira su VPS MQL5** (bot 02/10); dopo update su MQL5 occorre ri-migrare il VPS.
- EA bonus ricevuti da Wim senza licenza: update dal portale tradewithwim con chiave universale "EA_DOWNLOADS_WSC" (solo EA MT5 ricevuti direttamente da Wim; Wim 01/10).
- 25/10 UBS v8.6 MQL5 "license not valid" → Wim: "fixed" (problema lato licenza risolto in giornata).
- Bundle: Gold/BBB $1.249 una tantum, aggiornamenti a vita; esiste però una membership $99/mese e abbonamenti Shopify (domande su come cancellare senza risposta pubblica).

### AutoLoader / OneChartSetup
- Rischio comune su tutti i set (Wim 05/10, testato UBS 8.1): AutoLoader ON + Override Autoload Lotsize Settings = true + Lotsize calculation method = "use max risk per strategy" + valore Max Risk per Strategy. Non serve toccare i singoli set. "Max Historical Drawdown ($) at 0.01 lots" viene sempre dal set; "Adjust Lotsize To Variable Values" overridabile solo a false.
- Rischio dei singoli set: Override = false.
- Set in MT5 → Common\Files\Sets (o cartella propria); l'AutoLoader esegue solo i .set presenti; magic unici. Simboli broker diversi (GOLD#, WS30): ForceSymbol / US30_Symbol dentro ogni .set.
- Limite set: Wim 02/10 "nessun limite ora, raccomando max 50 per grafico" (es. 2 grafici × 50).
- ReverseTrades (UBS 8.2): va attivato in ogni set, non è globale (Wim 14/10).
- OnlyUp con OneChart: nessuno switch globale dedicato documentato.
- DTP: set portafoglio con RunOneChartSetup=1 corretto.

### Codici Risk
- Wim/bot: "Risk" è un codice che seleziona la modalità di sizing, non una percentuale. Codici citati: **1234** (set GR/GP live: blocco StartLots + Max Allowed Total DD), **123** = MaxRiskPerStrategy e **9999** = LotPerBalance (affermato dall'utente Mr.B 27/10, non confermato da Wim), **999** (set Range Breakout di Ukrit 31/10, significato non documentato), **99999**, **3** (Goldtrade_V4.0_low_risk.set). Il bot: nessuna tabella ufficiale dei codici; usare il Risk del set ufficiale. Wim 11/10: con LotsizeStep come metodo, StartLots e risk per trade non contano.
- Wim 04/10: "Max risk in $" in UBS = rischio PER TRADE (es. 50$ per trade); non esiste "risk per strategy in $".
- Wim 29/10: Risk per trade in $ ha senso solo se "Lotsize Calculation method" = "use Risk Per Trade in $/€".

### Set raccomandati / rischio / saldo minimo
- Wim 14/10 (portafoglio con 15-20k): non tutti gli EA su un conto; 3-5 conti da 4-5 EA (~5K ciascuno). Esempio: A) $1.500 Gold Reaper high risk + Gold Scalp C; B) 5K GR + Daytrade Pro + Luna; C) 7K 3 Gold EA; D) 5K portafoglio UBS (44-strat o Xmas, nello zip set UBS, cartella "UBS live portfolio").
- Wim 15/10: set 3Gold = 3 Gold EA insieme; 4Gold = 4; con 2 Gold EA usare il set low risk di ciascuno (non per prop).
- Wim 10/10: GR Moderate = miglior rischio/rendimento; non usare Moderate sotto $1.000 salvo voler alto rischio. Wim 03/10: GR+Luna minimo ~$1.000; Luna LotsizeStep 100 su $2.000 "aggressivo", step 200 + GR moderate su $2.000 "sì".
- UBS: Wim 21/10 "per ora 3% per strategia" (in arrivo UBS Optimization app). 44-strat live: 3%, mai >6% (bot); prop ~0,5% (bot). Wim 01/10 (newbies): 5% per strategia ok con 5 set, 40 set su $1.000 troppo.
- GR: minimo $600 (alto rischio), $1.500 confortevole, $2.000+ consigliato; DD storico ~$350 a 0,01 su extreme conservative; set gold_reaper_default (30), 10%, 15%, 60%_HighRisk, propfirm (MaxAllowedDD 9, daily 4); live signal settings: TF 2, MaxAllowedDD 30, MaxRiskPerStrategy 1, Risk 1234, OnlyUp true, NFP on. Conto cent consigliato sotto ~$5.000 per target DD bassi.
- Gold Phantom live: TF 3, MaxAllowedDD 30, Risk 1234, magic 75000. GTP low risk: MaxRiskPerStrategy 1.5, LotPerBalance_step 600, Risk 3. Luna: step low/med/high incoerenti nelle risposte del bot (500/200/100 vs 300/150/70; prop 700; conservativo 400); Scalp C live LotsizeStep 80 (Wim: DD storico ~15$ a 0,01 → DD <20-25%).
- Minimi multi-EA (bot): 2-3 EA ~3K, 4-5 EA ~5K, 6+ EA ~7K; con ~5 EA rischio per EA 1/3–1/5.
- OnlyUp: lotti calcolati sul massimo balance (Global Variables MT5, F3); reset con "Reset Highest Balance" e riavvio; ON per conti personali, OFF per prop; con OnlyUp, Auto TradeFrequency non scende (Wim 16/10).

## Dettaglio #automated-support

Totale raccolto canale: 1285 msg dal 01/10 al 03/11 (578 di Digital_Wim bot, 63 di Wim The Algo Trader), 116 msg con immagini.
Metodo: messaggi utenti e Wim integrali; risposte bot integrali se contengono licen/activat/autoloader/onechart/onlyup/demo account/999/9999/123/minimum balance (max 1500 car.), altrimenti prime 220 car.

- 01/10 Wim (vero): lot GR diversi per strategia (0.01/0.02/0.03), "fai un backtest 2026".
- 01/10 bot: Max Allowed Total Drawdown = solo input di sizing, non ferma mai l'EA; cambiarlo non modifica trade aperti.
- 01/10 bot: GR leva bassa 1:20 → min ~3k e MaxAllowedDD ~10. Gold EA: $600 minimo alto rischio, $1500 confortevole; 3-4 EA ~ $3000; UBS+GR stesso conto preferibile >5k.
- 01/10 bot: esempio estremo GR 400→72k (65.201%) con Mode Extreme, MaxAllowedTotalDD 204 ("insane high risk", non raccomandato).
- 01/10 Licenza "invalid license": URL consentiti in MT5 Options→Expert Advisors: forexeasolutions.com, tradewithwim.com, worldtimeserver.com, nfs.faireconomy.media; se acquistato su MQL5 lasciare VUOTO "License Key (for non MQL5 version)"; se dal sito: chiave + numero conto MT5 in uno "slot" su ManageAccounts (tradewithwim.com) → Update. Account demo/live deve corrispondere a quello inserito.
- 01/10 BIGDEX: Luna "invalid license" → risolto (problema acquisto MQL5 non visto in Market).
- 01/10 Wim: per EA bonus ricevuti direttamente da lui senza licenza → aggiornamento nel portale tradewithwim con chiave universale "EA_DOWNLOADS_WSC" (solo EA MT5 ricevuti direttamente da Wim; NON per MQL5 né per acquisti sul sito).
- 01/10 Wim: Prop firm GR: impostare solo Randomization=75; gli Adjust* sono offset fissi.
- 01/10 bot: Luna + GR stesso conto ok (grafici separati, magic diversi). Luna: StartLots 0.01, Risk_Per_Trade 0.5, LotsizeStep per profilo.
- 01/10 p87z domande tecniche UBS V7.7 AutoLoader (backtest speed 1-4, OnlyUp). Bot: AutoLoader legge da ogni set i settaggi, ma override globali dal dialogo: "Override Autoload Lotsize/Newsfilter/Trading Time/Prop Firm settings"; "Force Max Pending Orders per strategy"; "Adjust Lotsize To Variable Values" overridabile solo a false; "Max Historical Drawdown ($) at 0.01 lots" sempre dal set.
- 03/10 Wim risposte a p87z: OnlyUp high-water salvato nelle Global Variables di MT5 (F3); backtest speed veloci: solo con real ticks, saltano tick / controllano pochi tick attorno alla nuova candela M1, nessun controllo saltato; Adjust lotsize to variable values: lot = StartLots*(prezzo attuale/valore default) (oppure ATR attuale/ATR di riferimento).
- 02/10 bot: Reset highest balance = azzera il picco OnlyUp (OnlyUp dimensiona sul massimo balance mai visto).
- 02/10 Wim: nessun limite set per grafico ora, raccomanda max 50 per grafico ("2 grafici con 50 ciascuno"). Bot: AutoLoader NON gira su VPS MQL5.
- 02/10 Wim: GR: disattivare singole strategie solo con TradeFrequency = "Manual Strategy Selection".
- 02/10 Wim: "non c'è lot step in Gold Reaper" (Lot step è di UBS Scalp C).
- 02/10 NFP filter GR: chiude pending/live 100 min prima, riprende 60 min dopo (eyalperel/Ash).
- 02/10 bot: aggiornamento UBS: non serve cancellare pending; GR ultima versione rimuove automaticamente pending di strategie non usate.
- 02/10 Classicaltrading UBS "invalid price" sell stop limit XAUUSD+.
- 01/10 bot: GR Vantage → AutoGMT=true + worldtimeserver URL.

## chunk 2 (03/10 04:57 → 06/10 03:26)
- 03/10 Wim: GR + Luna su un conto: minimo "direi 1000$". Luna LotsizeStep 100 su $2000 "piuttosto aggressivo". 04/10 Wim: "sì" a GR Moderate + Luna step 200 su $2000.
- 03/10 bot: Luna LotsizeStep: low 500 / medium 200 / high 100 (setup guide); set Luna: highRisk 70, MediumRisk 150; "step 200 ≈ 25% DD, 1000+ conservativo".
- 03/10 bot: guida capitale: ~$2000 = 1 Gold EA + DTP + Luna; ~$3000 = 2 Gold EA + DTP...
- 03/10 bot: GR minimo $600, confortevole $1500+.
- 04/10 bot UBS Max Risk per Strategy: standard 1%, conservativo 0.5%, moderato 5% ≈ DD totale <15% (KB); 20 strategie moderate → ~3.
- 04/10 Wim CORREZIONE: "Max risk in $" è RISCHIO PER TRADE (50$ per trade), non esiste "risk per strategy in $"; se una strategia ha più trade, più SL da ~50$. Wim: "verrà insegnato nella prossima discord harvest dalla mia altra AI".
- 04/10 bot: set live-signal GR: TradeFrequency 2 (Moderate), MaxAllowedDD 30, MaxRiskPerStrategy 1, StartLots 0.01, Risk code 1234, UseEquity false, OnlyUp true, Randomization 0, MaxSpread 500, magic 8000, NFP filter true, FridayStopHour 25.
- 04/10 bot: tipi rischio GR: StartLots fissi; Max Allowed TOTAL DD %; Max Risk Per Strategy % (1% cons., 2-3% mod., >5% aggr.); Weighted Lotsize; UseEquity; OnlyUp; Max DAILY DD (prop).
- 04/10 bot: OnlyUp + prelievo grande → "Reset Highest Balance for OnlyUp"=true, riavvio, poi false; ricalcolo lot a variazioni >5% balance o riavvio.
- 04/10 BIGDEX: Luna mostra balance 3005 vs reale 1958 → Ash: Tools→Global Variables → cancellare highest balance, riavviare. 05/10 Wim: è OnlyUp che ricorda il balance massimo.
- 04/10 bot: news filter NFP/IR/CPI default 100 min prima / 60 dopo, close trades & pendings.
- 04/10 bot: versioni: DTP 4.3; Luna AI Pro 1.50.
- 05/10 OneChart/AutoLoader rischio comune: Wim (testato su UBS V8.1): A) autoloader ON, B) Override lotsize settings = true, C) Lotsize calculation method = use max risk per strategy, D) valore Max Risk per Strategy. Non serve impostarlo in ogni set (è lo scopo dell'override). Max Historical DD at 0.01 resta dal set.
- 05/10 bot: 3 approcci rischio con AutoLoader: rischio di ogni set (override false); lotto fisso comune; % comune.
- 05/10 Wim: dopo deposito con MDD 30% e pending vecchie → "puoi sempre rilanciare l'EA".
- 05/10 bot: cartella "recommended combo setup": set "Gold 3" (3 EA) e "Gold 4" (4 EA).
- 05/10 bot: set GR nel pack nominati per DD: gold_reaper_10%maxrisk.set, 15%...; "low-risk live-signal" MaxAllowedDD 7.
- 05/10 bot: Portfolio Setup E: GR/GP MaxAllowedDD 7; non si può garantire DD <6%.
- 05/10 bot: set live Gold Phantom (Myfxbook): TradeFrequency 3, MaxAllowedDD 30, MaxRiskPerStrategy 1, StartLots 0.01, Risk 1234, OnlyUp true, UseEquity false, MaxSpread 500, magic 75000, AutoGMT true (GMT 2/3), UseMQL5Calendar true, NFP on (100/60), IR/CPI off, AdjustLotsizeToVariableValues true, CheckMargin true.
- 05/10 Goldtrade Pro: OnlyUp=1, UseEquity=0 → pannello mostra balance più alto.
- 05/10 TGR news filter solo NFP/IR/CPI (no PMI).
- 05/10 royst1: backtest UBS complessi 3,5 giorni; chiede Ryzen 9 9950X.
- 06/10 bot: manuale UBS V7.0 sezioni 1-32 (Licence Key, InfoPanel, AutoLoad Set Files (OneChartSetup), Custom Optimization, Spread, Backtest Speed, Variable Values, entry models Volatility/S-R/Range, Prop Firm, Lot-size, GMT, news, Fake Breakout, Trading Hours). Nessun dato su "UBS Christmas v3".
- 06/10 bot: deposito: EA vede il nuovo balance; con OnlyUp serve reset.

## chunk 3 (06/10 03:26 → 08/10 15:19)
- 06/10 nongiooo: dove sospendere abbonamento mensile (nessuna risposta). Ronybulffer: abbonamento $99/mese, email sbagliata → Wim: "ti ho mandato una email" (si lamenta di 10 messaggi ripetuti).
- 06/10 bot: MaxAllowedDD non monitora il DD live, non chiude trade; non cambia distanza SL.
- 06/10 bot OnlyUp: pensato per conti personali di lungo periodo, recupera più in fretta ma DD più profondo; "è una scelta di rischio, non protezione".
- 06/10 bot: starter bundle = Gold Bundle (GR, Gold Trade Pro, Goldbot, Gold Phantom).
- 06/10 bot: UBS live 44-signal = portafoglio 44 strategie + Gold Scalp C + 1 set scalp di un cliente.
- 06/10 meanroaster: crash GR 5.1 su VPS MQL5 (MT5 build 6241, XMTrading, London LD6) "NetDispatcher thread timeout possible deadlock"; in locale ok. Nessuna soluzione documentata.
- 06/10 bot: nei set ufficiali NFP true, IR false, CPI false.
- 06/10 bot GR "high risk" = gold_reaper_60%maxrisk_HighRisk.set; floor 0.01 lot su conti piccoli.
- 06/10 bot: Conservative = strategie 1-5, DD portfolio @0.01 ~$330.
- 06/10 bot: minimi: 2-3 EA ~$3000; 4-5 EA ~$5000; 6+ EA ~$7000; conto cent come workaround su depositi piccoli; con 3 EA rischio ~1/3 per EA.
- 06/10 royst1: backtest DTP EURUSD 10 anni 0.01 lot: DD 0.19%, PF 2.19, netto 1695.30, 1445 trade; forward 2024-2025 PF 1.44, DD 0.12%, 306 trade (+135.84); real ticks: +96.69, PF 1.31, DD 0.13%, 301 trade. Non buono su altre coppie. Bot: "verificare sempre su demo prima del live".
- 07/10 bot: confronto -35% vs -5.4% in 24h tra portafogli con TGR (stesso cap 30%): differenze set default vs live signal settings, TradeFrequency 5 vs 2.
- 07/10 Wim: pannello GR balance "bloccato" = OnlyUp; reset con "Reset Highest Balance" dopo rilancio EA.
- 07/10 Wim: "consiglio vivamente di leggere il manuale per un prodotto che costa 949$" (GR); allega FILE "Gold Reaper my_live signal settings.set" 5.54 KB (ufficiale Wim).
- 07/10 bot: TradeFrequency GR: Extreme conservative (1-3), Conservative, Moderate, Intense, Extreme + Auto.
- 07/10 Wim: set UBS restano gli stessi con gli aggiornamenti (V7.9 ex5 con set V7.7); OnlyUp highest balance = global variable (CTRL+F3/F3).
- 07/10 Fabio M: GR ricevuto da Wim legato a 2 conti MT5 → bot: email info@/wim@forexeasolutions.com (ma vedi chiave EA_DOWNLOADS_WSC del 01/10).
- 07/10 UBS "init failed code 1": licenza/URL/file posizione.
- 07/10 bot: GR news filter solo NFP (no FOMC).
- 08/10 Strider: conti cent ($10=1000...).
- 08/10 Wim CORREZIONE su Auto TradeFrequency: i valori non sono "budget" ma i max DD a 0.10 lot; l'EA li usa con Max Allowed Total DD per decidere quale frequenza usare. Bot: budget = Balance × MaxAllowedDD ÷ 100.
- 08/10 bot: lot ricalcolati quando balance cambia ~5%, EA rinnova pending.
- 08/10 bot: UBS live performance su pagina prodotto MQL5 133653.
- 08/10 UBS trailing: sez. 17 Trail SL distance / start distance.

## chunk 4 (08/10 15:19 → 12/10 23:10)
- 08/10 bot: UBS ottimizzazione: usare Custom Optimization Settings con i valori pre-impostati da Wim nei set di ottimizzazione (min Expected Payoff, Recovery Factor, min trade).
- 08/10 Jan: Stability_Pro_WSC_V1.8 EURUSD M5 "zero divide" riga 711 → errore nel codice compilato, segnalare a Wim.
- 08/10 bot UBS: Use Virtual SL nasconde solo SL (TP resta reale), "Hard SL distance" di backup.
- 09/10 bot UBS: nessun parametro timeframe nel set: la strategia gira sul TF del grafico.
- 09/10 GR FridayStopHour=25 = disattivato; 22/23 per chiudere venerdì (ora server) (Ash).
- 10/10 bot broker: raccomandati IC Markets, IC Trading, Vantage (RAW/ECN); Exness "ok". Leva: esempi Wim fino a 1:500.
- 10/10 bot: Darwinex/Darwinex Zero, GKE flagship DARWIN (live da nov 2020), >3M capitale investitori.
- 10/10 Wim: "Moderate dà il miglior rischio/rendimento; poi imposta il max DD che puoi sopportare. Non usare Moderate sotto 1000$ salvo che ti piaccia l'alto rischio."
- 10/10 bot CheckMargin: verifica solo se il conto può sostenere il margine dell'ordine; nessuna soglia, nessun retry documentato.
- 10/10 bot (Profalgo_SetFileReference.md): MaxAllowedDD "solo sizing, non ferma l'EA; alzarlo = più profitto e più DD in proporzione". MaxRiskPerStrategy = metodo per Gold Trade Pro e UBS; UBS: 3 basso, 6 medio, 10 alto; portafoglio 44 strategie usa 3. LotsizeStep: numero più alto = più conservativo. Weighted lots/UseVariableValues: lasciare al valore del set. OnlyUp: ON per conti personali lungo termine, OFF per prop.
- 10/10 bot (articolo Gold EA di Wim): con più EA ridurre rischio; con 5 EA rischio 3-5x più basso; set pronti in zip "setsAndManuals" su Discord (privati e prop). GR live esempio: TradeFrequency 2, MaxAllowedDD 15 (?), UseWeightedLots true, MaxRiskPerStrategy 1, OnlyUp true, CheckMargin true. Minimi 3K/5K/7K+.
- 10/10 bot: UBS default = ottimizzazione XAUUSD Daily con 10+ anni OOS; pacchetto contiene TUTTI i set mai sviluppati da Wim (basi di DTP, GTP, GR, Goldbot One, Indicement); da v5.0 rielaborati per AutoLoad/OneChartSetup + MaxRiskPerStrategy con max DD storico per set.
- 10/10 *** LICENZE (Kumar, bundle con "10 license"; sito tradewithwim mostra 20 slot): bot cita FAQ: "Un acquisto sul sito ForexEASolutions dà 10 slot conto per EA, modificabili nella dashboard dopo l'acquisto. Il DEMO CONTA COME UNO SLOT." = 10 numeri conto MT5 (live/demo), non legato a VPS/PC. Attivazione: tradewithwim.com/manageaccounts, URL tradewithwim in MT5, chiave → SEARCH → numeri conto → Update; chiave nell'input EA. Motivo dei 20 slot non documentato.
- 10/10 Portfolio set A-E: nessuna tabella minimi.
- 11/10 bot Luna: LotsizeStep low 300 / medium 150 / high 70 / prop 700; StartLots 0.01. (incoerente con 03/10: 500/200/100)
- 11/10 Wim: con LotsizeStep come metodo, StartLots e risk per trade non contano. Bot: "Risk è un codice che seleziona la modalità di sizing". Wim: "sì, sono Wim... imparerai entro domattina".
- 11/10 UBS nuova opzione ReverseTrades (Breakout S/R): buy stop → sell limit, sell stop → buy limit, off di default, set esistenti invariati. JOHN: testati 57 set, ReverseTrades perde ovunque vs baseline; serve ottimizzare set nuovi. Broker limit ~150-200 pending.
- 12/10 bot: Myfxbook Wim = myfxbook.com/members/strueli.
- 12/10 bot setup UBS (sito): URL forexeasolutions.org, forexeasolutions.services, worldtimeserver, nfs.faireconomy.media; dashboard → Licenses → incolla numero conto → Activate. Max bars 1000. (Nebrsw comprato su MQL5: zip con set, set-file editor v7.2, manuale.)
- 12/10 !R7: "ho bruciato il mio primo conto aumentando il rischio per errore".

## chunk 5 (12/10 23:10 → 17/10 15:57)
- 12/10 bot UBS principiante: modalità singola strategia con UseAutoLoader OFF; max historical DD a 0.01 = da backtest a 0.01 lot fissi.
- 13/10 Wim: link performance live su app.karnek.com/profile/tradewithwim.
- 13/10 dhruv: comprato Gold Bundle, vuole pagare differenza per "Big Beautiful Bundle" (BBB) → Wim risponde in PM.
- 13/10 bot: GR+GP insieme "non è un lavoro da 1000$"; Phantom solo: 600 alto rischio, 1500 consigliato, 2000 ok.
- 14/10 bot UBS: min lot broker letto automaticamente da MT5.
- 14/10 Mr.B ReverseTrades ancora BUY STOP → Wim: va cambiato il parametro IN OGNI SET, non è un parametro "cambia tutte le strategie in un colpo" (con autoloader). Bot cita UBS v8.2 = versione con ReverseTrades.
- 14/10 rbgold: set 44 UBS, broker GoMarkets usa WS30 invece di US30 → errore "Symbol US30 not available"; cambiare US30_Symbol negli input; non risolto, rimandato a email.
- 14/10 Wim: per GR usa SOLO filtro NFP (non CPI/IR). langesi: suo BT dice meglio tutti e 3. Wim: ognuno decide.
- 14/10 finpotaatti: 4 conti FTMO stesse impostazioni prop, uno con ordini diversi.
- 14/10 bot GR: 600 alto rischio / 1500 confortevole / 2000 ok; GR = breakout puro XAUUSD, fino a 9 strategie, pending BUY_STOP/SELL_STOP; livelli teorici uguali per tutti (Randomization li sposta). Nessun filtro overnight.
- 14/10 Andrew Soma: formula "Custom Max" UBS (EP vs RF peso) – non documentata.
- 15/10 bot: minimi 2-3 EA 3K, 4-5 EA 5K, 6+ 7K; ~5 EA rischio ~1/3; set portafoglio in zip "setsAndManuals".
- 15/10 Wim: set 3Gold = per 3 Gold EA insieme; 4Gold = per 4; con solo 2 Gold EA sullo stesso conto usare il set low risk per ciascuno (NON per prop firm).
- 15/10 bot: DTP set portafoglio (daytrade_combo.set) RunOneChartSetup=1 e OneChartSetupPairs pieno → corretto.
- 15/10 bot: dopo update EA su MQL5 bisogna ri-migrare sul VPS MQL5.
- 15-16/10 GR TradeFrequency Auto: TCLEONG backtest sale solo (Moderate→Intense). Wim: "sì scende anche, ma con OnlyUp usa sempre il balance massimo quindi non scende".
- 16/10 sdeyter: ScalpH1_C UBS risk per strategy 4%, HistoricalMaxDD=17, OnlyUp true; balance 92.000 → 45.900 USD (calo ~50%); EA apre ancora 2.17 lot (=0.01×4%×92.200/17) → rischio effettivo ~8%. Bot non conferma formula; rimanda a Wim.
- 16/10 bot UBS Variable Values: Default ATR value >0 abilita scaling degli input in pip.
- 16/10 bot: Scalp_C nel zip UBS: Breakout Support Resistance → gold → scalper → gold scalp c (XAUUSD H1). 17/10 bot: live Scalp C usa LotsizeStep 80.
- 16/10 bot: link Telegram UBS solo da Wim in DM per acquirenti.
- 16/10 bot: broker con min lot 1 (contract size diverso): fare backtest sul proprio broker e inserire DD in $ al lotto corrispondente.
- 17/10 bot AutoLoader: mettere i .set in MT5 → Common → Files → "Sets" (o cartella propria), UseAutoLoader ON + cartella; override false = ogni set suo rischio; true = Max Risk per Strategy uniforme.
- 17/10 bot timeframe: GR & GP H1; GTP & Goldbot One Daily; Luna M5 (OneChartSetup); DTP Daily (OneChartSetup); UBS OneChartSetup (simbolo host qualsiasi).
- 17/10 bot set GR (v5.4): gold_reaper_default.set (MaxAllowedDD 30), _10%maxrisk ecc.

## chunk 6 (17/10 15:57 → 23/10 13:30)
- 17/10 Nebrsw: orbmaster_combo_setup.set errore "Wrong step or stop" (era in modalità ottimizzazione); input = MaxRisk_Strategy=2 nel set.
- 18/10 bot broker: IC Markets (non-EU/AU), IC Trading (EU/AU); (altrove anche Vantage).
- 18/10 bot: manuale GR più recente nel KB = v4.3 (dic 2025), EA GoldReaper_MT5_WSC_V4.6 (KB obsoleto; utenti parlano di v5.1/5.4).
- 18/10 bot UBS: due grafici single-strategy (UseAutoLoader off) non dipendono dalla cartella Sets; AutoLoader esegue solo i .set presenti nella cartella ("Folder with .set files", default Sets); per 40 strategie tenerle tutte nella cartella con magic unici. Grafico consigliato H1.
- 18/10 bot VPS: Wim elenca forexvps.net (link affiliato); Windows VPS.
- 18/10 Tomasarnau: 5k/30% vs 10k/15% → 19/10 Wim: "girerà esattamente uguale, ma 30% su 5K crescerà più velocemente ovviamente".
- 18/10 bot: aggiornare EA non cancella pending (stesso magic).
- 19/10 bot UBS: 1M OHLC per ottimizzazioni grandi, conferma con real ticks; backtest sul TF del nome del set (es. 1H). "UBS default = oro D1".
- 19/10 bot: UBS gold scalp: singola strategia da ~200$; multi-strategia Max Risk Per Strategy 3 medio.
- 19/10 bot: GR default: StartLots 0.01, "Risk 1234 (codice che attiva il metodo Max Allowed Total Drawdown, non è un %)", MaxAllowedDD 30. Nessuna tabella lotti per 3000$ → provare su demo.
- 19/10 bot: OnlyUp su UBS "non documentato" (contraddice altre risposte). GR OnlyUp: reset rimuovendo e riattaccando con Reset Highest Balance=true.
- 20/10 Anan22: broker min lot 1, set bk_TESLA in backtest apre 160 lot anche in Manual Lotsize: AdjustLotsizeToVariableValues=true, LotPerBalance_step 1000, MaxLots 1000 → lotto scala comunque.
- 20/10 3372: Luna licenza tradewithwim "invalid" su nuovo VPS → Wim: mettere chiave nell'EA e URL in MT5; causa: caricando il set default si cancellava la chiave.
- 20/10 bot: nessuna classifica set UBS a DD più basso; nessun sito con backtest pronti.
- 21/10 bot: Max Risk per Strategy non si auto-adatta al numero di set; 44 strategie live = 3.
- 21/10 Wim: "per ora è semplicemente 3% di rischio per strategia; con la mia nuova app UBS Optimization (in arrivo) l'app calcolerà il miglior bilanciamento per tutte le strategie".
- 21/10 bot: $5000+ → Wim tipicamente 4 Gold EA + 2-3 EA non correlati.
- 21/10 akiva: GR fermo, oro in range (scherzi); bot: GR ~1 trade... a non-Extreme.
- 21/10 Ukrit: UseTradingTimeZones false = ora server broker; true = timezone sessione.
- 22/10 bot kit UBS: EA MT5 + 100+ set prebuilt...
- 22/10 Ash: highest balance OnlyUp in Tools → Global Variables.
- 22/10 GA: abbonamento mensile Shopify (solo GR) come cancellare; bot: bundle Gold/BBB $1.249 una tantum, aggiornamenti a vita.
- 23/10 Wim: UBS XMAS set è nello zip set UBS. combo.zip: Wim "è in #plug-and-play-eas, è AllSetsAndManuals.zip".
- 23/10 bot: gruppo Telegram UBS solo acquirenti, invito da Wim.

## chunk 7 (23/10 13:30 → 30/10 04:30)
- 23/10 Ukrit: UBS Range breakout con Risk per trade in $ usa lotto minimo; Pepperstone US500: conto A 50$/trade → 3.4 lot, conto B 20$/trade → 0.1 lot (incoerente). Bot: altro driver (HistoricalMaxDD, step volume).
- 23/10 bot: LotsizeStep (Lots per balance): 0.01 lot per ogni LotsizeStep di balance (più alto = lotti più piccoli).
- 24/10 bot: OnlyUp=false → lotti da balance corrente (scendono dopo perdite). Per partire dal balance attuale con OnlyUp: Reset Highest Balance una volta.
- 24/10 *** CODICI RISK: bot: "Risk = 1234" = codice che seleziona il blocco StartLots / Max Allowed Total DD (contraddittorio: 19/10 diceva 1234 = Max Allowed Total DD). Mr.B (utente, 27/10): "Risk=123 è MaxRiskPerStrat, Risk=9999 è LotPerBalance"; chiede codici per StartLots, Manual_RiskPerTrade, MaxRiskInDollar_input. Bot: codici (123, 9999, 1234, 99999) "ID interni di modalità usati in specifici portafogli, non documentati globalmente"; nessuna tabella; consiglia di usare il Risk del set ufficiale. GTP low risk set ha "Risk 3".
- 24/10 bot UBS OneChart OnlyUp: con Override Autoload Lotsize Settings controllato globalmente; altrimenti per singolo set; nessun switch globale dedicato documentato. Nessun editor batch dei set.
- 24/10 LFX: dopo update UBS pannello 0 lot → impostare metodo lotsize e valore non zero in override, o ricaricare/salvare ogni set nella nuova versione.
- 24/10 Wim: cambiare OnlyUp non modifica le pending esistenti; "meglio riavviare l'EA con le nuove impostazioni, l'EA rimuoverà le vecchie pending se necessario".
- 25/10 AC: UBS aggiornato a v8.6 (MQL5) → "license not valid" → Wim: "fixing it now... fixed" (bug lato licenza risolto da Wim).
- 25/10 bot: set GR per 2000$: 10% conservativo, 15% ...
- 25/10 bot Scalp C: LotsizeStep; disattivare trailing = Trail SL start distance 0. Zena: venerdì TP pieno con VPS spento (aggiornamento Windows).
- 26/10 bot: broker con GOLD# (XM): ForceSymbol nel set (con Autoloader va scritto dentro ogni .set file).
- 26/10 bot: maxHistoricalDD sempre misurato a 0.01 lot.
- 26/10 Mircolup cita Wim: "uso LotsizeStep=80. DD storico ~15$ a 0.01 lot quindi DD dovrebbe restare sotto 20-25%"; per 40-50% → bot: step più basso (circa metà, non formula).
- 26/10 Scalp C con leva 25 nel tester → margine insufficiente.
- 27/10 bot: GTP "meglio far girare tutte le strategie"; vecchia nota "small account 3+4+7 / 2+4+7".
- 27/10 bot: GR per strategia solo DD a 0.01 (tabella strategie 1-9).
- 27/10 bot: UBS Xmas dentro "UPDATED SETS UBS_V8.3.zip".
- 27/10 broker: IC Markets (ASIC+CySEC, non-EU/AU), IC Trading (FSC Mauritius, EU/AU, leva fino 1:500, swap-free su richiesta), Vantage "ok"; set validati su IC (Raw/ECN), non ottimizzati per Vantage.
- 28/10 bot GTP low risk: Goldtrade_V4.0_low_risk.set: MaxRiskPerStrategy 1.5, Manual_RiskPerTrade 1.2, StartLots 0.01, LotPerBalance_step 600, Risk 3, OnlyUp 1; medium/high MaxRiskPerStrategy 3 e 6.
- 28/10 Wim: più grafici con setup diversi ok "se hai fatto i compiti su ciascuno".
- 28/10 Luna: AutoGMT 1, GMT winter 2/summer 3 → nessun cambio ora legale.
- 29/10 chrisc0720: risk $100/trade ma SL 2-3x → Wim: "hai davvero impostato Lotsize Calculation method = use Risk Per Trade in $/€? altrimenti non ha senso". Bot: UBS docs "non usare Risk per trade % se strategie hanno SL molto diversi".
- 29/10 bot: usare rischio dei singoli set con AutoLoader = Override Autoload Lotsize Settings false.
- 29/10 standalone gold EA: righe lotto 0.00 su default = normale (si popola con ordini).
- 30/10 bot: VPS Wim = ForexVPS (link affiliato).

## chunk 8 (30/10 04:30 → 03/11 19:55, fine)
- 30/10 Wim (a chi non vede lotti): "simbolo sbagliato, login con password investor, algotrading non abilitato".
- 30/10 SAMIE: set GR ottimizzato usa TradeFrequency Auto + StartLots, ma manuale GR: "quando usi StartLots DEVI impostare anche la trade frequency manualmente" → nessuna risposta.
- 30/10 bot: solo GR descritto con Trailing SL/TP; news filter gold EA: NFP on di default, CPI/IR off (GR 3GOLD/4GOLD EnableCPI false).
- 30/10 bot UBS: "l'EA non può modificare pending esistenti" → modifiche SL valgono solo per nuovi ordini.
- 30/10 bot GR: minimo $600, consigliato da $2000+.
- 31/10 Wim: in UBS tutte le distanze (Exit_stop, TrailSL ecc.) sono in PIPS, frazioni possibili.
- 31/10 Ukrit: set UBS Range Breakout con **Risk=999**, override false nei set, AutoLoader override Risk Per Trade 0.25%, Force Fixed Manual Balance 8000 → lotti minimi; warning "US500 wants 0.0259 lots ... broker minimum 0.1 – will risk about 3.9x its share". Bot (glossario): "Risk = metodo di calcolo lotto, non percentuale; codice interno della modalità attiva"; tabella codici non documentata; Force Fixed Manual Balance: "dimensiona da questa cifra invece del balance reale, 0 = balance conto"; metodi risk-based calcolano dal SL reale (Range Breakout lato opposto → lotto varia). Rimanda a Wim.
- 01/11 bot: backtest: real ticks (model 1) per scalper (Scalp C); 1M OHLC (model 0) ok per H1 breakout (GR, GP).
- 01/11 **Claudio** (utente nuovo, conto personale IC Markets, poi prop): bot: UBS non plug&play; partire dal portafoglio live 44 strategie (nello zip set UBS); live: Wim ~3% per strategia, mai >6% sul 44; prop: ~0.5% per strategia; UBS preferito da Wim per prop (strategie uniche, meno "copycat"). Claudio $3000 → "$3000 è circa la dimensione che Wim ha in mente per il 44 completo"; Autoloader: Override Autoload Lotsize=true, Max Risk Per Strategy=3, metodo "use Max Risk Per Strategy"; conservativo 1.5-2; demo prima. Non serve modificare i 44 set.
- 01/11 bot GR Moderate 0.01 su $2500 → riferimento live signal settings. GTP default Manual lotsize 0.01 per strategia.
- 01/11 arielguti: EA non funziona, idsme: aggiungere URL in Tools→Options (è nella guida).
- 02/11 bot: GMT "unconfirmed offset" UBS: problema worldtimeserver, fix in UBS 9.0+ e 9.5 (Michael_ su v9.5 ancora avviso → solo informativo).
- 02/11 finpotaatti: "trade disabled", errore 4756.
- 02/11 Ukrit: contract size NAS100 Pepperstone 1 vs TMGM 10 → historical max DD da adattare (bot).
- 02/11 bot: GR raw vs standard: "lo spread non conta molto" per GR, slippage più importante. Leva 1:500 "più che sufficiente", non obbligatoria.
- 03/11 bot GR: MaxDD 50→100 non cambia numero trade, solo lotti.
- 03/11 bot: GR live signal MQL5 "New V2 2": mql5.com/en/signals/2265877; broker/spread non documentati.
- 03/11 Seanexmartingale: $100k da allocare su UBS, già portafoglio raccomandato su conto $10k (nessuna risposta letta).
- Versioni citate nel periodo: UBS 7.7/7.9 → 8.1 → 8.2 (ReverseTrades) → 8.3 (zip set) → 8.6 (25/10) → 9.0+/9.5 (02/11); GR 5.1, 5.4; Luna 1.50; DTP 4.3; Stability_Pro 1.8.

## Dettaglio #general-trade-talk

## chunk 1 (01/10 → 13/10 12:50)
- 01/10 Tony: ricarica conto senza toccare EA ok (prossime pending ricalcolate); per effetto immediato cancellare pending. Prelievo: cancellare pending e lasciare rigenerare, altrimenti rischio margin call.
- 01/10 Wim: SL/TP virtuali solo se il broker dà avvisi di iperattività; altrimenti normali meglio. langesi: virtuale richiede bassa latenza.
- 01/10 utenti: DM di scammer frequenti.
- 02/10 IanL123: Gold bundle per prop (FTMO swing) → community sfavorevole alle prop ("stay away").
- 02/10 Gabriel007: ForexVPS Prime: MT5 chiuso durante NFP → EA non cancellava pending → perdita ~12% portafoglio; Contabo ok. Consigli: server dedicato (JOHN, Rainy), notifiche (healthchecks.io). 03/10 Wim: con lo strumento Karnek si riceve notifica se MT5 non gira.
- 03/10 Wim banna un utente (messaggio rimosso).
- 04/10 Wim: "sfrutto al massimo i miei assistenti AI"; molti update UBS.
- 04/10 malek: $1200 IC Markets, UBS + tutti gold EA, ha raddoppiato il conto "per errore" senza controllare.
- 05/10 langesi: slippage in calo (estate poco volume). Tool MQL5 per stop daily DD (product 28252, 165444).
- 06/10 grosso DD (GR): Alicanto -30%; Flygplan (yolo MaxDD 204) "giù ben più di 30k, peggior DD da quando ha iniziato yolo" (~70% da ATH secondo altro utente); Wim: "sei giù circa 1 mese di profitti?". DanM: yolo 204 + 5.8 per strategia, +120% 10 giorni prima. Rudolf: yolo 1k demo e 1k live azzerati in 2 settimane.
- 06/10 Wim: Fake breakout filter non prende tutti i falsi breakout; chiude se candela chiude bullish (per sell) e sopra l'entry (o bearish/sotto per buy).
- 07/10 crollo EA grid altrui (Quantum Queen/Bogdan, segnale MQL5 2234595, "77k usd gone"); utenti: nessuno qui con rischio ragionevole ha perso tutto.
- 07/10 markushka99: GR set YOLO (quello del "400$→130k"), $1400 → $691 (-50%) in 1 settimana; backtest 4 anni DD 50-80%. Rudolf: 1000→380; demo 1000→1900→550. Eugen: yolo 200% +100% lunedì, ritirato deposito, ridotto a 150%; ieri -50%. Consiglio: ritirare profitti subito. sattysingh: "medium risk con OnlyUp è meglio".
- 08/10 Wim: set Luna aggiornato in #plug-and-play-eas. JOHN: SL virtuale/set SL TP after entry solo se broker avvisa iperattività.
- 08/10 Anan22: correlazione EA breakout di Wim → laterale prolungato rischio.
- 09/10 DiiZi: gap Tesla all'apertura.
- 11/10 Steve: migrazione GR su VPS MT5 errore dll communicatorplugin10.
- 12/10 Wim: "io e Jimmy andiamo forte su EasyAlgos".
- 12/10 *** Scandalo "Huy Tran": utente che vendeva in DM set/EA (set 200$, EA 100$) spacciandoli per propri; Jeremy (Mentor) condivide FILE "UBS_5.0 - 5 GOLD SET PORTFOLIO.zip" 89.92 KB (set UBS, D1/H4, con autoloader; contiene la chiave UBS di Tran). maindfriik/Tom: sono set di Phantom/Gold EA esistenti travestiti; strat4 meno correlata. langesi BT 01/2024→oggi a 10% DD per set: "rischio/rendimento non male ma niente di nuovo". Tran bannato. Wim: "non sembra buono per Tran".
- 12/10 pipraider: stesso GR su IC Markets (2 ms) in profitto, su Darwinex (70 ms) leggera perdita; Gold Trader uguale su entrambi.
- 13/10 Wim nuovo video YouTube.
## chunk 2 (13/10 → 25/10 20:23)
- 14/10 *** Wim (a !R7 su capitale per tutti gli EA): "Non farei girare TUTTI gli EA su 1 conto. Farei più setup con 4-5 EA, circa 5K per conto"; per 15-20k "dividerei su 3-4 conti, magari 5 (uno piccolo ma aggressivo). Esempio: A) piccolo 1500$: Gold Reaper high risk + set Gold Scalp C; B) 5K: Gold Reaper + Daytrade Pro + Luna; C) 7K: 3 Gold EA; D) 5K: portafoglio UBS (44-strat o Xmas)". 44-strat e Xmas = portafogli UBS nello zip set UBS (3372: cartella "UBS live portfolio", con set del one chart EA).
- 15/10 Ákos (BBB, $2-5k) chiede portafogli. Rainy-: niente prop con EA (ban per combinazione); propone GR 20% maxDD + Goldbot One 1%/strategia + GTP 1%/strategia + Gold Phantom 20% maxDD + Luna LotsizeStep 1000 → "300% l'anno scorso", DD atteso 35-40% (25% in backtest). Myfxbook Rainy: portfolio 11576068. Con UBS non servono gli altri EA, può replicarli.
- 15/10 3372: difficile tradurre "20% max dd GR" in UBS; usa 3% o 2% per strategia.
- 15/10 Dey: BlackBull conto Prime, leva 1:500.
- 15/10 Rainy- inoltra FILE "UPDATED SETS UBS_V8.3.zip" 2.56 MB (manuale aggiornato + set client Bitcoin di BK) – originale di Wim.
- 15/10 Wim: sta creando "UBS Optimizer app" per lanciare tutti i backtest e creare portafogli.
- 15/10 Rainy: metodo: set non correlati, rischio per ciascuno; se live supera 50% del max DD di backtest → panchina; backtest real tick dal 2018 (oro dal 2014), uno per uno. Pepperstone dati gold real tick dal 2018; MetaQuotes demo affidabile dal 2014.
- 16/10 a.l.r._: conto 'pure' Luna (6 grafici), niente più strategia 9 TGR sui conti principali.
- 18/10 langesi: GR minimo 3000€ ("1000 troppo poco"). Eugen: con 1000$ e 10% DD il lotto minimo non lo permette.
- 18/10 princeboto: aneddoti (non verificati) di amici con GR: 500→3000$, 9000→100000$, 300→900$.
- 19/10 *** Wim: "non vuoi strategie che vanno bene solo sui tuoi dati, ma su tutti i broker... crea strategie i cui grafici 1M OHLC somigliano molto a quelli real ticks. Tutto ciò che sembra molto peggio su real ticks andrà male live."
- 19/10 Lox: storico real tick broker solo 1-3 anni, prima dati MQL5; Dukascopy via Tick Story / Quant Data Manager.
- 19/10 Wim: set Daytrade Pro invariati con l'update.
- 20/10 Wim: "prima scrivevo tutto io; da qualche settimana uso soprattutto AI per il codice" (non StrategyQuant).
- 21/10 Gaetan: backtest GR 2020-2026 IC Trading 5k → +555k (> 600k) [IMG]. Critiche: backtest ≠ live, slippage peggiorato ("EA chiude subito come fake breakout"), Mistermember tool simulazione condizioni broker.
- 21-22/10 champ: copia di GR (9 strategie) da youtuber → Wim: "copia truffaldina... probabilmente AI su copia decompilata".
- 22/10 kridel: TGR moderate oggi 7 trade: 3 piccoli win, 4 loss non piccoli.
- 22/10 Wim: UBS Optimization app in arrivo (vedrete correlazioni).
- 23/10 *** Wim AVVISO: canali Telegram t.me/forexeasolutions e t.me/forexeasolutions_fx NON sono suoi, sono truffe di investimento.
- 23-24/10 Wim conferma Myfxbook ufficiale GR: myfxbook.com/members/strueli/gold-reaper-v30/11320334.
- 24/10 Wim: "impossibile moderare MQL5, per questo ho creato il Discord per clienti verificati".
- 24/10 Wim posta 2 immagini backtest Scalp C [IMG x2]; 25/10 Wim: UBS "è il mio miglior EA, può fare tutto quello che fanno gli altri miei EA (breakout) e molto di più".
- 25/10 Mistermember: Scalp C live VT Markets, 0.01 per 2000 USD (0.04 lot) [IMG], contento.
## chunk 3 (25/10 → 03/11 14:03, fine)
- 25/10 tuviah: BT ignora slippage, provare live prima di aumentare rischio Scalp C. Mistermember: tool che applica condizioni broker (commissioni, swap, slippage reali, ordini simultanei).
- 26/10 Mistermember: ridotto rischio Scalp C dopo agosto (più versioni).
- 26/10 njw: link gruppo Telegram → solo Wim può invitare.
- 29/10 Anan22 chiede altri EA; proposti grid/martingala (Sentinel, SSL, Stability Killer, Storm, Yuki, Kyora, Duelist) → criticati come martingala; Rudolf: Sentinel in forte DD flottante.
- 30/10 JOHN: "UBS 9.5 ha corretto un potenziale problema con ATR usando Variable Values" → 31/10 Wim: "solo in backtesting quando non sono ancora caricate tutte le candele; non riuscivo a replicarlo, un cliente aveva il problema".
- 31/10 Signofthetimes: "se hai UBS non ti serve altro".
- 02/11 Wessel: chiede quale set usa track record GR myfxbook strueli/goldreaper/11320334 (nessuna risposta testuale). 03/11 Wessel: GR default solo 2 ordini lontani dal prezzo → Kumar: normale.

## Dettaglio #newbies-corner

- 01/10 Wim a lgil (UBS, conto 1K IC Trading, rischio 5%?): "Dipende da quali set. 5% di rischio per strategia con 5 set sembra ok. Con 40 set sarà un po' dura su 1000".
- 02/10 Mr.B: ultima GR v4.7 (canale ea-update-notifications) [poi utenti su 5.1, 5.4]. Update = sostituire il file.
- 02/10 Graham: GR set 15% Wim + NFP true come partenza → consiglio: backtest.
- 04/10 Ash: usa UBS, GR e Phantom (ha tutti gli EA).
- 05/10 Crilosan: impostazioni FIFO/no hedging per conti USA? JOHN: "no".
- 06/10 bot: SL/TP/trailing calcolati dal prezzo di riempimento effettivo (slippage). 07/10 Wim: "lo SL si sposta se la nuova distanza è più grande di quella prevista; il TP no".
- 06/10 MollyImms GR v5.1 nessuna pending "market is closed" → Wim: algotrading non abilitato? password investor? simbolo sbagliato?
- 09/10 bot: nei combo set raccomandati OnlyUp=1 per tutti tranne GoldBot One (0), motivo non documentato. Apex = EA smart-grid di Wim (AUDCAD, AUDNZD, NZDCAD M15). Suffisso set "H1_A_P006": H1=TF, A=variante, Pxxx=preset (non ufficiale).
- 10/10 Kumar: 5 conti replicando set portafoglio A-E, chiede minimi (nessuna risposta Wim).
- 12/10 olegfusion: combo file GR ha Max DD 7%.
- 12/10 *** LICENZE: SaidHamid (Big Beautiful/Gold Bundle) "10 licenze per EA: il demo conta?" → KoSSaKi: "Sì, i conti demo contano come 1 licenza", rimanda a tradewithwim.com/faq.
- 14/10 Jebediah: GR noleggiato, broker EU 1:20, lotto min 1 e step 1 → yllo: funziona con leva bassa usando max DD conservativo; il lotto minimo 1 è del broker, cambiare broker.
- 15-16/10: GR nessun trade dal 9/10 (oro laterale). 22/10 meanroaster primo trade dal 9/10: -$89 [IMG]. Wim 22/10: "credo romperemo quel livello (4100)... con nuove pending e Gold Trade Pro ancora aperto, potrebbe essere una piacevole sorpresa... o potrei sbagliare".
- 18/10 bot: Portfolio Setup C (PortC "my MEX live combo deal setup_PortC") contiene daytrade_combo.set, goldbot_one_combo.set, bitcoin scalp_combo_a/b.set anche se la pagina live-results non mostra BTC. 19/10 Wim: "li usavo in passato, rimossi ora, aggiornerò lo zip dei set" + FILE "AllSetsAndManuals.zip" 2.92 MB (ufficiale Wim).
- 18/10 bot: update UBS: tenere .set in Common\Files\Sets con stessi nomi, ricaricare. 22/10 Logan.Dale: metodo profili MT5 (profilo portfolio + profilo vuoto "UPDATE" per aggiornare EA dal Market e poi ricaricare il profilo) – contraddice il bot.
- 19/10 bot: backtest dei 4 gold EA insieme incluso nel Gold Bundle.zip.
- 25/10 Kumar (BBB): critica: mancano video per principianti, README per set (min balance, DD atteso, backtest 10-20 anni, quale live signal); 30-50 set, troppo tempo a leggere. Bot: nessun README; doc GoldBotOne e Luna hanno tabelle balance/DD.
- 26/10 bot GR conservativo: gold_reaper_propfirm.set (TradeFrequency 2, MaxAllowedDD 9, PropFirmMaxDailyDD 4); gold_reaper_10%maxrisk.set (MaxAllowedDD 10); evitare 60% HighRisk. $1000: floor 0.01 → DD reale può superare il target; "materiale raccomanda conto CENT sotto ~$5.000 per rispettare target DD bassi". GR minimo $600 "lato basso", DD storico ~$350 a 0.01 lot su extreme conservative. Luna conservativo: LotsizeStep 400, OnlyUp true, news filter. Stability Pro low risk set (AutoLotsizeRisk=1).
- 26/10 bot: AdjustLotsizeToVariableValues deve restare ON (riduce lotto quando distanze crescono col prezzo oro); Weighted lotsize mantiene coerenza dei tier conservativi.
- 27-28/10 GMT offset error (worldtimeserver) → Wim 28/10: "problema del sito worldtimeserver, lo correggo oggi in tutti gli EA; non danneggia i gold EA, non usano l'ora GMT". 30/10 erng37: errore tornato poi sparito.
- 28/10 bot Luna: coppie ufficiali solo EURAUD, GBPAUD, AUDCAD, AUDUSD (16 extra sconsigliate, max DD ~$50 a 0.01 vale solo per le 4). Rollover filter.
- 31/10 Wim: distanze UBS in PIPS, frazioni possibili.
- 31/10 bot: optimization.set = template per ottimizzazione, NON set live; "300+ set (ogni set = una strategia)". Scalp A/B/C differenze non documentate. Etichette "2010-2020" = periodo ottimizzazione.
- 02/11 Claus: log UBS sizing: "MaxRiskPerStrategy 4.96% | balance ... EUR | histDD $32.19 | wanted 0.1725 lots → trading 0.17" (formato log nuovo UBS); 25 set misti (XAGUSD, XTIUSD) caricano in 10 minuti vs 2 s per set gold.

## Tabella immagini analizzate
| Data | Autore | Canale | Contenuto | Numeri leggibili | Interpretazione |
|---|---|---|---|---|---|
| 06/10 | Wim | general | Screenshot di un messaggio privato di un cliente | "last week and this week, have lost back almost the 7% profit so far. You sure no need to upgrade the EA?" | Wim ironizza sui consigli non richiesti dopo un drawdown |
| 12/10 | maindfriik | general | 5 tabelle di correlazione P&L giornaliero tra i set "GR_MaxRisk_W01…W05" di Tran e i set dello zip UBS (es. "Daily_DD41p77_CONFIRMED.set", "sr - 2008-2024 - 9.set") | correlazioni non leggibili nei dettagli | La strategia 4 è la meno correlata; le altre duplicano set esistenti |
| 12/10 | Tom | general | Testo dell'analisi dei set di Tran | W01 = GR strategia 2 con uscita diversa; W02 = Gold Phantom strategia 2 (corr. 0,95-0,98 con Gold10 su FN, E8, Darwinex Zero); W03 = come W02 con impostazioni leggermente diverse; W04 = Gold Trade Pro D senza price scaling; W05 = GR strategia 4 con stessa entry | I set venduti da Tran sono copie di EA esistenti |
| 21/10 | Gaetan | general | Foto dello schermo (report backtest MT5 GR 2020-2026) | non leggibile (il testo dice 5k → +555k, >600k) | backtest, non live; affidabilità bassa |
| 24/10 | Wim | general | 2 immagini del report Strategy Tester di Scalp C (equity, istogrammi per ora/giorno/mese) + FILE HTML | Equity in salita costante su ~310 trade; nessun numero leggibile | Backtest ufficiale di Scalp C (Vantage, H1) |
| 25/10 | Mistermember | general | Strategy Ledger "Gold_Scalp_C", XAUUSD, 1 strategia, 76 posizioni chiuse, 4 ago → 21 ott 2026 | netto ≈ +€646,40; win rate ≈ 85,5%; expectancy ≈ €8,51; max DD ≈ €19 (lettura incerta); verdetto "EXCEPTIONAL" | Live su VT Markets, 0,01 lot ogni 2.000 USD (0,04 lot); buon risultato su un campione breve |
| 03/11 | Wessel | general | Screenshot MT5 mobile: grafico oro con 2 livelli pending lontani dal prezzo | – | GR con impostazioni default; "normale" secondo Kumar |
| 19/10 | Jeremy (Mentor) | general | 4 immagini: backtest di un portafoglio (le prime 3 sono SOMA) con equity, statistiche e tabella mensile | statistiche troppo piccole; il visualizzatore non si è caricato | NON analizzata nei dettagli |

Non analizzate (solo descritte dal testo): #general markushka99 07/10 (3 screenshot trade GR yolo, -50%), langesi 12/10 (backtest dei set di Tran al 10% DD, 01/2024→oggi), Ákos 15/10 (portafoglio 4,9%/mese), DiiZi 09/10 (gap Tesla), Wim 13/10 (miniatura video YouTube), Wim 16/10 (Tesla), meme/foto varie (Лох Кандибобирович1, langesi, Vladislavs, Zena, Dr. Khairy, !R7, JOHN, Anan22: non pertinenti o di contesto); #automated-support: tutte (screenshot di input/pannelli/log degli utenti, es. BIGDEX, Vision, royst1 backtest DTP, Mr.B ReverseTrades, Anan22 bk_TESLA; immagini di Wim dal manuale/pagina prodotto); #newbies-corner: meanroaster 22/10 (trade GR -$89).

## Tabella allegati (non scaricati)
| Data | Autore | Canale | File | Dimensione | Descrizione | Ufficiale? |
|---|---|---|---|---|---|---|
| 07/10 | Wim The Algo Trader | automated-support | Gold Reaper my_live signal settings.set | 5,54 KB | set del segnale live di GR | Sì (Wim) |
| 12/10 | Jeremy (Mentor) | general | UBS_5.0 - 5 GOLD SET PORTFOLIO.zip | 89,92 KB | set di "Huy Tran" (copie di GR/GP/GTP, D1/H4, con set autoloader; contiene la chiave UBS di Tran) | No (utente; materiale rivenduto da un truffatore) |
| 15/10 | Rainy- (inoltro) | general | UPDATED SETS UBS_V8.3.zip | 2,56 MB | manuale aggiornato + set client Bitcoin di BK (contiene UBS Xmas) | Sì (originale di Wim, inoltrato) |
| 19/10 | Wim The Algo Trader | newbies-corner | AllSetsAndManuals.zip | 2,92 MB | zip completo di set e manuali, PortC senza BTC; = "combo.zip" (anche in #plug-and-play-eas) | Sì (Wim) |
| 24/10 | Wim The Algo Trader | general | Gold_scalp_H1_C_vantage.html | 586 KB | report HTML del backtest di Scalp C | Sì (Wim) |
| 01/10 e 08/10 | Wim / bot | automated-support | anteprime di link alla pagina prodotto MQL5 UBS 133653 (non sono file) | – | – | – |
