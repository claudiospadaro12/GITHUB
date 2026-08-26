# 🏁 R112 — REFERTO DEL ROUND: IL CONTRATTO DELL'EMADOW — **NESSUN DIAL PASSA: LA SEDIA RESTA COM'È**

_Corsa: 26/08/2026 23:05-23:09 (4,7 min di banco per 16 passate, celle
EMADOW veloci), tick reali, pin `f33f374`, `-Rifai` dopo il doppio lancio
delle 22:37 (checklist 88, archiviato in `R112_PARZIALE_20260826/`). Esito
driver: **COMPLETO CON RILIEVI, 0 guasti** — 4 celle su 4, gemelli
IDENTICI anche a livello di singolo trade (G0-C-bis), criteri FIRMATI
("FIRMO R112", 26/08 sera). Zip agli atti:
`R112_EMADOW_CONTRATTO_CORSA_20260826_2305.zip`._

## 🏛️ PRIMA IL FATTO STORICO: IL BANCO RIPRODUCE — G0-B OK, due volte

Primo G0-B applicabile della storia della macchina: metro e short@1%
hanno riprodotto i CSV di R110 **al centesimo, su tutte e 7 le colonne,
IS e OOS** — e lo hanno fatto in DUE corse indipendenti (21:00 e 23:05).
**Il banco a tick reali è deterministico E riproducibile fra corse.**
Ogni numero misurato finora su questo banco pesa di più da stasera.

## 📊 LA TABELLA MADRE (OOS; PeggGio = peggior giornata dei CHIUSI, un PAVIMENTO — il muro prop guarda il flottante)

| CELLA | OOS prof | PF | DD | n | PeggGio %fisso | PeggGio %eq | vol max |
|---|---:|---:|---:|---:|---:|---:|---:|
| 00_metro (L+S, 1%) | +23.321 | 1,524 | 7,83 | 517 | **−2,45** | −1,98 | 14,6 |
| 01_short 1% | +16.948 | 1,891 | 2,66 | 302 | −1,17 | −1,00 | 14,6 |
| 02_short 2% | +36.527 | 1,886 | 5,30 | 315 | **−2,70** | −1,99 | 30,3 |
| 03_short 3% | +58.567 | 1,873 | 7,92 | 324 | −4,72 | −3,00 | 48,4 |

(IS nel referto driver. Tetto volume: max 0,33% delle righe al massimo —
il cap NON ha morso a nessun dial su questa finestra.)

## ⚖️ IL CANCELLO DI PORTAFOGLIO (par. 6, congelato prima) — APPLICATO A MANO

| dial | (a) prof > metro | (b) DD ≤ metro | (c) PeggGio non più profonda | (d) IS > 0 | VERDETTO |
|---|---|---|---|---|---|
| 1,0 | ❌ +16.948 < +23.321 | ✅ | ✅ | ✅ | **NO** |
| 2,0 | ✅ +36.527 | ✅ 5,30 | ❌ **−2,70 più profonda di −2,45** | ✅ | **NO** |
| 3,0 | ✅ +58.567 | ❌ 7,92 > 7,83 | ❌ −4,72 | ✅ | **NO** |

**→ VERDETTO: NESSUN DIAL SUPERA IL CANCELLO. Il contratto NON cambia:
la sedia 771531 (L+S, 0,65% in campo) resta com'è.** Niente delibera.

## 🔍 LE TRE LETTURE CHE VALGONO IL ROUND

1. **Il criterio nuovo ha fatto esattamente il suo lavoro.** Il dial 2
   passava (a), (b) e (d) con margini larghi — senza la peggior giornata
   sarebbe sembrato un vincitore. La misura nuova lo ha fermato: la sua
   giornata peggiore (−2,70%) è più profonda di quella della sedia intera
   (−2,45%). **E il verdetto regge su TUTTI E DUE i denominatori**:
   anche su equity di inizio giornata fa −1,99 contro −1,98 del metro.
   Non è un cavillo di convenzione: è un no robusto.
2. **Perché lo short concentrato perde sul giorno peggiore pur avendo
   metà del DD**: nel metro, long e short si spalmano; nella cella short
   a dial alto i cluster di short dello stesso giorno (2026.03.31,
   2026.06.08, 2026.02.02 — sempre quelli) si sommano senza compensazione.
   Il DD di percorso premia lo short; **la concentrazione giornaliera lo
   punisce** — ed è la grandezza che le prop guardano.
3. **La scoperta di contabilità, MISURATA dalla riconciliazione**: il
   `n` dell'OPTFRAME (STAT_TRADES) conta i **DEAL DI USCITA**, non le
   posizioni — metro: 517 righe deal per **257 posizioni distinte**;
   short: 302/315/324 righe per **140 posizioni**. Con TP1 al 50% +
   trailing ogni posizione chiude in ~2 deal. **Vale per tutti i round di
   casa** (il metro è sempre stato STAT_TRADES, coerente fra loro), ma da
   oggi va detto: "n 302" = 302 uscite ≈ 140 posizioni. Ai criteri futuri
   la domanda: l'unità dell'Emendamento (≥150) è l'uscita o la posizione?
   Da decidere PRIMA del prossimo round che ci si gioca (qui non cambia
   nulla: il verdetto è NO per (c), non per G4).

## 📌 A REGISTRO

- **La peggior giornata della SEDIA VIVA è misurata per la prima volta:
  −2,45% fisso / −1,98% eq a dial 1,0 (in campo ×0,65: ≈ −1,6%)** —
  primo mattone del censimento dei contratti (prerequisito del 18/08).
  Le 3 peggiori del metro: 23/06/26, 23/01/26, 07/08/25.
- Magic 7634xx bruciati. Checklist 87 (segni nel referto) e 88 (pulizia
  pre-corsa che cancella le prove: pagata alle 22:37) nate in questo round.
- Il driver va corretto sulla classe 88 (pulizia per cella) prima di un
  eventuale riuso — annotato, non urgente: il round è chiuso.
- Un solo regime (21 mesi in salita), compounding misurato: worst-day
  %eq scala LINEARE col dial (−1,00/−1,99/−3,00), il %fisso super-lineare
  perché l'equity composta gonfia i lotti a fine finestra.
- Costo del round: **~5 minuti di tester** (più il doppio lancio) per
  chiudere una domanda da migliaia di euro di contratto. Il cancello
  congelato prima dei numeri ha deciso senza farsi incantare dal
  +58.567 del dial 3.
