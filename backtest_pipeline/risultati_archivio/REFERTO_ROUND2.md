# REFERTO — ROUND 2 (griglie mirate) — 08/08/2026

_Due dei tre lavori arrivati; il Nikkei a taglia prop segue. Criteri scritti nei file
prova PRIMA di lanciare._

## 1. 🥇 MaxMinNotte_DAX_Short_Ottimizzato — PROMOSSO (con l'asterisco dichiarato)

Griglia sul buffer d'ingresso, valore live (1000) al centro:

| buffer | IS | OOS | PF OOS | DD OOS |
|---:|---:|---:|---:|---:|
| 500 | +376,67 | −26,03 | 0,957 | 3,61% |
| **750** | +488,79 | **+515,72** | 2,007 | 2,23% |
| **1000 (live)** | +477,51 | **+618,31** | 2,192 | 1,88% |
| **1250** | +444,58 | **+699,30** | 2,680 | 2,38% |
| **1500** | +466,80 | **+432,88** | 1,722 | 2,77% |

- ✅ **Sanità: la cella 1000 riproduce la FASE 0 AL CENTESIMO** (+618,31). Stesso driver,
  stesse finestre: il banco di prova è riproducibile.
- ✅ **Il criterio scritto prima è passato**: 750 e 1250 positivi in ENTRAMBE le finestre.
  Non è un picco: è un **altopiano da 750 a 1500**, con l'IS stabile su tutte e 5 le celle.
  L'edge è del box notturno, non del numero 1000.
- ⚠️ L'asterisco, dichiarato prima del test: **~20 trade OOS per cella**, sotto il minimo
  dei 30. Questo non lo risolve nessuna griglia (i trade sono quelli): lo risolve solo il
  forward che si accumula. **Primo EA a passare TUTTI i criteri verificabili.**

## 2. 🥈 GoldenCross_Ottimizzato @XAUUSD H1 — NON promosso, e la griglia spiega perché

Griglia sulla soglia ADX, live=15:

| ADX min | IS | OOS |
|---:|---:|---:|
| 10 | +299,35 | +308,30 |
| **15 (live)** | +299,35 | **+308,30** |
| 20 | **+331,69** ← migliore IS | **−136,56** |
| 25 (il PDF) | +227,24 | −6,62 |

- ✅ Sanità: cella 15 riproduce la FASE 0 al centesimo.
- 🔎 **Celle 10 e 15 IDENTICHE al centesimo** (il rilevatore delle righe identiche): fra
  10 e 15 il filtro ADX non scarta **nessun** trade — le altre condizioni del pattern lo
  rendono già superfluo sotto quota ~15. Il filtro "di forza" non sta contribuendo niente.
- 🔴 **NONO ribaltamento IS→OOS**: la cella 20 è la MIGLIORE in campione e NEGATIVA fuori.
  E il 25 suggerito dal PDF fuori campione perde. Il live (15) sta sul bordo giusto di un
  dirupo che comincia subito sopra.
- ❌ Criterio dichiarato («promossa se 10 E 20 positive in entrambe»): il 20 è negativo →
  **non promossa**. Resta 🥈: il pattern regge (57 trade OOS, PF 1,25) ma il suo vicinato
  su quest'asse non è verde. **Non si tocca niente in live** — 15 e 10 sono equivalenti,
  e alzare verso il "consigliato" 25 sarebbe stato un danno misurato.

## In attesa

Nikkei a taglia prop (100k): il file `_r2` di `ABTG_SupertrendReversal` non è ancora
arrivato. Il referto si completa con quello.

## 3. ⚠️ Nikkei a taglia prop — il criterio 6 ha fatto il suo lavoro: IL TEST NON RISPONDE

A deposito **100.000** i numeri sono rimasti quelli del 10.000:

| TF | OOS (100k) | OOS (10k, FASE 0) | PF | n |
|---|---:|---:|---:|---:|
| H2 | +13,68 | +12,68 | 1,521 | 32 |
| H3 | +17,38 | +18,03 | 1,803 | 20 |
| H4 | **+6,48** | **+6,48 (identico)** | 1,242 | 17 |

DD allo 0,01–0,02% di 100k: **il lotto è ancora inchiodato al minimo del broker.** Il
criterio 6, scritto prima proprio per questo caso, dice: *"se il profitto resta a pochi
euro anche a 100k, il test non risponde"*. Non risponde.

**La causa è nel motore, ed è stata trovata nel codice**: `LotByRisk()` usa
`SYMBOL_TRADE_TICK_VALUE` così com'è. Sul Nikkei (`225JPY`) quel valore è quasi
certamente **in yen, non convertito in euro** (≈160× troppo grande): il rischio per
lotto esce enorme, il lotto calcolato esce ~zero, e `MathMax(min, …)` lo appoggia al
minimo. Per questo il P&L reale è di pochi euro mentre il calcolo "crede" di rischiare
l'1%. La conferma indiretta: se il rischio per lotto fosse davvero quello calcolato, i
trade a lotto minimo oscillerebbero di centinaia di euro — oscillano di cinque.

**Cosa resta in piedi**: la FORMA. Per la terza misura consecutiva H2·H3·H4 sono
positive in entrambe le finestre, e l'aggregato dell'altopiano fa **+37,54 su 69 trade
OOS** (sopra il minimo dei 30, come da regola dichiarata). L'edge come disegno c'è; la
sua taglia economica è **non misurabile finché il sizing non viene corretto**.

→ **Il Nikkei passa al binario B del PIANO_MIGLIORAMENTO**: correzione del calcolo del
lotto su simboli non-EUR (`OrderCalcProfit` al posto del tick value nudo), poi la
misura si rifà. È la stessa classe di difetto del lotto-a-zero del SuperWave: la
famiglia "il money management sbaglia su simboli esotici" ha ora due membri.
