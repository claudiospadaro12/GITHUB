# UBS U1 pilota: il max DD a 0,01 lotti dichiarato nei set, misurato su BCM (10/11/2026)

Criteri e previsioni U1a-U1g scritti PRIMA: `UBS_U1_CRITERI_2026-11-09.md`. Dati: `ANNO_ORO_GRADINI_UBSU1_20261109_2258.zip` (6 passate), parser `D160_dati/parse_cartelle.py`, dati `D160_dati/ubsu1.json`. 6 set oro di Wim in formato UBS (pacchetto `Ultimate-Breakout-System-Set-Files.zip`) **cosi come consegnati** (`Risk=0`, `StartLots=0,1`, `AdjustLotsizeToVariableValues=true`), EA `Ultimate_Breakout_EA_WSC_V9.5.ex5` (cartella WIM), XAUUSD, deposito 100.000 EUR, Modello 1, **una passata continua 2013-01-01 -> 2026-01-01** per set, BCM, solo tester.

## Validita
**6 passate su 6 valide**: stato OK, qualita storico 98% (barre da 1 minuto, 18 milioni di tick generati), deposito 100.000, zero stop out e zero righe "no money", **licenza accettata nel tester** (giornale: "License found! EA starting up"), **i set sono stati caricati davvero**: il report mostra `HistoricalMaxDD`, `StartLots=0,1`, `Risk=0`, `ForceSymbol=XAUUSD` e il magic di ogni set (38, 60, 52, 110, 60, 57 come nel file). Durata di una passata: 1,5-3 minuti (13 anni su D1, H4 e H1), molto meno di quanto stimato.

## Risultato: DD equity BCM a 0,1 lotti diviso 10, contro `HistoricalMaxDD` del set
R = DD BCM (a 0,01) / dichiarato. In EUR il DD e quello del report; in USD si converte a 1,15 USD per EUR (cambio medio 2013-2025, **ipotesi mia**: l'effetto sul verdetto e piccolo).
| Set | DD dichiarato ($ a 0,01) | DD equity BCM a 0,1 lotti | DD BCM a 0,01 | **R** (EUR / USD) | Esito (EUR / USD) | Netto 13 anni | Operazioni | Lotto max | Peggior giorno |
|---|---|---|---|---|---|---|---|---|---|
| Goldbot One dailyA (D1) | 38 | 326 EUR (0.32%) | 32.6 EUR = 37.5 USD | **0.86** / 0.99 | CONFERMA / CONFERMA | 4.325 | 358 | 0.13 | -100 |
| Gold Trade Pro a (D1) | 60 | 1.315 EUR (1.22%) | 131.5 EUR = 151.2 USD | **2.19** / 2.52 | DIVERSO / DIVERSO | 15.433 | 911 | 0.3 | -552 |
| Gold Phantom strat1 (D1) | 57 | 426 EUR (0.42%) | 42.6 EUR = 49.0 USD | **0.75** / 0.86 | DIFFERENTE / CONFERMA | 6.148 | 573 | 0.09 | -125 |
| Reaper strategy1 (D1) | 60 | 2.397 EUR (2.33%) | 239.7 EUR = 275.7 USD | **4.00** / 4.59 | DIVERSO / DIVERSO | 5.016 | 423 | 0.18 | -1.434 |
| Reaper strategy4 (H4) | 52 | 827 EUR (0.78%) | 82.7 EUR = 95.1 USD | **1.59** / 1.83 | DIVERSO / DIVERSO | 14.143 | 763 | 0.15 | -163 |
| Reaper strategy5 (H1) | 110 | 1.503 EUR (1.48%) | 150.3 EUR = 172.8 USD | **1.37** / 1.57 | DIFFERENTE / DIVERSO | 13.713 | 1770 | 0.24 | -713 |

## Classificazione (regola scritta: CONFERMA |R-1| <= 25%, DIFFERENTE fino a 50%, DIVERSO oltre)
- **CONFERMA**: **Goldbot dailyA** (R 0,86 in EUR, 0,99 in USD) in entrambe le valute; **Phantom strat1** (R 0,75 in EUR, 0,86 in USD) solo in USD (in EUR e DIFFERENTE per un soffio, 0,75). Per questi due il metodo (DD a 0,1 lotti diviso 10) riproduce il numero di Wim: l'unita assunta e giusta e i dati BCM sono compatibili con quelli del suo broker.
- **DIVERSO (o al limite): 4 set su 6**, tutti **piu alti del dichiarato**: Reaper strategy1 (R 4,0-4,6), Gold Trade Pro a (2,2-2,5), Reaper strategy4 H4 (1,6-1,8), Reaper strategy5 H1 (1,4-1,6, DIFFERENTE in EUR, DIVERSO in USD).
- **Nessun set ha un DD BCM sotto il dichiarato di piu del 25%**: dove cambia, il rischio reale e **maggiore** di quello scritto nel set.

## Previsioni U1a-U1g contro i risultati
| # | Previsione | Esito |
|---|---|---|
| U1a | 6 passate valide (licenza e caricamento): 65% | **Vero** |
| U1b | >= 4 set su 6 CONFERMA: 35%; >= 2 DIVERSO: 25% | **Falso** (1 su 6 in EUR, 2 in USD); **vero** (3 DIVERSO in EUR, 4 in USD) |
| U1c | DD BCM piu alto del dichiarato in >= 4 set su 6: 60% | **Vero** (4 su 6) |
| U1d | I set giornalieri piu vicini al dichiarato dello H1: 60% | **Falso**: Goldbot e Phantom (giornalieri) combaciano, ma Reaper strategy1 e Gold Trade Pro (giornalieri) sono i piu lontani |
| U1e | strategy5 H1 DIVERSO: 40% | **Mezzo**: DIFFERENTE in EUR (1,37), DIVERSO in USD (1,58) |
| U1f | R circa 10 o 0,1 su tutti (unita diversa): 15% | **Falso**: R fra 0,75 e 4,6 |
| U1g | licenza o caricamento falliscono: 25% | **Falso** |

## Cosa significa
- **La pipeline UBS funziona nel tester** (licenza, set, passate di 2 minuti): si puo estendere senza problemi.
- **Il numero scritto nel set non e affidabile da solo**: su BCM, 4 set su 6 hanno un DD fino a 4,6 volte piu alto. Con `MaxRiskPerStrategy` calcolato su quel numero, il rischio reale supererebbe quello nominale, soprattutto sul Reaper strategy1 e sul Gold Trade Pro.
- **Perche i set differiscono: NON VERIFICATO.** Ipotesi, nessuna testata: periodo e dati di Wim diversi; filtri (news, fake-out, spread) accesi nella misura di Wim e spenti nel set; `AdjustLotsizeToVariableValues` e `DefaultValue` che fanno variare il lotto con il prezzo (lotto massimo 0,09-0,30 invece di 0,1 fisso), per cui DD(0,1)/10 non e esattamente il DD a 0,01; il Reaper strategy1 ha un giorno realizzato a -1.434 EUR (2013, probabilmente il crollo dell'oro) che il DD dichiarato a 0,01 lotti non puo contenere.
- **Il test e a una sola passata** (i set hanno Randomization 0, quindi deterministico).

## Limiti
Un solo periodo (2013-2025; quello di Wim e noto solo come "2004-2025" nel video); Modello 1; cambio EUR/USD ipotesi; lotti con variazione col prezzo; nessun input di rischio provato (`Risk` diverso da 0 non testato); manuale non ancora letto. Nessun giudizio su acquisti, taglie o lotti.
