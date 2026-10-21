# R276c (T3x: stessa cella viva Nasdaq a deposito 500) -- lettura PARZIALE dei CSV riassuntivi (21/10/2026)

Fonte: `ROUND_R276c.zip` (solo CSV IS/OOS, referto e file prova; **NIENTE per-trade**: quelli stanno nel `ROUND_R276_<data>.zip` completo). Pin `bf00332a` (corretto), deposito 500, modello 4, `InpSessionHour=14`, `InpRiskPercent=2`. Criteri: `backtest_pipeline/prove/R276c_T3x_deposito500_NASDAQ_NASUSD.txt`. Il lettore dei per-trade di R276 NON esiste ancora: da scrivere e congelare PRIMA di aprire i per-trade; i CSV riassuntivi non sono per-trade e si leggono ora. Non controllata da agenti.

## G1 (determinismo): PASSA
Le due gemelle (magic 798621 e 798671) hanno righe identiche in Profit, PF, RF, Sharpe, Equity DD %, Trades, peggior giornata, serie perdente, sia IS sia OOS.

## Numeri a 500 EUR contro la cella a 80.000 (R274a)
| | IS 500 | IS 80.000 | OOS 500 | OOS 80.000 |
|---|---|---|---|---|
| Profit | +49,22 (+9,8%) | +7.014 (+8,8%) | +53,88 (+10,8%) | +8.497 (+10,6%) |
| PF | 1,285 | 1,221 | 1,254 | 1,215 |
| Equity DD % | 6,25 | 7,31 | 7,48 | 7,86 |
| **Trades (deal)** | **96** | 135 | **122** | 172 |
| **Peggior giornata** | **-3,25%** | -2,04% | **-2,68%** | -2,13% |
| Serie perdente peggiore | -17,24 (3,4% del deposito) | -3.407 (4,3%) | -33,79 (6,8%) | -5.682 (7,1%) |

## Cosa si legge, e cosa NO
- **Rendimento e DD in % restano simili** (+9,8%/+10,8% contro +8,8%/+10,6%; DD 6,3-7,5% contro 7,3-7,9%): a 500 EUR l'EA non esplode.
- **Peggior giornata -3,25% (IS) e -2,68% (OOS) contro -2,04% e -2,13% a 80.000**: a deposito piccolo una singola giornata perde di piu' del 2% di rischio nominale. Con `InpOneTradePerDay=1` la giornata e' di norma una posizione. **E' un INDIZIO coerente col lotto forzato al minimo (o con l'arrotondamento al passo del lotto), NON una conferma**: il criterio congelato del T3 chiede una posizione con rischio > 2,5% del saldo E volume uguale al minimo osservato, e il volume sta nel per-trade.
- **Meno operazioni**: 96 contro 135 (IS) e 122 contro 172 (OOS), circa -29% in entrambe. Causa [NON NOTA]: l'ipotesi e' che a 500 EUR parte delle posizioni non si apra per margine insufficiente (nel tester l'oro chiede 8.580 EUR a lotto [dal repo, R114]; per il Nasdaq non lo so) o per lotto sotto il minimo; si vede dal per-trade o dal giornale, non da qui.
- A3/A4 della prova (a 500: lotto minimo toccato in almeno il 20% delle posizioni e una oltre 2,5%; almeno 60 posizioni): le posizioni sono > 60 (96 e 122 deal contro il criterio sulle POSIZIONI da contare nel per-trade); il resto resta da misurare.

## Cosa serve
Il `ROUND_R276_<data>.zip` completo (con `PERTRADE`, R276a a 2000 e R276b armo tardivo): lo leggo con il lettore scritto e congelato prima.
