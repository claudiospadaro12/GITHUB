# ⚖️ R87 — CRITERI CONGELATI **PRIMA** DEI NUMERI — 📝 **FIRMATI**

> ## ✍️ FIRMA DI CLAUDIO: ______________________  data: ____/____/2026, ore ____
>
> **Finché questa riga è vuota, i CSV di R87 NON SI APRONO.** Sono nella
> cartella sigillata sul Desktop col suo `LEGGIMI_PRIMA`. *I criteri si
> cambiano PRIMA dei numeri, non dopo*: se un numero uscito suggerisse un
> criterio migliore, quel criterio vale **dal round dopo**.

> ### 🔒 DICHIARAZIONE DI CIECO — obbligatoria, e vera
> Scritto il **19/08/2026, in tarda serata (ore ~23:20 italiane = ~22:20 ora
> server BCM)**, mentre le passate di R87 giravano o erano in coda. **Chi
> scrive NON ha visto un solo numero di R87.** Le cifre presenti qui vengono
> tutte da round già refertati (R2, R20, R84, R55, METRO_PROP) o da **letture
> di sorgente e di `git`** fatte stanotte e citate riga per riga.

_Nota di collocazione: i TODO nei file prova rimandano a `prove\R87_CRITERI.md`.
**Il file è QUESTO**, in `risultati_archivio/` accanto a `R88_CRITERI.md`._

---

## 0. 🧭 PERCHÉ ESISTE QUESTO ROUND, E PERCHÉ È DIVERSO DAGLI ALTRI

Il 19/08 la verifica di fedeltà contro il PDF Masterclass
(`caccia_strategie/biblioteca/schede/VERIFICA_FEDELTA_GOLDENCROSS_PDF_2026-08-19.md`)
ha misurato **FEDELE 36/78** e ha nominato **tre DIFETTI meccanici** — non tre
opzioni, tre bug:

| fix | difetto misurato nel codice v1.00 | riga citata nell'audit |
|---|---|---|
| **FIX 1** | la finestra dell'incrocio guardava **UNA barra sola**: *"EMA9 sopra ORA e sotto ESATTAMENTE `InpCrossLookback` barre fa"*. Sbagliato nei due sensi: passavano incroci vecchi di 8 barre (32 ore su H4) e **si perdeva un incrocio fresco di 3 barre** se 8 barre fa la EMA9 era già sopra | righe 363-364, audit §1.4 ① |
| **FIX 2** | mancava **"Prezzo > EMA9"** (fase 3 del PDF), e il filtro di distanza era **sempre vero quando il prezzo stava SOTTO la EMA9** (differenza negativa ≤ 1,5·ATR). Risultato: **l'EA apriva long con la chiusura sotto la EMA9** | righe 362, 366, audit §1.4 ② |
| **FIX 3** | i parziali in profitto **azzeravano il contatore delle perdite consecutive**: la regola del cap.14 *"stop dopo 2 perdite"* c'era nel codice ma **non scattava quasi mai** | righe 663-667, audit §1.4 ④ |

E due interruttori **nuovi, opt-in, default SPENTO**: `InpMaxDistEma21ATR`
(la regola del "tardivo" del cap.9) e `InpRequireAdxRising`.

> 🎯 **R87 è quindi l'unico round di stanotte che parla di SEDIE VIVE.**
> Quattro sedie girano su questo motore in questo momento:
> **XAUUSD H1 (970301, `_Ottimizzato`)** e **USDCHF/USDCAD/NZDUSD H4
> (770331/770332/770333, motore base)** — `FLOTTA_ATTIVA.md` righe 27, 32-34.
> **La v2.00 è già sulla punta di `lavoro`**: la correzione è già nel motore
> che verrà compilato al prossimo giro. R87 misura **cosa è cambiato**, non
> decide se cambiare.

### 0-bis. ⚠️ La tensione che va scritta, non nascosta

`REFERTO_ROUND20_GOLDENCROSS_FOREX.md` (10/08) **ha chiuso il capitolo
GoldenCross**: 0 celle su 6 sul forex, 0 su 3 sugli indici (R4), near-miss su
XAUUSD H1 (R2: OOS +308, PF 1,25). Testuale: *"Il pattern non ha superato
l'imbuto su nessun mercato. Si archivia senza rimpianti."*

**Eppure quattro sedie girano.** R87 è la prima misura che può o **riaprire**
quel capitolo (se la meccanica corretta cambia il verdetto) o **chiuderlo
definitivamente** (se non lo cambia). Va detto adesso, non a numeri visti.

---

## 1. 🎯 LE DUE DOMANDE — sono due, e non si mescolano

| cella | file prova | LA DOMANDA | cosa può produrre |
|---|---|---|---|
| **R87a** 🔬 | `R87a_impatto_fix_{XAUUSD,USDCHF,USDCAD,NZDUSD}.txt` | **QUANTO CAMBIANO i tre fix meccanici**, sulla configurazione IN CAMPO delle sedie vive, a parità assoluta di tutto il resto? | **una MISURA DI DIFFERENZA.** Qui **non si promuove e non si sceglie niente**: si quantifica uno scarto. |
| **R87b** 🕸️ | `R87b_griglia_{XAUUSD,USDCHF,USDCAD,NZDUSD}.txt` | Adesso che la meccanica è quella del PDF, **ESISTE un altopiano** nei parametri? (6 assi, 144 passate per finestra per simbolo) | **una risposta SÌ/NO sull'esistenza di un altopiano.** La **scelta della cella è SOSPESA** (§2.2): la griglia serve a vedere SE c'è una regione, non a scegliere il preset. |

### 1-bis. 🔢 Il conto delle passate

| | passate/finestra/simbolo | finestre | simboli | **totale a tick reali** |
|---|---:|---:|---:|---:|
| **R87a** (2 magic gemelli) | 2 | 2 | 4 | **16** |
| **R87b** (3×2×2×3×2×2 = 144) | 144 | 2 | 4 | **1.152** |
| **R87a-V1** (il "prima", §3) | 2 | 2 | 4 | **+16** |
| | | | | **1.184** |

---

## 2. 🪟 LE FINESTRE E IL CANARINO — Emendamento, regola A

### 2.0 🚧 PASSO 0 — prima di tutto

`@DAQUANDO` nei file prova è **PRUDENTE, non misurato**:
- **XAUUSD H1**: `2024.09.26` — **la profondità TICK di XAUUSD non è MAI stata
  misurata** (l'unica riga `TICK` del repo è GBPUSD, probe del 15/08).
- **USDCHF / USDCAD / NZDUSD H4**: `2024.07.05` — è la data **misurata su
  GBPUSD**, estesa per analogia agli altri cambi: **[INFERITO, non misurato]**.

> 🔴 Se i tick partono **dopo** quelle date → **i numeri non si leggono**, la
> finestra si riscrive e il round si rilancia (difetto n.18 della checklist).
> Se i tick **non ci sono**, si gira a **modello 1 (OHLC M1)** e ogni numero
> porta scritto accanto **"OHLC, non tick"**.

### 2.1 Le finestre dichiarate (provvisorie fino al PASSO 0)

| simbolo | TF | dal | al | IS (split 40/60) | OOS |
|---|---|---|---|---|---|
| **XAUUSD** | H1 | 2024.09.26 | 2026.06.30 | **2024.09.26 → 2025.06.09** | **2025.06.10 → 2026.06.30** |
| **USDCHF/USDCAD/NZDUSD** | H4 | 2024.07.05 | 2026.06.30 | **2024.07.05 → 2025.04.21** *(calcolo: 40% di 725 giorni = 290)* | **2025.04.22 → 2026.06.30** |

⚠️ Le date IS/OOS del forex sono **[CALCOLO]**, non lette: vanno **verificate
sulle anteprime `.ini` del PASSO 2** e sulla prima/ultima riga del per-trade,
come è stato fatto in R84. Se il driver spezza diversamente, **vale il driver**
e la tabella si corregge nel referto.

Rischio pinnato **1,00%** in tutte le celle: non è una taglia di campo, è un
valore comune che rende confrontabili le celle fra loro. Deposito e modello
come da driver.

### 2.2 🐤 IL CANARINO — e qui **morde davvero**

L'Emendamento chiede **≥150 operazioni IS**. Le stime dichiarate nei file prova:

| simbolo | TF | stima operazioni IS | verdetto |
|---|---|---|---|
| **USDCHF / USDCAD / NZDUSD** | **H4** | **15-40** *(motore vestito di filtri, `InpMaxTradesPerDay=2`, H4)* | 🔴 **MOLTISSIMO sotto 150** |
| **XAUUSD** | **H1** | **40-120** | 🟠 **in bilico, comunque sotto 150** |

> ### 🔴 CONSEGUENZE, ACCETTATE IN ANTICIPO
>
> 1. **La selezione di cella per il MERITO è SOSPESA in tutto R87**, su tutti e
>    quattro i simboli. **Da R87b non può uscire un preset**, qualunque numero
>    faccia. Regola A dell'Emendamento + valvola R59.
> 2. **Il RISCHIO si legge sempre** (regola B: *un drawdown è un fatto
>    accaduto, non una stima*), e a qualunque `n`. I cancelli §5.3 sono
>    pienamente applicabili.
> 3. **R87a NON è una selezione**: è un confronto A/B fra due versioni dello
>    stesso motore. La soglia dei 150 esiste per impedire di **pescare una
>    cella** da una superficie frastagliata — qui non si pesca niente. Ma una
>    differenza ha comunque bisogno di un minimo di campione per essere
>    **quantificata**: vedi il cancello di leggibilità §5.1.
> 4. **Con 15-40 operazioni IS, la parola "PF" sul forex H4 vale poco.**
>    Il referto deve scrivere `n` accanto a ogni PF e, sotto 30 operazioni in
>    una finestra, **deve scrivere anche l'elenco dei trade**: a quel campione
>    l'ispezione vale più della statistica.

### 2.3 Il REGIME contenuto — accanto a OGNI numero

Un solo regime (2024-2026). Niente 2020, niente 2022, niente 2013.
**R87 misura l'effetto di una CORREZIONE dentro un regime, non la robustezza.**
La prova di regime (toro/orso/laterale/crollo) è la regola C dell'Emendamento
ed è un altro round.

---

## 3. 🧩 IL "PRIMA" — la decisione che il file prova lasciava all'architetto

Il file prova R87a dichiara la trappola: `walkforward_generico.ps1` ha
`$EABranch="lavoro"` **scritto fisso** e prende sempre la **punta** del branch.
**La v2.00 è già su `lavoro`**, quindi da quella riga di lancio esce solo il
"dopo". Le due strade erano: (1) girare prima del merge — **finestra passata**;
(2) pubblicare una copia congelata della v1.00 come EA a sé stante.

### 3.1 ✅ DECISIONE PROPOSTA: **strada (2)**, ed è già per tre quarti fatta

`mql5/Experts/ABTG_GoldenCross_V1.mq5` **esiste già** sul branch: v1.00
congelata, 67 input, magic di default 770301.

**Verificato stanotte con `git show 8ad73f2` + `diff` (letto io, non assunto):**

> **`ABTG_GoldenCross_Ottimizzato` v1.00 era il motore base v1.00 MENO due
> gambe opzionali** (`InpUseBBExpand` + le bande di Bollinger, e
> `InpHAAutoCount`/`HACountEffettivo()`), più la stringa di nome passata al
> Guardian. **Nient'altro di logico differisce.**

👉 **Conseguenza operativa, e va scritta nel referto:** con
`InpUseBBExpand=0` e `InpHAAutoCount=0` **pinnati**, `ABTG_GoldenCross_V1` è
**funzionalmente identico** anche alla `_Ottimizzato` v1.00. **Quindi il
"prima" di tutti e quattro i simboli, XAUUSD compreso, si misura su
`ABTG_GoldenCross_V1`** — non serve congelare un secondo EA.

### 3.2 🛠️ COSA SERVE PER AVERE IL "PRIMA" (quattro file prova gemelli)

Quattro nuovi file `R87a_impatto_fix_<SIMBOLO>_V1.txt`, **copia esatta** dei
quattro esistenti con **tre sole differenze**, e il `diff` va fatto prima di
lanciare:

1. ➖ **si tolgono** `InpMaxDistEma21ATR` e `InpRequireAdxRising` — **non
   esistono nella v1.00**. (Lasciarli a 0 sarebbe innocuo nel merito, ma
   produce due parametri sconosciuti nell'`.ini`: **va VERIFICATO come li
   tratta il tester** — se li ignora silenziosamente o se scrive un warning nel
   Giornale. Non si assume: si guarda.)
2. ➕ **si aggiungono** `InpUseBBExpand=0` e `InpHAAutoCount=0` **dove non ci
   sono già** (i tre file forex li hanno già pinnati; **il file XAUUSD NO**:
   lì vanno aggiunti, altrimenti prendono il default del sorgente — che è
   `false` per entrambi, **verificato alle righe 66 e 71 di
   `ABTG_GoldenCross_V1.mq5`**, ma un valore verificato scritto vale più di un
   default sottinteso).
3. 🔢 **magic vergini diversi**: proposta **778750/778751 (XAUUSD)**,
   **778760/61 (USDCHF)**, **778770/71 (USDCAD)**, **778780/81 (NZDUSD)** —
   fuori dalla serie 7787{1,2,3,4}x già usata da R87a/R87b. *(Lezione R54: un
   magic già visto può far incrociare al tester deal che non c'entrano.)*
4. ▶️ si lancia con `-Expert ABTG_GoldenCross_V1`.

> ⛔ **SE IL "PRIMA" NON VIENE GIRATO**, va scritto in testa al referto con
> queste parole: **"R87a è la fotografia del DOPO. Onesta, ma non un
> confronto."** E i cancelli §5.2 **non si applicano**: nessuna frase del tipo
> *"i fix hanno migliorato/peggiorato"* può essere scritta. Sarebbe un
> confronto contro un numero che non esiste.

---

## 4. 🎚️ LA REGOLA DI SELEZIONE — centro dell'altopiano, MAI il picco

Non trattabile, e va **dichiarata insieme al numero** (in R70 il confronto si è
ribaltato quando è stato rifatto con la regola giusta). Per R87b, che è una
griglia a **6 assi**, la si rende operativa:

1. Si guarda la **superficie**, non la riga migliore.
2. **Definizione di VICINO**: una cella ottenuta muovendo **un solo asse di un
   solo passo** (fino a 6-12 vicine, a seconda di dove sta la cella nella
   griglia).
3. Una cella si può nominare come **centro di altopiano** solo se **TUTTE** le
   sue vicine dirette restano dentro **20% di PF** e **1,5 punti percentuali di
   DD** da lei. Soglia identica a `R88_CRITERI.md` §3 — non inventata stanotte.
4. Una cella che sporge da sola è **rumore**: a referto va scritta come
   **"picco isolato, non proposto"**, anche se è la più bella della tabella.
5. **`n` IS e `n` OOS accanto a OGNI numero.** Un numero senza `n` non entra.
6. Etichetta **[MISURATO] / [INFERITO] / [DICHIARATO]** su ogni riga.

---

## 5. 🚪 I CANCELLI DI LETTURA — le soglie NUMERICHE, congelate

### 5.0 🧪 Sanità, prima di tutto

1. **Gemelli identici** (R87a e R87a-V1): 8 coppie in tutto. Una che diverge →
   **il round si ferma** (checklist punto 5).
2. **R87b non ha gemelli** (magic pinnato: raddoppierebbe a 288 passate/finestra).
   Il controllo gemello lo fa R87a — **e va dichiarato che R87b ne è privo**.
3. **`-SoloControllo` deve stampare 144 celle** per ogni file R87b. Se ne
   stampa un altro numero, la griglia non è quella che credevamo: ci si ferma.
4. **Il commit sulla punta di `lavoro` all'ora della corsa va dichiarato.**
   Il driver ignora il `-Rif`: gira l'EA di `lavoro` ADESSO. Se il BLOCCO 4
   del collaudo Guardian non era chiuso, un numero strano non si sa se è del
   motore corretto o della migrazione. *(Nota: BLOCCO 4 risulta chiuso VERDE la
   sera del 19/08, commit `8907a8f` — **da confrontare con l'ora di raccolta
   dei CSV**.)*

### 5.1 📐 CANCELLO DI LEGGIBILITÀ — quando una differenza si può quantificare

| campione (IS+OOS, per simbolo) | cosa si può scrivere |
|---|---|
| **n ≥ 30** | lettura **quantitativa**: Δn, ΔPF, ΔDD, sovrapposizione dei trade |
| **10 ≤ n < 30** | **solo ISPEZIONE**: si elencano i trade comparsi, spariti e cambiati, uno per uno. **Nessun PF, nessuna percentuale.** A questo campione la statistica mente e l'elenco no. |
| **n < 10** | **"non misurabile"**, e si scrive il conteggio. Punto. |

Soglia dei 30 identica a `R84_ABLAZIONE_CRITERI.md` §3.3 (valvola R59).

**Il POOL dei quattro simboli** (somma) si può scrivere **solo con etichetta
[INFERITO]** e **sempre accanto** ai quattro numeri per simbolo. Mai al posto
loro: la lezione PTE (GBPUSD sì, USDJPY no) vale anche qui.

### 5.2 🔬 R87a — COSA SIGNIFICA "I FIX HANNO CAMBIATO", in numeri

Tre metriche, in quest'ordine. **La prima è la più importante** e non è il P&L.

#### ① QUANTO l'insieme dei trade è cambiato (la metrica principale)

Il file prova lo dice: *"i fix toccano QUALI trade si prendono, non solo
quanti; se cambia SOLO il numero e non l'insieme, è un caso"*. Quindi si
misura la **SOVRAPPOSIZIONE** fra i due insiemi di trade, dai CSV per-trade,
sulla chiave **(data-ora d'ingresso, direzione)**:

```
sovrapposizione =  | trade in COMUNE fra V1 e v2.00 |
                   ------------------------------------
                   | unione dei trade di V1 e v2.00 |
```

| sovrapposizione | Δn | **verdetto congelato** |
|---|---|---|
| **≥ 90%** | e \|Δn\| ≤ 10% | 🟢 **CAMBIAMENTO COSMETICO** — i fix erano corretti ma l'impatto operativo è sotto il rumore. Il contratto della sedia **non si tocca**, la storia forward **non si azzera**. |
| **70-90%** | qualunque | 🟠 **CAMBIAMENTO MISURABILE, NON STRUTTURALE** — si aggiorna la **frequenza promessa** nel contratto della sedia; il resto resta. |
| **< 70%** | oppure \|Δn\| > 25% | 🔴 **È UN'ALTRA SEDIA.** Conseguenza congelata: il **contratto della sedia va RISCRITTO** (`report/CONTRATTI_SEDIE.md`: DD e frequenza promessi) e **la storia forward della sedia riparte da zero** per il criterio di uscita del 18/08 — perché quel criterio confronta il forward col **backtest della cella promossa**, e la cella promossa non è più questa. |

⚠️ **[DA VERIFICARE PRIMA DI CALCOLARLO]**: che i CSV per-trade escano per
**tutte** le passate di R87a e non solo per l'OOS. In R84 uscivano i per-trade
**OOS**. Se manca l'IS, la sovrapposizione si calcola **solo in OOS** e va
detto.

#### ② SE i fix hanno MIGLIORATO o PEGGIORATO

Solo se il cancello di leggibilità §5.1 lo consente (n ≥ 30):

- ✅ **"I FIX HANNO MIGLIORATO"** se, **per lo stesso simbolo**:
  **PF(v2.00) ≥ PF(V1) + 0,10 in ENTRAMBE le finestre** (o in una, con
  pareggio entro ±0,05 nell'altra) **E** DD non peggiore di **1,0 punto
  percentuale** in nessuna delle due.
- ❌ **"I FIX HANNO PEGGIORATO"** se: **PF(v2.00) ≤ PF(V1) − 0,10 in almeno una
  finestra**, **oppure** DD peggiore di più di **1,0 pp** in almeno una,
  **oppure** il campione crolla sotto il cancello di leggibilità.
- ⚪ **PAREGGIO** in tutti gli altri casi: si scrive *"nessuna differenza
  misurabile sul conto economico"* — che, unito a una sovrapposizione bassa,
  è **un risultato interessante** e va commentato (stessi soldi, altri trade).

Il **±0,10 di PF** è il margine di rumore già congelato in
`R84_ABLAZIONE_CRITERI.md` §5 punto 3. Non è nuovo e non è tarato su R87.

#### ③ 🔴 IL PUNTO DELICATO — **I FIX RESTANO COMUNQUE.** Leggerlo due volte.

> ## **Un bug non si tiene perché era fortunato.**

Questa clausola è congelata **prima** dei numeri proprio perché è quella che si
sarebbe più tentati di riscrivere dopo. Per intero:

1. **FIX 1 e FIX 2 correggono DIFETTI, non scelte.** Il codice non faceva ciò
   che il documento su cui è costruito prescrive: il FIX 2 permetteva di
   **aprire long con la chiusura sotto la EMA9**, cioè un setup che il PDF
   mette **fuori** dalla fase 3. Il FIX 1 **perdeva incroci freschi**. Non sono
   parametri: sono errori di implementazione, misurati e citati per riga.
2. **Se la v2.00 PEGGIORA, la lettura corretta NON è "rimettiamo il bug".** È:
   **"il motore guadagnava per una ragione DIVERSA da quella dichiarata"** — e
   quella è una **TESI NUOVA**, che va scritta, misurata e difesa come tesi
   (per esempio: *"su questo mercato paga l'ingresso in ritardo sull'incrocio
   vecchio"*), non un permesso di tornare indietro. Tornare alla v1.00 perché i
   numeri erano più belli è **curve fitting retroattivo su un difetto**: si
   sceglierebbe un bug guardando il suo P&L su un regime e mezzo e 15-40
   operazioni IS. È esattamente il modo in cui si brucia una challenge.
3. **FIX 3 è un fix di RISCHIO, e ha uno statuto a parte.** Rimette in funzione
   lo *stop dopo 2 perdite consecutive* del cap.14 — una regola di protezione,
   non di rendimento. **Se costa profitto, quel costo È IL PREZZO DELLA
   REGOLA**, non un argomento contro di essa. Il muro prop è al **10%**
   (`report/METRO_PROP.md`), e una regola che riduce le giornate nere si paga
   in rendimento **per definizione**. Il FIX 3 **non è negoziabile sul P&L**:
   si può discutere il suo *parametro* (`InpStopAfterLosses`), mai la sua
   correttezza.
4. **L'unica reazione ammessa a un peggioramento è sul RISCHIO, e non è il
   rollback.** Se la v2.00 sfonda i cancelli §5.3, la proposta a Claudio è
   **spegnere la sedia** (o proporne la revisione secondo il criterio del
   18/08), **non rimettere la v1.00**. Spegnere un motore e rimettere un bug
   sono due cose diverse: la prima è prudenza, la seconda è superstizione.
5. **Corollario da scrivere nel referto**: *"i fix restano in tutti e tre gli
   scenari (migliora / pareggia / peggiora). Cambia solo COSA si fa della
   SEDIA, mai COSA si fa del CODICE."*

### 5.3 🔴 CANCELLO DEL RISCHIO — assoluto, a qualunque `n`, su A e su B

Non si sospende mai (regola B dell'Emendamento). Vale per **ogni** cella di
R87a e di R87b:

| # | soglia | da dove esce il numero |
|---|---|---|
| **R1** | **DD (IS o OOS) > 15,0%** → cella bocciata **per rischio**, qualunque sia il PF | Muro prop **10% di DD totale** (`METRO_PROP.md` §1-bis), passate a **1,00%** di rischio contro taglia di campo **0,65%**: 10% ÷ 1,538 = **15,4%**, arrotondato in basso. ⚠️ **[INFERITO per scalatura lineare, NON misurato]** — il DD non scala esattamente col lotto: serve un R55-bis su qualunque cella eventualmente proposta. |
| **R2** | **Peggior Giornata % peggiore di −7,5%** → bocciata **per rischio** | Muro prop giornaliero **5%**, stessa scalatura: 5% ÷ 1,538 = 7,7% → **7,5%**. Stesso [INFERITO]. |
| **R3** | **La v2.00 sfonda R1 o R2 dove la V1 non li sfondava** | 🔴 **allarme sulla sedia viva**: è l'unico esito di R87 che richiede una decisione **rapida** di Claudio. Proposta: revisione della sedia secondo il criterio del 18/08 (corsia RISCHIO), **non** rollback (§5.2 ③ punto 4). |

### 5.4 🕸️ R87b — COSA SIGNIFICA "C'È UN ALTOPIANO"

Il verdetto di R87b è **uno di questi tre, e nessuno promuove**:

| verdetto | condizione numerica | cosa ne segue |
|---|---|---|
| 🟢 **ALTOPIANO ESISTE** | esiste almeno una cella **centro** (§4 punto 3: tutte le vicine dentro 20% di PF e 1,5 pp di DD) con **PF OOS ≥ 1,10** e **PF IS > 1,00** e `n` sopra il cancello di leggibilità | si scrive *"esiste una regione candidata; **campione insufficiente per sceglierla**"*. Serve un round su **dati lunghi** (broker esterno / serie `_EXT`, quando passeranno il loro cancello) prima di qualunque proposta. **Nessun preset esce da qui.** |
| 🟠 **SOLO PICCHI ISOLATE** | le celle sopra PF 1,10 non hanno vicine che le accompagnano | si scrive *"picchi isolati, non proposti"*. E il verdetto operativo è: **la meccanica corretta non riapre il capitolo chiuso da R20.** |
| 🔴 **SUPERFICIE TUTTA SOTTO** | nessuna cella con PF OOS ≥ 1,10 | **R20 è confermato dopo la correzione**: il GoldenCross non aveva un problema di implementazione, aveva un problema di edge. |

**PF 1,10** è il cancello storico di casa (R15, citato in `R88_CRITERI.md`
§4.1). Non si abbassa e non si alza per questo round.

> ⚠️ **Cosa R87b NON può fare, per costruzione:** con 144 celle e `n` IS
> stimato 15-40 sul forex, **una cella "verde" è attesa per puro caso**.
> Con 144 estrazioni, trovare qualche PF alto non è una notizia: è aritmetica.
> **Per questo il criterio è l'ALTOPIANO, non il valore.** Chi legge R87b
> cercando "la cella migliore" sta leggendo il round sbagliato.

---

## 6. 🛑 IL VINCOLO — R87 PROPONE, CLAUDIO DECIDE

1. **NESSUN DEPLOY AUTOMATICO.** Da R87 non esce nessun `.set`, nessun cambio
   di input su una sedia viva, nessun EA riattaccato a un grafico.
2. **Le quattro sedie GoldenCross NON si toccano mentre R87 gira.** Nessun
   parametro, nessun magic, nessun timeframe.
3. **R87 non può spegnere una sedia per il MERITO.** Il criterio di uscita del
   18/08 misura il **FORWARD** (famiglia a 20+ operazioni in perdita), non un
   backtest. Il massimo che R87 può dire sul merito è: **"il backtest non dà
   una ragione NUOVA per tenerle"** — che è un'informazione per Claudio, non
   una decisione. Sul **RISCHIO** invece R87 parla eccome: vedi R3 in §5.3.
4. **Un solo cambio alla volta.** Se R87b indicasse una regione e Claudio
   volesse muoversi, si muove **un asse per volta**, mai il pacchetto.
5. Prima di qualunque campo, se una proposta esce e viene firmata: (a) prova di
   regime; (b) R55-bis su slippage/spread; (c) contratto della sedia
   aggiornato; (d) **forward demo**, mai live da un backtest.
6. **`InpAutoTest` non esiste in questo EA** (verificato: non è una
   dimenticanza del file prova, nel sorgente non c'è). Se R87 producesse una
   proposta, **l'autotest va aggiunto all'EA prima del forward** — è un debito
   dichiarato, non un dettaglio.

---

## 7. 🕳️ COSA R87 **NON** PUÒ MISURARE — dichiarato prima

| ❌ non misurabile in R87 | perché | dove va |
|---|---|---|
| **Quale dei TRE FIX ha spostato cosa** | i tre fix sono **entrati insieme** nella v2.00 e non hanno un interruttore per spegnerli uno alla volta. R87a misura il **pacchetto**. | round di ablazione dei fix, **solo se** serve: richiede tre interruttori nel codice |
| **Le 25 regole ASSENTI dell'audit** (livelli S/R, classificazione A/B/C, fasce orarie, target tecnici) | **l'EA non possiede il concetto di livello**: 0 su 5 sul blocco S/R, 0 su 3 sulla classificazione A/B/C | altra strategia, altro EA |
| **Il resto del money management del cap.14** (3 fedeli su 9) | R87 corregge **un** pezzo (FIX 3), non il blocco | coda |
| **La robustezza di regime** | un regime solo nella finestra | regola C dell'Emendamento |
| **La SCELTA di un preset** | `n` IS 15-40 (forex) e 40-120 (oro), tutti sotto 150 | round su dati lunghi (`_EXT`) |
| **Il filtro NEWS** | spento in tutte le celle: serve un CSV in `MQL5\Files` e la sua copertura sulla finestra non è misurata (stesso motivo per cui R84 lo escluse) | R84-bis / coda |
| **Lo SLIPPAGE e lo SPREAD** | `InpMaxSpread=0` | R55-bis, se esce una proposta |
| **Il GUARDIAN** | acceso come in campo ma **INERTE nel tester**: fail-open totale | collaudo Guardian |
| **La chiusura del venerdì** | `InpFridayClose=0`, come in campo | — |
| **Il confronto col forward vero delle 4 sedie** | R87 è backtest; i contratti delle sedie (DD e frequenza **promessi**) sono il metro del forward | `report/CONTRATTI_SEDIE.md` + criterio 18/08 |

---

## 8. 📋 CHECKLIST DEL REFERTO DI R87

- [ ] **PASSO 0** dichiarato per tutti e quattro i simboli (tick sì/no/OHLC).
- [ ] Il **commit sulla punta di `lavoro` all'ora della corsa**, dichiarato.
- [ ] **Il "prima" c'è o non c'è** (§3): se non c'è, la frase *"fotografia del
      DOPO, non un confronto"* va **in testa**, non in fondo.
- [ ] Date **IS/OOS verificate** sulle anteprime `.ini`, non calcolate (§2.1).
- [ ] **Gemelli identici** 8 coppie su 8 (R87a + R87a-V1); **R87b è senza
      gemelli**, dichiarato.
- [ ] `-SoloControllo` = **144 celle** per file R87b, dichiarato.
- [ ] **n IS e n OOS accanto a OGNI numero.** Sotto 30: elenco dei trade, non
      percentuali (§5.1).
- [ ] **Sovrapposizione dei trade** calcolata e dichiarata (§5.2 ①), con la
      finestra su cui è stata calcolata.
- [ ] La **clausola dei fix** (§5.2 ③) **ripetuta per esteso nel referto**,
      qualunque sia l'esito.
- [ ] Il **regime** dichiarato accanto a ogni tabella.
- [ ] Il **canarino** (§2.2) ripetuto: merito sospeso, nessun preset.
- [ ] La **regola di selezione** dichiarata insieme a ogni cella nominata.
- [ ] Etichette **[MISURATO] / [INFERITO] / [DICHIARATO]** su ogni riga.
- [ ] Le **ipotesi falsificate** dette per prime.

---

## 9. 📎 TRACCIABILITÀ

- **File prova**: `prove/R87a_impatto_fix_{XAUUSD,USDCHF,USDCAD,NZDUSD}.txt` ·
  `prove/R87b_griglia_{...}.txt` · *(da creare, §3.2)* `R87a_impatto_fix_*_V1.txt`
- **Sorgenti**: `mql5/Experts/ABTG_GoldenCross.mq5` **v2.00** ·
  `ABTG_GoldenCross_Ottimizzato.mq5` **v2.00** ·
  `ABTG_GoldenCross_V1.mq5` **v1.00 congelata**
- **Il "prima" in git**: commit **`8ad73f2`** (ultimo di `lavoro` con la v1.00;
  il `.mq5` non cambiava da **`5fc0bc3`**)
- **Audit di fedeltà**: `caccia_strategie/biblioteca/schede/VERIFICA_FEDELTA_GOLDENCROSS_PDF_2026-08-19.md`
  (36/78; le cinque divergenze principali; §1.4 ①②③④⑤)
- **Precedenti citati**: `REFERTO_ROUND20_GOLDENCROSS_FOREX.md` (0/6 forex,
  capitolo chiuso, lezione USDJPY, soglia ADX inerte) · R2 (XAUUSD near-miss,
  OOS +308 PF 1,25) · `REFERTO_ROUND84_ABLAZIONE.md` (margine di rumore ±0,10)
  · `report/METRO_PROP.md` (muri 10% / 5%) · `report/FIRME_2026-08-18.md`
  (criterio di uscita delle sedie)
- **Flotta**: `FLOTTA_ATTIVA.md` righe 27, 32-34 (le quattro sedie vive)
- **Regole di casa**: EMENDAMENTO DELLA FINESTRA (A/B/C/D) · valvola R59 ·
  criterio di uscita delle sedie del 18/08 · CHECKLIST_RIGA_DI_LANCIO punti 5,
  13, 14, 18, 19
