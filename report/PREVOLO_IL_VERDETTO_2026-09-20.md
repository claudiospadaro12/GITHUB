# 🔬 PREVOLO FTMO — IL VERDETTO. Quattro luci su cinque sono VERDI

**Fonte**: `PREVOLO_FTMO_specifiche.csv`, prodotto il **20/09/2026 alle 17:08:07** dal
terminale FTMO `541452707` (`C:\FTMO`), **a mercato APERTO** (`MercatoAperto=SI`,
scarto tick 0 s — quindi la classe 479 non morde).

---

## ✅ S2 — L'OROLOGIO: **MISURATO, E I PRESET NON SI TOCCANO**

| campo | valore |
|---|---|
| `DeltaServerGMT_hhmm` | **+03:00** |
| atteso (BCM +2, su cui sono rimappati i 10 preset) | +03:00 |
| **`Scarto_vs_atteso_hhmm`** | ✅ **+00:00** |

Era `[INFERITO]` da un regolamento letto il 13/08 e **mai misurato da noi**. Adesso è
**misurato**. 🟢 **Nessun `InpSessionHour` va toccato.**
⚠️ Resta un'assunzione dichiarata: `Assunto_BCM_UTC=+1` è la regola di casa (*ora
italiana −1*), non una misura di stasera. Il +3 di FTMO invece è misurato.

## ✅ S5 — IL BLOCCO SU `771531` E `770511` **CADE**

Il rapporto fra le due formule della perdita per lotto — e `slDist` si semplifica, quindi
si misura dal solo CSV:
```
B/A = (TickSize x ContractSize x FX) / TickValue
  GER40.cash   profitto EUR  FX=1.000000  ->  1.00000   COINCIDONO
  US30.cash    profitto USD  FX=0.870655  ->  0.99960   COINCIDONO
  US100.cash   profitto USD  FX=0.870655  ->  0.99960   COINCIDONO
```
**Controprova**: il `TickValue` è **già convertito in valuta conto**. Su GER40 (profitto
EUR, conto EUR) vale esattamente `0.01 x 1 = 0.01000`, e su US30 vale
`0.01/1.14856 = 0.008707` contro **0.00871 letto**. 🟢 **L'F7 non cambia la taglia: il
buco B9 si chiude.**

## ✅ LA LEVA È **1:100**, NON 1:15 — e cambia tutto sul margine

| simbolo | margine 1 lotto | % del conto (80.000 €) |
|---|---:|---:|
| `GER40.cash` | 506,24 € | 0,63% |
| `US30.cash` | 900,87 € | 1,13% |
| `US100.cash` | 516,94 € | 0,65% |

🔴 Tutti i conti catastrofici precedenti (**357% del conto**, `PACCHETTO_SCHIERAMENTO_PROP`
§2.2) erano su **1:15**, cioè su un'ipotesi Swing mai verificata. **Il margine non è un
problema.**

## ✅ Le due trappole silenziose: **nessuna delle due morde**
- **`Digits=2` su tutti e tre gli indici** → `InpBufferPoints` vale quello che crediamo,
  niente fattore 10.
- **`VolMin 0.01 · VolMax 1000 · VolStep 0.01`** → nessun tetto di taglia.

## ✅ Tutti e cinque i mercati **TROVATI**, candidato unico 5/5, assenti 0/5 — **XAUUSD compreso**

---

## 🔴 S3 — I NOMI SONO **TUTTI DIVERSI**, ma la correzione è gratis

| nostro preset | nome vero FTMO |
|---|---|
| `D30EUR` | **`GER40.cash`** |
| `U30USD` | **`US30.cash`** |
| `NASUSD` | **`US100.cash`** |
| `XAUUSD` | `XAUUSD` (uguale) |

🟢 **Nessun preset va cambiato**: gli EA tradano `_Symbol`, cioè **il simbolo del grafico**
— verificato, non esiste nessun parametro di simbolo operativo. **Basta aprire i grafici
giusti.**

---

## 🔴 IL PROBLEMA VERO: `770411` MAXMIN DAX SHORT HA **TRE** GUAI

**1. Lo stop è sotto la frontiera del costo, ed è l'unica sedia in cui si può MISURARE**
(le altre hanno stop ad ATR, quindi `[NON MISURATO]` dal solo preset):
```
spread FTMO GER40.cash : 143 punti = 1,43 punti indice
stop del preset        : 3000 punti = 30,00 punti indice  (InpSLFixedPts, InpSLMode=1)
frontiera di casa 40x  : 5720 punti = 57,20 punti indice
rapporto stop/spread   : 21x        -> serve >= 40x
```
🔴 **Sotto di un fattore 1,9.**

**2. `InpMaxSpread=0` = filtro di spread SPENTO** — e non solo su questa: è **0 su tutte e
sei**. Su un broker con **2,63 punti indice** di spread sul Dow, è una manopola che vale.

**3. 🔴 `InpUseCorrelation=true` che punta a `SPXUSD`, che su FTMO NON ESISTE.**
È l'unica delle sei col filtro **acceso** (le altre hanno `false`). Il codice fa
`if(c != 0) bias = ...`: se il simbolo non si legge il filtro viene **ignorato in
silenzio** — cioè la sedia girerebbe **senza il filtro con cui è stata validata**.

**4. Il lotto**: a 2,00% su 80.000 € con stop 30,0 punti fa **53,33 lotti**, cioè
**27.000 € di margine = 33,7% del conto** per una sedia sola. Non sfora il `VolMax`, ma è
un terzo del conto.

---

## 🎯 LA PROPOSTA: **CINQUE SEDIE STASERA, `770411` FUORI**

Le altre cinque non hanno nessuno dei quattro problemi: correlazione spenta, stop ad ATR
(che si adatta allo strumento), margine leggero, orologio giusto, S5 sciolto.
✍️ `770411` rientra quando Claudio firma **o** lo stop, **o** il simbolo guida corretto,
**o** la scelta di spegnere la correlazione. **Il numero c'è, la firma no.**

---

# ✏️ ERRATA DEL 20/09, SERA — **il guaio «A» di `770411` NON ESISTE. L'ho sbagliato io.**

Qui sopra ho scritto che `770411` ha lo **stop fisso a 30,00 punti indice**, e ci ho
costruito tre numeri che sono finiti in chat mentre Claudio decideva:
> ~~stop 3000 punti = 30,00 punti indice · rapporto **21×** contro una frontiera di 40× ·
> lotto **53,33** · margine **27.000 € = 33,7%** del conto~~

🔴 **Tutti e tre FALSI.** La dichiarazione vera, `ABTG_MaxMinNotte_DAX_Short_Ottimizzato.mq5` r.45:
```
enum ENUM_MM_SL { MM_SL_OPPOSITE=0, MM_SL_ATR=1, MM_SL_FIXED=2 };
```
Il preset porta `InpSLMode=1`, che è **`MM_SL_ATR`**, non `FIXED` (che è **2**). E il
codice a r.284-286 lo conferma: *se non è OPPOSITE e non è FIXED → `sl = entry ± atr ×
InpAtrSLmult`*.

👉 **Lo stop di `770411` è `ATR(14) su M15 × 2,5`**, e `InpSLFixedPts=3000` è una
**manopola INERTE**.

🟢 **E la configurazione era GIUSTA**: `REGISTRO_TEST.md` r.476 dice che la sedia è stata
promossa con *«short only, corr S&P ON, buffer 1000, **SL ATR x2.5**, TP2 3.0, rischio
1%»*. Il preset corrisponde alla promozione **riga per riga**. Il difetto stava solo nella
mia lettura.

**Conseguenza sul verdetto**: lo stop di `770411` **non è misurabile dal preset**, esattamente
come quello delle altre cinque. Esce dai guai di questa sedia ed **entra nel mandato**
dell'agente che misura stop-vs-spread sulle cinque vive.
📌 Errore archiviato come **classe 495**.

## 🔴 IL GUAIO CHE RESTA, ed è l'unico — ma è serio e adesso è **confermato due volte**

`InpUseCorrelation=true` che punta a **`SPXUSD`**, che su FTMO **non esiste**.
E la sedia è stata **promossa con quel filtro ACCESO**, da due fonti indipendenti:
- `report/CONTRATTI_SEDIE.md` r.93 — *«la promozione 26/07: PF 2,05 · DD 3,1% · 41 tr,
  **corr S&P ON**»*
- `backtest_pipeline/REGISTRO_TEST.md` r.476 — *«Promosso … short only, **corr S&P ON**,
  buffer 1000, SL ATR x2.5, TP2 3.0, rischio 1%»*

👉 Quindi **non è un errore di trascrizione**: il filtro serve. E su FTMO verrebbe
**ignorato in silenzio** (`if(c != 0) bias = …`), facendo girare **una sedia diversa da
quella misurata**.

## 📄 E IL CONTRATTO DELLA SEDIA, per decidere con tutto davanti
| | |
|---|---|
| DD promesso | **1,27%** a 1,0% (R16) → **2,54%** a 2,00% · la corsa di promozione: **3,1%** con n=41 → 6,2% a 2,00% |
| PF | **2,05** (promozione 26/07, n=41) |
| Frequenza | 🔴 **~1,7 operazioni al MESE** (21 trade in 12,6 mesi) — è un cecchino, non un motore |
| Forward BCM | **9 posizioni, 9 vinte, 0 perse** (+155,78 € sul piccolo, +1.565,49 € sul 100k) — ⚠️ **n=9 non dice niente**: questa sedia **non ha ancora mostrato la sua distribuzione delle perdite** |
