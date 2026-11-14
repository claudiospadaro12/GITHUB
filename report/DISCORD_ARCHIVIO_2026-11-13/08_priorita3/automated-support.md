# #automated-support (ForexEASolutions) — dal 03/11/2026 00:00 UTC a oggi (13/11/2026)

Lettura in sola lettura. Orari in UTC (MM-GG THH:MM). Autore: indicato solo quando il messaggio ha intestazione; le righe senza autore sono continuazioni dello stesso autore del messaggio precedente.
ATTENZIONE: Digital_Wim è un bot ("APP verificata"), NON Wim. Le sue risposte non sono dichiarazioni di Wim.
Allegati: indicati solo come [ALLEGATO], senza nome né dimensione. Link e query string sostituiti con [link].

11-03T05:47 meanroaster: @Digital_Wim I changed the MaxDD setting from 50 to 100, but I haven't noticed any difference in the EA's trading behavior. The number of trades seems to be exactly the same as when MaxDD was set to 50. Under what conditions would this change start to make a [link] I'd also like to understand how increasing MaxDD from 50 to 100 actually affects the EA's trading behavior.
11-03T05:47 Digital_Wim (bot): You're talking about UBS's "Max Risk Per Strategy" style MaxDD. In UBS that setting mainly caps risk [link] lot size, it does not directly change how often a strategy trades. Only when the strategy's current drawdown plus a "possible next loss" would push above the MaxDD cap. Below that cap, the strategy trades exactly the same signals; only lot [link] is scaled from the historical max drawdown value and your Max Risk Per Strategy. Increasing MaxDD from 50 to 100 doubles the allowed total % drawdown budget for that strategy before the cap would bite. It does not create extra trades or change which setups are taken.
11-03T05:49 meanroaster: @Digital_Wim I asked abt gold reaper sry
11-03T05:49 Digital_Wim (bot): For Gold Reaper: 1) Max Allowed Total Drawdown is a lot-sizing dial only. It does not change which trades are taken or how often the EA trades. 2) When changing 50 → 100 makes a difference: the EA first calculates risk from the strategies' historical DD at 0.01 lots; your Max Allowed Total Drawdown then caps how big that risk can be. Trade Frequency controls how many strategies run.
11-03T13:21 finpotaatti: @Digital_Wim How do I update latest versio of reaper as example
11-03T13:21 Digital_Wim (bot): For Reaper you update the same way as any other EA, depending on where you bought it. MQL5: Market → My Purchases → Update. Via the Profalgo portal: download the newest file, replace the old EA file and re-attach it to the chart.
11-03T19:28 idsme: @Digital_Wim what are ideal profitable max spread levels. As Gold is never 0 spread. At what is GoldReapers strategy canceld out by [link]
11-03T19:28 Digital_Wim (bot): Gold Reaper doesn't have a documented "cut-off" spread. Low-spread ECN broker for XAUUSD recommended. No exact threshold in the material; check with Wim directly.
11-03T19:31 idsme: @Digital_Wim What broker is MyFxBook track record for gold reaper on and what is average gold spread at that broker and which account [link]
11-03T19:31 Digital_Wim (bot): Broker, account type and average XAUUSD spread are not stated in the docs; check the MQL5 signal page. [ALLEGATO: Trading Signals for MetaTrader 5: Gold Reaper New V2 2]
11-03T19:55 Seanexmartingale: @Digital_Wim I have $100k that I can allocate to UBS, what do you recommend. I have the recommended portfolio with the purchase already running on one $10k account (modificato) martedì 3 novembre 2026 alle ore 21:00
11-04T06:18 olegfusion: @Digital_Wim UBS what is use virtual SL standard and all except be
11-04T06:18 Digital_Wim (bot): "Use Virtual SL": OFF = no virtual SL; STANDARD = normal SL and break-even SL both virtual; ALL EXCEPT BE = all SL virtual except break-even, which is sent as real broker SL. Set a "Hard SL distance when using virtual SL" as safety net.
11-04T10:31 Bigfishh: @Digital_Wim What does it mean : error:"invalid ticket" when modifying stop loss [link] What should I do. I am using gold reaper
11-04T10:32 Digital_Wim (bot): "Invalid ticket" = MT5 rejects the change because the position is already closed, belongs to another symbol/EA, or a sync glitch. Check open trades, ensure only one instance of Gold Reaper per symbol, re-attach the EA, and share a screenshot of Experts/Journal if it persists.
11-04T14:13 Jan: @Digital_Wim I try to run Luna AI on Vantage with Pairs EURAUD+;GBPAUD+;AUDUSD+; on OneChart. Error "Make sure all pairs are visible in the marketwatch window and the suffix is correct in the parameters". Tried with or without the "+" in the symbol. Luna always looks for symbol without suffix, without success.
11-04T14:13 Digital_Wim (bot): For Luna OneChart: do NOT put the broker suffix in OneChartSetup_Pairs (use EURAUD;GBPAUD;AUDUSD;). Attach Luna to an EURUSD+ chart (with the Vantage suffix); Luna adds the suffix automatically.
11-04T16:20 Wim The Algo Trader [re]: don't run on EURUSD. run on EURUSD+
11-04T18:31 3372: @Digital_Wim if we edit a set file and it's being used with AutoLoad, will the AutoLoad re-read and refresh it every now and then or do we need to manually make sure it's reloaded
11-04T18:31 Digital_Wim (bot): UBS Autoloader re-reads .set files about once per week. For immediate change, reload the EA manually. [ALLEGATO]
11-05T10:34 Toystory: @Digital_Wim Hi, I have a question about Luna AI. Would you recommend enabling the "enable performance based lotsize" [link] I noticed that Wim's MQL5 signal seems to have this feature disabled...
11-05T10:34 Digital_Wim (bot): Official Luna set files have EnablePerformanceBasedRisk = 1. The bot does not know why Wim's public signal differs.
11-05T19:37 MaximusDemicusMaridius: @Digital_Wim How to make 10k in a [link] I need new turbo for my car [ALLEGATO]
11-05T19:37 Digital_Wim (bot): I can't help with a plan to "make 10k in a week". Trading carries substantial risk; no profit guarantee.
11-05T19:38 MaximusDemicusMaridius: understood
11-05T19:38 yomama_36 [re]: You need digital trump [ALLEGATO]
11-05T23:00 Successkenz: What's max historical Drawdown in dollars for wim's 43 ubs live sets
11-06T05:57 Wim The Algo Trader [re]: sell a kidney (not financial advise) [ALLEGATO]
11-06T06:07 clickrukii [re]: @Digital_Wim
11-06T06:07 Digital_Wim (bot): Tell me what you'd like help with and which EA you're using.
11-06T06:08 clickrukii [re]: What's max historical Drawdown in dollars for wim's 43 ubs live sets @Digital_Wim
11-06T06:08 Digital_Wim (bot): No stored figure; ask Wim directly in #ultimate-breakout-system. [ALLEGATO]
11-06T07:52 Adebayo Ojo: @Digital_Wim If i don't want the one chart autoloader overwrite any settings in the individual set file, what should i [link]
11-06T07:52 Digital_Wim (bot): Use a second Autoloader instance with no overrides and a different Sets folder and unique magics.
11-06T07:53 Adebayo Ojo: @Digital_Wim You are missing the question. I have curated my set with specific settings, user variables, i don't want it overwritten
11-06T07:53 Digital_Wim (bot): Turn OFF all override sections in the Autoloader; each .set then loads as-is.
11-06T07:56 Adebayo Ojo: @Digital_Wim I think if i set UseAutoLoader to false, won't the value in each set be use automatically instead
11-06T07:56 Digital_Wim (bot): No. UseAutoLoader false turns the Autoloader off entirely.
11-06T07:57 Adebayo Ojo: @Digital_Wim what does this set: overrideAutoLoadLotsSettings
11-06T07:57 Digital_Wim (bot): If ON, the main Autoloader ignores lot-size settings inside every .set; if OFF, each .set keeps its own.
11-06T08:00 Ashrafee: @Digital_Wim Does the all EAs of WIM, of does the UBS and Gold reaper supports, this. Symbol compatibility: Whether the EA recognizes XAUUSD+. Contract size... Spread and commission... Execution and stop levels... Broker server time...
11-06T08:00 Digital_Wim (bot): Symbol suffixes generally fine; Gold Reaper auto-detects broker symbol names; contract spec, costs and execution are broker-side. Gold Reaper has built-in NFP filter with AutoGMT.
11-06T08:31 Xencoo: @Wim The Algo Trader i wanted to move the EAs from a Contabo VPS, which has a terrible RDP performance to another hosting provider but here i am having issues with the licensing. Could you tell me what the problem is here [link] (modificato) venerdì 6 novembre 2026 alle ore 09:31
11-06T08:42 Xencoo: [ALLEGATO]
11-06T09:00 Xencoo: 2026.11.06 09:56:39.307 Luna_AI_PRO_MT5_WSC_1.60 (EURUSD,H1) Web request failed #2: [link] [link]
11-06T09:01 Montz: @Digital_Wim what risk setting would you use for Luna on a 100k [link]
11-06T09:01 Digital_Wim (bot): Bot cites Luna KB guideline LotsizeStep ≈ 500 (low), 200 (medium), 100 (high). Not a personal recommendation.
11-06T09:42 Adebayo Ojo: @Digital_Wim I'm not able to validate my licence, seems Wim's server is down
11-06T09:43 Digital_Wim (bot): Likely an issue on Wim's side; post details in #product-manuals or tag Wim.
11-06T09:58 Wim The Algo Trader [re]: it works with me, so the server isn't down. I contacted your in private [ALLEGATO]
11-06T10:00 Wim The Algo Trader [re]: did you check [link]
11-06T10:08 AleAle: Is MaxSpread in points for Bitcoin Scalp [link]
11-06T12:01 sujal_fx: Hi @Digital_Wim what setting does win use on his goldreaper Ea
11-06T12:01 Digital_Wim (bot): Bot lists "live signal" set values for Gold Reaper (not verified by Wim).
11-06T12:01 sujal_fx [re]: @Wim The Algo Trader
11-06T13:11 Wim The Algo Trader [re]: default settings, but trade frequency set to moderate [ALLEGATO]
11-06T14:07 Luigi: hi . Where to found the updated folder with all the [link]
11-06T14:07 vERTIX [re]: plug-and-play-eas
11-06T14:21 Luigi: thanks
11-06T19:13 vERTIX: @Digital_Wim I have message at mt5: error: "unknown error 4752" when setting entry order with Gold Trade Pro What is the problem and how to [link] [link]
11-06T19:13 Digital_Wim (bot): Usually a broker-side restriction; check symbol, trading session, SetSL_TP_After_Entry, Max Allowed Spread; post in #all-gold-eas for Wim.
11-06T19:23 vERTIX: @Digital_Wim But the orders are placed. but messages with these errors are at the tab Experts at mt5
11-06T19:23 Digital_Wim (bot): Check Journal lines around the 4752 messages.
11-06T19:28 vERTIX: @Digital_Wim
11-06T19:28 Digital_Wim (bot): The line ends with "[auto trading disabled by client]": enable AutoTrading and "Allow live trading" / "Allow DLL imports" in the EA properties.
11-06T20:15 Razvan M.: Hi everyone, Could someone tell me where I can find the instructions for updating the [link] Like many of you, I received a free EA when I purchased another one...
11-07T02:16 youknowho: Where are you using his EAs
11-07T02:16 : Mql5 or client portal [link]
11-07T06:55 Jan: @Digital_Wim Which are the best prop trading firms, and which EA would you [link]
11-07T06:55 Digital_Wim (bot): Wim doesn't really promote classic prop firms (per bot). Mentions Darwinex Zero.
11-07T07:33 Claudio: @Digital_Wim What are the 'plug and play EA's' I see on [link] What sort of strategies are [link]
11-07T07:33 Digital_Wim (bot): Simpler pre-configured robots; ready to run with presets.
11-07T07:39 Claudio [re]: I've bought UBS – can I use these sets with this EA, or do I need to buy some [link]
11-07T07:40 Digital_Wim (bot): No need to buy other EAs; plug-and-play sets are for standalone gold EAs, not UBS.
11-07T07:41 Claudio [re]: Are there any UBS sets that are more suitable than others for the prop firm [link]
11-07T07:41 Digital_Wim (bot): No special prop pack; run the normal sets at lower risk per strategy (~0.5% vs ~3%, per bot).
11-07T07:44 Claudio [re]: Where can I find (a video or guide) with detailed instructions on how to upload the 44 sets using One Chart [link]
11-07T07:44 Digital_Wim (bot): Refers to Wim's official getting-started videos. [ALLEGATO: Comments | Ultimate Breakout System]
11-07T07:56 Claudio [re]: If I want to use the 44 sets with the 'One Chart' setup to pass the Prop Firm Challenge, what parameters should I [link]
11-07T07:56 Digital_Wim (bot): Lower risk; set Max Daily Drawdown and Close-all at min equity in Prop Firm Settings.
11-07T08:14 Claudio [re]: How should I modify the 44 sets so as not to breach the prop firm's (FTMO) [link]
11-07T08:14 Digital_Wim (bot): Keep the 44 sets; reduce risk; set Prop Firm daily DD and min equity; add small randomisation.
11-07T08:17 Claudio [re]: 100k account max daily drawdown 5% max total drawdown 10%
11-07T08:17 Digital_Wim (bot): Bot suggests min-equity 90,000 and daily DD 5,000 and low risk per trade (0.25–0.5%). Not verified by Wim.
11-07T08:21 Claudio [re]: Is a maximum level of randomisation sufficient to avoid being accused of copy [link]
11-07T08:21 Digital_Wim (bot): No guarantee; prop firms judge case by case.
11-07T08:23 Claudio [re]: I can shift [link] wuth one chart [link]
11-07T08:23 Digital_Wim (bot): Yes, each set can have its own randomisation with OneChartSetup, unique magic per set.
11-07T08:25 Claudio [re]: with one chart setup I can make a single test for all [link]
11-07T08:25 Digital_Wim (bot): One combined backtest for all sets in the folder; use high-quality modelling.
11-07T08:26 Claudio [re]: What parameters are recommended for this mass test (time [link] duration of the [link]
11-07T08:26 Digital_Wim (bot): Gold/H1 example; 5–10 years for Daytrade Pro, 2–3 years for Luna; use "1 Minute OHLC" or real ticks.
11-07T08:32 Claudio [re]: I'm a bit confused: if I use the 44 sets with UBS, which setting do I need to change in each individual [link]
11-07T08:32 Digital_Wim (bot): MagicNumber unique per set, ForceSymbol with broker symbol, HistoricalMaxDD per 0.01 lot.
11-07T08:34 Claudio [re]: But I read somewhere that with the 44 sets, you just need to load them as they are and set the maximum drawdown in the 'One Chart Setup'
11-07T08:34 Digital_Wim (bot): Correct if the sets already contain those three values.
11-07T13:52 vERTIX: @Digital_Wim New message at MT5 at tab Experts opposite each ea Suffix detected: ! Is it [link]
11-07T13:53 Digital_Wim (bot): Informational; ForceSymbol must match the broker symbol including "!".
11-07T18:41 vERTIX: @Digital_Wim Which balance prefer to have on account for Gold Reaper & Gold Trade Pro on medium risk [link]
11-07T18:41 Digital_Wim (bot): Bot cites historical max DD of ~350 $ per 0.01 lot (GR) and ~600 $ per 0.01 lot (GTP). Not verified.
11-07T18:42 vERTIX: @Digital_Wim 30DD, one account
11-07T18:42 Digital_Wim (bot): Bot estimates ~3,200 $ balance for 30% DD with both EAs at 0.01. Not verified.
11-07T19:46 princeboto: @Digital_Wim @ $2,000 equity balance and Drawdown 10%
11-07T19:46 Digital_Wim (bot): With $200 DD budget, 0.01 lots of GR/GTP already exceeds it per bot's figures.
11-07T19:50 princeboto: @Digital_Wim @ Gold reaper $2,000 equity and 10% DD
11-07T19:50 Digital_Wim (bot): Bot says even 0.01 lots exceeds the $200 budget.
11-07T19:59 princeboto: @Digital_Wim @ what about Conservative setting on $2,000 equity and 15% DD
11-07T19:59 Digital_Wim (bot): Per bot, still above 15% limit.
11-07T20:04 princeboto: @Digital_Wim @ what equity amount can you recommend for Conservative setting with Fixlot 0.01 Gold reaper
11-07T20:04 Digital_Wim (bot): Bot gives balance levels for 10/15/20% DD based on 350 $ DD figure.
11-07T20:08 princeboto: @Digital_Wim @ what equity is good for Moderate setting with 20% DD
11-07T20:08 Digital_Wim (bot): Bot says no explicit figure for 20%.
11-07T20:29 princeboto: @Digital_Wim @ Conservative setting $1,000 with 20% DD
11-07T20:29 Digital_Wim (bot): No confirmed figure; treat as outside documented range.
11-08T00:27 Anan22: @Digital_Wim what is difference between the plug and play eas and the set files in ubs with the same logic of the eas so the set files of the [link]
11-08T00:27 Digital_Wim (bot): No explicit definition; UBS sets run inside UBS; plug-and-play EAs run standalone.
11-08T00:28 Anan22 [re]: Indicement set files from wim in ubs and indicement da
11-08T00:28 Digital_Wim (bot): No documented side-by-side comparison; ask Wim in #indicement-and-orb-master.
11-08T01:50 권대현: @Digital_Wim Can I get the latest version of Gold Reaper v4.6 that comes with my purchase of Gold Trade [link]
11-08T01:50 Digital_Wim (bot): Cannot confirm entitlement; check purchase email or contact support.
11-08T10:06 Wim The Algo Trader [re]: Ask me on MQL5 please [ALLEGATO]
11-08T20:48 Claudio: @Digital_Wim Among the 40+ UBS sets, there is also a set called ubs_onechart_live_MainEA_Settings.set. After loading the 40+ sets into the Sets folder, do I need to load this set into the EA settings...
11-08T20:48 Digital_Wim (bot): Usually yes: load the main OneChartSetup preset so Autoloader is enabled and points to the right folder.
11-08T20:59 Claudio [re]: I have several MT5 instances running on my VPS, all in different directories. How can I be sure that the folder 'Terminal > Common > Files' – where I need to create the 'Sets' folder – is the one for the MT5 terminal I want to [link]
11-08T20:59 Digital_Wim (bot): Use File → Open Data Folder from the specific terminal, go up one level, then Common → Files.
11-08T21:06 Claudio [re]: Unfortunately, when I open the 'Terminal' folder in IC Markets, I find the set files that I had previously uploaded to the MT5 platform of the broker Ultima.
11-08T21:06 Digital_Wim (bot): Expected: Common\Files\Sets is shared by all MT5 terminals of the Windows user.
11-08T21:09 Claudio [re]: ok but IC Markets have different names for forex and indices: IC Markets: EURUSD - Utima: EURUSD+. What I [link]
11-08T21:09 Digital_Wim (bot): Keep one set per broker with the exact symbol name.
11-08T21:13 Claudio [re]: But to fit both groups of files into a single folder, I need to rename the sets. Could this be a problem for [link]
11-08T21:13 Digital_Wim (bot): Renaming is fine; only the content (Symbol, magic) matters.
11-08T21:29 Claudio [re]: I've renamed the sets for IC Markets and uploaded in Sets, but now I'm getting an error on both terminals telling me that the symbol is not available
11-08T21:29 Digital_Wim (bot): Symbol inside the .set must match the broker's exact symbol.
11-08T21:35 Claudio [re]: IC identifies Ultima's names as incorrect, and Ultima identifies IC's names as incorrect
11-08T21:35 Digital_Wim (bot): Set BTCUSD on IC and BTCUSD+ on Ultima.
11-09T06:57 Wim The Algo Trader [re]: you are trying to run BTCUSD+ on ICMarkets, which has BTCUSD
11-09T07:57 Claudio [re]: I've solved it, thank you. To run two MT5 instances, in the same VPS, with different symbol names, I had to create two separate Sets folders (Sets_01 and Sets_02) and modify the Sets_folder input parameter in the EA. Everything is working perfectly now. [ALLEGATO]
11-10T08:53 princeboto: @Digital_Wim @ My Gold reaper Place Buy stop and Sell Stop showing Expert Expiration date and time
11-10T08:53 Digital_Wim (bot): Check Experts tab; contact support or ask Wim for an updated build.
11-10T20:15 Robert: @Digital_Wim How can I use my existing IC Trading accounts (currently used under [link] IB) with easyalgos [link] I don't want to use the EAs offered there...
11-10T20:15 Digital_Wim (bot): Register via the EasyAlgos Precision link, then ask EasyAlgos support to move the accounts.
11-10T20:18 Robert [re]: Ok, I'm already registered without using the referral...
11-10T20:18 Digital_Wim (bot): Ask EasyAlgos support about the 10-trade requirement.
11-10T21:37 eyalperel: @Digital_Wim in gold reaper ea, in the common tab, what does 'Allow modification of Signals Settings' [link]
11-10T21:37 Digital_Wim (bot): Standard MT5 setting; only relevant if subscribed to an MQL5 signal.
11-11T08:56 Bark Vader: @Digital_Wim what are the default settings for the reaper
11-11T08:56 Digital_Wim (bot): Gold Reaper default set: TradeFrequency 5, MaxAllowedDD 30, StartLots 0.01, MaxSpread 500, OnlyUp 1.
11-11T08:59 !R7 [re]: @Digital_Wim How much is the average return per month on the default settings [link]
11-11T08:59 Digital_Wim (bot): No fixed monthly figure; live results show ~16% max DD and ~200% growth at Max Allowed Total DD 30 (per bot).
11-11T09:58 olegfusion: @Digital_Wim gold bot one #8 strategy UBS set, I have every 5 minutes cancel and place the order again. Only this set! What parameter is managing cancellation and adding again every 5 [link]
11-11T09:58 Digital_Wim (bot): Pending orders refresh on each new entry-timeframe candle; change ST8 timeframe.
11-11T09:59 olegfusion: Strategy 8 is daily strategy @Digital_Wim
11-11T09:59 Digital_Wim (bot): Check daily check time, trading hours window and news filter.
11-11T10:56 Wim The Algo Trader [re]: remove all pending orders and restart the EA. Let me know if it continues doing that. I never was able to replicate this myself
11-11T11:59 Bark Vader: @Digital_Wim how does UBS compare to the gold [link]
11-11T11:59 Digital_Wim (bot): Gold Reaper: single gold EA, simpler. UBS: framework running many strategies, more complex.
11-11T12:04 Bark Vader: @Digital_Wim recommended and minimum amount of money to run the gold bundle
11-11T12:04 Digital_Wim (bot): Bot guideline: 4,000–5,000 USD or more for full Gold Bundle.
11-11T12:30 Bark Vader: @Digital_Wim can i run the gold bundle with 2k account
11-11T12:30 Digital_Wim (bot): Bot: aggressive; one or two gold EAs better at 2k.
11-11T12:53 olegfusion [re]: It helps. But later starts again, only with this set
11-11T12:54 : Unsure...
11-11T12:54 : Maybe glitch of .mt5 [ALLEGATO]
11-11T13:12 Bark Vader: @Digital_Wim can i run the gold bundle on the mql [link]
11-11T13:12 Digital_Wim (bot): Yes, MQL5 VPS is fine.
11-11T21:30 JussyJames: is there a telegram [link]
11-12T02:41 Kumar [re]: Telegram channel is only for UBS users only. Contact Wim privately if you have UBS.
11-13T00:11 3372: @Digital_Wim is there a setting in UBS set files to define minimum [link] And to tighten trailing stop after a certain minimum profit is [link]
11-13T00:11 Digital_Wim (bot): No single toggle; combine Breakeven start distance with standard or structure-based trailing SL.
11-13T02:17 chrisc0720: @Digital_Wim Everytime i launch my EA on my on my terminal, it itializes then fails printing the code -1. How can i fix this
11-13T02:17 Digital_Wim (bot): Check Allow algorithmic trading, WebRequest URLs, symbol/timeframe, .ex5 location.
11-13T02:21 chrisc0720 [re]: Thanks for that. Found the issue. I had the wrong symbol name in force symbol. Didnt match my broker symbol. All good now, thanks!
11-13T02:21 Digital_Wim (bot): Glad you found it.
11-13T11:42 sdeyter: @Digital_Wim : In UBS we can choose to close all trades if the open trades have a win of x%. Which setting does [link]
11-13T11:43 Digital_Wim (bot): Not described; ask Wim in #ultimate-breakout-system.
11-13T11:45 sdeyter [re]: It seems to be this settings. Are there any experiences using [link]
11-13T11:45 Digital_Wim (bot): No practical experience data; ask in #ultimate-breakout-system.
11-13T12:20 denisj: @Digital_Wim In Gold Reaper, what does each TradeFrequency value (1 to 9) mean? Which strategies (1-9) are enabled for each value, and is the activation tied to the account [link] (modificato) venerdì 13 novembre 2026 alle ore 13:23
11-13T12:35 denisj: @Digital_Wim In the UBS EA, is there a setting to enable strategies depending on the balance, like TradeFrequency in the standalone Gold [link] If not, what is the recommended way to replicate [link]
11-13T12:35 Digital_Wim (bot): No automatic balance switch in UBS; use different .set files manually.
11-13T12:41 denisj: @Digital_Wim in UBS, in the the Gold Reaper sets, what does TradeFrequency mean in the standalone Gold [link] Which strategies (1-9) are enabled at each value, and at what balance do the others get added when starting with 1000 [link]
11-13T12:42 Digital_Wim (bot): Bot lists tiers: Extreme conservative 1–3; Conservative 1–5; Moderate 1–7; Intense 1–8; Extreme 1–9; Auto uses budget = balance × Max Allowed Total DD ÷ 100 with thresholds $200/$330/$560/$810 (per bot).
11-13T13:05 sdeyter: @Digital_Wim : the value I put in here is the % not USD or something else, [link]
11-13T13:05 Digital_Wim (bot): Unit not confirmed; ask Wim in #ultimate-breakout-system.
