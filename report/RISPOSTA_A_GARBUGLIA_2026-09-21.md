# ABTG x PS5 — RISPOSTE AI VOSTRI PUNTI APERTI

### Al documento «PS5 x ABTG — Risposte a D1-D6» del 21 settembre 2026

**Da:** Claudio Spadaro (progetto ABTG) · **A:** Marco Garbuglia
**Data:** 21 settembre 2026, sera

---

## Premessa: il vostro canarino misura una cosa che tocca noi, non voi

Avete proposto (D6-a) un esperimento per sapere se il tester conta operazioni o
deal, e lo avete messo in lista come lavoro nostro.

**Non serve farlo: è già misurato, e il risultato è che avevate ragione a
sospettarlo.** Sotto c'è il numero, letto dai CSV e non dai referti che li citano.
È il punto più utile del vostro documento per noi, e ci costringe a correggere
per iscritto i numeri che abbiamo prodotto **oggi stesso**.

---

## 1. Il canarino operazione/deal: MISURATO, e il fattore e' 1,28-1,35

### Che cosa conta la colonna `Trades`

Nei nostri CSV `Trades` e' `TesterStatistics(STAT_TRADES)`. **Conta i deal
d'uscita, non le posizioni.** Con la chiusura parziale attiva, una posizione che
raggiunge il primo obiettivo produce **due** uscite.

### La misura, su una coppia appaiata

Round **R46b**, sedia `ABTG_Dow_Apertura_US` (magic 770202), simbolo `U30USD`,
M5, stessa finestra e stesso banco, con `InpTP1_ClosePct` a **0** e a **50** e
tutto il resto identico:

| finestra | parziale SPENTA | parziale ACCESA | posizioni | fattore |
|---|---:|---:|---:|---:|
| dentro campione | **56** | 73 - 74 | **56** | 1,30 - 1,32 |
| fuori campione | **96** | 123 - 130 | **96** | 1,28 - 1,35 |

**La condizione che rende valido il conto, dichiarata invece che sottintesa:** il
numero di posizioni dev'essere lo stesso nelle due righe. Lo e', ed e'
verificabile in tre modi: un solo ciclo d'ingresso al giorno; nessun ramo
d'ingresso legge `InpTP1_ClosePct`; e il pavimento del lotto del broker non morde
a quel banco. **La riga con la parziale spenta ha un solo valore di `Trades`**
(56 e 96) in tutte le sue celle: le posizioni non si muovono.

### Che cosa correggiamo, di nostro, stasera

Le nostre sedie con la parziale accesa hanno il campione **piu' piccolo di quanto
abbiamo scritto finora**. I round girati oggi:

| round di oggi | `n` pubblicato | **posizioni vere** |
|---|---:|---:|
| Dow `770202` (breakeven indipendente) | 74 / 130 | **56 / 96** |
| DAX `770101` (breakeven indipendente) | 175 / 270 | circa **132 / 203** |
| Nasdaq `770260` (cinque round) | 82 / 102 | **82 / 102**, corretti |

Il Nasdaq e' corretto perche' quella sedia ha la parziale **spenta**: fattore
1,00. **Le conclusioni di quei round non cambiano** — erano tutte «lascia com'e'»
— ma il campione del Dow era **56** operazioni dentro campione, non 74, e la
nostra regola delle 150 va applicata a quel numero.

### Che cosa ne segue per voi

Se il vostro report US2000 dice **445** e conta i deal, la vostra ipotesi delle
**circa 255 posizioni** e' della stessa famiglia del nostro 74 contro 56. Il
nostro fattore non e' il vostro — dipende da quanta parte delle posizioni
raggiunge il parziale, e voi chiudete l'80% a 1,5R dove noi chiudiamo il 50% a
1R — ma **il metodo per misurarlo e' quello della tabella qui sopra: due righe
appaiate che differiscono solo per la percentuale del parziale.** Non serve un EA
di prova, basta una coppia di celle.

---

## 2. Il vostro D6-b e il vostro D6-d hanno la stessa risposta, ed e' un numero solo

Avete trovato due cose che sembrano due errori:

- **D6-b**: «0,3 + 0,5 = 0,86» non torna, fa 0,80;
- **D6-d**: «EURUSD H1: 20,8x in costo pieno = 45,0x in spread» implica un
  rapporto di **2,16x**, non il nostro 3,32x.

**Sono lo stesso fatto, e la somma e' giusta.** Il numero sbagliato e' **lo
spread scritto nella prosa**, non la somma ne' la commissione:

```
   0,400 (spread di quell'ora) + 0,4636 (commissione) = 0,8636  ->  0,86
   rapporto costo pieno / spread = 0,8636 / 0,400     = 2,16

   0,200 (spread MEDIANO di sei giornate) + 0,4636    = 0,6636
   rapporto costo pieno / spread = 0,6636 / 0,200     = 3,32
```

Il «0,3» sta in un nostro referto del 13/09 ed e' un refuso: lo spread di quella
riga e' **0,400**, come scritto nella tabella del nostro documento del 18/09.

**Quindi 2,16 e 3,32 non sono in disaccordo: sono lo stesso conto a due spread
diversi.** E la vostra deduzione e' esatta, la sottoscriviamo:

> «se la conversione dipende dall'ora, va fatta ora per ora: la commissione pesa
> di piu' proprio nelle ore a spread stretto, che sono quelle dove il cancello in
> spread passa piu' facilmente.»

**Conseguenza che accettiamo:** un rapporto unico costo/spread **non esiste**.
Ogni conversione fra le due unita' va fatta con lo spread **dell'ora della
sedia**, e va dichiarata. Le nostre esclusioni per costo di EURUSD H1 e H4 vanno
rilette con questo criterio.

---

## 3. R55: il pedaggio del 2,5% e' sullo SPREAD (vostra lista, punto 7)

La nostra frontiera di casa e' scritta in **spread**: `stop >= 40 x spread`, cioe'
**spread / stop <= 2,5%**. Non e' in costo pieno.

In costo pieno lo stesso cancello vale **8,3%** con il rapporto 3,32, e **5,4%**
con il rapporto 2,16 — e quale dei due sia quello giusto dipende dall'ora, come
al punto 2. **E' esattamente la trappola che ci avevate segnalato**, e vale anche
dentro casa nostra: due nostri paragrafi usano due unita' diverse per lo stesso
cancello.

---

## 4. Il conteggio delle classi: nessuna delle due cifre e' il numero delle voci

Ci chiedete se le 225 classi dell'11/09 e la numerazione fino a 425 del 18/09
significhino 200 classi nuove in una settimana. **No, e vi diamo i tre numeri
veri, contati adesso:**

| | |
|---|---:|
| voci **scritte per esteso** nella checklist | **109** |
| intervallo della numerazione di quelle voci | **438 - 546** |
| numeri di classe **distinti citati** in tutto il repo | **324** |

La numerazione **non e' densa**: i numeri sono assegnati in ordine storico e molte
classi vivono come citazione dentro un referto o un file prova invece che come
voce della checklist. **Quindi «425» era un numero d'ordine, non un inventario**,
e nemmeno «225» lo era. **Da oggi, quando citiamo un totale, diciamo quale dei
tre numeri stiamo usando.**

Aggiungiamo una nostra debolezza sullo stesso tema, trovata **oggi**: due nostri
agenti che lavoravano in parallelo hanno assegnato **lo stesso numero** a due
classi diverse, perche' avevano cercato il primo numero libero all'inizio del
lavoro invece che al momento di scriverlo. L'abbiamo rinumerata e la regola ora
dice di rifare la ricerca **al momento di scrivere**.

---

## 5. Che cosa prendiamo dal vostro documento, e cosa no

### Lo prendiamo, ed e' la cosa che ci serviva oggi: la distribuzione nulla (D5)

La vostra risposta al D5 e' la parte piu' utile per noi, perche' colpisce un buco
che **si e' aperto due volte nella giornata di oggi**.

Oggi abbiamo misurato sette manopole su tre sedie. In due casi una cella era
**concorde** — migliorava dentro e fuori campione — e l'abbiamo **scartata lo
stesso**, perche' guardando i due vicini era un **picco** e non un altopiano. E'
stata una decisione a occhio, presa con una regola di casa che dice «centro
dell'altopiano, mai il picco», ma **senza un numero che dicesse quanto spesso un
picco concorde capita per caso**.

La vostra proposta lo trasforma in una misura, e la sottoscriviamo in tutti e tre
i punti:

1. **serie vere, motore vero, vantaggio zero** — randomizzando la direzione o
   l'istante d'ingresso, non rumore bianco sulle celle;
2. **si fa girare la regola di promozione INTERA** sulle griglie nulle, e si
   registra il PF fuori campione della cella che la regola promuove;
3. **il candidato vale se sta oltre il P95** di quella distribuzione, e la
   statistica secondaria e' la lunghezza del blocco contiguo, non l'area.

Prendiamo anche il vostro corollario sul **campione efficace**: la quota di
operazioni in comune fra celle vicine si **misura**, e allora «30 su 30 in utile»
diventa «N efficaci su N». Il nostro agente lo aveva **stimato** vicino a uno;
stimarlo non basta.

### Lo prendiamo: il grappolo dentro la stessa ora (D2)

> «il grappolo che conta di piu' non e' quello fra giorni: e' quello dentro la
> stessa ora.»

Ci riguarda alla lettera: due delle nostre sedie d'apertura, sul Dow e sul
Nasdaq, hanno la **stessa ora d'ingresso**. Accettiamo la conseguenza: **il blocco
minimo di un riordino dev'essere la giornata di portafoglio, non l'operazione**,
e un Monte Carlo che riordina le singole operazioni **sottostima la peggior
giornata**.

Aggiungiamo una cosa nostra sullo stesso tema, perche' e' un limite e non un
merito: abbiamo un **tetto di rischio per cluster** firmato, e **non e' attivo**.
Abbiamo misurato che oggi non morderebbe — il tetto generale scatta prima — ma
diventa una rete vera alla quarta sedia sullo stesso gruppo.

### Lo prendiamo: lo slippage per DEAL e non per operazione (D1)

Il vostro passaggio dall'operazione al deal, con il livello di riferimento
riconosciuto dal motivo del deal, e' corretto e lo useremo anche noi. La vostra
supposizione che la divergenza fra i nostri due gruppi di misure — noi slippage
in ingresso e zero in uscita, voi il contrario — venga dal fatto che le vostre
«uscite» includevano **parziali chiusi a mercato dall'EA**, e' la spiegazione piu'
semplice che rende vere tutte e due le misure. Aspettiamo la riderivazione.

### Non lo prendiamo, e lo diciamo con il vostro stesso criterio

| cosa | perche' |
|---|---|
| le 32 misure di slippage del 13/09 | **le avete ritirate voi** |
| la tabella Monte Carlo (P95 fra 1,19 e 1,91 volte l'osservato) | descrive una cella **con la recovery accesa, che non e' piu' in campo**: lo scrivete voi |
| i vostri PF | in gran parte **coarse**, e il vostro dossier dice che il coarse gonfia di circa **due volte**. L'unico al tick pulito che citate fa **PF 1,15** |
| «i due sistemi sono vicini sulle soglie» | **ritirata da voi**, e per il motivo giusto |
| il forward su demo (9 operazioni, PF 2,44) | **n = 9**: per la nostra regola il merito e' sospeso, e lo scrivete anche voi |

---

## 6. Una cosa che facciamo diversamente da voi, e che forse vi serve

Voi scrivete (D6-e) che i vostri EA dimensionano sulla distanza dello stop per il
valore del tick, **commissione esclusa**, e ci elencate tre casi in cui il rischio
vero supera quello dichiarato. E' la stessa famiglia del nostro difetto.

Il nostro caso peggiore **non e' nel dimensionamento**: e' che una manopola di
protezione puo' essere **accesa e inerte**. Oggi abbiamo trovato che il nostro
stop-a-pareggio al primo obiettivo sta **dentro** il ramo della chiusura parziale:
se la parziale e' spenta, mettere quel flag a `true` **non fa assolutamente
niente**. Lo abbiamo misurato accoppiando le righe che differiscono solo per quel
flag: **36 coppie su 36 identiche** con la parziale spenta, **15 su 36 diverse**
con la parziale accesa. Lo stesso schema e' in **16 nostri file**.

**Perche' ve lo diciamo:** la vostra famiglia ha `InpBreakeven = true`, e due
vostri dossier descrivono un pareggio che il codice che avete riaperto non fa.
**Prima di cercarlo nelle versioni intermedie, vale la pena controllare se nella
vostra il pareggio e' annidato dentro il ramo del parziale come nella nostra.**
Se lo e', il pareggio «non fatto» non e' una versione diversa: e' una
configurazione in cui quel ramo non viene mai aperto. Il controllo e' una lettura
di parentesi, non un backtest.

---

## Cosa succede adesso, dalla nostra parte

| # | cosa | chi |
|---|---|---|
| 1 | Canarino operazione/deal: **fatto**, fattore 1,28-1,35, tabella al punto 1 | noi - fatto |
| 2 | R55: il pedaggio e' sullo **spread** (punto 3) | noi - fatto |
| 3 | Conteggio delle classi: 109 voci, numerazione 438-546, 324 numeri citati | noi - fatto |
| 4 | Riconciliazione 2,16 / 3,32: stesso conto, spread diversi (punto 2) | noi - fatto |
| 5 | Etichette IS/OOS nel PDF del dossier | noi - da fare |
| 6 | Rilettura delle esclusioni per costo di EURUSD H1/H4 con lo spread **dell'ora** | noi - da fare |
| 7 | Distribuzione nulla dell'altopiano, con la vostra ricetta al D5 | noi - da fare |
| 8 | Controllo di parentesi sul vostro pareggio (punto 6) | voi, se vi serve |

---

## Chiusura

Il pezzo piu' utile del vostro documento, per noi, non e' un numero: e' il metodo
del D5, perche' colpisce una decisione che **oggi abbiamo preso a occhio due
volte**. E il vostro canarino del D6-a ci ha costretti a rileggere i nostri
campioni di stasera e a scoprire che **il Dow aveva 56 operazioni dove avevamo
scritto 74**.

Voi ci scrivete che il 35% non esiste e che il vostro «1,5-2x» era giusto per
meta'. Noi vi scriviamo che un nostro spread era un refuso, che i nostri totali di
classe non erano inventari, e che stasera abbiamo dovuto correggere di un quarto
il campione di due round appena finiti.

---

*Progetto ABTG - 21 settembre 2026. I numeri di questo documento vengono dai file
riaperti in questo giro: i CSV del round R46b su `U30USD`, i CSV dei round di oggi
sulle tre sedie d'apertura, la tabella del nostro documento del 18/09 e il
registro delle classi. Dove una misura non esiste, qui c'e' scritto.*
