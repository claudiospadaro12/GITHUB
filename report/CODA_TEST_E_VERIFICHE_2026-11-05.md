# CODA DEI TEST E DELLE VERIFICHE — da tenere sempre a mente (aggiornata 05/11/2026)

Regola: criteri e previsioni scritti PRIMA dei numeri; un controllo non fatto e' "NON MISURATO"; nessuna modifica al live/VPS/reale 10105439 senza decisione di Claudio; gli `_Ottimizzato` girano in parallelo con magic diversi, mai al posto degli originali; ogni zip deve stare in chat (<= 10 MB) ed essere evidenziato.

## A. IN CORSO ORA
1. **Fake-out Gold Reaper** (F0 Off / F1 Low / F2 Medium / F3 High), XAUUSD H1, 80k, anni 2013/2018/2020/2025, 16 passate. Criteri: `report/REAPER_FAKEOUT_CRITERI_2026-11-05.md` (+ Emendamento 1). Riga corta lanciata sul PC di backtest. Poi: leggere i risultati, verificare F2 vs riferimenti del 29/10 (+-3%), verificare mappatura 0-3 e default del venditore.

## B. SUBITO DOPO (ordine)
2. **Fase 2 fake-out** SOLO se una configurazione passa la regola della Fase 1: anni 2015, 2019, 2022, 2024 (se i dati BCM ci sono).
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
