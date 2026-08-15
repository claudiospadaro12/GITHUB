# ✅ IMPORT DEI SEI SIMBOLI — 15/08/2026: CANCELLO ZERO PASSATO 6 SU 6

_Fonte: `import_esterno.zip` da `DESKTOP-H4D7CAJ`. Feed HistData M1
2018-2024, importato come simboli `_EXT` nel terminale BCM._

## 1. La tabella, contro il cancello congelato

Cancello ZERO (`PROVA_REGIME_CRITERI.md`, congelato il 14/08):
**differenza media > 0,05% del prezzo** oppure **copertura < 80%** →
il simbolo **non si usa**.

| simbolo | barre M1 | scartate | **diff media** | diff max | **copertura** | shift | verdetto |
|---|---:|---:|---:|---:|---:|---:|---|
| `AUDJPY_EXT` | 2.558.215 | **0** | **0,0090%** | 756,0 pt | **99,6%** | +5 | OK |
| `CHFJPY_EXT` | 2.549.100 | **0** | **0,0080%** | 1.162,0 | **99,6%** | +5 | OK |
| `EURJPY_EXT` | 2.556.391 | **0** | **0,0063%** | 1.064,0 | **99,6%** | +5 | OK |
| `GBPCAD_EXT` | 2.547.121 | **0** | **0,0072%** | 3.043,0 | **99,5%** | +5 | OK |
| `XAUUSD_EXT` | 2.432.995 | **0** | **0,0110%** | 3.704,5 | **99,2%** | +5 | OK |
| `USDJPY_EXT` | 2.553.253 | **0** | **0,0054%** | 1.482,0 | **99,6%** | +5 | OK |

**Totale: 15,2 milioni di barre M1. Zero righe scartate. Zero proprieta'
guaste.**

> 🎯 **Il peggiore dei sei — XAUUSD a 0,0110% — sta CINQUE VOLTE sotto la
> soglia.** E la copertura peggiore, 99,2%, e' venti punti sopra il minimo.
> Non e' un "passa per un pelo": e' passato largo.

## 2. 🔍 Il controllo che vale piu' della tabella

**Tutti e sei hanno calibrato lo stesso shift: +5 ore.** E i due importati il
14/08 — `EURUSD_EXT` e `GBPUSD_EXT` — avevano dato **+5** anche loro.

**Otto simboli su otto, feed e giorni diversi, stesso numero.** Lo shift non
e' stato imposto da noi: lo script lo cerca da solo provando da −6 a +6 e
scegliendo quello che minimizza la differenza contro lo storico nativo BCM.
Che otto ricerche indipendenti convergano sullo stesso valore e' la prova che
la calibrazione **misura una cosa vera** (HistData e' ora di New York) e non
sta inseguendo rumore.

Se un simbolo avesse dato +4 o +6, sarebbe stato il campanello da guardare
prima di ogni altra cosa. Non e' successo.

## 3. 📋 Le celle aggiunte alla prova di regime

Parametri **copiati riga per riga dai deploy vivi**, nessuno inventato:

| cella | EA | simbolo | TF | fonte del preset |
|---|---|---|---|---|
| `EZ_CHFJPY` | ABTG_EasyTrend | CHFJPY | H1 | `deploy_vivaio_ez.ps1` (R48) |
| `EZ_AUDJPY` | ABTG_EasyTrend | AUDJPY | H1 | `deploy_vivaio_ez.ps1` (R48) |
| `COST_EURJPY` | ABTG_CostToCost | EURJPY | **H4** | `deploy_vivaio_cost.ps1` |
| `COST_GBPCAD` | ABTG_CostToCost | GBPCAD | **H4** | `deploy_vivaio_cost.ps1` |
| `LARRY_ORO` | ABTG_PunteLarry | XAUUSD | H1 | `deploy_vivaio_larry.ps1` |
| `PTE_USDJPY` | ABTG_PTE | USDJPY | H1 | `deploy_vivaio_r23.ps1` |

**Da 8 celle a 14.**

### ⚠️ Una casella resta scoperta, e va detta

**`COST_XAGUSD` non e' misurabile in questo giro**: l'import ha portato
**XAUUSD**, non XAGUSD. E' una mia svista nella scelta dei sei simboli.
Non e' un problema del feed ne' della cella: e' semplicemente **non
misurata**, e va rifatta con un import successivo.

### ✅ Verifica fatta sui default
Le tre righe EZ che il file R50 ometteva (`InpDivMaxBars`,
`InpDivDieOnFail`, `InpMarketIfTooClose`) sono state controllate nel
sorgente: i default dell'EA valgono **0, false, true**, cioe' **esattamente**
i valori del preset vivo. Quindi la cella `EZ_GBPUSD` misurata in R50 era
fedele. Nelle righe nuove le ho scritte comunque **esplicite**, cosi' un
domani un cambio di default non puo' spostare in silenzio una cella
congelata.

## 4. ▶️ Il passo dopo

**FASE 1: la prova di regime a parametri congelati**, sulle 14 celle e sulle
quattro finestre (ORSO 2022, CROLLO 2020, TORO 2021, LATERALE 2019).

Valgono i criteri **A-E** del 14/08, e in particolare il B:
_"bocciare un long-only perche' non guadagna nell'orso sarebbe un errore di
lettura; bocciarlo perche' si distrugge, no."_

**Nessun parametro degli EA in forward cambia per questi numeri.**
