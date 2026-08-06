# FASE E (C11) — il riempimento realistico del retest

06/08/2026 · `walkforward_aperture.ps1 -SoloRiempimento` · **40 pass** a tick reali
`InpEntryMode=2`, volumi OFF, **buffer 500** (centro dell'altopiano di FASE D)
range 5/15/25/35/45 × `InpRetestOffsetPts` 0/100/200/300 · periodo **INTERO** 26/09/2024→30/06/2026

**Non e' un test di slippage.** `InpSlippagePts` e' usato solo dentro `TryPlaceBreakout`
(righe 709 e 733): sul retest non ha effetto, e ha senso — un LIMIT non puo' riempirsi peggio del
suo prezzo. L'ottimismo del retest e' un altro: **il tester riempie appena il prezzo TOCCA il
livello**, mentre il livello rotto e' il prezzo piu' affollato del grafico e per essere eseguiti
serve che ci passi attraverso. `InpRetestOffsetPts` sposta il LIMIT piu' in dentro e pretende un
ritorno piu' profondo.

---

## DAX — il cancello e' passato

| range | offset 0 | offset 100 | offset 200 | offset 300 |
|---:|---|---|---|---|
| 5 | −1587.45 · pf 0.872 | −2604.30 · pf 0.786 | −2904.51 · pf 0.759 | −2282.48 · pf 0.818 |
| 15 | −218.15 · pf 0.980 | −364.03 · pf 0.968 | −1336.03 · pf 0.880 | −1156.09 · pf 0.898 |
| 25 | +387.22 · pf 1.038 | +471.41 · pf 1.045 | +135.57 · pf 1.014 | +492.40 · pf 1.048 |
| **35** | **+1042.80 · pf 1.107** | **+1284.62 · pf 1.131** | **+1364.89 · pf 1.144** | **+1594.76 · pf 1.176** |
| 45 | +72.42 · pf 1.007 | −11.90 · pf 0.999 | +280.57 · pf 1.029 | +738.02 · pf 1.080 |

**Range 35: positivo a tutti e quattro i livelli, e cresce in modo monotono.**
Non degrada sotto l'ipotesi pessimistica: **migliora**.

| | offset 0 | 100 | 200 | 300 |
|---|---|---|---|---|
| trade | 409 | 403 | 401 | **393** |
| DD | 12.01% | 12.11% | 11.83% | 7.28% |
| Sharpe | 3.67 | 4.56 | 5.01 | 5.89 |

### La riga che risponde davvero alla domanda: 409 → 393 trade

Pretendendo un ritorno **300 punti piu' profondo** si perdono **16 riempimenti su 409, il 3.9%**.
Questa e' la misura del rischio di non-esecuzione, ed e' piccola: quando il prezzo torna sul
livello rotto, **ci passa attraverso**, non lo sfiora e basta. Era esattamente il dubbio che
questo test doveva sciogliere, e la risposta e' che **l'edge non dipende da riempimenti
ottimistici del tester.** Cancello passato.

### ⚠️ Ma il miglioramento NON e' merito del realismo — e va detto

L'offset non e' un puro filtro sui riempimenti: **cambia anche la geometria del rischio.**
Per un BUY: `entry = livello − offset`, mentre lo `SL` resta sul bordo opposto del range.
Spostando l'entry verso il basso **la distanza dallo stop si accorcia**; a rischio fisso 1% il
lotto cresce, e il TP (entry + dist × 1.5R) si avvicina.

Quindi la colonna offset mescola due effetti:
1. **meno riempimenti** (il realismo) → −3.9% di trade,
2. **stop piu' stretto, size maggiore, target piu' vicino** (geometria nuova) → tutto il resto.

Il +552 € fra offset 0 e offset 300 e' quasi tutto (2), non (1). **Non si puo' quindi dire "il
realismo migliora il sistema": si puo' dire "il realismo non lo peggiora, e per strada abbiamo
trovato una geometria di stop migliore che va misurata a parte."**

---

## Coerenza con il test di ieri — il pezzo di controllo

La FASE D girava a buffer 500 e offset 0 su due finestre separate; la FASE E gira la stessa
configurazione sul periodo intero. Devono coincidere.

| range | IS(D) + OOS(D) | FULL(E, offset 0) | scarto |
|---:|---:|---:|---:|
| 5 | −1632.55 | −1587.45 | +45.10 |
| 15 | −223.79 | −218.15 | +5.64 |
| 25 | +410.98 | +387.22 | −23.76 |
| **35** | **+1033.55** | **+1042.80** | **+9.25** |
| 45 | +179.39 | +72.42 | −106.97 |

Scarti dell'ordine dell'1%, spiegabili col fatto che in un giro continuo il lotto si calcola su un
saldo che cambia mentre in due giri separati riparte. **Le due misure sono coerenti**: la pipeline
non sta inventando niente.

---

## NASDAQ — quarto fallimento indipendente

| range | offset 0 | 100 | 200 | 300 |
|---:|---|---|---|---|
| 5 | −2983.53 | −3192.10 | −3122.22 | −3276.73 |
| 15 | −2329.45 | −2278.69 | −2248.25 | −1659.68 |
| 25 | −2082.69 | −1927.97 | −1827.96 | −1275.11 |
| 35 | −1042.09 | −824.33 | −843.10 | **+9.93** |
| 45 | −1481.25 | −1124.22 | −994.07 | −883.27 |

**1 cella positiva su 20, e vale +9.93 € (PF 1.001).** E' zero.

Il conto complessivo sul Nasdaq d'apertura in `RANGE_OPENING`:

| test | esito |
|---|---|
| FASE A — geometria del breakout | 19 celle negative su 20 fuori campione |
| FASE C — costo | 20 su 20 negative |
| FASE D — geometria del retest | 18 su 20 negative |
| FASE E — riempimento | 19 su 20 negative |

Quattro test indipendenti, quattro bocciature. **La linea Nasdaq d'apertura in modalita' OPENING
va chiusa.** Resta una sola cosa mai misurata: `RangeMode=2` (candela H1 precedente), che e' quello
che gira davvero in forward. E' l'ultima chance, ed e' C6.

---

## Dove siamo, sul DAX

| cancello | esito |
|---|---|
| 1 · fuori campione | ✅ FASE A: 8/8 celle positive nella zona 35–45. FASE D: idem col retest |
| 2 · robustezza di vicinato | ✅ due motori diversi, stesso segno in 18 celle su 20 |
| 3 · costo / realismo | ✅ breakout regge lo slippage (FASE C); retest perde il 3.9% dei riempimenti e resta positivo (FASE E) |
| 4 · forward | ❌ mai fatto |

**Configurazione da portare avanti: RETEST · range 35 · buffer 500 · offset 200.**
Offset 200 e non 300 di proposito: il profitto cresce in modo monotono ma il DD del 7.28% a
offset 300 e' un salto isolato (i vicini stanno a 11.8 e 12.1), e un singolo numero molto meglio
dei vicini si tratta come fortuna finche' non si ripete. Il 200 sta dentro l'altopiano su tutte e
due le dimensioni.

### Prima di accendere qualunque cosa in forward, due conti da fare

1. **Il drawdown va raddoppiato.** Tutti questi numeri sono a **rischio 1%**; in forward si rischia
   il **2%**. Un DD dell'11.8% diventa circa il **24%**. Con una regola prop questo e' il vincolo,
   non il profitto.
2. **La gestione testata non e' quella accesa.** Qui: TP 1.5R, niente parziale, niente breakeven,
   trailing base candela M5. In forward: TP 3R + parziale 50% + stop in pari. Sono due sistemi
   diversi (`report/AUDIT_live_vs_backtest.md`, voce B1). **Nessuno di questi numeri descrive
   l'EA acceso** finche' quel confronto non e' fatto.

---

## Cosa aggiungere alla lista

- **C12 — la geometria dello stop del retest.** L'offset ha mostrato che accorciare lo stop e
  avvicinare il target migliora il sistema, ma qui l'effetto e' confuso con quello sui
  riempimenti. Da separare: `InpSLMode` / `InpAtrSlMult` / `InpTP1_R` a offset fisso.
- **C6 — Nasdaq `RangeMode=2`.** Ultima misura prima di spegnere la linea.
- **B1 — rifare il candidato con la gestione ACCESA** (TP 3R + parziale + BE, rischio 2%).
  Senza questo non si puo' dire niente sull'EA che gira.
