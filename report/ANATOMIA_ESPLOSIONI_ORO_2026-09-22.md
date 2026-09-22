# 💥 ANATOMIA DELLE ESPLOSIONI DELL'ORO — 4,88 MILIONI DI BARRE M1, 154.787 FINESTRE

**Domanda di Claudio (22/09/2026, ore 16:30), testuale:**
> _"Vorrei che un agente analizzasse questi screen dove l'oro corre e fa questi
> punti, che cosa c'e' in comune, xche avviene, se c'e' un orario comune durante
> il giorno, se c'e' ATR simile, volumi simili che possano ricondurre a una
> esplosione di prezzo cosi'. Come si puo' misurare, dobbiamo misurare anche il
> lato short."_

🔒 **Niente lanciato in MT5. Nessun EA toccato. Nessun preset, nessuna taglia,
nessun file prova. Questo giro e' CONOSCENZA, non una sedia.**

---

# 🎯 LE QUATTRO RIGHE CHE CONTANO

> ### 1️⃣ **L'ORA C'E', ED E' DOPPIA.** In ora di New York: **08:30 ET** (i dati
> macro) e **09:30 ET** (l'apertura del cash azionario USA). Alle 09:30 ET l'oro
> esplode **4,13 volte** piu' che nell'ora media della giornata.
>
> ### 2️⃣ **E UNA DELLE DUE NON E' LE NOTIZIE.** Togliendo le finestre di
> calendario, **08:30 ET CROLLA da 5,32x a 2,75x** (era notizia, per meta'), ma
> **09:30 ET SALE da 4,13x a 5,07x** e diventa **la fascia piu' esplosiva di
> tutto il giorno**. Nei calendari di casa alle
> 09:30 ET ci sono **8 eventi su 1.292**, contro i **735** delle 08:30 ET: li'
> non c'e' un dato, c'e' **l'apertura di Wall Street**.
>
> ### 3️⃣ **MA NON E' SFRUTTABILE, E IL MOTIVO NON E' IL COSTO.** Dall'istante in
> cui l'esplosione e' **riconoscibile**, la continuazione mediana e' **NEGATIVA**
> a tutti gli orizzonti (−1,14 $ a +15 min, −0,93 $ a +60 min, a oro di oggi), e
> va a favore solo **45-48 volte su 100**. 🟢 La bella notizia: la frontiera del
> costo **PASSA** (MAE mediano 9,54 $ = **47,6x** il costo pieno, contro il
> pavimento di lavoro a 40x). **Non costa troppo: non va da nessuna parte.**
>
> ### 4️⃣ **E QUELLO CHE CLAUDIO HA VISTO E' IL 99,5° PERCENTILE.** Una corsa da
> **35 $** in mezz'ora a oro 4.330 e' **0,81% del prezzo**: succede **775 volte
> su 154.787 finestre = 4,5 volte al mese**. Da 40 $: **3,1 volte al mese**.
> 🔴 **Non e' una cosa di tutti i giorni: e' una cosa di tutte le settimane.**

---

# 0. 🚨 LA TRAPPOLA DEL MANDATO, E PERCHE' LE TRE SCHERMATE NON SONO IL DATO

Le tre schermate sono state scelte **PERCHE' sono esplosive**. E' **selezione
sull'esito**: qualunque cosa abbiano "in comune" la si trova **per costruzione**,
e la si trova anche nei giorni in cui non e' successo niente.

👉 Quindi la domanda misurata **non e'** *"cosa hanno in comune questi tre"*, ma:
> ## **"che cosa DISTINGUE le finestre esplosive da TUTTE le altre finestre?"**

E si risponde **solo** col denominatore in mano. Le tre schermate entrano **alla
fine** (§8), come **percentile**, non come dato di partenza.

🔴 **Dalle immagini non e' stato letto NESSUN numero.** Non sono dati: sono
l'ipotesi.

---

# 1. 📏 LA DEFINIZIONE DI ESPLOSIONE — **scritta PRIMA di guardare i numeri**

Congelata nell'intestazione dello strumento
(`backtest_pipeline/anatomia_esplosioni_oro.py`, righe 32-77) **prima** della
prima corsa, e **mai cambiata dopo**.

| pezzo | scelta | **perche'** |
|---|---|---|
| **griglia** | blocchi da 15' allineati all'orologio (:00 :15 :30 :45), validi se hanno ≥12 minuti su 15 | il denominatore dev'essere un **conteggio esatto**, non una stima |
| **finestra N** | **30 minuti** = due blocchi, **allineati a :00 e :30, NON sovrapposti** | le schermate mostrano corse *"in meno di un'ora"*; 30' e' la finestra piu' stretta che le contiene tutte e tre **e** si assegna a un'ora senza ambiguita'. ⚠️ Niente sovrapposizione = niente doppio conteggio |
| **movimento** | `close(ultimo minuto) − open(primo minuto)` | nessun prezzo migliore, mai |
| **metro** | **ATR14 GIORNALIERO** (media dei true range dei **14 giorni precedenti**, gap incluso, noto alla chiusura del giorno prima) | 🔴 **nessuna barra futura entra nel metro** |
| **soglia** | **\|movimento\| ≥ 0,40 × ATR14** | *"in mezz'ora fa quasi meta' di quello che un giorno intero fa normalmente"*. 🔴 **k=0,40 NON viene dalle schermate**: e' un principio leggibile e indipendente dall'esito |
| **lato** | **RIALZO e RIBASSO contati SEPARATAMENTE** | regola di casa del 25/08 |
| **istante di riconoscimento** | la **FINE** della finestra | un'esplosione **non e' riconoscibile prima**: il suo inizio lo si sa solo col senno di poi. Misurare da li' sarebbe barare |

### 🧮 Perche' il metro e' l'ATR **giornaliero** e non *"l'ATR della stessa ora"*
Il mandato suggeriva *"k × ATR(14) della stessa ora"*. **Non l'ho fatto come
misura principale, e il motivo e' che quella normalizzazione CANCELLA PER
COSTRUZIONE l'effetto che stiamo cercando**: un'ora sempre agitata si alzerebbe
da sola la propria asticella, e la tavola oraria uscirebbe piatta per
costruzione. L'ATR **giornaliero** normalizza le **epoche** (oro a 600 $ contro
oro a 4.300 $) e lascia intatta la stagionalita' oraria, che e' la domanda.

🧪 **Ma quella versione e' stata calcolata lo stesso, come CONTRO-ESEMPIO** — ed
e' la sezione §9, dove **smonta meta' della lettura ingenua**. Non l'ho nascosta:
l'ho messa contro di me.

### ✅ E la sensibilita' e' dichiarata, non scelta dopo
| variante | esito sulla classifica oraria |
|---|---|
| **k = 0,25** (4.256 esplosioni) | TOP-5 ore: `14 13 12 15 16` — **4 su 5 in comune** con la principale |
| **k = 0,40** (1.147, principale) | TOP-5 ore: `14 13 12 15 18` |
| **k = 0,60** (326 esplosioni) | TOP-5 ore: `13 12 14 15 18` — **5 su 5 in comune** |
| **N = 60'** invece di 30' (1.608 esplosioni) | **5 su 5 in comune** |

🟢 **La classifica oraria non dipende dalla soglia.** Se dipendesse, il numero
non varrebbe niente.

---

# 2. 🗄️ I DATI, E L'OROLOGIO COLLAUDATO (non assunto)

| | |
|---|---:|
| **barre M1 lette** | **4.884.366** |
| finestra | **2006-03 → 2020-05** |
| giornate | **4.467** (di cui **3.641** con metro ATR valido) |
| **finestre N=30' valide** | **154.787** (N=60': 75.123) |
| righe scartate / OHLC incoerenti | **0 / 0** |
| fonte | `FutureSharks/financial-data` (GPL-3.0), feed **Oanda XAU_USD**, 171 file mensili, 261,7 MB |
| costo di lettura | **~4 minuti a corsa**, dati scaricati in **75 secondi** |

### 🕐 COLLAUDO DELL'OROLOGIO — **PASSATO**, e se fallisce lo strumento si ferma (`exit 2`)
Metodo: il minuto del giorno piu' mosso, **mediana** di `|close−open|`, mesi
invernali (12-1-2) contro estivi (6-7-8), su tutto il campione.

| stagione | 1° | 2° | 3° |
|---|---|---|---|
| **inverno** | **13:20** (0,4455 · n=876) | 15:00 (0,4000) | 13:30 (0,4000) |
| **estate** | **12:20** (0,4800 · n=918) | 12:30 (0,4400) | 14:00 (0,4100) |

**Spostamento −60 minuti → il file e' in UTC.** ✅ E si legge il perche': il
picco e' il **dato USA delle 8:30 di New York** e il secondo e' il **fixing
LBMA delle 15:00 di Londra** — **due ancore indipendenti, stesso verdetto**.

📌 **Nota di metodo**: la prima stesura usava la **media** e il collaudo e'
**FALLITO** su un minuto della riapertura domenicale gonfiato da un solo gap.
E' stato riparato con la **mediana** (robustezza), **non** escludendo a mano i
minuti scomodi. 🟢 **Il cancello ha funzionato: ha fermato una misura sbagliata
prima che producesse una tabella pulita e falsa.**

---

# 3. 🕐 LA TAVOLA ORARIA IN **UTC**, coi denominatori, **i due lati separati**

**Tasso medio su tutto il campione: 0,741%** (1.147 esplosioni su 154.787).

| ora UTC | finestre | RIALZO | RIBASSO | TOT | **x medio** | range med. | tick vol. med. |
|---:|---:|---|---|---:|---:|---:|---:|
| 00 | 6.900 | 7 (0,10%) | 10 (0,14%) | 17 | 0,33x | 1,670 | 748 |
| 01 | 6.965 | 10 (0,14%) | 13 (0,19%) | 23 | 0,45x | 1,721 | 909 |
| 02 | 6.723 | 5 (0,07%) | 1 (0,01%) | 6 | **0,12x** | 1,280 | 681 |
| 03 | 6.370 | 5 (0,08%) | 1 (0,02%) | 6 | **0,13x** | 1,158 | 566 |
| 04 | 6.297 | 2 (0,03%) | 6 (0,10%) | 8 | 0,17x | 1,144 | 535 |
| 05 | 6.739 | 1 (0,01%) | 12 (0,18%) | 13 | 0,26x | 1,327 | 636 |
| 06 | 7.010 | 6 (0,09%) | 12 (0,17%) | 18 | 0,35x | 1,699 | 889 |
| 07 | 7.112 | 6 (0,08%) | 17 (0,24%) | 23 | 0,44x | 1,992 | 1.066 |
| 08 | 7.132 | 16 (0,22%) | 8 (0,11%) | 24 | 0,45x | 1,919 | 1.054 |
| 09 | 7.085 | 8 (0,11%) | 9 (0,13%) | 17 | 0,32x | 1,790 | 980 |
| 10 | 7.091 | 8 (0,11%) | 7 (0,10%) | 15 | 0,29x | 1,742 | 919 |
| 11 | 7.111 | 14 (0,20%) | 16 (0,23%) | 30 | 0,57x | 1,950 | 985 |
| **12** | 7.152 | 78 (1,09%) | 82 (1,15%) | **160** | 🔥 **3,02x** | 2,960 | 1.622 |
| **13** | 7.261 | 81 (1,12%) | 100 (1,38%) | **181** | 🔥 **3,36x** | 3,481 | 2.200 |
| **14** | 7.252 | 77 (1,06%) | 112 (1,54%) | **189** | 🔥 **3,52x** | 3,468 | 2.263 |
| **15** | 7.248 | 66 (0,91%) | 81 (1,12%) | **147** | 🔥 **2,74x** | 2,999 | 1.912 |
| 16 | 7.222 | 25 (0,35%) | 45 (0,62%) | 70 | 1,31x | 2,450 | 1.411 |
| 17 | 7.031 | 30 (0,43%) | 27 (0,38%) | 57 | 1,09x | 2,206 | 1.226 |
| 18 | 6.828 | 40 (0,59%) | 28 (0,41%) | 68 | 1,34x | 1,930 | 1.072 |
| 19 | 6.706 | 18 (0,27%) | 32 (0,48%) | 50 | 1,01x | 1,700 | 862 |
| 20 | 5.890 | 1 (0,02%) | 11 (0,19%) | 12 | 0,27x | 1,400 | 648 |
| 21 | 2.101 | 1 (0,05%) | 1 (0,05%) | 2 | 0,13x | 1,183 | 391 |
| 22 | 2.941 | 3 (0,10%) | 2 (0,07%) | 5 | 0,23x | 1,248 | 532 |
| 23 | 4.620 | 2 (0,04%) | 4 (0,09%) | 6 | 0,18x | 1,400 | 533 |

⚠️ **Il "volume" e' TICK VOLUME** (conteggio degli aggiornamenti di prezzo),
**non volume scambiato**: sull'oro spot/CFD il volume vero non esiste nel feed.
Etichettato cosi' **ogni volta** che compare in questo referto.

⚠️ Le ore **21, 22, 23** hanno meno finestre (2.101-4.620 contro ~7.000): e' la
**pausa di manutenzione CME** e la chiusura del venerdi'. Il **tasso** resta
leggibile perche' e' una frazione, ma il conteggio grezzo no — ed e' esattamente
perche' **il denominatore e' stampato in colonna 2**.

> ## 🔴 **La forbice fra l'ora piu' esplosiva e la piu' quieta e' di 29,2 VOLTE** (14 UTC contro 02 UTC). Non e' una sfumatura: e' la struttura della giornata dell'oro.

---

# 4. 🗽 LA TAVOLA IN **ORA DI NEW YORK** — la sola che separa gli appuntamenti

🔴 **In UTC le fasce si MESCOLANO fra estate e inverno**: le 08:30 di New York
sono le 13:30 UTC d'inverno e le 12:30 d'estate. Una tavola UTC impasta il dato
macro con l'apertura del cash, e **non puo' rispondere alla domanda "e' l'ora o
e' la notizia"**. Questa si'.

**Tasso medio: 0,741%** (tutte) · **0,625%** (2010-2020, escluse le finestre di
notizia). Le due colonne `x` sono ciascuna rapportata **al proprio** tasso medio.

| fascia ET | finestre | RIALZO | RIBASSO | tasso | **x medio** | **x SENZA news** | che cosa c'e' li' |
|---|---:|---:|---:|---:|---:|---:|---|
| 07:30 | 3.564 | 7 | 7 | 0,393% | 0,53x | 0,54x | |
| **08:00** | 3.529 | 36 | 45 | 2,295% | **3,10x** | **3,57x** | |
| **08:30** | 3.630 | 70 | 73 | 3,939% | 🥇 **5,32x** | 🔻 **2,75x** | **DATI MACRO USA** |
| 09:00 | 3.631 | 37 | 29 | 1,818% | 2,45x | 2,38x | |
| **09:30** | 3.631 | **39** | **72** | 3,057% | **4,13x** | 🏆 **5,07x** | **APERTURA CASH USA** |
| **10:00** | 3.624 | 56 | 63 | 3,284% | **4,43x** | **4,87x** | **ISM / FIDUCIA** |
| 10:30 | 3.626 | 31 | 46 | 2,124% | 2,87x | 3,12x | |
| 11:00 | 3.626 | 27 | 36 | 1,737% | 2,34x | 2,58x | |
| 11:30 | 3.618 | 19 | 32 | 1,410% | 1,90x | 2,10x | |
| 13:00 | 3.545 | 16 | 25 | 1,157% | 1,56x | 1,60x | |
| 13:30 | 3.409 | 4 | 4 | 0,235% | 0,32x | 0,31x | |
| **14:00** | 3.425 | 27 | 25 | 1,518% | **2,05x** | **2,10x** | **FOMC** |
| 14:30 | 3.365 | 18 | 12 | 0,892% | 1,20x | 1,16x | |
| 16:00 | 2.786 | 0 | 2 | 0,072% | 0,10x | 0,15x | |
| **17:00 / 17:30** | — | — | — | — | — | — | 🔧 **assenti: pausa CME** |
| 22:30 | 3.285 | 1 | 0 | 0,030% | **0,04x** | 0,06x | la piu' morta del giorno |

*(tavola completa a 46 fasce nel referto grezzo)*

### ✅ E LA CONVERSIONE A ORA DI NEW YORK E' VERIFICATA CONTRO UN FATTO CHE NON HO USATO PER COSTRUIRLA
Contro-esempio costruito apposta: la **pausa di manutenzione CME sull'oro e'
17:00-18:00 ET, tutto l'anno**. Se la conversione DST fosse sbagliata, il buco
cadrebbe altrove. Misurato su **690.075 barre** (2012 + 2017):

| ora di New York | barre M1 | % del totale |
|---|---:|---:|
| ogni ora, da 00 a 16 e da 18 a 23 | 26.989 – 30.880 | **3,91% – 4,47%** |
| 🔧 **17 ET** | **2.160** | 🎯 **0,31%** |

E in **UTC** lo stesso buco **si sposta**: **21 UTC d'estate** (503 barre) e
**22 UTC d'inverno** (345 barre). 🟢 **Il buco cade esattamente dove la regola
DST americana dice che deve cadere, e si muove esattamente di un'ora.** La
conversione e' un **fatto verificato**, non un'assunzione.

---

# 5. 📰 IL CONFONDENTE UCCISO PER PRIMO: **LE NOTIZIE**

**Calendario usato** (unione di tre file di casa, tutti in UTC):
`abtg_news_postnews_2010_2025_UTC.csv` + `abtg_news_usd1330_2010_2023_UTC.csv`
+ `abtg_news_ism1500_2010_2023_UTC.csv` → **1.292 eventi distinti ad alto
impatto, 2010-2025** (NFP, disoccupazione, conferenze BCE e FOMC, rilasci USA
delle 13:30 UTC, ISM e fiducia delle 15:00 UTC).
**Finestra di esclusione: da −5 a +30 minuti** attorno a ogni evento.
🔴 Il confronto e' ristretto al **2010-2020**, dove il calendario esiste: negli
anni scoperti *"non c'e' notizia"* vorrebbe dire solo *"non la sappiamo"*, e
sarebbe un numero falso.

### 📍 E prima di tutto: **DOVE STANNO** quei 1.292 eventi, in ora di New York
Contato traducendo **ogni** evento del calendario con la stessa regola DST
verificata in §4 — cosi' la frase *"alle 09:30 ET non esce niente"* diventa un
conteggio e non un'impressione:

| fascia ET | eventi ad alto impatto in calendario |
|---|---:|
| **08:30 ET** | 🔴 **735** |
| **10:00 ET** | 🔴 **459** |
| 14:30 ET | 72 |
| 14:00 ET | 8 |
| **09:30 ET** | 🟢 **8** |
| **08:00 ET** | 🟢 **0** |
| tutte le altre | ≤ 6 ciascuna |

### L'effetto dell'esclusione, ora per ora (UTC, 2010-2020)
| ora UTC | tasso CON news | tasso SENZA news | variazione | finestre escluse |
|---:|---:|---:|---:|---:|
| 00-11 | invariate | invariate | **0,000 pt** | **0** |
| **12** | 2,286% | 1,330% | 🔻 **−0,956 pt** | 675 |
| **13** | 2,583% | 2,158% | −0,425 pt | 940 |
| **14** | 2,530% | 2,415% | −0,115 pt | 782 |
| **15** | 1,911% | 1,796% | −0,115 pt | 270 |
| 18 | 1,058% | 0,734% | −0,324 pt | 62 |
| 19 | 0,837% | 0,704% | −0,133 pt | 47 |

### 🔑 E il verdetto, letto sulle fasce di New York (che e' dove si legge)
| fascia ET | x medio CON news | x medio SENZA news | lettura |
|---|---:|---:|---|
| **08:30 ET** (dati macro) | **5,32x** | **2,75x** | 🔻 **PERDE META' DELL'ECCESSO: era notizia** |
| **09:30 ET** (apertura cash) | 4,13x | 🏆 **5,07x** | 🟢 **SALE. Non e' notizia** |
| **10:00 ET** (ISM/fiducia) | 4,43x | **4,87x** | 🟢 sopravvive |
| 14:00 ET (FOMC) | 2,05x | 2,10x | invariata |

> ## 🟢 **LA RISPOSTA E' "TUTTE E DUE", E SI SEPARANO PULITE.**
> **Alle 08:30 ET l'oro esplode PERCHE' ESCONO I DATI** (735 eventi li' dentro)
> — tolta la notizia, **meta' dell'eccesso se ne va con lei: 5,32x → 2,75x**.
> **Alle 09:30 ET no**: li' il calendario ha **8 eventi in sedici anni**, e
> togliendo le notizie la fascia **sale a 5,07x e diventa la piu' esplosiva
> della giornata.** Quello che apre alle 09:30 di New York non e' un dato:
> **e' Wall Street.**

### 🔎 E c'e' un TERZO posto che sopravvive, ed e' quello che non mi aspettavo
La fascia **08:00-08:30 ET** ha **ZERO eventi in calendario** eppure fa
**3,10x**, e **senza notizie SALE a 3,57x**. ⚠️ Attenzione a come e' costruito
quel numero: la finestra di esclusione parte a **−5 minuti** dall'evento delle
08:30, quindi **ogni** finestra 08:00-08:30 di un giorno con dato macro **e'
esclusa**. 👉 Quindi il **3,57x e' misurato sui giorni SENZA dato**: la
mezz'ora prima dell'apertura dei future USA si muove tanto **anche quando non
c'e' niente da aspettare**. 🔴 **Questo e' `NON ANCORA SPIEGATO`**, e lo scrivo
invece di inventargli una causa.

### 🔴 IL LIMITE DI QUESTA PROVA, detto per nome
Il calendario di casa **non copre tutto**: mancano **sussidi settimanali** (ogni
giovedi' alle 13:30 UTC!), **PIL**, **PCE**, **Michigan**, **JOLTS**, **PPI
completo**, i **discorsi Fed**. Quindi *"sopravvive senza news"* alla fascia
**08:30 ET** e' un risultato **debole**: li' dentro puo' esserci notizia non
elencata. 🟢 **Ma sulla fascia 09:30 ET l'obiezione non morde**, perche' **alle
09:30 di New York non esce nessun dato macro USA, in nessun calendario** — e'
l'orario di apertura di una **borsa**, non di un ufficio statistico.

---

# 6. 📊 ATR E VOLUME: **la domanda di Claudio, e la risposta e' NO due volte**

## 6.1 🔴 **L'ATR NON E' UNA FIRMA. Anzi: le esplosioni NON capitano nei giorni agitati.**

| grandezza | nelle **ESPLOSIVE** | in **TUTTE** | rapporto |
|---|---:|---:|---:|
| **ATR14 giornaliero del giorno ($)** | **16,28** | **16,99** | 🔴 **0,96x** |
| **ATR14 in % del prezzo** | **1,3173%** | **1,4207%** | 🔴 **0,93x** |
| range della finestra ($) | 11,04 | 1,87 | 5,89x |
| tick volume della finestra | 5.080 | 1.026 | 4,95x |

> ### 🔴 **Il giorno in cui l'oro esplode e' un giorno NORMALE.** L'ATR del giorno e' **il 4% SOTTO** la mediana, non sopra. **Non esiste un "ATR simile" che prepari l'esplosione**: guardare l'ATR del giorno prima per sapere se oggi ci sara' una corsa **non serve a niente**, ed e' misurato su 1.147 casi.

🟢 Il range della finestra (5,89x) e il tick volume (4,95x) sono **enormi** —
ma sono **la stessa cosa che stiamo misurando**: sono il **termometro dentro la
febbre**, non la causa. Dire *"le esplosioni hanno un range grande"* e' una
tautologia, non una scoperta.

## 6.2 🔴 **E IL TICK VOLUME NON ANTICIPA: e' un termometro, non una spia**

Misura fatta sulla finestra **PRECEDENTE** (i 30 minuti *prima*), rapportata
alla mediana **della sua ora**:

| gruppo | n | Q1 | **MEDIANA** | Q3 |
|---|---:|---:|---:|---:|
| **PRIMA di un'esplosione** | 1.138 | 0,61 | **1,44** | 3,85 |
| **tutte le finestre** | 148.516 | 0,45 | **1,03** | 2,69 |

**1,40x.** Sembra qualcosa. **Non lo e'**, e la prova e' la domanda che decide:
*un filtro a volume servirebbe?*

| soglia sul volume precedente | finestre che passano | esplosioni catturate | P(esplosione \| filtro) | **guadagno** |
|---|---:|---:|---:|---:|
| **(nessuna)** | 148.516 | 1.138 | **0,766%** | 1,00x |
| ≥ 1,00x | 75.642 (51%) | 695 | 0,919% | 1,20x |
| ≥ 1,44x | 60.885 (41%) | 569 | 0,935% | 1,22x |
| ≥ 2,00x | 48.038 (32%) | 475 | 0,989% | 1,29x |
| ≥ 3,00x | 33.380 (22%) | 349 | 1,046% | 1,36x |
| ≥ 5,00x | 17.776 (12%) | 224 | 1,260% | **1,64x** |

> ### 🔴 Anche con la soglia **piu' feroce** (volume 5 volte la norma dell'ora) la probabilita' di esplosione passa da **0,77% a 1,26%**: si butta via **l'88% della giornata** per comprare **1,64x**. E il **Q1 = 0,61** dice la cosa peggiore: **un'esplosione su quattro e' preceduta da un volume SOTTO la norma.**
> **Il volume sale INSIEME al prezzo, non prima.**

---

# 7. 💰 E' SFRUTTABILE? — dall'istante di **RICONOSCIMENTO**, al netto del costo

**Riferimento**: il `close` alla **FINE** della finestra. Non il suo inizio:
quello lo si sa solo col senno di poi.
**Costo applicato**: **0,2003 $/oncia** a giro completo (spread 0,1600 +
commissione 0,0403), **MISURATO** il 10/09/2026 in
`report/ORO_1530_CANCELLO_COSTO_2026-09-10.md`, letto a oro ~4.400 $.
🔴 Il campione storico e' a oro 600-2.000 $: applicare 0,2003 $ **piatti** ai
dollari del 2010 sarebbe un pedaggio finto. Quindi il costo e' applicato in
**relativo** (**0,004552% del prezzo**) e i risultati sono riportati in
**dollari di OGGI** (oro 4.330 $).

### 7.1 Tutto il campione — **1.147 esplosioni**, contro **1.139 controlli appaiati** (stessa ORA, stesso ANNO, non esplosivi)

| | orizzonte | n | continuaz. mediana | **>0** | lorda $ oggi | **NETTA $ oggi** | MFE med | MAE med |
|---|---|---:|---:|---:|---:|---:|---:|---:|
| **ESPLOSIONI** | +15 min | 1.141 | −0,02634% | **45,31%** | −1,141 | 🔴 **−1,338** | 5,797 | 5,892 |
| | +30 min | 1.138 | −0,01448% | **47,72%** | −0,627 | 🔴 **−0,824** | 7,773 | 7,514 |
| | +60 min | 1.131 | −0,02143% | **47,13%** | −0,928 | 🔴 **−1,125** | 10,925 | 9,540 |
| **CONTROLLO** | +15 min | 1.128 | −0,00214% | 48,40% | −0,093 | −0,290 | 2,835 | 2,725 |
| | +30 min | 1.121 | −0,00555% | 47,55% | −0,240 | −0,437 | 4,105 | 3,826 |
| | +60 min | 1.102 | −0,00753% | 47,37% | −0,326 | −0,523 | 5,690 | 5,855 |

### 7.2 🔒 La cassaforte OOS 2016-2020 **non smentisce: peggiora**
| | +15 min | +30 min | +60 min |
|---|---:|---:|---:|
| continuazione mediana | −0,02973% | −0,00161% | 🔴 **−0,04934%** |
| quota > 0 | **43,71%** | 49,37% | 🔴 **43,71%** |
| netta a oro di oggi | −1,485 $ | −0,267 $ | 🔴 **−2,334 $** |

### 7.3 🎯 E la fascia che **sopravvive al cancello delle notizie** (09:30 ET) — dichiarata **prima**, non scelta dopo
**111 esplosioni.** Se un'ora vera e' sfruttabile, dev'essere questa.

| | +15 min | +30 min | +60 min |
|---|---:|---:|---:|
| continuazione mediana | −0,03528% | **+0,00222%** | −0,02133% |
| quota > 0 | 44,55% | **50,00%** | 47,27% |
| netta a oro di oggi | −1,725 $ | −0,101 $ | −1,121 $ |
| **controllo appaiato**, quota > 0 | 50,91% | 🔴 **51,82%** | 45,45% |

> ## 🔴 **ANCHE L'ORA VERA NON PAGA.** A +30 minuti la continuazione e' **50,00% esatto**: una monetina. E il **controllo appaiato fa 51,82%** — cioe' **meglio dell'esplosione**. 🔴 **L'esplosione non porta informazione sul dopo.**

### 7.4 🟢 MA IL COSTO, QUI, **PASSA** — e va detto, perche' e' una notizia nuova

| | |
|---|---:|
| **MAE mediano a +60 min** (quanto va contro, in mediana) | **9,54 $** |
| costo pieno di un giro completo | 0,2003 $ |
| **rapporto** | 🟢 **47,6x** |
| pavimento **DI LAVORO** (`stop ≥ 40 × costo`) | **8,01 $** → ✅ **PASSA** |
| pavimento **DURO** (13,3x) | 2,66 $ → ✅ passa largo |

> ### 🟢 **Questa e' la differenza con il verdetto del 10-11/09.** Li' (oro M1,
> finestra 15:36-15:41) il meccanismo era **BOCCIATO PER COSTO**: serviva un
> movimento **5-6 volte piu' grande**. **Qui il costo non c'entra**: la finestra
> da 30 minuti e' abbastanza grande da pagare il pedaggio con comodo.
> 🔴 **E' l'EDGE a non esserci.** Che e' una notizia peggiore, ma piu' pulita:
> un problema di costo si risolve cambiando TF, un problema di direzione no.

---

# 8. 🖼️ **DOVE CADONO LE TRE SCHERMATE DI CLAUDIO** — alla fine, non all'inizio

### 8.1 La distribuzione completa — finestre da **30 minuti**, n = 154.787
| percentile | movimento in % del prezzo | **in $ a oro 4.330** |
|---|---:|---:|
| P50 | 0,0626% | **2,71 $** |
| P75 | 0,1271% | 5,50 $ |
| P90 | 0,2340% | 10,13 $ |
| P95 | 0,3374% | 14,61 $ |
| P99 | 0,6434% | 27,86 $ |
| **P99,9** | 1,3316% | **57,66 $** |
| P99,99 | 2,1023% | 91,03 $ |
| **MAX** | 3,8628% | **167,26 $** |

### 8.2 🎯 E quindi, la risposta a Claudio in una riga
| la corsa che hai visto | in % del prezzo | **percentile** | quante volte |
|---|---:|---:|---:|
| **35 $ in 30 minuti** | 0,8083% | 🎯 **99,50°** | 775 su 154.787 = **4,5 volte al mese** |
| **40 $ in 30 minuti** | 0,9238% | 🎯 **99,66°** | 532 su 154.787 = **3,1 volte al mese** |
| 35 $ in 60 minuti | 0,8083% | 98,57° | 1.077 su 75.123 = **6,2 volte al mese** |
| 40 $ in 60 minuti | 0,9238% | 99,02° | 735 su 75.123 = **4,2 volte al mese** |

> ## 🎯 **Quello che hai visto sta nell'0,5% PIU' ESTREMO delle mezz'ore dell'oro — e capita 3-4 volte al mese.** Non e' un miraggio (esiste, e si ripete), e non e' quotidiano. **E' un appuntamento settimanale.**

### 8.3 E **dove** cadono, per ora — la conferma che l'imbuto e' lo stesso
| | ore UTC piu' frequenti |
|---|---|
| corse ≥ 35 $ (775 casi) | **13** (120) · **14** (111) · **15** (105) · **12** (92) · 16 (48) · 18 (48) |
| corse ≥ 40 $ (532 casi) | **13** (88) · **14** (83) · **15** (70) · **12** (64) · 18 (35) · 16 (32) |

🟢 **Le stesse quattro ore della tavola §3.** Le corse che Claudio ha
fotografato **non sono un fenomeno a parte**: sono la coda alta **della stessa
distribuzione**, nella stessa finestra oraria. **E il 57,5-62,8% di esse e'
gia' "esplosione" anche secondo la nostra definizione a k=0,40** (le altre sono
grandi in dollari ma cadono in giorni ad ATR alto, dove 35 $ non e' un evento).

### 8.4 ⏰ **IL FUSO DELLE SCHERMATE NON LO SAPPIAMO, e non lo assumo**
Claudio ha mandato tre finestre — **10:00-13:00**, **12:00-15:00**,
**17:00-20:00** — in **ora del suo telefono, fuso non dichiarato**.
🔴 **`[NON MISURATO]`.** Se il telefono fosse in ora italiana (il 22/09 e'
**CEST = UTC+2**), la traduzione sarebbe:

| finestra sul telefono | → UTC (se CEST) | → ora di New York | cade nella fascia calda? |
|---|---|---|---|
| 10:00-13:00 | 08:00-11:00 | 04:00-07:00 ET | ❌ no (**0,23x-0,49x**) |
| 12:00-15:00 | 10:00-13:00 | 06:00-09:00 ET | 🟡 **il bordo** (tocca 08:00-08:30 ET) |
| 17:00-20:00 | 15:00-18:00 | 11:00-14:00 ET | 🟡 **la coda** della fascia calda |

⚠️ **Questa tabella e' un'ILLUSTRAZIONE, non un risultato**: si regge su un'ipotesi
(`telefono in CEST`) che **non ho verificato**. 👉 **Basta che Claudio dica in che
fuso e' il suo TradingView e la riga diventa un fatto.** Se le tre schermate
cadessero davvero **fuori** dalle fasce calde, sarebbe un'informazione **preziosa
e contraria** a tutto questo referto — motivo in piu' per chiedere invece di
indovinare.

---

# 9. 🧪 **IL CONTRO-ESEMPIO CHE FACCIO A ME STESSO** — e mezzo REGGE

🔴 **Regola di casa del 10/09: prima di consegnare devo costruire IO la
spiegazione alternativa e far vedere che non regge. Qui ne REGGE UNA, e la
scrivo grande invece di nasconderla.**

## 9.1 L'obiezione: *"non c'e' nessuna ora esplosiva. C'e' solo l'orologio della volatilita'."*

Alle 14 UTC l'oro si muove **sempre** piu' che alle 02 UTC (range mediano 3,468
contro 1,280). Con una soglia tarata sull'ATR **giornaliero**, le ore agitate
superano quella soglia piu' spesso **per forza**. La scoperta sarebbe una
tautologia.

**Il numero che produce l'ALTRA spiegazione**: definizione **E2**, soglia
`k2 × range mediano DELLA SUA ORA` — con **k2 = 4,0072 calibrato per dare
esattamente lo stesso tasso medio** (0,741%), cosi' le due tavole sono
confrontabili riga per riga.

| ora UTC | tasso **E2** (ora su se stessa) | **x medio E2** | x medio **E1** (ATR giornaliero) |
|---:|---:|---:|---:|
| 03 | 0,926% | 1,25x | 0,13x |
| 05 | 0,950% | 1,28x | 0,26x |
| **13** | 0,413% | 🔴 **0,56x** | **3,36x** |
| **14** | 0,414% | 🔴 **0,56x** | **3,52x** |
| 18 | 1,142% | **1,54x** | 1,34x |
| **19** | 1,357% | 🥇 **1,83x** | 1,01x |
| 22 | 1,088% | 1,47x | 0,23x |
| **dispersione max/min fra le ore** | | 🟢 **3,3x** | 🔴 **29,2x** |

> ## 🔴 **L'OBIEZIONE REGGE, E IN PARTE MI SMONTA.**
> Chiedendo *"quest'ora esplode rispetto al SUO normale?"* la forbice fra le ore
> **crolla da 29,2x a 3,3x**, e le ore 13-14 diventano **fra le PIU' TRANQUILLE
> della giornata (0,56x)**. 🔴 **Alle 13-14 UTC l'oro si muove tanto, ma si
> muove tanto IN MODO PREVEDIBILE: la sorpresa relativa al suo normale e' li'
> piu' bassa che altrove.**

### 🔎 Cosa sopravvive dopo l'obiezione, e cosa no
| affermazione | regge? |
|---|---|
| *"le corse da 35-40 $ capitano soprattutto fra le 12 e le 15 UTC"* | ✅ **SI'** — e' la domanda di Claudio, ed e' in dollari. E2 non la tocca |
| *"quelle ore hanno qualcosa di SPECIALE oltre a essere trafficate"* | 🔴 **NO** — E2 dice il contrario |
| *"l'apertura del cash USA sopravvive al cancello delle notizie"* | ✅ **SI'** — e' un confronto **fra fasce**, e le 09:30 ET vincono **anche** contro le 08:30 ET che hanno range simile |
| *"si puo' costruirci sopra una sedia"* | 🔴 **NO**, e lo dice §7, non E2 |

## 9.2 La seconda obiezione: *"e se il 2026 fosse un regime CALDO e 35 $ fosse la norma?"*

Il campione arriva al 2020, con l'oro a 1.700 $. Oggi e' a 4.330 $ e viene da un
mercato toro violento. **Contro-esempio costruito**: la stessa distribuzione, ma
**solo sul decile piu' alto di ATR14 RELATIVO** (soglia **2,4427%** del prezzo,
15.480 finestre) — il regime piu' agitato che il campione contenga.

| | percentile normale | **percentile nel regime CALDO** | volte al mese |
|---|---:|---:|---:|
| corsa da **35 $** | 99,50° | 🔻 **97,36°** | da 4,5 a 🔥 **21,9** |
| corsa da **40 $** | 99,66° | 🔻 **98,14°** | da 3,1 a 🔥 **15,4** |

> ## 🟠 **L'OBIEZIONE MORDE ANCHE QUI, e cambia la risposta a Claudio.** In un regime caldo una corsa da 35 $ **NON e' piu' un evento da 4 volte al mese: sono 22.** Resta comunque **la coda alta** (97° percentile), ma **la frequenza si quintuplica**. 👉 Quindi la riga onesta e': **"fra 4 e 22 volte al mese, a seconda di quanto e' caldo il mercato"** — e quale dei due sia il 2026 **`[NON MISURATO]`**, perche' i dati si fermano al maggio 2020.

## 9.3 La terza obiezione: *"il ribasso domina perche' l'oro ha la coda negativa, e basta"*

Misurato lo sbilancio fra i due lati, **per epoca** (errore standard binomiale
accanto):

| insieme | n | RIALZO | RIBASSO | **quota RIBASSO** |
|---|---:|---:|---:|---:|
| **TUTTO 2006-2020** | 1.147 | 510 | 637 | **55,5% ± 1,5 pt** |
| 2006-2013 | 661 | 260 | 401 | **60,7% ± 1,9 pt** |
| 2014-2020 | 486 | 250 | 236 | 🔴 **48,6% ± 2,3 pt** — *si ribalta!* |
| **fascia 09:30 ET, tutto** | 111 | 39 | 72 | 🎯 **64,9% ± 4,5 pt** |
| fascia 09:30 ET, 2006-2013 | 68 | 27 | 41 | 60,3% ± 5,9 pt |
| **fascia 09:30 ET, 2014-2020** | 43 | 12 | 31 | 🎯 **72,1% ± 6,8 pt** |

> ## 🔑 **E QUI L'OBIEZIONE NON REGGE, ed e' il risultato piu' fine del referto.**
> Lo sbilancio **GLOBALE si ribalta** fra le due epoche (60,7% → 48,6%): **non
> e' una legge dell'oro**, e chi avesse scritto *"l'oro crolla piu' di quanto
> sale"* basandosi sulla media di 15 anni avrebbe scritto una cosa **falsa in
> meta' del campione**.
> 🎯 **Ma la fascia 09:30 ET NON si ribalta: 60,3% → 72,1%.** Nell'epoca in cui
> il resto della giornata e' **simmetrico (48,6%)**, l'apertura del cash USA e'
> al **72,1%**. **23,5 punti di differenza, nella stessa epoca.** La coda
> negativa "generale" **non spiega** questo, perche' nel 2014-2020 non esiste.
>
> ⚠️ **E il campione e' sottile: n = 43.** Per la regola di casa del 16/08
> (*"il vecchio giudica il RISCHIO, il recente giudica il MERITO"*) questo e'
> abbastanza per un'affermazione di **RISCHIO** — *"una posizione LONG sull'oro
> tenuta attraverso l'apertura di Wall Street ha la coda peggiore"* — e **NON
> abbastanza per un'affermazione di MERITO**. Non ci si costruisce una sedia.

---

# 10. ⚖️ IL VERDETTO, e cosa questo referto **NON** dice

## ✅ COSA E' MISURATO ADESSO
| domanda di Claudio | risposta | fonte |
|---|---|---|
| *"c'e' un orario comune?"* | 🟢 **SI': 08:30 ET e 09:30 ET** (= 12-15 UTC). Forbice **29,2x** fra l'ora piu' e meno esplosiva | §3, §4 |
| *"xche avviene?"* | 🟢 **Meta' notizie, meta' apertura di Wall Street**, e le due si separano pulite | §5 |
| *"c'e' un ATR simile?"* | 🔴 **NO.** ATR del giorno **0,96x** la mediana: le esplosioni capitano in **giorni normali** | §6.1 |
| *"volumi simili?"* | 🔴 **NO, non prima.** Filtro al volume: guadagno **max 1,64x** buttando l'88% del giorno | §6.2 |
| *"dobbiamo misurare anche il lato short"* | 🟢 **FATTO, sempre separato.** E il risultato e' li': **64,9% ribasso alle 09:30 ET**, stabile fra le epoche | §9.3 |
| *"come si puo' misurare?"* | 🟢 `backtest_pipeline/anatomia_esplosioni_oro.py` — **gira in ~4 minuti**, si scarica i dati da solo | tutto |
| **e' sfruttabile?** | 🔴 **NO.** Continuazione **negativa** a tutti gli orizzonti, **45-48%** a favore, OOS peggiore, controllo appaiato uguale o meglio | §7 |

## 🚫 COSA QUESTO REFERTO **NON** DICE — e non lo diro'

- ❌ **Non copre il 2021-2026.** Il campione finisce a **maggio 2020**, oro a
  1.700 $. Le schermate sono a 4.330 $. 🔴 **`[NON MISURATO]`**, e §9.2 mostra
  che **morde**. Provato oggi da qui: **HistData** (che pubblica XAUUSD M1
  2018-2024), **Dukascopy** e **Stooq** sono **tutti e tre murati dal proxy**
  (`CONNECT tunnel failed, 403`). 👉 Il buco si chiude **solo dal PC di
  backtest** o dal VPS. **Questa e' la cosa piu' utile che Claudio puo' fare.**
- ❌ **Non e' BCM**: il feed e' **Oanda**. Misura di **OCCASIONI**, non verdetto
  su un broker. ⚠️ Direzione dell'errore **nota**: BCM ha spread **peggiore**.
- ❌ **Non e' un backtest.** Nessuna uscita simulata, nessun PF, nessuna equity,
  nessun DD. I numeri di §7 sono **escursioni**, non operazioni.
- ❌ **Il "volume" e' TICK VOLUME**, non volume scambiato. Detto ogni volta.
- ❌ **Il fuso delle tre schermate e' `[NON MISURATO]`** (§8.4): la traduzione
  e' un'illustrazione sotto ipotesi, non un risultato.
- ❌ **Il calendario notizie e' INCOMPLETO** (§5): mancano sussidi settimanali,
  PIL, PCE, Michigan, JOLTS, discorsi Fed. Regge la conclusione su **09:30 ET**
  (dove non esce nulla), **non** quella su 08:30 ET.
- ❌ **Lo spread dell'oro nelle fasce 08:30/09:30 ET e' `[NON MISURATO]`** —
  eredita' dichiarata del 10/09. Usato 0,2003 $, il **piu' favorevole** che
  abbiamo. **Nessuno scenario in cui il costo vero sia migliore.**
- ❌ **Lo slippage sull'oro e' `[NON MISURATO]`**, e su un'apertura morde.
- ❌ **Nessuna proposta di EA, nessun file prova, nessuna cella.** Come da mandato.

## 🚩 E LA COSA CHE **NON** ANDAVA FATTA, e non e' stata fatta
❌ Non ho cercato la combinazione di ATR e volume che "spiega" i tre casi. Su
1.147 esplosioni e due manopole libere, una combinazione che li spiega **si trova
sempre** — ed e' la cella verde per caso che brucia la challenge (regola del
19/08). **Le manopole sono state misurate una per volta, contro la popolazione,
e hanno detto di no tutte e due.**

---

# 11. 🔜 LE TRE COSE CHE APRIREBBERO DAVVERO QUALCOSA (in ordine di costo)

1. 🥇 **CHIUDERE IL BUCO 2021-2026** — scaricare XAUUSD M1 2021-2026 dal **PC di
   backtest** (HistData lo pubblica, e questa casa ne ha gia' importate
   **2.432.995 barre** in `XAUUSD_EXT`: `REFERTO_IMPORT_6_SIMBOLI.md`, diff
   media **0,0110%** contro BCM). Lo strumento **legge gia' quel formato**: zero
   righe di codice. Costo: **un'ora**. 👉 Risponde a *"il 2026 e' un regime
   caldo?"*, che e' la sola obiezione di §9 rimasta aperta con un numero dentro.
2. 🥈 **CHIEDERE A CLAUDIO IL FUSO DEL SUO TRADINGVIEW** — costo: **una domanda**.
   Trasforma §8.4 da illustrazione in fatto.
3. 🥉 **MISURARE LO SPREAD BCM SULL'ORO nella fascia 09:30 ET** (14:30 o 15:30
   ora server secondo la stagione) — buco aperto dal 10/09 e mai chiuso. Serve
   a **qualunque** candidato futuro sull'oro, non solo a questo.

🔴 **E la cosa che NON propongo: una griglia di parametri su questo meccanismo.**
La direzione non c'e' (§7), e su un motore senza direzione una griglia piu' fitta
trova solo **picchi di rumore**.

---

## 📁 FONTI E RIPRODUCIBILITA'
| cosa | dove |
|---|---|
| **strumento** | `backtest_pipeline/anatomia_esplosioni_oro.py` (v1, definizione congelata alle righe 32-77) |
| **referto grezzo** (557 righe, tutte le tavole complete) | `backtest_pipeline/risultati_prove/ANATOMIA_ESPLOSIONI_ORO_20260922.txt` |
| **dati** | `FutureSharks/financial-data` GPL-3.0, Oanda `XAU_USD`, 171 file mensili 2006-03 → 2020-05 (scaricati dallo strumento) |
| **notizie** | `mql5/Files/abtg_news_postnews_2010_2025_UTC.csv`, `abtg_news_usd1330_2010_2023_UTC.csv`, `abtg_news_ism1500_2010_2023_UTC.csv` |
| **costo** | `report/ORO_1530_CANCELLO_COSTO_2026-09-10.md` §2.4 (0,2003 $/oncia) |
| **precedenti riletti** | `ORO_1530_MISURA_GIRATA_2026-09-11.md`, `ORO_1530_DISEGNO_MISURA_2026-09-10.md`, `CACCIA_APERTURE_ORO_2026-09-08.md`, `LA_SEDIA_ORO_GIRA_ALTROVE_2026-09-11.md`, `ORO_CONTRO_INDICI_COSTO_2026-09-10.md`, `GOLDEDGE_SPARK5_2026-08-22.md`, `RICERCA_SPREAD_PROP_XAUUSD_2026-09-17.md` |
| **riga per rifarlo** | `python3 backtest_pipeline/anatomia_esplosioni_oro.py --dati <cartella> --news <i tre csv> --fuori <referto.txt>` |

**Corsa di riferimento: 22/09/2026 · 4.884.366 barre M1 · 0 righe scartate ·
0 OHLC incoerenti · collaudo dell'orologio PASSATO.**
