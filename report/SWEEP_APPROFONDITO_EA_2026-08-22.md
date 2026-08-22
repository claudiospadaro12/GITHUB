# 🔎 SWEEP APPROFONDITO — caccia setacciata a EA, parametri e meccanismi (22/08/2026)

_Scritto il **22/08/2026**. Ogni pagina citata e' stata **aperta davvero in
questa sessione**; la data di lettura e' **22/08/2026** salvo diversa
indicazione. Ogni numero che viene da fuori e' etichettato **[DICHIARATO
DAL VENDITORE, NON MISURATO DA NOI]**; i numeri prodotti dalle statistiche
automatiche di MQL5 sono **[MQL5, dato di piattaforma]** (piu' forti: li
calcola la piattaforma sui deal reali, non il venditore)._

**Mandato di Claudio**: _"L'obbiettivo e' trovare qualsiasi EA o parametri che
ci possono servire sia x prop che x conto demo piccolo, grande o un motore che
secondo te puo' essere di spunto. Facciamola meglio che si puo' questa
ricerca."_ — ricerca **esaustiva e setacciata**, non il primo risultato
plausibile.

🔒 **NON e' stato toccato nulla**: nessun EA nostro, nessun parametro in
forward, nessun file di R97, nessun file del Guardian, `PIANO_PROP.md`
**intatto** (le proposte del §6 sono SEGNALATE, non scritte).

---

> # 🎯 LA RIGA CHE CONTA
>
> **Ho censito 2.046 prodotti del Market MQL5 e 955 voci del Code Base, e ho
> aperto ~130 pagine/artefatti. Su 5 categorie il risultato e' asimmetrico e
> va detto cosi': sui MOTORI il web mi ha dato UN solo candidato che merita il
> gradino 3 (Gold Phantom, e ce l'avevamo gia' in biblioteca dal 18/08); sui
> FRENI del Guardian mi ha dato una miniera — 4 sorgenti gratuiti letti riga
> per riga e 8 meccanismi che ci mancano davvero.**
>
> **E il reperto piu' pesante e' NEGATIVO, e riguarda esattamente il buco
> Nasdaq: "The ORB Master" di Profalgo — il venditore piu' credibile del
> Market su questa famiglia (20 anni di mestiere, 27 prodotti, 998 recensioni
> venditore, 29 signal reali) — ha un signal LIVE del suo stesso ORB su
> SP500/US30/NASDAQ/DAX che dopo 47 settimane e 1.343 operazioni fa
> PF 0,89, Sharpe −0,02, e i QUATTRO indici sono TUTTI in perdita
> (DE40 −173, USTEC −170, US30 −337, US500 −261 USD).**
> _[MQL5, dato di piattaforma — signal 2336314, letto il 22/08/2026]_

---

## 🔴 LE DUE COSE URGENTI, IN CIMA COME CHIESTO

### 1. Il buco JPY (punto C) — **il web NON ce l'ha, e adesso e' misurato**

**Su 2.046 prodotti del Market, i prodotti che dichiarano un cross JPY come
mercato principale sono OTTO. Su tutto il Market. E di questi, quelli
dedicati a USDJPY con un signal reale sono DUE.** Il gold ne ha 256.

| il fatto | il numero |
|---|---|
| prodotti Market censiti | **2.046** |
| che nominano oro/XAU nel TITOLO | **256** |
| che nominano JPY/yen/Nikkei/Tokyo in titolo o descrizione | **8** |
| dedicati a USDJPY con signal MQL5 pubblico | **2** (Market Anomalies, Zen Eagle) |

I due, entrambi **[MQL5, dato di piattaforma]**:

| | **Market Anomalies EA** (Eriksson) | **Zen Eagle** (traderjes) |
|---|---|---|
| signal | [2342700](https://www.mql5.com/en/signals/2342700) | [2364778](https://www.mql5.com/en/signals/2364778) |
| settimane / operazioni | **41 / 571** | **23 / 484** |
| PF | **1,17** | **1,39** |
| DD relativo su SALDO | **24,68%** | **24,65%** |
| DD relativo su EQUITY | 5,56% | 9,31% |
| perdite consecutive max | **13** | **11** |
| conto del venditore | 500 USD | 300 EUR |
| meccanismo | breakout intraday + pattern | **8 breakout** |
| verdetto | 🟠 **BLOCCATO dal fuso** (§4.3) | 🔴 **SCARTO: e' il motore morto** |

🎯 **Ma il pezzo che vale davvero per Claudio e' questo, ed e' contro-corrente
rispetto a quello che scriviamo da giorni:**

> **Zen Eagle e' un breakout puro su USDJPY, 8 strutture diverse in parallelo,
> e in 484 operazioni live fa PF 1,39.** Il nostro R82 ha bocciato il breakout
> sui cross JPY con 0 vincitori su 7 e PF 0,769-0,980. **Le due cose non si
> contraddicono: R82 ha bocciato UN breakout (rettangolo 20 candele M15 +
> Williams 140 + SuperTrend), non IL breakout.**
> ⚠️ Con tutte le cautele che pesano: 23 settimane = **un solo regime**, 300
> EUR = **non e' una taglia vera**, ed e' il conto del venditore, cioe' la
> vetrina. **Non e' una prova che il breakout JPY paghi. E' la prova che la
> nostra frase "il breakout JPY e' morto" e' piu' larga di quello che abbiamo
> misurato**, e che la regola della seconda caccia va applicata alla lettera:
> _meccanismo diverso_, non _famiglia diversa_.

📌 **Il candidato numero uno sul JPY resta quello di casa** — `ABTG_LiquiditySweep`
portato sui cross JPY con struttura piu' corta (`CACCIA_JPY_MECCANISMI_2026-08-21.md`
§3, 10/10, **zero ore di sviluppo**). **Niente di quello che ho trovato oggi
sul web lo batte.** E questa e' una risposta, non una resa: 2.046 prodotti
guardati e il migliore ce l'abbiamo gia' scritto in casa.

📌 **E una nota sul Nikkei che tocca una sedia VIVA** (§4.6): l'autore del
codice da cui viene la nostra `ABTG_GapContinuation` (sedia 774101, 225JPY)
ha pubblicato **5 prodotti in 65 giorni** e promuove in un blog un EA
"Kuro225" come **gia' sul Market** — che sulla sua pagina venditore, oggi,
**non c'e'**.

### 2. I freni del Guardian (punto E) — **qui il raccolto e' grosso**

Ho letto **riga per riga 4 guardiani gratuiti col sorgente** e le schede di
**30 utility a pagamento**. **Otto meccanismi ci mancano davvero**, e tre
compaiono in **fonti indipendenti con lo stesso numero**:

| convergenza indipendente | dove l'ho letta | il nostro valore |
|---|---|---|
| **cap giornaliero interno 4,5%** contro muro 5% | `PropFirmHelper` (`DAILY_LOSS_LIMIT=4500` su 100k) · `Prop Firm Protector EZ` (4,5%) · blog MQL5 767611 ("3,5-4%") | **4,9%** (emergenza) — cioe' **lasciamo 0,1% di margine dove il campo ne lascia 0,5-1,5** |
| **stop a target raggiunto: +10,1%** | `PropFirmHelper` (`PASS_CRITERIA=110100`) · `Prop Firm Protector EZ` (10,1% fase 1 / 5,1% fase 2) | 🔴 **NON ESISTE**: il nostro Guardian non sa che la challenge e' finita |
| **freno a 80% del limite**, non a % assoluta | `EquityGuardPanel` (`InpTriggerPct=80`) · `ASQ RiskGuard` (`InpWarningPct=80`) | pausa 4,0 = 80% di 5,0 ✅ **stesso posto, ma scritto come numero fisso** |

---

## 0. ✅ CONTROLLO POSITIVO DELLE FONTI — fatto PRIMA di cercare

| canale | bersaglio noto | esito |
|---|---|---|
| **MQL5 Market** (curl) | pagina 111837 gia' letta il 22/08 deve tornare l'HTML pieno | ✅ **200** |
| **MQL5 Market** (WebFetch) | listato experts deve rendere nomi/autori/prezzi | ✅ contenuti veri |
| **MQL5 Signals** — liste autore e schede | statistiche integrali | ✅ **200**, 11 liste + 9 schede lette |
| **MQL5 Code Base** — listati e **download ZIP del sorgente** | `/en/code/download/<id>` deve dare il `.mq5` | ✅ **200**, **5 sorgenti scaricati e letti** |
| **MQL5 blogs / forum** | post 773070 e thread 513338 | ✅ **200** |
| **WebSearch** (motore generale) | regole FTMO 5%/10% | ✅ risponde con contenuti veri |
| **GitHub — `git clone`** ⭐ | clone di un repo pubblico | ✅ **FUNZIONA** (novita' rispetto al 21/08) — 3 repo clonati |
| **GitHub — `raw.githubusercontent.com`** | README | ✅ 200 |
| **GitHub — `/search`, `/topics`, `api.github.com`, `codeload`** | ricerca repo | ❌ **403** — repo trovati solo di rimbalzo da WebSearch |
| **Forex Factory** | homepage | ❌ **403** 🛑 FONTE NULLA |
| **Reddit** (`www.reddit.com`) | r/algotrading | ❌ **403 al CONNECT** 🛑 FONTE NULLA |
| **Myfxbook** | homepage | ❌ **403 al CONNECT** 🛑 FONTE NULLA |
| **web.archive.org** | snapshot storici | ❌ **403 al CONNECT** 🛑 FONTE NULLA |
| **ftmo.com** e siti prop | pagine regole | ❌ EGRESS_BLOCKED (confermato dal 21/08) 🛑 |

⚠️ **404 ≠ 503**: nessuna fonte e' stata dichiarata nulla per un errore
temporaneo. I 403 sopra sono **rifiuti del proxy al CONNECT**, verificati con
`curl -sS "$HTTPS_PROXY/__agentproxy/status"` (tre `connect_rejected`
registrati alle 06:22 di oggi).

### 🔴 Cosa NON ho potuto vedere, e va dichiarato

1. **Forex Factory, Reddit e Myfxbook**: cioe' **tutte e tre le fonti dove si
   legge come la gente FALLISCE davvero le challenge** e dove si trovano le
   recensioni non manipolabili. Il punto **F del mandato e' coperto solo
   parzialmente**: GitHub si' (clone funzionante), forum/reddit **no**.
   Le poche informazioni di quel mondo che riporto sono **[LETTO-VIA-SEARCH]**:
   snippet restituiti dal motore, **non pagine che ho aperto io**.
2. **Le tab "Reviews" complete** dei prodotti: sono caricate in JavaScript.
   Ho i **conteggi** e i testi che finiscono nell'HTML, non tutte le 54.
3. **Il changelog** del `Nikkei225 Gap ContinuationEA` sul Market: la tab
   `/updates` esiste ma **non elenca versioni** → non so se la v1.50 del
   Market corregge qualcosa rispetto al sorgente Code Base che abbiamo
   adottato. **[INCERTO]** — e tocca una sedia viva (§4.6).

### 📏 La copertura, in numeri

| cosa | quanto |
|---|---|
| pagine di listato Market sfogliate | **32** (12 experts + 12 utility + 8 free) → **2.046 prodotti unici** |
| pagine di listato Code Base sfogliate | **24** → **955 voci uniche** |
| schede prodotto Market aperte per intero | **66** |
| liste signal per autore aperte | **11** |
| schede signal singole aperte | **9** |
| sorgenti `.mq5` **scaricati e letti** | **5** (Code Base) |
| repository GitHub **clonati e letti** | **3** |
| blog / thread MQL5 aperti | **4** |
| interrogazioni WebSearch | **8** |
| **totale artefatti aperti** | **~130** |

**Le query usate** (letterali): `prop firm` · `USDJPY mean reversion expert
advisor MQL5 signal verified track record not breakout` · `github prop firm
risk management EA MT5 daily drawdown guard open source mq5` · `"github.com"
MQL5 EA repository "FTMO" OR "prop firm" equity guard kill switch mq5 source`
· `github mql5 news filter expert advisor economic calendar MqlCalendarValue
no DLL source code` · `site:mql5.com market expert advisor USDJPY OR "JPY
pairs" 2026 "live signal" no martingale prop firm` · `Nikkei 225 JP225 expert
advisor MT5 strategy gap overnight mean reversion` · `reddit r/algotrading
prop firm EA MQL5 market scam what actually works funded account experience
2026` · `github MQL5 "Expert Advisor" repository stars ORB opening range
breakout index DAX Nasdaq backtest source mq5 2026` · `github "prop firm" MT5
EA repository "daily loss" "kill switch" mq5 EquityGuard OR PropGuard OR
SafetyPack` · `"Kuro225" mql5 expert advisor Nikkei 225 Mallol Nolden`.
**Filtri applicati sui 2.046**: `prop|ftmo|funded|challenge` (61 hit) ·
`jpy|yen|nikkei|tokyo|jp225` (8) · `nasdaq|nas100|us30|dow|dax|index` (40
titoli) · `gold|xau|bullion` (256 titoli) ·
`risk|drawdown|protect|equity|guard|news|manager|panic|lock` (525).

---

## 1. 📊 TABELLA DI TUTTI I CANDIDATI, CON VERDETTO

Legenda: 🔴 scartato al volo · 🟠 scartato dopo verifica · 🟢 **MERITA il
gradino 3** (demo nel tester) · ⚪ evidenza, non candidato.

### A. Indici in apertura sessione

| # | prodotto | autore / URL | prezzo | verdetto | motivo in una riga |
|---|---|---|---|---|---|
| A1 | **The ORB Master** | Profalgo Limited · [150079](https://www.mql5.com/en/market/product/150079) | 499 USD (nol. 199/mese) | ⚪ **EVIDENZA, non candidato** | il signal LIVE del venditore sul suo stesso ORB: **PF 0,89 su 1.343 op, tutti e 4 gli indici in perdita** (§3.1) |
| A2 | Viking Alpha DAX Ivar Edition | Valdeci C. Albuquerque | 299,90 USD | 🔴 al volo | tracciamento su **FX Blue**, non su signal MQL5 → nessun dato di piattaforma verificabile; lancio a copie limitate |
| A3 | DAX Robot MT5 | mqlblue · 135313 | 1.199 USD | 🔴 al volo | pubblicato **26/06/2026**, 3 recensioni, autore senza signal leggibili; prezzo 1.199 su 2 mesi di vita |
| A4 | AI Prop Firms MT5 | mqlblue · 107706 | 1.099 USD | 🔴 al volo | stesso venditore di A3, **"AI"** nel nome = il buzzword che due venditori seri del Market indicano come bandiera rossa |
| A5 | US30 Matrix Escape | dannyclay · 170913 | 120 USD | 🔴 al volo | **0 recensioni**, 34 demo scaricate, apr 2026, nessun signal |
| A6 | The US30 Market Maker | njtrading · 104750 | 79 USD | 🟠 dopo verifica | il piu' vecchio del gruppo (set 2023, 8 recensioni) ma **nessun signal dell'autore**: niente test del punto 4 |
| A7 | Nasdaq Super Scalper MT5 | yudisriwarsito · 122581 | 30 USD | 🔴 al volo | stesso autore del **Master Nasdaq gia' scartato**: **0 signal** (verificato il 22/08) |
| A8 | Nasdaq 100 Ultra mt5 | humming_bird · 176605 | nol. 30/mese | 🔴 al volo | 0 recensioni, **14 demo**, mag 2026 |
| A9 | Index Cadence TechnoTrader | aller.techno · 190845 | 149 USD | 🔴 al volo | pubblicato **15/08/2026 (7 giorni fa)**, 0 recensioni, **7 demo** |
| A10 | Apex Drawdown Zero | mbedzimz1 · 163054 | 999 USD | 🔴 al volo | nome che promette drawdown zero a 999 USD, **0 recensioni**, nessun signal |
| A11 | `yulz008/GOLD_ORB` (GitHub) | 188 stelle · ultimo commit **29/07/2023** | gratis | ⚪ **IDEA, non candidato** | progetto didattico morto da 3 anni — **ma il meccanismo del "candle composition" e' spunto vero** (§5.3) |

### B. Oro (XAUUSD)

| # | prodotto | autore / URL | prezzo | verdetto | motivo |
|---|---|---|---|---|---|
| B1 | **The Gold Phantom** | Profalgo Limited · [161561](https://www.mql5.com/en/market/product/161561) | 649 USD · **nol. 349/3 mesi** | 🟢 **GRADINO 3** | **l'UNICO signal oro di tutto lo sweep che sta dentro il muro del 10%**: DD max **8,56%** su 31 settimane e 436 op, PF 1,34, **zero ricariche** (§3.2). Scheda gia' in biblioteca dal 18/08 |
| B2 | The Gold Reaper MT5 | Profalgo · 111357 | 949 USD | 🟠 dopo verifica | **il track record piu' lungo dello sweep**: 133 settimane, 1.300 op, PF 1,78 — ma **DD sul saldo 45,64%** = 4,5 volte il muro |
| B3 | Gold Atlas | jimmy282 · 159658 | 449 USD | 🟠 dopo verifica | signal 36 settimane, PF 1,17, **DD 16%** — ma **stesso blocco di fuso** di tutti gli Eriksson (GMT+2/+3, §4.3) |
| B4 | Prop Firm Gold EA | jimmy282 · 153540 | 399 USD | ⚪ **gia' scartato** il 21/08 (`report/PROPFIRM_GOLD_ERIKSSON_2026-08-21.md`) — riverificato: **e' lo stesso prodotto** della scheda `PropFirmGoldEA_manuale_...md` in biblioteca |
| B5 | Smart Gold Hunter / Impulse | barbarosbulent · 170050 / 183038 | 299 / 149 USD | 🟠 dopo verifica | 5 signal, ma **il piu' vecchio e' di 25 settimane** e le DD vanno da 4% a 17%: campione troppo giovane |
| B6 | Aura Gold Pro / Vortex | stanislav110685 · 184335 / 126409 | 400 USD | 🟠 dopo verifica | 18 signal, **DD 19-73%**, e un signal a **PF 0,98 su 67 settimane** (AuraBlackEdition NR) |
| B7 | Gold Snap / Gold House | walter2008 · 172673 / 165036 | 999 USD | 🟠 dopo verifica | 9 signal, DD 6-65%, **il piu' vecchio 29 settimane**, uno a **PF 0,83** |
| B8 | GoldEdge Spark / GoldEdge US30 | Chi Sang Lai · 187088 | 349 USD | ⚪ **gia' scartato** stanotte (`report/GOLDEDGE_SPARK5_2026-08-22.md`, DD 79,98%) |
| B9 | altri **248 titoli** con "gold/xau" | — | — | 🔴 al volo | filtro applicato: **nessun signal MQL5 dell'autore** oppure **DD del signal > 20%** oppure prodotto piu' giovane di 6 mesi |

### C. JPY pairs / Nikkei — **la categoria prioritaria**

| # | prodotto | autore / URL | prezzo | verdetto | motivo |
|---|---|---|---|---|---|
| C1 | **Market Anomalies EA** | jimmy282 · [155039](https://www.mql5.com/en/market/product/155039) | 349 USD | 🟠 **scartato dopo verifica** | USDJPY esclusivo, signal 41 sett / 571 op / **PF 1,17** — ma **richiede broker GMT+2/GMT+3 e BCM e' GMT+1**, e nessun input di offset dichiarato (§4.3) |
| C2 | Zen Eagle | traderjes · 169432 | 298 USD | 🔴 **scarto per regola di casa** | e' **breakout su USDJPY** = famiglia del motore morto (R82). ⚪ **tenuto come EVIDENZA**: PF 1,39 su 484 op (§4.4) |
| C3 | Fuji Wave X | michael4308 · 190402 | 100 USD | 🔴 al volo | descrizione = **insalata di parole chiave SEO** senza un solo meccanismo; **nessun input di rischio %**, solo "adjustable lot-size"; pubblicato 13/08/2026, 0 recensioni |
| C4 | FXChronos | prizmal · 128825 | 299 USD | 🔴 al volo | JPY solo citato fra i simboli, 2 recensioni, nessun signal dedicato |
| C5 | Atlas Diversified Trend Portfolio | app.develop.sk · 182751 | 99 USD | 🔴 al volo | 0 recensioni, giu 2026 |
| C6 | Cyber Pulse | marcobrugali · 112509 | — | 🟠 dopo verifica | 31 recensioni (buon campione) ma **JPY e' marginale**, non e' un EA JPY |
| C7 | `Nikkei225 Gap ContinuationEA` (Market, v1.50) | mauriykiku · [187414](https://www.mql5.com/en/market/product/187414) | **GRATIS** | ⚪ **CI RIGUARDA GIA'** | e' la versione Market del codice da cui viene la nostra sedia **774101**. Changelog vuoto → **[INCERTO]** se corregge qualcosa (§4.6) |
| C8 | "Kuro225" | promosso nel blog [773070](https://www.mql5.com/en/blogs/post/773070) del 23/07/2026 come *"on the MQL5 Market"* | — | 🔴 **NON ESISTE sulla pagina venditore** | la pagina `mauriykiku/seller`, letta oggi, elenca **5 prodotti** e Kuro225 **non c'e'**. Bandiera rossa sull'autore (§4.6) |

### D. EA "prop firm" generici, ordinati per **tempo di signal**, non per pubblicita'

| # | prodotto | autore | prezzo | signal dell'autore | verdetto |
|---|---|---|---|---|---|
| D1 | **HFT PropFirm EA MT5** | rodeong (Dilwyn Tng) · 117386 | 200 USD | **15 signal — e NESSUNO su questo EA**; i suoi signal sono tutti scalper oro di **2-17 settimane** | 🟠 **scartato dopo verifica**: 91 recensioni e 7.770 demo, ma **zero track record del prodotto** + categoria **HFT** che le prop bandiscono per definizione (latency arbitrage) |
| D2 | POBE Prop Firm | rodeong · 159220 | 408 USD | idem, nessun signal del prodotto | 🟠 dopo verifica |
| D3 | Easy Funded MT5 | barbarosbulent · 116600 | 100 USD | 5 signal, **tutti oro**, nessuno su questo EA | 🟠 dopo verifica: 55 recensioni ma prodotto **senza signal** |
| D4 | FundedBridge EA for Prop Firms | riccardoborello01 · 152873 | 499 USD | **nessun signal leggibile** | 🔴 al volo (3 recensioni) |
| D5 | SwiftCap Trinity EA MT5 | swiftcapeas · 172725 | 599 USD | 2 signal | 🔴 al volo (0 recensioni, apr 2026) |
| D6 | PropGuardian Pro / Prop Guardian EA | 189710 / 187591 | 149 / 249 USD | 2 / 0 signal | 🔴 al volo (pubblicati **lug-ago 2026**, 1 recensione ciascuno) |
| D7 | AI Prop Runner Gold · Golden Mawzoo · Funded Gold | 152119 / 184446 / 185088 | 399 / 299 / 497 USD | nessuno | 🔴 al volo (0-1 recensioni, tutti **giugno-luglio 2026**) |
| D8 | Adam FTMO MT5 | snapea · 113326 | 2.700 USD | — | 🔴 al volo: si autodichiara *"Our 1st EA created using **ChatGPT** technology"* a **2.700 USD**. ⚪ **Ma una riga di config e' oro** (§5.2) |
| D9 | S7 v55 Prop Firm · HFT slow EA · HFT Passing Prop EA | 190537 / 121883 / 119633 | gratis / gratis / 39 USD | — | 🔴 al volo: famiglia **HFT/passing** = la categoria bandita |

### E. Guardiani e addon di risk management — **la categoria che ha reso**

| # | strumento | fonte | prezzo | verdetto |
|---|---|---|---|---|
| **E1** | **`Equity Guard — Daily Loss Limit Guardian with Panic Panel`** | [Code Base 73870](https://www.mql5.com/en/code/73870) — **sorgente 1.082 righe, scaricato e letto** | **GRATIS** | 🟢 **DA SPOGLIARE** (§3.3) |
| **E2** | **`ASQ RiskGuard Professional Risk Management EA`** | [Code Base 71120](https://www.mql5.com/en/code/71120) — **sorgente 1.063 righe, letto** | **GRATIS** | 🟢 **DA SPOGLIARE** (§3.4) — il piu' completo dei quattro |
| **E3** | `PropGuard MT5 Dead-Line Visualizer` | [Code Base 68087](https://www.mql5.com/en/code/68087) — **sorgente 706 righe, letto** | GRATIS | 🟢 **UN'IDEA SOLA, ma bella** (§5.1) |
| E4 | `Breakout Strategy with Prop Firm Helper Functions` | [Code Base 49713](https://www.mql5.com/en/code/49713) — sorgente 373 righe, letto | GRATIS | ⚪ **valori copiabili**: `PASS_CRITERIA=110100`, `DAILY_LOSS_LIMIT=4500` |
| E5 | `Prop Firm Risk Dashboard` | [Code Base 74553](https://www.mql5.com/en/code/74553) — sorgente 201 righe, letto | GRATIS | ⚪ **soglie a due stadi**: warning 60%, danger 85% |
| E6 | `Economic Calendar Monitor and Cache for Backtesting on History` | [Code Base 53393](https://www.mql5.com/en/code/53393) | GRATIS | 🟢 **SEGNALATO all'altro dossier**: e' l'implementazione pronta del rimedio gia' identificato in `DOSSIER_NEWS_FILTER_2026-08-21.md` §1B (calendario nativo **non disponibile nel tester**) |
| E7 | **EmoGuardian** | Market [101255](https://www.mql5.com/en/market/product/101255), Samuel B. Roccatello, **ago 2023, 7 recensioni** | 89 USD (**prova 20 giorni gratis su richiesta**) | 🟠 **non testabile nel tester** (lo dichiara il venditore) — ⚪ **ma la lista funzioni e' la migliore del Market** (§5.4) |
| E8 | Drawdown Guardian Pro | Market 137576, yetiteam, apr 2025, 4 recensioni | 30 USD | ⚪ **catalogo di meccanismi** (§5.4) |
| E9 | DrawDown Limiter | Market 91587, tradewithat, **dic 2022, 23 recensioni** (il piu' longevo e recensito) | 69 USD | ⚪ regala un EA che **accende/spegne Algo Trading** in base al DD |
| E10 | AXR Prop Guard | Market 176662 | 79 USD | ⚪ **le tre voci che nessun altro ha**: rischio degli **ORDINI PENDENTI**, **perdita settimanale**, **consistenza "best day"** |
| E11 | Prop News Filter Pro | Market 175738, joaojara | 39 USD | ⚪ **la configurazione news piu' concreta trovata** (§5.5) |
| E12 | Prop Firm Protector EZ MT5 | Market 150962, itprotrading, ott 2025 | 50 USD | ⚪ **numeri di default copiabili**: 10,1% / 5,1% / 4,5% / 2,0% |
| E13 | `LamaToes/MT4-MT5-prop-risk-monitor` (**PROPstyle**) | GitHub, **MIT**, ultimo commit **10/02/2026**, 525 righe, **clonato e letto** | GRATIS | ⚪ **solo indicatore** (non chiude) — ⚪ idea: modalita' **"Track Balance Down Only"** |
| E14 | `Amaljeevs/MT5BasicRiskManager` | GitHub, clonato | GRATIS | 🔴 al volo: **103 righe**, un solo input, calcola il lotto da tre linee sul grafico |
| E15-E30 | altre 16 utility "prop" del Market (Prop Firm Os, PropTradeManager, Prop Assistant, Drawdown Terminator, Drawdown Manager, Phoenix Drawdown Meter, Trader Command Center, PropMarshal, ecc.) | Market | 30-152 USD | 🔴 al volo: pubblicate **fra febbraio e luglio 2026**, 0-2 recensioni, e ripetono meccanismi gia' coperti da E1/E2 col sorgente |

---

## 2. 🧱 LA TABELLA DEI BUCHI — cosa hanno gli altri e noi no

Colonna "noi" = `ABTG_Guardian.mq5` (467 righe, 20 input, letto oggi) +
`ABTG_Guardian_FTMO_2Step.set` (firmato 18/08).

| # | meccanismo | dove l'ho letto (fonte + valore) | ce l'abbiamo? |
|---|---|---|---|
| 1 | cap perdita giornaliera + chiusura totale | tutti | ✅ **SI** (`InpDailyLossPct=4.9`) |
| 2 | DD totale statico **o trailing** | Dead-Line (`InpTrailingDrawdown`), Drawdown Guardian Pro, PROPstyle | ✅ **SI** (`InpDDMode`) — ⚠️ ma le Monte Carlo sono su **statico** |
| 3 | cancellazione degli **ordini pendenti** al trigger | ASQ RiskGuard (`InpProtectPendings=true`) | ✅ **SI** (`gTrade.OrderDelete`) |
| 4 | persistenza a **riavvio del VPS** | 🔴 **Dead-Line dichiara di NON averla**: _"In a real implementation, this would be retrieved from historical data. For now, we use current balance"_ | ✅ **SI, e siamo MIGLIORI**: GlobalVariable + battito |
| 5 | reset giornaliero a ora configurabile | EquityGuardPanel (ora **+ MINUTO**) | 🟡 **PARZIALE**: solo l'ora (`InpDailyResetHour=23`) |
| 6 | cap sul rischio aperto simultaneo | ASQ (`InpMaxTotalLots`), AXR | ✅ **SI** (`InpMaxOpenRiskPct=3.25`) |
| 7 | **freno espresso in % DEL LIMITE** (non assoluta) | EquityGuardPanel `InpTriggerPct=80` · ASQ `InpWarningPct=80` | 🟡 **PARZIALE**: 4,0 assoluto (= 80% di 5,0) |
| 8 | **STOP A TARGET RAGGIUNTO** (+10,1% → chiudi e basta) | PropFirmHelper `PASS_CRITERIA=110100` · Prop Firm Protector EZ `10,1% / 5,1%` | 🔴 **NO — e questo e' il buco piu' grosso** |
| 9 | **tetto operazioni/giorno** | ASQ `InpMaxOrdersPerDay=10` · EmoGuardian · Artemis 6 | 🔴 **NO** |
| 10 | **stop dopo N perdite consecutive** | EmoGuardian ("max consecutive losers") · Artemis 6 | 🔴 **NO** |
| 11 | **flat serale / niente overnight** | ASQ `InpCloseOutsideSession` + sessione 08:00-20:00 · Drawdown Guardian Pro · Prop Guard Pro 21:50 | 🔴 **NO** |
| 12 | **chiusura del VENERDI'** | Adam FTMO: *"Close all deals and Auto-trading before Weekend at 12:00 GMT+3 Friday"* · Prop News Filter Pro (auto weekend + festivi) | 🔴 **NO** |
| 13 | **guardia SPREAD sulla chiusura forzata** | ASQ `InpMaxSpreadPoints=30` · EquityGuardPanel `InpSlippagePts=30` | 🔴 **NO** — ed e' proprio il rischio scritto nella proposta P3 del 21/08 |
| 14 | **cooldown fra i tentativi di chiusura** | ASQ `InpCooldownSeconds=5` | 🔴 **NO** — con 20 posizioni e un server che rifiuta, il Guardian oggi martella |
| 15 | **enforcement attivo dopo il blocco** (chiude anche cio' che apre DOPO) | EquityGuardPanel `InpEnforceFlat` · Drawdown Guardian Pro ("Active Post-Blocking") · Prop News Filter Pro ("entro 5 secondi") | 🟡 **PARZIALE**: il lockdown chiude+blocca, ma la **pausa morbida** si fida che gli EA leggano la GlobalVariable |
| 16 | **cap per SIMBOLO / per lato** | EmoGuardian ("max open risk per symbol") · AXR ("symbol loss") | 🔴 **NO** — e la regola di casa "mai due EA stesso simbolo/lato" **non e' applicata da nessuno** |
| 17 | **rischio degli ORDINI PENDENTI** nel conteggio | AXR ("projected stop-loss risk **and pending-order risk**") | 🔴 **NO**: C1 conta solo le posizioni aperte |
| 18 | **cap di PROFITTO giornaliero** (regola di consistenza) | AXR ("daily profit caps", "**best-day consistency**") · Prop Firm Protector EZ (2,0%/giorno) | 🔴 **NO** — e le prop la misurano |
| 19 | **perdita SETTIMANALE** | AXR ("optional weekly loss") | 🔴 **NO** |
| 20 | **filtro news** | Prop News Filter Pro (§5.5) · ORB Master (NFP/CPI/IR) | 🔴 **NO** — coperto dal dossier del 21/08, non ancora in codice |
| 21 | **baseline giornaliera adattiva** balance vs equity | Prop Firm Protector EZ: *"se all'ora di reset l'equity supera il saldo, si usa la daily starting EQUITY"* · EquityGuardPanel `InpBaseMode` · PropFirmRiskDashboard (usa **equity**) | 🔴 **NO**: usiamo sempre il **saldo** |
| 22 | **kill/reload automatico degli EA** e spegnimento terminale | EmoGuardian ("kill EAs... reload them the next day") · Drawdown Guardian Pro ("Close Terminal") · DrawDown Limiter (toggle Algo Trading) | 🔴 **NO** (e ⚠️ e' una funzione **pericolosa**, va valutata, non copiata) |
| 23 | **log su file** degli eventi del guardiano | ASQ `InpLogToFile` · Prop News Filter Pro (CSV) · AXR ("Event Audit") | 🟡 **PARZIALE**: `InpVerbose` scrive nel giornale, non in un file nostro |
| 24 | **"dead-line": il muro come PREZZO, non come %** | Dead-Line Visualizer (§5.1) | 🔴 **NO** |

**Conteggio onesto: su 24 meccanismi, ne abbiamo 6 pieni, 5 parziali, e 13 no.**
Ma attenzione a leggerlo bene: **i 6 pieni sono i 6 che contano di piu'** (i
due muri, i pendenti, il cap C1, la persistenza al riavvio), e **su uno — la
sopravvivenza al riavvio del VPS — siamo misurabilmente meglio del guardiano
gratuito piu' scaricato**, che quel problema lo dichiara irrisolto nel proprio
commento di codice.

---

## 3. 🔬 LE SCHEDE COMPLETE

### 3.1 ⚪ THE ORB MASTER — la scheda che vale come EVIDENZA sul Nasdaq

```
NOME / VENDOR   The ORB Master / Profalgo Limited (login strueli, Malta)
URL             https://www.mql5.com/en/market/product/150079     [aperto 22/08/2026]
PREZZO          499 USD - NOLEGGIO 199 USD/1 mese, 299/3 mesi, 399/6 mesi
DEMO            si', gratuita, gira nel tester (3.301 demo scaricate)
PUBBLICATO      1 ottobre 2025 - versione 3.3 del 19 maggio 2026 - 10 attivazioni
RECENSIONI      31 (4,5) sul prodotto - 998 (4,1) sul VENDITORE
VENDITORE       27 prodotti, 29 SIGNAL REALI, reputazione 94.684, sito proprio,
                "developing EA's since 2005"
```

**MERCATI E MECCANISMO** _[DICHIARATO DAL VENDITORE]_: ORB su **SP500, US30,
NASDAQ e DAX**, M15, **3 varianti per indice = 12 strategie in parallelo**,
tutte pilotate da un unico grafico EURUSD. Trailing SL **e** trailing TP.
Dichiarato: *"No grid, no martingale, no aggressive tactics"*.

> ### 🔴 IL TEST DEL PUNTO 4 — e qui il caso si chiude
>
> Il venditore pubblica un signal del suo stesso EA: **"The ORB Master Live"**,
> [signal 2336314](https://www.mql5.com/en/signals/2336314). **[MQL5, dato di
> piattaforma, letto il 22/08/2026]**
>
> | metrica | valore |
> |---|---|
> | settimane | **47** (da fine 2025, cioe' **da quando il prodotto e' uscito**) |
> | operazioni | **1.343** — campione oltre il nostro canarino dei 150 |
> | **Profit Factor** | **0,89** |
> | crescita | **−15,38%** |
> | Sharpe | **−0,02** · Recovery Factor **−0,44** |
> | operazioni vinte | 524 (39,01%) |
> | **perdite consecutive max** | **23** |
> | avviso automatico MQL5 | *"A large drawdown may occur on the account again"* |
>
> **E la riga che pesa davvero — il profitto per SIMBOLO:**
>
> | simbolo | operazioni | profitto (USD) |
> |---|---|---|
> | **DE40** | 489 | **−173** |
> | **USTEC** | 301 | **−170** |
> | **US30** | 280 | **−337** |
> | **US500** | 259 | **−261** |
> | BTCUSD | 10 | +144 |
> | XAUUSD | 1 | +124 |
>
> **I quattro indici su cui il prodotto e' costruito sono TUTTI in perdita.
> Gli unici due simboli positivi hanno 10 e 1 operazioni** — cioe' sono
> rumore, o un altro EA sullo stesso conto.

**⚠️ Le cautele, dichiarate prima delle conclusioni:**
1. Il conto e' piccolo (deposito iniziale 635 USD + 2.878 di ricariche): i
   numeri di **drawdown percentuale sono inutilizzabili** (il "50,07% relativo
   sul saldo" e' distorto dalle ricariche). **Il PF e il profitto per simbolo
   NO: quelli sono puliti.**
2. 47 settimane = **un solo regime**. Non e' una bocciatura definitiva del
   motore ORB: e' una **misura indipendente su 1.343 operazioni vere**.
3. Il rischio del signal non e' il nostro rischio.

**🎯 COSA CI PORTIAMO A CASA** — due cose, e nessuna e' l'EA:
- **Per la sedia Nasdaq spenta (FIRMA 21/08, strada b):** un venditore di
  vent'anni, con 12 varianti ORB su 4 indici e gestione completa, **non
  guadagna in 11 mesi live**. Non decide il nostro round — ma va **scritto nei
  criteri prima dei numeri**, perche' e' esattamente la famiglia di
  `ABTG_Nasdaq_Apertura_US` e corrobora R45 (0/48) e R83/R84 (12 configurazioni,
  12 OOS negative).
- **Cinque meccanismi di configurazione**, elencati nel §5.

**COSA NON SAPREMO MAI**: il sorgente. E il `.set` non e' pubblico (a
differenza dell'Eriksson).

---

### 3.2 🟢 THE GOLD PHANTOM — l'unico che merita il gradino 3

```
NOME / VENDOR   The Gold Phantom / Profalgo Limited (strueli)
URL             https://www.mql5.com/en/market/product/161561     [aperto 22/08/2026]
PREZZO          649 USD - NOLEGGIO 349/3 mesi, 399/6 mesi, 499/1 anno
DEMO            si', gratuita, gira nel tester - 4.226 demo scaricate
PUBBLICATO      23 gennaio 2026 - aggiornato 19 maggio 2026
RECENSIONI      54 sul prodotto - 998 (4,1) sul venditore
IN CASA         gia' catalogato il 18/08: backtest_pipeline/caccia_strategie/
                biblioteca/schede/GoldPhantom_readMe_cmql5-31-1765_2026-08-18.txt
```

**MECCANISMO** _[DICHIARATO]_: breakout di supporti/resistenze su XAUUSD,
**9 strategie indipendenti** spalmate su **H1, H4 e Daily**. Ogni posizione ha
**SL fisso + TP fisso** dall'ingresso, piu' trailing SL e trailing TP.
Dichiarato: nessuna griglia, nessuna martingala.

> ### ✅ IL TEST DEL PUNTO 4 — e qui, per la prima volta in tutto lo sweep, passa
>
> [Signal 2355953 "The Gold Phantom Live"](https://www.mql5.com/en/signals/2355953)
> **[MQL5, dato di piattaforma, 22/08/2026]**
>
> | metrica | valore | confronto col METRO_PROP |
> |---|---|---|
> | settimane | **31** (dal 27/01/2026) | 🟡 giovane |
> | operazioni | **436** | ✅ ben oltre 150 |
> | **Profit Factor** | **1,34** | ✅ |
> | crescita | +26,40% | — |
> | **DD relativo sul SALDO** | **8,56%** | ✅ **DENTRO il muro del 10%** |
> | DD relativo sull'equity | 6,89% | ✅ |
> | **perdite consecutive max** | **9** | ⚠️ 9 × 0,65% = **5,85%** |
> | deposito | 3.091 EUR — **ricariche 0,00** | ✅ **numero pulito** |
>
> **Secondo signal indipendente, altro broker** — "The Gold Phantom Darwinex"
> ([2355966](https://www.mql5.com/en/signals/2355966)): 39 settimane, 584
> operazioni, PF 1,14, **DD sul saldo 11,02%**, 9 perdite consecutive.
> **Due conti, due broker, stessa firma: DD 8,6-11% e 9 perdite di fila.**

**🚩 LE BANDIERE ROSSE, cercate e trovate (gradino 2 del cancello):**
- ❌ griglia / martingala / recovery: **non dichiarate, e nessun indizio** nei
  due signal (436 e 584 operazioni, nessun accumulo).
- 🟠 **marketing aggressivo**: *"Only a few copies left"*, *"Final price 990$"*,
  *"passes prop firm challenges with ease"*. **Il prezzo che sale e' una leva
  di vendita, non un dato.**
- 🔴 **il dimensionamento e' circolare, e va scritto**: il venditore dichiara
  che l'EA *"auto-adjusts trade frequency and lot sizing according to your
  account balance and **your chosen maximum allowable drawdown**"*. Cioe':
  **il lotto viene dal DD STORICO di backtest della strategia.** Se il
  backtest sottostima il DD, il lotto e' troppo grande e non te ne accorgi.
  **E' l'esatto contrario del nostro metodo** (lotto dalla distanza dello SL a
  rischio 0,65%). Questo va misurato da noi, non creduto.
- 🟠 **il fratello maggiore fa 45,64% di DD**: The Gold Reaper, stesso motore
  ("same DNA"), 133 settimane. **La firma di rischio della famiglia e' alta**;
  il 8,56% del Phantom potrebbe essere giovinezza, non virtu'.

**⚖️ DUE DILIGENCE SUL VENDITORE (gradino 1-bis):** Profalgo Limited, Malta,
sito `forexeasolutions.com`, 27 prodotti, **29 signal pubblici** di cui alcuni
a **133, 208, 226, 260, 328 e 409 settimane** (5-8 anni). **E pubblica anche i
suoi fallimenti**: "Gold Scalp Test" −96% con DD 98%, "Bitcoin Reaper Live"
−13%, e **"The ORB Master Live" −15%**. 🎯 **Un venditore che lascia online il
signal negativo del proprio prodotto di punta e' il segnale di onesta' piu'
forte che abbia trovato in tutto lo sweep** — e vale piu' delle 54 recensioni.

**COSA CI PORTIAMO A CASA se il gradino 3 lo promuove**: un motore ORO
**decorrelato** dalla nostra famiglia oro (noi: LARRY / MaxMinNotte / EMA200 /
STREV — nessuno e' un breakout di livelli multi-timeframe).
**COSA NON AVREMO MAI**: il sorgente. Non lo potremo mai aggiustare.

📋 **PROPOSTA DI PERCORSO (decide Claudio, non io):** **NOLEGGIO 3 mesi a 349
USD prima di qualunque acquisto**, come dice la regola 2 del cancello. Ma
**prima** il gradino 3: la demo gratuita gira gia' nel tester, **a costo zero**,
sui nostri anni e i nostri costi. Non c'e' motivo di pagare prima di misurare.

---

### 3.3 🟢 EQUITY GUARD — Daily Loss Limit Guardian with Panic Panel

```
NOME            Equity Guard - Daily Loss Limit Guardian with Panic Panel
FONTE           MQL5 Code Base 73870 - https://www.mql5.com/en/code/73870
AUTORE          KairosLab - versione 1.20 - SORGENTE 1.082 righe
LICENZA         header MQL5 di default (Code Base = download gratuito).
                [INCERTO] la licenza esatta di riuso non e' dichiarata nel file
STATO           scaricato e letto oggi
```

**I 4 input che ci mancano** (letti nel sorgente, non nella descrizione):

| input | default | cosa fa | perche' ci serve |
|---|---|---|---|
| `InpTriggerPct` | **80.0** | blocca a **80% DEL LIMITE**, non a una % assoluta | la nostra pausa 4,0 e' 80% di 5,0 **scritto a mano**: se un giorno il muro cambia (prop diversa, 4% invece di 5%), il 4,0 diventa il 100% e la pausa **sparisce senza che nessuno se ne accorga** |
| `InpEnforceFlat` | **true** | **tiene il conto piatto MENTRE e' bloccato**: chiude tutto cio' che si apre dopo | oggi la nostra pausa morbida **si fida** che gli EA leggano la GlobalVariable. Un EA nuovo, o uno che non usa l'include, la ignora |
| `InpResetMinute` | 0 | reset al **minuto**, non solo all'ora | serve se la prop resetta a un orario non tondo nel fuso del server |
| `InpSlippagePts` | **30** | **deviazione massima ammessa sulla chiusura forzata** | e' esattamente il rischio scritto nella proposta P3 del 21/08: *"chiusura forzata su spread largo"* |

---

### 3.4 🟢 ASQ RISKGUARD — il guardiano gratuito piu' completo che esista

```
NOME            ASQ RiskGuard Professional Risk Management EA
FONTE           MQL5 Code Base 71120 - https://www.mql5.com/en/code/71120
AUTORE          AlgoSphere Quant - versione 2.00 - SORGENTE 1.063 righe
LICENZA         "Copyright 2026, AlgoSphere Quant" nell'header. [INCERTO] riuso
STATO           scaricato e letto oggi
```

**Gli 8 input che ci mancano**, coi loro default:

| input | default | buco che copre |
|---|---|---|
| `InpMaxOrdersPerDay` | **10** | #9 tetto operazioni/giorno |
| `InpMaxOpenPositions` | **5** | 🎯 **e' esattamente il nostro C1**: 3,25% = **5 stop vivi da 0,65%**. Due strade indipendenti, stesso numero |
| `InpMaxTotalLots` | 1.0 | cap di esposizione in lotti (noi contiamo il rischio, non i lotti) |
| `InpEnableSessionFilter` + `InpSessionStart/End` | **"08:00" / "20:00"** server | #11 finestra oraria |
| `InpCloseOutsideSession` | false | #11 **flat fuori sessione** |
| `InpEnableSpreadGuard` + `InpMaxSpreadPoints` | **30 punti** | #13 la guardia che serve al flat serale |
| `InpCooldownSeconds` | **5** | #14 niente raffica di tentativi di chiusura |
| `InpLogToFile` | true | #23 traccia d'audit su file |
| `InpMagicFilter` | 0 (tutti) | ✅ ce l'abbiamo (`InpCloseAllMagics`) |
| `InpDailyLimitPct` | **3.0** | ⚠️ **piu' conservativo di noi**: 3% contro il nostro 4,9% |

---

## 4. 🚩 LE VERIFICHE CHE HANNO SCARTATO (e perche' contano)

### 4.1 D1 — HFT PropFirm EA: 91 recensioni, **zero signal del prodotto**
Il prodotto piu' recensito della categoria "prop" (91 recensioni, **7.770**
demo scaricate, in vendita da maggio 2024, aggiornato l'**8 agosto 2026**).
Il test del punto 4: l'autore `rodeong` ha **15 signal** — e **nessuno e' su
questo EA**. Sono tutti scalper oro di **2-17 settimane**, e uno (`TNG Gold IC`)
e' a **PF 0,75**. In piu' la categoria stessa — **HFT / latency** — e' quella
che le prop bandiscono esplicitamente. 🟠 **Scartato dopo verifica.**

### 4.2 La regola generale che ne esce, e vale per tutti
> **Recensioni e download misurano quanto un prodotto e' VENDUTO. I signal
> misurano se FUNZIONA. Nello sweep le due cose non correlano:** i due prodotti
> piu' recensiti (91 e 55) **non hanno signal**; l'unico signal che sta dentro
> il muro del 10% sta su un prodotto con **54** recensioni.

### 4.3 C1 — Market Anomalies EA: bloccato dal FUSO, non dal merito
Il signal e' onesto e lungo (41 settimane, 571 operazioni **tutte USDJPY**,
PF 1,17). Ma il venditore scrive: *"This system is designed for brokers using
standard US trading time (**GMT+2 / GMT+3**)"*, e **nella pagina non c'e'
nessun input di offset GMT**. 🔴 **BCM e' GMT+1.** E' lo stesso blocco gia'
trovato il 21/08 sul "Range Breakout EA" dello stesso autore — quindi non e'
un caso: **e' una caratteristica di tutto il catalogo Eriksson**, e vale anche
per B3 (Gold Atlas). ⚠️ Conseguenza pratica: **anche il gradino 3 sarebbe
falsato**, perche' testeremmo su dati BCM un EA con le sessioni sbagliate di
un'ora. 🟠 **Scartato dopo verifica** — non per il motore, per la geografia.
📌 Da tenere: il venditore dichiara **daily drawdown protector integrato** e
**randomizzatore** (§5.6).

### 4.4 C2 — Zen Eagle: scartato per REGOLA, tenuto come EVIDENZA
Breakout su USDJPY = famiglia del motore morto → la **regola della seconda
caccia** (CLAUDE.md, 19/08) lo esclude come candidato. Ma il dato resta agli
atti: 23 settimane, 484 operazioni USDJPY, **PF 1,39**, DD 24,65%, avviso MQL5
*"Too frequent deals"*, conto di **300 EUR**.

### 4.5 A2-A10 — perche' nove EA su indici sono caduti al volo
Il criterio, dichiarato prima di applicarlo: **(a)** nessun signal MQL5
dell'autore, **oppure** **(b)** prodotto pubblicato da meno di 6 mesi con 0-1
recensioni, **oppure** **(c)** tracciamento solo su piattaforme che non posso
leggere (FX Blue, Myfxbook). **Sette dei nove sono stati pubblicati fra
febbraio e agosto 2026.** ⚠️ Coerente con quanto gia' visto su Artemis nel
dossier del 21/08: la fabbrica di prodotti e' la norma, non l'eccezione.

### 4.6 🎌 C7/C8 — la nota che tocca una SEDIA VIVA: l'autore del Gap Continuation

**Fatti, tutti verificati oggi:**
- La nostra sedia **774101** (`ABTG_GapContinuation`, 225JPY, in forward dal
  16/08, contratto DD promesso **11,59%**, PF 1,398) e' l'adozione di
  *"Nikkei 225 Gap Continuation EA"*, **[Code Base 75301](https://www.mql5.com/en/code/75301)**,
  Francesc Jordi Mallol Nolden, pubblicato **24/07/2026, 1.830 visualizzazioni,
  1 solo voto**. Il thread forum 513338 ha **zero commenti**: nessuna
  segnalazione di bug, ma anche **nessuna revisione da parte di terzi**.
- **Il giorno dopo (25/07/2026)** lo stesso autore ha pubblicato sul **Market**
  lo stesso EA (`187414`) come **GRATUITO, versione 1.50**. La tab
  `/updates` **non elenca nessuna versione** → **[INCERTO]** se la 1.50
  contenga correzioni rispetto al sorgente che abbiamo adottato.
- La sua pagina venditore elenca **5 prodotti pubblicati fra il 16/06 e il
  19/08/2026** = **5 prodotti in 65 giorni**. 🚩 Stessa firma di "fabbrica" gia'
  vista su Artemis.
- Nel suo blog del **23/07/2026** promuove *"Kuro225 EA **on the MQL5 Market**"*.
  🔴 **Sulla sua pagina venditore, oggi, Kuro225 NON C'E'.**

> 🎯 **Cosa NON dice questo**: non dice che la sedia 774101 sia sbagliata — il
> suo contratto e' nostro, misurato da noi in R65/R66 a tick reali.
> 🎯 **Cosa dice**: che **l'upstream di una nostra sedia viva e' un autore da
> tenere d'occhio**, e che vale la pena **scaricare la 1.50 dal Market
> (e' gratis) e confrontarne il comportamento** con la nostra adozione — se non
> altro per sapere se stiamo girando su una versione superata.

---

## 5. 💎 LE IDEE E I PARAMETRI DA PORTARE IN CASA (spunti, non prodotti)

### 5.1 🎯 La "DEAD-LINE": il muro come PREZZO, non come percentuale
Dal sorgente di [Code Base 68087](https://www.mql5.com/en/code/68087), letto
riga per riga. La matematica e' **una trentina di righe**:

```
sensibilita' = Σ ( segno_direzione × volume × TickValue / TickSize )      [valuta per unita' di prezzo]
perdita_ammessa = equity_corrente − equity_minima_consentita
prezzo_di_morte  = prezzo_corrente − perdita_ammessa / sensibilita'
```

**Cosa dice a Claudio, in italiano:** *"con le posizioni che hai adesso, il
DAX puo' scendere fino a **23.847** — sotto quello sfondi il muro
giornaliero."* **Un prezzo, sul grafico, non una percentuale su un pannello.**
Il file la calcola sia sul muro giornaliero sia su quello totale e disegna la
**piu' vicina delle due**.

⚠️ **I suoi due difetti, che ci fanno comodo saperli:** conta solo le posizioni
del **simbolo del grafico** (noi ci serve conto intero), e la baseline
giornaliera e' **un'approssimazione dichiarata dall'autore nel commento**
(`"For now, we use current balance"`) — cioe' **al riavvio a meta' giornata
sbaglia**. Il nostro Guardian quel problema lo ha gia' risolto.

### 5.2 📐 I NUMERI DI CONFIGURAZIONE, con la fonte accanto

| valore | cosa | fonte | confronto con noi |
|---|---|---|---|
| **4,5%** | cap giornaliero interno contro muro 5% | `PropFirmHelper` (`DAILY_LOSS_LIMIT=4500` su 100k) + `Prop Firm Protector EZ` | noi **4,9%** |
| **3,5-4%** | idem | blog MQL5 [767611](https://www.mql5.com/en/blogs/post/767611), Mauricio Vellasquez, 23/02/2026 | noi pausa **4,0** ✅ |
| **3,0%** | cap giornaliero di default | `ASQ RiskGuard` | piu' stretto di noi |
| **+10,1%** | equity a cui **chiudere tutto e smettere** | `PropFirmHelper` + `Prop Firm Protector EZ` | 🔴 **non ce l'abbiamo** |
| **+5,1%** | idem per la **fase 2** di verifica | `Prop Firm Protector EZ` | 🔴 no |
| **+2,0%/giorno** | cap di **profitto** giornaliero, una volta al giorno | `Prop Firm Protector EZ` | 🔴 no |
| **80%** | soglia del freno, espressa come **frazione del limite** | `EquityGuardPanel` + `ASQ RiskGuard` | noi valore assoluto |
| **60% / 85%** | warning / danger a due stadi | `Prop Firm Risk Dashboard` | 🔴 no |
| **10% del margine residuo** | soglia di allarme | `Dead-Line Visualizer` | 🔴 no |
| **30 punti** | spread massimo e deviazione massima sulla chiusura | `ASQ` + `EquityGuardPanel` | 🔴 no |
| **5 secondi** | cooldown fra tentativi di chiusura | `ASQ RiskGuard` | 🔴 no |
| **10 op/giorno · 5 posizioni · 1,0 lotti** | tetti | `ASQ RiskGuard` | 🔴 no (ma **5 posizioni = il nostro C1**) |
| **08:00-20:00 server** | finestra operativa | `ASQ RiskGuard` | 🔴 no |
| **21:50 ora broker** | flat serale | `Prop Guard Pro` (dossier 21/08) | 🔴 no |
| **venerdi' 12:00 GMT+3** | chiusura di fine settimana | `Adam FTMO` | 🔴 no. **In ora server BCM (GMT+1) = venerdi' 10:00** |
| **−15 min / −2 min** | pre-blocco e chiusura forzata prima della news | `Prop News Filter Pro` | coperto dal dossier news, non in codice |
| **NFP, CPI, FOMC, tassi, occupazione** — **ISM e PMI ESCLUSI** | lista eventi bloccanti | `Prop News Filter Pro` | 🔴 lista non ancora scritta |
| **ogni 4 ore** | riscarico della cache del calendario | `Prop News Filter Pro` | — |

### 5.3 💡 Cinque IDEE di meccanismo (non parametri: modi di fare le cose)

1. **⭐ Il range che si chiude quando il mercato lo dice, non quando lo dice
   l'orologio** — da `GOLD_ORB` (GitHub): il range di apertura resta **aperto**
   finche' **N candele consecutive (default 3) non chiudono dentro di esso**.
   Solo allora e' "finale" e la rottura conta.
   🎯 **Perche' ci interessa davvero**: e' esattamente la risposta al difetto
   che R42 e R45 hanno misurato in casa (*"il box notturno paga sul RANGE
   DELLA NOTTE — ore di accumulo — non sul quarto d'ora dell'apertura"*).
   **Non e' "un altro ORB con un'altra finestra": e' un range a durata
   VARIABILE, cioe' un modo diverso di definire l'oggetto.** ⚠️ Costo:
   dimezza il campione e sposta l'ingresso piu' tardi. Merita un asse in un
   round, non un filtro appiccicato.
2. **Dimensionare dal DRAWDOWN storico invece che dallo SL** — Profalgo
   (Gold Phantom e ORB Master: `Max Risk Per Strategy` = *"the preferred maximum
   allowed total drawdown (%) for each strategy; the EA determines lotsize
   based on the historical max DD of that strategy"*). ⚠️ **Ne diffido, e
   scrivo perche'**: se il DD di backtest e' ottimista, il lotto e' troppo
   grande **e il sistema non ha modo di accorgersene**. E' il contrario del
   nostro metodo. **Lo segnalo come idea da conoscere, non come idea da
   adottare.**
3. **Randomizzare ingressi, uscite e trailing** — ORB Master
   (`US500_Randomization`, *"multiple users on the same broker will have
   slightly different trades. Also good for prop firms"*) **e** Market
   Anomalies (*"built-in randomizer function (prop firm friendly)"*).
   🎯 **Due venditori indipendenti, stesso meccanismo, stessa motivazione: le
   prop cercano i conti che fanno trade identici.** Per noi conta poco oggi
   (EA nostri, un conto solo) ma **conta il giorno in cui girassero due conti
   prop con gli stessi EA**.
4. **`AutoGMT`: l'EA calcola da solo l'offset del broker** — ORB Master
   (`AutoGMT`, `GMT_OFFSET_Winter`, `GMT_OFFSET_Summer`, con una URL di time
   server nelle "Allowed URLs"). 🎯 **E' la cura strutturale del problema che
   ha appena scartato due prodotti Eriksson** e che ci morde a ogni cambio di
   ora legale (vedi anche §5.7).
5. **`Track Balance Down Only`** — PROPstyle (GitHub, MIT): il saldo di
   riferimento **si aggiorna solo quando scende**, mai quando sale.
   🎯 Terza modalita' accanto alle nostre due (statico da inizio / trailing da
   picco), e la piu' prudente delle tre.

### 5.4 🧰 Il catalogo funzioni di EmoGuardian e Drawdown Guardian Pro
_(Market, letti oggi; li riporto perche' sono la lista di controllo piu'
completa che esista — non perche' proponga di comprarli.)_

**EmoGuardian** (89 USD, autore italiano, agosto 2023, 7 recensioni, prova
gratuita 20 giorni su richiesta) — ⚠️ **il venditore dichiara che NON gira nel
Strategy Tester**, quindi **non passerebbe il gradino 3 del cancello**:
limiti giornalieri (equity min/max, perdita/guadagno max, **inizio giornata
personalizzabile**) · limiti di posizione (volume max, **volume giornaliero
max**, **numero di trade al giorno**, **numero massimo di perdenti
consecutivi**, **rischio aperto max per trade E PER SIMBOLO**) · **fino a 3
fasce orarie**, ognuna con proprio tetto di perdita, proprio tetto di trade e
**una PAUSA dopo che il tetto e' colpito** · SL automatici aggiunti alle
posizioni che non ne hanno · **spegnimento e riaccensione automatica degli EA
il giorno dopo** · segnali d'emergenza per EA su VPS · **controlli di coerenza
sui parametri PRIMA di accettarli, per non liquidare il conto per un input
sbagliato** ⭐.

**Drawdown Guardian Pro** (30 USD): DD calcolato **da picco equity** o **da
saldo di inizio giornata** · **DD trailing** · soglia in % **o** in valuta **o
la prima che scatta** · **livello di equity MASSIMO** (= profit target
raggiunto) · azione fuori orario: niente / blocca / **chiudi tutto** · cinque
modi di reagire: `Close_All` / **`Close_Losing_Only`** / `Close_Profitable_Only`
/ `Block_Only` / `Notify_Only` · **cancellazione dei pendenti** · **blocco
attivo post-trigger** (richiude cio' che riapre) · **contatore dei tentativi
bloccati** · sfondo del grafico che cambia colore per stato · **chiusura degli
altri grafici** e **chiusura del terminale** come ultima risorsa ⚠️.

### 5.5 📰 La configurazione news piu' concreta trovata (Prop News Filter Pro)
_Complementare al `DOSSIER_NEWS_FILTER_2026-08-21.md`, che copre gia' le
fonti. Qui c'e' la CONFIGURAZIONE._
- **due stadi**: pre-blocco dei nuovi ingressi **15 minuti prima**, chiusura
  forzata di tutto **2 minuti prima**;
- 🔴 **fatto nuovo e pesante**: *"most news filters rely on the MQL5 native
  calendar, **which is disabled on many prop firm terminals**"* → il venditore
  usa **ForexFactory come fonte primaria** e il calendario nativo **solo come
  ripiego**. **[DICHIARATO, NON VERIFICATO DA NOI]** — ma se e' vero, riguarda
  direttamente la scelta di D5 del PIANO_PROP;
- **coordinamento multi-EA via GlobalVariable** (`PNF_BLOCK_USD`,
  `PNF_BLOCK_EUR`, ...): ⭐ **e' esattamente l'architettura del nostro
  Guardian** — conferma indipendente che la strada e' giusta — **ma la loro
  granularita' e' per VALUTA, la nostra e' per CONTO**;
- **difesa a strati**: se un EA apre lo stesso, **viene chiuso entro 5 secondi**;
- log CSV di ogni blocco/chiusura/ripresa.

### 5.6 🏛️ Le due funzioni "prop-friendly" che i venditori mettono per primi
Su tutti i prodotti che si dichiarano prop-ready, **le prime due voci
dell'elenco sono sempre le stesse**: **(1)** un **daily drawdown protector**
integrato **nell'EA**, non nel guardiano; **(2)** un **randomizzatore**.
🎯 **La (1) e' un'informazione strategica per noi**: il campo mette il freno
giornaliero **dentro ogni motore**, noi lo abbiamo **solo nel Guardian**.
Le due architetture hanno pregi opposti — la nostra e' centralizzata e
coerente; la loro sopravvive se il guardiano non c'e'. **Vale la pena
scriverlo come scelta consapevole, invece che lasciarlo implicito.**

### 5.7 ⏰ Un dubbio sull'ORA DI RESET, che va posto e non risolto qui
`ABTG_Guardian_FTMO_2Step.set` fissa `InpDailyResetHour=23` con la nota
_"23:00 BCM = 00:00 CET"_ e lo dichiara **[INCERTO]** in attesa di conferma
scritta di FTMO. Oggi, via motore di ricerca **[LETTO-VIA-SEARCH, ftmo.com e'
EGRESS_BLOCKED]**, la pagina "Trading Objectives" risulta dire: *"recalculated
daily at **00:00 CE(S)T**"* — cioe' **CET d'inverno e CEST d'estate**.
🔴 **La domanda che ne segue, e che io NON posso chiudere da qui:** se
l'offset del server BCM segue l'ora legale come lo segue l'Italia, allora
l'ora di reset **cambia in ottobre** e il `23` diventerebbe sbagliato.
**Va messo in calendario come verifica, non come correzione** — e va chiuso
con la risposta scritta di FTMO che il PIANO_PROP gia' aspetta.

---

## 6. 📋 SEGNALAZIONI PER LA TABELLA MADRE (`report/PIANO_PROP.md`)

🔒 **NON ho toccato `PIANO_PROP.md`: e' lavoro dell'architetto-prop.** Qui
sotto ci sono solo le righe candidate, ordinate per **resa/costo**. Nessuna si
applica da sola: vanno in coda all'imbuto come qualunque modifica, e gli
`_Ottimizzato` girano in parallelo, mai sostituiti.

| # | proposta | dove | fonte | costo stimato | rischio |
|---|---|---|---|---|---|
| **S1** | 🥇 **STOP A TARGET RAGGIUNTO**: se equity ≥ saldo iniziale × 1,101 → chiudi tutto, cancella i pendenti, blocca fino a decisione umana | `ABTG_Guardian` (input `InpTargetPct`, default 0 = spento) | PropFirmHelper `PASS_CRITERIA=110100` + Prop Firm Protector EZ (10,1% / 5,1%) | **~2h** + 1 giro di autotest | quasi nullo: e' il **muro dalla parte del profitto**. Attenzione a non farlo scattare su un picco di equity intraday che poi rientra → va valutato su **equity** con conferma, o su **saldo** |
| **S2** | 🥇 **GUARDIA SPREAD + DEVIAZIONE sulla chiusura forzata** (`InpMaxSpreadPts`, `InpSlippagePts=30`): se lo spread supera la soglia, ritenta invece di svendere | `ABTG_Guardian` | ASQ `InpMaxSpreadPoints=30` + EquityGuardPanel `InpSlippagePts=30` | **~2h** | 🔴 **e' il prerequisito di qualunque flat automatico** (P3 del 21/08). ⚠️ Attenzione: rimandare la chiusura **mentre si sfonda il muro** e' peggio che svenderla → serve un **tetto di attesa** oltre il quale si chiude comunque |
| **S3** | 🥈 **`InpCooldownSeconds=5`** fra i tentativi di chiusura | `ABTG_Guardian` | ASQ RiskGuard | **~1h** | basso. Va tarato: 5 s × 20 posizioni = 100 s per liquidare tutto — **troppo lento sul muro**. Il cooldown deve valere **per tentativo fallito**, non per posizione |
| **S4** | 🥈 **Freno espresso come % DEL LIMITE** (`InpPauseAsPctOfLimit=80`) invece del 4,0 assoluto | `ABTG_Guardian` | EquityGuardPanel `InpTriggerPct=80` + ASQ `InpWarningPct=80` | **~1h** | ⚠️ **cambia un valore FIRMATO il 18/08** → non si tocca senza firma. Oggi 4,0/4,9 = **81,6%**, quindi il comportamento resterebbe quasi identico: **e' robustezza, non una modifica di rischio** |
| **S5** | 🥈 **Tetto operazioni/giorno** + **stop dopo N perdite consecutive** (partenza proposta: 10 e 3) | `ABTG_Guardian` (stessa contabilita' per entrambi) | ASQ `InpMaxOrdersPerDay=10` · EmoGuardian · Artemis (6 e 6) | **~3h** + 1 giro | conteggio su conto **hedging** con parziali: si conta la **POSIZIONE chiusa in perdita**, non il deal. Rischio vero: **blocca un ingresso buono** dopo una giornata movimentata |
| **S6** | 🥉 **Cap del rischio aperto PER SIMBOLO e PER LATO** (oggi C1 e' solo aggregato) | `ABTG_Guardian` | EmoGuardian ("per symbol") + AXR ("symbol loss") | **~3h** | 🎯 **applicherebbe finalmente la regola di casa** *"mai due EA stesso segnale/simbolo/lato a rischio pieno"*, che oggi non e' applicata da nessuno. Serve prima **misurare quante volte succede davvero** nei nostri statement |
| **S7** | 🥉 **Rischio degli ORDINI PENDENTI dentro il conteggio C1** | `ABTG_Guardian` | AXR Prop Guard ("pending-order risk") | **~2h** | c'e' un doppio conteggio da evitare: un pendente non ancora scattato **non e' rischio certo** → serve un peso, o un cap separato |
| **S8** | 🥉 **Flat serale / venerdi'** con orari **in ora server BCM** | `ABTG_Guardian` | Prop Guard Pro (21:50) · Adam FTMO (**ven. 12:00 GMT+3 = 10:00 BCM**) · ASQ (`InpCloseOutsideSession`) | **~2h** dopo S2 | 🔴 **non si accende senza S2**. ⚠️ E ha un costo di MERITO da misurare: la sedia `GapContinuation` ha gia' *"zero overnight"* nel contratto, altre no |
| **S9** | 🔵 **Baseline giornaliera adattiva** (`InpDayBaseline`: saldo / max(saldo, equity)) | `ABTG_Guardian` | Prop Firm Protector EZ (regola esplicita) · EquityGuardPanel `InpBaseMode` · PropFirmRiskDashboard (usa equity) | **~2h** | ⚠️ **NON si tocca prima della risposta scritta della prop**: cambiare la baseline cambia il muro. Va **misurato sui nostri statement** quante volte all'ora di reset avremmo equity > saldo |
| **S10** | 🔵 **Pannello "dead-line": il muro come PREZZO** sul simbolo del grafico | `ABTG_Guardian` (solo pannello, non tocca la logica) | Code Base 68087, formula al §5.1 | **~3h** | 🟢 **rischio zero: non chiude niente, disegna soltanto.** Il candidato migliore per un primo passo indolore |
| **S11** | 🔵 **Log su FILE degli eventi del Guardian** (CSV con data/ora/evento/stato) | `ABTG_Guardian` | ASQ `InpLogToFile` · AXR ("Event Audit") · Prop News Filter Pro (CSV) | **~2h** | nessuno. 🎯 Utile soprattutto **il giorno di una contestazione con la prop** |
| **S12** | 🔵 **Cap di PROFITTO giornaliero** (regola di **consistenza**: nessun giorno > X% del profitto totale) | Guardian **oppure** procedura manuale | AXR ("best-day consistency", "daily profit caps") · Prop Firm Protector EZ (2,0%) | **~4h** | 🔴 **prima serve sapere se la prop scelta ha la regola e con che numero.** Senza quello e' un freno inventato |
| **S13** | ⚪ **Provare il gradino 3 su The Gold Phantom** (demo gratuita, costo zero) e solo dopo valutare il **noleggio 3 mesi 349 USD** | file prova + riga di lancio | §3.2 | **1 file prova + 1 round** | il rischio e' **spendere ore su un EA che non potremo mai aggiustare**. Mitigazione: la demo costa zero, il noleggio viene dopo |
| **S14** | ⚪ **Scaricare la v1.50 gratuita del Nikkei Gap Continuation** dal Market e confrontarla con la nostra adozione | verifica, non modifica | §4.6 | **~1h** | nessuno: e' gratis e non tocca il forward. 🎯 Riguarda una **sedia viva** |
| **S15** | ⚪ **Segnalare `Code Base 53393` al dossier news** (cache calendario per il tester) | `DOSSIER_NEWS_FILTER_2026-08-21.md` | §E6 | — | e' l'implementazione pronta del rimedio gia' scritto in quel dossier al §1B |

### 🥇 Se Claudio ne sceglie UNA sola, io farei **S1** (stop a target raggiunto)

**Perche' proprio quella:** e' **l'unico buco della lista che puo' far
fallire una challenge GIA' VINTA**. Tutti gli altri 23 meccanismi difendono dal
muro in basso; S1 e' l'unico che difende **il traguardo**. Il giorno in cui il
conto tocca +10%, la challenge e' finita — e oggi, nel nostro sistema, **non
esiste una sola riga di codice che lo sappia**: gli EA continuerebbero a
operare, e un solo brutto pomeriggio riporterebbe l'equity sotto il target.
Costa **due ore**, non tocca nessun valore firmato, non chiude mai niente in
perdita, ed e' **misurata da due fonti indipendenti allo stesso numero (10,1%)**.

---

## 7. 🗂️ ELENCO DELLE PAGINE APERTE (per chi verra' dopo)

| URL / artefatto | cosa ci ho preso |
|---|---|
| `mql5.com/en/market/mt5/expert` pag. 1-12 | 840 prodotti (nome, autore, prezzo, descrizione) |
| `mql5.com/en/market/mt5/utility` pag. 1-12 | 840 utility |
| `mql5.com/en/market/mt5/free` pag. 1-8 | 560 gratuiti → **2.046 unici** |
| `mql5.com/en/code/mt5/experts` + `/indicators` pag. 1-12 | **955 voci di Code Base** |
| `market/product/150079` + `/en/signals/2336314` | **The ORB Master**: input completi, e il signal a **PF 0,89** |
| `market/product/161561` + `signals/2355953` + `signals/2355966` | **Gold Phantom**: prezzo/noleggio + **due signal, DD 8,56% e 11,02%** |
| `signals/author/strueli` | 27 signal di Profalgo con settimane, PF, DD |
| `signals/author/jimmy282` + `signals/2342700`, `2340550`, `2271995` | 13 signal Eriksson; **Market Anomalies USDJPY 571 op PF 1,17** |
| `signals/author/rodeong` · `barbarosbulent` · `traderjes` · `joaojara` · `stanislav110685` · `gougo` · `walter2008` · `vasiliy_strukov` | 8 liste signal — **la prova che i prodotti piu' recensiti non hanno signal** |
| `signals/2364778` | **Zen Eagle**: 484 op USDJPY, PF 1,39, DD 24,65% |
| `market/product/155039` · `169432` · `190402` · `128825` · `182751` · `112509` | i 6 prodotti JPY del Market |
| `market/product/187414` + `/updates` + `code/75301` + `forum/513338` + `users/mauriykiku/seller` | **l'upstream della nostra sedia 774101** (§4.6) |
| 30 schede utility "prop" del Market (elenco al §1.E) | il catalogo dei meccanismi |
| `code/download/73870` · `71120` · `49713` · `74553` · `68087` | 🔧 **5 sorgenti `.mq5` scaricati e letti** (3.425 righe in tutto) |
| `github.com/LamaToes/MT4-MT5-prop-risk-monitor` · `Amaljeevs/MT5BasicRiskManager` · `yulz008/GOLD_ORB` | 🔧 **3 repo clonati e letti** (licenze e date di commit verificate) |
| `mql5.com/en/blogs/post/767611` · `/773070` | i due blog: config prop (3,5-4%) e orologio del Nikkei |
| `forexfactory.com` · `reddit.com` · `myfxbook.com` · `web.archive.org` · `github.com/search` | ❌ **tutti 403** — dichiarati nulli al §0 |
