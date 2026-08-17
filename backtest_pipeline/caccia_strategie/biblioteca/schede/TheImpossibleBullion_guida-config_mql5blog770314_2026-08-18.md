# SCHEDA — "The Impossible Bullion" — Optimisation & Configuration Guide

- **URL:** https://www.mql5.com/en/blogs/post/770314
- **Data del post:** 04/06/2026 — letta e archiviata il **18/08/2026**
- **Stato:** [VERIFICATO] pagina aperta da noi. La guida dichiara ESPLICITAMENTE
  di **non** pubblicare i preset ("does not publish genome files"): quindi
  **meccanismi si', valori no** — i numeri restano [INCERTO].

## 🔴 Perche' questa scheda e' importante: il buco n.8 e' TAPPATO

Il censimento della prima notte diceva, del meccanismo _"riduzione del rischio
in prossimita' dei muri"_: **"nessun prodotto letto lo dichiara"**.
Qui e' dichiarato, e con una struttura a **tre zone**:

| input | cosa fa (parola per parola dalla guida) |
|---|---|
| `EnablePropFirm` | _"Turns on **zone-based risk control**"_ |
| `PropYellowPct` / `PropRedPct` / `PropDeadPct` | _"Thresholds for zone changes"_ |
| **`YellowRiskMult` / `RedRiskMult`** | _"**Risk reduction inside warning zones**. Lower multipliers reduce size more aggressively **as DD budget is consumed**"_ |
| `YellowMaxTrades` / `RedMaxTrades` | _"Trade cap overrides in warning zones"_ |
| `YellowMinScore` / `RedMinScore` | _"Minimum score floors inside warning zones — raise to **demand cleaner setups while under stress**"_ |
| `PropStartBalance` | _"Leave at 0 for **auto-history reconstruction**"_ |
| `PropDDMode` | statico o **`DD_TRAILING_HWM`** — _"Use the firm's actual rule wording, **not marketing shorthand**"_ |

Cioe': man mano che il budget di drawdown si consuma, **tre manopole insieme**
si stringono — taglia, numero di trade, e qualita' minima del segnale.

Piu' la calibrazione per regolamento: _"Standard 10/5 challenge-style"_ vs
_"**Stricter 6/3 prop**: lower risk, **earlier Yellow / Red zones**, stricter
spread acceptance, more conservative trade frequency"_.

---

 The Impossible Bullion — Optimisation & Set File Guide
 4 June 2026, 16:11
 Paul Raymond Heckles 
 0 
 246
 The Impossible Bullion v3.23 — Optimisation & Settings Guide
 This guide explains how Bullion is configured, what each major setting does, how to adapt the EA to different brokers and prop-rule environments, and how matched presets are handled after purchase. This page is intentionally configuration-focused: it does not publish genome files or expose private preset downloads. For general product information see the Bullion product page .
 Quick link | Purpose | 
 Private message the seller | Preset requests, broker / prop matching, purchase support, configuration questions | 
 Discord community | Forward-test discussion, setup help, release notices, trader chat | 
 Live signal | Live signal coming soon | 
 Product page | Market listing, updates, screenshots, public comments | 
 Recommended Raw ECN Broker
 The Impossible Bullion has been extensively tested across multiple broker conditions. For live raw-ECN execution on XAUUSD, we recommend RoboForex for tighter pricing and cleaner execution with this strategy profile.
 Open Recommended Raw ECN Broker (RoboForex) 
 How preset support works after purchase 
 If you need a matched preset after purchase, send a private message to the seller with your MQL5 username and proof of purchase on that same account . A screenshot of the MQL5 purchase confirmation, Purchased tab, or product page showing ownership is sufficient. Do not send bank card details, payment numbers, or unrelated personal information.
 From there, the closest preset is selected from the internal genome library based on your broker, execution conditions, drawdown rules, and account type. Not every buyer needs a custom preset — many raw / ECN users can start from the raw-broker baseline and only adjust a small number of inputs.
 What To Send If You Want A Matched Preset
 MQL5 username used to purchase Bullion
 Proof of purchase from that MQL5 account
 Broker or prop firm name 
 Account type — raw / ECN, standard, challenge, funded, instant-funded
 Drawdown rules — max DD, daily DD, and whether the DD floor is static or trailing
 Typical XAUUSD spread during the hours you intend to trade
 Commission model if applicable
 Balance / account size 
 Any broker suffix or symbol variation such as XAUUSD.a, GOLDmicro, etc.
 The more precise your execution details are, the closer the matched preset can be to your real environment.
 ⚠️ Important 
 Always demo test first for at least 2 to 4 weeks before trading live or funded
 Prop firms change rules; always verify your current DD clause yourself before enabling PropFirm mode
 News filter uses the MT5 calendar and does not work in Strategy Tester
 Past performance and backtests do not guarantee future results
 The guide below explains how settings behave; changing key parameters without re-testing creates a new strategy profile
 Starting Point
 When examples below do not specify an environment, assume a raw / ECN retail-style baseline with tight spread and commission pricing . That is the cleanest starting point for Bullion because spreads are tighter, fills are cleaner, and spread-related filters can stay more selective.
 Backtest mode reminder: for Bullion, use Every Tick (recommended) or 1 Minute OHLC ; avoid Real Ticks when validating regime-dependent behavior.
 Strategy Tester: How To Test Your Set File
 If you received a genome set file by private message, test that exact set file in MT5 Strategy Tester before going live. The goal is to verify that your local broker feed and execution profile produce behavior consistent with the intended preset profile.
 Step | What to do | Why it matters | 
 1 | Select The Impossible Bullion on XAUUSD M5 in Strategy Tester | Bullion presets are tuned for this symbol/timeframe profile. | 
 2 | Load the provided .set file in Inputs | Ensures you are validating the intended genome, not terminal defaults. | 
 3 | Use Every Tick (recommended) or 1 Minute OHLC | These modes are the supported test basis for Bullion regime behavior. | 
 4 | Run an in-sample and out-of-sample window, then compare trade quality and DD behavior | Checks profile stability, not just one period's headline result. | 
 5 | Only change one major parameter at a time, then re-test | Multiple simultaneous edits create a new unvalidated strategy profile. | 
 Why Not Real Ticks For Bullion Regime Validation
 Bullion uses a weekly regime filter that reads W1 structure to decide directional gating and trade permission. In Strategy Tester, weekly bars are reconstructed from lower-timeframe data rather than loaded as true broker-side weekly closes. This can shift weekly bar alignment and distort regime decisions during backtests.
 Because of that, Real Ticks can produce misleading W1 regime outcomes for Bullion even though it appears more precise intrabar. For Bullion testing, Every Tick is the recommended mode and 1 Minute OHLC is the acceptable faster alternative. This is a tester-modeling limitation; live trading reads actual broker-feed weekly bars.
 Environment | Use when | Main adjustments | 
 Raw / ECN retail baseline | Tight spread XAUUSD, commission model, no prop DD rules | Moderate MaxSpread, PropFirm OFF, static risk, tighter spread filtering | 
 Wider raw retail | Still commission-based, but spread spikes more often | Raise MaxSpread modestly, keep SpreadMultiplier realistic, re-check trailing profile | 
 Standard 10/5 challenge-style prop | Typical 10% max / 5% daily rule set | Enable PropFirm, set PropMaxDD / PropDailyDD correctly, use conservative risk and trade caps | 
 Stricter 6/3 prop | Narrower 6% max / 3% daily rule set | Lower risk, earlier Yellow / Red zones, stricter spread acceptance, more conservative trade frequency | 
 Spread, Execution, And Rule Mapping
 Spread Calibration
 Observed XAUUSD conditions | Typical approach | What usually changes | 
 Very tight raw / ECN | Keep entry filter selective | Lower MaxSpread, lower tolerance for random spread spikes | 
 Acceptable but wider raw | Allow slightly more entry tolerance without normalising bad execution | Raise MaxSpread moderately, keep SpreadMultiplier realistic | 
 Standard-spread account | Not preferred for Bullion | Re-test before use; wider spread often requires materially different TP / SL behavior and lower expectancy | 
 Do not raise MaxSpread just to force more trades. If valid trades are being blocked, first confirm your real spread distribution during Bullion's trading hours. A spread filter that is too loose often converts a good genome into a low-quality execution profile.
 Prop Rule Calibration
 Rule style | Key inputs to review | Notes | 
 Standard 10/5 challenge-style | EnablePropFirm, PropMaxDD, PropDailyDD, PropDDMode, Yellow/Red/Dead thresholds | Use the exact daily / total DD rules published by your firm, not a brand name assumption | 
 Stricter 6/3 prop | Same inputs as above, with lower risk and earlier zone tightening | Usually requires lower risk-per-trade and tighter trade-frequency discipline | 
 Trailing DD floor | PropDDMode=DD_TRAILING_HWM | Use only if the firm truly ratchets the DD floor with peak equity / balance | 
 Static start-balance DD floor | PropDDMode=DD_STATIC_INITIAL | Most common choice for standard challenge accounts | 
 Settings Reference
 The tables below explain what each group of parameters does and how to think about the trade-offs. They are configuration notes, not optimisation promises.
 1. Strategy Core
 Parameter | What it changes | Practical guidance | 
 Timeframe | Chart timeframe Bullion reads for entry logic | Use XAUUSD M5. Do not treat other timeframes as equivalent. | 
 LookbackBars | Size of the breakout range window | Lower values react faster; higher values need more structure before breakout. | 
 BufferPips | Distance beyond the range required before entry qualifies | Raise it if you want fewer, cleaner breakouts; lower it if entries are too delayed. | 
 MinRangePips | Minimum range size required to consider the setup valid | Raise it to avoid compressed sessions; lower it only if you have tested thin-range behavior carefully. | 
 MaxRangePips | Upper limit on range size | Usually left wide. Lower only if extremely expanded pre-breakout sessions are polluting entries. | 
 MinScoreToTrade | Primary quality threshold for Bullion's scoring engine | One of the most sensitive settings. Raising it usually reduces frequency and can improve selectivity; lowering it usually increases activity and noise. | 
 MaxScoreToTrade | Optional upper band limit | Normally leave at 0 (off). Useful only for research or band testing. | 
 2. D1 Gate And D1 Classifier
 Parameter | What it changes | Practical guidance | 
 RegimeGateEnabled | Enables the lightweight D1 ADX chop gate | Good first layer if you want simple chop rejection before enabling the full D1 classifier. | 
 RegimeGateTF | Timeframe used for the gate ADX | Leave at D1 unless you are deliberately researching a different regime horizon. | 
 RegimeGatePeriod | ADX period for the simple gate | Higher values smooth more; lower values react faster and can flicker more. | 
 RegimeGateMinADX | Minimum ADX needed for entries to stay open to new trades | Raise it to block more choppy days; lower it to allow more marginal regimes. | 
 RegimeClassifierEnabled | Enables the full 5-factor D1 regime classifier | More advanced than the simple gate. Best enabled only after observation and logging. | 
 RegimeClassifierMode | 0=diagnostic, 1=block chop, 2=direction-aware | Use diagnostic first if you are not sure how the votes behave on your broker feed. | 
 RegimeAdxTrendMin | ADX threshold for trend vote | Raise for stricter trend recognition; lower for more permissive trend votes. | 
 RegimeAdxChopMax | ADX threshold for chop vote | Higher values classify more days as chop; lower values require cleaner trendlessness before blocking. | 
 RegimeAtrPctMax | ATR % ceiling used inside the classifier | Controls how stretched daily conditions are interpreted. Do not change casually. | 
 RegimeDiagCSV | Writes classifier diagnostics to file | Recommended before enabling live blocking in a new environment. | 
 MaxHoldBars | Maximum bar duration for any open trade | Useful if you want to prevent extended holds on M5. | 
 CooldownBars | Pause between trades after a close | Useful to suppress rapid re-entry loops in volatile periods. | 
 3. Session Filter
 Parameter | What it changes | Practical guidance | 
 SessionStart / SessionEnd | Main trading window in GMT | Use the liquid part of the day for XAUUSD. All-hours configurations typically sit around London through New York. | 
 ExcludeStart / ExcludeEnd | Optional sub-window inside the main session where entries are suppressed | Use only if your testing shows a reliably poor intraday pocket. | 
 BlockMonday ... BlockFriday | Per-day trading switches | Useful if one weekday is consistently weak on your broker feed. | 
 Bullion supports SessionStart > SessionEnd for overnight windows that wrap midnight. That allows one continuous session without splitting into two charts.
 4. Risk
 Parameter | What it changes | Practical guidance | 
 RiskPerTrade | Percent of equity risked per trade when using dynamic sizing | Lower it first on prop accounts. This is the first place to reduce aggression. | 
 CompoundAggressive | Whether sizing compounds with current equity | Leave on for normal compounding; turn off if you want steadier sizing relative to start balance. | 
 FixedLots | Overrides risk-based sizing with a fixed lot size | Use only if you intentionally want manual lot control. | 
 MinLotSize / MaxLotSize | Caps on calculated position size | Important for very small or very large accounts. | 
 MagicNumber | Unique trade identifier | Change when running multiple Bullion instances on one terminal. | 
 5. TP / SL And Spread
 Parameter | What it changes | Practical guidance | 
 TP_Pips | Fixed take-profit distance | One of the core expectancy settings. Do not alter without re-testing the full exit profile. | 
 SL_Pips | Fixed stop-loss distance | Must be considered together with trailing and breakeven behavior. | 
 MaxSpread | Hard entry block above this spread level | Match this to your real XAUUSD spread distribution. Too high usually harms quality more than it helps activity. | 
 SpreadMultiplier | Minimum-stop safety buffer relative to spread | Higher values are more conservative. Use realistic values for ECN/raw execution. | 
 6. ATR Scaling
 Parameter | What it changes | Practical guidance | 
 UseATRScaling | Replaces fixed TP / SL with ATR-based values | Leave off unless you are intentionally building and testing a volatility-adaptive profile. | 
 SL_ATR_Mult | ATR multiplier used for stop-loss | Lower = tighter stop; higher = more room. | 
 TP_ATR_Mult | ATR multiplier used for take-profit | Usually kept above the SL multiplier to preserve a healthy reward structure. | 
 7. Trade Management
 Parameter | What it changes | Practical guidance | 
 UseBreakeven | Moves stop after price reaches a trigger | Can reduce left-tail risk, but can also cut good trades too early if the trigger is too tight. | 
 BreakevenTrigger | Profit distance before breakeven activates | Lower values protect earlier but often reduce follow-through room. | 
 BreakevenOffset | Offset beyond entry after breakeven fires | Useful if you want small locked profit instead of exact flat break-even. | 
 UseTrailingStop | Enables trailing stop management | One of Bullion's most important exit tools. | 
 TrailingStart | Profit distance before trailing begins | Lower = earlier protection; higher = more room for trade development. | 
 TrailingStep | Distance maintained once trailing is active | Tighter values lock profit faster but can choke runners. | 
 EnableTPExtension | Enables Progressive TP Extension | Bullion-exclusive feature. Useful when strong moves regularly push beyond the first TP. | 
 ExtendTPTriggerATR | How close price must get before extension logic arms | Lower values trigger later; higher values trigger earlier. | 
 ExtendTPByPips | How far TP is pushed each time | Larger steps chase bigger runners but can also delay realization. | 
 ExtendTPMaxCount | Max number of TP extensions | 0 means unlimited. | 
 ExtendTPRatchetSL | Whether SL is shifted when TP extends | Mainly useful if trailing is off and you still want additional protection. | 
 8. Protection
 Parameter | What it changes | Practical guidance | 
 MaxDrawdown | Total account-level halt threshold | Set it to your personal or firm risk ceiling. | 
 MaxDailyLoss | Daily halt threshold | Critical for funded or challenge-style accounts. | 
 MaxOpenTrades | Maximum concurrent positions | Default one-trade structure is the safest baseline. | 
 MaxTradesPerDay | Daily trade cap | Use to prevent overtrading during noisy sessions. | 
 MaxConsecLosses | Daily stop after a losing streak | Useful if the strategy degrades sharply once regime quality falls. | 
 9. News Filter
 Parameter | What it changes | Practical guidance | 
 EnableNewsFilter | Blocks entries around high-impact events | Recommended for live trading. Tester does not emulate MT5 calendar behavior. | 
 NewsMinutesBefore | Pre-news blackout window | Raise it if your broker often widens aggressively before events. | 
 NewsMinutesAfter | Post-news blackout window | Raise it if post-event whipsaw remains unstable on your feed. | 
 10. Shield
 Parameter | What it changes | Practical guidance | 
 EnableShield | Enables the equity-peak circuit breaker | Useful when you want the EA to stand down after giving back too much from a peak. | 
 ShieldArmPct | Profit milestone before Shield fully arms | Higher means Shield waits longer before becoming active. | 
 ShieldDrawdownPct | Drawdown from shield peak that triggers it | Lower values protect faster; higher values allow more giveback. | 
 ShieldRecovery | 0=permanent, 1=next day, 2=recovery-based reset | Choose the reset style that matches your account management rules. | 
 ShieldRecoveryPct | Required recovery before re-enable in recovery mode | Only used when ShieldRecovery=2. | 
 11. Prop Firm Mode
 Parameter | What it changes | Practical guidance | 
 EnablePropFirm | Turns on zone-based risk control | Enable only when the account is actually governed by explicit DD rules. | 
 PropMaxDD / PropDailyDD | Maximum total and daily DD limits | These must match your actual firm rules exactly. | 
 PropYellowPct / PropRedPct / PropDeadPct | Thresholds for zone changes | More conservative profiles move into Yellow and Red earlier. | 
 YellowRiskMult / RedRiskMult | Risk reduction inside warning zones | Lower multipliers reduce size more aggressively as DD budget is consumed. | 
 YellowMaxTrades / RedMaxTrades | Trade cap overrides in warning zones | Useful for cutting trade frequency as the account approaches limits. | 
 YellowMinScore / RedMinScore | Minimum score floors inside warning zones | Raise to demand cleaner setups while under stress. | 
 PropStartBalance | Reference start balance for DD calculations | Leave at 0 for auto-history reconstruction unless you specifically need manual override. | 
 PropDDMode | Static or trailing DD floor | Use the firm's actual rule wording, not marketing shorthand, to choose the mode. | 
 12. Weekly Regime Filter
 Parameter | What it changes | Practical guidance | 
 EnableRegimeFilter | Enables W1 trend detection | Core Bullion filter. Normally left on. | 
 RegimeEMAPeriod | Weekly EMA period used by the filter | Lower reacts faster; higher smooths more. | 
 RegimeLookback | How many W1 bars are used for slope reading | Higher values create a slower, more stable trend state. | 
 RegimeMinSlope | Minimum slope magnitude to classify trend | Raise it to avoid weak-trend classification; lower it to accept softer trend states. | 
 TrendMode | How trade direction is allowed relative to the weekly trend | Bullion-specific directional control. Use the mode matrix below for weekly UP, DN, and FLAT behavior. | 
 Mode | Weekly trend UP | Weekly trend DN | Weekly FLAT | 
 TREND_BOTH | Buys & sells | Buys & sells | Buys & sells | 
 TREND_WITH_ONLY (default) | Buys only | Sells only | Buys & sells | 
 TREND_WITH_SKIP_FLAT | Buys only | Sells only | No trades | 
 TREND_BUY_ONLY | Buys only | Buys only | Buys only | 
 TREND_SELL_ONLY | Sells only | Sells only | Sells only | 
 TREND_WITH_ONLY is the default for Bullion. Use TREND_BOTH if you want Gold-style both-direction behavior, TREND_WITH_SKIP_FLAT if you want the EA to stand aside when the weekly trend is unclear, and TREND_BUY_ONLY / TREND_SELL_ONLY for pure directional overlays.
 13. Additional Prop Filters
 Parameter | What it changes | Practical guidance | 
 EnablePropFilters | Master switch for the additional prop-only filters | Useful when you want extra protection beyond the normal score and regime stack. | 
 FilterCounterTrendH1 | Blocks entries against H1 EMA50 slope | Can reduce counter-trend exposure, but may also cut valid reversals. | 
 FilterMinADX | Blocks low-ADX entries | Use with care; it can overlap with other trend-strength filters. | 
 MinADXForEntry | ADX threshold used by FilterMinADX | Higher values allow only stronger momentum states. | 
 14. Audit, Direction Exclusions, Discord, And Display
 Parameter | What it changes | Practical guidance | 
 LogTradeFactors | Writes per-trade score audit CSV | Enable when diagnosing why trades did or did not happen. | 
 AuditCSVPrefix | Sets the audit filename prefix | Useful when separating logs by environment. | 
 BuyExcludeStart / End | Suppresses buys during selected GMT hours | Use only if a directional intraday bias is consistently poor on your broker. | 
 BuyExclude2Start / End | Second buy exclusion zone | Use if you need two separate buy-suppression windows. | 
 SellExcludeStart / End | Suppresses sells during selected GMT hours | Same logic as buy exclusions. | 
 DiscordWebhookURL | Main Discord webhook | Blank disables alerts. | 
 DiscordRecapWebhookURL | Optional separate recap webhook | Leave blank to reuse the main webhook. | 
 DiscordAlertOnOpen / Close | Trade event alerts | Normal live-monitoring settings. | 
 DiscordWeeklyRecap | Monday performance recap | Useful for VPS-based unattended monitoring. | 
 DiscordStartupPing | Startup confirmation message | Strongly recommended for VPS setups. | 
 SetDescription | Instance label shown on dashboard and in alerts | Important if you run multiple Bullion charts. | 
 ShowDashboard | Shows the on-chart panel | Usually left on. | 
 ShowChartExtras | Extra overlays and labels | Personal preference unless you want a cleaner chart. | 
 ShowATRWarning | Displays elevated daily ATR warning | Recommended on. | 
 DebugMode | Verbose logging | Use only when troubleshooting. | 
 Example Configuration Logic
 Situation | Usually review first | Why | 
 Broker spread is tighter than expected | MaxSpread | You may be able to keep entry quality tighter without losing valid trades. | 
 Broker spread is wider than raw baseline | MaxSpread, SpreadMultiplier, TP / SL behavior | Do not simply lift MaxSpread aggressively; confirm the entire exit structure still makes sense. | 
 10/5 challenge account | EnablePropFirm, PropMaxDD, PropDailyDD, PropDDMode, risk, trade caps | The rule framework matters more than brand naming. | 
 6/3 account | Same as above, but with lower risk and earlier zone tightening | Narrower DD tolerance requires faster defensive behavior. | 
 Too many low-quality entries | MinScoreToTrade, RegimeGateEnabled, RegimeClassifier | Raise selectivity before touching exits. | 
 Too many trades in poor intraday pockets | Session window, exclusion hours, weekday blocks | Time-of-day filtering often fixes this more cleanly than changing score thresholds. | 
 Good trades stop out too early | TrailingStart, TrailingStep, breakeven, SL structure | Exit logic is usually the issue, not entry logic. | 
 Deployment Checklist
 Attach Bullion to XAUUSD M5 