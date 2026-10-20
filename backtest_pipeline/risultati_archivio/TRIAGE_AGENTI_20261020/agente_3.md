# Triage agente 3 - 8 EA del Market (letto il 20/10/2026, solo pagine pubbliche, nessuna misura)

Criteri applicati: MARKET_TRIAGE_AGENTI_CRITERI_2026-10-20.md. Tutti i dati sono dichiarazioni lette sulle pagine (fonte tra parentesi); i dati dei signal sono quelli mostrati dalla pagina del signal.

## Tabella riassuntiva
| EA | Classe | Simbolo | Flag principali | Evidenza |
|---|---|---|---|---|
| Cosmos Orion | B | XAUUSD H2 | SL duro dichiarato, no griglia; pochi trade; nessun backtest; signal citato e' di un altro EA | Nessuna (1 recensione, non verificabile) |
| Kyora MT5 | B | USDJPY H1 | forex (bonus); calendario MT5 (non nel tester); piu' strategie contemporanee; 75 USD | Signal 1 settimana, 7 trade |
| Atherion ("Aetherion") Zenith AI | B | XAUUSD H1 | "AI" senza regole; SL non quantificato; 36 trade con 0 perdite in 32 sett.; prezzo incoerente | Signal 32 sett., DD equity 3,70%, ma 100% vincenti |
| Iron Stops | B | XAUUSD M30 | recensioni critiche (live diverso dal backtest, "wide SLs"); prezzo e signal incoerenti | Signal 1 settimana, DD balance 33% |
| Impulse MT5 | C | XAUUSD | griglia di recupero dichiarata, averaging, no SL per operazione in modo griglia | Signal non del prodotto |
| GoldenShot | B | XAUUSD | SL 200/250 pip vs TP 40/50; recensioni critiche; WebRequest news | Signal 9 settimane (DD balance max 26%) |
| Scalping Index Pro | C | US30, DE40 M1 | "selective grid" dichiarato; piu' posizioni; scalper M1; nessun signal ne' backtest | Nessuna verificabile |
| Pips Kicker | B | Forex + oro | no griglia, 1 trade alla volta; nessun signal linkato; timeframe non dichiarato | Solo backtest di un recensore |

---
## 1) Cosmos Orion - Classe B
- URL: https://www.mql5.com/en/market/product/199231 . Signal proprio: nessuno. Il link in pagina (https://www.mql5.com/en/signals/2388805, "HighestRisk", 7 sett., +39,04%, DD balance 5,25%, DD equity 3,93%, 25 operazioni, PF 2,26, durata media 9 min, XAUUSD) e' dichiarato dalla pagina come signal dell'EA "gift", NON di Cosmos Orion.
- Autore Chen Jia Qi. Versione 2.1, pubblicato 03/10/2026, aggiornato 09/10/2026. Prezzo 299 USD "early-bird, prime 10 copie, 4 rimaste"; affitto: no. 10 attivazioni, 339 demo (pagina).
- Simbolo/TF: XAUUSD, segnali su H2 qualunque sia il grafico (pagina).
- Strategia: strutture a tre pivot su H2, solo barre chiuse; Buy Stop/Sell Stop vicino all'ultimo pivot; senza breakout niente trade (pagina). Breakout.
- SL: SI, SL e TP rigidi su ogni ordine, distanze in % del prezzo dell'oro, valori non dichiarati; break-even, trailing, TP parziale (pagina).
- Lotto: rischio L1-L5 = 1%-5% per ordine, o lotto fisso (pagina).
- Griglia/martingala/averaging: dichiarato NO. Richiede conto hedging (pagina).
- Dipendenze: pausa intorno ai dati USA; fonte del filtro non dichiarata -> [NON VERIFICATO] se funziona nel tester. Set .set: no; configurazioni inviate dopo l'acquisto via messaggio.
- Recensioni: 1 sola, positiva (Robert L: "confident live results will match backtests", PF 3-7 e' sua affermazione). Nessuna critica.
- Backtest del venditore: nessuno. Flag: pochi trade attesi (S-N a rischio), pressione "10 copie", rischio fino al 5% per ordine.
- Motivo B: nessun flag C (SL duro, no griglia), meccanismo plausibile, ma nessuna evidenza esterna (nessun signal proprio, nessun backtest). Oro: nessun bonus.

## 2) Kyora MT5 - Classe B
- URL: https://www.mql5.com/en/market/product/200056 ; signal https://www.mql5.com/en/signals/2396294 ; manuale https://www.mql5.com/en/blogs/post/777968.
- Autore Mauro Augello (Italia, valutazione venditore 4,8 su 37 voti). V1.0, pubblicato 18/10/2026. Prezzo 75 USD, affitto no, 58 demo, 15 attivazioni (pagina).
- Simbolo/TF: solo USDJPY, H1; conto hedging consigliato (pagina).
- Strategia: breakout con due set (Balanced / Ultimate), Buy Stop/Sell Stop a livelli di breakout (pagina).
- SL: SI per ordine (valori non dichiarati), break-even e trailing per strategia. Lotto: fisso o automatico su saldo; i limiti sono per ordine, non sull'esposizione totale (pagina).
- Griglia: "does not use grid averaging or martingale lot progression" (pagina). Ma "Several strategies may hold positions at the same time" (esposizione cumulata).
- Dipendenze: filtro news/NFP con calendario economico MT5, attivo solo con terminale connesso -> non funziona nel tester (pagina). Nessun WebRequest. Set: no. Limiti giornalieri/ciclo disattivi di default.
- Signal: 1 settimana, +1,07%, DD balance 0,08%, DD equity 0%, 7 operazioni tutte in profitto e tutte long, PF 13,69, durata media 11 h, USDJPY.r (signal). Recensioni: nessuna.
- Motivo B: nessun flag C, meccanismo descritto, ma signal di 1 settimana (<20) e nessun backtest. Bonus decorrelazione: SI (forex). Attenzione: 7 trade/settimana, S-N da verificare; durata media 11 h.

## 3) Atherion Zenith AI EA (nome in pagina "Atherion", citato anche come "Aetherion") - Classe B
- URL: https://www.mql5.com/en/market/product/191762 ; signal https://www.mql5.com/en/signals/2381671.
- Autore Valentina Zhuchkova (venditore 3,7 su 69 voti). V1.6, pubblicato 21/08/2026, aggiornato 16/10/2026. Pulsante 459 USD, affitto 199 USD/mese; la descrizione dice "primi 7 esemplari 259, poi 359" (incoerente). La frase "only 1 copy left / last chance" NON compare nel testo letto ([NON VERIFICATO]). 13 attivazioni, 614 demo (pagina).
- Simbolo/TF: XAUUSD H1, VPS consigliato (pagina).
- Strategia: "AI", valuta struttura, volatilita', momentum, sessioni, R/R, "livelli di conferma interni"; nessuna regola di entrata/uscita (pagina). Trailing e dashboard.
- SL: il testo dice che l'EA "puo'" mettere SL/TP, senza distanze -> non dichiarato in modo chiaro. Lotto: livello di rischio scelto dall'utente, formula non dichiarata.
- Griglia/martingala/averaging: nessuna menzione (non dichiarato ne' escluso). Un sito terzo dice "non usa griglia" (non verificato). Dipendenze: nessuna dichiarata. Set: no.
- Signal: 32 settimane, +549,30%, DD balance 0,15%, DD equity 3,70%, 36 operazioni, PF 27,41, win rate 100%, durata media 22 min, XAUUSD.ls, InstaForex, operativita' in 34 giorni su 225, avvisi "poca attivita'" e "crescita alta" (signal). Prezzo del signal 999 USD/mese.
- Recensioni: 3, tutte positive; una avverte "two weeks is still a short period", "only a few trades" (pagina). Commenti (12) non letti.
- Flag: AI senza meccanismo; nessuna perdita in 36 operazioni = coda non vista (possibile SL molto largo o nessuno); ~1 trade/settimana (S-N fallirebbe); durata 22 min -> sensibile ai costi.
- Motivo B: il signal supera le 20 settimane e il DD, ma il meccanismo non e' descritto e l'SL non e' dichiarato (rischio flag C "AI senza meccanismo"; da decidere dal coordinatore). Oro: nessun bonus.

## 4) Iron Stops - Classe B
- URL: https://www.mql5.com/en/market/product/190545 ; signal https://www.mql5.com/en/signals/2395437 (il tooltip del link mostra 2386516, che da' 404).
- Autore Fajar Dicky Firmansyah (venditore 3,9 su 95). V1.18, pubblicato 14/08/2026, aggiornato 28/08/2026. Pulsante 349 USD, la descrizione dice "costa 580, poi 629 dopo 30 licenze, 29 vendute" (incoerente). Affitto no. 20 attivazioni, 2.797 demo. Prodotto 4,01 su 81 recensioni (pagina).
- Simbolo/TF: XAUUSD M30.
- Strategia: "Volume Acceleration", rileva improvvisi cambi di volume prima dei breakout; chiude entro 36 h; nessun'altra regola (pagina).
- SL: non descritto; il lotto automatico dipende dalla "distanza SL", quindi un SL esiste (indiretto). TP non descritto. Stop del trading se la perdita flottante supera una soglia. Lotto: automatico a rischio, manuale o fisso.
- Griglia/martingala/averaging: nessuna menzione. Ma la recensione di Shahid Saghir dice "trades quite randomly with wide SLs to give big room to possibly get TP". Dipendenze: nessuna dichiarata. Set: no (file .ini a richiesta, Telegram dopo l'acquisto).
- Signal: 1 settimana, +29,88%, DD balance 33,41%, DD equity 26,55%, 4 operazioni, PF 1,66, 1 giorno medio, XAUUSD_i, Alpari (signal). "Conto nuovo, troppo pochi trade".
- Recensioni critiche (pagina): "the backtest completly doesnt reflect in live trading" (12061985, 13/09); "Bad. Just bad ... The losses are big" (Kwun Lin Liu, 22/09); "backtests created very different expectations" (Zhanyshbek Muratbekov); recensore che parla di inganno. Alcune positive sono ricevute con un EA regalo (Adam Kostecki).
- Motivo B: nessun flag C dichiarato, ma evidenza debole e contraddetta dalle recensioni; SL largo (da una recensione). Oro: nessun bonus.

## 5) Impulse MT5 - Classe C
- URL: https://www.mql5.com/en/market/product/179349 . Signal dedicato: nessuno (la pagina linka https://www.mql5.com/en/signals/2383163 "Low Risk Signal Vantage AU", non letto: [NON VERIFICATO]).
- Autore Simon Reeves (Starpoint Trading, 4,9 su 30). V2.41, pubblicato 31/05/2026, aggiornato 28/08/2026. 499 USD; affitto 199 USD/1 mese, 299 USD/3 mesi. 10 attivazioni, 1.641 demo (pagina).
- Simbolo: solo XAUUSD, TF "any" con timeframe interni. Sei strategie (momentum-pullback, ranger, double-impulse, confluence fade/trend, conviction).
- Griglia: SI, dichiarata. "Il default e' una recovery grid con un solo paniere"; le aggiunte abbassano il prezzo medio e il TP e' sul prezzo medio ponderato; ricostruzione dello stato dopo il riavvio; lotto piatto (martingala negata). SL: in modo griglia nessun SL per operazione (chiusura virtuale del paniere); solo nel modo "Single Position" c'e' SL (pagina).
- Lotto fisso, automatico a rischio o proporzionale (0,01 per 1.500 USD). Dipendenze: feed news https://nfs.faireconomy.media/ via WebRequest, con ripiego sul calendario MT5 (non funziona nel tester). Set: no, manuale su richiesta.
- Recensioni (20, voto 5): positive; qualificate: "Highly recommended if you can handle xau grids with multiple steps and temporary red positions" (Dani12555).
- Motivo C: griglia/averaging/"recovery grid" dichiarati e nessun SL per operazione nel modo di default. Oro: nessun bonus.

## 6) GoldenShot - Classe B
- URL: https://www.mql5.com/en/market/product/185207 ; signal https://www.mql5.com/en/signals/2387381 ; manuale https://www.mql5.com/en/blogs/post/774929 ; post https://www.mql5.com/en/blogs/post/775431.
- Autore Adam Hrncir (4,6 su 75). V1.46, pubblicato 28/08/2026, aggiornato 15/10/2026. 249 USD (sale a 299 poi 399); affitto no. 10 attivazioni, 2.238 demo. Prodotto 4,31 su 34 recensioni (pagina).
- Simbolo: XAUUSD, TF qualunque (interni: M15/M30). Due strategie: Pullback e Momentum, una posizione alla volta (manuale).
- SL: SI, broker-side su ogni operazione: 200 pip (circa 20 USD a 0,01 lotto) / 250 pip, con TP 40 / 50 pip, trailing, break-even (blog). Rapporto SL:TP circa 5:1 (coda).
- Lotto: rischio 1% (consigliato da circa 2.500 USD) o fisso; "Use Broker Minimum Lot" attivo di default puo' superare il rischio. Griglia/martingala/hedge: dichiarato NO.
- Dipendenze: calendario ForexFactory via WebRequest su https://nfs.faireconomy.media/ (ripiego su calendario MT5): non funzionano nel tester. Set: no.
- Signal "GoldenShot High Risk": 9 settimane, +15,70%, DD balance max 26,03% (relativo 10,95%), DD equity 9,06%, 37 operazioni, PF 1,39, durata media 17 min, win rate 89,18%, XAUUSD+, Vantage; 99 USD/mese; "conto nuovo" (signal).
- Recensioni critiche (pagina): "One losing trade can wipe out a month or more of accumulated profits" (Rizwan Ahmed, 11/10); "Bot che trada poco ma quando perde e' una catastrofe" (Dino Caccia, 24/09); "so one loss eat profits for more than 20 orders" (baderbader); "Only 2 small profit and one BE in 15 days" (Minoru Iida).
- Motivo B: nessun flag C (SL reale, niente griglia) ma signal di 9 settimane (<20) e nessun backtest numerico del venditore. Flag: SL molto piu' largo del TP, poche operazioni, scalper di 17 min (S-COSTO). Oro: nessun bonus.

## 7) Scalping Index Pro (MT5) - Classe C
- URL: https://www.mql5.com/en/market/product/187117 (MT4: https://www.mql5.com/en/market/product/187118). Signal: nessuno linkato; "live results" rimandati a un sito del venditore senza URL. La dicitura "live signal verified" NON e' nella pagina letta ([NON VERIFICATO]).
- Autore MQL TOOLS SL (4,4 su 1.999 voti, 38 prodotti). V1.0, pubblicato 27/08/2026, nessun aggiornamento. 1.099 USD (promo fino al 23/10, poi 1.999); affitto 899 USD/anno. 12 attivazioni, 707 demo. 6 recensioni, voto 5 (pagina; 22.651 caratteri finali letti, nessuna critica).
- Simboli: US30/DJ30 e DE40/DAX/GER40, M1; la FAQ finisce con "any other symbol", in contrasto con "esclusivamente". Nomi dei simboli su BCM: [NON VERIFICATO].
- Strategia: scalping su movimenti brevi e momentum, regole di entrata non divulgate. Griglia: "selective grid based trade management techniques" (pagina). Il venditore risponde che "can open multiple positions".
- SL: "configurable Take Profit, Stop Loss, Trailing Stop, maximum positions" ma nessun valore/default; Max Drawdown e Daily Profit configurabili. Lotto: "you only need to set the lot size", metodo non descritto.
- Dipendenze: filtro news High Impact 60 min prima e dopo, fonte non dichiarata. Set: no ("fully optimized, only lot size"). Backtest del venditore: nessuno (solo istruzioni tester: Every Tick Normal, 2.000-3.000 USD).
- Fonti terze, non verificate: AlgoCheck "structure unverified" (https://algocheck.net/review/scalping-index-pro-mt5); un sito rivenditore riporta -4,9% ROI, DD 32,7%, 2.266 operazioni, win rate 45% (non confermato).
- Recensioni: tutte positive, nessuna critica; risposte del venditore quasi identiche.
- Motivo C: griglia dichiarata e multi-posizione; per lo stesso motivo l'SL per singola operazione non e' garantito. Nessuna evidenza (signal/backtest) -> non sarebbe comunque A. Bonus decorrelazione: SI (indici), ma e' l'unico motivo di interesse; chiedere conferma al coordinatore se vale una demo per capire cosa significhi "selective grid" (la formula e' vaga).

## 8) Pips Kicker - Classe B
- URL: https://www.mql5.com/en/market/product/199547 . Signal: nessuno linkato in pagina. Il signal https://www.mql5.com/en/signals/2394973 (titolo "Pips Kicker EA") risulta "not found in our database" ([NON VERIFICATO]; un indice di ricerca riportava circa 11 trade in una settimana). La dicitura "live signal verified" NON compare in pagina.
- Autore Andrey Barinov (Wahoo, 4,5 su 716 voti, Vagabonding Ltd.). V1.0, pubblicato 10/10/2026. 499 USD "solo 10 copie", offerta "BUY 1 GET 1 FREE" (altri snapshot 249/299: incoerente). Affitto no. 10 attivazioni, 177 demo. 4 recensioni, voto 5 (pagina).
- Simboli: "all Forex pairs and Gold"; timeframe non dichiarato (solo M30 EURUSD nella recensione). Circa 3-5 trade per coppia a settimana.
- Strategia: "trend following mean reversion" su supporti/resistenze, filtri di mercato, solo setup con buon R/R.
- SL: SI, SL/TP predefiniti e invariati da R/R. Niente trailing nell'EA. Lotto: metodo non descritto ("Risk in Money" e' un'utility a parte); limiti di perdita giornaliera e DD totale.
- Griglia: "No Grid, No Martingale", "only one trade can remain active at a time". Dipendenze: filtro news con due fonti di calendario (non specificate, probabile non funzionante nel tester). Set: no.
- Recensione utile: zeke21t2, EURUSD M30 con Pips Kicker + Edge Boost Pro, 12/01-09/10/2026, 1% rischio: 132 trade, win rate 78,03%, PF 2,52, DD equity relativo 4,68%; "live validation is still ahead" (dato del recensore, non verificato). Nessuna recensione critica.
- Motivo B: nessun flag C, ma niente signal proprio ne' backtest del venditore. Bonus decorrelazione: SI se usato su forex (EURUSD e simili); su oro no.

## Note finali
- Nessun EA di questo lotto soddisfa i requisiti A (nessun signal >= 20 settimane con DD < 25% abbinato a meccanismo chiaro e SL dichiarato).
- Dati contraddittori da ricontrollare dal coordinatore: prezzo/scarsita' di Atherion, Iron Stops e Pips Kicker; presenza di "live signal verified" per Scalping Index Pro e Pips Kicker (non trovata).
