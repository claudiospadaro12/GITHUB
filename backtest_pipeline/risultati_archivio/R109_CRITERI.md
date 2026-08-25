# ✍️ R109 — **ATR EXHAUSTION & VOLUME SPIKE** su indici M15 (D30EUR · U30USD · NASUSD), **LONG e SHORT separati** — CRITERI **[DA FIRMARE]**

> 🔒 **Il titolo porta `[DA FIRMARE]` e non è decorazione.** Il driver
> `righe/RIGA_R109_ATREXH.ps1` **scarica questo file al pin e ci cerca dentro
> quella stringa**: se la trova, il **giro a vuoto parte lo stesso** (non apre
> MT5, non produce nessun numero, **ma COMPILA**) e la **CORSA VERA si ferma
> con `exit 2`**, a meno che Claudio non passi `-CriteriFirmati`, che è la sua
> firma in riga e finisce **scritta nel referto**.
>
> **Sono OTTO decisioni, tutte con la proposta già scritta (§ 10).** Si può
> rispondere `FIRMO CON PROPOSTE` in una riga.

---

## 0. 📌 DA DOVE NASCE — e cosa **non** è

**Mandato di Claudio (25/08/2026):** _"Dobbiamo avere più strategie su TF 5 min
e 15 min. Ci servono per la challenge."_

Questo round è la **prima misura in assoluto** di `ABTG_AtrExhaustVol.mq5`,
porting del candidato **P2** della caccia M5/M15 indici del 25/08
(`caccia_strategie/CACCIA_M5M15_INDICI_2026-08-25.md`, voto **9/10 — PROVA
SUBITO`), con la tesi del porting in `ATREXHAUST_TESI.md`.

### 🚨 LE TRE COSE CHE VANNO DETTE PRIMA DI QUALUNQUE ALTRA

1. 🔴 **L'EA NON È MAI STATO COMPILATO.** Chi l'ha scritto **non ha
   MetaEditor**: nel `.mq5` c'è scritto a chiare lettere _"NON compilato ne'
   testato da chi ha scritto il file"_. 👉 **La prima `F7` della sua vita
   avviene sul PC di Claudio, dentro questo round**, e la FASE COMPILA del
   driver è costruita per **fermarsi bene** e restituire il log del
   compilatore, non per tirare dritto. Un errore di compilazione qui **è un
   esito previsto**, non un guasto della riga.
2. 🔴 **NON ESISTE UN METRO.** R108 poteva chiedere alla cella `00_metroH1` di
   **riprodurre** i numeri di R103. Qui non c'è niente da riprodurre: nessun
   numero di questo motore esiste in casa, e **nessun numero d'autore entra in
   questo documento** (mandato §3D: Pine → MQL5 non è un porting, è una
   riscrittura; il tester di TradingView è ottimista di natura). Al posto del
   gate dell'antenato c'è il **GATE DEL PORTING** (§ 1.1): ogni file prova
   viene confrontato **riga per riga contro i default LETTI NEL SORGENTE**.
3. 🔴 **UN SOLO REGIME, E IL MOTORE È CONTROTENDENZA.** Lo storico BCM sugli
   indici parte dal **2024.09.26** (misurato, `REFERTO_SONDA_STORICO_17-08.md`,
   stato `COMPLETO` = *il broker non ha altro*) ≈ **23 mesi prevalentemente
   RIALZISTI**. Un fade a un livello, in un toro, **incassa serie di stop dal
   lato long-di-continuazione e trova terreno buono dall'altro** — o il
   contrario. **Non lo sappiamo, e non lo possiamo sapere da questa finestra.**
   👉 Vedi § 7: **questo round è DIAGNOSTICO sul MERITO e VALIDO sul RISCHIO.**

---

## 1. 🧭 IL METODO — **sei celle, un asse solo, ZERO griglia**

### ⚖️ REGOLA DEI DUE LATI (CLAUDE.md, congelata il 25/08)

> _"Su Nasdaq, DAX e Dow ogni analisi misura SEMPRE tutti e due i lati (long E
> short) — anche se un lato è già vivo in forward, si RITESTA."_

Qui è ancora più stringente che altrove, per due motivi **specifici di questo
motore**:

- lo **short è il lato che abbiamo simmetrizzato** rispetto al Pine
  (`ATREXHAUST_TESI.md` § 4.3: l'autore misurava l'esaurimento con la
  **chiusura** sullo short e con l'**estremo** sul long, senza dirlo). È
  l'**unico scostamento dentro il motore**, e va misurato da solo;
- su un motore **controtendenza in un toro**, i due lati **non sono la stessa
  scommessa**: mescolarli in una cella "entrambi" produrrebbe una media che non
  descrive nessuno dei due.

| # | cella | simbolo | `InpAllowLong` | `InpAllowShort` | file prova |
|---|---|---|:--:|:--:|---|
| 1 | `00_long`  | D30EUR | **true**  | false | `R109_D30EUR_00_long.txt` |
| 2 | `01_short` | D30EUR | false | **true**  | `R109_D30EUR_01_short.txt` |
| 3 | `00_long`  | U30USD | **true**  | false | `R109_U30USD_00_long.txt` |
| 4 | `01_short` | U30USD | false | **true**  | `R109_U30USD_01_short.txt` |
| 5 | `00_long`  | NASUSD | **true**  | false | `R109_NASUSD_00_long.txt` |
| 6 | `01_short` | NASUSD | false | **true**  | `R109_NASUSD_01_short.txt` |

**TF: M15** su tutte e sei. **Finestra: `2024.09.26 → 2026.08.21`**, cioè
**tutto lo storico BCM disponibile** (§ 4). **Modello 4 = TICK REALI.**

### 🔴 1.0 LA SOMMA DEI DUE LATI **NON** È LA CELLA "ENTRAMBI" — dichiarato ora

Ogni cella è un lancio a sé, con un magic suo. Quindi:

- ogni lato ha il **suo** `InpMaxTradesPerDay = 3` → **un simbolo può fare fino
  a 6 operazioni al giorno in questo round**, mentre **un solo EA con tutti e
  due i lati accesi ne farebbe 3**;
- ogni lato ha la **sua** "una posizione alla volta" → in R109 long e short
  **non si bloccano a vicenda**, in campo sì.

👉 **Sommare le due righe di un simbolo dà un limite SUPERIORE**, non la cella
"entrambi". **La cella "entrambi" in R109 NON si misura**: si misura quando si
sa quale lato ha qualcosa da dire (round successivo). Questo è il **costo
dichiarato** della regola dei due lati, e si paga volentieri: senza, i due lati
non sarebbero distinguibili affatto.

### 1.1 Come è garantita l'attribuzione — **verificata dal codice**, non promessa

Il driver, **prima di aprire MT5**, pretende su ogni file:

- **GATE DELLA STELLA**: la cella `01_short` differisce dalla `00_long` dello
  stesso simbolo **esattamente su `InpAllowLong`, `InpAllowShort`, `InpMagic`,
  `InpComment`** e su **nessun altro input**. Non basta *contare* le righe
  diverse: due righe **sbagliate** darebbero lo stesso conteggio;
- 🆕 **GATE DEL PORTING** — *l'analogo dell'antenato di R108, checklist **72***.
  La stella confronta le due celle **fra loro**: per costruzione **non può
  vedere** una riga storta uguale in **tutte e due** (in R108 questa classe di
  difetto lasciava scoperti 64 input su 70, con tutti i gate verdi e uscita 0).
  Qui non c'è nessun round precedente da cui copiare, **ma c'è il sorgente**:
  il driver **estrae i default da `ABTG_AtrExhaustVol.mq5`** (`input <tipo>
  <nome> = <valore>;`) e li confronta **numericamente** con i valori pinnati in
  ogni file prova. **I soli delta ammessi sono `InpAllowLong`, `InpAllowShort`,
  `InpMagic`, `InpComment`** (più la riga `InpNewsCurrencies`, **tolta**: un pin
  di stringa vuoto MT5 lo ignora, ed è la regola che `controlla_prova.py`
  verifica). 👉 **È questo gate che rende vera la frase "cella AUTORE": non è
  una dichiarazione, è un confronto.**
- 🆕 **GATE SUL SORGENTE — i cinque punti del revisore**, presi da
  `ATREXHAUST_TESI.md` § 8 e trasformati in `if`. Il driver si ferma se nel
  `.mq5` al pin non trova:
  1. `int c = 1 + InpPivotRight;` in `AggiornaPivot()` — se qualcuno lo
     abbassasse a `InpPivotRight`, **il pivot ridipinge e da lì in poi ogni
     backtest è finto**;
  2. `CopyTickVolume(_Symbol,gTF,1,` — la lettura del volume **parte dallo
     shift 1**: se partisse da 0, la barra in formazione entrerebbe nel calcolo;
  3. in `VolumeSpike_Calc`, `if(media<=0 || mult<=0) return(false);` — **niente
     `return(true)` di cortesia** sui dati mancanti. Il volume è il MOTORE, non
     un filtro;
  4. **nessun `input` che spenga il volume** (`InpUseVolume` & simili): se
     esistesse, l'EA potrebbe girare senza la sua tesi e la misura sarebbe
     irripetibile;
  5. `#property version "1.00"` — il sorgente è quello che credo.
- **GATE DEI VALORI**: `InpAllowLong`/`InpAllowShort` valgono **davvero** quello
  che il nome della cella promette (e **mai tutti e due `false`**, che l'EA
  rifiuterebbe in `OnInit`), e la **geometria della cella AUTORE** è quella del
  § 6;
- **GATE DELL'ASSE UNICO**: un solo flag `Y` per file, ed è `InpMagic`. Più di
  un asse sarebbe una **griglia**, cioè un altro round;
- **GATE DEI MAGIC**: unici fra i file, **vergini**, mai un magic vivo o di un
  round precedente — **e mai `774401`**, che è il **default compilato** dell'EA
  (§ 2);
- **`@SIMBOLO` / `@PERIODO` / `@DAQUANDO`** confrontati, non creduti.

### 1.2 ⚙️ Come gira ogni cella — **due lanci, e rispondono a domande diverse**

È la macchina di **R103/R108**, non una macchina nuova (checklist 9: una
riscrittura non può perdere le funzioni del gemello):

| lancio | `.ini` | cosa produce | a cosa serve |
|---|---|---|---|
| **SINGOLA** sulla finestra intera | `Optimization=0`, `Report=` | il **report `.htm` coi DEAL** (Ora, Direzione, Tipo, Volume, **Prezzo**, Profitto, Commissioni, Swap) + **le righe `[ATREXH]` nel log** | **TUTTO IL PASSO 0** + il **gate dell'AUTOTEST** |
| **GEMELLE** sulla finestra intera | `Optimization=1`, sweep su `InpMagic` | `OptResults_*.csv` via **OPTFRAME** | **profitto / PF / DD equity / n / peggior giornata** + **igiene dei gemelli** |

**Passate**: 2 per cella × 6 celle = **12**, più **1 passata di COLLAUDO**
(§ 3.1) = **13**.

> ⚠️ **Perché la SINGOLA e non solo l'ottimizzazione, e non è burocrazia.**
> `OptResults` dà **numeri di riepilogo**. Il PASSO 0 chiede **il take in punti
> indice** e **la durata in barre**: sono grandezze **per operazione**, e
> l'unico artefatto che le contiene con **entrambi i prezzi** (ingresso *e*
> uscita) è la tabella Deal del report `.htm`. Il file per-trade dell'EA
> (`abtg_trades_*.csv`, scritto da `ExportTrades()` in `OnTester`) **NON basta**:
> misurato nel sorgente il 25/08, scrive **solo i deal di uscita** (riga 1075:
> `if(entry!=DEAL_ENTRY_OUT ...) continue`) — niente prezzo d'ingresso, quindi
> **nessun take calcolabile**. È la **traduzione dichiarata** che la checklist
> **57** impone: *(1)* lo strumento nominato non può produrre la misura, *(2)*
> la misura si fa **qui**, *(3)* l'intento — *"letto dalle serie per operazione,
> non dal riepilogo"* — **è conservato**.

### 1.3 🚫 NIENTE GRIGLIA ALLA PRIMA USCITA — ed è la decisione **D1**

Le quattro ablazioni che la tesi elenca al suo § 6 — **prossimità PERC vs ATR**,
**grilletto AUTORE vs CLOSE**, **buffer/pavimento dello SL**, **parziale +
BE + trailing** — **non girano in R109**.

**Motivo, in una riga:** su un motore **mai compilato e mai misurato**, una
griglia non è un'ottimizzazione, è una **pesca**. Non sappiamo ancora *quante*
operazioni fa, *quanto* incassa per operazione, *se* il cap giornaliero morde,
*se* i tick ci sono. Una superficie costruita su un `n` sconosciuto è
esattamente la cella "verde per caso" che la regola della **SECONDA CACCIA**
(CLAUDE.md, 19/08) dice che **brucia la challenge**.

👉 **R109 misura il porting NUDO, ai default dell'autore.** Le ablazioni sono un
**round successivo**, e girano **solo se R109 passa S0**.

---

## 2. 🧊 LE SEI CELLE E I MAGIC — blocco **7744xx**, VERGINE

`grep -rno '7744[0-9][0-9]'` su tutto il repo il 25/08/2026: **4 occorrenze,
tutte del valore `774401`**, e stanno **solo** nel sorgente nuovo
(`ABTG_AtrExhaustVol.mq5` riga 178) e nella sua tesi (`ATREXHAUST_TESI.md`
righe 3, 133, 408). **Nessun magic 7744xx ha mai girato**, né in un round né in
una sedia.

| simbolo | cella | lato | base | gemelle INTERA | singola |
|---|---|---|---:|---|---|
| D30EUR | `00_long`  | LONG  | 774410 | 774410/774411 | 774412 |
| D30EUR | `01_short` | SHORT | 774420 | 774420/774421 | 774422 |
| U30USD | `00_long`  | LONG  | 774430 | 774430/774431 | 774432 |
| U30USD | `01_short` | SHORT | 774440 | 774440/774441 | 774442 |
| NASUSD | `00_long`  | LONG  | 774450 | 774450/774451 | 774452 |
| NASUSD | `01_short` | SHORT | 774460 | 774460/774461 | 774462 |
| — | **COLLAUDO** (§ 3.1) | — | — | — | **774400** |

🔴 **`774401` È VIETATO, ed è il default compilato dell'EA.** Se una cella
girasse col default — perché il pin è saltato, perché MT5 si è ricordato
l'ultimo valore (checklist 25) — **il magic lo direbbe**. Il driver lo mette
fra i `MagicVietati` e si ferma.

📌 **Perché un magic diverso per ogni lancio** (pattern R103/R108): l'EA scrive
un file per-trade `abtg_trades_<EA>_<Simbolo>_<magic>.csv` in `Common\Files`, e
`FILE_WRITE` **tronca**. Con lo stesso magic su due lanci resterebbe solo
l'ultimo, e nessuno saprebbe di quale passata è.

**Rischio: `InpRiskPercent = 1.0`** in tutti e sei i file — è il **default
dichiarato del porting** (`ATREXHAUST_TESI.md` § 4.6). ⚠️ **Il rischio % è un
moltiplicatore lineare del P/L e del drawdown**: in campo sul 100k le sedie
girano allo **0,65%**, l'autore usava **0,5%**. Ogni euro e ogni % di DD di
questo referto va **moltiplicato per 0,65** (o 0,5) prima di confrontarlo con
qualcos'altro. **Nessuna conclusione sul MERITO cambia; tutte quelle sul
RISCHIO sì.**

---

## 3. 🚨 IL **CANCELLO ZERO (S0)** — il costo, e si legge PRIMA di qualunque PF

È il criterio **C1** della caccia (_"il costo è il criterio, non un contorno"_)
e il cancello che ha chiuso **R98 in una riga** (lordo medio **−0,31 punti
indice** su 410 operazioni).

### 3.0 🧪 PRIMA ANCORA: il **PASSO 0 CONTA**

**Prima di leggere qualunque PF**, il referto scrive, per ogni cella:
`n` totale · giorni con almeno un'operazione · **massimo di operazioni in un
giorno** · operazioni per seduta · data della **prima** e dell'**ultima**
operazione. **Poi** si guarda il take. **Poi** tutto il resto.

### 3.1 🧷 IL COLLAUDO DELL'AUTOTEST — **gate, e viene PRIMA di tutto**

L'EA porta dentro un **autotest a sette blocchi** sul nucleo puro (pivot,
prossimità, esaurimento, volume, i due grilletti, il segnale completo, il
pavimento dello SL, l'orario) e chiude con una riga secca:

```
[ATREXH][AUTOTEST] esito motore: SETTE BLOCCHI SU SETTE, la regola ragiona come la firma.
[ATREXH][AUTOTEST] esito motore: DIVERGE: non usare i risultati, c'e' da guardare il codice.
```

⚠️ **Si legge ESEGUENDO, non compilando** (checklist **20**): stampa in
`OnInit`, quindi `F7` non la produce. E **mai attaccando l'EA a un grafico**: sul
PC di backtest il terminale è collegato al **conto vivo** (checklist 26).

👉 Perciò il driver fa una **PASSATA DI COLLAUDO** dedicata: **una sola cella,
un mese, modello 1**, magic **774400**, che **non produce nessun numero del
round** e serve solo a leggere quelle righe. Costa minuti, e **fallisce presto**
invece che dopo ore di tick reali.

**Tre stati, e sono nel codice:**

| stato | cosa fa il driver |
|---|---|
| `SETTE BLOCCHI SU SETTE` | ✅ si prosegue |
| **`DIVERGE`** | 🔴 **si ferma TUTTO il round** (non "quel simbolo": il codice è lo stesso ovunque). *"Se stampa DIVERGE, i risultati non si usano"* — tesi § 8.8 |
| **righe non trovate** | 🟠 si prosegue, **ma ogni numero esce marcato `NON CONVALIDATO`** e il round **non può uscire `OK`**. **Non è un verde per assenza** (checklist 28-bis): non aver trovato il log **non è** aver letto un autotest riuscito |

🟢 **E il driver legge una seconda riga**, quella che l'EA stampa da solo in
`OnInit` quando qualche variante è accesa:
`ATTENZIONE: almeno una variante e' accesa. Questa cella NON e' la cella AUTORE
del porting.` **Se compare, è un PROBLEMA**: vuol dire che la cella non è quella
che i criteri dicono.

### 3.2 🔴 E il backtest da solo NON risponde

Qualcuno obietterà: *"se il backtest paga già lo spread e il PF esce > 1, il
costo è già dentro"*. **È vero solo a metà, e la metà che manca è quella che
conta:**

- a **modello 4 (tick reali)** il bid/ask arriva dai tick, quindi lo spread **è**
  storico e variabile — **se i tick reali ci sono davvero** (§ 4.2);
- in **nessun** modello c'è **slippage**, e in nessuno c'è l'allargamento da
  news o da apertura;
- ⚠️ **e questo motore è particolarmente esposto**: l'ingresso nasce da un
  **estremo di barra** e lo stop sta **a un tick dal minimo** (buffer 0 di
  default). **R55 ha misurato che 1,5 punti indice di slippage sfondavano il
  10% sull'ORB.**

🎯 **Perciò S0 non chiede "il backtest è positivo?": chiede "quanto è SOTTILE il
margine su cui il backtest è positivo?".**

### 3.3 Le misure del PASSO 0 — **definite ORA, prima dei numeri**

Tutte lette dalla tabella **Deal del report `.htm`** della passata SINGOLA,
accoppiando i deal `in` → `out`. Con **una posizione alla volta per magic** e
**`InpTP1Pct = 0`** (niente parziali) la sequenza **deve** essere alternata:
**se non lo fosse, la misura si dichiara NON MISURATA e non si stima.**

📏 **UNITÀ: PUNTI INDICE.** Su BCM D30EUR, U30USD e NASUSD hanno **2 decimali**
→ **1 punto indice = 100 punti MT5 = 1,00 di prezzo** (misura R97/R98, e
`README_ABTG_Aperture.md` riga 141: *"Cifre=2, tick=0.10 → 1 punto indice = 100
punti"*). Il take in punti indice è quindi `|prezzo_out − prezzo_in| / 1,0`.
**Nessun "pip": su un indice il pip non esiste** (classe di difetto "QB 45").

**S0a — IL TAKE. 🔴 CANCELLO, per cella.**

- `take_netto` = `|prezzo_out − prezzo_in|` sulle operazioni **VINCENTI**
  (netto = Profitto + Commissioni + Swap > 0).
  📌 **È già AL NETTO dello spread**: per un long il prezzo d'ingresso è
  l'**ask** e quello d'uscita il **bid**, cioè i due lati del book;
- `take_lordo` = `take_netto + spread_dichiarato`;
- **CONDIZIONE**: **mediana** di `take_lordo` **≥ 3 × spread_dichiarato**.
  Si usa la **MEDIANA** e non la media: una manciata di trade lunghissimi
  alzerebbe la media e nasconderebbe che il grosso sta sotto il costo;
- **tre stati**, come R108: `SUPERATO` · `FALLITO` · **`SOSPESO`** quando il
  rapporto cade dentro **3,0 ± 0,5**, perché la soglia poggia su uno **spread
  NON MISURATO** (D4). *Dare un verdetto secco su un numero dentro
  l'incertezza del suo metro è il modo più elegante di sbagliare.*
- Fallisce → **quella cella si chiude qui**, e il verdetto si scrive **con un
  numero**. **Le altre proseguono** (D6).

**S0b — LA FREQUENZA. Misura, non cancello.** `n` totale, giorni operativi,
**operazioni per seduta**. Atteso dichiarato **[STIMA del cacciatore, NON
NOSTRA]**: **1-3 trade/giorno per indice**, che coi due lati separati si legge
come **~0,5-2 per lato**. 👉 **Se `n` esce molto più basso, è già un
risultato**: la frequenza è la ragione per cui questo round esiste (challenge).

> 🔴 **E LA FREQUENZA MISURATA È CENSURATA DALL'ALTO, per costruzione.**
> `InpMaxTradesPerDay = 3` **taglia** le giornate più affollate. Perciò il
> referto stampa **quante giornate hanno toccato il cap**: se sono tante, il
> numero letto è un **limite inferiore**, non la frequenza vera del motore.
> Chi legge "1,2 al giorno" senza questa colonna legge un numero mutilato.

**S0c — LA DURATA. Misura, non cancello.** Media e mediana in **barre M15**
(`(ora_out − ora_in) / 900 s`). Motivo dichiarato: `arXiv 2605.04004` § 6.2
misura che gli unici segnali intraday sopravvissuti alla falsificazione
_"hold positions for **12-15 bars** rather than 1-6"_. **Se la mediana esce 1-3
barre, va scritto come segnale di allarme sulla robustezza, anche a cancelli
verdi.**

**S0d — LA PERDITA MEDIANA ≈ **R**. Misura, non cancello.** Le operazioni
perdenti escono allo stop, quindi la **mediana della loro distanza in punti
indice** è la miglior stima disponibile di **R**, che il report non contiene.
Serve a rispondere al **rischio n.5 della tesi**: _"stop molto stretto → lotto
grande → lo slippage si mangia l'operazione intera"_. **Se R mediano esce sotto
~5 punti indice**, il referto scrive un allarme e la domanda per il round dopo è
`InpMinSLPts` (il pavimento, che oggi è spento).

**S0e — LA PRIMA E L'ULTIMA OPERAZIONE.** § 4.1. Obbligatorie, e si leggono
**prima** dei numeri.

---

## 4. 📅 LE FINESTRE — e i tre paletti

### 4.1 🚩 `@DAQUANDO 2024.09.26` è **MISURATO** (per le BARRE), e il PASSO 0 lo verifica

`REFERTO_SONDA_STORICO_17-08.md` misura per `D30EUR`, `U30USD` e `NASUSD` la
**prima data 2024.09.26** con stato **`COMPLETO`**, che nel vocabolario di quel
referto vuol dire *"il broker non ha altro"*. La misura dei tick su U30USD
(20/08) lo conferma: `M1 650.255 barre, prima data 2024.09.26`.

⚠️ **Il tetto delle 100.000 barre NON morde su questa finestra** — e il conto è
scritto qui perché sia controllabile: un indice CFD fa ordine di **440-500 barre
M15 a settimana**; ~100 settimane × 470 ≈ **47.000 barre**, cioè **meno di
metà** del tetto. **[DERIVATO, non misurato]**: il driver scrive comunque
`[Charts] MaxBars=2000000000` nei suoi `.ini`, e **[INFERITO]** che il tester lo
onori.

👉 **Il PASSO 0 dichiara la data della PRIMA e dell'ULTIMA operazione, cella per
cella.** Soglia dichiarata ora: **prima operazione entro 2 mesi** dall'inizio →
`FINESTRA PIENA`; oltre → `FINESTRA ACCORCIATA`, e va nei **PROBLEMI**.
⚠️ **2 mesi, non i 6 di R103/R108**: su una finestra di 23 mesi, sei mesi
sarebbero **un quarto della finestra** buttato senza accorgersene.

### 4.2 🎫 IL SECONDO PALETTO: **la profondità dei TICK è misurata su UNO dei tre**

Cercato il 25/08 in `risultati_archivio/misura_tick/`: **esiste un solo
referto, ed è `U30USD`** — e dice:

```
U30USD,TICK,67618571,2024.09.26,-,TICK REALI PARZIALI
```

Per **D30EUR** e **NASUSD** **non esiste nessuna misura della profondità a
TICK** in tutto il repo. La sonda del 17/08 ha misurato **le BARRE**, non i
tick.

🔴 **È la checklist 18 in persona** (_"la profondità misurata su un TF, la corsa
girata su un altro"_), e morde forte: a **modello 4** senza tick reali MT5
**non si ferma** — ripiega e produce **numeri plausibili e falsi**. **Nessuna
guardia del driver può accorgersene in modo affidabile**: la frase esatta che il
tester scrive nel Journal non è misurata, e un `grep` che non trova niente
sarebbe un **verde per assenza** (checklist 28-bis).

➡️ **È la decisione D2.** Comunque sia firmata, il driver cerca al pin
`risultati_archivio/misura_tick/misura_tick_<SIMBOLO>.csv`, **stampa la riga
`TICK` e la DATA DEL FILE**, e se manca scrive un **RILIEVO obbligatorio**
(checklist 23: chi consuma un artefatto ne guarda **l'età**, non solo
l'esistenza — sopra i **30 giorni** esce un rilievo anche se il file c'è).

### 4.3 🔴 IL TERZO PALETTO — **NIENTE IS/OOS IN R109**, ed è la decisione **D3**

**Emendamento della Finestra, regola A:** _"L'IS si dimensiona sulle OPERAZIONI
(≥150), non sugli anni. **DOVE collocarla NON è deciso**: si usa la finestra che
lascia un OOS di almeno 150 trade."_

👉 **Quella regola non si può applicare PRIMA di aver contato.** Con la stima
del cacciatore (0,5-2 op/giorno/lato) e ~490 sedute, una divisione 50/50 darebbe
per finestra **da ~120 a ~490 operazioni**: cioè **potrebbe stare sotto soglia,
oppure no**, e non lo sappiamo. Tagliare adesso vorrebbe dire **scegliere il
taglio prima di conoscere il campione** — esattamente il contrario di quello che
l'Emendamento chiede.

**Proposta: R109 gira la SOLA finestra intera e CONTA.** La divisione IS/OOS si
dimensiona nel round successivo, **sui conteggi veri**. Costo dichiarato: **da
R109 non esce nessun giudizio out-of-sample**, e infatti non lo pretende (§ 7).
Beneficio: 12 passate invece di 24 a tick reali, e nessun numero che nessuno può
usare.

### 4.4 🚫 M5 — dichiarato ORA: **non gira in R109**

Aritmetica: ~1.400-1.500 barre M5 a settimana su un indice → 100.000 / 1.450 ≈
**69 settimane ≈ 1,3 anni**, cioè **meno dello storico disponibile**: su M5 il
tetto **morderebbe** e la finestra andrebbe spezzata in tranche. **[DERIVATO]**.
👉 **Prima si misura M15 su tutto lo storico. M5 è un round a sé**, e la tesi lo
prevede come seconda cella (§ 5 della tesi), non come cella di questa.

---

## 5. 🚧 I CANCELLI

### A0 · **AUTOTEST** — 🔴 **FATALE per tutto il round**
§ 3.1. `DIVERGE` → ci si ferma. Righe non trovate → si prosegue **marcati
`NON CONVALIDATO`**, e il round non può uscire `OK`.

### C0 · **COMPILAZIONE** — 🔴 **FATALE, ed è la prima volta**
Il `.ex5` deve essere **riscritto adesso** (verdetto sul `LastWriteTime`
prima/dopo, checklist 69 e 54). Se non lo è, il driver **rimette il `.mq5`
com'era**, mette il **log del compilatore nello zip** e si ferma. **Vale anche
in `-SoloControllo`**, altrimenti il giro a vuoto non direbbe niente sulla
compilabilità (checklist 39) — ed è **il motivo principale** per cui il giro a
vuoto di questo round va fatto per primo.

### S0 · **CANCELLO ZERO SUL COSTO** — 🔴 **FATALE, per cella**
§ 3.3. **Si legge PRIMA di qualunque PF.**

### G1 · **MISURABILITÀ** (Emendamento regola A)
- `n` **≥ 150** → il **MERITO** si giudica (nei limiti del § 7);
- `n` **< 150** → **MERITO SOSPESO**, e il **RISCHIO si legge lo stesso, a
  qualunque `n`** (regola **B**: un drawdown è un fatto accaduto). È un
  **RILIEVO**, cioè un **risultato del round**, non un guasto;
- `n` **< 20** → **NON MISURABILE**, mai *"non funziona"*.

### G4 · **PEGGIOR GIORNATA** — misurata **sempre**, anche a merito sospeso
Muro prop giornaliero: **−5% su 100k**. La peggiore misurata in casa (R51) è
**−2,06%**. ⚠️ **Su un motore a 3 operazioni/giorno per lato e su TRE indici
correlati** — DAX, Dow e Nasdaq si esauriscono spesso **insieme** — **il numero
da guardare non è il DD totale, è la peggior giornata**. Il referto la stampa in
**due viste**: dal report `.htm` (con la **data**) e dalla colonna OPTFRAME.

### G5 · **NESSUNA PROMOZIONE ESCE DA QUESTO ROUND**
R109 produce **misure**. Nessuna sedia, nessun forward, nessuna taglia. E la
tesi lo dice già in testa: *"NON va in forward."* Un deploy è **una firma
separata, con il suo referto**.

### 🚫 Cosa NON è un cancello in R109, e va detto
**G2 (merito) e G3 (coerenza cross-simbolo) NON si applicano**, perché il § 7
sospende il merito per costruzione. Se S0 e G1 fossero verdi su più celle, il
referto del round **elenca i numeri e propone il round successivo**; non
promuove e non boccia.

---

## 6. 🧊 LA GEOMETRIA DELLA CELLA "AUTORE" — cosa NON cambia mai

Il driver pretende questi valori **in ogni file prova** (oltre al gate del
porting, che li copre tutti):

| input | valore | perché |
|---|---|---|
| `InpProxMode` | **0** (PERC) | modo dell'autore. Il modo ATR è l'ablazione n.1, **non gira qui** |
| `InpTrigMode` | **0** (AUTORE) | idem, ablazione n.2 |
| `InpTP1Pct` | **0** | **niente parziale**: la cella autore è SL + TP 2R e basta |
| `InpUseTrailAtr` | **false** | idem |
| `InpOneTradePerLevel` | **false** | l'autore non ce l'ha |
| `InpSLBufferPts` / `InpMinSLPts` | **0** / **0** | stop **esattamente** sul livello, pavimento spento |
| `InpUseHourFilter` / `InpUseNewsFilter` / `InpFridayClose` | **false** | nessun filtro appiccicato sopra il motore |
| `InpMaxTradesPerDay` | **3** | 🔴 **l'unico default che si scosta dal Pine**, e per **regola di casa** (C6), non per misura |
| `InpVolSpikeMult` / `InpVolSmaBars` | **1.5** / **20** | ⛔ **NON SI TOCCANO, MAI, in nessun round di taratura.** È il punto in cui il candidato esterno, `REGISTRO_TEST.md` §MODIFICHE e il corso del 24/08 **concordano indipendentemente**. Girarli trasformerebbe una convergenza in una manopola |
| `InpRiskPercent` | **1.0** | default del porting (§ 2) |
| `InpVerbose` / `InpAutoTest` | **true** / **true** | **senza, non esiste il gate A0** |

---

## 7. ⚖️ L'EMENDAMENTO DELLA FINESTRA — e perché R109 è **diagnostico sul merito**

- **regola A** — l'unità di misura è l'**operazione**: R109 **conta** e non
  taglia (D3);
- **regola B** — **il vecchio giudica il RISCHIO, il recente il MERITO**: qui il
  "vecchio" **non esiste** (23 mesi, un regime solo). Perciò:
  🔴 **il MERITO è SOSPESO PER COSTRUZIONE, a qualunque `n`** — non perché il
  campione sia sottile, ma perché **la finestra contiene un solo mercato**, e un
  motore **controtendenza** misurato in un **toro** dice quanto costa opporsi a
  quel toro, non se l'idea funziona;
  🟢 **il RISCHIO si legge tutto e subito**: DD, peggior giornata, perdita
  mediana, concentrazione giornaliera. **Sono fatti accaduti**, e G4 vale
  sempre;
- **regola C** — la **prova di regime** batte la storia contigua: **R109 non la
  può fare**, perché **il broker non ha altro storico**, e lo dichiara. La
  strada aperta è la pipeline **Dukascopy `_EXT`** sugli indici, **oggi
  inesistente** (in costruzione in parallelo): 👉 **quando ci sarà, questo round
  va rifatto su una finestra che contenga almeno un orso**;
- **regola D** — il limite in basso: 23 mesi sono **poco**, ma sono **tutto
  quello che il broker ha**, ed è più dei 21 mesi su cui girano già 110 file
  prova su 153.

---

## 8. 📤 COSA PUÒ USCIRE DA R109 — e cosa no

**Può uscire:**
1. la risposta a *"questo EA compila?"* — 🔴 **oggi non lo sa nessuno**;
2. la risposta a *"il suo autotest a 7 blocchi passa?"*;
3. **il primo conteggio vero** delle operazioni di questo motore: `n`, per lato
   e per simbolo, e **quante volte il cap giornaliero morde**;
4. **il primo take misurato in punti indice** di questo motore, e quindi il
   verdetto S0a;
5. **la misura del rischio**: DD, **peggior giornata con la data**, perdita
   mediana ≈ R, durata in barre;
6. l'asimmetria **long vs short** su un motore controtendenza in un toro —
   che è **esattamente** la domanda della regola dei due lati.

**NON può uscire:**
1. **una sedia** (G5) e nessun forward;
2. nessun **giudizio out-of-sample** (D3) e nessuna **prova di regime** (§ 7);
3. niente su **M5** (§ 4.4) e niente sulle **ablazioni** (D1);
4. niente sulla cella **"entrambi i lati"** (§ 1.0);
5. nessuna promessa sul **live**: fill, slippage e spread variabile non stanno
   in nessun modello. E su questo motore lo slippage morde **più del solito**
   (§ 3.2);
6. nessun confronto col **TradingView dell'autore**: conteggi diversi per
   costruzione (cap giornaliero, media del volume, `STOPS_LEVEL`,
   simmetrizzazione dello short — tesi § 4).

---

## 9. ⚙️ ESECUZIONE

- **Driver**: `righe/RIGA_R109_ATREXH.ps1`, marcatore `MARCATORE_RIGA_R109_v1`.
- **`-SoloControllo`** (giro a vuoto): **non apre MT5**. Verifica gli
  **artefatti** — file prova, stella, porting, sorgente, valori, magic, `.ini` —
  **e COMPILA**. ⚠️ **Non misura NESSUN numero**: nessun `n`, nessun PF, nessun
  S0, **nessun autotest** (che richiede un'esecuzione). Sta scritto anche
  **dentro il suo referto**.
- **MT5 e MetaEditor chiusi**, o la riga si rifiuta di partire.
- **`[Experts] AllowLiveTrading=false`** in ogni `.ini`: aprire MT5 per misurare
  **riarma la flotta** sul conto vivo (checklist 51; successo il 14/08).
- **Una macchina, un lavoro**: R109 parte solo quando nessun altro round tocca
  il terminale.
- **Il round non scarica storico** e **non tocca `bases\<server>\ticks`**.
- **Durata [STIMA, non una previsione]**: **13 passate**, di cui **12 a tick
  reali** su ~23 mesi di M15 su indici. Il solo U30USD ha **67,6 milioni di
  tick** nella finestra: i tick reali sugli indici sono **il caso pesante**, non
  quello leggero. Ordine di grandezza atteso: **da 3 a 12 ore**. `-OreMax 14` è
  un tetto sull'**inizio** di nuovi lavori, non un'accetta su un lavoro in corso.
  Se il tempo fosse proibitivo c'è `-ScreenOhlcM15` (D8), che però **non produce
  nessun verdetto**.

---

## 10. ✍️ LE OTTO DECISIONI — **[DA FIRMARE]**

| | decisione | ✅ PROPOSTA | ❌ alternativa scartata, e perché |
|---|---|---|---|
| **D1** | **Griglia o default d'autore** alla prima uscita | **SOLO la cella AUTORE**, ai default del porting. Zero ablazioni, zero assi spazzolati | *far girare subito la griglia (prossimità, grilletto, SL, gestione)*: su un motore **mai compilato e mai misurato** una griglia è una **pesca**, e la cella "verde per caso" è quella che brucia la challenge (regola della SECONDA CACCIA) |
| **D2** | La **profondità dei TICK**: misurata su **U30USD** (20/08), **mancante** su D30EUR e NASUSD | **SI MISURA PRIMA** sui due che mancano, con lo strumento di casa già usato su U30USD. Costa una riga e mezz'ora | *girare e dichiarare*: a modello 4 senza tick reali MT5 **non si ferma**, ripiega e produce numeri **plausibili e falsi**, e **nessuna guardia del driver può accorgersene**. È la classe di difetto più cara del progetto |
| **D3** | **Divisione IS/OOS** della finestra | **NESSUNA.** R109 gira la **sola finestra intera** e **conta**; il taglio si dimensiona nel round dopo, **sui conteggi veri** | *tagliare 50/50 adesso*: l'Emendamento A dice che l'IS si dimensiona **sulle operazioni**, e le operazioni **non le conosciamo ancora**. Due finestre da ~120 op sarebbero due numeri che nessuno può usare — e che qualcuno userebbe lo stesso |
| **D4** | Lo **spread di riferimento** di S0a | **2,0 punti indice** su tutti e tre, **[SPREAD NON MISURATO]** stampato accanto a ogni verdetto. È il **lato alto** della forchetta 1-2 di `R98_CRITERI.md` = scelta **prudenziale** | *misurarlo prima col RealCost Spread P95 Logger* (Code Base 74148, promosso il 23/08 e **mai usato**): è la strada giusta ma è **un altro lavoro**. ⚠️ **Se il rapporto cade fra 2,5x e 3,5x il verdetto NON si dà**: si misura lo spread e si rilegge |
| **D5** | Cosa succede se **l'AUTOTEST non si legge** (log non trovato) | **Si prosegue, ma ogni numero esce marcato `NON CONVALIDATO`** e il round **non può uscire `OK`**. Se invece stampa **`DIVERGE`**: **si ferma TUTTO** | *dichiararlo superato perché "l'EA lo stampa sempre"*: è un **verde per assenza** (checklist 28-bis). *Fermare tutto anche quando manca solo il log*: butterebbe una corsa per una cartella di log che non abbiamo trovato |
| **D6** | Cosa succede se **S0a fallisce su UNA cella** | **Quella cella si chiude, le altre proseguono.** Un lato storto non porta via anche l'altro (stessa scelta di R100/R101/R107/R108) | *fermare tutto il round*: trasformerebbe **sei risposte in zero** |
| **D7** | Il **cap giornaliero** con i lati separati | **Resta 3 PER CELLA**, e il referto **dichiara** che la somma dei due lati **non è** la cella "entrambi" (§ 1.0), **e stampa quante giornate hanno toccato il cap** (la frequenza misurata è **censurata dall'alto**) | *metterlo a 0 (illimitato) per "vedere la frequenza vera"*: violerebbe il criterio **C6** del dossier (*ogni promosso deve avere un cap fra i suoi input*) e misurerebbe un EA che non useremmo mai. *Metterlo a 1-2 per lato*: sarebbe una nostra taratura dentro il round che deve misurare il porting nudo |
| **D8** | **Modello** | **4 (TICK REALI)** per il giudizio. `-ScreenOhlcM15` esiste, ma **se acceso ogni riga esce `NON GIUDICABILE`**, la cartella si chiama `SCREENOHLC` e l'uscita **non è 0** | *screening OHLC per risparmiare ore*: su M5/M15 l'OHLC inganna, **ed è MISURATO in casa** (`REGISTRO_TEST.md` §2: +129k finti sul DAX). E qui morde **più del solito**: l'ingresso nasce da un **estremo di barra** e lo stop sta **a un tick dal minimo** → stop e target dello stesso trade sarebbero decisi da un'**ipotesi** sull'ordine di visita dentro la barra |

### 10.1 🟢 Cosa **non** serve firmare, e perché

- **i sei file prova**: sono **generati dai default del sorgente**, e il **gate
  del porting** lo verifica a ogni corsa. Le sole righe toccate sono elencate
  nella testa di ognuno;
- **la regola dei due lati**: è **regola di casa** (CLAUDE.md, 25/08), non una
  scelta di round;
- **G5** (nessuna promozione): idem;
- **la soglia del volume** (`1.5` × media `20`): non è una scelta di round, è
  una **convergenza fra tre fonti indipendenti** (§ 6).

---

## 11. 🚫 QUELLO CHE R109 **NON** FARÀ, dichiarato prima

1. **Non tocca `ABTG_AtrExhaustVol.mq5`.** Il driver lo **copia e lo compila**,
   non lo modifica. Se non compila, **rimette il `.mq5` com'era** e si ferma.
2. **Non tocca nessuna sedia in forward.** Magic **vergini** `7744xx`; i magic
   vivi, quelli dei round recenti e **il default `774401`** sono **vietati e
   controllati nel codice**.
3. **Non promuove e non boccia niente** (G5).
4. **Non applica G2 e G3**: il merito è sospeso per costruzione (§ 7).
5. **Non misura lo spread**, non misura la profondità dei tick, non misura i
   sotto-periodi, non fa la prova di regime, **non scarica storico**.
6. **Non gira su dati Dukascopy `_EXT`**: sugli **indici non esistono ancora**
   (pipeline in costruzione in parallelo). **R109 gira SOLO su BCM**, e ogni suo
   numero è **di un broker solo, con i costi di un broker solo**.
7. **Non mescola un OHLC e un tick reale nella stessa tabella** (D8, checklist
   67: è un `if`, non una frase).

---

_Criteri scritti il 25/08/2026, **prima** di qualunque numero. I criteri si
cambiano **prima** dei numeri, mai dopo._
