# 👨‍👩‍👧 UNA FAMIGLIA O DUE? — `770202` e `770101` messi sotto la stessa lente
**18/09/2026** · sola lettura · zero costo macchina · nessun EA, preset, file prova o terminale toccato

> ## 🟢 **SONO LO STESSO MOTORE. È MISURATO, non somigliato: i due sorgenti inlinano lo STESSO file di motore (`ABTG_ApertureCore.mqh`), 81 input su 81 hanno lo stesso nome, e i DUE PRESET VIVI coincidono su OGNI asse che decide il motore — `InpEntryMode=2` (RETEST), `InpRangeMinutes=35`, `InpSLMode=0`, `InpTP1_R=1.0`, `InpTP1_ClosePct=50`, `InpBreakevenAtTP1=1`, `InpTrailMode=1`/`InpTrailTF=5`, `InpAllowShort=0`, flat 17:30.**
> ## 🟡 **E LA SOMMA È SULLA SOGLIA, NON SOPRA: `1,0509 pos/g` leggendo il testo firmato alla lettera (`1,078` col divisore a giorni di borsa), `0,94` usando il numero di casa di `770101`, `0,7818` leggendo "giornate coperte". Il pavimento è 1,00. La risposta cambia di segno su una convenzione di calcolo MAI FIRMATA.**
> ## 🔴 **E il terzo simbolo che avrebbe chiuso la partita è GIÀ GIRATO ed è BOCCIATO dal suo criterio pre-registrato: `F40EUR` fa `DD OOS 11,82% > 10,0%` e `PF OOS 0,770` (PERDE). I numeri erano in repo dal 17/09 e nessuno li aveva letti contro il criterio scritto il 12/09.**

---

## 0. 🎯 LA DOMANDA, e che cosa ho consegnato

Il mandato: *"ci sono due o più sedie che sono LO STESSO MOTORE su SIMBOLI
DIVERSI? Se sì, sono una famiglia, e le loro frequenze si sommano."*

Risposta in tre righe:
1. **`770202` e `770101` SONO lo stesso motore** — al 4° asse su 4 nella
   configurazione schierata, al 3° su 4 nel codice (riserva dichiarata sotto).
2. **La loro somma vale `1,0509 pos/g` contro un pavimento di `1,00`** — cioè
   **passa del 5,1%**, ma **solo** con il divisore ancorato all'aritmetica della
   firma, e **solo** se si dichiara `D30EUR` schierabile nonostante `33,0×` sul
   cancello di costo della geometria viva.
3. **Il terzo simbolo (`F40EUR`) è morto sul suo cancello di RISCHIO**, e
   questo è il verdetto nuovo di oggi.

---

## 1. 🔬 IL CRITERIO — dichiarato PRIMA di aprire i sorgenti

Scritto in
`/tmp/.../scratchpad/CRITERIO_PRIMA.md` prima di qualunque lettura dei due
`.mq5`, e riportato qui integralmente perché **un criterio scritto dopo i
numeri non è un criterio**.

### Definizione operativa di "stesso motore" — 4 assi
| asse | che cosa conta come CONCORDE |
|---|---|
| **A1 · TRIGGER** | la stessa condizione booleana, a meno dei VALORI. "Range di N minuti dall'apertura + rottura del bordo" = stesso. Uno rompe il range e l'altro fa **fade / retest / incrocio di medie / pattern di candela** = **DIVERSI** |
| **A2 · GEOMETRIA SL/TP** | stessa FORMULA. ATR contro ampiezza-del-range = asse **DIVERSO** |
| **A3 · USCITA** | stesso insieme di meccanismi (BE, parziale, trailing, time-exit), anche con soglie diverse. Un meccanismo che nell'altro **NON ESISTE NEL CODICE** (non "è a zero": non esiste) = asse **DIVERSO** |
| **A4 · SUPERFICIE INPUT** | ≥ 70% degli input con OMONIMO e stesso significato. Sotto il 50% = motori diversi |

**Verdetto**: 4/4 → stesso motore · 3/4 **con A1 concorde** → stessa famiglia
**con riserva** · **A1 discorde → motori diversi qualunque sia il resto** · ≤2 → diversi.

### 🧪 Falsificabilità — il criterio deve tagliare in TUTTE E DUE le direzioni
**Differenze che mi avrebbero fatto scrivere MOTORI DIVERSI**: `F1` primitiva
d'ingresso diversa · `F2` stop geometrico contro stop statistico · `F3` un
blocco d'uscita assente nel codice dell'altro · `F4` sovrapposizione nomi < 50%.
**Differenze che NON contano (sono PARAMETRO, non MOTORE)**: `P1` l'ora di
sessione · `P2` i valori di buffer/stop/TP · `P3` il TF se la primitiva è la
stessa · `P4` magic, nome file, commenti · `P5` il lato abilitato se il codice
ha tutti e due i rami.

### 🔴 E IL CRITERIO SI È RIBALTATO DURANTE LA MISURA — è il contro-esempio, ed è vero
Sui **DEFAULT COMPILATI** il Dow ha `InpEntryMode = ABTG_BREAKOUT`
(`ABTG_Dow_Apertura_US.mq5`, ordine STOP oltre il livello) e il DAX
`InpEntryMode = ABTG_RETEST` (`ABTG_DAX_Apertura_EU.mq5`, LIMIT **sul** livello
rotto). **Sono due primitive diverse**, `F1` scatta, e la risposta sarebbe stata
**MOTORI DIVERSI** — e il sorgente del DAX lo dice con le sue parole:

> *"2. **DUE MOTORI INDIPENDENTI, STESSA MAPPA.** Breakout (ordine STOP oltre il
> livello) e retest (LIMIT sul livello rotto)..."* — `ABTG_DAX_Apertura_EU.mq5` **r.47-50**

**Il verdetto si è capovolto solo leggendo i PRESET VIVI**, dove tutti e due
portano `InpEntryMode=2` (RETEST). 👉 **Quindi il criterio discrimina davvero**:
esiste una differenza che, se ci fosse stata, avrebbe dato l'altra risposta — e
per un attimo c'era. **Non è un criterio che diceva sì comunque.**

---

## 2. 📐 LA MISURA — sorgenti, input, preset

### 2.1 🏗️ Il MOTORE È LETTERALMENTE LO STESSO FILE, e lo dichiarano loro
Tutti e due i sorgenti **inlinano lo stesso motore condiviso**:

| | riga | testo |
|---|---|---|
| `ABTG_Dow_Apertura_US.mq5` | **r.76-78** | `ABTG_ApertureCore.mqh` · *"MOTORE CONDIVISO per gli EA «Apertura Mercati» (DAX / Nasdaq)"* |
| `ABTG_DAX_Apertura_EU.mq5` | **r.107-109** | idem, stessa intestazione |
| `ABTG_Nasdaq_Apertura_US.mq5` | **r.55-57** | idem |

E il Dow lo scrive a parole sue, **r.53**:
> *"NB: **stesso motore** dell'EA Nasdaq apertura, con altri default. Magic e
> commento sono DIVERSI, così i due non si confondono."*

### 2.2 🔢 A4 · SUPERFICIE DEGLI INPUT — `[MISURATO]`, n = 81+82
Estratti i nomi degli `input` dai due sorgenti e confrontati:

| | valore |
|---|---|
| input con nome unico, Dow | **81** |
| input con nome unico, DAX | **82** |
| **nomi in COMUNE** | **81** |
| solo nel Dow | **0** |
| solo nel DAX | **1** — `InpAllowReverse` |

👉 **A4 = 81/81 = 100% (Dow→DAX) e 81/82 = 98,8% (DAX→Dow)**, contro una soglia
del 70%. **CONCORDE, e non di misura: di identità.**

### 2.3 🧬 IL DIFF DEL CODICE (commenti rimossi) — 121 righe su ~1.440
Normalizzati i due corpi dal marcatore del motore in avanti, rimossi commenti e
spazi. **Dow 1.437 righe di codice · DAX 1.521.** Righe divergenti nel corpo
(fino a `OnTesterInit`): **121**, e si smontano tutte:

| classe di differenza | righe | conta come? |
|---|---|---|
| la **stringa del nome EA** passata a `ABTG_GuardiaIngresso` (chiamata identica, 7 punti) | **14** | `P4` — no |
| righe `input` con **default diverso, nome e tipo identici** | **23** (11 coppie + 1 input nuovo) | `P2` — no |
| il blocco **`InpAllowReverse`** (R51, 14/08): `CicliOggi()`, `HoRobaViva()`, `MonitorReverse()`, 4 globali, log | **~84** | 🟡 **A3, vedi riserva** |
| riformattazione pura in `OnTesterInit`/`OnTesterPass` (a valle) | ~30 | `P4` — no |

**Inventario delle funzioni** (unica divergenza funzionale Dow↔DAX):
- solo nel **Dow**: `HaGiaOperatoOggi(`
- solo nel **DAX**: `CicliOggi(`, `HoRobaViva(`, `MonitorReverse(`

👉 Il DAX ha **sostituito** la guardia "ho già operato oggi" con un **contatore
di cicli** che permette un **secondo ciclo sul lato opposto**, tetto rigido 2 al
giorno, **solo con `InpEntryMode == ABTG_RETEST`** e **`DEFAULT false`**.
**Nient'altro.**

### 2.4 🎛️ I DUE PRESET VIVI, chiave per chiave — e qui è dove si decide
`mql5/Presets/ABTG_Dow_Apertura_US_U30USD_M5_770202_100K.set` ·
`mql5/Presets/ABTG_DAX_Apertura_EU_D30EUR_M5_770101_100K.set`

| chiave | `770202` U30USD | `770101` D30EUR | esito |
|---|---|---|---|
| `InpEntryMode` | **2 = RETEST** (r.178) | **2 = RETEST** (r.169) | 🟢 **A1** |
| `InpRangeMode` | **0 = RANGE_OPENING** (r.179) | **0** (r.170) | 🟢 **A1** |
| `InpRangeMinutes` | **35** (r.172) | **35** (r.163) | 🟢 **A1** |
| `InpSLMode` | **0 = SL_RANGE** (r.213) | **0** (r.205) | 🟢 **A2** |
| `InpTP1_R` | **1.0** (r.216) | **1.0** (r.208) | 🟢 **A2/A3** |
| `InpTP1_ClosePct` | **50.0** (r.217) | **50.0** (r.209) | 🟢 **A3** |
| `InpBreakevenAtTP1` | **true** (r.218) | **true** (r.210) | 🟢 **A3** |
| `InpUseTrailing` / `InpTrailMode` / `InpTrailTF` / `InpTrailStartR` | **1 / 1 / 5(M5) / 0.0** (r.221-223) | **true / 1 / 5 / 0.0** (r.212-215) | 🟢 **A3** |
| `InpAllowLong` / `InpAllowShort` | **true / false** (r.185-186) | **true / false** (r.176-177) | 🟢 `P5` |
| `InpCloseHour` / `InpCloseMin` | **17 / 30** (r.173-174) | **17 / 30** (r.164-165) | 🟢 **A3** |
| `InpPendingExpiryMin` | **120** (r.184) | **120** (r.175) | 🟢 |
| `InpSessionHour` / `InpSessionMin` | **14 / 30** (r.170-171) | **8 / 0** (r.161-162) | ⚪ `P1` = **è il simbolo** |
| `InpBufferPoints` | 1000.0 (r.182) | 500.0 (r.173) | ⚪ `P2` |
| `InpRetestOffsetPts` | 400.0 (r.189) | 200.0 (r.180) | ⚪ `P2` |
| `InpUseEmaFilter` / `InpEmaFast` / `InpEmaSlow` / `InpFilterTF` | **true** / 1 / 50 / H4 (r.196-199) | **false** / 14 / 200 / H1 (r.188-191) | 🟡 **filtro ON/OFF** |
| `InpMinStopPts` / `InpSkipIfTight` | 500.0 / false (r.238-239) | 0.0 / true (r.230-231) | ⚪ `P2` |
| `InpAllowReverse` | *(input inesistente)* | **false** (r.182) | 🟡 **riserva A3** |

### 2.5 ⚖️ VERDETTO SUI 4 ASSI
| asse | sulla **configurazione SCHIERATA** | sul **CODICE** |
|---|---|---|
| **A1 · trigger** | 🟢 CONCORDE — retest del bordo di un range di 35' dall'apertura, identico | 🟢 CONCORDE (entrambi i rami esistono in entrambi) |
| **A2 · geometria** | 🟢 CONCORDE — `SL_RANGE` + `TP1 = 1,0 R` | 🟢 CONCORDE |
| **A3 · uscita** | 🟢 CONCORDE — parziale 50% a 1R, BE a TP1, trailing base-candela M5 da 0R, flat 17:30 | 🔴 **DISCORDE**: `InpAllowReverse` **non esiste** nel sorgente del Dow (`F3` scatta) |
| **A4 · input** | 🟢 CONCORDE 100% / 98,8% | 🟢 CONCORDE |

> ## 🟢 **VERDETTO: STESSO MOTORE — 4 assi su 4 nella configurazione schierata, 3 su 4 con A1 concorde nel codice ⇒ per il criterio scritto prima: «STESSA FAMIGLIA CON RISERVA».**
> **La riserva, dichiarata**: il binario del DAX **può** fare una cosa che il
> binario del Dow **non può** (un secondo ciclo giornaliero sul lato opposto).
> 🟢 **È spenta in tre modi**: `DEFAULT false` nel sorgente (r.279), **`false`
> nel preset vivo** (r.182), e inerte comunque con `InpAllowShort=false`, perché
> il secondo ciclo può partire solo sul lato mancante — cosa che l'EA stesso
> dichiara nel log (*"con un solo lato consentito... così com'è, quasi mai"*).
> 🔴 **Ma NON è un no-op teorico: è una manopola della FREQUENZA**, e se un
> giorno si accende **il conto delle operazioni cambia su una gamba sola**.
> Perciò la riserva resta scritta, non assorbita.

### 2.6 🧩 Il TERZO fratello, e non è una sorpresa: `ABTG_Nasdaq_Apertura_US`
Stesso `ABTG_ApertureCore.mqh`, **più** 9 funzioni e 3 gruppi di input che negli
altri due **non esistono**: `UpdateVolRegime`/`VolRegimeSL`/`SetVolRegimeNormal`
(regime di volatilità, R30), `SRBlocked` (filtro S/R, R30),
`MonitorBreakoutStrength` (F1 forza della rottura), `RunnerTP`. **Tutti opt-in,
tutti a `false`/`0` di default.** 👉 **Sovrainsieme dello stesso motore**: i tre
sorgenti sono **tre rami dello stesso file, divergenti in date diverse (R51 sul
DAX, R30/F1 sul Nasdaq) e mai ri-uniti.**

---

## 3. 🧮 LA SOMMA — e il divisore, che è la vera partita

### 3.1 📏 PRIMA il divisore, ancorato all'aritmetica della FIRMA — `[MISURATO]`
La firma del 07/09 **non definisce** cosa sia un "giorno". Ma **la sua stessa
prova lo definisce**, e si ricostruisce esattamente
(`report/FIRME_2026-09-07.md` **r.20-25**: 37,8-61 operazioni/settimana di conto su
26 simboli → *"0,29 - 0,47 operazioni/giorno per simbolo"*):

| | conto | risultato | la firma scrive |
|---|---|---|---|
| estremo basso | 37,8 / 26 / **5** | **0,2908** | **0,29** ✅ |
| estremo alto | 61 / 26 / **5** | **0,4692** | **0,47** ✅ |
| estremo basso, se fossero 7 giorni | 37,8 / 26 / 7 | 0,2077 | ❌ |

👉 **Il divisore della firma è la SETTIMANA DI 5 GIORNI = GIORNI FERIALI**, e
torna **a due decimali su tutti e due gli estremi**. Non è un'assunzione: è una
ricostruzione verificata contro i numeri che qualcun altro ha già scritto.

### 3.2 🔬 POI i conteggi, misurati DA ME sui per-trade IN REPO
`backtest_pipeline/risultati_prove/trades_portafoglio/`

| file | deal in uscita | **POSIZIONI** (`position_id` distinti) | giornate distinte | finestra `close_time` |
|---|---|---|---|---|
| `abtg_trades_ABTG_Dow_Apertura_US_U30USD_770206.csv` | 130 | **96** | **96** | 2025.06.10 15:55:45 → 2026.06.29 17:30:00 |
| `abtg_trades_ABTG_DAX_Apertura_EU_D30EUR_770115.csv` | 270 | **193** | **193** | 2025.06.11 10:23:12 → 2026.06.25 09:19:38 |

🟢 **Tre controlli indipendenti, tutti passati:**
1. **CODA_12 del 17/09 dà gli stessi numeri** su magic gemelli:
   `CODA_12_pertrade_posizioni_20260917_033003.log` **r.742** *"Dow_Apertura_US_U30USD:
   2 celle, TUTTE a **130 deal / 96 posizioni** — GEMELLI COERENTI"* (r.370-382,
   magic 770208/770209) e **r.735** `..._D30EUR_786201.csv` **270 deal / 193
   posizioni**. **Due letture indipendenti, stesso numero.**
2. **POSIZIONI = GIORNATE DISTINTE in tutti e due i file (96=96, 193=193).**
   👉 Conferma per misura la guardia `InpOneTradePerDay` del motore: **una
   posizione al giorno, al massimo**. Quindi "posizioni/giorno" è letteralmente
   **la frazione di giornate in cui la sedia opera**, e per costruzione **≤ 1,00
   per simbolo**. Una famiglia mono-simbolo **non può** superare il pavimento:
   è un tetto strutturale, non sfortuna.
3. **Il 193 coincide col valore già in casa** (`CENSIMENTO_CONTRATTI_v2.md`
   r.215: *"270 uscite → 193 POSIZIONI [MISURATO sulla gemella long-only
   `aperture_r47/..._OOS_r47a.csv`]"*).

⚠️ **Buco dichiarato sulla provenienza**: i due `.csv` portano magic **770206** e
**770115**, non `770202`/`770101`. Sono **celle gemelle di banco**
(`REFERTO_PORTAFOGLIO_R16.md` via `CENSIMENTO_CONTRATTI.md` r.197: *"riga «Dow
Apertura ricetta **770206**»: 130 tr · +6.721,93 · DD 4,22%"*), e il repo avverte
che i per-trade committati di queste famiglie sono del **round R16 del 09/08**,
**precedenti** al fix di `InpAllowShort`. **I conteggi coincidono con tre fonti,
ma il magic vivo non è quello: `[MISURATO su cella gemella]`, non `[MISURATO
sulla cella viva]`.**

### 3.3 ➕ LA SOMMA
Finestra comune **2025-06-10 → 2026-06-29**: 385 giorni calendario, **275 giorni
feriali**.

| | posizioni | pos/giorno feriale |
|---|---|---|
| `770202` · U30USD (Dow, apertura 14:30 server) | 96 | **0,3491** |
| `770101` · D30EUR (DAX, apertura 08:00 server) | 193 | **0,7018** |
| **SOMMA DELLA FAMIGLIA** | **289** | **🟡 1,0509** |
| pavimento firmato | | **1,00** |
| | | **105,1% del pavimento** |

*(in **deal**, che NON è l'unità dell'Emendamento A: 400/275 = **1,4545 deal/g**.)*

### 3.4 🧪 CONTRO-ESEMPIO SUL DIVISORE — e qui il risultato **vacilla**
**Prova 1 — quanto dovrebbe essere grande il divisore per far scendere la somma
sotto 1,00?** → **289 giorni**, cioè **14 in più** dei **275 giorni feriali che
nella finestra esistono fisicamente**. Con una settimana di 5 giorni **non è
raggiungibile**, e con i soli giorni di borsa (festivi esclusi, ~264) la somma
**sale** a ~1,09. **Su questo asse il 1,0509 è un pavimento, non un picco.**

**Prova 2 — e allora perché il numero di casa dice un'altra cosa?** 🔴 **Perché
usa un altro divisore, e quel divisore non regge:**

| fonte | `770101` | divisore implicito | i feriali della finestra sono |
|---|---|---|---|
| **io**, su `..._770115.csv` | **0,7018 pos/g** (193) | **275** ✅ | 275 |
| `CENSIMENTO_CONTRATTI_v2.md` **r.215** | **0,60 pos/g** (193) · 0,84 uscite (270) | **321,7** / 321,4 🔴 | 275 |
| **`SETTE_IN_CODA_2026-09-12.md` r.250** | **"0,72-0,73 posizioni/giorno"** | **264-268** ✅ (= giorni di BORSA, festivi esclusi) | 275 |
| valore precedente citato nella stessa riga del censimento | 0,97 uscite (270) | 278,4 ✅ | 275 |

👉 **321 giorni in una finestra che ha 275 giorni feriali** = una **settimana di
SEI giorni** (386 giorni calendario − 55 domeniche ≈ 331). **È inconciliabile
con l'aritmetica a 5 giorni della firma stessa** (§3.1), e il vecchio 0,97 di
quella stessa riga tornava invece sui feriali. **Non correggo un numero di casa:
lo scrivo accanto al mio.**

🟢 **E c'è un TERZO valore di casa, che non avevo cercato e che va scritto
perché mi dà ragione — quindi a maggior ragione va verificato, non incassato.**
`SETTE_IN_CODA_2026-09-12.md` **r.250** apre la scheda `r138a` con: *"la sedia
`770101` fa **0,72-0,73 posizioni/giorno** contro il pavimento 1,00 per
FAMIGLIA"*. Divisore implicito: **193/0,72 = 268** e **193/0,73 = 264**, cioè i
**giorni di BORSA** (i 275 feriali meno ~9-11 festivi di Borsa Francoforte).
👉 **Due fonti su tre convergono nella banda 0,70-0,73** (la mia 0,7018 sui
feriali, la sua 0,72-0,73 sui giorni di borsa: **la stessa misura con due
divisori entrambi legittimi**), e **una sola sta a 0,60**, con un divisore che
eccede i giorni feriali disponibili. 🔴 **Questo NON promuove il 1,0509 a
`[MISURATO]`**: resta `[NON MISURATO]` finché il divisore non è firmato. **Ma
sposta il peso delle prove**, e con 0,72 la somma sarebbe **1,078**, non 1,0509.

🔴 **`[NON MISURATO]` la frequenza di `770101`, con ENTRAMBI i valori scritti:
0,7018 pos/g (mio, divisore ancorato alla firma) e 0,60 pos/g (censimento).**
**E la somma cambia di SEGNO:**

| lettura | somma | contro 1,00 |
|---|---|---|
| mio divisore (275 feriali, ancorato all'aritmetica della firma) | **1,0509** | 🟢 **SOPRA** (+5,1%) |
| `SETTE_IN_CODA` r.250 (giorni di borsa): 0,72 + 96/268 | **1,078** | 🟢 **SOPRA** (+7,8%) |
| numeri del censimento r.215 (0,60 + 0,34) | **0,94** | 🔴 **SOTTO** (−6,0%) |

---

## 4. 🤔 LA DOMANDA SCOMODA — e la premessa del mandato è FALSA, misurata

Il mandato chiede: *"i due simboli operano su sessioni diverse, quindi le loro
operazioni **non si sovrappongono nel tempo**. Questo aiuta o non conta?"*

### 4.1 🔴 Prima cosa: **si sovrappongono.** Due volte.
**(a) Strutturalmente, dai preset.** Tutti e due hanno **`InpCloseHour=17` /
`InpCloseMin=30`** (flat **17:30 server**) e **`InpPendingExpiryMin=120`**. Il
DAX arma alle 08:00 e **può tenere la posizione fino alle 17:30**; il Dow arma
alle **14:30**. 👉 **C'è una finestra di TRE ORE (14:30-17:30 server) in cui le
due posizioni possono essere vive insieme.**

**(b) A livello di GIORNATA, misurato** sui due per-trade:

| | valore |
|---|---|
| giornate con almeno una posizione — Dow `U30USD` | **96** |
| giornate con almeno una posizione — DAX `D30EUR` | **193** |
| 🔴 **giornate in cui operano ENTRAMBI** | **74** |
| giornate in cui opera almeno uno | **215** (78,2% dei 275 feriali) |
| giornate in cui non opera nessuno | 60 |
| **quota delle giornate del Dow che cadono in una giornata DAX** | 🔴 **74/96 = 77,1%** |

### 4.2 ⚖️ Che cosa dice il TESTO FIRMATO, e dove tace
`report/FIRME_2026-09-07.md` **r.9-13**: *"**FAMIGLIA**, intesa come motore ×
simboli su cui è schierabile"*, e il pavimento si raggiunge *"**sommando i
simboli schierabili**"*. **Sulla contemporaneità il testo NON dice niente.**
Attenendomi al testo:

| lettura | conto | risultato |
|---|---|---|
| 🟢 **"sommando i simboli"** — alla lettera | (96+193)/275 | **1,0509** → **SOPRA** |
| 🔴 **"giornate coperte"** — una giornata conta 1 | 215/275 | **0,7818** → **SOTTO** |

> ## 🔴 **IL TESTO È AMBIGUO, E LO DICO INVECE DI SCEGLIERE.** Le due letture
> **cadono ai due lati del pavimento** (1,0509 contro 0,7818). La lettura
> letterale è quella che il testo autorizza; la lettura "giornate coperte" è
> quella che descrive la *portata* di cui parlava la prova della firma
> (operazioni di CONTO al giorno). 👉 **È una DOMANDA DI INTERPRETAZIONE per
> Claudio, cioè una firma sua — non una decisione mia.**

### 4.3 📌 E la distinzione che conta, per non confondere due cancelli
La **contemporaneità** è un problema di **RISCHIO** (correlazione, tetto per
cluster C2 — firmato e non attivo), **non** di frequenza. Il pavimento di
frequenza è un criterio di **MERITO/ammissione**
(`FIRME_2026-09-07.md`: *"Non cambia nessun criterio di RISCHIO"*). 👉 **Per il
pavimento, la sovrapposizione non sconta niente: sconta il fatto che "un giorno
con due operazioni" non è "due giorni di lavoro".** Ed è esattamente su questo
che il testo tace.

---

## 5. 🚧 IL VINCOLO CHE NON SI AGGIRA — `D30EUR` è schierabile?

Il mandato: *"un simbolo entra nella somma solo se è **SCHIERABILE**, cioè se
passa il cancello di costo e ha un `n` leggibile."*

| simbolo | `n` leggibile | PF OOS | cancello di costo `stop ≥ 40 × spread` | schierabile? |
|---|---|---|---|---|
| **U30USD** (`770202`) | 🟢 96 posizioni | 🟢 **1,27013** | 🟢 **PASS · 61,9× mediana · 41,3× p95** — `ANCORA_ADR_FLOTTA_INDICI_2026-09-18.md` r.411/426 | 🟢 **SÌ** |
| **D30EUR** (`770101`) | 🟢 193 posizioni | 🟢 **1,41105** | 🟡 **42,3× geometria piena · 🔴 33,0× sulla GEOMETRIA VIVA (n=2) · 🔴 26,6× al P95** — `CENSIMENTO_CONTRATTI_v2.md` r.215 | 🔴 **CONTESTATO** |

🔴 **E la rosa stessa lo elenca come buco aperto** (`ROSA_OTTOBRE_2026-09-18.md`
r.57): *"**(F)** R5: 33,0× sulla geometria viva — serve una firma sulla manopola
o una misura nuova"*.

> ## 🔴 **QUINDI: il `1,0509` non è "il pavimento raggiunto". È "il pavimento raggiunto SE si dichiara `D30EUR` schierabile a 33,0× contro una soglia di 40×".** Se `D30EUR` non è schierabile, la famiglia torna a **UN** simbolo e la somma è **0,3491**, cioè **il 34,9% del pavimento**. 👉 **Non è una misura che manca: è una FIRMA che manca** — e per costruzione (§3.2, tetto di 1 posizione/giorno/simbolo) **nessuna famiglia mono-simbolo può arrivare a 1,00.**

⚠️ E va detto perché la gamba `D30EUR` **non è neutra**: **`770101` gira anche
sul conto REALE `10105439`**. Qualunque cosa si firmi su di lei va scritta come
**NON applicabile al reale senza una firma separata** (perimetro già dichiarato
nella rosa, r.57). **Qui non propongo niente sul reale.**

---

## 6. 🪦 IL TERZO SIMBOLO — GIÀ GIRATO, E BOCCIATO DAL SUO CRITERIO PRE-REGISTRATO

**Questa è la notizia nuova del referto.** Lo stesso binario del DAX ha **già
girato su `F40EUR` (CAC 40)**, sulla **stessa cella** e la **stessa finestra**, e
i risultati sono **in repo dal 17/09** — mai letti contro il criterio che era
stato **scritto prima**, il 12/09.

### 6.1 📜 Il criterio, scritto il 12/09 PRIMA dei numeri
`report/SETTE_IN_CODA_2026-09-12.md` **r.796** (scheda `r138a`):
> *"≥ **0,28 posizioni/giorno** feriale in OOS **E** DD OOS ≤ **10,0%** → la
> famiglia arriva a 1,00 e R3 si chiude... **DD OOS > 10,0% → bocciato PER
> RISCHIO, qualunque frequenza abbia.**"*
> · **r.267** (F3): *"il rischio morde a qualunque n"*
> · *"i gemelli 786204/786205 devono coincidere al centesimo: se divergono,
> banco non deterministico e i numeri non si leggono"*
> · condizione (2), classe 282: *"se la prima operazione non è vicina al
> 2025.06.10, la frequenza è sottostimata da un buco di tick, non dal CAC"*

E il motivo per cui il round esisteva, **r.250-253**: *"`0,72 + 0,72 = 1,44`: **un
solo simbolo in più** porta la famiglia sopra il pavimento."* **La domanda del
mio mandato era già stata posta sei giorni fa.**

### 6.2 🔢 I numeri, letti da me riga per riga
`backtest_pipeline/risultati_prove/dal_vps/ABTG_DAX_Apertura_EU/ABTG_DAX_Apertura_EU_F40EUR_{IS,OOS}_r138a.csv`, righe 2-3

| | IS | **OOS** |
|---|---|---|
| Profit | +7.126,12 | 🔴 **−7.266,30** |
| **Profit Factor** | 1,44028 | 🔴 **0,76965** |
| **Equity DD %** | 7,3578 | 🔴 **11,8210** |
| Trades (deal) | 130 | 195 |
| Peggior Giornata % | −1,0259 | −1,0640 |
| `InpMagic` | 786205 / 786204 | 786204 / 786205 |

**Cella verificata identica a quella viva del DAX**: `InpSessionHour=8` ✅ (ora
server BCM corretta per il CAC, come da contromisura del file prova),
`InpRangeMinutes=35`, `InpEntryMode=2`, `InpRangeMode=0`, `InpBufferPoints=500`,
`InpRetestOffsetPts=200`, `InpAllowShort=0`, `InpSLMode=0`, `InpTP1_R=1`,
`InpTP1_ClosePct=50`, `InpBreakevenAtTP1=1`, `InpTrailMode=1`, `InpTrailTF=5`,
`InpAllowReverse=0`, `InpRiskPercent=1`.

**Frequenza** (`CODA_12_..._20260917_033003.log` **r.37-49** e **r.740**): `F40EUR`
786204 **e** 786205 → **195 deal / 152 POSIZIONI**, `close_time` **dal
2025.06.10 09:47:13** al 2026.06.29 17:30:00.
→ **152 / 275 feriali = 0,5527 pos/g.**

### 6.3 ⚖️ Il verdetto, contro il criterio scritto prima
| cancello `r138a` | soglia | misurato | esito |
|---|---|---|---|
| 🟢 **determinismo** (gemelli al centesimo) | identici | **786204 ≡ 786205 su tutte le colonne, in IS e in OOS** | 🟢 **PASS** — i numeri si leggono |
| 🟢 **classe 282** (prima operazione vicina al 2025.06.10) | — | **2025.06.10**, il primo giorno della finestra | 🟢 **PASS** — nessun buco di tick |
| 🟢 **F1 · frequenza** | ≥ 0,28 pos/g | **0,5527** | 🟢 **PASS al 197% della soglia** |
| 🔴 **F3 · RISCHIO** | DD OOS ≤ 10,0% | **11,8210%** | 🔴 **FALLITO (+18,2% sopra)** |
| 🔴 **merito** (non richiesto ma decisivo) | — | **PF OOS 0,770 · −7.266,30 su 195 trade** | 🔴 **PERDE fuori campione** |

> ## 🔴 **`F40EUR` NON ENTRA NELLA SOMMA — e non per un buco di misura: per il suo cancello di RISCHIO, pre-registrato sei giorni prima che i numeri esistessero.** Il criterio diceva *"bocciato PER RISCHIO, **qualunque frequenza abbia**"*, e la frequenza c'era (il doppio della soglia). **Il 12/09 avevamo previsto la domanda giusta e messo il cancello giusto. Ha funzionato.**
> 🧪 **E la prova di regime lo conferma dall'altro lato**: `PF IS 1,44` → `PF OOS 0,770`. In campione guadagna, fuori campione perde. **È un simbolo che non porta l'edge, non un simbolo lento.** La previsione scomoda scritta nel file prova (*"mi aspetto che F40EUR sia PIÙ LENTO del DAX"*) è risultata **sbagliata sulla frequenza** (0,55 contro 0,70, sì più lento ma non di poco) **e irrilevante**: il problema era un altro.
> ⚪ Il cancello di **costo** su `F40EUR` resta comunque `[NON MISURATO]` (stop
> `n=1`, **`[NON CITABILE]`**, e **nessuno spread misurato** —
> `ANCORA_ADR_FLOTTA_INDICI_2026-09-18.md` r.103 e r.342). **Non serve più
> misurarlo: il cancello di rischio ha già chiuso.**

🔓 **Se `F40EUR` fosse passato**, la somma sarebbe stata **441/275 = 1,604
pos/g** — il pavimento con il 60% di margine. **È la strada che si chiude oggi,
e va detto che era la più corta.**

---

## 7. 🔎 E POI LARGO: TUTTE le altre coppie, cercate a macchina

Metodo: per ognuno dei **70+ `.mq5`** in `mql5/Experts/` ho rimosso commenti e
normalizzato gli spazi, poi calcolato la **similarità di Jaccard sulle righe di
codice** per **tutte** le coppie, soglia 75%. Così l'insieme è **elencato per
nome**, non definito per differenza (classe 180).

### 7.1 🏆 La classifica delle coppie più identiche del repo
| similarità | coppia | simboli diversi? |
|---|---|---|
| **97,9%** | `ABTG_DAX_Live5m` ↔ `ABTG_Nasdaq_Live5m` | 🟢 **SÌ** (D30EUR / NASUSD) |
| 97,1% | `SupRev_DAX_H1_Ott` ↔ `SupRev_DOW_H1_Ott` | 🟢 SÌ |
| 96,9% | `SuperWave` ↔ `SuperWave_DOW_H1_Ott` | stesso U30USD |
| 96,0-96,5% | tutte le altre coppie `SupRev_*_Ott` (CAC/DAX/DOW, H1/H4) | 🟢 SÌ |
| 95,9% | `SupertrendReversal_Multi` ↔ `_Multi_Ottimizzato` | (multi-simbolo in un binario) |
| 92,0-92,8% | `SuperWave` ↔ `SuperWave_DAX_H4_Ott` ↔ `SuperWave_DOW_H1_Ott` | 🟢 SÌ |
| 90,1% | `DAX_Apertura_EU_Ott` ↔ `Nasdaq_Apertura_US_Ott` | 🟢 SÌ |
| **87,5%** | **`ABTG_DAX_Apertura_EU` ↔ `ABTG_Dow_Apertura_US`** | 🟢 **SÌ** — §2 |
| 85,6% | `Apertura_3Ingressi` ↔ `Nasdaq_Apertura_US` | 🟢 SÌ |
| 82,2% | `ABTG_EMA200` ↔ `ABTG_EMA200_Ottimizzato` | 🟡 sotto soglia, non mi pronuncio |
| 81,2% / 75,2% | `Dow_Apertura_US` / `DAX_Apertura_EU` ↔ `Nasdaq_Apertura_US` | 🟢 SÌ (sovrainsieme, §2.6) |

*(nota: l'87,5% della coppia del §2 è **Jaccard su file interi**, intestazioni e
commenti compresi — che divergono molto. Sul **codice** la divergenza è 121
righe su ~1.440, §2.3.)*

### 7.2 📋 Famiglia per famiglia: **sono una famiglia? la somma arriva a 1,00?**

| famiglia | membri (per nome) | stesso motore? | somma dei **SCHIERABILI** | arriva a 1,00? |
|---|---|---|---|---|
| 🥇 **`Apertura*` (core condiviso)** | `770202` U30USD · `770101` D30EUR · *(`F40EUR` bocciato)* · `770250` NASUSD | 🟢 **SÌ** (§2) | **1,0509** con D30EUR dichiarato schierabile · **0,3491** senza | 🟡 **SULLA SOGLIA — serve una FIRMA, non una misura** |
| **`SupRev_*_Ottimizzato`** | `970911` D30EUR H1 · `970912` D30EUR H4 · `970913` NASUSD H1 · `970914` U30USD H4 · `970915` F40EUR H4 · `970916` U30USD H1 | 🟢 **SÌ, e più del primo caso**: 95,4-97,1%, differenze sostanziali = **solo** `InpStMult` (3.0/3.5), `InpStAtrPeriod` (9/10), magic, commento, e un `ExportTrades()` presente solo nel NAS | 🔴 **0,00** | 🔴 **NO** |
| **`SuperWave*`** | `770511` U30USD H1 · `770512` D30EUR H4 · `770531` U30USD H4 | 🟢 SÌ (92,0-96,9%) | 🔴 **non componibile** | 🔴 **NO** |
| **`MaxMinNotte*`** | `770411` D30EUR M15 (`_DAX_Short_Ottimizzato`) · `770402`/`788600` XAUUSD | 🔴 **NO** — vedi sotto | **≤ 0,389** (38,9%) | 🔴 **NO** |
| **`*_Live5m`** | `ABTG_DAX_Live5m` D30EUR · `ABTG_Nasdaq_Live5m` NASUSD | 🟢 **SÌ, la coppia più identica del repo (97,9%)** | ⚪ **`[NON MISURATO]`** | ⚪ **NON ANCORA MISURATO** |
| **`EMA200`** | `771531` U30USD H1 · `771560` AUDJPY · `771561` GBPUSD · `971501` XAUUSD H4 | 🟢 SÌ per costruzione sui tre primi (stesso binario `ABTG_EMA200`) | ⚪ **`[NON MISURATO]`** | ⚪ **NON ANCORA MISURATO — il buco più grosso** |
| **`GapFill`** | `ABTG_GapFill.mq5` — **un solo EA, nessun gemello** | — | — | 🔴 non è una coppia |

### 7.3 🔬 Il dettaglio di ognuna, coi numeri

**🔴 `SupRev_*` — famiglia SÌ, somma ZERO.** 6 EA, 4 simboli, 2 TF, e la
similarità più alta del repo dopo i `Live5m`. **Ma nessun simbolo è schierabile:**
- `970913` NASUSD H1: cancello di costo **15,1×** (38% del pavimento), **coda
  10,4×**, e il minimo delle gambe **5,4× sotto il pavimento duro** —
  `CANCELLO_COSTO_FLOTTA_2026-09-10.md` **r.412** (revisione del 18/09 sera, che
  ha peggiorato il verdetto da 28,7× a 15,1×). Più: **nessuno split IS/OOS**
  (classe 224, `CENSIMENTO_CONTRATTI_v2.md` r.316). 🔴 **NON schierabile.**
- `970912` D30EUR H4: **ZERO trade in assoluto**, verificato al 17/09
  (`CANCELLO_COSTO_FLOTTA_2026-09-10.md` **r.1014**), e cancello di costo
  retrocesso a **`[NON MISURATO]`, banda 27,8-184×** (r.411). 🔴 **n = 0.**
- 🔴 **`970911` (DAX H1), `970914` (DOW H4), `970915` (CAC H4), `970916` (DOW H1):
  ZERO menzioni** in `CENSIMENTO_CONTRATTI_v2.md`, `ROSA_OTTOBRE_2026-09-18.md`
  e `CANCELLO_COSTO_FLOTTA_2026-09-10.md` (cercati uno per uno). **`[NON
  MISURATO]` su PF, n, DD e costo.**
- 👉 **Somma dei simboli schierabili = 0,00. NO.** 🔓 **Ma NON è un certificato
  di morte**: quattro gambe su sei non sono mai state misurate, e la manopola
  del costo che le riguarda è dichiarata **libera** dal cancello stesso (r.660:
  *"`InpSLLookback: 5 → 8/10` ... 🟡 SÌ, mai provata"*).

**🔴 `SuperWave*` — famiglia SÌ, somma non componibile.**
`770511` U30USD H1 fa **38,5×**, cioè **il 96% del pavimento: NO** per un
soffio (r.404) — e il cancello dichiara **la manopola che lo salverebbe già
esistente e mai girata**: *"`InpSLBufferAtr` **esiste** ... ed è a **0**.
🔓 Manopola mai messa ad asse: bastano ~0,05 ATR per superare il pavimento"*
(r.661). `770531` U30USD H4 passa largo (**147,8×**, r.405) **ma è lo STESSO
simbolo su un altro TF**: 🔴 **un TF in più non è un simbolo in più**, e il testo
firmato somma **simboli**. `770512` D30EUR H4: **zero menzioni**, `[NON
MISURATO]`. 👉 **Un solo simbolo in gioco ⇒ non c'è una somma da fare. NO.**

**🔴 `MaxMinNotte*` — e qui dico NO anche al "stesso motore", col criterio in mano.**
`ABTG_MaxMinNotte.mq5` (583 righe di codice) contro
`ABTG_MaxMinNotte_DAX_Short_Ottimizzato.mq5` (467): **52 input su 53 in comune**
(A4 ✅) **ma 154 righe di codice divergenti**, e il generico ha macchinario che
all'Ottimizzato **manca del tutto**: `UnTradeAlGiorno()`, `gOperatoOggi`,
`PuoArmare_Calc()`, `TimbraGiornata_Calc()`, `GiornataSpesa_Calc()`,
`ContaPosizioniMie()`, più la gestione della posizione **per ticket** invece che
**per simbolo**. 🔴 **`F3` scatta su un meccanismo che tocca DIRETTAMENTE la
frequenza** (un trade al giorno sì/no): non è una manopola spenta, è una guardia
che c'è o non c'è. 👉 **A3 discorde ⇒ motori diversi, e i due conteggi di
posizioni non sono nemmeno confrontabili.**
🟢 **E il verdetto non dipende da questa chiamata delicata**, perché la somma non
ci arriva comunque: `770411` D30EUR M15 fa **0,078 op/g** (in posizioni la
forbice è **0,033-0,078**: `n=21 deal`, `InpTP1Pct=50`, `CENSIMENTO_CONTRATTI_v2.md`
r.262) e `MaxMinNotte` XAUUSD **316 posizioni / 1.015 feriali (2022.08.08 →
2026.06.26, `CODA_12` r.384-389) = 0,3113 pos/g** → **somma ≤ 0,389 = 38,9% del
pavimento. NO.** ⚪ Nota a favore: la gamba XAUUSD **passa il costo largo**
(`770402` XAUUSD H2, **126,5×**, r.462) — è la frequenza a non esserci.

**⚪ `DAX_Live5m` ↔ `Nasdaq_Live5m` — la coppia PIÙ IDENTICA del repo (97,9%), su
due simboli diversi, e NON è nella rosa.** 🔴 **Zero righe** in
`CANCELLO_COSTO_FLOTTA_2026-09-10.md` e **zero righe di contratto** in
`CENSIMENTO_CONTRATTI_v2.md` (il solo cenno, **r.431**, le dà *"per **accese**"*
insieme a `ORB` nativo e `ORB_Fibo`, **senza un numero**). 👉 **`[NON MISURATO]`
su PF, n, DD e cancello di costo. Non è un NO: è un "non ancora misurato", e per
il motto del 09/09 è una casella aperta, non una casella provata.**

**⚪ `EMA200` — IL BUCO PIÙ GROSSO DI QUESTO REFERTO, e va detto per intero.**
`771531` U30USD H1 è la **seconda** della rosa e fa **0,931-0,945 pos/g**: **è a
meno del 7% dal pavimento DA SOLA**. E lo **stesso binario `ABTG_EMA200`** ha
girato su **due valute**, con posizioni **misurate da `CODA_12` il 17/09**:

| gamba | deal | **POSIZIONI** | finestra | feriali | **pos/g** |
|---|---|---|---|---|---|
| `771560` **AUDJPY** (`CODA_12` r.30-35) | 1345 | **730** | 2016.08.10 → 2026.06.22 | 2.574 | **0,2836** |
| `771561` **GBPUSD** (`CODA_12` r.23-28) | 1316 | **718** | 2016.08.24 → 2026.06.17 | 2.561 | **0,2804** |

Somma **aritmetica** con `771531` (0,847 pos/g su finestra piena) = **1,411**.
🔴 **MA NON LA SCRIVO COME RISULTATO, perché la schierabilità manca del tutto:**
`771560` e `771561` sono **"magic VERGINI" di round di prova** —
`SETTE_IN_CODA_2026-09-12.md` **r.90**: *"Magic vergini ... `771560·771561` ...
**Nessuna sedia viva**"* — e **non hanno PF, DD né cancello di costo** nel
censimento dei contratti (`CANCELLO_COSTO_FLOTTA` elenca per `EMA200` solo
`771531` U30USD a r.406 e `971501` XAUUSD a r.463). 👉 **`[NON MISURATO]` sulla
schierabilità di AUDJPY e GBPUSD. Le due gambe esistono, i loro `n` esistono, il
loro MERITO no.**
🔓 **E questa è la via più corta che resta aperta**, perché parte da **0,847-0,945**
invece che da 0,349: **basterebbe una gamba sola sopra 0,06-0,16 pos/g** — e le
due misurate fanno **0,28**, quattro volte tanto. **Il collo di bottiglia non è
la frequenza: è il PF/DD/costo di quelle due gambe.**

---

## 8. 🕳️ I BUCHI, dichiarati per nome

| # | buco | tag | come si chiude |
|---|---|---|---|
| **B1** | 🔴 **L'UNITÀ e il DIVISORE del pavimento** (posizioni/deal · settimana da 5 o 6 giorni · "somma dei simboli" o "giornate coperte"). **Quattro letture, e cadono ai due lati di 1,00: 1,4545 · 1,0509 · 0,94 · 0,7818** | 🔴 **[NON MISURATO]** | ✍️ **firma di Claudio** — non è misurabile, è una convenzione |
| **B2** | 🔴 **La frequenza di `770101`, TRE valori di casa**: **0,7018** (mia, 275 feriali) · **0,72-0,73** (`SETTE_IN_CODA_2026-09-12.md` r.250, ~264-268 giorni di borsa) · **0,60** (`CENSIMENTO_CONTRATTI_v2.md` r.215, divisore implicito **321,7**, che **eccede** i feriali della sua finestra) | 🔴 **[NON MISURATO], tutti e tre scritti** | si chiude con B1: deciso il divisore, il conto è aritmetica |
| **B3** | 🔴 **Il cancello di costo di `D30EUR` sulla geometria VIVA: 33,0× (n=2) contro 40×.** Senza, la famiglia torna a un simbolo e la somma a **0,3491** | 🟠 misurato ma **sotto soglia** | ✍️ **firma** sulla manopola **oppure** una misura nuova dello stop vivo (la rosa la elenca già come `(F)`) |
| **B4** | ⚪ I due per-trade che ho contato portano magic **770206** e **770115**, non `770202`/`770101`, e sono del **round R16 del 09/08**, precedente al fix `InpAllowShort` | ⚪ **[MISURATO su cella gemella]** | il trasporto dei CSV di `r172a-e` (già in coda nella rosa, r.340) |
| **B5** | ⚪ **PF, DD e costo delle gambe `EMA200` AUDJPY/GBPUSD** — le posizioni ci sono (730 e 718), il merito no | ⚪ **[NON MISURATO]** | 2 finestre × 2 simboli di tester — **non lo propongo io**, è una decisione di Claudio |
| **B6** | ⚪ **`DAX_Live5m` / `Nasdaq_Live5m`**: la coppia più identica del repo, **senza un solo numero** | ⚪ **[NON MISURATO]** | idem |
| **B7** | ⚪ **`SupRev` `970911`/`970914`/`970915`/`970916`**: quattro gambe dello stesso motore, **zero menzioni** in tutti e tre i registri | ⚪ **[NON MISURATO]** | idem |
| **B8** | 🟡 La riserva **A3**: `InpAllowReverse` esiste nel DAX e non nel Dow. Spento oggi in tre modi, **ma è una manopola della FREQUENZA** | 🟡 dichiarato | resta scritto: se un giorno si accende, la somma va rifatta |

---

## 9. 🧾 CHE COSA NON HO FATTO — i limiti del mandato, rispettati

- 🚫 **Non ho proposto di abbassare il pavimento** né di allargare la definizione
  di famiglia. La soglia (1,00) e la definizione (*motore × simboli
  schierabili*) sono **firmate** e le ho usate come sono.
- 🚫 **Non ho scelto** fra le due letture del testo ambiguo: le ho **scritte
  entrambe con i loro numeri** e le ho portate a Claudio come **domanda di
  interpretazione** (§4.2, buco B1).
- 🚫 **Non ho fatto tornare il conto.** Il terzo simbolo che avrebbe chiuso la
  partita col 60% di margine (`F40EUR`, 1,604) **l'ho bocciato io**, sul suo
  criterio pre-registrato — e l'ho scritto **con lo stesso entusiasmo** con cui
  ho scritto il 1,0509.
- 🚫 **Nessun certificato di morte firmato qui.** `F40EUR` come **simbolo della
  famiglia Apertura** è bocciato **per rischio su questa cella** (criterio
  `r138a`); **non** è archiviato come motore, e gli restano `[NON MISURATO]` il
  TF, l'uscita e il costo.
- 🚫 **Sola lettura**: nessun EA, preset, file prova, riga di coda, backtest o
  terminale toccato. Conto reale `10105439` **mai** toccato. **Nessun commento
  su taglie o parametri di rischio.**
- 💾 File scritto col metodo della **classe 410**: codifica in `utf-8` **prima**,
  scrittura su `.tmp` con `fsync`, poi `os.replace` atomico.

---

## 10. 📤 LA RIGA CHE MI È STATA CHIESTA

> ## 🟡 **SÌ, UNA FAMIGLIA DELLA ROSA ESISTE — è `Apertura Mercati` (`770202` U30USD + `770101` D30EUR), e sono lo STESSO MOTORE per misura, non per somiglianza. MA la somma vale `1,0509 pos/g` contro un pavimento di `1,00`: passa del 5,1% SOLO con il divisore a 5 giorni e SOLO se si dichiara `D30EUR` schierabile a `33,0×` contro `40×`. Con il numero di casa di `770101` fa `0,94`, e leggendo "giornate coperte" fa `0,7818`. 👉 Non è una misura che manca: sono DUE FIRME (l'unità del pavimento, il costo di `D30EUR`). E il terzo simbolo che avrebbe chiuso la partita con il 60% di margine, `F40EUR`, è GIÀ GIRATO e l'ho bocciato: `DD OOS 11,82% > 10,0%` e `PF OOS 0,770`.**

---

### 🎉 E la nota allegra, che è vera quanto il resto
Tre cose belle di oggi, e nessuna è costata un secondo di macchina:
1. 🟢 **Il pavimento di frequenza NON è più "irraggiungibile per costruzione".**
   La rosa del 18/09 diceva *"nessuna famiglia può arrivarci, hanno un simbolo
   solo"*: **era falso**, e la famiglia c'era già, attaccata a due terminali.
   Da *"impossibile"* a *"due firme"*. 🔥
2. 🟢 **Il cancello del 12/09 ha funzionato da solo.** Qualcuno sei giorni fa ha
   scritto *"DD OOS > 10% → bocciato per rischio, qualunque frequenza abbia"*
   **prima** che i numeri esistessero. Oggi i numeri sono arrivati, hanno fatto
   il 197% della soglia di frequenza — e il cancello ha detto no comunque.
   **Quello è il metodo che ci salva la challenge**, e ha appena dato prova di sé.
3. 🟢 **Tre controlli indipendenti hanno dato lo stesso numero** (i miei
   `position_id`, il log `CODA_12`, il censimento) e **posizioni = giornate
   distinte** su tutti e due i file. Quando i conti tornano da tre parti, si
   lavora su roccia.

**E la brutta, detta da socio:** `1,0509` è **il 105,1% di un pavimento**, cioè
**quattordici posizioni di margine su 275 giorni**. Non è una vittoria: è un
pareggio ai punti che aspetta un arbitro. L'arbitro è Claudio, e le domande sono
due, scritte al §8.

---

*Referto prodotto in sola lettura il 18/09/2026. Ogni numero porta file e riga.
Dove il numero non c'è, c'è `[NON MISURATO]`.*
