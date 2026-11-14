# TICKP3: parte oro di P3 a tick reali, 2025, 80.000 EUR — RISULTATI (14/11/2026)

**Natura: MISURA dal tester** (BCM, Modello 4 tick reali, qualita 100%, XAUUSD D1, 01/01/2025-01/01/2026, 80.000 EUR). Zip `ANNO_ORO_GRADINI_TICKP3_20261114_1949`: 2 passate, stato OK, stop out 0, "no money" 0. Criteri e previsioni scritti prima: `CRITERI_P3_P4_VS_P1_P4_2026-11-14.md` (commit 182322d5); riga `RIGA_LANCIA_TICK_P3.txt` (pin 6cc57f9e). Goldbot con set `Goldbot_PropFirm_combo_3GOLD.set` (da combodeal.zip); Gold Trade Pro con input `Risk=3, MaxRiskPerStrategy=0,5, PropFirmMaxDailyDD=4,0` (confermati dal report, `input_ok=si`). Riferimenti M1: `ORO_GRADINI_dati/oro_table.txt` (Goldbot L3 80k 2025) e `GTP_COMBO_TRE_ANNI_RISULTATI_2026-11-04.md` (GTP combo 2025 candele). Durata: Goldbot 70 minuti, GTP 60 minuti.

## Numeri
| | Operazioni | Netto | PF | DD equity | Peggior giorno realizzato |
|---|---|---|---|---|---|
| **Goldbot Combo L3 — tick (14/11)** | 238 | +6.028 | 1,97 | 1.238 (1,45%) | -703 (-0,88%) |
| Goldbot Combo L3 — M1 | 239 | +6.680 | 2,16 | 1.547 (1,88%) | -696 |
| **Rapporto tick/M1** | **0,996** | **0,902** | **0,912** | **0,80** | 1,01 |
| **GTP Combo — tick (14/11)** | 278 | +8.047 | 2,45 | 1.934 (2,41%) | -820 (-1,03%) |
| GTP Combo — M1 | 276 | +8.843 | 2,71 | 1.535 (1,91%) | -818 |
| **Rapporto tick/M1** | **1,007** | **0,910** | **0,904** | **1,26** | 1,00 |
| *GTP Combo — tick del 04/11 (stesso set, stesso anno)* | 276 | +8.667 | 2,60 | 1.585 (1,98%) | -823 |
| **Somma P3 oro (due EA): netto tick / M1** | | 14.075 / 15.523 = **0,907** | | somma dei DD singoli: 3.172 / 3.082 = **1,03** | |
Il DD della somma e un limite superiore (somma dei DD singoli, non il DD dell'equity combinata).

## Soglie di Wim (PF >= 0,7 dell'M1, DD <= 1,5x, operazioni +-10%, win rate +-10 punti)
PF: 0,91 e 0,90 -> OK. DD: 0,80 e 1,26 -> OK. Operazioni: -0,4% e +0,7% -> OK. Win rate: **non controllato** (manca il valore M1). Nessuna delle due passate fuori soglia.

## Previsioni (scritte prima) contro risultati
| | Previsione | Esito |
|---|---|---|
| 1a rapporto netto 0,83-0,92 | si | **si**: 0,90 e 0,91 |
| 1b rapporto DD 1,02-1,35 | si | **GTP 1,26 si; Goldbot 0,80 NO (piu basso)**; somma 1,03 si |
| 1c PF 0,90-0,94 | si | **si**: 0,91 e 0,90 (la seconda sul bordo) |
| 1d soglie di Wim | alta probabilita | **si** (win rate non controllato) |
| 2 tempi P3 con tick: 195-215 giorni | | fattore di tempo = 1/0,907 = 1,10: 179 x 1,10 = **circa 197**, nel lato basso della fascia (stima, non simulazione) |
| 6 tempi non distinguibili da P1 | | coerente con i 169-196 di P1 (Phantom 2026 + tick) |

## Regola di lettura scritta prima: "P3+P4 preferibile a P1+P4 solo se..."
1. **Rapporto DD di P3 <= 1,20**: **soddisfatta** (somma 1,03; GTP da solo 1,26, Goldbot 0,80).
2. Fallimento a stress di P3 <= meta di quello di P1: **non misurato** (serve il motore e i dati M1 ricaricati). Indizio: la prova di stress a DD x1,15 / profitti x0,92 per P3 dava 0% fallimenti; il tick misurato (DD 1,03, netto 0,91) sta *dentro* quel punto, non oltre il piu duro (x1,35 / x0,85, 11,7%).
3. Entrambe entro 9 mesi >= 70%: **non misurato** (idem).
**Verdetto: 1 condizione su 3 verificata; le altre due richiedono il motore e i dati.** Nessuna conclusione P3+P4 contro P1+P4 da questo test da solo.

## Segnale da non perdere: due corse a tick sullo stesso set danno numeri diversi
GTP Combo, stesso periodo e stesso modello (4, qualita 100%): **04/11** netto 8.667, PF 2,60, DD 1,98%; **14/11** netto 8.047, PF 2,45, DD 2,41%: -7% sul netto, +22% sul DD, +2 operazioni. Cause NON verificate (ipotesi: storico tick riscaricato o allungato dal 04/11; dati o versione dell'EA diversi). **Conseguenza**: i rapporti tick/M1 di una sola corsa hanno un margine di incertezza almeno del 5-10% sul netto e del 20% sul DD; letti con questa cautela, i nostri rapporti 0,83-0,92 e 1,02-1,35 restano la fascia giusta. Il confronto fra il DD di Goldbot (0,80) e GTP (1,26) non e un'anomalia certa.

## Cosa NON dice
Un solo anno (2025, oro in rialzo), due passate, un percorso per EA (Randomization 0), senza Daytrade Pro, senza slippage e spread FTMO, senza correlazione P3-P4 (servono le equity), senza P4 tick (attendo il risultato del test a 160k). Non e una garanzia di superare la challenge.
