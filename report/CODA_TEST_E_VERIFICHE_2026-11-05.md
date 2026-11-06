# CODA DEI TEST E DELLE VERIFICHE — da tenere sempre a mente (aggiornata 05/11/2026)

Regola: criteri e previsioni scritti PRIMA dei numeri; un controllo non fatto e' "NON MISURATO"; nessuna modifica al live/VPS/reale 10105439 senza decisione di Claudio; gli `_Ottimizzato` girano in parallelo con magic diversi, mai al posto degli originali; ogni zip deve stare in chat (<= 10 MB) ed essere evidenziato.


## CANCELLO PRIMA DI UBS (deciso da Claudio il 05/11/2026: "prima di partire con UBS dobbiamo aver testato bene TUTTI gli EA")
UBS parte solo quando ogni EA ha, per ognuno, una riga "TESTATO BENE" con i punti sotto, oppure un limite dichiarato. Stato al 05/11:
| EA (13 di Wim) | Fatto | Manca prima di UBS |
|---|---|---|
| Gold Reaper, Gold Phantom, Goldbot One, Gold Trade Pro (4 oro) | test su anni diversi (2013/2018/2020/2025 e altri), trio con Guardian; fake-out Fase 1 | Fase 2 fake-out (in corso); combo `*_3GOLD/_4GOLD` di Wim; AdjustEntry, Randomization 60, weekend, regola 1/3 del rischio; verifica `AdjustLotsizeToVariableValues` su Reaper e Phantom |
| Apex, Stability Pro, Luna, Daytrade Pro (forex, 5 anni: 2013, 2017, 2020, 2022, 2025) | 88 passate su 28 set, Guardian sul realizzato | **lotti non calibrati sul prezzo/broker** (profitti e DD a 80k gonfiati dalla crescita del lotto): rifare con rischio calibrato; flottante non misurato; etichette long/short/laterale degli anni; verifica del parametro "max DD a 0.01 lotti" |
| Indicement, ORB Master (indici) | 1 periodo (2025-01 -> 2026-09), perdono o pareggiano | secondo periodo e orari verificati (`AutoGMT`, GMT+1 fisso BCM); correlazione fra i due NON misurata |
| Bitcoin Reaper, Bitcoin Scalp Pro | 56 passate FTMO, commissioni | ricalibrare il DD sul prezzo; rifare 2023-2025 con real ticks se possibile; correlazione col trio, Guardian, margine 1:3,3 |
| UBS | niente (per ultimo) | tutto sopra finito + ricalibrazione max DD a 0.01 lotti |
Un "TESTATO BENE" richiede: anni di regimi diversi, set diversi, DD prop 80k con Guardian, lotto calibrato, commissioni/slippage dichiarati, un fuori campione, e le previsioni scritte prima.

## A. IN CORSO ORA
1. **[FATTO 05/11] Fake-out Gold Reaper** (risultati in `REAPER_FAKEOUT_RISULTATI_2026-11-05.md`: nessuna configurazione migliore del Medium; Fase 2 non scattata) (F0 Off / F1 Low / F2 Medium / F3 High), XAUUSD H1, 80k, anni 2013/2018/2020/2025, 16 passate. Criteri: `report/REAPER_FAKEOUT_CRITERI_2026-11-05.md` (+ Emendamento 1). Riga corta lanciata sul PC di backtest. Poi: leggere i risultati, verificare F2 vs riferimenti del 29/10 (+-3%), verificare mappatura 0-3 e default del venditore.

## B. SUBITO DOPO (ordine)
2. **[FATTO 05/11] Fase 2 fake-out** (`REAPER_FAKEOUT_FASE2_RISULTATI_2026-11-05.md`: Low NON dimostrato come migliore del Medium; fallisce nel 2024) SOLO se una configurazione passa la regola della Fase 1: anni 2015, 2019, 2022, 2024 (se i dati BCM ci sono).
3. **Zip e analisi** di ogni giro con `RIGA_ZIP_RISULTATI_WIM.txt` (riconosce WIM, BTC_FTMO e REAPER_FAKEOUT).

## C. TEST DA FARE SUL GOLD (EA Wim che abbiamo)
4. **AdjustEntry negativo** (Guelsko: -1000 sul Reaper intense, "3,1K con ~5% DD contro 1,6K con ~2%" nel solo 2026): da testare SOLO su anni lunghi e regimi diversi; Wim: "over-optimizing for a short period".
5. **Randomization 60 contro 0** (cambia il numero di ordini), gia' parzialmente fatta (50/75/100): confrontare con i nostri risultati precedenti.
6. **Rischio con piu' EA oro insieme**: la regola di Wim "3 EA a 1/3 del rischio, 4 a 1/4, 5 a ~1/4" e "Max Allowed Total DD piu' basso se girano insieme" contro il nostro dimensionamento del trio (Reaper + Phantom + Goldbot) con Guardian.
7. **Set combo ufficiali `*_3GOLD.set` / `*_4GOLD.set`** (cartella "recommended combo setup" in `AllSets&Manuals.zip`, canale plug-and-play-eas): da scaricare a mano e confrontare con i nostri set prop sugli stessi anni. Anche `LivePortfolioSets.zip` (44 strategie UBS di Wim).
8b. **Weekend aperto contro chiuso** (MaximusDemicusMaridius 21/03, dichiarato, non verificato): DD massimo 62% con il weekend lasciato aperto contro 72% con il weekend spento (chiusura): contraddice l'idea che chiudere prima del weekend riduca il rischio; da misurare con i nostri anni.
6b. **Eugen (25/01)**: nei combo `*_3GOLD.set` su 24-25 anni Phantom +22%/1% DD, GTP +46%/6% DD, TGR +58%/3% DD; propone di aumentare il rischio del Phantom di 2-2,5 volte per bilanciare. Dichiarato, non verificato; da provare dentro il test del punto 6 (stessa baseline `*_3GOLD`).
8. **Fake Breakout HIGH e OFF** (incluso nel test fake-out), **Friday stop hour 23 / chiusura prima del weekend** (Wim 14/03) sul rischio gap: da progettare.
9. **Strategia 9 del Reaper** (molti la disattivano o la sostituiscono con Scalp C; Marcus: PF basso ma e' la piu' redditizia): verificare con i nostri anni se tenerla; ricordare che richiede "manual strategy selection" (non compatibile con Max Allowed Total DD).

## D. VERIFICHE SU COSE GIA' DETTE (NON VERIFICATE)
10. `AdjustLotsizeToVariableValues` nei set Reaper e Phantom (nel Goldbot c'e' ed e' 1; Wim 06/05 dice che deve essere True).
11. Quale valore ha `FakeOutFilter` nel set del venditore e quale e' il default dell'EA attuale (Wim 16/02: "off by default, I run low").
12. Il DD dei 88 test del pacchetto Wim: controllare se Apex, Stability, ecc. hanno un parametro "max DD a 0.01 lotti" legato a prezzo/broker.
13. Filtro news nel tester (Wim: date scritte nel codice, funziona in backtest) contro le nostre note (non simulato) e `AutoGMT` (errore 4014 nel tester FTMO; orari BCM GMT+1 fisso).
14. Versione dei nostri EA oro sul VPS e sul PC: Wim ha aggiunto virtual trailing SL/TP il 30/09; confrontare versioni prima di confrontare risultati.
15. **OHLC 1M contro real ticks** su un periodo breve: misurare noi (Andrew Soma: 95% sull'oro, ~80% sugli indici; langesi: i real ticks tolgono ~40% di profitto) prima di fidarci dei test lunghi in OHLC.

## E. BITCOIN
16. Test FTMO 56 passate: FATTO (`RISULTATI_BTC_FTMO_2026-11-05.md`): nessun set passa; commissioni 0,0325%/lato decisive. In coda: ricalibrare il "max DD a 0.01 lotti" sul nostro broker/prezzo e rifare 2023-2025 (con real ticks se possibile), candidato Scalp Pro PropFirm. NON misurati: correlazione col trio oro, Guardian sim, equity floating, margine a 1:3,3.
17. **Strategie Bitcoin nostre con UBS** (meno operazioni, piu' movimento per operazione, commissioni sempre nel test).

## F. UBS (per ultimo, come deciso)
18. Prima di tutto: ricalibrare il "max historical DD a 0.01 lotti" sul BCM e sul FTMO (backtest 1% di rischio per strategia su balance fisso 80k, poi scalare; Wim 04/09 e 31/07).
19. Testare i set di Wim (UBS_V9.0, set Scalp A/B/C, set gold daily, volatility BTC/indici, break and retest e range breakout = versioni di prova non ottimizzate) con anni long/short/laterale e simulazione 80k.
20. Set degli utenti (solo come ipotesi): `30StrategiesPortfolio_Sets.zip`, Gold_Scalp YOLO, ScalpA/B_opt, Ash (Scalp A/B ingresso anticipato), Rainy-, Sander. Autore, data e link per ognuno.
21. Costruire EA nostri con UBS sullo stesso metodo (criteri prima, fuori campione, nessun overfitting).
22. "UBS Optimizer" di Wim (in sviluppo al 30/09): vedere se esce.

## G. DISCORD E ALTRI IMPEGNI
23. Leggere gli altri canali (per set modificati e metodo): #backtesting-discussion, #share-your-performance, #bitcoin-eas, #luna-ai, #daytrade-pro, #indicement-and-orb-master, #important-announcements.
24. Verificare che la scansione del lunedi' (attivita' pianificata nell'app Claude desktop, 7:00) produca il file `DISCORD_<data>_report.md` in Download, e che la riga `RIGA_PIANIFICA_ZIP_DISCORD.txt` (lunedi' 07:45) sia stata registrata (scritta `REGISTRATA...`): NON confermato.
25. Risposta di Wim su licenza/AutoLoader (aperta); regole prop (FTMO) che Wim non dice mai: servono altre fonti.

## H. RESIDUI DEI GIRI PRECEDENTI (dal riepilogo)
26. Reset del Guardian sul 100k; PostNews chiusura del venerdi'; EMA200_Ombra ore nascoste; AUDNZD salto anomalo dell'equity (NON MISURATO); ORB/Indicement da rifare con orari verificati (opzionale); etichette anni; misura dell'equity floating; prova gratuita FTMO scade ~18/11; vecchie righe del tester che ora fermano su "installazione NON censita" (aggiornate solo quelle nuove).

## AGGIORNAMENTO 05/11 sera (dopo la lettura degli altri canali: `report/UBS_DISCORD_2026-11-03/SINTESI_ALTRI_CANALI_2026-11-05.md`)
- ORB Master e Indicement: priorita' BASSA (Wim li ha fermati sul suo live il 03/08). Bitcoin Reaper/Scalp Pro: in fondo; se mai con real ticks e strategie 1, 2, 8, 9, 10.
- NUOVO: verificare le ore del set Luna nei nostri test (Wim: finestra "23 till 1am" server ICMarkets = 21-23 GMT; i nostri test usano AutoGMT=false e offset 1/1: NON VERIFICATO).
- NUOVO: controllo di `ManualBalance` e lotto di partenza su tutti i set prima dell'uso su un conto piccolo (set ORB del 10/04 sbagliato su 325 dollari).
- NUOVO: verifica ufficiale delle regole FTMO (copy trading, EA, correlazione/stessa strategia su piu' conti, ordini pendenti, perdita giornaliera) e della leva del conto BCM reale.
- NUOVO: scaricare a mano `combodeal.zip`, `AllSetsAndManuals.zip` (28/08), `Gold_Bundle.zip` e controllare se contengono i combo `*_3GOLD/_4GOLD` (il nome "AllSets&Manuals.zip" non esiste).
- Demo forward: serve a provare il funzionamento, non lo slippage (Wim: "I basically never run demo accounts anymore").
- VPS: misurare RAM/CPU nei picchi; rimedi gratuiti prima di aumentare la RAM (terminali minimizzati, High Performance, desktop heap, riavvio settimanale).

## AGGIORNAMENTO 05/11 (zip ufficiali di Wim ricevuti: `UBS_DISCORD_2026-11-03/ZIP_UFFICIALI_WIM_LETTURA_2026-11-05.md`)
- I combo `*_3GOLD` e `*_4GOLD` (con le versioni `prop firms`) ci sono, dentro `combodeal.zip` e `AllSetsAndManuals.zip`. Il punto 7 della coda (confronto con i set combo di Wim) si puo' fare: Reaper 3 / 2, Phantom 4 / 2,5, Goldbot 0,8 / 0,5, Goldtrade 0,3 / 0,2, con Randomization 50 sul Reaper e Phantom.
- NUOVO test in coda: set combo di Wim contro i nostri set del reale/FTMO, a 3.745 EUR e a 80k, 4 anni, con criteri scritti prima. Attenzione al lotto minimo 0,01 a 3.745 EUR.
- Manuali PDF di 13 EA ora disponibili (capitali minimi, parametri): da leggere EA per EA. Apex: 2.000-4.000 USD = Conservative con LotsizeStep 3000 o piu'.
- `Gold_Bundle.zip` e' un solo backtest di Wim (UBS V6.4, 5.000 USD, 1% per strategia, 2020-2026, +109.836, DD equity max 10,4%): materiale di confronto per UBS, non una prova.

## AGGIORNAMENTO 05/11 sera (forex a 4k)
- FATTO: 70 passate dei 4 EA forex a 4.000 EUR (`RISULTATI_FOREX_4K_2026-11-05.md`, 7 candidati) e confronto col trio oro (`CONFRONTO_TRIO_ORO_FOREX_4K_2026-11-05.md`).
- SCRITTI i criteri del forward demo (`CRITERI_FORWARD_DEMO_FOREX_2026-11-05.md`): in attesa delle decisioni D1-D5 di Claudio (set, conto, macchina, registro equity, data).
- FATTO 06/11: trio oro a 4 livelli di rischio, 96 passate a 80.000 e 3.745 (`ORO_GRADINI_RISULTATI_2026-11-06.md`): Medium NON REGGE i limiti FTMO in nessun anno; Combo 3GOLD regge; punto 7 della coda (combo 3GOLD di Wim) fatto, restano AdjustEntry, Randomization, weekend, strategia 9.
- SCRITTO 06/11: piano del forward demo della Serie 4 (tre conti prop, EA diversi per conto): `PIANO_FORWARD_DEMO_SERIE4_2026-11-06.md`. In attesa delle decisioni D1-D6 di Claudio.
