# Agente 2 - Forum e file .set (ricerca web 27/11/2026)

**Verdetto sintetico:** nessun candidato "pronto" per la flotta prop. Fonte forum poco accessibile; i risultati sono quasi tutti dichiarati dal venditore/autore, nessuno verificato da terzi. Gli unici dati con parametri ESATTI pubblici sono First Five Breakout (US100), Spring Break (3 valori) e le regole RSI2 dell'articolo MQL5. Nessun file scaricato o eseguito.

## Accesso alle fonti (cosa NON ho potuto verificare)
- ForexFactory: 403 su ogni thread (apparsi solo nei risultati di ricerca: Waka Waka EA, AUDNZD system 254519, Simple Mean Reversion 743125, Alphabet EA post 15180238). **Contenuti non letti.**
- Non raggiungibili dalla rete della sessione (DNS): reddit (bloccato dal motore), EarnForex, Myfxbook, BabyPips, ProRealCode, QuantifiedStrategies, Unger Academy, pineify. Trade2Win/Elite Trader/FXBlue: nessun risultato utile.
- MQL5: raggiungibile, con 503 temporanei. Pagine segnale 2390105 (German and US Index Opening Range) e Viking Alpha non lette. Nessun tracciamento Myfxbook/FXBlue indipendente aperto.
- Lo ZIP dei set di Samson non e' stato scaricato (regola di sicurezza): contenuto dei .set NON verificato.

## Candidati (ordine di utilita)

### 1. First Five Breakout - Nasdaq 100 (US100), M1, apertura USA
- URL: https://www.mql5.com/en/blogs/post/781810 (prodotto: https://www.mql5.com/en/market/product/208706, 99 USD, demo gratuita)
- Logica: range dei primi 5 min dopo le 09:30 NY, buy stop/sell stop OCO, stop sul lato opposto del range, nessun TP, chiusura 15:45 NY, max 1 trade/giorno, ordini cancellati dopo 180 min. Non e' trend-oro; e' ORB indice (famiglia gia' chiusa da noi per l'ORB di Emiliano: non nuova).
- Parametri ESATTI (dal post): Risk_Percent 0,3; Max_Min_Lot_Risk 2,0; Max_Lots 10; Max_Spread_Pct 50; Market_Session Auto; Range_Minutes 5; Stop_Range_Mult 1,0; Take_Profit_R 0; Entry_Window_Min 180; Exit_Before_Close 15; Tester_GMT_Offset 2; Tester_DST US. Set allegati al post: `FirstFiveBreakout_US100_default_0_3.set`, `..._conservative_0_15.set` (solo rischio diverso). Link diretto al file: NON TROVATO (allegati in fondo al post).
- Storico: backtest dichiarato, dati Admirals, 10.000 USD, 0,3% rischio: 2018-2026 M1 OHLC +14.126, PF 1,18, 2.279 trade, DD equity 12,2% (8 anni su 9 positivi, 2020 negativo); tick reali 2025-26 PF 1,06, 478 trade, DD 10,1%. Nessun conto live/Signals.
- Allarmi: l'autore stesso dice che a tick reali l'edge e' debole e che S&P/Dow/DAX sono a pareggio dopo i costi; prodotto nuovo (15/11/2026), nessuna recensione; un solo broker.

### 2. Opening Range Breakout EA V2 (Lee Samson) - DAX / Nasdaq / Dow, M5
- URL: https://www.mql5.com/en/blogs/post/751385 (risultati: https://www.mql5.com/en/blogs/post/751238; strategia: post 751229, manuale 751352)
- Set files gratuiti (ZIP, non scaricato): https://c.mql5.com/6/914/ORB_EA_Set_Files.zip. L'EA e' a pagamento (MT4 product 90502, MT5 91232).
- Logica: breakout trend dell'apertura (DAX 10:00 broker, breakout 10:05/10/15, ordini chiusi 11:30; NAS/DOW 16:30, breakout 16:35/40/45, chiusura 18:00). Tasso di vincita dichiarato 20-30%.
- Parametri: i valori dentro i .set NON verificati; dal post solo orari e rischio per set (es. DAX-6 "15 Min Pre" 09:45/10:00-10:05, 500 USD; NAS-2 "5 and 15 Tight" 1.000 USD).
- Storico: solo Return on Drawdown (DAX 2,50-4,21; NAS 2,64-5,11) su 1 anno (04/2021-04/2022), tick Dukascopy, spread fisso 2 pip, MT4. Nessun PF, DD assoluto, numero di trade. Un commentatore cita 732 trade e DD 9,01% per NAS-5, ma l'autore dice 6 mesi di test.
- Allarmi: periodo unico di 12 mesi (2021-22), nessun fuori campione, nessun live, ottimizzato (dice che 80-90% dei valori sono profittevoli, non provato), orari broker da riconvertire (regola GMT+1 BCM del progetto), possibili errori "zero divide".

### 3. Spring Break - NAS100, M1
- URL: https://www.mql5.com/en/blogs/post/778138 (autore Darren Mark Scott, 20/10/2026)
- Set: `SpringBreak_NAS100_10k.set` (15 KB) allegato al post; link diretto NON TROVATO. Valori dichiarati diversi dal default: BarLotSize e BeachLotSize 0,1 (default 0,01), MaxStopRiskPercent 0 (default 5), BrokerToNYOffset -7 (probabilmente sbagliato per BCM).
- Logica: "lavora sugli orari di sessione"; NON descritta. Non valutabile.
- Storico dichiarato: BlackBull, 01/09/2025-21/09/2026, 10.000 USD, PF 1,90, 246 trade; 0,8 lotti = +11.062, DD balance 715; 0,1 lotti = +1.383, DD 89. Solo 12 mesi, una sola prova.
- Allarmi: logica ignota, 12 mesi, tetto di rischio sullo stop disattivato nel file, lotti pubblicati != lotti del file.

### 4. Band Reversion EA - AUDNZD H1 (mean reversion, a pagamento)
- URL: https://www.mql5.com/en/market/product/196587 (59 USD, demo gratuita, v1.0 del 17/09/2026, venditore Marc Eric Litzler)
- Logica: rientro nella banda di Bollinger + conferma RSI + filtro di regime (pendenza MA lunga/ADX), uscita sulla banda centrale, stop a tempo; richiede conto hedging.
- Parametri/.set: NON TROVATO (nessun valore, nessun set). Stop loss fisico: NON descritto (solo "minimum stop distance" e stop a tempo) = da scartare finche' non confermato.
- Storico dichiarato (tick reali 100%, 01/2016-06/2026, 10.000 USD): +881 USD, PF 1,34, DD balance 2,59%, 268 trade, 61,6% vincenti; media vincita 21 / perdita 25. Nessun conto/Signal; nessuna recensione.
- Allarmi: rendimento minuscolo (circa 0,9% annuo), 268 trade in 10 anni, nessuna prova indipendente.

### 5. Apex Origin - AUDCAD / NZDCAD / AUDNZD / EURGBP, H1 (mean reversion)
- URL: https://www.mql5.com/en/market/product/166552 (autore Yi Hsiu Tsai, v1.51 del 14/09/2026, prezzo indicato GRATIS, 4,91 su 39 recensioni)
- Logica: "Enhanced Mean Reversion", scaling lineare, "NO Martingale", limiti di posizione per simbolo; un recensore dice 1 posizione per simbolo, no griglia. Griglia/averaging NON escluso dall'autore; stop loss NON documentato (un recensore chiede di aggiungerlo) = **allarme forte per i nostri criteri**.
- .set: NON pubblici, "scrivere all'autore per manuale e .set". Parametri: NON TROVATO.
- Storico: nessun numero. Dichiarati IS 2010-2020, OOS 2020-2026. Recensori (non verificati): circa 5% annuo su 2,5 anni, EA poco attivo. Signal live nel profilo venditore (https://www.mql5.com/en/users/sagen520/seller), non letto.
- Allarmi: SL, griglia e parametri non verificabili.

### 6. Scalp IC Markets MT5 (segnale) - cross forex, notte
- URL: https://www.mql5.com/en/signals/1560883 (Roman Kartezhnikov)
- Dati letti: 260 settimane (dal 08/06/2022), crescita 736%, DD balance 10,43%, DD relativo equity 32,86%, 2.697 trade, vincenti 72,11%, PF 1,51, ICMarkets-MT5 1:500, 19 simboli (tra cui AUDNZD, EURGBP, EURCHF, AUDCAD, GBPCAD e **XAUUSD**). Dichiarato: scalping notturno ECN, no martingale, SL/TP fisso per ordine.
- .set: NON TROVATO (EA non pubblico).
- Allarmi: **e' scalping notturno** (escluso dal mandato), include oro, conto reale non confermato dalla pagina, avvisi di inattivita' ricorrenti, recensioni che citano slippage e discrepanze, "virtual stop loss" vicino al rollover.

### 7. Argus (GitHub, MIT) - 20 strategie MT5 incluse Asian Range Fakeout e Bollinger Mean Reversion
- URL: https://github.com/logiccrafterdz/Argus (cartella `Asian_Range_Fakeout/AsianRangeFakeoutEA.mq5`)
- Codice sorgente aperto, nessun .set trovato, nessuna regola scritta nel README, strumenti NON dichiarati.
- Backtest dichiarato (portafoglio, 10 strumenti non nominati, 8,3 anni): PF 1,18, DD -35,99%, 3.742 trade; test 2024-05/2026 PF 1,31; validazione 2023 PF 1,03. Circuit breaker, chiusura al venerdi', filtro news.
- Allarmi: DD 36% incompatibile con prop, 21 stelle, repo recente, nessuna verifica terza. Utile solo come codice da leggere (non eseguito).

### 8. Connors RSI2 su US500 M30 (articolo MQL5 con codice) - mean reversion indice
- URL: https://www.mql5.com/en/articles/17636
- Regole ESATTE: V1 acquisto RSI2 < 5 e chiusura > MM200, uscita chiusura > MM5 o < MM200, SL 0,15%; V2 3 valori RSI2 < 10, uscita sopra il massimo precedente; V3 RSI2 < 5 e > MM50, uscita RSI2 > 70, SL 1%. Test 01/01/2024-01/03/2025, 0,1 lotti. Nessun PF/DD nel testo (solo schermate).
- Allarmi: 14 mesi, autore ammette code che opera anche short; noi abbiamo gia' misurato RSI2 Nasdaq/S&P (PF 1,17-1,18 con M1 reali, chiuso il 21/11). Nessun set: parametri sono i default dell'articolo.

## Fonti lette ma scartate o solo di contesto
- Night Session Automated Trader (AUDNZD M15, 59 USD): https://www.mql5.com/en/market/product/185680 - nessun valore, nessun backtest, orari non indicati.
- OrdinalEdge Mean Reversion Asian Session (USDJPY M15, 39 USD): https://www.mql5.com/en/market/product/175154 - PF 2,26 su 139 trade 2023-26, DD 2,02%, ma strategia opaca, SL non specificato, set a pagamento.
- Gold London Range Breakout: https://www.mql5.com/en/blogs/post/777540 - **oro, scartato** (regole e PF 1,37-1,38, DD 17-19%, 715 trade; utile solo come metodo).
- Articolo ML EURGBP H1: https://www.mql5.com/en/articles/16457 - modelli ONNX, nessun numero, selezione su R2: non riproducibile.
- Articolo swing indici e swap: https://www.mql5.com/en/articles/23469 - NAS100/US30/US500/DE40 2020-26, 424 giri, lo swap consuma il 44,2% dell'utile lordo (DE40: oltre il 100%). Conferma la nostra nota swap BCM.
- Grid Bollinger Bands EA (blog 782046): griglia, scartato. Waka Waka EA (ForexFactory): griglia, scartato.
- MQL5 Low-Frequency Part 3/4 (22783, 23226): azioni singole, nessuno stop loss nel codice (Part 3), nessun PF testuale.

## Per il portafoglio
- Nessun candidato nuovo scorrelato dall'oro con dati verificabili. Nelle famiglie gia' chiuse da noi (ORB, RSI2, breakout indici) ricadono i punti 1-3 e 8.
- Unica strada nuova di interesse sui cross: mean reversion AUDNZD/AUDCAD H1 (punti 4-5), ma con dati forti solo dichiarati, rendimento molto basso, SL e set non verificabili.
- Se Claudio vuole procedere: replicare noi il motore (Bollinger + RSI + filtro regime) con criteri scritti prima, senza prendere il codice di terzi.
- Per leggere i thread ForexFactory servono accesso browser dal PC di Claudio (403 dal cloud).
