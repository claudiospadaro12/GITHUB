# SCHEDA — "Range Breakout Day Trader" — manuale + impostazioni prop

- **URL:** https://www.mql5.com/en/blogs/post/760349
- **Data del post:** 21/12/2024, preset aggiornati fino a **giugno 2026** — letta e archiviata il **18/08/2026**
- **Cosa e':** manuale pubblico di un EA di **range breakout intraday** (prodotto a
  pagamento su MQL5 Market) + **32 file `.set`** pubblici, archiviati in
  `biblioteca/set/RangeBreakoutDaytrader_*.set`
- **Stato:** [VERIFICATO] pagina aperta da noi. Numeri e screenshot di conti FTMO
  passati = **[dichiarato dal vendor, NON verificato]**, non pesano.

## Le tre righe che contano per noi

1. 🔴 **Il filtro news E' BACKTESTABILE** — parola per parola:
   _"If you want to use the news filter in back testing, you have to save the MT5
   economic calendar as a **CSV-file in the Common/Files directory** for the time
   period you want to test."_ Piu' un `news.csv` pubblico scaricabile
   (archiviato in `biblioteca/schede/CALENDARIO_news-*.csv`).
   **Questo scioglie il blocco dichiarato in `PIANO_PROP` D1** ("il calendario
   nativo non risponde nel tester"): non risponde la *funzione*, ma un CSV
   esportato una volta dal terminale vivo si', ed e' leggibile nel tester.
2. 🔴 **La scala di rischio legata al cuscinetto di equity** — parola per parola:
   _"it's recommended to **start with the EXTRA LOW RISK settings and switch to
   the LOW RISK once the balance has grown enough. But once the profit drops
   below zero, then make sure to switch back to the EXTRA LOW RISK settings**."_
   E' il meccanismo n.8 del censimento della prima notte ("riduzione del rischio
   in prossimita' dei muri"), che allora risultava **dichiarato da NESSUNO**.
3. **La regola di taratura**: _"Make sure that the max. equity drawdown percentage
   is **lower than the daily allowed drawdown** for the challenge"_ — quinta voce
   indipendente sul "guardiano prima del muro".

## I valori dei preset (dai 32 `.set`, identici su tutti e 4 i simboli)

| profilo | `RiskPercentage` | `_MaxLoss` |
|---|---:|---:|
| ExtraLowRisk | **2,4** | **2,4** |
| LowRisk | 4,7 – 4,8 | 4,7 – 4,8 |
| MediumRisk | 10 | 10 |
| HighRisk | 20 | 20 |

I quattro profili di uno stesso simbolo differiscono **SOLO** su questi due
parametri, che sono **sempre tenuti uguali fra loro**. Tutto il resto (orari,
filtri, trailing, news) e' identico.

Filtro news, valori uguali su tutti i preset:
`HighImpactNewsFilter=true` · `ModImpactNewsFilter=false` · **`TimeToClose=5`**
(minuti prima della news in cui chiude posizioni e pendenti) ·
`FFCalendar=true` · `FFURL=https://nfs.faireconomy.media/ff_calendar_thisweek.xml`
· `NewsUpdateFreq=60` (minuti) · `IgnoreNews=Crude oil` (esclusione per NOME
evento) · toggle per valuta (`ReportForUSD` ... `ReportForCNY`).

Orari (ora del server dell'autore, con input `TimeOffset` per correggere da
UTC+2): USDJPY range 01:00→13:50, chiusura sessione 20:00 · US30 range 01:00,
chiusura 22:00 · XAUUSD range 02:00, chiusura 17:00 · BTCUSD range 04:00,
chiusura 17:00. `InpClosingSession=true` ovunque = **chiusura programmata di
fine sessione**, che noi non abbiamo.

---

## Estratto testuale del manuale

 Manual for Range Breakout Day Trader
 21 December 2024, 14:01
 Aroen Mughal 
 0 
 1 828
 Expert advisor product pages: 
 Range Breakout Day Trader MT5 version 
 Range Breakout Day Trader MT4 version 
 This page contains the manual and set-files of the Range Breakout Day Trader. 
 Before you use this Expert Advisor, you first have to add this URL: " nfs.faireconomy.media"  in the allow webrequests which you can find in the Meta Trader menu in  'Tools/Options/Expert Advisors' .
 This will allow the EA to get news data from the forex factory website. This news data is used by the news filter which will close any open position at a certain time before the high/medium impact news release. In the EA settings you select the country currencies which are used in the currency pair which you are trading. Avoiding financial news releases is important to prevent possible big losses, especially if you are managing a prop firm account. Some prop firms also don't allow trading during high impact financial news releases. 
 In the MT5 version you can also choose to use the built in calendar of MT5 instead of the Forex Factory calendar. When the news filter is turned on, you can set the amount of minutes it will close any open positions/orders before the news is released. 
 Another advantage of this EA is that it can also do back testing with the news filter on (this is only possible for the MT5 version because it can handle big news databases by using SQLite which is not possible in the MT4 version). Doing back tests with avoiding high impact news releases will give more realistic results, because your strategy will not be effected by the volatility during news releases which can effect the results in a negative or overoptimized way. Without a news filter in the back test your strategy's performance rely more on chance during volatile news events than on proper statistics. And there is the problem that you might pick only the optimized results which were profitable during these news events.
 Important! 
 To be able to do back tests with news events, you will first have to download this news.csv file with news data from 01.01.2021 to 31.12.2024 and place it in the following directory:  
 C:\Users\<username>\AppData\Roaming\MetaQuotes\Terminal\Common\Files
 In the comments section there is also a news.csv file with data from 2018 till 2024, but make sure that you don't use more than 4 years of data (delete the other years from the CSV file) or it might be too much data to be able to converted into the SQLite data base.
 Here are the recommended set files per risk level which you can load into the settings of the Expert Advisor
 Set-files MT5 
 USDJPY, Extra Low Risk 
 USDJPY, Low Risk 
 USDJPY, Medium Risk 
 USDJPY, High Risk 
 BTCUSD, Extra Low Risk 
 BTCUSD, Low Risk 
 BTCUSD, Medium Risk 
 BTCUSD, High Risk 
 US30, Extra Low Risk 
 US30, Low Risk 
 US30, Medium Risk 
 US30   , High Risk 
 XAUUSD, Extra Low Risk 
 XAUUSD, Low Risk 
 XAUUSD , Medium Risk 
 XAUUSD , High Risk 
 The set-files for BTCUSD, US30 and XAUUSD are for  a 2 digit symbol. If the symbol has a different amount of digits, then adjustments need to be made in the set-files. 
 Set-files MT4 
 USDJPY, Extra Low Risk 
 USDJPY, Low Risk 
 USDJPY, Medium Risk 
 USDJPY, High Risk 
 BTCUSD, Extra Low Risk 
 BTCUSD, Low Risk 
 BTCUSD, Medium Risk 
 BTCUSD, High Risk 
 US30, Extra Low Risk 
 US30, Low Risk 
 US30, Medium Risk 
 US30, High Risk 
 XAUUSD, Extra Low Risk 
 XAUUSD, Low Risk 
 XAUUSD , Medium Risk 
 XAUUSD , High Risk 
 The set-files for BTCUSD, US30   and XAUUSD are for  a 2 digit symbol. If the symbol has a different amount of digits, then adjustments need to be made in the set-files. 
 PARAMETERS DESCRIPTION 
 Time settings: 
 Set start hour and minutes of the range
 Set end hour and minutes of the range
 Close position at predefined time    (on/off) 
 Set hour and minutes at which the position will be closed
 Set expiry time of pending stop order (in amount of hours)
 Set expiry time of pending limit order after retest (in amount of hours)
 Only do retests till time (time in 24h)
 Set time offset in hours to correct time from GMT/UTC+2
 Allowed trading days: turn on/off the days where trading is allowed by the EA
 Price range settings: 
 Maximum height of the price range
 Minimum height of the price range
 Trade settings: 
 Magic number: EA identification number
 Maximum spread size: If the current spread is higher than the predefined spread size the position or order will not be opened
 Lot mode: choose to set lot size according to the risk percentage or a fixed lot size
 Risk percentage: The risk percentage at which the lot size will be calculated
 Fixed lot size: The value of the lot size if a fixed lot size is set in the lot mode
 Stop loss: Set the stop loss in points or if you fill in 0, it uses the range distance as your stop loss distance
 Stop Loss based on ATR value   (on/off) 
 ATR multiplier 
 ATR period 
 Amount of points above/below the range to place pending orders
 *Maximum equity drawdown (on/off)
 Loss percentage (equity drawdown) at which the position will automatically be closed 
 Close at predefined take profit percentage: predefined profit percentage at which the position will automatically be closed  (on/off) 
 Multiple take profit levels (only available in MT5 version) 
 Turn on close part of total profit Percentage at TP1,2,3,4 
 TP1,2,3,4 price level as percentage of the total TP price level
 Percentage to close of total profit at TP1,2,3,4
 Trade alerts 
 Profit percentage at which a notification/email is send: predefined percentage at which the EA sends a notification or email
 Set hour or minutes after which the notification/email will not be send
 Send notification when predefined profit percentage is reached  (on/off) 
 Send email when predefined profit percentage is reached   (on/off) 
 Other trade settings 
 Open early position before the range price at range time end  (on/off) 
 Amount of points position is opened before the range price 
 Only open trade after retest of the breakout  (on/off) 
 Amount of points after breakout to start retest 
 Combine breakout with retest entries (on/off) 
 Automatically adjust the take profit and trailingstop start 
 Ratio (Risk) : (Take Profit)
 Ratio (Risk) : (Trailingstop Start)
 Ratio (Risk) : (Max. Equity Drawdown)
 Trailing stop settings: 
 Turn on trailing stop (on/off) 
 Profit percentage at which the trailing stop starts
 ATR multiplier: Value which will be multiplied with the ATR value (to set the trailing stop distance)
 ATR period: The period used for calculating the ATR (average true range)
 Use TP level based trailing stop instead of ATR based (only available in MT5 version)
 Trend filter settings: 
 Turn on trend filter (on/off) If turned on the trend filter will only place buy stop or sell stop orders in the direction of the trend
 Turn on OCO (One-Cancels-the-Other) pending orders if trend filter is turned off
 Time frame used for trend filter
 Signal period used for trend filter
 **News filter settings: 
 Turn on the news of the two currencies from the currency pair which you are trading (Make sure to turn off the news of the other currencies)
 Turn on moderate impact news filter (on/off) If turned on the news filter will close any open position or pending order before the first release of moderate impact news
 Turn on high impact news filter (on/off) If turned on the news filter will close any open position or pending order before the   first release of high impact news 
 Amount of minutes to close before news release
 ***Use the Forex Factory economical calendar instead of the MT5 economical calendar in live trading
 Ignore news containing the word you place here
 Change frequency of the forex factory calendar update (in minutes) 
 Select the countries from which the news will be used
 *Note: If you use the maximum equity drawdown, it needs to be checked with the stop loss setting. If the percentage max. equity drawdown is too low, your positions might get closed before it reaches the stop loss order and might increase your losses. 
 **Note: If you want to use the news filter in back testing, you have to save the MT5 economic calendar as a CSV-file in the Common/Files directory for the time period you want to test. Here you can find the script for creating the CSV-file:   MT5 Economic Calendar CSV exporter . 
 Or use the CSV-file with economical news from 2021.01.01 to 2024.12.31 which you can download   here . 
 ***Note: Add this URL: "nfs.faireconomy.media/ff_calendar_thisweek.xml" in the 'Allow webrequest' in menu: 'Tools/Options/Expert Advisors' to be able to use the Forex Factory calendar. 
 Prop Firm ( Proprietary Firm)  settings 
 The LOW RISK and EXTRA LOW RISK settings of this EA are suitable for prop firm challenges. Make sure that the max. equity drawdown percentage is lower than the daily allowed drawdown for the challenge. And importantly avoid days with news events like interest rate decisions, because the volatility during these news events cause slippage which can result in bigger equity drawdowns than what is set as maximum in the EA. Also it's recommended to start with the EXTRA LOW RISK settings and switch to the LOW RISK once the balance has grown enough. But once the profit drops below zero, then make sure to switch back to the EXTRA LOW RISK settings. If you want to keep it safe, it's best to use only the EXTRA LOW RISK settings. If you want to use even lower risk levels, let me know and I will setup the right set-file for you. 
 To show that this EA has successfully completed prop firm challenges, you can view my completed prop firm accounts at FTMO:
 FTMO Challenge 
 Verification 
 FTMO Account 