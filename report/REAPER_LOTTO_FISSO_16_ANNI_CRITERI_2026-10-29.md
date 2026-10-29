# Gold Reaper a lotto minimo su 16 anni (2008-2023) e confronto col test di Wim: CRITERI e PREVISIONI (29/10/2026, scritti PRIMA dei numeri)
**Natura: CRITERI. Non controllata da agenti.** Richiesta di Claudio (29/10) dopo la lettura di `WIM_BACKTEST_REAPER_LETTURA_2026-10-29.md`. Riga `RIGA_LANCIA_REAPER_FISSO_80K.txt` (generatore `gen_riga_reaper_fisso_80k.py`, pin 3e43646d, script ANNO80K v5): 19 passate, 80.000 EUR, Modello 1.
## Cosa si misura
`TradeFrequency=2`, `MaxAllowedDD=0` (lotto 0,01 su tutte le operazioni, misurato il 27/10 sul 2025), `PropFirmMaxDailyDD=0`, `OnlyUp=false`. 3 passate su **D1** (2013, 2018, 2020, come i report di Wim) e 16 su **H1** (ogni anno 2008-2023). Riferimento di Wim (DICHIARATO, `2008-2024_stability.html`, 10.000, lotto 0,01, D1, TradeFrequency 2, `MaxAllowedDD` 30, `OnlyUp` true, versione `GoldReaper_WSC_V1.0`): positivo in tutti i 16 anni, netto annuo +487 (2012) ... +2.326 (2023), 491-751 operazioni l'anno, peggior giorno realizzato -3,57%. Non e lo stesso input (`OnlyUp`, MaxAllowedDD 30 contro 0) ne la stessa versione: con lotto fisso il confronto e sul netto in valore assoluto e sul segno.
## Previsioni dichiarate ORA
- F1: netto positivo in tutti e 16 gli anni H1 (con barre M1 presenti): 55%; in almeno 14 su 16: 85%.
- F2: operazioni per anno entro +-30% di quelle di Wim in ogni anno: 55%.
- F3: 2013 / 2018 / 2020 a lotto 0,01 H1 entro +-40% di +1.305 / +1.193 / +1.329 di Wim: 55%.
- F4: il netto D1 differisce da quello H1 di oltre il 25% in almeno 2 anni su 3 (2013, 2018, 2020): 45%.
- F5: netto totale 2008-2023 (H1) fra +14.000 e +26.000 (Wim +19.312): 55%.
- F6: l'anno peggiore (per netto) e uno fra 2008, 2010 e 2012: 55%.
- F7: almeno un anno fra 2008 e 2012 e KO o senza operazioni (barre M1 BCM assenti): 35%.
- F8: il peggior giorno realizzato (in % dei 80.000) e sotto lo 0,6% in ogni anno (lotto 0,01): 75%.
## Cosa NON dice
Lotto minimo: non misura il rischio a lotto normale. Dati BCM e Modello 1 (OHLC), nessuna slippage, filtro news non simulato, orologio AutoGMT non verificato, un percorso per anno. Se un anno ha dati insufficienti, e una misura mancante. Nessun giudizio su acquisto, lotto o taglia.
