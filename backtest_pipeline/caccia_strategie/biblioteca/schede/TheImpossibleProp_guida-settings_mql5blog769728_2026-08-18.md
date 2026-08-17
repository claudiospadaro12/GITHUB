# SCHEDA — "The Impossible Prop (TIP)" — Settings & Optimisation Guide

- **URL:** https://www.mql5.com/en/blogs/post/769728
- **Autore/vendor:** blog MQL5 del vendor dell'EA "The Impossible Prop" (MT5, prodotto **a pagamento** su MQL5 Market)
- **Data del post:** 07/05/2026 — **letta e archiviata il 18/08/2026** dal cacciatore-config-prop
- **Cosa e':** guida pubblica ai preset. I 4 file `.set` linkati dal post sono archiviati in `biblioteca/set/TheImpossibleProp_*.set`
- **Stato:** [VERIFICATO] pagina aperta da noi. I numeri di performance sono **[dichiarato dal vendor, NON verificato]** e non pesano.

> Estratto testuale integrale della parte tecnica (tabelle appiattite con `|`).
> Conservato perche' e' l'unica fonte trovata che dichiara, con numeri,
> **la matematica del rischio combinato di due EA sullo stesso conto prop**.

---

 The Impossible Prop — Settings & Optimisation Guide
 7 May 2026, 10:36
 Paul Raymond Heckles 
 0 
 457
 The Impossible Prop — Settings & Optimisation Guide
 This is the quick-start settings reference for The Impossible Prop (TIP). It covers the locked v1.1 presets (data-driven refresh of v1.0 — see “What changed in v1.1” below), the recommended baseline parameters, and how to run the two correlated EAs in parallel on a single account.
 What changed in v1.1 (2026-05-10) 
 v1.1 keeps every line of v1.0’s strategy, risk and parallel-awareness logic untouched and only adjusts the filter parameters based on a fresh statistical edge analysis of 11 years of FTMO M5/H1/D1 data (2015-01 → 2026-05, 1.6M+ M5 bars) . Out-of-sample validated in MT5 Strategy Tester over 2026-01-01 → 2026-05-09 (every-tick from real ticks, $100K, 1:30 leverage):
 EURUSD: +6.4%   2.0% peak DD   76.7% WR   30 trades   0 halts
 GBPUSD: +3.6%   1.0% peak DD   91.7% WR   12 trades   0 halts
 Headline parameter deltas (full per-line evidence in the .set file headers):
 BlockCounterTrend → true (both pairs) — D1-regime alignment adds ~2.5p (EUR) / 3.8p (GBP) edge per trade
 BlockFriday → true (both pairs) — Friday is the worst day on both pairs across the full 11-year sample
 GBPUSD BlockWednesday → false (was true) — over 11 years Wednesday is GBP’s best day (+1.08p mean); the v1.0 block was a 2024-25 in-sample artefact and survived OOS once removed
 GBPUSD BufferPips 5.0 → 7.0 — first buffer above 50% breakout WR in the long sweep
 GBPUSD session 8-16 → 9-17 — drops worst hour (08:00) and reclaims best hour (16:00)
 Session/buy/sell hour exclusions realigned per hour-of-day asymmetry data on both pairs
 MaxSpread tightened to 5p on both pairs (broker p99 in session)
 v1.0 presets remain available for users who prefer to keep the prior configuration — both ship in the box.
 Links
 The Impossible Prop — on MQL5 Market | 
 Discord Community — live trade alerts, performance updates, trader chat | 
 MQL5 Seller Profile | 
 Private Message — for .set file requests or questions | 
 The Impossible Gold — FREE on MQL5 Market | 
 Recommended Raw ECN Broker
 The Impossible Prop has been extensively tested across multiple broker conditions. For live raw-ECN forex execution on EURUSD and GBPUSD, we recommend RoboForex for tighter pricing and cleaner fills with this strategy profile.
 Open Recommended Raw ECN Broker (RoboForex) 
 💡 Not just for prop firms — runs on any personal MT5 account too 
 The name says "Prop" because that's the hardest constraint set the EA is engineered to pass (FTMO-style 5% daily / 10% total DD with zero overshoot). But it's the same single binary for personal accounts — flip one input, EnablePropFirm=false , and the prop hard-rails switch off while every other safety layer (Shield circuit breaker, daily loss cap, consecutive-loss pause, news filter, spread filter, weekly regime, Parallel Awareness sibling coordination) stays fully active.
 On a personal account you can dial RiskPerTrade up from the prop-safe 0.75% to a more typical 1.5–3.0% per EA. Position size scales linearly so return and drawdown scale together — see the Personal Account Mode section below the sizing table for the recommended risk profiles (balanced / aggressive / high-conviction). One product, two deployment modes, one toggle.
 For .set file requests, optimisation questions or sibling configuration help, leave a comment below or send a private message .
 Recommended Baseline Settings
 Optimised .set files for both EUR/USD and GBP/USD are attached to the Settings & Optimisation Guide blog post. Download them directly from the attachments at the bottom of that page and load them in your MT5 Strategy Tester or live chart.
 Setup — 4 Steps
 Install the EA from the MQL5 Market into your MT5 terminal. The included icon will appear in the Navigator panel.
 Attach the EA to a 5-minute (M5) EURUSD chart and load TIP_v1.1_EURUSD.set . Verify the dashboard panel renders top-left. M5 is the timeframe the EA and its indicators are optimised for.
 Attach the EA to a 5-minute (M5) GBPUSD chart on the same terminal, same account and load TIP_v1.1_GBPUSD.set . Both EAs will discover each other automatically through the Parallel Awareness layer.
 Confirm the dashboard PARALLEL section shows both siblings as live (green heartbeat). If either side shows red, double-check magic numbers and that both EAs are running in the same terminal.
 Optimisation Notes
 The shipped v1.0 presets were locked using strict in-sample / out-of-sample discipline:
 In-sample : 24 months (2024-01-01 → 2025-12-31), 1-minute OHLC tester data, EA running on M5 chart, genetic optimiser
 Out-of-sample : ~4 months (2026-01-01 → 2026-04-27), every-tick-real, never seen during tuning
 Anti-overfit check : win rate held or improved IS → OOS on both pairs
 The v1.1 presets were derived using a different methodology — a statistical edge analysis on the full 11 years of FTMO data (2015-01 → 2026-05, 1.6M+ M5 bars) covering hour-of-day expectancy, day-of-week effects, breakout follow-through rates by buffer size, D1 regime conditioning, and spread tradeability by hour. Each parameter delta vs v1.0 is justified by a specific quantitative finding in the .set file header. v1.1 was then out-of-sample backtested in the MT5 Strategy Tester over 2026-01-01 → 2026-05-09 with the results listed in the “What changed in v1.1” box above. Both v1.0 and v1.1 presets ship in the box.
 If you want to re-optimise for a different account size or risk profile, the parameters with the largest performance impact are MinScoreToTrade , BufferPips and RiskPerTrade . Always validate any retuned set against at least 3 months of out-of-sample data the optimiser never saw.
 Entry Logic & Scoring Engine
 The EA scans a configurable lookback window for the session high and low, then waits for price to break above or below with a configurable BufferPips . Before any entry is sent, the breakout is graded by a 4-component scoring engine and must clear the MinScoreToTrade threshold (65 EUR, 55 GBP):
 ADX trend strength — confirms directional momentum is present
 EMA alignment — validates trend direction via moving average crossover
 ATR volatility filter — removes low-volatility noise where SL is too easily clipped
 RSI momentum — confirms entry is not extended into a reversal zone
 Trading is restricted to configurable GMT session hours with optional per-day blocking. In v1.1 both pairs block Friday (worst day on the 11-year sample); GBP additionally blocks Thursday. EUR trades Mon–Thu and GBP trades Mon–Wed in the v1.1 configuration. v1.1 also enables BlockCounterTrend on both pairs — entries are filtered by the D1 EMA50 trend regime, which contributes the single largest edge of any filter (~2.5p EUR / 3.8p GBP per trade). Trailing stop locks in profits as price moves favourably. Optional breakeven moves SL to entry after a configurable trigger distance.
 Parallel Awareness — internals & per-chart settings
 The cross-EA layer is built directly into the EA — no external coordinator, no shared file with locking issues, no extra software. Each instance broadcasts seven fields every tick via terminal-local GlobalVariables, and the sibling reads them with built-in staleness detection (default 30s).
 What each instance shares with its sibling: 
 Heartbeat — current server time, written every tick
 Open trade count — how many positions this EA currently has open
 Open direction — net long, net short, or flat
 Trades today — how many entries this EA has opened today
 Today's P&L — current day profit/loss attributable to this EA's positions
 Total P&L — running total since EA attached
 Halt state — prop permanent halt, daily halt, or Shield trigger active
 Per-chart parallel settings (already set in the shipped presets): 
 Setting | EURUSD chart | GBPUSD chart | 
 MagicNumber | 88800 | 88801 | 
 EnableParallel | true | true | 
 SiblingSymbol | GBPUSD | EURUSD | 
 SiblingMagic | 88801 | 88800 | 
 BlockIfSiblingHalted | true | true | 
 BlockIfSameDir | false (opt in) | false (opt in) | 
 MaxCombinedTradesDay | 0 (no cap) | 0 (no cap) | 
 SiblingStaleSec | 30 | 30 | 
 Combined risk math: at the shipped 0.75% RiskPerTrade per EA, worst case where both pairs lose simultaneously equals 0.75 × 2 = 1.5% account risk per concurrent loss event — well under the 5% daily DD limit even in correlated stop runs. With BlockIfSiblingHalted active (default), the surviving EA stops opening new trades the moment the other halts, capping further account exposure.
 AI Diagnostics — category reference
 The EA continuously studies its own live trade history per symbol per magic number, ranks tuning suggestions by priority and statistical confidence, deduplicates them across sessions, and surfaces the top items on the dashboard. Diagnostics persist as JSONL files in <Common>\Files\tip_diag_<SYMBOL>_<MAGIC>.jsonl across restarts (capped at 200 most-recent rows per symbol). The bundled PowerShell analyser reads these files — see the next section for download & usage.
 Category | What the diagnostic detects | Priority levels | 
 SL_TP | Stop loss / take profit ratio versus realised volatility — flags when SL is too tight relative to ATR or when TP consistently overshoots available range | P2 | 
 DAY_FILTER | Day-of-week win rate analysis — flags days where WR is below 30% (consider blocking) and phantom days where a currently-blocked day looks profitable in your data (consider unblocking) | P1, P2, P3 | 
 SESSION | Hour-of-day win rate — flags hours below 30% WR (tighten session window) and phantom hours just outside the window that look profitable (consider expanding) | P1, P2, P3, P4 | 
 NEWS | News blackout effectiveness — phantom news windows where the EA was blocked but the price action turned out to be tradeable (consider relaxing blackout) | P1 | 
 SPREAD | Spread observations — flags when broker spread is consistently above 75% of MaxSpread, suggesting either a broker change or a MaxSpread bump | P3 | 
 VERDICT | Lifetime overall verdict — flags when lifetime WR drops below 30% over 20+ trades, the strongest signal that the configuration needs revisiting | P1 | 
 The Shield Circuit Breaker
 The Shield is a peak-equity-aware drawdown brake that runs alongside the prop firm rails. It tracks peak equity, arms when account is in profit by a configurable percentage (so it never triggers on a fresh-start losing streak), and halts trading when equity drops a configurable percentage below the recorded peak. Three recovery modes:
 Permanent — once Shield fires, EA stops until manually re-armed
 Next-Day — Shield resets at the start of the next trading day
 Recovery% — Shield re-arms automatically when equity recovers a configurable percentage of the lost ground
 Default arm trigger 3% in profit, default brake 3% drawdown from armed peak. The Shield fires before the prop hard rails so it acts as an early warning brake, not a last-resort stop.
 Cross-Symbol Diagnostics Script (analyze_diagnostics.ps1)
 The Impossible Prop writes per-symbol tuning suggestions to tip_diag_<SYMBOL>_<MAGIC>.jsonl files in your MT5 Common\Files folder while it runs. The bundled PowerShell script analyze_diagnostics.ps1 reads every diagnostics file across all your charts and terminals at once, dedupes suggestions, and ranks them by Priority → Confidence → Seen-count so you know which single parameter to investigate next.
 ⚠️ Important — file rename required after download 
 MQL5 attachment filters do not accept files with the .ps1 extension (PowerShell executable scripts are blocked at upload for security reasons). The script is therefore attached here with a trailing .txt extension as analyze_diagnostics.ps1.txt . You must rename it back before running.
 Steps: 
 Download analyze_diagnostics.ps1.txt from the attachments at the bottom of this post
 In Windows Explorer, right-click → Rename (or press F2) and remove the trailing .txt so the filename becomes analyze_diagnostics.ps1 If you can't see file extensions in Explorer: open Explorer → View tab → tick File name extensions 
 Right-click the renamed file → Properties → if you see an Unblock checkbox at the bottom, tick it and click OK (Windows marks downloaded scripts as untrusted by default)
 Open PowerShell, cd into the folder where you saved it, and run: pwsh .\analyze_diagnostics.ps1 
 The script auto-discovers your MT5 Common\Files folder plus every per-terminal MQL5\Files folder under %APPDATA%\MetaQuotes\Terminal — no path editing required. Run it weekly while the EA is live and it will surface the next single-variable tuning candidate from your real trading data.
 Useful flags: 
 -Symbol GBPUSD — only show suggestions for one pair
 -MaxPriority 2 — only show high-priority (P1, P2) suggestions
 -Path 'D:\MT5_Portable\MQL5\Files' — point at a portable terminal install
 -TopN 10 — limit console output to the top 10 ranked suggestions
 Full options documented in the script header (open the .ps1 file in any text editor to view).
 Output: ranked console table + diagnostics_summary.csv in your current working directory.
 Sizing for Different Challenge Sizes
 The shipped presets target a $100K account, but the EA scales to any challenge size. Lot sizing is computed automatically from current account equity, so you only need to adjust the risk and drawdown parameters to match your firm's rules. The table below assumes the standard 5% daily / 10% total drawdown framework — if your firm uses different limits, set PropDailyDD and PropMaxDD to match.
 Account Size | RiskPerTrade (per EA) | PropDailyDD (%) | PropMaxDD (%) | PropPhaseTargetPct | Daily $ DD Limit | Notes | 
 $5,000 | 0.75% | 5.0 | 10.0 | 10.0 | $250 | Micro lots required — verify broker minimum lot is 0.01 | 
 $10,000 | 0.75% | 5.0 | 10.0 | 10.0 | $500 | Standard small evaluation | 
 $25,000 | 0.75% | 5.0 | 10.0 | 10.0 | $1,250 | Common entry-tier challenge | 
 $50,000 | 0.75% | 5.0 | 10.0 | 10.0 | $2,500 | Mid-tier challenge | 
 $100,000 | 0.75% | 5.0 | 10.0 | 10.0 | $5,000 | Shipped preset baseline — no changes needed | 
 $200,000 | 0.75% | 5.0 | 10.0 | 10.0 | $10,000 | Large funded account — consider 0.5% risk for capital preservation | 
 $400,000+ | 0.5% | 5.0 | 10.0 | 10.0 | $20,000+ | Lower risk recommended on larger sizes | 
 Important: Both EAs share the daily DD budget when running in parallel. The RiskPerTrade values above are per EA — combined worst-case daily exposure with both EAs active stays inside the 5% daily DD limit at the recommended sizing. If you only run one EA (single pair), you can raise RiskPerTrade to 1.0–1.25% but verify with a backtest first.
 For non-standard prop firm rules (e.g. 4% daily / 8% total, or trailing drawdown), adjust PropDailyDD and PropMaxDD to match your firm's exact framework before going live. Demo-test for at least 2 weeks at the new settings.
 Personal Account Mode — same EA, parallel siblings, prop rails off
 To run TIP on a personal account (broker account, not a prop evaluation), set EnablePropFirm=false in both presets. The two EAs still run side-by-side with the full Parallel Awareness sibling handshake intact — only the prop hard-rails (PropDailyDD / PropMaxDD / PropPhaseTargetPct) are bypassed. Everything else — Shield, daily loss, consecutive-loss pause, news filter, spread filter, weekly regime block, sibling cross-monitoring — stays active and untouched.
 With the prop ceiling removed you can scale RiskPerTrade up. Three reference profiles — pick the row that matches your appetite, then demo-test for 2 weeks before going live:
 Profile | RiskPerTrade (per EA) | Indicative annual return* | Indicative max DD* | Suggested for | 
 Prop-safe (default) | 0.75% | ~21% / yr | ~7.8% | Funded prop accounts (challenge or live phase) — leave EnablePropFirm=true | 
 Personal — balanced | 1.5% | ~42% / yr | ~15.6% | Personal account, conservative growth, low stress | 
 Personal — aggressive | 2.5% | ~70% / yr | ~26% | Personal account, higher risk tolerance | 
 Personal — high conviction | 3.0% | ~84% / yr | ~31% | Experienced personal-account trader, demo first | 
 *Linear extrapolation from the 0.75% baseline using the OOS audit window. Position size scales linearly so return and drawdown scale together — these are guidance figures, not guaranteed outcomes. Always validate at your chosen risk on demo before going live. 
 What changes vs prop mode: 
 Prop hard-rails (PropDailyDD / PropMaxDD / PropPhaseTargetPct) — bypassed 
 RiskPerTrade — typically 1.5%–3.0% per EA instead of 0.75%
 Everything else (Shield, daily loss cap, news filter, spread filter, weekly regime, Parallel Awareness) — unchanged and active 
 Both presets still run side-by-side on the same account with the sibling handshake intact
 One binary, one set of presets, one toggle. The same edge that's engineered to pass FTMO-grade rules is the same edge that runs on your personal account — just with the artificial ceiling removed and the dial turned up.
 Live Performance Updates
 Verified performance results and strategy updates are posted in the MQL5 blog . Join the community via the Discord link in the Links table above for discussion and trader chat.
 ⚠️ Disclaimer 
 Always test on a demo account for at least 2 weeks before running on a live or funded account
 Both EAs must run in the same MT5 terminal on the same account for the Parallel Awareness layer to function — it relies on terminal-local GlobalVariables for the sibling handshake
 Past performance and backtest results do not guarantee future results
 Trading carries risk of capital loss — only trade with funds you can afford to lose
