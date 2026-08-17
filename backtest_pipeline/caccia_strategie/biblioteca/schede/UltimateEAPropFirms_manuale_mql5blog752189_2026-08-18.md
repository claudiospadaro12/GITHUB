# SCHEDA — "Ultimate EA for Prop Firms" — Presentation, Manual and Presets

- **URL:** https://www.mql5.com/en/blogs/post/752189
- **Data del post:** 18/03/2023 (aggiornato agosto 2023) — **letta e archiviata il 18/08/2026**
- **Cosa e':** manuale pubblico + 8 preset `.set` (archiviati in `biblioteca/set/UltimateEAPropFirms_*.set`)
- **Stato:** [VERIFICATO] pagina aperta da noi. Numeri di performance = [dichiarato dal vendor, NON verificato].
- 🚩 **Attenzione:** l'EA ha input `martingala` e una modalita' **TIME GRID** (griglia
  a lotto fisso, fino a `maxTrades=15`, senza SL individuali). Per il setaccio di
  casa e' materiale da SCARTARE come motore. **Si conserva per la CONFIGURAZIONE
  prop, non per la strategia.**

> ⭐ La riga che vale il giro (manuale, parola per parola):
> _"Daily Drawdown -> the maximum daily drawdown imposed by the rules of the prop
> firm you are doing. **Advice: keep it slightly lower than the rule to have some
> margin in case of fast price movements (Ex: if the prop imposes a 5% daily dd,
> set this option to max 4.9)**."_

---

 Ultimate EA for Prop Firms - Presentation, Manual and Presets
 18 March 2023, 16:33
 Riccardo Borello 
 2 
 2 651
 ULTIMATE EA FOR PROP FIRMS 
 Presentation and guide 
 Hello, and welcome to the presentation of Ultimate EA for Prop Firms. Here you will find all the information you need to understand how this EA works, and how to best use it. 
 Link to product page   →  https://www.mql5.com/it/market/product/95640 
 This product is the version that contains all the strategies I have developed specifically to pass the challenges, with the possibility to choose which one to use every time! If you want, you can purchase the expert advisors individually at lower price by clicking here: 
 https://www.mql5.com/it/users/riccardoborello01/seller 
 Where can I use it? 
 As the name says, this EA is specially developed to pass challenges. In particular, the backtests were performed on MyForexFunds historical data, but it works the same way on other prop firms as long as they have similar rules. It works only on MetaTrader 5 . 
 What strategies does it use? 
 You can choose between 6 different strategies that use different indicators, which tell the EA when to open positions and where to set the stop loss. 
 You can choose from the following strategies, all backtested before being published: 
 MACD Strategy 
 Alligator Strategy 
 MACD + RSI + Stochastic Strategy 
 Parabolic SAR Strategy 
 Ichimoku Strategy 
 SuperTrend Strategy 
 And more may be added in the future via updates! 
 What assets does it work on? 
 It works on all forex pairs and indexes in all timeframes, but I'll advise you where to use it. 
 What functions does it have for challenges? 
 Daily anti-drawdown control : if the daily drawdown set in the inputs is reached, the EA immediately closes the current trades. 
 Total drawdown (useful for backtesting) : allows you to discard an input set in the optimization phase if this drawdown is reached. 
 Profit target : if it is reached during a trade, the current operations are automatically closed and no others will be opened for the current month. 
 I bought the EA, now how do I proceed? 
 First of all, make sure you are using a 24/7 VPS. 
 Now, you will find the EA on the MT5 navigator and by clicking on it you can attach it to the open chart of the suggested forex pair and timeframe (you can find it in the Backtest paragraph) and set the parameters as follows. 
 There are two possibilities: either you are using the default parameters to pass a first challenge phase, or you are using a set of settings that I sent you. In each of these cases, you will need to modify only these inputs: 
 Initial capital → the initial budget of the challenge. If you are starting a 20k challenge then enter 20000, if you are starting a 50k challenge enter 50000 and so on. This will help open trades with the right lot size, so if you get it wrong, the bot may open positions that are too big or too small. 
 Profit target → as the name implies, it is the percentage of the initial capital at which all operations will be closed. Then enter 8 if you are doing a first phase, 5 if you are doing a second phase, or any target you want to reach if you already have the founded account. When the account equity reaches this target, no more trades will be opened in the current month in case of founded account, and in general if you are in challenge. 
 Asset → specify here on which asset you will use the EA (forex or indexes). 
 Max ticks spread → is the maximum number of spread ticks with which to open a trade. If the current spread is higher than this number, no trade will be opened even if there is confirmation from the indicators. 
 Monthly Restart → it's only useful for backtesting, so if you're using the bot on any account, keep this option false. The explanation on how it works is in the "backtest" paragraph. 
 Previous month loss recovery → Another function useful only for the backtest, connected to the monthly restart and therefore explained later. 
 Test mode → keep this option false if you are using the bot on any account, set it to true if you are only backtesting it. 
 Daily Drawdown → the maximum daily drawdown imposed by the rules of the prop firm you are doing. Advice: keep it slightly lower than the rule to have some margin in case of fast price movements (Ex: if the prop imposes a 5% daily dd, set this option to max 4.9). 
 Monthly Drawdown → the maximum drawdown imposed by the challenges which is usually between 10% (FTMO) and 12% (MyForexFunds). If you already have a funded account, this is the maximum total drawdown that can be reached. 
 Magic Number  → u nique identifier used by the Expert Advisor to specifically distinguish and manage the various open positions. In this way it is possible to use the bot on multiple charts at the same time by setting a different magic number on each of them
 All other inputs can be changed at will, but it is preferable not to do so to improve the performance of the EA a lot. 
 Explanation of other input parameters 
 Risk Reward → it is simply the risk-reward ratio that each trade will have. 
 Risk Percentage → this is the percentage of your initial capital that will be risked on each trade. Based on this value the struggle of each trade is calculated. Usually, 1% is risked having a high chance of passing the challenges. 
 Take Profit Type → take profit can be reached through fixed risk reward or through the reversal of the signal of the indicators. 
 Strategy → indicates the type of strategy used by the EA to open orders. 
 Martingale → if set to true it uses a martingale strategy. 
 Closing trade by spread increase → if the spread in ticks reaches this value, then the open trades are closed. 
 Breakeven → In this case we have to make a distinction between the case in which a take profit type with fixed risk reward or with reverse signal is set. 
 If Take Profit Type is set to FIXED RR then this value indicates at what percentage of the trade, it will be set to breakeven. For example, if breakeven = 0.5 and the risk reward = 5, when the trade reaches half of its risk reward (therefore 2.5) it will be set to breakeven. If breakeven = 0 or breakeven = 1, then breakeven is disabled. 
 If Take Profit Type is set to REVERSE SIGNAL then this value indicates at what risk reward the trade will be set to breakeven. For example, if breakeven = 1, when the trade reaches 1:1 risk reward, it will be set to breakeven. If breakeven = 0, then breakeven is disabled. 
 TP1 & TP2 → for the partial tp the same applies to the breakeven based on Take Profit Type . They are active only if they have a value between 0 and 1 excluded (if Take Profit Type is set to FIXED RR). So, here are some examples: 
 TP1 = 0 and TP2 = 1 → both disabled 
 TP1 = 0.5 and TP2 = 0.7 → TP1 will be withdrawn at 50% of the operation and TP2 at 70% 
 TP1 = 0.6 and TP2 = 0.2 → TP1 will be picked up at 60% of the trade, while TP2 is disabled 
 TP1 = 0.3 and TP2 = 1 →  TP1  will be picked up at 30% of the trade, while TP2 is disabled 
 They are active only if they have a value greater than 0 (if Take Profit Type is set to REVERSE SIGNAL). So, here are some examples:
 TP1 = 0 and TP2 = 0 → both disabled 
 TP1 = 1 and TP2 = 2 → TP1 will be withdrawn at 1:1 risk reward of the operation and TP2 at 1:2 risk reward. 
 TP1 = 1 and TP2 = 0.2 → TP1 will be picked up at 1:1 risk reward, while TP2 is disabled 
 For both cases, the TP2 is active only if it is higher than the tp1. Also, keep in mind that if both partials are active, each will close out one third of the trade, leaving the last third open until the final TP. If instead only TP1 is active, it will close half of the trade.
 Additional pips → (only for forex) stop loss pips added to those already calculated through the indicators. Usually, this value is between 0 and 1. 
 Max & Min pips Stop → Stop loss pips limits. If the indicators signal to open a trade with too large or too small a stop loss, it is not opened. 
 Moving Average Distance → (only for forex) minimum distance of the price from the moving average for a trade to be opened. 
 Trading days → operational days, set to YES to enable possible operations for each day. 
 Time → operating hours, each trade will be opened only within this time range. 
 Indicators → input parameters for the various indicators used on the type of strategy that you have chosen. 
 I activated the bot two days ago and it still hasn't opened trades, is this normal? 
 Yes, if you have set everything up correctly it's normal, because this EA works on timeframes like M5, M6 and M10 and therefore it doesn't necessarily have to open every day. Also, it is developed to only open one trade at a time, so don't worry if maybe a week has gone by and the bot has only opened for example 3 trades. There is always at least one month for the challenges, and this bot can pass them either on the first day or after 3 weeks. So just be patient. 
 NEW (AUGUST 2023)! TIME GRID OPERATIVITY 
 With the new update, a new trade type has been added, applicable to all available strategies with indicators. 
 By activating it, the bot will receive signals from indicators as in fixed risk reward and reverse signal strategies, but will not risk a fixed percentage of capital. Instead, it will open a first trade with a lot size set via input and then other trades with another fixed lot size at the opening of each successive candle, up to a set maximum number. Open trades will be closed when the sum of their profits or losses reaches a certain percentage. 
 Time grid therefore allows you to open trades without stop losses and without take profits, which will be managed entirely by the bot. It also does not use breakeven, partial take profits and works on all types of assets. 
 Time Grid input parameters:
 Initial lot size  → Lot size of first trade 
 Next trades lot size  →  lot size of following trades, from second to last
 Max Trades →  maximum number of trades
 Aggregate TP % →  the sum of the profits of all open trades at the same time to make them all close
 Aggregate SL % →  the sum of the losses of all open trades at the same time to make them all close
 NOTE : if you use the presets sent by me or downloaded from this page, you have to adapt the lot size settings according to the account you use. Example: in the preset the initial capital is 10000 and the initial lot size is 0.4, while you have an account of 20000. So you have to set the initial lot size to 0.8
 Presets with Time Grid (More to come...) 
 Challenge Phase 1 (Target 8%, Daily DD 5%, Total DD 12%) 
 Characteristics: 
 Period: Aug 2022 – Jul 2023 (12 months) 
 USDJPY M5 
 Strategy: SuperTrend 
 Initial lot size: 0.4 
 Next trades lot size: 0.3 
 Max Trades: 8 
 Aggregate TP %: 2 
 Aggregate SL %: 3 
 Days of trading: Monday, Wednesday, Thursday 
 Time (UTC+1): 00.45-19.45 
 File name (at the bottom of the page): UEA_Phase_1_UJ_M5_Time_Grid.set
 BACKTESTING 
 If you want to try a different challenge than the classic ones like FTMO and MyForexFunds, that's no problem: you can optimize the bot yourself to get the combinations of input parameters suitable for the challenge you want to start. 
 First of all open the MT5 strategy tester (CTRL+R), and then select "optimization". 
 Now select the forex pair, timeframe and period of time you want to test. 
 For "modelling" you can keep "1 minute OHLC" for fast optimizations. Once the optimization is complete, it is recommended to test them with "every tick" to see if the results are the same. They may change, but only slightly, as the EA waits for the candle to close before opening trades. On "Optimization" set "custom max" (reason explained later). 
 Now click on "Inputs" and select the parameters you want to optimize by clicking on the tick to the left of each one. Turn on test mode by setting it to true. 
 Not all parameters need to be optimized: those that must remain fixed for each test (therefore relating to the rules of the challenge or the funded account) must be set in the right way before starting the optimization (such as initial capital, profit target and drawdown). 
 Monthly restart : This is a useful feature for backtesting and optimizations, in particular for the first phase, given that the time to pass it is usually 1 month. If activated, it will reset profits and losses at the end of each month, but only if no drawdown has occurred. 
 If deactivated however, when the following month begins it will consider any losses from the previous month in the case of a negative streak, therefore if the drawdown is reached after 2 months or more, it will be detected. 
 Previous Month Loss Recovery : If the Monthly Restart is disabled, then this function can be useful, which allows you to count the month following the negative one as a target month only if the loss is also recovered. 
 Example →   at the end of January 2020 the EA is -5%: 
 Monthly restart true →   in February 2020 the backtest will not consider the January loss and the drawdown will be counted only if it drops to -12% from the beginning of February. 
 Monthly restart false, Previous Month Loss Recovery true  → in February 2020 the loss of January will be considered, and if it drops to -7% in January, a drawdown will be signaled. Furthermore, if the target is 8%, in February it will have to recover the -5% of January and therefore make a +13% to be considered a target month. 
 Monthly restart false, Previous Month Loss Recovery false  → in February 2020 the loss of January will be considered, and if it drops to -7% in January, a drawdown will be signaled. Furthermore, if the target is 8%, in February it will have to do +8% to be considered a month on target, without having to recover the loss of January 
 Optimization through custom max 
 This feature is useful for getting the number of months the challenge was passed during the backtest period. 
 At the end of the optimization, you will see a screen that looks like this: 
 Result → By optimizing through custom max, here you will find the count of the months with challenge passed and free retry (i.e. month closed in positive but without reaching the target). 
 This value is calculated in order to distinguish the months with the target achieved and the positive months without the target achieved: in fact, in the example photo you see values ​​ such as 30005, 29005 etc., here they are explained: 
 30005 = 30 months of target achieved + 5 positive months. Therefore, if the backtest period was 36 months, only 1 month was closed in the negative. 
 Also, if at any point in the backtest period the drawdown is reached, this value will be set equal to 0 to cause the parameter set to be automatically discarded. So, we just order the input parameter combos by custom max to get the best combos for our challenge! 
 Now, let's analyze the best combo we found by double clicking on it: 
 Total trades → it gives us an indication of the amount of open trades. In fact, knowing that the period in this case is 36 months, we obtain that on average this combination of parameters opens 14 trades per month. 
 OnTester result → is the value of the custom max, therefore the number of months of challenge passed and those closed in positive (as explained above) 
 Note: The backtests were performed also taking into account the spread and commissions ($3 per lot) of MyForexFunds.
 Default parameters combination 
 As mentioned above, you can optimize the EA yourself and find the input sets you prefer, but you can save time by directly using the ones I already found (I remind you that my tests were performed on historical data from MyForexFunds, so if you are using a different broker you may get slightly different data from mine), here are some of them (you can download the preset files at the end of the page): 
 Challenge Phase 1 (Target 8%, Daily DD 5%, Total DD 12%) 
 Characteristics: 
 Period: Jan 2020 – Jul 2023 (43 months) 
 AUDUSD M5 
 Strategy: Alligator 
 RR 1:6.3 
 Risk Percentage: 1% 
 BE: 0.4 
 TP1: 0.8 
 Pips: 6 (min) – 20 (max) 
 Days of trading: Monday, Thursday, Friday 
 Time (UTC+1): 03.00-15.45 
 File name ( at the bottom of the page): UEA_Phase_1_AU_M5.set
 Challenge Phase 1 (Target 8%, Daily DD 5%, Total DD 12%) 
 Characteristics: 
 Period: Jan 2020 – Jul 2023 (43 months) 
 GBPUSD M5 
 Strategy: MACD 
 RR 1:7.35 
 Risk Percentage: 1% 
 BE: 0.3 
 Pips: 1 (min) – 17 (max) 
 Days of trading: all except Monday 
 Time (UTC+1): 04.30-15.45 
 File name (at the bottom of the page): UEA_Phase_1_GU_M5.set
 Challenge Phase 2 (Target 5%, Daily DD 5%, Total DD 12%) 
 Period: Jan 2020 – Aug 2023 (43 months) 
 AUDUSD M5 
 Strategy: MACD+RSI+STOCH 
 RR 1:6.8 
 Risk Percentage: 1% 
 BE: 0.9 
 Pips: 4 (min) – 14 (max) 
 Trading days: Monday, Thursday, Friday 
 Time (UTC+1): 07.30-12.45 
 File name (at the bottom of the page): UEA_Phase_2_AU_M5.set
 Funded account (Target 2%, Daily DD 5%, Total DD 12%) 
 The following preset was backtested without monthly restart and with loss recovery. Basically it means that it has never gone on a drawdown since January 2019 and, if it has closed a month with a loss, it has always recovered it in the following month. Also, to keep the account as long as possible, the target is 2% per month
 Period: Jan 2019 – Jun 2023 (53 months) 
 GBPUSD M5 
 Strategy: MACD 
 RR 1:7.9 
 Risk Percentage: 1% 
 BE: 0.4 
 TP1: 0.1 
 Pips: 6 (min) – 24 (max) 
 Trading days: Tuesday, Thursday, Friday 
 Time (UTC+1): 04.15-19.45 
 File name (at the bottom of the page): UEA_Funded_GU_M5.set
 If you already have a funded account or want to use the EA to make a profit every month, you can optimize yourself using the preset provided at the bottom of the page. Set the profit target as you like and find your combo! 
 To obtain profitable long-term input sets and avoid losing live accounts, it is recommended to optimize with profit targets that are not too high (for a funded account, I recommend not going beyond 3%) and over a period of time of several years , with the monthly restart set to false to avoid drawdowns over consecutive months. 
 In any case, I will add additional parameter sets here that I will find from now on for any type of account. 
 Files: 
 Combo_Preset_UEA_Fixed_RR_Optimization.set 
  6 kb 
 Combo_Preset_UEA_Reverse_Signal_Optimization.set 
  6 kb 
 Combo_Preset_UEA_Time_Grid_Optimization.set 
  6 kb 
 UEA_Phase_1_AU_M5.set 
  6 kb 
 UEA_Phase_1_GU_M5.set 