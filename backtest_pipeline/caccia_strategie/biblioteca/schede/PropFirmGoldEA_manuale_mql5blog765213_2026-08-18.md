# SCHEDA — "PROP FIRM GOLD EA" — User Manual & Configuration Guide

- **URL:** https://www.mql5.com/en/blogs/post/765213
- **Vendor:** Eriksson Systems (XAUUSD) — prodotto a pagamento
- **Data del post:** 07/11/2025 — letta e archiviata il **18/08/2026**
- **Stato:** [VERIFICATO] pagina aperta da noi. Nessun `.set` pubblicato.
- **Perche' e' in biblioteca:** era la voce n.3 della lista M8 del `PIANO_PROP`
  ("lista input Prop Firm Gold EA"). **Il manuale c'e', i valori di default NO.**

## Le tre righe che contano

1. **Buffer, parola per parola:** _"Set the daily loss limit **below** your prop
   firm's maximum. **Example: If max allowed is 5%, set it to 4%**."_
   → seconda fonte VERAMENTE indipendente del 4% (la prima e' Profalgo).
2. **L'aritmetica del rischio giornaliero, parola per parola:**
   _"The EA can take **up to 3 trades in one trading day**. This means:
   **1% risk -> up to ~3% total daily loss (worst case)**; 0.5% risk -> up to
   ~1.5%."_ → e' esattamente il conto che manca a noi (riga C1 del PIANO_PROP).
3. **Portafoglio:** _"Divide **total account risk equally across multiple EAs**,
   based on backtest results."_
4. ⚠️ **Effetto collaterale dichiarato:** _"This feature closes **all trades on
   the account, including trades from other EAs**... This is **intentional**."_
   Identico al nostro `FlattenAll()`.

---

 PROP FIRM GOLD EA – USER MANUAL & CONFIGURATION GUIDE
 7 November 2025, 03:09
 Jimmy Peter Eriksson 
 0 
 2 047
 Prop Firm Gold EA (XAUUSD) Developed by Eriksson Systems 
 ✅ 1) BASIC SETUP (LIVE TRADING)
 Symbol: 
 XAUUSD (Gold only)
 Timeframe: 
 Works on any timeframe
 Recommended Broker Conditions: 
 Low spread
 Low commission
 Broker time zone GMT+2 / GMT+3 
 ✅ 2) MAGIC NUMBER & TRADE COMMENT
 Always use a unique Magic Number 
 If running multiple EAs, each EA must have its own Magic Number 
 Prop firms: using a custom trade comment is recommended
 📊 3) DETAILED INFO PANEL
 You can enable the Detailed Info Panel to monitor your EA’s historical live performance directly on the chart.
 The panel provides a clear overview of performance metrics, including:
 Total P&L
 Total trades
 Win rate
 Profit factor
 Current drawdown
 Biggest win
 Biggest loss
 And other key statistics
 It also displays an equity curve , allowing you to visually track how the EA has performed over time.
 This makes it easier to track live performance , compare results with backtests, and make data-driven decisions instead of emotional ones.
 ✅ 4) BACKTESTING SETTINGS (IMPORTANT)
 Correct tester settings are essential for realistic results.
 Recommended Test Period
 📌 Long-term testing is strongly recommended 
 Most brokers provide reliable Gold data from 2018 → Present 
 Dukascopy M1 data can be used , and the EA has been tested back to 2010 
 Gold behavior changes significantly over time, so testing across multiple market cycles is important.
 Recommended Modeling Method
 📌 1 Minute OHLC (Open / High / Low / Close) 
 Do NOT use: 
 Every Tick
 Real Tick Data
 Reason: 
Tick data often contains incorrect spreads, gaps, and broker-specific inconsistencies.
This EA processes logic on new M1 candle openings , so tick modeling provides no advantage.
 If Your Backtest Looks Different From Live / Page Results
 This is usually caused by:
 Incorrect spread or commission settings in the tester
 Low-quality historical data
 Using tick modeling instead of M1 OHLC
 📌 Also recommended: 
Backtest using risk based on starting balance / fixed balance , not equity-based risk.
 ✅ 5) RISK SETTINGS (VERY IMPORTANT)
 ⚠ Fixed lot size is NOT recommended 
 Gold volatility changes heavily, and current gold volatility is very high .
 This EA adapts automatically:
 Higher volatility → larger stop loss distance
 Lot size adjusts dynamically to keep risk stable
 Manual Risk Explanation
 When using Manual Risk (%) , the percentage you set represents the maximum risk per trade .
 Example:
 If you set 1% risk , a trade that hits stop loss will lose approximately 1% of your account balance 
 The EA can take up to 3 trades in one trading day 
 This means:
 1% risk → up to ~3% total daily loss (worst case) 
 0.5% risk → up to ~1.5% total daily loss (worst case) 
 This is important to consider when trading with prop firm daily loss limits .
 Recommended Risk Guidelines
 Prop Firms: 
📌 Use low risk settings 
 Portfolio Trading (Multiple EAs): 
📌 Use manual risk 
📌 Divide total account risk equally across multiple EAs , based on backtest results
 🛡 6) DAILY DRAWDOWN PROTECTION (PROP FIRMS ONLY)
 📌 Recommended ONLY for prop firm accounts 
 Set the daily loss limit below your prop firm’s maximum 
 Example: If max allowed is 5%, set it to 4% 
 ⚠ Important Behavior: 
 This feature closes all trades on the account , including trades from other EAs
 Trades may be closed earlier than intended by trade logic 
 This is intentional and required to protect the account from breaking prop firm rules .
 📌 Not recommended for personal accounts .
 💰 7) MINIMUM BALANCE
 📌 Minimum recommended balance: $500
 📌 Recommended during high volatility: $1000+
(for safer margin levels and smoother performance)
 ✅ QUICK RECOMMENDED SETTINGS (BEST DEFAULT)
 ✔ XAUUSD
✔ M30 timeframe
✔ Low risk (prop firms)
✔ Stop Loss Size: Small (smaller accounts) / Large (larger accounts)
✔ Daily Drawdown Protection = ON (prop firms only)
✔ Backtest using 1 Minute OHLC
✔ Long-term testing (2010+ recommended)
✔ Unique Magic Number per EA
 DISCLAIMER
 Trading involves risk.
This EA can experience losing periods.
Past results do not guarantee future performance.
 Always test on demo accounts and use proper risk management.
 To add comments, please log in or register 
 [iVISTscalp5]: Week-Ahead LAP Timing Forecast (EURUSD) 
 Analytics & Forecasts 
 29