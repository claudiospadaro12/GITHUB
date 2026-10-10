# MARKET: "Gold Scalper PRO" / "Gold Scalper for MT5 EA" (Andrei Mikheev), 10/10/2026

**BOZZA, NON passata dal cancello** (controllo-preventivo non ancora invocato). Non e' una consegna operativa: e' un dossier di lettura.

Letto OGGI, 10/10/2026, da sandbox, **solo web pubblico, sola lettura**. Niente scaricato dal Market, nessuna registrazione, nessun login, nessuna decompilazione, nulla eseguito, nessun EA/preset/conto/terminale toccato. Sono state scaricate solo **pagine HTML pubbliche e 6 immagini pubbliche** (4 allegati dei commenti/prodotto + 2 schermate del prodotto) nella cartella temporanea di sessione, **non nel repo**.

Etichette: **[VERIFICATO]** letto da me su pagina/immagine pubblica oggi · **[DICHIARATO DA TERZI]** detto dall'autore o dal venditore (o da un utente), mai un criterio e mai nel punteggio · **[MQL5, dato di piattaforma]** statistica calcolata da MQL5 · **[DERIVATO]** aritmetica mia su numeri letti · **[INFERITO]** deduzione, con la ragione · **[INCERTO]** non lo so.

---

## 0. LA RIGA CHE CONTA

> **SCARTATO. Il prodotto e' una scatola nera: niente sorgente, niente scaricabile oggi dalla sua pagina, tesi di mercato non dichiarata, lotto FISSO con uno stop da circa 97 USD e un take profit a 5.500 USD (cioe' non esiste), autore interdetto dalla vendita su MQL5, con un secondo account dichiarato da lui stesso, set "premium" venduti a mano via messaggio e tre utenti che riferiscono di conti azzerati o di un backtest andato a zero.**
> Nessun meccanismo nuovo da riprodurre: l'unico dato di meccanica visibile (un input `FastMaPeriod` = 22 e un filtro `Wednesday`) e' generico e gia' coperto in casa (EMA + canale = GBA, EMA200).
> **Punteggio scheda: 1/10 (SCARTO < 5).**

---

## 1. ACCESSO E CONTROLLO POSITIVO (fatto prima di leggere)

| fonte | bersaglio noto | esito |
|---|---|---|
| `mql5.com/en/market/product/178437` (curl, user-agent normale) | deve rendere titolo, autore, data, versione come nello screenshot di Claudio | **200, 241 KB. PASS: titolo "Gold Scalper for MT5 EA" (brand nel testo: "Gold Scalper PRO"), Andrei Mikheev, GRATUITO, pubblicato 25/05/2026, v1.2, aggiornato 20/07/2026, 4,5 stelle, "Author debarred from selling products": coincide riga per riga con lo screenshot** |
| `.../178437/comments` + `/comments/page2` + `/comments/page3` | 53 commenti | **200 su tutte e tre; letti #1-#53 per intero** (attenzione: `?page=2` NON pagina, si usa `/comments/page2`) |
| `.../178437/updates` (What's new) | note di versione | **200**, una sola voce (v1.2) |
| profilo `/en/users/nagart` e `/publications` | profilo, prodotti, bacheca | **200** |
| schede sorelle 177351, 188393, 190981, 194048 e signal 2391311, 2391665 | collegamenti dal profilo | **200** tutte |
| `c.mql5.com` (immagini allegate) | 4 allegati + 2 schermate | **200** tutte |
| Code Base `mql5.com/en/code/mt5/experts` | lista con titoli | **200, titoli veri** (la pagina non mostra autore/data: servirebbe aprire ogni voce) |
| `WebFetch` generico sulla scheda | stessa pagina | funziona ma **riassume e perde** (non dava ne' input ne' immagini); per MQL5 il `curl` raw e' piu' affidabile |
| `forge.mql5.io/nagart` (Algo Forge del profilo) | repository dell'autore | **NON RAGGIUNTO: 403 al CONNECT del proxy** (non e' un 404: non so se esista qualcosa) |
| GitHub (ricerca repo/codice) | repo con sorgente | **NON RAGGIUNTO**: la sessione e' vincolata ai suoi repository, l'endpoint di ricerca risponde 403 |

Nota onesta sulla ricerca web: la prima WebSearch con "Andrei Mikheev" NON trovava la pagina (ha restituito prodotti omonimi di altri autori); la seconda l'ha trovata. Inoltre il riassunto della ricerca attribuiva alla scheda "timeframe 1H, deposito 400 USD, backtest 2018-2023 su MT4": **[VERIFICATO] falso per questa pagina**: quelle righe stanno nel testo di un prodotto affiancato nei "correlati" (Peri Peri Gold). Non le uso.

---

## 2. LA SCHEDA (griglia del par. 7 delle regole di caccia)

```
NOME            Gold Scalper for MT5 EA   (brand nel testo: "Gold Scalper PRO")
FONTE / URL     https://www.mql5.com/en/market/product/178437   [letta 10/10/2026]
AUTORE / DATA   Andrei Mikheev (login nagart, "Russia"), pubblicato 25/05/2026,
                v1.2 del 20/07/2026
POPOLARITA'     4,5 stelle; 11 recensioni (8 da 5 stelle, 2 da 4, 1 da 2); 53 commenti;
                il numero di demo scaricate NON e' mostrato sulla pagina
LICENZA         nessuna dichiarata (prodotto del Market, .ex5 compilato)
RIGHE / INPUT   NON CONTABILI: nessun sorgente, nessun elenco di input sulla pagina.
                Dagli screenshot degli utenti si vedono 7 input (par. 5)

TESI IN UNA RIGA
  NON SCRIVIBILE. La pagina dice solo "monitora le condizioni di mercato con la
  sua logica interna" e "entra solo quando tutte le condizioni sono soddisfatte".
  [INFERITO, debole] media mobile veloce (periodo 22) + qualcosa che l'autore
  chiama "falsi breakout" nella sessione asiatica (par. 6).

MECCANICA        [DICHIARATO DA TERZI] ingresso: "logica interna"; uscita: break-even,
                 trailing, "exit management"; stop: SL e TP gestiti "internamente"
GESTIONE RISCHIO LOTTO FISSO (input LotSize, valore 0,02 nello screenshot di un
                 utente; 0,1 su 392 USD nella schermata dell'autore). Nessun input di
                 rischio % visibile. SL presente nelle schermate dell'autore (~97 USD),
                 TP 10031,62 = a +5.500 USD dall'ingresso (non esiste)
BANDIERE ROSSE   vedi par. 7 (lotto fisso, TP irraggiungibile, nessun sorgente,
                 "grid" nel testo d'origine, divieto di vendita, venditore multiplo)
COSTO DI PORTING non portabile: niente sorgente. Riscrittura da zero = ore, ma su cosa?
                 La logica non e' pubblica.

PUNTEGGIO (0-2 per voce)
  [1] semplicita'               (i pochi input visibili sono pochi, ma il resto e' ignoto)
  [0] il filtro E' il motore    (non so cosa sia il motore)
  [0] tesi di mercato scrivibile
  [0] riempie un BUCO           (se MA+breakout long-biased su oro: doppione di GBA/EMA200)
  [0] testabile senza riscritture (niente sorgente; il lotto non e' in %: serve un
                                   involucro che non possiamo mettere su un .ex5)
  TOTALE 1/10

VERDETTO   SCARTO (< 5)
PERCHE'    nessuna tesi scrivibile e nessun sorgente: non c'e' una "macchina" da
           tradurre, e cio' che si vede (lotto fisso, SL ~97 USD, TP a 5.500 USD,
           autore interdetto) e' esattamente la forma che il nostro imbuto esiste
           per non comprare.

IN OTTICA PROP  il lotto fisso non e' scalabile a 100k e la perdita per operazione e'
           dettata dalla distanza dello stop, non dal rischio: a 0,65% (650 USD) il
           lotto sarebbe 0,067, ma l'EA non ha un input che lo faccia da solo (par. 8).
```

---

## 3. COSA E' DAVVERO SCARICABILE (dichiarato con onesta')

| cosa | stato | etichetta |
|---|---|---|
| **sorgente `.mq5` / `.mq4`** | **NON ESISTE in pubblico.** Profilo dell'autore: "Publications: **No publications**" (quindi nessuna voce Code Base); nessun repository trovato (Algo Forge e GitHub non raggiunti, par. 1); la ricerca web non trova nulla a suo nome. Il sorgente dei suoi EA lo **vende lui**: "a complete EA with source code starts from **$509**", "early-access EAs from **$50**", via messaggio privato | [VERIFICATO] sul profilo e sulla bacheca |
| **`.ex5` dalla pagina** | **La pagina NON mostra il blocco di installazione/Download.** Confronto che regge: la scheda sorella `188393` (stesso testo) mostra "Have you installed MetaTrader 5? ... Download"; la scheda `178437`, aperta con lo stesso metodo, **no** | [VERIFICATO] (differenza reale fra due pagine lette con lo stesso metodo) |
| **conferma da un browser LOGGATO** | la schermata `c.mql5.com/31/2449/Scr.jpg` (allegata dall'utente Tosomeone4518, commento #52, 06/10) mostra la scheda **aperta col suo account loggato** (nome utente in alto a destra): nella colonna sinistra ci sono solo "FREE" e "Author debarred from selling products", **nessun pulsante di installazione** | [VERIFICATO] l'immagine |
| **perche'** | [INFERITO] effetto del divieto di vendita. Coerente con i commenti: 17-20/07 "il robot non e' piu' disponibile" (#24-#25), l'autore risponde il 20/07 "ora e' di nuovo scaricabile" (#26-#27); il **06-07/10** due utenti scrivono "non trovo il file dell'EA" e "come faccio ad averlo?" (#52-#53) | [VERIFICATO] i commenti; [INFERITO] la causa |
| **`.ex5` dal terminale MT5** | si ottiene solo da un terminale MT5 con account mql5 loggato (Market > Gratis). **Non fattibile dal sandbox, e io non l'ho tentato.** Se oggi funzioni, non lo so | [INCERTO] |
| **.set** | **non pubblici**: "set file premium" dato **solo via messaggio privato** (una dozzina di risposte "mandami un DM", par. 6) | [VERIFICATO] |
| **decompilazione** | **esclusa** (regola di casa, e comunque non e' un modo legittimo) | |

Quindi: **non possiamo leggere il codice**, e il setaccio del par. 4 delle regole non e' applicabile alla lettera. Cio' che resta sono **screenshot e commenti pubblici**, usati come testimonianza, non come sorgente.

---

## 4. IL DIVIETO DI VENDITA: COSA DICE LA PAGINA E COSA NON DICE

- **[VERIFICATO]** La scheda porta, sotto il prezzo, la dicitura **"Author debarred from selling products"** (la stessa dello screenshot di Claudio) e il nome dell'autore barrato.
- **[VERIFICATO, DICHIARATO DA TERZI]** Il **motivo NON e' dichiarato da MQL5**. L'unica spiegazione e' dell'autore, 23/07/2026, in risposta a un utente (#recensione di Deepak Vaish) e in un post sulla sua bacheca: *"my products are currently unavailable on the MQL5 Market while I work with MQL5 support regarding my seller account"* / *"our products are temporarily unavailable... active discussions with the MQL5 Support Team regarding our seller account"*. **Non so perche' sia stato interdetto. Non lo scrivo.** [INCERTO]
- A 10/10/2026 il flag e' **ancora attivo**, cioe' **79 giorni dopo** la sua dichiarazione "temporanea" [DERIVATO: 23/07 -> 10/10].
- Il prodotto resta **comunque in vetrina**: pubblicato 25/05, ultimo aggiornamento 20/07 (v1.2, note: "stabilita'", "compatibilita'", "correzioni minori", nessuna riga di sostanza).

---

## 5. COSA SI VEDE DAVVERO (immagini pubbliche, lette una a una)

### 5.1 Schermata degli input di un utente: `c.mql5.com/31/2176/EA.png` (allegata al commento #15 di MapeXau) [VERIFICATO]
Titolo finestra: **"Gold Scalper for MT5 EA 1.01 (XAUUSD,M5)"**. Input leggibili:

| input | valore |
|---|---|
| `MagicNumber` | 24990 |
| `LotSize` | **0,02** (lotto FISSO) |
| `StopLossPips` | **10010** |
| `TakeProfitPips` | **550010** |
| `Timeframe` | "1 Minute" (il grafico e' M5: l'EA ha un TF interno suo) |
| sezione `=== Indicator Settings ===` -> `FastMaPeriod` | **22** |

Il commento #13 dello stesso utente conferma: *"My default settings were SL:10010 and TP:550010"*; l'autore NON dice che e' un errore (#14): *"the default SL and TP values should not normally be changed"*. Altri due utenti riportano gli stessi numeri (recensione di mightyN, commento #7 di v1kkm: "stoploss e take profit eccezionalmente alti").
**[DERIVATO] su XAUUSD con Digits 2 / Point 0,01** (il nostro simbolo BCM e' cosi': `ORO_1530_DISEGNO_MISURA_2026-09-10.md` r.160): 10010 punti = **100,10 USD** di stop, 550010 punti = **5.500,10 USD** di take profit. Se il broker dell'utente avesse 3 decimali sarebbero 10,01 e 550,01 USD: l'ordine di grandezza del TP non cambia il fatto che **non e' raggiungibile**.

### 5.2 Schermata del prodotto, dell'autore: `c.mql5.com/31/2053/gold-scalper-for-mt5-ea-screen-9356.png` (25-26/05/2026) [VERIFICATO]
Grafico M5 XAUUSD, pannello "GOLD SCALPER AUTOMATED ENGINE": **Balance 392,32 · Equity 414,82 · Floating +22,50 · Spread 35,0 "Pips" · Signal Status NO SIGNAL · Active Lots 0,10 (1 Pos)**. Tabella posizioni:

| ticket | tipo | lotti | prezzo | **S/L** | **T/P** | magic / commento |
|---|---|---:|---:|---:|---:|---|
| 1132827060 | **buy** | **0,1** | 4531,86 | **4435,14** | **10031,62** | 24990 / "24990" |
| 1132718022 | sell stop | 0,01 | 4512,08 | 4529,79 | 4427,15 | 2428 / **"Gold Family_PendingE"** (un ALTRO EA dello stesso conto) |

**[DERIVATO] tre numeri da questa sola schermata:**
1. **TP = 10031,62** = bid (4531,51) + 5.500,10: coincide con `TakeProfitPips` 550010 a Point 0,01 (controllo incrociato: lo spread del pannello, 35 punti = 0,35 USD, spiega la differenza fra 4531,86 e 4531,51). **Il TP del default e' davvero a +5.500 USD: non e' un'uscita.**
2. **Lo stop e' a 96,72 USD dall'ingresso** (4531,86 - 4435,14), quindi circa 100 USD, coerente con 10010 punti.
3. **Perdita massima di quella posizione: 0,1 lotto x 100 oz x 96,72 = 967 USD, cioe' 2,47 volte il saldo di 392,32 USD.** Su quel conto lo stop non protegge: arriverebbe prima la chiusura per margine (margin level 457,66% con quella sola posizione). [VERIFICATO l'immagine, DERIVATO il calcolo]

### 5.3 Schermata del prodotto, grafico del tester: `.../2050/gold-scalper-for-mt5-ea-screen-4512.png` [VERIFICATO l'immagine]
Curva Balance/Equity del Strategy Tester, **2024.01.04 -> 2026.01.02 e oltre**, da circa 1.000 a circa 22.000 (asse 923 -> 23.010). **Nessuna statistica, nessun modello di tick, nessun costo, nessun input visibile.** Il sotto-grafico **"Deposit Load" parte con picchi fino a ~50% nel 2024 e scende a ~0 negli anni dopo.** [INFERITO, e dico da cosa] con un lotto in percentuale del rischio il carico di margine resterebbe circa costante al crescere del saldo; **qui decade**, il che e' la firma di un **lotto fisso** su un saldo che cresce (coerente con l'input `LotSize` del par. 5.1). Il periodo coincide con un lungo rialzo dell'oro [DERIVATO dal fatto che nei commenti l'oro e' a ~4.000-4.500 USD a maggio-luglio 2026 e la curva sale di 20 volte]: **un lotto fisso su un motore che resta lungo in un toro fa curve cosi', senza che questo sia un edge**. [INFERITO]

### 5.4 Schermata di un utente, 29/07/2026: `c.mql5.com/31/2234/ScreenHunter_375.png` (commenti #30-#33, utente ZN) [VERIFICATO l'immagine]
Storico di 8 operazioni **sell XAUUSD**, tutte con la colonna **S/L VUOTA**:
- 6 operazioni da **0,01** chiuse sul TP, con TP a **2,74-3,64 USD** dall'ingresso (differenze fra prezzo d'ingresso e di uscita lette sull'immagine; profitti mostrati +2,06...+2,74 nella valuta del conto, **che l'immagine non indica**: il rapporto 0,75 fra profitto e movimento suggerisce una valuta diversa dal dollaro [INFERITO]), 29/07 fra le 09:46 e le 17:43;
- **17:58:02 sell 0,01 a 4003,36** e **20:04:06 sell 0,1 a 4033,67 (dieci volte il lotto, 30 USD SOPRA la prima, cioe' contro la posizione aperta)**, **entrambe con lo stesso T/P 4001,63**, **chiuse alle 21:00:07 e 21:00:09 a 4065,88 e 4077,86 con -241,64 e -55,89**; totale del blocco **-273,79**. L'utente scrive: *"it made profit for 2 weeks. And suddenly... carnage"* e *"this bot can wipe your acc in 5 minutes"*.
**[INFERITO, e dico perche']** le due ultime righe hanno la **firma di un'aggiunta contro il prezzo con lotto x10 e TP comune**, cioe' di un **recupero/averaging**. **[INCERTO]** se sia l'EA o un'operazione a mano dell'utente, e quali input avesse: **non e' una prova, e' il motivo per cui nessun "no martingale/no grid" scritto sulla pagina conta** finche' non c'e' una prova nel tester.
**[DERIVATO, su due fonti non omogenee: stop ~96,7 USD dallo screenshot dell'autore e TP ~3,6 USD da questo]**: con quelle due distanze il tasso di vincita di pareggio (a costi zero) e' 96,72 / (96,72 + 3,61) = **96,4%**. E' la matematica del "tante vincite piccole, una perdita enorme", che spiega la forma "profitto per due settimane e poi carnage". Lo scrivo come ordine di grandezza, non come misura.

---

## 6. COMMENTI E RECENSIONI: COSA DICONO (tutti letti, 53 + 11)

**Recensioni (11) [VERIFICATO]**: 8 da 5 stelle, 2 da 4, 1 da 2. Il punteggio del prodotto e' 4,5 ma **il testo smentisce parecchie stelle**: Mohd Mazher (5 stelle) riceve la risposta "il backtest su 1.000 USD e' fallito"; Abid Hussain (5) scrive "Status: No Signal"; mightyN (5) lamenta TP/SL enormi; Bangkok_Baz (5) scrive che l'account dell'autore e' stato "hackerato". **Tre recensioni (Mohd Mazher, Deepak Vaish, soundonmike) sono "senza commento"**; l'autore ha **sollecitato recensioni** nel commento #12 (9/7: *"I would greatly appreciate it if you could leave an honest review"*) e ha ringraziato per una "5-star review" di due parole ("Nice EA").
**La recensione piu' pesante** e' di **alou131 (26/06/2026, 5 stelle): "ho passato una challenge FTMO da 200k con questo EA... non so perche' non ci siano recensioni prima della mia"**. [DICHIARATO DA TERZI] Non verificabile (FTMO e' bloccato dal proxy, nessun certificato). **Nota [VERIFICATO]**: era la prima recensione in assoluto, a un mese dalla pubblicazione, e nessun commento successivo la corrobora; l'unico utente che chiede se l'EA e' adatto a una prop (#46, 23/08, Andre Thielemann) **non riceve risposta**.

**Commenti: cosa torna piu' volte [VERIFICATO]**
| tema | dove | cosa risponde l'autore |
|---|---|---|
| "non apre operazioni / No Signal / 5 ore e una sola operazione" | #2, #34, #50, recensioni Abid, Trevor | "e' normale, entra solo quando tutte le condizioni sono soddisfatte" |
| "SL e TP enormi (10010 / 550010)" | #7, #13-#15, recensione mightyN, recensione After 9fx | "non cambiarli se non sai come funzionano", "la gestione e' interna", poi **"set premium via DM"** |
| backtest fallito | #9 McFab (6/7), #47 McFab (26/8) | "usa M5, usa i set giusti"; McFab riferisce **"6 mesi con 1k: ha fatto 33k, poi li ha persi tutti"** [DICHIARATO DA TERZI] |
| **conto azzerato / "carnage"** | #30-#33 ZN (29/07), #51 Jamal (11/09: "il mio DD massimo e' 500 USD e a volte l'EA va a -600 USD o piu' **con una sola operazione**") | a ZN: "serve il Premium Set File"; **a Jamal: nessuna risposta** |
| solo BUY in 30 giorni | #40-#41 ABDULLA ALGHONAIM (14/08) | "dipende dal broker... usa il Premium Set File" |
| nessun filtro di sessione / falsi breakout in Asia | #16-#19 Aman1405 | **l'autore conferma**: "in sessione asiatica ci sono piu' falsi breakout... **nella versione attuale non c'e' un filtro di sessione**"; `Wednesday = false` di default e' **voluto** (gestione del rischio "in base ai test") |
| "e' un EA a griglia?" | #4-#6 patrickdrew (15/06) citando la descrizione allora online: *"Advanced Pro-Grid HUD Dashboard"* | "no, il 'grid' e' solo il nome del pannello; **non si basa su tecniche di griglia TRADIZIONALI** che aggiungono continuamente posizioni contro il mercato". **La frase non e' piu' nella descrizione di oggi** (verificato: la descrizione attuale dice solo "No Martingale / No Grid") |
| set file | #22-#23, #35-#38, #42-#45, #48 e altri **dieci** | **sempre "mandami un DM": set 'premium' ottimizzato per broker e conto** |

**Cosa NON c'e'**: nessun elenco di input sulla pagina, nessuna statistica, **nessun signal collegato** (il profilo dell'autore dice **0 signal**), nessun backtest con numeri, nessuna risposta alla domanda "e' adatto a una prop?".

---

## 7. IL SETACCIO (par. 4 delle regole), CON LE LIMITAZIONI DEL .ex5

| bandiera | esito | prova |
|---|---|---|
| martingala / raddoppio | **[INCERTO], sospetta** | dichiarato "no martingale"; ma il caso ZN (5.4) mostra un lotto x10 contro la posizione aperta. Non provabile senza tester |
| griglia / averaging | **[INCERTO], sospetta** | descrizione di giugno "Pro-Grid", risposta dell'autore con "tradizionale"; ZN: seconda posizione a +30 USD contro la prima. Dichiarato "no grid" nel testo di oggi |
| nessuno stop | **SL presente nello screenshot dell'autore ma NON PROTEGGE**: 96,72 USD x 0,1 lotto = 2,47x il saldo | par. 5.2 |
| lotto fisso senza rischio % | **SI'** | `LotSize` 0,02 (5.1); Deposit Load che decade (5.3); recensione di Jamal (-600 USD da una sola operazione) |
| TP irraggiungibile | **SI'** | 550010 punti = 5.500 USD (5.2) |
| repaint / look-ahead | **NON VERIFICABILE** senza sorgente | |
| indicatori esterni / DLL / WebRequest / licenze | **NON VERIFICABILE** | il `.ex5` non e' leggibile |
| **niente sorgente** | **SI'** | par. 3 |
| venditore | **ROSSO**: interdetto dalla vendita; 3 identita'; vendita fuori piattaforma | par. 8 |

---

## 8. IL VENDITORE (due diligence, gradino 1-bis del cancello d'acquisto)

[VERIFICATO sulle pagine pubbliche, 10/10/2026]
- **Tre nomi, un'unica persona, dichiarato da lui.** Sul prodotto la firma e' "Andrei Mikheev" (login `nagart`, Russia), nelle risposte compare **"Best regards, Utazima MentorCreate"** (commento #5) e nelle schermate la dicitura **"Utazima_MentorCreate_PRO"**; l'utente Bangkok_Baz scrive (28/09) che **"Byiringiro Anastase"** gli chiede 47 USD via messaggio per un "file aggiornato" e **l'autore risponde: *"Byiringiro Anastase is me. This profile is used for EA development and broker support."*** Esiste il profilo **Anastase Byiringiro** ("CEO at Incredible Traders", Rwanda, 5 prodotti, 2 signal, voto 2,2 su 5 recensioni).
- **Lo stesso testo e' in vendita/vetrina sotto l'altro account.** La scheda gratuita **"XAU 1 Minute" (`/market/product/188393`, Anastase Byiringiro, pubblicata 31/07/2026, v1.3 del 05/10/2026)** ha **la stessa descrizione parola per parola** (confronto riga per riga, 52 righe su 52 identiche tranne il nome del prodotto) e **in fondo la stessa coda "Gold Scalper PRO / Free Expert Advisor for MetaTrader 5 / ```"**. La scheda e' scaricabile (blocco "Download" presente). Il suo "What's new" v1.2 del 04/09: *"Product renamed to XAU 1 Minute. Upgraded Gold trading engine and dashboard"*; v1.3 del 05/10 apre con **"Use this professional MQL5 V1.03 update description:"** (resto di un prompt incollato per errore) e dichiara che *"la strategia, la logica di ingresso/uscita, SL, TP e il rischio restano invariati"*.
  **[INFERITO]** stesso motore sotto un altro nome (stesso testo, rinominato). **[INCERTO]** se il motore sia davvero lo stesso. **[INFERITO]** il secondo account e' stato pubblicato **8 giorni dopo** la dichiarazione "i miei prodotti sono sospesi" (31/07 contro 23/07): **non so se questo violi le regole del Market** (non ho letto il regolamento): lo segnalo come fatto, non come accusa.
- **Vendita fuori piattaforma, scritta da lui sulla bacheca (03/08/2026)**: pacchetti con sorgente **da 509 USD** (con possibilita' di "pubblicarli col proprio marchio"), EA "early access" **da 50 USD**, **servizio di copia automatica di conti da 79 USD con "50/50 di condivisione dei profitti"**, **"Academy" a 500 USD**. I "set premium" dell'EA gratuito sono la porta d'ingresso.
- **Prodotti e signal gemelli (stessa mano)**, [MQL5, dato di piattaforma]: "Xauusd 1 Minute Premium EA" **189,99 USD**, 10 attivazioni; il suo signal 2391311 ha **3 settimane, 5 operazioni, 100% vincenti, deposito 81 USD, "Copy for 999 USD per month"** e l'avviso di MQL5 *"the number of deals on the account is too small to evaluate trading quality"*; "Gold Family EA" signal 2391665: **4 settimane, 19 operazioni, PF 1,16, DD saldo 15,62%, deposito 60 USD, prezzo di copia 999 USD/mese**. **Sono prove di nulla** (n troppo piccolo, conti da 60-160 USD) e il prezzo di abbonamento e' fuori scala.
- **Il segnale che serve qui: il prodotto in esame non ha NESSUN signal pubblico** (profilo di Andrei Mikheev: 0 signal).

---

## 9. CONFRONTO CON GBA E CON LA FRONTIERA DEL COSTO

### 9.1 Il nostro punto di riferimento (da `report/GBA_R2_PIANO_2026-10-10.md` e `docs/PER_GEMINI_GBA_ORO_2026-10-10.md` (al 10/10 17:30 il file e' stato rinominato da un'altra sessione in `docs/PER_GEMINI_ORO_DOCENTE_2026-10-10.md`; letto col nome vecchio), **non ricontrollato qui**)
GBA (`ABTG_GoldBreakoutATR`, magic 775800): breakout di canale + EMA, SL 2,5 ATR, uscita a tempo; a tick reali 933 operazioni **PF_V 0,855** (bootstrap 2,5-97,5%: 0,70-1,03), lordo di costi -0,014 R. Frontiera del costo di casa **stop >= 40 x spread**; oro BCM spread mediano **0,21-0,26 USD**, ATR M1 mediano 2-5 USD; per M1 il nostro proxy da' **21,6x (FRA)**, M5 53,3x (passa).

### 9.2 Uno scalper dichiarato M1/M5 con stop corti passerebbe? [DERIVATO]
- **Stop minimo di casa**: 40 x 0,21 = **8,40 USD**, 40 x 0,26 = **10,40 USD**. A M1 con ATR 2-5 USD servono stop di **circa 2-5 ATR**; uno stop di 1 ATR a M1 (2-5 USD) fa **8-24x** lo spread: **sotto la frontiera**.
- **Questo EA non e' uno "scalper con stop corti"**: lo stop dell'autore e' **~97-100 USD** (**385-477x** lo spread, quindi la frontiera del COSTO non lo tocca) e il TP e' irraggiungibile. **Le uscite reali sono trailing/BE/"uscita interna"**: come GBA (dove l'1,1% esce a SL), ma **senza che si conosca la regola**. I TP di ~2,7-3,6 USD che si vedono nel caso ZN (5.4) sono **11-17x lo spread** (2,74/0,26 = 10,5 ... 3,64/0,21 = 17,3): **sotto 40x per il guadagno, non per lo stop**.
- Con **SL = 100 USD** il problema non e' il costo, e' la **dimensione del rischio per operazione**: a 0,1 lotto = 1.000 USD; per stare a 0,65% di 100k (650 USD) servirebbe **0,065 lotti**, e l'EA ha **lotto fisso, non %**. Il nostro involucro (rischio %, Guardian, cap C1 al 3,25%) **non si puo' applicare a un `.ex5`** se non governando il lotto dall'esterno: e' una riscrittura del lato che ci interessa meno.

### 9.3 Doppione o buco?
- **[INFERITO]** Se il motore e' media veloce 22 + breakout: **e' una famiglia che abbiamo gia'** (GBA breakout-canale + EMA sull'oro; `EMA200` sui indici). Un solo dato di meccanica (FastMA 22) non e' un meccanismo nuovo.
- Il buco "short / laterale / crollo" non e' riempito: l'unico utente che ne parla vede **solo BUY in 30 giorni** (#40, [DICHIARATO DA TERZI]) e la curva del tester coincide col rialzo dell'oro.

---

## 10. VERDETTO E PROPOSTA

**SCARTATO.** Motivi con i numeri:
1. **Niente sorgente, niente scaricabile dalla sua pagina oggi**: la regola di casa e' "non posso escludere un martingala che non posso leggere".
2. **Tesi non scrivibile** (la scheda lo prevede: "se non la sai scrivere: SCARTO").
3. **Lotto fisso**, SL ~97 USD, TP 5.500 USD: **2,47x il saldo** nella schermata dell'autore.
4. **Tre testimonianze pubbliche di conti o backtest azzerati** (ZN -273,79 in blocco e "carnage"; McFab 33k->0; Jamal -600 USD su una sola operazione), mai smentite dall'autore, che risponde a tutte con la vendita del "set premium".
5. **Venditore**: interdetto dalla vendita (motivo non dichiarato), tre nomi, secondo account con lo stesso testo e 8 giorni di distanza, vendita fuori piattaforma di codice e copia-conti con profit sharing.

**Meccanismo nuovo da riprodurre: NESSUNO.** Non propongo nessun file prova: un file prova senza meccanismo sarebbe "parametri a caso", che la regola del 19/08 vieta. La sola cosa nominabile (FastMA 22 + filtro `Wednesday`) e' generica e non e' una tesi.

**Se Claudio vuole comunque chiudere la domanda "e' davvero rotto?" a costo quasi zero** (non e' una proposta di priorita': GBA R2 e le sedie vengono prima):
- *Cosa*: scaricare **dal terminale MT5 del PC di backtest `50504400`** (cartella `C:\MT5_Backtest`; **non il VPS**, regola del 21/09) la scheda **gratuita `188393` "XAU 1 Minute"** (l'unica con il blocco Download), con il **suo** account mql5, e leggere **la scheda Input** del tester, **zero passate**: da li' escono **elenco e default reali** (e si vede se `StopLossPips`/`TakeProfitPips` sono ancora 10010/550010 e se esiste un input di rischio %).
- *Costo*: circa 10-15 minuti di Claudio, nessuna passata. **Spesa: zero.** Nessuna decompilazione.
- *Attesa scritta prima*: input e default uguali a 5.1 (lotto fisso, SL ~100 USD, TP ~5.500 USD, nessun input di rischio %). *Alternativa che cambierebbe il verdetto*: un input di rischio % e uno stop in ATR o in prezzo ragionevole. In quel caso il passo successivo sarebbe **una sola passata a tick reali su XAUUSD** per l'audit a scatola nera (successione dei lotti, posizioni aggiunte contro il prezzo, presenza dello SL), **non** una griglia.
- **Non sara' mai rifinibile** (niente sorgente) e per l'acquisto dei suoi prodotti a pagamento vale il solo `CANCELLO_ACQUISTI_EA.md`: **non lo propongo**.

**Certificato di morte (regola del 09/09)**: questo e' uno **SCARTO DI SETACCIO, non un "morto per backtest"**: non c'e' PF misurato da noi. Lo scrivo cosi' perche' il certificato richiede PF, n, DD, gestione dell'uscita, simboli gemelli e TF, e **nessuno e' misurabile** senza il `.ex5`. Verdetto corretto: **"scartato per setaccio e per tesi assente; NON ANCORA MISURATO in senso di imbuto"**. La via piu' corta al numero e' quella del paragrafo sopra (Input + 1 passata), da fare solo se Claudio lo vuole.

---

## 11. COSA NON HO POTUTO VERIFICARE

1. **Il codice, gli input reali, i default completi**: niente `.ex5`, niente sorgente. Gli unici input visti sono **7** (par. 5.1), di una versione **1.01**; la v1.2 e' diversa e non so quanto.
2. **Se la scheda e' scaricabile oggi dal terminale**: non ho un terminale MT5 loggato. Ho solo la differenza fra le due pagine e i commenti del 6-7/10.
3. **Il motivo del divieto**: non dichiarato da nessuno nelle fonti pubbliche. Non ho letto il regolamento del Market sui secondi account.
4. **Che il motore di "XAU 1 Minute" sia lo stesso di "Gold Scalper PRO"**: stesso testo, stessa dichiarazione di rinomina, nessuna prova sul codice.
5. **Se il lotto x10 del caso ZN sia dell'EA o dell'utente**, e con quali input; l'immagine mostra solo lo storico.
6. **Le due schermate dell'autore** (equity di tester e pannello) sono **materiale di marketing**: nessuna statistica, nessun modello di tick, nessun costo; il grafico non mostra il deposito iniziale (asse 923-23.010, partenza non leggibile).
7. **La challenge FTMO "passata" di alou131**: non verificabile (FTMO bloccato dal proxy, nessun certificato).
8. **Algo Forge (`forge.mql5.io/nagart`)**: 403 al CONNECT, non so cosa contenga. **GitHub**: ricerca non disponibile da questa sessione; la ricerca web non ha trovato nulla a nome dell'autore, ma **non e' una prova di assenza**.
9. **Le tab "Reviews" come testo completo**: ho il testo delle 11 recensioni e le valutazioni da dati strutturati (ratingCount 8 nei metadati contro "11" in pagina: non spiegato).
10. **Nessuna demo** lanciata, nessun backtest nostro: **non esiste nessun numero di casa su questo EA**.

---

## 12. LA DOMANDA A CUI IL PRIMO (EVENTUALE) TEST DEVE RISPONDERE

> *"L'EA gratuito `XAU 1 Minute` (stesso testo di Gold Scalper PRO) espone, nella scheda Input del tester, un input di rischio percentuale e uno stop dell'ordine di 10 USD, oppure ha lotto fisso, SL = 10010 e TP = 550010 come nello screenshot del 05/2026? E, se esegue 1 passata a tick reali su XAUUSD con il nostro feed, apre posizioni aggiuntive contro il prezzo con lotto crescente?"*

Se la risposta e' "lotto fisso, SL 10010, TP 550010, nessun input di rischio" (la mia attesa, scritta ora), **il caso e' chiuso senza una sola passata**.

---

## 13. FONTI (tutte aperte il 10/10/2026)

- Scheda: https://www.mql5.com/en/market/product/178437 · commenti: https://www.mql5.com/en/market/product/178437/comments, /comments/page2, /comments/page3 · novita': https://www.mql5.com/en/market/product/178437/updates
- Profilo autore: https://www.mql5.com/en/users/nagart · pubblicazioni: https://www.mql5.com/en/users/nagart/publications (**"No publications"**)
- Schede dell'altro account: https://www.mql5.com/en/market/product/188393 (XAU 1 Minute, gratuita) · https://www.mql5.com/en/market/product/194048 (XAUUSD 1 Minute Premium, 189,99 USD) · https://www.mql5.com/en/market/product/177351 (Am Gold Master MT5, 209 USD, stessa dicitura "debarred") · https://www.mql5.com/en/market/product/190981 (Aurevia BTCUSD, 99,99 USD)
- Signal gemelli: https://www.mql5.com/en/signals/2391311 · https://www.mql5.com/en/signals/2391665
- Immagini pubbliche: https://c.mql5.com/31/2176/EA.png · https://c.mql5.com/31/2234/ScreenHunter_375.png · https://c.mql5.com/31/2053/gold-scalper-for-mt5-ea-screen-9356.png · https://c.mql5.com/31/2050/gold-scalper-for-mt5-ea-screen-4512.png · https://c.mql5.com/31/2449/Scr.jpg (browser dell'utente Tosomeone4518 che mostra la stessa scheda con "Author debarred from selling products")
- Interni al repo: `report/GBA_R2_PIANO_2026-10-10.md` · `docs/PER_GEMINI_GBA_ORO_2026-10-10.md` · `report/ORO_1530_DISEGNO_MISURA_2026-09-10.md` r.160 (XAUUSD Digits 2, Point 0,01) · `backtest_pipeline/caccia_strategie/CANCELLO_ACQUISTI_EA.md` · `report/CACCIA_MARKET_2026-08-23.md` (stessa tecnica: signal, due colonne di DD, test a taglia vera)
