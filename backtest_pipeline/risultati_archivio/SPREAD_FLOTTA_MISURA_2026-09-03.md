# 💸 SPREAD FLOTTA — LA MISURA (03/09/2026, corsa 10:06-10:08, pin e1c8143)

Il debito aperto dal 23/08 e' PAGATO: spread orario REALE dai tick storici
BCM (2024.09.26 -> 2026.06.30) per i tre indici. 252 milioni di tick letti,
blocchi persi 0, esito COMPLETA 3/3. Artefatti in `spread_flotta/`
(referto MQL5 + 3 CSV orari).

## 1) LA RIGA CHE DECIDE — BID/ASK: TUTTO OK
% SOLO-BID = **0,000% su tutti e tre i simboli** -> ask valido ovunque ->
**le corse a Model 4 usano lo spread VERO**: nessun backtest "ottimista"
da rifare per questo motivo.

## 2) I NUMERI CHE CONTANO (mediana / P95, PUNTI INDICE, ora SERVER)

| simbolo | ORE DI LAVORO del motore | mediana | P95 | fuori sessione |
|---|---|---|---|---|
| NASUSD | 14-20 (cash USA) | **1,6-1,8** | 1,8-2,7 | 2,3-2,6 (P95 2,7) |
| U30USD | 14-20 (cash USA) | **1,9-2,0** | 2,0-3,0 | 2,6-2,8 · ⚠️ ora 23: P95 7,0, max 101 |
| D30EUR | 8-16 (cash EU) | **1,6-1,7** | 1,9 (ora 8: P95 2,7) | **NOTTE 3,5-3,9** (piu' del doppio) |

## 3) COSA CAMBIA, dichiarato
- La convenzione `spread 2.0 [NON MISURATO]` dei prova era **giusta o
  prudente NELLE ORE DI SESSIONE** (mediane 1,6-2,0) e **ottimista fuori**
  (DAX notte 3,5-3,9; Dow ora 23 con code violente).
- **C2 si applica ORA PER ORA**: il take lordo mediano del motore deve
  stare >= 3x lo spread mediano DELL'ORA in cui lavora. In sessione:
  3x = **4,8-6,0 punti indice** a seconda di simbolo/ora.
- Le fasce F2 "sospese [spread non misurato]" dei round GIA' GIUDICATI
  restano come sono (i criteri non si cambiano dopo i numeri); dai round
  FUTURI si cita QUESTA misura.
- ⚠️ Per le sedie NOTTURNE sugli indici (MaxMinNotte DAX): lo spread
  notturno del DAX (3,5-3,9) e' un costo strutturale da tenere davanti
  in ogni valutazione — e la pendente delle 07:59 lavora a ~2,8.
- Caveat del referto: broker singolo, spread dai tick (non esecuzione
  live), niente slippage qui dentro (quello e' R55).
