# Flotta di EA per una prop challenge — dove siamo arrivati

*Claudio — 6 settembre 2026*

---

## 1. A cosa serve questo documento

Ho letto il tuo sul PS5 ORB Bot e mi è venuta voglia di ricambiare con lo stesso
livello di onestà: cosa misuriamo, con quale strumento, e soprattutto cosa
abbiamo buttato via e perché.

Il progetto è una **flotta di Expert Advisor MQL5** pensata per superare una
prop challenge (target 10%, muro giornaliero 5%, muro totale 10%). L'impostazione
è diversa dalla tua — non un motore ottimizzato a fondo, ma molti motori
scorrelati con un modulo di rischio unico sopra — ma i problemi che troviamo
sono gli stessi, e sull'ultimo (costi reali di esecuzione) credo che tu sia
esattamente sul mio stesso muro. Se ha senso, su quello mi piacerebbe unire le
forze.

Qui dentro non ci sono dettagli di conto: solo metodo e risultati.

---

## 2. Il metodo: i criteri si congelano PRIMA dei numeri

È la regola che regge tutto il resto. Ogni round di test parte con un file di
criteri **scritto, datato e versionato prima di lanciare**: cosa promuove, cosa
boccia, con quali soglie, e con quale regola si sceglie la cella nella griglia.
Poi si gira. Chi ha scritto i criteri non li può cambiare dopo aver visto il
risultato.

Non è pignoleria: è nata da un errore mio. In un round avevo fatto dei confronti
prendendo la cella **migliore** della griglia invece del **centro
dell'altopiano**; rifacendoli con la regola giusta il risultato si è ribaltato.
Da allora la regola di selezione si dichiara insieme al numero — altrimenti il
numero non vuol dire niente.

### La gerarchia di fiducia (l'equivalente dei tuoi tre livelli)

| livello | cosa vale | come lo usiamo |
|---|---|---|
| **Backtest OHLC** | indicativo, mai promotivo | serve per esplorare griglie lunghe (20 anni) dove i tick non esistono. Da solo **non promuove niente** |
| **Backtest a tick reali** | promotivo, ma limitato nel tempo | il tetto barre del tester ci dà ~4 anni su M15 e ~1,3 su M5 per corsa: finestre più lunghe si spezzano in tranche, dichiarandolo |
| **Walk-forward IS/OOS** | è il metro standard | split dell'universo dei parametri, promozione solo su OOS |
| **Prova di regime** | il più severo | quattro finestre separate — toro, orso, laterale, crollo — misurate una per una invece che diluite in una media |
| **Forward reale** | l'unico giudice finale | contratto di ogni sedia confrontato col comportamento vero |

Il salto fra il primo e il secondo livello ha già ucciso un EA promosso: ne parlo
nella tabella della sezione 5.

Aggiungo una regola di caccia che ci ha risparmiato tempo: **quando un motore
risulta senza edge, si cerca un meccanismo diverso sulla stessa inefficienza,
mai altri parametri dello stesso motore morto.** Su un motore che dà 0 celle
positive su 48, una griglia nuova non trova un edge: trova un picco di rumore. E
la cella "verde per caso" è esattamente quella che brucia la challenge.

---

## 3. L'architettura: una flotta di sedie, ognuna con un contratto

Invece di un motore solo abbiamo una **quarantina di "sedie"**. Una sedia è una
combinazione EA + simbolo + orario, scelta per essere il più scorrelata possibile
dalle altre: chi lavora all'apertura di Francoforte, chi su quella cash USA, chi
di notte sull'oro, chi su cambi in sessione di Londra. Le correlazioni misurate
fra le sedie storiche del portafoglio sono vicine a zero, ed è quello il motivo
per cui esistono tante.

**Ogni sedia ha un contratto scritto**, con due sole voci ma vincolanti:
il **drawdown promesso** dal backtest della cella che l'ha promossa, e la
**frequenza promessa** (operazioni/mese di quella stessa finestra OOS). Il
censimento di questi contratti è un documento a parte, e la sua funzione è
rendere falsificabile il forward: senza DD promesso, qualunque drawdown reale non
viola niente.

Sopra le sedie c'è un **modulo di rischio unico sul conto**, con:

- **rischio per trade 0,65%.** Non è un gusto: Monte Carlo sulle serie reali dà
  p99 **8,51%** contro un muro statico del 10% — passa. Ma su un muro **trailing**
  lo stesso rischio dà p99 **12,05%**, cioè non passa. La taglia dipende dal
  **tipo di muro**, e va rifirmata se cambiamo prop;
- **pausa morbida al 4,0% giornaliero** e **chiusura d'emergenza al 4,9%** e al
  **9,9% totale** — mai sul muro esatto, sempre con un margine tecnico per spread
  e slippage in chiusura;
- **cap sul rischio aperto simultaneo al 3,25%** = 5 stop vivi da 0,65%.

Quest'ultimo numero è quello che mi ha insegnato di più. Non nasce da una teoria
ma da una misura sul forward vero: una mattina d'agosto avevamo **9 posizioni di
8 sedie aperte contemporaneamente = 5,85% di rischio aperto**, con p99
giornaliero al 5,67%. Su una prop col muro giornaliero al 5% quel giorno era già
oltre il limite, e nessuno se n'era accorto. Con più motori scorrelati il rischio
non è la singola sedia: è la **sovrapposizione**. E il vincolo giusto non è
"quante sedie sono accese" ma "quanti stop sono vivi adesso" — una griglia da
sola può fare 10 posizioni essendo una sedia sola.

### Il criterio di uscita, tre corsie

Una sedia si spegne per regole scritte, non a sensazione:

- **rischio** (per sedia, sempre, a qualunque numero di trade): DD forward oltre
  il DD promesso → revisione immediata. Un drawdown è un fatto, non serve un
  campione;
- **merito** (per famiglia, a 20 operazioni totali): famiglia in perdita →
  revisione di tutte le sedie, si spegne **la sedia colpevole**, la gemella
  positiva resta. Su un motore su cambi la versione GBPUSD reggeva e la USDJPY no:
  spegnere l'intera famiglia sarebbe stato un errore;
- **tagliando** (6 mesi): famiglia sotto le 20 operazioni e in perdita → revisione
  umana, nessun verdetto automatico su campione sottile. Anche una frequenza molto
  sotto quella promessa manda in revisione.

Porta di rientro: una sedia spenta rientra solo se **una misura nuova** le ridà
una ragione.

---

## 4. Le regole intoccabili, coi numeri che le hanno prodotte

**A. L'unità di misura è l'operazione, non l'anno.**
L'in-sample si dimensiona su **≥150 operazioni**, non su "cinque anni". La soglia
morde davvero: con n=75-159 la superficie dei parametri era frastagliata (una
cella che sporge, il resto su e giù = selezione che insegue il rumore); con
n=190-256 sullo stesso motore l'altopiano si legge a occhio. Quanti anni servano
lo detta la frequenza del motore, non il calendario: un motore che fa 25-53
trade/anno su H1 forex ha bisogno di ~5 anni di IS, e lo si calcola.

Corollario che ci ha fatto cambiare idea su un intero round: **non si boccia un
motore perché non guadagnava nel 2012.** Su un cambio, l'IS 2010-2016 dava
**0 celle positive su 28** e l'OOS ne faceva **25 su 28** — quella finestra
conteneva un'epoca morta per quel mercato, non un difetto del motore. Da lì la
regola: la finestra IS si sceglie sul numero di operazioni, e si **dichiara quale
regime contiene**.

**B. Il vecchio giudica il rischio, il recente giudica il merito.**
Un drawdown del 2020 è un fatto accaduto e vale per sempre. Un profitto del 2012
è una stima e vale poco. Quindi: campione sottile sospende il giudizio sul
merito, **mai** quello sul rischio.

**C. Sugli indici si misurano sempre entrambi i lati.**
Anche il lato già vivo in forward si ritesta, non si dà per buono perché "sta
girando". Ci è servita: applicandola abbiamo trovato un lato short mai misurato
che è diventato un candidato pieno, su un simbolo dove davamo per scontato che
funzionasse solo il long.

**D. E il limite in basso resta.**
Il difetto storico del progetto era l'opposto: a un certo punto **110 file prova
su 153** giravano su una finestra di soli 21 mesi. Un round con 27 operazioni
in-sample, 46 out-of-sample e **un solo regime** non è misurabile nemmeno per il
merito.

---

## 5. Cosa abbiamo scartato, con i numeri

Questa per me è la sezione che dice di più su un metodo, come la tua sezione 7.

| motore / candidato | verdetto misurato | perché è finito così |
|---|---|---|
| Breakout d'apertura M5, sessione di Londra | **0 celle positive su 48** | nessun edge sulla griglia intera; da lì è nata la regola "meccanismo diverso, non parametri diversi" |
| Turtle-soup su falsa rottura, costruito da zero | **0 celle su 30 con PF ≥ 1** | motore senza edge, chiuso in un round |
| Candidato "ad alta frequenza" | **morto 12 su 12** al primo controllo | frequenza 0,15-0,52 trade/giorno/lato contro un pavimento dichiarato di 1,00. Costo del verdetto: una compilazione e 12 passate |
| EA "RSI + EMA" preso da fuori | **non promosso, poi confermato dall'ablazione** | il filtro RSI toglieva solo il **9-13%** degli incroci → era un incrocio EMA 5/20 travestito, famiglia già morta due volte in casa |
| Motore su Dow H4, timeframe alto | OHLC **PF 2,77** → tick reali **PF mediano 0,79** | illusione OHLC pura. Promozione **revocata** dopo la rivalidazione |
| EA sull'oro validato da terzi | **PF 1,54** su broker a spread stretto → **PF 1,01 e DD 28%** sul nostro | stesso codice, stessi anni, altro mondo. I costi non sono un dettaglio |
| Motore su cambi, versione USDJPY | su 13 anni: **1 cella positiva su 14** (PF 1,011) | il contratto su finestra corta diceva DD 3,97%; la finestra lunga ha detto "nessun edge". Sedia spenta |
| Breakout su cross JPY (pre-progetto) | paniere di 7 cross 2022-24: **PF 0,67-0,95 su tutte, DD 30-48%** | famiglia intera scartata prima di entrare nell'imbuto |
| Motore caotico con gate | gate **PF 1,789** vs nudo **1,150** | **non promosso lo stesso**: la tesi originale era invertita rispetto a quella pre-registrata, e il criterio scritto prima diceva di bocciare |
| Retest di sessione USA su M15 | cella top **PF 1,37-1,43, DD 3,7%** ma **n=115 < 150** | merito **sospeso**, non promosso. Tagliando calendarizzato. È il caso che è costato di più da rispettare |
| Filtro di rischio/rendimento minimo | bocciato su **3 simboli su 3** | tagliava i trade migliori: **+193 / +184 / +66** di aspettativa per trade persi. L'intuizione era plausibile, la misura no |

### E gli errori di processo (la parte che fa più male)

- **Una sedia ha girato nove giorni al triplo della taglia prevista dal
  contratto** (1,0% invece di 0,3%) senza che nessuno se ne accorgesse, perché
  guardavamo il P&L e non il rapporto fra i lotti dei conti gemelli. Scoperta
  confrontando sei coppie appaiate: il rapporto dei lotti era passato da ~6 a ~20,
  cioè esattamente il rapporto dei saldi. Rimessa a contratto, quella sedia
  passava da **+496 € a circa −383 €**: il "profitto" era un difetto di
  configurazione. Ora c'è un controllo automatico che confronta ogni trade col
  suo contratto.
- **Il default di rischio scritto nel sorgente era il doppio di quello del
  contratto.** Chiunque avesse riaperto l'EA "a default nudo" avrebbe lanciato al
  2% una sedia dichiarata all'1%. Corretto, con il costo dichiarato agli atti: i
  backtest storici fatti a default nudo non sono più confrontabili con quelli
  futuri, e non si riscrivono.
- **Un audit sul codice di tutta la flotta** (126 file) ha trovato 26 EA che
  selezionavano le posizioni in modo non sicuro su conto hedging — e lo stesso
  difetto governava anche il vincolo "un trade al giorno". Nella verifica storica
  un EA aveva aperto **il secondo lato vietato in 4 giornate su 16**, con **+25%
  di frequenza rispetto al contratto**: è un difetto di rischio, non di eleganza.

---

## 6. Il tema aperto: costi reali contro costi di convenzione

Qui credo che siamo sullo stesso muro, e per me è il punto più interessante.

**Lo spread.** Nei backtest usavamo una convenzione — 2,0 punti indice — mai
misurata. L'abbiamo misurata sui tick storici del broker: **252 milioni di tick**,
spread orario reale sui tre indici che tradiamo. Risultato: **in sessione le
mediane sono 1,6-2,0**, quindi la convenzione era giusta o prudente. **Fuori
sessione no**: DAX di notte **3,5-3,9** (più del doppio), Dow all'ora 23 con P95
**7,0** e un massimo di **101 punti indice**. Cioè il backtest era onesto nelle
ore in cui i motori lavorano e ottimista in quelle in cui alcuni *tengono* le
posizioni aperte. La conseguenza operativa è che il vincolo "il take lordo
mediano deve valere almeno 3× lo spread" si applica **ora per ora**, non in media.

**Lo slippage**, che nel nostro caso vale circa **11 volte lo spread** ed è il
numero grosso che non avevamo. L'abbiamo estratto dai report a tick reali
confrontando, sulla stessa riga, il **livello richiesto** e il **prezzo
eseguito**: 638 stop loss e 283 take profit.

Il controllo positivo è la parte che mi ha convinto che la misura fosse buona:
la stessa formula applicata ai take profit deve dare risultati opposti, se il
segno è giusto. E infatti — **l'81% degli stop viene riempito peggio del livello
richiesto, e lo 0% dei 283 take profit.** Se la formula fosse sbagliata i TP
uscirebbero a caso. L'asimmetria è reale: gli stop scivolano contro di noi, i
take non scivolano mai a favore.

Il risultato non è un numero, sono **due mondi**:

| | n | mediana | P95 | massimo |
|---|---:|---:|---:|---:|
| **in sessione (07-20 server)** | 484 | **0,40** | **3,25** | 25,80 |
| **fuori sessione (21-06)** | 67 | 0,40 | **92,68** | **294,40** |
| media su tutte le ore (inutile) | 551 | 0,40 | 4,05 | 294,40 |

**Il 12% degli stop porta il 58% del costo totale dello slippage.** Non è una
coda statistica: è un **orario**. Le scivolate peggiori cadono tutte su pochi
secondi esatti e ricorrenti — stesso secondo, anni diversi — cioè gap di
riapertura, non esecuzione lenta. E l'evento da 21,5 punti su cui avevamo
costruito una priorità di lavoro è in realtà il **percentile 98,6**: l'evento
raro, non il costo che paghiamo di solito. Non è inutile saperlo — l'evento raro
è quello che brucia una challenge — ma cambia quale numero si usa per tarare
cosa.

**Il limite, dichiarato senza sconti:** questo è slippage **del tester**, cioè il
gap fra un tick e il successivo, non latenza né coda d'esecuzione. È un
**pavimento**: sul reale può solo essere peggio.

E qui la scoperta che forse ti interessa di più. Abbiamo chiesto formalmente al
broker se il conto **demo** simuli lo slippage. Risposta scritta: **no, solo sul
reale.** Il che significa che tutto il nostro forward in demo, su questa
dimensione, è **ottimista per costruzione** — e non di poco, visto che sono
cinque mesi e centinaia di stop. È il tipo di cosa che è molto meglio scoprire
prima di comprare una challenge che dopo.

La risposta di metodo è stata: **misurare invece di assumere**. Stiamo portando
le due sedie più frequenti su un piccolo conto reale, a rischio di casa,
affiancate da uno strumento in **sola lettura** costruito apposta, che per ogni
trade registra il livello richiesto e il prezzo eseguito da **tre fonti
indipendenti** (commento del server, prezzo dell'ordine, e una nostra fotografia
periodica dello stop), con priorità dichiarata. Non è un esperimento per
guadagnare: è per avere finalmente il numero vero. E ha già la sua spia di
onestà scritta: se una delle fonti coincidesse sempre con l'eseguito, quella
fonte direbbe "slippage zero" su qualunque conto — e il referto lo dovrà
scrivere, invece di stampare uno zero.

---

## 7. Nota di metodo finale

La tua "un vantaggio misurato con lo strumento sbagliato non esiste" da noi ha
una gemella, nata sbagliando:

> **Una media che non descrive nessuno non è una misura.**

Sedici anni contigui che mescolano sei anni brutti e dieci buoni danno un profit
factor che non descrive nessun mercato. Uno slippage "medio" di 4 punti non
descrive né la sessione (3,3) né la notte (92,7). Un backtest OHLC non descrive
un motore che vive dentro le fiammate. In tutti e tre i casi il numero esiste,
è calcolato bene, ed è **inutile** — perché la finestra o lo strumento sono
sbagliati.

Il corollario con cui lavoriamo, e che è diventato la nostra disciplina
quotidiana: **ogni numero entra solo con la sua finestra, la sua regola di
selezione e il suo strumento di misura.** È noioso e rallenta parecchio. In
cambio ci ha risparmiato almeno tre EA che sembravano promossi e non lo erano, e
ci ha fatto scoprire — prima di pagare una challenge — che il forward su cui ci
stavamo basando aveva una dimensione intera non simulata.

Se ti va di lavorarci insieme, i due punti dove secondo me due teste valgono più
del doppio di una sono proprio gli ultimi: **la calibrazione dei costi reali**
(spread e slippage per ora, non in media, e demo contro reale) e **la disciplina
della prova di regime**. Servono broker diversi e dati diversi per capire cosa
è del metodo e cosa è del proprio broker — ed è esattamente il tipo di cosa che
da soli non si riesce a distinguere.
