# 📝 R99 — ORO SU 22 ANNI, LA MISURA DEL RISCHIO CHE NON ABBIAMO — ✅ **FIRMATI il 23/08/2026**

> ## ✍️ FIRMA (23/08/2026, in chat)
> Parole esatte di Claudio: **"FIRMO R99, PARTIAMO CON L'ORO"**.
> Firmati **a numeri di R99 mai visti**, come da regola di casa (i criteri si
> cambiano PRIMA dei numeri, mai dopo).
> Questo documento **promuove a criteri firmati l'header del file prova**
> `backtest_pipeline/prove/R99_ORO_22ANNI_RISCHIO.txt`, scritto il 23/08 dalla
> caccia `report/SWEEP_MECCANISMI_2026-08-23.md` §G1 (punteggio **10/10**,
> "PROVA SUBITO"). **I criteri di accettazione sono riportati alla lettera:
> nessuna virgola cambiata.** Tutto ciò che è stato aggiunto dopo la firma
> (la cella input-per-input, le date delle finestre, i magic, il metodo di
> misura) è **traduzione esecutiva** ed è marcato come tale.

**Oggetto**: `mql5/Experts/ABTG_SupertrendReversal_Ottimizzato.mq5` v1.00 su
**XAUUSD H4**, la cella **viva** — sedia a contratto 🟡 **PARZIALE** in
`report/CONTRATTI_SEDIE.md`.
**Da dove nasce**: `report/SWEEP_MECCANISMI_2026-08-23.md` §G1.
**File prova**: `backtest_pipeline/prove/R99_ORO_22ANNI_RISCHIO.txt`.
**Driver**: `backtest_pipeline/righe/RIGA_R99_ORO_RISCHIO.ps1`.

---

## 0. 🚫 REGOLA ZERO — cosa questo round NON è

- **NON è un round di MERITO.** Emendamento **regola B** (16/08): _"il VECCHIO
  giudica il RISCHIO, il RECENTE giudica il MERITO"_. Qui non si chiede se
  l'oro guadagnava nel 2008: si chiede **quanto avrebbe perso**.
- **NON promuove niente e NON boccia niente per merito.** Il PF di una finestra
  di vent'anni fa **non viene usato** né per promuovere né per bocciare nessuna
  sedia. L'unico esito possibile è: il contratto regge, oppure la sedia va in
  **REVISIONE** sulla corsia **RISCHIO** (firma 18/08).
- **NON è uno sweep.** Una cella sola, congelata, su una finestra nuova. Zero
  parametri di strategia spazzolati. L'unico asse `Y` è `InpMagic`, che è la
  **coppia gemella di controllo**, non una griglia.
- **NON tocca nessuna sedia viva.** Gira su magic **vergini** del blocco
  `7799xx`; il magic vivo (`970901`) e quello della collisione (`770901`) sono
  **vietati e controllati nel codice**.
- **NON è un permesso.** Il numero che esce è un **LIMITE INFERIORE** del
  rischio (vedi §4, modello OHLC).

---

## 1. 🎯 L'IPOTESI (riportata alla lettera dal file prova, scritta PRIMA di qualunque numero)

> Le sedie vive sull'oro hanno un contratto di rischio firmato su una finestra
> corta: R17 (MaxMinNotte oro notte) su ~16 mesi, tutte le altre con
> `@DAQUANDO 2024.09.26` (21 mesi). Quel 2024.09.26 è il **MURO DEI TICK DEGLI
> INDICI**, copiato sull'oro per inerzia.
> La sonda del 17/08 (`REFERTO_SONDA_STORICO_17-08.md`, riga
> "XAUUSD | 2004.06.11 | 22,1 anni") ha **MISURATO** che sull'oro il broker ha
> 22 anni.
> **IPOTESI DA SMONTARE**: che il drawdown promesso dalle celle vive dell'oro
> regga anche sui due eventi che nella nostra finestra NON esistono — il crollo
> dell'**ottobre 2008** e il crollo dell'**aprile 2013**.
> (L'ampiezza esatta di quei due crolli NON la scrivo qui: non l'ho misurata
> sui nostri dati. La misura il round.)
> Se non regge, il DD promesso è sottostimato e la taglia prop dell'oro va
> rivista **PRIMA** di accendere, non dopo.

---

## 2. ⚖️ PERCHÉ È UNA MISURA DI RISCHIO E NON DI MERITO (alla lettera)

> **Emendamento B, 16/08**: _"Il VECCHIO giudica il RISCHIO. Il RECENTE giudica
> il MERITO."_
> Questo file NON chiede se l'oro guadagnava nel 2008. Chiede SOLO quanto
> avrebbe perso. **Un drawdown è un FATTO ACCADUTO e vale a qualunque n**; il PF
> su una finestra di vent'anni fa NON viene usato per promuovere né per bocciare
> nessuna sedia.

---

## 3. 🔒 I CRITERI DI ACCETTAZIONE — **CONGELATI PRIMA DEI NUMERI, riportati alla lettera**

> Questo round non promuove niente. Produce UN numero per cella:
>
> **A.** il **DD massimo dell'equity** su `2004.06.11 → 2026.06.30` **al rischio 1%**
> **B.** la **PEGGIOR GIORNATA in %** (il muro prop giornaliero è 5%)
> **C.** il **DD massimo dentro ciascuna delle quattro finestre di regime**
>
> E **una sola decisione meccanica, dichiarata adesso**:
>
> - ➡️ se il **DD lungo** di una cella supera il **DOPPIO del DD promesso** in
>   `CONTRATTI_SEDIE.md`, quella sedia va in **REVISIONE** (corsia **RISCHIO**
>   del criterio di uscita firmato il 18/08), **senza altre discussioni**.
> - ➡️ se non lo supera, **il contratto resta e ora ha vent'anni sotto**.

**Questi quattro capoversi non si toccano.** Tutto quello che segue è come si
eseguono, non cosa dicono.

### 3.1 🔴 LA TENSIONE MISURATA **DOPO** LA FIRMA — il denominatore non esiste

_Trovata preparando il lancio, il 23/08, leggendo `CONTRATTI_SEDIE.md` invece
di ricordarselo. È la famiglia della **checklist 57**: un criterio firmato che
assegna una misura a uno strumento (qui: a un documento) che non può produrla._

La riga del contratto di questa sedia, **verbatim** da
`report/CONTRATTI_SEDIE.md` (sezione "🟡 CONTRATTO PARZIALE (2)", riga 72):

> `| ABTG_SupertrendReversal_Ottimizzato | XAUUSD | 970901 | 1,0 |` **`PF 2,74
> real-tick c'è, il DD NO: a referto solo "basso", mai quantificato`** `| n/d
> nella promozione | 2024.01→2026.06 nominale, real-tick 26/07 |`
> `backtest_pipeline/CLASSIFICA_PF.md` riga 17 · `REGISTRO_TEST.md` §5 `|` 🟡
> **[PARZIALE] — manca il numero del DD**

**Il DD promesso di questa sedia NON È UN NUMERO.** Quindi la decisione
meccanica del §3 — *"se il DD lungo supera il DOPPIO del DD promesso"* — **non
ha un denominatore**.

Le due uscite sbagliate, ed è facile prenderle entrambe in buona fede:

- ❌ **inventare il denominatore** (prendere il `2,74` che sta nella stessa
  cella: è il **PF**, non il DD) → un verdetto firmato costruito su un numero
  sbagliato;
- ❌ **riaprire il criterio dopo la firma** → esattamente ciò che la regola di
  casa vieta.

> ✅ **LA TRADUZIONE, DICHIARATA (e ripetuta nel driver, nel referto e nel
> documento della riga).**
> 1. **Il criterio non si tocca.** Resta scritto com'è.
> 2. **Il confronto `2x` si esegue MECCANICAMENTE quando il denominatore
>    esiste**, e il driver lo estrae **dall'artefatto** (scarica
>    `CONTRATTI_SEDIE.md` al pin e cerca la riga della sedia), non dalla
>    memoria di chi scrive.
> 3. **Se il denominatore non è un numero — ed è il caso di oggi — il referto
>    stampa `2x NON CALCOLABILE: contratto senza numero`, insieme alla riga
>    grezza del contratto.** ⚠️ **Quel "non calcolabile" NON è un via libera: è
>    esso stesso un rilievo della corsia RISCHIO** — una sedia viva sull'oro
>    senza DD promesso non ha nessun metro, e la C3 del 18/08 su di lei **non
>    può scattare** (lo dice già `CONTRATTI_SEDIE.md` §SINTESI per le sedie
>    senza contratto).
> 4. **Quello che R99 può fare, e che non è una promozione**: i tre numeri che
>    misura sono **candidati a RIEMPIRE il contratto mancante**. Riempirlo è
>    **una firma nuova, di Claudio, in un passo successivo** — non un esito
>    automatico di questo round. R99 lo **propone**, non lo scrive.

⚠️ **E il rischio si legge su due taglie.** La sedia viva è stata misurata a
`InpRiskPercent = 1` nel censimento `.chr` del **18/08 00:01**
(`censimento_rischio_2026-08-18_0001.txt`, riga 38) — cioè **la stessa taglia
che il criterio A pinna**. Ma fino al **17/08 23:34** la stessa sedia girava a
**2,0%** (`REFERTO_CENSIMENTO_RISCHIO.md`, che la elenca in rosso fra le tre al
doppio). Se qualcuno la riportasse a 2%, **tutti i numeri di R99 vanno
raddoppiati** — la scalatura lineare del rischio è la convenzione già dichiarata
in `CONTRATTI_SEDIE.md` §COME LEGGERE I NUMERI, punto 2, ed è
**[APPROSSIMATA]**.

---

## 4. 🧪 CHE MODELLO (riportato alla lettera)

> **OHLC M1**: i tick reali di BCM partono dal 2024.07.05, quindi su 22 anni
> **NON ESISTONO**. È la tensione già scritta in R76: _"o la finestra lunga o il
> riempimento vero, mai tutti e due"_.
> Vale perché la domanda è il **DRAWDOWN di celle H1/H4** (non M5): R57 ha
> misurato che il modello ribalta il SEGNO sull'intraday, non che gonfia o
> sgonfia il DD di una cella swing. E il numero che esce è comunque un **LIMITE
> INFERIORE del rischio, mai un permesso**.

**Traduzione esecutiva**: `Model=1` nell'`.ini` del tester (1 = OHLC su M1). I
CSV di R99 portano il suffisso **`_ohlc`** nel nome, per la regola di casa che
un OHLC non deve nemmeno poter finire nella stessa tabella di un tick reale
(`walkforward_generico.ps1`, riga 607).

---

## 5. 🪟 LA FINESTRA, IL TETTO DELLE BARRE E IL PASSO 0 (alla lettera)

> `@SIMBOLO  XAUUSD` · `@PERIODO  H4` · `@DAQUANDO 2004.06.11`
> **MISURATA, non ipotizzata**: `REFERTO_SONDA_STORICO_17-08.md` sez. 2, CSV
> della sonda `ABTG_InfoBroker` con `InpSondaStorico=true`, 59 simboli su 59
> misurati, 0 date recuperate.
>
> ⚠️ **ATTENZIONE AL TETTO**: la stessa sonda ha misurato **100.000 barre H1**
> in locale sull'oro = il tetto "Max barre nel grafico" di MT5, **NON il limite
> del broker**. R76 ha già verificato che il tetto NON ferma lo Strategy Tester.
> **Se il PASSO 0 misura una prima operazione DOPO il 2006, il tetto ha morso lo
> stesso e la finestra si dichiara accorciata.**
>
> **PASSO 0 OBBLIGATORIO** (prima di leggere qualunque numero):
> 1. data della **PRIMA operazione**: deve cadere entro il **2005.12.31**
> 2. **n totale operazioni**: si scrive, non si commenta
> 3. **cella sonda e cella gemella IDENTICHE al centesimo**

**Data di fine**: `2026.06.30` — è la data scritta nel criterio A (§3) ed è la
stessa fine di finestra di tutta la stagione (R78, R88, R97, R98).

### 5.1 ⚙️ Traduzione esecutiva del PASSO 0 — **gate che dichiara, gate che ferma**

Il criterio dice **"si dichiara accorciata"**, non "ci si ferma". Quindi:

| misura | esito | cosa fa la corsa |
|---|---|---|
| prima operazione **≤ 2005.12.31** | ✅ la finestra è quella dichiarata | prosegue |
| prima operazione **fra il 2006 e il 2009** | 🟡 **FINESTRA ACCORCIATA** | **prosegue**, e il referto la dichiara accorciata **accanto a ogni numero** |
| prima operazione **dopo il 2010.01.01** | 🔴 **FATALE** | **si ferma**: senza il 2008 e senza il 2013 la domanda del round non ha più senso, e i tre numeri descriverebbero un'altra finestra |
| prima operazione **non leggibile** | 🔴 **FATALE** | un gate che non legge niente **non è un gate verde** |

⚠️ La soglia dei **2010** è una **traduzione**, non un criterio firmato: la
firma dice "si dichiara accorciata" e non nomina nessun punto di rottura. È
messa perché i due eventi che l'ipotesi (§1) vuole misurare sono **ottobre 2008**
e **aprile 2013**: una finestra che comincia dopo il 2010 ne perde uno dei due e
non risponde più alla domanda. **Dichiarata qui, non nascosta nel codice.**

### 5.2 ⚙️ Traduzione esecutiva dei tre gate — **dove si misurano davvero**

_Checklist 57: si dichiara dove la misura viene fatta, e perché lo strumento
"ovvio" non può farla._

**Il fatto che comanda tutto**: `ABTG_SupertrendReversal_Ottimizzato.mq5`
**NON esporta il per-trade**. Verificato nel sorgente al pin: l'unico `FileWrite`
è quello di `OnTesterDeinit` (blocco OPTFRAME, righe 576-604), che scrive
`OptResults_<EA>_<Simbolo>.csv` **e solo in ottimizzazione**. Non esiste nessun
`abtg_trades_*.csv` per questo EA. Quindi:

| gate / criterio | strumento **impossibile** | strumento **usato davvero** |
|---|---|---|
| **1** prima operazione | per-trade (non esiste) | **due misure indipendenti, entrambe sempre eseguite**: (a) il **log del tester** della passata singola con `InpVerbose=true` — l'EA stampa `[STReversal] LONG mercato ... @ ...` (sorgente riga 270) e la riga porta la data simulata; (b) la **prima riga della tabella dei deal** del report `.htm` della stessa passata. Se le due divergono → PROBLEMA scritto; se falliscono **entrambe** → FATALE |
| **2** n totale | per-trade | colonna **`Trades`** dell'`OptResults` della passata gemella (= `TesterStatistics(STAT_TRADES)`), **più** il conteggio dei deal del report come controllo incrociato |
| **3** gemelli identici al centesimo | — | le **due righe** dell'`OptResults` (magic `779910` e `779911`): `Profit`, `Profit Factor`, `Equity DD %` e `Trades` devono coincidere **arrotondati al centesimo** |
| **A** DD massimo 22 anni | — | colonna **`Equity DD %`** dell'`OptResults` sulla finestra intera (= `STAT_EQUITY_DDREL_PERCENT`) |
| **B** peggior giornata % | per-trade / PowerShell sui tick | **tabella dei deal del report `.htm`** della passata singola: profitto sommato **per giorno di calendario**, diviso per il saldo a inizio giornata. ⚠️ **[APPROSSIMATO]**: è la peggior giornata sulle **chiusure realizzate**, non sull'equity intraday — la stessa approssimazione con cui è stata misurata la peggior giornata di portafoglio in R51 |
| **C** DD nelle 4 finestre | — | **una passata gemella per finestra**, ciascuna col suo `Equity DD %`. È il metodo di casa: R50/R56/R59 hanno fatto esattamente così (celle × finestre) |

> 🔴 **E se il report `.htm` non c'è o non è leggibile**, il criterio **B non si
> inventa**: il referto scrive `PEGGIOR GIORNATA: NON MISURATA`, dice **perché**
> e **come si misura**, e la corsa **prosegue** (è una misura, non un gate —
> checklist 26-bis). Un numero inventato dentro un verdetto firmato sarebbe
> peggio di un numero mancante.

---

## 6. 🧊 LA CELLA — quella VIVA, congelata (alla lettera: _"Vietato cambiarne uno solo"_)

42 input, tutti scritti **nell'artefatto che gira**
(`prove/R99_ORO_22ANNI_RISCHIO.txt`, **45 righe vive** = 3 direttive `@` + 42
parametri, **misurate** con `grep -vE '^\s*(#|$)' | wc -l`, non ricordate).

| input | valore | da dove |
|---|---|---|
| `InpUsaGuardian` | `true` | default sorgente. **Nel tester è fail-open totale**: le GlobalVariable del Guardian non esistono lì, e il sorgente lo dichiara alle righe 38-41. Non cambia una virgola del backtest |
| `InpTF` | `16388` (H4) | default sorgente · già nel file prova prima della firma |
| `InpStMult` | `2.5` | default sorgente — **è il valore "OTT XAUUSD H4"**, il commento del sorgente dice `(era 3.5)` |
| `InpStAtrPeriod` | `7` | default sorgente — `OTT XAUUSD H4 (era 10)` |
| `InpNearAtr` | `1.0` | default sorgente |
| `InpRequireConfirmBody` | `true` | default sorgente |
| `InpAllowLong` / `InpAllowShort` | `true` / `true` | default sorgente. ⚠️ **[DA CONFERMARE]**: `prove/R52_CENSIMENTO_LATI.md` classifica questa sedia **[INCERTO]** sui lati |
| `InpUseConfluence` | `true` | default sorgente |
| `InpEma1..4` | `14` · `89` · `100` · `200` | default sorgente |
| `InpConflAtr` | `1.5` | default sorgente |
| `InpFirstFraction` | `0.3333` | default sorgente (1/3 a mercato) |
| `InpUsePending` | `true` | default sorgente |
| `InpPendingPips` | `20` | default sorgente |
| `InpPendingExpiryBars` | `3` | default sorgente |
| `InpSLLookback` | `5` | default sorgente |
| `InpSLBufferPips` | `3` | default sorgente |
| `InpTP1_R` / `InpTP1Pct` | `1.0` / `50` | default sorgente |
| `InpBreakeven` | `true` | default sorgente |
| `InpTP_RR` | `2.5` | default sorgente — `OTT XAUUSD H4 (era 2.0)` |
| `InpTrailOnST` / `InpExitOnFlip` | `true` / `true` | default sorgente |
| **`InpRiskPercent`** | **`1.0`** | 🔒 **CRITERIO A** (_"al rischio 1%"_). Il sorgente ha `2.0`; la **sedia viva è misurata a `1`** nel censimento `.chr` del 18/08 → il pin del criterio **coincide** con la sedia accesa oggi |
| `InpMaxTradesPerDay` | `0` | default sorgente (illimitato) |
| `InpUseTimeWindow` / `InpStartHour` / `InpEndHour` | `false` / `0` / `24` | default sorgente (filtro orario spento) |
| `InpUseNewsFilter` + le 6 righe news | `false` + default | default sorgente (filtro spento: le 6 righe sono **inerti**, ma stanno scritte invece che dedotte — checklist 25) |
| `InpComment` | `STREV OTT` | default sorgente, **e coincide col commento misurato nel censimento `.chr`** |
| **`InpMagic`** | **`779910 → 779911`** (asse `Y`) | 🔒 **coppia VERGINE**, vedi §7 |
| `InpMaxSpread` | `0` | default sorgente |
| `InpVerbose` | `true` | default sorgente. **Serve al gate 1**: senza, la passata singola non stampa le righe d'ingresso e non c'è nessuna data da leggere. In ottimizzazione MT5 non esegue le `Print`, quindi sulle passate gemelle è inerte |

### 6.1 📌 Cosa è MISURATO della sedia viva e cosa è [DA CONFERMARE]

**Misurato** (censimento `.chr` del 18/08 00:01, riga 38 — `EA · simbolo ·
magic · rischio · commento`): magic **970901** ✅ = default sorgente · rischio
**1** ✅ = pin del criterio · commento **STREV OTT** ✅ = default sorgente.
**Tre indizi su tre coerenti col sorgente.**

**[DA CONFERMARE]**: gli **altri 39 input non sono elencati in nessun
censimento**. Sono presi dai **default del sorgente al pin**. Se sul VPS
qualcuno ha toccato un input a mano su quel grafico, R99 misura **il sorgente**
e non **la sedia**. 👉 La conferma vera è leggere il `.chr` del grafico
`XAUUSDH41` sul VPS, input per input: **non è un prerequisito del lancio**
(nessuno dei 39 è stato mai dichiarato diverso), ma va scritta nel referto.

---

## 7. 🏷️ I MAGIC — e la collisione `770901`

`report/CENSIMENTO_FREQUENZA_FLOTTA_2026-08-22.md` §5 ha misurato che il magic
**770901** è assegnato **in due documenti a due sedie diverse**
(`SupertrendReversal` "Nikkei H2" su 225JPY in `CONTRATTI_SEDIE.md`; questa
sedia su XAUUSD in `FLOTTA_ATTIVA.md`) e che **ha davvero fatto trade su
XAUUSD** (3 chiusure, 30-31/07). Il contratto di questa sedia porta invece
**970901**.

> **R99 non usa nessuno dei due.** Gira su una coppia **vergine** del blocco
> `7799xx` — verificato che in tutto il repo il blocco `7799xx` contiene solo
> `779001` (`ABTG_Guardian`, utility che non trada).

| finestra | magic |
|---|---|
| INTERA 2004-2026 (gemelle) | `779910` / `779911` |
| INTERA — passata **singola** (log + report) | `779912` |
| ORSO | `779920` / `779921` |
| CROLLO | `779930` / `779931` |
| TORO | `779940` / `779941` |
| LATERALE | `779950` / `779951` |
| diagnostica **ORO 2008** (non è un criterio) | `779960` / `779961` |
| diagnostica **ORO 2013** (non è un criterio) | `779970` / `779971` |

**Vietati e controllati nel codice**: `970901` (la sedia viva), `770901` (la
collisione), `770921` e `770924` (i due `SupertrendReversal` di forward).

⚠️ Il magic **non cambia il comportamento** dell'EA: è l'etichetta degli ordini
e, qui, l'asse gemello di controllo. Le passate del PASSO 0 **non condividono il
magic** con le passate delle finestre (checklist 41, pagato in R82).

---

## 8. 🌍 LE QUATTRO FINESTRE DI REGIME — le date, e da dove vengono

**Fonte**: `backtest_pipeline/prova_regime.ps1`, righe 69-75, blocco
_"LE QUATTRO FINESTRE (fissate nei criteri, non si toccano qui)"_ — sono le
stesse di **R50 / R56 / R59**.

| finestra | da | a |
|---|---|---|
| **ORSO** | `2022.01.01` | `2022.10.31` |
| **CROLLO** | `2020.02.01` | `2020.04.30` |
| **TORO** | `2021.01.01` | `2021.12.31` |
| **LATERALE** | `2019.01.01` | `2019.12.31` |

➕ Nello stesso file esiste una quinta finestra, **`CROLLO_ANNO`
(`2020.01.01 → 2020.12.31`)**, nata dall'**Emendamento 2 del 15/08**: il CROLLO
da tre mesi non accumula abbastanza operazioni per giudicare il **MERITO**, e
quindi si sdoppia — _"CROLLO → il RISCHIO (drawdown, peggior giornata): valgono
a QUALUNQUE numero di operazioni, perché sono fatti accaduti e non stime;
CROLLO_ANNO → il MERITO"_.
👉 **R99 è un round di RISCHIO**: usa il **CROLLO** da tre mesi, che è
esattamente la metà che l'emendamento assegna al rischio, e **non gira**
`CROLLO_ANNO`. Dichiarato qui perché nessuno lo cerchi nel referto.

### 8.1 🥇 Due finestre DIAGNOSTICHE dell'oro — **non sono criteri**

L'ipotesi (§1) nomina **due eventi specifici**: *"il crollo dell'ottobre 2008 e
il crollo dell'aprile 2013"*. **Nessuna delle quattro finestre di casa li
contiene** (sono finestre di regime nate su indici e forex). Il criterio A (i 22
anni interi) li copre entrambi, ma **annegati** in vent'anni di equity.

Perciò il round gira **due passate in più**, marcate **DIAGNOSTICHE**:

| diagnostica | da | a | perché |
|---|---|---|---|
| **ORO 2008** | `2008.07.01` | `2008.12.31` | contiene il crollo dell'ottobre 2008 nominato dall'ipotesi |
| **ORO 2013** | `2013.03.01` | `2013.06.30` | contiene il crollo del 12-15 aprile 2013 nominato dall'ipotesi |

> 🛑 **NON entrano nel criterio C e non entrano in nessun confronto `2x`.**
> Sono la stessa figura delle "passate diagnostiche" di R98 §4.1: **servono a
> DICHIARARE, non a decidere.** Le date sono **scelte da chi prepara il lancio**
> per contenere gli eventi che l'ipotesi nomina, non misurate su un criterio: se
> qualcuno volesse promuoverle a criterio, **serve una firma**.

---

## 9. 📋 COSA PUÒ USCIRE DA R99, E COSA NO

**Può uscire:**
1. i **tre numeri** del §3 per la cella (A, B, C×4) + le due diagnostiche;
2. il verdetto meccanico **`2x`** — oggi: `NON CALCOLABILE` (§3.1), che è a sua
   volta un rilievo;
3. una **PROPOSTA** (da firmare a parte) di riempire il contratto parziale della
   sedia col DD misurato;
4. una **PROPOSTA** (da firmare a parte) di rifare la stessa misura sulle altre
   sedie oro — la flotta ha **12 grafici** sull'oro
   (`FLOTTA_ATTIVA.md`: *"Concentrazione ORO altissima"*), e questa è **una sola** di
   quelle sedie.

**Non può uscire:**
- nessuna promozione, nessuna bocciatura **di merito**, nessun cambio di
  parametri, nessuna sedia nuova, nessuna sedia spenta;
- nessun giudizio sul PF/profitto delle finestre vecchie;
- nessun numero di spread, nessun numero a tick reali (**il modello è OHLC**).

---

## 10. 🧾 DA DOVE VIENE OGNI PEZZO — la mappa delle fonti

| pezzo | fonte | stato |
|---|---|---|
| `@DAQUANDO 2004.06.11` | `REFERTO_SONDA_STORICO_17-08.md` sez. 2 | ✅ MISURATO |
| tetto 100.000 barre | stessa sonda + R76 | ✅ MISURATO |
| tick reali dal 2024.07.05 | R76 / sonda | ✅ MISURATO |
| DD promesso della sedia | `CONTRATTI_SEDIE.md` riga 72 | 🔴 **NON È UN NUMERO** (§3.1) |
| rischio della sedia viva = 1 | `censimento_rischio_2026-08-18_0001.txt` riga 38 | ✅ MISURATO |
| rischio 2,0% fino al 17/08 | `REFERTO_CENSIMENTO_RISCHIO.md` | ✅ MISURATO |
| collisione magic 770901 | `CENSIMENTO_FREQUENZA_FLOTTA_2026-08-22.md` §5 | ✅ MISURATO |
| i 39 input non censiti | default del sorgente al pin | 🟡 **[DA CONFERMARE]** |
| le 4 finestre di regime | `prova_regime.ps1` righe 69-75 (R50/R56/R59) | ✅ AGLI ATTI |
| le 2 finestre diagnostiche oro | scelte dal preparatore per contenere gli eventi dell'ipotesi | 🟡 **DICHIARATE, non criteri** |
| soglia fatale "dopo il 2010" | traduzione del preparatore | 🟡 **DICHIARATA** (§5.1) |
| PF 2,74 della sedia | `CLASSIFICA_PF.md` riga 17 | ℹ️ **non entra in R99** (è merito) |

---

## ✍️ FIRMA — ✅ **APPOSTA il 23/08/2026, in chat**

> **"FIRMO R99, PARTIAMO CON L'ORO"** — Claudio, 23/08/2026.

Firmati a numeri mai visti. I criteri di accettazione del §3 sono quelli
dell'header del file prova, **parola per parola**. Le traduzioni esecutive
(§3.1, §5.1, §5.2, §8.1) sono **aggiunte dichiarate**, non modifiche: nessuna
di esse cambia cosa il round accetta o rifiuta — cambiano solo **dove si legge
il numero** e **cosa si scrive quando il numero non si può leggere**.
