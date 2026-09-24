# ⚖️ HEDGING FRA CONTI — quanto è esposta la challenge FTMO `541452707` al divieto del 24/09

**24/09/2026** · branch `lavoro` · **SOLA MISURA**: nessun EA, preset, terminale o conto toccato; niente mandato al VPS.
Fonte del vincolo: `docs/RISPOSTA_SUPPORTO_FTMO_2026-09-24.md` (Xavier Rocha, supporto FTMO):
> *"hedging across multiple trading accounts is strictly prohibited. This includes any form of trading that
> involves opening opposite positions irrespective of the entity/company (prop firms/brokers)"* → può costare
> *"account terminations"*. Stesso conto: permesso. Copy nello stesso verso verso altre ditte: *"we do not control that"*.

---

## 0️⃣ LA RISPOSTA IN SEI RIGHE

1. 🟢 **Nessuna sovrapposizione opposta è già avvenuta.** La challenge ha fatto **3 posizioni (2 decisioni)**: per tutte e tre
   ho controllato ogni posizione BCM sullo stesso sottostante nello stesso intervallo UTC. **Zero opposte**
   (con due residui non verificabili dichiarati in §4). L'unica
   sovrapposizione trovata è una **COPIA nello stesso verso** (22/09, `771531` EMA200 short sul piccolo e su FTMO,
   **aperte allo stesso secondo UTC**).
2. 🔴 **Ma la struttura rende l'esposizione INEVITABILE su tutti e tre gli indici.** FTMO tiene **tutti e due i lati** su
   DAX (`770101` long + `770411` short), Dow (`771531` e `770511` bidirezionali) e Nasdaq (`770260` bidirezionale).
   Quindi **ogni** sedia BCM su D30EUR / U30USD / NASUSD, **copie comprese**, può trovarsi opposta a qualche sedia FTMO.
   Non esiste una sedia BCM "solo copia" su quei tre strumenti.
3. 🔴 **Il REALE `10105439` è esposto con tutte e due le sue sedie**: `770101` DAX long contro `770411` FTMO short, e
   `770611` ORB Dow long contro `771531`/`770511` FTMO short.
4. 📈 **Frequenza attesa, coppie del REALE: ~1,4 al mese** (Dow ~1,25 + DAX ~0,17), cioè **~74% di probabilità di
   almeno un episodio in 20 giorni di borsa** (la durata mediana al target del Monte Carlo). Contando **tutti** i conti BCM
   (piccolo compreso): nel campo di agosto-settembre **5 giornate su 28** con un episodio → **~97%** in 20 giorni.
5. 🟢 **EURUSD e XAUUSD: esposizione ZERO oggi.** Su FTMO non gira nessuna sedia su quei simboli (i preset ORO/PostNews in
   `mql5/Presets/FTMO/` **non** sono attaccati). Diventa esposizione il giorno in cui ci salgono.
6. 🟠 **Confidenza: BASSA-MEDIA.** I per-trade di backtest hanno **solo le chiusure**: gli ingressi sono stimati. Il numero
   del forward è su **28 giorni di borsa** e un regime solo. **[NON CHIARITO]** se FTMO conti i conti **demo**.

---

## 1️⃣ L'OROLOGIO — tutto in UTC prima di confrontare

| orologio | offset oggi (estate) | fonte |
|---|---|---|
| **FTMO** server | **UTC+3** (= ora italiana + 1) | `report/SECONDO_STOP_FTMO_2026-09-24.md` r.4 |
| **BCM** server | **UTC+1** (= ora italiana − 1; fisso tutto l'anno) | `CLAUDE.md` §FUSO ORARIO, correzione 24/09 · `report/OROLOGIO_BCM_2026-09-24.md` |
| **giornali MT5** (`CODA_09`) | **UTC+2** (ora locale del VPS = italiana) | `CLAUDE.md` §"Ora dei LOG ≠ ora del GRAFICO" |
| `trades_auto.csv` / `trades_100k.csv` | **UTC+1** (ora server BCM) | verificato sotto |

🧪 **Contro-esempio sull'orologio, fatto sul dato**: il 22/09 la gamba S1 di `771531` si apre alle **12:52:01 FTMO** e alle
**10:52:01 BCM** → entrambe **09:52:01 UTC**. Se l'ipotesi alternativa fosse vera (FTMO = UTC+2, o BCM = UTC+2) le due gambe
cadrebbero **a un'ora esatta di distanza**, non allo stesso secondo. Stessa cosa sull'uscita (14:45:51 FTMO = 12:45:51 BCM =
**11:45:51 UTC**) e sul giornale del REALE (BUY LIMIT DAX alle 10:56:34 locali = 08:56:34 UTC, riempito 09:56:41 BCM =
08:56:41 UTC, 7 secondi dopo). **La conversione regge su tre ancore.**

---

## 2️⃣ LE SEDIE — chi gira dove, con che lato

Fonte primaria: **i `.chr` letti stanotte** (`backtest_pipeline/coda/referti/CODA_01_sedie_attaccate_20260924_033003.log`
e `CODA_08_preset_dai_chr_20260924_033003.log`, parametri `InpAllowLong/InpAllowShort` e orari). I preset in repo
(`mql5/Presets/FTMO/*.set`) coincidono sui lati.

### 2.1 Le sei sedie FTMO `541452707` (`C:\FTMO`)

| magic | sedia | simbolo | lato | finestra (UTC, estate) | `.chr` r. |
|---|---|---|---|---|---|
| `770101` | DAX Apertura | GER40.cash | **solo LONG** | range 07:00-07:35 → chiusura 16:30 | CODA_08 r.3054-3138 |
| `770411` | MaxMinNotte DAX Short | GER40.cash | **solo SHORT** | box 22:00-03:59 · ordine 06:59 · cutoff 07:30 · chiusura 16:30 | r.3471-3525 |
| `770202` | Dow Apertura | US30.cash | **solo LONG** | range 13:30-14:05 → chiusura 16:30 | r.3143-3226 |
| `771531` | EMA200 H1 | US30.cash | **LONG e SHORT** | tutto il giorno, anche overnight (`InpUseCutoff=false`, `InpFridayClose=false`) | r.3336-3381 |
| `770511` | SuperWave DOW H1 | US30.cash | **LONG e SHORT** | 0-24, overnight | r.3386-3432 |
| `770260` | Nasdaq Apertura RETEST | US100.cash | **LONG e SHORT** | range 13:30-14:05 → chiusura 16:30 | r.3231-3331 |

`CLAU12_Guardian` (NZDJPY) e `ABTG_TradeExporter` (NZDUSD) non tradano.

### 2.2 Le sedie BCM sugli stessi sottostanti (profilo ATTIVO, 24/09 03:30)

| conto | magic | sedia | simbolo | lato | finestra (UTC) |
|---|---|---|---|---|---|
| 🔴 **REALE `10105439`** (`C:\BCM_Reale`) | `770101` | DAX Apertura | D30EUR | **solo LONG** | come FTMO `770101` (08:00 BCM = 07:00 UTC) |
| 🔴 **REALE** | `770611` | ORB Ottimizzato | U30USD | **solo LONG** | range 13:30-13:45 → fine 20:00 |
| 100k `50504263` (`...-V3`) | `770101` | DAX Apertura | D30EUR | solo LONG | 07:00 → 16:30 |
| 100k | `770411` | MaxMin DAX Short | D30EUR | solo SHORT | ordine 06:59 · cutoff 07:30 · chiusura 16:30 |
| 100k | `770202` | Dow Apertura | U30USD | solo LONG | 13:30 → 16:30 |
| 100k | `770611` | ORB | U30USD | solo LONG | 13:30 → 20:00 |
| piccolo `50503392` (`BCM Markets MT5 Terminal`) | `770101` · `770411` · `770202` · `770611` | come sopra | | come sopra | come sopra |
| piccolo | `770511` | SuperWave DOW H1 | U30USD | LONG e SHORT | 0-24 |
| piccolo | `770531` | SuperWave H2 | U30USD | LONG e SHORT | 0-24 |
| piccolo | `771321` | PTE H1 | U30USD | LONG e SHORT | 0-24 |
| piccolo | `772234` | GapFill H1 | U30USD | LONG e SHORT (dal gap) | apertura sessione |
| piccolo | `772341` | PunteLarry H1 | U30USD | LONG e SHORT | pendenti giornalieri |
| piccolo | `970912` | SupRev DAX H4 | D30EUR | LONG e SHORT | 0-24 |
| piccolo | `970913` | SupRev NAS H1 | NASUSD | LONG e SHORT | 0-24 |
| piccolo | `770250` | Nasdaq GatedShort | NASUSD | **solo SHORT** | 13:30 → 19:45 |

🟠 **Nota di campo**: `771531` EMA200 **c'era** sul piccolo il 23/09 03:30 (`CODA_01_..._20260923`, `ORO\chart33.chr`) e
**non c'è più** il 24/09 03:30. Il profilo è stato risalvato il 23/09 19:35. Lo tratto come **staccata**.

**Fuori perimetro, e perché**: sul piccolo girano anche EURUSD (`772162`, `772232`, `771202`) e XAUUSD (`770402`, `772343`,
`971501`, `970901`); su Tickmill `250604` XAUUSD e `BREAKOUT_EA_JPY_v3` USDJPY; su Pepperstone niente. **Nessuna** di queste ha
una controparte FTMO oggi. Il 23/09 il 100k ha anche un trade **manuale** XAUUSD (magic 0, `trades_100k.csv`): stessa
conclusione, ma ricorda che **anche i trade a mano contano** come posizioni.

---

## 3️⃣ 🎯 LA TABELLA DELLE COPPIE A RISCHIO

Legenda: **OPPOSTA** = verso contrario possibile · **COPIA** = stessa sedia, stesso verso (FTMO: *"we do not control that"*).

| # | sedia BCM | conto BCM | sedia FTMO | strumento | lati | quando possono coesistere (UTC, estate) | stima |
|---|---|---|---|---|---|---|---|
| **D1** | `770101` L | 🔴 **REALE** · 100k · piccolo | `770411` S | DAX | 🔴 **OPPOSTA** | se la `770411` (dentro 06:59-07:30) è **ancora aperta** quando la `770101` entra (≥ 07:35; minimo osservato 07:40:19) | **~0,17/mese** |
| **D2** | `770411` S | 100k · piccolo | `770101` L | DAX | 🔴 **OPPOSTA** | stesso incastro, ruoli scambiati | stessa di D1 (è lo stesso evento) |
| D3 | `970912` L/S | piccolo | `770101` L · `770411` S | DAX | 🔴 OPPOSTA | tutto il giorno | [NON MISURATO] — mai tradato sul piccolo |
| **W1** | `770611` L (ORB) | 🔴 **REALE** · 100k · piccolo | `771531` S · `770511` S | Dow | 🔴 **OPPOSTA** | ORB 13:45-20:00 contro EMA200/SuperWave aperte in qualsiasi ora | **~1,25/mese** (solo EMA200) |
| W2 | `770202` L | 100k · piccolo | `771531` S · `770511` S | Dow | 🔴 OPPOSTA | 14:05-16:30 | ~0,26/mese (solo EMA200) |
| W3 | `770511`/`770531`/`771321`/`772234`/`772341` (L o S) | piccolo | `770202` L · `771531` · `770511` | Dow | 🔴 OPPOSTA | tutto il giorno, overnight | forward: **9 episodi su 10** stanno qui |
| N1 | `770250` S | piccolo | `770260` L | Nasdaq | 🔴 OPPOSTA | 13:30-16:30 | [NON MISURATO] — nessun per-trade con ingressi |
| N2 | `970913` L/S | piccolo | `770260` L/S | Nasdaq | 🔴 OPPOSTA | 13:30-16:30 | [NON MISURATO] |
| C1 | `770101` L | REALE · 100k · piccolo | `770101` L | DAX | 🟢 COPIA | | |
| C2 | `770411` S | 100k · piccolo | `770411` S | DAX | 🟢 COPIA | | |
| C3 | `770202` L | 100k · piccolo | `770202` L | Dow | 🟢 COPIA | | |
| C4 | `770511` | piccolo | `770511` | Dow | 🟢 COPIA *(di regola; feed diversi possono divergere)* | | |
| C5 | `771531` | piccolo (fino al 23/09) | `771531` | Dow | 🟢 COPIA — **misurata il 22/09** | | |

🔴 **La lettura che conta**: C1 e D1 sono **la stessa sedia REALE**. La `770101` sul REALE è **copia** della `770101` FTMO e
**opposta** della `770411` FTMO. Su DAX, Dow e Nasdaq FTMO copre entrambi i lati, quindi **nessuna sedia BCM su questi tre
strumenti è "solo copia"**. Tenere su BCM solo le copie **non** basta a eliminare il rischio.

---

## 4️⃣ 🔎 LE SOVRAPPOSIZIONI GIÀ AVVENUTE (dal 21/09) — misurate

**Le posizioni FTMO della challenge sono tre** (`report/SECONDO_STOP_FTMO_2026-09-24.md` §6, riconciliato al centesimo col
saldo). Il 23/09 FTMO non ha aperto niente: `770260` ha saltato per volumi (`CODA_09_..._20260924`), e il Guardian segna
`rischioAperto=0.00%` alle 23:55 del 23/09 e alle 03:30 del 24/09. Per ognuna ho cercato ogni posizione BCM sullo stesso
sottostante che si sovrapponesse nel tempo.

| FTMO | intervallo FTMO → **UTC** | BCM sullo stesso sottostante in quell'intervallo | esito |
|---|---|---|---|
| 22/09 `771531` S1 sell US30.cash | 12:52:01-14:45:51 FTMO → **09:52:01-11:45:51 UTC** | piccolo `771531` S1 **sell** U30USD 10:52:01-12:45:51 BCM → **09:52:01-11:45:51 UTC** | 🟢 **COPIA** (stesso verso, stesso secondo) |
| 22/09 `771531` S2 sell | 12:52:31-14:45:51 FTMO → **09:52:31-11:45:51 UTC** | piccolo `771531` S2 **sell** 10:52:32-12:45:51 BCM → **09:52:32-11:45:51 UTC** | 🟢 **COPIA** |
| ↳ stesso intervallo | | REALE e 100k: nessuna posizione Dow. Nel giornale del 22/09 ci sono solo il BUY LIMIT DAX (08:56 UTC) e il BUY STOP ORB (**13:45 UTC**, cioè **dopo** la chiusura FTMO delle 11:45); tutte le sedie sono intraday e `rischioAperto=0.00%` a fine giornata. Piccolo: nessun'altra posizione U30USD in `trades_auto.csv` e nessun altro ordine Dow nel giornale del 22/09 | 🟢 **nessuna opposta** |
| 24/09 `770411` sell GER40.cash | 10:02:04-10:14:49 FTMO → **07:02:04-07:14:49 UTC** | nessun long DAX BCM può esistere: la `770101` (REALE/100k/piccolo) entra **non prima di 07:35 UTC**, a range chiuso (minimo osservato **07:40:19 UTC**, 21/08). La `770411` BCM, se ha sparato, è una **copia** short. La `970912` non ha ordini nel giornale del 22-23/09 e **zero** trade in `trades_auto.csv` | 🟢 **nessuna opposta** *(strutturale; i dati BCM del 24/09 non sono ancora in repo)* |

### Due residui dichiarati [NON VERIFICATO]
- **Il giornale del 21/09 manca** (il runner non ha girato la notte del 22/09). Una posizione Dow sul piccolo aperta il 21/09 e
  **ancora aperta** al 23/09 21:00 non comparirebbe in `trades_auto.csv`, che registra solo le chiuse. L'ultima posizione Dow
  chiusa prima del 22/09 è del **09/09** (`772341`), quindi il residuo è piccolo, ma non è zero.
- **Il 23/09 il piccolo ha armato `772341` PunteLarry SELL STOP U30USD @ 51714,50** (scadenza 23/09 23:59). Se è stato
  riempito ed è ancora aperto, **oggi il piccolo è short Dow**, e ogni long FTMO su US30 (`770202`, `771531`, `770511`) sarebbe
  **opposto**. Il riempimento **non è misurato**: `trades_auto.csv` si ferma al 23/09 14:00 BCM.

---

## 5️⃣ 📈 LA FREQUENZA ATTESA

### 5.1 Dal campo: le sedie BCM **come proxy** delle sedie FTMO (14/08 → 22/09, 28 giorni di borsa)
Il piccolo ha fatto girare **le stesse sedie** che oggi sono su FTMO (`770101`, `770411`, `770202`, `770511`, `771531`), con
ingresso **e** uscita registrati. Il 22/09 le tre copie `770101`/`770611` di REALE, 100k e piccolo hanno piazzato **lo stesso
ordine allo stesso prezzo** (giornali `CODA_09_..._20260923`), e il 22/09 `771531` FTMO e piccolo sono entrati allo stesso
secondo. Quindi la tempistica di una sedia sul piccolo è una **proxy ragionevole** della sua gemella FTMO.
⚠️ Non è un'identità: il 22/09 `770101` ha sparato su BCM e **non** su FTMO.

Metodo: ogni posizione di una sedia "FTMO" sul piccolo, confrontata con ogni posizione di una sedia BCM viva sullo stesso
strumento (piccolo + `trades_100k.csv`). Ho tenuto le coppie con **intervalli sovrapposti**, separando i due versi. Esclusi i
`770101` sell, che vengono dalla configurazione vecchia fino al 13/08. Poi ho deduplicato per giornata × coppia di sedie.

| | coppie grezze | episodi (giorno × coppia) |
|---|---:|---:|
| 🟢 **stesso verso** (copie e concordanze) | 74 | — |
| 🔴 **verso opposto** | 26 | **10**, in **5 giornate** |

Gli episodi opposti, in **UTC** (= BCM − 1):

| giorno | sedia "FTMO" | contro sedia BCM | sovrapposizione UTC | conti BCM esposti |
|---|---|---|---|---|
| 19/08 | `771531` S | `770531` L | 16:11:56-16:36:06 | piccolo |
| **24/08** | **`771531` S** | **`770611` L (ORB)** | **13:46:25-13:49:11** (2 min 46 s) | 🔴 **REALE** · 100k · piccolo |
| 24-25/08 | `771531` S | `770511` L · `770531` L · `772341` L | 02:00:00-06:54:40 (25/08) | piccolo |
| 31/08 | `770511` S · `771531` S | `772234` L · `772341` L | 05:00:00-13:30:30 | piccolo |
| 03-04/09 | `770511` L | `771321` S | 22:05 (03/09) → 07:33:36 (04/09) | piccolo |

- **Tutti i conti BCM**: 5 giornate su 28 → **~18% dei giorni di borsa**, **tutti sul Dow**.
- 🔴 **Coppie del REALE**: **1 episodio su 28 giorni** (24/08, EMA200 short contro ORB long, 2 min 46 s). L'ingresso ORB del
  24/08 è identico su piccolo e 100k (14:46:25 BCM). Che quel giorno l'ORB girasse già anche sul REALE è **[NON VERIFICATO]**:
  la sedia è documentata sul REALE dal 07/09, primo censimento del runner. L'episodio conta quindi come **controfattuale con
  la rosa di oggi**, non come fatto avvenuto.
- **DAX**: **0 episodi**. Le giornate con tutte e due le sedie sono state due (24/08 e 26/08): la `770411` ha chiuso **20 minuti
  prima** (24/08: chiusa 07:47:01 UTC, `770101` entrata 08:07:27 UTC) e **115 minuti prima** (26/08).

### 5.2 Dal backtest (OOS 2025.06 → 2026.06, ~12,5 mesi, stessi file del Monte Carlo)
🔴 **Limite**: i per-trade (`abtg_trades_*.csv`) hanno **solo le chiusure**, non gli ingressi. Ogni numero qui sotto è una
**stima** con due confini dichiarati.

**DAX, D1/D2** (`aperture_r47/..._772501.csv` × `trades_portafoglio/..._770413.csv`):
- giornate con `770411`: **14**; di queste **9** con anche `770101`;
- 1 **impossibile** (03/09/2025: la `770411` chiude 08:28:30 BCM, prima che la `770101` possa entrare); **0 certe**;
- **confini: 0-8 episodi in 12,6 mesi**. Stima, con l'ingresso `770101` ricavato dalla distribuzione dei tempi di tenuta
  osservati in campo (n=47, mediana 33 min): **~2,1 episodi / 12,6 mesi ≈ 0,17/mese**.

**Dow, W1** (ORB `770612` R16 × EMA200 `771521` short, stessi file del Monte Carlo):
- 119 posizioni ORB long, 136 posizioni EMA200 short; **0 sovrapposizioni certe** (una chiusura EMA dentro la vita di una
  posizione ORB);
- stima con ingressi simulati (ORB uniforme fra 14:45 BCM e la prima chiusura; EMA200 = prima chiusura − tenuta estratta dal
  campo, n=23, mediana 114 min): **~15,6 episodi / 12,5 mesi ≈ 1,25/mese**, su 30 giornate candidate;
- **W2** (Dow Apertura `772505` × EMA200 short): **~3,2 / 12,5 mesi ≈ 0,26/mese**;
- la `770511` SuperWave FTMO **non è nel conto**: il suo per-trade non c'è. Il numero del Dow è quindi **un pavimento**.

### 5.3 Tradotto sulla durata della challenge (mediana Monte Carlo: **20 giorni di borsa** al target)
| perimetro | frequenza | P(≥1 episodio in 20 giorni di borsa) |
|---|---|---:|
| 🔴 **solo coppie del REALE** (D1 + W1) | ~0,17 + ~1,25 ≈ **1,4/mese** | **~74%** |
| coppie di REALE + 100k (+ W2 e D2) | ~1,7/mese | ~80% |
| **tutti i conti BCM** (forward, 5/28 giorni) | ~3,8/mese | **~97%** |

*(Poisson, con 20 giorni di borsa ≈ 0,95 mesi. A far girare il numero sono le frequenze, non la matematica.)*

### 5.4 Confidenza: BASSA-MEDIA, e perché
- ingressi di backtest **stimati**, non letti; tenute prese da campioni piccoli (47 e 23);
- forward su **28 giorni di borsa**, un regime solo, e la proxy "piccolo = FTMO" non è un'identità;
- `770511`, `770260`, `770250`, `970912`, `970913` **non stimate**: tutte spingono il numero **in su**, non in giù;
- 🔴 **d'inverno cambia l'incastro**, e lo cambia in peggio. Dal **26/10** (DAX) BCM resta UTC+1 mentre FTMO passa a UTC+2: la
  `770101` BCM arma alle **07:00 UTC**, **un'ora prima** della `770411` FTMO (07:59 UTC). Il cuscinetto strutturale di D1
  (§4: *"la 770101 non può entrare prima delle 07:35"*) **sparisce**. Dal **02/11** vale lo stesso per ORB/Dow Apertura
  contro le sedie FTMO a ora fissa. [NON MISURATO]; si aggancia alla decisione già aperta entro il 25/10 (`CLAUDE.md`
  §"CORRETTO IL 24/09").

---

## 6️⃣ 🧪 IL CONTRO-ESEMPIO — la copia non va contata come hedging

1. **Il caso vero**: 22/09, `771531` short sul piccolo e su FTMO, **stesso secondo UTC**. Il classificatore la mette in
   **COPIA**, non in OPPOSTA. Se lo strumento contasse "qualsiasi sovrapposizione", l'unico episodio della challenge
   risulterebbe una violazione. Non lo è: **verso uguale = copy**, che FTMO ha scritto di non controllare.
2. **Il controllo negativo**: nel forward lo stesso codice trova **74 coppie nello stesso verso** e **26 opposte**. Le separa,
   e sul DAX dice **zero** con i minuti accanto (20 e 115 minuti di distanza). Lo strumento sa dire di no.
3. **L'ipotesi alternativa sull'orologio** (FTMO o BCM spostati di un'ora) avrebbe messo le due gambe del 22/09 a **un'ora
   esatta di distanza**. Sono allo stesso secondo: la conversione in UTC è quella giusta (§1).
4. ⚠️ **Il caso che il classificatore NON separa**: una copia che **diverge** (feed diversi, versioni diverse del binario:
   la `770411` FTMO ha `InpSLMode`, quella BCM no; l'ORB del REALE è v1.04 e quello del 100k v1.02,
   `report/CENSIMENTO_CONTRATTI_v2.md` r.216/261). Una copia **bidirezionale** (`770511` piccolo × `770511` FTMO) che su un
   feed va long e sull'altro short **sarebbe** un'opposta. Non l'ho osservato, ma non lo escludo.

---

## 7️⃣ 🧭 LE OPZIONI — tutte decisioni di Claudio, nessuna è fatta

| | opzione | cosa toglie | cosa costa |
|---|---|---|---|
| **A** | **Sospendere sui conti BCM, per la durata della challenge, tutte le sedie su D30EUR / U30USD / NASUSD** (REALE: 2 · 100k: 4 · piccolo: 12) | **tutto** il rischio misurato qui | il REALE resta **senza sedie**; si fermano i contatori forward (C3 MERITO/RISCHIO) delle famiglie Aperture/ORB/SuperWave/EMA200; a fine challenge serve una riaccensione pulita |
| **A′** | come A, ma **solo REALE + 100k** | le coppie a frequenza stimata più alta legate al denaro vero (W1, D1) e al dry-run | resta il piccolo, cioè **~3,8 episodi/mese** del forward (W3); vale solo se FTMO risponde che i demo non contano |
| **B** | **Chiedere a FTMO, per iscritto, prima di decidere**: (1) un conto **demo** presso un altro broker conta? (2) contano **strategie automatiche indipendenti** che si trovano in verso opposto per caso, o solo l'hedging deliberato? (3) conta la **sovrapposizione di pochi minuti** (es. 2 min 46 s) e la **taglia** (REALE: ~49 € di rischio contro ~1.531 € su FTMO)? (4) vale in **valutazione** o solo sul **finanziato**? (5) sottostanti uguali con simboli diversi (D30EUR / GER40.cash) contano? | l'incertezza sul perimetro | tempo di risposta; fino ad allora il rischio resta. Le domande (1) e (2) stanno già in fila con quelle di `report/DOMANDE_SUPPORTO_PROP.md` |
| **C** | **Semaforo fra terminali**: le sedie BCM leggono da `Common\Files` (lo stesso VPS; il TradeExporter FTMO ci scrive già `ABTG_Trades_FTMO.csv`) se FTMO ha una posizione opposta sullo stesso sottostante, e non entrano | le opposte **nate da BCM** | è una **modifica agli EA** (firma + cancello); **non copre** il caso in cui è FTMO a entrare dopo, a meno di toccare anche le sedie FTMO **a challenge in corso**; e aggiunge una dipendenza fra terminali |
| **D** | **Tenere tutto com'è, con una sonda notturna** di sola lettura che conta le sovrapposizioni opposte fra i conti (sui dati che il runner già raccoglie) | niente; rende il rischio **visibile** | il rischio resta ~74-97% di almeno un episodio in 20 giorni di borsa; la sonda è una riga nuova da far passare dai cancelli |
| **E** | **Togliere da FTMO la sedia che crea l'opposto** (es. `770411` sul DAX) | solo D1/D2 (~0,17/mese) | tocca la rosa della challenge e il suo Monte Carlo; **lascia intatto il Dow**, che è ~88% dell'attesa del REALE |

🔴 **Cosa NON dice questo referto**: non dice se FTMO **vede** i conti BCM, né quanto sia probabile che sanzioni un episodio di
pochi minuti. Il vincolo scritto è quello del supporto, e i numeri qui sopra misurano **quanto spesso lo incroceremmo**, non
**cosa succederebbe**. Contare sul "tanto non se ne accorgono" non è una misura.

---

## 8️⃣ FONTI (tutte in repo)
- vincolo: `docs/RISPOSTA_SUPPORTO_FTMO_2026-09-24.md`
- sedie FTMO: `report/GUARDIAN_SEI_SEDIE_2026-09-24.md` r.49-57 · `mql5/Presets/FTMO/*.set`
- posizioni FTMO: `report/PRIMO_STOP_FTMO_2026-09-22.md` §1 · `report/SECONDO_STOP_FTMO_2026-09-24.md` §1, §6
- sedie e parametri in campo: `backtest_pipeline/coda/referti/CODA_01_sedie_attaccate_20260924_033003.log` ·
  `CODA_08_preset_dai_chr_20260924_033003.log` · confronto col 23/09: `CODA_01_..._20260923_033004.log`
- giornali: `CODA_09_giornale_operativo_20260923_033004.log` (22/09) · `..._20260924_033003.log` (23-24/09) ·
  `..._20260918_033004.log`, `..._20260919_033003.log`
- posizioni BCM: `data/statements/trades_auto.csv` (piccolo `50503392`) · `trades_100k.csv` (100k `50504263`); del REALE
  non esiste un per-trade in repo, quindi il REALE si legge dai giornali
- backtest: `backtest_pipeline/risultati_prove/aperture_r47/abtg_trades_ABTG_DAX_Apertura_EU_D30EUR_772501.csv` ·
  `..._Dow_Apertura_US_U30USD_772505.csv` · `trades_portafoglio/abtg_trades_ABTG_MaxMinNotte_DAX_Short_Ottimizzato_D30EUR_770413.csv` ·
  `trades_portafoglio/abtg_trades_ABTG_ORB_Ottimizzato_U30USD_770612.csv` · `trades_candidati_r23/abtg_trades_ABTG_EMA200_U30USD_771521.csv`
- orologio: `report/OROLOGIO_BCM_2026-09-24.md` · `CLAUDE.md` §FUSO ORARIO BCM
