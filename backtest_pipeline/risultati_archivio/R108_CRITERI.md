# ✍️ R108 — BREAKING BAND SU **M15** (GBPUSD · EURUSD · AUDUSD) — CRITERI **FIRMATI**

> 🖊️ **FIRMA: "FIRMO CON PROPOSTE" — Claudio, 25/08/2026.** Le sei decisioni
> del § 10 valgono come proposte: **D1** metro G0 a OHLC come R103, **D2** la
> profondità dei tick si MISURA PRIMA, **D3** finestre 2+2 anni, **D4** spread
> 1,5 pip dichiarato `[SPREAD NON MISURATO]`, **D5** il simbolo che fallisce
> S0/G0 si chiude da solo e gli altri proseguono, **D6** niente celle M5.
> Firma a numeri non visti. La corsa vera si lancia con `-CriteriFirmati`
> (il file al pin de7134e porta ancora `[DA FIRMARE]`: il flag è la
> registrazione della firma, questo documento ne è il verbale).

> 🔒 **Il titolo porta `[DA FIRMARE]` e non è decorazione.** Il driver
> `righe/RIGA_R108_BB_M15.ps1` **scarica questo file al pin e ci cerca dentro
> quella stringa**: se la trova, il **giro a vuoto parte lo stesso** (non apre
> MT5, non produce nessun numero) ma la **CORSA VERA si ferma con `exit 2`**,
> a meno che Claudio non passi `-CriteriFirmati`, che è la sua firma in riga e
> finisce **scritta nel referto**.
>
> **Sono SEI decisioni, tutte con la proposta già scritta (§ 10).** Si può
> rispondere `FIRMO CON PROPOSTE` in una riga.

---

## 0. 📌 DA DOVE NASCE — e cosa **non** è

**Mandato di Claudio (25/08/2026):** _"Dobbiamo avere più strategie su TF 5 min
e 15 min. Ci servono per la challenge."_

La caccia del 25/08 (`caccia_strategie/CACCIA_M5M15_FOREX_ORO_2026-08-25.md`,
promosso **P1**) ha proposto `ABTG_BreakingBand` **a M15** perché è l'unico
candidato **a ZERO righe di codice**: `InpTF` è già un `input` del sorgente
(riga 213) e i quattro handle indicatore lo usano già (righe 415-423).

🎯 **E a dirci di guardare lì è la NOSTRA fonte del motore**, non il web —
`prove/BREAKING_BAND_TESI.md`, **riga 17**, sezione _"I PARAMETRI (citazioni
verificate)"_:

> **`- TF: dimostrata su tutti; operativita' M5/M15.`**

Mentre lo **stesso file**, riga 103, dice che i criteri di promozione congelati
il 12/08 partivano da _"screening OHLC multi-simbolo **H1 (poi H4)**"_.
👉 **H1 è stata una scelta di comodità nostra, non una misura.** Verificato:
`R33`, `R94`, `R102` e `R103` hanno **tutti** `InpTF=16385` (= `PERIOD_H1`).
**Il ramo M5/M15 non è stato bocciato: non è stato misurato.**

### 🟢 Perché NON è "parametri diversi di un motore morto" (clausola della SECONDA CACCIA)

Il motore **è vivo e misurato**, `R103_REFERTO_DRIVER_FOREX_METALLI_20260824_1922.txt`
TABELLA 1 (finestra 2020.01.01→2026.06.30, **modello 1 = OHLC M1**, deposito
100.000, `Spread=0`, rischio 1,0%):

| simbolo | `InpPatternMode` VIVO | profitto | PF | DD % | n | prima operazione |
|---|---|---:|---:|---:|---:|---|
| **GBPUSD** | **2** (entrambi) | +5.415 | **1,199** | 7,75 | **126** | 2020.01.14 |
| **EURUSD** | **0** (solo CONTINUAZIONE) | +8.271 | **1,936** | 2,51 | **59** | 2020.02.03 |
| **AUDUSD** | **1** (solo INVERSIONE) | +5.365 | **1,541** | 2,13 | **64** | 2020.02.05 |

### 🔴 I DUE DIFETTI DEL FILE PROVA DEL CACCIATORE — trovati verificandolo, corretti e dichiarati

Il file `prove/R108_BB_M15_FOREX.txt` era dato per pronto (`controlla_prova.py`
ESITO OK). **`controlla_prova.py` fa tre controlli sintattici, non conosce la
storia del repo**: i due difetti gli sono passati sotto il naso, ed erano
entrambi fatali per il significato del round.

| | difetto | come è stato trovato | correzione |
|---|---|---|---|
| **1** | `InpMagic=760030/760031` dichiarato *"serie 76xxxx VERGINE"*. **È la coppia con cui R103 ha girato BreakingBand su EURUSD** (`prove/R103_ABTG_BreakingBand_EURUSD_772162.txt`) | `grep -rno '7600[0-9][0-9]'` su tutto il repo: **9 occorrenze** di `760030` | blocco **762xxx**, verificato **VERGINE** (zero occorrenze in tutto il repo, 25/08) |
| **2** | `InpPatternMode=2` per tutti e tre, con la frase _"la stessa identica cella (unico input diverso: InpTF)"_. **FALSO su due simboli su tre** | `diff` fra i tre file prova di R103: GBPUSD **2**, EURUSD **0**, AUDUSD **1** | ogni cella pinna il **pattern VIVO del suo simbolo** |

⚠️ **Il difetto 2 è quello che avrebbe fatto più danno, ed è invisibile a
occhio**: su EURUSD e AUDUSD il round non avrebbe misurato *"lo stesso motore a
M15"*, avrebbe misurato **UN ALTRO MOTORE**, e il confronto con R103 non
sarebbe esistito. La tabella sarebbe uscita perfetta e non avrebbe risposto
alla domanda.

📌 **E mancava il METRO.** Senza una cella che riproduce i numeri di R103,
*"M15 va male"* e *"il banco è storto"* sono **indistinguibili**. R108 aggiunge
tre celle H1 apposta (§ 5, G0).

---

## 1. 🧭 IL METODO — **sei celle, un asse solo**

Per ogni simbolo, **due celle**, e fra loro cambia **`InpTF` e nient'altro**:

| cella | TF | `InpTF` | finestra | modello | ruolo |
|---|---|---|---|---|---|
| `00_metroH1` | H1 | 16385 | 2020.01.01 → 2026.06.30 | **1 (OHLC M1)** | **IL METRO** — riproduce R103 (gate G0) |
| `01_m15` | M15 | **15** | 2022.07.01 → 2026.06.30 | **4 (TICK REALI)** | **LA MISURA NUOVA** del round |

### 1.1 Come è garantita l'attribuzione — è **verificata dal codice**, non promessa

Il driver, **prima di aprire MT5**, pretende su ogni file:

- **GATE DELLA STELLA**: la cella `01_m15` differisce dalla `00_metroH1` dello
  stesso simbolo **esattamente su `InpTF`** (più `InpMagic`), e su **nessun
  altro input**. Non basta *contare* le righe diverse: due righe **sbagliate**
  darebbero lo stesso conteggio;
- **GATE DEI VALORI**: `InpTF` vale **davvero** 16385 nella prima e **15** nella
  seconda, e `InpPatternMode` vale **il pattern vivo di quel simbolo**. Se i
  file di due simboli fossero scambiati, la stella resterebbe verde e questo no
  (checklist **34-bis**);
- **GATE DELL'ASSE UNICO**: un solo flag `Y` per file, ed è `InpMagic`. Più di
  un asse sarebbe una **griglia**, cioè un altro round;
- **GATE DEI MAGIC**: unici fra i file, **vergini**, e mai un magic vivo o di un
  round precedente (`760xxx` = R103, `761xxx` = R107, `77xxxx` = sedie vive);
- **`@SIMBOLO` / `@PERIODO` / `@DAQUANDO`** confrontati, non creduti.

### 1.2 ⚙️ Come gira ogni cella — **tre lanci, e ognuno risponde a una domanda diversa**

È la macchina di **R103**, non una macchina nuova (checklist 9: una riscrittura
non può perdere le funzioni del gemello):

| lancio | `.ini` | cosa produce | a cosa serve |
|---|---|---|---|
| **SINGOLA** sulla finestra INTERA | `Optimization=0`, `Report=` | il **report `.htm` coi DEAL** (Ora, Direzione, Tipo, Volume, **Prezzo**, Profitto, Commissioni, Swap) | **TUTTO IL PASSO 0**: prima operazione, take realizzato in pip, durata in barre, peggior giornata |
| **GEMELLE** sulla finestra INTERA | `Optimization=1`, sweep su `InpMagic` | `OptResults_*.csv` via **OPTFRAME** | **profitto / PF / DD equity / n** — e il **gate G0** |
| **GEMELLE** su **IS** e su **OOS** (solo celle M15) | idem | due CSV | i cancelli **S1 · S2 · S3** |

**Passate**: metro H1 = 1 + 2 = **3**; cella M15 = 1 + 2 + 2 + 2 = **7**.
Totale **(3 + 7) × 3 simboli = 30 passate**.

> ⚠️ **Perché la SINGOLA e non solo l'ottimizzazione, e non è burocrazia.**
> `OptResults` dà **numeri di riepilogo**. Il PASSO 0 chiede **il take in pip** e
> **la durata in barre**: sono grandezze **per operazione**, e l'unico artefatto
> che le contiene con **entrambi i prezzi** (ingresso *e* uscita) è la tabella
> Deal del report `.htm`. Il file per-trade dell'EA
> (`abtg_trades_*.csv`, scritto da `ExportTrades()` in `OnTester`) **NON basta**:
> misurato nel sorgente il 25/08, scrive **solo i deal di uscita** — niente
> prezzo d'ingresso, quindi **nessun take calcolabile**. È la **traduzione
> dichiarata** che la checklist **57** impone: *(1)* lo strumento nominato nel
> file prova non può produrre la misura, *(2)* la misura si fa **qui**, *(3)*
> l'intento — *"letto dalle serie per operazione, non dal riepilogo"* — **è
> conservato**.

---

## 2. 🧊 LE SEI CELLE E I MAGIC

Blocco **762xxx**, **VERGINE** — `grep -rn '7620[0-9][0-9]'` su tutto il repo:
**zero occorrenze** (l'unico hit è `…762052196` dentro una correlazione in un
JSON di snapshot: non è un magic). Verificato il 25/08/2026.

| simbolo | cella | file prova | `InpPatternMode` | base | gemelle INTERA | singola | gemelle IS | gemelle OOS |
|---|---|---|:--:|---:|---|---|---|---|
| GBPUSD | `00_metroH1` | `R108_GBPUSD_00_metroH1.txt` | **2** | 762000 | 762000/762001 | 762002 | — | — |
| GBPUSD | `01_m15` | `R108_GBPUSD_01_m15.txt` | **2** | 762010 | 762010/762011 | 762012 | 762014/762015 | 762016/762017 |
| EURUSD | `00_metroH1` | `R108_EURUSD_00_metroH1.txt` | **0** | 762020 | 762020/762021 | 762022 | — | — |
| EURUSD | `01_m15` | `R108_EURUSD_01_m15.txt` | **0** | 762030 | 762030/762031 | 762032 | 762034/762035 | 762036/762037 |
| AUDUSD | `00_metroH1` | `R108_AUDUSD_00_metroH1.txt` | **1** | 762040 | 762040/762041 | 762042 | — | — |
| AUDUSD | `01_m15` | `R108_AUDUSD_01_m15.txt` | **1** | 762050 | 762050/762051 | 762052 | 762054/762055 | 762056/762057 |

📌 **Perché un magic diverso per ogni lancio** (pattern R103): l'EA scrive un
file per-trade `abtg_trades_<EA>_<Simbolo>_<magic>.csv` in `Common\Files`, e
`FILE_WRITE` **tronca**. Con lo stesso magic su tre lanci resterebbe solo
l'ultimo, e nessuno saprebbe di quale finestra è.

**Rischio: `InpRiskPercent=1.0`** in tutti e sei i file — è la **taglia viva**
di R103, ed è il denominatore della normalizzazione. ⚠️ **In campo sul 100k le
sedie girano allo 0,65%**: ogni DD di questo referto va **moltiplicato per
0,65** prima di confrontarlo col forward. Chi salta la conversione confronta
due cose diverse.

---

## 3. 🚨 IL **CANCELLO ZERO (S0)** — il costo, e si legge PRIMA di qualunque PF

È **la domanda del primo test** del dossier, ed è il cancello che decide se
questo round esiste.

### 3.1 Perché il take si accorcia e lo spread no

Il TP di questo motore **è la mediana delle bande** (`InpTPMode=0`, mediana
secca, aggiornata a ogni barra). La semi-ampiezza di BB(20,2) scala **circa con
√(rapporto di TF)**: 4 barre M15 = 1 barra H1 → **√4 = 2**, cioè a M15 il
bersaglio è **circa la metà** di quello a H1. **Lo spread resta lo stesso.**
[INFERITO dall'aritmetica, **NON MISURATO**]

### 3.2 🔴 E NON È UN'IPOTESI: **abbiamo già visto un take da 2,5 pip, DAL VIVO, e a H1**

`report/DIARIO.md`, pagella del **2026-08-20**, riga verbatim:

> _"`BB GBPUSD INV S` **`tp`** ma con un bersaglio da **2,5 pip** raggiunto in
> 10 ore, prima comparsa in pagella."_

👉 **Questo è un FATTO ACCADUTO, su H1, sulla sedia viva.** Se a H1 un take può
valere 2,5 pip, a M15 — dove il bersaglio è circa la metà — **il cancello zero
non è una formalità: è la domanda vera del round.**

### 3.3 ⚠️ E il backtest da solo NON risponde, ed è il punto che va capito

Qualcuno obietterà: *"se il backtest paga già lo spread e il PF esce > 1, il
costo è già dentro"*. **È vero solo a metà, e la metà che manca è quella che
conta:**

- a **modello 1 (OHLC M1)** l'`.ini` scrive `Spread=0` = **spread CORRENTE del
  feed**, cioè **un solo numero, quello che il terminale aveva in memoria
  all'ultima connessione, applicato a sei anni e mezzo di storia**. Non è lo
  spread storico: è una fotografia;
- a **modello 4 (tick reali)** il bid/ask arriva dai tick, quindi lo spread **è**
  storico e variabile — **se i tick reali ci sono davvero** (vedi § 4.2);
- in nessuno dei due casi c'è **slippage**, e in nessuno dei due c'è
  l'allargamento notturno o da news.

🎯 **Perciò S0 non chiede "il backtest è positivo?": chiede "quanto è SOTTILE il
margine su cui il backtest è positivo?".** Un motore che guadagna con un take
mediano di 3 pip contro 1,5 di spread **vive dentro la variabilità del costo**,
e quello il tester non lo simula.

### 3.4 Le tre misure del PASSO 0 — **definite ORA, prima dei numeri**

Tutte lette dalla tabella **Deal del report `.htm`** della passata SINGOLA,
accoppiando i deal `in` → `out` (con `InpMaxPositions=1` la sequenza è
alternata; **se non lo fosse, la misura si dichiara NON MISURATA e non si
stima**).

**S0a — IL TAKE. 🔴 CANCELLO, per simbolo.**

- `take_netto_pip` = `|prezzo_out − prezzo_in| / 0,0001` sulle operazioni
  **VINCENTI** (netto = Profitto + Commissioni + Swap > 0).
  📌 **È già AL NETTO dello spread**, e non è un dettaglio: per un long il
  prezzo d'ingresso è l'**ask** e quello d'uscita è il **bid**, cioè i due lati
  del book. Il costo è **dentro** quella differenza.
- `take_lordo_pip` = `take_netto_pip + spread_dichiarato`.
- **CONDIZIONE**: **mediana** di `take_lordo_pip` **≥ 3 × spread_dichiarato**.
  Si usa la **MEDIANA** (non la media): una manciata di trade lunghissimi
  alzerebbe la media e nasconderebbe che il grosso delle operazioni sta sotto
  il costo.
- Il referto scrive **sempre**: mediana e media del netto, mediana e media del
  lordo, lo spread usato, il rapporto, e il verdetto.
- Fallisce → **quel simbolo si chiude qui**, e il verdetto si scrive con un
  numero. **Gli altri due proseguono** (§ 10, D5).

**S0b — LA FREQUENZA.** `n` totale sulla finestra M15 e `n` per finestra IS/OOS.
Atteso **[INFERITO, NON MISURATO]**: GBPUSD fa 126 op in 6,5 anni a H1 =
~19/anno; se gli eventi scalano col numero di barre (×4) → **~78/anno** →
~310 in 4 anni → **~155 per finestra**. 🟡 **È appena sopra i 150
dell'Emendamento: esattamente il tipo di numero che NON si assume.**

**S0c — LA DURATA.** Durata media e mediana in **barre M15**
(`(ora_out − ora_in) / 900 s`). **Non è un cancello: è una misura a referto.**
Motivo dichiarato: `arXiv 2605.04004` §6.2 misura che gli unici due segnali
intraday sopravvissuti alla sua falsificazione _"hold positions for **12-15
bars** rather than 1-6"_. **Se qui la durata mediana fosse 1-3 barre, va scritto
nel referto come segnale di allarme sulla robustezza, anche a cancelli verdi.**

**S0d — LA PRIMA OPERAZIONE VERA.** Vedi § 4.1: è **obbligatoria** e si legge
**prima** dei numeri.

---

## 4. 📅 LE FINESTRE — e i due paletti sul `@DAQUANDO`

### 4.1 🚩 `@DAQUANDO 2022.07.01` è **DERIVATO, NON MISURATO** — e il PASSO 0 lo deve dichiarare

Il tetto MT5 delle 100.000 barre è a verbale (`CODA_PROSSIMA_SESSIONE.md`
riga 21: _"su M15 vale 4,0 anni"_). Controllo aritmetico: forex ≈ **480 barre
M15 a settimana** → 100.000 / 480 = **208 settimane = 4,0 anni**.

⚠️ **Ma il limite NON è il dato del broker**: `REFERTO_SONDA_STORICO_17-08.md`
misura GBPUSD dal **1993** ed EURUSD dal **1971**, e dimostra che il "2010" che
credevamo un muro **era il tetto delle 100.000 barre contate all'indietro**. Lo
stesso referto lascia un **[INCERTO] esplicito**: _"il tetto è dimostrato per le
serie del terminale. **Se valga anche per lo Strategy Tester non lo so.**"_

👉 **Conseguenza operativa, e non si assume niente:**

1. il driver scrive `[Charts] MaxBars=2000000000` nei suoi `.ini` (come R107) —
   **[INFERITO] che il tester lo onori, NON misurato**;
2. **il PASSO 0 DICHIARA LA DATA DELLA PRIMA OPERAZIONE VERA, cella per cella**,
   letta dal report `.htm`. Se cade **sensibilmente dopo** il 2022.07.01, la
   finestra reale è **più corta di quella nominale** e va **riscritta nel
   referto PRIMA di leggere qualunque numero**;
3. soglia dichiarata ora: **prima operazione entro 6 mesi** dall'inizio della
   finestra → `FINESTRA PIENA`; oltre → `FINESTRA ACCORCIATA`, e va nei
   **PROBLEMI**. (È la stessa soglia di R103, `$MesiPrimaOp = 6`.)
4. sul **metro H1** la prova del nove è gratis: R103 ha già misurato la prima
   operazione (**2020.01.14 / 2020.02.03 / 2020.02.05**). Se il metro non
   ridà quelle date, **il banco è cambiato** e tutto il resto si legge con
   riserva.

### 4.2 🎫 IL SECONDO PALETTO: **la profondità dei TICK sui tre simboli NON È MISURATA**

Cercato il 25/08 in `risultati_archivio/misura_tick/`: **esiste un solo
referto, ed è `U30USD`**. Per GBPUSD, EURUSD e AUDUSD **non esiste nessuna
misura della profondità a TICK** in tutto il repo. La sonda del 17/08 ha
misurato **le BARRE**, non i tick.

🔴 **È il difetto della checklist 18 in persona** (_"la profondità misurata su un
TF, la corsa girata su un altro"_), e morde forte: a **modello 4** senza tick
reali MT5 **non si ferma** — ripiega, e produce **numeri plausibili e falsi**.
**Nessuna guardia del driver R108 può accorgersene in modo affidabile**: la
frase esatta che il tester scrive nel Journal non è misurata, e un `grep` che
non trova niente sarebbe un **verde per assenza** (checklist 28-bis).

➡️ **È la decisione D2 (§ 10).** Il driver, comunque sia firmata, cerca al pin
`risultati_archivio/misura_tick/misura_tick_<SIMBOLO>.csv`: se **non** c'è,
scrive un **RILIEVO obbligatorio** in testa al referto — *"PROFONDITÀ TICK NON
MISURATA su &lt;simbolo&gt;: ogni numero a modello 4 va letto con questa
riserva"* — e **non lo nasconde**.

### 4.3 La divisione IS / OOS della cella M15

**Proposta (D3): 2 anni + 2 anni**, cioè
**IS `2022.07.01 → 2024.06.30`** · **OOS `2024.07.01 → 2026.06.30`**.

E si dichiara **quale regime contiene ciascuna** (Emendamento regola **A**):
- **IS** = il post-picco dei tassi e il 2023 laterale-rialzista del dollaro;
- **OOS** = 2024-2026, con la fase di forte direzionalità del 2025.
[Descrizione **qualitativa e [INCERTA]**: questo round **non misura i
sotto-periodi** e non lo pretende.]

### 4.4 🚫 M5 — dichiarato ORA: **NON GIUDICABILE, e in R108 non gira**

Aritmetica: forex ≈ **1.440 barre M5 a settimana** → 100.000 / 1.440 =
**~69 settimane = ~1,3 anni**. **In 1,3 anni non entrano due finestre da 150
operazioni**: qualunque cella M5 sarebbe **non giudicabile sul MERITO a
prescindere dal segno**, per costruzione e prima di girare.

➡️ **Proposta (D6): M5 NON gira in R108.** Non è pigrizia: una cella che produce
un numero che nessuno può usare è una cella che qualcuno userà lo stesso. Se un
giorno girerà, girerà con l'etichetta `NON GIUDICABILE` **stampata dal codice**,
non scritta in una nota.

---

## 5. 🚧 I CANCELLI

### G0 · **RIPRODUZIONE DEL METRO** — 🔴 **FATALE, per simbolo**

La cella `00_metroH1` deve **riprodurre** i numeri di R103 (§ 0). Tolleranze,
le stesse di R101/R107, che con quelle hanno riprodotto due metri:

| grandezza | tolleranza |
|---|---|
| PF | **± 0,01** |
| DD equity % | **± 0,10 punti** |
| n operazioni | **ESATTO** |
| prima operazione | **ESATTA** (§ 4.1 punto 4) |

Se non riproduce → **quel simbolo si ferma** e la sua cella M15 **non viene
nemmeno lanciata**: sopra un metro sbagliato non misurerebbe niente.
**Gli altri simboli proseguono.**

⚠️ **E il metro gira a MODELLO 1 (OHLC M1), non a tick reali** — è la
decisione **D1**. R103 è girato così: un metro a tick reali **non
riprodurrebbe mai** quel numero e **boccerebbe un banco sano**.

🟢 **In più, G0 include l'IGIENE DEI GEMELLI**: le due passate identiche (magic
`B` e `B+1`) devono dare **lo stesso numero al centesimo** su profitto, PF, DD e
n. È il collaudo del banco, ed è il motivo per cui l'unico asse spazzolato è
`InpMagic`. **E si pretende che siano DUE righe**: "una riga sola" non è
"gemelli ok", è uno sweep che non ha spazzolato (checklist 55).

### S0 · **CANCELLO ZERO SUL COSTO** — 🔴 **FATALE, per simbolo**

Definito al § 3.4. **Si legge PRIMA di qualunque PF.** Fallisce → quel simbolo
si chiude e il verdetto si scrive **con un numero**.

### G1 · **MISURABILITÀ** (Emendamento regola A)

- `n` per finestra **≥ 150** → il **MERITO** si giudica;
- `n` per finestra **< 150** → **MERITO SOSPESO**, e il **RISCHIO si legge lo
  stesso, a qualunque n** (regola **B**: un drawdown è un fatto accaduto). È un
  **RILIEVO**, cioè un **risultato del round**, non un guasto;
- `n` per finestra **< 20** → **NON MISURABILE**, mai *"non funziona"*.

### G2 · **MERITO** (solo se S0 e G1 sono verdi)

- **S1** positivo in **ENTRAMBE** le finestre (IS **e** OOS);
- **S2** **PF OOS ≥ 1,10**;
- **S3** **DD OOS < 10%** a rischio 1%.

Sono i quattro cancelli congelati nella tesi del motore il 12/08
(`BREAKING_BAND_TESI.md`, *CRITERI DI PROMOZIONE*), **non inventati oggi**.

### G3 · **COERENZA CROSS-SIMBOLO** — 🔴 il cancello che protegge dal rumore

**Un simbolo su tre non fa un edge.** Se M15 regge su **uno solo** dei tre
mentre gli altri due muoiono, la lettura di casa è **rumore**, non scoperta —
ed è il cancello che in R46 fermò un candidato che faceva +31%.
**Non è meccanizzabile nel driver**: è un ragionamento su tre tabelle, e lo
applica **il referto del round, a mano**.

### G4 · **PEGGIOR GIORNATA** — misurata **sempre**, anche se favorevole

Muro prop giornaliero: **−5% su 100k**. La nostra peggiore misurata (R51) è
**−2,06%**: due giornate così sono già metà del cap. ⚠️ **A M15 la frequenza
sale, e con lei la CONCENTRAZIONE giornaliera**: il numero da guardare **non è
il DD totale, è la peggior giornata**.

### G5 · **NESSUNA PROMOZIONE ESCE DA QUESTO ROUND**

R108 produce **misure**. Nessuna sedia nuova, nessun cambio al forward, nessuna
taglia. Un deploy è **una firma separata, con il suo referto**. E `FLOTTA_ATTIVA`
ha già **tre BreakingBand vive** su questi stessi simboli a H1: una versione M15
non entrerebbe *"in più", entrerebbe accanto o al posto*, e quella è una
decisione di portafoglio, non un risultato di backtest.

---

## 6. 🚫 COSA NON SI SPAZZOLA — e perché

**Zero.** L'unico flag `Y` è `InpMagic`, e il driver **si ferma** se in un file
ne trova un secondo.

In particolare restano **SPENTE** le due valvole che imporrebbero un take
minimo — `InpMinTPatATR = 0.0` e `InpMinRR = 0.0`:

> ⚠️ **accenderle dentro il round che MISURA il take vorrebbe dire misurare il
> filtro invece del motore.** Prima si misura **nudo** (S0a), poi si decide. Se
> S0a fallisce, la variante *"con valvola accesa"* è **un round NUOVO, con
> criteri nuovi** — non un salvataggio di questo.

---

## 7. ⚖️ L'EMENDAMENTO DELLA FINESTRA, applicato a questo round

- **regola A** — l'unità di misura è l'**operazione**, non l'anno: la finestra
  M15 si dimensiona sulle **≥150 operazioni per finestra**, e la stima è
  **[INFERITA]** (§ 3.4, S0b) finché il PASSO 0 non la misura;
- **regola B** — **il vecchio giudica il RISCHIO, il recente il MERITO**: nessun
  simbolo viene bocciato perché *"nel 2022 non guadagnava"*; ma **un DD del 25%
  nel 2025 sarebbe un fatto accaduto** e si legge a qualunque `n`;
- **regola C** — la **prova di regime** batte la storia contigua: R108 **non la
  fa** (quattro finestre = un altro round) e **lo dichiara**;
- **regola D** — il limite in basso resta: quattro anni su M15 sono **più** di
  quello che gira oggi in casa (110 file prova su 153 girano su 21 mesi).

---

## 8. 📤 COSA PUÒ USCIRE DA R108 — e cosa no

**Può uscire:**
1. una risposta **con un numero** alla domanda *"il Breaking Band regge a M15?"*,
   su tre simboli e su quattro anni;
2. **il primo take misurato in pip** di questa famiglia — che serve anche alle
   **tre sedie H1 vive**, indipendentemente da come va M15;
3. la **frequenza vera** a M15 (il mandato della challenge nasce da lì);
4. la misura della **durata in barre**, da confrontare con la specifica esterna.

**NON può uscire:**
1. **una sedia** (G5);
2. niente su **M5** (§ 4.4);
3. niente sugli **altri 19 cross** del basket: tre simboli;
4. niente sulla **prova di regime**;
5. nessuna promessa sul **live**: fill, slippage e spread variabile non stanno in
   nessuno dei due modelli.

---

## 9. ⚙️ ESECUZIONE

- **Driver**: `righe/RIGA_R108_BB_M15.ps1`, marcatore `MARCATORE_RIGA_R108_v1`.
- **`-SoloControllo`** (giro a vuoto): **non apre MT5**. Verifica gli
  **artefatti** — file prova, stella, valori, magic, `.ini` — e **compila**.
  ⚠️ **Non misura NESSUN numero**: nessun `n`, nessun PF, nessun G0, **nessun
  S0**. Sta scritto anche **dentro il suo referto**.
- **MT5 e MetaEditor chiusi**, o la riga si rifiuta di partire.
- **`[Experts] AllowLiveTrading=false`** in ogni `.ini`: aprire MT5 per misurare
  **riarma la flotta** sul conto vivo (checklist 51; successo il 14/08).
- **Una macchina, un lavoro**: R108 parte solo quando nessun altro round tocca
  il terminale.
- **Il round non scarica storico** e **non tocca `bases\<server>\ticks`**.
- **Durata [STIMA, non una previsione]**: 30 passate, di cui 18 a tick reali su
  4 anni di M15. R103 fece 25 sedie in OHLC in 36 minuti; **i tick reali sono un
  altro ordine di grandezza**. `-OreMax 12` è un tetto sull'**inizio** di nuovi
  lavori, non un'accetta su un lavoro in corso.

---

## 10. ✍️ LE SEI DECISIONI — **FIRMATE ("FIRMO CON PROPOSTE", 25/08/2026)**

> La firma "CON PROPOSTE" vale **SÌ su tutte e sei le proposte**. Il testo
> originale resta sotto per il verbale.

| | decisione | ✅ PROPOSTA | ❌ alternativa scartata, e perché |
|---|---|---|---|
| **D1** | Il **metro G0** gira a **modello 1 (OHLC M1)**, come R103 | **SÌ.** È l'unico modello che può riprodurre quel numero | *metro a tick reali*: non riprodurrebbe **mai** R103 e **boccerebbe un banco sano**. Un metro deve misurare il banco, non il modello |
| **D2** | La **profondità dei TICK** su GBPUSD/EURUSD/AUDUSD **non è misurata** (§ 4.2) | **SI MISURA PRIMA**, con lo strumento di casa già usato su U30USD. Costa una riga e mezz'ora | *girare e dichiarare*: a modello 4 senza tick reali MT5 **non si ferma**, ripiega e produce numeri **plausibili e falsi**, e **nessuna guardia del driver può accorgersene**. È la classe di difetto più cara del progetto |
| **D3** | La **divisione IS/OOS** della cella M15 | **2 anni + 2 anni** (IS 2022.07→2024.06, OOS 2024.07→2026.06). Serve a dare a **entrambe** le finestre una possibilità di arrivare a 150 op | *40/60 come gli altri round*: darebbe un IS di 1,6 anni ≈ **125 op attese**, cioè **sotto soglia per costruzione**. Costo dichiarato: i CSV IS/OOS **non sono confrontabili con quelli 40/60** degli altri round |
| **D4** | Lo **spread di riferimento** di S0a | **1,5 pip** su tutti e tre, **[SPREAD NON MISURATO]** stampato accanto a ogni verdetto. Valore prudenziale dichiarato | *misurarlo prima col RealCost Spread P95 Logger* (Code Base 74148, promosso il 23/08 e **mai usato**): è la strada giusta ma è **un altro lavoro**, e la sua assenza non deve bloccare la prima misura del take. ⚠️ **Se S0a esce vicino alla soglia (rapporto 2,5-3,5), il verdetto NON si dà: si misura lo spread e si rilegge** |
| **D5** | Cosa succede se **S0 o G0 falliscono su UN simbolo solo** | **Quel simbolo si chiude, gli altri proseguono.** Un simbolo storto non porta via anche gli altri (stessa scelta di R100/R101/R107) | *fermare tutto il round*: butterebbe ore di macchina già spese e trasformerebbe **tre risposte in zero** |
| **D6** | **M5 in R108?** | **NO** (§ 4.4). Con ~1,3 anni di tetto è **non giudicabile per costruzione**, prima di girare | *farlo girare "tanto è diagnostico"*: un numero che nessuno può usare è un numero che qualcuno userà lo stesso |

### 10.1 🟢 Cosa **non** serve firmare, e perché

- **i sei file prova**: sono **copiati riga per riga** dalle celle vive di R103,
  e le uniche righe toccate sono elencate nella testa di ognuno;
- **le tolleranze di G0**: sono quelle di R101 e R107, che con quelle hanno
  riprodotto due metri;
- **G5** (nessuna promozione): è **regola di casa**, non una scelta di round;
- **`InpRiskPercent = 1.0`**: è la **taglia viva** misurata nel censimento `.chr`
  del 23/08, non una scelta.

---

## 11. 🚫 QUELLO CHE R108 **NON** FARÀ, dichiarato prima

1. **Non tocca `ABTG_BreakingBand.mq5`.** Zero righe di MQL5. A M15 ci si arriva
   **via `input`**, ed è il punto della promozione. ✅ **Verificato eseguendo**:
   `InpTF` esiste (riga 213), è `ENUM_TIMEFRAMES`, e `PERIOD_M15 = 15`.
2. **Non tocca nessuna sedia in forward.** Magic **vergini** `762xxx`; i magic
   vivi e quelli di R103/R107 sono **vietati e controllati nel codice**.
3. **Non promuove e non boccia niente** (G5).
4. **Non applica i cancelli G2 e G3**: il driver produce i numeri, i verdetti li
   dà **il referto del round, a mano**. G3 non è meccanizzabile.
5. **Non misura lo spread**, non misura i sotto-periodi, non fa la prova di
   regime, non scarica storico.
6. **Non mescola un OHLC e un tick reale nella stessa tabella.** Lo switch
   `-ScreenOhlcM15` esiste per fare uno screen veloce, ma **se è acceso il round
   gira SOLO in OHLC**, la cartella e lo zip si chiamano `SCREENOHLC`, e **ogni
   riga M15 esce marcata `NON GIUDICABILE`** — stampata dal codice, non scritta
   in una nota (checklist 67).

---

_Criteri scritti il 25/08/2026, **prima** di qualunque numero. I criteri si
cambiano **prima** dei numeri, mai dopo._
