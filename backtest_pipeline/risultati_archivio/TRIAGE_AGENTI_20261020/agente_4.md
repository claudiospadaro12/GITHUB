# Triage agente 4 - 20/10/2026 (dichiarazioni da ri-verificare a campione; nessun consiglio di acquisto)

Correzioni di identificazione: le prime ricerche web davano ID sbagliati (126970 = AlgoFlux; 187549 = "Lycan" gratuito di Leo Carlo Bermudez/LeyzFX, prodotto DIVERSO). Gli ID giusti sono stati presi dalla lista Market (https://www.mql5.com/en/market/product/1046 = elenco "Trading Robots MT5").

## Tabella riassuntiva
| EA | Classe | Simbolo | Flag principali | Evidenza |
|---|---|---|---|---|
| Aikon MT5 | C | Forex+Gold (non elencati) | Profilo Recovery (aggiunge posizioni a distanze Fibonacci), AI via WebRequest+API key non testabile nel tester, nessun signal >=20 sett. | Signal Aikon nuovi (dal 2/10/2026, 1 sett.); portafogli legacy "in dismissione", commento "6 su 10 saltati" non verificato |
| Morpheus Algo EA | B | XAUUSD + EURUSD | SL 1700 pt vs TP 450 (coda), numeri incoerenti, prodotto pubblicato 11/10/2026, signal 14 e 18 operazioni | Signal 19 sett. / 31 sett. (date incoerenti con la pubblicazione); backtest PF 35 non credibile |
| Range Breakout EA with Range Filters (649 USD) | B | XAUUSD, USDJPY, BTCUSD, US30, DE40 | SL non dichiarato, correlazione con altri EA dell'autore, PF signal 1,15 | Signal 100 sett., DD balance 25,53% max (28,29% relativo), equity 8,96%; bonus indici |
| Lizard | B | XAUUSD H1 | Filtro news richiede WebRequest (OFF di default), signal del venditore cancellato/404, recensioni critiche forti | Nessun signal verificabile; 4,08/72 recensioni |
| Lycan MT5 | C (limite) | 28 forex H1 | Logica non descritta, nessun signal/backtest, lotto "appreso" (tester a lotto minimo per 2-3 anni), URL time server | Nessuna |
| Quantum King EA | C | AUDCAD M5 | Griglia + martingala adattiva dichiarate, SL non dichiarato, equity DD 29,25% vs balance 5,98% | Signal 61 sett., PF 2,30, 554 op. |
| Quantum Athena (X) | C | XAUUSD | Griglia dichiarata, recensioni "grid" bruciato conto; originale non trovato | Nessun signal linkato |
| MoonDog EA V4 | B | XAUUSD | Scalper (hold medio 1 min: S-COSTO), signal <20 sett., recensioni critiche, slippage | Signal 16 sett., DD balance 20,26%, PF 2,22 |

## Schede

### 1) Aikon MT5
- URL: https://www.mql5.com/en/market/product/191992 ; signal: nessuno per il prodotto (pagina). Blog autore: https://www.mql5.com/en/blogs/post/776217 (signal 2393883/2393885/2393886/2393890 nuovi; legacy 2328342, 2334563, 2334570, 2311648, 2311651, 2296729, 2373643, 2373642, 2311649, 2327176).
- Autore William Brandon Autry (USA, 4 prodotti, 14 signal); v9.0, aggiornato 19/10/2026 (pubblicato 5/9/2026) (pagina).
- Prezzo 1.097,97 USD (resta 1 acquisto, poi 1.197,97; prezzo finale dichiarato 4.997); affitto non listato; demo gratuita (pagina).
- Simboli: profili Forex e Gold, "AIKON CHOOSES" per scelta AI; timeframe non dichiarato (pagina).
- Strategia: analisi + apertura/gestione automatica; "Ask Aikon" interfaccia conversazionale (anche via Telegram); regole permanenti "Trading Constitution"; architettura Master/Node (pagina).
- Signal: il prodotto non ha signal linkato; quello "Quick Start Recovery" 2393883 ha 1 settimana, 14 op., PF 4,06, DD balance 0,28%/equity 1,24%, AUDCAD/NZDCAD/NZDUSD/GBPUSD (https://www.mql5.com/en/signals/2393883) = troppo corto. Blog: portafogli legacy depositi 4.898,89, floating -458,26, "alcuni potrebbero essere liquidati"; commento di un utente "6 su 10 blown" [NON VERIFICATO].
- SL: Single Entry con SL/TP (AI o regole); Recovery opzionale. Lotto: non specificato (pagina).
- Recovery: SI, dichiarato ("Forex Recovery (optional)"; modalita' Veyra aggiunge posizioni a distanze Fibonacci, max 5 per simbolo; Echelon chiude coppie vincente+perdente) (pagina+blog). Griglia/martingala/averaging: non nominati, ma l'aggiunta di posizioni e' averaging di fatto.
- Dipendenze: WebRequest + API key di un provider AI (costi separati) e Telegram; "il tester non esegue queste WebRequest" (pagina). DLL no. Set: nessuno (profili interni).
- Recensioni critiche: nessuna sulla pagina (11, 5 stelle). 
- FLAG: recovery, AI non testabile nel tester, signal troppo giovani, prezzo molto alto.
- CLASSE C: recovery dichiarato nel prodotto e meccanismo AI non verificabile nel tester; nessun signal >=20 sett. Nota: la sola modalita' Single Entry con SL sarebbe al massimo B.
- Bonus decorrelazione: forex/gold a scelta, non assegnabile.

### 2) Morpheus Algo EA MT5
- URL: https://www.mql5.com/en/market/product/200661 ; signal XAUUSD https://www.mql5.com/en/signals/2395128 ; EURUSD (MT4) https://www.mql5.com/en/signals/2395153.
- Autore Maxim Kurochkin (stesso di TitanForge, gia' misurato); v1.0, pubblicato 11/10/2026, nessun aggiornamento (pagina).
- Prezzo 399,99 (testo: lancio 299/standard 399, incoerente); affitto 199,99/mese, 299,99/anno (pagina).
- XAUUSD e EURUSD; timeframe non dichiarato (grafico H1 d'esempio). Strategia: motore interno con range scanner, BSL/SSL, EQ, BOS; la logica di ingresso non e' spiegata (pagina).
- SL: SI. XAUUSD SL 1.700 pt / TP 450 pt, trailing da +115 (step 35); EURUSD SL 600 / TP 150, trailing +30 (step 5) = SL ~3,8-4x il TP (coda). Lotto: automatico o fisso, rischio 0-5 (profili, non %). Griglia/martingala/recovery: non menzionati.
- Dipendenze: filtro news e limiti DD prop OFF nel preset; nessuna WebRequest/DLL dichiarata. Set scaricabili: NO (solo "preset fornito").
- Signal XAUUSD: 19 sett., +479,19%, DD balance 0,30% (77 USD), equity 0,99%, 14 operazioni tutte vincenti, PF 28,8, hold medio 28 min, InstaForex, 1:200. Signal EURUSD: 31 sett. (inizio dichiarato 11/10/2026: incoerente), +113%, DD balance 0%, equity 16,54%, 18 op. tutte vincenti, hold 10 h. Entrambi con avviso "numero operazioni troppo piccolo" (pagine signal). Backtest dichiarato 2020-2026: 1.750 op., PF 35,65, DD 10,45% / profilo 4 DD 37,95% e 59,12% (pagina): non credibile senza verifica.
- Recensioni: 5 su 5 positive; nessuna critica (pagina).
- FLAG: coda SL>>TP, dati incoerenti (settimane vs data pubblicazione), campione minuscolo, 100% vincenti, prodotto nuovissimo, nessun .set.
- CLASSE B: nessun flag C, ma signal <20 sett. effettive e con 14/18 op.; meccanismo non descritto.
- Bonus: EURUSD = forex (si'), XAUUSD no.

### 3) Range Breakout EA with Range Filters (il 649 USD)
- Identificazione: unico prodotto a 649 USD con questo nome nella lista Market; coincide con "Range Breakout EA with Range Filters". Non so se Claudio lo abbia gia' misurato [NON VERIFICATO]; il coordinatore confermi. Non e' "Range Breakout Pulse" (176606) ne' "Range Escape".
- URL: https://www.mql5.com/en/market/product/122237 ; signal live https://www.mql5.com/en/signals/2271995 ; portafoglio https://www.mql5.com/en/signals/2340542 ; guida backtest https://www.mql5.com/en/blogs/post/771906.
- Autore Jimmy Peter Eriksson; v5.20, aggiornato 23/8/2026 (pubblicato 25/8/2024); 649 USD (prossimo 749, finale 999); affitto non dichiarato (pagina).
- Simboli XAUUSD, USDJPY, BTCUSD, US30, DE40; timeframe "non conta". Strategia: range nella sessione asiatica, breakout all'apertura di Londra, chiusura nel giorno; senza indicatori, filtro anti-breakout debole (pagina).
- SL: non dichiarato. Lotto: rischio auto Low/Med/High, % manuale o fisso. Protezione DD giornaliero, randomizzatore, filtro spread. Griglia/martingala: "No Martingale / No Grid" (pagina); averaging/recovery/hedge non menzionati.
- Dipendenze: non dichiarate. Set: non richiesti (impostazioni interne per mercato).
- Signal 2271995: 100 sett., +331,55%, DD balance max 25,53% (relativo 28,29%), equity 8,96%, 2.053 op., PF 1,15, win 41,35%, hold 7 h, USDJPY 588 / US30 403 / DE40 385 / BTCUSD 369 / XAUUSD 308, ICMarkets (pagina signal). Serie perdenti fino a 17.
- Signal 2340542 (portafoglio): 84 sett., +555,65%, DD balance relativo 74,90%, equity 7,40%, 6.512 op., PF 1,16, 8 simboli, 25 perdite consecutive (pagina signal).
- Recensioni critiche: Julien Metz (21/3/2026) "After having tested the system for a month I was on a loss of 3 percent... ate the profit of my other experts... bought reviews"; bi mo (2/5/2026) "some pairs struggle more than others... high correlation with other EAs from the author".
- FLAG: SL non dichiarato (da verificare nel tester), PF basso 1,15 (sensibile ai costi, S-COSTO), DD balance 25,5-28% sopra il 25%, portafoglio DD 74,9%, correlazione con altri EA dell'autore, prezzo.
- CLASSE B: nessun flag C dichiarato; signal 100 sett. ma DD balance dichiarato >25%, quindi non A.
- Bonus decorrelazione: SI (indici US30/DE40, USDJPY; breakout di sessione, ma c'e' oro).

### 4) Lizard (Lucertola)
- URL: https://www.mql5.com/en/market/product/172541 ; signal citato dal venditore https://www.mql5.com/de/signals/2372821 -> 404 (anche /en/): [NON VERIFICATO: non letto]. Esiste "Lizard Mini" gratuito: https://www.mql5.com/en/market/product/189287 (lotto 0,01 fisso, filtri bloccati; da risultati di ricerca).
- Autore Marco Scherer; v2.1, aggiornato 4/10/2026 (pubblicato 9/5/2026); 99 USD; affitto no; demo gratuita (pagina).
- XAUUSD H1. Swing breakout: buy/sell stop da swing high/low H1; 6 strategie con SL, TP, trailing e magic propri; zone attive in base al saldo (pagina).
- SL: SI su ogni posizione (+ SL virtuale software, break-even, trailing). Lotto: rischio configurabile, limite perdita giornaliera per prop; dettagli non dichiarati. Griglia/martingala/averaging: esclusi ("No martingale, no grid, no averaging into losses").
- Dipendenze: filtro news NFP; secondo un recensore e' OFF finche' non si aggiunge l'URL WebRequest (non funziona nel tester). Set: nessuno (preset interni).
- Recensioni (4,08 su 72): Rico9900 "no profit at all for whole 2 months"; Nhut Anh Phan "I lost 30% of my account in just one day, the admin deleted the group"; Nguyen Thanh "the seller's live signal... has now been deleted"; Jung Hoon "multiple users lost 25%+ ... under DEFAULT settings during CPI news"; Ryan Woodward "now there's an update with edited backtest results". Lo sviluppatore contesta.
- FLAG: nessun signal verificabile, accuse di backtest modificato, news filter non testabile, perdite su CPI.
- CLASSE B: nessun flag C dichiarato; evidenza esterna assente.
- Bonus: no (oro).

### 5) Lycan MT5
- URL: https://www.mql5.com/en/market/product/196538 ; signal: nessuno. (Non confondere con "Lycan" gratuito https://www.mql5.com/en/market/product/187549.)
- Autore Rob Josephus Maria Janssen (4,5/53); v1.3, aggiornato 18/10/2026 (pubblicato 12/10/2026); 99 USD; affitto no; demo (231 download) (pagina).
- 28 coppie forex maggiori/minori, H1. "Fratello maggiore" di Chiroptera (notturno M5). Singole operazioni con SL e TP; la pagina non descrive la logica di ingresso (nessun indicatore/pattern) (pagina).
- SL: SI (distanze non indicate). Lotto: ottimale "incorporato" e aggiornato con apprendimento interno in live; nel tester lotti minimi finche' l'apprendimento non converge, "2-3 anni". Griglia/martingala: non menzionati, solo singole operazioni.
- Dipendenze: URL time server https://mql.chiroptera.io da autorizzare in live (non chiaro se serve nel tester); backtest consigliato con OHLC 1 minuto. Set: no.
- Recensioni: 5 stelle (3), nessuna critica (pagina). Nessun backtest/numero in pagina.
- FLAG: logica non dichiarata, lotto che cambia con l'apprendimento (tester non rappresentativo per S-*), dipendenza da server esterno, nessun signal.
- CLASSE C (al limite): applicata alla lettera "nessuna informazione sulla logica E nessun signal E nessun backtest". Il coordinatore puo' rileggere la pagina; se la logica fosse altrove passerebbe a B.
- Bonus: SI (forex, 28 coppie).

### 6) Quantum King EA
- URL: https://www.mql5.com/en/market/product/152162 ; signal https://www.mql5.com/en/signals/2333407 (il tooltip riporta 2234595, che risulta cancellato/non trovato).
- Autore Bogdan Ion Puscasu; v3.1, aggiornato 9/2/2026 (pubblicato 14/10/2025); 599,99 USD ("lancio"); affitto no; demo (pagina).
- AUDCAD M5. "Griglia + martingala adattiva" con logica di recovery adattiva; lotto: livelli di rischio (Extreme/High). SL non menzionato. Set: manuale via messaggio privato dopo l'acquisto. Dipendenze non dichiarate.
- Signal 2333407: 61 sett., +391,71%, DD balance 18,58% max, equity 29,25% relativo, 554 op., win 74,18%, PF 2,30, hold 1 giorno, 541 AUDCAD (pagina signal). Equity DD >> balance DD relativo (5,98%) = impronta di griglia. Il "15+ mesi" del prompt non e' sulla pagina (61 sett. circa 14 mesi).
- Recensioni: Ibrahim S (7/10/2026) "All the quantum EAs are a huge scam"; Phuoc Hung Van "Set it up on extreme high risk... 17% max drawdown over 8 weeks"; Radek Manasek "I accepted the risk of a used grid and possibility of blowing my account". 4,94 su 271.
- FLAG: griglia, martingala, recovery, no SL dichiarato, equity DD alto.
- CLASSE C: griglia e martingala dichiarate; SL non dichiarato.
- Bonus: forex (AUDCAD), ma irrilevante per C.

### 7) Quantum Athena (X)
- URL: https://www.mql5.com/en/market/product/186917 (Quantum Athena X). Il "Quantum Athena" originale non e' nella lista Market ne' linkato: [NON VERIFICATO: non trovato]. Signal: nessun URL (solo canale pubblico).
- Autore Bogdan Ion Puscasu; v2.3, aggiornato 31/7/2026 (pubblicato 23/7/2026); 599,99 USD (+50 ogni 10 acquisti fino a 1.999); affitto no (pagina).
- XAUUSD; timeframe non dichiarato. Sei strategie su motore comune "stessa dell'originale"; "sistema a griglia trend-following" (pagina). SL non descritto in pagina; "DD Control mode" nel manuale. Lotto: livello di rischio. Hedging account, min 500 USD, VPS obbligatoria, oro 2 decimali. Set: nessuno, manuale su richiesta.
- Recensioni (4,09 su 24): arturs nefjodovs "it blew my acc today"; NN "one bad trading situation last week almost wiped out my entire account due to its grid system"; Lim Jaewon "It was all gone just a week after I bought it"; Phu Thien Le "expensive, difficult to use, and capable of blowing your account".
- FLAG: griglia, SL non dichiarato, recensioni di conto bruciato.
- CLASSE C: griglia dichiarata; nessun signal verificabile.
- Bonus: no (oro).

### 8) MoonDog EA V4
- URL: https://www.mql5.com/en/market/product/183924 ; signal https://www.mql5.com/en/signals/2381309 ; secondo (beta AI) https://www.mql5.com/en/signals/2386840 ; guida .set https://www.mql5.com/en/blogs/post/774178.
- Autore James Vito Armin Bianchini (Svizzera); v4.21, aggiornato 4/10/2026 (pubblicato 2/7/2026); 299 USD, affitto 199 USD/mese; demo gratuita (pagina).
- XAUUSD; timeframe non dichiarato. Breakout multi-strategia (9 strategie, 5 di default), 3 modalita' ONNX locale, MoonLock (protegge 50% del picco). SL iniziale 20 pip oro, TP 140-150 pip. Lotto: fisso 0,01 nei .set, o % rischio; senza .set tester a 2% rischio. Dichiara NO martingala/recovery/averaging. Protezione news NFP/CPI/FOMC attiva di default (fonte non dichiarata).
- Set: SI, 4 file .set scaricabili dal blog guida (SET_1_DEFAULT ... SET_4_ALL_9_ADAPTIVE_MOONLOCK) (blog).
- Signal 2381309: 16 sett., +412%, DD balance 20,26% max, equity 2,36%, 257 op., win 68,87%, PF 2,22, hold medio 1 minuto, XAUUSD, GlobalPrime 1:500, conto minuscolo (avvisi slippage negativo e "troppe operazioni"). Signal 2386840: 14 sett., +169%, DD balance 12,32%, 190 op., PF 2,13. Backtest tick reali citati nel blog (1.606 op.): non letti direttamente [NON VERIFICATO]; il post 774563 contiene solo risultati live.
- Recensioni (4,39 su 44): JadeBernard Diamante "Only losing money since I started using this"; 9889882026 "It is worst EA I ever used... 1 profit, many losses!"; Mrnew231083 2 stelle "slightly negative"; Alexander Seidel (DE) demo buone, live "SEHR gemischt", "all breakout EAs perform similarly".
- FLAG: scalper (hold 1 min: S-COSTO, slippage), signal <20 sett., recensioni critiche, filtro news senza fonte chiara.
- CLASSE B: nessun flag C; signal 16 sett. (<20), backtest non verificato.
- Bonus: no (oro).
