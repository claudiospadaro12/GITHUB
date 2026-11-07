# Prompt per l'estensione Claude in Chrome: lettura completa del sito FTMO (07/11/2026)

Uso: Chrome aperto su https://ftmo.com/en/ con l'estensione Claude attiva e il permesso concesso al sito ftmo.com. Incolla il prompt qui sotto nel pannello laterale dell'estensione. Lo scopo e leggere le regole UFFICIALI, non decidere acquisti.

## Prompt da incollare

```
Sei in sola lettura sul sito ufficiale FTMO (ftmo.com). Regole ferme: NON accedere a nessun account, NON inserire dati, NON cliccare su Buy / Start / Checkout / Free Trial / Login, NON compilare form. Solo leggere pagine pubbliche.

Compito: leggi TUTTE le pagine di regole e le FAQ di ftmo.com in inglese (partendo da /en/faq/ e da ogni categoria e domanda elencata, poi /en/trading-objectives/, /en/trading-rules/ o pagine equivalenti, /en/swing-account..., /en/blog/ solo se il blog spiega una regola, Terms and Conditions e Risk Disclosure se pubblici). Segui i link interni di FAQ e regole, non quelli di marketing. Tieni un elenco delle pagine lette (URL + data di aggiornamento se mostrata).

Per ogni punto qui sotto rispondi con: (1) cosa dice il sito, con la FRASE ESATTA tra virgolette; (2) l'URL; (3) se la pagina non lo dice, scrivi "NON TROVATO" (non dedurre, non completare a memoria).

1. Capitale massimo per trader e per strategia (dollari/euro): tetto, come si somma, cosa succede a chi supera il tetto.
2. EA identici o simili su piu conti, copy trading, "same strategy", trading correlato fra conti, uso di conti di altre persone: cosa e vietato e cosa e permesso.
3. Posizioni e ORDINI PENDENTI nel weekend/overnight: Challenge, Verification, conto finanziato Standard, conto Swing. Distingui sempre posizioni aperte e ordini pendenti.
4. Regole sulle news (finestra di minuti prima/dopo, su quali conti, quali strumenti, cosa vale come "trade": apertura, chiusura, SL/TP, pendenti).
5. Perdita giornaliera massima e perdita totale massima: come si calcolano (balance o equity, flottante, a che ora si azzera il giorno, fuso orario/ora del server, commissioni e swap inclusi o no), per ogni tipo di conto (Challenge, Verification, finanziato, 1-Step se esiste).
6. Target di profitto, giorni minimi di trading, durata massima, regole di inattivita.
7. Prelievi e profit split: quando si puo chiedere il payout, cosa deve essere chiuso prima, frequenza, percentuali per tipo di conto, regola "prelievo uno all'anno o mensile".
8. Commissioni e costi per strumento (forex, metalli/oro, indici, crypto), swap, spread, slippage, conversione valuta; leva per strumento.
9. Expert Advisor: sono permessi? Quali pratiche sono vietate (HFT, latency arbitrage, martingala, grid, tick scalping, copy, "forbidden trading practices" con elenco completo)?
10. VPS e piattaforme: VPS permessi, restrizioni geografiche, MT4/MT5/cTrader, orario del server (GMT+?) e cambio ora legale.
11. Limiti di ordini/posizioni al giorno e di lotti/esposizione per strumento.
12. Conti da 160k e superiori: disponibilita, regole diverse, tetto "scaling plan", numero massimo di conti attivi.
13. Free Trial: durata, cosa non vale, possibilita di acquisto dopo.
14. Rimborso della fee (quando e come), reset, riacquisto dopo fallimento, ripetizione dell'esame.
15. Qualsiasi regola o FAQ che non rientra nei punti sopra ma riguarda EA, copy trading, o capitale massimo.

Output finale (in italiano):
- Una tabella: punto | risposta sintetica | frase esatta | URL | stato (CHIARO / AMBIGUO / NON TROVATO).
- L'elenco di tutte le pagine lette con URL.
- Una lista "DOMANDE DA FARE ALL'ASSISTENZA FTMO PER ISCRITTO" per tutti i punti AMBIGUI o NON TROVATI.
- Segnala qualsiasi differenza fra le versioni del sito (en / au / altre) e fra pagina FAQ e pagina regole.
Se una pagina non si apre o richiede login, scrivilo e vai avanti. Non inventare nulla.
```

## Dopo la lettura
- Incolla/salva qui il risultato (o mandamelo): lo confronto con `DOMANDE_FTMO_PRIMA_DELLA_CHALLENGE_2026-11-06.md` e con il PDF `Regole_FTMO_ufficiali_2026-11-07.pdf` di tuo fratello. Dove l'estensione dice NON TROVATO o AMBIGUO, la risposta viene da FTMO per iscritto (supporto), non dall'estensione.
- L'estensione legge solo pagine pubbliche: le regole del TUO conto (FTMO Account, area clienti) non le vede senza login e non le deve vedere (login sempre a mano, solo tu).
