# CACCIA: "Gold Breakout PRO MT5" (Daophet Seng Athit), 09/10/2026

Letto OGGI, 09/10/2026, da sandbox. Niente comprato, nessuna demo scaricata, nessuna registrazione, nulla eseguito, nessun EA/preset/conto toccato. Sono state scaricate **solo immagini e pagine HTML pubbliche** (nella cartella di lavoro temporanea, non nel repo) e lette come testo/immagini. Le decisioni (acquisto, rischio, campo) restano di Claudio.

Etichette: **[LETTO]** = visto da me su pagina/immagine pubblica oggi · **[DICHIARATO DAL VENDITORE]** = scritto da lui, non verificato · **[NON VERIFICABILE]** = non c'e' modo di controllarlo da fuori · **[DERIVATO]** = aritmetica mia sui numeri letti · **[INFERITO]** = deduzione, con la ragione · **[INCERTO]** = non lo so.

---

## 0. ACCESSO E CONTROLLO POSITIVO (in testa, come da regola)

| fonte | esito oggi | note |
|---|---|---|
| `mql5.com/en/market/product/135291` (la pagina dello screenshot) | **200, pagina intera raggiunta** (`curl` con user-agent normale; il `WebFetch` generico a volte la riassume male o la dichiara "non disponibile": per le pagine MQL5 e' piu' affidabile il raw) | **controllo positivo PASS**: titolo "Gold Breakout PRO MT5", venditore Daophet Seng Athit, **399 USD / affitto 100 USD 3 mesi, v1.7, aggiornato 7 ottobre 2026, 9 attivazioni, 5 stelle (2), 390 demo scaricate, pubblicato 28 marzo 2025**: **coincide con lo screenshot di Claudio**, riga per riga |
| profilo venditore `/en/users/daosengathit` | 200 | bacheca con 5 post-immagine (letti) |
| segnale `/en/signals/2351091` | 200 | statistiche, commenti, rischio dichiarato |
| profili dei due recensori `/en/users/buza20`, `/en/users/vernk855` | 200 | letti |
| prodotti correlati del venditore e del recensore (185662, 185697, 185700, ...) | 200 | letti |
| Code Base `/en/code/77691` (EA gratuito col sorgente, stesso concetto) | 200 | letto, serve da riferimento a sorgente aperto |
| canale `mql5.com/en/channels/goldbreakoutpro` | **richiede login** | **NON LETTO** |
| scheda "What's new" e "Comments" del prodotto | **NON LETTI** (si caricano dinamicamente; `/whatsnew` = 404) | **non so cosa e' cambiato dalla 1.0 alla 1.7** |
| sito FTMO per verificare il certificato | **NON TENTATO oggi** (nella caccia del 01/10 FTMO ufficiale era bloccato) | il QR del certificato **non e' stato decodificato** (nessun lettore QR nell'ambiente) |
| gli **input dell'EA**, i `.set`, il sorgente | **NON ESISTONO pubblicamente**: la pagina non elenca nessun parametro (confermato sulle quattro pagine del venditore) | **la tabella dei valori sotto e' fatta con altri esempi e con quello che i grafici del venditore lasciano leggere** |

**Verdetto sull'accesso:** la pagina e' stata letta, undici immagini marketing (dieci grafici + il certificato) e cinque immagini della bacheca scaricate e viste una a una, ma **del motore non c'e' alcun parametro pubblico**. Cio' che sappiamo del motore e' dedotto da: testo, grafici SQX del venditore, e le posizioni visibili nei suoi screenshot di segnale.

---

## 1. COS'E' DAVVERO (riassunto in dieci righe)

- **Prodotto**: Experts MT5, XAUUSD, **H4**, "Highest-Lowest Breakout" **[DICHIARATO]**. Pagina dichiara "no grid, no martingale", rischio per trade, SL e TP, "cut loss system", 24/7. Broker di riferimento IC Markets, saldo consigliato 500-1000 USD **[DICHIARATO]**.
- **Come e' costruito: validata con StrategyQuant X [LETTO sui suoi screenshot]; generata dallo stesso software [INFERITO]** (schede "Strategy config", "Source Code", "Retester", "Walk-Forward Matrix" visibili nelle immagini; il file si chiama `Gold Breakout PRO(H4)06 - XAUUSD_icmarkets, H4, 2020.01.02 - 2026.07.08`). Le schede "2-Step Challenge Analyzer", "Edge Decay & Max Loss Analyzer", "Portfolio Rescaler", "RobustnessScorecard" sono **plugin di terzi** (scritto dentro lo screenshot: *"This tab is user-created plugin, not a standard part of StrategyQuant. Use at your own risk."*).
- **Meccanica dedotta dal suo segnale [INFERITO, da 2 screenshot del venditore]**: nello screenshot del segnale del 24/11/2025 ci sono **ordini pendenti Buy Stop / Sell Stop** a 67-180 USD dal prezzo e **senza SL visibile** nella tabella (S/L vuoto) e due posizioni Buy 0,01 con **SL gia' sopra l'ingresso** (4051,42 contro ingresso 4050,57: trailing o breakeven) e TP a +60,68. Quindi: **ordini stop piazzati sul massimo/minimo di N barre, SL/TP fissi, trailing/BE quando in profitto** (il segnale stesso dichiara: *"SL,TP Fixed · Trailling Stop When Profit · Exit Rules (Exit If Wrong Condition) · Max Trade Per Day"*).
- **Lati**: long e short entrambi in profitto nelle sue statistiche (Long circa 1.500 USD, Short circa 1.250 USD, dal grafico a barre, "Symmetry 83,53") **[LETTO, backtest suo]**: **a differenza dell'EA gratuito di confronto (§4), non e' solo long**.
- **Frequenza** nel suo backtest: **328 operazioni su 6,5 anni = ~50 all'anno = ~1 a settimana** su un solo simbolo **[LETTO/DERIVATO]**. Tenuta media 10,2 barre H4 (~41 ore) **[LETTO]**.
- **Il segnale "All Star" usa due EA insieme (H1 + H4)** sullo stesso conto (**[DICHIARATO]** in titolo del post 29/09: *"Passed FTMO using Good Breakout PRO and Gold Breakout H1"*): **la challenge FTMO dichiarata non e' stata passata col solo prodotto da 399 USD**.

---

## 2. TABELLA DEGLI ESEMPI (valori; il prodotto non ne pubblica, quindi si affiancano altri esempi sulla stessa famiglia)

| # | fonte (URL, letto 09/10/2026) | che cosa e' | parametro = VALORE | etichetta | cosa ne facciamo |
|---|---|---|---|---|---|
| **G1** | [Gold Breakout PRO MT5, prodotto 135291](https://www.mql5.com/en/market/product/135291) | H4 XAUUSD, breakout highest/lowest | TF **H4**; saldo 500-1000; **399 USD / 100 USD 3 mesi**; reottimizzazione "ogni 121 giorni su finestra di 1.214 giorni, 10 run, 30% OOS" | [DICHIARATO DAL VENDITORE] | TF come **asse da misurare** (H4 vs i nostri M1); la reottimizzazione trimestrale **NON si copia** (vedi bandiere) |
| **G2** | screenshot #7516 (`c.mql5.com/31/2189/gold-breakout-pro-mt5-screen-7516.jpg`) e #9290 | statistiche backtest `(H4)06` 2020.01.02-2026.07.08 | **328 operazioni, PF 1,85, win 69,21%, payoff 0,82 (media vinta 26,43 / persa -32,08), DD 146,67 USD (1,24%), profitto 2.758,79 USD, max 9 vinte / 3 perse consecutive, stagnazione 157 giorni**; lotti **0,009-0,01** fino a ~trade 300, poi **0,02** | [LETTO sull'immagine; DICHIARATO come dati] | **ordine di grandezza di un motore H4 su oro**: PF 1,3-3,5 per anno, nessun anno in perdita; non e' un valore da copiare |
| **G3** | screenshot #7822 | PF per anno `(H4)06` | 2026 PF **2,70** (n=36, +1.032), 2025 **1,33** (n=68), 2024 **1,49** (49), 2023 **1,99** (50), 2022 **2,03** (44), 2021 **3,49** (42) | [LETTO] | **2026 pesa il 37,4% del profitto totale** (1.032,33/2.758,79) e **ha lotti doppi** (0,02): [DERIVATO] |
| **G4** | screenshot #5942 (Monte Carlo "retest methods") | prova di costo e slippage | 500 simulazioni, **spread casuale 10-50, slippage 0-15, dati tick randomizzati (20% su/giu')**; percentile 95: profitto **2.427,87 contro 2.758,79** (-12%), DD **147,80 contro 146,67** | [LETTO] | **utile**: dice quanto regge ai costi **del suo broker**; il DD quasi non si muove |
| **G5** | screenshot #6785 (Monte Carlo "trades manipulation") | rimescola le STESSE operazioni | 1.000 simulazioni (blocchi da 50, skip 3%, jitter parametri); "Original" **8.824,72 USD, DD 403,06** | [LETTO] | **NON e' lo stesso file** di G2: nome `(H4)01`, ~225 operazioni sull'asse, profitto 8.824 contro 2.758 [DERIVATO]. **Due configurazioni diverse nello stesso set di immagini** |
| **G6** | screenshot #8913 (Walk-Forward Matrix) | WF `(H4)06` | **16 su 16 "PASSED"**; 9 finestre OOS di **178 giorni** su IS di **588 giorni**, **20-47 operazioni per finestra OOS**; profitto OOS per finestra 19,19 / 275,93 / 140,12 / 144 / 61,18 / 70,93 / 570,94 / 318,55 / 117,62; "parameters stability **0,76**"; raccomandato "10 run, 20% OOS: reotti. ogni **158 giorni su storia di 789 giorni**" | [LETTO] | vedi §3.4: **mostra che la reottimizzazione e' positiva, non che l'edge esiste fuori dal suo strumento di costruzione** |
| **G7** | screenshot #4925 ("2-Step Challenge Analyzer", plugin di terzi) | simulazione challenge | rischio 5% giornaliero / 10% totale statici; **target 10% + 5%**; **peggior giorno -1,2%, DD max -1,0%**; "pass probability 100%" (IC 99,9-100); fase 1 in **138 giorni di trading**, fase 2 in **92**; *"This sample includes in-sample data... Pass probability is optimistically biased here — prefer Out-of-Sample"* | [LETTO] | **il rischio usato nel backtest e' ~0,3% per trade** [DERIVATO: perdita media 32 USD su 10.000]; **non e' il rischio con cui il venditore lo gira dal vivo (3,5%, G9)** |
| **G8** | screenshot #6150 ("Edge Decay") | IS contro OOS | IS 204 operazioni **PF 1,74**, OOS 124 operazioni **PF 1,97**; DD% IS 1,14 / OOS 1,38 ("degrada +21%"); win rate 71,6 / 65,3 | [LETTO] | **l'OOS e' l'ultimo 38% delle operazioni = 2024-2026**, cioe' il rialzo storico dell'oro [INFERITO dall'asse dell'equity] |
| **G9** | [segnale 2351091 "Gold Breakout PRO All Star"](https://www.mql5.com/en/signals/2351091) | **conto live del venditore, IC Markets, leva 1:100, 40 settimane** | **"Risk % Per Trade 3,5%"**; "No Grid, No Martingale, SL/TP fixed, trailing, exit if wrong condition, max trade per day"; 119 operazioni, PF 2,10, win 68,06%; **DD relativo 35,31% sul saldo / 24,99% sull'equity**; 3 posizioni contemporanee (commento di un iscritto); **peggior trade -172,78 USD**; "2 trade a settimana"; capitale iniziale 1.517, **prelievi 3.346,61 contro versamenti 927,95**, equity 992,72 | [LETTO; DICHIARATO come rischio] | **il vero rischio di funzionamento del "prop-ready" e' 3,5% per trade, 5,4 volte il nostro 0,65%** [DERIVATO] |
| **G10** | [Code Base 77691, Ali Rajput, 24/09/2026](https://www.mql5.com/en/code/77691) | **EA gratuito, sorgente, stessa famiglia concettuale** (Turtle H4 su oro) | `InpEntryBars=20`, `InpATRPeriod=20`, `InpStopATR=2.0`, `InpUseTrend=true`, **`InpTrendEMA=200`**, `InpAllowLong=true`, **`InpAllowShort=false`**, `InpExitMode=C (TP fisso)`, **`InpTargetR=2.0`**, `InpTrailATR=3.0`, `InpExitBars=10`, **`InpRiskPercent=1.0`**, **`InpMaxSpreadToRisk=0.10`** (salta se spread > 10% dello stop), `InpSlippagePoints=50`, `InpCloseFriday=false`/ore 20 | [SORGENTE/INPUT LETTI nella pagina] | **l'unico esempio con valori veri**. Risultati dichiarati 2020-2026: **PF 1,77, DD 11,38%, win 46,97%, solo buy**; con short **PF 1,28 e i 116 short perdono -2.080** |
| **G11** | idem G10, tabella delle uscite | TRE gestioni dell'uscita provate anno per anno, 7 anni | **ATR trail 3: +2.554 (2 anni persi) · canale 10 barre: +3.393 (3 persi) · TP fisso 2R: +4.579 (3 persi); con EMA200: +4.777, DD annuo peggiore da 13,98% a 10,21%**; "la gestione migliore cambia da un anno all'altro" | [DICHIARATO dall'autore, tabella nella pagina] | **conferma il nostro asse "gestione dell'uscita" e dice di misurarne piu' di una** |
| **G12** | [Vernkham Sorsavanh, prodotti 185697 / 185700](https://www.mql5.com/en/market/product/185700) | **stesso testo del venditore, prodotto diverso, 222,22 USD**; e' **uno dei due recensori** | "Gold Breakout EA, XAUUSD, H4, saldo 500$, IC Markets, Highest-Lowest, parametri aggiornati ogni tre mesi con il WF" (descrizione quasi identica) | [LETTO] | **bandiera sui recensori (§3.5)** |

---

## 3. LA VALIDITA' DELLE PROVE, UNA PER UNA

### 3.1 Il certificato "PASSED FTMO CHALLENGE" [LETTO, immagine #1652 (cartella 2422) e post sulla bacheca del 29/09/2026]
- **Cosa dice**: "Proudly presented to: Daophet Sengathit", data **28 Sep 2026**, firma "Otakar S. / Otakar Suffner CEO", QR code, testo standard *"successfully passed the FTMO Challenge... reaching the Profit Target while staying within the defined loss limits"*.
- **Cosa NON dice [LETTO]**: la **taglia del conto**, **la fase** (Challenge o Verification o entrambe), **in quanti giorni**, **con quale EA o a quale rischio**, **che sia stato un EA**. Il testo e' generico: e' lo stesso modello per qualunque trader.
- **Il QR [NON VERIFICATO]**: non l'ho decodificato. E' l'unico modo verificabile da fuori; **se Claudio vuole** puo' inquadrarlo col telefono (solo lettura, dice se punta a un dominio FTMO).
- **Come lo dice lui**: post sulla sua bacheca del **29/09/2026**: *"Passed FTMO using Good Breakout PRO and Gold Breakout H1"* [LETTO]. **Due EA** (il PRO H4 e l'H1 da 199 USD), **un solo conto**, **un solo passaggio**: **un campione di uno**.
- **Tempismo [DERIVATO]**: certificato 28/09, post 29/09, aggiornamento del prodotto alla v1.7 il **07/10** con il certificato come primo screenshot. Il certificato e' stato **messo in vetrina nove giorni dopo**, insieme a un aggiornamento di cui non so il contenuto.
- **Spelling [NOTA]**: il certificato porta "Sengathit", il profilo "Seng Athit". Banale, ma e' la prova che nome e profilo non sono collegati da niente di verificabile.
- **Giudizio**: **[NON VERIFICABILE] come prova del prodotto.** Un solo passaggio di challenge e' compatibile con un motore a bassa frequenza e un rischio scelto dal trader (la challenge FTMO non ha limite di tempo: `docs/REGOLAMENTO_FTMO_2026-08.md` r.17) e con la fortuna: **non distingue "ha edge" da "e' passato"**.

### 3.2 Le statistiche [LETTO; DICHIARATE: sono le sue, calcolate con il suo strumento]
- **Su che dati**: "XAUUSD_icmarkets" H4, 2020.01.02-2026.07.08; il testo dice "Real Tick data"; il Monte Carlo "retest" randomizza i dati **"by tick"** [LETTO]. **Il modello di backtest esatto (tick reali dall'intera storia?) non e' scritto da nessuna parte** [INCERTO].
- **Capitale**: 10.000 USD [DERIVATO: 27,6% di profitto = 2.758,79; "yearly avg profit 459,67 = 4,6%"].
- **Rendimento reale piccolo**: **4,6% l'anno (CAGR 4,14%)** con lotti di 0,01 [LETTO]: i numeri di marketing come "PF 1,85" stanno su un rischio di **circa 0,3% a trade** [DERIVATO]; **il venditore poi lo gira al 3,5%** (G9).
- **Concentrazione**: il 2026 e' il **37,4%** del profitto e ha **lotti doppi** (0,02 contro 0,009-0,01) [DERIVATO + volume nel grafico]. A lotti costanti il 2026 varrebbe meno, circa la meta' o poco piu' [DERIVATO, approssimato: dal grafico dei volumi ~28 delle 36 operazioni 2026 sono a 0,02]. In termini percentuali il 2025 (anno record dell'oro) e' uno dei piu' deboli: **+2,7%, PF 1,33**.
- **Controprova a suo favore**: **tutti i sette anni sono positivi**, **entrambi i lati guadagnano**, e **il 2025 non e' il suo anno migliore**: **non si comporta come un puro beta sull'oro che sale** (a differenza dell'EA gratuito G10, che e' solo long e prende il 27% nel 2025). Il motore va tenuto sotto osservazione, non liquidato.
- **Insidie [DERIVATO/INFERITO]**: (a) IS 204 operazioni = 2020-2023, OOS 124 = 2024-2026: **l'OOS e' un solo regime** (oro in rialzo storico), e **la strategia e' stata scelta fra molte** (nomi `(H4)01` e `(H4)06`; "DATABANKS 3" nella barra di stato) con il flusso tipico di SQX: la scelta guarda anche l'OOS; (b) PF OOS 1,97 maggiore di PF IS 1,74 e' compatibile sia con edge robusto sia con scelta fatta sull'OOS; (c) nessuna prova **fuori dal suo strumento** (nessun rifacimento in tester MT5 da parte di terzi).
- **Incongruenze interne [LETTO]**: (1) testo: "Optimization Window 1.214 giorni, ciclo 121 giorni"; immagine: **"158 giorni su 789 giorni"**; il testo identico e' sul prodotto H1 da 199 USD, quindi e' **un modello di testo, non il WF di questa strategia**. (2) La somma dei profitti OOS delle nove finestre visibili e' **1.718,46** [DERIVATO], il pannello dice **"WF Net profit (OOS) 2.066,09"** (differenza 347,63, **[NON RICONCILIATA]**). (3) Il Monte Carlo "trades manipulation" (G5) e' di `(H4)01`, le altre schede sono `(H4)06`.

### 3.3 Monte Carlo (G4, G5): cosa dimostrano e cosa NO
- **Il "trades manipulation" (G5) rimescola le stesse operazioni** (blocchi da 50, ordine, skip 3%): **dice che il DD dipende poco dall'ordine; NON dice nulla sull'esistenza di un edge** (se la media per trade e' positiva, rimescolare la lascia positiva). Il 95% resta a +5.120 contro un "Original" 8.824: normale.
- **Il "retest" (G4) e' piu' interessante**: stressa **spread (10-50), slippage (0-15), dati**: **-12% di profitto al 95%**. **Se i numeri sono veri, il motore sopporta i costi**: lo stop medio (~32 USD) e' ~64-320 volte lo spread simulato (10-50 punti = 0,10-0,50 USD [INFERITO: oro a 2 decimali]): **sopra la nostra frontiera `stop >= 40 x spread` con ampio margine** [DERIVATO].
- **Limite**: tutti i test sono sugli **stessi dati di costruzione**; nessuno prova un'altra epoca o un altro mercato.

### 3.4 Walk-forward (G6)
- **Cosa dice [LETTO]**: se si **ri-ottimizza** i parametri su 588 giorni e si applica ai successivi 178, le 9 finestre successive sono **tutte positive** (19-571 USD, poche decine di operazioni ciascuna: 20-47). Nove finestre positive su nove con n piccolo e ordine di grandezza del profitto che va da 19 a 571: **plausibile, non decisivo**.
- **Cosa NON dice**: (1) che i parametri che il compratore ricevera' (o che il venditore ha bloccato) siano quelli del WF: **la strategia finale ha i suoi parametri e i "parametri aggiornati ogni 3 mesi" richiedono che il compratore riceva un nuovo file ogni trimestre** (non risulta dalla pagina come: [INCERTO]); (2) che il WF sia stato fatto su una strategia **non scelta** guardando l'intera storia: la **famiglia** (breakout H4 su oro) e' stata scelta **sapendo** com'e' andata; (3) **il WF di SQX testa se ri-ottimizzare funziona, non se l'edge vale in un mercato diverso**.

### 3.5 Recensioni (2) [LETTO, profili aperti]
1. **Cristian-bogdan Buzatu**, 18/06/2025, 5 stelle: *"deserves 5 stars, and the seller as well - he helps you along the way and explains everything"*. Profilo: Romania, 2 anni di esperienza, 4 prodotti, 2 segnali, 125 amici, canale Telegram "GOLD Trader Buza". **Plausibilmente reale e indipendente** [INFERITO dal profilo]. **Parla del supporto, non dei risultati.**
2. **Vernkham Sorsavanh**, 07/06/2026, 5 stelle **senza testo** (*"User didn't leave any comment"*); il venditore risponde in 14 minuti. Profilo: **Laos, come il venditore**; **vende prodotti con descrizione quasi identica** ("Xauusd Breakout H4 mt5", "Xauusd Breakout H1 mt5" a **222,22 USD**, pubblicati il 14 e 16/07/2026, e un segnale "Gold Breakout Power H1 H4" a 39 USD) [LETTO]. **Il recensore e' un concorrente/affiliato dello stesso ambiente, con lo stesso testo di vendita**: non e' una recensione indipendente [INFERITO: stesso Paese, stesso modello di testo]. **Non e' dimostrato** che sia lo stesso autore.
- **Verdetto**: 2 recensioni, 1 senza testo e di un soggetto collegato, 1 sul supporto. **Valore informativo sul motore: ~zero.** E sul segnale: **3 stelle** da Eun Kim (*"inactivity... not worth the fee"*, 28/07/2026) e un avviso di Nhut Anh Phan (18/05/2026): *"If you open 3 trades simultaneously, the risk is too high"* [LETTO].

### 3.6 Attivazioni (9), data di aggiornamento (7/10/2026)
- 9 attivazioni in **18 mesi** dalla pubblicazione (28/03/2025) con **390 demo scaricate** = **2,3%** di conversione demo-attivazione [DERIVATO]. Le attivazioni includono rinstallazioni e noleggi: i compratori veri sono **<= 9** [INFERITO].
- Il prodotto sorella H1 (199 USD) ha 10 attivazioni e 44 demo in 3 mesi [LETTO 09/10].
- **Aggiornato il 7/10/2026 = 2 giorni fa**: cambia **qualcosa** (v1.7 contro 1.4 del 14/07) e non so cosa. **Il testo "What's new" non l'ho letto** [INCERTO]. **Chi studia questo prodotto sta guardando un bersaglio che si e' mosso due giorni fa.**

### 3.7 Il segnale live del venditore (G9) e la sua storia [LETTO, 4 screenshot del venditore + pagina]
| quando | segnale | risultati dichiarati | DD | note |
|---|---|---|---|---|
| 13/06/2025 | 4 segnali "Breakout Robot H4", "Breakout Robot MT5", "Gold Breakout PRO", "H1+H4 on Axi Prop firm" | PF 2,26 / 1,36 / 1,49 / n.d.; crescita 74% / 110% / 249% / 6%; **saldo 315-2K USD**; 7-23 settimane | **15% / 51% / 54% / 2%** | **due dei quattro DD sono 51-54%** (gli altri 15% e 2%); ultimo = un **conto prop (Axi Prop) con una settimana di vita** |
| 24/11/2025 | "Breakout EA All Star" (30 sett.) | crescita 139%; **versamenti 3.825,94, prelievi 2.178,52** | 28,9% | ordini pendenti stop visibili |
| 22/02/2026 | "Gold Breakout PRO" (7 sett.) | crescita 324%; 1 posizione; prelievi 1.500 su 1.517 | **30,5%** | |
| 03/07/2026 | "Gold Breakout PRO All Star" (26 sett.) | **1.218% da inizio 2026**; prelievi 2.646 contro 716 versati | **35,3%** | |
| 09/10/2026 | stesso (40 sett.) | PF 2,10; 119 operazioni | 35,31% bal / 24,99% eq | **avvisi di piattaforma**: *"Too much growth in the last month indicates a high risk"*, *"Share of days for 80% of growth is too low (9 giorni, 3,26%)"*, **"No trading activity for the last 6 days" (22/09)** |
- **Lettura**: **tutti i risultati live sono su conti piccoli (300-1.500 USD) con rischio 3,5% e DD 25-54%**; nessuno e' a rischio da prop. **La "crescita" del segnale e' gonfiata** dalla base piccola e dai prelievi. **Il PF 2,10 e il win rate 68% sono compatibili con il backtest (1,85 / 69%)**: questo e' **a favore** del motore (mismatch assente su PF/win rate), ma **non e' una prova** su 119 operazioni, miscela di due EA (H1+H4).
- **Concorrenza interna sul conto**: due posizioni Buy 0,01 **allo stesso prezzo e SL** (24/11/2025: 4050,57 e 4050,55) = **due EA, stesso simbolo, stesso lato, stesso istante**. **E' esattamente la sovrapposizione che la nostra regola di casa vieta** ("mai due EA stesso segnale/simbolo/lato a rischio pieno").

---

## 4. BANDIERE ROSSE (setaccio)

| bandiera | esito | evidenza |
|---|---|---|
| martingala / griglia / recovery | **assenti [DICHIARATO]**, nessuna traccia nei suoi screenshot di segnale | pagina e segnale dicono "No grid, no martingale" |
| **SL non verificabile** | **GIALLA** | gli **ordini pendenti nel segnale (24/11/2025) hanno S/L vuoto** [LETTO]; il segnale dichiara "SL fixed", e la pagina "Cut Loss System" (**un'uscita a mercato non e' uno stop server-side**) [INCERTO su dove vive] |
| **rischio dichiarato 3,5% per trade** | **ROSSA per un uso prop** | G9; DD 25-35%; "3 trade simultanei" |
| **"passa la prop" garantito** | **GIALLA-ROSSA** | non scrive "garantito", ma usa un certificato FTMO come prima immagine, e il plugin "2-Step Challenge Analyzer" dice **"100% pass probability"** (con il suo stesso avviso in giallo: *optimistically biased*) |
| **curve fitting dichiarato** | **GIALLA** | strategia generata da software, scelta su una storia nota, "parametri aggiornati ogni 3 mesi"; il testo WF (1.214/121) **non coincide** con l'immagine (789/158) |
| **un solo certificato, due EA** | **GIALLA** | §3.1 |
| **recensioni di facciata** | **ARANCIONE** | 1 recensione senza testo di un venditore collegato; una vera ma sul supporto |
| **numeri incoerenti fra immagini** | **ARANCIONE** | MC di `(H4)01` accanto a statistiche di `(H4)06`; WF OOS 1.718 contro 2.066 dichiarato |
| **rendimento reale modesto** | **informativa** | CAGR 4,1% a 0,3% di rischio |
| **bersaglio che si muove** | **ARANCIONE** | v1.7 del 07/10, contenuto sconosciuto; 4 prodotti quasi uguali a prezzi 199-399 |
| **DLL / repaint / hedging fra conti** | **non determinabile** | nessuna indicazione; il prodotto non ne parla, il codice e' compilato [NON VERIFICABILE]. Il segnale e' su **un conto**; la regola FTMO su EA commerciali di terzi (`docs/REGOLAMENTO_FTMO_2026-08.md` r.36: *"there might be other traders already using the same EA... you potentially run a risk of being denied the FTMO Account"*) si applica **a qualunque EA in vendita** |
| prezzo | **399 USD (o 100 per 3 mesi)** | **la demo Market gira nel tester** (cancello `CANCELLO_ACQUISTI_EA.md`): si puo' misurare **senza comprare** |

**Sintesi bandiere:** **nessuna bandiera "da bocciare subito"** (niente martingala, niente griglia, niente promessa assoluta), **ma** rischio di funzionamento del venditore (3,5%), prove costruite sugli stessi dati, un campione di uno come certificato, recensioni di facciata, e numeri incoerenti fra i suoi stessi grafici.

---

## 5. IL CONFRONTO CON IL NOSTRO LAVORO

### 5.1 Stessa famiglia?
**Si' come famiglia concettuale, no come istanza.** Tutti e tre condividono: **rottura di un massimo/minimo di N barre + filtro di trend + uscita gestita**.

| aspetto | GBA di Emiliano (`EA_NOTTURNO_GBA_SPECIFICA_2026-10-09.md`) | nostra bozza `ABTG_GoldBreakoutATR.mq5` | Gold Breakout PRO (G1-G9, **dedotto**) | EA gratuito Ali (G10, sorgente) |
|---|---|---|---|---|
| TF segnale | **M1** (a voce M3) | `InpSignalTF = M1` (asse M5) | **H4** | **H4** |
| canale | **48 barre**, chiusura oltre max/min precedenti | `InpChannelBars=48` | "Highest-Lowest", N **[INCERTO]** | **20 barre**, chiusura oltre il massimo |
| ingresso | a mercato alla barra dopo la chiusura | idem (R3) | **ordini STOP** sul livello [INFERITO] | a mercato alla barra dopo |
| trend | **EMA 100** | `InpEmaPeriod=100` | non dichiarato | **EMA 200** |
| SL | **2,5 x ATR(14)** | `InpSL_ATR=2.5` | fisso, 0,3% [DERIVATO] | **2,0 x ATR(20)** |
| TP | **nessuno** (trailing) | nessuno | **fisso** (TP a ~60-156 USD) | **2R** (default) o trail 3 ATR o canale 10 |
| trailing | 2,5 ATR dal massimo | `InpTrail_ATR=2.5` | quando in profitto [DICHIARATO] | opzionale |
| tempo | **48 barre** | `InpTimeExitBars=48` | non dichiarato (tenuta media 10 barre H4) | 10 barre (modo B) |
| BE | a +1 ATR | `InpBE_TriggerATR=1.0` | si' (SL sopra l'ingresso nelle posizioni) | no |
| spread | **<= 5% ATR** (o 35%) | `InpSpreadMaxATR=0.05` | non dichiarato | **<= 10% dello stop** |
| lati | long e short | idem | **entrambi positivi** | **solo long** (gli short perdono) |
| rischio | lotti **10** (1,55% sul suo conto) | **1,00 lotto** (decisione 09/10) | **3,5%** (live), ~0,3% (backtest) | 1% |
| frequenza | **~12 al giorno** nel suo pannello | non misurata | **~1 a settimana** | ~30 all'anno |

### 5.2 Cosa e' utile come IPOTESI da misurare (mai criteri, mai valori copiati in forward)
1. **Il tempo del segnale come asse (H1/H4) e non solo M1/M3/M5.** Perche': (a) nel tester **100.000 barre = ~70 giorni su M1 sull'oro** [DERIVATO dal tetto delle ~100.000 barre di CLAUDE.md, oro ~23 ore al giorno]: **il GBA su M1 ha una finestra di prova di pochi mesi**, mentre **H4 ne ha 6+ anni e tocca piu' regimi** (regola C dell'emendamento 16/08); (b) a H4 lo stop (~30 USD) e' **decine o centinaia di volte lo spread**: la frontiera del costo `>= 40` e' superata con margine, mentre su M1 il filtro spread 0,05 ATR e' il vero cancello. **Il certificato di morte chiede il TF cambiato almeno una volta**: questo e' il modo.
2. **Il TP fisso (multiplo dello stop) come uscita da mettere ad asse.** Il GBA non ne ha. **G11** dice che **tre uscite diverse danno totali molto diversi sullo stesso motore (+2.554 / +3.393 / +4.579) e che la migliore cambia da un anno all'altro**: e' proprio l'asse "gestione dell'uscita" richiesto dal certificato dei 5.
3. **Uscita "se la condizione sbaglia" ("Exit If Wrong Condition" del venditore).** Es.: chiudere se la barra rientra nel canale entro k barre dall'ingresso, o se la chiusura torna oltre l'EMA. **Non esiste nel GBA**; ipotesi con un meccanismo preciso, non un parametro.
4. **Ingresso con ordine stop sul livello** contro ingresso a mercato alla barra successiva. Su H4 il ritardo di una barra e' 4 ore: ordine pendente e a mercato **si comportano molto diversamente** (slippage, gap). Misura da fare con tick reali.
5. **Long e short separati, per regime.** L'EA gratuito dice: **short -2.080 in sei anni di oro in rialzo**; il venditore dice short positivi. **Due fonti si contraddicono = una misura da fare** (regola dei due lati del 25/08, gia' di casa): per il GBA ogni cella va letta per lato e per regime (2020-2023 / 2024-2026).
6. **Un tetto di operazioni per giorno / posizioni contemporanee.** Il segnale del venditore e' criticato dai suoi iscritti per **3 posizioni aperte insieme** (G9); **da noi gia' coperto** da P0/P1/C1 del Guardian: nessun buco.
7. **Spread come % dello stop, non solo dell'ATR** (G10: 10%). Equivale a `InpSpreadMaxATR` con SL fisso in ATR: **nessun valore nuovo**, solo un modo diverso di scrivere la stessa soglia.

### 5.3 Una verifica a costo zero sul NOSTRO codice (non e' una caccia, e' un difetto potenziale in bozza)
L'autore di G10 scrive: *"on MetaQuotes-Demo, SYMBOL_TRADE_TICK_VALUE for XAUUSD is 0.10 while the real value of a point is 1.00, and an EA that trusts it risks ten times what you asked for"* e dimensiona i lotti con **`OrderCalcProfit()`**. **La nostra bozza usa `SYMBOL_TRADE_TICK_VALUE_LOSS` (poi `TICK_VALUE`), mai `OrderCalcProfit`** (`ABTG_GoldBreakoutATR.mq5` r.544-545). Con `InpLotMode=0` (1,00 lotto fisso, decisione di Claudio) **non c'e' effetto**; **con `InpLotMode=1` (rischio %) il calcolo va confrontato con `OrderCalcProfit` sul terminale BCM** prima di accendere quella modalita'. [INFERITO: non ho visto il tick value di BCM sull'oro.]

### 5.4 Cio' che NON ci portiamo a casa
- **La reottimizzazione trimestrale**: **la regola del 19/08** (niente griglie su motori senza edge) e quella del 09/09 vanno nella stessa direzione: **una rotazione periodica dei parametri e' il processo che produce il picco di rumore**. Un EA schierato **non cambia parametri** senza passare dall'imbuto.
- **Il rischio del 3,5%**: non e' un esempio, e' un contro-esempio di taglia (G9).
- **I numeri del venditore**: **non pesano nulla** per la decisione (§3).

---

## 6. LE PROPOSTE (formato cosa / dove / costo / rischio)

Tutte **passano dall'imbuto**, girano **sul PC di backtest** (non sul VPS, regola del 21/09), **mai in forward**, **nessun parametro cambia sulle sedie vive**. Aspettare il cancello `controllo-preventivo` + `controlla_riga.py` prima che qualunque riga arrivi a Claudio.

```
PROPOSTA   P1: asse TF del segnale nel collaudo GBA: aggiungere H1 e H4 a {M1, M3, M5}
DOVE       procedura di test su ABTG_GoldBreakoutATR (nessun cambio di codice: InpSignalTF c'e' gia'); durata del canale
           FISSATA A PRIORI in tempo (es. 8 h / 24 h / 48 h) e tradotta in barre per TF, NON una griglia su N
FONTE      G1 (H4), G10 (H4 20 barre), vincolo barre del tester (CLAUDE.md)
COSTO      ~1-2 ore di preparazione + 1 round tester (XAUUSD; poi XAGUSD e un indice come gemelli, da dichiarare)
RISCHIO    N fisso a 48 su H4 = 8 giorni di canale: non e' la stessa strategia; per questo si dichiara la durata in ore.
           A H4 la frequenza scende (~1 a settimana per simbolo): serve la misura per FAMIGLIA, non per sedia
```
```
PROPOSTA   P2: uscita a TP fisso (multiplo dello stop) e uscita "condizione sbagliata" come input nuovi, DEFAULT SPENTI
DOVE       input nuovi in ABTG_GoldBreakoutATR: InpTP_R (0 = spento), InpExitWrongCond (0/1/2: spento / rientro nel canale entro k barre / chiusura oltre EMA)
FONTE      G11 (tre uscite, risultati divergenti), G9 ("Exit If Wrong Condition")
COSTO      ~2-3 ore di codice + 1 round (cella di REPLICA = comportamento attuale; celle di misura: TP 1,5R / 2R / 3R, k = 6 / 12 barre)
RISCHIO    ogni uscita nuova e' una nuova scelta: la cella si sceglie al CENTRO dell'altopiano, mai al picco. Tre valori per input, non una griglia
```
```
PROPOSTA   P3: separare long e short per regime nel collaudo del GBA e delle altre sedie su oro
DOVE       procedura di collaudo (InpAllowLong/InpAllowShort ci sono gia'); finestre di regime 2020-2023 e 2024-2026
FONTE      G10 (short -2.080) contro G2/G9 (short positivi): due fonti che si contraddicono
COSTO      nessun codice; 4 celle (L, S, L+S, per 2 regimi) = 1 round
RISCHIO    dati BCM sull'oro: la profondita' va misurata con una sonda (regola dei due lati e storico lungo)
```
```
PROPOSTA   P4: verifica del dimensionamento: confrontare `GbaTickValue()` con `OrderCalcProfit` sul terminale 50504400 (PC di backtest) PRIMA di InpLotMode=1
DOVE       ABTG_GoldBreakoutATR r.544-557, procedura di test (stampa di confronto in AutoTest)
FONTE      G10, avvertimento esplicito dell'autore
COSTO      ~1 ora; nessun round
RISCHIO    nessuno oggi (il lotto fisso non e' toccato); evita un rischio 10x se si passa a rischio %
```
```
PROPOSTA   P5 (solo SE Claudio vuole l'unica misura diretta sul prodotto): demo del Market nel tester, 1 passata, dopo il cancello degli acquisti
DOVE       PC di backtest, terminale banco; scheda -> setaccio -> demo nel tester -> verdetto (CANCELLO_ACQUISTI_EA.md, gradini 1-5)
FONTE      G1; unica via per vedere gli input reali e il comportamento (pendenti, SL, orari) dei trade
COSTO      ore del PC di backtest, 0 USD (la demo e' gratuita; "si paga il prodotto, mai la promessa"); NON acquisto
RISCHIO    la demo del Market gira nel tester ma puo' essere limitata a un periodo/simbolo/quantita'; il motore e' compilato (nessun sorgente)
           e il prodotto e' stato cambiato 2 giorni fa. NON va fatta sul VPS mentre la challenge e' viva
```
**Non propongo l'acquisto.** Il criterio dei prodotti non e' "funziona?" ma "quale meccanismo dichiara e ci manca": sono **tre idee** (P1, P2, P3), nessuna richiede di comprare nulla. La demo (P5) e' facoltativa e serve a leggere **gli input veri**, cosa che nessuna pagina pubblica fa.

---

## 7. LA TABELLA DEI BUCHI (meccanismi trovati fuori contro quello che abbiamo)

| meccanismo trovato fuori | fonte | lo abbiamo? | dove | stato |
|---|---|---|---|---|
| canale highest/lowest + filtro EMA + ATR | G1, G10, GBA | **si'** | `ABTG_GoldBreakoutATR` r.119-143 | coperto (bozza, non compilata) |
| ordine STOP sul livello invece di mercato alla barra dopo | G9 (inferito) | **no** | GBA entra a mercato (R3) | **buco da misurare**: ipotesi 4 |
| **TP fisso a multiplo dello stop** | G9, G10, G11 | **no** nel GBA | assente tra gli input | **buco** -> P2 |
| **uscita "se la condizione sbaglia"** | G9 | **no** | assente | **buco** -> P2 |
| uscita a tempo | G10 (10 barre) | si' | `InpTimeExitBars` | coperto |
| trailing in ATR | G10 (3 ATR) | si' | `InpTrail_ATR` | coperto |
| breakeven | G9 | si' | `InpUseBreakeven` | coperto |
| spread relativo allo stop | G10 (10%) | **si', in altra forma** | `InpSpreadMaxATR` | coperto (stessa soglia, altro modo di scriverla) |
| long/short accendibili | G10 | si' | `InpAllowLong/Short` | coperto |
| un solo trade per giorno / tetto operazioni | G9, G10 | **si' nel Guardian** | P0/P1/C1; GBA: una posizione per magic | coperto |
| perdita giornaliera massima | G9 | si' | `InpMaxDailyLoss` (0 = spenta) | coperto |
| **dimensionamento con `OrderCalcProfit`** | G10 | **no** | GBA usa TICK_VALUE_LOSS | **buco potenziale** -> P4 |
| TF alto (H1/H4) | G1, G10 | **si' nel codice, non nel collaudo** | `InpSignalTF` | **buco di misura** -> P1 |
| reottimizzazione periodica | G1 | no | **volutamente NO** | rifiutata (§5.4) |
| rischio 3,5%/trade | G9 | no | **volutamente NO** | contro-esempio di taglia |
| doppio EA sullo stesso conto e lato | G9 | **no, vietato in casa** | regola "mai due EA stesso segnale/simbolo/lato" | difesa nostra gia' attiva |

**Il nostro Guardian copre tutto cio' che questo prodotto dichiara a livello di protezione.** I buchi stanno nel **motore** (P1-P4), non nella protezione.

---

## 8. COSA NON HO POTUTO VEDERE

1. **Input, `.set`, sorgente, ora di apertura, filtro news, finestre orarie**: **non pubblici** (quattro pagine controllate).
2. **"What's new" (da 1.0 a 1.7), "Comments", canale `goldbreakoutpro`**: non letti (login o caricamento dinamico).
3. **Il QR del certificato**: non decodificato; sito FTMO non consultato.
4. **L'estratto conto della challenge FTMO**: non esiste pubblicamente.
5. **La storia dei trade del segnale**: richiede il login; ho solo le statistiche e 4 screenshot suoi.
6. **Se i dati del backtest sono tick reali dall'intera storia o OHLC**: non scritto.
7. **Se il valore dell'oro sul broker del venditore (IC Markets) e' quello di BCM**: gli spread BCM sull'oro vanno **misurati**.

---

## 9. IN UNA FRASE PER CLAUDIO

**Il prodotto non rivela nessun parametro e non ci insegna niente che dobbiamo comprare**: e' un breakout H4 su oro, generato con StrategyQuant, con numeri propri plausibili e non verificabili (PF 1,85 su 328 operazioni a ~0,3% di rischio, tutti gli anni positivi, entrambi i lati), un certificato FTMO che non dice niente sul prodotto, e un conto live del venditore al **3,5%** di rischio con DD 25-54%. **La famiglia e' la stessa del GBA** (rottura di canale + trend + uscita gestita), **a un altro tempo** (H4 contro M1). Le **tre cose da misurare, tutte senza comprare**: **H1/H4 come asse del GBA**, **TP fisso e uscita "condizione sbagliata"**, **long e short per regime**; **piu' un controllo di 1 ora** sul dimensionamento (`OrderCalcProfit`).

---

## 10. FONTI (URL esatti, data di accesso 09/10/2026)

- Prodotto: <https://www.mql5.com/en/market/product/135291> (pagina letta intera; immagini `c.mql5.com/31/2174/gold-breakout-pro-mt5-screen-6785.jpg`, `.../2189/...-2584, -4925, -5942, -6150, -7516, -7822, -8531, -8913, -9290.jpg`, `.../2422/gold-breakout-pro-mt5-screen-1652.jpeg`)
- Prodotto H1 (stesso testo): <https://www.mql5.com/en/market/product/185662>; MT4: <https://www.mql5.com/en/market/product/135280> (non piu' acquistabile)
- Profilo venditore: <https://www.mql5.com/en/users/daosengathit> (post del 13/06/2025, 23/11/2025, 21/02/2026, 14/07/2026, 29/09/2026 con immagini `c.mql5.com/1/312/Screenshot_2025-06-13_113817.jpg`, `.../325/Screenshot_2025-11-24_042344.png`, `.../334/Screenshot_2026-02-22_030828.png`, `.../347/Screenshot_2026-07-03_114218.png`, `.../357/1790592174220.jpg`)
- Segnale: <https://www.mql5.com/en/signals/2351091>
- Recensori: <https://www.mql5.com/en/users/buza20>, <https://www.mql5.com/en/users/vernk855>; prodotto collegato: <https://www.mql5.com/en/market/product/185700> (e 185697, 185699, 185701)
- EA gratuito di confronto (sorgente, inputs, risultati): <https://www.mql5.com/en/code/77691>
- Nostro: `report/EA_NOTTURNO_GBA_SPECIFICA_2026-10-09.md`, `mql5/Experts/ABTG_GoldBreakoutATR.mq5` (bozza), `docs/REGOLAMENTO_FTMO_2026-08.md` (r.17, r.36)

Non esiste un file-indice `report/CACCIA_*`: i dossier sono richiamati nei documenti che li usano; nessun indice da aggiornare.
