# 🧊 CRITERI CONGELATI — MONTE CARLO DEL DD SU UNA SINGOLA CELLA

**Scritti il 14/09/2026, PRIMA di calcolare qualunque quantile.**
Strumento: `backtest_pipeline/mc_dd_cella.py` (nuovo).
Nasce da un rilievo esterno (Marco, 13/09) sul cancello di funnel
**«Rischio (OOS): DD fuori campione ≤ 7,00%»** (`genera_dossier_metodo.py`
r.132; IS ≤ 9,00%, r.133): **quel numero si legge su UNA sola sequenza di
trade**, senza nessuna distribuzione di riordino.

---

## 1. Che cosa NON è questo documento

🔴 **Non cambia il cancello.** La soglia 7,00%/9,00% è una firma di Claudio:
qui si costruisce solo la MISURA che dice quanto quel singolo numero sia
stabile. Ogni lettura nuova proposta sotto è **una proposta**, e resta
proposta finché non è firmata.

---

## 2. Metodologia — la STESSA di casa, applicata a una cella sola

Ereditata alla lettera da `dd_portafoglio.py` (R16→R41) e da `mc_trailing.py`
(M1, referto `risultati_archivio/REFERTO_M1_MC_TRAILING.md`):

- **Unità di ricampionamento: il GIORNO INTERO.** Si rimescolano i giorni,
  non i singoli trade: così i deal dello stesso giorno (parziale + resto)
  restano insieme e nello stesso ordine interno. Conserva la correlazione
  same-day, **distrugge** quella seriale (le strisce).
- **2000 iterazioni, seed 42** — identici a casa, quindi deterministico.
- **Deposito 100.000**, scala lineare dei P&L (`--scala`), niente compounding.
- **Lettura dei trade**: CSV per-trade `abtg_trades_*.csv` scritto da
  `ExportTrades()` degli EA, separatore `;`, colonna 0 = `close_time`,
  colonna 7 = `net_profit` (stesso parser di `dd_portafoglio.py`).

### Le quattro metriche calcolate per ogni risequenza

| sigla | geometria | a che serve |
|---|---|---|
| **S-g** | statica, % dal **picco**, equity di **fine giornata** | è ESATTAMENTE la metrica di `dd_portafoglio.py`: serve da sanità |
| **S-t** | statica, % dal **picco**, equity **dopo ogni deal** | più severa, più vicina a quello che misura il tester |
| **T-A** | trailing EOD, % del **capitale iniziale** | variante A di `mc_trailing.py` (muro prop stile 1-Step) |
| **T-B** | trailing per-deal, % del **capitale iniziale** | variante B di `mc_trailing.py`, minorante dell'equity flottante |

Il cancello del dossier si confronta con **S-t** (vedi §3).

---

## 3. 🔴 IL LIMITE DI GEOMETRIA, dichiarato PRIMA e non dopo

Il DD che il cancello legge è l'**`Equity DD %` del tester**, che include
l'**equity flottante intrabar**. Il nostro per-trade contiene solo i deal
**chiusi**: qualunque DD ricostruito da lì è un **MINORANTE**.
Su questa cella il divario è già misurabile sui numeri storici pubblicati e
**si dichiara qui, prima della Monte Carlo**:

- `Equity DD %` del tester (r137c OOS, `InpTP1_ClosePct=50`): **7,2328%**
- DD ricostruito dal per-trade chiuso (% dal picco, per-deal): **6,2516%**
- ⇒ **sovrapprezzo intrabar misurato su questa cella: k = 1,157**

Quindi si producono **due letture, etichettate diversamente**:
1. **MISURA**: i quantili in geometria per-deal chiusa (confrontati con il
   cancello **così come sono**, dichiarando che sono un minorante);
2. **INFERENZA**: gli stessi quantili moltiplicati per **k = 1,157**
   (ipotesi: il sovrapprezzo intrabar è proporzionale). 🔴 **Non è una
   misura** — è un'estrapolazione da UN solo punto, e va detto ogni volta
   che la si cita.

---

## 4. Le tre lampade — lettura PROPOSTA (non firmata)

Detto `q` il quantile del max DD ricampionato e `S` la soglia del cancello
(7,00% OOS / 9,00% IS):

- 🟢 **SOLIDA** — `p95 < S`: 95 risequenze su 100 restano sotto il cancello.
- 🟡 **FRAGILE** — `p50 < S ≤ p95`: lo storico passa, ma una sequenza
  sfortunata plausibile no.
- 🔴 **PASSATA PER FORTUNA** — `S ≤ p50`: la mediana delle risequenze
  sfonda già il cancello.

Più due numeri di servizio, che sono la risposta diretta a Marco:
- **P(DD ricampionato > S)** — la probabilità di sfondare il cancello;
- **indice di fortuna = DD storico / p50** — sotto 1 lo storico è stato
  più gentile della mediana, sopra 1 più cattivo.

---

## 5. 🧪 I CONTRO-ESEMPI — devono passare TUTTI, prima di leggere un numero

Regola del 10/09: prima di consegnare una misura, costruire il caso che la
farebbe sbagliare e far vedere che non sbaglia. Lo strumento ha un
`--autotest` che **fallisce rumorosamente** se uno di questi cade:

1. **Identità con `dd_portafoglio.py`** — sulla stessa singola serie, la
   metrica **S-g** deve dare p50/p95/p99 **identici al centesimo** a quelli
   di `dd_portafoglio.py`. Se il raggruppamento per giorni o il flusso RNG
   divergessero, questo test cade. *(È il vero collaudo: non un test scritto
   per confermarmi, ma un confronto con codice che esiste già.)*
2. **Enumerazione esatta** — su una serie giocattolo di 7 giorni si
   enumerano **tutte** le 5.040 permutazioni e si calcolano i quantili veri.
   I quantili della Monte Carlo devono cadere entro **0,25 punti** da quelli
   esatti. Un errore di segno, di picco o di ordine li sposta.
3. **Degeneri** — serie tutta in guadagno ⇒ max DD **0,00 in ogni**
   risequenza; serie tutta in perdita ⇒ DD **identico in ogni** permutazione
   (p50 = p99), perché con equity monotona decrescente l'ordine non conta.
4. **Determinismo** — due esecuzioni con lo stesso seme danno gli stessi
   numeri, cifra per cifra.

---

## 6. ⚠️ Limiti dichiarati (validi qualunque cosa esca)

- **Il rimescolo non crea regimi.** Allarga le sequenze possibili dentro la
  finestra misurata; non dice niente su un mercato che non c'è in quei dati.
- **Niente equity flottante intrabar** (§3): tutte e quattro le metriche
  sono minoranti del vero.
- **Il DD non scala linearmente col rischio**: i quantili vanno ricalcolati
  per taglia, non moltiplicati (nota d'igiene già pagata in M1, §3 del
  referto: «~8,1%» scalato contro **8,51%** ricalcolato).
- 🔴 **Su una cella che apre al massimo UNA posizione al giorno, rimescolare
  i GIORNI è identico a rimescolare le POSIZIONI.** La frase «conserva la
  correlazione same-day» resta vera ma **vuota**: va detto per la cella su
  cui si gira, ogni volta, contando le posizioni per giorno (lo strumento
  stampa la distribuzione).
- La Monte Carlo per riordino assume che i trade siano **scambiabili**. Se
  il motore avesse una dipendenza seriale vera (strisce non casuali), il
  rimescolo la cancella: è per questo che il DD storico si continua a
  riportare **accanto** ai quantili, mai al loro posto.
