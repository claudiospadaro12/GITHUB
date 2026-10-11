# PER GEMINI -- Piano di misura "stesso motore pullback, TF da H1 a M30": rilettura di attese, smentita e soglie scritte PRIMA dei numeri -- 11/10/2026

Scritto da Claude per Gemini, secondo `docs/gemini/PROTOCOLLO_SQUADRA_2026-10-08.md` (ricevuto insieme a questo file) e la BASE di conoscenza che ricevi in testa. Il pacchetto si legge da solo e contiene solo cio' che serve alle tre domande della sez. 6.
**Perche' esiste**: regola di casa dell'11/10, punto 3 (piano di misura nuovo: Gemini rilegge attesa, smentita e soglie scritte prima dei numeri). **La misura NON e' ancora stata fatta**: i numeri M30 non esistono; quelli di sotto sono tutti del pilota H1 (gia' letto) o conti su di essi.
Niente preset, righe o script di lancio, conti, importi o nomi di terzi in questo documento.
**Nota importante**: l'EA e' una **ricostruzione nostra** (da descrizioni a voce di terzi): i numeri dicono cosa fa *quella ricostruzione* sul feed del nostro broker, non cosa fa l'EA di altri.

Etichette di questo pacchetto: **[FATTO]** = letto o ricontato da noi su un file del repo (la fonte e' accanto); **[CALCOLO]** = conto su fatti, formula e numeri scritti; **[IPOTESI]** = ragionamento nostro, non verificato; **[NON MISURATO]** = il numero non esiste. Il marcatore **[INFERITO, NON VERIFICATO]** e' quello del nostro file prova: vale per la proporzionalita' fra n e (1 - f), spiegata in 3.2.

**Cosa chiediamo, e come rispondere (ruoli del protocollo)**: **Q1** al ruolo **B** (avvocato del diavolo), **Q2** al ruolo **C** (auditor, un conto solo), **Q3** al ruolo **B**. Una domanda per chiamata. Tabella `N | Affermazione | Etichetta (FATTO / CALCOLO / IPOTESI / NON LO SO) | Fonte (sezione del PACCHETTO, oppure "mia conoscenza di mercato, non verificata") | Verificabile da noi come | Costo`. Ogni affermazione senza fonte e' IPOTESI. "NON LO SO" e' una risposta valida e preferita a un numero inventato. Cita i NOMI degli input o dei campi del giornale, mai numeri di riga.

---

## 1. Il motore e cosa si misura

- **Motore** [descrizione = ricostruzione]: pullback su tre linee Supertrend (periodo ATR 10, moltiplicatori 2,5 / 3,0 / 3,5) e su una EMA200; ordini pendenti a scala sul ritorno verso la linea; filtri: ADX (soglia 20, periodo 14) e inclinazione della EMA200 (variazione sulle ultime 20 barre divisa per l'ATR14, soglia minima fissa); TP e stop in unita' di prezzo FISSE (non in multipli di ATR); una posizione per volta; tre "modi" di stop (GEOM, LINEA, PIU) che cambiano solo dove sta lo stop. Una "config" (A) usa le tre linee piu' i filtri; una seconda (M2) usa solo la EMA200, senza ADX.
- **Cosa cambia in questo piano**: UNA variabile, il TF del segnale, **H1 -> M30**, a parita' di simbolo, config, lato, modo di stop, soglie, deposito, rischio, finestra e modello. La fonte del metodo dice "non sotto H1": M30 e' una **misura voluta dal capo del progetto** (verbale `report/FIRME_2026-10-11.md`, punto 1), **non** il metodo originale. Nell'EA e' un input nuovo che di default lascia il rifiuto (v1.12) [FATTO: `mql5/Experts/EA_NatCla.mq5`, input `InpAmmettiTFSottoH1`, default false].
- **Perche' M30**: il muro dei 150 operazioni per leggere il MERITO (regola di casa: merito sospeso sotto n=150, rischio sempre giudicato). Sull'oro H1 la finestra di prova (solo IS, 2024.07.10 -> 2025.06.30, OOS 2025.07.01 -> 2026.06.30 NON toccato) da' n=144 e n=134, appena sotto [FATTO: sez. 2.1]. Le barre M30 sono il doppio: la leva e' "piu' barre, piu' setup".
- **Condizioni** [FATTO: file prova `backtest_pipeline/prove/NATCLA_F1_M30_2026-10-11.txt`, SHA256 `15c70437e714af3ef04a186bf38b2e5d68c28b954db6e7f2f11a9ba16414cefd`, pin `307f37a12c4b10a0dee59c4dbe0d4a2f82103308`, bozza NON passata dal nostro cancello]: tick reali (modello 4, 100%), deposito 1.000.000 EUR, rischio per setup 0,25% (segnaposto, nessuna taglia nuova), commissione e costo come il piano madre, Guardian nel tester fail-open. Un regime (oro in forte rialzo nell'IS), un broker.
- **Il lotto**: quattro passate, tutte nell'IS: (1) oro, config A, H1, long, GEOM = CONTROLLO di identita' della nuova versione dell'EA su H1; (2) oro, config A, M30, long, GEOM; (3) oro, config A, M30, long, PIU; (4) EURUSD, config M2, M30, short, GEOM. Esclusa la passata EURUSD config A short LINEA: la sua versione H1 e' KO per il lettore (caso P_003, sez. 5).
- **Cosa il lotto NON fa**: nessun verdetto di merito, nessuna promozione, nessuna sedia, nessun PF come criterio. Il verdetto massimo di ogni gamba e' "NON ANCORA MISURATO (mancano le caselle 3 e 4 del certificato)". Nessuna gamba del lotto puo' essere VIVA (la regola del segno vuole almeno 2 simboli votanti; qui l'oro e' 1 e il forex 1 su 7).

## 2. I numeri del pilota H1 (gia' letto, di riferimento)

### 2.1 Le tre gambe H1 leggibili  [FATTO: `report/NATCLA_F1_P_LETTURA_2026-10-11.md`, commit 336597ae, e `backtest_pipeline/risultati_archivio/NATCLA_F1_P_20261011/LETTURA_leggi_natcla_f1_P.txt`]
Lettore passato dal cancello; pilota di colla: **un PF qui non vale niente** (n sottile).
| gamba (H1) | n setup | PF_R | PF_R nullo (geometria vera) | durata mediana (min) | secondi di macchina |
|---|---:|---:|---:|---:|---:|
| oro, config A, long, GEOM | 144 | 1,32 | 0,93 | 70 | 133 |
| oro, config A, long, PIU | 134 | 1,13 | 0,96 | 95 | 168 |
| EURUSD, config M2, short, GEOM | 92 | 0,78 | 0,83 | 20 | 83 |
- Tick nell'IS: oro 53.339.206, EURUSD 24.018.311 [FATTO: report del tester nello zip archiviato]; barre H1: oro 5.651, EURUSD 6.071 [FATTO: sez. A6 del file prova].
- n reale = 2,16-2,36 volte l'attesa del nostro conteggio precedente (3 gambe) [FATTO: stessa lettura]: le bande di n del pilota erano sbagliate, ricalibrate in 3.1.
- Media di R della prima gamba +0,06 con p(>0) = 0,093: non distinguibile da zero [FATTO]. GEOM contro PIU: delta -0,19 contro delta del nullo 0,03 [FATTO]: nessuna differenza distinguibile.
- Ordini falliti con retcode 10018 (mercato chiuso 22:00-00:00 ora server): 29 / 29 / 9 / 5 nelle quattro passate H1 [FATTO].

### 2.2 L'imbuto del pilota H1: le frazioni respinte  [CALCOLO nostro, rifatto da noi sul giornale dell'EA dello zip archiviato, `NATCLA_F1_P.zip`, commit 336597ae; righe `[NATCLA-IMBUTO]` giornaliere, deduplicate (il giornale le stampa due volte)]
Ogni valutazione di barra (per linea) finisce in UNO stadio dell'imbuto: la partizione quadra (oro GEOM: somma degli stadi = 16.950 = valutate). L'ordine degli stadi e' quello dei campi del giornale [IPOTESI: coincide con l'ordine dei test nel codice].
**Definizione di f**: f = respinti dal filtro / (respinti dal filtro + valutazioni arrivate DOPO il filtro), somma di tutti i giorni. "Dopo l'inclinazione" = semaforo + nessun ordine valido + ARMATO (gli stadi confluenza, spread, timing, conferma, ritardo, apertura lontana valgono 0 in tutte le passate).
| passata H1 | valutate | lato spento | conteggio esaurito | ADX | inclinazione | dopo l'inclinazione (di cui ARMATO) | setup | f inclinazione | f ADX |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| oro A long GEOM | 16.950 (+3 nel parziale finale = 16.953) | 7.318 | 1.773 | 2.502 | 2.230 | 2.230 (2.063) | 144 | 0,500 | 0,359 |
| oro A long PIU | 16.950 | 6.805 | 1.740 | 2.502 | 2.144 | 2.208 (1.930) | 134 | 0,493 | 0,365 |
| EURUSD A short LINEA | 18.207 | 8.712 | 1.879 | 2.085 | 2.380 | 2.299 (1.818) | KO | 0,509 | 0,308 |
| EURUSD M2 short GEOM | 6.069 | 3.205 | 0 | 0 | 401 | 2.096 (2.094) | 92 | 0,161 | -- |
- f ADX = ADX / (ADX + inclinazione + dopo l'inclinazione). Per M2 f e' "per barra", non per setup: M2 si riarma a ogni barra.
- **Incertezza di f sul pilota H1** [CALCOLO nostro: bootstrap per giorno, 5.000 ricampionamenti, 277 giorni]: oro GEOM f = 0,500, intervallo 2,5-97,5% = **0,429-0,573** (errore standard circa 0,037); oro PIU 0,422-0,565. L'errore binomiale "ingenuo" sarebbe 0,0075 (N circa 4.460) ma ignora che valutazioni di barre vicine sono dipendenti.
- Le due gambe oro condividono gli STESSI giorni e quasi le stesse valutazioni (differiscono solo nel modo di stop): sono **una** osservazione di f, non due [IPOTESI sulla dipendenza; i due f differiscono di 0,007].
- **Rapporto n / ARMATO** nell'oro H1: 144 setup su 2.063 valutazioni ARMATO (circa 1 su 14): "ARMATO" conta valutazioni, non episodi [FATTO].

### 2.3 Come scala n con le barre, nei dati che abbiamo  [FATTO: `report/NATCLA_F0_A_LETTURA_2026-10-09.md`; conteggio di setup, 11 simboli forex, finestra di 1,99 anni, modello OHLC su M1, config A; NON i tick reali]
setup totali: H1 5.089 · H4 1.225 · H12 461 · D1 252.
| passaggio | barre per periodo di quello piu' grosso | rapporto di setup (misurato) | esponente [CALCOLO] = ln(rapporto setup) / ln(rapporto barre) |
|---|---:|---:|---:|
| H1 -> H4 | x4 | 4,15 | 1,03 |
| H4 -> H12 | x3 | 2,66 | 0,89 |
| H12 -> D1 | x2 | 1,83 | 0,87 |
Quasi proporzionale da H1 a H4, sotto-proporzionale piu' in alto. **Il passaggio H1 -> M30 (barre x2, TF piu' FINE) non e' mai stato misurato** [NON MISURATO]. Da qui la stima del nostro piano: n M30 = circa 2,0 volte n H1 come ancora, ridotta a circa 1,4 dall'effetto della soglia trasportata (3.2).

## 3. Il piano: attese scritte PRIMA dei numeri  [FATTO: sezioni A0-A7 del file prova; le cifre sotto sono quelle scritte nel file, ricontrollate da noi a mano]

### 3.1 Attese
- **A0 (identita')**: la passata di controllo H1 della nuova versione riproduce **riga per riga** le righe SETUP della passata H1 del pilota (n=144, stesse barre, stessi esiti; operazioni 232, tick 53.339.206, barre 5.651). **Smentita**: anche UNA riga diversa a tick uguali = la nuova versione ha cambiato il comportamento su H1: STOP, il lotto M30 non si legge. Tick diversi = ambiente cambiato (storico riscaricato): A0 non decide.
- **A1 (n per gamba M30 contro n H1 misurato)**: banda coerente x1,2 - x2,6 di n H1: oro GEOM 144 -> 173-374 (centri 288 con x2,0 e 202 con x1,4); oro PIU 134 -> 161-348 (268 / 188); EURUSD M2 92 -> 110-239 (184 / 129). Fuori banda = DA GUARDARE; sotto x0,5 o sopra x5 = STOP. [CALCOLO: 144 x 1,2 = 172,8; 144 x 2,6 = 374,4; 134 x 1,2 = 160,8; 134 x 2,6 = 348,4; 92 x 1,2 = 110,4; 92 x 2,6 = 239,2; verificato.] Il centro x1,4 e' l'ipotesi "soglia trasportata piu' severa" (3.2) con la proporzionalita' sotto.
- **A2 (imbuto)**: la frazione f respinta dall'inclinazione su M30, per le gambe oro config A, si legge cosi': **<= 0,56** = la soglia trasportata da H1 si comporta ancora da "meta' dei casi" anche su M30; **>= 0,59** = piu' severa (il confronto H1/M30 confonde TF e severita' del filtro); **fra 0,56 e 0,59** = non distinguibile. Ipotesi "soglia piu' severa": f circa 0,65; ipotesi "senza scala": f circa 0,50. Per M2 solo il rapporto M30/H1 contro 0,161, senza soglia. ADX: nessuna soglia, si legge f ADX contro 0,359 / 0,365.
- **A3 (durata mediana)**: TP e stop sono in unita' fisse, quindi la durata mediana M30 attesa entro x0,5 - x2,0 di quella H1 della stessa gamba (70 / 95 / 20 min) [IPOTESI al primo ordine]. Alternativa: su M30 le linee stanno piu' vicine al prezzo, quindi nel modo PIU lo stop e' piu' stretto e la durata puo' accorciarsi; sotto x0,5 su PIU e' compatibile, su GEOM no.
- **A4 (lato e regime)**: invariato: nel regime dell'IS (oro in rialzo) il long con PF > 1 e lo short con PF < 1 e' regime, non linea; il lotto gira solo il long dell'oro e NON chiede nulla sul segno.
- **A5 (PF_R)**: nessuna attesa di direzione; il nullo per setup e' 0,93-0,98 (oro) e 0,77-0,94 (forex): un PF_R M30 dentro il nullo o a meno di +0,10 dal PF_R H1 della stessa gamba non distingue niente.
- **A6 (tempo)**: tick uguali, barre x2: per passata x1,0 (tutto per tick) - x2,0 (tutto per barra): lotto 9-19 minuti con compilazione. Smentita del modello: una passata M30 oltre x3 della sua H1 (oro GEOM oltre 400 s).
- **A7 (colla)**: operazioni del report = riempiti delle righe SETUP (fino a 3 in piu' per un setup aperto a fine test); ordini falliti 10018 (mercato chiuso) attesi **almeno** quanti su H1 (pilota: 29 / 29 / 9 / 5).

### 3.2 La smentita della ragione del piano, condizionata ad A2
La ragione e': "su M30 il campione sale in proporzione alle barre, quindi la leva del muro dei 150 funziona". **Smentita** (cioe': M30 NON porta il campione promesso):
1. n M30 sotto x1,2 di n H1 **in ENTRAMBE le gambe oro** (n GEOM < 173, n PIU < 161), **E**
2. f (inclinazione) **<= 0,56 in ENTRAMBE le gambe oro** (GEOM e PIU).
Se f e' >= 0,59, o fra 0,56 e 0,59, o solo una delle due gambe e' <= 0,56: la smentita **NON si emette**; il verdetto sulla leva e' **NON ANCORA MISURATO** (il campione puo' essere stato tagliato dalla soglia trasportata, non dal TF). Perche' la condizione su f: la soglia di inclinazione e' quella del 50-esimo percentile di H1, TRASPORTATA a M30 senza ricalcolarla (non esiste un "passo 0" su M30), quindi puo' da sola tagliare n.

**Derivazione dell'ipotesi "piu' severa"** [CALCOLO su ipotesi]: inclinazione = |EMA200 ora - EMA200 20 barre fa| / ATR14. Per lo stesso trend, su M30 il numeratore copre 10 ore invece di 20 (x0,5) e l'ATR14 e' circa x0,71 (passeggiata casuale: ATR cala con la radice del tempo) [IPOTESI: la scala radice(2) NON e' misurata su questi dati]: inclinazione M30 circa 0,71 x inclinazione H1. Percentili di inclinazione dell'oro, config A, H1, sui setup del conteggio precedente [FATTO: file prova madre `backtest_pipeline/prove/NATCLA_F1_STOP_2026-10-09.txt`, blocco "INCLINAZIONE P50"]: **P25 0,325 · P50 0,700 · P75 1,161**. La soglia H1 0,700 su M30 equivale a 0,700 / 0,71 = 0,986 in unita' H1, cioe' (interpolazione lineare fra P50 e P75, assunzione nostra) circa il 65-esimo percentile: f atteso circa 0,65.
**Proporzionalita'** [INFERITO, NON VERIFICATO]: n M30 / n H1 circa 2 x (1 - f_M30) / (1 - f_H1). Con f_H1 = 0,500: f_M30 = 0,50 -> x2,0; 0,56 -> x1,76; 0,59 -> x1,64; 0,65 -> x1,40 [CALCOLO]. **Non verificabile con i dati in repo**: f e' contata per VALUTAZIONE di barra per linea, e il rifiuto dell'inclinazione NON consuma l'"episodio" (lo stesso episodio puo' armarsi una barra dopo), quindi n puo' calare MENO di (1 - f).
Lettura: se f <= 0,56, il filtro da solo non puo' portare il rapporto sotto circa x1,76 [sempre sotto la proporzionalita' INFERITA]; un rapporto sotto x1,2 con f <= 0,56 non e' spiegabile dal filtro, e' un fatto sulla leva.

### 3.3 Note di lettura vincolanti (emerse dal nostro cancello sul piano)
1. La smentita si emette **solo se ENTRAMBE le gambe oro (GEOM e PIU) hanno f <= 0,56** (e n sotto x1,2 in entrambe): altrimenti NON ANCORA MISURATO.
2. Il passo successivo (3.4) e' necessario se f e' **> 0,56** (il file prova dice ">= 0,56" in un punto: lo leggiamo "> 0,56", perche' f = 0,56 esatto appartiene alla banda "<= 0,56").

### 3.4 Passo successivo dichiarato (NON in questo lotto)
Un **passo 0 su M30**: conteggio puro (nessun ordine, nessun P/L) dei setup su oro ed EURUSD per le due config, da cui ricalcolare P25/P50/P75 di inclinazione su M30 con la stessa regola di H1, PRIMA di qualunque P/L; poi file prova nuovo. Costo [IPOTESI, ancora: ~33 s a passata nei conteggi precedenti]. Serve un file prova nuovo e un driver adattato: pin nuovo e cancello. **Diventa necessario se f > 0,56** nelle gambe oro.

## 4. Limiti dichiarati (li scriviamo noi, prima che li trovi tu)
1. **Lettore assente per M30**: il lettore passato dal cancello legge solo la versione precedente dell'EA e il piano madre; per leggere il lotto M30 serve una modifica del lettore (cancello) o un lettore separato. Il confronto H1/M30 (A0-A3) e' scritto qui con i comandi e i numeri di riferimento, non automatizzato.
2. **A3 e T6 (durata e rischio) richiedono strumento**: la durata per gamba e il drawdown in R escono dal lettore, non dal solo driver.
3. **ADX a 20 non calibrato su M30**: periodo 14 su M30 copre 7 ore (14 su H1 coprono 14); la distribuzione dell'ADX su M30 [NON MISURATO]. Nessuna soglia ADX e' ritoccata dopo i numeri.
4. **Equivalenza "percentile per valutazione = P50 per setup" solo ipotesi su M30**: su H1 f e' risultata 0,500 con la soglia al P50 *dei setup* del conteggio precedente [FATTO], ma i due denominatori sono diversi (valutazioni di barra contro setup, e il conteggio precedente era a barra del tocco, il filtro guarda la barra prima [FATTO: nota del file prova madre]). Che valga anche su M30 e' una [IPOTESI].
5. **Compilazione non provata**: la nuova versione dell'EA non e' mai stata compilata (nessun compilatore nel posto dove e' stata scritta); la prima azione del lotto e' compilarla, e se fallisce il lotto si ferma prima del tester.
6. **Un regime, un broker, due simboli, un lato per simbolo**; solo IS (OOS intatto); soglia di inclinazione trasportata da H1 (non rispetta alla lettera la regola del passo 0, ed e' scritto).
7. **Caso P_003** (decisione separata, NON corretta qui): nel pilota H1, la passata EURUSD config A short LINEA e' KO perche' un ordine pendente non cancellato il venerdi' a mercato chiuso si riempie alla riapertura di domenica e viene "adottato" con rischio 0 (1 riga SETUP su 110). Su M30 le aperture di barra sono il doppio, quindi i riprezzamenti dentro 22:00-00:00 sono attesi almeno altrettanto frequenti [IPOTESI]. Se 2 o piu' passate M30 su 4 escono KO per questo caso, il lotto e' illeggibile.

## 5. Contro-esempi nostri, gia' fatti (non ripeterli: attaccali)
- **Errore di unita' su n** [FATTO: sez. A1 del file prova]: se si contassero ordini o deal invece dei setup, n M30 sarebbe 1,6-1,8 volte i setup (riempiti medi del pilota 1,60-1,77); con centro x2,0 cadrebbe a x3,2-3,6, fuori banda, ma con centro x1,4 cadrebbe a x2,2-2,5, **dentro** la banda. La banda da sola non prende l'errore di unita': lo prende il lettore (conta solo righe SETUP).
- **Controllo incrociato** [CALCOLO]: n previsto dalle frazioni dell'imbuto contro n misurato; scarto oltre il 25% = DA GUARDARE (non smentita), con il limite [INFERITO] di 3.2.
- **Identita'**: se la nuova versione avesse spostato anche solo la cifra di TF nell'identificatore delle posizioni su H1, il file dei risultati cambierebbe nome e il driver segna KO prima del confronto riga per riga.

## 6. Le domande (una per chiamata). Per ognuna: dato, nostra attesa, contro-esempio

**Q1 (ruolo B) -- Quale misura manca, o quale spiegazione alternativa fa si' che "il filtro taglia n in proporzione" non provi nulla su M30?**
Dato che la motiva: sez. 2.2, 2.3 e 3.2. La nostra lettura dell'esito (n M30 e f) passa per n M30 / n H1 circa 2 x (1 - f_M30) / (1 - f_H1), [INFERITO, NON VERIFICATO]. La regola di smentita dice: n < x1,2 in entrambe le gambe oro E f <= 0,56 in entrambe -> "la leva non funziona"; altrimenti NON ANCORA MISURATO.
Domanda: costruisci il contro-esempio. Descrivi una situazione concreta, compatibile con i dati H1 di sez. 2, in cui l'esito "n < x1,2 con f <= 0,56" avrebbe una causa DIVERSA da "il raddoppio delle barre non porta setup" (o in cui "n >= x1,2 con f >= 0,59" non proverebbe che il filtro taglia). Per ogni spiegazione alternativa dici quale campo dell'imbuto o quale numero del lotto (n, durata, stadi del giornale: lato spento, conteggio esaurito, ADX, inclinazione, semaforo, ARMATO) la mostrerebbe, o se il lotto, cosi' com'e', NON la puo' mostrare e che misura servirebbe.
Nostra attesa [IPOTESI]: la regola regge per le gambe oro con le soglie scritte, ma NON separa tre cause: (a) il numero di episodi non scala con le barre (esponente sotto 1 oltre H1 verso l'alto, 0,87-0,89: il verso verso il basso non e' misurato); (b) gli stadi a monte (lato spento, conteggio esaurito, ADX) cambiano composizione su M30 e quindi il denominatore di f; (c) rumore di n (con n circa 144 un conteggio poissoniano ha errore relativo circa 8%, [CALCOLO: 1/radice(144) = 0,083], e il rapporto fra due conteggi di questo ordine ne ha di piu'). Contro-esempio nostro: errore di unita' (sez. 5) -- misurato che il lettore lo prende.

**Q2 (ruolo C) -- Le fasce 0,56 / 0,59 separano davvero le due ipotesi "senza scala" (f circa 0,50) e "radice di 2" (f circa 0,65)? UN conto solo.**
Dato che la motiva: sez. 2.2 (errore standard di f su H1 circa 0,037, per giorno) e 3.2 (P25 0,325, P50 0,700, P75 1,161 per l'oro H1; inclinazione M30 = c x inclinazione H1, con c = 0,71 nell'ipotesi radice di 2 e c = 1 senza scala).
Domanda (UN conto, formula e controllo di verso): con interpolazione lineare fra i punti (P50, 0,700) e (P75, 1,161) dichiarata, e f atteso = percentile (in centesimi) della soglia 0,700 / c espressa in unita' H1: **per quali valori di c, f atteso cade in ciascuna delle tre fasce** (<= 0,56 / fra 0,56 e 0,59 / >= 0,59)? E, con errore standard 0,037 e approssimazione normale: con quale probabilita' una misura f dell'ipotesi "senza scala" (vero 0,50) uscirebbe > 0,56, e una dell'ipotesi "radice di 2" (vero 0,65) uscirebbe <= 0,56? Rispondi NON LO SO dove manca un dato (ad esempio: l'errore standard di f su M30 non e' misurato).
Nostra attesa [CALCOLO nostro, da rifare]: soglia 0,56 <-> c = 0,700 / (0,700 + 0,24 x 0,461) = **0,864**; soglia 0,59 <-> c = 0,700 / (0,700 + 0,36 x 0,461) = **0,808**; c = 0,71 -> percentile **65,5**; c = 0,85 -> circa 56,7 (nella fascia intermedia vicino al bordo 0,56). P(f_misurato > 0,56 | vero 0,50) = 1 - Phi(1,62) = circa **5%**; P(f_misurato <= 0,56 | vero 0,65) = Phi(-2,43) = circa **0,8%**. Limite nostro: l'errore standard 0,037 e' quello di H1 e di UN solo passaggio; due gambe oro condivise = una osservazione. Contro-esempio nostro: c = 0,85 (a meta' fra le due ipotesi) cade appena sotto 0,57: fascia intermedia, quindi NON ANCORA MISURATO, mai un verdetto sbagliato; ma il filtro taglia solo (1 - 0,567) / 0,5 = 0,87 del campione.

**Q3 (ruolo B) -- Quale lettura del lotto M30 sarebbe fuorviante per il confronto con H1 (TF, ADX, scala ATR)?**
Dato che la motiva: sez. 1 (una sola variabile cambia: il TF) e sez. 4 punti 3-4. In realta' cambiano insieme al TF anche le finestre IN BARRE dei parametri, che NON ritocchiamo: ADX periodo 14 (7 ore su M30 invece di 14), ATR del Supertrend periodo 10 (5 ore invece di 10), inclinazione su 20 barre (10 ore invece di 20), EMA200 (circa 4,2 giorni di borsa invece di circa 8,3), finestra di calcolo dell'EA 1.500 barre (circa 31 giorni invece di circa 62) [CALCOLO: barre x 0,5 ore; ipotesi 24 ore al giorno; i numeri in giorni sono approssimati]. Stop e TP restano in unita' di prezzo fisse: TP 10 unita' = circa 1,43 ATR14 M30 sull'oro (1,01 su H1) e circa 1,17 sull'EURUSD (0,83) [IPOTESI: ATR14 M30 = ATR14 H1 / radice di 2, NON misurato], dentro la banda ammessa su H1 (0,22-2,06).
Domanda: elenca al massimo 3 letture del confronto H1/M30 che sarebbero fuorvianti (es.: attribuire al TF una differenza di n, di PF_R o di durata che nasce da un parametro in barre non scalato; leggere f ADX come severita' di filtro mentre cambia la composizione dei dati), e per ognuna quale numero dell'output (stadi del giornale, n, durata mediana, PF_R contro nullo, secondi) la mostrerebbe, e che CONFRONTO ALLA PARI (stessa durata in ore invece di stesse barre) servirebbe. Non proporre di ritoccare le soglie dopo i numeri: dicci quale misura nuova servirebbe.
Nostra attesa [IPOTESI]: la lettura piu' fuorviante e' "M30 ha n piu' alto e PF_R simile, quindi M30 e' H1 con piu' campione": n e PF_R cambiano per TF, finestre in barre e soglia trasportata insieme, e il lotto non li separa; il pezzo che il lotto separa e' la soglia di inclinazione (A2). Contro-esempio nostro: la gamba di controllo H1 (A0) verifica solo che la nuova versione non cambi nulla su H1; NON verifica che M30 sia "H1 con piu' campione".

---

## 7. Fonti nel repo (branch `lavoro`, commit di oggi, da `git log`)
- File prova del piano: `backtest_pipeline/prove/NATCLA_F1_M30_2026-10-11.txt` (SHA256 `15c70437e714af3ef04a186bf38b2e5d68c28b954db6e7f2f11a9ba16414cefd`), commit 53d0241f; pin del lotto 307f37a1 (commit di pin); EA versione 1.12 con l'input nuovo di default spento: commit d1aef381.
- Pilota H1 (letto, numeri di riferimento): `report/NATCLA_F1_P_LETTURA_2026-10-11.md` e `backtest_pipeline/risultati_archivio/NATCLA_F1_P_20261011/` (commit 336597ae); piano madre con le soglie T1-T7 e i percentili di inclinazione: `backtest_pipeline/prove/NATCLA_F1_STOP_2026-10-09.txt`.
- Proposta M30 e muro dei 150: `report/NATCLA_MISURA_PARAMETRI_2026-10-10.md`, par. 9 punto 1; conteggio setup per TF: `report/NATCLA_F0_A_LETTURA_2026-10-09.md`; firma: `report/FIRME_2026-10-11.md`, punto 1.
- Memoria, BASE e protocollo: `docs/gemini/MEMORIA_CONDIVISA.md`, `docs/gemini/BASE_CONOSCENZA_PER_GEMINI_2026-10-04.md`, `docs/gemini/PROTOCOLLO_SQUADRA_2026-10-08.md` (ricevuti insieme a questo file).
- I conti di sez. 2.2 (frazioni f e bootstrap per giorno) sono nostri sul giornale dello zip archiviato; lo script di conto non e' in repo (e' un conto di una trentina di righe: somma per stadio, dedup per giorno, ricampionamento dei giorni).
