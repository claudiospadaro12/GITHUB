# Goldbot One con i set del venditore (Risk=3): RISULTATI (30/10/2026)
Criteri e previsioni scritti prima: `GOLDBOT_ONE_SET_VENDITORE_CRITERI_2026-10-29.md` (commit 8c7f9ee4). Fonte: zip `ANNO80K_GOLDBOT_SETVEND_20261030_0145` (riga `RIGA_LANCIA_GOLDBOT_SETVEND_80K.txt`, pin 3e43646d; archivio `backtest_pipeline/risultati_archivio/ANNO80K_GOLDBOT_SETVEND_20261030_0145`, report compressi). Lettori `leggi_goldbot_setvend.py` (esiti, giorni realizzati, calibrazione) e `leggi_portafoglio_prop_oro_combo_gb.py` (portafoglio con equity da barre M1). 80.000 EUR, XAUUSD D1, Modello 1 salvo dove detto, `Risk=3`, tutti gli input imposti. Non controllata da agenti.

**Validita:** 16/16 OK, `input_ok = si` ovunque, 0 stop out, qualita 99-100% (21 mesi a tick reali 100%). **K0 (controllo): SI, esattamente**: LOW3 sui 21 mesi M1 = +51.745,04 / DD equity 10.828,83, come la sonda 3 del 21/10 (+51.745, 10.829).

## Risultati (netto EUR / DD equity EUR / peggior giorno REALIZZATO)
| Configurazione | 2013 | 2018 | 2020 | 2025 (M1) | 21 mesi M1 | 21 mesi tick reali |
|---|---|---|---|---|---|---|
| **PF105** (PropFirm_10_5: MaxRisk 2, limite 4) | +38.133 / 7.608 (6,05%) / -4,25% | +9.349 / 6.997 / -2,26% | +25.237 / 3.854 / -2,23% | +19.571 / 3.685 / -2,25% | +31.697 / 6.266 / -2,57% | **+26.410 / 7.769 / -2,96%** |
| **PF525** (PropFirm_5_2.5: MaxRisk 1, limite 2) | +17.445 / 3.062 / -2,11% | +4.638 / 3.270 / -1,12% | +11.840 / 1.749 / -1,07% | +8.999 / 1.637 / -1,08% | +14.406 / 2.479 / -1,21% | - |
| **LOW3** (LowRisk_Max15DD: MaxRisk 3, nessun limite) | +61.766 / **14.927** / **-6,95%** | +14.062 / **10.990** / -3,42% | +40.281 / 6.337 / -3,35% | +31.206 / 6.146 / -3,38% | +51.745 / 10.829 / -3,89% | - |
Peggior giorno 2013 = 31/12/2013 per tutti (ultimo giorno del test: da leggere con cautela, non verificato se e un effetto di fine finestra). Una riga "no money" in LOW3 2013, nessuna altrove. Operazioni: 290 / 294 / 259 / 237 (2013/2018/2020/2025) e 451 sui 21 mesi, uguali per le tre configurazioni (cambia solo il lotto).

## PROP-ANNI (netto > 0, DD equity <= 8.000, nessuno stop out, nessun giorno realizzato >= 5%)
- **PF525: SI** (DD 3.062 / 3.270 / 1.749).
- **PF105: SI** (DD 7.608 / 6.997 / 3.854): il 2013 sta a 392 EUR dal limite; la corsa a tick reali sui 21 mesi ha DD 7.769 contro 6.266 a Modello 1 (+24%): [DERIVATO, NON MISURATO] se i tick reali alzassero il DD del 2013 in proporzione, supererebbe 8.000. Calibrazione 2025 PF105: **OK** (rapporto M1/M4 sui 21 mesi 1,20, correlazione mensile 0,99).
- **LOW3: NO** (2013 DD 14.927 e giorno -6,95%; 2018 DD 10.990).

## Portafoglio con il Reaper 9 (set prop, Randomization 0), equity da barre M1, PORT-OK = perdita <= 8% dal deposito e giorno < 5% in OGNI anno
| Combinazione | 2013 perdita / giorno | 2018 | 2020 | 2025 | netto medio/anno | PORT-OK |
|---|---|---|---|---|---|---|
| Reaper 9 + Goldbot del test 26/10 (Risk 9999 step 6000) | 5,7% / -4,72% | 3,3% / -3,91% | 0 / -1,95% | 2,9% / -2,59% | +29.935 | SI |
| **Reaper 9 + PF525** | 6,0% / -4,73% | 4,0% / -4,56% | 0 / -2,03% | 3,2% / -2,79% | **+33.399** | **SI** |
| Reaper 9 + PF105 | 7,7% / **-5,69%** | 5,9% / **-6,51%** | 0,2% / -2,97% | 4,0% / -3,83% | +46.529 | **NO** |
| Reaper 6 + PF105 | 7,7% / -4,88% | 5,2% / **-5,59%** | 0,3% / -2,76% | 3,2% / -3,44% | +38.179 | NO |
| Reaper 9 + LOW3 | 9,4% / -6,98% | 7,8% / -8,45% | 0,4% / -3,94% | 4,8% / -5,08% | +61.618 | NO |
| Reaper 9 + PF525 + Phantom D4 | 7,1% / -5,21% | 4,4% / -5,03% | 0 / -2,25% | 3,2% / -2,89% | +37.381 | NO (bordo) |
| Reaper 9 + PF105 + Phantom D4 / D9 | 8,8% / -5,73% ; 10,4% / -6,06% | 6,3% / -6,98% ; 6,8% / -7,59% | - | - | +50.511 ; +56.221 | NO |
| Reaper 9 + PF105 + Gold Trade Pro | 13,0% / -9,73% | 7,9% / -9,82% | 0,6% / -4,59% | 6,2% / -6,90% | +69.076 | NO |
Il Guardian non e incluso. Somma di corse indipendenti; ogni EA sul proprio saldo da 80.000 (vedi limiti del 28/10).

## Previsioni contro esito
K0 SI. Q1 (PF525 PROP-ANNI, 85%) **SI**. Q2 (PF105 PROP-ANNI, 45%) **SI**. Q3 (LOW3 PROP-ANNI, 20%) **NO**. Q4 (ordine LOW3 > PF105 > PF525 per netto e DD in ogni anno, 90%) **SI**. Q5 (PF105 21 mesi: netto 20-40 mila e DD 4.500-9.000, 55%) **SI** (31.697 / 6.266). Q6 (PF105 piu del doppio del vecchio set, 75%) **SI** (31.697 contro 11.173, x2,8; a tick reali 26.410, x2,4). Q7 (2018 anno col DD piu alto per PF105, 65%; DD 2018 > 8.000, 30%) **NO e NO** (il piu alto e il 2013, 7.608). Q8 (nessun giorno realizzato >= 3% in PF105 e PF525, 80%) **NO** (PF105 ne ha 2 nel 2013, con il 31/12 a -4,25%). Q9 (calibrazione PF105 OK, 85%) **SI**. Q10 (nessun "no money" in PF105/PF525, 90%) **SI**. Q11 (Reaper 9 + PF105 PORT-OK 35%; + PF525 85%) **NO e SI**. 8 su 11 giuste.

## Lettura
- **I set di Wim a `Risk=3` non sono quelli che abbiamo testato il 26/10 e rendono molto di piu**: a parita di anni PF105 fa il 2,8 volte il vecchio set sui 21 mesi (26.410 contro 11.173 a tick reali, 31.697 a Modello 1) con DD 6.266-7.769 contro 3.213. PF525 fa circa il doppio (14.406 a M1) con DD 2.479.
- **PF105 passa da solo ma NON in portafoglio col Reaper 9**: il giorno 2013 sale a -5,7% e il 2018 a -6,5%. **PF525 passa in portafoglio** (giorno peggiore -4,73% nel 2013, perdita 6,0%) e rende piu del vecchio Goldbot (+33.399 contro +29.935 all anno).
- Il giorno peggiore e il DD del 2013 cadono su una finestra che finisce il 31/12: NON VERIFICATO se il 31/12/2013 e un effetto di fine finestra.
- Limiti: un percorso per anno; Modello 1 sui tre anni vecchi; 2013/2018/2020 probabilmente dentro l ottimizzazione del venditore; nessuna slippage; filtro news non simulato; margine con leva 1:10 non simulato; `Risk=3` = Max Risk Per Strategy e dedotto. Nessun giudizio su acquisto, lotto o taglia.
