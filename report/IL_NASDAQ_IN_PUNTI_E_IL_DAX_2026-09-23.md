# 📏 IL NASDAQ IN PUNTI, E IL DAX — **R229**

**23/09/2026** · domanda di Claudio, testuale:
> *«Guarda la strategia sul Nasdaq che hai le slide e proviamo ad applicarla col Dax.
> Per vedere la distanza in punti potresti farla misurare agli agenti. Non so se fa
> 50 punti di media come il Dax.»*

🚫 **Zero minuti macchina, zero MT5, zero righe di lancio.** Tutto misurato sui file
gia' in repo. Claudio e' da cellulare: non deve incollare niente.
🚫 Niente toccato di `770101` e `770260`, che stanno operando adesso.

---

# 🎯 LA RISPOSTA IN QUATTRO RIGHE

> ## 1. **Il DAX fa 55,25 punti indice** di escursione favorevole mediana dopo la rottura d'apertura. **Il «50 punti» di Claudio e' CONFERMATO dai nostri dati BCM**, n=440 giornate.
> ## 2. **Il Nasdaq ne fa 65,00.** Cioe' **+17,6% in punti** — non il doppio, non il quadruplo.
> ## 3. **In percentuale del prezzo i due sono quasi identici: 0,2235% contro 0,2173%, +2,9%.** 👉 Il movimento d'apertura e' **lo stesso fenomeno**, misurato su due strumenti quasi alla stessa quota.
> ## 4. 🔴 **MA il trasferimento NON e' una riscalatura**, e il contro-esempio lo rompe in tre punti (§5). Il piu' caro: **sul DAX lo stop d'apertura fa 36,7 × spread e NON passa il cancello dei 40×; sul Nasdaq fa 44,8 × e passa.**

🔴 **E una premessa del mandato era sbagliata, va corretta subito**: *«il Nasdaq vale
~4x il DAX in valore d'indice»*. **Falso nel 2026.** Prezzi mediani dei nostri
ordini veri (`data/statements/trades_auto.csv`, apr-set 2026): **Nasdaq 29.089 ·
DAX 25.431 → rapporto 1,144**. Era vero anni fa, non e' vero oggi (**classe 638**).

---

# 1. 📜 LA STRATEGIA DEL NASDAQ IN REGOLE E NUMERI, ciascuno con la fonte

Fonte primaria: **`docs/live_emiliano/c05566f8-Piano_Trading__NASDAQ__ABTG.pdf`**,
9 pagine, Alfio Bardolla Training Group. Estratto con `pymupdf` (in repo non c'e'
`pdftotext`; `pypdf` e' rotto su questa macchina — `_cffi_backend` mancante).

| # | regola | numero | fonte |
|---|---|---|---|
| R1 | Time frame operativo | **M15** | PDF p.2 §4a |
| R2 | Canale di riferimento = MAX/MIN dei **15 minuti PRIMA** dell'apertura USA | 15:15-15:30 o 15:25-15:30 CET | PDF p.3 §4b |
| R3 | Ordini pendenti **BUY STOP sopra il massimo / SELL STOP sotto il minimo** | **+7 … +10 punti** | PDF p.4 §4d |
| R4 | Stop loss a distanza fissa **dal livello dell'ordine pendente** | **5 punti** | PDF p.4-5 §4e |
| R5 | Break-even obbligatorio a | **+30 punti** di profitto | PDF p.5 §4e |
| R6 | Rapporto rischio/rendimento minimo | **1:2** | PDF p.2 §3b · p.5 §4f |
| R7 | Ostacoli tecnici da valutare entro | **10-15 punti** dall'ingresso | PDF p.3 §4c |
| R8 | Size ridotta se c'e' un ostacolo | **¼ o ⅓** | PDF p.4 §4d |
| R9 | **Cancellazione dei pendenti non eseguiti** | dopo la **prima mezz'ora** | PDF p.5 §4g |
| R10 | Parzializzazione al 1° target + stop in pari | **50%** | PDF p.5 §4h.1 |
| R11 | Poi trailing tecnico (minimi crescenti / EMA 14-50-100 M5-M15 / Supertrend) | — | PDF p.6 §4i.1 |
| R12 | Money management | **2%** per operazione, **DD max 4%** | PDF p.2 §3a, §3c |
| R13 | Cancello prima del reale | **>70% win rate su >=30 operazioni** in demo | PDF p.8 §5 |

## 🔴 1.1 — CHE COSA SONO DAVVERO I «7 PIPS» E I «50 PUNTI»

### ✅ I «7 pips» ESISTONO, e sono la **R3**
Claudio ricorda bene: le slide dicono **+7 … +10 punti oltre il livello**. Non e'
la distanza *fra* i due pendenti (quella e' ampiezza del range + 2 × buffer).
🟠 **Ma la macchina non ne mette 7**: il commento nel motore condiviso dice *«700 =
7 punti indice»*, il **default compilato del Nasdaq e' 200 = 2,00 punti indice**, e
il preset FTMO vivo `770260` conferma **`InpBufferPoints=200`**. Sul DAX `770101`
gira a **`InpBufferPoints=500` = 5,00 punti indice**.
👉 Fonte del confronto riga per riga: `report/LA_STRATEGIA_NASDAQ_DEI_COLLEGHI_2026-09-18.md`.

### 🔴 I «50 punti» NON sono nelle slide del Nasdaq. **Sono del DAX — e adesso sono MISURATI.**
Nelle slide del Nasdaq il numero 50 **non compare come bersaglio**: il primo target
e' definito per rapporto (RR >= 1:2), non in punti.
Il 50 viene dalle **live sul DAX** (Emiliano 14/09: *«50 punti al giorno»*; 18/09:
*«quasi 50 punti»*; Paolo 28/04: *«parzializzo dopo 40-50 punti»*).
🟢 **E il 09/23 possiamo finalmente dire se e' vero: SI'.** Sul DAX l'escursione
favorevole mediana dopo la rottura d'apertura e' **55,25 punti indice** su **440
giornate BCM a tick** (§3). Claudio aveva ragione, con uno scarto del **+10,5%**
sulla sua regola del pollice.

### 🔴 1.2 — E I NUMERI DELLE SLIDE NON SONO PUNTI INDICE DI UN INDICE DEL 2026
Due prove, e vanno dette insieme al numero:

**(a) Il cancello di costo li polverizza.** Uno stop da **5 punti indice**:

| simbolo | spread mediano all'apertura | stop 5,00 idx = | serve per **40×** | pavimento duro **13,3×** | esito |
|---|---:|---:|---:|---:|---|
| `NASUSD` | 1,80 idx | **2,8 ×** | 72,0 idx | 23,9 idx | 🔴 **NON PASSA** (fuori di 14,4 volte) |
| `D30EUR` | 1,60 idx | **3,1 ×** | 64,0 idx | 21,3 idx | 🔴 **NON PASSA** (fuori di 12,8 volte) |

*(spread: `data/spread_vivo/SPREAD_VIVO_2026-09-12_orario.csv`, ora server 14 per il
Nasdaq e 8 per il DAX, n≈3.580 campioni per secchio.)*

**(b) Le slide si contraddicono da sole.** R4 mette lo stop a **5 punti**; R6 vuole
RR >= 1:2, quindi primo target a **+10 punti**; R5 impone il break-even a **+30
punti** — cioe' a **6R**, **tre volte oltre il target che dovrebbe gia' aver chiuso
meta' posizione**. 👉 Un sistema di numeri che non si chiude su se stesso **non e'
un preset: e' un'illustrazione.**

> ## 🔴 **CONCLUSIONE SULLE SLIDE: i RAPPORTI (buffer oltre il livello, stop dal livello, parziale 50%, RR 1:2, cancellazione a 30') si trasferiscono. I NUMERI ASSOLUTI in "punti" NO — non si sa a quale unita' e a quale quota d'indice si riferiscano, e presi per punti indice del 2026 falliscono il cancello di casa di un ordine di grandezza.** Dove manca la conversione: **`[NON MISURATO]`**, e si legge solo chiedendo agli autori.

### 1.3 — Le unita', dichiarate (classe 598, gia' pagata in casa)
🟢 **`D30EUR`: 2 decimali, 1 punto indice = 100 punti MT5** — `[MISURATO]`,
`data/spread_vivo/SPREAD_VIVO_2026-09-12_referto.txt` r.62, e colonna
`punti_per_unita=100` nel CSV orario.
🟢 **`NASUSD` e `U30USD`: 1 idx = 100 punti MT5** — stessa fonte + colonna
`punti_per_unita=100`, confermato da `ANCORA_ADR_FLOTTA_INDICI_2026-09-18.md` r.105.
👉 **Nessun numero qui sotto e' dedotto: tutti vengono da una colonna o da una riga di referto.**

---

# 2. 🔴 IL CORREGGIMENTO CHE VIENE PRIMA DI TUTTO: le colonne `up5_pt … up60_pt` NON misurano «dopo la rottura»

Il mandato le descriveva come *«quanto si e' esteso il movimento a 5, 15, 30 e 60
minuti **dalla rottura**»*. **Non e' cosi', e l'ho letto nel codice, non nel nome.**

`backtest_pipeline/anatomia_aperture.py` **rr.483-513**, commento testuale dell'autore:
> *«le finestre 5/15/30/60: escursione SU, escursione GIU', e dove chiude la finestra.
> **Tutto DAL PREZZO DI APERTURA**»*

e il calcolo: `up_pt = hi − apertura` dove `hi` e' il massimo dei **primi `w` minuti
dall'apertura**. Quindi `up60_pt` e' *«quanto e' salito il Nasdaq nella prima ora
rispetto al prezzo d'apertura»*, **non** *«quanto ha corso dopo aver rotto»*.
👉 E `up5_pt` e' **inservibile** per la domanda: il range di riferimento si chiude
al minuto **15**, quindi al minuto 5 **non c'e' ancora nessuna rottura** (**classe 637**).

## ✅ Ma il dato si recupera, con un'identita' esatta
Il range di riferimento e' i **primi 15 minuti** (`--finestra-classe 15`, letto nel
referto r.86), quindi:

```
amp_rif_pt  ==  up15_pt − dn15_pt          <- hi_rif e lo_rif, ricostruiti
MFE60_long  =   up60_pt − up15_pt          <- punti OLTRE il massimo rotto
MFE60_short =   dn15_pt − dn60_pt          <- punti OLTRE il minimo rotto
```

🟢 **Verificato, non assunto**: l'identita' `amp_rif_pt == up15_pt − dn15_pt` regge
su **3.899 righe su 3.899**, **zero discordanti** (tolleranza 1e-6).

---

# 3. 📊 LA TABELLA DELL'ESTENSIONE DEL NASDAQ, PER EPOCA

Fonte: `backtest_pipeline/risultati_archivio/ANATOMIA_APERTURE_20260826/ANATOMIA_APERTURE_PERGIORNO_NASUSD.csv`
(4.877 righe; **3.899 `stato=OK`**, 904 senza apertura, 74 sospetti — esclusi).
🔴 **Feed HistData, NON BCM** (dichiarato nel referto della corsa). Vedi §3.2.

**`MFE30` / `MFE60` = punti indice OLTRE il livello rotto**, entro 30 e 60 minuti
dall'apertura (quindi **15 e 45 minuti dopo la chiusura del range**).

### Lato LONG (giorni con `rott_up=1`)

| regime | n | ampiezza 15' (idx) | ampiezza (% prezzo) | **MFE30 idx** | **MFE60 idx** | MFE30 % | **MFE60 %** | **MFE60/ampiezza** |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| 2010-2019 | 1.227 | 13,0 | 0,323% | 2,8 | **6,9** | 0,071% | **0,174%** | 0,542 |
| 2020_covid | 137 | 50,2 | 0,495% | 9,4 | **25,8** | 0,094% | **0,252%** | 0,480 |
| 2021 | 143 | 55,0 | 0,375% | 12,3 | **29,1** | 0,087% | **0,207%** | 0,482 |
| 2022_orso | 139 | 93,1 | 0,708% | 23,5 | **48,1** | 0,190% | **0,383%** | 0,576 |
| **2023-2026** | **456** | **74,6** | **0,383%** | **16,9** | 🟢 **47,2** | 0,091% | **0,236%** | 0,576 |
| *tutti* | *2.102* | *25,4* | *0,368%* | *4,3* | *13,2* | *0,078%* | *0,205%* | *0,542* |

### Lato SHORT (giorni con `rott_dn=1`)

| regime | n | ampiezza 15' (idx) | **MFE30 idx** | **MFE60 idx** | **MFE60 %** | **MFE60/ampiezza** |
|---|---:|---:|---:|---:|---:|---:|
| 2010-2019 | 1.196 | 13,0 | 3,2 | **8,2** | 0,202% | 0,613 |
| 2020_covid | 122 | 55,3 | 15,9 | **34,0** | 0,324% | 0,604 |
| 2021 | 120 | 60,4 | 14,4 | **34,1** | 0,245% | 0,560 |
| 2022_orso | 143 | 91,8 | 20,1 | **52,4** | 0,403% | 0,566 |
| **2023-2026** | **444** | **74,8** | **17,3** | 🟢 **44,2** | **0,226%** | 0,556 |
| *tutti* | *2.025* | *25,0* | *5,0* | *16,0* | *0,227%* | *0,591* |

### 🎯 Quartili del MFE60 long — perche' la mediana da sola inganna

| regime | n | q25 | **mediana** | q75 | q90 |
|---|---:|---:|---:|---:|---:|
| 2010-2019 | 1.227 | 3,8 | **6,9** | 12,7 | 20,8 |
| 2022_orso | 139 | 29,5 | **48,1** | 70,7 | 122,0 |
| **2023-2026** | **456** | **23,4** | **47,2** | **75,3** | **113,8** |
| *tutti* | *2.102* | *5,8* | *13,2* | *33,3* | *68,8* |

> ## 🔴 **PERCHE' LA MEDIA SU 16 ANNI E' UN NUMERO CHE NON DESCRIVE NIENTE**
> Il MFE60 mediano passa da **6,9 punti** (2010-2019) a **47,2** (2023-2026): un
> fattore **6,8**. La riga *«tutti»* dice **13,2** — un valore che **non e' mai
> stato tipico di nessuna epoca**. 👉 Chi progettasse un bersaglio sul 13,2 lo
> starebbe tarando su un Nasdaq a 4.000 punti che non esiste piu'.

## 🟢 3.1 — L'INVARIANTE: il rapporto **MFE60/ampiezza** NON si muove
Mentre l'ampiezza cambia di **7,2 volte** (13,0 → 93,1 punti), il rapporto resta
in **0,48 – 0,58** (long) e **0,56 – 0,61** (short), su **cinque regimi** che
includono il Covid e l'orso 2022.
👉 **Questo e' il numero trasferibile**, non i punti. Ed e' l'unica ragione per cui
una domanda sul DAX puo' avere una risposta.

### 📐 Mediana dei rapporti ≠ rapporto delle mediane — **dichiarato**
Nella colonna `MFE60/ampiezza` ho scritto la **mediana dei rapporti** (giorno per
giorno). Il **rapporto delle mediane** da' numeri diversi, e lo scarto arriva al
**−10,4%** (UP 2022_orso: 0,5763 contro 0,5162) e al **+9,9%** (UP 2021 e 2023-2026).
Sul totale: 0,5415 contro 0,5206 (**−3,9%**).

## 🔴 3.2 — DUE FONTI DI CASA, E NON SONO D'ACCORDO DEL 21,8%
Stessa grandezza (ampiezza del range 15' d'apertura del Nasdaq), stessa numerosita'
(**447 giornate**), due feed:

| fonte | feed | finestra | **mediana ampiezza 15'** |
|---|---|---|---:|
| `ANATOMIA…NASUSD.csv` (ultime 447 giornate OK) | M1 **HistData** | 2024.10.25 → 2026.07.31 | **96,33 idx** |
| `Studio_NASUSD.csv` | **tick BCM** | 447 giornate | **75,30 idx** |
| | | | 🔴 **scarto −21,8%** |

Gia' segnalato il 21/09 (`report/AMPIEZZA_RANGE_NASDAQ_2026-09-21.md`, che misura
93,22 contro 75,30 su una selezione di giorni leggermente diversa: **stessa
direzione, stesso ordine di grandezza**).

> ## 🔴 **CONSEGUENZA OPERATIVA: dell'anatomia HistData si usano i RAPPORTI e la divisione per EPOCA. I PUNTI ASSOLUTI su cui si taglia un preset BCM si prendono da `Studio_*.csv`, e da nessun'altra parte.**

---

# 4. 🇩🇪 IL CONFRONTO COL DAX — **e la sorpresa e' che il dato c'era**

🔴 Il mandato dava per buono che *«`ANATOMIA_APERTURE_PERGIORNO_*.csv` esiste solo
per `NASUSD`»*. **Vero.** 🟢 **Ma esiste una SECONDA famiglia di file che misura la
stessa cosa su tutti e due i simboli, sullo stesso feed, con lo stesso strumento:**

**`backtest_pipeline/risultati_archivio/studio_apertura/Studio_D30EUR.csv` (440 righe)**
e **`Studio_NASUSD.csv` (447 righe)** — prodotti da
`mql5/Experts/ABTG_Apertura_Study_EA.mq5` (`InpRangeMinutes=15`), **tick BCM**,
colonne `ampiezza_pt · MAE_pt · MFE_pt · MAE_R · MFE_R · risultato_R · barre`.
Riepiloghi: `Studio_*_RIEPILOGO.csv` (`apertura 08:00` DAX / `14:30` Nasdaq,
`buffer 200`, `slippage 100`, `TP_R 2.0`).

## 📊 4.1 LA TABELLA MADRE — stesso feed, stesso metodo, stessa finestra

| simbolo | n | prezzo mediano | **ampiezza 15' idx** | ampiezza % | **MFE idx** | **MFE %** | stop implicito idx |
|---|---:|---:|---:|---:|---:|---:|---:|
| **`D30EUR`** | 440 | 25.431 | **54,65** | 0,2149% | 🟢 **55,25** | **0,2173%** | 58,66 |
| **`NASUSD`** | 447 | 29.089 | **75,30** | 0,2589% | 🟢 **65,00** | **0,2235%** | 80,62 |
| `U30USD` | 446 | 53.450 | 119,75 | 0,2240% | 95,10 | 0,1779% | 125,32 |

*(prezzi: mediana di `open_price` degli ordini veri in `data/statements/trades_auto.csv`,
apr-set 2026, n=167 DAX / 62 Nasdaq / 76 Dow. Unita' idx = `ampiezza_pt`/100.)*

> ## 🎯 **LA RISPOSTA ALLA DOMANDA DI CLAUDIO**
> | | in **PUNTI INDICE** | in **% DEL PREZZO** |
> |---|---:|---:|
> | DAX | **55,25** | **0,2173%** |
> | Nasdaq | **65,00** | **0,2235%** |
> | **il Nasdaq fa** | 🟠 **+17,6%** | 🟢 **+2,9%** |
>
> 👉 **Cambia molto quale unita' si guarda: in punti il Nasdaq e' un sesto piu'
> generoso, in percentuale sono lo stesso strumento.** E siccome un preset si
> scrive in **punti**, il +17,6% e' quello che va rifatto nei numeri.

## ⚠️ 4.2 I QUATTRO LIMITI DI QUESTA TABELLA, detti prima di usarla
1. 🔴 **Il MFE e' TRONCATO a 2R** (`TP_R=2.0`): quando il trade chiude a target,
   l'escursione smette di essere misurata. **Al tetto ci arriva il 30,0% dei giorni
   sul DAX, il 24,4% sul Nasdaq, il 27,8% sul Dow.** 👉 Quindi **la mediana e' salva**
   (meno del 50% e' censurato) **ma q75 e q90 NON SONO CITABILI**: il q75 del DAX
   (116,58) coincide col tetto (2 × 58,66 = 117,3). **In questo referto uso solo la mediana.**
2. **La finestra e' 15 minuti**, mentre le due sedie vive girano `InpRangeMinutes=35`.
   L'ampiezza a 35' **non e' misurata per il DAX**: `[NON MISURATO]`.
3. **L'orizzonte e' l'intero trade, non 60 minuti**: durata mediana **90 minuti
   (DAX)** e **55 (Nasdaq)**; entro 60 minuti chiude il **41,4%** dei trade DAX e il
   **52,6%** dei Nasdaq. 👉 **Per questo `MFE/ampiezza` qui vale 0,86 (Nasdaq) mentre
   l'anatomia a 60 minuti dava 0,54: sono due orizzonti diversi, non due misure in
   disaccordo.** La direzione e' quella giusta (piu' tempo = piu' escursione).
4. **Lo Studio e' un breakout CIECO** con aspettativa ≈ 0 (`aspettativa_R` 0,026 DAX /
   0,001 Nasdaq). 🔴 **Non e' un edge e non va letto come tale**: e' un righello
   dell'ampiezza del movimento, niente di piu'.

### ✅ Contro-esempio sulla mia derivazione dello stop
Lo stop implicito l'ho ricavato come `MAE_pt / MAE_R`, che e' una divisione — poteva
dare qualsiasi cosa. **Se e' giusta, `stop − ampiezza` deve valere una costante
uguale su tutti e tre i simboli** (il buffer e lo slippage sono gli stessi nei tre
riepiloghi). Misurato:

| simbolo | mediana(stop − ampiezza) | n |
|---|---:|---:|
| `D30EUR` | **+4,99 idx** | 419 |
| `NASUSD` | **+5,00 idx** | 414 |
| `U30USD` | **+5,00 idx** | 401 |

🟢 **Tre simboli, stessa costante a due decimali.** La derivazione e' buona.

---

# 5. 🧪 IL CONTRO-ESEMPIO: **«basta riscalare i punti» E' FALSO**

L'ipotesi comoda sarebbe: *il DAX e' una versione piu' piccola del Nasdaq, quindi si
moltiplica tutto per 0,73 e si e' finito.* **Se fosse vera, OGNI rapporto NAS/DAX
darebbe lo STESSO numero.** Misurati:

| grandezza | Nasdaq | DAX | **rapporto NAS/DAX** |
|---|---:|---:|---:|
| prezzo dell'indice | 29.089 | 25.431 | **1,144** |
| spread all'apertura | 1,80 | 1,60 | **1,125** |
| **MFE mediano** | 65,00 | 55,25 | **1,176** |
| ampiezza 15' | 75,30 | 54,65 | **1,378** |
| stop implicito | 80,62 | 58,66 | **1,374** |
| ADR (max-per-data) | 384,6 | 252,5 | **1,523** |

> ## 🔴 **I rapporti vanno da 1,125 a 1,523 — si spalmano su un intervallo del 35%. NON e' una riscalatura.**

## 🔬 E i tre punti dove il trasferimento si ROMPE

| rapporto adimensionale | `D30EUR` | `NASUSD` | `U30USD` | che cosa dice |
|---|---:|---:|---:|---|
| **MFE / ampiezza** | 🟢 **1,011** | 0,863 | 0,794 | **il DAX estende il 17% IN PIU' rispetto al proprio range** |
| **spread / ampiezza** | 🔴 **0,0293** | 0,0239 | 0,0251 | **il DAX costa il 22% IN PIU' rispetto al proprio range** |
| **ampiezza / ADR** | 0,2164 | 0,1958 | 0,3155 | il DAX mette il 10% in piu' della sua giornata nell'apertura |
| stop / ampiezza | 1,0734 | 1,0706 | 1,0465 | 🟢 **questo si', e' invariante** (per costruzione) |
| ampiezza / prezzo | 0,2149% | 0,2589% | 0,2240% | il Nasdaq apre il 20% piu' largo, in % |

*(colonna `MFE/ampiezza` = **rapporto delle mediane**. La **mediana dei rapporti**
da' 1,1309 · 0,9610 · 0,9892 — scarti del **−10,6% · −10,2% · −19,7%**. La
**conclusione non cambia**: il DAX resta il piu' alto con tutti e due i calcoli.)*

## 🔴 5.1 — E IL PUNTO CHE COSTA DAVVERO: il cancello `stop >= 40 × spread`

| simbolo | stop implicito | spread | **stop/spread** | serve per 40× | esito |
|---|---:|---:|---:|---:|---|
| **`D30EUR`** | 58,66 | 1,60 | 🔴 **36,7 ×** | 64,00 idx | 🔴 **NON PASSA** |
| `NASUSD` | 80,62 | 1,80 | 🟢 **44,8 ×** | 72,00 idx | 🟢 passa |
| `U30USD` | 125,32 | 3,00 | 🟢 **41,8 ×** | 120,00 idx | 🟢 passa |

> ## 🔴 **ECCO LA RISPOSTA VERA ALLA DOMANDA DI CLAUDIO.** Non e' *«il DAX fa meno punti»* — ne fa quasi gli stessi, e in rapporto al suo range ne fa **di piu'**. 🔴 **E' che il DAX fa quei punti con uno stop che sta sotto la frontiera del costo di casa**, mentre il Nasdaq no. **Trasferire la configurazione del Nasdaq sul DAX a parita' di regole porta la sedia SOTTO il 40×, non sopra.**

⚠️ **E questa riga va letta con la sua etichetta, non gonfiata.** Vale per la
configurazione **dello Studio** (range 15', buffer 200 = 2,00 idx). La sedia viva
`770101` gira **buffer 500 (5,00 idx)** e **range 35'**: il suo stop misurato sulle
gambe vere e' **71,90 idx su n=7** (`ANCORA_ADR_FLOTTA_INDICI_2026-09-18.md` §contro-esempio #1),
cioe' **44,9 ×** → **passa**. 👉 **Non sto dicendo che `770101` e' fuori cancello:
sto dicendo che il margine se lo compra col buffer piu' largo, e che chi copiasse
il buffer 200 del Nasdaq sul DAX lo perderebbe.** `[n=7, SOTTILE]`.

---

# 6. 🔴 CHE COSA MANCA PER RISPONDERE DAVVERO — col costo e la macchina

## 6.1 — Il buco principale: **l'anatomia per epoca del DAX non esiste**
Quello che ho per il DAX (`Studio_D30EUR.csv`) e' **440 giornate recenti, una sola
epoca**. Quello che ho per il Nasdaq (anatomia) e' **16 anni divisi in 5 regimi**.
👉 **Non posso dire se l'invariante `MFE/ampiezza ≈ 0,54` del DAX regge nei regimi**,
perche' sul DAX ho **un solo regime**. Per l'Emendamento C (prova di regime) questo
e' **`[NON MISURABILE OGGI]`**.

## 6.2 — Come si produrrebbe, e perche' **non e' un round**
Lo strumento e' **`backtest_pipeline/anatomia_aperture.py`** (in repo, sul branch
`lavoro`): e' uno **script Python in streaming** che legge un CSV M1, **non un EA e
non un'ottimizzazione**.
- 🟢 **Costo in tempo macchina: ZERO passate di Strategy Tester.** La corsa sul
  Nasdaq (5.233.590 barre, 347 MB) e' durata **0,45 minuti** (referto della corsa).
  Il DAX su una finestra simile costerebbe **lo stesso ordine di grandezza**.
- 🖥️ **Macchina: il PC di backtest** (regola del 21/09: i round non girano piu' sul
  VPS). Ed essendo Python puro, **non tocca nessun terminale MT5**.
- 🔴 **LO SBARRAMENTO NON E' IL TEMPO: E' IL DATO.** Serve un
  `<SIMBOLO>_M1.csv` del DAX in `C:\Users\Master\abtg_storico_indici\`, e il referto
  del 26/08 dichiara testualmente: *«il DAX (`grxeur`) e' **BOCCIATO** in attesa di
  diagnosi (decisione D-F, referto storico indici del 25/08)»*.
  👉 **Prima della misura va riaperta QUELLA diagnosi.** Finche' e' chiusa cosi',
  l'anatomia del DAX **non si puo' fare**, e non per pigrizia.
- 📌 **Se invece si volesse la stessa cosa a tick BCM**, lo strumento e'
  `mql5/Experts/ABTG_Apertura_Study_EA.mq5` + `backtest_pipeline/studio_apertura.ps1`:
  **1 passata per simbolo per finestra** (non e' un'ottimizzazione). Il costo di
  `Studio_D30EUR.csv` fu **115.914 candele M5 processate** = una corsa singola.
  🔴 **Ma il tetto delle ~100.000 barre del tester limita la finestra**, quindi
  per fare piu' epoche servono **corse spezzate in tranche, dichiarate**.
  **Quante tranche esattamente: `[NON MISURATO]`** — dipende dalla profondita' vera
  dei dati BCM su `D30EUR`, che **si misura con una sonda, non si assume** (regola
  del 25/08).

## 6.3 — Gli altri buchi, con il nome
| che cosa manca | perche' serve | come si chiude | costo |
|---|---|---|---|
| ampiezza del range a **35'** sul DAX | le sedie vive girano 35', non 15' | rilancio di `ABTG_Apertura_Study_EA` con `InpRangeMinutes=35` | **1 passata**, PC di backtest |
| **MFE non troncato** (TP > 2R) | q75/q90 oggi sono censurati al 30% | `TP_R` alto o nullo nello Study EA | **1 passata per simbolo** |
| a che **unita'** si riferiscono i «punti» delle slide | decide se R3/R4/R5 sono trasferibili | **chiedere agli autori del corso** | 🟢 **zero macchina** — e' un buco che **Claudio puo' chiudere lui** |
| decimali di `D30EUR`/`NASUSD` dal terminale | conferma indipendente del ×100 | lettura a costo zero in MT5 | 🟢 gia' coperto da 2 fonti in repo |
| spread FTMO (le sedie operano su `GER40.cash`/`US100.cash`, non su BCM) | il cancello vero e' sullo spread del broker dove si opera | `STOP_VS_SPREAD_FTMO_2026-09-20.md` ne ha uno (Nasdaq 1,53); per il DAX **`[NON MISURATO]`** | sola lettura sul terminale FTMO `541452707` |

---

# 7. 📋 CHE COSA **NON** HO COPERTO — elencato per nome (mai «tutto il resto»)

1. **`docs/live_emiliano/ANALISI_SLIDE_APERTURE.md`** — non letto in questo giro; ho
   usato la sua sintesi gia' verificata in `LE_SLIDE_NASDAQ_LA_CROCE_MAI_GIRATA_2026-09-18.md`.
2. **`report/R183_LA_CROCE_DELLE_SLIDE_LA_GRIGLIA_2026-09-18.md`** — non aperto.
3. **`report/ATR_DAX_M30_RICONCILIAZIONE_2026-09-17.md`** — non aperto (usata solo la
   sua sintesi citata dentro `ANCORA_ADR_FLOTTA_INDICI`).
4. **`ANATOMIA_APERTURE_CASSAFORTE_2021_2026.txt` e `ANATOMIA_APERTURE_COMPLETO.txt`** —
   non letti: ho lavorato direttamente sul CSV per-giorno.
5. **I round sul DAX in `risultati_prove/` e `risultati_archivio/`** — **non censiti**.
   Non so se qualcuno abbia gia' misurato un bersaglio in punti sul DAX.
6. **Il `CENSIMENTO_PF_TUTTI_2026-09-09.csv` e `REGISTRO_TEST.md`** — non consultati:
   questo e' un referto di **misura**, non una proposta di griglia, e non archivia
   ne' promuove nessun candidato.
7. **`Studio_SPXUSD` · `Studio_F40EUR` · `Studio_E35EUR` · `Studio_E50EUR` ·
   `Studio_100GBP`** — esistono in repo e **non li ho aperti**. `F40EUR` (CAC) e
   `E50EUR` (Eurostoxx) aprono alle 08:00 come il DAX: sarebbero **due controprove
   europee gratis** dell'invariante del §5.
8. **I giorni `SOSPETTO` (74) e la malattia del feed del 2023 (22,9%)** — esclusi dai
   conteggi, **non analizzati**. Il regime `2023-2026` porta quella riserva dentro.
9. **Il lato SHORT del DAX** — `770101` ha `InpAllowShort=false`. Lo Studio misura
   **215 short** su 440, quindi il numero c'e', ma **non ho indagato perche' lo short
   sia spento** ne' se i 55,25 punti valgano uguali sui due lati del DAX. 🔴 **Questo
   e' un debito con la regola dei due lati del 25/08.**
10. **Qualunque numero che richieda MT5** — vincolo del mandato, Claudio e' da cellulare.

---

# 8. ✅ IL RIASSUNTO PER CLAUDIO

| la sua frase | verdetto | numero |
|---|---|---|
| *«due ordini pendenti a 7 pip di distanza»* | 🟢 **il 7 c'e' nelle slide** (R3: +7…+10 oltre il livello, **non fra i due ordini**) | la macchina ne mette **2,00** sul Nasdaq e **5,00** sul DAX |
| *«fa 50 punti di media come il Dax»* | 🟢 **sul DAX confermato** | **55,25 punti indice**, n=440 BCM tick |
| *«non so se il Nasdaq fa 50 punti»* | 🟠 **ne fa di piu'** | **65,00 punti indice**, n=447 — **+17,6%** |
| *«proviamo ad applicarla col DAX»* | 🔴 **i rapporti si', i punti vanno rifatti** | e lo stop dello Studio sul DAX fa **36,7 × spread**: **sotto il 40×** |

🟢 **La buona notizia**: il fenomeno e' **lo stesso** sui due indici (0,2173% contro
0,2235% del prezzo, **+2,9%**), e il rapporto estensione/ampiezza e' rimasto stabile
sul Nasdaq attraverso **cinque regimi in sedici anni**. **C'e' qualcosa di solido
sotto la domanda di Claudio.**
🔴 **La cattiva**: quello che si trasferisce sono i **rapporti**, non i **punti** — e
il DAX paga uno spread piu' alto **in rapporto al proprio range** (2,93% contro
2,39%). 👉 **La configurazione del DAX va ricalcolata, non copiata.**

---

*R229 · 23/09/2026 · tutte le misure da file in repo, zero minuti macchina, zero MT5.
Fonti primarie: `backtest_pipeline/risultati_archivio/studio_apertura/Studio_{D30EUR,NASUSD,U30USD}.csv`
e `Studio_*_RIEPILOGO.csv` ·
`backtest_pipeline/risultati_archivio/ANATOMIA_APERTURE_20260826/ANATOMIA_APERTURE_PERGIORNO_NASUSD.csv`
+ `REFERTO_ANATOMIA_APERTURE.txt` + `CENSIMENTO_FONTE.txt` ·
`backtest_pipeline/anatomia_aperture.py` rr.483-513, 518-534 ·
`docs/live_emiliano/c05566f8-Piano_Trading__NASDAQ__ABTG.pdf` pp.2-8 ·
`data/spread_vivo/SPREAD_VIVO_2026-09-12_orario.csv` + `_referto.txt` r.62 ·
`data/statements/trades_auto.csv` · `report/ANCORA_ADR_FLOTTA_INDICI_2026-09-18.md` ·
`report/AMPIEZZA_RANGE_NASDAQ_2026-09-21.md` ·
`report/LA_STRATEGIA_NASDAQ_DEI_COLLEGHI_2026-09-18.md` ·
`mql5/Presets/FTMO/ABTG_{Nasdaq_Apertura_US_RETEST_770260,DAX_Apertura_EU_770101}_FTMO.set`.*
