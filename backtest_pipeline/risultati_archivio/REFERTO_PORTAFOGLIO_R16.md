# REFERTO R16 -- IL PRIMO DD DI PORTAFOGLIO MISURATO (09/08/2026)

**La domanda**: se i candidati girano INSIEME su un conto da 100k
(taglia FTMO), quanto fa male il momento peggiore?

**La risposta, misurata (5 serie)**: storico **8,91%**; Monte Carlo
p95 **12,80%**, p99 **15,96%**. Correlazioni giornaliere ~zero, anche
fra Dow e ORB che dividono simbolo e sessione. Il portafoglio esiste:
22,11% di somma dei DD singoli diventa 8,91% combinato.

---

## Le serie (tutte OOS 2025.06.10 -> 2026.06.30, tick reali, 1%, 100k)

Raccolte coi lanci pt7a-e del 09/08 (driver corretto, magic vergini),
coppie gemelle al centesimo verificate, archiviate in
`risultati_prove/trades_portafoglio/`:

| EA (magic serie) | trade | giorni attivi | netto | DD singolo |
|---|---|---|---|---|
| ORB-EMA200 lab (770612) ** | 119 | 119 | +41.057,00 | 9,72% |
| DAX Apertura EU (770115) | 270 | 193 | +18.029,58 | 6,25% |
| Dow Apertura ricetta (770206) | 130 | 96 | +6.721,93 | 4,22% |
| MaxMinNotte DAX Short (770413) | 21 | 14 | +6.143,38 | 1,27% |
| Nikkei STREV H2 (770903) | 50 | 34 | +1.863,34 | 0,65% |

Sanita' ORB a 100k: OOS 119 trade identici al R15, PF 1,674 vs 1,657,
DD 9,76% vs 9,92% -> scala ~10x pulita, come gli altri.

## Il portafoglio a 5 (239 giorni con trade, ~12,6 mesi)

- **Netto totale: +73.815,23** (+73,8% sul deposito, a 1% per trade)
- **Max DD storico: 11.448,55 = 8,91%** dal picco
- Somma dei DD singoli: 22,11% -> **beneficio di diversificazione: -13,2 punti**
- **Peggior giornata combinata: -3.094,97 (-3,09%)**
- Correlazioni giornaliere tutte fra **-0,12 e +0,06**. La piu' bella:
  **Dow retest vs ORB breakout = +0,06** sulla STESSA apertura USA --
  ingressi diversi (retest del livello vs pendente sul range 15')
  bastano a scorrelarli.

## Monte Carlo a 5 (2000 rimescoli dei giorni interi, seed 42)

- p50: **7,46%** · p95: **12,80%** · p99: **15,96%**
- Storico 8,91%, sopra il p50: la sequenza reale NON e' stata fortunata.

## Lettura FTMO 2-step (100k: max DD 10%, daily 5%)

- **Daily**: peggior giornata -3,09% a rischio 1% -> a 0,65% diventa
  ~-2,0%: margine ok in entrambi i casi.
- **Max DD a 1%**: p95 12,80% > 10% -> NON si accende cosi' su una prop.
- Scala lineare del rischio per trade:
  - **0,78%** -> p95 ~10,0% (limite esatto, zero margine)
  - **0,70%** -> p95 ~9,0% · p99 ~11,2%
  - **0,63%** -> p95 ~8,1% · **p99 ~10,0%**
- Taratura consigliata per il dry-run Guardiano: **0,6-0,65% per trade**
  (p99 sotto il 10% con margine). Decisione di DEPLOY del conto
  prop/demo, non un'ottimizzazione: i forward in corso NON si toccano.

## L'avvertenza onesta (prima di innamorarsi del +73,8%)

Il portafoglio a 5 pende sull'ORB: **+41k su +73,8k e' SUO**, ed e' il
candidato piu' giovane -- nato in laboratorio ieri, doppio asterisco
dichiarato nel referto R15, forward demo partito solo lunedi'. La
versione prudente e' il portafoglio a 4 (senza ORB): netto +32.758,
DD storico 5,51%, MC p50 6,51% / p95 10,56% / p99 12,66%. Regola di
buon senso per il dry-run: accendere l'ORB nel Guardiano a rischio
ridotto o aspettare i suoi 30 trade forward prima di dargli peso pieno.

## Cosa resta aperto

1. La finestra e' UNA (12,6 mesi OOS): il Monte Carlo allarga le
   sequenze, non i regimi. Il forward resta il giudice.
2. Demo 100k col Guardiano (FTMO preset): i numeri ci sono tutti --
   scaletta di deploy con verifica screenshot, poi si accende.
3. Dopo i 30 trade forward per candidato: la decisione prop vera
   (regola del 30/07, invariata).

*Serie e riepiloghi: `risultati_prove/trades_portafoglio/` · prove
pt7a-e: commit 844f9a5/a70dc77/c920e04 · analisi: `dd_portafoglio.py
--deposito 100000` (output integrale riprodotto sopra).*
