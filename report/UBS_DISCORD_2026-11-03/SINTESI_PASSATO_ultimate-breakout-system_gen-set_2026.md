# Sintesi del passato di #ultimate-breakout-system (20/01 - 30/09/2026) per i test su prop da 80k

Fonte: file `DISCORD_PASSATO_ultimate-breakout-system_2026-01_2026-09.md` (5.541 messaggi letti da un'estensione di Chrome il 05/11/2026, sola lettura, nessun allegato scaricato). Questa sintesi e' stata fatta da quattro lettori che hanno diviso il file per mesi; i punti marcati **[V]** li ho ricontrollati io sul file originale, gli altri sono dal riassunto dei lettori e vanno ricontrollati prima di usarli come regola.

## Limiti (da leggere prima)
- Le 480 immagini NON sono lette: molti risultati sono solo screenshot.
- Risultati e problemi sono stati selezionati per parole chiave: possono mancare messaggi utili.
- I numeri degli utenti sono dichiarazioni, non verificate. Chi posta e' chi ha risultati buoni (selezione).
- `Digital_Wim` e' un BOT con la conoscenza di Wim, non Wim: le sue risposte non valgono come parole di Wim. Il ruolo di Marcus Wyatt come staff non e' verificato.
- Nel periodo Wim NON dice nulla su: regole prop (FTMO ecc.), fuso/orario del server, sessioni. Apex, Stability Pro e Luna non compaiono praticamente mai. Quindi per quelli non c'e' niente da imparare da questo canale.
- La regola GMT+1 fisso del CLAUDE.md vale per i NOSTRI test sul server BCM, non per i set di Wim.

## 1. Rischio e drawdown (dichiarato da Wim) - il punto piu' importante per l'80k
- UBS ha solo "max risk per strategy" (non un limite di DD totale). Il numero di strategie non cambia il lotto di ciascuna.
- Il lotto e' calcolato dal "max drawdown a 0.01 lotti in $" scritto nel set. **[V]** (04/09): "It's the responsibility of the client to run tests with the set files provided... I can't adjust it to the broker." Il valore va rifatto con un backtest sul proprio broker; senza, il rischio reale e' sbagliato. ORB e Indicement NON ne hanno bisogno: "they have a hardcoded setup" **[V]**.
- Valore del pip/contract size diversi tra broker (indici, Darwinex x10): correggere il valore (09/05, 19/05, 16/06, 29/07).
- Procedura di Wim per dimensionare **[V]** (31/07): backtest con 1% di rischio per strategia su balance fisso 100K; se il DD in $ e' 5.000, l'1% per strategia vale il 5% di rischio totale; poi basare il rischio su questo. Per 80k: ripeterla su balance fisso 80k (su 100K con rischio alto si arriva a ~99 lotti e il test non e' affidabile, utente timsiejx).
- Regola pratica **[V]** (18/06): "combined max DD for the 30-set UBS portfolio is about 4-5X the max risk per strategy". Livelli indicativi (08/06): 2 = basso, 4 = medio, 8 = alto. Il suo portafoglio live a 30 set usa 3% per strategia: "15-20% max DD according to my tests"; per stare sicuri suggerisce 0.5-1.
- Test 45 set a 2% per strategia, balance fisso 100K, 2025-26: DD massimo ~6K, +180% (07/05). Backtest dei 44 set live: ~600$ di DD su 4.500$ (30/07).
- Wim NON consiglia il rischio per trade: "keep risk per strategy" (21/09). Non mescolare due metodi di lotto (04/06).
- Funzioni prop in UBS v7 (citate dal manuale da Marcus) **[V]**: "Close all trades / stop trading at min equity" e "at max equity", in valori assoluti. Un trailing/chiusura di gruppo non l'ha implementato: "to implement a group close is not so difficult. I'll put it on the list" **[V]** (26/09).
- Dopo un prelievo: rilanciare l'EA con "Reset Highest Balance" = true (29/09).
- Il suo live signal (3% per strategia) a metà agosto: "not going so well", ridotto a 2 set.

## 2. Come sceglie i set (Wim)
- **[V]** "We are not looking for 'good results' when creating portfolios. We are trying to balance things" e "I mostly look at recovery factor. at least value 3 for me" (30/03).
- Periodi buoni/cattivi diversi per bassa correlazione; mercati diversi; trenta breakout sull'oro sono correlati (17/05); 5-7 EA al massimo per conto (04/02).
- "Backtests will be backtests... happy with half of that" (21/06).
- Dati storici: 1M OHLC ok per oro e forex; per Bitcoin e indici real ticks per confronto; per scalping SEMPRE real ticks (09/05). **Per noi: il test Bitcoin e' stato fatto in 1M OHLC (Modello 1): va dichiarato come limite.**
- Nuovo "UBS Optimizer" in sviluppo (27/09): ancora non rilasciato.

## 3. Versioni, bug e comportamento (Wim)
- V5.0 a maggio (set vecchi non piu' validi); V6.0 con limite 50 set per grafico; V6.2 (19/06) toglie il limite; V6.3 (luglio) cambia SOLO i filtri news; 6.4 (agosto); 7.0 (14/08) permette di mescolare Support/Resistance, Range e Retest; 7.2 corregge la visualizzazione lotti.
- Pannello info mostra lotti sbagliati all'avvio (99 / 0.01): solo grafica.
- Filtro NFP spento di default; per i set breakout S/R conviene attivarlo (50 min prima, 30 dopo) per lo slippage sui pendenti (02/07). In backtest le date NFP sono scritte nel codice, dal vivo usa il calendario MQL5: possibile causa di differenza test/live.
- Dopo filtro news o all'avvio i pendenti non tornano subito; "market orders won't make breakouts better" (02/09). I volatility breakout (Bitcoin, indici) usano ordini a mercato.
- Per i set BTCUSD: Virtual Expiration (18/09). UBS non legge set di altri EA (26/06).
- Bug AutoLoader con filtri news diversi: corretto in V6.3. Errori comuni: ForceSymbol da cambiare in ogni set, simboli con suffisso, storico insufficiente, "cannot load indicator ATR".
- Break and Retest e Range Breakout: versioni di prova, Wim stesso dice non ottimizzate / solo backtest.

## 4. Broker, server, VPS
- Gli scalp (A/B/C) sono molto sensibili al broker e al pricefeed: bene su Vantage, male su ICMarkets (Wim 13/07, 29/07); "Blackbull is notoriously bad for scalping" (staff, 23/09).
- Slippage sui pendenti = la maggioranza dei problemi di agosto-settembre; il backtest non lo riproduce. Backtest +50% contro live -18% nello stesso periodo (utente, 21/07).
- Non usare il VPS di MQL5 (non si caricano i set). Su VPS: 5 grafici da 10 strategie meglio di 1 da 50.
- Wim gira su ICMarkets Precision e ha 35+ conti su 5-6 broker.

## 5. Risultati dichiarati da utenti (NON verificati)
- Sander (22/09): 336 set community, 69 in Quant Analyzer, ~82k in 20 mesi con DD 1,3% - ma Fusion e TMGM hanno 0% tick reali nel 2025 (test simulati).
- Rainy- (07/09): allocazione personale per set (DD tra 1,5% e 25%); Rainy- 10/04: `UBS_Gold_Daily_A_6`, DD ~5,5% dal 2016.
- Andrew Soma (29/04): OHLC contro real ticks: 95% di corrispondenza sul profitto per l'oro, ~80% per gli indici. langesi (21/06): real ticks tolgono circa 40% di profitto. Le due cose non coincidono: da misurare noi.
- Gold su Vantage dal 01/07/2024: DD 25% per i set alternativi contro 44% per due set originali di Wim (stesso test).
- Scalp C: ok fino a meta' agosto, poi slippage e serie di SL. A e B: "didn't work good in live" (21/09).

## 6. Allegati da scaricare a mano (dopo antivirus), in ordine di utilita'
| Priorita' | File | Autore, data | Note |
|---|---|---|---|
| 1 | `LivePortfolioSets.zip` 130,5 KB | Wim, 31/07 | set esatti del portafoglio live a 44 strategie |
| 2 | set combo di Daytrade, Goldbot One, Gold Reaper, Goldtrade, Indicement, Luna, Gold Phantom, ORB Master | Wim, 04/02 (due invii, file cambiati di dimensione: prendere il secondo) | per confronto con i set del pacchetto |
| 3 | `ubs_onechart_live_MainEA_Settings.set`, `nas100_H1_G.set`, `nas100_H1_L.set` | Wim, 17/06 e 24/06 | main EA con autoloader e override lotto |
| 4 | `portfolio_test.zip` 89 KB, `EURUSD.zip` 2,36 MB | Wim, 14/05 e 15/06 | |
| 5 | `ScalpH1_B.set` | Wim, 26/03 | |
| 6 | `UBS_Manual_V4.0.pdf` (31/03), `Range_Breakout_Client_Guide_1.pdf`, `RANGE_USDJPY.set`, `RANGE_XAUUSD.set` | Wim, 31/03 e 06/08 | |
| 7 | `30StrategiesPortfolio_Sets.zip` 89 KB, `Gold_Scalp_A/B_YOLO.set`, `ScalpA_opt.set`, `ScalpB_opt.set` | utenti, luglio | solo come ipotesi |
| non ora | `Ultimate_Breakout_EA_TestVersion.ex5`, `...RangeBreakout.ex5`, `US500BreakRetest.set` | Wim, 09/07-06/08 | versioni di prova non ottimizzate |

Link ai messaggi: sono nel file originale e nei dettagli per mese (scratchpad), non copiati qui per non gonfiare il repo.

## 7. Cosa cambia per i nostri test
1. **UBS**: prima di qualsiasi test, ricalibrare "max historical DD a 0.01 lotti" sul BCM e sul FTMO con un backtest a 1% su balance fisso 80k. Senza, il rischio e' sbagliato di fattori anche x10 sugli indici.
2. **Altri EA gia' testati** (Apex, Stability, ecc.): controllare se hanno un parametro analogo. Non risulta da questo canale; da verificare sui set. Non do per buono il DD dei 88 test finche' non e' controllato.
3. **Bitcoin**: la nostra corsa e' 1M OHLC. Wim dice real ticks per Bitcoin e per scalping. Va scritto come limite nel referto.
4. **Guardian**: la funzione "stop a equity minima/massima" di UBS v7 e' l'equivalente di quello che gia' simuliamo; per UBS valutare se usarla.
5. **Set di utenti**: entrano nei test solo con autore, data e link, e passano per lo stesso tester dell'80k e gli anni long/short/laterale. Nessun risultato di utente vale come prova.
