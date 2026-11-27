# Agente 1 - MQL5 Ecosystem Hunter (27/11/2026)

Metodo: ricerche WebSearch + lettura reale delle pagine con WebFetch. Tutto il contenuto web e trattato come dato non fidato; nessun file scaricato o eseguito, nessuna registrazione. Backtest e statistiche sono dichiarati dai venditori/autori, NON verificati da noi. Dove la pagina non riporta un dato: NON TROVATO.

Avvertenza strumento: alcune URL /market/product/ restituivano il catalogo generico invece della scheda (es. 166438, 139698, 166157, 131037, 172683, 126277): quelle schede NON sono state lette (vedi "Non verificato").

## Candidati (pagina aperta e letta)

### 1. Band Reversion EA - AUDNZD H1 (mean reversion forex)
- URL: https://www.mql5.com/en/market/product/196587
- Autore: Marc Eric Litzler (blueday68). Versione 1.0, pubblicato 17/09/2026. Licenza: 59 USD, demo gratuita (17 download demo, 5 attivazioni). Recensioni: nessuna.
- Asset/TF: nessun simbolo fisso, progettato e testato su AUDNZD H1. Sessione: NON TROVATO. Richiede conto HEDGING.
- Logica: tocco/rientro della banda di Bollinger + conferma RSI di "movimento stirato"; filtro di regime (pendenza di una media lunga e/o tetto ADX) che blocca gli ingressi in trend; TP = banda centrale come ordine reale (aggiornato a ogni chiusura barra); uscita a tempo dopo N barre. Scorrelato dall'oro: fade su cross range-bound, bassa esposizione a trend.
- Parametri: nomi/valori NON TROVATO (pagina descrive solo funzioni: lotto fisso / % equity / rischio con lotto massimo, filtro spread, distanza minima stop).
- Dichiarato: tick reali 100%, 01/2016-06/2026, deposito 10.000, profitto netto 881 USD, PF 1,34, 268 operazioni (circa 26/anno), win rate 61,6%, media vincita/perdita 21/25 USD, DD massimo di saldo 2,59%. Il venditore stesso lo chiama componente "a bassa volatilita e basso rendimento".
- Rischi: stop loss fisico NON dichiarato (solo "distanza minima di stop") da verificare; puo tenere buy e sell insieme; rendimento molto basso (881 USD in 10 anni su 10.000); nessun grid/martingale dichiarato ma neppure escluso esplicitamente.

### 2. Apex Origin - AUDCAD/NZDCAD/AUDNZD/EURGBP H1 (mean reversion forex)
- URL: https://www.mql5.com/en/market/product/166552
- Autore: Yi Hsiu Tsai. v1.51, pubblicato 23/04/2026, aggiornato 14/09/2026. Licenza: GRATUITO (scaricabile). Voto 4,91 su 39 recensioni, 55 commenti; segnale live collegato al profilo autore. Download: NON TROVATO.
- Asset/TF: AUDCAD di default, preset inclusi per NZDCAD, AUDNZD, EURGBP; H1. Sessione: NON TROVATO.
- Logica: "Enhanced Mean Reversion", dimensionamento lineare; "NO Martingale"; limiti di posizioni per simbolo; deposito minimo 500 USD (2.000 consigliati). Backtest 2010-2026 (in-sample 2010-2020, out-of-sample 2020-2026) senza cifre pubblicate.
- Parametri: NON TROVATO (manuale e file .set solo via messaggio privato all'autore).
- Rischi: logica e SL non documentati sulla pagina (un recensore lamenta che il sistema SL e difficile da trovare nei settaggi); "scaling lineare" va verificato che non sia averaging; codice chiuso, ma ha descrizione e 39 recensioni. Un recensore riporta circa 5% annuo in 2,5 anni (non verificato). Da provare su demo/tester prima.

### 3. Linear Regression Mean Reversion PRO - cross forex + indici H1
- URL: https://www.mql5.com/en/market/product/164713
- Autore: Marina Dangerio (AuroraQuantSystems). v1.3, 08/02/2026. Licenza: 149 USD (o affitto 49 USD/6 mesi, 99 USD/anno), demo gratuita (30 download demo, 5 attivazioni). Voto prodotto: NON TROVATO.
- Asset/TF: 13 preset FX (AUDJPY, AUDUSD, CADJPY, EURAUD, EURNZD, EURJPY, GBPAUD, GBPJPY, GBPNZD, CHFJPY, NZDJPY, USDJPY...) e 6 preset indici (AUS200, EUSTX50, FRA40, JPN225, NAS100, US500); H1 consigliato e testato. Sessione: NON TROVATO.
- Logica: regressione lineare con bande residue (OverSold/OverBought, LowerExtreme/UpperExtreme); ingresso al rientro attraverso la banda; uscita verso la linea di regressione; moltiplicatori di lotto dipendenti dalla pendenza. SL/TP basati su ATR (periodo e moltiplicatori configurabili), trailing, taglio parziale del rischio, stop opzionale a paniere e guardia sul drawdown equity.
- Parametri: valori NON TROVATO (solo in uno screenshot; file preset su richiesta dopo l'acquisto).
- Dichiarato: "No martingale, grid, averaging, hedging, or recovery logic". Backtest/DD: nessuna cifra nel testo.
- Rischi: nessuna cifra pubblica di DD/PF; preset su molti cross JPY (correlati fra loro); il moltiplicatore di lotto sulla pendenza va misurato.

### 4. OrdinalEdge Mean Reversion Asian Session - USDJPY M15 (mean reversion sessione asiatica)
- URL: https://www.mql5.com/en/market/product/175154
- Autore: Suarez Zackary Kyle. v1.0, 02/05/2026. Licenza: 39 USD o affitto 30 USD/mese; demo gratuita (13 download demo, 10 attivazioni). Recensioni: nessuna.
- Asset/TF: backtest USDJPY M15; dichiarato compatibile con qualunque simbolo/TF. Sessione: asiatica, tutte le posizioni chiuse prima della pre-apertura di Londra; orari specifici NON TROVATO (guida per messaggio privato dopo l'acquisto).
- Logica: estremi a breve rientrano verso la media statistica in condizioni di range, filtri multi-strato e conferma multi-timeframe; una posizione alla volta; tre profili di rischio (Conservative, Standard, Aggressive). "No martingale, grid, tick scalping".
- Parametri: NON TROVATO (solo i tre profili).
- Dichiarato (profilo Standard, tick 99%, 01/2023-24/04/2026, deposito 25.000, rischio 0,5%): profitto 5.020, PF 2,26, recovery factor 9,39, win rate 66,91%, 139 operazioni (circa 43/anno), DD massimo 2,02%.
- Rischi: SL/TP NON TROVATO ("rischio gestito dinamicamente"); campione 139 operazioni su 3,3 anni; solo backtest; l'orario dipende dall'offset server (vedi nota fuso).

### 5. FXEA365 Nasdaq Dip Buyer - NAS100/USTEC H4 (swing multi-giorno, long only)
- URL: https://www.mql5.com/en/market/product/181839
- Autore: Kenichiro Sakamoto (FXEA365). v1.75, pubblicato 17/06/2026, aggiornato 10/10/2026. Licenza: 30 USD (o 20 USD/mese; la pagina mostra anche un "launch price" 35 USD), demo gratuita (30 download demo, 5 attivazioni). Autore voto 5 (2 recensioni); prodotto: NON TROVATO.
- Asset/TF: CFD Nasdaq-100 (USTEC, USTECm, NAS100, US100) H4. Segue gli orari dell'indice. Conto hedging consigliato (su netting avvisa).
- Logica: solo long; opera solo con prezzo sopra SMA250; compra con RSI(14) <= 35; uscite (la prima che scatta): RSI > 70, 30 barre senza rimbalzo, stop ATR x 8 sotto l'ingresso. Una posizione alla volta. Meno di 10 operazioni/anno. Scorrelato dal trend/breakout oro (compra ritracciamenti).
- Parametri scritti: RunMode (default Ultra; opzioni Defensive, Standard raccomandato dall'autore, Aggressive, Ultra), TrendSMA 250, RSI_Period 14, RSI_BuyLevel 35, RSI_ExitLevel 70, SL_ATR 8, MaxHoldBars 30. NON TROVATO: RiskPercent, FixedLot, MaxLot, TrendTF_Bars, ATR_Period. Stop giornaliero, guardia perdite consecutive, pausa notizie, chiusura weekend opzionale; esiste un set prop firm in modalita Defensive.
- Dichiarato (tick reali Exness, qualita storico 6%, 10.000 USD, 01/2019-06/2026, 54 operazioni): Defensive +19,2% PF 1,86 DD 5,2%; Standard +41,3% PF 1,82 DD 10,2%; Aggressive +92,5% PF 1,74 DD 19,8%; Ultra +186,4% PF 1,63 DD 32,8%.
- Rischi: campione piccolo (54), qualita storico 6%, nessun forward; stop ATR x 8 molto largo; una serie di perdite in downtrend vero.

### 6. GER40 Evening Coil - GER40 H1 (sera, contrazione di volatilita) - CodeBase GRATUITO
- URL: https://www.mql5.com/en/code/78380
- Autore: Tomasz Wojciech Forszpaniak (tomekforszpania). Pubblicato 14/10/2026. Gratuito con sorgente completo (licenza formale non dichiarata). Voto 3 (3 voti), 2.031 visualizzazioni; 1 commento (non pertinente).
- Asset/TF: GER40 H1. Sessione: lun-ven, ingressi 18:00-21:00 ORA SERVER, chiusura forzata 23:00 server (o 1 minuto prima della chiusura GER40). L'EA stampa l'offset GMT all'avvio.
- Logica: solo long, una operazione alla volta. Segnale su ultima barra chiusa: (1) volatilita non in picco (ultimi 10 rendimenti orari < 1,6x i 100 precedenti); (2) tick volume della barra >= media 50 barre; (3) volume medio 252 barre sotto una soglia (livello NON dichiarato); (4) una delle ultime 13 barre era NR7. Ingresso all'apertura della barra successiva; SL 3,5 ATR, TP 4,5 ATR, uscita a tempo 23:00. L'autore dice che le condizioni vengono da ricerca automatica, senza giustificazione teorica.
- Parametri input: NON TROVATO sulla pagina (da leggere nel sorgente .mq5).
- Dichiarato (GER40 H1, 01/2022-13/10/2026, 10.000 USD, 5 lotti fissi, senza compounding): +37.647 USD, DD 10,5%, PF 2,07, 465 operazioni (tutte long, circa 97/anno), win rate 62,6%, serie perdente massima 5; 15 stress test "tutti A" fatti nel suo motore di ricerca (non MT5), OOS 2,15 vs IS 1,88, 4 su 5 finestre walk-forward positive.
- Rischi: dipende dal tick volume del broker (condizione 3); solo long (2022-2026 e un periodo rialzista); sessione serale con spread piu larghi; 5 lotti fissi su 10.000 = leva alta; soglia volume non dichiarata; mercato e TF unici. Il titolo dice 370%/10% DD, il corpo 376,5%/10,5% (incoerenza minore).

### 7. ZoneUS30 - US30 (mean reversion short con carry) - CodeBase GRATUITO
- URL: https://www.mql5.com/en/code/77748
- Autore: Jose Isaac Almeida Da Silva (isaaccarv100), Brasile. Pubblicato 28/09/2026. Licenza: NON TROVATO (gratuito). Voto "(3)" senza punteggio, 1.551 visualizzazioni, nessun commento.
- Asset/TF: US30; timeframe dall'input "Signal Timeframe" (default non dichiarato). Sessione: NON TROVATO.
- Logica: solo SELL; dopo un forte rialzo cerca correzione/inversione di breve; swing, posizioni anche di diversi giorni; la componente carry presume swap positivo sugli short US30.
- Parametri pubblici: Lot ("intenzionalmente aggressivo", valore non dichiarato), Signal Timeframe (nessun default). Gli altri sono interni e non divulgati.
- Rischi: SL/TP NON TROVATO; solo gli screenshot (Results 2023-2026.png, non leggibile qui) con risultati; contro-trend short su indice in rialzo = rischio di coda; dipendenza dallo swap del broker (su BCM gli short e i long hanno swap diversi, da misurare); parametri nascosti. Da trattare come spunto, da leggere il sorgente (9,45 KB) prima di usarlo.

### 8. Viking Alpha DAX Ivar Edition - DAX M5 (breakout apertura Francoforte)
- URL: https://www.mql5.com/en/market/product/173538
- Autore: Valdeci Carlos Dos Passos Albuquerque (Viking Systems), Brasile. v1.0, 18/05/2026. Licenza: 299,90 USD (affitto 49,90 USD/mese), demo gratuita (61 download demo, 5 attivazioni). Recensioni: nessuna.
- Asset/TF: DE40_Spot (anche GER40/DAX40/Germany40) M5. Sessione: apertura Francoforte circa 09:00, filtri europei, weekend e festivita USA/DE; tempi fissi a GMT+3 di Mosca (attenzione al cambio ora, vedi nota fuso).
- Logica: tre tipi di ingresso: (1) momentum su volumi (prezzo sopra VWAP, volumi forti, breakout candela); (2) momentum filtrato con volumi rilassati; (3) breakout FKT (blocca massimo/minimo di una finestra dopo l'apertura e entra al breakout confermato).
- Parametri (default dalla pagina): N_contratos_inicio 0,01; candle_trigger1 131; N_candles_gatilho_open 5; N_candles_after_open 8; usd_loss_total 150; usd_set_break_c1 120; usd_inicio_trail 160; usd_gain_total 500; usd_limite_perda_diaria 15 (valori in USD per 1 lotto).
- Dichiarato: SL fisso su ogni trade, break-even, trailing ATR; backtest 01-12/2025, tick reali 98%, FXGlobe, deposito 150 USD: +916 USD (+611%), PF 1,88, win rate 62,96%, 216 operazioni, Sharpe 7,71, DD massimo 11,59%. Segnale live FX Blue collegato (non aperto). "No martingale, no grid, no averaging".
- Rischi: backtest di soli 12 mesi; DD 11,59% in un anno; sensibile a spread/slippage su M5 e apertura; deposito test 150 USD non rappresentativo; e breakout (famiglia vicina al nostro oro, ma su asset/orario diversi).

### 9. Global Session Trading - Asian Range Breakout / London Sweep Reversal (simbolo libero)
- URL: https://www.mql5.com/en/market/product/203070
- Autore: Gayakvad Hansaben Sumanbhai. v1.0, 22/10/2026. Licenza: 30 USD, demo gratuita (8 download demo, 20 attivazioni). Recensioni: nessuna.
- Asset/TF: simbolo non specificato; entry TF default M15 (InpEntryTF). Sessioni (ora locale di borsa): Sydney 07-16, Tokyo 09-18, Londra 08-17, New York 08-17.
- Logica: (1) Asian Range Breakout a Londra su range apertura Tokyo-apertura Londra con chiusura candela oltre il range; (2) London Sweep Reversal (fade: sconfinamento e chiusura di rientro nel range, TP al lato opposto); (3) NY Breakout/Sweep sul range di Londra.
- Parametri principali (default esatti dalla pagina): InpStrategy Asian Range Breakout; InpEntryTF M15; InpBreakoutBufferPts 20; InpMinRangePts/InpMaxRangePts 0/0; InpWindowMode Full session; InpTradeWindowHours 4,0; InpNYMode Breakout; InpSweepBufferPts 20; InpSweepTPMode Range opposite; InpLotMode Fixed lot; InpRiskPercent 1,0; InpFixedLot 0,01; InpSLMode Middle of range; InpFixedSLPts 500; InpRR 2,0; InpMaxTradesPerDay 1; InpMaxSpreadPts 0; InpForceCloseAtWindowEnd true; InpMagic 260404; InpConfirmMode Candle close only; InpUseEngulf/InpUsePinBar true/true; InpPinWickRatio 2,0; InpPinOppWickMax 0,30; InpRetestTolPts 50; InpRetestMaxBars 8; InpUseBE true; InpBETriggerRR 1,0; InpUseTrail true; InpTrailStartRR 1,5; InpTrailDistRR 1,0; InpTrailStepPts 10; InpNewsPauseEntries false; InpNewsBlockBefore/After 15/15; InpAvoidUKHolidays/USHolidays true/true; InpServerMode Auto; InpAutoDST true.
- Rischi: nessun backtest/DD dichiarato; prodotto nuovissimo e senza recensioni; calendario notizie non funziona nel tester (il backtest ignora le notizie); la modalita di default e breakout, il fade e la modalita Sweep da selezionare; funziona su qualunque simbolo, quindi i risultati vanno misurati per coppia (EURGBP/AUDNZD/GER40).

### 10. DAX Quant Range MT5 - GER40 M15 (ORB europeo + pullback EMA)
- URL: https://www.mql5.com/en/market/product/162807
- Autore: Manuel De Huerta De La Cruz. v1.1, 23/01/2026. Licenza: 599 USD, demo gratuita (40 download demo, 10 attivazioni). Recensioni: nessuna.
- Asset/TF: DAX/GER40 M15. Sessione europea, ora server (orari esatti NON TROVATO).
- Logica: Opening Range Breakout dell'apertura europea con filtro RSI + EMA Pullback (EMA 20/50, pullback verso la EMA veloce, conferma RSI); modalita attivabili separatamente. SL dinamico (range o ATR), TP ATR; rischio % consigliato 0,5-1%; limiti spread, trade giornalieri, posizioni simultanee, cooldown. "No martingale, no grid, no averaging". Dichiarato adatto a prop firm.
- Parametri: NON TROVATO (solo EMA 20/50 e RSI in generale). DD dichiarato: NON TROVATO.
- Rischi: prezzo alto, nessuna recensione, nessuna statistica pubblica; e breakout/trend (rischio di correlazione con la nostra logica oro, ma asset e orario diversi).

## Con riserva / spunti (non nel conto dei 10)

- Janus (https://www.mql5.com/en/market/product/199501) - autore Alex Amuyunzu Raymond, 450 USD (affitto 220/mese), demo gratuita (16 download). 7 moduli tutti OFF di default: M1 apertura condizionata, M2 DAX overnight drift (GER40), M3 gotobi USDJPY ("folklore"), M4 fade di breakout falliti, M5 apertura Londra UK100/GBPUSD, M6 fade del range asiatico su EURUSD/EURGBP in sessione europea, M7 pullback trend su XAUUSD e US100 (OPERA ORO: va lasciato OFF, ma e nel prodotto). Rischio 0,5% per trade, SL fisso su ogni ordine (distanze NON TROVATO), nessun backtest pubblicato; la pagina stessa descrive le ipotesi con un "kill gate" PF >= 1,25 e >= 300 operazioni. Utile come catalogo di idee (M2, M6) piu che come EA collaudato; per la regola "scarta EA che operano anche oro" e borderline.
- Asian Range Breakout PRO (https://www.mql5.com/en/market/product/181468) - 35 USD, demo gratuita; range asiatico 00:00-07:00 UTC, finestra 07:00-12:00 UTC, SL sul lato opposto del range; solo breakout; nessuna statistica. Sulla famiglia breakout, non mean reversion.
- FxCraft Example EA (https://www.mql5.com/en/code/78687) - gratuito, autore Jan Jablonski; mean reversion Bollinger (20/2,0) con rientro e RSI opzionale (14/30/70), SL 300 punti, lotto 0,10, magic 5020, spread massimo 30 punti, orari 00:00-00:00; ma gira SOLO su demo e tester (si blocca su reale): utile come modello/benchmark, non come EA operativo. Voto 2,5 (2 voti).
- BB RSI Mean Reversion Pro (https://www.mql5.com/en/market/product/172957) - gratuito, MT4 (NON MT5), EURUSD/GBPUSD/USDCHF H4; parametri completi (BB 20/2,0, RSI 8, 70/30, SL 75 pip, TP 150 pip, Donchian 20, lotto 0,04, magic 473829); dichiarato PF 1,72 (EURUSD) e 2,46 (GBPUSD) con DD 21,91% e 10,68%. Piattaforma sbagliata per noi e coppie major.

## Scartati (con motivo)
- Aurum Imperator (https://www.mql5.com/en/blogs/post/769954, prodotto 169989): AUDCAD M15, ma DD equity 44,21% (saldo 34,97%) e nessuno SL fisso dichiarato; cifre incoerenti fra corpo e riassunto.
- Mean Reversion EA From Funded Traders (https://www.mql5.com/en/market/product/124202): AUDCAD H1, PF 2,18, ma NESSUNA descrizione di regole (solo lotto 0,1 come parametro): codice/logica opachi.
- SeasonalEA (https://www.mql5.com/en/market/product/29911): gratuito e a orari fissi (default acquisto mercoledi 12, uscita venerdi 22), ma nessuno stop loss, 2018, solo un "Profit in money" di 199: scartato per assenza di SL.
- Ultimate Mean Reversion (GridSizePips=18) e MAT FX Strategist: griglie. ARG Pro Bot: dichiara grid. Power EURGBP: usa grid. GridPilot: griglia.
- Dax Institutional Flow (https://www.mql5.com/en/market/product/200035): MT4, breakout D1 con chiusura 21:00 ora tedesca; nessun parametro ne DD pubblicato.
- Dax EA (https://www.mql5.com/en/market/product/129289): 23 strategie opache, recensioni miste e un segnale live disattivato.
- Articolo 16700 (Mean Reversion Signal Reaper): solo indicatore con frecce, testato su Volatility 75.

## Nota fuso orario (regola del progetto)
Gli orari delle pagine sono quasi sempre "ora server" del broker dell'autore (spesso GMT+2/+3 con ora legale) o GMT. Il server BCM e GMT+1 fisso: per GER40 Evening Coil (18-21 / chiusura 23 server) e per tutti gli EA con finestre orarie, i parametri vanno riconvertiti all'ora del server BCM e ricontrollati due volte l'anno.

## Non verificato / non accessibile
- Articoli MQL5 (17239 Asian Breakout, 24936, 23575, 24652): HTTP 503. Dell'articolo 17239 e rimasto un riassunto letto in un tentativo successivo (parametri: LotSize 0,1; BreakoutOffsetPips 10; BoxTimeframe M15; MA 50 SMA; RiskToReward 1,3; box 23:00-03:00 GMT; uscita 13:00 GMT), ma e solo un esempio didattico senza risultati numerici leggibili.
- Schede che il fetch ha sostituito col catalogo e quindi NON lette: AI Mean Reversion (166438, AUDCAD/AUDNZD/NZDCAD M15 secondo la ricerca), EW3 (126277/139698, 26 coppie dichiarate nel risultato di ricerca, non confermato), Ger40 Morning Breakout (131037), Dax Box (172683), USA Index Low (166157, S&P H2), Tidewater (NAS100/US500 D1 long, sopra SMA200 giornaliera, autore Abriel Dellosa Rivera; URL non trovato).
- Segnale "German and US Index Opening Range" (https://www.mql5.com/en/signals/2390105): non aperto.
- Forum MQL5 non esplorato; CodeBase esplorata solo tramite ricerca (pochi EA gratuiti pertinenti trovati); numero di download delle voci CodeBase non mostrato.
- Nessun EA trovato su EURCHF, GBPCAD o AUDCAD in Asian-range mean reversion con regole complete e parametri pubblici: la maggior parte dei prodotti non pubblica i parametri.
- Nessun backtest o dato e stato riprodotto da noi; i dati sono dichiarati dagli autori.
