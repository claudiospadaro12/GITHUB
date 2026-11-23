# Terzo EA: Bitcoin intraday (stagionalita oraria, momentum del giorno, giorno della settimana) - CRITERI scritti PRIMA dei numeri (23/11/2026)
Perche: tutte le operazioni durano meno di 24 ore e chiudono a fine giornata: **niente swap** (il vero problema del BTC D1, vedi `BTC_D1_NOSTRO_CRITERI_2026-11-22.md`), mercato aperto 7 giorni su 7, diverso da oro e Dow. Il BTC intraday non e mai stato testato da noi (il test "orari fissi" era sull'oro). Famiglia nostra e generica: nessun EA di terzi.
**Dati:** FTMO `BTCUSD` M1 2017-2026 (`/tmp/claude-0/btc/`), riga a 00:00 con tickvol anomalo SCARTATA (stesso artefatto dell'oro), aggregati in barre H1 ora SERVER (limite: l'ora server cambia con l'ora legale: i blocchi sono da 8 ore, lo sfasamento di 1 ora e un rumore noto). Script `backtest_runner/simulatore/btc_intraday.py`.
**Celle (19 in tutto, fissate ora):**
- A. Blocco orario, solo long, 8 ore: ingresso all'apertura delle 00:00 / 08:00 / 16:00, uscita alla chiusura dell'ora 7 successiva (3 celle) e la versione solo short (3 celle) = 6.
- B. Momentum del giorno: all'apertura delle 08:00 / 12:00 / 16:00 si confronta il prezzo con l'apertura delle 00:00; si entra nella direzione (momentum) o contraria (fade); uscita alla chiusura delle 23:00-23:59 = 3 x 2 = 6.
- C. Giorno della settimana, solo long dall'apertura alla chiusura del giorno, per ciascun giorno (lun-dom) = 7.
**Costo:** 0,06% del nozionale per operazione completa (spread + commissione), nessuno swap (nessuna posizione passa la mezzanotte).
**Periodi:** IS 2017-2021, OOS 2022-2024, hold-out 2025-2026 (aperto UNA volta per le celle finaliste, massimo 3).
**Cancelli (non si allentano; rendimento % per operazione, netto):**
- G1 IS: PF >= 1,25, >= 150 operazioni, >= 3 anni su 5 positivi.
- G2 OOS: PF >= 1,15 con >= 80 operazioni e >= 2 anni su 3 positivi.
- G3 stabilita: PF > 1,0 sia in 2017-2019 sia in 2020-2021 (non c'e plateau di parametri: i blocchi non sono vicini).
- G4: |corr| < 0,20 fra il P&L giornaliero della cella e il rendimento giornaliero di oro e Dow (Yahoo D1) nei giorni feriali.
- G5 hold-out: PF >= 1,10.
**Previsione prima dei numeri:** su 19 celle ci aspettiamo 1-2 falsi positivi al solo G1; probabilita che una cella superi G1+G2+G3: 12%; che superi tutto: 5%. Il BTC ha una forte tendenza di fondo (rialzista 2017-2024) che favorisce i long: ogni cella long deve battere il rendimento di semplice "long tutte le ore" (riportato come riferimento).

## RISULTATI (23/11/2026) - FAMIGLIA CHIUSA, nessun candidato
Uscita completa: `BTC_INTRADAY_RISULTATI_2026-11-23.txt`. **19 celle: 2 passano G1 (C lunedi PF 1,48; C mercoledi PF 1,42), 0 passano G2** (OOS 1,09 e 1,07, soglia 1,15; lunedi 1 anno su 3 positivo). Hold-out NON aperto. Previsione (12% una cella G1-G3) non realizzata; i 2 G1 sono coerenti col numero atteso di falsi positivi (1-2).
- **Riferimento "long tutto il giorno":** PF 1,26 in IS e 1,02 in OOS: il vantaggio dei long e la tendenza del 2017-2021, che si spegne nel 2022-2024. Nessuna cella la batte in modo stabile.
- **Blocchi orari:** il migliore e long 08-16 (IS 1,23, OOS 1,05, 4 anni su 5 e 2 su 3), sotto le soglie. Gli short perdono ovunque (PF 0,71-0,95). Momentum e fade del giorno: PF 0,81-1,10, nessuno stabile.
- **Limite dati:** nel feed FTMO i sabati e le domeniche 2017-2021 hanno 15-29 giorni (il CFD non quotava nel weekend fino al 2022): C sabato/domenica non e valutabile. Ora server con cambio d'ora non corretto. Il Bitcoin di Wim (UBS, BTC D1) resta l'unico inseguitore di trend cripto noto, ma con swap.
