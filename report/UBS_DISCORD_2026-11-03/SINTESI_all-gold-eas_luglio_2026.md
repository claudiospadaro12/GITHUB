# #all-gold-eas, luglio 2026 - sintesi (file DISCORD_PASSATO_all-gold-eas_2026-07_2026-09.md, luglio = 2.701 messaggi)

Letto da me per intero il blocco Wim di luglio (righe 3105-3245) e filtrato i 14 "set modificati". Agosto e settembre di quel file sono nelle sintesi gia' fatte. Immagini/allegati NON letti. Numeri degli utenti = non verificati. Restano da leggere 20/01-30/06.

## Wim (citazioni dal file)
- 03/07: "backtests are actually better I think without filter. But live too much risk of slippage which will cause difference in results" (filtro news).
- 03-04/07: dopo un prelievo bisogna togliere l'EA e rilanciarlo con "Reset Highest Balance" = true (unico modo per azzerare il valore di OnlyUp); OnlyUp serve ad adattare i pendenti quando il balance sale; Wim lo usa "because my risk is based on backtests with fixed lotsize (so it doesn't decrease either after losses)".
- 12/07: piu' EA oro sullo stesso terminale: "run each one on a different chart, and divide the risk per EA, by the number of EAs".
- 14/07: Darwinex MT5 con slippage enorme sull'oro (entrate a 4009 invece di 4020 degli altri broker); "MT4 did much better for Darwinex".
- 22/07: i parametri "run strategy N = false" valgono solo con trade frequency = "use manual strategy selection" (e' nel manuale). Un set aveva "extra pips below low for entry" -60 invece di -10: corretto.
- 23/07: non e' possibile avere trade identici su tutti i conti: "simply IMPOSSIBLE to have 100% same trades on all accounts".
- 25/07: scalp A e B "kinda correlated"; li gira entrambi live per scegliere; "backtest on Metaquotes is better for ScalpB, but on Vantage (better pricefeed), ScalpA does better".
- 29/07: "More Trades Does NOT Equal More Profits!"; i SL a catena che vede sono di chi usa extreme; ogni strategia ha un proprio trailing SL, alcuni poco aggressivi.
- 30/07: moderate + max DD 30% come riferimento; il SL non cambia con il rischio impostato.
- 31/07: con 5K o piu' farebbe girare tutti e 4 gli EA oro "(lowered risk for each one!)"; con 3K ne farebbe girare 2 (Reaper e Phantom). Break and retest: serve set dedicati, "it's not simply enabling it".

## Utenti (non verificato)
- dinocon9: fake out filter di Reaper su "low" invece di "medium": in backtest circa il doppio del profitto con DD relativo quasi uguale (immagini non lette; nessuna conferma di Wim). Robin: Reaper, Max Allowed Total DD 20%, news filter on, fake breakout medium, test 2020-2026.
- maindfriik: trailing modificato (ingressi no), "2025-today" meglio in test, live su lotti piccoli (Vantage/TMGM); SL piu' stretto + risk per trade batte il default solo perche' il lotto e' piu' grande (non per merito del set); chiude tutto alle 23.
- Perdite dei nuovi: Adebayo Ojo ha perso circa 10k EUR in poche settimane con Reaper; DanM con Reaper high risk 60% DD "got hit" (consiglio di Wim: 30%). Molti dei SL di fine luglio sono su "extreme".

## Cosa cambia per noi
1. Il DD storico di Wim e' a lotto fisso e l'OnlyUp non riduce il lotto dopo le perdite: nei nostri test con il Guardian questo va tenuto presente.
2. Per piu' EA oro insieme: dividere il rischio per il numero di EA (Wim 12/07) - e' quello che facciamo col trio.
3. Il filtro news migliora il backtest se tolto ma dal vivo c'e' slippage: nei test senza slippage i risultati senza filtro sono ottimisti.
4. Il test "fake out filter low contro medium" di dinocon9 e' un'ipotesi da verificare con i nostri anni (long/short/laterale): non e' ancora una prova.
