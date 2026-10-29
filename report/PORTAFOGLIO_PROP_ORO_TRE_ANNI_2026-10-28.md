# Portafoglio oro in una prop da 80.000: Reaper + Goldbot One + Phantom + Gold Trade Pro, 2013 / 2018 / 2020 / 2025 (28/10/2026)
**Natura: STIMA da somma di corse INDIPENDENTI. Non controllata da agenti.** Richiesta di Claudio (28/10): "se li tenessi tutti in una prop come sarebbe rendimento e DD, verifica nei tre anni". Il tester MT5 fa girare un EA per volta: qui si SOMMANO le liste affari delle corse gia fatte (80.000 EUR ciascuna, set prop: Reaper `MaxAllowedDD` 9 + limite 4%; Goldbot One step 6000; Phantom PROPFIRM D9; Gold Trade Pro PROPFIRM R1). Strumenti: `backtest_pipeline/leggi_portafoglio_prop_oro.py` (equita da barre M1: SOLO 2013 e 2025, le uniche esportate) e `leggi_portafoglio_prop_oro_realizzato.py` (solo realizzato, tutti gli anni). Dati in `risultati_archivio/` (Reaper: `ANNO80K_TRE_EA_ZIP_1444`, `GR80K_20261020`; Goldbot One: `ANNO80K_GOLDBOT_ZIP_1608`; Phantom e Gold Trade Pro: `ANNO80K_SUPER_20261028_1933`); le barre M1 vengono dall'export del 27/10 (non nel repo). Equita = realizzato + flottante da barre M1 (centrale = chiusura barra, pessimistica = estremo); giorno FTMO = mezzanotte CE(S)T.

## Equita ricostruita (2013 Modello 1; 2025 tick reali, 12 mesi)
| Anno | Combinazione | Netto | Equity minima (perdita dal deposito) | DD dal picco | Peggior giorno | giorni >= 3/4/5% | Lotti max insieme |
|---|---|---|---|---|---|---|---|
| 2013 | Reaper | +24.000 (+30,0%) | -4,37% | 5.219 | **-4,57%** | 3/1/0 | 9,43 |
| 2013 | Reaper + Goldbot | +35.304 | -5,67% | 6.403 | -4,72% | 3/2/0 | 9,65 |
| 2013 | Reaper + Goldbot + Phantom | +45.627 | **-8,43%** | 8.545 | **-5,79%** | 3/3/1 | 11,48 |
| 2013 | i 4 (con Gold Trade Pro) | +81.943 | **-13,73%** | 14.682 | **-10,60%** | 5/3/2 | 19,54 |
| 2025 | Reaper | +27.460 (+34,3%) | -2,77% | 2.731 | -2,32% | 0/0/0 | 1,93 |
| 2025 | Reaper + Goldbot | +35.303 | -2,99% | 3.720 | -2,57% | 0/0/0 | 2,41 |
| 2025 | Reaper + Goldbot + Phantom | +48.393 | -3,03% | 4.356 | -2,94% | 0/0/0 | 2,82 |
| 2025 | i 4 | +67.762 | -5,98% | 5.939 | **-6,32%** | 3/2/1 | 4,57 |
(netto al 30/12 dell'anno, in 2013 a ultimo giorno 31/12 le barre finiscono alle 16:59.) Gli stessi risultati in pessimistica differiscono di meno di 0,2 punti.

## Solo realizzato (tutti gli anni): netto / DD di saldo / peggior giorno / giorni per +8.000 e +4.000 dal primo giorno
| Anno | Reaper | + Goldbot | + Phantom | + Gold Trade Pro (i 4) |
|---|---|---|---|---|
| 2013 | +21.757 / 5.118 (6,4%) / -4,57% / 120 e 91 gg | +31.952 / 6.277 / -4,60% / 99 e 69 | +41.089 / 8.395 (10,5%) / -5,23% / 91 e 53 | +73.996 / 14.540 (18,2%) / -10,04% / 68 e 48 |
| 2018 | +13.535 / 4.546 / -2,22% / 236 e 176 | +15.891 / 4.669 / -2,32% / 199 e 177 | +20.750 / 5.662 / -2,96% / 179 e 143 | +39.416 / 7.477 / -6,32% / 134 e 107 |
| 2020 | +20.388 / 2.874 / -1,63% / 51 e 48 | +30.046 / 3.234 / -1,57% / 51 e 7 | +39.586 / 4.177 / -2,22% / 50 e 6 | +54.171 / 7.323 / -3,61% / 23 e 5 |
| 2025 | +27.985 / 2.634 / -1,12% / 112 e 92 | +35.829 / 3.623 / -1,65% / 105 e 86 | +49.036 / 4.228 / -2,13% / 89 e 76 | +68.257 / 5.307 / -3,44% / 86 e 72 |
Il DD di saldo e solo realizzato (sottostima l'equita). Per 2018 e 2020 **l'equita NON e ricostruibile**: le barre M1 di quegli anni non sono state esportate. Limite superiore rigoroso (somma dei DD di equity dei singoli, dai report): 2018 Reaper+Goldbot 8.357, +Phantom 10.357, i 4 17.512; 2020 Reaper+Goldbot 5.181, +Phantom 6.982, i 4 17.260 (soglia 8.000).

## Lettura
- **Reaper + Goldbot One:** in 2013 e 2025 resta dentro i limiti FTMO (perdita dal deposito 5,7% / 3,0%, giorno peggiore -4,7% / -2,6%); netto +44% in 2013 e +44% in 2025.
- **Aggiungendo il Phantom:** nel 2025 va bene (-3,0%, giorno -2,9%); nel **2013 no**: giorno peggiore -5,79% (sopra il 5% FTMO) e equity minima -8,4% (sopra la soglia di progetto dell'8%, sotto il 10% FTMO).
- **Con tutti e quattro:** nel 2013 -13,7% dal deposito (oltre il 10% FTMO) e giorno -10,6%; nel 2025 giorno -6,3%. **Non regge.**
- **Rendimento e tempi:** piu EA = piu netto e +8.000 piu in fretta in 2013/2018/2025 (per esempio 2018: 236 giorni col Reaper, 179 con Reaper+Goldbot+Phantom), ma il costo e il DD. Il 2020 e il solo anno in cui si chiude presto con tutte le combinazioni.

## Cosa NON dice
- Somma di corse indipendenti: ogni EA dimensiona i lotti sul proprio saldo da 80.000, non sul saldo combinato; i limiti giornalieri interni (Reaper 4%, Phantom 4%) non si accorgono degli altri EA; ordini rifiutati per margine, interazioni sullo stesso conto e margine NON simulati. Margine a leva 1:9 (Swing, oro): con i lotti sommati supera il conto gia col Reaper da solo (2013: 9,4 lotti ~ 178.000 USD).
- 2013, 2018 e 2020 a Modello 1; un percorso per anno; probabilmente dentro l'ottimizzazione del venditore; nessuna slippage; filtro news non simulato.
- Equita solo per 2013 e 2025; 2018 e 2020 serve un export M1 (finestre 2018 e 2020) per completare. Il Goldbot 2025 e a 12 mesi (tick reali), non 21.
- Nessun giudizio su acquisto, lotto o taglia.

## AGGIORNAMENTO 29/10/2026: equita ricostruita anche per 2018 e 2020
Fonte: zip `EXPORT_M1_ORO_V3_2018_2020_20261029_064758` (riga `RIGA_LANCIA_EXPORT_M1_ORO_V3.txt`): 349.730 barre M1 per il 2018 e 351.258 per il 2020, 0 settimane vuote, 0 errori. Stesso metodo e stesso script (`leggi_portafoglio_prop_oro.py --barre <cartella>`). **Sostituisce la frase "per 2018 e 2020 l'equita NON e ricostruibile" e i limiti superiori scritti sopra.**
| Anno | Combinazione | Netto | Equity min (perdita dal deposito) | DD dal picco | Peggior giorno | giorni >= 3/4/5% | Lotti max insieme |
|---|---|---|---|---|---|---|---|
| 2018 | Reaper | +13.524 (+16,9%) | -2,43% | 4.894 | -2,86% | 0/0/0 | 7,18 |
| 2018 | Reaper + Goldbot | +15.880 | -3,25% | 5.069 | -3,79% | 1/0/0 | 7,65 |
| 2018 | + Phantom | +20.739 | -4,48% | 6.524 | **-4,84%** (pess. -4,99%) | 2/1/0 | 9,35 |
| 2018 | i 4 | +39.405 (+49,3%) | -6,68% | 8.338 | **-8,17%** | 6/2/1 | 17,82 |
| 2020 | Reaper | +21.235 (+26,5%) | mai sotto il deposito | 2.980 | -1,98% | 0/0/0 | 3,30 |
| 2020 | Reaper + Goldbot | +30.893 | mai sotto il deposito | 3.632 | -1,88% | 0/0/0 | 4,32 |
| 2020 | + Phantom | +40.991 | mai sotto il deposito | 4.488 | -2,37% | 0/0/0 | 5,18 |
| 2020 | i 4 | +56.407 (+70,5%) | -0,23% (pess. -0,55%) | 7.544 (pess. 8.070) | -3,77% | 4/0/0 | 8,51 |
**Lettura sui tre anni vecchi + 2025 (equita completa):**
- **Reaper + Goldbot One** resta dentro i limiti FTMO in tutti e quattro gli anni: perdita massima dal deposito 5,7% (2013), 3,3% (2018), 0% (2020), 3,0% (2025); peggior giorno -4,72% (2013), -3,79%, -1,88%, -2,57%.
- **Reaper + Goldbot + Phantom**: giorno peggiore -5,79% nel 2013 (oltre il 5% FTMO) e -4,84% nel 2018 (pessimistica -4,99%, sul bordo); equity minima -8,4% nel 2013 (sopra la soglia di progetto dell'8%).
- **I quattro insieme**: giorno oltre il 5% in 2013 (-10,6%), 2018 (-8,17%) e 2025 (-6,32%); perdita dal deposito -13,7% nel 2013 (oltre il 10%). Nel 2020 regge (-3,77%, DD dal picco 7.544 / 8.070 pessimistica).
- **Margine a leva 1:9 (derivato, nozionale lotti x 100 x prezzo / 9):** supera 80.000 USD gia col Reaper da solo nel 2013 e nel 2018 (circa 177.600 e 99.700) e con tutte le combinazioni piu larghe; solo nel 2020 e nel 2025 il Reaper da solo sta sotto o vicino al conto. Non simulato dal tester.
Limiti invariati: somma di corse indipendenti, lotti sul proprio saldo, limiti giornalieri interni che non si vedono fra EA, Modello 1 nei tre anni vecchi, nessuna slippage, un percorso per anno.
