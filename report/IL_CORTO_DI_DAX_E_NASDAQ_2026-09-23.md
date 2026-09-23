# 🐻 IL CORTO DI DAX E NASDAQ — censimento MOTORE PER MOTORE, letto dentro i CSV — **R233**

**23/09/2026** · branch `lavoro` · sigla **R233** (grepata libera prima dell'uso, classe 194:
zero occorrenze in repo al momento della scrittura).

> 🧾 **SOLA LETTURA, ZERO MINUTI MACCHINA.** Nessun round lanciato, nessuna riga di lancio
> scritta, nessun file prova nuovo, nessun preset, nessun EA, nessuna sedia, nessun terminale,
> niente VPS, niente conto reale `10105439`, nessuna taglia, nessun parametro di rischio.
> **Sei sedie stanno operando adesso e non sono state toccate.** Claudio e' da cellulare: tutto
> quello che c'e' qui viene da file gia' in repo. Dove un numero richiede MT5 c'e' scritto
> **`[NON MISURATO]`**, non una stima.
>
> 🤝 **Non si sovrappone a `R230`** (`report/I_LATI_MANCANTI_2026-09-23.md`, stessa giornata):
> quello guarda **i lati delle tre sedie VIVE**; questo guarda **tutti e 73 i motori con un
> input di lato**, sui due simboli. Dove si toccano, i numeri coincidono — ed e' detto.

---

# 0. 🥁 LA RISPOSTA IN OTTO RIGHE

1. 🟢 **«Sul DAX e sul Nasdaq il corto non funziona» e' FALSO, e si rompe con i nostri CSV.**
   Su `D30EUR` **10 motori** hanno il corto misurato e **8 di questi 10 hanno almeno una cella
   con `RF > 0`**; su `NASUSD` i motori misurati sono **7** e **5** hanno celle positive.
2. 🥇 **Il ribaltamento piu' netto e' `ABTG_GoldenCross` sul NASDAQ: il LUNGO fa `0 celle
   positive su 69`, il CORTO ne fa `27 su 48` — e nello scan H1 il corto e' `20 su 20`, positivo
   su OGNI valore di OGNI manopola.** Sul Nasdaq, di quel motore, **l'unico lato che vive e' il
   corto**. `[OHLC · n 16-28 → MERITO SOSPESO]`.
3. 🥈 **`ABTG_SupertrendReversal` corto su `D30EUR` H1 e' l'unico corto di DAX/Nasdaq con
   `n ≥ 150`:** 12 celle sopra le 150 operazioni, la migliore **PF 1,372 · RF 1,227 · n 169 ·
   DD 5,62%**, 32 celle positive su 70. 🔴 **Ma a TICK REALI il lato non e' MAI stato un asse su
   quel motore**: tutte le validazioni `SupRev` su DAX/Nasdaq (160 passate) portano
   `(InpAllowLong, InpAllowShort) = (1,1)`.
4. 🟢 **Il corto vivo esiste ed e' in campo**: `ABTG_MaxMinNotte_DAX_Short_Ottimizzato`
   (`770411`) fa **45 celle positive su 46**, best **PF 2,442 · RF 3,211 · n 21 · DD 2,25%**, e
   sullo stesso motore il **LUNGO fa 0 su 18**. Sul DAX notturno il lato bocciato e' il lungo.
5. 🔴 **Il corto dell'`EMA200` su DAX e Nasdaq resta chiuso sui parametri, e il conto di Claudio
   e' VERIFICATO alla cifra**: `D30EUR` H1 **0/26 e 0/26**, H4 **1/34**; `NASUSD` H1 **0/30 e
   0/32**. Contro `U30USD` H1 **32/32 e 29/29** — e in piu' **26/26 a TICK REALI**
   (`RF 4,869 · PF 1,658 · n 368 · DD 3,47%`). **Non riproporro' quelle distanze.**
6. 🥉 **Il primo dei MAI MISURATI e' `ABTG_IntradayMomentum`**, e la ragione e' misurata da
   altri: frontiera del costo **53,3x su NASUSD** e **47,8x su U30USD** (`REGISTRO_TEST.md`
   r.3117), **1,00 operazione/giorno per costruzione**, **n ≥ 150 garantito in tutte e due le
   finestre** — e sul Nasdaq ha **4 passate, tutte `(1,1)`: il lato non e' mai stato un asse.**
7. 🔴 **Due esclusioni PER COSTO, col numero**: `SupRev` su **NASUSD H1** fa **28,7x** contro
   una frontiera di 40x (`CANCELLO_COSTO_FLOTTA_2026-09-10.md` r.660) → **il corto del
   SupertrendReversal sul Nasdaq NON si propone a H1**, si propone a **H2/H4**. E `AtrExhaustVol`
   **NASUSD M5** fa **10,9x**, sotto il pavimento **duro** 13,3x.
8. 🧪 **Il contro-esempio piu' forte non viene da un motore: viene da una sonda.**
   `ABTG_SondaRelativo` misura su M5, su tutti e due i simboli, che il corto e il lungo hanno la
   **STESSA geometria**: `win rate necessario` **52,05% long vs 53,65% short** sul DAX e
   **55,52% vs 55,36%** sul Nasdaq. 👉 **Il lato corto di questi due strumenti non parte con un
   handicap strutturale.** Quello che manca ai corti bocciati non e' il mercato: e' il motore.

---

# 1. 🔬 IL METODO — perche' questo censimento non si poteva fare coi nomi dei file

🔴 **Classe 640, e oggi ha morso di nuovo**: cercare il lato corto per **nome di file**
(`*short*`, `*_S_*`) fa dichiarare «mai provato» cio' che e' provato. Esempio dentro questo
referto: `risultati_archivio/R113_CORSA_20260827/R113_F*_02_short.csv` **non nomina il simbolo**
— il `NASUSD` sta solo nella colonna `InpComment` (`"STREV NAS H1"`). Un `grep` sul nome lo
perde. Al contrario `scan_ABTG_SupertrendReversal_H1_D30EUR.csv` non ha «short» nel nome ma
contiene **37 passate short-only**.

**Quindi ho letto le colonne, non i nomi.**

| passo | cosa ho fatto | numero |
|---|---|---:|
| 1 | tutti i `.csv` del repo (escluso `.git`, `.claude/worktrees`, `__pycache__`) | **2.409** in `backtest_pipeline`, **21.648** nel repo |
| 2 | quelli che portano **tutte e due** le colonne `InpAllowLong` e `InpAllowShort` | **1.681 file** |
| 3 | righe di passata lette | **60.576** |
| 4 | simbolo risolto per **nome file → cartella → `InpComment`** | **41 righe non risolte** (tutte `PTEGBP`/`PTEJPY` + `R114_canarino_A` = ORB: **nessuna DAX/Nasdaq**) |
| 5 | motore attribuito per **`InpMagic` dentro il CSV** (88 magic estratti dai 115 sorgenti), poi per percorso | **314 righe non attribuite** (§8) |
| 6 | geometria del lato = **la coppia** `(InpAllowLong, InpAllowShort)` | `(0,1)` = **CORTO PURO** |

**Righe short-only trovate su `D30EUR`: 505. Su `NASUSD`: 220.**

## 🧪 IL CONTRO-ESEMPIO DEL METODO — ho provato a rompere il mio stesso conteggio
Se il mio filtro `(0,1)` fosse sbagliato, i «corti» che trovo sarebbero passate a vuoto. **Ho
guardato le `Trades`**: le **554** passate `(0,0)` su DAX/Nasdaq hanno **`Trades = 0` in 554 casi
su 554** — cioe' il filtro sul lato **morde davvero** e le righe `(0,1)` sono operazioni vere.
Secondo controllo: il conto del mandato su `U30USD` (32/32 e 29/29, RF +5,235 e +6,296) **torna
alla terza cifra** rileggendolo per geometria (§2.3). Se avessi letto la coppia al contrario, quel
numero sarebbe uscito diverso.

---

# 2. 📊 LA TABELLA MADRE — 73 motori con input di lato × 2 simboli

Legenda: **🟢/🔴** = il corto **e' stato misurato** (celle `(0,1)` con operazioni), col conto
delle celle positive · **⚪** = **il motore ha girato li' ma il LATO non e' mai stato un asse**
(tutte le passate a lato fisso) · **—** = nessuna passata su quel simbolo.

🔴 **Banco**: quasi tutte queste righe vengono da **scansioni OHLC (Modello 1)**, che e' il banco
**ottimista** — non paga lo spread vero. **Un corto che perde li' perde di piu' a tick, non di
meno.** Dove la riga e' a tick reali e' scritto nel dettaglio (§3).

| motore | D30EUR — lato CORTO | NASUSD — lato CORTO |
|---|---|---|
| `ABTG_AllineaLondra` | — nessuna passata | — nessuna passata |
| `ABTG_Apertura_3Ingressi` | ⚪ lato MAI ad asse (12 passate, tutte (1,1)/(1,0)/(0,0)) | ⚪ lato MAI ad asse (12 passate, tutte (1,1)/(1,0)/(0,0)) |
| `ABTG_Apertura_Marco` | — nessuna passata | — nessuna passata |
| `ABTG_AtrExhaustVol` | — nessuna passata | ⚪ lato MAI ad asse (4 passate, tutte (1,1)/(1,0)/(0,0)) |
| `ABTG_BreakinBox` | — nessuna passata | — nessuna passata |
| `ABTG_CanaleLento` | — nessuna passata | — nessuna passata |
| `ABTG_ChaosLyapunov` | — nessuna passata | — nessuna passata |
| `ABTG_CostToCost` | 🔴 0/6 RF>0 · best RF -0.322 PF 0.849 n 113 DD 22.26 · n≥150: 3 | 🟢 1/6 RF>0 · best RF 0.150 PF 1.031 n 95 DD 10.02 · n≥150: 3 |
| `ABTG_CrossEma` | ⚪ lato MAI ad asse (16 passate, tutte (1,1)/(1,0)/(0,0)) | — nessuna passata |
| `ABTG_CrossEmaApertura` | — nessuna passata | — nessuna passata |
| `ABTG_Cycle` | — nessuna passata | — nessuna passata |
| `ABTG_DAX_Apertura_EU` | 🟢 2/22 RF>0 · best RF 0.749 PF 1.212 n 237 DD 9.02 · n≥150: 22 | — nessuna passata |
| `ABTG_DAX_Apertura_EU_Ottimizzato` | ⚪ lato MAI ad asse (360 passate, tutte (1,1)/(1,0)/(0,0)) | — nessuna passata |
| `ABTG_DAX_Live5m` | ⚪ lato MAI ad asse (8 passate, tutte (1,1)/(1,0)/(0,0)) | — nessuna passata |
| `ABTG_DAX_Live5m_v2` | ⚪ lato MAI ad asse (40 passate, tutte (1,1)/(1,0)/(0,0)) | — nessuna passata |
| `ABTG_DAX_M3` | — nessuna passata | — nessuna passata |
| `ABTG_Dow_Apertura_US` | — nessuna passata | — nessuna passata |
| `ABTG_EMA200` | 🟢 1/86 RF>0 · best RF 0.010 PF 1.006 n 64 DD 3.99 · n≥150: 52 | 🔴 0/62 RF>0 · best RF -0.201 PF 0.950 n 273 DD 6.04 · n≥150: 62 |
| `ABTG_EMA200_Ottimizzato` | — nessuna passata | — nessuna passata |
| `ABTG_EasyTrend` | 🔴 0/2 RF>0 · best RF -0.206 PF 0.938 n 51 DD 8.34 · n≥150: 0 | 🔴 0/2 RF>0 · best RF -0.161 PF 0.923 n 53 DD 11.35 · n≥150: 0 |
| `ABTG_FiboH4_Corso` | — nessuna passata | — nessuna passata |
| `ABTG_FiboH4_Multi` | — nessuna passata | — nessuna passata |
| `ABTG_FvgRetest` | — nessuna passata | — nessuna passata |
| `ABTG_GoldenCross` | 🟢 23/51 RF>0 · best RF 0.736 PF 2.267 n 10 DD 1.85 · n≥150: 0 | 🟢 27/48 RF>0 · best RF 0.707 PF 1.785 n 22 DD 2.76 · n≥150: 0 |
| `ABTG_GoldenCross_Ottimizzato` | ⚪ lato MAI ad asse (4 passate, tutte (1,1)/(1,0)/(0,0)) | ⚪ lato MAI ad asse (4 passate, tutte (1,1)/(1,0)/(0,0)) |
| `ABTG_GoldenCross_V1` | — nessuna passata | — nessuna passata |
| `ABTG_HARSI` | — nessuna passata | — nessuna passata |
| `ABTG_HVAncora` | — nessuna passata | — nessuna passata |
| `ABTG_IBRetest` | ⚪ lato MAI ad asse (8 passate, tutte (1,1)/(1,0)/(0,0)) | ⚪ lato MAI ad asse (8 passate, tutte (1,1)/(1,0)/(0,0)) |
| `ABTG_ImpulsoApertura` | — nessuna passata | — nessuna passata |
| `ABTG_IntradayMomentum` | — nessuna passata | ⚪ lato MAI ad asse (4 passate, tutte (1,1)/(1,0)/(0,0)) |
| `ABTG_InvEsaurimento` | — nessuna passata | — nessuna passata |
| `ABTG_LVNArbitro` | — nessuna passata | — nessuna passata |
| `ABTG_LiquiditySweep` | — nessuna passata | — nessuna passata |
| `ABTG_Londra_ORB` | — nessuna passata | — nessuna passata |
| `ABTG_MIS_SIZING_EMA200` | — nessuna passata | — nessuna passata |
| `ABTG_MIS_SIZING_SWDOW` | — nessuna passata | — nessuna passata |
| `ABTG_MaxMinNotte` | 🟢 62/72 RF>0 · best RF 7.061 PF 5.300 n 25 DD 1.77 · n≥150: 0 | — nessuna passata |
| `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` | 🟢 45/46 RF>0 · best RF 3.211 PF 2.442 n 21 DD 2.25 · n≥150: 0 | — nessuna passata |
| `ABTG_MaxMinNotte_DAX_Short_Ottimizzato_MFE` | — nessuna passata | — nessuna passata |
| `ABTG_MeanRevert` | — nessuna passata | — nessuna passata |
| `ABTG_Nasdaq_Apertura_US` | — nessuna passata | 🟢 4/22 RF>0 · best RF 0.508 PF 1.165 n 142 DD 7.54 · n≥150: 19 |
| `ABTG_Nasdaq_Apertura_US_Ottimizzato` | — nessuna passata | — nessuna passata |
| `ABTG_Nasdaq_Live5m` | — nessuna passata | ⚪ lato MAI ad asse (30 passate, tutte (1,1)/(1,0)/(0,0)) |
| `ABTG_Nightly` | ⚪ lato MAI ad asse (4 passate, tutte (1,1)/(1,0)/(0,0)) | — nessuna passata |
| `ABTG_Nightly_Ottimizzato` | — nessuna passata | — nessuna passata |
| `ABTG_NySessionRetest` | — nessuna passata | — nessuna passata |
| `ABTG_ORB` | — nessuna passata | ⚪ lato MAI ad asse (106 passate, tutte (1,1)/(1,0)/(0,0)) |
| `ABTG_ORB_Fibo` | — nessuna passata | ⚪ lato MAI ad asse (6 passate, tutte (1,1)/(1,0)/(0,0)) |
| `ABTG_ORB_Ottimizzato` | ⚪ lato MAI ad asse (8 passate, tutte (1,1)/(1,0)/(0,0)) | ⚪ lato MAI ad asse (216 passate, tutte (1,1)/(1,0)/(0,0)) |
| `ABTG_OutOfNoise` | — nessuna passata | — nessuna passata |
| `ABTG_PTE` | ⚪ lato MAI ad asse (64 passate, tutte (1,1)/(1,0)/(0,0)) | ⚪ lato MAI ad asse (64 passate, tutte (1,1)/(1,0)/(0,0)) |
| `ABTG_PTE_Ottimizzato` | — nessuna passata | — nessuna passata |
| `ABTG_PunteLarry` | 🟢 3/6 RF>0 · best RF 0.383 PF 1.165 n 34 DD 5.87 · n≥150: 0 | 🟢 1/6 RF>0 · best RF 0.195 PF 1.175 n 23 DD 6.47 · n≥150: 0 |
| `ABTG_SondaOrologio` | 🟢 45/144 RF>0 · best RF 2.724 PF 2.240 n 40 DD 1.07 · n≥150: 0 | — nessuna passata |
| `ABTG_SupRev_CAC_H4_Ottimizzato` | — nessuna passata | — nessuna passata |
| `ABTG_SupRev_DAX_H1_Ottimizzato` | ⚪ lato MAI ad asse (44 passate, tutte (1,1)/(1,0)/(0,0)) | — nessuna passata |
| `ABTG_SupRev_DAX_H4_Ottimizzato` | ⚪ lato MAI ad asse (44 passate, tutte (1,1)/(1,0)/(0,0)) | — nessuna passata |
| `ABTG_SupRev_DOW_H1_Ottimizzato` | — nessuna passata | — nessuna passata |
| `ABTG_SupRev_DOW_H4_Ottimizzato` | — nessuna passata | — nessuna passata |
| `ABTG_SupRev_NAS_H1_Ottimizzato` | — nessuna passata | ⚪ lato MAI ad asse (72 passate, tutte (1,1)/(1,0)/(0,0)) |
| `ABTG_SuperWave` | ⚪ lato MAI ad asse (71 passate, tutte (1,1)/(1,0)/(0,0)) | ⚪ lato MAI ad asse (80 passate, tutte (1,1)/(1,0)/(0,0)) |
| `ABTG_SuperWave_DAX_H4_Ottimizzato` | ⚪ lato MAI ad asse (44 passate, tutte (1,1)/(1,0)/(0,0)) | — nessuna passata |
| `ABTG_SuperWave_DOW_H1_Ottimizzato` | — nessuna passata | — nessuna passata |
| `ABTG_SuperWave_EA` | — nessuna passata | — nessuna passata |
| `ABTG_SupertrendInvert` | ⚪ lato MAI ad asse (22 passate, tutte (1,1)/(1,0)/(0,0)) | ⚪ lato MAI ad asse (22 passate, tutte (1,1)/(1,0)/(0,0)) |
| `ABTG_SupertrendReversal` | 🟢 32/70 RF>0 · best RF 1.516 PF 1.382 n 146 DD 4.55 · n≥150: 12 | 🟢 21/62 RF>0 · best RF 2.765 PF 1.966 n 50 DD 0.78 · n≥150: 0 |
| `ABTG_SupertrendReversal_Multi` | — nessuna passata | — nessuna passata |
| `ABTG_SupertrendReversal_Multi_Ottimizzato` | — nessuna passata | — nessuna passata |
| `ABTG_SupertrendReversal_Ottimizzato` | — nessuna passata | — nessuna passata |
| `ABTG_TurnaroundTuesday` | — nessuna passata | — nessuna passata |
| `ABTG_VwapRevert` | — nessuna passata | — nessuna passata |
| `ABTG_WOL` | ⚪ lato MAI ad asse (44 passate, tutte (1,1)/(1,0)/(0,0)) | ⚪ lato MAI ad asse (44 passate, tutte (1,1)/(1,0)/(0,0)) |

## 2.1 📐 IL CONTO, in quattro classi

| classe | `D30EUR` | `NASUSD` |
|---|---:|---:|
| 🟢🔴 **corto MISURATO** (celle `(0,1)` con operazioni) | **10 motori** | **7 motori** |
| ⚪ **il motore gira li', ma il LATO non e' mai stato un asse** | **16 motori** | **14 motori** |
| — **nessuna passata su quel simbolo** | 47 | 52 |

**Motori senza NESSUNA passata su nessuno dei due: 40.**

⚠️ **Dei 40 «nessuna passata» una parte non e' un buco**: `ABTG_Dow_Apertura_US`,
`ABTG_SupRev_DOW_H1/H4_Ottimizzato`, `ABTG_SupRev_CAC_H4_Ottimizzato`,
`ABTG_SuperWave_DOW_H1_Ottimizzato`, `ABTG_PTE_Ottimizzato`, `ABTG_MIS_SIZING_SWDOW` sono
**derivati pinnati a un altro simbolo**: su DAX/Nasdaq non «non sono stati provati», **non sono
quel motore li'**. Sono **7**; gli altri **33** sono caselle vuote vere (elenco per nome in §8).

## 2.2 🕳️ IL BUCO STRUTTURALE, ed e' il piu' grosso di tutti
**16 + 14 = 30 caselle** in cui il motore ha girato su quel simbolo e **il lato non e' mai stato
messo ad asse**. Non sono verdetti: sono **manopole inerti per omissione**. I casi che pesano:

| motore · simbolo | passate a lato fisso | perche' brucia |
|---|---:|---|
| `ABTG_ORB_Ottimizzato` · `NASUSD` | **216** | il breakout di range e' **simmetrico per costruzione** (max/min dell'OR), e il lato non e' mai stato separato li' |
| `ABTG_SuperWave` · `NASUSD` / `D30EUR` | **80 / 71** | — |
| `ABTG_SupRev_NAS_H1_Ottimizzato` · `NASUSD` | **72** | 🔴 e' **la validazione a tick reali** del SupRev sul Nasdaq: **tutte `(1,1)`** |
| `ABTG_PTE` · `D30EUR` / `NASUSD` | **64 / 64** | mean-reversion sugli estremi del canale = **specchio esatto** |
| `ABTG_SupRev_DAX_H1/H4_Ottimizzato` · `D30EUR` | **44 + 44** | idem: le validazioni a tick del DAX, **tutte `(1,1)`** |
| `ABTG_WOL` · entrambi | **44 + 44** | inversione su doji alla Weekly Open Line = simmetrica |
| `ABTG_SupertrendInvert` · entrambi | **22 + 22** | — |
| `ABTG_IntradayMomentum` · `NASUSD` | **4** | 👉 **vedi §5: e' il primo della classifica** |

> ### 🔴 **La riga da tenere: su DAX e Nasdaq, il lato corto dei motori a TICK REALI non e' mai stato misurato da nessuno. Zero volte, su 160 passate di validazione `SupRev`.** Quello che abbiamo sul corto di questi due simboli sta **tutto** sul banco ottimista.

## 2.3 ✅ IL CONTO DEL MANDATO, riverificato per geometria

| simbolo · TF · file | celle corto | `RF > 0` | best RF | best PF | n | DD |
|---|---:|---:|---:|---:|---:|---:|
| `U30USD` H1 `risultati_archivio/EMA200/H1_OHLC/scan_..._U30USD.csv` | 32 | 🟢 **32** | **+5,235** | 1,842 | 300 | 3,81% |
| `U30USD` H1 `risultati_prove/risultati_scan_ABTG_EMA200_H1/scan_..._U30USD.csv` | 29 | 🟢 **29** | **+6,296** | 1,777 | 386 | 3,56% |
| 🟢 **`U30USD` H1 — A TICK REALI** `risultati_prove/risultati_valid_ABTG_EMA200_H1_realtick/valid_..._U30USD.csv` | **26** | 🟢 **26** | **+4,869** | **1,658** | **368** | **3,47%** |
| `D30EUR` H1 (archivio) | 26 | 🔴 **0** | −0,269 | 0,928 | 358 | 10,84% |
| `D30EUR` H1 (prove) | 26 | 🔴 **0** | −0,360 | 0,920 | 375 | 9,18% |
| `D30EUR` H4 | 34 | 🔴 **1** | +0,010 | 1,006 | 64 | 3,99% |
| `NASUSD` H1 (archivio) | 30 | 🔴 **0** | −0,201 | 0,950 | 273 | 6,04% |
| `NASUSD` H1 (prove) | 32 | 🔴 **0** | −0,486 | 0,877 | 251 | 6,68% |

✅ **La tabella del mandato e' confermata cifra per cifra**, e in piu' porta una riga che li' non
c'era: **il corto del Dow regge anche a TICK REALI, 26 celle su 26.**
🔴 **Conseguenza operativa, e la rispetto**: sul corto dell'`EMA200` in DAX/Nasdaq **la casella
dei parametri e' CHIUSA** — `0` celle positive su `26+26+30+32 = 114` a H1 e `1` su 34 a H4.
**Non propongo di rigirare quelle distanze.** Propongo **altri motori** (§5).

---

# 3. 🟢 I CORTI CHE FUNZIONANO GIA' SU QUESTI DUE SIMBOLI — la falsificazione, coi numeri

## 3.1 🥇 `ABTG_GoldenCross` su `NASUSD` H1 — **il corto batte il lungo, e non di poco**

| lato | celle | `RF > 0` | best RF | best PF | n | DD |
|---|---:|---:|---:|---:|---:|---:|
| **LUNGO** | 69 | 🔴 **0** | −0,118 | 0,916 | 34 | — |
| **CORTO** | 48 | 🟢 **27** | **+0,707** | **1,785** | 22 | 2,76% |

E nello **scan H1** (`risultati_archivio/GoldenCross/H1_OHLC/scan_ABTG_GoldenCross_H1_NASUSD.csv`)
il corto e' **20 celle su 20 positive**, su **tutti e quattro** i valori di `InpAdxMin`
(15/20/25/30), **tutti e quattro** di `InpAtrSLmult` e **tutti e quattro** di `InpTP_R`:

```
RF 0,707 PF 1,785 n 22   ADX 25  ATRsl 2,0  TP_R 2,5    <- migliore
RF 0,690 PF 1,644 n 25   ADX 20  ATRsl 2,0  TP_R 2,5
RF 0,670 PF 1,642 n 25   ADX 20  ATRsl 1,0  TP_R 1,5
...
RF 0,031 PF 1,028 n 27   ADX 15  ATRsl 2,0  TP_R 3,0    <- peggiore, ANCORA positiva
```
> ## 🎯 **Questo e' un ALTOPIANO, non un picco**: il segno non cambia su nessuno dei tre assi. E la regola di casa dice di prendere il **centro**, non lo `0,707`.

🔴 **E adesso i tre motivi per cui NON e' una sedia**, detti prima che qualcuno si entusiasmi:
1. **`n` fra 16 e 28** → sotto 150 → **MERITO SOSPESO** (Emendamento B). Il rischio invece si
   legge: **DD 2,26-3,21%**, basso.
2. **Banco OHLC**, finestra `2024.01.01 → 2026.06.30` con dati indici che iniziano il
   **2024.09.26** → ~21 mesi, **un solo regime (toro)**. Ai tick lo spread mangia, e non sappiamo
   quanto: **`[NON MISURATO]`**.
3. **Frequenza**: ~25 operazioni su ~458 giornate feriali fra il **2024.09.26** (prima data BCM sugli indici) e il **2026.06.30** = **0,055 op/giorno** `[DERIVATO]`. Il pavimento e'
   **1,00 per FAMIGLIA**: una sedia cosi' non la raggiunge da sola nemmeno con dieci gemelle.

🟡 Sul **DAX** lo stesso motore fa **23 celle positive su 51** (best `RF 0,518 · PF 1,367 · n 28`),
🔴 **ma li' NON c'e' altopiano**: su `InpAdxMin` il segno si ribalta — **25/30 positive, 20
NEGATIVE, 15 quasi a zero**. *Un pettine, non un altopiano.* Verdetto onesto sul DAX:
**non c'e' una configurazione robusta**.

## 3.2 🥈 `ABTG_SupertrendReversal` corto — **l'unico con `n ≥ 150` su DAX**

`risultati_archivio/SupertrendReversal/H1_OHLC/scan_ABTG_SupertrendReversal_H1_D30EUR.csv`,
37 passate short-only, deposito **10.000 EUR**, Modello **1 (OHLC)**, `2024.01.01 → 2026.06.30`,
ottimizzazione **genetica** (`Optimization=2`, quindi **griglia SPARSA**: 123 passate su 384
possibili):

| RF | PF | n | DD | `InpStMult` | `InpStAtrPeriod` | `InpTP_RR` |
|---:|---:|---:|---:|---:|---:|---:|
| **1,227** | **1,372** | **169** | 5,62% | **2,5** | **14** | 2,0 |
| 1,136 | 1,336 | 169 | 5,45% | 2,5 | 14 | 2,5 |
| 1,051 | 1,336 | 172 | 5,77% | 2,5 | 14 | 1,5 |
| 1,038 | 1,355 | 169 | 6,22% | 2,5 | 14 | 3,0 |
| 1,516 | 1,382 | 146 | 4,55% | 2,5 | 13 | 1,5 |

🟢 **Sull'asse `InpTP_RR` c'e' un altopiano perfetto**: a `(2,5 · 14)` **tutti e quattro** i
valori di TP sono positivi, con `n` fra 169 e 172 e PF fra 1,336 e 1,372. **La cella di centro e'
`TP_RR = 2,0-2,5`, non il picco.**

🔴 **MA il contro-esempio lo rompe sugli altri due assi, e lo dico io**:
```
(2,5 · 14)  ->  +1,05  +1,23  +1,14  +1,04     tutte POSITIVE
(2,5 · 12)  ->  -0,41  -0,60  -0,66             tutte NEGATIVE
(3,5 · 14)  ->  -0,20  -0,24  -0,33             tutte NEGATIVE
(2,5 · 13)  ->  NESSUNA PASSATA                 <- la genetica non c'e' passata
```
> ## 🔴 **Su `InpStAtrPeriod` e `InpStMult` le vicine sono ROSSE. Con una griglia genetica la corona attorno a `(2,5 · 14)` NON e' stata misurata: non e' «vuota», e' `[NON MISURATO]`.** Finche' quella corona non si riempie, **non si puo' dire se `(2,5 · 14)` sia un altopiano o un picco di rumore** — e la regola di casa dice che un picco non si promuove.

**Su `NASUSD`** lo stesso motore fa **21 celle positive su 62** (best `RF 2,765 · PF 1,966 ·
n 50 · DD 0,78%` a H1; `RF 2,020 · PF 2,825 · n 11` a H4). 🔴 **`n` massimo = 63: zero celle sopra
150 → merito sospeso.** E vedi §6: **a H1 il costo lo esclude**.

## 3.3 🟢 IL CORTO VIVO: `ABTG_MaxMinNotte` sul DAX (sedia `770411`)

| lato | celle | `RF > 0` | best RF | best PF | n | DD |
|---|---:|---:|---:|---:|---:|---:|
| **LUNGO** (`ABTG_MaxMinNotte`) | 18 | 🔴 **0** | −0,264 | 0,947 | 173 | — |
| **CORTO** (`ABTG_MaxMinNotte`) | 72 | 🟢 **62** | +7,061 | 5,300 | 25 | 1,77% |
| **CORTO** (`_DAX_Short_Ottimizzato`) | 46 | 🟢 **45** | **+3,211** | **2,442** | 21 | 2,25% |

🔴 **Classe 604, e va detta**: le righe `r81*` dello stesso motore riportano `Profit 6.143,38` a
parita' di `PF 2,160 · n 21` contro `618,31` delle righe `risultati_prove` — **sono depositi
diversi e i profitti NON si confrontano.** I PF, gli RF e i DD si'.
🟡 **Frontiera del costo di `770411`**: **`[NON MISURATO]`, banda 37,8-51,5x** — 🟠 **FRAGILE**
(`CANCELLO_COSTO_FLOTTA_2026-09-10.md` r.1006 e r.1153). Non e' un verde.
✅ Il **lungo bocciato** di `770411` e' lo stesso fatto che `R230` §4 porta dal suo lato: **i due
referti concordano**.

## 3.4 🟡 Gli altri corti positivi, per completezza (e nessuno di loro e' una sedia)

| motore · simbolo | celle `RF>0` | best | perche' non basta |
|---|---:|---|---|
| `ABTG_DAX_Apertura_EU` · `D30EUR` | 2/22 | `RF 0,749 · PF 1,212 · n 237` (OOS) | 🔴 **IS 0/3, tutte negative** = ribaltamento IS→OOS. E `R107` (25/08, **tick reali**, n OOS 257) lo ha gia' chiuso: PF IS 0,965 / OOS 0,957. **Resta bocciato** |
| `ABTG_Nasdaq_Apertura_US` · `NASUSD` | 4/22 | `RF 0,508 · PF 1,165 · n 142` (IS) | 🔴 **OOS 0/8, best `PF 0,666 · DD 25,3%`**. Il verde sta solo nell'IS |
| `ABTG_PunteLarry` · `D30EUR` / `NASUSD` | 3/6 · 1/6 | `PF 1,165 · n 34` · `PF 1,175 · n 23` | campione minuscolo, 6 celle in tutto |
| `ABTG_CostToCost` · `NASUSD` H4 | 1/6 | `RF 0,150 · PF 1,031 · n 95` | 🔴 le altre 5 vanno da `PF 0,347` a `0,864` con **DD fino al 55,5%** |
| `ABTG_SondaOrologio` · `D30EUR` | 45/144 | `RF 2,724 · PF 2,240 · n 40` (OOS) | 🔴 **NON e' un EA**: e' uno strumento di misura (stop a 10 ATR). E il suo criterio `I7` dice che i due lati si leggono INSIEME: **la cella LONG non e' mai stata girata → NON LEGGIBILE**. 72 fasce su 72 sotto le 150 giornate |
| `ABTG_SupertrendReversal` (round `R113`) · `NASUSD` | 2/12 | `RF 0,092 · PF 1,049 · n 39` | celle di ablazione, `n` da 0 a 39 |

## 3.5 🧪 IL CONTRO-ESEMPIO CHE VALE PIU' DI TUTTI — una sonda, non un motore

`risultati_archivio/sondarelativo/ABTG_SondaRelativo_{D30EUR,NASUSD}_IS_ohlc_*_M5_EST.csv`,
90 passate per simbolo, **441 e 450 giornate contate**, dati **esterni**, M5:

| misura | `D30EUR` long | `D30EUR` **short** | `NASUSD` long | `NASUSD` **short** |
|---|---:|---:|---:|---:|
| MFE mediana (punti indice) | 21,00 | **22,00** | 34,15 | **33,33** |
| MAE mediana (punti indice) | 20,95 | **22,50** | 36,38 | **35,95** |
| R/R dalle mediane | 1,065 | **1,004** | 0,936 | **0,942** |
| **win rate NECESSARIO** | 52,05% | **53,65%** | 55,52% | **55,36%** |
| MFE / spread | 7,50 | **7,86** | 18,97 | **18,51** |
| occasioni eseguibili al giorno | 6,46 | **6,60** | 6,61 | **6,41** |

> ## 🎯 **Il lato corto di DAX e Nasdaq NON ha un handicap di geometria.** Stesso movimento a favore, stesso movimento contro, stesso win rate richiesto (differenza **1,6 punti** sul DAX, **0,16** sul Nasdaq), **stesso numero di occasioni**. 👉 Se il corto perde, **perde per il MOTORE, non per lo strumento.**

⚠️ **Con la sua etichetta**: e' una sonda MFE/MAE su **M5 e dati esterni**, con spread letto
**2,80** sul DAX (non l'1,60 delle 8-9). **Non e' un P/L** e non promuove niente. Ma e' **la
misura giusta per la domanda giusta**: dice che la simmetria c'e'.

---

# 4. 🪦 CHI HA GIA' `0/N` SUL CORTO — lo dico e passo oltre

| motore · simbolo | celle corto | `RF > 0` | numero |
|---|---:|---:|---|
| `ABTG_EMA200` · `NASUSD` H1 | 62 | **0** | best `PF 0,950 · n 273`; **62 celle su 62 con `n ≥ 150`** = campione pieno, verdetto pieno |
| `ABTG_EMA200` · `D30EUR` H1 | 52 (n≥150) | **0** | best `PF 0,928 · n 358 · DD 10,84%` |
| `ABTG_CostToCost` · `D30EUR` | 6 | **0** | best `PF 0,849 · n 113`; a H1 **`DD 52,9%` su n 403** 🔴 |
| `ABTG_EasyTrend` · entrambi | 2 + 2 | **0** | `PF 0,938` e `PF 0,923`; solo 2 celle → **`[NON ANCORA MISURATO]`**, non morto |

🔴 **Su `EMA200` DAX/Nasdaq la casella dei PARAMETRI e' chiusa** (114 celle H1, zero positive,
campione pieno). ✅ **Su `EasyTrend` no**: 2 celle non sono un verdetto — manca la gestione
dell'uscita ad asse e manca il TF. Verdetto: **NON ANCORA MISURATO**.

---

# 5. 🏆 LA CLASSIFICA DEI MAI MISURATI SUL CORTO DI DAX/NASDAQ

Ordine = **probabilita' di funzionare**, e ogni riga porta la **ragione misurata**.
Costo in **passate** = celle × 2 finestre (IS/OOS), come conta `controlla_prova.py`.
🚫 **Nessuno di questi e' proposto come sedia**: sono misure.

### 🥇 1 — `ABTG_IntradayMomentum` · `NASUSD` e `D30EUR`
| voce | numero | fonte |
|---|---|---|
| corto altrove | ⚪ il lato **non e' mai stato un asse** (4 passate su NASUSD, tutte `(1,1)`) | questo censimento |
| simmetria | 🟢 **SIMMETRICO PER COSTRUZIONE**: il segno del rendimento della prima mezz'ora predice il segno dell'ultima. **Zero filtri di trend** nel sorgente (0 input EMA/ADX/Supertrend su 1.009 righe) | `mql5/Experts/ABTG_IntradayMomentum.mq5` |
| costo | 🟢 **53,3x su `NASUSD`**, **47,8x su `U30USD`** (mediane misurate, ora 20) — **passa il 40x**. Su `D30EUR`: stop `2,0 × ATR(M30)`, e `ATR(14) D30EUR M30 = 36,4-41,4 idx` `[DERIVATO]` → stop **72,8-82,8 idx** → **45,5-51,8x** su spread 1,60 → **passa** `[DERIVATO]` | `REGISTRO_TEST.md` r.3117 · `ATR_DAX_M30_RICONCILIAZIONE_2026-09-17.md` r.16 |
| frequenza | 🟢 **1,00 op/giorno per costruzione**, **160-180 (IS) e 240-270 (OOS)** operazioni attese: **l'unico che garantisce `n ≥ 150` in tutte e due le finestre** | `REGISTRO_TEST.md` r.3287, r.3292 |
| numeri gia' in casa | `NASUSD` OOS **`PF 1,243 · RF 1,351 · n 261 · DD 3,03%`** e **`PF 1,486 · n 133`**; IS negativo (`PF 0,609 · n 146`) → **ribaltamento IS→OOS da dichiarare** | `risultati_prove/dal_vps/ABTG_IntradayMomentum/*_r141a.csv` |
| 🔴 quello che NON promette | il TF **non aiuta** (`0,00 op/g` guadagnate scendendo, misurato dal codice) e il `D30EUR` **non e' mai stato girato**: la prima mezz'ora del DAX e' un altro mercato | `REGISTRO_TEST.md` r.3274 |
| **misura proposta** | **ablazione del LATO**, 3 celle (`LS` / `solo L` / `solo S`) × 2 simboli × 2 finestre = **12 passate**. Sul `D30EUR` serve prima una cella di conta (il motore non ha mai girato li'): **+4 passate** | — |

### 🥈 2 — `ABTG_ORB_Ottimizzato` · `NASUSD` (216 passate, lato mai ad asse)
- 🟢 **simmetrico per costruzione**: max/min dell'opening range, i due pendenti sono speculari.
- 🔴 **e qui c'e' una tesi da battere, e la scrivo**: sul **Dow** lo stesso motore ha il corto
  **DISTRUTTO** (`R54`: `PF OOS 0,520 · DD 26,37%`, rosso in **tutte e due** le finestre =
  *asimmetria strutturale*, `CENSIMENTO_LATI_SHORT_2026-08-25.md`). **Su un motore gia' ucciso
  sul corto di un simbolo, il corto su un altro simbolo NON e' una ripetizione: e' un simbolo
  nuovo** — ma la tesi nuova deve esserci, e qui e' una sola: **`R97` ha trovato che sul Nasdaq
  il problema sono gli INGRESSI, non il lato**. Quindi la misura vale **solo** insieme a un
  cambio di ingresso, non da sola.
- 💰 costo: `770611` ORB `U30USD` M5 misurato **29,5x** 🔴, riparabile a **~64,0x** con
  `InpSLMode: HALFRANGE → OPPRANGE`. Su `NASUSD` **`[NON MISURATO]`**.
- **misura proposta**: **3 celle di lato × 2 finestre = 6 passate**, e **solo** sulla geometria
  `OPPRANGE` (quella che passa il costo). ⚠️ Prima serve la riga del costo su `NASUSD`.

### 🥉 3 — `ABTG_SupertrendReversal` · `D30EUR` H1, **la corona di `(2,5 · 14)`**
- 🟢 la ragione e' in §3.2: **l'unico corto di DAX/Nasdaq con `n ≥ 150`** (12 celle), altopiano
  su `TP_RR`, e **corona MAI misurata** perche' la griglia era genetica.
- ⚠️ **E qui devo essere onesto con la regola di casa**: questo **e'** un allargamento di
  parametri. E' ammesso **solo perche' il motore NON e' dichiarato senza edge su quel simbolo**
  — anzi: `SupRev DAX H1` e' validato a tick reali a `PF 1,45 · n 223` (`REGISTRO_TEST.md` r.260)
  e `DAX H4` a `PF 1,96`. Il corto e' un **LATO mai separato**, non una griglia piu' fitta su un
  morto. 🔴 **Se la corona esce rossa, la casella si chiude e lo si scrive.**
- 💰 costo `D30EUR` H1: distanza mediana prezzo→Supertrend misurata **54,88 pt** a
  `ST(10 · 2,0)` (`SUPERTREND_IL_CERTIFICATO_2026-09-22.md` §5.3) = **31,0x** a spread 1,7676.
  A `InpStMult = 2,5` il rapporto scala a **68,6 pt = 42,9x** su spread 1,60 `[DERIVATO]`, e lo
  stop dell'EA e' `max(linea ST, estremo 5 barre) + buffer` (r.386-389) → **puo' solo essere piu'
  largo**. 🟢 **passa, al pelo** `[DERIVATO]`. 🔴 Il numero vero e' `[NON MISURATO]`.
- **misura proposta**: corona completa `InpStMult {2,0 · 2,5 · 3,0}` × `InpStAtrPeriod
  {13 · 14 · 15}` × `InpTP_RR {2,0 · 2,5}` = **18 celle × 2 finestre = 36 passate**, lato pinnato
  `(0,1)`, **su un file prova solo**, con l'attesa dichiarata prima: *«se l'altopiano c'e', le 6
  celle con `StAtrPeriod` 13-15 a `StMult 2,5` escono tutte `PF > 1,20` con `n > 150`»*.

### 4 — `ABTG_PTE` · `D30EUR` e `NASUSD` (64 + 64 passate, lato mai ad asse)
- 🟢 **mean-reversion sugli estremi dei canali di regressione**: simmetrico per costruzione.
- 🔴 **costo, ed e' il problema**: `771321 PTE U30USD H1` = **39,0-44,1x, 🟠 FRAGILE**, e la
  manopola di riparazione **`InpSLbufferPips` e' INERTE sugli indici** (25 «pip» = **0,25 punti
  indice**). **Un buffer in ATR in `ABTG_PTE.mq5` NON ESISTE.** Su DAX/Nasdaq `[NON MISURATO]`.
- **misura proposta**: **6 passate** (3 celle di lato × 2 finestre) per simbolo — ma **dopo** la
  riga del costo, non prima.

### 5 — `ABTG_WOL` · entrambi (44 + 44 passate, lato mai ad asse)
- 🟢 inversione con doji alla **Weekly Open Line** su D1: simmetrica, e **il TF alto aiuta il
  costo** (su D1 lo stop e' enorme rispetto allo spread). 🔴 **frequenza**: su D1 le occasioni
  sono poche — `[NON MISURATO]` su questi due simboli.
- **misura proposta**: **6 passate** per simbolo.

### 6 — `ABTG_IBRetest` · entrambi (8 + 8 passate, lato mai ad asse)
- 🟢 il sorgente dichiara **«macchina a TRE STATI, DUE LATI»**: simmetrico.
- 🔴 **ma e' gia' un caduto**: `09/09` scartato dal cancello **C0**, `PF famiglia 0,7798 su
  n = 344`, «resta chiuso» (`REGISTRO_TEST.md` r.2138, r.3073). **Non si riesuma senza una tesi
  nuova**, e l'unica che avrei — *«il lato non e' mai stato separato»* — vale **6 passate**, non
  un round. La metto in fondo apposta.

### ⚪ E i 33 motori con **zero passate** su DAX/Nasdaq
Sono caselle vuote (elenco in §8). 🔴 **Nessuno di loro diventa una sedia entro il 1 ottobre** —
lo dice gia' `CENSIMENTO_CASELLE_VUOTE_2026-09-22.md` §0.5, e non lo contraddico. I tre che
metterei per primi **dopo** ottobre, tutti **simmetrici per costruzione e senza filtro di trend
nel sorgente**: `ABTG_MeanRevert` (*«lo short e' lo specchio esatto»*, 379 righe, 0 input di
trend), `ABTG_VwapRevert` (0 input di trend su 1.755 righe), `ABTG_LiquiditySweep` (sweep+reclaim,
0 input di trend). ⚠️ `ABTG_BreakinBox` **no**: chiuso il 31/08, *«l'ablazione lo smaschera come
R95 con un livello nuovo»*.

---

# 6. 💸 CHI E' ESCLUSO **PER COSTO**, col numero accanto

Frontiera di casa: **`stop ≥ 40 × spread`**; pavimento **duro 13,3x**.
Spread **misurati**: `D30EUR` **1,60** (ore 8-9) → servono **64,00 punti indice** ·
`NASUSD` **1,80** (ore 14-15) → servono **72,00** · `U30USD` **3,00** → **120,00**
(`IL_NASDAQ_IN_PUNTI_E_IL_DAX_2026-09-23.md` §5.1).

| motore · simbolo · TF | stop | × spread | esito |
|---|---:|---:|---|
| 🔴 `SupRev` **`NASUSD` H1** (`970913`) | swing 5 barre + 3 «pip» (**inerti**: 0,03 idx) | **28,7x** | 🪦 **ESCLUSO PER COSTO.** Il corto del SupertrendReversal sul Nasdaq **non si propone a H1**. Riparazione a costo zero gia' scritta: **TF H2/H4** (la gemella `770531` su H4 fa **147,8x**) |
| 🔴 `AtrExhaustVol` **`NASUSD` M5** | ~18,5 idx `[DER]` | **10,9x** | 🪦 **ESCLUSO PER COSTO**, sotto il pavimento **duro** 13,3x. M15 **18,8x** · M30 **26,6x** · H1 **37,7x**: 🔴 **nessun TF arriva a 40x** |
| 🔴 `HVAncora` **`U30USD` M5** | — | **9,3x** (ore 14-20) · **7,1x** (08-13) | 🪦 **ESCLUSO PER COSTO** (per memoria: su DAX/Nasdaq non ha nessuna passata) |
| 🟠 `770411` MaxMinNotte_DAX_Short **`D30EUR` M15** | `2,5 × ATR(14) M15`, banda 64,2-87,5 | **37,8-51,5x** | ⚪ **`[NON MISURATO]` · FRAGILE**: il 40x **non e' deciso** |
| 🟠 `970912` SupRev_DAX_H4 **`D30EUR` H4** | swing 5 barre H4 | **27,8-184x** | ⚪ **`[NON MISURATO]`**: il 40x **non e' piu' deciso** (rettifica 18/09) |
| 🟢 `IntradayMomentum` **`NASUSD`** | `2,0 × ATR(M30)` | **53,3x** | ✅ **passa** |
| 🟢 `IntradayMomentum` **`D30EUR`** | `2,0 × ATR(14) M30` = 72,8-82,8 idx `[DER]` | **45,5-51,8x** | ✅ **passa** `[DERIVATO]` |
| 🟢 `SupRev` **`D30EUR` H1** a `InpStMult 2,5` | ≥ 68,6 idx `[DER]` | **≥ 42,9x** | ✅ **passa, al pelo** `[DERIVATO]` |

## 🧪 IL CONTRO-ESEMPIO SUL COSTO — provo a rompere il mio stesso `42,9x`
Il `42,9x` del `SupRev` DAX H1 e' **scalato** da una misura fatta su **dati esterni 2013-2018**
con `ST(10 · 2,0)`, non sul nostro feed 2024-2026, e con **ATR(10) invece di ATR(14)**.
**L'ipotesi alternativa produce un numero che cade dentro la banda?** Si': lo stesso motore,
misurato **in casa** sul Nasdaq a `InpStMult 3,0`, fa **28,7x** — cioe' **molto sotto** il 40x
nonostante un moltiplicatore piu' grande. 👉 **Quindi il `42,9x` del DAX NON e' un verde: e' un
`[DERIVATO]` che una misura di casa sul simbolo gemello contraddice.** La sola cosa che regge per
costruzione e' la disuguaglianza `stop ≥ distanza-Supertrend` (r.389 `MathMax`). **Il numero vero
resta `[NON MISURATO]`, e va misurato prima di proporre la corona di §5.3.**

---

# 7. 🔭 IL QUADRO — cosa dicono questi numeri messi insieme

| fatto | numero |
|---|---|
| 🟢 **il corto funziona sul Dow** (`EMA200`) | 26/26 celle positive **a tick reali**, `PF 1,658 · n 368` |
| 🟢 **il corto funziona sul DAX notturno** (`MaxMinNotte`) | 45/46, ed **e' in campo** |
| 🟢 **il corto batte il lungo sul Nasdaq** (`GoldenCross`) | **27/48 contro 0/69** |
| 🟢 **la geometria del corto non e' penalizzata** su nessuno dei due | win rate necessario **53,65%** (DAX) e **55,36%** (Nasdaq) contro 52,05% e 55,52% dei lunghi |
| 🔴 **ma nessun corto su DAX/Nasdaq e' mai stato misurato a TICK REALI** | **0 passate** short-only a tick su **184** validazioni `SupRev` |
| 🔴 **e solo UNO supera le 150 operazioni** | `SupRev D30EUR H1`, 12 celle, `PF max 1,372` |

> ## 🎯 **La conclusione giusta NON e' «il corto non funziona su DAX e Nasdaq». E' questa: il corto su questi due simboli e' stato misurato POCO, SUL BANCO OTTIMISTA e CON CAMPIONI PICCOLI — e dove e' stato misurato bene (Dow, DAX notturno) VINCE.** Il buco non e' un verdetto: e' un buco.

---

# 8. 🕳️ QUELLO CHE NON HO COPERTO — elenco per nome, mai «tutto il resto» (classe 180)

1. **41 righe con simbolo non risolto**: `csv_R80/PTEGBP_*` e `csv_R80/PTEJPY_*` (40 righe,
   forex) e `R114_CORSA_20260827/R114_canarino_A.csv` (2 righe, `InpComment = "ORB OTT"`).
   🟢 **Nessuna di queste e' DAX o Nasdaq** — verificato: l'unico candidato ambiguo (`R114`) ha
   `InpRangeStartHour = 14:30`, cioe' apertura USA, e i suoi `InpAllowShort` sono `(1,1)`.
2. **314 righe non attribuite a un motore**: `risultati_prove/regime_r59` (100),
   `risultati_archivio/csv_R80` (80), `risultati_prove/regime_r50` (80),
   `risultati_archivio/R113_CORSA_20260827` (36, **lette a mano in §3.4**),
   `risultati_prove/regime_r57` (16), `R114_CORSA_20260827` (2). **Solo le 36 di `R113` toccano
   DAX/Nasdaq, e sono contate.**
3. **CSV con un input di lato DIVERSO da `InpAllowLong/Short`**: `InpSide` (16 file) e `InpLato`
   (4 file). Li ho aperti a mano: sono **sonde** — `ABTG_SondaGapCash_NASUSD_*` (2),
   `ABTG_SondaRelativo_{D30EUR,NASUSD}_*` (2, **usate in §3.5**),
   `ABTG_SondaOrologio_D30EUR_*` (4, **usate in §3.4**),
   `ABTG_OpeningReversalB_U30USD_*` (16, **Dow: fuori perimetro**). **Nessuna e' un P/L.**
4. **Le 42 EA senza input di lato** (115 sorgenti − 73): non sono nel perimetro di questo
   referto per definizione. Fra queste ci sono motori che operano un lato solo per costruzione
   (`ABTG_CRT_TurtleSoup`, `ABTG_GapContinuation`, `ABTG_Bulge`, `ABTG_PostNews`, `ABTG_Relativo`,
   `ABTG_LondonFx`, `ABTG_BreakoutCorso`, `ABTG_BreakingBand`, `ABTG_GapFill`, `ABTG_DaxReEntry`,
   `ABTG_DaxValueArea`, `ABTG_VolExpBreak`, `ABTG_AltaVelocita`, `ABTG_Apertura_Study_EA`,
   `ABTG_OpeningReversalB`, `ABTG_MIS_SIZING_*`, gli EA oro di terzi): **`[NON VERIFICATO]` se il
   lato sia vincolato dal codice o solo dal preset.**
5. **I 33 motori con zero passate su DAX/Nasdaq** (esclusi i 7 derivati pinnati ad altri
   simboli, elencati in §2.1): `ABTG_AllineaLondra` · `ABTG_Apertura_Marco` · `ABTG_BreakinBox` ·
   `ABTG_CanaleLento` · `ABTG_ChaosLyapunov` · `ABTG_CrossEmaApertura` · `ABTG_Cycle` ·
   `ABTG_DAX_M3` · `ABTG_EMA200_Ottimizzato` · `ABTG_FiboH4_Corso` · `ABTG_FiboH4_Multi` ·
   `ABTG_FvgRetest` · `ABTG_GoldenCross_V1` · `ABTG_HARSI` · `ABTG_HVAncora` ·
   `ABTG_ImpulsoApertura` · `ABTG_InvEsaurimento` · `ABTG_LVNArbitro` · `ABTG_LiquiditySweep` ·
   `ABTG_Londra_ORB` · `ABTG_MIS_SIZING_EMA200` · `ABTG_MaxMinNotte_DAX_Short_Ottimizzato_MFE` ·
   `ABTG_MeanRevert` · `ABTG_Nasdaq_Apertura_US_Ottimizzato` · `ABTG_Nightly_Ottimizzato` ·
   `ABTG_NySessionRetest` · `ABTG_OutOfNoise` · `ABTG_SuperWave_EA` ·
   `ABTG_SupertrendReversal_Multi` · `ABTG_SupertrendReversal_Multi_Ottimizzato` ·
   `ABTG_SupertrendReversal_Ottimizzato` · `ABTG_TurnaroundTuesday` · `ABTG_VwapRevert`.
   ⚠️ **`ABTG_Apertura_3Ingressi` NON sta in questo elenco**: ha 12 passate per simbolo, a lato
   fisso, quindi sta nella classe ⚪ di §2.2.
6. 🔴 **Nessun numero a tick reali sul corto di DAX/Nasdaq esiste in repo.** Non e' una lacuna
   di questo referto: e' una lacuna del progetto, ed e' il punto §2.2.
7. 🔴 **La finestra e' UN SOLO REGIME.** I dati BCM sugli indici partono dal **2024.09.26**
   (`REFERTO_SONDA_STORICO_17-08.md` §3, stato `COMPLETO`): 21 mesi di **toro**. Ogni verdetto
   corto qui dentro nasce con l'etichetta **«per questa epoca»**, mai «per sempre».

---

# 9. 📝 CLASSI NUOVE PER LA CHECKLIST — 23/09/2026

Numeri **grepati al momento della scrittura**: l'ultima classe in
`backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md` e' la **647**. Queste sono la **648** e la **649**.

### CLASSE 648 — «il lato non e' mai stato un ASSE» non e' «il lato e' stato misurato»
Cercare il lato corto per **nome di file** (`*short*`) invece che per la **coppia**
`(InpAllowLong, InpAllowShort)` **dentro** i CSV fa sbagliare in tutti e due i versi.
**Caso reale 23/09**: `R113_F0_02_short.csv` non nomina il simbolo (`NASUSD` sta solo in
`InpComment`), mentre `scan_ABTG_SupertrendReversal_H1_D30EUR.csv` — nessun «short» nel nome —
contiene **37 passate short-only**. **Estensione della classe 640 al LATO.**
👉 **Regola**: il censimento di un lato si fa sulle **colonne**. E una casella si chiama
**⚪ «lato mai ad asse»**, che e' una terza categoria fra «misurato» e «non gira».

### CLASSE 649 — il lato ad asse come DUE booleani fabbrica la passata a vuoto
Mettere `InpAllowLong` e `InpAllowShort` come due `Y` indipendenti nell'ottimizzatore genera
anche la cella `(0,0)` = **nessun lato acceso** = **0 operazioni**.
**Misurato oggi su tutto l'archivio**: **14.182 passate su 60.576 (23,4%)** hanno `(0,0)`, e
**14.182 su 14.182** hanno `Trades = 0`. Su `D30EUR`+`NASUSD` sono **554**. Sono sparse su
**368 file**.
👉 **Regola**: il lato si mette ad asse come **UNA manopola a 3 valori** (`LS` / `solo L` /
`solo S`), non come due booleani. Costo del difetto: **un quarto del tempo macchina speso in
quelle scansioni e' stato buttato.**

---

# 10. 🎯 COSA CHIEDO A CLAUDIO — e non e' un round da lanciare oggi

🚫 **Non propongo nessuna riga di lancio**: i round girano sul **PC di backtest**, non sul VPS
(firma del 21/09), e tu sei da cellulare. Questi sono **file prova da scrivere quando la macchina
c'e'**, in ordine, col costo:

| # | misura | passate | perche' prima delle altre |
|---:|---|---:|---|
| 1 | **ablazione del lato** su `IntradayMomentum` `NASUSD` + `U30USD` | **12** | l'unico candidato che **garantisce `n ≥ 150`** e **passa il costo con margine** |
| 2 | **misura dello stop** di `SupRev` su `D30EUR` H1 e `NASUSD` H1/H4 sul NOSTRO feed | **0 passate di tester** (si legge dai trade e dallo spread logger) | 🔴 senza quel numero la #3 non si puo' proporre: oggi e' `[DERIVATO]` e una misura di casa lo contraddice |
| 3 | **corona di `(StMult 2,5 · StAtrPeriod 14)`** sul corto `SupRev` `D30EUR` H1 | **36** | l'unico corto di DAX/Nasdaq con `n ≥ 150`; oggi non sappiamo se e' altopiano o picco |
| 4 | **ablazione del lato** su `ABTG_PTE` `D30EUR`+`NASUSD` | **12** | mean-reversion simmetrica, 128 passate gia' spese a lato fisso |
| | **totale** | **60 passate** | due round da trenta, non una griglia da seicento |

🙋 **E una cosa che puoi chiudere TU, e vale piu' di tutte**: quando la challenge lo permette,
**una singola validazione a tick reali del lato corto su DAX o Nasdaq** cancellerebbe il buco
piu' grosso di questo referto — perche' oggi, su quei due simboli, **il corto non l'ha mai
guardato nessuno ai prezzi veri.**

---

_Fine R233. Zero round, zero righe, zero passate spese, zero file altrui toccati._
