# UBS U1b: il DD a 0,01 lotti su BCM per i 37 set oro, due periodi (11/11/2026)

Criteri e previsioni scritti PRIMA: `UBS_U1B_CRITERI_2026-11-10.md` (disegno rivisto la sera del 10/11, prima di lanciare). Dati: 30 zip `WIM_01..30` (cartella `ANNO_ORO_GRADINI_UBSU1B_20261110_2259`), script `D160_dati/analisi_ubs_u1b.py`, dati `D160_dati/ubsu1b.json` e `ubsu1b_righe.json`. EA `Ultimate_Breakout_EA_WSC_V9.5`, XAUUSD, BCM (demo 50503392 del PC di backtest), Modello 1, deposito 100.000 EUR, set cosi come consegnati (lotto fisso 0,1). R = (DD equity del report / 10) / `HistoricalMaxDD` del set; USD = EUR x 1,15 (ipotesi). I report completi (.htm, fino a 85 MB) non sono stati letti: i numeri vengono dai REFERTO di ogni passata.

## Validita
- **68 passate fatte, 65 valide** (stato OK, qualita >= 98%, licenza accettata, nessuno stop out e nessun "no money", in tutte). **9 passate KO**: le **H1 sul periodo lungo 2005-2025** (Reaper strategy5-9 e Phantom strat6-9): "barre generate 122.269 >= 100.000: finestra TRONCATA dal tetto del tester". Il tester ha un tetto di 100.000 barre: le H1 su 21 anni non ci stanno. **Per quei 9 set il periodo lungo NON esiste**; restano la (B) 2013-2025 (valida, 37 su 37). Le passate in (A) valide sono **28 su 37**.
- Tempo: dalle 22:59 del 10/11 alle 03:33 dell'11/11, **4,56 ore**; somma delle durate 4,27 ore.
- **Scoperta sui set**: i set "Gold Phantom (daily)" `Gold_a/b/c` sono **la stessa strategia** di `Gold_Phantom_strat1/2/3` (stessi parametri, differisce solo `HistoricalMaxDD`: **30 contro 57, 30 contro 50, 50 contro 99**). Il DD misurato su BCM e identico (42,6 / 38,0 / 66,2). Cioe Wim ha scritto per la stessa strategia due numeri che differiscono quasi del doppio.

## Risultato per set (DD a 0,01 lotti in EUR e R = BCM / dichiarato; classi: CONFERMA |R-1| <= 25%, DIFFERENTE <= 50%, DIVERSO oltre)
| Set | Dichiarato $ | A 2005-2025: DD EUR / R (EUR / USD) / classe | B 2013-2025: DD EUR / R (EUR / USD) / classe | R(A)/R(B) |
|---|---|---|---|---|
| Phantom daily Gold_a | 30 | 43 | 1.42 / 1.63 | DIFFERENTE | 43 | 1.42 / 1.63 | DIFFERENTE | STABILE |
| Phantom daily Gold_b | 30 | 38 | 1.27 / 1.46 | DIFFERENTE | 27 | 0.91 / 1.05 | CONFERMA | STABILE |
| Phantom daily Gold_c | 50 | 66 | 1.32 / 1.52 | DIFFERENTE | 52 | 1.04 / 1.19 | CONFERMA | STABILE |
| GR_s1_D1 | 60 | 350 | 5.83 / 6.70 | DIVERSO | 240 | 4.00 / 4.59 | DIVERSO | STABILE |
| GR_s2_D1 | 30 | 40 | 1.34 / 1.54 | DIFFERENTE | 40 | 1.34 / 1.54 | DIFFERENTE | STABILE |
| GR_s3_D1 | 35 | 52 | 1.50 / 1.72 | DIFFERENTE | 52 | 1.50 / 1.72 | DIFFERENTE | STABILE |
| GR_s4_H4 | 52 | 83 | 1.59 / 1.83 | DIVERSO | 83 | 1.59 / 1.83 | DIVERSO | STABILE |
| GR_s5_H1 | 110 | KO (finestra troncata) | - | - | 150 | 1.37 / 1.57 | DIFFERENTE | - |
| GR_s6_H1 | 140 | KO (finestra troncata) | - | - | 183 | 1.31 / 1.50 | DIFFERENTE | - |
| GR_s7_H1 | 90 | KO (finestra troncata) | - | - | 134 | 1.49 / 1.71 | DIFFERENTE | - |
| GR_s8_H1 | 130 | KO (finestra troncata) | - | - | 150 | 1.15 / 1.32 | CONFERMA | - |
| GR_s9_H1 | 700 | KO (finestra troncata) | - | - | 608 | 0.87 / 1.00 | CONFERMA | - |
| PH_strat1 | 57 | 43 | 0.75 / 0.86 | DIFFERENTE | 43 | 0.75 / 0.86 | DIFFERENTE | STABILE |
| PH_strat2 | 50 | 38 | 0.76 / 0.87 | CONFERMA | 27 | 0.55 / 0.63 | DIFFERENTE | STABILE |
| PH_strat3 | 99 | 66 | 0.67 / 0.77 | DIFFERENTE | 52 | 0.52 / 0.60 | DIFFERENTE | STABILE |
| PH_strat4 | 146 | 73 | 0.50 / 0.57 | DIVERSO | 73 | 0.50 / 0.57 | DIVERSO | STABILE |
| PH_strat5 | 283 | 181 | 0.64 / 0.74 | DIFFERENTE | 162 | 0.57 / 0.66 | DIFFERENTE | STABILE |
| PH_strat6 | 476 | KO (finestra troncata) | - | - | 136 | 0.29 / 0.33 | DIVERSO | - |
| PH_strat7 | 400 | KO (finestra troncata) | - | - | 159 | 0.40 / 0.46 | DIVERSO | - |
| PH_strat8 | 720 | KO (finestra troncata) | - | - | 199 | 0.28 / 0.32 | DIVERSO | - |
| PH_strat9 | 600 | KO (finestra troncata) | - | - | 235 | 0.39 / 0.45 | DIVERSO | - |
| GB_dailyA | 38 | 33 | 0.86 / 0.99 | CONFERMA | 33 | 0.86 / 0.99 | CONFERMA | STABILE |
| GB_dailyB | 75 | 123 | 1.64 / 1.89 | DIVERSO | 123 | 1.64 / 1.89 | DIVERSO | STABILE |
| GB_dailyC | 27 | 64 | 2.37 / 2.73 | DIVERSO | 17 | 0.62 / 0.71 | DIFFERENTE | INSTABILE |
| GB_dailyD | 38 | 61 | 1.62 / 1.86 | DIVERSO | 61 | 1.62 / 1.86 | DIVERSO | STABILE |
| GB_dailyE | 25 | 91 | 3.63 / 4.17 | DIVERSO | 91 | 3.63 / 4.17 | DIVERSO | STABILE |
| GB_dailyH | 69 | 108 | 1.57 / 1.81 | DIVERSO | 108 | 1.57 / 1.81 | DIVERSO | STABILE |
| GB_dailyI | 83 | 87 | 1.05 / 1.21 | CONFERMA | 87 | 1.05 / 1.21 | CONFERMA | STABILE |
| GB_dailyK | 104 | 115 | 1.10 / 1.27 | CONFERMA | 115 | 1.10 / 1.27 | CONFERMA | STABILE |
| GTP_H4b | 90 | 106 | 1.18 / 1.36 | CONFERMA | 106 | 1.18 / 1.36 | CONFERMA | STABILE |
| GTP_E | 40 | 45 | 1.13 / 1.30 | CONFERMA | 41 | 1.03 / 1.19 | CONFERMA | STABILE |
| GTP_F | 60 | 99 | 1.65 / 1.90 | DIVERSO | 99 | 1.65 / 1.90 | DIVERSO | STABILE |
| GTP_G | 40 | 66 | 1.66 / 1.91 | DIVERSO | 66 | 1.66 / 1.91 | DIVERSO | STABILE |
| GTP_H | 50 | 86 | 1.72 / 1.98 | DIVERSO | 86 | 1.72 / 1.98 | DIVERSO | STABILE |
| GTP_a | 60 | 132 | 2.19 / 2.52 | DIVERSO | 132 | 2.19 / 2.52 | DIVERSO | STABILE |
| GTP_c | 40 | 66 | 1.65 / 1.90 | DIVERSO | 66 | 1.65 / 1.90 | DIVERSO | STABILE |
| GTP_d | 100 | 91 | 0.91 / 1.04 | CONFERMA | 91 | 0.91 / 1.04 | CONFERMA | STABILE |

(A) = periodo lungo 2005-2025. Per i 6 set del pilota la (B) viene dal pilota del 10/11. Per i set con A = B il DD massimo cade dopo il 2013 (2013, 2020, 2025).

## Riepilogo
- **(A) 28 set validi**: R mediano **1,38**; **21 su 28 con R > 1** (DD BCM piu alto del dichiarato); **7 CONFERMA, 8 DIFFERENTE, 13 DIVERSO**. Piu alti: Reaper strategy1 5,83; Goldbot dailyE 3,63; dailyC 2,37; Gold Trade Pro a 2,19.
- **(B) 37 set**: R mediano 1,15; 23 con R > 1; 10 CONFERMA, 11 DIFFERENTE, 16 DIVERSO. Con il periodo lungo dove esiste e la finestra (B) altrove: 25 su 37 con R > 1, R mediano 1,31.
- **Per EA (R mediano, A o B)**: Reaper 1,54 (A, 4 set) / 1,37 (B, 9 set); Goldbot 1,59 / 1,34; Gold Trade Pro 1,65 / 1,65; **Phantom 0,75 / 0,54**. Per i Goldbot e i Gold Trade Pro il rischio reale e di norma **piu alto** di quello nominale (fino a 3,6 volte); per il Phantom e **piu basso**: i suoi set H4 e H1 dichiarano 146-720 $ contro 73-235 $ misurati (R 0,28-0,57).
- **Per timeframe (B)**: D1 R mediano 1,38; H4 0,88; H1 0,87.
- **Stabilita (A contro B, 28 set)**: 27 STABILE, 1 INSTABILE (Goldbot dailyC: R 2,37 su 21 anni contro 0,62 dal 2013: le prime annate gli aggiungono un DD vero).

## Previsioni contro risultati
| # | Previsione | Esito |
|---|---|---|
| U1b-1 | >= 60 passate su 68 valide: 80% (e >= 30 (A) su 37: 75%) | **Vero** (65) / **Falso** (28 (A): le H1 sono troncate dal tetto di 100.000 barre) |
| U1b-2 | >= 65% dei 37 set con R > 1: 70% | **Vero, per poco** (25 su 37 = 68%) |
| U1b-3 | R(A) mediano fra 1,2 e 2,0: 50% | **Vero** (1,38) |
| U1b-4 | >= 50% CONFERMA o DIFFERENTE in (A): 45% | **Vero, per poco** (15 su 28 = 54%) |
| U1b-5 | H1 con R mediano piu alto dei D1: 55% | **Falso** (H1 0,87 contro D1 1,38) |
| U1b-6 | R(A) >= 1,25 x R(B) in >= 20% dei set: 45% | **Vero, per poco** (6 su 28 = 21%) |
| U1b-7 | >= 60% STABILE: 50% | **Vero** (27 su 28) |
| U1b-8 | DD dichiarato <= 40 $ con R piu alto di >= 100 $: 60% | **Vero** (A: 1,50 contro 0,77; B: 1,42 contro 0,72) |
| U1b-9 | Fine in meno di 4,5 ore: 70% | **Falso, per poco** (4,56 ore) |

## Regola di uso scritta prima: quale delle due
**Il 54% dei set (A) e CONFERMA o DIFFERENTE: sotto il 60% richiesto.** Quindi, per le regole fissate ieri sera, **non si usa il DD dichiarato**: per ogni set si usa il **DD misurato su BCM** (`DD_BCM = dichiarato x R(A)`, cioe il DD a 0,01 lotti in tabella, colonna "A" se esiste, altrimenti "B" con un margine da decidere). Un set INSTABILE (Goldbot dailyC) non entra in un portafoglio senza un test dedicato.

## Cosa significa e cosa NON significa
- **Significa**: su BCM, per molti set il rischio nominale di UBS (`MaxRiskPerStrategy` calcolato sul DD scritto nel set) e sbagliato, in entrambe le direzioni; per Goldbot, Gold Trade Pro e Reaper giornalieri spesso **sottostimato**. Va ricalibrato per set.
- **NON significa** che i set siano cattivi o i dati BCM peggiori: la spiegazione piu semplice e il dato storico (Wim usa MetaQuotes) e il periodo; **non e stata testata** (U1c).
- **Per la challenge conta il dato FTMO, non il BCM**: serve la stessa tabella sul terminale FTMO.
- Un percorso per periodo e per set; Modello 1; cambio EUR/USD ipotesi; lotti variabili col prezzo.
- I 9 set H1 non hanno il periodo lungo: si possono rifare in due meta (2005-2012 e 2013-2025) e confrontare i due DD (il DD a cavallo non si misura).
- **Nessun giudizio su acquisti, taglie o lotti.**
