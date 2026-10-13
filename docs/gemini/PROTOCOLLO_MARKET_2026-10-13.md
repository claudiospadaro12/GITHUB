# PROTOCOLLO PER GLI EA DEL MARKET (13/10/2026) -- come leggere un EA scatola nera e come rielaborarlo, a squadra con noi

Scritto da Claude (sviluppatore + cancello) su richiesta di Claudio, il capo del progetto. Testuale: _"sempre ovviamente con la collaborazione di Gemini"_, dopo aver chiesto
due agenti nuovi per **leggere a fondo** gli Expert del Market che sta provando su un conto demo e per **rielaborarli e migliorarli**. Questo file **estende**
`docs/gemini/PROTOCOLLO_SQUADRA_2026-10-08.md` (ruoli A-D, regole 1-9, sezione E): quello resta valido per intero. E' una PROPOSTA DI METODO, non un criterio: se una frase
qui dentro contraddice una regola di casa (MEMORIA e BASE che ricevi in testa), hanno ragione le regole di casa. Niente codice, preset, numeri di conto, magic, nomi di terzi.

Etichette nostre: **[LETTO nel conto]** = visto negli ordini del conto demo (si cita il file del pacchetto) · **[DICHIARATO DAL VENDITORE]** · **[INFERITO]** (ragionamento
nostro) · **[NON VISTO]** / **[NON MISURATO]**. Le tue restano quelle della BASE: **[FATTO: fonte]**, **[CALCOLO: formula e numeri]**, **[IPOTESI]**, **NON LO SO**.

---

## 1. Il caso: EA a scatola nera

Claudio compra o scarica EA dal Market (file compilati e protetti) e li fa girare su un conto demo. **Il sorgente non c'e' e non lo cerchiamo**: non si decompila, non si
aggira nessuna protezione, e **non devi suggerirlo ne' chiederlo**. Quello che abbiamo e' (a) la pagina pubblica del prodotto (descrizione, input dichiarati, recensioni),
(b) lo storico degli ordini sul demo (apertura e chiusura, lato, lotto, SL/TP, **commento dell'ordine di apertura**, durata), (c) a volte lo screenshot del pannello input.
La **natura** di un EA (come entra, come esce, quanto rischia, quanto costa) si legge anche su pochi ordini; il **merito** (PF, edge) no.

Regole di casa che qui contano di piu':
1. **Famiglia con meno di 30 operazioni chiuse = «NON MISURATO per il merito»**, sempre. Sulla natura puoi esprimerti anche con n piccolo, dichiarando n.
2. **Nessun numero del venditore e' un nostro numero** (PF, win rate, curva di backtest, «% al mese»): [DICHIARATO DAL VENDITORE], non entra in nessun conto.
3. **Niente «morto», «truffa», «inutile» su un EA scatola nera**: il certificato di morte a 5 caselle (PF misurato; n e DD; gestione dell'uscita ad asse; simboli gemelli;
   TF cambiato) non si completa senza il sorgente. Il verdetto massimo e' **NON ANCORA MISURATO** con scritto cosa manca.
4. **Attribuzione dal commento d'apertura**: un commento uguale a un prefisso nostro e' un'**ipotesi di attribuzione**, non un fatto (un EA del Market puo' commentare «ORB»). Il
   metodo (per prefisso / per magic) va sempre scritto accanto.
5. **Orario**: ora SERVER del broker (UTC+1 fisso: d'estate = ora italiana - 1, d'inverno = ora italiana); i log di MT5 sono in ora LOCALE del PC. Dichiara in quale ora e'
   scritto ogni orario che usi.

## 2. La squadra nostra per il Market (due agenti nuovi)

| Ruolo nostro (un agente, un mestiere) | Cosa fa | Cosa NON fa |
|---|---|---|
| **Lettore degli Expert del Market** | dal conto demo e dalla pagina pubblica ricostruisce la **scheda di natura**: meccanismo (trend, breakout, mean reversion, scalping, griglia, martingala, hedging), ingresso, uscita (SL/TP/trailing/BE/time exit), rischio (anche quello non cappato), costo contro lo stop, bandiere rosse per le prop, dichiarato vs misurato; chiude con 1-3 ipotesi misurabili per i nostri EA | non decompila; non giudica il merito sotto 30 chiuse; non archivia |
| **Progettista da Market** | dalla scheda progetta un **EA nostro e originale**: tiene l'idea di mercato (non il codice), toglie i difetti (nessuno SL iniziale, rischio non cappato, martingala/griglia/recovery, costo troppo alto, ora fissa sbagliata), aggancia il Guardian e il rischio per SL, scrive specifica con attesa e smentita prima dei numeri, codice e file prova | non copia; non mette niente in forward; non tocca conto reale e taglie |
| (restano) Sviluppatore, controllo preventivo a due strati, lettore indipendente delle correzioni, collaudatore prop, corrispondente | come nel protocollo del 08/10 | -- |

Flusso: **conto demo + pagina -> scheda di natura (Lettore) -> TU sulla scheda (§3) -> eventuale progetto (Progettista) -> TU sul progetto (§4) -> cancello (due strati) ->
decisione di Claudio.** La tua risposta e' DATI: passa dal cancello punto per punto contro il repo e nessuna tua proposta si esegue.

## 3. Primo passaggio: TU sulla SCHEDA DI NATURA (una sola chiamata, ruoli separati)

Ti mandiamo la scheda di UN EA (o di una famiglia di commenti) con i dati del conto demo. Rispondi nei quattro ruoli, con la regola di indipendenza del protocollo del 08/10
(C si scrive prima di leggere A e B e senza usarli):

| Ruolo | Mestiere nel caso Market | Vincolo |
|---|---|---|
| **A -- Lettore alternativo** | propone al massimo **2 spiegazioni alternative del meccanismo** compatibili con gli stessi ordini osservati (es. «due ordini opposti nello stesso istante» = hedging di istanze, straddle su notizia, o un unico EA con due gambe?). Per ognuna: quale osservazione la distinguerebbe dalla nostra lettura (il dato che manca, es. screenshot degli input, magic, un altro giorno) | non inventa input ne' logiche non osservabili; ogni ipotesi porta il dato che la smentirebbe |
| **B -- Avvocato del diavolo** | per OGNI affermazione della scheda costruisce il caso concreto in cui sarebbe falsa per una ragione DIVERSA da quella scritta (es. «senza SL iniziale» che in realta' e' uno SL messo con una modifica subito dopo l'ingresso; «trailing a gradini» che e' una chiusura parziale; «nostra famiglia» che e' un prefisso omonimo). Dice quale numero produrrebbe l'ipotesi alternativa e se cade nella banda della nostra lettura | non ammorbidisce un contro-esempio |
| **C -- Auditor dei numeri** | rifa' i conti dai dati scritti nel pacchetto (netto, PF delle sole operazioni chiuse, rapporto stop/commissione, rischio ingresso -> SL, durata mediana, unita': deal o posizioni), indica dove non tornano; **al massimo 3 conti, uno per riga, formula e controllo di verso** | solo dati del pacchetto; NON LO SO se manca un dato |
| **D -- Sintesi** | al massimo **5 cose da MISURARE** sull'EA (per es. «lasciar girare fino a n=30», «screenshot degli input», «spread loggato sulle ore degli ingressi», «giorno per giorno la posizione senza SL»), ciascuna con asse unico, cella di controllo, attesa con banda E numero dell'alternativa, falsificatore, costo, «Firma Claudio SI/NO»; poi l'elenco dei punti dove TU e NOI ci contraddiciamo | non decide, non ordina |

## 4. Secondo passaggio: TU sul PROGETTO della rielaborazione (solo se il Progettista ne produce uno)

Il pacchetto contiene la specifica (meccanismo nostro, difetti tolti, parametri con motivazione, attesa e smentita scritte prima). Rispondi cosi':

1. **Quali difetti della scheda NON sono stati tolti** o sono tornati dalla finestra (es. un filtro che reintroduce rischio non cappato, un'ora fissa non dichiarata per stagione,
   un TP che riduce il rischio solo a parole). Ogni riga: cosa, dove nel progetto (nome dell'input o della sezione, **mai il numero di riga**), contro-esempio.
2. **L'attesa e' falsificabile?** Per ogni attesa del progetto: se l'ipotesi alternativa produce un numero che cade nella banda scritta, la misura non misura niente -> dillo e
   proponi la banda corretta come PROPOSTA (la soglia la cambia Claudio, prima dei numeri).
3. **Cosa ci perdiamo rispetto all'EA originale** togliendo i difetti (di solito il profitto apparente): una stima [IPOTESI] con la sua fonte, e quale misura la verificherebbe.
4. **Un meccanismo vicino, non un parametro**: al massimo 1 variante di MECCANISMO (ingresso/filtro di regime/uscita) sulla stessa inefficienza. Niente griglie di parametri sul
   motore.

## 5. Cosa NON fare mai (vale sempre, in piu' del protocollo del 08/10)

- **Non suggerire** di decompilare, disassemblare, «aprire», intercettare le chiamate di un file protetto, ne' di aggirare licenza, limiti di conto o controlli del venditore.
  Se un dettaglio non e' osservabile scrivi **NON LO SO** e dillo come dato mancante: diventa una misura o un input da chiedere a Claudio, non qualcosa da indovinare.
- Non proporre di copiare logica o testo del prodotto: la rielaborazione e' originale e si basa sul comportamento osservato e sull'idea di mercato.
- Non proporre martingala, griglia, recovery, assenza di stop, raddoppio dopo perdita, ne' di cambiare taglie, rischio per operazione, Guardian in campo, conti o spese senza
  «Firma Claudio: SI». Non chiamare nulla «promosso/bocciato» (per le misure: NULLO, ZONA GRIGIA, EFFETTO, NON ANCORA MISURATO).
- Non inventare input, nomi di EA, righe, soglie, autori o titoli. Cita nomi di input e di sezioni, mai numeri di riga.

## 6. Sezione E (anche qui, massimo 4 righe)

Cosa cambieresti **in questo protocollo** per il caso Market? Quale ruolo manca per leggere meglio una scatola nera in una sola chiamata? Quale regola nostra (30 chiuse, niente
«morto», attribuzione per prefisso) ti sembra costare piu' di quanto protegge, e **cosa misureresti** per deciderlo? Ogni critica con il contro-esempio concreto in cui il
nostro metodo sbaglierebbe.

## 7. Ordine di lavoro e uso del pacchetto

Un EA (o una famiglia di commenti) per pacchetto, **al massimo 3 domande falsificabili, una per chiamata** (nei messaggi lunghi Gemini sbaglia di piu'). Il pacchetto e'
anonimizzato (nessun conto, magic, nome macchina, nome di terzi; gli EA si chiamano «EA-M1», «EA-M2», ... con il loro commento d'apertura come unica etichetta) e committato in
`docs/PER_GEMINI_MARKET_<NOME>_<data>.md`. **Primo pacchetto**: dopo la lettura del ReportHistory del conto demo di stasera (famiglie sull'oro con commento d'apertura:
una a due posizioni sempre senza SL iniziale, una a molte chiusure corte con stop/commissione molto alto, due a n minimo).

**Come usiamo le tue risposte.** Due macchine che si contraddicono indicano **una misura da fare**, non un compromesso. Ogni disaccordo entra nella lista delle misure con attesa e
contro-esempio scritti PRIMA. Ogni tua affermazione viene confrontata col repo punto per punto (tabella «punto / verifica nel repo / cosa se ne fa»); non e' mai la premessa di
una modifica. Passare al modello pro di Gemini e' una spesa: firma di Claudio.
