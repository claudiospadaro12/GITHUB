# ⚖️ ROUND 91 — IL CANCELLO DI RR SUL BREAKING BAND: **BOCCIATO SU TUTTI E TRE**

_Girato la notte del 20/08 (22:52-22:55), pin `8c67c6f`, tick reali, deposito
100.000. **Criteri firmati da Claudio la sera del 20/08, a numeri mai visti.**
24 passate, sanita' superata su tutti e tre i simboli. CSV in `r91_csv/`._

## 1. Da dove nasceva il round
Un trade forward **vincente**: `BB GBPUSD INV S` del 20/08, +2,69 netti, con
**2,5 pip di target contro 36,4 di rischio (RR 1 : 0,069)**. L'asimmetria e'
strutturale: **TP = geometria delle bande, SL = 3 x ATR fissi**, due misure che
non si parlano. Sembrava un difetto da curare.

## 2. Il verdetto, col criterio n.1 firmato

> *"L'aspettativa dei trade TAGLIATI, per differenza. **Se viene >= 0 il filtro
> ha tagliato VINCENTI: bocciato**, qualunque cosa dica il resto della riga."*

| simbolo | soglia | trade tagliati | **aspettativa dei tagliati** | esito |
|---|---|---:|---:|---|
| GBPUSD | RR >= 0,5 | 16 su 26 | **+193,08 a trade** | 🔴 BOCCIATO |
| EURUSD | RR >= 0,5 | 9 su 13 | **+184,17 a trade** | 🔴 BOCCIATO |
| AUDUSD | RR >= 0,5 | 6 su 11 | **+66,11 a trade** | 🔴 BOCCIATO |

**Tutte e tre positive, e di molto.** Il filtro non tagliava trade scadenti:
tagliava **i migliori**.

### Il quadro completo (OOS)
| simbolo | RR 0 (in campo) | RR >= 0,5 | RR >= 1,0 |
|---|---|---|---|
| GBPUSD | PF **1,7302** · +3.160,10 · n 26 | PF 1,0227 · **+70,84** · n 10 | **nessun trade** |
| EURUSD | PF **3,8627** · +2.069,82 · n 13 | PF 1,7651 · +412,27 · n 4 | **−517,15** · n 1 |
| AUDUSD | PF **2,7474** · +1.840,67 · n 11 | PF 56,88 · +1.443,99 · n 5 | **nessun trade** |

Sul GBPUSD il filtro piu' blando **cancella il 98% del profitto** (da 3.160 a 71).

### E il canarino della frequenza dice VETO, in piu'
Taglio del **62% · 69% · 55%**: tutti oltre la soglia di **veto (>50%)** scritta
nei criteri. A RR 1,0 le sedie smettono proprio di operare (0-1 trade in due
anni). *Comprare "qualita'" pagando in cecita' e' un cattivo affare.*

## 3. 🎯 PERCHE' QUESTO ROUND VALE PIU' DI UNA PROMOZIONE

I criteri, scritti **prima** dei numeri, contenevano gia' la frase che spiega
tutto:

> *"Il TP **vicino** e' anche il TP **FACILE**: tagliarlo toglie tante piccole
> vincite e lascia in piedi i trade con obiettivo lontano, che hanno piu' tempo
> per andare in stop. Puo' peggiorare l'aspettativa alzando il PF."*

E' **esattamente** quello che e' successo. L'intuizione — *"RR 1:0,07 e'
assurdo, va corretto"* — era **sbagliata**, e i criteri l'hanno smascherata
invece di lasciarci inseguire per settimane un miglioramento che non c'era.

Il Breaking Band **e' un motore di mean reversion**: guadagna perche' il
ritorno alla media e' **probabile**, non perche' e' grande. Chiedergli un RR da
trend-following significa chiedergli di essere un altro motore.

## 4. Conseguenze operative

- ✅ **`InpMinRR` resta nel codice, a 0 (spento)**. E' un input opt-in che non
  cambia nulla: nessun `.ex5` in campo va toccato, nessun preset cambia.
- 🚫 **La pista "migliorare il BB col RR" e' CHIUSA.** Non e' un parametro da
  spazzolare meglio: e' una domanda con risposta.
- 📌 **Se un giorno si vorra' migliorare il Breaking Band**, la strada NON e'
  filtrare gli ingressi: semmai e' **lo stop** (3 x ATR fisso mentre il TP e'
  geometrico) — cioe' la stessa direzione che l'ORB ha mostrato in R88.
  **Domanda per un round futuro, non per questo.**
- ⚠️ **TODO ancora aperto**: i `.set` delle tre sedie BB **non sono in repo**;
  R91 ha usato la configurazione dei file prova R33/R34. Il verdetto (il filtro
  taglia vincenti) e' cosi' netto su tutti e tre i simboli che un piccolo
  scarto di preset non lo ribalta — ma la verifica sul VPS resta da fare.
