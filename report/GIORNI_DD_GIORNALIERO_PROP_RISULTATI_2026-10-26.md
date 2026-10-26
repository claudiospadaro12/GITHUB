# Quanti giorni ogni EA tocca il DD giornaliero FTMO: risultati (26/10/2026)
**Natura: MISURA + LETTURA, SOLO REALIZZATO (limite inferiore).** Criteri e previsioni scritti prima: `GIORNI_DD_GIORNALIERO_PROP_CRITERI_2026-10-26.md` (commit 5b91bec4). Lettore congelato `leggi_giorni_dd_prop.py` (autotest OK; riprodotto il peggior giorno noto di Prop Firm Gold EA, 17/02/2026 -2.501,65). Uscita completa: `risultati_archivio/GIORNI_DD_PROP_20261026.txt`. Giorno FTMO = mezzanotte CE(S)T (server BCM UTC+1: in estate +1 ora). **FTMO misura sull'equita, flottante compreso: i numeri sotto sono un MINIMO.** Dati: gen 2025-set 2026 con l'oro soprattutto al rialzo.

## Giorni con perdita realizzata oltre la soglia (corse a 80.000 EUR, default del venditore, nessun guardiano)
| EA | giorni | >= 3% | >= 4% | **>= 5%** | >= 4.000 EUR fissi | peggior giorno |
|---|---|---|---|---|---|---|
| Smart Gold Hunter | 192 | 0 | 0 | **0** | 0 | -0,0% (-9 EUR) |
| Prop Firm Gold EA | 437 | 0 | 0 | **0** | 0 | -2,3% (-2.502) |
| Entry Points Pro | 247 | 0 | 0 | **0** | 0 | -1,8% (-1.509) |
| ORB Revolution | 173 | 0 | 0 | **0** | 0 | -2,5% (-1.845) |
| Rocket Breakout | 157 | 2 | 0 | **0** | 2 | -3,7% (-4.272) |
| SixtyNine | 297 | 7 | 1 | **0** | 12 | -4,6% (-15.389, luglio 2026) |
| Umbra Vault | 347 | 3 | 3 | **3** | 3 | -8,4% (-7.208, 12/02/2025) |
| Vortex Turbo | 289 | 3 | 3 | **3** | 3 | **-11,8%** (-17.481, 01/07/2026) |
| Microedge | 280 | 5 | 5 | **5** | 5 | -8,0% (-8.456, 11/04/2025) |
| SomaGold (protezione spenta) | 156 | 5 | 4 | **2** | 14 | -7,2% (-5.592, 17/01/2025) |
| Gold Snap | 159 | 11 | 1 | **1** | 16 | -6,1% (-19.934, 08/12/2025) |
"% di giorno" = sul saldo a inizio giorno: non dipende dalla crescita del conto. "4.000 EUR fissi" = il 5% del capitale iniziale 80.000, la lettura letterale di una prop: con l'auto-lotto che cresce col saldo (Gold Snap, SixtyNine, SomaGold) le perdite in EUR dei mesi tardivi superano 4.000 anche quando in % sono contenute: per una prop servirebbe un lotto massimo (scelta di Claudio).

## Con la guardia da prop del venditore accesa (Microedge e Umbra)
Microedge **5 -> 11 giorni** a -5,0% e Umbra **3 -> 12** a -5,0/-5,2%: i giorni peggiori finiscono tutti in fondo a -5%, perche la guardia **chiude le posizioni quando il giorno tocca il -5%**: il flottante diventa perdita realizzata. Netto 21 mesi: Microedge +66.709 invece di +112.199, Umbra +60.785 invece di +195.101. **Questo e il meccanismo che Claudio ha visto sul reale: la guardia che chiude su un flottante che poteva rientrare trasforma la perdita in definitiva** (nel tester questi EA rientrano spesso). Non e un giudizio sul Guardian di casa, che ha un'altra regola: e la misura sulla guardia dei venditori.

## Arena (5.000 EUR, lotto 0,01, 3 mesi, realizzato)
Giorni con perdita >= 5%: luglio 3 (24/07 -27%), agosto 1 (05/08 -67%, stop out), settembre 3 (11/09, 18/09, 28/09 -70%). **In EUR** (il lotto base e fisso: a 80.000 le perdite sarebbero le stesse): giorni con perdita >= 4.000 EUR = **3 su 3 mesi** (05/08 -4.029, 18/09 -4.686, 28/09 -5.809), piu 11/09 -3.474 e 24/07 -3.162 vicini. Misura sul solo realizzato: il flottante di Arena e molto piu grande.

## Previsioni scritte prima
G1 nessun EA oltre il 5% salvo Arena e Vortex: **NO** (anche Microedge 5, Umbra 3, SomaGold 2, Gold Snap 1). G2 Arena oltre il 5% in agosto e settembre: **SI**. G3 almeno 5 EA con peggior giorno sotto il 3%: **NO** (4: Smart Gold Hunter, Prop Firm Gold, Entry Points, ORB Revolution). G4 giorni fissi 4.000 > giorni al 5% relativo per almeno 2 EA: **SI** (Gold Snap, SixtyNine, SomaGold, Rocket). 2 su 4.

## Lettura per le due classi di Claudio (dati, non scelte)
- **Mai oltre il 3% nel realizzato (candidati per DD basso, a patto di verificare il flottante):** Smart Gold Hunter (guadagno piccolo: +276 EUR su 80K in 21 mesi), Prop Firm Gold EA (+34.130, DD equity 9,7% dal picco), Entry Points (+3.038, PF 1,06), ORB Revolution (perde). Chi ha anche un risultato utile: Prop Firm Gold e Smart Gold Hunter (gia nella combinazione A del 19/10).
- **Vicini ma sopra il 3%:** Rocket Breakout (2 giorni, max -3,7%), SixtyNine (7 giorni, 1 oltre il 4%, max -4,6% ma in EUR anche -15.389 per il lotto grande).
- **Oltre il 5% piu volte, con giorni da -7% a -12% (non per una prop senza guardia):** Microedge, Umbra, Vortex, SomaGold, Gold Snap. Sono quelli dove il conto personale potrebbe essere la collocazione, e dove la guardia dei venditori peggiora il risultato.
- **Arena:** fuori da entrambe le classi nel realizzato; flottante da misurare.

## Cosa NON dice
Realizzato, non equita: per Arena, SomaGold, Vortex, SixtyNine e Gold Snap i giorni veri oltre il 5% sono di piu. Oro quasi sempre al rialzo; tester senza slippage; nessuna taglia o acquisto: decisioni di Claudio. **Prossimo passo per l'equita (da decidere):** esportare le barre M1 dell'oro 2025-2026 dal terminale e, per gli EA con una posizione alla volta (Rocket, Entry Points, ORB, Umbra, Microedge, Gold Snap), calcolare l'equita intraday esatta; per Vortex, SixtyNine e SomaGold serve l'accoppiamento delle posizioni (stima), oppure un giro del tester che registri l'equita.
