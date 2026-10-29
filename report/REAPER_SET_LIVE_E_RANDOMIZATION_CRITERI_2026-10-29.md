# Gold Reaper: set del segnale live e Randomization 50: CRITERI e PREVISIONI (29/10/2026, scritti PRIMA dei numeri)
**Natura: CRITERI. Non controllata da agenti.** Richiesta di Claudio (29/10): "prima testare il set del segnale live e il set prop con Randomization=50". Riga `RIGA_LANCIA_REAPER_SETLIVE_80K.txt` (generatore `gen_riga_reaper_set_live_80k.py`, pin 3e43646d, script ANNO80K v5), 16 passate, 80.000 EUR, XAUUSD H1, Modello 1 su 2013, 2018, 2020, 2025. Set del venditore: `backtest_pipeline/set_venditore/gold_reaper/`.
## CORREZIONE a quanto detto il 29/10
**`FakeOutFilter=2` NON e una differenza del set live:** e gia il default nelle nostre corse (il report del 20/10 lo mostra: `FakeOutFilter=2`). Anche `UseVariableValues`, `AdjustLotsizeToVariableValues`, `UseHL_TrailingSL` e il filtro NFP con 100/60 minuti sono gia come nel live. **Le differenze vere fra il set live e il nostro set prop sono solo quattro:** `MaxAllowedDD` 30 (contro 9), limite giornaliero 0 (contro 4), `OnlyUp` true (contro false), `Virtual_expiration` false (contro true).
## Configurazioni (TUTTI gli input imposti, anche quelli che restano uguali)
LIVE30 = set live (TF 2, MaxAllowedDD 30, limite 0, OnlyUp true, Virtual_expiration false, Randomization 0). LIVE9 = come LIVE30 ma MaxAllowedDD 9 e limite 4 (isola `OnlyUp` e `Virtual_expiration`). R50A e R50B = il nostro set prop (9 / 4 / OnlyUp false / Virtual_expiration true) con `Randomization=50`, due corse identiche per anno. Riferimenti del nostro set prop con Randomization 0 (stessi anni): netto 2013 +21.757, 2018 +13.535, 2020 +20.388, 2025 (12 mesi, M1) +30.457; DD equity 5.621 / 5.504 / 3.839 / 3.077 (`REAPER_MAXALLOWEDDD_RISULTATI_2026-10-29.md`).
## Criteri di lettura
PROP-ANNI come per gli altri (netto > 0, DD equity <= 8.000, nessuno stop out, nessun giorno realizzato >= 5%; la calibrazione non e misurata qui). Si riportano netto, PF, DD equity, giorni >= 3/4/5%, peggior giorno, operazioni, lotti.
## Previsioni dichiarate ORA
- L1: LIVE30 ha DD equity > 8.000 in tutti e 4 gli anni: 90%; almeno un anno con un giorno realizzato >= 5%: 75%; netto 2013 sopra +50.000: 60%.
- L2: LIVE9 ha netto entro +-10% di quello del nostro set prop (Randomization 0) in almeno 3 anni su 4: 50% (se `OnlyUp` e `Virtual_expiration` contano poco); LIVE9 supera PROP-ANNI nei tre anni vecchi: 55%.
- L3: R50A e R50B differiscono fra loro di oltre il 5% di netto in almeno un anno (la randomizzazione non e ripetibile): 55%.
- L4: il netto di R50A e R50B resta entro +-25% di quello con Randomization 0 in ogni anno: 65%.
- L5: R50A e R50B superano PROP-ANNI (DD <= 8.000, nessun giorno >= 5%) nei tre anni vecchi: 55%.
- L6: tutte le 16 passate valide (`input_ok = si`): 75%.
## Cosa NON dice
Un percorso per anno; Modello 1 per i tre anni vecchi; 2013/2018/2020 probabilmente dentro l'ottimizzazione del venditore; nessuna slippage; filtro news non simulato; orologio AutoGMT non verificato su BCM; la Randomization del tester puo non rappresentare quella dal vivo (ritardi di esecuzione diversi); margine con leva FTMO non simulato. Nessun giudizio su acquisto, lotto o taglia.
