# CONFLUENZA H4/M3 della SuperWave misurata come FENOMENO: la MISURA (01/10/2026)

1. **"Ha senso entrare in M3 quando l'inversione va nel verso dell'H4?" Come TIMING, no: misurato.** Dopo un'inversione del Supertrend 10/3,5 su M3 nel verso di un H4 stabile (la dashboard v4.1 che si accende), a 60 minuti il prezzo fa **esattamente quello che fa in un istante qualunque con lo stesso H4**: effetto da **-0,018 a +0,015 ATR(14) H1** su DAX, oro A e oro B, due lati, n 2.638-9.473 per cella, IC95 a blocchi di giorni tutti dentro **[-0,043; +0,041]**: **6 celle su 6 NULLO** -> verdetto congelato **SENZA CONTENUTO (dentro il null)**. S&P (secondario): 2 su 2 NULLO. Nessun EFFETTO nemmeno con Supertrend 2,5 / 3,0 / ATR 14 (le sole ZONA GRIGIA, sul DAX long, sono NEGATIVE: -0,025..-0,027) ne' con le barre H4 spostate di un'ora (orologio ~FTMO).
2. **Il costo pesa 2-4 volte piu' di qualunque effetto**: uno spread vale **0,051 ATR H1 sul DAX, 0,068 sull'oro A, 0,036 sull'oro B**; netto di spread, il rendimento medio a 60 minuti dopo il segnale e' **negativo in tutte e 6 le celle** (da -0,016 a -0,093 ATR H1).
3. **Lo stop del pannello (Supertrend M3) vale 0,60-0,88 ATR H1 anno per anno (mediana 0,72-0,86 per dataset)**: sul DAX 2010-18 e' 13,7-17,5 volte lo spread (mediana), sopra la frontiera dei 40x solo nel **2,2-5,8%** dei segnali; sull'oro va da 5x (2007) a **72x (2026)**, perche' l'ATR dell'oro e' quintuplicato. Con quello stop **P(+1R prima di -1R) = 0,491-0,534** e l'aspettativa netta e' **da -0,035 a -0,130 R per operazione** (IC sotto zero in 5 celle su 6; DAX short [-0,073; +0,004]).
4. **Il filtro H4 aggiunge poco**: ALLINEATO meno CONTRO da -0,012 a +0,038 ATR H1 (tutti gli IC toccano lo zero), al netto della base di ciascuno da -0,012 a +0,024. Lo schema top-down con stop H4 (76-154x spread, sopra la frontiera nell'82-96%) a 240 minuti resta piatto: netto da -0,042 a +0,013 R (quasi tutto ancora aperto: la gestione su piu' giorni NON e' misurata).
5. **Non raggiunti da qui: Nasdaq, Dow, feed BCM, forex della griglia, gestione TP1/TP2/TP3 40/30/30.** Un solo cambio DOPO i dati, dichiarato (filtro di qualita' del feed: tocca 982 chiusure su 1,66 milioni del solo oro A, DAX identico al byte). Frequenza della dashboard: **2,8 segnali ALLINEATO al giorno sul DAX, 4,0-4,3 sull'oro**.

---

Criteri congelati PRIMA dei numeri: `report/H4_M3_CONFLUENZA_CRITERI_2026-10-01.md`, commit `0523b049` (pushato 21:28:17 UTC), **emendamento prima dei dati** sez. 10, commit `e122978a` (pushato 21:41:49 UTC). Primo caricamento di un dato vero da parte di questo strumento: **21:41:54 UTC** (corsa DAX).
Strumento: `backtest_pipeline/h4_m3_confluenza.py` (MARCATORE_H4_M3_CONFLUENZA_v1, SHA256 `9d40b522...91b0`), autotest **29/29**.
Archivio: `backtest_pipeline/risultati_archivio/H4_M3_2026-10-01/` (4 CSV con tutte le righe, 4 referti, 4 log, autotest, stop per anno, riconto indipendente).
Classi nuove in `backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md`: **1052** (controllo appaiato per mese = look-ahead nel controllo), **1053** (look-ahead reso quasi invisibile dal filtro: serve la guardia deterministica), **1054** (ATR quasi zero nel feed piatto, oltre la 1037).
Etichette: [MISURATO] dai CSV di questa corsa; [DERIVATO] calcolo da numeri misurati; [NON MISURATO].

## 0. Che cosa vale questo referto (e che cosa NO)

- E' una misura del **fenomeno** (event study), non di un motore: niente PF, DD, equity, niente gestione a quote. **Non archivia nessun candidato** e non e' un certificato di morte: misura il timing della confluenza, non un EA.
- Decide UNA cella congelata prima: **R a 60 minuti, media lorda in ATR(14) H1, ALLINEATO meno CASUALE B**, per simbolo e lato. Tutto il resto (orizzonti 30/120/240, placebo, regimi, fasce, stop) e' descrittivo.
- Che cosa NON esclude: che la dashboard sia utile come **filtro di direzione** dentro un sistema con un'altra uscita (trailing, TP a piu' giorni); che lo sia su Nasdaq/Dow/forex; che lo sia con la gestione 40/30/30 su TP1/TP2/TP3. Esclude solo che **l'istante** dell'inversione M3 nel verso H4 porti informazione sul percorso dei 30-240 minuti dopo, su DAX e oro, oltre a quella della direzione H4.

## 1. Dati, orologio, regime (dichiarati)

| simbolo / feed | finestra (UTC) | barre M1 | G-OROLOGIO | ruolo |
|---|---|---|---|---|
| DAX `GRXEUR` HistData (mirror FutureSharks) | 2010-11-15 -> 2018-12-28 | 1.718.805 | **PASSA** (inverno 07:00, estate 06:00) | primario |
| Oro A: Oanda `XAU_USD` | 2006-03-19 -> 2020-05-14 | 4.884.366 | **PASSA** (13:30 / 12:30) | primario (gemello di feed) |
| Oro B: HistData in repo (UTC) | 2021-01-03 -> 2026-09-18 | 1.979.587 | **PASSA** (13:30 / 12:30) | primario (gemello di feed) |
| S&P `SPXUSD` HistData | 2010-11-14 -> 2018-12-31 | 2.117.667 | **PASSA** con l'ancora 15:00 dichiarata nei criteri (classe 1036) | SECONDARIO |

Barre M3, H1, H4 su **UTC+1 fisso** (orologio BCM di oggi). Supertrend: **lo stesso `SW_STCore` della v4.1**, versione veloce **identica al bit** allo specchio `py_stcore` del collaudo v4.1 (autotest su 4 coppie di parametri + prime 20.000 barre M3 vere di ogni dataset: identico). **Finestra della dashboard (1000 barre) contro storico intero: 0 discordanze su 300 eventi campionati per dataset** (direzione M3, inversione sulla barra, direzione e stabilita' H4, `SW_Confl`). Classificazione ALLINEATO == `py_confl` del collaudo su tutti gli eventi (12.490 DAX, 40.170 oro A, 14.387 oro B, 23.237 S&P). Regimi: DAX 2010 LAT, 2011 ORSO, 2012-13 TORO, 2014-16 LAT, 2017 TORO, 2018 ORSO; oro A 14 anni con TORO/LAT/ORSO; oro B **nessun ORSO** (2023-25 TORO, +64,5% nel 2025).

**Cambio dopo i dati (dichiarato, classe 1037 estesa)**: alla prima corsa l'oro A dava IC larghi 0,2-0,3 e bande del controllo di +/-0,08. Causa misurata: nei tratti piatti del feed Oanda l'ATR H1 vale **0,0014 $** (mediana 2,92) e un movimento normale di 3 $ diventava **R = 2.350 ATR**. Filtro aggiunto, deciso sulla distribuzione dell'ATR e non sugli esiti, uguale per tutti: **ATR H1 >= 0,1 x mediana del dataset**. Esclude **982 chiusure M3 su 1.656.759 dell'oro A, zero su DAX, oro B e S&P** (CSV del DAX identico al byte prima/dopo). Prima del filtro l'oro A usciva ZONA GRIGIA/ZONA GRIGIA alla cella che decide (nessun EFFETTO); dopo, NULLO/NULLO.

## 2. La cella che DECIDE (D1: il timing M3 aggiunge qualcosa alla direzione H4?)

ALLINEATO = inversione del Supertrend M3 (barra chiusa) con H4 stabile (`bsH4 >= 3`) nello stesso verso. CASUALE B = istanti qualunque (chiusure M3) con H4 stabile nello stesso verso, stessa distribuzione oraria, 20 estrazioni da n eventi ciascuna. CON = inversione M3 contro l'H4 stabile. R in ATR(14) H1, a 60 minuti dalla chiusura della barra d'inversione (= l'ingresso fisso del pannello). Netto = meno uno spread (DAX: mediana BCM per ora; oro 0,2003 $).

| simbolo / feed | lato | n ALL | ALL | B (20 estr.) | banda B [p2,5; p97,5] | CON (n) | effetto ALL-B | IC95 blocchi-giorno | netto ALL | verdetto |
|---|---|---|---|---|---|---|---|---|---|---|
| DAX (D30EUR) | long | 2820 | -0.020 | -0.002 | [-0.037; +0.020] | -0.007 (2662) | -0.018 | -0.043..+0.008 | -0.093 | **NULLO** |
| DAX (D30EUR) | short | 2638 | +0.018 | +0.003 | [-0.022; +0.028] | -0.002 (2856) | +0.015 | -0.011..+0.041 | -0.036 | **NULLO** |
| Oro A (Oanda 06-20) | long | 9473 | +0.005 | +0.012 | [-0.007; +0.032] | -0.021 (8547) | -0.007 | -0.023..+0.010 | -0.074 | **NULLO** |
| Oro A (Oanda 06-20) | short | 8417 | -0.002 | +0.010 | [-0.005; +0.025] | -0.026 (9576) | -0.012 | -0.029..+0.007 | -0.077 | **NULLO** |
| Oro B (HistData 21-26) | long | 3312 | +0.022 | +0.017 | [-0.009; +0.042] | -0.016 (3269) | +0.005 | -0.018..+0.031 | -0.016 | **NULLO** |
| Oro B (HistData 21-26) | short | 3245 | +0.005 | +0.003 | [-0.019; +0.028] | -0.026 (3324) | +0.003 | -0.026..+0.031 | -0.034 | **NULLO** |
| S&P (SPXUSD) [sec.] | long | 4600 | -0.008 | +0.003 | [-0.021; +0.022] | +0.024 (4441) | -0.011 | -0.038..+0.016 | [NON MISURATO] | **NULLO** |
| S&P (SPXUSD) [sec.] | short | 4417 | -0.020 | -0.004 | [-0.022; +0.013] | -0.016 (4670) | -0.016 | -0.044..+0.012 | [NON MISURATO] | **NULLO** |

**Verdetto sul fenomeno (criteri sez. 5.1, alla lettera): SENZA CONTENUTO (dentro il null)** -- NULLO su tutte le 6 celle che decidono (DAX, oro A, oro B x long/short, n >= 150), due simboli misurati. L'altopiano non serve (nessun EFFETTO da confermare). Nelle 34 sotto-righe descrittive per regime e fascia oraria dei tre primari (n 155-5.354): 13 NULLO, 21 ZONA GRIGIA (IC piu' larghi di +/-0,05 per n piu' piccolo), **0 EFFETTO, 0 CONTRARIO** (sez. 6). Chi leggesse "tutte le celle" includendo anche quelle sotto-righe avrebbe "NON ANCORA MISURATO" per la forma debole: lo scrivo, ma nessuna sotto-riga punta da nessuna parte.

**Limite dell'IC (scritto accanto)**: il bootstrap ricampiona giorni interi, quindi tiene conto della dipendenza fra eventi dello stesso giorno (finestre di 60 minuti che si sovrappongono, grappoli di volatilita'), **non** di quella fra giorni consecutivi. Effetto minimo rilevabile: con semi-ampiezze di 0,016-0,029 ATR H1, un effetto vero di +0,05 sarebbe uscito EFFETTO o ZONA GRIGIA, **mai NULLO** (NULLO chiede |effetto| < 0,02 con l'IC dentro +/-0,05) [DERIVATO]. L'autotest vede un effetto piantato da +0,21/+0,25; uno piu' piccolo non e' stato piantato.

## 3. D2: il filtro H4 aggiunge qualcosa all'inversione M3?

| simbolo / feed | lato | ALL - CON | IC95 | (ALL-B) - (CON-B_con) |
|---|---|---|---|---|
| DAX (D30EUR) | long | -0.012 | -0.052..+0.028 | -0.012 |
| DAX (D30EUR) | short | +0.020 | -0.022..+0.061 | +0.017 |
| Oro A (Oanda 06-20) | long | +0.026 | -0.002..+0.055 | +0.009 |
| Oro A (Oanda 06-20) | short | +0.024 | -0.005..+0.052 | +0.004 |
| Oro B (HistData 21-26) | long | +0.038 | -0.003..+0.077 | +0.024 |
| Oro B (HistData 21-26) | short | +0.031 | -0.013..+0.073 | +0.007 |
| S&P (SPXUSD) [sec.] | long | -0.031 | -0.076..+0.012 | -0.028 |
| S&P (SPXUSD) [sec.] | short | -0.004 | -0.050..+0.043 | -0.008 |

Lettura: l'inversione M3 **contro** l'H4 rende un po' meno dell'inversione a favore sull'oro (+0,024..+0,038, IC che toccano lo zero), niente sul DAX, segno opposto sull'S&P long. Tolta a ciascuno la sua base (istanti a caso con lo stesso H4), la differenza scende a **-0,012..+0,024**: quel poco che c'e' e' la direzione H4 stessa, non l'incontro con l'M3.

## 4. D3: a quale COSTO (stop ipotetici, primo passaggio entro 240 minuti)

Per ogni evento: +1R prima di -1R (TP), -1R prima (SL), stesso minuto (AMB, contato come SL nell'aspettativa), nessuno dei due (TO, chiuso a mercato a 240 minuti). (a) stop = valore del Supertrend M3 sulla barra d'inversione (**lo stop del pannello della dashboard**); (b) 1 ATR H1; (c) Supertrend H4 (schema top-down). Sensibilita': DAX 1,7676 pt fisso; oro **0,45 $** (`XAUUSD` FTMO, una giornata, SOTTILE); S&P 0,60 pt (`US500.cash` FTMO, una giornata, SOTTILE: lo spread S&P sul nostro broker e' [NON MISURATO], quindi le colonne del rapporto e del netto restano vuote).

| simbolo / feed | lato | stop | gruppo | n | D mediana (pt) | D / ATR H1 | D / spread mediana [p10; p90] | quota >= 40x | P(+1R prima di -1R) [Wilson] | TO | E lordo (R) | E netto (R) [IC giorni] | E netto, spread di sensibilita' |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| DAX (D30EUR) | long | a_ST_M3 | ALLINEATO | 2506 | 24.66 | 0.86 | 13.7 [6.1; 27.9] | 2.2% | 0.491 [0.469; 0.513] | 566 | -0.009 | -0.100 [-0.135; -0.064] | -0.091 |
| DAX (D30EUR) | long | a_ST_M3 | CASUALE_B | 50120 | 24.97 | 0.86 | 13.8 [5.9; 28.8] | 3.2% | 0.505 [0.500; 0.510] | 11724 | +0.022 | -0.070 [-0.092; -0.046] | -0.060 |
| DAX (D30EUR) | long | b_1ATR_H1 | ALLINEATO | 2506 | 28.68 | 1.00 | 15.5 [9.1; 26.6] | 1.0% | 0.474 [0.451; 0.497] | 733 | -0.022 | -0.092 [-0.128; -0.056] | -0.088 |
| DAX (D30EUR) | long | b_1ATR_H1 | CASUALE_B | 50120 | 28.96 | 1.00 | 15.7 [9.2; 27.1] | 1.1% | 0.499 [0.494; 0.504] | 14567 | +0.021 | -0.048 [-0.074; -0.022] | -0.044 |
| DAX (D30EUR) | long | c_ST_H4 | ALLINEATO | 2486 | 142.76 | 5.38 | 77.0 [32.6; 152.3] | 86.2% | 0.495 [0.426; 0.564] | 2290 | +0.005 | -0.015 [-0.029; +0.001] | -0.013 |
| DAX (D30EUR) | long | c_ST_H4 | CASUALE_B | 49087 | 141.50 | 5.28 | 76.4 [30.4; 153.8] | 84.1% | 0.455 [0.441; 0.469] | 44358 | +0.007 | -0.021 [-0.036; -0.007] | -0.019 |
| DAX (D30EUR) | short | a_ST_M3 | ALLINEATO | 2365 | 31.39 | 0.79 | 17.5 [7.6; 34.3] | 5.8% | 0.534 [0.513; 0.556] | 363 | +0.038 | -0.035 [-0.073; +0.004] | -0.028 |
| DAX (D30EUR) | short | a_ST_M3 | CASUALE_B | 47445 | 30.61 | 0.79 | 17.1 [7.3; 36.6] | 7.6% | 0.514 [0.509; 0.519] | 8977 | +0.010 | -0.064 [-0.088; -0.041] | -0.057 |
| DAX (D30EUR) | short | b_1ATR_H1 | ALLINEATO | 2365 | 38.45 | 1.00 | 20.9 [12.4; 38.2] | 8.6% | 0.543 [0.520; 0.566] | 590 | +0.046 | -0.005 [-0.042; +0.032] | -0.002 |
| DAX (D30EUR) | short | b_1ATR_H1 | CASUALE_B | 47445 | 38.55 | 1.00 | 20.9 [12.3; 37.8] | 8.1% | 0.524 [0.518; 0.529] | 12777 | +0.016 | -0.036 [-0.064; -0.010] | -0.032 |
| DAX (D30EUR) | short | c_ST_H4 | ALLINEATO | 2345 | 173.43 | 4.63 | 93.3 [33.8; 196.8] | 86.5% | 0.622 [0.557; 0.683] | 2118 | +0.022 | -0.042 [-0.157; +0.017] | -0.027 |
| DAX (D30EUR) | short | c_ST_H4 | CASUALE_B | 46404 | 171.24 | 4.51 | 92.1 [29.7; 200.1] | 84.2% | 0.554 [0.540; 0.568] | 41313 | +0.007 | -0.019 [-0.036; -0.003] | -0.018 |
| Oro A (Oanda 06-20) | long | a_ST_M3 | ALLINEATO | 9509 | 2.03 | 0.73 | 10.1 [4.2; 23.8] | 2.1% | 0.506 [0.495; 0.517] | 1317 | +0.006 | -0.130 [-0.151; -0.109] | -0.298 |
| Oro A (Oanda 06-20) | long | a_ST_M3 | CASUALE_B | 192973 | 2.01 | 0.72 | 10.0 [4.0; 25.0] | 3.0% | 0.503 [0.500; 0.505] | 32232 | +0.007 | -0.129 [-0.140; -0.117] | -0.298 |
| Oro A (Oanda 06-20) | long | b_1ATR_H1 | ALLINEATO | 9509 | 2.82 | 1.00 | 14.1 [7.8; 25.6] | 2.3% | 0.504 [0.491; 0.516] | 2946 | -0.003 | -0.083 [-0.103; -0.063] | -0.182 |
| Oro A (Oanda 06-20) | long | b_1ATR_H1 | CASUALE_B | 192973 | 2.83 | 1.00 | 14.1 [8.0; 25.8] | 2.2% | 0.504 [0.502; 0.507] | 61255 | +0.008 | -0.070 [-0.084; -0.057] | -0.168 |
| Oro A (Oanda 06-20) | long | c_ST_H4 | ALLINEATO | 9442 | 15.24 | 5.76 | 76.1 [29.1; 149.7] | 82.1% | 0.494 [0.460; 0.528] | 8605 | +0.001 | -0.025 [-0.041; -0.013] | -0.059 |
| Oro A (Oanda 06-20) | long | c_ST_H4 | CASUALE_B | 190251 | 15.07 | 5.61 | 75.2 [27.8; 149.3] | 81.3% | 0.480 [0.472; 0.487] | 172564 | +0.005 | -0.025 [-0.033; -0.017] | -0.061 |
| Oro A (Oanda 06-20) | short | a_ST_M3 | ALLINEATO | 8505 | 2.09 | 0.72 | 10.4 [4.7; 24.8] | 2.7% | 0.513 [0.501; 0.524] | 1070 | +0.013 | -0.109 [-0.131; -0.087] | -0.261 |
| Oro A (Oanda 06-20) | short | a_ST_M3 | CASUALE_B | 171496 | 2.07 | 0.71 | 10.3 [4.3; 26.2] | 3.6% | 0.510 [0.508; 0.513] | 28079 | +0.013 | -0.112 [-0.124; -0.099] | -0.267 |
| Oro A (Oanda 06-20) | short | b_1ATR_H1 | ALLINEATO | 8507 | 2.93 | 1.00 | 14.6 [8.5; 27.9] | 2.9% | 0.525 [0.513; 0.538] | 2594 | +0.015 | -0.060 [-0.081; -0.038] | -0.152 |
| Oro A (Oanda 06-20) | short | b_1ATR_H1 | CASUALE_B | 171535 | 2.91 | 1.00 | 14.5 [8.5; 28.0] | 3.1% | 0.522 [0.519; 0.525] | 54657 | +0.017 | -0.058 [-0.071; -0.043] | -0.150 |
| Oro A (Oanda 06-20) | short | c_ST_H4 | ALLINEATO | 8464 | 16.41 | 5.80 | 81.9 [30.7; 165.7] | 84.5% | 0.508 [0.471; 0.545] | 7776 | +0.002 | -0.019 [-0.029; -0.009] | -0.044 |
| Oro A (Oanda 06-20) | short | c_ST_H4 | CASUALE_B | 169256 | 15.87 | 5.66 | 79.3 [29.4; 166.2] | 83.5% | 0.504 [0.496; 0.512] | 154241 | +0.005 | -0.019 [-0.028; -0.011] | -0.049 |
| Oro B (HistData 21-26) | long | a_ST_M3 | ALLINEATO | 3315 | 4.27 | 0.75 | 21.3 [9.5; 68.4] | 25.9% | 0.509 [0.491; 0.528] | 508 | +0.017 | -0.038 [-0.070; -0.006] | -0.107 |
| Oro B (HistData 21-26) | long | a_ST_M3 | CASUALE_B | 66522 | 4.35 | 0.75 | 21.7 [9.3; 72.2] | 25.0% | 0.507 [0.503; 0.511] | 11910 | +0.015 | -0.040 [-0.058; -0.022] | -0.109 |
| Oro B (HistData 21-26) | long | b_1ATR_H1 | ALLINEATO | 3315 | 5.52 | 1.00 | 27.6 [15.0; 84.0] | 31.3% | 0.517 [0.496; 0.537] | 999 | +0.029 | -0.009 [-0.041; +0.023] | -0.056 |
| Oro B (HistData 21-26) | long | b_1ATR_H1 | CASUALE_B | 66522 | 5.61 | 1.00 | 28.0 [15.3; 85.2] | 32.0% | 0.505 [0.501; 0.510] | 19841 | +0.016 | -0.021 [-0.043; +0.000] | -0.068 |
| Oro B (HistData 21-26) | long | c_ST_H4 | ALLINEATO | 3302 | 30.86 | 5.77 | 154.1 [62.4; 462.2] | 95.7% | 0.516 [0.451; 0.580] | 3076 | +0.023 | +0.013 [-0.002; +0.026] | +0.001 |
| Oro B (HistData 21-26) | long | c_ST_H4 | CASUALE_B | 65722 | 30.90 | 5.64 | 154.2 [59.7; 468.3] | 95.1% | 0.489 [0.476; 0.503] | 60601 | +0.014 | -0.002 [-0.017; +0.011] | -0.021 |
| Oro B (HistData 21-26) | short | a_ST_M3 | ALLINEATO | 3256 | 4.09 | 0.76 | 20.4 [9.0; 75.1] | 25.0% | 0.497 [0.479; 0.516] | 444 | -0.007 | -0.065 [-0.098; -0.030] | -0.136 |
| Oro B (HistData 21-26) | short | a_ST_M3 | CASUALE_B | 65379 | 4.20 | 0.76 | 21.0 [9.1; 84.4] | 25.5% | 0.508 [0.504; 0.512] | 12195 | +0.012 | -0.044 [-0.064; -0.025] | -0.114 |
| Oro B (HistData 21-26) | short | b_1ATR_H1 | ALLINEATO | 3256 | 5.10 | 1.00 | 25.4 [14.9; 98.6] | 26.8% | 0.499 [0.478; 0.519] | 968 | -0.014 | -0.053 [-0.086; -0.019] | -0.102 |
| Oro B (HistData 21-26) | short | b_1ATR_H1 | CASUALE_B | 65379 | 5.31 | 1.00 | 26.5 [15.3; 101.0] | 28.9% | 0.505 [0.500; 0.509] | 20216 | +0.004 | -0.034 [-0.056; -0.011] | -0.081 |
| Oro B (HistData 21-26) | short | c_ST_H4 | ALLINEATO | 3238 | 26.77 | 5.34 | 133.7 [47.0; 522.4] | 92.0% | 0.511 [0.452; 0.569] | 2960 | -0.005 | -0.016 [-0.031; -0.001] | -0.030 |
| Oro B (HistData 21-26) | short | c_ST_H4 | CASUALE_B | 64379 | 27.73 | 5.31 | 138.4 [45.8; 563.6] | 91.7% | 0.519 [0.505; 0.532] | 58904 | +0.003 | -0.020 [-0.043; -0.003] | -0.049 |
| S&P (SPXUSD) [sec.] | long | a_ST_M3 | ALLINEATO | 4464 | 2.35 | 0.90 | [NON MISURATO] | [NON MISURATO] | 0.498 [0.482; 0.513] | 473 | +0.003 | [NON MISURATO] | -0.277 |
| S&P (SPXUSD) [sec.] | long | a_ST_M3 | CASUALE_B | 100318 | 2.51 | 0.84 | [NON MISURATO] | [NON MISURATO] | 0.505 [0.501; 0.508] | 13617 | +0.016 | [NON MISURATO] | -0.269 |
| S&P (SPXUSD) [sec.] | long | b_1ATR_H1 | ALLINEATO | 4464 | 2.77 | 1.00 | [NON MISURATO] | [NON MISURATO] | 0.487 [0.471; 0.503] | 818 | -0.019 | [NON MISURATO] | -0.251 |
| S&P (SPXUSD) [sec.] | long | b_1ATR_H1 | CASUALE_B | 100318 | 3.04 | 1.00 | [NON MISURATO] | [NON MISURATO] | 0.508 [0.505; 0.512] | 22143 | +0.019 | [NON MISURATO] | -0.196 |
| S&P (SPXUSD) [sec.] | long | c_ST_H4 | ALLINEATO | 4439 | 17.21 | 6.58 | [NON MISURATO] | [NON MISURATO] | 0.426 [0.380; 0.474] | 4016 | -0.004 | [NON MISURATO] | -0.067 |
| S&P (SPXUSD) [sec.] | long | c_ST_H4 | CASUALE_B | 98606 | 18.23 | 6.36 | [NON MISURATO] | [NON MISURATO] | 0.441 [0.431; 0.451] | 88876 | +0.007 | [NON MISURATO] | -0.052 |
| S&P (SPXUSD) [sec.] | short | a_ST_M3 | ALLINEATO | 4293 | 2.83 | 0.78 | [NON MISURATO] | [NON MISURATO] | 0.490 [0.474; 0.505] | 325 | -0.029 | [NON MISURATO] | -0.269 |
| S&P (SPXUSD) [sec.] | short | a_ST_M3 | CASUALE_B | 92381 | 3.06 | 0.75 | [NON MISURATO] | [NON MISURATO] | 0.494 [0.490; 0.497] | 10717 | -0.018 | [NON MISURATO] | -0.258 |
| S&P (SPXUSD) [sec.] | short | b_1ATR_H1 | ALLINEATO | 4293 | 3.82 | 1.00 | [NON MISURATO] | [NON MISURATO] | 0.491 [0.474; 0.508] | 943 | -0.030 | [NON MISURATO] | -0.202 |
| S&P (SPXUSD) [sec.] | short | b_1ATR_H1 | CASUALE_B | 92381 | 4.25 | 1.00 | [NON MISURATO] | [NON MISURATO] | 0.495 [0.491; 0.499] | 23573 | -0.024 | [NON MISURATO] | -0.182 |
| S&P (SPXUSD) [sec.] | short | c_ST_H4 | ALLINEATO | 4270 | 22.10 | 5.78 | [NON MISURATO] | [NON MISURATO] | 0.529 [0.483; 0.574] | 3816 | -0.008 | [NON MISURATO] | -0.055 |
| S&P (SPXUSD) [sec.] | short | c_ST_H4 | CASUALE_B | 91072 | 23.58 | 5.62 | [NON MISURATO] | [NON MISURATO] | 0.522 [0.512; 0.532] | 81383 | -0.009 | [NON MISURATO] | -0.072 |

**Il numero che conta per la frontiera di casa (`stop >= 40 x spread`)**: lo stop del pannello e' **0,60-0,88 ATR H1 in OGNI anno** (0,72-0,86 per dataset) (tabella per anno in `STOP_PER_ANNO.txt`) [MISURATO]. Quindi stop/spread = ~0,77 x (ATR H1 / spread), e la frontiera si passa solo quando **l'ATR H1 vale almeno ~52 spread** [DERIVATO]. Per anno:
- **DAX 2011-2018**: mediana **9,8x-22,4x**, sopra 40x da 0,1% a 11,9% dei segnali (ATR H1 23,5-50,8 pt contro 1,7 pt di spread BCM). Il DAX di oggi ha un ATR H1 piu' alto: **[NON MISURATO qui]** (nessun M1 DAX 2024-26 raggiungibile da questa sessione); con 1,7 pt servirebbero ~88 pt di ATR H1, con lo spread FTMO d'apertura (1,23 pt, una giornata) ~64 pt [DERIVATO].
- **Oro**: 2006-2019 mediana **5,1x-14,9x**; 2024 20,3x; **2025 39,7x (49,2% sopra 40x)**; **2026 72,3x (94,4% sopra 40x)**, con lo spread BCM 0,2003 $. Con lo spread FTMO di una giornata (0,45 $) il 2026 scende a ~32x [DERIVATO: 72,3 x 0,2003/0,45].
- La stima del mandato ("pannello M3 ~8,6x per radice del tempo", [DERIVATO] dal Dow H1 a 38,5x) e' **dello stesso ordine** dei DAX/oro 2006-2019 misurati qui (5-22x); sull'oro di oggi e' sbagliata per eccesso di prudenza.
- **Ma passare la frontiera non crea un vantaggio**: con il fenomeno nullo, l'aspettativa lorda e' ~0 (da -0,022 a +0,046 R, stop a e b) e il netto e' lo spread in R con il segno meno. Sull'oro 2026 lo spread costerebbe poco (~1/72 di R), ma non c'e' niente con cui pagarlo.

## 5. Gli orizzonti (descrittivo) -- effetto ALL - B e IC; N = NULLO, ZG = ZONA GRIGIA, EFF = EFFETTO

| simbolo / feed | lato | H30 | H60 | H120 | H240 |
|---|---|---|---|---|---|
| DAX (D30EUR) | long | -0.023 [-0.043;-0.004] ZG | -0.018 [-0.043;+0.008] N | -0.031 [-0.064;+0.001] ZG | -0.053 [-0.095;-0.012] ZG |
| DAX (D30EUR) | short | +0.000 [-0.020;+0.021] N | +0.015 [-0.011;+0.041] N | +0.041 [+0.006;+0.075] ZG | +0.053 [+0.011;+0.095] EFF |
| Oro A (Oanda 06-20) | long | -0.011 [-0.023;+0.001] N | -0.007 [-0.023;+0.010] N | -0.007 [-0.029;+0.015] N | -0.009 [-0.037;+0.019] N |
| Oro A (Oanda 06-20) | short | -0.006 [-0.020;+0.009] N | -0.012 [-0.029;+0.007] N | -0.010 [-0.033;+0.016] N | -0.013 [-0.043;+0.020] N |
| Oro B (HistData 21-26) | long | +0.010 [-0.010;+0.029] N | +0.005 [-0.018;+0.031] N | +0.018 [-0.017;+0.051] ZG | +0.059 [+0.015;+0.103] EFF |
| Oro B (HistData 21-26) | short | -0.005 [-0.026;+0.017] N | +0.003 [-0.026;+0.031] N | -0.008 [-0.044;+0.029] N | -0.009 [-0.049;+0.035] N |
| S&P (SPXUSD) [sec.] | long | -0.028 [-0.049;-0.007] ZG | -0.011 [-0.038;+0.016] N | -0.035 [-0.071;-0.002] ZG | -0.024 [-0.070;+0.022] ZG |
| S&P (SPXUSD) [sec.] | short | -0.005 [-0.026;+0.016] N | -0.016 [-0.044;+0.012] N | -0.009 [-0.043;+0.029] N | -0.001 [-0.046;+0.049] N |

Due EFFETTO isolati a 240 minuti, su lati e simboli diversi: **DAX short +0,053** e **oro B long +0,059** (il secondo nel TORO 2023-25 dell'oro). Nessuno si ripete sull'altro lato ne' sul gemello (oro A a 240: -0,009 / -0,013). Sugli **indici il lato long va un po' PEGGIO del caso a 2-4 ore** (DAX -0,031/-0,053, S&P -0,035/-0,024, IC che a tratti escludono lo zero): e' l'unico disegno che si ripete su due simboli, ed e' di segno **contrario** all'idea della dashboard. Indizio, non promosso.

**Molti confronti**: 198 righe descrittive con verdetto (orizzonti x varianti x orologi x regimi x fasce): 122 NULLO, 69 ZONA GRIGIA, **2 EFFETTO, 5 CONTRARIO** (i 5 CONTRARIO sono tutti lato long degli indici a 120-240 minuti). Con soglie a ~2,5% per coda e |effetto| >= 0,05, qualche riga cosi' e' attesa per caso [DERIVATO]; nessuna regge "due simboli e due lati".

## 6. PLACEBO e orologio (cella R_60, effetto ALL - B)

| simbolo / feed | lato | ST10x3.5 (dashboard) | ST10x2.5 | ST10x3.0 | ST14x3.5 | orologio H4+60 (FTMO ~) |
|---|---|---|---|---|---|---|
| DAX (D30EUR) | long | -0.018 (n 2820) N | -0.025 (n 4745) ZG | -0.027 (n 3437) ZG | -0.025 (n 2832) ZG | -0.012 (n 2729) N |
| DAX (D30EUR) | short | +0.015 (n 2638) N | -0.001 (n 3882) N | +0.014 (n 3271) N | +0.017 (n 2587) N | +0.002 (n 2701) N |
| Oro A (Oanda 06-20) | long | -0.007 (n 9473) N | -0.000 (n 14587) N | -0.001 (n 11551) N | -0.010 (n 9484) N | -0.003 (n 9219) N |
| Oro A (Oanda 06-20) | short | -0.012 (n 8417) N | -0.006 (n 13352) N | -0.005 (n 10414) N | -0.012 (n 8375) N | -0.013 (n 8594) N |
| Oro B (HistData 21-26) | long | +0.005 (n 3312) N | +0.003 (n 5592) N | -0.012 (n 4230) N | -0.004 (n 3403) N | +0.008 (n 3414) N |
| Oro B (HistData 21-26) | short | +0.003 (n 3245) N | +0.001 (n 4719) N | -0.006 (n 3901) N | +0.021 (n 3113) ZG | +0.009 (n 3154) N |
| S&P (SPXUSD) [sec.] | long | -0.011 (n 4600) N | -0.016 (n 7179) N | -0.002 (n 5851) N | -0.014 (n 4780) N | -0.023 (n 4614) ZG |
| S&P (SPXUSD) [sec.] | short | -0.016 (n 4417) N | +0.006 (n 6605) N | -0.011 (n 5253) N | -0.011 (n 4091) N | -0.018 (n 4415) N |

Nessun parametro del Supertrend accende qualcosa: con 2,5 / 3,0 / ATR 14 l'effetto sta fra -0,027 e +0,021 (le ZONA GRIGIA del DAX long sono **negative**, -0,025..-0,027). Spostando i bordi H4 di un'ora (UTC+2, ~ FTMO d'inverno; l'estate UTC+3 NON e' coperta) il numero di segnali ALLINEATO cambia di meno dello 0,5% e nessun verdetto si accende.

### Regimi e fasce orarie (cella R_60, effetto ALL - B, senza banda delle estrazioni)

| simbolo / feed | lato | TORO | LATERALE | ORSO | notte 22-07 | giorno 08-16 | sera 17-21 |
|---|---|---|---|---|---|---|---|
| DAX (D30EUR) | long | -0.018 (n 1276) ZG | -0.024 (n 1101) ZG | -0.003 (n 443) ZG | +0.031 (n 155) ZG | -0.024 (n 1954) ZG | -0.008 (n 711) N |
| DAX (D30EUR) | short | +0.013 (n 812) ZG | +0.005 (n 992) ZG | +0.029 (n 834) ZG | +0.058 (n 186) ZG | +0.016 (n 1868) N | -0.005 (n 584) N |
| Oro A (Oanda 06-20) | long | -0.014 (n 5354) N | +0.009 (n 3129) N | -0.029 (n 990) ZG | -0.009 (n 4186) N | -0.004 (n 3775) N | -0.011 (n 1512) N |
| Oro A (Oanda 06-20) | short | -0.006 (n 4043) N | -0.015 (n 2943) N | -0.016 (n 1431) ZG | -0.005 (n 3622) N | -0.015 (n 3468) ZG | -0.024 (n 1327) ZG |
| Oro B (HistData 21-26) | long | +0.021 (n 1911) ZG | -0.016 (n 1401) ZG | - | +0.004 (n 1422) N | +0.027 (n 1335) ZG | -0.043 (n 555) ZG |
| Oro B (HistData 21-26) | short | -0.020 (n 1610) ZG | +0.025 (n 1635) ZG | - | -0.009 (n 1386) N | +0.015 (n 1331) ZG | +0.000 (n 528) ZG |
| S&P (SPXUSD) [sec.] | long | -0.006 (n 2310) N | -0.024 (n 1710) ZG | +0.000 (n 580) ZG | +0.008 (n 1169) N | -0.023 (n 2405) ZG | -0.015 (n 1026) ZG |
| S&P (SPXUSD) [sec.] | short | -0.028 (n 1864) ZG | +0.002 (n 1822) N | -0.025 (n 731) ZG | -0.009 (n 1339) N | -0.033 (n 2254) ZG | +0.012 (n 824) ZG |

### I gruppi a 60 minuti (R in ATR H1; punti nel prezzo del feed)

| simbolo / feed | lato | gruppo | n | R medio | R mediano | MFE | MAE | punti medi | netto |
|---|---|---|---|---|---|---|---|---|---|
| DAX (D30EUR) | long | ALLINEATO | 2820 | -0.020 | -0.036 | 0.534 | 0.559 | -0.74 | -0.093 |
| DAX (D30EUR) | long | CASUALE_B | 59540 | -0.002 | +0.019 | 0.520 | 0.541 | -0.01 | -0.076 |
| DAX (D30EUR) | long | CONTRO | 2662 | -0.007 | -0.019 | 0.526 | 0.543 | -0.42 | -0.062 |
| DAX (D30EUR) | long | CASUALE_CON | 55960 | -0.001 | +0.018 | 0.507 | 0.534 | -0.03 | -0.056 |
| DAX (D30EUR) | long | H4_INSTABILE | 425 | -0.019 | -0.040 | 0.452 | 0.470 | -0.31 | -0.076 |
| DAX (D30EUR) | short | ALLINEATO | 2638 | +0.018 | -0.027 | 0.592 | 0.524 | +0.46 | -0.036 |
| DAX (D30EUR) | short | CASUALE_B | 55360 | +0.003 | -0.016 | 0.541 | 0.514 | +0.07 | -0.051 |
| DAX (D30EUR) | short | CONTRO | 2856 | -0.002 | -0.054 | 0.598 | 0.543 | -0.24 | -0.075 |
| DAX (D30EUR) | short | CASUALE_CON | 60360 | +0.000 | -0.021 | 0.546 | 0.528 | -0.04 | -0.074 |
| DAX (D30EUR) | short | H4_INSTABILE | 419 | -0.069 | -0.080 | 0.476 | 0.513 | -2.30 | -0.126 |
| Oro A (Oanda 06-20) | long | ALLINEATO | 9473 | +0.005 | -0.023 | 0.605 | 0.597 | -0.01 | -0.074 |
| Oro A (Oanda 06-20) | long | CASUALE_B | 196320 | +0.012 | +0.007 | 0.568 | 0.569 | +0.01 | -0.066 |
| Oro A (Oanda 06-20) | long | CONTRO | 8547 | -0.021 | -0.019 | 0.600 | 0.613 | -0.08 | -0.095 |
| Oro A (Oanda 06-20) | long | CASUALE_CON | 176240 | -0.005 | +0.003 | 0.561 | 0.579 | -0.01 | -0.079 |
| Oro A (Oanda 06-20) | long | H4_INSTABILE | 1400 | +0.015 | -0.020 | 0.512 | 0.509 | +0.09 | -0.051 |
| Oro A (Oanda 06-20) | short | ALLINEATO | 8417 | -0.002 | -0.035 | 0.637 | 0.599 | -0.00 | -0.077 |
| Oro A (Oanda 06-20) | short | CASUALE_B | 174520 | +0.010 | +0.000 | 0.585 | 0.561 | +0.02 | -0.064 |
| Oro A (Oanda 06-20) | short | CONTRO | 9576 | -0.026 | -0.044 | 0.624 | 0.604 | -0.06 | -0.106 |
| Oro A (Oanda 06-20) | short | CASUALE_CON | 197880 | -0.010 | -0.003 | 0.576 | 0.570 | -0.01 | -0.088 |
| Oro A (Oanda 06-20) | short | H4_INSTABILE | 1403 | -0.024 | -0.044 | 0.532 | 0.537 | -0.10 | -0.089 |
| Oro B (HistData 21-26) | long | ALLINEATO | 3312 | +0.022 | -0.004 | 0.562 | 0.545 | +0.09 | -0.016 |
| Oro B (HistData 21-26) | long | CASUALE_B | 67720 | +0.017 | +0.013 | 0.543 | 0.552 | +0.08 | -0.021 |
| Oro B (HistData 21-26) | long | CONTRO | 3269 | -0.016 | -0.012 | 0.561 | 0.584 | -0.19 | -0.056 |
| Oro B (HistData 21-26) | long | CASUALE_CON | 67280 | +0.003 | +0.004 | 0.539 | 0.554 | -0.02 | -0.035 |
| Oro B (HistData 21-26) | long | H4_INSTABILE | 427 | +0.016 | +0.005 | 0.502 | 0.470 | +0.29 | -0.018 |
| Oro B (HistData 21-26) | short | ALLINEATO | 3245 | +0.005 | -0.030 | 0.613 | 0.568 | +0.12 | -0.034 |
| Oro B (HistData 21-26) | short | CASUALE_B | 66600 | +0.003 | +0.001 | 0.562 | 0.541 | -0.00 | -0.035 |
| Oro B (HistData 21-26) | short | CONTRO | 3324 | -0.026 | -0.058 | 0.594 | 0.577 | -0.40 | -0.064 |
| Oro B (HistData 21-26) | short | CASUALE_CON | 68620 | -0.021 | -0.016 | 0.554 | 0.547 | -0.08 | -0.059 |
| Oro B (HistData 21-26) | short | H4_INSTABILE | 417 | +0.007 | -0.009 | 0.533 | 0.504 | -0.08 | -0.027 |
| S&P (SPXUSD) [sec.] | long | ALLINEATO | 4600 | -0.008 | +0.000 | 0.688 | 0.750 | -0.04 | [NON MISURATO] |
| S&P (SPXUSD) [sec.] | long | CASUALE_B | 112720 | +0.003 | +0.000 | 0.644 | 0.673 | +0.01 | [NON MISURATO] |
| S&P (SPXUSD) [sec.] | long | CONTRO | 4441 | +0.024 | +0.042 | 0.676 | 0.682 | +0.08 | [NON MISURATO] |
| S&P (SPXUSD) [sec.] | long | CASUALE_CON | 101280 | +0.007 | +0.011 | 0.617 | 0.641 | +0.04 | [NON MISURATO] |
| S&P (SPXUSD) [sec.] | long | H4_INSTABILE | 753 | -0.029 | +0.000 | 0.509 | 0.561 | -0.13 | [NON MISURATO] |
| S&P (SPXUSD) [sec.] | short | ALLINEATO | 4417 | -0.020 | -0.051 | 0.722 | 0.704 | -0.07 | [NON MISURATO] |
| S&P (SPXUSD) [sec.] | short | CASUALE_B | 100140 | -0.004 | -0.016 | 0.647 | 0.621 | -0.04 | [NON MISURATO] |
| S&P (SPXUSD) [sec.] | short | CONTRO | 4670 | -0.016 | -0.036 | 0.764 | 0.738 | -0.02 | [NON MISURATO] |
| S&P (SPXUSD) [sec.] | short | CASUALE_CON | 114060 | -0.007 | +0.000 | 0.668 | 0.646 | -0.01 | [NON MISURATO] |
| S&P (SPXUSD) [sec.] | short | H4_INSTABILE | 740 | -0.087 | -0.083 | 0.543 | 0.615 | -0.40 | [NON MISURATO] |

Da notare: **MFE e MAE stanno quasi pari** in ogni gruppo (0,53-0,64 contro 0,52-0,61 ATR H1 sui primari): dopo il segnale il prezzo si allontana tanto a favore quanto contro. E' la firma di un istante senza informazione.

## 7. I contro-esempi, controllati (non solo scritti)

| contro-esempio | che cosa ho trovato | effetto sul verdetto |
|---|---|---|
| **Trend persistente / la direzione H4 e' quella del giorno** | B (H4 da solo) a 60 minuti: da -0,002 a +0,017 ATR H1 sui primari; a 240 minuti da +0,000 a +0,071 (il massimo: oro B long, TORO) [MISURATO, T7 e CSV]. L'autotest con deriva costante da' B +0,121 e ALL +0,109: la deriva sta in B e la cella resta NULLO | la cella confronta ALL con B: la deriva si cancella. Quel poco di valore che c'e' a 2-4 ore e' della direzione H4, non dell'M3 |
| **Controllo appaiato per MESE** (mia aggiunta ai criteri, poi tolta PRIMA dei dati) | su 6 random walk dava B **+0,011..+0,034** (media +0,024) contro ~0 della media vera: il peso del mese dipende dal futuro dell'istante estratto | appaiamento per sola ora (la definizione del mandato); resta nell'autotest come contro-esempio che deve accendersi (+0,020). Classe nuova |
| **Look-ahead H4** (barra in formazione) | il mutante sposta B di solo **+0,018**: il filtro di stabilita' della dashboard scarta i casi in cui la barra in formazione si gira, quindi il test del random walk da solo NON lo vedrebbe | guardia deterministica: per ognuna delle 1.247.921 chiusure M3 sintetiche la barra H4 usata e' chiusa ed e' l'ultima chiusa; sui dati veri stesso codice. Classe nuova |
| **Volatilita' per ora del giorno** | R normalizzato con l'ATR H1 dell'istante; B con la stessa distribuzione oraria; autotest su random walk con volatilita' oraria x5 (0,4-2,0): ALL +0,014/+0,014, B +0,005/-0,004, NULLO/NULLO | nessuno |
| **Momentum M3 senza H4** (A3) | autotest: ALL - B +0,261 ma ALL - CON +0,006 e incremento +0,017: lo strumento separa "e' l'M3" da "e' la confluenza". Sui dati veri ALL ~ B ~ CON: non c'e' nemmeno il momentum M3 | nessuno |
| **Strumento cieco** (classe 1014) | autotest con effetto PIANTATO (deriva per 60 minuti dopo ogni inversione M3 allineata, generata in tempo reale con lo stesso Supertrend): **EFFETTO** +0,250 / +0,212 con IC [+0,230;+0,271] / [+0,193;+0,233], incremento sul CONTRO +0,217 | lo strumento vede un effetto quando c'e' |
| **Supertrend diverso da quello della dashboard** | identita' al bit con `py_stcore` (collaudato contro il C++ della v4.1) su sintetico e sulle prime 20.000 barre M3 vere di ogni dataset; righe chiave di `SW_STCore`/`SW_Confl` e default (10; 3,5; H4 stabile 3) ritrovati nel `.mq5`; finestra di 1000 barre: 0 discordanze su 1.200 eventi | nessuno |
| **Feed piatto (Oanda)** | ATR H1 0,0014 $ -> R fino a 2.350 | filtro di qualita' del feed (sez. 1), dichiarato come cambio DOPO i dati |
| **Costo di un'altra epoca** | spread BCM 2024-26 applicato a prezzi 2010-18 (DAX) e 2006-20 (oro A) | la cella che decide e' LORDA; il rapporto stop/spread e' dato per anno (sez. 4) |
| **Ingresso alla chiusura** | nessuno slittamento simulato oltre lo spread | ottimista per il segnale; non cambia un verdetto NULLO |

## 8. Attese dichiarate prima, contro i numeri

- **E1** (B entro +/-0,02): **regge** (da -0,004 a +0,017).
- **E2** (effetto fra -0,04 e +0,02, nessun EFFETTO): **regge** (-0,018..+0,015). La parte "segno negativo piu' probabile sul DAX" **non** regge: long -0,018, short +0,015.
- **E3** (|ALL - CON| < 0,03): **regge sul DAX e sull'oro A, NON sull'oro B** (+0,038 / +0,031, IC che toccano lo zero) e S&P long (-0,031). A incrementi regge ovunque (<= 0,028).
- **E4** (costo): stop (a) DAX 13,7-17,5x (atteso 10-25: **regge**), oro A 10,1-10,4x (8-20: **regge**), oro B 20,4-21,3x (15-35: **regge**); "meno del 20% sopra 40x" **regge su DAX e oro A, NON sull'oro B (25-26%)** perche' l'ATR dell'oro 2025-26 e' esploso (sez. 4). Stop (b) e (c): **reggono**.
- **E5** (P_1R 0,44-0,51, netto negativo): netto negativo **regge** (5 IC su 6 sotto zero); P_1R **sfora in alto** su DAX short (0,534) e oro A short (0,513).
- **E6** (2-6 segnali al giorno): **regge** (DAX 2,80; oro A 4,33; oro B 4,05; S&P 4,49).

## 9. Che cosa NON ho raggiunto, e la via piu' corta al numero

| buco | perche' | via piu' corta |
|---|---|---|
| **NASUSD (US100)** | `NSXUSD` 404 sul mirror; il CSV M1 vive solo sul PC di backtest (`%USERPROFILE%\abtg_storico_indici\NASUSD_M1.csv`) | lo strumento legge solo i dataset di `ema200_rimbalzo.py`: serve aggiungere l'opzione `--file` (come `ema200_rimbalzo.py`), poi una riga sul PC di backtest che passi dal cancello. **Riga NON scritta** |
| **U30USD (US30)** | nessun feed esterno; BCM solo dal 2024.09.26; nessuno strumento d'export M1 collaudato | export M1 da MT5 (script nuovo, cancello) |
| **Feed BCM / ATR DAX di oggi** | non raggiungibile | stesso export: darebbe anche lo stop/spread del DAX di oggi |
| **Forex della griglia** (25 simboli della dashboard) | nessun M1 forex in cache in questa sessione | -- |
| **Gestione della dashboard** (TP1/TP2/TP3 a 1/2/3 R, quote 40/30/30), **stop H4 su piu' giorni**, **confluenza modo 0** | fuori dal disegno congelato | e' un motore, non un fenomeno: andrebbe nell'imbuto con i suoi cancelli. Con il timing nullo misurato qui, il suo eventuale vantaggio dovrebbe venire dall'uscita o dalla direzione H4, non dall'ingresso M3 [INFERITO] |
| **Spread S&P** | [NON MISURATO] sul nostro broker | spread logger |
| **Dipendenza fra giorni** | IC a blocchi di un giorno | blocchi di settimana (non fatto) |

## 10. Che cosa ho controllato prima di consegnare (lo Sviluppatore contro l'Agente dei Controlli)

- **Criteri committati e pushati prima di ogni dato vero** (`0523b049`, 21:28:17 UTC). **Emendamento prima dei dati** (`e122978a`, 21:41:49 UTC), nato dall'autotest SINTETICO: controllo appaiato per mese distorto (+0,024 su 6 random walk), B' tolto, test del look-ahead reso deterministico. Primo dato vero: 21:41:54 UTC.
- **Un solo cambio dopo i dati**: il filtro di qualita' del feed (sez. 1), con il prima e il dopo scritti.
- **Autotest 29/29** (`autotest.log`), con i casi che DEVONO accendersi (classe 1014): effetto piantato -> EFFETTO; controllo per mese -> distorto; look-ahead mutante -> B sale; deriva -> B sale e la cella no; momentum M3 -> ALL - B sale e l'incremento no; mult 3,5 -> 2,5 -> eventi +67%; orologio +1h -> eventi cambiano; G-OROLOGIO boccia un file in EST fisso.
- **Il mio primo autotest aveva un atteso sbagliato** (primo passaggio short: avevo scritto TP, era SL): corretto il test, lo strumento era giusto.
- **Riconto indipendente** a cicli espliciti (barre, Supertrend dallo specchio `py_stcore`, mappa H4 con `bisect`, esiti) della cella ALLINEATO/CONTRO a 60 minuti su DAX e oro B: conteggi e medie **identici** (`VERIFICA_INDIPENDENTE.txt`).
- **Determinismo**: tutte e 4 le corse rilanciate dopo l'ultimo ritocco dello strumento: 4 CSV **identici al byte**.
- Tabelle di questo referto **generate dai CSV**, non ricopiate.
- Nessun EA, preset, sedia, conto, terminale toccato. Zero Strategy Tester, zero VPS, nessuna riga di lancio.

**Che cosa il cancello indipendente dovrebbe provare a rompere** (non coperto da me): un'implementazione indipendente anche del **controllo B** e del **bootstrap** (il mio riconto copre ALLINEATO/CONTRO, non B ne' gli IC); gli stop (a)/(c) e il primo passaggio sui dati veri; l'oro A con un filtro di qualita' diverso (es. escludere le barre H1 piatte invece di una soglia sull'ATR) per vedere che il verdetto non dipende dalla soglia 0,1; i blocchi di una settimana negli IC.
