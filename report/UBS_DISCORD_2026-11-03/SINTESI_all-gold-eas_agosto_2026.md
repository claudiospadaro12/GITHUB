# #all-gold-eas, agosto 2026 - sintesi (file DISCORD_PASSATO_all-gold-eas_2026-08_2026-09.md, agosto = 3.440 messaggi)

Letto da me per intero il blocco Wim/staff di agosto (righe 2076-2297) e filtrato i 15 "set modificati" degli utenti. Il settembre di quel file e' quello gia' sintetizzato in SINTESI_all-gold-eas_settembre_2026.md. Immagini e allegati NON letti. `Digital_Wim` e' un bot, non Wim. Numeri degli utenti = non verificati. Restano da leggere 20/01-31/07.

## Wim (citazioni dal file)
- 02/08: "Intense is fine as well. I would never 'recommend' extreme... The risk reward is the worst of all strategies, and I only added it because some clients were complaining about not enough trades".
- 03/08: dopo perdite, rilanciare l'EA (rimuoverlo prima) e mettere "reset highest balance" = true.
- 05/08: scalp "great trades on ICMarkets Precision"; lo stesso set su Vantage nel portafoglio scalp "much worse"; ha ridotto a 4 set quel portafoglio; "scalping, as always, is so sensitive".
- 11/08: il cliente dei "70k" usa extreme + Max Allowed Total DD 204% "very high risk", e ogni tanto chiude a mano.
- 12/08: i filtri news funzionano in backtest perche' le date sono scritte nel codice; "the MQL5 calendar doesn't work in backtests". L'NFP lo usa solo per lo slippage, non per i fake breakout; non filtra il CPI ("no history of giving a lot of slippage"); "these news events are rather good for breakout systems".
- 16/08: "There really is no answer [to which settings]... what's your account size and max tolerated drawdown?".
- 23/08: serve un terminale MT5 separato per ogni conto di trading.
- 26/08: se si girano insieme piu' EA (Reaper + Phantom), usare un "max allowed total drawdown" piu' basso (il bot aveva detto altro: corretto da Wim).
- 27/08: lo slippage non si puo' "filtrare" perche' c'e' solo a trade gia' aperto. Errore "trade disabled": password investor, simbolo sbagliato o AlgoTrading non attivo. SL troppo vicino: stop level del broker. Scalp C: cambiata solo la formula del lotto.
- 30-31/08 (backtest): "there is no real ticks data for longterm, so makes no sense trying to backtest longterm"; "if your shorter term comparison between 1M OHLC and Real Ticks is good, you can use 1M OHLC for longterm tests in my opinion"; non gli piace il feed Dukascopy (diverso dai feed reali); "having 99,99% backtests doesn't say anything about the over-optimizations... it should work on any backtest data". Allegato `Gold_Bundle.zip` (backtest suo, non letto).
- 29/08: "+100% with very limited drawdown for Gold Scalp set", periodo 2025-2026 (immagini non lette).

## Staff (Marcus Wyatt, ruolo NON verificato)
- 25-26/08: usa i set combo di Wim `*_4GOLD.set` (o `*_3GOLD.set` se 3 EA) sui 4 EA oro, senza modifiche; si trovano in `AllSets&Manuals.zip` nel canale plug-and-play-eas, cartella "recommended combo setup". Su un conto da 1.300$: luglio -238$, agosto +1.470$; lui stesso dice che potrebbe essere stata fortuna e non si aspetta gli stessi risultati. Reaper "trades roughly once a week on average". Il link FXBlue che cita non e' stato aperto.
- Gli scalper di sessione (Global Trade Plan) hanno "slippage horrendo" ora che troppi li usano.

## Utenti (non verificato)
- Jonasz (11/08): max DD 40% scelto cosi': in backtest 80% era il massimo che non bruciava il conto (90% si'), poi dimezzato. Metodo discutibile: un DD vicino al punto di rottura del backtest non e' un margine.
- MacauCEO: set default, frequency moderate, DD 100%, onlyup false. Ash: set Scalp A/B con ingresso anticipato come Scalp C (every tick + pips extra), "performing better" (valori solo in screenshot). maindfriik: tiene solo Scalp C. BIGDEX (Vantage, demo): StartLots 0.05 ma apre 0.02 (Weighted Lotsize attivo).
- Jonasz e Suichi: disattivare la chiusura del weekend / la strategia 9 non peggiora il DD ma riduce i profitti (backtest, non allegati).
- Passando da Extreme a Moderate gli ordini pendenti piazzati in Extreme restano (bug noto, serve rimuoverli a mano).

## Cosa cambia per noi
1. Wim stesso dice che 1M OHLC va bene per i test lunghi SE il confronto breve con i real ticks e' buono: e' il nostro metodo (Modello 1 OHLC). Per Bitcoin, indici e scalp vale ancora la sua regola (real ticks), gia' scritta nella sintesi UBS. Il confronto OHLC/real ticks va misurato da noi su un periodo corto, non assunto.
2. I filtri news in backtest usano date scritte nel codice: i nostri test le avranno, il live usa il calendario MQL5 (stessa nota di luglio).
3. Per i 3-4 EA oro in parallelo conviene un "max allowed total drawdown" piu' basso: coerente con il nostro uso del trio con il Guardian.
4. I set combo `*_3GOLD.set`/`*_4GOLD.set` sono la "baseline" ufficiale di Wim: il confronto con i nostri set prop (Goldbot_PropFirm, GoldPhantom_Propfirm, GoldReaper_propfirm) va fatto a parita' di periodo prima di dire che i nostri sono meglio o peggio. Se non li abbiamo, vanno scaricati a mano da `AllSets&Manuals.zip`.
