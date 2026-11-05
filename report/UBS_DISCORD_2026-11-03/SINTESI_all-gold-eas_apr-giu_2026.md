# #all-gold-eas, aprile-giugno 2026 - sintesi (file DISCORD_PASSATO_all-gold-eas_2026-04_2026-06.md, 9.818 messaggi)

Letto da me per intero il blocco Wim di aprile, maggio e giugno (righe 554-713, 1529-1633, 2409-2508 del file) e controllato le citazioni principali. I 46 "set modificati" degli utenti NON li ho letti uno per uno (solo i punti citati dall'estensione e il confronto Guelsko). Immagini e allegati NON letti. Restano da leggere 20/01-31/03.

## Wim (citazioni dal file)
**Rischio con piu' EA e DD**
- 09/04: "General rule is: run 3 eas at 1/3rd of your normal risk"; 5 EA "would probably be ok with 1/4th of the risk, since the chance of all 5 having max drawdown at the same time is smaller". 05/05: "I run 4 at 1/4th of the risk, so the max drawdown is MAXIMUM of what 1 EA would be at normal settings". Minimi di conto: 3 EA da 1.500$, 5 EA da 3.000$ (29/04); 3 EA con 1.000$ e' poco (20/04).
- 12/05: con l'oro a ~5.000 la distanza dello SL (e la perdita a 0.01 lotti) e' raddoppiata rispetto a 2.500; sotto i 3K e' difficile tenere il DD sotto il 30%. 01/06: "even at 0.01lots a SL hit can be around 80-100$ sometimes".
- 11/06: su 5K "moderate" con 30% (o 20%) max DD; Moderate rende un po' meglio per unita' di DD, per Phantom "Intense has the best ratio" ma con piu' DD. **Metodo di verifica di Wim: backtest 2007-2026, balance FISSO 100K nelle impostazioni lotto, Max Allowed Total DD = 30, poi leggere crescita e max DD in $.**
- 01/06: "always assume that historical max DD might be broken at some point, and set your risk based on that"; il suo Goldtrade Pro era quasi al max storico ma nessuna singola strategia vicino al suo max storico (DD correlati). 24/04: intervenire "ONLY IF the max historical drawdown is breached (preferably by 20-30% more)". 12/05: mettere in pausa nei drawdown e ripartire e' "the best way to ruin your trading career".
**Parametri**
- 06/05: "adjustlotsizetovariablevalues" deve essere True ("because SL size gets bigger when gold has bigger value, so lotsize should decrease with bigger SL size"); Wim lo aveva dimenticato sul suo segnale Goldtrade Pro e High risk, che giravano a rischio molto piu' alto del voluto: "fixed that now... double check yours!". 25/06: ha dimezzato il rischio dopo le perdite di maggio.
- 01/06 il Max DD cambia solo il lotto, non lo SL. 18/05: "max allowed total DD will not work with manual strategy selection". 26/05: UBS 5.0 ha "max risk per strategy"; con UBS si possono far girare i set Gold Reaper da un grafico (es. 3% per strategia).
- 10/06: il CPI non e' filtrato negli EA oro, "you must do that manually".
- 25/06: TrailingTP/SL si basano sul prezzo di ingresso reale; SL e TP sul prezzo del pendente (salvo setSL-TP_After_Entry=true).
**Slippage / long-term / over-fitting**
- 30/05 (risposta a Guelsko, AdjustEntry -1000 nel 2026): "now do 2004-2026, because 'only 2026' really has no meaning for me"; "you are simply over-optimizing for a short period. I prefer the most stable performance longterm"; "if you do only last month, we can really make better results... but much worse longterm". 01/06: gli EA oro "perform basically the same in-sample and out-of-sample (about 10 years out of sample)".
- 20/05, 23/04, 25/06: contro lo slippage si puo' solo diversificare broker e conti ("I run 40 smaller accounts"), oppure far girare l'EA su 5 grafici con magic diversi, 1/5 del rischio e randomization; "if you constantly have bad slippage, change broker".
- 28/04: "STOP TOUCHING THE DAMN EAs!! UNLESS WE BREAK HISTORICAL DRAWDOWN".

## Utenti (non verificato)
- Guelsko: Reaper intense, AdjustEntry -1000, backtest 2026, lotto fisso 0.01/10K: 3,1K con ~5% DD contro 1,6K con ~2% del default. Confutato nel metodo da Wim (periodo troppo corto). Altri: fake breakout HIGH, randomization 60 contro 0, rischi per EA piu' bassi.

## Controllo sui NOSTRI set (nel repo)
- `Goldbot_PropFirm_5_2.5_*.set`: `AdjustLotsizeToVariableValues=1` (ok), `FakeOutFilter=1`, `AdjustEntry=0`, `OnlyUp=0`. I set Reaper e Phantom nel repo non mostrano un parametro con quel nome: NON VERIFICATO se lo hanno con un altro nome. Da controllare nel set originale prima di dire che e' corretto.
- Reaper `TradeFrequency=2`, `Randomization=0`.

## Cosa cambia per noi
1. Test fake-out/AdjustEntry: se li facciamo, anni LUNGHI (non solo 2026) e separati per regime, come per tutto il resto. Un test su un anno solo e' esattamente cio' che Wim chiama over-optimizing.
2. Il nostro trio sull'oro a 80k: la regola "3 EA a 1/3 del rischio" e' il confronto naturale per il nostro dimensionamento; da misurare, non da assumere.
3. L'oro a ~5.000 raddoppia lo SL rispetto al 2.500: i nostri test su anni lunghi devono tenere conto che il lotto minimo 0.01 pesa di piu' oggi (i DD in $ non sono confrontabili tra anni senza guardare il prezzo dell'oro).
4. Backtest consigliato da Wim: balance fisso 100K e Max Allowed Total DD = 30 su 2007-2026: noi usiamo l'80k e gli anni scelti; i due metodi non sono lo stesso.
