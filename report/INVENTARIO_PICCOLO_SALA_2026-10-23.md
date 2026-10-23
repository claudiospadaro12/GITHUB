# Inventario delle sedie nostre sul demo piccolo 50503392 e priorita' per la sala del consiglio (23/10/2026)

**Natura: LETTURA. Nessun EA, preset, sedia, terminale o conto toccato; nessun numero nuovo misurato.** Richiesta di Claudio: rianalizzare con la sala del consiglio tutti gli EA del piccolo "per provare a migliorarli". Questo documento e' il passo 0: cosa c'e', in che stato, che prove abbiamo, in che ordine guardarlo.

**Fonti** (tutte sul branch `lavoro`): `CODA_01` e `CODA_06` del 23/10 03:30 (stato PRIMA del ripristino di oggi; **FATTO**), `report/RIPRISTINO_DEMO_QUADRO_2026-10-23.md` (le 16 sedie su indici/225JPY rimesse oggi), `data/statements/trades_auto.csv` (per-posizione del piccolo e dei Market, **fino al 22/10 18:11**, attribuzione **per magic**: **FATTO**). Le statistiche forward sono **DERIVATE** da quel file: netto = profitto + commissioni + swap, PF = somma dei guadagni / somma delle perdite, dal 29/07. Il magic 770611 e' lo stesso per ORB sul Dow e ORB sull'argento: il file non li separa per simbolo (nel file compare solo U30USD).
**Fuori ambito:** i circa 30 EA del Market attaccati al piccolo (restano com'e'; regola: solo i NOSTRI), TradeExporter, SpreadLogger, EMA200_Ombra (non aprono ordini).

## 1. Le sedie (42 combinazioni EA-simbolo)
| Famiglia | EA | Simbolo/TF | Magic | Rischio % | Stato | Binario | Guardian nel codice | Pos. forward dal 29/07 | Netto EUR | PF forward |
|---|---|---|---|---|---|---|---|---:|---:|---:|
| Aperture indici | DAX Apertura EU (solo long) | D30EUR M5 | 770101 | 1,0 (100k 0,65) | RIPRISTINATA 23/10 | .ex5 08/08, sorgente toppato 19/09 (F7 da premere) | no | 33 | -400 | 0.41 |
| Aperture indici | Dow Apertura US (solo long) | U30USD M5 | 770202 | 1,0 | RIPRISTINATA 23/10 | .ex5 08/08, sorgente toppato 19/09 (F7) | no | 4 | +0 | 1.02 |
| Aperture indici | Nasdaq Apertura US (solo short) | NASUSD M15 | 770250 | 0,35 | RIPRISTINATA 23/10 | .ex5 08/08 (F7) | no | 2 | +8 | n/d |
| Aperture indici | MaxMin DAX Short Ott. | D30EUR M15 | 770411 | 1,0 | RIPRISTINATA 23/10 | .ex5 18/08 | no | 5 | +156 | n/d |
| Aperture indici | ORB Ottimizzato (Dow) | U30USD M5 | 770611 | 1,0 | RIPRISTINATA 23/10 | .ex5 03/09 v1.04 | SI | 8 | -209 | 0.27 |
| Aperture indici | ORB Ottimizzato (argento) | XAGUSD H4 | 770611 | 1,0 | IN CAMPO | .ex5 03/09 v1.04 | SI | 8 | -209 | 0.27 |
| Trend/swing indici e Nikkei | SuperWave DOW H1 Ott. | U30USD H1 | 770511 | 1,0 | RIPRISTINATA | .ex5 06/08 | no | 14 | +334 | 16.29 |
| Trend/swing indici e Nikkei | SuperWave U30 H4 | U30USD H4 | 770531 | 1,0 | RIPRISTINATA | .ex5 06/08 | no | 14 | -42 | 0.81 |
| Trend/swing indici e Nikkei | SupRev DAX H4 Ott. | D30EUR H4 | 970912 | 1,0 | RIPRISTINATA | .ex5 06/08 | no | 0 | - | - |
| Trend/swing indici e Nikkei | SupRev NAS H1 Ott. | NASUSD H1 | 970913 | 1,0 | RIPRISTINATA | .ex5 06/08 | no | 9 | +53 | 2.66 |
| Trend/swing indici e Nikkei | SupertrendReversal 225JPY | 225JPY H2 | 770924 | 1,0 | RIPRISTINATA | .ex5 08/08 | no | 5 | +3 | 1.08 |
| Trend/swing indici e Nikkei | EMA200 Dow | U30USD H1 | 771531 | 0,65 | RIPRISTINATA (da attaccare a mano) | .ex5 06/08 | no | 23 | -55 | 0.68 |
| Trend/swing indici e Nikkei | PTE Dow | U30USD H1 | 771321 | 1,0 | RIPRISTINATA | .ex5 06/08 | no | 1 | +4 | n/d |
| Gap e punte | GapFill Dow | U30USD H1 | 772234 | 1,0 | RIPRISTINATA | .ex5 13/08 | no | 1 | -51 | 0.00 |
| Gap e punte | GapFill 225JPY | 225JPY H1 | 772235 | 1,0 | RIPRISTINATA | .ex5 13/08 | no | 2 | +38 | n/d |
| Gap e punte | PunteLarry Dow | U30USD H1 | 772341 | 1,0 | RIPRISTINATA | .ex5 13/08 | no | 5 | -2 | 0.98 |
| Gap e punte | GapContinuation 225JPY | 225JPY M1 | 774101 | n/d | RIPRISTINATA | .ex5 16/08 | no | 4 | -138 | 0.12 |
| Forex/oro in campo | BreakingBand GBPUSD | GBPUSD H1 | 772161 | 1,0 | IN CAMPO | .ex5 13/08 | no | 3 | +43 | n/d |
| Forex/oro in campo | BreakingBand EURUSD | EURUSD H1 | 772162 | 1,0 | IN CAMPO | .ex5 13/08 | no | 2 | -43 | 0.18 |
| Forex/oro in campo | BreakingBand AUDUSD | AUDUSD H1 | 772163 | 1,0 | IN CAMPO | .ex5 13/08 | no | 1 | +12 | n/d |
| Forex/oro in campo | GapFill GBPUSD | GBPUSD H1 | 772231 | 1,0 | IN CAMPO | .ex5 13/08 | no | 0 | - | - |
| Forex/oro in campo | GapFill EURUSD | EURUSD H1 | 772232 | 1,0 | IN CAMPO | .ex5 13/08 | no | 1 | +23 | n/d |
| Forex/oro in campo | GapFill AUDUSD | AUDUSD H1 | 772233 | 1,0 | IN CAMPO | .ex5 13/08 | no | 3 | -86 | 0.24 |
| Forex/oro in campo | PunteLarry EURAUD | EURAUD H1 | 772342 | 0,5 | IN CAMPO | .ex5 13/08 | no | 5 | +2 | 1.03 |
| Forex/oro in campo | PunteLarry XAUUSD (solo long) | XAUUSD H1 | 772343 | 0,3 | IN CAMPO | .ex5 13/08 | no | 3 | +44 | 1.44 |
| Forex/oro in campo | PunteLarry GBPJPY (solo long) | GBPJPY H1 | 772344 | 1,0 | IN CAMPO | .ex5 13/08 | no | 3 | -94 | 0.04 |
| Forex/oro in campo | PunteLarry GBPUSD (solo short) | GBPUSD H1 | 772345 | 1,0 | IN CAMPO | .ex5 13/08 | no | 4 | +56 | 16.71 |
| Forex/oro in campo | PunteLarry EURCAD (solo long) | EURCAD H1 | 772346 | 1,0 | IN CAMPO | .ex5 13/08 | no | 1 | +13 | n/d |
| Forex/oro in campo | CostToCost EURJPY (solo long) | EURJPY H4 | 772361 | 0,65 | IN CAMPO | .ex5 13/08 | no | 14 | -282 | 0.10 |
| Forex/oro in campo | CostToCost GBPCAD (solo long) | GBPCAD H4 | 772362 | 0,25 | IN CAMPO | .ex5 13/08 | no | 11 | +91 | 1.98 |
| Forex/oro in campo | EasyTrend CHFJPY | CHFJPY H1 | 772421 | 0,3 | IN CAMPO | .ex5 14/08 | no | 10 | -52 | 0.65 |
| Forex/oro in campo | EasyTrend GBPUSD | GBPUSD H1 | 772422 | 0,5 | IN CAMPO | .ex5 14/08 | no | 9 | +219 | 3.03 |
| Forex/oro in campo | PTE GBPUSD (sedia 1) | GBPUSD H1 | 771332 | 0,5 | IN CAMPO | .ex5 06/08 | no | 1 | +7 | n/d |
| Forex/oro in campo | PTE GBPUSD (sedia 2) | GBPUSD H1 | 771322 | 0,5 | IN CAMPO | .ex5 06/08 | no | 2 | +35 | n/d |
| Forex/oro in campo | MaxMinNotte oro | XAUUSD M15 | 770402 | 0,5 | IN CAMPO | .ex5 06/08 | no | 16 | +87 | 1.56 |
| Forex/oro in campo | EMA200 Ottimizzato | AUDCHF H4 | 971501 | 0,25 | IN CAMPO | .ex5 06/08 | no | 26 | -2 | 0.99 |
| Forex/oro in campo | SupertrendReversal Ott. oro | XAUUSD H4 | 970901 | 1,0 | IN CAMPO | .ex5 06/08 | no | 3 | -21 | 0.00 |
| Forex/oro in campo | PostNews NFP | USDJPY M5 | 771203 | 1,3 | IN CAMPO | .ex5 04/09 | SI (fail-open) | 1 | +37 | n/d |
| Forex/oro in campo | PostNews ECB | EURJPY M5 | 771201 | 1,3 | IN CAMPO | .ex5 04/09 | SI (fail-open) | 1 | -83 | 0.00 |
| Forex/oro in campo | PostNews FOMC | EURUSD M5 | 771202 | 1,3 | IN CAMPO | .ex5 04/09 | SI (fail-open) | 1 | +143 | n/d |
| Bulge | Bulge viola/BLU | GBPUSD H4 (22 cross) | 772700 | 0,8 x 4 | IN CAMPO | .ex5 29/09 v5.20 | SI (fail-open) | 139 | -315 | 0.77 |
| Bulge | BulgeAzzurra | EURGBP H1 (33 simboli) | 774500 | 0,8 x 4 | IN CAMPO | .ex5 09/10 v5.20 | SI (fail-open) | 36 | -104 | 0.77 |

Note di lettura: "Binario" = data del `.ex5` compilato (CODA_06); **"Guardian nel codice = no" significa che il binario non chiama la guardia**: sul piccolo non c'e' comunque un Guardian attaccato, quindi per queste sedie il tetto di rischio non esiste. "fail-open" = il codice chiama la guardia ma, senza le variabili del canale, l'ordine passa (`PIANO_SCHIERAMENTO_PICCOLO_DEMO_2026-10-11.md`, INFERITO dal codice). Le sedie "RIPRISTINATA" sono state rimesse da Claudio oggi con gli script di ripristino; la loro prima attivita' forward post-ripristino non e' ancora nei dati (ultimo dato 22/10).

## 2. Cosa dicono i numeri forward (e quanto poco)
- **Campione minuscolo:** su 42 sedie, **solo 3 hanno almeno 30 posizioni** dal 29/07 (DAX Apertura 33, Bulge viola 139, Azzurra 36); **29 ne hanno meno di 10**, 2 nessuna. Con questi numeri il forward **non permette di dire che un EA e' migliore o peggiore di un altro**; serve solo a trovare comportamenti anomali.
- **Anomalie da guardare, non verdetti:** CostToCost EURJPY 772361 (14 posizioni, circa -282, PF 0,10); DAX Apertura 770101 (33 posizioni, circa -400, PF 0,41, fino al 22/09: **CORREZIONE del giro 1 - sono 17 posizioni del vecchio BREAKOUT ritirato il 14/08, circa -575, e 16 RETEST BUY, circa +175, PF 13,5; il 0,41 non misura la sedia attuale**, vedi `report/SALA_GIRO1_APERTURE_INDICI_2026-10-23.md`); ORB sul Dow 770611 (8 posizioni, circa -209, PF 0,27, fino al 03/09) [precedono il binario v1.04 del 03/09]; EMA200 Dow 771531 (23 posizioni, circa -55, PF 0,68); GapCont 774101 (4 posizioni, -138); le due Bulge in perdita (-316 su 139; -104 su 36).
- **Positive con campione minimo:** SuperWave Dow H1 770511 (14 posizioni, circa +334), EasyTrend GBPUSD 772422 (9, circa +219), MaxMin DAX 770411 (5, +156): troppo poche per concludere.
- **La mano pesa piu' degli EA:** nel file le posizioni a magic 0 (manuali) del 01-08/10 sono 16 e circa -961, contro qualche centinaio degli EA nostri (gia' segnalato in `PIANO_SCHIERAMENTO` r.3).

## 3. Problemi strutturali comuni (non sono questioni di parametri)
1. **Binari vecchi:** 14 famiglie di EA hanno un `.ex5` del 06-18 agosto, **prima** del fix hedging (toppa del 19/09) e senza Guardian. Per DAX, Dow e Nasdaq i sorgenti sono gia' toppati ma il `.ex5` no (F7 mai premuto): finche' non si ricompila, **quello che gira non e' quello che analizziamo**.
2. **Nessun tetto di rischio sul piccolo** per le sedie senza Guardian; 11+ sedie su indici/oro insieme ricreano la correlazione di prima.
3. **Orologio:** DAX e MaxMin DAX dal 26/10, Dow/ORB/Nasdaq dal 02/11 armano un'ora prima della cash se non cambiano gli orari (decisione `cash`/`prima` ancora tua).
4. **Magic condiviso 770611** tra ORB Dow (ripristinata) e ORB argento (in campo): su hedging con selezione per simbolo e magic non si pestano, ma le statistiche per magic li mescolano.
5. **Due sedie PTE sullo stesso GBPUSD H1** (771332 e 771322) con lo stesso rischio: da capire se sono volute.

## 4. Ordine proposto per la sala (per Claudio da approvare)
| Giro | Gruppo | Perche' prima | Domanda tipo (criteri scritti PRIMA) |
|---|---|---|---|
| 1 | **Aperture indici** (DAX, Dow, Nasdaq, MaxMin DAX, ORB Dow) | orologio che cambia fra 3 e 10 giorni; gia' revisionate il 23/10 (sala DAX/Dow/ORB), ORB: R283-R285 hanno misurato la regola di EMILIANO, NON la cella in campo (correzione del giro 1); binari da ricompilare | quali pezzi servono davvero (come R284/R285) e cosa non ha prova |
| 2 | **Forex e oro in campo** (BreakingBand, GapFill, PunteLarry, CostToCost, EasyTrend, PTE, MaxMin oro, EMA200 Ott., SupertrendReversal oro) | sono le sedie con piu' posizioni vive; tutte con binario vecchio e senza Guardian; CostToCost EURJPY da spiegare | il codice fa quello che l'intestazione promette? c'e' un difetto come quello hedging? |
| 3 | **Trend/swing su indici e 225JPY** (SuperWave x2, SupRev x2, SupertrendReversal 225JPY, EMA200 Dow, PTE Dow) | non dipendono dall'orologio; base dati OHLC lunga disponibile solo per alcuni | una modifica alla volta, nessuna taratura di soglia sul solo regime 2024-26 |
| 4 | **Gap e punte** (GapFill x2, PunteLarry Dow, GapContinuation) | campione forward minuscolo | che cosa misurare prima di toccare |
| 5 | **Bulge e Azzurra, PostNews** | hanno gia' un loro ciclo di studio e documenti; PostNews dipende dal calendario notizie | non dipendono da questo giro: si lasciano ai loro documenti |

## 5. Regole per ogni giro (proposte)
Diagnosi prima delle ipotesi; **una domanda per EA** con criteri scritti prima dei numeri; mai sostituire l'originale (variante con magic diverso, in parallelo); nessuna taratura di soglie con un solo regime nel feed BCM; rischio e taglie restano di Claudio; ogni riga di lancio passa da `controlla_riga.py`; nessun test sul VPS o sui conti.

## 6. Limiti di questo inventario
Lo stato delle sedie e' quello di stanotte alle 03:30 piu' il ripristino di oggi dichiarato da Claudio, **non** una foto fresca del profilo; il forward si ferma al 22/10; l'attribuzione per magic mescola i simboli di una stessa sedia; la qualita' dei set ripristinati non e' stata riverificata sul terminale.
