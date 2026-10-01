# Scheda della live di Paolo del 01/10/2026 (sera, ore 21:30)

Mandato di Claudio, 01/10/2026: analizzare gli EA dove non sono mai stati analizzati e cercare ovunque parametri e meccanismi.
Contesto del giorno: challenge FTMO nostra persa il 30/09; Free Trial 160K in corso, oggi -3,9% in un giorno; si guardano H4+M3 (confluenza e ingresso), la EMA200 (rimbalzo: forma forte esclusa su DAX/oro M5-H1) e lo schema top-down.

**Sola lettura.** Nessun preset, sedia, conto, terminale o EA toccato; nessun round lanciato; nessuna riga di lancio. Tutte le "proposte di misura" sono specifiche, non file prova: ognuna passa dal cancello prima di esistere, e i round girano solo sul PC di backtest.

Etichette di casa: [TRASCRITTO] (c'e' scritto, cito con la riga) · [INFERITO] (lo deduco, dico da cosa) · [INCERTO] · [DICHIARATO, NON verificato] (numero del relatore: si registra, non pesa) · [MISURATO] (numero nostro, con il file) · [DERIVATO] (calcolo mio da numeri scritti, formula nel testo) · [NON MISURATO].
I numeri di riga sono le righe di `data/trascrizioni/LIVE_PAOLO_2026-10-01.txt` (532 righe, lette per intero).

---

## 0. LE SEI RIGHE CHE CONTANO

1. **L'unica EMA200 di cui Paolo parla e' quella D1, usata come linea orizzontale su un grafico M5** (r.21, 27, 31: "metti una linea sulla media 200"; il DAX "ha aperto molto vicino alla media 200" in D1). E' esattamente la lettura che la misura del 01/10 dichiara NON coperta (`report/EMA200_RIMBALZO_MISURA_2026-10-01.md` sez. 0-bis, riga "EMA200 di un TF SUPERIORE guardata su un grafico piu' basso": **NO**). Misurarla costa **zero passate di tester** (Python sulla cache gia' scaricata). Proposta M1.
2. **Oggi, sul DAX, la sua spiegazione e la nostra perdita coincidono nel lato**: lui dice che il prezzo e' tornato indietro dalla EMA200 D1 e che entrare short "di fronte a un ostacolo" e' entrare "in un punto di svantaggio" (r.27-29). Nostro, [MISURATO] `report/TRIAL_GIORNO1_STOP_DAX_2026-10-01.md`: 770411 short stop -3.292,52 (09:59-10:06 server FTMO) e un secondo short DAX Apertura (candidato 770105) -3.110,48 (11:13-13:36). Il nostro filtro "ostacolo" (`SRBlocked`, opt-in, spento: `ABTG_Apertura_3Ingressi.mq5` r.380, r.2095-2139) conosce **PDH/PDL e numeri tondi, non la EMA200 D1**; e 770105 ha EMA/Supertrend/correlazione tutti spenti nel preset FTMO (r.304-313). E' un'ipotesi con n=2 giorni: **non e' un'evidenza, e' il motivo della misura M2.**
3. **Nessuna bandiera rossa classica**: zero martingala, zero griglia, zero recovery, zero trucchi anti-prop, zero prop nominate. Una sola frase ambigua sullo stop (r.179, sez. 8) da chiarire con Claudio.
4. **Il parziale + stop in pari + trailing strutturale (HA/VWAP/Supertrend) e' ancora la sua ricetta**; il target fisso "30-40 punti" sull'ORB pomeridiano (r.87) e' una geometria **nuova** rispetto al 22/09 (1:1): con lo stop sul lato opposto del box, il conto dice che il bersaglio a 30-40 punti pareggia solo oltre ~80% di vincite (sez. 11, M4) - ed e' lo stesso numero che un random walk da' gia' da solo.
5. **H4+M3**: in questa live **M3 non compare mai** (zero occorrenze). La cascata e' D1 (marea) -> H4 (conferma) -> H1 -> M15 (r.447-461) e "conta D1" (r.449). Il nostro `ABTG_DAX_M3` (H4 bias + M3 trigger, ADX>=25, Supertrend 3,5) **non ha mai avuto un CSV** (`REGISTRO_TEST.md` r.123, r.226) ed e' la traduzione in EA piu' vicina allo schema che Claudio guarda oggi.
6. **Domani 02/10 e' giorno di NFP** (Paolo, r.299-315: "l'ordine non si fa", solo scalping): nel repo `mql5/Files/abtg_news.csv` ha **due righe di ottobre** (FOMC 28/10, ECB 29/10) e **nessuna riga NFP del 02/10** [MISURATO, grep]; e nei preset FTMO delle cinque sedie indice `InpUseNewsFilter=false` [MISURATO, grep sui cinque preset]. Non e' una decisione: e' una domanda (sez. 14, D7).

---

## 1. INTESTAZIONE

```
FILE              data/trascrizioni/LIVE_PAOLO_2026-10-01.txt  (TurboScribe, 532 righe, ~67 kB)
RELATORE/CANALE   Paolo (docente del corso, gia' citato nel repo). Nel testo: gli allievi fanno domande;
                  l'altro docente (Emiliano) e' citato di passaggio (r.173, r.445).
OGGETTO           (A) r.1-203  revisione di un ORB sul DAX preso da un allievo la mattina del 01/10 +
                      commento di Paolo alle proprie operazioni del giorno (EMA200 D1, ORB, EA);
                  (B) r.205-279 avvio del ciclo di 24 live (percorso didattico, diario, obiettivi di reddito);
                  (C) r.281-355 lezione: aperture, NFP di domani, volatilita' (ADR), VWAP/value area;
                  (D) r.357-375 ADR e correlazioni DAX/Nikkei/S&P/Dow;
                  (E) r.377-435 composizione degli indici, correlazioni fra operazioni, Russell;
                  (F) r.437-481 ORB pomeridiano e perche' non su S&P+Nasdaq insieme; cascata top-down D1/H4/H1;
                  (G) r.483-533 conversione pip/euro, indicatori promessi (RSI divergence, Multi-M, Heikin-Ashi).
```

### Ricostruzioni di ascolto (tutte [INFERITO]: dico da cosa)

| Testo TurboScribe | Lo leggo come | Da cosa |
|---|---|---|
| Orba / Orbe | ORB (Opening Range Breakout) | contesto r.7, 35, 169 |
| Don Jones / Dan Jones / Air Down Jones | Dow Jones (e "Air Down Jones" = ORB sul Dow, r.151) | r.69, 85; r.151 e' ambiguo |
| standard impulse | S&P 500 (Standard & Poor's) | r.365 poi r.379 "Standard & Poor's rappresenta le 500 aziende" |
| Japan | Nikkei 225 | r.73-77 "il Nikkei" |
| buvà / VWAP | VWAP | r.97 "ho levato la 50 perche' ho messo il buva'", r.143 "stop su VWAP" |
| DX / ADX | ADX ("rosso sopra i 25") | r.113-117 e r.205 "ADX devi settarlo" |
| Akenashi / Ekenensi (e "achinacce" nella live del 22/09) | Heikin-Ashi | r.139, 527 |
| non fan parallel | Non-Farm Payrolls | r.299-305 |
| AirOSD / EUR-ISD | EURUSD | r.321, 341, 411 |
| marea | il bias di fondo D1 (parola di Paolo) | r.27, 449 |
| ricrociamento / ricarciamento | ritracciamento o retest | r.29, 347; [INCERTO] quale dei due |
| terza banda della "diversita' di standard" | banda a 3 deviazioni (Bollinger multi-banda) | r.345, 355; [INCERTO] se e' Bollinger o un indicatore a tre bande suo |
| "Triangolo Estretto Index"/TSI | [INCERTO] (forse un indice di forza) | r.61: il testo non e' ricostruibile |
| "Mataf" | strumento online di correlazioni | r.405 |
| "Terry New / Amici 5" | [INCERTO] non ricostruibile | r.143 |
| "Il terzo mi e' andato in drawdown. Mi e' arrivato qua a Suncina" | [INCERTO] non ricostruibile | r.137 |
| "Don Jones ha aperto stamattina piu' 3,3 per cento" | **[INCERTO]**: nella frase seguente "lo standard impulse l'ha seguito il Nikkei" e r.79 "Qui ha fatto tre giorni di rialzo": probabilmente e' il **Nikkei** a +3,3%, non il Dow | r.71-79. Un Dow a +3,3% in apertura e' implausibile; non lo uso |
| "time forward" | [INCERTO] (forse "pendenti/ordine piazzato e vado via") | r.339: "strategie che piazzi l'ordine e te ne vai" |

### Fusi orari

Paolo non dichiara il fuso. Dalla scheda del 22/09 (`report/LIVE_PAOLO_2026-09-22_SCHEDA.md`, sez. 1): **a voce parla in ora italiana, nel pannello digita ora server**. Qui: "alle due e mezza" per l'NFP (r.305) = 14:30 italiane [INFERITO: l'NFP esce alle 08:30 ET = 14:30 CEST]; "tornato a casa alle tre e mezzo" (r.339) = 15:30 IT, apertura US [INFERITO]; "le 9 e le 15.30" (r.285) = ora italiana. "Verso le 8 e mezzo" per il taglio del Supertrend (r.41) e "domattina alle 8" (r.463) = **[INCERTO]** (potrebbero essere ora server = 09:30 / 09:00 IT, oppure italiana pre-apertura). **Non converto nulla di incerto.** Promemoria nostro: BCM = IT-1 fino al 25/10 (poi UTC+1 fisso), FTMO = IT+1.

---

## 2. PARAMETRI CON VALORE (ogni numero, con la riga)

| # | Parametro | Valore | Citazione | Etichetta |
|---|---|---|---|---|
| V1 | ORB, **conferma d'ingresso** | candela che **apre fuori e chiude fuori**; la candela successiva e' "stop molto svantaggioso" | r.39 "La regola e' candela che apre fuori, candela che chiude fuori. Pertanto, se prendi la candela successiva sei ancora in una posizione di stop molto svantaggiosa" | [TRASCRITTO] (conferma la regola del 22/09, riga gia' in repo) |
| V2 | ORB TF | **M5** | r.35 "si fa in M5 l'orb" | [TRASCRITTO] |
| V3 | ORB DAX: orario | **mattina**; il pomeriggio sul DAX l'ha abbandonato | r.81 "faccio la mattina l'orb sul DAX e prima lo facevo anche il pomeriggio" | [TRASCRITTO] |
| V4 | ORB pomeriggio: simboli | **Dow Jones o Nasdaq** (S&P e Nasdaq insieme = "lo stesso strumento", r.443) | r.83 | [TRASCRITTO] |
| V5 | **Target** ORB pomeridiano | **fisso 30-40 punti**, poi **stop in pari** | r.87 "Take Profit lo faccio sempre 30-40 punti e poi porto lo stop in pari" | [TRASCRITTO chiaro]. Non dice se il 30-40 e' uscita piena o parziale |
| V6 | Taglia dell'operazione Dow vista oggi | **0,2 lotti = "8,50 euro"** | r.85-87 "Questi piccoli 0,2 sono 8,50 euro" | [TRASCRITTO dubbio]: non dice se per punto o totale; non ricavo i punti |
| V7 | EMA200 | **D1**, come **linea** sul grafico basso; "punto di risposta"; il prezzo "rimbalza subito e torna indietro" | r.21, r.27-31 | [TRASCRITTO] |
| V8 | EMA200, ordini | **un ordine prima e un ordine dopo** la media ("un po' fuori e un po' torna indietro") | r.21 | [TRASCRITTO] |
| V9 | EMA200, **ordine pre-piazzato** | **la sera prima**, lasciato sul grafico; scattato in mattinata; **un solo ordine** invece di due | r.131 "Era un ordine che avevo posizionato ieri sera"; r.135 "avrei dovuto mettere un altro ordine ... Non l'ho messo" | [TRASCRITTO] |
| V10 | EMA200, **attesa** | "devi aspettare, questa e' una pratica in D1"; la chiusura D1 decide ("chiude in D1 a fine giornata sotto") | r.23-25 | [TRASCRITTO] |
| V11 | Supertrend | **"basta il terzo livello"** (indicatore a tre linee) | r.45 | [TRASCRITTO]. I parametri 3,5/10 sono quelli gia' in repo da lives precedenti (25/08), **non dettati qui** |
| V12 | Medie sul grafico pomeridiano | **9 e 21**; la 50 tolta e **sostituita dal VWAP** perche' "per 50 il buva' non cambia moltissimo" | r.95-97, 103 | [TRASCRITTO]; "buva' = VWAP" e' [INFERITO] |
| V13 | ADX | **colorato in rosso sopra 25**; indicatore da lui distribuito e "gia' settato" (periodo non dettato) | r.117 "tutti rossi sopra i 25"; r.205 | [TRASCRITTO] (soglia) · [NON DETTATO] (periodo) |
| V14 | Parziale | quando le **Heikin-Ashi diventano arancioni** (da telefono) | r.139 | [TRASCRITTO] |
| V15 | Trailing | stop **sotto il VWAP**; **uscita alla rottura del Supertrend molto inclinato** + eventuale controingresso | r.143-145 | [TRASCRITTO] |
| V16 | Orari importanti | **09:00 e 15:30** (IT); la borsa USA "vera e propria" **14:30** nelle settimane di disallineamento d'ora legale ("fra la fine di ottobre e l'inizio di aprile", frase confusa) | r.285 | [TRASCRITTO dubbio] (l'orario USA e' il tema dell'orologio d'inverno gia' in repo: `report/OROLOGIO_BCM_2026-09-24.md`) |
| V17 | Giorno di NFP (domani) | **ORB non si fa**; mattina "senza fare niente"; solo scalping a "10 punti"; nessuna operazione di posizione | r.299, 315 | [TRASCRITTO] |
| V18 | News: quando entra | **dopo** il rilascio, guardando i segnali (VWAP, medie inclinate); **non piu' "in uscita"/prima** | r.321 "io non la faccio piu' in uscita, io la faccio dopo il rilascio della notizia, eventualmente" | [TRASCRITTO]; "in uscita" = prima della notizia [INFERITO] |
| V19 | M1 sul giorno di notizia | bande a 3 livelli: **entrare sulla seconda banda e uscire sulla prima**; **banda piatta = movimento finito**; in M1 "troppo rumore": salire a **M5** | r.345-355 | [TRASCRITTO] |
| V20 | ADR | strumento "Range Analysis": finestra di default **10** (settimane), alternative **4 / 1 / 50**; "normalmente si misura le 50 settimane"; DAX: **~290 punti** (media 10 sett.), massimo giornaliero **530** | r.357-361, 485 | [TRASCRITTO]; "settimane" [INFERITO] da "10 settimane" r.357; numeri [DICHIARATO, NON verificato] |
| V21 | Correlazioni | DAX-S&P **46%**, DAX-Nikkei **39%**, Nikkei-S&P **79%**, Dow "completamente scorrelato" | r.365-367 | [DICHIARATO, NON verificato]; cambiano nel tempo (r.367) |
| V22 | Cascata di TF (DAX) | **D1 (marea) -> H4 (conferma) -> H1 -> M15**; "se D1 long e H4 short = ritracciamento, **conta D1**"; i livelli si tracciano a mano su H4 e poi si confrontano con l'indicatore | r.371, 447-461 | [TRASCRITTO] |
| V23 | Correlazione fra operazioni | **mai due operazioni sulla stessa scommessa**: EURUSD long + USDJPY short, o EURUSD + USDCAD ("correlazione inversa di un 95%") -> se ne fa una (la piu' solida tecnicamente) | r.341, 407-423 | [TRASCRITTO]; il 95% [DICHIARATO] |
| V24 | Obiettivo di reddito (didattico) | **50 euro/giorno = 1.000 al mese**; poi 1.200, poi 1.500; conto a 5.000 e poi prelievi | r.271-275 | [DICHIARATO]; e' un percorso formativo, non un parametro di rischio |
| V25 | Piano del ciclo | **24 live settimanali** | r.213 | [TRASCRITTO] |
| V26 | Conversioni pip/euro | EURUSD 8,89; EURGBP 11,73; EURJPY 5,82; **oro: 10 punti con 1 lotto = 790 euro** | r.495-509 | [TRASCRITTO dubbio]: 8,89 implica un cambio ~1,125; il 790 dell'oro non e' verificabile qui. **Non li uso** |

---

## 3. MECCANISMI (come li descrive, senza abbellire)

### 3.1 Ingresso
- **ORB su M5, conferma "apre fuori e chiude fuori"** (V1). Il suo errore tipico da correggere nell'allievo: entrare **in corsa**, prima della chiusura della candela, "per paura che uscisse troppo" (r.13): "stop sfavorevole" (r.39).
- **Tre modi di applicare la stessa strategia** (r.119-121): *rigoroso* (aspettare la candela che apre e chiude fuori), *aggressivo* (entrare prima), *intelligente* = "**a rimbalzo sul vuoto**", cioe' sul ritorno dentro un imbalance, non sull'estensione. Non dice in cifre quale offset/stop abbiano.
- **Entrare su un ritorno, non su un'estensione, davanti a un ostacolo**: r.29 "Se si entra di fronte ad un ostacolo bisogna entrare in un punto di vantaggio, non di svantaggio. Pertanto non su una estensione, ma su un ricrociamento."
- **Volume**: la rottura del mattino "e' sceso senza volumi" (r.33) -> lo usa come motivo di diffidenza; nessuna soglia.
- **Imbalance grosso sulla candela di rottura** (r.37): "c'e' un grosso imbalance" -> tende a essere ritestato (r.109: "qui andava a retestare, quando usciva entravi su questa").

### 3.2 Gestione dopo l'ingresso
- Parziale, poi stop in pari, poi stop in profit strutturale (VWAP / Supertrend), uscita a mano alla rottura del Supertrend inclinato (r.139-145).
- Target fisso 30-40 punti + stop in pari sull'ORB Dow/Nasdaq (r.87).
- Si arrabbia con se stesso per non aver messo il **secondo ordine** (r.135) e per non essere uscito/invertito alla rottura del Supertrend (r.145-147).

### 3.3 Protezioni e **quando NON operare** (la parte che ci serve di piu')
| Quando NON si opera | Citazione |
|---|---|
| **Contro un ostacolo forte** a meno di un punto di vantaggio (qui: EMA200 D1 vicina all'apertura) | r.27-29 |
| **Vicino all'apertura**: "il mio piano di trading non prevede di entrare in prossimita' dell'apertura del mercato" (anche se perde ingressi buoni: "Ma sai, questa non ti devi mortificare") | r.51, 235 |
| **Giorno di NFP**: compressione, "pronto a esplodere": niente ORB, niente posizione, niente range ("il rischio e' troppo alto, non si lavora") | r.299-315 |
| **Mercati guida discordi**: se Nikkei long, S&P short, DAX indeciso = "tenata difficile da tradare" | r.373 |
| **Due operazioni sulla stessa scommessa** (correlazione) | r.407-423 |
| "**Entri solo se c'e' valore**" ("in un mese ci sono 20 giorni, vale la pena rischiare?") | r.319 |
| "Bisogna mettere in conto che un giorno l'operazione non si da'" (anti-meccanicita') | r.49 |
| Mai passare al reale finche' non si e' "estremamente positivi" in demo | r.229-231 |

- **Dopo uno stop**: **non ci sono regole di pausa, cap giornaliero o riduzione di rischio in questa live.** L'unico atteggiamento dichiarato e' didattico: "Lo stop loss fa parte del gioco ... abbiamo seguito il nostro piano" (r.233), "ogni perdita in demo deve essere studiata" (r.231). **Tetto giornaliero: [NON DICHIARATO]. Rischio per trade: [NON DICHIARATO]** (solo l'esempio 0,2 lotti, V6).
- **Stop sempre presente** come regola didattica: "La stragrande maggioranza di voi entra senza mettere lo stop" (r.249, riferito ai risultati della **challenge del corso** che gli allievi gli mandano per mail, non a una prop) e presenta un pannello che **calcola il lotto dal rischio** quando si posiziona l'ordine (r.251-259, non ancora distribuito: "ci devo lavorare ancora").

### 3.4 Il suo metodo e' dichiaratamente non meccanico
- r.47 "Non dovete farlo in forma meccanica."
- r.89 "se fosse meccanico tutti faremmo degli Expert Advisor e perche' gli Expert Advisor non funzionano? **Non funzionano perche' c'e' sempre da guardare un contesto.**"
- ma **ha un EA suo** che opera da solo ("sto sperimentando un settaggio", r.149) e lo cita come una delle "due operazioni" del pomeriggio (r.339).

---

## 4. INDICATORI E COME LI USA

| Indicatore | Uso dichiarato in questa live | Riga |
|---|---|---|
| **EMA200 D1** | livello "di risposta"; si traccia una linea sul grafico M5; ordine limit prima e dopo; falso breakout se la tocca "di testa" e rompe sopra e torna giu'; chiusura D1 sotto = tende a ritestare e proseguire | r.21-31, 65-67, 479 |
| **Supertrend (3o livello)** | segnale di taglio ("verso le 8 e mezzo"); uscita alla rottura quando e' molto inclinato; "taglio del Supertrend" come contesto | r.41-45, 143-145 |
| **VWAP** | sostituisce la EMA50 sul grafico; stop sotto il VWAP; "sotto il VWAP" = contesto short | r.97, 103, 107, 143 |
| **EMA 9 e 21** | restano sul grafico del pomeriggio | r.95-97 |
| **ADX (rosso >25)** | forza del trend; ingressi con ADX rosso sono "validi" | r.113-117, 205 |
| **Heikin-Ashi** | segnale di parziale/uscita (arancione) | r.139 |
| **Deviazione standard (indicatore suo)** | "se domani la deviazione standard cresce e' una conferma" di prosecuzione su D1 | r.69 |
| **Bande a 3 livelli (M1)** | inclinate+aperte = momentum, non andare contro; piatte = movimento finito; entrata sulla 2a, uscita sulla 1a | r.345-355 |
| **Value area / POC / volume profile** | su NFP: lo spostamento della value area = "accettazione" del nuovo prezzo; forma a "B" della distribuzione | r.323-335 (di fatto lezione, nessuna soglia) |
| **ADR (Range Analysis)** | misura la volatilita' media e quanto e' lontano un livello rispetto al movimento giornaliero ("molto superiore alla velocita' giornaliera" = livello lontano) | r.357-361, 453 |
| **Correlazioni (Mataf, indicatore proprio)** | catena Nikkei -> S&P -> DAX al mattino | r.365-375, 405-419 |
| **Livelli a mano + indicatore di liquidita'** | tracciare prima i livelli H4/H1 e poi confrontarli con l'indicatore | r.451-461 |
| **Bollinger** | **non citato** in questa live (zero occorrenze della parola) | - |
| **M3** | **non citato** (zero occorrenze) | - |

---

## 5. REGOLE PROP CITATE

**Nessuna.** Zero occorrenze di FTMO / prop / funded. La parola "challenge" (r.249) indica la challenge **interna del corso** (gli allievi gli mandano i risultati per mail); [INFERITO] dal contesto "ho risposto a una quindicina o venti mail ... entra senza mettere lo stop" e dalla scheda di Emiliano del 30/09 (`report/SCHEDA_LIVE_EMILIANO_2026-09-30.md`, "consegnare statement a Emiliano e a Paolo"). Niente di prop da copiare, niente da etichettare VIETATO.

---

## 6. NUMERI DI PERFORMANCE DICHIARATI (tutti [DICHIARATO, NON verificato]: si registrano, non pesano)

| Numero | Citazione | Nota |
|---|---|---|
| ORB Dow di oggi "una bella operazione", 0,2 lotti = 8,50 euro | r.85-87 | **non l'ha presa** ("ero in mattina fuori"); e' una lettura a posteriori |
| "Sono andato a profitto col Nasdaq e sono andato in perdita qui. Gli altri giorni sono andato a profitto con l'[ORB] Dow Jones e in perdita col Nasdaq." | r.151 | alternanza Dow/Nasdaq su pochi giorni; n non dichiarato; simbolo di "qui" non dichiarato |
| "quando le faccio vado in stop" (ORB pomeridiano) | r.83 | **[INCERTO]**: letto alla lettera dice che l'ORB pomeridiano va spesso in stop; il resto della frase non lo conferma (continua a consigliarlo). Chiedere conferma a Claudio che lo conosce |
| EMA200 della mattina: parziale + stop in profit, poi stop sotto VWAP; **P/L finale non dichiarato** | r.139-147 | simbolo/ora/esito: **non detti** |
| NFP: "33 pip" di movimento, "un paio di mesi prima ne ha fatti 60", "55 pip con la notizia"; "164 pip" di espansione su M1 | r.305-309, 349 | strumento non dichiarato (probabile EURUSD o USDJPY: [INCERTO]); esempi, non statistiche |
| "99 su 100 il mercato va long" quando Nikkei, S&P e DAX sono long | r.373 | iperbole, **non utilizzabile** |
| "Statisticamente, [l'altro docente] ha verificato che normalmente guida il movimento giornaliero il Dow Jones, il Japan alla mattina ..." | r.445 | attribuzione di seconda mano, nessun numero |
| ADR DAX 290 / massimo 530; correlazioni 46/39/79% | r.357, 365, 485 | vedi V20-V21 |
| Obiettivo 50 euro/giorno | r.271 | e' un obiettivo didattico |

---

## 7. BANDIERE ROSSE

Verifica attiva: ho cercato recovery / raddoppio / martingala / griglia / mediazione / "senza stop" / trucchi anti-prop nell'intero testo.

| Pratica | Verdetto | Prova |
|---|---|---|
| Martingala / aumento dopo la perdita | **ASSENTE** | l'unica occorrenza di "recuperare le perdite" e' tra gli **errori del principiante** (r.229) |
| Griglia / recovery | **ASSENTE** | - |
| Raddoppio | **ASSENTE come tecnica**: "stai raddoppiando i rischi" (r.407) e' l'avvertimento contro **due operazioni correlate** |
| Trucchi per aggirare le prop | **ASSENTI, zero** | nessuna prop nominata (sez. 5) |
| Stop assente | **1 passaggio AMBIGUO** | r.179 "non ho messo lo stop perche' mi immaginavo che scendesse molto". Contesto: parla di un ordine di cui "me lo vado a aspettare" dopo che il prezzo "mi e' andato avanti"; subito prima (r.141) dice di avere lo stop "qua giu' sotto". **[INCERTO]** se si riferisca a un ordine nuovo senza stop. E' l'unico punto della live da chiarire. |
| Ordine lasciato **di notte** sulla EMA200 (r.131, "ordine che avevo posizionato ieri sera") | **bandiera gialla, non rossa** | rischio gap/notizia notturna; nei nostri EA i pendenti hanno scadenza in barre (`InpPendingExpiryBars=6` in `ABTG_EMA200.mq5`, riga sul meccanismo nel referto del 30/09). Divergenza di design, non una colpa |
| **Seconda gamba oltre la media** ("un ordine prima e un ordine dopo") | **da chiarire**: e' una mediazione controllata o aggiunta di rischio? | non dice se il rischio e' **diviso** fra i due ordini (come fa il nostro `ABTG_EMA200`: `riskPct=InpRiskPercent/nOrders`) o **raddoppiato**. Domanda D4 |
| "Gli EA non funzionano perche' c'e' sempre da guardare un contesto" (r.89) | **avvertenza di metodo**, non pericolo | e' una dichiarazione di Paolo; **nessuna misura nostra la conferma o la smentisce**. Va tenuta presente quando si trasforma un suo schema in EA (il contesto D1/H4 e' la parte meccanizzabile; il giudizio "a occhio" no) |
| Esempi su 1-3 giorni, aneddoti | **non evidenza** | sez. 6 |

---

## 8. COSA SUCCEDE NELLE OPERAZIONI MOSTRATE IN DIRETTA

| # | Operazione | Chi | Cosa si vede / si dice | Esito | Righe |
|---|---|---|---|---|---|
| O1 | ORB **DAX**, mattina del 01/10 (BCM) | allievo | box formato; la candela "si sviluppa molto fuori"; **non aspetta la chiusura della seconda candela, entra "in corsa"** con il minimo; stop **sul lato opposto del box** ("stop grande"); il prezzo "si e' girato e e' tornato indietro" | **perdita** [INFERITO da "campanata", "mi e' arrivato in faccia"; lato **short** [INFERITO] da "oggi era tutto short"]; importo non detto | r.1-15, 27-39 |
| O1b | giudizio di Paolo su O1 | Paolo | (1) **non ha guardato il contesto D1**: DAX aperto "molto vicino alla media 200", "sempre punto di risposta"; (2) entrata **su estensione** davanti a un ostacolo; (3) **volumi assenti** ("e' sceso senza volumi"); (4) "imbalance" grosso sulla candela di rottura; Supertrend gia' tagliato prima ("verso le 8 e mezzo" [INCERTO fuso]) -> il movimento era gia' fatto | - | r.15-47 |
| O2 | Long "Golden Cross" sopra EMA200, mattina | allievo | setup "da Golden Cross" lungo, **mancato**; Paolo: non ci si mortifica, "fare un'operazione prima dell'apertura ... non si fa" | non preso | r.49-53 |
| O3 | ORB **Dow** pomeridiano | Paolo (non eseguito) | "una bella operazione"; 0,2 lotti = 8,50 euro; TP 30-40 punti poi pareggio | **vinta a posteriori** [DICHIARATO]; non presa | r.83-87 |
| O4 | ORB su **S&P/Nasdaq** (domanda dell'allievo: candela che rompe, poi la verde, poi riscende) | Paolo (non eseguito: "dal telefonino non ne faccio piu'") | sotto VWAP; medie 9/21 inclinate verso il basso; DX rossa >25; tre modi di entrare (rigoroso/aggressivo/intelligente = rimbalzo sul vuoto) | non presa | r.81, 91-123 |
| O5 | **EMA200 long** del mattino | Paolo | ordine limit **piazzato la sera prima** sulla EMA200 (D1, linea su grafico basso); scattato in mattinata, "sul rimbalzo della media 200"; **un solo ordine** invece di due; poi drawdown; **parziale** su HA arancioni; **stop in profit**; poi stop sotto VWAP; avrebbe dovuto **uscire alla rottura del Supertrend inclinato e girarsi short** | **P/L non dichiarato**; da "stop in profit" [INFERITO] chiusura in leggero utile o pari | r.129-147, 165-183 |
| O6 | Operazione dell'**EA di Paolo** "per conto suo" | EA | "sto sperimentando un settaggio"; profitto col Nasdaq oggi, perdita "qui" [INCERTO su cosa sia "qui"]; altri giorni profitto sul Dow, perdita sul Nasdaq | misto | r.149-151 |
| O7 | Operazioni del pomeriggio | Paolo | "due operazioni, una con l'expert e una in posizione" (tornato a casa alle 15:30 IT) | non dichiarato | r.339 |
| O8 | NFP di due mesi fa (esempio) | Paolo | mercato "congestionato" prima, poi 33/55 pip; value area che si sposta = accettazione; in M1 espansione 164 pip, "la banda si appiattisce = movimento finito"; entrata corretta sul rientro; "da pittore" | esempio, nessun P/L | r.301-355 |

**Che cosa NON si sa di O5 (la piu' rilevante per noi)**: simbolo, TF del grafico, ora di fill, livello esatto, lotti, stop in punti, P/L. Servono le immagini (sez. 11).

**Che cosa e' successo a noi lo stesso giorno sul DAX** [MISURATO, `report/TRIAL_GIORNO1_STOP_DAX_2026-10-01.md`, ore server FTMO = IT+1]: 09:59:01 770411 short a 24.998,25 (sell stop 24.999,04), stop 10:06:32 a 25.067,16, **-3.292,52**; 11:13:13 sell 12,08 lotti a 24.834,96, stop 25.092,04, chiuso 13:36:02 a 25.092,45, **-3.110,48** (commento non espanso: candidato 770105); il prezzo poi e' sceso a 24.853 (controfattuale del referto). Non c'e' modo di sapere da qui se la EMA200 D1 fosse a ~25.0xx: **[NON VERIFICATO]**, domanda D1.

---

## 9. MAPPA SUI NOSTRI EA

Letto per questa mappa: `ABTG_EMA200.mq5` (r.61-65, 308-345), `ABTG_DAX_M3.mq5` (testata e input), `ABTG_Segnali_EMA_BB_ST.mq5` (testata), `ABTG_Apertura_3Ingressi.mq5` (r.288, r.380, r.2086-2139), preset FTMO 770105/770411/ORB Dow trial, `REGISTRO_TEST.md` r.123-126/226/331, `EMA200_RIMBALZO_{STATO_DELLARTE,MISURA}`, `H4_M3_CONFLUENZA_CRITERI`, `TRIAL_GIORNO1_STOP_DAX`, `LIVE_PAOLO_2026-09-22_SCHEDA`, `ANALISI_LIVE_PAOLO_2026-09-29`. **Non letto** (dichiaro): i per-trade delle sedie DAX, `ABTG_SuperWave.mq5`, i risultati di R248a, `ABTG_Bulge.mq5` oltre la testata.

### 9.1 EMA200 (`ABTG_EMA200`, sedia 771531 e gemelli)

| Voce | Paolo (01/10) | Noi | Coincide? |
|---|---|---|---|
| **Quale EMA200** | **D1**, linea su grafico basso (r.21-31) | l'EMA200 **del TF operativo** (H1 per 771531: `InpTF`, r.331 usa `iClose(InpTF)` e `EmaVal(hEma)`) | **NO, e qui sta il buco.** La misura del 01/10 dice espressamente di non coprire "EMA200 di un TF superiore guardata su un grafico piu' basso" |
| **Due ordini** ("uno prima e uno dopo") | si | si: due LIMIT, il 1o a `EMA200 +/- 0,10 ATR` verso il prezzo, il 2o oltre la media a `0,35 ATR` (default; la cella viva 771531 usa O1 0,20 / O2 0,30 secondo il HANDOFF del 30/09), rischio diviso per due gambe | **SI per costruzione** - ma **non e' una fonte indipendente**: il nostro EA ha gia' un filtro "live Paolo" (r.61) e non posso escludere che il disegno nasca dalle sue lezioni. Non lo conto come convergenza |
| **Parziale + pari + trailing** | parziale su HA/EMA, stop in profit, trailing VWAP/ST | parziale 50% su EMA14, pari, trailing EMA14, TP finale 2R (referto 30/09 sez. 1) | **PARENTE** (stesso scopo, riferimenti diversi) |
| **Distanza dalla media** | "ordine troppo vicino alla fine dell'ORB, [l'altro docente] dice che quando siamo troppo vicini lo sfonda" (r.173) | `InpMinDistAtr=0,3` / `InpMaxDistAtr=1,5` + filtro ADR opt-in 0,8x (r.65 `InpAdrDistMax`) | **PARZIALE**: noi **limitiamo** il prezzo a 0,3-1,5 ATR dalla media; lui parla di ordini **sulla** media |
| **Attesa/chiusura D1** | "devi aspettare ... pratica in D1" (r.23) | nessuna attesa della chiusura D1 | **NO** |
| **Forza del rimbalzo** | "rimbalza subito e torna indietro" (r.21) | misura 01/10: forma forte (P >= 0,75) **ESCLUSA** su DAX M5-M15, oro M5-H1 (EMA sul TF di lettura); P 0,403-0,545 | **non conflitto, ma non coperto**: lui parla della EMA200 D1 letta su M5; la misura no |
| **Giornata del 01/10** | DAX: apre vicino alla EMA200 D1, **rimbalza**, poi **chiude sotto** (r.21-25, 65-67); Dow: "ha retestato la media, e' stato rifiutato" (r.189) | - | un giorno, due indici, due esiti opposti sullo stesso livello: e' la definizione di "rimbalzo o sfondamento" **a seconda del criterio**. Aneddoto, non evidenza |

**Le due letture della sua frase, e perche' contano per la misura** (cosa va congelato PRIMA di guardare i numeri): (a) "primo tocco" della EMA200 D1 con barre M5; (b) rimbalzo "a ordine limit sulla linea" (cioe' P(fill) e P(ritorno) sono eventi diversi da "tocco d'ombra dopo 20 barre pulite"). La misura del 01/10 ha congelato solo (a'): ombra, 20 barre pulite, TF di lettura = TF della EMA.

### 9.2 Filtro ADR (`InpUseAdrFilter`, `InpAdrDays=50`, `InpAdrDistMax=0,8`)

- **Coincide**: la finestra di default dello strumento di Paolo e' **10 settimane** (r.357) = **~50 giorni di borsa** = il nostro `InpAdrDays=50` [INFERITO: 10 x 5 = 50]. La stessa live dice che "normalmente si misura le 50 settimane" (~250 giorni) e che nel pannello si possono scrivere 4, 1, 50: **la sensibilita' alla finestra non e' mai stata messa ad asse** [NON MISURATO; non ho cercato in ogni CSV: dichiaro solo che nei CSV letti dal referto del 30/09 non compare].
- **Non c'e' in questa live il numero 0,8x ADR**: era di una live precedente (commento r.65: "guida Paolo ~0,8x ADR"). Qui l'ADR serve a dire quanto e' **lontano un livello** rispetto al movimento giornaliero (r.453), **la stessa funzione "raggiungibilita'" gia' annotata il 03/09** (`ANALISI_LIVE_PAOLO_2026-09-03.md`), non una distanza prezzo-media.
- **Gia' misurato in casa**: GBPJPY **peggiora** (PF 1,224 -> 1,167; `LETTURA_ROUND_CORTI_C_2026-09-28.md` sez. 7.4); XAUUSD **indizio** (PF 1,309 -> 1,559, DD 6,07 -> 4,63, banco rosso; `EMA200_RIMBALZO_STATO_DELLARTE_2026-09-30.md` r.142). Un asse in piu' (finestra 10 vs 50 settimane) e' una misura **piccola** se si rifa' R267e con la finestra; costo: non stimato qui.

### 9.3 H4 + M3 e lo schema top-down

| Voce | Paolo (01/10) | Noi | Coincide? |
|---|---|---|---|
| **Gerarchia** | **D1 decide** ("conta D1"), H4 conferma, poi H1/M15 (r.447-449) | `ABTG_DAX_M3`: **H4** e' il bias (Supertrend 3,5/10 + EMA200 H4 + ADX H4 >= 25), **M3** il trigger (rottura del Supertrend M3), dalle 08:30 server; H4 non direzionale = niente | **PARZIALE**: noi non abbiamo D1 nel bias. In questa live il D1 viene **prima** dell'H4 |
| **ADX >= 25** | soglia 25 | `InpAdxMin=25` | **SI** (stessa soglia) |
| **Supertrend "terzo livello"** | si (r.45) | `InpStMult=3,5`, ATR 10 | **COMPATIBILE**: i parametri non sono dettati qui |
| **M3** | **non citato** | trigger | **NON TESTIMONIATO da questa live** |
| **Ingresso su ritorno** | "non su un'estensione, ma su un ritracciamento/retest" (r.29) | `InpEntryMode = M3E_ENTRAMBE` (rottura + continuazione/ritracciamento) | **SI** a livello di meccanismo (il ritracciamento c'e' come modo) |
| **Livelli a mano** | prima i livelli H4/H1 poi l'indicatore | non automatizzato (`ABTG_DAX_M3` dichiara fuori VWAP/POC/S&D) | **gap noto** |
| **Stato misura** | - | **`ABTG_DAX_M3` mai misurato**: nessun CSV in tutta la storia git (`REGISTRO_TEST.md` r.123 e r.226, "NON ANCORA MISURATO, zero punti su cinque"); `InpBiasTF`/`InpTriggerTF` mai mossi | - |

Collegamento con la misura in corso: `report/H4_M3_CONFLUENZA_CRITERI_2026-10-01.md` e' un **event study** della confluenza della dashboard v4.1 (D1 = timing M3 aggiunge qualcosa all'H4? D2 = il filtro H4 aggiunge qualcosa all'M3? D3 = costo). **Non include il D1.** Aggiungere "D1 decide" e' un'**ipotesi nuova** che non puo' essere letta sugli stessi numeri come se fosse prevista: va scritta con criteri propri e **prima** di guardare (vedi M3 sez. 11).

### 9.4 `Segnali EMA BB ST` (`ABTG_Segnali_EMA_BB_ST.mq5`)

Le condizioni dell'indicatore: (a) espansione BB, (b) incrocio EMA9/EMA21 entro 3 barre, (c) pendenza di entrambe, (d) flip del Supertrend entro 3 barre.
- **Coincidenza di lettura** con cio' che Paolo dice delle bande ("inclinate e che si aprono" = momentum, r.345; "si appiattisce = movimento finito", r.351) -> **(a)+(c)**.
- **Divergenza**: lui lo usa come **contesto di non-controtendenza** e come **uscita**, non come trigger; entra sul ritorno (r.29, 109). L'indicatore genera il segnale **sull'incrocio**, cioe' dove lui direbbe "non su un'estensione".
- **Da chiedere**: se le "tre bande" sono Bollinger con deviazioni 1/2/3 o un suo indicatore (il nostro ha una sola banda: [NON VERIFICATO sull'input]).

### 9.5 Aperture DAX/Dow e ORB (770101 / 770105 / 770411 / 770611 / ORB Dow trial)

| Voce | Paolo | Noi | Coincide? |
|---|---|---|---|
| **Filtro "ostacolo"** | EMA200 D1 davanti = niente breakout su estensione | `SRBlocked`: **PDH/PDL e numeri tondi** (r.2105-2128), opt-in, default `false` (r.380); **la EMA200 non e' tra i livelli** | **NON coperto** |
| **Contesto D1** | marea D1, H4 conferma | 770105 FTMO: `InpUseEmaFilter=false`, `InpUseSupertrend=false`, `InpUseSupertrend3=false`, `InpUseCorrelation=false` | **diverso**: nessun contesto |
| **Catena guida Nikkei -> S&P -> DAX** | "il DAX segue il Nikkei, segue lo S&P"; oggi scorrelato (r.73-75, 191-195, 365-373) | 770411 FTMO: `InpUseCorrelation=true` su `US500.cash`, TF H1, EMA 14/100 (default del motore); **Nikkei assente** | **PARZIALE** (un anello della catena) |
| **ORB Dow trial** (`ABTG_ORB_Ottimizzato_DOW_FTMO_TRIAL.set`, magic 770621, **non ancora attaccato** a 01/10 secondo il HANDOFF) | target fisso 30-40 pt + pari; stop non dichiarato oggi (22/09: lato opposto del box); lati: entrambi (22/09) | `InpSLMode=3` (mezzo range), `InpTPMode=1`, `InpTPRangeMult=1,5`, `InpTP1Pct=0`, `InpAllowShort=false`, `InpUseEma200Filter=true`, `InpMaxRangePct=0,8`, rischio 0,3 | **DIVERSO**: tre geometrie (sua 22/09: 1:1 stop opposto; sua 01/10: TP 30-40 pt; nostra: 1,5x range) |
| **ORB DAX la mattina** | lo fa; "pomeriggio non piu'" | 770101/770105 DAX Apertura (non e' un ORB 15': e' il motore a 3 ingressi) | non confrontabile 1:1 |
| **Conferma "apre fuori/chiude fuori"** | si (V1) | `InpUseCloseConfirm` confronta col **bordo grezzo** non con la linea +10 e non guarda l'apertura (22/09, M4) | **NO**, gia' scritto il 22/09: non lo ripeto |
| **NFP: niente ORB al mattino, entra dopo** | si (V17-V18) | filtro news spento nei 5 preset indice FTMO; CSV senza NFP del 02/10 | **domanda** D7 |

### 9.6 Bulge, SuperWave

- **Bulge**: **niente in questa live** (zero Bollinger/bulge/compressione; la compressione era del 22/09). Nessuna mappa.
- **SuperWave**: non citato per nome. L'uso Supertrend/EMA200/ADX di questa live e' la stessa famiglia di indicatori, ma non ho elementi per una mappa (non ho letto `ABTG_SuperWave.mq5`): dichiaro il buco.

---

## 10. COSA GIA' C'ERA DI PAOLO IN REPO (per non rifare)

| Fonte in repo | Cosa dice | Cosa aggiunge questa live |
|---|---|---|
| `LIVE_PAOLO_2026-09-22_SCHEDA.md` | due ORB (classico 14:30-14:45 srv, breakout 14:25-14:30); stop opposto, target 1:1, apre-fuori/chiude-fuori; **compressione StdDev(20) vs SMA(50) + Bollinger**; fuso: a voce IT, nel pannello server | il **target 30-40 pt + pari** (nuova geometria); l'ORB DAX e' **solo mattina**; la **StdDev "che cresce"** come conferma di prosecuzione D1 (r.69) |
| `ANALISI_LIVE_PAOLO_2026-09-29.md` | VWAP giornaliero ancorato al rollover come filtro ORB; box 5' pre-apertura in M1; risultati su 2-3 giorni | oggi **sostituisce la EMA50 col VWAP** (r.97) e ci mette lo **stop** (r.143); niente su rollover/ancoraggio |
| `caccia_strategie/ANALISI_LIVE_PAOLO_2026-09-03.md` | ADR "4a comparsa in 9 giorni": 115/248/270 pip, **esaurimento >2x ADR -> si riposa**, dashboard con % del movimento rispetto all'ADR | finestra di default **10 settimane**; oggi l'ADR e' per la **raggiungibilita' del livello** (r.453), non l'esaurimento |
| `caccia_strategie/ANALISI_LIVE_PAOLO_2026-08-25.md` | Supertrend 3.5/10, "reversal vs invert", RR "almeno 1 a 1" | "basta il terzo livello"; uscita alla rottura inclinata |
| `report/coach_paolo/NEWS_BREAKOUT_OCO_NFP_2026-09-03.md`; `OCO_CLAUDIO_HA_RAGIONE_2026-09-11.md` | straddle OCO sul NFP | oggi **non piu' prima della notizia: dopo, con i segnali** (r.321) |
| `mql5/Experts/ABTG_EMA200.mq5` r.61-65, 308-345 | filtro ADR-distanza "live Paolo, opt-in" (0,8x, 50 giorni) | la finestra 10 settimane = 50 giorni; **la EMA200 e' quella D1 sul grafico basso** |
| `mql5/Experts/ABTG_DAX_M3.mq5` | traduzione in EA della "Strategia DAX M3 T-TREND" della guida | **M3 non e' in questa live**; "conta D1" e' una gerarchia in piu' |

---

## 11. PROPOSTE DI MISURA (specifiche; nessun file prova; nessun round lanciato)

Regole che valgono per tutte: attesa e contro-esempio **scritti prima** dei numeri (criteri in un file committato e pushato prima del primo caricamento dei dati veri, come nel 01/10); R sempre al netto dello spread; i round girano **solo sul PC di backtest**; "campione sottile sospende il merito, non il rischio". Il tempo macchina e' stimato dalla cache gia' esistente; dove non ho una misura scrivo [NON STIMATO].

### M1. EMA200 **D1** come livello letto su barre basse (rimbalzo MTF) - **priorita' 1**
- **Domanda**: "la EMA200 D1 tracciata come linea sul grafico M5 respinge il prezzo piu' di una linea qualsiasi alla stessa distanza?"
- **Strumento**: estensione di `backtest_pipeline/ema200_rimbalzo.py` (stesse funzioni, stessa cache e stesso caricatore dei feed del 01/10). **Zero passate di tester.** Tempo macchina: [NON STIMATO] (stessa classe del 01/10: Python su M1).
- **Da congelare prima**: livello = EMA200 delle chiusure D1 **chiusa**, valore fisso per la giornata; evento = primo tocco **intraday** a barre M5 (o M15) dopo almeno N barre senza tocco; esito in ATR del TF di lettura **e** in ADR(50 gg); evento secondario "apertura entro 0,3 ADR dal livello" (la situazione di oggi).
- **Attesa (scritta prima)**: alla cella simmetrica, P(rimbalzo di 1 ATR prima di sfondamento di 1 ATR) **dentro l'IC del null** del 01/10 (random walk e surrogati) = esito NULLO come per la EMA del TF di lettura; l'ipotesi "e' un livello speciale" richiede P sopra il surrogato con |effetto| > 0,05.
- **Contro-esempio (placebo)**: la stessa misura con **EMA D1 di periodo 150 e 250** (stessa geometria, nessuna fama). Se anche loro "respingono" uguale, l'effetto e' di **spazio disponibile/volatilita', non della 200**. E il confronto con la EMA200 **del TF di lettura** gia' misurata (stessa tabella, stessi simboli).
- **Cosa fa gia' il 01/10 e non va rifatto**: la forma forte (P >= 0,75) per la EMA del TF di lettura.
- **Limite dichiarato**: a D1 il primo tocco e' raro (n 1-20 a D1 nella misura del 01/10). Qui il livello e' D1 ma gli **eventi** sono intraday: il campione sale, ma non e' indipendente (stessi giorni). **Contare gli episodi per giorno e dichiarare n indipendente**; se < 150: merito sospeso, **non** morto (certificato di morte del 09/09: mancano gestione dell'uscita, gemelli, TF).
- **Rischio di auto-inganno**: a M5 il 9-23% degli sfondamenti avviene nel minuto del tocco (misura 01/10); va tenuto nel null.

### M2. "Ostacolo EMA200 D1 davanti" come filtro delle aperture DAX - **priorita' 2**
- **Domanda**: "i breakout di apertura con la EMA200 D1 entro d x ADR **davanti** rendono meno di quelli senza ostacolo, piu' di un placebo?"
- **Strumento**: stratificazione descrittiva, **zero passate**. Fonti candidate: (a) studio apertura FASE A (`risultati_archivio/studio_apertura/`, per-giornata R, ~440 giornate BCM dal 2024.09.26, include `dir` e ampiezza) con la EMA200 D1 calcolata dal D1 BCM (EMA200 D1 richiede ~200 giorni di riscaldamento: sugli indici BCM restano ~11 mesi); (b) DAX M1 HistData 2010-2018 per un ORB **cieco** simulato (stessa funzione dell'`anatomia_movimenti_m5.py`).
- **Attesa**: se l'ostacolo vale, R medio con ostacolo (d < 0,5 ADR) **inferiore** a quello senza di un margine > IC; contro-esempio: **placebo = stessa distanza da una linea fittizia** (EMA D1 150/250) e da **PDH/PDL** (che il filtro `SRBlocked` gia' copre: se la 200 non aggiunge nulla a PDH/PDL, il filtro S/R basta).
- **Controllo di plausibilita' sul giorno di oggi**: 770411 e 770105 sono **2 stop sullo stesso giorno** = 1 evento di regime, non 2 campioni. Non e' un test: e' il perche' della domanda. **Nessuna decisione sui preset in campo.**
- **Prima cosa da fare, a costo zero e di sola lettura (domanda D1)**: il valore della EMA200 D1 del DAX alle 08:59-10:00 IT del 01/10.

### M3. D1 nella confluenza H4/M3 - **priorita' 3, solo dopo che l'H4/M3 e' letto**
- Gerarchia di Paolo (r.449): D1 prima, H4 conferma. La misura H4/M3 e' un event study con criteri congelati; **D1 non e' previsto**.
- **Disegno onesto**: **emendamento ai criteri prima di rileggere i numeri**, con una cella nuova "ALLINEATO e D1 concorde" contro "ALLINEATO e D1 contrario" (come D2 di H4/M3: filtro che aggiunge o no), **sui due feed gemelli** (oro A/oro B) e DAX; D1 = lato della EMA200 D1 oppure direzione del Supertrend D1 (da congelare). **Se i numeri H4/M3 sono gia' stati caricati con tutte le celle, qualunque stratificazione e' esplorativa e va dichiarata tale**, con conferma sul gemello di feed (stesso principio della regola "la cella verde per caso e' quella che brucia la challenge").
- **Contro-esempio**: placebo con D1 spostato di una giornata (futuro non visibile) e D1 "casuale con lo stesso rapporto long/short".

### M4. Il bersaglio fisso a 30-40 punti dell'ORB pomeridiano - **priorita' 4, conto a mano gia' fatto**
- Conto [DERIVATO]: con stop sul lato opposto del box e offset 10 (22/09: stop = ampiezza + 10), box medio [MISURATO, FASE A, 22/09] Dow **131,5**, Nasdaq **85,2**, DAX **62,5**, SPX **15,5**: stop = 141,5 / 95,2 / 72,5 punti. Con X = 35 (centro di 30-40): rapporto R = X/stop = **0,247 / 0,368 / 0,483**; vincite necessarie per il pareggio (prima dei costi) = stop/(X+stop) = **80,2% / 73,1% / 67,4%**. **Un random walk senza vantaggio fa esattamente quella frequenza** (P = Y/(X+Y)): lo stesso trucco che il 01/10 ha mostrato per la EMA200 ("l'80% della collega e' quello che fa gia' una passeggiata casuale"). Quindi un "70-80% di vincenti" **non e' evidenza**.
- **Misura a costo zero di tester**: MAE/MFE dello studio FASE A (`Studio_*.csv` ha `MAE_pt;MFE_pt;ampiezza_pt`): quota di giornate in cui MFE >= 30/35/40 prima di MAE >= stop opposto, **contro** la stessa quota di un random walk con le stesse ampiezze. Se la differenza e' dentro il rumore, il bersaglio fisso e' solo un modo di vincere spesso e perdere poco-molto, non un vantaggio.
- Dove non so: se il 30-40 e' uscita piena o parziale (V5). **Domanda D3.**

### M5. (nota, non una misura nuova) NFP del 02/10
- Non propongo round. **Fatto**: Paolo non fa ORB DAX nella mattina di NFP; i nostri DAX Apertura (09:00 IT) partono 5 ore e mezza prima del dato (14:30 IT), le sedie USA delle 15:30 IT un'ora dopo. Il filtro news dei preset FTMO e' spento e il CSV news non ha il 02/10. **Decisione: di Claudio** (D7).

### Cosa NON propongo (e perche')
- Niente griglia sui parametri di un motore gia' dichiarato senza edge (regola del 19/08).
- Niente round sul compression gate/Bollinger/Bulge da questa live (non c'e' nulla di nuovo).
- Niente sul "Golden Cross" dell'allievo (non si sa il simbolo; `ABTG_GoldenCross` esiste).

---

## 12. DOMANDE PER CLAUDIO (che conosce Paolo di persona) e screenshot ai minuti giusti

| # | Domanda / cosa chiedere | Perche' serve |
|---|---|---|
| **D1** | **Screenshot del grafico D1 del DAX con la EMA200 al 01/10** (oppure il valore della EMA200 D1 del DAX alla chiusura del 30/09), insieme al punto della live in cui Paolo dice "ha aperto molto vicino alla media 200" (r.21-31). Non detto da me nessun terminale: se servira' una lettura su MT5, la riga portera' in testa il bersaglio per esteso (numero di conto e cartella), come da regola. | Verifica del collegamento fra la sua frase e i due nostri short DAX di oggi; senza di lui M2 resta un'ipotesi |
| **D2** | Lo **screenshot dell'operazione EMA200 di Paolo** (r.129-147, quando mostra "sono entrato qua stamattina sulla media 200"): simbolo, TF, orario, lotti, stop, e **come e' finita**. | O5: e' l'unico trade con numeri veri della live e non li abbiamo |
| **D3** | **Il target "30-40 punti" e' uscita piena o parziale?** E lo stop dell'ORB Dow/Nasdaq pomeridiano e' ancora il lato opposto del box? E "quando le faccio vado in stop" (r.83) e' letterale? | M4 e `[INCERTO]` della sez. 6 |
| **D4** | Il **secondo ordine** della EMA200 ("un ordine prima e un ordine dopo", r.21, 135): il rischio e' **diviso** fra i due o ciascuno ha il suo? Dove mette lo stop (unico o per ordine)? | Se e' diviso e' il nostro EA; se e' doppio e' una mediazione |
| **D5** | **r.179**: "non ho messo lo stop perche' mi immaginavo che scendesse molto": si riferisce a un ordine reale? Quale? | unico passaggio ambiguo sulle protezioni |
| **D6** | Che cosa sono **"TSI"** (r.61) e le **"tre bande" in M1** (r.345-355) - Bollinger multi-banda o un indicatore suo? E le **impostazioni dell'ADX** "gia' settato" (periodo)? | senza il periodo l'ADX non si traduce |
| **D7** | **NFP di domani (02/10, 14:30 IT secondo Paolo)**: le sedie USA delle 15:30 IT sul trial e l'ORB Dow (non ancora attaccato) devono saltare la giornata? Oggi il filtro news e' spento nei preset indice e il CSV non ha il 02/10. | **decisione sua** |
| **D8** | Conosce **Paolo di persona**: l'ORB DAX del mattino lo fa guardando **sempre** la EMA200 D1 prima di entrare, come filtro fisso? E ha mai quantificato "troppo vicino" in punti? (r.173: lo dice [l'altro docente].) | e' il numero che manca a M2 |

---

## 13. COSA NON PRENDO

- I suoi risultati (ORB Dow/Nasdaq alternati, "bella operazione", NFP "33/55/164 pip"): aneddoti su pochi giorni.
- Il "99 su 100" e le correlazioni 46/39/79% come numeri: cambiano nel tempo e non sono verificati.
- Le conversioni pip/euro (V26) e gli obiettivi di reddito (V24): didattica, non parametri.
- L'idea che "gli EA non funzionano": e' un'opinione; e' pero' un **monito su dove cercare** (la parte meccanizzabile e' il contesto D1/H4, non il giudizio).

## 14. NESSUNA AZIONE SUL CAMPO

Nessun preset, sedia, taglia, conto, magic o Algo Trading toccato; nessun round lanciato; nessun file prova creato. Tutte le misure sopra sono specifiche in attesa di cancello e di firma dove toccano taglie o preset.

## 15. FONTI LETTE PER QUESTA SCHEDA

`data/trascrizioni/LIVE_PAOLO_2026-10-01.txt` (intera) · `report/ANALISI_LIVE_PAOLO_2026-09-29.md` · `report/LIVE_PAOLO_2026-09-22_SCHEDA.md` · `backtest_pipeline/caccia_strategie/ANALISI_LIVE_PAOLO_2026-09-03.md` (righe sull'ADR) · `report/EMA200_RIMBALZO_STATO_DELLARTE_2026-09-30.md` · `report/EMA200_RIMBALZO_MISURA_2026-10-01.md` · `report/H4_M3_CONFLUENZA_CRITERI_2026-10-01.md` · `report/TRIAL_GIORNO1_STOP_DAX_2026-10-01.md` · `report/TRIAL_GIORNO1_ANALISI_2026-10-01.md` · `report/CHI_E_PIU_VICINO_AL_CAMPO_2026-09-24.md` · `report/LETTURA_ROUND_CORTI_C_2026-09-28.md` (sez. 7.4) · `backtest_pipeline/REGISTRO_TEST.md` (r.123-126, 226, 325-336) · `mql5/Experts/ABTG_EMA200.mq5` · `mql5/Experts/ABTG_DAX_M3.mq5` · `mql5/Experts/ABTG_Apertura_3Ingressi.mq5` (r.288, 380, 2086-2139) · `mql5/Indicators/ABTG_Segnali_EMA_BB_ST.mq5` (testata) · `mql5/Presets/FTMO/{ABTG_DAX_Apertura_EU_770105_SHORT, ABTG_MaxMinNotte_DAX_Short_770411, ABTG_ORB_Ottimizzato_DOW_TRIAL}_FTMO*.set` e i cinque preset indice (news filter) · `mql5/Files/abtg_news.csv` (grep ottobre 2026) · `HANDOFF.md` (blocco 01/10).
