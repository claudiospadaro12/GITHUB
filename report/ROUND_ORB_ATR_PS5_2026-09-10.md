# 🧪 ROUND ORB / PS5 — **il round che puo' produrre una sedia**

**Data: 10/09/2026.** Nasce dal documento master del collega (Marco Garbuglia,
"PS5 ORB Bot", v2.60) letto in
`backtest_pipeline/caccia_strategie/PS5_ORB_MASTER_LETTURA_2026-09-10.md`, e dal
cancello del costo di `report/ORO_1530_CANCELLO_COSTO_2026-09-10.md`.

> 🛑 **Questo dossier non tocca niente.** Nessun backtest eseguito, nessun EA
> modificato, nessun parametro in forward cambiato, nessun candidato promosso.
> Porta **misure**, una **griglia** e **sei file prova gia' passati dal
> cancello**. Le decisioni sono di Claudio.

---

# 0. 🥇 LE CINQUE RIGHE CHE RESTANO

1. 🎉 **NON DOBBIAMO CERCARE LA CELLA CHE PASSA IL CANCELLO DEL COSTO: CE
   L'ABBIAMO GIA', ED E' GIA' MISURATA A TICK.** Il cancello di casa
   `stop >= 40 x spread` chiede su U30USD **80,0 punti indice** di stop
   (spread mediano ora 14 **2,00**, MISURATO su 4,93 M tick). La cella viva
   (HALFRANGE) ne ha **~47** = **23,5x** → **non passa**. La cella
   **OPPRANGE** ne ha **~104** = **52,0x** → **passa con +30% di margine** —
   ed e' lo stesso ramo che R88 aveva gia' misurato migliore fuori campione:
   **le TRE celle esistenti fanno PF OOS 1,762 / 1,839 / 1,645 e DD OOS
   4,20% / 3,84% / 4,40% su n=119 — tutte e tre sopra R125-G3 (1,40) e tutte e tre
   sotto R125-G1 (7,00%).**
   🔴 **Ma con la nostra regola quella non e' ancora una cella scelta**: vedi
   §3.4, dove il contro-esempio mi ha corretto.
2. 🔓 **E non era stata bocciata per un numero brutto: per un numero
   MANCANTE.** Il cancello che la fermava era **PF IS >= 1,10** contro **1,063**,
   applicato a **n IS = 71** — e l'Emendamento A del 16/08 dice che **sotto
   150 operazioni il MERITO e' sospeso**. Lo scrive R88 stesso nel proprio
   file prova. E' il caso esatto del motto del 09/09: *"se e' fermo per un
   numero mancante, si trova la via piu' corta al numero"*.
3. 🔴 **LA MANOPOLA PRINCIPALE DEL COLLEGA — LA GEOMETRIA ATR SU D1 — NON E'
   PROVABILE OGGI, e non per pigrizia**: `iATR` su **D1 non popola nel tester
   Modello 4 su simbolo NATIVO BCM**. E' **PROVATO** con un discriminante a
   soglie sempre-vere (`REFERTO_CRT_2026-08-30.md`: 0 trade su 2.573 pattern).
   Serve un **fix dell'EA** e la **validazione del fix**. Fuori da questo round,
   dichiarato, con il costo scritto (§6).
4. 🔧 **Due cose riportate dal documento del collega vanno corrette sui
   nostri fatti**: (a) **l'ampiezza minima di range CE L'ABBIAMO**
   (`InpMinRangePct`, r.200 del `.mq5`, agganciata a r.503) — non e' mai stata
   **girata**, che e' un'altra cosa; (b) **lo spread nell'ora del trade E'
   MISURATO**, ora per ora, da **252 milioni di tick** — quello che manca e' la
   granularita' al **minuto** dentro 14:30-14:45.
5. 💰 **Il round costa 66 passate ≈ 7 minuti di macchina** (modello di costo
   MISURATO: R88, 136 passate in **13,7 min** = **0,101 min/passata** su questo
   identico EA/simbolo/TF). Sei file, **un asse ciascuno**, tutti e sei
   **PASS** a `controlla_prova.py`.

---

# 1. 🏺 COSA E' GIA' STATO PROVATO — con le fonti, riga per riga

## 1.1 L'ORB nell'archivio: 33 righe nel censimento del 09/09

Da `risultati_archivio/CENSIMENTO_PF_TUTTI_2026-09-09.csv`, filtrate le righe
`ORB*`. Ordinate per PF OOS mediano:

| motore | simbolo | etichetta | passate IS | **uniche IS** | PF IS med | n IS | **PF OOS med** | **PF OOS max** | n OOS |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|
| ORB_Ott | U30USD | r44a | 4 | 4 | 1,286 | 71 | **1,736** | 1,955 | 119 |
| ORB_Ott | U30USD | R119/ANCORA | 2 | **1** | 1,231 | 71 | 1,675 | 1,675 | 119 |
| ORB_Ott | U30USD | r88c | 4 | **2** | 1,154 | 74 | 1,674 | 1,687 | 119 |
| ORB_Ott | U30USD | r55b | 10 | **5** | 1,192 | 71 | 1,617 | 1,674 | 119 |
| ORB_Ott | U30USD | r118a | 25 | 25 | 1,008 | 71 | 1,566 | 1,674 | 119 |
| ORB_Ott | U30USD | r88a | 48 | **24** | 1,037 | 71 | 1,554 | **1,844** | 119 |
| ORB | NASUSD | ohlc | 2 | **1** | 0,945 | 220 | 1,248 | 1,248 | 357 |
| ORB_Ott | U30USD | r14 | 24 | 24 | 1,117 | 134 | 1,174 | 1,405 | 119 |
| ORB_Ott | U30USD | r15 | 64 | 62 | 0,994 | 107 | 1,166 | 1,680 | 172 |
| ORB_Ott | NASUSD | r44b | 4 | 4 | 1,058 | 74 | 1,111 | 1,156 | 135 |
| ORB_Ott | **D30EUR** | **r11** | **4** | 4 | 1,228 | 115 | **0,995** | 1,022 | 233 |
| ORB_Ott | NASUSD | r13 | 48 | 48 | 0,922 | 127 | 1,027 | 1,156 | 217 |
| ORB_Ott | NASUSD | r12 | 48 | **24** | 0,977 | 171 | 0,800 | 0,916 | 267 |
| ORB_Ott | XAUUSD/EURUSD/GBPUSD | r10/r45 | 4-8 | — | 0,64-0,76 | — | 0,63-0,88 | — | — |

### 🔎 Le manopole INERTI che si leggono da qui
La colonna **uniche IS** contro **passate IS** e' la firma:
- **r88a: 48 passate → 24 esiti distinti.** Meta' del round non ha morso — ed
  era **previsto e dichiarato** nel file prova (con `InpTPMode=1` l'input
  `InpTP_R` e' inerte, perche' lo legge solo `ManageTP1` che esce subito con
  `InpTP1Pct=0`). ✅ **Inerzia dichiarata prima = controllo gratis, non spreco.**
- **r12: 48 → 24** e **r55b: 10 → 5**, **r88c: 4 → 2**: stesso schema.
- 🟢 **r118a: 25 → 25.** Tutte distinte: quel round ha morso ovunque.

## 1.2 🪦 Quello che e' MORTO, con il certificato completo (e non si rifa')

| candidato | fonte | PF | DD | n | verdetto |
|---|---|---|---|---|---|
| **U30USD SHORT** (ORB-EMA200) | `REFERTO_ROUND54_LATI_DOW.md` | IS **0,681** · OOS **0,520** | IS 13,72% · **OOS 26,37%** | 64 / 100 | 🔴 **MORTO per MERITO in ENTRAMBE le finestre** (n sopra soglia) **e per RISCHIO** (DD 26,37%, e il rischio si legge a qualunque n). Certificato completo |
| **U30USD long+short** | idem | OOS 1,047 | OOS 17,16% | 219 | 🔴 morto: meno profitto **e** DD doppio del solo long |
| **DAX scheda "open range 07:00-08:05"** | `REFERTO_ROUND11.md` | OOS 0,940-1,022 | OOS 17,5-29,7% | 191-267 | 🔴 morto **quella ricetta** — vedi §1.3 |
| **ORB su oro / EURUSD / GBPUSD (Londra)** | R10, R45 | OOS 0,63-0,88 | — | 189-323 | 🔴 morto, 0/48 celle |
| **ORB_Fibo NASUSD** | censimento | OOS 0,968 | — | 75 | 🔴 morto |

> 🚫 **Nessuna passata di questo round e' spesa su U30USD short.** Non e'
> stanchezza: e' che allargare lo stop a un lato che **perde in tutte e due le
> finestre** produce un perdente con meno drawdown. L'unica cosa che lo
> riaprirebbe e' un **regime d'orso**, e i tick BCM partono dal 2024.09.26.
> **Non ce l'abbiamo.** Questa e' la meta' "non illudersi" del mandato.

## 1.3 🕳️ E QUELLO CHE **NON** E' MAI STATO PROVATO — il giacimento vero

| # | buco | prova che e' un buco |
|---|---|---|
| **B1** | **buffer sullo stop oltre 20 punti indice** | il massimo mai girato e' **2000 punti MT5**, e **solo sul ramo HALFRANGE** (R118). Sul ramo **OPPRANGE** — quello che passa il cancello — esistono **TRE punti in tutto** (0/500/1000, R88) |
| **B2** | **la geometria vincente del Dow (OR 15' + OPPRANGE + trailing) sul DAX** | l'ORB su D30EUR ha **4 passate in tutto** nel censimento, e sono di R11, che e' **un'altra ricetta** (finestra 65', niente trailing, niente parziale, niente breakeven, EMA50) |
| **B3** | **la finestra 08:00-08:15 server sul DAX** | e' la ricetta **RICORRENTE dei docenti** (`REGISTRO_TEST.md` r.219) e **non e' mai stata misurata** |
| **B4** | **il lato SHORT sul DAX, isolato** | R11 girava con entrambi i lati accesi e non li ha mai separati |
| **B5** | **la finestra da 15 minuti sul NASDAQ** | tutte e 8 le corse NASUSD dell'ORB girano sui 5 minuti **pre**-apertura o su varianti dei filtri |
| **B6** | **`InpTP1Pct` (il parziale)** | asse **UNA volta sola su 153 file prova** (R15, valori {0; 50}). Mai 25, 75, 100 |
| **B7** | **`InpMinRangePct`** | asse **UNA volta sola** (R11, D30EUR, {0; 0,2}). **Mai su U30USD, mai su NASUSD** |

---

# 2. ⚖️ IL CANCELLO DEL COSTO, APPLICATO **PRIMA** DI PROPORRE

## 2.1 🔧 Prima una correzione al brief: **lo spread nell'ora del trade E' MISURATO**

Il brief dice *"lo spread NELL'ORARIO DEL TRADE non e' mai stato misurato"*.
**Non e' cosi'**, e la differenza cambia il round.
`risultati_archivio/spread_flotta/spread_orario_*.csv` (03/09, **252 M tick**,
`% solo-bid = 0,000%` su tutti e tre) da' la mediana e il P95 **ora per ora**:

| simbolo | ora srv | tick nell'ora | **mediana** | media | **P95** | max |
|---|---|---:|---:|---:|---:|---:|
| **U30USD** | **14** ⬅️ ora del trade | 4.931.660 | **2,00** | 2,18 | **3,00** | 47,0 |
| U30USD | 13 (pre) | 2.147.331 | 2,60 | 2,52 | 3,00 | 101,0 |
| U30USD | 15 | 7.852.363 | 2,00 | 1,98 | 2,60 | 36,0 |
| **NASUSD** | **14** | 10.455.143 | **1,80** | 2,09 | **2,70** | 8,2 |
| **D30EUR** | **8** ⬅️ apertura DAX | 1.847.049 | **1,70** | 1,92 | **2,70** | 12,0 |
| **D30EUR** | **7** (PRE-apertura) | 746.714 | **2,80** | 2,82 | **4,10** | 19,1 |
| D30EUR | 9 | 2.391.503 | 1,70 | 1,71 | 1,90 | 11,9 |

🎯 **Il numero piu' utile di tutta la tabella:** sul DAX la **pre-apertura
(ora 7) costa il 65% in piu' della post-apertura (ora 8)** — 2,80 contro 1,70.
👉 **E' il numero che boccia da noi la finestra del collega**, che costruisce il
range **prima** dell'apertura (08:55 IT). Non e' un giudizio sulla sua
strategia: e' **il nostro listino**.

🔴 **E il buco vero, dichiarato:** questa e' la mediana **dell'ORA**, non del
**MINUTO**. Dentro 14:30-14:45 lo spread puo' essere peggiore (il `max` di
U30USD nell'ora 14 e' **47,0**). La direzione dell'errore e' **nota e
sfavorevole**. Chiuderlo costa una riga: `ABTG_SpreadLogger` sul demo 50503392.

## 2.2 📏 Quanto vale lo stop — e come l'ho ricavato, **con il contro-esempio**

Non c'e' nessun CSV con la colonna "distanza di stop". Ho tre strade, e le
dichiaro tutte e tre con il loro grado.

### Strada 1 — **inversione del DD di R118** (DERIVATO)
Il DD e' proporzionale al lotto, e il lotto va come `1/distanza`. R118 corsa a
da' 14 coppie *buffer contro baseline* a parita' di tutto il resto:
`d = buffer / (DD_base/DD_buffer − 1)`.

| buffer (idx) | slip 0 | slip 0,5 | slip 1,0 | slip 1,5 |
|---|---:|---:|---:|---:|
| 5 | 🔴 **233** | 37,8 | 36,2 | 32,1 |
| 10 | 46,9 | 44,7 | 44,7 | 39,9 |
| 15 | 51,3 | — | — | 44,7 |
| 20 | **48,0** | 46,7 | 45,7 | 42,7 |

👉 **13 stime su 14 cadono fra 32 e 51, mediana ~45.** La quattordicesima
(buffer 5, slip 0) esce a **233**: la scrivo invece di nasconderla — il buffer
non cambia solo il lotto, cambia anche **quali trade sopravvivono**, e a buffer
piccolo quel secondo effetto domina.

### 🔴 Strada 2 — quella che ho provato per ROMPERE la prima, **e che FALLISCE**
Stesso ragionamento sui **profitti** invece che sui DD: R88 OOS da'
HALFRANGE 41.057 e OPPRANGE-buffer0 24.136 → rapporto 1,701. Ma
`(range+10)/(0,5·range) = 2 + 20/range`, che e' **sempre > 2**: 1,701 e'
**impossibile**. ✅ **La contraddizione e' la prova che i profitti NON si
possono usare** (i due modi hanno target diversi, quindi trade diversi).
**Il metodo dei profitti e' scartato, e con lui qualunque numero ne uscisse.**

### Strada 3 — **la scala del movimento** (INFERITO, con un fattore MISURATO)
Range di giornata **MISURATO su operazioni vere** (`trades_auto.csv`, colonne
`session_high/low`):

| simbolo | prezzo mediano | giorni | **range giornaliero mediano** | p25 | p75 |
|---|---:|---:|---:|---:|---:|
| U30USD | 53.465 | 24 | **314,5** | 172,0 | 478,0 |
| D30EUR | 25.421 | 49 | **186,5** | 146,0 | 260,8 |
| NASUSD | 29.001 | 24 | **313,8** | 239,4 | 474,9 |

La regola di scala `range(t) ≈ range(giorno) × √(t/1440)` (validata al **4,3%**
in `ORO_1530_CANCELLO_COSTO`) darebbe per 15 minuti: U30USD **32,1**, D30EUR
**19,0**, NASUSD **32,0**.
🔴 **Ma l'apertura non e' un quarto d'ora qualunque.** Il fattore di
amplificazione si **MISURA sul DAX**: `giornata_2026-08-06.md` r.98 scrive
*"R medio misurato di **~58,7 punti indice** sul DAX"* per la geometria range
15' d'apertura + stop all'estremo opposto → **58,7 / 19,0 = 3,05**.

### 🎯 LE DUE STRADE VALIDE CONVERGONO — ed e' il contro-esempio che sopravvive
Su **U30USD**: strada 1 da' range **85-103** (da stop 42,7-51,3 HALFRANGE),
strada 3 da' **314,5 × 0,10206 × 3,05 = 97,9**. **94 e 98.**
⚠️ **Il fattore 3,05 e' misurato su UN SIMBOLO SOLO.** Trasportarlo sul Dow e'
**[INFERITO]**. Che due strade indipendenti diano lo stesso numero e' la
ragione per cui lo uso — **non e' una prova**.

## 2.3 ⚖️ IL VERDETTO DI COSTO, cella per cella

Pavimenti: **DI LAVORO** `40x`, **DURO** `13,3x`. Stop OPPRANGE = `range + 10
(ingresso) + buffer`. Stop HALFRANGE = `0,5 × range + buffer`.

### 🇺🇸 U30USD — range ~94 (banda 85-103) · spread **2,00** / P95 **3,00**
| geometria | stop | **/2,00** | 40x = 80,0 | /3,00 (P95) |
|---|---:|---:|:---:|---:|
| **HALFRANGE + 0 — LA SEDIA VIVA SUL REALE** | ~47 | **23,5x** | 🔴 **NO** (59%) | 15,7x |
| HALFRANGE + 20 | ~67 | 33,5x | 🔴 NO (84%) | 22,3x |
| HALFRANGE + 33 | 80 | 40,0x | 🟡 esatto | 26,7x |
| **OPPRANGE + 0** | ~104 | **52,0x** | 🟢 **SI (+30%)** | 34,7x 🟡 |
| **OPPRANGE + 20** | ~124 | **62,0x** | 🟢 **SI (+55%)** | **41,3x 🟢** |
| OPPRANGE + 30 | ~134 | 67,0x | 🟢 SI (+68%) | 44,7x 🟢 |

> ### 🥇 **La sedia che gira sul conto REALE (770611, HALFRANGE) sta al 59% del pavimento di lavoro.**
> Non e' una novita' assoluta — **R55 l'aveva gia' chiamata *"vive solo a
> taglia piccola"*, e R118 aveva misurato che sfonda il 10% di DD con **1,5
> punti indice** di slippage. Adesso ha anche il **numero del cancello**
> accanto. 🔓 **E la cella che il cancello promuove e' OPPRANGE, che e' anche
> quella che R88 aveva gia' misurato migliore fuori campione.** Due regole di
> casa indipendenti puntano sulla stessa casella.
> ⚠️ **Al bordo BASSO della banda (range 85) e allo spread P95, OPPRANGE+0 fa
> 31,7x e NON passa.** Serve buffer **16 al centro della banda (range 94)** e
> **25 al bordo basso (range 85)** — il pavimento a P95 chiede `40 x 3,00 = 120`
> punti indice. 🟢 **Per questo l'asse arriva a 30 (3000 punti), e la cella che
> copre il caso peggiore e' la 2500.**
> 📌 **CORREZIONE del 10/09 sera (classe 195):** la v1 diceva "buffer >= ~15",
> cioe' rispondeva al **caso peggiore** col numero del **caso centrale** —
> sottostima del **40%**. La conclusione sopravvive perche' l'asse era gia' largo,
> **non perche' il conto fosse giusto.**

### 🇩🇪 D30EUR (08:00-08:15) — stop OPPRANGE **58,7 MISURATO IN CAMPO** · spread **1,70** / P95 **2,70**
| buffer | stop | **/1,70** | 40x = 68,0 | /2,70 (P95) |
|---|---:|---:|:---:|---:|
| 0 | 58,7 | 34,5x | 🔴 NO (86%) | 21,7x |
| 10 | 68,7 | **40,4x** | 🟢 SI (+0,9%) | 25,4x 🔴 |
| **20** | 78,7 | **46,3x** | 🟢 **SI (+16%)** | 29,1x 🔴 |
| 30 | 88,7 | 52,2x | 🟢 SI (+30%) | 32,9x 🔴 |

🔴 **Allo spread P95 il DAX non passa il 40x a NESSUN buffer della griglia.**
Va detto adesso, non dopo aver visto un PF bello. **Il DAX sta un gradino sotto
il Dow**, e per questo `InpMinRangePct` (che compra margine di costo) e'
proposto **li'** e non altrove.
⚠️ E per il DAX la "controprova" della strada 3 e' **CIRCOLARE** (il fattore
3,05 viene da questo stesso numero): vale come coerenza interna, **non** come
conferma indipendente.

### 🇺🇸 NASUSD — spread **1,80** / P95 **2,70** · 40x = **72,0**
| finestra | stop | **/1,80** | esito |
|---|---:|---:|---|
| **14:25-14:30 (5', PRE-apertura) — LA SEDIA VIVA 770601** | **47,70 MISURATO IN CAMPO** | **26,5x** | 🔴 **NO** (66%) — sopra il DURO (23,9), sotto il lavoro |
| 14:30-14:45 (15', post-apertura) | ~108 [INFERITO] | ~60x | 🟢 SI (+50%) |

📌 Il **47,70** e' misurato dal vero: `giornata_2026-08-06.md`, due gambe reali
(BUY 29.250,20 → 29.202,50 e SELL 29.192,50 → 29.240,20).
🔴 **E qui il mio contro-esempio mi smentisce in parte, quindi lo scrivo:** la
formula della strada 3 applicata ai 5 minuti predice **66,4** contro i **47,70**
misurati — **sbaglia del 39% verso l'alto**. La spiegazione che regge e' che
14:25-14:30 sta **PRIMA** dell'apertura, dove l'amplificazione non si applica.
👉 **Quindi la stima di ~108 sui 15 minuti puo' essere ALTA**, e la misura
diretta della distribuzione del range 14:30-14:45 su NASUSD e' **la prima cosa
da fare se quel file torna ambiguo**. Costa una corsa diagnostica.

## 2.4 📉 E LA TRAPPOLA DA NON PRENDERE: **"gli indici su M5 sono esclusi per costo" NON si applica qui**
Quella regola parla di motori con lo stop scalato sulla **barra M5** (~10-15
punti indice = **5-7x**). Qui il TF di esecuzione e' M5 ma la **geometria e' da
15 minuti**: lo stop e' **104 punti indice**. 👉 **Il TF non decide il costo:
lo decide lo stop.** Escludere questo round "perche' e' M5" sarebbe un falso
scarto, ed e' il genere di errore che costa un candidato.

---

# 3. 📋 LA GRIGLIA PROPOSTA — 6 file, 33 celle, 66 passate

**Criteri congelati:** `backtest_pipeline/prove/R125_ORB_COSTO_CRITERI.md`
(scritti **prima** di qualunque numero). Tutti e sei **PASS** a
`controlla_prova.py`, **un asse ciascuno**, **ASCII puro**, `@DAQUANDO`
**misurato**.

| file | simbolo | asse | celle | passate | cosa chiude |
|---|---|---|---:|---:|---|
| **R125a** | U30USD | `InpSLBufferPts` 0→3000 (0→30 idx) | 7 | 14 | **B1** — la frontiera del costo, con celle da **tutte e due le parti** del punto in cui si chiude |
| **R125b** | U30USD | `InpTP1Pct` 0/25/50/75/100 | 5 | 10 | **B6** — il parziale, e se la sedia reale lascia soldi per terra |
| **R125c** | D30EUR | `InpSLBufferPts` 0→3000 | 7 | 14 | **B2 + B3** — la geometria del Dow sull'apertura di Francoforte |
| **R125d** | D30EUR | magic (asse **TECNICO**, gemelli G1) | 2 | 4 | **B4** — il lato short del DAX, isolato, + cancello di determinismo gratis |
| **R125e** | D30EUR | `InpMinRangePct` 0→0,20 | 5 | 10 | **B7** — ampiezza minima, con la soglia **RICAVATA dal cancello** |
| **R125f** | NASUSD | `InpSLBufferPts` 0→3000 | 7 | 14 | **B5** — la finestra da 15 minuti sul Nasdaq |
| | | | **33** | **66** | |

## 3.1 💰 IL COSTO IN TEMPO MACCHINA — **modello MISURATO, non stimato**
**R88: 136 passate in 13,7 min = 0,101 min/passata** (stesso EA, stesso simbolo,
stesso TF, tick reali, stessa finestra). 👉 **66 × 0,101 = ~7 minuti.**

> 🔴 **CORREZIONE del 10/09 sera — la v1 di questo dossier diceva "2,3 ore" e
> quindi "67 minuti": sbagliato di un FATTORE 10 ESATTO** (classe 192 della
> checklist). Le **2,3 ore** stampate in `REFERTO_R88.txt` r.4 sono la durata di
> **TUTTA LA NOTTE** — la prima riga del referto dice *"R88 (firmato) + **R87 +
> R89 + R86** (SIGILLATI)"*. Le **cinque righe di R88** sommano
> `8,0+2,1+1,3+1,2+1,1 = **13,7 min**`. 👉 **Un modello di costo si costruisce
> col numeratore del SUO lavoro, non con quello del turno intero.**
Con il margine per compilazione, avvio del terminale e caricamento dei tick, il
turno sta **sotto i 20 minuti** su una macchina. ⚠️ Il margine e' **STIMATO**, il
ritmo di 0,101 min/passata e' **MISURATO**.
📌 Il mandato dice *"meglio due round da 48 fatti bene"*: **66 sta in quella
misura.** Una griglia che moltiplicasse le tre manopole del collega
(7 buffer × 5 parziali × 5 ampiezze × 3 simboli × 2 lati) farebbe **1.050
celle = 2.100 passate = **~3,5 ore**.
🔴 **E non si lancia lo stesso — ma il motivo NON e' il tempo, ed e' importante
dirlo:** e' la regola del **19/08**. Moltiplicare manopole su un motore il cui
**merito e' SOSPESO** (n IS 71 / n OOS 119, **entrambi sotto 150**) non trova
altopiani: trova **picchi di rumore**, e la cella verde per caso e' quella che
brucia la challenge.
> 📌 **CORREZIONE del 10/09 sera (classe 193).** La v1 scriveva **35 ore** e
> usava quel numero come **la ragione** per non lanciare la griglia grande.
> Il numero derivava dal modello di costo sbagliato di un fattore 10: le ore
> vere sono **3,5**, e a 3,5 ore **quell'argomento non reggeva piu' da solo**.
> La ragione buona esisteva gia' ed e' un'altra — ma andava scritta QUELLA.
> 👉 **Quando si corregge un numero, si inseguono i suoi DISCENDENTI**, e
> soprattutto quelli che sorreggono un argomento.

## 3.2 ✂️ COSA **NON** PROVO, e perche' — la parte che vale piu' della griglia

| non provato | perche', col numero |
|---|---|
| 🔴 **U30USD SHORT** | **MORTO col certificato**: PF IS 0,681 (n 64) e PF OOS 0,520 (n 100), DD OOS **26,37%**. Perde in **entrambe** le finestre. Allargare lo stop a un perdente da' un perdente con meno DD |
| 🔴 **`InpSLMode` come asse** | e' un **ENUM**: MT5 ignora lo step e spazzola tutti i membri fra start e stop (0,1,2,3). Chiedere "solo 0 e 3" e' impossibile. Il cancello del costo ha **gia' scelto** OPPRANGE: si pinna |
| 🔴 **finestra pre-apertura sul DAX (la sua)** | **spread ora 7 = 2,80** contro **1,70** dell'ora 8: **+65% di pedaggio**. MISURATO su 746.714 tick |
| 🔴 **`InpMinRangePct` a 0,30%** (il valore che chiuderebbe il P95 sul DAX) | taglierebbe ~2/3 delle giornate → **n sotto la soglia del merito**. Il P95 si chiude col buffer, non qui |
| 🔴 **UK100 / 100GBP** | esiste su BCM (spread 1,60) **ma il collega l'ha SCARTATO** e tenerlo gli e' costato 2.842 EUR. Entra dall'imbuto come candidato nuovo, non da questo round |
| 🔴 **US2000** | **non esiste su BCM.** Nessun Russell a listino |
| 🔴 **le TAGLIE** | `InpRiskPercent` e' **pinnato a 1,00%** in tutti e sei i file, ed e' un valore di **confrontabilita'**, non di campo (la sedia reale gira a 0,65%). 🛑 **Le taglie sono di Claudio, sempre.** Non e' un asse e non lo diventa |
| 🔴 **`InpSlippagePts`** | ogni gradino e' uno **scenario assunto**, non una misura. Se una cella passa, il suo R55-bis e' un round a parte |

## 3.3 🎯 LA REGOLA DI SELEZIONE, scritta **insieme** ai numeri e non dopo

> **CENTRO DELL'ALTOPIANO, MAI IL PICCO.** Operativamente:
> 1. l'asse `InpSLBufferPts` si guarda come una **curva**, non come 7 numeri;
> 2. una cella si accetta **solo se le due adiacenti** stanno dalla stessa
>    parte del cancello e col PF entro **±0,15**;
> 3. se una cella sporge e le vicine no → **"non c'e' una configurazione
>    robusta"**, e si scrive cosi';
> 4. fra due celle sull'altopiano si prende **la piu' interna**, mai quella col
>    PF piu' alto.

**Le soglie, congelate ora:** R125-G0 costo `stop ≥ 40 × spread mediano dell'ora` ·
R125-G1 **DD OOS ≤ 7,00%** · R125-G2 **DD IS ≤ 9,00%** · R125-G3 **PF OOS ≥ 1,40** ·
R125-G4 **n OOS ≥ 95 e n IS ≥ 57** · R125-G5 altopiano.
**Bocciatura secca:** DD OOS > **9,7623%** (il DD promesso dalla sedia reale) ·
stop sotto **13,3×** spread.

> 🔴 **La riga che non si negozia, e che va detta chiara:** il **MERITO si
> legge sull'OOS (n=119) e NON sull'IS (n=71)** — Emendamento A del 16/08 alla
> lettera. **Ma il PF IS si scrive lo stesso, accanto a ogni numero, con l'n a
> fianco.** Se una cella passa R125-G0..R125-G5 con PF IS sotto 1,00 si dichiara
> **"passa i cancelli, ma la finestra vecchia non la conferma"** — **non
> "promossa"**. 🛑 **E non e' un ammorbidimento retroattivo: R88 resta
> giudicato com'era.** I criteri si cambiano prima dei numeri, e questi sono
> scritti prima dei numeri di R125.

## 3.4 🔴 IL CONTRO-ESEMPIO CHE MI HA CORRETTO — e che cambia una riga di questo dossier

Prima di consegnare ho riaperto i **CSV grezzi** di R88 invece di fidarmi della
prosa del referto. Le celle `SLMode=0 + TPMode=0 + TP_R=1,5` sono **tre**, e
sono queste:

| buffer | PF IS | DD IS | n IS | **PF OOS** | **DD OOS** | n OOS |
|---:|---:|---:|---:|---:|---:|---:|
| 0 | 1,06124 | 4,4336 | 71 | **1,76162** | 4,2025 | 119 |
| **500** | 1,06346 | 4,7839 | 71 | **1,83850** | **3,8395** | 119 |
| 1000 | 1,00555 | 4,5695 | 71 | **1,64542** | 4,4027 | 119 |

**Cosa dicono, e la seconda cosa mi contraddice:**
- 🟢 **Tutte e tre passano R125-G3** (PF OOS ≥ 1,40) **e R125-G1** (DD OOS ≤ 7,00%) con
  **n=119 ≥ 95**. Tre celle **adiacenti** dalla stessa parte del cancello:
  **non e' una cella sola che sporge.**
- 🔴 **MA sul PF il buffer 500 e' un MASSIMO, non un piano**: 1,762 → 1,839 →
  1,645. Con la regola di casa (vicine entro **±0,15**) la coppia 0/500 sta
  **dentro** (0,077), la coppia 500/1000 sta **fuori** (0,193).

> ### 🛑 **Detto senza girarci intorno: su tre punti quella cella e' PIU' UN PICCO CHE UN ALTOPIANO, e per la nostra regola un picco NON si sceglie.**
> E' esattamente il motivo per cui **R125a mette SETTE punti dove ce n'erano
> tre**. Il round non e' li' per confermare 1,8385: e' li' per scoprire se
> quel numero e' la cima di un altopiano o un sasso in mezzo al rumore.

### E cancella un'attesa che avevo scritto, e che era sbagliata
Avevo scritto che R125a avrebbe visto *"la prosecuzione del piano inclinato di
R118"*. **Falso, e verificato:** R118 corsa a gira su `InpSLMode=3` e
`InpTPMode=1` (letto dai suoi CSV, colonne `InpSLMode`/`InpTPMode`: **un solo
valore, 3 e 1**). Quel piano inclinato monotono (DD 9,76 → 9,56 → 8,05 → 7,55 →
6,89) sta sul ramo **HALFRANGE + TP_RANGE**. Sul ramo **OPPRANGE + TP in R** il
DD sui tre punti fa **4,20 → 3,84 → 4,40**: **non e' monotono.**
👉 **Trasportare la monotonia da un ramo all'altro sarebbe stato pescare**, e il
file prova adesso lo dice con le tre righe davanti.

### E la contro-verifica che ha FALLITO, che e' la piu' utile
Ho provato a ricavare la distanza di stop dai **profitti** invece che dai DD:
il rapporto R88 `HALFRANGE/OPPRANGE = 41.057/24.136 = 1,701` contro la formula
`(range+10)/(0,5·range) = 2 + 20/range`, che e' **sempre > 2**.
**1,701 e' aritmeticamente impossibile.** ✅ La contraddizione dimostra che i
profitti **non sono utilizzabili** (i due modi hanno target diversi, quindi
trade diversi) — e con essi qualunque numero ne fosse uscito. **Il metodo e'
scartato, non aggiustato.**

---

# 4. 🚪 LA PROVA FUORI CAMPIONE, DICHIARATA **PRIMA** (regola: ogni allargamento si paga)

Il round allarga su **meccanismo, simboli e finestra**. Il pagamento e' in tre
rate, e **due sono gia' dentro il round**:

| # | prova | dove sta | quando si legge |
|---|---|---|---|
| **P1** | **OOS classico** — IS 40% / OOS 60%, la seconda finestra non si guarda per scegliere | dentro ogni file (il driver la fa da solo) | subito |
| **P2** | **REPLICA SU SIMBOLI INDIPENDENTI** — la stessa identica geometria su **tre** simboli (U30USD, D30EUR, NASUSD). ⚠️ E' **piu' forte** di un n piu' grande su un simbolo solo: tre mercati che dicono la stessa cosa non e' lo stesso che 350 trade su uno | R125a + R125c + R125f | subito |
| **P3** | **PROVA DI REGIME** a parametri **CONGELATI** sulla cella eventualmente scelta, con la macchina gia' fatta (`prova_regime.ps1`, schema R50/R56/R59/R90) | round successivo, **PRIMA di qualunque forward** | dopo |

🔴 **E il limite di P3, dichiarato adesso:** i tick BCM partono dal
**2024.09.26** (MISURATO: sonda 17/08 stato `COMPLETO` = *"il broker NON HA piu'
storico"*, confermato simbolo per simbolo in `misura_tick/`). **Dentro quella
finestra c'e' UN SOLO REGIME** (indici prevalentemente al rialzo). 👉 **La prova
di regime vera — un orso — oggi NON e' eseguibile su questi simboli**, e gli
`_EXT` **non sono autorizzati** (cancello zero ancora chiuso: diff media H1
0,061-0,101% contro ≤0,05% richiesto, referto del 10/09). **Si scrive
`[NON MISURABILE]`, non si finge.**

---

# 5. 🔬 LE TRE MANOPOLE DEL COLLEGA, tradotte sui nostri fatti

## 5.1 📐 Geometria tutta ATR-adattiva su D1 chiusa → 🔴 **NON PROVABILE OGGI**

| pezzo | da noi | esprimibile? |
|---|---|---|
| **stop** ATR | `InpSLMode=ATR` usa `iATR(_Symbol, InpExecTF, 14)` — **sul TF di esecuzione**, r.284 | 🟡 solo su M5. Per averlo su D1 servirebbe `InpExecTF=D1`, che sposta **anche** EMA9/21/200, il trailing e il rilevatore di barra nuova (r.376, 736): non isolerebbe niente |
| **buffer d'ingresso** | `InpEntryPoints × InpK`, **fisso in prezzo** (r.614) | 🔴 no |
| **target** | in R sullo stop **o** in multipli del range (r.588-589) | 🔴 no |
| **ampiezza minima** | `InpMinRangePct`, **% del prezzo** (r.503) | 🟡 esiste, ma non e' normalizzata sull'ATR |

### 🔴 E c'e' un muro **sotto** al problema del codice, ed e' PROVATO
`REFERTO_CRT_2026-08-30.md`, sezione *"DISCRIMINANTE (pin 343e139)"*:
> *"**CONFERMATO: iADX/iATR su D1 NON popolano nel tester Modello 4 (tick) su
> simbolo NATIVO BCM** → RegimeGateOk torna sempre false → gate blocca tutto."*

Il discriminante e' pulito: soglie rese **sempre vere** (`AdxMax=100`, `ATR=0`)
→ **0 trade su 2.573 pattern**. L'unica spiegazione e' **dato mancante**.
👉 **Quindi anche aggiungendo gli input ATR-D1, nel tester a tick non
misurerebbero niente** — e il fallimento sarebbe **silenzioso**.
📌 La strada c'e' (`CopyRates` D1 + fallback M15, la v3 del CRT) ma **quella
corsa non e' mai partita**: e' **[NON MISURATO]**.

**Costo per aprire davvero questa manopola** (fase 2, fuori da R125):
1. fix EA: lettura D1 con `CopyRates` + ATR calcolato a mano — **~mezza
   giornata di lavoro**;
2. **validazione del fix**: una corsa diagnostica che dimostri che il D1 si
   legge nel tester a tick (contatore stampato, non un PF) — **~10 min macchina**;
3. solo dopo, il round vero.
🛑 **Saltare il punto 2 vorrebbe dire misurare un ATR che vale zero e non
accorgersene.** E' esattamente il difetto del 10/09 che il contro-esempio deve
impedire.

## 5.2 🎯 Parziale 80% a 1,5R + coda a 3R → 🔴 **NON ESPRIMIBILE COSI'**

Letto nel codice (`ABTG_ORB_Ottimizzato.mq5` r.451/588 e r.677):
- il TP dell'ordine sta a `entry + dist × InpTP_R`;
- il bersaglio del parziale sta a `openP + (openP − SL_corrente) × InpTP_R`.

👉 **Con `InpTPMode = ORB_TP_R` e lo stop fermo sono LO STESSO PREZZO**: il
parziale non ha niente da anticipare e **`InpTP1Pct` e' strutturalmente quasi
inerte**.
👉 **Col trailing acceso il bersaglio del parziale SI MUOVE**, perche' e'
ricalcolato su `SL_corrente`: piu' il trailing sale, **piu' il parziale si
avvicina**. **Non e' "1,5R dall'ingresso".**
👉 L'unico modo di avere parziale e coda su **due prezzi diversi** e'
`InpTPMode=1` (coda a un multiplo del **range**) — ed e' quello che **R125b**
usa. **Non e' la sua ricetta: e' la sua idea nella nostra macchina, e la
differenza va detta.**

📌 **E c'e' un terzo effetto, gia' nel codice (r.651-663):** con
`InpTP1Pct ≤ 0` il **breakeven non scatta MAI**, anche con `InpBreakeven=true`.
🔴 **La sedia sul conto REALE ha `InpTP1Pct=0.0`** → **il suo breakeven e'
spento e il pannello dice il contrario.** R125b lo misura invece di ipotizzarlo.

## 5.3 📏 Ampiezza minima di range → 🟢 **CE L'ABBIAMO, non l'abbiamo mai girata**

`InpMinRangePct` esiste (r.200) ed e' agganciata (r.503). Il brief diceva *"noi
non ce l'abbiamo per niente"*: **non e' cosi'**.

**E la soglia NON si copia dal collega** (i suoi `0,02727 × ATR D1` vivono sul
suo broker). **Da noi la detta il cancello del costo**, che e' una misura
nostra:
```
stop  =  ampiezza_range + 10 (ingresso) + buffer
cancello: stop >= 40 x spread mediano dell'ora
D30EUR ora 8, spread 1,70  ->  stop >= 68,0 punti indice
con buffer 20              ->  ampiezza_range >= 38,0
D30EUR a ~25.421 (prezzo mediano MISURATO su 162 operazioni vere)
                           ->  38,0 / 25.421 = 0,149%
```
> ### 🎯 **La soglia derivata e' 0,15%. Non e' pescata: e' il cancello del costo riscritto nell'unita' della manopola.**
E il valore **0,20** resta nella griglia perche' e' **l'unico gia' misurato**
(R11) — ma su una finestra da 65 minuti. Sui 15 minuti taglierebbe **meta'**
delle giornate: e' **l'estremo alto dell'altopiano**, non un candidato.

🐦 **Canarino di manopola inerte, scritto prima** (lezione degli 874 CSV con
esiti identici del 09/09): *se a 0,05 e a 0,10 il numero di operazioni non
cambia di almeno il 5%, la manopola **non ha morso** a quei valori e i loro PF
**non si citano**.*

---

# 6. 🚩 I BUCHI, DICHIARATI

| # | buco | stato | come si chiude | costo |
|---|---|---|---|---|
| 1 | **spread al MINUTO** dentro 14:30-14:45 e 08:00-08:15 | 🔴 **[NON MISURATO]** — abbiamo la mediana **dell'ORA**. Direzione dell'errore **nota e sfavorevole** | `ABTG_SpreadLogger` sul demo **50503392** | una riga, sola lettura |
| 2 | **ampiezza del range 14:30-14:45**, distribuzione vera | 🟡 **[DERIVATO]** da due strade che convergono (94 e 98) su U30USD, **[MISURATO in campo]** su D30EUR (58,7), **[INFERITO e forse ALTO]** su NASUSD | corsa diagnostica che stampa il range giorno per giorno | ~10 min macchina |
| 3 | **slippage sugli indici alla ROTTURA** | 🔴 **[NON MISURATO]** — il tester lo modella a **zero**. Unico dato: D30EUR ingresso **+0,70**, uscita in stop **0,00**, **n=1** | `ABTG_SlippageLogger`, gia' attivo sul reale | in corso |
| 4 | **`iATR` su D1 nel tester a tick** | 🔴 **ROTTO, e PROVATO** (0 trade su 2.573 pattern con soglie sempre-vere) | fix EA `CopyRates` + **validazione del fix** | mezza giornata + 10 min |
| 5 | **prova di regime vera (un orso)** | 🔴 **[NON MISURABILE]** — tick BCM dal **2024.09.26**, un solo regime. `_EXT` **non autorizzati** | Dukascopy, o si aspetta | ~12,7 giorni di crawl per il Dow |
| 6 | **OCO / `PositionSelect` su conto hedging** | 🟠 **misurato ROTTO in campo** (06/08: due gambe riempite in 90 s, −45,47 e −45,47), **non riproducibile nel tester** | v1.04 gia' scritta, serve la firma su **dove** si ricompila | — |
| 7 | **i numeri del collega** | 🔴 **[DICHIARATO-FONTE-ESTERNA]** — PF, DD, Monte Carlo, frequenze di inversione: **nessuno verificato da noi** | rimisurare sul nostro broker | — |

---

# 7. 🙋 LE COSE CHE PUO' CHIUDERE SOLO CLAUDIO

1. 🔏 **La firma sui criteri** `R125_ORB_COSTO_CRITERI.md` — vanno firmati **a
   numeri non visti**, altrimenti i numeri di R125 non si leggono.
2. 🖥️ **La macchina.** Il round vuole **un MT5 solo, libero, ~20 minuti**. Una
   macchina, un lavoro.
3. 🙋 **Le tre domande al collega** (gia' nel dossier del 10/09): pavimento di
   stop **0 o fisso**? UK100/US2000 rientrati? **slippage misurato** dopo le
   2-4 settimane? 👉 La terza e' **il dato piu' prezioso del suo documento**:
   slippage vero su una straddle a stop stretto, su conto reale — e chiude il
   nostro buco n.3.
4. 🛑 **Le taglie.** In tutti e sei i file `InpRiskPercent` e' pinnato a
   **1,00%** per confrontabilita'. **Non e' una proposta di taglia.**

---

# 8. 🚧 COSA QUESTO DOSSIER **NON** DICE

- **Non dice che l'ORB ha edge.** Dice che **la cella che passa il cancello del
  costo esiste, e' gia' stata misurata a tick, e non e' quella in campo**.
- **Non promuove niente.** Nessuna cella scende su nessun conto.
- **Non tocca il forward**: nessun EA modificato, nessun preset cambiato,
  nessun magic vivo riusato (i sei file usano **779800-779870**, vergini;
  la banda di `R125d` e' stata portata a **779860-779870** il 10/09 perche'
  quella vecchia scavalcava i magic di `R125e` e `R125f`).
- **Non ha verificato nessun numero del collega.**
- **Non ha eseguito nessun backtest.** Tutti i numeri qui dentro vengono da
  corse **gia' fatte** e da **statement veri**, con la fonte accanto.

---

_Fonti primarie, tutte sul branch `lavoro`:_
`backtest_pipeline/risultati_archivio/CENSIMENTO_PF_TUTTI_2026-09-09.csv` ·
`.../spread_flotta/spread_orario_{U30USD,D30EUR,NASUSD}.csv` +
`SPREAD_FLOTTA_MISURA_2026-09-03.md` ·
`.../REFERTO_R118_PAVIMENTO_STOP.md` par.1.4, 2, 3.1, 3.3 ·
`.../r88_csv/` + `REFERTO_ROUND88_ORB_MIGLIORAMENTO.md` ·
`.../REFERTO_ROUND54_LATI_DOW.md` · `.../REFERTO_ROUND11...` ·
`.../REFERTO_CRT_2026-08-30.md` (discriminante pin 343e139) ·
`.../REFERTO_SONDA_STORICO_17-08.md` + `.../misura_tick/` ·
`.../sonda_storico_17-08/215D85D7_ABTG_InfoBroker.csv` ·
`.../STORICO_INDICI_20260910_1356/REFERTO_STORICO_INDICI.txt` ·
`data/statements/trades_auto.csv` (1.296 righe) ·
`report/giornata_2026-08-06.md` r.85-110 · `report/DIARIO.md` r.134 ·
`mql5/Experts/ABTG_ORB_Ottimizzato.mq5` (r.200, 284, 451, 503, 588, 614,
651-663, 677) ·
`mql5/Presets/conto_reale/ABTG_ORB_Ottimizzato_770611_REALE.set` ·
`mql5/Presets/ABTG_ORB_US.set` · `backtest_pipeline/REGISTRO_TEST.md` r.219 ·
`backtest_pipeline/prove/{R11,R15,R54b,R88a,R118a}*.txt`.
