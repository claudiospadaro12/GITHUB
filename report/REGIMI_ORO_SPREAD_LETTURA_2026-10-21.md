# Controllo spread della prova a tre regimi: lettura (21/10/2026)

Fonte: `RG4.zip` (+ zip per EA con manifest identici). Previsioni: `REGIMI_ORO_SPREAD_ATTESE_2026-10-21.md`; finestre: `CRITERI_TRE_REGIMI_RIALZO_RIBASSO_LATERALE_2026-10-21.md` par. 9. Non controllata da agenti. 8 passate tutte OK, input confermati 8/8, 0 stop out, OHLC a 1 minuto. Analisi: `backtest_pipeline/rg4_an.py`. Finestre con spread mediano D1 realistico: RIALZO-S 01/08/2019-01/08/2020 (R +39,6%, spread 14), LATERALE-S 01/06/2018-01/06/2019 (R +0,4%, spread 15).

## Numeri (80.000 EUR; DD in % di 80.000 e dal picco)
| EA | finestra | n | netto | PF | DD equity EUR (% 80K / % picco) | lotti rapp. | long / short |
|---|---|---|---|---|---|---|---|
| Goldbot One step 3000 | RIALZO-S | 289 | +15.135 | 1,74 | 5.932 (7,4% / 7,02%) | 2,2 | 21.938 / -2.991 |
| Goldbot One step 6000 | RIALZO-S | 289 | +7.034 | 1,73 | 2.844 (3,6% / 3,46%) | 2,4 | 10.191 / -1.375 |
| Goldbot One step 3000 | LATERALE-S | 279 | +7.818 | 1,51 | 5.856 (7,3% / 6,67%) | 2,2 | 3.500 / 7.170 |
| Goldbot One step 6000 | LATERALE-S | 279 | +3.871 | 1,51 | 2.853 (3,6% / 3,40%) | 2,1 | 1.713 / 3.543 |
| Gold Reaper | RIALZO-S | 457 | +26.410 | 2,18 | 5.125 (6,4% / 5,94%) | 4,5; 11 aperte | 27.589 / 3.401 |
| Gold Reaper | LATERALE-S | 558 | +16.497 | 1,57 | 4.225 (5,3% / 4,93%) | 4,5; 15 aperte | 11.058 / 9.778 |
| Prop Firm Gold EA | RIALZO-S | 435 | +952 | 1,01 | 12.435 (15,5% / 15,10%) | 1,4 | 7.297 / -5.437 |
| Prop Firm Gold EA | LATERALE-S | 491 | -1.782 | 0,97 | 9.658 (12,1% / 11,60%) | 1,2 | -129 / -409 |

## Conclusione
**Con spread realistici (14-15 punti) il quadro della prova RG3 si conferma.** Goldbot One e Gold Reaper hanno PF 1,51-2,18 in entrambe le finestre; nel LATERALE-S gli short di Goldbot One guadagnano piu' dei long (7.170 contro 3.500), come nel ribasso 2013-14. **Prop Firm Gold EA non regge nemmeno nel rialzo 2019-20** (PF 1,01, DD 15,5% di 80.000) e perde nel laterale (PF 0,97): coerente con PF 1,02 nel laterale 2022-23 e 0,94 nel ribasso 2013-14.
Il laterale 2022-23 (spread zero) non era quindi gonfiato in modo da cambiare il giudizio: con spread 15 Goldbot One e Gold Reaper restano a PF >= 1,5.

## Cancelli
- S-DD (<=10% dal deposito): Goldbot One e Gold Reaper passano (3,6-7,4%); **Prop Firm no** (15,5% e 12,1%).
- S-NOSCALA (rapporto lotti <=3 e <=10 posizioni): Goldbot One passa (2,1-2,4); **Gold Reaper no** (rapporto 4,5; 11-15 posizioni aperte); Prop Firm passa.
- **S-CORR giornaliera (<=0,5, realizzi):**
| finestra | Goldbot One-Gold Reaper | Goldbot One-Prop Firm | Gold Reaper-Prop Firm |
|---|---|---|---|
| RIALZO-S 2019-20 | **0,55** (IC95 0,40-0,67) | 0,27 | 0,24 |
| LATERALE-S 2018-19 | **0,41** (0,26-0,54) | 0,30 | 0,32 |
 Mensile Goldbot One-Gold Reaper: 0,85 / 0,52. Nelle sei finestre misurate (2025-26, 2024, 2019-20, 2022-23, 2018-19, 2013-14) la correlazione giornaliera Goldbot One-Gold Reaper va da 0,41 a 0,63: **passa il tetto 0,5 solo nei due laterali (0,44 e 0,41), non nei rialzi (0,52-0,55) ne' nel ribasso (0,63)**.
- **S-PORT (DD combinato realizzi <=10% di 80.000), step 3000 / step 6000:** Goldbot One + Gold Reaper 9,3% / 7,1% (rialzo), 8,2% / 5,5% (laterale): passa in entrambe. Qualunque coppia con Prop Firm: 10,9-15,5%: non passa.

## Previsioni
S1 vero (8/8). S2 vero (Goldbot One PF 1,51-1,74). S3 vero (Gold Reaper 1,57-2,18). S4: PF < 1,1 nel laterale vero (0,97); PF >= 1,2 nel rialzo FALSO (1,01). S5: laterale <= 0,5 vero (0,41); rialzo 0,45-0,70 vero (0,55). S6 vero. S7 vero (Goldbot One <=3, Gold Reaper 4,5). S8 vero (n >= 279; 8 passate OK).

## Limiti
Un anno per finestra; il rialzo 2019-20 contiene il crollo di marzo 2020; modello OHLC; EA Market a periodo di ottimizzazione ignoto; non verificato se il tester usa lo spread storico delle barre (questo controllo non lo dimostra: mostra che con barre a spread 14-15 le conclusioni non cambiano).
