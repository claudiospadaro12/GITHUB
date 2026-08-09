# REFERTO R16 -- IL PRIMO DD DI PORTAFOGLIO MISURATO (09/08/2026)

**La domanda**: se i 4 candidati girano INSIEME su un conto da 100k
(taglia FTMO), quanto fa male il momento peggiore?

**La risposta, misurata**: storico **5,51%**; Monte Carlo p95 **10,56%**,
p99 **12,66%**. Correlazioni giornaliere ~zero. Il portafoglio esiste:
diversificare ha dimezzato il rischio rispetto alla somma dei singoli.

---

## Le serie (tutte OOS 2025.06.10 -> 2026.06.30, tick reali, 1%, 100k)

Raccolte coi lanci pt7a-d del 09/08 (driver corretto, magic vergini),
coppie gemelle al centesimo verificate, archiviate in
`risultati_prove/trades_portafoglio/`:

| EA (magic serie) | trade | giorni attivi | netto | DD singolo |
|---|---|---|---|---|
| DAX Apertura EU (770115) | 270 | 193 | +18.029,58 | 6,25% |
| Dow Apertura ricetta (770206) | 130 | 96 | +6.721,93 | 4,22% |
| MaxMinNotte DAX Short (770413) | 21 | 14 | +6.143,38 | 1,27% |
| Nikkei STREV H2 (770903) | 50 | 34 | +1.863,34 | 0,65% |

NOTA: manca la QUINTA serie, ORB-EMA200 (il candidato di laboratorio,
magic 770611): la sua raccolta per-trade e' il prossimo giro (R16e).

## Il portafoglio (225 giorni con trade, ~12,6 mesi)

- **Netto totale: +32.758,23** (+32,8% sul deposito, a 1% per trade)
- **Max DD storico: 7.498,94 = 5,51%** dal picco
- Somma dei DD singoli: 12,39% -> **beneficio di diversificazione: -6,9 punti**
- **Peggior giornata combinata: -2.258,15 (-2,26%)**

## Correlazioni P&L giornalieri (la notizia vera)

Tutte fra **-0,12 e +0,04**: statisticamente zero. DAX e Dow aprono a
ore diverse su indici diversi, MaxMin lavora la notte, il Nikkei
un'altra sessione: sulla carta erano scorrelati, ORA E' MISURATO.

## Monte Carlo (2000 rimescoli dei giorni interi, seed 42)

Il rimescolo conserva la correlazione same-day (i giorni restano interi)
e distrugge le strisce; per la prop conta la coda, non la media:

- p50: **6,51%** · p95: **10,56%** · p99: **12,66%**
- Lo storico (5,51%) sta sotto il p50: la sequenza reale e' stata
  leggermente fortunata. Mai pianificare sul percorso migliore.

## Lettura FTMO 2-step (100k: max DD 10%, daily 5%)

- **Daily**: peggior giornata -2,26% contro il limite del 5% -> margine largo.
- **Max DD**: a rischio 1% per trade la coda buca il limite
  (p95 10,56% > 10%). **A 0,7% per trade** le code scalano ~linearmente:
  p95 ~7,4%, p99 ~8,9% -> **sotto il 10% con margine anche al p99**.
- Tradotto: il portafoglio e' SANO, il rischio per trade a taglia prop
  va tarato a ~0,7% (decisione di DEPLOY del conto prop/demo dry-run,
  non un'ottimizzazione: i forward in corso NON si toccano).

## Cosa resta aperto

1. **R16e**: serie per-trade ORB-EMA200 (cella R15, deposito 100k) e
   referto aggiornato a 5 serie.
2. La finestra e' UNA (12,6 mesi OOS): il Monte Carlo allarga le
   sequenze, non i regimi. Il forward resta il giudice.
3. Demo 100k col Guardiano (FTMO preset): i numeri per la decisione
   adesso ci sono.

*Serie e riepiloghi: `risultati_prove/trades_portafoglio/` · driver e
prove: commit 844f9a5/a70dc77 · analisi: `dd_portafoglio.py --deposito
100000` (output integrale riprodotto sopra).*
