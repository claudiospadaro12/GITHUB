# 🔍 PERCHÉ `770511` REALIZZA 0,13% — e perché **alzarlo non recupera niente**

**18/09/2026** · richiesta di Claudio: *«ALLORA ALZIAMO IL SUPERWAVE, CAPISCI PERCHÉ FA 0,13%»*

> ## 🟢 **RISPOSTA IN UNA RIGA: lo 0,13% non è una taglia bassa. È quello che il TRAILING ha già salvato prima che lo stop venisse colpito.** Il rischio non è stato lasciato sul tavolo: è stato messo sul tavolo e ripreso indietro.

---

## ① LE SEDICI POSIZIONI, per esteso

`data/statements/trades_auto.csv`, magic `770511`, U30USD, 27/07 → 09/09.
`punti` = distanza percorsa dall'ingresso alla chiusura, col segno del lato.

| apertura | lato | vol | apre | chiude | **punti** | P/L | motivo |
|---|---|---:|---:|---:|---:|---:|---|
| 07.27 08:00 | buy | 0,10 | 52351,5 | 52338,8 | **−12,7** | −1,12 | sl |
| 07.27 08:00 | buy | 0,20 | 52351,7 | **52351,7** | **0,0** | **+11,57** | sl |
| 07.29 20:00 | sell | 0,20 | 52210,5 | 52045,5 | +165,0 | +18,52 | tp |
| 07.29 20:00 | sell | 0,60 | 52210,3 | 52045,3 | +165,0 | +65,83 | tp |
| 07.31 04:00 | buy | 0,10 | 52414,5 | 52358,8 | **−55,7** | −4,86 | sl |
| 07.31 04:00 | buy | 0,20 | 52414,7 | **52414,7** | **0,0** | **+9,45** | sl |
| 08.17 11:00 | sell | 0,10 | 53648,5 | **53648,5** | **0,0** | 0,00 | sl |
| 08.17 11:06 | sell | 0,30 | 53648,3 | **53648,3** | **0,0** | **+9,64** | sl |
| 08.25 03:00 | buy | 0,10 | 53443,5 | **53443,5** | **0,0** | 0,00 | sl |
| 08.25 03:00 | buy | 0,20 | 53443,7 | **53443,7** | **0,0** | **+7,79** | sl |
| 08.31 06:00 | sell | 0,10 | 53419,5 | 52905,6 | +513,9 | +44,32 | tp |
| 08.31 06:00 | sell | 0,30 | 53419,3 | 52905,4 | +513,9 | +103,46 | tp |
| 09.03 17:00 | buy | 0,10 | 53716,5 | 53618,0 | **−98,5** | −8,48 | sl |
| 09.03 17:00 | buy | 0,10 | 53716,7 | 53618,0 | **−98,7** | −8,49 | sl |
| 09.07 05:00 | sell | 0,10 | 53212,5 | 52698,0 | +514,5 | +44,23 | tp |
| 09.07 05:00 | sell | 0,20 | 53212,3 | 52697,8 | +514,5 | +52,47 | tp |

**Netto: +244,33 su 16 posizioni.** EUR/punto misurato: **0,0860–0,0882 a 0,10 lotti** — combacia con la taratura indipendente del 09/09 (`report/PICCOLO_50503392_2026-09-09.md`: *«0,0859 €/punto a 0,10 lotti su U30USD»*). ✅

---

## ② 🔴 `close_reason == 'sl'` **NON vuol dire «colpito lo stop iniziale»**. Tre prove.

### (a) Il codice avrebbe RIFIUTATO quell'ingresso
`ABTG_SuperWave.mq5` **r.371-372**:
```
double minDist = MathMax(buf, SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point);
if(risk < minDist){ cO_sl++; Log("SL troppo vicino: skip."); return; }
```
Il 27/07 la sedia chiude a **−12,7 punti indice**. Uno stop **iniziale** di 12,7 punti su un Dow a 52.351 è dentro il livello di stop del broker: **l'EA non avrebbe nemmeno aperto**. 👉 Quindi quel −12,7 **non può essere lo stop iniziale**. È lo stop **spostato**.

### (b) Quattro chiusure al prezzo ESATTO di ingresso, con P/L POSITIVO
`52351,7 → 52351,7 (+11,57)` · `52414,7 → 52414,7 (+9,45)` · `53648,3 → 53648,3 (+9,64)` · `53443,7 → 53443,7 (+7,79)`.
**Prezzo di chiusura identico al prezzo di apertura, e soldi in tasca.** È il breakeven scattato dopo la parziale al TP1 (`InpTP1_R=1.0`, r.81). Quattro volte di fila non è un caso.

### (c) Lo stesso meccanismo, visibile in chiaro su un'altra sedia
In `ReportHistory50503392.xlsx` l'ordine **2847862** (`DAX Live 5m BUY`) compare in **due sezioni diverse**:
- sezione **Ordini** (r.36): ingresso 24761,1 · **S/L 24722,6** → *sotto* l'ingresso = **stop INIZIALE**
- sezione **Posizioni** (r.10): stesso ordine · **S/L 24842,4** → *sopra* l'ingresso = **stop FINALE**

> ## 🟢 **Lo stop ha attraversato l'ingresso di 81 punti.** E ci dice anche dove sta il numero che mi manca: **nel report MT5 «Ordini» porta lo stop iniziale, «Posizioni» quello finale.**

---

## ③ 🔴 CONSEGUENZA: alzare `InpRiskPercent` **non recupera uno 0,87% fantasma**

Lo 0,87% di differenza fra il contratto (1,0%) e il realizzato (0,13%) **non è spazio libero**.
È rischio che è stato **messo** all'ingresso e **ripreso** dal trailing prima dello stop.

👉 Alzare la percentuale alza il rischio **dell'ingresso** — quello vero, quello che il trailing
deve ancora salvare. **E su quello non ho il numero.**

---

## ④ 🔴 IL NUMERO CHE MANCA, e perché non ce l'ho

Per sapere quanto rischia davvero `770511` all'ingresso serve il **prezzo dello stop INIZIALE**.
- ❌ `trades_auto.csv` **non porta la colonna S/L**. Ha `session_high`/`session_low`, ma non
  riconciliano con nessuna ipotesi di stop (provato: darebbero rischi da 0,50% a 1,55% sugli
  stessi segnali — **non è quella la colonna**).
- ❌ `ReportHistory50503392.xlsx` **copre solo il 20/07** e non contiene **nemmeno una** posizione
  di SuperWave: 10 D30EUR, 5 XAUUSD, 7 NASUSD, 2 GBPUSD — **zero U30USD**.

### 🟢 La via più corta al numero, e costa una lettura
Un `ReportHistory` del conto **50503392** (`BCM Markets MT5 Terminal`) esteso da **27/07 a oggi**:
la sezione **Ordini** ha la colonna `S / L` al piazzamento. Con quella, il rischio d'ingresso di
tutti e nove i segnali si calcola esatto. **Sola lettura, nessun EA toccato, nessun parametro.**

⚠️ **Finché quel numero non c'è, il verdetto su `770511` è «NON ANCORA MISURATO», non «ha margine».**

---

## ⑤ 🟢 E C'È UN MECCANISMO CHE SOTTO-DIMENSIONA DAVVERO — ma si risolve da solo sulla prop

`ABTG_SuperWave.mq5` **r.550-551**:
```
lot = MathFloor(lot/st)*st;
return( MathMax(mn, MathMin(mx,lot)) );
```
**Arrotonda SEMPRE in giù.** Su U30USD i lotti totali in campo stanno fra **0,20 e 0,80**: con
uno step da 0,10, un lotto calcolato 0,29 diventa **0,20** → **−31% di rischio**. Uno da 0,19
diventa 0,10 → **−47%**.

E si vede: **otto gambe 1/3 su nove sono a 0,10 esatti** — cioè al **minimo**, non a un calcolo.

> ## 🟢 **MA su un conto da 100.000 i lotti sono ~20 volte più grandi, e uno step da 0,10 sparisce nel rumore. Questo taglio NON va corretto: si risolve da solo cambiando conto.**

📌 E il sorgente conosce già questa famiglia di guai, dal lato opposto — **r.383-390**:
*«Misurato in campo il 20/08/2026: **1,42% su un contratto da 1,0%**»*, perché il pavimento del
lotto minimo si sommava al pendente. **Fix applicato l'08/09.** Il pavimento del lotto minimo su
questa sedia ha già fatto sbagliare il rischio **in eccesso** una volta: è una manopola che morde
in tutte e due le direzioni.

---

## 📌 In una riga
**Non alzarlo al buio.** Lo 0,13% è il trailing che lavora, non una taglia timida; il rischio
d'ingresso vero **non è misurato**; e l'unico sotto-dimensionamento reale (l'arrotondamento in
giù) **scompare da solo** passando da 5.000 a 100.000 €. 🔴 **La cosa che serve è un report con
la sezione Ordini, non una percentuale più alta.**

---
*Fonti: `data/statements/trades_auto.csv` · `mql5/Experts/ABTG_SuperWave.mq5` rr.81, 371-372,
383-390, 526, 550-551 · `data/statements/ReportHistory50503392.xlsx` sezioni Ordini (r.32-118)
e Posizioni (r.6-30) · `report/PICCOLO_50503392_2026-09-09.md` per la taratura EUR/punto.*
