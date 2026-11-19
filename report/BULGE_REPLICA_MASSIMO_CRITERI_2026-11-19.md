# Replica sul tester BCM della verifica di Massimo (Breaking Band v4) - criteri PRIMA dei numeri (19/11/2026)

Fonte: `Breaking_Band_per_Claudio_COMPLETO_19nov.pdf`. EA: `BreakingBand_MT5_v4.mq5` (invariato, SHA256 4003A62B...). Parametri di default del file, H1, **100.000 EUR**, Modello 1 (barre da 1 minuto; Massimo usa ogni tick su MetaQuotes-Demo), tester BCM portabile, solo tester.
**Passate (12):** EURUSD, EURCHF, EURCAD x finestre **2013-01-01 -> 2020-12-31** e **2020-01-01 -> 2026-10-31** (le sue) x rischio **0,5%** e **2,0%**.
**ATTENZIONE hold-out:** la finestra 2020-2026 consuma il 2025-26 che per la bulge avevamo tenuto intatto. Queste passate sono una **REPLICA**, non un fuori campione. 2020 e comune alle due finestre (come nel PDF).

## Previsioni (prima dei dati)
- Replica IS 2013-20: PF >= 1,5 su 3 simboli su 3 a rischio 0,5%: **80%** (nostro IS Market Watch: 2,56 / 3,05 / 80,7).
- Replica 2020-26: PF > 1,2 e profitto > 0 su almeno 2 simboli su 3: **35%** (nostro OOS 2021-24: PF 0,64-0,75).
- Operazioni EURCAD 2020-26 entro 8-14 (suo: 11): **55%**.
- Scala col rischio (2% contro 0,5%): DD x 3,0-5,0 per simbolo: **80%**; profitto x 3,2-4,8: **55%** (il suo PDF mostra circa x5).
- Portafoglio dei 3 (serie giornaliere sommate, rischio 2%): peggior giorno < 5%: **95%**; DD totale <= peggior singolo: **75%**.

## Regole di esito
1. **Replica riuscita** per un simbolo: PF tester > 1,2, profitto > 0, >= 8 operazioni nel 2020-26 E nell'IS PF > 1,5. **Replica confermata** se riescono 3 su 3; **parziale** 1-2; **non replicata** 0. Con meno di 15 operazioni per finestra nessun esito vale come prova statistica: si riporta comunque.
2. Si riportano per simbolo: operazioni, PF, rendimento, DD equity, e confronto con la sua tabella (PF IS 1,99/3,33/EURCAD +3.042 EUR; OOS 1,59/1,41/2,34; DD 2% 3,83/4,20/3,92).
3. Portafoglio: somma giornaliera delle 3 serie (una passata per simbolo), peggior giorno e DD totale, a 0,5% e a 2%. Nessuna taglia consigliata: scelta di Claudio.
4. Non si cambiano parametri. Esito "non replicata" = la differenza e dati/esecuzione/finestra; domanda a Massimo per le sue liste operazioni.

---
## RISULTATO (19/11/2026, zip BULGE_REPLICA, 12 passate; dati in `BULGE_REPLICA_dati/`) - replica sul tester BCM, 100.000 EUR, Modello 1
| Simbolo | IS 2013-20 BCM (op., PF, EUR) | suo IS (PF, EUR) | 2020-26 BCM (op., PF, EUR) | suo 2020-26 (PF, EUR) | DD equity 2%: BCM | suo DD 2% |
|---|---|---|---|---|---|---|
| EURUSD | 17, 2,55, +2.382 | 1,99, +1.575 | 13, 2,00, +1.154 | 1,59, +773 | 3,84% | 3,83% |
| EURCHF | 14, 3,03, +2.222 | 3,33, +1.910 | 11, **0,82**, **-366** | 1,41, +498 | 4,91% | 4,20% |
| EURCAD | 15, 81,3, +3.682 | +3.042 | 12, 2,28, +1.436 | 2,34, +1.129 | 4,07% | 3,92% |

1. **Regola 1: replica PARZIALE (2 su 3).** EURUSD e EURCAD passano (PF>1,2, profitto>0, >=8 operazioni, IS PF>1,5); **EURCHF no** (PF 0,82 nel 2020-26). Previsione "almeno 2 su 3" = 35%: **sbagliata**, e vera. IS: previsione 3 su 3 con PF>=1,5 (80%): confermata.
2. **Il nostro tester riproduce bene i numeri di Massimo** su EURUSD ed EURCAD (PF e DD quasi uguali; operazioni EURCAD 12 contro 11); i DD a 2% coincidono (3,84/4,07 contro 3,83/3,92).
3. **Scala col rischio:** profitto 2% / 0,5% = 4,0-4,2 (previsione 3,2-4,8: si); DD x 3,8-4,0. **Il suo "x5 del profitto" non e riprodotto**: a noi vale circa x4.
4. **Da dove viene il risultato 2020-26 (rendimento per anno a rischio 0,5%, somma uscite):** EURUSD 2020 +0,38, 2021 +0,38, 2022 -0,61, 2025 +0,54, 2026 +0,46. EURCAD 2020 **+1,43** (5 operazioni), 2021 -0,57, 2023 +0,33, 2024 +0,07, 2025 +0,29, 2026 -0,12 (totale +1,44: il 2020 vale il 99%). EURCHF: negativo in 4 anni su 6. **Senza il 2020 (anno gia dentro la finestra IS) EURCAD fa circa 0, EURUSD +0,77% in 6 anni, EURCHF -0,37%**: coerente col nostro OOS 2021-24 (PF 0,64-0,75). Il vantaggio fuori campione vero e quasi nullo; il resto e 2020 (sovrapposto) e 2025-26.
5. **Portafoglio (serie giornaliere sommate, DD sul saldo chiuso, non sull'equity):** 2020-26 a 2%: peggior giorno -2,45%, DD chiuso 4,31% (peggior singolo 4,62%); a 0,5% -0,61% / 1,07%. IS 2013-20 a 2%: peggior giorno **-3,99%** (circa 2 volte il rischio per operazione, non "un rischio-trade"), DD 4,13%. Peggior giorno < 5% (previsione 95%): si, ma in IS arriva all'80% del muro. DD portafoglio <= peggior singolo: si. DD equity del portafoglio NON misurabile da queste serie.
6. **Verdetto:** replica tecnica riuscita (il suo tester e il nostro concordano), ma **il fuori campione e sottile**: 11-13 operazioni per simbolo, 2020 sovrapposto, 2025-26 consumato. Non e un EA validato per mettere capitale; e un candidato per la demo, con EURCHF da escludere dai dati. Domande a Massimo: lo scaling x5 del profitto; le sue operazioni 2020-26.
