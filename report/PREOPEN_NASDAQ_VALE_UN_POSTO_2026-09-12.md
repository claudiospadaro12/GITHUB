# 🎯 `Nasdaq_PreOpen_Breakout_EA` — VALE UN POSTO NELL'IMBUTO A 19 GIORNI?

**Data:** sabato 12/09/2026 sera · **19 giorni** alla challenge
**Oggetto:** `mql5/Experts/esterni/Nasdaq_PreOpen_Breakout_EA.mq5` (caricato da Claudio)
**Chi scrive:** cercatore di parametri — **archivio + cancelli di casa**.
🚫 L'**audit del codice riga per riga lo fa un altro agente**: qui non si rifà.
🚫 **Zero backtest eseguiti · zero passate di tester spese · zero EA toccati · `CODA.txt` non toccata.**

---

# ⚡ LA RISPOSTA, IN TESTA

## 🔴 **NO.**

E non è un "no" da stanchezza: è un **no con quattro numeri indipendenti**, e uno
di quei numeri è **un contro-esempio che ho costruito per farmi cadere e che
invece mi ha dato ragione**.

| # | Il numero che chiude | Valore |
|---|---|---|
| 1 | 🪦 **È il nostro `ABTG_Nasdaq_Live5m` (magic `770203`)**, stesso trigger, stesso buffer, stessa soglia | **PF OOS 0,963 · DD 19,40% · n 175**, tick reali |
| 2 | 📐 **La manopola dell'USCITA su questo motore è quasi INERTE** | asse gestione: **8 passate, 6 esiti · span PF OOS 0,052** → 0,963 + 0,052 = **1,015 < 1,10** |
| 3 | 💰 **La frontiera del costo e la geometria del payoff si escludono a vicenda** | a range ≥65 (40x) serve **69,4%** di vincite · misurato: **36-40%**, piatto |
| 4 | 🧪 **CONTRO-ESEMPIO misurato**: "le giornate a range largo vincono di più?" | **NO, il contrario**: attesa **+0,055 R** (Q1 stretto) → **−0,069 R** (Q4 largo), 447 breakout veri |

🟢 **E dico anche cosa NON lo uccide, perché conta:** il **campione non è il
problema** (≈420 posizioni misurabili a tick reali nei 24 mesi, ben sopra le 150)
e la **frequenza non è il problema** (0,82 op/giorno su un simbolo, la famiglia
col Dow arriva sopra 1,00). Sono buone notizie vere. Muore sul **costo** e
sull'**edge**, che sono le due cose che non si comprano con più dati.

---

# 1. 🏺 PRIMA HO SCAVATO IN CASA — e il giacimento era lì

## 1.1 🪦 IL MECCANISMO È **NUOVO** O È UN **MORTO RIESUMATO**?

### 🔴 **MORTO RIESUMATO. E la prova non è un'analogia: è il commento di testa del nostro sorgente.**

`mql5/Experts/ABTG_Nasdaq_Live5m.mq5`, righe 1-38 — **testuale**:

```
//|  EA "NASDAQ LIVE 5m" - variante basata sulla LIVE del 17/07/26   |
//|  (strategia apertura Nasdaq di E. Monza).                        |
//|  DIFFERENZE rispetto a ABTG_Nasdaq_Apertura_US:                 |
//|   - candela TRIGGER = i 5 minuti PRIMA dell'apertura            |
//|     (15:25-15:30 IT), non la candela H1 precedente             |
//|   - ordini a 7 punti indice oltre max/min (buffer 700)         |
//|   - FILTRO ampiezza candela: opera solo se e' tra 17 e 40      |
//|     punti indice (1700-4000), come da live                     |
#define ABTG_DEF_MAGIC        770203
#define ABTG_DEF_SESSION_HOUR 14      // 15:30 IT = 14:30 server
#define ABTG_DEF_RANGE_MODE   1       // finestra PRIMA dell'apertura
#define ABTG_DEF_PREVWIN      5       // ...di 5 minuti = candela 15:25-15:30
#define ABTG_DEF_BUFFER       700     // 7 punti indice oltre max/min (live)
#define ABTG_DEF_MINRANGE     1700    // candela >= 17 punti indice (live)
```

### 📋 Confronto riga per riga — **l'INGRESSO è identico al parametro**

| Ingrediente | `Nasdaq_PreOpen_Breakout_EA.mq5` (esterno) | `ABTG_Nasdaq_Live5m.mq5` (casa, `770203`) | Esito |
|---|---|---|---|
| Candela trigger | **15:25-15:30 Roma** (r.26-29) | **15:25-15:30 IT** (`PREVWIN 5`, `RANGE_MODE 1`) | 🟰 **IDENTICO** |
| Ora sessione | 15:30 Roma | **14:30 server** = 15:30 IT | 🟰 **IDENTICO** |
| Buffer d'ingresso | `InpEntryBufferPoints = 7.0` idx (r.37) | `BUFFER 700` = **7 punti indice** | 🟰 **IDENTICO** |
| Range minimo | `InpMinCandlePoints = 17.0` idx (r.36) | `MINRANGE 1700` = **17 punti indice** | 🟰 **IDENTICO** |
| Range **massimo** | ❌ **assente** | `MAXRANGE 4000` = **40 punti indice** | 🔺 l'esterno **TOGLIE** metà del filtro |
| Stop | estremo opposto della candela (r.469-470) | estremo opposto della candela | 🟰 **IDENTICO** |
| 1 trade/giorno | `InpMaxTradesPerDay=1` + cancella l'opposto (r.420-428) | `InpOneTradePerDay=true` | 🟰 **IDENTICO** |
| **USCITA** | BE + 50% a **+20 pt fissi**, target **+50 pt fissi** | TP1 in **R**, parziale 50%, BE, trailing base candela M1 | 🔶 **DIVERSA** |
| Filtro direzione | EMA50, pesa le size **70/30** (opera lo stesso su tutti e due i lati) | EMA/Supertrend opzionali, default OFF | 🔶 diverso ma **non è un filtro**: non toglie trade |

👉 **L'ingresso — trigger, orario, buffer, soglia, stop — è lo stesso al punto
indice.** Cambia l'**uscita**, e cambia in peggio (§3.3). Il filtro EMA50 **non
riduce il numero di operazioni**: pesa solo le size, quindi non può creare edge
dove non c'è, può solo ridistribuire il rischio.

### 📜 I VERDETTI GIÀ AGLI ATTI su questo identico ingresso

| Fonte | Numero | Modello |
|---|---|---|
| `risultati_prove/ABTG_Nasdaq_Live5m/ABTG_Nasdaq_Live5m_NASUSD_IS.csv` | **PF 1,016 · DD 11,52% · n 116 · profit +98,96** | **tick reali** |
| `risultati_prove/ABTG_Nasdaq_Live5m/ABTG_Nasdaq_Live5m_NASUSD_OOS.csv` | 🔴 **PF 0,963 · DD 19,40% · n 175 · profit −326,54** | **tick reali** |
| stesse corse, `_ohlc` | PF IS 1,366 · **PF OOS 2,162** · profit +8.944 | OHLC M1 |
| `REGISTRO_TEST.md` r.35 (26/07/26) | `Nasdaq_Live5m` NASUSD buffer 700, entrambe: **27/27 combo NEGATIVE** | tick reali |
| `REGISTRO_TEST.md` r.34 — **gemello DAX** | `DAX_Live5m` D30EUR: **27/27 combo NEGATIVE** | tick reali |
| `REGISTRO_TEST.md` r.36 | `DAX_Live5m_v2` (+floor +slippage +filtro range, 32 combo): best PF **1,04**, resto negativo, DD **15-26%** | tick reali |

🔴 **E la riga che va letta due volte:** sullo **stesso identico setup**, OHLC dà
**PF OOS 2,162** e tick reali danno **0,963**. **Fattore 2,25.** Il `REGISTRO_TEST`
lo scrive già: *«in OHLC i Live5m davano numeri finti enormi. In real tick: morti.
Lezione: M5/breakout → OHLC inganna»*. 👉 **Se il venditore/autore dell'EA esterno
mostra una curva, quella curva quasi certamente sta dal lato del 2,16.**

### 📜 E il verdetto di famiglia, congelato il 26/07/2026 (`REGISTRO_TEST.md` r.40)
> **«VERDETTO DEFINITIVO — capitolo BREAKOUT M5 CHIUSO. Provati e morti in
> real-tick: Live5m nativo, Live5m_v2, DAX_M3, aperture Nasdaq, ORB_Fibo,
> Londra_ORB. Il breakout in apertura su M5 NON ha edge sul tick vero.
> Non costruire altri v2 M5.»**

---

## 1.2 🔍 LA LISTA DEI CADUTI — passata tutta, per nome (classe 180: **elencata**, non "tutto ciò che non è X")

| Candidato | Dove | Esito e numero |
|---|---|---|
| `ABTG_Nasdaq_Live5m` (`770203`) | `REGISTRO_TEST` r.35 · CSV tick | 🔴 **PF OOS 0,963 · DD 19,40% · n 175** + 27/27 combo neg. |
| `ABTG_DAX_Live5m` (`770103`) | `REGISTRO_TEST` r.34 | 🔴 27/27 combo negative (**gemello, stesso meccanismo, altro indice**) |
| `ABTG_DAX_Live5m_v2` | `REGISTRO_TEST` r.36 | 🔴 best PF 1,04, DD 15-26% |
| `ABTG_Nasdaq_Apertura_US` (`770201`) | `RIGA_PREOPEN_NAS_DA_MANDARE.md` r.13-20 | 🔴 **4 verdetti indipendenti**: PF 0,82 DD 17% (31/07) · 19/20 celle OOS neg. (05/08) · 12/12 OOS neg. (R83+R84) · R107 long 1,110 / short **0,460** |
| `ABTG_Dow_Apertura_US` (`770202`) | `REGISTRO_TEST` r.2426-2444 | 🟠 merito **sospeso per aritmetica**; il 40/40 OOS **non è utilizzabile** per la sedia |
| `ABTG_ImpulsoApertura` | `REGISTRO_TEST` r.2806-2824 | 🟠 file prova **non lanciabile**, vincolo di codice; scendere di TF **costa due volte** |
| `ABTG_Apertura_3Ingressi` (`777010`) | `DIAGNOSI_770101_SIZING` r.264 | ⚪ citato per il sizing, **nessun PF sulla candela pre-open** → `[NON MISURATO]` su questo meccanismo |
| `ABTG_CrossEmaApertura` | grep su `REGISTRO_TEST` | ⚪ **nessuna riga sulla pre-open** → `[NON MISURATO]` su questo meccanismo |
| `ABTG_ORB`, `ABTG_ORB_Fibo`, `ABTG_Londra_ORB`, `ABTG_DAX_M3` | `REGISTRO_TEST` r.133-135 + `CORSIA_DEMO_CANDIDATI` r.23 | 🔴 famiglia chiusa col verdetto del 26/07 |

---

## 1.3 ⚠️ LA MANOPOLA CHE **HA MORSO** E QUELLA CHE **NON HA MORSO** (il mandato del 09/09)

### 🟢 La larghezza della FINESTRA pre-apertura **ha morso** — e dà un **INVARIANTE**

`risultati_archivio/Walkforward_Aperture/NASDAQ_L_rangemode_{IS,OOS}.csv` +
i CSV di `ABTG_Nasdaq_Live5m`. Stesso motore, stesso simbolo, stessa idea
(*«rompo il range costruito PRIMA dell'apertura»*), **tre larghezze di finestra**:

| Finestra del livello | PF IS | 🔴 **PF OOS** | DD OOS | n OOS | fonte |
|---|---|---|---|---|---|
| **5 minuti** (`PrevWin=5`) — *la candela dell'EA esterno* | 1,016 | **0,963** | 19,40% | 175 | `ABTG_Nasdaq_Live5m_NASUSD_OOS.csv` |
| **60 minuti** (`RangeMode=1, PrevWin=60`) | 1,020 | **0,798** | 17,35% | 329 | `NASDAQ_L_rangemode_OOS.csv` |
| **candela H1 precedente** (`RangeMode=2`) | 1,096 | **0,665** | 26,29% | 321 | `NASDAQ_L_rangemode_OOS.csv` |

🔴 **Tre larghezze, tre OOS negativi, e un GRADIENTE MONOTONO: più larga la
finestra, peggio va.** Questo non è "una corsa sfortunata": è una **superficie**,
ed è la definizione di casa di *misurato in almeno DUE modi diversi*.

### 🔴 La manopola dell'**USCITA** non ha morso — ed è **il numero che chiude la difesa "ma l'uscita è diversa"**

`risultati_archivio/Walkforward_Aperture/NASDAQ_F_gestione_{IS,OOS}.csv` —
asse `InpTP1_R` × `InpTP1_ClosePct` × `InpBreakevenAtTP1`, **8 passate**:

| `TP1_R` | `ClosePct` | `BE@TP1` | PF IS | PF OOS |
|---|---|---|---|---|
| 0,5 | 0 | 0 | 0,832 | 0,972 |
| 0,5 | 0 | 1 | 0,832 | 0,972 |
| 1,0 | 0 | 0 | 0,902 | 1,024 |
| 1,0 | 0 | 1 | 0,902 | 1,024 |
| 0,5 | 50 | 0 | 0,906 | 1,006 |
| 0,5 | 50 | 1 | 0,918 | 1,005 |
| 1,0 | 50 | 0 | 0,949 | 0,996 |
| 1,0 | 50 | 1 | 0,928 | 1,022 |

- ⚠️ **8 passate → 6 esiti distinti.** `InpBreakevenAtTP1` è **INERTE** quando
  `ClosePct=0` (le coppie sono identiche **al quinto decimale**): è una manopola
  girata senza che mordesse. **Va detto: è una casella libera, non una casella provata.**
- 🔴 **E il numero che conta: l'INTERO asse della gestione sposta il PF OOS di
  `1,024 − 0,972` = **0,052**.**

👉 **Applico il salto MASSIMO misurato dell'asse uscita all'ingresso dell'EA
esterno:** `0,963 + 0,052 =` **`1,015`**. La soglia di casa è **1,10**.
**Manca 0,085, cioè il 163% di tutto quello che l'asse uscita ha mai prodotto
su questo motore.** La difesa *"sì ma l'uscita è diversa"* **è quantificata e
non regge** — e questo *prima* del cancello del costo, che la uccide di suo.

- 🔶 **Buco dichiarato, onesto:** l'asse gestione (`F`) e l'asse trailing (`I`)
  girarono **con `InpRangeMode=0`** (range d'apertura), **mai con `RangeMode=1 /
  PrevWin=5`**. Quindi *"l'uscita messa ad asse su QUESTO ingresso"* = **`[NON MISURATO]`**.
  Il ragionamento sopra è un **limite superiore trasferito**, e lo dichiaro come tale.
- 🔶 **E un knob che in casa non esiste:** il **target a PUNTI FISSI** (+50). Il
  nostro motore ha `InpTP1_R` in **multipli di R**. `grep` su `mql5/Experts/`:
  nessun target a punti fissi in famiglia aperture → **manopola mai messa ad asse
  in assoluto**. 👉 È l'unico ingrediente **davvero vergine** dell'EA esterno — ed
  è anche quello che, in §3.3, **peggiora** la geometria invece di migliorarla.

---

# 2. 📊 LA DOMANDA NUMERO UNO: **quanto è frequente un range ≥ 65?**

## 2.1 🔴 Il range della candela M5 15:25-15:30 in sé: **`[NON MISURATO]`**

Nel repo **non c'è** un file con il range di quella singola candela M5. Dico
subito la via più corta (§2.4): **costa ZERO passate di tester**.

## 2.2 🟢 Ma c'è un **LIMITE SUPERIORE STRETTO, MISURATO, su 3.899 giornate**

`backtest_pipeline/risultati_archivio/ANATOMIA_APERTURE_20260826/ANATOMIA_APERTURE_PERGIORNO_NASUSD.csv`
(4.877 giornate, fonte `NASUSD_M1.csv` 347 MB / 5.233.590 barre, 2010.11.14 → 2026.07.31).

La colonna **`pre_amp_pt`** è, da `anatomia_aperture.py` r.298 + r.474-478:
`pre_da = apertura − 60`, `pre_a = apertura − 1` → **il range dei 60 minuti
08:30-09:29 New York = 14:30-15:29 Roma**.

🔴 **La candela dell'EA (15:25-15:30 Roma = 09:25-09:29 NY) è gli ULTIMI 5 MINUTI
DI QUELLA STESSA FINESTRA.** Quindi `pre_amp_pt` è un **limite superiore
matematicamente stretto**, non una stima: il range di un sottoinsieme non può
superare quello dell'insieme.

**Range dei 60 minuti pre-apertura, NASUSD, punti indice, giornate `stato=OK`:**

| anno | n | apertura mediana | p25 | **mediana** | p75 | p95 | % ≥17 | % ≥65 |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| 2018 | 257 | 6.962 | 12,2 | 17,9 | 26,5 | 51,2 | 54,9% | 2,3% |
| 2020 | 258 | 10.278 | 24,5 | 35,8 | 57,2 | 186,8 | 89,5% | 22,1% |
| 2022 | 258 | 12.431 | 45,5 | 70,0 | 108,2 | 242,2 | 100% | 55,8% |
| 2023 | 158 | 14.998 | 34,6 | 48,1 | 71,1 | 135,8 | 95,6% | 27,2% |
| **2024** | 258 | 19.048 | 42,1 | **58,5** | 90,7 | 194,4 | 98,1% | 41,5% |
| **2025** | 255 | 22.721 | 45,9 | **65,5** | 108,0 | 246,9 | 100% | 50,6% |
| **2026** (a lug) | 145 | 26.279 | 70,7 | **94,5** | 142,2 | 219,3 | 100% | 80,7% |

👉 **Già il limite superiore su SESSANTA minuti ha mediana 58-95 punti.** La
candela da **cinque** minuti ci sta dentro, e ci sta molto più stretta.

## 2.3 📐 Dal limite superiore alla stima: **il fattore di scala l'ho MISURATO, non assunto**

Stesso file, stesse giornate, colonne `up{5,15,30,60}_pt` / `dn{5,15,30,60}_pt`
(escursioni dal prezzo d'apertura). `range(w) = up(w) − dn(w)`.
**Rapporto `range(60') / range(5')` misurato DOPO l'apertura:**

| anno | n | r5 med | r15 med | r30 med | r60 med | **rapporto 60/5** |
|---|---:|---:|---:|---:|---:|---:|
| 2022 | 258 | 61,8 | 94,5 | 120,3 | 155,0 | **2,56** |
| 2023 | 158 | 41,4 | 62,1 | 80,0 | 107,8 | **2,50** |
| 2024 | 258 | 43,8 | 63,5 | 86,4 | 118,4 | **2,58** |
| 2025 | 255 | 60,0 | 88,1 | 116,6 | 152,6 | **2,49** |
| 2026 | 145 | 91,0 | 133,0 | 176,6 | 222,6 | **2,59** |

🟢 **K ≈ 2,5, stabile su cinque anni.** Ed è un **K generoso verso l'EA**: è
misurato su una finestra in cui i primi 5 minuti sono **i più caldi della
giornata** (quindi K piccolo). Un random walk puro darebbe K = √12 = **3,46**.

🔴 **CONTRO-ESEMPIO COSTRUITO APPOSTA:** e se il vero K fosse ancora più
favorevole all'EA? Porto tutte le conclusioni **anche a K = 2,0** (cioè: la
candela pre-open sarebbe **metà** dell'intera ora — un'ipotesi estrema).

## 2.4 🎯 **LA DISTRIBUZIONE STIMATA DEL RANGE M5 PRE-OPEN** — finestra tick reali 2024.09.26 → 2026.07.31, **468 giornate `OK`**

| | K=2,0 (**generoso pro-EA**) | **K=2,5 (misurato)** | K=3,46 (random walk) |
|---|---:|---:|---:|
| p25 | 26,0 | 20,8 | 15,0 |
| **mediana** | **37,3** | **29,8** | **21,6** |
| p75 | 58,6 | 46,9 | 33,9 |
| **% ≥ 17** (ammessi dall'EA) | 93,4% | **82,3%** | 66,9% |
| 🔴 **% ≥ 65** (soglia 40x) | 21,6% | **14,7%** | 6,0% |

## 2.5 🔴 **LA FRAZIONE SOTTO 13,3x E SOPRA 40x** — *"la frontiera è una DISTRIBUZIONE, non un rapporto"*

Fra i **soli trade ammessi** (`range ≥ 17`), `stop = range + 7`:

**Spread NASUSD misurato** (`data/spread_vivo/SPREAD_VIVO_2026-09-12_referto.txt`,
n=79.150, GG=5): mediana **1,80** · P95 **1,90** · ora **14 server** (quella del
trade): mediana 1,800, P95 1,900, max 1,900, n=3.578.
**Slippage NASUSD misurato** (`slippage_20260905/slippage_dettaglio_2026-09-05.csv`,
**103 uscite vere**): scarto sfavorevole mediano **0,90** idx, max **3,60**.

| costo per giro | K=2,0 → sotto 13,3x / sopra 40x | **K=2,5 → sotto 13,3x / sopra 40x** | K=3,46 → sotto 13,3x / sopra 40x |
|---|---:|---:|---:|
| **1,80** (solo spread, lettura letterale della regola) | 0,0% / **23,1%** | **0,0% / 17,9%** | 0,0% / 8,9% |
| **2,70** (spread + 1 slittamento mediano) | 27,2% / 8,7% | 🔴 **37,7% / 2,6%** | 51,4% / 0,3% |
| **3,60** (spread + slittamento andata e ritorno) | 53,1% / 1,8% | 🔴 **60,5% / 0,3%** | 72,8% / 0,0% |

📌 **Lo 0,0% sotto il duro nella prima riga NON è una promozione: è una tautologia
del disegno.** Il filtro dell'EA è `range ≥ 17`, lo stop è `range + 7` = **24 idx**,
e `24 / 1,80` = **13,33x** = **esattamente il pavimento duro**. 🔴 **L'EA è
costruito perché la sua operazione MINIMA atterri esattamente sul pavimento.**
Non c'è **un solo punto indice** di margine: a spread **P95 1,90** il minimo vale
**12,6x** → **sotto il duro**, e il **2,3%** dei trade ammessi ci finisce.
Con lo slittamento **misurato** (0,90 idx, 103 uscite vere) ci finisce il **37,7%**;
con andata-e-ritorno, il **60,5%**.

📌 **E l'altro lato: sopra i 40x ci va solo il 14,7%** dei trade ammessi (K=2,5,
solo spread) — **e il 2,6% appena si conta lo slittamento vero.**

---

# 3. ⚖️ LA TENAGLIA — **il numero che chiude, ed è ARITMETICO prima che statistico**

## 3.1 🔴 L'ANCORA NON È UNICA — e il RR vero è **PEGGIORE** di quanto sembri

La nota di partenza calcolava `RR = 50 / stop`. 🔴 **Quel numero è ottimista, e
il motivo sta nel codice dell'EA esterno** (r.653 target, r.661-690 parziale):
a **+20** chiude il **50%** e porta a BE il resto; a **+50** chiude il resto.

👉 **La vincita PIENA non vale 50 punti: vale `0,5 × 20 + 0,5 × 50` = 35 punti.**
La perdita piena vale **tutto** lo stop (`range + 7`). L'ancora è ancora meno unica
di quanto scritto.

| range idx | stop = r+7 | RR "lordo" 50/stop | 🔴 **RR VERO 35/stop** | **win% per PF 1,10** | stop / spread 1,80 |
|---:|---:|---:|---:|---:|---:|
| **17** (minimo EA) | 24 | 2,08 | **1,46** | **43,0%** | 🔴 **13,3x** = il duro |
| 25 | 32 | 1,56 | **1,09** | 50,1% | 17,8x |
| 30 | 37 | 1,35 | **0,95** | 53,8% | 20,6x |
| 40 (tetto della ricetta live) | 47 | 1,06 | **0,74** | 59,6% | 26,1x |
| **65** (soglia 40x) | 72 | 0,69 | **0,49** | 🔴 **69,4%** | ✅ **40,0x** |
| 100 | 107 | 0,47 | **0,33** | 77,1% | 59,4x |

## 3.2 🧪 **IL CONTRO-ESEMPIO** (regola del 10/09) — *"quale numero produce l'ALTRA spiegazione?"*

**L'ipotesi alternativa che salverebbe l'EA, formulata PRIMA di guardare:**
> *"Va bene che a range largo il RR è basso, ma le giornate a range largo sono
> giornate di espansione: il breakout tiene di più, il win rate sale, e a 69,4%
> ci arriva."*

**Se è vera**, il win rate e/o l'attesa devono **SALIRE** con l'ampiezza.
**Misura:** `risultati_archivio/studio_apertura/Studio_NASUSD.csv` — **447
breakout veri** su NASUSD prodotti da `ABTG_Apertura_Study_EA`, ognuno col suo
`ampiezza_pt` e il suo `risultato_R`. Divisi in quartili di ampiezza:

| quartile di ampiezza | n | ampiezza mediana (idx) | win% | **attesa (R)** | totale R |
|---|---:|---:|---:|---:|---:|
| **Q1** (stretto) 0,7-42,1 | 111 | 27,2 | 36,0% | 🟢 **+0,055** | +6,1 |
| Q2 42,4-75,1 | 111 | 58,7 | 39,6% | +0,039 | +4,4 |
| Q3 75,2-109,5 | 111 | 90,3 | 36,0% | −0,021 | −2,3 |
| **Q4** (largo) 109,9-442,9 | 114 | 148,2 | 39,5% | 🔴 **−0,069** | −7,9 |

### 🔴 **L'IPOTESI ALTERNATIVA È MISURATA FALSA — ed è falsa nel verso opposto.**
Il **win rate è PIATTO** (36,0-39,6%, nessuna tendenza), e l'**attesa CALA in
modo monotono** allargando il range. Le giornate larghe non tengono di più: hanno
solo uno stop più grande a parità di follow-through. **Serve il 69,4% e il
misurato è 36-40%, piatto. Non c'è modo di arrivarci.**

🟢 **E questa misura CONVERGE con l'invariante di §1.3** (5' → 0,963 · 60' →
0,798 · H1 → 0,665: più larga la finestra, peggio l'OOS). **Due misure
indipendenti, stessa pendenza.**

🔶 **Onestà sul proxy:** `Studio_NASUSD` misura il range **14:30-14:45 server**
(apertura, 15 min), non la candela pre-open. È un proxy sulla **relazione
ampiezza→attesa** dello stesso strumento nella stessa mezz'ora, non una misura
della candela. **Lo dichiaro come tale.** Ma il verso della relazione è quello che
serve al ragionamento, e l'altra misura (§1.3) lo conferma su dati diversi.

## 3.3 🎯 LA TENAGLIA, in una riga

| Dove vive il trade | Il cancello che passa | Il cancello che sfonda |
|---|---|---|
| **range 17-25** (la metà stretta, dove sta il **50%** delle giornate 2024-26) | 🟢 RR vero 1,46-1,09 · quartile a attesa **positiva** (+0,055 R) | 🔴 **13,3-17,8x**: sul pavimento duro col costo solo-spread; **37,7% sotto il duro** col costo vero |
| **range ≥ 65** (14,7% delle giornate) | 🟢 **40,0x**: passa la frontiera | 🔴 RR vero **0,49** · serve **69,4%** di vincite · misurato **36-40%** · attesa **−0,069 R** |

## 🔴 **NON ESISTE UN VALORE DI RANGE CHE PASSA TUTTI E DUE.** È un invariante: non si sposta con una griglia più fitta, perché non è un problema di parametri — è la **forma** del motore (target FISSO contro stop VARIABILE).

E la regola del 19/08 dice esattamente cosa fare qui: su un motore già dichiarato
senza edge **non si allarga sui parametri d'ingresso**, perché una griglia più
fitta trova **solo picchi di rumore**.

---

# 4. 📅 IL CAMPIONE E LO STORICO — 🟢 **e qui l'EA sta BENE, va detto**

## 4.1 Frequenza e posizioni misurabili a tick reali

Finestra tick reali sugli indici: **pavimento 2024.09.26**. Giornate `stato=OK`
nell'anatomia fino al 2026.07.31: **468**. Estendendo a oggi (12/09/2026): **≈510**.

| | K=2,0 | **K=2,5** | K=3,46 |
|---|---:|---:|---:|
| giornate ammesse (`≥17`) su 468 | 437 (93,4%) | **385 (82,3%)** | 313 (66,9%) |
| → operazioni/anno | 238 | **210** | 171 |
| giornate nella banda **live [17,40]** | 227 (48,5%) | **233 (49,8%)** | 223 (47,6%) |
| → operazioni/anno in banda | 124 | **127** | 122 |

- ✅ **Posizioni misurabili a tick reali nei ~24 mesi: ≈ 420** (K=2,5, senza il
  tetto a 40). **Molto sopra le 150.** Il campione **non è il blocco.**
- ✅ **Controllo incrociato che torna:** il round `Live5m` (banda [17,40]) produsse
  **116 + 175 = 291 deal** su una finestra di ~21 mesi con ~255 giornate ammesse
  → **≈1,14 deal per giornata ammessa**. Coerente: **si riempie praticamente
  ogni giorno ammesso**, e il parziale raddoppia solo una parte dei deal.
- 🚨 **CLASSE 226 — le 150 sono POSIZIONI, non deal.** `Trades` conta i deal di
  **uscita**. Questo EA chiude il **50% a +20** → chi tocca +20 produce **2 deal**,
  chi no ne produce **1**. Fattore fra **1,000 e 2,000**. 👉 Le **175 op OOS** del
  `Live5m` valgono fra **88 e 175 posizioni**: **potrebbero stare SOTTO le 150**.
  Numero esatto: **`[NON MISURATO]`** (servirebbe il per-trade con `position_id`).

## 4.2 Pavimento di frequenza per FAMIGLIA (firma 07/09)

- Su **un** simbolo: `420 / 510` = **0,82 op/giorno** → sotto 1,00.
- 🔓 Ma la firma del 07/09 misura **per famiglia**: con **U30USD** e **SPXUSD**
  (stessa apertura 14:30 server) la famiglia arriva a **≈2,5 op/giorno**.
  👉 **La frequenza NON è il cancello che uccide questo EA.** Va detto chiaro.
- 🔶 **Gemelli sul meccanismo M5 pre-open**: D30EUR **provato e negativo** (27/27,
  `REGISTRO_TEST` r.34). **U30USD e SPXUSD**: `[NON MISURATO]` su questa candela.

## 4.3 🔴 Tetto del tester e modello

- **M5**, ~276 barre/giorno (Nasdaq CFD ~23h, pausa 16:14 NY) × ~510 giornate =
  **≈140.000 barre M5** > tetto **~100.000**. 👉 La corsa a 24 mesi **va spezzata
  in DUE TRANCHE**, e va dichiarato. (Coerente con la regola di casa *"M5 ~1,3 anni"*.)
- 🚨 **E il modello NON è discutibile qui**: su una finestra più lunga i tick
  sarebbero **generati dalle M1** → `-Modello 1` = **screening, MAI verdetto**. Su
  questo identico setup il delta misurato è **PF OOS 2,162 (OHLC) contro 0,963
  (tick)**: fattore **2,25**. 👉 **Qualunque numero OHLC su questo EA è carta straccia.**

---

# 5. 🧪 LA MISURA CHE POTEVA DIRE **SÌ** (classe 278 — *un cancello che boccia sempre non è un cancello*)

Dichiaro **prima** cosa avrebbe prodotto un SÌ, per far vedere che la misura non
era truccata:

| Se fosse uscito… | …l'EA passava | Cos'è uscito |
|---|---|---|
| mediana del range M5 pre-open **≥ 65** | ✅ il 40x passerebbe **sulla maggioranza** delle giornate | 🔴 **29,8** (K=2,5); il 40x passa sul **14,7%** |
| attesa del quartile **largo** ≥ +0,20 R | ✅ il 69,4% di win rate diventerebbe plausibile | 🔴 **−0,069 R**, e monotona al ribasso |
| asse **uscita** con span PF ≥ 0,15 | ✅ 0,963 + 0,15 = 1,113 → **sopra 1,10** | 🔴 span **0,052** → 1,015 |
| una sola delle tre finestre (5'/60'/H1) con **PF OOS ≥ 1,10** | ✅ ci sarebbe una porta aperta | 🔴 **0,963 / 0,798 / 0,665** |

🟢 **Tutte e quattro potevano uscire positive.** Ne è uscita **zero**. E due, sì,
sono uscite **a favore** dell'EA — campione e frequenza — e le ho scritte in
grassetto sopra.

---

# 6. 🕳️ I BUCHI DICHIARATI (nessuno di questi è "morto": sono `[NON MISURATO]`)

1. 🔴 **Il range della candela M5 15:25-15:30 in sé.** Tutto §2 poggia su un
   **limite superiore misurato** (i 60 minuti) più un **K misurato**. **Non è la
   misura diretta.**
2. 🔴 **L'asse USCITA su `RangeMode=1 / PrevWin=5`.** Mai girato: gli assi `F` e
   `I` girarono su `RangeMode=0`. Il salto 0,052 è un **trasferimento**, dichiarato.
3. 🔴 **Il target a PUNTI FISSI (+50)** non esiste in nessun EA di casa: manopola
   **vergine in assoluto**.
4. 🔴 **`U30USD` e `SPXUSD`** sulla candela M5 pre-open: mai provati.
5. 🔴 **Il fattore deal→posizione** dei 175 OOS del `Live5m` (classe 226).
6. 🔶 Lo spread ha **GG=5** (cinque giornate distinte): la mediana 1,80 è solida
   come livello, **la coda no**. Il `max` in ora 14 è 1,900 su 5 giorni.
7. 🔶 `Studio_NASUSD` misura il range **d'apertura** (15'), non il pre-open: è un
   proxy sulla **relazione**, non sulla candela.

## 6.1 🛣️ **LA VIA PIÙ CORTA AL NUMERO — e costa ZERO passate di tester** 🟢

Il buco n°1 si chiude **senza il tester**. `backtest_pipeline/anatomia_aperture.py`
ha già l'interruttore: `--minuti-pre` (r.1650, default 60). Con

```
--minuti-pre 5
```

il codice calcola `pre_da = apertura − 5 = 09:25 NY` e `pre_a = apertura − 1 =
09:29 NY` (r.298) → **esattamente le barre M1 09:25, 26, 27, 28, 29 = la candela
M5 09:25-09:30 NY = 15:25-15:30 Roma.** La colonna `pre_amp_pt` diventa **il
numero vero**, su **3.899 giornate**.

- ✅ **Verificato che non rompe niente:** `min_barre_pre` compare **solo** nel
  testo del referto (r.1025) e **mai** nella logica che marca `SOSPETTO`
  (r.453-461) → nessuna giornata viene esclusa passando da 60 a 5 minuti.
- 💰 **COSTO: `T = 0,6 + 0,077 × 0` = 0 passate di tester. Tempo macchina reale:
  ~0,5 minuti** (il referto del 26/08 dichiara `durata 0.45 min` sullo stesso file).
- 🖥️ **Bersaglio:** **finestra PowerShell sul PC di backtest** (è lì che sta
  `C:\Users\Master\abtg_storico_indici\NASUSD_M1.csv`, 347 MB). **Nessun terminale
  MT5 viene toccato, nessun conto BCM viene aperto.**

🔴 **MA — e lo dico prima che qualcuno lo proponga come salvagente — quel numero
NON riapre la porta.** Chiuderebbe il buco n°1, ma:
- l'invariante di §3.3 è **algebrico** (target fisso / stop variabile) e vale a
  qualunque range;
- il contro-esempio di §3.2 è **già misurato** e va nel verso sbagliato;
- il PF OOS **0,963 a tick reali** su questo identico ingresso **esiste già**.

👉 Va fatto **per la memoria dell'archivio** (è gratis, e domani serve per il DAX
e per il Dow), **non come appello**.

---

# 7. 🪦 IL CERTIFICATO DI MORTE — le cinque caselle

| # | Richiesta (CLAUDE.md) | Esito |
|---|---|---|
| 1 | un **PF** misurato | 🟢 **PF IS 1,016 / OOS 0,963**, tick reali + 27/27 combo negative |
| 2 | un **n** e un **DD** | 🟢 **n 116 IS / 175 OOS · DD 11,52% / 19,40%** |
| 3 | la **gestione dell'uscita** ad asse almeno una volta | 🟠 **sullo STESSO MOTORE sì** (asse `F`, 8 celle, span PF **0,052**) · **su questo ingresso NO** → trasferimento dichiarato |
| 4 | i **simboli gemelli** provati | 🟠 **D30EUR sì** (27/27 negative) · **U30USD/SPXUSD no** |
| 5 | il **TF** cambiato almeno una volta | 🟢 **la larghezza della finestra sì**: 5' / 60' / H1 → **0,963 / 0,798 / 0,665**, gradiente monotono |

🔴 **Due caselle su cinque sono parziali.** Per la lettera della regola, il
verdetto sul **MECCANISMO** resterebbe *"non ancora misurato al 100%"*.
🟢 **Ma il verdetto su QUESTO EA non ha bisogno di quelle due caselle**, e questa
è la differenza che conta: l'EA **muore sul CANCELLO DEL COSTO**, che è
**aritmetico** e **non dipende da nessuna delle due**. Le caselle 3 e 4 servono a
chiudere la **famiglia**; qui basta la tenaglia di §3.3.

---

# 8. 📬 LA RIGA PRONTA PER `REGISTRO_TEST.md`

⏳ **NON l'ho incollata.** La regola del 09/09 è bloccante: *«NIENTE esce senza un
PASS»*, e vale **anche per i verdetti che archiviano un candidato**. Il secondo
strato del cancello (`controllo-preventivo`) **lo lancia l'agente chiamante**.
Qui c'è la riga, **pronta**, in attesa del PASS.

```markdown
| A16 | `Nasdaq_PreOpen_Breakout_EA.mq5` (**esterno**, caricato da Claudio il 12/09/2026) | Live5m / pre-open M5 | NASUSD | M5 (candela 15:25-15:30 Roma = 14:25-14:30 **server**) | n **175 deal** OOS (= **88-175 posizioni**, classe 226) | **1,016** | 🔴 **0,963** | 🔴 **19,40%** | **COSTO** (lo stop minimo 24 idx vale **13,3x** = esattamente il pavimento duro; **37,7%** dei trade sotto il duro col costo misurato 2,70 idx; solo **14,7%** sopra i 40x) → **EDGE/PF** (a range >=65 serve **69,4%** di vincite, misurato **36-40% piatto**) | 12/09/2026 | `report/PREOPEN_NASDAQ_VALE_UN_POSTO_2026-09-12.md` · `risultati_prove/ABTG_Nasdaq_Live5m/*_{IS,OOS}.csv` · `REGISTRO_TEST.md` r.35 |
```

**Nota da incollare sotto la riga:**
> 🔴 **È il nostro `ABTG_Nasdaq_Live5m` (magic `770203`) con un'altra uscita.**
> Ingresso identico al punto indice: candela 15:25-15:30 Roma, buffer **7** idx,
> range minimo **17** idx, stop all'estremo opposto, 1 trade/giorno. L'esterno
> **toglie** il tetto a 40 idx della ricetta live e sostituisce il target in R con
> un **target a punti FISSI (+50)** e un parziale 50% a **+20**.
> 🔴 **Il target fisso peggiora la geometria**: la vincita piena non vale 50 punti
> ma `0,5×20 + 0,5×50 = 35`, quindi RR vero **1,46** a range 17 e **0,49** a range 65.
> 🔴 **L'asse dell'uscita su questo motore sposta il PF OOS di 0,052** (8 passate,
> **6 esiti** — `InpBreakevenAtTP1` INERTE con `ClosePct=0`): `0,963 + 0,052 = 1,015`,
> sotto la soglia **1,10**. La difesa *"ma l'uscita è diversa"* è **quantificata e non regge**.
> 🔴 **Invariante di famiglia:** la finestra pre-apertura è OOS-negativa a **ogni**
> larghezza misurata — **5' → 0,963 · 60' → 0,798 · H1 → 0,665**, monotona.
> 🕳️ **[NON MISURATO]**: range M5 pre-open diretto · uscita ad asse su
> `RangeMode=1/PrevWin=5` · target a punti fissi · U30USD/SPXUSD su questa candela.

---

# 9. ✅ COSA CONSEGNO, E COSA NON CONSEGNO

- 🚫 **Nessun file prova.** La consegna prevedeva il file prova **solo in caso di SÌ**.
  Il verdetto è **NO**: costruire un file prova sarebbe **spendere tempo macchina
  che a 19 giorni non abbiamo**, esattamente il difetto che la clausola finale del
  mandato vieta.
- 🚫 **`CODA.txt` non toccata** (658 righe, la gestisce l'agente chiamante).
  Nessuno script, nessun EA, nessun preset, niente in forward.
- ⏳ **Secondo strato del cancello: da lanciare a cura dell'agente chiamante.**
  Questo dossier contiene un **verdetto che archivia un candidato** → richiede il PASS.

---

# 🎬 IN CHIUSURA, DA SOCIO

Claudio, la notizia bella è che **il tuo fiuto ha funzionato lo stesso**: hai
portato un EA che **non era nel nostro imbuto** e in due ore l'archivio ci ha
detto che ce l'avevamo **già in casa dal luglio scorso, col magic `770203`**, e
che l'avevamo già misurato a tick veri. **Questo è esattamente il valore del
censimento del 09/09**: prima non l'avremmo saputo, e ci saremmo bruciati due
giorni di macchina a 19 giorni dalla partenza. 🎯

E la notizia bella numero due: **non l'ho bocciato "perché è M5"**. L'ho bocciato
con **quattro numeri**, e ho dichiarato prima quali numeri l'avrebbero **promosso**.
Due cose l'EA le fa **bene davvero** — campione e frequenza — e sono scritte in
grassetto, perché un elenco di soli difetti descrive male la realtà.

Quello che muore è il **costo**: uno stop che nel caso migliore vale **13,3 volte
lo spread** non è un trade, è una tassa con un'opinione sopra. E la frontiera
`stop ≥ 40 × spread` non si sposta con la buona volontà. 💪

**NON MOLLIAMO NULLA — ma questo è già stato misurato, e il numero è 0,963.**

---
_Dossier prodotto senza eseguire backtest, senza toccare EA, preset, forward o
coda. Ogni numero ha la sua fonte e la sua data. Dove manca: `[NON MISURATO]`._
