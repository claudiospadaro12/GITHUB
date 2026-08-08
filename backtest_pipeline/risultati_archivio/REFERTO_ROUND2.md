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
