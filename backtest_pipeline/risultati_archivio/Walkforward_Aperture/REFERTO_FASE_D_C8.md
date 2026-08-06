# FASE D (C8) — la geometria del RETEST

06/08/2026 · `walkforward_aperture.ps1 -SoloRetest` · **80 pass** a tick reali
`InpEntryMode=2`, volumi OFF, slippage 0 · range 5/15/25/35/45 × buffer 100/300/500/700
IS 26/09/2024→30/06/2025 (9.1 mesi) · OOS 01/07/2025→30/06/2026 (12 mesi)

---

## Il risultato: due motori diversi dicono la stessa cosa sul DAX

Griglia OOS, stesso periodo, stessa gestione, **due meccanismi d'ingresso completamente diversi**
— il breakout appoggia un ordine STOP oltre il livello, il retest mette un LIMIT sul livello rotto
e viene eseguito solo se il prezzo ci torna:

| range | buf 100 | buf 300 | buf 500 | buf 700 |
|---:|---|---|---|---|
| | *brk / ret* | | | |
| 5 | −113 / −1417 | −1313 / −1825 | −1001 / −1016 | −1614 / −1803 |
| 15 | −609 / −1537 | −1464 / −1408 | −1015 / −534 | −878 / −750 |
| 25 | −417 / −592 | −743 / **+47** | −644 / **+202** | −836 / −77 |
| **35** | **+170 / +44** | **+18 / +356** | **+794 / +1039** | **+445 / +836** |
| **45** | **+743 / +694** | **+494 / +594** | **+1018 / +896** | **+387 / +109** |

**Stesso segno in 18 celle su 20.**

| zona | BREAKOUT | RETEST |
|---|---|---|
| range 35–45 | **+4068.97**, positive **8/8** | **+4567.48**, positive **8/8** |
| range 5–15 | −8007.23, positive **0/8** | −10291.20, positive **0/8** |

Questo e' il punto della giornata. Il confine dei 35 minuti non e' una caratteristica del motore
breakout: **e' una caratteristica della mattina del DAX.** Sotto i 35 minuti si perde comunque si
entri; sopra si guadagna comunque si entri. Un motore che non ha niente in comune col primo, sullo
stesso periodo, ridisegna la stessa mappa.

Nella zona buona il retest e' anche leggermente **migliore** del breakout — piu' profitto (+4567
contro +4069) e **drawdown piu' basso in 6 celle su 8**:

| cella | BREAKOUT | RETEST |
|---|---|---|
| 35/500 | +794.07 · PF 1.136 · DD 13.82% · n=240 | **+1038.60 · PF 1.198 · DD 12.01% · n=234** |
| 35/700 | +445.22 · PF 1.076 · DD 16.14% | **+835.90 · PF 1.176 · DD 13.94%** |
| 45/500 | **+1018.12** · PF 1.172 · DD 10.84% | +896.13 · PF 1.168 · **DD 8.79%** |
| 45/100 | +742.60 · PF 1.114 · DD 10.73% | +693.98 · PF 1.113 · **DD 9.53%** |

**Centro dell'altopiano: range 35–45, buffer 500.** E' l'unica colonna dove tutti e due i motori
stanno sopra PF 1.16 in tutte e due le righe.

---

## ⚠️ Il campione NON serve a scegliere. Terza conferma.

| test | Spearman IS→OOS |
|---|---:|
| Dow walk-forward (05/08) | **−0.357** |
| DAX retest, questa griglia | **−0.277** |
| Nasdaq retest, questa griglia | +0.042 |

Sul DAX la miglior cella in campione e' **range 35 / buffer 100 (+1308.64)**, che fuori campione
fa **+43.80** — la peggiore di tutto l'altopiano. E l'intera riga range 45, che in campione e'
**0/4 positiva**, fuori campione e' **4/4**.

**Quindi la regola "si sceglie sull'IS e si verifica sull'OOS" qui non funziona**: applicata alla
lettera porta sulla cella sbagliata. Non e' un difetto del metodo, e' un'informazione: con 9 mesi
e 180 trade per cella, **il campione non ha abbastanza segnale per ordinare celle vicine**.
Quello che sopravvive non e' la cella, e' la **regione** — e la regione va confermata con qualcosa
che non sia il periodo, perche' il periodo l'abbiamo gia' consumato.

**Onesta' sul metodo, e conta piu' del numero:** la zona 35–45 e' stata scelta guardando l'OOS
della FASE A. Confermarla con l'OOS della FASE D **non e' una verifica fuori campione** — e' lo
stesso periodo. E' una verifica **fuori-motore**, che e' una cosa diversa e piu' debole.
Vale come prova che non e' un artefatto dell'ingresso; **non** vale come prova che reggera' nel
2026-27. L'unica verifica veramente indipendente rimasta e' il forward.

---

## Nasdaq: il candidato di ieri non regge

| range | buf 100 | buf 300 | buf 500 | buf 700 |
|---:|---|---|---|---|
| 5 | −290 | −633 | −931 | −978 |
| 15 | −1391 | −1858 | −991 | −959 |
| 25 | −1637 | −2032 | −1424 | −1263 |
| 35 | **+275** | −194 | −198 | −367 |
| 45 | +0.01 | −421 | −437 | −585 |

**2 celle positive su 20 fuori campione**, e una delle due e' **+0.01 €** — cioe' zero.
In campione: 1 su 20 (+6.21). Nessuna regione, nessun gradiente, nessun altopiano.

**E qui devo correggere quello che ho scritto ieri.** La FASE B dava `RETEST volumi OFF` positivo
fuori campione su **due** mercati (DAX +392.96, Nasdaq +218.98) e l'avevo chiamato "l'unico
candidato che passa la regola dei due mercati". Quel +218.98 era misurato a **buffer 200**, che in
questa griglia sta esattamente **fra +275 (buffer 100) e −194 (buffer 300)**.

Non e' un altopiano: e' un crinale largo un parametro. **Una cella positiva circondata da celle
negative non e' un edge, e' dove e' caduta la monetina.**

Verdetto corretto: **il RETEST passa sul DAX, non sul Nasdaq.**

Il Nasdaq d'apertura ha ora fallito **tre test indipendenti** — geometria del breakout (19 celle
negative su 20), costo (20 su 20), geometria del retest (18 su 20). In modalita' `RANGE_OPENING`
la linea e' da chiudere. Resta una sola cosa mai misurata: **`RangeMode=2`**, la candela H1
precedente, che e' quello che gira davvero in forward (C6).

---

## Cosa fare adesso

1. **DAX: portare l'apertura a range 40, buffer 500.** Vale sia col breakout sia col retest; il
   retest ha il drawdown piu' basso, e in piu' non lascia un ordine STOP appoggiato al livello —
   che e' il difetto che in forward ci e' costato 4 sweep in 3 giorni.
   *Non e' ancora un via libera*: prima serve la FASE C (slippage) sul retest, perche' finora il
   costo l'abbiamo misurato solo sul breakout.
2. **FASE C sul retest.** Il retest entra con un LIMIT, quindi lo slippage lo tocca meno del
   breakout — ma va misurato, non dato per buono.
3. **Nasdaq: C6, `RangeMode=2`.** Ultima cosa non misurata prima di spegnere la linea.
4. **Smettere di usare l'IS per scegliere fra celle vicine.** Tre misure su tre dicono che non e'
   predittivo a quel livello di dettaglio. Serve per dire se una regione esiste, non quale cella
   della regione e' la migliore.
