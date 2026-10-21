# Prova a tre regimi dell'oro con tre EA: lettura (21/10/2026)

Fonte: `RG3.zip` (contiene le tre cartelle; gli zip per EA hanno manifest identici). Previsioni: `REGIMI_ORO_TRE_EA_ATTESE_2026-10-21.md`; finestre: `CRITERI_TRE_REGIMI_RIALZO_RIBASSO_LATERALE_2026-10-21.md` par. 8. Non controllata da agenti. 12 passate tutte OK, input imposti confermati dal report 12/12, OHLC a 1 minuto, 53-327 s ciascuna. Analisi: `backtest_pipeline/rg3_an.py`.

## Numeri (80.000 EUR; DD in % di 80.000 e dal picco)
| EA | finestra (R oro) | n | netto | PF | DD equity EUR (% 80K / % picco) | lotti min/med/max, rapp. | long / short |
|---|---|---|---|---|---|---|---|
| Goldbot One step 3000 | RIALZO 2024 (+27,2%) | 265 | +11.632 | 1,68 | 5.050 (6,3% / 5,68%) | 0,12/0,22/0,26, 2,2 | 15.093 / -1.757 |
| Goldbot One step 6000 | RIALZO | 265 | +5.633 | 1,70 | 2.415 (3,0% / 2,86%) | 0,05/0,10/0,13, 2,6 | 7.269 / -825 |
| Goldbot One step 3000 | LATERALE 2022-23 (+7,0%) | 316 | +10.979 | 1,55 | 6.015 (7,5% / 6,78%) | 0,15/0,27/0,34, 2,3 | 7.691 / 5.055 |
| Goldbot One step 6000 | LATERALE | 316 | +5.295 | 1,55 | 2.860 (3,6% / 3,39%) | 0,07/0,13/0,17, 2,4 | 3.700 / 2.453 |
| Goldbot One step 3000 | RIBASSO 2013-14 (-19,6%) | 329 | +18.062 | 2,04 | 6.153 (7,7% / 6,13%) | 0,18/0,39/0,54, 3,0 | 8.458 / 11.068 |
| Goldbot One step 6000 | RIBASSO | 329 | +8.488 | 2,05 | 2.796 (3,5% / 3,12%) | 0,08/0,19/0,24, 3,0 | 3.951 / 5.222 |
| Gold Reaper (set venditore) | RIALZO | 515 | +22.364 | 1,91 | 6.013 (7,5% / 6,02%) | 0,11/0,19/0,53, 4,8; 14 aperte | 20.957 / 3.447 |
| Gold Reaper | LATERALE | 561 | +13.314 | 1,52 | 5.842 (7,3% / 6,77%) | 0,13/0,21/0,61, 4,7; 16 aperte | 10.527 / 4.502 |
| Gold Reaper | RIBASSO | 505 | +25.664 | 1,77 | 6.512 (8,1% / 5,91%) | 0,19/0,47/1,41, 7,4; 17 aperte | 13.415 / 13.696 |
| Prop Firm Gold EA | RIALZO | 426 | +17.981 | 1,29 | 7.073 (8,8% / 8,05%) | 0,30/0,36/0,44, 1,5 | 15.789 / 2.791 |
| Prop Firm Gold EA | LATERALE | 436 | +1.437 | 1,02 | 8.644 (10,8% / 10,29%) | 0,41/0,45/0,49, 1,2 | -909 / 3.106 |
| Prop Firm Gold EA | RIBASSO | 396 | -5.234 | 0,94 | 21.934 (27,4% / 23,25%) | 0,64/0,81/0,93, 1,5 | -18.732 / 14.435 |
Goldbot One: max 8 posizioni aperte insieme; Prop Firm: 3.

## Cosa si legge
- **Goldbot One e Gold Reaper reggono in tutti e tre i regimi** (PF 1,52-2,05, n 265-561, DD <= 8,1% degli 80.000). Nel RIBASSO guadagnano anche dagli short (Goldbot One short +11.068 contro long +8.458; Gold Reaper 13.696 contro 13.415): non seguono solo il mercato. Nel 2025-26 i long erano l'82% del profitto di Goldbot One.
- **Prop Firm Gold EA segue il mercato**: PF 1,29 nel rialzo, 1,02 nel laterale, 0,94 nel ribasso (long -18.732, short +14.435), DD 27,4% degli 80.000 nel ribasso: fuori dal tetto del 10% nel laterale e nel ribasso.
- **Il profitto del RIBASSO e' concentrato**: Goldbot One step 3000 13.860 nel primo semestre (aprile-settembre 2013, l'anno del crollo di aprile) contro 4.391 nel secondo; Gold Reaper 18.779 contro 7.284.

## Cancelli (alla lettera)
- **S-DD** (<=10% dal deposito): passano tutte tranne Prop Firm nel laterale (10,8%) e nel ribasso (27,4%).
- **S-NOSCALA** (rapporto lotti <=3 e <=10 posizioni): Goldbot One passa in tutte (rapporto 2,2-3,0; 3,0 al bordo); **Gold Reaper no** (rapporto 4,7-7,4; 14-17 posizioni aperte insieme); Prop Firm passa.
- **S-CORR (<=0,5 giornaliera, realizzi)**:
| finestra | Goldbot One-Gold Reaper | Goldbot One-Prop Firm | Gold Reaper-Prop Firm |
|---|---|---|---|
| RIALZO 2024 | **0,55** (IC95 0,29-0,71) | 0,22 | 0,24 |
| LATERALE 2022-23 | 0,44 (0,28-0,60) | 0,13 | 0,10 |
| RIBASSO 2013-14 | **0,63** (0,46-0,76) | 0,07 | 0,07 |
 Mensile Goldbot One-Gold Reaper: 0,76 / 0,43 / 0,76. Con il 2025-26 (0,52-0,54): **Goldbot One e Gold Reaper restano correlati attorno a 0,5-0,6 in ogni regime, la correlazione e' PIU' ALTA nel ribasso**. Con Prop Firm la correlazione e' bassa ma Prop Firm perde nel ribasso.
- **S-PORT** (DD combinato realizzi <=10% di 80.000), step 3000 / step 6000 di Goldbot One:
| | RIALZO | LATERALE | RIBASSO |
|---|---|---|---|
| Goldbot One + Gold Reaper | 5,6% / 5,6% | 9,0% / 6,7% | 8,1% / 6,6% |
| Goldbot One + Prop Firm | 12,0% / 9,3% | 10,1% / 9,5% | 21,0% / 22,3% |
| Gold Reaper + Prop Firm | 9,3% | 12,8% | 18,6% |
| tutti e tre | 11,9% / 9,6% | 12,6% / 11,2% | 21,1% / 19,4% |
 **Goldbot One + Gold Reaper passa il tetto in tutte e tre le finestre; qualunque coppia con Prop Firm lo supera nel laterale o nel ribasso.**

## Limite grave di costo (dichiarato)
Lo spread mediano delle barre D1 di Claudio vale: **2024: 5 punti; 2022-23: 0 punti (191 barre su 310 a spread zero, media 2,0); 2013-14: 23 punti; 2025-26: 16**. Se il tester usa lo spread storico delle barre [NON VERIFICATO], il laterale e' stato girato quasi senza spread e il rialzo con costi bassi: i risultati sono **ottimistici** e non confrontabili col 2025-26. Stima [DERIVATA, 1 lotto = 1 USD a punto di spread]: ricalcolando a 16 punti il costo in piu' e' di circa 1.300 USD (Goldbot One step 3000, laterale), 2.200 (Gold Reaper laterale), **3.200 (Prop Firm laterale, che passerebbe da +1.437 a circa -1.700)**; nel ribasso lo spread era gia' piu' alto del 2025-26 (23 contro 16), quindi li' i numeri sono prudenti. Il giudizio "regge fuori dal rialzo" per Goldbot One e Gold Reaper resta, ma con meno margine nel laterale.

## Altri limiti
Un anno per regime; il ribasso e' di 12 anni fa (prezzo 1.300-1.600, struttura diversa); modello OHLC; i tre EA sono prodotti Market (periodo di ottimizzazione ignoto: se e' stato ottimizzato su anni che comprendono queste finestre, il test non e' fuori campione [NON NOTO]); il filtro notizie di Goldbot One nel tester usa offset 2/3 contro UTC+1.

## Previsioni
R1 vero (12/12). R2 vero (tutti n >= 265; il timore di dati mancanti e' smentito). R3: vero rialzo (PF 1,68-1,70) e laterale (1,55), **falso ribasso** (PF 2,04, non < 1). R4 vero (long 43% del profitto nel ribasso). R5 vero (Prop Firm 0,94). **R6 falso** (Goldbot One e Gold Reaper hanno PF >= 1 in tutte e tre). R7: laterale 0,44 vero, **ribasso 0,63 falso**, rialzo 0,55 nella banda attesa. R8 vero.
