# Prompt per l'estensione Claude in Chrome: lettura delle regole di The5ers (07/11/2026)

Uso: Chrome su https://the5ers.com/ con l'estensione Claude attiva (permesso solo per the5ers.com e help.the5ers.com). Incolla il prompt nel pannello laterale. Scopo: leggere le regole UFFICIALI e verificare la dicitura "payout garantiti"; non decidere acquisti.

## Cosa mi ha mostrato una ricerca preliminare (snippet di ricerca, NON verificato sul sito, da confermare con l'estensione)
- **EA**: la FAQ ufficiale pare ammettere solo EA **di cui si possiede il codice sorgente**; vietati tick scalping, latency/hedge arbitrage, HFT, copia di segnali altrui; stop loss **visibile** sulla piattaforma. Se confermato, gli EA di Wim (`.ex5` compilati, codice non nostro) **non sarebbero ammessi**: sarebbe il punto decisivo.
- **Capitale massimo**: Hyper Growth, 40.000 $ di capitale di valutazione per trader (3 conti: 5k, 10k, 20k, ecc.); lo scaling arriva a 4 milioni.
- **Copy trading** fra conti propri: fonti discordanti.
- **"Payout garantiti"**: nessuna fonte trovata che spieghi una garanzia vera e propria.

## Prompt da incollare
```
Sei in sola lettura sul sito ufficiale The5ers (the5ers.com e help.the5ers.com). Regole ferme: NON accedere a nessun account, NON inserire dati, NON cliccare su Buy / Start / Checkout / Login, NON compilare form. Solo leggere pagine pubbliche.

Compito: leggi le pagine di regole e le FAQ ufficiali di The5ers: i tre programmi (Bootcamp, High Stakes / 2 Step, Hyper Growth / 1 Step) e ogni altro programma attuale, la pagina Terms/Rules, Prohibited Trading Practices, la FAQ sugli Expert Advisor, il Scaling Program, i payout, la pagina sugli account multipli (help.the5ers.com). Segui i link interni di FAQ e regole, non quelli di marketing. Elenca tutte le pagine lette (URL + data di aggiornamento se mostrata).

Per ogni punto rispondi con: (1) cosa dice il sito, con la FRASE ESATTA tra virgolette; (2) l'URL; (3) se la pagina non lo dice scrivi "NON TROVATO" (non dedurre). Se due pagine si contraddicono, riporta entrambe.

1. PAYOUT GARANTITI: dove compare l'espressione (o simile: "guaranteed payout", "payout guarantee", ecc.)? Quali sono ESATTAMENTE le condizioni (programma, importi, tempi, cosa si perde se si viola una regola, eventuali eccezioni)? E una garanzia scritta nei Terms o solo uno slogan di marketing?
2. Expert Advisor: sono ammessi? Obbligo di possedere il codice sorgente? Sono ammessi EA di terzi acquistati (file compilati, senza sorgente)? EA di mercato (MQL5 Market)? Cosa succede se si viola (annullamento, ban, niente rimborso)? Obbligo di stop loss visibile/stealth mode?
3. Pratiche vietate: elenco completo (HFT, tick scalping, arbitraggi, martingala, grid, hedging, copy trading fra conti propri e con altri, news straddling, gap trading, over-leverage, strategie di "consistency", ecc.).
4. Capitale massimo per trader e numero massimo di conti, per programma; capitale complessivo di valutazione e finanziato; scaling (condizioni e tetto).
5. Perdita giornaliera e perdita massima: come si calcolano (balance o equity, flottante, trailing o statico, a che ora si azzera, fuso orario del server, commissioni e swap), e cosa succede al superamento (pausa del giorno o chiusura del conto).
6. Target di profitto, giorni minimi, durata massima, inattività, per ogni programma e fase.
7. Prelievi: quando si può chiedere il primo payout, frequenza, importo minimo, tempi, metodi, profit split per programma, cosa deve essere chiuso prima (posizioni, ordini pendenti), regole di coerenza.
8. News: stop sugli ordini (minuti prima/dopo), per quali programmi, per quali strumenti, cosa vale come "trade" (apertura, chiusura, SL/TP, pendenti).
9. Weekend e notte: posizioni e ordini pendenti consentiti? Differenze per programma e per fase (valutazione/finanziato).
10. Commissioni e costi per strumento (forex, oro, indici, crypto), swap, spread, leva per strumento, taglie di lotto massime.
11. VPS, piattaforme (MT5), orario del server (GMT+?) e cambio ora legale.
12. Quante richieste/ordini al giorno sono ammessi (limiti di esecuzione, "overtrading", "hyperactive")?
13. Rimborso della quota, reset, riacquisto dopo fallimento, scadenze degli account.
14. Strumenti disponibili (forex, oro XAUUSD, indici, crypto).
15. Chiarisci le differenze fra la versione per CFD/forex e le eventuali versioni futures.

Output finale in italiano:
- Tabella: punto | risposta sintetica | frase esatta | URL | stato (CHIARO / AMBIGUO / NON TROVATO).
- Elenco di tutte le pagine lette con URL.
- Lista "DOMANDE DA FARE ALL'ASSISTENZA PER ISCRITTO" per ogni punto AMBIGUO o NON TROVATO.
- Sezione finale "CRITICITA PER EA DI TERZI": per ognuna delle regole sugli EA, riporta se un EA acquistato da un terzo (senza accesso al sorgente) sarebbe ammesso, con la frase.
Se una pagina non si apre o richiede login, scrivilo e vai avanti. Non inventare nulla.
```

## Dopo la lettura
Incolla qui il risultato o salvalo come zip (come per FTMO): lo confronto con le regole FTMO e con i nostri EA (Wim: `.ex5` di terzi). Dove il sito dice NON TROVATO o AMBIGUO vale la risposta scritta dell'assistenza, non l'estensione.
