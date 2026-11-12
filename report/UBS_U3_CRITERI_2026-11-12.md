# UBS U3: il DD misurato su un periodo regge su un altro periodo? — CRITERI e PREVISIONI (12/11/2026, scritti PRIMA dei numeri)

**Natura: CRITERI, righe NON ancora lanciate.** Segue `RISULTATI_UBS_U2_2026-11-12.md`: nel braccio B il DD BCM misurato a 0,01 lotti e preso sullo STESSO periodo 2013-2025 del test (in-sample), quindi la precisione (DD% 2,00-2,71) e in parte circolare. U3 la toglie: il DD si misura su un periodo e il lotto si calcola e si prova su un altro. Solo tester; reale, trial FTMO e VPS non si toccano; nessun giudizio su lotti, taglie o acquisti.

## Domanda
Se si dimensiona un set UBS (`Risk=123`, `MaxRiskPerStrategy_Value=2`) con il DD misurato su BCM in UN periodo, il DD% che esce in un periodo DIVERSO e vicino al 2%?

## Disegno (doppio incrocio, stessi 9 set di U2)
Set: Phantom strat8, Phantom strat3, Goldbot dailyC, Gold Trade Pro E, Phantom Gold_c, Goldbot dailyI, Gold Trade Pro a, Reaper s5 H1, Reaper s1 D1. XAUUSD, Modello 1, deposito 100.000 EUR, EA `Ultimate_Breakout_EA_WSC_V9.5`.
- **Periodo 1 (P1)** = 2013-01-01 -> 2019-01-01 (6 anni). **Periodo 2 (P2)** = 2019-01-01 -> 2026-01-01 (7 anni).
- **Tappa 1 (misura, riga U3-M)**: 9 set x 2 periodi = 18 passate, set cosi come consegnati (lotto fisso 0,1, nessun input imposto, come U1b). Si legge il DD equity: `DD01(P) = DD / 10` (a 0,01 lotti) e `HistoricalMaxDD(P) = DD01(P) x 1,15` (dollari, come U2).
- **Tappa 2 (prova, riga U3-T, generata DOPO aver letto la tappa 1)**: 9 set x 2 incroci = 18 passate. **Incrocio X**: `HistoricalMaxDD` = valore misurato su P1, prova su P2. **Incrocio Y**: valore misurato su P2, prova su P1. Input imposti: `Risk=123`, `MaxRiskPerStrategy_Value=2.0`, `AdjustLotsizeToVariableValues=true`, `HistoricalMaxDD`; tutti gli altri input uguali al set e controllati nel report.
- Controllo di coerenza: `DD01(P1)`, `DD01(P2)` contro `DD01(2013-2025)` di U1b (`D160_dati/ubsu1b.json`); il DD del periodo intero puo superare entrambi (la perdita puo attraversare il 2019).

## Misure
Per passata della tappa 2: DD equity in % del deposito, netto, PF, operazioni, lotto medio e massimo, peggior giorno realizzato. Per set e incrocio: rapporto `DD01(prova)/DD01(misura)` (quanto il periodo di prova e piu duro del periodo di misura), DD% della prova, classe (PRECISO 1,5-2,5%; LONTANO oltre 3,0 o sotto 1,0; FUORI altrimenti, come U2).

## Regole di lettura (fissate ora)
- **Validita**: report presente, deposito 100.000, qualita >= 95%, almeno 1 operazione, nessun "no money", input imposti confermati dal report e tutti gli altri uguali al set.
- **Verdetto del metodo fuori periodo**, su 18 casi (9 set x 2 incroci):
  - **REGGE**: PRECISO in almeno 9 casi e LONTANO in non piu di 2.
  - **REGGE CON LIMITI**: PRECISO in 5-8 casi, oppure PRECISO >= 9 con LONTANO in 3-4.
  - **NON REGGE**: tutto il resto.
- Se il verdetto e REGGE CON LIMITI o NON REGGE, si legge anche per quali set e per quale incrocio fallisce (set con rapporto `DD01(prova)/DD01(misura)` oltre 1,5).

## Previsioni dichiarate ORA (non misurate)
- **U3-1** Tappa 1: almeno 16 passate su 18 valide: 85%.
- **U3-2** `DD01(P1)` e `DD01(P2)` differiscono di oltre 1,5 volte (massimo/minimo) in almeno 5 set su 9: 70%.
- **U3-3** Prova (18 casi): PRECISO in almeno 9: 25%; in almeno 5: 65%.
- **U3-4** Prova (18 casi): LONTANO in almeno 4: 65%.
- **U3-5** DD% mediano della prova sopra 2,39 (media in-sample di U2 B): 70%.
- **U3-6** Nei casi in cui il periodo di misura ha DD01 piu basso del periodo di prova, il DD% della prova supera 2,5 in almeno l'80% di quei casi: 80%.
- **U3-7** Verdetto: REGGE 15%; REGGE CON LIMITI 40%; NON REGGE 45%.

## Limiti
Un percorso per set (Randomization 0); 6-7 anni per periodo, DD01 su 6-7 anni e un singolo evento peggiore; cambio EUR/USD 1,15 ipotesi; il lotto cresce col saldo (compounding); Modello 1; il periodo di misura a lotto fisso 0,1 non ha compounding, la prova si; solo oro e solo questi 9 set.
