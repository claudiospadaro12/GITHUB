# Analisi Backtest DAX — Expert Advisor "DAX_MASTER_PROP" (v1)

> File EA di riferimento: `/home/user/GITHUB/mql5/Experts/DAX_MASTER_PROP.mq5`
> Documento di analisi e pianificazione. Versione: v1 — Data: 2026-06-19

---

## 1. Premessa metodologica (LEGGERE PRIMA DI TUTTO)

Questa premessa è la parte più importante del documento. Tutto ciò che segue va interpretato alla luce di questi limiti.

- **Backtest disponibile SOLO in-sample (2023-2024)**, simbolo DE40 su timeframe M15, deposito iniziale 10.000 €, broker Tickmill (conto demo).
- **Il backtest è stato girato con 0% tick reali (dati modellati).** I risultati **NON sono affidabili al 100%**. La prima cosa da fare, prima di qualsiasi altra valutazione, è **rifare il backtest con tick reali** (dati Dukascopy, modello "Every tick based on real ticks") e con un periodo **out-of-sample** distinto.
- **Le migliorie introdotte sono STRUTTURALI e difendibili logicamente, NON sono curve-fitting.** Sono state pensate per correggere problemi di robustezza, non per ottimizzare i numeri di un singolo backtest.
- Tutte le migliorie sono **input TOGGLEABLE** con **default = comportamento attuale preservato**. L'unica eccezione è il **bugfix del contatore SL consecutivi**, che è una correzione di sicurezza e non un'opzione cosmetica.
- **Nessun risultato di backtest delle nuove migliorie viene dichiarato in questo documento.** Le migliorie sono ipotesi da validare; finché non superano i test descritti al paragrafo 6, non hanno alcun valore probatorio.

---

## 2. Risultati del backtest in-sample (riepilogo)

> Periodo: 2023-2024 · DE40 M15 · deposito 10.000 € · Tickmill demo · **0% tick reali (dati modellati)**.

| Metrica | Valore | Note |
|---|---|---|
| Profitto netto | **+636 €** | +6,4% in 2 anni |
| Profit Factor | **1.51** | |
| Equity Drawdown massimo | **5,45%** | sotto il kill-switch del 6% |
| Win rate | **65%** | 45 win / 24 loss |
| Numero di trade | **69** in 2 anni | campione piccolo |
| Recovery Factor | **1.09** | basso |
| Payoff (avg win / avg loss) | **negativo (R:R < 1)** | avg win 41,85 € < avg loss 51,95 € |
| Avg win | 41,85 € | |
| Avg loss | 51,95 € | |
| Max perdite consecutive | **5** | per un totale di −263 € |

### Asimmetria direzionale

| Direzione | Numero trade | Win rate | Giudizio |
|---|---|---|---|
| SHORT | 35 | **77,1%** | forte |
| LONG | 34 | **52,9%** | debole |

L'asimmetria tra LONG e SHORT è evidente, ma va trattata con cautela (vedi paragrafo 3.3): potrebbe riflettere il regime di mercato 2023-2024 più che un vantaggio strutturale.

---

## 3. I 4 problemi individuati

### 3.1 PAYOFF < 1 — il problema più serio

**Descrizione.** L'avg loss (51,95 €) è maggiore dell'avg win (41,85 €): il rapporto rischio/rendimento medio per trade è strutturalmente inferiore a 1.

**Causa.** Il take profit è **fisso** (`FinalTP` ~50 punti, parziale ~45 punti), mentre lo stop loss è **tecnico e variabile** (fino a ~100 punti). Questo rende il R:R incoerente da trade a trade.

**Evidenza dai singoli trade.** **Tutte le 24 perdite** sono uscite per Stop Loss con perdita compresa in un intervallo molto stretto (~−48..−54 €). Questo cluster molto stretto indica che, nella maggioranza dei casi, la distanza reale dello SL è stata intorno ai ~50 punti. I vincenti, invece, vengono tagliati al TP fisso/parziale.

**Perché è un problema di robustezza.** Un payoff < 1 significa che la strategia dipende interamente da un win rate alto per restare in profitto. Basta un piccolo calo del win rate (molto probabile passando a tick reali e out-of-sample) per portare il sistema in perdita. È una fragilità intrinseca, non un dettaglio.

### 3.2 CONTATORE SL CONSECUTIVI non protettivo

**Descrizione.** Nel codice attuale (funzione `UpdateConsecutiveSLCounter`) il contatore si azzera su **qualsiasi** deal di uscita con `profit > 0`, **incluso un parziale in profitto**.

**Conseguenza 1 (azzeramento errato).** Una posizione che incassa il parziale a +45 (deal con commento "None", positivo) e poi viene stoppata in **perdita netta** azzera comunque il contatore. Il risultato è una **sottostima della streak** di perdite.

**Conseguenza 2 (scope DAILY).** Con scope giornaliero, l'halt si resetta ogni giorno. Ma la strategia esegue ~2 trade/giorno: una serie di SL può quindi **attraversare più giorni** senza che l'halt giornaliero la fermi mai.

**Effetto combinato.** I due effetti insieme spiegano come si possano osservare **5 perdite consecutive nonostante il limite sia impostato a 3**.

**Dati di supporto.** 24 uscite negative tutte da Stop Loss; 14 uscite positive con commento vuoto = parziali/trailing in profitto.

**Perché è un problema di robustezza.** Una protezione anti-streak che non conta correttamente le streak è una protezione che non protegge: il sistema può subire run di perdite ben oltre la soglia che l'operatore crede di aver impostato.

### 3.3 ASIMMETRIA LONG/SHORT

**Descrizione.** LONG debole (52,9%) contro SHORT forte (77,1%).

**Cosa NON fare.** **Non** forzare la strategia a operare solo short. Sarebbe un **overfit** al regime rialzista del 2023-2024: nulla garantisce che lo short mantenga il vantaggio in un altro regime di mercato.

**Cosa fare.** Predisporre la possibilità di testare in **A/B** le tre varianti (entrambe le direzioni, solo long, solo short) per capire se l'asimmetria regge anche out-of-sample o se è dipendente dal regime.

**Perché è un problema di robustezza.** Decidere la direzione operativa su un solo periodo in-sample è uno dei modi più classici di costruire un sistema che funziona solo sul passato.

### 3.4 POCHI TRADE (69 in 2 anni)

**Descrizione.** 69 trade in 2 anni sono un campione statisticamente piccolo.

**Perché è un problema di robustezza.** Con così pochi campioni, ogni metrica (win rate, profit factor, payoff) ha un'incertezza ampia: la differenza tra un buon sistema e un caso fortunato è difficile da distinguere.

**Cosa NON fare.** Non allentare i filtri a caso pur di aumentare il numero di trade: si rischia di degradare la qualità delle entrate. Le leve sulla frequenza (paragrafo 5) vanno trattate come ipotesi da testare, non come correzioni da applicare in blocco.

---

## 4. Migliorie introdotte nel codice (con razionale)

Tutte le migliorie sono **toggleable** con **default = comportamento attuale**, eccetto il bugfix di sicurezza (C).

### A) Take Profit a R-multiplo (anti payoff < 1)

- **Nuovi input:** `InpUseRMultipleTP` (default **false**), `InpTP_R_Multiple` (es. 1.8), `InpPartial_R_Multiple`.
- **Comportamento (ON):** il TP finale e la soglia del parziale vengono calcolati come **R × distanza SL effettiva del trade**, invece che in punti fissi.
- **Razionale:** rende il R:R **coerente con il rischio reale di ogni singolo trade**, così i vincenti possono coprire i perdenti. È la risposta diretta al problema 3.1.
- **Default OFF** = comportamento attuale (TP fisso in punti) preservato, per consentire l'A/B test.

### B) Trailing / Break-Even legato a R (toggleable)

- **Nuovi input:** `InpUseRBasedActivation` (default **false**), `InpBreakEven_R`, `InpTrailingActivation_R`.
- **Comportamento (ON):** l'attivazione del break-even e del trailing è legata a **multipli di R della distanza SL effettiva** invece che a punti fissi.
- **Razionale:** protegge i profitti in modo **proporzionale al rischio**, senza tagliare troppo presto sui trade ampi né troppo tardi sui trade stretti.
- **Default OFF** = punti fissi attuali.

### C) Bugfix contatore SL consecutivi (correzione di sicurezza)

- **Nuovo input:** `InpSLCounterMode` con valori `{ NET_LOSS_PER_POSITION, ANY_NEGATIVE_DEAL, SL_REASON_ONLY }`.
- **Natura:** **non** è un toggle cosmetico sul comportamento di default — è una **correzione di sicurezza**. L'input serve solo a scegliere il *criterio* di conteggio.
- **Il fix:** il contatore ora valuta la **perdita NETTA PER POSIZIONE** (somma di tutti i deal di uscita della stessa posizione). Così un parziale positivo seguito da uno stop in perdita netta conta correttamente come **1 perdita** e **NON azzera la streak**.
- **Cross-day:** la variabile `g_consecutiveSL` e lo scope `CROSSDAY` consentono di gestire le streak che attraversano più giorni. Per una protezione più severa si raccomanda di usare lo **scope CROSSDAY** invece di quello DAILY.
- Risolve i due problemi descritti in 3.2.

### D) Gate direzionale globale

- **Nuovo input:** `InpDirectionMode` con valori `{ BOTH, LONG_ONLY, SHORT_ONLY }`, default **BOTH**.
- **Comportamento:** gate direzionale globale per l'A/B test dell'asimmetria (problema 3.3).
- **Default BOTH** = comportamento attuale. Permette di testare in modo controllato se l'asimmetria LONG/SHORT regge out-of-sample, senza forzare una scelta di direzione.

---

## 5. Leve per aumentare la frequenza (ipotesi da A/B, restano OFF di default)

Le seguenti leve sono **ipotesi**, non correzioni. Restano disattivate di default.

- Attivare `InpTradeAfternoon` (input già presente nell'EA).
- Riattivare il **lunedì** (`InpTradeMonday`) e/o il **venerdì** (`InpTradeFriday`) come test.
- Allargare **leggermente** la finestra mattutina.

> **Avvertenza:** queste leve **non vanno forzate**. Sono ipotesi da testare **una alla volta**, su periodo **out-of-sample** e con **tick reali**. Aumentare la frequenza senza verifica rischia solo di peggiorare la qualità delle entrate (vedi problema 3.4).

---

## 6. Piano di test A/B

### Passo 0 — OBBLIGATORIO: baseline affidabile

Rifare il backtest **BASE** (tutti i default attuali) con **TICK REALI** (Dukascopy, modello "Every tick based on real ticks"):

1. su in-sample 2023-2024, per avere un baseline affidabile;
2. poi su **out-of-sample** (es. 2021-2022 e/o 2025).

Senza questo passo, nessun confronto successivo ha valore.

### Test successivi — un toggle alla volta

Attivare **UN solo toggle per run** (mai più di uno) e confrontare sempre col baseline:

| Test | Configurazione |
|---|---|
| Test 1 | `InpUseRMultipleTP = true` con `InpTP_R_Multiple` ~1.5-2.0 |
| Test 2 | `InpUseRBasedActivation = true` |
| Test 3 | `InpDirectionMode = SHORT_ONLY`, poi `LONG_ONLY` (verifica se l'asimmetria regge out-of-sample o è regime-dependent) |
| Test 4 | leve di frequenza (afternoon, lunedì/venerdì) una alla volta |

### Criteri di accettazione di una miglioria

Una miglioria è accettabile **solo se supera questi criteri su OUT-OF-SAMPLE con tick reali**:

| Criterio | Soglia |
|---|---|
| Equity Drawdown massimo | **< 6%** |
| Profit Factor | **> 1.5** |
| Payoff (avg win / avg loss) | **>= 1** |
| Recovery Factor | **> 2** |
| Numero di trade | **> 150** nel campione |

> Una miglioria si tiene **SOLO** se migliora il baseline su out-of-sample **senza degradare il DD** e se ha **senso logico**, non solo numerico.

---

## 7. Avvertenza finale

I numeri in-sample ottenuti con 0% tick reali **NON costituiscono una validazione**. La **priorità assoluta** è rifare tutti i test con **tick reali** e su **out-of-sample** prima di qualsiasi uso in demo o in live. Finché questo non è fatto, ogni metrica riportata in questo documento va considerata indicativa e potenzialmente non rappresentativa del comportamento reale dell'EA.
