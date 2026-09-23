# 🔴 LA GIORNATA PEGGIORE NON È QUELLA CHE LEGGEVAMO — quanto è largo il buco (23/09/2026)

**Misura mia, fatta a mano sul file, dopo il ritrovamento di R224 (classe 618).**
Costo: **zero minuti macchina**. Fonte unica:
`backtest_pipeline/risultati_archivio/R103_REFERTO_DRIVER_FOREX_METALLI_20260824_1922.txt`.

---

## 1. Il fatto, verificato alla cifra

Il referto R103 misura la peggior giornata in **due modi indipendenti**, e lo dichiara:

- **dai DEAL** — chiusure realizzate, percentuale sul saldo a inizio giornata. Il file stesso
  la marca `[APPROSSIMATO]` **due volte**, e scrive che *«l'errore va nella direzione COMODA
  (giornata migliore del vero)»*;
- **dall'OPTFRAME dell'EA** — la colonna `Peggior Giornata %`, che è **equity-based
  tick-per-tick**, cioè **esattamente la definizione del muro prop**.

🔴 **La TABELLA 1 — quella che tutti i referti a valle copiano — ha UNA SOLA colonna, e ci mette
la misura dai DEAL: la più comoda delle due.** La seconda sta nel blocco per-sedia, dove nessuno
l'ha letta.

Caso F04 `CostToCost EURJPY`, verbatim:

```
  74:  2    F04  CostToCost   EURJPY  1.0% ... 394   -1.57%   1/7  n=394     <- TABELLA 1
       ->  -1.57%  (il 2020.07.07, su 566 giornate operative, 788 deal)
       -> SECONDA MISURA INDIPENDENTE (dall'OPTFRAME dell'EA): -8.01%
```

**Fattore 5,1×.** E −8,01% contro un muro giornaliero prop del **5%**.

---

## 2. Quanto è largo — **tutte e 25 le sedie, contate**

| | |
|---|---:|
| sedie in TABELLA 1 | **25** |
| con **due** misure disponibili | **20** |
| in cui l'OPTFRAME è **PEGGIORE** della colonna stampata | 🔴 **13 su 20** |
| che **sfondano il muro del 5%** secondo l'OPTFRAME | 🟢 **1 sola** |

### 🟢 La buona notizia, ed è la parte che conta

**Il difetto è sistematico ma la conseguenza è UNA.** Le altre dodici sottostime stanno fra
**1,1× e 2,1×** e restano tutte **ben sotto il 5%** con tutte e due le misure: la peggiore dopo
F04 è `CostToCost GBPCAD` a −2,26%. 👉 **Nessuna sedia che credevamo dentro il muro ne esce**,
tranne quella che stavamo per promuovere.

### 🔴 La sedia colpita

| sedia | TAB 1 (deal) | OPTFRAME (equity) | fattore |
|---|---:|---:|---:|
| **`CostToCost` EURJPY** | −1,57% | 🔴 **−8,01%** | **5,1×** |

Le tre maggiori sottostime **innocue**: `EasyTrend GBPUSD` 1,7× (−2,17%) ·
`PTE GBPUSD` 1,6× (−0,86%) · `GapFill AUDUSD` 1,5× (−1,50%).
E tre casi vanno nell'altro verso (OPTFRAME **migliore**): `EasyTrend AUDJPY`, `PTE USDJPY`,
`PunteLarry EURCAD` — a 0,9×. La misura dai deal **non sbaglia sempre nella stessa direzione**,
e questo è un motivo in più per non fidarsene.

---

## 3. 🔴 E CINQUE SEDIE NON HANNO LA SECONDA MISURA — la loro giornata peggiore è `[NON MISURATA]`

Il loro EA **non ha la colonna `Peggior Giornata %` nell'OPTFRAME**, quindi di loro esiste solo
il numero comodo. Per nome:

| | sedia | simbolo | colonna stampata (dai DEAL) |
|---|---|---|---:|
| F21 | `SuperWave` | GBPUSD | −1,16% |
| F22 | `EMA200_Ottimizzato` | XAUUSD | −0,29% |
| F23 | `MaxMinNotte` | XAUUSD | −0,50% |
| F24 | `SupertrendReversal_Ottimizzato` | XAUUSD | −0,51% |
| F25 | `Gold_Ichimoku_TK_ATR_EA` | XAUUSD | −1,07% |

🔴 **Questa non è una promozione: è una casella bianca.** Applicando il fattore peggiore
osservato (5,1×) il −1,16% di `SuperWave` diventerebbe −5,9%, cioè **oltre il muro** — e il
−1,07% di `Gold_Ichimoku` diventerebbe −5,5%. 🔴 **Non sto dicendo che sfondano: sto dicendo che
non lo sappiamo**, e che il numero che abbiamo **non è quello che la prop misura**.
⚠️ E sono **quattro sedie oro su cinque**: è proprio la famiglia che R217 e R219 stavano
valutando stamattina.

---

## 4. Perché il difetto era invisibile

Non è un dato mancante: **R103 stampa tutti e due i numeri**. È un difetto di **trasporto**:
la tabella riassuntiva ne porta uno solo, e la catena di referti a valle ha copiato la tabella,
non il blocco. 👉 Il controllo che lo scopre è **una sottrazione gratis**, e nessuno l'aveva
fatta in un mese.

---

## 5. Cosa NON dice questo referto

1. **Non archivia e non promuove niente.** Sposta un numero da "letto" a "letto male", e ne
   dichiara cinque `[NON MISURATI]`.
2. **Non tocca le sedie in campo.** Le sei della challenge FTMO **non stanno in questo file**
   (R103 è forex/metalli, `INDICI 0`): il loro muro giornaliero va letto altrove, e
   **questa verifica lì non è stata fatta**.
3. **R103 gira a OHLC M1, non a tick.** Per il drawdown e per la giornata l'OHLC **sottostima**:
   anche il −8,01% è un **limite inferiore**.
4. **Non ho misurato la giornata peggiore delle cinque scoperte.** Serve una corsa con un EA che
   esponga la colonna, oppure il per-trade — e **non l'ho stimato**: il 5,1× è il fattore di
   UNA sedia, non una legge.
5. Il fattore 5,1× **non si trasporta**: negli altri 19 casi sta fra 0,9× e 2,1×.

## 6. Cosa si fa, in ordine

1. 🥇 **Quando si legge una peggior giornata da R103, si apre il BLOCCO, non la tabella.**
   Se c'è la seconda misura, decide quella.
2. 🥈 Le **cinque senza OPTFRAME** vanno marcate `[NON MISURATO]` in `REGISTRO_TEST.md`, non
   lasciate col numero comodo. *(Non ho toccato il registro: archiviare passa dal cancello.)*
3. 🥉 La stessa verifica va rifatta **sulle sei sedie FTMO in campo**, che questo file non copre.

---

*Verifica indipendente: i conti di §2 e §3 sono stati rifatti a mano sul file, non ereditati dal
referto di R224. Il fatto di partenza (F04: −1,57% in tabella, −8,01% nel blocco) è stato letto
verbatim prima di scrivere qualunque conclusione.*
