# 📐 L'ANCORA ADR DELLA FLOTTA INDICI — RICALIBRATA, E LA LEGGE √T VALIDATA SU DUE SIMBOLI

**Data: 2026-09-18 · SOLA LETTURA · zero costo macchina (tutti i dati erano già in repo)**
**Referto NUOVO: non riscrive `CANCELLO_COSTO_FLOTTA_2026-09-10.md` né
`ATR_DAX_M30_RICONCILIAZIONE_2026-09-17.md` — dice quali loro righe cambiano.**

---

## 🛑 IN TESTA, LA REGOLA DEL «SI CORREGGE UNA VOLTA SOLA»

🔴 **Chi usa i numeri di questo referto NON deve aggiungerci il «+18-27%»**
annotato in `EMA200_I_DUE_REQUISITI_2026-09-12.md` **r.182** né il «~18-27%»
della coda di `CANCELLO_COSTO_FLOTTA_2026-09-10.md`. Quella sottostima **è già
dentro** la correzione dell'ancora: contarla due volte gonfia ogni numero.

🔴 **E una precisazione che vale quanto la regola**: i difetti sono **DUE, non
uno**, e sono **indipendenti** — quindi si applicano entrambi **una volta
ciascuno**, non si sommano al vecchio 18-27%:
1. **aggregazione** — min-per-data invece di max-per-data (trovato il 17/09);
2. **finestra della legge** — denominatore **1440** invece della **finestra
   attiva del simbolo** (trovato qui, §4).
Sul **Dow** morde solo il primo (il secondo vale 2%). Sul **DAX** mordono
entrambi: la catena originale (`186,5 × √(240/1440) = 76,1`) sottostimava
l'ATR(H4) misurato di **−45,5%**.

---

## 🎯 IL VERDETTO IN CINQUE RIGHE

> 🟢 **L'ancora nuova (max-per-data) è quella giusta, e NON va «de-troncata»:
> ho provato due de-troncature e le ha bocciate la misura** (§5).
> 🟢 **La legge √T è ora validata su DUE simboli e DUE TF — `D30EUR` H4
> (+0,3%) e `U30USD` H1 (−0,7%) — a patto che il denominatore sia la
> FINESTRA ATTIVA del simbolo** (DAX **780 min**, indici USA **~1380**), non
> 1440 per tutti. Col 1440 universale il DAX sbaglia di **−26,2%**.
> 🟡 **Il cancello di costo cambia verdetto su 4 celle, tutte in meglio**, e
> **nessuna peggiora**. 🟢 **Due passano da `[INF]` a `[MISURATO]`**.
> 🔴 **Ma due numeri che davo per acquisiti sono caduti sotto il contro-esempio:
> l'«`ATR(M15) DAX ≥ 22,0`» del 17/09 NON segue dai dati, e il mio stesso
> «pavimento misurato» su `770250` non regge** (§7, §8-D).
> 🔴 **E c'è un disaccordo di casa sullo spread di coda del DAX (1,70 contro
> 2,70)** che decide da solo il verdetto al p95 su tutto il DAX (§6).

---

## 1. 🔬 IL DIFETTO, RILETTO SUL CODICE — la premessa del mandato va corretta

Il mandato (e il referto del 17/09) dice che al max-per-data *«manca il tratto
fra l'ultimo trade della giornata e la campanella»*. 🔴 **Sul codice è il
CONTRARIO.**

`mql5/Experts/ABTG_TradeExporter.mq5` **r.79-96** (`SessionRange`):

```
MqlDateTime d; TimeToStruct(from,d);
d.hour=23; d.min=59; d.sec=0;
datetime to = StructToTime(d);
```

👉 `from` = **`open_time` del trade**, `to` = **23:59 dello stesso giorno**. La
finestra è **`[apertura del trade → fine giornata]`**: completa DIETRO, troncata
**DAVANTI**. E l'export si rifà a ogni timer (`OnTimer`, r.106) riscrivendo
tutto il file, quindi per le giornate passate il `to` non è mai clampato.

### ✅ La prova empirica, e non lascia scampo: **35 date su 35**
Su tutte le date con più valori (17 `D30EUR` + 7 `U30USD` + 11 `NASUSD`) il
**trade più PRECOCE porta SEMPRE il range più grande**, e la serie è monotona
non crescente nell'ora d'apertura. `[MISURATO]` n=35 date.

| esempio | valori per ora d'apertura |
|---|---|
| `D30EUR 2026.06.08` | 08:02=**343,6** · 08:03=343,6 · 08:23=258,9 · 08:51=258,4 |
| `U30USD 2026.08.31` | 01:00=**400** · 06:00=400 · 07:28=400 · 07:58=400 · 13:07=367 · 20:00=95 |
| `NASUSD 2026.07.30` | 00:00=**1090,1** · 14:33=614,5 · 14:35=579,3 |

*(il `2026.06.08 → [258,4 · 258,9 · 343,6]` citato nel mandato è la stessa riga
ordinata per valore invece che per ora: il **343,6** è il trade delle **08:02**,
non l'ultimo della giornata.)*

### 🎯 Perché conta, e non è pedanteria
Cambia **quale correzione serve**. Se il difetto fosse in coda, servirebbe
stimare un *tetto*. Essendo in testa, la domanda diventa *«quanti minuti ATTIVI
copre la mia misura?»* — e la risposta è la §4, che è anche la ragione per cui
il DAX sbagliava del 26% e nessuno capiva perché.

---

## 2. 🏺 L'ANCORA NUOVA, per simbolo — **max per data, mediana, GREZZA**

Metodo dichiarato: per ogni data si prende il **massimo** dei range
`session_high − session_low` (= la finestra più lunga disponibile), poi la
**mediana** sulle date. **Escluso il giorno in corso** (`2026.09.17`, export
ancora aperto: il suo `to` è clampato all'ultima barra).
Fonte: `data/statements/trades_auto.csv` + `data/statements/trades_100k.csv`.

| simbolo | 🟢 **ANCORA (max-per-data)** | n giornate | media | p25 | p75 | giorno max | vecchio (min-per-data) | tag |
|---|---:|---:|---:|---:|---:|---:|---:|---|
| **D30EUR** | 🟢 **252,5** | **52** | 253,0 | 162,2 | 308,6 | 601,7 | 185,6 *(casa: 186,5)* | `[MISURATO]` |
| **U30USD** | 🟢 **379,5** | **24** | 383,0 | 277,2 | 469,8 | 769,0 | 314,5 *(casa: 314,5)* | `[MISURATO]` |
| **NASUSD** | 🟢 **384,6** | **26** | 433,0 | 255,5 | 528,0 | 1090,1 | 300,4 *(casa: 313,8)* | `[MISURATO]` |
| **225JPY** | 793,0 | **9** | 709,9 | 293,0 | 1039,0 | 1739,0 | 446,0 | `[MISURATO]` 🟡 **SOTTILE (n=9)** |
| **SPXUSD** | 60,8 | **2** | 60,8 | — | — | 66,2 | 60,8 | 🔴 `[NON CITABILE]` n=2 |
| **F40EUR** | 85,3 | **1** | 85,3 | — | — | 85,3 | 85,3 | 🔴 `[NON CITABILE]` n=1 |

Unità: **punti indice** (`D30EUR`/`U30USD`/`NASUSD`/`SPXUSD`/`F40EUR`: 1 idx =
100 punti MT5 — `PROPOSTA_RELATIVO_TICK_REALI_2026-09-04.md` r.352 `[MIS]`;
`225JPY`: 1 idx = 1 punto MT5 — `CANCELLO_COSTO_FLOTTA` r.292).

### ✅ Contro-esempio #1: **ho ricostruito la pipeline di casa, e lo dimostro su 7 righe**
Con il filtro di casa (`close_reason = sl` **e** `profit < 0`) riproduco **alla
cifra** 7 dei 9 `[MIS]` di `CANCELLO_COSTO_FLOTTA` §5.1:

| magic | mio | casa | esito |
|---|---:|---:|---|
| `770101` | **71,90** n=7 | 71,9 n=7 | 🟢 riproduce |
| `770611` | **59,00** n=7 | 59,0 n=7 | 🟢 riproduce |
| `770511` | **77,10** n=4 | 77,1 n=4 | 🟢 riproduce |
| `770531` | **295,50** n=8 | 295,5 n=8 | 🟢 riproduce |
| `772341` | **274,15** n=2 | 274,2 n=2 | 🟢 riproduce |
| `772234` | **98,00** n=1 | 98,0 n=1 | 🟢 riproduce |
| `771531` | 88,10 n=**10** | 104,3 n=8 | 🟡 **lo statement è CRESCIUTO**: 2 gambe nuove dopo il 10/09 |
| `970913` | 27,10 n=**5** | 51,65 n=4 | 🟡 idem, 1 gamba nuova |

E il min-per-data riproduce `U30USD` **314,5**, identico a
`ROUND_ORB_ATR_PS5_2026-09-10.md` **r.234**. 👉 Il difetto è loro, non mio.

### ⚠️ Il conto 100k **non aggiunge nemmeno una giornata** — e i suoi numeri sono più bassi per lo stesso difetto
`trades_100k.csv` da solo darebbe `D30EUR` **160,6** (n=16), `U30USD` **306,0**
(n=9), `225JPY` 793,0 (n=3). 🔴 **Ma le sue date sono un SOTTOINSIEME esatto di
quelle del piccolo** (verificato: `100k \ auto = ∅` su tutti e tre i simboli), e
le sue sedie **aprono più tardi** (`D30EUR`: primo trade mediano **09:15**
contro **08:17**). Quindi è **la stessa troncatura, più forte**: il pooling non
cambia un numero e i valori del 100k **non vanno citati come un secondo parere**.

---

## 3. 📏 GLI ATR MISURATI — ora sono DUE, non uno. **E il secondo l'ho trovato oggi**

Questo è il pezzo che mancava per validare qualunque legge di scala.

### 🟢 `U30USD` H1 — sedia `771531` (EMA200)
Geometria dal codice `mql5/Experts/ABTG_EMA200.mq5` **r.356-358**:
`o1 = ema ± Order1·ATR` · `o2 = ema ∓ Order2·ATR` · `sl = o2 ∓ SLatr·ATR`
⟹ **gamba 2 = 1,00 × ATR(14)** sul TF `InpTF`.
Preset `mql5/Presets/ABTG_EMA200_U30USD_H1_771531_VIVA.set`: `InpTF=16385`
(**H1**) · `InpOrder1Atr=0.2` · `InpOrder2Atr=0.3` ⟹ rapporto gamba1/gamba2 = **1,50**.

**Eventi con le DUE gambe chiuse in stop pieno** (entrambe in perdita, quindi
né pari né trailing):

| data | gamba 1 | gamba 2 | rapporto | ⟹ ATR(14) H1 |
|---|---:|---:|---:|---:|
| 2026.08.24 14:32 | 98,20 | 65,50 | **1,4992** | 65,50 |
| 2026.08.27 09:54 | 110,40 | 73,60 | **1,5000** | 73,60 |
| 2026.09.04 21:30 | 117,00 | 78,00 | **1,5000** | 78,00 |
| 2026.08.28 18:01 | 142,90 | *(sola)* | — | 95,27 |
| 2026.08.24 19:00 | 147,00 | *(sola)* | — | 98,00 |

🟢 **`ATR(14) U30USD H1 = 78,0` `[MISURATO]` · mediana su n=5 eventi puliti ·
banda 65,5-98,0.**
🔴 **E il secondo valore di casa, che NON concorda**: `R112` per-trade backtest
dà **88,2** su **n=33 coppie** (`EMA200_I_DUE_REQUISITI_2026-09-12.md` r.157).
**Scrivo entrambi**: banda **78,0 – 88,2**.

### 🟢🆕 `D30EUR` H4 — sedia `771501` (EMA200 sul DAX) — **MAI USATA PRIMA COME RIGHELLO**
`771501` è il **magic di DEFAULT** dell'EA (r.104) e il preset generico
`mql5/Presets/ABTG_EMA200_H4.set` porta `InpTF=16388` (**H4**) ·
`InpOrder1Atr=0.10` · `InpOrder2Atr=0.35` ⟹ rapporto **1,45**.
**Non esiste nessun preset EMA200 per `D30EUR`** (verificato): la sedia girava
a default o con quel preset — in tutti e due i casi **H4 e 1,45**.

| data | gamba 1 | gamba 2 | rapporto | ⟹ ATR(14) H4 | note |
|---|---:|---:|---:|---:|---|
| 2026.07.21 | 202,60 | 139,70 | 🎯 **1,4502** | **139,70** | entrambe in perdita |
| 2026.07.24 | 201,50 | 139,00 | 🎯 **1,4496** | **139,00** | entrambe in perdita |
| 2026.07.23 | 206,30 | *(la L2 è uscita in PROFITTO: trailing, esclusa)* | — | **142,28** | da gamba 1 / 1,45 |

🟢 **`ATR(14) D30EUR H4 = 139,7` `[MISURATO]` · mediana su n=3 eventi ·
banda 139,0-142,3.**

### ✅ Contro-esempio #2: **il rapporto 1,45 NON prova il TF. Cosa lo prova?**
Il rapporto è indipendente dal TF, quindi non basta. Tre prove indipendenti:
1. 📋 il **preset** e il **default compilato** dicono H4, e nessun `.set` per
   `D30EUR` esiste;
2. 🔢 il rapporto misurato **1,4496/1,4502** identifica la cella **0,10/0,35**
   (il default), *non* la cella 0,2/0,3 della sedia Dow (che infatti misura
   **1,4992/1,5000/1,5000**): le due sedie si distinguono **dai dati**;
3. 🧮 **l'ancora stessa lo conferma**: se fosse H1, l'ancora giornaliera
   implicata sarebbe `139,7 × √(780/60) = **503**` (o 684 col 1440) — cioè
   **il DOPPIO** del misurato 252,5 e **sopra il giorno più volatile mai
   osservato** (601,7) *preso come tipico*. Assurdo. A H4 l'ancora implicata
   è **252,0**, contro **252,5 misurato**: 🎯 **0,2%**.

### 🔴 E il validatore che il mandato mi chiedeva di usare **NON È USABILE**
Il mandato indica `970913 / NASUSD / H1 → 51,65 idx [MIS] n=4`
(`CANCELLO_COSTO_FLOTTA` **r.407**). **Non è un ATR, e non può validare niente:**
- la colonna si chiama **`stop`** (header **r.389**) e la geometria dichiarata è
  **«swing 5 barre H1 + 3 pip»** — uno stop *strutturale*;
- le distanze realizzate sono **0,00 · 9,70 · 12,80 · 27,10 · 151,90**: un
  fattore **15** fra estremi, con dentro uscite in trailing. Non è un righello;
- e il **contro-esempio decisivo**: se 51,65 fosse l'ATR(H1) di `NASUSD`,
  l'ancora giornaliera implicata sarebbe `51,65 × √(1380/60) = **247,7**`, cioè
  **−36%** sotto il misurato 384,6 e **sotto il suo p25** (255,5). 👉 Prenderlo
  per un ATR **contraddice una misura con n=26**.

**Quindi su `NASUSD` non esiste nessun ATR misurato**, e ogni sua scalatura
resta `[INFERITO]`. Detto, non aggirato.

---

## 4. 📐 LA LEGGE, VALIDATA SU DUE SIMBOLI — e il denominatore **non è 1440 per tutti**

Legge dichiarata: **`ATR(T) = ancora × √(T / W)`**, dove **`W` = minuti ATTIVI
coperti dalla misura dell'ancora**.

### Da dove vengono le due `W`, e **non sono state adattate al risultato**
- **`D30EUR` → W = 780 min (08:00-21:00 server).** Due prove indipendenti,
  entrambe *precedenti* al confronto con l'ATR:
  - 🟢 **il tratto prima delle 08:00 non aggiunge NULLA**: su **4 date su 4**
    dove esiste sia un trade pre-08:00 sia uno alle 08:00, il range è
    **identico alla cifra** — `02:06 = 08:00 = 447,7` (30/07) ·
    `02:36 = 08:00 = 252,2` (28/07) · `07:00 = 08:00 = 268,9` (29/07) ·
    `07:02 = 08:00 = 307,8` (20/07). `[MISURATO]` n=4;
  - 🟢 **lo spread cambia regime alle 21:00**: `D30EUR` mediana **1,60** per le
    ore 07-20, **2,80** dalle 21 (`SPREAD_VIVO_2026-09-12_orario.csv`, n≈3.580
    campioni/ora, GG=5).
- **`U30USD`, `NASUSD` → W = 1380 min** = 24h meno **l'ora 22**, che il
  referto spread misura come *«solo campioni scartati (mercato fermo)»* su
  tutti e quattro gli indici. Prova che l'overnight **conta** su questi
  simboli: le coppie infragiornaliere mostrano crescita reale
  (`U30USD 19/08: 04:00 = 444 → 14:00 = 314`, rapporto 0,707 ·
  `NASUSD 30/07: 00:00 = 1090,1 → 14:33 = 614,5`, rapporto 0,564).

### 🎯 IL CONFRONTO — due simboli, due TF, due leggi

| simbolo · TF | **MISURATO** | **legge di casa** (den. 1440) | errore | 🟢 **legge finestra attiva** | errore |
|---|---:|---:|---:|---:|---:|
| **`D30EUR` H4** | **139,7** (n=3) | 103,1 | 🔴 **−26,2%** | 🟢 **140,1** (W=780) | 🟢 **+0,3%** |
| **`U30USD` H1** | **78,0** (n=5, vivo) | 🟢 77,5 | 🟢 **−0,7%** | 79,1 (W=1380) | +1,5% |
| **`U30USD` H1** | 88,2 (n=33, backtest R112) | 77,5 | −12,2% | 79,1 | −10,3% |

👉 **La legge di casa NON è sbagliata: è incompleta.** Sul Dow `W ≈ 1440` è
giusto per costruzione (CFD quasi 24h) e l'errore è −0,7%. Sul DAX `W = 1440` è
**falso** (il DAX fa il suo range nella cassa) e l'errore è −26,2%.
**Nessun parametro è stato adattato**: 780 e 1380 escono dalla struttura di
sessione, misurata prima.

### 🔬 Robustezza della `W` del DAX, perché un numero fittato non vale niente
| W provata | da dove | ATR(H4) predetto | errore vs 139,7 |
|---|---|---:|---:|
| 720 (08:00-20:00) | cassa stretta | 145,8 | +4,4% |
| 🟢 **780 (08:00-21:00)** | **coppie infragiornaliere + spread** | **140,1** | 🟢 **+0,3%** |
| 840 (07:00-21:00) | spread stretto da 07:00 | 135,0 | −3,4% |
| 1440 | legge di casa | 103,1 | 🔴 −26,2% |
👉 Su tutta la forbice plausibile **720-840** l'errore sta in **−3,4% … +4,4%**;
il **1440 è fuori scala**. La conclusione non dipende dalla scelta fine di W.

### 🔬 E un secondo controllo sul DAX, su un sottocampione contemporaneo
I 3 eventi di `771501` sono del **21-24 luglio**. L'ancora **del solo luglio**
(n=17 giornate) è **269,0** ⟹ ATR(H4) = **149,2** ⟹ **+6,8%** sul misurato.
👉 **Margine dichiarato sulla legge: ±7%**, non ±0,3%.

---

## 5. 🚫 PERCHÉ IL MAX-PER-DATA **NON VA «DE-TRONCATO»** — due correzioni provate e BOCCIATE dalla misura

Il mandato chiede di stimare il «tetto». L'ho fatto in due modi, e **la misura
li rifiuta entrambi**. È il risultato più controintuitivo del referto.

| stimatore provato | `D30EUR` H4 vs 139,7 | `U30USD` H1 vs 78,0 | esito |
|---|---:|---:|---|
| 🟢 **E1 — mediana max-per-data GREZZA** (n=52 / n=24) | 🟢 **+0,3%** | 🟢 **+1,5%** | ✅ **adottato** |
| E3 — media invece di mediana (n=52 / n=24) | +0,5% | +2,4% | quasi equivalente |
| E2 — solo le date che partono entro l'apertura (n=23 / n=13) | 🔴 **+22,2%** | +6,9% | ❌ **bocciato** |
| E4 — de-troncatura per-data `R × √(T/W_effettiva)` (n=52 / n=24) | +5,4% | 🔴 **+34,5%** | ❌ **bocciato** |

🎯 **E1 vince su TUTTI E DUE i simboli**, ed è l'unico: E2 e E3 ed E4 stanno
sempre **sopra** E1, e i due tentativi di correzione sbagliano ciascuno di
molto su **un** simbolo (E2 sul DAX, E4 sul Dow). Non c'è nessuna scelta di W
che salvi E2 o E4 su entrambi.

### 🧠 Perché le de-troncature sbagliano — la causa, non solo il numero
🔴 **`R_d` e l'ora del primo trade NON sono indipendenti.** Le giornate in cui
le sedie entrano **tardi** sono le giornate in cui **non era successo niente
presto**: de-troncarle col √T le gonfia di un fattore che presuppone
un'agitazione che quel giorno non c'era. È **auto-selezione**, e il segno
dell'errore (`+` su tutte e due le validazioni) è la sua firma.

### 📉 Quanto manca davvero davanti, misurato sulle coppie infragiornaliere (non distorte)
| simbolo | rapporto `range[apertura sessione→EOD] / range[pre-sessione→EOD]` | mediana |
|---|---|---:|
| `D30EUR` | **1,000 · 1,000 · 1,000 · 1,000** (n=4) | 🟢 **1,000 → manca 0%** |
| `U30USD` | 0,707 · 0,918 · 1,000 (n=3) | 0,918 → manca ~8% |
| `NASUSD` | 0,564 · 0,802 · 0,888 (n=3) | 0,802 → manca ~20% |

👉 **Sul DAX il max-per-data non è un pavimento: è la misura.** Sugli indici USA
manca qualcosa (8-20% sulla mediana, n=3 per simbolo), **ma correggerlo
peggiora la predizione**, perché quel che manca è già assorbito nella `W`
calibrata sulla struttura di sessione. **La correzione giusta era la finestra,
non l'ancora.**

---

## 6. 💵 GLI SPREAD — e 🔴 **un disaccordo di casa che decide da solo il p95 del DAX**

Fonte designata: `data/spread_vivo/SPREAD_VIVO_2026-09-12_orario.csv` +
`..._referto.txt` (ABTG_SpreadLogger, passo **5 s**, 650.484 campioni validi,
primo 04/09 21:54 → ultimo 11/09 21:50 server).

| simbolo | ora | mediana | p95 | max | campioni | GG |
|---|---:|---:|---:|---:|---:|---:|
| `D30EUR` | **08** | **1,60** | **1,70** | 1,70 | 3.596 | 5 |
| `D30EUR` | 21 | 2,80 | 2,80 | 2,80 | 2.064 | 6 |
| `U30USD` | **14** | **3,00** | **3,00** | 9,00 | 3.578 | 5 |
| `U30USD` | 15 | **2,00** | 3,00 | 8,00 | 3.529 | 5 |
| `U30USD` | 17 | 2,00 | 3,00 | 11,00 | 3.600 | 5 |
| `NASUSD` | **14** | **1,80** | **1,90** | 1,90 | 3.578 | 5 |
| `NASUSD` | 15 | 1,80 | 1,90 | 3,80 | 3.538 | 5 |

### 🔴 `[NON MISURATO]` — lo spread di CODA del DAX all'ora 08: due valori di casa, **entrambi scritti**
| fonte | metodo | ora 08 mediana | ora 08 **p95** | ora 08 max |
|---|---|---:|---:|---:|
| `SPREAD_VIVO_2026-09-12_orario.csv` | **polling 5 s**, n=**3.596**, GG=5 | **1,60** | **1,70** | **1,70** |
| `I_QUATTRO_INVISIBILI_2026-09-12.md` **r.298** | **a TICK**, n=**1.847.049** a quell'ora | **1,70** | 🔴 **2,70** | **12,00** |

- 🟢 **Sulla MEDIANA concordano** entro 0,10 (1,60 vs 1,70): uso **1,70**, la
  peggiore. Nessun verdetto di mediana dipende da questa scelta.
- 🔴 **Sul p95 differiscono di un fattore 1,59, e il 40× del DAX si decide
  lì.** Un picco di spread che dura meno di 5 secondi è **invisibile** al
  polling: per la coda la misura a tick è la più credibile, ma **non ho il file
  sorgente di quella misura in repo** e non posso verificarla. 👉 **Verdetto al
  p95 sul DAX = `[NON MISURATO]`**, con i due esiti opposti scritti (§8).

### ⚠️ E un secondo rilievo di spread, che tocca `CANCELLO_COSTO_FLOTTA` (non l'ancora)
Il referto del 10/09 usa `U30USD` = **2,00 (ora 14)** per `770611`. Il file del
12/09 misura l'ora 14 a **3,00** di mediana (2,00 comincia dall'ora 15).
🔴 Lo `stop/spread` di `770611`, che apre su range **14:30-14:45**, passa così
da **29,5×** a **19,7×**. Il verdetto (**🔴 NO**) **non cambia**, ma il numero
sì. 🚫 **Non è una correzione d'ancora: la segnalo e non la propago.**

### `[NON CALCOLABILE]`
`SPXUSD`, `F40EUR`, `E35EUR`, `E50EUR`, `100GBP`, `200AUD`: **nessuno spread
misurato** (il file ne ha otto: `225JPY · D30EUR · EURUSD · GBPUSD · NASUSD ·
U30USD · USDJPY · XAUUSD`). Per loro il cancello è `[NON CALCOLABILE]` —
**non «escluso per costo»**. Per `225JPY` lo spread c'è (35 / 22-23 idx) ma
l'ancora è `[SOTTILE]` (n=9): la riga si scrive, il verdetto resta sospeso.

---

## 7. 🕐 IL FATTORE D'APERTURA, **MISURATO PER SIMBOLO** — e la trappola del doppio conteggio evitata

`ROUND_ORB_ATR_PS5_2026-09-10.md` **r.243-245** usa un fattore d'amplificazione
d'apertura **3,05**, ricavato come `58,7 / 19,0` dove il **19,0 nasce
dall'ancora rotta** (`186,5 × √(15/1440)`).

🔴 **Questa è la trappola del «si corregge una volta sola» nella sua forma più
pura**: il 3,05 **aveva già assorbito** l'errore d'ancora. Chi corregge
l'ancora **e tiene il 3,05** conta l'errore due volte. I fattori qui sotto sono
**tutti ricalcolati sull'ancora e sulla legge nuove**.

E non serve inferirli: i `Studio_*.csv` li **misurano** (un EA di studio che
ricostruisce il range dei primi 15' giorno per giorno,
`mql5/Experts/ABTG_Apertura_Study_EA.mq5` r.29 `InpRangeMinutes = 15`).

| simbolo | apertura | **range 15' d'APERTURA misurato** | n giornate | 15' generico (legge nuova) | **fattore** |
|---|---|---:|---:|---:|---:|
| `D30EUR` | 08:00 | **54,6 idx** | **440** | 35,0 | **1,56×** |
| `U30USD` | 14:30 | 🟢 **119,8 idx** | **446** | 39,6 | **3,03×** |
| `NASUSD` | 14:30 | **75,3 idx** | **447** | 40,1 | **1,88×** |
| `SPXUSD` | 14:30 | 12,8 idx | 444 | 6,3 | 2,02× |
| `F40EUR` | 08:00 | 20,7 idx | 443 | 8,9 | 2,33× |
*(tutti `[MISURATO]`, mediana di `ampiezza_pt`/100; i riepiloghi confermano
apertura e `buffer 200 / slippage 100`.)*

👉 **Il fattore è SPECIFICO DEL SIMBOLO** (1,56 DAX · 1,88 Nasdaq · 3,03 Dow):
trasportare il 3,05 del DAX sul Dow, come fece R125, ha funzionato **per caso**.

### 🎯 E la misura del Dow ha una CONFERMA INDIPENDENTE, che vale come contro-esempio
`770611` (ORB, `HALFRANGE` = **0,5 × range 14:30-14:45**, buffer **0** in tutti
e due i preset) ha stop **59,0 `[MIS]` n=7**.
- `Studio_U30USD.csv` predice `0,5 × 119,8 = **59,9**` → **−1,5%** dal misurato.
- E all'inverso: il 59,0 misurato implica un range di **118,0**, contro i
  **119,8** dello Studio.
👉 **Due fonti che non si parlano** — un tester su **446 giornate** e **7 gambe
vive** — **convergono all'1,5%**. Il vecchio `[INF]` dava **97,9**: sbagliava
del **−18%**.

---

## 8. 💰 IL CANCELLO DI COSTO, RIGA PER RIGA — chi cambia verdetto

Soglie di casa: **40×** (lavoro) · **13,3×** (pavimento duro).
🔴 **Solo le righe costruite sull'ancora vecchia** (`[INF]` / `[NM]`). Le righe
`[MIS]` non le tocco.

### 📊 ATR(14) con ancora e legge nuove — la tabella di scala

| simbolo | W | **M15** | **M30** | **H1** | **H4** | tag |
|---|---:|---:|---:|---:|---:|---|
| **`D30EUR`** | 780 | **35,0** | **49,5** | **70,0** | **140,1** | `[DERIVATO]`, legge validata **sul simbolo stesso a H4 (+0,3%)** |
| **`U30USD`** | 1380 | **39,6** | **56,0** | **79,1** | **158,3** | `[DERIVATO]`, legge validata **sul simbolo stesso a H1 (+1,5%)** |
| **`NASUSD`** | 1380 | **40,1** | **56,7** | **80,2** | **160,4** | 🔴 `[INFERITO]` — **nessun ATR misurato su NASUSD** |
| `225JPY` | 1380 | 82,7 | 116,9 | 165,4 | 330,7 | 🔴 `[INFERITO]` + ancora `[SOTTILE]` n=9 |

### 🚦 LE CELLE CHE CAMBIANO VERDETTO

| sedia | simb · TF | geometria | stop VECCHIO | stop NUOVO | spread | `stop/spr` vecchio → **nuovo** | **DA → A** |
|---|---|---|---:|---:|---:|---|---|
| **`771321`** | `U30USD` H1 | `ATR(14) H1 + 0,05` | ~65 `[INF]` | 🟢 **78,05 – 88,25 `[MISURATO]`** | 2,00 | 32,5× → **39,0 – 44,1×** | 🔴 **NO (81%)** → 🟠 **FRAGILE** |
| **`770250`** | `NASUSD` M15 | `SL_RANGE` su candela H1 prec. + buffer 3 | ~67 `[INF]` | **83,2 `[INFERITO]`** | 1,80 | 37,2× → **46,2×** | 🟡 **NO (93%)** → 🟢 **PASS (+16%)** |
| **`770202`** | `U30USD` M5 | `SL_RANGE` range 15' + 2×2 idx | ~102 `[INF]` | 🟢 **123,8 `[MISURATO]` n=446** | 3,00 (p95/ora 14) | 34,0× → **41,3×** | 🔴 **NO al p95** → 🟢 **PASS (+3%)** |
| **`770411`** | `D30EUR` M15 | `2,5 × ATR(14) M15` | `[NM]` | **64,2 – 87,5** 🔴 `[NON MISURATO]` | 1,70 | `[NM]` → **37,8 – 51,5×** | ⚪ **NM** → 🟠 **FRAGILE** |
| **`970912`** | `D30EUR` H4 | swing 5 barre H4 | ~170 `[INF]` | **112 – 313** | 1,70 | ~100× → **65,8 – 184×** | 🟢 **PASS** → 🟢 **PASS** *(numero riscritto)* |
| `770611` ↳ | `U30USD` M5 | sub-riga *«~47 `[INF]` da R125»* | ~47 `[INF]` | — | — | — | 🔴 **DA RITIRARE**: superata dal `[MIS]` 59,0 e dallo Studio (59,9) |

🟢 **Nessuna cella PEGGIORA per effetto dell'ancora. Nessuna esclusione si
ribalta in esclusione più dura.** La direzione attesa dal mandato è
**confermata — verificata, non assunta.**

### Dettaglio delle quattro celle, con le code

| cella | stop | /mediana | 40×? | /coda | 40×? | duro 13,3× |
|---|---:|---:|---|---:|---|---|
| `771321` `U30USD` H1 | 78,05-88,25 | **39,0-44,1×** (2,00) | 🟠 **FRAGILE** — la soglia cade **dentro** la banda | 26,0-29,4× (3,00) | 🔴 NO (65%) | 🟢 SI |
| `770250` `NASUSD` M15 | 83,2 | **46,2×** (1,80) | 🟢 **PASS (+16%)** | **43,8×** (p95 1,90) | 🟢 **PASS (+9%)** | 🟢 SI |
| `770202` `U30USD` M5 | 123,8 | **61,9×** (2,00, ora 15) | 🟢 **PASS (+55%)** | **41,3×** (3,00) | 🟢 **PASS (+3%)** | 🟢 SI |
| `770411` `D30EUR` M15 | 64,2-87,5 | **37,8-51,5×** (1,70) | 🟠 **FRAGILE** — la soglia cade **dentro** la banda | 23,8-32,4× (2,70 tick) | 🔴 NO (60-81%) | 🟢 SI |
| `970912` `D30EUR` H4 | 112-313 | **65,8-184×** (1,70) | 🟢 **PASS (+64%)** | **41,4-116×** (2,70 tick) | 🟢 **PASS (+4%)** | 🟢 SI |

### 🔴 D — E QUI HO DOVUTO BOCCIARE DUE COSE MIE
Il contro-esempio serve a rompere la propria risposta, e ha rotto due pezzi:

**(a) `770250`: il mio «pavimento MISURATO 75,3» NON REGGE, e l'ho ritirato.**
Avevo argomentato che la candela H1 precedente contiene l'apertura 14:30,
quindi `stop ≥ 75,3 + 3 = 78,3 [MIS]` → 43,5×. **Falso.** Il codice
`mql5/Experts/ABTG_Nasdaq_Apertura_US.mq5` **r.909-915** legge
`iHigh(_Symbol, InpLevelTF, 1)` = **l'ultima candela CHIUSA**, e l'armamento
cade a `openMin` (**r.744**, `refEndMin = openMin` per `PREVBAR`): alle 14:30 la
candela chiusa su H1 è la **13:00-14:00**, che **non contiene l'apertura**.
👉 Il numero giusto è l'ATR(H1) generico: **80,2 `[INFERITO]` + 3 = 83,2**. Il
verdetto (**PASS**) non cambia, ma **il tag scende da `[MIS]` a `[INF]`** e va
detto. *(preset verificato: `mql5/presets/ABTG_GatedShort_NASUSD_770250_LIVE.set`
→ `InpSessionHour=14` · `InpSessionMin=30` · `InpRangeMode=2` ·
`InpLevelTF=16385` · `InpBufferPoints=300` · `InpSLMode=0`. Con la lettura
`range + 2×buffer` lo stop sale a 86,2 → 47,9× — **PASS in tutte e due le
letture**.)*

**(b) `770411`: l'«`ATR(14) M15 ≥ 22,0`» del referto 17/09 NON SEGUE DAI DATI.**
Quel referto (§4) ricava `55,0 ≤ 2,5 × ATR` dalla gamba del **20/08**. Ma quella
gamba è una **SELL** con `open 26043,80 → close 25988,80`, **profit +78,32**:
l'uscita è **55,0 punti DALLA PARTE DEL GUADAGNO**, cioè un **trailing** (il
preset porta `InpBreakeven=true` e `InpUseTrailing=true` con
`InpTrailAtrMult=2.0`). Lo stop iniziale di una SELL sta **SOPRA** l'ingresso:
dalla distanza di un'uscita in profitto **non si ricava nessun limite inferiore
sull'ATR**.
🔴 **E tutte e quattro le gambe `sl` di `770411` sono in PROFITTO**
(+25,35 · +78,32 · +1,20 · +33,13): **zero stop pieni**. Quindi:
- la frase di `CANCELLO_COSTO_FLOTTA` r.408 *«0 gambe in stop»* era **giusta
  nella sostanza** (0 stop pieni) e la «correzione» del 17/09 era giusta solo
  sul `close_reason` letterale;
- `770411` **resta `[NON MISURATO]`**. 🔴 **Senza quel pavimento la banda non
  ha più un estremo basso MISURATO**: la scrivo fra le **due leggi**, non fra
  due misure — `ATR(M15) ∈ [25,7 (legge 1440, referto 17/09) … 35,0 (legge
  W=780)]` ⟹ stop `∈ [64,2 … 87,5]` ⟹ **37,8 – 51,5×**, 🟠 **FRAGILE**.
  🚫 **Non lo promuovo a PASS**, anche se la legge nuova da sola darebbe 51,5×.
- ⚠️ **E un limite in più, dichiarato**: la sedia entra alle **08:01-08:27**, e
  `ATR(14) M15` in quel momento media le **14 barre precedenti** = circa
  **04:45-08:00**, cioè il DAX **fuori cassa** — dove abbiamo *misurato* che il
  range non si costruisce (§4). Il mio 35,0 è una media di sessione: sul
  **valore all'apertura** è quasi certamente **un tetto, non una stima**.

### ✏️ E la tabella DAX del referto 17/09 (§5) è **superata**, di un fattore 1,36
| grandezza | 17/09 (den. 1440) | 🟢 **ora (W=780)** | fattore |
|---|---:|---:|---:|
| `ATR(14) D30EUR` **M15** | 25,7 – 29,2 | **35,0** | ×1,360 |
| `ATR(14) D30EUR` **M30** | 36,4 – 41,4 | **49,5** | ×1,360 |
| `ATR(14) D30EUR` **H1** | 51,5 – 58,6 | **70,0** | ×1,360 |
| ATR necessari per il 40× su **M30** | 1,64-1,87 | **1,37** | — |
| ATR necessari per il 40× su **M15** | 2,33-2,65 | **1,94** | — |
| **M30 a 1,5 ATR** | 32,1-36,5× 🔴 NO | **43,7×** 🟢 **PASS (+9%)** | — |
| **M30 a 2,0 ATR** | 42,8-48,7× 🟢 PASS | **58,3×** 🟢 PASS (+46%) | — |

### 🔴 E il «numero scomodo» del 17/09 — **resta scomodo, ma è `[NON MISURATO]`**
Alla **coda a tick 2,70** (soglia: stop ≥ 108,0 idx) **nessuna cella viva del
DAX passa il 40×**: `M30 a 2 ATR` fa **36,7×** (92% della frontiera) e
`M15 a 2,5 ATR` fa **32,4×** (81%).
🟢 Alla **coda da polling 1,70** passano **tutte** (51,5× e 58,3×).
👉 **Il verdetto di coda sul DAX dipende interamente da quale delle due misure
di casa è giusta** (§6). Finché non si riconcilia: `[NON MISURATO]`, con
entrambi gli esiti scritti. **Non scelgo il più comodo.**

---

## 9. ✏️ LE CORREZIONI CHE DEVO AD ALTRI REFERTI (da applicare a loro, non da me)

| referto · riga | cosa dice | cosa va scritto |
|---|---|---|
| `ATR_DAX_M30_RICONCILIAZIONE_2026-09-17.md` §3 e mandato | *«al max-per-data manca il tratto fra l'ULTIMO trade e la campanella»* | 🔴 **il tronco è DAVANTI, non dietro**: `ABTG_TradeExporter.mq5` r.84-85 porta `to = 23:59`. 35/35 date lo confermano |
| idem §4 | `ATR(14) M15 ≥ 22,0 [DERIVATO da MISURATO, n=1]` | 🔴 **non segue**: la gamba 20/08 è un'uscita in **profitto** (+78,32), non uno stop |
| idem §4/§5 | `ATR M30 36,4-41,4` · `M15 25,7-29,2` | 🟢 **×1,360** → **49,5** e **35,0** (legge sulla finestra attiva) |
| idem §7 buco 2 | *«legge √T validata su UN SOLO simbolo»* | 🟢 **ora due**: `D30EUR` H4 +0,3% e `U30USD` H1 −0,7% |
| `CANCELLO_COSTO_FLOTTA_2026-09-10.md` r.408 · coda | `770411` *«0 gambe in stop»* / *«la frase era FALSA»* | 🟡 **era giusta nella sostanza**: 4 gambe `sl`, **tutte in profitto** = 0 stop pieni |
| idem r.406 | `970912` `~170 idx [INF]` | 🔴 numero da riscrivere: **313** (ricetta, ancora nuova) o **~112** (ricetta corretta col 2,8× della riga sorella). Verdetto PASS invariato |
| idem, spread `770611`/`770202` | `2,00 (ora 14)` | 🟡 il file 12/09 misura l'**ora 14 a 3,00** (il 2,00 parte dall'ora 15) |
| `ROUND_ORB_ATR_PS5_2026-09-10.md` r.243-245 | fattore d'apertura **3,05** trasportato dal DAX | 🔴 **è specifico del simbolo**: DAX **1,56** · Nasdaq **1,88** · Dow **3,03** `[MIS]` n=440-447. E il 3,05 **aveva assorbito** l'errore d'ancora: non si somma alla correzione |
| `EMA200_I_DUE_REQUISITI_2026-09-12.md` r.182 | *«la legge ancorata all'ADR sottostima del 18-27%»* | 🟢 **causa trovata e chiusa**: era l'aggregazione min-per-data. 🔴 **Non va più aggiunta a nulla** |

---

## 10. 🕳️ I BUCHI, DICHIARATI

1. 🔴 **`NASUSD` non ha nessun ATR misurato.** Tutta la sua colonna è
   `[INFERITO]` con una legge validata su **altri due** simboli. Il validatore
   proposto dal mandato (`970913`, 51,65) **non è un ATR** ed è escluso da un
   contro-esempio (§3).
2. 🔴 **La `W` di `NASUSD` (1380) è per analogia col Dow**, non misurata.
3. 🔴 **Lo spread di coda del DAX all'ora 08 è `[NON MISURATO]`**: 1,70
   (polling, n=3.596) contro 2,70 (tick, n=1.847.049). **Decide il 40× di tutto
   il DAX in coda** e non ho il file sorgente della misura a tick.
4. 🔴 **`ATR(14)` non è MAI stato letto direttamente** su nessun TF: i miei due
   `[MISURATO]` sono **distanze di stop** con geometria `k × ATR` invertita.
   Solidi (rapporto 1,45/1,50 confermato alla quarta cifra) ma **indiretti**.
5. 🔴 **Il margine vero della legge è ±7%**, non ±0,3%: il sottocampione di
   luglio del DAX dà **+6,8%**.
6. 🟡 **`225JPY` `[SOTTILE]` (n=9)**, `SPXUSD` (n=2) e `F40EUR` (n=1)
   **non citabili**. `E35EUR`/`E50EUR`/`100GBP`/`200AUD`: nessuna ancora e
   nessuno spread → `[NON CALCOLABILE]`.
7. 🟡 **L'ATR all'APERTURA non è l'ATR di sessione.** Per le sedie che entrano
   all'08:00-08:30 sul DAX (`770411`, `770101`, `770111`, `770311`) l'ATR(14)
   del momento pesa **barre fuori cassa**: i miei numeri sono **tetti**. Non
   misurato, e non aggirabile con l'ancora.
8. ⚪ **L'ancora copre apr-set 2026** (52/24/26 giornate). Un regime, niente
   prova di regime — Emendamento C non applicato.
9. ⚪ `Studio_*.csv` è a **15 minuti**: il range d'apertura a 30' resta non
   misurato su tutti i simboli.

---

## 11. 🧾 CHE COSA NON HO FATTO
🚫 Nessun backtest, nessuna ottimizzazione, nessun EA, nessun preset, nessun
file prova, nessuna riga di coda, nessuna riga di lancio, nessun terminale
toccato. 🚫 **Conto reale `10105439` non toccato**; nessun commento su taglie o
parametri di rischio. 🚫 **Nessun candidato archiviato e nessuno promosso**:
tutte le sedie citate sono **fonti di numeri**, non oggetti di giudizio.
🚫 Non ho riscritto `CANCELLO_COSTO_FLOTTA_2026-09-10.md` né il referto del
17/09 (§9 dice cosa cambiare; la penna è di Claudio).

---

## 📚 FONTI (file + riga)
- `data/statements/trades_auto.csv` — 1.319 gambe; indici: `D30EUR` 166 (52 gg) · `U30USD` 74 (24 gg) · `NASUSD` 61 (26 gg) · `225JPY` 11 (9 gg) · `SPXUSD` 2 · `F40EUR` 2
- `data/statements/trades_100k.csv` — 35 gambe, **0 giornate nuove**
- `data/spread_vivo/SPREAD_VIVO_2026-09-12_orario.csv` · `..._referto.txt` — spread `[MIS]`, 8 simboli, 650.484 campioni
- `backtest_pipeline/risultati_archivio/studio_apertura/Studio_{D30EUR,U30USD,NASUSD,SPXUSD,F40EUR}.csv` + `_RIEPILOGO` — range 15' d'apertura `[MIS]` n=440-447
- `mql5/Experts/ABTG_TradeExporter.mq5` r.79-96 (`SessionRange`: `to = 23:59`), r.106
- `mql5/Experts/ABTG_EMA200.mq5` r.49 (`InpTF` default H4), r.68-69, r.74, r.79-80, r.104 (`InpMagic` default **771501**), r.356-358 (geometria), r.258-260
- `mql5/Presets/ABTG_EMA200_H4.set` (`InpTF=16388`, 0.10/0.35) · `ABTG_EMA200_U30USD_H1_771531_VIVA.set` (`InpTF=16385`, 0.2/0.3)
- `mql5/Experts/ABTG_Nasdaq_Apertura_US.mq5` r.178-179, r.744, r.909-915 (`PREVBAR` = ultima candela **chiusa**)
- `mql5/presets/ABTG_GatedShort_NASUSD_770250_LIVE.set`
- `mql5/Presets/ABTG_MaxMinNotte_DAX_Short_Ottimizzato_D30EUR_M15_770411_100K.set`
- `mql5/Experts/ABTG_Apertura_Study_EA.mq5` r.29 (`InpRangeMinutes = 15`)
- `report/CANCELLO_COSTO_FLOTTA_2026-09-10.md` r.385, **r.389 (header: la colonna è `stop`)**, r.393-408, r.292, r.482-485, r.672, coda
- `report/ATR_DAX_M30_RICONCILIAZIONE_2026-09-17.md` §3, §4, §5, §7
- `report/ROUND_ORB_ATR_PS5_2026-09-10.md` r.229-236 (ADR vecchio), r.243-245 (fattore 3,05)
- `report/EMA200_I_DUE_REQUISITI_2026-09-12.md` r.155-160 (ATR H1 misurato tre volte), r.173, r.182
- `report/I_QUATTRO_INVISIBILI_2026-09-12.md` r.298 (spread a tick, 30.974.789 tick)
- `report/PROPOSTA_RELATIVO_TICK_REALI_2026-09-04.md` r.352 (100 punti MT5 = 1 punto indice)
