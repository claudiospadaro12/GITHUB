# 🔭 R185 — LA SONDA SU **SPXUSD**, prima di qualunque duello

_Criteri congelati il **18/09/2026**, **PRIMA di qualunque numero**.
Gemella di `R180_DUELLO_DOW_CRITERI.md`. Nasce dalla richiesta di Claudio
**«FAI IL DUELLO SUI GEMELLI DOW E SPX»** e dal **PASSO 0** prescritto da
**R83** (`prove/R83_INGRESSI_CRITERI.md` §3), che su SPXUSD **non è mai stato
fatto**._

> ## 🔴 LA FRASE CHE VALE PIÙ DI TUTTO IL RESTO
> **IL DUELLO SU SPXUSD NON PARTE.** Non esiste in questa consegna, e non
> esisterà finché questa sonda non avrà risposto. Preparare le celle adesso
> vorrebbe dire scrivere sette file con dentro una finestra **inventata**.

---

## 1. 🧐 CHE COSA SAPPIAMO GIÀ (misurato) E CHE COSA NO

| domanda | risposta | fonte |
|---|---|---|
| BCM **quota** SPXUSD? | ✅ **SÌ** | `risultati_archivio/REFERTO_SONDA_STORICO_17-08.md` §3 |
| profondità delle **BARRE** BCM | ✅ **2024.09.26**, verdetto **`COMPLETO`** (= il broker non ne ha di più) | idem |
| profondità dei **TICK REALI** BCM | 🔴 **MAI MISURATA** | `risultati_archivio/ABTG_StoricoScaricato.csv` ha la riga `TICK` **solo** per `D30EUR` e `U30USD` |
| **specifiche di contratto** (lotto minimo, valore del punto, tick size, spread tipico) | 🔴 **MAI MISURATE** | nessun referto in repo le riporta per SPXUSD |
| il motore delle **aperture** su SPXUSD | 🔴 **ZERO righe in tutto il repo** | censimento meccanico del 18/09 (§1d di `R180_DUELLO_DOW_CRITERI.md`) |

### 1a. 🪤 IL FALSO POSITIVO DA NON RIPETERE

Un `grep SPXUSD` sui CSV dei risultati **risponde SÌ in decine di file**, e
**è falso**: `SPXUSD` è il valore della colonna **`InpCorrSymbol`** (simbolo
del *filtro di correlazione*, per giunta **spento**: `InpUseCorrelation=0`),
non il simbolo negoziato. Chi legge quel grep conclude «SPX è già stato
provato» e sbaglia.

### 1b. 📌 `SPXUSD_EXT` ESISTE, MA **NON È** QUESTO

Il round di import del **26/08/2026**
(`risultati_archivio/STORICO_INDICI_20260826_2334/REFERTO_STORICO_INDICI.txt`)
ha creato il simbolo personalizzato **`SPXUSD_EXT`**: **4.598.932 righe M1,
anni 2010→2026**, importate da una fonte **esterna**. È un dato prezioso, ma:
- 🔴 è **OHLC, non tick**: non serve a `-Modello 4`;
- 🔴 è **un altro simbolo**: spread, specifiche di contratto e sessioni non
  sono quelli di `SPXUSD` a BCM;
- 🔴 è marcato, per la famiglia `_EXT`, **«SOLO prova di regime»**.

👉 **`SPXUSD_EXT` può servire alla PROVA DI REGIME (2010-2022), mai al
duello.** Sono due strumenti diversi e vanno tenuti separati nel referto.

---

## 2. 🎯 LE TRE DOMANDE DELLA SONDA — e i cancelli, congelati adesso

### Q1 — **I TICK REALI: da quando?**
Si legge la riga `SPXUSD,TICK` di `ABTG_StoricoScaricato.csv`, colonne
`Barre`, `PrimaDataLocale`, `Verdetto`.

- 🟢 **PASS** — `PrimaDataLocale ≤ 2024.09.26` e `Verdetto = COMPLETO`:
  il duello SPX può girare a **`-Modello 4`** sulla stessa finestra del Dow, e
  i due gemelli sono **confrontabili**.
- 🟠 **PARZIALE** — i tick partono **dopo** il 2024.09.26: la finestra del
  duello SPX **si riscrive** su quella data, e **va detto in ogni tabella** che
  Dow e SPX **non hanno la stessa finestra** (difetto n.18 della checklist).
- 🔴 **FAIL** — `PrimaDataLocale` vuota, riga assente, o `IL BROKER NON HA PIÙ
  STORICO`: **niente tick, niente duello a tick**. Le due sole uscite oneste
  sono: (a) girare a **`-Modello 1` (OHLC M1)** dichiarando **su ogni numero**
  *"OHLC, non tick"* e usandolo **solo come SCREENING**, mai per un verdetto
  (regola R57: il solo modello ribalta il segno); (b) rinunciare.

### Q2 — **LE SPECIFICHE DI CONTRATTO: la cella è dimensionabile?**
Servono `VOLUME_MIN`, `TRADE_TICK_SIZE`, `TRADE_TICK_VALUE`, `POINT`, e lo
spread tipico. Le stampa `ABTG_InfoBroker`.

- 🔴 **Perché è un cancello e non una curiosità (classe 229, il PAVIMENTO DEL
  LOTTO):** se il lotto minimo di SPXUSD rischia **più** dell'1% del deposito
  di banco, la cella **non rischia quello che dichiara**, e ogni PF e ogni DD
  del duello descrivono una taglia che non esiste. Il conto è già stato fatto
  per U30USD (`VOLUME_MIN 0,10`, ~0,861 EUR/punto indice per lotto → il
  pavimento morde solo sotto ~1.350 EUR di saldo): **su SPXUSD quel conto non
  esiste**, va fatto con i numeri veri prima di leggere qualunque risultato.
- 🟢 **PASS**: rischio del lotto minimo **< 1,0%** del deposito di banco
  (10.000) con lo stop tipico della cella → la taglia dichiarata è la taglia
  vera.
- 🟠 **ATTENZIONE**: fra 1,0% e 2,0% → il duello si può fare, ma **a deposito
  100.000**, e va dichiarato.
- 🔴 **FAIL**: sopra il 2,0% → il duello SPX a queste taglie **non è
  misurabile**, e si dice così.

### Q3 — **LA FRONTIERA DEL COSTO: `stop ≥ 40 × spread`**
Regola di casa, e su M5 gli indici la sfondano. Con lo spread tipico di
SPXUSD misurato in Q2 e lo stop tipico della cella (estremo opposto del range
di apertura 35 min), si calcola il rapporto.

- 🟢 **PASS**: `stop ≥ 40 × spread` → M5 è ammesso.
- 🔴 **FAIL**: il TF **M5 si dichiara ESCLUSO PER COSTO, col numero accanto**,
  e il duello SPX si prepara su **M15/M30** — non è pigrizia, è un conto.

> ⚠️ **Q3 nasce con un limite dichiarato**: lo stop tipico su SPXUSD **non è
> misurato** (zero gambe osservate). Finché non c'è, Q3 si calcola con lo stop
> **inferito** dal range di apertura, e il numero porta scritto **[INFERITO]**.

---

## 3. 🛠️ COME SI MISURA — nessuno script nuovo, e questo è un pregio

La sonda **esiste già ed è collaudata**: `backtest_pipeline/scarica_storico.ps1`
(marcatore `MARCATORE_SCARICA_STORICO_v3_TERMINALE_BACKTEST`). Scrive
`MQL5\Files\ABTG_StoricoScaricato.csv`, che il driver di R83 rilegge da
`Desktop\storico_bcm\`.

🔴 **NIENTE `.ps1` NUOVI IN QUESTA CONSEGNA.** Uno script nuovo è una classe di
difetti nuova; qui non serve.

### 3a. 🎁 IL SIMBOLO IN PIÙ CHE COSTA POCO E CHIUDE UN BUCO VECCHIO

Nella stessa corsa conviene sondare **anche `NASUSD`**: i suoi tick **non sono
mai stati misurati** e sono il **PASSO 0 ancora aperto di R83** (il round che
ha già girato il duello sul Nasdaq). Costo marginale: una passata di download
in più nella stessa esecuzione. 🟠 **Ma i tick sono pesanti** (U30USD ne ha
68,5 milioni): due simboli possono raddoppiare il tempo. È una scelta di
Claudio, non mia — la propongo, non la do per fatta.

### 3b. ⚠️ QUELLO CHE LA RIGA DEVE DIRE, E CHE È UN RISCHIO VERO

`scarica_storico.ps1 -Auto` **SENZA** `-TerminaleBacktest` **chiude TUTTI i
terminali della macchina**. Sul VPS sono quattro, e **uno è il conto REALE
10105439 con posizioni aperte**. Quindi:

- 🖥️ **se la sonda gira sul PC DI BACKTEST**: MT5 va **chiuso prima**, e non
  c'è nessun forward su quella macchina.
- 🖥️ **se la sonda gira sul VPS**: **obbligatorio** `-TerminaleBacktest
  "C:\MT5_Backtest"` (conto demo **50504400**, zero EA attaccati). Così si
  chiude **solo** quel processo e **restano vivi** il piccolo **50503392**, il
  100k **50504263** e il **REALE 10105439**, con PID e percorso **stampati
  prima e dopo**.

🔴 **La riga di lancio dettata a Claudio deve portare in TESTA il bersaglio e
l'elenco di cosa NON viene toccato.** La riga vera passa dal cancello
(`controlla_riga.py` + agente `controllo-preventivo`) **prima** di partire: qui
si congelano i criteri, non si consegna la stringa.

---

## 4. ⏱️ COSTO — **STIMA, con la base dichiarata**

Non esiste in repo un cronometraggio del download **tick** per simbolo. Le due
basi disponibili:
- l'`.ini` di R83 prescrive **`-TimeoutMin 180`** per il PASSO 0 su **due**
  simboli → **il tetto previsto dalla casa è 3 ore**;
- la corsa dell'08/09 ha scaricato **104 milioni di tick** in una notte
  (`commit 70b289d5`) — 🔴 **senza cronometro registrato**.

👉 **Stima dichiarata: 30-180 minuti per simbolo, [NON MISURATO].**
Si misura al primo giro e si scrive nel referto.

---

## 5. 🛑 CHE COSA QUESTA SONDA **NON** MISURA — per nome

1. 🔴 **Non misura nessun edge.** Non produce PF, non produce DD, non promuove
   e non boccia nessun motore. È il ponteggio, non il lavoro.
2. 🔴 **Non dice se il duello SPX vale la pena.** Anche con PASS su tutte e
   tre le domande, la finestra resterebbe **21 mesi e un regime e mezzo**,
   esattamente come sul Dow.
3. 🔴 **Non tocca `SPXUSD_EXT`** (§1b): quello è materia da prova di regime.
4. 🔴 **Non misura lo spread di una prop vera**, né requote né rifiuti.

---

## 6. 🚦 IL CANCELLO DI USCITA — quando si può scrivere il duello SPX

Tutte e tre insieme, altrimenti **non si scrive nessun file prova**:

- **Q1 = PASS o PARZIALE** (con la finestra riscritta sulla data vera);
- **Q2 = PASS o ATTENZIONE** (col deposito dichiarato);
- **Q3 = PASS** (oppure M5 escluso per costo e il duello riscritto su M15/M30).

Solo allora si generano le celle **`R186s*`** col medesimo generatore usato per
il Dow (`prove/R180_GENERA.py`, parametrizzato sul simbolo) e con **magic
vergini nuovi**, verificati col grep e col risultato dichiarato nel file.

---

## 7. 📎 TRACCIABILITÀ

- Sonda: `backtest_pipeline/scarica_storico.ps1` · script MQL5
  `ABTG_HistoryDownloader` · specifiche: `mql5/Scripts/ABTG_InfoBroker.mq5`
  (via `backtest_pipeline/sonda_storico.ps1`)
- Referto che misura le BARRE: `risultati_archivio/REFERTO_SONDA_STORICO_17-08.md`
- Referto che misura i TICK di Dow e DAX: `risultati_archivio/ABTG_StoricoScaricato.csv`
- Import esterno `SPXUSD_EXT`: `risultati_archivio/STORICO_INDICI_20260826_2334/REFERTO_STORICO_INDICI.txt`
- Criteri padre: `prove/R83_INGRESSI_CRITERI.md` §3 (PASSO 0)
- Gemello: `prove/R180_DUELLO_DOW_CRITERI.md`
