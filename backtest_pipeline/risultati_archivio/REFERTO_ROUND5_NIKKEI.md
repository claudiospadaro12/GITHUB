# REFERTO — ROUND 5: il Nikkei col sizing corretto — 09/08/2026

Rimisura a deposito 100k dopo il fix di `LotByRisk` (OrderCalcProfit al posto del tick
value nudo, che su 225JPY arrivava in yen non convertiti). Criteri scritti nel file prova
PRIMA di lanciare. 7 celle H1→H12, tick reali.

| TF | IS | OOS | PF OOS | DD OOS | n OOS |
|---|---:|---:|---:|---:|---:|
| H1 | +763,13 | +332,10 | 1,073 | 2,06% | 122 |
| **H2** | +591,35 | **+1863,34** | **1,653** | **0,88%** | **50** |
| **H3** | +875,76 | **+1263,55** | 1,542 | 1,01% | 37 |
| **H4** | +348,99 | **+1098,96** | 1,621 | 0,98% | 26 |
| H6 | −51,78 | +38,61 | 1,037 | 0,83% | 26 |
| H8 | +75,64 | −208,75 | 0,604 | 0,59% | 8 |
| H12 | +409,48 | +569,50 | 3,786 | 0,39% | 10 |

## I tre criteri, tutti passati

1. ✅ **SCALA**: H3 OOS +1263,55 contro i **+17,38** del round 2 (~70×), drawdown
   finalmente misurabile. Il lotto si è sganciato dal minimo: **il fix ha morso.**
2. ✅ **FORMA**: H2·H3·H4 positive in ENTRAMBE le finestre — **quarta conferma
   consecutiva** dell'altopiano, ora a taglia vera.
3. ✅ **PROP**: aggregato H2+H3+H4 OOS **+4225,85 su 113 trade** (minimo dei 30
   superato anche dalle celle H2 e H3 da sole), PF per cella 1,54–1,65, DD max **1,01%**.

**Regola TF di Claudio**: l'H1 è positivo in entrambe ma con PF OOS 1,073 (sotto l'1,10)
→ la cella di riferimento è **H2**, la più corta fra quelle che passano: OOS +1863,34 ·
PF 1,653 · DD 0,88% · 50 trade.

## Osservazione onesta sul meccanismo

I conteggi sono SALITI rispetto al round 2 (H2: 32→50 trade OOS). Non era previsto
dall'ipotesi ("stessi ingressi, lotto diverso"): col lotto minimo l'ingresso frazionato
dell'EA (1/3 a mercato + 2/3 pendente) non riusciva a spezzare il volume, col lotto vero
sì. Il sizing interagiva anche con la MECCANICA dei trade, non solo con la taglia — il
file prova lo contemplava come caso da dichiarare, ed è dichiarato. I segni per cella
hanno retto comunque.

## ⚠️ I due caveat che restano

1. **La finestra OOS del Nikkei è stata guardata quattro volte**: la conferma vera è il
   forward, come per tutti.
2. **Sul VPS gira ancora il codice vecchio**: sul grafico 225JPY l'EA continua a operare
   a lotto minimo finché non viene ricompilato/riattaccato. Ricompilare cambia il sizing
   SOLO sul Nikkei (sui simboli sani i due calcoli coincidono) — ma è un cambio live e
   la decisione è di Claudio. Il candidato ha bisogno esattamente di quel forward.
