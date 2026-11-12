# Quante volte i 4 EA di Wim e Daytrade Pro superano il 4,5% giornaliero nei test (12/11/2026)

**Natura: MISURA dai report del tester** (BCM, Modello 1, 80.000 EUR; la % vale a qualsiasi taglia). Script `ORO_GRADINI_dati/soglia45.py` (perdita realizzata dai deal) e `equity_45.py` (equity con flottante ricostruito dalle barre M1, solo oro). Livelli scelti per il portafoglio: Goldbot Prop (L0) e Combo (L3), Phantom Gradino 1, Reaper Combo, Gold Trade Pro Combo, Daytrade Pro Max9.

## 1. Perdita giornaliera REALIZZATA (somma dei deal chiusi nel giorno, con commissioni e swap del tester)
Giorni con perdita >= 4,3% / **>= 4,5%** / >= 5,0% del conto:
| EA | Anni testati | Giorni >= 4,5% | Peggior giorno per anno |
|---|---|---|---|
| Goldbot One Prop | 2013, 2018, 2020, 2025 | **0** | -2,6% / -1,1% / -1,1% / -1,1% |
| Goldbot One Combo | 2013, 2018, 2020, 2025 | **0** | -2,2% / -0,9% / -0,9% / -0,9% |
| Gold Phantom Gradino 1 | 2013, 2018, 2020, 2025 | **0** | -2,4% / -0,8% / -1,1% / -0,9% |
| Gold Reaper Combo | 2013, 2018, 2020, 2025 | **0** | -1,6% / -0,8% / -0,6% / -0,5% |
| Gold Trade Pro Combo | 2013, 2018, 2020, 2025 | **0** | -2,7% / -1,7% / -1,1% / -1,0% |
| Daytrade Pro Max9 | 2013, 2017, 2020, 2022, 2025 | **0** | -2,6% / -2,6% / -1,6% / -3,1% / -1,8% |
Anche a 4,3% e a 5,0%: **0 giorni** per tutti gli EA singoli.

## 2. Le tre combinazioni scelte (per conto, 2013 / 2020 / 2025)
| Conto | Combo | Giorni >= 4,5% | Peggior giorno per anno | Peggior giorno con i costi "centrali" |
|---|---|---|---|---|
| 160k | P1: Phantom Gradino 1 + Goldbot Prop + Daytrade Pro | **0** | -4,2% / -2,4% / -1,9% | -4,4% |
| 80k | P3: Goldbot Combo + Gold Trade Pro Combo + Daytrade Pro | **0** | -3,9% / -1,9% / -1,9% | -4,1% |
| 80k | P4: Reaper Combo + Goldbot Prop + Daytrade Pro | **0** | -3,5% / -1,7% / -1,5% | -3,7% |
**Nessun conto del portafoglio supera il 4,5%; il piu vicino e P1 nel 2013 (-4,2%, -4,4% con i costi centrali). Con il limite 4,3% del Guardian un giorno di P1 con i costi centrali lo avrebbe superato (-4,4%).**

## 3. Perdita giornaliera in EQUITY (flottante ricostruito, solo oro; Daytrade Pro NON ricostruibile: mancano le barre forex)
Giorni con perdita in equity >= 4,5%: **0** per tutti i 5 EA oro e per le tre parti oro delle combo, in tutti e 4 gli anni (2013, 2018, 2020, 2025). Peggiori giorni in equity: Goldbot Prop 2,7% (31/12/2013), Goldbot Combo 2,2%, Phantom 3,6% (18/12/2013), Reaper 2,1% (23/01/2013), Gold Trade Pro 2,2%. Parte oro di P1 (Phantom + Goldbot Prop): **4,46% il 31/12/2013** (ultimo giorno del test: puo includere la chiusura forzata di fine test), poi 3,7% / 2,6% / 2,2%; parte oro di P3: 3,9% (31/12/2013), 3,2%, 2,4%, 2,3%; parte oro di P4: 3,7% (31/12/2013), 3,1%, 1,9%, 2,1%.

## 4. Per confronto: i livelli che NON abbiamo scelto (giorni >= 4,5% realizzati, 2013 / 2020 / 2025)
| Livello | Giorni >= 4,5% | Peggior giorno |
|---|---|---|
| Reaper Prop (L0) da solo | 2 (tutti nel 2013) | -5,9% |
| Reaper Medium (L2) da solo | 24 (10 / 11 / 3) | -32,5% |
| Goldbot Medium (L2) da solo | 13 (7 / 4 / 2) | -22,2% |
| Phantom Medium (L2) da solo | 2 (2013) | -7,5% |
| **Trio oro Medium (Reaper + Phantom + Goldbot L2)** | **48 (21 / 16 / 11)** | **-47,4% (2013)** |
E` il confronto con quello che hai visto sul trial e sul reale: il Medium supera il 4,5% decine di volte, i livelli scelti mai.

## Limiti
- Il tester non e il live: la perdita giornaliera di FTMO e su equity (flottante, swap e commissioni) e azzera a mezzanotte CET; qui "giorno" = giorno del server BCM nel tester (GMT+1 fisso). L'equity e ricostruita solo per l'oro e con il flottante all'estremo di barra M1 (prudente, ma non e il tick).
- 3-5 anni, un percorso per anno (Phantom e Reaper con rumore, Randomization 50); anni diversi potrebbero avere giorni peggiori. Il 31/12/2013 e l'ultimo giorno del test.
- I costi "centrali" (36 EUR a lotto oro, 4 forex) sono una mia ipotesi; FTMO non e simulato (spread nelle news, slippage, esecuzione).
- Le raffiche reali (es. 9/11: 12-13 ordini in pochi secondi) possono produrre perdite piu rapide di quelle viste nei backtest. Il caso del trial il 9/11 non e confrontabile con i test (lotti, livello, uscita).
