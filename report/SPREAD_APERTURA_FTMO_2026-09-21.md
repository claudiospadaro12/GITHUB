# 💸 LO SPREAD ALL'APERTURA SU FTMO — prima misura viva

**Fonte**: `SPREADLOGGER_RACCOLTA_20260921_0950.zip`, prodotto da
`RIGA_SPREADLOGGER_RACCOLTA.ps1` v6 (pin `582341cd`) sul terminale FTMO.
**Identita' verificata dal file di stato**: `conto 541452707 @ FTMO-Server4` — il controllo
d'identita' della **classe 511**, scritto stanotte, ha confrontato e **non ha accusato**.
**Doppio conto**: *«OK: 50 righe confrontate, ZERO differenze fra il conto dell'EA (MQL5) e
il ricalcolo di questa riga (PowerShell)»*.
**Campioni**: 35.092 validi, passo 5 s, dalle 01:05 alle 10:50 **ora server**.

🟠 **`GG = 1` su tutte le righe: il referto le marca SOTTILE, ed e' giusto.** Quello che segue
e' un **ordine di grandezza su una giornata**, non una statistica. La misura si chiude
**venerdi' 25/09** con cinque giornate.

---

## ⓪ 🎯 LA RISPOSTA IN UNA RIGA

🟢 **Il prevolo REGGE: all'apertura lo spread e' PIU' STRETTO di quello misurato a mercato
chiuso, non il doppio.** Nessuna sedia va toccata per motivi di costo.

---

## ① 📊 IL CONFRONTO COL METRO DICHIARATO PRIMA

Numeri in **punti MT5** (1 punto indice = 100 punti MT5), ora **10 server** = apertura DAX
09:00 italiane.

| simbolo | prevolo 20/09 (mercato **CHIUSO**) | mediana ora 10 | **P95 ora 10** | verdetto |
|---|---:|---:|---:|---|
| `GER40.cash` | 143 | **123** | **133** | 🟢 **piu' stretto del 7%** |
| `US30.cash` | 263 | **210** | **248** | 🟢 **piu' stretto del 6%** |
| `US100.cash` | 153 | **145** | **165** | 🟢 in linea (+8% sul P95) |
| `XAUUSD` | 47 | **45** | **45** | 🟢 in linea |
| `US500.cash` | — | **60** | **60** | 🟢 fisso come un muro |

🧪 **Il contro-esempio era dichiarato prima**: *«se il P95 e' il doppio, `InpMinStopPts` si
rifa' oggi»*. **Non e' il doppio: e' MENO.** L'ipotesi alternativa e' caduta dalla parte
buona.

---

## ② 🌙 E LA NOTTE COSTA 2,5 VOLTE L'APERTURA

| `GER40.cash` | mediana | P95 |
|---|---:|---:|
| **notte 0-7 srv** | **303** | **373** |
| ora 09 (pre-apertura) | 143 | 233 |
| **ora 10 (apertura)** | 🟢 **123** | 🟢 **133** |
| tutta la giornata | 293 | 369 |

👉 **Lo spread del DAX si stringe di 2,5 volte appena apre il cash.** Chi opera di notte su
quel simbolo paga un pedaggio che di giorno non esiste — e la media giornaliera (293) **non
descrive nessuno dei due momenti**.

---

## ③ 📐 LA FRONTIERA DEL COSTO, calcolata sui numeri veri

Regola di casa: **`stop >= 40 x spread`**. Usando il **P95 dell'ora di apertura**:

| simbolo | P95 (punti MT5) | pavimento **40x** (punti MT5) | in punti indice |
|---|---:|---:|---:|
| `GER40.cash` | 133 | **5.320** | 53,2 |
| `US30.cash` | 248 | **9.920** | 99,2 |
| `US100.cash` | 165 | **6.600** | 66,0 |

### 🔴 E qui c'e' il rilievo vero della giornata: **i pavimenti configurati sono INERTI**

| sedia | `InpMinStopPts` oggi | pavimento richiesto | |
|---|---:|---:|---|
| `770101` DAX | **0.0** *(spento)* | 5.320 | 🔴 nessun pavimento |
| `770202` Dow | **500.0** | 9.920 | 🔴 **20 volte sotto** |
| `770260` Nasdaq | **500.0** | 6.600 | 🔴 **13 volte sotto** |

🟠 **Cosa NON dico**: non dico che le sedie stiano operando con stop troppo stretti. Gli stop
veri di queste tre nascono dal **range** dei primi 35 minuti, che vale tipicamente 40-80 punti
indice = 4.000-8.000 punti MT5 — cioe' **intorno alla frontiera, non venti volte sotto**.
👉 **Il difetto e' che il pavimento a 500 non puo' mordere MAI**: e' una rete tesa sotto il
pavimento. Non e' pericoloso di per se', ma **non ci protegge da niente**, e noi credevamo di
averla.

🔴 **Quanto gli stop veri stiano davvero sopra la frontiera e' `[NON MISURATO]`**: si legge
dalle prime operazioni vere, non da qui.

---

## ④ 🖊️ COSA ASPETTA UNA FIRMA (nessuna urgenza)

> **Portare `InpMinStopPts` ai valori misurati** — `770101` da 0 a ~5.300, `770202` da 500 a
> ~9.900, `770260` da 500 a ~6.600 — **oppure lasciarli inerti e dichiararlo.**

🟠 **Non lo propongo per oggi.** Sono numeri di **una giornata sola** (`GG=1`), e alzare un
pavimento fa **saltare operazioni**: su una challenge che deve fare 4 giornate di trading,
saltare ingressi ha un costo. 👉 **La proposta giusta e' venerdi' 25/09**, con cinque giornate
e con le prime operazioni vere in mano per sapere dove stanno gli stop davvero.

---

## ⑤ 🕳️ COSA QUESTA MISURA NON COPRE
1. 🔴 **`GG = 1`**: una giornata. Tutto quanto sopra e' un ordine di grandezza.
2. 🔴 **L'apertura USA non c'e'**: la fascia `cash USA 16-22 srv` dice *«nessun campione»* —
   il giro e' stato lanciato alle 10:50 server, prima che gli USA aprissero. Si chiude col
   secondo giro delle 16:00 italiane.
3. 🟠 **Qui non c'e' lo slippage**, non ci sono commissioni ne' swap: **e' spread e basta**.
4. 🟠 **18.418 campioni scartati** perche' il tick era vecchio (mercato fermo): e' il
   comportamento voluto, ma vuol dire che le ore notturne e serali sono coperte in modo
   irregolare.
