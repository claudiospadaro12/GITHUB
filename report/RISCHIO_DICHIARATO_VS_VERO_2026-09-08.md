# 🔍 RISCHIO DICHIARATO vs RISCHIO VERO — censimento del codice di sizing

**Data:** 08/09/2026 · **Perimetro:** tutti i `mql5/Experts/ABTG_*.mq5` (91 file)
**Metodo:** lettura statica del codice che calcola il lotto e piazza gli ordini.
**Domanda unica:** *se questo EA dichiara «rischio X%», quanto rischia DAVVERO
nel caso peggiore, in % del saldo?*

🛑 **Zero modifiche.** Nessun `.mq5`, nessun `.set`, nessun parametro toccato.
Questo file è l'unico prodotto. I difetti trovati sono **scritti, non corretti**.

⚠️ **Limite dichiarato:** questa è una misura **sul sorgente**, non un backtest e
non una lettura dei conti. Dove serve un dato del broker (lotto minimo, valore
del punto) lo dico e indico **cosa** andrebbe misurato — non lo invento.

---

## 🚨 1. LA PRIMA RIGA: I DUE EA DEL CONTO REALE 10105439

### ✅ **`ABTG_DAX_Apertura_EU` (770101, D30EUR) e `ABTG_ORB_Ottimizzato` (770611, U30USD) sono ONESTI COME SONO CONFIGURATI OGGI: dichiarano 0,65% e rischiano 0,65%.**

Non perché il codice sia sano — **perché i preset del conto reale spengono il
secondo lato**:

| prova | file | riga |
|---|---|---|
| `InpAllowShort=false` | `mql5/Presets/conto_reale/ABTG_DAX_Apertura_EU_770101_REALE.set` | riga `InpAllowShort=false` |
| `InpAllowShort=false` | `mql5/Presets/conto_reale/ABTG_ORB_Ottimizzato_770611_REALE.set` | riga `InpAllowShort=false` |
| `InpRiskPercent=0.65` | entrambi i preset | — |

**Con un solo lato armato viene piazzato UN solo pendente, quindi N = 1 gamba
viva → rischio vero = 0,65% = dichiarato.** La size è calcolata sulla **stessa**
distanza dello stop che viene poi piazzata (nessun caso PostNews qui):

- `ABTG_DAX_Apertura_EU.mq5:1062-1067` → `dist = entry - sl` e poi
  `CalcLotByRisk(dist)` alla riga **1069**; lo stesso `sl` finisce nel
  `BuyStop()` alla riga **1071**. ✅ coerente.
- `ABTG_ORB_Ottimizzato.mq5:456-458` → `dist = buyPx - sl`,
  `LotByRisk(dist)` alla riga **453/456**, stesso `sl` nel `BuyStop()` alla
  riga **457**. ✅ coerente.
- In entrambi `InpSlippagePts = 0` nei preset reali: il ramo che sposta lo SL
  **dopo** aver calcolato il lotto (`ORB_Ottimizzato.mq5:454`,
  `DAX_Apertura_EU.mq5:1062`) **non si attiva**. Se qualcuno lo accendesse,
  lo SL si allontanerebbe di X punti **dopo** il calcolo del lotto → il rischio
  vero salirebbe sopra il dichiarato. 🔴 **Da sapere prima di toccare quel campo.**

### 🟠 Ma tre avvertenze che vanno dette lo stesso

**(a) Il 2× è disarmato da un `.set`, non dal codice.** Se un giorno si riaccende
`InpAllowShort=true`, tutti e due gli EA piazzano **due pendenti opposti, ognuno
dimensionato al pieno 0,65%**, e l'OCO è **software, non di broker**:

```
ABTG_ORB_Ottimizzato.mq5:1029   void HandleOCO(){ if(SelPos()) CancelPendings(); }
ABTG_DAX_Apertura_EU.mq5:1850   void HandleOCO(){ if(!HasOpenPosition()) return; CancelMyPendings(); }
```

Gira **a tick** (`ORB_Ottimizzato.mq5:341`, `DAX_Apertura_EU.mq5:590`): fra il
riempimento del primo lato e la cancellazione del secondo c'è una finestra vera.
E **non è teoria**: il commento a `ABTG_ORB_Ottimizzato.mq5:1021-1028` cita il
gemello nativo `ABTG_ORB` con **4 giornate su 16 con il secondo lato riempito**
(`report/VERIFICA_CHIUSURE_INCROCIATE_2026-09-03.md`). 👉 A due lati armati il
rischio vero è **1,30%, non 0,65%**.

**(b) Il default compilato NON è il preset.** `ABTG_DAX_Apertura_EU.mq5:90` porta
`ABTG_DEF_RISK 1.0` (era 2.0, corretto il 02/09 col fix C4) e
`ABTG_ORB_Ottimizzato.mq5:207` porta `InpRiskPercent = 1.0`. **Un RIPRISTINA che
perde il preset atterra all'1,0%, non a 0,65%: +54%.** È già successo (la riga A4
e `report/DIAGNOSI_770101_SIZING_2026-08-31.md`).

**(c) Il pavimento del lotto minimo, sul reale, oggi NON morde — ma il margine è
2,6×, non infinito.** Calcolo con i soli numeri **misurati altrove**:
`D30EUR` ha step **0,10** e vale **1 €/punto indice**
(`report/DIAGNOSI_770101_SIZING_2026-08-31.md` §punto 6 e la riconciliazione
`11,80 × 54,9 × 1 € = 647,82`), saldo del reale ≈ **5.000 €**
(`report/CENSIMENTO_CONTRATTI.md:209`).

> pavimento che morde quando: `volMin × dist_punti × valore_punto > saldo × risk%`
> → `0,10 × dist × 1 > 5.000 × 0,0065 = 32,50 €` → **dist > 325 punti indice**.
> Distanza di stop massima mai osservata sulla 770101: **127 punti**. → margine 2,6×.

🔴 **Cosa manca per chiudere il punto (c) senza assunzioni:** `SYMBOL_VOLUME_MIN`
di `D30EUR` e di `U30USD` letto dal terminale (io conosco lo **step** 0,10 di
D30EUR, non il **minimo**, e di U30USD non conosco né minimo né valore del
punto). Due righe di `SondaMargine`/`config_in_uso.ps1` sul terminale
**10105439** (`C:\BCM_Reale`) bastano. Finché non c'è, la soglia dei 325 punti è
un **calcolo con un'assunzione dichiarata**, non una misura.

---

## 🔴 2. DOVE DICHIARATO ≠ VERO — ordinati per grandezza dello scarto

Solo gli EA in cui il numero scritto nell'input **non descrive** la perdita di un
caso peggiore. Gli EA onesti stanno nella tabella madre e **non qui**.

| # | EA | dichiarato | VERO caso peggiore | ×  | prova (file:riga) |
|---|---|---|---|---|---|
| 1 | **`ABTG_Bulge`** | `Risk_Percent = 0.8` | **3,20%** aperto insieme | **4,00×** | `:412 Max_Trades=4` · `:1247 if(CountOpenTrades()>=Max_Trades) return;` · `:1220-1222` il `/Max_Trades` **esiste solo in `RISK_TOTAL_CAP`**, ma il default è `RISK_PER_TRADE` (`:402`) |
| 2 | **`ABTG_FiboH4_Multi`** | `InpRiskPercent = 1.0` "per simbolo" | **3,00%** (3 simboli) | **3,00×** | `:183 InpSymbols="GBPUSD;USDJPY;EURUSD"` · `:185 InpMaxTotalPositions=6` · `:399` la guardia è **per simbolo**, non totale |
| 3 | **`ABTG_SuperWave` + 12 gemelli** (vedi §3) | `InpRiskPercent = 1.0` | **fino a 2,00%** | **fino a 2,00×** | `SuperWave.mq5:253-255` — 🐞 **difetto di codice, non di configurazione**, spiegato sotto |
| 4 | **`ABTG_Nightly`, `ABTG_Nightly_Ottimizzato`** | `InpRiskPercent = 1.0` "per ordine" | **2,00%** | **2,00×** | `:232` SELL LIMIT e `:243` BUY LIMIT, **ognuno a rischio pieno**, opposti, **nessun OCO** fra i due (l'unico `CancelPendings()` è al cutoff, `:150`) |
| 5 | **`ABTG_CanaleLento`** | `InpRiskPercent = 1.0` | **2,00%** | **2,00×** | `:588` BuyStop e `:617` SellStop, guardie **separate per lato** (`long_aperte==0` / `short_aperte==0`), nessun OCO |
| 6 | **`ABTG_GapContinuation`** | `InpBuyRiskPercent = 0.50` + `InpSellRiskPercent = 0.50` | **1,00%** | **2,00×** | `:987` volume BUY e `:1041` volume SELL, **nessuna guardia di posizione aperta** in tutto il file |
| 7 | **famiglia a DUE PENDENTI OPPOSTI con OCO software** (vedi §3) | 0,65-2,0% | **il doppio** | **2,00×** | OCO a tick, non di broker — misurato **4/16 giornate** col secondo lato riempito sul gemello `ABTG_ORB` |
| 8 | **`ABTG_PostNews`** ⚠️ **scarto INVERSO** | `InpRiskPercent = 3.0` | **1,50% per gamba**, **3,00% per evento** | **0,50× per gamba** | `:98 InpSLpips=25` · `:114 InpRiskRefSLpips=50` · `:325 LotByRisk(InpRiskRefSLpips*pip)` · `:479 risk=BALANCE*InpRiskPercent/100` |
| 9 | **TUTTI gli EA con `MathMax(minLot, …)`** (72 file) | qualunque | **> dichiarato su conti piccoli** | variabile | vedi §4 — misurato: **6 sedie a lotto minimo, rischio reale ~0,7% dove l'input dice 0,25-0,5%** (`report/M27_SEGNO_ASPETTATIVA_2026-08-31.md`) |

### 🐞 Il punto 3 merita il dettaglio: è un BUG, non una scelta

Tredici file identici. In `ABTG_SuperWave.mq5`:

```
253   double lotMkt =NormVol(totLot*InpFirstFraction);   // 1/3 a mercato
254   double lotPend=NormVol(totLot-lotMkt);             // 2/3 su pendente
255   if(lotMkt<=0) lotMkt=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
```

`NormVol()` (`:416-423`) **restituisce 0** sotto il lotto minimo. Quindi quando
`totLot × 0,3333` non arriva al minimo:
1. riga 253 → `lotMkt = 0`;
2. riga 254 → `lotPend = NormVol(totLot − 0) = totLot` **intero**;
3. riga 255 → `lotMkt` **risorge al lotto minimo**.

👉 Volume totale piazzato = **`totLot` + `volMin`** invece di `totLot`. E siccome
`totLot` esce già dal pavimento `MathMax(mn, …)` di `LotByRisk` (`:413`), nel
regime «conto piccolo» il totale è **2 × volMin = il doppio del rischio voluto**.
L'ordine delle righe 254 e 255 è invertito rispetto all'intenzione.

🔴 **E in campo è già successo**, con i numeri: `SW DOW H2` il 19-20/08, due gambe
da 0,10 lotti, **−72,32 € su 5.076,62 = 1,42%** contro un contratto dichiarato
**1,0%** (`report/DIARIO.md`, riga 20/08/2026). **1,42×.**

**Righe esatte, file per file** (stesso identico blocco):

| file | righe |
|---|---|
| `ABTG_SuperWave.mq5` · `ABTG_SuperWave_DAX_H4_Ottimizzato.mq5` · `ABTG_SuperWave_DOW_H1_Ottimizzato.mq5` | 253-255 |
| `ABTG_SupertrendReversal_Ottimizzato.mq5` | 260-262 |
| `ABTG_SupRev_CAC_H4` · `DAX_H1` · `DAX_H4` · `DOW_H1` · `DOW_H4` · `NAS_H1` `_Ottimizzato.mq5` | 261-263 |
| `ABTG_SupertrendReversal_Multi.mq5` · `ABTG_SupertrendReversal_Multi_Ottimizzato.mq5` | 264-266 |
| `ABTG_SupertrendReversal.mq5` | 274-276 |

⚠️ **Aggravante sulle due `_Ottimizzato` dell'oro:** `ABTG_SupertrendReversal_Ottimizzato.mq5:86`
e `ABTG_SupertrendReversal_Multi_Ottimizzato.mq5:90` dichiarano **`InpRiskPercent = 2.0`**.
Con questo difetto il caso peggiore su conto piccolo è **4,00%** — da solo oltre
il cap C1 di 3,25%.

### 📋 Il punto 7 in chiaro: chi piazza due pendenti opposti a rischio pieno

Ogni gamba è dimensionata al **100%** di `InpRiskPercent`. L'OCO è una riga
eseguita a tick: se il mercato riempie tutte e due prima del tick successivo (o
in un gap), le posizioni vive sono due.

| EA | righe delle due gambe | OCO |
|---|---|---|
| `ABTG_ORB.mq5` | 329 / 341 | `:222 HandleOCO()` |
| `ABTG_ORB_Ottimizzato.mq5` | 453 / 468 | `:341` → `:1029` |
| `ABTG_Londra_ORB.mq5` | 219 / 234 | `:136` → `:304` |
| `ABTG_MaxMinNotte.mq5` (+ `_DAX_Short_Ott` 253/265, `_MFE` 301/313) | 354 / 366 | `:239` |
| `ABTG_DAX_Apertura_EU.mq5` | 1069 / 1093 (+ fade 1151/1168) | `:590` → `:1850` |
| `ABTG_DAX_Apertura_EU_Ottimizzato.mq5` | 684 / 708 | idem |
| `ABTG_Dow_Apertura_US.mq5` | 906 / 930 | idem |
| `ABTG_Nasdaq_Apertura_US.mq5` (+ `_Ottimizzato` 685/709) | 1006 / 1031 | idem |
| `ABTG_DAX_Live5m.mq5` (661/678) · `_v2` (683/707) · `ABTG_Nasdaq_Live5m.mq5` (664/681) | — | idem |
| `ABTG_Apertura_3Ingressi.mq5` · `ABTG_Apertura_Marco.mq5` | 1144/1169 · 822/846 | idem |
| `ABTG_PostNews.mq5` | 325 (un solo `LotByRisk`, due ordini) | `InpUseOCO` |

🟠 **`ABTG_Apertura_3Ingressi.mq5`** lo dichiara da solo nell'intestazione
(righe 36-39): le tre modalità *«si innescano sullo STESSO evento, quindi
sarebbero posizioni CORRELATE e mangerebbero tre volte il cap C1»*. **Tre istanze
insieme = 3 × il dichiarato.**

### 📰 Il punto 8 in chiaro: PostNews, il caso che ha aperto l'indagine

Il codice è **coerente con sé stesso ma il numero è etichettato male**:
`LotByRisk()` riceve **50 pip** (`:325`) e piazza uno stop di **25 pip** (`:98`).
Quindi:

- **una gamba stoppata = 1,50%** (metà del dichiarato);
- **doppio stop (whipsaw sul dato, entrambe le gambe riempite e stoppate) = 3,00%** = il dichiarato.

👉 Il `3.0` descrive **l'evento**, non l'operazione. Chi legge l'input crede di
avere uno stop da 3% e ne ha uno da 1,5%. **Non è rischio in più: è
un'etichetta che non si può usare per contare il cap C1.**

✅ **I preset vivi hanno già la correzione, e lo scrivono:**
`mql5/Presets/ABTG_PostNews_ECB_EURUSD.set:47-54` →
`; Era 3.0 (il numero del corso). Con InpRiskRefSLpips=50 e InpSLpips=25 …` →
**`InpRiskPercent=1.30`** = 0,65% per gamba × 2 gambe. Concorda con
`report/CENSIMENTO_CONTRATTI.md:171` (`771203`: **1,30%/evento**).
🔴 **Resta il difetto del sorgente**: il default compilato è ancora `3.0`
(`:113`), quindi un RIPRISTINA riporta l'EA a **1,50% per gamba / 3,00% per evento**.

---

## 📊 3. TABELLA MADRE — tutti gli `ABTG_*.mq5`

Legenda gravità: 🔴 = il numero dichiarato è sbagliato per costruzione ·
🟠 = dipende dalla configurazione o dal saldo · 🟢 = dichiarato = vero ·
⚪️ = non opera (sonda/utility).

**Colonna «×»** = moltiplicatore del rischio dichiarato nel caso peggiore.
Dove non diversamente indicato lo SL è **fisso e piazzato con l'ordine** (quindi
il rischio è definito all'ingresso) e il sizing usa la **stessa** distanza dello
stop poi piazzato.

| EA | parametro | rischio VERO caso peggiore | × | prova | grav. |
|---|---|---|---|---|---|
| `ABTG_Bulge` | `Risk_Percent 0.8` | **3,20%** (4 trade insieme su 22 cross) | **4,00** | `:412` · `:1247` · `:1220` | 🔴 |
| `ABTG_SupertrendReversal_Ottimizzato` | `InpRiskPercent 2.0` | **4,00%** (bug tranche) | **2,00** | `:260-262` | 🔴 |
| `ABTG_SupertrendReversal_Multi_Ottimizzato` | `InpRiskPercent 2.0` | **4,00%** (bug tranche) | **2,00** | `:264-266` | 🔴 |
| `ABTG_FiboH4_Multi` | `InpRiskPercent 1.0` /simbolo | **3,00%** (3 simboli) | **3,00** | `:183` · `:185` · `:399` | 🔴 |
| `ABTG_MaxMinNotte` | `InpRiskPercent 2.0` | **4,00%** (2 pendenti opposti) | **2,00** | `:354` / `:366` · `:239` | 🔴 |
| `ABTG_SuperWave` | `InpRiskPercent 1.0` | **2,00%** | **2,00** | `:253-255` | 🔴 |
| `ABTG_SuperWave_DAX_H4_Ottimizzato` | `1.0` | **2,00%** | **2,00** | `:253-255` | 🔴 |
| `ABTG_SuperWave_DOW_H1_Ottimizzato` | `1.0` | **2,00%** | **2,00** | `:253-255` | 🔴 |
| `ABTG_SupertrendReversal` | `1.0` | **2,00%** | **2,00** | `:274-276` | 🔴 |
| `ABTG_SupertrendReversal_Multi` | `1.0` | **2,00%** | **2,00** | `:264-266` | 🔴 |
| `ABTG_SupRev_CAC_H4_Ottimizzato` | `1.0` | **2,00%** | **2,00** | `:261-263` | 🔴 |
| `ABTG_SupRev_DAX_H1_Ottimizzato` | `1.0` | **2,00%** | **2,00** | `:261-263` | 🔴 |
| `ABTG_SupRev_DAX_H4_Ottimizzato` | `1.0` | **2,00%** | **2,00** | `:261-263` | 🔴 |
| `ABTG_SupRev_DOW_H1_Ottimizzato` | `1.0` | **2,00%** | **2,00** | `:261-263` | 🔴 |
| `ABTG_SupRev_DOW_H4_Ottimizzato` | `1.0` | **2,00%** | **2,00** | `:261-263` | 🔴 |
| `ABTG_SupRev_NAS_H1_Ottimizzato` | `1.0` | **2,00%** | **2,00** | `:261-263` | 🔴 |
| `ABTG_Nightly` | `1.0` "per ordine" | **2,00%** | **2,00** | `:232` / `:243` | 🔴 |
| `ABTG_Nightly_Ottimizzato` | `1.0` "per ordine" | **2,00%** | **2,00** | `:232` / `:243` | 🔴 |
| `ABTG_CanaleLento` | `1.0` | **2,00%** | **2,00** | `:588` / `:617` | 🔴 |
| `ABTG_GapContinuation` | `0.50` BUY + `0.50` SELL | **1,00%** | **2,00** | `:987` / `:1041` · 🔴 `:157 InpFixedLots` scavalca il rischio se >0 (default 0) | 🔴 |
| `ABTG_PostNews` | `InpRiskPercent 3.0` | **1,50%/gamba · 3,00%/evento** | **0,50 / 1,00** | `:98` · `:114` · `:325` · `:479` | 🔴 |
| `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` | `1.0` | **2,00%** | **2,00** | `:253` / `:265` | 🟠 |
| `ABTG_MaxMinNotte_DAX_Short_Ottimizzato_MFE` | `1.0` | **2,00%** | **2,00** | `:301` / `:313` | 🟠 |
| `ABTG_ORB` | `1.0` | **2,00%** (2 lati armati) | **2,00** | `:329` / `:341` · `:222` — **4/16 giornate misurate** | 🟠 |
| **`ABTG_ORB_Ottimizzato` 🔴REALE 770611** | `1.0` sorgente / **0,65% preset** | **0,65%** col preset reale (`AllowShort=false`) · **1,30%** a due lati | **1,00** oggi | `:207` · `:453`/`:468` · `:1029` | 🟢 oggi |
| **`ABTG_DAX_Apertura_EU` 🔴REALE 770101** | `1.0` sorgente / **0,65% preset** | **0,65%** col preset reale (`AllowShort=false`) · **1,30%** a due lati | **1,00** oggi | `:90` · `:313` · `:1069`/`:1093` · `:1850` | 🟢 oggi |
| `ABTG_DAX_Apertura_EU_Ottimizzato` | `ABTG_DEF_RISK 2.0` | **4,00%** a due lati | **2,00** | `:217` · `:684`/`:708` | 🟠 |
| `ABTG_Dow_Apertura_US` | `ABTG_DEF_RISK 2.0` | **4,00%** a due lati | **2,00** | `:281` · `:906`/`:930` | 🟠 |
| `ABTG_Nasdaq_Apertura_US` | `ABTG_DEF_RISK 2.0` | **4,00%** a due lati | **2,00** | `:260` · `:1006`/`:1031` | 🟠 |
| `ABTG_Nasdaq_Apertura_US_Ottimizzato` | `2.0` | **4,00%** a due lati | **2,00** | `:218` · `:685`/`:709` | 🟠 |
| `ABTG_DAX_Live5m` | `2.0` | **4,00%** a due lati | **2,00** | `:212` · `:661`/`:678` | 🟠 |
| `ABTG_DAX_Live5m_v2` | `2.0` | **4,00%** a due lati | **2,00** | `:213` · `:683`/`:707` | 🟠 |
| `ABTG_Nasdaq_Live5m` | `2.0` | **4,00%** a due lati | **2,00** | `:215` · `:664`/`:681` | 🟠 |
| `ABTG_Apertura_3Ingressi` | `ABTG_DEF_RISK 2.0` | **4,00%** a due lati · **3×** se le 3 modalità girano insieme | **2,00-6,00** | `:310` · `:1144`/`:1169` · intestazione `:36-39` | 🟠 |
| `ABTG_Apertura_Marco` | `ABTG_DEF_RISK 2.0` (EA **RITIRATO**, `:192`) | **4,00%** a due lati | **2,00** | `:233` · `:822`/`:846` | 🟠 |
| `ABTG_Londra_ORB` | `1.0` | **2,00%** a due lati | **2,00** | `:219`/`:234` · `:304` | 🟠 |
| `ABTG_EMA200` / `_Ottimizzato` | `1.0` **totale, diviso** | **1,00%** — ma **2 × volMin** su conto piccolo | 1,00 / >1 | `:223-224` divisione corretta · `:357` pavimento **per gamba** | 🟠 |
| `ABTG_BreakoutCorso` | `1.0` | **1,00%** · ⚠️ tick value **nudo** (`:609-614`, niente `OrderCalcProfit`) | 1,00 | `:606-632` · pavimento **dichiarato a log** `:627` | 🟠 |
| `ABTG_SuperWave_EA` | `InpRiskPct 1.0` | **≤ 1,00%** (`NormLots`→0 sotto il minimo, `:168-176`) · ⚠️ tick value **nudo** `:243` | ≤1,00 | `:241-245` | 🟠 |
| `ABTG_Relativo` | `0.65` | **0,65%** (una posizione per volta, `:1540`) · pavimento **dichiarato** (`sottoMinimo`, `:1009`) | 1,00 | `:373` · `:993-1013` · ⚠️ tick value nudo | 🟢 |
| `ABTG_AllineaLondra` | `0.65` | **0,65%** × `InpMaxPositions 1` | 1,00 | `:255` · `:875` · pavimento **dichiarato** (`alMinimo`, `:463`) | 🟢 |
| `ABTG_LondonFx` | `0.65` | **0,65%** × `LONDONFX_MAX_POSIZIONI` | 1,00 | `:365` · `:1271` · pavimento **dichiarato** `:821` | 🟢 |
| `ABTG_SondaOrologio` | `1.0` | **1,00%** × `InpMaxPositions 1` | 1,00 | `:187` · `:626` · pavimento **dichiarato** `:356` | 🟢 |
| `ABTG_MeanRevert` | `1.0` | **1,00%** (una posizione, `:193`) | 1,00 | `:113-145`, verifica il lotto con `OrderCalcProfit` e **scende di uno step** finché non sfora | 🟢 |
| `ABTG_AltaVelocita` | `1.0` | **1,00%** (`:1060 HasPosition→return`) | 1,00 | `:1127` · `:1272` | 🟢 |
| `ABTG_AtrExhaustVol` | `1.0` | **1,00%** (`:469`) | 1,00 | `:654` · `:839` | 🟢 |
| `ABTG_BreakinBox` | `0.65` | **0,65%** (`:638`) | 1,00 | `:828` · `:981` | 🟢 |
| `ABTG_BreakingBand` | `1.0` | **1,00%** × `InpMaxPositions 1` (`:1089`) | 1,00 | `:1342` · `:1637` | 🟢 |
| `ABTG_CRT_TurtleSoup` | `0.65` | **0,65%** (`:860`) | 1,00 | `:939` · `:1186` | 🟢 |
| `ABTG_ChaosLyapunov` | `1.0` | **1,00%** (`:400`) | 1,00 | `:483` · `:606` | 🟢 |
| `ABTG_CostToCost` | `1.0` | **1,00%** (`:589`, `:653`) | 1,00 | `:732` · `:923` | 🟢 |
| `ABTG_CrossEma` | `1.0` | **1,00%** (`:326`) | 1,00 | `:405` · `:603` | 🟢 |
| `ABTG_CrossEmaApertura` | `1.0` | **1,00%** (`:576`) | 1,00 | `:611` · `:793` | 🟢 |
| `ABTG_DAX_M3` | `1.0` | **1,00%** (`:169 SelPos`) | 1,00 | `:280` · `:442` | 🟢 |
| `ABTG_DaxReEntry` | `0.65` | **0,65%** (`:444`) | 1,00 | `:592` · `:736` | 🟢 |
| `ABTG_DaxValueArea` | `0.65` | **0,65%** (`:722`) | 1,00 | `:833` · `:1064` | 🟢 |
| `ABTG_EasyTrend` | `1.0` | **1,00%** (`:921`, `:1006`) | 1,00 | `:1102` · `:1406` | 🟢 |
| `ABTG_FiboH4_Corso` | `0.65` | **0,65%** (`:604-605`) | 1,00 | `:740` · `:443` | 🟢 |
| `ABTG_FvgRetest` | `1.0` | **1,00%** (`:594`) | 1,00 | `:950` | 🟢 |
| `ABTG_GapFill` | `1.0` | **1,00%** (`:366`) | 1,00 | `:487` · `:647` | 🟢 |
| `ABTG_GoldenCross` / `_Ottimizzato` / `_V1` | `1.0` | **1,00%** (`:305 HasOpenPos‖HasPending`) | 1,00 | `:538`/`:456`/`:432` · `:706`/`:624`/`:600` | 🟢 |
| `ABTG_HARSI` | `0.5` | **0,50%** × `InpMaxPositions 1` (`:189`) | 1,00 | `:248` · `:323` | 🟢 |
| `ABTG_IntradayMomentum` | `1.0` | **1,00%** (`:623`) | 1,00 | `:643` · `:730` | 🟢 |
| `ABTG_InvEsaurimento` | `0.65` | **0,65%** (`:635`) | 1,00 | `:796` · `:921` | 🟢 |
| `ABTG_LiquiditySweep` | `1.0` | **1,00%** (`:645`) | 1,00 | `:712` · `:878` | 🟢 |
| `ABTG_NySessionRetest` | `0.65` | **0,65%** (`:587`) | 1,00 | `:694` · `:945` | 🟢 |
| `ABTG_ORB_Fibo` | `1.0` | **1,00%** (`:318 SelPos`) | 1,00 | `:268` · `:419` | 🟢 |
| `ABTG_OpeningReversalB` | `0.65` | **0,65%** (`:714`) · cap extra in punti `:125` | 1,00 | `:924` · `:1093` | 🟢 |
| `ABTG_OutOfNoise` | `0.65` | **0,65%** (`:540`) | 1,00 | `:839` · `:974` | 🟢 |
| `ABTG_PTE` / `_Ottimizzato` | `1.0` | **1,00%** × `InpMaxPositions 1` (`:272`/`:318`) | 1,00 | `:354`/`:410` · `:478`/`:534` | 🟢 |
| `ABTG_PunteLarry` | `1.0` | **1,00%** (`:408`) | 1,00 | `:687` · `:1037` | 🟢 |
| `ABTG_SupertrendInvert` | `1.0` | **1,00%** × `InpMaxPositions 1` (`:194`) | 1,00 | `:279` · `:429` | 🟢 |
| `ABTG_TurnaroundTuesday` | `1.0` | **1,00%** (`:507`) | 1,00 | `:567` · `:682` | 🟢 |
| `ABTG_VwapRevert` | `1.0` | **1,00%** (`:746`) | 1,00 | `:958` · `:1321` | 🟢 |
| `ABTG_WOL` | `1.0` | **1,00%** × `InpMaxPositions 1` (`:193`) | 1,00 | `:273` · `:383` | 🟢 |
| `ABTG_Guardian` | — | **non apre posizioni**: è il vigile (cap C1 `:107`) | — | — | ⚪️ |
| `ABTG_Apertura_Study_EA` · `ABTG_SlippageLogger` · `ABTG_SpreadLogger` · `ABTG_TradeExporter` · `ABTG_SondaGapCash` · `ABTG_SondaLondonFx` · `ABTG_SondaM0PB` · `ABTG_SondaMargine` · `ABTG_SondaRelativo` · `ABTG_SondaRsiEmaV8` | — | **nessun invio ordini** (0 `Buy`/`Sell` nel file) | — | — | ⚪️ |

**Punto 4 del mandato — stop assente o mobile:** ✅ **nessun EA del parco entra
senza stop.** In tutti i casi letti lo SL è calcolato **prima** del lotto e
passato nella stessa chiamata d'ordine. Trailing e breakeven **riducono** il
rischio dopo l'ingresso, non lo aumentano. 🟠 **Unica eccezione di forma:**
`InpSlippagePts > 0` (in `ORB_Ottimizzato:454/470` e `DAX_Apertura_EU:1062`)
sposta lo SL **dopo** il calcolo del lotto → allarga il rischio vero. **Default e
preset reali = 0: oggi non morde.**

**Punto 5 del mandato — lotto fisso che scavalca il rischio:** ✅ **un solo caso
in tutto il parco**, `ABTG_GapContinuation.mq5:157 InpFixedLots` con
`:784-785 if(InpFixedLots>0.0) return(NormalizeVolumeDown(InpFixedLots));`.
**Default 0 = spento.** Se qualcuno lo valorizza, i due `RiskPercent` diventano
**decorativi**.

---

## 📏 4. IL PAVIMENTO DEL LOTTO MINIMO — la falla trasversale

**72 file su 91** chiudono il calcolo con `MathMax(minLot, MathMin(maxLot, lot))`.
Il `MathFloor` sullo step **toglie** rischio (innocuo); il `MathMax` ne
**aggiunge**, e nessuno se ne accorge perché **il lotto è ancora "valido"**.

> 🔢 **Formula del cancello, valida per ogni sedia:**
> il pavimento morde quando `saldo × risk% < volMin × dist_stop × valore_del_punto`,
> cioè sotto il **saldo di soglia**
> **`S* = volMin × dist × valore_punto × 100 / risk%`**.
> Sotto `S*` il rischio vero non è più `risk%` ma `volMin × dist × valore_punto / saldo`.

📌 **Il fatto già misurato** (`report/M27_SEGNO_ASPETTATIVA_2026-08-31.md`, righe
203-212 e 266): **6 sedie del conto piccolo girano al lotto minimo 0,01**, e
*«le riduzioni firmate 23-24/08 sotto ~0,5% sul conto piccolo sono FINZIONE:
rischio reale ~0,7% dove l'input dice 0,25-0,5%»*. Su XAUUSD **1,4-2,8×**.

📌 **Il contro-esempio, anch'esso misurato** (`report/DIAGNOSI_770101_SIZING_2026-08-31.md`
§punto 6): su **D30EUR** (step 0,10, 1 €/punto) il pavimento morderebbe solo con
**stop oltre ~510 punti** al saldo/rischio di quel test — **mai visto, max 127**.
👉 **Il pavimento non è un difetto universale: è un difetto CONDIZIONATO al
rapporto saldo/valore-del-punto. Va misurato per sedia, non temuto in blocco.**

🔴 **Cosa serve per fare la misura, e non ce l'abbiamo:** per ogni sedia viva
servono tre numeri dal terminale — `SYMBOL_VOLUME_MIN`, `SYMBOL_VOLUME_STEP`,
valore per punto (via `OrderCalcProfit` su 1 lotto) — più la distanza **tipica**
e **minima** dello stop di quel motore. Con quelli, `S*` è aritmetica.
`ABTG_SondaMargine` è già scritto e non tocca niente: è il candidato naturale.

🟢 **Tre EA fanno la cosa giusta e lo dicono**: `ABTG_AllineaLondra:455-466` (flag a `:463`),
`ABTG_LondonFx:814-825` (flag a `:822`), `ABTG_SondaOrologio:349-360` (flag a `:356`) restituiscono un flag
`alMinimo` con il commento *«in quel caso il rischio REALE e' piu' alto di quello
dichiarato … il fatto finisce in colonna, non sotto il tappeto»*.
`ABTG_BreakoutCorso:627` lo stampa a log. **È il modello da estendere.**

⚠️ **Difetto gemello, 3 file:** `ABTG_BreakoutCorso`, `ABTG_Relativo`,
`ABTG_SuperWave_EA` calcolano la perdita per lotto **dal tick value nudo**, senza
il ripiego `OrderCalcProfit` che tutti gli altri hanno. È il difetto già pagato
sul **225JPY** (tick value non convertito in valuta conto, commento in
`ABTG_PostNews.mq5:480-485`). Se il tick value **sottostima**, il lotto esce
**troppo grande** e il rischio vero sfonda il dichiarato **senza limite noto**.

---

## ⚖️ 5. CONSEGUENZA SUL CAP C1 (3,25% firmato il 18/08)

Il cap dice: **3,25% di rischio aperto = 5 stop vivi da 0,65%**. Il Guardian lo
conta con `InpMaxOpenRiskPct` (`ABTG_Guardian.mq5:107`).

### ✅ Sul conto REALE il cap conta BENE, oggi
Due sedie, **una gamba ciascuna**, **0,65% vere**: rischio aperto massimo
**1,30%**, contro un cap di 3,25%. **Margine 2,5×.** Nessuna correzione urgente.

### 🔴 Sul resto della flotta il cap conta MALE, e di quanto si può dire

| se il Guardian conta… | …ma il vero è | il cap 3,25% vale in realtà |
|---|---|---|
| 5 sedie × 0,65% = **3,25%** | famiglia Supertrend/SuperWave a lotto minimo (**2×**) | **6,50%** |
| 5 sedie × 0,65% = **3,25%** | 5 sedie a **due lati armati** (**2×**) | **6,50%** |
| 1 `Bulge` a **0,80%** | **4 trade insieme** | **3,20%** = **il cap intero da un EA solo** |
| 1 `SupertrendReversal_Multi_Ottimizzato` a **2,0%** | bug tranche (**2×**) | **4,00%** = **cap già sfondato da una sedia** |
| 3 istanze `Apertura_3Ingressi` a 0,65% = **1,95%** | stesso evento, 3× | **5,85%** |

👉 **La frase da tenere: il cap C1 non è sbagliato — è sbagliato l'ingresso che
gli diamo.** Finché il Guardian conta *«quante sedie × quanto dice l'input»* e
non *«quante GAMBE × quanto perde davvero uno stop»*, **il 3,25% è una promessa
con un moltiplicatore ignoto sotto**, che nei casi letti arriva a **2×**.

🔵 **Nota tecnica da verificare, NON un'accusa:** `InpRiskMode`
(`ABTG_Guardian.mq5:108`) dice che il rischio aperto si calcola *«dall'INGRESSO»*
o *«dal PREZZO CORRENTE»*. **Se il Guardian legge le posizioni VERE (volume × distanza
dallo SL) invece degli input degli EA, allora conta già le gambe giuste e gran
parte di questo paragrafo decade.** Non l'ho verificato in questo giro: il mandato
era il codice di sizing degli EA. 👉 **È la prima cosa da leggere dopo questo
referto**, e cambia la conclusione.

🔴 **E il tetto per CLUSTER (C10, 3,0%, firmato il 07/09) resta NON ATTIVO**
(`InpMaxClusterRiskPct = 0` di default, `ABTG_Guardian.mq5:119`; implementato in
v1.13 ma non compilato né collaudato). **Va detto ogni volta che si cita.**

---

## 🗂️ 6. NOTA SU `mql5/Experts/standalone/`

**NON è un doppione da ignorare in blocco.** 22 file, e **nessuno è identico** al
gemello in `mql5/Experts/`: sono **versioni ridotte** (es. `ABTG_PostNews.mq5`
**307 righe** contro **666**, `ABTG_DAX_Apertura_EU.mq5` **1069** contro **2367**).
Tre esistono **solo** lì: `ABTG_FiboH4.mq5`, `ABTG_PointBreak.mq5`,
`ABTG_SuperFilter.mq5`.

👉 **Li ho esclusi da questo censimento** perché il mandato dice
`mql5/Experts/ABTG_*.mq5` e perché nulla nel repo indica che siano quelli
compilati in campo. 🔴 **Ma la domanda va posta a Claudio: quale albero viene
compilato sul VPS?** Se qualcuno compilasse la copia `standalone`, **tutti i
numeri di questo referto sarebbero riferiti al file sbagliato** — e le versioni
ridotte non hanno le correzioni degli ultimi mesi.

---

## 🔧 7. DIFETTI DA CORREGGERE (scritti, NON corretti)

In ordine di quanto rischio spostano. **Nessuno di questi è stato toccato.**

1. 🐞 **Il bug delle tranche (13 file)** — invertire le righe `lotPend = …` e
   `if(lotMkt<=0) lotMkt = volMin`, oppure ricalcolare `lotPend` **dopo** il
   pavimento. Ha già prodotto **1,42% su un contratto da 1,0%** in campo.
2. 🏷️ **`ABTG_PostNews` default `3.0`** — allinearlo ai preset vivi (`1.30`) o
   rinominare l'input, perché oggi il numero **non descrive nessuna operazione**.
3. 🔒 **OCO software → OCO vero** sui 15+ EA a due pendenti opposti: o si
   dimensiona ogni gamba a **metà** rischio, o si accetta e si **dichiara** il 2×.
4. 📏 **Estendere il flag `alMinimo`** (già scritto in `AllineaLondra`/`LondonFx`)
   a tutti gli EA con `MathMax(minLot, …)`, così il pavimento **finisce in log**
   invece che nel drawdown.
5. 🧮 **Aggiungere il ripiego `OrderCalcProfit`** in `BreakoutCorso`, `Relativo`,
   `SuperWave_EA` — è l'unico dei cinque meccanismi che può sbagliare **verso
   l'alto senza limite noto**.
6. 🧹 **`DAX_Apertura_EU.mq5:669`** — `gTrade.PositionClose(_Symbol)` nel flatten
   da notizie chiude **per simbolo**, non per ticket: può chiudere la posizione
   di un'altra sedia sullo stesso simbolo. È lo stesso difetto già corretto in
   `ABTG_ORB_Ottimizzato` v1.04 (`ChiudiPosizioniMie`, `:1001`). **Non è rischio
   di taglia, è rischio di collisione** — ma è nel file di una sedia del REALE.

---

### 📌 Fatto / inferenza / da misurare

- **FATTO (letto nel codice, riga citata):** tutti i moltiplicatori delle
  colonne «×», il bug delle tranche, il ref-SL di PostNews, il `MathMax(minLot)`
  su 72 file, `InpAllowShort=false` nei due preset reali.
- **FATTO (misurato altrove, fonte citata):** 1,42% su contratto 1,0% (DIARIO
  20/08) · 4/16 giornate col secondo lato riempito (VERIFICA 03/09) · 6 sedie a
  lotto minimo (M27 31/08) · D30EUR step 0,10 e 1 €/punto (DIAGNOSI 31/08).
- **INFERENZA DICHIARATA:** la soglia dei **325 punti** sul reale assume
  `volMin = 0,10` per D30EUR (io ho letto lo **step**, non il **minimo**).
- **DA MISURARE, e non l'abbiamo:** `VOLUME_MIN` + valore del punto di **U30USD**
  · se il Guardian conta le gambe vere o gli input · quale albero
  (`mql5/Experts/` o `standalone/`) viene compilato sul VPS.
