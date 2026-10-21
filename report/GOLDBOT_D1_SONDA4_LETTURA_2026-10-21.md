# Goldbot One sonda 4: lettura (21/10/2026)

Fonte: `GB4.zip` = `GB4_GOLDBOTONEMT5.zip` (manifest identico). Previsioni: `GOLDBOT_D1_SONDA4_ATTESE_2026-10-21.md`. Non controllata da agenti. Sei passate OHLC 1 minuto, 244-344 s ciascuna, 451 operazioni ovunque, input dei lotti confermati in tutte, 0 stop out. Script del portafoglio: `backtest_pipeline/gb4_port.py` (stesso metodo di `gr80k_port.py`: realizzi giornalieri).

## Numeri (Risk 9999 = LotsizeStep [PROBABILE], MaxRisk 6, StartLots 0,01; XAUUSD D1, 01/2025-10/2026, 80.000 EUR)
| step | netto | PF | DD equity EUR (% di 80K / % picco) | lotti min/med/max | rapporto | long / short |
|---|---|---|---|---|---|---|
| 3000 | +25.157 | 1,83 | 7.282 (9,10% / 7,16%) | 0,07/0,13/0,20 | **2,9** | 22.098 / 4.646 |
| 3500 | +20.933 | 1,83 | 6.122 (7,65% / 6,24%) | 0,05/0,11/0,17 | 3,4 | 18.357 / 3.923 |
| 4000 | +18.406 | 1,87 | 4.968 (6,21% / 5,19%) | 0,04/0,09/0,15 | 3,8 | 16.186 / 3.383 |
| 5000 | +14.047 | 1,86 | 3.757 (4,70% / 4,08%) | 0,03/0,07/0,12 | 4,0 | 12.353 / 2.593 |
| 6000 | +11.173 | 1,84 | 3.213 (4,02% / 3,58%) | 0,03/0,06/0,09 | **3,0** | 9.819 / 2.079 |
| 7500 | +8.498 | 1,84 | 2.462 (3,08% / 2,81%) | 0,02/0,04/0,08 | 4,0 | 7.649 / 1.426 |
Mesi positivi 15/21 ovunque; entrambe le meta' positive; max 8 posizioni insieme; commissioni+swap da -578 a -1.587.

## Cancelli singoli (regole gia' scritte, alla lettera)
S-N 451 ok. S-M 71% ok. S-H ok. **S-DD (<=10% dal deposito, <=15,2% dal picco): passano tutte e sei** (step 3000 al limite, 9,10%). **S-NOSCALA (rapporto <=3): passano step 3000 (2,9) e step 6000 (3,0, sul bordo); le altre 3,4-4,0 no.** Il rapporto max/min dipende da pochi lotti estremi (es. step 3000: lotto 0,07 in 5 operazioni, 0,20 in 5): e' sensibile. S-COSTO (>=3x spread): NON misurato.

## Portafoglio (realizzi giornalieri, 448 giorni, confronto con i test 80K archiviati di Prop Firm e Gold Reaper)
| | step 3000 | step 6000 |
|---|---|---|
| **S-CORR** GB-Gold Reaper giornaliera (IC95) | **0,535** (0,33-0,68) | **0,524** (0,33-0,67) |
| GB-Gold Reaper mensile | 0,598 | 0,583 |
| GB-Prop Firm giornaliera | 0,110 | 0,107 |
| **S-PORT** GB+GR: DD realizzi % di 80K | 5,91% | 4,51% |
| GB+PF | 14,19% | 13,39% |
| PF+GR+GB | 12,11% | 10,52% |
| (PF+GR da sola, gia' misurata) | 10,13% | 10,13% |
- **S-CORR non passa con Gold Reaper** (soglia 0,5; l'intervallo di confidenza scende sotto 0,5 ma il valore centrale no): due EA oro long-biased nello stesso rialzo. Con Prop Firm e' bassa (0,11).
- **S-PORT: il tetto del 10% e' gia' superato da Prop Firm + Gold Reaper (10,13%)**; aggiungere Goldbot One lo porta a 10,5-12,1%. Goldbot One + Gold Reaper senza Prop Firm: 4,5-5,9%.
- Nessuna configurazione passa TUTTI i cancelli. Nessuna taglia e nessun acquisto vengono proposti qui.

## Previsioni
S1 vero. S2 monotonia DD e lotto: vero. S3 DD entro +-40% in 4 passate su 6: vero (6 su 6, entro l'8%); netto entro il 3% della tabella. S4 DD <=10% per step da 3500: vero (e anche 3000: 9,10%). S5 rapporto <=3 per step 3000-4000: solo in parte (2,9; 3,4; 3,8); sopra 3 da 5000 in su: tranne 6000 (3,0). S6 operazioni 440-470 e sotto 10 minuti: vero.

## Limiti
Un solo regime (oro in rialzo; long 82% del profitto). Il ritmo del 2026 e' circa meta' del 2025 (step 3000: 2025 +18.880 su 12 mesi, 2026 +6.382 su 9). NFP filter attivo con AutoGMT non funzionante nel tester (offset 2/3 contro UTC+1): effetto NON misurato. Versione dell'EA 3.3 contro 3.4 del Market [da verificare]. Latenza non misurata. Mappa di Risk [PROBABILE].
