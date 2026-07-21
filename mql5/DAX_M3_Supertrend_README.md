# DAX M3 Supertrend — MQL5 Expert Advisor

Fully-automated MetaTrader 5 Expert Advisor that replicates the **DAX M3 Supertrend**
multi-timeframe trend-following intraday strategy. Designed for backtesting in the
MT5 Strategy Tester.

- EA: `mql5/Experts/DAX_M3_Supertrend.mq5`
- The **chart timeframe IS the entry timeframe**. To replicate "M3", open the EA on
  an **M3 chart**. The **H4** bias timeframe is fixed internally.

---

## Strategy logic

### 1. Supertrend (manual implementation)

Implemented manually with the standard formula, equivalent to TradingView's
`ta.supertrend(factor, atrPeriod)`. Computed on **closed bars only** (shift 1 vs
shift 2), and re-derived over the last `ST_Lookback` bars each evaluation so the
recursion stabilises.

```
atr        = ATR(AtrPeriod)                       (via iATR handle)
hl2        = (high + low) / 2
upperBasic = hl2 + Factor * atr
lowerBasic = hl2 - Factor * atr

upperBand[i] = (upperBasic < upperBand[i-1] || close[i-1] > upperBand[i-1])
               ? upperBasic : upperBand[i-1]
lowerBand[i] = (lowerBasic > lowerBand[i-1] || close[i-1] < lowerBand[i-1])
               ? lowerBasic : lowerBand[i-1]

dir:  start +1
      if close[i] > upperBand[i-1]      -> dir = +1   (bullish, price ABOVE Supertrend)
      else if close[i] < lowerBand[i-1] -> dir = -1   (bearish)
      else                              -> dir = dir[i-1]

supertrend line = (dir == +1) ? lowerBand[i] : upperBand[i]
```

The function returns, for a given timeframe: the **closed-bar** direction and line
value (shift 1), and the **previous closed-bar** direction (shift 2) so a *flip* can
be detected.

### 2. H4 bias (the only thing that sets direction)

```
biasLong  = ST_H4 dir == +1 AND (close_H4 > EMA200_H4) AND (ADX_H4 > AdxThreshold)
biasShort = ST_H4 dir == -1 AND (close_H4 < EMA200_H4) AND (ADX_H4 > AdxThreshold)
else        bias = NEUTRAL (no trades)
```

- EMA200 on H4: `iMA(PERIOD_H4, EmaPeriod, 0, MODE_EMA, PRICE_CLOSE)`.
- ADX on H4: `iADX(PERIOD_H4, AdxLen)`, main line (buffer 0).
- `UseEMA` and `UseADX` make each filter toggleable.

### 3. M3 entry trigger (current chart timeframe)

Evaluated **once per new bar**, on the just-closed bar.

```
flipLong  = ST(currentTF) dir flipped to +1 this bar  (dir==+1 and prevDir<=0)
flipShort = ST(currentTF) dir flipped to -1 this bar  (dir==-1 and prevDir>=0)
emaOkL    = not UseEMA or close > EMA200(currentTF)
emaOkS    = not UseEMA or close < EMA200(currentTF)

longSignal  = (bias==Long)  and flipLong  and emaOkL and inSession
shortSignal = (bias==Short) and flipShort and emaOkS and inSession
```

Pyramiding is disabled: only **one position per direction** is allowed at a time.

### 4. SL / TP / exit

- On entry: `SL = current Supertrend line of the current TF`.
  `stopDist = |entryPrice - SL|`, `TP = entry ± RR * stopDist`.
- `ExitMode`:
  - `EXIT_ST_OPPOSITE_PLUS_RR` (default) — TP at RR **and** close on opposite ST flip.
  - `EXIT_RR_ONLY` — TP at RR only.
  - `EXIT_ST_OPPOSITE_ONLY` — no TP; close only on opposite ST flip.
- `TrailWithST` (default **false**) — when on, moves the SL to the ST line as it
  trails (favourable direction only). Keep **off** for the first backtest to match
  the Pine version (fixed SL at entry ST).
- A sanity check refuses the trade if the ST line is on the wrong side of the entry
  (e.g. SL ≥ entry for a long).

### 5. Risk / sizing / governance (reused from `HARSI_Assistant.mq5`)

- Universal risk-based lot sizing via `MoneyPerLotPerPricePoint`
  (`SYMBOL_TRADE_TICK_VALUE / SYMBOL_TRADE_TICK_SIZE`), `RoundDownToStep`,
  `CalcRiskLot`. Refuses (with a `Print`) if even the minimum lot exceeds the
  risk budget.
- `MaxConcurrentTrades` and `MaxTotalRiskPct` block new entries when violated
  (via `CurrentOpenRiskPct` / `CountSymbolPositions`).
- `MagicNumber` isolates the EA's own positions.

---

## Session / time handling (read carefully)

The session window is defined in **CET**:
`SessionStartHour:SessionStartMin` … `SessionEndHour:SessionEndMin`
(default **09:30 – 17:30 CET**, start inclusive).

**MT5 server time is usually NOT CET.** Set `ServerToCET_OffsetHours` so the window
aligns:

```
ServerToCET_OffsetHours = (server hours) - (CET hours)
effective_server_time   = CET_time + ServerToCET_OffsetHours
```

Examples (most brokers run on **GMT+2 / GMT+3 with DST**):
- Broker server GMT+2 (summer), CET = GMT+1 → server is 1h ahead → **offset = +1**.
- Broker server GMT+3 (summer), CET = GMT+2 (CEST) → server 1h ahead → **offset = +1**.
- Broker server GMT+2 (winter), CET = GMT+1 → **offset = +1**.
- Server already on CET → **offset = 0** (default).

Bar times are decomposed with `TimeToStruct`; the CET window is converted to
minutes-of-day in server time and wrapped into `[0,1440)` (handles a window that
crosses midnight). New entries are only allowed inside `[start, end]` inclusive.

`CloseAtSessionEnd` (default true): once a closed bar falls at/after session end and
outside the window, all EA positions are flattened (intraday — no overnight risk).

> Note: because the EA acts on the **closed bar**, the session/close decisions use the
> closed bar's timestamp. On M3 this is at most a 3-minute granularity around the
> boundaries.

---

## Inputs

### Supertrend
| Input | Default | Meaning |
|---|---|---|
| `Factor` | 3.5 | ATR multiplier |
| `AtrPeriod` | 10 | ATR period |
| `ST_Lookback` | 300 | Bars used to stabilise the recursion each evaluation |

### Bias H4
| Input | Default | Meaning |
|---|---|---|
| `UseEMA` | true | Enable EMA200 filter |
| `UseADX` | true | Enable ADX filter |
| `EmaPeriod` | 200 | EMA period (H4 and current TF) |
| `AdxLen` | 14 | ADX length (H4) |
| `AdxThreshold` | 25.0 | Minimum ADX for a valid trend |

### Session / time (CET)
| Input | Default | Meaning |
|---|---|---|
| `SessionStartHour` | 9 | Session start hour (CET) |
| `SessionStartMin` | 30 | Session start minute (CET) |
| `SessionEndHour` | 17 | Session end hour (CET) |
| `SessionEndMin` | 30 | Session end minute (CET) |
| `ServerToCET_OffsetHours` | 0 | server hours − CET hours (see above) |
| `CloseAtSessionEnd` | true | Flatten EA positions at/after session end |

### Exit / SL / TP
| Input | Default | Meaning |
|---|---|---|
| `ExitMode` | ST opposite + RR | Exit logic (3 options) |
| `RR` | 1.5 | Reward:Risk for the TP |
| `TrailWithST` | false | Trail SL on the Supertrend line |

### Risk / management
| Input | Default | Meaning |
|---|---|---|
| `RiskPct` | 1.0 | Risk % of balance per trade |
| `MaxConcurrentTrades` | 3 | Max simultaneous open trades |
| `MaxTotalRiskPct` | 3.0 | Cap on total open risk (%) |
| `MagicNumber` | 20260626 | Magic number |

Defaults reflect the tested config: Factor 3.5, ATR 10, EMA200 on, ADX 25 on,
RR 1.5, ExitMode ST opposite + RR, RiskPct 1, session 09:30–17:30, CloseAtSessionEnd
true, TrailWithST false.

---

## Backtest protocol

1. **Compile** `DAX_M3_Supertrend.mq5` in MetaEditor (place it in
   `MQL5/Experts/`). No custom indicators are required — the EA uses built-in
   `iATR`, `iMA`, `iADX` plus its own manual Supertrend.
2. In the **Strategy Tester**:
   - Symbol: **DAX cash / DAX CFD** (e.g. `GER40`, `DE40`, `DAX`, broker-dependent).
   - Timeframe: **M3** (this sets the entry TF; H4 is read internally as MTF).
   - Modelling: **Every tick based on real ticks** (most realistic; required for an
     intraday ST/RR strategy).
   - Use a **long history** window.
3. **Set `ServerToCET_OffsetHours`** for your broker before the run, or the session
   gate will be wrong (this is the single most common source of garbage results).
4. **In-sample / out-of-sample**: split the long date range into two — optimise /
   inspect on the earlier (in-sample) portion, then validate untouched on the later
   (out-of-sample) portion. Do not tune on the out-of-sample window.
5. **Spread**: model spread via the tester's symbol settings (use the symbol's real
   spread, or set a realistic fixed spread) rather than the unrealistic "current"
   value, since DAX spreads widen outside the main session.
6. Inspect the **Journal / Experts** log: the EA prints every entry (direction, lot,
   entry, SL, TP, stopDist, ExitMode) and every exit with its reason.

---

## Reviewer double-check list

- **Supertrend recursion correctness** — band carry-over (`upperBand`/`lowerBand`),
  the `dir` carry on the "else" branch, and the seed on the first lookback bar.
  Increase `ST_Lookback` if the line looks unstable versus TradingView near the
  start of data.
- **Timezone / session** — confirm `ServerToCET_OffsetHours` matches your broker;
  verify entries cluster inside 09:30–17:30 CET and that `CloseAtSessionEnd` flattens
  at the right server time.
- **H4 bias via MTF reads** — `ComputeSupertrend(PERIOD_H4, ...)`, `iMA(H4)`,
  `iADX(H4)` all read shift 1 (last closed H4 bar); confirm no look-ahead and that
  enough H4 history is loaded.
