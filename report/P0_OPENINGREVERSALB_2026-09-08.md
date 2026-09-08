# 🔬 PASSO 0 di `ABTG_OpeningReversalB` — **il motore funziona, ma non spara quasi mai**

Primo round della storia del progetto girato **sul VPS**, su macchina verificata.
08/09/2026, ore **18:21**. `rc=0`, **RILIEVI: 0**, PID degli altri terminali intatti.

---

## 📊 IL NUMERO

| finestra | durata | **Trades** | Profit | PF | DD % |
|---|---|---:|---:|---:|---:|
| **IS** (dentro campione) | 256 gg (~8,4 mesi) | **2** | 57,28 | 1,82619 | 0,9588 |
| **OOS** (fuori campione) | 386 gg (~12,7 mesi) | **0** | 0 | 0 | 0 |

E i gemelli tecnici coincidono su entrambe le finestre → **cancello G1
(determinismo) passato**.

## ⚖️ COSA DICE, E COSA NON DICE

### ✅ Il motore GIRA. Questo è misurato, non dedotto.
L'EA ha **compilato** (per la prima volta in assoluto), è partito, ha letto lo
storico e **ha piazzato due operazioni**. 👉 Quindi lo zero dell'OOS **NON è il
solito "non è girata"**: la parte IS lo esclude. È uno **zero vero**.

> ### 🎯 È la distinzione che rende utile questa cella.
> La regola di casa dice *"Trades=0 vuol dire NON E' GIRATA"* — ed è giusta come
> difesa. Ma qui abbiamo la **controprova dalla stessa corsa**: la macchina
> funziona, il motore semplicemente **non trova occasioni**.

### 🔴 Il verdetto, contro i criteri congelati PRIMA del round
- **Attesa dichiarata**: *"poche decine di operazioni, non centinaia"*.
  **Uscite: 2.** Sbagliata anche la mia previsione bassa, di un ordine di grandezza.
- **Frequenza misurata: 0,0078 operazioni/giorno.** Il pavimento di casa è
  **1,00 op/giorno per famiglia**: siamo **128 volte sotto**. Nemmeno schierando
  Dow, Nasdaq e DAX insieme ci si avvicina.
- **Merito: SOSPESO** (n=2, la soglia è 150). PF 1,83 su due operazioni non è
  un indizio: è rumore.
- **Rischio: DD 0,96%** — leggibile a qualunque n, ed è un buon numero. Ma su
  due trade dice poco anche quello.
- **I tre score "devono mordere"**: con n=2 quel test **non è nemmeno
  eseguibile**.

## 🚫 VERDETTO: **NON si fa la griglia.**
Sarebbero ore di macchina per ottimizzare un motore che, nella sua
configurazione congelata, **non opera**. Il passo 0 è servito esattamente a
questo: **ha salvato un round intero**, al costo di quattro passate.

---

## 🧭 E ADESSO? Tre strade, e vanno dichiarate PRIMA di guardarle

Il motore ha **tre cancelli di conferma in serie** (`fail>=3`, `signal>=4`,
`FT>=60%`). Due operazioni in 21 mesi dicono che **sono troppo stretti per
questo mercato**, non che l'idea sia sbagliata.

1. 🟢 **Passo 0-bis: allentare le soglie, in modo ORDINATO.**
   `fail 3->2`, `signal 4->3`, `FT 60->50`. **Non è ritoccare finché non
   funziona**: è la stessa prova prevista dalla SPEC (*"i tre score devono
   mordere"*), fatta al contrario. Se allentando i trade salgono **poco e in
   modo ordinato** → il motore è solo raro. Se esplodono → i cancelli erano
   l'unica cosa che teneva in piedi la curva, e **si scarta**.
   🔴 **Va congelato PRIMA**: soglie, attesa e criterio di scarto scritti nel
   file prova, come sempre.
2. 🟡 **Cambiare finestra**: la SPEC prevede la **fascia pomeridiana** (ultime 2
   ore) senza toccare il codice — gli orari sono input. Costa una corsa.
3. 🔴 **Chiuderlo e passare oltre**: abbiamo **7 motori nuovi** promossi oggi e
   **7 ripescati**. A 23 giorni dalla challenge, un motore che fa 2 operazioni
   in 21 mesi **non è il collo di bottiglia da sbloccare**.

👉 **La mia raccomandazione: la 1, UNA sola corsa.** Costa quanto questa
(quattro passate) e chiude la domanda in modo definitivo. Se dopo l'allentamento
i numeri restano miseri, si archivia con un verdetto pulito invece che con un
"chissà".

---

## 🏭 E LA NOTIZIA GRANDE NON È IL MOTORE
**La catena ha funzionato dall'inizio alla fine, sul VPS, senza il PC di
Claudio:** download dal pin, marcatore verificato, chiusura chirurgica,
compilazione, quattro passate a tick reali, CSV, referto leggibile, zip sul
Desktop. **Zero rilievi. Il conto reale mai sfiorato.**

Stamattina questa macchina non esisteva.

---

# 🔬 PASSO 0-BIS **A** — `InpFailScoreMin` 3 → 2 → 1: **NON CAMBIA NIENTE**

Girato sul VPS, 08/09 ore **18:47**. `rc=0`, zero rilievi, PID intatti.

| Pass | `InpFailScoreMin` | Trades IS | Profit | PF | DD % |
|---|---:|---:|---:|---:|---:|
| 0 | **1** | **2** | 57,28 | 1,82619 | 0,9588 |
| 1 | **2** | **2** | 57,28 | 1,82619 | 0,9588 |
| 2 | **3** | **2** | 57,28 | 1,82619 | 0,9588 |
| — | *(OOS, tutte)* | **0** | 0 | 0 | 0 |

## ✅ E il primo controllo era: **il parametro è arrivato davvero all'EA?**
Sì, verificato **nel CSV**, colonna per colonna: `InpFailScoreMin` vale **1, 2, 3**
sulle tre righe. Le altre due soglie restano a 4 e 60, come previsto.

> ### 🎯 Quindi non è "l'asse non è passato". **Il parametro è stato applicato e non ha spostato NIENTE** — nemmeno di un'operazione, nemmeno alla quinta cifra.

## 📖 IL VERDETTO, contro il criterio congelato PRIMA
> *"1. Il conteggio NON si muove (resta sotto 5 in IS) → questo cancello NON è
> il collo di bottiglia. Si passa al file successivo."*

**Criterio 1, applicato alla lettera:** `InpFailScoreMin` è **INERTE** in questo
intervallo. In ogni situazione candidata la failure-evidence era già ≥3, oppure
**uno degli altri due cancelli aveva già ucciso il candidato prima**.

👉 Il collo di bottiglia è **altrove**: `InpSignalScoreMin` (file B) o
`InpFollowThroughPct` (file C).

## 💡 E c'è un pezzo di risposta gratis alla domanda della SPEC madre
La SPEC chiedeva: *"se il PF è piatto rispetto alle soglie, lo scoring è
decorativo → scarto"*. **Su questo asse il PF è piatto come un tavolo.** Non
basta per il verdetto — gli altri due assi non sono ancora stati misurati — ma è
**un terzo della risposta, già in cassa**, e va agli atti così.
