# Goldbot One a TICK REALI, step 3000: lettura (22/10/2026). Il rifacimento della TRANCHE1 e andato.

Fonte: `GB5_GOLDBOTONEMT5.zip` (nuovo giro, partito 14:26:35). Archivio `risultati_archivio/GB5_20261022_STEP3000`. Previsioni: `GOLDBOT_ONE_TICK_REALI_ATTESE_2026-10-22.md`. Non controllata da agenti. Il `GB5_RIEPILOGO_VECCHIO_...txt` allegato e quello del giro precedente (step 6000 OK, step 3000 KO).

## Numeri (XAUUSD D1, 01/01/2025-01/10/2026, 80.000, tick reali 100% con 146 milioni di tick, input confermati: Risk 9999, MaxRisk 6.0, StartLots 0.01, step 3000; durata 8.889 s = 2 h 28 min)
| | OHLC 1 min (sonda 4) | **TICK REALI** |
|---|---|---|
| operazioni | 451 | **449** |
| netto | +25.156,86 | **+21.468,82 (-14,7%)** |
| PF | 1,83 | **1,68** |
| DD equity | 7.281,90 (9,10%) | **7.844,20 = 9,81% di 80K (7,85% del picco)** |
| DD saldo | 5.941,54 | 6.658,74 |
| lotti min / mediano / max | | **0,06 / 0,13 / 0,20 (rapporto 3,33)** |
| mesi positivi | | 15 su 21 (71%) |
| meta 01-10/2025 / 11/2025-09/2026 | | +15.273 / +6.196 |
| peggior giorno realizzato | | -2.499 il 23/03/2026 (3,12% di 80K) |
| posizioni aperte insieme (max) | | 8 |

## Contro le previsioni (scritte prima)
- TK1 operazioni 440-460: CENTRATA (449). TK2 netto -5/-25% dall'OHLC (+18.900..+23.900): CENTRATA (+21.469). TK3 PF 1,5-1,8: CENTRATA (1,68).
- **TK4** (step 3000 supera il 10% di 80K: 40%): **NO, 9,81%**: sotto il tetto, ma **per 0,19 punti percentuali**.
- **TK5** (rapporto lotti <= 3 in entrambi: 45%): **FALSA**. Step 6000 = 3,0 (bordo), **step 3000 = 3,33**.
- TK6 (2,5-3,2 ore, nessun timeout): CENTRATA (2 h 28 min).

## Cancelli, step 3000 a tick reali
S-N 449 ok | S-M 71% ok | S-H ok (+15.273 / +6.196) | **S-DD 9,81%: passa SUL BORDO** (<= 10% dal deposito; <= 15,2% dal picco ok) | **S-NOSCALA 3,33: NON PASSA** (> 3; un solo ingresso a 0,06, il minimo; 5 ingressi al massimo 0,20) | S-COSTO non misurato.

## Insieme a Gold Reaper (stesso conto 80K, lotti sommati)
- netto +81.265; DD del saldo 4.756 (5,95%); DD di equity fra 5,95% (minimo stimato) e **14,62%** (massimo rigoroso: 7.844 + 3.854): **S-DD NON dimostrabile**.
- correlazione giornaliera dei realizzi **0,498** (sul bordo di 0,5, non robusta); sulle variazioni di equity **0,646**.
- peggior giorno insieme -3.154 (3,94% di 80K), 23/03/2026. Posizioni insieme fino a 17.

## Confronto con step 6000 a tick reali (report GOLDBOT_ONE_TICK_REALI_LETTURA)
Step 6000: netto +9.537, PF 1,69, DD 4,29%, rapporto lotti 3,0, insieme a GR DD massimo rigoroso 9,10% (S-DD dimostrato), correlazione 0,494. **Step 3000 rende piu del doppio (+21.469 contro +9.537) ma con DD 9,81% quasi al tetto, rapporto lotti sopra il limite e S-DD insieme a GR non dimostrabile.** Nessuna taglia: la scelta resta di Claudio.

## Cosa NON dice
Un solo percorso (rialzo 2025-26), una passata per step, PropFirmMaxDailyDD a 0 (protezione spenta), niente slippage con lotti grandi, filtro news, margine reale.
