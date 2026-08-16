# 📋 BILANCIO DEL 16/08 — cosa e' entrato, cosa va cambiato negli EA

_Scritto rispondendo a Claudio: **"fammi un riassunto delle modifiche che
dovremmo fare ai nostri EA, se c'e' qualcuno che entra in squadra... perche'
mi sembra strano che non abbiamo trovato nulla."**_

> ## 🎯 LA RISPOSTA SECCA
> **Non e' vero che non abbiamo trovato nulla. E' vero che NIENTE E' ANCORA
> IN PIEDI** — e la differenza sta in un passo solo: **nessuno dei tre EA
> nuovi e' stato compilato in MetaEditor.** Finche' non passa quell'F7,
> tutto quello che c'e' sotto e' materiale fermo in cantiere.

---

## 1. 🆕 CHI ENTRA IN SQUADRA — 3 EA scritti, 6 in coda

### Adottati oggi (codice nel repo, magic vergini, NON compilati)

| EA | origine | magic | stato |
|---|---|---|---|
| `ABTG_TurnaroundTuesday` | 001 Turnaround Tuesday, Code Base 73674 | **774201** | 918 righe · `OnTester` ✅ · 3 difetti corretti |
| `ABTG_CanaleLento` | Simple Yet Effective Breakout, 49272 | **774301** | 838 righe · `OnTester` ✅ · 8 correzioni |
| `ABTG_GapContinuation` | Nikkei 225 Gap Continuation, 75301 | **774101** | 1.531 righe · `OnTester` ✅ · `@DAQUANDO` misurato |

**Il piu' forte e' `TurnaroundTuesday`**: promosso **due volte da due cacce
indipendenti** che partivano da buchi diversi (9/10 sul laterale, 10/10
sullo short simmetrico). La direzione e' costitutiva — `tradeUp = !isBullish`,
nessun `AllowLong`/`AllowShort` nel file — ed e' la forma che nei nostri dati
vale il massimo.

### In coda, con dossier e scheda gia' scritti

| candidato | fonte | voto | cosa gli manca |
|---|---|---|---|
| **Pivot Supertrend** | 75110 | **9/10** | l'EA va scritto (file prova gia' pronto), 3-4 h |
| Flip sul wick | 57063 (MIT) | 8/10 | EA da scrivere, 1-2 h |
| Trailing Chandelier | 19875 | 8/10 | EA da scrivere, 2-3 h |
| ADX Trend Pullback | 73958 | 8/10 | lotto fisso, niente `OnTester`, nessun filtro sessione |
| Dominance EA | — | 7/10 | lotto `_VolumeMin` cablato: sizing da rifare |
| KSQ FVG EA | 71467 | in coda | 53 input, 3 posizioni simultanee (rischio prop) |

---

## 2. 🔧 LE MODIFICHE AI NOSTRI EA — sei, e due sono a costo zero

### A. 🔴 `ABTG_PTE` — stop e target sono DISACCOPPIATI
`ABTG_PTE.mq5:329-330` calcola lo stop, `:338` calcola il target, **e non si
parlano**. Nel default scalano entrambi con l'ATR, quindi **il rapporto R
regge per caso, non per costruzione**; con `InpSLfromDoji=true` il target non
e' piu' espresso in R affatto.
Leung & Li (arXiv:1411.5062) provano su processo OU che il target ottimo e'
**funzione monotona dello stop**.
> ✅ **Costo zero: le tre leve esistono gia' come input.** 32 celle, nessuna
> riga di codice. File prova pronto: `prove/PTE_ACCOPPIAMENTO_TP_SL.txt`.
> E' la modifica col miglior rapporto valore/costo di tutta la giornata.

### B. 🔴 `ABTG_SupertrendReversal` — non sappiamo che ATR usa
`:121` chiama `iATR` e **lo smoothing non e' dichiarato da nessuna parte**.
Se e' Wilder, la memoria effettiva e' ~`2N−1`: `InpStAtrPeriod=10` sarebbe
una finestra da **~19 barre**, non 10.
> Finche' non e' sciolto, **"Supertrend 10/3.5" non e' confrontabile con
> nessun riferimento esterno**, e nemmeno con le varianti che vorremmo
> provare. **Controllo da mezz'ora, e va fatto PRIMA di qualunque variante.**

### C. 🟡 `ABTG_SupertrendReversal` — 52 input contro un tetto di ~15
Contati col `grep`. E' **il motore piu' diffuso dell'arsenale** (Oro, DAX,
Nasdaq, Dow, CAC, Nikkei) ed e' anche il piu' pieno di manopole. La
sfrondatura non e' mai stata fatta.

### D. 🐛 IL BLOCCO `OPTFRAME` — riguarda TUTTI e 39 gli EA testabili
Le due colonne prop escono **uguali**: `Perdite Consecutive Max: -3005` e
`Serie Perdente Peggiore: -3004.67`, cioe' **entrambe in denaro**.
> **La colonna che dovrebbe dire QUANTE perdite di fila non contiene un
> conteggio.** Per una prop e' una domanda vera, e oggi **non abbiamo quel
> dato su nessun EA**. Da verificare quale costante MT5 dia il numero e
> correggere nel blocco, che e' inlinato ovunque.

### E. 🔴 `ABTG_GapContinuation` — si autozittisce in forward
`HasAnyPositionOnSymbol()` **non filtra per magic**: in forward, una
posizione aperta di `ABTG_SupertrendReversal` su 225JPY **spegne del tutto
questo EA**. Invisibile nel backtest; in forward si manifesta come "non fa
niente", cioe' il sintomo che si scambia per "la tesi non funziona".

### F. ✅ `ABTG_Nasdaq_Apertura_US` — il GAPFILL e' confermato, ma c'e' altro
- La cella **RR 1,0 / pts 30-50** e' uscita **identica al centesimo in due
  round indipendenti** (R61 e R62): OOS **+7.649,67 · PF 2,007 · n=26 · DD
  3,91% · peggior giornata −1,03%**.
- **`InpGapMinPoints` e' un asse RIDONDANTE**: il filtro RR, col pavimento
  `InpMinStopPts=500`, impone gia' un gap minimo di 250/500/750 punti. La
  leva vera, se servisse, e' `InpMinStopPts`.
- 🔵 **E il RETEST col filtro volumi non e' mai stato seguito**: OOS
  **+274,35 · PF 1,109 · DD 3,68%**. Scatta su giorni diversi dal GAPFILL,
  quindi **ci convive** senza violare la regola 1 di `ROTTA_PROP.md`.

---

## 3. 🚪 LE PORTE CHIUSE — valore negativo, ma reale

| cosa | misura |
|---|---|
| **`RangeMode=2`** — due referti dicevano ancora "mai misurato, provare" | **e' misurato**: IS +434,08 → **OOS −2.444,14, PF 0,665, DD 26,29%**. Un round da 26% di drawdown evitato |
| **short dell'apertura su DAX e Nasdaq** — la CODA lo dava per mai misurato | **R43 l'aveva gia' ucciso**: 64 celle, 0 verdi su 32 OOS |
| **il `retest` sul Code Base** | **0 occorrenze su 1.185 sorgenti pubblici**: il buco non e' nostro, e' loro |
| **gap continuation short** (arXiv 2605.04004) | l'unica famiglia positiva su 14, ma **7,3 trade/anno** → ~14 sul nostro storico, sotto il pavimento dei 15 |

---

## 4. 🧱 IL COLLO DI BOTTIGLIA, in una riga

> **Tre EA scritti, sei candidati in coda, sei modifiche individuate — e
> zero cose che girano, perche' manca UN F7 in MetaEditor.**

**L'ordine che consiglio:**

1. **Compila i tre EA** in MetaEditor. Se uno da' errore, me lo mandi e lo
   sistemo: nessun agente puo' compilare, quindi quel passo e' tuo e blocca
   tutto il resto.
2. **La modifica PTE** (§2.A): 32 celle, zero codice, il miglior rapporto
   valore/costo di oggi.
3. **Il controllo ATR sul Supertrend** (§2.B): mezz'ora, e sblocca tre
   candidati in coda.
4. **Il round RETEST volumi** sul Nasdaq (§2.F): dati gia' in casa.
5. La **sonda sessione** (`ABTG_SondaSessione.mq5`), che dice se il GAPFILL
   va rinominato prima del forward.
