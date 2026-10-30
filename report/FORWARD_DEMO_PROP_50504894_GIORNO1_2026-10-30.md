# Forward demo 50504894 (set prop, 100.000 EUR, leva 1:10): prima giornata, 30/10/2026
Fonte: report cronistorico del terminale (xlsx caricato da Claudio, generato 30/10 20:43). Non controllata da agenti. Una sola giornata: NON dice niente sui risultati nel tempo.

## Numeri (EUR)
Saldo 103.907,68 (+3.907,68, +3,9%), P/L fluttuante +527,85, equity 104.435,53; margine usato 6.261, margine libero 98.174. 32 posizioni chiuse, TUTTE sell (62,5% vincenti), PF 8,13; profitto lordo 4.455,69, perdita lorda -548,01; la piu grande vincente +635,96, la piu grande perdente -69,05; drawdown di saldo massimo 466,10 (0,47%); commissioni totali 9,76. Una posizione aperta (GoldBot One sell 0,07 a 3.959,07, +527,85) e 47 ordini pendenti attivi (Phantom 23, Reaper 9, Goldbot 8, GTP 7).
Per EA (profitto + commissioni): Reaper 7 pos, 1,02 lotti, +1.803; Gold Trade Pro 9 pos, 0,93 lotti, +1.427; Phantom 11 pos, 0,36 lotti, +432; Goldbot One 5 pos, 0,39 lotti, +246 (piu +528 aperto). Oro da circa 3.980 a 3.875: giornata di discesa, i breakout sell sono scattati tutti.

## Margine: 25 ordini rifiutati "no money"
25 sell stop rifiutati per margine insufficiente (4,52 lotti in tutto), 20 alle 08:49:02-20 quando i livelli intorno a 3.975-3.978 sono scattati insieme, 5 fra le 14:04 e le 14:11. Eseguiti nello stesso giorno 2,70 lotti: la quota del volume richiesto che e stata aperta e circa il 37% (2,70 su 7,22). Con leva 1:10 il margine per lotto sull'oro e circa 34.000 EUR: la capacita del conto da 100.000 e circa 2,9 lotti. Il tester gira a leva 1:100 e questo non lo mostra. Lo stesso limite si ritroverebbe su un conto FTMO con leva 1:9-1:15 sull'oro [ipotesi, leva FTMO non verificata]. Quali ordini passano e quali no dipende dall'ordine di arrivo.

## Correzione
Il 30/10 avevo letto nei log del 29/10 un rapporto 2,0 fra i lotti del Reaper dei due conti e ne avevo dedotto un MaxAllowedDD circa 18: il confronto era sbagliato perche il log del conto prop era delle 16:58, prima che venissero caricati i set (default 30: 0,49 lotti), mentre i lotti dopo il caricamento del set prop sono 0,16 (rapporto 3,1 fra 30 e 9). Il conto alto rischio ha 0,97 contro 0,16 = 6,1: coerente con un MaxAllowedDD 60 contro 9.

## Conto alto rischio 50504263 (stessa giornata, report cronistorico generato 20:45)
Saldo finale 94.651,47 = equity (nessuna posizione aperta, nessun margine usato). 32 posizioni chiuse, tutte sell, 25,80 lotti in tutto, netto -4.864,22 (profitto -4.771,97, commissioni -92,25), cioe -4,89% del saldo di ieri sera (99.515,69), 364 EUR oltre il limite del Guardian (4,5% di 100.000 = 4.500).
**21 posizioni (18,27 lotti) chiuse nello stesso secondo 09:01:53-54: netto -5.336,69**; le altre 11, chiuse prima, +472,47. Dopo le 09:02 nessuna nuova posizione; gli EA continuano a piazzare pendenti ogni 5 minuti e ogni volta vengono cancellati (circa 1.860 ordini "canceled" dopo le 09:02). Coerente con la chiusura di tutto del Guardian; la conferma diretta (righe `[GUARDIAN]` nel giornale) NON e stata vista.
Per EA (netto): Goldbot One -2.730 (8 pos, 8,04 lotti, peggiore -894 con 2,19 lotti), Gold Trade Pro -1.382 (8 pos, 6,75 lotti), Phantom -439 (8 pos, 2,88 lotti), Reaper -313 (8 pos, 8,13 lotti, peggiore -463 con 1,94 lotti).
**Nessun ordine rifiutato per margine (0)** contro i 25 del conto prop: 25,8 lotti a 3.978 non stanno in un conto da 100.000 a leva 1:10 (servirebbero circa 880.000 EUR di margine): la leva di 50504263 e molto piu alta di quella di 50504894 [da confermare con Claudio].

## Confronto fra i due conti (30/10)
| | Prop 50504894 | Alto rischio 50504263 |
|---|---|---|
| Lotti aperti | 2,70 | 25,80 |
| Ordini rifiutati per margine | 25 (4,52 lotti) | 0 |
| Netto della giornata | +3.907,68 (+3,9%) | -4.864,22 (-4,9%) |
| Guardian | non e scattato | chiusura di 21 posizioni alle 09:01:53 (probabile) |
Stessi segnali, stesso oro: i sell sono scattati intorno a 3.975-3.978 e alle 09:01:53 l oro era a circa 3.979,7 (rimbalzo di 2-4 USD); poi e sceso a 3.875. Sul conto alto rischio la chiusura del Guardian ha tagliato le posizioni sul rimbalzo, mentre sul conto prop le stesse (con meno lotti) sono rimaste aperte e hanno chiuso a profitto (per esempio +433 alle 14:01). Previsione P3 (rapporto di profitto Reaper alto/prop fra 1,6 e 2,4): NO (segno opposto: -313 contro +1.803). Una giornata sola; due conti con leve diverse: il confronto NON e a parita di condizioni.
