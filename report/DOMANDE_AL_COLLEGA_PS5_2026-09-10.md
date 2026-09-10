# ✉️ DOMANDE SUL PS5 ORB BOT — da mandare al collega

> 📌 **Come usarlo**: e' gia' scritto per essere **inoltrato cosi' com'e'**.
> Nessun numero di conto, nessun dato nostro riservato: si puo' girare tutto.
> Se vuoi accorciarlo, manda solo la **PARTE 1** — sono le tre domande che
> cambiano davvero cosa facciamo noi.

---

## Ciao Marco,

grazie di aver condiviso il documento master del PS5. L'abbiamo letto tutto, e
prima delle domande ti diciamo cosa ci ha colpito, perche' non e' una cortesia:

- 📊 **La gerarchia di fiducia scritta sopra ogni numero** (forward live > tick
  100% > coarse 1 minuto) con il costo dell'errore **misurato** invece che
  stimato: *US100 in coarse PF 2,18, lo stesso asset al tick reale **1,15***.
  Non l'avevamo mai vista dichiarata cosi' bene, e ce la portiamo in casa.
- 🪦 **La tabella degli scartati con i numeri accanto.** Da noi vale una regola
  identica: *"un candidato archiviato senza un numero non e' un candidato morto,
  e' un'occasione persa che nessuno ritrovera' piu'"*. La tua tabella e' proprio
  quello, fatto bene.
- 🩸 **L'autopsia della settimana in perdita, in euro, con la colpa attribuita
  alla configurazione e non alla strategia.** In particolare questa riga:
  *"la configurazione in produzione deve corrispondere all'ultima versione
  validata, e va verificata **sul terminale — non sui file `.set`**"*.
  👉 **Lo stesso identico difetto lo abbiamo trovato in casa nostra oggi**: un
  preset corretto nel repo e un grafico vivo con un valore diverso sopra. Averlo
  letto da te con il conto in mano ci ha fatto controllare subito.

Le domande sotto nascono dal volerlo capire bene, non dal metterlo in dubbio.

---

# 🔴 PARTE 1 — LE TRE CHE CONTANO DAVVERO

### 1. Il pavimento di stop-loss: **0 o fisso?**
Nel documento (sez. 5, *"I due valori che non si toccano"*) c'e' scritto
**`InpMinSLPts = 0`**, e che portarlo a 20 punti *"fa crollare il DAX da PF 2,40
a 1,26 e US2000 da 2,97 a 1,05-1,40"*, perche' *"lo stop stretto e' l'unita' di
misura di tutta la geometria"*.
A noi e' arrivato pero' un riassunto che dice **"range su ATR con un pavimento di
stop-loss fisso"**.
👉 **E' cambiato qualcosa dopo la v2.60 del 10/08?** Se hai trovato un pavimento
che NON distrugge l'edge, e' la cosa piu' interessante di tutte — e ci
piacerebbe capire **come l'hai riscalato** (hai toccato anche buffer/target/size
per tenere le proporzioni, o solo il pavimento?).

### 2. **UK100 e US2000**: sono rientrati in portafoglio dopo il 10/08?
Nel documento il portafoglio validato ha **quattro** asset e **UK100 non c'e'**
(*"~20 trade l'anno, spread al 19% del range, assente da entrambi i portafogli
validati"*), mentre **US2000 vive solo su Pepperstone** perche' su FTMO
*"lo spread e' pari al 90% dello stop"*. E nell'autopsia UK100 pesa **-2.842 EUR**
e US2000 su FTMO **-717 EUR**.
👉 A noi e' arrivata una lista di **cinque** asset che li comprende tutti e due:
**e' un aggiornamento (li hai recuperati con qualche modifica) o un refuso?**

### 3. 🥇 **Hai finito le 2-4 settimane di raccolta slippage?**
E' la domanda a cui teniamo di piu'. Nel documento l'haircut e' dichiarato
**non ancora tarato**, con due soli campioni: *"US30 **4,67 punti, pari al 27%
dello stop**; NAS 2,38 punti, 13%"*. E fra il +130% e il +93% annuo c'e' solo
quel numero.
👉 Se la raccolta e' finita, per noi **quello e' il dato piu' prezioso del
documento intero**: slippage misurato su una straddle a stop stretto, su conto
vero. Ci interessano soprattutto:
- **mediana e coda alta** (P80/P90), non la media;
- 🔍 **la differenza fra ingresso e uscita**: da noi il primo dato misurato su
  conto reale dice **slippage all'ingresso, ma ZERO sull'uscita in stop** (un
  solo campione, quindi un indizio, non una statistica) — e se anche da te
  l'uscita costa meno dell'ingresso, cambia dove conviene mettere la protezione;
- se hai visto lo slippage **peggiorare nei primi 60 secondi** dopo l'apertura.

---

# 🟠 PARTE 2 — LE UTILI, se hai tempo

### 4. La soglia **spread ÷ SL al 20%**: da dove viene il 20?
Scrivi *"sotto il 20% vive, oltre il 50% muore"*, misurato **all'orario del
trade**. E' una soglia **osservata sui tuoi asset** (cioe' sotto il 20% i tuoi
sopravvivono e sopra il 50% no) oppure **derivata da un conto** (per esempio dal
rapporto rischio/rendimento e dal win rate)?
👉 Te lo chiediamo perche' **noi usiamo una soglia molto piu' stretta** — nel tuo
formato sarebbe circa **il 2,5%** — e le due non possono essere tutte e due
giuste. La nostra e' tarata su edge sottili; la tua su un edge grasso.
**Sapere come hai ricavato il 20% ci dice quale delle due stiamo sbagliando.**

### 5. Le **frequenze di inversione** (35% UK100, **57% DAX**, 68% Russell)
Sono il numero che ci ha impressionato di piu', perche' spiega in una riga
perche' cancellare la gamba opposta e' *"una protezione, non una preferenza"*.
👉 Come sono definite esattamente? *"Il prezzo tocca il livello opposto entro la
stessa giornata"*, oppure *"entro N minuti"*, oppure *"dopo che la prima gamba e'
stata stoppata"*? La definizione cambia molto il numero, e a noi serve per
misurarla sui nostri dati con la tua stessa regola.

### 6. **US30 al tick nella finestra vera**
Lo elenchi fra i loop aperti: *"US30 e' il motore principale del portafoglio ed
e' ancora l'unico grande asset senza verdetto tick sulla sua vera finestra
(15:25-15:40)"*.
👉 L'hai poi chiuso? Se si', **il PF 3,01 quanto e' sceso?** (Chiediamo perche'
sugli altri il passaggio coarse→tick e' costato circa la meta'.)

### 7. L'**armo anomalo delle 11:50 del 4 agosto** sul DAX
Anche questo e' fra i loop aperti, con la candela segnale alle 08:55.
👉 L'hai spiegato? Da noi un armo fuori orario e' quasi sempre **un problema di
fuso** (l'ora dei log del terminale e' l'ora locale del PC, l'ora del grafico e'
quella del server: **sono diverse**, e ci siamo gia' cascati). Se e' quello, e'
una trappola che vale la pena scriversi.

### 8. Il **portafoglio decorrelato** oltre il PS5
Ultimo loop aperto della tua lista. 👉 Ci stai lavorando? E' il punto su cui
siamo piu' d'accordo con te: **DAX, US30, NAS100 e Russell nella stessa mezz'ora
sono quattro versioni della stessa scommessa**, e la diversificazione toglie il
rumore del singolo indice ma **non il fattore comune**. Se hai gia' provato ad
aggiungere qualcosa di davvero scorrelato (un'altra sessione, un'altra classe,
un altro meccanismo), sapere **cosa NON ha funzionato** ci farebbe risparmiare
settimane.

---

# 🎁 E COSA POSSIAMO DARTI NOI IN CAMBIO

Non vogliamo solo chiedere. Se ti servono, questi numeri li abbiamo **misurati**
e te li giriamo volentieri:

- 📏 **Spread mediani misurati a tick** (campione: ~252 milioni di tick) sui
  nostri indici, sul nostro broker — utili se vuoi un secondo termine di
  paragone per la tua regola `spread ÷ SL`.
- 🎯 **Il primo slippage mai misurato sul nostro conto reale** su un ORB
  d'apertura su DAX: **+0,70 punti indice in ingresso, 0,00 sull'uscita in
  stop**. ⚠️ **Un solo campione per gruppo: e' un indizio, non una statistica** —
  te lo diciamo com'e'.
- 🕵️ **Una trappola di misura che potrebbe riguardare anche te**: sul nostro
  broker il livello *richiesto* non viene riportato nel prezzo dell'ordine, quindi
  **il modo piu' ovvio di misurare lo slippage darebbe ZERO su qualunque conto**.
  Ce ne siamo accorti per caso confrontando due fonti diverse. Se la tua raccolta
  slippage legge quel campo, **vale la pena verificarlo prima di fidarsi del
  numero**.
- 🇬🇧🇺🇸 **Un fatto pratico**: sul nostro broker **US2000 non esiste proprio**
  (nessun Russell 2000 a listino) e **UK100 c'e'** con spread intorno a **1,6
  punti indice**. Se ti serviva un confronto broker su quei due, eccolo.

Grazie ancora — il documento e' scritto meglio del 90% di quello che si trova in
giro, e la frase che ci portiamo via e' quella finale:

> *"Un vantaggio misurato con lo strumento sbagliato e' un vantaggio inesistente."*
