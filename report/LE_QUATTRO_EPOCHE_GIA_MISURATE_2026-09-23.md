# 🕰️ LE QUATTRO EPOCHE GIA' MISURATE — **R219**, 23/09/2026

**Sigla:** `R219` (verificata libera col grep nel momento in cui questa riga e' stata scritta:
`grep -rIn "R219" .` → nessuna occorrenza).
**Costo macchina:** 🟢 **ZERO minuti.** Nessun round, nessuna corsa, nessuna riga verso il VPS.
Questo referto **legge un file gia' in repo dal 24/08** e non produce niente di nuovo sul banco.
**Fonte unica:** `backtest_pipeline/risultati_archivio/R103_REFERTO_DRIVER_FOREX_METALLI_20260824_1922.txt`
(159 KB, 25 sedie forex/metalli, finestra **2020.01.01 → 2026.06.30 NATIVA BCM**, modello 1 OHLC M1,
deposito 100.000 EUR, pin `7e2fb0de9487eb26350da3cbcf6f05673597e233`).

---

# 0. 🔴 COSA QUESTO REFERTO **NON** PUO' DIRE — in testa, non in fondo

Sono i limiti che **il file dichiara di se stesso**. Vengono prima dei numeri perche' se si
leggono dopo, i numeri sono gia' stati creduti per la cosa sbagliata.

| # | il limite, alla lettera | conseguenza operativa |
|---|---|---|
| **1** | La spina dorsale e' il **netto REALIZZATO** (Profitto + Commissioni + Swap), attribuito al periodo della **CHIUSURA**. Il file scrive testualmente: *«NON e' l'equity e NON e' il DD»* | 🔴 **Questo referto giudica il MERITO, MAI il RISCHIO.** Per il drawdown **per epoca** servono **corse vere**: §6 dice quali, in che ordine e quante passate costano |
| **2** | Una posizione aperta a dicembre e chiusa a gennaio conta **TUTTA** nell'anno della chiusura | un anno di confine puo' essere gonfiato o svuotato da poche posizioni a cavallo. Non e' correggibile da qui |
| **3** | Il **2026 e' PARZIALE**: la finestra finisce il **2026.06.30** | 🔴 **il 2026 non si confronta col 2025 a occhio.** Nelle tabelle resta, ma vale mezzo anno |
| **4** | La finestra 2020-2026 **non contiene il LATERALE 2019** (`2019.01.01-2019.12.31`) | 🔴 **Sono TRE epoche su quattro, non quattro.** La quarta si chiama **LATERALE 2019** e qui **non c'e'**: va misurata con una corsa, non dedotta |
| **5** | Emendamento **A** del 16/08: l'unita' di misura e' l'**OPERAZIONE**, non l'anno | ogni netto in questo referto porta **`n` accanto, sempre**. Gli anni con `n < 30` (la stessa soglia del **GATE 5** di R103) sono marcati **⚠️**: 🔴 **sospendono il giudizio sul MERITO, mai sul RISCHIO** (Emendamento **B**) |
| **6** | R103 punto 4: il profitto e' una **stima del LORDO, e generosa** (spread corrente, zero slippage, zero requote, riempimenti ideali) | la frase giusta e' *«su questo banco avrebbe fatto X»*, **mai** *«avrebbe guadagnato X»* |
| **7** | 🔴 **L'anno solare NON E' l'epoca.** Vedi §2: solo **una** delle tre corrisponde | il CROLLO e l'ORSO qui si leggono **per contenimento**, e il fattore di diluizione e' dichiarato sedia per sedia |

> 🚫 **E un confine che non si sposta**: questo referto **non archivia nessun candidato.**
> Un verdetto che chiude un candidato ha bisogno del **certificato di morte** completo
> (PF · n+DD · gestione dell'uscita messa ad asse · simboli gemelli · TF cambiato).
> Qui manca **il DD per finestra** su tutte e 25 le sedie ⇒ per tutte, il verdetto e'
> **«NON ANCORA MISURATO sul rischio per epoca»**.

---

# 1. 🧪 IL CONTRO-ESEMPIO, costruito PRIMA di consegnare

## 1.1 ✅ Il test dell'estrattore (quello che l'incarico mi ha dato in mano)

Il dossier `report/I_MORTI_E_LO_STORICO_2026-09-23.md` riporta per `MaxMinNotte` XAUUSD
(`770402`, blocco **F23**) sette numeri gia' verificati. Il mio estrattore li deve
riprodurre **alla cifra**, altrimenti e' rotto lui, non il file.

| anno | atteso dal dossier | **letto dal mio estrattore** | n |
|---|---:|---:|---:|
| 2020 | +223 | **+223** | 89 |
| 2021 | **−274** | **−274** | 107 |
| 2022 | +6603 | **+6603** | 114 |
| 2023 | **−2703** | **−2703** | 104 |
| 2024 | +6867 | **+6867** | 124 |
| 2025 | +6420 | **+6420** | 113 |
| 2026 | +7601 | **+7601** | 42 |

✅ **PASS, 7 su 7.** E il ritrovamento contro-intuitivo regge: su questa sedia gli anni
negativi sono il **TORO 2021** e il **2023**, non l'orso — nell'**anno dell'ORSO (2022)**
fa **+6.603**, il secondo anno migliore dopo il 2026 parziale.

## 1.2 🔴 Il contro-esempio VERO: **«6 su 7» da un conteggio ingenuo non vuol dire niente**

Una sedia con **sei anni positivi e un settimo che si mangia tutto** esce **6/7** da un
conteggio ingenuo, identica a una sedia sana. Il conteggio dei segni **non distingue** i
due casi, e non e' un'opinione: l'ho costruito e misurato.

Quattro casi sintetici, dati in pasto allo stesso classificatore che gira sui dati veri:

| caso | serie | ingenuo | **senza il migliore** | **quota del migliore** | **peso del peggiore** | verdetto del classificatore |
|---|---|:---:|---:|---:|---:|---|
| **A** sei positivi, il settimo si mangia tutto | +1000 ×6, **−5900** | **6/7** | **−900** | 17% | **98%** | 🔴 **B1 + C1** — smascherata |
| **B** sei positivi, il settimo e' un graffio | +1000 ×6, −300 | **6/7** | +4700 | 17% | 5% | ✅ REGOLARE |
| **C** un anno fa tutto, gli altri sei in perdita | −200 ×6, **+6000** | 1/7 | **−1200** | **100%** | 3% | 🔴 **B1** — smascherata |
| **D** stesso ingenuo di A (6/7), ma sana e di altra forma | +500/+900/+1200/+800/+1100/+1400, −400 | **6/7** | +4100 | 24% | 7% | ✅ REGOLARE |

🔴 **A e B e D danno lo STESSO conteggio ingenuo (6/7) e sono cose diverse.** Le
separano le tre misure qui sotto, che uso in tutto il referto:

| sigla | misura | quando si accende | che cosa dice |
|---|---|---|---|
| **B1** | `totale − anno migliore ≤ 0` **oppure** `anno migliore / somma dei positivi ≥ 60%` | dipendenza da **UN ANNO BUONO** | togli l'anno migliore e la sedia non guadagna piu'. **Non e' robusta: e' fortunata** |
| **B2** | `totale − i DUE anni migliori ≤ 0` | dipendenza da **DUE ANNI BUONI** | piu' severa della B1: intercetta chi ha due annate portanti e cinque che perdono |
| **C1** | `|anno peggiore| / somma dei positivi ≥ 50%` | **UN ANNO CATTIVO** si mangia meta' o piu' dei guadagni | e' il caso **A**: tanti anni verdi e uno che li cancella |

> 🔴 **E lo dichiaro come limite, non come pregio: nei dati VERI il caso A non esiste.**
> Fra le quattro sedie a 6/7 il peso del peggiore vale **4% · 6% · 8% · 21%** — nessuna
> viene mangiata. Quindi la B1/B2/C1 **non e' stata validata da un caso reale di classe A**:
> e' validata **solo** sul sintetico. 👉 **La patologia vera dei nostri dati e' l'OPPOSTA**,
> ed e' misurata in §4.2.

---

# 2. 🔴 L'ANNO SOLARE NON E' L'EPOCA — e solo **una su tre** coincide

Le finestre firmate il 14/08 (`backtest_pipeline/prove/PROVA_REGIME_CRITERI.md` §3) sono:

| finestra | periodo firmato | che cosa c'e' nel file R103 | **corrispondenza** |
|---|---|---|---|
| **LATERALE** | `2019.01.01 → 2019.12.31` | 🔴 **NIENTE**: la finestra R103 parte dal 2020.01.01 | ❌ **ASSENTE** |
| **CROLLO** | `2020.02.01 → 2020.04.30` (**3 mesi**) | l'anno solare **2020** (12 mesi) | 🟠 **CONTENUTA, diluita 4×**: l'anno 2020 contiene il crollo **piu' altri 9 mesi** |
| **TORO** | `2021.01.01 → 2021.12.31` (**12 mesi**) | l'anno solare **2021** (12 mesi) | 🟢 **IDENTICA, 1:1** — l'unica |
| **ORSO** | `2022.01.01 → 2022.10.31` (**10 mesi**) | l'anno solare **2022** (12 mesi) | 🟡 **CONTENUTA, diluita 1,2×**: mancano solo nov-dic 2022 |

👉 **Quindi, alla lettera: una epoca misurata esatta (TORO 2021), una quasi (ORSO, 10/12),
una diluita a un quarto (CROLLO, 3/12), una assente (LATERALE 2019).**
🔴 **Un «+1.548 nel crollo» letto dall'anno 2020 non e' il crollo**: e' il 2020, di cui il
crollo e' **un quarto**. Dove serve il numero del crollo puro, **serve una corsa**.
Il file **non contiene** la scomposizione mensile per il forex (per gli indici la fa a
trimestri, per il forex ad anni: R103 punto 5).

---

# 3. 🏆 LA CLASSIFICA — ordinata per **anni positivi**, a parita' per il **peggior anno @1%**

📏 I confronti in euro sono **normalizzati a rischio 1%** (`@1%`): e' la **DECISIONE 3**
firmata in R103 — le sedie girano da 0,25% a 1,0% e confrontarle «come stanno» premia la
**taglia**, non il **motore**. 🔴 **La riscalatura e' LINEARE e APPROSSIMATA**, e sotto lo
0,5% (cioe' su **F22 a 0,25%** e **F20 a 0,30%**) il lotto ha un minimo ⇒ **il numero
normalizzato e' SOVRASTIMATO**. Le due righe sono marcate.

📐 **Nota di arrotondamento, dichiarata:** i totali `@1%` di questo referto sono
**ricalcolati dalla somma delle righe annuali × (1/rischio)**, non copiati dall'intestazione
di R103. Le due strade differiscono di **≤ 4 EUR** su ogni sedia (arrotondamento delle righe
annuali) — per esempio **F23 +49.474 qui contro +49.473 in R103**. 🔴 **L'unica eccezione
vera e' `Gold_Ichimoku` (F25), che scarta di 950 EUR: e' un rilievo, ed e' in §7.**

**Bandiere:** **B1** = dipende da un anno buono · **B2** = dipende dai due anni migliori ·
**C1** = un anno cattivo si mangia meta' dei guadagni · **P** = in perdita sulla finestra.

| # | ID | EA | simbolo | TF | rischio vivo | n | **anni + / operati** | peggior anno | **peggior anno @1%** | tot @1% | senza il migliore @1% | senza i due migliori @1% | bandiere |
|---:|---|---|---|---|---:|---:|:---:|---|---:|---:|---:|---:|---|
| 1 | F02 | `ABTG_BreakingBand` | EURUSD | H1 | 1.00% | 59 | **6/7** | 2021 | -506 | +8271 | +4393 | +2818 | — |
| 2 | F17 | `ABTG_PunteLarry` | EURCAD | H1 | 1.00% | 154 | **6/7** | 2023 | -1292 | +14780 | +5768 | +1806 | — |
| 3 | F04 | `ABTG_CostToCost` | EURJPY | H4 | 1.00% | 394 | **6/7** | 2026 | -4007 | +94303 | +49116 | +31777 | — |
| 4 | F20 | `ABTG_PunteLarry` | XAUUSD | H1 | 0.30% | 60 | **6/7** | 2022 | -4427 | +16480 | +10700 | +5540 | — |
| 5 | F03 | `ABTG_BreakingBand` | AUDUSD | H1 | 1.00% | 64 | **5/7** | 2020 | -224 | +5365 | +3767 | +2285 | — |
| 6 | F18 | `ABTG_PunteLarry` | GBPJPY | H1 | 1.00% | 139 | **5/7** | 2020 | -1456 | +17220 | +10350 | +5559 | — |
| 7 | F23 | `ABTG_MaxMinNotte` | XAUUSD | H2 | 0.50% | 693 | **5/7** | 2023 | -5406 | +49474 | +34272 | +20538 | — |
| 8 | F24 | `ABTG_SupertrendReversal_Ottimizzato` | XAUUSD | H4 | 1.00% | 208 | **4/7** | 2021 | -2292 | +4792 | -15 | -1639 | B1 B2 |
| 9 | F08 | `ABTG_EasyTrend` | GBPUSD | H1 | 1.00% | 254 | **4/7** | 2024 | -3693 | +8536 | +475 | -7183 | B2 |
| 10 | F01 | `ABTG_BreakingBand` | GBPUSD | H1 | 1.00% | 126 | **4/7** | 2021 | -3853 | +5413 | +743 | -2557 | B2 |
| 11 | F22 | `ABTG_EMA200_Ottimizzato` | XAUUSD | H4 | 0.25% | 610 | **4/7** | 2023 | -4092 | +12436 | +2924 | -2048 | B2 |
| 12 | F09 | `ABTG_EasyTrend` | AUDJPY | H1 | 1.00% | 313 | **4/7** | 2024 | -4162 | +1944 | -2712 | -6975 | B1 B2 |
| 13 | F15 | `ABTG_PTE` | USDJPY | H1 | 1.00% | 244 | **4/7** | 2021 | -4688 | +3405 | -2490 | -4755 | B1 B2 |
| 14 | F19 | `ABTG_PunteLarry` | GBPUSD | H1 | 1.00% | 121 | **4/7** | 2020 | -6093 | +1612 | -1655 | -4621 | B1 B2 C1 |
| 15 | F16 | `ABTG_PunteLarry` | EURAUD | H1 | 1.00% | 216 | **4/7** | 2023 | -6147 | +4695 | -4504 | -10775 | B1 B2 |
| 16 | F12 | `ABTG_GapFill` | AUDUSD | H1 | 1.00% | 17 | **3/3** | 2025 | +222 | +5349 | +1188 | +222 | B1 |
| 17 | F13 | `ABTG_PTE` | GBPUSD | H1 | 0.50% | 175 | **3/7** | 2022 | -5192 | -1102 | -4170 | -7130 | B1 B2 C1 P |
| 18 | F07 | `ABTG_EasyTrend` | CHFJPY | H1 | 1.00% | 265 | **3/7** | 2021 | -8172 | +9598 | -4763 | -9548 | B1 B2 |
| 19 | F05 | `ABTG_CostToCost` | GBPCAD | H4 | 1.00% | 382 | **3/7** | 2022 | -13470 | -14979 | -27875 | -31496 | B1 B2 C1 P |
| 20 | F25 | `Gold_Ichimoku_TK_ATR_EA` | XAUUSD | H1 | 0.50% | 553 | **3/7** | 2021 | -31008 | +148972 | +57326 | -30828 | B2 |
| 21 | F11 | `ABTG_GapFill` | EURUSD | H1 | 1.00% | 14 | **2/3** | 2024 | -507 | +3024 | +777 | -507 | B1 B2 |
| 22 | F10 | `ABTG_GapFill` | GBPUSD | H1 | 1.00% | 13 | **2/4** | 2020 | -998 | +4472 | +216 | -1035 | B1 B2 |
| 23 | F14 | `ABTG_PTE` | GBPUSD | H1 | 0.50% | 188 | **2/7** | 2022 | -1934 | +1804 | -2154 | -4556 | B1 B2 |
| 24 | F21 | `ABTG_SuperWave` | GBPUSD | H4 | 1.00% | 358 | **2/7** | 2024 | -3276 | -7502 | -10347 | -11491 | B1 B2 C1 P |
| 25 | F06 | `ABTG_CostToCost` | XAGUSD | H4 | 1.00% | 83 | **1/7** | 2022 | -5682 | -11700 | -15265 | -14109 | B1 B2 C1 P |

---

# 4. 🔴 IL RITROVAMENTO — chi sopravvive a tutto e chi vive di un anno solo

## 4.1 🥇 **NESSUNA SEDIA SU 25 HA SETTE ANNI POSITIVI SU SETTE.** Zero.

Il massimo e' **6 su 7**, e lo fanno **quattro sedie**: `BreakingBand EURUSD` ·
`PunteLarry EURCAD` · `CostToCost EURJPY` · `PunteLarry XAUUSD`.
👉 Detto in chiaro: **«sopravvive a tutte le epoche» non descrive nessuno dei nostri
motori.** Chi cercava la sedia perfetta in questo file non la trova, e questo e' un
risultato, non un fallimento della misura.

## 4.2 🛡️ **IL GRUPPO CHE REGGE DAVVERO: SETTE sedie, e sono quelle che restano positive anche TOGLIENDO I DUE ANNI MIGLIORI**

E' il test piu' severo dei tre (B2). Lo passano **otto sedie su venticinque** — e la
ottava passa solo **formalmente**, come dichiarato nell'ultima riga:

| ordine | sedia | anni + | senza i **due** migliori @1% | 3 epoche + | nota |
|---:|---|:---:|---:|:---:|---|
| 1 | **`CostToCost` EURJPY H4** (F04) | **6/7** | **+31.777** | **3/3** | n=394, **nessun anno con n<30** (il piu' magro e' il 2026 parziale, a n=30 esatti): e' **l'unica delle sette che regge la B2 con il campione pieno in tutti e sette gli anni**. *(Hanno tutti gli anni a n≥30 anche **F23**, **F22**, **F25** e **F21** — ma delle quattro solo F23 passa la B2)* |
| 2 | **`MaxMinNotte` XAUUSD H2** (F23) | 5/7 | **+20.538** | 2/3 | n=693, **il campione piu' grosso del referto**; **nessun anno sottile** (minimo 42, nel 2026 parziale) |
| 3 | **`PunteLarry` GBPJPY H1** (F18) | 5/7 | +5.559 | 1/3 | ⚠️ **tutti e sette gli anni hanno n<30** |
| 4 | **`PunteLarry` XAUUSD H1** (F20) | **6/7** | +5.540 | 2/3 | ⚠️ tutti gli anni n<30 · 🔴 **@1% SOVRASTIMATO** (taglia 0,30%) |
| 5 | **`BreakingBand` EURUSD H1** (F02) | **6/7** | +2.818 | 2/3 | ⚠️ tutti gli anni n<30 (**n=4** nel 2020) |
| 6 | **`BreakingBand` AUDUSD H1** (F03) | 5/7 | +2.285 | 2/3 | ⚠️ tutti gli anni n<30 |
| 7 | `PunteLarry` **EURCAD** H1 (F17) | **6/7** | +1.806 | **3/3** | ⚠️ sei anni su sette con n<30; passa la B2 per soli **1.806 EUR** |
| *(8)* | *`GapFill` AUDUSD H1 (F12)* | *3/3* | *+222* | 🔴 *0/0* | 🔴 **PASSA SOLO SULLA CARTA**: `n=17` in tutto, **3 anni operati su 7**, e **zero operazioni in tutte e tre le epoche** (§4.5). Togliere «i due anni migliori» da una sedia che ha **tre anni** non e' un test di robustezza: e' un anno solo. Qui la B2 **non misura niente**, e lo dico invece di lasciarla in classifica |

🔴 **E il limite della B2, dichiarato**: togliere due anni ha senso su **sette** anni
operati, non su **tre**. Su una sedia con 3-4 anni operati la B2 **degenera** e va letta
insieme alla colonna `anni + / operati` — e' il caso di **F12** qui sopra e delle altre due
`GapFill` (§4.5).

🟢 **E due sole sedie su 25 sono positive in TUTTE E TRE le epoche misurate**:
**`CostToCost` EURJPY** (+4.991 / +1.115 / +13.036) e **`PunteLarry` EURCAD**
(+1.536 / +3.962 / +1.099). 🔴 Ma della seconda, **due epoche su tre hanno n<30**.

## 4.3 ⚠️ **CHI VIVE DI UN ANNO SOLO — dieci sedie, per nome**

Togli l'anno migliore e **il totale va a zero o sotto**, oppure l'anno migliore vale da
solo ≥60% di tutti i guadagni:

| sedia | anni + | totale @1% | **senza il migliore** | l'anno che la tiene in piedi | quanto pesa |
|---|:---:|---:|---:|---|---:|
| `SupertrendReversal_Ott` XAUUSD (F24) | 4/7 | +4.792 | **−15** | **2025** | 61% dei guadagni |
| `EasyTrend` AUDJPY (F09) | 4/7 | +1.944 | **−2.712** | **2021** | 35% |
| `PTE` USDJPY (F15) | 4/7 | +3.405 | **−2.490** | **2023** | 57% |
| `PunteLarry` GBPUSD (F19) | 4/7 | +1.612 | **−1.655** | **2025** | 35% · 🔴 **e il 2020 da solo −6.093 = 64% dei guadagni (C1)** |
| `PunteLarry` EURAUD (F16) | 4/7 | +4.695 | **−4.504** | **2025** | 55% |
| `EasyTrend` CHFJPY (F07) | 3/7 | +9.598 | **−4.763** | **2025** | **60%** · 🔴 **0/3 nelle epoche** |
| `PTE` GBPUSD 0,5% (F14) | 2/7 | +1.804 | **−2.154** | **2024** | 62% · 🔴 **0/3 nelle epoche** |
| `GapFill` AUDUSD (F12) | 3/3 | +5.349 | +1.188 | **2026** | **78%** · 🔴 n=17 in tutto |
| `GapFill` EURUSD (F11) | 2/3 | +3.024 | +777 | **2026** | 64% · 🔴 n=14 |
| `GapFill` GBPUSD (F10) | 2/4 | +4.472 | +216 | **2026** | 77% · 🔴 n=13 |

## 4.4 🔴 **IL CASO CHE ROMPE LA CLASSIFICA INGENUA: `Gold_Ichimoku` XAUUSD (F25)**

E' **la prima sedia della classifica R103** (`PROF-1% +150.871`, la piu' ricca del lotto).
Ma la spina dorsale dice un'altra cosa:

- **solo 3 anni positivi su 7** (2020, 2023, 2025);
- **2020 +44.077** e **2025 +45.823** fanno **+89.900**; gli **altri cinque anni sommati
  fanno −15.414**;
- ⇒ **senza i due anni migliori la sedia e' IN PERDITA** (bandiera **B2**);
- ⇒ nelle tre epoche fa **1/3**: 🟢 +88.154 @1% nel 2020, 🔴 **−31.008 @1% nel TORO 2021**,
  🔴 −13.098 @1% nel 2022.

🔴 **E il rischio su questa sedia non esiste come numero**: R103 dichiara che l'EA **non
ha l'OPTFRAME** (*«nessun `OnTesterDeinit`»*), quindi **il DD dell'equity NON E' STATO
MISURATO** e il **GATE 3** (gemelle) **non esiste** — e un gate che non c'e' non e' un
gate verde. Unico numero di rischio disponibile: **DD sul saldo chiuso 20,87%**, che e' un
limite inferiore **ancora piu' basso** del vero.

👉 **Questa e' la lezione della sezione: la colonna del profitto l'ha messa al primo posto,
la spina dorsale la mette fra le fragili.** Le due letture non si contraddicono — **misurano
cose diverse**, e per schierare una sedia serve la seconda.

## 4.5 🕳️ **LE TRE `GapFill` NON HANNO DATI NELLE EPOCHE — e non e' un giudizio negativo, e' un buco**

| sedia | anni con **zero operazioni** | epoche operate |
|---|---|:---:|
| `GapFill` AUDUSD (F12) | **2020, 2021, 2022, 2023** | 🔴 **0 su 3** |
| `GapFill` EURUSD (F11) | **2020, 2021, 2022, 2023** | 🔴 **0 su 3** |
| `GapFill` GBPUSD (F10) | **2021, 2022, 2023** | 🔴 **0 su 3** (il 2020 ha **n=1**) |

🔴 **Per queste tre sedie la prova di regime di questo referto vale ZERO**: non hanno
perso nel crollo, nel toro o nell'orso — **non c'erano**. Verdetto: **NON ANCORA MISURATO**
sulle epoche. Manca: le operazioni stesse (n=13/14/17 su tutta la finestra), e quindi
**il campione, non il risultato**.

---

# 5. 📋 I NUMERI COMPLETI, sedia per sedia

## 5.1 La spina dorsale anno per anno — netto alla **TAGLIA VIVA**, `n` fra parentesi
⚠️ = anno con **n < 30** (soglia GATE 5 di R103): **sospende il giudizio sul MERITO, mai sul RISCHIO**.
`— (n=0)` = anno **non operato**: non e' un anno negativo, e' un anno **assente**.
🔴 Il **2026** e' **mezzo anno** (fino al 2026.06.30).

| ID | EA | simbolo | risch | **2020** | **2021** | **2022** | **2023** | **2024** | **2025** | **2026** | totale |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| F02 | `ABTG_BreakingBand` | EURUSD | 1.00% | +188 *(4)* ⚠️ | -506 *(9)* ⚠️ | +1058 *(7)* ⚠️ | +954 *(12)* ⚠️ | +3878 *(12)* ⚠️ | +1124 *(7)* ⚠️ | +1575 *(8)* ⚠️ | **+8271** |
| F17 | `ABTG_PunteLarry` | EURCAD | 1.00% | +1536 *(30)* | +3962 *(23)* ⚠️ | +1099 *(29)* ⚠️ | -1292 *(22)* ⚠️ | +9012 *(18)* ⚠️ | +145 *(23)* ⚠️ | +318 *(9)* ⚠️ | **+14780** |
| F04 | `ABTG_CostToCost` | EURJPY | 1.00% | +4991 *(66)* | +1115 *(51)* | +13036 *(59)* | +17339 *(63)* | +16642 *(67)* | +45187 *(58)* | -4007 *(30)* | **+94303** |
| F20 | `ABTG_PunteLarry` | XAUUSD | 0.30% | +1548 *(8)* ⚠️ | +1734 *(11)* ⚠️ | -1328 *(7)* ⚠️ | +158 *(9)* ⚠️ | +1150 *(10)* ⚠️ | +1448 *(7)* ⚠️ | +234 *(8)* ⚠️ | **+4944** |
| F03 | `ABTG_BreakingBand` | AUDUSD | 1.00% | -224 *(9)* ⚠️ | +309 *(9)* ⚠️ | +1482 *(11)* ⚠️ | -96 *(13)* ⚠️ | +962 *(8)* ⚠️ | +1334 *(7)* ⚠️ | +1598 *(7)* ⚠️ | **+5365** |
| F18 | `ABTG_PunteLarry` | GBPJPY | 1.00% | -1456 *(18)* ⚠️ | -222 *(27)* ⚠️ | +2378 *(17)* ⚠️ | +758 *(16)* ⚠️ | +6870 *(22)* ⚠️ | +4101 *(29)* ⚠️ | +4791 *(10)* ⚠️ | **+17220** |
| F23 | `ABTG_MaxMinNotte` | XAUUSD | 0.50% | +223 *(89)* | -274 *(107)* | +6603 *(114)* | -2703 *(104)* | +6867 *(124)* | +6420 *(113)* | +7601 *(42)* | **+24737** |
| F24 | `ABTG_SupertrendReversal_Ottimizzato` | XAUUSD | 1.00% | -572 *(24)* ⚠️ | -2292 *(34)* | +767 *(24)* ⚠️ | -200 *(27)* ⚠️ | +1624 *(38)* | +4807 *(48)* | +658 *(13)* ⚠️ | **+4792** |
| F08 | `ABTG_EasyTrend` | GBPUSD | 1.00% | -3289 *(40)* | +2113 *(39)* | -2603 *(44)* | +289 *(46)* | -3693 *(23)* ⚠️ | +8061 *(43)* | +7658 *(19)* ⚠️ | **+8536** |
| F01 | `ABTG_BreakingBand` | GBPUSD | 1.00% | -1675 *(21)* ⚠️ | -3853 *(19)* ⚠️ | +2718 *(15)* ⚠️ | +1194 *(18)* ⚠️ | +3300 *(18)* ⚠️ | +4670 *(22)* ⚠️ | -941 *(13)* ⚠️ | **+5413** |
| F22 | `ABTG_EMA200_Ottimizzato` | XAUUSD | 0.25% | +483 *(103)* | +1243 *(135)* | -304 *(62)* | -1023 *(56)* | +2378 *(141)* | -140 *(81)* | +472 *(32)* | **+3109** |
| F09 | `ABTG_EasyTrend` | AUDJPY | 1.00% | -3563 *(42)* | +4656 *(49)* | +215 *(48)* | -3675 *(50)* | -4162 *(50)* | +4263 *(49)* | +4210 *(25)* ⚠️ | **+1944** |
| F15 | `ABTG_PTE` | USDJPY | 1.00% | +601 *(48)* | -4688 *(22)* ⚠️ | -2190 *(37)* | +5895 *(45)* | +1657 *(41)* | -135 *(38)* | +2265 *(13)* ⚠️ | **+3405** |
| F19 | `ABTG_PunteLarry` | GBPUSD | 1.00% | -6093 *(19)* ⚠️ | +2966 *(19)* ⚠️ | +1232 *(14)* ⚠️ | -343 *(18)* ⚠️ | -1404 *(20)* ⚠️ | +3267 *(19)* ⚠️ | +1987 *(12)* ⚠️ | **+1612** |
| F16 | `ABTG_PunteLarry` | EURAUD | 1.00% | +716 *(38)* | -4370 *(30)* | -1412 *(31)* | -6147 *(40)* | +6271 *(27)* ⚠️ | +9199 *(34)* | +438 *(16)* ⚠️ | **+4695** |
| F12 | `ABTG_GapFill` | AUDUSD | 1.00% | — *(n=0)* | — *(n=0)* | — *(n=0)* | — *(n=0)* | +966 *(3)* ⚠️ | +222 *(3)* ⚠️ | +4161 *(11)* ⚠️ | **+5349** |
| F13 | `ABTG_PTE` | GBPUSD | 0.50% | +798 *(25)* ⚠️ | -453 *(17)* ⚠️ | -2596 *(19)* ⚠️ | -1134 *(25)* ⚠️ | +1480 *(38)* | -180 *(26)* ⚠️ | +1534 *(25)* ⚠️ | **-551** |
| F07 | `ABTG_EasyTrend` | CHFJPY | 1.00% | -3911 *(30)* | -8172 *(42)* | -347 *(34)* | +4764 *(53)* | -1882 *(31)* | +14361 *(51)* | +4785 *(24)* ⚠️ | **+9598** |
| F05 | `ABTG_CostToCost` | GBPCAD | 1.00% | +1486 *(62)* | -10843 *(57)* | -13470 *(57)* | -8367 *(58)* | -302 *(56)* | +12896 *(63)* | +3621 *(29)* ⚠️ | **-14979** |
| F25 | `Gold_Ichimoku_TK_ATR_EA` | XAUUSD | 0.50% | +44077 *(81)* | -15504 *(87)* | -6549 *(79)* | +10727 *(85)* | -3253 *(87)* | +45823 *(88)* | -835 *(46)* | **+74486** |
| F11 | `ABTG_GapFill` | EURUSD | 1.00% | — *(n=0)* | — *(n=0)* | — *(n=0)* | — *(n=0)* | -507 *(2)* ⚠️ | +1284 *(3)* ⚠️ | +2247 *(9)* ⚠️ | **+3024** |
| F10 | `ABTG_GapFill` | GBPUSD | 1.00% | -998 *(1)* ⚠️ | — *(n=0)* | — *(n=0)* | — *(n=0)* | -37 *(2)* ⚠️ | +1251 *(2)* ⚠️ | +4256 *(8)* ⚠️ | **+4472** |
| F14 | `ABTG_PTE` | GBPUSD | 0.50% | -30 *(25)* ⚠️ | -293 *(18)* ⚠️ | -967 *(22)* ⚠️ | -604 *(27)* ⚠️ | +1979 *(43)* | -384 *(27)* ⚠️ | +1201 *(26)* ⚠️ | **+902** |
| F21 | `ABTG_SuperWave` | GBPUSD | 1.00% | -2964 *(69)* | -2931 *(56)* | -62 *(60)* | -2258 *(41)* | -3276 *(46)* | +2845 *(54)* | +1144 *(32)* | **-7502** |
| F06 | `ABTG_CostToCost` | XAGUSD | 1.00% | -1156 *(11)* ⚠️ | -2531 *(5)* ⚠️ | -5682 *(7)* ⚠️ | -2018 *(4)* ⚠️ | -1983 *(10)* ⚠️ | +3565 *(20)* ⚠️ | -1895 *(26)* ⚠️ | **-11700** |

## 5.2 Le tre epoche, nell'anno solare che le CONTIENE — netto **@1%**
🔴 Si rilegga §2 prima di usare questa tabella: **solo la colonna 2021 e' l'epoca**.

| ID | EA | simbolo | **anno 2020** *(contiene CROLLO 02-04, 3 mesi su 12)* | **anno 2021** *(= TORO, 12 mesi su 12)* | **anno 2022** *(contiene ORSO 01-10, 10 mesi su 12)* | epoche + / operate |
|---|---|---|---:|---:|---:|:---:|
| F02 | `ABTG_BreakingBand` | EURUSD | +188 *(4)* ⚠️ | -506 *(9)* ⚠️ | +1058 *(7)* ⚠️ | 2/3 |
| F17 | `ABTG_PunteLarry` | EURCAD | +1536 *(30)* | +3962 *(23)* ⚠️ | +1099 *(29)* ⚠️ | 3/3 |
| F04 | `ABTG_CostToCost` | EURJPY | +4991 *(66)* | +1115 *(51)* | +13036 *(59)* | 3/3 |
| F20 | `ABTG_PunteLarry` | XAUUSD | +5160 *(8)* ⚠️ | +5780 *(11)* ⚠️ | -4427 *(7)* ⚠️ | 2/3 |
| F03 | `ABTG_BreakingBand` | AUDUSD | -224 *(9)* ⚠️ | +309 *(9)* ⚠️ | +1482 *(11)* ⚠️ | 2/3 |
| F18 | `ABTG_PunteLarry` | GBPJPY | -1456 *(18)* ⚠️ | -222 *(27)* ⚠️ | +2378 *(17)* ⚠️ | 1/3 |
| F23 | `ABTG_MaxMinNotte` | XAUUSD | +446 *(89)* | -548 *(107)* | +13206 *(114)* | 2/3 |
| F24 | `ABTG_SupertrendReversal_Ottimizzato` | XAUUSD | -572 *(24)* ⚠️ | -2292 *(34)* | +767 *(24)* ⚠️ | 1/3 |
| F08 | `ABTG_EasyTrend` | GBPUSD | -3289 *(40)* | +2113 *(39)* | -2603 *(44)* | 1/3 |
| F01 | `ABTG_BreakingBand` | GBPUSD | -1675 *(21)* ⚠️ | -3853 *(19)* ⚠️ | +2718 *(15)* ⚠️ | 1/3 |
| F22 | `ABTG_EMA200_Ottimizzato` | XAUUSD | +1932 *(103)* | +4972 *(135)* | -1216 *(62)* | 2/3 |
| F09 | `ABTG_EasyTrend` | AUDJPY | -3563 *(42)* | +4656 *(49)* | +215 *(48)* | 2/3 |
| F15 | `ABTG_PTE` | USDJPY | +601 *(48)* | -4688 *(22)* ⚠️ | -2190 *(37)* | 1/3 |
| F19 | `ABTG_PunteLarry` | GBPUSD | -6093 *(19)* ⚠️ | +2966 *(19)* ⚠️ | +1232 *(14)* ⚠️ | 2/3 |
| F16 | `ABTG_PunteLarry` | EURAUD | +716 *(38)* | -4370 *(30)* | -1412 *(31)* | 1/3 |
| F12 | `ABTG_GapFill` | AUDUSD | — *(n=0)* | — *(n=0)* | — *(n=0)* | 0/0 |
| F13 | `ABTG_PTE` | GBPUSD | +1596 *(25)* ⚠️ | -906 *(17)* ⚠️ | -5192 *(19)* ⚠️ | 1/3 |
| F07 | `ABTG_EasyTrend` | CHFJPY | -3911 *(30)* | -8172 *(42)* | -347 *(34)* | 0/3 |
| F05 | `ABTG_CostToCost` | GBPCAD | +1486 *(62)* | -10843 *(57)* | -13470 *(57)* | 1/3 |
| F25 | `Gold_Ichimoku_TK_ATR_EA` | XAUUSD | +88154 *(81)* | -31008 *(87)* | -13098 *(79)* | 1/3 |
| F11 | `ABTG_GapFill` | EURUSD | — *(n=0)* | — *(n=0)* | — *(n=0)* | 0/0 |
| F10 | `ABTG_GapFill` | GBPUSD | -998 *(1)* ⚠️ | — *(n=0)* | — *(n=0)* | 0/1 |
| F14 | `ABTG_PTE` | GBPUSD | -60 *(25)* ⚠️ | -586 *(18)* ⚠️ | -1934 *(22)* ⚠️ | 0/3 |
| F21 | `ABTG_SuperWave` | GBPUSD | -2964 *(69)* | -2931 *(56)* | -62 *(60)* | 0/3 |
| F06 | `ABTG_CostToCost` | XAGUSD | -1156 *(11)* ⚠️ | -2531 *(5)* ⚠️ | -5682 *(7)* ⚠️ | 0/3 |

## 5.3 Il rischio che questo referto **NON** misura — colonne copiate da R103 TAB 1
Sono qui **per contrasto**, non come risultato di R219: sono **DD di FINESTRA INTERA**,
non per epoca. `n/d` sul promesso = il contratto **non da' un numero confrontabile**:
🔴 **non e' un via libera, e' un rilievo**. E un DD sopra il promesso **non e' una revisione
automatica**: il promesso e' stato misurato su **un'altra finestra** (regola del 18/08: la
C3 gira sul **FORWARD**).

| ID | EA | simbolo | n | PF | DD-VIVO | DD @1% | DD PROMESSO | rapporto |
|---|---|---|---:|---:|---:|---:|---:|---:|
| F02 | `ABTG_BreakingBand` | EURUSD | 59 | 1.936 | 2.51 | 2.51 | 1.20 | 2.09x |
| F17 | `ABTG_PunteLarry` | EURCAD | 154 | 1.338 | 6.96 | 6.96 | 4.80 | 1.45x |
| F04 | `ABTG_CostToCost` | EURJPY | 394 | 1.410 | 12.26 | 12.26 | 9.33 | 1.31x |
| F20 | `ABTG_PunteLarry` | XAUUSD | 60 | 1.753 | 2.44 | 8.13 | n/d | **non calcolabile** |
| F03 | `ABTG_BreakingBand` | AUDUSD | 64 | 1.541 | 2.13 | 2.13 | 1.20 | 1.77x |
| F18 | `ABTG_PunteLarry` | GBPJPY | 139 | 1.288 | 8.95 | 8.95 | 2.70 | 3.31x |
| F23 | `ABTG_MaxMinNotte` | XAUUSD | 693 | 1.308 | 5.32 | 10.64 | n/d | **non calcolabile** |
| F24 | `ABTG_SupertrendReversal_Ottimizzato` | XAUUSD | 208 | 1.330 | 3.51 | 3.51 | n/d | **non calcolabile** |
| F08 | `ABTG_EasyTrend` | GBPUSD | 254 | 1.059 | 15.77 | 15.77 | 4.58 | 3.44x |
| F01 | `ABTG_BreakingBand` | GBPUSD | 126 | 1.199 | 7.75 | 7.75 | 1.90 | 4.08x |
| F22 | `ABTG_EMA200_Ottimizzato` | XAUUSD | 610 | 1.203 | 1.95 | 7.80 | n/d | **non calcolabile** |
| F09 | `ABTG_EasyTrend` | AUDJPY | 313 | 1.013 | 15.88 | 15.88 | 4.29 | 3.70x |
| F15 | `ABTG_PTE` | USDJPY | 244 | 1.083 | 11.49 | 11.49 | 3.97 | 2.89x |
| F19 | `ABTG_PunteLarry` | GBPUSD | 121 | 1.048 | 8.51 | 8.51 | 5.10 | 1.67x |
| F16 | `ABTG_PunteLarry` | EURAUD | 216 | 1.053 | 17.12 | 17.12 | 3.70 | 4.63x |
| F12 | `ABTG_GapFill` | AUDUSD | 17 | 2.270 | 1.87 | 1.87 | 1.90 | 0.98x |
| F13 | `ABTG_PTE` | GBPUSD | 175 | 0.962 | 6.55 | 13.10 | n/d | **non calcolabile** |
| F07 | `ABTG_EasyTrend` | CHFJPY | 265 | 1.066 | 21.80 | 21.80 | 6.27 | 3.48x |
| F05 | `ABTG_CostToCost` | GBPCAD | 382 | 0.924 | 41.52 | 41.52 | 6.18 | 6.72x |
| F25 | `Gold_Ichimoku_TK_ATR_EA` | XAUUSD | 553 | 1.311 | n/d | n/d | n/d | **non calcolabile** |
| F11 | `ABTG_GapFill` | EURUSD | 14 | 2.452 | 1.85 | 1.85 | 1.50 | 1.23x |
| F10 | `ABTG_GapFill` | GBPUSD | 13 | 2.459 | 2.50 | 2.50 | 2.40 | 1.04x |
| F14 | `ABTG_PTE` | GBPUSD | 188 | 1.108 | 2.92 | 5.84 | n/d | **non calcolabile** |
| F21 | `ABTG_SuperWave` | GBPUSD | 358 | 0.785 | 13.41 | 13.41 | 1.04 | 12.89x |
| F06 | `ABTG_CostToCost` | XAGUSD | 83 | 0.696 | 16.37 | 16.37 | 4.48 | 3.65x |

---

# 6. 🎯 LA BUSSOLA — chi merita una corsa vera per il **DD PER EPOCA**, in ordine, col costo

**Il conto delle passate non lo invento**: uso l'ancora gia' scritta in
`report/I_MORTI_E_LO_STORICO_2026-09-23.md` §4 — **1 finestra = 1 cella = 2 passate gemelle**,
**0,30 min/cella (ancora R113) → 0,70 min/cella (tetto prudente)**, cioe' **0,15 / 0,35 min
per passata**. Le quattro finestre canoniche costano quindi **8 passate = 1,2 / 2,8 min per sedia**.

| ordine | sedia | perche' proprio lei, col numero | finestre | **passate** | **minuti (ancora / tetto)** |
|---:|---|---|:---:|---:|---:|
| **1** | 🥇 `CostToCost` **EURJPY** H4 (F04, magic vivo **772361**) | **6/7 anni positivi**, **3/3 epoche**, **n=394 senza un solo anno sottile**, senza-i-due-migliori **+31.777 @1%**. 🔴 Ma **DD 12,26% @1% contro 9,33% promesso = 1,31×**: il merito e' il piu' solido del lotto e **il rischio per epoca e' esattamente cio' che non si sa** | 4 canoniche | **8** | **1,2 / 2,8** |
| **2** | 🥈 `MaxMinNotte` **XAUUSD** H2 (F23, `770402`) | **n=693**, il campione piu' grosso; senza-i-due-migliori **+20.538 @1%**; e l'anomalia gia' verificata in §1.1 (**perde nel TORO, guadagna nell'ORSO**) chiede una spiegazione che solo il DD per epoca da'. 🟢 **Gia' in cima alla coda del dossier del 23/09 (riga 1): queste 8 passate sono LE STESSE, non si sommano** | 4 canoniche | **8** *(gia' contate)* | **1,2 / 2,8** *(gia' contati)* |
| **3** | 🥉 `PunteLarry` **GBPJPY** H1 (F18, magic vivo **772344**) | passa la B2 (**+5.559 @1%**) ed e' la sedia col **divario promesso/misurato piu' largo fra quelle sane: DD 8,95% contro 2,70% = 3,31×**. 🔴 E **tutti e sette gli anni hanno n<30** ⇒ il merito e' sospeso, **il rischio no** | 4 canoniche | **8** | **1,2 / 2,8** |
| **4** | `PunteLarry` **EURCAD** H1 (F17, magic vivo **772346**) | **6/7 anni** e **3/3 epoche** — l'unica altra sedia con le tre epoche tutte verdi. 🔴 Ma **sei anni su sette con n<30** e B2 di soli **+1.806**: la corsa serve a dire se e' solida o sottile | 4 canoniche | **8** | **1,2 / 2,8** |
| **5** | `Gold_Ichimoku` **XAUUSD** H1 (F25, magic vivo **250604**) | 🔴 **per il motivo opposto a tutti gli altri: e' la piu' ricca del lotto e il suo DD di equity NON ESISTE** (nessun OPTFRAME). Senza-i-due-migliori **−30.828 @1%**. Una corsa per epoca qui serve a sapere **se e' schierabile o no**, non a raffinare | 4 canoniche | **8** | **1,2 / 2,8** |

### 💰 IL TOTALE, e la parte che si paga davvero
**5 sedie × 4 finestre = 20 celle = 40 passate = 6,0 min (ancora) → 14,0 min (tetto).**
🟢 **Al netto della sedia 2, che il dossier del 23/09 ha gia' messo in conto**:
**4 sedie = 16 celle = 32 passate = 4,8 → 11,2 min.**
👉 **Non e' un round: e' un quarto d'ora di banco** — e sul **PC di backtest**, non sul VPS
(regola del 21/09).

### ❌ E chi **non** propongo, per nome (classe 180: mai «tutto il resto»)
- **`BreakingBand` EURUSD / AUDUSD (F02, F03)**, **`PunteLarry` XAUUSD (F20)** — passano la
  B2, ma **n=59/64/60 su 6,5 anni** ⇒ **ogni singolo anno sta fra 4 e 13 operazioni**. Una
  finestra di regime da 3-12 mesi conterrebbe **0-3 operazioni**: il DD per epoca sarebbe il
  DD di due trade. 🔴 **Prima serve il campione, non la finestra.**
- **Le tre `GapFill` (F10, F11, F12)** — §4.5: **zero operazioni nelle tre epoche**. Una
  corsa sulle quattro finestre tornerebbe **vuota per costruzione**.
- **Le dieci sedie con bandiera B1 in §4.3** — il DD per epoca **non e' la misura che gli
  manca**: gli manca una ragione per cui l'anno buono dovrebbe ripetersi. Quella e' una
  domanda di **meccanismo**, e costa una **seconda caccia** (regola del 19/08), non 8 passate.
- **Le quattro sedie in perdita sulla finestra (F13, F05, F21, F06)** — 🔴 **e NON le
  archivio**: il certificato di morte chiede **gestione dell'uscita messa ad asse**,
  **simboli gemelli** e **TF cambiato**, e da questo file **non si vede nessuna delle tre**.
  Verdetto: **NON ANCORA MISURATO**, cosa manca = quelle tre voci.

---

# 7. 🧾 IL RILIEVO TROVATO STRADA FACENDO — `Gold_Ichimoku` non quadra con se stessa

Riconciliando totale e dettaglio (la regola gia' a checklist: *«il totale e il dettaglio non
vengono mai dalla stessa riga: si RICONCILIANO»*), **24 sedie su 25 chiudono entro 3 EUR di
arrotondamento**. Una no:

| sedia | totale dichiarato in testa | ultimo **CUMULATO** della sua spina dorsale | somma delle sue 7 righe | **scarto** |
|---|---:|---:|---:|---:|
| **F25 `Gold_Ichimoku_TK_ATR_EA` XAUUSD** | **+75.436** | **+74.488** | **+74.486** | 🔴 **−950 EUR (1,26%)** |

🔴 **Lo scarto e' INTERNO al file**: l'intestazione del blocco e il suo stesso dettaglio non
si chiudono, e la riga del cumulato finale — che e' il totale, gratis — **non e' mai stata
confrontata con l'intestazione**. E' l'unica sedia **senza OPTFRAME** (numeri presi dai
DEAL), quindi il sospetto e' li', ma **resta un sospetto: non lo risolvo da qui**.
🟢 **Non cambia nessun segno e nessuna conclusione** di questo referto (1,26% su una sedia
gia' classificata fragile per altri due motivi). ➜ Registrato come **classe 609** in
`backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md`.

---

# 8. 📌 CIO' CHE NON HO COPERTO, per nome

| # | non coperto | perche' |
|---|---|---|
| 1 | **LATERALE 2019** — su tutte e 25 le sedie | 🔴 la finestra R103 parte dal **2020.01.01**. Serve una corsa. E' la **quarta** epoca: senza di lei la prova di regime e' **3/4** |
| 2 | **Il DD per epoca** — su tutte e 25 | il file da' il netto **realizzato**, non l'equity (§0 punto 1). E' esattamente cio' che §6 propone di comprare con 32-40 passate |
| 3 | **Il CROLLO puro** (`2020.02.01-2020.04.30`) — su tutte e 25 | qui c'e' l'**anno 2020**, che lo diluisce **4×** (§2). Il file **non** ha il dettaglio mensile per il forex |
| 4 | **L'ORSO puro** (`2022.01.01-2022.10.31`) — su tutte e 25 | qui c'e' l'**anno 2022**: mancano **nov-dic 2022**, diluizione 1,2× |
| 5 | **Le altre 15 sedie della flotta** (le sedie INDICI) | 🔴 **In questo file NON CI SONO, e il file lo dichiara in riga 2**: *«25 sedie su 40 (FOREX+METALLI 25, **INDICI 0**)»* — la corsa e' girata con lo switch `-SoloGruppo FOREX`. **Non e' una tabella 2 che non ho letto: e' una tabella che non esiste qui.** E anche se ci fosse: la finestra INDICI dichiarata a riga 4 e' `2024.09.26 → 2026.06.30` (21 mesi), **nessuna delle tre epoche ci cade dentro**, e R103 punto 3 vieta comunque il confronto (*«6,5 anni e 21 mesi nella stessa classifica sarebbero la truffa peggiore del round»*) ⇒ **la prova di regime sugli indici non e' misurabile da nessun file di R103** |
| 6 | **Il modello a tick** — su tutte e 25 | R103 gira a **modello 1 (OHLC M1)**, e il file dichiara che **sugli indici l'OHLC ha gia' mentito** (`SupRev_DOW_H4`: PF 2,77 OHLC → **0,79** a tick reali, 30/07). Sul forex il fattore **non e' misurato in questo referto** |
| 7 | **Lo scarto di 950 EUR su `Gold_Ichimoku`** (§7) | e' un rilievo **aperto**: non ho lo zip `F25_report_singola.htm` per chiuderlo, e non giro nulla per ottenerlo (sola lettura) |
| 8 | **Il forward reale** di tutte le sedie | questo e' un **backtest**. La regola del 18/08 (criterio di uscita C3) gira sul **FORWARD**: niente di qui tocca quella corsia |
| 9 | **Ogni verdetto di archiviazione** | vietato dal perimetro, e comunque impossibile: manca il **DD per finestra** su tutte e 25 ⇒ certificato di morte incompleto per costruzione |

---

## 🔒 PERIMETRO RISPETTATO
🟢 **Zero minuti macchina** · 🟢 nessuna riga verso il VPS o verso Claudio · 🟢 nessun round,
nessun preset, nessun forward, nessuna sedia toccata · 🟢 nessun file prova scritto ·
🟢 **niente sul conto reale 10105439**, nessuna taglia, nessun parametro di rischio, nessuna
spesa · 🟢 nessun candidato archiviato.

**File prodotti da R219:** questo referto · la voce **classe 609** in
`backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md`.
