# ANALISI LIVE EMILIANO - 07/10/2026 (mercoledi' mattina: "analisi del DAX con Luca, apertura sotto il livello, short sul VWAP/numero tondo, retest con la stessa size, oro e ORB")

**Stato: passata dal cancello il 07/10/2026** (strato 1 `controlla_riga.py --oggetto md` verde; strato 2 `controllo-preventivo`: **PASS CON RISERVE dopo correzioni**, elenco in fondo).
**Fonte unica:** `data/trascrizioni/LIVE_EMILIANO_2026-10-07.txt` (211 righe per `cat -n`, 53.013 byte, trascrizione automatica TurboScribe).
Letta per intero, riga per riga. Nessuna navigazione, nessun completamento da memoria: dove cito il repo lo dico col file.
**Analista:** agente `analista-trascrizioni`, 07/10/2026.
**Come si leggono i riferimenti:** `r.NN` = numero di riga `cat -n`. **La trascrizione non ha timestamp.** **Tre righe sono enormi**: r.169 (~5.000 caratteri), r.191 (~13.500) e r.193 (~6.000); quando cito
una di queste aggiungo la frase, perche' il solo numero non basta a ritrovare il punto (la registrazione resta la fonte per riascoltare).
Le citazioni sono **verbatim**, con le storpiature STT lasciate com'erano ("dash" = DAX, "Wiki" = weekly, "dei" = daily, "WAP/VVAP/move up" = VWAP, "ordi impedenti" = ordini pendenti,
"bassista" = ribassista); le sciolgo solo in §2.1.

> ## REGOLA CHE VALE SOPRA TUTTO
> **Da questo materiale non si muove NIENTE.** Ogni numero qui dentro e' una **dichiarazione di una fonte esterna** `[DICHIARATO, NON verificato]`, mai un criterio nostro.
> Nessun preset, EA, conto, sedia, forward o VPS e' stato toccato; nessun round lanciato; niente e' stato mandato a Claudio. Le "proposte di misura" della Parte 4 sono **specifiche**,
> non file prova e non righe di lancio: passano dal cancello prima di esistere e i round girano **solo sul PC di backtest**.

Etichette: **[TRASCRITTO]** c'e' scritto (cito) · **[TRASCRITTO dubbio]** c'e' scritto ma puo' essere un errore di trascrizione · **[INFERITO]** lo deduco (dico da cosa) ·
**[INCERTO] / [NON CHIARO]** non lo so e non lo deduco · **[DICHIARATO, NON verificato]** numero o affermazione del relatore · **[DERIVATO]** calcolo mio da numeri scritti, formula nel testo ·
**[LETTO nel repo]** viene da un file nostro, col nome · **[MISURATO]** numero nostro con il file · **[NON MISURATO]** il dato non c'e'.

**Orari.** La trascrizione **non dichiara mai il fuso**. Emiliano dice *"manca un quarto d'ora all'apertura"* (r.23), *"mancano pochi minuti all'apertura"* (r.83) e, in r.193, *"sono le 9.56, mancano quattro minuti alla chiusura della candela"*:
coerente con l'apertura cash del DAX alle 09:00 **ora italiana** `[INFERITO]`, non dettata come tale. **Non converto nessun orario del parlato.** Promemoria per chi legge: il 07/10 l'Italia e' ancora in ora legale, quindi
il server BCM e' **un'ora indietro** rispetto all'Italia `[DERIVATO da report/OROLOGIO_BCM_2026-09-24.md]` (dal 26/10 non piu').

---

# PARTE 1 - LA SINTESI (la pagina che si legge per prima)

## 1.0 La riga che conta

> **Su 211 righe: 32 parametri con valore (nessuno e' una regola completa e verificabile), 27 meccanismi, 10 bandiere (ZERO rosse piene; 5 arancioni; 5 ambra), ZERO regole prop, ZERO trucchi anti-prop,
> ZERO numeri di P/L in euro.** E' una live **operativa dal vivo** (DAX in apertura) con un **allievo, Luca, che apre con l'analisi** (r.3-27) ed Emiliano che poi **opera e commenta** (r.89-205).
> **Il pezzo che fa piu' differenza per noi sono TRE meccanismi di gestione, nessuno misurato** ((1) e (2) in prima persona da Emiliano; (3) in parte dal piano di Luca):
> **(1)** **retest con la STESSA size del primo ordine**, ammesso solo se *"hai gia' un fieno in cascina"* (r.169-171: *"se avevo 10 mettevo 10, se avevo 20 mettevo 20, la stessa size identica"*): **re-entry dopo profitto parziale**;
> **(2)** **chiudere meta' della posizione in profitto per pagare la perdita dell'altra gamba** (r.161: *"togli una quantita' tale dal tuo ordine in Profitto, tale per cui ti copre la perdita"*): *"Io lo faccio quasi sempre"* (r.163);
> **(3)** **scala di ordini a size diversa secondo la qualita' del livello** (r.69, **Luca**: *"2-4 fa 6, 10"*; r.91 *"dieci contratti"*; r.99 tondo senza confluenza = *"quantita' inferiore"*; r.191 *"questa da venti questa e' da dieci"*), parente della scala 2-4-10-20 del 05/10 (r.209: *"entro con 10, con 20 ... l'ordine civetta"*).
> Nessuno e' un hedging (**l'hedging di r.235-243 del 05/10 qui NON c'e'**). **(1) e (3) sono parenti del re-entry/scale-in: arancioni; (2) riduce l'esposizione, non la aumenta: ambra** (§2.7). Sono **gli opposti** del nostro modello (un ciclo/giorno per sedia, rischio in % del conto, un solo stop).
> **Il secondo pezzo NON e' una contraddizione fra live (verificato alla fonte):** il 05/10 (Tommy, r.141-155) la regola e' *"candela importante [tra le 8 e le 9] ... arriva sul livello importante. In prima istanza in apertura scarica sempre in direzione opposta"*;
> il 07/10 la stessa regola e' **richiamata** (r.63: *"quando fa queste candele importanti, o di discesa o di salita, in apertura se le rimangia"*) e la mattina la **segue**: pre-apertura gia' -50/60 punti (r.23, r.37) sul supporto (r.43),
> apertura, **rimbalzo** fino a VWAP/tondo (r.121-135: *"non mi scrittavo neanche che aprendo sotto potesse rimbalzare in questa maniera"*), poi lo short *"aperto sotto un livello di resistenza"* (r.123) **dalla resistenza**.
> Le due frasi parlano di **due momenti diversi** (primo scarico, poi direzione) e si compongono. Resta **n = 1 mattina**: coerenza, non misura.
> **Il terzo pezzo e' una convergenza di forma con la nostra misura piu' solida:** il **retest** (*"i livelli li va sempre a ritestare, per definirli"*, r.169; *"il retest e' il momento in cui puo' rientrare"*, r.171) e' il motore che nel repo
> **vive** mentre il breakout nudo e' chiuso (`report/CENSIMENTO_ORB_2026-09-29.md` §0.3; `report/DIARIO.md` r.87: *"RETEST ✓ re incontrastato"*). **Non indipendente** (stessa scuola).

## 1.1 Che cosa e' questa live, e che cosa NON e'

- **Chi parla:** Emiliano (host) e **Luca** (allievo, ripetutamente lodato: *"Luca ... mi hai fatto pulita, leggera, senza fronzoli"*, r.115); in chat/voce: Mattia, Silvia, Valerio, Giuliano, Consuelo, Dario, Cristian, Kevin, **Ban/"Bani"**, Giro/**Girolamo** (autore di un sistema sui numeri tondi), Vale. **Paolo non c'e'**: e' citato (*"Luca mi ha cercato ieri Paolo"*, r.191).
  In r.195 un partecipante gli dice *"Paolo, mi sta bene"*: errore STT sul nome `[INFERITO]`.
- **Quando:** **mercoledi' 07/10/2026 mattina** (*"siamo anche a mercoledi', siamo a meta' settimana"*, r.11). Comincia ~**un quarto d'ora prima dell'apertura** (r.23) e arriva almeno a r.193 (*"sono le 9.56"*) `[INFERITO: ora italiana]`.
- **Non e' una prop.** Zero `prop`, `FTMO`, `funded`, `challenge`, `drawdown` (verificato `grep`: le 29 occorrenze di "prop" sono "proprio"/"proprieta'"; **0** come parola intera).
- **Qualita':** media. Il passo r.191 (13.500 caratteri senza punteggiatura) e' in parte **non ricostruibile**: dove una frase cambia il senso lo segnalo (§2.1). La frase *"a, a, a, a, a, ..."* (r.191, **15 ripetizioni** `[MISURATO grep]`) e' un loop STT, **non contenuto**.
- **Nessun fatto personale rilevante** (r.1-3, r.31-33: problema di password su Zoom, profilo Instagram hackerato): scartato.

## 1.2 I punti piu' importanti (ordinati per valore per noi)

| # | punto | dove | che cosa vale |
|---|---|---|---|
| 1 | **Retest con la stessa size** dopo aver gia' portato a casa un parziale (*"fieno in cascina"*) | r.169, r.171 | **NUOVO** meccanismo di re-entry; **incompatibile** con `InpOneTradePerDay=true` delle sedie DAX (scheda 09/30 r.279). Non si copia |
| 2 | **Chiudere la gamba perdente con meta' del profitto dell'altra** | r.161 | **NUOVO**; parente del recovery (netting). Arancione. *"Io lo faccio quasi sempre"* |
| 3 | **Regola dell'apertura sotto un livello -> short dalla resistenza**, dopo un primo rimbalzo | r.119-135 | **Si compone col 05/10** (*"in apertura scarica sempre in direzione opposta"*, richiamata qui a r.63): primo scarico contro la candela di pre-apertura, poi direzione. Dichiarazione senza misura, n = 1 |
| 4 | **Numero tondo SOLO con una confluenza; altrimenti quantita' piu' piccola** | r.93-101, r.191 | **CAMBIA** il 02/10 e il 05/10 (tondo come livello in se'). Ora: *"io personalmente non lavoro il numero tondo fine a se stesso"* (r.191) |
| 5 | **Fill:** per essere eseguiti l'ordine va messo **prima** del tondo, non sopra (*"mi sfiora e non mi becca"*, Luca mancato **per 10 punti**) | r.167-169 | **NUOVO**: lezione di esecuzione. Tocca la distanza `Buffer` dei nostri pendenti |
| 6 | **Stop 20-30 punti dal primo ordine** sul DAX (r.65, **piano di Luca**, approvato da Emiliano r.73) | r.65 | **[DERIVATO]** 20-30 / 1,70 = **11,8-17,6x lo spread BCM**: **sotto il pavimento duro 13,3x per il 20; sotto 40x in ogni caso** (`APERTURE_DAX_MAPPA_2026-10-03.md` §3). **Quello stop non passa il nostro cancello di costo** |
| 7 | **Volumi M15 decrescenti = niente ORB**; i minimi della notte valgono come livello di **retest**, non come **floor di un box ORB** | r.193-195 | Converge col filtro volumi gia' vivo nella RETEST Nasdaq (`APERTURE_NASDAQ_MAPPA_2026-10-03.md` r.50). Non indipendente |
| 8 | **Contro-trend long sul tondo** con weekly **e** daily short, *"esasperando l'operativita'"* per didattica | r.173-179 | **Contraddice** *"sempre in direzione"* (r.189, r.191) detto 10 righe dopo. Bandiera arancione |
| 9 | **Sistema di Girolamo: pendenti automatici su tutti i numeri tondi** (200, 100, 300) *"perche' tanto il mercato sale e scende ad onde"*, costruito con IA | r.175, r.191 | **Griglia di pendenti** di un allievo, lodata (*"bellissimo sistema"*) ma **non adottata** da Emiliano. Intelligence, non pratica |
| 10 | **Uscita con l'ATR** e **cancellare tutti i pendenti in prossimita' di dati** | r.205-207 | **Conferma** la gestione ATR di `770411` (2,5x ATR, mappa DAX §3); il filtro news dei preset FTMO indici resta **spento** (decisione di Claudio) |
| 11 | **Il DAX tenuto in M3** (S&P e Nikkei a fianco) | r.5, r.173, r.189 | **prima volta nelle live Emiliano trascritte** (18/09-05/10: 0); **non** nuovo nel corso: M3 c'e' in live Paolo vecchie (`docs/live_paolo/` 05/05, 07/05, 03/09) e `ABTG_DAX_M3` e' la "Strategia DAX M3" (Supertrend su M3), **mai un CSV** (`backtest_pipeline/REGISTRO_TEST.md` r.123). Una testimonianza, non una misura |

## 1.3 Regole di rischio / prop

**Nessuna regola prop. Nessun limite giornaliero. Nessuna percentuale di rischio.** Le uniche frasi di rischio sono personali e qualitative:
*"Luca, tu hai preso meno rischio. Io mi sono preso piu' rischio"* (r.135), *"io sono stato aggressivo"* (r.155-159), *"quando sei in direzione ... puoi anche sbagliare l'ingresso ... il Profitto lo si porta sempre a casa, sempre"* (r.155-159, **assoluto, B7**),
*"in prossimita' di dati, cancello tutto"* (r.207), *"Ban, ... ti sei preso troppo rischio"* (r.199), *"prima o poi ci lascio le penne"* (r.191, sull'oro in contro-direzione). **Nessuna taglia in euro, nessun capitale, nessuna % per trade.**
L'unico numero di size e' in **contratti**: 10, 20, *"quattro lotti"* (r.41), 2-4-6-10 (r.69) `[TRASCRITTO dubbio]`.

## 1.4 Numeri dichiarati (mai criteri nostri)

**Nessun P/L in euro.** Solo punti DAX e giudizi: *"questi sono 80 punti DAX, fatti bene"* (r.169), *"cento punti d'acciaio"* (r.183) `[TRASCRITTO dubbio]`, *"io ho fatto i soldi e lui [Luca] no"* (r.169),
*"il quattro lotti del DAX che avevamo impezzato proprio molto, molto bene"* (r.41, riferito alla **live precedente**; quale giorno non detto), *"ho portato Profitto con la meta'"* (r.151). **n = 1 mattina, un regime.** Nessun win rate, nessun drawdown, nessun PF.

## 1.5 Bandiere (dettaglio in §2.7)

**Rosse piene: 0.** **Arancioni (5):** B1 *"riparare l'operazione"* col secondo ordine (mediazione); B2 sistema di Girolamo (griglia di pendenti sui numeri tondi); B3 stessa size sul retest con "fieno in cascina" (re-entry);
B4 scala di size secondo il livello (parente del 2-4-10-20 del 05/10); B5 contro-trend long con W1+D1 short. **Ambra (5):** B6 chiusura meta' profitto per coprire la perdita; B7 assoluti (*"il profitto lo si porta sempre a casa"*);
B8 sposta gli ordini in corsa quando e' "sfiorato"; B9 size senza capitale ne' valore del punto; B10 pressione sui partecipanti a "cliccare" in live. (La B11 della bozza, "regola di apertura che cambia fra live", e' **ritirata**: vedi §1.0.) **Trucchi anti-prop: 0.** Hedging: **0 parole** (a differenza del 05/10).

## 1.6 Quello che NON c'e' (verificato con `grep`, case-insensitive)

| pratica cercata | occorrenze | nota |
|---|---:|---|
| prop (intera) / FTMO / funded / challenge / drawdown | 0 / 0 / 0 / 0 / 0 | |
| hedging / ejami / "legato" / copy | 0 / 0 / 0 / 0 | **assente** (presente il 05/10, r.235-243) |
| martingala / raddoppio / griglia (parola) / recupero | 0 / 0 / 0 / 0 | ma vedi B1, B2, B3, B6 (parenti senza la parola) |
| "senza stop" | 0 | *stop* compare 14 volte, sempre come stop di un ordine o spostamento |
| PF / backtest / statistica / storico / anni | 0 / 0 / 0 / 0 / 0 | **non c'e' niente su PF, storico, regimi** |
| ATR | 2 | r.205 *"l'uscita qua con l'ATR"* (e un'altra occorrenza nello stesso passo) |
| M3 | 3 | r.5, r.173, r.189 |
| VWAP/V-Vap/VVAP/wwap/move up | 26 | **protagonista** (ingressi, stop, bande di regressione) |
| retest/ritest | 18 | **protagonista** |

---

# PARTE 2 - LA SCHEDA DI CASA

```
FILE             data/trascrizioni/LIVE_EMILIANO_2026-10-07.txt  (211 righe cat -n, 53.013 byte)
RELATORE/CANALE  Emiliano (host, opera in prima persona); allievo Luca che apre con l'analisi; live pubblica del corso
OGGETTO          Mercoledi' 07/10 mattina: DAX (apertura cash), analisi weekly/daily/H1, livelli (min/max notte, VWAP, numero tondo, medie),
                 short sul VWAP/tondo, retest, oro, ORB sul DAX (volumi), dashboard "sweet"
```

## 2.1 Le ricostruzioni dell'ascolto (tutte [INFERITO]; quelle che cambiano il significato sono in grassetto)

| nel testo | lo leggo come | su che base |
|---|---|---|
| "dash", "Dark Sources" (r.9), "Dax e' nostro" | **DAX** | r.9 *"sale o scende Dark Sources? Per ora e' short"*; r.109 *"oggi attendiamo il dash"* |
| "Wiki", "Weekly", "wiki" | **weekly** | scheda 10/05 §4.1; r.15 *"In Weekly tiro supporti resistenze"* |
| "dei", "Dei", "di uno" | **daily / D1** | r.191 *"la candela dei e' short"* |
| "WAP", "VVAP", "wwap", "move up" | **VWAP** | r.17 *"VVAP ... questo giallo"*; r.173 *"dove c'e' il move up, il M3"* (schede 18/09, 10/05) |
| **"VVAP Pasquale"** (r.17) | **[NON CHIARO]**: un VWAP "di ... Pasquale"/"di Pasqua"; potrebbe essere un nome proprio | r.17 *"Ho anche il VVAP Pasquale, questo qua giallo"* |
| "FONC", "FONC Meeting" | **FOMC** | r.13-15 *"non e' la FONC che facciamo noi"* |
| "ordi impedenti", "ordini impedenti" | **ordini pendenti** | r.93, r.99 |
| "pre section", "percezione", "grande percepzione" | **zona di prezzo / livello** (supporto-resistenza, a volte "pre-session") | r.97, r.113, r.191 *"pre-session"* | **mai definita** (anche il 30/09, 02/10, 05/10) |
| **"sederino"** (r.159) | **[NON CHIARO]**: *"ho seguito la strategia del sederino sotto un livello"* = apertura sotto un livello `[INFERITO dal contesto r.133]` | r.133, r.159 |
| **"cipettino"** (r.193) | **ordine "civetta"/di prova** in direzione `[INFERITO]`: *"quell'ordine che mi da' un po' il senso di tutto ... il senso della direzione, il senso della forza"* | r.193; scheda 10/05 (*"ordine civetta"*) |
| **"ordine delle teste"** (r.189) | **[NON CHIARO]**: forse "ordine di test/retest" | r.189 *"l'ordine delle teste ... con lo stop in pari"* |
| **"3d range"** (r.191) | **range di 3 giorni** `[TRASCRITTO dubbio]` | r.191 *"a 3 giorni da 3 giorni e' in un 3d range pazzesco"* |
| **"tre profi"** (r.179) | **[NON CHIARO]**: tre take profit? tre profitti? | r.179 *"se arriviamo a tre profi ci facciamo tutti un bel applauso"* |
| **"d'acciaio"** (r.183) | **[NON CHIARO]** | r.183 *"cento punti d'acciaio"* |
| "bassista" | **ribassista** | r.185-191 |
| "Profitto" (maiuscolo) | **profitto** (STT) | passim |
| "FONC ... Trump stasera alle 7 e alle 8" | evento serale; **orari senza fuso: [INCERTO]** | r.15 |
| **"2-4 fa 6, 10"** (r.69) | **size 2 + 4 (= 6) e 10** `[TRASCRITTO dubbio]`: tre ordini (2, 4, 10)? | r.69 *"2-4 fa 6, 10 lo metterei qua, tra il VWAP e la media 200"* (ricorda la scala 2-4-10-20 del 05/10) |
| **"sull'86"** (r.103), **"66"** (r.89), **"306"** (r.167) | ultime due cifre del prezzo DAX (25.286? 25.166, 25.306) `[INFERITO]` | r.89 *"25,266? Si, 25, no, 25,166"*; r.167 *"Ah, 306, si'"* |
| **"3955 ... 4.000 ... 413 ... 66"** (r.191, oro) | **[NON RICOSTRUIBILE]**: livelli oro con prefisso migliaia non detto | r.191 |
| **"che a 25.152 sono 110 punti"** (r.57) | weekly support 25.152, a **110 punti** dal prezzo | r.57 chiaro |
| "Girolamo", "Giro", "Giro l'amore", "Giro, Giro, ti ho nominato" | **Girolamo** (allievo) | r.175, r.189, r.191 |
| "Bani", "Ban", "Van" | **Ban** (un partecipante) | r.191-199 |
| "Pasquale", "Giuliano" (r.21, r.63 ecc.) | **[NON CHIARO]**: nomi usati come intercalare/appellativo; **in r.21** *"proprio dove si trova adesso Giuliano"* = probabilmente "il prezzo" (STT) | r.21, r.193 |
| "Wuvappo" (r.191) | **[NON CHIARO]** (VWAP + "po'"?) | r.191 |

## 2.2 Cronologia della live

| riga | cosa succede |
|---|---|
| r.1-3 | problema di password su Zoom; si apre con l'analisi di Luca |
| r.3-27 | **Luca**: monitor (S&P in alto a sx, Nikkei in basso a sx, DAX in H1/M15/M3); min/max della notte e del giorno prima; weekly S/R; daily resistenza; VWAP; H1: rotti i minimi della notte (~50-60 punti), attende il **retest** |
| r.29-41 | Emiliano: *"si parte sempre da weekly, daily, sempre su ogni strumento"*; la **scorsa volta** *"il quattro lotti del DAX"* short |
| r.43-63 | **pre-apertura**: si puo' aspettare un rimbalzo sul livello? Luca: *si', se il mercato e' chiuso; a ridosso dell'apertura no, e' come lanciare la monetina*; supporto weekly 25.152 (110 punti); **confluenze** (min notte, VWAP, tondo 25.3, media 200 H1, 89, 100, pavimenti Supertrend) |
| r.63-77 | **piano di Luca**: stop **20-30 punti** dal primo ordine, ordini splittati in 2-3; H4: VWAP H4 sul primo, media 14 sul secondo, media 9 e 50 sul terzo |
| r.77-97 | VWAP su M15; massimi/minimi della notte *"applicare in maniera costante"*; **livello 25.166**; **dieci contratti**; numero tondo senza supporto = quantita' inferiore |
| r.99-117 | ordini sul tondo/86; **apertura del mercato** (r.117: *"aperto al mercato. Allora, aperto sotto questo livello"*) |
| r.117-141 | **regola dell'apertura sotto il livello**: primo ordine al livello, secondo sul VWAP, terzo al tondo; stop sopra VWAP; *"sono entrato un po' dopo"*; **sorpresa: rimbalza** |
| r.143-161 | **gestione**: primo ordine in profitto; secondo ordine *"mi porta a casa 10 e chiudo il resto"* `[TRASCRITTO dubbio]`; stop in pari; **regola "chiudi meta' per coprire la perdita"** |
| r.165-171 | **fill e retest**: Luca mancato per 10 punti; ordine *"sotto il numero tondo quando voglio essere fillato"*; **retest con la stessa size** |
| r.173-183 | **domanda di Mattia** (contro-trend) e risposta; Girolamo; take profit al tondo; *"se arriviamo a tre profi"* |
| r.185-191 | **rottura dei minimi -> accelerazione**; ordine sfiorato (25.159); si sposta tutto piu' giu'; *"esasperando"*: short sul trading range; **oro** (Ban); fase di pre-session |
| r.191-199 | **Ban e Kevin** sullo stesso grafico oro, posizioni opposte; **ORB short sui minimi della notte** (Giuliano/Consuelo): volumi M5 vs M15; **ritiro**: *"bisognava dargli long, non short"*; i minimi della notte **per retest** non **come floor box** |
| r.199-207 | Ban e il rischio; **"sweet"/dashboard**: dollaro forte e oro debole; chiusura: *"tengo solo questi ordini ... uscita con l'ATR ... in prossimita' di dati cancello tutto"* |

## 2.3 PARAMETRI CON VALORE (32 voci; tutte [DICHIARATO, NON verificato])

| # | parametro | valore | citazione | dove | chiaro? |
|---|---|---|---|---|---|
| P1 | setup grafico | **S&P** (alto-sx), **Nikkei** (basso-sx), **DAX in H1, M15 e M3** | *"io ho il monitor suddiviso in standard pulse in alto a sinistra e Japan in basso a sinistra, e poi tengo il DAX in tre time frame, H1, M15 e M3"* | r.5 | chiaro (Luca) |
| P2 | linee di riferimento | **min/max della notte** (viola), **min/max di ieri** (azzurro: *"lontana, quindi non ci interessa"*) | r.9 | r.5-9 | chiaro; **finestra notte NON dichiarata** |
| P3 | weekly | **tre minimi e due massimi** = supporto; supporto weekly **25.152**, a **110 punti** dal prezzo; weekly *"incertezza"*, *"piccola d'oggi"* | *"abbiamo tre minimi e due massimi"*; *"supporto weekly che ho tracciato, che a 25.152 sono 110 punti"* | r.11, r.15, r.57 | chiaro; `[TRASCRITTO dubbio]` sul "tre/due" |
| P4 | daily | resistenza **arancione** da due massimi e un minimo; **nessun supporto daily** | r.17-19 | r.17-19 | chiaro |
| P5 | calendario | Cina chiusa; EUR niente tranne *"questa cosa della Francia"*; **"Trump stasera alle 7 e alle 8"**; *"non e' la nostra FONC"* | r.13-15 | r.13-15 | **orari serali: fuso non dichiarato** `[INCERTO]` |
| P6 | DAX operativo | **TF H1**; min della notte rotti; movimento **~50-60 punti**; ritracciato; **attendere il ritest dei minimi della notte** | *"si e' fatto una cinquantina di punti, 60 addirittura. Ha ritracciato ... Io lo attenderei su un eventuale ritest dei minimi della notte"* | r.23 | chiaro |
| P7 | confluenze (zona ritracciamento) | **min della notte** + **VWAP** + **numero tondo 25.3** + **media 200 H1** | *"sul ritracciamento dei minimi della notte, che coincide con il VVAP, il numero tondo 25.3, la media 200 H1"* | r.59 | chiaro; il tondo e' **25.300** `[INFERITO]` |
| P8 | confluenze H1 | **media 89**, **media 100**, min notte, VWAP, media 200, *"pavimenti del Supertrend"* | *"In questa zona abbiamo media 89, media 100, i minimi della notte ... il VVAP, la media 200, tutto questo in H1, e ci sono i pavimenti del super trend"* | r.63 | chiaro; **periodi del Supertrend non dettati** |
| P9 | stop | **20-30 punti** dal primo ordine; stop **sopra lo spike**; stop comune a tutte le gambe | *"abbiamo lo stop, lo metterei qua sopra. Quindi parliamo di 20-30 punti dal primo ordine. Ovviamente li splitterei in due o tre ordini"* ; *"Lo stop di tutto lo metterei sopra questo spike"* | r.65, r.71 | chiaro; **[DERIVATO] 11,8-17,6x lo spread BCM 1,70** (vedi sotto) |
| P10 | size (Luca) | **"2-4 fa 6, 10"** | r.69 | r.69 | **`[TRASCRITTO dubbio]` pesante** (unita' non detta) |
| P11 | H4: tre ordini | primo: **VWAP H4**; secondo: **media 14**; terzo: **media 9 e media 50** | *"nel primo ordine c'e' il VWAP di H4 ... Sul secondo ordine c'e' la media 14, e sul terzo abbiamo la media 9, che e' questa bianca, e la media 50"* | r.71 | chiaro; TF delle medie 14/9/50 `[INCERTO]` (H4?) |
| P12 | VWAP | usato su **M15**; distanza **~100 punti** (*"quasi 100 punti, un po' di meno"*); canali di regressione del VWAP = **obiettivi** | *"Io il VWAP lo utilizzo sull'M15 ... mi ha salvato tantissime volte"* ; *"il VWAP ha questi canali di regressione che sono dei livelli di obiettivo"* | r.81, r.159 | chiaro; **deviazioni/ancoraggio del VWAP NON dichiarati** |
| P13 | livello | **25.166** *"a 66 ... un livello importante"* | r.89 | r.89 | `[TRASCRITTO dubbio]` (25.266 o 25.166: *"25,166"* detto) |
| P14 | size DAX | **dieci contratti** sopra; sul tondo **quantita' inferiore** | *"dieci contratti mi metto sopra"*; *"ci metto qua uno, e' a cavallo"* | r.91, r.101 | **`[TRASCRITTO dubbio]`**: "uno" |
| P15 | secondo ordine | a **~20 punti** dal tondo, *"sull'86"* | *"Siamo distanti circa 20 punti, quindi diciamo sull'86"* | r.103 | chiaro |
| P16 | regola d'apertura | *"aperto sotto un livello di resistenza"* -> primo ordine al livello, secondo ordine al VWAP, **terzo al numero tondo**; tendo **short**; **stop sopra il VWAP** | *"la regola e' aperto sotto un livello di resistenza. Il primo ordine lo metto li', il secondo ordine lo piazzo su questo livello. Quindi per me tendo ad andare short ... lo stop lo metto sopra V-Vap"* | r.123-129 | chiaro come regola; **assolutizzata dal giorno**; si compone con la regola del 05/10 (§1.0) |
| P17 | gestione (primo/secondo ordine) | primo ordine *"me lo porta a casa"*; secondo *"mi porta a casa 10 e chiudo il resto"*; **stop in pari**; poi *"ho portato Profitto con la meta'"*; stop *"sopra l'ordine pendente"* | r.143-151 | r.143-151 | `[TRASCRITTO dubbio]` sul "10" (punti? contratti?) |
| P18 | regola mentale | chiudi **meta' della posizione in perdita... togli dalla posizione in profitto la quantita' che copre la perdita**; gestisci solo l'operazione in profitto | *"Prendi, chiudi meta' posizione qua, questo guadagno, chiudi questa perdita e ti gestisci solo l'operazione in Profitto ... togli una quantita' tale dal tuo ordine in Profitto, tale per cui ti copre la perdita"* | r.161-163 | chiaro; *"Io lo faccio quasi sempre, quasi sempre"* (r.163) |
| P19 | primo ordine di Luca | **25.306** (*"Ah, 306, si'"*), **sopra** il numero tondo; **mancato per 10 punti** | r.167 | r.167 | `[TRASCRITTO dubbio]` ("306") |
| P20 | regola di fill | *"quando voglio essere fillato ... lo metto sotto il numero tondo"* (per uno short) | *"Io quando voglio essere beccato non lo metto sopra il numero tondo, lo metto sotto il numero tondo quando voglio essere fillato"* | r.169 | chiaro come regola; la **distanza non e' dichiarata** |
| P21 | retest: size | **stessa size** del primo ordine (*"se avevo 10 mettevo 10, se avevo 20 mettevo 20"*), *"sopra invece lo messo leggermente in superiore"* | r.169 | r.169 | chiaro (re-entry full size) |
| P22 | retest: condizione | solo con **"fieno in cascina"** (profitto gia' incassato); *"fatelo fare a me"*; chi non era in operazione puo' rientrare sul retest | *"hai gia' un fieno in cascina, puoi permetterti di fare i retest ... mi raccomando, la stessa size, sul primo ordine che hai in essere"* | r.171 | chiaro |
| P23 | movimento DAX | **80 punti** (*"questi sono 80 punti DAX"*); **100 punti** (*"cento punti d'acciaio"*) | r.169, r.183 | r.169, r.183 | `[TRASCRITTO dubbio]` sul 100 |
| P24 | altri ordini del retest | *"5 e 10"*; *"500 ... le quantita' sono basse"* | r.169 | r.169 | **`[TRASCRITTO dubbio]` pesante** (taglie? punti? 500 = ?) |
| P25 | obiettivo contro-trend | il **numero tondo** (*"il suo obiettivo e' diventato il numero tondo"*); take profit *"di uno e di due"* | r.173-177 | r.173-177 | `[TRASCRITTO dubbio]` ("di uno e di due") |
| P26 | spazio al tondo | *"almeno 10 15 20 punti"*; ordini **da venti** e **da dieci** | *"sul numero tondo mi possa dare uno spazio di almeno 10 15 20 punti"*; *"questa da venti questa da dieci"* | r.191 | `[TRASCRITTO dubbio]` (venti/dieci = contratti o punti) |
| P27 | uscita colpita | **25.159**, ordine di uscita *"sfiorato ... per un punto, per lo spread"* | r.189 | r.189 | chiaro; *"per un punto"* |
| P28 | struttura M3 | massimi e minimi **nella stessa direzione**; massimo non superato = *"dormo tranquillo"* | *"siamo in M3, io devo mantenere una struttura, dove i massimi e i minimi incominceranno ad andare tutti nella stessa direzione"* | r.189 | chiaro |
| P29 | oro (Ban) | **D1 short, weekly indeciso**; *"3d range"*; lui **lavorerebbe long a "19"** (prefisso non detto); stop di Ban **~29**; obiettivo short **74**; livelli *"3955 ... 4.000 ... 66"* | r.191-193 | r.191-193 | **prefissi/unita' NON detti**; livelli in parte `[NON RICOSTRUIBILE]` |
| P30 | ORB DAX short (Giuliano/Consuelo) | **volumi M5 aumentati**, **M15 decrescenti**; ora *"9.56, mancano quattro minuti alla chiusura della candela"*; *"per rompere il livello, il floor dell'ORB ci devono essere i volumi"* | r.193 | r.193-195 | ora IT `[INFERITO]`; **quale candela chiude fra 4 minuti `[INCERTO]`** (M15?) |
| P31 | uscita | **ATR**; **cancella tutto prima dei dati** | *"questi ordini, io li tengo ... l'uscita qua con l'ATR. Uscita con l'ATR. Attenzione, perche' in prossimita' di dati, cancello tutto"* | r.205-207 | **periodo/moltiplicatore dell'ATR NON detti** |
| P32 | "una volta sola, in pari" | *"con lo stop in pari"* per l'ordine di retest (*"di certo, con l'ordine ... non posso ancora perdere"*) | r.189 | r.189 | chiaro |

**Costo (DERIVATO, non e' un criterio suo):** stop 20 punti / spread BCM 1,70 = **11,8x**; 30 / 1,70 = **17,6x**; FTMO 1,23: **16,3x / 24,4x**; FTMO P95 1,33: **15,0x / 22,6x**. Pavimento duro **13,3x**; frontiera **40x** = **68,0** idx a BCM e **53,2** a FTMO P95 (`APERTURE_DAX_MAPPA_2026-10-03.md` §3 `[LETTO nel repo]`).

## 2.4 MECCANISMI (27)

| # | meccanismo | come descritto | dove |
|---|---|---|---|
| M1 | **Cascata strumento**: si parte sempre da weekly -> daily -> TF operativo (H1) | *"si parte sempre da weekly, daily, sempre su ogni strumento"* | r.9-23, r.29 |
| M2 | **Calendario prima di tutto** (*"una cosa importante che non si salta mai"*) | r.11-15 | r.11-15 |
| M3 | **Punti di riferimento = max/min della notte e del giorno prima**; **una volta superati non si prendono piu' a riferimento** | *"che sono gia' stati superati, quindi non li prendiamo piu' a riferimento"* | r.85 |
| M4 | **Disciplina**: *"quando c'e' una strategia, bisogna applicarla e bisogna applicarla in maniera costante, non una volta si', una volta no"* | r.87 | r.87 |
| M5 | **Pre-apertura**: rimbalzo sul livello OK **se il mercato e' chiuso**; **a ridosso dell'apertura MAI** (*"come lanciare la monetina"*) | Luca r.49-53; Emiliano r.55 *"tendenzialmente e' sempre meglio stare fuori dal mercato, aspettare e vedere"* | r.47-55 |
| M6 | **Domanda del livello**: *"cosa succede su quel livello ... se supera quel livello, che cosa fa e dove arriva"* | r.57 | r.57 |
| M7 | **Ordini splittati** in 2-3 sulle confluenze, **stop unico** sopra lo spike | r.65-71 | r.65-71 |
| M8 | **Numero tondo**: livello importante ma **solo con confluenza**; altrimenti **quantita' minore**; *"per me il numero tondo deve essere accompagnato sempre da un supporto o da una resistenza"* | r.93-101, r.191 | r.93-101, r.191 |
| M9 | **Regola dell'apertura sotto il livello** -> si va in quella direzione (short), stop sopra VWAP | r.119-133 | |
| M10 | **Parziale + stop in pari**; il resto con stop *"sopra l'ordine pendente"* | r.143-151 | |
| M11 | **Chiudi meta' per coprire la perdita** | r.161 | |
| M12 | **Retest con la stessa size**, solo se gia' in direzione e col profitto in tasca | r.169-171 | |
| M13 | **Regola di fill**: l'ordine **prima** del livello, non sopra | r.169 | |
| M14 | **Contro-trend sul tondo** *"esasperando"*, obiettivo il tondo successivo | r.173-179 | |
| M15 | **"Il livello va sempre ritestato per definirlo"** (retest) | r.169 | r.169 |
| M16 | **Sposta gli ordini piu' giu' dopo che il livello e' stato sfiorato/rotto** (*"rotto i minimi accelera"*) | r.189-191 | |
| M17 | **Struttura M3** (HH/LL) per rimanere in operazione | r.189 | |
| M18 | **Livello dinamico/trendline** + livello statico = confluenza | r.191, r.193 | |
| M19 | **Trading range** -> si fa sempre **short**, sempre in direzione (*"mi raccomando sempre in direzione"*) | r.191 | |
| M20 | **Rischio di accelerazione**: se i minimi precedenti sono vicini agli ordini, l'accelerazione e' rischiosa; *"col secondo ordine penso di andare a riparare l'operazione"* | r.187 | |
| M21 | **Oro**: se **weekly incerto** e **daily short**, il **long** solo *"in sicurezza"* e in **trading range**; *"se te la devo dire tutta ... il long tendenzialmente io lo rifiuterei"* se il weekly e' certo | r.191-193 | |
| M22 | **ORB**: volumi **M15 decrescenti = non si fa**; minimi della notte come **livello di retest**, non come **floor di box** | r.193-197 | |
| M23 | **"Cipettino"**: l'ordine piccolo in direzione che *"mi da' il senso di tutto"* | r.193 | |
| M24 | **Dashboard "sweet"/currency strength** come avviso (*"dollaro forte e oro debole"*) | r.197-205 | |
| M25 | **Fine giornata**: tiene solo alcuni pendenti, **uscita con ATR**, **cancella i pendenti vicino ai dati** | r.205-207 | |
| M26 | **VWAP M15** come livello e obiettivo (canali di regressione) | r.81, r.159 | |
| M27 | **Aggressivo vs cauto**: *"quando sei in direzione puoi anche sbagliare l'ingresso ... il Profitto lo si porta sempre a casa"* | r.155-159 | |

## 2.5 REGOLE PROP CITATE

**Nessuna.** Zero occorrenze di prop/FTMO/funded/challenge/drawdown. Non c'e' niente da etichettare VIETATO.

## 2.6 CASI OPERATIVI DEL GIORNO

| # | caso | chi | cosa si vede/si dice | esito | righe |
|---|---|---|---|---|---|
| C1 | **Setup DAX pre-apertura** | Luca (e Emiliano) | DAX short; minimi della notte **gia' rotti** (50-60 punti); weekly incerto, daily short; ordini splittati sulle confluenze (VWAP, tondo 25.3, media 200 H1, 89, 100, Supertrend); stop sopra lo spike | **ordini pendenti** (non eseguiti prima dell'apertura) | r.3-77 |
| C2 | **Apertura cash del DAX** | tutti | *"aperto sotto questo livello"*; il mercato **rimbalza fino al VWAP/tondo** (*"si e' fermato sul livello di VWAP ... arriva sul numero tondo"*) | prezzo sale, poi cade | r.117-131 |
| C3 | **Operazione di Emiliano (short)** | Emiliano | ingresso *"un po' dopo"* l'apertura, **aggressivo**; ordini sul VWAP/tondo (**tre ordini**, il terzo al tondo); stop **sopra il VWAP**; primo ordine in profitto, secondo *"mi porta a casa 10"*, **chiude il resto**, stop in pari; il prezzo *"ritorna"*: **rientra sul retest con la stessa size** | **in profitto** ("ho fatto i soldi", **~80 punti DAX**; **importo non dichiarato**) | r.117-171 |
| C4 | **Operazione di Luca** | Luca | primo ordine **sopra** il tondo (25.306?), **non eseguito per 10 punti** (*"mi sfiora e non mi becca"*); secondo su VWAP | **nessun profitto** (*"io ho fatto i soldi e lui no"*) | r.165-169 |
| C5 | **Retest** | Emiliano | ordine di retest **stessa size**, *"sopra invece lo messo leggermente in superiore"*; *"adesso ha ritestato il livello di resistenza, andiamo a vedere se mi da' ragione"* | **in profitto** (non quantificato) | r.169-171 |
| C6 | **Buy contro-trend sul tondo** | Emiliano | *"sul numero tondo ... mi metto contro trend"* (weekly **e** daily short); obiettivo il tondo; take profit *"di uno e di due"* | **non chiaro l'esito**; poi *"questo sarebbe stato un short esasperando"* | r.173-179, r.189-191 |
| C7 | **Uscita sfiorata** | Emiliano | ordine di uscita a **25.159** sfiorato (*"per un punto, per lo spread"*); poi sposta tutto piu' giu' | profitto mancato | r.189 |
| C8 | **Short sul trading range** (*"esasperando"*) | Emiliano | *"io lì entro short perché ho individuato un canale ... un trend"*; **poi non entra** sul tondo: *"qua io non sono entrato ... preferisco portarmi a casa il risultato"* | **nessun nuovo ingresso** | r.191 |
| C9 | **Oro (Ban long, Kevin short)** | allievi | Ban long in contro-direzione al D1 short, **stop ~29**; Kevin short *"in sicurezza"*; Ban **chiuso/uscito**; *"ti sei preso troppo rischio"* | **Ban in perdita** `[INFERITO]` (*"Si e' uscito"*) | r.191-199 |
| C10 | **ORB short sui minimi della notte (DAX)** | Consuelo/Giuliano | volumi M5 aumentati, **M15 decrescenti** -> **non lo farei**; poi **Emiliano rivede se stesso**: *"qua gli dovevamo dare long, non short ... mi sto sbagliando io?"* | **non preso**; Emiliano ammette **errore di lettura** (r.195) | r.193-197 |
| C11 | **Errori dichiarati** | Emiliano | *"ho sbagliato l'ingresso, il timing, sono stato aggressivo"* (r.155); *"non mi scrittavo neanche che aprendo sotto potesse rimbalzare in questa maniera"* (r.135); *"vi chiedo scusa ... mi sono perso [i volumi decrescenti]"* (r.195); **poi si riprende** (*"in realta' io non ho sbagliato l'ingresso"*, r.157) | **autocontraddizione nello stesso passo** (r.155 vs r.157) | r.135, r.155-157, r.195 |
| C12 | **Gestione a fine live** | Emiliano | *"tengo solo questi ordini, solo sul DAX ... uscita con l'ATR ... in prossimita' di dati cancello tutto"* | **pendenti residui** | r.205-207 |

**P/L del giorno: non dichiarato in euro.** Dice che ha *"fatto i soldi"* e che il movimento e' di ~80 punti (r.169): **non verificabile**.

## 2.7 BANDIERE ROSSE (verifica attiva sull'intero testo)

| # | bandiera | colore | prova | nota |
|---|---|---|---|---|
| B1 | ***"col secondo ordine penso di andare a riparare l'operazione"*** (mediazione) | **arancione** | r.187 | il secondo ordine **ripara** il primo: e' averaging. Con stop sul primo? **non detto** (D3) |
| B2 | **Sistema di Girolamo**: pendenti automatici **su tutti i numeri tondi** (200, 100, 300), via IA | **arancione** | r.175, r.191: *"mette l'ordine pendenti su i livelli numeri tondo perche' dice lui li mette su tutti i numeri tondi ... perche' tanto dice il mercato che sale e scende ad onde"* | **griglia di livelli fissi**; Emiliano **lo elogia** ma dichiara *"io personalmente non lavoro il numero tondo fine a se stesso"* (r.191). **Documento come intelligence, non lo propongo** |
| B3 | **Stessa size sul retest** con *"fieno in cascina"* | **arancione** | r.169, r.171 | **re-entry full size** dopo profitto: la perdita eventuale del retest e' piu' grande del primo ordine; **nessun cap del rischio dichiarato** |
| B4 | **Scala di size secondo il livello** (2-4-10-20 del 05/10; oggi *"2-4 fa 6, 10"* di Luca, *"questa da venti questa e' da dieci"*) | **arancione** | r.69, r.91, r.99, r.191 | la size cresce **verso il livello migliore**, non dopo una perdita: scale-in contro il prezzo. **Perche' non rossa:** la rossa di casa e' la size che cresce **dopo una perdita** o senza tetto (martingala/recovery); qui la scala e' **decisa al piazzamento** con **uno stop comune dichiarato** (r.65, r.71 *"lo stop di tutto ... sopra questo spike"*), quindi la perdita massima e' nota prima. **Diventa rossa** se D3 risponde che il primo ordine non ha stop |
| B5 | **Contro-trend long con weekly e daily short**, per *"esasperare l'operativita'"* | **arancione** | r.173-179 *"Mi metto contro trend, si', mi metto contro trend"* | **contraddice** *"sempre in direzione"* (r.189, r.191) e *"se vado a lavorarmi l'oro in queste condizioni prima o poi ci lascio le penne"* (r.191) detti pochi minuti dopo |
| B6 | **Chiudi meta' in profitto per coprire la perdita** | ambra | r.161 *"togli una quantita' ... tale per cui ti copre la perdita"* | netting della perdita: **non e' hedging, non e' martingala**, e **riduce** l'esposizione (chiude, non apre): per questo ambra e non arancione. Il difetto e' contabile: la gamba perdente non viene giudicata da sola |
| B7 | **Assoluti**: *"il Profitto lo si porta sempre a casa, sempre, perche' sei in direzione"* | ambra | r.159; r.191 *"non e' possibile non portarci a casa il risultato"* | non misurato; **smentito dallo stesso r.195** (ORB short sbagliato) |
| B8 | **Sposta gli ordini quando il prezzo li sfiora** | ambra | r.189-191 *"nei momenti in cui mi sfiora io come faccio sempre gli ordini li sposto piu' in giu'"* | gestione discrezionale, **non replicabile** |
| B9 | **Size in contratti senza capitale ne' valore del punto** | ambra | r.41, r.91, r.191 | non si puo' ricostruire il rischio % |
| B10 | **Pressione a "cliccare" in live** | ambra | r.191 *"io ho bisogno che vivete quel momento insieme a me ... se non cliccate state sempre a guardare manca un pezzo operativo"* | rischio didattico/emulazione, non nostro |

**Nessuna rossa:** nessun hedging (e' **assente rispetto al 05/10**), nessuna martingala, nessun recovery dichiarato come tale, **nessun trucco anti-prop**, nessuno stop assente.

## 2.8 NUMERI DI PERFORMANCE (tutti [DICHIARATO, NON verificato]; si registrano, non pesano)

*"quattro lotti del DAX ... impezzato molto bene"* (r.41, live precedente, giorno non detto); *"80 punti DAX"* (r.169); *"cento punti d'acciaio"* (r.183) `[TRASCRITTO dubbio]`; *"ho fatto i soldi"* (r.169). **Nessun PF, win rate, drawdown, P/L in euro.**

## 2.9 COSA C'ERA A SCHERMO E NON NEL PARLATO (da chiedere a Claudio / ascoltare)

La registrazione non ha timestamp nel `.txt`: serve la riga e l'ascolto.

| # | cosa | riga | cosa chiedere |
|---|---|---|---|
| S1 | **tutti i livelli del grafico di Luca** (min/max notte, weekly, daily, VWAP): nessun prezzo dettato salvo 25.152 | r.5-21 | screenshot del grafico H1/M15/M3 del DAX (ora e simbolo) |
| S2 | **le tre taglie dell'ordine** (2, 4, 6, 10, 20, 500...) e il **valore del punto** | r.69, r.91, r.169, r.191 | quanto vale 1 contratto sul suo conto; capitale |
| S3 | **le distanze dei tre ordini** (VWAP, tondo, 86) dall'apertura e **dove e' stato fillato** | r.103, r.129-137 | giornale/screenshot dell'esecuzione |
| S4 | **"i canali di regressione del VWAP"** | r.159 | numero di deviazioni, ancoraggio |
| S5 | **"i pavimenti del Supertrend"**: periodi | r.63 | parametri |
| S6 | **il sistema di Girolamo** (pendenti su tutti i tondi) | r.175, r.191 | se esiste un file/regole; **solo per documentarlo come griglia** |
| S7 | **la dashboard "sweet"/currency strength** (*"quella che ci ha dato il nostro amico"*) | r.197-205 | quale indicatore; e' la nostra `ABTG_ForzaFX_Dashboard`? |
| S8 | **l'ATR dell'uscita** (periodo, TF, moltiplicatore) | r.205 | domanda a Emiliano |
| S9 | **i numeri dell'oro** (19, 3955, 4.000, 413, 66, 74) | r.191-193 | prefissi/unita' |
| S10 | **il caso Ban**: ingresso, stop in punti, esito | r.191-199 | screenshot |

---

# PARTE 3 - COSA E' NUOVO RISPETTO ALLE LIVE PRECEDENTI

Confronto con: `report/SCHEDA_LIVE_EMILIANO_2026-10-05.md` (+ `-10-02`, `-09-30`), `report/ANALISI_LIVE_EMILIANO_2026-09-28.md`, `report/ANALISI_LIVE_EMILIANO_2026-09-18.md`, e (per i temi condivisi) `report/ANALISI_LIVE_PAOLO_2026-10-06.md` (stessa serie di bozze).

| tema | gia' c'era | cosa aggiunge/cambia il 07/10 | tipo |
|---|---|---|---|
| Struttura della live | 05/10: Emiliano da solo, *"live un po' operativa"* | **Luca fa l'analisi, Emiliano la commenta e poi opera**; l'allievo diventa il metro (*"ho avuto il buon maestro"*, r.27) | NUOVO formato |
| Cascata weekly -> daily -> H1 | 05/10 C7: *"la direzione dei Wi-Fi dei Devi"* | **ripetuta** (r.29): *"si parte sempre da weekly, daily"* | CONFERMA |
| Numero tondo | 02/10 (25.000), 05/10 (25.200): livello d'ingresso e di estensione | **solo con confluenza**; senza supporto **quantita' inferiore**; *"io personalmente non lavoro il numero tondo fine a se stesso"* (r.191) | **CAMBIA** (stretta) |
| Apertura del mercato | 05/10: *"in prima istanza in apertura scarica sempre in direzione opposta"* (Tommy, r.155, dopo una candela importante fra le 8 e le 9); 02/10: ritest/rimbalzo sul tondo | **richiamata** (r.63 *"in apertura se le rimangia"*) e **seguita**: rimbalzo, poi **"aperto sotto un livello di resistenza -> short"** dalla resistenza (r.123-135) | **SI COMPONE** (due momenti diversi), n = 1 |
| Pre-apertura | 05/10: *"rischiosissimo"*; 02/10: *"rischio ... ancora moderato"* | **Luca**: rimbalzo ok **se il mercato e' chiuso**, vicino all'apertura *"come lanciare la monetina"* (r.49-53); **Emiliano concorda** (r.55) | CONFERMA 05/10, **in contrasto** col 02/10 |
| Hedging | 05/10 r.235-243 (rossa piena) | **assente** | CAMBIA (non c'e' piu') |
| Ordine "civetta" | 05/10: 2 contratti, poi 4, poi 10/20 | **"2-4 fa 6, 10"** (r.69) + **"cipettino"** (r.193) | CONFERMA/ripetizione |
| Retest | 18/09 (Volume Profile -> retest generalizzato), 02/10 | **retest con la stessa size** (r.169-171), **NUOVO** come re-entry | NUOVO meccanismo |
| Chiusura | 05/10: *"alleggerisco"*, *"in pari"* | **chiudi meta' per coprire la perdita** (r.161) | NUOVO |
| Fill | mai trattato | **ordine prima del tondo per essere fillato**; Luca mancato per 10 punti | NUOVO |
| Contro-trend | 28/09: *"long contro il piano"* (oro, DAX) | **contro-trend sul tondo con W1+D1 short** (r.173-179) | RIPETIZIONE della bandiera 28/09 |
| ORB | 05/10: ORB 09:15, 15 min | **volumi M15 decrescenti = niente ORB**; **min notte come retest, non floor di box** (r.193-197) | NUOVO filtro |
| M3 | non in 05/10 (ne' nelle live Emiliano trascritte prima) | **DAX in M3** (r.5, r.173, r.189): HH/LL | NUOVO per Emiliano; **non** per il corso (live Paolo 05/05, 07/05, 03/09; `ABTG_DAX_M3`) |
| Uscita ATR / cancello dati | 30/09: *"tre stop di fila -> fermarsi"* | **uscita ATR + cancella tutti i pendenti vicino ai dati** (r.205-207) | NUOVO (uscita) |
| Dashboard | 28/09: Bollinger/VWAP/Supertrend (strumenti che non abbiamo) | **"sweet"/currency strength**: *"dollaro forte e oro debole"* (r.197-205) | NUOVO |
| Griglia | mai | **sistema di Girolamo**: pendenti su tutti i tondi (r.175, r.191) | NUOVO (bandiera arancione) |
| PF/storico/regimi/expert | 05/10: **0** occorrenze | **0** occorrenze | invariato (nulla da attribuirgli sul criterio "~10 anni + regimi") |
| Prop/challenge | 05/10: **0** | **0** | invariato |

---

# PARTE 4 - COSA TOCCA I NOSTRI EA

Lette per questa parte (cito il file): `report/SCHEDA_LIVE_EMILIANO_2026-10-05.md` §2 (mappa gia' costruita, con i numeri di mappa DAX/ORB/EMA200), `report/SCHEDA_LIVE_EMILIANO_2026-09-30.md` r.235 e r.279,
`report/CENSIMENTO_ORB_2026-09-29.md` §0, `report/APERTURE_DAX_MAPPA_2026-10-03.md` §3, `report/APERTURE_NASDAQ_MAPPA_2026-10-03.md` r.50, `report/DOSSIER_EXPERT_PER_EMILIANO_2026-10-05.md` §B-§C,
`backtest_pipeline/REGISTRO_TEST.md` r.378-384, `report/DIARIO.md` r.87, `HANDOFF.md`, `FLOTTA_ATTIVA.md`, `report/PIANO_FREE_TRIAL_FTMO_2026-09-30.md`, `report/OMBRA_FORZAFX_SPEC_2026-10-05.md` (intestazione).
**Non letto** (dichiaro): i per-trade delle sedie, `ABTG_SuperWave.mq5`, `ABTG_Bulge.mq5`, il giornale del 07/10 di qualunque terminale.
**I numeri del coach sono "[DICHIARATO, NON verificato]"; le convergenze con Emiliano NON sono indipendenti** (il corso e' la fonte di molte nostre sedie).

## 4.1 CONFERMATI

| sedia / EA | cosa dice Emiliano (citazione) | cosa c'e' da noi | verdetto |
|---|---|---|---|
| **`770101` DAX Apertura long (RETEST), `770105` short, famiglia Apertura** | *"i livelli li va sempre a ritestare, per definirli"* (r.169); *"il retest e' il momento in cui puo' rientrare"* (r.171); *"Io lo attenderei su un eventuale ritest dei minimi della notte"* (r.23) | RETEST = il motore vivo: BREAKOUT, RANGE_FADE, DELAYED **bocciati**, RETEST *"re incontrastato"* (`DIARIO.md` r.87); `770101` PF OOS 1,397 su 193 posizioni (scheda 10/05 §C14) | **CONFERMA l'impianto**. **Non indipendente.** Il suo retest e' sui **minimi della notte**, il nostro sul **range d'apertura a 35'**: **non e' lo stesso livello** (vedi P-1) |
| **`770411` MaxMin DAX short** | *"i massimi e i minimi della notte ... bisogna applicarla in maniera costante, non una volta si', una volta no"* (r.85-87) | PF OOS 2,16 su **14** posizioni (n<30, non si legge) (scheda 10/05 §C1) | **CONFERMA l'impianto** (stessa scuola); **non e' prova di merito** |
| **Gestione parziale + stop in pari** | r.143-151 | TP1 50% + BE + trailing PREVBAR M5 (scheda 10/05 §C10) | **CONFERMA** (gia' nostra) |
| **`770411` gestione ad ATR** | *"l'uscita qua con l'ATR"* (r.205) | `770411` 2,5x ATR(`InpMgmtTF`) (`APERTURE_DAX_MAPPA` §3, riga TF/ATR) | **CONFERMA la forma**, **parametri non detti** (S8) |
| **Filtro volumi (RETEST Nasdaq)** | *"per rompere il livello ... ci devono essere i volumi"*; M15 decrescenti = non si entra (r.193-195) | *"Giornata 01/10: la RETEST Nasdaq ha saltato per volumi insufficienti ... E' il filtro volumi che fa il suo lavoro"* (`APERTURE_NASDAQ_MAPPA` r.50) | **CONVERGE di forma** (non indipendente); **non sappiamo** se il DAX RETEST ha il filtro `[NON VERIFICATO da me]` |
| **ORB DAX non da fare** | Emiliano rinuncia all'ORB short sui minimi della notte (r.195) | DAX breakout 5-15' **0/8 in OOS** (ma **7/8 positive in IS**: ribaltamento), solo 35' positivo in entrambe le finestre (`CENSIMENTO_ORB` §0 punto 4, §5) | **CONFERMA ex post** solo sull'OOS (aneddoto, n=1) |
| **`771531` EMA200 / Bulge** come "livello di confluenza" | la *"media 200 H1"* e le medie 14/89/100 sono **ingredienti** della confluenza (r.59, r.63, r.71) | `771531` EMA200 H1 Dow (cella viva, 257 posizioni); sul **DAX** l'EMA200 H1 e' **0/28** (scheda 10/05 §C4) | **non conferma l'EMA200 come regola autonoma**: per lui e' un ingrediente a occhio (stessa lettura del 05/10) |

## 4.2 CONTRADDETTI o MESSI IN DUBBIO

| sedia / EA | cosa dice Emiliano (citazione) | cosa c'e' da noi | verdetto |
|---|---|---|---|
| **Sedie DAX: un solo ciclo al giorno** (`770101`, `770105`, `770411`: `InpOneTradePerDay=true`, scheda 09/30 r.279) | **retest con la stessa size** *"se avevo 10 mettevo 10"* (r.169) e *"fieno in cascina"* (r.171); **terzo ordine** al tondo (r.129) | un ciclo/giorno, un solo stop, rischio in % del conto | **CONTRADDICE il modello**: re-entry e scale-in **non si copiano** (esclusione di casa); **non si misura** come candidato |
| **Regola dell'apertura** (famiglia Apertura: BREAKOUT/RETEST/FADE) | **07/10:** *"aperto sotto un livello di resistenza ... tendo ad andare short"*; **05/10:** *"scarica sempre in direzione opposta"* | RANGE_FADE DAX **0/24** celle con PF >= 1 (OOS 0,772, stop 13,7x lo spread: ESCLUSO PER COSTO); BREAKOUT nudo **chiuso** (`CENSIMENTO_ORB` §0.3) | **Le due frasi (05/10 e 07/10) si compongono** (primo scarico opposto, poi direzione: §1.0); **ma nessuna e' misurata**. Il suo giorno (rimbalzo prima del calo) assomiglia piu' a un **retest** che a un **breakout**, e il **fade** del primo scarico da noi e' 0/24: aneddoto n=1 |
| **`770411` arma pre-apertura (08:59 IT)** | Luca r.47-53: *"a ridosso dell'apertura ... assolutamente non si opera"*; Emiliano r.55 concorda; **ma** r.85-87 sui max/min della notte *"in pre-apertura ... si fa l'operazione"* `[TRASCRITTO dubbio]` | scheda 10/05 §C2 (la tensione c'era gia'); `PRV_DAXAP_03` (ritardo +5/+10/+15: IS sale, OOS crolla su 13-15 deal) | **TENSIONE RIPETUTA, terza live** (02/10, 05/10, 07/10): i due coach **non sono coerenti** sul pre-apertura. **Non cambia nessun numero nostro** |
| **Stop 20-30 punti sul DAX** (r.65) | **[DERIVATO]** 11,8-17,6x lo spread BCM | frontiera `stop >= 40 x spread` = 68,0 idx (BCM 1,70), 53,2 (FTMO P95 1,33); pavimento duro 13,3x | **il suo stop NON passa il nostro cancello di costo**: se lo si volesse tradurre in EA, lo stop va rifatto a >= 68 (BCM). Non e' un dettaglio |
| **Lato short sugli indici** | Emiliano **shorta** il DAX (r.123-131); **Paolo 06/10**: *"a me gli indici short non mi piace farli"* (analisi Paolo r.151) | 770105 short PF 0,965/0,957, DD OOS 12,3%; 770411 n=14 (scheda 10/05 §C1, §C14) | **i due coach divergono sul lato**; nessun numero nostro si muove |
| **Numero tondo come livello** | oggi: **solo con confluenza** (r.93-101, r.191); 02/10 e 05/10: livello in se' | `SRBlocked` (opt-in, spento) conosce PDH/PDL e tondi come **ostacoli** (scheda 10/05 §C6); la misura S2 (05/10) usa **tondo = livello** | **Cambia l'ipotesi**: la misura S2 (scheda 10/05) deve distinguere **tondo da solo** da **tondo con confluenza** |
| **Contro-trend** | *"Mi metto contro trend"* (r.173-179) | le nostre sedie sono tutte con filtro di direzione dove misurato (EMA H4 1/50 sul Dow `770202`: spento PF 1,03, acceso 1,24; scheda 10/05 §C7) | **MESSO IN DUBBIO** (**anche da lui**, r.189-191 *"sempre in direzione"*) |
| **VWAP come filtro/livello** | *"mi ha salvato tantissime volte"* (r.81) | R101 `07_vwap`: PF +0,007 Dow / -0,061 DAX, **bocciato** (ma e' il VWAP **di sessione**, come filtro) (`ANALISI_LIVE_PAOLO_2026-09-29.md` O2) | **NON coperto**: il VWAP **come livello d'ingresso/stop/obiettivo su M15** non e' mai stato misurato `[NON VERIFICATO da me, ho cercato in REGISTRO e nelle schede]` |
| **Filtro news** | *"in prossimita' di dati, cancello tutto"* (r.207) | nei preset FTMO dei cinque indici `InpUseNewsFilter=false` (scheda 10/01 §9.5); `abtg_news.csv` ha per ottobre **solo** FOMC 28/10 e ECB 29/10 `[MISURATO grep]` | **Confermata come buona pratica del coach, NON come cosa nostra**: la decisione sul filtro news e' di Claudio (gia' agli atti). **Nessuna azione** |
| **Oro** (Ban long contro-D1, ~29 di stop) | *"prima o poi ci lascio le penne"* (r.191), *"ti sei preso troppo rischio"* (r.199); long solo in trading range e solo se il weekly e' incerto | tre trade manuali sull'oro del 30/09 (HANDOFF) | **promemoria di casa, non un giudizio su nessuno**: lo stesso schema (long/short alternati contro-direzione) e' quello che il coach sconsiglia |

## 4.3 NUOVI DA MISURARE (SOLO come proposta, mai come criterio; ogni numero e' un'attesa scritta ORA, prima di guardare)

Ordine di valore per **una sedia schierabile**: **basso** (la live e' discrezionale; i pezzi misurabili sono un livello e un filtro). Regole di casa: nessuna griglia su motori senza edge;
**due lati sempre**; **n >= 150** per il merito (altrimenti il merito e' sospeso: si giudicano forma e rischio); **regime dichiarato**; **40 x spread** come primo cancello; **orologio dichiarato**.
**Nessuna riga di lancio e' preparata.**

### P-1 - "Il retest del minimo/massimo della notte (non del range d'apertura)": passo 0 di COSTO prima di tutto
- **Perche':** e' il **setup della live** (r.23: *"un eventuale ritest dei minimi della notte"*) ed e' **diverso** dal nostro retest (range d'apertura a 35'). Nel repo il **box notturno** e' coperto solo come **rottura** (`770411` short; rottura LONG 0/18 celle) `[LETTO via scheda 10/05 §C1]`; **un retest del livello notturno rotto non lo trovo in nessuna mappa** `[NON VERIFICATO da me]` (cerca fatta: `retest.*notte` in REGISTRO e report: solo `REGISTRO_TEST.md` r.382, che parla di un filtro distanza/ADR, non di una misura).
- **Passo 0 (aritmetica, 0 minuti):** il suo stop e' **20-30 punti** (r.65) = **11,8-17,6x** lo spread BCM 1,70 `[DERIVATO]`. **Sotto il 13,3x duro il 20; sotto il 40x in ogni caso.** Quindi *per come lo fa lui* la misura **chiude da sola** per costo, **con il numero accanto**. Resta un'unica domanda: **se il retest e' leggibile a stop >= 68 (M30/H1)**.
- **Passo 1 (solo se vuole proseguire):** definizione congelata: evento = **prima chiusura M30** oltre il minimo (o massimo) della notte dopo l'apertura cash (la finestra della notte e' **quella del preset `770411`**, letta dal preset, non scelta); esito = il prezzo torna a `<= 0,2 x ATR14(H1)` dal livello **entro 2 ore** e poi si allontana di `1 x ATR14(H1)` **prima** di rientrare nel box. **Lati: entrambi.** **Orologio da UTC** (non l'ora fissa 8).
- **Attesa (scritta ora):** **nessuna differenza** fra P(continuazione | ritest) e P(continuazione | nessun ritest) oltre la banda bootstrap; entrambe **0,50 +/- 0,05**. **Contro-esempio:** P(continuazione | ritest) sopra la banda in **IS-era e OOS-era** con **n >= 40 per era**.
- **n atteso:** `[NON MISURATO]`; con ~459 feriali (`APERTURE_NASDAQ_MAPPA` §0.2) e un evento *"si rompe e ritorna"* ~15-25% = **70-115 giorni** = **35-55 per era** = **sul bordo**: se < 40 -> *"non misurabile per campione"*, **non "morto"**.
- **Costo:** **0 minuti di tester** (Python su M1 `D30EUR`). **Non fa:** non tocca nessuna sedia.

### P-2 - "Filtro volume M15 sul DAX RETEST": un'unica domanda, poi eventualmente uno split ex post (zero tester)
- **Perche':** r.193-195 e il filtro volumi gia' vivo sulla RETEST Nasdaq. **Prima domanda (lettura del sorgente, 0 minuti):** il DAX RETEST (`770101`/`770105`) **lo ha**? `[NON VERIFICATO da me]` (non ho letto `ABTG_DAX_Apertura_EU.mq5` per questo).
- **Se non ce l'ha e se esistono i per-trade:** **un solo split ex post**: volume M15 della candela di segnale sopra/sotto la **mediana dei giorni** (definizione unica, congelata ora). **Avvertenza dichiarata:** i volumi BCM sono **tick**, non reali; lo dice anche Paolo nella live 06/10 (r.269: *"sono relativi all'attivita' di scambio che fa quel broker"*).
- **Attesa:** nessuna differenza di PF oltre ~0,15 (rumore gia' misurato in scheda 10/05 §S1); **contro-esempio:** PF(basso volume) < 0,85 **e** PF(alto) > 1,25 in entrambe le ere con n >= 40.

### P-3 - "Il 07/10 al minuto" (**zero macchina**, una domanda a Claudio; stile S4 del 05/10)
- **Domanda:** il DAX stamattina ha fatto davvero *"aperto sotto il livello, rimbalzo fino a VWAP/tondo, poi circa 80 punti giu'"* (r.117-131, r.169) e **che cosa hanno fatto le sedie** (`770411`, `770101`, `770105`)?
- **Cosa serve:** screenshot M5 `D30EUR` (BCM) o `GER40.cash` (FTMO) **08:50-10:00 ora italiana** + il giornale delle sedie del 07/10 (**con numero di conto e cartella programma scritti in testa**). Oggi e' ancora ora legale: BCM = IT-1.
- **Attesa (scritta ora):** il DAX ha **aperto sotto** il livello identificato (minimo della notte) (r.117), ha **toccato il VWAP o il tondo 25.300 entro i primi ~30 minuti** (r.121-131) e poi e' sceso di **~80 punti** (r.169). **Contro-esempio:** non tocca il VWAP/tondo nei primi 30', **oppure** il calo successivo e' **< 40 punti** `[40 = meta' degli 80 dichiarati, scelto solo per definire il contro-esempio]`: la mattina descritta non e' quella che vedo.
- **Costo:** zero. **Limite:** **n = 1 giorno**: e' **una domanda, non evidenza**.

### Cosa NON propongo (col motivo)
- **Re-entry con la stessa size / scale-in 2-4-10-20 / "chiudi meta' per coprire la perdita"**: esclusione di casa (rischio non cappato, un ciclo/giorno).
- **Il sistema di Girolamo (pendenti su tutti i numeri tondi)**: **griglia di ordini su livelli fissi**, stop non detto, nessun edge misurato, nessuna fonte oltre la parola del coach. (Non e' la regola del 19/08, che vieta le griglie di **parametri** su motori senza edge: qui il motivo e' che una griglia di ordini senza stop dichiarato e' rischio non cappato.) **Intelligence, non pratica.**
- **Contro-trend sul tondo / oro in contro-direzione**: lo sconsiglia lui stesso (r.189-191).
- **ORB DAX/oro**: gia' misurati e negativi (`CENSIMENTO_ORB` §0.4-§0.5).
- **Il VWAP M15 come livello**: **non lo propongo come misura nuova** da questa live perche' i dati non dicono ne' l'ancoraggio ne' le deviazioni (S4): **prima la domanda a Emiliano**.
- **Qualunque modifica in forward, preset, taglia o filtro news**: sono decisioni di Claudio.

---

# PARTE 5 - DOMANDE PER CLAUDIO (che conosce Emiliano di persona)

| # | domanda | perche' |
|---|---|---|
| D1 | A Emiliano: la lettura giusta e' **"prima scarica in direzione opposta alla candela di pre-apertura (05/10, richiamata il 07/10 r.63), poi si lavora la direzione dalla resistenza (07/10 r.123)"**? Che cosa conta come "candela importante" (punti? fra le 8 e le 9 di quale fuso)? | le due frasi si compongono (§1.0) ma nessuna ha una soglia: senza la soglia non si misura |
| D2 | A Emiliano: **il "10" di r.143** (*"il secondo ordine mi porta a casa 10"*) sono **punti** o **contratti**? E il **"5 e 10"** di r.169? | senza questo il suo guadagno non si legge |
| D3 | A Emiliano: *"col secondo ordine penso di andare a riparare l'operazione"* (r.187): **il primo ordine ha uno stop?** o l'obiettivo e' mediare? | e' **mediazione** se non c'e' stop sul primo |
| D4 | **Per riascoltare**: i passaggi S1, S2, S7, S8 della registrazione (il `.txt` non ha timestamp) | §2.9 |
| D5 | A Emiliano: l'**ATR dell'uscita** (r.205): periodo, TF, moltiplicatore. E il **VWAP M15**: ancoraggio e deviazioni dei *"canali di regressione"* | per confrontare con `770411` (2,5x ATR) e R101 |
| D6 | A Emiliano: la **"sweet"/currency strength** (r.205) e' la **nostra `ABTG_ForzaFX_Dashboard`** (che ha una specifica **OMBRA** in `report/OMBRA_FORZAFX_SPEC_2026-10-05.md`) o un'altra dashboard del corso? | per non confondere due indicatori |
| D7 | Il **sistema di Girolamo** (pendenti sui numeri tondi): esiste un file? Claudio lo ha mai visto girare? | solo per documentarlo come intelligence/griglia |
| D8 | Screenshot **07/10 08:50-10:00 IT del DAX** + giornale sedie 07/10, **con numero di conto e cartella in testa** | P-3 |

---

# PARTE 6 - NESSUNA AZIONE SUL CAMPO

- **Non toccato:** nessun preset, EA, sedia, conto, terminale, VPS, forward, parametro di rischio o taglia. Nessun round lanciato, nessuna riga di lancio scritta, nessun messaggio a Claudio.
- **Letto solo:** trascrizione `LIVE_EMILIANO_2026-10-07.txt`; schede e mappe del repo citate; `mql5/Files/abtg_news.csv` (grep).
- **Documento passato dal cancello (strati 1 e 2, 07/10).** Le proposte della Parte 4 restano **specifiche**: per diventare un file prova ripassano **di nuovo** dai due strati.

## Esito del controllo deterministico
`python3 backtest_pipeline/controlla_riga.py --oggetto md` su questo file e su `ANALISI_LIVE_PAOLO_2026-10-06.md` (07/10/2026): **ESITO: nessun difetto meccanico**, nessun rilievo su questo file. Strato 2 (`controllo-preventivo`) fatto il 07/10: **PASS CON RISERVE** dopo le correzioni elencate in fondo.

## Correzioni del cancello (strato 2, `controllo-preventivo`, 07/10/2026)
Fatte nel file prima della consegna, controllate alla fonte (`cat -n` delle trascrizioni 05/10 e 07/10, mappe, censimento):
- **La "contraddizione fra live" (05/10 vs 07/10) e' ritirata**, con la B11: la regola del 05/10 (r.141-155: candela importante 8-9 -> primo scarico opposto) e' **richiamata** il 07/10 (r.63) e la mattina la segue (rimbalzo, poi short dalla resistenza). §1.0, §1.2 riga 3, §1.5, §2.7, Parte 3, §4.2 e D1 riscritti. Bandiere: 10 (5 arancioni, 5 ambra).
- §1.0: (2) "chiudi meta'" e' **ambra** (B6), non arancione; (3) la scala e' in parte **di Luca** (r.69); B4 motiva perche' arancione e non rossa (stop comune dichiarato r.65/r.71; rossa se D3 dice "niente stop").
- Stop 20-30 punti (r.65) e' il **piano di Luca** approvato da Emiliano (r.73), non "quello che fa lui".
- §4.1 ORB DAX: "0/4 OOS" -> **0/8 in OOS, 7/8 in IS** (`CENSIMENTO_ORB` §0 punto 4).
- M3: **non** e' la prima volta nel corso (live Paolo 05/05, 07/05, 03/09; `ABTG_DAX_M3`): e' la prima nelle live Emiliano trascritte.
- Girolamo: il motivo d'esclusione **non** e' la regola del 19/08 (griglie di parametri) ma il rischio non cappato di una griglia di ordini.
- Conteggi/righe: VWAP 26 occorrenze; "Io lo faccio quasi sempre" e' r.163.
