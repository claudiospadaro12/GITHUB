# 🎯 `EMA200` U30USD — **I DUE REQUISITI CHE MANCANO**, contati sull'archivio e non a memoria

_Compilato il **12/09/2026** in **sola lettura d'archivio**. **Nessun backtest lanciato. Nessun EA, preset, magic, sedia o file prova toccato.** Ogni numero qui sotto e' stato **ricalcolato da me** sui file grezzi: dove riproduce un numero scritto da qualcun altro lo dico, dove lo **corregge** lo dico piu' forte._

---

## 🔔 LA RISPOSTA IN OTTO RIGHE

1. 🟢 **I requisiti mancanti non sono due: e' UNO E MEZZO.** Il **3** (gestione dell'uscita) e' l'unico buco vero, ed e' misurato **quanto** e' grosso: l'unica manopola d'uscita mai messa ad asse (`InpTP_RR`) governa il **4,3%** delle uscite nel backtest e lo **0,0%** nel campo. Il **5** (TF) **e' GIA' STATO CAMBIATO su U30USD** — H1 contro H4, con verdetto scritto il 01/08/2026 — e il referto di stamattina lo dava per **mai fatto**.
2. 🔴 **E il rilievo piu' grosso della giornata ribalta il §4-bis del referto**: *«l'edge sta su UN SIMBOLO SOLO»* e' vero **A H1** e **FALSO A H4**. Sugli stessi gemelli, a H4: `SPXUSD` **75/86** celle positive, `D30EUR` **54/92**, `F40EUR` **52/92**, `200AUD` **58/92**, `100GBP` **50/91**, `225JPY` **64/83**. A **tick reali** su H4 **sei simboli reggono** con PFmed **1,33-1,59**. La concentrazione che stava andando davanti a Claudio come firma **e' un artefatto del TF**, non una proprieta' del motore.
3. 🟢 **IL BUCO STRUTTURALE DEL FLOTTANTE E' CHIUSO, e senza toccare l'EA.** Il massimo di posizioni contemporanee e' **2**, e lo dicono due fonti indipendenti: il **codice** (`ABTG_EMA200.mq5` **r.322**: `if(HasPosition() || HasPending()) return;`) e il **campo** (39 posizioni della famiglia sul demo 50503392: max contemporanee **2** su tutte e quattro le sedie). 👉 **Il rischio aperto di questa sedia e' strutturalmente ≤ 1,00% del saldo** (2 gambe × 0,5%, r.361), contro un cap C1 di 3,25%.
4. 🆕 **Tre `[NON MISURABILE]` del referto sono MISURATI, da file che erano gia' in casa** (`data/statements/trades_auto.csv`, che ha **`open_time`**): **swap U30USD = 0,00** su 21 posizioni di cui **4 tenute oltre la mezzanotte** (una su un weekend) · **commissione = 0,00** su 21 su 21 · **valore del punto = 0,8569-0,8628** unita'/punto/lotto (n=8) — che **uccide** definitivamente l'ipotesi 8,61 di R114.
5. 🟠 **Il campione IS in POSIZIONI resta `[NON MISURATO]`**, e la banda giusta e' **piu' larga** di quella del referto: non 102-118 ma **102-165**, perche' il **43,97%** del rapporto deal/posizione non viene da un parametro ma da **chiusure spezzate in mercato veloce**. 👉 *«sotto 150»* e' **probabile, non certo**: e' esattamente per questo che le **2 passate** della prova `02` valgono piu' di tutto il resto del pacchetto.
6. 🔴 **La frontiera del costo dice una cosa che nessuno aveva scritto: H1 non e' una scelta, e' il PAVIMENTO.** Sulla gamba debole (1,0×ATR) i rapporti stop/spread misurati sono **M5 11,5-13,1× (SFONDA il pavimento DURO 13,3×)** · M15 20,0-22,6× · M20 23,1-26,1× · M30 28,3-32,0× · **H1 33,6-45,2×** · H2 56,6-64,0× · H4 80,0-90,5×. **Sotto H1 non c'e' niente da provare, e adesso c'e' il numero accanto.**
7. 🔴 **E scatta un criterio firmato, va detto anche se non fa piacere**: la **famiglia EMA200 sul demo ha 39 posizioni e sta in PERDITA** (−126,27 unita' di conto). Il criterio del 18/08 (*«famiglia a 20+ op in perdita → revisione di tutte le sedie»*) **e' SCATTATO**. 🟢 Il criterio di **RISCHIO** invece **NON** scatta: il DD forward della sedia e' **5,44 R = 2,72% del saldo**, contro un promesso di 7,21-7,83%.
8. ⏱️ **Il costo di tutto quello che manca, col metro buono `T = 0,6 + 0,077 × passate`: 21,1 minuti** (17,4 se il canarino dello spread dice «morta»). **Non e' un ostacolo. Non lo e' mai stato.**

---

# 1. 📋 I CINQUE REQUISITI, per nome, con lo stato VERO e il file:riga

Metro: `CLAUDE.md`, «IL CERTIFICATO DI MORTE» (09/09/2026), usato al contrario — non per uccidere, per sapere cosa manca a uno vivo.

| # | requisito | referto di stamattina | 🔎 **STATO VERO** | il file:riga che lo prova |
|---|---|---|---|---|
| **1** | **PF misurato** | ✅ SI | ✅ **SI, e riprodotto da me al quinto decimale** | `risultati_archivio/R112_CORSA_20260826/ABTG_EMA200_U30USD_OOS_00_metro.csv` (PF **1,52365** · Profit **23.321,47** · DD **7,8323%** · Trades **517**) e `..._IS_00_metro.csv` (PF **1,20110** · DD **5,7325%** · Trades **237**). Ricostruito sommando i 517 deal del per-trade: saldo **123.321,47**, PF **1,52365**, DD chiusi **7,5367%** |
| **2** | **n e DD** | 🟠 PARZIALE | 🟠 **PARZIALE, e confermo il buco** — DD ✅ · n OOS ✅ **257 posizioni** · **n IS `[NON MISURATO]`** | `pertrade_00_metro_763400.csv` → **517 deal = 257 position_id** (rapporto **2,0117**). Secondo conteggio **indipendente**: `risultati_prove/trades_candidati_r23/abtg_trades_ABTG_EMA200_U30USD_771521.csv` (R31, magic **diverso**) → **517 deal = 257 posizioni**, identico |
| **3** | **gestione dell'uscita messa ad asse** | 🔴 NO | 🔴 **NO — ed e' l'UNICO buco vero. Ora con il numero di quanto pesa: 4,3%** | Audit mio su **213 CSV** di `ABTG_EMA200` (**21.209 righe di risultato**, tutti i simboli, tutti i round): `InpTP1Pct` **un solo valore (50)** · `InpBreakeven` **un solo valore (1)** · `InpUseTrailing` **(1)** · `InpSLatr` **(1)** · `InpTP1_ATRmult` **(0)** · `InpPendingExpiryBars` **(6)** · `InpMinRR` **(1)**. 🟠 **Ma `InpTP_RR` SI**: 5 valori (1,5 · 2 · 2,0 · 2,5 · 3,0) — e `InpTP_RR` **e' un parametro d'USCITA**, non d'ingresso come dice il referto (§1 req.1) |
| **4** | **simboli gemelli provati** | ✅ SI | ✅ **SI — e la LETTURA del referto e' sbagliata: §2 e §4 qui sotto** | `risultati_prove/risultati_scan_ABTG_EMA200_H1/` (48 simboli) · `risultati_archivio/EMA200/H4_OHLC/` (**48 simboli, MAI citata dal referto**) · `risultati_archivio/EMA200/realtick_H4/` (8 simboli **a tick**) · `risultati_prove/risultati_valid_ABTG_EMA200_H1_realtick/` |
| **5** | **TF cambiato almeno una volta** | 🔴 **NO su U30USD** | 🟢 **SI SU U30USD, e c'e' anche il verdetto scritto** | `risultati_archivio/EMA200/H4_OHLC/scan_ABTG_EMA200_H4_U30USD.csv` (**InpTF=16388**, 85 celle vive, **77 positive**) contro `EMA200/H1_OHLC/scan_ABTG_EMA200_H1_U30USD.csv` (**InpTF=16385**, 81/81). Verdetto scritto in `risultati_archivio/EMA200/ANALISI_EMA200.md` **r.60-73**: tabella «CONFRONTO H1 vs H4», riga **`U30USD (Dow) \| 1.84 \| 3.8 \| 300 \| 2.39 \| 2.6 \| H4`** |

> ### 🔴 IL VERDETTO DEL CERTIFICATO, rifatto
> **4 requisiti su 5 PIENI · 1 parziale (il 2, per il solo n dell'IS) · 1 mancante (il 3).**
> Non 3 su 5. La differenza non e' contabile: il referto aveva messo **due voci** in coda alle misure, e **una era gia' in archivio da sei settimane**.

### 🔬 Perche' il referto ha detto «TF mai cambiato», e non era distrazione
Ha cercato **`InpTF` che VARIA DENTRO un CSV**. Su U30USD non varia dentro nessun CSV: e' **fisso a 16385 in uno** e **fisso a 16388 in un altro**. 👉 **Il confronto esiste FRA due file, non dentro uno**, e un audit colonna-per-colonna non lo vede. E' la classe gemella delle «manopole inerti»: qui non e' una manopola girata a vuoto, e' **una manopola girata in un altro file e contata come non girata**.

---

# 2. 🚩 IL RILIEVO CHE CAMBIA UNA FIRMA — **«l'edge su un simbolo solo» e' un fatto DI H1, non del motore**

Il referto §4-bis manda davanti a Claudio, come cosa da **sapere mentre si firma**, questa: *«6 celle positive su 330 sui quattro indici azionari gemelli contro 98/98 sul Dow — e non e' il regime»*. Il numero e' **giusto**. L'insieme su cui e' calcolato **e' definito male**: e' *«i gemelli»*, ma il **TF e' fissato a H1 in silenzio** (classe 180 — l'insieme si elenca per nome, e qui mancava una coordinata).

### 📊 Gli STESSI simboli, gli STESSI file, i due TF affiancati (celle positive / celle vive)

| simbolo | **H1 OHLC** | **H4 OHLC** | H4 miglior PF | H4 max Trades |
|---|---:|---:|---:|---:|
| **U30USD** (la sedia) | **81 / 81** | **77 / 85** | 3,0247 | 82 |
| `SPXUSD` | 1 / 79 | 🟢 **75 / 86** | 1,8670 | 147 |
| `D30EUR` | 0 / 85 | 🟢 **54 / 92** | 1,8084 | 200 |
| `F40EUR` | 0 / 88 | 🟢 **52 / 92** | 1,5699 | 204 |
| `225JPY` | 41 / 85 | 🟢 **64 / 83** | 2,4542 | 58 |
| `200AUD` | 13 / 87 | 🟢 **58 / 92** | 2,7807 | 181 |
| `100GBP` | 9 / 93 | 🟢 **50 / 91** | 2,0046 | 208 |
| `E50EUR` | 0 / 88 | 🔴 **0 / 81** | 0,9535 | 150 |
| `NASUSD` | 1 / 85 | ⚪ **`[NON MISURATO]`** — il file H4 **non esiste** | — | — |

_(fonti: `risultati_archivio/EMA200/H1_OHLC/` e `.../H4_OHLC/`, 48 file ciascuna, magic 771501, 50 colonne identiche, rischio 1%; «celle vive» = escluse quelle con `InpAllowLong=0 E InpAllowShort=0`, che sono **motore spento** e non spazio sterile)_

### ✅ E A TICK REALI, che e' quello che conta — **8 simboli, misurati il 01/08/2026, mai citati stamattina**
`risultati_archivio/EMA200/realtick_H4/` — PFmed = mediana del PF sulle celle con ≥20 trade e profitto > 0:

| simbolo | PFmed **a tick** | celle positive | best PF | best DD | n |
|---|---:|---:|---:|---:|---:|
| `200AUD` | **1,590** | 53 / 87 | 3,02579 | 1,4188% | 83 |
| `AUDJPY` | **1,501** | 68 / 84 | 2,30923 | 2,5497% | 180 |
| `GBPJPY` | **1,456** | 51 / 91 | 2,06000 | 3,3642% | 146 |
| `SPXUSD` | **1,444** | **76 / 84** | 1,77961 | 1,8507% | 116 |
| `GBPUSD` | **1,378** | 64 / 87 | 2,25352 | 4,1556% | 141 |
| `XAUUSD` | **1,328** | 89 / 95 | 2,19508 | 5,0724% | 86 |
| `USDNOK` | 1,279 | 32 / 88 | 1,71474 | 2,2680% | 162 |
| `225JPY` | 1,272 | 70 / 91 | 2,89360 | 0,2881% | 19 |

🔬 **Contro-esempio, e l'ho costruito PRIMA di consegnare la tabella**: se il mio modo di contare fosse sbagliato, questi numeri non coinciderebbero con quelli scritti da un'altra sessione. `ANALISI_EMA200.md` r.48-57 aveva scritto **1.59 / 1.50 / 1.46 / 1.44 / 1.38 / 1.33 / 1.28 / 1.27**. Io ho ottenuto **1,590 / 1,501 / 1,456 / 1,444 / 1,378 / 1,328 / 1,279 / 1,272** partendo dai CSV grezzi e senza aver letto quella tabella prima. ✅ **Verificato contro i numeri veri di qualcun altro, non contro me stesso.**

### 👉 COSA CAMBIA, e cosa NON cambia
- ✅ **La concentrazione su un simbolo solo NON e' una proprieta' del motore**: e' il prezzo che il motore paga a H1. A H4 la famiglia esiste e **sei simboli reggono a tick**. Quindi **la voce 1 dell'elenco «cose scomode» del referto va riscritta**, e non e' una firma di rischio di modello.
- 🔴 **Ma non regala una sedia per il 1 ottobre**, e va detto nella stessa riga: a H4 il motore fa **42-208 Trades** su tutta la finestra, cioe' **in DEAL** — in POSIZIONI, col rapporto misurato ~2, sono **21-104**. **Tutti sotto il pavimento dei 150**, `SPXUSD` compreso (147 deal ≈ 74 posizioni). E le cinque sedie H4 gia' schierate (`771511`-`771515`, attaccate il 01/08) hanno **0 operazioni** nello statement 30/03→11/09 (`report/CENSIMENTO_FREQUENZA_FLOTTA_2026-08-22.md` r.176-180, confermato oggi da me su `trades_auto.csv`).
- 📌 Quindi la lettura corretta e': **il motore ha un edge largo a H4 e lento; ha un edge stretto a H1 e veloce.** La sedia che stiamo per schierare sta sul ramo veloce, ed e' l'**unico** che arriva a 150 posizioni entro ottobre. Questo **non** e' un difetto della sedia: e' la ragione per cui e' quella giusta.
- ⚠️ **E resta uno screening**: H4 OHLC **non e' un verdetto** (regola di casa). Il verdetto a tick esiste su 8 simboli e **su U30USD a H4 non c'e'** (`realtick_H4/` non contiene U30USD: verificato, 8 file, elencati per nome sopra).

---

# 3. 🔢 IL CAMPIONE IN POSIZIONI — **OOS 257 MISURATO · IS `[NON MISURATO]`, banda 102-165**

## 3.1 Il numero dell'OOS, e come ho provato a romperlo

```
pertrade_00_metro_763400.csv (R112, magic 763400)   517 deal -> 257 posizioni   2,0117
abtg_trades_..._U30USD_771521.csv (R31, magic 771521) 517 deal -> 257 posizioni   2,0117
pertrade_01_short_r1_763410                          302 deal -> 140 posizioni   2,1571
pertrade_02_short_r2_763420                          315 deal -> 140 posizioni   2,2500
pertrade_03_short_r3_763430                          324 deal -> 140 posizioni   2,3143
```
Due round diversi, due magic diversi, **stesso numero**. E la colonna `Trades` dei CSV di riepilogo vale **517 / 302 / 315 / 324**: coincide **esattamente** col numero di righe dei per-trade ⇒ **`Trades` conta i deal di uscita**, confermato sul campo e non per citazione. Il codice lo dice pure: `ABTG_EMA200.mq5` **r.629** tiene solo `DEAL_ENTRY_OUT` / `DEAL_ENTRY_OUT_BY`.

### 🔬 IL CONTRO-ESEMPIO OBBLIGATORIO — «il tuo metodo distingue qualcosa, o divide sempre per due?»
Il rischio e' esattamente quello scritto nella missione: su un motore che tiene **una posizione per volta**, deal e posizione coincidono **per costruzione**, e un metodo sbagliato tornerebbe giusto con **potere di falsificazione zero**. Quindi ho applicato **lo stesso conteggio** a **tutti** i per-trade dell'archivio:

| rapporto misurato | quanti file | esempi (motore · simbolo) |
|---|---:|---|
| **1,000 esatto** | **38 file** | `AtrExhaustVol` U30USD/D30EUR/NASUSD (818-927 deal) · `MaxMinNotte` JPY ×7 (1.467-2.138 deal) · `GapFill` · `BreakingBand` · `EasyTrend` · `PunteLarry` · `CostToCost` · `ORB_Ott` U30USD · `Dow_Apertura_US` **772507** |
| 1,07 – 1,40 | 21 file | `SupRev` NASUSD/D30EUR · `MaxMinNotte` XAUUSD · `DAX_Apertura_EU` |
| 1,50 – 1,82 | 9 file | `MaxMinNotte_DAX_Short` · `SupertrendReversal` 225JPY · `PTE` · `SuperWave` |
| **2,01 – 2,31** | **6 file** | 🎯 **solo `ABTG_EMA200` U30USD** |

👉 Il metodo **restituisce 1,000 esatto su 38 file e 6 motori diversi**, e **2,0117 su EMA200**. Non divide per due: **discrimina**. E il contro-esempio piu' pulito sta **dentro un solo EA**: `ABTG_Dow_Apertura_US` U30USD, stessa finestra, due celle — magic **772505 → 130 deal / 96 posizioni (1,354)** e magic **772507 → 96 deal / 96 posizioni (1,000)**. **Stesse 96 posizioni, deal diversi.** 🔴 Prova diretta che **le posizioni le fa l'INGRESSO e i deal li fa l'USCITA** — che e' il perno di tutto il §3.2.

### 🟢 E una buona notizia che nessuno aveva cercato: **la classe 226 NON tocca il PF**
PF calcolato **per deal**: **1,52365**. PF calcolato **per posizione** (aggregando i deal dello stesso `position_id`): **1,52370**. Differenza al quinto decimale, perche' il PF pesa **euro**, non conteggi. 👉 **L'unita' di conto decide `n`, la frequenza e i cancelli di campione — NON decide il PF ne' il DD.** Una delle «tre firme in sospeso» del referto morde **meno** di quanto sembrava.

## 3.2 🔴 L'IS, e perche' la banda del referto e' troppo strETTA

**Il per-trade dell'IS non esiste, e adesso so anche PERCHE'**: l'esportatore scrive un file il cui nome contiene **solo EA, simbolo e magic** (`ABTG_EMA200.mq5` **r.619**). La tranche IS e la tranche OOS dello **stesso magic** scrivono **lo stesso file**, e l'OOS gira per ultima: **l'IS viene sovrascritto, per costruzione.** Per questo serve una corsa dedicata (prova `02`), e per questo nessun round passato puo' averlo salvato.

**La banda del referto (102-118) usa i rapporti di `r1`/`r2`/`r3`, che sono CELLE DIVERSE, non FINESTRE diverse.** Il modo giusto e' decomporre il rapporto:

```
rapporto 2,0117 su 257 posizioni  =  1
                                  +  0,5720   <- il PARZIALE TP1 (147 posizioni a 2 deal)
                                  +  0,4397   <- CHIUSURE SPEZZATE (20 posizioni, 113 deal extra)
```
🔴 **Il 43,97% del rapporto non lo controlla nessun parametro.** Le 20 posizioni «spezzate» chiudono in **4-8 deal tutti entro pochi secondi**, a volumi in progressione geometrica (es. `position_id 135`: 4,30 · 2,20 · 1,10 · 0,50 · 0,20 · 0,20 · 0,10 · 0,10 fra le 15:00:22 e le 15:00:28 del 30/07/2025). **Non e' un tetto di volume** — nello stesso file c'e' un deal singolo da **14,6 lotti** — e' **riempimento frazionato in mercato veloce**, un artefatto d'esecuzione del Modello 4.

**Conseguenza sulla banda:**
- limite basso: `237 / 2,3143` = **102** posizioni;
- limite alto: se il parziale non scattasse **mai** e lo spezzettamento restasse com'e', il rapporto scenderebbe a **1,4397** ⇒ **165** posizioni;
- **valore piu' probabile 118-135** (il TP1 e' sull'EMA14, `InpTP1_ATRmult=0` → r.413: un tocco dell'EMA14 non si dirada come il PF).

👉 **`[NON MISURATO]`, banda 102-165, punto 150 DENTRO la banda.** Quindi *«l'IS sta sotto il pavimento»* e' **probabile ma non dimostrato**, e **non si chiude un cancello su una stima** — che e' esattamente cio' che il file prova `02` dice di se stesso.
🔴 **Via piu' corta al numero, e non ce n'e' una piu' corta**: `backtest_pipeline/prove/COLLAUDO_EMADOW_02_pertrade_IS.txt`, **gia' scritto, gia' gatato**, **2 passate**, `T = 0,6 + 0,077 × 2 =` **0,75 minuti**.

### 🧊 Un limite di questo numero, dichiarato
Anche a IS misurato, **150 posizioni per parte non e' una condizione che questa finestra possa soddisfare due volte**: OOS 257 ✅, IS 102-165 ❓. Se l'IS uscisse a 120, l'Emendamento A **non passa alla lettera** e la strada non e' «ammorbidire»: e' **spostare lo split** (60/40 invece di 40/60, con l'IS che diventa la finestra lunga) — e l'Emendamento A del 16/08 dice **esplicitamente** che «DOVE collocarla NON e' deciso». Questo e' un conto che si fa **con il numero in mano**, non prima.

---

# 4. 🌍 I GEMELLI E I TF — chi e' misurato, chi va misurato, **chi e' fuori PER COSTO col numero**

## 4.1 Il costo all-in sugli indici e' **SOLO SPREAD**, e non e' un'assunzione
`report/CANCELLO_COSTO_FLOTTA_2026-09-10.md` r.181-183, rimisurato su `data/statements/trades_auto.csv`: **indici, commissione 0,0000 su n=302 deal, UN SOLO valore distinto**. Verificato **di nuovo oggi da me sulla sedia stessa**: **21 posizioni su 21 di `771531` con `commission = 0.00`**, e **swap 0,00** anche sulle **4 tenute oltre la mezzanotte** (una attraverso il weekend 14→16/08). 👉 Sul Dow **il pedaggio e' lo spread e basta**: niente commissione, niente swap. `calcola_pedaggio_forex.py` (`MARCATORE_..._v3`) qui **non si usa e lo dichiaro**: la sua legge (`0,004% del nozionale in valuta BASE`) e' scritta per le **coppie**, e sugli indici il valore misurato e' zero.

**Spread U30USD MISURATO** su **64.711.285 tick** (`risultati_archivio/spread_flotta/spread_orario_U30USD.csv`), in punti indice, **ora SERVER**:

| fascia | mediana | p95 | max |
|---|---:|---:|---:|
| sessione US **14-21** | **1,8 – 2,0** | 2,0 – 3,0 | 91,0 |
| Europa/notte **0-13** | 2,6 – 2,8 | 3,0 | 101,0 (ora 13) |
| 🔴 **ora 23** | **2,8** | **7,0** | 60,0 |
| tutto il file | **2,0** | 2,8 | 101,0 |

## 4.2 Lo STOP di questa sedia, misurato tre volte da fonti indipendenti
Geometria dal codice: `o1 = ema + 0,2·ATR` · `o2 = ema − 0,3·ATR` · `sl = o2 − 1,0·ATR` (r.356-358) ⇒ **gamba 1 = 1,50·ATR**, **gamba 2 = 1,00·ATR**, rapporto **esattamente 1,50**.

| fonte | gamba 2 (= 1,0·ATR) | n | come l'ho verificata |
|---|---|---:|---|
| per-trade backtest R112 | **mediana 88,2 pt** | 33 coppie | referto di stamattina |
| **statement dal vivo** (mio, oggi) | **65,5 · 73,6 · 78,0 pt** | 3 coppie | `\|close_price − open_price\|` sulle 8 posizioni in perdita di `771531` |
| stop pieno complessivo | **mediana 104,3** (min 65,5 · max 147,0) | 8 | 🎯 **riproduce alla cifra** `CANCELLO_COSTO_FLOTTA` r.401: *«104,3 idx [MIS] n=8 … (65,5-147,0)»* |

🔬 **Due contro-esempi, e passano entrambi**: (a) le tre coppie di gambe misurate dal vivo stanno in rapporto **1,4992 · 1,5000 · 1,5000** — se stessi catturando uscite in trailing invece di stop pieni, quel rapporto non ci sarebbe; (b) il **valore del punto implicito** `|P/L| / (dist × lotti)` esce **0,8569-0,8628** su otto eventi ⇒ **0,861 confermato, 8,61 escluso** (il conflitto `CONTRACT_SIZE` di R114 si chiude qui, con dati di campo).
🟢 **E un regalo**: il rapporto 1,50 misurato dal vivo prova che la sedia in campo gira la cella **`InpOrder1Atr=0,2` / `InpOrder2Atr=0,3`** (il default compilato e' 0,10/0,35, che darebbe 1,45). 👉 **La cella del backtest E' la cella che gira.** Requisito zero, verificato dal campo.

## 4.3 🔴 LA TABELLA DEI TF, col numero accanto a ogni esclusione
Legge di scala **dichiarata**: `ATR(T) = ATR(H1) × √(T/60)`, ancorata al **misurato** H1 (banda **78,0-88,2**). Denominatore: mediana di sessione **1,95**. Cancello di casa: **≥ 40×** (lavoro) e **≥ 13,3×** (duro).

| TF | ATR stimato (pt) | **gamba 2 / spread sessione** | gamba 1 / spread | verdetto |
|---|---|---:|---:|---|
| **M5** | 22,5 – 25,5 | 🔴 **11,5 – 13,1×** | 17,3 – 19,6× | 🔴 **ESCLUSO PER COSTO: SFONDA IL PAVIMENTO DURO 13,3×** sulla gamba 2. (+ fuori anche dal tetto barre: M5 su 21 mesi ≈ **132.000 barre** > ~100.000) |
| **M15** | 39,0 – 44,1 | 🔴 **20,0 – 22,6×** | 30,0 – 33,9× | 🔴 **ESCLUSO PER COSTO** (50-57% della frontiera). Sopra il duro |
| **M20** | 45,0 – 50,9 | 🔴 **23,1 – 26,1×** | 34,6 – 39,2× | 🔴 **ESCLUSO PER COSTO** |
| **M30** | 55,2 – 62,4 | 🔴 **28,3 – 32,0×** | 42,5 – 48,0× | 🔴 **ESCLUSO PER COSTO sulla gamba 2** (71-80%). La gamba 1 passerebbe |
| **H1** 🎯 | **78,0 – 88,2** (misurato) | 🟠 **33,6 – 45,2×** | 50,4 – 67,8× | 🟠 **LA SOGLIA CADE DENTRO LA BANDA MISURATA.** `FRAGILE`, non `PASS`, non `sfondato` |
| **H2** | 110,3 – 124,7 | 🟢 56,6 – 64,0× | 84,8 – 96,0× | 🟢 passa |
| **H3** | 135,1 – 152,8 | 🟢 69,3 – 78,3× | — | 🟢 passa |
| **H4** | 156,0 – 176,4 | 🟢 80,0 – 90,5× | — | 🟢 passa. 🔴 **ma 42-82 Trades = 21-41 POSIZIONI**: fuori per frequenza |

> ### 🎯 **H1 NON E' UNA SCELTA: E' IL PAVIMENTO.**
> Sotto H1 non c'e' **nessun** TF che tenga la frontiera sulla gamba debole, e sopra H1 non c'e' **nessun** TF che tenga la frequenza. 👉 **La sedia sta nell'unica casella che soddisfa entrambi i cancelli**, e da oggi questo e' un **conto**, non un'abitudine.

🔬 **Contro-esempio sulla legge di scala, perche' una formula senza verifica non vale niente**: la casa, in `CANCELLO_COSTO_FLOTTA` r.405, usa la stessa legge ancorata all'**ADR** (`314,5 × √(60/1440) = 64,2`) per inferire lo stop H1 di `PTE`. Il mio misurato su H1 e' **78,0-88,2**. 👉 **La legge ancorata all'ADR sottostima del 18-27%**; ancorata a H1 (come qui) l'errore comune si elide e restano **rapporti** fra TF, non valori assoluti. **Margine dichiarato: ±20% sulle celle non-H1.** Questo non sposta nessun verdetto: M5 sfonda il duro anche col +20% (13,8× contro 13,3× sul massimo — e **col minimo no**), e M15/M20/M30 restano sotto 40× anche col +20%.

### 🔴 E il difetto notturno, col numero giusto
Al **p95 dell'ora 23** lo spread e' **7,0 punti**: la gamba 2 fa **9,4 – 12,6×**, cioe' **sotto il pavimento DURO**. E la sedia apre anche all'ora 23 (`InpUseCutoff=false`, `InpMaxTradesPerDay=0`). La riparazione candidata resta **`InpMaxSpread`** (l'EA ce l'ha, r.507) — ma con il limite che va detto ogni volta: `SpreadOK()` e' chiamata al **r.325**, cioe' al **SEGNALE**, quindi **filtra l'ingresso e non l'uscita**. **Parziale per costruzione.**

## 4.4 I gemelli: chi va misurato, e la REGOLA DEI DUE LATI
🟢 **I due lati ci sono su tutto**: in ogni scan e in ogni validazione le combinazioni `(InpAllowLong, InpAllowShort)` presenti sono **tutte e quattro** — `(1,1) (1,0) (0,1) (0,0)` — su **tutti** i simboli (verificato sulle 21.209 righe). E R110/R112 hanno misurato i lati separati su U30USD **a tick** (long puro PF 1,24103 · short puro PF 1,89147). Regola del 25/08: **rispettata**.

| candidato gemello | stato in archivio | cosa dico io |
|---|---|---|
| `SPXUSD` **H4** | ✅ tick, **76/84 celle positive**, PFmed 1,444, best DD 1,85%, n=116 deal | 🟢 **il gemello migliore che abbiamo**, e non e' mai stato portato a walk-forward. 🔴 **n=116 deal ≈ 58 posizioni**: sotto 150 |
| `D30EUR` **H4** | 🟠 OHLC **54/92**, best PF 1,8084, n=200 deal | 🟠 **da misurare a tick** — a H4 non e' mai stato fatto sul DAX. n≈100 posizioni |
| `F40EUR` **H4** | 🟠 OHLC **52/92**, best PF 1,5699, n=204 | 🟠 idem |
| `200AUD` · `100GBP` · `225JPY` **H4** | ✅/🟠 positivi, gia' 3 con sedia attaccata | 🟡 fuori dal perimetro indici del 25/08 |
| `E50EUR` **H4** | 🔴 **0/81 celle**, best PF **0,9535** | 🪦 **SCARTATO, col numero.** Va in `REGISTRO_TEST.md` |
| `NASUSD` **H4** | ⚪ **il file non esiste** | 🔴 **`[NON MISURATO]`** — e' **l'unico buco della matrice dei gemelli**: il Nasdaq e' stato provato a H1 (1-2/85) e **mai a H4**, mentre i suoi due vicini a H4 girano. 👉 **Buco dichiarato, non colmato.** Va in coda |
| `NASUSD` **H1** | 🔴 **1-2 celle su 83-85**, best PF 1,0285 | 🪦 **SCARTATO a H1, col numero** |
| `U30USD` **H4** | 🟠 OHLC **77/85**, best PF 3,0247, **ma n=42-82 deal** | 🪦 **fuori per FREQUENZA, non per edge** — e va scritto cosi' |

---

# 5. 🔓 IL FLOTTANTE — **il buco strutturale e' CHIUSO**, e non con una toppa

Il referto lo chiama *«l'unico buco STRUTTURALE del pacchetto, e nessun backtest lo chiude»*. 🟢 **Lo chiudono due cose che c'erano gia', e sono migliori di un backtest.**

## 5.1 Il CODICE mette un tetto, e il tetto e' 2
```
ABTG_EMA200.mq5  r.322:   if(HasPosition() || HasPending()){ cB_occupata++; return; }   // gia' impegnati
ABTG_EMA200.mq5  r.361:   double riskPct = InpRiskPercent/nOrders;                      // 1,0% / 2 = 0,5% per gamba
```
`HasPosition()` (r.509-518) e `HasPending()` (r.520-529) filtrano per **`POSITION_SYMBOL == _Symbol` E `POSITION_MAGIC == InpMagic`**. 👉 **L'EA non valuta un nuovo segnale finche' esiste una sua posizione O un suo pendente.** Ogni segnale piazza **2 LIMIT** (r.354-366) ⇒
- **massimo posizioni contemporanee = 2** (le due gambe di UN segnale);
- **massimo pendenti contemporanei = 2**;
- 🎯 **massimo rischio aperto della sedia = 2 × 0,5% = 1,00% del saldo**, sia in posizioni sia in pendenti.

## 5.2 Il CAMPO conferma, su 39 posizioni e quattro sedie
`data/statements/trades_auto.csv` — e la scoperta e' che **quel file ha `open_time`**, cosa che i per-trade non hanno. Finestra dello statement **30/03 → 11/09/2026**, demo **50503392** (`chart33.chr`, `ABTG_EMA200 U30USD`, censito acceso il 12/09: `report/collaudi/CENSIMENTO_MT5_VPS_2026-09-12_0846.txt` r.92-94 e r.125):

| magic · simbolo | posizioni | **max CONTEMPORANEE** | max volume aperto | netto |
|---|---:|:---:|---:|---:|
| `771531` **U30USD H1** 🎯 | **21** | **2** | 0,60 lotti | −19,39 |
| `771501` D30EUR | 6 | **2** | — | −77,31 |
| `771501` XAUUSD | 3 | **2** | — | +24,80 |
| `971501` XAUUSD | 9 | **2** | — | −54,37 |
| **famiglia** | **39** | **2** | | **−126,27** |

> ### 🔬 IL CONTRO-ESEMPIO CHE HA PRESO UN MIO ERRORE IN FLAGRANTE
> Al primo conteggio avevo aggregato **per magic** e mi era uscito **3** su `771501`. Sembrava un guardiano che perde un colpo. 🔴 **Era mio l'errore**: `771501` gira su **DUE simboli** (`D30EUR` **e** `XAUUSD`), e il guardiano filtra per **simbolo E magic** — quindi le tre posizioni erano **1 XAUUSD + 2 D30EUR**, e il tetto **non e' stato violato**. Aggregato nell'unita' giusta — **(magic, simbolo)** — il massimo e' **2 su tutte e quattro le sedie**. 👉 Senza cercare il caso che mi rompeva il numero, avrei consegnato *«il guardiano non tiene»*: **falso, e su una sedia che sta per andare in prop.**

## 5.3 🔴 Che cosa resta **davvero** `[NON MISURABILE]`, ed e' molto meno di prima
| grandezza | stato |
|---|---|
| max posizioni contemporanee | 🟢 **2** (codice + campo, n=39) |
| max rischio aperto della sedia | 🟢 **1,00% del saldo** (r.322 + r.361) |
| contributo al **buco B6** (pendenti invisibili al cap C1) | 🟢 **≤ 1,00%**, non piu' `[?]`. Il caso dell'oro (4 pendenti = 3,94%) **non e' replicabile da questa sedia**: non puo' averne piu' di 2 |
| DD di equity **sull'intera corsa** (flottante incluso) | 🟢 **7,8323% misurato**, contro **7,5367%** sui soli chiusi ⇒ il flottante aggiunge **0,2956 punti** (fattore **1,0392**) |
| 🔴 **la peggior ESCURSIONE GIORNALIERA di EQUITY** | 🔴 **`[NON MISURABILE]`** dai CSV. E' **questa** e solo questa la grandezza che decide il muro giornaliero di una prop. Sui **chiusi** il peggior giorno e' **−2,448%** nel backtest e **−1,18%** nel campo (11/09: `−40,30` unita' = **−2,36 R**) |

### 🧪 La via alternativa che ho provato **e che NON funziona** — e la dichiaro perche' e' un risultato
Senza `open_time`, l'unico pavimento ricavabile dai per-trade e' **«posizioni distinte chiuse nello stesso istante»**. L'ho calcolato: **massimo 2** allo stesso secondo (84 istanti con 2, 264 con 1) e **massimo 2** entro 60 secondi. 🔴 **Quel pavimento vale ZERO come misura**: sapevamo **a priori** che le gambe sono 2 e si chiudono spesso insieme, quindi «2» era garantito e **non falsifica niente**. Se avessi consegnato quel 2 come misura del flottante, avrei consegnato una tautologia con l'aria di un dato. **Il 2 vero viene dal codice e dal campo, non da li'.**

## 5.4 🔧 LA TOPPA PRONTA — **`P1`, e NON VA APPLICATA OGGI**

> # 🛑 **DA APPLICARE DOPO CHE LA CODA HA GIRATO**
> Il driver compila dall'**HEAD di `lavoro`**: toccare `ABTG_EMA200.mq5` **adesso** romperebbe il **cancello di determinismo S1** dei **19 round in coda stanotte** (`b2cc582`). 🔴 **Io non l'ho applicata: questa e' una proposta, e l'EA e' rimasto intatto.**
> 🟢 E va detto che **dopo le §5.1-5.2 questa toppa e' un MIGLIORAMENTO, non una riparazione urgente**: il numero che doveva produrre ce l'abbiamo gia' da due fonti.

Bersaglio: `mql5/Experts/ABTG_EMA200.mq5`, funzione `ExportTrades()` (**r.616-642**). Si aggiunge **una NONA colonna in coda** — `open_time` — senza spostare nessuna colonna esistente, cosi' `dd_portafoglio.py` e ogni lettore per indice continuano a funzionare.

```diff
--- a/mql5/Experts/ABTG_EMA200.mq5
+++ b/mql5/Experts/ABTG_EMA200.mq5
@@ -622,7 +622,24 @@ void ExportTrades()
-   FileWrite(h,"close_time","symbol","magic","position_id","deal_type","volume","price","net_profit");
+   FileWrite(h,"close_time","symbol","magic","position_id","deal_type","volume","price","net_profit","open_time");
    int n=HistoryDealsTotal();
+   // --- PASSO 1: l'ora di APERTURA di ogni posizione (deal DEAL_ENTRY_IN).
+   //     Serve al FLOTTANTE e al massimo di posizioni CONTEMPORANEE, che con
+   //     la sola close_time non si ricavano. open_time e' la NONA colonna, in
+   //     CODA: nessuna colonna esistente cambia di posto (dd_portafoglio.py
+   //     e i lettori per indice restano validi).
+   long     inPid[];   datetime inTime[];
+   int      nin=0;
+   ArrayResize(inPid,n);  ArrayResize(inTime,n);
+   for(int j=0;j<n;j++)
+     {
+      ulong tk0=HistoryDealGetTicket(j);
+      if(tk0==0) continue;
+      if(HistoryDealGetInteger(tk0,DEAL_ENTRY)!=DEAL_ENTRY_IN) continue;
+      inPid[nin] =(long)HistoryDealGetInteger(tk0,DEAL_POSITION_ID);
+      inTime[nin]=(datetime)HistoryDealGetInteger(tk0,DEAL_TIME);
+      nin++;
+     }
+   ArrayResize(inPid,nin);  ArrayResize(inTime,nin);
    for(int i=0;i<n;i++)
      {
       ulong tk=HistoryDealGetTicket(i);
@@ -629,6 +646,10 @@ void ExportTrades()
       if(entry!=DEAL_ENTRY_OUT && entry!=DEAL_ENTRY_OUT_BY) continue;
       double net=HistoryDealGetDouble(tk,DEAL_PROFIT)+HistoryDealGetDouble(tk,DEAL_SWAP)+HistoryDealGetDouble(tk,DEAL_COMMISSION);
+      long   pid=(long)HistoryDealGetInteger(tk,DEAL_POSITION_ID);
+      string ot="";
+      for(int k=0;k<nin;k++)
+         if(inPid[k]==pid){ ot=TimeToString(inTime[k],TIME_DATE|TIME_MINUTES|TIME_SECONDS); break; }
       FileWrite(h,
                 TimeToString((datetime)HistoryDealGetInteger(tk,DEAL_TIME),TIME_DATE|TIME_MINUTES|TIME_SECONDS),
@@ -639,7 +660,8 @@ void ExportTrades()
                 DoubleToString(HistoryDealGetDouble(tk,DEAL_PRICE),_Digits),
-                DoubleToString(net,2));
+                DoubleToString(net,2),
+                ot);
      }
```
**Quattro cose dichiarate su questa toppa, prima che qualcuno la applichi:**
1. **Costo in passate: ZERO.** Viaggia sul primo round che gira dopo.
2. **`HistorySelectByPosition()` NON si usa** di proposito: azzererebbe la selezione dello storico dentro il ciclo esterno — trappola MQL5 nota. Da qui i **due passaggi** sulla stessa selezione.
3. **Ricerca lineare** `O(n·nin)`: con n ~1.000 sono ~10⁶ confronti, irrilevanti a fine test.
4. ⚠️ **Su una posizione con PIU' ingressi** (netting) prende **il primo** `DEAL_ENTRY_IN`. Su questa sedia non capita (max 2 posizioni separate, mai netting misurato) ma la riga va scritta nel referto di chi la usa.

🔴 **E la toppa non basta comunque**: `open_time` + `close_time` danno il **numero** di posizioni contemporanee (che ora conosciamo) ma **non l'equity intraday**. La peggior escursione giornaliera la chiude **solo** un forward osservato o un EA che logga l'equity a intervalli. **Il tester non la dara' mai.**

---

# 6. 🆕 COSE MISURATE OGGI CHE PRIMA ERANO BUCHI (tutte da file gia' in casa)

| # | cosa | prima | **ora** | fonte |
|---|---|---|---|---|
| 1 | **swap / rollover su U30USD** | `[NON MISURABILE]` | 🟢 **0,00** su 21 posizioni, **4 overnight** (una attraverso il weekend) | `trades_auto.csv`, magic 771531 |
| 2 | **commissione su U30USD** | 0 «verificato su 7 simboli» | 🟢 **0,00 su 21/21** della sedia stessa | idem |
| 3 | **valore del punto** | 0,861 «vinto per assurdo» | 🟢 **0,8569-0,8628 misurato**, n=8 | idem |
| 4 | **max posizioni contemporanee** | `[NON MISURABILE]` | 🟢 **2** (codice r.322 + campo n=39) | §5 |
| 5 | **frequenza in POSIZIONI dal vivo** | mai misurata | 🟢 **1,000 pos/giorno feriale** (21 posizioni / 21 giorni feriali, 14/08→11/09) | idem |
| 6 | **DD forward della sedia** | mai calcolato | 🟢 **5,44 R = 2,72% del saldo** (R = 0,5%, r.361) | idem |
| 7 | **peggior giornata forward** | mai calcolata | 🟢 **−2,36 R = −1,18%** (04/09/2026) | idem |
| 8 | **quota di uscite governate da `InpTP_RR`** | mai calcolata | 🔴 **4,3% nel backtest · 0,0% nel campo** | §7 |
| 9 | **dispersione di prezzo dentro una chiusura spezzata** | mai guardata | 🟠 mediana **3,50 pt**, max **166,2 pt** su 20 posizioni | per-trade R112 |

### 📊 La frequenza, e perche' i due numeri si abbracciano
- **backtest OOS**: 257 posizioni / 272 giorni feriali = **0,945 pos/giorno**
- **campo**: 21 posizioni / 21 giorni feriali = **1,000 pos/giorno**
- 🔬 **Contro-esempio**: con 21 eventi l'intervallo di Poisson e' **0,56-1,44** — il dato di campo **non distingue** 0,6 da 1,4, mentre i 257 del backtest danno **±0,12**. 👉 **La stima buona resta 0,945-1,000: la sedia sta ESATTAMENTE SUL pavimento**, e dire «sopra» o «sotto» oggi e' oltre la risoluzione dei dati. Onesto: **sul pavimento.**
- **Famiglia dal vivo**, stessa finestra 14/08→11/09, **tutto in POSIZIONI** (nessuna mescolanza di unita'): `771531` 21 + `971501` 7 = **28 posizioni / 21 giorni = 1,333 pos/giorno**. 🔴 **Ma 0,333 sono di `971501`, firmato «prop: NO a nessuna taglia» il 23/08.** La famiglia degli **SCHIERABILI** e' **1,000**.
- 🟢 **Questo pero' CORREGGE il referto a favore della sedia**: il §5 del referto dice che la famiglia passa *«solo contando 971501»* e che il 1,245 *«mescola le unita'»*. Con la misura di campo **non serve mescolare niente e non serve `971501`**: la sedia da sola fa **1,000 posizioni/giorno**, misurate in posizioni.

### 🔴 E IL CRITERIO CHE SCATTA, detto senza addolcire
`report/FIRME_2026-08-18.md`, corsia **MERITO**: *«famiglia a 20+ operazioni totali in perdita → revisione di TUTTE le sedie; si spegne la SEDIA colpevole»*.
**Famiglia EMA200: 39 posizioni, netto −126,27. SCATTATO.** E anche la sola `771531`: **21 posizioni, −19,39 = −1,13 R**.
🔬 **Contro-esempio, perche' un criterio scattato non e' una condanna**: il tasso di vincita di campo e' **10/21 = 47,6%** contro **156/257 = 60,7%** del backtest. Su n=21 lo scarto e' **1,2 σ**: **non distinguibile dal rumore**. E l'Emendamento B del 16/08 e' esplicito — *«il campione sottile sospende il giudizio sul MERITO, mai sul RISCHIO»*.
👉 Quindi la frase giusta e' **«il criterio chiede una REVISIONE, e i dati non danno ancora un verdetto»** — non «la sedia perde». 🟢 **E il RISCHIO, che si legge a qualunque n, sta dentro**: DD forward **2,72%** contro **7,21-7,83%** promessi; peggior giornata **−1,18%** contro **−2,448%** del backtest. **Nessuna revisione di rischio.**

---

# 7. 🎯 IL REQUISITO 3 — l'unico buco vero, e ora si sa **quanto** e' grosso

Classifico le **257 posizioni** dell'OOS per **tipo di uscita**, usando il saldo corrente al momento dell'apertura (rischio per gamba 0,5%, TP finale a RR 2,0 ⇒ +1,0%):

| tipo di uscita | posizioni | quota | quale manopola la governa | mai messa ad asse? |
|---|---:|---:|---|---|
| **utile via BE/trailing** | 145 | **56,4%** | `InpTP1Pct` · `InpTP1_ATRmult` · `InpBreakeven` · `InpUseTrailing` | 🔴 **MAI** |
| **stop pieno** | 78 | **30,4%** | `InpSLatr` | 🔴 **MAI** |
| perdita parziale via BE/trailing | 23 | 8,9% | idem sopra | 🔴 **MAI** |
| **TP finale a RR 2,0** | **11** | 🔴 **4,3%** | `InpTP_RR` | ✅ **SI** (1,5 / 2,0 / 2,5 / 3,0) |

**E nel CAMPO e' ancora piu' netto: 21 posizioni su 21 chiuse con motivo `sl`** (cioe' l'ordine di stop, spostato da breakeven e trailing). **Zero TP finali su 21.**

> ## 🔴 LA FRASE CHE VA DAVANTI A TUTTO IL PACCHETTO
> **L'unico parametro d'uscita mai messo ad asse in 213 CSV governa il 4,3% delle uscite nel backtest e lo 0,0% nel campo. Il meccanismo che governa il restante 95,7% non e' mai stato confrontato con un'alternativa, su nessun simbolo, in nessun round.**
> 👉 Non e' «una casella da spuntare»: e' la macchina che **fa il DD** e **fa il rapporto 2,01 deal/posizione** che ha aperto la classe 226 su questa sedia.

🤝 **Lo chiude il pacchetto di un altro agente** (`63e10ba`): `prove/R136a_slatr_U30USD.txt` · `R136b_primobersaglio_U30USD.txt` · `R136c_parziale_U30USD.txt` · `R136d_trailing_U30USD.txt` — **40 passate**. **Nessun file nuovo da scrivere da parte mia**, e non ne scrivo (`prove/` e' fuori dal mio perimetro oggi, per consegna).

### 💡 UNA SINERGIA CHE VALE DUE CANCELLI CON UN ASSE SOLO — e la propongo col numero
`R136a` mette ad asse **`InpSLatr`**. Quella manopola non decide solo l'edge: **decide la frontiera del costo**, perche' la gamba 2 vale **`InpSLatr` × ATR**.

| `InpSLatr` | gamba 2 (pt) | **/spread sessione 1,95** | C3 |
|---|---|---:|---|
| **1,00** (oggi) | 78,0 – 88,2 | **33,6 – 45,2×** | 🟠 **FRAGILE** (la soglia cade dentro) |
| **1,25** | 97,5 – 110,3 | **50,0 – 56,6×** | 🟢 **PASS** |
| **1,50** | 117,0 – 132,3 | **60,0 – 67,8×** | 🟢 **PASS con margine** |

🔴 **E il prezzo, che va detto nella stessa riga**: R118 ha misurato che alzare `InpSLatr` **costa edge in modo non riproducibile** (OOS **29/56** = una monetina). Quindi **non e' una riparazione: e' un baratto**, e `R136a` e' esattamente la corsa che lo prezza. **Regola di selezione dichiarata adesso, prima dei numeri: si prende `InpSLatr` diverso da 1,00 SOLO se la cella sta al CENTRO di un altopiano di almeno tre valori contigui positivi in OOS. Un valore che sporge da solo si scarta, anche se e' il migliore** — e specialmente se e' il migliore.

---

# 8. 📐 LA GRIGLIA PROPOSTA — **nessun file nuovo**, un ordine nuovo e tre attese dichiarate

🔴 **Non propongo una griglia piu' fitta.** Su questa sedia il cancello aperto e' **una misura mai fatta** (requisito 3), non un parametro d'ingresso da raffinare: allargare sugli ingressi di un motore che fa 98/98 celle positive significherebbe solo trovarne una piu' verde per caso. Quello che propongo e' **l'ordine**, e due esclusioni **con il numero**.

Metro del tempo, quello buono: **`T(min) = 0,6 + 0,077 × passate`, per ROUND.**

| ord. | round (file gia' esistente) | passate | corse | **T (min)** | cosa chiude | attesa DICHIARATA prima |
|---:|---|---:|---:|---:|---|---|
| **1** | `R136a/b/c/d` — l'uscita | 40 | 4 | **5,48** | ✅ **requisito 3 — IL buco** | `R136c` a `InpTP1Pct=0` deve dare **rapporto deal/posizione ≈ 1,44** (= solo lo spezzettamento, §3.2). Se non lo da', il modello del rapporto e' sbagliato e la classe 226 si riapre |
| **2** | `COLLAUDO_EMADOW_02_pertrade_IS` | 2 | 1 | **0,75** | ✅ **requisito 2 — n IS in POSIZIONI** | **102-165**, punto piu' probabile **118-135**. Sentinella: 237 deal ±2%, PF 1,20110 ±0,05, DD 5,7325% |
| **3** | 🐤 canarino spread (`01` a `-Spread 0` vs `99999`, solo OOS) | 4 | 2 | **1,51** | 🚦 decide se il round 8 esiste | identici alla cifra ⇒ riga ignorata ⇒ **«non misurabile»**, mai «robusta allo spread» |
| **4** | `LATI_A1/A2` — la discesa 2025.02-04 | 8 | 4 | **3,02** | 🎁 robustezza di **regime** | sentinelle R110 gia' scritte dentro i file |
| **5** | `COLLAUDO_EMADOW_05_tf_U30USD` | 14 | 1 | **1,68** | 🟠 requisito 5 **a TICK** (in OHLC e' gia' chiuso, §1) | 🔴 **e qui cambio l'attesa del file**: le celle **M15 · M20 · M30** sono **ESCLUSE PER COSTO IN ANTICIPO** (20,0-32,0× sulla gamba 2, §4.3): qualunque numero diano, **non sono promuovibili**. Le celle che decidono sono **H1 (sentinella) · H2 · H3 · H4**. 🎯 **Regola di selezione dichiarata col numero: H1 resta se sta DENTRO un altopiano — cioe' se ALMENO DUE fra H2/H3/H4 sono positive. Se H1 fosse l'unico TF positivo fra quelli che tengono il costo, e' un PICCO e la sedia va rivista.** L'archivio dice che l'altopiano c'e' (H4 OHLC **77/85**): questo round lo verifica a tick |
| **6** | `COLLAUDO_EMADOW_00_manopola_maxspread` | 10 | 1 | **1,37** | 🔧 riparazione **parziale** del C3 | attesa: **poco effetto**, perche' `SpreadOK()` filtra il segnale e non l'uscita (r.325) |
| **7** | `COLLAUDO_EMADOW_06_latenza` | 16 | 4 | **3,63** | 🛡️ scala `ExecutionMode` | attesa: **fermo** (si entra con LIMIT). Canarino gia' pagato in `ritardo_r119b_csv/` |
| **8** | `COLLAUDO_EMADOW_01` — la scala di spread | 16 | 4 | **3,63** | 🛡️ +25/+50/+100% | 🔴 **solo se il round 3 dice VIVA** |
| | **TOTALE** | **110** | **21** | **21,07** | | **17,44 min** se il canarino dice morta |

### ⏱️ E riconcilio col numero del referto, perche' due metri diversi senza spiegazione sono un errore in piu'
Il referto dice **~40 minuti**, io **21,07**. Non e' una contraddizione: il referto usa **22 s/passata**, ricavato da `REFERTO_R112.txt` r.7 (*«durata: 0.1 ore»* per 16 passate) — ma **«0,1 ore» e' arrotondato a un decimale**, quindi il vero valore sta fra 0,05 e 0,15 h, cioe' fra **11 e 34 s/passata**. Il metro `0,6 + 0,077 × passate` da' **4,6 s/passata + 36 s fissi di round**, che e' il **metro di casa**. 👉 **I due conti dicono la stessa cosa che importa: sotto la mezz'ora, non sotto l'ora.** Dichiarati entrambi, e nessuno dei due argomenta lo schieramento da solo.

### 🛑 Tre cose prima di premere invio (restano quelle del referto, e sono giuste)
1. ⚙️ **UN SOLO agente locale (`Core 1`)**, spento a mano in MT5 → Strategy Tester → Agenti. **Classe 129**: con piu' agenti le celle gemelle divergono, e in questo pacchetto la coppia gemella **e'** il cancello d'identita' delle prove `01` e `02`.
2. 🚦 **I due cancelli sulla riga** prima che parta: `controlla_riga.py` **e** l'agente `controllo-preventivo`. 🔴 **Il wrapper `.ps1` non esiste ancora** ed e' l'unico pezzo non pronto.
3. 📐 **`-SoloControllo` prima di ogni round.** Su `InpTF` il conteggio celle di `controlla_prova.py` **e' sbagliato per costruzione** (stampa 16374 su un enum i cui membri veri sono 7): **fa fede il numero del driver**.

---

# 9. 🏁 IL VERDETTO SECCO

> ## 🟢 **SCHIERABILE IL 1° OTTOBRE: SI.** E quello che manca e' **meno** di quanto diceva il referto di stamattina.
>
> **Requisiti del certificato: 4 su 5 PIENI**, 1 parziale, 1 mancante.
> ⏱️ **Tempo macchina per chiudere tutto: 21,07 minuti** (17,44 se il canarino dice morta). **Nessun ostacolo tecnico. Nessuna notte.**

### ✅ Che cosa e' andato BENE, perche' un elenco di difetti senza le vittorie descrive male la realta'
- **Il buco «strutturale» del flottante non esiste**: 2 posizioni massime, **1,00% di rischio aperto massimo**, garantiti dal **codice** e confermati sul **campo** (n=39). Compatibile col cap C1 di 3,25% **da solo, per costruzione**.
- **Il requisito 5 era gia' chiuso** in OHLC su U30USD, dal 01/08/2026.
- **«L'edge su un simbolo solo» e' un artefatto del TF**: a H4 sei simboli reggono **a tick reali**.
- **Tre `[NON MISURABILE]` sono diventati numeri** senza lanciare niente: swap **0,00**, commissione **0,00**, valore del punto **0,857**.
- **La classe 226 non tocca il PF** (1,52365 per deal vs 1,52370 per posizione): una delle firme in sospeso morde meno del previsto.
- **Il rischio forward e' meta' del promesso** (DD 2,72% contro 7,21-7,83%; peggior giornata −1,18% contro −2,448%).
- **La frequenza in posizioni, misurata dal vivo, e' 1,000/giorno**: **sul** pavimento, e senza mescolare unita' ne' appoggiarsi a una sedia non schierabile.

### 🔴 Che cosa manca, ESATTAMENTE, elencato per nome
| # | cosa manca | chi lo chiude | costo |
|---|---|---|---|
| **1** | 🔴 **La gestione dell'uscita mai messa ad asse** — governa il **95,7%** delle uscite | `R136a/b/c/d` (di un altro agente, gia' scritti) | **5,48 min** |
| **2** | 🟠 **n dell'IS in POSIZIONI** (banda 102-165, il pavimento 150 e' **dentro**) | `COLLAUDO_EMADOW_02` | **0,75 min** |
| **3** | 🟠 **C3 `FRAGILE`**: la soglia 40× cade **dentro** la banda misurata (33,6-45,2×), e al **p95 dell'ora 23** la gamba 2 fa **9,4-12,6×**, sotto il pavimento DURO | `R136a` (baratto `InpSLatr`) + `COLLAUDO_EMADOW_00` | dentro i round 1 e 6 |
| **4** | 🔴 **La peggior escursione giornaliera di EQUITY** — `[NON MISURABILE]` dal tester, e decide il muro giornaliero della prop | **solo** un forward osservato o un EA che logga l'equity intraday | nessun backtest |
| **5** | 🔴 **Il criterio MERITO del 18/08 e' SCATTATO** (famiglia 39 op, −126,27) — chiede una **revisione**, e i dati a n=21 non danno un verdetto (1,2 σ) | `[FIRMA DI CLAUDIO]` | — |
| **6** | 🔴 **Il preset del 100k (`881531`) NON ESISTE** | va creato: 41 chiavi copiate, `InpRiskPercent` = `[FIRMA DI CLAUDIO]` | — |
| **7** | 🔴 **Tre firme**: unita' di conto (ora meno grave, §3.1) · taglia d'ingresso · **tetto per cluster** su un simbolo che ha gia' 10 sedie (firmato 07/09, **implementato**, **non valorizzato in nessun preset**, **assente dalla versione in campo**) | `[FIRMA DI CLAUDIO]` | — |
| **8** | ⚪ **`NASUSD` a H4**: il file non esiste. Unico buco della matrice dei gemelli | un round nuovo, **fuori** da questo pacchetto | dichiarato, non colmato |

### 🙋 E DUE COSE CHE CHIEDO A CLAUDIO, perche' si e' messo a disposizione
1. **Il preset vivo di `771531` va confrontato riga per riga col `.set` in repo.** Io ho **dedotto** dal campo che la sedia gira `Order1Atr=0,2 / Order2Atr=0,3` (rapporto 1,50 su tre coppie di stop). E' una deduzione forte, ma **una foto del pannello input** la trasforma in un fatto — e quella cella e' la cosa che stiamo promuovendo. 🪟 Terminale: **`50503392` (`C:\Program Files\BCM Markets MT5 Terminal`, demo piccolo)**, grafico `U30USD` con `ABTG_EMA200`.
2. **`771511`-`771515` (i cinque gemelli H4) sono ancora attaccati?** Hanno **0 operazioni** in tutto lo statement 30/03→11/09, e nel censimento `.chr` del 12/09 **non compaiono**. Se sono relitti, la famiglia H4 va **rifatta** (e ora sappiamo che a H4 l'edge c'e'); se sono vivi e muti, c'e' qualcosa da diagnosticare.

---

_🛑 **Zero modifiche al forward. Nessun EA, preset, parametro, magic o grafico toccato. Nessun file in `backtest_pipeline/prove/` creato o modificato. Nessun backtest lanciato. Nessuna promozione, nessuna accensione, nessuna spesa.** Rischio e taglie sono di Claudio; lo schieramento e' una sua decisione._

_📂 **Fonti nuove aperte da questo referto**, che il dossier di stamattina non citava:_
`data/statements/trades_auto.csv` **(ha `open_time`: e' la chiave del flottante, dello swap, della commissione e del valore del punto)` · `risultati_archivio/EMA200/H4_OHLC/` (48 simboli, U30USD compreso) · `risultati_archivio/EMA200/realtick_H4/` (8 simboli a tick) · `risultati_archivio/EMA200/ANALISI_EMA200.md` r.60-73 (il confronto H1/H4 col verdetto) · `risultati_prove/trades_candidati_r23/abtg_trades_ABTG_EMA200_U30USD_771521.csv` (R31: secondo conteggio indipendente delle 257 posizioni) · `risultati_prove/risultati_valid_ABTG_EMA200_H1_realtick/` (EURUSD 94/94) · `risultati_archivio/R109_deal_anomali/` + `r81_csv/` + `r82_csv/` + `r83_csv/` + `r84_csv/` (i 38 file a rapporto 1,000 = il contro-esempio della classe 226) · `report/CANCELLO_COSTO_FLOTTA_2026-09-10.md` r.181-183 e r.401 · `report/collaudi/CENSIMENTO_MT5_VPS_2026-09-12_0846.txt` r.92-94, r.125 · `mql5/Experts/ABTG_EMA200.mq5` r.322, r.356-361, r.413, r.507, r.616-642.
