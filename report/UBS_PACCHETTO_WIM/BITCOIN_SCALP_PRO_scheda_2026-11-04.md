# Scheda EA "Bitcoin Scalp Pro V2.4" (pacchetto Wim) — 04/11/2026
Fonte: manuale v2.4 (maggio 2026) incollato da Claudio + 3 set file. `.ex5` non aperto e non nel repository; set originali fuori dal repo.

## Cosa dichiara
- Breakout su supporti/resistenze, **solo Bitcoin (BTCUSD/BITCOIN), H1**, ordini pendenti (max 5), SL e TP fissi + trailing + breakeven opzionale; rapporto rischio/rendimento «circa 1:2». «Nessuna griglia, nessuna martingala.»
- Sistema "adattivo": tutti i parametri (distanza ingresso, SL, TP, trailing, lotto) scalati sul prezzo corrente di BTC (valore base di riferimento 30.000; `Base_Value=0` = adattivo). Dichiara quindi stabilità tra $10.000 e $100.000.
- Filtri: spread e slippage (spread filter **spento** nei set, `MaxSpread=9999999`), chiusura del venerdì (`FridayStopHour=18`), orari per giorno (tutti 0–24 nei set), lotto per rischio % o manuale, `OnlyUp`.
- Cripto: opera 24/7, quindi il weekend e la chiusura del venerdì contano sul broker (BCM/FTMO: da verificare se offrono BTC e con che spread/orari).

## I 3 set (differenze: 2 valori)
| Set | `Risk` | `setSL_TP_After_Entry` |
|---|---|---|
| 1% risk per trade (low risk) | 10 | 0 |
| 2% risk per trade (medium risk) | 20 | 0 |
| BitcoinScalpPro_PropFirm | 5 | 1 (SL/TP impostati dopo l'ingresso) |
Il nome suggerisce che `Risk` = decimi di %: 10 → 1%, 20 → 2%, 5 → 0,5%. **È un'interpretazione dai nomi dei file, da verificare nel tester** (non è scritto nel manuale). Il set PropFirm è pensato per conti di challenge: utile da confrontare con il nostro Guardian.

## Letture di C0 (non misurate)
1. È l'unico finora **non su coppie AUD e non su oro**: classe di rischio diversa (cripto). Correlazione con oro probabilmente bassa, con indici USA (Nasdaq) possibilmente più alta nei momenti di stress: va misurata.
2. L'adattamento al prezzo è una promessa verificabile: serve un test su regimi di prezzo diversi (BTC a pochi migliaia, a 30k, a 100k+), e su entrambi i lati (long/short).
3. Breakout H1 con pendenti: la qualità dei fill, lo spread e il gap del weekend cambiano molto da broker a broker (il manuale stesso dice «spread basso su BTC, molto importante»). Con `SpreadFilter` spento nei set il test deve usare lo spread reale.
4. «Rapporto 1:2» ma con trailing e breakeven: il profilo vero (win rate, payoff) si vede solo dal test.
5. Nessun accenno nel manuale a un tetto di perdita giornaliero o di equity: per FTMO/100k si dovrebbe affiancare il Guardian; il set PropFirm non dice quanto vale come protezione.
6. Storia disponibile: BTC su broker ha tick/barre solo dal ~2017–2019 (da verificare sul PC di backtest): meno anni degli AUD (dal 2007).

## Da misurare (criteri da congelare prima di guardare i risultati)
Profit factor, drawdown massimo in % e in giorni, peggior giorno e peggiore sequenza, win rate/payoff, numero di trade/anno, risultati per anno e per regime di prezzo, sensibilità a spread maggiorato e a slippage, comportamento nel weekend/venerdì; correlazione dei P&L giornalieri con Reaper/Goldbot/Phantom/GTP e con Nasdaq/Apex/Stability; peggior giorno combinato col Guardian. Test: BTC H1 con tick reali, tutti e 3 i set, `Base_Value=0`.
Stato: **nessun test eseguito**.
