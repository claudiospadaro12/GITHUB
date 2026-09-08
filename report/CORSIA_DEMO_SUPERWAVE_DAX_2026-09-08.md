# 🪑 CORSIA DEMO — `SUPERWAVE DAX H4` · magic **770512** · PACCHETTO DI ACCENSIONE

_Scritto l'**08/09/2026**, **PRIMA** che la sedia apra una sola posizione._
_Regole della corsia: `report/CORSIA_DEMO_REGOLE.md`. Candidato **R1** di
`report/RIPESCAGGIO_FREQUENZA_2026-09-08.md`. Riga **6** di `report/DA_FIRMARE.md`._

> ## 🖊️ LA DOMANDA PER CLAUDIO, IN UNA RIGA
> **`SuperWave DAX H4` (770512) si accende in corsia demo sul piccolo 50503392,
> a `InpRiskPercent = 0,65`, sì o no?**
> Tutto il resto è già preparato: preset scritto, passi numerati, cancello di
> rischio dichiarato, riga di verifica pronta e già passata al parser.

> ### 🔴 E LA PRIMA COSA DA SAPERE, PRIMA DEL SÌ — **c'è un NO agli atti, di ieri**
> `report/CORSIA_DEMO_SUPERWAVE_DAX_H4.md` (07/09/2026) si intitola, testuale,
> **"NON ACCENDERE"**. Non è un documento vecchio: è di ieri, ed è nostro.
> **Il suo argomento non è la frequenza — è il TRAGUARDO** (§4 qui sotto):
> a 2,65 op/mese la sedia arriva a n=150 nel **2029-2031**, contro il tetto di
> ~18 mesi della corsia. **Quell'argomento regge ancora, e questo pacchetto non
> lo smonta.**
> 👉 Ciò che è cambiato l'08/09 è **la domanda per cui si accende**: non più
> *"arriva a 150?"* (no, non ci arriva) ma *"quanto costa avere il numero della
> sua frequenza e del suo comportamento vero?"* — e la risposta è **mezz'ora**.
> **Le due letture vanno tenute tutte e due in testa. La firma è di Claudio.**

---

## 🪪 IDENTITÀ

| campo | valore | fonte |
|---|---|---|
| EA | `mql5/Experts/ABTG_SuperWave_DAX_H4_Ottimizzato.mq5` — **v1.01** (post fix del lotto 08/09) | sorgente, `#property version "1.01"` · `report/FIX_LOTTO_PENDENTE_2026-09-08.md` file n.2 |
| Simbolo / TF | **D30EUR (DAX) H4** | `backtest_pipeline/REGISTRO_TEST.md` **riga 477** |
| Cella promossa | **`InpStMult 3.0` / `InpTP_RR 2.0`**, due lati accesi | idem · CSV Pass 1 |
| Numeri della cella | netto **+277,69** · PF **1,28456** · **DD 3,3245%** · **n 56** · 7/9 celle positive | `backtest_pipeline/risultati_archivio/SuperWave/valid_SuperWaveRT_D30EUR_H4_realtick.csv` riga `Pass 1` · `REGISTRO_TEST.md` r.477 e r.480 |
| Banco | **modello 4 (TICK REALI)**, deposito **10.000 EUR**, leva 100, **rischio 1,00%** | `backtest_pipeline/ini/valid_SuperWaveRT_D30EUR_H4.ini` |
| **Magic** | **770512** — default compilato del sorgente (riga 108), **assente da ogni censimento** | `FLOTTA_ATTIVA.md` r.46: *"NON IN CAMPO (770512: assente da censimenti ed Esperti 25/08 22:15)"* |
| Preset | 🆕 `mql5/Presets/ABTG_SuperWave_DAX_H4_770512.set` (scritto oggi) | — |
| **Conto** | **DEMO PICCOLO 50503392**, cartella `C:\Program Files\BCM Markets MT5 Terminal` (**SENZA** `-V3`) | `report/CORSIA_DEMO_REGOLE.md` |
| Guardian | `InpUsaGuardian=true` ma **sul piccolo il Guardian NON GIRA** → guardia **fail-open**, non protegge niente | decisione di Claudio 06-07/09, `HANDOFF.md` |
| Gemella già viva | **`ABTG_SuperWave_DOW_H1_Ottimizzato` 770511** — PF 1,52 · DD 4,0% · **n 227**, 9/9 celle positive | `REGISTRO_TEST.md` r.476 e r.479 |

### 🟢 IL RISCHIO DELLA CELLA **È MISURATO**, e l'ho trovato
Il mandato avvisava che *"il registro non dice a che `InpRiskPercent` è stata
misurata la cella"*. **C'è, in tre posti indipendenti fra loro:**
1. colonna `InpRiskPercent` del **CSV Pass 1** → `1`;
2. `valid_SuperWaveRT_D30EUR_H4.ini` → `InpRiskPercent=1.0||1.0||0||1.0||N` (asse **fisso**, non ottimizzato);
3. `REGISTRO_TEST.md` **riga 459** (intestazione della griglia) → *"entrambe le direzioni, **rischio 1%**"*.

👉 **Quindi il DD 3,3245% è il DD misurato a rischio 1,00% su deposito 10.000 EUR.**
La taglia proposta per la demo (**0,65%**) è invece il **metro firmato il 18/08**
(cap C1 3,25% = 5 SL vivi da 0,65%) — ed è **una PROPOSTA, non una misura**:
a 0,65% questa cella **non è mai stata girata**.

---

## 🔴 1. LA PRE-CONDIZIONE BLOCCANTE — **il lotto minimo**, e qui NON è teoria

Questa è la cosa più importante di tutta la scheda, e va letta prima dei numeri belli.

### I fatti misurati, uno per riga

| fatto | valore | fonte |
|---|---|---|
| `D30EUR` `CONTRACT_SIZE` | **10** → 1 lotto = **10 EUR per punto indice** | `backtest_pipeline/risultati_archivio/R114_CORSA_20260827/REFERTO_R114.txt` r.77 |
| `D30EUR` `VOLUME_MIN` / `VOLUME_STEP` | **0,10 / 0,10** → il lotto minimo vale **1 EUR per punto indice** | idem, r.78-80 |
| il codice **alza al minimo** il lotto calcolato dal rischio | `return(MathMax(mn,MathMin(mx,lot)));` | sorgente, riga **421** |
| saldo del piccolo 50503392 | **5.076,62** (equity 5.139,11) — ⚠️ **agli atti al 19/08, non riletto oggi** | `report/PAGELLA_2026-08-19.md` r.11 |

### L'aritmetica, in chiaro

`lotto = rischio_EUR / (SL_punti_indice × 10)` → perché il lotto **non** finisca
al minimo di 0,10 serve `SL_punti_indice ≤ rischio_EUR`.

| scenario | rischio in EUR | SL massimo per NON finire al minimo |
|---|---:|---:|
| demo piccolo, 5.100 EUR, **0,65%** | **33,15** | **33 punti indice** |
| demo piccolo, 5.100 EUR, 1,00% | 51,00 | 51 punti indice |
| **il tester che ha prodotto il 3,32%**, 10.000 EUR, 1,00% | 100,00 | **100 punti indice** |

🔴 **Lo stop di questo motore è un Supertrend `StMult 3,0 × ATR(10)` su H4 del
DAX. Il suo valore mediano in punti indice è NON MISURATO** (nessuna colonna nel
CSV, nessun referto lo riporta) — **ma su DAX H4 supera i 33 punti indice con
ogni evidenza, e molto probabilmente anche i 100.**

### 🩸 E NON È UN'IPOTESI: È GIÀ SUCCESSO, SU QUESTA FAMIGLIA E SU QUESTO CONTO
`report/DIARIO.md`, riga **20/08/2026** — `SW DOW H2` (magic **770531**, stesso
motore SuperWave, stesso piccolo 50503392):
> *"le due gambe sono da **0,10 lotti** su uno step 0,10, quindi il parziale non
> poteva esistere … i due lati insieme hanno perso **−72,32 su un bilancio di
> 5.076,62 = 1,42%** in una posizione sola, contro un contratto che dice **1,0%**."*

**Il lotto è finito al minimo, in campo, su questa famiglia, su questo conto.**
Il fix del lotto dell'08/09 toglie la gamba di troppo; **non toglie il pavimento
del lotto minimo**, che è del broker.

### ⚠️ LA CONSEGUENZA CHE CAMBIA IL CANCELLO — e va detta prima, non dopo
**Se il lotto va al minimo in tutti e due i posti** (tester e demo), la perdita
per trade **in EURO è la stessa**, ma il saldo del piccolo è **circa la metà**
del deposito del tester (5.100 contro 10.000). Quindi:

> **DD atteso sul piccolo ≈ 3,3245% × (10.000 / 5.100) = 6,52%**
> 🔴 **[DERIVATO DALL'ARITMETICA, NON MISURATO]**

E in quel regime **`InpRiskPercent` non controlla più niente**: 0,65 e 1,00
danno lo **stesso identico lotto** (0,10). Scriverlo nel preset resta giusto
— è la taglia dichiarata — ma **non è la taglia vera**.

### ✅ COME SI CHIUDE QUESTO BUCO — costa **una riga del Giornale**, non un round
L'EA con `InpVerbose=true` stampa (sorgente riga **272**):
```
[SuperWave] LONG mercato 0.10 lot @ 24123.40 SL 23890.10 TP 24590.00
```
Da quella riga si leggono **il lotto vero** e **lo stop vero**, e i due numeri
chiudono tutto. 👉 **Passo 8 delle istruzioni.** Finché non c'è, il DD promesso
va letto con questo cartello appeso.

---

## 🔴 2. IL CANCELLO DI RISCHIO — **dichiarato PRIMA, come chiede la firma del 18/08**

> # 🛑 **DD forward > 3,3% → REVISIONE IMMEDIATA.**
> Non "quando arriva al 10%". **Al numero promesso dal backtest della cella
> promossa**, che è **3,3245%** (`CSV Pass 1`, colonna `Equity DD %`).
> Criterio **RISCHIO** firmato il 18/08: *"per sedia, sempre, **a qualunque n**"*.
> Un drawdown è un fatto accaduto, e si legge anche a n=1.

**Spia anticipata:** 🔎 **2,16%** = 3,3245 × (0,65/1,00), la riscalatura lineare
alla taglia proposta — **[APPROSSIMATO, NON MISURATO]**, convenzione di casa
(`report/CENSIMENTO_CONTRATTI.md` §1.2). **Non è il cancello** (un DD stimato non
può essere una promessa di rischio): è la soglia a cui si guarda **prima**.

**Muri prop, per confronto:** 10% totale · 5% giornaliero
(`report/REGOLAMENTI_PROP_2026-09-08.md`). Il 3,32% ci sta larghissimo dentro;
il **6,52% derivato** del regime "lotto al minimo" ci sta ancora dentro, **ma è
il doppio del promesso** — cioè il cancello scatterebbe, e per un motivo che
**non è la strategia**. È esattamente per questo che il passo 8 esiste.

🔴 **Peggior giornata: NON MISURATA.** Il CSV non ha la colonna, nessun referto
la riporta. Con un muro prop **giornaliero** al 5% questo è un buco vero, e va
scritto ogni volta: *il DD del tester è un pavimento, il muro prop guarda il
flottante* (`R112`). Chi lo porta: §9, riga 1.

---

## ⚖️ 3. IL MERITO È **SOSPESO**, e la sedia NON si accende perché si crede che guadagni

> # 🔴 **n = 56. La regola di casa sospende il MERITO sotto le 150 operazioni.**
> **PF 1,28 su 56 trade NON è una promessa: è un indizio.**
> (Emendamento della Finestra §A + valvola R59, `CLAUDE.md`.)

**Si accende per MISURARE**, e le cose da misurare sono tre, tutte e tre
impossibili da avere dal tester:
1. 📊 **la FREQUENZA vera** (il numero che decide se la famiglia SuperWave arriva al pavimento di 1,00 op/giorno — oggi sta a **0,80**);
2. 🔩 **il LOTTO vero e lo STOP vero** in punti indice (§1: oggi **NON MISURATI**);
3. 🧾 **l'esecuzione vera** — fill, spread, slippage sul DAX H4 — che il tester non dà mai.

🚫 **Cosa NON si sta dicendo:** che il motore funzioni. Il DAX H4 **non è mai
stato smontato per lati**, e la famiglia SuperWave ha **due morti misurati**:
GBPUSD 770532 (PF 0,79 · DD 13,4% · 5/7 anni negativi, spenta il 24/08,
`R103_REFERTO_FINALE.md` pos.23) e il **lato short del Dow** (R110: PF OOS 0,429).

---

## 📅 4. COSA ASPETTARSI — la frequenza, con la finestra DICHIARATA

**La finestra del round ha due letture, e le do tutte e due** perché il `.ini`
chiede `FromDate=2024.01.01` ma il **pavimento misurato dei tick BCM sugli indici
è il 2024.09.26** (`RIPESCAGGIO_FREQUENZA_2026-09-08.md` §9).

| lettura della finestra | giorni feriali | op/giorno (56 / feriali) | **op/mese** (× 21,75) |
|---|---:|---:|---:|
| **NOMINALE** — quella scritta nel `.ini`: 2024.01.01 → 2026.06.30 | **652** | 0,0859 | **1,87** |
| **EFFETTIVA** — solo dove i tick veri esistono: 2024.09.26 → 2026.06.30 | **459** | 0,1220 | **2,65** |

_(I feriali li ho ricontati: 652 e 459. `CORSIA_DEMO_SUPERWAVE_DAX_H4.md` scrive
651 e 459 — differenza di un giorno sull'estremo, ininfluente. Uso la mia.)_

👉 **Uso la lettura EFFETTIVA — 2,65 op/mese ≈ 0,122 op/giorno** — perché è
quella su cui i tick esistono davvero, ed è la stessa che il censimento aveva già
usato (*"~2,7 op/mese = 0,12 op/gg"*, `CORSIA_DEMO_CANDIDATI.md` §2 G4).
⚠️ **Incertezza dichiarata: fra le due letture c'è un 40%.**

### Le due date che servono in agenda

| momento | feriali dal 09/09 | operazioni attese |
|---|---:|---:|
| **1° ottobre 2026** (la data del mandato) | 16 | 🔴 **~2** |
| **08/03/2027** (tagliando 6 mesi) | 129 | **~16** |

> ### 🔴 LA RIGA ONESTA SUL 1° OTTOBRE
> **Questa sedia, accesa oggi, al 1° ottobre avrà fatto DUE operazioni.**
> Non è una sedia che "si prepara per la challenge": è una sedia che **inizia a
> raccogliere un dato** che oggi non abbiamo. Chi la accende sperando che aggiunga
> portata entro ottobre sta guardando il numero sbagliato.

### 🔴 E IL TRAGUARDO n=150 **NON È RAGGIUNGIBILE** — l'argomento del NO del 07/09

| lettura del traguardo | feriali necessari | durata | data |
|---|---:|---:|---|
| **A** — il forward da solo arriva a 150 | 1.229 | **56,5 mesi** | ~**maggio 2031** |
| **B** — il `n` della cella (56 + 94 forward) arriva a 150 | 770 | **35,4 mesi** | ~**agosto 2029** |

❌ **Anche la lettura più favorevole dà 2,9 anni, contro il tetto di ~18 mesi
della corsia demo** (`CORSIA_DEMO_REGOLE.md`, punto 2: *"Se la stima dice 4 anni,
la sedia non entra"*). **Questo è, alla lettera, il motivo del NO del 07/09, e
non l'ho addolcito.**
👉 **La proposta di oggi è di accenderla per il §3 (frequenza, lotto, esecuzione),
non per il traguardo n=150.** È un cambio di domanda, ed è **una decisione, non
un calcolo**: per questo sta in `DA_FIRMARE.md` e non in un referto.

---

## 🖥️ 5. IL CONTO E LA CARTELLA, IN CHIARO — regola dei terminali multipli (06/09)

| | |
|---|---|
| ✅ **SI TOCCA** | **conto 50503392** (demo piccolo) · cartella **`C:\Program Files\BCM Markets MT5 Terminal`** (SENZA `-V3`) |

### 🛑 I DUE TERMINALI DA **NON** TOCCARE

| conto | cartella programma | perché |
|---|---|---|
| ⛔ **50504263** (demo 100k) | `C:\Program Files\BCM Markets MT5 Terminal -V3` | è il dry-run del Guardian: una sedia in più falsa la misura |
| ⛔ **10105439** (**REALE**) | `C:\BCM_Reale` | 🔴 **soldi veri**, e il mandato lo riserva a Claudio |

### 🔎 IL RICONOSCIMENTO NON SI FA "A OCCHIO"
Prima di trascinare qualunque cosa, in **PowerShell** (sola lettura):
```powershell
Get-Process terminal64 | Select-Object Id, MainWindowTitle, Path
```
La riga giusta è quella il cui `Path` contiene **`BCM Markets MT5 Terminal\terminal64.exe`**
**senza** `-V3` e **senza** `BCM_Reale`. 📌 *Il 06/09 un attacco EA destinato al
piccolo è stato quasi fatto sul terminale del REALE: questa riga esiste per quello.*

---

## 🔧 6. I PASSI MANUALI IN MT5 — numerati, uno per riga

> ⏱️ Tempo stimato: **20-30 minuti**, di cui metà è l'attesa della compilazione.
> 🛑 **Nessuno di questi passi tocca una sedia viva.** Si apre un grafico NUOVO.

1. Aprire **PowerShell** e lanciare `Get-Process terminal64 | Select-Object Id, MainWindowTitle, Path`. **Annotare il PID** del terminale il cui `Path` è `C:\Program Files\BCM Markets MT5 Terminal\terminal64.exe`.
2. Portare in primo piano **quel** terminale — conto **50503392**. Controllare in alto a sinistra, scheda **Navigatore → Conti**, che il numero sia **50503392**.
3. Scaricare il preset dal branch `lavoro` sul VPS (sola scrittura di UN file nuovo, in una cartella di preset):
   `irm https://raw.githubusercontent.com/<repo>/lavoro/mql5/Presets/ABTG_SuperWave_DAX_H4_770512.set -OutFile "$env:APPDATA\MetaQuotes\Terminal\215D85D767A1C39E22D242C8114BF9F5\MQL5\Presets\ABTG_SuperWave_DAX_H4_770512.set"`
   ✅ **La cartella dati del piccolo è MISURATA, non indovinata**: `215D85D767A1C39E22D242C8114BF9F5` → `programma: C:\Program Files\BCM Markets MT5 Terminal`
   (`backtest_pipeline/coda/referti/CODA_01_sedie_attaccate_20260908_033003.log` righe 11-12).
   ⚠️ Se la riga di verifica del §7 stampasse un altro ID per quel programma, **vale quello che stampa lei**.
4. Aggiornare il sorgente **`ABTG_SuperWave_DAX_H4_Ottimizzato.mq5`** dal branch `lavoro` in `MQL5\Experts\`. 🔴 **Serve davvero**: la versione col fix del lotto è la **1.01** dell'08/09, e sul VPS può esserci la **1.00**.
5. Aprire **MetaEditor** (F4 dal terminale del **50503392**), aprire `ABTG_SuperWave_DAX_H4_Ottimizzato.mq5`, premere **F7**. ✅ Atteso: **0 errori**. Nel Navigatore l'EA deve mostrare **versione 1.01** (tasto destro → Proprietà, oppure la riga di avvio nel Giornale).
6. Nel terminale **50503392**: **Vista → Finestra di mercato**, click destro su **D30EUR → Grafico**. Impostare il timeframe su **H4**.
   🔴 **DEVE ESSERE UN GRAFICO NUOVO.** Sul piccolo gira già `ABTG_SupRev_DAX_H4_Ottimizzato` **su un D30EUR H4**, nella stessa cartella dati `215D85…` (`backtest_pipeline/coda/referti/CODA_02_chi_ha_operato_20260908_033003.log` r.56). **Quel grafico non si tocca**: si aggiunge una finestra, non si sostituisce una sedia viva.
   📌 Il profilo attivo del piccolo si chiama **`ORO`** e ha **52 sedie** (CODA_01 08/09 r.13 e r.96): 770512 **non è fra queste** (`grep 770512` su quel log → **0 occorrenze**).
7. Trascinare **`ABTG_SuperWave_DAX_H4_Ottimizzato`** dal Navigatore sul grafico D30EUR H4. Nella finestra che si apre:
   a. scheda **Comune** → spuntare **"Consenti trading algoritmico"**;
   b. scheda **Parametri di input** → **Carica** → scegliere **`ABTG_SuperWave_DAX_H4_770512.set`**;
   c. verificare a schermo, prima di premere OK, queste **sei righe**: `InpTF = 16388 (H4)` · `InpStMult = 3.0` · `InpTP_RR = 2.0` · `InpRiskPercent = 0.65` · `InpMagic = 770512` · `InpAllowLong = true` **e** `InpAllowShort = true`;
   d. **OK**.
8. 🔴 **PASSO CHE NON SI SALTA — leggere il Giornale/Esperti.** Scheda **Strumenti → Esperti**: deve comparire `[SuperWave] avviato…`. **Alla PRIMA operazione**, cercare la riga `[SuperWave] LONG|SHORT mercato X.XX lot @ … SL … TP …` e **annotare `X.XX` e la distanza `entry − SL` in punti indice**. È la misura della pre-condizione §1. *(Ricorda: l'ora del log è **locale = italiana**, il grafico è in **ora server BCM = italiana − 1**.)*
9. **File → Profili → Salva.** ⚠️ Senza questo passo la riga di verifica del §7 **non vede la sedia**: i `.chr` si aggiornano solo al salvataggio del profilo.
10. Lanciare la riga di verifica del §7 e **incollare l'output in chat**. Da quel momento la sedia è a verbale.
11. Scrivere **DD promesso (3,32%)** e **frequenza promessa (2,65 op/mese ≈ 0,122 op/gg)** in `report/CENSIMENTO_CONTRATTI.md`. 🔴 **Prerequisito del 18/08: senza il contratto scritto, il criterio di uscita NON è applicabile** (§8).

---

## 🔎 7. LA RIGA DI VERIFICA **DOPO** L'ACCENSIONE — sola lettura

📄 `backtest_pipeline/righe/VERIFICA_SW_DAX_770512.ps1`
_(costola di `backtest_pipeline/righe/CODA_01_sedie_attaccate.ps1` v2: stessa
lettura condivisa dei `.chr`, stessa separazione **profilo attivo / residui su
disco**, stessa funzione `TF`. Cambia il filtro — un magic solo — e aggiunge il
blocco che stampa PID + titolo + cartella dei terminali.)_

**Da lanciare sul VPS, in PowerShell:**
```powershell
irm https://raw.githubusercontent.com/<repo>/lavoro/backtest_pipeline/righe/VERIFICA_SW_DAX_770512.ps1 -OutFile "$env:TEMP\VERIFICA_SW_DAX_770512.ps1"; powershell -ExecutionPolicy Bypass -File "$env:TEMP\VERIFICA_SW_DAX_770512.ps1"
```

**Cosa stampa:** i terminali in esecuzione (PID + titolo + `Path`), poi — per
ogni cartella dati — se il magic **770512** è attaccato, **su quale programma**,
con che **simbolo, TF, `InpRiskPercent`, `InpStMult`, `InpTP_RR`, `InpAllowLong/Short`**,
separando il **profilo attivo** dai **residui su disco**.

**Come si legge l'esito:**
- `0` nel profilo attivo → **non è attaccata**, oppure il profilo non è stato salvato (passo 9);
- `1` nel profilo attivo → giusto. Controllare che sia **D30EUR**, **H4** e `InpRiskPercent` = la taglia firmata;
- `2 o più` → **due istanze sullo stesso magic**: è un errore, se ne spegne una.

✅ **Sintassi già verificata** con
`pwsh -NoProfile -Command '[System.Management.Automation.Language.Parser]::ParseFile(...)'` → **OK**.
✅ **ASCII puro verificato** (`grep -P '[^\x00-\x7F]'` → zero righe): regola dei
`.ps1` del 17/08.
🔴 **Il limite dichiarato**, identico a quello della CODA_01: la riga legge i
`.chr`, e i `.chr` si aggiornano **solo quando MT5 salva il profilo**. Se non
compare niente, la prima ipotesi è *"profilo non salvato"*, non *"EA non attaccato"*.

---

## 🔌 8. COSA LA SPEGNE — le tre corsie del criterio di uscita del **18/08**

### 🩸 Corsia **RISCHIO** — per sedia, **sempre**, a qualunque n
| # | trigger | dove si guarda | azione |
|---:|---|---|---|
| 1 | **DD > 3,32%** (spia a 2,16%) | equity 50503392, magic **770512** | 🔴 **revisione immediata** |
| 2 | **una giornata peggiore di −5,0%** | muro prop giornaliero | ⛔ **spegnimento**, non revisione |
| 3 | **il lotto risulta 0,10 e lo stop > 33 punti indice** | riga `[SuperWave] … mercato X.XX lot` (passo 8) | 🟠 **la taglia non è quella dichiarata**: il cancello 1 misurerebbe un'altra cosa → si ritara o si spegne |
| 4 | **opera su simbolo ≠ D30EUR, TF ≠ H4, o magic ≠ 770512** | riga di verifica §7 | ⛔ **spegnimento immediato**: preset caricato male o grafico sbagliato |
| 5 | **compaiono due istanze sullo stesso magic** | riga di verifica §7 | ⛔ spegnimento di una delle due |

### ⚖️ Corsia **MERITO** — per **FAMIGLIA**, a 20 operazioni
La famiglia SuperWave in campo è **770511 (Dow H1)** + **770531 (H2)** + questa.
Se la famiglia arriva a **20+ operazioni totali in perdita** → revisione di tutte
le sedie, e **si spegne la SEDIA colpevole**, non la famiglia (lezione PTE:
GBPUSD no, USDJPY sì).
> ❄️ **Ma il merito della SINGOLA sedia a n=20 NON la spegne**, ed è la
> definizione stessa della corsia demo: a n=20 il merito è rumore, non misura.
> **È l'unica riga di questa scheda che allenta qualcosa, ed è in chiaro.**

### 🗓️ Corsia **TAGLIANDO** — data fissa **08/03/2027**
Si guarda **comunque**, anche se n non è arrivato (attese **~16 operazioni**).
Si legge in quest'ordine:
1. **DD reale** contro **3,32%** promesso (e la spia a 2,16%);
2. **frequenza reale** contro **2,65 op/mese** promesse — 🎯 **è il numero per cui la sedia è accesa**. Se è molto sotto il promesso → revisione (corsia tagliando, 18/08);
3. **i due lati separati** (long vs short), che su questa cella **non hanno mai avuto un numero proprio**;
4. il **PF**, sapendo che a n≈72 totali **il merito resta sospeso**: non è un verdetto, è un aggiornamento.

🎁 **Il tagliando cade lo stesso giorno di `NY SESSION RETEST` e `RELATIVO NASUSD`:
tre sedie demo, UNA data in agenda.**

---

## 🛑 9. LA CORSIA DEMO **NON È UNA PORTA VERSO IL CONTO REALE**

Testuale da `report/CORSIA_DEMO_REGOLE.md`:
> _Una sedia che va bene in demo **non passa in campo in automatico**: torna in
> coda all'imbuto con il suo n finalmente pieno, e da lì si giudica col merito,
> come tutti. Il passaggio ai soldi veri resta una **firma specifica su un numero
> misurato**._

Questa sedia gira su **DEMO 50503392**, costa **zero euro**. Il **reale 10105439**
e il **100k 50504263** non c'entrano e non si toccano.

---

## ⚠️ 10. COSA QUESTA SCHEDA **NON** COPRE — dichiarato prima, non dopo

1. 🔴 **L'EA che ha misurato NON è l'EA che si schiera.** Il `.ini` dice `Expert=ABTG_SuperWave.ex5` e il CSV porta `InpMagic=770501`: ha girato l'**EA base**. Il derivato `_DAX_H4_Ottimizzato` è un **file separato** e **nessuno ha mai verificato che riproduca il numero del padre**. *(Rilievo già agli atti: `CORSIA_DEMO_SUPERWAVE_DAX_H4.md` §3 punto 1.)*
2. 🔴 **Il fix del lotto dell'08/09 cambia il comportamento.** La cella è del 26/07, misurata col codice **v1.00** (bug della tranche); si schiera la **v1.01**. Il `FIX_LOTTO` lo dice testualmente: *"Le curve di backtest delle celle promosse su questi motori **cambieranno** — chi le riproduce deve saperlo."* **Il forward non è bit-identico alla cella.**
3. 🔴 **Peggior giornata: NON MISURATA** (§2). Con un muro prop **giornaliero** al 5%, è il buco più scomodo della scheda.
4. 🔴 **I DUE LATI non sono mai stati smontati** su questa cella — e la regola del 25/08 sugli indici lo chiede. La famiglia ha **uno short morto misurato** sul Dow (R110, PF OOS 0,429).
5. 🔴 **UN SOLO REGIME.** Tutto il tick BCM sugli indici sta in **21 mesi di toro** (pavimento 2024.09.26). Emendamento della Finestra: regola **C — prova di regime — NON soddisfatta**. E il forward parte **dentro lo stesso toro**: non aggiunge un regime, aggiunge campione.
6. 🔴 **Tre input non esistevano quando la cella è stata misurata**: `InpUsaGuardian`, `InpPendingAtr`, `InpSLBufferAtr` non hanno colonna nel CSV. Nel preset stanno ai default **neutri** — ma è un'**inferenza dal codice**, non un dato del banco.
7. 🔴 **Il tetto per cluster/valuta al 3,0%** è firmato il 07/09 ma **implementato spento, non compilato e non collaudato**: **non è una protezione**. E questa sedia mette **un secondo motore sul D30EUR** (c'è già `SupRev_DAX_H4`): il **cumulo di rischio sul DAX non è misurato**.
8. 🔴 **Il Guardian non gira sul piccolo**: `InpUsaGuardian=true` è **fail-open**. Il cap C1 3,25% su questo conto **non è attivo**.
9. 🔴 **Il saldo del piccolo è agli atti al 19/08** (5.076,62). Tutta l'aritmetica del §1 va **rifatta col saldo di oggi**, che è una lettura da un minuto.
10. 🔴 **La famiglia SuperWave resta SOTTO il pavimento anche con questa sedia dentro**: 0,50 + 0,18 + 0,12 = **0,80 op/giorno** contro 1,00. Il ripescaggio **lo avvicina, non lo chiude** (`RIPESCAGGIO_FREQUENZA_2026-09-08.md` §2 R1).

---

## 📮 11. COSA MANCA E CHI LO PORTA

| # | buco | chi | domanda esatta |
|---:|---|---|---|
| 1 | **peggior giornata** della cella `StMult 3,0 / TP_RR 2,0` | 🤖 agenti (round corto, EA già scritto) | *"qual è la peggior giornata sull'equity di quella cella su D30EUR H4, modello 4?"* |
| 2 | **stop mediano in punti indice** + **lotto effettivo** del tester | 🤖 agenti (stessa corsa del n.1) | *"qual è la distanza mediana `entry−SL` in punti indice, e che lotto ha usato il tester a 10.000 EUR / 1%?"* — 🎯 **è il numero che chiude la pre-condizione §1 senza aspettare il forward** |
| 3 | **i DUE LATI** della cella (regola 25/08) | 🤖 agenti | *"cosa fa il lato short da solo su D30EUR H4 a `StMult 3,0 / TP_RR 2,0`?"* |
| 4 | **riproduzione della cella col derivato** `_DAX_H4_Ottimizzato` | 🤖 agenti | *"il derivato dà lo stesso numero del padre `ABTG_SuperWave.mq5`, al centesimo, sulla stessa `.ini`?"* Se no, **il 3,32% non è il DD di questa sedia** |
| 5 | **frequenza di `SuperWave NASUSD H1`** | 🤖 agenti | *"quante op/giorno fa la cella NASUSD H1 sulla finestra 2024.09.26 → 2026.06.30?"* — 🎯 **è il numero che decide se la famiglia SuperWave arriva a 1,00** |
| 6 | **saldo di oggi del piccolo 50503392** | 👤 Claudio (un minuto) | scheda Trading del terminale del piccolo |
| 7 | 🖊️ **LA DECISIONE** | 👤 **Claudio, e solo lui** | *"si accende? e a che taglia — **0,65%** (metro firmato) o **1,00%** (taglia misurata)? e con magic **770512** o **770513**?"* |

---

## ✅ 12. IL VERDETTO CHE PROPONGO — e i suoi confini

🟢 **SÌ, si accende — ma per la domanda del §3, non per il traguardo del §4.**

- 🟢 **Il RISCHIO ha un numero misurato a tick reali** — **DD 3,32%** contro il muro prop del 10% — ed è **più basso di quello della gemella già viva** (770511, DD 4,0%).
- 🟢 **Costa mezz'ora**: EA scritto, magic assegnato, preset scritto oggi, riga di verifica scritta e già passata al parser. **Zero round, zero euro.**
- 🟢 **La gemella 770511 gira già** con **n 227 · PF 1,52 · 9/9 celle positive**: non è un motore sconosciuto, è **un secondo simbolo di un motore che già gira**.
- 🟠 **Ma il merito è SOSPESO** (n=56) e **al 1° ottobre avrà fatto 2 operazioni**.
- 🔴 **E il traguardo n=150 resta fuori portata (2029-2031)**: il NO del 07/09 su quel punto **non è stato smontato, è stato messo da parte cambiando la domanda.** Se Claudio non accetta il cambio di domanda, **il NO del 07/09 è ancora la risposta giusta**, e questo pacchetto resta in cartella senza costare niente.

---

## 📝 CHANGELOG

| data | cosa | perché |
|---|---|---|
| **08/09/2026** | Prima stesura. Preset `ABTG_SuperWave_DAX_H4_770512.set` e riga `VERIFICA_SW_DAX_770512.ps1` scritti insieme a questa scheda. | Riga **6** di `report/DA_FIRMARE.md` + raccomandazione 1 della "VERIFICA DI CLAUDE" in `RIPESCAGGIO_FREQUENZA_2026-09-08.md`. |
| **08/09/2026** | 🔴 **Aggiunta la pre-condizione del lotto minimo (§1)**, che nei documenti precedenti **non c'era**. | L'aritmetica `CONTRACT_SIZE 10 / VOLUME_MIN 0,10` (R114) più il caso misurato del 20/08 su `SW DOW H2` mostrano che il lotto va al minimo e che **il DD in % sul piccolo può essere il doppio del promesso**. È un fatto di rischio: va davanti, non in fondo. |
| **08/09/2026** | Trovato e documentato **`InpRiskPercent = 1,0` della cella** in tre fonti indipendenti. | Il mandato lo dava per mancante nel registro: c'è, ed è misurato. |

---

_🛑 **Questo documento PREPARA, non esegue.** Nessun EA è stato compilato,
attaccato, spento o modificato. Nessuna sedia viva è stata toccata. Nessun
backtest è stato lanciato. **La firma è di Claudio.**_
