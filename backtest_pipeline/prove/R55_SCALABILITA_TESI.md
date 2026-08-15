# R55 — QUANTO SCALA OGNI CELLA — tesi prima dei numeri (15/08/2026)

_Nata dalla domanda di Claudio sui conti prop da 1.500.000
(`report/SCHEDA_PROP_UPCOMERS.md` §7). **Ma il round che avevo proposto non si
puo' fare come l'avevo scritto**, e la prima cosa che questa tesi deve fare e'
spiegare perche'._

---

## 0. ⚠️ CORREZIONE: il round proposto ieri era sbagliato, e anche l'esempio

Avevo proposto: _"si spazzola `InpSlippagePts` sulla cella viva del DAX e su
quella del Dow, otto-dieci passate"_. **Sarebbe uscita una tabella di righe
identiche.** Due motivi, letti nel codice:

1. **`InpSlippagePts` e' implementato SOLO nel ramo BREAKOUT**
   (`ABTG_DAX_Apertura_EU.mq5:1037` e `:1061`, dentro `TryPlaceBreakout`). Le
   celle vive di DAX e Dow girano in **RETEST**, che sta in un'altra funzione e
   **non legge quell'input**.
2. **Il RETEST entra con `BuyLimit`/`SellLimit`** (`:1474`, `:1505`). Un limit
   **non subisce slippage negativo per costruzione**: o si riempie al prezzo
   chiesto (o meglio), o non si riempie affatto.

**E l'esempio della scheda prop era il peggiore possibile.** Avevo scritto che
"cinque punti di slippage azzerano l'edge del nostro EA migliore" usando il DAX
Apertura — che e' **la cella meno esposta allo slippage di tutte**, perche'
entra a limit. Il ragionamento sui 177 lotti resta valido; l'esempio no.

---

## 1. Il quadro vero: come entra ogni EA (letto dal codice, 15/08)

| EA | mercato | stop | limit | ha `InpSlippagePts` |
|---|:-:|:-:|:-:|:-:|
| ABTG_PTE | ✅ | — | — | ❌ |
| ABTG_BreakingBand | ✅ | — | — | ❌ |
| ABTG_GapFill | ✅ | — | — | ❌ |
| ABTG_CostToCost | ✅ | — | — | ❌ |
| ABTG_SuperWave | ✅ | ✅ | — | ❌ |
| ABTG_SupertrendReversal | ✅ | ✅ | — | ❌ |
| ABTG_EasyTrend | ✅ | — | ✅ | ❌ |
| ABTG_MaxMinNotte | — | ✅ | — | ❌ |
| ABTG_ORB_Ottimizzato | ✅ | ✅ | — | ❌ |
| ABTG_PunteLarry | — | ✅ | ✅ | ❌ |
| ABTG_EMA200 | — | — | ✅ | ❌ |
| **Apertura (DAX/Dow/Nasdaq)** | ✅ | ✅ | ✅ | ✅ **solo nel breakout** |

### Come si legge

- **A MERCATO** → paga lo slippage **pieno**, a ogni trade. PTE, BreakingBand,
  GapFill, CostToCost.
- **A STOP** → paga lo slippage sulla rottura, che e' il momento in cui il book
  e' piu' sottile. MaxMinNotte, ORB, Larry(stop), SuperWave, SupertrendReversal.
- **A LIMIT** → **non paga slippage**, ma rischia di **non riempirsi**.
  EMA200, Larry(limit), EasyTrend(limit), Apertura in RETEST.

> **La scoperta di questa lettura: il RETEST scala MEGLIO del breakout, e non
> l'avevamo mai notato.**
>
> A 177 lotti chi entra a stop **entra comunque, a un prezzo peggiore** — cioe'
> perde soldi. Chi entra a limit **rischia di non entrare** — cioe' perde
> un'occasione. **Il limit degrada in modo benigno, lo stop no.**
>
> La scelta del RETEST fatta in R6 e deployata il 09/08 aveva un beneficio
> collaterale mai misurato ne' dichiarato: e' la geometria che regge la taglia.

**E la cella che scala peggio del portafoglio non e' il DAX: e' il PTE**, che
entra a mercato ed e' la famiglia con piu' serie in classifica. Subito dietro
l'**ORB Dow** (BuyStop, buffer 10), che sta sul 100k a mezzo peso.

## 2. Cosa dicono i giornali, sui dati che abbiamo gia'

Dal censimento del 15/08 (60 giorni, ordini piazzati dal VPS):

| simbolo | pendenti piazzati | riempiti | **scaduti INEVASI** |
|---|---:|---:|---:|
| D30EUR | 187 | 124 | **20** (10,7%) |
| NASUSD | 103 | 59 | 12 (11,7%) |
| U30USD | 42 | 32 | 9 (21,4%) |
| XAUUSD | 50 | 22 | 16 (32,0%) |

> ⚠️ **Limite dichiarato, e va letto prima dei numeri:** la colonna
> "annullati" (166 in totale) **non e' un mancato riempimento**: contiene le
> cancellazioni che l'EA fa di proposito sul pendente gemello quando l'altro
> lato si riempie. Quindi **non si puo' calcolare un "tasso di fill" da qui**.
> L'unica colonna pulita e' **scaduti inevasi**, che e' il **limite inferiore**
> del non-riempimento.

Anche cosi': **un pendente su dieci sul DAX scade senza riempirsi, gia' a
11,80 lotti**. Non e' un problema di taglia — e' la geometria del retest che
chiede al prezzo di tornare. Ma e' il numero da cui partire per capire cosa
succede a 177.

## 3. IPOTESI (scritte prima di qualunque misura)

1. **Le celle a mercato e a stop perdono edge in modo proporzionale allo
   slippage**, e la soglia di morte e' bassa: con un'aspettativa di ~0,075R per
   trade (misurata su DAX in R47), **basta uno slippage del 7,5% di R** per
   azzerarla. Su celle con payoff simile la soglia sara' dello stesso ordine.
2. **Le celle a limit non perdono edge per slippage, ma perdono TRADE.** Il
   backtest MT5 riempie i limit al prezzo esatto **sempre**: quindi i nostri
   numeri sono **ottimisti sulla probabilita' di riempimento**, non sul prezzo.
   Di quanto, il tester **non puo' dirlo**.
3. **[NON MISURABILE COL TESTER]** Il fill parziale a 177 lotti. MT5 non
   modella la profondita' del book. Nessun backtest, per quanto onesto,
   rispondera' mai a questa domanda: solo il forward a taglia crescente.

## 4. CRITERI (congelati, a numeri non visti)

1. **Nessun cambio ai parametri vivi da questo round.** Misura la robustezza,
   non cerca una taratura.
2. Una cella si dice **"scala"** se, aggiungendo uno slippage pari al **10% di
   un R**, resta positiva fuori campione. Sotto quella soglia si dice
   **"vive solo a taglia piccola"**, e va scritto nella sua riga di classifica.
3. **Le celle a LIMIT non partecipano** a questa misura: per loro il tester non
   ha niente da dire (ipotesi 2). Vanno marcate **[NON MISURABILE QUI]**, non
   "promosse".
4. Il risultato **non autorizza nessuna taglia**: dice solo quali celle
   sopravvivono a un'esecuzione peggiore. La taglia la decide il forward.

## 5. COSA SERVE PER FARLO (e perche' oggi non c'e' una riga da lanciare)

**Nessuno degli EA a mercato o a stop ha un input di slippage.** Per misurare
serve aggiungerlo, e va fatto come si e' fatto con `InpAllowReverse` in R51:

- un input nuovo `InpSlippagePts`, **default 0 = comportamento identico a
  oggi**, quindi **forward invariato per costruzione**;
- applicato al prezzo di ingresso nel verso che danneggia (peggiora l'entry);
- un EA per volta, partendo dai due che contano di piu': **ABTG_PTE** (a
  mercato, la famiglia con piu' serie) e **ABTG_ORB_Ottimizzato** (a stop, sul
  100k).

Poi il round e' corto: 5 valori di slippage x 2 finestre x 2 EA = **20 passate**.

**Fino ad allora, la risposta onesta alla domanda "conviene un conto da 1,5M?"
resta: non lo sappiamo, e nessuno dei numeri che abbiamo lo dice.**
