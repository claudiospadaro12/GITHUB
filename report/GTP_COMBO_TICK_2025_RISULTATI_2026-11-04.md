# Gold Trade Pro COMBO a tick reali nel 2025: risultati (04/11/2026)
Zip `ANNO80K_TICK_2025_GTP_20261103_2248`. Criteri e previsioni scritti prima (commit 667cccfb): `GTP_COMBO_TICK_2025_CRITERI_2026-11-03.md`. Una corsa XAUUSD D1, Modello 4 (tick reali, qualita 100%), 01/01/2025-01/01/2026, 80.000 EUR, input Risk=3, MaxRiskPerStrategy=0,5, PropFirmMaxDailyDD=4,0 (confermati dal report, `input_ok = si`), stato OK, stop out 0, "no money" 0. Non controllata da agenti. Giorno peggiore, mesi, long/short e correlazioni: calcolo mio dai deal dei report (P&L realizzato per giorno).

## Numeri
Netto **+8.667** (saldo 88.667), PF 2,60, 276 operazioni, DD equity 1.585 (1,98%; DD di saldo 1.234 = 1,54%), netto/DD **5,47**. Peggior giorno realizzato -823 (-1,03%, 27/03/2025). Netto da long 7.672 (88%) / short 1.032 (12%). Mesi positivi 9 su 12 (negativi: gen -625, feb -534, ott -344).

## Confronto a tick reali, 2025, 80.000 EUR
| | Netto | DD equity | Netto/DD | Peggior giorno |
|---|---|---|---|---|
| Reaper D9 | +27.985 | 3.104 | 9,02 | -882 |
| Phantom D4 | +5.409 | 794 | 6,81 | -193 |
| **GTP COMBO** | **+8.667** | **1.585** | **5,47** | **-823** |
| Goldbot PF525 | +8.444 | 1.611 | 5,24 | -891 |

## Correlazione giornaliera del realizzato (159 giorni con operazioni)
GTP-Reaper 0,64; GTP-Goldbot 0,50; GTP-Phantom 0,29; Reaper-Goldbot 0,37; Reaper-Phantom 0,34; Goldbot-Phantom 0,56.

## Combinazioni (P&L realizzato giornaliero sommato; il DD qui e sul saldo realizzato, SENZA flottante: l equity e almeno uguale)
| | Netto | Peggior giorno | DD saldo realizzato |
|---|---|---|---|
| Reaper + Goldbot + Phantom (trio Free Trial) | +41.839 | -1.704 (-2,13%) | 4.028 (5,04%) |
| Trio + GTP COMBO | +50.506 | -2.226 (-2,78%) | 4.564 (5,71%) |
| Reaper + Phantom + GTP COMBO | +42.061 | -1.433 (-1,79%) | 3.424 (4,28%) |

## Previsioni vs realta
C1 valida: SI. C2 netto positivo: SI. **C3 netto tra 12.000 e 30.000 (55%): NO** (8.667, sotto: era il 20%). C4 DD <=4.000 / <=8.000: SI / SI. C5 giorno <=2.000 / <=4.000: SI / SI. C6 netto/DD >=5: SI (5,47); superiore al Goldbot: SI (di poco); superiore al Phantom: NO. C7 long >=80%: SI (88%). C8 operazioni 200-450: SI (276). C9 "no money" <=10: SI (0).

## Lettura
- A tick reali il COMBO nel 2025 e molto simile al Goldbot (stessa classe D1, stesso netto e DD), e meno efficiente del Phantom. Il fuori campione 2005-2012 lo aveva fatto sembrare migliore (netto/DD 19,9): su 2025 e 5,5, nel mezzo.
- Il GTP e il piu correlato al Reaper (0,64): aggiungerlo al trio non diversifica molto, aggiunge circa +8.700 con +0,65 punti di DD sul saldo e -0,65 sul giorno peggiore (somma, giorni realizzati).
- Il quadro regge a tick reali: nessun KO (quasi tutto da long, come per gli altri, effetto anno rialzista).

## Cosa NON dice
Solo il 2025 (anno di rialzo), un percorso, tester senza slippage e gap, DD combinato senza flottante, correlazione sul realizzato giornaliero (non sull equity). Non cambia la scelta dei tre EA per la Free Trial: e una decisione di Claudio. Nessuna taglia proposta.
