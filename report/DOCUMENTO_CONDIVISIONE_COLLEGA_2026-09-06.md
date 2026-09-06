# Dove siamo arrivati — flotta di EA per una prop challenge

*Claudio — 6 settembre 2026*

Ho letto il tuo documento sul PS5 ORB Bot e mi è venuta voglia di scriverti il
nostro, nello stesso spirito: metodo e numeri veri, niente promesse. Te lo
faccio corto.

**Il metodo, in una frase: i criteri si congelano PRIMA di vedere i numeri.**
Ogni round parte con un file di criteri scritto e datato — cosa promuove, cosa
boccia, con quali soglie — poi si gira, e non si toccano più. Quando ci ho
provato si è visto perché: avevo fatto dei confronti prendendo la cella
*migliore* della griglia invece del *centro dell'altopiano*, e rifacendoli con
la regola giusta il risultato si è ribaltato. Da allora la regola di selezione
si dichiara insieme al numero, altrimenti il numero non vuol dire niente.

Anche noi abbiamo la tua gerarchia di fiducia, con altri nomi: backtest OHLC <
tick reali < walk-forward IS/OOS < prova di regime (toro, orso, laterale,
crollo misurati separatamente) < forward vero. L'OHLC da solo non promuove
niente, e sotto c'è il caso che lo dimostra.

**L'architettura: non un motore, una flotta.** Una quarantina di "sedie"
(EA/simbolo/orario) scelte per essere il più scorrelate possibile: chi lavora
all'apertura di Francoforte, chi su New York, chi di notte sull'oro, chi sui
cambi. Ogni sedia ha un **contratto scritto** — il drawdown promesso dal
backtest che l'ha promossa e la frequenza promessa. Se in forward sfora il DD
promesso scatta revisione immediata, non "vediamo come va". Sopra c'è un modulo
di rischio unico sul conto intero (pausa al 4% giornaliero, emergenza a 4,9% e
9,9% — mai sul muro esatto) e soprattutto un **cap sul rischio aperto
simultaneo al 3,25%** = 5 stop vivi da 0,65%. Quel cap non è un'opinione:
misurando il forward vero abbiamo trovato una mattina con **9 posizioni di 8
sedie aperte insieme = 5,85% di rischio aperto**, cioè già oltre il muro
giornaliero del 5%. Il rischio per trade è 0,65%: Monte Carlo sulle serie reali
dà p99 **8,51%** su drawdown statico (passa il muro 10) ma **12,05%** su
drawdown trailing (non passa). La taglia dipende dal tipo di muro.

**Le tre regole intoccabili.** (1) *L'unità di misura è l'operazione, non
l'anno*: l'in-sample si dimensiona su ≥150 operazioni. Sotto quella soglia la
superficie dei parametri è frastagliata e la selezione insegue rumore — stessa
griglia con n=75-159 illeggibile, con n=190-256 altopiano netto. Corollario: non
si boccia un motore perché non guadagnava nel 2012 — su un cambio l'IS 2010-2016
dava **0 celle positive su 28** e l'OOS ne faceva **25 su 28**, perché quella
finestra conteneva un'epoca morta. (2) *Il vecchio giudica il rischio, il
recente giudica il merito*: un drawdown del 2020 è un fatto accaduto, un
profitto del 2012 è una stima. (3) *Sugli indici si misurano sempre entrambi i
lati*, anche quello già vivo in forward.

**Cosa abbiamo scartato, coi numeri.** Un breakout d'apertura M5 su Londra:
**0 celle positive su 48**. Un turtle-soup costruito da zero: **0 celle su 30
con PF ≥ 1**. Un candidato "ad alta frequenza": morto **12 su 12** al primo
controllo, frequenza 0,15-0,52 trade/giorno contro un pavimento dichiarato di
1,00. Un "RSI + EMA" preso da fuori: l'ablazione ha mostrato che il filtro RSI
toglieva solo il **9-13%** degli incroci — era un incrocio EMA 5/20 travestito.

I due più istruttivi. Un motore su Dow H4 che in OHLC faceva **PF 2,77**; a tick
reali **PF mediano 0,79**: illusione pura, promozione revocata. E un EA sull'oro
validato da terzi con **PF 1,54** su un broker a spread stretto: lo stesso test
sul nostro broker, **PF 1,01 e DD 28%**. Stesso codice, stessi anni, altro
mondo. Infine uno che avremmo voluto promuovere e non abbiamo promosso: PF
1,37-1,43 con DD 3,7%, ma **n=115 < 150** → merito sospeso. È costato, ma la
regola era scritta prima.

E la parte scomoda, gli errori nostri: per **nove giorni** una sedia ha girato
al triplo della taglia prevista dal contratto e nessuno se n'era accorto perché
guardavamo il P&L, non il rapporto fra i lotti. Rimessa a contratto quella sedia
passava da **+496 € a circa −383 €**: il "profitto" era un difetto di
configurazione.

**Il tema aperto, e credo sia lo stesso tuo: costi veri contro costi di
convenzione.** Nei backtest usavamo uno spread di convenzione di 2,0 punti
indice, mai misurato. L'abbiamo misurato su **252 milioni di tick**: in sessione
mediane **1,6-2,0** (la convenzione era onesta), fuori sessione no — DAX di
notte **3,5-3,9**, Dow all'ora 23 con P95 **7,0** e massimo **101**.

Poi lo slippage, che vale ~11 volte lo spread. Da report a tick reali abbiamo
confrontato livello richiesto e prezzo eseguito su 638 stop e 283 take profit.
Il controllo positivo è la parte che mi ha convinto: **l'81% degli stop viene
riempito peggio del livello, e lo 0% dei 283 take profit** — se la formula fosse
sbagliata i TP uscirebbero a caso. E il risultato non è un numero, sono due
mondi: **in sessione mediana 0,4 / P95 3,3 / max 25,8** su 484 stop; **fuori
sessione P95 92,7 e max 294,4** su 67 stop. Il **12% degli stop porta il 58% del
costo**. Non è una coda: è un orario. L'evento da 21,5 punti su cui avevamo
costruito una priorità è il **percentile 98,6**.

Limite dichiarato: è slippage **del tester**, cioè il gap fra tick, non latenza
e coda d'esecuzione — quindi è un pavimento, sul reale può solo essere peggio. E
qui la cosa che forse ti interessa di più: abbiamo chiesto al broker se la demo
simuli lo slippage, e la risposta scritta è **no, solo sul conto reale**. Cioè
tutto il nostro forward in demo, su questa dimensione, è **ottimista per
costruzione**. Stiamo quindi mettendo le due sedie più frequenti su un piccolo
conto reale con un logger in sola lettura che registra livello richiesto e
prezzo eseguito da tre fonti indipendenti. Non per guadagnarci: per avere il
numero.

**La nota finale.** La tua frase "un vantaggio misurato con lo strumento
sbagliato non esiste" da noi ha una gemella, nata sbagliando: **una media che
non descrive nessuno non è una misura**. Sedici anni contigui che mescolano sei
anni brutti e dieci buoni danno un PF che non descrive nessun mercato; uno
slippage "medio" di 4 punti non descrive né la sessione (3,3) né la notte
(92,7). Il corollario operativo: **ogni numero entra solo con la sua finestra,
la sua regola di selezione e il suo strumento di misura**. È noioso e rallenta
parecchio; in cambio ci ha risparmiato almeno tre EA che sembravano promossi e
non lo erano.

Se ti va, le due cose su cui secondo me varrebbe la pena unire le forze sono
proprio le ultime: **la calibrazione dei costi reali** (spread e slippage per
ora, non medi) e **la disciplina della prova di regime**. Si fanno meglio in
due, perché servono broker e dati diversi per capire cosa è del metodo e cosa è
del proprio broker.
