# ✍️ R110 — I LATI MAI MISURATI DEI MOTORI VIVI SUGLI INDICI — CRITERI **FIRMATI**

> 🖊️ **FIRMA: "FIRMO R110" — Claudio, 25/08/2026 sera.** Data DOPO che gli
> erano stati presentati i 5 difetti del verificatore e la nascita della
> **sesta decisione** (D6: la peggior giornata non esportata da questi 4 EA →
> rischio letto su DD equity IS/OOS + delta contro il metro) e l'esclusione
> di SupRev DAX H1 (spenta con sua delibera l'11/08, `REFERTO_FUORILISTA.md`).
> La firma vale per le SEI decisioni del § 10 **con le proposte**. Firma a
> numeri non visti. La corsa si lancia con `-CriteriFirmati`.

> 🔓 **IL LUCCHETTO E' APERTO.** Questo documento **portava il lucchetto della
> firma** nel titolo e nel § 10; il driver lo cerca **al pin, in tutto il file**,
> e finché lo trova la **corsa vera** si ferma con `exit 2` (il **giro a vuoto**
> parte lo stesso: non apre MT5 e non produce nessun numero, e serve proprio a
> far leggere questi criteri prima di firmarli). Con la firma qui sopra il
> lucchetto è stato **tolto da tutti e due i punti**, quindi la corsa vera parte
> **senza `-CriteriFirmati`**.
> ⚠️ **E la parola del lucchetto non compare più da nessuna parte in questa
> pagina, nemmeno nella prosa che lo spiega**: il gate cerca la STRINGA, non il
> titolo — una citazione in prosa terrebbe la porta chiusa a firma data
> (checklist 82).
> Le decisioni firmate sono **sei**, e stanno al § 10.

**Origine**: Claudio, sera del 25/08/2026, dopo i verdetti short di R107:
_"non si possono provare i vari motori?"_ — non è contento di chiudere la
domanda sullo short con tre geometrie di apertura.
**La mappa che risponde**: `risultati_archivio/CENSIMENTO_LATI_SHORT_2026-08-25.md`,
**tabella 1d** (_"Motori SIMMETRICI vivi in forward — lati MAI separati"_) e
**§ 5** (la lista ordinata: R110 sono i **punti 1 e 2**).
**Driver**: `righe/RIGA_R110_LATI_VIVI.ps1` (marcatore `MARCATORE_RIGA_R110_v1`).
**File prova**: `prove/R110_*.txt` — **dodici**.
**Riga da mandare**: `righe/RIGA_R110_DA_MANDARE.md`.

---

## 0. 📌 CHE ROUND È — e soprattutto cosa **non** è

R107 ha misurato il lato short di **tre motori di apertura**, e ha risposto
_"0 su 3"_. Ma quella era **una famiglia sola di motori** (il breakout/retest
d'apertura su M5). Il parco ne ha altri, **già vivi in forward, che girano
long+short nella stessa cella** — e il loro lato short **non ha mai avuto un
numero suo** (censimento § 1d).

**Cosa È:** la **diagnostica dei lati** già fatta altrove (R54 sul Dow, R98 sul
Nasdaq, R107 sulle aperture) applicata ai **motori vivi che nessuno ha mai
smontato**. Zero righe di MQL5 scritte. Zero parametri spazzolati.

**Cosa NON è:**

- ❌ **Non è la Seconda Caccia.** La Seconda Caccia vieta _"un'altra griglia
  sullo stesso motore morto"_. Qui i motori **non sono morti**: sono vivi, e la
  domanda non è "hanno edge?" ma **"da quale lato viene l'edge che già hanno?"**.
- ❌ **Non è un'ottimizzazione.** L'unico asse con flag `Y` in tutti e dodici i
  file prova è **`InpMagic`**, che è il controllo d'igiene dei gemelli.
- ❌ **Non è un round di deploy.** Vedi **G5**.
- ❌ **Non è la riproduzione di R103.** E questo è il punto delicato del round:
  ha un paragrafo suo, il **§ 5, G0-B**.

---

## 1. 🧭 IL METODO — tre celle per famiglia, e cambia **un lato per volta**

Per ogni famiglia:

| cella | InpAllowLong | InpAllowShort | cos'è |
|---|---|---|---|
| `00_metro` | `true` | `true` | **la cella viva com'è**, congelata input per input |
| `01_long` | `true` | **`false`** | il lato LONG da solo |
| `02_short` | **`false`** | `true` | **il lato SHORT da solo — la misura nuova** |

La differenza fra `00_metro` e ciascuna cella dei lati è **letteralmente di una
riga** (più `InpMagic`). **Verificato col `diff` sui file veri il 25/08**, ed è
riportato qui sotto testualmente per tutte e quattro le famiglie:

```
-- 01_long:   InpAllowShort=true||...  ->  InpAllowShort=false||...   + InpMagic
-- 02_short:  InpAllowLong=true||...   ->  InpAllowLong=false||...    + InpMagic
```

### 1.1 ⚠️ LA SOMMA DEI DUE LATI **NON** RIPRODUCE IL METRO — e non è un difetto

Va scritto **prima** dei numeri, perché è la prima cosa che chiunque proverà a
fare guardando la tabella (sommare `01_long` e `02_short` e confrontarli con
`00_metro`).

**MISURATO NEL SORGENTE**, non dedotto. Tutti e quattro i motori aprono la loro
funzione di ingresso così:

_(Le citazioni sono scritte come **marcatore da cercare** e non come numero di
riga: un numero di riga non si sposta col codice, e una citazione che drifta
manda il verificatore a cercare la prova nel posto sbagliato — checklist 43.
I numeri qui accanto sono **misurati al pin del 25/08** e valgono come conferma,
non come indirizzo.)_

- `ABTG_EMA200.mq5`, in `void OnNewBar()`, prima istruzione — cerca
  `if(HasPosition() || HasPending()) return;` *(riga **186** al pin)*
- `ABTG_SupRev_NAS_H1_Ottimizzato.mq5` e `ABTG_SupRev_DAX_H4_Ottimizzato.mq5`,
  in `void OnNewBar(MqlDateTime &now)` — cerca `if(HasPosition())` *(riga
  **174**)* e poi `if(HasPending()) return;` *(riga **181**)*
- `ABTG_SuperWave_DOW_H1_Ottimizzato.mq5`, stesso schema ma **più in basso**
  perché il blocco del flip è più lungo — `if(HasPosition())` *(riga **176**)*
  e `if(HasPending()) return;` *(riga **183**)*

...e **solo dopo** arriva il controllo del lato (`if(up && !InpAllowLong) return;`).

➡️ **Conseguenza obbligata**: nel metro, un segnale short che arriva mentre è
aperta una posizione **long** viene **buttato via**. Nella cella `02_short`
quello slot è libero e quel segnale **entra**. Quindi:

> **`n(01_long) + n(02_short) ≠ n(00_metro)`, e lo sbilancio è un FATTO DEL
> MOTORE, non un guasto del banco.** Il referto stampa i tre `n` accanto proprio
> perché la differenza si veda; nessuno la legga come un errore di misura.

E il corollario che conta per il verdetto: **il lato long da solo non è la sedia
viva**, e nemmeno il lato short. Sono **tre celle diverse**, e la sedia è la
prima.

---

## 2. 🧊 LE QUATTRO FAMIGLIE — con la **fonte** di ogni numero e di ogni scelta

### 2.1 🇺🇸 SUPNAS — `ABTG_SupRev_NAS_H1_Ottimizzato` · NASUSD **H1** · sedia viva **970913**

La **prop-friendly ⭐** (censimento § 1d): DD 1,48% in R103, il più basso del
parco indici. Antenato del file prova:
`prove/R103_ABTG_SupRev_NAS_H1_Ottimizzato_NASUSD_970913.txt`.
Origine della cella: **R5v** del `REGISTRO_TEST.md` (validazione real-tick del
26/07: StMult 3.0 / AtrP 10 / TP_RR 3.0, **8/8 combo positive**).

### 2.2 🇩🇪 SUPDAX — `ABTG_SupRev_DAX_H4_Ottimizzato` · D30EUR **H4** · sedia viva **970912**

Antenato: `prove/R103_ABTG_SupRev_DAX_H4_Ottimizzato_D30EUR_970912.txt`.
⚠️ **È il campione più sottile del round**: n 99 in R103 su 21 mesi. Su H4 un
lato da solo farà **molto** meno: **atteso sotto G1 o poco sopra**, e il § 5 G4
dice cosa se ne fa.

### 2.3 🇺🇸 SWDOW — `ABTG_SuperWave_DOW_H1_Ottimizzato` · U30USD **H1** · sedia viva **770511**

Antenato: `prove/R103_ABTG_SuperWave_DOW_H1_Ottimizzato_U30USD_770511.txt`.
n 290 in R103 — il secondo campione più grasso degli indici.

### 2.4 🇺🇸 EMADOW — `ABTG_EMA200` · U30USD **H1** · sedia viva **771531**

Antenato: `prove/R103_ABTG_EMA200_U30USD_771531.txt`.
🔥 **712 operazioni in R103**: il campione più grasso di tutta la flotta indici,
e **l'unico posto del parco dove un lato da solo può arrivare a n ≥ 150 su
questa finestra** — cioè dove l'Emendamento regola A può essere **soddisfatto**
invece che invocato.

> 🧬 **`magic del SORGENTE` ≠ `magic della SEDIA` ≠ `magic del FILE PROVA`.**
> `ABTG_EMA200.mq5` dichiara `InpMagic = 771501` (riga 104) mentre la sedia Dow
> gira su **771531** (impostato sul grafico). Il gate di versione controlla il
> **sorgente**; il magic della sedia è **VIETATO**; nel tester gira il magic
> **vergine** del file prova. Confonderli è il difetto che R100 dovette
> correggere a mano su due sedie.

### 2.5 ⛔ LA FAMIGLIA **ESCLUSA**, e il motivo è MISURATO — `SupRev_DAX_H1` (970911)

La richiesta di Claudio diceva _"DAX H1/H4"_. **L'H1 non entra**, e non è
un'opinione:

| controllo | esito |
|---|---|
| è nel censimento `.chr` del **23/08 15:49**? | 🔴 **NO** (ci sono 970912 e 970913, non 970911) |
| è nel censimento `.chr` del **25/08 07:31**? | 🔴 **NO** (52 sedie, nessuna 970911) |
| ha un file prova R103? | 🔴 **NO** — le 15 sedie indici di R103 non la comprendono |
| ha un numero R103? | 🔴 **NO** — non compare nel `R103_REFERTO_BLOCCO1_INDICI.md` |
| ha un preset live in repo? | 🔴 **NO** (`mql5/Presets` non ne ha) |
| dove risulta viva? | 🟡 solo in **documenti**: `FLOTTA_ATTIVA.md` la marca `🟡 in osservazione`, e da lì l'ha ripresa il censimento dei lati |

➡️ **Non esiste nessun artefatto della sua cella viva.** Costruirla dai default
del sorgente (`InpStMult 3.5`, `InpStAtrPeriod 10`, `InpTP_RR 3.0` — che sono i
valori vincenti di **R S1v**, registro 26/07) sarebbe **ricostruire una cella,
non riprodurla**: e un round che misura i lati di una cella inventata misura i
lati di niente. **Regola di casa applicata alla lettera: se un documento e un
artefatto divergono, comanda l'artefatto.**
👉 È la decisione **D1** del § 10, con l'alternativa scritta.

### 2.6 ⚖️ Rischio 1,00% nei file prova, **0,65% in campo**

Come R101 § 2.4 e R107 § 2.4, e per lo stesso motivo (confrontabilità).
➡️ **Ogni DD di questo round è all'1%.** Per confrontarlo col forward del 100k
**si moltiplica per 0,65**. Chi salta la conversione confronta due cose diverse.

### 2.7 🏷️ `InpComment` resta quello vivo, ed è una scelta dichiarata

I file prova tengono `InpComment` della sedia (`STREV NAS H1`, `EMA200 DOW`…):
la cella è **quella, tale e quale**. A distinguere il round dal forward ci pensa
il **magic vergine**, e il tester gira comunque con `AllowLiveTrading=false`.

---

## 3. 🔢 LE DODICI CELLE E I MAGIC

| famiglia | cella | file prova | L / S | magic gemelli |
|---|---|---|---|---|
| SUPNAS | `00_metro` | `R110_SUPNAS_00_metro.txt` | 1 / 1 | **763000 / 763001** |
| SUPNAS | `01_long` | `R110_SUPNAS_01_long.txt` | 1 / 0 | **763010 / 763011** |
| SUPNAS | `02_short` | `R110_SUPNAS_02_short.txt` | 0 / 1 | **763020 / 763021** |
| SUPDAX | `00_metro` | `R110_SUPDAX_00_metro.txt` | 1 / 1 | **763100 / 763101** |
| SUPDAX | `01_long` | `R110_SUPDAX_01_long.txt` | 1 / 0 | **763110 / 763111** |
| SUPDAX | `02_short` | `R110_SUPDAX_02_short.txt` | 0 / 1 | **763120 / 763121** |
| SWDOW | `00_metro` | `R110_SWDOW_00_metro.txt` | 1 / 1 | **763200 / 763201** |
| SWDOW | `01_long` | `R110_SWDOW_01_long.txt` | 1 / 0 | **763210 / 763211** |
| SWDOW | `02_short` | `R110_SWDOW_02_short.txt` | 0 / 1 | **763220 / 763221** |
| EMADOW | `00_metro` | `R110_EMADOW_00_metro.txt` | 1 / 1 | **763300 / 763301** |
| EMADOW | `01_long` | `R110_EMADOW_01_long.txt` | 1 / 0 | **763310 / 763311** |
| EMADOW | `02_short` | `R110_EMADOW_02_short.txt` | 0 / 1 | **763320 / 763321** |

**Blocco magic `763xxx`**: i **24** numeri qui sopra sono stati cercati **uno per
uno** in tutto il repo il 25/08/2026 → **zero occorrenze**. I blocchi confinanti
sono occupati e restano tali: `760xxx` R103, `761xxx` **R107**, `7744xx`
**R109**, `7732xx/7733xx` R101, `7726xx` R54, `7728xx` R98, `750xx` R104,
`79xxxx` R102.

**Magic VIETATI e controllati nel codice**: `970913`, `970912`, `770511`,
`771531` (**le quattro sedie di questo round**), `970911` (SupRev DAX H1: non
gira, ma **un'identità non in campo resta occupata**), `970914` (SupRev DOW H4,
promozione **revocata**), `771501` (default del sorgente EMA200), `770901`,
`770923`, `770924`, `770925`, `770512`, `770531`, `770532`, `771511`-`771515`,
`971501`, più `770101`, `770202`, `770611`, `770411` e i blocchi dei round
recenti.

**Costo della corsa**: 12 celle × 2 finestre × 2 gemelle = **48 passate**,
**24 CSV**, **2 righe per CSV**.

---

## 4. 📅 FINESTRE — le standard di casa, senza sconti

| | |
|---|---|
| simboli / TF | **NASUSD H1**, **D30EUR H4**, **U30USD H1** (×2 motori) |
| storico | `@DAQUANDO` **2024.09.26** — muro del feed BCM sugli indici, **MISURATO** (`REFERTO_SONDA_STORICO_17-08.md`, verdetto `COMPLETO`) |
| fine | **2026.06.30** |
| split | **40 / 60** (`FrazioneIS 0.40`, default del driver generico) |
| **IS** | **2024.09.26 → 2025.06.09** |
| **OOS** | **2025.06.10 → 2026.06.30** |
| modello | **4 = TICK REALI** |
| deposito | **100.000** |
| spread | `Spread=0` nell'ini = spread **corrente** del feed, dichiarato. **Non è uno stress e non è una misura** |

Sono le finestre di **R88 / R97 / R98 / R101 / R107**: è l'unico modo di leggere
R110 accanto a R107 senza barare.

### 4.1 🚩 I limiti della finestra — **e per un round sui LATI sono decisivi**

1. 🔴 **21 MESI DI INDICI IN SALITA.** Il lato short parte **svantaggiato per
   REGIME**, non per merito. Un _"niente edge short"_ qui **la chiude PER QUESTA
   EPOCA**, non per sempre. **Emendamento regola C** (la prova di regime batte la
   storia contigua) **non è eseguibile sugli indici**: il frigo dei dati esterni
   (`NASUSD_EXT` / `SPXUSD_EXT` / `225JPY_EXT`) non passa il cancello 0,05%
   (`ANALISI_CANCELLO_ZERO_EXT_2026-08-25.md`).
2. 🔴 **QUESTO OOS È GIÀ STATO GUARDATO MOLTE VOLTE** (R14, R15, R16, R35, R46,
   R51, R54, R88, R101, R103, R107…). R110 ci aggiunge **dodici** celle. Con
   tante guardate, **qualcuno esce verde per caso**: è la ragione di **G3**.
3. 🟠 **IL CAMPIONE SI DIMEZZA PER COSTRUZIONE.** Spegnere un lato toglie
   operazioni. Attesi (proiezione lineare dai `n` R103, che sono OHLC su 21 mesi
   pieni — **[STIMA GROSSOLANA, non una previsione]**): EMADOW ~350 per lato,
   SWDOW ~145, SUPNAS ~85, SUPDAX ~50. **Solo EMADOW può ragionevolmente
   superare i 150 dell'Emendamento regola A.**

### 4.2 🦴 LA LETTURA PER **SPINA DORSALE**, e il fatto nuovo di R107

**Il fatto di calendario**: la discesa documentata dentro questa finestra è la
correzione di **febbraio-aprile 2025** (minimi di aprile). Cade **dentro l'IS**
— l'IS finisce il **2025.06.09**. L'OOS è quasi tutto salita.

➡️ **Conseguenza sulla lettura, scritta PRIMA dei numeri:**

> Se una cella `02_short` esce **positiva in IS e negativa in OOS**, la prima
> ipotesi **non è** _"il lato è rumore"_: è che **l'edge dello short viva nelle
> discese, e l'IS ne contenga una mentre l'OOS quasi no.**

E adesso c'è **un fatto nuovo che punta lì**, ed è di ieri: **R107 ha misurato il
NAS short a PF IS 3,220 e PF OOS 0,460** — l'IS con la discesa dentro, l'OOS
senza. È il segnale più forte che l'archivio abbia su questa ipotesi.

> ⚠️ **E resta [INFERITO] anche dopo R110.** Questo round **non misura i
> sotto-periodi**: non sa quanto del profitto IS venga da febbraio-aprile e non
> sa se l'OOS contenga discese paragonabili. **La prova vera è un round di PROVA
> DI REGIME fatto apposta** — che oggi è **bloccato dal frigo dei dati esterni**.
> Chi legge un IS verde come _"funziona"_ sta leggendo male; chi legge un OOS
> rosso come _"non funziona mai"_ pure.

---

## 5. 🚧 I CANCELLI

### G0-A · IL **GATE DELL'ANTENATO** — 🔴 **FATALE, per famiglia** (checklist 72)

**È il gate che in R110 può davvero mordere, ed è meccanico: gira PRIMA di
aprire MT5.**

Il driver scarica **al pin** i quattro file prova di R103 e confronta la cella
`00_metro` con il suo antenato **riga per riga, PER NOME** (mai per posizione:
l'antenato può avere una riga in più o in meno, ed è il punto 58 applicato alle
righe). **Delta ammessi, elencati e nient'altro:**

| famiglia | antenato | delta ammessi |
|---|---|---|
| SUPNAS | `R103_ABTG_SupRev_NAS_H1_Ottimizzato_NASUSD_970913.txt` | `InpMagic` |
| SUPDAX | `R103_ABTG_SupRev_DAX_H4_Ottimizzato_D30EUR_970912.txt` | `InpMagic` |
| SWDOW | `R103_ABTG_SuperWave_DOW_H1_Ottimizzato_U30USD_770511.txt` | `InpMagic` |
| EMADOW | `R103_ABTG_EMA200_U30USD_771531.txt` | `InpMagic` |

**Perché serve, e perché il gate della stella da solo non basta**: la stella
(§ G0-D) confronta le celle **fra loro**, e _"un diff fra A e B non può
accorgersi di niente che sia uguale in A e in B"_. Una riga storta **in tutte e
tre** le celle di una famiglia passerebbe la stella e **cambierebbe il motore**.
Con l'antenato, la frase _"il corpo è copiato riga per riga da R103"_ smette di
essere un commento in testa al file e diventa **un controllo**.

**Se l'antenato non torna, la FAMIGLIA si ferma** e le sue celle non vengono
nemmeno lanciate. **Le altre vanno avanti.**

### G0-B · LA RIPRODUZIONE NUMERICA — 🚫 **NON APPLICABILE, e va scritto in chiaro**

**Questo è il paragrafo più importante del round, e va letto prima di ogni
tabella.**

R110 **non ha nessun numero agli atti da riprodurre** su questa finestra e su
questo banco. Non per pigrizia: **per aritmetica.**

| | R103 (dove stanno i numeri) | R110 (questo round) |
|---|---|---|
| modello | **1 = OHLC su M1** | **4 = TICK REALI** |
| finestra | **una sola**, 21 mesi pieni | **due**: IS 40% / OOS 60% |
| suffisso CSV | `_ohlc` | nessuno |

E il driver generico **non sa girare a finestra unica**: `walkforward_generico.ps1`
righe 465-468 costruisce **sempre** le due gambe IS/OOS. Quindi non è nemmeno
una scelta: **la riproduzione di R103 con questo strumento non è eseguibile.**

**E se anche lo fosse, non varrebbe:** che sugli indici OHLC e tick reali NON
diano lo stesso numero **è MISURATO, non temuto** — `SupRev_DOW_H4` fece
**PF 2,77 in OHLC** e **PF 0,79 a tick reali** (revalidation 30/07: *"illusione
OHLC"*, contratto **REVOCATO**; `R103_CRITERI.md` § 3.3).

➡️ **Quindi**: i numeri R103 delle quattro sedie stanno nei file prova e nel
referto come **CONTESTO DICHIARATO**, mai come gate.

| famiglia | R103 (OHLC, 21 mesi pieni, rischio 1%) |
|---|---|
| EMADOW | +30.647 · **PF 1,42** · DD 6,48% · **n 712** |
| SWDOW | +7.280 · PF 1,28 · DD 4,14% · n 290 |
| SUPDAX | +7.856 · PF 2,05 · DD 4,22% · n 99 |
| SUPNAS | +6.765 · PF 1,65 · DD 1,48% · n 172 |

> 🔴 **`NON APPLICABILE` NON È `SUPERATO`.** In R107 questo caso c'era su **una**
> famiglia (il NAS); in R110 c'è su **tutte e quattro**. Va detto senza girarci
> intorno: **su questo banco, in questo round, nessuno può dimostrare guardando i
> numeri che il banco è sano.** Quello che si può dimostrare — e si dimostra — è
> che **i file sono quelli giusti** (G0-A) e che **il banco è deterministico**
> (G0-C).
> 👉 È la decisione **D3** del § 10, con l'alternativa scritta.

### G0-C · IGIENE DEI GEMELLI — 🔴 **FATALE, per famiglia**

Le **due righe** di ogni CSV (i due magic gemelli, unico asse `Y`) devono essere
**identiche al centesimo** su profitto, PF, DD e `n`. Due righe diverse a
parametri identici vogliono dire che il banco **non è deterministico**, e allora
non si legge niente. **E si pretende che siano DUE**: _"una riga sola"_ non è
"gemelli ok", è **uno sweep che non ha spazzolato** (checklist 55).

Applicato alla cella `00_metro`: se fallisce, **la famiglia si ferma**.

### G0-D · GATE DELLA STELLA, DEI VALORI, DELL'ASSE UNICO, DEI MAGIC — 🔴 fatali

Prima di aprire MT5, sui file veri scaricati al pin:

1. **righe vive** attese, **misurate sui file** il 25/08 con `grep -cvE '^\s*(#|$)'`:
   **SUPNAS 45 · SUPDAX 45 · SWDOW 47 · EMADOW 46**;
2. **stella**: `01_long` differisce dal suo `00_metro` **esattamente** su
   `InpAllowShort` (+ `InpMagic`); `02_short` **esattamente** su `InpAllowLong`
   (+ `InpMagic`). *Contare "2 righe diverse" non basterebbe: due righe sbagliate
   darebbero lo stesso conteggio*;
3. **valori propri**: `InpAllowLong`/`InpAllowShort` valgono `true/true`,
   `true/false`, `false/true`. **Se due file di una famiglia fossero scambiati,
   la stella resterebbe verde e questo no** (checklist 34-bis);
4. **`@SIMBOLO` / `@PERIODO` / `@DAQUANDO`** confrontati, non creduti — ed è qui
   che la regola *"niente coda 2026.07-08"* diventa un `if` invece di una frase;
5. **asse unico**: un solo flag `Y`, ed è `InpMagic`. Contato **nel file prova**,
   non solo nell'anteprima;
6. **magic**: unici fra le dodici celle, **vergini**, mai uno dei vietati.

### G1 · MISURABILITÀ (per cella dei lati)

**n OOS ≥ 30** → sotto, il verdetto è **"NON MISURABILE"**, **mai** *"non
funziona"*. Stessa soglia e stessa formulazione di R54 criterio 2, R101 G1 e
R107 G1. **È l'esito atteso come possibile su SUPDAX** (H4, n 99 su 21 mesi
interi, e qui l'OOS è il 60% di quello, diviso per due lati).

### G2 · MERITO DEL LATO — proposta: **quello di R54, identico** (decisione **D2**)

Una cella dei lati diventa **CANDIDATA** solo se:

- **(a)** **PF OOS ≥ 1,10**, **E**
- **(b)** **positiva anche in IS**.

**Perché quello**: è **letteralmente il criterio 3 di R54**, ed è il metro con
cui R107 ha appena giudicato tre short. Cambiarlo adesso renderebbe R110
illeggibile accanto a R107 — che è metà del motivo per cui questo round esiste.

⚠️ **G2 non si legge da solo**: una cella che passa G2 **non sostituisce** la
sedia viva. Per quello servirebbe il cancello di portafoglio di R46/R54 (*più
profitto OOS **e** DD non peggiore*), e comunque una **firma** (G5).

⚠️ **E c'è un verso che vale quanto l'altro**: se un `01_long` passa G2 e il suo
`02_short` è **rosso e con n abbondante**, la lettura non è _"lo short non
serve"_ ma **"questa sedia potrebbe essere long-only"** — e quella è una
**proposta di modifica di contratto**, cioè un round successivo con la sua firma,
**non una conclusione di R110** (regola R52: _"non si spegne un lato guardando i
risultati"_; il lato si dichiara, e si dichiara **in un round che ha quello come
oggetto**).

### G3 · COERENZA CROSS-MOTORE — 🔴 il cancello che protegge dal rumore

> **Un lato short verde su UN SOLO motore, dentro una finestra guardata dieci
> volte, è un picco isolato — non un risultato.**

È il criterio 2(c) di R46 (quello che fermò un candidato al +31%). Qui: quattro
motori, **tre mercati** (NASUSD, D30EUR, U30USD) e **due logiche diverse**
(rimbalzo su Supertrend / rimbalzo su EMA200). Se lo short è verde su **uno** e
rosso sugli altri tre, **non è un candidato**: è materiale per una domanda.

⚠️ **Non è meccanizzabile dal driver**: è un ragionamento su quattro tabelle, e
lo applica **il referto del round, a mano**.

### G4 · CAMPIONE (Emendamento regola A e regola B)

L'Emendamento chiede **≥ 150 operazioni**. Attesi al § 4.1.

**Emendamento regola B — la valvola**: *"il campione sottile sospende il giudizio
sul MERITO, mai sul RISCHIO"*.

- **RISCHIO**: si giudica **sempre**, a qualunque `n`. **Un DD è un fatto
  accaduto.** E su un round che smonta sedie che **stanno sui soldi**, il DD del
  lato è l'informazione più utile che esca da qui.
- **MERITO su EMADOW** (n atteso ≥ 150 per lato): si giudica.
- **MERITO su SWDOW, SUPNAS, SUPDAX**: 🔴 **SOSPESO per regola** se `n < 150`.
  Producono **indizi** e servono a G3 come conferma di direzione, non come
  promotori. (Stessa scelta firmata in R101 decisione 3 e in R107 G4.)

### G4-bis · 🚫 **LA PEGGIOR GIORNATA: NON MISURABILE IN R110** — e va detto **prima** della firma

> ⚠️ **Questo paragrafo era sbagliato fino al 25/08 sera** e diceva _"la peggior
> giornata, SEMPRE, per ogni cella, anche a `n` sottile"_. Era **una colonna
> ereditata dal round gemello R107** insieme alla macchina che la legge. Su
> questa famiglia di motori **non esiste**.

**MISURATO NEL SORGENTE AL PIN**, un `.mq5` per volta, non dedotto e non
ricordato:

| EA | array di `OnTester()` | header scritto da `OnTesterDeinit()` |
|---|---|---|
| `ABTG_SupRev_NAS_H1_Ottimizzato` | `double stats[7]` | `Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,Sharpe Ratio,Equity DD %,Trades` |
| `ABTG_SupRev_DAX_H4_Ottimizzato` | `double stats[7]` | idem |
| `ABTG_SuperWave_DOW_H1_Ottimizzato` | `double stats[7]` | idem |
| `ABTG_EMA200` | `double stats[7]` | idem |

**Otto colonne. `Peggior Giornata %` NON C'È.** Ce l'hanno i **tre EA
d'apertura di R107** (header a **undici** colonne: `…,Trades,Peggior Giornata %,
Perdite Consecutive Max,Serie Perdente Peggiore`), ed è da lì che questa
macchina è stata copiata.

➡️ **Conseguenza, scritta prima dei numeri**: la colonna `PeggGio%` della
tabella madre esce **`n/d` su tutte e dodici le celle, PER COSTRUZIONE**. Non è
un guasto del parser e non è un CSV mancante. Il driver **lo verifica a runtime
sulle intestazioni vere** e lo scrive come **RILIEVO**, perché un `n/d` da solo
si legge *"stavolta non è uscita"* mentre qui vuol dire *"non esce mai"*.

**Il rischio resta giudicato lo stesso** (Emendamento **regola B**: _"il campione
sottile sospende il giudizio sul MERITO, mai sul RISCHIO"_), su ciò che c'è:

- **DD equity IS e OOS** di ogni cella — che è un fatto accaduto;
- **`dDD%` contro il `00_metro`** della stessa famiglia — che è **letteralmente
  la domanda del round**: *il lato peggiora o migliora il rischio della sedia?*

**La strada per averla, dichiarata e NON percorsa qui.** R103 la misurò su
**queste stesse sedie** leggendo i **deal del report `.htm`** di una passata
singola (`RIGA_R103_CLASSIFICA_FLOTTA.ps1`, `$sd.PeggiorGiornata`), e usò la
colonna dell'OPTFRAME solo come **seconda misura indipendente, quando c'era**
(`if($cols -contains "Peggior Giornata %")`). Portarla in R110 vuol dire
**dodici passate SINGOLE in più** (`Optimization=0`, una per cella): è **un
round successivo**, non un'aggiunta di stasera.
⚠️ E non sarebbe nemmeno uniforme: **`ABTG_SupRev_DAX_H4_Ottimizzato` non ha
`ExportTrades()`** (gli altri tre sì), quindi su **SUPDAX** non esiste neppure
la strada dei per-trade.

👉 È la decisione **D6** del § 10.

### G5 · **NESSUNA PROMOZIONE ESCE DA QUESTO ROUND**

**Le quattro sedie girano sul conto 100k adesso.** Se un lato mostrasse edge (o
mostrasse di essere zavorra), è **una FIRMA di modifica contratto** con referto
suo. R110 produce **informazione**, non deploy.

### 5.1 📊 Cosa si scrive nel referto, per ogni cella

Sempre, e sempre col `n` accanto: `profitto IS/OOS · PF IS/OOS · DD IS/OOS ·
n IS/OOS · Δ vs la cella 00_metro della stessa famiglia (PF e DD) · esito G1 ·
esito G2 · esito G3`.
⚠️ **La colonna `peggior giornata %` c'è nella tabella ma esce `n/d` su tutte e
dodici le celle**, e il motivo sta nel **G4-bis**: questi quattro EA non la
esportano. È dichiarato nel referto, non lasciato al sentinella.

E **due righe obbligatorie in più**:

- **la riga della somma dei lati** (§ 1.1): `n metro / n long / n short`, con la
  frase che dice **perché non tornano**;
- **la riga della spina dorsale** (§ 4.2): per ogni short, il confronto **IS
  contro OOS** con la frase che dice **dove sta la discesa**.

> 🔴 **CONVENZIONE DI SENTINELLA, valida per TUTTE le colonne** (checklist 66):
> un numero **non misurato** si scrive **`n/d`**. Mai `-1`, mai `0.000`.
> `0.000` su un PF è un numero **plausibile** che si legge *"ha perso tutto"*.
> Vale per profitto, PF, DD, `n` **e** peggior giornata.
> ⚠️ **E la peggior giornata è il caso in cui il `n/d` onesto nasconde una misura
> IMPOSSIBILE**: esce `n/d` su tutte e dodici le celle **per costruzione** (G4-bis,
> decisione D6). Il referto lo dice a parole, perché il sentinella da solo non basta.

---

## 6. 🚫 COSA NON SI SPAZZOLA — e perché

- **Nessun parametro.** Zero griglie. L'unico asse `Y` è `InpMagic`.
- **Nessun filtro nuovo.** Chi volesse "aiutare" un lato con un filtro sta
  facendo **un altro round**.
- **Nessuna riga di MQL5.** I quattro `.mq5` hanno già `InpAllowLong` e
  `InpAllowShort` — cerca `input bool   InpAllowLong` (`ABTG_EMA200` **righe
  58-59**, gli altri tre **59-60**, misurate al pin del 25/08) — e il driver
  **si ferma se non li trova**, con un gate suo.
- **Nessuna coda 2026.07-08.** Allungare `Fino` sposterebbe anche lo split al
  40%, cambiando **sia l'IS sia l'OOS**: i numeri non sarebbero più confrontabili
  con R107.
- **Nessuna cella ricostruita.** Vedi § 2.5 (SupRev DAX H1).

---

## 7. 🕳️ IL REGISTRO DEI CADUTI E LA **SECONDA CACCIA**

**La regola** (19/08): quando un round dichiara un motore senza edge, si cercano
**meccanismi alternativi sulla stessa inefficienza**, mai *"parametri diversi
dello stesso motore morto"*. Ogni candidato passa la lista dei caduti **prima**
di entrare nell'imbuto.

**Passaggio fatto, il 25/08, sul `CENSIMENTO_LATI_SHORT` § 2** (i dieci short già
bocciati): **nessuna** delle quattro famiglie di R110 è in quella lista. I
bocciati sono aperture (R107, R54), ORB (R54), ORH/FADE (R42, R43), reverse
(R51), IntradayMomentum (R98), GapContinuation Nikkei. **Motori diversi,
inefficienze diverse.**

**E c'è un motivo per cui questa non è nemmeno "una caccia"**: qui non si cerca
un motore nuovo. Si **smonta un motore che già guadagna** per sapere da dove
viene quello che guadagna. La domanda _"ma non è pesca?"_ ha una risposta secca:
**una pesca produce candidati; questo round non può produrne nessuno (G5).**

⚠️ **La clausola di prudenza, scritta prima dei numeri**: il censimento § 1d
elenca **nove** motori simmetrici mai smontati. R110 ne prende **quattro**. Se
questi quattro dessero tutti *"short rosso"*, **non si estende il verdetto agli
altri cinque**: PTE Dow, PunteLarry, GapFill, SuperWave H2 e SupRev Nikkei
restano **non misurati**, e vanno detti tali.

---

## 8. 📤 COSA PUÒ USCIRE DA R110, e cosa no

**Può uscire:**

- ✅ il **primo numero in assoluto** sul lato short di **quattro sedie vive** —
  su EMADOW con un campione che può reggere l'Emendamento regola A;
- ✅ una misura del **rischio per lato** (**DD equity IS/OOS** e **`dDD%` contro il
  metro**) su sedie che stanno sui soldi: e quello si giudica **sempre**, anche a
  `n` sottile. ⚠️ **La peggior giornata no**: questi quattro EA non la esportano
  (G4-bis, decisione D6);
- ✅ un confronto **alla pari con R107** (stessa finestra, stesso banco, stesso
  metro di merito);
- ✅ una **proposta di round successivo**: modifica di contratto su una sedia,
  oppure l'estensione agli altri cinque simmetrici del censimento § 1d.

**NON può uscire:**

- ❌ nessun cambio al forward, nessuna sedia toccata, nessun contratto modificato;
- ❌ nessuna frase *"il lato short non ha edge"* senza il pezzo *"in questa epoca,
  su questi quattro motori"*;
- ❌ nessuna riproduzione di R103, e nessuna frase che lo lasci credere;
- ❌ nessun giudizio sugli altri cinque motori simmetrici mai smontati.

---

## 9. ⚙️ ESECUZIONE

- **48 passate** (12 celle × 2 finestre × 2 gemelle), **24 CSV**, tick reali.
  **[STIMA, non una previsione]**: R107 fece **24 passate a tick reali sulla
  stessa finestra in 9 minuti** (21:14→21:23, referto agli atti). R110 ne fa il
  **doppio**, su tre simboli i cui tick sono **già a disco**. **Stima 20-45
  minuti**, più la compilazione di quattro EA.
  ⚠️ **Il `n` alto di EMADOW (712 in R103) NON allunga la corsa**: a tick reali
  il tempo lo fa il **numero di tick della finestra**, non il numero di
  operazioni. `-OreMax` **10** è un tetto sull'**inizio** di nuovi file, non
  un'accetta su un lavoro in corso.
- **Una macchina, un lavoro**: R110 parte solo quando nessun altro round sta
  toccando il terminale. ⚠️ **R109 è in coda sulla stessa macchina**: i due non
  possono girare insieme.
- **Ripresa**: `-SoloEa 'EMADOW'` (anche in elenco, **fra apici**) e
  `-SoloCella <file>`. In tutti e due i casi **la cella `00_metro` della famiglia
  rigira**: è il denominatore e porta il gate G0-C. Costa **2 CSV**.
- **Il round non scarica storico** e non tocca `bases\<server>\ticks`.
- **Il round non scrive una riga di MQL5** e non tocca il forward.

---

## 10. ✍️ LE SEI DECISIONI — **FIRMATE** ("FIRMO R110", Claudio, 25/08/2026 sera)

### D1 · Quali famiglie entrano

**Proposta: QUATTRO** — SUPNAS (970913), SUPDAX H4 (970912), SWDOW (770511),
EMADOW (771531). **`SupRev_DAX_H1` (970911) NON entra**, per il motivo misurato
del § 2.5: **non è in nessuno dei due censimenti `.chr`** (23/08 e 25/08), non ha
file prova R103, non ha numero R103, non ha preset in repo. Il suo `00_metro`
andrebbe **ricostruito** dai default del sorgente, e una cella ricostruita non è
la cella viva.
**Alternativa**: farla entrare dichiarando in chiaro *"metro RICOSTRUITO dai
default del sorgente al pin, nessun `.chr` a confermarlo"* — costa 3 celle in più
(15 in tutto) e porta dentro l'unica famiglia del round di cui **non sappiamo se
gira davvero**.
👉 **[ ] SÌ, quattro famiglie   [ ] NO, aggiungi anche SupRev DAX H1 ricostruita**

### D2 · Il cancello di merito sui lati

**Proposta: identico a R54 criterio 3 — PF OOS ≥ 1,10 E positivo in IS.**
**Alternativa scartata**: un cancello più permissivo (`PF > 1,00`). Scartata
perché cambiare il metro adesso rende R110 incomparabile con R107, e il confronto
con R107 è metà del senso di questo round.
👉 **[ ] SÌ, quello di R54   [ ] NO (dire quale)**

### D3 · Il metro numerico che **non c'è** — G0-B

**Proposta: si dichiara `NON APPLICABILE` su tutte e quattro le famiglie**
(§ 5, G0-B), e al suo posto mordono **G0-A (antenato)** e **G0-C (gemelli)**. I
numeri R103 entrano nel referto **etichettati come non confrontabili** (OHLC vs
tick reali, finestra unica vs split).
**Alternativa scartata**: aggiungere 4 celle a **modello 1 (OHLC)** per
riprodurre R103. Scartata per due motivi, e il primo è tecnico: il driver
generico **spezza sempre in IS/OOS** (righe 465-468), quindi non riprodurrebbe
comunque la finestra unica di R103; e il secondo è la regola di casa
(`R103_CRITERI` § 3.2): *"un OHLC non deve nemmeno poter finire nella stessa
tabella di un tick reale"*.
👉 **[ ] SÌ, G0-B non applicabile e dichiarato   [ ] NO, voglio anche le celle OHLC**

### D4 · Tre celle per famiglia, o due?

**Proposta: TRE** (`00_metro` + `01_long` + `02_short`). Il metro costa **8
passate in più** in tutto il round, e in cambio dà: **(a)** l'unico ancoraggio
verificabile del round (il gate dell'antenato gira **su di lui**), **(b)** il
denominatore vero per i delta (la sedia è quella, non il lato long), **(c)** la
misura dello sbilancio del § 1.1, che senza il metro non esiste.
**Alternativa**: solo i due lati, e il metro preso da R103 — cioè da un **altro
banco** (§ G0-B). Sarebbe confrontare tick reali con OHLC dentro la stessa
tabella.
👉 **[ ] SÌ, tre celle   [ ] NO, solo i due lati**

### D5 · Cosa si fa se una famiglia non passa G0-A o G0-C

**Proposta: quella famiglia si FERMA** (le sue celle dei lati non vengono
nemmeno lanciate: sopra un metro sbagliato non misurerebbero niente), **e le
altre tre vanno avanti.** Stessa scelta firmata in R100, R101 e R107: *una sedia
storta non porta via anche le altre.*
👉 **[ ] SÌ, famiglia ferma e le altre avanti   [ ] NO, si ferma tutto il round**

### D6 · La **peggior giornata** che questi quattro EA non esportano

⚠️ **Decisione aggiunta il 25/08 sera, in verifica, PRIMA della firma** — perché
un criterio firmato non si corregge dopo (checklist 57). Il § 5 **G4-bis**
prometteva la peggior giornata *"sempre, per ogni cella, anche a `n` sottile"*:
è **una colonna ereditata da R107** insieme alla macchina che la legge, e su
questi quattro motori **non esiste** (`double stats[7]`, header a **otto**
colonne — misurato nel sorgente al pin, un `.mq5` per volta).

**Proposta: si dichiara `NON MISURABILE` in R110.** La colonna `PeggGio%` resta
nella tabella madre ma esce **`n/d` su tutte e dodici le celle, per
costruzione**, e **il driver lo verifica a runtime** sulle intestazioni vere del
CSV e lo scrive come **RILIEVO** — perché un `n/d` da solo si legge *"stavolta
non è uscita"*, mentre qui vuol dire *"non esce mai"*. Il **rischio si giudica
lo stesso**, su **DD equity IS/OOS** e sul **`dDD%` contro il `00_metro`**.

**Alternativa**: prenderla come la prese R103, dai **deal del report `.htm`** di
una passata singola — **dodici passate in più** (`Optimization=0`), quindi un
round successivo. E comunque **non uniforme**: `ABTG_SupRev_DAX_H4_Ottimizzato`
non ha nemmeno `ExportTrades()`, quindi su **SUPDAX** non c'è neppure la strada
dei per-trade.

👉 **[ ] SÌ, NON MISURABILE e dichiarata (la colonna esce n/d, il rischio si
legge sul DD)   [ ] NO, voglio la peggior giornata: si aggiungono le 12 passate
singole**

### 10.1 🟢 Cosa **non** serve firmare, e perché

- **Non serve una verifica a grafico** delle celle: i file prova sono la copia
  riga per riga degli artefatti R103, e il driver **lo verifica da solo** (G0-A).
- **Non serve firmare G5**: "nessuna promozione" non è mai stata in discussione
  su un round che tocca quattro sedie sui soldi.

---

## 11. 🚫 QUELLO CHE R110 **NON** FARÀ, dichiarato

1. **Non promuove e non boccia niente in forward.** G5.
2. **Non giudica il driver.** La riga produce i CSV, li conta e mette a referto i
   delta. **I cancelli G1-G5 li applica il REFERTO DEL ROUND, a mano.** G3 in
   particolare **non è meccanizzabile**: è un ragionamento su quattro tabelle.
3. **Non riproduce R103** e non pretende di farlo (G0-B).
4. **Non misura lo spread**, non misura i sotto-periodi, non misura il regime.
5. **Non estende niente agli altri cinque motori simmetrici** del censimento
   § 1d, che restano **non misurati**.
6. **Non chiude la domanda sul lato short.** La chiude **per questa epoca e per
   questi quattro motori** — ed è comunque la prima volta che quei lati hanno un
   numero.
