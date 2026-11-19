# GoldenZoe_H4 (EA MQL5 dell'oro trend following): criteri del test nel tester, scritti PRIMA dei numeri (19/11/2026)
**EA:** `mql5/Experts/GoldenZoe_H4.mq5` (breakout 55 candele H4, stop iniziale 3 ATR, stop mobile Chandelier 3 ATR, solo long di default). Riga: `RIGA_GOLDENZOE_BCM.txt` (BCM portabile, XAUUSD H4, Modello 1 barre da 1 minuto, 100.000 EUR, rischio 1% dell'EA, spread/commissioni/swap del tester). **Non compilato in questa sessione**: il primo lancio dira' se ci sono errori.
**Differenze note dal simulatore Python (cause attese di scarto):** candele H4 del server BCM (GMT+1 fisso) contro quelle FTMO; iATR di MT5 (media semplice) contro la media di Wilder; spread e swap veri al posto di 0,35 USD fissi; stop in intrabarra del tester. Riferimento Python (solo long, costo 0,35): PF 1,45 (2004-2014), 1,89 (2014-2020), 1,77 (2021-2026), DD 6-8%.
**Varianti:** LONG (default) e LONGSHORT (con vendite) su tre finestre: **W2005_2014, W2015_2023, W2024_2026** (6 passate).
## Porte (scritte ora)
- **Conferma LONG:** in ciascuna delle tre finestre PF del tester >= 1,3, DD equity <= 15%, >= 25 operazioni; e almeno il 60% degli anni positivi. Se in una finestra il PF e' < 1,2: NON CONFERMATO.
- **Il test tiene o no rispetto a Python:** scarto del PF entro +-0,3 dal riferimento. Uno scarto maggiore va spiegato (differenza di dati/orario H4) prima di fidarsi.
- LONGSHORT serve solo come confronto: se le vendite peggiorano il PF (atteso), si resta sul solo long.
## Previsioni
- PF LONG >= 1,3 nella finestra 2005-2014: **55%**; 2015-2023: **60%**; 2024-2026: **55%**; in tutte e tre: **30%**.
- DD LONG <= 15% in tutte e tre: **65%**.
- LONGSHORT con PF inferiore a LONG in almeno due finestre su tre: **70%**.
- Primo lancio con errore di compilazione: **35%**.
## Limiti
Un solo mercato; rialzo strutturale dell'oro; costi 2005-2010 del tester dipendono dal feed BCM; nessun test a tick reali oltre al 2025 (da aggiungere se il risultato regge); regole FTMO e tenuta pluri-giornaliera non verificate; la scelta del rischio per operazione e' di Claudio.

## RISULTATI nel tester BCM (zip `GOLDENZOE.zip`, 6 passate, nessun errore di compilazione; dati in `GOLDENZOE_dati/`)
| Variante / finestra | Operazioni | PF tester | Rend. totale | DD equity | Anni positivi | **PF senza swap** | Swap totale |
|---|---|---|---|---|---|---|---|
| LONG 2005-2014 | 189 | **0,52** | -30,8% | 31,0% | 2 su 10 | **1,53** | -52.482 |
| LONG 2015-2023 | 154 | **1,02** | -0,1% | 19,0% | 4 su 9 | **1,66** | -33.615 |
| LONG 2024-2026 | 62 | **1,54** | +10,8% | 6,2% | 3 su 3 | **1,82** | -5.065 |
| LONGSHORT 2005-2014 | 329 | 0,73 | -29,0% | 31,6% | 2 su 10 | 1,22 | -46.419 |
| LONGSHORT 2015-2023 | 269 | 1,22 | +19,9% | 16,2% | 6 su 9 | 1,56 | -31.587 |
| LONGSHORT 2024-2026 | 93 | 1,11 | +3,0% | 11,2% | 2 su 3 | 1,25 | -4.539 |
**Verdetto con le porte scritte: NON CONFERMATO** (PF LONG 0,52 / 1,02 / 1,54 contro >= 1,3 in ogni finestra; DD 31% / 19% / 6% contro <= 15%). Previsioni: PF >= 1,3 in tutte e tre (30%) -> no; DD <= 15% in tutte (65%) -> no; LONGSHORT peggiore di LONG in almeno due finestre su tre (70%) -> **no (sbagliata: con lo swap del tester LONGSHORT e' migliore in 2 finestre su 3)**; errore di compilazione (35%) -> no.
**Diagnosi (dai deal dei report):** (1) **L'EA riproduce il simulatore Python:** senza swap il PF del tester e' 1,53 / 1,66 / 1,82 (Python: 1,45 / 1,89 / 1,77): stesso numero di operazioni (189 contro 188 nel 2005-14). (2) **Lo swap sui long azzera il vantaggio.** Il tester applica ai long un swap costante di circa **-75/-90 EUR per lotto per notte in tutti gli anni** (mediane per anno: -56..-97), cioe' il **swap attuale** del simbolo anche nel 2005, quando l'oro valeva 400 USD (e un lotto 40.000): sui primi anni il costo e' enormemente sovrastimato rispetto a quello storico. Con tenuta media di 4 giorni, lo swap pesa -52 mila EUR contro un lordo di +22 mila nel 2005-14; -33,6 mila contro +33,5 mila nel 2015-23; -5 mila contro +15,8 mila nel 2024-26. (3) **Sensibilita' al swap (PF LONG):** swap 0: 1,53 / 1,66 / 1,82; -20 EUR/lotto/notte: 1,17 / 1,49 / 1,74; -40: 0,88 / 1,32 / 1,67; -60: 0,66 / 1,17 / 1,60; -85: 0,45 / 1,01 / 1,51 (2005-14 / 2015-23 / 2024-26). Il PF resta >= 1,3 fino a circa -40 EUR/lotto/notte nel 2015-23 e fino a -85 nel 2024-26.
**Lettura:** il vantaggio lordo e' reale e riproducibile; **la domanda decisiva e' il swap dell'oro long sul conto dove si opera** (BCM e FTMO, tipo di conto, eventuale conto senza swap). Il 2024-2026 e' l'unica finestra con costi realistici di oggi e passa le porte (PF 1,54, DD 6,2%, 3 anni su 3), ma su sole 62 operazioni. Le finestre vecchie non sono valide per giudicare i costi (swap odierno applicato a prezzi di allora).
## PROSSIMI PASSI
(1) Leggere il swap vero dell'oro long (e short) sui conti: in MT5, Market Watch, XAUUSD, tasto destro, Specifiche: "Swap long", modalita' e giorno del triplo swap, su BCM e su FTMO; (2) rifare la simulazione Python con swap proporzionale al nozionale e ai tassi storici (carry reale per anno) per giudicare 2005-2023 in modo non distorto; (3) test a tick reali sul 2025.

## SWAP VERO DELL'ORO (zip `SWAPINFO_20261119_1528`, letto dai terminali; dati in `SWAPINFO_20261119/`)
| XAUUSD | modo | swap long | swap short | triplo swap | per 1 lotto (100 oz) a notte | in % annuo del valore (oro 3.710 USD) |
|---|---|---|---|---|---|---|
| **BCM** | punti | **-98,78** | **+19,28** (accredito) | mercoledi' | long -98,78 USD (circa -90 EUR); short +19,28 USD | long circa -9,7% annuo |
| **FTMO** | punti | **-56,28** | **-4,20** | mercoledi' | long -56,28 USD (circa -51 EUR); short -4,20 USD | long circa -5,5% annuo |
(1 punto = 0,01 USD; il tester BCM misurava circa -85 EUR/lotto/giorno: coincide con -98,78 USD.) Argento: BCM -29,32 / +2,73; FTMO -12,38 / -1,22. Indici BCM: interesse annuo -1,4% / -1,15%. `tick_value` risultava 0 (terminali senza quotazioni in tempo reale): le stime in EUR del CSV sono "n.d." per i modi in punti.
## Rivalutazione di GoldenZoe LONG con lo swap vero (analisi successiva, NON cambia il verdetto formale della porta)
| Finestra | Senza swap (PF / rend. / DD chiuso) | FTMO punti -56,28: PF / rend. / DD | FTMO 5,5% annuo del valore: PF / rend. / DD | BCM 9,7% annuo: PF |
|---|---|---|---|---|
| 2005-2014 | 1,53 / +21,7% / 4,9% | 0,77 / -12,2% / 16,3% | **1,31** / +13,6% / 8,0% | 1,16 |
| 2015-2023 | 1,66 / +33,5% / 10,2% | **1,26** / +14,6% / 13,9% | **1,48** / +25,7% / 11,8% | 1,36 |
| 2024-2026 | 1,82 / +15,8% / 4,6% | **1,64** / +13,0% / 4,8% | **1,67** / +13,4% / 4,8% | 1,56 |
LONGSHORT con swap FTMO: PF 0,81 / 1,30 / 1,15 (le vendite non aggiungono). DD = saldo dei trade chiusi (non flottante).
**Lettura:** (1) il swap di FTMO e' circa il 43% piu' basso di quello BCM; sulle vendite BCM accredita, FTMO addebita poco. (2) **Il costo in R dipende dalla distanza dello stop in dollari:** con l'oro a 3.700 e uno stop di circa 120 USD (3 ATR H4) il swap di una tenuta di 4 giorni vale circa 0,02 R; con l'oro a 400-1.200 e stop di 12-40 USD valeva fino a 0,2 R. **Il costante in punti applicato dal tester alle finestre vecchie e' quindi irrealistico** (ecco perche' il 2005-2014 "crolla"); per le condizioni di oggi il costo e' piccolo. (3) Con il swap FTMO e un costo proporzionale al valore (modello piu' realistico per gli anni passati) il PF LONG e' 1,31 / 1,48 / 1,67 nelle tre finestre. (4) Restano: test a tick reali 2025, DD flottante, regole di rischio FTMO, correlazione con gli EA di Wim, forward demo.

## TEST A TICK REALI (riga `RIGA_GOLDENZOE_TICK_BCM.txt`; criteri scritti PRIMA dei numeri)
Finestra: dal 01/08/2024 fino ai mesi consecutivi di tick reali BCM disponibili (la riga misura la copertura e si ferma se sono meno di 12 mesi; massimo 31/10/2026). 3 passate: **LONG con Modello 1** (barre da 1 minuto), **LONG con Modello 4** (tick reali), **LONGSHORT con Modello 4**. Il DD del tester e' sull'**equity (flottante)**. Swap del tester = quello BCM (-98,78 punti; piu' pesante di FTMO: stima prudente).
**Porte:** LONG a tick: >= 20 operazioni, PF >= 1,3, DD equity <= 15%; scarto del PF tra Modello 4 e Modello 1 entro +-0,3 (altrimenti le barre da 1 minuto non sono una buona approssimazione per questo EA).
**Previsioni:** PF LONG a tick >= 1,3: **60%**; scarto |PF M4 - PF M1| <= 0,3: **75%**; DD equity LONG <= 15%: **85%**; LONGSHORT a tick con PF inferiore a LONG: **55%**.
**Limite:** circa 2 anni di finestra (poche decine di operazioni): conferma la qualita' dell'esecuzione, non la persistenza del vantaggio.
