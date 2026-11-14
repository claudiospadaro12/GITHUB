# UBS A + C: nuove combinazioni diversificate dall'oro e meno "affollate" — CRITERI e PREVISIONI (14/11/2026, scritti PRIMA dei numeri)

**Natura: CRITERI, nessuna riga lanciata, nessun numero nuovo.** Obiettivi scelti da Claudio il 14/11/2026: **A** = combinazioni nuove che diversifichino il portafoglio dall'oro (indici, forex); **C** = strategie meno usate dagli altri utenti di Wim, per ridurre l'esposizione al tetto di capitale per strategia (FTMO: "evaluated alongside theirs", `FTMO_RISPOSTA_ORIGINALE_2026-11-10_INGLESE.md`). Solo tester sul PC di backtest; reale, FTMO e VPS non si toccano; nessun giudizio su lotti, taglie o acquisti.

## Paletti (letti prima di tutto)
1. **Nessun "trucco anti-controllo".** FTMO scrive che strategie "identical or highly correlated... intended to circumvent the cap" contano insieme. Cambiare parametri di un set di Wim per renderlo "diverso" NON lo rende una strategia diversa: C si ottiene scegliendo famiglie di set meno centrali, non ritoccando. Nessuna Randomization come "scudo".
2. **L'uso reale degli altri utenti NON e misurabile** (non lo sa nemmeno FTMO a noi). Il "meno usato" e solo un **proxy** dichiarato qui sotto, non un fatto.
3. **Un percorso per set, un solo anno tick al massimo**: i risultati sono sul passato, non previsioni.

## Fase 0 (condizione): scegliere il pacchetto di base
Parte solo dopo **U5** (`UBS_U5_CRITERI_2026-11-14.md`): se la candela di conferma cambia il risultato dei set daily oro, si lavora con i set V9.0 (382); altrimenti con i 283. Per famiglie non oro il confronto 283/V9.0 e da rifare set per set (253 identici, 43 cambiati: elenco in `UBS_CATALOGO_dati/differenze_43_set_stesso_nome.json`).

## Fase 1: inventario e scelta dei candidati (nessun test)
Dal catalogo V9.0 (`UBS_CATALOGO_dati/catalogo_UPDATED_SETS_V9_0_382set.csv`), set NON oro, non BTC, non TSLA, non argento: **165 set**. Famiglie: Client sets (forex USDJPY 15, US30 14, EURUSD 8, petrolio 7), Volatility Breakout (EURUSD 13, USTEC 6, US500 4, US30 4), Indicement (US30 8, US500 6, USTEC 4), ORB Master (12: USTEC, DE40, US30, US500), Advanced Scalper (10: USDJPY, EURUSD), Other sets (USTEC 5, EURUSD 4), UBS live portfolio non oro (EURUSD 8, US30 6, USTEC 4, US500 3).
- **Proxy "meno usato" (C):** ESCLUSI i 44 set del "UBS live portfolio" (sono il portafoglio che Wim stesso mostra: i piu esposti) e i set Goldbot/GTP/Reaper/Phantom/Daytrade Pro; PREFERITE le famiglie meno nominate (Client sets, Indicement, Volatility Breakout, ORB Master, Advanced Scalper, Other sets). **Ipotesi non verificata** che siano meno usate.
- **Limite 1: al massimo 40 set** in prova, scelti per famiglia e simbolo (non per risultato), con almeno 10 forex e 10 indici; elenco fissato PRIMA e salvato nel repo.
- **Limite 2: dati BCM.** Forex (EURUSD, USDJPY, ...) ha storico lungo; indici su BCM: DAX `D30EUR` (M1 2025), Nasdaq/S&P `NASUSD_EXT`/`SPXUSD_EXT` (2015, 2020, 2025-2026, con apertura USA a 14:30 anche in inverno, e a 13:30 in due settimane l'anno), Dow `U30USD`: copertura e nomi da VERIFICARE. Per i set a sessione (ORB, Indicement) il fuso conta (server BCM GMT+1 fisso: ora legale = Italia -1): **si testa per stagione o si dichiara il limite** (regola di `CLAUDE.md`). I campi `tz`/autoGMT dei set non sono letti: da controllare per ogni set.
- **Limite 3: contract size e DD01.** Il "max historical drawdown a 0,01 lotti" dei set e del broker di Wim: va rimisurato su BCM (come U1b), non copiato.

## Fase 2: filtro a M1 (set cosi come consegnati, lotto fisso 0,1, deposito 100.000 EUR, Modello 1)
Due periodi quando i dati lo permettono (P1 e P2 come U3; altrimenti due meta equivalenti dell'ultimo anno disponibile, dichiarato).
Un set PASSA se, in **entrambi i periodi**: operazioni >= 150 per periodo (Emendamento A di casa; sotto 150 = NON VALUTABILE, non scartato), PF >= 1,20, netto > 0, nessuno stop out, DD equity <= 5 volte il DD01 misurato in U1b-stile e rapporto DD01(P2)/DD01(P1) fra 0,5 e 2 (stabilita).
**Nessuna modifica di parametri in questa fase.**

## Fase 3: diversificazione (A) e affollamento (C)
Per i sopravvissuti: correlazione giornaliera dell'equity con (i) il portafoglio oro P1/P3/P4 (stessi anni) <= 0,30 e (ii) tra loro <= 0,60. **Il confronto con gli altri utenti (C) NON si misura**: solo il proxy della Fase 1.

## Fase 4: tick reali contro M1 (soglie di Wim)
Sui candidati che passano la Fase 3, un anno a tick reali: rapporto PF >= 0,7, DD tick <= 1,5 x M1, operazioni +-10%, win rate +-10 punti. Un solo percorso: margine di incertezza del 5-10% sul netto e del 20% sul DD (vedi `RISULTATI_TICK_P3_2026-11-14.md`).

## Fase 5 (solo se serve): fine-tuning
Solo per candidati "buoni ma non abbastanza" (PF fra 1,10 e 1,20 o stabilita al limite): intervalli stretti (un passo per lato), **nuovo periodo fuori campione** e prova di perturbazione (quota di varianti in profitto >= 0,7). Non va su candidati gia passati.

## Fase 6: forward demo
Sopravvissuti alla Fase 4: demo BCM o FTMO trial, minimo 4 settimane, prima di qualunque pensiero su conti veri.

## Previsioni dichiarate ORA (non misurate)
- **O-1** Fase 1: si riescono a individuare 40 set testabili (simbolo e dati BCM disponibili, nessun set a sessione senza il fuso chiaro): 60%.
- **O-2** Fase 2 (M1, set come consegnati): passa il 10-40% dei set provati: 60%; passa meno del 10% (cioe meno di 4 su 40): 25%; passa piu del 40%: 15%.
- **O-3** Dei passati in Fase 2, la quota con correlazione <= 0,30 verso l'oro: >= 70% dei sopravvissuti: 70%.
- **O-4** Dopo la Fase 4 restano almeno 3 candidati su 40: 55%; zero: 25%.
- **O-5** I set indici/forex di Wim a BCM hanno PF mediano (sui passati) piu basso del PF dichiarato da Wim: 75%.
- **O-6** Tick contro M1 (Fase 4): almeno il 70% dei candidati rispetta le 4 soglie di Wim: 60%.
- **O-7** Tempo di Fase 2: 40 set x 2 periodi = 80 passate: 6-12 ore di PC (NON MISURATO; M15 e H1 sono piu lenti dei daily oro): 55%.
- **O-8** Un candidato su 40 che "migliora" dopo fine-tuning senza nuovo fuori campione e da considerare falso positivo: regola, non previsione.

## Regole di arresto
Se in Fase 2 passano meno di 4 set: si allarga la lista (altri 40, sempre per famiglia) UNA volta; se ancora meno di 4: si ferma e si scrive "nessun candidato". Se la Fase 4 lascia zero candidati: stop, nessun fine-tuning per forzare un esito.

## Limiti dichiarati
Dati BCM indici incompleti, un percorso per set, fuso e sessioni da verificare, costi FTMO (commissione indici 0 misurata sulla challenge, slippage Dow 7,8 punti, spread non misurato), correlazione calcolata sull'equity del tester, "meno usato" non misurabile, 40 prove = comunque rischio di falso positivo (per questo i filtri indipendenti e il forward).
