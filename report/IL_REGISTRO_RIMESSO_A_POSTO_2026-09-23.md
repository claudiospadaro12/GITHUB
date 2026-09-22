# 🗂️ IL REGISTRO RIMESSO A POSTO — `REGISTRO_TEST.md`, 22-23/09/2026

**Branch `lavoro`** · 🛑 **SOLA LETTURA SU TUTTO IL RESTO**: nessun round lanciato, nessuna riga
consegnata a Claudio, niente sul VPS, niente sul forward, nessun preset toccato, nessuna sedia
accesa o spenta, nessun file prova scritto. **Ho toccato `backtest_pipeline/REGISTRO_TEST.md`
e basta** (piu' questo referto).

> ## 🎯 IN SEI RIGHE
> 1. 🔴 **Il registro dichiarava MORTO un motore che sta operando in challenge.** La riga A4
>    *«Nasdaq_Apertura_US — 🔴 morto, best PF 0,91»* riguarda la sedia **`770260`**, viva su FTMO
>    `541452707` dal 21/09. **Riscritta col numero della cella che opera davvero.**
> 2. 🔴 **Tredici round girati non erano archiviati.** `R172D` `R196A` `R197A` `R197B` `R198`
>    `R199A` `R199B` `R200A` `R200C` `R200E` `R201A` `R202A` `R202B`: **zero occorrenze** prima di
>    oggi. **Ora hanno una riga ciascuno, con l'asse, il rischio, il modello e il verdetto.**
> 3. 🏆 **Chiuso un buco che il registro dichiarava aperto**: la tabella «studio aperture FASE A
>    su 8 indici» **e' in repo** — e dice che **il Dow e' PRIMO**, ribaltando la *«CONCLUSIONE
>    APERTURA (definitiva)»*.
> 4. 📏 **Aggiunta in testa la sezione «COME SI LEGGE QUESTO REGISTRO»**: MODELLO accanto al PF,
>    `InpRiskPercent` accanto al DD, il certificato in cinque caselle, e **la mappa dello storico
>    esterno `_EXT`** (richiesta di Claudio del 23/09).
> 5. ✅ **Due verdetti hanno RETTO al contro-esempio e li ho lasciati in piedi**, dicendolo: la
>    parte *«non costruire altri v2 M5»* e la bocciatura dell'OPENCONFIRM.
> 6. 🟢 **E una vittoria del metodo, che vale la pena dire: in un caso il REGISTRO aveva ragione
>    e il dossier di stanotte torto.** Vince il CSV, anche quando scomoda noi.

---

# 0️⃣ COME HO LAVORATO

**La gerarchia non e' stata derogata: per ogni numero che ho scritto ho aperto il CSV.**
Niente e' stato copiato da un referto. I referti li ho usati per **datare** e per **trovare le
contraddizioni**, mai come fonte di una cifra.

- 🔢 **CSV aperti e letti colonna per colonna**: i 26 dei tredici round
  (`risultati_prove/R*/`), gli 8 `Studio_*_RIEPILOGO.csv`, i 5 `MaxMinNotte/*.csv` (288 passate),
  i 10 `Live5m`/`ORB_Fibo`/`PostNews`, i 2 `Apertura_nuovi_indici`, gli 8 `Dow_Apertura`, i 4
  `Openconfirm`, i 2 `Walkforward_Aperture/NASDAQ_B_motore`.
- 🧾 **`git log --all --pretty=format: --name-only`** per i CSV che *non esistono*.
- 🧪 **Contro-esempio costruito PRIMA di consegnare** per ogni verdetto ribaltato (§3).
- 🚦 **Cancello deterministico passato** su tutto il file (§5).

---

# 1️⃣ ✏️ COSA HO CAMBIATO, E PERCHE' — riga per riga

_(I numeri di riga qui sotto sono quelli **del file di oggi**, dopo le modifiche: le righe si
sono spostate perche' ho inserito una sezione in testa. Le ho trovate **per contenuto**.)_

### 1.1 🔴 La riga **A4** — *«Nasdaq_Apertura_US, morto, best PF 0,91»*

| | |
|---|---|
| **dove** | tabella «1) APERTURE», riga `A4` |
| **diceva** | `real tick \| 0% combo pos, best PF 0.91 \| 🔴 morto` |
| **il fatto** | quel motore **e' la sedia `770260`, e opera su FTMO `541452707` dal 21/09** |
| **fonte** | `mql5/Presets/FTMO/ABTG_Nasdaq_Apertura_US_RETEST_770260_FTMO.set` + `risultati_prove/R199B/*.csv` |

🔴 **Il punto non e' che il numero del 26/07 fosse sbagliato: e' che era il numero di
un'ALTRA configurazione.** Il 26/07 misurava il **breakout cieco LONG-only**; la cella che opera
e' `InpEntryMode=2` (**RETEST**), range 35', buffer 200, **due lati**, `TP1_R=0,5`,
**`TP1_ClosePct=50`**, `TrailMode=1`, `TrailTF=M5`, filtro volumi **ON**, **`InpRiskPercent=2,00`**.

📊 **Numeri della cella che opera, dal CSV** (`R199B` Pass 2, tick reali, banco 80.000, **taglia
2,00% = quella di campo**):

| | IS | OOS |
|---|---|---|
| **PF** | **1,22116** | **1,21546** |
| **n** `[uscite]` | 135 | 172 **(= 102 posizioni)** |
| **`Equity DD %`** | 🟢 **7,3069%** | 🟢 **7,8576%** |

🟢 **Il DD sta SOTTO il muro del 10% ALLA TAGLIA VERA**: non serve raddoppiare niente.
🔴 **Ma il MERITO resta SOSPESO**: 102 posizioni < 150 (Emendamento A del 16/08). *«Merito
sospeso» non e' «morto»: e' «aspetta il campione»* — e il criterio RISCHIO del 18/08 vale su di
lei dal primo giorno, a qualunque `n`.

✅ **E ho corretto ME STESSO prima di consegnare.** La prima stesura di quella riga dava il
punto ④ (gemelli) per **pieno**, elencando U30USD/D30EUR/100GBP/F40EUR. **E' falso**: quei CSV
sono di `ABTG_DAX_Apertura_EU` e `ABTG_Dow_Apertura_US`, **EA diversi**. `ABTG_Nasdaq_Apertura_US`
ha CSV **solo su NASUSD** (verificato su tutta la storia di git). Il punto ④ e' ora **🟡 parziale,
coi gemelli di MECCANISMO distinti da quelli di BINARIO**.

### 1.2 🔴 La *«CONCLUSIONE APERTURA (definitiva)»* e la tabella «NUOVI INDICI»

| | |
|---|---|
| **diceva** | *«funziona SOLO sul DAX, SOLO LONG. Su Nasdaq/FTSE/Dow → morto … L'idea di Marco (Dow>Nasdaq) NON regge … Fine dell'espansione della famiglia aperture»* |

🟢 **Cosa ho TENUTO, per intero** — perche' e' vero e riverificato sul CSV: il **breakout cieco**
non paga su Dow ne' FTSE. `valid_Apertura_U30USD_Dow.csv` best **PF 0,99721 · Profit −9,00 ·
DD 8,5752% · n 360**; `valid_Apertura_100GBP_FTSE.csv` best **0,90423 · −302,12 · 9,5820% · 283`.
**0 celle su 96 sopra 1,00 su tutti e due**, tick reali, rischio 1%. **I due numeri del 26/07
reggono al centesimo.**

🔴 **Cosa ho riscritto, e con quali misure:**

**(a) «Fine dell'espansione»** — la famiglia e' **meta' della challenge**: `770101` DAX,
`770202` Dow, `770260` Nasdaq operano dal 21/09.

**(b) «Su Dow → morto»** — era un verdetto sul **BREAKOUT**, spacciato per verdetto sul
**MOTORE**. `R197A` mette `InpEntryMode` 0/1/2 sullo stesso asse su `U30USD`, tick reali:

| `InpEntryMode` | IS PF · n · DD | OOS PF · n · DD |
|---|---|---|
| **0 BREAKOUT** | 🔴 0,96503 · 87 · 11,99% | 1,18772 · 162 · 8,86% |
| **2 RETEST** | 🟢 **1,21214** · 74 · 11,09% | 🟢 **1,25384** · 130 · 8,75% |

**(c) «Dow>Nasdaq NON regge»** — **regge**, su due misure indipendenti. Lo **studio FASE A**
(8 file, 3.302 rotture, 🔴 **OHLC = screening**) mette il **Dow PRIMO** (+0,074 cieco, +0,126 col
filtro H4); e a **tick reali** il Dow fa OOS **1,27175** contro il Nasdaq **1,21546**.

### 1.3 🏆 Il buco *«non ho trovato la tabella FASE A»* — **CHIUSO col percorso**

Il registro lo dichiarava **aperto**. **E' in repo**:
**`backtest_pipeline/risultati_archivio/studio_apertura/Studio_<SIMBOLO>_RIEPILOGO.csv`** — 8 file
piu' 8 per-trade, committati il **03/08/2026**.

🧪 **Non mi sono fidato del nome del file: ho costruito la prova CONTRO la mia ipotesi.**
`Dow_Apertura/DOW_MOTORE.md` cita **di seconda mano** quattro effetti del filtro H4 senza mai
linkarne la fonte. Se i CSV sono quelli, l'effetto calcolato (riga *«Con FILTRO H4»* meno riga
*«TUTTI i breakout»*) deve riprodurli **tutti e quattro**:

| indice | Δ calcolato dal CSV | Δ citato da `DOW_MOTORE.md` | esito |
|---|---:|---:|---|
| `U30USD` | **+0,052** | +0,052 | ✅ |
| `D30EUR` | **−0,043** | −0,043 | ✅ |
| `F40EUR` | **−0,053** | −0,053 | ✅ |
| `E35EUR` | **−0,081** | −0,081 | ✅ |

🟢 **4 su 4 alla terza cifra.** La tabella e' identificata.
✏️ **E due dettagli della vecchia riga erano sbagliati**: le rotture sono **3.302**, non
«~3.500»; e il modello **non e' a tick, e' OHLC M1**.
🔴 **E la risposta alla domanda che il buco poneva e' «SI»**: `F40EUR` ha gia' un numero, ed e'
**−0,056**. Quindi `R138a` **e' un ritest di un caduto** e serve la tesi nuova — che c'e' (la
cella viva e' un **RETEST**, non la rottura cieca). **Lo stesso vale per `E50EUR` (−0,048),
`E35EUR` (−0,048) e `SPXUSD` (−0,017): NON sono «caselle libere».**

### 1.4 🔴 Il *«capitolo BREAKOUT M5 CHIUSO»* — riscritto, ma **meta' l'ho tenuta**

🟢 **TENUTO, col numero**: la rottura secca della candela pre-apertura da 5 minuti, a due lati,
senza filtro di trend e senza cancello d'ampiezza, **non paga** — e muore **prima sul RISCHIO**:
`DAX_Live5m` OOS **0,85701 · 342 deal · DD 39,74% @ 2,00%**; `Nasdaq_Live5m` OOS **0,96265 · 175 ·
19,40% @ 2,00%**; `Live5m_v2` ramo `PrevWin=5`/ST OFF **0,846-0,951 · DD 16,1-26,1% @ 1,00%**
(= 31,5-51,9% alla taglia FTMO).

🔴 **CORRETTO**, perche' la frase dava per morti motori **mai misurati**:
- **`ABTG_DAX_M3` e `ABTG_Londra_ORB` non hanno MAI avuto un CSV.** Riverificato da me con
  `git log --all --pretty=format: --name-only`: sull'intera storia del repo i soli file che
  portano quei nomi sono `.mq5`, `.set`, `.ini`, `.pine`, `.md`. **Zero risultati.** E i loro
  `.ini` dichiarano **`Model=1` = OHLC**. ⇒ **⚪ NON ANCORA MISURATI, zero punti su cinque.**
- **Anche le corse a tick citate (27+27 passate) non hanno CSV agli atti.**
- **Nessuno dei sei e' mai stato girato su un TF diverso dal suo.** E nell'unica volta in cui il
  TF effettivo e' stato alzato (finestra d'ingresso **5'→15'**), il PF sale in **4 coppie
  distinte su 4** (+0,077 / +0,085 / +0,089 / +0,136) e il DD scende di **5,64-11,26 punti**.
- **Due dei sei non sono breakout d'apertura** (`DAX_M3` = Supertrend H4/M3; `ORB_Fibo` = LIMIT
  in Golden Zone = **retest**): errore di categoria.
- **`Londra_ORB` ha misurato le 07:00, mentre Londra apre alle 08:00 server** (misurato il 03/09).

### 1.5 🔴 Stoxx50 — **due righe del registro si contraddicevano**

`max 0.59` (tabella MaxMinNotte) contro `best 0,8398` (r.2527 e la sezione «TRE MORTI»), **stesso
simbolo, stesso file**. Riaperto `8eefb007-valid_MaxMin_E50EUR.csv` (72 passate):

| lato | max PF | DD | n |
|---|---:|---:|---:|
| **solo SHORT** | **0,58966** | 12,80% | 71 |
| **solo LONG** | 🔴 **0,83979** ← **il massimo vero del file** | 13,90% | 80 |
| due lati | 0,54031 | 30,16% | 123 |

👉 **Lo 0,59 era il massimo di un SOTTOINSIEME, spacciato per il totale.** Il verdetto **non
cambia** (0 celle su 72 sopra 1,00), il numero si'. 🟢 **Gli altri tre reggono**
(D30EUR 1,18742 · 100GBP 0,67170 · F40EUR 0,99852) — **ma in due casi su quattro il «migliore»
e' il lato LONG, non lo short**, e la colonna «migliore config» era vuota: l'ho riempita.

### 1.6 ⚪ `MaxMinNotte` sui gemelli europei — da *«TRE MORTI COL CERTIFICATO COMPLETO»* a **NON ANCORA MISURATI**

**Il certificato non era completo: manca il punto ⑤.** `InpMgmtTF` vale **`15` in 216 passate su
216** (72+72+72, aperte una per una). E' **la** manopola di TF che su questo motore entra nei
numeri, ed e' rimasta inchiodata a M15 in ogni corsa mai fatta.
🟢 **I numeri restano tutti scritti** e alla taglia FTMO i DD valgono **~80% / ~69% / ~94%**.
👉 Verdetto onesto: **⚪ NON ANCORA MISURATO sul MERITO, 🔴 BOCCIATO SUL RISCHIO** — e il secondo
basta a tenerli fuori dal campo **oggi**, senza bisogno di chiamarli morti.

### 1.7 ⚪ `PostNews` — *«PF 0,00000 su 0 operazioni»* non e' un verdetto

Riverificati gli 4 CSV (8 righe in tutto): **`Profit 0.00`, `PF 0.00000`, `Trades 0` su ogni
riga**. La cella del verdetto portava ancora un 🔴 accanto a *«RITIRATO»*: ora e' **⚪ NESSUNA
MISURA**, zero punti su cinque. 🔴 **PF 0,00000 su 0 operazioni non e' «nessun edge»: e' NESSUNA
MISURA**, e tenerlo in rosso e' il modo in cui un'occasione si perde per sempre.

### 1.8 📏 Le tre colonne che mancavano a tutti + lo **STORICO ESTERNO** — nuova sezione «0)» in testa

Nasce dal difetto di metodo del 22/09 (la classifica mescolava OHLC e tick).
- **MODELLO accanto al PF**, col fattore misurato in casa: **1,714** su `L1`, **1,850** su `L3`,
  **2,246** su `L2`.
- **`InpRiskPercent` accanto al DD**, fattore 1%→2% **1,956-1,990**.
- **Certificato in cinque caselle**, col ⑤ da scrivere **per nome** e la clausola **NON
  APPLICABILE** dove i TF sono cablati.
- 🌍 **Lo storico esterno** (richiesta di Claudio, 23/09), con il cancello ZERO accanto a ogni
  riga: **forex e oro `_EXT` PROMOSSI** (0,0041-0,0110% contro la soglia 0,05%), **oro su disco
  4.884.366 barre M1 dal 2006-03-19**, **`NASUSD_EXT` e `SPXUSD_EXT` IN FRIGO** (0,0756% e
  0,0608%, sopra soglia), **DAX e Dow non importati**.
  🔴 **Col vincolo scritto tre volte: `_EXT` e' fatto di BARRE M1, non di tick** — non e' modello
  4, e un numero `_EXT` **non si confronta con un numero a tick**.
  👉 **Conseguenza che cambia cosa si puo' fare**: ovunque il registro dica *«prova di regime non
  possibile»*, quella frase e' **vera sugli INDICI BCM e FALSA su FOREX e ORO**.
  _(Mappa completa non duplicata: `report/LO_STORICO_ESTERNO_MAPPA_2026-09-23.md`, altro agente.)_
- ✏️ **Corretta l'etichetta «2,5 anni» del Contesto fisso**: sugli indici lo storico parte dal
  **2024.09.26** ⇒ **21 mesi**, non 30.

### 1.9 🗃️ I tredici round — **una riga per round, con l'asse letto dal CSV**

Nuova sezione in coda: **«I TREDICI ROUND DEL 20-21/09/2026»**. Per ognuno: EA e magic, simbolo,
TF, modello, **rischio**, **l'asse vero letto dal CSV** (non dal nome del file), PF IS/OOS,
`n`, DD e **il verdetto**.

🟢 **Tutti e tredici hanno un verdetto scritto da qualche parte**: nessuno e' finito in *«girato,
non ancora giudicato»*. Fonti dei verdetti: `report/DD_NASDAQ_R199_2026-09-21.md`,
`report/DD_NASDAQ_IL_ROUND_GIA_FATTO_2026-09-22.md`, `report/PROFONDITA_RETEST_2026-09-21.md`,
`report/VERDETTO_R202_2026-09-21.md`.

**Il contesto comune, letto e non dedotto**: PC di backtest `DESKTOP-H4D7CAJ`, **modello 4**,
deposito **80.000**, **M5**, `2024.09.26 → 2026.06.30`, **taglio `0.40`** ⇒ IS ~8,5 mesi / OOS
~12,7 mesi. _(Il taglio e' **dichiarato** nel file prova in 4 round su 13; negli altri 9 e' il
**default del driver, che e' lo stesso 0.40** — `walkforward_generico.ps1` r.189. Verificato, non
supposto.)_ **Tutti: `RILIEVI: 0`.**

**I tre risultati che contano:**
1. 🟢 **Una promozione su tredici** (`R199B`, `TP1_ClosePct` 0→50), misurata, firmata e in campo
   in **sei ore**. Porta la sedia **sotto il muro FTMO alla taglia vera**.
2. 🟠 **Una manopola che VINCEVA ed e' stata RITIRATA** (`R199A`, `BEatR=0,5`: domina su PF, DD e
   profitto a operazioni invariate) **perche' non si generalizzava** — Dow e DAX la rifiutano.
3. 🔴 **La prova che una cella NON si trasferisce fra gemelli**: `InpRetestOffsetPts` **400 sul
   Dow** (`R197B`) e **0 sul Nasdaq** (`R198`), misurato lo stesso giorno sugli stessi assi.
   Sul Nasdaq il segno **si inverte fra IS e OOS su 3 celle su 3** e il DD OOS tocca **26,11%**.

🟢 **E una casella del punto ⑤ e' chiusa**: `R200A` ha messo **`InpTrailTF` su NOVE TF**
(M1·M2·M3·M4·M5·M6·M10·M12·M15). **M5 resta**, ed e' l'unico positivo in tutte e due le finestre
con DD OOS sotto il 10%. 🔎 **M1 e' PRIMO in IS (1,13354) e ULTIMO in OOS (0,89257)**: segno
invertito = selezione. 📌 **E' l'UNICO asse di timeframe mai girato in tutta la famiglia APERTURE.**

### 1.10 🔧 Una riparazione di sola resa

La tabella «Il MECCANISMO, ricontato sui per-trade il 18/09» aveva un'intestazione con
`**|vinc./perd.|**`: le due pipe **non escapate** rompevano il conteggio delle colonne e **la
tabella non si renderizzava**. Escapate. **Nessun numero toccato.**
🟢 Dopo la riparazione: **0 righe di tabella incoerenti in tutto il file** (controllo a macchina
su tutte le tabelle, contando solo le pipe non escapate).

---

# 2️⃣ ⚖️ LE CONTRADDIZIONI CHE HO TROVATO E **NON** HO POTUTO SCIOGLIERE

| # | la contraddizione | cosa ho fatto |
|---|---|---|
| **1** | 🔴 **Il *«best PF 0,91»* della riga A4 (26/07) NON HA UN CSV.** Nessun file di quella griglia e' in repo. Ho cercato fra i CSV NASUSD con la colonna `InpSessionHour`: il piu' vicino e' `csv_ablazione/apert_APERT_US_M5_doc_brk_volatrh4corr_realtick_NASUSD.csv` (72 passate, best **0,92574**), ma e' **un'ablazione**, non quella griglia | **L'ho lasciato scritto come numero DICHIARATO, non come misura**, e l'ho detto nel registro. 👉 Di conseguenza **l'argomento «anche nel corpus del 26/07 il Dow batteva il Nasdaq» vale MENO degli altri due**, che sono su CSV. L'ho scritto proprio cosi' |
| **2** | 🔴 **Le «27/27 combo NEGATIVE» di `L1` e `L2` (26/07) non hanno CSV**, in tutta la storia di git | Scritte come **`[NUMERO NON VERIFICABILE]`**. Non le ho cancellate: cancellare un numero non verificabile e' peggio che marcarlo |
| **3** | 🟠 **Un dossier di stanotte contraddice il proprio CSV**: `RIESAME_MORTI_APERTURE_2026-09-22.md` scrive due volte *«il Nasdaq e' quinto»* nella FASE A, mentre **la sua stessa tabella §2.4 e il CSV dicono TERZO** (+0,001, dietro Dow +0,074 e DAX +0,026) | **Ho scritto il CSV** e ho messo l'**errata in chiaro** dentro il registro. La conclusione «Dow primo» non cambia |
| **4** | 🔴 **Lo stesso dossier attribuisce all'OPENCONFIRM un OOS che e' di un altro motore.** Riga O: *«IS 1,81587 / OOS 0,69553, n 108/108, DD 3,75/12,73»*. Il CSV `Walkforward_Aperture/NASDAQ_B_motore_OOS.csv` dice: **`EntryMode=5` vol ON → OOS 0,95586 · n 104 · DD 6,7247**; lo **0,69553 · n 108 · DD 12,7332 e' `EntryMode=3` (RANGE-FADE)**. Il `n=108` identico ha ingannato | 🟢 **E QUI IL REGISTRO AVEVA RAGIONE E IL DOSSIER TORTO**: la tabella del registro porta gia' *«OPENCONFIRM (5) ON \| 1,816 · 108 \| **0,956 · 104**»*, cioe' **il numero giusto**. 👉 **Non ho toccato il registro**, e segnalo il difetto del dossier. ⚠️ **Il verdetto non cambia comunque**: 1,816 → 0,956 resta un crollo sotto 1 |
| **5** | 🟠 Il dossier cita, come frase del registro, *«OPENCONFIRM: una cella positiva su otto»*. **Quella frase oggi nel registro NON c'e'** (`grep`: zero occorrenze). E il conto vero, fatto da me sui 4 CSV `Openconfirm/`, e' **2 celle positive su 8 distinte** (DAX `OCtf=M15` vol OFF **1,00575** e DAX `OCtf=grafico M5` vol ON **1,08636**) | **Non ho modificato il registro**, perche' la frase da correggere non ci sta dentro. Segnalata qui. 🟢 Resta **misurato e vero** il ribaltamento citato: sul DAX `InpOCTimeframe` M5→M15 a volumi ON porta il profitto da **+1.032,77 a −669,00** |
| **6** | 🟠 Il mandato diceva *«r.135/r.136 su `ORB_Fibo` e `DAX_M3`»*. Le righe vere sono **r.134 = `ORB_Fibo`**, **r.135 = `DAX_M3`**, **r.136 = `Londra_ORB`** | **Trovate per contenuto** e corrette tutte e tre. Dichiaro i numeri che ho trovato io |
| **7** | 🟠 `R197A` ha una cella **degenere**: `InpEntryMode=1` produce **2 operazioni** e `PF 0` | Scritta come **cella degenere, `PF 0` = nessuna misura**, non come uno zero. Non l'ho usata per niente |

---

# 3️⃣ 🧪 I CONTRO-ESEMPI — costruiti **contro** i miei stessi ribaltamenti

Regola del 10/09: *prima di consegnare, devo costruire IO l'argomento che mi farebbe sbagliare.*
**Su tre ribaltamenti l'argomento e' caduto. Su due ha retto, e ho lasciato il verdetto vecchio.**

### 🥊 3.1 CADE — *«Dow > Nasdaq»* (ribaltato)
**L'argomento contro di me:** *«La FASE A e' OHLC. Un modello ottimista non puo' ribaltare una
misura a TICK su 96 celle. E col fattore 1,71-1,85 il +0,074 del Dow sparisce.»*
✅ **Il primo pezzo e' giusto, e infatti NON uso la FASE A per promuovere: la uso per ORDINARE
otto indici misurati con la STESSA geometria. Il fattore OHLC→tick colpisce tutti e otto: cancella
il LIVELLO, lascia in piedi la CLASSIFICA.**
🔴 **Il secondo pezzo cade da solo**: `R197A`, `R197B`, `R172D`, `R202A` sono **modello 4**, banco
80.000, `RILIEVI: 0`, **split IS/OOS pulito**, e danno il Dow **positivo in tutte e due le
finestre**. 👉 **Non e' l'OHLC a ribaltare il tick: e' un tick NUOVO a ribaltare un tick VECCHIO
su un'ALTRA configurazione.**

### 🥊 3.2 CADE — *«il breakout M5 non ha edge»* (ristretto a *«non paga SU M5»*)
**L'argomento contro di me:** *«Riaprire sei motori bocciati e' accanimento, e la regola del
19/08 vieta di allargare su un motore senza edge.»*
🔴 **Non regge, perche' la regola del 19/08 vieta *«altri PARAMETRI dello stesso motore morto»* —
e qui non sto proponendo parametri: sto dicendo che due dei sei NON SONO MAI STATI MISURATI
(zero CSV in tutta la storia di git), e che l'unica volta che il TF e' stato alzato il PF e'
salito 4 volte su 4.** Un motore senza CSV non e' un motore senza edge: e' un motore senza misura.
✅ **E la parte che difendeva il verdetto l'ho TENUTA**: *«non costruire altri v2 M5»* resta
in piedi, e il costo (1,2-8,8x lo spread contro i 40x richiesti) lo spiega da solo.

### 🥊 3.3 CADE — *«TRE MORTI COL CERTIFICATO COMPLETO»* (riclassificati)
**L'argomento contro di me:** *«0 celle su 216 sopra 1,00 e DD fino al 94% alla taglia di campo.
Nessun `InpMgmtTF` recupera 30 punti di PF.»*
✅ **E' l'argomento piu' forte del lotto, e in gran parte TIENE** — tanto che **non ho scritto
«riaprirli»**: ho scritto **⚪ NON ANCORA MISURATO sul MERITO + 🔴 BOCCIATO SUL RISCHIO**, e il
secondo basta a tenerli fuori dal campo **oggi**. Ma il titolo *«certificato COMPLETO»* era
**falso al punto ⑤**, e un certificato falso e' il modo in cui un'occasione sparisce.
📌 **Priorita' dichiarata: BASSA.** Nessuno dei tre diventa una sedia per il 1° ottobre.

### ✅ 3.4 REGGE — la bocciatura dell'**OPENCONFIRM**: **verdetto vecchio LASCIATO IN PIEDI**
Avevo davanti un dossier che contestava il registro. **Sono andato al CSV, e il registro aveva
ragione**: `EntryMode=5` vol ON fa **IS 1,81587 → OOS 0,95586**, crollo sotto 1; e
`InpOCTimeframe` M5→M15 ribalta il DAX da **+1.032,77 a −669,00**. **Non ho cambiato niente.**

### ✅ 3.5 REGGE — i due numeri del 26/07 su Dow e FTSE: **LASCIATI IN PIEDI, al centesimo**
Li ho riaperti aspettandomi di trovarli gonfiati. **Tornano tutti**: 0,99721 / −9,00 / 8,5752% /
360 e 0,90423 / −302,12 / 9,5820% / 283, **0 celle su 96 sopra 1,00 su tutti e due**.
👉 **Ho ristretto il loro AMBITO (valgono per il breakout cieco), non il loro valore.**

---

# 4️⃣ 🔴 NON COPERTO — per nome, non per categoria

1. 🔴 **Non ho riverificato l'intero registro.** Ho aperto i CSV **delle righe del mandato** piu'
   quelle che quelle righe tiravano dentro. **Il resto del file resta com'era**, e non e' stato
   certificato da me. Un registro di 4.145 righe non si riverifica in una sessione: **questa e'
   una passata mirata, non un censimento.**
2. 🔴 **Il punto ③ (gestione dell'uscita) l'ho compilato solo dove il CSV lo diceva.** Dove ho
   scritto 🟡 o ✅ mi sono basato sugli assi presenti nei CSV che ho aperto. **Non ho fatto la
   Tabella B dell'uscita per ogni motore del registro.**
3. 🔴 **Il punto ④ (gemelli) puo' essere sbagliato altrove come lo era sulla riga A4.** L'ho
   corretto dove me ne sono accorto, ma **non ho fatto il giro di tutte le righe** per
   distinguere *gemelli di MECCANISMO* da *gemelli dello stesso BINARIO*. **E' la classe di
   errore piu' probabile che resta nel file.**
4. 🔴 **La mappa dello storico esterno e' una SINTESI, non la misura.** Ho verificato i numeri che
   cito (cancello ZERO, barre, date) contro `REFERTO_IMPORT_6_SIMBOLI.md`,
   `STORICO_INDICI_20260826_2334/ABTG_ImportEsterno_referto.csv` e `SONDA_FADE_ORO_2006_2020.txt`.
   **Non ho verificato che la mappa sia COMPLETA**: `225JPY_EXT` e' citato da quattro documenti
   di casa ma **non compare** nel referto d'import che ho aperto. La mappa completa e' dell'altro
   agente (`report/LO_STORICO_ESTERNO_MAPPA_2026-09-23.md`) e **il registro la cita invece di
   duplicarla**.
5. 🔴 **Non ho aperto `prove/R138a_gemello_F40EUR_770101.txt` per correggerlo**, pur avendo
   scoperto che contiene **la stessa frase sbagliata** del registro (*«non ho trovato la
   tabella»*). 🛑 **Il mandato dice: solo il registro.** Nel registro ho scritto **che quel file
   va corretto**, cosi' non si perde.
6. 🔴 **Non ho verificato la riga `O1` (`ORB` NASUSD, «real tick, best PF 1.15, DD 16%, 625 tr»)**:
   era fuori mandato e non l'ho aperta. **Resta com'era, e non e' certificata da me.**
7. 🔴 **Nessuno dei verdetti che ho riscritto promuove una sedia.** Il certificato riaperto su
   `DAX_M3`, `Londra_ORB`, `ORB_Fibo`, `Live5m`, `Live5m_v2` e i tre `MaxMinNotte` **apre
   caselle, non produce candidati per il 1° ottobre**. 🎯 **E va detto cosi': oggi ho prodotto
   PONTEGGIO, non una sedia.** Il ponteggio serve — senza di lui le sedie nascono sbagliate — ma
   non si racconta per progresso.
8. 🔴 **Costi e priorita' non li decido io.** Dove ho scritto cosa manca, **non ho proposto
   round**: la challenge e' viva dal 21/09, i round girano **solo sul PC di backtest** (firma del
   21/09) e **il runner notturno delle 03:30 sul VPS va ancora sospeso**. **Non ho armato niente.**

---

# 5️⃣ 🚦 IL CANCELLO

`python3 backtest_pipeline/controlla_riga.py --oggetto md backtest_pipeline/REGISTRO_TEST.md`

| esito | dettaglio |
|---|---|
| ✅ **PASSATI (2)** | blocco di sola lettura riconosciuto; 3 blocchi ``` trovati, 1 controllato come riga di lancio |
| 🟠 **RILIEVO (1), non bloccante** | *«la PROSA nomina terminali o conti vietati in 8 righe»* — **riletto a occhio, come chiede il cancello**: sono **dichiarazioni di bersaglio e di divieto** dentro un documento che spiega cosa non si tocca. **Una e' mia** (r.4091, `BCM Markets MT5 Terminal` nel contesto dei tredici round): e' **esattamente la regola dei terminali multipli applicata** — dico su quale macchina e su quale conto quei round sono girati, col numero in chiaro |
| 🔴 **BLOCCANTE (1)** | `[ASCII]` sul blocco ``` di r.3232. 🟢 **PRE-ESISTENTE, e l'ho dimostrato invece di affermarlo**: girato lo stesso cancello sulla copia di **HEAD**, lo stesso difetto esce allo **stesso blocco** (r.3021 a HEAD → r.3232 oggi, **spostamento +211 righe = esattamente quelle che ho inserito in testa**). 📌 **E non e' una riga di lancio**: e' la **trascrizione dell'output di console** di `controlla_prova.py` dentro un `.md`. La regola ASCII del 17/08 vale per i **`.ps1`**, che PowerShell 5.1 legge come ANSI. **Nessuna delle mie modifiche introduce un difetto bloccante nuovo.** |

🔬 **Controllo in piu', fatto da me**: verifica a macchina della coerenza di **tutte** le tabelle
del file (pipe non escapate) → **0 righe incoerenti**, dopo la riparazione del §1.10.

⏳ **Secondo strato del cancello (agente `controllo-preventivo`): NON lanciato da me.** Questo e'
un `.md` di registro, non una riga verso Claudio ne' verso il VPS — **niente di quanto scritto
qui parte verso una macchina.** Se qualcosa di questo referto dovesse diventare una riga, **passa
dal secondo strato prima**.

---

# 6️⃣ 🎁 COSA CI PORTIAMO VIA

😄 **Tre cose buone, e una scomoda — perche' un elenco di difetti senza le vittorie accanto
descrive male la realta'.**

🟢 **La prima:** il metodo ha funzionato **contro di noi e a nostro favore nello stesso giorno**.
Il CSV ha corretto il registro cinque volte, **e ha corretto un dossier di stanotte due volte**.
Quando la gerarchia regge anche quando fa comodo il contrario, vuol dire che e' una regola.

🟢 **La seconda:** i tredici round del 20-21/09 **erano lavoro buono**, non perso. Una promozione
in campo in sei ore, una manopola vincente ritirata **per disciplina**, e la prima misura di
casa che dimostra che **una cella non si trasferisce fra simboli gemelli**.

🟢 **La terza:** `ABTG_DAX_Apertura_EU` a `R201A` fa **7 celle su 7 sopra 1,25 in OOS**. E'
il numero piu' bello dei tredici, e nessuno l'aveva scritto da nessuna parte.

🔴 **E quella scomoda, che viene prima di tutte:** per **due mesi** il registro ha dichiarato
morto un motore che oggi paga lo stipendio a una sedia della challenge. **Non e' costato niente
per fortuna, non per metodo** — perche' chi ha schierato `770260` il 19/09 non e' andato a
leggere il registro. 👉 **La mappa sbagliata non ha fatto danni perche' nessuno l'ha usata: e
questo e' il problema, non la scusa.**

---

_Fonti primarie (CSV, non referti): `risultati_prove/{R172D,R196A,R197A,R197B,R198,R199A,R199B,R200A,R200C,R200E,R201A,R202A,R202B}/**` ·
`risultati_prove/{ABTG_PostNews,ABTG_ORB_Fibo,ABTG_DAX_Live5m,ABTG_DAX_Live5m_v2,ABTG_Nasdaq_Live5m}/*.csv` ·
`risultati_archivio/studio_apertura/Studio_*_RIEPILOGO.csv` ·
`risultati_archivio/MaxMinNotte/*.csv` · `risultati_archivio/Apertura_nuovi_indici/*.csv` ·
`risultati_archivio/Dow_Apertura/*.csv` · `risultati_archivio/Openconfirm/*.csv` ·
`risultati_archivio/Walkforward_Aperture/NASDAQ_B_motore_{IS,OOS}.csv` ·
`risultati_archivio/Live5m/valid_DAX_Live5m_v2_D30EUR_realtick.csv` ·
`risultati_archivio/REFERTO_IMPORT_6_SIMBOLI.md` ·
`risultati_archivio/STORICO_INDICI_20260826_2334/ABTG_ImportEsterno_referto.csv` ·
`mql5/Presets/FTMO/*.set` · `git log --all --pretty=format: --name-only`._
