# Riga ordinata dal piu corto al piu lungo: Luna AI Pro sui tre anni e Gold Reaper con le protezioni spente: CRITERI (26/10/2026, scritti PRIMA dei numeri)
**Natura: CRITERI. Non controllata da agenti.** Richiesta di Claudio (26/10): "vai dal piu corto al piu lungo". Riga `RIGA_LANCIA_ORDINE_LUNA_E_REAPER_80K.txt` (script ANNO80K v5, pin 6b849dec), 5 passate a 80.000 EUR:
1-4. **Luna AI Pro LotsizeStep 400** (livello basso del manuale; il piu contenuto del giro del 26/10: +9,7%, DD equity 7,4%) a **Modello 1** su 2013 ribasso, 2018 laterale, 2020 rialzo e 2025 come calibrazione (contro la corsa a tick reali `2025_M4_LUNA_LS400` gia fatta). EURUSD M5, OneChartSetup, coppie EURAUD+GBPAUD+GBPCHF, AutoLotMode=3, AutoGMT spento offset 1/1, filtro news spento. Durata attesa: pochi minuti ciascuna.
5. **The Gold Reaper con protezioni spente** (`MaxAllowedDD=0`, `PropFirmMaxDailyDD=0`, `TradeFrequency=2`, `OnlyUp=false`, altri input default), XAUUSD H1, tick reali, 01/01/2025-01/10/2026 (21 mesi continui). Durata attesa: circa 3 ore (la corsa con protezioni accese: 10.835 s).

## Criteri
- **Luna, tre anni (PROP-ANNI, come per gli altri EA)**: netto > 0 in 2013, 2018 e 2020; DD equity <= 8.000 EUR; nessuno stop out; nessun giorno con perdita realizzata >= 5%; calibrazione 2025 OK (stesso segno, rapporto Modello 1 / tick reali fra 0,5 e 2,0, correlazione mensile >= 0,5). Lettore `leggi_tre_anni_80k.py`.
- **Reaper con protezioni spente (21 mesi)**: confronto con la corsa a protezioni accese (+59.796, PF 2,89, DD equity 3.854, peggior giorno -1,2% del saldo, 0 giorni >= 3%). Soglie: netto > 0; DD equity <= 8.000 EUR (10% di 80.000); nessun giorno con perdita realizzata >= 5%; si riporta quanti giorni >= 3% e >= 4%, la permanenza massima e le posizioni insieme. Se le protezioni sono mai intervenute lo si vede da operazioni e DD diversi fra le due corse (con protezioni spente un'operazione chiusa dalle protezioni sparisce o cambia).

## Previsioni dichiarate ORA
- O1: Luna LS400 PROP-ANNI superato (tutte le condizioni): 40% (rischio: un anno vecchio negativo, storico M1 forex 2013 mancante, calibrazione non OK).
- O2: la calibrazione di Luna 2025 (Modello 1 contro tick reali) e OK: 55%.
- O3: lo storico M1 di tutte e tre le coppie esiste per il 2013 (la corsa non risulta KO): 70%.
- O4: Reaper a protezioni spente: netto entro +-15% di quello a protezioni accese: 55%.
- O5: Reaper a protezioni spente: DD equity <= 8.000 EUR: 75%.
- O6: Reaper a protezioni spente: almeno un giorno con perdita realizzata >= 3% (contro 0 a protezioni accese): 40%.

## Cosa NON dice
Luna: due livelli di filtro news non simulati, nessuna slippage, un solo percorso per anno; Reaper: le protezioni spente nel tester non dicono come si comportano sul server vero (orologio AutoGMT 2/3 contro BCM UTC+1), l'equity vera giorno per giorno richiede l'export M1; nessun merito d'acquisto, lotto o taglia.
