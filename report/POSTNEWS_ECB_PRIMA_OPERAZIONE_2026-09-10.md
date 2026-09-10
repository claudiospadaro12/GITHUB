# 🎬 POSTNEWS ECB — **LA PRIMA OPERAZIONE IN ASSOLUTO**, e un numero che non torna

**10/09/2026, ore 15:00:00 italiane (14:00:00 ora server).** Conto **DEMO piccolo
50503392**, grafico **EURJPY M5**, magic **771201**.

```
15:00:00.173  [PostNews] BUY  STOP @ 179.230  SL 178.980  TP 179.730  lot 0.58
15:00:00.211  [PostNews] SELL STOP @ 178.981  SL 179.231  TP 178.481  lot 0.58
```

🎯 **173 e 211 millisecondi** dopo l'apertura della barra d'azione. La sedia era
ferma da mesi perche' il calendario non c'era: oggi ha sparato al millisecondo
giusto.

---

## ✅ LA GEOMETRIA E' ESATTA — ricontata sui prezzi veri

| | valore | atteso | |
|---|---|---|---|
| BUY: distanza SL | 179,230 − 178,980 = **0,250** | 25 pip | ✅ |
| BUY: distanza TP | 179,730 − 179,230 = **0,500** | 50 pip | ✅ |
| SELL: distanza SL | 179,231 − 178,981 = **0,250** | 25 pip | ✅ |
| SELL: distanza TP | 178,981 − 178,481 = **0,500** | 50 pip | ✅ |
| **rapporto rischio/rendimento** | **2:1** | 2:1 | ✅ |

E il **range** da cui nascono: BUY = max + 3 pip → **max 179,200**; SELL =
min − 3 pip → **min 179,011**. Range delle due candele M5 delle 14:50-15:00
italiane = **18,9 pip**.

---

# 🚨 MA IL LOTTO NON TORNA — **0,58 dove ne calcolo 0,25**

## Il conto, con i numeri del broker (non a memoria)
Dalla sonda `215D85D7_ABTG_InfoBroker.csv`, riga `EURJPY`:
`ContractSize 100.000` · `TickSize 0,001` · `TickValue 0,54147` (al cambio del
17/08; a EURJPY 179,1 di oggi diventa **0,5583 EUR** per 0,001).

`LotByRisk()` (sorgente r.476-499) fa:
```
risk       = ACCOUNT_BALANCE x InpRiskPercent / 100
slDist     = InpRiskRefSLpips x pip = 50 x 0,01 = 0,50
lossPerLot = 500 tick x 0,5583 = 279,2 EUR
lot        = risk / lossPerLot
```
Con **bilancio 5.427,56 EUR** (letto a schermo) e **`InpRiskPercent = 1.3`**
(letto nel pannello F7 alle 13:59, su tutte e tre le sedie):

> **risk = 70,56 EUR → lot = 70,56 / 279,2 = 0,25**

🔴 **Il lotto piazzato e' 0,58: 2,3 volte tanto.**
E 0,58 e' esattamente il lotto che verrebbe fuori con **`InpRiskPercent ~ 2,9-3,0`**
(157 EUR / 279,2 = 0,56-0,58).

## 📉 Cosa vuol dire in rischio vero
Una gamba stoppata a **25 pip** con **0,58 lotti**:
> 0,58 x 250 tick x 0,5583 = **80,9 EUR = 1,49% del conto**

contro lo **0,65% promesso stamattina nel contratto**, scritto PRIMA di armare.
🔴 **E' 2,3 volte il contratto**, ed e' esattamente la clausola di RISCHIO che
avevo scritto: *"se il DD forward supera lo 0,65% per evento promesso qui →
revisione IMMEDIATA, a qualunque n"*.

## ⚖️ MA NON LO DICHIARO ANCORA COME FATTO — ecco cosa manca
Il conto sopra e' **aritmetica su parametri letti**, non una misura del P/L. Le
strade per cui potrei sbagliarmi io, dichiarate:
1. il **TickValue** che uso e' del 17/08, riscalato a mano al cambio di oggi;
2. il **bilancio** l'ho letto da uno screenshot, non da `ACCOUNT_BALANCE`;
3. `OrderCalcProfit` (che il codice usa **prima** del tick value) potrebbe dare
   un `lossPerLot` diverso da quello che calcolo io.

> ## 🎯 **E la verita' arriva da sola, oggi.**
> Se una gamba si riempie e va a stop, la **perdita in euro** e' la misura
> definitiva: **~35 EUR** se il contratto e' rispettato (0,65%), **~81 EUR** se
> ho ragione io (1,49%). Non serve discutere: **si legge nel conto.**
> E' lo stesso metodo del 09/09, quando il rischio del piccolo fu ricavato dai
> P/L veri (predetto −4,82 EUR, riportato −4,84).

🟢 **E' un conto DEMO**: qui non ci sono soldi veri in gioco. Ma il difetto, se
confermato, **e' della stessa famiglia sulle sedie che andranno in prop** — ed e'
per questo che va chiuso adesso e non a ottobre.

---

## 👀 COSA GUARDARE STASERA, in ordine
1. 💰 **il P/L della gamba chiusa** → risolve la questione del lotto, in euro;
2. 🔁 **l'OCO ha cancellato l'altra gamba** appena la prima si e' riempita?
   (il documento PS5 misura **57% di inversione sul DAX**: qui e' un caso vero);
3. 📏 **lo spread al momento del riempimento** — il numero che manca a tutta la
   flotta, e oggi c'e' una conferenza stampa BCE a fornirlo;
4. 🎯 **lo slippage** in ingresso e in uscita.

## 📌 E una cosa che ha funzionato e va detta
`InpRestrictToNews=true` + calendario con **UTILI 1** + barra d'azione alle
14:00 server = **ordini piazzati in 173 ms**. La catena, dal file CSV scritto a
mano al pendente sul mercato, **ha funzionato al primo colpo**. Il difetto e'
nella **taglia**, non nel meccanismo.
