# Breaking Band — conferma su anni nuovi (forex H1: EURUSD, GBPUSD, USDJPY, EURJPY; 2015, 2017, 2019, 2022)

**VERDETTO: NON DIMOSTRATO.** Codice v2 invariato (hash verificati), hash dei 16 CSV congelati e pubblicati (commit 2afb8245) PRIMA del run, criteri e previsioni di `congelati/criteri_conferma_forex_v1.md`. Tutti i controlli di integrita dell'aggregatore superati (verdetto valido).

## Pooled H1 (N=49, 45 settimane)
- R medio +0,006 (IC90 −0,121 / +0,122). Win rate 73,5% contro pareggio atteso 75,9% (soglia 80,9%). PF netto 1,03.
- Condizioni: 1 N≥30 ✔; 2 IC90 inferiore >0 ✘; 3 win ≥ pareggio+5pt ✘; 4 leave-one-pair-out >0 ✘ (senza EURJPY −0,05, senza EURUSD −0,03); 5 costo extra 0,05R: media −0,044 ✘.
- Il vantaggio visto sugli anni vecchi (win 87%, R +0,1/+0,3) NON si ripete: regressione verso la media, come previsto.

## Esplorative (non decidono)
- Per coppia H1: EURJPY N17 R +0,12 (win 82%); EURUSD N11 +0,13 (82%); GBPUSD N12 −0,25 (58%); USDJPY N9 −0,01 (67%).
- Per anno: 2015 +0,11 (N17), 2017 −0,21 (N14), 2019 +0,20 (N9), 2022 −0,05 (N9).
- CONT N44 +0,04 (win 75%); INV N5 −0,27. Long N16 −0,00; short N33 +0,01.
- M30 pooled N191: R +0,013 (IC90 −0,045/+0,068), win 74,9%.

## Previsioni vs realta
N 30–59 (40%) ✔ (49). Verdetto NON DIMOSTRATO (38%) ✔. R medio >0 (55%) ✔ ma >+0,10 (28%) ✘. Win ≥80% (40%) ✘ (73,5%). Win rate sotto l'87% visto (80%) ✔. Almeno una coppia con R<0 (70%) ✔ (due). M30 >+0,05 (15%) ✘ (+0,013).

## Lettura
Con costi realistici (+0,05R) la media e negativa; la strategia come automatizzata (target SMA20 vs stop 3 ATR, breakeven ~76%) non ha un vantaggio dimostrabile sul forex H1 nemmeno fuori campione. Con N=49 non si esclude un edge piccolo (IC90 fino a +0,12R), ma non c'e nulla per costruire un EA. Verdetto valido solo per le regole v2 (operazionalizzazione di C0 della Guida 11, non la gestione discrezionale di Fasciano).
