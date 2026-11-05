# #all-gold-eas, gennaio-marzo 2026 - sintesi (file DISCORD_PASSATO_all-gold-eas_2026-01_2026-03.md, 7.528 messaggi, dall'inizio del canale 20/01 al 31/03)

Letto da me il blocco Wim di gennaio-marzo (citazioni dal file); i 33 "set modificati" degli utenti non li ho letti uno per uno. Immagini e allegati NON letti. Con questo file `#all-gold-eas` e' coperto dall'inizio (20/01/2026) al 30/09/2026.

## Wim (citazioni dal file, tutte con link nel file originale)
**Fake breakout filter (rilevante per il test in coda)**
- 11/03: "low = M1, Medium = M1 + M15. High = M1+M15+H1"; "if first M1 candle closes in negative after entry, it's a fake breakout. same for the other timeframes"; i trade chiusi senza SL/TP sono dal filtro.
- 16/02: "the default settings for the breakout filter are the recommended ones"; "yes, off by default indeed. though I run it on 'low'" (EA non chiaro dal file).
- Wim su TGP (09/02): "I used Intense and fake breakout filter on".
**Rischio e dimensionamento**
- Max Allowed Total DD = lotto calcolato in modo che SE si raggiunge il max DD storico, la perdita sia circa X% (11/02). Il DD storico e' a 0.01 lotti e il "100% max DD" significa che se si ripete quel DD, "game over" (21/03). Il set "All Or Nothing" (100% max DD, 29/03) e' definito "EXTREME high risk"; Wim lo gira su un conto da ~1.900-2.500$ come scommessa.
- 17/02: "I tested with fixed balance 100K, and then used 30% Max Allowed Total DD". 18/02: assumere un DD potenziale del 20-30% peggiore dello storico "you'll sleep much better". 21/01: considerare backtest 2007-2026, non gli ultimi 4-5 anni. 24/04 (altro file): intervenire solo se il max storico viene superato.
- Con le combinazioni consigliate di Wim ("recommended combo set files", cartella `plug-and-play-eas`): DD massimo circa 25-30% (11/03).
- StartLots e' il lotto minimo con gli altri metodi; LotsizeStep e' sempre per 0.01 lotti (04/03); "I never use lotsizeStep to do strategy analysis" (20/03). Max Risk Per Strategy meglio del rischio per trade con piu' strategie (19/02).
- L'SL non e' fisso ma legato al prezzo dell'oro: "if SL is 1000pips when gold is 2000$, then SL will be 2000pips when gold is at 4000$" (05/02); non e' basato su ATR (05/02). `adjustlotsizetovariablevalues` attivato anche per XAUUSD (20/03): il lotto cala quando l'SL sale.
- Strategie: 1,2,3 daily, 4,5 H4, le altre H1 (23/01). Strategia 5 in perdita dal lancio, la 6 profittevole (20/03).
**Operativita'**
- Friday stop hour chiude tutto; con "FridayStopHour 23" chiude a mercato e pendenti alle 23:00 ora del broker (14/03). Wim ha ridotto l'esposizione prima del weekend per i gap (13-14/03) ma "in normal times I would never close".
- Trailing SL/TP si muovono una volta a ogni candela M1, non a ogni tick (17/02); trailing TP "better than full SL" (17/02).
- Slippage durante l'NFP e' il problema (05/02). Backtest: "Metaquotes for gold backtesting... the one that comes closest to my live results (on any broker)"; ICMarkets per Bitcoin e indici (17/02, 21/02).
- Randomization: aggiunge/sottrae un valore casuale in pips da 0 al valore impostato a entrata e uscite, nuovo valore a ogni trade (22/01).
- Filtro news: il fallback usa il GMT del VPS se il calendario MQL5 non funziona; se il VPS ha l'ora sbagliata, gli orari del filtro possono essere sbagliati (27/03).
- "Golden rule in trading: do NOT make long term changes based on short term results" (17/02).
- Minimi di conto: circa 750$ per l'oro al prezzo attuale (21/02).

## Cosa cambia per noi
1. Il meccanismo del fake-out e' confermato da Wim: aggiornato il documento dei criteri (Emendamento 1), previsioni invariate.
2. Il DD "storico" di Wim e' da 2007-2026: i nostri anni (2013, 2018, 2020, 2025) sono solo un campione.
3. Il fallback news usa l'ora del PC/VPS: sul BCM (GMT+1 fisso) il filtro news del tester potrebbe avere orari diversi in estate/inverno: NON misurato.
