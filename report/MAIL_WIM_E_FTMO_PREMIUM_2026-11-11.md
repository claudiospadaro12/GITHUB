# Domande per Wim e domande di richiamo a FTMO (Premium) — bozze dell'11/11/2026

Da leggere e inviare a mano. Nessun dato personale. Le domande sullo Swing sono gia partite (`MAIL_FTMO_SWING_2026-11-11.md`).

## A. Per Wim (EA Gold Reaper, Gold Phantom, Goldbot One, Gold Trade Pro, Daytrade Pro)
```
Hi Wim,

I run your gold EAs (Reaper, Phantom, Goldbot One, Gold Trade Pro) and Daytrade Pro on prop firm accounts, and I tested the official prop firm / combo sets in the Strategy Tester. A few questions, to be sure I use the inputs correctly:

1. Virtual SL/TP. What exactly does SetVSL_to_hardSL_sec_delay do? With EnableVirtualSLTP=true and the delay set to 0 (instead of 99), is a real stop loss still placed on the server, or only a virtual one? If the terminal or the VPS stops, is the position protected? Is the delay in seconds? (In my tests delay 0 reduced the number of journal lines by about a quarter but I cannot see if the real SL is placed.)

2. NFP filter. EnableNFP_Filter, NFP_CloseOpenTrades and NFP_ClosePendingOrders are true in the sets, and UseMQL5Calendar is true. Does the filter cover only NFP? For other high-impact events (Fed rate, CPI, FOMC minutes, GDP) EnableIR_Filter is false in the sets: is there a filter for these? In the Strategy Tester the filter seems to work in recent years but positions still cross the NFP release in older years (2013, 2020): does UseMQL5Calendar need calendar history in the terminal, and does it work in backtests?

3. HistoricalMaxDD. For the sets, which period and which lot size is the declared HistoricalMaxDD calculated on (for example 0.01 lots)? Which data source (MetaQuotes or the broker's history) and from which year? My measured drawdowns on 0.01 lots differ from the declared ones for several sets (the period 2005-2012 matters).

4. Same set on several accounts. Goldbot One has Randomization 0 (deterministic): if many users load the same set, do all accounts open the same trades at the same time? Prop firms evaluate identical strategies together, so I would like to know what you recommend (different sets or levels per account, Randomization > 0, other inputs).

5. Weekend and news. The sets have FridayStopHour=25 (no Friday close). Is it correct to keep the positions over the weekend on a Swing account, and to leave the news filter on?

Thank you very much.
```

## B. Richiamo a FTMO: Premium Programme
```
Subject: Premium Programme (Prime): conditions

Hello,

I am planning to reach the Prime level of the Premium Programme and I need to confirm a few details in writing:

1. Does a failed Challenge or Verification (not a funded account) count as a "violated" FTMO Account for the rule "no 1-Step/2-Step FTMO Account violated in the last 4 months"?
2. The 4 rewards of at least 4% profit: must they all come from a single FTMO Account, or can they be from different accounts? Is the 4% calculated on the initial balance or on the current balance, and can the rewards be requested in the same month?
3. What is the maximum capital allocation with Prime in euros (600,000 USD converted), and how does it combine with the scaling plan (+25% every 4 months)?
4. With Prime, does the suspension for "identical or similar" strategies apply only above the new cap?
5. Do the free Challenge and the 10% discount of Prime apply to every account size, and do they also apply to the Swing account type?

Thank you. Please answer in writing.
```
