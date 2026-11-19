# TV_SCOUT_8 (zip del 19/11): audit e backtest — criteri e previsioni scritti PRIMA dei numeri (19/11/2026)
Sei script con codice esatto (verificato dall'estensione riga per riga): 21 Jaws Mean Reversion (v4), 23 Donchian Channels strategy (v4), 24 Peri Bollinger Mean Reversion V2 (v6), 25 RSI Mean Reversion (v6, "ottimizzato per gas naturale MCX 4H"), 26 Z-Score Mean Reversion Pro (v6), 27 Breakout Finder (v4, indicatore). Non estratti: 22 (pubblicazione cancellata), 28 SMRE (1.471 righe). Il 27 NON e' il 17 dello zip precedente (quello zip conteneva solo 11, 15, 16).
## Audit anti-repainting (dal codice)
- 21, 24, 25, 26: nessun `request.security`/lookahead; segnali a chiusura barra (25 usa `barstate.isconfirmed`). Puliti. 21 e 24 non hanno stop (24 in piu' accumula fino a 5 unita' contro il movimento: rischio di mediazione). 26: lo stop/TP e' calcolato sulla chiusura della barra di riempimento; in un'inversione diretta long<->short restano i prezzi VECCHI (difetto).
- 23: `calc_on_every_tick=true` e il canale include la barra corrente: in tempo reale il segnale compare a meta' barra e puo' sparire/ripetersi; nel backtest storico e' valutato a chiusura. **Backtest e live non coincidono: usare solo a barra chiusa.** Sempre in mercato (stop-and-reverse), nessuno stop.
- 27: pivot confermati con 5 barre di ritardo (nessun futuro); il segnale usa `close` della barra: stabile solo a barra chiusa. Indicatore senza uscite.
- 25: parametri ottimizzati su un altro mercato (gas naturale 4H): atteso sovradattamento.
## Test (stesse regole del 18/11, `backtest_runner/simulatore/tv_scout8_backtest.py`)
- Dati: EURUSD e XAUUSD H1 da M1 FTMO, 2014-11/2020-12, riga aggregata 00:00 scartata. IS = fino al 27/02/2019 (70% delle barre), OOS = dopo. Costi all-in: EURUSD 1,0 pip, XAUUSD 0,35 USD. Ingresso all'apertura della barra successiva al segnale.
- **Rischio R** (per PF/DD con 1% a operazione): dove lo script ha stop (26) = distanza stop; dove non ha stop (21, 23, 24, 25) R = 2 x ATR(14) all'ingresso (scala convenzionale, nessuno stop applicato: l'uscita e' quella dello script); 27 e' un indicatore: uscite NOSTRE SL 2 ATR / TP 4 ATR (come il Breakout Range).
- Porting fedele con i parametri di default degli autori. 24: una sola unita' (niente mediazione), deviazione dichiarata. 26: baseline = default (filtro BB-width 2% pensato per azioni/cripto: se i trade IS sono < 30 si riporta e si lancia UNA variante dichiarata con filtro BB spento). Griglia piccola per script (1-2 parametri, tre valori) solo per vedere il plateau; **nessuna ottimizzazione finale se nessuna cella IS arriva a PF 1,5.**
## Porte (di Claudio, immutate)
Filtro IS: PF >= 1,5, DD <= 15%, >= 100 operazioni. **VALIDATA** = filtro IS + OOS con PF > 1,2, R medio > 0, >= 30 operazioni. Nessun "salvataggio" a posteriori.
## Previsioni
- Nessuno script validato su nessun mercato: **92%**.
- 23 Donchian e 25 RSI(3) (sempre in mercato, nessuno stop): PF IS < 1,2 su entrambi i mercati: **80%**.
- 21 Jaws (long only, nessuno stop): pochi trade (< 100 IS) su almeno un mercato: **70%**; PF IS tra 0,9 e 1,4: 75%.
- 26 baseline default: < 30 trade IS su EURUSD (filtro 2% di larghezza BB): **90%**.
- 27: R medio netto <= 0 su EURUSD: **80%**.
- Almeno una cella di griglia con PF IS >= 1,5 e >= 100 trade: **12%**; che tenga l'OOS: **3%**.
## Limiti
Un periodo di 6 anni, due mercati, H1 senza tick, parametri di default; conclusioni valide per questi script su questi mercati/TF (alcuni nati per azioni/gas/cripto). Per il 24 niente piramidazione. Il PF su R convenzionale (2 ATR) per gli script senza stop non e' confrontabile con un conto reale: serve solo a dire se c'e' vantaggio.

## RISULTATI (dati puliti; IS = fino al 27/02/2019, OOS = dopo; `tv_scout8_backtest.py`)
| Script | Mercato | IS n | IS R | IS PF | IS DD | OOS n | OOS PF | Esito |
|---|---|---|---|---|---|---|---|---|
| 21 Jaws (2,8,1%) | EURUSD | 5 | +0,26 | 2,96 | 0,7% | 0 | - | < 100 operazioni: NON VALUTABILE | 
| 21 Jaws | XAUUSD | 16 | -0,13 | 0,61 | 3,7% | 21 | 1,57 | NON VALIDATA |
| 23 Donchian 20 (conferma) | EURUSD | 504 | +0,06 | 1,06 | 60% | 202 | 1,38 | NON VALIDATA (IS) |
| 23 Donchian | XAUUSD | 461 | -0,09 | 0,91 | 63% | 190 | 1,46 | NON VALIDATA (IS) |
| 24 Peri BB+RSI | EURUSD | 406 | +0,05 | 1,08 | 25% | 166 | 0,80 | NON VALIDATA |
| 24 Peri BB+RSI | XAUUSD | 379 | -0,06 | 0,92 | 40% | 161 | 0,76 | NON VALIDATA |
| 25 RSI(3) 40/70 | EURUSD | 3.328 | -0,04 | 0,88 | 85% | 1.470 | 0,96 | NON VALIDATA |
| 25 RSI(3) | XAUUSD | 2.938 | -0,08 | 0,79 | 93% | 1.347 | 0,89 | NON VALIDATA |
| 26 Z-Score default | EURUSD / XAUUSD | 0 / 0 | - | - | - | 0 / 1 | - | **zero segnali** (filtro larghezza BB 2%) |
| 26 Z-Score filtro BB spento | EURUSD / XAUUSD | 4 / 4 | - | - | - | 2 / 4 | - | < 30: NON VALUTABILE (RSI<30 + z<-2,5 + EMA200 quasi mai insieme) |
| 27 Breakout Finder (SL2/TP4 nostri) | EURUSD | 250 | -0,06 | 0,92 | 25% | 105 | 0,79 | NON VALIDATA |
| 27 Breakout Finder | XAUUSD | 223 | -0,11 | 0,85 | 29% | 104 | 0,94 | NON VALIDATA |
**Griglie (16/8/9/16/9/9 celle per script):** nessuna cella con >= 100 operazioni IS arriva a PF 1,5. Massimi IS con >= 100 trade: Jaws EURUSD 1,01, oro 1,37 (n 142, ma OOS 0,96); Donchian 1,06 / 1,15; Peri 1,13 / 1,07; RSI3 1,02 / 0,97; Z-score nessuna cella con 100 trade; Breakout Finder 1,07 / 1,21 (OOS 1,08 / 0,87). Plateau (celle con PF IS >= 1,3): 0 in tutte tranne una cella isolata del Jaws oro (1 su 7). **Nessuna ottimizzazione fatta.**
**Controlli:** costi sul lordo (EURUSD): RSI3 lordo R +0,004 (PF 1,01) → nessun vantaggio nemmeno senza costi (4.800 operazioni); Peri lordo PF 1,06 → i costi lo azzerano. **Donchian** e' l'unico con un lordo positivo su tutto il periodo (EURUSD PF 1,15, oro 1,04 netti) ma per anno e' instabile (EURUSD 0,75 / 0,98 / 0,98 negli anni 2016, 2018, 2019; oro 0,47-0,78 nel 2014, 2017, 2018) e il buon OOS (PF 1,38 / 1,46) viene dal 2020 (EURUSD 1,76, oro 1,68), anno di trend: stessa trappola gia' vista con il Supertrend oro. t OOS 1,7 e 1,4 (non significativo). Il DD 60% e' sul rischio convenzionale di 1% per 2 ATR senza stop: lo script non ha stop.
**Verdetto con le regole scritte: nessuno script VALIDATO, nessun Pine finale.** Previsioni: nessuno validato (92%) → si'; Donchian e RSI3 PF IS < 1,2 su entrambi (80%) → si'; Jaws < 100 trade IS (70%) → si' (5 e 16 operazioni: su H1 "1% sotto la media a 8 barre" non accade quasi mai, e' pensato per giornaliero/azioni); Z-score < 30 trade (90%) → si' (zero); Breakout Finder R < 0 su EURUSD (80%) → si'; cella >= 1,5 (12%) → no.
## Limiti e cosa resta
Un periodo, 2 mercati, H1 (Jaws e Z-score nascono per D1/azioni-cripto: su H1 forex non producono segnali, quindi non sono "bocciati" ma "non applicabili"); non testati su altri TF/mercati. Restano da estrarre il 28 SMRE (1.471 righe: serve seconda passata dell'estensione o incolla con "Copia") e il 22 e' cancellato. Il bilancio dei due zip: 9 script esatti + CHoCH LuxAlgo, tutti senza vantaggio su EURUSD/oro H1.
