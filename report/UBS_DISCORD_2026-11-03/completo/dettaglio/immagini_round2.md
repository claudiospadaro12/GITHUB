# Immagini – secondo giro (round 2) – Discord ForexEASolutions, 01/10/2026 – 03/11/2026

Lettura in sola lettura (nessun messaggio, reazione o download). Integra `immagini_performance_ubs.md` e `broker_prop_tools_files.md`: qui solo le immagini che lì erano non aperte o descritte in una riga. Date in ora locale di Discord (CET/CEST) salvo diversa indicazione. Numeri di conto non riportati. "~" = lettura approssimativa.

## 1. #ultimate-breakout-system CHAT (1463074780675833970)

Scansione: 970 messaggi caricati (30/09 → 03/11), 84 messaggi del periodo con immagini/anteprime reali (le altre "IMG" erano solo emoji/avatar). In questo giro sono state aperte o zoomate **30 immagini** (le 3 richieste esplicitamente e i 23 screenshot tecnici).

### A. Immagini richieste esplicitamente
| Data | Autore | Cosa mostra / numeri leggibili | Interpretazione |
|---|---|---|---|
| 06/10 10:01 | Лох Кандибобирович1 (2a img) | tabella "Gross Profit, USD" per simbolo su un portafoglio forex più ampio: **XAUUSD +4.1K**; EURUSD +329, AUDCAD +234, GBPUSD +189, USDJPY +168, EURAUD +146, USDCAD +84, AUDUSD +81, CHFJPY +70, EURCAD +14, NZDCAD +3, CADCHF 0; in perdita EURJPY −101, GBPJPY −91, GBPCHF −77, USDCHF −55, GBPCAD −53, EURNZD −51, EURCHF −49, NZDUSD −36, AUDNZD −16, AUDJPY −12, EURGBP −2, AUDCHF −2, GBPAUD −1. Testo: "lascio questi screen come suggerimento per capire il problema che abbiamo" | Somma forex (23 coppie) ≈ +0,9K contro +4,1K dell'oro: quasi tutto il profitto viene dall'oro, le coppie forex sono vicine a zero. Conferma la 1a immagine (solo oro positivo). Periodo/EA non indicati. |
| 23/10 13:01 | Bruce8 (2a img = anteprima link) | anteprima del segnale MQL5 "UBS Christmas" di Abdullah Uygar Tuna (= Mistermember): **+180% "growth since 2026"**, affidabilità 2/5, algo trading 87%, 1 abbonato, ~1.257 trade; curva da 0% a ~200% con picco e piccolo calo finale | stesso segnale della 1a immagine (+189,99% nel 2026). Il dato "since 2026" (180%) è l'anteprima automatica, leggermente diversa dal valore nel grafico. |
| 26/10 14:39 | Kumar (img 2-4, report Strategy Tester "GOLD Scalp A – Blow Account") | **img2 "Profit vs Time (min)"** (durata dei trade): quasi tutti i trade si chiudono entro ~24 min; vincite fino a ~+4.400; **perdite fino a ~−7.600 a durata ~0 min** (6–7 perdite tra −1.800 e −7.600). **img3 distribuzioni**: entrate per ora con picco alle 15–17 (sessione USA, ~105 alle 15h); per giorno lun–ven ~175–195; per mese gen–ago 80–99, set–dic 50–61; P/L per ora: **perdite ~40.000 all'ora 1** (profitti ~5.700 nella stessa ora); P/L per giorno: **lunedì perdite ~22.000 vs profitti ~10.000**; P/L per mese: perdite ~12–13k in **lug, ago, set**, profitti massimi ad apr (~9k). **img4 MFE/MAE**: le grandi perdite hanno MFE ~0 e MAE fino a −6.000 | Lo Scalp_H1_A col set di default (manual lot 0,1 e Risk=LotsPerBalance) ha poche perdite enormi concentrate all'ora 1 del lunedì → gap di apertura settimanale/notturna che salta lo stop. Nel thread: Vladislavs/Mr.B/Ash "il set oro ha 0,1 lotti di default, va ridotto e testato"; Kumar: "manual lotsize dovrebbe essere 0,01 nei set A, B, C"; Wim: "metaquotes? [dati demo MetaQuotes] non funziona bene per lo scalping". |

### B. Screenshot tecnici (prima descritti in una riga) – analisi
| Data | Autore | Cosa mostra (parametri, errori) | Soluzione / interpretazione |
|---|---|---|---|
| 02/10 06:22 | Classicaltrading | log MT5: `Ultimate Breakout System (XAUUSD+,M5) CTrade::OrderSend: sell stop limit 0.01 XAUUSD+ at 4161.78 (4161.78) sl: 4176.78 tp: 4152.78 [invalid price]` ripetuto 7 volte | lui stesso: "VT Markets non accetta ordini stop-limit"; olegfusion: chiudere/riaprire il terminale se troppi ordini insieme. Problema del broker (tipo d'ordine). |
| 04/10 13:07 | JOHN | scheda Calendario del Toolbox MT5 (eventi di lun 5/10: CNY National Day, PMI AUD, JPY…), accanto ai grafici con strategie 166/181 | Il warning "NFP filter ENABLED but Calendar returned no NFP" (UBS 8.0) è un falso allarme: il prossimo NFP era a più di 31 giorni (Wim). |
| 04/10 14:38 | DKPoulsen (2 img) | img1 Alert: "License not valid – Contact developer" + "Make sure the URL 'https://www.tradewithwim.com/' is allowed" e "…'https://www.forexeasolutions.com/' is allowed" (UBS 8.1, 04/10 05:3x); img2 Opzioni → Expert Advisors: WebRequest consentito per forexeasolutions.org, forexeasolutions.services, worldtimeserver.com, nfs.faireconomy.media, node.showmytrades.com, tradewithwim.com | Nella lista mancava **https://www.forexeasolutions.com/**; Wim ha ricaricato il file sul portale e dopo il ri-download ha funzionato. |
| 05/10 03:55 | Basa2021 | parametri UBS: `OnlyUp = true`, `Reset Highest Balance for OnlyUp = false` | Wim: dopo un prelievo rilanciare l'EA con "reset highest balance" = true. Dalla v8.5 (17/10) il "highest balance" si adegua automaticamente ai prelievi. |
| 06/10 18:23 | Ooi/Coi (2 img) | img1 pannello UBS **v7.7**: set Gold_Scalp_C, magic 2103, **lotto 1,25 con LotsPerBalance=80**, balance ~10.011, 4 vincite/0 perdite, P/L +62,20, prossima news CPI 14/10 15:30; img2 cartella GOLD_Scalp: ScalpH1_A.set, ScalpH1_B.set, ScalpH1_C.set (19 KB), scalph1_C_LiveSettings.set (13 KB), datati 02/10/2026 | Wim: "sì", la LiveSettings è quella giusta. Con 80 di balance per 0,01 → 1,25 lotti su 10k: sizing aggressivo (il 07/10 Wim porta lo step a 120). |
| 06/10 20:23 | DKPoulsen | grafico XAUUSD+ H1 (30/09–06/10) con pannello UBS v8.1 Gold_Scalp_C (lotto 0,15 con LotsPerBalance=80, balance 1.250 di cui credito 750); ordini: **buy stop 0,15 @4179,68 SL 4179,48 TP 4179,88** e **sell stop 0,15 @4105,73 SL 4108,73 TP 4095,73** | Il buy stop ha SL e TP a ±0,20 dal prezzo d'ingresso (anomalo) e a volte compare "lotsperbalance=inf" dopo il riavvio; lui risolve modificando e rimettendo lotsizestep. Possibile bug di calcolo dopo riavvio (non c'è risposta chiara di Wim nel messaggio). |
| 07/10 12:17 | Ooi/Coi | foto dello schermo: XAUUSD-ECN H1, pannello UBS (Gold_Scalp_C, magic 2103) "Current Lotsize 1,9x (using LotsPerBalance=120)", balance ~23.5k; ordine pendente ancora a 3,22 lotti | Wim: "rimuovi gli ordini pendenti" (erano stati creati col vecchio rischio); poi Coi: era colpa del magic number. |
| 08/10 08:15 | timsiejx | tabella (in olandese): "le strategie 4 e 5 nei set live e nella v7.7 sono identiche: tutti i 186 parametri uguali tranne HistoricalMaxDD": strat4 live **79,94** vs v7.7 **216**; strat5 live **224,21** vs v7.7 **74** | I valori di MaxDD storico delle strategie 4 e 5 (Gold Phantom nell'UBS) risultano invertiti nella v7.7; incide su MaxRiskPerStrategy. Risposta di Wim non visibile nello screenshot. |
| 09/10 11:19 | Maracujax | report Strategy Tester (simbolo e EA non visibili, 1 simbolo, qualità storico 100%, 12.771 barre, 43,9 M tick): deposito 1.000, **utile netto 35.056,88**, profitto lordo 66.921,70 / perdita lorda −31.864,82, **PF 2,10**, recovery 7,88, Sharpe 60,86, DD bilancio max 4.085 (11,34%), DD relativo 19,03%, DD equity 19,83%, **502 trade**, short vinti 79,15%, long 87,65%, totale 83,27%, perdita massima −1.464, max perdite consecutive 4 | "ho trovato i miei settaggi": backtest molto aggressivo (×35 il deposito) con DD ~20%; non verificabile, EA/set non indicati. |
| 12/10 14:32 | Flygplan | pannello "Ultimate Breakout System v7.6 – Profalgo LTD 2026": Total PnL 1.241,44, prossima news CPI 14/10, "Running the following 32 strategies" | Richiesta di mostrare il nome del portafoglio → implementato nella **v8.4 (15/10)** con il parametro "portfolio name". |
| 14/10 17:19 | 3372 | elenco file: UBS-TSLA.NAS-H1-TSV01/02/07/08/09/12.set | Sono i set Tesla H1 del pacchetto Christmas (non 15 min né D). Mistermember: normale che Tesla apra molti ordini (10+ strategie), lotti già ridotti rispetto all'originale. |
| 16/10 18:14 | Ukrit | storico: BTCUSD sell 0,01 +5,89 (BTCUSD_RB2_09_v_kill2000_RISK); NAS100 sell 0,1 ×2 +41,32 ciascuno (USTEC_RB2_02_RISK, USTEC_H_RISK); SP500 sell 0,8 +39,04 (US500_I_RISK) | Trade del 16/10 con i set a pagamento di BK ("dm BK"): giornata positiva sugli indici short. |
| 19/10 18:34 | Ash | pagina MQL5 (telefono) Ultimate Breakout System: **1.699 USD**, Profalgo Limited, pubblicato 16/05/2025, **versione 8.5 aggiornata 17/10/2026**, 13.529 demo scaricate, 61 recensioni. What's new: **8.5** (17/10) "highest balance si adegua sempre ai prelievi"; **8.4** (15/10) parametro "portfolio name" nell'autoloader (se vuoto usa il nome della cartella dei set); 8.3: rischio calcolato sul balance (con OnlyUp) come gli altri metodi di lotto | changelog ufficiale delle versioni di ottobre (risposta a malek). |
| 23/10 04:54 | Josh Baker | grafico TradingView XAUUSD M5 (OANDA) 22–23/10: discesa da ~4.076 a ~4.020, poi spike rettangolo evidenziato **−1,13% in 1h55m** (fino a ~3.988) e rimbalzo a ~4.021 | "In un paio d'ore il movimento di una giornata intera": volatilità anomala sull'oro, causa dei falsi breakout/SL. |
| 23/10 05:21 | Adebayo Ojo (anteprima link) | segnale MQL5 "UBS Scalp Set C" (Profalgo Limited): **+181% dal 2026**, affidabilità 1/5, algo 100%, 3 abbonati, ~88 trade | Wim: "Scalp C is doing awesome". Segnale ufficiale (su Vantage, non ICM, secondo Nawril/Mr.B 14/10). |
| 24/10 16:48 e 25/10 07:18 | Wim (anteprime link + PDF) | anteprima commento MQL5 UBS: "prezzo salirà a 1.999 $ + 300 strategie", banner "More than 2 years of live results! BONUS: Choose 5 EAs for free"; il 25/10 allegato UBS_Manual_V8_3.pdf (1,55 MB) | Wim: "UBS NON è plug and play: bisogna imparare backtest, rischio, portafogli; ci sono 2 portafogli d'esempio e molti set". |
| 25/10 11:48 | Mark | scheda prodotto sul portale: "Ultimate Breakout System – Multi-Strategy Breakout", pulsante **Download Ultimate_Breakout_EA_WSC_V8.5.ex5**, "Read the guide", "Set files (ZIP)" | Il portale mostrava ancora la 8.5 mentre gli annunci dicevano 8.6. |
| 25/10 12:26 | Fahreneit | Alert "License not valid – Contact developer" su UBS (XAUUSD,H1 ed EURUSD,H1) 25/10 14:08–14:11, con i messaggi "Make sure the URL tradewithwim.com / forexeasolutions.com is allowed" (URL già aggiunti) | Bug licenza della versione MQL5: Wim "errore mio, lo sistemo" → **corretto nella v8.61**; non riguardava chi scarica dal portale. |
| 26/10 18:18 | Wim | screenshot FX Live Setfile Editor, pulsante "Format all sets": "riformatta ogni .set al layout UBS 7.6: stesso ordine di parametri, intestazioni, parametri nuovi riempiti coi default UBS; i valori esistenti restano" | Wim indica lo strumento di Jonathan per aggiornare i vecchi set (clickrukii non trovava i simboli). |
| 28/10 04:59 | Marcus Wyatt (2 img) | pannello autoloader con strategie Sup/Res P01_G_PG2K_8002 (magic 7100001) e P01_G_PG2K_8002_RT (retest, 7100031) su XAUUSDp, ordini pendenti 0,03 a 3.268–3.498 (backtest, fine agosto); grafico del tester. UBS v9.1, EntryModel=2, RetestTrigger=50 | Problema: i pendenti "retest" vengono creati subito. Wim: **50 è troppo piccolo** (sotto il trigger, scatta subito), usare ad es. 500; e "non ho ancora trovato set break&retest profittevoli per l'oro, non lo consiglio se non per ottimizzare". |
| 28/10 08:51 | youknowho | pannello UBS: balance 127.845,67, metodo **MaxRiskStrat (3,00%)**, ma **tutte le strategie a 0,01 lotti**: set Till_UBS-XAUUSD-H2 (magic 81), dailyK = GoldbotOne_8, GOLDTRADEPRO_c/_d/_H (goldtrade_C/D/H), Gold_a/b/c/f (GoldDaily1/2/3/6) | Stesso set della 8.5 dà lotti diversi con 9.1/9.2 (lotto bloccato al minimo). Wim chiede i set e la valuta del conto per verificare. |
| 28/10 17:18 | ABEXoP | pannello **UBS v9.3**: Total PnL +128,70 (511 trade), portafoglio **"Sets Live 44 Vantage"**, balance 2.720,93, MaxRiskStrat 3%; per set: Bitcoin Reaper 1/8/9 (+10,17 / −24,68 / +19,38), GoldbotOne_8 +41,68, DaytradePro CHFJPY +9,47, DaytradePro XAUUSD +16,15, EURUSD_e…o ~0, goldtrade_D +7,09, goldtrade_E +21,49, **goldtrade_H +88,14**, GoldDaily1/2/3 +25,96/+18,82/−3,76, H1_H +10,69, H1_J +8,81, H1_O +16,36, IND_US30_3 −33,27, IND_US30_4 −20,99, **M5_C −121,37**, **M5_H −201,29**, NAS_VOL_M15_C −3,63, NAS_VOL_M15_D +45,51 | "Perché ne usa solo 4?" → Wim: è solo il testo del pannello tagliato. Sul portafoglio 44 set: utile minimo; gli scalper M5 (C, H) in forte perdita, GoldTrade Pro H il migliore. |
| 01/11 12:13 | youknowho | log: `Ultimate_Breakout_EA_WSC_V9… GMT: offset NOT established (none – falling back to the manual offset…)` | L'EA non riesce a determinare l'offset GMT automatico e usa quello manuale (verificare il parametro di fuso/Time_Source). |
| 01/11 21:45 | Jonathan (3 img + anteprima) | FX Live "Apply a broker's symbols to ForceSymbol" – PU Prime (PUPrime-Live 6, elenco da Stats Export 7.67, agg. 26/10): set Range_Trader_Pro_* di BK: XAUUSD→XAUUSD.p, DE40→GER40.p, EURJPY→EURJPY.p, EURUSD→EURUSD.p, GBPUSD→GBPUSD.p, US30→DJ30.p, US500→SP500.p, USDJPY→USDJPY.p, USTEC→NAS100.p; BTCUSD/ETHUSD già corretti; "Apply to 11 sets" | Strumento per adattare in blocco i nomi dei simboli dei set al broker. |
| 01/11 21:49 | Jonathan (3 img) | nomi simboli: Tesla su Tickmill = **TSLA** / **TSLA.NAS**; US500 su TMGM = **US500** | Risposta a chi diceva che TMGM non ha US500 e Tickmill non ha TSLA: vanno messi nel campo "Force Symbol". |

Non riaperte in questo giro (già analizzate nel primo file o meme): craig 01/10, Classicaltrading 05/10 e 07/10, Mr.B 05/10, Wim 06/10, maindfriik/Benny D/DKPoulsen 06/10, craig 07/10, Wim 07/10, Jonathan 10/10, Coi/Yohomeansmoney 12/10, BK/maindfriik/Mistermember 12–14/10, Coi/BK 14/10, Classicaltrading 16/10, Sebastian 16/10, BK 16/10, Jonathan 17/10, WDW808 19/10, Clen M. 22/10, Mistermember 23/10, maindfriik 24/10, Nurik 25/10, sattysingh56 27/10, 3372 30/10, malek 01–03/11. **Non aperte:** Лох 09/10 "A solution for a sensitive princess" (4 img, verosimilmente meme; la pagina non l'ha caricata in tempo), meme/gif di langesi, yllo, PerezTeka, yomama_36, Rainy-, MaximusDemicusMaridius, JOHN (09–11/10).

## 2. #luna-ai (1463077070971338784)

Aperte in questo giro: 2a immagine di BIGDEX (06/10) e le immagini 2-3 di Vipersnake (09/10). Nota: il messaggio di Vipersnake contiene 2 immagini + 1 anteprima link (Forex Factory), non 3 immagini.

| Data | Autore | Cosa mostra / numeri leggibili | Interpretazione |
|---|---|---|---|
| 06/10 23:16 e 23:19 | BIGDEX (img 1 e 2) | MT5 mobile, AUDCAD.m M15 (06/10 06:15 → 07/10 00:15): **SELL LIMIT 1 a 0,99289** (TP 0,99250) e **BUY LIMIT 1 a ~0,9916** (TP 0,99194); il prezzo Bid (0,99158 alle 23:15, 0,99152 alle 23:18) è già sotto la linea del buy limit, ma l'ordine non si attiva | Il buy limit si esegue sul prezzo **Ask**, non sul Bid mostrato dal grafico: con lo spread notturno l'Ask non ha toccato il livello. Risposte: RSFX "spread", BK "attiva lo spread nelle impostazioni del grafico". Il 3° elemento del messaggio è una gif (scimmia), meme. |
| 09/10 21:28 | Vipersnake (img 2) | input di **Luna_AI_PRO_MT5_WSC_1.51** (EURUSD+, M5), sezione News filter: EnableNewsFilter = true, FilterHighRisk = true, FilterMediumRisk = false, FilterLowRisk = false, FilterAUDonJPYnews = true, HoursBeforeSessionStart = 2, "quanto tardi una notizia blocca ancora la sessione" = 3, filtro per nome evento = **false**, nomi eventi "AUD CPI, AUD Cash Rate, AUD Trimmed Mean, NPF", retry download news 6 min | Il filtro considera solo le notizie ad alto impatto che cadono entro 2 h prima dell'inizio della sessione notturna (o fino a 3 h dopo): una notizia CAD "rossa" del giorno dopo, fuori da questa finestra, non blocca il trade. Il filtro per nome è disattivato e la lista contiene "NPF" (probabile refuso per NFP). |
| 09/10 21:28 | Vipersnake (img 1, già vista) | AUDCAD+ H1 01–09/10: entrate Luna 01/10 (~0,986) e 08/10 (~0,9893–0,9897); poi forte rialzo a ~0,9962 il 9/10 | Lui ha chiuso a mano con piccolo profitto prima della news CAD; il prezzo poi è salito molto (la chiusura manuale ha ridotto il guadagno). Nessuna risposta di Wim visibile nei messaggi caricati. |
| 09/10 21:28 | Vipersnake (anteprima link) | anteprima del sito Forex Factory (calendario economico) | non è un'immagine di trading. |

## 3. #backtesting-discussion (1497100231974584473)

Scansione: 330 messaggi caricati (24/09 → 02/11). Molti "IMG" erano solo reazioni o il badge APP di Digital_Wim. Aperte o zoomate in questo giro: **Mal 01/10 (10 immagini, 4 report completi)**, **Anan22 13/10 (8 immagini su ~16; le altre sono varianti dello stesso pannello)**, Dey 13/10, malek 12/10, Katd-Sama 12/10 ×2. In totale circa 23 immagini.

### Mal – UBS file "YOLO" (Gold Reaper dentro l'UBS), 01/10, backtest YTD 2026 (02/01 → venerdì 25/09), 1 simbolo (oro), qualità storico 99–100%, deposito 500
| Ora | Immagine | Numeri leggibili | Interpretazione |
|---|---|---|---|
| 07:59 | YOLO **Extreme** (curva + report) | curva da 500 a ~22.000 (picchi equity ~25k); **utile netto 21.493,53**, profitto lordo 49.458,51, perdita lorda −27.964,98, **PF 1,77**, recovery 2,73, Sharpe 9,56; **DD bilancio max 5.480 (34,08%)**, **DD equity max 7.875 (42,98%)**; **871 trade**, short vinti 73,2%, long 71,0% (72,1% totale); vincita max 3.345, perdita max −1.751; 10 perdite consecutive max (−286,90); carico deposito fino al 25%; mese migliore agosto (~15k di profitto) | rendimento enorme (×43) ma DD 34–43%: rischio da conto "da bruciare". |
| 08:00 | YOLO **Moderate** | **utile netto 20.978,51**, PF **2,01**, recovery 2,87, Sharpe 13,94; DD bilancio 4.024,70 (31,33%), **DD equity 7.318 (45,79%)**; **290 trade** (contro 871), vinti 80% (short 79,9%, long 80,1%); vincita max 3.484,94, perdita max −1.836,23 | Moderate: stesso utile con un terzo dei trade e PF migliore, ma DD equity anche più alto (~46%). |
| 08:10 | tabella di ottimizzazione (MaxRiskPerStrategy 60–90 × attivazione strategie 1–8) | migliore pass 3226: profitto 708.208, 297 trade, DD 38,92%, rischio 85; molti pass tra 345k e 625k con DD 33–78%; **pass evidenziato 1050**: profitto 356.857, 210 trade, **DD 26,57%**, rischio 85, solo strategie 1, 3, 4, 5, 6 | ottimizzazione su soli 9 mesi: forte rischio di sovra-adattamento. |
| 08:10 | report pass 1050 (3 img) | utile **356.857,31** da 500, PF 2,21, recovery 3,91, Sharpe 16,61; DD bilancio 62.611 (24,47%) ma **relativo 50,92%**; **DD equity relativo 60,17%**; 210 trade, vinti 79%; **vincita max 81.682, perdita max −46.587**, perdite consecutive max −62.556; tenuta media 1h22m (min 19 s, max 49,5 h); quasi tutto il profitto in agosto (~323k) e settembre | numeri irrealistici per l'uso reale (lotti composti enormi, DD relativo 50–60%). |
| 08:14 | report "rischio 65, strategie 3–6" | utile **77.031,56**, PF **2,37**, recovery 4,84, Sharpe 16,72; DD bilancio 10.718 (18,67%), relativo 38,82%; DD equity 15.916 (19,64%), relativo 44,12%; 204 trade, vinti 78,4%; vincita max 16.634, perdita max −7.720 | versione "meno estrema" ma sempre con DD relativo ~40%. |
| testo | — | Mal nota che il **martedì** è sempre il giorno peggiore e chiede di poter disattivare giorni specifici | Wim (08:25–08:29): "hai fatto il longterm? … allora non stai usando dati affidabili per queste conclusioni" (solo 2026). |

### Anan22 – set UBS "XTW07" (petrolio) su broker tedesco "gbe broker", 13/10
| Ora | Cosa mostra | Numeri / dettagli | Interpretazione |
|---|---|---|---|
| 12:27 (×2) | specifica del simbolo USOIL.c (in tedesco) | 3 decimali, valuta USD, **dimensione contratto 1,0** (XTIUSD altrove = 100), calcolo CFD, stop level 1, tick 0,001, valore tick 0,00089 (conto in EUR); lotto minimo del broker 1,0 | Origine del problema: con contratto 1 e lotto minimo 1, i calcoli di rischio UBS (pensati per 0,01 lotti) non scalano. |
| 12:28 (×3) | contenuto del .set XTW07 (salvato 30/05/2025, per Ultimate_Breakout_EA_V1.3) | ST1_Timeframe 16388 (H4), Entry_Timing 16385 (H1), HL strength L7/R6, countback 75, MinDist_to_HL 45, UpDiff 9,9, DownDiff −0,6, MaxPendingOrders 3, MaxTrades 3, scadenza 180 h, Magic 79508, Exit_stop 240, Exit_limit 245, ATRDefault 5,75, ATR_Period 30, MaxSpread 3, SpreadFilter false, virtual stops 1 | set di un cliente per il WTI; nulla di specifico del broker (Digital_Wim). |
| 12:30 | input LotSize | Force Fixed Manual Balance 10.000, adjust lotsize 5%, Risk = "use Max Risk Per Strategy", manual lotsize 0,1, LotsizeStep 500, MaxRiskPerStrategy 2,0, **max historical DD a 0,01 lotti = 13,88**, max lotto 1.000 | — |
| 15:05 | report del tester (tedesco) | deposito 10.000: **utile netto 30,61**, PF 2,15, DD max 5,80 (0,06%), 68 trade, vinti 64,7% | "30 $ in 2 anni": il rischio non scala. |
| 16:12 (×2) | input dopo modifiche | Risk = "use Max Risk Per Strategy" (colonna "Wert"), **MaxRiskPerStrategy_Value 50**, **max hist DD 138,8**, max lotto 100.000, OnlyUp true, CheckMargin true | Nota: Digital_Wim ha risposto che il rischio era impostato su "risk per trade in $/€", ma nello screenshot quella voce è solo il **valore finale dell'ottimizzazione** ("Beenden"); il valore effettivo è Max Risk Per Strategy. La diagnosi del bot era quindi sbagliata; problema non risolto nel canale. |
| 19:34 | input + "DD solo 3%" | stesso pannello, voce "Adjust lotsize if balance changes X percent" evidenziata | Digital_Wim: aumentare MaxRiskPerStrategy (es. 6→8–10). |
| Dey 18:54–18:56 (3+1 img) | report: deposito 500, utile netto 416,02, PF 2,24, recovery 4,57, DD 88,44 (17,68%), 79 trade, vinti 65,8%; elenco trade e curva in salita; testo "10K, 2% per strategia, 01/01–12/10/2026" | Lo stesso set con Max Risk Per Strategy funziona su un altro broker: il problema di Anan22 dipende dal simbolo/broker (contratto 1, lotto minimo 1). |

### Altri
| Data | Autore | Cosa mostra | Interpretazione |
|---|---|---|---|
| 12/10 04:26 | malek | ottimizzazione 3 anni (8 pass): con NFP filter **on** profitto 18.228,66, 9.752 trade, DD 2,70%; con **off** 18.434,78, 9.974 trade, DD 2,67%; ReverseTrades true/false e KillPending: **risultati identici** | Il parametro globale ReverseTrades non ha effetto. Wim: "è un parametro del singolo set, non si usa come globale". Il filtro NFP costa poco (~1%). |
| 12/10 07:57 | Katd-Sama | journal tester: gruppo "MetaQuotes-Demo_demo", **XAUUSD storico dal 05/06/2021, tick reali solo dal 27/05/2025** | Con il server MetaQuotes i tick reali coprono solo ~1,5 anni. Wim (07:07): "uso MetaQuotes per forex e oro, IC Markets per crypto e indici; controllo che tick reali e 1M OHLC coincidano, poi uso 1M OHLC per il lungo periodo". |
| 12/10 08:29 | Katd-Sama | warning con tick reali ICM: "XAUUSD: 2026.09.27/28/29… 23:59 – no real ticks within a day" (molte righe) | Anche i tick di ICM hanno buchi giornalieri (ultimi giorni). |
| 29/10 12:31–12:47 | Лох К. | il messaggio "nuovo setup EA, backtest tutti i mesi positivi → primo mese negativo dal vivo" non ha immagini; segue una gif (meme) | Il "video 29/10" del primo file è questa gif. |
| 27/10 07:10 | Wim | solo allegato Gold Reaper.zip (4,83 MB, "done with UBS"), nessuna immagine | Wim 14:49: "fate i backtest da soli, non ha senso prendere quelli di altri". |

Nota dal testo (28–29/10): Wim avverte che **esiste solo un gruppo Telegram UBS più il canale annunci; tutto il resto è truffa** (Aleksei segnala p87z, che offriva un backtest di 41 MB di tutti i set via Telegram).

## 4. #usefull-tools (1482989069029085246)

Scansione: 108 messaggi del periodo; **44 messaggi con immagini reali o anteprime (~51 immagini)**, tutti visti a schermo (una riga ciascuno). Quasi tutto materiale promozionale/di interfaccia, nessuna performance di EA tranne due casi (in grassetto). L'immagine slippage di Jonathan del 04/10 18:04 è già nel file precedente.

| Data | Autore | Cosa mostra |
|---|---|---|
| 01/10 18:01 | Jonathan | anteprima "MetaTrader Setfile Editor 7.3 – duplicate magic numbers" (tabella magic duplicati); allegato metatrader-setfile-editor_v7.3.html **148 KB** |
| 02/10 16:18 | Mistermember | Strategy Ledger Pro, Backtest Analyzer con finestra "MAP" per collegare simboli custom ai simboli del broker |
| 02/10 18:13 | tuviah | input di **MagicNotifier 1.10** (XAUUSD+, H1): magic 10001/10002/10003, etichette UBS_Gold/UBS_SPX/UBS_EURUSD, notifica apertura/chiusura, push MT5 sì, e-mail/alert no |
| 03/10 10:17 | JOHN | anteprima Microsoft Learn "Autologon – Sysinternals" (accesso automatico Windows per far ripartire MT5) |
| 03/10 22:45 | Mistermember | anteprima MQL5 Strategy Ledger Pro (192540) "now in 11 languages", versione 4.40 |
| 04/10 12:39 | Jonathan | FX Live, lista posizioni con filtri dinamici (Daily/Weekly/Monthly), elenco trade XAUUSD di Gold Phantom/Reaper |
| 04/10 17:37 | MaximusDemicusMaridius | telefono: conferma di acquisto Strategy Ledger Pro su MQL5 |
| 06/10 09:12 | Jonathan (3 img + anteprima) | Portfolio Lab v1.4: curve portafoglio, calendario P/L (best/worst slot), "what-if" lotto fisso |
| 06/10 15:36 | Mistermember | "Sneak peek" del prossimo Ledger: confronto backtest vs live trade per trade |
| 06/10 21:31 | Tom (2) | **Limit Monitor** (MQL5 199889): ordini pendenti 259 su limite, margine 98,7%, 31 grafici, tabella per simbolo |
| 07/10 14:51 | Jonathan | anteprima "EA disconnection alerts" FX Live: avvisi warning/critical (EA senza attività da X min) via mail/Telegram |
| 08/10 14:17–14:18 | Mistermember (2) | Ledger Pro **4.41**: Compare (backtest vs live), What-if simulator, Account, Orders ahead |
| 09/10 13:50 | Jonathan | Portfolio Lab v1.5: scomposizione per simbolo di EA multi-simbolo con stesso magic (Daytrade Pro, Luna, Range Breakout) |
| 09/10 20:52 | Mistermember (2) | Ledger Pro **4.42**: What-if con un clic, Orders ahead corretto, Split by symbol |
| 10/10 05:56 | Tony (2) | FX Live: curve per EA raggruppate (Gold Reaper, GoldTrade Pro, Luna, Gold Phantom) invece che per magic |
| 10/10 06:20 | Jonathan | **scheda "Gold Phantom": +20,09%, 6 conti, 12 magic, 922 trade, win 62%, PF 1,53, RF 2,20, DD −9,1%** (i suoi conti) |
| 10/10 04:40 / 07:58 | Jonathan / Tony | istruzioni FX Live (pagina principale), non di performance |
| 11/10 19:47 | Jonathan | Portfolio Lab v1.6 "Bring in your real trading history" (import segnali MQL5/Myfxbook/MT5) |
| 11/10 20:52 | Multydrew | anteprima MQL5 "Kontrol01 Manager" (logo KONTROL_01) |
| 13/10 08:53 | Jonathan | anteprima "Ultimate Breakout System (UBS) – User Manual" online su fxlive.trading (con approvazione di Wim, fino a UBS 8.2) |
| 13/10 20:38 | Jonathan (3) | Setfile Editor 7.4: pulsante "Format UBS 8.2", campo ForceSymbol / OnlyLoaderForce, link al manuale per parametro |
| 13/10 23:48–23:49 | Mistermember (2 + anteprime) | guida MQL5 "Backtest Analyzer and What-if Simulator"; card "What's new in 4.43" (What-if sul conto live, Sizing Optimizer, Exits paired by time, What-if money to the cent) |
| 14/10 08:15 | Лох К. (2) | anteprima x.ai "The X Subscription" (Grok, Cursor, X Premium) – non trading |
| 15/10 17:09 | Jonathan (2) | Setfile Editor 7.5: "Broker Symbols" (equivalenti dei simboli per broker), "Format UBS 8.4" |
| 17/10 19:09–19:20 | Mistermember (2) | What-if simulator (curva e tabella) + anteprima blog "What-if and the Sizing Optimizer" |
| 18/10 17:25 | Multydrew | anteprima "PerformanceDashboard" (MQL5 171337) |
| 21/10 08:47 | Mistermember | locandina "Practical deep dives into EA evaluation" (10 articoli con QR code) |
| 21/10 16:42 | Andrew Soma | anteprima BBC "Websites taken down… critical PHP cyber-security update" – rischio dei tool basati su PHP |
| 22/10 10:39 | Andrew Soma | anteprima Setfile Editor FX Live |
| 24/10 12:27 | Jonathan (2) | anteprima "Portfolio Lab 2.0: Live vs Backtests vs Signals vs Brokers" |
| 25/10 21:12 | Eugen | nessuna immagine: allegato PanicButtons.mq5 7,48 KB (già elencato) |
| 26/10 15:24–15:27 | Mistermember (2) | locandina articoli + anteprima MQL5 "Behavioural Cloning in a Live Trading System" |
| 27/10 17:57 | Multydrew | anteprima KONTROL_01 (prezzo lancio $59 prolungato) |
| 27/10 21:31 | Mistermember | locandina "Portfolio mode" (tutti i conti in una pagina) |
| 28/10 08:16 | Jonathan | locandina "Economic Calendar – your trading week in your time zone" (notifica Telegram mattutina) |
| 29/10 08:08–08:09 | Mistermember (2 + anteprima) | card "Version 4.44" (Portfolio, curva conto live, share card, What-if con costi reali) |
| 02/11 13:18 | Mistermember | avviso: Strategy Ledger rinominato **EA Scorecard** (richiesta MQL5) |
| 02/11 20:49 | Multydrew | anteprima KONTROL_01 (notifiche Telegram per la protezione DD) |

Allegato con dimensione ora leggibile: **metatrader-setfile-editor_v7.3.html = 148 KB** (Jonathan, 01/10).

## 5. Canali ufficiali e Karnek

### #ea-update-notifications (1463173281426309152) – 20 messaggi nel periodo, tutti di Wim; 1 messaggio con immagini (2 immagini, non 4: il contatore includeva le anteprime), nessun allegato
| Data | Cosa mostra / numeri leggibili | Interpretazione |
|---|---|---|
| 19/10 13:45 – Wim "2025-2026 comparison, all pairs" (img 1, "Daytrade Pro old version") | report Strategy Tester, 13 simboli, qualità 100%, 465 barre (D1, 2025–2026), saldo iniziale ~100k: **utile netto 2.266,07**, PF **1,07**, recovery 0,42, Sharpe 0,19; DD bilancio max 4.561,55 (4,46%), DD equity max 5.344,40 (5,21%); **637 trade**, vinti 69,23% (short 68,7%, long 69,6%); vincita max 868, perdita max −1.618,32; 10 perdite consecutive max −1.760,94; curva da ~100k a picco ~105,7k e chiusura ~102,4k | La versione vecchia del Daytrade Pro nel 2025–26 è quasi in pareggio (+2,3% in ~2 anni). |
| 19/10 13:45 – img 2 ("Daytrade Pro V4.5 improved EURJPY & GBPJPY") | stesso test: **utile netto 9.309,47**, PF **1,33**, recovery 1,78, Sharpe 0,80; DD bilancio 3.104,17 (3,03%), DD equity 5.216,13 (5,02%); **629 trade**, vinti 70,75%; vincita max 868, perdita max −1.645,29; 9 perdite consecutive max −2.913,48; curva da ~100k a picco ~111,6k e chiusura ~109k | La 4.5 migliora il periodo recente (~+9,3% contro +2,3%) solo cambiando EURJPY e GBPJPY: è un miglioramento ottimizzato sullo stesso periodo che mostra (rischio di curve-fitting); rendimento comunque modesto, DD ~5%. |

Elenco aggiornamenti del periodo (testo, per contesto): 02/10 tutti gli EA oro (sessioni broker, filtri CPI e tassi; trailing virtuale) e UBS 7.9 (filtro news); 04/10 UBS 8.0 (log del filtro news) e 8.1 (falso warning NFP); 10/10 UBS 8.2 (ReverseTrades per Sup/Res, colonna Trades nel pannello); 14/10 Gold Reaper/GoldTrade Pro/Goldbot One (filtri CPI/tassi usavano date fisse invece del calendario MQL5) e UBS 8.3 (Risk per Trade usa Manual/Highest Balance); 15/10 UBS 8.4 (portfolio name); 16/10 GoldTrade Pro 7.0 (bug filtro NFP); 17/10 tutti gli EA principali: OnlyUp/HighestBalance si adegua ai prelievi (aggiornare TUTTI gli EA che girano insieme, altrimenti la vecchia versione riscrive la variabile globale); 19/10 Daytrade Pro 4.5; 25/10 UBS 8.6 (break&retest nell'autoloader) e 8.61 solo MQL5 (licenza); 27/10 UBS 9.0 (rilevamento GMT, lotti con valuta non USD e suffissi diversi, "Only use Range Based SL/TP") e 9.1 (bug della 9.0); 28/10 tutti gli EA con worldtimeserver (GMT non rilevato su MT5) e UBS 9.3 (conti cent USC); 29/10 UBS 9.5 (ATR con Variable Values).

### #important-announcements (1463082885832773632) – 7 messaggi nel periodo, tutti di Wim; nessun allegato
| Data | Immagini | Contenuto |
|---|---|---|
| 01/10 07:42 | miniatura video "Testimonial – Rosa, Trader, Spain" | testimonianza: Gold Reaper +16% in un mese su conto piccolo (dichiarato, nessun dato verificabile nell'immagine) |
| 05/10 18:36 | anteprima pagina "Reviews & Independent Coverage" | annuncio del ritorno del Big Beautiful Bundle (72 h) |
| 11/10 18:41 | locandina "The Big Beautiful Bundle – opens tomorrow – 13 Expert Advisors, one toolbox" (Gold, Forex, Indices, Bitcoin) | promozione |
| 12/10 14:09 | locandina BBB + anteprima Profalgo LTD | **72% di sconto** sulla collezione completa per 72 h (link shop) |
| 13/10 08:01 | miniatura YouTube "Peter Müller – Traders Meta: Inside the Mind of MQL5's Best-Selling Developer" | intervista a Wim |
| 14/10 13:18 | locandina "24 hours left – 72% OFF – 13 Expert Advisors": Gold Reaper, Ultimate Breakout System, Gold Trade Pro, Goldbot One, Gold Phantom, Daytrade Pro Algo, Luna AI Pro, Indicement, Bitcoin Reaper, ORB Master + 3 EA bonus; set file, 10 licenze, aggiornamenti a vita, community | chiusura del BBB (ORB Master incluso nel bundle nonostante l'avviso "not recommended to buy" dell'8/10) |
| 23/10 10:56 | nessuna immagine | **avviso truffa**: i canali Telegram t.me/forexeasolutions e t.me/forexeasolutions_fx NON sono di Wim (usano nome e marchio per truffe d'investimento) |

### #my-manual-ea-interventions (1463172903477706909) – 2 messaggi nel periodo, nessuna immagine né allegato
- 30/10 13:31 Wim: "Chiuse alcune grandi posizioni oro in profitto sui conti portafoglio perché siamo su un supporto importante; tutti i conti monitor restano intatti" (prima, 28/09: prese profitto oro, "come al solito il mio intervento ha lasciato profitti sul tavolo").

### #karnek_questions (1536624850410672198) – 6 messaggi nel periodo, **nessuna immagine** (le "IMG" erano reazioni) e nessun allegato
- 22/10 jamie s (sviluppatore): Karnek disponibile su Apple Store e Google Play; Wim ringrazia. 23/10 3372: l'app iOS a volte mostra una schermata bianca (usa la web-app); Robert: ringrazia per l'**analisi dello slippage** aggiunta in Karnek. 31/10 jamie s: spiega il bug iOS (pagina non ricaricata dopo che iOS libera memoria).

### Allegati (.ex5/.zip/.pdf/.set/.html) in questi 4 canali nel periodo
**Nessuno.** Gli aggiornamenti in #ea-update-notifications rimandano a MQL5, alla dashboard ForexEASolutions e al portale tradewithwim.com, senza file allegati.

## Cosa non è stato fatto / limiti
- Nessun file scaricato o aperto; nessun messaggio o reazione.
- #ultimate-breakout-system: non aperte le 4 immagini di Лох del 09/10 ("A solution for a sensitive princess", probabile meme; la pagina non si caricava in tempo) e i meme/gif già catalogati; la 1a immagine di Kumar (curva balance) non è stata riaperta perché già descritta.
- #backtesting-discussion: di Anan22 sono state lette 8 immagini su ~16; le altre sono varianti dello stesso pannello di input/del report (stesso contenuto). La 3a immagine di Mal del messaggio delle 08:14 (MFE/MAE) non è stata aperta.
- #usefull-tools: immagini viste a bassa risoluzione (una riga ciascuna); nessuna è stata zoomata tranne quelle con dati (Gold Phantom di Jonathan, Limit Monitor).
- Date e ore come mostrate da Discord (ora locale), con possibili differenze di ±1–2 h rispetto all'UTC dei file precedenti.
