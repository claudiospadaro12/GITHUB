# 🪑 COSTTOCOST EURJPY — LA SETTIMA SEDIA, CERCATA NEI CSV DI CASA — **R224**, 23/09/2026

**Sigla:** `R224` (verificata libera col grep nel momento in cui questa riga e' stata
scritta: `grep -rn "R224" --include="*.md" .` -> nessuna occorrenza).
**Costo macchina:** 🟢 **ZERO minuti.** Nessun round, nessuna corsa, nessuna riga verso il
VPS o verso il PC di backtest. Questo referto legge **solo CSV gia' in repo**.
**Domanda dell'incarico:** *«esiste, nei CSV che abbiamo gia', una configurazione di
`CostToCost` che tenga il merito e porti il DD dentro il muro?»*

---

# 0. 🔴 LA RISPOSTA IN QUATTRO RIGHE, prima dei numeri

1. **NO.** In archivio **non c'e'** una configurazione che tenga il merito **e** abbassi il
   drawdown. L'unica alternativa misurata (`InpExitMode=0`) abbassa il DD del **24,3%** ma
   si porta dietro **−49,8% di profitto** e **−26,1% di Recovery Factor**: paga il rischio
   col motore. 👉 **Sul merito, il DEFAULT VA BENE** — ed e' un risultato, non un
   fallimento.
2. 🔴 **MA IL TAPPO DICHIARATO NON E' IL TAPPO.** Il blocco di questa sedia e' scritto
   ovunque come *«DD 12,26% contro 9,33% promesso = 1,31×»*. Il numero che sfonda un muro
   prop **non e' quello**: e' la **PEGGIOR GIORNATA**, **−8,02%** su BCM nativo a 100k
   (`r127c` OOS) e **−10,07%** nell'ORSO 2022, **contro il muro giornaliero del 5%**. Era
   **nella stessa riga di CSV**, in una colonna che nessuna classifica ha ordinato.
3. 🟢 **E li' una configurazione alternativa ESISTE, e ha un MECCANISMO, non un pescaggio.**
   `exit 0` e `exit 1` tengono la giornata dentro il 5% dove `exit 2` la sfonda: misurato su
   **864 celle** (48 simboli × 3 uscite × 3 lati × **due timeframe**), appaiato per simbolo,
   **135/144 su H4** e **128/144 su H1**.
4. 🔴 **Il DD del 12,26% non e' un'anomalia da correggere: e' il centro della distribuzione
   del motore.** Su cinque finestre di regime lo stesso ingranaggio fa **10,63 · 10,89 ·
   14,31 · 14,83 · 16,60 %** a rischio 1,00%. **Non esiste una manopola d'ingresso che
   porti questo motore sotto il 9,33%**, e il 9,33% promesso era il DD della **finestra piu'
   corta che abbiamo** (13,5 mesi).

---

# 1. 🧪 I CONTRO-ESEMPI, costruiti PRIMA di consegnare

## 1.1 ✅ Contro-esempio (a) — «e' piu' piccola»: **FALSIFICATO, con il numero**

`exit 0` fa **piu'** operazioni di `exit 2` (194 contro 155) e **meno** profitto
(2.104,55 contro 4.195,14). Se fosse un effetto di **taglia**, il Recovery Factor
sarebbe **INVARIATO** per costruzione. Non lo e': **2,296 contro 3,106, −26,1%.**
👉 Non e' una sedia piu' piccola: e' un motore che rende **meno per unita' di rischio**.

E la seconda gamba dell'obiezione — **la troncatura del lotto a 10.000 EUR di deposito**
(`lancia_r53.ps1` r.29: *«sui cambi a 10k il lotto minimo schiaccia il rischio»*) —
**e' misurata, non assunta**, sui volumi veri di
`risultati_prove/trades_cost/abtg_trades_ABTG_CostToCost_EURJPY_772351.csv` (64 operazioni,
volumi da **1,48** a **10,09** lotti a 100k → da **0,148** a **1,009** a 10k):

| errore di quantizzazione del lotto a 10k | mediana | p90 | **massimo** |
|---|---:|---:|---:|
| in % del rischio per operazione | **0,61%** | 1,41% | **1,82%** |

👉 **1,82% al caso peggiore non spiega un divario di RF del 26,1%.** L'obiezione cade.

## 1.2 ✅ Contro-esempio (b) — «e' il picco di una griglia»: **VERO, e lo dichiaro**

| test | esito |
|---|---|
| la cella `exit 0 long` e' la **1ª o la 2ª su N** ordinata per PF? | 🔴 **2ª su 9** per PF (1,3427 dietro 1,5459), **2ª su 9** per RF, **1ª su 9** per peggior giornata. **NON e' un centro d'altopiano** |
| l'asse e' ordinale, quindi l'altopiano e' osservabile? | 🔴 **NO: `InpExitMode` e' CATEGORICO.** 0, 1 e 2 sono tre macchine diverse (TP sulla punta opposta · TP a N×rischio · nessun TP). Fra 0 e 2 non esiste un «1,5». **La regola "centro dell'altopiano" qui non ha referente e non si applica** |
| la griglia veniva da un **genetico**? | 🟢 **No**: 9 celle su 9 nel CSV, enumerazione completa. L'altopiano non e' osservabile per la ragione sopra, non perche' manchino le celle |
| esiste un altopiano in **un'altra direzione**? | 🟢 **SI', ed e' quello su cui appoggio la conclusione del §4**: la direzione **trasversale ai simboli**. `exit 2` produce la giornata peggiore in **135/144** celle appaiate su H4 e **128/144** su H1. Quello e' un effetto di meccanismo, non una cella che sporge |

🔴 **E l'avvertenza ereditata da `report/I_MORTI_E_LO_STORICO_2026-09-23.md` (voce 5) resta
valida alla lettera: `exit 0` e' stata pescata DENTRO un CSV DOPO aver visto i numeri.**
Quello che questo referto aggiunge **non e' una conferma della cella**, e' una conferma del
**meccanismo** su 864 celle e due TF. Sono due cose diverse e non le confondo: sulla
**redditivita'** di `exit 0` su EURJPY non ho nessuna prova fuori campione, e resta selezione.

## 1.3 ✅ Contro-esempio (c) — «e' una manopola INERTE»: **NO sull'uscita, SI' sull'orologio**

- **`InpExitMode` MORDE**: le 9 celle EURJPY H4 hanno 9 valori di `Profit` **tutti distinti**.
- 🔴 **`InpMaxBarsHold` E' INERTE, ed e' misurato**: in `r127c`, **8 valori** → **3 esiti
  distinti** in IS e **3** in OOS. Da **75 a 200** le righe sono **identiche al centesimo**
  (Profit 71.284,16 · PF 1,52341 · RF 4,30178 · DD 12,2627 · n 242, sei volte di fila).
  👉 **Il time-stop non e' una casella provata: e' una casella LIBERA** (sotto le 75 barre
  morde: a 25 fa n=257 e PF 1,45246; a 50 fa PF 1,52364). E **su `exit 0` e `exit 1` la sua
  vincolativita' e' [NON MISURATA]**, perche' quelle due celle hanno un TP e quindi un
  orologio diverso.

## 1.4 🔴 Contro-esempio (d) — **«6 anni su 7 nasconde una sedia fortunata?»**

Fonte: `backtest_pipeline/risultati_archivio/R103_REFERTO_DRIVER_FOREX_METALLI_20260824_1922.txt`,
blocco **F04**, *«LA SPINA DORSALE ANNO PER ANNO»* — netto **REALIZZATO** a rischio 1,00%,
deposito 100.000, che il file stesso dichiara *«NON e' l'equity e NON e' il DD»*.

| anno | n | netto EUR | quota del totale |
|---|---:|---:|---:|
| 2020 | 66 | +4.991 | 5,3% |
| 2021 | 51 | +1.115 | 1,2% |
| 2022 | 59 | +13.036 | 13,8% |
| 2023 | 63 | +17.339 | 18,4% |
| 2024 | 67 | +16.642 | 17,6% |
| **2025** | 58 | **+45.187** | 🔴 **47,9%** |
| 2026 *(parziale, al 30/06)* | 30 | **−4.007** | −4,2% |
| **TOTALE** | **394** | **+94.302** | |

📐 *Arrotondamento dichiarato: la somma delle sette righe fa **+94.303**; R103 scrive
**+94.302** sia nell'intestazione sia nella colonna «cumulato». Differenza **1 EUR**, dovuta
all'arrotondamento delle righe annuali. Tengo il numero del file, non il mio.*

| test (definizioni di R219 §1.2) | valore | soglia | esito |
|---|---:|---:|---|
| **B1** totale − anno migliore | **+49.116** | > 0 | ✅ |
| **B1** anno migliore / somma dei positivi | **45,96%** | < 60% | ✅ |
| **B2** totale − i due anni migliori | **+31.777** | > 0 | ✅ |
| **C1** \|anno peggiore\| / somma dei positivi | **4,08%** | < 50% | ✅ |

🟢 **Passa tutti e quattro.** Non e' una sedia fortunata nel senso stretto.
🔴 **Ma la concentrazione c'e' lo stesso, e va scritta accanto:**
- **il 2025 da solo vale il 47,9% del totale**;
- **i quattro anni 2022-2025 valgono il 97,8%** (+92.204 su +94.302);
- **i primi due anni — 24 mesi e 117 operazioni — valgono il 6,5%** (+6.106);
- **il 2026, l'unico pezzo di finestra in cui lo yen non si stava indebolendo, e' NEGATIVO**,
  e lo dice **due volte in modo indipendente**: R103 (−4.007 su n=30) e il file delle
  operazioni vere di r41 (`abtg_trades_..._772351.csv`: **2025 +26.434 su 34 operazioni ·
  2026 −3.598 su 30 operazioni**).

👉 **La lettura onesta e': `6/7` e' vero, ma questo motore e' un LONG-ONLY su un cross yen
misurato quasi tutto dentro una fase di indebolimento dello yen** *(il contesto di mercato
e' [NON MISURATO IN CASA]: quello che e' misurato e' la forma della curva annuale, non la
sua causa)*. **L'ipotesi «e' un regime travestito da motore» questo referto NON PUO'
falsificarla**, e non fingo il contrario.

---

# 2. 🆔 LA CARTA D'IDENTITA' — la cella migliore di oggi, riga per riga

> 📐 **Classe 604 applicata PRIMA di mettere due numeri in colonna.** Il deposito di ogni
> corsa non e' scritto nei CSV: l'ho **ricavato** con `capitale = (Profit/RF)/(DD%/100)`,
> che restituisce l'**equity al picco** nel momento del DD massimo — quindi un numero
> **appena sopra** il deposito. Esito: `r127c`/`r41`/regimi → **103k-142k = deposito
> 100.000**; `scan_h4`/`r40` → **10,0k-12,9k = deposito 10.000**. **Le due famiglie NON si
> mettono nella stessa colonna di DD%.**

## 2.1 🪑 La cella **SCHIERATA** (contratto `772361`)

`InpExitMode=2` (flip di struttura, **nessun TP**) · **solo LONG** · H4 · `InpTP_R=1.5` ·
`InpSLBufferATR=0.2` · `InpAtrPeriod=14` · `InpMinRangeATR=0.0` · `InpMaxBarsHold=100` ·
`InpWarmupBars=500` · `InpMaxSpreadPts=300` · `InpEntryWindowBars=3`.

| corsa | file · riga | dep. | finestra | modello | Profit | **PF** | **RF** | **DD%** | **PEGG. GIORN.** | n |
|---|---|---:|---|---|---:|---:|---:|---:|---:|---:|
| **R103 F04** *(la fonte di R219)* | `risultati_archivio/R103_REFERTO_DRIVER_FOREX_METALLI_20260824_1922.txt`, blocco **F04** | 100k | 2020.01.01→2026.06.30 | 1 (OHLC) | +94.302 | **1,410** | [n/d] | **12,26** | 🔴 **−8,01** *(OPTFRAME)* · −1,57 *(dai deal)* | **394** |
| **r127c IS** | `risultati_prove/dal_vps/ABTG_CostToCost/ABTG_CostToCost_EURJPY_IS_ohlc_r127c.csv`, **Pass 3** | 100k | 2020.01.08→~2022.08 | 1 | +13.368,74 | 1,17686 | 1,17244 | 10,9946 | −4,2160 | 153 |
| **r127c OOS** | `..._EURJPY_OOS_ohlc_r127c.csv`, **Pass 3** | 100k | ~2022.08→2026.06.30 | 1 | +71.284,16 | **1,52341** | **4,30178** | **12,2627** | 🔴 **−8,0159** | 242 |
| **r40 OOS** *(= il «9,33% promesso»)* | `risultati_prove/ABTG_CostToCost/r40/ABTG_CostToCost_EURJPY_OOS_r40.csv`, **Pass 1** | **10k** | ~2025.05→2026.06 (13,5 mesi) | 1 | +2.196,82 | 1,74020 | 1,82843 | **9,3345** | −3,9740 | 64 |
| **r41 OOS** *(stessa cella, deposito ×10)* | `.../r41/ABTG_CostToCost_EURJPY_OOS_r41.csv`, **Pass 1** | 100k | idem | 1 | +22.252,20 | 1,74084 | 1,82309 | **9,4547** | −4,0041 | 64 |

🟢 **Due verifiche che reggono e vanno dette:**
- **il −8,01% di R103 e il −8,0159% di r127c OOS sono DUE CORSE INDIPENDENTI** (magic
  760050/760051 contro 779430, finestre diverse, script diversi) e **coincidono alla seconda
  cifra**. Non e' un refuso di un file solo.
- **r40 contro r41 isola il DEPOSITO da solo**: stessa cella, stessa finestra, deposito
  10k → 100k, e il DD passa da **9,3345** a **9,4547**, cioe' **+0,12 punti (+1,29%
  relativo)**. 👉 **Quindi il salto 9,33 → 12,26 e' la FINESTRA, non il deposito.**
  Contro-esempio costruito e superato.

## 2.2 📉 Il vero blocco, letto nelle stesse righe

| il muro prop | il numero misurato su questa cella, **a rischio 1,00%** | fonte |
|---|---:|---|
| **totale 10%** (DD di equity) | **12,26%** | R103 F04 / r127c OOS |
| 🔴 **giornaliero 5%** | **−8,02%** (BCM nativo, 100k) · **−10,07%** (ORSO 2022, feed `_EXT`, 100k) · **−7,87%** (scan, 10k) | r127c OOS · `regime_r59/COST_EURJPY_ORSO_r59.csv` · `scan_h4/..._EURJPY.csv` Pass 5 |

🔴 **Tre finestre diverse, tre feed/depositi diversi, e tutte e tre sfondano il muro
giornaliero.** Il muro **totale** lo sfonda di **1,23×**; il muro **giornaliero** lo sfonda
di **1,57× · 1,60× · 2,01×** (scan · r127c OOS · ORSO).
👉 **Il tappo di questa sedia e' la GIORNATA, non il DRAWDOWN.**

---

# 3. 📚 TUTTO CIO' CHE E' GIA' STATO PROVATO — e le caselle rimaste vuote

## 3.1 Gli assi **realmente girati** su `ABTG_CostToCost`, in tutta la storia del repo

Ricavati col grep degli assi (`^Inp...||...||Y`) su **tutti** i file prova del motore
(`R40a-d`, `R41a-c`, `R102`×3, `R103`×3, `R127c`, `R214e`, `R214f`) piu' i due scan:

| asse | dove | esito |
|---|---|---|
| **lato** (`InpAllowLong`/`Short`) | R40 (4 simboli), scan H1+H4 | ✅ girato. Short **escluso PER MISURA**: 6 celle su 144 sopra PF 1,00 su H4, mediana 0,7648 |
| **`InpExitMode`** (0/1/2) | scan H1 + scan H4 **soltanto** | ✅ girato **una volta sola**, in OHLC, a 10k, su **una finestra [NON MISURATA]** |
| **`InpMaxBarsHold`** | R127c | ✅ girato · 🔴 **INERTE da 75 a 200** |
| **`InpTF`** | scan H1 vs scan H4 | ✅ H1 misurato e **catastrofico** (9 celle su 9 negative su EURJPY, DD 52,8-93,5%). 🔴 **H2 e D1 MAI**, e la TESI del motore prescriveva *«H4/D1 da spazzolare»* (sorgente r.149) |
| `InpMagic` | R41, R102, R103 | asse tecnico (gemelli), **3/3 identici** |

## 3.2 🕳️ Le manopole **MAI messe ad asse**, in nessun round, su nessun simbolo

| input | valore in **tutte** le corse | perche' e' una casella pesante |
|---|---|---|
| 🔴 **`InpMinRangeATR`** | **0,0 = FILTRO SPENTO, sempre** | la TESI del motore lo descrive cosi': *«un cost-to-cost piu' stretto dello spread e' un regalo al broker»*, e il sorgente lo marca *«0 = filtro SPENTO (default di screening: prima la frequenza)»*. 👉 **E' il filtro di qualita' del motore, e non e' mai stato acceso nemmeno una volta** |
| **`InpSLBufferATR`** | **0,2 sempre** | e' la manopola che fissa la distanza di stop → il lotto → **profitto e DD insieme**. ⚠️ Per la regola #2 dell'incarico va letta **solo** su RF/PF, mai su DD |
| **`InpTP_R`** | **1,5 sempre** | vive **solo** dentro `exit 1` (sorgente r.831). Quindi `exit 1` non e' «l'uscita R-based»: e' *«l'uscita R-based **a 1,5R**»*, e quel 1,5 non e' mai stato toccato |
| `InpAtrPeriod` · `InpWarmupBars` · `InpEntryWindowBars` | 14 · 500 · 3 | mai ad asse |
| `InpMaxSpreadPts` | **0 nello scan, 300 in tutto il resto** | mai ad asse, ed e' una **differenza fra lo scan e ogni altra corsa** che rende lo scan non-confrontabile con l'archivio |

## 3.3 🟢 Quello che invece **e' gia' misurato e nessuno sta citando**: le CINQUE finestre di regime

`backtest_pipeline/risultati_prove/regime_r59/COST_EURJPY_*.csv` — cella **schierata**
(`exit 2`, solo long, rischio 1,00%), deposito **100.000**, feed **`EURJPY_EXT`**
(il driver `prova_regime.ps1` r.24 sostituisce il simbolo con la versione `_EXT`).
🔴 **Dentro il feed `_EXT` e mai contro BCM** — lo impone il driver stesso alla r.124.
I file `regime_r50/` portano gli **stessi numeri alla quinta cifra** con magic diversi: e'
una prova di **determinismo 4/4**, non un doppione.

| finestra | periodo | Profit | **PF** | **RF** | **DD%** | **PEGG. GIORN.** | n |
|---|---|---:|---:|---:|---:|---:|---:|
| **CROLLO** (rischio) | 2020.02.01-04.30 | **−12.711,32** | 0,02454 | −0,836 | **14,8345** | −2,3564 | 23 |
| **CROLLO_ANNO** (merito) | 2020 | +20.881,56 | 1,69341 | 1,205 | 🔴 **16,6036** | −2,9515 | 67 |
| **TORO** | 2021 | +1.255,42 | 1,05315 | 0,112 | 10,6345 | −3,2413 | 46 |
| **ORSO** | 2022.01.01-10.31 | +47.260,47 | **2,65390** | 2,325 | 14,3083 | 🔴 **−10,0654** | 43 |
| **LATERALE** | 2019 | +8.918,44 | 1,38460 | 0,795 | 10,8901 | −4,4649 | 54 |

### Il verdetto secondo i criteri **congelati il 14/08** (`prove/PROVA_REGIME_CRITERI.md` §4)

- **A — SOPRAVVIVENZA** *(in ORSO e CROLLO il DD non supera 2× il DD OOS originale — qui
  2×9,33 = 18,66 — e comunque mai il 20%)*: ORSO **14,31** ✅ · CROLLO **14,83** ✅ →
  **PASSA**.
- **B — TENUTA** *(PF ≥ 0,90 nelle finestre avverse)*: 🛑 **il PF 0,02454 del CROLLO NON si
  usa**, e non perche' faccia comodo: `prova_regime.ps1` r.59-66 lo dichiara prima dei dati
  — *«CROLLO da tre mesi non accumula abbastanza operazioni per giudicare il merito; CROLLO
  → il RISCHIO, CROLLO_ANNO → il MERITO»*. Sul **CROLLO_ANNO** il PF e' **1,69341** →
  **PASSA**. *(Questo e' un errore che stavo per scrivere e che l'autoverifica ha fermato:
  leggere il PF di una finestra da 23 operazioni come un verdetto di merito.)*
- **C — PROMOZIONE DI RANGO** *(nell'ORSO PF ≥ 1,10 con DD dentro A)*: **PF 2,65390** →
  🟢 **PASSA. Questo motore SALE DI RANGO: lavora in tutti e due i regimi.**
- **D — DUE BANCHI**: nessuna decisione da una finestra sola. ✅ rispettato.

🔴 **E IL FATTO CHE CAMBIA LA DOMANDA DELL'INCARICO:** il DD di questa cella, a rischio
1,00%, **non scende MAI sotto il 10,63%** in nessuna delle cinque epoche. Il 12,26% non e'
un picco: **e' il centro.** 👉 *«Trovare una configurazione che porti il DD sotto 9,33%»*
non e' un problema di parametri d'ingresso — **nessun parametro d'ingresso ha quel
margine**. L'unica leva che lo farebbe e' `InpRiskPercent`, che **e' una firma di Claudio e
non si tocca**, e che per giunta abbasserebbe il DD **per aritmetica**, non per merito.

---

# 4. 🔎 LE CONFIGURAZIONI ALTERNATIVE TROVATE IN ARCHIVIO

Tutte e tre vivono in **UN SOLO FILE**: `risultati_prove/ABTG_CostToCost/scan_h4/scan_ABTG_CostToCost_H4_EURJPY.csv`
(9 righe, deposito **10.000**, modello OHLC, `InpMaxSpreadPts=0`, **finestra [NON
MISURATA]**). 🔴 **Nessuna delle due alternative e' mai stata girata su una finestra IS/OOS,
su un regime, o a tick.**

| riga | cella | Profit | **PF** | **RF** | **DD%** | **PEGG. GIORN.** | n |
|---|---|---:|---:|---:|---:|---:|---:|
| **Pass 5** | `exit 2` long — **la schierata** | 4.195,14 | **1,54592** | **3,10576** | 12,0482 | 🔴 **−7,8690** | 155 |
| **Pass 3** | `exit 0` long — cost-to-cost puro | 2.104,55 | 1,34274 | 2,29601 | **9,1158** | 🟢 **−1,2863** | **194** |
| **Pass 4** | `exit 1` long — R-based a 1,5R | 2.363,56 | 1,23787 | 1,72465 | 10,8444 | 🟢 **−1,9417** | 160 |

## 4.1 ⚖️ Il giudizio, con RF e PF accanto al DD come impone la regola #2

| confronto `exit 0` contro `exit 2`, **stessa finestra, stesso deposito** | variazione |
|---|---:|
| Equity DD % | **−24,3%** 🟢 |
| Profit | **−49,8%** 🔴 |
| **Recovery Factor** *(l'invariante alla taglia)* | **−26,1%** 🔴 |
| **Profit Factor** | **−13,1%** 🔴 |
| operazioni | **+25,2%** 🟢 |
| **Peggior giornata** | **da −7,8690 a −1,2863 = 6,1× meglio** 🟢🟢 |

🔴 **Sul MERITO la risposta e' secca: `exit 0` NON tiene il merito.** Perde su RF **e** su
PF. La pista della voce 5 di `I_MORTI_E_LO_STORICO` — *«l'uscita `exit 0` tiene anche dove
`exit 2` e' crollata?»* — **sull'unica finestra dove le due sono misurate insieme, NON e'
sostenuta**: `exit 0` non e' un `exit 2` con meno rischio, e' un motore piu' debole.
👉 **Verificata, non ereditata**, come chiedeva l'incarico.

🟢 **Sul RISCHIO GIORNALIERO la risposta e' l'opposta, ed e' la scoperta di questo
referto.** E non poggia sulla cella: poggia su **864 celle e due TF**.

## 4.2 🔬 La prova del meccanismo — 864 celle, 48 simboli, due timeframe

Tutte le celle degli scan `scan_h4/` e `scan_h1/` (48 simboli × 3 uscite × 3 combinazioni di
lato per TF), colonna `Peggior Giornata %`, **rischio 1,00%, deposito 10.000**:

| TF | uscita | mediana peggior giornata | peggiore | **celle che sfondano il muro giornaliero del 5%** |
|---|---|---:|---:|---:|
| **H4** | `exit 0` | −2,174% | −5,963% | **4 / 144 (2,8%)** |
| **H4** | `exit 1` | −1,969% | −7,191% | **2 / 144 (1,4%)** |
| **H4** | 🔴 `exit 2` | **−4,790%** | **−10,706%** | 🔴 **64 / 144 (44,4%)** |
| **H1** | `exit 0` | −3,516% | −12,813% | 23 / 144 |
| **H1** | `exit 1` | −3,668% | −33,262% | 20 / 144 |
| **H1** | 🔴 `exit 2` | **−5,768%** | −28,150% | 🔴 **96 / 144** |

**Appaiato simbolo per simbolo e lato per lato** (stesso simbolo, stesso lato, cambia solo
l'uscita): `exit 2` ha la giornata peggiore di `exit 0` in **135 casi su 144 su H4** e in
**128 su 144 su H1**. Sui soli long-only H4: **42 simboli su 48**, differenza mediana
**−1,787 punti percentuali**.

🧩 **E il meccanismo e' nel sorgente, non nell'interpretazione:** `exit 2` **non ha take
profit** — si esce solo quando gira il trend intermedio. Tiene aperto il flottante piu' a
lungo, e la restituzione arriva tutta insieme. `exit 0` chiude sulla punta opposta.
La metrica, per chi vuole ricontrollarla, e' **equity-based e tick-per-tick**
(`ABTG_CostToCost.mq5` r.486-495: minimo di equity della giornata contro l'equity
d'apertura del giorno) — **e' esattamente la definizione prop di perdita giornaliera**, non
una proxy.

## 4.3 🔴 I limiti di questa prova, per non venderla per piu' di quello che e'

1. **Non e' fuori campione.** 864 celle, ma **una finestra sola e [NON MISURATA]**: i 48
   simboli condividono lo stesso periodo. E' una prova **trasversale**, non un OOS.
2. **E' OHLC M1.** Sugli indici l'OHLC ha gia' mentito (PF 2,77 → 0,79 ai tick reali); sul
   forex H4 il fattore e' **[NON MISURATO]**. 🔴 **E per il drawdown e per la peggior
   giornata l'OHLC sbaglia nella direzione SCOMODA: non vede le escursioni dentro la barra,
   quindi SOTTOSTIMA.** I −8,02% e i −10,07% sono **limiti inferiori**.
3. **Il deposito e' 10.000**, cioe' la famiglia «quantizzata». La quantizzazione e' misurata
   piccola (§1.1) ma non e' zero.
4. **`exit 0` e `exit 1` non hanno MAI girato**: ne' su IS/OOS, ne' sulle finestre di regime,
   ne' a tick, ne' a 100k, ne' su BCM con `InpMaxSpreadPts=300`. **Zero corse.**

---

# 5. 🧭 LA MISURA PIU' CORTA CHE CHIUDE LA DOMANDA — e costa poco

🟢 **Buona notizia: il file prova E' GIA' SCRITTO, dal 22/09, e non e' mai stato lanciato.**

| # | file prova | cosa misura | passate | costo dichiarato |
|---|---|---|---:|---|
| **1** | `backtest_pipeline/prove/R214f_uscite_COSTTOCOST_EURJPY_ohlc_lungo.txt` | le **tre uscite** sulla finestra lunga **2020.01.01→2026.06.30**, IS/OOS 0,40, **deposito 100.000**, **modello 1**, con **ancora di regressione esatta** (la cella `exit 2` deve riprodurre `r127c` Pass 3 alla quinta cifra) | **6** | tempo per passata **[NON MISURATO]** a modello 1 · **tetto prudente dichiarato dal file stesso: 9,0 minuti** |
| **2** | `backtest_pipeline/prove/R214e_uscite_COSTTOCOST_EURJPY_tick.txt` | le stesse tre uscite **a tick reali** sul pavimento dei tick forex (2024.07.05→2026.06.30) | **6** | **2,0-9,0 minuti** (base misurata il 21/09 sul PC di backtest: 20,1-89,6 s/passata a modello 4) |

**Totale per chiudere la domanda: 12 passate, tetto 18 minuti.**
**Ordine giusto: prima il 1 (ha l'ancora e i regimi), poi il 2.**

## 5.1 🔴 L'UNICA COSA CHE MANCA A QUEI DUE FILE, e costa ZERO passate

Le soglie congelate di `R214e` (**C3** e **C4**) sono scritte **su `Equity DD %`**. Dopo
questo referto e' chiaro che **la colonna che decide e' `Peggior Giornata %`**, che quei CSV
**gia' producono** (e' nell'intestazione, scritta da `OnTesterDeinit`).

👉 **Proposta, da portare a chi tiene quei file — io non li tocco:** aggiungere una soglia

> **C7 — MURO GIORNALIERO.** Una cella e' dichiarata «schierabile su prop» solo se
> `Peggior Giornata %` resta **sopra −5,00%** (muro FTMO giornaliero) **in tutte e due le
> finestre**. La cella `exit 2` e' **attesa in bocciatura** su questo cancello: e'
> l'attesa dichiarata prima dei numeri, e viene da −8,0159 (r127c OOS) e −10,0654 (ORSO).

⚠️ **E l'attesa contro me stesso, scritta prima:** se a **tick reali** la peggior giornata
di `exit 0` **salisse sopra il 5%**, l'intera §4.2 sarebbe un artefatto del modello OHLC e
questo referto avrebbe indicato la strada sbagliata. **Sarebbe la scoperta piu' utile dei
due round.**

## 5.2 🛑 Quello che **NON** si puo' fare, e perche'

Verrebbe voglia di infilare `exit 0` nelle **cinque finestre di regime** (15 passate, driver
`prova_regime.ps1` gia' pronto). 🔴 **Non si puo' adesso**, e non per prudenza: i criteri
firmati il 14/08 (`PROVA_REGIME_CRITERI.md` §1) dicono alla lettera *«Si testano le celle
GIA' PROMOSSE, esattamente come sono... **Vietato** cercare parametri nuovi sui dati vecchi:
sarebbe overfitting su una finestra piu' lunga»*. **`exit 0` non e' una cella promossa: e'
una cella pescata in un CSV.** 👉 Prima passa da un OOS indipendente (R214f), **poi** entra
nella prova di regime. L'ordine e' la regola, non una preferenza.

---

# 6. 🚫 L'ELENCO **PER NOME** DI CIO' CHE NON HO COPERTO

Definito per **elenco**, mai per differenza (classe 180).

1. **Non ho misurato la finestra dello `scan_h4`/`scan_h1`.** Resta **[NON MISURATA]**: non
   esiste un file prova per quegli scan (sono usciti da uno script di scansione, non
   dall'imbuto dei `prove/`). Di conseguenza **nessun numero dello scan e' confrontabile con
   `r40`, `r41`, `r127c`, R102, R103 o i regimi**. Tutte le mie conclusioni dallo scan sono
   **interne allo scan**.
2. **Non ho misurato il fattore OHLC→tick su H4 forex.** Il fattore 1,71-1,85 di casa e'
   misurato su breakout M5 su INDICE e **non si trasporta**. Dichiaro il **segno** (PF giu',
   DD e giornata su), non la taglia.
3. **Non ho aperto `USDCHF` ne' `CHFJPY`**, gli altri due `exit 0 long` sotto il muro nello
   scan H4 (PF 1,2617 DD 8,6110 n 186 · PF 1,1474 DD 7,0950 n 190). Sono **simboli gemelli
   veri** e sono **scoperti**.
4. **Non ho toccato `GBPCAD` (772362) ne' `XAGUSD` (772363)**, le due sorelle di famiglia.
   `GBPCAD` in R103 fa **PF 0,924 e DD 41,52% contro 6,18% promesso = 6,72×**; `XAGUSD` e'
   **spenta dal 24/08**. Non li ho istruiti e **non li archivio**.
5. **Non ho misurato lo spread reale di EURJPY presso BCM.** `risultati_archivio/spread_flotta/`
   copre 3 simboli su 13 e EURJPY non c'e'. Il rapporto `stop/spread` **25,6×** citato da
   R214e viene da un'altra fonte: **passa** il cancello duro (13,3×), **non passa** il
   pavimento di lavoro (40×), ed e' **da riconfermare**. Misurarlo costa **zero passate di
   tester** (`ABTG_SpreadOrario`).
6. **Non ho verificato che l'`.ex5` sul banco corrisponda al `.mq5` a HEAD.** **[NON
   MISURATO]** — ed e' il difetto che il 12/09 ha trovato `ABTG_EMA200` in campo con un
   binario di 486 righe contro 690.
7. **Non ho messo ad asse niente**: nessun round lanciato, zero minuti macchina, come da
   incarico.
8. **Non ho proposto ne' taglie ne' rischi.** `InpRiskPercent` resta **1,00%** in ogni riga
   di questo referto, ed e' **firma di Claudio**.
9. **Non ho toccato i temi di `R222`** (sedie in campo `771531` e `770101`) **ne' quelli di
   `R223`** (manopole inerti e censimento uscite): la sola manopola inerte che cito
   (`InpMaxBarsHold` in `r127c`) e' dentro il perimetro di questo motore.

---

# 7. 🪦 IL CERTIFICATO — **NON ANCORA MISURATO**, e cosa manca esattamente

`ABTG_CostToCost` EURJPY H4 (`772361`) **non si archivia** e **non si promuove**.

| voce del certificato (09/09) | stato |
|---|---|
| **PF misurato** | ✅ 1,410 su n=394 (R103) · 1,52341 OOS (r127c) |
| **n e DD** | ✅ n=394 · DD 12,26% · e **cinque DD di regime** (10,63-16,60%) |
| **gestione dell'uscita messa ad asse** | 🟠 **una volta sola**, in OHLC, a 10k, su finestra **[NON MISURATA]**, **mai in IS/OOS** → **NON BASTA** |
| **simboli gemelli provati** | 🟠 `GBPCAD` e `XAGUSD` misurati; **`USDCHF` e `CHFJPY`, i due che nello scan stanno sotto il muro, NO** |
| **TF cambiato** | 🟠 H1 misurato (catastrofico), H4 misurato. **H2 e D1 MAI**, e la tesi prescriveva D1 |

🔴 **Tre voci su cinque incomplete ⇒ il verdetto e' «NON ANCORA MISURATO», e la via piu'
corta per chiuderlo e' scritta al §5: 12 passate, tetto 18 minuti, file gia' pronti.**

---

# 8. 📌 CLASSE NUOVA PER LA CHECKLIST

**Classe 618 — IL TAPPO DICHIARATO NON ERA IL TAPPO: IL MURO PROP E' DOPPIO E NE
CLASSIFICHIAMO UNO.** Registrata in `backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md`.
