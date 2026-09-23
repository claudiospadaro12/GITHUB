# 🗺️ LA MAPPA DEL COSTO — SIMBOLO × TF PER LA FAMIGLIA APERTURA

**24/09/2026 · repo `/home/user/GITHUB`, branch `lavoro`, HEAD `5ff4256c`**
🛑 **SOLA LETTURA E SOLA MISURA.** Nessun round lanciato, nessun `.ini`, nessun `.set`,
nessun `.mq5` toccato, nessun terminale, nessun forward, nessuna sedia promossa o spenta,
nessuna soglia modificata. Il conto reale `10105439` non compare in nessun comando.
**Scritto: questo file.** Letti: 8 CSV dello Studio delle aperture, 3 CSV di spread orario
storico, 1 CSV di spread vivo, 1 sonda broker, 2 statement, 3 sorgenti MQL5, 9 referti.

---

# 0. 🥁 IL NUMERO CHE SERVE SUBITO

> ## 🎯 **DELLE 240 CELLE DELLA MATRICE, NE SOPRAVVIVONO 58. Il 24,2%.**
> **116 passate invece di 480.**

| | celle | passate |
|---|---:|---:|
| matrice a forza bruta del mandato (6 modi × 4 TF × 5 simboli × 2 lati) | **240** | **480** |
| dopo il taglio dei **simboli** (cancello di costo) | 144 | 288 |
| dopo il taglio del **TF inerte** (4 modi su 6) | 72 | 144 |
| dopo il cancello di costo **sul solo modo FADE** | 🟢 **58** | 🟢 **116** |

### 🔴 E LA PRIMA COSA DA DIRE È CHE **LA PREMESSA DEL MANDATO SULLE 44 ORE NON REGGE**

Il mandato conta **5,5 min/passata, «misurato su R238»**. 🔴 **Quel numero non è in repo**:
`backtest_pipeline/prove/R238a_finestra_TICK_SUPREV_NASUSD_short.txt` non dichiara nessun
ritmo, e **tutti** i ritmi misurati in casa stanno fra **0,022 e 0,700 min/passata**.
E ce n'è uno **della famiglia Apertura, sullo stesso simbolo, sullo stesso TF, a tick reali**:

| fonte | misura | ritmo |
|---|---|---:|
| 🎯 `report/CHI_ALTRO_PUO_SCHIERARSI_2026-09-22.md` **r.64** — `Apertura US` breakout 2 lati, `U30USD` **M5, tick reali**, 18 mesi | **80 passate ≈ 6,8 min** | 🟢 **0,085 min/passata** |
| `report/ALLARGARE_LA_ROSA_2026-09-19.md` **r.340** — `DAX_Apertura_EU` `D30EUR`, asse `InpSessionHour` | 12 passate · 1,1–9,0 min | 0,09 – 0,75 min/passata |
| `report/CODA_NOTTE_2_2026-09-12.md` **r.292** — R88a, tick, M5, 21 mesi | 96 passate in 8,0 min | 0,083 min/passata |

> 🔢 **Rifatto il conto con il ritmo MISURATO della famiglia:**
>
> | | al ritmo del mandato (5,5) | al ritmo **misurato** (0,085) | al bordo **lento** misurato (0,75) |
> |---|---:|---:|---:|
> | 480 passate (forza bruta) | 44,0 h | 🟢 **41 min** | 6,0 h |
> | **116 passate (matrice tagliata)** | 10,6 h | 🟢 **10 min** | 1,5 h |
>
> 🎯 **Quindi il taglio NON serve a risparmiare ore: serve a non girare 182 celle che non
> possono essere promosse in nessun caso.** Su un motore che gira già, una cella
> inammissibile per costo o duplicata non costa tempo — **costa un picco di rumore verde**,
> che è la cosa che brucia la challenge (regola del 19/08). **Questa è la ragione vera del
> taglio, e va scritta al posto di quella sbagliata.**

### 🔑 LE QUATTRO RIGHE CHE RESTANO

1. 🔴 **IL TF NON TOCCA LO STOP, E QUESTO DA SOLO TOGLIE 72 CELLE.** Il range d'apertura si
   calcola su `PERIOD_M1` **cablato**, in tutti e tre gli EA. Con i default di famiglia
   (`SLMode=RANGE`, filtri volumi/ATR **spenti**, trailing su `InpTrailTF` esplicito) il TF
   del grafico è **completamente inerte** su **4 modi d'ingresso su 6**: quattro TF
   darebbero **quattro CSV identici**. §1.
2. 🟢 **SOPRAVVIVONO TRE SIMBOLI SU DIECI INDICI BCM** — `D30EUR` **49,1×**, `U30USD`
   **61,0×**, `NASUSD` **63,9×** sul range di 35' — e sono **esattamente** i tre di cui
   possediamo sia lo spread orario sia i tick. §4.
3. 🔴 **CINQUE INDICI SONO ESCLUSI PER COSTO CON UN MARGINE DI 2-4 VOLTE**, e due di loro
   (`SPXUSD`, `E50EUR`) **non passerebbero nemmeno prendendo il range dell'INTERA giornata
   come stop**: 35,6× e 27,7×. §5.
4. 🥇 **I METALLI NON SONO NELLO STESSO CAMPIONATO, E NEANCHE FRA LORO.** `XAGUSD` è
   **escluso per costo a qualunque TF e a qualunque durata di range** (il giorno intero vale
   **26,7×**). `XAUUSD` ha il **tetto più alto della flotta, 250×**, ma il suo range
   d'apertura è **`[NON MISURATO]`**: sotto la legge più prudente passa il 40× **solo da 35'
   in su su BCM, e da 114' in su su FTMO**. §6.

---

# 1. 🔴 LA CORREZIONE CHE TAGLIA DA SOLA METÀ MATRICE — **il TF non entra nello stop**

## 1.1 Il range d'apertura si legge su M1 **cablato**, non sul TF del grafico

```mql5
// mql5/Experts/ABTG_Dow_Apertura_US.mq5  r.844-857   (ComputeRangeWindow)
int idxStart = iBarShift(_Symbol, PERIOD_M1, tStart, false);
int idxEnd   = iBarShift(_Symbol, PERIOD_M1, tEnd,   false);
int hIdx = iHighest(_Symbol, PERIOD_M1, MODE_HIGH, count, MathMin(idxStart,idxEnd));
int lIdx = iLowest (_Symbol, PERIOD_M1, MODE_LOW,  count, MathMin(idxStart,idxEnd));
hi = iHigh(_Symbol, PERIOD_M1, hIdx);   lo = iLow (_Symbol, PERIOD_M1, lIdx);
```

**Identico, riga per riga, in tutti e tre gli EA della famiglia:**

| EA | righe di `ComputeRangeWindow` | chiamata con `InpRangeMinutes` |
|---|---|---|
| `ABTG_Dow_Apertura_US.mq5` | **r.834-857** | r.1402 |
| `ABTG_DAX_Apertura_EU.mq5` | **r.1145-1158** | r.2031 |
| `ABTG_Nasdaq_Apertura_US.mq5` | **r.941-954** | r.1635 |

E l'altra sorgente di livelli, `ABTG_RANGE_PREVBAR`, legge `iHigh/iLow(_Symbol, **InpLevelTF**, 1)`
(Dow **r.815-816** · DAX **r.1116-1117** · Nasdaq **r.912-913**): un **input esplicito**, non
il TF del grafico.

> 🎯 **Conseguenza**: la larghezza del range — e quindi lo stop di `ABTG_SL_RANGE` — dipende
> da **`InpSessionHour`, `InpSessionMin`, `InpRangeMinutes`** e dal simbolo. **Del TF del
> grafico non sa niente.**

## 1.2 🔍 E allora **che cosa** tocca il TF del grafico? Grep secco su `PERIOD_CURRENT`

| punto | riga (Dow) | tocca il TF? | acceso nei default di famiglia? |
|---|---|---|---|
| `gAtrH = iATR(_Symbol, PERIOD_CURRENT, InpAtrPeriodMgmt)` | **r.396** | 🟢 sì | dipende da **dove** si usa `AtrValue()` ⬇️ |
| `AtrValue()` dentro `SL_ATR` (BREAKOUT/RETEST/DELAYED/OPENCONFIRM) | r.897·921·1129·1237·1320·1353 | 🟢 sì | 🔴 **NO** — `InpSLMode = ABTG_SL_RANGE` (**r.282**): il ramo ATR non viene mai preso |
| `AtrValue()` dentro **RANGE_FADE** | **r.976** | 🟢 sì | 🟢 **SÌ, SEMPRE** — il fade **non guarda `InpSLMode`** |
| `VolumeOK(){ return VolumeOKtf(PERIOD_CURRENT); }` | **r.2091** | 🟢 sì | 🔴 **NO** — `InpUseVolumeFilter = false` (**r.317**) e `VolumeOKtf` esce subito (r.2076) |
| `AtrOK()` dentro `ConfirmOK()` | r.2042-2050 | 🟢 sì | 🔴 **NO** — `InpUseAtrFilter = false` (**r.320**); `ConfirmOK` r.2044 esce `true` |
| trailing ad ATR (`ABTG_TRAIL_ATR`) | r.1838·1851 | 🟢 sì | 🔴 **NO** — `ABTG_DEF_TRAIL_MODE 1` = base candela precedente (**r.68**), su **`InpTrailTF`** esplicito (**r.292**, `PERIOD_M5` sul Dow) |
| `octf` di **OPENCONFIRM** | **r.1207** | 🟢 sì | 🟢 **SÌ** — `InpOCTimeframe = PERIOD_CURRENT` (**r.235**): il TF **è** il meccanismo |

> ## 🔴 **IL VERDETTO DI QUESTO PARAGRAFO**
> Con i **default di famiglia** (`InpSLMode=ABTG_SL_RANGE` · `InpUseVolumeFilter=false` ·
> `InpUseAtrFilter=false` · `InpTrailMode=PREVBAR` su TF esplicito), **il TF del grafico è
> una MANOPOLA INERTE su quattro modi d'ingresso su sei**: `BREAKOUT`, `GAPFILL`, `RETEST`,
> `DELAYED`.
> 👉 Girarli su M5/M15/M30/H1 produrrebbe **quattro CSV identici** — esattamente i
> **874 CSV su 1.960 con esito identico** trovati dal censimento del 09/09. **Stavolta lo
> sappiamo PRIMA, e costa zero saperlo.**
>
> ⚠️ **Con UNA eccezione dichiarata, e tira nel verso sbagliato**: quanto sopra vale a
> **Modello 4 (tick reali)**, dove i tick sono gli stessi qualunque sia il TF del grafico. A
> **Modello 1/2 (OHLC)** il TF del grafico **genera i tick finti** ⇒ quattro TF darebbero
> quattro risultati **diversi**, e la differenza sarebbe **un artefatto della simulazione,
> non del motore**. 🔴 **Su questa famiglia un asse `TF` in OHLC misura il simulatore.**

---

# 2. 📐 LE SEI GEOMETRIE DI STOP, LETTE NEL SORGENTE — non trasferite da nessuna sedia

Notazione: **`R`** = larghezza del range d'apertura · **`B`** = `InpBufferPoints × _Point`
(`EffectiveBuffer()`, **r.1906-1911**) · **`O`** = `InpRetestOffsetPts × _Point` ·
**`A`** = `ATR(PERIOD_CURRENT, InpAtrPeriodMgmt)`.

| # | modo (`ENUM_ABTG_ENTRY`, r.170-177) | righe | **distanza di stop** | dipende dal **TF**? |
|---:|---|---|---|:---:|
| 0 | `ABTG_BREAKOUT` | r.897 / r.921 | `entry = rangeHigh+B` · `sl = rangeLow−B` ⇒ **`R + 2B`** (+ `InpSlippagePts`) | 🔴 **NO** |
| 1 | `ABTG_GAPFILL` | r.1420 / r.1435 | `entry = lo−B` · `sl = hi+B` ⇒ **`R + 2B`** | 🔴 **NO** |
| 2 | `ABTG_RETEST` | r.1319-1320 / r.1353 | `entry = rangeHigh−O` · `sl = rangeLow−B` ⇒ **`R + B − O`** | 🔴 **NO** |
| 3 | `ABTG_RANGE_FADE` | **r.976-978** | **`A × InpAtrSlMult`** (ripiego `B` se ATR=0) — 🔴 **non guarda `InpSLMode`** | 🟢 **SÌ** |
| 4 | `ABTG_DELAYED` | r.1127-1129 | `entry = ask/bid` al minuto della decisione · `sl = bordo opposto` **senza buffer** ⇒ **variabile**, `≥ R/2` in `DIR_MID`, `> R` in `DIR_BREAK` | 🔴 NO *(il TF non entra)* |
| 5 | `ABTG_OPENCONFIRM` | r.1235-1237 | `entry = ask ≥ rangeHigh+B` · `sl = rangeLow−B` ⇒ **`≥ R + 2B`** | 🟡 **solo verso l'ALTO** |

✅ **La formula del RETEST riproduce quella già scritta da un'altra sessione**:
`report/STOP_VS_SPREAD_FTMO_2026-09-20.md` **r.78-79** dice
*«`entry = rangeHigh − InpRetestOffsetPts`, `sl = rangeLow − InpBufferPoints` ⇒ stop =
larghezza del range + (buffer − offset)»*. **Identica.** Verificata contro il numero di
qualcun altro, non contro me stesso.

> ### 🧮 LA SCELTA CHE EVITA LA CLASSE 687
> `B` e `O` **cambiano da sedia a sedia** (`770101` B=5,00/O=2,00 idx · `770202` B=10,00/O=4,00
> · `770260` B=2,00/O=0 — `STOP_VS_SPREAD_FTMO` **r.84-86**). **Trasferirli a un altro simbolo
> sarebbe esattamente il difetto vietato.**
> 👉 Perciò **tutta la tabella di ammissibilità è calcolata con `B = 0` e `O = 0`**, cioè
> **`stop = R`**. È la scelta **conservativa** per i modi 0/1/5 (ogni buffer positivo
> *allarga* lo stop e *aiuta*), ed è **neutra**: non porta dentro i parametri di nessuno.
> 🎯 **Il cancello diventa così una domanda su una sola grandezza: `R ≥ 40 × spread`.**
> Con un buffer `B` la soglia scende di `2B` (modi 0/1/5) o di `B−O` (modo 2).
> 🔴 **Il modo 4 (`DELAYED`) è l'unico che può stare SOTTO `R`** (nessun buffer, entrata a
> mercato dentro il range in `DIR_MID`): per lui `R` è un bordo **ottimista**, e va detto.

---

# 3. 💸 LO SPREAD, SIMBOLO PER SIMBOLO — con l'etichetta accanto a ogni numero

## 3.1 🕐 Prima: **quale ora**, e perché non è la mediana di giornata (classe 650)

La **classe 650** (`backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md` **r.32735+**) impone di
leggere l'insieme delle ore **dal sorgente**. Fatto:

- 🟢 **La famiglia Apertura HA un cancello d'ora, ed è stretto**: `InpSessionHour`/`InpSessionMin`
  (r.220-221) + `rangeEndMin = openMin + InpRangeMinutes` (r.621) + `InpPendingExpiryMin = 120`
  (**r.239**). Gli ingressi vivono nella finestra **`[apertura, apertura + 35' + 120']`**.
- 👉 **Quindi qui la mediana giusta è quella dell'ORA DI APERTURA, non la «mediana delle 24
  mediane orarie»**: quella serve ai motori senza filtro d'ora (il caso `EMA200` della
  classe 650). **Per questa famiglia usarla sarebbe l'errore simmetrico.**
- ⚠️ **E lo dichiaro come limite**: `770101` opera all'**ora 08** (19 su 34 gambe,
  `CANCELLO_COSTO_FLOTTA` r.326) e `770611` all'**ora 14** (5 su 8, r.329). **È l'ora
  d'apertura, misurata sui trade veri.** Ma la coda dei 120 minuti del pendente può cadere
  nell'ora successiva: sul DAX passa da 1,70 a 1,70 (ore 8→9: **invariato**), sugli USA da
  2,00 a 2,00 e da 1,80 a 1,80 (ore 14→15). 🟢 **L'ora successiva non peggiora su nessuno dei
  tre.** Verificato, non assunto.

## 3.2 🟢 I TRE con lo spread **MISURATO** (tick storici + logger vivo)

Fonti: `backtest_pipeline/risultati_archivio/spread_flotta/spread_orario_{D30EUR,U30USD,NASUSD}.csv`
(finestra **2024.09.26 → 2026.06.30**, 30,9 / 64,7 / 156,1 milioni di tick, `% solo-bid = 0,000`)
· `data/spread_vivo/SPREAD_VIVO_2026-09-12_orario.csv` (logger vivo 04→11/09/2026, passo 5 s,
**GG=5**).

| simbolo | ora d'ingresso | **archivio tick** med / P95 | **logger vivo** med / P95 | 🔴 **valore PRUDENTE adottato** |
|---|---|---:|---:|---:|
| `D30EUR` | **08** | **1,70** / 2,70 | 1,60 / 1,70 | **1,70** |
| `U30USD` | **14** | **2,00** / 3,00 | 🔴 **3,00** / 3,00 | 🔴 **3,00** |
| `NASUSD` | **14** | **1,80** / 2,70 | 1,80 / 1,90 | **1,80** |

> ### 🔴 IL DISACCORDO CHE VA DICHIARATO, PERCHÉ DECIDE UNA CELLA
> Su `U30USD` all'ora 14 le due fonti dicono **2,00** e **3,00**: **+50%**. Non è un errore di
> nessuno dei due — sono **due pesi diversi**: l'archivio pesa **per tick** (e l'ora 14 è
> densissima di tick a spread stretto), il logger pesa **per secondo**. La classe 650 dice
> che fra due letture della stessa faccia non si costruisce un intervallo: qui invece sono
> **due facce diverse**, e allora **si prende la peggiore**.
> 👉 **Con 2,00 il modo FADE su `U30USD` a M30 passerebbe (42,0×); con 3,00 non passa
> (28,0×).** È l'unica cella del referto che si ribalta, ed è marcata 🟠 in §8.

## 3.3 🟡 I CINQUE con **una sola lettura istantanea**, e nell'ora sbagliata

Fonte unica: `backtest_pipeline/risultati_archivio/sonda_storico_17-08/215D85D7_ABTG_InfoBroker.csv`,
blocco `[SIMBOLI]`, colonna `SpreadPt`, **17/08/2026 17:34 ora server** — cioè **l'ora 17**.

🔴 **Per gli indici EUROPEI l'ora 17 server è a cassa CHIUSA** (17:34 srv = 18:34 italiane;
Xetra chiude alle 16:30 srv). È lo stesso difetto già scritto per il Nikkei
(`CANCELLO_COSTO_FLOTTA` **r.492-498**). **La direzione dell'errore è nota e misurata sul
DAX**: ora 17 = **2,60** contro ora 08 = **1,70**, cioè la lettura fuori sessione è
**1,53× troppo larga**.

| simbolo | `SpreadPt` (h17) | **in punti indice** | 🔴 **bordo PESSIMISTA** (la lettura così com'è) | 🟡 **bordo OTTIMISTA** (× 1,70/2,60 = 0,654, rapporto DAX) |
|---|---:|---:|---:|---:|
| `SPXUSD` | 140 | 1,40 | **1,40** *(h17 è dentro la cassa USA: la correzione NON si applica)* | 1,40 |
| `F40EUR` | 170 | 1,70 | **1,70** | 1,11 |
| `E50EUR` | 200 | 2,00 | **2,00** | 1,31 |
| `E35EUR` | 540 | 5,40 | **5,40** | 3,53 |
| `100GBP` | 160 | 1,60 | **1,60** | 1,05 |
| `200AUD` | 160 | 1,60 | ⚪ *(vedi sotto)* | — |

✅ **Il fattore di conversione ×100 non è assunto**: `Digits=2`, `Point=0,01` su tutti e sei
(sonda `[SIMBOLI]`), e `CANCELLO_COSTO_FLOTTA` **r.295** lo verifica in tre modi indipendenti.
Su `XAGUSD` **`Digits=3`, `Point=0,001`** ⇒ **1 $ = 1.000 punti MT5**, un fattore **diverso
dagli altri**: sbagliarlo qui varrebbe un fattore 10.

🔴 **Il verdetto su `200AUD` è ⚪ `NON MISURABILE` per un secondo motivo**: non esiste nessuno
`Studio_200AUD.csv` in `backtest_pipeline/risultati_archivio/studio_apertura/` ⇒ **il suo
range d'apertura non è mai stato misurato**. Manca il numeratore, non solo il denominatore.

## 3.4 🥇 I metalli

| simbolo | fonte | valore | etichetta |
|---|---|---:|---|
| `XAUUSD` | `SPREAD_VIVO_2026-09-12_orario.csv`, **ora 08** med / P95 | **0,21** / 0,23 $ | 🟢 `[MISURATO, GG=5]` |
| `XAUUSD` | idem, **ora 14** | 0,21 / 0,22 $ | 🟢 `[MISURATO, GG=5]` |
| `XAUUSD` | **+ commissione** misurata `ORO_1530_CANCELLO_COSTO` §2.4 via `CANCELLO_COSTO_FLOTTA` **r.457** | **+0,0403 $** | 🟢 `[MISURATO]` |
| 👉 `XAUUSD` **costo pieno adottato** | | 🔴 **0,2503 $** | |
| `XAGUSD` | sonda 17/08 h17, `SpreadPt = 41`, `Point = 0,001` | **0,041 $** | 🟡 `[MISURATO, n=1 lettura]` |
| `XAGUSD` | commissione | 🔴 **`[NON MISURATO]`** — l'argento non compare nella legge dello 0,004% del nozionale (`CANCELLO_COSTO_FLOTTA` r.184-196) | — |

🔴 **`XAGUSD` non è nel logger vivo** (8 simboli: `225JPY`, `D30EUR`, `EURUSD`, `GBPUSD`,
`NASUSD`, `U30USD`, `USDJPY`, `XAUUSD`) **né in `spread_flotta/`** (3 simboli). **Una lettura,
un istante.**

---

# 4. 🚦 LA TABELLA DI AMMISSIBILITÀ — **simbolo × TF**, con il numero accanto

## 4.1 Il numeratore: il range d'apertura **MISURATO su 8 simboli**

Fonte: `backtest_pipeline/risultati_archivio/studio_apertura/Studio_<SIM>.csv`, colonna
**`ampiezza_pt`** (= `(gHi−gLo)/_Point`, `mql5/Experts/ABTG_Apertura_Study_EA.mq5` **r.210**),
range **15 minuti** (**r.29**), apertura **08:00** per gli europei e **14:30** per gli USA
(intestazione dei `_RIEPILOGO.csv`) — **le ore server giuste**.

Colonna **35'** = `× √(35/15) = 1,5275` — la legge di casa `ANCORA_ADR_FLOTTA_INDICI` §4,
usata così in `STOP_VS_SPREAD_FTMO` **r.241**.

| simbolo | n giornate | **R mediano 15'** | **R mediano 35'** `[INF]` | R **P10** 15' |
|---|---:|---:|---:|---:|
| `U30USD` | 446 | **119,75** | **182,92** | 30,80 |
| `NASUSD` | 447 | **75,30** | **115,02** | 23,80 |
| `D30EUR` | 440 | **54,65** | **83,48** | 23,89 |
| `E35EUR` | 211 | 54,00 | 82,49 | 35,60 |
| `F40EUR` | 443 | 20,70 | 31,62 | 10,50 |
| `100GBP` | 431 | 17,30 | 26,43 | 7,30 |
| `SPXUSD` | 444 | 12,75 | 19,48 | 4,83 |
| `E50EUR` | 440 | 12,00 | 18,33 | 5,60 |

> ### ✅ **IL CONTRO-ESEMPIO CHE HO COSTRUITO PER ROMPERE QUESTA COLONNA — e non si rompe**
> `STOP_VS_SPREAD_FTMO_2026-09-20.md` **r.245-250** pubblica, per una **sessione diversa e
> con un altro scopo**, lo **stop** ricostruito dallo stesso file = `R + (buffer − offset)`.
> Ho ricalcolato `R` da zero e ci ho aggiunto le costanti di **r.84-86**:
>
> | | mio `R` mediano | + costante | loro **stop** mediano | esito |
> |---|---:|---:|---:|---|
> | `D30EUR` (+3,00) | 54,65 | **57,65** | **57,65** | 🎯 identico |
> | `U30USD` (+6,00) | 119,75 | **125,75** | **125,75** | 🎯 identico |
> | `NASUSD` (+2,00) | 75,30 | **77,30** | **77,30** | 🎯 identico |
> | `D30EUR` **P10** (+3,00) | 23,89 | **26,89** | **26,89** | 🎯 identico |
> | `U30USD` **P10** (+6,00) | 30,80 | **36,80** | **36,80** | 🎯 identico |
> | `NASUSD` **P10** (+2,00) | 23,80 | **25,80** | **25,80** | 🎯 identico |
>
> **Sei numeri su sei, alla seconda cifra, per via indipendente.** La colonna è la stessa
> grandezza che usa l'altro referto, e non è una coincidenza di cifre: le costanti che la
> separano sono **tre diverse** e tornano tutte e tre.

## 4.2 🚦 **LA TABELLA CHE DECIDE** — `R(35') / spread`, pavimento di lavoro **40×**, duro **13,3×**

Pavimenti: `backtest_pipeline/prove/R125_ORB_COSTO_CRITERI.md` §2 via
`CANCELLO_COSTO_FLOTTA_2026-09-10.md` **r.168-171**.
**Tutti i modi tranne il FADE hanno lo stesso stop a qualunque TF ⇒ una riga per simbolo
vale per M5, M15, M30 e H1 insieme.**

| simbolo | spread 🔴 prudente | **R35/spr** | spread 🟡 ottimista | **R35/spr** | **40×?** | **13,3×?** | **VERDETTO (M5 · M15 · M30 · H1)** |
|---|---:|---:|---:|---:|:---:|:---:|---|
| **`U30USD`** | 3,00 | 🟢 **61,0×** | 2,00 | 91,5× | 🟢 SI (+53%) | 🟢 SI | 🟢 **AMMESSA su tutti e quattro** |
| **`NASUSD`** | 1,80 | 🟢 **63,9×** | 1,80 | 63,9× | 🟢 SI (+60%) | 🟢 SI | 🟢 **AMMESSA su tutti e quattro** |
| **`D30EUR`** | 1,70 | 🟢 **49,1×** | 1,60 | 52,2× | 🟢 SI (+23%) | 🟢 SI | 🟢 **AMMESSA su tutti e quattro** |
| `F40EUR` | 1,70 | 🔴 18,6× | 1,11 | 🔴 28,5× | 🔴 **NO (46-71%)** | 🟢 SI | 🔴 **ESCLUSA PER COSTO** |
| `100GBP` | 1,60 | 🔴 16,5× | 1,05 | 🔴 25,2× | 🔴 **NO (41-63%)** | 🟢 SI | 🔴 **ESCLUSA PER COSTO** |
| `E35EUR` | 5,40 | 🔴 15,3× | 3,53 | 🔴 23,4× | 🔴 **NO (38-58%)** | 🟢 SI | 🔴 **ESCLUSA PER COSTO** |
| `SPXUSD` | 1,40 | 🔴 13,9× | 1,40 | 🔴 13,9× | 🔴 **NO (35%)** | 🟡 **SI per un soffio** | 🔴 **ESCLUSA PER COSTO** |
| `E50EUR` | 2,00 | 🔴 **9,2×** | 1,31 | 🔴 14,0× | 🔴 **NO (23%)** | 🔴 **NO al bordo prudente** | 🔴 **ESCLUSA PER COSTO** — l'unica che sfonda anche il pavimento DURO |
| `200AUD` | 1,60 | ⚪ | — | ⚪ | ⚪ | ⚪ | ⚪ **NON MISURABILE** — nessuno `Studio_200AUD.csv` |
| `225JPY` | 35 (h08) | ⚪ | 23 (h14) | ⚪ | ⚪ | ⚪ | ⚪ **NON MISURABILE** al range · 🔴 **ESCLUSA dal TETTO**, §5 |
| **`XAUUSD`** | 0,2503 | ⚪ | — | ⚪ | ⚪ | ⚪ | ⚪ **NON MISURATO** — §6 |
| `XAGUSD` | 0,041 | ⚪ | — | ⚪ | ⚪ | ⚪ | 🔴 **ESCLUSA dal TETTO**, §5 |

> 🎯 **Nota di metodo, dichiarata prima del verdetto**: i cinque esclusi lo sono **sotto tutti
> e due i bordi dello spread**, pessimista e ottimista. **Nessuno dei cinque cambia verdetto
> se lo spread vero è quello buono**, e il più vicino (`F40EUR` a 28,5×) resta **29% sotto**.
> 👉 Per questo li dichiaro **ESCLUSI PER COSTO** e non «da misurare»: **misurare meglio lo
> spread non li salva**, e questo è il contro-esempio che rende l'esclusione onesta.

## 4.3 📏 E la stessa tabella letta **al contrario**: quanti minuti di range servono per il 40×

`T* = 15 × (40 × spread / R₁₅)²`. È il numero che dice **se una manopola già esistente
(`InpRangeMinutes`) può riparare la cella**.

| simbolo | **minuti richiesti** (spr. prudente) | (spr. ottimista) | riparabile? |
|---|---:|---:|---|
| `NASUSD` | 🟢 **13,7** | 13,7 | 🟢 passa già a **15'** |
| `U30USD` | 🟢 **15,1** | 6,7 | 🟢 passa a **15'** entro l'1% |
| `D30EUR` | 🟢 **23,2** | 20,6 | 🟢 passa a **35'** (la geometria viva) |
| `F40EUR` | 🔴 **161,9** | 69,0 | 🟡 servirebbe un range di **1-3 ore**: non è più «apertura» |
| `100GBP` | 🔴 **205,3** | 88,4 | 🔴 no |
| `E35EUR` | 🔴 **240,0** | 102,6 | 🔴 no |
| `E50EUR` | 🔴 **666,7** | 286,0 | 🔴 no |
| `SPXUSD` | 🔴 **289,4** | 289,4 | 🔴 no *(su BCM: su FTMO è un'altra storia, §7)* |

---

# 5. 🧱 IL TETTO — il range dell'INTERA giornata diviso lo spread

**Se `ADR / spread < 40`, nessuna durata di range può passare il cancello**, perché lo stop
della famiglia Apertura è per costruzione **una frazione del range giornaliero**. È il
pre-cancello più economico che esista: si calcola in dieci secondi e **chiude una domanda per
sempre**.

Ancore giornaliere: `report/ANCORA_ADR_FLOTTA_INDICI_2026-09-18.md` §2 (metodo **max-per-data,
mediana sulle date**). 🟢 **Ho rifatto il conto da zero su `data/statements/trades_auto.csv` +
`trades_100k.csv` e riproduce**: `U30USD` **381,0** contro 379,5 · `NASUSD` **372,5** contro
384,6 · `D30EUR` **243,8** contro 252,5 — scarti **+0,4% / −3,2% / −3,4%**, spiegati dal giorno
in corso escluso/incluso. *(Per le ancore dichiarate uso le loro, non le mie.)*

| simbolo | **ADR** | fonte | spread | **tetto `ADR/spr`** | esito |
|---|---:|---|---:|---:|---|
| `XAUUSD` | **62,60 $** | 🟢 **`[MISURATO]` n=67 giornate — calcolata QUI, col metodo §2 dell'ancora. Nessun referto la conteneva** | 0,2503 | 🥇 **250,1×** | il tetto più alto della flotta |
| `NASUSD` | 384,6 | `[MIS]` n=26 | 1,80 | **213,7×** | 🟢 |
| `D30EUR` | 252,5 | `[MIS]` n=52 | 1,70 | **148,5×** | 🟢 |
| `U30USD` | 379,5 | `[MIS]` n=24 | 3,00 | **126,5×** | 🟢 |
| `F40EUR` | ~95,6 | `[INF]` da `R₁₅/0,2164` (rapporto DAX) | 1,70 | 56,3× | 🟡 tetto basso |
| `100GBP` | ~79,9 | `[INF]` idem | 1,60 | 50,0× | 🟡 |
| `E35EUR` | ~249,5 | `[INF]` idem | 5,40 | 46,2× | 🟡 |
| **`SPXUSD`** | ~49,9 | `[INF]` da `R₁₅/0,2557` (rapporto USA) | 1,40 | 🔴 **35,6×** | 🔴 **SOTTO IL TETTO: nessun range lo salva su BCM** |
| **`225JPY`** | **793,0** | `[MIS]` n=9 🟡 sottile | **35** (h08 vivo) | 🔴 **22,7×** *(34,5× all'ora 14)* | 🔴 **SOTTO IL TETTO a tutte e due le ore** |
| **`E50EUR`** | ~55,4 | `[INF]` | 2,00 | 🔴 **27,7×** | 🔴 **SOTTO IL TETTO** *(42,3× col bordo ottimista: 🟠 non deciso, ma a 35' fa 9,2× comunque)* |
| **`XAGUSD`** | **1,095 $** | 🔴 `[n=4 — NON CITABILE]` per la stessa regola che l'ancora applica a `SPXUSD` (n=2) e `F40EUR` (n=1) | 0,041 | 🔴 **26,7×** | 🔴 **SOTTO IL TETTO** |

> ### 🔴 `SPXUSD` e `225JPY`: **esclusi per costo in modo DEFINITIVO su BCM**, e non per il TF
> Non è «il TF è sbagliato» e non è «il range è corto». **Il giorno intero non basta.**
> - `SPXUSD`: per arrivare a 40× servirebbe un ADR di **56,0 punti** contro i ~49,9 stimati —
>   e il numero non dipende dal bordo dello spread (la sonda h17 è **dentro** la cassa USA).
>   🟡 **Il tetto è `[INFERITO]`**: se l'ADR vero fosse ≥ 56,0 il verdetto cadrebbe. Serve
>   `ABTG_SpreadOrario` + un'ancora vera (n=2 oggi). **Margine: 12%. È stretto, e lo dico.**
> - `225JPY`: l'ADR è **misurato** (n=9) e lo spread pure (logger vivo, GG=5, **ora per ora**).
>   🎯 **Questo chiude il buco lasciato aperto da `CANCELLO_COSTO_FLOTTA` r.492-498**, che
>   ipotizzava *«se sul Nikkei valesse come sul DAX, 35 → ~21 e i rapporti diventerebbero
>   ~22,7×»*. **Il logger vivo dice 22-23 all'ora 14 e 35 all'ora 08: l'ipotesi era giusta, e
>   il numero non basta lo stesso.**

> ### 🔴 `XAGUSD`: **escluso per costo a qualunque TF e a qualunque durata di range**
> Il giorno intero dell'argento vale **26,7 volte** lo spread. Per arrivare a 40× servirebbe
> un ADR di **1,64 $** — cioè, sull'argento a ~40 $, un **range giornaliero del 4,1%**.
> 🧪 **Contro-esempio costruito prima**: *«e se lo spread vero fosse metà della sonda?»* A
> **0,0205 $** il tetto salirebbe a 53,4×, ma il range di **15'** varrebbe
> `1,095 × √(15/1380) = 0,114 $` = **5,6×**, e quello di 120' **15,8×**. 🔴 **Nemmeno
> dimezzando lo spread una geometria d'apertura passa.** Il verdetto non dipende dal bordo.
> ⚠️ **E dichiaro la debolezza**: l'ADR poggia su **n=4** e lo spread su **una lettura**.
> Il verdetto è **ESCLUSA PER COSTO** perché il margine è di **1,5 volte**, non del 5%; ma se
> qualcuno volesse riaprirlo, la porta è `ABTG_SpreadOrario` su `XAGUSD` + un'ancora vera.

---

# 6. 🥇 I METALLI — la risposta alla domanda 4, e **non sono nello stesso campionato**

## 6.1 🔴 Perché il range d'apertura dell'oro **non si può inferire** — il contro-esempio che mi ha fermato

La tentazione era: *ADR × √(T/W) = range di apertura*. **L'ho provata sui tre indici dove ho
tutte e due le misure, e sbaglia — di quanto, non si sa dire:**

| simbolo | `ADR × √(15/W)` | **R₁₅ MISURATO** | **rialzo d'apertura** |
|---|---:|---:|---:|
| `D30EUR` (W=780) | 35,02 | **54,65** | **×1,56** |
| `NASUSD` (W=1380) | 40,10 | **75,30** | **×1,88** |
| `U30USD` (W=1380) | 39,57 | **119,75** | 🔴 **×3,03** |

> 🎯 **I primi minuti dopo la campanella valgono da 1,6 a 3,0 volte quello che la legge √T
> predice — e il fattore varia di DUE VOLTE fra tre simboli dello stesso tipo.**
> 🔴 **Quindi per l'oro — che una campanella non ce l'ha — quel fattore è `[NON MISURATO]` e
> non è stimabile.** Inventarlo qui sarebbe esattamente il difetto del 10/09: una formula
> verificata contro due numeri che tornano, con l'incognita libera.
> 🟢 **Ma la legge √T resta un LIMITE INFERIORE utilizzabile**, perché il rialzo misurato è
> **≥ 1 su tre simboli su tre**: se l'oro passa il 40× **senza** rialzo, passa a maggior ragione.

## 6.2 🚦 L'oro sotto la legge più prudente (`ADR = 62,60 $`, `W = 1380`, **nessun rialzo**)

| durata del range | stop implicito | **su BCM** (0,2503 $) | **su FTMO** (0,45 $, comm. `[NM]`) |
|---:|---:|---:|---:|
| 15' | 6,53 $ | 🔴 26,1× | 🔴 14,5× |
| 30' | 9,23 $ | 🔴 36,9× | 🔴 20,5× |
| **35'** | 9,97 $ | 🟠 **39,8×** *(sulla riga esatta)* | 🔴 22,2× |
| **45'** | 11,30 $ | 🟢 **45,2×** | 🔴 25,1× |
| 60' | 13,05 $ | 🟢 52,1× | 🔴 29,0× |
| 90' | 15,99 $ | 🟢 63,9× | 🔴 35,5× |
| **120'** | 18,46 $ | 🟢 73,8× | 🟢 **41,0×** |
| **minuti richiesti per il 40×** | | 🟢 **35,3'** | 🔴 **114,1'** |

> ## 🎯 **LA RISPOSTA ALLA DOMANDA 4, in tre righe**
> 1. 🟢 **`XAUUSD` ha il tetto più alto di tutta la flotta (250×)**: il costo **non** è il suo
>    problema. È il **DD** (45,91% su `971501` a rischio 1%, `CANCELLO_COSTO_FLOTTA` r.463) —
>    **due assi diversi**, e confonderli è l'errore che quel referto mette in testa a se stesso.
> 2. 🟡 **Ma il TF non c'entra: quello che decide è `InpRangeMinutes`.** Sotto la legge
>    prudente l'oro **non passa a 15'** e **passa da 35-45' in su su BCM**. Su **FTMO** serve
>    **~2 ore**, perché lo spread oro di FTMO (**0,45 $**) è **2,1 volte** quello di BCM
>    (0,21 $) — misurato, non assunto (`SPREAD_APERTURA_FTMO_2026-09-21.md` §1).
> 3. 🔴 **`XAGUSD` è fuori, a qualunque TF e a qualunque range** (§5). **Non è «lo stesso
>    campionato con numeri diversi»: è un altro sport.**

## 6.3 🔴 E il prerequisito che va chiuso **prima** di qualunque passata sui metalli

| buco | stato | come si chiude | costo |
|---|---|---|---|
| **range d'apertura di `XAUUSD` e `XAGUSD`** | 🔴 `[NON MISURATO]` — `studio_apertura/` ha **8 file, tutti indici** | **`ABTG_Apertura_Study_EA`** (lo stesso che ha prodotto gli altri 8), 2 simboli × 1-2 ore d'apertura | 🟢 **2-4 passate**, ~**0,3 min** al ritmo misurato |
| **profondità dei tick di `XAUUSD`** | 🔴 `[NON MISURATO]` — `misura_tick/` ha **3 referti**: `D30EUR`, `NASUSD`, `U30USD`. Dichiarato aperto in `report/CACCIA_APERTURE_ORO_2026-09-08.md` r.409 e `report/DA_FIRMARE.md` r.293 | `scarica_storico.ps1` in sonda | 🟢 zero passate di tester |
| ⚠️ **e c'è una contraddizione in casa** | `report/DIARIO.md` r.43 (08/08) scrive *«B9 sull'oro CHIUSA: dati ok dal 26/09/2024»*, ma **non è un referto di `misura_tick`**. 🔴 **Finché le due fonti non concordano, la profondità oro resta `[NON VERIFICATA]`** | la sonda sopra chiude anche questa | — |
| **commissione FTMO sui CFD e sull'oro** | 🔴 `[NON MISURATO]` (`STOP_VS_SPREAD_FTMO` **r.610-611**). R5 è definito su `spread + commissione`: **ogni × di FTMO in questo referto è un TETTO** | una posizione da `VolMin` e la colonna commissione — **firma di Claudio** | 1 operazione |

---

# 7. 🏦 LA STESSA MAPPA SU **FTMO** — perché è lì che si schiera

Spread FTMO: `report/SPREAD_APERTURA_FTMO_2026-09-21.md` §1 — logger vivo sul terminale
**`541452707` (`C:\FTMO`)**, 35.092 campioni, **ora 10 server = apertura DAX**.
🟠 **`GG = 1`**: una giornata sola. Il referto lo marca SOTTILE e io lo ripeto.

| BCM | FTMO | spread med | P95 | **R35/med** | **R35/P95** | verdetto |
|---|---|---:|---:|---:|---:|---|
| `D30EUR` | `GER40.cash` | **1,23** | 1,33 | 🟢 **67,9×** | 🟢 **62,8×** | 🟢 **AMMESSA** |
| `U30USD` | `US30.cash` | **2,10** | 2,48 | 🟢 **87,1×** | 🟢 **73,8×** | 🟡 **AMMESSA, ma all'ora sbagliata** ⬇️ |
| `NASUSD` | `US100.cash` | **1,45** | 1,65 | 🟢 **79,3×** | 🟢 **69,7×** | 🟡 idem |
| `SPXUSD` | `US500.cash` | **0,60** | 0,60 | 🔴 **32,5×** | 🔴 32,5× | 🟠 **passa da 53' di range in su** |
| `XAUUSD` | `XAUUSD` | **0,45** | 0,45 | ⚪ | ⚪ | 🔴 serve **114'** di range (§6) |

> ### 🔴 IL LIMITE CHE RENDE DUE DI QUESTE RIGHE PROVVISORIE
> Il logger FTMO è partito **alle 01:05 e si è fermato alle 10:50 server**: la fascia
> **cash USA 16-22 srv dice «nessun campione»** (`SPREAD_APERTURA_FTMO` §5.2).
> 👉 **`US30.cash` e `US100.cash` all'ora 14 — cioè all'ora in cui la famiglia Apertura USA
> ENTRA — sono `[NON MISURATO]` su FTMO.** I due 🟢 qui sopra usano l'ora 10.
> 🧪 **Quanto margine c'è?** `US30` rompe il 40× a **4,57** contro i 2,10 misurati: servirebbe
> uno spread **2,2× più largo** all'apertura USA per ribaltarlo. Su BCM lo stesso confronto
> (ora 14 contro ora 10) vale **2,00 contro 2,60 = 0,77×**, cioè **più stretto**, non più
> largo. 🟢 **La direzione dell'errore è favorevole, ma il numero non ce l'ho.**

> ### 🎁 E LA NOTIZIA BUONA CHE ESCE DA QUI: **su FTMO l'S&P costa meno della metà che su BCM**
> `US500.cash` **0,60** contro `SPXUSD` **1,40**: **−57%**. Il tetto passa da **35,6×** a
> **~83×**, e il simbolo **esce dalla condanna definitiva** e diventa *«ammissibile da 53
> minuti di range in su»*. 🔴 **Ma i round girano su dati BCM**, e su BCM `SPXUSD` resta
> escluso: **sarebbe una sedia validata su un feed dove il costo non passa e schierata su un
> feed dove passa.** Quella è una decisione, non una misura, e non è mia.

---

# 8. 🌀 `RANGE_FADE` — **l'unico modo in cui il TF morde davvero**, e il cancello lo taglia

Stop del fade = `ATR(PERIOD_CURRENT, InpAtrPeriodMgmt) × InpAtrSlMult` (**r.976**), con
`InpAtrSlMult = 1,5` di default (**r.283**). ATR per TF dalla legge validata
`ATR(T) = ancora × √(T/W)` (`ANCORA_ADR_FLOTTA_INDICI` §4, **W = 780 DAX · 1380 USA**,
errori misurati **+0,3%** e **−0,7%** a H4 e H1).

| simbolo (spread) | | **M5** | **M15** | **M30** | **H1** |
|---|---|---:|---:|---:|---:|
| **`D30EUR`** (1,70) | ATR → stop | 20,2 → 30,3 | 35,0 → 52,5 | 49,5 → 74,3 | 70,0 → 105,0 |
| | **×** | 🔴 17,8× | 🔴 30,9× | 🟢 **43,7×** | 🟢 **61,8×** |
| **`NASUSD`** (1,80) | ATR → stop | 23,2 → 34,7 | 40,1 → 60,1 | 56,7 → 85,1 | 80,2 → 120,3 |
| | **×** | 🔴 19,3× | 🔴 33,4× | 🟢 **47,3×** | 🟢 **66,8×** |
| **`U30USD`** (3,00 prud.) | ATR → stop | 22,8 → 34,3 | 39,6 → 59,3 | 56,0 → 83,9 | 79,1 → 118,7 |
| | **×** | 🔴 11,4× | 🔴 19,8× | 🟠 28,0× *(42,0× a spr 2,00)* | 🟠 **39,6×** *(59,4× a spr 2,00)* |

> ## 🎯 **IL FADE PASSA SOLO DA M30 IN SU, E SUL DOW NON È DECISO**
> - 🟢 **`D30EUR` M30 · H1** e **`NASUSD` M30 · H1**: **AMMESSE**.
> - 🔴 **M5 e M15 su tutti e tre: ESCLUSE PER COSTO**, con margini fra il 28% e il 50% del
>   pavimento. *(È la conferma della riga di casa «su M5 gli indici sfondano la frontiera» —
>   ma vale **solo per il fade**: per gli altri cinque modi M5 va benissimo, perché lo stop
>   non è la barra, è il range. `CANCELLO_COSTO_FLOTTA` §6.1 lo dimostra già su 7 sedie.)*
> - 🟠 **`U30USD`: NON DECISA su M30 e H1**, perché il verdetto si ribalta col disaccordo di
>   spread del §3.2 (2,00 contro 3,00). **Tengo H1 in griglia come 🟠 FRAGILE e scarto M30**:
>   H1 al bordo prudente fa 39,6× (−1%), M30 fa 28,0× (−30%).
>
> ⚠️ **E il limite della riga M5, dichiarato**: la legge `√T` è validata **a H1 e H4**, non a
> M5. Estrapolarla a 5 minuti è `[INFERITO]`. 🟢 **Ma non cambia il verdetto**: perché M5
> passasse il 40× servirebbe un ATR(M5) **2,2× più grande** di quello che la legge predice —
> e la legge, dove è misurata, sbaglia dello **0,3-1,5%**, non del 120%.

---

# 9. ✂️ LA MATRICE TAGLIATA — **le 58 celle, elencate per nome**

🔴 *Elencate, non definite per differenza (classe 180).*

| blocco | modi | TF | simboli | lati | **celle** | **passate** |
|---|---|---|---|---:|---:|---:|
| **A** — TF inerte | `BREAKOUT` · `GAPFILL` · `RETEST` · `DELAYED` | **uno solo** (M5, per costo nullo e massima granularità del trailing) | `D30EUR` · `U30USD` · `NASUSD` | L, S | **24** | **48** |
| **B** — `OPENCONFIRM` | `OPENCONFIRM` | **M5 · M15 · M30 · H1** *(via `InpOCTimeframe`, input esplicito r.235: **non serve cambiare grafico**)* | `D30EUR` · `U30USD` · `NASUSD` | L, S | **24** | **48** |
| **C** — `RANGE_FADE` | `RANGE_FADE` | `D30EUR` **M30·H1** · `NASUSD` **M30·H1** · `U30USD` **H1** 🟠 | (sopra) | L, S | **10** | **20** |
| | | | | **totale** | 🟢 **58** | 🟢 **116** |

### 💰 Il costo in tempo macchina, con il ritmo dichiarato prima del numero

| ritmo | fonte | **116 passate** | *(confronto: 480 a forza bruta)* |
|---|---|---:|---:|
| 🟢 **0,085 min/passata** | `CHI_ALTRO_PUO_SCHIERARSI_2026-09-22.md` r.64 — **stessa famiglia, stesso simbolo, stesso TF, tick reali** | 🟢 **~10 min** | ~41 min |
| 0,375 min/passata | R112, tick, per-trade, 8 gambe separate | ~44 min | ~3,0 h |
| 0,750 min/passata | bordo alto di `ALLARGARE_LA_ROSA` r.340 | **~1,5 h** | ~6,0 h |
| *(5,5 min/passata del mandato)* | 🔴 **`[NON RITROVATO IN REPO]`** | *10,6 h* | *44,0 h* |

### 🧱 E i due vincoli che **non** sono di costo ma limitano lo stesso

1. ⏳ **Finestra**: i tick BCM partono dal **2024.09.26** su tutti e tre i simboli
   (`misura_tick/REFERTO_MISURA_TICK_{D30EUR,NASUSD,U30USD}.txt`, *«IL BROKER NON HA PIÙ
   STORICO»*) ⇒ **~21 mesi ≈ 450 giornate**.
2. 📊 **Frequenza**: `InpOneTradePerDay = true` (r.226) ⇒ **al massimo 1 operazione/giorno**
   ⇒ **n ≤ ~450 per cella, prima di qualunque filtro**. 🟢 Sopra il muro dei 150, ma **non
   c'è margine per uno split IS/OOS più filtri stretti**: con un filtro che dimezza, l'OOS
   sta sotto i 150. **Va guardato prima di scegliere la finestra, non dopo.**
3. 🔴 **`Max barre nel grafico` non è più un vincolo**: `MaxBars = 10.000.000` sul banco
   `50504400`, misurato il 09/09 (`LE_SONDE_A_COSTO_ZERO_2026-09-23.md` §0, riga 3).
4. 🖥️ **Dove gira**: firma di Claudio del **21/09** — *«i round sul PC di backtest»*. Il banco
   `50504400` sul VPS **resta spento** mentre la challenge opera.

---

# 10. 🚩 I BUCHI, DICHIARATI — e la via più corta per chiuderli

| # | buco | stato | come si chiude | costo |
|---:|---|---|---|---|
| 1 | **spread orario di `F40EUR` · `E50EUR` · `100GBP` · `E35EUR` · `SPXUSD` · `200AUD`** | 🔴 `[NON MISURATO]` — una sola lettura istantanea, **all'ora sbagliata** per i quattro europei | `ABTG_SpreadOrario` via `RIGA_SPREAD_FLOTTA.ps1`. 🔴 **Ma il bersaglio è cablato su `C:\MT5_Backtest` (r.265) = banco VPS spento**: serve un `-TerminaleBacktest`, **che è una modifica a uno script e passa dal cancello** (`LE_SONDE_A_COSTO_ZERO` §1) | **0 passate di tester** |
| 2 | ⚠️ **e prima ancora: i tick di quei simboli esistono?** | 🔴 `[NON MISURATO]` — `misura_tick/` ha 3 referti su 10 indici. 🔴 **E `backtest_pipeline/ini/valid_MaxMin_F40EUR.ini` porta `Model=4` con `FromDate=2024.01.01`, NOVE MESI prima del muro degli altri**: se il muro è lo stesso, quella corsa ha usato tick generati senza dirlo | `ABTG_InfoBroker` | **0 passate** |
| 3 | **range d'apertura di `XAUUSD`, `XAGUSD`, `200AUD`, `225JPY`** | 🔴 `[NON MISURATO]` | `ABTG_Apertura_Study_EA` | **~4-8 passate, <1 min** |
| 4 | **spread FTMO all'apertura USA (ora 14 srv)** | 🔴 `[NON MISURATO]` — il logger si è fermato alle 10:50 | secondo giro del logger alle 16:00 italiane (**P2** di `STOP_VS_SPREAD_FTMO` §7.5) | **0 passate**, 🖥️ riga di sola lettura sul **terminale FTMO `541452707` (`C:\FTMO`)** |
| 5 | **commissioni e swap FTMO** | 🔴 `[NON MISURATO]` | **firma di Claudio**: 1 posizione da `VolMin` | 1 operazione |
| 6 | **profondità tick `XAUUSD`** | 🔴 `[NON VERIFICATA]` — due fonti in casa che non concordano (§6.3) | `scarica_storico.ps1` in sonda | **0 passate** |
| 7 | **spread al MINUTO dentro l'ora d'apertura** | 🔴 `[NON MISURATO]` su tutti. 🔴 **Direzione dell'errore nota e SFAVOREVOLE**: `U30USD` ora 14 ha `max = 47,00` punti indice, **23× la mediana** | logger a passo fine | — |
| 8 | **slippage** | 🔴 quasi tutto `[NON MISURATO]`: **n=1** sul reale (+0,70 idx, `IL_PRIMO_SLIPPAGE_VERO_2026-09-11.md`), **zero** su FTMO. **Il 40× di questo referto è `40 × spread` e basta** | `ABTG_SlippageLogger` sul terminale FTMO | continuo, zero impatto |
| 9 | **ancore di `SPXUSD` e `F40EUR`** | 🔴 `[NON CITABILE]` (n=2 e n=1): i loro tetti in §5 sono `[INFERITO]` dal rapporto `R₁₅/ADR` di un altro simbolo | tempo, o un export dedicato | — |

---

# 11. 🧪 I CONTRO-ESEMPI — costruiti **prima** di consegnare

### 11.1 ❓ *«Dici che il TF non tocca lo stop. Ma allora perché 21 mesi di round hanno girato su M5?»*
🟢 **Non è una contraddizione: è la scoperta.** Le sedie vive girano su M5 **per abitudine**,
non perché il TF faccia qualcosa. E il sorgente lo conferma due volte: `CANCELLO_COSTO_FLOTTA`
**§6.1** aveva già verificato che *«nessuna sedia è bocciata perché è su M5»* e che
*«le due sedie su M5 con lo stop più largo PASSANO mentre una su H1 non passa»*.
👉 **Quel referto aveva già misurato l'effetto senza nominarne la causa. La causa è `PERIOD_M1`
a r.844.**

### 11.2 ❓ *«La tua colonna del range è la stessa di `STOP_VS_SPREAD_FTMO`: ti stai autoconfermando.»*
🔴 **No, ed è il controllo più forte del referto.** Ho ricalcolato `ampiezza_pt` da zero e
confrontato con la loro colonna **stop**, che è `R + costante` con **tre costanti diverse**
(+3,00 · +6,00 · +2,00, da `r.84-86`). **Sei numeri su sei tornano** (§4.1). Due colonne che
differiscono per tre costanti diverse **non possono tornare per caso**.

### 11.3 ❓ *«L'esclusione dei cinque indici europei poggia su una sonda di un istante.»*
🟢 **Accolta, e per questo ogni riga è scritta DUE VOLTE** (§3.3 e §4.2). Il bordo ottimista
non è «un secondo valore della stessa faccia» (classe 650 punto 4): è la **correzione
d'apertura MISURATA sul DAX** (2,60 → 1,70), cioè l'**altra faccia**.
🔴 **E sotto tutti e due i bordi i cinque restano esclusi**, il più vicino al 29% dal
pavimento. **L'esclusione non dipende dal bordo scelto.**

### 11.4 ❓ *«Il tetto `ADR/spread` è un'invenzione tua per chiudere le domande in fretta.»*
🟢 **È un'identità, non un'euristica**: lo stop della famiglia Apertura è `R + k`, e
`R ≤ ADR` per definizione (il range di N minuti è contenuto nel range del giorno). Quindi
`stop/spread ≤ ADR/spread + k/spread`. 🔴 **E dichiaro il termine che salta**: con un buffer
`k` grande il tetto si alza. Per ribaltare `E50EUR` (27,7×) servirebbe `2B ≈ 24,6` punti
indice di buffer **su un simbolo il cui range di 15' mediano è 12,00** — cioè **uno stop il
doppio del range**. Non è più una geometria d'apertura.

### 11.5 ❓ *«Hai dato per buono il 5,5 min/passata del mandato?»*
🔴 **No, e l'ho rotto**: §0. Il numero non è in repo, e il ritmo **misurato sulla stessa
famiglia, stesso simbolo, stesso TF, a tick reali** è **0,085 min/passata** — **65 volte più
veloce**. 👉 **Se avessi accettato la premessa, avrei consegnato un taglio giustificato con
una ragione falsa** — e sarebbe stata la classe del 10/09: controllare che la risposta sia
coerente con l'attesa invece di provare a romperla.

---

# 12. 📌 IL QUADRO FINALE — ogni numero con la sua etichetta

| # | numero | valore | etichetta |
|---:|---|---|---|
| 1 | il range d'apertura si legge su `PERIOD_M1` **cablato** | Dow r.844-857 · DAX r.1145-1158 · Nasdaq r.941-954 | 🟢 `[MISURATO — sorgente]` |
| 2 | TF del grafico su `BREAKOUT`/`GAPFILL`/`RETEST`/`DELAYED` coi default | **manopola INERTE** | 🟢 `[MISURATO — sorgente, 7 punti di chiamata]` |
| 3 | range mediano 15' | `U30USD` **119,75** · `NASUSD` **75,30** · `D30EUR` **54,65** | 🟢 `[MISURATO, n=446/447/440]` |
| 4 | range mediano 35' | 182,92 · 115,02 · 83,48 | 🟡 `[INFERITO, ×√(35/15)]` |
| 5 | spread all'ora d'ingresso, BCM | `U30USD` **2,00-3,00** · `NASUSD` **1,80** · `D30EUR` **1,70** | 🟢 `[MISURATO]`, 🔴 disaccordo dichiarato sul Dow |
| 6 | **celle ammesse** | 🟢 **58 su 240** | — |
| 7 | simboli ammessi | 🟢 **`D30EUR` · `U30USD` · `NASUSD`** | `[MISURATO]` |
| 8 | simboli **esclusi per costo** | 🔴 `F40EUR` · `100GBP` · `E35EUR` · `SPXUSD` · `E50EUR` · `225JPY` · `XAGUSD` | `[MIS]` i primi cinque al range, `[INF]` i tetti di 4 su 7 |
| 9 | simboli **non misurabili** | ⚪ `200AUD` (nessuno Studio) · `XAUUSD` (nessun range d'apertura) | — |
| 10 | **TF più basso ammesso** | `D30EUR` · `U30USD` · `NASUSD`: 🟢 **M5** su 5 modi su 6; **M30** sul solo `RANGE_FADE` (H1 sul Dow, 🟠) | `[MISURATO]` / `[INFERITO]` per il fade |
| 11 | tetto `ADR/spread` | `XAUUSD` **250,1×** · `NASUSD` 213,7× · `D30EUR` 148,5× · `U30USD` 126,5× · 🔴 `SPXUSD` 35,6× · `E50EUR` 27,7× · `XAGUSD` 26,7× · `225JPY` 22,7× | `[MIS]` su 5, `[INF]` su 4 |
| 12 | 🆕 **ancora giornaliera `XAUUSD`** | **62,60 $**, n=67 giornate | 🟢 `[MISURATO]` — **calcolata in questo referto, non esisteva** |
| 13 | rialzo d'apertura contro la legge √T | ×1,56 (DAX) · ×1,88 (Nasdaq) · ×3,03 (Dow) | 🟢 `[MISURATO]` — e **varia di 2 volte: non si trasferisce** |
| 14 | oro, minuti di range per il 40× | 🟢 **35,3' su BCM** · 🔴 **114,1' su FTMO** | 🟡 `[INFERITO, legge √T senza rialzo = limite INFERIORE]` |
| 15 | spread FTMO | GER40 **1,23** · US30 **2,10** · US100 **1,45** · US500 **0,60** · XAUUSD **0,45** | 🟠 `[MISURATO, GG=1]`, e **all'ora 10, non all'apertura USA** |
| 16 | commissioni/swap FTMO | 🔴 `[NON MISURATO]` ⇒ ogni × di FTMO qui è un **TETTO** | — |
| 17 | slippage dentro il 40× | 🔴 **non c'è**: il 40× è `40 × spread` | `[dichiarato]` |
| 18 | ritmo macchina della famiglia | 🟢 **0,085 min/passata** (tick, M5, 18 mesi, stesso EA e simbolo) | 🟢 `[MISURATO]` — il 5,5 del mandato è 🔴 `[NON RITROVATO IN REPO]` |

---

### 🔒 PERIMETRO
Sessione in **SOLA LETTURA**. Nessun `.mq5`, nessun `.set`, nessun `.ini`, nessun terminale,
nessuna taglia, nessun magic, nessun backtest, nessuna riga di lancio. **Nessun candidato
archiviato come morto**: dove manca un dato questo file scrive `[NON MISURATO]` e dice cosa
servirebbe. Le esclusioni **PER COSTO** riguardano **una famiglia su un simbolo**, non il
simbolo in assoluto: un motore con uno stop di geometria diversa su `SPXUSD` o `E50EUR`
va misurato da capo. **Decide Claudio.**

*Referto del 24/09/2026.*
