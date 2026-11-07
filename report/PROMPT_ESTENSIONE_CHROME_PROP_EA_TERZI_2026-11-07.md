# Prop firm che potrebbero ammettere EA di terzi: ricerca preliminare e prompt (07/11/2026)

**Fonti della ricerca: blog di confronto e siti di affiliazione, spesso contraddittori e a volte datati. NESSUNA e vincolante.** Vale solo il regolamento ufficiale della prop e la risposta scritta dell'assistenza.

## Candidati emersi (da verificare con l'estensione sul sito ufficiale)
| Prop | Cosa dicono le fonti secondarie sugli EA di terzi | Dubbi/limiti | Priorita |
|---|---|---|---|
| **FTMO** (gia letta) | EA ammessi, nessuna pre-approvazione; "potrebbero esserci gia altri trader che usano lo stesso EA"; vietati EA "iperattivi" (>2.000 richieste/giorno) | tetto 320.000 EUR/trader; stop news solo sul Standard finanziato | la nostra base |
| **E8 Markets** | la piu aperta nei confronti: EA di terzi ammessi se la strategia rispetta le policy; MT5; stop loss su ogni posizione | "niente strategie duplicate fra utenti"; massimo 50% di trade sotto 1 minuto; latency arbitrage vietato | **alta** |
| **Choice** | EA ammessi, ma segnala piu utenti con lo stesso EA di terzi che eseguono operazioni identiche | rischio: gli EA di Wim li usano molti trader | media |
| **FundedNext** | fonti discordanti: EA vietati sopra 50.000 $ (solo manuale) oppure ammessi con tetto 300.000 $ per strategia; vieta EA fatti per passare le challenge e pubblica una lista di EA vietati | molto incerto | media |
| **FundingPips** | un EA acquistato puo solo gestire il rischio, non aprire trade | probabile esclusione | bassa |
| **Alpha Capital Group** | solo funzioni di gestione del rischio (stop loss, lotti), pre-approvazione | probabile esclusione | bassa |
| **Seacrest Markets** | EA ammessi solo se basati sulle proprie operazioni e strategie; niente segnali di terzi | probabile esclusione | bassa |
| **The5ers** | letta: EA di terzi **non ammessi** (vedi `THE5ERS_ANALISI_2026-11-07.md`) | | esclusa |

Altre prop citate nelle liste ma non verificate: FXIFY, FundYourFX, Blueberry Funded (compaiono solo tra quelle che vietano il latency arbitrage). Nessuna delle fonti dice se l'ORO (XAUUSD) ha restrizioni sugli EA: **NON VERIFICATO**.
Rischio comune: se molti trader usano gli stessi EA di Wim, le operazioni "identiche" fra utenti diversi possono essere trattate come copy trading. Le prop lo scrivono in clausole separate dalle regole sugli EA.

## Prompt da incollare (una prop alla volta: cambia solo il nome)
```
Sei in sola lettura sul sito ufficiale della prop firm [NOME PROP] (sito e help center). Regole ferme: NON accedere a nessun account, NON inserire dati, NON cliccare su Buy / Start / Checkout / Login, NON compilare form. Solo leggere pagine pubbliche.

Compito: leggi le regole ufficiali (Terms, Trading Rules, Prohibited Trading Practices, FAQ su Expert Advisor, copy trading, programmi/challenge, prelievi, account multipli, help center). Segui i link interni di regole e FAQ, non quelli di marketing. Elenca tutte le pagine lette (URL + data di aggiornamento se mostrata). Per ogni punto: (1) FRASE ESATTA tra virgolette; (2) URL; (3) "NON TROVATO" se non c'e (non dedurre). Se due pagine si contraddicono, riporta entrambe.

1. EA di terzi: un EA ACQUISTATO da un fornitore (file compilato .ex5, senza sorgente, es. venduto sul MQL5 Market o da un venditore esterno) e ammesso? Serve il sorgente? Serve approvazione scritta? Quali EA sono nominati come vietati?
2. Piu trader con lo stesso EA (operazioni identiche o simili): e vietato, tollerato, o a rischio sospensione? Regola sui "duplicate strategies", copy trading, "same strategy".
3. Stop loss obbligatorio e visibile? Stealth/virtual stop vietati? Durata minima dei trade (scalping sotto N secondi)? Martingala, grid, hedging, HFT, latency arbitrage, tick scalping: ciascuno vietato o no.
4. Oro (XAUUSD) e metalli: ci sono restrizioni di leva, di lotto o sugli EA per questi strumenti?
5. Capitale massimo per trader e numero massimo di conti; programmi disponibili e taglie.
6. Perdita giornaliera e massima: base (balance/equity, flottante, trailing o statica), ora di reset, fuso del server; cosa succede al superamento.
7. Target, giorni minimi, durata massima, inattivita, regole di coerenza/consistency e "best day".
8. Prelievi: primo payout, frequenza, minimo, profit split, cosa va chiuso prima (posizioni, pendenti), eventuali limiti o rate. Esiste una "garanzia di payout" scritta nei Terms o e solo uno slogan?
9. News: stop sugli ordini (minuti), su quali conti, cosa conta come trade (SL/TP, pendenti).
10. Weekend/notte: posizioni e ordini pendenti ammessi? Differenze fra valutazione e finanziato.
11. Commissioni e costi per strumento (forex, oro, indici), swap, spread, leva, lotti massimi; fuso del server.
12. VPS ammessi? Limiti di richieste/ordini al giorno ("hyperactive", server requests).
13. Rimborso della quota, reset, riacquisto, scadenze.

Output in italiano: tabella (punto | risposta | frase esatta | URL | CHIARO/AMBIGUO/NON TROVATO); elenco delle pagine lette; domande da fare all'assistenza per iscritto; e una sezione finale "EA DI TERZI COMPILATI SENZA SORGENTE: AMMESSI?" con la frase esatta. Se una pagina non si apre o richiede login, scrivilo e vai avanti. Non inventare nulla.
```

## Dopo la lettura
Mandami l'output (come per FTMO e The5ers): lo confronto con i nostri EA e con FTMO. Una prop e candidata solo se la frase esatta ammette EA acquistati senza sorgente **e** non vieta operazioni identiche di piu utenti, oppure se l'assistenza lo conferma per iscritto.
