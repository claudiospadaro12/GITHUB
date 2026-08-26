# 🏹 CACCIA SMC — ORDER BLOCK e FAIR VALUE GAP su M15 — 26/08/2026

**Mandato di Claudio (sessione principale, 26/08):** ha portato un prompt
esterno che chiede un EA 5m/15m con **Order Block**, **Fair Value Gap** e
**liquidità di sessione**. Compito: trovare su fonti **gratuite** e
**leggibili nel sorgente** implementazioni di (1) OB e (2) FVG su **M15**,
per **indici** (D30EUR / U30USD / NASUSD) e **FX majors**, in ottica
**challenge prop**.

**Perimetro tagliato PRIMA di uscire, e non è negoziabile:**
- **M5 = capitolo CHIUSO** (`REGISTRO_TEST.md` §2 + arXiv 2605.04004 §6.1).
  Si caccia **solo M15** (e M30 come piano B). La terza gamba del prompt
  esterno — "5 minuti" — **non entra in questo dossier**, e sotto c'è il
  motivo con i numeri.
- **Sweep/raid di sessione con reversal = CADUTO** (R95 0/30 + T = −14,12
  esterno). Un candidato SMC che si riduce a quello è il caduto riverniciato.
- **Fade degli estremi d'apertura = R42** (0/24 IS, 0/24 OOS).
- **Volume come conferma: su FX NO** (tick volume), **sugli indici SÌ**.

---

## ⚡ IL RISULTATO IN UNA RIGA

> **Su 6 fonti sottoposte a controllo positivo (4 vive, 2 nulle), 3.189
> titoli del Code Base ricrawlati, 60 strategie TradingView uniche raccolte
> su 15 tag SMC, ho aperto e letto nel sorgente 20 file (14 Pine + 6 `.mq5`).
> Ne PROMUOVO 3 — e il primo è l'unico dei venti che si può mettere nel
> tester senza riscrivere una riga di logica.**

🎯 **Il buco che riempiono è vero e verificato in repo:** ho listato tutti gli
`ABTG_*.mq5` della flotta. Ci sono `ABTG_GapFill` (gap del **weekend**),
`ABTG_GapContinuation` (gap di **apertura** del Nikkei) e
`ABTG_LiquiditySweep` (sweep + reclaim). **Non esiste un solo EA che
riconosca un Fair Value Gap a tre candele, e non esiste un solo EA che
riconosca un Order Block.** Sono due meccanismi che il progetto non ha mai
misurato — né promosso, né bocciato.

🔴 **E la scoperta più scomoda va scritta per prima, perché cambia il peso di
tutto il resto: l'SMC non ha letteratura.** Cinque interrogazioni all'API
arXiv (`"fair value gap"` + trading → **0 entry**; `"order block"` + trading
→ 2 entry, entrambe di **teoria dei grafi e blockchain**; `"smart money
concepts"` → **0 entry**; `abs:"liquidity sweep"` → 1 entry, ed è **fisica
delle gocce**). Nessun paper, nessun campione, nessun T-stat. **La tesi di
mercato dell'OB/FVG esiste solo nella didattica retail.** Non è un motivo di
scarto — le nostre sedie vive non hanno paper dietro nemmeno loro — ma è il
motivo per cui in questo dossier **il cancello del costo e la prova di
frequenza pesano il doppio**: non c'è nessuno, fuori, che abbia già
falsificato al posto nostro.

---

## 0. 📕 LA LISTA DEI CADUTI — riletta PRIMA di uscire, è il metro di scarto

| caduto | dove | meccanismo | verdetto misurato |
|---|---|---|---|
| **capitolo BREAKOUT M5** | `REGISTRO_TEST.md` §2 | Live5m, Live5m_v2, DAX_M3, aperture Nasdaq, ORB_Fibo, Londra_ORB | **CHIUSO 26.07.26** a tick reali. _"Non costruire altri v2 M5."_ |
| **soffitto del costo su M5** | arXiv **2605.04004** §6.1 (Mesfin 2026) | 14 famiglie di segnali OHLCV su MNQ | _"maximum achievable gross return before friction is roughly **1,05-1,50 points**… the **2,0-point friction cost consistently exceeds this**"_ |
| **R95 — SWEEP + RECLAIM** | `R95_REFERTO.md` | sweep di swing + rientro, M30→H4, EURJPY | **30 passate su 30 in perdita**, PF 0,65-0,80, DD 27-99,9%, n da 149 a 3.641 |
| **sweep di sessione, conferma esterna** | arXiv 2605.04004 §4.3 | *Asia Session Liquidity Grab Reversal* | 6.442 eventi, netto **−2,20 punti**, **T = −14,12** |
| **R42 — FADE degli estremi d'apertura** | `REFERTO_ROUND42_FADE.md` | fade sugli estremi del box 15'/35' | **0/24 IS e 0/24 OOS**. _"è morto il MOTORE, non la gestione"_ |
| **R45 — ORB di sessione (Londra)** | `REFERTO_ROUND45_LONDRA.md` | range 15/30' + chiusura M5 + corpo 50% + EMA 9/21 | **0 celle positive su 48** |
| **famiglia ORB in generale** | `SETACCIO_MANUALE.md` | ~**210 celle a tick reali** su 4 mercati | _"il breakout puro al tocco è morto ovunque"_ |
| **R109 — ATR Exhaustion & Volume Spike** | `R109_REFERTO.md` | esaurimento + spike di volume su M15 indici | DD **44-68%**, peggior giornata **−9,72%**. Causa fotografata: **SL strettissimi con `InpMinSLPts` spento** |
| **R108/R111 — la discesa di TF** | `R108_REFERTO.md`, `R111_REFERTO.md` | Breaking Band da H1 a M30 a M15 | gradiente **MONOTONO H1 > M30 > M15** su 3 simboli. A M15: **6 finestre su 6 rosse** |
| **filtro appiccicato a motore già tarato** | `ROBUSTEZZA.md` §5B | R20 ADX, R12, R26, R45, R54 | **0 successi su 5** |
| **Nikkei Gap Continuation (75301)** | `ABTG_GapContinuation.mq5` | gap d'apertura Nikkei | **GIÀ ADOTTATO IN CASA** — è un doppione, non un candidato |

### 📌 Le quattro frasi che ho usato come bussola (citate, non parafrasate)

1. **R42:** _"L'unica cosa che ha sempre pagato è il **RETEST** — entrare sul
   RITORNO al livello DOPO la rottura confermata"_. **Un FVG e un OB sono,
   letteralmente, due modi meccanici di definire quel livello.** È la ragione
   per cui questa caccia ha senso e non è l'ennesimo giro sull'ORB.
2. **R95:** _"NON DICE che lo sweep di liquidità sia morto ovunque"_ — ma
   30/30 in perdita è un fatto, e chiude quel meccanismo lì.
3. **R109:** il difetto che ha prodotto DD del 56% non era il segnale, era
   **lo stop senza pavimento**. Ogni promosso di oggi porta `InpMinSLPts`
   nella sua scheda, e non come optional.
4. **§5B:** filtro **aggiunto dopo** = 0/5; filtro che **È** la strategia =
   **30 celle su 30**. È il criterio numero uno di ordinamento dei promossi.

---

## 0-bis. ⚖️ I CRITERI CONGELATI PRIMA DEI NUMERI

Scritti qui **prima** di aver letto un solo risultato d'autore. Valgono per
ogni candidato del dossier.

**C1 — LA DEFINIZIONE DEVE ESSERE MECCANICA, O È SCARTO.**
Un Order Block "valido" deve avere nel codice: **(a) dimensione**, **(b)
età**, **(c) mitigazione/invalidazione**. Se una delle tre è "si vede a
occhio", il candidato non entra. **Questo criterio da solo ha ucciso 9
candidati su 20.**

**C2 — IL COSTO È IL CANCELLO PRINCIPALE.**
Metro di casa: `R98_CRITERI.md` §3.2 e `METRO_PROP.md` D4 —
**mediana del take LORDO ≥ 3 × spread**, con **spread di riferimento 2,0
punti indice** su D30EUR/U30USD/NASUSD, dichiarato **[SPREAD NON MISURATO]**
(è il lato alto della forchetta 1-2 di `R98_CRITERI.md`: scelta prudenziale).
👉 **Soglia operativa: take mediano ≥ 6,0 punti indice.**
⚠️ E la regola di lettura di `METRO_PROP` D4: **se il rapporto cade fra 2,5×
e 3,5× il verdetto NON si dà** — si misura lo spread col *RealCost Spread P95
Logger* (Code Base 74148, promosso il 23/08 e **ancora mai usato**) e si
rilegge.

**C3 — VALIDAZIONE SOLO A TICK REALI.** Congelato dal mandato. L'OHLC 1-min
su M15 serve a **contare i trade**, mai a dare il segno (R57: cambiando solo
il modello il segno dell'orso si è ribaltato; `+129k finti sul DAX`).

**C4 — PAVIMENTO SL OBBLIGATORIO.** Lezione R109, fotografata: senza
`InpMinSLPts` il lotto sbatte su `SYMBOL_VOLUME_MAX` (66 trade su 743 tagliati
su NASUSD short), i DD **sottostimano** il rischio e non si riscalano
linearmente. Nessun promosso entra nel tester senza pavimento.

**C5 — CONVERSIONE PUNTI.** Su U30USD e NASUSD **1 punto indice = 100 punti
MT5** (R97, due misure indipendenti concordi). Ogni "punto" qui è **punto
indice**, e lo dico ogni volta.

**C6 — CAMPIONE E FINESTRA.** Indici a BCM: storico dal **2024.09.26**
(misurato, `REFERTO_SONDA_STORICO_17-08.md`, stato COMPLETO). Emendamento
della Finestra §A: **≥150 operazioni in IS**. Su M15, con ~56 barre di
sessione al giorno e ~450 sedute, il campione non è il problema — **il regime
sì**: quei 21 mesi sono **un solo regime rialzista**, ed è esattamente la
trappola che ha reso R109 "non misurabile per il merito". Va dichiarato prima,
non dopo.

**C7 — DUE LATI SEMPRE** (regola di Claudio del 25/08): long **e** short si
misurano entrambi, anche quando uno sembra ovvio.

**C8 — NIENTE** griglie, martingale, recovery, hedging, lotto fisso, stop
virtuale, repaint, `WebRequest`, `iCustom` non allegato. Il §4 non si
ammorbidisce per l'entusiasmo.

---

## 1. 📡 CONTROLLO POSITIVO — misurato oggi, 26/08, fonte per fonte

| fonte | HTTP | bersaglio noto verificato oggi | esito |
|---|---|---|---|
| **MQL5 Code Base** | **200** | id **68951**: titolo `Liquidity Sweep H4 - M15 (Swing Highs and Lows)`, autore `OsmarSandovalEspinosa`, `datePublished 2026-03-23T13:23:44`, **`UserDownloads:2393`** (erano **2.383** il 25/08 sullo stesso id → **la pagina è viva, non una cache**) | 🟢 **PASSA in pieno.** 80 pagine (40 experts + 40 indicators) → **3.189 id+titolo unici**. `/en/code/download/<id>` restituisce lo ZIP col `.mq5`: verificato su **6 id** |
| **TradingView** | **200** | tag `/scripts/vwap/?script_type=strategies` → **116 anchor `/script/`** nell'HTML; `pine-facade` restituisce il `source` completo | 🟢 **PASSA.** ⚠️ **La procedura del memo va CORRETTA** — vedi §1-bis |
| **arXiv API** (`https://export.arxiv.org`) | **200** | `all:"price gap" AND cat:q-fin*` → **6 entry vere** con titoli, id e `<published>` (dal 1201.5448 del 2012 al 2608.10321 del 10/08/2026) | 🟢 **PASSA — e non ha niente**, §5 |
| **Quantpedia** | **200** sullo slug noto / **500** sugli slug tentati | `strategies/turn-of-the-month-in-equity-indexes` risponde; la ricerca `?s=gap` rende **133 KB e zero link `/strategies/`** | 🟡 **VIVA MA NON ENUMERABILE.** Confermata la nota del 25/08. **Non ricontrollarla per mandati intraday** |
| **GitHub** (web + API + `gh`) | **403** su `api.github.com/search`; **`gh: command not found`** | — | 🔴 **NULLA — sesta caccia di fila.** ⚠️ Nota tecnica nuova: `raw.githubusercontent.com` risponde **404**, non 403 → l'host **è raggiungibile**, manca solo la **ricerca**. Chi conosce già l'URL di un repo può leggerne i file |
| **SSRN** | **403** (Cloudflare) | — | 🔴 **NULLA — sesta caccia di fila** |

### 1-bis. 🔧 CORREZIONE AL MEMO FONTI — la procedura Pine aveva un difetto

`PROMEMORIA_SBLOCCO_FONTI.md` (agg. 25/08) dice di estrarre gli anchor con
`data-qa-id="ui-lib-card-link-title"` e `href="/script/..."`. **Con quel
pattern oggi ho raccolto ZERO link su 13 tag consecutivi**, e per venti minuti
ho creduto che i tag SMC fossero vuoti. Non lo erano.

**Il motivo, misurato:** l'HTML contiene l'**URL assoluto**, non relativo, e
l'ordine degli attributi è invertito rispetto al memo:

```html
<a href="https://www.tradingview.com/script/L7P3quUz-VWAP-Suite.../"
   data-qa-id="ui-lib-card-link-title" class="title-iHlMXS2Y ...">VWAP Suite | …</a>
```

👉 **Il pattern che funziona oggi** (e che va messo nel memo):
`href="https://www\.tradingview\.com/script/([^"/]+)/"\s+data-qa-id="ui-lib-card-link-title"[^>]*>(.*?)</a>`

**Seconda trappola, nuova:** la **paginazione `/page-N/` NON funziona** con
`?script_type=strategies` — pagina 1, 2 e 3 restituiscono **lo stesso identico
set**. Contato tag per tag: `ict` 11/11/11, `liquidity` 15/15/15,
`priceaction` 20/20/20. **Il tetto per tag è quello che rende la pagina 1**,
e chi vuole più materiale deve **allargare i tag**, non paginare.

**Terza:** il tag `orderblock` con filtro strategie rende **0**; `orderblocks`
(plurale) ne rende **2**. Senza filtro, `orderblock` rende 116 link — **sono
tutti indicatori**. Su TradingView l'SMC è quasi tutto indicatoristica: le
**strategie** backtestabili sono una manciata, ed è un dato in sé.

### Cosa ho sfogliato, dove ha funzionato

- **Code Base — 3.189 titoli unici** (2.000+ indicatori, ~1.190 esperti).
  Filtri di questo mandato: `order.?block|supply.{0,6}demand` → **9 titoli** ·
  `fair.?value|FVG|imbalance|gap` → **22** · `SMC|smart.?money|ICT|BOS|CHoCH|
  market structure|mitigation|breaker` → **16** · `M15|15.?min` → **2**.
  **Unione: 38 titoli SMC-affini.** 🔴 **E di questi 38, gli EA sono DUE**:
  `KSQ Fair Value Gap EA` (71467) e `Nikkei 225 Gap Continuation EA` (75301,
  **già adottato in casa**). Tutto il resto sono **indicatori** — che non si
  backtestano, quindi per il nostro imbuto **non esistono come candidati**,
  solo come **specifiche**. **6 sorgenti `.mq5` scaricati e letti.**
- **TradingView — 15 tag SMC** (`orderblock, orderblocks, fairvaluegap, fvg,
  smartmoneyconcepts, ict, smc, imbalance, marketstructure, breakofstructure,
  supplyanddemand, supplydemand, liquidity, priceaction, gap`) →
  **60 strategie uniche** con slug e titolo. **14 sorgenti Pine scaricati e
  letti riga per riga.**
- **arXiv — 5 query** mirate su OB/FVG/SMC/liquidity sweep. Esito in §5.

---

## 2. 🟢 I PROMOSSI — tre, in ordine di rapporto VALORE / LAVORO

---

### 🥇 P1 — `KSQ Fair Value Gap EA` — **il FVG come motore, già in MQL5**

```
NOME            KSQ Fair Value Gap EA FVG with Regime Detection and Dual SL TP Mode
FONTE / URL     https://www.mql5.com/en/code/71467
                ZIP: https://www.mql5.com/en/code/download/71467  →  KSQ_FVG_EA.mq5
                [rango: SORGENTE MQL5 LETTO RIGA PER RIGA, tutte le 949]
AUTORE / DATA   Adiec7 / "KSQuantitative — KSQuants" (#property copyright, riga 6)
                datePublished 2026-04-04T05:48:37  [VERIFICATO sulla pagina]
POPOLARITA'     UserDownloads: 1.820               [VERIFICATO sulla pagina]
LICENZA         ⚠️ [INCERTO] — nessuna licenza dichiarata né sulla pagina né nel
                sorgente. Valgono i termini generali del Code Base, NON verificati.
                → uso interno di ricerca; attribuzione obbligatoria in testa al .mq5
RIGHE / INPUT   949 righe · 53 `input` veri + 8 `input group`  [CONTATI: grep '^input ']
COPIA IN CASA   biblioteca/sorgenti/KsqFairValueGapEA_Adiec7-KSQuantitative_mql5code71467_2026-08-26.mq5
```

**TESI IN UNA RIGA**
> _"Un Fair Value Gap è una finestra di prezzo che nessuno ha contrattato:
> tre candele in cui il mercato si è mosso troppo in fretta perché ci fosse
> un venditore per ogni compratore. Quel vuoto non ha padroni, e il prezzo
> tende a tornarci a cercare gli ordini che lì non sono stati eseguiti —
> chi entra sul ritorno compra dove la carta è mancata, non dove è finita."_

**MECCANICA — in tre righe, letta nel sorgente**
1. **Il livello:** `ScanFVGs()` (riga 269) scorre le ultime `InpLookback=200`
   barre e marca un FVG rialzista quando `low[i] > high[i-2]`, ribassista
   quando `high[i] < low[i-2]`. **Esclude esplicitamente la barra in
   formazione** (`endBar = ratesTotal - 2`).
2. **Il grilletto:** `CheckFVGEntries()` (riga 308) legge **l'ultima barra
   CHIUSA** (`rates[ratesTotal-2]`) e entra se quella barra è rientrata nella
   zona **e** ha chiuso in direzione (`InpConfirmCandle`), **e** il regime è
   allineato. Ogni FVG porta un flag `isTraded`: **si opera una volta sola per
   gap**.
3. **L'uscita:** SL e TP **veri, mandati al broker** dentro `trade.Buy(...)`,
   in **ATR** (`1,5 × ATR` / `3,0 × ATR`) o in punti fissi; poi **parziale
   50%**, **breakeven** e **trailing** in ATR.

**🔬 LA DEFINIZIONE MECCANICA, ESATTA — e dove è INCOMPLETA**

| requisito C1 | come è nel codice | giudizio |
|---|---|---|
| **dimensione** | `InpMinGapPoints = 10` confrontato con `g_minGapSize = InpMinGapPoints * _Point` (riga 170) | 🔴 **ROTTA sugli indici.** Con C5 (1 punto indice = 100 punti MT5) quei 10 punti valgono **0,1 punti indice**: il filtro è **di fatto spento**. È la stessa classe di difetto del *Nightly QB* (soglia assoluta confrontata con una grandezza che cambia scala per simbolo, `ANALISI_NIGHTLY_PDF` §rettifica). **Da riscrivere in ATR** |
| **età** | ❌ **non esiste.** `FVGData` ha `barIndex` e `timeStart` ma **nessun confronto** li usa | 🔴 **ASSENTE** → viene da P3 |
| **mitigazione** | `UpdateFillStatus()` (riga 740): il gap muore appena il prezzo lo **tocca** o lo **buca**. Binario: 0% o morto | 🟡 **PRESENTE MA GROSSOLANA.** Nessuna profondità di penetrazione → viene da P3 |
| **invalidazione** | inclusa sopra (bucato = `isFilled`) | 🟢 c'è |

**🔍 PERCHÉ NON È UN CADUTO — confronto punto per punto**

| | **R95 sweep+reclaim** | **R42 fade apertura** | **breakout M5** | **P1 (FVG retest)** |
|---|---|---|---|---|
| **da dove nasce il livello** | swing H4 confermato a 21 barre per lato | high/low del box 15'/35' attorno alla campanella | high/low del box 15'/30' | **vuoto di prezzo fra la barra i e la barra i−2**: non è un estremo, è un **intervallo**, e non c'è nessun orologio dentro |
| **cosa attiva il segnale** | il prezzo **buca** il livello e **rientra** | il prezzo **tocca** l'estremo | il prezzo **rompe** il livello | il prezzo **RITORNA** dentro un vuoto lasciato **dopo** un movimento già avvenuto |
| **direzione** | **contro** l'ultimo movimento (reversal) | **contro** (fade) | **a favore** della rottura appena avvenuta | **a favore del movimento che HA CREATO il gap** — è continuazione su pullback, non reversal e non breakout |
| **serve un raid di liquidità?** | **sì, è il motore** | no | no | **NO. Zero riferimenti a sweep, stop-hunt o estremi di sessione in tutte le 949 righe.** Verificato con grep |
| **serve un orario?** | no | **è la strategia** | **è la strategia** | `InpUseSessionFilter = false` di **default**: l'orario è un **optional spento**, non il motore |
| **il TF** | M30→H4 | M5 | M5 | **M15**, e il gradiente R108/R111 (H1>M30>M15) **è un rischio dichiarato**, non un alibi |

> ✅ **La differenza non è di gradazione, è di categoria.** R95 e R42
> comprano **un estremo**; il breakout M5 compra **una rottura**; P1 compra
> **il ritorno dentro un intervallo di prezzo mai contrattato**. E il ritorno
> al livello è, testualmente, l'unica cosa che R42 dice abbia _"sempre
> pagato"_. **P1 è quella famiglia, con una definizione di livello che in
> casa non abbiamo mai avuto.**

**BANDIERE ROSSE §4 — la lettura completa**

✅ **NESSUNA bandiera strutturale.** Verificato con grep su tutto il file:
zero `martingal|grid|averag|recovery|hedge|lot *\*=`, zero `#import`, zero
`WebRequest`, zero `DLL`, zero `iCustom`, zero controllo di account/licenza.
✅ SL e TP **reali al broker**. ✅ **Solo a barra nuova**
(`if(bars == g_prevBars) return;`, riga 232) → nessuna decisione intrabarra.
✅ **Nessun look-ahead**: lo scan esclude la barra in formazione, l'ingresso
legge `ratesTotal-2`. ✅ `isTraded` impedisce ingressi ripetuti sullo stesso
gap. ✅ Guardie **DD giornaliero 5% e totale 10%** già scritte dentro
(`IsDrawdownBreached`, riga 885) — sono **letteralmente i muri prop**.

⚠️ **I quattro difetti veri, e sono tutti di GESTIONE o di taratura** (§5F:
esattamente la parte che sappiamo rifare):

| # | difetto | la riga che lo prova | costo |
|---|---|---|---|
| 1 | **`InpLotMode = LOT_FIXED` di DEFAULT**, lotto 0,10 | riga 123-124 | 🟢 **zero: `LOT_RISK` con `InpRiskPercent` c'è già** (riga 469-482, e la formula usa `tickValue/tickSize`, che è quella giusta). Si **pinna** nel file prova |
| 2 | **NESSUN `OnTester()`** | grep su tutto il file: 0 occorrenze | 🔴 **il driver RIFIUTA di partire** (`prove/LEGGIMI.md`: _"EA senza OnTester: il driver rifiuta di partire"_). **Va aggiunto. È il primo lavoro** |
| 3 | **pavimento SL assente** — c'è solo il minimo del broker (`stopLevel + spread`, riga 425) | riga 413-430 | 🔴 **è ESATTAMENTE il difetto R109.** Serve `InpMinSLPts` vero (C4) |
| 4 | **corsa fra `UpdateFillStatus` e `CheckFVGEntries`** | riga 256 usa `rates[ratesTotal-1]` (barra **in formazione**), riga 313 usa `rates[ratesTotal-2]` (barra **chiusa**) | 🟡 se la barra nuova **apre dentro** la zona, il gap viene marcato `isFilled` **prima** che l'ingresso lo veda → segnale perso in modo silenzioso. **Da unificare su barre chiuse** |

🟠 **E un difetto di definizione, che va detto separato:** `priceInZone`
(riga 330-331) accetta un tocco fino a **una intera altezza di gap SOTTO** la
zona (`lastBar.low >= lower - (upper-lower)`). Non è un bug — è una scelta
generosa — ma **allarga il segnale** e va reso un parametro, non una costante.

🟠 **Il regime è appiccicato, e lo dico prima di misurarlo.**
`InpRegimeFilter = REGIME_BOTH` di default = EMA(50/200) su H4 **+** ADX ≥ 20.
È **lo schema che in casa fa 0 successi su 5** (§5B), e l'ADX è uno dei
cinque. 👉 **Il round si disegna con `REGIME_NONE` come BASELINE** e l'EMA/ADX
come **gradini di ablazione** — non come parte del motore. Se il motore nudo
non regge, il filtro non lo salva: R101 lo ha già misurato.

**💰 COSTO (C2) — il cancello, calcolato prima di accendere il tester**
- TP di default = `3,0 × ATR(14)` su M15.
- Sul DAX M15 [STIMA, da misurare al PASSO 0] ATR(14) è dell'ordine di
  **8-15 punti indice** → take **24-45 punti indice**.
- Soglia C2 = **6,0 punti indice**. 👉 **Margine 4×-7,5×: il cancello passa
  con comodo, e non per un pelo.**
- ⚠️ **Ma il take NON è il numero che conta**: conta la **mediana del take
  LORDO realizzato**, che include gli stop e i parziali. **Si misura al PASSO
  0, non si stima.** E `InpTPATRMult` va spazzolato **verso l'alto** (2,5 /
  3,0 / 3,5), mai sotto: sotto c'è il muro dell'attrito.

**📊 FREQUENZA [STIMA — NON MISURATA, e il PASSO 0 esiste per questo]**
Ragionamento dichiarato, così che chiunque possa falsificarlo:
D30EUR M15 in sessione cash = **~56 barre/seduta**. Un FVG richiede tre barre
di spinta consecutive con `low[i] > high[i-2]`: **[IPOTESI] 2-4% delle
barre** → **1-2 gap per lato al giorno**. Con `isTraded` (uno per gap) e la
condizione di ritorno + candela di conferma, **[STIMA] 0,3-1,0 operazioni per
seduta per lato**, cioè **~150-500 operazioni in 21 mesi per lato**.
🔴 **Il numero 2-4% è un'ipotesi mia, non una misura: se al PASSO 0 esce
0,3%, il candidato non è misurabile e va chiuso lì.** Se esce 10%, va stretto
il filtro dimensione. **La frequenza è il primo dato del round, prima di
qualunque PF.**

**🔧 COSA TERREI / COSA RIFAREI**

**DA TENERE (il motore, ~120 righe):** rilevazione FVG a tre barre con
esclusione della barra viva · struttura `FVGData` con `isFilled`/`isTraded` ·
ingresso sul ritorno con candela di conferma · SL/TP veri al broker in ATR ·
**parziale 50% + breakeven + trailing** (è già la ricetta di casa) ·
**guardie DD giornaliero e totale** (già i muri prop).

**DA RIFARE (la gestione e la taratura):**

| difetto | cosa ci mettiamo |
|---|---|
| soglia gap in `_Point` | **`InpMinGapATR`**: gap ≥ X × ATR(14). Si scala da solo fra DAX, Nasdaq ed EURUSD |
| nessun pavimento SL | **`InpMinSLPts`** (C4, R109) |
| nessun `OnTester` | `OnTester` standard di casa + export per-trade (serve al DD di portafoglio, `ROTTA_PROP` punto 2) |
| corsa sulla barra viva | fill status valutato **solo su barre chiuse** |
| 53 input | **sfrondare al tetto ~15**: alert/push/dashboard/`InpTPMode`/`InpSLPoints`/`InpTrailPoints` si pinnano e **non entrano nello sweep** |
| `InpMaxOpenTrades=3` con `InpMaxTradesPerDir=1` | su conto **HEDGING** significa long+short aperti insieme = copertura di fatto. **Tetto a 1 posizione totale** |
| `ORDER_FILLING_FOK` (riga 168) | su BCM va verificato: se il simbolo non ammette FOK gli ordini vengono **rifiutati in silenzio** |

**🏛️ IN OTTICA PROP**
Questo motore è **il più prop-friendly dei tre, e non per opinione**: le
guardie **DD giornaliero 5%** e **DD totale 10%** sono già dentro il sorgente,
con i valori esatti dei muri. Il rischio da sorvegliare è **la
concentrazione**: gli FVG nascono in grappoli sulle giornate di spinta, quindi
**più segnali nella stessa mattina, tutti dallo stesso lato**. Serve un
**cap di operazioni al giorno** (`METRO_PROP` C6) e va misurata la **peggior
giornata**, non solo il DD totale — il metro è **−2,06%** (R51) e il muro
−5,00%. 🟢 **Scorrelazione: alta.** Nessuna sedia viva usa un vuoto di prezzo
come livello, e su M15 indici oggi gira solo `MaxMinNotte DAX Short` (notte
europea): **fascia oraria diversa, livello diverso, lato diverso.**

**PUNTEGGIO**
- [2] semplicità — il motore vero sono ~120 righe e **3 parametri di segnale**
  (dimensione, lookback, conferma). I 53 input sono contorno, non logica
- [2] il filtro **È** il motore — il FVG **è** la strategia; EMA/ADX sono
  optional spegnibili con un enum, e nel round partono **spenti**
- [2] tesi di mercato scrivibile — sì, ed è sopra
- [2] riempie un BUCO — **zero EA FVG in flotta**, verificato sui sorgenti
- [1] testabile senza riscritture — **è già MQL5** (zero porting), ma serve
  `OnTester` + pavimento SL + soglia in ATR: **mezza giornata, non un round**

## **VERDETTO: 🟢 PROVA SUBITO — 9/10**
**PERCHÉ:** è l'unico dei venti candidati letti che si può mettere nel tester
**oggi**, con una tesi scrivibile, un motore costitutivo e un buco di
portafoglio vero. I suoi quattro difetti sono **tutti** nella metà del lavoro
in cui questo progetto è bravo.

---

### 🥈 P2 — `SMC Pro BTC - ICT Order Blocks & FVG [DOE]` — **l'ORDER BLOCK, definito bene**

```
NOME            SMC Pro BTC - ICT Order Blocks & FVG [DOE]
FONTE / URL     https://www.tradingview.com/script/QMvHkvdQ-SMC-Pro-BTC-ICT-Order-Blocks-FVG-DOE/
                Pine via pine-facade  [SORGENTE LETTO RIGA PER RIGA, 523 righe]
AUTORE / DATA   DOE_Trade  [VERIFICATO nel <title> della pagina]
                data di pubblicazione: ⚠️ [INCERTO] — non presente nell'HTML
                e il JSON pine-facade rende `created` vuoto. NON la invento
POPOLARITA'     ⚠️ [INCERTO] — non letta
LICENZA         ⚠️ [INCERTO] — nessuna intestazione di licenza nel sorgente.
                `scriptAccess: open_no_auth` [VERIFICATO nel JSON] = sorgente
                pubblico. Attribuzione a DOE_Trade obbligatoria in qualunque .mq5
RIGHE / INPUT   523 righe · 19 `input.` totali, di cui **9 di logica**
                (mode, htfTF, mtfTF, swingLen, obLookback, sweepWindow,
                rrRatio, slBuffer, pdThreshold) — **sotto il tetto di casa**
COPIA IN CASA   biblioteca/sorgenti/SmcProOrderBlocksFvg_DOE_Trade_tvQMvHkvdQ_2026-08-26.pine
```

**TESI IN UNA RIGA**
> _"Quando il prezzo rompe una struttura, l'ordine grosso che l'ha spinta non
> è entrato tutto: l'ultima candela contraria prima dell'impulso è il punto
> in cui quel flusso stava ancora accumulando. Il ritorno lì non è un rimbalzo
> tecnico — è il resto dell'ordine che cerca di essere eseguito allo stesso
> prezzo."_

**MECCANICA — in tre righe**
1. **Contesto:** struttura direzionale su **H4** e conferma su **H1**
   (`f_structureTrend` via `request.security(..., lookahead = barmerge.lookahead_off)`,
   righe 130 e 134), più uno **sweep recente** entro `i_sweepWindow = 20` barre.
2. **Il livello (il motore):** al **BOS** (`ta.crossover(close, lastSH)`) si
   cerca a ritroso, entro `i_obLookback = 15` barre, **la prima candela
   ribassista** (`close[i] < open[i]`): il suo `high`/`low` **è** l'Order
   Block. In parallelo lo stesso codice marca gli FVG a tre barre.
3. **Il grilletto e l'uscita:** ingresso quando il prezzo **rientra nell'OB o
   nel FVG** con candela in direzione; **SL al bordo della zona** meno
   `i_slBuffer = 0,3%`; **TP a `i_rrRatio = 2,0` R**.

**🔬 LA DEFINIZIONE MECCANICA, ESATTA — è la migliore delle venti lette**

```pine
// riga 195-201 — LA definizione di Order Block, tutta qui
if bullBOS
    for i = 1 to i_obLookback
        if close[i] < open[i]                 // ultima candela CONTRARIA
            bullOB_top := high[i]             // dimensione = il range di QUELLA candela
            bullOB_bot := low[i]
            bullOB_valid := true
            break                             // la PRIMA che trova, non la migliore
// riga 217-220 — invalidazione
if bullOB_valid and close < bullOB_bot
    bullOB_valid := false
```

| requisito C1 | come è nel codice | giudizio |
|---|---|---|
| **dimensione** | il range `high[i]-low[i]` della candela stessa: **auto-scalante per definizione**, nessuna costante | 🟢 **meccanica e pulita** |
| **età** | il tetto `i_obLookback = 15` barre limita **quanto indietro si cerca**; l'OB poi vive finché non è invalidato | 🟡 **c'è un tetto, non c'è un'età minima** → il complemento è P3 |
| **mitigazione** | `close < bullOB_bot` → morto. **Chiusura**, non ombra: un'ombra che perfora non uccide il livello | 🟢 **presente, e la scelta "chiusura" è quella robusta** |
| **origine** | **BOS obbligatorio**: un OB senza rottura di struttura **non esiste**. È ciò che impedisce di chiamare "order block" qualunque candela rossa | 🟢 **è il pezzo che distingue una definizione da un disegno** |

**🔍 PERCHÉ NON È UN CADUTO — e dove invece SFIORA un caduto, detto per primo**

🔴 **L'onestà prima dell'entusiasmo: dentro P2 c'è un cancello di sweep.**
```pine
bullSweep = not na(lastSL) and low < lastSL and close > lastSL   // riga 178
```
**Questo è, letteralmente, la definizione di R95** (buca il minimo, chiude
sopra). Va dichiarato, non nascosto.

**Ma la differenza è strutturale e si legge in due righe:**

| | **R95** | **P2** |
|---|---|---|
| lo sweep **è** | **il grilletto d'ingresso**: si compra il reclaim | **una precondizione** che apre una finestra di 20 barre |
| l'ingresso è | il reclaim stesso | il **ritorno nell'Order Block** — che può arrivare 1 o 20 barre dopo, a un **prezzo diverso** |
| lo stop è | oltre l'estremo dello sweep | al **bordo della zona OB**, molto più vicino |
| il livello è | uno swing H4 a 21 barre per lato | **il range di una singola candela** identificata da un BOS |

👉 **La prova che decide, e va scritta nei criteri del round:** se lo sweep
fosse il motore, **spegnerlo dovrebbe uccidere l'edge**. Il round deve girare
`sweepWindow` come **gradino di ablazione** (motore nudo / +sweep). Se il
motore nudo perde e solo col cancello di sweep guadagna, **è R95 con un
cappello e va chiuso**. Se il motore nudo regge, lo sweep è contorno.
**Senza questa ablazione P2 non si può giudicare** — e lo dico prima dei
numeri, non dopo.

| | R42 fade | breakout M5 | **P2** |
|---|---|---|---|
| direzione | contro | a favore della rottura | **a favore della struttura HTF**, su pullback |
| il livello | estremo del box d'apertura | estremo del box d'apertura | **una candela specifica**, selezionata da un evento (il BOS) |
| l'orario | **è la strategia** | **è la strategia** | **assente**: nessun `input.session` in 523 righe |

**BANDIERE ROSSE §4**
✅ `calc_on_every_tick = false` (riga 70) → **decide su barre chiuse**.
✅ `request.security(..., lookahead = barmerge.lookahead_off)` **esplicito**
su entrambi i TF (righe 130, 134) → **niente look-ahead**.
✅ `ta.pivothigh(high, len, len)` è un pivot **confermato**, ritardato di
`len` barre → **niente repaint**.
✅ `pyramiding = 0`, una posizione per volta, SL e TP veri.
✅ L'autore ha **modellato i costi**: `commission_value = 0.075`,
`slippage = 3` (righe 63-65). Raro, e va detto.
❌ **`default_qty_value = 10` % dell'equity in nozionale = NON è rischio per
operazione.** Bandiera §4 "lotto fisso" nella sostanza. → gestione, si rifà.
❌ **`i_slBuffer` in PERCENTUALE del prezzo** (0,3%): tarato su BTC. Su
D30EUR a ~24.000 sono **72 punti indice** di solo buffer. → si rifà in ATR.
❌ Nessun parziale, nessun breakeven: TP secco a 2R. → si rifà.

🔴 **E l'obiezione strutturale, che vale un punto in meno:** `longSignal`
(riga 268) è un **AND di cinque cancelli** (HTF + MTF + sweep + zona +
candela). È una macchina a confluenze, e le confluenze sono il modo più
elegante di sovradattare. **Il round deve accenderli uno alla volta**, con il
motore nudo (BOS → OB → ritorno) come baseline.

⚠️ **`i_mode` è una TESI MESSA FRA GLI INPUT** — "Aggressive" o "Selective"
cambiano *se* esiste il filtro premium/discount. È lo stesso difetto per cui
il 22/08 abbiamo scartato `003 - Weekly Day Reversal`. **Nel porting si sceglie
UNA modalità e si pinna**: non si lascia scegliere all'ottimizzatore.

**💰 COSTO (C2)** — TP = 2 × la distanza dal bordo dell'OB. Su M15 indici la
zona di un OB è tipicamente **[STIMA] 5-20 punti indice** → take **10-40
punti indice**, contro la soglia di **6,0**. 🟡 **Passa, ma il bordo basso
della forchetta (10 punti = 5×) è più vicino al muro di quello di P1.**
Il filtro `InpMinOBpts` in ATR è **obbligatorio**, non opzionale: un OB troppo
sottile produce un take che non paga il viaggio.

**📊 FREQUENZA [STIMA — NON MISURATA]** — servono BOS su M15 con `swingLen=10`
(pivot confermato a 10+10 barre): **[IPOTESI] 1-3 BOS per lato al giorno**,
ma il ritorno nell'OB entro la sua validità è **molto** più raro.
👉 **[STIMA] 0,1-0,4 operazioni/seduta/lato** = **~30-130 operazioni in 21
mesi per lato**. 🔴 **Sotto la soglia dei 150 dell'Emendamento §A.**
**È il rischio numero uno di P2, e va misurato al PASSO 0 PRIMA di scrivere
la griglia**: se la frequenza è quella, o si allarga (swingLen più corto, OB
anche senza sweep) o si scende a M15 su **più simboli** per fare campione.

**🔧 COSA SERVE PER IL PORTING — è una RISCRITTURA, non un porting (§3D)**
- **Riscrittura MQL5:** ~250-350 righe. Su un chassis che **abbiamo già**:
  `ABTG_LiquiditySweep.mq5` ha di serie `InpSLMode` strutturale con buffer
  ATR, `InpTP1_RR` per il parziale, `InpMaxSpreadToStopPercent` (R55),
  `InpUsaGuardian` e il tetto livelli anti-overflow. **Il pezzo nuovo è solo
  il motore OB.**
- `ta.pivothigh/pivotlow` → funzione a barre chiuse (già scritta lì dentro).
- `request.security` H4/H1 → `CopyRates` su `ENUM_TIMEFRAMES` con la regola
  di casa: **si legge la barra 1, mai la 0**.
- SL: da **% del prezzo** a **bordo OB + buffer ATR**, con **pavimento
  `InpMinSLPts`** (C4).
- Sizing: da `percent_of_equity` a **rischio % sulla distanza di stop**.
- Gestione: **parziale 1R + breakeven + runner 2R** (la ricetta DAX/Dow).
- 🕐 **Stima onesta: 1-1,5 giornate di lavoro** prima che esista un `.mq5`
  compilabile. **P2 non è pronto per lunedì mattina, P1 sì.**

**🏛️ IN OTTICA PROP**
🟢 **La geometria è la più prop-friendly delle tre**: stop **stretto** (bordo
di una singola candela) e take a 2R = **R:R alto con perdita piccola**, che
è il profilo che tiene basso il DD giornaliero. 🔴 **Il prezzo lo paga in
frequenza**: pochi trade = più giorni per passare la challenge (R106:
mediana **16 giorni** con la flotta attuale). 🟡 **E lo stop stretto è una
lama a due tagli**: R109 ha misurato slippage di **21,5 punti oltre lo stop**
su NASUSD — su uno stop da 8 punti indice quello **raddoppia la perdita**.
Il pavimento SL qui non è pignoleria contabile, **è il punto in cui il
candidato vive o muore**.

**PUNTEGGIO**
- [2] semplicità — 9 input di logica, sotto il tetto
- [1] il filtro È il motore — **l'OB è costitutivo**, ma è avvolto in un AND
  di cinque cancelli e uno di quelli è lo sweep di R95. **Un punto in meno,
  e l'ablazione è obbligatoria**
- [2] tesi scrivibile — sì
- [2] riempie un BUCO — **zero EA Order Block in flotta.** È il meccanismo
  che il prompt esterno chiede per primo e che non abbiamo per niente
- [1] testabile senza riscritture — **no: è Pine.** 1-1,5 giornate

## **VERDETTO: 🟡 PROVA DOPO P1 — 8/10**
**PERCHÉ:** è la migliore definizione di Order Block che ho letto oggi — la
sola che leghi il livello a un **evento** (il BOS) invece che a un disegno. Ma
costa una riscrittura, va ablato dal cancello di sweep prima di poter essere
giudicato, e **rischia di non fare campione**. Si apre **dopo** che P1 ha
dato un numero.

---

### 🥉 P3 — `Order Block Volumatic FVG Strategy` — **promosso come SPECIFICA, scartato come EA**

```
NOME            Order Block Volumatic FVG Strategy — Mitigation%, Volume & Age + SL/Trailing
FONTE / URL     https://www.tradingview.com/script/PjH7wg3n/
                Pine via pine-facade  [SORGENTE LETTO RIGA PER RIGA, 345 righe]
AUTORE / DATA   TagsTrading  [VERIFICATO nel <title>]
                derivato dichiarato da "Volumatic Fair Value Gaps [BigBeluga]"
                data: ⚠️ [INCERTO], non presente nell'HTML
LICENZA         🟢 **CC BY-NC-SA 4.0** — dichiarata nel sorgente, riga 4.
                ⚠️ **NC = Non Commercial.** Per uso di ricerca interna va bene;
                l'attribuzione a TagsTrading e a BigBeluga è OBBLIGATORIA
RIGHE / INPUT   345 righe · 29 `input.`  (quasi il doppio del tetto)
COPIA IN CASA   biblioteca/sorgenti/OrderBlockVolumaticFvg_TagsTrading_tvPjH7wg3n_2026-08-26.pine
```

**🔴 PERCHÉ NON È UN EA CANDIDATO — le tre bandiere, subito**
1. **`calc_on_every_tick = true`** (riga 23) → §4 repaint, per giunta
   combinato con `request.security_lower_tf` per il volume intrabarra.
2. **`default_qty_type = strategy.percent_of_equity, default_qty_value = 100`**
   (riga 24) → **il 100% dell'equity a ogni operazione**.
3. **`slPercent = 30`** (riga 60) → **stop loss al 30% del prezzo.** Su
   D30EUR sono ~7.200 punti indice. È un EA nato su cripto e non ha nessun
   senso su un indice.

**🟢 PERCHÉ LO PROMUOVO LO STESSO — è l'unico dei venti che risponde in pieno
al C1.** Il mandato chiede una definizione meccanica di **dimensione, età e
mitigazione**. **P1 non ha età e ha una mitigazione binaria. P2 non ha età
minima. Questo le ha tutte e tre, scritte in codice:**

**(a) DIMENSIONE — adattiva, e questa è l'idea migliore della giornata**
```pine
// righe 88-90
float diff      = close[1] > open[1] ? (low - high[2]) / low * 100
                                     : (low[2] - high) / high * 100
float sizeFVG   = diff / ta.percentile_nearest_rank(diff, 1000, 100) * 100
bool  filterFVG = sizeFVG > 10          // ≥10% del gap PIÙ GRANDE delle ultime 1000 barre
```
> 🎯 **La soglia non è una costante: è un percentile mobile.** Il gap deve
> valere almeno il 10% del massimo delle ultime 1000 barre. **Si ritara da
> sola** fra DAX e EURUSD, fra il 2024 tranquillo e il 2025 volatile — ed è
> l'antidoto esatto al difetto n.1 di P1 (`InpMinGapPoints` in `_Point`) e
> alla classe di difetto del *Nightly QB*. **Questo pezzo va copiato.**

**(b) ETÀ — un parametro vero, con un default sorprendente**
```pine
int minAgeLong = input.int(40, "Long: min age (bars)")   // riga 52
...
if useAgeFilter
    ok := ok and (ageBars >= minAgeLong)                 // riga 265-266
```
> **Il gap deve avere almeno 40 barre di vita prima che il suo ritorno valga
> come segnale.** Su M15 sono **10 ore**. È una regola non ovvia e
> **falsificabile in una griglia** (0 / 10 / 40 / 100 barre): o l'età conta,
> o non conta, e il tester lo dice. **Né P1 né P2 possono rispondere a questa
> domanda, perché non hanno il parametro.**

**(c) MITIGAZIONE — continua, non binaria**
```pine
// righe 127-137: f_mitigation_pct → 0..100
pct := src >= top ? 0 : src <= bot ? 100 : ((top - src) / height) * 100
...
bool ok = m >= longThreshold        // default 5%
```
> **Quanto in profondità il prezzo è rientrato nel vuoto, in percentuale
> dell'altezza del vuoto.** P1 sa solo "toccato sì/no". Questo sa "toccato al
> 5%, al 50%, al 90%" — e la soglia è **spazzolabile**. 🎯 **Ed è la domanda
> di mercato che un motore FVG deve saper porre**: si compra sul bordo del
> vuoto o in mezzo?

**(d) INVALIDAZIONE e SOVRAPPOSIZIONE** — il box muore quando il prezzo lo
attraversa del tutto (riga 172); i box **sovrapposti** vengono rimossi (righe
196-214); tetto a **10 box vivi** (riga 217). **Anche l'igiene della lista è
meccanica.**

**🔍 PERCHÉ NON È UN CADUTO** — non è mai stato un candidato di famiglia:
non c'è box d'apertura (R42), non c'è rottura da inseguire (M5), non c'è
sweep di estremi (R95). È **P1 con tre manopole in più**.

**💰 COSTO / 📊 FREQUENZA** — non si applicano: **non lo porto nel tester
come EA.** Le sue tre definizioni entrano nella **griglia di P1**, e lì il
costo è quello di P1.

**🔧 COSA SERVE — poche ore, non un round**
Tre input nuovi dentro il P1 adottato:
`InpMinGapPct` (percentile mobile su N barre) · `InpMinAgeBars` ·
`InpMinMitigationPct`. Tutte e tre **spazzolabili**, tutte e tre con una
domanda di mercato dietro.
⚠️ **Il volume NON si porta**: `request.security_lower_tf` sul volume è
tick volume su FX (regola di casa: non valido) e su CFD indici non è volume
regolamentato. **Sugli indici resta legittimo come `02_volumi` di R101, ma
è un'altra strada e non entra qui.**

**🏛️ IN OTTICA PROP** — indiretto ma pesante: **il filtro di età e quello di
mitigazione sono i due modi di ridurre il numero di segnali senza cambiare il
motore.** Meno segnali correlati nella stessa mattina = meno rischio contro
il muro giornaliero da −5.000. Se P1 al PASSO 0 spara troppo, **è qui che si
gira la manopola** — non abbassando il rischio, che non riduce la
correlazione.

**PUNTEGGIO** — [2] semplicità delle tre definizioni · [2] sono
**costitutive** del motore, non filtri appiccicati · [2] tesi scrivibile ·
[2] riempie un buco (il buco è **dentro P1**) · [1] serve un innesto.
## **VERDETTO: 🟢 PROMOSSO COME SPECIFICA — 9/10 come spec, SCARTO come EA**
**PERCHÉ:** è l'unica fonte, su venti, che dica in codice **cosa rende valido
un FVG**. Le sue tre manopole trasformano la griglia di P1 da "spazzolata" in
**tre domande di mercato con risposta misurabile**.

---

## 3. 🗑️ GLI SCARTATI — uno per riga, col motivo che lo prova

### 3.1 MQL5 Code Base — letti nel sorgente

| # | candidato | id | motivo |
|---|---|---|---|
| S1 | **`Nikkei 225 Gap Continuation EA`** (Francesc Jordi Mallol Nolden, 24/07/2026, DL 493) | [75301](https://www.mql5.com/en/code/75301) | 🔵 **DOPPIONE DI CASA — già adottato**: `mql5/Experts/ABTG_GapContinuation.mq5` lo attribuisce riga per riga (dossier `CACCIA_2026-08-16_C_NIKKEI_GAP.md`). E il gap d'apertura **non è** un FVG a tre candele. **Non è uno scarto di merito: è già dentro** |
| S2 | **`Unmitigated Order Block Matrix`** (Amanda V \| KayruYuta, 31/03/2026, DL 530) | [71269](https://www.mql5.com/en/code/71269) | 🟠 **SCARTATO come EA, TENUTO come definizione.** È un **indicatore**: zero logica di trading, quindi **non backtestabile** — e per giunta `if(MQLInfoInteger(MQL_TESTER)) return(rates_total)` (riga 50) **si autodisattiva nel tester**. ✅ **Ma la sua definizione di OB è la più compatta che ho letto e la riporto agli atti**: OB = la candela **immediatamente** precedente a una candela di impulso, dove l'impulso richiede **(a)** `tick_volume > 1,5 × media(5)` **e (b)** `\|close−open\| ≥ 50 punti`; mitigazione = **primo tocco** del box. ⚠️ Entrambe le soglie sono **assolute** (stesso difetto di P1), e il volume è **tick volume** — legittimo solo sugli indici |
| S3 | `Market Structure SMC: Swings, BOS/CHoCH, Order Blocks, FVG, QML` (YeohJooYam, 02/07/2026, DL 1.249) | [74575](https://www.mql5.com/en/code/74575) | 🔴 **indicatore, 284 righe, zero ordini.** Disegna, non opera. Nessun EA da cui partire |
| S4 | `ICT Silver Bullet and Macro Imbalance Filter` (KayruYuta, 30/03/2026, DL 500) | [71186](https://www.mql5.com/en/code/71186) | 🔴 **indicatore** (123 righe). E il meccanismo è **una finestra oraria** (Silver Bullet = 10:00-11:00 NY): **la strategia È un orario**, cioè la stessa forma di R42/R45 |
| S5 | `Order Block Mitigation Tracker` (adeolu01, 12/08/2026, DL 309) | [76068](https://www.mql5.com/en/code/76068) | 🔴 **indicatore**, traccia e basta |

### 3.2 Code Base — scartati al primo taglio (titolo + sezione, sorgente non aperto, e lo dichiaro)

Dei **38 titoli SMC-affini** trovati sui 3.189, **33 sono indicatori** — e un
indicatore, per il nostro imbuto, **non è un candidato**: senza EA non c'è
backtest, e senza backtest non c'è verdetto. Elencati per non ricercarli:
`SMC Order Block Detector` (75679) · `XAUUSD MTF Liquidity OB Reversal
Breakout` (75965) · `Interactive Supply and Demand Zone Trading Prototype`
(75178) · `ExMachina SupplyDemand` (70709) · `Shved Supply and Demand`
(29395, 36571) · `Fair Value Gap Detector` (76538) · `Multi-Timeframe FVG
Depth Meter` (76019) · `The Quantitative Microstructure Matrix` (75332) ·
`FVG Imbalance Marker Helper` (74209) · `fair value gap/imbalance` (73418) ·
`Gold FVG Finder` (73049) · `Imbalance Finder (FVG)` (71540) · `Fair Value Gap
FVG MT5` (71423) · `SMC Fair Value Gap Auto-Detector` (70854) · `FVG based
Momentum Detection` (57377) · `Fair Value Gap (FVG) Indicator` (51977) ·
`Fair Value Gap` (48116) · `Candlestick Wick Imbalance` (47370) · `Swing
Detector by Pullback (SMC)` (76451) · `SniperGold SMC ProPlus` (75466) ·
`Institutional Market Reversal - The SMC way` (73414) · `Smart Money Concepts`
(71497) · `ICT True Open and Power of 3` (71047) · `SMC Liquidity Sweep and
Rejection Detector` (71025) · `ExMachina Smart Money Concepts` (70826) ·
`Market Structure Onnx` (68535) · `ZigZag BOS CHoCH Detection` (65980) ·
`Risk management and bot ict daily bias` (59714) · `Weekend Gap Statistics`
(72596) · `News Spread Risk Dashboard` (68122) · `Tuyul GAP` (60347) ·
`Gap DM` (23223) · `Exp_i-GAP` (14346).

> 📌 **E questo è il dato più utile del paragrafo, da mettere agli atti:**
> **su 3.189 sorgenti del Code Base, gli EA SMC con sorgente sono DUE, e uno
> lo abbiamo già.** Il Code Base, per Order Block e Fair Value Gap, **è
> esaurito**. Non ricontrollarlo: si ricontrolli solo per **id nuovi** dopo
> il 26/08/2026.

### 3.3 TradingView — 14 Pine letti riga per riga, 11 scartati

| # | script | slug | meccanismo | la riga che lo prova |
|---|---|---|---|---|
| S6 | **`Strict 1-Trade/Day SMC + ORB`** (Ross1992gg) | [AeYVHi9k](https://www.tradingview.com/script/AeYVHi9k-Strict-1-Trade-Day-SMC-ORB/) | ORB 09:30-09:45 NY → CHoCH entro 5 barre → FVG → 1 trade/giorno, EOD | 🔴 **È L'ORB CON LA VERNICE SMC.** `if canEnter and close > orh and chochBullValid and bullFVG` (riga 86): **il motore è `close > orh`**, cioè la rottura del box d'apertura — ~**210 celle a tick reali** in casa, R45 **0/48**. CHoCH e FVG sono **due filtri appiccicati a un motore già sepolto** = lo schema 0/5 del §5B. **In più un difetto vero**: la R della gestione è `orbRange` (riga 63) ma lo **stop reale** è un trail ATR×3 (riga 93) → **il "parziale a 1R" non è a 1R**. 🟢 **Da tenere agli atti solo la GESTIONE**: 1 trade/giorno + cutoff d'ingresso + uscita EOD è il profilo prop più pulito visto oggi |
| S7 | **`Tomukas Elite SMC`** (Tomukasss) | [83hmaEOQ](https://www.tradingview.com/script/83hmaEOQ-Tomukas-Elite-SMC/) | sweep del pivot low con candela di rifiuto → **MSS** → FVG nella spinta → ingresso sul **retest** del FVG | 🟠 **IL PIÙ DOLOROSO DA SCARTARE, ed ecco perché lo faccio.** La macchina a stati a 3 passi è ben scritta e la gestione è **già la nostra** (TP1 50% a 1R + SL a BE + runner). **Ma:** (a) il **primo cancello è lo sweep di R95** (`low < lastPl and close > lastPl`, riga 66) — qui **non ablabile**, perché senza sweep `sweepType` resta 0 e **la macchina non parte proprio**: è nel motore, non è un gradino; (b) `slPrice := sweepExtremum` (riga 170) = lo stop torna **fino al minimo dello sweep**, che dopo MSS + retest può essere lontanissimo → **R non controllata, nessun pavimento, nessun tetto**: è la ricetta di R109 al contrario; (c) **AND di sei cancelli** con **ADX ≥ 20 dentro** — l'ADX è uno dei cinque 0/5; (d) `default_qty_value = 10`, nessun rischio %. 👉 **Se un giorno si vuole riaprire, si riapre come VARIANTE DI P2** (P2 lo sweep lo ha come finestra ablabile, non come innesco), **mai come EA a sé** |
| S8 | **`Fair Value Gap Continuation Framework`** (AIScripts) | [4uYwBCmZ](https://www.tradingview.com/script/4uYwBCmZ-Fair-Value-Gap-Continuation-Framework/) | FVG a tre candele + EMA50 + SL ATR + TP 2R, in **65 righe e 4 input** | 🟠 **SCARTATO PER UN BUG, e il bug è istruttivo.** Il commento dice `// Retest Logic`, ma: alla barra di formazione `bullTop := low` (riga 28), quindi `bullRetest = low <= bullTop and close > bullTop` (riga 36) è **vera sulla barra stessa** (`low <= low` è sempre vero). **Non entra sul ritorno: entra sulla chiusura della terza candela del gap.** Non è un retest, è un **momentum di continuazione**. In più: `bullTop` viene **sovrascritto** da ogni nuovo FVG (nessuna lista, nessuna invalidazione, nessuna età), `strategy.exit` con `atrValue` ricalcolato a ogni barra → **lo stop si muove in entrambe le direzioni**, e nessun sizing. 🟢 **Ma il bug vale come IPOTESI**: "entrare sulla **formazione** del gap invece che sul **ritorno**" è un **braccio di ablazione gratuito** per il round di P1, e distingue continuazione da mean-reversion **con lo stesso rilevatore** |
| S9 | `Captain Backtest Model [TFO]` (tradeforopp, **MPL 2.0** — l'unica licenza chiara della giornata) | [tOQ8gnxj](https://www.tradingview.com/script/tOQ8gnxj-Captain-Backtest-Model-TFO/) | range 06:00-10:00 NY; se entro le 11:15 il prezzo ne prende un estremo → **bias in QUELLA direzione**; poi ritracciamento obbligatorio; poi ingresso; EOD | 🟠 **FUORI BERSAGLIO (non è OB né FVG) ma va registrato, perché è l'ipotesi speculare di R95.** R95 e l'arXiv §4.3 misurano il **reversal** dopo il raid: 30/30 in perdita, T = −14,12. Questo fa il **contrario**: il raid **conferma** la direzione. ⚠️ **E l'aritmetica dice di NON entusiasmarsi**: se il reversal ha netto −2,20 con attrito c, il lordo speculare vale `+2,20 − c` e il **netto** speculare `2,20 − 2c`; con `c ≈ 2,0` fa **−1,8**. **Lo specchio di una strategia perdente non è una strategia vincente**, perché l'attrito si paga in entrambi i versi. Scarto: (a) non è il mandato di oggi; (b) resta un **breakout di box di sessione**, e chi lo riapre deve prima rispondere alla domanda già posta il 25/08 su `DataTraderH4Breakout` — _perché un box di 4 ore sarebbe diverso dai livelli che R95 ha bocciato_; (c) `risk = 25` / `reward = 75` in **punti assoluti** e nessun sizing |
| S10 | `Imbalance No SL` | [NTbbqM57](https://www.tradingview.com/script/NTbbqM57-Imbalance-No-SL/) | imbalance → entra | 🔴 **NESSUNO STOP LOSS, e sta nel titolo.** Più `pyramiding=1` e `qty` fisso. §4, prima riga |
| S11 | `ICT NY Kill Zone Auto Trading` | [nStqk3GV](https://www.tradingview.com/script/nStqk3GV-ICT-NY-Kill-Zone-Auto-Trading/) | kill zone NY | 🔴 **`default_qty_value = 100`** (100% dell'equity) e **ZERO `input.`** in 51 righe: SL e TP sono **costanti nel sorgente**. Non ha manopole, non ha tesi, non si misura |
| S12 | `ICT Bread and Butter Sell-Setup` | [RuVyrrAc](https://www.tradingview.com/script/RuVyrrAc-ICT-Bread-and-Butter-Sell-Setup/) | tre setup orari ICT | 🔴 **ZERO input**, geometrie **hardcoded** (`20 * syminfo.mintick`, `15`, `10`) e **tre tesi diverse nello stesso file** (riga 46, 52, 58): NY short, buy, Asia short. **Non una strategia: tre, in OR** |
| S13 | `ICT Entry V1 [TS_Indie]` / `ICT Entry V2 [TS_Indie]` | [mVdZBLJ7](https://www.tradingview.com/script/mVdZBLJ7-ICT-Entry-V1-TS-Indie/) · [wm9e7Wca](https://www.tradingview.com/script/wm9e7Wca-ICT-Entry-V2-TS-Indie/) | suite ICT completa | 🔴 **1.282 righe e 64 `input.` ciascuno** — **quattro volte** il tetto di casa, e le due versioni differiscono di **una riga**. §5E: _"il costo di validazione supera il valore atteso"_. **Non è "grezzo": è ingiudicabile** |
| S14 | `00 SMC + BB Breakout + Momentum Candle` | [Y4kqxvA7](https://www.tradingview.com/script/Y4kqxvA7-02-SMC-BB-Breakout-Improved/) | rottura di Bollinger + candela momentum | 🔴 **nessuno SL**: le uniche uscite sono `strategy.close` sul segnale opposto (righe 75-78). Più `trade_qty = capital_per_trade / close` = nozionale fisso. E **`ABTG_BandFade` esiste già** in casa |
| S15 | `16. SMC Strategy with SL - low Timeframe` | [QSNkX7W1](https://www.tradingview.com/script/QSNkX7W1-16-SMC-Strategy-with-SL-low-Timeframe/) | SMC always-in-the-market | 🔴 **sempre a mercato**: ogni segnale chiude e ribalta (righe 57-78). Nessun flat, quindi **esposizione permanente** — incompatibile col muro giornaliero prop. `default_qty_value = 10` |
| S16 | `MOMO – Imbalance Trend (SIMPLE BUY/SELL)` | [HFBT7MWQ](https://www.tradingview.com/script/HFBT7MWQ-MOMO-Imbalance-Trend-SIMPLE-BUY-SELL/) | imbalance + trend | 🔴 **2 soli `input.`** e SL in **percentuale del prezzo** (`position_avg_price * (1 - slP)`, riga 163): stessa taratura cripto di P3, senza le sue definizioni. Niente da salvare |

### 3.4 TradingView — scartati al primo taglio (titolo + tag, sorgente NON aperto, dichiarato)

Delle 60 strategie raccolte, non ho aperto quelle il cui titolo dichiara già
una famiglia sepolta o una bandiera §4:
`[JOAT]` (**7 script**: Aureate, Charter, Concordance, Helios, Precision Edge,
Singularity, Sovereign, Vortex) → **già scartati il 25/08** come _"nomi da
prodotto, confluenze multiple senza tesi singola"_; ciò che è setacciato non
si ricontrolla ·
`Liquidity Sweep Breakout - LSB`, `Liquidity Sweep Filter Strategy`,
`Liquidity Sweep Rider Institutional HFT Grabber`, `Master Sweep Strategy`,
`Casper SMC: 5m ORB + Retest` → **sweep di sessione / ORB su M5**, i due
capitoli chiusi in cima al dossier ·
`Long-Only Opening Range Breakout (ORB) with Pivot Points` → **ORB e long-only** ·
`Gap Filling Strategy`, `Gap Down Reversal`, `Gap Absorption`, `Gap Stats v2`,
`SP500 Session Gap Fade`, `Yesterday's High Breakout` → **gap di apertura**,
che è `ABTG_GapFill`/`ABTG_GapContinuation`, **non** il FVG a tre candele ·
`Stratégie SMC V18.2 (BTC/EUR FINAL R3)` → **BTC/EUR**, e "FINAL R3" nel
titolo è **una cicatrice da ottimizzatore** ·
`US/SPY Financial Regime Index`, `USD Liquidity Conditions Index` → **swing su
indici macro**, non intraday ·
`ChronoPulse MS-MACD Resonance`, `Multi-Indicator Swing [TIAMATCRYPTO]`,
`SuperATR 7-Step Profit`, `MTF Matrix Strategy` → confluenze multiple ·
`Amazing strategy for silver` → il titolo è la recensione.

---

## 4. ⬜ COSA NON HO POTUTO VEDERE — dichiarato, non taciuto

| oggetto | perché, e cosa ci costa |
|---|---|
| 🔴 **Ricerca GitHub** (403 su API; `gh` non installato) | **Sesta caccia di fila.** Zero repo nuovi. Pesa **più del solito qui**: l'SMC è un tema da repo hobbisti, e i repo hanno la **storia dei commit** — l'unico posto dove si vede se l'autore ha aggiustato la strategia **dopo** aver visto i risultati. Nota tecnica utile: `raw.githubusercontent.com` risponde **404 e non 403** → chi conosce già un URL può leggerlo |
| 🔴 **SSRN** (403 Cloudflare) | Sesta di fila. Ma vedi §5: **su questo tema non c'è niente da leggere nemmeno se si aprisse** |
| 🔴 **Forex Factory** | Non interrogata oggi (403 nelle 5 cacce precedenti). È **l'unico posto dove si legge come l'SMC è invecchiato** in dieci anni di thread — e per un tema **senza letteratura** sarebbe la fonte più preziosa. **È il buco più grave del dossier** |
| 🟡 **46 delle 60 strategie TradingView raccolte** | Aperte 14, le più in bersaglio. Le altre 46 sono elencate in §3.3-3.4 col motivo del primo taglio. **Il canale funziona: chiunque riprende da lì** |
| 🟡 **Le date di pubblicazione dei 5 Pine** | Il `<title>` dà nome e autore, **non la data**; il JSON `pine-facade` rende `created` **vuoto**. Marcate **[INCERTO]** in ogni scheda. **Non le ho inventate** |
| 🟡 **La popolarità dei Pine** (like, view) | Non letta. **[INCERTO]** — e comunque non entra nei punteggi |
| 🔴 **Lo SPREAD BCM misurato** su D30EUR/U30USD/NASUSD | **Non esiste in repo.** Uso i **2,0 punti indice dichiarati** di `METRO_PROP` D4, marcati **[SPREAD NON MISURATO]**. Lo strumento c'è (Code Base **74148**, promosso il 23/08) e **non è ancora mai stato usato**: è la terza caccia che lo scrive |
| ⚠️ **Nessun backtest è stato eseguito qui** | In questo ambiente non esistono MT5 né Strategy Tester. **Nessun numero di questo dossier è stato misurato oggi**: quelli di casa vengono dai referti citati, quelli di fuori sono `[DICHIARATO]` o `[STIMA]` |
| 🔴 **Ogni numero di performance degli autori** | **Letto e NON usato.** `SMC Pro BTC` dichiara nell'header _"90 trades \| 46% WR \| +14,36% P&L \| PF 1,95 \| DD 1,36%"_ su **BTC 4H 2021-2026**: **[DICHIARATO DALL'AUTORE, NON VERIFICATO]**, altro strumento, altro TF, altra epoca. **Non pesa su nessun punteggio** |

---

## 5. 📄 LA LETTERATURA — il vuoto, misurato

**Cinque interrogazioni all'API arXiv, oggi, con l'esito riga per riga:**

| query | entry | cosa erano davvero |
|---|---:|---|
| `all:"fair value gap" AND all:trading` | **0** | — |
| `all:"order block" AND all:trading` | 2 | `Learning Multi-Order Block Structure in Higher-Order Networks` (2511.21350) e `Exploiting Multi-Core Parallelism in Blockchain Validation` (2602.03444): **teoria dei grafi e blockchain**. Zero attinenza |
| `all:"smart money concepts"` | **0** | — |
| `all:"price gap" AND cat:q-fin*` | 6 | microstruttura del **book** (`1405.1247` gap nei limit order book cinesi, `1204.1381` price jump prediction): il "gap" è fra livelli del book, **non fra candele**. Zero attinenza |
| `abs:"liquidity sweep"` | 1 | `Sweeping by Sessile Drop Coalescence` (2005.06977): **fisica delle gocce** |

> ### 🧱 La riga che va incorniciata
> **Order Block, Fair Value Gap e Smart Money Concepts hanno ZERO presenza
> nella letteratura peer-review indicizzata su arXiv q-fin.** Non "pochi
> paper": **zero**.
>
> **Cosa NON significa:** che non funzionino. Le nostre sedie vive non hanno
> paper dietro nemmeno loro, e la nostra migliore misura di sempre
> (`ABTG_EMA200` Dow, 30/30) è un incrocio di medie.
>
> **Cosa significa davvero, ed è operativo:** nessuno, fuori, ha già
> falsificato al posto nostro. Sul fade d'apertura e sullo sweep di sessione
> il paper Mesfin ci ha **risparmiato dei round** (T = −14,12 su 6.442
> eventi). **Qui quel risparmio non c'è: il PASSO 0 e il cancello del costo
> sono l'unica rete.** È esattamente il motivo per cui P1 va misurato prima
> per **frequenza e costo**, e solo dopo per PF.

**Quantpedia:** viva ma non enumerabile (`?s=gap` → 133 KB, zero link
`/strategies/`), coerente con il verdetto del 25/08 — _"la sezione gratuita di
Quantpedia, per un mandato intraday, non serve"_. **Confermato, non
ricontrollare.**

---

## 6. 🧭 SCOPERTE TRASVERSALI — valgono oltre questa caccia

1. **🔧 La procedura Pine del memo fonti è SBAGLIATA e va corretta** (§1-bis):
   l'`href` è **assoluto**, l'ordine degli attributi è invertito, e la
   **paginazione `/page-N/` non funziona** col filtro strategie. Con il
   pattern vecchio si raccolgono **zero link** e si conclude che la fonte è
   vuota quando non lo è. **Ho fatto esattamente questo errore per venti
   minuti.** Il pattern corretto è nel §1-bis.

2. **📚 Il Code Base è ESAURITO su OB/FVG, e adesso c'è il numero.**
   Su **3.189** sorgenti (80 pagine, experts + indicators): **38 titoli
   SMC-affini, di cui 33 indicatori e 2 EA — e uno dei due lo abbiamo già.**
   Non è un'impressione: è un censimento. Si ricontrolli solo per **id nuovi
   dopo il 26/08/2026**.

3. **🏭 Su TradingView l'SMC è indicatoristica, non strategia.** Il tag
   `orderblock` rende **116 script** e **0 strategie** backtestabili. Sui 15
   tag SMC le strategie uniche sono **60**, contro le 399 raccolte il 25/08
   su tag generici. **Chi cerca SMC là fuori trova disegni, non regole.**

4. **📉 Nessuna letteratura, su nessuna delle tre parole chiave** (§5). Cambia
   il peso della prova: **la nostra misura è la prima misura**.

5. **🧱 Tre definizioni di Order Block lette in tre fonti indipendenti, e
   NON coincidono.** È il dato che più conta per chi scriverà l'EA:

   | fonte | quando nasce un OB | dimensione | mitigazione |
   |---|---|---|---|
   | **SMC Pro (P2)** | dopo un **BOS**, cercando **fino a 15 barre** indietro | il range della candela | **chiusura** oltre il bordo |
   | **Unmitigated OB Matrix (S2)** | candela **immediatamente** precedente a un impulso con **volume ≥1,5×** e **corpo ≥50 punti** | il range della candela | **primo tocco** |
   | **Tomukas (S7)** | dopo **sweep + MSS**, dentro la spinta | in **% del prezzo** | chiusura oltre il bordo |

   👉 **"Order Block" non è UNA cosa: è una famiglia di definizioni che danno
   segnali diversi sulle stesse barre.** Un round che voglia dire qualcosa
   deve **dichiarare quale definizione misura** — e la scelta va nei criteri,
   **non fra gli input**. È la stessa lezione di `003 - Weekly Day Reversal`:
   la tesi non si lascia decidere all'ottimizzatore.

6. **🎯 La domanda che nessuna delle venti fonti si pone, e che il nostro
   tester può risolvere in un round:** *si compra sul **bordo** del vuoto o
   **dentro** il vuoto?* Solo P3 ha il parametro (`mitigation %`). Nessuno lo
   ha spazzolato. **È una domanda di mercato vera, misurabile in una griglia
   a 4 celle** — ed è il tipo di cosa in cui questo progetto è forte.

7. **⏳ E la scoperta più utile per la CHALLENGE, che va contro il primo
   istinto:** questi motori **non sono ad alta frequenza**. Il mandato del
   25/08 chiedeva M15 **per accorciare i giorni di passaggio** (R106: mediana
   16 giorni). **P2 rischia di non arrivare nemmeno a 150 operazioni in 21
   mesi.** 👉 **P1 è il solo dei tre che possa rispondere a quel bisogno**, ed
   è un'altra ragione dell'ordine. **Se al PASSO 0 anche P1 spara poco, la
   famiglia SMC non è la risposta alla challenge** — e sarà bene dirlo subito
   invece di scoprirlo dopo tre round.

---

## 7. 📦 IL FILE PROVA DEL CANDIDATO NUMERO UNO

⚠️ **Non lo scrivo ancora, e il motivo è una regola di casa, non pigrizia.**
`ABTG_FVG.mq5` **non esiste**: P1 va prima **adottato** (attribuzione in
testa, `OnTester`, `InpMinSLPts`, soglia gap in ATR, fill su barre chiuse,
tetto a 1 posizione). Un file prova che punta a un EA inesistente è
esattamente l'errore n.3 della `CHECKLIST_RIGA_DI_LANCIO` — *"il file dei
parametri è quello giusto?"*.

**Ecco la BOZZA da congelare quando l'EA esiste**, con le righe `@` già
verificate contro le misure di casa:

```
# IPOTESI: un Fair Value Gap (low[i] > high[i-2]) e' un intervallo di prezzo
#   mai contrattato. Il ritorno del prezzo dentro quell'intervallo, nella
#   direzione del movimento che lo ha creato, e' un ingresso con edge -
#   e l'edge sta nel VUOTO, non nell'orario e non in un raid di liquidita'.
#
# CRITERI DI ACCETTAZIONE (congelati PRIMA dei numeri):
#   PASSO 0 - FREQUENZA: >= 150 operazioni per lato nella finestra.
#             Sotto: NON MISURABILE, si chiude qui (Emendamento §A).
#   PASSO 0 - COSTO (S0a): mediana del take LORDO >= 3 x 2,0 punti indice
#             = 6,0 punti indice. Fra 2,5x e 3,5x: verdetto SOSPESO,
#             si misura lo spread (Code Base 74148) e si rilegge.
#   RISCHIO (non si sospende mai): DD <= 10% a rischio 1% E peggior
#             giornata > -5,00%. Sopra: bocciato, a qualunque n.
#   MERITO: PF OOS >= 1,10 con IS positivo, su ENTRAMBI i lati misurati
#             separatamente (regola dei due lati, 25/08).
#   SELEZIONE: centro dell'altopiano, MAI il picco (12 Spearman su 13
#             negative). La regola si dichiara INSIEME al numero.
#   BASELINE: InpRegimeFilter = REGIME_NONE. EMA/ADX sono GRADINI di
#             ablazione, non parte del motore (0/5 sui filtri appiccicati).
#
# LIMITE DICHIARATO PRIMA: la finestra 2024.09.26-2026.08 e' UN SOLO
#   REGIME (toro). Il verdetto di MERITO e' provvisorio per costruzione
#   (e' il muro di R109); quello di RISCHIO vale pieno (regola B).

@SIMBOLO  D30EUR
@PERIODO  M15
@DAQUANDO 2024.09.26      <- MISURATO, REFERTO_SONDA_STORICO_17-08.md, stato COMPLETO

InpMinGapATR=0.5||0.25||0.25||0.75||Y      <- P3: la dimensione, in ATR (mai in _Point)
InpMinAgeBars=0||0||20||40||Y              <- P3: l'eta' conta? 0 = non conta
InpMinMitigationPct=5||5||25||55||Y        <- P3: bordo del vuoto o dentro?
InpTPATRMult=3.0||2.5||0.5||3.5||Y         <- verso l'ALTO: sotto c'e' l'attrito
InpRegimeFilter=0||0||0||0||N              <- REGIME_NONE: motore NUDO
InpLotMode=1||1||1||1||N                   <- LOT_RISK, mai LOT_FIXED
InpRiskPercent=1.0||1.0||1.0||1.0||N       <- 1% per confronto pulito
InpMinSLPts=<da misurare>||0||0||0||N      <- C4/R109: pavimento OBBLIGATORIO
InpMaxOpenTrades=1||1||1||1||N             <- niente long+short insieme su HEDGING
InpConfirmCandle=true||0||0||0||N
```
**4 assi liberi = 3 × 3 × 3 × 3 = 81 celle.** ⚠️ **Troppe per uno
screening**: al momento del congelamento si scende a **2 assi liberi per
corsa**, come da regola dell'altopiano.

---

## 8. ❓ LA DOMANDA A CUI IL PRIMO TEST DEVE RISPONDERE

> ### **Su M15, un Fair Value Gap produce abbastanza operazioni e un take
> abbastanza grasso da pagare l'attrito — prima ancora di chiedersi se
> guadagna?**

**È una domanda a due gate, e sono nell'ordine giusto:**

1. **FREQUENZA.** Se il FVG a tre barre su D30EUR M15 non fa **≥150
   operazioni per lato** in 21 mesi, il candidato non è misurabile e si
   chiude — senza girare una griglia. La mia **[STIMA] 150-500** poggia su
   un'ipotesi (2-4% delle barre) che **non ho misurato** e che il PASSO 0
   falsifica in dieci minuti.
2. **COSTO.** Se la mediana del take lordo non supera **6,0 punti indice**,
   il motore muore di attrito come i sei motori M5 prima di lui, e nessuna
   taratura lo salva (arXiv 2605.04004 §6.1).

**Solo se entrambi passano** ha senso guardare il PF. E il PF va guardato
**su due lati separati** (regola del 25/08), **col motore nudo**
(`REGIME_NONE`), sapendo che i 21 mesi sono **un solo regime** e che quindi
il merito è provvisorio mentre **il rischio è definitivo**.

**La ragione per cui questa è la domanda giusta, e non "quanto guadagna":**
negli ultimi quattro round chiusi il segnale non è mai morto di segno. R109 è
morto di **stop senza pavimento**. R108/R111 sono morti di **TF**. Il
capitolo M5 è morto di **costo**. **Tre morti su quattro sono di attrito e di
geometria, non di direzione.** Chiedere prima "quanto costa" e poi "quanto
rende" è la lezione che questi quattro round hanno già pagato.

---

_Dossier chiuso il 26/08/2026. **20 sorgenti letti riga per riga** (14 Pine +
6 `.mq5`), 3 promossi, 16 scartati con motivo, 2 fonti dichiarate nulle.
**Nessun backtest eseguito, nessun numero d'autore usato in nessun
punteggio.** Sorgenti archiviati in
`backtest_pipeline/caccia_strategie/biblioteca/sorgenti/` (7 file)._
