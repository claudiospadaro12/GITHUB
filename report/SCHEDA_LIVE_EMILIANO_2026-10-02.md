# SCHEDA LIVE EMILIANO - 02/10/2026 (giorno NFP, la mattina: "NFP, DAX al numero tondo, e la storia dei pendenti su sette strumenti")

**Fonte unica:** `data/trascrizioni/LIVE_EMILIANO_2026-10-02.txt` (38 righe per `wc -l`, 39 per `cat -n`, 47.055 byte,
trascrizione automatica, commit `993069c5`). Letta per intero. Nessuna navigazione, nessun completamento da memoria: dove
cito il repo lo dico col file.
**Analista:** estrattore di trascrizioni (agente `analista-trascrizioni`), 02/10/2026.

> ## REGOLA CHE VALE SOPRA TUTTO
> **Da questo materiale non si muove NIENTE.** Ogni numero qui dentro e' una **dichiarazione di una fonte esterna**
> `[dichiarato, NON verificato]`, mai un criterio nostro. Nessun preset, EA, conto, sedia o forward e' stato toccato per
> scrivere la scheda; nessun round lanciato. Le "misure proposte" della Parte 5 sono **specifiche**, non file prova: ognuna
> passa dal cancello prima di esistere e i round girano solo sul PC di backtest.

Etichette: **[TRASCRITTO]** c'e' scritto (cito) - **[TRASCRITTO dubbio]** c'e' scritto ma puo' essere un errore di
trascrizione - **[INFERITO]** lo deduco (dico da cosa) - **[INCERTO] / [NON CHIARO]** non lo so e non lo deduco -
**[DICHIARATO, NON verificato]** numero del relatore - **[DERIVATO]** calcolo mio da numeri scritti, formula nel testo -
**[LETTO nel repo]** viene da un file nostro, col nome - **[NON MISURATO]** il dato non c'e'.

**Convenzione sulle citazioni.** Le citazioni sono verbatim dalla trascrizione, con la grafia italiana normale per accenti e apostrofi dove l'ho
scritta in ASCII; le **storpiature STT le lascio com'e'** ("non fan pedo", "ORM", "stop in pali", "Audi Yen") e le sciolgo **solo** fra parentesi quadre o in
§2.1. Dove ho usato `...` ho tagliato; dove la frase e' una citazione di un'altra nostra scheda lo dico.

**Come si leggono i riferimenti.** Le righe 1-37 sono corte: cito `r.NN`. **La riga 39 contiene da sola 43.696 caratteri su
~47.000 (il 93%)**: cito `c.N` = posizione del carattere (base 0) **dentro la r.39**, misurata con Python sul testo UTF-8.
Per ritrovare un passo basta cercare la citazione.

---

# PARTE 1 - LA SINTESI (la pagina che si legge per prima)

## 1.0 La riga che conta

> **Su 39 righe: 26 voci di parametro/valore (nessuna e' una regola con soglia completa e verificabile), 22 meccanismi,
> 9 bandiere (0 rosse piene, 1 avvertenza rossa STORICA e autodichiarata sui pendenti NFP, 5 arancioni, 3 ambra),
> ZERO regole prop, ZERO trucchi anti-prop.**
> **La parte NFP e' un RACCONTO piu' una STATISTICA DI SECONDA MANO, non un'operativita' mostrata.** La live e' girata
> **al mattino, prima del dato**: il DAX apre mentre parla (c.11309: *"mancano dieci secondi... e' partito"*) e l'NFP e'
> ancora davanti (*"ah la notizia andra' ok va bene magari e' una notizia scontata"*, c.40525) `[INFERITO]` - nessun trade
> NFP e' mostrato. Il solo contenuto NFP *operativo* e' un'**intenzione** per oggi: *"euro dollaro e oro"*, con
> *"quantita' standard modeste"* (c.41082-41321). Tutto il resto del tempo e' DAX al numero tondo 25.000.
> **Il pezzo piu' solido per noi non e' un numero: e' la CONVERGENZA DEL GIORNO NFP fra i due docenti** (Emiliano 02/10 e
> Paolo 01/10: niente ORB sull'NFP, mercato "attendista", si lavora dopo e leggeri) **e il fatto che NON e' una convergenza
> indipendente** (stesso corso, stessa scuola, e la cifra dei 60 pip era gia' agli atti dal 29/07, §1.2 N8).

## 1.1 Che cosa e' questa live, e che cosa NON e'

- **Chi parla:** quasi solo **Emiliano (host)**, che **opera in prima persona** sul DAX (come il 28/09, diverso dal 30/09
  dove operavano i colleghi). Interlocutori in chat citati per nome (Marco, Luca, Cristian, Giuliano, Mattia, Stefano,
  Paolo "ciao Paolo" r.21): usati solo come etichetta, nessun dato personale. A fine live parla con una terza persona
  chiamata "Fede"/"Parigi" (stessa persona gia' nominata come "interruzione personale" nel referto del 28/09,
  `report/ANALISI_LIVE_EMILIANO_2026-09-28.md`): `[INFERITO]` chi organizza le live; serve per un "permesso" (§1.2 N14).
- **Non e' una prop.** Zero `prop`, `FTMO`, `funded`, `drawdown`. L'unica `challenge` (r.21: *"questo e' un weekend, collego le
  challenge"*) e' l'esercizio del corso gia' visto il 30/09 `[INFERITO dalla scheda del 30/09]`.
- **Orari:** la trascrizione **non ha orari e non dichiara il fuso**. Dal contenuto la live comincia **prima dell'apertura
  del DAX** e dura oltre il quarto d'ora successivo. *"Nel 2015"* (c.37210, c.37534, vedi §2.3 P1) e' l'unico indizio di un
  orario operativo e **non e' dettato come ora**. **Non converto nessun orario.**
- **Qualita':** bassa. La r.39 e' un unico flusso senza punteggiatura che mescola DAX, NFP, volumi, aneddoti e battute
  con i partecipanti. Parti incomprensibili segnalate una per una nelle tabelle.

## 1.2 NFP IN PRIMO PIANO - tutto cio' che dice, passo per passo

Tutte `[DICHIARATO, NON verificato]`. Colonna "Chiaro?" = affidabilita' della frase come trascritta.

| # | cosa dice | citazione (troncata) | dove | Chiaro? |
|---|---|---|---|---|
| N1 | **Si guarda sempre il calendario** (Forex Factory, Investing o simile) prima di operare | *"non dimentichiamoci mai di prendere sempre, di prendere sempre Forex Factoring, Investing, o un tool che ci permette di sapere..."* ("Forex Factoring" = Forex Factory `[INFERITO]`) | r.33 | si' sul concetto |
| N2 | **Il primo venerdi' del mese e' un giorno speciale**: dati fra i piu' importanti; *"il mercato scontra gia' questo tipo di informazione"* (= il mercato sconta gia' l'informazione `[INFERITO]`). Le parole attorno ("la riflessione", "PPI") sono storpiate | *"in particolare il primo venerdi' di mese, ci sono uno dei dati piu' importanti..."* | r.33 | solo il concetto; **il resto `[NON CHIARO]`** |
| N3 | **Cambiano le condizioni, cambia l'operativita'** | *"Cambiano le condizioni e devi cambiare anche tu l'Opera"* (= operativita' `[INFERITO]`) | r.35 | si' |
| N4 | **Prima del dato il mercato e' "attendista" e e' difficile un movimento direzionale**: *"se c'e' un dato molto importante... sara' difficile che faccia un movimento direzionale"*; *"abbiamo detto che e' difficile che possa prima del rilascio di non fan payroll fare un movimento di estensione di una giornata, questo rimane fermo"* (lo dice mentre studia il DAX) | r.35; c.0-110; c.3857 | si' sul concetto; il pezzo *"entro il cinque e mezzo"* (r.35) e' `[NON CHIARO]` (un orario? non lo converto) |
| N5 | **Eccezione al "fermo": se rompe livelli rotondi importanti CON volumi, si puo' entrare**: *"nel caso in cui il mercato rompe a livelli circolari importanti, possa rompere con volumi, allora a quel punto possiamo entrare magari sulle teste"* | c.179-360 | `[TRASCRITTO dubbio]`: "livelli circolari" = livelli tondi `[INFERITO]`; "sulle teste" `[NON CHIARO]`; **non dice se prima o dopo il rilascio** |
| N6 | **Oggi sul Forex non si sceglie lo strumento**: *"Oggi non c'e' la possibilita' di sceglierlo su Forex, perche'? ... Ti ricordo oggi gli NFP"* (un partecipante lo ricorda); la mattina la passa sul DAX | r.27-29 | si' sul fatto, il motivo e' `[INFERITO]` |
| N7 | **ORB sull'NFP: "secondo me no"**: *"in un contesto di non fanpero l'ORM [= ORB] potrebbe essere una strategia valida secondo me no secondo me no quindi secondo me no perché non dovrebbe prendere direzione"* | c.18053-18160 | si' |
| N8 | **La regola dei 60 pip su EURUSD.** *"Francesco aveva fatto un lavoro per la comunità pazzesco e è andato a verificare qual era il range medio dei prezzi donanti di non fan pedo di tutti i strumenti finanziari... abbiamo trovato che l'euro dollaro sta all'interno mediamente di 60 pip il primo movimento di non fan pedo è a 60 pip il primo movimento direzionale si ferma mediamente a 60 pip poi fa quello che deve fare e prende il direzione il primo movimento"* ("donanti di" = `[NON CHIARO]`: forse "dopo/dei"; non lo risolvo) | c.30834-31320 | **chiara sul numero** (3 volte "60 pip"). **Metodo, campione, periodo, finestra di tempo e unita' del "range medio" NON dichiarati.** Autore = "Francesco" (un collega del corso), non Emiliano. **Gia' detta il 29/07** (`docs/live_emiliano/ANALISI_LIVE_luglio.md` r.35: *"primo movimento EUR/USD ~60 pip (statistico)"*, a proposito del FOMC): **ripetizione, non conferma indipendente** |
| N9 | **AUDJPY "reversa".** *"abbiamo determinato che Audi Yen era l'unica valuta che sempre aveva un comportamento reversa cioè aveva un comportamento che arrivava a 30, 40, 50 non so se vi ricordate a 30, 40, 50 pip short e long... Audi Yen è l'unica valuta che è reversa cioè fa sempre così va e poi scende e torna al suo punto di partenza"* | c.31321-31720 | numeri chiari (30-40-50); **"Audi Yen" = AUDJPY `[INFERITO]`** (il testo dice "Audi Yen"; "Audi" compare altrove per AUD, r.25). **Dove va l'ordine "short" e' sullo schermo, NON detto** (§2.8 S1) |
| N10 | **Il sistema vecchio: "ordini pendenti su sette strumenti contemporaneamente"** | *"abbiamo creato un sistema che ci metteva degli ordini pendenti e diceva su sette strumenti contemporaneamente: quando va bene va bene, ma poi dopo in realta' avevamo tutto per scontato, ormai erano soldi incassati"* | c.30131-30330 | si' sul concetto; "per non utilizzare la leva" (c.30354) `[NON CHIARO]` |
| N11 | **Perche' li aveva smessi.** Per anni *"un punto di riferimento importante nella mia operativita'"* ("ogni primo domenica di mese facevo gia' mese il venerdi'", c.27635: **storpiato**, probabile "ogni primo venerdi' del mese `[INFERITO]`"). Poi un episodio: *"i clienti al feature camp 3, 2, 1 0 pensavo di portare a casa 10, 20, 30k invece abbiamo lasciato tutti tutto tutti tutto senza senso... da quel momento forse è meglio non rifare"* ("feature camp" `[NON CHIARO]`: un evento?; "3, 2, 1" = conto alla rovescia del dato `[INFERITO]`); *"eravamo tipo 600 persone che negoziavano tutti lo stesso blogger e gli abbiamo portato via un sacco di quantità"* ("blogger" `[INCERTO]`: forse "broker"); *"abbiamo bruciato chi ha bruciato i fondi mi sono sentito una merda in quel momento ero distrutto"* | c.27300-28200 | **narrativa chiara nel senso** (clienti/allievi hanno perso, lui si e' sentito responsabile); **data, strumento, broker, importi NON dichiarati** |
| N12 | **Perche' li ha ripresi.** *"io ho ripreso a farli Marco io ho ripreso a farli leggero"*; *"da un po' di mesi perche' diciamo con qualche accorgimento"*; *"adesso io la guardia c'ho da ben alta"*; *"quando dai le cose per scontato e' li' che abbassi la guardia ed e' li' che vengono ammazzate"* | c.27067-27100; c.29632-29676; c.29944-30000 | **l'"accorgimento" NON e' mai detto** (la frase che lo spiega, c.29709, e' incomprensibile). Taglia: *"adesso non utilizzerò una leva ma una leva che sia diciamo in linea con quella che ho avviso l'operativo"* (c.30377) `[TRASCRITTO dubbio]` |
| N13 | **Cosa lavorera' oggi.** *"si lavora euro dollaro le valute che hanno più liquidità euro dollaro usdn e e oro euro dollaro e oro"* ("usdn" `[NON CHIARO]`); *"sull'euro dollaro entrero' con quantita' standard modeste, entrero' con 10 modeste ... inizialmente con uno stop di 2.500 euro per farne un doppio"*; *"con l'oro entrero' con 3 o 4"* | c.40990-41400 | strumenti chiari (**EURUSD e oro**); **taglie e stop `[TRASCRITTO dubbio]`**: "10 modeste" e "3 o 4" **senza unita'** (lotti? contratti?); lo "stop di 2.500 euro per farne un doppio" e' **incomprensibile come regola** (2.500 e' anche la cifra del profitto del DAX di poco prima) |
| N14 | **Il "permesso" per fare l'NFP in diretta.** Chiude con una chiamata: *"appena finita la live voglio chiederti un permesso se posso, con quantita' pochino leggerissima, posso fare uno speciale NFP"*, risposta *"oggi ci sono un lotto [?]"*, e piu' avanti *"quindi non li possiamo fare ma proprio adesso"* | c.42724-43000 | **esito INCERTO**: la frase finale puo' voler dire che l'NFP in diretta NON si fa. Da chiedere a Claudio se e' andata (§6) |
| N15 | **Frase sull'uscita del dato**: *"la notizia ovviamente che esce improvvisamente non ti permette poi magari di prendere la pubblicita' corretta"* | c.40593 | `[NON CHIARO]` ("pubblicita'" e' STT di qualcosa di simile a "direzionalita'/il prezzo corretto"): **non interpreto** |
| N16 | Post-saluto: *"probabilmente e' nata proprio per la notizia uscita... questo non si puo' prevedere"* sulla direzionalita' del DAX | c.42230 | `[TRASCRITTO dubbio]` (dopo "ciao a tutti", c.41470); riferito al DAX, non a un trade NFP |

**Quello che NON dice sugli NFP** (verificato con `grep` sul file): zero `AUDJPY` scritto cosi' (solo "Audi Yen"), **zero
USDJPY**, **zero orari** del dato, **zero distanze/SL/TP** per un setup NFP, **zero risultati** di trade NFP, **zero
"OCO"**, **zero filtro news in minuti**. Il "60 pip" e il "reversa" sono **statistiche citate a memoria da uno studio di
un collega** (*"se vi ricordate"*, c.31445), non la sua regola operativa descritta.

## 1.3 NFP contro la nostra sedia `ABTG_PostNews` 771203 (USDJPY, M5)

**Come e' la sedia** [LETTO nel repo: `mql5/Presets/ABTG_PostNews_NFP_USDJPY.set` e la versione FTMO
`..._771203_FTMO.set`, `report/PACCHETTO_POSTNEWS_TRE_GRAFICI_2026-09-19.md`, `report/NFP_2026-10-02_SEDIE_TRIAL.md` §4]:
dato alle 14:30 IT; **riferimento = massimo e minimo delle due candele M5 14:35 e 14:40 IT**; **ordini STOP piazzati alle
14:45 IT** (13:45 BCM): **BUY STOP a max + 3 pip, SELL STOP a min - 2 pip**; **SL 25 / TP 30 pip dall'ingresso su entrambe le
gambe**; **`InpUseOCO=false`** (le due gambe possono riempirsi tutte e due); **scadenza pendenti 17:59 IT**; posizione
chiusa a TP/SL o alle 22:50 IT di venerdi'; rischio 0,65% per ordine = **1,30% a evento nel caso peggiore**; regole prese
da una **slide del corso AB Forex, pag. 140-143**. **Contratto: `[NON MISURATO]`** (`report/CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md`
r.70). Stato in campo: **non sul trial `1514806751`; sul piccolo `50503392` attaccata ma cieca** (file news svuotato il 07/09);
**quindi oggi non opera da nessuna parte** (`NFP_2026-10-02_SEDIE_TRIAL.md` §4).

### CONVERGENZE (tutte NON indipendenti: stessa scuola)

| punto | Emiliano 02/10 | 771203 | peso |
|---|---|---|---|
| **L'NFP e' un giorno a se'** | N2-N4: cambiano le condizioni, mercato attendista | sedia dedicata, calendario proprio | concettuale. **Stessa fonte**: la sedia nasce da una slide del *corso* di Emiliano e Paolo |
| **Non si lavora sul dato, si lavora dopo** | N4 (pre-dato fermo) + N7 (no ORB) + la regola di Paolo 01/10 *"io la faccio dopo il rilascio"* (`SCHEDA_LIVE_PAOLO_2026-10-01.md` V18) | ordini armati **15 minuti dopo** il dato, sulle due candele 14:35-14:40 | **coerente nel disegno**; non e' una prova che il disegno renda. Gia' scritto il 29/07: *"Post-news ... NON sul dato (troppo slippage)"* (`docs/live_emiliano/ANALISI_LIVE_luglio.md` r.28, sul FOMC) |
| **Il primo movimento "si esaurisce" poi "prende la direzione"** (N8) | primo movimento EURUSD ~60 pip, *"poi fa quello che deve fare e prende il direzione"* | la sedia aspetta 10 minuti (le due candele) e poi mette i due pendenti in cima/fondo del range | **compatibile come idea**, ma **non trasferibile**: la cifra e' su EURUSD, la sedia e' su USDJPY, e il pip non e' lo stesso fra i due cambi (§2.3 P19) |
| **Taglia piccola il giorno del dato** | N12-N13: *"leggero"*, *"modeste"* | 1,30%/evento nel preset (0,65% per ordine) | **non confrontabile**: lui non da' percentuali ne' capitale |

### CONTRADDIZIONI E TENSIONI

1. **AUDJPY "reversa" contro il nostro breakout.** La sedia **compra la rottura e vende la rottura** (continuazione).
   Per Emiliano, su AUDJPY il movimento *"va e poi scende e torna al suo punto di partenza"* (N9): la rottura **non** paga, **il
   fade si'**. E' il segno opposto su una **coppia JPY**. **Non e' una contraddizione sul nostro simbolo** (USDJPY non e'
   AUDJPY e la live non nomina USDJPY): e' un'**ipotesi** (§1.4).
2. **L'architettura "pendenti su piu' strumenti" e' quella che gli ha fatto male (N10-N11).** Il nostro 771203 e' un'architettura
   della stessa famiglia (pendenti due lati, senza OCO, SL/TP fissi), su **un** strumento. La sua storia e' **un aneddoto
   sul rischio di coda di quell'architettura** (*600 persone sullo stesso [broker?]*, `[INCERTO]` il termine) **non un dato
   nostro**. La parte che ci riguarda **e' gia' scritta**: *"In un NFP sul feed FTMO: [NON MISURATO]"* e
   *"1,30% in una giornata invece di 0,65%"* quando le due gambe riempiono (`NFP_2026-10-02_SEDIE_TRIAL.md` §2 e §6;
   `REGISTRO_TEST.md` lapide POSTNEWS: **24,8% e 23,5% delle giornate** riempiono entrambe le gambe, con SL 25 / TP 30 come la
   sedia, sui blocchi ISM e 13:30, **non sull'NFP**; `CACCIA_POSTNEWS_MECCANISMI_2026-09-05.md` r.292-296).
3. **Sette strumenti contemporanei = una scommessa correlata.** Sette pendenti sul dato USA muovono tutti la stessa leva
   (il dollaro) `[INFERITO]`. Da noi la correlazione e' coperta dal cap C1 al 3,25% (**firmato**, vivo) e dal tetto di cluster
   (3,0%, **firmato ma NON attivo**: `CLAUDE.md`). Qui nessuna azione, solo il nesso.
4. **Dove la sua prudenza e' piu' severa della nostra configurazione**: lui non lavora sul dato, noi **non abbiamo
   un filtro news acceso** sulle sedie indice FTMO (`InpUseNewsFilter=false`, `NFP_2026-10-02_SEDIE_TRIAL.md` §0). Non
   e' un'osservazione nuova: e' gia' la nota decisionale di Claudio. **Nessuna decisione qui.**

## 1.4 "AUDJPY reversa": e' un meccanismo alternativo da MISURARE? (solo ipotesi, mai criterio)

**Che cosa e' dichiarato** (N9): *una* coppia, *"sempre"*, 30-50 pip dopo l'NFP, poi ritorno al punto di partenza. **Che cosa
manca per poterlo ripetere:** la finestra di tempo (quanti minuti), il livello di partenza (prezzo pre-dato? chiusura della
prima candela?), l'orizzonte del "ritorno", il periodo dello studio, il numero di eventi, i costi. *"Sempre"* in uno
studio statistico e' un'**iperbole**: **non lo uso come numero**. La geometria dell'ordine (*"questo e' il livello di prezzo
e questi sono 60 pip, come qua mettiamo l'ordine short"*, c.31568-31700) e' **sullo schermo, non nel parlato**: tra l'altro i 60 pip
sono *piu'* dei 30-50 che l'AUDJPY "fa" (c.31383): se l'ordine sta a 60 pip dal livello, su AUDJPY non verrebbe mai raggiunto:
**la frase e' incoerente cosi' com'e' trascritta `[INCERTO]`**.

**Perche' regge come ipotesi (e perche' e' MIA, non sua):** AUDJPY **non ha la gamba USD**. L'NFP entra sul cambio solo
**indirettamente** (propensione al rischio, ecc.), mentre USDJPY **porta direttamente il dollaro**. Un primo impulso che
**rientra** su una coppia senza USD e **prosegue** su una coppia con USD e' **coerente** con cio' che un'asimmetria di
questo tipo produrrebbe. **E' `[INFERITO]` da me; nel parlato non c'e'.** Non e' una prova di niente.

**Perche' va trattata con sospetto, tutto gia' in casa:**
- **"L'unica valuta"** e' una scelta **a posteriori** su un insieme di coppie: fra tante coppie, una "sempre reversa" puo'
  uscire per caso. Per questo il confronto, se si fa, e' **trasversale** (AUDJPY contro le altre), non su AUDJPY da sola.
- **Il fade post-notizia e' gia' una lapide** (`backtest_pipeline/REGISTRO_TEST.md` r.1571-1577): *"il fade e' lo specchio del
  breakout sugli stessi prezzi di scatto, a somma quasi nulla, e paga lo spread due volte. Invertire una strategia
  perdente non e' un meccanismo nuovo"* (misurato su **EURUSD e oro**, eventi ISM e blocco 13:30, 2010-2020, con controllo a
  ingressi casuali; sul 13:30 il fade fa PF 1,10 contro un casuale a 1,06). **Quella misura NON copre AUDJPY, NON copre
  l'NFP e NON copre il regime 2021-2026** (`CACCIA_POSTNEWS_MECCANISMI_2026-09-05.md` §0 e riga 495-496). Quindi la lapide
  **non chiude** la domanda, ma da' l'**attesa**.
- **AUDJPY ha un'ipotesi di deriva di carry gia' sul tavolo**: sull'EMA200 H4 il lato forte di AUDJPY e' il LONG e l'ipotesi *"e' la deriva del carry, non il motore"* e' stata posta e **non e' ne' esclusa ne' dimostrata** (`REGISTRO_TEST.md` r.2820-2826). Un "ritorno al punto di partenza" va depurato di questo.
- **La frequenza e' fatta di NFP**: ~12 eventi/anno. Anche se reale, e' un **satellite** (0,05 op/giorno, come il 771203):
  **non porta una famiglia al pavimento di 1,00 op/g** (`PACCHETTO_POSTNEWS_TRE_GRAFICI_2026-09-19.md`, "il conto della
  famiglia").

**Verdetto sull'ipotesi:** si puo' misurare **a costo zero di tester**, come studio di eventi, **con l'attesa NEGATIVA scritta
prima** (Parte 5, M-N1). **Non e' un candidato**, non entra nell'imbuto, **non tocca la 771203**.

## 1.5 Le altre cose piu' utili (dopo l'NFP)

| # | cosa | perche' vale | etichetta |
|---|---|---|---|
| 1 | **Il livello e' il NUMERO TONDO 25.000, non il box notturno** | il 30/09 i colleghi usavano il max/min **della notte**; qui Emiliano compra il rimbalzo **sul tondo** all'apertura (c.10716, c.11437). Il nostro `SRBlocked` conosce **PDH/PDL e numeri tondi** come **ostacoli** (opt-in, spento): lui li usa come **supporti** | [TRASCRITTO] + [LETTO nel repo, `SCHEDA_LIVE_PAOLO_2026-10-01.md` §9.5] |
| 2 | **I volumi decrescenti su un livello toccato per la seconda volta** = si puo' ri-entrare in contro-tendenza; **crescenti** = si esce | la stessa direzione del nostro filtro volumi (`InpUseVolumeFilter`, rottura >= media), che migliora PF ma **taglia le uscite 270 -> 150 -> 96 -> 62** (selezione, non gestione: `report/ALZARE_IL_PF_2026-09-22.md` r.349) | [TRASCRITTO] + [LETTO nel repo] |
| 3 | **Gestione: "metta' posizione + stop in pari" e "stop bassissimo"** | la stessa ricetta del 30/09 (P3) e di Paolo del 01/10: parziale + pari. E' **gia' nostra** (TP1 50% + BE sui DAX) | [TRASCRITTO] + [LETTO nel preset] |
| 4 | **Trading range diviso in parte bassa/alta + scalping dentro** | e' il "cost to cost" del 30/09 senza il nome di Larry Williams: bande orizzontali | [INFERITO] |

## 1.6 Quello che NON c'e' (verificato con `grep`, conteggio per termine)

| pratica cercata | occorrenze | nota |
|---|---:|---|
| prop / FTMO / funded / drawdown | 0 / 0 / 0 / 0 | |
| martingala / raddoppio / griglia / mediazione / hedging / copy | 0 / 0 / 0 / 0 / 0 / 0 | nessuna parola; ma l'ingresso a due livelli con stop spostato e' descritto in **B2** (§2.7) |
| "recuper*" | 2 | *"andare a recuperare i 25 mila"* = il **livello**; *"recuperato 5 cento"* = `[NON CHIARO]`. **Nessuna** "recupero perdite" |
| "senza stop" | 0 | lo stop e' citato **46 volte**, quasi sempre per dire che lo mette |
| trucchi per aggirare le prop | **0** | **nessuna sezione "VIETATO PER NOI" da aprire** |
| VWAP / Supertrend / EMA / Fibonacci / gap | 0 / 0 / 0 / 0 / 0 | **la live e' senza indicatori**: lo dice lui (*"ho lavorato un mercato senza niente: c'e' un indicatore, c'e' un oscillatore, c'e' una media, senza niente... con la perception e basta"*, c.21361). Cade tutta la colonna EMA200 del 30/09 e del 01/10 |

---

# PARTE 2 - LA SCHEDA DI CASA

```
FILE             data/trascrizioni/LIVE_EMILIANO_2026-10-02.txt  (39 righe cat -n; r.39 = 43.696 caratteri)
RELATORE/CANALE  Emiliano (host, opera in prima persona); partecipanti in chat; Zoom; serie live gia' agli atti
OGGETTO          Mattina del giorno NFP: scelta dello strumento, DAX attorno al numero tondo 25.000
                 (long al rimbalzo, gestione a meta' posizione, secondo giro, scalping nel range), ORB,
                 piu' un racconto sugli NFP (60 pip EURUSD, AUDJPY reversa, sistema pendenti su sette strumenti).
```

## 2.1 Le ricostruzioni dell'ascolto (tutte [INFERITO], nessuna entra in un numero)

| nel testo | lo leggo come | su che base |
|---|---|---|
| "non fan pair/pedo/payroll/perol", "NFPM", "no fan perol" | **NFP (Non-Farm Payrolls)** | contesto r.29, r.35-39, c.26900 |
| "Audi", "Audi Yen" | **AUD / AUDJPY** | r.25 (*"Audi e la ZD"* = AUD e NZD); c.31321 |
| "orm", "orba", "orb" | **ORB** | indicazione di Claudio gia' agli atti (scheda 30/09) |
| "nel 2015", "lo prendo nel 2015" | **09:15** (orario IT) ? | **il testo dice solo "2015"**; la lettura 09:15 viene dal mandato di Claudio; nella scheda del 30/09 era `[NON CHIARO]`. Coerente con un ORB a 15' dall'apertura del DAX (09:00 IT) **[INFERITO]**, mai dettato come ora |
| "stop in pali", "stop impari" | **stop in pari** (breakeven) | contesto: *"adesso mi riprendo la stop in pali"* (c.14454) |
| "tele range", "training range", "trading range" | **trading range** | contesto c.800-1100 (*"parte inferiore e parte superiore"*) |
| "numero torno" | **numero tondo** | contesto c.38244-38550 |
| "German", "Axe", "Das" | **DAX** | contesto di tutta la live |
| "SMP" | **S&P 500** | c.10700 |
| "cannera / cannelle" | **candela / candele** | r.39 c.3796 e c.4445 |
| "contatti" | **contratti** | c.24200 |
| "dashboard Zen" | una **dashboard di forza valutaria** (quadretti, weekly/daily nella stessa direzione) | r.23-25; nelle lives precedenti compare **"ZenFX"** (`docs/live_emiliano/ANALISI_LIVE_storico.md` r.25) |
| "move up" | `[NON CHIARO]`: un indicatore che permette stop piu' vicini | c.37405; **non interpreto** |
| "Poc" | `[NON CHIARO]`: "poco"? "POC" (point of control)? | c.24657, 24979; **non interpreto** |
| "scioltare / sciolterei / scioccarlo" | `[NON CHIARO]` (probabile "sciogliere = chiudere", altre volte "shortare"?) | compare 6-7 volte; **non interpreto** |
| "GPPD" | forse **GBPJPY** `[INCERTO]` | c.1700-3000: lo scarta come *"un macello"* |
| "pre-section", "preseption" | una zona/canale di prezzo, parte alta e floor | stesso termine del 30/09 (**non definito nemmeno la'**) |
| "Parigi", "Fede" | persona che organizza le live | r.39 c.26872, c.42724 e referto 28/09 |
| "feature camp", "blogger", "usdn", "pubblicita' corretta", "3 shot", "8 miliardi", "Luigi ... il test" | `[NON CHIARO]` | **non interpreto** |

## 2.2 Cronologia della live (per orientarsi dentro la r.39)

| c. (r.39) | cosa succede |
|---|---|
| 0-1700 | NFP: mercato attendista; spiegazione "trading range" parte alta/bassa; *"l'ATR ti da' un numero"* |
| 1700-9300 | scelta dello strumento con la dashboard; oro e un cambio (forse GBPJPY, `[INCERTO]`) valutati e non scelti; DAX: weekly negativo, daily incerto, zona "pre-section"; scenario A; *"aumento il size"* (c.8226); *"se non c'e' la strategia invento"* (c.9293) |
| 9300-11500 | primo obiettivo 25.100; sondaggio *"quanti di voi entrerebbero in long?"*; apertura del DAX; **ingresso long 20 contratti sul tondo 25.000** |
| 11500-13400 | stop non visibile -> da mettere; divisione in due della size; il prezzo rompe il minimo precedente; stop spostato sotto; liquida la parte a 25.000, tiene quella sotto |
| 13400-20700 | gestione: metta' posizione + stop in pari; 20 -> 10 -> 5 contratti; *"60 punti"*, *"100 punti d'azio in un quarto d'ora"*; ORB non utile alle 9 |
| 20700-26300 | **secondo giro**: volumi, falso breakout, *"e' la seconda volta"*, *"io devo entrare con meno"*; **rinuncia** al secondo giro |
| 26300-31800 | **NFP**: ripresa dei pendenti; storia dei 600; 60 pip EURUSD; AUDJPY reversa; range notturno; domanda "dalle 6 del pomeriggio" |
| 31800-36900 | scalping nel range con stop sempre; spike senza volumi |
| 36900-40800 | **ORB "nel 2015"**; short sul numero tondo; **chiusura: +2.700 / +2.500 EUR** |
| 40800-41500 | piano per oggi: EURUSD e oro, quantita' modeste |
| 41500-43696 | frammenti **dopo il saluto**; telefonata con "Fede": permesso per un possibile "speciale NFP" |

## 2.3 PARAMETRI CON VALORE

Tutti **[dichiarato, NON verificato]**. "Chiaro?" = affidabilita' del numero come trascritto.

| # | parametro | valore | citazione (troncata) | posizione | Chiaro? |
|---|---|---|---|---|---|
| P1 | **ORB, livello** | **"nel 2015"** (= 09:15 `[INFERITO]`) | *"nel 2015 questo e' il livello orb, e' corretto? ... lo prendo nel 2015"* | c.37210, 37534 | **non e' dettato come ora**; durata del range **NON dichiarata** |
| P2 | **ORB alle 9** | **non da' "valore aggiunto" oggi** | *"oggi l'orba e' una strategia che ti puo' dare un valore aggiunto alle 9? no"* | c.20730 | si'; "alle 9" = ora italiana `[INFERITO]`, fuso NON dichiarato |
| P3 | **ORB in giorno NFP** | **no** | *"in un contesto di non fanpero l'ORM [= ORB] potrebbe essere una strategia valida secondo me no"* | c.18053-18126 | si' |
| P4 | **Stop dell'ORB long** | **sotto il livello ORB**, oppure con "move up" per stop piu' vicini | *"entro long e lo stop lo metto qua sotto perché lo posso mettere o sotto il livello dell'orb o posso andare di solito vado a prendere il move up e il move up mi da anche magari la possibilità di mettere gli stop più vicini"* | c.37726-37900 | `[TRASCRITTO dubbio]` ("move up" non chiaro) |
| P5 | **Primo obiettivo DAX** | **25.100** | *"potrebbe arrivare a 25.100, primo obiettivo 25.100"* | c.10308 | chiaro |
| P6 | **Livello d'ingresso e di uscita** | **25.000** ("tondo"), ingresso long all'apertura; obiettivo **25 mila** | *"ho effettuato un ingresso di 20 contratti sul rotondo... ho preso un livello obiettivo che era 25 mila"* | c.11437-11580 | chiaro |
| P7 | **Taglia** | **20 contratti**; poi *"dividere in due la size"*; seconda parte *"sul minimo della candela precedente"* | *"la seconda parte della size la metto sul minimo della candela precedente"* | c.11454, 11812, 12043 | chiaro; **TF della "candela precedente" NON dichiarato**; **capitale e valore del punto NON dichiarati** |
| P8 | **Stop iniziale e target** | **~60 punti** di stop, **60 punti** di obiettivo (1:1) | *"sono circa 60 punti, se io ho 60 punti di stop cerchero' di fare 60 punti di gain"* | c.12149-12200 | chiaro. **E' la cifra con cui e' partito**; poi lo stop cambia (B2) |
| P9 | **Obiettivi realizzati o attesi** | *"dai 50 ai 60"* (attesi); *"oltre 60 punti"*; *"100 punti d'azio in un quarto d'ora"*; *"altri 20, 30 punti"*; *"i 40 punti"*; *"altri 2 o 3 cento euro"* | | c.15519, 16674, 19832, 20848, 16198 | chiari ma **di cronaca**, non parametri |
| P10 | **Parziale e stop in pari** | **meta' posizione a casa + stop in pari**, il resto "corre"; poi **20 -> 10 -> 5 contratti** | *"porto a casa metà posizione e e faccio correre porto a casa metà posizione faccio correre andando a gestire una posizione dove non posso perdere"* · *"ho dieci contratti... rimango solo con dieci"* | c.14129-14500; c.18851 | chiaro il meccanismo; **nessuna soglia in punti** (a differenza del "ogni 20 punti" del 30/09) |
| P11 | **"Stop bassissimo"** | dopo il parziale, stop a *"160 euro"* | *"scioltato con uno stop bassissimo, bassissimo 160 euro mi porta a casa a meta' posizione"* | c.18444-18480 | `[TRASCRITTO dubbio]`: la cifra potrebbe essere il rischio residuo o altro. *"in prima istanza io lì lo faccio sempre perché siamo in un contesto di pochi volumi"* (c.18749) e' chiaro |
| P12 | **Volumi, breakout** | un breakout regge solo con **volumi "incrementali" che superano quelli del livello**; altrimenti *"potrebbe essere un fake breakout"* | *"per essere dei volumi incrementali devo superare questi, quindi potrebbe essere un fake breakout"* | c.23078 | chiaro; **TF e strumento del volume NON dichiarati** (sul DAX = volume di tick `[INFERITO]`) |
| P13 | **Volumi, secondo contatto** | **seconda volta sul livello = piu' rischioso**; **volumi decrescenti = si puo' ri-entrare**; **crescenti = "operazione da andarsene"** | *"e' la seconda volta... io devo entrare con meno"* · *"i volumi decrescenti... posso farlo ancora"* · *"i volumi stanno aumentando... e' un'operazione da andarsene"* | c.23255, 23591; c.24657; c.35782-35970 | chiaro. **Nessuna inversione** in questa live (le righe 233-235 del 30/09 erano dubbie: qui 0 casi di "crescenti = rallenta") |
| P14 | **Secondo giro** | *"entro con meno... altri 10 punti vi porto a casa altri 5... altri 5 contatti, con uno stop... stretto"* | | c.24006-24200 | chiaro il senso; **poi NON lo fa** (B-nota sotto) |
| P15 | **Scalping** | **6 punti = 12 EUR**; ordini secondari *"di 8 o 4"* (punti? contratti? `[NON CHIARO]`); **stop "sempre"** e *"determinato sui massimi precedenti"* | *"6 punti prendo e mi porta a casa i 12 euro... sempre con lo stop"* | c.34460, 34535-34650, 33536 | chiaro sui 6-12; il resto `[NON CHIARO]` |
| P16 | **Trading range** | diviso in **parte bassa e parte alta**; dentro *"si può fare scarto [= scalping `[INFERITO]`] non tengo più le posizioni posso uscire rientrare"*; *"prima o poi esce il training range ovviamente"* | | c.875-1100; c.32721-33150 | chiaro; **nessuna soglia** |
| P17 | **Livelli d'ingresso** | **max/min del giorno precedente**; **numeri tondi**; zona di pre-section | *"noi abbiamo detto quali sono i massimi e i minimi del giorno precedente"* | c.14980-15040 | chiaro; manca il "notturno" del 30/09 |
| P18 | **TF citati** | weekly, daily, **H1** (*"scendiamo in H1"*); i volumi "in proiezione" = candela in corso | | r.23; c.4241-4400; c.13134-13170 | chiaro; **nessun TF dichiarato per l'ingresso** |
| P19 | **NFP - primo movimento EURUSD** | **~60 pip** (3 volte), *"poi... prende il direzione"* | vedi N8 | c.31097-31300 | chiaro; **metodo/campione/periodo/orizzonte NON dichiarati**; pip di EURUSD non confrontabili 1:1 con quelli di USDJPY senza i prezzi (che qui non ci sono) |
| P20 | **NFP - AUDJPY** | **30, 40, 50 pip**, short e long, *"torna al suo punto di partenza"* | vedi N9 | c.31383-31720 | chiaro sul numero, **incoerente sulla geometria** (§1.4) |
| P21 | **NFP - sistema storico** | **7 strumenti**, ordini pendenti; **~600 persone**; attese di *"10, 20, 30k"* | vedi N10-N11 | c.27403; c.27764; c.30206 | chiaro il numero; **contesto NON dichiarato** |
| P22 | **NFP - piano di oggi** | **EURUSD e oro**; EURUSD *"10 modeste"*; oro *"3 o 4"*; *"stop di 2.500 euro per farne un doppio"* | vedi N13 | c.41082-41400 | strumenti chiari; **taglie senza unita', stop incomprensibile** |
| P23 | **Notte** | *"una volta che sai che dal 1 al 2 non c'è liquidità e che si deve si muove dalle 3 di notte e che spesso si mette laterale e quando si mette laterale entri"* (e prima: *"prima gli stessi male lavoravano dal 1 al 2 di notte"*, **al passato**) | | c.29185-29480 | **ora senza fuso**, riferimento `[INCERTO]`: non lo converto |
| P24 | **"Dalle 6 del pomeriggio"** | una **domanda** di un partecipante (strategie dalle 18 in avanti); **la risposta non e' intelligibile** (*"diventa una figata lavorare in televisione"*, c.28700) | | c.28640 | **nessun parametro estraibile** |
| P25 | **Esperienza dichiarata** | **26-27 anni** sul DAX; *"non ha commissioni"* (suo giudizio sul DAX) | *"negozio sullo strumento da ormai 26 anni 27 anni"* · *"a me piace tradare il DAX perche' non ha commissioni"* | c.6752; c.6541-6600 | chiaro; **dichiarazioni**; il costo vero si misura da noi (spread/commissione per broker) |
| P26 | **Esito dichiarato** | **+2.700 EUR**, poi *"2.500 euro molto corto"* (= in poco tempo `[INFERITO]`) | *"2700 euro e' il profitto... la chiudo in positivo 2.500 euro"* | c.40702-40860 | **le due cifre sono diverse** (STT o due chiusure): `[TRASCRITTO dubbio]`; non e' chiaro se sia **una** operazione o la mattina; **nessun importo del rischio** |

**Derivazioni mie, tutte `[DERIVATO]` e con le ipotesi scritte:**
- **Valore del punto:** *"6 punti ... 12 euro"* (c.34460) implica **2 EUR/punto**; con 20 contratti = **20 EUR/punto** **solo se**
  ogni contratto vale 1 EUR/punto (**NON dichiarato**). Con questa ipotesi: stop 60 punti = ~1.200 EUR di rischio, 100 punti = ~2.000 EUR,
  e +2.500/2.700 EUR e' coerente con 20 contratti per ~100-130 punti. **Il capitale non e' detto: la % di rischio NON e' calcolabile.**
  Se l'ipotesi e' sbagliata, tutto questo cade.
- **Nessun numero di questa tabella e' una soglia nostra.**

## 2.4 MECCANISMI (22, in ordine di apparizione)

| # | meccanismo | come descritto | posizione |
|---|---|---|---|
| M1 | **Scelta dello strumento al mattino con la dashboard**: weekly e daily nella stessa direzione, forza valuta per valuta | *"prima cosa, scegli lo strumento"* (r.27) · *"non è che dobbiamo negoziare sempre e solo sul DAX"* (c.6339) | r.23-27; c.1679; c.6339 |
| M2 | **In giorno NFP: mercato attendista, niente movimento di estensione prima del dato** | vedi N4 | r.35; c.3857 |
| M3 | **In giorno NFP: si entra solo se si rompono livelli tondi con volumi** | vedi N5 | c.179-360 |
| M4 | **Scenari A/B e "paletti"**: con situazione incerta *"devo trovare dei paletti"* (analisi tecnica, supporti/resistenze) | *"io in questo caso devo andare a immaginare che cosa può fare il mercato se il mercato fa A cioè si sale io faccio B l'opposto"* | c.7300-9300 |
| M5 | **Ingresso long al numero tondo, all'apertura, nella direzione del daily** quando c'e' un floor sotto | *"io tendenzialmente cercherei di andare in apertura nella direzione del Daily perche' qua sotto c'e' un floor"* | c.10308-10500 |
| M6 | **Sondaggio del pubblico prima dell'ingresso** | *"quanti di voi entrerebbero in Longer giusto per capire se siamo in linea o no"* | c.10501, 10860 |
| M7 | **Ingresso a due livelli**: meta' sul tondo, meta' sul minimo della candela precedente, stop sotto | vedi P7 | c.11800-12200 |
| M8 | **Liquidare la parte "vicina" e tenere quella "sotto"** quando il prezzo torna al livello | *"io liquido la posizione a 25 mila e tengo soltanto la posizione sotto"* | c.13373 |
| M9 | **Meta' posizione a casa + stop in pari**, *"un'operazione dove posso solo guadagnare"* | vedi P10 | c.14088-14500 |
| M10 | **Stop bassissimo dopo il parziale in contesto di pochi volumi** | vedi P11 | c.18444-18900 |
| M11 | **Volumi come filtro del breakout / del falso breakout** | vedi P12 | c.23078 |
| M12 | **Seconda volta sullo stesso livello = piu' rischioso -> meno quantita'** | vedi P13 | c.23255-23607 |
| M13 | **Rinuncia al secondo giro** per prudenza (*"vi devo insegnare a fare che cosa ad aspettare"*, *"io ritengo che sia più pericoloso adesso"*) | | c.26056-26296 |
| M14 | **Scalping dentro un trading range** con stop tecnico su livelli importanti, "avanti e indietro" | vedi P15-P16 | c.32721-36700 |
| M15 | **Spike senza volumi = "vuoto di mercato"**: non perdere la calma, chiudere | *"questo era un vuoto di mercato"* | c.39500-40200 |
| M16 | **ORB come livello** e stop sotto il livello | vedi P1, P4 | c.37210-37900 |
| M17 | **ORB non in giorno NFP** | vedi P3 | c.18053 |
| M18 | **Studio del weekend** ("attaccare i pezzettini del domenica") per capire l'inizio della settimana | *"aspettare per diciamo il domenica... l'evoluzione"* | c.7114 |
| M19 | **Specializzazione sullo strumento** | *"quando prendete uno strumento finanziario qualsiasi andate a prendere la coppia di questo strumento finanziario e aspettare..."* | c.6900-7300 |
| M20 | **NFP storico: pendenti su 7 strumenti** | vedi N10 | c.30131 |
| M21 | **NFP: primo movimento 60 pip su EURUSD** | vedi N8 | c.31097 |
| M22 | **NFP: AUDJPY reversa** | vedi N9 | c.31321 |

## 2.5 I RISULTATI DICHIARATI (tutti [dichiarato, NON verificato], mai come criterio)

| cosa | valore | nota |
|---|---|---|
| DAX di questa mattina | **+2.700 / +2.500 EUR** (c.40702, c.40819), **60 punti poi 100 punti in un quarto d'ora** (c.16674, c.19832) | **cronaca di una mattina, un solo regime, un solo giorno**. Rischio in % non dichiarato. Le cifre non coincidono fra loro (STT?) |
| Altri trade | tutti senza esito scritto (scalping nel range, short sul tondo, rinuncia al secondo giro) | |
| NFP | **nessuno** | non ne ha fatto in questa live |

## 2.6 REGOLE PROP CITATE

**Nessuna. Zero.** (§1.6.)

## 2.7 BANDIERE ROSSE

| # | bandiera | citazione che la prova | posizione | grado |
|---|---|---|---|---|
| B1 | **Ordine d'ingresso senza stop visibile, 20 contratti** | *"adesso non vedo l'ordine lo stop, devo mettere lo stop dal punto di vista tecnico"* | c.11614-11680 | **ARANCIONE** (stessa classe del B1 del 30/09). **`[INCERTO]` se lo stop mancasse davvero o fosse solo non visibile a schermo**; lo mette in meno di un minuto |
| B2 | **Scale-in sotto + stop spostato piu' in basso dopo la rottura del livello** | *"ha gia' rotto i minimi della candela precedente e va giu'... i 25 mila quindi si e' rinunciati, quindi lo stop lo metto sotto... il secondo lo e' aspirato quindi devo necessariamente portarlo sotto, quindi ho preso un range abbastanza ampio"* | c.12863-13300 | **ARANCIONE**: due parti d'ingresso a livelli diversi (mediazione **pianificata**, non martingala) **e** uno stop **allargato** a livello perso; poi la parte alta viene liquidata al ritorno ("recuperare i 25 mila"). Il passo `[TRASCRITTO dubbio]` sul *cosa* sia "aspirato" |
| B3 | **"Quando non ci capisco aumento il size"**: lettura letterale | *"tendenzialmente quando non ci capisco bene all'inizio aumento il size, no, vengo come normalmente, no"* | c.8226 | **ARANCIONE-AMBIGUA**. La frase e' **spezzata**: puo' essere affermativa ("aumento il size") o **domanda retorica con risposta negativa** ("aumento il size? no, vado come al solito"). **Controprove nel testo che puntano alla seconda lettura**: *"io devo entrare con meno quantita', perche' qua diventa piu' rischiosa"* (c.23591), *"entro con meno"* (c.24006), *"quantita' standard modeste"* (c.41177), e il 30/09 *"gioco in difesa"* e size ridotte. **Non si decide da qui: va chiesto** (§6 Q4) |
| B4 | **"Se mi scappa entro"** + entrare **prima dell'apertura** | *"quanti entrerebbero in Longer e se mi scappa io qua potrei entrare sempre prima dell'apertura come qualcuno ha fatto l'altro giorno in realtà il rischio in questo caso è ancora moderato"* | c.10864-11000 | **ARANCIONE**: ingresso "per paura che scappi", giustificato col rischio moderato **a stima**. L'"altro giorno" = i colleghi del 30/09 `[INFERITO]` |
| B5 | **Improvvisare quando non c'e' la strategia** | *"quando andro' a lavorare la mattina con delle strategie piu' precise, e se non c'e' la strategia invento"* | c.9293 | **ARANCIONE** `[TRASCRITTO dubbio]`: contraddice il suo stesso "piano scritto prima" (M1 del 30/09). Frase spezzata |
| B6 | **AVVERTENZA ROSSA STORICA: pendenti NFP su 7 strumenti, "tutto per scontato", clienti bruciati** | vedi N10-N11 | c.27300-30330 | **ROSSA come avvertenza, NON come pratica di oggi**: racconto autodichiarato di un fallimento di **quell'architettura**. **Non e' una pratica che oggi propone**; oggi *"leggero"* con *"qualche accorgimento"* **mai detto** |
| B7 | **Scalping "avanti e indietro" senza tetto al numero di operazioni** | *"puoi fare avanti e indietro tutte le cose che vuoi"* · *"20 volte avanti e indietro, 1, 2, 3, 4, 5 volte"* | c.33957; c.36658 | **AMBRA**. ⚠ **Correzione al mandato**: nel testo lo scalping e' **sempre con lo stop** (*"sempre con lo stop"*, c.34650; *"io preferisco sempre avere lo stop"*, c.35171). **La parte "senza stop" NON c'e' scritta**; resta l'assenza di un limite al numero di ingressi |
| B8 | **Vittoria presentata come prova** | *"e' veramente facile"*, *"100 punti d'azio [= DAX `[INFERITO]`] in un quarto d'ora brava gente"*, *"ragiono poco ma lo ragiono bene"* | c.19832-20080; c.21589 | **AMBRA**: n = 1 mattina |
| B9 | **Rischio "veramente basso" non misurabile** | *"60 punti d'Axe dove il rischio è stato veramente basso"* con 20 contratti e stop ~60 punti | c.16674 | **AMBRA** `[DERIVATO]`: con l'ipotesi del §2.3 il rischio era ~1.200 EUR; il capitale non e' detto, quindi **"basso" non e' verificabile** |

**Trucchi anti-prop: 0.** Niente da documentare come intelligence.

## 2.8 COSA C'ERA A SCHERMO E NON NEL PARLATO (da chiedere a Claudio)

| # | cosa | perche' serve | posizione |
|---|---|---|---|
| S1 | **La geometria dell'ordine AUDJPY**: *"questo e' il livello di prezzo e questi sono 60 pip, come qua mettiamo l'ordine short"* | senza lo schema non si sa **dove** sta l'ordine rispetto al livello pre-dato, ne' se e' un fade | c.31535-31700 |
| S2 | **La slide/tabella dello studio di "Francesco"** sul range medio post-NFP per strumento | e' la fonte dei 60 pip e del "reversa"; **gia' parte del corso**: *"se vi ricordate"* | c.30927-31445 |
| S3 | **Grafico DAX di stamattina** con 25.000, 25.100, il minimo "della candela precedente", il livello ORB | l'ora, il TF e i livelli reali: tutto l'entrata/uscita e' sul grafico | c.10200-20000 |
| S4 | **Il pannello ordini** (entrata, stop, target, lotti) | stop/size/volumi veri; qui sono `[TRASCRITTO dubbio]` | c.11600-14000 |
| S5 | **Gli indicatori dei volumi in "proiezione"** (e "move up", "Poc") | senza nome non si traducono | c.23078; c.37405; c.41776 |
| S6 | **La "comunicazione scritta" che promette di mandare** (*"vi mando la comunicazione scritta"*) | puo' essere il suo piano NFP | c.40858 |

## 2.9 COSA NE COPIAMO

**Niente come regola, niente come parametro.** Quello che si prende sono **domande e misure** (Parte 5). I numeri sono
dichiarati e senza campione; la regola dei 60 pip e il "reversa" **non hanno geometria completa** nel parlato.

---

# PARTE 3 - SCARTI (cio' che non e' estraibile)

- **Introduzione e regia** (r.1-21): battute, ritardi, chi c'e'/non c'e'. Zero contenuto.
- **La spiegazione "trading range"** e le frasi generali sul mercato laterale (c.800-1400, c.7100-7300): descrittive, **nessuna
  soglia**; resta in M12/M14 come meccanismo.
- **L'analisi weekly/daily del DAX e dell'oro** (c.1700-9300): lettura di grafici, i numeri parlati sono storpiati
  (*"800 300 punti"*, c.8024, `[NON CHIARO]`).
- **Frasi spezzate attorno a "dalle 6 del pomeriggio"** e **dopo il saluto** (c.41500-43696): vedi P24 e N14-N16.
- **Battute e commenti con i partecipanti** (la moglie di Cristian, ecc.): scartati.

---

# PARTE 4 - RAPPORTO CON LE SCHEDE DEL 30/09 E DEL 01/10

Fonti: `report/SCHEDA_LIVE_EMILIANO_2026-09-30.md`, `report/SCHEDA_LIVE_PAOLO_2026-10-01.md`, questa.

| tema | 30/09 Emiliano | 01/10 Paolo | 02/10 Emiliano | si ripete / cambia |
|---|---|---|---|---|
| **Piano scritto prima, scenari, cascata multi-TF** | M1-M2 | V22 D1->H4->H1->M15 | M1, M4: dashboard, weekly/daily, scenario A/B | **si ripete** |
| **Il livello d'ingresso** | max/min **notturno** + EMA200 + Supertrend + gap | EMA200 **D1** come linea | **numero tondo 25.000** + max/min **del giorno precedente**; **zero indicatori** | **CAMBIA**: cade l'EMA200 e cade il box notturno |
| **Quando entrare** | pre-apertura 08:30 a piccola size; all'apertura se *"parte proprio con decisione"*; dopo l'ORB | non entra *"in prossimita' dell'apertura del mercato"* (V1-3.3) | **long all'apertura sul tondo**; sondaggio il *"se mi scappa"* con ingresso prima dell'apertura | **si ripete con Emiliano, contraddice Paolo** (Paolo: no vicino all'apertura): due docenti, due regole |
| **Gestione** | parziale + pari **ogni 20 punti** (P3) | parziale + pari + trailing struttura | **meta' posizione + pari + stop bassissimo** | **si ripete** (stessa ricetta), cambiano le soglie (qui in contratti, non in punti) |
| **Volumi** | P13, con una **inversione dubbia** (r.233-235) | *"e' sceso senza volumi"* (Paolo r.33) | P12-P13 **senza inversioni**: decrescenti -> fade, crescenti -> uscire | **si ripete e si CHIARISCE**: il dubbio di inversione del 30/09 **non compare** oggi |
| **ORB** | cita l'ORB senza durata | ORB M5, candela che apre e chiude fuori; no vicino all'apertura | **"nel 2015"** (09:15 `[INFERITO]`) + "alle 9" senza valore aggiunto + **no su NFP** | **si ripete**; **per la prima volta** un indizio d'orario (**e e' un indizio, non un dato**) |
| **NFP / news** | M18: *"guardare le news"*, senza ora ne' numero | V17-V18: ORB no, dopo il rilascio, scalping a 10 punti | N1-N16: calendario; no ORB; **60 pip EURUSD**; **AUDJPY reversa**; storia dei pendenti; oggi EURUSD+oro leggero | **si ripete il nocciolo** (aspettare, ORB no, leggero), **cambiano 3 cose nuove**: la statistica dei 60 pip, l'AUDJPY, e la storia del sistema vecchio |
| **Taglia in incertezza** | *"gioco in difesa"* e size ridotte | non dichiarata | *"quantità standard modeste"* ma anche *"aumento il size"* (ambiguo, B3) | **si ripete**, con un'ambiguita' nuova |
| **Freno dopo gli stop / tetto giornaliero** | P8, M17: 3 stop di fila + target finanziario | nessuno (§3.3) | **nessuno**: *"lo stop"* e' citato 46 volte, mai un limite giornaliero | **non si ripete** |
| **Cost to cost / trading range** | Larry Williams, bande orizzontali | - | *"mi sono fatto il cost to cost"* (c.18646), *"stop non su cost to cost"* (c.37713), **trading range alto/basso** | **si ripete**; qui e' il **movimento fra due livelli**, non l'indicatore |
| **Controtendenza** | B3 del 30/09 | - | **long di rimbalzo** dopo un movimento ribassista arrivato su un supporto (*"movimento importante di bassista arrivato su un livello di supporto... ho dato piu' importanza a un rimbalzo tecnico"*, c.16900-17150) e **short sul tondo** (c.38244-38600) | **si ripete** |
| **Stop mancante** | B1 | ambiguo r.179 | **B1** | **si ripete** (classe) |
| **Chi opera** | colleghi | Paolo (e un allievo) | **Emiliano da solo** | cambia l'osservatore |

---

# PARTE 5 - PROPOSTE DI MISURA (nessuna eseguita, nessuna decisione, nessun criterio nuovo)

Ordine di valore per **una sedia schierabile** (che e' bassissimo qui: l'NFP e' ~12 eventi/anno). Per ognuna: **attesa e
contro-esempio scritti PRIMA di qualunque numero**; **costo**; i round girano **solo sul PC di backtest**.

### M-N1 - AUDJPY dopo l'NFP: studio di eventi, **con l'attesa NEGATIVA scritta prima** (priorita' 1, solo se i dati ci sono)
- **Domanda:** su un NFP, il prezzo di AUDJPY **rientra al livello pre-dato** dopo il primo impulso **piu' spesso** di quanto fanno
  le altre coppie e di quanto farebbe un movimento casuale **con la stessa volatilita'**?
- **Come non barare con la finestra** (la trappola dell'"unica valuta"): **orizzonte e livello li prendo dalla NOSTRA sedia, non da
  lui e non da AUDJPY**: il primo impulso si misura **al 14:40 IT** (chiusura dell'ultima delle due candele di riferimento del 771203) e
  il "ritorno" e' "prezzo pre-dato (chiusura della candela 14:25-14:30 IT) toccato entro le 17:59 IT" (la scadenza dei nostri
  pendenti). **Una sola definizione, congelata prima, senza scansione.**
- **Insieme da confrontare, elencato per nome:** AUDJPY, USDJPY, EURJPY, GBPJPY, EURUSD, AUDUSD `[da confermare quali hanno M1 sul PC di backtest]`.
- **Controlli:** (a) **stesso orario su giorni NON-NFP** (la base casuale e' reale); (b) **random walk con la stessa volatilita'**;
  (c) la **deriva di carry** di AUDJPY tolta (confronto per direzione dell'impulso).
- **Attesa (scritta ora):** **NESSUNA asimmetria**: AUDJPY **dentro la banda delle altre coppie e del random walk**, e il fade,
  convertito in R **netto di spread**, sotto il cancello (come il fade post-notizia gia' in lapide su EURUSD/oro).
- **Contro-esempio (cosa mi smentirebbe):** AUDJPY **sopra la banda superiore delle altre coppie** e **sopra la base non-NFP**
  in **almeno due finestre di regime**, con **n >= 40 per finestra** (186 NFP in tutto, `[LETTO nel preset]`: ~45 per finestra da 4 anni:
  **sul bordo**). Se succede, e' un'asimmetria **non un'inversione**, e si passa al secondo passo (convertire in R).
- **Costo:** **zero passate di tester**. Python su M1 + il calendario `mql5/Files/abtg_news_postnews_2010_2025_UTC.csv`
  (UTC, 186 disoccupazioni USA 2010-2025 `[LETTO nell'intestazione del preset]`). Il difetto DST gia' misurato (10 NFP su 186 cadono alle 13:30 IT invece che
  alle 14:30, tutti di novembre) riguarda l'**ora fissa del preset**, non il calendario UTC: per lo studio basta ancorare t0 all'orario UTC reale di ogni evento. **Prima domanda per Claudio (§6 Q2):** quali M1 di AUDJPY/USDJPY esistono. La sonda esterna del 05/09 **non ha USD_JPY** (404)
  e di AUD_JPY **non so**. Ore, non giorni. **Non e' un candidato, non entra nell'imbuto.**
- **Limite dichiarato:** campione che sospende il MERITO (< 150): si giudica il **rischio e la forma**, non il profitto.
  **Certificato di morte:** se l'attesa regge, **NON e' un archivio**: mancherebbero *gestione dell'uscita, simboli gemelli, TF*.

### M-N2 - I "60 pip" contro il nostro contratto 771203 (priorita' 2, stesso studio, costo marginale ~0)
- **Domanda:** su USDJPY, **quanta parte dell'escursione dei primi 10 minuti e' gia' consumata prima che la sedia armi?**
  (la sedia piazza alle 14:45 IT con TP 30 pip: se l'impulso medio e' molto piu' largo dei 30, il TP cade dentro il primo movimento).
- **Attesa:** i **60 pip su EURUSD** (N8) **non si trasferiscono** su USDJPY **senza i prezzi** `[NON CONVERTIBILI qui]`; la misura
  si fa **sul simbolo della sedia, in pip suoi**. Contro-esempio: se l'escursione mediana a +10 minuti su USDJPY e' **gia' >= 30 pip**,
  il TP della 771203 **e' dentro l'impulso gia' esaurito**: **informazione sul contratto, non una decisione**.
- **Costo:** **zero tester**; i dati sono gli stessi di M-N1.

### M-N3 - Volumi decrescenti come condizione del fade al secondo contatto (priorita' 3, **gia' in parte in casa**)
- **Gia' misurato in casa:** il filtro volumi sul `770101` **migliora IS e OOS** ma e' **selezione, non gestione**
  (`ALZARE_IL_PF_2026-09-22.md` r.349: uscite 270 -> 150 -> 96 -> 62). **Il verso opposto che dice Emiliano (fade a volumi
  decrescenti al *secondo* contatto) non e' mai stato messo ad asse** `[NON VERIFICATO fino in fondo]`.
- **Attesa:** come per M-2 del 30/09: **il fade a livello senza vantaggio rispetto al casuale a pari frequenza**. **Non apro un
  round**: solo la lista, **dopo** M-N1.

### Cosa NON propongo
- **Niente sulla 771203** (resta com'e': cieca, fuori dal trial).
- **Niente "AUDJPY reversa" come sedia** e niente griglia sui suoi parametri (regola del 19/08).
- **Niente sul filtro news dei preset FTMO**: e' una decisione di Claudio e c'e' gia' la nota (`NFP_2026-10-02_SEDIE_TRIAL.md`).

---

# PARTE 6 - LE DOMANDE PER CLAUDIO (che conosce Emiliano di persona)

1. **La slide/tabella di "Francesco"** (range medio post-NFP per strumento): **e' del corso**. Il 03/09 avevi portato le slide
   pag. 140-143 sull'NFP USDJPY: la tabella sugli altri strumenti e l'AUDJPY e' **li' vicino**? (S2)
2. **Dati M1 di AUDJPY, USDJPY, EURUSD sul PC di backtest `DESKTOP-H4D7CAJ`** (o altrove): copertura 2010-2025? (serve a M-N1)
3. **Che "accorgimento" ha preso per gli NFP?** (N12) - cambiano gli ordini, la taglia, l'ora, o il filtro? Vale una domanda diretta a Emiliano.
4. **"Quando non ci capisco aumento il size?"** (c.8226) - e' una frase **affermativa o una domanda retorica**? Le controprove del testo dicono la seconda,
   ma e' una bandiera troppo importante per lasciarla a un'interpretazione.
5. **Lo "speciale NFP" di oggi** (N14): **e' andato**? Se si': **e' la prima volta che si vedrebbe Emiliano operare l'NFP** (EURUSD e oro,
   *"leggerissima"*). Quella trascrizione varrebbe piu' di questa.
6. **L'orario del "nel 2015"** (P1): conferma che e' **09:15 IT** e che il range ORB e' **9:00-9:15**? E il **TF** della "candela precedente" dove mette la seconda
   parte (P7)?
7. **Esito del 02/10 mattina sulle sedie DAX del trial** (`770411` / `770105` / `770101` se attaccata): per affiancarlo alla mossa che Emiliano descrive
   (calo sotto 25.000, poi risalita di ~100 punti in un quarto d'ora **`[dichiarato]`**). **Stessa idea del M-1 del 30/09**: n = 1 giorno, e' una **domanda**, non un'evidenza.
8. **Screenshot/pannello ordini di Emiliano** al minuto del suo ingresso (S3-S4): stop, lotti, TF.
9. **Gli indicatori citati senza nome** ("move up", "Poc", i volumi "in proiezione") (S5): quali sono nel suo template.

---

## Chiusura

- **Niente e' stato eseguito.** Nessun preset in campo, nessun EA, nessun conto (reale `10105439`, trial `1514806751`), nessun parametro di
  rischio. Nessun numero della live e' diventato criterio.
- **Dichiarato come ponteggio:** questa e' una **scheda di lettura**, non un avanzamento verso una sedia. La parte NFP **non apre** una
  sedia: il 771203 resta `[NON MISURATO]`, cieco e fuori dal trial; l'unica voce che puo' avvicinare qualcosa e' **M-N1**, e **solo come
  studio di eventi con attesa negativa**.
- **Il dato piu' solido** non e' di Emiliano: e' che **due docenti dello stesso corso dicono la stessa cosa sull'NFP** (aspettare, ORB no, leggeri).
  **Convergenza non indipendente**: la sedia 771203 nasce dalla stessa scuola.
- **Fonti lette:** `data/trascrizioni/LIVE_EMILIANO_2026-10-02.txt` (intera) - `report/SCHEDA_LIVE_EMILIANO_2026-09-30.md` -
  `report/SCHEDA_LIVE_PAOLO_2026-10-01.md` - `report/NFP_2026-10-02_SEDIE_TRIAL.md` - `mql5/Presets/ABTG_PostNews_NFP_USDJPY.set` e
  `..._771203_FTMO.set` - `report/PACCHETTO_POSTNEWS_TRE_GRAFICI_2026-09-19.md` - `report/CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md` (r.70) -
  `backtest_pipeline/caccia_strategie/CACCIA_POSTNEWS_MECCANISMI_2026-09-05.md` - `backtest_pipeline/REGISTRO_TEST.md` (lapide POSTNEWS r.1571-1577; r.2816-2830) -
  `docs/live_emiliano/ANALISI_LIVE_luglio.md` (r.28-35) - `docs/live_emiliano/ANALISI_LIVE_storico.md` (r.25) - `report/ALZARE_IL_PF_2026-09-22.md` (r.349) -
  `report/ANALISI_LIVE_EMILIANO_2026-09-28.md` (testata). **Non letti:** i CSV per-trade delle sedie DAX, i dati M1 di AUDJPY/USDJPY, gli statement del 02/10.
