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
