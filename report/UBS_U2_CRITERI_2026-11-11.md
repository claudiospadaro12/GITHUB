# UBS U2: il lotto calcolato dal rischio, con il DD dichiarato o con il DD misurato — CRITERI e PREVISIONI (11/11/2026, scritti PRIMA dei numeri)

**Natura: CRITERI, righe NON ancora generate.** Segue `RISULTATI_UBS_U1B_2026-11-11.md` (U1b e U1b-H1: il DD misurato su BCM a 0,01 lotti non coincide quasi mai col `HistoricalMaxDD` dichiarato; R = DD BCM / dichiarato, mediana attorno a 1,1 ma da 0,4 a 4,0). Solo tester; reale, trial FTMO e VPS non si toccano; nessun giudizio su lotti, taglie o acquisti.

## Domanda
Con `Risk = use Max Risk Per Strategy` e `MaxRiskPerStrategy_Value = 2` (il lotto e dimensionato perche il DD storico a 0,01 lotti stia dentro il 2% del saldo, manuale UBS), **il DD che esce dal test e vicino al 2%?** E lo e di piu quando al posto del `HistoricalMaxDD` dichiarato si mette il DD misurato su BCM? E` la tappa che dice se si puo dimensionare un set UBS su un conto prop senza fidarsi del numero di Wim.

## Cosa si testa
- EA `Ultimate_Breakout_EA_WSC_V9.5`, XAUUSD, **2013-01-01 -> 2025-12-31** (periodo B di U1b, qualita 98%), Modello 1, deposito 100.000 EUR, i set cosi come consegnati ad eccezione degli input sotto. Quindici o piu passate non servono: **9 set x 2 bracci = 18 passate**.
- **Campione (R misurato in U1b, il piu lontano e il piu vicino a 1)**: Phantom strat8 (R 0,41), Phantom strat3 (0,52), Goldbot dailyC (0,62), Gold Trade Pro E (1,03), Phantom Gold_c (1,04), Goldbot dailyI (1,05), Gold Trade Pro a (2,19), Reaper s5 H1 (2,82), Reaper s1 D1 (4,00). Mix di EA e di timeframe (D1, H4, H1).
| Braccio | Input imposti rispetto al set | Cosa mette |
|---|---|---|
| **A** | `Risk` = valore di "use Max Risk Per Strategy" (da leggere, vedi sotto), `MaxRiskPerStrategy_Value=2`, `overrideAutoLoadLotsSettings` come serve | `HistoricalMaxDD` DICHIARATO dal set |
| **B** | come A, piu `HistoricalMaxDD` = DD BCM misurato a 0,01 lotti, **in dollari** (DD in EUR x 1,15, ipotesi di cambio di U1b) | `HistoricalMaxDD` MISURATO |
Tutti gli altri input uguali al set; **si impongono tutti gli input che cambiano fra i test e si controllano nel report TUTTI gli input contro il riferimento** (lezione dell'11/11: il tester ricorda l'ultimo valore salvato per l'EA; `FridayStopHour` e simili restano come nel set).
- **Prerequisito manuale (non lo so dai file)**: il valore numerico di `Risk` per "use Max Risk Per Strategy" **non e verificato**: nei set del pacchetto compaiono 0, 123, 999 e 9999 e l'ordine del manuale (Manual lotsize, Lots per balance, Risk per trade %, Risk per trade $, Max Risk Per Strategy) potrebbe non coincidere. Passo di Claudio: nel Strategy Tester, tra gli input dell'EA, scegliere "use Max Risk Per Strategy" nel menu Risk, salvare un file `.set` e mandarmelo (leggo io il numero). Senza quello la riga NON si genera.
- **Risolto il 12/11**: dal file salvato da Claudio (`u2_phantom_strat8_maxrisk.set`, letto dalla riga di ricerca: `Risk=123`, `HistoricalMaxDD=720`, `StartLots=0.1`, `MaxRiskPerStrategy_Value=2.0`) il valore di `Risk` per "use Max Risk Per Strategy" e **123** (coerente con i 121 set del pacchetto della community che hanno `Risk=123` e `MaxRiskPerStrategy_Value=2.0`). Verifica nella corsa stessa: il report deve mostrare `Risk=123` e lotti diversi da 0,1.
- **Limite aggiunto (di progetto, non dai risultati)**: il lotto e arrotondato a 0,01; per i set con DD dichiarato alto (Phantom strat8 720, Reaper s5 e simili) il lotto atteso a 100.000 EUR e 0,01 x 2000 / DD, cioe circa 0,03 lotti per strat8: la granularita del lotto puo spostare il DD% di diverse decine di punti percentuali. Si legge come limite, non cambia le regole.

## Misure
Per passata: DD equity in % del deposito (e in EUR), netto, PF, operazioni, **lotto medio e massimo aperti** (dai deal), peggior giorno realizzato; **rapporto DD% / 2** per braccio; per il braccio A anche il DD% previsto 2 x R (R da U1b).

## Regole di lettura (fissate ora)
- **PRECISO**: DD% in 1,5-2,5 (entro 25% dal 2%); **FUORI** altrimenti; **LONTANO** se oltre 3,0 o sotto 1,0.
- Validita di una passata: report presente, deposito 100.000, input imposti confermati dal report e tutti gli altri input uguali al set, qualita >= 95%, almeno 1 operazione, nessun "no money".
- Verdetto del metodo: **VALE** se B e PRECISO in almeno 6 set su 9 e nessuno LONTANO; **VALE CON LIMITI** se B e PRECISO in 4-5 set o ha 1-2 LONTANO; **NON VALE** altrimenti. Verdetto del DD misurato rispetto al dichiarato: **MISURATO MEGLIO** se B e piu vicino a 2% di A in almeno 7 set su 9.

## Previsioni dichiarate ORA (non misurate)
- **U2-1** 16 passate su 18 valide: 80% (lo stesso EA di U1b: tutte valide).
- **U2-2** Braccio A: il DD% e vicino a 2 x R (entro 25%) in almeno 6 set su 9: 55% (il lotto e proporzionale al DD dichiarato, ma i lotti variano nel tempo con il saldo).
- **U2-3** Braccio B PRECISO (1,5-2,5%) in almeno 5 set su 9: 45%.
- **U2-4** B piu vicino a 2% di A in almeno 7 set su 9 (MISURATO MEGLIO): 70%.
- **U2-5** Almeno un set con DD% oltre 3,0 nel braccio B (non si e fatto un'ottimizzazione, i rialzi del saldo cambiano il lotto): 50%.
- **U2-6** Reaper s1 D1 (R 4,00): nel braccio A il DD% supera 5%: 70%.
- **U2-7** Verdetto del metodo: VALE 15%; VALE CON LIMITI 40%; NON VALE 45%.
- **U2-8** I lotti medi nel braccio B sono entro il doppio di quelli di A solo per i set con R vicino a 1 (0,75-1,33): 80%.

## Limiti
Un percorso per set (i set hanno Randomization 0); il DD storico dichiarato puo essere su un altro periodo o dati (MetaQuotes, non testato: U1c); cambio EUR/USD 1,15 ipotesi; il lotto cambia con il saldo (compounding): il DD in % non e il DD a lotto fisso; non si prova `Max Daily Drawdown` dell'EA ne il Guardian; Modello 1; un solo anno-intervallo (2013-2025).
