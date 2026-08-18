# 📰 POST NEWS — SPECIFICA IMPLEMENTABILE RICOSTRUITA DAL CORSO

**Fonte:** 9 trascrizioni, lezioni **2-10** del master (capitolo 5, "la prima
strategia"), in
`backtest_pipeline/caccia_strategie/trascrizioni_corso_2026-08-18/modulo_postnews/`
— **~78.500 caratteri, letti per intero, riga per riga.**

**Referto narrativo (schede lezione per lezione, contraddizioni, aritmetica):**
`backtest_pipeline/caccia_strategie/ANALISI_CORSO_POSTNEWS_2026-08-18.md`
— qui NON si duplica: qui c'e' solo cio' che serve a scrivere il codice.

**Etichette:** `[T]` = testuale nella trascrizione (cito) · `[I]` = inferito
(dico da dove) · `[?]` = incerto · `[T-dubbio]` = trascritto ma il numero
potrebbe essere un errore di speech-to-text.

> 🔒 **Nessuna modifica al forward. Nessun EA toccato. Nessun round lanciato.**
> Questa e' una specifica, non un ordine di esecuzione. Decide Claudio.

---

## 0. 🎯 IL VERDETTO DI MECCANIZZABILITA'

> ## **77% SECCO — 20 decisioni su 26 sono dettate a voce con un numero.**
> ## **92% con 4 assunzioni dichiarate. E' il modulo PIU' meccanizzabile dei sei.**

E non e' un caso: **e' l'unico modulo che si autodefinisce meccanico** `[T]`
lez. 2: _"Il concetto di una strategia meccanica e' quello di **non dover mai
prendere una decisione** … la strategia meccanica ti dice precisamente quando
fare l'operazione, su quale tasso di cambio, se devi comprare o vendere e come
gestire l'operazione"_ — e lez. 5: _"questa cosa la faranno esattamente uguale
tutte le persone che applicheranno questa strategia … **faremo tutti la stessa
cosa perche' e' una strategia meccanica**"_.

| | Breakout | Mediazione | Fibo H4 | Media 200 | Point Break | **POST NEWS** |
|---|---:|---:|---:|---:|---:|---:|
| meccanizzabilita' secca | 55% | ~50% | 50% | 48% | non-strategia | **77%** 🥇 |

### 🟢 Le tre cose che questo modulo ha e gli altri cinque NO

1. **Il FUSO E' DICHIARATO.** Tutti gli orari sono **ora italiana**, detto
   esplicitamente e ripetuto 6 volte `[T]` (lez. 3: _"la cosa importante che
   devi verificare e' che qua ci sia **l'ora italiana**"_; lez. 9: _"la notizia
   era alle 19.30 **ora italiana**"_). Negli altri moduli il fuso era il buco
   n.1.
2. **L'ARITMETICA DEI DUE ESEMPI TORNA AL CENTESIMO** (§7): prezzi, SL, TP e
   perfino il **lotto** dei due casi pratici sono verificati esatti. Negli altri
   moduli i conti si rompevano.
3. **L'USCITA E' DETERMINATA**: TP 50 / SL 25 / scadenza dei pendenti, senza
   "a discrezione". Rompe il filo rosso degli altri cinque moduli — con
   un'eccezione sola (il trailing opzionale, D20).

### 🔴 E le tre che mancano
1. **Il backtest non e' verificabile** e per la parte piu' vecchia **non e'
   nemmeno producibile con lo strumento insegnato** (§8).
2. **Il rischio suggerito (3% per evento) e' 4,6x il nostro** e non passa il
   metro prop (§6).
3. **Nessun filtro spread/slippage**, sostituito da un'ASSERZIONE (§9.2).

---

## 1. LA TESI, COME LA DICHIARA IL CORSO

`[T]` lez. 4, ed e' l'unica giustificazione logica che viene data:

> _"Devi cominciare a capire che di notizie macroeconomiche fondamentalmente ne
> esistono di due tipi. Il rilascio di **un dato numerico** e situazioni in cui
> invece **una persona parla**."_

- Sul **dato numerico** (CPI, GDP, disoccupazione, tassi): _"nel secondo in cui
  esce quel dato il mercato reagisce in modo violentissimo … se anche imposti
  uno stop loss, **non puoi essere sicuro che quella sara' la tua perdita
  massima. Il tuo stop loss puo' essere saltato**"_ `[T]` → **queste notizie
  NON si tradano**.
- Sulla **conferenza stampa** (una persona che parla): _"c'e' una reazione del
  prezzo molto meno esplosiva, ma molto piu' **dosata nel tempo** … andando a
  cavalcare quei **trend a breve e medio periodo** che quasi sempre si formano
  in concomitanza con una persona che parla"_ `[T]` → **queste si**.

**La tesi in una riga, come la testerebbe un tester:** durante una conferenza
stampa di banca centrale il prezzo esce dal range dei primi 10-15 minuti e
prosegue nella direzione della rottura per almeno 50 pip prima di ritracciare
di 25.

⚖️ **Cosa NON e' dimostrato:** che la reazione a una conferenza stampa sia
diversa **in modo misurabile** da quella a un dato numerico. E' un'asserzione
qualitativa, ripetuta tre volte, mai quantificata. **E' esattamente cio' che un
nostro backtest puo' falsificare** (§10, test P2).

---

## 2. LE DUE NOTIZIE E I LORO PARAMETRI — la tabella madre

| | 🇪🇺 **ECB Press Conference** | 🇺🇸 **US FOMC Press Conference** |
|---|---|---|
| **strumento** | **EUR/JPY** `[T]` lez. 5 (_"la traderai **sempre** sul cross euro-yen, sempre"_) | **EUR/USD** `[T]` lez. 8 |
| **timeframe** | **M5** `[T]` (_"nella strategia post-news **per tutte le notizie** il time frame sara' sempre 5 minuti"_) | **M5** `[T]` |
| **orario notizia** | **14:45 ora italiana** `[T]` lez. 5 (era **14:30 fino a meta' 2022** `[T]`) | **20:30 IT** in ora legale / **19:30 IT** nelle finestre di disallineamento `[T]` lez. 8 — ⚠️ la regola generale che ne da' e' SBAGLIATA, vedi §4.2 |
| **frequenza dichiarata** | 8/anno, giovedi, ogni 6 settimane `[T]` | 8/anno `[I]` (mai detto: si ricava da _"16 operazioni all'anno"_ lez. 10) |
| **candele di riferimento** | le **DUE DOPO** quella della notizia (14:50 e 14:55) — **la candela della notizia si IGNORA** `[T]` | la candela **DELLA notizia** + la successiva (20:30 e 20:35) `[T]` |
| **istante d'azione** | **15:00 IT** = notizia **+15 min** `[T]` | **20:40 IT** = notizia **+10 min** `[T]` (_"qui anticipiamo di 5 minuti"_) |
| **livelli** | max e min **fra le due candele, ombre incluse** `[T]` (_"ovviamente considerando anche le ombre"_) | idem `[T]` |
| **ordine 1** | **BUY STOP a high + 3 pip** `[T]` | idem `[T]` |
| **ordine 2** | **SELL STOP a low − 2 pip** `[T]` (2 volte, lez. 5 e 6) | idem `[T]` lez. 8 |
| **TP / SL** | **50 / 25 pip** su ciascuno dei due `[T]` | **50 / 25** `[T]` |
| **OCO** | ❌ **NO, esplicito** `[T]` (§3.4) | ❌ **NO** `[T]` |
| **scadenza PENDENTI** | **18:15 IT** dello stesso giorno `[T]` (= notizia +3h30) | **notizia + 75 minuti** `[T]` (20:30→21:45 / 19:30→20:45) |
| **scadenza POSIZIONE** | ❌ **nessuna** `[T]` esplicito (§3.5) | ❌ **nessuna** `[T]` |
| **trailing** | **si, opzionale**: a +25 pip di profitto, SL da −25 a **−15** `[T]` | ❌ **niente** `[T]` (_"qua non devi fare niente"_) |
| **chiusura forzata** | venerdi **22:50 IT** se ancora aperta `[T]` | idem `[T]` |
| **rischio** | **3% per evento**, size calcolata su **50 pip** `[T]` (§6) | idem `[T]` |

### 2.1 🧭 Gli stessi orari in ORA SERVER BCM (regola di casa: server = IT − 1)

⚠️ **Conversione lecita perche' la fonte DICHIARA il fuso** (ora italiana). Per
tutti gli altri moduli questa conversione era vietata.

| evento | notizia | azione | scadenza pendenti |
|---|---|---|---|
| **ECB** | 14:45 IT → **13:45 BCM** | 15:00 IT → **14:00 BCM** | 18:15 IT → **17:15 BCM** |
| **FOMC** (20:30 IT) | → **19:30 BCM** | 20:40 IT → **19:40 BCM** | 21:45 IT → **20:45 BCM** |
| **FOMC** (19:30 IT, solo finestre di disallineamento) | → **18:30 BCM** | → **18:40 BCM** | → **19:45 BCM** |

🔴 **`[?]` Il "−1" e' verificato solo per QUESTO periodo dell'anno**
(`CLAUDE.md`: _"in questo periodo"_). Se BCM segue l'ora legale, il delta
Italia→server resta −1 tutto l'anno e le righe sopra valgono sempre; se non la
segue, d'inverno cambia. **Non e' misurato. Da verificare su un grafico di
gennaio prima di qualunque forward.** La soluzione robusta e' non usare orari
fissi: §5.

---

## 3. LA MACCHINA, PASSO PER PASSO (pseudocodice della lezione)

### 3.1 Il ciclo completo di un evento

```
ALL'ORARIO D'AZIONE (ECB news+15 / FOMC news+10, ora italiana):
  hi = max(high[1], high[2])        # le due candele M5 di riferimento
  lo = min(low[1],  low[2])         # ombre incluse
  buyPrice  = hi + 3 pip
  sellPrice = lo - 2 pip
  lot = (saldo * 3%) / (50 pip * valore_pip)      # NB: 50, non 25 - vedi 3.3
  PIAZZA BUY  STOP  @ buyPrice   SL = buyPrice  - 25 pip   TP = buyPrice  + 50 pip
  PIAZZA SELL STOP  @ sellPrice  SL = sellPrice + 25 pip   TP = sellPrice - 50 pip
  scadenza di ENTRAMBI i pendenti = ECB 18:15 IT | FOMC news+75min
  # NESSUN OCO: restano vivi tutti e due anche dopo il primo scatto
POI:
  se (solo ECB) profitto >= +25 pip -> sposta SL a -15 pip dall'ingresso  [opzionale]
  la posizione NON ha scadenza oraria: esce a TP, a SL,
      o venerdi 22:50 IT (chiusura manuale, caso "una volta in 15 anni")
```

`[T]` lez. 5, la sequenza in bocca al relatore: _"il 6 giugno … quello che faro'
sara' aspettare le 15, prendere quei due prezzi come riferimento, andare a
impostare quei due ordini pendenti su euro yen"_.

### 3.2 ⏱️ La differenza ECB/FOMC nelle candele — e perche' NON e' un dettaglio

- **ECB**: si **butta via** la candela della notizia. Range = 14:50 + 14:55.
  Si agisce a **15:00**.
- **FOMC**: si **tiene** la candela della notizia. Range = 20:30 + 20:35.
  Si agisce a **20:40**.

`[T]` lez. 8: _"in questo caso noi anticipiamo tutto rispetto all'ICB di 5
minuti, cioe' mentre sull'ICB noi ignoravamo la candela della notizia e
lavoravamo sulle due successive, **qua lavoriamo sulla candela della notizia e
sulla successiva**"_.

🔴 **Il MOTIVO non viene MAI dato.** In tutte e 9 le lezioni non c'e' una riga
che spieghi perche' sull'ECB la candela dell'evento si scarta e sull'FOMC no.
E' la differenza piu' sostanziale fra le due notizie e resta **[?] non
motivata** → in un round va trattata come **parametro da spazzolare** (skip 0/1
candela), non come verita' ricevuta.

📐 **Conseguenza sul range:** includere la candela della notizia significa
includere lo **spike** del rilascio → range piu' largo → ordini piu' lontani →
meno riempimenti ma rotture piu' significative. Sono due strategie con due
profili diversi, vendute come "la stessa architettura".

### 3.3 💰 Perche' la size si calcola su 50 pip e non su 25 — la parte piu' intelligente del modulo

`[T]` lez. 6, ed e' un ragionamento corretto che va conservato:

> _"Com'e' possibile che allora noi calcoliamo il volume mettendo 50 di stop
> loss? … **se un ordine viene eseguito l'altro ordine pendente resta
> posizionato** … puo' essere che vengano eseguiti entrambi gli ordini ed
> entrambi si chiudano in stop loss? **E' raro ma e' successo** … Ecco perche'
> noi qua impostiamo stop loss 50 pip, perche' il 3% e' quello che noi
> perderemo **nell'ipotesi dello scenario peggiore**"_

**Traduzione operativa:** il "3%" del corso e' un **budget per EVENTO**, non per
trade. Il singolo ordine rischia **1,5%** `[T]` (_"sull'ordine singolo il massimo
che potrai perdere e' l'1,5%"_).

### 3.4 🔴 NIENTE OCO — dichiarato, e il nostro EA fa il contrario

`[T]` lez. 6: _"io prima non ti ho detto che in questa strategia c'e' la regola
per cui **se uno dei due ordini viene eseguito tu vai a cancellare l'altro. No**,
se un ordine viene eseguito l'altro ordine pendente **resta posizionato**"_.

Lo scenario ammesso e descritto: prezzo sale → esegue il buy → torna giu' →
stoppa il buy → esegue il sell → risale → stoppa anche il sell. **Doppio stop
nello stesso evento.**

🔴 **`ABTG_PostNews.mq5` ha `InpUseOCO = true` di default** (cancella la gamba
opposta al primo scatto): **implementa la strategia che il corso NEGA
esplicitamente**. Vedi §9.1 — non e' un bug, e' una scelta di un'altra fonte,
ma va sweepata, non ereditata.

### 3.5 🔴 LA POSIZIONE NON HA SCADENZA — dichiarato due volte

`[T]` lez. 5: _"la scadenza fa riferimento **solo all'ordine pendente** … se
per esempio quell'ordine viene eseguito alle 16 e 30 non e' che diventando un
buy a mercato alle 18 e 15 la piattaforma lo chiude. **No**"_.
`[T]` lez. 9 (FOMC): l'esempio del 20/03/2024 **tiene la posizione tutta la
notte** — _"l'ordine sarebbe stato eseguito intorno alle 19.45, sarebbe rimasto
aperto tutta la notte e la mattina intorno alle 8 l'ordine sarebbe chiuso in
profitto"_.

🔴 **`ABTG_PostNews.mq5` ha `InpCloseAtExpiry = true`**: chiude la posizione
alla scadenza. **Anche questa e' la strategia opposta a quella insegnata** —
e viene da un'altra fonte (§9.1). Con l'esempio-principe della lez. 9 (profitto
preso alle 8 del mattino dopo) la chiusura a scadenza **avrebbe cancellato il
trade migliore del video**.

### 3.6 Il trailing (SOLO ECB) — l'unico pezzo NON meccanico del modulo

`[T]` lez. 6: _"solo per questa notizia c'e' la possibilita' di migliorare
leggermente le performance applicando **una sorta di piccolo trading stop** [=
trailing stop], che **se riesci bene, se non riesci non muore nessuno** … **non
nel preciso istante in cui raggiungi i 25 pips di profitto, ma se tu vedi che li
ha raggiunti**, puoi andare ad accorciare lo stop loss … da 25 a **15**"_.

- Trigger: **+25 pip di profitto** (meta' strada verso il TP).
- Nuovo SL: **−15 pip dall'INGRESSO** (non break-even: resta una perdita di 15).
- ⚠️ **Timing dichiarato discrezionale** ("se tu vedi che li ha raggiunti") →
  in un EA diventa deterministico, quindi **l'EA e' PIU' preciso della
  strategia**: il backtest sara' ottimistico rispetto all'esecuzione umana.
  **Va scritto accanto al numero.**
- ✅ Il nostro EA lo implementa correttamente (SL a `open − 15 pip`, non a BE).

---

## 4. 🕐 GLI ORARI — e il primo modulo che possiamo VERIFICARE con dati di casa

> 🥇 **La scoperta operativa di questa analisi: il calendario di casa contiene
> ESATTAMENTE questi due eventi, con l'orario, e quindi possiamo controllare
> quello che il relatore dice invece di crederci.**
>
> `caccia_strategie/biblioteca/dati/CALENDARIO_news-2021-2024_UTC+2_*.csv` +
> `CALENDARIO_news-2022-2025_UTC+2_*.csv` — 37.799 righe, titoli
> **`ECB Press Conference`** e **`FOMC Press Conference`**, impatto **3**.

### 4.1 ✅ DUE affermazioni del relatore VERIFICATE sui nostri dati

**(a) Lo spostamento dell'ECB da 14:30 a 14:45 a meta' 2022** `[T]` lez. 5:
_"questa notizia fino circa alla meta' del 2022 era sempre rilasciata alle
14.30, per piu' di un decennio … adesso e' alle 14.45"_.

Le righe del nostro CSV (ora del server del calendario):

```
2022.06.09 15:30   ECB Press Conference     <-- vecchio orario
2022.07.21 15:45   ECB Press Conference     <-- SALTO, e non torna piu' indietro
2022.09.08 15:45   ECB Press Conference
```

✅ **Il salto c'e', ed e' esattamente dove lo mette lui.** Prima volta in sei
moduli che un'affermazione del corso viene confermata da una fonte
indipendente in casa nostra.

**(b) L'esempio FOMC del 20/03/2024 "alle 19:30 ora italiana"** `[T]` lez. 9.
Il nostro CSV ha `2024.03.20 20:30` (ora calendario = UTC+2 a marzo) = **18:30
UTC = 19:30 in Italia**. ✅ **Combacia al minuto.**

### 4.2 🔴 UNA affermazione del relatore FALSIFICATA dai nostri dati

`[T]` lez. 8: _"quando in Italia siamo in ora legale, quindi da **aprile a
settembre e' alle 20.30**, mentre invece **da ottobre a marzo e' alle 19.30**"_.

**E' sbagliato.** Il FOMC parla alle **14:30 di New York**: l'ora italiana
cambia **solo nelle 2 finestre in cui USA ed Europa non hanno ancora cambiato
l'ora insieme** (meta' marzo e fine ottobre/inizio novembre). Nei mesi di
dicembre, gennaio e febbraio — che sono "ottobre-marzo" — la conferenza e' alle
**20:30 italiane**, non alle 19:30.

**Contati sul nostro CSV (2021-2025), eventi FOMC fra novembre e marzo:**

| ora italiana reale | eventi | quali |
|---|---:|---|
| **19:30** (disallineamento) | **6** | 2021.03.17 · 2021.11.03 · 2022.03.16 · 2022.11.02 · 2023.03.22 · 2023.11.01 · 2024.03.20 · 2025.03.19 *(8 contando tutto il periodo)* |
| **20:30** (entrambi in ora solare) | **11** | tutti i dicembre / gennaio / febbraio + i novembre "tardi" (2024.11.07) |

🔴 **Un EA che applicasse la regola detta a voce sbaglierebbe l'orario su 11
eventi invernali su 17 (65%)** — e sbagliare l'orario qui non significa
"entrare male": significa **prendere le candele sbagliate**, cioe' misurare il
range di un momento qualunque.

⚖️ **A discolpa del relatore:** si copre subito dopo `[T]` — _"comunque ripeto,
il sito se tu verifichi che ti dia l'ora italiana, ti da' l'ora italiana precisa
del rilascio"_. **Per un umano davanti a Forex Factory il problema non esiste.
Per un EA con l'ora scritta a mano, esiste eccome.** → §5.

### 4.3 📅 Quanti eventi abbiamo davvero in casa (e il muro dei 150 trade)

| serie | eventi unici nel CSV | copertura |
|---|---:|---|
| ECB Press Conference | **35** | 2021.01.21 → 2025.06.05 |
| FOMC Press Conference | **35** | 2021.01.27 → 2025.06.18 |
| **TOTALE** | **70** | ~4,5 anni |

⚠️ **Due buchi di dato da sapere prima di lanciare:**
1. **Il 2025 e' incompleto**: gli ultimi eventi sono di giugno 2025 benche' il
   file arrivi a dicembre 2025. Anche **dicembre 2024 manca** in entrambe le
   serie. → **anni pieni utilizzabili: 2021-2024 = 62 eventi.**
2. **Il fuso del CSV non e' fisso**: si comporta da **UTC+2 d'inverno / UTC+3
   d'estate** (classico orario server MetaQuotes) fino a marzo 2025, poi le
   righe cambiano convenzione (2025.04.17 ECB alle 14:45 invece che 15:45). Il
   nome del file dice "UTC+2" e **il nome del file mente**. → l'offset va
   **calibrato e verificato**, non assunto (§5.2).

🚨 **E qui arriva il vincolo che decide tutto:**

> **62-70 eventi producono al massimo ~70-100 operazioni. La regola di casa
> (Emendamento della Finestra, punto A) chiede >=150 operazioni SOLO per l'IS,
> piu' altre 150 per l'OOS.**
>
> **Con il calendario che abbiamo in casa, la Post News NON e' misurabile
> secondo il metro di casa.** Non e' un'opinione: e' un conteggio.

**Le tre uscite possibili, in ordine di costo:**
1. 🥇 **Allargare la famiglia** (§10, test P1): il CSV contiene **altre 5 banche
   centrali con conferenza stampa** — BoJ (58 righe), BoC (41), RBNZ (34), SNB
   (26), piu' NBS cinese (81). Testare il **meccanismo** su tutte porta il
   campione a **oltre 250 eventi** e risponde alla domanda vera: _il post-news
   funziona, o funzionano solo ECB e FOMC (= sovradattamento a 70 date)?_
2. 🥈 **Allungare all'indietro**: servono le date ECB/FOMC dal 2009. Sono
   pubbliche e deterministiche, ma **non le abbiamo** e **non me le invento**:
   e' una richiesta di dato, non un'inferenza.
3. 🥉 **Rinunciare all'IS/OOS** e giudicare con la **PROVA DI REGIME**
   (Emendamento C): 4 finestre, 15-20 eventi ciascuna. Sospende il giudizio sul
   merito, non sul rischio (Emendamento B).

---

## 5. 🔧 COME SI IMPLEMENTA DAVVERO — l'ora si legge, non si scrive

### 5.1 Il difetto strutturale dell'implementazione attuale

`ABTG_PostNews.mq5` decide **a un orario fisso** (`InpActionHour/Min`) e usa il
calendario **solo per sapere se oggi c'e' la notizia** (commento nel sorgente:
_"Match sul giorno, non sull'ora … Il QUANDO operare e' dato da
InpActionHour/Min"_).

Su una serie storica questo si rompe **tre volte**:

| quando | cosa succede all'orario fisso |
|---|---|
| **luglio 2022** | l'ECB passa da 14:30 a 14:45 IT → l'azione fissa alle 15:00 legge **le candele +15/+20** invece di +5/+10 |
| **marzo / novembre** | il FOMC passa fra 19:30 e 20:30 IT → **un'ora di errore, 12 candele fuori** |
| **ora legale** | se il delta BCM-Italia non e' costante, tutto slitta di 60 minuti |

### 5.2 La forma corretta (proposta, NON eseguita)

```
1. all'avvio: carica gli eventi (titolo contiene "ECB Press Conference" /
   "FOMC Press Conference", impatto >= 3)
2. converti l'ora dell'evento in ORA SERVER:
      t_server = t_csv + OFFSET_CSV_SERVER          (input, default 0)
   e VERIFICALO invece di fidarti: per gli ultimi 3 eventi controlla che la
   candela M5 dell'evento sia la piu' AMPIA della giornata. Se non lo e',
   l'offset e' sbagliato -> LOG ROSSO e nessun ordine.
3. istante d'azione   = t_server + InpActionOffsetMin   (ECB 15, FOMC 10)
4. range              = le DUE candele M5 chiuse prima dell'istante d'azione
5. scadenza pendenti  = t_server + InpExpiryOffsetMin   (ECB 210, FOMC 75)
```

✅ **Con questa forma spariscono tutti e tre gli errori sopra**, l'EA diventa
indipendente dall'ora legale e **il backtest storico diventa possibile senza
toccare i preset anno per anno**.

🧪 **Il controllo di sanita' del punto 2 e' gratis e vale oro**: e' lo stesso
tipo di controllo che ci ha salvato sul fuso del DAX. Un EA che non sa
dimostrare di aver trovato la candela giusta **non deve piazzare ordini**.

### 5.3 Il pip, il prezzo, e i due decimali diversi

`[T]` lez. 8: _"prima ragionavamo su euro-yen che ha solo tre cifre decimali,
qui lavoreremo invece su euro-dollaro che ha 5 cifre decimali"_.

- EUR/JPY 3 decimali → **1 pip = 0,010**
- EUR/USD 5 decimali → **1 pip = 0,00010**
- ✅ `PipSize()` del nostro EA (`_Point*10` per digits 3/5) e' **corretto** e
  riproduce entrambi gli esempi al centesimo (§7).

### 5.4 🎯 L'asimmetria +3 / −2 e' una CORREZIONE DELLO SPREAD, non un capriccio

`[T]` lez. 5: _"Piu' 3 e meno 2, semplicemente **per lo spread**, la differenza
tra bid e ask. In realta' sia l'ordine di acquisto che l'ordine di vendita
vengono eseguiti 2 pips sopra e sotto, ma perche' l'ordine di acquisto venga
eseguito 2 pips sopra, **a causa dello spread devo metterlo 3 pips**"_.

**Il ragionamento e' tecnicamente giusto:** un BUY STOP scatta sull'**ASK**, un
SELL STOP sul **BID**. Il livello vero che il relatore vuole e' **+2 pip di BID
in entrambe le direzioni**, e il +3 e' un +2 **con 1 pip di spread assunto**.

🔧 **Conseguenza per noi:** l'offset del buy **non e' 3**, e'
`2 pip + spread_corrente`. Su EUR/JPY BCM lo spread non e' garantito 1 pip →
l'implementazione fedele e':

```
buyPrice  = hi + 2 pip + spread_corrente     (invece di hi + 3 pip fisso)
sellPrice = lo - 2 pip
```

⚠️ **E questo spiega la divergenza con la nostra fonte live** (§9.1: il preset
usa −3 sul sell): con un'assunzione di spread diversa cambia il numero. **Il
parametro giusto da spazzolare non e' "2 o 3": e' `offset_base` (1-4 pip) con
lo spread aggiunto solo al lato buy.**

---

## 6. 🚨 RISCHIO — dove il modulo esce dal metro di casa

### 6.1 Cosa dice il corso

`[T]` lez. 6: _"per questa strategia **ti suggerisco un profilo di rischio del
3% a operazione**, questo e' quello che suggeriamo noi, ovviamente se vuoi avere
un approccio piu' aggressivo alzerai quel rischio"_.

- 3% = **budget dell'evento** (doppio stop), 1,5% = singolo ordine `[T]`.
- Formula del volume `[T]`: `lotti = (saldo x rischio%) / (SL_riferimento x valore_pip)`
  con **SL_riferimento = 50 pip sempre**, valore pip dal calcolatore Dukascopy.
- ⚠️ La lezione che insegna quella formula **non e' nel nostro corpus** (sta in
  un capitolo precedente che non abbiamo): qui e' solo **usata**.

### 6.2 Il confronto col metro di casa — e non e' vicino

| | corso | casa (A1) | fattore |
|---|---:|---:|---:|
| rischio per ORDINE | **1,50%** | **0,65%** | **2,3x** |
| rischio per EVENTO (doppio stop) | **3,00%** | 1,30% | **2,3x** |
| quota del cap C1 (3,25% aperto) consumata da UN evento | **92%** | 40% | — |
| drawdown massimo dichiarato (solo ECB) | **15%** `[dichiarato]` | muro prop 10% | 🔴 **sfonda** |

🔴 **Al 3% del corso, UN SOLO evento consuma il 92% del cap di rischio aperto
firmato il 18/08.** E il drawdown che il relatore stesso dichiara (15%) **e' piu'
grande del muro totale di ogni prop censita** (10%).

✅ **Riscalatura di casa (proposta):** `InpRiskPercent = 1,30` con
`InpRiskRefSLpips = 50` → **0,65% per ordine**, 1,30% per evento nel caso
peggiore. **Con questa taratura il DD dichiarato del 15% si riduce
proporzionalmente a ~6,5%** — sotto il muro, sopra il fastidio.

### 6.3 Nessun cap giornaliero, nessuna correlazione — ma qui quasi non serve

- ❌ Il modulo non nomina mai un limite di perdita giornaliera.
- ✅ **Ma le due notizie non cadono MAI lo stesso giorno** (ECB giovedi, FOMC
  mercoledi; nel nostro CSV 2021-2025 **zero collisioni di data**) → il rischio
  aggregato di strategia e' per costruzione **un solo evento alla volta**.
  E' l'unica strategia dei sei moduli che **non ha il problema
  dell'esposizione simultanea**.

---

## 7. 🧪 TEST-CASE NUMERICI — i due esempi, verificati uno per uno

> **Questi due casi vanno usati come test di accettazione dell'EA: se
> l'implementazione non riproduce questi numeri esatti, e' sbagliata.**

### T1 — ECB, giovedi 07/03/2024, EUR/JPY `[T]` lez. 6

| voce | valore dettato | verifica aritmetica |
|---|---|---|
| high delle 2 candele | **160,780** | — |
| low delle 2 candele | **160,607** | — |
| BUY STOP (high +3 pip) | **160,810** | ✅ 160,780 + 0,030 |
| SL del buy (−25) | **160,560** | ✅ −0,250 |
| TP del buy (+50) | **161,310** | ✅ +0,500 |
| SELL STOP (low −2 pip) | **160,587** | ✅ 160,607 − 0,020 |
| SL del sell (+25) | **160,837** | ✅ +0,250 |
| TP del sell (−50) | **160,087** | ✅ −0,500 |
| saldo | **9.935 €** | — |
| rischio 3% su 50 pip, valore pip **5,90 €** | **volume 1,01** | ✅ 9935 × 0,03 / (50 × 5,90) = **1,0103** |
| scadenza | 18:15 IT = **16:15 sulla sua piattaforma** | ✅ coerente con "piattaforma 2h indietro in ora legale" |
| esito raccontato | sell mai eseguito e cancellato; **buy eseguito, TP +50 pip** | `[dichiarato]` |

**8 numeri su 8 tornano.** Compreso il lotto.

### T2 — FOMC, mercoledi 20/03/2024, EUR/USD `[T]` lez. 9

| voce | valore dettato | verifica |
|---|---|---|
| high | **1,08892** | — |
| low | **1,08656** | — |
| BUY STOP (+3 pip) | **1,08922** | ✅ +0,00030 |
| TP buy / SL buy | **1,09422** / **1,08672** | ✅ +50 / −25 |
| SELL STOP (−2 pip) | **1,08636** | ✅ −0,00020 |
| SL sell / TP sell | **1,08886** / **1,08136** | ✅ +25 / −50 |
| valore pip EUR/USD | **9,21 €** | — |
| volume | **0,65** | ✅ implica saldo ≈ 9.976 € al 3% su 50 pip |
| scadenza | 19:30 IT + 75 min = 20:45 IT = **19:45 piattaforma** | ✅ |
| esito raccontato | buy a TP **la mattina dopo alle ~8** | `[dichiarato]` |

**9 numeri su 9 tornano.**

> 🟢 **Questo e' il punto di forza reale del modulo, e va detto con la stessa
> forza con cui si dicono i difetti: l'aritmetica operativa e' esatta.** Negli
> altri cinque moduli i conti degli esempi si rompevano. Qui no.
> **Cio' che non torna non e' il calcolo: e' la PROVA** (§8).

### T3 — Casi limite che il corso NON copre (da decidere in fase di codice)

| caso | frequenza attesa | il corso | proposta |
|---|---|---|---|
| prezzo gia' oltre il livello all'istante d'azione | **quasi zero** — all'apertura della candela d'azione il prezzo e' per costruzione dentro il range delle due candele precedenti | non lo tratta | piazza comunque; se il broker rifiuta, salta la gamba e **loggala** |
| notizia rinviata/annullata | rara | citata solo per il 2009 `[T]` (_"le date venivano modificate all'ultimo"_) | nessun evento nel CSV → **nessun ordine** |
| candela M5 mancante (dati bucati) | rara | non lo tratta | **salta l'evento**, non "usa la precedente" |
| doppia esecuzione (buy poi sell) | _"raro ma e' successo"_ `[T]` | **ammessa e finanziata** (§3.3) | tenerla: e' la ragione della size su 50 pip |
| spread anomalo al momento del piazzamento | frequente in conferenza stampa | ❌ **non trattato** | guardia `InpMaxSpread` **attiva** (oggi e' 0 = spenta) |

---

## 8. 🔬 IL BACKTEST DEL CORSO — audit numero per numero

### 8.1 Cosa viene dichiarato

| serie | periodo | pips | risultato in % | DD | N |
|---|---|---:|---:|---:|---:|
| **ECB** (lez. 7) | 01/01/2009 → 2024 ("15 anni e mezzo") | _"quasi 3000"_ | 1.000 € → **~4.700 €**, _"oltre il 340%"_ | **15%** | ❌ **mai** |
| **FOMC** (lez. 9) | 2011 → 2024 ("14 anni") | _"piu' di 1500"_ | _"oltre il 200%"_ | _"bassissimo"_ (nessun numero) | ❌ **mai** |
| **combinata** (lez. 10) | 2009 → 2024 | — | **+1000%**, media _"oltre il 20%/anno"_, un solo anno negativo (**−2%**) | ❌ **mai** | ❌ **mai** |

Tutti `[dichiarato, NON verificato]`. Rischio simulato: 3% per operazione.

### 8.2 🧮 L'aritmetica: cosa regge e cosa no

**(a) Il win rate implicito e' altissimo.** Con soli esiti +50 / −25:
`media = 75p − 25`. Dai suoi numeri:

| serie | pips/operazione implicito | **win rate necessario** |
|---|---:|---:|
| ECB (3000 pips / 124 op. implicite) | **24,2** | **65,6%** |
| FOMC (1500 / 112 op. implicite) | **13,4** | **51,2%** |

🔴 **Un 65% di operazioni vincenti con rapporto 1:2 e' un numero
straordinario** — e non e' mai pronunciato. **Il numero che decide se la
strategia guadagna non viene mai detto: e' lo stesso identico difetto degli
altri cinque moduli**, solo spostato dall'uscita alla prova.

**(b) N e' inventato dal contesto, e probabilmente sbagliato.** Il relatore
lascia intendere 8 operazioni/anno **fin dal 2009** per l'ECB e **fin dal 2011**
per il FOMC. `[ANCORA ESTERNA — conoscenza generale, NON dalla trascrizione, da
verificare]`: le conferenze BCE erano **mensili fino al 2014** (≈12/anno) e le
conferenze FOMC erano **4/anno fino al 2018**. Se e' cosi', il conteggio vero e'
**~147 ECB** (non 124) e **~74 FOMC** (non 112) → i pips per operazione, e
quindi il win rate, **cambiano in entrambe le direzioni**. **Senza N e senza la
lista dei trade, nessuno di questi numeri e' controllabile.**

**(c) I due file non sono prodotti con la stessa macchina.** Applicando la sua
stessa taratura (3% su 50 pip = 0,06% di equity per pip, capitalizzato):

| serie | % attesa dai pips dichiarati | % dichiarata | scarto |
|---|---:|---:|---|
| ECB | ≈ **+480%** | +340/370% | dichiara **MENO** del dovuto |
| FOMC | ≈ **+140%** | oltre +200% | dichiara **PIU'** del dovuto |
| combinata | ≈ **+1.290%** | +1.000% | meno |

🔴 **Due file dello stesso autore, sulla stessa strategia, con due
comportamenti opposti rispetto alla stessa formula.** Non e' la prova di un
imbroglio: e' la prova che **il metodo di calcolo non e' dichiarato** e quindi
**nessuna delle tre percentuali e' riproducibile**.

**(d) "+1000% con media del 20% annuo" non e' contraddittorio ma va letto
bene:** 11x in 15,5 anni = **16,5% composto**. Il "20%" e' la **media
aritmetica degli anni**, che e' sempre >= quella composta. Il numero da
ricordare e' **16,5%**, non 20%.

**(e) "Un solo anno negativo su 15" e' statisticamente COERENTE** col win rate
che lui implica (con 16 operazioni/anno al 60% di successo, la probabilita' che
un anno chiuda in rosso e' ~2%, cioe' ~0,3 anni su 15). **Coerente non vuol dire
vero: vuol dire che non si contraddice.**

### 8.3 🔴 IL COLPO GROSSO: lo strumento insegnato NON PUO' produrre quel backtest

Due frasi dello stesso relatore, a tre lezioni di distanza:

> `[T]` lez. 3: _"noi possiamo impostare una data passata sulla piattaforma
> MetaTrader 4. **Non e' da questo punto di vista la piattaforma piu' efficace**
> per andare ad analizzare il passato … **senza andare troppo indietro nel
> passato**"_
>
> `[T]` lez. 6: _"noi possiamo andare indietro di **2-3 mesi** sulla
> piattaforma? Si, certamente"_

E la strategia ha bisogno di **massimo e minimo di due candele da 5 minuti**.

🔴 **Lo strumento che insegna arriva a 2-3 mesi di storico M5. Il backtest che
mostra parte dal 1° gennaio 2009.** La serie di pips 2009-2013 **non puo'**
essere stata prodotta con la procedura mostrata nel corso. Il relatore dichiara
`[T]` che _"dal 2013 e' applicazione concreta sul mercato"_ — cioe' **operativita'
reale**, che pero' arriva senza estratto conto, senza broker, senza date dei
singoli trade.

⚖️ **Cosa NON sto dicendo:** che i numeri siano falsi. Sto dicendo che
**l'origine del dato piu' vecchio e' incompatibile con lo strumento insegnato**,
e che questo, sommato all'assenza di N, di DD combinato e di lista operazioni,
rende il backtest **una testimonianza, non una misura**.

### 8.4 Le contraddizioni interne minori

1. `[T-dubbio]` lez. 7: _"l'ultima [operazione] che e' la prossima che ci sara',
   il **6 maggio 2024**"_ — ma la lez. 5 dice che la prossima ECB e' il **6
   giugno 2024**, e **il nostro CSV non ha nessuna ECB Press Conference in maggio
   2024** (2024.04.11 → 2024.06.06). **Il dato di casa arbitra: e' "6 giugno".**
   Errore di parlato o di trascrizione.
2. `[T-dubbio]` lez. 6: _"soprattutto **Mario**, le prime volte che ci lavori"_ —
   parola priva di senso nel contesto: quasi certamente un artefatto dello
   speech-to-text.
3. **Scadenze asimmetriche mai spiegate**: ECB **+3h30**, FOMC **+75 minuti**.
   Nessuna riga giustifica il fattore ~3. → **parametro da spazzolare**, non
   costante di natura.
4. `[?]` **La scadenza ECB e' un ORARIO FISSO (18:15) o un DELTA (+3h30)?** Fino
   a meta' 2022 la notizia era alle 14:30: la scadenza era 18:15 lo stesso
   (= +3h45) o 18:00? **Non e' dicibile dalla trascrizione.**

---

## 9. 🆚 CONFRONTO COL NOSTRO `ABTG_PostNews.mq5` (458 righe, in flotta dal 26/07)

> 🚨 **Questo modulo e' l'unico dei sei in cui l'EA ESISTEVA PRIMA della
> trascrizione.** Scritto il 26/07/2026 da una sessione precedente, gira in
> forward su EURUSD ed EURJPY (`FLOTTA_ATTIVA.md`, magic 771201/771202), e la
> sua intestazione attribuisce la strategia a **"Christian Bertacchi"** —
> **attribuzione che in repo non ha nessun documento a sostegno** (§12).

### 9.1 Riga per riga: corso ↔ EA ↔ fonte live

| parametro | 📘 corso | 🎤 live "De Marco" 29/07 *(sintesi in repo, trascrizione grezza ASSENTE)* | 🤖 `ABTG_PostNews` | esito |
|---|---|---|---|---|
| range 2 candele M5 | ✅ | ✅ | ✅ `iHigh/iLow[1],[2]` | 🟢 **converge** |
| BUY offset | **+3 pip** | +3 | **3.0** | 🟢 converge |
| SELL offset | **−2 pip** (2 volte) | **−3** | **3.0** | 🟠 **l'EA segue il live, non il corso** |
| TP / SL | **50 / 25** | 50 / 25 | **50 / 25** | 🟢 converge |
| size su SL 50 (doppio stop) | ✅ | n.d. | ✅ `InpRiskRefSLpips=50` | 🟢 |
| rischio | **3%** | n.d. | **3.0** | 🟢 (ma §6.2) |
| **OCO** | 🔴 **NO, esplicito** | n.d. | 🔴 **`true`** | 🔴 **OPPOSTO** |
| **chiusura posizione a scadenza** | 🔴 **NO, esplicito ×2** | ✅ _"tenere fino alle 21:45"_ | 🔴 **`true`** | 🔴 **OPPOSTO al corso** |
| trailing +25 → SL 15 | solo ECB, **opzionale** | BE dopo ~20 pip | ✅ ECB on / FOMC off | 🟢 fedele |
| chiusura venerdi 22:50 IT | ✅ | n.d. | ✅ 21:50 server | 🟢 |
| strumenti | EURJPY / EURUSD | EURUSD (+USDJPY) | EURJPY / EURUSD | 🟢 |
| **tradare l'ECB** | ✅ meta' del modulo | ❌ _"non la trado"_ | preset ECB attivo | 🟠 **le fonti si smentiscono** |
| orario d'azione | **relativo alla notizia** | relativo | 🔴 **fisso a orologio** | 🔴 **divergenza strutturale** (§5.1) |

### 9.2 🚨 LA SCOPERTA CHE VALE PIU' DI TUTTA LA TABELLA

**Il verdetto _"PostNews: nessun edge nemmeno in screening"_ (weekend del 07/08,
`REFERTO_WEEKEND_FASE0.md` §2 e `CLASSIFICA_WEEKEND.md`) NON E' UN VERDETTO:
i quattro file di risultato contengono ZERO TRADE.**

```
backtest_pipeline/risultati_prove/ABTG_PostNews/ABTG_PostNews_EURUSD_IS_ohlc.csv
Pass,Profit,Expected Payoff,Profit Factor,...,Trades,InpMagic,...
0,0.00,0.00000,0.00000,...,0,771201,...
1,0.00,0.00000,0.00000,...,0,771202,...
```

**Tutte e quattro le finestre (EURUSD/EURJPY × IS/OOS): `Profit 0.00`,
`Trades 0`.**

🔎 **Causa certa e banale:** `InpRestrictToNews=true` + il file eventi
`mql5/Files/abtg_news.csv` contiene **17 righe, tutte del 2026-2027** (e
`data/abtg_news.csv` e' **vuoto, 0 byte**). Nel periodo di backtest **non
esisteva un solo evento** → nessun ordine piazzato → il test ha misurato **il
nulla**, e il nulla e' finito in classifica come "niente edge".

> 🟢 **Conseguenza operativa, la piu' azionabile della serata:**
> **la Post News non e' mai stata misurata.** Il verdetto negativo va
> **ritirato** (non ribaltato: ritirato, perche' non esiste), e il round va
> rifatto **con il calendario vero** — che adesso sappiamo di avere (§4.3, 70
> eventi) e che l'EA sa gia' leggere.

### 9.3 Le tre modifiche minime perche' l'EA sia FEDELE al corso

_(proposte, non eseguite — nessun file EA e' stato toccato)_

1. `InpUseOCO = false` → il corso finanzia esplicitamente il doppio stop (§3.4).
2. `InpCloseAtExpiry = false` → il corso tiene la posizione oltre la scadenza
   (§3.5); l'esempio FOMC incassa **la mattina dopo**.
3. **orario d'azione derivato dall'evento** invece che fisso (§5.2).

E i tre diventano **le tre gambe di uno sweep**, perche' su ognuno **le due
fonti umane si contraddicono**: e' il caso in cui si misura invece di scegliere.

---
