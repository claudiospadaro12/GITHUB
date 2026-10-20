# Triage Market - agente 1 (lotto 8 EA), letture del 20/10/2026

Metodo: WebSearch + WebFetch su pagine pubbliche mql5.com. WebFetch riassume la pagina con un modello piccolo: tutti i numeri sono DICHIARAZIONI da ri-verificare a campione. Nessun file del repository toccato.

AVVERTENZA DATI: le "settimane" estratte per alcuni signal NON tornano con la data di inizio letta sulla stessa pagina (Gold Snap: inizio 2026.03.05 = circa 32 sett. contro 36 lette; GoldWave: inizio 2025.10.21 = circa 52 sett. contro 73 lette; AI Gold Master signal: inizio 2026.10.16 ma "5 weeks"). Riporto entrambi i valori e li marco [DA RICONTROLLARE]. Simboli su BCM e compatibilita' con il conto: [NON VERIFICATO] per tutti.

## Tabella riassuntiva

| EA | Classe | Simbolo | Flag principali | Evidenza |
|---|---|---|---|---|
| Aura Gold Pro Edition | A (al limite) | XAUUSD H1 | DD relativo balance 24,83% (Rbfx) e 34,97% (FPMarkets), PF 1,30, recensione "periodi di stagnazione" | Signal 33 e 39 sett., crescita 337% / 630%, 417 / 491 operazioni |
| Gold Snap | A | XAUUSD | scalper (tenuta media 4 min, S-COSTO), recensioni critiche (trailing, accusa backtest), nessuna attivita' da 9 giorni, preset non pubblici | Signal 36 sett. [da ricontrollare], DD balance 15,2%, DD equity 3,6%, 123 op., PF 2,51 |
| Scraper Gold | B | XAUUSD H1 | signal troppo giovani (4 sett. e 1 sett.), news via calendario MT5 + cache web, nessun preset pubblico, v3.70 in 4 settimane | Nessun signal >= 20 sett. |
| Osloma FlipPro | C | XAUUSD | 3 sistemi GRIGLIA dichiarati (fino a 12 passi), averaging, equity DD 21,8% contro balance 4,8% | Signal 9 sett. |
| Goldwave Ultra | B | XAUUSD M1 | logica "AI-assisted" non descritta, WebRequest non supportato nel tester, preset non pubblici, win rate 95%, recensione "backtest 3 trade, live nessuno" | Signal 73 sett. [da ricontrollare], 304 op., equity DD 17,5% |
| Diamond Scalper | B | XAUUSD M1 | scalper (tenuta 54 s - 12 min), ordini pendenti lontani, news filter opzionale, signal giovani con DD balance fino a 40,7% | Signal 14, 6, 2 sett. |
| AI Gold Master | C | XAUUSD M15 | fino a 7 posizioni impilate sullo stesso lato (max 8 aperte), "AI" non spiegata, zero recensioni, nessun TP | Signal di 4 giorni |
| Vortex Gold EA | C | XAUUSD H1 | equity DD 34,86% contro balance DD 16,64%; win 96,5% con 9 perdenti su 259; "additional orders" non spiegato; "neural network" senza meccanismo | Signal 29 sett. |

Bonus decorrelazione: nessuno degli 8 (tutti oro puro). Goldwave ha 4 deal su CHINA50, irrilevanti.

## Schede

### 1) Aura Gold Pro Edition
- URL: https://www.mql5.com/en/market/product/184335 ; signal: https://www.mql5.com/en/signals/2358523 (FPMarkets), https://www.mql5.com/en/signals/2366593 (Rbfx), https://www.mql5.com/en/signals/2380859 (ICTrading). Guida: https://www.mql5.com/en/blogs/post/772317
- Autore: Stanislav Tomilov (stanislav110685), rating 4,4 su 816 voti, 16 prodotti, 15 signal (pagina prodotto + https://www.mql5.com/en/users/stanislav110685/seller).
- Versione 1.5, pubblicato 10/07/2026, aggiornato 07/10/2026 (pagina prodotto).
- Prezzo 599 USD (la pagina dice che sale a 999 dal 1 novembre); affitto 399 USD / 1 anno.
- Simboli: XAUUSD / GOLD, H1. Deposito minimo 500 USD.
- Strategia dichiarata: 4 strategie indipendenti (Classic Breakout, London Open Momentum, Swing Capture, Price Action Scalper), R:R medio dichiarato 1:1.
- Signal (pagina signal):
  - FPMarkets: 39 sett., +629,84%, DD balance massimo 12,95% / relativo 34,97%, DD equity relativo 8,57%, 491 op., win 61%, PF 1,31, tenuta media 5 ore, solo XAUUSD, leva 1:500. Descrizione: "MyFX book, real funded accounts" (link Myfxbook non letto: [NON VERIFICATO]). La pagina segnala avvisi MQL5 su crescita mensile eccessiva.
  - Rbfx: 33 sett., +336,54%, DD balance massimo 19,13% / relativo 24,83%, DD equity relativo 6,86%, 417 op., PF 1,31, tenuta 5 ore.
  - ICTrading: 16 sett., +19,41%, DD balance 9,25%, DD equity 1,77%, 196 op., PF 1,25.
  - Il "+700%" del tuo screenshot non e' confermato: i dati letti sono +630% / +337% / +19%.
- Stop loss: si, "ogni trade ha SL" (pagina). Lotto: non dettagliato, rischio % per strategia (max 0,5% per rischio basso).
- Griglia/martingala/averaging: esclusi esplicitamente ("No grid, No martingale, No averaging"); "recovery" solo come "high recovery factor". Hedge non citato.
- Dipendenze tester (URL/calendario/DLL): non citate. Preset .set: non citati.
- Recensioni (7): Pechkin 2026.08.21 "had and will have stagnation periods and July 2026 was a losing month"; Mahmud Sharif 2026.10.04 cita "some negative reviews here" non visibili. Il resto e' favorevole e di tono promozionale.
- Flag: DD relativo balance al limite/oltre la soglia del 25% secondo la riga considerata; PF basso (1,30), quindi sensibile ai costi; DD balance maggiore del DD equity (possibili prelievi, non verificato).
- CLASSE A (al limite). Motivo: nessun flag C dichiarato o visibile, signal Rbfx di 33 sett. con DD 24,83% (FPMarkets 34,97%, quindi sopra soglia) e meccanismo descritto. Se si applica il DD piu' alto, scende a B: decide il coordinatore.

### 2) Gold Snap
- URL: https://www.mql5.com/en/market/product/172673 ; signal: https://www.mql5.com/en/signals/2362714, https://www.mql5.com/en/signals/2372603, https://www.mql5.com/en/signals/2379945
- Autore: Chen Jia Qi (walter2008), rating venditore 4,1 su 285. Versione 2.3, pubblicato 11/04/2026, aggiornato 15/10/2026. Rating 4,63 (31 recensioni).
- Prezzo 399 USD (offerta, regolare 799); affitto non indicato. XAUUSD, "qualsiasi timeframe".
- Strategia: breakout con uscita rapida; parametri adattivi SL/TP/trailing. Spread oro consigliato entro 25 punti.
- Signal (pagine signal):
  - 2362714: 36 sett. [da ricontrollare], +223%, DD balance 15,20%, DD equity relativo 3,61%, 123 op., win 79,7%, PF 2,51, tenuta media 4 min, XAUUSD 121 deal + GBPUSD 2, leva 1:100, Tickmill. Fermo da 9 giorni. Peggior trade -35,39 USD.
  - 2372603 ("Gold Snap Live 2"): 33 sett. [da ricontrollare], +183%, DD balance 14,18%, DD equity 2,72%, 102 op., PF 2,24.
  - 2379945: 15 sett., +38%, DD balance 10,61%, 46 op., PF 1,95.
  - Accumulo di posizioni: non determinabile dalle pagine.
- SL: si, SL e TP predefiniti piu' trailing (pagina e recensioni). Lotto: non indicato sulla pagina (recensore usa lotto fisso). Griglia/martingala: la pagina dice "no grid expansion, no martingale recovery". Una sintesi di WebSearch parlava di "grid" su un signal, ma l'URL citato (signals/2389597) e' in realta' un elenco generico: non confermato.
- Dipendenze: non citate. Preset .set: non pubblici (inviati in privato dopo l'acquisto).
- Recensioni critiche: rochejude 2026.08.27 "trailing stop failure e rientro allo stesso livello" (sviluppatore: rientro voluto); zhou xiaoqiang 2026.07.23 accusa backtest manipolato, senza prove; sviluppatore 2026-04-17 (commenti, https://www.mql5.com/en/market/product/172673/comments): "Our live signal is also experiencing losses"; blarxfj: "Same entries as Gold house. Only the SL placement and Trailing differ".
- Flag: scalper (S-COSTO), recensioni critiche, preset non pubblici, 123 op. in circa 8 mesi (S-N da verificare nel tester).
- CLASSE A. Motivo: nessun flag C dichiarato o visibile (DD equity piu' basso del balance), signal oltre 20 sett. con DD balance < 25%, meccanismo breakout descritto. Evidenza solo su conti piccoli.

### 3) Scraper Gold
- URL: https://www.mql5.com/en/market/product/197663 ; signal: https://www.mql5.com/en/signals/2392705 (Classic), https://www.mql5.com/en/signals/2396229 (Fixed Entry)
- Autore: Kriscandra Rumbang Atmaja (Indonesia, 4 prodotti, 7 signal). Versione 3.70, pubblicato 24/09/2026, aggiornato 19/10/2026.
- Prezzo 95 USD (finale 195); affitto non indicato. XAUUSD solo, H1 consigliato.
- Strategia: 4 motori breakout (Scrap A-D) con Buy Stop / Sell Stop su swing, SL e TP su ogni ordine, trailing.
- Signal: Classic 4 sett., +37,98%, DD balance 6,05%, DD equity 5,19%, 118 op., PF 2,32, tenuta 3 min; Fixed Entry 1 sett., 10 op. Entrambi segnalati da MQL5 come conti nuovi.
- SL: si. Lotto: fisso, rischio % o per balance (0,01 per 1000 USD), riduzione lotto in settimane di news.
- Griglia/martingala/averaging: pagina "No grid. No martingale. No averaging". Una sintesi di WebSearch citava "dynamic grid/hedging defense" per questo nome: non trovata nella pagina letta, contraddizione [NON VERIFICATO].
- Dipendenze tester: news filter opzionale con calendario MT5 e "web and local-cache backup" (nel tester non funziona). DLL non citata.
- Preset: non pubblici (5 preset di rischio + 3 profili nel kit dopo l'acquisto).
- Recensioni (13): quasi tutte positive. Thomas Alte 2026.10.12, risposta dello sviluppatore: "at the minimum 0.01 lot, one full SL can cost 5-10% of a $100 balance". Disputa su presunta copia, negata dallo sviluppatore.
- Flag: scalper (tenuta 3 min sul signal), nessuna evidenza lunga, versioni frequenti.
- CLASSE B. Motivo: nessun flag C dichiarato, ma nessun signal oltre 4 settimane e nessun backtest verificabile.

### 4) Osloma FlipPro
- URL: https://www.mql5.com/en/market/product/186568 ; signal: https://www.mql5.com/en/signals/2387337
- Autore: Uttam Kumar Nandeibam (traderbota). Versione 1.24, pubblicato 22/08/2026, aggiornato 05/10/2026.
- Prezzo 399 USD (prossimo 499); affitto 199 USD / mese. XAUUSD, qualsiasi timeframe.
- Strategia dichiarata: 3 sistemi GRIGLIA standalone, entrate su pullback e breakout, griglia fino a 12 passi, gestione per basket.
- Signal: 9 sett., +57,78%, DD balance massimo 7,62%, DD equity relativo 21,77%, 353 op., win 73,4%, PF 2,34, tenuta 47 min, leva 1:1000 (non sottoscrivibile).
- SL: solo a livello basket (default 500 USD per basket da 0,01 lot). Lotto: fisso 0,01 o AutoLot.
- Pagina: "NO Martingale or Double Sizing", ma griglia con averaging di fatto.
- Dipendenze e preset: non citati; solo guida inputs (https://www.mql5.com/en/blogs/post/774562).
- Recensioni (4): tutte positive ("One of the best grid bots for gold"). Sul prodotto gemello Osloma Gold (https://www.mql5.com/en/market/product/169004) ci sono molte recensioni critiche su SL enormi rispetto al TP (es. 2026.06.24 "Brutal SL hit" 4.700 USD), citate solo come contesto sull'autore.
- Flag: griglia dichiarata, averaging, SL basket molto piu' largo dei TP, coda.
- CLASSE C. Motivo: griglia dichiarata con averaging; equity DD (21,8%) molto maggiore del balance DD (4,8% relativo).

### 5) Goldwave Ultra
- URL: https://www.mql5.com/en/market/product/193209 ; signal: https://www.mql5.com/en/signals/2339082 (IC Markets)
- Autore: Shengzu Zhong (4,2 su 146 voti, 15 prodotti, 1 signal). Versione 5.6, pubblicato 01/09/2026, aggiornato 17/10/2026.
- Prezzo 699 USD ("limited", prezzo target dichiarato 1899); affitto non indicato. XAUUSD, M1.
- Strategia: "AI-assisted adaptive" con filtro news in tempo reale, una posizione alla volta; nessuna regola di entrata, indicatori o valori SL/TP dichiarati.
- Signal: 73 sett. dichiarate [da ricontrollare, inizio 2025.10.21], +775%, DD balance massimo 5,66% / relativo 8,05%, DD equity relativo 17,52%, 304 op. (290 vincenti), win 95,4%, PF 4,60, tenuta 2 ore, XAUUSD 300 deal + CHINA50 4 deal, leva 1:500. Link Myfxbook: non trovato sulla pagina prodotto (il "16 mesi, MyFXBook verified" non confermato: [NON VERIFICATO]).
- SL: adattivo, valori non dichiarati. Lotto: parametri di rischio, formula non dichiarata.
- Griglia/martingala/averaging/recovery: esclusi esplicitamente (pagina e descrizione signal).
- Dipendenze tester: WebRequest usato e "not fully supported in the Strategy Tester" (pagina). Preset: non pubblici.
- Recensioni (9): Alexander Seidel 2026.09.20 "Im Backtest ... 3 Trades ... LIVE..? Keinen Einzigen". Sul signal, recensioni che segnalano errori di copia su simboli con suffisso e una perdita grande.
- Flag: logica opaca, win rate 95% con coda, tester non affidabile, equity DD circa il doppio del balance DD.
- CLASSE B. Motivo: nessun flag C esplicito e signal lungo con DD < 25%, ma meccanismo non descritto (manca il requisito A) e profilo a coda.

### 6) Diamond Scalper
- URL: https://www.mql5.com/en/market/product/190894 ; signal: https://www.mql5.com/en/signals/2382857 (Mode 3), https://www.mql5.com/en/signals/2390825 (Mode 11), https://www.mql5.com/en/signals/2394547 (IC 1)
- Autore: Lo Thi Mai Loan (Xubisoft Viet Nam), 4,6 su 290 voti. Versione 2.1, pubblicato 06/09/2026, aggiornato 08/10/2026. Rating 5 (9 recensioni).
- Prezzo 299 USD (sale ogni 10 licenze); affitto 99 USD / mese o 199 USD / 3 mesi. XAUUSD, M1.
- Strategia: 3 strategie (trend-following + 2 breakout), 11 modi, trailing comune, chiusura venerdi', filtro spread, limiti giornalieri e DD.
- Signal: Mode 3: 14 sett., +27%, DD balance 40,71% massimo / 26,97% relativo, DD equity 5,53%, 82 op., PF 1,06, tenuta 2 min. Mode 11: 6 sett., +24%, DD balance 22,54%, 38 op., PF 1,27, tenuta 54 s. IC 1: 2 sett., +19%, DD balance 12,38%, 39 op., PF 1,50. Nessuno raggiunge 20 settimane.
- SL: si, legato al modo, gestito dal trailing; valori non dichiarati. Lotto: fisso, rischio % o rischio a scaglioni.
- Pagina: no martingala, no griglia, no hedging. News filter opzionale (dipendenza dal calendario, non funzionante nel tester).
- Preset: un file .set per XAUUSD solo dopo l'acquisto.
- Recensioni critiche: Guilliano22 2026.10.09 "most pending orders were never filled ... this is not a high-speed money printing machine"; Manus Coetzee 2026.10.05 "I can just not understand why it would open pending orders very far away from current market prices".
- Flag: scalper con tenuta di secondi/minuti (S-COSTO), ordini pendenti non eseguiti, evidenza giovane. Backtest del venditore sul blog (https://www.mql5.com/en/blogs/post/775447, https://www.mql5.com/en/blogs/post/775822) visti solo tramite WebSearch, non letti: [NON VERIFICATO].
- CLASSE B. Motivo: nessun flag C dichiarato; nessun signal >= 20 sett. e DD balance 40,7% sul Mode 3.

### 7) AI Gold Master
- URL: https://www.mql5.com/en/market/product/201604 ; signal: https://www.mql5.com/en/signals/2395909
- Autore: Ho Tuan Thang ("eatrading.ai"). Versione 1.0, pubblicato 16/10/2026.
- Prezzo 199 USD per le prime 10 copie (la pagina da' prezzi finali contraddittori, 299 o 1999); affitto non indicato. XAUUSD, M15.
- Strategia: nessuna spiegazione di cosa sia l'"AI" ne' della logica di entrata. Backtest del venditore 2020.01.01 - 2026.07.18, 1.976 operazioni (numeri di redditivita' non trascritti).
- Dalla pagina: sequenze fino a 7 posizioni sullo stesso lato, passo mediano 2,373, max 8 aperte; nessun TP mai raggiunto, 91,65% di chiusure su trailing in profitto; peggior perdita -57,73 USD.
- Signal: pagina dice 5 sett. ma inizio 2026.10.16 (4 giorni), +62%, DD balance 15,56% / 7,09%, DD equity 6,42%, 15 op., PF 3,04. MQL5 segnala troppe poche operazioni.
- SL: si (chiusure a stop). Lotto: fisso 0,01 o rischio %, modalita' "High Risk (max drawdown 30%)". Martingala/hedge/recovery: non citati. Dipendenze: non citate. Preset: non scaricabili.
- Recensioni: nessuna.
- Flag: accumulo di posizioni (grid-like), IA non spiegata, nessuna evidenza esterna, prezzo con conflitto.
- CLASSE C. Motivo: posizioni impilate fino a 8 sullo stesso lato (direzione rispetto al prezzo non dichiarata: se fosse piramidazione con il trend va rivalutata) e promessa "AI" senza meccanismo ne' prova esterna.

### 8) Vortex Gold EA
- URL: https://www.mql5.com/en/market/product/126409 ; signal: https://www.mql5.com/en/signals/2366351 (altro: https://www.mql5.com/en/signals/2392524, Vortex S3, 6 sett.)
- Autore: Stanislav Tomilov. Versione 3.15, pubblicato 11/11/2024, aggiornato 13/09/2026. Rating 4,96 (50 recensioni).
- Prezzo 755 USD (prossimo 895); affitto 395 USD / anno. XAUUSD, H1. Deposito minimo 250 USD.
- Strategia: due strategie con CCI e Parabolic SAR, ciascuna con funzione di "additional orders"; "neural network / machine learning" dichiarati senza architettura.
- Signal 2366351: 29 sett., +161%, DD balance 16,64%, DD equity relativo 34,86%, 259 op., win 96,5% (9 perdenti), PF 10,06, tenuta 3 ore, leva 1:1000 (non sottoscrivibile). Descrizione: "MyFX book, real funded accounts" (non verificato).
- SL: si, hard SL su tutte le strategie, piu' trailing. Lotto: "adaptive lot sizing" e livelli di rischio, formula non data.
- Martingala: esclusa. Griglia/averaging/recovery/hedge: non descritti, ma "additional orders" non chiarito.
- Dipendenze e preset: non citati.
- Recensioni critiche: Mustafa Ibrahim 2026.02.26 "the risk is much greater than the potential profit, and capital can be lost easily"; Ayyappan Selvam 2026.08.19 "trades very slow [2-3 trades per week]".
- Flag: equity DD oltre il doppio del balance DD, coda (96% vincenti, perdite grandi), pochi trade, "IA" senza meccanismo.
- CLASSE C. Motivo: DD equity (34,86%) molto maggiore del balance DD (16,64%), indice di posizioni aperte contro il prezzo; "additional orders" non spiegati.
