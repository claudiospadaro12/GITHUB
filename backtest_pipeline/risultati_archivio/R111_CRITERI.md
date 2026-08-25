# ✍️ R111 — BREAKING BAND SU **M30** (GBPUSD · EURUSD · AUDUSD) — CRITERI **[DA FIRMARE]**

## 🖊️ LA PRE-FIRMA, registrata qui — e cosa copre **esattamente**

> **Claudio, 25/08/2026 sera: _"FIRMO R111"_.**
> La pre-firma è **sul PERIMETRO**, e il perimetro è questo, testuale:
> **_«Breaking Band su M30: il confine fra l'H1 vivo e l'M15 morto»_**.

**Che cosa vuol dire, detto senza sconti.** La pre-firma autorizza il round a
**esistere** e a **partire** — non approva i numeri che ci sono dentro. Le
**sette decisioni** del § 11 sono **PRE-FIRMATE CON PROPOSTE**: sono già scritte
qui, con la loro alternativa scartata e il perché, **prima** di qualunque
numero, e **ognuna resta smentibile da Claudio finché la corsa non parte**. Se
una proposta non gli piace, si cambia **qui**, e poi si gira — mai il contrario:
🔒 **i criteri si cambiano PRIMA dei numeri, mai dopo.**

### 🧷 LA FORMA DEL LUCCHETTO — dichiarata, perché il driver la legge

Il titolo di questo file porta la stringa `[DA FIRMARE]`, e **non è
decorazione**: il driver `righe/RIGA_R111_BB_M30.ps1` **scarica questo file al
pin** e ci cerca dentro **quella stringa esatta**.

| stato | cosa succede |
|---|---|
| stringa presente, **giro a vuoto** (`-SoloControllo`) | **parte lo stesso**: non apre MT5, non produce nessun numero |
| stringa presente, **corsa vera** senza `-CriteriFirmati` | **si ferma, `exit 2`**, e stampa a schermo le sette decisioni |
| stringa presente, **corsa vera** con `-CriteriFirmati` | **parte**, e scrive nel referto un **RILIEVO** che cita **la pre-firma del 25/08** come autorizzazione |
| stringa tolta dal file | il gate si apre da solo |

👉 **Perché il lucchetto resta chiuso anche con la pre-firma in mano.** Perché
la pre-firma è sul **perimetro**, non sulle sette decisioni; e perché un file
che dice *"firmato"* mentre il flag non è mai stato premuto è un **guardiano
decorativo** (checklist 14). Così invece la firma è **un fatto che finisce nel
referto**: la riga di lancio del § *2️⃣* di `RIGA_R111_DA_MANDARE.md` porta
`-CriteriFirmati` **citando la pre-firma**, e chi legge lo zip fra sei mesi
sa **chi ha autorizzato cosa**.

---

## 0. 📌 DA DOVE NASCE — e perché **non** è rigirare la griglia di un morto

### La domanda del round, **una sola, e chirurgica**

Il Breaking Band **VIVE a H1** ed è **MISURATO**
(`R103_REFERTO_DRIVER_FOREX_METALLI_20260824_1922.txt`, TABELLA 1 — finestra
2020.01.01→2026.06.30, **modello 1 (OHLC M1)**, deposito 100.000, `Spread=0`,
rischio 1,0%):

| simbolo | `InpPatternMode` VIVO | profitto | PF | DD % | n | prima operazione |
|---|---|---:|---:|---:|---:|---|
| **GBPUSD** | **2** (entrambi) | +5.415 | **1,199** | 7,75 | **126** | 2020.01.14 |
| **EURUSD** | **0** (solo CONTINUAZIONE) | +8.271 | **1,936** | 2,51 | **59** | 2020.02.03 |
| **AUDUSD** | **1** (solo INVERSIONE) | +5.365 | **1,541** | 2,13 | **64** | 2020.02.05 |

Lo stesso motore **MUORE a M15**, e anche questo è **MISURATO** — R108, corsa
del 25/08 (`R108_REFERTO.md`), tick reali, 2022.07→2026.06:

| simbolo | INTERA | IS (2+2) | OOS (2+2) |
|---|---|---|---|
| GBPUSD | **−8.754 / PF 0,823 / n 227** | −1.351 / 0,935 | −7.511 / 0,743 |
| EURUSD | **−8.872 / PF 0,637 / n 87** | −4.104 / 0,712 | −4.973 / 0,533 |
| AUDUSD | **−3.131 / PF 0,865 / n 118** | −2.762 / 0,781 | −381 / 0,965 |

**Sei finestre su sei rosse**, e con una lettura fine che conta più del verdetto:
R108 è morto **di SEGNALE, non di costo** — il cancello zero S0a era
**SUPERATO** dove misurabile (GBPUSD take lordo 5,4× lo spread, AUDUSD 3,6×).

🎯 **M30 è il punto di mezzo, e non è mai stato misurato.**
`R33`, `R94`, `R102`, `R103` hanno **tutti** `InpTF=16385` (H1); R108 ha
misurato `InpTF=15` (M15). **Fra i due non c'è niente.**

### 🔎 E c'è un dettaglio LETTO NEL SORGENTE che M15 non aveva

`ABTG_BreakingBand.mq5`, **riga 213**, l'input su cui si regge tutto il round:

```mql5
input ENUM_TIMEFRAMES InpTF = PERIOD_H1;   // TF operativo (guida: D1/H4/H1/M30)
```

👉 **`M30` sta nella lista dei TF che il motore dichiara operativi. `M15` non
c'era.** È una riga **letta nel sorgente il 25/08**, non un ricordo, e non è una
prova di niente — un commento non è una misura. Ma è la differenza fra *"proviamo
un TF a caso"* e *"proviamo l'ultimo TF che l'autore del motore nomina"*.

> ### ❓ LA DOMANDA, testuale: **DOV'È IL CONFINE DELL'EDGE?**
> Fra **H1 e M30** (e allora il capitolo della discesa di TF è chiuso), oppure
> fra **M30 e M15** (e allora M30 è un candidato che nessuno ha ancora guardato).

### 🟢 Perché **NON** viola la REGOLA DELLA SECONDA CACCIA

La clausola di casa (19/08) dice: quando un motore è dichiarato **senza edge**,
si cercano **meccanismi alternativi**, **MAI "parametri diversi dello stesso
motore morto"**. Qui la clausola **non morde**, e va detto perché con i numeri
in mano, non con una frase:

| l'obiezione | la risposta, misurata |
|---|---|
| *"il motore è stato dichiarato morto ieri"* | ❌ **No.** Il motore è **VIVO a H1** e ha **tre sedie in campo**. Quello che R108 ha dichiarato morto è **il motore A M15**, cioè **un punto**, non la famiglia |
| *"state rigirando una griglia"* | ❌ **Non c'è nessuna griglia.** L'unico flag `Y` dei file prova è `InpMagic`, e il driver **si ferma** se ne trova un secondo. **Zero parametri spazzolati** |
| *"è pesca: un altro tentativo finché non esce verde"* | ❌ **È UN PUNTO NUOVO FRA DUE PUNTI MISURATI**, sulla **stessa cella viva**, con **un solo input diverso** (`InpTF`). Non si cerca una cella verde: si cerca **dove sta il confine**, e § 8 dichiara **PRIMA** che cosa si legge in **ognuno** dei tre esiti possibili — **compreso il rosso, che chiude il capitolo** |

⚠️ **E il paletto che rende la cosa onesta è al § 8**: se M30 esce rosso, il
capitolo *"abbasso il TF del Breaking Band"* si **CHIUDE**. Niente M20, niente
M10, niente ripescaggi, nessuna nuova griglia. **Questa è la regola che
distingue una misura da una pesca, ed è scritta prima di girare.**

---

## 1. 🧭 IL METODO — **sei celle, un asse solo**

Per ogni simbolo, **due celle**, e fra loro cambia **`InpTF` e nient'altro**:

| cella | TF | `InpTF` | finestra | modello | ruolo |
|---|---|---|---|---|---|
| `00_metroH1` | H1 | 16385 | 2020.01.01 → 2026.06.30 | **1 (OHLC M1)** | **IL METRO** — riproduce R103 (gate G0) |
| `01_m30` | M30 | **30** | 2018.07.01 → 2026.06.30 | **4 (TICK REALI)** | **LA MISURA NUOVA** del round |

È **la stessa macchina di R108**, non una macchina nuova. Le celle metro sono
**copiate riga per riga da quelle di R108** — le stesse che il 25/08 hanno fatto
**G0 3/3 al centesimo** — salvo `InpMagic` e `InpComment`.

### 1.1 Come è garantita l'attribuzione — è **verificata dal codice**, non promessa

Il driver, **prima di aprire MT5**, pretende su ogni file:

- **GATE DELLA STELLA**: la cella `01_m30` differisce dalla `00_metroH1` dello
  stesso simbolo **esattamente su `InpTF`** (più `InpMagic`), e su **nessun
  altro input**. Non basta *contare* le righe diverse: due righe **sbagliate**
  darebbero lo stesso conteggio;
- **DUE GATI DELL'ANTENATO** (checklist **72**) — perché la stella confronta le
  due celle **fra loro** e per costruzione **non può vedere** la stessa riga
  storta in **entrambe**:
  - contro `prove/R108_<SIM>_00_metroH1.txt` — delta ammessi **`InpMagic`,
    `InpComment`**;
  - contro `prove/R103_ABTG_BreakingBand_<SIM>_<magic>.txt` — delta ammessi
    **`InpMagic`, `InpComment`, `InpNewsCurrencies`** (riga tolta; inerte perché
    `InpUseNewsFilter=false` e il sorgente esce subito, righe 1491-1496).
  👉 **Due antenati e non uno**: R108 è la copia da cui R111 nasce, R103 è
  l'originale. Se qualcuno avesse corrotto R108 *dopo* la sua corsa, il secondo
  gate lo vede;
- **GATE DEI VALORI**: `InpTF` vale **davvero** 16385 nella prima e **30** nella
  seconda, e `InpPatternMode` vale **il pattern vivo di quel simbolo**. Se i
  file di due simboli fossero scambiati, la stella resterebbe verde e questo no
  (checklist **34-bis**);
- **GATE DELL'ASSE UNICO**: un solo flag `Y` per file, ed è `InpMagic`;
- **GATE DEI MAGIC**: unici fra i file, **vergini**, e mai un magic vivo o di un
  round precedente;
- **`@SIMBOLO` / `@PERIODO` / `@DAQUANDO`** confrontati, non creduti;
- 🆕 **GATE DELLE DATE** (checklist **79**): `FromDate` e `ToDate` di **ogni**
  `.ini` prodotto sono controllati **sugli argomenti** (forma
  `^\d{4}\.\d{2}\.\d{2}$`, giorno che **esiste** davvero, `ToDate > FromDate`) **e
  poi RILETTI DALL'ARTEFATTO**. Vedi § 9.

### 1.2 ⚙️ Come gira ogni cella — **tre lanci, tre domande diverse**

| lancio | `.ini` | cosa produce | a cosa serve |
|---|---|---|---|
| **SINGOLA** sulla finestra INTERA | `Optimization=0`, `Report=` | il **report `.htm` coi DEAL** (Ora, Direzione, Tipo, Volume, **Prezzo**, Profitto, Commissioni, Swap) | **TUTTO IL PASSO 0**: prima operazione, take in pip, durata in barre, peggior giornata |
| **GEMELLE** sulla finestra INTERA | `Optimization=1`, sweep su `InpMagic` | `OptResults_*.csv` via **OPTFRAME** | **profitto / PF / DD equity / n** — e il **gate G0** |
| **GEMELLE** su **IS** e su **OOS** (solo celle M30) | idem | due CSV | i cancelli **S1 · S2 · S3** |

**Passate**: metro H1 = 1 + 2 = **3**; cella M30 = 1 + 2 + 2 + 2 = **7**.
Totale **(3 + 7) × 3 simboli = 30 passate**.

> ⚠️ **Perché la SINGOLA e non solo l'ottimizzazione** — è la **traduzione
> dichiarata** che la checklist **57** impone, ed è la stessa di R108.
> `OptResults` dà **numeri di riepilogo**; il PASSO 0 chiede **il take in pip**
> e **la durata in barre**, che sono grandezze **per operazione** e pretendono
> **entrambi i prezzi**. L'unico artefatto che li contiene è la tabella Deal del
> report `.htm`. Il file per-trade dell'EA (`abtg_trades_*.csv`) **non basta**:
> **misurato nel sorgente** il 25/08, scrive **solo i deal di uscita** (riga
> 1531), quindi il prezzo d'ingresso **non c'è**.

---

## 2. 🧊 LE SEI CELLE E I MAGIC

Blocco **764xxx**, **VERGINE**: `grep -rEo '\b7640[0-9]{2}\b'` su tutto il repo
dà **ZERO occorrenze** (verificato il 25/08/2026). Occupati e messi in
`$MagicVietati`: **760xxx** (R103, che sono **proprio le tre BreakingBand di
questo round**), **761xxx** (R107), **762xxx** (R108, il round gemello),
**763xxx** (R110), **7744xx** (R109), più tutte le sedie vive.

| simbolo | cella | file prova | `InpPatternMode` | base | gemelle INTERA | singola | gemelle IS | gemelle OOS |
|---|---|---|:--:|---:|---|---|---|---|
| GBPUSD | `00_metroH1` | `R111_GBPUSD_00_metroH1.txt` | **2** | 764000 | 764000/764001 | 764002 | — | — |
| GBPUSD | `01_m30` | `R111_GBPUSD_01_m30.txt` | **2** | 764010 | 764010/764011 | 764012 | 764014/764015 | 764016/764017 |
| EURUSD | `00_metroH1` | `R111_EURUSD_00_metroH1.txt` | **0** | 764020 | 764020/764021 | 764022 | — | — |
| EURUSD | `01_m30` | `R111_EURUSD_01_m30.txt` | **0** | 764030 | 764030/764031 | 764032 | 764034/764035 | 764036/764037 |
| AUDUSD | `00_metroH1` | `R111_AUDUSD_00_metroH1.txt` | **1** | 764040 | 764040/764041 | 764042 | — | — |
| AUDUSD | `01_m30` | `R111_AUDUSD_01_m30.txt` | **1** | 764050 | 764050/764051 | 764052 | 764054/764055 | 764056/764057 |

📌 **Perché un magic diverso per ogni lancio** (pattern R103): l'EA scrive un
file per-trade `abtg_trades_<EA>_<Simbolo>_<magic>.csv` in `Common\Files`, e
`FILE_WRITE` **tronca**. Con lo stesso magic su tre lanci resterebbe solo
l'ultimo, e nessuno saprebbe di quale finestra è.

**Rischio: `InpRiskPercent=1.0`** in tutti e sei i file — è la **taglia viva** di
R103, ed è il denominatore della normalizzazione. ⚠️ **In campo sul 100k le sedie
girano allo 0,65%**: ogni DD di questo referto va **moltiplicato per 0,65** prima
di confrontarlo col forward.

---

## 3. 🚨 IL **CANCELLO ZERO (S0)** — il costo, e si legge PRIMA di qualunque PF

Identico a R108 nella meccanica; **cambia l'attesa**, e va detta prima.

### 3.1 A M30 il cancello è **meno probabile che morda**, e questo è un rilievo, non un permesso

Il TP del motore è **la mediana delle bande** (`InpTPMode=0`). La semi-ampiezza
di BB(20,2) scala **circa con √(rapporto di TF)**: 2 barre M30 = 1 barra H1 →
**√2 ≈ 1,41**, cioè a M30 il bersaglio è **circa il 71%** di quello a H1 (a M15
era circa la metà). **Lo spread resta lo stesso.**
[INFERITO dall'aritmetica, **NON MISURATO**]

📌 **E c'è un dato vero che dice quanto sia sottile il margine anche a H1**:
`report/DIARIO.md`, pagella del **2026-08-20**, riga verbatim:

> _"`BB GBPUSD INV S` **`tp`** ma con un bersaglio da **2,5 pip** raggiunto in
> 10 ore, prima comparsa in pagella."_

👉 A M15 il take mediano lordo misurato da R108 su GBPUSD è uscito **5,4× lo
spread**: **S0a passava**. Quindi a M30, con bersagli **più grandi** che a M15,
**l'attesa dichiarata è che S0a passi**. ⚠️ **E questo NON è una buona notizia
mascherata da cancello verde**: vuol dire che **S0 non è più il cancello che
decide il round** — a decidere sarà **G2/G3**, cioè l'edge. Chi legge il referto
e vede `S0a SUPERATO` non ha letto niente sul merito.

### 3.2 ⚠️ E il backtest da solo non risponde sul costo

- a **modello 1 (OHLC M1)** l'`.ini` scrive `Spread=0` = **spread CORRENTE del
  feed**: **un solo numero applicato a tutta la storia**. È una fotografia, non
  lo spread storico;
- a **modello 4 (tick reali)** il bid/ask arriva dai tick — **se i tick reali ci
  sono davvero** (§ 4.3);
- **in nessuno dei due c'è slippage**, e in nessuno dei due c'è l'allargamento
  notturno o da news.

### 3.3 Le quattro misure del PASSO 0 — **definite ORA, prima dei numeri**

Tutte lette dalla tabella **Deal del report `.htm`** della passata SINGOLA,
accoppiando i deal `in` → `out`. Con `InpMaxPositions=1` e `InpTPMode=0` la
sequenza **deve** essere alternata; **se non lo è, la misura si dichiara NON
MISURATA e non si stima** — è successo su EURUSD in R108, ed è un `if` nel
codice, non una frase.

**S0a — IL TAKE. 🔴 CANCELLO, per simbolo.**

- `take_netto_pip` = `|prezzo_out − prezzo_in| / 0,0001` sulle **VINCENTI**
  (netto = Profitto + Commissioni + Swap > 0). 📌 **È già AL NETTO dello
  spread**: per un long l'ingresso è all'**ask** e l'uscita al **bid**;
- `take_lordo_pip` = `take_netto_pip + spread_dichiarato`;
- **CONDIZIONE**: **mediana** di `take_lordo_pip` **≥ 3 × spread_dichiarato**.
  **MEDIANA e non media**: una manciata di trade lunghissimi alzerebbe la media
  e nasconderebbe che il grosso sta sotto il costo;
- **tre stati**: `SUPERATO`, `FALLITO`, e **`SOSPESO`** quando il rapporto cade
  dentro **3,0 ± 0,5×** — perché la soglia poggia su uno **spread non misurato**
  (D4), e dare un verdetto secco dentro l'incertezza del proprio metro è il modo
  più elegante di sbagliare;
- fallisce → **quel simbolo si chiude qui**, **gli altri due proseguono** (D5).

**S0b — LA FREQUENZA.** `n` sulla finestra INTERA e per finestra IS/OOS.
🆕 **L'attesa di R111 NON è una stima a tavolino: è un'INTERPOLAZIONE FRA DUE
PUNTI MISURATI** (H1 da R103, M15 da R108), media geometrica dei due tassi
annui — ed è comunque **[INFERITA]**:

| simbolo | H1 misurato | M15 misurato | **attesa M30 [INFERITA]** | su 8 anni | per finestra (4 anni) |
|---|---|---|---|---:|---:|
| GBPUSD | 126 / 6,5 anni = **19,4/anno** | 227 / 4 anni = **56,8/anno** | ~**33/anno** | ~**265** | ~**133** |
| EURUSD | 59 / 6,5 anni = **9,1/anno** | 87 / 4 anni = **21,8/anno** | ~**14/anno** | ~**113** | ~**56** |
| AUDUSD | 64 / 6,5 anni = **9,9/anno** | 118 / 4 anni = **29,5/anno** | ~**17/anno** | ~**136** | ~**68** |

🟡 **E la conseguenza va guardata in faccia PRIMA di girare** (§ 7): con queste
attese **nessuna finestra IS/OOS arriva a 150**, e **solo GBPUSD** ha una
speranza di superare i 150 **sulla finestra INTERA**. Il round nasce quindi con
il **MERITO PIENO** giudicabile **su un simbolo solo**. Non è un difetto
nascosto: è **il costo dichiarato** di misurare un TF alto su un motore a bassa
frequenza, ed è **esattamente la situazione di R108** (n=227 su GBPUSD, 87 e 118
sugli altri due) — dove il verdetto è stato leggibile lo stesso perché **le sei
finestre erano concordi**.

**S0c — LA DURATA.** Media e mediana in **barre M30** (`(ora_out − ora_in) /
1800 s`). **Non è un cancello: è una misura a referto.** Se la mediana esce
**1-3 barre**, va scritto come **segnale di allarme sulla robustezza anche a
cancelli verdi**: `arXiv 2605.04004` §6.2 misura che i soli segnali intraday
sopravvissuti alla sua falsificazione tengono **12-15 barre**, non 1-6.

**S0d — LA PRIMA OPERAZIONE VERA.** Vedi § 4.2: **obbligatoria**, e si legge
**prima** dei numeri.

---

## 4. 📅 LE FINESTRE — e **il ponte di lettura** che vale mezzo round

### 4.1 🌉 IL PONTE: **l'OOS di R111 È la finestra intera di R108**

Questa non è una coincidenza, è **una scelta**, ed è la ragione per cui la
finestra M30 finisce dove finisce:

```
R108  M15                     |========== 2022.07 -> 2026.06 ==========|
R111  M30   |===== IS 2018.07 -> 2022.06 =====|===== OOS 2022.07 -> 2026.06 =====|
```

👉 **La finestra OOS di R111 e la finestra INTERA di R108 sono LA STESSA EPOCA,
sugli STESSI tre simboli, con lo STESSO motore e lo STESSO modello (tick
reali).** Fra le due cambia **una cosa sola: il timeframe.**

🎯 **È il confronto più pulito che questo round può produrre**, e va letto
**esplicitamente nel referto, simbolo per simbolo**:

| | R108 M15 (INTERA) | R111 M30 (OOS) | lettura |
|---|---|---|---|
| GBPUSD | PF 0,823 · n 227 | *(da misurare)* | |
| EURUSD | PF 0,637 · n 87 | *(da misurare)* | |
| AUDUSD | PF 0,865 · n 118 | *(da misurare)* | |

⚠️ **E il caveat, dichiarato prima**: l'OOS di R111 **non è "out of sample" nel
senso pieno** rispetto a R108 — è un'epoca che **abbiamo già guardato**, su un
altro TF. Rispetto ai **parametri**, che non tocchiamo, resta OOS; rispetto alla
**nostra conoscenza dell'epoca**, no. **Si dichiara, non si nasconde.**

### 4.2 🚩 `@DAQUANDO 2018.07.01` è **DERIVATO, NON MISURATO** — e stavolta siamo **AL LIMITE**

Il tetto MT5 delle 100.000 barre è a verbale (`CODA_PROSSIMA_SESSIONE.md` riga
21: *"su M15 vale 4,0 anni"*). Aritmetica per M30: forex ≈ **240 barre M30 a
settimana** → 100.000 / 240 = **416,7 settimane = 8,0 anni**.

🔴 **La finestra proposta 2018.07.01 → 2026.06.30 è ESATTAMENTE 8,0 anni: siamo
AL LIMITE del tetto, non sotto.** In R108 il margine c'era (4,0 anni chiesti su
4,0 di tetto, e la finestra è uscita **PIENA**); qui non c'è margine.

👉 **Conseguenza operativa, e non si assume niente:**

1. il driver scrive `[Charts] MaxBars=2000000000` nei suoi `.ini` — **[INFERITO]
   che il tester lo onori, NON misurato**;
2. **il PASSO 0 DICHIARA LA DATA DELLA PRIMA OPERAZIONE VERA, cella per cella**,
   letta dal report `.htm`. Soglia dichiarata ora: **prima operazione entro 6
   mesi** dall'inizio → `FINESTRA PIENA`; oltre → `FINESTRA ACCORCIATA`, e va nei
   **PROBLEMI**, e la finestra reale va **riscritta nel referto PRIMA di leggere
   qualunque numero**;
3. ⚠️ **Se la finestra esce ACCORCIATA, la divisione IS/OOS 4+4 non è più 4+4** e
   il referto deve dirlo prima delle tabelle. È il rischio n.1 di questo round
   sul piano della finestra, ed è **dichiarato prima**;
4. sul **metro H1** la prova del nove è gratis: R103 **e** R108 hanno già
   misurato la prima operazione (**2020.01.14 / 2020.02.03 / 2020.02.05**). Se il
   metro non ridà quelle date, **il banco è cambiato**.

### 4.3 🎫 LA PROFONDITÀ DEI **TICK** — ancora **NON MISURATA**, e stavolta su 8 anni

Cercato di nuovo il 25/08 in `risultati_archivio/misura_tick/`: **esiste un solo
referto, ed è `U30USD`**. Per GBPUSD, EURUSD e AUDUSD **non esiste nessuna
misura della profondità a TICK** in tutto il repo.

🔴 A **modello 4** senza tick reali MT5 **non si ferma**: ripiega e produce
**numeri plausibili e falsi**, e **nessuna guardia del driver può accorgersene**
(checklist **28-bis**, il verde per assenza). ⚠️ **E qui il rischio è più grande
che in R108**, perché la finestra è il **doppio**: se i tick reali di BCM
partono, poniamo, dal 2020, la metà IS di questo round girerebbe su un ripiego
**senza dirlo**.

➡️ **È la decisione D2 (§ 11).** Il driver cerca al pin
`risultati_archivio/misura_tick/misura_tick_<SIMBOLO>.csv`; se **non** c'è,
stampa un **RILIEVO obbligatorio** per simbolo e **non lo nasconde**. E il PASSO
0 offre un **controllo indiretto gratis**: se la **prima operazione** cade molto
dopo il 2018.07.01 su tutti e tre i simboli, il sospetto n.1 è proprio questo.

### 4.4 La divisione IS / OOS della cella M30

**Proposta (D3): 4 anni + 4 anni** — **IS `2018.07.01 → 2022.06.30`** ·
**OOS `2022.07.01 → 2026.06.30`**.

E si dichiara **quale REGIME contiene ciascuna** (Emendamento regola **A**):

- **IS 2018-2022** — fine ciclo pre-Covid, **il crollo di marzo 2020**, i tassi a
  zero, il dollaro debole 2020-21. **Contiene un evento di coda vero**;
- **OOS 2022-2026** — il ciclo di rialzo dei tassi, il 2023 laterale-rialzista
  del dollaro, la direzionalità del 2025.

🟢 **E questo è un miglioramento sostanziale su R108**, dove entrambe le finestre
stavano dentro la stessa epoca dei tassi: qui **le due metà sono due mondi
diversi**, che è quello che l'Emendamento regola **C** chiede.
[Descrizione **qualitativa e [INCERTA]**: questo round **non misura i
sotto-periodi** e non lo pretende.]

⚠️ **Costo dichiarato**: questi CSV IS/OOS **non sono confrontabili** né con il
40/60 degli altri round **né con il 2+2 di R108**. Chi li mette nella stessa
tabella confronta tre cose diverse.

### 4.5 🚫 Niente **M20**, niente **M10**, niente **M5**

Non esistono in R111, e non per pigrizia: § 8 dichiara **prima** che un M30
rosso **chiude il capitolo**. Un TF intermedio in più sarebbe **pesca**.

---

## 5. 🚧 I CANCELLI

### G0 · **RIPRODUZIONE DEL METRO** — 🔴 **FATALE, per simbolo**

La cella `00_metroH1` deve **riprodurre** i numeri di R103 (§ 0). Tolleranze, le
stesse di R101/R107/R108 — che con quelle hanno riprodotto **tre** metri:

| grandezza | tolleranza |
|---|---|
| PF | **± 0,01** |
| DD equity % | **± 0,10 punti** |
| n operazioni | **ESATTO** |
| prima operazione | **ESATTA** |

Se non riproduce → **quel simbolo si ferma** e la sua cella M30 **non viene
nemmeno lanciata**. **Gli altri simboli proseguono.**

⚠️ **Il metro gira a MODELLO 1 (OHLC M1)** — decisione **D1**. Un metro a tick
reali **non riprodurrebbe mai** quel numero e **boccerebbe un banco sano**.

🟢 **G0 include l'IGIENE DEI GEMELLI**: le due passate identiche (magic `B` e
`B+1`) devono dare **lo stesso numero al centesimo** su profitto, PF, DD e n. **E
si pretende che siano DUE righe**: *"una riga sola"* non è *"gemelli ok"*, è uno
sweep che non ha spazzolato (checklist 55).

### S0 · **CANCELLO ZERO SUL COSTO** — 🔴 **FATALE, per simbolo**

Definito al § 3.3. **Si legge PRIMA di qualunque PF.** Con l'avvertenza del
§ 3.1: a M30 **l'attesa è che passi**, e un `SUPERATO` **non dice niente sul
merito**.

### G1 · **MISURABILITÀ** (Emendamento regola A)

- `n` per finestra **≥ 150** → il **MERITO** si giudica;
- `n` per finestra **< 150** → **MERITO SOSPESO**, e il **RISCHIO si legge lo
  stesso, a qualunque n** (regola **B**). È un **RILIEVO**, cioè un **risultato
  del round**, non un guasto;
- `n` per finestra **< 20** → **NON MISURABILE**, mai *"non funziona"*.

📌 **E si applica anche alla finestra INTERA**, che con 8 anni è l'unica che può
arrivare a 150 (§ 3.3, S0b).

### G2 · **MERITO** (solo se S0 e G1 sono verdi)

- **S1** positivo in **ENTRAMBE** le finestre (IS **e** OOS);
- **S2** **PF OOS ≥ 1,10**;
- **S3** **DD OOS < 10%** a rischio 1%.

Sono i cancelli congelati nella tesi del motore il 12/08
(`BREAKING_BAND_TESI.md`, *CRITERI DI PROMOZIONE*), **non inventati oggi**.

### G3 · **COERENZA CROSS-SIMBOLO** — 🔴 il cancello che protegge dal rumore

**Un simbolo su tre non fa un edge.** Non è meccanizzabile nel driver: è un
ragionamento su **tre** tabelle, e lo applica **il referto del round, a mano**.
⚠️ **E in R111 pesa il doppio**, perché con le attese di S0b **il MERITO PIENO
esiste su un simbolo solo**: se GBPUSD uscisse verde e gli altri due grigi (merito
sospeso), **quello NON è un edge dimostrato** — è **un simbolo**, ed è la
situazione che § 8 chiama **esito misto**.

### G4 · **PEGGIOR GIORNATA** — misurata **sempre**, anche se favorevole

> 🫥 **CHECKLIST 80, e la colonna NON è stata ereditata dal gemello.** Il punto
> 80 (nato verificando R110) dice che una colonna presa dal round gemello può
> essere **strutturalmente impossibile** per la famiglia nuova, e che il `n/d`
> onesto la **camuffa**. Quindi è stata **riverificata nel sorgente di questo
> EA**, il 25/08: `ABTG_BreakingBand.mq5` riga **1591** dichiara
> `double stats[10]` e riga **1625** scrive un OPTFRAME a **11 colonne** che
> contiene `Peggior Giornata %`. ✅ **La colonna esiste**, quindi qui un `n/d`
> vuol dire *"stavolta non è uscita"* e **non** *"non può uscire"* — ed è
> proprio la distinzione che il punto 80 impone di dichiarare **prima**.

Muro prop giornaliero: **−5% su 100k**. La nostra peggiore misurata (R51) è
**−2,06%**; R108 a M15 ha misurato max **−2,03%**. Il referto stampa **quattro
viste**: `htm-INTERA` (con la data), `csv-INTERA`, `csv-IS`, `csv-OOS`.
👉 **Il rischio non si sospende mai** (regola **B**): un DD e una giornata si
leggono **a qualunque `n`**, anche quando il MERITO è sospeso.

### G5 · **NESSUNA PROMOZIONE ESCE DA QUESTO ROUND**

R111 produce **misure**. Nessuna sedia nuova, nessun cambio al forward, nessuna
taglia. Un deploy è **una firma separata, con il suo referto**. E `FLOTTA_ATTIVA`
ha già **tre BreakingBand vive** su questi stessi simboli a H1: una versione M30
non entrerebbe *"in più"*, entrerebbe **accanto o al posto** — decisione di
portafoglio, non risultato di backtest.

---

## 6. 🚫 COSA NON SI SPAZZOLA — e perché

**Zero.** L'unico flag `Y` è `InpMagic`, e il driver **si ferma** se in un file
ne trova un secondo.

In particolare restano **SPENTE** le due valvole che imporrebbero un take minimo
— `InpMinTPatATR = 0.0` e `InpMinRR = 0.0`:

> ⚠️ **accenderle dentro il round che MISURA il take vorrebbe dire misurare il
> filtro invece del motore.** Se S0a fallisce, la variante *"con valvola
> accesa"* è **un round NUOVO, con criteri nuovi** — non un salvataggio di
> questo.

---

## 7. ⚖️ L'EMENDAMENTO DELLA FINESTRA, applicato a questo round

- **regola A** — l'unità di misura è l'**operazione**, non l'anno. R111 la
  applica **due volte**: la finestra M30 è di **8 anni** proprio per dare alla
  cella INTERA una possibilità di arrivare a **150**, e ogni finestra dichiara
  **quale REGIME contiene** (§ 4.4). ⚠️ **E si dichiara PRIMA che le attese
  [INFERITE] dicono che IS e OOS ci arriveranno probabilmente NO** (§ 3.3);
- **regola B** — **il vecchio giudica il RISCHIO, il recente il MERITO**: nessun
  simbolo viene bocciato perché *"nel 2019 non guadagnava"*; ma **un DD del 25%
  nel marzo 2020 sarebbe un fatto accaduto** e si legge a qualunque `n`. 📌 **La
  finestra IS contiene il crollo Covid apposta**;
- **regola C** — la **prova di regime** batte la storia contigua: R111 **non la
  fa** (quattro finestre = un altro round) e **lo dichiara**. Il 4+4 del § 4.4 è
  il massimo che si può fare senza cambiare macchina;
- **regola D** — il limite in basso: **otto anni** su M30 sono **molto più** di
  quello che gira oggi in casa (110 file prova su 153 girano su 21 mesi).

---

## 8. 🧭 LA **LETTURA PRE-DICHIARATA DEL CONFINE** — scritta PRIMA dei numeri

🔒 **Questa è la sezione che rende R111 una misura e non una pesca. Si scrive
adesso, e non si tocca dopo.**

### Esito **A** · 🟢 M30 **VERDE su almeno DUE simboli su tre**, con G3 coerente

*(verde = G2 pieno: positivo in IS **e** OOS, PF OOS ≥ 1,10, DD OOS < 10%)*

**Lettura**: **il confine sta fra M30 e M15.** Il motore regge fino a mezz'ora e
si rompe sotto. È un **risultato positivo**, e apre **una porta sola**:

➡️ **un ROUND DI VALIDAZIONE nuovo**, con criteri nuovi, che deve rispondere a
quello che R111 **non** può rispondere: prova di regime (quattro finestre), spread
**misurato** col RealCost P95 Logger, profondità tick **misurata**, e il posto di
una BB-M30 accanto a tre BB-H1 già in campo sugli stessi simboli.

🔴 **E NON è una promozione (G5).** «Verde in R111» ≠ «sedia». La distanza fra le
due cose è **un altro round e una firma separata**.

### Esito **B** · 🔴 M30 **ROSSO ovunque** (0 simboli su 3 passano G2)

**Lettura**: **il confine sta fra H1 e M30.** Il Breaking Band vive **solo** al TF
su cui è stato costruito, e la riga della tesi *"operatività M5/M15"*
(`BREAKING_BAND_TESI.md`, riga 17) è **MISURATA E FALSA** su tutta la discesa,
non solo su M15.

➡️ **IL CAPITOLO "ABBASSO IL TF DEL BREAKING BAND" SI CHIUDE.**
**Niente M20. Niente M10. Niente M5. Nessun ripescaggio. Nessuna nuova griglia
sul motore a TF basso** — quella sarebbe **pesca**, ed è la clausola della
Seconda Caccia.

➡️ E **la conseguenza per la challenge** si scrive con un numero: la frequenza
forex intraday **non verrà da questa famiglia**, e la caccia M5/M15 va spesa
altrove (indici, oro), come già indicato dal referto R108.

### Esito **C** · 🟡 **MISTO** — un simbolo verde, gli altri no

**Lettura**: **si legge per simbolo, con G3 in mano, e G3 dice NO.**
**Un simbolo su tre non è un edge: è rumore**, finché qualcuno non dimostra il
contrario — ed è il cancello che in R46 fermò un candidato che faceva **+31%**.

➡️ Il capitolo **non si chiude e non si apre**: resta **UNA RIGA A REGISTRO** con
il numero, e **nessun round nuovo parte** senza che qualcuno porti **una ragione
misurata** per cui quel simbolo dovrebbe comportarsi diversamente dagli altri
due. **La curiosità non è una ragione misurata.**

### Esito **D** · ⚪ **NON MISURABILE** — attese di frequenza mancate, o finestra ACCORCIATA

Se `n` esce **sotto 20 per finestra**, o se il PASSO 0 dichiara **FINESTRA
ACCORCIATA** su tutti e tre i simboli (§ 4.2), **nessuno dei tre esiti sopra si
applica**: il round ha misurato **il tetto delle barre o i tick**, non il motore.

➡️ Si scrive **NON MISURABILE** e si dice **che cosa** andrebbe misurato prima
(profondità tick, § 4.3). ⚠️ **`NON MISURABILE` non è `NO`**, e non chiude
nessun capitolo.

> ### 🧨 LA REGOLA CHE VALE PIÙ DI TUTTE E QUATTRO
> **L'esito si assegna leggendo il referto CONTRO questa tabella, non
> raccontando i numeri.** Se qualcuno, a numeri visti, propone una quinta
> lettura che non è qui dentro, **quella lettura va scritta e firmata PRIMA di
> essere usata** — e a quel punto non è più una lettura di R111: è un round
> nuovo.

---

## 9. 🗓️ IL GATE DELLE DATE — la lezione **79**, tradotta in codice

Il 25/08 un giro a vuoto è uscito **`ESITO: OK`, codice 0**, con dentro un `.ini`
che diceva:

```
ToDate=InpUsaGuardian=true||true||0||true||N InpPivotLeft=5||5||0||5||N ...
```

Causa: le variabili di PowerShell sono **case-insensitive**, `$A` della
configurazione era stato distrutto da un `$a` di comodo del gate della stella, e
**nessuna fabbrica di `.ini` controllava le DATE** — cioè metà di quello che un
backtest misura. Trovato da **Claudio**, aprendo un `.ini` dello zip.

➡️ **In R111 è impedito da quattro cose, tutte nel codice:**

1. **nomi lunghi**: le date si chiamano `$MetroDataDa`, `$M30DataDa`,
   `$M30IS_DataDa`, … e i parametri delle fabbriche `$DataDa`/`$DataA`. **Nessuna
   variabile di configurazione ha un nome di una o due lettere**;
2. **l'ArrayList del referto si chiama `$RefTxt`**, non `$R` — la mina `$R`/`$r`
   che in R103/R107/R108 era **disinnescata per ordine delle righe** (checklist
   79) qui **non esiste proprio**;
3. **`GateDate` sugli ARGOMENTI**, in **entrambe** le fabbriche: forma
   `^\d{4}\.\d{2}\.\d{2}$`, **giorno che esiste davvero** (`TryParseExact`), e
   **`ToDate` > `FromDate`**;
4. **`GateDateIni` sull'ARTEFATTO**: `FromDate` e `ToDate` **riletti dal testo
   dell'`.ini` prodotto**, non dalla variabile che l'ha prodotto. E **il giro a
   vuoto li rilegge e li stampa**.

📌 **La lezione di metodo, che vale più del difetto**: provare una funzione
chiamandola da un test dimostra che **la funzione** è giusta, **non** che riceve
**gli argomenti** giusti.

### 9.1 🎲 E IL SECONDO DIFETTO DI FAMIGLIA: `Sort-Object` **NON È STABILE** (checklist 81)

Arrivato **mentre R111 si costruiva**, e morde questo driver **in pieno**, perché
il parser dei deal è copiato dal gemello R108, che aveva:

```powershell
$ordinati = @($deal | Sort-Object Ora)
```

Un gesto **difensivo** che introduce il difetto che vuole evitare: sulle chiavi
**uguali** `Sort-Object` dà un ordine **arbitrario**, e `-Stable` esiste solo da
PowerShell 7 (sul PC di Claudio c'è **Windows PowerShell 5.1**). Su dati di
mercato **i pari al secondo sono la regola**: basta una posizione chiusa e la
successiva aperta dentro lo stesso secondo. Ogni gruppo invertito trasforma una
coppia `in`/`out` perfetta in `out`/`in`.

🔴 **MISURATO nella corsa vera di R109: 34 false anomalie e 16 operazioni perse**
— e il driver **accusava l'EA**, l'unico pezzo innocente della catena.

⚠️ **E il sospetto su R108 è aritmetico, non retorico.** Il suo referto registra
*"EURUSD M15: **2 deal non accoppiati**"*. Un gruppo invertito = **2 anomalie e 1
operazione persa**. Non è dimostrato qui, ma **è esattamente il numero che questo
difetto produce**, e va scritto perché nel referto R108 quell'anomalia è a
registro come *"da capire"*.

➡️ **In R111 è impedito così, e ogni pezzo è stato ESEGUITO:**

1. **non si ordina**: si usa **l'ordine della fonte** (i deal dell'`.htm` sono in
   ordine di **ticket**, che è cronologico e non ha pari);
2. **"arriva ordinato" è un'assunzione, e si MISURA**: il driver conta i **salti
   all'indietro** e i **gruppi a pari secondo**, e li **stampa nel referto**
   (`ordinamento dei deal (checklist 81): ...`). Il conteggio dei gruppi a pari è
   proprio il numero che a R109 è servito per la diagnosi;
3. **se la fonte NON è monotona**, si riordina **solo** con una **chiave di
   spareggio univoca** — il numero d'**AFFARE**, che il parser ora **legge e
   conserva apposta** (in R109 lo scartava: per questo la scorciatoia non era
   disponibile) — e **lo si dichiara**;
4. **se lo spareggio non c'è**, si scrive **NON MISURATO** e **non si stima**;
5. gli **altri** `Sort-Object` del file sono stati riesaminati uno per uno:
   `TrovaReport` ha ora uno **spareggio sul `FullName`** (due file scritti nello
   stesso istante darebbero un vincitore arbitrario); `Mediana` e
   `Sort-Object -Unique` sono **dichiarati legittimi**, perché nel primo la
   chiave **è** l'elemento (i pari sono indistinguibili) e nel secondo i pari
   **vengono deduplicati**;
6. **quando la guardia scatta, il driver NON accusa l'EA** (lezione **81-bis**):
   il messaggio porta con sé la misura dell'ordinamento e manda a confrontare i
   **tre testimoni indipendenti** — CSV OPTFRAME, deal `out` dell'`.htm`,
   per-trade dell'EA. *"Chi ha toccato il dato PRIMA della guardia?"* viene prima
   di *"la guardia è troppo severa?"*.

🧪 **E la batteria è stata scritta con i PARI COSTRUITI APPOSTA**, perché una
batteria a chiavi tutte distinte **non può vedere questo difetto** — è
esattamente perché il report finto di R108 aveva orari tutti diversi che il
difetto è passato. Compresa la **controprova**: sullo stesso input, il codice
vecchio inventa **fino a 4 anomalie e scende a n=2** contro un `n` vero di **4**.

---

## 10. ⚙️ ESECUZIONE

- **Driver**: `righe/RIGA_R111_BB_M30.ps1`, marcatore `MARCATORE_RIGA_R111_v1`.
- **`-SoloControllo`** (giro a vuoto): **non apre MT5**. Verifica gli
  **artefatti** — file prova, stella, **due** antenati, valori, magic, `.ini`
  (date comprese) — e **compila**. ⚠️ **Non misura NESSUN numero**: nessun `n`,
  nessun PF, nessun G0, **nessun S0**.
- **MT5 e MetaEditor chiusi**, o la riga si rifiuta di partire.
- **`[Experts] AllowLiveTrading=false`** in ogni `.ini`: aprire MT5 per misurare
  **riarma la flotta** sul conto vivo (checklist 51).
- **Una macchina, un lavoro.** ⚠️ **R109 sta girando stanotte sul PC di
  backtest**: R111 parte **solo** quando quel round ha finito e nessun altro
  tocca il terminale.
- **Il round non scarica storico** e **non tocca `bases\<server>\ticks`**.
- ⏱️ **Durata [STIMA, non una previsione], e stavolta poggia su un MISURATO**:
  R108 ha fatto **30 passate, di cui 18 a tick reali su 4 anni di M15, in 24
  minuti** (corsa vera del 25/08, agli atti). R111 fa **le stesse 30 passate**,
  con le **stesse 12 passate metro in OHLC** e **18 a tick reali su 8 anni di
  M30**. Le **barre** sono circa le stesse (~100.000 in entrambi i casi: è lo
  stesso tetto); i **tick** sono circa il **doppio**, perché la finestra è il
  doppio. ➡️ **Stima: 40-60 minuti.** `-OreMax 12` è un tetto sull'**inizio** di
  nuovi lavori, non un'accetta su un lavoro in corso.

---

## 11. ✍️ LE SETTE DECISIONI — **PRE-FIRMATE CON PROPOSTE**

> 🖊️ **Stato: PRE-FIRMATE.** La pre-firma di Claudio (*"FIRMO R111"*, 25/08) è
> sul **perimetro**; queste sette proposte sono scritte **prima dei numeri** e
> **restano smentibili da Claudio finché la corsa non parte**. Il file conserva
> `[DA FIRMARE]` **apposta**, così la corsa vera pretende `-CriteriFirmati` e la
> firma **finisce scritta nel referto** (§ 🧷).

| | decisione | ✅ PROPOSTA | ❌ alternativa scartata, e perché |
|---|---|---|---|
| **D1** | Il **metro G0** gira a **modello 1 (OHLC M1)**, come R103 e come R108 | **SÌ.** È l'unico modello che può riprodurre quel numero, e in R108 ha fatto **G0 3/3 al centesimo** | *metro a tick reali*: non riprodurrebbe **mai** R103 e **boccerebbe un banco sano**. Un metro misura il **banco**, non il modello |
| **D2** | La **profondità dei TICK** su GBPUSD/EURUSD/AUDUSD **non è misurata** (§ 4.3), e qui la finestra è **il doppio** di R108 | **SI GIRA E SI DICHIARA**, con il **RILIEVO obbligatorio per simbolo** stampato dal codice — **come R108**, dove la riserva non ha cambiato un verdetto rosso e concorde. ⚠️ **Ma se l'esito è A (verde), la riserva DIVENTA bloccante**: § 8 esito A manda i tick **fra le cose da misurare prima** del round di validazione | *misurarla prima*: è la strada giusta e costa mezz'ora, **ma è un altro lavoro** e fermerebbe R111 dietro a R109 già in coda. ⚠️ **La riserva ammorbidisce un SÌ, non un NO**: è per questo che si può girare — un NO su sei finestre concordi non cambia con tick migliori, un SÌ sì |
| **D3** | La **finestra M30** e la sua divisione | **`2018.07.01 → 2026.06.30`, IS/OOS 4+4.** Otto anni per dare alla cella INTERA una chance dei 150 (regola A); 4+4 per avere **due regimi diversi** (regola C) e per far **coincidere l'OOS con la finestra intera di R108** (§ 4.1, il ponte) | *2+2 come R108*: darebbe due finestre dentro **la stessa epoca** e **nessun ponte**. *40/60 come gli altri round*: IS di 3,2 anni, e comunque nessuna delle due a 150. ⚠️ **Costo dichiarato**: questi CSV **non sono confrontabili** né col 40/60 né col 2+2 |
| **D4** | Lo **spread di riferimento** di S0a | **1,5 pip** su tutti e tre, **`[SPREAD NON MISURATO]`** stampato accanto a **ogni** verdetto. **Stesso valore di R108**, così i due round si leggono con lo stesso metro | *misurarlo prima col RealCost Spread P95 Logger* (Code Base 74148, promosso il 23/08 e **mai usato**): strada giusta, **altro lavoro**. ⚠️ **Cambiare il valore fra R108 e R111 renderebbe i due S0a incomparabili**, e il confronto M15↔M30 è metà del round |
| **D5** | Cosa succede se **S0 o G0 falliscono su UN simbolo solo** | **Quel simbolo si chiude, gli altri proseguono** (stessa scelta di R100/R101/R107/R108) | *fermare tutto*: butterebbe ore di macchina già spese e trasformerebbe **tre risposte in zero** |
| **D6** | 🔴 **LA LETTURA DEL CONFINE si dichiara PRIMA** (§ 8): quattro esiti, quattro letture, scritte prima di girare | **SÌ**, ed è **la decisione che rende R111 una misura**. In particolare: **M30 rosso ovunque → il capitolo della discesa di TF si CHIUDE** (niente M20/M10/M5, nessun ripescaggio, nessuna nuova griglia) | *leggere i numeri e poi decidere che cosa vogliono dire*: è **esattamente** come si fa curve-fitting sulla NARRATIVA invece che sui parametri. Un round senza lettura pre-dichiarata **non può produrre un NO**, perché ci sarà sempre un motivo per riprovare |
| **D7** | Cosa succede se l'esito è **A (verde)** | **NON è una promozione** (G5). È **un round di VALIDAZIONE nuovo**, con criteri nuovi: prova di regime, **spread misurato**, **tick misurati**, e il posto della sedia dentro un portafoglio che ha già **tre BB H1 sugli stessi simboli** | *promuovere una BB-M30 sulla forza di R111*: sarebbe un deploy su **un backtest**, senza prova di regime e con la **riserva D2 aperta**. E la concentrazione sui tre stessi simboli non è un dettaglio di portafoglio |

### 11.1 🟢 Cosa **non** serve firmare, e perché

- **i sei file prova**: sono **copiati riga per riga** dalle celle metro di R108
  (a loro volta copie di R103), e **due gate dell'antenato** lo verificano al pin;
- **le tolleranze di G0**: sono quelle di R101, R107 e R108, che con quelle hanno
  riprodotto **tre** metri;
- **G5** (nessuna promozione): **regola di casa**, non una scelta di round;
- **`InpRiskPercent = 1.0`**: è la **taglia viva** misurata nel censimento `.chr`
  del 23/08, non una scelta.

---

## 12. 🚫 QUELLO CHE R111 **NON** FARÀ, dichiarato prima

1. **Non tocca `ABTG_BreakingBand.mq5`.** Zero righe di MQL5: `InpTF` è già un
   `input` del sorgente (riga 213), è `ENUM_TIMEFRAMES`, e `PERIOD_M30 = 30`. Il
   driver **verifica** che sia ancora un input libero, e si ferma se non lo è.
2. **Non tocca nessuna sedia in forward.** Magic **vergini** `764xxx`; i magic
   vivi e quelli di R103/R107/R108/R109/R110 sono **vietati e controllati nel
   codice**.
3. **Non promuove e non boccia niente** (G5).
4. **Non applica i cancelli G2 e G3**: il driver produce i numeri, i verdetti li
   dà **il referto del round, a mano**, **contro la tabella del § 8**.
5. **Non misura lo spread**, non misura la profondità dei tick, non misura i
   sotto-periodi, non fa la prova di regime, non scarica storico.
6. **Non mescola un OHLC e un tick reale nella stessa tabella.** Lo switch
   `-ScreenOhlcM30` esiste per uno screen veloce, ma **se è acceso il round gira
   SOLO in OHLC**, la cartella e lo zip si chiamano `SCREENOHLC`, **ogni riga M30
   esce marcata `NON GIUDICABILE`**, **nessun verdetto S0a viene dato** e
   **l'uscita è 1** — stampato dal codice, non scritto in una nota (checklist 67).
7. **Non tocca R109, R110 né lo storico indici**, che sono lavori di altri.

---

_Criteri scritti il 25/08/2026, **prima** di qualunque numero, sopra la pre-firma
di Claudio sul perimetro. I criteri si cambiano **prima** dei numeri, mai dopo._
