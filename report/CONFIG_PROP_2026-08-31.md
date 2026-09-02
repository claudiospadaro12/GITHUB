# 🎯 CACCIA CONFIG-PROP — 31/08/2026

_Mandato di Claudio (31/08 sera), al servizio delle due firme di
`report/FIRME_2026-08-31.md` e del `report/PIANO_MIGRAZIONE_100K_2026-08-31.md`.
**Tre bersagli**: (1) guardiano di conto / enforcement del cap C1, (2) la
definizione operativa di "high-frequency trading" nelle prop, (3) filtro news
per gli ordini PENDENTI._

**Questo file non tocca niente.** Nessun EA, nessun preset, nessun parametro in
forward. Sono carta e proposte: decide Claudio.

---

## 🔴 LA RIGA CHE CONTA

> Ho censito **5 prop** (via ricerca, i siti ufficiali sono irraggiungibili da
> qui) e **11 prodotti/sorgenti esterni** su **4 fonti utili su 8 provate**.
> **I meccanismi che ci mancano davvero sono 4** — e il primo che farei non e'
> nessuno dei tre bersagli come erano posti, e' questo: **la nostra "mina
> Risk Per Trade Idea" era letta al contrario, e la lettura giusta e' PEGGIO.**
> La regola FundingPips non colpisce il pile-up di 8 sedie diverse (quello NON
> e' una "idea"): colpisce lo **stesso simbolo, stessa direzione** — e li' il
> conto piccolo ha gia' prodotto un gruppo da **−10,67% del conto in 9 minuti**
> (5 posizioni DAX short di 4 magic, 29/07), contro un tetto del **3%**.
> Un **HARD BREACH da 3,5×, misurato sui nostri CSV oggi**.
>
> Buona notizia sul bersaglio 2: **la clausola HFT e' disinnescata da un
> numero**. Nessuna prop la definisce per trade/giorno; tutte la definiscono
> per **tempo di tenuta**. Il piu' severo misurabile trovato e' E8:
> _"non piu' del 50% dei trade tenuti sotto 1 minuto"_. **Noi siamo al 4,6%**
> (581 trade automatici, mediana di tenuta **224,7 minuti**). La filosofia
> "1-2+ trade/giorno su TF bassi" e' **legale su tutte e 5 le prop censite**,
> col paletto scritto sotto.

---

## 1. 🧪 CONTROLLO POSITIVO — cosa risponde e cosa e' NULLO

Fatto **prima** di cercare, su ogni canale.

| fonte | esito | conseguenza |
|---|---|---|
| **ftmo.com** (pagina regole ufficiale) | ❌ **EGRESS_BLOCKED** dal proxy di rete | 🛑 **FONTE NULLA da questa sessione.** Niente lettura diretta del normativo FTMO |
| **help.fundingpips.com** / **fundingpips.com** | ❌ **EGRESS_BLOCKED** | 🛑 **FONTE NULLA.** Il testo della "Risk Per Trade Idea" NON e' stato letto sulla pagina ufficiale |
| **help.e8markets.com** | ❌ **EGRESS_BLOCKED** | 🛑 FONTE NULLA |
| earnforex.com · tradingfinder.com · fortraders.com · quantvps.com · alfatactix.com · proptradingvibes.com | ❌ EGRESS_BLOCKED (tutti) | 🛑 tutta la stampa di settore e' fuori portata |
| **mql5.com** (Market, CodeBase, Articoli, Forum) | ✅ contenuti veri, letti a pagina piena | 🥇 **la fonte piu' produttiva del giro** |
| **api.github.com** | ✅ risponde (ricerca repo + contenuti) | 🥈 utile, ma vedi §2.3: il campo e' inquinato |
| github.com (ricerca web) | ⚠️ **429 Too Many Requests**, Retry-After 3600 | non e' un 404: e' "non adesso". Aggirato via API |
| **WebSearch** | ✅ restituisce estratti di contenuto dalle pagine bloccate | 🥉 usato per le prop, con etichetta dedicata |

### ⚠️ L'ETICHETTA CHE VA LETTA PRIMA DI TUTTO IL §3

Poiche' **nessun sito ufficiale di prop e' raggiungibile**, **ogni riga sulle
regole in questo dossier e' `[LETTO-VIA-SEARCH]`**, mai `[VERIFICATO]`. E'
l'etichetta gia' in uso in `PIANO_PROP.md` (riga D1). Significa: il testo
proviene dall'estratto che il motore di ricerca ha tratto dalla pagina, non
dalla pagina aperta da me. **Prima di comprare una challenge, ogni riga del §3
va riletta sul sito della prop, quel giorno.** Vale in particolare per le due
righe che cambiano decisioni: la RPTI di FundingPips e il 50%/1-minuto di E8.

---

## 2. 🛡️ BERSAGLIO 1 — IL GUARDIANO DI CONTO (enforcement del cap C1)

### 2.1 Cosa abbiamo GIA' in casa — censimento del repo, fatto oggi

Prima di proporre doppioni. **Il guardiano-enforcement del 19/08 esiste, ed e'
molto piu' avanti di come lo descriveva il mandato.**

| pezzo | dove | stato misurato |
|---|---|---|
| `ABTG_Guardian.mq5` **v1.11** | `mql5/Experts/ABTG_Guardian.mq5` (23.320 byte) | vivo, magic 779001 |
| Cap C1 **gia' scritto** | `InpMaxOpenRiskPct = 3.25` (riga 60) | ✅ **il valore firmato E' gia' nel codice**, non e' da scrivere |
| Rischio aperto aggregato | `OpenRiskPct()` righe 153-181: somma su **tutte** le posizioni, **qualsiasi magic**, via `OrderCalcProfit` con ripiego tick_value | ✅ meccanismo corretto e valuta-aware |
| Due letture del rischio | `InpRiskMode` 0=dall'INGRESSO (convenzione M2) · 1=dal PREZZO CORRENTE | ✅ piu' ricco della media degli esempi esterni |
| Canale verso gli EA | 5 GlobalVariable di terminale (`GV_PAUSA`, `GV_PAUSAFINO`, `GV_CAP`, `GV_RISKPCT`, `GV_BATTITO`) | ✅ + **verifica del filo** in `OnInit` (v1.11): confronta i nomi con quelli dell'include e urla se divergono |
| Lettura lato EA | `mql5/Include/ABTG_PausaGuardian.mqh` **v1.40**, 1.461 righe | ✅ **67 EA includono il file, 65 chiamano `ABTG_GuardiaIngresso()`** |
| Freno perdite consecutive (P1) | nell'include, nucleo puro `ABTG_PerditeConsecutive_Calc` | ✅ presente, **spento** (soglia 0) |
| Stop a obiettivo (S1) | nell'include v1.40 | ✅ presente, spento |
| Battito / fail-open | `ABTG_BATTITO_TOLLERANZA = 120` s | ✅ progettato e documentato |
| Autotest | `InpAutotest` nel Guardian + `ABTG_AutotestGuardia()` nell'include | ✅ 19 casi |
| Collaudo | `REFERTO_MIGRAZIONE_GUARDIAN_PREPARAZIONE.md`: **9 criteri congelati** | 🟡 **criteri 1-4 PASSATI il 19/08** (49/49 compilano, backtest identico al centesimo). **I criteri 5-9 sono ancora vuoti** |

> 🔵 **Correzione al mandato, con le prove**: il guardiano-enforcement **non
> e' "mai collaudato"**. E' **collaudato a meta'**: il criterio 4 (backtest
> identico prima/dopo, 8 confronti su 8) e' verde e archiviato in
> `guardian_REFERTO_CRITERIO4_2026-08-19.txt`. Quello che manca e' il collaudo
> **in campo**: 5 (la pausa blocca davvero), 6 (le posizioni aperte restano
> gestite), 7 (il cap rifiuta l'ingresso in eccesso), 8 (fail-open entro ~2
> min), 9 (3 giorni senza blocchi inspiegati). **Sono i cinque che costano
> giorni, non ore** — e sono esattamente il cancello della fase 2 del piano di
> migrazione.

### 2.2 🥇 LA TABELLA DEGLI ESEMPI — i valori copiabili

_Riga = un esempio esterno. Colonne = i valori. Ultima colonna = cosa ne
portiamo a casa. Tutti letti oggi 31/08/2026._

| # | esempio · fonte | prezzo | come AGGREGA | come BLOCCA gli altri EA | valori dichiarati | cosa ne copiamo |
|---|---|---|---|---|---|---|
| **E1** | **RiskGate — Centralized Risk Management for Multiple EAs**, articolo MQL5 21720, D. N. Rechia · [link](https://www.mql5.com/en/articles/21720) | gratis (articolo + sorgente) | **Service** MT5 centrale: gli EA mandano un JSON `{"symbol","sl_points","magic"}`, il servizio risponde `{approved, lot, reason}` | **permesso PRIMA di `OrderSend`** — l'EA non decide, chiede | **daily loss 2% equity · rischio/trade 0,5% · max 2 posizioni per simbolo · max 6 trade/giorno · esposizione correlata: lotto ×0,5 se lo stesso gruppo magic ha gia' una posizione** · timeout 500 ms · porta TCP 5555 · fino a 32 connessioni | 🥇 **la PRENOTAZIONE**: chiedere il permesso col rischio dell'ordine *futuro*, non leggere una bandiera sul rischio *passato*. E' il pezzo che chiude il buco dei gemelli. 🥇 **`max 2 posizioni per simbolo`** e **`lotto ×0,5 su gruppo correlato`**: due valori pronti. ⚠️ E il **fail-CLOSED** (`RISKGATE_FALLBACK_REJECT`, _"se il Service non risponde, nessun trade"_) — **l'opposto della nostra scelta** |
| **E2** | **Implementing a Daily Loss Limit and Drawdown Circuit Breaker in MQL5**, articolo MQL5 23732 · [link](https://www.mql5.com/en/articles/23732) | gratis | somma **P&L realizzato (deal `DEAL_ENTRY_OUT`/`INOUT`, con profit+swap+commissione) + P&L flottante (`POSITION_PROFIT + POSITION_SWAP`)** | `IsHalted()` chiamato **prima di ogni singolo `OrderSend`**; sezione 9: estensione via `GlobalVariableSet/Get` per gli altri EA | `InpDailyLossLimit = -500.0` · reset a **mezzanotte ora SERVER** (`MidnightToday()`) · check **a ogni tick** · pannello con "buffer residuo" | 🥇 **l'ORDINE della sequenza di emergenza**: chiudi posizioni → cancella pendenti → **solo allora** alza la bandiera _(«così il flag non dice mai true mentre l'esposizione è ancora aperta»)_. **Noi lo facciamo gia' cosi'** (`FlattenAll` righe 314-322): conferma, non buco. 🥈 lo **swap incluso**: dichiarato _"e' un costo gia' in corso"_ |
| **E3** | **Prop Firm Drawdown Monitor (Daily + Total DD, Auto-Close)**, CodeBase 69430, monkee1202, 14/02/2026 · [link](https://www.mql5.com/en/code/69430) | gratis | daily + totale, **statico e trailing**, reset consapevole del fuso | **`OnTradeTransaction`**: dopo la violazione intercetta le posizioni aperte **da altri EA o a mano** e le chiude in millisecondi + GlobalVariable per chi coopera | **buffer di sicurezza configurabile** sotto il limite · **slippage 50 punti** in chiusura ("per garantire l'esecuzione") · stato persistito in GlobalVariable e sopravvive ai riavvii | 🥇 **`OnTradeTransaction` come RETE DI SICUREZZA**: il nostro canale funziona **solo se l'EA collabora**. Questo funziona anche contro un EA non migrato, un EA nuovo, o un click a mano. 🥈 lo **slippage generoso in emergenza**. ⚠️ **la pagina oggi dice "The code has been removed"**: meccanismo `[LETTO-VIA-SEARCH]`, sorgente non piu' scaricabile |
| **E4** | **KT Equity Protector MT5** v3.1, KEENBASE, agg. 01/07/2026 · [link](https://www.mql5.com/en/market/product/79554) | **30 $** | conto intero, 5 regole | azioni a scelta, fino a **"chiudi tutto e RIMUOVI ogni altro EA dal terminale"** | 🥇 **"agisce al 4,5% invece del 5%"** (buffer dichiarato) · **3 modelli di ancoraggio del DD: saldo statico / massimo saldo trailing / massima equity trailing** · **protezione gap del weekend** (chiude prima della chiusura del venerdi') · **trailing profit lock** con % di restituzione · log CSV giornaliero timbrato | 🥇 **il TERZO ancoraggio**: noi abbiamo `InpDDMode` 0=statico e 1=**picco equity**. Ci manca **"massimo SALDO trailing"** — ed e' il modello di alcune prop. 🥇 **il buffer 4,5%**: loro un mezzo punto sotto il muro, noi la pausa a 4,0 su muro 5,0 = **1,0 punto**. Piu' prudente: nessuna azione. 🥈 **weekend gap**: non ce l'abbiamo |
| **E5** | **Daily Drawdown Limit EA Prop Firm**, Mathieu/Frede Alfaro · [link](https://www.mql5.com/en/market/product/85087) | **40 $** | DD giornaliero **sul deposito iniziale**, non sul saldo corrente | chiude tutto + blocca nuovi ingressi | DD giornaliero **"tipicamente 4-5%, regolabile a 4,8%"** · **reset a 23:00 CEST** | ✅ **CONFERMA ESTERNA DEL NOSTRO `reset 23`**: la firma del 18/08 mette `InpDailyResetHour = 23`. 23:00 su BCM (UTC+1 in agosto) = **mezzanotte del server di una prop in UTC+2**. Un vendor indipendente ha scelto lo stesso numero: **la nostra ora e' giusta** |
| **E6** | **Trade Equity Guardian** v1.10, Lee Samson, agg. 20/02/2026 · [link](https://www.mql5.com/en/market/product/165927) | gratis | ❌ **per POSIZIONE, non aggregato** | non blocca: chiude soltanto | `Check Interval = 5 s` · `Slippage = 10 punti` · `Max Close Retries = 3` · `Magic Filter = 0` (tutti) · Max Lot / Max % equity / Max Profit $ / Max Loss $, **tutti a 0 = spenti** | 🥈 **`Max Close Retries = 3`**: il nostro `FlattenAll` **non ritenta**. Se una chiusura fallisce (spread, requote) il giro dopo del timer ci riprova, ma non e' scritto come politica. 🥉 default a 0 = spento: stessa filosofia di casa |
| **E7** | **Prop Firm Risk Dashboard**, CodeBase 74553, Dror Munk, 01-02/07/2026 · [link](https://www.mql5.com/en/code/74553) | gratis, **sorgente incluso** (`PropFirmRiskDashboard.mq5`, 9,42 KB) | daily + DD statico da saldo configurato | ❌ **solo lettura: non piazza, non modifica, non chiude** | equity di inizio giornata **in una GlobalVariable di terminale** _"cosi' il P/L di oggi resta corretto attraverso ricariche del grafico e riavvii del terminale"_ | ✅ **conferma della nostra scelta di persistenza** (`GV_DAYSTART`). Nessun buco: siamo gia' avanti |
| **E8** | **PropGuard Dead-Line Visualizer**, CodeBase 68087, Arnold Holm, 10/01/2026 · [link](https://www.mql5.com/en/code/68087) | gratis | disegna le **linee di prezzo** dei due muri sul grafico | ❌ indicatore | daily max DD % · overall max DD % · trailing on/off · **soglia di allarme %** · dichiara: _"in v1.00 il saldo di inizio giornata e' approssimato"_ | 🥉 l'idea della **linea sul grafico** ("dove muoio oggi") — cosmetica, ma e' la lettura che manca alla legge dello screenshot |
| **E9** | **Automating Trade Discipline with an MQL5 Risk Enforcement EA**, articolo 20587 · [link](https://www.mql5.com/en/articles/20587) | gratis | limiti giorno/settimana/mese | **`GV_ALLOW = 0`** blocca i nuovi ingressi **e** chiama `ForceCloseAllPositionsNow()` | daily −300 / +100 · settimanale ∓1.000 · mensile ∓5.000 (USD) | ✅ **stessa identica architettura della nostra** (una GlobalVariable "si puo' aprire"): conferma indipendente che la strada e' quella standard. 🥈 **i limiti SETTIMANALE e MENSILE**: noi abbiamo solo giorno e totale |
| **E10** | forum MQL5 512694 — _"How do you handle drawdown rules across a portfolio of EAs (prop firm style)?"_ · [link](https://www.mql5.com/en/forum/512694/page1) | — | ogni EA pubblica il proprio flottante su variabile/file condiviso; un blocco master **taglia le taglie in proporzione** | scala prima, chiude dopo | **soglie a scaglioni 5% e 8%** · budget diviso: _"perdita giornaliera max 5% su 5 strategie → limite di 1% per EA"_, poi **quell'EA e' in pausa per il resto della giornata** | 🥇 **LA SCALA A GRADINI**: _"prima riduci o blocca i nuovi ingressi, forza la chiusura SOLO a un limite duro predefinito"_ — e' esattamente il nostro impianto (pausa 4,0 morbida → emergenza 4,9 dura). 🥈 **il BUDGET PER SEDIA**: alternativa al cap globale, e non ce l'abbiamo. ⚠️ E l'avvertimento contrario, che va scritto: _"non mettere in pausa una strategia solo per il P&L recente — la disattiveresti proprio prima che torni il suo regime"_ |
| **E11** | ricerca GitHub (via API): `youcefbibo53/PropGuard-Trailing-Equity-Armor` (119★), `Valtorim/MT5-PropFirm-Drawdown-Guard` (MIT), `Quorvathz/Prop-Matrix-Engine`, `Avenmoqe/MT5-PropFirm-MultiPass-Dashboard` | "gratis" | — | — | — | 🚩 **BANDIERA ROSSA, e vale come risultato**: ho aperto l'albero dei file di due di questi. `PropGuard-...-Armor` (119 stelle!) contiene **README.md, index.html, 2 SVG — zero `.mq5`**. `MT5-PropFirm-Drawdown-Guard` (MIT) e' un'app **.NET/Visual Studio**, **nessun sorgente MQL**, e i preset "FTMO/MFF/FundedNext" citati **senza un solo numero**. Quattro repo su sei con `pushed_at` **lo stesso identico giorno**. **La prima pagina di GitHub per "prop firm drawdown guard MQL5" e' vetrina, non codice.** Costo di verifica: 4 minuti. Risparmio: una giornata |

### 2.3 🕳️ LA TABELLA DEI BUCHI — bersaglio 1

| # | meccanismo trovato fuori | ce l'abbiamo? | il buco, in una riga |
|---|---|---|---|
| B1 | rischio aperto aggregato su tutti i magic, da SL, valuta-aware | ✅ **SI'**, `OpenRiskPct()` | — |
| B2 | canale a GlobalVariable letto prima di `OrderSend` | ✅ **SI'**, 65 EA | — |
| B3 | chiudi → cancella pendenti → alza bandiera, in quest'ordine | ✅ **SI'** | — |
| B4 | scala a gradini morbida→dura | ✅ **SI'** (4,0 / 4,9 / 9,9) | — |
| B5 | persistenza su riavvio | ✅ **SI'** | — |
| **B6** | 🔴 **il cap vede gli ORDINI PENDENTI** | ❌ **NO** — `OpenRiskPct()` cicla solo `PositionsTotal()` (riga 159) | **PunteLarry e tutta la famiglia "apertura" lavorano a STOP pendenti.** Cinque stop pendenti a 0,65% sono **3,25% di rischio gia' promesso** che il cap **conta zero**. E' lo stesso difetto gia' agli atti come nota M14 — qui e' confermato riga alla mano |
| **B7** | 🔴 **prenotazione del rischio dell'ordine FUTURO** (E1) | ❌ **NO** — leggiamo il rischio *gia' in campo* | Due EA che sparano **nello stesso secondo** (i gemelli PTE, il grappolo DAX delle 08:15) leggono **entrambi** un cap libero, e **passano entrambi**. Il cap e' esatto ma **in ritardo di un tick**. Con `GlobalVariableSetOnCondition()` (atomico, citato nel forum MQL5) la prenotazione si fa senza un servizio TCP |
| **B8** | 🟡 rete di sicurezza `OnTradeTransaction` (E3) | ❌ NO | oggi il cap protegge **solo dagli EA che collaborano**. Un EA nuovo non migrato, o un ordine a mano, passa. Con 18 sedie sul 100k la probabilita' che una resti indietro non e' zero |
| **B9** | 🟡 terzo ancoraggio del DD: "massimo SALDO trailing" (E4) | ❌ NO (abbiamo statico + picco equity) | non morde su FTMO/FundingPips (muri statici). **Morde se un giorno si sceglie una prop a trailing** — e sarebbe una riga da scrivere, non una settimana |
| **B10** | 🟡 protezione gap del weekend (E4) | ❌ NO | rilevante: **FTMO Standard chiede la chiusura nel weekend sui funded**, Alpha Pro segnala "soft breach". Non e' il collo di bottiglia di stasera |
| **B11** | 🟢 ritenta la chiusura N volte (E6: 3) | ❌ non dichiarato | `FlattenAll` prova una volta per giro di timer. Funziona, ma non e' una politica scritta |
| **B12** | 🟢 limiti settimanale/mensile (E9) | ❌ NO | fuori mandato di stasera |

---

## 3. ⚡ BERSAGLIO 2 — CHE COS'E' "HIGH-FREQUENCY TRADING" PER LE PROP

**Il risultato, in una riga: nessuna delle 5 prop censite definisce l'HFT per
NUMERO DI TRADE. Tutte lo definiscono per TEMPO DI TENUTA.** Il che sposta il
problema di Claudio da "quanti trade posso fare" a "quanto devono durare".

### 3.1 Le schede — tutte `[LETTO-VIA-SEARCH]`, 31/08/2026

```
PROP            FundingPips        URL REGOLE  help.fundingpips.com (BLOCCATO, letto via search)
LETTA IL        31/08/2026         ETICHETTA   [LETTO-VIA-SEARCH]
HFT             fra le pratiche VIETATE, in lista con gap trading, toxic flow, server
                spamming, latency arbitrage, hedging, tick scalping, opposite account trading.
                DEFINIZIONE OPERATIVA piu' vicina trovata: sui Master, "i profitti dei trade
                CHIUSI ENTRO 1 MINUTO dall'apertura NON vengono conteggiati".
                E i segnali di "toxic flow": tenute estremamente brevi (aperto e chiuso in
                SECONDI), profitto sistematico dai gap di sessione, pattern da tick scalping,
                accumulo di ordini attorno alle news sul funded.
RISK PER TRADE  ** LA CORREZIONE DEL DOSSIER — vedi 3.3 **
IDEA            "una trade idea e' un singolo trade, OPPURE piu' posizioni sullo STESSO
                STRUMENTO nella STESSA DIREZIONE, incluse le nuove posizioni aperte entro
                10 MINUTI DALLA CHIUSURA DI UN TRADE IN PERDITA". Perdita combinata
                realizzata+non realizzata. Tetto: 3% della size iniziale sotto 50k, 2% da
                50k in su. Un profitto nel gruppo NON compensa la perdita.
                NON si applica in evaluation: SOLO sui Master (inclusi i conti fusi).
NEWS            Master: i profitti dei trade aperti O chiusi entro 5 MIN PRIMA / 5 MIN DOPO
                una news high-impact "Restricted" sulle valute colpite NON contano —
                salvo che il trade sia stato aperto 5 ORE o piu' prima dell'evento.
                Viene dedotto il profitto INTERO del trade, non la sola parte nella finestra.
                Solo eventi ROSSI, solo la valuta colpita, calendario ufficiale = quello
                della loro dashboard.
EA              EA di terzi ammesso SOLO se funziona da trade/risk manager. Copy trading e
                gestione da terzi: VIETATI, chiusura del conto.
```

```
PROP            E8 Markets         URL REGOLE  help.e8markets.com (BLOCCATO, letto via search)
LETTA IL        31/08/2026         ETICHETTA   [LETTO-VIA-SEARCH]
HFT             *** L'UNICA DEFINIZIONE NUMERICA TROVATA IN TUTTO IL GIRO ***
                "per prevenire l'abuso di high-frequency trading, non puoi tenere PIU' DEL
                50% DEI TUOI TRADE SOTTO UN MINUTO."  -> e' una soglia MISURABILE, e noi
                la possiamo calcolare sul nostro CSV. Vietati anche latency arbitrage e
                cross-account hedging.
NEWS            permesso in evaluation; sui funded VIETATO nella finestra 5 MIN PRIMA e
                5 MIN DOPO le news high-impact sugli strumenti interessati.
EA              ammessi, ma UNA SOLA strategia unica per utente: stesso EA usato da piu'
                utenti = rischio di chiusura.
```

```
PROP            FTMO               URL REGOLE  ftmo.com/en/forbidden-trading-practices (BLOCCATO)
LETTA IL        31/08/2026         ETICHETTA   [LETTO-VIA-SEARCH]
HFT             vietato. Descritto qualitativamente: "trade aperti e chiusi in millisecondi
                o secondi che mirano a inefficienze di prezzo", "decine di trade al minuto",
                "bot HFT che dipendono da esecuzione sub-millisecondo". Nessuna soglia.
                Il minimo di durata del trade e' stato RIMOSSO nel 2022; resta il flag
                sui trade sotto i 2 minuti (INCERTO: soglia di segnalazione, non di breach).
                Vietato anche: distribuire artificialmente il profitto su piu' giorni senza
                distribuire proporzionalmente il RISCHIO (hedging / posizioni opposte su
                strumenti uguali o molto correlati).
NEWS            *** LA RIGA CHE CI RIGUARDA ***
                "non e' permesso aprire o chiudere alcun trade, INCLUSA L'ESECUZIONE DI
                ORDINI PENDENTI (come Stop Loss o Take Profit), nella finestra che inizia
                2 MINUTI PRIMA e finisce 2 MINUTI DOPO il rilascio" — sugli strumenti
                interessati. Un Buy/Sell Stop che SI ATTIVA dentro la finestra CONTA come
                apertura di un nuovo trade.
                SCOPE: si applica ai conti funded STANDARD. Il conto SWING e' esente (sia
                news sia chiusura del weekend). Strumenti non interessati: liberi.
EA              ammessi. Rischio dichiarato: se piu' conti fanno trade identici, FTMO puo'
                classificarlo come copy/group trading.
```

```
PROP            The5ers            LETTA IL 31/08/2026     ETICHETTA [LETTO-VIA-SEARCH]
HFT             vietato "con durate di pochi secondi o meno". Nessuna soglia numerica.
NEWS            generalmente permesso; sul programma HIGH STAKES vietato eseguire ordini
                nei 2 MINUTI prima/dopo news high-impact.
EA              ammessi; vietati gli EA che scalpano durante il rollover.
CONSISTENZA     nessun giorno oltre il 50% del profitto totale.
```

```
PROP            Alpha Capital Group     LETTA IL 31/08/2026    ETICHETTA [LETTO-VIA-SEARCH]
HFT             EA high-frequency / arbitrage / copy / latency: VIETATI.
EA              *** IL VINCOLO OPERATIVO PIU' PESANTE TROVATO ***
                si deve SOTTOPORRE IL CODICE SORGENTE (MQ5) e il set file dell'EA per
                revisione e APPROVAZIONE PREVENTIVA. Solo MT5.
NEWS            Pro Plan: vietato aprire o chiudere 2 MIN prima e 2 MIN dopo le news
                high-impact (Red Folder di Forex Factory). Conti SWING: nessun limite.
CONSISTENZA     regola del "best day" al 40% (letta via search, non confermata).
```

**Riga trasversale, terza fonte:** _"la maggior parte delle firm vieta le
strategie con frequenza di trade sotto i 5 secondi"_ — la soglia di fatto del
settore e' **il secondo, non il giorno**.

### 3.2 🥇 LA MISURA DI CASA — la mina HFT disinnescata con un numero

Calcolata stasera su `data/statements/trades_auto.csv` e `trades_100k.csv`,
solo trade automatici (magic ≠ 0):

| conto | n trade auto | **<5 s** | **<60 s** | <120 s | <300 s | mediana di tenuta |
|---|---:|---:|---:|---:|---:|---:|
| piccolo (`trades_auto`) | **581** | 3 (**0,5%**) | 27 (**4,6%**) | 42 (7,2%) | 77 (13,3%) | **224,7 min** |
| dry-run 100k | 22 | 0 (0,0%) | 1 (4,5%) | 1 (4,5%) | 2 (9,1%) | **31,8 min** |

**Verdetto sul bersaglio 2, con i numeri:**

- 🟢 **E8 (l'unica soglia misurabile): tetto 50% sotto 1 minuto. Noi 4,6%.
  Margine 10,9×.** Anche triplicando la frequenza non ci avviciniamo.
- 🟢 **FundingPips (1 minuto = profitti non contati): il 4,6% dei nostri trade
  cadrebbe nella regola.** Non e' un breach, e' una **rinuncia al profitto**
  su una minoranza di trade. Da tenere d'occhio, non da temere.
- 🟢 **FTMO / The5ers ("secondi", "decine di trade al minuto")**: fuori scala
  rispetto a noi di tre ordini di grandezza. La flotta intera fa **111,9
  op/MESE**; loro parlano di decine al minuto.
- 🟡 **Il paletto da scrivere nella filosofia nuova.** La direzione firmata
  ("piu' EA con trade frequenti su TF bassi") e' legale **finche' la tenuta
  MEDIANA resta sopra il minuto**. Su M1 con SL stretto **non e' garantito**.
  → proposta P5.
- ⚠️ **Alpha Capital e' un caso a parte**, e non per l'HFT: chiede il
  **sorgente MQ5 di ogni EA**. Con 18 sedie, e' un progetto, non una casella.

### 3.3 🔴 LA CORREZIONE — "Risk Per Trade Idea": la leggevamo al contrario

**Cosa dice oggi `PIANO_MIGRAZIONE_100K` §3 (e `PIANO_PROP` H5/M28):**

> _"Risk Per Trade Idea = max 2% combinato per idea, dove 'stessa idea' =
> nuova posizione entro 10 minuti nella stessa direzione (Master ≥25k)"_ →
> e in tabella: _"M2: 9 posizioni di 8 sedie aperte insieme = 5,85% il 03/08
> → HARD BREACH"_.

**Cosa dice il testo trovato oggi** `[LETTO-VIA-SEARCH]`, su due ricerche
indipendenti che concordano parola per parola:

| pezzo | lettura di casa (fino a oggi) | lettura trovata oggi | effetto |
|---|---|---|---|
| che cos'e' una "idea" | qualunque posizione entro 10 min nella stessa direzione | **stesso STRUMENTO + stessa DIREZIONE** | 🟢 **il pile-up di 8 sedie su 8 simboli DIVERSI NON e' una trade idea.** La riga "5,85% = hard breach" **non regge** |
| i 10 minuti | una finestra generica di raggruppamento | **entro 10 minuti dalla CHIUSURA DI UN TRADE IN PERDITA**, stesso strumento, stessa direzione | 🟡 e' la clausola anti-revenge, non un raggruppamento a orologio |
| il tetto | 2% (Master ≥25k) | **3% sotto 50k · 2% da 50k in su**, sulla size INIZIALE | 🟡 sul 100k il numero giusto e' **2%** |
| dove si applica | Master ≥25k | **solo Master. NON in evaluation, su nessun modello** | 🟢 le due fasi della challenge sono libere da questa regola |

**E adesso la parte che fa male.** Ho applicato la definizione **giusta** ai
nostri CSV. Gruppi = stesso simbolo, stessa direzione, con le due letture
(stretta: aperture entro 10 minuti l'una dall'altra; larga: anche il
concatenamento sulle posizioni ancora vive).

| conto | gruppi "stessa idea" con 2+ posizioni | peggior perdita combinata | in % del conto | contro il tetto |
|---|---:|---:|---:|---|
| piccolo (~5k) — lettura **stretta** | **62** | **−533,52** | **−10,67%** | tetto 3% → **sforato 3,5×** |
| piccolo (~5k) — lettura larga | 67 | −533,52 | −10,67% | idem (il caso peggiore e' lo stesso) |
| dry-run 100k (5 sedie) | **1** | −139,98 | −0,14% | tetto 2% → largo |

**Il caso peggiore, aperto riga per riga** (29/07/2026, D30EUR **short**):

| ora apertura | magic | sedia | volume | esito |
|---|---|---|---|---|
| 08:53:56 | 770311 | Apertura Marco SELL | 1,60 | sl −120,80 |
| 08:53:56 | 770101 | DAX Apertura EU SELL | 1,60 | sl −120,80 |
| 08:53:56 | 770101 | DAX Apertura EU SELL | 1,60 | sl −115,04 |
| 09:02:31 | 770103 | DAX Live 5m SELL | 2,30 | sl −118,91 |
| 09:02:32 | 770121 | DAX Live5m v2 SELL | 1,10 | sl −57,97 |

**Cinque posizioni, quattro magic, un simbolo, una direzione, nove minuti,
tutte stoppate.** Per FundingPips e' **UNA trade idea da −10,67%**.

E non e' archeologia: **il 13/08 sul dry-run 100k**, con solo 5 sedie a
bordo, `770611` ORB compra U30USD alle **15:05:18** e `770202` Dow Apertura
compra U30USD alle **15:06:04** — **46 secondi dopo, stesso simbolo, stessa
direzione**. Combinata −0,14%, innocua **oggi**. Ma il §3 del piano di
migrazione mette nella stessa finestra **anche `881531` EMA200 Dow**: tre
sedie, stesso simbolo, stessa direzione, stessi minuti.

> 🎯 **La conseguenza pratica, ed e' un ribaltamento utile:**
> **la mina non e' la DIVERSITA' del pile-up — quella e' innocua per questa
> regola. La mina e' la CONCENTRAZIONE per simbolo+direzione**, cioe' proprio
> il grappolo DAX delle 08:15 e il grappolo Dow delle 14:30. E si disinnesca
> con un tetto **per simbolo+lato**, non col cap globale. Il valore pronto
> ce l'ha E1: **max 2 posizioni per simbolo**.

---

## 4. 📰 BERSAGLIO 3 — FILTRO NEWS PER GLI ORDINI PENDENTI

### 4.1 La regola che rende il bersaglio urgente

FTMO, testuale `[LETTO-VIA-SEARCH]`: _"non e' permesso aprire o chiudere alcun
trade, **inclusa l'esecuzione di ordini pendenti**, nella finestra 2 minuti
prima / 2 minuti dopo"_, e: _"se un pendente (Buy Limit, Sell Limit, Buy Stop,
Sell Stop) viene attivato e apre un trade dentro la finestra, **conta come
esecuzione di un nuovo trade**"_.

> 🔴 **Tradotto per noi: uno STOP piazzato alle 08:15 e toccato alle 14:29:30
> dal salto dell'ISM e' una violazione, anche se l'EA e' andato a dormire ore
> prima.** Il filtro news su un EA a pendenti **non e' un filtro d'ingresso:
> deve CANCELLARE il pendente prima della finestra**. E' un meccanismo
> diverso, e questo e' il punto centrale del bersaglio 3.

### 4.2 Cosa abbiamo GIA' — e il difetto della catena

**Il filtro news esiste, e' scritto, ed e' piu' completo di due dei tre
esempi esterni.** Censimento fatto oggi sui sorgenti:

| voce | numero misurato |
|---|---|
| EA che piazzano STOP pendenti | **36** |
| di questi, senza NESSUN riferimento a news nel sorgente | **2** (`ABTG_CanaleLento`, `ABTG_OpeningReversalB`) — piu' `ABTG_PunteLarry`, che ha i pendenti e zero input news |
| EA con `InpUseNewsFilter` | **55** |
| default `InpUseNewsFilter = false` | **54 su 55** (uno solo parte acceso) |
| default `InpNewsBeforeMin` | **30** (38 EA) · **60** (15 EA) · 15 (1) |
| default `InpNewsAfterMin` | **30** (50 EA) · 60 (3) · 15 (1) |
| default `InpNewsMinImpact` | **3** (55 EA) = solo alto impatto |
| `InpNewsFlatten = true` (chiude posizioni **e cancella i pendenti**) | **16 EA** |
| `InpNewsCancelPendings` (input dedicato) | **1 EA** |
| `InpNewsCommon = true` (legge da `Common\Files`) | **2 EA** — tutti gli altri leggono dalla `Files` della singola istanza |

> ✅ **Nota di merito, misurata**: `ABTG_ORB.mq5` riga 153 fa
> `if(newsBlk && InpNewsFlatten){ CancelPendings(); ... }` — **la cancellazione
> dei pendenti nella finestra news e' gia' scritta e collaudata** in 16 EA. E
> `ABTG_FiboH4_Multi` ha perfino il guardrail giusto: logga
> `"[FIBOH4][NEWS] FILTRO ACCESO MA CIECO"` quando il file manca.
> **Non e' un buco di meccanismo. E' un buco di ALIMENTAZIONE.**

**🔴 IL DIFETTO, verificato sui file:**

1. `data/abtg_news.csv` — il file che il VPS scarica — **e' 0 BYTE**. Ultimo
   commit che lo tocca: **26/07/2026**.
2. `.github/workflows/news-export.yml` lo genera bene (feed Forex Factory
   `nfs.faireconomy.media`, settimana scorsa/corrente/prossima), ma il trigger
   e' **`workflow_dispatch` soltanto: nessuno `schedule`**. Nessuno l'ha
   lanciato: il file resta vuoto.
3. `backtest_pipeline/aggiorna_news.ps1` scarica quel file e lo copia in
   `MQL5\Files\abtg_news.csv`. **Oggi installerebbe un file vuoto.**
4. Il file che c'e' nel repo, `mql5/Files/abtg_news.csv`, ha **18 righe scritte
   a mano**: **nessun NFP e nessun CPI dopo marzo 2026.** Da aprile in poi il
   filtro sarebbe **cieco proprio sui due eventi che ci fanno male**.

> **Quindi: accendere `InpUseNewsFilter = true` domani mattina non
> proteggerebbe niente — e sarebbe peggio, perche' ci crederemmo protetti.**
> Prima si ripara la catena del CSV. Questo e' l'ordine giusto.

### 4.3 Gli esempi esterni per il filtro news — i valori

| # | esempio | fonte del calendario | valori dichiarati | cosa ne copiamo |
|---|---|---|---|---|
| **N1** | **News Filtering with MT5 Economic Calendar and CSV Fallback**, articolo 22580 · [link](https://www.mql5.com/en/articles/22580) | **doppia**: `CalendarEventByCountry()` dal vivo, **CSV nel tester**, scelta con `MQLInfoInteger(MQL_TESTER)` | `InpPreEventMins = 30` · `InpPostEventMins = 30` · `InpFilterHigh = true` · `InpFilterMedium = false` · CSV in **Common Files**, colonne `DateTime, EventName, Impact, Currency, CountryCode, Forecast, Previous, Actual` · ricerca del file a **3 priorita'** (nome esatto → `NewsCalendarLog_<Symbol>.csv` → `NewsCalendarLog_<Symbol>_*.csv`) · **riduzione taglia ×0,5** nei giorni ad alto impatto | ✅ **30/30 e impatto alto = identici ai nostri default.** Conferma indipendente che i nostri numeri sono quelli di mercato. 🥇 **`Common\Files`**: loro **sempre**, noi solo in 2 EA su 55. 🥈 **la riduzione ×0,5 invece del blocco secco**: mezza via che non abbiamo. ⚠️ E il limite dichiarato: _"il filtro non gestisce le posizioni aperte, blocca solo i nuovi ingressi; i pendenti non sono trattati"_ — **su questo NOI SIAMO AVANTI** (16 EA cancellano i pendenti) |
| **N2** | **MQL5 Economic Calendar (Part 4): Accurate Backtesting with Static Data**, articolo 22231 · [link](https://www.mql5.com/en/articles/22231) | script `ExportCalendarToCSV.mq5`: esporta il calendario del terminale | colonne `event_time,currency,importance,event_name`, formato `YYYY.MM.DD HH:MM:SS` · importanza **1/2/3** · `NewsMinutesBefore = 15`, `NewsMinutesAfter = 15` · file in `\Terminal\Common\Files\` | 🥇 **il metodo dell'ESPORTAZIONE dal terminale**: la strada per riempire il buco senza dipendere da un feed esterno. 🥈 formato colonne quasi identico al nostro (`data;impatto;valuta;titolo`). ⚠️ **una riga da NON copiare a occhi chiusi**: dice _"i tempi del CSV siano in UTC, MT5 internamente usa UTC"_. **Il nostro CSV storico e' UTC+2 e su BCM va tolta un'ora** (gia' agli atti in `PIANO_PROP` D1). **Il fuso e' l'errore piu' facile e piu' caro di tutto il bersaglio 3** |
| **N3** | limite noto dell'API | `CalendarValueHistory()` **muta nel tester**: nessuna connessione al server durante il replay. Trappola ulteriore: con `from` = ora corrente di simulazione restituisce solo eventi **futuri**, non quelli gia' passati nella simulazione | — | ✅ e' esattamente il motivo per cui casa nostra ha scelto il **CSV**. La scelta era giusta |

**Sui MINUTI da mettere, i numeri delle prop censite** (§3.1): FTMO Standard
**±2** · The5ers High Stakes **±2** · Alpha Pro **±2** · E8 funded **±5** ·
FundingPips Master **±5** (con l'esenzione delle 5 ore). **Il piu' severo e'
±5.** Il nostro default e' **30/30**: **sei volte piu' largo del necessario per
la conformita'** — cioe' non e' un parametro di conformita', e' un parametro di
STRATEGIA (evitare la volatilita'), e va misurato nell'imbuto come tale.

**La finestra da governare per prima** (gia' individuata in `PIANO_PROP` D1 e
qui confermata dai numeri delle prop): **16:00 ora italiana = 15:00 server**,
ISM/PMI/Michigan, con i trade Nasdaq/Dow **vivi da 15-30 minuti**. Un parziale,
un trailing o un breakeven che esegue li' e' una **chiusura** dentro la
finestra: violazione su FTMO Standard, E8 funded, Alpha Pro.

---

## 5. 📋 LE PROPOSTE — cosa / dove / costo / rischio

🔴 **Nessuna si applica da sola.** Vanno in lista, decide Claudio, e comunque
passano dall'imbuto come qualunque modifica.

```
PROPOSTA P0   TETTO PER SIMBOLO+DIREZIONE (max 2 posizioni), non solo il cap globale
DOVE          ABTG_PausaGuardian.mqh: nuova funzione di conteggio + argomento in coda a
              ABTG_GuardiaIngresso() con default 0 = spento (stessa tecnica gia' usata
              due volte per P1 e S1: le 65 chiamate esistenti restano valide riga per riga)
FONTE         E1 (RiskGate: "max 2 posizioni per simbolo") + la misura di casa del 3.3
              (62 gruppi, peggiore -10,67% su tetto 3%) + FundingPips RPTI
COSTO         ~3 ore di scrittura + 2 casi di autotest nuovi + 1 giro di ricompilazione
              della flotta (regola di casa: un EA per volta). Zero round di backtest:
              e' una guardia di ingresso, non cambia i segnali
RISCHIO       cambia la STRATEGIA se il tetto e' troppo stretto: il grappolo DAX delle
              08:15 e' fatto apposta di 3 sedie. A 2 se ne perde una -> serve il criterio 4
              (backtest identico) su un valore alto prima di stringere. Mitigazione:
              default 0 (spento), si accende una sedia per volta
PRIORITA'     1 -- e' l'unica proposta che tocca una regola HARD BREACH gia' violata dai
              nostri dati, e non e' coperta dal cap C1 in nessuna sua forma
STATO         🔨 COSTRUITO il 02/09 (cantiere P0, firma del 02/09 mattina).
              IN ATTESA DI: verificatore + round di ricompilazione.
```

### 🔨 P0 — STATO DEL CANTIERE (aggiornato 02/09)

**COSTRUITO, NON IN CAMPO.** La modifica vive in `mql5/Include/ABTG_PausaGuardian.mqh`
(v1.50) ed e' **inerte finche' non si ricompila**: i binari `.ex5` sul VPS non
cambiano di una virgola (vincolo D1 del verbale `report/FIRME_2026-09-02.md`).
Il forward NON e' stato toccato.

**Fase 1 — censimento dell'esistente (fatto PRIMA di scrivere).** Il tetto "A1"
(`InpMaxPosSimbolo`) **esisteva gia'**, copiato a mano e **identico byte per byte**
in **5 EA** della famiglia Aperture: `ABTG_DAX_Apertura_EU`, `ABTG_Dow_Apertura_US`,
`ABTG_Nasdaq_Apertura_US`, `ABTG_Apertura_3Ingressi` (default **0** = spento) e
`ABTG_Apertura_Marco` (default **1**, ma **EA RITIRATO**). Conta posizioni **+**
pendenti, su **tutti i magic** — quindi copre gia' due terzi del bersaglio.
**Quello che NON fa: non divide per LATO.** Conta il totale sul simbolo: con A1=1
un long e uno short sullo stesso simbolo — che su conto **hedging sono una
copertura, non un pile-up** — si bloccherebbero a vicenda.
**Conclusione del cantiere: P0 non duplica A1, lo estende** (stessa idea divisa
per lato) e lo sposta in **un posto solo**, disponibile a tutta la flotta invece
che ai 5 EA che ne hanno la copia. A1 resta dov'e': non e' stato toccato nessun EA.

**Fase 2 — cosa e' stato scritto.** Nucleo puro (`ABTG_LatoDaTipo_Calc`,
`ABTG_ContaSimboloLato_Calc`, `ABTG_TettoSimboloLatoRaggiunto_Calc`) + il filo che
legge il terminale (`ABTG_LeggiEsposizione`, `ABTG_ContaSimboloLato`,
`ABTG_TettoSimboloLato_Calc`). Conta **posizioni + pendenti** (il buco **B6** qui
**non** si ripete), **stesso simbolo**, **stesso lato**, **tutti i magic**.
Wiring: **3 argomenti in coda** a `ABTG_GuardiaIngresso` (`tetto=0`, `lato=0`,
`simbolo=""`). Compatibilita' **contata, non sperata**: **93 chiamate reali in 65
file**, tutte a 2 argomenti oggi — nessun EA cambia comportamento ne' va toccato
per compilare. **39 casi di autotest** nuovi, agganciati a `ABTG_AutotestGuardia()`
cosi' ogni EA che gia' lo chiama li eredita.

**Il log non collide.** Un blocco P0 scrive `INGRESSO RIFIUTATO`, **non**
`INGRESSO BLOCCATO --`: quest'ultima e' la sottostringa con cui il collaudo
(`backtest_pipeline/attese_enforcement_fase1.txt`) estrae il campo **C9.BLOCCO**
e pretende una riga `[GUARDIAN]` nello stesso minuto che lo spieghi. P0 non passa
dal Guardian e quella riga non puo' averla: con la stessa frase, il **criterio 9
avrebbe contato un "blocco orfano"** e segnalato un difetto inesistente.

**⚠️ COSA RESTA DA FARE — e il rischio gia' scritto sopra vale ancora.** Nessuna
sedia ha il tetto acceso e **il valore lo firma Claudio**. Il rischio dichiarato
nella scheda (il grappolo DAX delle 08:15 e' fatto **apposta** di 3 sedie: a 2 se
ne perde una) **non e' stato risolto dal codice, e' stato solo reso opt-in**:
prima di stringere serve il **criterio 4** (backtest identico) su un valore alto.
Il tetto conta le **TESTE, non il rischio**: cinque ordini da 0,01 contano cinque.

```
PROPOSTA P1   IL CAP C1 VEDE ANCHE GLI ORDINI PENDENTI
DOVE          ABTG_Guardian.mq5, OpenRiskPct() riga 153-181: aggiungere un secondo ciclo
              su OrdersTotal() con ORDER_PRICE_OPEN -> ORDER_SL, stesso LossIfStopHit().
              Input nuovo InpContaPendenti (default false = comportamento di oggi)
FONTE         buco B6 + nota M14 gia' agli atti + PIANO_MIGRAZIONE fase 3 ("Larry,
              pendenti: il cap non li vede - sorveglianza manuale")
COSTO         ~2 ore. La funzione di calcolo del rischio c'e' gia' e non va toccata:
              si riusa. + un caso di autotest
RISCHIO       il rischio "aperto" raddoppia contabilmente per gli EA a pendenti, e col
              cap a 3,25 la flotta potrebbe bloccarsi presto. Va misurato PRIMA sul
              dry-run in modalita' InpAction=1 (solo allarme), leggendo GV_RISKPCT per
              una settimana, e solo dopo si decide se alzare il cap o accendere il conteggio
PRIORITA'     2 -- senza questa, il cancello della fase 2 misura mezza flotta
```

```
PROPOSTA P2   RIPARARE LA CATENA DEL CALENDARIO NEWS (prima di accendere qualunque filtro)
DOVE          (a) .github/workflows/news-export.yml: aggiungere uno "schedule" cron
              giornaliero (oggi e' workflow_dispatch e basta);
              (b) far girare una volta il workflow per riempire data/abtg_news.csv (0 byte);
              (c) estendere agent/news_export.py oltre le 3 settimane del feed FF, o
              affiancare l'esportazione dal calendario del terminale (metodo N2);
              (d) portare tutti gli EA a InpNewsCommon = true (Common\Files), oggi 2 su 55;
              (e) scrivere il FUSO nel file e nel codice: CSV in UTC+2 -> su BCM -1 ora
FONTE         il difetto verificato al 4.2 + N1 (Common Files) + N2 (export) + D1 di PIANO_PROP
COSTO         ~4 ore in tutto, quasi tutte fuori da MQL5 (yml + python + un ps1).
              Zero rischio sul forward: nessun EA legge il file finche' il filtro e' spento
RISCHIO       il piu' insidioso e' il FUSO: un CSV con un'ora di scarto sposta la finestra
              su un'altra candela e il filtro diventa peggio che inutile. Cancello proposto:
              prima di dichiarare la catena riparata, si verifica su UN evento noto
              (es. un NFP passato) che l'ora nel file coincida con la candela vera sul grafico
PRIORITA'     3 -- e' il prerequisito di P3, e da sola non protegge nulla. Ma senza,
              tutto il bersaglio 3 e' teatro
```

```
PROPOSTA P3   CANCELLAZIONE DEI PENDENTI PRIMA DELLA FINESTRA NEWS, come regola di casa
DOVE          i 16 EA che hanno gia' InpNewsFlatten (il codice c'e': ABTG_ORB riga 153
              CancelPendings()); + i 3 scoperti (ABTG_PunteLarry, ABTG_CanaleLento,
              ABTG_OpeningReversalB) dove l'input news non esiste proprio
FONTE         la riga FTMO testuale del 4.1 ("inclusa l'esecuzione di ordini pendenti";
              "se un pendente si attiva dentro la finestra conta come nuovo trade")
COSTO         sui 16: ZERO codice, e' una decisione sui VALORI (accendere il filtro e con
              che minuti). Sui 3 scoperti: ~2 ore ciascuno per portare l'input news
              standard di casa, + il criterio 4 (backtest identico a filtro spento)
RISCHIO       accendere il filtro CAMBIA la strategia: 30/30 su impatto 3 toglie trade
              veri. Per questo va nell'imbuto come una modifica qualunque.
              Proposta di valori, in due gradini distinti da non confondere:
                CONFORMITA' (il minimo che serve): 5/5 minuti, impatto 3, sola valuta
                  del simbolo -> copre la piu' severa delle 5 prop censite;
                STRATEGIA (evitare la volatilita'): 30/30, il nostro default -> e' una
                  scommessa, e va MISURATA, non accesa
PRIORITA'     4 -- subordinata a P2. Non si accende un filtro su un file vuoto
```

```
PROPOSTA P4   RETE DI SICUREZZA OnTradeTransaction NEL GUARDIAN
DOVE          ABTG_Guardian.mq5: gestore OnTradeTransaction che, quando GV_BLOCKDAY o
              GV_FAILED sono attive, chiude la posizione appena aperta da CHIUNQUE
FONTE         E3 (CodeBase 69430) -- buco B8
COSTO         ~3 ore + un collaudo dedicato sul dry-run (aprire una posizione a mano
              con la bandiera alzata e vedere se sparisce)
RISCHIO       ALTO, e va detto: e' l'unico meccanismo del dossier che CHIUDE senza che
              un EA abbia chiesto niente. Un bug qui chiude trade buoni. Da NON toccare
              finche' i criteri 5-9 non sono verdi
PRIORITA'     6 -- e' il completamento, non l'inizio
```

```
PROPOSTA P5   IL PALETTO DELLA TENUTA MINIMA NEL CANCELLO H8
DOVE          report/PIANO_PROP.md, riga H8 (cancello alta frequenza): aggiungere una
              terza condizione accanto a E >= 0,075R e DD <= 15% e n >= 150
FONTE         3.1 (E8: max 50% dei trade sotto 1 minuto -- l'unica soglia numerica
              esistente) + 3.2 (la misura di casa: siamo al 4,6%)
COSTO         ZERO codice. E' una riga di criterio, piu' due colonne nella pagella
              (% trade sotto 60 s, mediana di tenuta) -- lo script di misura e' gia'
              scritto e girato stasera
RISCHIO       nessuno tecnico. Il rischio e' l'opposto: NON scriverlo e scoprire a
              challenge comprata che un motore M1 promosso tiene i trade 40 secondi
FORMULA       "un motore ad alta frequenza entra in flotta solo se, oltre a E >= 0,075R,
               tiene MENO DEL 25% dei propri trade sotto i 60 secondi"
               (25% = meta' del tetto E8, margine di casa)
PRIORITA'     5 -- costa zero e chiude una mina dichiarata [INCERTO] da settimane
```

```
PROPOSTA P6   PRENOTAZIONE ATOMICA DEL RISCHIO (il buco dei gemelli)
DOVE          ABTG_PausaGuardian.mqh: prima di OrderSend l'EA PRENOTA il rischio del
              proprio ordine con GlobalVariableSetOnCondition() (atomica); il Guardian
              scala le prenotazioni scadute a ogni giro di timer
FONTE         E1 (il modello "chiedi il permesso, non leggere la bandiera") + il forum
              MQL5 sulle race condition -- buco B7
COSTO         ALTO: ~2 giorni + un protocollo nuovo da collaudare (prenotazioni orfane,
              EA che muore fra prenotazione e invio, ordini rifiutati dal broker)
RISCHIO       ALTO. Una prenotazione che non viene mai rilasciata BLOCCA la flotta:
              e' il difetto peggiore possibile (criterio 8 del collaudo esiste apposta)
PRIORITA'     7 -- da NON fare adesso. Si mette in lista perche' e' la risposta giusta
              al problema dei gemelli, e perche' P0 (max 2 per simbolo) lo rende
              MOLTO meno urgente: il tetto per simbolo ferma lo stesso grappolo,
              con un centesimo del rischio implementativo
```

### 5.1 L'ordine che raccomando (dichiarato come raccomandazione, decide Claudio)

| ordine | proposta | costo | perche' proprio questa |
|---|---|---|---|
| 1 | **P0** tetto per simbolo+lato | 3 h | l'unica che tocca una regola **gia' violata dai nostri dati** (−10,67% su tetto 3%) e che il cap C1 **non copre in nessuna forma** |
| 2 | **P5** paletto tenuta in H8 | 0 h | costo zero, chiude M28 con un numero |
| 3 | **P1** cap vede i pendenti | 2 h | senza, il cancello della fase 2 misura mezza flotta |
| 4 | **P2** riparare la catena news | 4 h | fuori da MQL5, rischio zero sul forward |
| 5 | **P3** cancellazione pendenti su news | valori | subordinata a P2 |
| 6 | **P4** `OnTradeTransaction` | 3 h + collaudo | solo a criteri 5-9 verdi |
| 7 | **P6** prenotazione atomica | 2 gg | in lista, non ora |

---

## 6. 🕳️ COSA NON HO POTUTO VEDERE — dichiarato

1. **Nessun sito ufficiale di prop.** ftmo.com, help.fundingpips.com,
   help.e8markets.com, fundingpips.com: tutti `EGRESS_BLOCKED` dal proxy di
   rete (403 di policy, **non si aggirano**). **Tutto il §3 e'
   `[LETTO-VIA-SEARCH]`.** Le due righe che cambiano decisioni — la RPTI di
   FundingPips e il 50%/1-minuto di E8 — **vanno rilette sul sito prima di
   comprare qualunque challenge**, e la domanda al supporto (M28/E1) resta da
   inviare.
2. **Il sorgente di E3** (CodeBase 69430), l'unico esempio con la rete di
   sicurezza `OnTradeTransaction`: la pagina oggi dice _"The code has been
   removed"_. Il meccanismo e' descritto, il codice non e' piu' leggibile.
3. **Nessuna stampa di settore**: earnforex, tradingfinder, fortraders,
   quantvps, alfatactix, proptradingvibes — tutti bloccati. Niente tabelle
   comparative di terze parti da incrociare.
4. **Ricerca web su github.com**: 429 con `Retry-After: 3600`. Aggirata via
   `api.github.com`, ma la ricerca di **codice** su GitHub chiede
   autenticazione (401): **non ho potuto cercare dentro i sorgenti MQL5 di
   GitHub**, solo nei nomi e nelle descrizioni dei repo.
5. **Nessun `.set` pubblico di EA prop-ready** trovato in questo giro: i
   valori del §2.2 vengono da pannelli input, articoli e manuali, non da
   preset scaricati. Resta una caccia aperta.
6. **La regola di consistenza di Alpha (40%)** e' `[INCERTO]`: una sola fonte.
7. **La soglia FTMO "sotto i 2 minuti"** e' `[INCERTO]`: non e' chiaro se sia
   segnalazione o violazione. Non ci tocca (mediana 224,7 min), ma non e'
   confermata.

---

## 7. 🧾 IL VERDETTO ONESTO, in tre righe

1. **Sul bersaglio 1 il nostro Guardian e' migliore di 8 esempi esterni su
   11.** Non ci mancano meccanismi di base: ci mancano **due dettagli che
   mordono davvero** (i pendenti invisibili al cap, il tetto per
   simbolo+lato) e **manca il collaudo in campo**, non il codice.
2. **Sul bersaglio 2 la mina e' disinnescata da un numero**: 4,6% contro un
   tetto del 50%. La filosofia nuova e' legale ovunque, col paletto P5.
3. **Sul bersaglio 3 non ci manca il meccanismo, ci manca il file**: il filtro
   e' scritto in 55 EA e cancella pure i pendenti in 16, ma il calendario che
   dovrebbe alimentarlo e' **0 byte dal 26 luglio**.

_E la cosa piu' importante che ho trovato non era in nessuno dei tre bersagli:
la lettura sbagliata della Risk Per Trade Idea. Il piano di migrazione va
corretto in due punti (§3, tabella delle mine), e la correzione **allarga** il
permesso sul pile-up eterogeneo mentre **stringe** — molto — su DAX e Dow._

---

_Compilato il 31/08/2026. Fonti aperte davvero: mql5.com (Market, CodeBase,
Articoli, Forum), api.github.com. Fonti dichiarate NULLE: §1. Misure di casa
calcolate stasera su `data/statements/trades_auto.csv` (581 trade automatici)
e `trades_100k.csv` (22), e sui sorgenti in `mql5/Experts/` e
`mql5/Include/ABTG_PausaGuardian.mqh`. **Nessun EA, preset, grafico o
parametro toccato.**_
