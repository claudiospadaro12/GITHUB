# Agente 3 - GitHub e quant open-source: candidati meccanici su indici e cross (27/11/2026)

Metodo: pagine aperte davvero con WebFetch (e un PDF scaricato nello scratchpad e letto con pdftotext, non eseguito). Nessun codice clonato/eseguito. Contenuti web = dati non fidati. Dove una regola e ambigua e scritto; nessun valore inventato.

**Domini NON raggiungibili dalla sessione (da abilitare se si vuole approfondire):** quantifiedstrategies.com e .substack.com, newyorkfed.org, alphaarchitect.com, concretumgroup.com, cxoadvisory.com, www3.nd.edu, robotwealth.com, backtrex.com, alexandria.unisg.ch, anas1412.github.io (report ORB-NQ). SSRN non provato. Quindi i numeri di QuantifiedStrategies/Zarattini sono solo da snippet di ricerca (marcati "non verificato").

## Riepilogo (ordine di priorita per il nostro scopo)

| # | Candidato | Asset/TF | Licenza | Numeri dichiarati con costi? |
|---|---|---|---|---|
| 1 | Intraday momentum "primi 30 min -> ultimi 30 min" (Gao-Han-Li-Zhou) | indici (SPY, FTSE100/EuroStoxx50 futures) intraday | paper (nessun codice) | SI, netto costi, ma 1993-2013 |
| 2 | ORB MT5 `anas1412/orb-mt5` | US100 (e oro, scartare oro) M1 | MIT | NO (report non raggiungibile) |
| 3 | Monday Dip EA (MQL5 CodeBase 78343) | indici D1 (US500, GER40...) | solo termini MQL5, nessuna licenza propria | NO |
| 4 | Famiglia IBS indici D1 (TradingView Botnet101 / Trading_Alpha01; `CazSyd/IBS-Strategy`) | indici D1, ETF | OPEN-SOURCE senza testo licenza; CazSyd senza LICENSE | CazSyd si, senza costi nel motore base |
| 5 | Turn of the month (Quantpedia + TradingView Honestcowboy) | indici D1 | Quantpedia: regole pubbliche; script: licenza non esposta | paper 1926-2005, costi NON riportati |
| 6 | RSI(2) Connors su US500 (MQL5 art. 17636) | US500 M30 | (c) MetaQuotes, copia vietata | NO (risultati solo immagini) |
| 7 | Gap fade RTH (`Dax-giant/RTH_Gap_Backtesting`) | indice futures 1 min | MIT | NO |
| 8 | Mean reversion EURGBP H1 z-score+ADX (MQL5 art. 25757) | EURGBP H1 | (c) MetaQuotes | SI, ma EDGE NON CONFERMATO (OOS PF 0,96) |
| 9 | Overnight drift (Quantpedia/NY Fed/GitHub chungderson) | indici, close->open | vari | costi esclusi / negativi |

Sotto: schede.

---

## 1. Intraday momentum: primi 30 minuti predicono gli ultimi 30 (Gao, Han, Li, Zhou)
- **URL:** copia PDF https://c.mql5.com/forextsd/forum/173/intraday_momentum_-_the_first_half-hour_return_predicts_the_last_half-hour_return.pdf (versione dic 2015, letta). Licenza: paper accademico, nessun codice (le regole si possono implementare liberamente).
- **Asset/TF:** SPY (1993-2013), 10 altri ETF, futures FTSE 100 e EuroStoxx 50 (2003-2015, dichiarato "intraday momentum anche li"); NON su cambi e materie prime. Barre 30 minuti.
- **Sessione:** ultima mezz'ora della sessione cash (nel paper SPY 15:30-16:00 ET). Per DAX/EuroStoxx l'equivalente sarebbe l'ultima mezz'ora cash europea: ambiguita da definire (nei futures europei il paper usa orari propri, vedi sez. 5.6).
- **Regole meccaniche (paper):** r1 = rendimento della prima mezz'ora (dalla chiusura precedente), r12 = rendimento della dodicesima mezz'ora (14:30-15:00 ET). Variante A: long gli ultimi 30 min se r1 > 0, short se r1 < 0, uscita alla chiusura. Variante B: stessa cosa col segno di r12. Variante C: long/short solo se r1 e r12 concordi, altrimenti flat. Nessuno stop esplicito nel paper (aggiungere uno stop fisico per la prop).
- **Parametri:** nessuno da ottimizzare (solo segno). Piu forte nei giorni a volatilita e volumi alti.
- **Risultati dichiarati:** variante A: 6,67% annuo, dev. std 6,19%, Sharpe 1,08 (SPY 1993-2013, lordo); dopo costi (bid/ask reali, solo dopo il 2001) 4,46% annuo (-2,47 punti), variante C netta 4,30%. Buy&hold 0,29 Sharpe.
- **Da verificare nel nostro tester:** spread dei CFD indice alle 15:30 IT e 17:00-17:30 IT (il rendimento per trade e piccolo: il costo e decisivo); se l'effetto esiste ancora dopo il 2013 (il paper finisce li); definizione corretta di "prima mezz'ora" sul nostro feed (GMT+1 fisso, vedi CLAUDE.md); numero trade circa 1/giorno; sensibilita a +-1 ora di fuso.
- **Ambiguo:** definizione della "chiusura" per CFD (quasi 24h); orari DAX non specificati nel testo che ho letto.
- **Non verificato:** versione "Noise Area" di Zarattini-Aziz-Barbon (SFI 24-97, SPY, 14 giorni, ingressi ogni 30 min, trailing su bande e VWAP): da snippet di ricerca, replica CXO "19,6% netto, Sharpe 1,33, DD -25%, 2007-2024" NON letta alla fonte (cxoadvisory.com non raggiungibile). Regole complete da leggere sul PDF SFI se si abilita il dominio.

## 2. `anas1412/orb-mt5` (Opening Range Breakout configurabile)
- **URL:** https://github.com/anas1412/orb-mt5 - **Licenza: MIT** (dichiarata nel README). 6 stelle, aggiornato 09/2026.
- **Asset/TF:** configurazioni su XAUUSD (scartare) e **US100/NQ**: "ORB + NQ" e "NQ range fade" nella sessione di New York. Grafico M1, ticks reali richiesti, MT5 build 6000+.
- **Regole (README, parziali):** range di apertura 15 minuti; ingresso solo entro 15 minuti dall'apertura del range; `InpMinClosePos` 0,50 ("regola meta' del range", test non spiegato); stop al 50% del range (punto medio); TP 2R; a +0,5R lo stop passa a -0,5R; uscita a tempo dopo 90 minuti; venerdi disattivato; filtro "ieri" opzionale (spento, corpo >= 30, "misurato non pubblicato"); rischio 2% (modo percentuale); `Winter offset` 2.
- **Risultati dichiarati:** nessuno nel README; rimanda a `orbnq.html`, `nqfade.html` su anas1412.github.io (NON raggiungibile) e a `fundingpips-1step-flex.md`.
- **Da verificare:** il range NQ usa orario NY: offset del server e DST USA (`InpFollowsUSDST` "non verificato", ~1 settimana ogni ottobre); sul nostro BCM l'apertura USA e a 14:30 server in estate e 15:30 in inverno. **Attenzione al nostro registro:** ORB gia chiuso senza vantaggio (CLAUDE.md, 20/11 e 25/11): serve solo come implementazione di riferimento, non come promessa. Lotti con rischio 2% troppo alti per prop.

## 3. Monday Dip EA (MQL5 CodeBase)
- **URL:** https://www.mql5.com/en/code/78343 - autore "pckr" (chen guang), pubblicato 13/10/2026, allegato `Monday_Dip_Weekly_Exit_EA.mq5`. **Licenza:** nessuna propria; download gratuito soggetto ai termini generali di MQL5.
- **Asset/TF:** qualsiasi indice (US500, UK100, GER40...), dati D1 (consigliato grafico D1). Solo long, max 1 trade a settimana.
- **Regole:** lunedi a chiusura: close(lunedi) < close(sessione precedente). Filtro IBS opzionale: IBS = (C-L)/(H-L) del lunedi <= `InpIBSMax` 0,25. Filtro MA opzionale: close < SMA(`InpMAPeriod`=180) giornaliera. Uscita: chiusura giornaliera di mercoledi (eseguita al primo tick successivo). Stop percentuale `InpStopLossPercent` 10% (allargato se richiesto dallo stops level), nessun TP; magic 20260922.
- **Risultati dichiarati:** nessuno.
- **Da verificare:** il filtro "close sotto SMA180" e un ribasso, non un filtro di trend: strano ma e come descritto; numero trade molto basso (<= 52/anno, con IBS meno); swap su long indici BCM (10-14% annuo, vedi CLAUDE.md) su 2 notti; storico indici BCM solo 2024-26 (usare `_EXT` Nasdaq/S&P con le avvertenze di orario D1 irrilevanti). Stop del 10% e inutile come protezione prop: da ridurre.

## 4. Famiglia IBS su indici giornalieri
Tutte le regole sono lette dalle pagine; nessuna riporta risultati con costi.
- **Botnet101 "Internal Bar Strength (IBS) Strategy"** https://www.tradingview.com/script/I3PUR2GA-Internal-Bar-Strength-IBS-Strategy (gen 2025, OPEN-SOURCE, testo licenza non esposto). D1, long: IBS < 0,2 entra, IBS >= 0,8 esce; finestra Start/End; nessuno stop. Formula IBS non resa nella pagina (la comune e (C-L)/(H-L)).
- **Trading_Alpha01 "S4 IBS Mean Rev 3candleExit"** https://www.tradingview.com/script/2KH3h0AC-S4-IBS-Mean-Rev-3candleExit (giu 2025). Long: IBS della barra precedente <= 0,25; esce se chiude sopra il prezzo d'ingresso, oppure dopo 3 barre senza profitto; nessuno stop di prezzo.
- **Botnet101 "Average High-Low Range + IBS Reversal"** https://www.tradingview.com/script/BTwOiV1h-Average-High-Low-Range-IBS-Reversal-Strategy : close sotto `upper - 2,5*hl_avg` per 2 barre consecutive (hl_avg = SMA(high-low, 20); `upper` NON definito nella pagina) + IBS < 0,2; esce se close > high[1]. Ambiguo.
- **Variante short** (Botnet101, feb 2025, D1): short se IBS >= 0,9 e close > high[1]; esce con IBS <= 0,3.
- **`CazSyd/IBS-Strategy`** https://github.com/CazSyd/IBS-Strategy (nessun file LICENSE visibile -> NON copiare il codice). D1 long: se IBS di ieri < 0,13 compra all'apertura, se IBS di ieri > 0,5 vende all'apertura. Segnali sulla barra precedente (senza look-ahead). Risultati README: TQQQ 2010-26 CAGR 20,3%, Sharpe 0,78, DD -39%, 392 trade, win 65%, in mercato 16%; SPXL 1993-26 Sharpe 0,83; out-of-sample walk-forward TQQQ 2018-26 Sharpe 0,93; positivo e significativo su 10 ETF su 13 (oro e bond nulli). Costi: motore base senza commissioni; stima 1-3 punti CAGR di attrito a spread realistici; breakeven ~50 bp/lato. Filtro SMA200 provato e scartato. L'autore avverte che l'edge puo derivare dal gap notturno (close->open): per CFD con ingresso all'open vale la regola "compra open successivo".
- **Da verificare:** i risultati sono su ETF a leva 3x (non trasferibili ai CFD); spread/swap dei CFD; con stop fisico l'effetto cambia (nessuna delle regole ha stop). Numero trade stimato 10-25/anno per indice.

## 5. Turn of the Month (stagionalita di calendario)
- **Quantpedia** https://quantpedia.com/strategies/turn-of-the-month-in-equity-indexes : long dall'ultimo giorno di borsa del mese (o chiusura del giorno prima) fino alla chiusura del 3o giorno di borsa del mese dopo (alcuni usano 4 giorni). Paper McConnell-Xu: 1926-2005 (e 1987-2005 fuori campione), 0,15% medio/giorno nei giorni -1..+3, rendimento 7,2% annuo, vol 6,9%, Sharpe 1,04, DD -20,79%; presente in 31 paesi su 35; **costi: "Non riportati"**. Rischio non maggiore nei 4 giorni.
- **TradingView Honestcowboy** https://in.tradingview.com/script/NXejRbFv-Turn-of-the-Month-Strategy-Honestcowboy : default compra 2 giorni prima della fine del mese, vende al 3o giorno del mese dopo; se l'ingresso cade di venerdi/sabato/domenica compra giovedi alla chiusura. In mercato ~25% del tempo. Risultati e commissioni NON dichiarati; licenza non esposta. Nessuno stop.
- **Verificare:** Maberly-Waggoner (2000) trovano l'effetto sparito dopo il 1990 su S&P spot e futures (secondo i risultati di ricerca, non letto). Trade ~12/anno per indice: pochi, utile come scorrelazione. Swap su 4-5 notti long. Aggiungere stop fisico (non previsto).

## 6. RSI(2) Connors su US500 (articolo MQL5)
- **URL:** https://www.mql5.com/en/articles/17636 - "All rights reserved by MetaQuotes", copia vietata; codice allegato `RSI2.zip` senza licenza aperta.
- **Asset/TF:** US500 CFD M30, test 01/01/2024-01/03/2025.
- **V1 Classic:** long se RSI(2) < 5 e close > SMA200; short se RSI(2) > 95 e close < SMA200; esce se close > SMA5 (o < SMA200); stop 0,15% dal prezzo. **V2 Pullback:** ultime 3 letture RSI2 < 10 (long) / > 90 (short) con filtro SMA200; esce sopra il massimo della barra precedente; stop 0,15%. **V3:** RSI2 < 5 e close > SMA50; esce con RSI2 > 70; stop 1%.
- **Risultati:** solo immagini; il testo dice V1 ~1-2 trade/giorno, V3 PF "piu alto" ma DD flottante maggiore. Nessun numero, nessun costo leggibile.
- **Verificare:** stop 0,15% su M30 e vicino allo spread dei CFD: sensibilita fortissima allo spread; molti trade (rischio limite richieste prop). Test indipendente (snippet di ricerca, backtrex.com non raggiungibile, NON verificato): SPX500 ott 2016-ott 2026, RSI(2)<5 e SMA200, 73 trade, win 71,2%, vincita media 1,22%, perdita media 2,10%, CAGR 1,7% vs 13,5% buy&hold, costi inclusi. Cioe: la versione daily e poco redditizia sul periodo recente.
- Connors originale (D1): RSI(2) < 10 sopra SMA200, esce con RSI(2) > 70 o dopo 5 barre (repo MIT `sofus-nl/swing-trading-strategies`, ma su ~2.000 azioni, PF ~1,7 su holdout 2025-04/2026 senza trade count). Esclusi i repository con scale-in/medie (`AlbertoJSE/mt5-tps-sample-ea`, MIT, ma 4 tranche sotto l'ultimo ingresso = averaging, nessuno stop: SCARTATO per le nostre regole).

## 7. Gap fade sessione RTH (`Dax-giant/RTH_Gap_Backtesting`)
- **URL:** https://github.com/Dax-giant/RTH_Gap_Backtesting - **MIT**. Python/backtesting.py, barre 1 minuto.
- **Regole:** gap-up se l'apertura (09:30 NY) supera il massimo RTH precedente di piu di 5,0 punti prezzo -> short; gap-down sotto il minimo -> long. TP = massimo (short) o minimo (long) RTH precedente; stop = distanza pari alla dimensione del gap dall'ingresso; uscita a tempo 15:59; max 1 trade/giorno.
- **Risultati:** nessuno nel README (solo notebook non letto); strumento e periodo non dichiarati; costi modificabili nel notebook. Il "5,0" e in unita di prezzo: da riscalare per DAX/Nasdaq.
- **Sul DAX (fonte secondaria, GodmodeTrader/stock3, non verificata):** short all'apertura dopo gap-up con chiusura a fine giornata: hit rate 58%, ma l'autore stesso lo considera fallito. Verificare con i nostri CFD: i CFD indice hanno gap veri solo alle riaperture del lunedi/dopo pause.

## 8. EURGBP H1 mean reversion z-score + ADX (negativo istruttivo)
- **URL:** https://www.mql5.com/en/articles/25757 (testo ~109k caratteri, letto per i primi 100k). (c) MetaQuotes, copia vietata.
- **Regole (spec Stage 5):** z = (Close - SMA20)/DevStd20; long se z[1] <= -2,0 e ADX(14)[1] < 20; short se z[1] >= +2,0 e ADX < 20; target SMA20 al momento dell'ingresso (versione rivista: banda media, distanza minima 0,5 ATR); stop 2,0 x ATR(14); uscita a tempo dopo 24 barre; rischio 0,5%, una posizione per simbolo.
- **Risultati:** 2025-01..2026-10: 170 trade, +88,79 USD, PF 1,097, DD 7,1%. OOS 2023-24: 194 trade, -43,96, PF 0,962. Totale 367 trade PF 1,025. Spread ~2 punti, modello "open prices", **nessuna commissione/slippage/swap**. Conclusione dell'autore: "L'edge non e confermato", peso zero. AUDNZD: non stazionario su H4 nel test dell'articolo, quindi non operato.
- **Utile come:** regole esatte per un nostro test su AUDNZD/EURGBP/EURCHF; atteso PF ~1,0 (vedi anche chiusure nostre: coppie e trend forex gia chiusi). AUDNZD: solo post di vendita (EA a griglia, SCARTATO) con risultati non verificabili; script TradingView su AUDNZD e invite-only (non utilizzabile).

## 9. Overnight drift (close -> open) sugli indici
- **Quantpedia "Market Sentiment and an Overnight Anomaly"** https://quantpedia.com/strategies/market-sentiment-and-an-overnight-anomaly : compra SPY alla chiusura, vende all'apertura se (SPY > MM20) e (VIX < MM20) e (indicatore Brain Market Sentiment > MM20). Backtest 2018-2021: 15,58% annuo, Sharpe 2,12, DD -10,97%; senza segnale 13,62% / Sharpe 0,84. **Costi esclusi**, gli autori dicono che sarebbero "molto alti" per la frequenza. Il filtro sul rendimento notturno precedente peggiora.
- **NY Fed Staff Report 917 "The Overnight Drift"** (newyorkfed.org non raggiungibile: contenuto NON letto; solo da snippet: effetto concentrato nelle ore notturne dei futures S&P).
- **`chungderson/overnight-drift-backtest`** https://github.com/chungderson/overnight-drift-backtest (licenza non mostrata): TQQQ overnight 2010-02..2025-06 CAGR 19,96%, Sharpe 0,89, DD -68% vs QQQ buy&hold 12,61%/0,93; l'autore dice "it sucks"; costi non considerati.
- **DAX (snippet GodmodeTrader, non verificato):** guadagno medio del close->open ~0,04% a giorno su Xetra, prima dei costi.
- **Verificare:** swap giornaliero sui CFD (BCM long indici 10-14% annuo: mangia l'intero edge a ~0,04%/notte); per i CFD la "notte" non esiste (24h) quindi l'orario di ingresso/uscita va fissato a mano. **Probabilmente non praticabile con i nostri costi.**

---

## Cosa NON ho trovato / limiti
- Nessuna implementazione .mq5 con licenza chiara e regole complete su DAX/Dow di tipo stagionalita oraria, NR7, opening range con filtro o IBS (ricerche GitHub per RSI2/IBS/overnight/turn of the month in MQL5: zero risultati). Le uniche .mq5 con licenza MIT utili sono `orb-mt5` (ORB, gia chiuso nel nostro registro) e `mt5-tps-sample-ea` (averaging, scartato).
- NR7: solo indicatori/strategie TradingView daily senza risultati (ChartArt NR7+Inside Day long: entra se NR7 e inside day e close > open e pendenza SMA positiva; esce alla prima chiusura > apertura; SMA di default non indicata; Lazybear/LuxAlgo solo indicatori). Nessun numero.
- Cross forex (AUDNZD, EURGBP, AUDCAD, EURCHF, GBPCAD, NZDCAD): nessuna strategia pubblica con regole complete + OOS positivo; l'unica (sez. 8) fallisce fuori campione.
- Numeri QuantifiedStrategies (RSI(2) <15, 184 trade, PF 2,8, win 78%; "RSI drop" 244 trade PF 36 da snippet, palesemente sospetti) non verificati alla fonte (dominio bloccato); i PF 36 non sono credibili.
- Nessun repository con numeri fuori campione e costi, tranne Gao et al. (paper) e CazSyd (ETF, costi stimati).
- Licenze: MIT confermate (README) per `orb-mt5`, `RTH_Gap_Backtesting`, `mt5-tps-sample-ea`, `sofus-nl/swing-trading-strategies`; "OPEN-SOURCE SCRIPT" di TradingView senza testo di licenza (rischio per la copia del codice: riscrivere le regole); MQL5 articoli (c) MetaQuotes: non copiare il codice.
