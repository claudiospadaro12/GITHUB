# EMA200 e il RIMBALZO misurato come FENOMENO: la MISURA (01/10/2026)

1. **"Dopo il primo tocco la EMA200 respinge il prezzo quasi sempre" e' FALSO nella forma forte**, su DAX, S&P e oro (due feed), M5-M15-H1, tutti e due i lati: alla cella simmetrica (rimbalzo di 1 ATR prima di uno sfondamento di 1 ATR) la P va da **0,403 a 0,545** su 21 celle con n >= 150; l'estremo alto dell'IC piu' alto e' **0,622**. L'ipotesi presa alla lettera chiedeva **>= 0,75**. Nessuna cella esce **EFFETTO**: 13 NULLO, 8 ZONA GRIGIA, |effetto| contro i surrogati **<= 0,052**.
2. **L'"80%" della collega e' quello che fa gia' una passeggiata casuale, e il mercato vero fa MENO**: alla cella (0,25 ATR di rimbalzo contro 1,0 di sfondamento) il random walk da' 0,800; i dati veri **0,649-0,786** (21 righe su 21 sotto lo 0,80), e i surrogati lo stesso. Il motivo e' misurato: a M5 il **9-23%** degli sfondamenti avviene GIA' nel minuto del tocco (minuti violenti), e succede a qualunque linea lenta, non alla 200.
3. **"Lo sfondamento viene ritestato prima di proseguire": no, solo il 33-43% delle volte** (b 0,5 / tol 0,10 / Z 1,5 ATR), in linea col null per evento (0,32-0,42) e coi surrogati: 12 NULLO, 8 ZONA GRIGIA, nessun EFFETTO. Il 0,714 dello stato dell'arte supponeva lo sfondamento a 0,5 ATR: quelli veri chiudono in media a ~1,0 ATR, e il 10-29% e' gia' oltre 1,5 ATR alla chiusura; anche togliendo quelli, il ritest arriva nel 41-51% dei casi.
4. **H3 (sui TF alti la 200 "e' forte"): NON ANCORA MISURATO.** Da M5 a H1 l'effetto e' piatto (entro +/-0,053, nessuna salita); a **H4 e D1 il "primo tocco" e' troppo raro** (n 28-108 per lato a H4, 1-20 a D1, contro 150) anche con 14 anni di oro. Unico indizio da rimisurare: **oro H1 lato long, due feed, +0,049 e +0,037** (ZONA GRIGIA, lato unico).
5. **Non raggiunti da qui: Nasdaq e Dow** (nessun mirror; Nasdaq solo sul PC di backtest, Dow esterno inesistente). S&P letto come lettura SECONDARIA (cancello d'orologio congelato fallito per un'ancora mancante, spostamento stagionale giusto: classe 1036). Zero tester, zero VPS, nessun EA/preset/conto toccato.

---

Criteri congelati PRIMA dei numeri: `report/EMA200_RIMBALZO_CRITERI_2026-10-01.md` (commit `c23bfe61`, pushato prima della prima corsa su dati veri).
Strumento: `backtest_pipeline/ema200_rimbalzo.py` (MARCATORE_EMA200_RIMBALZO_v1, SHA256 `dd4fb376...9eb2`), autotest **21/21**.
Archivio: `backtest_pipeline/risultati_archivio/EMA200_RIMBALZO_2026-10-01/` (4 CSV con tutte le celle, referti, log, autotest).
Classi nuove in `CHECKLIST_RIGA_DI_LANCIO.md`: **1034-1037** (i criteri congelati citano la prima come "1019": il numero e' stato preso lo stesso giorno da un altro agente, rinumerata senza cambiarne il contenuto).
Etichette: [MISURATO] dai CSV di questa corsa; [DERIVATO] calcolo da numeri misurati; [NON MISURATO].

## 0. Che cosa vale questo referto (e che cosa NO)

- E' una misura del **fenomeno**, non di un motore: niente PF, niente equity, niente costo dentro la P. Non dice se `ABTG_EMA200` guadagna, non sceglie parametri, non tocca la sedia 771531.
- Il verdetto si legge sulla **cella primaria congelata** (X = Y = 1,0 ATR), mai sulla migliore. Le altre celle sono nei CSV e non promuovono nulla.
- La parola **"falso"** al punto 1 riguarda la forma FORTE (P >= 0,75, quella che la collega descrive), che sta fuori da ogni IC. La forma DEBOLE (un effetto di pochi punti) **non** e' esclusa per le regole congelate: 8 celle su 21 stanno in ZONA GRIGIA. Si scrive "NON ANCORA MISURATO" per quella, non "morto".

## 1. Dati, orologio, regime (dichiarati)

| simbolo / feed | finestra (UTC) | barre M1 | orologio | regimi per anno (rendimento close-to-close) |
|---|---|---|---|---|
| DAX `GRXEUR` HistData (FutureSharks, GPL-3.0) | 2010-11-15 -> 2018-12-28 | 1.718.805 | G-OROLOGIO **PASSA**: picco inverno 07:00, estate 06:00 (-60) | 2010 LAT +3,3 · 2011 ORSO -15,8 · 2012 TORO +29,3 · 2013 TORO +26,1 · 2014 LAT +1,7 · 2015 LAT +9,2 · 2016 LAT +9,1 · 2017 TORO +12,6 · 2018 ORSO -18,2 |
| S&P `SPXUSD` HistData | 2010-11-14 -> 2018-12-31 | 2.117.667 | congelato **FALLISCE** (picco 15:00 = 10:00 NY, non in lista); spostamento -60 giusto; letto come **lettura SECONDARIA** con ancora 15:00 aggiunta a posteriori | 2010 LAT +4,9 · 2011 LAT -0,2 · 2012 TORO +11,5 · 2013 TORO +29,5 · 2014 TORO +11,1 · 2015 LAT -0,9 · 2016 LAT +9,6 · 2017 TORO +19,1 · 2018 ORSO -5,9 |
| Oro A: Oanda `XAU_USD` (FutureSharks) | 2006-03-19 -> 2020-05-14 | 4.884.366 | **PASSA**: 13:30 / 12:30 | 2006 TORO · 2007 TORO · 2008 LAT · 2009-2011 TORO · 2012 LAT · 2013 ORSO -28,0 · 2014 LAT · 2015 ORSO -10,4 · 2016 LAT · 2017 TORO · 2018 LAT · 2019-2020 TORO |
| Oro B: HistData (zip in repo, portati in UTC) | 2021-01-03 -> 2026-09-18 | 1.979.587 | **PASSA**: 13:30 / 12:30 | 2021 LAT -4,0 · 2022 LAT -0,3 · 2023 TORO +12,9 · 2024 TORO +27,2 · 2025 TORO +64,5 · 2026 LAT +1,2 |

I due feed dell'oro non sono mai concatenati (regola R80): sono **gemelli di feed**, non un simbolo in piu'. Barre del TF costruite su UTC+1 fisso (orologio BCM di oggi). Le prime 600 barre di ogni TF non producono eventi. Classe "crollo": non separabile con n >= 150 (buco dichiarato). Nessun ORSO nell'oro B.

## 2. H1 -- il RIMBALZO dopo il primo tocco

Definizione (criteri sez. 3): primo tocco = barra che tocca la EMA200 della barra precedente dopo 20 barre senza contatto, con almeno una chiusura a >= 1 ATR; esiti risolti sui minuti M1 con livello e ATR congelati; B = rimbalzo di X ATR, P = sfondamento di Y ATR, AMB e timeout a parte (nei CSV). P = B/(B+P). IC Wilson 95%. Surrogati: 40 a M5/M15, 100 a H1/H4/D1, blocchi di 40 barre del TF.

### T1. H1 -- CELLA PRIMARIA (X = 1,0 ATR rimbalzo, Y = 1,0 ATR sfondamento; N0 = 0,500)

| TF | simbolo / feed | lato | n | P | IC95 | N0 | surr. mediana [p2,5; p97,5] | effetto | verdetto |
|---|---|---|---|---|---|---|---|---|---|
| M5 | DAX (D30EUR) | long | 1571 | 0.472 | 0.447-0.496 | 0.500 | 0.452 [0.438; 0.473] | +0.020 | NULLO |
| M5 | DAX (D30EUR) | short | 1373 | 0.425 | 0.399-0.451 | 0.500 | 0.439 [0.405; 0.456] | -0.014 | NULLO |
| M5 | S&P (SPXUSD) [sec.] | long | 2475 | 0.468 | 0.449-0.488 | 0.500 | 0.456 [0.433; 0.474] | +0.013 | NULLO |
| M5 | S&P (SPXUSD) [sec.] | short | 2167 | 0.464 | 0.443-0.485 | 0.500 | 0.440 [0.422; 0.456] | +0.024 | ZONA GRIGIA |
| M5 | Oro A (Oanda 06-20) | long | 4448 | 0.478 | 0.464-0.493 | 0.500 | 0.456 [0.447; 0.469] | +0.022 | ZONA GRIGIA |
| M5 | Oro A (Oanda 06-20) | short | 4201 | 0.482 | 0.467-0.497 | 0.500 | 0.453 [0.439; 0.462] | +0.029 | ZONA GRIGIA |
| M5 | Oro B (HistData 21-26) | long | 1753 | 0.479 | 0.456-0.503 | 0.500 | 0.486 [0.471; 0.510] | -0.006 | NULLO |
| M5 | Oro B (HistData 21-26) | short | 1619 | 0.473 | 0.449-0.497 | 0.500 | 0.472 [0.457; 0.494] | +0.001 | NULLO |
| M15 | DAX (D30EUR) | long | 545 | 0.468 | 0.426-0.510 | 0.500 | 0.453 [0.421; 0.497] | +0.015 | NULLO |
| M15 | DAX (D30EUR) | short | 489 | 0.403 | 0.360-0.447 | 0.500 | 0.432 [0.381; 0.479] | -0.029 | NULLO |
| M15 | S&P (SPXUSD) [sec.] | long | 897 | 0.475 | 0.442-0.508 | 0.500 | 0.476 [0.449; 0.503] | -0.001 | NULLO |
| M15 | S&P (SPXUSD) [sec.] | short | 733 | 0.458 | 0.423-0.495 | 0.500 | 0.454 [0.423; 0.485] | +0.004 | NULLO |
| M15 | Oro A (Oanda 06-20) | long | 1488 | 0.489 | 0.463-0.514 | 0.500 | 0.478 [0.463; 0.509] | +0.011 | NULLO |
| M15 | Oro A (Oanda 06-20) | short | 1387 | 0.471 | 0.445-0.497 | 0.500 | 0.472 [0.450; 0.491] | -0.001 | NULLO |
| M15 | Oro B (HistData 21-26) | long | 579 | 0.503 | 0.462-0.543 | 0.500 | 0.497 [0.460; 0.521] | +0.006 | NULLO |
| M15 | Oro B (HistData 21-26) | short | 553 | 0.447 | 0.406-0.488 | 0.500 | 0.477 [0.440; 0.517] | -0.030 | ZONA GRIGIA |
| H1 | DAX (D30EUR) | long | 149 | 0.436 | 0.359-0.516 | 0.500 | 0.461 [0.380; 0.529] | -0.025 | NON ANCORA MISURATO |
| H1 | DAX (D30EUR) | short | 120 | 0.367 | 0.286-0.456 | 0.500 | 0.424 [0.355; 0.512] | -0.058 | NON ANCORA MISURATO |
| H1 | S&P (SPXUSD) [sec.] | long | 262 | 0.427 | 0.369-0.488 | 0.500 | 0.479 [0.419; 0.545] | -0.052 | ZONA GRIGIA |
| H1 | S&P (SPXUSD) [sec.] | short | 187 | 0.444 | 0.374-0.515 | 0.500 | 0.452 [0.364; 0.510] | -0.008 | ZONA GRIGIA |
| H1 | Oro A (Oanda 06-20) | long | 417 | 0.537 | 0.489-0.585 | 0.500 | 0.488 [0.453; 0.541] | +0.049 | ZONA GRIGIA |
| H1 | Oro A (Oanda 06-20) | short | 378 | 0.468 | 0.418-0.519 | 0.500 | 0.467 [0.429; 0.521] | +0.002 | NULLO |
| H1 | Oro B (HistData 21-26) | long | 154 | 0.545 | 0.467-0.622 | 0.500 | 0.508 [0.428; 0.572] | +0.037 | ZONA GRIGIA |
| H1 | Oro B (HistData 21-26) | short | 123 | 0.488 | 0.401-0.575 | 0.500 | 0.470 [0.391; 0.551] | +0.018 | NON ANCORA MISURATO |
| H4 | DAX (D30EUR) | long | 42 | 0.381 | 0.250-0.532 | 0.500 | 0.463 [0.349; 0.624] | -0.083 | NON ANCORA MISURATO |
| H4 | DAX (D30EUR) | short | 33 | 0.333 | 0.198-0.504 | 0.500 | 0.429 [0.257; 0.563] | -0.095 | NON ANCORA MISURATO |
| H4 | S&P (SPXUSD) [sec.] | long | 68 | 0.426 | 0.316-0.545 | 0.500 | 0.491 [0.364; 0.612] | -0.065 | NON ANCORA MISURATO |
| H4 | S&P (SPXUSD) [sec.] | short | 41 | 0.390 | 0.257-0.543 | 0.500 | 0.456 [0.309; 0.563] | -0.065 | NON ANCORA MISURATO |
| H4 | Oro A (Oanda 06-20) | long | 108 | 0.472 | 0.381-0.566 | 0.500 | 0.471 [0.372; 0.569] | +0.001 | NON ANCORA MISURATO |
| H4 | Oro A (Oanda 06-20) | short | 96 | 0.542 | 0.442-0.638 | 0.500 | 0.439 [0.361; 0.529] | +0.102 | NON ANCORA MISURATO |
| H4 | Oro B (HistData 21-26) | long | 38 | 0.474 | 0.325-0.627 | 0.500 | 0.495 [0.356; 0.622] | -0.022 | NON ANCORA MISURATO |
| H4 | Oro B (HistData 21-26) | short | 28 | 0.500 | 0.326-0.674 | 0.500 | 0.455 [0.304; 0.607] | +0.045 | NON ANCORA MISURATO |
| D1 | DAX (D30EUR) | long | 10 | 0.600 | 0.313-0.832 | 0.500 | 0.500 [0.000; 0.800] | +0.100 | NON ANCORA MISURATO |
| D1 | DAX (D30EUR) | short | 4 | 0.250 | 0.046-0.699 | 0.500 | 0.500 [0.000; 1.000] | -0.250 | NON ANCORA MISURATO |
| D1 | S&P (SPXUSD) [sec.] | long | 8 | 0.500 | 0.215-0.785 | 0.500 | 0.538 [0.235; 0.800] | -0.038 | NON ANCORA MISURATO |
| D1 | S&P (SPXUSD) [sec.] | short | 2 | 0.000 | 0.000-0.658 | 0.500 | 0.333 [0.000; 1.000] | -0.333 | NON ANCORA MISURATO |
| D1 | Oro A (Oanda 06-20) | long | 20 | 0.550 | 0.342-0.742 | 0.500 | 0.500 [0.307; 0.703] | +0.050 | NON ANCORA MISURATO |
| D1 | Oro A (Oanda 06-20) | short | 14 | 0.357 | 0.163-0.612 | 0.500 | 0.417 [0.201; 0.647] | -0.059 | NON ANCORA MISURATO |
| D1 | Oro B (HistData 21-26) | long | 5 | 0.600 | 0.231-0.882 | 0.500 | 0.556 [0.000; 1.000] | +0.044 | NON ANCORA MISURATO |
| D1 | Oro B (HistData 21-26) | short | 1 | 0.000 | 0.000-0.793 | 0.500 | 0.333 [0.000; 1.000] | -0.333 | NON ANCORA MISURATO |

Lettura: **nessuna cella supera 0,545**; il null analitico e' 0,500 e i surrogati stanno a 0,43-0,51. A M5-M15 la P vera e quella dei surrogati stanno quasi sempre SOTTO 0,50 (fino a 10 punti), insieme: e' il mercato (sez. 7, minuti violenti), non la media. Le ZONA GRIGIA a M5 sono di +0,022..+0,029 e hanno **la stessa inclinazione sui placebo** (sez. 5): non sono della 200.

### T2. H1 -- CELLA DELLA COLLEGA (X = 0,25, Y = 1,0; N0 = 0,800) -- descrittiva

| TF | simbolo / feed | lato | n | P | IC95 | N0 | surr. mediana [p2,5; p97,5] | effetto | verdetto |
|---|---|---|---|---|---|---|---|---|---|
| M5 | DAX (D30EUR) | long | 1554 | 0.676 | 0.652-0.699 | 0.800 | 0.659 [0.642; 0.684] | +0.017 | NULLO |
| M5 | DAX (D30EUR) | short | 1369 | 0.649 | 0.624-0.674 | 0.800 | 0.650 [0.620; 0.672] | -0.001 | NULLO |
| M5 | S&P (SPXUSD) [sec.] | long | 2459 | 0.675 | 0.657-0.694 | 0.800 | 0.647 [0.633; 0.670] | +0.028 | ZONA GRIGIA |
| M5 | S&P (SPXUSD) [sec.] | short | 2159 | 0.653 | 0.632-0.672 | 0.800 | 0.637 [0.619; 0.655] | +0.015 | NULLO |
| M5 | Oro A (Oanda 06-20) | long | 4407 | 0.684 | 0.670-0.697 | 0.800 | 0.648 [0.636; 0.661] | +0.035 | ZONA GRIGIA |
| M5 | Oro A (Oanda 06-20) | short | 4176 | 0.681 | 0.666-0.695 | 0.800 | 0.654 [0.638; 0.666] | +0.027 | ZONA GRIGIA |
| M5 | Oro B (HistData 21-26) | long | 1748 | 0.727 | 0.706-0.748 | 0.800 | 0.712 [0.692; 0.726] | +0.015 | ZONA GRIGIA |
| M5 | Oro B (HistData 21-26) | short | 1620 | 0.714 | 0.691-0.735 | 0.800 | 0.718 [0.702; 0.736] | -0.004 | NULLO |
| M15 | DAX (D30EUR) | long | 543 | 0.685 | 0.645-0.723 | 0.800 | 0.690 [0.656; 0.723] | -0.005 | NULLO |
| M15 | DAX (D30EUR) | short | 493 | 0.661 | 0.618-0.702 | 0.800 | 0.664 [0.628; 0.704] | -0.003 | NULLO |
| M15 | S&P (SPXUSD) [sec.] | long | 899 | 0.710 | 0.679-0.738 | 0.800 | 0.703 [0.676; 0.733] | +0.007 | NULLO |
| M15 | S&P (SPXUSD) [sec.] | short | 740 | 0.722 | 0.688-0.753 | 0.800 | 0.692 [0.657; 0.716] | +0.030 | ZONA GRIGIA |
| M15 | Oro A (Oanda 06-20) | long | 1487 | 0.736 | 0.713-0.758 | 0.800 | 0.701 [0.685; 0.733] | +0.035 | ZONA GRIGIA |
| M15 | Oro A (Oanda 06-20) | short | 1391 | 0.710 | 0.685-0.733 | 0.800 | 0.700 [0.679; 0.720] | +0.010 | NULLO |
| M15 | Oro B (HistData 21-26) | long | 575 | 0.758 | 0.722-0.791 | 0.800 | 0.745 [0.711; 0.774] | +0.014 | NULLO |
| M15 | Oro B (HistData 21-26) | short | 558 | 0.735 | 0.697-0.770 | 0.800 | 0.737 [0.711; 0.771] | -0.002 | NULLO |
| H1 | DAX (D30EUR) | long | 149 | 0.698 | 0.620-0.766 | 0.800 | 0.733 [0.658; 0.788] | -0.035 | NON ANCORA MISURATO |
| H1 | DAX (D30EUR) | short | 120 | 0.692 | 0.604-0.767 | 0.800 | 0.701 [0.628; 0.765] | -0.009 | NON ANCORA MISURATO |
| H1 | S&P (SPXUSD) [sec.] | long | 262 | 0.706 | 0.648-0.758 | 0.800 | 0.738 [0.692; 0.791] | -0.032 | ZONA GRIGIA |
| H1 | S&P (SPXUSD) [sec.] | short | 187 | 0.765 | 0.699-0.820 | 0.800 | 0.726 [0.669; 0.783] | +0.039 | ZONA GRIGIA |
| H1 | Oro A (Oanda 06-20) | long | 415 | 0.742 | 0.698-0.782 | 0.800 | 0.738 [0.693; 0.779] | +0.004 | NULLO |
| H1 | Oro A (Oanda 06-20) | short | 379 | 0.736 | 0.690-0.778 | 0.800 | 0.728 [0.690; 0.772] | +0.008 | NULLO |
| H1 | Oro B (HistData 21-26) | long | 154 | 0.786 | 0.714-0.843 | 0.800 | 0.766 [0.703; 0.815] | +0.019 | ZONA GRIGIA |
| H1 | Oro B (HistData 21-26) | short | 124 | 0.758 | 0.676-0.825 | 0.800 | 0.743 [0.671; 0.817] | +0.015 | NON ANCORA MISURATO |
| H4 | DAX (D30EUR) | long | 42 | 0.667 | 0.515-0.790 | 0.800 | 0.758 [0.651; 0.848] | -0.091 | NON ANCORA MISURATO |
| H4 | DAX (D30EUR) | short | 33 | 0.788 | 0.623-0.893 | 0.800 | 0.681 [0.500; 0.848] | +0.107 | NON ANCORA MISURATO |
| H4 | S&P (SPXUSD) [sec.] | long | 68 | 0.750 | 0.636-0.838 | 0.800 | 0.767 [0.676; 0.867] | -0.017 | NON ANCORA MISURATO |
| H4 | S&P (SPXUSD) [sec.] | short | 41 | 0.756 | 0.607-0.862 | 0.800 | 0.760 [0.637; 0.863] | -0.004 | NON ANCORA MISURATO |
| H4 | Oro A (Oanda 06-20) | long | 108 | 0.713 | 0.622-0.790 | 0.800 | 0.762 [0.696; 0.827] | -0.049 | NON ANCORA MISURATO |
| H4 | Oro A (Oanda 06-20) | short | 97 | 0.794 | 0.703-0.862 | 0.800 | 0.738 [0.662; 0.835] | +0.055 | NON ANCORA MISURATO |
| H4 | Oro B (HistData 21-26) | long | 38 | 0.868 | 0.727-0.943 | 0.800 | 0.806 [0.667; 0.935] | +0.062 | NON ANCORA MISURATO |
| H4 | Oro B (HistData 21-26) | short | 29 | 0.724 | 0.543-0.853 | 0.800 | 0.765 [0.599; 0.902] | -0.041 | NON ANCORA MISURATO |
| D1 | DAX (D30EUR) | long | 10 | 0.900 | 0.596-0.982 | 0.800 | 0.750 [0.333; 1.000] | +0.150 | NON ANCORA MISURATO |
| D1 | DAX (D30EUR) | short | 4 | 0.500 | 0.150-0.850 | 0.800 | 0.750 [0.290; 1.000] | -0.250 | NON ANCORA MISURATO |
| D1 | S&P (SPXUSD) [sec.] | long | 8 | 0.750 | 0.409-0.928 | 0.800 | 0.867 [0.591; 1.000] | -0.117 | NON ANCORA MISURATO |
| D1 | S&P (SPXUSD) [sec.] | short | 2 | 1.000 | 0.342-1.000 | 0.800 | 0.800 [0.250; 1.000] | +0.200 | NON ANCORA MISURATO |
| D1 | Oro A (Oanda 06-20) | long | 20 | 0.700 | 0.481-0.855 | 0.800 | 0.800 [0.625; 0.952] | -0.100 | NON ANCORA MISURATO |
| D1 | Oro A (Oanda 06-20) | short | 14 | 0.857 | 0.601-0.960 | 0.800 | 0.765 [0.550; 1.000] | +0.092 | NON ANCORA MISURATO |
| D1 | Oro B (HistData 21-26) | long | 5 | 0.800 | 0.376-0.964 | 0.800 | 0.800 [0.500; 1.000] | +0.000 | NON ANCORA MISURATO |
| D1 | Oro B (HistData 21-26) | short | 1 | 1.000 | 0.206-1.000 | 0.800 | 0.775 [0.000; 1.000] | +0.225 | NON ANCORA MISURATO |

Lettura: la cella della collega **non arriva mai a 0,80**, che e' quanto fa il random walk (e l'autotest lo riproduce: 0,823 / 0,785). Il "rimbalza quasi sempre di pochi punti" e' **peggio** di una moneta truccata dalla geometria: 0,649-0,786. Il criterio congelato per dargli contenuto (>= 0,85 e sopra p97,5) non e' raggiunto da nessuna riga (P massima 0,786, IC alto massimo 0,843).

## 3. H2 -- lo SFONDAMENTO e il RITEST

### T3. H2 -- SFONDAMENTO E RITEST (b = 0,5, tol = 0,10, Z = 1,5; N0 = media per evento)

| TF | simbolo / feed | lato | n | P | IC95 | N0 | surr. mediana [p2,5; p97,5] | effetto | verdetto |
|---|---|---|---|---|---|---|---|---|---|
| M5 | DAX (D30EUR) | giu | 1359 | 0.380 | 0.355-0.406 | 0.364 | 0.362 [0.336; 0.384] | +0.018 | NULLO |
| M5 | DAX (D30EUR) | su | 1273 | 0.389 | 0.362-0.416 | 0.378 | 0.365 [0.347; 0.396] | +0.024 | NULLO |
| M5 | S&P (SPXUSD) [sec.] | giu | 2192 | 0.396 | 0.375-0.416 | 0.379 | 0.387 [0.366; 0.404] | +0.009 | NULLO |
| M5 | S&P (SPXUSD) [sec.] | su | 1999 | 0.421 | 0.400-0.443 | 0.384 | 0.390 [0.378; 0.412] | +0.031 | ZONA GRIGIA |
| M5 | Oro A (Oanda 06-20) | giu | 3897 | 0.407 | 0.392-0.423 | 0.380 | 0.381 [0.371; 0.398] | +0.026 | ZONA GRIGIA |
| M5 | Oro A (Oanda 06-20) | su | 3808 | 0.412 | 0.397-0.428 | 0.381 | 0.386 [0.372; 0.398] | +0.026 | ZONA GRIGIA |
| M5 | Oro B (HistData 21-26) | giu | 1572 | 0.425 | 0.401-0.450 | 0.411 | 0.401 [0.384; 0.422] | +0.024 | ZONA GRIGIA |
| M5 | Oro B (HistData 21-26) | su | 1500 | 0.424 | 0.399-0.449 | 0.423 | 0.411 [0.393; 0.429] | +0.013 | NULLO |
| M15 | DAX (D30EUR) | giu | 460 | 0.356 | 0.314-0.401 | 0.322 | 0.351 [0.312; 0.390] | +0.006 | NULLO |
| M15 | DAX (D30EUR) | su | 450 | 0.344 | 0.302-0.390 | 0.349 | 0.366 [0.312; 0.390] | -0.022 | NULLO |
| M15 | S&P (SPXUSD) [sec.] | giu | 787 | 0.395 | 0.362-0.430 | 0.377 | 0.374 [0.340; 0.399] | +0.021 | NULLO |
| M15 | S&P (SPXUSD) [sec.] | su | 691 | 0.411 | 0.375-0.448 | 0.387 | 0.384 [0.354; 0.416] | +0.027 | NULLO |
| M15 | Oro A (Oanda 06-20) | giu | 1283 | 0.407 | 0.380-0.434 | 0.373 | 0.386 [0.352; 0.406] | +0.021 | ZONA GRIGIA |
| M15 | Oro A (Oanda 06-20) | su | 1225 | 0.384 | 0.357-0.411 | 0.377 | 0.392 [0.364; 0.411] | -0.008 | NULLO |
| M15 | Oro B (HistData 21-26) | giu | 515 | 0.425 | 0.383-0.468 | 0.402 | 0.392 [0.356; 0.437] | +0.033 | ZONA GRIGIA |
| M15 | Oro B (HistData 21-26) | su | 502 | 0.416 | 0.374-0.460 | 0.407 | 0.398 [0.351; 0.429] | +0.018 | NULLO |
| H1 | DAX (D30EUR) | giu | 127 | 0.354 | 0.277-0.441 | 0.365 | 0.358 [0.266; 0.444] | -0.004 | NON ANCORA MISURATO |
| H1 | DAX (D30EUR) | su | 119 | 0.294 | 0.220-0.381 | 0.416 | 0.368 [0.294; 0.431] | -0.074 | NON ANCORA MISURATO |
| H1 | S&P (SPXUSD) [sec.] | giu | 228 | 0.360 | 0.300-0.424 | 0.341 | 0.350 [0.300; 0.403] | +0.009 | ZONA GRIGIA |
| H1 | S&P (SPXUSD) [sec.] | su | 182 | 0.335 | 0.271-0.406 | 0.362 | 0.380 [0.315; 0.455] | -0.045 | ZONA GRIGIA |
| H1 | Oro A (Oanda 06-20) | giu | 341 | 0.337 | 0.289-0.389 | 0.319 | 0.366 [0.314; 0.414] | -0.028 | NULLO |
| H1 | Oro A (Oanda 06-20) | su | 333 | 0.336 | 0.288-0.389 | 0.342 | 0.366 [0.313; 0.407] | -0.030 | NULLO |
| H1 | Oro B (HistData 21-26) | giu | 121 | 0.380 | 0.299-0.469 | 0.396 | 0.369 [0.290; 0.459] | +0.012 | NON ANCORA MISURATO |
| H1 | Oro B (HistData 21-26) | su | 117 | 0.427 | 0.341-0.518 | 0.391 | 0.382 [0.295; 0.456] | +0.045 | NON ANCORA MISURATO |
| H4 | DAX (D30EUR) | giu | 41 | 0.293 | 0.176-0.445 | 0.353 | 0.382 [0.220; 0.476] | -0.090 | NON ANCORA MISURATO |
| H4 | DAX (D30EUR) | su | 37 | 0.324 | 0.196-0.485 | 0.430 | 0.382 [0.253; 0.556] | -0.058 | NON ANCORA MISURATO |
| H4 | S&P (SPXUSD) [sec.] | giu | 56 | 0.518 | 0.390-0.643 | 0.415 | 0.389 [0.274; 0.505] | +0.129 | NON ANCORA MISURATO |
| H4 | S&P (SPXUSD) [sec.] | su | 44 | 0.386 | 0.257-0.534 | 0.402 | 0.430 [0.286; 0.584] | -0.044 | NON ANCORA MISURATO |
| H4 | Oro A (Oanda 06-20) | giu | 94 | 0.415 | 0.321-0.516 | 0.393 | 0.353 [0.279; 0.452] | +0.062 | NON ANCORA MISURATO |
| H4 | Oro A (Oanda 06-20) | su | 88 | 0.364 | 0.271-0.468 | 0.422 | 0.386 [0.266; 0.489] | -0.022 | NON ANCORA MISURATO |
| H4 | Oro B (HistData 21-26) | giu | 36 | 0.583 | 0.422-0.729 | 0.490 | 0.375 [0.243; 0.536] | +0.208 | NON ANCORA MISURATO |
| H4 | Oro B (HistData 21-26) | su | 28 | 0.393 | 0.236-0.576 | 0.435 | 0.362 [0.163; 0.523] | +0.030 | NON ANCORA MISURATO |
| D1 | DAX (D30EUR) | giu | 7 | 0.143 | 0.026-0.513 | 0.325 | 0.333 [0.000; 0.800] | -0.191 | NON ANCORA MISURATO |
| D1 | DAX (D30EUR) | su | 4 | 0.000 | 0.000-0.490 | 0.235 | 0.400 [0.000; 1.000] | -0.400 | NON ANCORA MISURATO |
| D1 | S&P (SPXUSD) [sec.] | giu | 7 | 0.429 | 0.158-0.750 | 0.498 | 0.400 [0.048; 0.733] | +0.029 | NON ANCORA MISURATO |
| D1 | S&P (SPXUSD) [sec.] | su | 2 | 0.000 | 0.000-0.658 | 0.203 | 0.464 [0.000; 0.921] | -0.464 | NON ANCORA MISURATO |
| D1 | Oro A (Oanda 06-20) | giu | 15 | 0.400 | 0.198-0.642 | 0.439 | 0.394 [0.186; 0.600] | +0.006 | NON ANCORA MISURATO |
| D1 | Oro A (Oanda 06-20) | su | 13 | 0.385 | 0.177-0.645 | 0.414 | 0.400 [0.174; 0.684] | -0.015 | NON ANCORA MISURATO |
| D1 | Oro B (HistData 21-26) | giu | 2 | 0.000 | 0.000-0.658 | 0.442 | 0.367 [0.000; 1.000] | -0.367 | NON ANCORA MISURATO |
| D1 | Oro B (HistData 21-26) | su | 1 | 0.000 | 0.000-0.793 | 0.702 | 0.400 [0.000; 1.000] | -0.400 | NON ANCORA MISURATO |

Lettura: lo sfondamento torna sulla media (entro 0,10 ATR) prima di correre a 1,5 ATR nel **33-43%** dei casi. Il null per evento (0,32-0,42) e' basso perche' la chiusura di sfondamento sta in media a ~1,0 ATR dalla media [DERIVATO: d0 = 1,5 - 1,4 x null], e il **10-29%** e' gia' oltre 1,5 ATR alla chiusura (contato come fuga). Togliendo quelli, ritest nel 41-51%. **"Difficilissimo superarla senza ritest" non regge: piu' della meta' degli sfondamenti prosegue senza ritest.** A M5-M15 c'e' un'inclinazione positiva piccola (+0,02 in 14 righe su 16) che si ripete identica sui placebo (sez. 5).

## 4. H3 -- il GRADIENTE per TF

### T4. H3 -- effetto (P - mediana surrogati) per TF, cella primaria H1 e H2; tra parentesi n; '-' = n < 150

| simbolo / feed | ipotesi | lato | M5 | M15 | H1 | H4 | D1 |
|---|---|---|---|---|---|---|---|
| DAX (D30EUR) | rimbalzo | long | +0.020 (1571) | +0.015 (545) | - (149) | - (42) | - (10) |
| DAX (D30EUR) | rimbalzo | short | -0.014 (1373) | -0.029 (489) | - (120) | - (33) | - (4) |
| DAX (D30EUR) | ritest | giu | +0.018 (1359) | +0.006 (460) | - (127) | - (41) | - (7) |
| DAX (D30EUR) | ritest | su | +0.024 (1273) | -0.022 (450) | - (119) | - (37) | - (4) |
| S&P (SPXUSD) [sec.] | rimbalzo | long | +0.013 (2475) | -0.001 (897) | -0.052 (262) | - (68) | - (8) |
| S&P (SPXUSD) [sec.] | rimbalzo | short | +0.024 (2167) | +0.004 (733) | -0.008 (187) | - (41) | - (2) |
| S&P (SPXUSD) [sec.] | ritest | giu | +0.009 (2192) | +0.021 (787) | +0.009 (228) | - (56) | - (7) |
| S&P (SPXUSD) [sec.] | ritest | su | +0.031 (1999) | +0.027 (691) | -0.045 (182) | - (44) | - (2) |
| Oro A (Oanda 06-20) | rimbalzo | long | +0.022 (4448) | +0.011 (1488) | +0.049 (417) | - (108) | - (20) |
| Oro A (Oanda 06-20) | rimbalzo | short | +0.029 (4201) | -0.001 (1387) | +0.002 (378) | - (96) | - (14) |
| Oro A (Oanda 06-20) | ritest | giu | +0.026 (3897) | +0.021 (1283) | -0.028 (341) | - (94) | - (15) |
| Oro A (Oanda 06-20) | ritest | su | +0.026 (3808) | -0.008 (1225) | -0.030 (333) | - (88) | - (13) |
| Oro B (HistData 21-26) | rimbalzo | long | -0.006 (1753) | +0.006 (579) | +0.037 (154) | - (38) | - (5) |
| Oro B (HistData 21-26) | rimbalzo | short | +0.001 (1619) | -0.030 (553) | - (123) | - (28) | - (1) |
| Oro B (HistData 21-26) | ritest | giu | +0.024 (1572) | +0.033 (515) | - (121) | - (36) | - (2) |
| Oro B (HistData 21-26) | ritest | su | +0.013 (1500) | +0.018 (502) | - (117) | - (28) | - (1) |

Lettura: da M5 a H1 nessuna salita (su nessun simbolo, nessuna ipotesi); a H4 e D1 **nessuna cella arriva a 150**. Il tratto dove la frase "sui TF alti la 200 e' forte" dovrebbe vedersi e' esattamente quello senza campione: H3 resta NON ANCORA MISURATO, non "falso".

## 5. PLACEBO -- la 200 e' speciale?

### T5. PLACEBO (stessi dati veri, cella primaria H1 e H2; P grezza; solo TF con n EMA200 >= 150)

| TF | simbolo / feed | ip | lato | EMA200 | EMA100 | EMA150 | EMA250 | SMA200 | EMA200 dentro la forbice placebo? |
|---|---|---|---|---|---|---|---|---|---|
| M5 | DAX (D30EUR) | rimbalzo | long | 0.472 | 0.449 | 0.451 | 0.475 | 0.467 | si |
| M5 | DAX (D30EUR) | rimbalzo | short | 0.425 | 0.434 | 0.433 | 0.432 | 0.443 | si |
| M5 | DAX (D30EUR) | ritest | giu | 0.380 | 0.369 | 0.378 | 0.375 | 0.387 | si |
| M5 | DAX (D30EUR) | ritest | su | 0.389 | 0.389 | 0.375 | 0.363 | 0.375 | si |
| M5 | S&P (SPXUSD) [sec.] | rimbalzo | long | 0.468 | 0.479 | 0.472 | 0.469 | 0.462 | si |
| M5 | S&P (SPXUSD) [sec.] | rimbalzo | short | 0.464 | 0.440 | 0.448 | 0.442 | 0.461 | si |
| M5 | S&P (SPXUSD) [sec.] | ritest | giu | 0.396 | 0.392 | 0.412 | 0.396 | 0.404 | si |
| M5 | S&P (SPXUSD) [sec.] | ritest | su | 0.421 | 0.414 | 0.428 | 0.422 | 0.429 | si |
| M5 | Oro A (Oanda 06-20) | rimbalzo | long | 0.478 | 0.474 | 0.468 | 0.484 | 0.470 | si |
| M5 | Oro A (Oanda 06-20) | rimbalzo | short | 0.482 | 0.465 | 0.463 | 0.467 | 0.471 | si |
| M5 | Oro A (Oanda 06-20) | ritest | giu | 0.407 | 0.410 | 0.422 | 0.404 | 0.408 | si |
| M5 | Oro A (Oanda 06-20) | ritest | su | 0.412 | 0.422 | 0.418 | 0.410 | 0.412 | si |
| M5 | Oro B (HistData 21-26) | rimbalzo | long | 0.479 | 0.498 | 0.476 | 0.471 | 0.488 | si |
| M5 | Oro B (HistData 21-26) | rimbalzo | short | 0.473 | 0.483 | 0.482 | 0.492 | 0.473 | si |
| M5 | Oro B (HistData 21-26) | ritest | giu | 0.425 | 0.406 | 0.416 | 0.422 | 0.435 | si |
| M5 | Oro B (HistData 21-26) | ritest | su | 0.424 | 0.430 | 0.419 | 0.424 | 0.410 | si |
| M15 | DAX (D30EUR) | rimbalzo | long | 0.468 | 0.455 | 0.474 | 0.427 | 0.431 | si |
| M15 | DAX (D30EUR) | rimbalzo | short | 0.403 | 0.438 | 0.389 | 0.428 | 0.396 | si |
| M15 | DAX (D30EUR) | ritest | giu | 0.356 | 0.386 | 0.323 | 0.307 | 0.360 | si |
| M15 | DAX (D30EUR) | ritest | su | 0.344 | 0.332 | 0.359 | 0.333 | 0.341 | si |
| M15 | S&P (SPXUSD) [sec.] | rimbalzo | long | 0.475 | 0.504 | 0.471 | 0.487 | 0.478 | si |
| M15 | S&P (SPXUSD) [sec.] | rimbalzo | short | 0.458 | 0.455 | 0.460 | 0.447 | 0.444 | si |
| M15 | S&P (SPXUSD) [sec.] | ritest | giu | 0.395 | 0.374 | 0.380 | 0.381 | 0.395 | si |
| M15 | S&P (SPXUSD) [sec.] | ritest | su | 0.411 | 0.423 | 0.399 | 0.375 | 0.410 | si |
| M15 | Oro A (Oanda 06-20) | rimbalzo | long | 0.489 | 0.507 | 0.512 | 0.471 | 0.502 | si |
| M15 | Oro A (Oanda 06-20) | rimbalzo | short | 0.471 | 0.492 | 0.484 | 0.489 | 0.461 | si |
| M15 | Oro A (Oanda 06-20) | ritest | giu | 0.407 | 0.442 | 0.415 | 0.410 | 0.419 | si |
| M15 | Oro A (Oanda 06-20) | ritest | su | 0.384 | 0.411 | 0.421 | 0.384 | 0.405 | si |
| M15 | Oro B (HistData 21-26) | rimbalzo | long | 0.503 | 0.494 | 0.497 | 0.509 | 0.484 | si |
| M15 | Oro B (HistData 21-26) | rimbalzo | short | 0.447 | 0.489 | 0.465 | 0.488 | 0.483 | si |
| M15 | Oro B (HistData 21-26) | ritest | giu | 0.425 | 0.389 | 0.421 | 0.349 | 0.422 | si |
| M15 | Oro B (HistData 21-26) | ritest | su | 0.416 | 0.403 | 0.394 | 0.381 | 0.423 | si |
| H1 | S&P (SPXUSD) [sec.] | rimbalzo | long | 0.427 | 0.485 | 0.488 | 0.440 | 0.472 | si |
| H1 | S&P (SPXUSD) [sec.] | rimbalzo | short | 0.444 | 0.416 | 0.431 | 0.378 | 0.381 | si |
| H1 | S&P (SPXUSD) [sec.] | ritest | giu | 0.360 | 0.375 | 0.372 | 0.327 | 0.319 | si |
| H1 | S&P (SPXUSD) [sec.] | ritest | su | 0.335 | 0.404 | 0.372 | 0.370 | 0.369 | NO (-0.034 oltre) |
| H1 | Oro A (Oanda 06-20) | rimbalzo | long | 0.537 | 0.452 | 0.484 | 0.483 | 0.463 | NO (+0.053 oltre) |
| H1 | Oro A (Oanda 06-20) | rimbalzo | short | 0.468 | 0.470 | 0.489 | 0.478 | 0.459 | si |
| H1 | Oro A (Oanda 06-20) | ritest | giu | 0.337 | 0.377 | 0.389 | 0.355 | 0.343 | si |
| H1 | Oro A (Oanda 06-20) | ritest | su | 0.336 | 0.401 | 0.390 | 0.351 | 0.315 | si |
| H1 | Oro B (HistData 21-26) | rimbalzo | long | 0.545 | 0.513 | 0.449 | 0.512 | 0.516 | si |

Lettura: la P della EMA200 sta dentro la forbice delle quattro linee placebo (+/-0,03) in **39 righe su 41**. Fuori: **oro A H1 long** (0,537 contro 0,452-0,484 dei placebo, +0,053 sopra il placebo piu' alto) e S&P H1 ritest "su" (sotto). A M5 l'inclinazione media sopra i surrogati e' **+0,016 per la EMA200 e +0,014 per i placebo** (14/16 e 55/64 righe positive) [MISURATO]: e' di qualunque linea lenta, o del surrogato che a M5 spezza la stagionalita' intraday (blocco di 200 minuti); non e' separabile qui, e in ogni caso **non e' della 200**.

## 6. REGIMI

### T6. Righe per REGIME (n >= 150) con verdetto EFFETTO o CONTRARIO

- S&P (SPXUSD) [sec.] H2 M5 su ORSO: n 262, P 0.477, surrogati 0.408, effetto +0.069 -> EFFETTO
- Oro A (Oanda 06-20) H1 M5 short ORSO: n 653, P 0.505, surrogati 0.455, effetto +0.050 -> EFFETTO
- Oro B (HistData 21-26) H2 M15 giu LATERALE: n 244, P 0.492, surrogati 0.399, effetto +0.093 -> EFFETTO

Righe per regime con n >= 150 (tutte le celle primarie H1 e H2): 84

Le tabelle complete per regime (TORO / LATERALE / ORSO, cella primaria H1 e H2, tutti i TF) sono nei CSV (`regime` != `TUTTO`).

## 7. I contro-esempi, controllati sui dati (non solo scritti)

| contro-esempio | che cosa ho trovato | effetto sul verdetto |
|---|---|---|
| **Soglie asimmetriche** | la cella (0,25; 1,0) da' 0,649-0,786: il "quasi sempre" vive della geometria, non della media | nessuno: verdetto sulla primaria simmetrica |
| **Minuti violenti al tocco** (grana M1, code grasse) | a M5 il **9-23%** degli sfondamenti di 1 ATR avviene GIA' nel minuto del tocco (DAX 23%/20%, S&P 16%/13%, oro A 20%/21%, oro B 14%/9%, long/short); a H1 2-18%; in un random walk **0** su 1.342. Il minuto del tocco a M5 ha range mediano 0,93 ATR(M5) sul DAX contro 0,56 nel random walk [MISURATO, diagnosi in scratch, contatore ora dentro il referto di ogni corsa] | spiega perche' P < 0,50 e < 0,80 anche nei surrogati: e' una proprieta' del mercato (si arriva sulla media con slancio), non della EMA200. Per un ordine limite sulla media vuol dire: **1 volta su 5, a M5, lo stop di 1 ATR e' preso nello stesso minuto del fill** |
| **Deriva / trend** (DAX/S&P toro 2012-17, oro B +64,5% nel 2025) | effetto senza segno legato al lato a M5-M15; l'unico lato "sopra" e' oro H1 long (deriva toro di entrambi i feed): **coerente con la deriva, non con un rimbalzo simmetrico** | indizio non promosso (regola dei due lati) |
| **Mean reversion generica** | la P della EMA200 sta dentro la forbice dei quattro placebo (+/-0,03) in 39 righe su 41; a M5 l'inclinazione sopra i surrogati e' +0,016 per la 200 e +0,014 per i placebo | la 200 non e' speciale dove si misura |
| **Surrogato che contiene l'effetto** (classe 1034) | misurato su rimbalzo piantato a M5: blocchi di un giorno 0,538/0,550, blocchi di 40 barre 0,512/0,509, vero 0,656/0,643: il blocco "a giorni" si mangia il 18-31% dell'effetto | usato il blocco di 40 barre del TF, come congelato |
| **Orologio** | DAX, oro A e oro B passano al primo colpo; S&P ha il picco alle 10:00 NY (dati delle 10:00) con spostamento stagionale -60 esatto: conversione giusta, ancora mancante nella lista congelata (classe 1036) | S&P = lettura secondaria; i verdetti sul fenomeno valgono anche senza S&P (DAX + oro bastano come gemelli) |
| **ATR = 0 sul feed piatto** (classe 1037) | 532/321/302 barre con ATR 0 nell'oro Oanda (M5/M15/H1) -> distanza infinita che armava la separazione. Corretto e rifatte TUTTE le corse: **diff = 0 righe** | nessuno (misurato) |
| **Molti confronti** | 84 righe per regime con n >= 150: 3 escono EFFETTO (S&P M5 ritest "su" ORSO +0,069; oro A M5 rimbalzo short ORSO +0,050; oro B M15 ritest "giu" LATERALE +0,093), 0 CONTRARIO; ognuna isolata (un TF, un lato, un regime), nessuna replicata sul gemello | atteso ~1-2 per caso su 84 [DERIVATO: soglia al p97,5 dei surrogati]; nessuna regge la regola "ogni classe di regime" |
| **Costo** | 1 ATR / spread: DAX M5 **4,9x**, M15 9,0x, H1 18,8x, H4 33,4x, D1 84,4x; oro A 3,7x / 6,7x / 14,7x / 30,0x / 77,9x; oro B 7,4x / 13,4x / 27,8x / 54,6x / 173x; un rimbalzo di 0,25 ATR a M5 vale **0,9-1,8 spread**. S&P: spread [NON MISURATO] | non entra nella P; dice che anche un effetto vero a M5-M15 non sarebbe convertibile sotto la frontiera 40x (spread: D30EUR 1,7676 pt, XAUUSD 0,2003 giro completo, `sonda_supertrend_segnali.py`; ATR mediano del feed esterno, non BCM) |

## 8. Verdetti, uno per ipotesi (regole della sez. 7 dei criteri, alla lettera)

| ipotesi | TF | gemelli misurati (n >= 150) | che cosa dicono i numeri | verdetto |
|---|---|---|---|---|
| **H1 rimbalzo, forma forte** ("quasi sempre", P >= 0,75 alla primaria) | M5, M15, H1 | DAX, oro A, oro B, S&P (sec.) | P 0,403-0,545, estremo alto IC max 0,622 | **ESCLUSA** (fuori da ogni IC, due lati, tre simboli) |
| H1 rimbalzo, forma debole (pochi punti sopra il null) | M5 | DAX, S&P, oro A, oro B | effetti -0,014..+0,029; 5 NULLO, 3 ZONA GRIGIA (oro A due lati, S&P short), inclinazione identica sui placebo | **NON ANCORA MISURATO**: la regola "SENZA CONTENUTO" chiede NULLO ovunque; manca. Massimo plausibile (IC alto - surrogati) +0,045 |
| idem | M15 | 4 | -0,030..+0,015; tutti NULLO tranne oro B short (ZONA GRIGIA -0,030) | NON ANCORA MISURATO (un ZONA GRIGIA, di segno CONTRARIO) |
| idem | H1 | S&P, oro A, oro B long (DAX 149/120: sotto 150) | -0,052..+0,049, tutti ZONA GRIGIA o NULLO | NON ANCORA MISURATO; indizio oro long |
| idem | H4, D1 | nessuno | n 28-108 (H4), 1-20 (D1) | **NON ANCORA MISURATO** (campione) |
| **H2 ritest "prima di proseguire"** | M5, M15 | 4 | P_RT 0,344-0,425, sotto 0,50, accanto al null per evento | forma forte **ESCLUSA**; forma debole NON ANCORA MISURATO (6 ZONA GRIGIA su 16, tutte +0,021..+0,033, inclinazione identica sui placebo) |
| H2 | H1 | S&P, oro A | 0,335-0,360, effetti -0,045..+0,009 | NON ANCORA MISURATO (ZONA GRIGIA S&P "su" -0,045) |
| H2 | H4, D1 | nessuno | n 28-94 / 1-15 | NON ANCORA MISURATO |
| **H3 gradiente** | M5 -> D1 | M5-H1 si', H4-D1 no | effetto piatto fino a H1 (nessuna salita monotona su nessun simbolo) | **NON ANCORA MISURATO**: il tratto dove Claudio si aspetta la forza (H4-D1) non ha campione. Fino a H1 l'attesa E4 (piatto) regge |

Attese dichiarate prima (criteri sez. 10) contro numeri: **E1** (effetto entro +/-0,05) regge: max |effetto| 0,052 (S&P H1 long, di segno CONTRARIO). **E2** (cella collega 0,75-0,85) **SBAGLIATA**: e' 0,649-0,786, piu' bassa del random walk (minuti violenti, sez. 7). **E3** (H2 vicino al null e ai surrogati entro 0,05) regge: max 0,045. **E4** (H3 piatto) regge fino a H1, oltre non misurabile. **E5** (lati) regge a M5-M15; a H1 il lato long dell'oro e' l'eccezione.

## 9. Che cosa NON ho raggiunto, e la via piu' corta al numero

| buco | perche' | via piu' corta (costo) |
|---|---|---|
| **NASUSD (US100)** | `NSXUSD` = 404 sul mirror FutureSharks; il CSV `%USERPROFILE%\abtg_storico_indici\NASUSD_M1.csv` (HistData 2010-2026, ora NY, Formato 1) vive solo sul PC di backtest | lo strumento lo legge gia': `python ema200_rimbalzo.py --dataset FILE --file NASUSD_M1.csv --formato f1 --fuso NY --simbolo NASUSD --ancore 810,870,900`. Serve **numpy** sul PC [NON VERIFICATO che ci sia]. Tempo atteso: 2-8 min [DERIVATO dalle corse di qui, 131-470 s]. **La riga di lancio NON e' scritta**: va scritta e passata da `controlla_riga.py` + `controllo-preventivo` prima di arrivare a Claudio (bersaglio: finestra PowerShell sul PC di backtest, nessun MT5) |
| **U30USD (US30)** | nessun feed esterno esiste (stato dell'arte 5.4); BCM ha il Dow solo dal 2024.09.26; in repo nessuno strumento d'export M1 da MT5 a CSV collaudato | serve uno script MQL5 di export M1 (nuovo, da far passare dal cancello) sul terminale banco del PC di backtest; con 21 mesi, M5-M15 darebbero n >= 150 [DERIVATO: DAX 8 anni = 1.571 tocchi long a M5], H1 forse no. Senza questo il Dow resta **NON MISURATO**, e con lui il G0 "come l'EA" (0,696 della sedia 771531) |
| **H4 / D1** | il primo tocco dopo 20 barre pulite e' raro: ~7-8 eventi/anno/lato a H4 sull'oro A [DERIVATO 108/14,2 anni], ~1/anno a D1 | (a) un feed lungo: forex/oro BCM dal 1999/2004 (R102), 20+ anni = ~150 a H4, a D1 mai; (b) pooling dichiarato di piu' simboli per classe; (c) N_SEP piu' corto, ma e' un'altra definizione e va congelata PRIMA. Nessuna di queste e' fatta qui |
| **Spread S&P** | [NON MISURATO] sul nostro broker | spread_orario di SPXUSD dal logger, se esiste |
| **Regime "crollo"** | non separabile con n >= 150 | finestre nominate (2008, 2011-08, 2020-03) con pooling di TF bassi |
| Domini bloccati dal proxy | `histdata.com`, `datafeed.dukascopy.com`, `stooq.com`, `query1.finance.yahoo.com`, `www.kaggle.com` -> `connect_rejected` (verificato oggi) | -- |

## 10. Che cosa ho controllato prima di consegnare (lo Sviluppatore contro l'Agente dei Controlli)

- **Criteri committati e pushati PRIMA della prima corsa su dati veri** (`c23bfe61`); dopo, un solo cambio, dichiarato: l'ancora S&P aggiunta a posteriori (lettura secondaria, non il cancello).
- **Autotest 21/21** (`autotest.log`), con i casi che DEVONO accendersi (classe 1014): rimbalzo piantato -> P 0,926/0,921 e EFFETTO contro surrogati 0,52; rottura piantata -> P_RT 0,180/0,195 e CONTRARIO; random walk -> 0,516/0,502 (N0 0,500) e 0,823/0,785 (N0 0,800) con n 944/906, nessun falso positivo; orologio spostato di 1 h -> eventi H4/D1 cambiano; file in EST fisso -> cancello bocciato (estate 11:30 invece di 12:30); colonne Oanda lette per nome. Random walk a M5: 0,497/0,503 e 0,789/0,792, quindi la grana M1 a M5 NON spiega da sola lo 0,47 dei dati veri: lo spiegano i minuti violenti (sez. 7).
- **Primo autotest fallito 5/21 per rumore** (n ~300, SE 0,029 contro tolleranza 0,03): alzato il campione, non la tolleranza (classe 1035).
- **Difetto trovato nel mio strumento** (ATR = 0 -> distanza infinita, classe 1037): corretto, corse rifatte tutte, diff = 0.
- **Prima stesura della classe 1034** diceva "il surrogato a giorni rimbalza quanto il vero": era un'attesa, l'ho misurata (18-31%) e corretta prima del commit.
- Tabelle generate dai CSV, non ricopiate a mano.
- Nessun EA, preset, sedia, conto, terminale toccato. Zero passate di Strategy Tester, zero VPS.
