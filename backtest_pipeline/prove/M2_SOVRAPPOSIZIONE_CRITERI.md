# M2 — CRITERI CONGELATI PRIMA DEI NUMERI (18/08/2026)

**Missione M2 del PIANO_PROP (riga C1): misurare la sovrapposizione REALE
delle sedie** — quante posizioni sono aperte NELLO STESSO momento e quanto
rischio aperto fa la somma, giorno per giorno. Questo file e' scritto e
committato PRIMA di far girare lo script: i criteri non si ritoccano dopo
aver visto i numeri.

---

## 1. I dati (in ordine di verita')

| fonte | cosa contiene | uso in M2 |
|---|---|---|
| `data/statements/trades_auto.csv` (forward conto piccolo, export TradeExporter/pubblica_trades) | **open_time E close_time** per posizione, magic, strategy, simbolo | **misura PRIMARIA** — l'unico dataset di casa con gli orari di apertura |
| `data/statements/trades_100k.csv` (dry-run 100k) | idem, 6 posizioni | contorno (campione minuscolo, dichiarato) |
| serie per-trade R16 / portafoglio 27-30 serie (`backtest_pipeline/risultati_prove/trades_*/abtg_trades_*.csv`) | **SOLO `close_time`** + netto (formato `ExportTrades()`: close_time;symbol;magic;position_id;deal_type;volume;price;net_profit) | ⛔ **la sovrapposizione intra-day NON e' misurabile da qui** — dichiarato (vedi §5) |

**Verificato prima del congelamento (schema, non risultati):** tutti i CSV
di backtest hanno solo `close_time`; il forward ha entrambe le colonne e
zero righe con `close_time < open_time` o `close_time` vuoto.

## 2. Definizioni (congelate)

- **Tempo**: ora SERVER BCM, cosi' come scritta nei CSV. Nessuna conversione.
- **Posizione aperta in t**: `open_time <= t < close_time`.
- **Sedia** = magic. `magic = 0` = trading MANUALE: **escluso** dalla misura
  (M2 misura le sedie, non la mano) — quantita' esclusa dichiarata nel referto.
  Tutti i magic ≠ 0 contano, anche gli EA esterni.
- **Sedie simultanee in t** = numero di magic distinti con almeno una
  posizione aperta in t.
- **Posizioni simultanee in t** = numero di posizioni (pid) aperte in t.
- **Rischio aperto in t — la metrica C1**, in DUE letture, tutte a taglia
  prop **0,65% per unita'** (la convenzione di casa, A1 congelato):
  - **per-POSIZIONE (primaria, conservativa)**: `posizioni aperte in t × 0,65%`
    — corrisponde alla definizione C1 "somma degli SL vivi" assumendo ogni
    posizione con SL pieno;
  - **per-SEDIA (secondaria)**: `sedie aperte in t × 0,65%` — la lettura
    "una sedia = un rischio" (se un EA fraziona l'ingresso, la somma dei
    suoi SL resta ~un rischio).
  Il numero vero sta fra le due; nel referto si riportano entrambe.
- **⚠️ Limite dichiarato**: il CSV non registra l'evoluzione dello SL
  (parziali, BE, trailing). Il rischio aperto qui e' quello **all'ingresso,
  tenuto vivo per tutta la durata** = **limite SUPERIORE** del rischio reale.
  Per dimensionare un cap e' il verso giusto dell'errore.
- **Giornata** = data server (00:00–24:00 server). Metrica giornaliera =
  **massimo intra-day** di sedie/posizioni/rischio aperto.

## 3. Output (decisi ora)

1. **Max storico** di sedie e posizioni aperte insieme (e quando).
2. **Distribuzione del massimo giornaliero** del rischio aperto: p50 / p95 /
   p99 / max, sui giorni con almeno una posizione EA aperta.
3. **Giornate sopra soglia**: quante col massimo intra-day di rischio aperto
   `> 4%` e `> 5%` (in entrambe le letture).
4. **Combinazioni ricorrenti**: coppie di sedie con piu' minuti di
   sovrapposizione (top), e la composizione esatta del momento di picco.
5. La riga per C1: *"il rischio aperto simultaneo reale arriva a X% (p99 Y%)
   → il cap C1 sensato e' Z%"*.

## 4. Algoritmo

Sweep-line sugli eventi (aperture/chiusure ordinate): ad ogni evento si
aggiorna l'insieme delle posizioni aperte; il massimo giornaliero si prende
sugli istanti-evento (il conteggio e' costante fra due eventi, quindi il
massimo cade per costruzione su un evento). Script:
`backtest_pipeline/sovrapposizione_sedie.py` (python3, sola lettura, zero
modifiche al forward).

Finestre riportate: **(a) tutto il forward EA** (da quando esistono magic ≠ 0
nel CSV) e **(b) solo agosto 2026** (il campione citato dal piano). Se i
numeri divergono, fa fede la lettura piu' recente e lo si scrive.

## 5. Cosa NON si misura (dichiarato, non aggirato)

- Dalle serie R16/27-serie **niente sovrapposizione**: senza `open_time` non
  esiste l'intervallo. L'unica cosa lecita da li' e' la **co-attivita' per
  giorno di CHIUSURA** (quante sedie hanno chiuso almeno un trade lo stesso
  giorno) — che NON e' rischio aperto simultaneo e nel referto sta in una
  sezione separata, etichettata come contesto. Peraltro sottostima le
  posizioni multi-day (contate solo il giorno di chiusura).
- Il rischio reale post-parziale/BE: non osservabile dal CSV (vedi §2).
- Il forward EA copre ~4,5 mesi (primo trade con magic ≠ 0: 31/03/2026;
  518 posizioni EA al 17/08) con una flotta che e' CAMBIATA nel tempo
  (sedie accese e spente): i percentili si dichiarano per quello che sono,
  e la finestra di agosto (flotta attuale) pesa di piu' nella lettura.

*Congelato prima di ogni numero. Prossimo commit: lo script. Poi il referto
`backtest_pipeline/risultati_archivio/REFERTO_M2_SOVRAPPOSIZIONE.md`.*
