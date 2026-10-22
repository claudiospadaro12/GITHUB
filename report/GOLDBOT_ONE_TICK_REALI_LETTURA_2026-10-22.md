# Goldbot One a TICK REALI, step 6000 (TRANCHE2): lettura (22/10/2026). La TRANCHE1 (step 3000) e KO: manca.

Fonte: `GB5.zip` = `GB5_GOLDBOTONEMT5.zip` + `GB5_RIEPILOGO.txt` (archivio `risultati_archivio/GB5_20261022`). Previsioni: `GOLDBOT_ONE_TICK_REALI_ATTESE_2026-10-22.md`. Non controllata da agenti.

## TRANCHE1 (step 3000): KO, MISURA MANCANTE
Partita 06:47, finita 11:52 (18.341 s). Report vuoto (periodo 1970, deposito 0, leva 1:0, input non applicati, zero operazioni). Il giornale dice "last test passed with result some error after pass finished in 0:00:00.000" e "failed to send close command" (il terminale non ha ricevuto la chiusura). Il tester ha chiuso subito e lo script ha aspettato circa 5 ore. Causa [NON TROVATA]. Precedente: T4 di GBO del 20/10. Va rifatta (riga `RIGA_LANCIA_GOLDBOT_TICK_REALI_STEP3000.txt`).

## TRANCHE2 (step 6000, tick reali 100%, 146 milioni di tick, 80.000, input confermati dal report: Risk 9999, MaxRisk 6.0, StartLots 0.01, step 6000): OK
| | OHLC 1 min (sonda 4) | **TICK REALI** |
|---|---|---|
| operazioni | 451 | **449** |
| netto | +11.173,35 | **+9.536,74 (-14,6%)** |
| PF | 1,84 | **1,69** |
| DD equity | 3.213,10 (4,0%) | **3.428,67 (4,29% di 80K; 3,85% del picco)** |
| DD saldo | 2.641,57 | 2.893,34 |
| lotti min / mediano / max | | **0,03 / 0,06 / 0,09 (rapporto 3,0)** |
| mesi positivi | | **15 su 21 (71%)** |
| meta 01-10/2025 / 11/2025-09/2026 | | **+7.008 / +2.529** |
| peggior giorno realizzato | | -1.110 il 23/03/2026 (1,39% di 80K) |
| posizioni aperte insieme (max) | | 8 |
Durata 9.092 s (2 h 31 min), nessun timeout.

## Contro le previsioni (scritte prima)
- **TK1** (operazioni 440-460): **CENTRATA** (449).
- **TK2** (netto -5/-25% dall'OHLC, step 6000 fra +8.400 e +10.600): **CENTRATA** (-14,6%, +9.537).
- **TK3** (PF 1,5-1,8): **CENTRATA** (1,69).
- **TK4** (step 6000 <= 10% di 80K): **CENTRATA** (4,29%). Step 3000: NON MISURATO.
- **TK5** (rapporto lotti <= 3): **CENTRATA sul bordo** (3,0 esatti: 0,09 / 0,03). Step 3000: NON MISURATO.
- **TK6** (2,5-3,2 ore, nessun timeout): **CENTRATA** per la T2 (2 h 31 min). Il rischio di blocco (10%) si e verificato sulla T1.

## Cancelli, step 6000 a tick reali
S-N 449 ok | S-M 71% ok | S-H ok (entrambe le meta positive) | S-DD 4,29% ok (<= 10% dal deposito, <= 15,2% dal picco) | **S-NOSCALA 3,0: ok SUL BORDO** (e dipende da 17-18 posizioni ai lotti estremi 0,03 e 0,09) | S-COSTO NON misurato.

## Insieme a Gold Reaper (stesso conto 80K, lotti sommati; stesso metodo di `GOLDBOT_ONE_E_GOLD_REAPER_INSIEME_2026-10-22.md`)
- netto 21 mesi **+69.333**; DD del saldo **3.623 (4,53%)**; DD di equity: minimo stimato 4,53%, **massimo rigoroso 9,10%** (somma dei DD: 3.429 + 3.854) -> **S-DD passa in modo rigoroso**.
- **S-CORR (<= 0,5): correlazione giornaliera dei realizzi 0,494 (marginale; con OHLC era 0,526)**; sulle variazioni di equity col flottante **0,641**. Il valore e sul bordo e l'intervallo di confidenza (0,33-0,68 in OHLC) lo contiene: NON robusto.
- peggior giorno insieme -1.765 (2,21% di 80K), 23/03/2026. Posizioni aperte insieme fino a 17.

## Cosa NON dice
Una sola passata, un solo percorso (rialzo 2025-26); lo step 3000 non e misurato; PropFirmMaxDailyDD era a 0 (protezione spenta); niente slippage con lotti grandi, filtro news, margine reale. Nessuna taglia.
