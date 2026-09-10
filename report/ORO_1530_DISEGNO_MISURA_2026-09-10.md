# 🥇 ORO ALLE 15:30 — LA STRADA AI DATI E IL DISEGNO DELLA MISURA (10/09/2026)

**Richiesta di Claudio, testuale:**
> _"VOGLIO CHE FAI ANALIZZARE AGLI AGENTI IL MOVIMENTO DELL'ORO XAUUSD ALLE 15.30
> ALL'APERTURA DEI MERCATI. Un collega mi diceva che lui guarda in M5 la candela
> dalle 15.30 alle 15.35, poi mette in M1 e vede alle 15.36 dove sfonda, se long
> o short ed entra. Fa un'operazione cosi. Poi fa 3 o 4 candele in M1. VOGLIO
> SAPERE DAGLI AGENTI, NEGLI ULTIMI ANNI COME SI COMPORTA ALL'APERTURA L'ORO IN
> M1 DALLE 15,36 ALLE 15,41. QUESTI 5 MIN, SE FA BREAKOUT, TUTTE LE CANDELE
> DELLO STESSO COLORE O SE FA SU E GIU' DI COLORE. FAI CON CALMA."_

**Precisazione dello stesso giorno:**
> _"LA RICHIESTA CHE TI HO FATTO E' X TRADARE MANUALE. O PER CREARE UN EA
> SULL'APERTURA. LUI DICE CHE QUEI 5 MINUTI SONO FACILI DA TRADARE, CHE L'ORO VA
> IN DIREZIONE QUALCHE CANDELA IN M1. PROBABILMENTE CI POTREBBE ESSERE L'INCROCIO
> DELLE MEDIE 9 E 21 E MAGARI LI IL PREZZO POTREBBE CORRERE DI +."_

🔒 **Niente toccato in forward. Niente lanciato sul VPS. Nessun backtest.
Nessun verdetto di strategia: qui c'è la STRADA e il DISEGNO, i numeri veri
arrivano quando lo strumento gira sul campione pieno.**

---

## ⚡ LA RIGA CHE CONTA

> 🟢 **I DATI CI SONO, SONO GRATIS E LI HO GIÀ TOCCATI OGGI.** Oro M1
> **2006-03 → 2020-05** (~14,2 anni, ~3.730 giornate feriali utili), fonte
> `FutureSharks/financial-data` GPL-3.0 via `raw.githubusercontent.com` — lo
> stesso canale che questa casa usa dal 03/09. **Copertura sondata file per file
> oggi**, non assunta.
>
> 🕐 **E L'OROLOGIO È COLLAUDATO, NON ASSUNTO.** Misurato oggi sull'oro:
> picco di volatilità M1 **13:30 d'inverno / 12:30 d'estate** → spostamento
> **−60 min** → **il file è in UTC**, confermato (ed è il dato USA delle 8:30
> di New York che si sposta, più il fixing di Londra a 15:00/14:00 in seconda
> riga). **Il collaudo è dentro lo strumento e se fallisce lo strumento si
> ferma**, perché un orologio sbagliato non dà errore: dà un numero pulito e
> falso.
>
> ⚠️ **LA TRAPPOLA DEL FUSO È REALE E VA DETTA A CLAUDIO ADESSO:** per
> **~15-20 sedute l'anno** (metà marzo e fine ottobre) **le 15:30 italiane NON
> sono le 09:30 di New York: sono le 08:30.** Non le butto e non le nascondo:
> **misuro tutte e due le ancore** e stampo a parte il sottoinsieme discorde.
>
> 💰 **COSTO IN TEMPO MACCHINA: MENO DI 15 MINUTI IN TUTTO** (scarico ~275 MB
> una volta sola + **~30 secondi a corsa**, misurati: **210.000 barre M1 al
> secondo**). È la misura più economica che questo progetto abbia in canna.
>
> 🔵 **AGGIORNATO IN CORSA (10/09, fatti arrivati mentre lavoravo):**
> **① IL COSTO NON È PIÙ UN BUCO, È UN NUMERO: 0,2003 $/oncia** a giro
> completo (spread 0,1600 + **commissione 0,0403 — sull'oro la commissione
> ESISTE, sugli indici è zero**). Pavimenti: **DURO 2,66 $**, **DI LAVORO
> 8,01 $**. È dentro lo strumento come **metro**, non come deduzione.
> **② C'È UN SECONDO FEED, ED È GIÀ IN CASA E GIÀ VALIDATO:** HistData
> **pubblica XAUUSD M1** e questa casa ne ha già importate **2.432.995 barre
> M1 (2018-2024)** in `XAUUSD_EXT`, con **shift +5 calibrato** e **diff media
> 0,0110% contro il nativo BCM, copertura 99,2%**. Lo strumento **legge già
> quel formato**: zero righe di codice in più.
> **③ L'IPOTESI 9/21 CAMBIA VERSO:** la principale diventa **le medie
> INCLINATE** (lo stato come filtro di lato), l'**incrocio** scende a
> variante. Motivo misurabile e già visibile: sul campione di collaudo
> l'incrocio nella barra si accende **7 volte su 63**.

---

## 0. 📕 COSA ABBIAMO GIÀ MISURATO SU QUESTA INEFFICIENZA — letto PRIMA

Fonti rilette per intero: `CACCIA_APERTURE_ORO_2026-09-08.md`,
`CACCIA_ORO_ARGENTO_MECCANISMI_2026-09-06.md`,
`CACCIA_INTRADAY_FOREX_ORO_2026-08-28.md`,
`CACCIA_POSTNEWS_MECCANISMI_2026-09-05.md`, `REGISTRO_TEST.md` (1.827 righe),
`SPREAD_FLOTTA_MISURA_2026-09-03.md`, `biblioteca/sonde_esterne/LEGGIMI.md`.

| cosa | verdetto già agli atti | **c'entra con la domanda di Claudio?** |
|---|---|---|
| **Blocco 13:30 sull'oro (dati USA delle 8:30 NY)** — `CACCIA_POSTNEWS_2026-09-05` | **683 giornate-evento**, breakout del range post-notizia: **PF 1,08 contro un controllo casuale a 1,11**. *"Sull'oro il controllo casuale guadagna da solo (+0,055 R)"* | 🟡 **È LA COSA PIÙ VICINA CHE ABBIAMO**: stesso simbolo, stessa famiglia di orologio (mattino USA), stessa geometria (rottura di un range corto). **Ma NON è la stessa misura**: solo giorni di notizia, ore 8:30 NY e non 9:30, range di 15 minuti e non di 5. **È il precedente più severo che questa idea deve battere.** |
| **Famiglia BREAKOUT / ORB in apertura** — `REGISTRO_TEST` §2, verdetto 26.07.26 | *"Il breakout in apertura su M5 NON ha edge sul tick vero"*, **~210 celle** | 🟠 chiusa sugli **indici** e su **M5**. Mai misurata sull'oro all'**apertura di New York** con range di **5 minuti** e osservazione **M1** |
| **R45 ORB Londra** · **`GoldLondonBreakout`** · **Gold ORB Asia&London** | **0 celle positive su 48**; il Code Base 75586 è *"LETTERALMENTE il nostro R45"* | 🟠 è l'**apertura di Londra**, non quella di New York. Simbolo giusto, **orologio diverso** |
| **4 meccanismi oro** (lead-lag bond→oro, oro←dollaro, fixing LBMA, Code Base) — `CACCIA_ORO_ARGENTO_2026-09-06` | **54+19+72 celle, ZERO promosse**; il lead-lag *"vive dentro lo spread"* | 🔴 nessuno è l'apertura USA. **Il fixing LBMA è 72 su 72 negativo da entrambi i lati** |
| **`SessionReopenEA`** — `CACCIA_APERTURE_ORO_2026-09-08` | promosso 9/10, **mai costruito** | 🔴 è la **riapertura CME delle 23:00 server**, un altro orologio |
| **`ABTG_MaxMinNotte` XAUUSD** (magic 770402, H2) | sedia viva sulla **notte** dell'oro | 🟠 stesso simbolo, fascia oraria diversa: **nessuna sovrapposizione con le 14:30 server**, ma va ricontrollata se questa cosa diventasse una sedia |
| **Profondità TICK di XAUUSD su BCM** | 🔴 **MAI MISURATA** (`misura_tick/` ha solo D30EUR, NASUSD, U30USD) | 🔴 **nessun verdetto di merito sull'oro è possibile oggi**, per nessun candidato |

### 🎯 Quindi: la domanda di Claudio è **NON ANCORA MISURATA**
**Nessun file in questo repository misura il comportamento dell'oro M1 nei
minuti dopo l'apertura del cash USA.** Zero righe. Non è una riesumazione: è
una casella vuota.

🔴 **MA la lista dei caduti impone di dirlo chiaro:** se questa misura diventa
un EA, **entra nell'imbuto portandosi addosso il peso della famiglia chiusa**
(breakout di un range d'apertura, ~210 celle + 48 celle + il PF 1,08 contro un
caso a 1,11 sull'oro). **La misura descrittiva la si fa perché costa 15 minuti
e risponde a una domanda vera. Il file prova, invece, si scrive solo se i
numeri battono il controllo casuale E il pavimento di costo.** Non prima.

### 🚨 UNA CONTRADDIZIONE AGLI ATTI — trovata oggi, e **ORA SANATA**
`CACCIA_APERTURE_ORO_2026-09-08.md` §2.2 e §5b citano *"spread oro diurno
**MISURATO** in casa 0,24 $"*. **Non ho trovato nessun file che lo misuri.**
`SPREAD_FLOTTA_MISURA_2026-09-03.md` copre **solo i tre indici**;
`CACCIA_ORO_ARGENTO_2026-09-06` §6 scrive l'opposto a lettere grandi:
*"LO SPREAD BCM SULL'ORO NON È MAI STATO MISURATO… sono dodici giorni"*, e usa
0,25 $ **dichiarato**. L'unico riferimento reale è un **tetto di vendor**
(`MaxSpreadSize=30` = 0,30 $).
✅ **CHIUSA IN GIORNATA dall'agente del cancello di costo:** il numero "0,24 $
misurato" **non ha nessuna fonte nel repository** — era una voce che si citava
da sé — ed è stato **RITIRATO**, con errata depositata in
`CACCIA_APERTURE_ORO_2026-09-08.md` e in
`CACCIA_ORO_1530_APERTURA_USA_2026-09-10.md`.
👉 **Il numero vero, misurato il 10/09: costo pieno di un giro completo
`0,2003 $/oncia` = spread `0,1600` + commissione `0,0403`** (`SpreadPt 16`,
`Digits 2`, `Point 0,01`, verificato per triangolazione; commissione
**3,4858 EUR/lotto** da **520 righe** di `data/statements/trades_auto.csv`).
🚨 **E la scoperta che nessun conto di casa teneva: sull'oro la COMMISSIONE
ESISTE, mentre sugli indici è ZERO.** Vale il **20% del costo totale**.

---

## 1. 🛣️ LA STRADA AI DATI — misurata oggi, non presunta

### 1.1 ✅ HistData **PUBBLICA** l'oro M1 — e noi l'abbiamo GIÀ importato
Avevo scritto che `histdata_m1.py` non ha XAUUSD nella sua tabella (vero: 8
indici + EURUSD) e che il sito è **murato dal proxy** (vero: `EGRESS_BLOCKED`,
quindi da qui non posso guardarlo). **Ma la risposta era in casa, e l'ho
trovata:**

`backtest_pipeline/risultati_archivio/REFERTO_IMPORT_6_SIMBOLI.md` (15/08/2026):

| simbolo | barre M1 | scartate | **diff media vs BCM nativo** | **copertura** | shift |
|---|---:|---:|---:|---:|---:|
| **`XAUUSD_EXT`** | **2.432.995** | **0** | **0,0110%** | **99,2%** | **+5** |

> *"Feed HistData M1 **2018-2024**, importato come simboli `_EXT` nel terminale
> BCM… Il peggiore dei sei — XAUUSD a 0,0110% — sta **cinque volte sotto la
> soglia**."*

👉 **Tre conseguenze, tutte buone:**
1. **HistData pubblica `xauusd` in M1** (il driver `importa_storico_esterno.ps1`
   costruisce l'URL dal nome del simbolo minuscolo: `…/1-minute-bar-quotes/xauusd/<ANNO>`).
   **Il buco che volevo far chiudere a Claudio è già chiuso da una misura di
   casa.** Aggiungerlo a `histdata_m1.py` resta **3 righe** (`STRUMENTI`,
   `PRIMO_MESE`, `SIMBOLI_MISSIONE`) con banda di prezzo larga — es. **200,0 –
   6.000,0 $** — dichiarando che serve solo a beccare errori di **UNITÀ**.
2. **È un SECONDO FEED INDIPENDENTE, e per giunta già validato contro BCM**
   (diff media **0,0110%**, copertura **99,2%**, shift **+5** trovato da solo
   dallo script provando da −6 a +6, **come per altri 7 simboli su 7**).
3. 🎯 **E copre gli anni che a Oanda mancano: 2018-2024.** Insieme fanno
   **2006 → 2024**, cioè *"negli ultimi anni"* per davvero, **regime
   2021-2024 compreso**.

⚠️ **Dove stanno quei CSV**: lo zip `import_esterno.zip` veniva dal PC di
backtest `DESKTOP-H4D7CAJ`. **Nel repository non ci sono** (`[NON MISURATO]` se
siano ancora su quel PC). Se ci sono, **lo strumento li legge così come sono**:
riconosce il formato HistData `AAAAMMGG HHMMSS;o;h;l;c;v` e va lanciato con
`--fuso-file ny` (che è già il default per quel formato).

### 1.1-bis 🗄️ E BCM ha più storico sull'oro di quanto credevamo
Da `risultati_archivio/sonda_storico_17-08/215D85D7_ABTG_InfoBroker.csv`, riga
`XAUUSD`:
```
XAUUSD  Digits 2  Point 0.01  ContractSize 100  TickValue 0.86289  SpreadPt 16
        H1: 100.000 barre, prima data 2004.06.11    D1: 6.795 barre, 2004.06.11
```
👉 **BCM parte dal 2004.06.11 sull'oro** — e le 100.000 barre H1 sono il **tetto
del tester**, non la fine dei dati.
🔴 **MA la profondità M1 è UN'ALTRA DOMANDA e in quella riga NON C'È:
`[NON MISURATO]`.** Va misurata sul VPS, non dedotta. (E la M1 su MT5 è la
prima serie che i broker potano.)

### 1.2 ✅ LA STRADA BUONA: `FutureSharks/financial-data` (GPL-3.0)
Canale già verde in casa da 5 dossier (`PROMEMORIA_SBLOCCO_FONTI.md`, blocco
03/09) e usato per **253 file mensili** il 05/09.

```
https://raw.githubusercontent.com/FutureSharks/financial-data/master/
    pyfinancialdata/data/currencies/oanda/XAU_USD/<ANNO>/oanda-XAU_USD-<ANNO>-<MESE>.csv
```

**COPERTURA SONDATA OGGI, file per file (HTTP + byte):**

| anno | gen | giu | dic | nota |
|---|---|---|---|---|
| 2005 | 404 | 404 | 404 | **non esiste** |
| 2006 | 404 | 200 (1,08 MB) | 200 | **primo mese: 2006-03** (01 e 02 = 404) |
| 2007-2019 | 200 | 200 | 200 | **13 anni pieni**, 1,4-1,8 MB/mese |
| 2020 | 200 | 404 | 404 | **ultimo mese: 2020-05** |
| 2021 | 404 | 404 | 404 | — |

➡️ **2006-03 → 2020-05 = 171 file mensili, ~275 MB, ~5,0 milioni di barre M1.**

**FORMATO (verificato aprendo un file):**
```
time,close,high,low,open,volume
2015-06-01 13:30:00,1200.304,1200.434,1199.326,1199.47,445
```
🚨 **LE COLONNE SONO `C,H,L,O` — NON `O,H,L,C`.** Leggerle nell'ordine sbagliato
**inverte il colore di ogni candela**, che è esattamente la cosa che Claudio
chiede di misurare. **L'autotest dello strumento verifica proprio questo.**
Il volume c'è (conteggio tick Oanda) — utile per riconoscere le mezze giornate.

### 1.3 🕐 IL COLLAUDO DELL'OROLOGIO — **fatto oggi, sull'oro, non ereditato**
Metodo: il minuto del giorno con la `|close-open|` media più alta, mesi
invernali contro mesi estivi. Su 6 mesi (gen/lug di 2010, 2015, 2019),
**174.278 barre**:

| stagione | picco | 2° | 3° |
|---|---|---|---|
| **inverno** | **13:30** (0,8466) | 15:00 (0,6253) | 13:20 (0,5819) |
| **estate** | **12:30** (1,0844) | 12:20 (0,6567) | 13:00 (0,6520) |

**Spostamento −60 minuti → il file è in UTC. ✅ CONFERMATO sull'oro.**
E si legge anche il perché: il picco è il **dato USA delle 8:30 di New York**
(13:30 UTC d'inverno, 12:30 d'estate) e il secondo è il **fixing LBMA delle
15:00 di Londra** (15:00 UTC d'inverno, 14:00 d'estate). Due ancore
indipendenti, stesso verdetto.
🔴 **Se questo collaudo fallisce, lo strumento esce con codice 2 e non misura
niente.** Non è pignoleria: è la lezione del 05/09 (*"un orologio sbagliato
produce un numero pulito e falso"*).

### 1.4 ⏰ IL FUSO, e cosa faccio delle settimane sfasate
| calendario | inizio | fine |
|---|---|---|
| **USA dal 2007** | 2ª domenica di marzo | 1ª domenica di novembre |
| **USA fino al 2006** | 1ª domenica di aprile | ultima di ottobre |
| **UE (tutto il campione)** | ultima domenica di marzo | ultima domenica di ottobre |

⚠️ Il campione parte dal **marzo 2006**: la **regola americana VECCHIA serve
davvero**, altrimenti un mese del 2006 è misurato un'ora fuori. È implementata
e verificata nell'autotest su date note.

**Conseguenza, in chiaro:**

| periodo | 15:30 Roma | 09:30 New York | **coincidono?** |
|---|---|---|---|
| settimane normali (~94% dell'anno) | 13:30 o 14:30 UTC | idem | ✅ sì |
| **~8-15 sedute a metà marzo** | 14:30 UTC | **13:30 UTC** | 🔴 **NO: le 15:30 italiane sono le 08:30 di New York** |
| **~5 sedute a fine ottobre** | 14:30 UTC | **13:30 UTC** | 🔴 **NO** |

👉 **NON butto niente e non scelgo per Claudio:** lo strumento misura
**entrambe le ancore** (`APERTURA_NY` e `APERTURA_ROMA`) e stampa **a parte il
sottoinsieme dei giorni discordi**, così si vede quanto pesa invece di
assumerlo nullo.

### 1.5 🖥️ E PER L'EA, l'aritmetica in **ORA SERVER** (server BCM = Roma − 1)
| | ora server BCM |
|---|---|
| settimane **normali** | 09:30 New York = **14:30 server** = 15:30 Roma |
| settimane **sfasate** | 09:30 New York = **13:30 server**, mentre 15:30 Roma resta 14:30 server |

🎯 **Un EA con orario FISSO `14:30 server` è allineato all'apertura di Wall
Street tutto l'anno TRANNE quelle ~15-20 sedute, in cui arriva UN'ORA TARDI.**
Se il segnale è l'apertura USA, l'orario va calcolato con la **regola DST
americana**, non lasciato fisso. **Questo è un requisito di progetto, non un
dettaglio** — ed è misurabile: lo strumento dice quanto valgono quei giorni.

### 1.6 Le altre fonti — dichiarate come opzioni, non come fatti
| fonte | stato |
|---|---|
| **BCM nativo (i tre terminali del VPS)** | 🟢 **H1/D1 dal 2004.06.11** (§1.1-bis). 🔴 **La profondità M1 resta `[NON MISURATO]`**: si misura sul VPS, non si deduce. **Non ho toccato niente**, come da mandato |
| **Pepperstone / Tickmill** (presenti sul VPS) | 🟠 **possibile** fonte alternativa di storico oro. È un'**opzione**, non un fatto: nessuno l'ha mai sondata |
| **HistData** | 🟢 **RISOLTO (§1.1): pubblica XAUUSD M1, e noi ne abbiamo già 2.432.995 barre 2018-2024.** Il sito resta murato da qui, ma non serve più chiederlo |
| **Dukascopy** | 🟠 ha `XAUUSD` ma il crawl è strozzato (misurato il 18/08: proiezione **~7 giorni di corsa**). Non vale il prezzo |

### 1.7 🐍 Il python del VPS
`C:\python313\python.exe` **embeddable, sola libreria standard, niente pip**.
👉 Lo strumento consegnato usa **solo `argparse, csv, os, random, sys, time,
urllib, datetime`**. Niente pandas, niente numpy. **ASCII puro.** E siccome
`raw.githubusercontent.com` è raggiungibile da questo ambiente, **la corsa può
girare qui e non serve nemmeno disturbare il VPS.**

---

## 2. 📐 LA SPECIFICA — congelata PRIMA di vedere i numeri

### 2.1 Il segnale del collega, tradotto in regole non ambigue
| pezzo | definizione **congelata** |
|---|---|
| **SETUP** | le 5 barre M1 `[A, A+5)`, dove `A` = l'ancora. `H0` = massimo delle 5, `L0` = minimo, `R = H0−L0`. È la candela M5 "15:30-15:35" |
| **GRILLETTO** | la barra M1 `[A+5, A+6)` = il minuto "15:35-15:36". **È qui che si decide il lato**, perché Claudio vuole osservare **da** 15:36: la rottura dev'essere già avvenuta alle 15:36:00 |
| **OSSERVAZIONE** | le barre M1 da `A+6`. Le prime **5** sono la finestra "15:36-15:41"; l'orizzonte esteso (**10 minuti**) serve a vedere **dove finisce la spinta** |
| **RIFERIMENTO** | l'**apertura della barra `A+6`**. È il prezzo che prende chi entra all'inizio della finestra. **Mai un prezzo migliore** |

### 2.2 «SFONDA» — tre definizioni, calcolate tutte e tre
| | regola |
|---|---|
| **T (principale)** | `high(grilletto) > H0` → **LONG** · `low < L0` → **SHORT**. È quello che un uomo vede sul grafico |
| **C (variante)** | **chiusura** M1 oltre il livello |
| **M (variante)** | come T ma il livello va superato di **`k·R` con k = 0,10** (stessa convenzione di `anatomia_aperture.py`) |

**E i due lati nello stesso minuto?** Regola scritta adesso: si decide con la
**chiusura del grilletto** (`close > H0` → long, `close < L0` → short); se la
chiusura resta dentro il range il giorno è **AMBIGUO_IRRISOLTO**, esce dalle
statistiche direzionali **ed è contato**.
**Nessuna rottura?** Giorno contato e fuori dalle direzionali: **la frequenza
di "nessuna rottura" è essa stessa un risultato** — dice quante volte
l'operazione del collega semplicemente **non esiste**.

### 2.3 🎨 COLORE — deciso ADESSO, doji compreso
`close > open` = **VERDE** · `close < open` = **ROSSA** · **`close == open` =
DOJI, categoria PROPRIA.**
👉 Un doji **non è verde e non è rosso**: **spezza** la serie di colore uguale e
**non conta** come candela "nella direzione". **La sua frequenza è stampata**,
così il suo peso si vede invece di sparire dentro una convenzione. (Sull'oro
Oanda a 3 decimali i doji sono rari; su un feed a 2 decimali sono molti di più
— per questo la regola va scritta prima e non dopo.)

### 2.4 📊 Le statistiche prodotte
**(a) COLORE, su TUTTI i giorni** — è la domanda **letterale** di Claudio, che
non parla di direzione:
quota di **5 su 5 dello stesso colore** (e quante verdi / quante rosse) ·
distribuzione della **serie più lunga** di colore uguale (1-5) · distribuzione
dei **cambi di colore** (0-4) · quota di doji.

**(b) DIREZIONE, sui giorni con rottura** — la versione operabile:
distribuzione di **k = quante delle 5 candele sono nella direzione** (k=0..5),
quote **5/5**, **≥4/5**, **≥3/5**, e frequenza di **INVERSIONE** (chiusura dei
5 minuti dal lato opposto alla rottura).

**(c) MOVIMENTO IN DOLLARI** — *"serve a Claudio più del colore"*:
**MFE** (escursione a favore) e **MAE** (contro) dal prezzo di riferimento, in
**mediana, Q1, Q3, P80, P90**, in **$ e in % del prezzo** (l'oro del 2006 vale
600 $, quello del 2020 1.700: senza il % gli anni non sono confrontabili) ·
range dei 5 minuti · range della candela M5 di setup · e il **METRO DEL COSTO**
stampato accanto: costo pieno **0,2003 $/oz MISURATO**, pavimenti **2,66 $**
(`13,3×`, duro) e **8,01 $** (`40×`, di lavoro), **quota di giornate che
arrivano al pavimento**, e **quante volte più grande** dovrebbe essere il
movimento mediano per arrivarci. 🎯 **È la risposta (b): a quale TF quel
movimento diventa pagabile.**

**(e) 🖐️ QUANTO DURA LA SPINTA — la sezione del TRADER A MANO** *(aggiunta
dopo la precisazione di Claudio)*: per **ogni minuto j = 1..10**, mediana del
MFE, mediana del MAE, mediana della chiusura, e **% di giornate ancora sopra
zero**. Più la **distribuzione del minuto in cui il MFE tocca il massimo**.
👉 È la risposta alla domanda vera del collega: **"3-4 candele" è la durata
giusta, o si è già fermato prima, o continua dopo?** E la riga
**"quanto costa sbagliare"**: lo **stop che sopravvive all'80% delle escursioni
contrarie = P80 del MAE**, in dollari.

**(d) ANNO PER ANNO**, sempre: *un numero che vive in un anno solo non è un
comportamento, è un episodio.* Gli anni sotto 100 giornate sono marcati
**SOTTILE**.

### 2.5 🧪 L'IPOTESI 9/21 — **l'INCLINAZIONE è la principale, l'incrocio è una variante**
*(cambiata dopo la segnalazione del coordinatore, e il cambio è motivato, non estetico)*

**Medie su M1, prezzo di CHIUSURA, aggiornate fino alla chiusura del grilletto
`A+5` compreso.** Nessuna barra futura entra nel calcolo (il look-ahead da
0,6 R preso il 06/09 non si ripete). Riscaldamento **45 barre M1**; con
`alfa = 2/22` il peso del seme vale **~1,5%** — dichiarato. Se manca più di
1/3 del riscaldamento, le bandiere valgono **n/d** e il giorno resta valido per
tutto il resto.

| | condizione | ruolo |
|---|---|---|
| **INCLINATE** | **le DUE medie inclinate nel verso della rottura** (EMA9 ed EMA21 entrambe più alte — o più basse — di **3 barre M1** fa) | 🥇 **PRINCIPALE** |
| **E-ORDINE** | `EMA9 > EMA21` nel verso della rottura (l'**ordine**, non la pendenza) | variante |
| **E-FRESCO** | l'incrocio è avvenuto **nelle ultime 5 barre**, nel verso della rottura | variante |
| **E-BARRA** | l'incrocio è avvenuto **esattamente in `A+5`** — è l'ipotesi **letterale** di Claudio | variante |
| **S-INCLINATE** | come INCLINATE ma con **medie SEMPLICI** | variante |

**🔍 PERCHÉ L'INCLINAZIONE E NON L'INCROCIO — tre motivi, e nessuno è "mi
sembra":**
1. 🏠 **È la variante GIÀ SCRITTA IN CASA.** `REGISTRO_TEST.md` **riga 230** la
   elenca fra le regole d'ingresso **RICORRENTI**: *"ORB: si entra alla rottura
   del max/min… **SOLO se** (1) la candela chiude col corpo fuori dal range,
   (2) volumi ≥ 1,5× la media(20), **(3) medie 9/21 INCLINATE nella
   direzione**"*. **È una regola che circolava da mesi e non è mai stata
   misurata sull'oro.** Misurarla è esattamente il mandato: *cercare le manopole
   mai messe ad asse*.
2. ⏱️ **L'incrocio su M1 alle 15:36 arriva TARDI.** [INFERITO, non misurato]
   con lag EMA ≈ (N−1)/2 la 9 ritarda **~4 barre** e la 21 **~10**: in 4-5
   minuti l'incrocio spesso **non è ancora avvenuto**. Misurare come
   principale una condizione che quasi non si verifica vuol dire misurare il
   vuoto. **E il collaudo lo conferma già** (§2.5-bis).
3. 📚 **La caccia esterna non ha trovato NESSUNA evidenza misurata**
   sull'incrocio 9/21 su M1.

⚠️ **DA DIRE A CLAUDIO, perché cambia il significato del segnale:** alle 15:36
su M1 una media a **21 periodi guarda indietro fino alle ~15:15**, cioè **PRIMA
dell'apertura**. Quel 9/21 quindi **non descrive l'apertura**: descrive il
passaggio dal pre-apertura all'apertura. Sul grafico sembra un'altra cosa.

**La misura è un confronto a due gruppi: CON la condizione contro SENZA**,
sugli **stessi giorni** e con la **stessa geometria**. Se la mediana del
movimento a favore è la stessa, **l'incrocio non aggiunge niente e si scrive
così**. Se aggiunge, si dice **di quanto** e su **quante osservazioni**.
🚨 **E si misura anche NEI CONTROLLI**: se il 9/21 "funziona" pure alle 11:36,
allora stiamo misurando **le medie su M1**, non l'apertura. Lo strumento stampa
le due percentuali affiancate proprio per rendere impossibile confonderle.

### 2.5-bis ⚠️ IL RISCHIO CHE HO VISTO NEL COLLAUDO, e che dichiaro PRIMA
Sui 6 mesi di collaudo (**n=63 giorni con rottura — NON un risultato, è
idraulica**) le condizioni si accendono così:

| condizione | si accende su | commento |
|---|---:|---|
| **INCLINATE** | **86%** dei giorni con rottura | 🔴 **quasi sempre vera → non FILTRA: doppia la rottura** |
| E-ORDINE | 84% | idem |
| **S-INCLINATE** | **67%** | la più equilibrata fra le condizioni di stato |
| **E-FRESCO** | **37%** | 🟢 la partizione più leggibile |
| **E-BARRA** | **11%** (7 su 63) | 🟡 **conferma il motivo (2): l'incrocio nella barra è raro** |

👉 **Conseguenza messa nello strumento PRIMA di girarlo:** se un braccio del
confronto CON/SENZA ha meno di **100 osservazioni**, il confronto si stampa
**SOSPESO**, con scritto accanto che *"una condizione che si accende quasi
sempre non filtra: doppia con la rottura"*. **È il difetto più probabile di
questa ipotesi, e voglio che sia impossibile non vederlo.**

### 2.6 🔢 IL CONTO DELLE IPOTESI — perché senza questo si pesca
- **UNA sola ipotesi principale:** `APERTURA_NY × rottura T × 9/21 INCLINATE`,
  confrontata con `CTRL_QUIETO`. **È su questa che si dirà sì o no.**
- **6 varianti dichiarate:** rottura `C`, rottura `M`, `E-ORDINE`, `E-FRESCO`,
  `E-BARRA`, `S-INCLINATE`. Restano varianti **anche se vincono**.
- Tutto il resto è **descrizione**, non prova.
- 🔒 **DIFESA CONTRO LA PESCA — il campione è spezzato in due:**
  **IS 2006-03 → 2015-12** (~2.570 giornate) è dove si guarda;
  **OOS 2016-01 → 2020-05** (~1.155 giornate) è la **CASSAFORTE**.
  Lo strumento parte in `--fase is`; per aprire la cassaforte serve
  `--fase oos` **esplicito**, e il referto lo scrive in testa a caratteri
  grandi. Non è burocrazia: è l'unica cosa che distingue una misura da una
  caccia al numero bello.

### 2.7 🎯 IL CONTROLLO — **senza questo la misura non vale niente**
| gruppo | ancora | a cosa serve |
|---|---|---|
| `APERTURA_NY` | **09:30 America/New_York** | l'evento vero |
| `APERTURA_ROMA` | **15:30 Europe/Rome** | l'ora del collega, alla lettera |
| `CTRL_DOPO` | **10:30 New York** | un'ora **dopo** l'apertura: stessa seduta, stesso simbolo, **nessuna apertura** → separa *"è l'apertura"* da *"è un'ora viva"* |
| `CTRL_QUIETO` | **11:30 Europe/Rome** | i "11:36-11:41" chiesti: ora tranquilla |
| `CTRL_CASO` | **minuto a sorte 07:00-19:00 UTC**, uno per **ciascuno degli stessi giorni**, seme **20260910** | il **controllo APPAIATO** imposto dalla correzione del 05/09 (*il controllo non appaiato è artificialmente facile da battere: +6,7/+12,7 punti di edge apparente su 93.000 segnali*) |

**Ogni frequenza esce con la sua banda di rumore (±2 SE binomiali) e ogni delta
contro un controllo con la banda del delta**, etichettato meccanicamente
**DENTRO IL RUMORE** / **FUORI DAL RUMORE**. Così *"3 su 5 dello stesso colore"*
non può essere letto come un risultato se è quello che l'oro fa a qualunque ora.

### 2.8 📏 IL CAMPIONE — in OSSERVAZIONI, non in anni (Emendamento A)
| | numero |
|---|---:|
| giornate feriali con la finestra **completa** (11 barre) | ~**3.730** *(misurato 131/133 = **98,5%** sui 6 mesi di collaudo)* |
| di cui **IS 2006-2015** | ~**2.570** |
| di cui **OOS 2016-2020** | ~**1.155** |
| **giorni con una rottura** (il grilletto sfonda il range M5) | ⚠️ ~**48%** → IS ~**1.230**, OOS ~**555** *(stima da n=131 di collaudo: **indicativa**)* |
| banda 2 SE su una frequenza del 10% | IS **±1,7 pt** · OOS **±2,5 pt** |

🔴 **PAVIMENTO DICHIARATO PRIMA: sotto 400 giorni con rottura un gruppo si
stampa ma si legge come SOSPESO.** Con i numeri sopra ci si sta comodi — **e
quel ~52% di giornate senza rottura è già di per sé una risposta a Claudio:
l'operazione del collega, circa un giorno su due, non esiste.** (Da
riconfermare sul campione pieno: oggi è n=131.)

### 2.9 🔮 L'ATTESA DICHIARATA — scritta PRIMA, così i numeri possono smentirmi
| | previsione |
|---|---|
| **A. base** | 5 candele a testa e croce danno "tutte uguali" nel **6,25%**. Con la persistenza a raffica delle M1 mi aspetto **8-12% A QUALUNQUE ORA**, controlli compresi |
| **B. all'apertura** | 5/5 stesso colore fra il **10% e il 18%** = da **+2 a +6 punti** sopra il controllo quieto |
| **C. direzionale** | **≥4 su 5 nella direzione: 25-40%**. **INVERSIONE: 30-45%**, cioè **non rara** |
| **D. ampiezza** | MFE e MAE mediani all'apertura **2-4×** quelli dell'ora quieta, ma **simmetrici fra loro** (MFE entro ±20% del MAE) |
| **E. durata** | il MFE mediano arriva **entro il minuto 3-5** e poi si appiattisce → "3-4 candele" sarebbe sensato **sul piano della durata** |
| **F. 9/21** | delta della mediana MFE fra CON e SENZA **dentro il 15%**, e **simile nei controlli** → l'ordine delle medie racconterebbe la stessa persistenza che il colore già racconta |

### 🔄 AGGIORNAMENTO DELL'ATTESA — dichiarato, datato, con la fonte
*(10/09, dopo i fatti nuovi. Aggiorno la PREVISIONE, **non** i criteri: le
soglie restano quelle scritte sopra, e questo blocco è qui apposta perché si
veda che cosa ho cambiato e perché.)*

🔬 **Fatto nuovo che pesa più di ogni ragionamento: in archivio ci sono già
33 operazioni VERE di Claudio, a mano, in quella finestra** (XAUUSD, aperte
**14:35-14:40 server**, 19 giornate, magic 0):
**22 vinte su 33 = 66,7%**, e **−785,99 EUR netti**. Durata mediana **1,9
minuti**. Escursione mediana **1,41 $**.

> 🎯 **Vincere due volte su tre e perdere lo stesso è la firma del cancello di
> costo**, non della direzione. E rende la mia tesi **più probabile**, non meno.

Quindi correggo due previsioni, **prima** di vedere i numeri della sonda:
- **E (durata)** era *"il MFE mediano arriva entro il minuto 3-5"* →
  **la sposto a 1-3 minuti**, perché la durata mediana misurata sulle
  operazioni vere è **1,9 minuti**. ⚠️ Ma è un indizio **debole e sbilanciato**:
  33 operazioni, e la durata di un trade **chiuso a mano** dice quando Claudio
  è uscito, **non quando la spinta è finita**.
- **NUOVA, G (ampiezza contro il costo)**: escursione tipica dei 5 minuti
  **~1-1,5 $** contro un pavimento **DI LAVORO di 8,01 $** → prevedo che la
  quota di giornate che arrivano al pavimento sia **sotto il 5%**, e che il
  moltiplicatore necessario sia **fra 4× e 8×**.

> 🎯 **LA TESI CHE STO PROVANDO A FALSIFICARE:**
> **"l'apertura cambia l'AMPIEZZA, non la PERSISTENZA DELLA DIREZIONE."**
> Se i numeri mi smentiscono è un risultato **migliore** di uno che mi conferma.
> Se mi danno ragione, la conseguenza pratica è secca: **il colore non è il
> segnale, lo spazio lo è** — e allora tutto si sposta sul costo.

---

## 3. 🔧 LO STRUMENTO — pronto, collaudato, ASCII puro

**`backtest_pipeline/sonda_oro_apertura_m1.py`** ·
marcatore **`MARCATORE_SONDA_ORO_APERTURA_M1_v3`**

- **Solo libreria standard** (niente pandas/numpy/pip) → gira sull'**embeddable
  `C:\python313\python.exe`**. **ASCII puro.**
- **Tre formati letti, riconosciuti dalla prima riga**: Oanda/FutureSharks
  (`time,close,high,low,open,volume`), **HistData Generic ASCII**
  (`AAAAMMGG HHMMSS;o;h;l;c;v`, come chiesto), e il **"Formato 1" di casa**
  prodotto da `histdata_m1.py --converti`.
- **Streaming per giornata**: la RAM non dipende dalla lunghezza del campione.
- **Quattro modi**: `--autotest` · `--scarica` · `--sonda-dati` (copertura +
  orologio, **zero statistiche di comportamento**) · la misura completa.
- **Codici d'uscita**: `0` misurato · `1` misurato **con rilievi** · `2` **non
  partito** (dati assenti, formato ignoto, **orologio in contraddizione**).
- **Ogni riga di risultato dichiara la sua `n`**, e i controlli sono stampati
  **accanto** a quelli delle 15:36, non in un altro file.
- 💰 **Il COSTO PIENO MISURATO (`0,2003 $/oz`) è dentro come METRO**, non come
  deduzione: MFE e MAE restano **lordi** e i due pavimenti (**2,66 $** duro,
  **8,01 $** di lavoro) sono stampati accanto all'ampiezza, insieme a
  **quante volte più grande** dovrebbe essere il movimento mediano per
  arrivarci. Iniettabile con `--costo` se il numero cambia.
- 🔴 **In testa e in coda al referto c'è il riquadro dei limiti**: non è BCM,
  è OHLC non tick, **zero costi**, finisce nel 2020. *Un numero di qui è una
  MISURA DI OCCASIONI, mai un verdetto (F6).*

### ✅ Collaudi già fatti (in questo ambiente, non promessi)
| prova | esito |
|---|---|
| `--autotest` | 🟢 **14/14 OK** — ora legale USA vecchia **e** nuova su date note, ancore e giorni discordi, controllo casuale riproducibile, i 3 formati **con la trappola `C,H,L,O`**, conversione NY→UTC, giornata sintetica (k=5, MFE 0,60, MAE 0,10), profilo minuto per minuto, doji che spezza la serie, ambigua irrisolta, margine `k·R`, barra mancante = giorno escluso, medie 9/21 (ordine **e inclinazione**) in salita, in discesa e su serie piatta, bande 2 SE |
| `--sonda-dati` su 6 mesi reali | 🟢 **orologio CONFERMATO UTC** (−60 min), 174.278 barre, **0 righe scartate, 0 OHLC incoerenti**, 131/133 giornate complete |
| corsa completa su 6 mesi | 🟢 **nessun errore**, 767 righe di referto, tutte le sezioni prodotte, `exit 1` **corretto** (campione sotto il pavimento → gruppi SOSPESI) |

### 💰 IL COSTO IN TEMPO MACCHINA — misurato
| voce | costo |
|---|---|
| scarico 171 file (~275 MB), **una volta sola**, con cache | **~5-10 minuti** |
| lettura + misura, campione pieno (~5,0 M barre) | **~30 secondi** *(misurato: **210.000 barre M1/s**)* |
| programma completo: IS + OOS × 3 definizioni di rottura = **6 corse** | **~3-4 minuti** |
| **TOTALE** | 🟢 **sotto i 15 minuti** |

**Per confronto:** una griglia da 600 passate nel tester non la lancia nessuno.
**Questa risposta costa un quarto d'ora.** È l'argomento più forte per farla.

### 🚀 La riga di lancio proposta (passa dal cancello prima di arrivare a Claudio)
```
python3 backtest_pipeline/sonda_oro_apertura_m1.py --dati dati_oro_m1 --scarica --sonda-dati
python3 backtest_pipeline/sonda_oro_apertura_m1.py --dati dati_oro_m1 --fase is --out uscite_oro_apertura
```
E sul **secondo feed** (i CSV HistData 2018-2024, se si recuperano dal PC di
backtest), **stessa macchina, zero modifiche**:
```
python3 backtest_pipeline/sonda_oro_apertura_m1.py --dati dati_histdata_oro --fuso-file ny --fase tutto --out uscite_oro_histdata
```
🔴 **Prima corsa `--sonda-dati`**: se l'orologio non conferma, **la seconda non
si lancia**. E la cassaforte (`--fase oos`) si apre **solo dopo** che l'ipotesi
è scritta sull'IS.

---

## 4. 🎁 LE DUE CONSEGNE, separate — perché i padroni sono due

### 4.0 🔵 A COSA SERVE ADESSO QUESTA MISURA (riformulata il 10/09)
Il cancello di costo ha già dato il suo numero, quindi **questa misura NON
serve più a decidere se si opera su M1**. Serve a due cose, e sono queste:

| | la domanda | perché conta |
|---|---|---|
| **(a)** | **IL FENOMENO ESISTE?** L'oro va davvero in direzione nei 4-5 minuti dopo le 14:36 server, **oppure è come un'ora qualunque?** | 🎯 **È il pezzo più importante di tutto il lavoro, ed è per questo che il GRUPPO DI CONTROLLO non si toglie per fare prima.** Se il fenomeno **non** esiste, la risposta a Claudio è semplice e **chiusa**. Se **esiste**, non è morto: **è solo nel contenitore sbagliato** |
| **(b)** | **QUANTO VALE, IN DOLLARI?** ampiezza della candela M5 14:30-14:35 e del percorso nei minuti dopo, **mediana e quartili** | 🎯 dice **a quale TF quel movimento supera gli 8,01 $** del pavimento di lavoro. Il referto del costo indica **M30** come primo TF che passa (+9,7%, sottile) e **H1** come gradino robusto: **questa misura dà il moltiplicatore**, cioè quanto manca |

👉 **Detto in una riga: non sto misurando se si guadagna. Sto misurando se
esiste una cosa da mettere in un contenitore più grande.**


### 4.1 🖐️ Per la MANO di Claudio (numeri usabili a mercato aperto)
Lo strumento produce, per l'apertura **e per i controlli**:
1. **quante volte l'operazione esiste** (quota di giorni in cui il minuto delle
   15:35-15:36 sfonda davvero il range);
2. **quanto spesso la spinta continua** (k su 5 nella direzione, 5/5, ≥4/5) e
   **quanto spesso si gira** (inversione);
3. **quanto dura, minuto per minuto**, in dollari, e **in che minuto il
   massimo a favore arriva** (distribuzione, non media);
4. **quanto costa sbagliare**: **P80 del MAE** = lo stop che sopravvive
   all'80% delle escursioni contrarie;
5. **se il 9/21 aggiunge qualcosa**, e **di quanto**, con la sua `n`.

🔬 **E c'è già un campione VERO, ed è di Claudio.** In archivio, **33
operazioni a mano** su XAUUSD aperte **14:35-14:40 server** in 19 giornate
(magic 0): **22 vinte su 33 = 66,7%**, **−785,99 EUR netti**, durata mediana
**1,9 minuti**, escursione mediana **1,41 $**.
> 🎯 **Vincere due volte su tre e perdere lo stesso** è la firma del **cancello
> di costo**, non della direzione. **Il collega non ha torto sul fenomeno: la
> mano di Claudio ha davvero indovinato il lato 2 volte su 3.** Il conto lo
> rompe il pedaggio, non la lettura del grafico.
⚠️ n=33 è **piccolo** e le uscite sono **discrezionali**: dice quando Claudio è
uscito, non quando la spinta è finita. **Per questo serve la misura sistematica
su ~1.200 osservazioni.**

🔴 **E la riga che non salta:** **MANUALE NON VUOL DIRE ESENTE DAI CANCELLI.**
Il pedaggio lo paga anche la mano di Claudio, ed è **MISURATO**:
**0,2003 $/oncia** a giro completo — pavimenti **2,66 $** (duro) e **8,01 $**
(di lavoro) — `report/ORO_1530_CANCELLO_COSTO_2026-09-10.md`. Nello strumento
è il **metro** (`--costo`), stampato accanto all'ampiezza in **ogni** referto,
insieme a **quante volte più grande** dovrebbe essere il movimento mediano per
arrivare al pavimento.

⚠️ **E l'ordine di grandezza, dal collaudo** (n=131, **idraulica, NON un
risultato**): mediana del range dei 5 minuti **1,46 $** contro un pavimento di
lavoro di **8,01 $** → servirebbe un movimento **5,5 volte più grande**, e le
giornate che arrivano al pavimento sono **0 su 131**.
> 🎯 **Non è un verdetto: è una divisione.** E dice dove sta il problema —
> **non nel colore delle candele, ma nel contenitore.** Se il fenomeno esiste,
> vive a un TF dove il movimento supera il pedaggio, non su M1.

### 4.2 🤖 Per un EA (regole non ambigue, pronte a diventare file prova)
| voce | valore |
|---|---|
| **simbolo / TF** | XAUUSD · segnale su **M1** (setup letto come range di 5 M1) |
| **orario** | **14:30 ora SERVER** nelle settimane normali. 🔴 Ma se il segnale è l'apertura USA, l'ora va calcolata con la **regola DST americana**, perché per **~15-20 sedute l'anno** l'ora fissa arriva **60 minuti tardi** (§1.5) |
| **livelli** | `H0`/`L0` = massimo/minimo delle 5 barre M1 dalle 14:30 alle 14:35 server |
| **grilletto** | rottura di `H0`/`L0` **dentro la barra 14:35-14:36**; lato deciso dalla chiusura se sono rotti entrambi |
| **ingresso** | apertura della barra **14:36** |
| **stop** | **da fissare col P80 del MAE misurato**, e deve passare `stop ≥ 40 × costo` = **≥ 8,01 $** col numero **vero** (0,2003 $/oz, misurato). 🔴 Sul collaudo il P80 del MAE sta **sotto 1,5 $**: la strada per arrivare a 8,01 non è un parametro, **è un TF più grande** |
| **uscita** | 🔴 **da fissare col minuto di picco del MFE misurato**, non a occhio |
| **filtro 9/21** | 🔴 **si aggiunge SOLO se il confronto CON/SENZA lo giustifica** e **solo se non fa lo stesso effetto nei controlli** |

🚫 **Il file prova NON è stato scritto, ed è voluto.** Un file prova oggi
avrebbe stop, uscita e filtro **inventati**: si scrive **dopo** i numeri, non
prima. **Scriverlo adesso sarebbe esattamente il difetto che il progetto ha
pagato più caro.**

---

## 5. 🕳️ I BUCHI DICHIARATI — cosa manca per avere il numero

| buco | stato al 10/09 sera | come si chiude |
|---|---|---|
| ~~spread BCM sull'oro~~ | ✅ **CHIUSO OGGI**: costo pieno **0,2003 $/oz** (spread 0,1600 + commissione 0,0403). E con una scoperta: **sull'oro la commissione esiste, sugli indici è zero** | fatto — `ORO_1530_CANCELLO_COSTO_2026-09-10.md` |
| ~~HistData pubblica XAUUSD?~~ | ✅ **CHIUSO OGGI, da una misura di casa**: sì, e ne abbiamo già **2.432.995 barre M1 (2018-2024)**, validate a **0,0110%** contro BCM | fatto — `REFERTO_IMPORT_6_SIMBOLI.md` |
| 🔴 **profondità M1 di XAUUSD su BCM** | **`[NON MISURATO]`**. H1/D1 partono dal **2004.06.11**, ma la M1 è un'altra serie e **non è in quella riga** | **una lettura sul VPS** (`CopyRates` o la barra più vecchia sul grafico XAUUSD M1). **Non l'ho fatta: perimetro sola lettura, e non tocco i terminali in forward** |
| 🔴 **profondità TICK di XAUUSD su BCM** | **MAI MISURATA** (`misura_tick/` ha solo D30EUR, NASUSD, U30USD) | **nessun verdetto di merito** sull'oro è possibile finché manca (regola F6) |
| 🟠 **dove sono i CSV HistData 2018-2024** | lo zip veniva da `DESKTOP-H4D7CAJ`; **nel repository non ci sono** | se sono ancora sul PC di backtest, **lo strumento li legge come sono** (`--fuso-file ny`). Altrimenti si riscaricano: 3 righe in `histdata_m1.py` |
| 🟠 **il feed Oanda finisce nel 2020-05** | non copre 2021-2026 né l'oro sopra i 3.000 $ | **il secondo feed (2018-2024) copre metà del buco.** Il resto è prova di regime sul feed BCM |
| 🟠 **OHLC M1, non tick** | MFE/MAE sono **estremi raggiunti**, non esiti di un'uscita simulata (qui **non si simula nessuna uscita**) | dichiarato in ogni referto |
| 🟠 **Pepperstone / Tickmill come fonte oro** | mai sondate | opzione, non fatto |
| ⚠️ **la condizione 9/21 potrebbe non filtrare** | sul collaudo **INCLINATE si accende nell'86%** dei giorni con rottura | **guardia già dentro lo strumento**: braccio < 100 → confronto **SOSPESO** e scritto perché (§2.5-bis) |

### 🙋 Le cose che chiedo a Claudio (si è messo a disposizione)
1. 🔴 **La domanda che vale di più: quanto storico M1 ha BCM sull'oro?** Basta
   aprire il grafico **XAUUSD M1** sul terminale che preferisce e premere
   `Home` per andare all'inizio: la data della prima candela è la risposta. **Io
   non tocco i terminali in forward.** Se BCM ha M1 fino al 2004, la misura si
   può rifare **sul nostro feed**, e allora non è più "misura di occasioni":
   diventa un numero di casa.
2. 🟠 **I CSV HistData dell'oro sono ancora sul PC di backtest?** (cartella
   dell'import del 15/08, `import_esterno.zip`). Se sì, **risparmiamo uno
   scarico e guadagniamo gli anni 2021-2024**.
3. 🟡 **Il collega: da quanto lo fa, su che broker, e paga commissione
   sull'oro?** Se il suo broker ha **spread più stretto o zero commissione**, il
   suo conto torna e il nostro no — e quella **non è una differenza di lettura
   del grafico, è una differenza di pedaggio**. È l'informazione che i dati fino
   al 2020 non possono darci.

## 6. ✅ COSA HO TOCCATO

| | |
|---|---|
| EA toccati | **0** |
| parametri di forward sfiorati | **0** |
| terminali MT5 aperti / comandi al VPS | **0** |
| backtest lanciati | **0** |
| verdetti di strategia scritti | **0** *(non è il mio compito e senza numeri sarebbe aria)* |
| file nuovi | `backtest_pipeline/sonda_oro_apertura_m1.py` (v3) · questo dossier |
| dati scaricati | 6 mesi di collaudo (~10 MB) in cartella temporanea |

---

_Cercatore di parametri · 10/09/2026 · branch `lavoro`._
_Fonte dati: `github.com/FutureSharks/financial-data`, **GPL-3.0**, barre M1
Oanda — attribuzione dovuta, e i limiti sono scritti accanto a ogni numero._
