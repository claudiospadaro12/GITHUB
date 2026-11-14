# EA "solo positive + accelerazione" (idea di Claudio, 14/11/2026): CRITERI e PREVISIONI scritti PRIMA del codice

**Natura: CRITERI, nessun codice scritto, nessun test.** Idea di Claudio (testuale, 14/11/2026): "chiude e riapre operazioni solo quando sono positive; quando entra successivamente entra nel verso di come ha vinto"; "all'inizio ne apre poche, poi in base a se il prezzo accelera ne apre altre in sequenza anche 7 o 8 contemporaneamente". Nasce dallo screenshot di una pubblicita (non verificata) e dalla versione 1.07 di `ABTG_ScalperDirezionale` (demo manuale 50503635, `UPLOAD ABTG_ScalperDirezionale_4.mq5`), che ha una filosofia opposta (stop in euro e 10 secondi). **Solo demo e tester. NON per FTMO, NON per il reale 10105439, nessun giudizio su lotti, taglie o acquisti.**

## Regole (da implementare cosi)
1. **Verso iniziale**: segno della prima accelerazione (vedi 3); nessun ordine finche non c'e.
2. **Uscita**: ogni posizione chiude SOLO quando il profitto NETTO (profitto + swap + commissione) e >= `InpTargetEuro` (default 1,5 EUR a 0,01 lotti). **Nessuno stop sulla singola posizione.**
3. **Accelerazione** (parametri da FISSARE prima e NON ottimizzare): velocita = spostamento del bid negli ultimi 5 secondi, in punti, nel verso corrente; rapporto = velocita / media del valore assoluto dello spostamento a 5 s negli ultimi 600 s. Posizioni da aprire per passo = `clamp(floor(rapporto) - 1, 0, 3)`; massimo `InpMaxOpen` = 8 posizioni aperte insieme; pausa minima fra due passi 5 s.
3b. **Distanza fra le entrate (aggiunta del 14/11, dalle osservazioni di Claudio sull'EA della pubblicita):** quell'EA apre molte posizioni quasi uguali, a 1-2 punti l'una dall'altra, 3-4 per volta o anche 10, oppure poche con lotto grande. Nello screenshot le 7 posizioni erano a distanze di circa 0,06-0,30 USD (prezzi a 3 decimali). Nel nostro EA: distanza minima fra due entrate `InpMinGapUsd` (default 0,05 USD) e **tetto ai lotti totali aperti** `InpMaxTotalLots` (default 0,08 lotti): il rischio dipende dai lotti totali, non dal numero di posizioni (10 x 0,01 e 1 x 0,10 sono la stessa esposizione).
4. **Solo aggiungere ai vincitori**: nuove posizioni SOLO se il P/L fluttuante complessivo del cesto e >= 0. Mai aggiungere su un cesto in perdita (niente media al ribasso).
5. **Verso dopo una vincita**: la prossima ondata ha lo stesso verso dell'ultima posizione chiusa in profitto. Il verso si azzera (si aspetta una nuova accelerazione) dopo lo scatto del freno 6.
6. **Freno obbligatorio nel codice** (e uno stop mascherato; senza non si prova): se il P/L fluttuante complessivo scende sotto `-InpBasketStopEuro` (default 20 EUR), chiude tutto e si ferma per `InpCooldownMin` minuti (default 30).
7. **Tempo**: nessun uso di `GetTickCount()`; solo `TimeTradeServer()`/`TimeCurrent()` (cosi il tester a tick reali e valido). Conto: stesso blocco demo del 1.07 per l'esecuzione live; il tester non ha il blocco.
8. Lotto fisso 0,01 (nessuna progressione nella prima versione).

## Test (dopo il codice, non prima)
Tester BCM, Modello 4 (tick reali), XAUUSD, deposito 10.000 EUR, tre anni separati: **2013, 2020, 2025**. Misure per anno: netto dopo commissioni e swap, numero di posizioni, win rate, PF, DD equity massimo (EUR e %), numero di scatti del freno 6, massima perdita fluttuante, tempo medio di vita di una posizione, posizioni aperte da piu di 1 ora. Costi extra FTMO NON applicati (spread BCM, slippage zero nel tester).

## Previsioni dichiarate ORA (non misurate)
- **S-1** Win rate delle posizioni chiuse >= 90% in tutti e tre gli anni: 75%.
- **S-2** Il freno 6 scatta almeno una volta all'anno in almeno 2 anni su 3: 80%.
- **S-3** Netto dopo costi positivo in tutti e tre gli anni: 25%; positivo in almeno 2: 50%; negativo o nullo in 2013 (oro in forte ribasso): 65%.
- **S-4** Il DD equity massimo e almeno 3 volte `InpBasketStopEuro` (le perdite fluttuanti superano il freno prima che chiuda per gap e velocita): 40%.
- **S-5** Almeno il 5% delle posizioni resta aperto piu di 1 ora: 70%.
- **S-6** I costi (commissioni + spread) assorbono oltre meta del profitto lordo: 60%.
- **S-7** Il comportamento nel 2025 (oro in rialzo) e migliore di quello del 2013: 75%.

## Regole di lettura (fissate ora)
- **Utile come idea** solo se: netto positivo in almeno 2 anni su 3 **e** DD equity massimo <= 10 volte `InpBasketStopEuro` **e** nessun anno con il freno scattato piu di 20 volte.
- Se il netto e <= 0 in almeno 2 anni su 3: **stop**, nessuno sviluppo, nessun forward.
- Qualunque cosa: **mai** su conti di prop firm (il DD fluttuante conta sull'equity; limite FTMO di circa 2.000 richieste/giorno; condizioni 7.1).

## Limiti dichiarati
Un percorso per anno; Randomization assente; velocita e rapporto di accelerazione sono scelte mie, non misurate; i parametri di default sono punti di partenza; il tester non ha slippage ne latenza (uno scalper a pochi secondi guadagna di piu nel tester che in demo); nessun dato su cosa fa la strategia della pubblicita (non verificabile).
