# Forex "TESTATO BENE" — piano a giri, CRITERI e PREVISIONI (07/11/2026, scritti PRIMA dei numeri)

**Natura: CRITERI, non ancora lanciato.** Richiesta di Claudio (07/11): "voglio testare tutto bene" sui 4 EA forex (Apex, Stability Pro, Luna, Daytrade Pro), dopo la decisione di chiudere il cancello prima di UBS solo con oro e forex. Il reale e le prop non li tocco io; lotti e taglie le decide Claudio. Sono solo test nel tester.

## Cosa manca oggi (dalla coda del 05/11 e dai risultati del 4k e dell'80k)
1. **Fuori campione**: i 14 set sono stati provati in 5 anni (2013, 2017, 2020, 2022, 2025). I 7 candidati del 4k sono stati scelti guardando quei 5 anni: serve un secondo gruppo di anni mai usati.
2. **OHLC contro tick reali**: tutto in Modello 1 (barre da 1 minuto), mai confrontato con i tick sul forex (Andrew Soma: l'oro 95%; langesi: i tick tolgono ~40% di profitto).
3. **Orari**: Apex `GMT_Offset` 1 fisso, Luna finestra "23-1" server ICMarkets (Wim) contro il BCM GMT+1 fisso: NON VERIFICATO.
4. **Taglia prop**: a 80k i set hanno lotti per saldo enormi; il "4k" non si trasferisce all'80k. Serve una versione a lotto proporzionato, dichiarata come scenario (non consiglio di lotto).
5. **Perdita giornaliera con le posizioni aperte (flottante)** e Guardian: non misurati sulle griglie.
6. **Costi**: commissioni FTMO (forex 2,50 USD/lotto/lato) e slippage non applicati ai risultati forex.
7. **Parametro "max DD a 0,01 lotti"** (Apex/Stability/Daytrade Pro): non ricalibrato sul broker, NON MISURABILE dal di fuori dell'`.ex5`; si dichiara come limite.

## Struttura a giri (ogni giro con criteri propri, scritti prima del lancio del giro)
| Giro | Cosa | Passate | Stato |
|---|---|---|---|
| **A** | Fuori campione: 10 set x 7 anni nuovi a 4.000 EUR | 70 | **criteri sotto, da lanciare** |
| **B** | Modello 4 (tick reali) contro Modello 1 su un anno, 4 set | ~8 | criteri da scrivere dopo A |
| **C** | Orari: `GMT_Offset` +-1 su Luna 4DD e Apex Conservative, 2 anni | ~8 | criteri da scrivere |
| **D** | Taglia prop 80k a lotto proporzionato (scenario) per i set sopravvissuti | da definire | dopo A, serve verificare i parametri di lotto di ogni EA |
| **E** | Post-elaborazione, senza passate nuove: flottante giornaliero (deal + M1), commissioni/slippage FTMO, correlazione fra i candidati e col trio oro | 0 | dopo A |

## GIRO A — criteri
**Set (10)**: Apex `ConservativeGrid`, `UltraConservativeGrid`, `ElevatedGrid`; Daytrade Pro `Max9DD lowrisk`, `Max20DD mediumrisk`, `Max50DD highrisk`; Luna `4DD`, `recommended lowrisk`; Stability Pro `low risk`, `medium-low risk`. Sono i 7 candidati del 4k + le 3 zone grigie. Non si ripetono i 4 set gia scartati (Apex `extremerisk`/`highrisk live`, Luna `recommended`, Stability `high risk`: stop out o DD > 50% in piu anni).
**Anni nuovi (7)**: 2014, 2016, 2018, 2019, 2021, 2023, 2024. Deposito **4.000 EUR**, Modello 1, terminale BCM, solo tester, set del venditore invariati, stessa riga di partenza del 4k (cambia solo l'elenco anni e set).
**Validita di una passata**: report presente, deposito 4.000, input uguali al set, qualita storico >= 98%, almeno 1 operazione. Un anno con qualita < 98% o senza dati BCM per un simbolo del set viene escluso e DICHIARATO (non sostituito).
**Misure**: le stesse del 4k (netto, rendimento, PF, operazioni, DD equity relativa e assoluta, peggior giorno realizzato, giorni <= -10%, stop out, righe "no money", quota 0,01, conto finale) + confronto con i 5 anni gia visti.

**Soglie (le stesse del 4k, sul limite di Claudio 50% di DD)**: SCARTATO se in almeno un anno DD relativa > 50% o conto finale < 2.000 o stop out; ZONA GRIGIA se DD relativa massima fra 35% e 50%; CANDIDATO se DD <= 35% in tutti gli anni.
**Definizione di "TESTATO BENE (forex)" per un set, sui 12 anni insieme (5 vecchi + 7 nuovi)**:
- DD equity relativa <= 35% in TUTTI i 12 anni (> 50% in un anno = scartato), nessuno stop out;
- netto > 0 in almeno 10 anni su 12;
- nessun anno con conto finale < 3.000;
- e, per essere promosso per intero, i giri B, C ed E senza sorprese. Dopo il solo giro A il massimo possibile e "FUORI CAMPIONE SUPERATO", non "TESTATO BENE".
- Mai promosso su un solo anno. Con 70 passate nessun migliore e una scoperta: riporto il quadro per set e anno.

## Previsioni dichiarate ORA (non misurate)
- **F1** Daytrade Pro `Max9` ha DD relativa <= 35% in tutti e 7 gli anni nuovi: 90%; `Max20`: 80%; `Max50`: 40%.
- **F2** Daytrade Pro: netto positivo in almeno 6 anni su 7 nuovi: `Max9` 75%, `Max20` 70%, `Max50` 60%.
- **F3** Apex `Conservative` DD <= 35% in tutti e 7: 45%; `Ultra`: 50%; `Elevated`: 10%.
- **F4** Luna `4DD` DD <= 35% in tutti e 7: 55%; `lowrisk`: 15%. Luna `4DD` negativa in almeno uno dei 7 anni nuovi: 55% (nel 2013 era -826).
- **F5** Stability `low`: DD <= 35% in tutti e 7: 55%; `medium-low`: 25%.
- **F6** Almeno uno dei 7 candidati del 4k perde la qualifica sui 12 anni (DD > 35% o netto > 0 in meno di 10 anni): 80%. Tutti e 7 la mantengono: 5%.
- **F7** Almeno un anno nuovo con 3 o piu dei 7 candidati in perdita: 50%.
- **F8** Un set Apex realizza in un giorno -20% o peggio del conto in almeno un anno nuovo: 60% (nei 5 anni vecchi accadeva nel 2013 e 2017).
- **F9** Almeno una coppia anno/set esclusa per dati (qualita < 98% o simbolo senza storico): 40%.
- **F10** Tutte le 70 passate (meno quelle escluse per dati) hanno deposito 4.000 e input uguali al set: 80%.
- **F11** Le etichette dei nuovi anni (variazione dei prezzi delle operazioni, regola >= +-5%) mostrano i peggiori DD delle griglie Apex/Stability negli anni direzionali sui cross AUD/NZD, non nei laterali: 55%.

## Limiti dichiarati
Un percorso per anno; OHLC a 1 minuto (giro B lo misura); nessun slippage, commissioni e swap quelli del tester BCM (giro E); orari e `AutoGMT` (giro C); il "max DD a 0,01 lotti" resta quello del venditore; correlazione e Guardian non simulati in questo giro; i giorni peggiori sono realizzati, non flottanti; anni piu vecchi del BCM possono avere dati meno buoni. Nessun giudizio su acquisto, lotto o taglia e nessuna modifica a live, VPS o reale.
