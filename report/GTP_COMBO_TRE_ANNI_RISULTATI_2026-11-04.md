# Gold Trade Pro COMBO su 2013, 2018, 2020 (e 2025 a candele): risultati (04/11/2026)
Zip `ANNO80K_GTPCOMBO_ANNI_20261104_0723`. Criteri e previsioni scritti prima (commit 6746e00d): `GTP_COMBO_TRE_ANNI_CRITERI_2026-11-04.md`. Quattro corse XAUUSD D1, Modello 1, 80.000 EUR, input COMBO (Risk=3, MaxRiskPerStrategy 0,5, PropFirmMaxDailyDD 4,0), stato OK, `input_ok = si`, qualita 99-100%, stop out 0, "no money" 0. Non controllata da agenti. Seconda fase: calcolo mio dai deal dei report (P&L realizzato per giorno, entrata e uscita incluse): Reaper D9 (zip `ANNO80K_TRE_EA_20261026_1444`), Goldbot PF525 (zip `ANNO80K_GOLDBOT_SETVEND_20261030_0145`). **Il Phantom D4 su questi anni non e negli zip che ho: i confronti sono Reaper + Goldbot, non il trio.** I netti coincidono coi riferimenti gia noti (Reaper 2013 +21.757, Goldbot 2013 +17.445).

## GTP COMBO da solo (PROP-ANNI)
| | 2013 | 2018 | 2020 | 2025 (candele) |
|---|---|---|---|---|
| Netto | +14.693 | +8.753 | +6.529 | +8.843 (tick: +8.667) |
| DD equity (report) | 3.615 (4,45%) | 3.169 (3,52%) | 4.969 (5,94%) | 1.535 (1,91%) |
| PF / operazioni | 2,42 / 325 | 1,77 / 330 | 1,79 / 288 | 2,71 / 276 |
| Peggior giorno realizzato | -2.190 (-2,74%) | -1.360 (-1,70%) | -905 (-1,13%) | -818 (-1,02%) |
Passa PROP-ANNI da solo: netto > 0 nei tre anni, DD <= 8.000, nessun giorno >= 5%.

## Con e senza GTP COMBO: giorno peggiore realizzato (somma dei P&L realizzati, senza flottante, senza Guardian)
| Anno | Reaper + Goldbot | Reaper + Goldbot + GTP COMBO | Differenza | Corr. GTP-Reaper / GTP-Goldbot |
|---|---|---|---|---|
| 2013 | -5.64% (-4.509) | **-7.36%** (-5.887) | -1,72 punti | 0,78 / 0,79 |
| 2018 | -2.66% | -4,36% | -1,70 | 0,49 / 0,69 |
| 2020 | -2,03% | -3,04% | -1,01 | 0,59 / 0,60 |
| 2025 | -1,89% | -2,52% | -0,63 | 0,61 / 0,47 |
DD sul saldo realizzato (Reaper+Goldbot -> con GTP): 2013 6.545 -> 9.850; 2018 4.896 -> 5.659; 2020 3.336 -> 4.857; 2025 3.588 -> 4.104. Netto: 2013 +39.201 -> +53.895; 2018 +18.172 -> +26.925; 2020 +32.228 -> +38.757; 2025 +39.456 -> +48.299.

## Previsioni vs realta
H1 valide: SI. H2 netto positivo (60/75/85%): SI, SI, SI. H3 DD <= 8.000 nei tre anni (75%): SI. H4 nessun giorno >= 4.000 del COMBO (85%): SI; peggior giorno 2013 <= 2,5% (65%): **NO** (-2,74%). H5 netto 2025 M1 tra 0,9 e 1,3 volte il tick (65%): SI (1,02). H6 il GTP peggiora il giorno peggiore 2013 di almeno 0,5 punti (45%): **SI** (+1,72), valutato su Reaper + Goldbot. H7 il portafoglio da solo supera il 5% in almeno un anno (30%): **SI** gia con Reaper + Goldbot nel 2013 (-5,64%), senza Phantom ne GTP.

## Lettura
- Il COMBO da solo regge gli anni difficili: nessun anno in perdita, DD sotto 8.000.
- Aggiungerlo a Reaper + Goldbot **peggiora il giorno peggiore di 0,6-1,7 punti in ogni anno**, fino a -7,4% nel 2013 (sopra il 5% di FTMO). La correlazione giornaliera con gli altri due sale fino a 0,78-0,79 nel 2013: nei giorni cattivi perdono insieme. L'argomento "2,78% nel 2025" non vale per gli anni con oro in ribasso.
- **Dato scomodo per il trio gia scelto:** gia Reaper + Goldbot, senza Phantom, hanno -5,64% nel 2013 (realizzato, senza Guardian). A proteggere dal 5% restano i limiti interni degli EA e il Guardian (4,3%), non il portafoglio in se. Il Phantom D4 non e misurabile qui (serie assente negli zip).

## Cosa NON dice
Modello 1 (sottostima i picchi), realizzato senza flottante, un percorso per anno, Phantom assente, Guardian non simulato (nel 2013 avrebbe chiuso tutto a -4,3% prima di quei giorni). Nessun giudizio su acquisti, lotti o taglie.

## Aggiunta 04/11: giorni peggiori del 2013 e perdita dentro la giornata (richiesta di Claudio)
Dai deal dei report (realizzato, ordinato per ora; il flottante non c'e). Giorni con chiusure nel 2013: 138. Sono 4 i giorni peggiori, con o senza GTP: 23/01, 17/07, 18/12, 31/12.
| Giorno | Reaper+Goldbot (minimo corrente = fine giorno) | + GTP COMBO | Supera -4,3% alle (ora server): senza / con GTP |
|---|---|---|---|
| 23/01 | -4,62% | -7,36% | 15:02:40 / 15:02:40 |
| 17/07 | -5,64% | -6,40% | 15:38:40 / 15:38:40 |
| 18/12 | -4,95% | -5,45% | 19:02:40 / 19:02:40 (fine 20:43:40) |
| 31/12 | -5,43% | -7,16% | 15:14:40 / 14:56:40 |
- Il minimo corrente coincide con la chiusura della giornata nei 4 giorni: nessun recupero dentro la giornata. Le perdite si chiudono a grappolo (23/01, 31/12 e 17/07 in pochi minuti; il 18/12 in circa 1,7 ore).
- Giorni con minimo <= -4,3%: 4 con e senza GTP; <= -5%: 2 senza GTP, 4 con GTP.
- Il Guardian (`ABTG_Guardian.mq5`) sorveglia con **OnTimer ogni secondo** (non a ogni tick): sui picchi veloci dell'oro la reazione puo arrivare dopo che i livelli di stop sono gia stati toccati. Il 18/12 (lento) avrebbe tagliato intorno al -4,3% delle 19:02; sui giorni a grappolo veloce non e determinabile da barre M1.

## Aggiunta 04/11 (sera): analisi con tutti e 4 gli EA insieme (Reaper D9 + Goldbot PF525 + Phantom D4 + GTP COMBO)
Phantom D4 (prop combo) 2013/2018/2020/2025 da `risultati_archivio/ANNO80K_SUPER_20261028_1933/PHANTOM/*_M1_PHANTOM_PROPCOMBO_D4` su `lavoro` (netti +3.759, +2.034, +3.926, +5.560: coincidono col riferimento). Script: `GTP_COMBO_TRE_ANNI/analisi_trio_vs_quattro.py`. Realizzato, senza flottante, senza Guardian, Modello 1. Il trio qui e Reaper + Goldbot PF525 + Phantom D4 (stessa combinazione della Free Trial); con Goldbot PF525 il giorno peggiore 2013 del trio e -6,01% (l'analisi del 29/10 su `lavoro` dava -5,20% con misura pessimistica sull'equity e altro set Goldbot).
| Anno | Netto trio / 4 EA | Peggior giorno trio / 4 EA | DD saldo trio / 4 EA | Giorni >=4,3% trio / 4 EA | >=5% |
|---|---|---|---|---|---|
| 2013 | 42.960 / 57.653 | -6,01% / -7,74% | 9,26% / 13,40% | 4 / 4 | 3 / 4 |
| 2018 | 20.206 / 28.959 | -2,94% / -4,64% | 6,61% / 7,65% | 0 / 1 | 0 / 0 |
| 2020 | 36.154 / 42.683 | -2,33% / -3,34% | 4,68% / 6,58% | 0 / 0 | 0 / 0 |
| 2025 | 45.016 / 53.859 | -2,08% / -2,71% | 4,77% / 5,42% | 0 / 0 | 0 / 0 |
Finestre di partenza (80.000 di partenza, peggiore minimo cumulato dall'inizio della finestra; quota di finestre che toccano -9,3%): 2013 14 giorni trio -7,54% (0%), 4 EA -11,22% (2,6%); 30 giorni trio -9,26% (0%), 4 EA -13,40% (5,7%). 2018 14gg -5,94% / -6,68%, 30gg -6,61% / -7,65% (0% -9,3%). 2020 14gg -4,68% / -6,58%, 30gg -4,68% / -6,58% (0%). 2025 14gg -4,18% / -4,83%, 30gg -4,77% / -5,42% (0%).
2013, i giorni peggiori (trio, minimo corrente = fine giorno; ora server del -4,3%): 31/12 -6,01% (15:00), 17/07 -5,96% (15:38), 18/12 -5,52% (19:02), 23/01 -4,87% (15:02). Con GTP: 31/12 -7,74% (14:56), 23/01 -7,61% (15:02), 17/07 -6,72% (15:38), 18/12 -6,02% (19:02).
