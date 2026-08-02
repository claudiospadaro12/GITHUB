# 📉 DAX apertura M5 (D30EUR) — confronto MOTORI a TICK REALI

_Aggiornato: 2026-08-02. Fonte: i 3 CSV in questa cartella (Model 4, 2024.01–2026.06, apertura 08:00 server = 09:00 IT)._
_Griglia comune: `InpRangeMinutes` × `InpBufferPoints` × `InpTrailFixedPts`. Nessun filtro di trend (sul DAX il filtro H4 peggiora, finding 30/07)._
_Regola d'oro: conta il **PF MEDIANO** (robustezza), non il PF migliore (fluke)._

## Tabella

| Motore | pass | **PFmed** | PFmin | PFmax | % pass PF>1 | DDmed% | DDmax% | trade (med) | Esito |
|---|---|---|---|---|---|---|---|---|---|
| BREAKOUT (stop) | 138 | **0,77** | 0,39 | 1,04 | **1%** | 12,6 | 34,8 | 440 | ❌ morto |
| RETEST (limit) | 130 | **0,79** | 0,32 | 1,11 | **10%** | 13,0 | 33,3 | 436 | ❌ morto |
| RANGE-FADE | 136 | **0,73** | 0,38 | **0,94** | **0%** | **23,5** | 38,4 | 440 | ❌ **il peggiore** |

## Cosa dicono i numeri

- **Il fade è il peggiore dei tre**, non il salvatore che speravamo per il whipsaw. PFmed 0,73, e soprattutto **nessuna singola combo su 136 arriva a PF 1** — il massimo assoluto è 0,94, in perdita di −5.532 €.
- **Il DD raddoppia**: mediana 23,5% contro 12,6–13,0% degli altri due. Ha senso: fadare l'estremo del range nei giorni in cui il DAX parte davvero significa mettersi davanti al treno. Il motore pensato per ridurre il rischio del whipsaw è quello che ne aggiunge di più.
- Il numero di trade è identico nei tre motori (~440): non è un problema di campione o di ordini non riempiti. Il DAX all'apertura viene tradato tutti i giorni in tutti e tre i modi, e in tutti e tre si perde.
- ⚠️ `InpFadeOffsetPts` è rimasto a 0 (non spazzolato). Con PFmax 0,94 e 0% di pass positivi, però, un offset non colma un buco del 30%: sarebbe cercare il fluke, non l'edge.

## 🔑 Verdetto DAX apertura M5

**Tre motori su tre falliti a tick reali, con ~440 trade ciascuno su 2,5 anni.** Non è sfortuna né un campione sottile: è un'assenza di edge misurata tre volte in tre modi opposti (inseguire la rottura, aspettare il ritorno, fadare l'estremo).

Restano da provare **entrata ritardata/confermata** (#4, implementata 02/08) e, se serve, **ORB-15** (#7) e **gap-fill** (#5). Se anche la ritardata fallisce, la conclusione onesta è che **il DAX all'apertura non ha edge sfruttabile in M5** e la questione va chiusa — il tempo di backtest va sui candidati prop (GoldenCross H1 a tick reali).

## Nota di metodo
I valori qui calcolati (BREAKOUT 0,77 · RETEST 0,79) coincidono con quelli già registrati in `CACCIA_MOTORE_APERTURE.md` il 02/08 → il conteggio è riproducibile e i tre motori sono confrontabili fra loro.
