# 🛑 CORSIA DEMO — `SUPERWAVE DAX H4`: **NON ACCENDERE**

_Scritta il **07/09/2026**. Candidato **4️⃣ G4** di `report/CORSIA_DEMO_CANDIDATI.md`.
Regole della corsia: `report/CORSIA_DEMO_REGOLE.md`._

---

## ⚖️ IL VERDETTO IN UNA RIGA

**Il traguardo è il più lontano dei tre (3-6,7 anni a seconda di come si conta la
finestra), e la finestra stessa non è ricostruibile con certezza.** Due delle tre
condizioni di scarto previste dal mandato scattano insieme: **traguardo fuori
portata** e **cella non pienamente ricostruibile**.

> `report/CORSIA_DEMO_CANDIDATI.md` §2 G4 lo dice già, e lo dice bene:
> _"**Frequenza attesa ~0,12 op/giorno → n=150 in anni. Passeggero, non
> pilota.**"_ e _"**È il più fragile dei quattro, ed è per questo che sta in
> fondo alla lista.**"_

---

## 2️⃣ IL TRAGUARDO — e il buco nel denominatore

**Il numeratore è certo, il denominatore no.** Il file `.ini` della validazione
chiede `FromDate=2024.01.01`, ma il **pavimento MISURATO dei tick BCM sugli
indici è il 2024.09.26**. Quindi la finestra **effettiva** della corsa a modello 4
non è ricostruibile dall'archivio: o sono 30 mesi (e allora buona parte è senza
tick veri), o sono 21.
_(fonte: `backtest_pipeline/ini/valid_SuperWaveRT_D30EUR_H4.ini` · pavimento tick:
`CORSIA_DEMO_CANDIDATI.md` §7. Lo stesso caveat è già scritto in
`report/CENSIMENTO_CONTRATTI.md` §4b per `SupRev_DAX_H4`: "2024.01→2026.06
nominale (tick indici dal 2024.09.26)".)_

| lettura della finestra | feriali | op/gg | op/mese | **A — forward da solo a 150** | **B — `n` cella (56+94) a 150** |
|---|---:|---:|---:|---|---|
| **nominale** 2024.01.01→2026.06.30 | 651 | 0,086 | 1,87 | **80 mesi** (6,7 anni) → **2033** | **50 mesi** (4,2 anni) → **~nov 2030** |
| **effettiva** 2024.09.26→2026.06.30 | 459 | 0,122 | 2,65 | **56,6 mesi** (4,7 anni) → **~mag 2031** | **35,4 mesi** (2,9 anni) → **~ago 2029** |

❌ **Il migliore dei quattro conti è 2,9 anni. Il tetto è ~18 mesi.**
E la lettura "effettiva" (2,65 op/mese) è quella che il censimento ha usato
(_"~2,7 op/mese = 0,12 op/gg"_): **anche prendendo il numero più favorevole, la
sedia arriva a destinazione nel 2029.**

### 🔓 La rilettura del 07/09 tolgono UN ostacolo, non questo
La firma del 07/09 sposta il pavimento di frequenza dalla **sedia** alla
**FAMIGLIA**, e la famiglia SuperWave **ha già due sedie in campo** (DOW H1
770511, H2 770531): quindi **l'esclusione per sola frequenza cade davvero**, ed
era giusto rileggerla. 👉 **Ma la frequenza e il traguardo sono due criteri
diversi.** Il primo chiede _"questa sedia porta abbastanza operazioni al conto?"_
— e oggi la risposta è "non serve che le porti, ci pensa la famiglia". Il secondo
chiede _"in quanto tempo questa sedia risponde alla domanda per cui la accendo?"_
— e la risposta resta **anni**. La firma del 07/09 **non tocca il secondo**, e
scriverlo altrimenti sarebbe usarla per una cosa che non dice.

---

## 3️⃣ IL DD PROMESSO — **3,32% a rischio 1,00%** · e la riscalatura da dichiarare

**Fonte primaria trovata e letta** (a differenza degli altri due candidati, qui il
CSV grezzo **esiste**):
`backtest_pipeline/risultati_archivio/SuperWave/valid_SuperWaveRT_D30EUR_H4_realtick.csv`,
**riga Pass 1**.

| metrica (D30EUR H4, **modello 4 tick reali**, deposito **10.000 EUR**, rischio **1,00%**) | valore |
|---|---:|
| `InpStMult` / `InpTP_RR` | **3,0 / 2,0** |
| profit | **+277,69** |
| profit factor | **1,28456** |
| **drawdown equity** | **3,3245%** |
| expected payoff | **+4,95877** |
| Sharpe | **1,06358** |
| n (Trades) | **56** |
| celle positive | **7 su 9** |

### 💶 La riscalatura a 0,65% — DICHIARATA, e per questo NON usata come promessa
Il metro di casa è **0,65%** (cap C1 3,25% = 5 SL vivi). La corsa è a **1,00%**.
Per la convenzione di casa (`report/CENSIMENTO_CONTRATTI.md` §1.2, il DD scala
~linearmente col rischio, marcato **[APPROSSIMATO]**):

> 3,3245% × (0,65 / 1,00) = **2,16% [APPROSSIMATO, NON MISURATO]**

🔴 **Il DD promesso che varrebbe come cancello resta il MISURATO 3,32%**, non il
2,16% stimato: un DD stimato non può essere una promessa di rischio. **Un DD
misurato all'1% non è lo stesso DD allo 0,65%**, e la differenza si dichiara —
non si spende.

### 🔴 E TRE COSE **NON MISURATE** SULLA CELLA, che da sole fermerebbero il deploy
1. **La corsa ha girato l'EA BASE `ABTG_SuperWave.mq5`, non
   `ABTG_SuperWave_DAX_H4_Ottimizzato.mq5`** (`rilancia_superwave_validazione.ps1`
   riga 12: `$EA="ABTG_SuperWave"`), e il CSV porta **`InpMagic=770501`**, non
   770512. I due file oggi **differiscono** (diff verificato: `InpStMult` 3.5 vs
   3.0, commento, magic — il resto identico), ma sono **due sorgenti separati**
   (628 vs 599 righe): **nessuno ha mai verificato che il derivato riproduca il
   numero del padre.**
2. **Tre input non esistevano al momento della misura** e non compaiono fra le
   colonne del CSV: **`InpUsaGuardian`**, **`InpPendingAtr`**, **`InpSLBufferAtr`**.
   I valori neutri (`false` / `0` / `0`) riproducono il comportamento misurato —
   ma è un'**inferenza dal codice**, non un dato del banco. **NON MISURATO.**
3. **La finestra effettiva** (§2). Con n=56 su una finestra incerta, **la
   frequenza promessa ha un'incertezza del 40%.**

### 🔴 LA CONTRO-EVIDENZA DI FAMIGLIA, dichiarata prima che la trovi qualcun altro
- **SuperWave GBPUSD 770532: SPENTA il 24/08** — R103: PF 0,79 · DD 13,4% ·
  −7.501 · **5/7 anni negativi** (DD 12,9× il promesso).
- **SuperWave lato SHORT del Dow: morto** — R110: PF OOS 0,429 · DD 7,53%.
- **Il DAX H4 non è MAI stato smontato per lati né rimisurato su finestra
  lunga**: il suo n=56 è **una finestra sola**, in **un regime solo**.

---

## 4️⃣ IL TAGLIANDO — non si apre, quindi non si fissa

Non c'è tagliando perché non c'è sedia. **La misura che va fatta prima di
qualunque forward** — e che costa **una corsa, non anni di calendario** — è
un'altra:

🗓️ **Da mettere in coda all'imbuto (costo: una riga di lancio)**
1. **Smontare i due lati** (long / short) sulla cella `StMult 3.0 / TP_RR 2.0`,
   **regola di casa del 25/08** sugli indici. La famiglia ha **già uno short
   morto misurato** sul Dow: è la prima cosa da guardare, e il DAX non l'ha mai
   avuta.
2. **Ridichiarare la finestra** con `FromDate=2024.09.26` (il pavimento vero) e
   rileggere n, PF, DD **sulla finestra che i tick coprono davvero**.
3. **Riprodurre la cella con `ABTG_SuperWave_DAX_H4_Ottimizzato.mq5`** (il file
   che si vorrebbe schierare) e verificare che dia lo **stesso numero al
   centesimo** del padre. Se non lo dà, il 3,32% **non è il DD di quella sedia**.

👉 Queste tre misure **possono cambiare il verdetto**. Il forward **non può**:
può solo aspettare.

---

## 🪪 MAGIC — la nota che evita un incidente

| | |
|---|---|
| **770512** | è **già assegnato** a `ABTG_SuperWave_DAX_H4_Ottimizzato.mq5` come default compilato, ma **la sedia NON è in campo** (`FLOTTA_ATTIVA.md`: _"NON IN CAMPO (770512: assente da censimenti ed Esperti 25/08 22:15)"_, e non compare in `report/CENSIMENTO_CONTRATTI.md`). |
| **770513** | **RISERVATO** per l'eventuale sedia demo. Verificato **VERGINE** repo-wide il 07/09/2026: `grep -rn "770513" . --exclude-dir=.git` → **0 occorrenze**. 🔴 **Motivo per cui NON riuso il 770512**: è il magic di una sedia che risulta "assegnata ma non in campo", e riusarlo renderebbe **impossibile distinguere** in un censimento futuro una sedia demo nuova da un residuo del 25/08. Un magic nuovo costa zero e toglie un'ambiguità. |

---

## 🛑 E LA FRASE CHE VALE COMUNQUE

**La corsia demo non è una porta verso il conto reale.** Se un giorno questa
sedia si accende, tornerebbe **in coda all'imbuto** col suo n finalmente pieno,
e da lì si giudicherebbe col merito come tutte. Il passaggio ai soldi veri resta
una **firma specifica su un numero misurato**.

---

## ✅ COSA RESTA A VERBALE, ANCHE COL NO

1. 🟢 **La rilettura del 07/09 era dovuta e l'ho fatta**: l'esclusione per **sola
   frequenza della sedia singola** **cade** (la famiglia SuperWave ha due sedie in
   campo). Il "no" di oggi poggia su **un criterio diverso**, il traguardo — e va
   detto, perché altrimenti sembra che la firma del 07/09 non sia servita.
2. 🟢 **Il CSV primario esiste** ed è l'unico dei tre candidati ad averlo: la
   cella è tracciabile fino al centesimo (`Pass 1`).
3. 🔴 **Il verdetto non è "il motore non vale"**: è **"il forward non è lo
   strumento"**, e ci sono **tre misure da banco** che costano una corsa e
   possono riaprire tutto (§4). **Quelle sì, valgono la spesa.**
