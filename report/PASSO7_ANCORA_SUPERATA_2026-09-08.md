# 🏁 PASSO 7 SUPERATO — **il quarto MT5 è la stessa macchina**

08/09/2026, ore **17:52:02**. `ESITO: ANCORA SUPERATA` · **RILIEVI: 0**.

---

## 🎯 I NUMERI, RIPRODOTTI ALLA CIFRA

Riverificati da Claude sui CSV, non solo dichiarati dallo script:

| sedia | magic | Profit | PF | DD % | Trades | |
|---|---|---:|---:|---:|---:|---|
| `ABTG_ORB_Ottimizzato` U30USD | 770611 | **2484.17** | **1.67490** | **6.5389** | **119** | ✅ |
| *(gemello di determinismo)* | 770661 | 2484.17 | 1.67490 | 6.5389 | 119 | ✅ |
| `ABTG_DAX_Apertura_EU` D30EUR | 770101 | **1103.31** | **1.41105** | **4.3501** | **270** | ✅ |
| *(gemello di determinismo)* | 770151 | 1103.31 | 1.41105 | 4.3501 | 270 | ✅ |

**Atteso e ottenuto coincidono su tutte e quattro le grandezze, per tutte e
quattro le righe.** E i gemelli tecnici sono identici fra loro: **il cancello
G1 (determinismo) passa gratis**, come da schema di casa.

## 🛡️ E il conto reale non è stato sfiorato — **stampato, non promesso**
```
PID non bersaglio PRIMA: 7824, 8664, 9780
PID non bersaglio DOPO : 7824, 8664, 9780
```

---

## ✅ COSA VUOL DIRE, in concreto

> ### I round non aspettano più che Claudio accenda il PC.
> Il VPS ha un terminale da backtest **verificato**: stesso storico, stesso
> tipo di conto, stessi numeri **alla cifra**. Da qui in avanti un round può
> girare **di notte, da solo**, e il suo risultato è confrontabile con tutto
> quello che abbiamo misurato prima.

A **23 giorni** dalla challenge, è l'unico cambiamento che moltiplica tutto il
resto: ogni candidato dell'imbuto — i 7 promossi di oggi, i 7 ripescati,
`ABTG_OpeningReversalB` mai girato — adesso ha **una macchina che lo può
misurare senza chiedere il permesso a nessuno**.

## 📋 LA CATENA DEL QUARTO MT5, CHIUSA
| passo | stato |
|---|---|
| 1-3 conto nuovo, HEDGING, zero EA | ✅ |
| 4 agenti del tester a 3 | ✅ |
| 5 storico (104 milioni di tick) | ✅ |
| 6 driver `-TerminaleBacktest` | ✅ |
| **7 ancora R119** | ✅ **SUPERATA** |
| 8 canarino sul forward | 🟡 **il prossimo**: dopo la prima notte di round si guarda se i tre terminali vivi hanno perso colpi |

## 🧾 E quanto è costato arrivarci, agli atti
**Tre tentativi**, e ogni fallimento ha lasciato un pezzo di macchina:
1. **tetto barre a 100.000** → trovato dal pre-volo in 2 secondi (classe 160:
   un'impostazione MT5 cambiata e poi il terminale ucciso a forza = persa);
2. **`error 106`, include mancanti** → il driver adesso se li porta da solo,
   su qualunque terminale nuovo (classe 161), e stampa il log di MetaEditor
   quando la compilazione fallisce;
3. e prima ancora, due difetti trovati **dal verificatore** senza spendere
   un minuto di macchina (classi 158 e 159).

👉 **Zero ore di tick reali buttate.** Ogni giro è morto in meno di un minuto,
per un motivo dichiarato, e ha prodotto un cancello nuovo.
