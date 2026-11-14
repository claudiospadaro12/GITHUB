# EA "solo positive + accelerazione" (idea di Claudio, 14/11/2026): CRITERI e PREVISIONI scritti PRIMA del codice

**Natura: CRITERI, nessun codice scritto, nessun test.** Idea di Claudio (testuale, 14/11/2026): "chiude e riapre operazioni solo quando sono positive; quando entra successivamente entra nel verso di come ha vinto"; "all'inizio ne apre poche, poi in base a se il prezzo accelera ne apre altre in sequenza anche 7 o 8 contemporaneamente". Nasce dallo screenshot di una pubblicita (non verificata) e dalla versione 1.07 di `ABTG_ScalperDirezionale` (demo manuale 50503635, `UPLOAD ABTG_ScalperDirezionale_4.mq5`), che ha una filosofia opposta (stop in euro e 10 secondi). **Solo demo e tester. NON per FTMO, NON per il reale 10105439, nessun giudizio su lotti, taglie o acquisti.**

## Regole (da implementare cosi)
1. **Verso iniziale**: segno della prima accelerazione (vedi 3); nessun ordine finche non c'e.
2. **Uscita**: ogni posizione chiude SOLO quando il profitto NETTO (profitto + swap + commissione) e >= `InpTargetEuro` (default 1,5 EUR a 0,01 lotti). **Nessuno stop sulla singola posizione.**
2b. **Modo di uscita a cesto (aggiunta del 14/11, osservazione di Claudio: "tutto quando diventano blu poi li chiude"):** oltre alla chiusura per singola posizione (regola 2), si prova l'uscita A CESTO: quando il profitto netto complessivo del cesto e >= `InpBasketTargetEuro` (default 2,0 EUR) si chiudono TUTTE le posizioni insieme, anche se qualcuna e in perdita. `InpExitMode` = 0 per posizione, 1 a cesto; i due modi si provano separatamente sugli stessi anni. Con l'uscita a cesto una posizione vincente puo restare aperta finche le altre non recuperano: aumenta il tempo in cui il conto e esposto.
**AGGIORNAMENTO 14/11 sera (spiegazione di Claudio, sostituisce le regole 1, 3 e 5):** "alla apertura degli ordini, se il prezzo si e girato long o short, gli ordini devono aprire long o short; in una frazione di secondo, 1 o 2 secondi, l'EA in base a come si e mosso il prezzo apre l'ordine con piu ordini nella direzione dove e andato il prezzo".
- **Direzione a ogni apertura** = segno dello spostamento del bid negli ultimi `InpLookbackSec` secondi (default 2, regolabile 1-2), se lo spostamento e >= `InpMinMovePoints` punti (default 3); altrimenti nessuna apertura. La direzione puo quindi cambiare da un cesto al successivo: **la regola 5 (verso dell'ultima vincita) e sostituita**.
- **Numero di ordini** = `clamp(floor(spostamento / InpPointsPerOrder), 1, InpMaxOpen)` (default 1 ordine ogni 3 punti di spostamento, massimo 8, mai oltre `InpMaxTotalLots`).
- Il bid e letto dai tick con il tempo in millisecondi (`SymbolInfoTick().time_msc`), cosi il tester a tick reali e valido. Restano valide le regole 2, 2b, 3b, 4 e 6 (uscita in profitto, cesto, stesso lotto a 1-2 punti, solo aggiunte ai vincitori, freno).
- **Nota onesta:** su 1-2 secondi la direzione del bid e in gran parte rumore del book (rimbalzo bid-ask); a quella scala il prezzo tende a tornare indietro piu che a proseguire. Non so quanto, e non c'e un dato nostro: la prova nel tester a tick reali serve a questo. In live con VPS la latenza (decine o centinaia di millisecondi) e una frazione non piccola dei 1-2 secondi, e il tester non la simula.
3. **Accelerazione** (parametri da FISSARE prima e NON ottimizzare): velocita = spostamento del bid negli ultimi 5 secondi, in punti, nel verso corrente; rapporto = velocita / media del valore assoluto dello spostamento a 5 s negli ultimi 600 s. Posizioni da aprire per passo = `clamp(floor(rapporto) - 1, 0, 3)`; massimo `InpMaxOpen` = 8 posizioni aperte insieme; pausa minima fra due passi 5 s.
3b. **Distanza fra le entrate (corretta il 14/11 su richiesta di Claudio: "gli ordini che si aprono devono avere 1 o 2 punti di distanza, devono essere simili"):** le entrate di un cesto sono tutte dello STESSO lotto e a distanza di `InpGapPoints` punti MT5 (default 2, regolabile 1-2) l'una dall'altra, nel verso del movimento: una nuova entrata parte solo quando il prezzo si e spostato di almeno `InpGapPoints` oltre l'ultima entrata. L'unita e il punto MT5 del simbolo (`_Point`): il codice stampa all'avvio quanti USD vale (su XAUUSD a 2 decimali 1 punto = 0,01 USD; a 3 decimali = 0,001 USD). **Nota onesta:** a 1-2 punti (cioe 1-2 centesimi su un simbolo a 2 decimali) le entrate stanno dentro lo spread (decine di punti): ogni posizione paga lo spread intero, quindi N posizioni = N spread. Nell'EA della pubblicita le 7 posizioni dello screenshot erano a 0,06-0,30 USD l'una dall'altra (prezzi a 3 decimali: circa 64-300 punti a 3 decimali). Il tetto ai lotti totali aperti `InpMaxTotalLots` (default 0,08): il rischio dipende dai lotti totali, non dal numero di posizioni.
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
- **S-9** (direzione dal movimento a 2 secondi) La quota di cesti il cui prezzo prosegue nella direzione scelta per almeno `InpMinMovePoints` punti nei 10 secondi successivi e fra 45% e 55% (nessun vantaggio direzionale): 70%; sopra il 55%: 15%; sotto il 45% (rimbalzo, cioe il segno e controproducente): 15%.
- **S-8** (modo a cesto contro per posizione, stessi anni) Il DD equity massimo del modo a cesto e maggiore di quello per posizione in almeno 2 anni su 3: 70%; il numero di scatti del freno 6 e maggiore: 65%; il netto e maggiore in almeno 2 anni su 3: 40%.
- **S-7** Il comportamento nel 2025 (oro in rialzo) e migliore di quello del 2013: 75%.

## Regole di lettura (fissate ora)
- **Utile come idea** solo se: netto positivo in almeno 2 anni su 3 **e** DD equity massimo <= 10 volte `InpBasketStopEuro` **e** nessun anno con il freno scattato piu di 20 volte.
- Se il netto e <= 0 in almeno 2 anni su 3: **stop**, nessuno sviluppo, nessun forward.
- Qualunque cosa: **mai** su conti di prop firm (il DD fluttuante conta sull'equity; limite FTMO di circa 2.000 richieste/giorno; condizioni 7.1).

## Limiti dichiarati
Un percorso per anno; Randomization assente; velocita e rapporto di accelerazione sono scelte mie, non misurate; i parametri di default sono punti di partenza; il tester non ha slippage ne latenza (uno scalper a pochi secondi guadagna di piu nel tester che in demo); nessun dato su cosa fa la strategia della pubblicita (non verificabile).

## Nota del 14/11 sera (codice scritto: `mql5/Experts/ABTG_ScalperClaudio.mq5`, 1.00)
- **Non compilato qui** (nessun MetaEditor): il primo passo e compilare sul PC di backtest e riportare gli errori.
- **Tick reali per 2013 e 2020 sul BCM: DISPONIBILITA NON VERIFICATA.** Fin qui abbiamo usato i tick reali solo sul 2025 e sul 2026; un EA a 1-2 secondi non e valido a candele da 1 minuto (Modello 1). Se i tick 2013/2020 non ci sono, la prova si fa sul 2025 e sul 2026 e la previsione S-3 su 2013 resta non testabile.
- La distanza di 1-2 punti fra le entrate e MISURATA (stampata nel riepilogo), non imposta; `InpGapMaxPoints` e solo una guardia.
