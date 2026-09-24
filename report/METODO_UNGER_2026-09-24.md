# 🎯 IL METODO UNGER, SMONTATO PEZZO PER PEZZO — e rimontato sui NOSTRI EA

**24/09/2026** · richiesta di Claudio: *"parametri e metodi concreti per migliorare i nostri EA, niente teoria generica"* · sintesi di due cacce parallele:
- `backtest_pipeline/caccia_strategie/CACCIA_UNGER_INGRESSI_USCITE_FILTRI_2026-09-24.md` (pilastri 1-3)
- `backtest_pipeline/caccia_strategie/CACCIA_UNGER_SIZING_VALIDAZIONE_2026-09-24.md` (pilastri 4-5)
- precedente: `backtest_pipeline/caccia_strategie/CACCIA_ANDREA_UNGER_2026-09-14.md`

---

## 0. 🔴 PRIMA DI TUTTO: DA DOVE VENGONO QUESTI NUMERI

> **Le fonti primarie di Unger sono ANCORA bloccate dalla rete di questa sessione** (blog Unger Academy, YouTube, podcast Better System Trader, Traders' Tips, ProRealCode, Benzinga, Wiley, Amazon, Google Books). Ricontrollato oggi dal coordinatore: `ungeracademy.com` → `EGRESS_BLOCKED` sia con `curl` che con `WebFetch`.
> **87 + 43 host provati nelle due cacce (16 in comune: ~114 distinti), 9 rispondono.**

Quindi ogni riga di questo referto porta la sua etichetta, e **l'etichetta è parte del numero**:

| etichetta | vuol dire | quanto pesa |
|---|---|---|
| **[VERIFICATO]** | pagina o sorgente aperto davvero | è un fatto |
| **[SNIPPET]** | riassunto del motore di ricerca, pagina NON aperta | è una **pista**, non un criterio |
| **[TERZI]** | fonte non di Unger che gliela attribuisce | pista debole |
| **[CASA]** | letto o misurato nel nostro repo | è un fatto |
| **[SONDA]** | contato da noi su dati DAX 2011-2018 (non BCM) | misura di **occasioni**, mai di edge |
| **[INFERITO]** | ragionamento nostro | si dice da cosa |

🟢 **La notizia buona**: stavolta c'è **un pezzo di meccanica di Unger letto nel sorgente**, il **Weekly Factor** (TASC settembre 2023, porting Pine di PineCodersTASC). Il coordinatore l'ha riaperto, e il cancello di nuovo: la pagina TradingView dice *"an article written by Andrea Unger titled “The Weekly Factor”"* e l'intestazione del sorgente Pine dice *"Article By: Andrea Unger"*, con filtro corpo 5gg / range 5gg, ingresso M15 sulla rottura del giorno prima e uscita a fine giornata **[VERIFICATO]**.

🚫 **Non aperti di proposito**: le copie non autorizzate del libro (scribd, pdfcoffee e simili) e i mirror che aggirerebbero il blocco di rete (translate.goog, web.archive).

---

## 1. 🏗️ PILASTRO 1 — ARCHITETTURA E INGRESSI

### 1.1 Il principio: prima il GRILLETTO, poi il setup [SNIPPET]
```
1. scegli il MECCANISMO d'ingresso (stop su un livello / limit su un livello)
2. costruisci un modello BASE senza pattern (trend-following, contro-trend, o BIAS)
3. SOLO DOPO applica i pattern come FILTRO sul motore (libreria di ~40 pattern:
   volatilita', direzionali, neutri)
```
⚠️ **[CASA] Il punto 3 da noi ha fatto 0 su 5.** Filtri aggiunti dopo a un motore già tarato: R20, R12, R26, R45, R54 (`report/ROBUSTEZZA.md`). Unger lo fa funzionare su 30-40 futures in portafoglio, noi no. **Si prendono i punti 1-2. Il 3 solo se il pattern è dichiarato COSTITUTIVO prima dei numeri.**

### 1.2 Trend o mean-reverting? Il test delle "2 righe" [SNIPPET]
```
STESSI LIVELLI = massimo e minimo di IERI (D1)
test_trend  : BUY STOP  a High[D1,1]   ;  SELL STOP  a Low[D1,1]
test_revert : BUY LIMIT a Low[D1,1]    ;  SELL LIMIT a High[D1,1]
IF PF(test_trend) > PF(test_revert)  THEN il mercato "segue"   -> motore breakout
ELSE                                   il mercato "sfuma"   -> motore fade
```
Si decide **per mercato**, non per principio. Due snippet discordi: uno mette gli indici USA fra i mean-reverting, l'altro dice che il Nasdaq ha *"a slightly more pronounced trend following tendency"*. **Da rimisurare, non da credere.**

### 1.3 Le sue strategie con le regole leggibili

| # | nome | regola IF-THEN | numeri | fonte |
|---|---|---|---|---|
| **E1** | **Weekly Factor** | IF `|Open[5] − Close[1]| < RF × (maxHigh5 − minLow5)` THEN giorno attivo. IF attivo AND una barra **M15** (n. 2..90 della sessione) chiude > `High[D1,1]` THEN long; chiude < `Low[D1,1]` THEN short. Flat a cambio sessione | RF = **0,5** (0..1 passo 0,1); **niente stop** nella versione TASC | **[VERIFICATO]** |
| E2 | Breakout di ieri, DAX | long alla rottura del massimo di ieri, short al minimo; flat a fine sessione | M15, sessione 8:00-22:00 | [SNIPPET] |
| E3 | Variante intraday DAX | long su `max(High oggi, High ieri)`, short su `min(Low oggi, Low ieri)`; flat a fine giornata | — | [SNIPPET] |
| E4 | **DAX First Hour** | range della 1ª ora del **future** (08-09 CET); ordini nella 2ª ora (= 1ª del cash) a **estremo ± 0,75 × range**; tutti i giorni **tranne venerdì**; esce a fine giornata o all'estremo della 1ª ora | k = **0,75** | [SNIPPET] |
| E8 | Nasdaq, esplosione di volatilità | livello = `Open sessione ± k × ATR`; entra se una barra M15 chiude oltre; flat a fine sessione | k ottimizzato 1..10: **5,5 long, 8 short**; variante ATR(200) | [SNIPPET] |
| E13 | Le origini (campionati) | breakout del massimo/minimo delle prime **2-3 ore**, niente TP, uno stop | — | [SNIPPET] |
| E14 | **OOPS** | — | — | 🔴 **[CASA] CHIUSO**: R38, **0 trade su 288 celle** (il CFD quota ~24h e il gap non esiste) |

---

## 2. 🚪 PILASTRO 2 — USCITE

### 2.1 Le regole [SNIPPET, salvo dove detto]
```
STOP LOSS   : SEMPRE ("a strategy without any kind of stops isn't safe at all")
              in MONETA FISSA per contratto: $2.000 (trend 4 giorni), $1.700 (oro H1),
              2.000-2.500 EUR (FDAX)
TAKE PROFIT : IF trend-following THEN niente TP ("let the trend develop")
              IF contro-trend / rimbalzo / esplosione THEN TP si'
BREAKEVEN   : IF profitto >= soglia THEN stop a pareggio; soglia "ne' troppo stretta
              ne' troppo larga"; attenzione: un BE piu' stretto della barra del
              backtest non si misura bene
TRAILING    : di norma NO su DAX / ES / Crude ("improved performances very seldom")
TEMPO       : IF intraday THEN flat a fine sessione (SetExitOnClose)
              IF multiday THEN esci dopo N barre: BarsSinceEntry > 5 (D1), max 10 barre (H1)
              oro: long chiusi all'1:00, short alle 9:00
```

### 2.2 Messe accanto alle nostre

| Unger | noi | dove | verdetto |
|---|---|---|---|
| flat a fine sessione | ✅ c'è | `ABTG_DAX_Apertura_EU.mq5` r.266-268 (`InpCloseHour/Min`, `InpCloseAtEnd`) | identico |
| uscita a N barre/giorni | ✅ c'è | `ABTG_PunteLarry.mq5` r.162 (`InpMaxDaysHold=5`), `ABTG_CostToCost.mq5` r.163 | il suo "5 giorni" = il nostro default |
| stop in **moneta fissa** | ❌ **per scelta** | `LotByRisk` in `ABTG_EMA200.mq5` r.467-495 | 🟢 **la nostra è quella giusta per le prop**: uno stop in euro fissi non scala fra simboli, il rischio % allo stop sì |
| breakeven con cautela | ✅ | `InpBreakevenAtTP1`, `InpBEatR` (`mql5/Experts/ABTG_DAX_Apertura_EU.mq5` r.331-332) | 🤝 sul Dow **[CASA]** "niente BE: 6 confronti puliti su 8 in perdita" (`ABTG_Dow_Apertura_US.mq5` r.287) |
| trailing "quasi mai" | ⚔️ **CONTRADDETTO in casa** | `ABTG_Dow_Apertura_US.mq5` r.289-292 | **[CASA]** trailing M5 sul Dow: PF **1,24 → 1,37**, DD **6,9% → 5,3%**. **Si tiene la nostra misura** |
| **"Open Position Profit"** (tieni la notte SOLO i trade in perdita) | ❌ | — | 🔴 **DA NON IMPORTARE**: è esposizione notturna condizionata alla perdita. La notte su indice da noi è **chiusa per rischio**: il 16/03/2020 costa **1,51 anni di edge** (`report/SECONDA_CACCIA_2026-09-12.md` §4.3). È la forma di rischio che il DD giornaliero della prop punisce |

---

## 3. 🔍 PILASTRO 3 — FILTRI E DATA MINING

### 3.1 I filtri, in forma di codice
```
WEEKLY FACTOR   : attivo IF |O[5]-C[1]| < 0,5 x (maxH5 - minL5)               [VERIFICATO]
DAILY FACTOR    : attivo IF |O[1]-C[1]| < x x (H[1]-L[1]),  x = 25%            [SNIPPET]
                  (un porting MetaTrader di terzi dice 50%: DISCORDI)          [TERZI, pagina non aperta]
DAY DROP        : (C[1]-L[1]) < DDV x (H[1]-L[1]),  DDV in 0..1                [SNIPPET]
GIORNO SETTIMANA: E4 salta il VENERDI'                                          [SNIPPET]
VIX             : spegni IF VIX e' in cima al ranking delle ultime 100 osservazioni [SNIPPET]
ADX             : solo come filtro, soglia OTTIMIZZATA (non 20/25 dei libri)   [SNIPPET]
IERI ESTREMO    : non operare dopo un giorno di movimento direzionale estremo  [SNIPPET]
```

### 3.2 Messi accanto ai nostri

| filtro | noi | verdetto |
|---|---|---|
| **Weekly / Daily Factor sul D1** (regime del giorno prima) | ❌ **NON c'è**. **[CASA]** Grep su 115 EA: i filtri corpo/range sono tutti sulla **candela di segnale** (`ABTG_PTE.mq5` r.64, `ABTG_ORB.mq5` r.144), mai sul regime di ieri | 🟠 **buco vero e piccolo** (1 input, ~15 righe), MA da provare solo come **motore costitutivo** (§6, ipotesi C) |
| giorno della settimana | 🟡 solo in `DAX_MASTER_PROP` e `TurnaroundTuesday` | 🚫 **non lo proponiamo**: è data mining puro, un cerotto (0 su 5) |
| bias per ora del giorno | ✅ **misurato e CHIUSO** | **[CASA]** DAX: **0 fasce asimmetriche su 72** in OOS (`backtest_pipeline/risultati_archivio/REFERTO_OROLOGIO_INDICI_DAX_2026-09-07.md`) |
| bias overnight (il suo E10) | ✅ **misurato e CHIUSO per rischio** | **[CASA]** merito sì (t = +2,86, 8 anni su 9), **rischio no** (§2.2) |
| ATR / volatilità | ✅ c'è | `InpUseAtrFilter` (`mql5/Experts/ABTG_DAX_Apertura_EU.mq5` r.364-365), `ABTG_VolExpBreak` |
| ADX come filtro | ✅ già provato | R20, fallito |

### 3.3 Come sceglie i filtri senza overfitting [SNIPPET]
- **Non usa il walk-forward.** Due pagine diverse del suo sito lo dicono: *"considers WFA a good analysis method, nevertheless he doesn't use it"*. Al suo posto fa **test di stabilità** (piccole variazioni attorno al valore scelto) più un fuori campione.
- L'ottimizzazione serve *"not to find the best values, but to get a deeper understanding of the markets"*.
- Sistemi da **3 righe di codice**.

---

## 4. 💰 PILASTRO 4 — MONEY MANAGEMENT

🔴 **Qui si riportano i numeri di Unger e li si confronta coi nostri. Nessuna taglia e nessun valore di rischio viene proposto: sono di Claudio.**

### 4.1 Le formule, scritte bene

**Fixed Fractional** [SNIPPET, attribuzione incerta: "non più dell'1% dell'equity"]
```
lotti = EQUITY x r / perdita_per_lotto_allo_stop
```
**[CASA]** Noi: `lotti = BALANCE x 0,65% / perdita_per_lotto(distanza_SL)` (`ABTG_EMA200.mq5` r.470, perdita per lotto da `OrderCalcProfit` r.480).
🟡 **Una differenza vera, non dichiarata in nessun documento trovato [INFERITO dal codice]**: lui calcola sull'**equity**, noi sul **saldo**. Con posizioni aperte in perdita noi apriamo un po' più grande. **È materia di taglia: la decide Claudio.**

**Percent Volatility** [SNIPPET]
```
lotti = rischio_monetario / (ATR_D1 x valore_di_1_punto_per_lotto)
```
🧪 **Contro-esempio [INFERITO dall'algebra]**: sedia a stop di **range** (apertura DAX), ATR invariato, range del giorno doppio. Il Percent Volatility tiene **lo stesso lotto** e la perdita allo stop **raddoppia**. La nostra **dimezza il lotto** e la perdita allo stop resta al rischio dichiarato. **Per il muro giornaliero della prop conta la seconda.**
Le due formule coincidono solo quando lo stop è proporzionale all'**ATR D1**; `EMA200` ci va vicino ma usa l'ATR del suo TF (`InpTF`, r.260) [INFERITO dal codice].

**Fixed Ratio** (Ryan Jones, trattato nel suo libro) [TERZI]
```
soglia(N) = DELTA x N x (N-1) / 2        # profitto cumulato per poter usare N contratti
N(P)      = floor( 0,5 + sqrt(0,25 + 2 x P / DELTA) )
```
🧪 **Contro-esempio fatto**: la versione di FXStreet **senza il +0,5**, con DELTA = P = 5.000, dà 1 contratto invece di **2**. **Quella formula non va copiata.**
🔴 **Riga prop [INFERITO]**: il Fixed Ratio sale a **gradini interi** (1 → 2 contratti vuol dire taglia ×2 in un colpo). La voce 8 delle pratiche vietate FTMO parla di *"substantially larger position sizes compared to other trades"*. **Non lo consigliamo in prop.**

**Kelly come TETTO, mai come bersaglio** [SNIPPET, attribuzione incerta: la frase compare solo accanto al dominio SEO scartato]
```
f* = W - (1-W)/b       # W = % vincenti, b = vincita media / perdita media
```
**[CASA]** Coi nostri numeri (`report/AUDIT_USCITE_2026-09-09.md` r.101-104) f* viene **0,13-0,25** (DAX 0,229 con parziale / 0,245 senza; Dow 0,156 / 0,131). Contro lo 0,0065 nostro siamo **20-38 volte sotto** il tetto. Un solo regime, quindi resta un tetto indicativo.

### 4.2 Scaling, piramidazione, portafoglio [SNIPPET]
| regola Unger | noi |
|---|---|
| uscita unica rende di più; lo **scaling out è "solo psicologico"** | ✅ **misurato**: gli danno ragione 2 prove su 4 (`AUDIT_USCITE`) |
| **niente piramidazione** | ✅ non la facciamo (i 2 ordini EMA200 sono pendenti dall'inizio, rischio diviso r.361) |
| **più sistemi sullo stesso mercato → taglia per sistema più bassa** | 🟡 noi ci arriviamo dal tetto: **C1 al 3,25% vivo** (`ABTG_Guardian.mq5`) |
| contratti per **fascia di volatilità** (1 su DAX/oro, 2 su gas/rame, 3 su sterlina) | ✅ è il nostro rischio % fatto a mano, a gradini interi perché sui futures non esistono frazioni |

### 4.3 Quando un sistema è "rotto" [SNIPPET]
```
D1  IF DD_forward > DD_max_storico THEN NON spegnere in automatico: INDAGA
D3  "Caso Benzina": IF 6 mesi senza nuovi massimi THEN PAUSA (non scarto)
                    IF l'equity OMBRA (il sistema in pausa, simulato) fa un nuovo massimo
                    THEN RIACCENDI
```
**[CASA]** D1 è **identico** alla nostra corsia RISCHIO del 18/08 (*"DD forward > DD promesso → revisione IMMEDIATA"*). D3 è **una cosa che non abbiamo**, la regola di rientro, ma **6 mesi sono fuori scala per una challenge**.

---

## 5. 🔬 PILASTRO 5 — OTTIMIZZAZIONE E VALIDAZIONE

| criterio | Unger | noi | chi è più severo |
|---|---|---|---|
| valore scelto | il **migliore DENTRO** l'area di stabilità [SNIPPET] | il **CENTRO** dell'altopiano, mai il picco | 🟢 **NOI** (e in R70 la differenza ha ribaltato un verdetto) |
| trade minimi | **30** (intervista Radio 24) [SNIPPET] | **150 IS + 150 OOS** | 🟢 **NOI, 5 volte** |
| walk-forward | **non la usa** [SNIPPET, due pagine concordi] | IS/OOS a finestre **e** altopiano | 🟢 **NOI più larghi** |
| filtri aggiunti in serie = overfitting | lo dice [SNIPPET] | l'abbiamo **contato**: 0 su 5 | 🟢 **NOI** |
| Monte Carlo | la distribuzione del DD | **p99**, rimescolando giorni interi | 🟢 **NOI** |
| **OOS contaminato** | *"non basta che un periodo sia etichettato OOS: non deve aver influenzato, nemmeno indirettamente, lo sviluppo"* [SNIPPET] | ❌ **nessuna regola** | 🔴 **LUI** |

### 🔴 Il punto dove Unger ci batte, contato alla fonte
**[CASA, ricontato dal coordinatore]** **494 file prova (`.txt`) su 916** citano la stessa fine del fuori campione, `2026.06.30` (517 su 979 contando anche gli `.md`/`.py`/`.csv` della cartella; conteggio a `1c4ed445`). La finestra OOS di casa è stata guardata da centinaia di prove: **non è più vergine**. Questo non rende falsi i numeri di contratto. Dice però che sono stati **scelti guardando** quella finestra.

👉 **In preparazione, NON lanciato**: **R248, la finestra vergine per questo EA** (2026.07.01 → 2026.09.18). Il candidato #1 (breakout del Dow di R245) e la sedia viva `770202` **verranno** letti **una volta sola**, con i criteri congelati prima. I file prova sono scritti e aspettano lo strato 2; **la riga di lancio non esiste ancora**: passerà dai due cancelli e partirà solo su via libera di Claudio, sul PC di backtest. ⚠️ **Con ~41 operazioni la finestra giudica il RISCHIO, non il MERITO** (Emendamento B): il PF si scrive e **non decide**.

---

## 6. 🧪 COSA SI PUÒ PROVARE, IN ORDINE DI COSTO

🔒 **Nessuna di queste è passata dai cancelli. Sono proposte, non righe di lancio.** I round girano sul PC di backtest, mai sul VPS (regola del 21/09).

### 🥇 IPOTESI A — "Ieri come livello", stop contro limit · **ZERO codice**
```
EA      : ABTG_DAX_Apertura_EU   (gemelli: ABTG_Dow_Apertura_US, ABTG_Nasdaq_Apertura_US)
INPUT   : InpRangeMode = 2 (RANGE_PREVBAR)      r.274
          InpLevelTF   = PERIOD_D1              r.275   <- MAI messo ad asse in casa
          InpEntryMode = 0 (BREAKOUT)  contro  3 (RANGE_FADE)   r.273, enum r.203-206
          InpPendingExpiryMin = 510 (08:00 -> 16:30)            r.282
          InpCloseHour/Min = 16:30 · InpMinStopPts = 0
          STOP UGUALE NEI DUE BRACCI: InpSLMode = 1 (ATR) + stesso InpAtrSlMult
            (RANGE_FADE IGNORA InpSLMode e InpBufferPoints: stop = InpAtrSlMult x ATR
             del TF del grafico, r.1277-1279 -- classe 706)
          STESSI LIVELLI: InpBufferPoints = 0, InpFadeOffsetPts = 0;
            InpSlippagePts dichiarato (sposta SOLO il braccio STOP)
          InpAllowLong / InpAllowShort separati (regola dei due lati, 25/08)
DOMANDA : sul DAX BCM, agli STESSI livelli di ieri, vince lo STOP o il LIMIT?
```
- **[CASA] Cosa c'è già**: `InpLevelTF` **non è mai stato messo ad asse** (nessuno dei 267 CSV con quella colonna la fa variare; `prove/R133a_livelliTF_NASUSD.txt`, M15..H4 su NASUSD, è scritto ma **mai lanciato**: `report/LE_MANOPOLE_INERTI_2026-09-23.md` §4.6). **Ma D1 come valore FISSO è già girato una volta sul DAX, in BREAKOUT**: `backtest_pipeline/risultati_archivio/DAX_Apertura/apert_DAX_M5_doc_brk_realtick_D30EUR.csv` (M5, tick reali, 119 passate / 32 esiti, ordini vivi 120 min, **n 61-71, PF 0,52-2,12**, mediana delle passate 0,76; finestra non scritta nel CSV). Campione sotto 150 e scadenza diversa: **non è un verdetto, è il prior**. Il braccio **RANGE_FADE su D1 non ha righe**; il FADE sul range d'apertura è archiviato senza edge (PF **0,715 / 0,720**, n 419/430, stesso referto §4.7). Enum verificati in `mql5/Experts/ABTG_DAX_Apertura_EU.mq5`. Il test delle "2 righe" di Unger è su barre D1 senza uscita serale [SNIPPET]: l'ipotesi A ne è un adattamento intraday [INFERITO].
- **[SONDA] L'evento esiste**: sul DAX 2011-2018 la rottura del massimo/minimo di ieri dopo le 08:00 capita circa **121 volte l'anno**. **MA nel 36,6% dei giorni il livello è già "consumato" prima delle 08:00**: è la lezione OOPS, e **va rimisurata sui tick BCM**, perché la sonda non vede la notte.
- 🔴 **La trappola da contare prima di leggere un PF [INFERITO dal codice]**: nei giorni "consumati" lo stop dalla parte già rotta viene **rifiutato** (log `BUY/SELL STOP fallito`, r.1214/r.1238; nel braccio FADE il LIMIT dalla parte già rotta è rifiutato allo stesso modo: `SELL/BUY LIMIT (fade) fallito`, r.1296/r.1313) e resta vivo solo l'altro lato. Quei giorni fanno un'operazione **mono-lato non voluta**.
- **Frontiera del costo [SONDA]**: i ≈ **197× lo spread** (p10 ~97×) valgono SOLO per il braccio STOP con stop all'estremo opposto di ieri. Con lo stop ATR comune ai due bracci la frontiera **va ricalcolata** sull'ATR(14) del TF del grafico: `[NON MISURATO]`.
- ⚠️ **Orologio**: BCM è UTC+1 fisso; nei mesi d'inverno le 08:00 server sono le 08:00 italiane (un'ora PRIMA del cash) e le 16:30 non sono la chiusura. Una prova 2024.09.26 → oggi a orari fissi MESCOLA due tempistiche: va spezzata per stagione o dichiarata (`OROLOGIO_BCM_2026-09-24.md`).
- ⚠️ **Sovrapposizione**: stessa fascia oraria di `770101`. Se passa, si misura la correlazione con `770101` **prima** di qualunque vivaio.

### 🥈 IPOTESI B — La "prima ora del future" con spostamento · **1 input nuovo**
- `ABTG_DAX_Apertura_EU`, `InpRangeMode=1`, `InpPrevWindowMin=60` (range 07-08 server), BREAKOUT, `InpPendingExpiryMin=60` (ordini vivi solo 08-09).
- **Manca un input**: lo spostamento oggi è in **punti fissi** (`InpBufferPoints` r.277), quello di Unger è una **frazione del range** (k = 0,75). Servono circa 5 righe, quindi **firma e sviluppatore**.
- **[CASA]** In RETEST ha già dato **PF OOS 0,861** (n = 320, DD 15,6%; modello di quel CSV `[INCERTO]`). In **BREAKOUT** è **NON ANCORA MISURATO**, non morto.
- **[SONDA, DAX future 2011-2018, non BCM: da rimisurare sui tick BCM D30EUR, con la fascia 07-08 server quotata]** Con k = 0,75 la rottura entro le 09:00 capita nel **57,6%** dei giorni. Stop con k = 0 ≈ **42× lo spread**: sul confine. **Vive solo con lo spostamento o col pavimento `InpMinStopPts`.**
- ⚠️ **Orologio**: dal 26/10 la prima ora del future diventa **08-09 server** (BCM UTC+1 fisso, `OROLOGIO_BCM_2026-09-24.md`).

### 🥉 IPOTESI C — Weekly/Daily Factor come motore COSTITUTIVO di A · **~15 righe**
- Tesi scritta **prima** dei numeri: *"la rottura di ieri paga dopo una fase di indecisione"*. La cella col filtro si congela **insieme** ad A, non dopo averla vista.
- **[SONDA, DAX future 2011-2018, non BCM: da rimisurare sui tick BCM]** Weekly Factor vero sul **52,5%** delle rotture (~64/anno/simbolo), Daily Factor 25% sul **29%** (~35/anno). **Il singolo simbolo non arriva a 150 per metà**: il verdetto è **solo di famiglia** (3 indici).
- Parte **solo se A mostra un motore vivo**.

---

## 7. 🏁 IL BILANCIO, DETTO ONESTO

| | |
|---|---|
| 🟢 **Dove siamo già avanti** | centro dell'altopiano, 150 + 150 trade, Monte Carlo p99, filtri-cerotto contati, rischio % allo stop invece che in euro fissi, trailing del Dow misurato |
| 🟠 **Cosa prendiamo** | (1) l'**OOS vergine** → in preparazione come R248 (non lanciato; giudica il rischio, non il merito); (2) il **test delle 2 righe** sul livello D1 → ipotesi A, zero codice; (3) il **Weekly Factor** come motore costitutivo → ipotesi C, dopo A |
| 🔴 **Cosa NON prendiamo** | stop in moneta fissa, Fixed Ratio in prop, "Open Position Profit", filtri giorno-della-settimana, bias overnight, OOPS |
| ❓ **Cosa resta aperto** | il walk-forward (due snippet concordi, nessuna pagina aperta), il 25% o 50% del Daily Factor, il codice EasyLanguage ufficiale del Weekly Factor |

🧭 **Bussola**: niente di tutto questo **schiera una sedia entro il 1° ottobre**. È ricerca. Il pezzo più vicino a una sedia è **R248**: mette alla prova sul RISCHIO un candidato che c'è già (con ~41 operazioni non può confermarne il merito), invece di inventarne uno nuovo.

### 📥 La lista della spesa per Claudio (5 pagine gratis, nessun acquisto: per lui non sono bloccate)
| # | URL | cosa chiude |
|---|---|---|
| 1 | `https://ungeracademy.com/blog/walk-forward-analysis` | la domanda aperta dal 14/09 |
| 2 | `https://www.traders.com/Documentation/FEEDbk_docs/2023/09/TradersTips.html` | EasyLanguage ufficiale del Weekly Factor |
| 3 | `https://www.prorealcode.com/prorealtime-trading-strategies/dax-5-min-trading-strategy-by-andrea-unger/` | la meccanica esatta della First Hour (il 75%) |
| 4 | `https://forexup.altervista.org/viewtopic.php?t=3963` | Daily Factor: 25% o 50%? |
| 5 | `https://ungeracademy.com/blog/mean-reverting-or-trend-following-find-it-out-with-2-lines-of-code-btc-and-eth` | il test delle "2 righe", verbatim |

📌 **Il precedente**: l'unica volta che Unger è entrato davvero in casa (l'OOPS), ci è entrato **così**. Claudio ha portato il materiale, e R38 l'ha chiuso in un round **senza sprecare un'ora di macchina**.

---
_Nessun EA toccato. Nessun parametro in forward toccato. Nessuna taglia proposta. Nessun acquisto. Conto reale 10105439 non toccato._
