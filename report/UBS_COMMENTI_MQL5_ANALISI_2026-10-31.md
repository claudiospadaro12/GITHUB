# Commenti degli utenti sulla pagina MQL5 dell'Ultimate Breakout System (31/10/2026)
Fonte: pagina `mql5.com/en/market/product/133653` e le sue 6 pagine di commenti (107 commenti: 69 di Wim, 38 di altri utenti), lette da qui; 36 immagini scaricate, 12 guardate. Non controllata da agenti. Tutto cio che segue e dichiarato da Wim o da utenti: non verificabile da noi.

## Pagina del prodotto
Acquisto 1.699 USD (annunciato a 1.999 a breve; un cliente scrive di aver pagato 1.499), affitto 399 (1 mese) / 599 (3) / 799 (6) / 999 (1 anno), demo gratuita scaricata 14.318 volte, versione 9.5 (29/10/2026), 63 recensioni (voto 5). Incluso: oltre 300 set, manuale, video guide, template di ottimizzazione, gruppo chat privato e **5 altri EA di Wim gratis a scelta** (un cliente ha scelto Gold Reaper, Gold Trade Pro, Gold Phantom, Luna AI e Daytrade Pro). Supporto tramite messaggi privati e gruppo Telegram/Discord: molti commenti sono richieste di entrare nel gruppo.

## Cosa postano gli utenti
- **Andrii Soma (#44, #47, #49, #50)**: set propri. Sei indici mondiali (AUS200, DE40, F40, JP225, STOXX50, CHINA50) ottimizzati su 2018-06/2023 e testati in avanti da 07/2023; correlazione fra i set quasi zero (da -0,02 a 0,11), DD del portafoglio 10% a rischio 5% per set (non 30%); live 3 settimane +2,28% (troppo poco). Petrolio (XTIUSD) H1/H4/D1: lotto minimo 0,5 e servono almeno 10.000 $ per un DD del 5%. ORB sugli indici USA (US30, US500, NAS, M15, 2018-2025, 1M OHLC, 10k statico): +81.289 $, 4.521 operazioni, DD 23%; **a tick reali il rapporto rendimento/DD e circa 17% peggiore che a 1M OHLC**.
- **Torsten (#18)**: 8 strategie NAS100 in un giorno: +140% e DD 10% nel 2024-2025 (periodo corto). **Andrei Trif (#39)**: "100 $ a 490k" da gennaio 2020, a tick reali (backtest composto, non live).
- Altri: ringraziamenti, richieste del gruppo, un problema (#84): l AutoLoader **non funziona sul VPS di MQL5** (i set non vengono trasferiti): serve un VPS vero o i singoli grafici. Un cliente che ha affittato il sistema lo trova confuso ("la testa mi gira") e non sa quale configurazione usare per l oro (#65).

## Cosa mostra Wim
- **Portafoglio live di 30, poi 44 strategie da un solo grafico** (segnale `mql5.com/en/signals/2373798`, EURUSD H1): crescita totale 38,47% nella schermata del 06/08/2026. Dal grafico: salita fino a circa +30%, ritorno a circa +16% nei mesi dopo (un calo di circa 12 punti), poi un rialzo di circa 20 punti in poche ore (#97). Un altro post (#79): +20% in poche settimane con DD massimo 3%. **Il file allegato che ci hai passato, `ubs_onechart_live_MainEA_Settings.set`, e l impostazione di questo portafoglio** (rischio 3% per strategia, OnlyUp true, nessun limite prop attivo).
- **Backtest di 45 set "casuali"** a 2% di rischio per strategia, 2025-2026, 100k fissi, un solo test con OneChartSetup (#72): netto +187.206, 9.036 operazioni, PF 1,63, DD equity massimo 7.633 (5,66%), fattore di recupero 24,5. Periodo dell oro in forte rialzo, set in gran parte costruiti su periodi che includono questi anni.
- **Conto cliente con impostazioni "Extreme risk"** del Gold Reaper (#81): da 400 $ a 72.229 $ di profitto in meno di 2 anni; mesi da +135% e -35% (visti nello screenshot).
- **Segnale "Gold Reaper New V2"** (conto reale di Wim, dal 22/10/2024): +340%, DD massimo 16,9%; il confronto mensile con i nostri test e in `CONFRONTO_SEGNALE_WIM_REAPER_2026-10-31.md`.
- Sets e manuali aggiornati continuamente (V1.0 -> V9.0, ultimo 27/10/2026). Il Gold Phantom e incluso nei set dal 26/08/2026.

## Cosa mi sembra utile per noi
1. Il metodo dichiarato da tutti e lo stesso (in-sample 2013/2018-2023, fuori campione dopo): **il periodo dei nostri test di 2013-2025 e in gran parte in-sample**; il test 2005-2012 in corso sul PC di backtest e l unico vero fuori campione che possiamo fare senza UBS.
2. **Tick reali contro 1M OHLC: -17% di rendimento/DD** (utente) e 93 contro 48 (Wim): i test a Modello 1 vanno letti come limite ottimistico.
3. La diversificazione fra mercati (indici di paesi diversi, correlazione ~0) e quella che abbassa il DD, non l oro in piu. Gli ORB sugli indici USA hanno correlazione alta fra loro (96-99%).
4. Con un conto piccolo il **lotto minimo** deforma il rischio (petrolio: 0,5 lotti minimo; il nostro oro a 0,01 lotti con 3.745 EUR).
5. Il portafoglio live di Wim non ha limite giornaliero attivo e ha OnlyUp acceso: il Guardian resterebbe necessario.

## Cosa NON dice
Nessun risultato verificabile da noi; i grafici sono scelti da chi li posta; i test in avanti sono brevi (settimane); i commenti negativi o i fallimenti non compaiono (chi ha perso raramente scrive). Le 63 recensioni non sono state lette tutte; non so quanti utenti operano in live con profitto.
