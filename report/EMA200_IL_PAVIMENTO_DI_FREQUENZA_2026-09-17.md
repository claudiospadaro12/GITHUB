# 📊 `ABTG_EMA200` — **IL PAVIMENTO DI FREQUENZA: SI PUÒ RAGGIUNGERE ENTRO IL 1° OTTOBRE?**

**Giovedì 17/09/2026, sera. Mancano 13 giorni.** Sola lettura d'archivio:
**nessun backtest, nessun EA, nessun preset, nessun file prova, nessuna riga di
coda, nessun terminale.** Il conto reale `10105439` non è stato letto né
nominato come bersaglio. **Nessuna taglia e nessun parametro di rischio è
proposto qui.** Zero costo macchina speso.

> # 🥇 IL VERDETTO IN UNA RIGA
> ## **NO — la famiglia `EMA200` NON può raggiungere 1,00 op/giorno entro il 1° ottobre per nessuna delle tre strade; e il muro NON è una misura mancante, è un vincolo di DATI (lo storico BCM sugli indici parte dal 2024.09.26) più un verdetto di edge già misurato a H1. L'unica leva che resta è una FIRMA di Claudio sull'UNITÀ di misura, e quella non è mia.**

> ## ⚖️ E LA COSA CHE CAMBIA DI PIÙ IL QUADRO
> 🔴 **Il numero «6 celle positive su 330» citato dal referto di stamattina era
> già stato corretto in casa CINQUE GIORNI FA** (`EMA200_I_DUE_REQUISITI_2026-09-12.md`
> r.10), **e l'insieme su cui è calcolato è definito male** (classe 180): dice
> *«i quattro indici gemelli»* ma sono **cinque**, e ne **lascia fuori quattro**
> che nello **stesso archivio** fanno **85 celle positive**. Il conto rifatto da
> me sui CSV grezzi, su **nove** indici gemelli, è **87 su 771**.
> 🟢 **La conclusione operativa non cambia** (nessun gemello è promuovibile a
> H1). 🔴 **Il numero sì**, e un numero sbagliato davanti a una firma è una
> trappola.

---

# 0. 📣 PRIMA LE VITTORIE, perché ce ne sono e non sono piccole

1. 🟢 **Il «6 su 330» NON era rumore da campione sottile**, e l'ho verificato
   prima di tutto il resto: il denominatore di quelle frazioni è *«celle con
   `Trades > 0`»*, e su quelle celle il numero di deal mediano sta fra **216 e
   372** per simbolo. **Il campione è pieno.** La differenza fra *«non ha edge
   sui gemelli»* e *«non è misurato sui gemelli»* — la domanda del mandato — si
   risolve a favore della **prima**, ed è una buona notizia perché chiude una
   strada invece di lasciarla aperta a vuoto.
2. 🟢 **La strada del TF è chiusa DUE VOLTE, non una**: per costo *e* per
   merito, tutti e due col numero. Non c'è niente da riprovare.
3. 🟢 **La porta aperta del trailing è stata guardata, e la risposta è netta**:
   sul **merito** resta aperta, sulla **frequenza** è chiusa — e la chiude il
   **codice**, non una stima.
4. 🟢 **La sedia è veloce davvero.** Contro il campo misurato (0,29-0,47
   op/giorno per simbolo) fa **2,0-3,2×**. Il problema non è il motore: è che la
   famiglia ha **un simbolo solo**. Questo va detto a Claudio in questa forma,
   perché è vero.

---

# 1. 🔢 IL NUMERO DA BATTERE, e il buco esatto

| grandezza | valore | fonte | tag |
|---|---:|---|:--:|
| pavimento firmato il 07/09 | **1,00 op/giorno per FAMIGLIA**, *«sommando i simboli schierabili»* | `report/FIRME_2026-09-07.md` **r.13** | firmato |
| posizioni OOS della sedia | **257** | `risultati_archivio/R112_CORSA_20260826/pertrade_00_metro_763400.csv`, riletto in `EMA200_I_DUE_REQUISITI_2026-09-12.md` §3.1 | **[MISURATO]** |
| deal OOS | **517** | `risultati_prove/ABTG_EMA200/ABTG_EMA200_U30USD_OOS_r31.csv` r.2 col. `Trades` | **[MISURATO]** |
| giorni feriali OOS (2025.06.10→2026.06.30) | **276** (il mio conteggio) · **272** (referto 17/09 §3.3) | ricalcolo mio con `datetime`, weekday<5, estremi inclusi | 🔴 **[NON MISURATO]** — due valori di casa, scritti entrambi |
| **frequenza OOS in POSIZIONI** | **0,931** (su 276) · **0,945** (su 272) | `257 / 276` · `257 / 272` | **[MISURATO]**, con la banda dichiarata |
| **frequenza OOS in DEAL** | **1,873** (su 276) · **1,901** (su 272) | `517 / 276` · `517 / 272` | **[MISURATO]** |

## 🔬 IL CONTRO-ESEMPIO, costruito prima di consegnare
Ho provato a **rompere lo 0,945**, non a confermarlo. Ho ricontato i giorni
feriali della finestra OOS da zero: mi escono **276**, non 272 (probabile
differenza: festivi tolti dall'altro conteggio, o un estremo incluso/escluso —
**non l'ho potuto attribuire**, quindi resta `[NON MISURATO]` con **entrambi i
valori scritti**). Risultato: **0,931 invece di 0,945**. 👉 Il verdetto **non si
muove**, ma si muove **nella direzione sfavorevole**: il buco è più grande, non
più piccolo. **Un contro-esempio che avesse fatto comodo lo avrei scritto lo
stesso, e questo non fa comodo.**

## 🆕 E UN NUMERO CHE NESSUNO AVEVA SCRITTO: la frequenza su TUTTA la finestra

| finestra | posizioni | feriali (mio conteggio) | pos/giorno |
|---|---:|---:|---:|
| **IS** 2024.09.26 → 2025.06.09 | 132 | 183 | 🔴 **0,721** |
| **OOS** 2025.06.10 → 2026.06.30 | 257 | 276 | **0,931** |
| **TUTTA** 2024.09.26 → 2026.06.30 | **389** | **459** | 🔴 **0,847** |

**[MISURATO]** — le posizioni vengono da `EMA200_DOW_COSA_MANCA_PER_IL_1_OTTOBRE_2026-09-17.md`
§3.2 (IS 132, cinque notti) e §3.1 (OOS 257); i giorni feriali sono un mio
ricalcolo.
🔴 **La frequenza della sedia NON è stabile fra le finestre: 0,721 contro
0,931.** Il numero che gira (0,945) è il numero della finestra **veloce**. Su
tutto il campione la sedia fa **0,847 pos/giorno**, cioè il buco verso 1,00 non
è del 5,5% ma del **15,3%**. 👉 **Questo rende la strada più difficile, non più
facile, e va davanti a Claudio così.**

### 📐 Il buco, in cose contabili
Perché la famiglia arrivi a 1,00 sulla finestra OOS servono **276 posizioni**
contro le 257 che ci sono: **mancano 19 posizioni in 13 mesi**, cioè
**0,069 pos/giorno** da un secondo simbolo. Col metro dei 272 giorni sono **15**
posizioni e **0,055 pos/giorno**. **È poco. E le tre strade qui sotto dicono che
non c'è dove prenderle entro il 1° ottobre.**

---

# 2. 🔓 STRADA 1 — I SIMBOLI, RIFATTA DA ZERO SUI CSV GREZZI

## 2.1 🔴 COME è stato prodotto il «6 su 330», e perché il numero è sbagliato

**La griglia** (letta da me sulle colonne che variano, `scan_ABTG_EMA200_H1_U30USD.csv`):
`InpAllowLong` ×2 · `InpAllowShort` ×2 · `InpOrder1Atr` ×6 (0,05→0,30) ·
`InpOrder2Atr` ×5 (0,2→0,6) · `InpTP_RR` ×4 (1,5→3,0) = **240 combinazioni
nominali**. È **solo geometria d'INGRESSO**: tutte le manopole d'uscita sono
**fisse alla cella viva** (`InpSLatr=1` · `InpTP1_ATRmult=0` · `InpTP1Pct=50` ·
`InpBreakeven=1` · `InpUseTrailing=1`). **[MISURATO]**

**Il campione** — la domanda che il mandato chiede per prima:

| simbolo | celle con `Trades>0` | **deal mediani per cella** | celle con ≥150 deal |
|---|---:|---:|---:|
| `U30USD` | 98 | 341 | 98 |
| `D30EUR` | 80 | 389 | 80 |
| `SPXUSD` | 86 | 376 | 86 |
| `NASUSD` | 83 | 315 | 83 |
| `F40EUR` | 81 | 270 | 70 |
| `E50EUR` | 83 | 231 | 83 |

_(mio ricalcolo su `backtest_pipeline/risultati_prove/risultati_scan_ABTG_EMA200_H1/`)_ **[MISURATO]**

> ### 🎯 **RISPOSTA ALLA DOMANDA DEL MANDATO: il «6 su 330» NON è rumore.**
> Il denominatore di quelle frazioni è *«celle che hanno prodotto almeno un
> trade»* — l'ho verificato provando sette soglie (`Trades >` 0, 1, 50, 100, 120,
> 150, 200): le soglie **0 · 1 · 50 · 100 danno TUTTE lo stesso conteggio**
> **80 · 83 · 81 · 83 · 86 · 98**, e solo da 120 in su i numeri si staccano.
> 🎯 **Ed è proprio questo il fatto che conta**: *«celle con almeno 1 trade»* e
> *«celle con almeno 100 deal»* sono **lo stesso insieme**. Non esiste una sola
> cella con un campione sottile che gonfi quel denominatore. E su quelle
> celle il campione è **pieno**: 231-389 deal mediani, cioè **~115-195
> posizioni** col rapporto strutturale ~2 di questo motore.
> ⚠️ **Il limite dichiarato**: `Trades` conta **deal**, non posizioni. Convertite,
> alcune celle di `E50EUR`/`F40EUR` scendono sotto il pavimento dei 150 in
> posizioni. **Non cambia niente**, perché il difetto lì non è il campione: è che
> il **PF massimo su 83-88 celle è 0,740-0,934**, cioè non c'è **nessuna** cella
> positiva da salvare.

## 2.2 🔴 E ADESSO L'INSIEME, ELENCATO PER NOME (classe 180)

Il referto del 17/09 dice *«i quattro indici azionari gemelli»* e ne elenca
**cinque**. Nello **stesso archivio** ce ne sono **nove**. Ecco tutti, contati da
me su `backtest_pipeline/risultati_archivio/EMA200/H1_OHLC/` (celle **vive** =
escluse quelle con `InpAllowLong=0 E InpAllowShort=0`, che sono motore spento):

| indice | H1 OHLC: PF>1 / vive | PF max | PF mediano | deal mediani | citato nel «330»? |
|---|---:|---:|---:|---:|:---:|
| 🎯 **`U30USD`** (Dow) | **81 / 81** | **1,842** | **1,415** | 287 | — (è la sedia) |
| `225JPY` (Nikkei) | **41 / 85** | 1,465 | 0,997 | 117 | ❌ **NO** |
| `E35EUR` (Spagna) | **22 / 81** | 1,185 | 0,923 | 125 | ❌ **NO** |
| `200AUD` (ASX) | **13 / 87** | 1,084 | 0,878 | 372 | ❌ **NO** |
| `100GBP` (FTSE) | **9 / 93** | 1,075 | 0,807 | 337 | ❌ **NO** |
| `SPXUSD` | 1 / 79 | 1,014 | 0,731 | 343 | ✅ sì |
| `NASUSD` | 1 / 85 | 1,020 | 0,791 | 286 | ✅ sì |
| `D30EUR` (DAX) | **0 / 85** | 0,928 | 0,828 | 372 | ✅ sì |
| `F40EUR` (CAC) | **0 / 88** | 0,934 | 0,714 | 256 | ✅ sì |
| `E50EUR` (EuroStoxx) | **0 / 88** | 0,740 | 0,489 | 216 | ✅ sì |
| **TOTALE gemelli (9)** | 🔴 **87 / 771** | | | | |

**[MISURATO]** — tutto ricalcolato da me sui CSV grezzi in questo giro.

⚠️ **Due archivi diversi, e vanno distinti**: `risultati_prove/risultati_scan_ABTG_EMA200_H1/`
e `risultati_archivio/EMA200/H1_OHLC/` **non sono lo stesso file** (md5 diversi,
numero righe diverso: es. `U30USD` 142 contro 139 celle). Danno conteggi vicini
ma non identici (`SPXUSD` 4/86 contro 1/79). 👉 **Il «330» viene dal primo, il
mio 87/771 dal secondo**, e li ho tenuti separati invece di mescolarli.

> ### 🔴 **PER NOME, QUELLO CHE È STATO PROVATO E QUELLO CHE NON LO È MAI STATO, A H1**
>
> **A TICK REALI (il verdetto vero), a H1:**
> | simbolo | esito | il numero | fonte |
> |---|---|---|---|
> | `U30USD` | 🟢 **30/30 PASS** | IS 30/30 pos., OOS 30/30 pos., PF OOS fino a 1,605 | `ABTG_EMA200_U30USD_{IS,OOS}_r29b.csv` |
> | `EURUSD` | 🔴 **BOCCIATO: 7/30 PASS pieni** | 29/30 e 30/30 **positive**, ma PF OOS **1,076-1,224** e DD OOS **9,05-11,98%** → metà regione manca `PF≥1,10`, metà sfonda `DD 10%` | `ABTG_EMA200_EURUSD_{IS,OOS}_r29a.csv` |
> | `225JPY` | 🔴 **BOCCIATO: 30/30 IS → 0/30 OOS** | IS PFmax **1,492**, OOS PFmax **0,849**, n OOS **451-578 deal** | `ABTG_EMA200_225JPY_{IS,OOS}_r32b.csv` (`InpTF=16385`) |
> | `XAUUSD` | 🔴 **BOCCIATO: 0/30 in IS** | — | `ABTG_EMA200_XAUUSD_{IS,OOS}_r32a.csv` |
>
> **MAI A TICK a H1, e con un segnale non nullo in screening:**
> **`E35EUR`** (22/81, PFmax 1,185) · **`200AUD`** (13/87, PFmax 1,084) ·
> **`100GBP`** (9/93, PFmax 1,075).
>
> **MAI A TICK a H1, e con screening a ZERO o quasi:**
> **`D30EUR`** (0/85) · **`F40EUR`** (0/88) · **`E50EUR`** (0/88) ·
> **`SPXUSD`** (1/79) · **`NASUSD`** (1/85).

### 🔬 IL CONTRO-ESEMPIO SUL «7/30» — perché non me lo sono fidato
Il referto del 12/09 scrive *«EURUSD 7/30»*, e i CSV grezzi dicono **29/30 e
30/30 celle positive**: sembrano due numeri in contraddizione. **Non lo sono, e
l'ho verificato incrociando il file prova coi CSV.** `backtest_pipeline/prove/R29a_ema200_eurusd.txt`
congela i criteri **PRIMA** dei numeri: *«positiva in ENTRAMBE le finestre; PF
OOS ≥ 1,10; REGIONE (non celle isolate); DD OOS < 10% all'1%»*. Applicandoli
cella per cella io ottengo **esattamente 7 su 30**. 👉 **`EURUSD` non è un buco
di misura: è una bocciatura col criterio congelato prima.** E vale la pena dirlo
perché `EURUSD` OOS fa **583-759 deal** — da solo porterebbe la famiglia sopra
il pavimento. **Non si usa, e il motivo è scritto e riprodotto.**

## 2.3 🎯 I TRE MAI PROVATI A TICK — vale la pena spenderci un round?

> ### 🔴 **La risposta onesta è NO, e i motivi sono tre, tutti col numero.**

**(a) Sono «celle sparse», che è esattamente ciò che ha ucciso `EURUSD`.**
`E35EUR` 27% di celle positive · `200AUD` 15% · `100GBP` 10%, contro **100% sul
Dow** (81/81). Il criterio congelato in `R29a` dice testualmente *«REGIONE (non
celle isolate): se passa solo qualche cella sparsa, è un no»*.

**(b) Il tick DEGRADA, e ho misurato di quanto.** Sugli unici due simboli dove
esistono **entrambe** le letture a H1:

| simbolo | PF max **OHLC** | PF max **TICK** | degrado |
|---|---:|---:|---:|
| `U30USD` | 1,805 (`risultati_scan_.../U30USD`) | 1,704 (`risultati_valid_ABTG_EMA200_H1_realtick/..._U30USD.csv`) | **−5,6%** |
| `EURUSD` | 1,445 (`risultati_scan_.../EURUSD`) | 1,371 (`..._realtick_EURUSD.csv`) | **−5,1%** |

**[MISURATO]**, due simboli indipendenti, stesso segno, stessa ampiezza.
Applicato ai tre candidati: `E35EUR` 1,185 → **~1,12** · `200AUD` 1,084 →
**~1,03** · `100GBP` 1,075 → **~1,02**. 👉 **Due su tre non arriverebbero
nemmeno al `PF ≥ 1,10` col loro PICCO**, e il picco è proprio la cella che la
regola di casa **vieta** di scegliere. `[INFERITO]` — è un'estrapolazione da due
punti, e la dichiaro come tale.

**(c) 🔴 E IL CANCELLO DI COSTO SU DI LORO NON È CALCOLABILE.**
Questa è la domanda che il mandato marca in rosso, e la risposta è un buco, non
un numero. **Lo spread misurato in casa esiste per OTTO simboli e basta**:

`225JPY` · `D30EUR` · `EURUSD` · `GBPUSD` · `NASUSD` · `U30USD` · `USDJPY` ·
`XAUUSD` — `data/spread_vivo/SPREAD_VIVO_2026-09-12_referto.txt` (78.926-84.997
campioni per simbolo, GG 5-6). Più i tick storici di tre soli simboli
(`NASUSD` · `U30USD` · `D30EUR`) in `risultati_archivio/spread_flotta/`.

| simbolo | spread misurato? | stop H1 misurato? | **cancello `stop ≥ 40 × spread`** |
|---|:---:|:---:|:---:|
| `U30USD` | ✅ mediana **2,000** pt indice (n=79.138, GG=5) | ✅ **104,3** [MIS] n=8 | 🟠 **54,9×** aggregato · **37,1×** sulla gamba 2 |
| `E35EUR` · `200AUD` · `100GBP` | ❌ **mai misurato** | ❌ mai misurato | ⚪ **[NON MISURATO] — non calcolabile** |
| `SPXUSD` · `E50EUR` · `F40EUR` | ❌ **mai misurato** | ❌ mai misurato | ⚪ **[NON MISURATO]** |

🔴 **Quindi, alla lettera del mandato: fra i simboli mai provati NON ce n'è
nessuno di cui si possa dire che passa il cancello di costo — e non perché lo
sfonda, ma perché lo spread non è mai stato misurato.** Non si scrive
*«escluso per costo»*: si scrive **«cancello di costo non calcolabile»**, che è
una cosa diversa e va detta così.

### ⏱️ La via più corta a quel numero, col suo costo
`ABTG_SpreadLogger` **esiste già** ed è già girato una volta
(`mql5/Experts/ABTG_SpreadLogger.mq5`, raccolta del 12/09 su 8 simboli).
Aggiungere `SPXUSD`/`E35EUR`/`100GBP`/`200AUD`/`F40EUR`/`E50EUR` costa **ZERO
tempo macchina di tester** — costa **5-6 giorni di calendario** di raccolta per
avere `GG ≥ 5` come gli altri. 🔴 **Consegnerebbe il numero verso il 23/09, e a
quel punto resterebbero 7 giorni per fare screening + tick + walk-forward su un
simbolo il cui screening dice già «celle sparse». Non ce la fa.**
📌 **Ma va messo in coda lo stesso, per DOPO ottobre**: è la classe di buco che
il 09/09 ci è costata quattro candidati.

---

# 3. ⏱️ STRADA 2 — IL TIMEFRAME. **CHIUSA DUE VOLTE, e non serve rifare niente**

## 3.1 Il merito: i numeri di `cemad05`, riletti da me sui CSV (non ricopiati)

`backtest_pipeline/risultati_prove/dal_vps/ABTG_EMA200/ABTG_EMA200_U30USD_{IS,OOS}_cemad05.csv`

| `InpTF` | PF IS | PF OOS | DD OOS | **n OOS (deal)** | deal/giorno feriale |
|---|---:|---:|---:|---:|---:|
| **H1 (16385) — viva** | **1,20110** | 🥇 **1,52365** | 7,8323% | **517** | 1,873 |
| M15 (15) | 0,77131 | 0,95408 | 🔴 **26,3396%** | 2020 | 7,32 |
| M20 (20) | 1,11669 | 0,83338 | 🔴 **30,7078%** | 1642 | 5,95 |
| **M30 (30)** | 1,03404 | 🔴 **0,90713** | 🔴 **15,8669%** | 1268 | 4,59 |
| H2 (16386) | 2,59887 | 1,17278 | 6,1206% | 266 | 0,964 |
| H3 (16387) | 2,15163 | 0,90825 | 9,0028% | 170 | 0,616 |
| H4 (16388) | 1,66012 | 1,42483 | 4,4497% | 116 | 0,420 |

**[MISURATO]** — lette da me, colonna per colonna, in questo giro.

> ### 🎯 **LA FREQUENZA SI COMPRA COL TF, ED È VERO: M30 fa 2,45× i deal di H1.**
> ### 🔴 **MA IL PREZZO È: PF OOS da 1,524 a 0,907 e DD da 7,83% a 15,87%.**
> Il DD **sfonda il muro del 10%** e il PF va **sotto 1**. Non è un compromesso:
> è una sedia che perde soldi più in fretta. **Non si compra frequenza con un
> PF sotto 1.**

## 3.2 🔴 Il costo: **M30 è ESCLUSO PER COSTO, e il numero c'è**

`report/EMA200_I_DUE_REQUISITI_2026-09-12.md` **r.173**, tabella §4.3
(legge di scala `ATR(T) = ATR(H1) × √(T/60)` **ancorata al misurato H1**
78,0-88,2 pt; denominatore: mediana di sessione **1,95**; cancello **≥40×**):

| TF | ATR stimato (pt) | **gamba 2 / spread** | verdetto |
|---|---|---:|---|
| M5 | 22,5-25,5 | 🔴 **11,5-13,1×** | sfonda anche il **pavimento DURO 13,3×** |
| M15 | 39,0-44,1 | 🔴 **20,0-22,6×** | **ESCLUSO PER COSTO** (50-57% della frontiera) |
| M20 | 45,0-50,9 | 🔴 **23,1-26,1×** | **ESCLUSO PER COSTO** |
| **M30** | 55,2-62,4 | 🔴 **28,3-32,0×** | 🔴 **ESCLUSO PER COSTO sulla gamba 2** (71-80%) |
| **H1** 🎯 | **78,0-88,2** (misurato) | 🟠 **33,6-45,2×** | la soglia cade **dentro** la banda → `FRAGILE` |
| H2 / H3 / H4 | 110-176 | 🟢 56,6-90,5× | passano, **ma la frequenza crolla** |

🔬 **Il margine dichiarato dalla fonte è ±20% sulle celle non-H1** (r.182), e
**non salva M30**: `32,0 × 1,20 = 38,4×`, ancora **sotto 40×**. **[MISURATO +
margine dichiarato]**

🔴 **Il numero dello spread `U30USD` che il mandato cita — `1,90` (ora 17) — è
quello della tabella del 10/09.** Il mio riscontro indipendente sul file vivo:
**mediana di giornata 2,000 punti indice, P95 3,000**, n=79.138, GG=5
(`data/spread_vivo/SPREAD_VIVO_2026-09-12_referto.txt`). **I due non litigano**
(uno è un'ora, l'altro la giornata), ma **il secondo è più severo**: con 2,00 il
rapporto di M30 sulla gamba 2 scende ancora.

> ## 🎯 **VERDETTO STRADA 2: ZERO operazioni/giorno comprabili col TF.**
> **Sotto H1 non c'è nessun TF che tenga la frontiera del costo sulla gamba
> debole; sopra H1 non c'è nessun TF che tenga la frequenza** (H2 0,96 ·
> H3 0,62 · H4 0,42 **deal**/giorno, cioè ~0,21-0,48 posizioni). **H1 è
> contemporaneamente il pavimento e il soffitto**, ed è un conto, non
> un'abitudine.

---

# 4. 🚪 STRADA 3 — IL TRAILING SPENTO. **Sul merito resta aperta. Sulla frequenza è CHIUSA.**

## 4.1 I numeri di `r136d`, letti da me

`.../ABTG_EMA200_U30USD_{IS,OOS}_r136d.csv` — unico asse: `InpUseTrailing`

| | PF IS | DD IS | **deal IS** | PF OOS | DD OOS | **deal OOS** | Profit OOS |
|---|---:|---:|---:|---:|---:|---:|---:|
| **trailing ON** (viva) | **1,20110** | 5,7325% | **237** | 1,52365 | 7,8323% | **517** | 23.321,47 |
| **trailing OFF** | 🔴 1,10716 | 5,4988% | **194** | 🟢 **1,77080** | 🟢 **7,4151%** | **427** | 🟢 **28.249,94** |

**[MISURATO]**

## 4.2 🔴 LA DOMANDA DEL MANDATO: **il trailing spento cambia la FREQUENZA?**

> ### 🎯 **SÌ, E LA PEGGIORA. Le uscite calano del 17,4% in OOS e del 18,1% in IS.**

E **non può essere altrimenti**, e lo dimostro dal codice invece che dalla
statistica — che è un contro-esempio più forte di un numero:

`mql5/Experts/ABTG_EMA200.mq5` **r.322**:
```
   if(HasPosition() || HasPending()){ cB_occupata++; return; }         // gia' impegnati
```
👉 **L'EA non arma una nuova candidata finché ha una posizione o un pendente
aperto** (filtrati per `_Symbol` **e** `InpMagic`, funzioni `HasPosition()`
r.509-518 / `HasPending()` r.520-529).
👉 Il trailing è uno **stop che si muove a favore**: può far uscire **PRIMA** di
quanto avrebbe fatto lo stop fisso, **mai dopo**.
👉 Quindi **trailing OFF ⇒ posizioni tenute più a lungo ⇒ la casella è occupata
più a lungo ⇒ ingressi ≤**. **Le posizioni/giorno con trailing spento non
possono salire.** `[INFERITO dal codice, direzione dimostrata]`

🔴 **E il numero esatto delle POSIZIONI con trailing OFF è `[NON MISURATO]`**: il
CSV di riepilogo conta **deal**, e il rapporto deal/posizione **cambia con la
configurazione d'uscita** — proprio perché il trailing è uno dei meccanismi che
spezza una posizione in più deal. Da 427 deal **non si può dedurre** il numero
di posizioni. **Non lo invento.**

### ⏱️ LA VIA PIÙ CORTA A QUEL NUMERO, col costo
Il file prova `backtest_pipeline/prove/COLLAUDO_EMADOW_02_pertrade_IS.txt`
**esiste già** e fa scrivere il per-trade (da cui si contano i `position_id`).
Servirebbe la stessa cosa sulla finestra OOS con l'asse `InpUseTrailing` a due
valori: **2 passate**. Col metro di casa `T = 0,6 + 0,077 × passate` ⇒ **≈ 0,75
minuti di tester**.
🔴 **Ma serve per il MERITO (capire se il PF 1,771 è vero), NON per la
frequenza**: la frequenza è già decisa dal codice, e nella direzione sbagliata.

## 4.3 📜 Che cosa resta aperto, e come va scritto
🟠 **Il segno si inverte fra le finestre** (IS peggio 1,107 vs 1,201 · OOS meglio
1,771 vs 1,524) ⇒ **[NON MISURATO] come miglioramento**, esattamente come lo
marca il referto del 17/09 §5.1. 🟢 **E resta una porta aperta sul merito**: un
PF 1,771 con **DD più basso** (7,4151% contro 7,8323%) merita una misura in più.
🔴 **Ma non è la cosa più preziosa della serata per la frequenza: per la
frequenza è un passo indietro.**

---

# 5. ⚖️ IL PUNTO DI ONESTÀ — **è un argomento vero o un sofisma?**

Il mandato chiede di mettere sul tavolo questa osservazione **senza usarla per
ammorbidire niente**: la sedia fa **0,945** (o 0,931, o 0,847) su **un** simbolo,
mentre il campo misurato fa **0,29-0,47 op/giorno PER SIMBOLO**.

## 5.1 🔢 PRIMA I NUMERI DELLA FORBICE, per nome e con la fonte

`backtest_pipeline/caccia_strategie/CONFIG_PROP_FREQUENZA_2026-09-06.md`
**r.100-101** e **r.187**, statistiche **calcolate da MQL5, non dal venditore**:

| rif. | portafoglio | EA | **simboli** | operazioni | per **simbolo**/giorno | per **CONTO**/giorno | DD |
|---|---|---:|---:|---|---:|---:|---:|
| **S2** | Gold Reaper + Goldtrade Pro + Daytrade Pro (`signals/2204998`) | **3-5** | **26** | 7.930 in 210 settimane = **37,8/sett** (61 dichiarate) | **0,29-0,47** | **8,7** | 🔴 32,59% per saldo |
| **S1** | The Gold Reaper default (`signals/2195619`) | **1** | **1** (XAUUSD) | 1.308 in 939 giorni | **~1,0** | **~1,0** | 🔴 45,64% per saldo |

## 5.2 🎯 LA RISPOSTA, e non è quella che fa comodo

> ### 🟢 **L'osservazione è VERA come FATTO: `0,945 / 0,47 = 2,01×` e `0,945 / 0,29 = 3,26×`. Questa sedia è 2-3 volte più veloce di un'istanza media del campo.**
> ### 🔴 **Ed è un SOFISMA come ARGOMENTO SUL PAVIMENTO. Per tre motivi, tutti aritmetici.**

**(a) Il pavimento è una SOMMA, ed è scritto.** `FIRME_2026-09-07.md` r.13:
*«se la sua famiglia, **sommando i simboli schierabili**, raggiunge il
pavimento»*. Confrontare una velocità **per istanza** con una soglia **per somma
di istanze** è confrontare due unità diverse. La firma cambia **l'unità a cui si
applica**, non la soglia (`FIRME_2026-09-07.md`, *«Cosa NON è stato firmato
qui»*).

**(b) 🔴 Se si usasse il metro del campo alla sua unità, l'asticella SALIREBBE.**
S2 fa **8,7 operazioni/giorno di conto con 3-5 EA** ⇒ **1,74-2,90 op/giorno per
FAMIGLIA**. 👉 **Il pavimento di casa, 1,00, sta 1,7-2,9 volte SOTTO quello che
il campo fa per famiglia.** Portare il confronto col campo fino in fondo
**peggiora** la nostra posizione, non la migliora. **Questo lo dico perché è
vero, non perché aiuta.**

**(c) 🎯 E il campo HA un caso da un simbolo solo: è S1, e sta esattamente a
1,00.** The Gold Reaper: **1 EA, 1 simbolo, ~1,0 op/giorno**. 👉 **Il «1,00» del
pavimento è calibrato proprio sulla famiglia mono-simbolo del campo**, e la
nostra ci arriva al **94,5%** (o **93,1%**, o **84,7%** sul campione pieno).
⚠️ **E S1 paga quella velocità con un DD del 45,64% per saldo**: la famiglia
mono-simbolo veloce esiste nel campo, **ed è la più rischiosa delle due lette**.
Il nostro DD promesso è **7,8323%**. 🟢 **Questo è a nostro favore, e va detto
nella stessa riga.**

## 5.3 🚫 COSA NON PROPONGO, e perché
**Non propongo di abbassare 1,00.** La soglia è firmata, e il motto di casa dice
che *«insistere vuol dire cercare una MISURA in più, mai un criterio più
morbido»*.

## 5.4 🔴 QUELLO CHE INVECE VA DAVANTI A CLAUDIO — ed è una FIRMA, non una misura

> ### 🚩 **L'UNITÀ IN CUI SI LEGGE IL PAVIMENTO NON È MAI STATA FIRMATA, E RIBALTA IL VERDETTO.**

| unità | numero della sedia | contro il pavimento 1,00 |
|---|---:|:---:|
| **posizioni** / giorno feriale (OOS) | **0,931-0,945** | 🔴 **SOTTO** |
| **posizioni** / giorno feriale (tutta la finestra) | **0,847** | 🔴 **SOTTO** |
| **deal (= operazioni chiuse)** / giorno feriale (OOS) | **1,873-1,901** | 🟢 **SOPRA, quasi doppio** |

**Tutti e tre `[MISURATO]`.** E in casa ci sono già **tre** numeri diversi per la
stessa sedia: **0,945** (referto 17/09 §3.3), **~0,77** (`CENSIMENTO_CONTRATTI_v2.md`
r.312, un ibrido di due configurazioni), **0,847** (mio, campione pieno).

🔴 **Il testo firmato dice «operazioni/giorno» e non dice se un'operazione è una
POSIZIONE o un DEAL.** Su questo motore la differenza è un fattore **2,0117**
(misurato, `EMA200_I_DUE_REQUISITI_2026-09-12.md` §3.1) — ed è un motore
**anomalo**: lo stesso conteggio applicato a 38 file d'archivio dà **1,000
esatto** su sei motori diversi. 👉 **Su quasi tutta la flotta la domanda non si
pone; su questa sedia decide il verdetto.**

✋ **Io non scelgo, e non suggerisco quale scegliere.** Dico che:
- la scelta **esiste**, **non è mai stata fatta**, e **cambia il colore del
  semaforo su questa sedia**;
- è una **rilettura dell'unità di misura**, cioè **una firma di Claudio**,
  esattamente come lo era spostare il pavimento da sedia a famiglia il 07/09;
- 🔴 e **non è un modo per farla passare**: se si decide «posizioni», la sedia
  resta sotto e va firmata come **concentrazione consapevole**; se si decide
  «deal», allora **lo stesso metro va applicato a TUTTA la flotta**, e qualche
  sedia che oggi passa potrebbe non passare più. **Un criterio si cambia prima
  dei numeri, e vale in tutte le direzioni.**

---

# 6. 🗺️ E ALLORA COSA RAGGIUNGEREBBE IL PAVIMENTO? — la strada che esiste, e perché non entro il 1° ottobre

C'è **una** configurazione che porterebbe la famiglia sopra 1,00, e non è
nessuna delle tre del mandato: **la famiglia `EMA200` a H4, già attaccata in
forward dal 01/08** (`771511` 200AUD · `771512` AUDJPY · `771513` GBPJPY ·
`771514` SPXUSD · `771515` GBPUSD).

| cosa | numero | fonte | tag |
|---|---|---|:--:|
| edge a H4 **a tick**, 6 simboli | PFmed **1,272-1,590**, `SPXUSD` **76/84** celle positive, best DD **1,85%** | `risultati_archivio/EMA200/realtick_H4/` · `ANALISI_EMA200.md` r.48-57, riprodotto indipendentemente in `EMA200_I_DUE_REQUISITI_2026-09-12.md` §2 | **[MISURATO]** |
| costo a H4 | 🟢 **80,0-90,5×** sulla gamba 2 — **il più sicuro di tutti i TF** | `EMA200_I_DUE_REQUISITI_2026-09-12.md` §4.3 | **[MISURATO + scala]** |
| apporto di frequenza | **0,55-0,80 pos/g** (5 × 0,11-0,16) | `LA_SECONDA_SEDIA_2026-09-12.md` r.158 | 🟠 **[SECONDA MANO]** |
| apporto ricalcolato da me | **0,03-0,11 pos/g per simbolo** (deal mediani H4 / 2 / 459 feriali) | `risultati_archivio/EMA200/H4_OHLC/` + mio conteggio feriali | **[INFERITO]** |

🔴 **I due apporti non coincidono** (0,11-0,16 contro 0,03-0,11): il primo usa
celle diverse dal mio (io ho usato la **mediana** delle celle, non il picco).
**Entrambi scritti, `[NON MISURATO]` il valore vero.** In tutti e due i casi
**0,945 + l'apporto supera 1,00**.

## 🔴 E ALLORA PERCHÉ NO? **Perché il muro non è l'edge, non è il costo e non è la frequenza: è lo STORICO.**

> ## 🧱 **LO STORICO BCM SUGLI INDICI PARTE DAL `2024.09.26`. TUTTI.**
> `report/COME_ALLUNGARE_STORICO_INDICI_2026-09-09.md` **rr.80-84**:
> *«D30EUR M1 643.567 · M5 129.930 · TICK 35.496.307 — prima data **2024.09.26**;
> U30USD M1 668.718 · M5 133.819 · TICK 68.558.736 — prima data **2024.09.26**.
> NASUSD: 166,5 M tick dal 2024.09.26»* → **~21 mesi e UN SOLO REGIME (un toro).**
> **[MISURATO]**

**Conseguenza aritmetica, non opinione:** a H4 su 21 mesi il massimo che questo
motore produce su un indice è **208 deal** (`100GBP`), cioè **~104 posizioni su
tutta la finestra** — e il pavimento è **150 POSIZIONI PER FINESTRA**, cioè
**300 in totale fra IS e OOS**. 👉 **Servirebbe ~3× lo storico che esiste.**
Il merito a H4 **non è bocciato: è SOSPESO** (Emendamento B — il campione
sottile sospende il giudizio sul merito, mai sul rischio). **Non è un certificato
di morte, è un «non ancora misurabile».**

### ⏱️ La via più corta a quel numero, col costo vero
Importare lo storico lungo da HistData nei simboli `_EXT`. Stato in casa
(`COME_ALLUNGARE_STORICO_INDICI_2026-09-09.md` **rr.314-321**):

| simbolo | sorgente | disponibile | stato in casa |
|---|---|---|---|
| `SPXUSD` | `spxusd` | ✅ 2010-11 → | 🧊 **importato, in frigo** |
| `E50EUR` | `etxeur` | ✅ 2010-11 → | ⚪ **mai toccato** |
| `F40EUR` | `frxeur` | ✅ 2010-11 → | ⚪ **mai toccato** |
| `100GBP` | `ukxgbp` | ✅ 2010-11 → | ⚪ **mai toccato** |
| `200AUD` | `auxaud` | ✅ 2010-11 → | ⚪ **mai toccato** |
| `D30EUR` | `grxeur` | 🔴 inutilizzabile 2020-2023; 2010-2018 mai guardato | ❌ |

**Costo dichiarato in casa** (r.295): *«Nasdaq 2 anni (~630 giorni) = ~42 ore =
2 notti»*, e per il Dow *«2019-2024 = ~105 ore = 4-5 notti»*.
🟢 **Nota a favore**: il tetto delle ~100.000 barre del tester **non morde a H4**
— 6 anni a H4 sono **~9.000 barre**. Il vincolo è **scaricare e convertire**, non
girare.
🔴 **Ma 42-105 ore di conversione + import + screening + walk-forward a tick +
cancello di costo su simboli con spread mai misurato, in 13 giorni e su una
macchina sola, non ci sta.** E il conto delle firme resta quello del referto di
stamattina: **il conto della challenge non esiste ancora**.

---

# 7. 🚦 COSA QUESTO REFERTO **NON** FA — dichiarato

- ❌ **Non archivia niente. Nessun certificato di morte.** `E35EUR`, `200AUD` e
  `100GBP` a H1 restano **«non ancora misurati a tick»**, con scritto accanto
  perché il round non conviene **adesso** e quanto costa **dopo**. Tutta la
  famiglia H4 resta **«merito sospeso per campione»**, non morta.
- ❌ **Non propone di abbassare, spostare o reinterpretare nessuna soglia.**
  La §5.4 porta a Claudio una **domanda di unità di misura**, non una proposta
  di ammorbidimento — e dice esplicitamente che la risposta può rendere i
  criteri **più severi** altrove.
- ❌ Non propone taglie, parametri di rischio, né l'acquisto di niente.
- ❌ Non ha toccato nessun EA, preset, file prova, riga di coda o terminale, e
  non ha letto né nominato come bersaglio il conto reale `10105439`.
- ❌ **Non ha lanciato un solo backtest.** Costo macchina di questo referto: **0**.
- ⚠️ **Buchi che lascio aperti, per nome:**
  1. ⚪ **Lo spread di `SPXUSD`, `E35EUR`, `100GBP`, `200AUD`, `F40EUR`, `E50EUR`
     non esiste in casa** → il cancello di costo su di loro **non è
     calcolabile**, in nessuna direzione.
  2. ⚪ **Non so se BCM offra indici che non sono mai stati scansionati**: nel
     repo non esiste un dump del Market Watch, e i dieci indici che compaiono
     nello scan sono **tutti quelli che lo scanner aveva**, non necessariamente
     tutti quelli che il broker ha. `[NON MISURATO]`
  3. ⚪ **Le posizioni con trailing OFF** (§4.2) — la direzione è dimostrata dal
     codice, il numero no.
  4. ⚪ **Il rapporto deal/posizione fuori da `U30USD`**: il ~2,0 è misurato
     **solo** sul Dow. Ogni conversione che ho fatto su altri simboli è
     `[INFERITO]` ed è marcata come tale.
  5. ⚪ **I giorni feriali della finestra OOS**: 272 (casa) contro 276 (mio),
     non attribuito.

---

# 8. 🎯 LA CHIUSURA

> ## 🥇 **NO: la famiglia `EMA200` non arriva a 1,00 op/giorno entro il 1° ottobre.**
>
> - 🔴 **Strada SIMBOLI**: chiusa **col numero**, e il campione è **pieno** (231-389
>   deal mediani per cella) — quindi è *«non ha edge a H1 sui gemelli»*, **non**
>   *«non è misurato»*. I tre mai provati a tick sono **celle sparse** (10-27%),
>   il tick **degrada del 5%** misurato, e il **cancello di costo su di loro non
>   è nemmeno calcolabile** perché lo spread non esiste.
> - 🔴 **Strada TF**: chiusa **due volte**. Per **costo** (M30 gamba 2 a
>   **28,3-32,0×** contro 40×, e **38,4×** anche col margine +20%) e per
>   **merito** (M30: PF OOS **0,90713**, DD **15,8669%**). **Zero op/giorno
>   comprabili.**
> - 🔴 **Strada TRAILING**: sulla **frequenza** è chiusa **dal codice** (r.322:
>   la casella resta occupata più a lungo ⇒ ingressi ≤). Le uscite calano del
>   **17,4%**. 🟢 Sul **merito** resta aperta, e vale **0,75 minuti** di tester.
>
> ## 🔓 **E LA COSA CHE RESTA IN MANO A CLAUDIO, che non è mia:**
> **l'unità in cui si legge il pavimento non è mai stata firmata.** In
> **posizioni** la sedia fa **0,847-0,945** (sotto). In **deal** fa
> **1,873-1,901** (sopra, quasi doppio). 🔴 **È una firma, non una misura — e va
> presa prima di premere «inizia», non dopo.**
>
> ## 💪 E LA NOTA CHE NON È CONSOLAZIONE, PERCHÉ HA I NUMERI SOTTO
> Questa sedia è **2,0-3,3 volte più veloce di un'istanza media del campo
> misurato** (0,29-0,47 op/g per simbolo), con un **DD promesso del 7,8323%**
> contro il **45,64%** dell'unica famiglia mono-simbolo veloce che il campo ci
> ha fatto leggere. 🎯 **Il problema non è mai stato il motore: è che la
> famiglia ha un simbolo solo, e allargarla costa uno STORICO che BCM non ha.**
> 👉 **Quella è la vera commessa per dopo ottobre, ed è scritta qui col suo
> costo (42-105 ore di conversione) perché fra tre settimane nessuno se la
> ricordi.**
