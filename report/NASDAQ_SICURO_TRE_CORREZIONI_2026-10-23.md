# ABTG_Nasdaq_Apertura_US_Sicuro v1.03: le tre correzioni (23/10/2026)

**Non controllata da agenti. Scritta senza poter compilare qui.** `mql5/Experts/ABTG_Nasdaq_Apertura_US_Sicuro.mq5` (SHA256 `735B0044...737D`) e una COPIA di `ABTG_Nasdaq_Apertura_US.mq5` 1.02 con magic proprio **770291**: non tocca la sedia in campo (770260 FTMO, 770250 BCM) e non la sostituisce. Le tre correzioni sono **opt-in, tutte spente di default**: a input di default il comportamento deve essere identico (cancello G0 di R282a contro R274a).

| correzione | input | cosa fa | perche (misurato) |
|---|---|---|---|
| festivi USA | `InpSkipUSHolidays` | nei giorni di chiusura NYSE (Capodanno, MLK, Presidents, Venerdi Santo, Memorial, Juneteenth, 4 luglio, Labor, Thanksgiving, Natale, con la regola sabato/domenica) non arma | R274c: 2 deal il 20/01/2025 (MLK) |
| ora solare USA | `InpAutoUSDST` | server a UTC fisso: sessione e flat +60 min quando gli USA sono in ora solare (orari impostati = ora legale: 14:30 / 17:30) | BCM UTC+1 fisso: dal 02/11/2026 14:30 BCM = 8:30 New York |
| lotto minimo | `InpMaxMinLotRiskX` | se il lotto va forzato al minimo e il rischio effettivo supera X volte il nominale, niente trade | R276: lotto forzato al minimo confermato a deposito 500 |

Verifiche fatte qui: calendario NYSE 2024-2026 e ora solare ricalcolati in Python contro le date note (10/11/10 festivi, 2a domenica di marzo e 1a di novembre); parentesi e graffe bilanciate. **Non compilata**: se il compilatore trova un errore, tutti i round di R282 escono rc 1 e non si legge niente. Eccezione cablata: chiusura straordinaria del 09/01/2025 (lutto nazionale), **da riverificare sul calendario NYSE**. Il festivo sposta solo la data del server, non gestisce le mezze sessioni.

Test prima/dopo: `backtest_pipeline/prove/R282a-e`, lettore congelato `r282_giudizio.py`, riga `RIGA_LANCIA_R282_NASDAQ_SICURO.txt`. Attese e criteri dentro i file prova (P1-P5). L'effetto sul conto reale e **NON MISURATO**. Nessuna taglia.
