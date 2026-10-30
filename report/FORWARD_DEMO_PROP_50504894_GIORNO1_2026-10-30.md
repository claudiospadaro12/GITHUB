# Forward demo 50504894 (set prop, 100.000 EUR, leva 1:10): prima giornata, 30/10/2026
Fonte: report cronistorico del terminale (xlsx caricato da Claudio, generato 30/10 20:43). Non controllata da agenti. Una sola giornata: NON dice niente sui risultati nel tempo.

## Numeri (EUR)
Saldo 103.907,68 (+3.907,68, +3,9%), P/L fluttuante +527,85, equity 104.435,53; margine usato 6.261, margine libero 98.174. 32 posizioni chiuse, TUTTE sell (62,5% vincenti), PF 8,13; profitto lordo 4.455,69, perdita lorda -548,01; la piu grande vincente +635,96, la piu grande perdente -69,05; drawdown di saldo massimo 466,10 (0,47%); commissioni totali 9,76. Una posizione aperta (GoldBot One sell 0,07 a 3.959,07, +527,85) e 47 ordini pendenti attivi (Phantom 23, Reaper 9, Goldbot 8, GTP 7).
Per EA (profitto + commissioni): Reaper 7 pos, 1,02 lotti, +1.803; Gold Trade Pro 9 pos, 0,93 lotti, +1.427; Phantom 11 pos, 0,36 lotti, +432; Goldbot One 5 pos, 0,39 lotti, +246 (piu +528 aperto). Oro da circa 3.980 a 3.875: giornata di discesa, i breakout sell sono scattati tutti.

## Margine: 25 ordini rifiutati "no money"
25 sell stop rifiutati per margine insufficiente (4,52 lotti in tutto), 20 alle 08:49:02-20 quando i livelli intorno a 3.975-3.978 sono scattati insieme, 5 fra le 14:04 e le 14:11. Eseguiti nello stesso giorno 2,70 lotti: la quota del volume richiesto che e stata aperta e circa il 37% (2,70 su 7,22). Con leva 1:10 il margine per lotto sull'oro e circa 34.000 EUR: la capacita del conto da 100.000 e circa 2,9 lotti. Il tester gira a leva 1:100 e questo non lo mostra. Lo stesso limite si ritroverebbe su un conto FTMO con leva 1:9-1:15 sull'oro [ipotesi, leva FTMO non verificata]. Quali ordini passano e quali no dipende dall'ordine di arrivo.

## Correzione
Il 30/10 avevo letto nei log del 29/10 un rapporto 2,0 fra i lotti del Reaper dei due conti e ne avevo dedotto un MaxAllowedDD circa 18: il confronto era sbagliato perche il log del conto prop era delle 16:58, prima che venissero caricati i set (default 30: 0,49 lotti), mentre i lotti dopo il caricamento del set prop sono 0,16 (rapporto 3,1 fra 30 e 9). Il conto alto rischio ha 0,97 contro 0,16 = 6,1: coerente con un MaxAllowedDD 60 contro 9.
