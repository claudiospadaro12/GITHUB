# 🎯 REFERTO R59 — L'EMENDAMENTO FUNZIONA: da **1 cella giudicabile a 7**

_15/08/2026. 14 celle × **5** finestre = **70 CSV su 70**, igiene gemelle
**70/70**. Stesse celle, stessi parametri, stesso feed di R56: l'unica cosa
aggiunta e' la finestra **CROLLO_ANNO** (2020 intero), per l'emendamento E.6._

**Le quattro finestre vecchie riproducono R56 al centesimo.** Il confronto e'
quindi pulito: cambia solo cio' che si e' aggiunto.

---

## 1. 📐 IL PUNTO: quante celle si possono davvero giudicare

| finestra usata per il MERITO | celle con **n ≥ 20** |
|---|---|
| CROLLO (feb-apr 2020) — *come in R56* | **1** su 14 |
| **CROLLO_ANNO (2020 intero)** — *nuova* | **9** su 14 |
| **entrambe le avverse giudicabili** (ORSO **e** CROLLO_ANNO) | **7** su 14 |

> **Da UNA cella giudicabile a SETTE.** L'emendamento non ha abbassato
> nessuna soglia: ha dato al test un campione su cui le soglie significano
> qualcosa.

---

## 2. 🔄 DUE VERDETTI SI RIBALTANO — e uno e' esattamente quello che temevi

### 🟢 `COST_EURJPY` — era condannata da 23 trade, ora passa

| finestra | n | PF | profit |
|---|---:|---:|---:|
| ORSO 2022 | 43 | **2,65** | **+47.260** |
| CROLLO (3 mesi) | 23 | **0,02** | −12.711 |
| **CROLLO_ANNO** | **67** | **1,69** | **+20.882** |

In R56 il crollo di tre mesi (PF 0,02) la fermava. **Sull'anno intero recupera
tutto e chiude a +20.882 con PF 1,69, su 67 operazioni.**

- ✅ **Criterio B** (PF ≥ 0,90 nelle avverse): 2,65 e 1,69 → **passa**
- ✅ **Criterio C** sul PF (≥ 1,10 nell'orso): **2,65** → passa
- ⚠️ **Criterio A da verificare**: il DD e' **14,3% / 16,6%** — sotto il tetto
  assoluto del 20%, ma **il confronto col "doppio del DD OOS originale" non
  l'ho fatto**, perche' quel numero non l'ho trovato in archivio. **Finche'
  non lo misuro, la promozione di rango NON e' dichiarata.**

> 🎯 **Questa e' la cella che stavamo per scartare per un campione sbagliato.**
> Era esattamente la tua preoccupazione, e adesso ha un nome e dei numeri.

### 🔴 `PTE_USDJPY` — il ribaltamento nell'altro senso

| finestra | n | PF |
|---|---:|---:|
| ORSO | 46 | 0,81 |
| CROLLO (3 mesi) | **7** | **2,08** |
| **CROLLO_ANNO** | **52** | **0,72** |

In R56 avevo scritto *"le due finestre dicono il contrario"*. **Non si
contraddicevano: una delle due era rumore.** Quel PF 2,08 stava su **sette
operazioni**; sull'anno intero, con 52, fa **0,72**.

**Adesso le due finestre avverse concordano, ed e' un no.** B fallisce in
entrambe, su campioni pieni.

## 3. ✅ Due verdetti sospesi diventano CONFERMATI

| cella | prima | CROLLO_ANNO | ora |
|---|---|---|---|
| `EZ_CHFJPY` | sospeso (n=9) | PF **0,72** su **n=40** | ❌ tenuta persa, **confermata** |
| `EZ_GBPUSD` | sospeso (n=10) | PF **0,76** su **n=35** | ❌ tenuta persa, **confermata** |

E `COST_GBPCAD` resta **declassato**, ora su base piena: orso PF 0,61 (n=48),
DD **18,9%**.

## 4. 🔍 `PTE_GBPUSD`: la terza conferma indipendente

**Nell'ORSO ha n=18. Sotto la soglia dei 20.**

Quindi la promozione di rango di R56 poggiava su una finestra **non
giudicabile** — e questo si aggiunge, indipendentemente, alle altre due
smentite: il modello (R57) e il campione del crollo (n=11).

> **Tre controlli diversi, tre volte lo stesso esito.** Nessuno dei tre era
> stato costruito per confermare gli altri.

Sull'anno 2020 intero fa PF 1,01 su n=35: **non sanguina, non brilla.**

## 5. 📋 La tabella dei verdetti, dopo l'emendamento

| cella | ORSO | CROLLO_ANNO | esito |
|---|---|---|---|
| `COST_EURJPY` | 2,65 (43) | **1,69 (67)** | 🟢 **B e C passati** — promozione **sospesa al criterio A** |
| `EZ_AUDJPY` | 0,93 (35) | 0,99 (41) | ✅ **tiene** (non sanguina) |
| `SW_GBPUSD` | 0,96 (51) | **0,86** (69) | 🟡 B mancato **per 4 centesimi**, su campione grande |
| `EZ_CHFJPY` | 0,98 (30) | **0,72** (40) | ❌ tenuta persa, confermata |
| `EZ_GBPUSD` | 0,99 (32) | **0,76** (35) | ❌ tenuta persa, confermata |
| `PTE_USDJPY` | **0,81** (46) | **0,72** (52) | ❌ B fallito in **entrambe** |
| `COST_GBPCAD` | **0,61** (48) | 0,97 (63) | 🔴 **declassato** (B + DD 18,9%) |
| `PTE_GBPUSD` | — **n=18** | 1,01 (35) | 🟡 orso non giudicabile |
| `LARRY_GBPUSD` | — n=12 | **0,35** (20) | 🟡 orso sospeso; 2020 negativo su campione al limite |
| `BB_GBPUSD` | — n=8 | — n=19 | ⬜ sospeso su entrambe |
| `BB_EURUSD` · `LARRY_ORO` | n=7 · n=2 | n=4 · n=8 | ⬜ **non misurate** |
| `GAP_EURUSD` · `GAP_GBPUSD` | 0 trade | 0 trade | ⬜ **non misurabili su questo feed** |

## 6. ⚠️ Un buco nei criteri, dichiarato e NON riempito adesso

`PTE_USDJPY` fallisce **B in entrambe** le finestre avverse, ma con DD bassi
(5,4% e 3,7%). I criteri congelati prescrivono il **declassamento** solo
tramite **A**, che parla di drawdown. **Per questo caso — "non tiene, ma non
fa male" — non e' prescritta nessuna azione automatica.**

Lo scrivo e lo lascio aperto: **un criterio non si inventa dopo aver visto i
numeri.** Se va colmato, si fa **prima** del prossimo round, per iscritto,
come abbiamo fatto oggi col campione minimo.

## 7. ▶️ Cosa resta

1. **Misurare il DD OOS originale di `COST_EURJPY`** — e' l'unico numero che
   separa quella cella da una promozione di rango.
2. **R58: PTE a tick reali su BCM** — serve la data d'inizio storico misurata.
3. **Gli INDICI**: tutta la fascia grossa e' ancora fuori. Dukascopy dal 2012,
   Pepperstone da misurare a mercato aperto.

**Nessun parametro degli EA in forward e' stato toccato.**
