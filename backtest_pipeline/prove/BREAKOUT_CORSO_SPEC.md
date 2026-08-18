# 📐 BREAKOUT — SPECIFICA RICOSTRUITA DAL CORSO DI CLAUDIO (lezioni 34-40)

> 🆕 **AGGIORNAMENTO 18/08 ore ~15:15 — SONO ARRIVATE LE SLIDE DEL PDF.**
> 14 screenshot della lezione 40 in
> `trascrizioni_corso_2026-08-18/slide_lezione40/` = **10 slide uniche**
> (4 sono doppioni con timestamp diverso). **La meta' scritta del corso.**
> Etichetta nuova: **`[SLIDE n]`** = letto testualmente da una slide, la fonte
> piu' forte che abbiamo (e' il documento, non il parlato).
> **Riepilogo di cosa hanno chiuso: §0.**

> **Fonte:** le 7 trascrizioni + le 10 slide in
> `backtest_pipeline/caccia_strategie/trascrizioni_corso_2026-08-18/`.
> **Nient'altro.** Nessuna integrazione da memoria, nessuna lettura del codice
> usata per "completare" il corso: dove il corso tace, qui c'e' scritto **BUCO**.
>
> **Referto di analisi** (schede per lezione, citazioni, contraddizioni):
> `backtest_pipeline/caccia_strategie/ANALISI_CORSO_BREAKOUT_2026-08-18.md`
>
> **Etichette:** `[T]` = trascritto testualmente · `[I]` = inferito (dico da dove)
> · `[?]` = incerto/ambiguo · `[BUCO]` = il corso non lo dice.
>
> ⚠️ **Questa spec descrive cosa INSEGNA il corso, non cosa funziona.** I numeri
> di performance del corso sono `[dichiarato dal corso, NON verificato da noi]`
> e sono in **contraddizione frontale** col nostro backtest di paniere
> (vedi §9). La spec serve a stabilire *se un EA puo' essere fedele*, non a
> promuovere la strategia.

---

## 0. 🆕 COSA HANNO CHIUSO LE SLIDE (aggiornamento 18/08 ~15:15)

### 0.1 Le 10 slide uniche

| # | titolo slide | file screenshot | peso |
|---|---|---|---|
| S1 | **Descrizione** | `151240` | contesto |
| S2 | **Insidie** | `151302` (dup `151336`) | contesto |
| S3 | **Cross da tradare** | `151343` | 🟢 universo |
| S4 | **Identificazione area di congestione** | `151406` | 🔥 rettangolo |
| S5 | **Il segnale di ingresso operazione sell** | `151429` | 🔥 segnale SELL |
| S6 | **Il segnale di ingresso operazione buy** | `151442` | 🔥 segnale BUY |
| S7 | **Livelli di ingresso, stop e target** | `151456` (dup `151515`) | 🔥 livelli |
| S8 | **Validita' del segnale** | `151527` (dup `151537`) | 🔥 uscite |
| S9 | **Gestione dell'operazione** | `151549` (dup `151600`) | 🔥 break-even |
| S10 | **Money management** | `151619` | 🔥 rischio |

### 0.2 🎯 I TRE NODI PRIORITARI — l'esito

| nodo | esito | dettaglio |
|---|---|---|
| **(a) Williams 140 o 14?** | ✅ **CHIUSO: 140** | Nessuna slide lo scrive, ma **Claudio ha ri-ascoltato il video il 18/08 e conferma: 140 periodi** [CONFERMA DIRETTA sulla fonte primaria]. Il "140" della lez. 35 era giusto, non un errore di trascrizione. |
| **(b) Parametri SuperTrend** | 🔴 **NON CHIUSO — e ora sappiamo perche'** | Le slide nominano _"supertrend rosso"_ / _"supertrend verde"_ e **non danno mai ATR ne' moltiplicatore**. ⚠️ **Il PDF riepilogativo NON contiene i parametri degli indicatori**: non e' un ritaglio mancante, e' che il documento non li tratta. **La risposta puo' venire SOLO dal modulo precedente.** |
| **(c) Vincolo delle 20 candele** | 🟡 **CHIUSO A META'** | S4 scrive: _"Esso deve contenere 20 candele"_ + _"si costruisce a partire dal primo ingresso del William's"_ (S5/S6). **Ne segue che 20 candele DEVONO essere trascorse** (non puoi contenerne 20 a partire dall'ingresso se ne sono passate 5). Ma **nessuna slide scrive l'attesa come regola esplicita** → resta un'implicazione, non una citazione. |

### 0.3 ✅ Cosa le slide hanno CHIUSO davvero (6 ambiguita' su 10)

| ambiguita' | prima | ora |
|---|---|---|
| **1. 15 vs 20 candele** | risolta per argomento | ✅ **CHIUSA DALLA FONTE** — S4: _"deve contenere 20 candele"_ |
| **2. "almeno" vs "al massimo" 20** | risolta per argomento | ✅ **CHIUSA** — S4: _"deve contenere 20 candele"_ + _"aggiornato ad ogni chiusura di candela"_ = **finestra mobile di 20** |
| **4. banda SELL "0/−50" vs "−20/−50"** | risolta per argomento | ✅ **CHIUSA DALLA FONTE** — S5 scrive **_"William's compreso tra -20 e -50"_**. Il _"tra 0 e meno 50"_ del parlato e' **definitivamente un errore verbale** |
| **5. "ancora dentro" vs "uscito"** | risolta per argomento | ✅ **CHIUSA** — S5/S6 danno solo la banda numerica, senza la frase contraddittoria |
| **6. trailing stop vs BE** | risolta per argomento | ✅ **CHIUSA** — S9 scrive **solo** lo stop in pari, **la parola "trailing" non compare in nessuna slide** → il trailing e' un espediente del video, **non fa parte della strategia** |
| **10. XAU dentro o fuori** | incerta + codice storpiato | ✅ **CHIUSA** — S3: _"Anche il gold **XAU/USD** risponde bene ma richiede capitali di partenza piu' elevati"_. Ticker confermato, esclusione per capitale confermata |

### 0.4 🆕 Cosa le slide AGGIUNGONO (regole nuove, non presenti nel parlato)

1. **`[SLIDE S4]` Cadenza di aggiornamento esplicita:**
   > _"Il rettangolo dovra' essere **aggiornato ad ogni chiusura di candela**"_

   Il parlato diceva solo _"si aggiorna man mano"_. Ora e' una **regola con una
   cadenza**: ricalcolo a ogni barra chiusa. **Direttamente implementabile.**

2. **`[SLIDE S8]` Le tre uscite come REGOLA, non come facolta':**
   > _"L'operazione **si chiudera'** in caso di: Stop loss / Take profit /
   > **Segnale direzionale contrario**"_

   Nel parlato era _"**possiamo** chiudere"_ (facolta'). La slide usa
   l'indicativo futuro: **e' un obbligo.** → La chiusura su segnale contrario
   **non e' un flag A/B: e' la strategia.**

3. **`[SLIDE S10]` ⚠️ La parola nuova che cambia il rischio di portafoglio:**
   > _"si consiglia per le prime 20 operazioni di tenere un **rischio
   > COMPLESSIVO dell'1%** e valutare successivamente i parametri di drawdown
   > prima di aumentare tale percentuale"_

   **Il parlato ha SEMPRE detto _"rischio 1% per l'operazione"_** (lez. 35, 37).
   **La slide scrive _"complessivo"_.** Vedi §8.1: **non e' un dettaglio, e' il
   fattore 7.**

### 0.5 🔥 IL REPERTO PIU' IMPORTANTE: cosa NON c'e' nel PDF

**La regola discrezionale del §7.4 — _"il Williams arriva all'estremo opposto
prima del target"_ — NON COMPARE IN NESSUNA SLIDE.**

Nel video (lez. 38) occupa un blocco lungo, con tre comportamenti alternativi e
un _"io personalmente mi preoccupo"_. Nella **checklist ufficiale** della stessa
autrice, **non esiste**: la slide S8 elenca **tre e sole tre** uscite (SL, TP,
segnale contrario).

> ⚖️ **Conseguenza operativa netta:** quella non e' una regola della strategia,
> e' un **commento personale a braccio**. Un EA che NON la implementa **non e'
> infedele: e' piu' fedele al documento.** Questo **elimina l'unica vera
> discrezionalita'** della spec.

---

## 1. 🎯 IDENTITA' DELLA STRATEGIA

| voce | valore | fonte |
|---|---|---|
| Nome | Strategia di Breakout | lez. 34 |
| Stile reale | **breakout CONTRO l'oscillatore** (si vende la rottura del minimo mentre il Williams e' in ipercomprato) | `[I]` da lez. 36+40, vedi §3 |
| Timeframe | **M15** | `[T]` lez. 37: _"questo e' un grafico a 15 minuti"_ · lez. 40: _"20 candele sul time frame a 15 minuti"_ |
| Piattaforma del corso | MT4 | `[T]` lez. 35, 36, 37, 38 |
| Indicatori | Williams %R + SuperTrend | `[T]` lez. 35 |

> 🧠 **Nota di lettura importante.** Il corso lo chiama "breakout" e lo motiva
> come uscita da compressione di volatilita' (lez. 40: _"movimenti direzionali
> di mercato che seguono ad una fase di compressione di volatilita'"_), **ma la
> regola direzionale lo rende un fade**: con Williams in **ipercomprato** si
> opera **solo SELL** (lez. 36: _"l'unica direzione che potremo seguire per le
> nostre operazioni sara' un sell"_). Si vende la rottura del **minimo** dopo
> una salita. E' un'inversione, non una continuazione. `[I]` — nessuna lezione
> usa la parola "inversione", la deduzione viene dall'accoppiata
> zona-oscillatore + lato della rottura, dichiarata identicamente in 36 e 40.

---

## 2. 🌍 UNIVERSO OPERATIVO

### 2.1 Strumenti — `[T]` lez. 35 e 40, convergenti

Le **7 coppie con lo yen**, elencate due volte in due lezioni diverse con lo
stesso contenuto:

`USDJPY` · `EURJPY` · `GBPJPY` · `CHFJPY` · `CADJPY` · `NZDJPY` · `AUDJPY`

- lez. 35: _"dollaro, euro Yen, sterlina Yen, Franco Yen, CAD Yen, NZD Yen e
  Audi Yen. Ok, sono 7."_ ("Audi Yen" = AUDJPY, `[T]` storpiatura evidente)
- lez. 40: _"tutte le coppie con lo Yen e di tutti i cross con lo Yen, quindi
  dollaro Yen, euro Yen, sterlina Yen, franco Yen, NZD Yen, AUD Yen e CAD Yen"_
- **Motivazione dichiarata:** _"la strategia di breakout e' estremamente
  performante per alcune coppie in particolare, in modo specifico per le coppie
  con lo Yen"_ (lez. 35) — perche' devono muoversi _"senza forti
  ritracciamenti"_ (lez. 34).

### 2.2 Oro — menzionato ma escluso `[T]` lez. 40

- _"anche l'oro risponde molto bene a queste logiche di breakout"_, codice
  piattaforma trascritto **`XAUSD`** `[TRASCRITTO dubbio]` — quasi certamente
  `XAUUSD`, ma la trascrizione riporta 5 caratteri.
- **Escluso per capitale:** _"per questo tipo di strumento occorrono pero' dei
  capitali molto piu' elevati e per questo motivo lo lasciamo un po' da parte
  per chi inizia"_. → Non e' un'esclusione tecnica, e' dimensionale.

### 2.3 Sessioni / orari — **assenza DICHIARATA, non buco** `[T]` lez. 40

> _"Si tratta di coppie che possono essere tradate in qualsiasi momento della
> giornata, si muovono bene anche nelle nostre sessioni europee o americane,
> quindi non sono coppie che devono essere tradate necessariamente di notte"_

→ **Nessun filtro orario. Nessuna sessione. 24/5.** Questo e' esplicito: il
corso non ha dimenticato l'orario, lo ha **escluso**.

### 2.4 Fuso della piattaforma del corso `[?]`

Dichiarato due volte, in modo ambiguo:
- lez. 36: _"la candela delle 14.30 in realta', la piattaforma indietro di due
  ore rispetto alle ore al nostro orario effettivo"_
- lez. 38: _"questo segnale e' stato dato alle 15, perche' la piattaforma va
  indietro di due ore"_

**Lettura letterale:** piattaforma = ora italiana − 2. **Non e' il nostro fuso:**
BCM = ora italiana − 1, quindi la piattaforma del corso e' **1 ora indietro
rispetto a BCM**. `[?]` la direzione non e' inequivocabile dal parlato (potrebbe
voler dire "l'orario vero e' 2 ore avanti a quello che vedete").
**Impatto operativo: NULLO** — non esistendo filtri orari (§2.3), il fuso serve
solo a rileggere gli esempi, non a configurare un EA. Si annota per onesta', non
si converte niente.

---

## 3. 🔧 INDICATORI E LORO PARAMETRI

| indicatore | parametro | valore | fonte |
|---|---|---|---|
| Williams %R | periodo | **140** | `[T]` lez. 35: _"il nostro Williams, sempre settato a 140 periodi"_ — **UNICA occorrenza in tutto il corpus** |
| Williams %R | soglia ipercomprato | **W >= −20** | `[I]` — vedi §3.1 |
| Williams %R | soglia ipervenduto | **W <= −80** | `[I]` — vedi §3.1 |
| Williams %R | linea mediana | **−50** | `[T]` lez. 38 e 40 |
| SuperTrend | periodo ATR | **[BUCO]** | mai detto in 34-40 |
| SuperTrend | moltiplicatore | **[BUCO]** | mai detto in 34-40 |

### 3.1 ⚠️ Le soglie −20 / −80 sono INFERITE, non dettate

Il corso **non pronuncia mai** "ipercomprato = −20" o "ipervenduto = −80". Le
soglie si ricavano dagli intervalli di validazione del segnale, che invece sono
dettati:

- **SELL** — lez. 38: _"Williams che esce dall'area di percomprato e si
  posiziona fuori, entro appunto il livello tra meno 20, compreso il livello
  tra meno 20 e meno 50"_ → banda di segnale **[−50, −20]**.
- **BUY** — lez. 40: _"il nostro Williams deve essere uscito dall'area di
  ipervenduto e si deve pero' trovare ancora nell'area compresa tra meno 80 e
  meno 50"_ → banda di segnale **[−80, −50]**.

Se la banda "appena uscito dall'ipercomprato" parte da −20, allora
l'ipercomprato **e'** [−20, 0]; simmetricamente l'ipervenduto e' [−100, −80].
`[I]` **da due lezioni diverse + simmetria**, ed e' l'unica lettura che rende
coerenti entrambe le frasi.

### 3.2 ✅ Williams a 140 periodi — CHIUSO il 18/08: Claudio ha ri-ascoltato il video e conferma 140

- Occorre **una sola volta**, in una sola lezione, senza mai essere ripetuto:
  **nessuna convergenza interna**.
- Il default di mercato del Williams %R e' **14**. Un "140" puo' essere sia un
  settaggio reale ereditato dal modulo precedente (il corso dice _"sempre"_,
  cioe' lo da' per gia' stabilito altrove), sia una storpiatura speech-to-text.
- **Conseguenza pratica pesante:** su M15, 140 periodi = **35 ore** di
  look-back. Toccare −20 significa essere sul massimo di 35 ore. La frequenza
  dei setup cambia di un ordine di grandezza fra 14 e 140.
- **Verdetto:** `[TRASCRITTO chiaro nel testo, ma SINGOLA FONTE]` — da
  confermare sul PDF/piattaforma prima di considerarlo acquisito.

### 3.3 🔴 SuperTrend — il buco BLOCCANTE

Il corso lo usa in ogni lezione ma **non ne detta mai i parametri**. Lez. 35 lo
tratta come gia' noto: _"Utilizzeremo il Supertrend ancora una volta"_,
_"Abbiamo salvato il nostro setup di base ... Lo abbiamo fatto nel modulo
precedente"_.

→ **I parametri del SuperTrend stanno in un modulo NON trascritto.** Sono due
gradi di liberta' (periodo ATR + moltiplicatore) che decidono quanti segnali
esistono. **Senza questi due numeri la strategia non e' riproducibile**, e
qualunque valore si usi e' *nostro*, non del corso.

---

## 4. 📦 IL RETTANGOLO DI CONGESTIONE

### 4.1 Regole certe

| # | regola | fonte |
|---|---|---|
| R1 | Il rettangolo si costruisce **solo** quando il Williams e' entrato in ipercomprato **o** ipervenduto | `[T]` lez. 36: _"Il canale deve essere realizzato nel momento in cui il Williams entra o in ipercomprato o in ipervenduto"_ |
| R2 | Ampiezza: **20 candele M15** | `[T]` lez. 40: _"Il rettangolo deve contenere 20 candele, 20 candele sul time frame a 15 minuti"_ |
| R3 | Ancoraggio iniziale: **la candela in cui il Williams entra in zona** | `[T]` lez. 40: _"iniziamo a costruirlo proprio dal primo ingresso del Williams nell'area di scarico"_ |
| R4 | Il rettangolo **trasla** in avanti abbracciando sempre le ultime 20 candele | `[T]` lez. 38: _"man mano che si sposta in avanti viene avanzato il nostro canale, fino a che non contiene sempre ... queste famose 20 candele"_ |
| R5 | Livelli = **massimo assoluto** e **minimo assoluto** delle 20 candele (estremi di wick, non di corpo) | `[T]` lez. 36: _"questo e' il livello piu' basso toccato dalle candele e questo e' il livello piu' alto toccato dalle candele"_ |
| R6 | I livelli si **riaggiornano** ad ogni traslazione | `[T]` lez. 40 |

**Implementazione diretta:** `rectHigh = Highest(High, 20)`,
`rectLow = Lowest(Low, 20)`, su candele **chiuse**.

### 4.2 ⚠️ Ambiguita' n.1 — 15 o 20 candele?

La lez. 36 dice **entrambe le cose in 5 righe**:
- riga 5: _"dobbiamo selezionare un rettangolo che deve contenere **15 candele**"_
- riga 9: _"Questo canale deve contenere almeno **15 candele**"_
- riga 11 (subito dopo, contando ad alta voce): _"...12, 13, 14, 15, 16, 17, 18,
  19 e 20. Ok, questo e' il rettangolo laterale che si e' formato nelle **20
  candele**"_
- riga 15: _"questa congestione ... deve abbracciare almeno **20 candele**"_

Da li' in poi **solo 20**, in tutte le lezioni (36 restante, 38, 40).

> ✅ **RISOLTA a favore di 20.** Il "15" compare 2 volte all'inizio di una sola
> lezione e viene contraddetto dal relatore stesso **mentre conta le candele in
> diretta**; il "20" compare oltre 15 volte in 3 lezioni, ed e' l'unico valore
> nella lezione di riepilogo (40). `[I]`

### 4.3 ⚠️ Ambiguita' n.2 — "almeno 20" o "al massimo 20"?

- lez. 36: _"deve abbracciare **almeno** 20 candele"_
- lez. 40: _"Ricordate che deve contenere **al massimo** 20 candele"_

> ✅ **RISOLTA:** i due vincoli insieme, piu' il comportamento mostrato (finestra
> che trasla mantenendo il conteggio a 20), significano **esattamente 20**,
> cioe' una **finestra mobile di 20 candele**. `[I]`

### 4.4 ⚠️ Ambiguita' n.3 — la candela di rottura sta dentro il rettangolo?

- lez. 36 riga 9: _"Questo canale deve contenere almeno 15 candele, **compresa
  anche la candela di rottura, se vogliamo**"_ ← il _"se vogliamo"_ e'
  letteralmente discrezionale.
- lez. 36 riga 11, contraddicendolo: _"questo e' il rettangolo laterale che si
  e' formato nelle 20 candele **che precedono la candela di rottura**"_

> ✅ **RISOLTA per necessita' logica: la candela di segnale va ESCLUSA.** Se la
> candela che rompe fosse dentro il rettangolo, il suo minimo diventerebbe il
> minimo del rettangolo e **non potrebbe rompere se stessa**: la regola si
> auto-annullerebbe. `[I]` — deduzione matematica, non citazione.
>
> **Per il developer:** il rettangolo sono le **20 candele chiuse che precedono
> la candela di segnale** (shift 2..21 se la candela di segnale e' shift 1).

### 4.5 ⚠️ Ambiguita' n.4 — quante candele devono passare dall'ingresso in zona?

Il corso e' **esplicito** su questo, ed e' un vincolo che si perde facilmente:

> `[T]` lez. 36: _"il canale sara' elaborato nel momento in cui avremo questo
> ingresso dell'indicatore e a quel punto si iniziera' a contare il nostro
> canale, nel senso che dovremo andare da quella candela in avanti per almeno
> 20 candele seguenti. **Quindi prima di quel tempo noi non riusciremo ad avere
> nessun setup di breakout.**"_

→ **Regola R7:** devono essere trascorse **almeno 20 candele M15 dall'ingresso
del Williams in zona** prima che un segnale sia ammissibile. Confermata dalla
motivazione operativa in lez. 37: _"20 candele di 15 minuti, stiamo parlando di
circa tre ore per la costruzione di una nuova fase di lateralita'"_.

> 🔴 **Questo e' il punto in cui un EA sbaglia per default.** Una finestra
> `Highest(20)` senza contatore fa scattare il segnale anche 3 candele dopo
> l'ingresso in zona, usando un rettangolo composto in maggioranza da candele
> **precedenti** l'ingresso in zona — cioe' un rettangolo che il corso vieta.
> Vedi §10 per il confronto col codice in campo.

**Contro-esempio nel corso stesso** `[?]`: lez. 38 descrive un secondo segnale
dove _"non ci sono state le 20 candele di congestione nel frattempo"_ e il
segnale viene comunque considerato valido. Non e' chiaro se sia
un'eccezione ammessa o una semplificazione narrativa. **Rimane aperta.**

---

## 5. 🎯 IL SEGNALE DI INGRESSO

### 5.1 Le TRE condizioni, obbligatorie e simultanee

`[T]` lez. 38 (formulazione piu' netta): _"bisogna aspettare tutti questi tre
elementi prima di poter entrare in posizione"_.

**SELL** (rettangolo costruito in **ipercomprato**):

| # | condizione | fonte |
|---|---|---|
| C1 | **Chiusura** di candela **sotto** il minimo assoluto del rettangolo | `[T]` lez. 40: _"la rottura deve avvenire con una chiusura di candela, quindi la chiusura deve essere al di sotto del livello di rottura"_ |
| C2 | **SuperTrend rosso** (ribassista) | `[T]` lez. 40: _"se dobbiamo fare un'operazione sell il super trend deve essere rosso"_ |
| C3 | Williams **uscito** dall'ipercomprato e compreso fra **−50 e −20** | `[T]` lez. 38 |

**BUY** (rettangolo costruito in **ipervenduto**), lez. 40:

| # | condizione |
|---|---|
| C1 | **Chiusura** di candela **sopra** il massimo assoluto del rettangolo |
| C2 | **SuperTrend verde** |
| C3 | Williams uscito dall'ipervenduto e compreso fra **−80 e −50** |

### 5.2 Regola direzionale (filtro one-way) `[T]` lez. 36

> _"Le rotture a rialzo non saranno valutate in questo contesto"_ (mentre il
> Williams e' in ipercomprato) — e simmetricamente: _"se dovesse rompere al
> rialzo invece rimaniamo fuori dall'operazione"_.

→ **Zona ipercomprato ⇒ SOLO SELL. Zona ipervenduto ⇒ SOLO BUY.** La rottura
opposta non e' un segnale, e non e' nemmeno un invalidatore esplicito `[BUCO]`.

### 5.3 Ordine di arrivo delle condizioni: irrilevante `[T]` lez. 38

> _"e' possibile ... che il Williams esca prima rispetto al super trend.
> Potrebbe determinarsi una rottura del super trend che deve attendere il
> Williams o comunque possiamo avere entrambi gli indicatori che ci danno il
> segnale ma non avere la rottura della candela"_

→ Conta **solo** che le tre condizioni siano vere **sulla candela di segnale**.
Meccanizzabile senza ambiguita'. L'esempio del 1° maggio (lez. 38) e' proprio
questo: rottura + SuperTrend gia' rossi, ma segnale posticipato di alcune
candele fino all'uscita del Williams.

### 5.4 ⚠️ Ambiguita' n.5 — "ancora in ipercomprato" oppure "uscito"?

La lez. 40 dice le due cose **nella stessa frase**:

> _"il Williams si deve **ancora trovare nell'area di ipercomprato**, quindi
> nell'area compresa ... **tra 0 e meno 50**, quella e' l'area entro la quale si
> deve trovare il nostro Williams, **che deve essere uscito dall'area di
> ipercomprato**"_

E la banda dichiarata (`0 / −50`) non coincide con quella della lez. 38
(`−20 / −50`).

> ✅ **RISOLTA a favore di [−50, −20]**, per tre motivi: (a) la lez. 38 e' la
> piu' specifica e la piu' operativa (_"compreso il livello tra meno 20 e meno
> 50"_); (b) il caso BUY della stessa lez. 40 e' **simmetrico e non ambiguo**
> (−80/−50), e la simmetria impone −20/−50 per il SELL; (c) "deve essere
> uscito dall'ipercomprato" esclude per definizione la fascia [−20, 0].
> `[I]` — il "tra 0 e meno 50" e' letto come descrizione grossolana della meta'
> alta dell'oscillatore.

---

## 6. 💰 LIVELLI: INGRESSO, STOP, TARGET

### 6.1 Il principio che regge tutto: **l'ancora e' la candela di segnale**

`[T]` lez. 38, ripetuto tre volte in tre modi:
> _"Tutta l'operazione verra' costruita a partire da questa candela, non dalla
> candela di rottura"_ · _"la gestione dell'operazione deve partire dalla
> candela del segnale"_ · lez. 40: _"i livelli vengono calcolati dalla chiusura
> della candela di segnale, non dal momento in cui inseriamo la nostra
> operazione in macchina"_

**Tutti** i livelli (SL, TP, break-even, calcolo di R) si misurano da
`Close(candela di segnale)` — **mai** dal prezzo di riempimento reale.

### 6.2 Tabella dei livelli

| voce | SELL | BUY | fonte |
|---|---|---|---|
| **Ingresso teorico** | Close della candela di segnale | idem | `[T]` lez. 40: _"il livello di entrata sarebbe il livello di chiusura della candela di rottura"_ |
| **Stop loss** | **1 pip SOPRA** il massimo del rettangolo | **1 pip SOTTO** il minimo del rettangolo | `[T]` lez. 40: _"Lo stop delle operazioni sell deve essere posizionato un PIP al di sopra rispetto alla resistenza"_ · lez. 37: _"lo stop va a un pip sopra rispetto al massimo"_ |
| **R (rischio unitario)** | `|CloseSegnale − SL|` | idem | `[T]` lez. 40: _"Il target dell'operazione e' dato dalla quantita' di PIP corrispondenti alla distanza tra l'entrata e lo stop"_ |
| **Take profit** | `CloseSegnale − 3R` | `CloseSegnale + 3R` | `[T]` lez. 40: _"il target sara' 3 volte il nostro stop, quindi 20 PIP per 3, quindi 60 PIP"_ |
| **R:R nominale** | **1:3** | idem | `[T]` lez. 40: _"Il rapporto di rischio-rendimento previsto deve essere di tipo 1 a 3"_ |

**Esempio numerico dettato** `[T]` lez. 37, USDJPY:
massimo congestione `155,95` → SL `155,96` (1 pip sopra) · chiusura segnale
`155,57` → R = **40 pip** → TP = `155,57 − 1,20` = **`154,37`** (120 pip).
✅ **Aritmetica verificata, i tre numeri chiudono.** Utile come test-case di
regressione per un EA. (Nella stessa lezione dice anche _"ci sono 41 pip di
distanza"_ riferito al **suo** prezzo di ingresso reale, diverso dai 40 teorici:
non e' un errore, e' la distinzione entrata reale/entrata teorica.)

### 6.3 Il **pip** su JPY `[BUCO]`

Mai definito. Dall'esempio (155,95 → 155,96 = "1 pip") si ricava `1 pip = 0,01`
su USDJPY. `[I]` da aritmetica dell'esempio. Ovvio per un umano, **non** per un
EA su broker a 3 decimali: va imposto esplicitamente.

### 6.4 Ingressi ritardati — la soglia 1:2 `[T]` lez. 37 e 40

> _"L'importante e' mantenere un rapporto di rischio-rendimento almeno di tipo
> 1 a 2"_ (lez. 37) · _"Vi consiglio di inserire delle operazioni qualora il
> vostro livello di ingresso sia compatibile con un rapporto di
> rischio-rendimento almeno di tipo 1 a 2"_ (lez. 40)

- Si puo' entrare **in qualsiasi momento dopo il segnale**, purche' dal prezzo
  corrente al TP (che **resta quello ancorato al segnale**) ci siano **>= 2
  volte** la distanza dallo stop.
- SL e TP **non si ricalcolano**: _"Tutte le entrate fatte successivamente
  devono avere lo stesso target e lo stesso stop di quella candela la'"_
  (`[T]` lez. 37).
- ⚠️ Attenzione all'asimmetria: **lo stop e' fisso**, quindi entrare peggio
  **non** aumenta il rischio in pip, lo **riduce**; entrare meglio lo aumenta.
  Il corso presenta il vincolo 1:2 come tutela, ma con SL fisso la vera perdita
  in R varia con l'ingresso. Il corso **non discute** questo effetto `[BUCO]`.

### 6.5 Tipo di ordine: **solo a mercato, MAI pendenti** `[T]` lez. 37

> _"e' bene non inserire degli ordini pendenti, perche' abbiamo bisogno di
> verificare intanto la posizione del Williams quando andiamo ad inserire i
> nostri ordini a mercato"_

> 🧠 **Critica per il developer:** questa regola e' un **vincolo umano, non
> logico**. Il motivo dichiarato e' la necessita' di *controllare gli indicatori
> al momento dell'ingresso* — cosa che un EA fa alla chiusura della candela di
> segnale per costruzione. Un EA che entra a mercato alla prima tick dopo la
> chiusura del segnale e' **piu' fedele allo spirito** di quanto lo sarebbe un
> umano che entra 4 ore dopo. **Non e' una divergenza: e' la regola che perde
> senso fuori dal contesto manuale.**

---

## 7. 🛡️ GESTIONE DELL'OPERAZIONE

### 7.1 Break-even a +1R — regola certa

| voce | valore | fonte |
|---|---|---|
| Trigger | il prezzo percorre **1R** (= la distanza dello stop) **dalla chiusura del segnale** | `[T]` lez. 37: _"Il primo 1% si raggiunge quindi nel momento in cui il mercato ha ripercorso i 40 pip"_ |
| Azione | SL → **chiusura della candela di segnale** | `[T]` lez. 38 |
| Dopo | si tiene aperto fino a TP 3R | `[T]` lez. 40 |

🔑 **Il dettaglio che quasi tutti sbagliano**, dettato in modo esplicito
(`[T]` lez. 38):
> _"lo stop va spostato **non sul livello di entrata che avete realizzato voi**,
> ... ma va spostato **sul livello di chiusura della candela del segnale**"_
> ... _"Se infatti voi aveste fatto un'entrata su queste aree ... e aveste
> spostato il vostro stop a zero appena raggiunto il primo target, vedete, i
> prezzi sarebbero ritornati indietro e vi avrebbero appunto scacciati fuori dal
> mercato, con un guadagno pari a zero invece appunto del 3%"_

→ Il "break-even" del corso **non e' il pareggio del trader**: e' un livello
oggettivo condiviso da tutti gli ingressi dello stesso segnale.

### 7.2 ⚠️ Ambiguita' n.6 — il trailing stop contraddice il break-even

La lez. 37 implementa il BE con il **trailing stop di MT4**:
> _"Io devo mettere un trailing stop a 40 pip, quindi questi 40 pip devono
> essere 400 punti"_ · _"tenete conto che qui mi da' di default 15 punti, che
> non sono 15 pip, 15 punti sono un pip e mezzo"_

`[T]` **trailing = 400 punti = 40 pip = 1R**, e va poi **rimosso a mano**:
> _"Una volta che il mercato raggiunge il livello di trailing stop, ritorniamo
> sull'ordine, togliamo il trailing stop ... e spostiamo solo lo stop loss sul
> livello di entrata"_

🔴 **La contraddizione:** il trailing di MT4 misura **dal prezzo di fill reale**,
mentre la regola (§7.1) impone il BE **sulla chiusura del segnale**. Se l'utente
e' entrato peggio del segnale, il trailing lo porta a un livello **diverso** da
quello prescritto — esattamente l'errore che la lez. 38 dice di evitare.

> ✅ **RISOLTA a favore della REGOLA, non dello strumento.** Il trailing e' un
> **espediente di comodo per chi non puo' stare al monitor** (_"proprio perche'
> rischiamo altrimenti di non riuscire a seguire l'operazione"_, lez. 37), e la
> lez. 40 lo declassa a facoltativo: _"In questo ci possiamo **aiutare**
> inserendo ... un trailing stop"_. La lez. 38 e la lez. 40 concordano sulla
> regola sostanziale. **Un EA implementa il BE sulla chiusura del segnale e
> NON usa trailing.** `[I]` da 3 lezioni.

### 7.3 Uscita su segnale contrario — regola certa `[T]` lez. 40

> _"l'operazione si rigira, il mercato si rigira, ci dara' un segnale contrario
> e magari ancora i prezzi non hanno raggiunto ne' lo stop ne' il target. A quel
> punto non avrebbe senso mantenere un'operazione in piedi e quindi
> indipendentemente dal livello in cui ci troveremo possiamo chiudere"_

→ Chiusura al **segnale opposto completo** (le 3 condizioni invertite).
Meccanizzabile. ⚠️ Nota il _"possiamo"_: e' formulato come facolta', non come
obbligo. `[?]` lieve.

### 7.4 🔴 La regola NON meccanizzabile: "il Williams arriva prima del target"

`[T]` lez. 38 — la riporto per intero perche' e' il punto che decide se un EA
puo' essere fedele:

> _"quando gia' il Williams va in area di ipercomprato prima del raggiungimento
> del target, **cominciamo un po' ad allertarci** perche' non e' un bel
> segnale"_ ... _"**Io personalmente mi preoccupo** gia' nel momento in cui
> Williams entra in ipercomprato e non ha raggiunto il target, pero' se si vuole
> essere un pochettino piu', magari dare un po' piu' di spazio al mercato, e'
> possibile avanzare gli stop, magari, o comunque chiudere l'operazione
> definitivamente nel momento in cui abbiamo il segnale contrario"_

**Il corso offre TRE comportamenti alternativi per la stessa situazione**, senza
criterio di scelta:
1. chiudere subito quando il Williams tocca l'estremo opposto;
2. "avanzare gli stop" (di quanto? `[BUCO]`);
3. aspettare il segnale contrario completo (§7.3).

> ⚖️ **Verdetto:** questa e' l'**unica regola davvero discrezionale** della
> strategia, ed e' anche una regola che **incide molto** sul risultato (decide
> quante operazioni muoiono a BE invece di andare a 3R). Un EA deve sceglierne
> una: la scelta e' **nostra**, e va dichiarata come tale — **non e' "il corso"**.
> Trattarla come input A/B e' l'unica onesta.

---

## 8. 📊 RISCHIO E MONEY MANAGEMENT

| voce | valore | fonte |
|---|---|---|
| Rischio per operazione | **1%** | `[T]` lez. 35: _"iniziamo a inserire il rischio 1% per l'operazione"_ · lez. 37 · lez. 39 |
| Sizing | calcolatore di posizione esterno: valuta conto + pip di stop + rischio % → volume | `[T]` lez. 35, 37 |
| Esempio di size dettato | conto in EUR, USDJPY, 41 pip di stop, 1% → **0,41 lotti** | `[T]` lez. 37 |
| Aumento del rischio | **solo dopo >= 20 operazioni** di storico (anche demo) | `[T]` lez. 40 |
| Tetto di drawdown | **20%** complessivo su **tutte** le strategie insieme | `[T]` lez. 40 e 39 |
| Ordini contemporanei | _"dovete fare un unico ordine per volta"_ | `[T]` lez. 37 — ⚠️ vedi §8.1 |

### 8.1 ⚠️ "Un unico ordine per volta" + "rischio COMPLESSIVO dell'1%" `[?]`

> 🆕 **AGGIORNATO DALLE SLIDE — e la lettura si e' ROVESCIATA.**

Detto in lez. 37 nel contesto di **un solo cross** (USDJPY, dove aveva due
posizioni aperte a scopo dimostrativo). Le due letture possibili:
- **(a)** una posizione per **cross** → fino a **7 posizioni** e **7% di
  rischio** simultaneo su un'unica scommessa sullo yen;
- **(b)** una posizione per **portafoglio** → **1% massimo sempre**.

**Prima delle slide** propendevo per (a): il corso prepara i grafici di tutte e
7 le coppie per cercare setup simultanei (lez. 36).

**La slide S10 ribalta l'indizio principale:**
> `[SLIDE S10]` _"si consiglia per le prime 20 operazioni di tenere un **rischio
> complessivo dell'1%**"_

Il parlato dice sempre _"rischio 1% **per l'operazione**"_ (lez. 35, 37); la
slide scrive **_"complessivo"_**. E la stessa autrice usa "complessivo" nel
senso di *aggregato su tutto* anche altrove (lez. 39/40: _"drawdown
**complessivo** con tutte le strategie ... non dovrebbe superare il 20%"_).

> ⚖️ **Verdetto aggiornato: l'ago si sposta su (b), ma la contraddizione
> parlato/slide e' REALE e resta APERTA.** `[?]`
>
> **Perche' pesa piu' di ogni altra cosa in questa spec:** e' un **fattore 7**
> sul rischio di portafoglio. Con (a) la strategia mette a rischio il 7% su
> un'unica direzione dello yen; con (b) l'1%. **Nessun backtest di paniere e'
> interpretabile senza aver deciso questo punto** — ed e' plausibile che il
> nostro `−20.853 €` sia stato prodotto in modalita' (a).
>
> 🎯 **Domanda diretta per Claudio** (§13 punto 7).

### 8.2 Il sizing dell'esempio non torna con un conto piccolo `[I]`

Il corso dichiara altrove (lez. 39) un capitale di simulazione di **5.000 EUR**.
Con 41 pip di stop su USDJPY, 1% di 5.000 EUR = 50 EUR → circa **0,12 lotti**,
non 0,41. **0,41 lotti** con 41 pip e 1% implica un conto di **~17.000 EUR**.
→ L'esempio della lez. 37 e la simulazione della lez. 39 usano **conti diversi**
(lez. 37 dice solo _"la montale del conto in questo caso"_ senza pronunciare la
cifra). Non e' una contraddizione della strategia, ma **il numero 0,41 non e'
trasportabile**: si ricalcola sempre dal proprio capitale.

---

## 9. 📉 NUMERI DI PERFORMANCE DICHIARATI DAL CORSO

> 🔴 **TUTTI** `[dichiarato dal corso, NON verificato da noi]`. Fonte: lez. 39,
> unica lezione con numeri di risultato. Nessun estratto conto, nessun report
> di piattaforma, nessun conteggio di operazioni: e' un **foglio di calcolo**
> mostrato a schermo e commentato a voce.

### 9.1 Quello che dichiara

| voce | valore | citazione |
|---|---|---|
| Periodo | _"ultimi due anni"_ | `[T]` |
| Universo | _"tutte le coppie con lo yen"_ | `[T]` |
| Capitale | **5.000 EUR** | `[T]` |
| **Rischio 1%** → profitto | **+133%** sul capitale iniziale | `[T]` _"il profitto ammonta al 133%"_ |
| **Rischio 1%** → DD | _"quasi un **4%** di drawdown **effettivo** e un **7%** di drawdown **atteso**"_ | `[T]` |
| **Rischio 3%** → capitale | **x8** | `[T]` _"il capitale appunto aumenta di 8 volte"_ |
| **Rischio 3%** → DD | _"**20%** come drawdown **atteso** e **11%** come drawdown **stimato**"_ | `[T]` |
| Confronto | la "mediazione" faceva _"intorno al 27-30%"_ | `[T]` |
| N. operazioni | **[BUCO]** — mai dichiarato | |
| Win rate | **[BUCO]** — mai dichiarato | |
| Broker / spread / slippage | **[BUCO]** | |
| Date esatte | **[BUCO]** | |

### 9.2 🧮 Cosa si scopre facendo l'aritmetica (analisi nostra)

**(a) I drawdown scalano LINEARMENTE col rischio.** Da 1% a 3% (fattore 3):
- 4% × 3 = **12%** ≈ l'11% dichiarato a rischio 3%
- 7% × 3 = **21%** ≈ il 20% dichiarato a rischio 3%

→ Due conseguenze:
1. **Le etichette a rischio 3% sono INVERTITE.** A 1% l'ordine e'
   "effettivo 4 / atteso 7"; a 3% dice "atteso 20 / stimato 11". Il numero
   piccolo resta il primo tipo, il grande il secondo. Il relatore **si e'
   scambiato i termini**. `[I]` da aritmetica.
2. **Non sono due simulazioni indipendenti: e' UNA lista di operazioni
   ri-scalata.** Un vero motore di compounding non produce DD perfettamente
   proporzionali al rischio. → **I due scenari (1% e 3%) sono UNA SOLA FONTE**,
   non due conferme.

**(b) I termini non sono mai definiti** `[BUCO]`: cosa distingue drawdown
"effettivo", "atteso" e "stimato" non e' spiegato in nessuna delle 7 lezioni.
Senza definizione, **quei tre numeri non sono confrontabili con i nostri**, che
sono max DD di equity da report MT5.

**(c) Il 4% di max DD a rischio 1% e' statisticamente difficile da credere.**
Con R:R 1:3, il win rate di pareggio e' 25%; per fare +133% in 2 anni serve un
win rate ben sopra, ma comunque **la maggioranza delle operazioni perde**. Un
max DD del 4% a 1% per trade significa **mai piu' di ~4 stop pieni consecutivi**
in due anni di operativita' su 7 cross. Su un campione di ordine 100+
operazioni con ~60% di esiti negativi, l'assenza di una serie di 5+ perdite e'
un evento di probabilita' trascurabile. **Attenuante onesta:** la regola del BE
a +1R converte molte perdite in **zeri**, il che comprime davvero il DD — ma non
fino a rendere il 4% plausibile. `[I]` — ragionamento probabilistico nostro, non
una misura.

**(d) Il "raddoppio" e il "+133%" convivono:** _"gia' con l'1% raggiunge il
raddoppio del capitale"_ e poi _"il profitto ammonta al 133%"_. +133% = 2,33x,
quindi "raddoppio" e' un arrotondamento verbale al ribasso, non una
contraddizione. ✅

### 9.3 🔥 LA CONTRADDIZIONE CHE CONTA: corso contro nostro backtest

| | **corso** (lez. 39) | **noi** (`docs/Portafoglio_Strategie.md`) |
|---|---|---|
| Universo | 7 cross JPY | 7 cross JPY (**identico**) |
| Timeframe | M15 | M15 (**identico**) |
| Rischio | 1% | 1% (**identico**) |
| Orizzonte | _"ultimi due anni"_ | 2022-2024 (**~identico**) |
| **Esito** | **+133%** su 5.000 EUR | **−20.853 EUR** aggregato |
| **PF** | non dichiarato (implicito > 1) | **0,67-0,95 su TUTTE e 7** |
| **Max DD** | _"quasi 4%"_ | **30-48% per coppia** |

> 🚨 **Stessa strategia, stesso universo, stesso timeframe, stesso rischio,
> orizzonte quasi coincidente, esiti di segno opposto e di ordine di grandezza
> incompatibile.** Non e' una sfumatura: e' un aut-aut.
>
> **Chi ha l'onere della prova:** noi abbiamo un artefatto riproducibile
> (backtest MT5, EA versionato, numeri per coppia). Il corso ha un foglio di
> calcolo mostrato a schermo, senza N operazioni, senza win rate, senza broker,
> senza date. **In assenza del PDF e della lista operazioni, la nostra
> misura pesa piu' della sua dichiarazione.**
>
> **MA** — e qui serve onesta' — la nostra misura **non ha un referto** (vedi
> `report/CONTRATTI_SEDIE.md`: della v3 _"non esiste alcun referto"_), e resta
> **una** possibilita' concreta: che il nostro EA implementi la strategia
> **infedelmente** e che il backtest abbia bocciato **la nostra
> implementazione**, non il corso. Le due divergenze candidate sono in §10.

---

## 10. 🔬 CONFRONTO COL CODICE IN CAMPO (`BREAKOUT_EA_JPY.mq5`)

Confronto fatto **dopo** aver ricostruito la spec dal solo parlato, per non
farsi guidare dal codice.

### 10.1 Dove il codice e' FEDELE (e sorprendentemente preciso)

| regola del corso | codice | esito |
|---|---|---|
| M15 | `PERIOD_M15` | ✅ |
| Williams 140 | `WilliamsPeriod = 140` | ✅ |
| Rettangolo 20 candele | `RectBars = 20` | ✅ |
| Estremi = high/low assoluti | `ArrayMaximum/ArrayMinimum` su High/Low | ✅ |
| **Candela di segnale ESCLUSA dal rettangolo** (§4.4) | `CopyHigh(..., 2, RectBars, ...)` — _"shift = 2 -> esclude la candela di segnale"_ | ✅ **risolve l'ambiguita' come noi** |
| Zone Williams −20 / −80, bande −50/−20 e −80/−50 (§5.4) | `W >= -20` / `W <= -80`, `IsSellSignal`: `W < -20 && W > -50` | ✅ **stessa lettura** |
| OB→solo SELL, OS→solo BUY | `trackZone == ZONE_OB` → `TryOpen(true)` | ✅ |
| Rottura con **chiusura** | `cl1 > rectHigh` / `cl1 < rectLow` su `iClose(...,1)` | ✅ |
| SL a 1 pip oltre il rettangolo | `sl = rectHigh + pip` | ✅ |
| **R misurato dalla CHIUSURA DEL SEGNALE** | `stopDist = MathAbs(cl1 - sl)` | ✅ |
| TP = 3R dalla chiusura del segnale | `tp = cl1 - stopDist * 3.0` | ✅ |
| **BE sulla chiusura del segnale, NON sul fill** (§7.1) | `nSL = sigClose`, commento _"il BE NON usa il prezzo di fill reale"_ | ✅ **il dettaglio piu' sottile del corso, implementato giusto** |
| Trigger BE a +1R dal segnale | `bid <= sigClose - trig` | ✅ |
| Niente trailing dopo il BE (§7.2) | _"Nessun trailing: dopo il BE la posizione si tiene fino al 3R"_ | ✅ |
| R:R minimo 1:2 su ingressi ritardati | `MinRR = 2.0`, `CalcRR` dal prezzo di mercato | ✅ |
| Rischio 1% | `RiskPercent = 1.0` | ✅ |
| Ordini a mercato | `trade.Sell/Buy` | ✅ |
| Chiusura su segnale contrario | `CloseOnOppositeSignal` | ✅ (flag) |

**Giudizio: l'EA e' un'implementazione notevolmente fedele del corso.** Non e'
un EA "ispirato": segue anche le regole controintuitive.

### 10.2 🔴 Le DUE divergenze trovate

**(1) Manca il vincolo delle 20 candele dall'ingresso in zona (§4.5).**
Il codice attiva `trackZone` appena `W >= -20` e da quel momento accetta il
segnale, ma `UpdateRectangle()` prende **sempre le ultime 20 candele chiuse**,
senza verificare che siano trascorse 20 candele dall'ingresso in zona. Non
esiste in tutto il file una variabile che conti le barre dall'ingresso in zona.

→ **Conseguenza:** l'EA puo' aprire un segnale poche candele dopo l'ingresso in
ipercomprato, su un rettangolo fatto in gran parte di candele **antecedenti** la
fase che il corso vuole misurare. Il corso lo vieta a chiare lettere:
_"prima di quel tempo noi non riusciremo ad avere nessun setup di breakout"_.
**Questa e' la divergenza piu' seria e la piu' facile da correggere** (un
contatore di barre). Effetto atteso: **meno segnali, piu' selettivi.**

**(2) Il SuperTrend usa parametri che NON vengono dal corso (§3.3).**
Il codice ha `ATRPeriod = 10`, `ATRMultiplier = 3.0`. **Nelle lezioni 34-40
questi due numeri non esistono.** Vengono dal modulo precedente del corso (non
trascritto) oppure sono una scelta nostra. **Finche' non si verifica, sono
parametri NOSTRI**, e un backtest negativo puo' dipendere da loro.

### 10.3 ⚠️ Punti non verificabili sul codice letto

- Il file in campo si chiama **`BREAKOUT_EA_JPY_v3`**, ma **nel repo esistono
  solo** `BREAKOUT_EA_JPY.mq5` e `BREAKOUT_EA_JPY_Multi.mq5`. **Il sorgente
  della v3 non e' nel repo** → il confronto qui sopra e' fatto sulla v1, e
  **non e' detto che descriva cio' che gira sul conto piccolo.**
- Gestione multi-posizione e cap di portafoglio (§8.1): non verificata in questa
  analisi.

---

## 11. 🧾 RIEPILOGO PER IL DEVELOPER: certo / ambiguo / buco

> 🆕 **CONTEGGIO AGGIORNATO DOPO LE SLIDE (18/08 ~15:15).**
> Era: **24 certe / 10 ambigue / 13 buchi → 71%**.
> Ora: **26 certe / 4 ambigue / 11 buchi → 87%**.
> Cosa e' cambiato: **+2 regole certe** (cadenza di aggiornamento del
> rettangolo, triade delle uscite resa obbligatoria), **−6 ambiguita'**
> (chiuse dalla fonte scritta, §0.3), **−2 buchi** (il PDF non e' piu' un buco
> perche' ce l'abbiamo; le soglie del Williams sono ora scritte),
> **−1 regola discrezionale** (§0.5: non e' nel PDF, quindi non e' strategia).

### ✅ 26 REGOLE CERTE (implementabili senza inventare)
M15 · 7 cross JPY · Williams %R periodo 140 · zone OB≥−20 / OS≤−80 · rettangolo
di 20 candele · estremi assoluti high/low · rettangolo mobile · candela di
segnale esclusa · OB⇒solo SELL / OS⇒solo BUY · rottura con **chiusura** oltre il
livello · SuperTrend in direzione · Williams in [−50,−20] sell / [−80,−50] buy ·
le 3 condizioni simultanee sulla candela di segnale · ordine di arrivo
irrilevante · ingresso teorico = chiusura del segnale · SL a 1 pip oltre il
rettangolo · R = |chiusura segnale − SL| · TP = 3R dalla chiusura del segnale ·
BE a +1R misurato dal segnale · BE posto sulla **chiusura del segnale** ·
nessun trailing dopo il BE · rischio 1% · R:R minimo 1:2 per ingressi ritardati ·
ordini a mercato · 🆕 **rettangolo ricalcolato a ogni chiusura di candela**
`[SLIDE S4]` · 🆕 **chiusura obbligatoria su SL / TP / segnale contrario**
`[SLIDE S8]`.

### ⚠️ 4 AMBIGUITA' RESIDUE (erano 10)

✅ **Chiuse dalle slide:** 15vs20 · "almeno/al massimo" · banda SELL 0/−50 ·
"ancora dentro/uscito" · trailing vs BE · XAU dentro/fuori → dettaglio in §0.3.

Restano:
1. **candela di rottura dentro/fuori** → risolta per **necessita' logica**
   (fuori), ma **nessuna slide lo scrive**: resta una nostra deduzione.
2. 🔴 **APERTA — obbligo delle 20 candele dall'ingresso in zona** (§4.5):
   implicata dalle slide, mai scritta come regola; e un esempio della lez. 38
   sembra disattenderla.
3. 🔴 **APERTA E PESANTE — "rischio 1% per operazione" (parlato) vs "rischio
   COMPLESSIVO dell'1%" (slide S10)** (§8.1): **e' un fattore 7** sul rischio di
   portafoglio.
4. direzione del fuso della piattaforma → **irrilevante** (nessun filtro orario).

🚫 **Non piu' in elenco:** la gestione "Williams all'estremo opposto" (§7.4).
**Non e' nel PDF** → non e' una regola della strategia (§0.5).

### 🕳️ 11 BUCHI (erano 13)
1. 🔴 **Parametri SuperTrend (ATR + moltiplicatore) — BLOCCANTE.**
   🆕 **E ora sappiamo che il PDF NON li contiene:** possono venire solo dal
   modulo precedente.
2. 🔴 **Periodo del Williams %R** — nessuna slide lo scrive: il "140" resta
   appeso a una sola frase del parlato (§3.2).
3. Massimo di posizioni contemporanee sui 7 cross *(parzialmente illuminato da
   "rischio complessivo 1%", ma non risolto)*
4. Correlazione fra i 7 cross JPY: **mai menzionata, nemmeno nelle slide**
5. Filtro spread
6. Filtro news (**anzi**: l'esempio della lez. 37 entra su una notizia macro)
7. Cap di perdita giornaliera
8. Cosa fare se arriva un nuovo segnale con posizione gia' aperta sullo stesso cross
9. Scadenza del setup se il Williams esce dalla zona senza rottura
10. Definizione di pip su JPY
11. Gap/slippage oltre lo stop + N. operazioni, win rate, broker, date del
    backtest dichiarato *(la lez. 39 non ha slide fra quelle ricevute)*

✅ **Chiusi dalle slide:** il PDF non e' piu' un buco (ce l'abbiamo) · le soglie
operative del Williams sono ora **scritte** (−20/−50 e −80/−50).

### 📐 GRADO DI MECCANIZZABILITA' — **87%** (era 71%)
Decisioni che un EA deve prendere per operare = **26 certe + 4 ambigue = 30**.
→ **26/30 ≈ 87%** deciso dal corso **senza alcuna interpretazione nostra**.

Aggiungendo le 2 ambiguita' che considero risolte con argomento solido
(candela di rottura esclusa; fuso irrilevante), il **coperto** sale a
**28/30 ≈ 93%**.

**Restano fuori solo 2 cose, ed entrambe sono DOMANDE, non scelte tecniche:**
- l'attesa delle 20 candele (§4.5) — cambia **quanti** segnali esistono;
- il rischio 1% per operazione **o** complessivo (§8.1) — cambia il rischio di
  portafoglio **di 7 volte**.

> **Traduzione secca, aggiornata:** la strategia **e' meccanizzabile quasi
> integralmente**, e le slide hanno **eliminato la discrezionalita'** che
> temevo (§0.5). **Ma resta un buco bloccante che il PDF non chiude**: i
> parametri del SuperTrend. Finche' quelli sono nostri, **qualunque backtest
> misura la NOSTRA versione**, non quella del corso — e va detto accanto al
> numero.

---

## 12. 🏛️ NOTE PROP (non richieste dal corso, rilevanti per noi)

Il corso e' pensato per un conto personale e **non nomina mai** una prop. Tre
punti di attrito con `report/METRO_PROP.md`:

1. **News.** L'esempio-principe della lez. 37 e' un ingresso **su rilascio
   macro** (_"un salto collegato allo sviluppo di alcuni, alla pubblicazione di
   alcune notizie macroeconomiche"_). METRO_PROP §7 registra che diverse prop
   **limitano il news trading**. La strategia, come insegnata, **non ha filtro
   news** e nel suo esempio migliore fa esattamente cio' che alcune prop
   vietano.
2. **Rischio simultaneo.** Se "un ordine per volta" e' per cross (§8.1), 7
   posizioni all'1% su 7 coppie che condividono lo yen = fino al **7% a
   rischio su un'unica direzione**. Contro un daily loss del 5%, e' una
   violazione a portata di una singola giornata di yen.
3. **Nessun cap giornaliero.** Il corso ha un solo tetto, il **20% di drawdown
   complessivo** — una misura di portafoglio personale, non una regola prop.

---

## 13. ❓ DOMANDE APERTE PER CLAUDIO

> 🆕 **Aggiornate dopo le slide.** ✅ **La domanda n.1 (il PDF) e' STATA
> EVASA** — e ha chiuso 6 ambiguita' su 10. **Ma non ha chiuso i due buchi
> bloccanti**, perche' il PDF non tratta i parametri degli indicatori.

1. ✅ ~~Il PDF della lezione 40~~ — **RICEVUTO 18/08 ~15:15**, 10 slide.
2. 🔴 **IL MODULO PRECEDENTE — ora e' la richiesta n.1.** E' quello che imposta
   Williams+SuperTrend (lez. 35: _"Lo abbiamo fatto nel modulo precedente"_).
   **Le slide hanno dimostrato che il PDF del modulo Breakout NON contiene i
   parametri degli indicatori**, quindi non esiste altra fonte: serve la
   trascrizione di quel modulo **o** uno screenshot dei due pannelli
   (SuperTrend: ATR + moltiplicatore · Williams: periodo).
3. 🟠 **Williams: 140 o 14?** Screenshot del pannello dell'indicatore. Se fosse
   14, tutta la frequenza dei segnali cambia e il backtest negativo va rifatto.
4. 🟠 **Il sorgente di `BREAKOUT_EA_JPY_v3`**: non e' nel repo. Cosa gira
   davvero sul conto piccolo?
5. 🟡 **Il foglio di calcolo della lez. 39**: mostrato a schermo, mai dettato.
   Servono N operazioni, win rate, date e broker — senza, i suoi numeri non
   sono confrontabili coi nostri.
6. 🟡 **Vincolo delle 20 candele dall'ingresso in zona** (§4.5): interpretazione
   stretta (come dice la lez. 36) o larga (come sembra l'esempio della lez. 38)?
   E' la prima cosa da provare in A/B: cambia il numero di segnali.
7. 🟡 **"Un ordine per volta"** (§8.1): per cross o per portafoglio?

---

## 14. 🖼️ COSA ERA A SCHERMO E NON NEL PARLATO

Elenco dei momenti in cui il corso **mostra** invece di **dettare** — servono
screenshot, non trascrizioni:

| lezione | cosa non e' stato dettato |
|---|---|
| 35 | pannello parametri del SuperTrend; template "Williams e Supertrend"; sito del calcolatore di posizione |
| 36 | soglie grafiche dell'ipercomprato/ipervenduto sul Williams; lo strumento che conta le candele |
| 37 | il **capitale** inserito nel calcolatore (_"la montale del conto in questo caso"_ — la cifra non viene pronunciata) |
| 38 | i grafici dei tre esempi (1 maggio, 3 maggio, terzo segnale): date complete e coppia non sempre dichiarate |
| **39** | **l'INTERO foglio di calcolo**: N operazioni, win rate, curva, date, broker. E' la lezione con i numeri, ed e' quella piu' cieca |
| 40 | **le slide del PDF**: il parlato le commenta ma non le legge integralmente |
