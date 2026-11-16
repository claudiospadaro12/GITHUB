# Piano: due binari in parallelo (16/11/2026, sera; criteri scritti PRIMA dei numeri)

**Obiettivo unico (Claudio):** EA profittevoli e SCORRELATI tra loro, per conti reali o prop, poi monitorati in demo/reale (programma tipo Karnek).
**Natura:** piano. Nessun lotto/taglia/acquisto deciso qui.

## Binario A - UBS di Wim (ottimizzazione e backtest, come finora)
1. Chiudere l'oro: griglia su dati FTMO in corso -> XML -> controllo centro (3573,72 EUR / 139) -> validazione V1/V2 su FTMO -> 2025/2026 solo informativi.
2. Poi altri mercati/EA UBS con lo stesso metodo (Nasdaq: criteri gia scritti in `NASDAQ_EA_OTTIMIZZAZIONE_CRITERI_2026-11-16.md`).
3. **Ogni finalista entra nella squadra solo dopo la tappa 3** (correlazione <= 0,30 con gli EA gia in squadra, sul valore piu alto tra giornaliero e settimanale).
## Binario B - nostro progetto (`backtest_runner`)
1. Prova a mano della catena: compilazione, `-Modo Prova`, una passata di controllo.
2. EMA200 EURUSD (EA nostro) come primo banco di prova del runner, dati FTMO.
3. Template_EA_Wim solo dopo la passata di controllo, un profilo solo per cercare il vantaggio.
## Regole comuni
- **Un solo giro del tester alla volta sul PC di backtest:** i due binari si alternano, non si sovrappongono. Il lavoro "in parallelo" e di preparazione (criteri, script, analisi), non di calcolo.
- Dati dell'ottimizzazione = dati del broker dove si operera (FTMO).
- Criteri e previsioni scritti prima di ogni giro; contatore dei tentativi; hold-out 2025-26 gia consumato sull'oro: l'unica prova indipendente e il forward.
- Tappa 4: forward in demo con bande attese scritte prima; tappa 5: monitoraggio con semaforo e regole scritte prima (formato da definire dopo aver capito cosa legge Karnek).

## Binario C - simulatore Python come filtro veloce (deciso da Claudio il 16/11/2026: "dopo l'oro")
**Natura:** piano e criteri scritti PRIMA dei numeri. Parte solo dopo la chiusura dell'oro. MT5 resta il giudice finale; il simulatore serve a scartare presto, non ad approvare.
- **Banco di prova:** ABTG_EMA200 su EURUSD H4, dati BCM (stesso periodo e stessa finestra del controllo gia usato nel runner). Se la calibrazione non regge qui, non si estende.
- **Cosa si confronta:** la stessa passata del tester MT5 a Modello 1 (candele da 1 minuto), NON a tick, perche il simulatore parte da M1. Controllo = un set (S000_BASE) + 2 set diversi.
- **Calibrazione superata solo se, per ciascuno dei 3 set:** numero di operazioni entro +-2%; profitto netto entro +-3%; PF entro +-0,05; correlazione dei profitti giornalieri (Esporta_Operazioni.ps1) >= 0,98.
- **Previsione scritta prima:** il primo tentativo NON passera (stima mia: 70% di probabilita che sbagli), per arrotondamenti di stop, spread, commissioni o regole di apertura delle candele; si prevedono 1-2 correzioni.
- **Regola d'arresto:** massimo 2 giri di correzione; se al terzo confronto non si e dentro le soglie, si scrive "simulatore non calibrabile per questo EA" e si ferma. Niente soglie allargate per farlo passare.
- **Uso dopo la calibrazione:** solo come pre-filtro (griglia ampia in Python -> i migliori N vanno in MT5 a candele, poi a tick). Un candidato approvato dal solo simulatore non esiste.
- **Cosa serve da Claudio dopo l'oro:** esportazione dello storico M1 EURUSD da MT5 (la riga la preparo io) e i 3 report MT5 di controllo.
- **Rischi noti:** spread variabile e regole del broker (distanza minima ordini, valore del tick) non sono modellati finche non sono letti dal terminale; i tick reali non si simulano.
