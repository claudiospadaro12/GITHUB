# ORB_OpeningRange — Opening Range Breakout (MQL5)

EA minimale di **Opening Range Breakout** intraday per lo Strategy Tester di MetaTrader 5,
pensato per **DAX** e **NASDAQ**. Core volutamente semplice: pochi parametri, filtri
opzionali **spenti di default** per evitare overfitting nel primo backtest.

File EA: `mql5/Experts/ORB_OpeningRange.mq5`

## Idea

1. **Opening Range (OR)**: nella finestra `[ORStart, ORStart + ORMinutes)` si traccia
   il massimo (`ORHigh`) e il minimo (`ORLow`) delle barre. A fine finestra i due livelli
   vengono **congelati** per la giornata.
2. **Breakout**: una barra **chiusa** che chiude *strettamente* sopra `ORHigh` apre un
   **LONG**; una che chiude *strettamente* sotto `ORLow` apre uno **SHORT**. Solo nella
   finestra operativa (da fine OR fino a `EntryEnd`).
3. **SL/TP**: SL sul lato opposto dell'OR (+/- buffer), validato contro i vincoli del
   broker; TP = `RR * stopDist`.
4. **Chiusura intraday**: a/dopo `CloseHour:CloseMin` tutte le posizioni dell'EA vengono
   chiuse e non si aprono nuovi trade.

Tutto è valutato **una volta per barra chiusa** (shift 1, nessun look-ahead). Il **timeframe
del grafico è il timeframe di lavoro** (inteso **M5**): applicare l'EA su un grafico M5.

## Helper riusati

Sizing/rischio/sessione sono riusati *verbatim* da `DAX_M3_Supertrend.mq5`:
`MoneyPerPoint` (via `SYMBOL_TRADE_TICK_VALUE`/`TICK_SIZE`), `RiskLot`, `RoundToTick`,
`MinStopDist`, governance (`IsMine`, `CountPos`, `NewestPos`, `OpenRiskPct`, `ClosePos`),
setup `CTrade`, pattern apri-con-fallback (su retcode 10016 apri senza stop poi
`PositionModify`), helper di sessione (`MinOfDay`, `Wrap`), e il `Print` diagnostico dei
vincoli broker in init. Niente pip/point/contratto hardcoded.

## Input

**Opening Range**
- `ORStartHour` (9), `ORStartMin` (0), `ORMinutes` (30)
- `ServerToCET` — offset orario: `ore_server = ore_CET + offset`

**Finestra operativa**
- `EntryEndHour` (16), `EntryEndMin` (30) — ultimo orario di ingresso (CET)
- `CloseHour` (17), `CloseMin` (25) — chiusura intraday (CET)
- `CloseAtSessionEnd` (true) — flat a fine sessione
- `OneTradePerDay` (true) — un solo trade al giorno (copre entrambe le direzioni). Se
  `false`, è ammesso un ingresso per ciascuna direzione.

**SL / TP / Rischio**
- `RR` (2.0), `BufferPoints` (0), `RiskPct` (1.0), `MaxTrades` (3),
  `MaxTotalRisk` (3.0), `MagicNumber`

**Filtri (opzionali, default OFF)**
- `UseVolumeFilter` (false): il tick volume della barra di breakout deve essere
  `>= VolFactor * media(VolAvgBars precedenti)`. `VolFactor` (1.5), `VolAvgBars` (20).
- `UseEmaFilter` (false): EMA `EmaFast` (9) / `EmaSlow` (21) sul TF del grafico. Long
  richiede `close > entrambe le EMA` e `EmaFast >= EmaSlow`; specchiato per lo short.

I default riflettono il **DAX** (OR 09:00–09:30 CET).

## Fuso orario (ServerToCET)

I tempi sono espressi in **CET** e tradotti in **ora server** con
`ore_server = ore_CET + ServerToCET`. Impostare l'offset in base al broker:

- Server già su CET/CEST → `ServerToCET = 0`.
- Server su "GMT+2/GMT+3" tipo MetaQuotes (spesso ~CET+1 in estate) → impostare
  l'offset misurato (es. `1`). Verificare guardando l'orario di una barra nota nel
  tester e confrontandolo con l'ora CET attesa.

> Nota: l'EA **non** gestisce automaticamente l'ora legale (DST). Se il broker e CET
> vanno in DST in modo non allineato, l'offset può cambiare tra inverno ed estate;
> per backtest a cavallo del cambio d'ora valutare run separati.

## Passare al NASDAQ

Apertura USA = **15:30 CET** (cash open 09:30 ET). Sessione cash fino a ~22:00 CET.

| Input         | DAX (default) | NASDAQ |
|---------------|---------------|--------|
| `ORStartHour` | 9             | 15     |
| `ORStartMin`  | 0             | 30     |
| `ORMinutes`   | 30            | 30 (OR 15:30–16:00 CET) |
| `EntryEndHour`| 16            | 21     |
| `EntryEndMin` | 30            | 0      |
| `CloseHour`   | 17            | 21     |
| `CloseMin`    | 25            | 55     |
| `ServerToCET` | (broker)      | (broker) |

Applicare l'EA sul simbolo NASDAQ del broker, grafico **M5**, e impostare `ServerToCET`
coerente col broker.

## Come testare

1. Strategy Tester → simbolo DAX (o NASDAQ), **timeframe M5**, modello "Every tick".
2. Impostare gli input (per NASDAQ usare la tabella sopra) e `ServerToCET`.
3. Avviare. La riga `ORB VINCOLI ...` e `ORB avviato ...` in init confermano i vincoli
   broker e i parametri attivi.

## Punti da rivedere (per il reviewer)

- **Reset giornaliero / timing OR**: il reset avviene al cambio data della *barra chiusa*
  (`day/mon/year`), non all'orario di sessione. Su DAX questo coincide perché l'OR è di
  mattina; su simboli/orari a cavallo della mezzanotte server verificare che il reset
  cada prima dell'inizio OR.
- **Congelamento OR**: i livelli sono congelati alla prima barra *dopo* la fine finestra.
  Se l'EA parte a metà giornata (OR non osservabile), `g_orFormed` resta `false` e non si
  opera quel giorno (comportamento voluto).
- **Finestre con `Wrap`**: tutte le finestre sono calcolate in minuti-dal-`orStart` con
  `Wrap` (modulo 1440) per gestire il cavallo di mezzanotte. `afterClose` usa
  `Wrap(closeM - orStart) <= sinceStart`. Verificare i confini per sessioni esotiche.
- **One-trade-per-day**: `g_tradeTakenToday` viene impostato **solo su apertura riuscita**.
  Con `OneTradePerDay=false` si usano `g_longTaken`/`g_shortTaken` per limitare a un
  ingresso per direzione. Da notare: un breakout long e poi short nello stesso giorno
  sono entrambi possibili solo con `OneTradePerDay=false`.
- **Breakout stretto**: il confronto è `close > ORHigh` / `close < ORLow` (strettamente),
  come da specifica.
