# Portafoglio scelto da Claudio per i tre conti prop: 160k + 80k + 80k (11/11/2026)

**Decisione di Claudio (11/11)**: "puntiamo su questa". Questa e la combinazione salvata. Natura: stima da backtest (tester BCM, 3 anni 2013 / 2020 / 2025, costi "centrali"), NON una previsione. Fonti: `RISULTATI_D160_ORO_2026-11-09.md`, `TRE_PROP_PROPOSTA_2026-11-11.md` (confronto e tabella dei costi), script `ORO_GRADINI_dati/tre_port.py`.

## I tre conti
| Conto | Combo | Componenti e set di Wim (nomi usati nei test) | Media annua a 80k (dopo costi) | Sul conto | PF (2013 / 2020 / 2025) | DD realizzato | Peggior giorno |
|---|---|---|---|---|---|---|---|
| **160k** | **P1** | Gold Phantom Gradino 1 (`GoldPhantom_Propfirm.set`) + Goldbot One Prop (`Goldbot_PropFirm_5_2.5.set`) + Daytrade Pro Max9 (`Daytrade_Pro_Max9%DD_lowrisk.set`) | 30.582 | **61.164** (x2) | 1,68 (1,52 / 1,82 / 1,75) | 6,5% | -4,4% |
| **80k** | **P3** | Goldbot One Combo 3GOLD (`Goldbot_PropFirm_combo_3GOLD.set`) + Gold Trade Pro Combo (`Goldtrade_V4.0_prop firm_combo.set`; nei test Risk=3, MaxRiskPerStrategy 0,5, PropFirmMaxDailyDD 4,0) + Daytrade Pro Max9 | 25.685 | **25.685** | 1,76 (1,81 / 1,92 / 1,51) | 6,7% | -4,1% |
| **80k** | **P4** | Gold Reaper Combo 3GOLD (`Gold_reaper_propfirm_combo_3GOLD.set`) + Goldbot One Prop (`Goldbot_PropFirm_5_2.5.set`) + Daytrade Pro Max9 | 24.788 | **24.788** | 1,67 (1,55 / 1,95 / 1,52) | 6,6% | -3,7% |
| **Totale** | | 320k di capitale equivalente | | **111.637 EUR/anno** (lordo, prima del profit split) | | congiunto 6,6% (2013) | congiunto -4,1% di 320k |
Per anno (totale): 2013 117.440 / 2020 132.871 / 2025 84.600. Variante P5 al posto di P4 (Phantom Prop + Goldbot Prop + Daytrade Pro): 111.227.
I nomi dei set sono quelli dei test (`gen_riga_d160_oro.py`, `gen_riga_d160_dtp.py`); prima di caricarli su un conto va verificato file per file che siano quelli delle versioni correnti di Wim (versioni EA sul VPS e sul trial NON verificate).

## Rischi noti di questa scelta (gia detti, qui per memoria)
1. **Peggior giorno realizzato -4,4% (P1) e -4,1% (P3)**: a ridosso del Guardian (4,3%) e del limite FTMO (5%). Un giorno oltre -4,3% nei 3 anni per P1.
2. **DD equity: limite superiore 12,6-13,2% per conto nel 2013** (somma dei massimi dei singoli EA, non ricostruita): sopra il 10% di FTMO. Il valore vero e sconosciuto per i conti con Daytrade Pro (nessuna barra forex).
3. **Posizioni opposte fra conti** (FTMO le vieta in modo rigoroso): oro su tutti e tre i conti, 2.451-10.718 ore a coppia in 3 anni nel tester; domanda 1 della seconda mail a FTMO ancora senza risposta (mail non inviata).
4. **Stessa strategia su piu conti** (tetto 400k per strategia valutato con altri utenti): Daytrade Pro su 3 conti, Goldbot Prop su 2, Goldbot su 3 con Combo.
5. **Costi**: nei numeri c'e l'ipotesi mia di 36 EUR/lotto oro e 4 EUR/lotto forex; costi FTMO veri (commissione, spread, swap) NON ancora letti (raccolta in corso, `PROMPT_ESTENSIONE_CHROME_FTMO_COSTI_2026-11-11.md`). Sensibilita: 130.079 (tester puro) / 120.664 / 111.637 / 94.134 (prudente). Non applicati: venerdi (-7/-12%), tick reali (-3/-8%), profit split.
6. Backtest su 3 anni, un percorso per anno, rumore su Phantom e Reaper; nessun forward su questa combinazione; margine/leva oro FTMO 1:50 e limiti di lotto NON verificati.

## Cose da chiudere prima di caricare i set (ordine)
1. Risposta di FTMO sulle posizioni opposte e sulla strategia identica (mail seconda bozza, 7 domande): da leggere e inviare da Claudio.
2. Costi FTMO veri (zip della raccolta) e ricalcolo.
3. Guardian v1.18 provato su un demo (richieste al server) e input dei set verificati su trial/reale.
4. Test Virtual SL/TP (righe pronte, da lanciare sul PC di backtest).
5. Forward su demo della combinazione, se Claudio lo vuole.
Nessuna indicazione di acquisto, lotto o taglia: la scelta e di Claudio.

## Proposta di Claudio (11/11): operare con conti FTMO SWING
**Motivo**: gli EA di Wim sono pensati per restare aperti nel weekend e i backtest (tutti) li tengono aperti; chiudere il venerdi costa guadagno (misurato 7-12% del netto per EA; per Gold Trade Pro -31% nel 2020). **Cosa dice FTMO (risposta scritta 10/11 e FAQ)**: Swing "nessun limite su news e weekend"; disponibile **solo sul 2-Step**; leva Swing 1:15 sull'oro (categoria "Metalli": XAUUSD non nominato) e 1:30 sul forex; il Swing non si puo cambiare dallo Standard dopo l'acquisto; prezzo e ripartizione dello Swing NON comunicati (da leggere sul sito). Lo Standard funded deve chiudere se il mercato e chiuso piu di 2 ore e ha la finestra news su XAUUSD/DXY: lo Swing evita entrambe le cose, che i backtest non modellano.
**Margine a 1:15 (oro) e 1:30 (forex)** sui tre conti, ricostruito dalle posizioni dei report (somma dei nozionali aperti contemporaneamente a prezzo di ingresso; EUR/USD medio dell'anno; base forex approssimata; BCM nel tester ha un margine fisso per lotto, quindi questo e un calcolo a parte). Margine massimo in % del saldo iniziale (stessa % su 160k):
| Conto | Swing 2013 / 2020 / 2025 | Standard (1:50 oro, 1:100 forex) |
|---|---|---|
| P1 | 51% / 56% / 56% | 15-17% |
| P3 | 59% / 53% / 58% | 16-18% |
| P4 | 50% / 51% / 50% | 15% |
Con equity piena un margine del 50-59% dà un livello di margine circa 170-200%; a -4,5% di equity (Guardian) circa 160%, a -9,5% circa 153%. **Il livello di stop out di FTMO NON e noto** (non nelle pagine lette): non si puo dire quanto margine di sicurezza ci sia. Con meno posizioni libere un nuovo ordine puo essere rifiutato se il margine libero non basta (non misurato nel tester).
**Costi**: commissioni e swap nel tester gia comprendono il weekend (BCM). Lo Swing evita il costo della chiusura del venerdi e il problema della finestra news; i costi di spread/slippage di FTMO e le differenze di commissione/swap fra Standard e Swing NON sono noti.
**Da chiedere a FTMO prima di decidere**: prezzo e ripartizione dello Swing per 80k e 160k (esistono?), leva dell'oro nello Swing, livello di margin call e stop out, swap dello Swing, e se la regola sulle posizioni opposte vale anche per lo Swing.

## Filtro NFP degli EA e conto Swing (nota di Massimo, 11/11)
Fonte: `Filtri_news_Swing_per_Claudio.pdf` (Massimo): il filtro news degli EA e acceso nei set; scelta dei settaggi, non regola FTMO; parere: tenerlo ACCESO (come nei backtest), usare lo Swing per il weekend. **Verifica sui report del tester** (anno 2025, set correnti): `EnableNFP_Filter=true`, `NFP_CloseOpenTrades=true`, `NFP_ClosePendingOrders=true`; finestre (minuti prima / dopo): Phantom e Reaper 100 / 60, Goldbot 180 / 50, Gold Trade Pro 10 / 240; Daytrade Pro: nessun input NFP. Quindi in finestra gli EA **chiudono posizioni e pendenti** (non solo smettono di aprire). **Misura**: posizioni aperte attraverso il rilascio NFP nei backtest (date NFP, ora server BCM): 2025 = 0 in tutti e 4 gli EA (10 date); 2013 = 16 (Phantom L1), 3 (Reaper L0), 3 (Gold Trade Pro), 0 (Goldbot); 2020 = 9, 5, 1, 0. Letture: il filtro risulta attivo nel 2025; negli anni vecchi alcune posizioni lo attraversano (il tester puo non avere i dati calendario di quegli anni: NON verificato). Il filtro riguarda l'NFP: gli altri eventi della regola FTMO sull'oro (tasso Fed, PIL, verbale FOMC, CPI) non risultano coperti. Spegnerlo richiede un re-test (non fatto). Decisione proposta: Swing + filtro NFP acceso.

### Conferma dal vivo (Massimo, `Filtri_news_resoconto_completo_per_Claudio.pdf`, F7 sui conti attuali, 11/11)
Phantom e Goldbot sui conti: `EnableNFP_Filter=true`, `NFP_CloseOpenTrades=true`, `NFP_ClosePendingOrders=true`, finestre Phantom 100/60 e Goldbot 180/50 (uguali ai report del tester), `EnableIR_Filter=false` (nessun filtro sui tassi), `UseMQL5Calendar=true`, Virtual SL/TP spento, `FridayStopHour=25` (chiusura del venerdi disattivata), autoGMT acceso, Randomization Phantom 50 e Goldbot 0. Letture: gli EA si fermano **solo per l'NFP**; operano su tassi Fed/BCE, CPI, FOMC, PIL (sullo Swing nessun problema, sullo Standard funded violerebbero la regola ±2 minuti dell'oro). Reaper e Gold Trade Pro non letti da Massimo (nel tester: stesso filtro, finestre Reaper 100/60 e GTP 10/240). `UseMQL5Calendar=true` e compatibile con il fatto che nel tester 2013 e 2020 alcune posizioni attraversano l'NFP (il calendario storico del terminale potrebbe non coprire quegli anni): ipotesi, NON verificata. Parere di Massimo: lasciare l'NFP acceso, nessun re-test; il test con il filtro spento (`CRITERI_NFP_OFF_2026-11-11.md`) resta preparato ma e **facoltativo**.
