# O-2 per Gold Trade Pro: costo della chiusura del venerdi — CRITERI e PREVISIONI (09/11/2026, scritti PRIMA dei numeri)

**Natura: CRITERI, non ancora lanciato.** Completa la voce O-2 del cancello (`CANCELLO_MINIMO_PRIMA_DI_UBS_2026-11-08.md`), che copriva Reaper, Phantom e Goldbot ma non il Gold Trade Pro. Solo tester; il reale, la trial FTMO e il VPS non si toccano; nessuna taglia ne lotto.

## Cosa si testa
Gold Trade Pro COMBO (`Risk=3`, `MaxRiskPerStrategy=0,5`, `PropFirmMaxDailyDD=4,0`), XAUUSD D1, 80.000 EUR, Modello 1, anni **2013, 2018, 2020, 2025**, con **`FridayStopHour=19`** (come per gli altri EA). Cambia solo quel parametro. **4 passate** (deterministico, Randomization 0: una passata per anno). Riferimento senza chiusura (`FridayStopHour=25`): test `GTP_COMBO_TRE_ANNI_RISULTATI_2026-11-04.md`: netto 14.693 / 8.753 / 6.529 / 8.843, DD equity 4,45 / 3,52 / 5,94 / 1,91%.
**Validita**: report presente, deposito 80.000, input uguali (conferma `si` del report, `FridayStopHour=19` incluso), qualita >= 98%, almeno 1 operazione.

## Misure
Netto, DD equity relativa, operazioni, peggior giorno realizzato; dai deal: quante posizioni attraversano il weekend, aperture del venerdi dalle 19:00.

## Regole di lettura (le stesse di O-2)
- Rapporto = netto con chiusura / netto base, per anno e sommando i 4 anni.
- **ACCETTABILE** se rapporto >= 0,92 in ogni anno e DD equity non piu alta di 1 punto; **ALTO** se < 0,85 in un anno o DD +3 punti; in mezzo ZONA GRIGIA.
- **CHIUDE** se le posizioni che attraversano il weekend scendono sotto il 2% (nel base circa 3,5% per gli altri EA); **SOLO BLOCCA NUOVE** se restano oltre il 10%.

## Previsioni dichiarate ORA (non misurate)
- **G1** 4 passate valide: 90%.
- **G2** Il parametro chiude (attraversamenti < 2%): 80%.
- **G3** Rapporto sommato sui 4 anni fra 0,88 e 0,95 (come Goldbot 0,90-0,91, stessa classe D1): 60%; sotto 0,85: 15%; sopra 0,95: 20%.
- **G4** DD equity entro +1 punto in almeno 3 anni su 4: 75%.
- **G5** Almeno un anno con rapporto < 0,85: 35%.
- **G6** Il verdetto per la regola per anno e ZONA GRIGIA (come il Goldbot): 50%; ACCETTABILE: 15%; ALTO: 35%.
- **G7** Il peggior giorno realizzato non peggiora in nessun anno: 70%.

## Limiti dichiarati
Un percorso per anno, tester a barre da 1 minuto senza slippage, `FridayStopHour=19` e ora del server BCM (GMT+1 fisso; l'ora FTMO e diversa: NON VERIFICATO che 19 equivalga a 3 ore prima della chiusura su FTMO). Nessun giudizio su acquisti, taglie o lotti.
