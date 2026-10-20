# Triage agente 2 - 20/10/2026 (lotto: SixtyNine, SGI, Mavrik, Tokyo, Gamma Nova, SomaGold, ThunderGold, Fornax)

Tutte le pagine lette con WebFetch il 20/10/2026. Le cifre sono dichiarazioni delle pagine/signal, non misure. Nessun consiglio di acquisto.

## Tabella riassuntiva

| EA | Classe | Simbolo | Flag principali | Evidenza |
|---|---|---|---|---|
| SixtyNine EA | A | XAUUSD H1/H4 | recensione critica "large losses vs tiny wins"; signal con prelievi; no bonus decorr. | signal 35 sett., DD bal. max 12,02% / eq. 10,34%, PF 1,84, 531 op. |
| Smart Gold Impulse | B | XAUUSD (dal signal) | scalper, coda (perdita media 7x il guadagno), PF 1,05, broker-sensitive, recensioni critiche, descrizione quasi assente | signal 12 sett. (<20) |
| Mavrik Scalper | A (riserva su "meccanismo") | XAUUSD M5 | scalper, coda estrema (vincita media 1,16 USD vs perdita 24,99), SL "molto largo", rete neurale opaca, 4 posizioni | signal 29 sett., DD bal. 17,22% / eq. 8,58%, PF 2,74, 1.023 op. |
| Gamma Nova EA | [NON VERIFICATO] (candidato Nova Range EA: B) | XAUUSD M5 (candidato) | nome non trovato; candidato per posizione/prezzo | candidato: signal 19 sett. (<20), DD bal. 3,08% |
| Tokyo EA mt5 | C | "qualsiasi", consigliato XAUUSD M15 | griglia/martingala dichiarata, DD-reduction (recovery), dipende dall'indicatore Tokyo (50 USD) | nessun signal EA |
| SomaGold | A | XAUUSD (D1-H4) | prezzo 600 (listino/lancio incoerenti), 23 perdite consecutive nel signal, recensione "unstable", WebRequest opzionale | signal 22 sett., DD bal. 17,62% / eq. 14,29%, PF 1,63, 296 op. |
| ThunderGold Scalper | B | XAUUSD M15 | scalper, SL "molto vicino", broker-sensitive, recensioni molto critiche (3,69), signal linkato non esiste piu' | nessun signal verificabile |
| Fornax Gold | C | XAUUSD M5 | "controlled recovery algorithm" (basket, max 3 pos./lato), WebRequest calendario | signal 0 sett., 1 operazione |

## Schede

### 1) SixtyNine EA - CLASSE A
- Pagina: https://www.mql5.com/en/market/product/180784 (letta); signal: https://www.mql5.com/en/signals/2361673
- Autore Farzad Saadatinia (Turchia), voto venditore 3,8 (31). v1.30, pubblicato 11/06/2026, aggiornato 02/08/2026 (pagina). Prezzo 399 USD (next 699, final 999); affitto no; demo gratuita. 10 attivazioni.
- XAUUSD, H1 o H4 (pagina). Sei "strati" di strategia, setup strutturati, niente posizioni opposte in contemporanea, trade da minuti a ore (pagina). Descrizione dei 6 strati: non dettagliata.
- Signal (pagina signal): 35 settimane, crescita 1.388% (deposito iniziale 500, prelievi 2.316,90 USD, quindi la % e' gonfiata dai prelievi/lotto fisso 0,02), DD balance max 12,02%, DD relativo balance 23,29%, DD equity relativo 10,34%, 531 operazioni, PF 1,84, tenuta media 17 min, win 60,26%, media +14,41/-11,87, 9 perdite consecutive, peggiore -51,56. Warning storici "Too much growth in the last month" (rimossi). DD equity < DD balance: nessuna firma di accumulo contro prezzo.
- SL su ogni operazione: SI (pagina). Lotto: fisso nel signal (0,02); anche Auto Lot e "Risk of Previous Trade" in backtest (nome modalita' da verificare: potrebbe essere dipendente dall'esito precedente, [NON VERIFICATO]). Griglia/martingala/recovery/hedge: dichiarato NO (pagina). Dipendenze tester: nessuna dichiarata. Preset .set: su richiesta via messaggio, non scaricabili.
- Recensioni critiche (pagina): bc01 28/07/2026 "so far large losses comparing to tiny wins, not sure can work long term"; 30/07 "huge losses today. I am turning this EA off, not recommended at all". Le altre 6 positive.
- FLAG: modalita' "Risk of Previous Trade" da chiarire; solo oro.
- Motivo: nessun flag C e signal >20 sett. con DD < 25%; meccanismo descritto solo in modo generico ma plausibile. Decorrelazione: no (oro).

### 2) Smart Gold Impulse (SGI) - CLASSE B
- Pagina: https://www.mql5.com/en/market/product/183038; signal: https://www.mql5.com/en/signals/2390103 ("Smart Gold Impulse New Set file v2"). (Attenzione: "Gold Impulse Engine" 188771 e' un altro prodotto, non SGI.)
- Autore Barbaros Bulent Kortarla (voto 4,3 su 217; 5 prodotti), stesso autore di Smart Gold Hunter (blog https://www.mql5.com/en/blogs/post/772797): possibile correlazione con un EA gia' misurato. v3.1, pubblicato 04/07/2026, aggiornato 13/10/2026. 199 USD, affitto 99 USD/mese; demo gratuita. Rating 4,08 (27).
- Simbolo/TF: non dichiarati in pagina (descrizione collassata); il signal e' XAUUSD. Strategia: impulso/momentum con ordini pendenti (blog); "No Grid / No Martingale / No DCA / No recovery" (pagina).
- Signal: 12 settimane, +16,84%, DD balance max 21,59%, equity relativo 8,81%, 458 op., PF 1,05, tenuta 11 min, win 88,2%, media +1,68/-11,97, peggiore -14,86, deposito 200. Warning: "80% of growth achieved within 2 days" e "Too frequent deals".
- SL: SI (recensioni/pagina). Lotto: non dichiarato. Dipendenze: nessuna dichiarata. .set: solo a chi compra (demo/starter/signal set).
- Recensioni critiche (pagina): akira1212 "a single loss wipes out the gains from ten trades"; Henrik Grasshoff "certainly not recommended", backtest molto meglio del live; Yen Ching Wang "Almost every large loss has wiped out previously accumulated small profits". Lo sviluppatore risponde "broker sensitive"; ha rimosso un recensore critico dal gruppo.
- FLAG: scalper (S-COSTO), coda (SL >> TP), broker-sensitive, PF 1,05.
- Motivo: nessun flag C, ma il signal ha solo 12 sett. (<20) e PF ~1; descrizione scarna. Decorrelazione: no (oro).

### 3) Mavrik Scalper - CLASSE A (con riserva)
- Pagina: https://www.mql5.com/en/market/product/184233; signal: https://www.mql5.com/en/signals/2378119
- Autore Vladimir Lekhovitser/prizmal (Israele), voto 3,3 (189). v18.307, pubblicato 04/07/2026, "aggiornato" 17/08/2026 (le recensioni arrivano a ottobre: data incoerente). 299 USD (target finale 1.499); no affitto; demo. Rating 4,17.
- XAUUSD M5, hedging, deposito min 500. Rete neurale "Hybrid Attention", selettiva, filtri orari/news, break-even/trailing, fino a 4 posizioni aperte (pagina). Risk 0,005 = DD atteso 20%, 0,010 = 25%, 0,015 = 35% (pagina).
- Signal: 29 sett., +147,85%, DD balance max 17,22%, equity relativo 8,58%, 1.023 op., PF 2,74, tenuta 22 min, win 98,33%, media +1,16/-24,99, peggiore -42,85, 3 perdite consecutive max, 94,7% short; warning "Too frequent deals" e inattivita' 6 giorni; 0 abbonati. Posizioni aperte e lotti non visibili: non posso ne' escludere ne' confermare accumulo.
- SL per operazione SI; TP SI. Lotto: non descritto (0,01 per un recensore, non verificato). Griglia/martingala/averaging: esclusi esplicitamente; recovery non menzionato. Dipendenze: filtro news senza fonte indicata [NON VERIFICATO se usa WebRequest]. .set: no.
- Recensioni critiche (pagina): Simonas Kavaliauskas 10/07 "In 99% cases EA hits SL, which is still in profit, but I've never experienced a TP scenario" e "non adatto a prop (DD >= 10%)"; Mostafa 26/09 "The robot's performance is very poor"; donhou8251 "nervous about the stop loss being hit as it is so wide". Analisi esterna ForexCracked (backtest ticks reali: entrate solo a :00/:15/:30/:45 tra 10:00 e 13:45, SL 38 USD vs ~1 USD a vincita) vista solo in un riassunto di ricerca: [NON VERIFICATO: pagina non raggiungibile].
- FLAG: coda estrema (win 98% ma una perdita ~21 vincite), scalper/S-COSTO, rete opaca, stessa mano di Nova Range.
- Motivo: nessun flag C dichiarato, signal 29 sett. con DD < 25%; il criterio "meccanismo plausibile" e' il punto piu' debole (nero), da decidere dal coordinatore. Decorrelazione: no (oro).

### 4) Tokyo EA mt5 - CLASSE C
- Pagina: https://www.mql5.com/en/market/product/197239; nessun signal dell'EA.
- Autore Vasiliy Strukov (Russia, voto 4,7 su 4.037). v1.0, pubblicato 22/09/2026. 50 USD, no affitto, demo. Rating 5 (28 recensioni).
- "Qualsiasi coppia/TF"; consigliato XAUUSD M15. Segue il trend: entra all'apertura della candela dopo la freccia dell'indicatore "Tokyo Indicator" (prodotto separato da 50 USD).
- Testo pagina: "and will trade in a grid/martingale strategy"; moltiplicatore di lotto, distanza dinamica tra ordini, opzione "drawdown reduction" (chiude l'ultimo ordine in profitto con il primo: recovery). SL/TP reali o virtuali, di default non indicati (0 = disattivato). Lotto: autolot sul margine libero o fisso. Hedge mode opzionale. Nessun limite di DD.
- .set: solo sul blog dell'autore (https://www.mql5.com/en/blogs/post/753060).
- Recensione critica: "It's a martingale EA, so the trend needs to be managed for it to remain profitable. Full auto requires a cent account".
- FLAG: griglia/martingala/recovery dichiarati; dipendenza da indicatore esterno.
- Motivo: C per griglia/martingala dichiarata. Decorrelazione: n/a.

### 5) Gamma Nova EA - [NON VERIFICATO]
- Nessuna pagina "Gamma Nova" trovata (varie ricerche, elenco Market popolare it/ pagina 1 di 247). [NON VERIFICATO: non trovato].
- Candidato per posizione (tra Tokyo EA e SomaGold nella lista) e prezzo (299): Nova Range EA, https://www.mql5.com/en/market/product/199782, signal https://www.mql5.com/en/signals/2391321. Identificazione non confermata: Claudio verifichi sullo screenshot.
- Dati del candidato: autore Lekhovitser (come Mavrik); v2.13 pubblicato 06/10/2026; 299 USD (target 1.999); XAUUSD M5; rete iTransformer, max 2 posizioni, SL su ogni trade (distanza non data), "no martingale, grid, averaging"; recovery non menzionato; filtro news senza fonte; .set no; nessuna recensione. Signal: 19 sett., +202,5%, DD balance max 3,08%, equity relativo 6,62%, 116 op., PF 23,87, tenuta 27 min, win 81%, media +3,34/-0,63, deposito iniziale 150 USD; warning inattivita' 6 giorni. Il signal esiste da 19 sett. ma il prodotto e' del 6 ottobre (v2.13).
- Classe del candidato: B (nessun flag C, ma signal <20 sett., 116 operazioni, capitale minuscolo, meccanismo opaco). Decorrelazione: no (oro).

### 6) SomaGold - CLASSE A
- Pagina: https://www.mql5.com/en/market/product/176349; signal: https://www.mql5.com/en/signals/2373152
- Autore Andrii Soma (Ucraina, voto 4,7 su 20). v3.6, pubblicato 15/05/2026, aggiornato 07/10/2026. Prezzo 600 USD (il testo parla di lancio 100 USD +100 ogni 10 copie: incoerente), affitto 60 USD/mese. Rating 4,83 (14).
- XAUUSD solo; 32 strategie breakout su D1/H12/H8/H4 in un grafico, ciascuna con magic proprio; ottimizzate 2018-2025, OOS 2007-2018 (dichiarato dall'autore).
- Signal: 22 sett., +38,45% (deposito 5.000), DD balance max 17,62%, equity relativo 14,29%, 296 op., PF 1,63, tenuta 1 h, win 60,81%, media +27,62/-26,29, 23 perdite consecutive (-1.479,75), peggiore -324,03; inattivita' 13 giorni al momento della lettura.
- SL: "layered exits con stop-loss, TP, break-even, trailing" (valori non dati). Lotto: manuale o per scalino di balance, RiskMultiplier, OnlyUp. Griglia/martingala/recovery: non menzionati; hedge non attivo di default. DD equity < DD balance: nessuna firma di averaging.
- Dipendenze tester: calendario news integrato; autorilevamento GMT richiede WebRequest a worldtimeserver.com (GMT impostabile a mano). Nessuna DLL. .set: no.
- Recensioni: Aleksandr Ryzhkov 06/10, 1 stella: "This is a very unstable Expert Advisor; the chart in the image looks great" (parla di perdite 15-20% in un giorno); RussellKing: "opens what are at times a frightening number of positions when the market moves in the right way".
- FLAG: molte posizioni contemporanee (a favore del prezzo, breakout), serie perdente lunga, prezzo.
- Motivo: nessun flag C visibile, signal 22 sett. con DD < 25% (marginale rispetto alle 20), meccanismo descritto. Decorrelazione: no (oro, ma timeframe lunghi: pochi trade, S-N da verificare).

### 7) ThunderGold Scalper - CLASSE B
- Pagina: https://www.mql5.com/en/market/product/188424; signal linkato https://www.mql5.com/en/signals/2384469: "signal not found" [NON VERIFICATO].
- Autore Jorge Luiz Guimaraes De Araujo Dias (Brasile, voto 4,1 su 221). v2.40, pubblicato 31/07/2026, aggiornato 17/10/2026. 199 USD, no affitto, demo. Rating 3,69 (29 recensioni, 117 commenti). La promo "V2 limited-time" non e' in pagina; una risposta dell'autore dice che V2 e' un "breakout engine piu' selettivo" aggiunto a V1 (V2: [NON VERIFICATO]).
- XAUUSD/GOLD M15, "multi-factor decision engine" (struttura, trend, candela, volume, momentum); ordini pendenti secondo i recensori. SL e TP automatici (SL "relativamente corto", valori non dati; un utente: "default $2 stop loss per lot"), trailing; lotto fisso o rischio % (0,5-1%). "No grid strategy"; martingala/recovery non citati. Filtro news (fonte non nominata). .set: no, solo guida via messaggio.
- Recensioni critiche (pagina): nemodori "backtest was fake ... lost about 1000 USD in one week"; liganss "Not worth buying"; yrli dopo v2.40 "order placement and profit/loss calculations are completely messed up"; MareaBaja (accusa di aggiornamenti per cancellare perdite, non verificata); tekoteko "There are no live signals anymore"; jmfxpro "the sl is very near". Lo sviluppatore ripete "broker-sensitive" e raccomanda Raw/ECN e VPS.
- FLAG: scalper (S-COSTO), SL vicino, spread/slippage, bug segnalati in v2.40, nessun signal verificabile.
- Motivo: nessun flag C dichiarato ma nessuna evidenza esterna leggibile e reputazione critica. Decorrelazione: no (oro).

### 8) Fornax Gold - CLASSE C
- Pagina: https://www.mql5.com/en/market/product/200610; signal: https://www.mql5.com/en/signals/2396276 (nome "Fornax Fixed 02").
- Autore Wahyu Krisnandi (Indonesia, voto 1164). v1.30, pubblicato 10/10/2026, aggiornato 20/10/2026. 125 USD ("only 6 copies left", next 149, final 299); no affitto; demo. Rating 5 (1 recensione).
- XAUUSD M5, Bollinger+medie, entrate da zone Orderblock, sessione Londra-New York, hedging richiesto. SL 30 USD / TP 40 USD per 0,01 lot + trailing; lotto auto a rischio % o manuale.
- Testo pagina: "This is not a grid or martingale system" ma "a controlled recovery algorithm manages the floating minus and closes the whole basket as soon as it returns to profit"; max 3 posizioni per lato, lotto uguale; recovery attivabile ("Recovery Order on/off"), default [NON VERIFICATO].
- Signal: 0 settimane, 1 operazione, +2,21%, account nuovo (499 USD/mese di abbonamento). Altri signal dell'autore non leggibili ([NON VERIFICATO]).
- Dipendenze: filtro news con ForexFactory via WebRequest (https://nfs.faireconomy.media); nel tester usa calendario interno (risultati diversi dal live). .set: no ("default = ottimizzato").
- Recensione: Justin Davis "backtests line up with live results".
- FLAG: recovery/basket dichiarato, WebRequest, signal appena aperto, promozione "pochi esemplari rimasti" in pagina.
- Motivo: C per "recovery" dichiarato. Decorrelazione: no (oro).
