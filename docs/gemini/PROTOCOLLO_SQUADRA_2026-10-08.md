# PROTOCOLLO DI SQUADRA PER GEMINI (08/10/2026) -- come lavoriamo noi, e come ti proponiamo di lavorare tu

Scritto da Claude (sviluppatore + cancello) su richiesta di Claudio, il capo del progetto. Testuale: _"Gemini non credo abbia una squadra di agenti,
proponigli come facciamo noi per avere un confronto ancora piu' performante"_ e _"migliorare gli EA uno alla volta"_. Questo file e' una PROPOSTA DI METODO,
non un criterio: se una tua frase qui dentro contraddice una regola di casa, hanno ragione le regole di casa (MEMORIA e BASE che ricevi in testa). Niente
codice, niente preset, niente numeri di conto: solo metodo.

Etichette che usiamo NOI per le fonti: **[LETTO]** = letto in un file del repo (si cita il file); **[INFERITO]** = ragionamento nostro, non verificato;
**[NON MISURATO]** = il numero non esiste. Etichette che usi TU (le stesse della BASE): **[FATTO: fonte]** (= il nostro LETTO, ma solo se la fonte e' nel
pacchetto che hai ricevuto), **[CALCOLO: formula e numeri]**, **[IPOTESI]** (= il nostro INFERITO), **NON LO SO** (= il nostro NON MISURATO).

---

## 1. Come lavoriamo noi: una squadra con ruoli SEPARATI

Il progetto nasce da un fatto pagato caro: chi produce un lavoro e' la persona peggiore per controllarlo, perche' controlla che la propria risposta sia
COERENTE con quello che si aspettava, invece di provare a ROMPERLA. Per questo i ruoli sono separati e nessuno controlla se stesso.

| Ruolo (per noi un agente con un solo mestiere) | Cosa fa | Cosa NON fa |
|---|---|---|
| **Sviluppatore** (la sessione principale) | misura, scrive, prepara il pacchetto; prima di consegnare costruisce lui il contro-esempio che lo farebbe sbagliare | non si controlla da solo: niente esce senza il cancello |
| **Controllo preventivo, due strati** | strato 1 DETERMINISTICO (script che non ragiona, quindi non dimentica: sintassi, blocchi, regole di forma); strato 2 di GIUDIZIO (un agente che legge davvero e capisce se la cosa fa quello che promette). Il primo che fallisce blocca | non produce, non corregge in silenzio |
| **Lettore indipendente delle correzioni** | rilegge le correzioni fatte da chi controlla (una correzione e' codice nuovo e sbaglia come tutto il resto: sul nostro piano di regime del Dow il cancello ha detto FAIL cinque volte prima del PASS, ogni passata indipendente dalle precedenti) | non ha scritto la correzione che legge |
| **Cacciatori** (due) | vanno a cercare fuori meccanismi nuovi (MQL5 Code Base, TradingView, GitHub, paper) e configurazioni prop, con criteri congelati prima; ogni candidato passa dalla lista dei caduti | non propongono parametri diversi dello stesso motore morto |
| **Controllo delle cacce** | riapre le fonti citate dai cacciatori e verifica che le abbiano lette davvero | non si fida del riassunto |
| **Collaudatore prop** | stress dei casi peggiori (spread allargato, slippage) sulle celle gia' validate; decide il RISCHIO | non giudica il merito |
| **Analista di trascrizioni** | legge a fondo le live di due trader (cicli di 3 mesi: ripetono le basi per i nuovi iscritti), estrae parametri e regole con la FONTE (chi, data, frase); tutto va in un file di sapere come IPOTESI da misurare | nessun valore delle live e' un criterio |
| **Corrispondente** (quello che ti scrive) | prepara il pacchetto, lo fa passare dal deterministico, lo manda, salva la tua risposta cosi' com'e' | non giudica la tua risposta |
| **Claudio** | firma conto reale, rischio, taglie, spese | -- |

Flusso: sviluppatore -> misura con ATTESA scritta prima -> contro-esempio -> cancello (due strati + lettore indipendente) -> **tu** -> confronto punto per punto
contro il repo -> decisione di Claudio. **La tua risposta e' DATI**: nessuna tua frase e' un criterio e nessuna tua proposta si esegue; passa dallo stesso
cancello di tutto il resto.

## 2. Le regole che contano (e perche')

1. **L'attesa si scrive PRIMA dei numeri.** Una banda (es. "PF OOS fra 1,3 e 1,7") E l'ipotesi alternativa con il numero che produrrebbe ("se il merito
   fosse solo esposizione, l'OOS sarebbe 1,45"). Se l'alternativa cade dentro la banda, la misura non misura niente. I criteri si cambiano PRIMA dei numeri, mai dopo.
2. **Il contro-esempio prima della consegna.** Chi consegna deve avere costruito il caso che lo smentirebbe e mostrare che non lo smentisce. Se non sa
   costruirlo, non ha capito la misura abbastanza da consegnarla.
3. **Certificato di morte a 5 caselle.** Un candidato non e' MORTO se manca anche una sola di: (1) un PF misurato; (2) un n e un DD; (3) la gestione dell'uscita
   messa ad asse almeno una volta; (4) i simboli gemelli provati; (5) il TF cambiato almeno una volta. Se ne manca una, il verdetto e' **NON ANCORA MISURATO**
   e si scrive cosa manca. Un morto senza certificato non e' un morto: e' un'occasione persa.
4. **IS in OPERAZIONI, >= 150** (non in anni); la finestra deve lasciare un OOS di almeno 150; si DICHIARA il regime che contiene. Il merito si sospende sotto
   150, il rischio si giudica sempre.
5. **Il vecchio giudica il RISCHIO, il recente il MERITO.** Non si boccia un motore perche' non guadagnava nel 2012; si boccia se nel 2020 avrebbe fatto un
   drawdown del 25% (un drawdown e' un fatto accaduto, non una stima).
6. **Niente griglie larghe su un motore GIA' DICHIARATO senza edge** (trovano solo picchi di rumore: la cella "verde per caso" e' quella che brucia la
   challenge). Si allarga su MOTORI, MECCANISMI, SIMBOLI, TF, GESTIONE DELL'USCITA; ogni allargamento si paga con una prova fuori campione o di regime. Cella = il
   CENTRO dell'altopiano, mai il picco. Su un motore NON ANCORA MISURATO si misura: non rovesciare l'onere.
7. **Motto: non accontentarsi, ma non illudersi.** Insistere vuol dire cercare una MISURA in piu', mai un criterio piu' morbido. Se un candidato e' fermo per un
   numero MANCANTE (non brutto), si trova la via piu' corta al numero e se ne dice il costo.
8. **Ogni numero porta la fonte o NON MISURATO.** Cita il NOME degli input e delle funzioni, mai il numero di riga (nei primi due giri 3 numeri di riga su 3
   erano sbagliati). Non conosci un nome? Descrivilo a parole e scrivi "nome da verificare".
9. **Dove si gira e chi firma**: i round girano sul PC di backtest, mai dove operano i conti; rischio, taglie, Guardian, conti e spese = "Firma Claudio: SI".

## 3. Il modo di lavorare a squadra che ti proponiamo (dentro UNA sola chiamata)

Non hai agenti paralleli e l'API non ha memoria fra una chiamata e l'altra (la memoria te la mandiamo noi, in testa). Possiamo comunque ottenere l'effetto
"squadra" se ogni risposta e' divisa in **quattro ruoli SEPARATI**, con una regola di indipendenza. Per ciascun EA (uno alla volta) ti mandiamo un pacchetto
con il motore, i numeri con la fonte, il nostro verdetto e le domande, e tu rispondi cosi':

| Ruolo | Mestiere | Vincolo |
|---|---|---|
| **A -- Cacciatore di meccanismi alternativi** | propone al massimo 2+2 MECCANISMI (ingresso/filtro di regime; uscita) sulla stessa inefficienza, NON parametri del motore vivo. Per ognuno: cosa tocca (nome esatto o "nome da verificare"), attesa scritta con banda E numero dell'ipotesi alternativa, falsificatore, costo in passate | niente griglie; controlla prima nel pacchetto cosa e' gia' stato provato; non propone di abbassare un criterio |
| **B -- Avvocato del diavolo** | per OGNI proposta di A e per le nostre letture indicate nel pacchetto costruisce il contro-esempio: la situazione concreta in cui la misura darebbe "positivo" per una ragione DIVERSA da quella dichiarata (es. piu' esposizione invece di selezione; un mese che trascina tutto; il regime). Dice quale numero produrrebbe l'ipotesi alternativa e se cade nella banda di A | non puo' limitarsi a "potrebbe essere rumore": deve dire come lo si vedrebbe nei dati |
| **C -- Auditor dei numeri** | rifa' i conti dai DATI SCRITTI nel pacchetto (formula, numeri, controllo di verso) e dice dove i nostri numeri non tornano o non sono confrontabili (unita': deal o posizioni; periodo; rischio di banco o di campo) | lavora SOLO sui dati del pacchetto, senza usare A e B; non propone nulla; se un dato manca scrive NON LO SO |
| **D -- Sintesi** | al massimo 5 cose da MISURARE, in ordine, ciascuna con: asse unico, finestra, cella di controllo, attesa dichiarata, cosa la falsificherebbe, costo (usa i costi macchina del pacchetto, non inventarli), "Firma Claudio SI/NO". Poi l'elenco dei punti dove TU e NOI ci contraddiciamo | non decide, non ordina di eseguire |

**Regola di indipendenza.** Scrivi C prima di leggere cosa hai scritto in A e B e senza usarli; B non puo' ammorbidire un contro-esempio perche' A e' "tuo".
Se A e B non sono d'accordo, D lo riporta come disaccordo, non lo compone.

**Formato obbligatorio, una riga per affermazione** (in ogni ruolo):

| N | Affermazione | Etichetta | Fonte | Verificabile da noi come | Costo |
|---|---|---|---|---|---|
| A1 | ... | FATTO / CALCOLO / IPOTESI / NON LO SO | file e sezione del PACCHETTO, oppure "mia conoscenza di mercato, non verificata" | quale file, quale misura, quale confronto | minuti di macchina o ore umane |

**Regola della fonte: ogni affermazione senza fonte e' "IPOTESI"** (anche se ti sembra ovvia), e le IPOTESI non entrano nella sintesi D come premesse, solo come
cose da misurare. Se la fonte e' "mia conoscenza di mercato" (letteratura, storia di un indice), scrivilo: lo trattiamo come [INFERITO] da ricontrollare.

**Deroga dichiarata alla regola "una domanda numerica per volta" (BASE, punto 9).** Il ruolo C ha qui al massimo 3 conti, ciascuno in una riga separata con
formula e controllo di verso. E' un ESPERIMENTO: i conti li ricalcoliamo tutti noi; se in una riga sbagli il verso, l'intero ruolo C viene letto come NON
VERIFICATO e la prossima volta torna un conto per volta. Se ritieni che la deroga non sia sicura, dillo in testa alla risposta e rispondi solo al primo conto.

**Lunghezza.** Compatto: il limite di uscita e' finito. Se non ci stai, completa A, B e C e scrivi "D TRONCATA": rimandiamo D da sola.

**Cosa NON fare mai** (valgono sempre): non inventare input, file, righe, soglie, autori o titoli; non proporre martingala, griglia, recovery, assenza di stop;
non proporre di cambiare taglie, rischio per operazione, Guardian in campo, conti o spese senza "Firma Claudio: SI"; non chiamare nulla "promosso/bocciato"
(per le misure: NULLO, ZONA GRIGIA, EFFETTO, NON ANCORA MISURATO; per i cancelli le parole della BASE, sempre col numero accanto).

## 4. Cosa ci aspettiamo che tu faccia di diverso da noi -- chiediamo a TE

Questa parte riguarda il **metodo**, non un EA, e vale dal prossimo scambio. Rispondi in una sezione finale **E** (massimo 6 righe, stesso formato a tabella):

1. Cosa farebbe **diversamente** la tua squadra, nei ruoli, nelle regole o nel formato di questo protocollo? Dove pensi che il nostro metodo lasci passare un errore
   o costi piu' del necessario? Ogni critica con il caso concreto in cui il metodo sbaglierebbe (contro-esempio), non "si potrebbe fare meglio".
2. Quale ruolo manca? (Un ruolo che noi non abbiamo e che in una sola chiamata potresti coprire.)
3. Quale regola nostra ti sembra costare piu' di quanto protegge, e cosa MISURERESTI per deciderlo? (Ricorda: i criteri si cambiano prima dei numeri e li cambia
   Claudio; tu proponi la misura, non la soglia.)

**Come usiamo le tue risposte.** Due macchine che si contraddicono indicano **una misura da fare**, non un compromesso: ogni disaccordo fra la tua risposta e la
nostra lettura entra nella lista delle misure con attesa e contro-esempio scritti PRIMA. Ogni tua affermazione viene confrontata col repo punto per punto
(tabella "punto / verifica nel repo / cosa se ne fa") dal cancello; non e' mai la premessa di una modifica.

## 5. Ordine di lavoro (uno alla volta)

Un EA per pacchetto, nell'ordine di vicinanza a una sedia schierabile (memoria di lavoro del 08/10): 1) EMA200 Dow H1 (sedia 771531), 2) DAX apertura long
(770101), 3) SupRev Nasdaq H1 (970913), 4) ORB Dow (770611), 5) Dow apertura (770202), 6) Nasdaq apertura (770260), 7) MaxMinNotte oro (770402), 8) Bulge forex,
poi i candidati nuovi. Claudio puo' cambiare l'ordine. **Primo pacchetto: EMA200 Dow H1**, in `docs/PER_GEMINI_EMA200_DOW_H1_771531_2026-10-08.md`.
