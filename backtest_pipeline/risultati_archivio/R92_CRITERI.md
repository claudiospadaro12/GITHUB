# ⚖️ R92-SCAN — CRITERI **FIRMATI** DA CLAUDIO IL 21/08/2026, PRIMA DEI NUMERI

> ## ✍️ FIRMATO: **"c,firmo 0,8,misura entrambe"** — 21/08/2026.
> La firma integrale, con le clausole, sta **in fondo a questo file** (sezione
> "FIRMA DI CLAUDIO"): quella e' l'originale, questo corpo e' solo allineato.
> Regola di casa, non trattabile: *i criteri si cambiano prima dei numeri, non
> dopo.* Se un numero uscito suggerisse un criterio migliore, quel criterio
> vale **dal round dopo**.
>
> _Scritto e firmato il 21/08/2026, a numeri di R92 **mai visti**: nessuna
> passata girata, l'EA `ABTG_Bulge.mq5` non e' mai stato compilato da nessuno._
>
> **Le tre soglie S1/S2/S3 (par. 3) NON sono state toccate dalla firma e non si
> toccano.** Il corpo e' stato allineato il 21/08 **solo** su: rischio
> 0,80% (era 1,00), disegno del round 88 passate (era 44), canarino 2.2.
> Ogni riga cambiata e' elencata nel commit che l'ha cambiata.

**Banco:** `ABTG_Bulge` **v5.10** (motore di **Claudio**, migrato agli standard
di casa — `mql5\Experts\ABTG_Bulge.mq5`) · H1 · **22 cross del basket** ·
**4 celle per simbolo = 88 passate** (2 gestioni × 2 varianti del VIOLA) ·
rischio **0,80%** · file prova `prove\R92_scan_BULGE.txt` · driver
`scan_market.ps1 -Robot ABTG_Bulge`.

**Le 4 celle di ogni simbolo, per nome** (etichette nel CSV: nome file,
colonna `InpMagic`, colonna `Use_Purple_PineReaction`):

| cella | gestione | VIOLA | magic | file |
|---|---|---|---:|---|
| **base** | nuda (SL 3xATR + TP mediana) | EA `\|c0-o0\| <= 1,5×ATR` | 772700 | `scan_ABTG_Bulge_<SYM>_nuda.csv` |
| | nuda | PINE `c0>o0` / `c0<o0` | 772700 | idem, riga con `Use_Purple_PineReaction=1` |
| | gestita (BE 1R + trailing R) | EA | 772710 | `scan_ABTG_Bulge_<SYM>_gestita.csv` |
| | gestita | PINE | 772710 | idem, riga con `Use_Purple_PineReaction=1` |

> La **cella base** è quella che riproduce `BULGE_MASTER.mq5`: è lì che si
> guarda se un giorno si vuole il confronto con l'originale di Claudio.

---

## 0. 🎯 LA DOMANDA DELLO SCAN — una sola, e non e' "quanto rende"

> ### **"Su QUALI dei 22 cross del basket questo motore ha un segnale, e con quale PROFILO (win rate, rapporto vincita/perdita, frequenza)?"**

E la domanda che **non** si fa: *"quale simbolo mettiamo in campo"*. Nessuna.

### 🛑 REGOLA ZERO — **LO SCAN NON PROMUOVE NIENTE**

Da R92-scan **non esce**: nessun `.set`, nessun EA attaccato a un grafico,
nessuna sedia, nessun cambio a niente di vivo. Esce **una lista di simboli che
meritano il round profondo a tick reali**, oppure nessuno.

Non e' prudenza formale, e' un fatto misurato di casa:

> **R57 — stesso EA, stessi dati, stessi parametri, cambiato SOLO il modello
> del tester (OHLC M1 -> tick): `PTE_GBPUSD` nell'orso 2022 passa da
> +1.245 PF 1,62 a −1.249 PF 0,75. IL SEGNO SI RIBALTA. E fino al 49% delle
> operazioni sparisce** (GBPUSD toro: n 37 -> 19).
>
> Da li' la frase di casa: **"l'OHLC e' solo screening, i verdetti solo a
> tick"**. R92-scan e' OHLC. Quindi R92-scan **e' screening**.

---

## 1. 📐 L'ASPETTATIVA, DICHIARATA **PRIMA** — e cosa vuol dire se non torna

Il riferimento non e' un'opinione: e' il backtest di Claudio, **misurato da noi
sul suo xlsx** e messo agli atti in cima ad `ABTG_Bulge.mq5`.

| voce | valore di Claudio | dove si legge nel CSV dello scan |
|---|---:|---|
| **win rate** | **80,22%** | (colonna trade + profitto: il WR si ricava dal report, va scritto a mano accanto) |
| **media vincita** | **+131,63** | — |
| **media perdita** | **−325,39** | — |
| **rapporto perdita/vincita** | **2,47x** | Expected Payoff + PF lo vincolano |
| **profit factor** | **1,599** | `Profit Factor` |
| **trade** | **268** in 4,25 anni su 6 simboli = **~10,5 per simbolo per anno** | `Trades` |
| **DD bilancio / equity** | **10,17% / 10,35%** (a rischio **3%**) | `Equity DD %` (qui a rischio **0,80%**) |

> ### 🔬 **IL PROFILO E' LA VERA IPOTESI DA FALSIFICARE, PIU' DEL PROFITTO.**
> Questo motore **dichiara** una forma precisa: vince quasi sempre poco, perde
> di rado tanto (SL = ATR x 3, TP = mediana BB). E' il disegno voluto dal coach
> — *"ATR x 3 e' difficile che venga toccato, e' fatto apposta"* — e confermato
> in R91.
>
> **Se lo scan NON riproduce quel profilo** (win rate crollato, perdite non piu'
> ~2,5 volte le vincite), l'ipotesi **numero uno** non e' "il mercato e'
> cambiato": e' che **il 40% di qualita' dati del backtest di Claudio stava
> mentendo**. Con dati bucati gli stop lontani vengono toccati meno di quanto
> succeda davvero, ed e' esattamente il difetto che gonfia un motore ad alto
> win rate.
>
> ⚠️ E vale anche il contrario, e va detto: se il profilo **torna**, non e' una
> promozione. E' solo il permesso di spendere una notte di tick reali.

### 1-bis. Cosa NON e' confrontabile con i numeri di Claudio, e perche'

| voce | Claudio | R92-scan | confrontabile? |
|---|---|---|---|
| rischio | **3,00%** | **0,80%** (firma) | ❌ profitti e DD in denaro. ✅ PF, win rate, n |
| dati | 40% qualita', tick misti | **OHLC M1** (Modello 1) | ❌ entrambi approssimano, in modi diversi |
| simboli | basket di 6 da UN grafico | **1 per passata** | ❌ il basket condivide `Max_Trades`: la concorrenza fra simboli sparisce |
| gestione | **BE 1R + trailing R** (a mano, col suo Manager MT4) | **misurate tutte e due** (nuda e gestita) | ✅ è il punto: il confronto lo fa il round |
| periodo | 2022.01.01-2026.03.30 | **2022.01.01-2026.06.30** | ✅ pinnato apposta |
| IS/OOS | **nessuno** | **nessuno nello scan** (arriva nel round profondo) | — |

---

## 2. 🐤 I TRE CANARINI — si leggono **PRIMA** dei numeri veri

### 2.1 🔵 IL BLU (il piu' importante, e riguarda il BANCO, non il mercato)

Sta scritto in cima ad `ABTG_Bulge.mq5`, punto **[DA DECIDERE] (a)**:
`CheckSignal` gira **una volta per barra, al primo tick**; la conferma BLU
pretende `closes[0] > opens[0]` sulla barra 0 — che al primo tick **e' uguale
all'apertura**. Sul **simbolo del grafico** — cioe' esattamente come gira lo
scan — **il BLU rischia di non scattare mai**.

L'EA stampa a fine passata:
`[BULGE-CONTA] ... aperture=N -> BLU=x VIOLA=y ARANCIO=z ...`

- **BLU = 0 su tutti e 22 i simboli** -> il round **non sta misurando la
  strategia di Claudio**: sta misurando il **solo VIOLA**. Si scrive a referto
  e ci si ferma: prima si decide *come* si prova un basket multi-simbolo, poi
  si misura. Qualunque altro numero, in quel caso, risponde a un'altra domanda.
- **BLU > 0** -> si prosegue, **ma il rapporto BLU/VIOLA va scritto accanto a
  ogni riga**: e' l'unico modo di sapere quale dei due segnali sta parlando.

[INFERITO dal codice, **NON misurato**: che i simboli NON del grafico si
comportino diversamente e' una deduzione, non una misura. Il conteggio e' il
modo per chiuderla.]

### 2.2 👯 IL DETERMINISMO DEL BANCO (89ª passata, facoltativa)

_Allineato il 21/08 dopo la firma: nella bozza il controllo era l'**asse magic
gemello** (precedente R51, *"tutte e quattro le coppie identiche"*). Con le 88
passate firmate quell'asse costerebbe **altre 88 corse**, e l'asse
dell'ottimizzatore ora serve alle due versioni del VIOLA._

Il controllo si fa **una volta sola, su un simbolo solo**: si rilancia la
**cella base** (`<SYM>_nuda`, `Use_Purple_PineReaction=0`) col magic **772701**
invece di 772700 e si confrontano le righe.
**Se non coincidono al centesimo, il banco non e' deterministico e NESSUN altro
numero di R92 vale.** Si cerca il perche' prima di leggere qualunque altra riga.

E c'è un secondo controllo, **gratis, dentro le 88**:
> il **VIOLA-PINE** è più selettivo del **VIOLA-EA** (pretende la candela di
> reazione, l'altro accetta anche quella rossa). Quindi, a parità di tutto il
> resto, **`n(PINE) <= n(EA)` deve valere su ogni simbolo.** Se su un simbolo il
> PINE facesse **più** trade dell'EA, non è il mercato: è un errore, e il round
> si ferma.

### 2.3 📅 IL PASSO 0 NON FATTO (la finestra che potrebbe non esistere)

> **La profondita' dei dati di questi 22 cross a BCM NON E' MISURATA.**
> L'unica misura forex agli atti e' **GBPUSD, tick dal 2024.07.05** (referto
> 15/08). Sulle barre il forex e' profondo (GBPUSD 1993, EURUSD/USDJPY 1971,
> `REFERTO_SONDA_STORICO_17-08.md`) **ma quel numero era il tetto "Max barre nel
> grafico" di MT5**, e se valga anche per lo Strategy Tester e' dichiarato
> **[INCERTO]** dal referto stesso.

Si misura prima. ⚠️ `-SoloReferto` **rilegge** l'ultimo referto e non misura
niente: per misurare davvero ci vuole `-Auto`, con **MT5 chiuso**.

```
.\scarica_storico.ps1 -Auto -SenzaTick -Da 2022.01.01 -Simboli "EURUSD,GBPUSD,...(i 22)"
```

`-SenzaTick` è quello che serve **a questo round**: lo scan gira in **OHLC M1**,
quindi la profondità che conta sono le **barre M1** e la misura costa minuti
invece di ore. La profondità dei **tick** è un'altra misura (stessa riga senza
`-SenzaTick`), si fa **dopo** e **solo sui simboli selezionati**, perché serve al
round profondo. Il referto esce da solo sul Desktop (`storico_bcm.zip`).

**Conseguenza accettata in anticipo:** finche' quella misura non c'e', **i
numeri di R92-scan sono PROVVISORI**. Un cross i cui dati partono dopo il
2022.01.01 ha girato su **mezza finestra** e il suo `n` non e' confrontabile
con gli altri — e' il **difetto n.18** della checklist, gia' pagato sugli
indici (il driver diceva 2024.01.01, i dati partivano dal 26/09/2024).
Se il passo 0 esce **dopo** i numeri, **i simboli con la finestra corta vanno
rilanciati**, non "interpretati".

---

## 3. 🚪 I CANCELLI — LE TRE SOGLIE, CONGELATE

Un simbolo **merita il round profondo a tick reali** se passa **tutte e tre**.
Nessuna delle tre da sola basta.

| # | soglia | da dove esce il numero |
|---|---|---|
| **S1 — CAMPIONE** | **n >= 30 trade** nella finestra 2022.01.01-2026.06.30 | L'atteso e' **~47** (10,5/anno x 4,5 anni, dalla frequenza misurata sul backtest di Claudio). 30 = **−36% dall'atteso**: sotto, o il simbolo non e' il suo mercato, o la finestra e' bucata (canarino 2.3). E vale l'avvertimento di R57: **passando ai tick reali fino al 49% delle operazioni sparisce**, quindi un simbolo a n=30 in OHLC puo' arrivare a **n≈15** al tick. Chi passa S1 al pelo va promosso al round profondo **sapendo che li' il merito sara' sospeso**. |
| **S2 — PROFIT FACTOR** | **PF >= 1,30** | Claudio misura **1,599**. 1,30 e' **−19%** da li': tiene conto del cambio di rischio e del fatto che un OHLC **puo' ribaltare il segno** (R57). Non si mette 1,05: un PF appena sopra 1 in OHLC, al tick, e' quasi sempre sotto 1. Non si mette 1,60: pretenderebbe che lo screening riproduca il caso migliore. |
| **S3 — PROFILO** | **win rate >= 65%** *e* **profitto netto > 0** | E' il test dell'ipotesi del paragrafo 1: il motore **dichiara** ~80% di vinti. 65% e' il pavimento sotto cui la forma non e' piu' quella (con perdite 2,5x le vincite, a WR 65% il PF scende gia' sotto 1,0: `0,65 / (0,35 x 2,47) = 0,75`). **Quindi S3 non e' un doppione di S2: e' il controllo che il PF, se c'e', arrivi dalla forma giusta** e non da due colpi di fortuna. |

### 3.1 ⚫ BOCCIATURA SECCA — basta **una** di queste

- **n < 20** -> *campione insufficiente*: il simbolo non e' leggibile nemmeno
  come direzione. Non si scrive un PF accanto: **un numero senza n non entra
  nel referto**, e un n troppo piccolo non fa nemmeno numero.
- **profitto netto <= 0** in OHLC. L'OHLC e' il modello **piu' generoso** dei
  tre (R57): quello che perde qui, al tick perde di piu'.
- **PF < 1,00**.

### 3.2 ⚪ IL PAREGGIO / LA ZONA GRIGIA, dichiarata e non tirata

Simbolo con **n >= 20** che passa **due soglie su tre**: si scrive a referto
come **"zona grigia"**, con il nome della soglia mancata. **Non va al round
profondo** in questo giro. Non e' bocciato per sempre: e' in coda dietro chi ha
passato tutte e tre. Una notte di macchina si spende sui migliori, non sui
forse.

---

## 4. 🎚️ LA REGOLA DI SELEZIONE — **la famiglia, mai il simbolo solo**

E' l'adattamento della regola di casa *"centro dell'altopiano, MAI il picco"*
(R70: il confronto si ribalto' quando fu rifatto con la regola giusta). Qui non
c'e' una griglia di parametri, c'e' una griglia di **simboli**: l'altopiano
sono i **vicini valutari**.

1. Un simbolo che passa le tre soglie **da solo**, con tutti i suoi parenti
   sotto, e' **un picco isolato = rumore**. Si scrive a referto come tale e
   **non si promuove**.
2. Un simbolo si propone se **almeno un altro cross della stessa famiglia lo
   accompagna** (i JPY fra loro, i commodity AUD/NZD/CAD fra loro, gli EUR/GBP
   fra loro). Due parenti che dicono la stessa cosa sono un segnale; uno solo
   e' un aneddoto.
3. **Tetto: al massimo 6 simboli** vanno al round profondo. Non e' una regola
   di gusto: e' una notte di macchina a tick reali per simbolo, e il PC di
   backtest e' **uno solo** (una macchina, un lavoro).
4. Il **conteggio operazioni va scritto accanto a OGNI numero**, senza
   eccezioni. E accanto va scritto **il regime contenuto**: 2022 dollaro forte,
   2023-24 disinflazione, 2025-26. **Niente 2008, niente 2015, niente 2020.**

---

## 5. ⚖️ EMENDAMENTO DELLA FINESTRA — cosa si puo' e cosa non si puo' dire

**Regola A (l'unita' di misura e' l'OPERAZIONE, >=150):** qui **non ci siamo, e
non ci possiamo essere**. A ~10,5 trade/anno per simbolo servirebbero **~14
anni** per fare 150 operazioni **in campione** e altrettante fuori. La finestra
di Claudio (4,5 anni) ne da' ~47 in tutto.

> ### 🔴 CONSEGUENZA, ACCETTATA IN ANTICIPO
> **In R92 (scan **e** round profondo) la selezione per il MERITO e' SOSPESA.**
> Vale la valvola R59: *il campione sottile sospende il giudizio sul MERITO,
> mai sul RISCHIO*.
> - ⛔ Nessun simbolo puo' essere dichiarato "buono" o "migliore".
> - ✅ Il **RISCHIO si legge lo stesso**: un drawdown accaduto e' **un fatto**,
>   non una stima. Se un cross fa il 20% di DD nel 2022, quello e' successo.
> - 📌 Un motore da ~10 trade/anno per simbolo, se un giorno andasse in campo,
>   ricadrebbe nel **TAGLIANDO A 6 MESI** del criterio di uscita delle sedie
>   (18/08): sotto 20 operazioni, si giudica per revisione di Claudio, non per
>   merito statistico. **Va scritto nel contratto della sedia PRIMA, non dopo.**

**Regola C (prova di regime):** la finestra 2022-2026 contiene **un blocco
solo**. La robustezza di regime (toro/orso/laterale/crollo) e' **un altro
round** — e sul forex, a differenza degli indici, i dati per farlo **forse ci
sono** (vedi passo 0): e' la prima cosa da chiedersi se R92 seleziona qualcuno.

---

## 6. 🛡️ IL RISCHIO, DETTO PRIMA CHE ARRIVINO I NUMERI

1. **IL CAP REGGE, ED E' LA FIRMA CHE L'HA FATTO REGGERE.**
   La bozza aveva 1,00% × `Max_Trades`=4 = **4,00%** di rischio aperto insieme,
   cioe' **sopra il cap C1 firmato il 18/08 (3,25%)**. Claudio ha firmato
   **0,80%**: **0,80 × 4 = 3,20% ≤ 3,25%.**
   Resta detto lo stesso, perche' vale: nel tester il **Guardian e' inerte**
   (fail-open, le sue GlobalVariable non esistono), quindi **nei numeri di R92
   il 3,20% ci puo' essere davvero**; in campo sarebbe il Guardian a fermare
   l'ingresso che sfonda il cap (la guardia e' sul percorso di apertura).
2. **`Risk_Percent` 0,80 non e' confrontabile in denaro con nessuno**: ne' con
   lo 0,50 di `BULGE_MASTER.mq5`, ne' con il 3,00 del backtest di Claudio, ne'
   con l'1,00 della bozza. **PF, win rate e n si'.**
3. **La gestione (b) NON alza il rischio**: BE e trailing muovono lo stop
   **solo a favore** (mai indietro), non aumentano il lotto e non aprono niente.
   Semmai lo abbassano — di quanto, e a che prezzo in euro, e' esattamente la
   domanda del round. E lo stop **iniziale** resta `ATR × 3` in tutte e 88 le
   passate: il disegno del coach non si tocca.
4. **Il kill switch resta acceso** (4 SL/giorno, 3 consecutivi, −2%/giorno):
   e' parte del motore di Claudio, non un accessorio. Spegnerlo cambierebbe i
   numeri e la domanda.
5. **Nessuna sedia viva viene toccata mentre R92 gira.** R92 non ha niente in
   campo: e' un motore nuovo per la flotta.

---

## 7. 📋 COSA DEVE CONTENERE IL REFERTO DI R92-SCAN (checklist)

- [ ] I **tre canarini** del par. 2 letti **per primi**, prima di ogni tabella.
- [ ] Il **conteggio operazioni accanto a OGNI numero** (n, e BLU/VIOLA).
- [ ] Il **regime** dichiarato accanto a ogni tabella.
- [ ] La **regola di selezione** (famiglia, non picco) dichiarata **insieme**
      alla lista dei promossi al round profondo.
- [ ] **Il confronto delle due GESTIONI**, simbolo per simbolo, e la risposta
      alla domanda della firma: **quanto vale il break-even in euro?** (e su
      quanti simboli cambia il segno, non solo il numero).
- [ ] **Il confronto delle due versioni del VIOLA**, con il controllo gratis
      `n(PINE) <= n(EA)` verificato su **ogni** simbolo.
- [ ] Le soglie S1/S2/S3 applicate **alla cella base** per la selezione, e le
      altre tre celle lette come **confronto**, non come candidate parallele
      (altrimenti si sceglie il meglio di quattro = si pesca).
- [ ] I simboli bocciati **scritti per nome**, con la soglia che li ha bocciati.
- [ ] Il **confronto di PROFILO** con il backtest di Claudio (win rate e
      rapporto perdita/vincita), con la conclusione esplicita su **cosa dice
      del 40% di qualita' dati**.
- [ ] Lo stato del **passo 0**: misurato o no, e quali simboli hanno la
      finestra corta.
- [ ] Distinzione esplicita **[MISURATO] / [INFERITO] / [DICHIARATO]**.
- [ ] La frase finale, in chiaro: **"lo scan non ha promosso niente; ha
      selezionato X simboli per il round profondo a tick reali"**.

---

## 8. ✍️ FIRMA

```
FIRMO R92          Claudio, data ____________
```

Finche' questa riga e' vuota, R92 **non si lancia** e i suoi numeri **non si
leggono**.


---

# ✍️ FIRMA DI CLAUDIO — 21/08/2026, **PRIMA** DI QUALSIASI NUMERO

Testuale, come detto in chat:

> **"c,firmo 0,8,misura entrambe"**

Dichiarazione di cecita': **nessun risultato di R92 e' stato prodotto, letto o
guardato** al momento della firma. L'EA `ABTG_Bulge.mq5` non e' mai stato
compilato ne' backtestato. Le tre soglie S1/S2/S3 restano quelle scritte sopra,
**non toccate dalla firma**.

## Cosa ha firmato, punto per punto

**1) "c" — SI MISURANO ENTRAMBE LE GESTIONI.**
Il round confronta la gestione NUDA dell'EA (SL 3xATR + TP mediana mobile,
nient'altro) contro la gestione VERA di Claudio (quella del suo Manager MQ4:
**break-even a 1R + trailing a gradini di R**, start 1,5R passo 0,25R), che in
MT5 **non esiste e va portata**. Il segnale resta **intoccato** in entrambe.
Scopo dichiarato prima: sapere **quanto vale il break-even in euro**, invece di
opinarlo. Vale identico per tutta la famiglia BreakingBand.
Nel porting si **corregge** il difetto ereditato del Manager
(`InitialRiskPoints()` usa lo SL CORRENTE: dopo il BE il denominatore va a ~0 e
i multipli R esplodono) memorizzando lo **SL INIZIALE per ticket**, come gli ABTG.
La correzione riguarda la GESTIONE, non il segnale.

**2) "firmo" — S1 / S2 / S3 CONGELATE.**
- **S1 campione:** n >= 30 trade
- **S2 profit factor:** PF >= 1,30
- **S3 profilo:** win rate >= 65% **e** profitto netto > 0
Piu' regola zero (lo scan non promuove niente), bocciatura secca, zona grigia,
"la famiglia mai il simbolo solo", tetto 6 simboli al round profondo.

**3) "0,8" — RISCHIO SCESO A 0,80%.**
Sostituisce l'1,00% della bozza. Motivo, dichiarato prima: 1,00% x `Max_Trades`=4
= **4% aperto**, sopra il cap C1 firmato il 18/08 (**3,25%**).
Con 0,80%: **0,80 x 4 = 3,20% <= 3,25%. Il cap regge.**
Nota per la lettura: e' un rischio **diverso** sia dal 3% del backtest di
Claudio sia dall'1% della bozza -> profitti e DD **in denaro** non sono
confrontabili con nessuno dei due; **PF, win rate e n** si'.

**4) "misura entrambe" — LE DUE VERSIONI DEL VIOLA.**
La divergenza trovata oggi nella triangolazione col Pine:
- **VIOLA-PINE:** ultima condizione `close > open` (candela di reazione **verde**)
- **VIOLA-EA:** ultima condizione `|close-open| <= 1,5 x ATR` (candela **non impulsiva**)
Si misurano **tutte e due**, non si sceglie a memoria. Nessuna delle due e' "la
correzione" dell'altra finche' il numero non parla.

## Dimensione del round che ne esce
**22 simboli x 2 gestioni x 2 varianti del VIOLA = 88 passate.**

## Cosa resta aperto DOPO la firma (non lo tocca)
- **PASSO 0**: profondita' dati dei 22 cross a BCM mai misurata -> finche' manca,
  i numeri sono **provvisori** (canarino 2.3).
- **Canarino BLU**: se `BLU=0` su tutti i simboli, il round misura solo il VIOLA
  e lo si dichiara nel referto.
- I **4 [DA DECIDERE]** nel codice restano decisioni di Claudio, non corretti.
