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
