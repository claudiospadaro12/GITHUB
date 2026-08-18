# 🎯 ANALISI DEI DUE MODULI BASE ABTG — 41 lezioni, caccia alle risposte

**Data:** 18/08/2026 (sera) · **Fonte:** `trascrizioni_corso_2026-08-18/moduli_base/`
(21 lezioni **modulo PIATTAFORMA** + 20 lezioni **modulo ANALISI TECNICA**,
~35.000 parole, **lette integralmente, riga per riga**)
**Missione:** non una spec (sono moduli didattici) — **rispondere alle domande
aperte** accumulate dai cinque processi (Breakout · Mediazione · EasyTrend ·
FiboH4 · Media200 · PointBreak).

---

## 0. 🔴 LA RIGA CHE CONTA

> **Su 61 domande aperte censite nelle 5 spec + 5 analisi: 14 CHIUSE, 9 PARZIALI,
> 38 senza risposta** (di cui 26 **strutturalmente fuori portata** di un modulo
> didattico: report di backtest, fogli Excel, slide di altri moduli).
>
> **La chiusura più pesante è che il buco bloccante NON SI CHIUDERÀ MAI:**
> il modulo di Leonardo è stato **identificato** (è il capitolo indicatori del
> modulo Piattaforma, lez. 8-14) e **anche lì il SuperTrend viene applicato coi
> default, senza pronunciare un solo parametro**. La catena
> `Breakout → Mediazione → Leonardo` **termina qui, a vuoto**.
>
> **La seconda chiusura più pesante è il FUSO:** la piattaforma del corso è
> **MT4 del broker Black Ridge scaricata da bcmmarkets.com** — cioè **il nostro
> stesso broker** — ed è **settata sul GMT**: `[T]` _"da fine marzo a fine
> ottobre, qui la piattaforma sarà **due ore indietro** rispetto all'ora
> italiana"_. Un buco aperto in **3 spec su 5** ha finalmente un numero.

---

## 0-bis. 🎯 LE TRE RISPOSTE CHE CLAUDIO ASPETTA — secche, in testa

### ① IL RETTANGOLO: 15 o 20 candele? → ❌ **QUI NON C'È, E NON POTEVA ESSERCI**

**La lezione didattica NON scioglie il nodo, perché parla di un OGGETTO
DIVERSO** — e il corso stesso avverte, nella sua prima riga:

`[TRASCRITTO chiaro, lez. 10 an.tec. "IL RETTANGOLO"]`
> _"È molto importante **distinguere il rettangolo dallo strumento di disegno
> rettangolo** ... Il rettangolo è una specie di figura che va a fondere due
> figure insieme. **È la fusione di un doppio minimo e di un doppio massimo**"_

| | rettangolo **analisi tecnica** (lez. 10-11) | rettangolo **Breakout** (lez. 36-40) |
|---|---|---|
| cos'è | una **FIGURA a 4 punti**: top-bottom-top-bottom | una **FINESTRA MOBILE di N candele** |
| definito da | i **top e i bottom** (swing) | il **conteggio delle candele** |
| candele | ⛔ **mai contate, in due lezioni intere** | 15? 20? ← la domanda |

> ⛔ **VERDETTO: le ambiguità "15 o 20", "la candela di rottura conta",
> "almeno/al massimo" restano APERTE. Questa fonte non le tocca.**
> In due lezioni sul rettangolo-figura **non compare mai un conteggio di
> candele**: né 15, né 20, né altro.
> ⚠️ **E va detto a chi implementa: è tentante "spiegare" il 15-vs-20 col
> rettangolo-figura. NON SI PUÒ.** Sono due concetti distinti dello stesso
> corso, e confonderli produrrebbe un EA che cerca doppi massimi dove il
> Breakout conta candele. **Dettaglio in §3.1.**
>
> ✅ **UNA COSA PERÒ SI CHIUDE, ed è il terzo pezzo della domanda: WICK O
> CORPO.** `[T]` lez. 5 modulo base: _"nelle strategie noi prenderemo anche
> molto come riferimento **le ombre delle candele giapponesi, cioè il massimo e
> il minimo**"_ → **WICK**, convenzione generale dichiarata, coach diverso.
> Conferma la regola R5 del Breakout (§2.4).

### ② GLI ESEMPI BUY/SELL JPY (lez. 18-21): che strategia usano? → ❌ **NESSUNA**

**Non confermano i livelli del Breakout perché non applicano nessuna strategia.**
Il corso lo dichiara **tre volte**:
`[T]` lez. 19: _"**essendo puramente didattico**, continuiamo con questo
esempio"_ · _"**sarà poi la strategia che andrai a mettere in campo a determinare
l'esatto valore in pips**"_ · `[T]` lez. 21: _"la quantità di pips da aggiungere
o da sottrarre **sarà sempre dettata dalla strategia**"_

> ⛔ **I 20 pip di SL e 40 di TP sono numeri inventati per l'esercizio.** Il
> rapporto **1:2** NON è una regola del corso e **non va usato per arbitrare**
> fra l'1:3 del Breakout e l'1:1 di EasyTrend.
>
> ✅ **MA LE QUATTRO LEZIONI NON SONO SPRECATE — danno due cose che servono:**
> 1. **la convenzione di calcolo**: `SL = ingresso ∓ N pip` **esatto**, con la
>    cifra del punto **riportata invariata** (_"Il 7 lo riportiamo esattamente
>    così com'è perché rappresenta i punti"_) → **nessun arrotondamento esiste
>    nel corso**, quindi il **39→40** della lez. 37 Breakout è un **errore
>    individuale**, non una convenzione: **la scelta dell'EA (39 esatto) è
>    confermata** (§2.6);
> 2. **due dei quattro test-case sul pip JPY** (§2.3), aritmetica verificata al
>    centesimo su tutti e quattro.

### ③ IL FUSO DELLA PIATTAFORMA DEL CORSO → ✅ **DETTATO, e il broker è IL NOSTRO**

`[TRASCRITTO chiaro, lez. 3 piatt.]`
> _"Questa è una piattaforma che, scaricata dal broker **BlackRidge**, **non dà
> l'ora italiana, cioè è settata sostanzialmente sul GMT** ... **e non può essere
> modificata questo orario** ... da fine marzo a fine ottobre **la piattaforma
> sarà DUE ORE INDIETRO rispetto all'ora italiana**; ... da fine ottobre a fine
> marzo ... **UN'ORA INDIETRO**"_

`[TRASCRITTO chiaro, lez. 2 piatt.]` _"il nome del broker che noi utilizziamo è
**Black Ridge** ... dovrai semplicemente scrivere **bcmmarkets.com**"_

> 🔥 **`bcmmarkets.com` È IL NOSTRO BROKER** — conto demo del progetto
> `50503392 — BCMMarkets-Server — BCM Markets Ltd`. **Il corso e noi operiamo
> sullo stesso broker**: su H4 le barre del relatore e le nostre **hanno lo
> stesso taglio** (chiude un'assunzione della spec Media200).
>
> ⚠️ **E RESTA UNO SCARTO DI UN'ORA DA MISURARE:** il corso dice **GMT** (agosto
> = IT−2 = UTC+0), il repo dice **BCM = IT−1 = UTC+1**. **Non tornano.**
> ➡️ **Screenshot con l'orologio di Windows e la "Vista del mercato" di MT4/MT5
> nella stessa foto.** 5 secondi, e chiude il buco del fuso di **3 spec su 5**.
> **Dettaglio e implicazioni in §2.5.**

---

## 1. 📋 TABELLA MASTER — domanda aperta → esito

Legenda: ✅ chiusa · 🟡 parziale · ❌ non trovata · 🚫 fuori portata di un modulo
didattico (report/Excel/slide di altri moduli: qui non potevano esserci)

### 1.1 BREAKOUT (`prove/BREAKOUT_CORSO_SPEC.md` §11, §13, §14)

| # | domanda aperta | esito | dove |
|---|---|---|---|
| B1 | 🔴 **Parametri SuperTrend (ATR + moltiplicatore)** — BLOCCANTE | ✅ **CHIUSA IN NEGATIVO, definitivamente** | lez. **10 piatt.** — §2.1 |
| B2 | 🔴 **Periodo del Williams %R: 140 o 14?** | ✅ **CHIUSA: 140**, 5ª occorrenza, coach diverso, forma imperativa | lez. **13 piatt.** — §2.2 |
| B3 | Rettangolo: 15 o 20 candele | ❌ **falso amico** — il "rettangolo" dell'analisi tecnica è un'ALTRA cosa | §3.1 |
| B4 | "almeno 20" o "al massimo 20" | ❌ idem | §3.1 |
| B5 | La candela di rottura sta dentro il rettangolo? | ❌ idem | §3.1 |
| B6 | Estremi **wick o corpo**? | ✅ **CHIUSA: WICK** — convenzione dichiarata del corso | lez. **5 piatt.** — §2.4 |
| B7 | Obbligo delle 20 candele dall'ingresso in zona | ❌ non trovata | — |
| B8 | 🔴 Rischio **1% per operazione** o **complessivo**? | ❌ non trovata — ma **l'indirizzo esiste**: modulo Money Management, §7.2 | — |
| B9 | Max posizioni contemporanee sui 7 cross | ❌ non trovata | — |
| B10 | Correlazione fra i 7 cross JPY | ❌ non trovata (mai nominata in 41 lezioni) | — |
| B11 | Filtro spread | 🟡 **parziale**: lo spread è spiegato e **dichiarato irrilevante** | lez. **16 piatt.** — §4.6 |
| B12 | Filtro news | 🟡 **parziale, ed è una POSIZIONE**: il corso insegna a ignorare la macro | lez. **3 an.tec.** — §5.4 |
| B13 | Cap di perdita giornaliera | ❌ non trovata | — |
| B14 | Nuovo segnale con posizione già aperta | ❌ non trovata | — |
| B15 | Scadenza del setup | ❌ non trovata | — |
| B16 | **Definizione di pip su JPY** | ✅ **CHIUSA**, 4 fonti nello stesso modulo | lez. **6, 11, 19, 21 piatt.** — §2.3 |
| B17 | Gap / slippage oltre lo stop | ❌ non trovata | — |
| B18 | Direzione del fuso della piattaforma | ✅ **CHIUSA: GMT** (IT−2 estate / IT−1 inverno) | lez. **3 piatt.** — §2.5 |
| B19 | 🔴 **Il "modulo precedente" — quale è?** | ✅ **CHIUSA: capitolo indicatori del modulo Piattaforma (Fasciano)** | lez. **8-14 piatt.** — §2.1 |
| B20 | L'arrotondamento **39-vs-40 pip** | ✅ **CHIUSA contro il corso**: nessun arrotondamento è previsto | lez. **18-21 piatt.** — §2.6 |
| B21 | N op / win rate / broker / date del backtest lez. 39 | 🚫 fuori portata | — |
| B22 | Sorgente di `BREAKOUT_EA_JPY_v3` | 🚫 fuori portata (è roba nostra) | — |

### 1.2 EASY TREND (`prove/EASYTREND_CORSO_SPEC.md` §10, §13)

| # | domanda aperta | esito | dove |
|---|---|---|---|
| E1 | 🔴 **Parametri Linear Regression Candles** — BLOCCANTE | ❌ non trovata (indicatore mai nominato nei moduli base) | — |
| E2 | 🔴 **Parametri CCI Divergences (CCI + pivot)** — BLOCCANTE | 🟡 **DUE PARZIALI, e vanno contro le nostre assunzioni** | lez. **13 piatt.** + **4 an.tec.** — §2.7 |
| E3 | 🔴 **Il FUSO della fascia 8-18** | 🟡 **parziale e pesante**: la piattaforma del corso è GMT | lez. **3 piatt.** — §2.5 |
| E4 | Scadenza dell'ordine pendente | ❌ non trovata | — |
| E5 | Scadenza della divergenza in attesa del taglio | ❌ non trovata | — |
| E6 | Max posizioni contemporanee | ❌ non trovata | — |
| E7 | Nuova divergenza a posizione aperta | ❌ non trovata | — |
| E8 | Filtro spread | 🟡 come B11 | §4.6 |
| E9 | Filtro news | 🟡 come B12 | §5.4 |
| E10 | Cap di perdita giornaliera | ❌ non trovata | — |
| E11 | Tetto di drawdown | ❌ non trovata | — |
| E12 | Definizione di pip | ✅ **CHIUSA** (= B16) | §2.3 |
| E13 | Broker / date / operazioni del backtest lez. 17 | 🚫 fuori portata | — |
| E14 | EURCAD: il "68%" è profitto o drawdown? | 🚫 fuori portata | — |
| E15 | Esiste un PDF riepilogativo del capitolo? | ❌ non trovata | — |
| E16 | Cosa vuol dire "taglia" / "sotto il plot" | ❌ non trovata | — |
| E17 | Le 18 sono incluse? 10 o 11 candele? | ❌ non trovata | — |
| E18 | La divergenza muore se fallisce R4/R5? | ❌ non trovata | — |

### 1.3 FIBO H4 (`prove/FIBOH4_CORSO_SPEC.md` §13, §14)

| # | domanda aperta | esito | dove |
|---|---|---|---|
| F1 | 🔴 Le SLIDE del modulo | 🚫 fuori portata | — |
| F2 | 🔴 Screenshot del Fibo con la linea "100" | 🚫 fuori portata | — |
| F3 | 🔴 **Il fuso della piattaforma** | ✅ **CHIUSA per la piattaforma** (GMT), 🟡 aperta per gli orari | lez. **3 piatt.** — §2.5 |
| F4 | 🟠 Le _"lezioni e capitoli precedenti"_ sullo stop loss | ✅ **CHIUSA come indirizzo — e l'indirizzo è VUOTO di numeri** | lez. **15-21 piatt.** — §3.3 |
| F5 | 🟠 Quale % di rischio insegna il relatore | ❌ non trovata — ma **l'indirizzo esiste**: Money Management | §7.2 |
| F6 | 🟠 Pannello Fibo con le 4 descrizioni | ❌ **non trovata, e il corso lo dice esplicitamente** | lez. **14 piatt.** — §4.4 |
| F7 | 🟠 Prezzi/date degli esempi | 🚫 fuori portata | — |
| F8 | Ancoraggi (a) o (b) del range | ❌ non trovata | — |
| F9 | Definizione di "fase laterale" | ✅ **CHIUSA: definizione formale dettata** | lez. **4 an.tec.** — §2.8 |
| F10 | Soglia dello "spike su dato macro" | ❌ non trovata | — |
| F11 | Soglia "candele molto ampie" | 🟡 **parziale**: l'ATR è **lo strumento** che il corso insegna per misurarlo | lez. **11 piatt.** — §4.2 |

### 1.4 MEDIA 200 (`prove/MEDIA200_CORSO_SPEC.md` §15)

| # | domanda aperta | esito | dove |
|---|---|---|---|
| M1 | 🔴 Le SLIDE | 🚫 fuori portata | — |
| M2 | 🔴 Esempio grafico di "spike" / "candela piena" | ❌ non trovata | — |
| M3 | 🔴 La % di rischio | ❌ non trovata — indirizzo: Money Management | §7.2 |
| M4 | 🟠 **Fuso della piattaforma + allineamento candele H4** | ✅ **CHIUSA, ed è la risposta più utile di tutte per H4** | lez. **3+2 piatt.** — §2.5 |
| M5 | 🟠 Pannello Moving Average (EMA/close) e ATR | 🟡 **parziale: "applicata alla chiusura della candela"** dettato | lez. **9, 11 piatt.** — §4.1 |
| M6 | 🟠 Prezzi/date degli esempi | 🚫 fuori portata | — |
| M7 | 🟠 Esiste un backtest di questa strategia? | 🚫 fuori portata | — |

### 1.5 MEDIAZIONE (`prove/MEDIAZIONE_CORSO_SPEC.md` §11-12 · analisi §1.12)

| # | domanda aperta | esito | dove |
|---|---|---|---|
| Z1 | 🔴 **Parametri SuperTrend** | ✅ **CHIUSA IN NEGATIVO** (= B1) | §2.1 |
| Z2 | 🔴 Fattore 2,29 seme-volume / capitale | 🚫 fuori portata (è il file Excel) | — |
| Z3 | 🔴 Win rate del backtest | 🚫 fuori portata | — |
| Z4 | N op / date / broker / spread del backtest | 🚫 fuori portata | — |
| Z5 | Filtro orario / sessioni | ❌ non trovata | — |
| Z6 | Filtro news | 🟡 come B12 | §5.4 |
| Z7 | Cap di pacchetti simultanei | ❌ non trovata | — |
| Z8 | Geometria della riapertura dopo stop | ❌ non trovata | — |
| Z9 | Scadenza dei pendenti | ❌ non trovata | — |
| Z10 | Anno degli esempi | 🚫 fuori portata | — |
| Z11 | **Passo di volume / lotto minimo del broker del corso** | 🟡 **parziale: il broker è identificato** (Black Ridge / BCM) | lez. **2 piatt.** — §2.5 |
| Z12 | 🔴 Tetto DD: 20% o 3%? | ❌ non trovata | — |
| Z13 | 🔴 Chiusura anticipata: Williams o segnale completo? | ❌ non trovata | — |
| Z14 | 🔴🔴 **Chi è "Leonardo"?** | ✅ **CHIUSA: Leonardo Fasciano, capitolo indicatori** | lez. **8 piatt.** — §2.1 |

### 1.6 POINT BREAK / PIANO DI CHRISTIAN (`ANALISI_POINTBREAK_2026-08-18.md` §5)

| # | domanda aperta | esito | dove |
|---|---|---|---|
| P1 | 🔴 In che fuso è scritto il PIANO DI TRADING? | ❌ non trovata (fonte diversa, coach diverso) | — |
| P2 | 🥇 Esiste una lezione sulle correlazioni? | ❌ **non trovata — e in 41 lezioni la parola non compare mai** | §5.3 |
| P3 | 🔴 **Quale oscillatore: Stocastico 5/3/3 o custom?** | 🟡 **parziale, ed è una CONTRADDIZIONE: il corso base insegna 14/3/3** | lez. **12 piatt.** — §5.2 |
| P4 | ADR `ImpPeriods: 50` | ❌ non trovata | — |
| P5 | Bollinger **37 / 1.4** | ❌ **non trovata, e il corso lo dice esplicitamente** | lez. **14 piatt.** — §4.4 |

---

## 2. ✅ LE CHIUSURE, PER ESTESO (con la citazione che le prova)

### 2.1 🔴🔴 LA PIÙ PESANTE — la catena del SuperTrend TERMINA A VUOTO

**Due fatti, uniti, chiudono un dossier aperto da due giorni.**

**Fatto 1 — il "modulo di Leonardo" è questo.** `[TRASCRITTO, lez. 8 piatt.]`
> _"**Sono Leonardo Fasciano**, coach in area trading in Alfio Bardolla Training
> Group e in questo capitolo andremo insieme a comprendere come il prezzo si
> muove nei grafici che utilizzeremo appunto sulla MetaTrader 4 ... **Ogni
> strategia utilizzerà determinati indicatori**"_

E la lezione precedente lo annuncia: `[TRASCRITTO, lez. 7 piatt.]`
> _"nel prossimo capitolo conoscerai un nuovo coach che si chiama **Leonardo
> Fasciano** e che comincerà a introdurti gli strumenti che possiamo applicare
> alla piattaforma sul prezzo, cioè degli indicatori ... **che poi saranno
> funzionali per l'applicazione delle strategie** che vedremo nei capitoli
> successivi"_

➡️ Il capitolo **lez. 8-14 del modulo Piattaforma** è **esattamente** ciò a cui
rimandano `Breakout lez. 35` (_"Lo abbiamo fatto nel modulo precedente"_) e
`Mediazione lez. 26` (_"il setup che voi avete già sicuramente costruito
**insieme a Leonardo** in precedenza"_). È lì che SuperTrend e Williams %R
vengono installati. **La catena `[I]` della spec Breakout §3.3 è confermata e
la sua ultima maglia è ora in mano nostra.**

**Fatto 2 — e in quel capitolo il SuperTrend viene applicato COI DEFAULT.**
`[TRASCRITTO chiaro, lez. 10 piatt., integrale]`
> _"L'indicatore super trend ha degli input, cioè ha dei **parametri
> modificabili**, che anche in questo caso, ti ricordo, sono **parametri che
> andrai a settare sulla base della strategia che andrai ad applicare**.
> **Facciamo ok senza fare nessuna variazione**, quindi semplicemente applicando
> l'indicatore, e quello che vedremo, eccolo qui, sarà una linea verde o una
> linea rossa"_

> 🔴 **VERDETTO: il buco n.1 del Breakout e della Mediazione NON È UN BUCO DI
> COPERTURA — È UN BUCO DEL CORSO.** Non esiste una lezione mancante da
> chiedere. Il modulo che doveva dettare i parametri **dichiara esplicitamente
> di non dettarli** e rimanda alla strategia; la strategia (Breakout 34-40,
> Mediazione 26-33) rimanda al modulo. **È un rimando circolare, e il corso non
> lo chiude in nessun punto.**
>
> ✅ **Conseguenza per noi: la decisione di Claudio del 18/08 (ATR 10 /
> moltiplicatore 3,0 come assunzione dichiarata) resta l'unica praticabile, e
> ora è motivata da una fonte invece che da una mancanza.** L'ipotesi C del
> referto Breakout (parametri SuperTrend diversi da quelli nostri) è
> **definitivamente chiusa**.

**🆕 MA C'È UNA VIA D'USCITA CHE NESSUNO AVEVA VISTO — ed è a costo zero.**
`[TRASCRITTO chiaro, lez. 10 piatt.]`
> _"ti farò vedere come inserire l'indicatore super trend ... questo indicatore
> che ti ricordo **troverai sotto questo video in un formato scaricabile** ...
> Una volta che avrai scaricato questo piccolo file che si chiama super trend
> ... **Il formato .ex4** ... andiamo nella cartella mql4 ... nella sezione
> indicatori"_

> 🥇 **Il SuperTrend del corso è un `.ex4` SPECIFICO, allegato alla lezione 10 —
> e il coach lo applica premendo OK senza toccare nulla. Quindi i DEFAULT DI
> QUEL FILE *SONO* i parametri del corso.**
> ➡️ **DOMANDA N.1 PER CLAUDIO (nuova, e sblocca tutto):** scaricare il file
> `super trend.ex4` dall'area corso sotto la lezione 10 del modulo Piattaforma,
> trascinarlo su un grafico e **fotografare la finestra degli input**. Non
> serve un riascolto, non serve una trascrizione: sono tre click, e chiudono
> l'unico buco bloccante di **DUE** strategie.

---

### 2.2 ✅ WILLIAMS %R = 140 PERIODI — la conferma che chiude il nodo

`[TRASCRITTO chiaro, lez. 13 piatt., integrale]`
> _"Insert, Indicator, andiamo su Oscillatori e inseriamo il Williams Percent
> Range. In questo caso **ti consiglio di settarlo a 140 periodi, quindi dove
> troverai la voce Period modifica e scrivi 140**, che sarà **funzionale per la
> strategia che imparerai nel corso del Master**. ... **140 periodi è sicuramente
> un valore molto alto per questo tipo di indicatore**, però, come ti dicevo
> all'inizio, ogni indicatore ha il suo particolare settaggio sulla base della
> strategia che andrai ad analizzare."_

> ✅ **QUESTA CITAZIONE UCCIDE L'IPOTESI "storpiatura speech-to-text 14→140",
> e la uccide in tre modi indipendenti nella stessa frase:**
> 1. **è un'istruzione di digitazione**: _"dove troverai la voce Period modifica
>    e **scrivi 140**"_ — non un numero letto di sfuggita;
> 2. **il relatore commenta il valore come anomalo**: _"140 periodi è sicuramente
>    un valore **molto alto** per questo tipo di indicatore"_ — un errore di
>    trascrizione non produce un commento coerente sull'anomalia del numero;
> 3. **dichiara lo scopo**: _"funzionale per **la strategia** che imparerai nel
>    corso del Master"_ — cioè Breakout/Mediazione.
>
> 📊 **Conteggio delle occorrenze, aggiornato: CINQUE, su TRE moduli e DUE
> coach.** Mediazione lez. 26 (×2), 27, 33 (PDF) `[Manuela Negro]` · Breakout
> lez. 35 `[Manuela Negro]` · **Piattaforma lez. 13 `[Leonardo Fasciano]`**.
> ⚠️ **Onestà sulla convergenza:** le prime quattro sono **la stessa fonte**
> (Negro). Questa è **la prima indipendente**. Il §3.2 della spec Breakout
> ("SINGOLA FONTE, da confermare") **è ufficialmente superato.**

**Bonus dalla stessa lezione:** `[TRASCRITTO]` il Williams _"va a ricalcare
l'andamento del prezzo"_ e l'ipotesi operativa è _"quando il prezzo arriva ad un
valore di ipercomprato, potrebbe tendenzialmente esaurire la sua corsa
rialzista per poi invertire"_ — **la logica contrarian del Breakout è dichiarata
già nel modulo base.**

---

### 2.3 ✅ IL PIP SU JPY — chiuso con 4 fonti nello stesso modulo

Buco n.10 del Breakout e n.11 di EasyTrend. `[TRASCRITTO chiaro, lez. 6 piatt.]`
> _"in tutti i tassi di cambio in cui non c'è lo yen, **il punto è la quinta, ...
> la quarta è il pip** ... Nei tassi di cambio invece in cui è presente lo yen ...
> **qui abbiamo solo tre cifre decimali** ... quella scritta in piccolino è il
> punto, questa invece è il pip ... **l'ultima è il punto, la penultima è il
> pip** ... ricordati che **dieci punti equivalgono a un pip**"_

E la **convenzione di linguaggio di tutto il corso**, dettata:
> _"**io e gli altri coach ci riferiremo al grafico parlando di pip**, ma ripeto,
> **la piattaforma ragiona in punti**"_

**Le altre tre conferme:**
- `[T]` lez. 11 (ATR): _"tutti i cross che non contengono il [J]PY ... [terza e
  quarta cifra] ... Mentre ... su AUD-[J]PY ... **soltanto le prime due cifre
  dopo la virgola** ... **0,16, ovvero 16 pips**"_
- `[T]` lez. 19 (esempio BUY JPY): _"sui tassi di cambio che comprendono il JPY
  ... **l'unità di pips come la seconda cifra dopo la virgola**"_ — e
  l'aritmetica chiude: 165,90 − 0,20 = 165,70 · +0,40 = 166,30 ✅
- `[T]` lez. 21 (esempio SELL JPY): 165,92 + 0,20 = 166,12 · −0,40 = 165,52 ✅

> ✅ **Per l'EA: 1 pip su JPY = 0,010 = 10 punti su broker a 3 decimali.**
> Lo "1 pip oltre il rettangolo" del Breakout = **10 punti**; i "3 pip" di
> EasyTrend = **30 punti**. Non è più un'inferenza dall'aritmetica di un
> esempio: è **dettato**, quattro volte.

---

### 2.4 ✅ WICK O CORPO — la convenzione è dichiarata, ed è WICK

`[TRASCRITTO chiaro, lez. 5 piatt.]`
> _"ecco perché **nelle strategie noi prenderemo anche molto come riferimento le
> ombre delle candele giapponesi, cioè il massimo e il minimo**, perché saranno
> dei riferimenti importanti per capire come si è mosso il prezzo"_

E, sempre nella stessa lezione, la scelta di rappresentazione, dettata per
**tutto** il master:
> _"per tutto quello che noi faremo in questo master e **per tutte le strategie**
> che andremo ad applicare noi sostanzialmente utilizzeremo ... **il grafico a
> candele giapponesi**"_

> ✅ Conferma la regola **R5** del Breakout (_"estremi di wick, non di corpo"_)
> **da una fonte indipendente e generale**. Vale come default di casa per
> qualunque livello preso da questo corso, salvo smentita esplicita della
> singola strategia.

---

### 2.5 ✅ IL FUSO — e la scoperta che il broker del corso È IL NOSTRO

**Domanda aperta in 3 spec su 5** (FiboH4 §2.1, Media200 §7, EasyTrend §2.2).

`[TRASCRITTO chiaro, lez. 3 piatt., integrale]`
> _"Poi c'è qui la sezione vista del mercato ... dove tra l'altro **vedi l'orario
> della piattaforma**. ... Questa è una piattaforma che, scaricata dal broker
> **BlackRidge**, **non dà l'ora italiana, cioè è settata sostanzialmente sul
> GMT**. ... **e non può essere modificata questo orario, così resta** ...
> Ricorda semplicemente che l'orario che vedrai in alto a sinistra ... quando in
> Italia [c'è] l'ora legale, quindi **da fine marzo a fine ottobre, qui la
> piattaforma sarà DUE ORE INDIETRO rispetto all'ora italiana**. Quando invece in
> Italia [c'è] l'ora solare, quindi **da fine ottobre a fine marzo, la
> piattaforma risulterà UN'ORA INDIETRO** rispetto all'ora italiana."_

**E il broker, dettato:** `[TRASCRITTO chiaro, lez. 2 piatt.]`
> _"il nome del broker che noi utilizziamo è **Black Ridge**, il nome della
> piattaforma su cui operiamo è **MetaTrader 4** ... dovrai semplicemente
> scrivere **bcmmarkets.com** ... andiamo su blackridge, questo, **demo, demo 1**,
> questo è il server ... ti ritroverai **saldo 10.000 euro**"_

> 🔥 **`bcmmarkets.com` È IL NOSTRO BROKER.** Il conto demo del progetto è
> `50503392 — **BCMMarkets-Server** — BCM Markets Ltd`
> (`report/CENSIMENTO_ORDINI_PC.md` riga 194). **Il corso e noi operiamo sullo
> stesso broker.** Non era mai stato messo agli atti.
> ➡️ **Implicazione forte per H4/D1:** l'allineamento delle candele del corso e
> il nostro **sono lo stesso** (buco n.7 di `MEDIA200_CORSO_SPEC` §14: _"e
> l'allineamento delle candele H4 dipende dal broker"_). **Non è più un'ipotesi
> da dichiarare: è misurabile su un grafico.**

> ⚠️ **MA C'È UNO SCARTO DI UN'ORA CHE VA MISURATO, NON ASSUNTO.**
> Il corso dice **GMT fisso** → in agosto = **ora italiana − 2 = UTC+0**.
> Il repo dice (`CLAUDE.md`, `HANDOFF.md` riga 496, `PIANO_PROP` riga 170)
> **BCM = ora italiana − 1 = UTC+1 in agosto**.
> **Le due cose non tornano.** Tre letture possibili, e solo una misura decide:
> (a) `BlackRidge-Demo 1` ≠ `BCMMarkets-Server` (due server della stessa casa
> con offset diversi); (b) il video è vecchio e il server è cambiato;
> (c) uno dei due enunciati è impreciso.
> ➡️ **DOMANDA N.2 PER CLAUDIO:** uno screenshot con **l'orologio di Windows e
> l'orologio "Vista del mercato" di MT4/MT5 nella stessa foto** (metodo già di
> casa, `CLAUDE.md` §"Ora dei LOG"). Chiude in 5 secondi.

**E la contraddizione interna, agli atti:** nella **stessa lezione 3** il coach
dice prima _"Questa cosa, ripeto, **impatterà** in un modo che ti verrà spiegato
quando si tratterà di applicare le strategie"_ e sei righe dopo _"**non avrà
nessun impatto** nella nostra operatività in nessun modo"_. `[INCERTO]` — la
lettura più economica è: *non devi cambiare nulla sulla piattaforma (non si
può), ma quando una strategia ti darà un orario dovrai sapere in che orologio è
scritto*. **Il corso promette la spiegazione e, nelle 8 lezioni di FiboH4 +
Media200 già trascritte, non la mantiene mai.**

> 📐 **Cosa cambia operativamente, se gli orari delle strategie sono in ORA
> PIATTAFORMA** `[IPOTESI, non dimostrata]`:
> FiboH4 cancellazione pendenti **18:45 piattaforma = 20:45 IT = 19:45 BCM**,
> contro il **17:45 BCM** cablato oggi in `ABTG_FiboH4_Multi.mq5`
> (`InpCutoffHour=17`, `InpCutoffMin=45`). **Due ore di scarto.**
> 🚫 **NESSUNA MODIFICA PROPOSTA OGGI**: l'assunzione attuale ("sono orari da
> parete italiani, è la routine del relatore") resta **altrettanto plausibile**,
> perché il relatore del FiboH4 parla di _"mi alzo alle 7"_. **È esattamente un
> A/B da misurare**, e ora ha due candidati con un numero ciascuno invece di
> uno solo.

---

### 2.6 ✅ LE CONVENZIONI DI CALCOLO SL/TP — e il verdetto sul 39-vs-40

Le lez. 18-21 sono **quattro esempi numerici completi**, tutti col foglio Excel.
La convenzione, dettata due volte:

`[TRASCRITTO chiaro, lez. 18 piatt.]`
> _"prendiamo il valore di ingresso iniziale, in questo caso selezionando la
> casella C8, facciamo **meno 0,0020, quindi sono 20 pips** ... **Il 7 lo
> riportiamo esattamente così com'è perché rappresenta i punti, non ci
> interessano**"_

`[TRASCRITTO chiaro, lez. 21 piatt.]`
> _"Ti ricordo che **la terza cifra dopo la virgola è il punto e quindi ti
> consiglio di ignorarla** in questo caso perché non è assolutamente
> rappresentativa di un movimento interessante, quindi **lasciamolo pure così
> com'è**"_

**Le quattro aritmetiche, verificate al centesimo:**

| lez. | cross | ingresso | SL (−/+20 pip) | TP (+/−40 pip) | ✓ |
|---|---|---|---|---|---|
| 18 | EURUSD buy | 1,07857 | 1,07657 | 1,08257 | ✅ |
| 19 | EURJPY buy | 165,90 | 165,70 | 166,30 | ✅ |
| 20 | EURUSD sell | 1,07816 | 1,08016 | 1,07416 | ✅ |
| 21 | EURJPY sell | 165,92 | 166,12 | 165,52 | ✅ |

> ✅ **La convenzione del corso è: `SL = ingresso ∓ N pip` ESATTO, con la cifra
> del punto RIPORTATA INVARIATA. Nessun arrotondamento al pip intero è previsto,
> mai, in nessuno dei quattro esempi.**
>
> 🎯 **Verdetto sul caso 39-vs-40** (`BREAKOUT_CORSO_SPEC` §6.2, correzione R82):
> il `155,96 − 155,57 = 0,39` arrotondato a `0,40` dalla relatrice **NON è una
> convenzione del corso**. Il modulo base non prevede alcun arrotondamento, e
> comunque 39 pip è un valore **già intero** (non è una questione di sub-pip).
> **È un errore aritmetico individuale.** ✅ **La scelta di
> `ABTG_BreakoutCorso` — usare il valore esatto (39 → TP 154,40) — è
> CONFERMATA dalla convenzione del corso, non solo dalla matematica.**

**Un dettaglio in più, e va segnalato perché è una trappola per l'EA:**
`[TRASCRITTO, lez. 18]` _"Ti ricordo che **418**, il valore che stai leggendo
nella voce pips, **sono i punti** che corrisponderanno a **41 pips** ... quindi
sarà a 400 anziché 40"_. Il relatore legge **418 punti = "41 pips"**: tronca,
non arrotonda (41,8 → 41). `[TRASCRITTO dubbio]` sull'intenzione — potrebbe
essere una lettura approssimativa a voce. **Non lo eleggo a regola:** è il tipo
di dettaglio che va deciso in implementazione e dichiarato.

---

### 2.7 🟡 EASY TREND — due parziali che vanno CONTRO le nostre assunzioni

Il modulo base **nomina esplicitamente il CCI come indicatore di una strategia
del master** — ed EasyTrend è l'unica che lo usa. `[TRASCRITTO chiaro, lez. 13]`
> _"L'indicatore CCI nasce come indicatore per lo studio delle commodity ... In
> questo caso, però, **lo andremo ad inserire soltanto perché è frutto dello
> studio di una strategia che vedrai nel corso del master, che prevede appunto
> l'utilizzo di questo indicatore** ... Quindi aggiungiamo anche questo
> indicatore, **facciamo ok, settaggio a 14 periodi** ... **queste due linee
> centrali, che corrispondono ai valori di 100 e valori di meno 100** ...
> quando l'indicatore tende a rientrare in questa fascia centrale ... siamo
> potenzialmente in una zona di inversione"_

> 🟡 **PARZIALE n.1 — il CCI del corso è a 14 periodi (default), non 20.**
> ⚠️ **Caveat onesto, e pesa:** il modulo base è **MT4**, EasyTrend gira su
> **TradingView** con lo script _"CCI Divergences" (TISTA)_. Non è lo stesso
> oggetto. **Ma è l'unico numero che il corso pronuncia per il CCI**, e la
> nostra assunzione era **20**. → **entra nell'A/B come candidato primario.**

**PARZIALE n.2 — il pivot.** La definizione di swing del corso, dettata:
`[TRASCRITTO chiaro, lez. 4 an.tec.]`
> _"Prendiamo tre candele, tale che quella centrale è più alta di quelle laterali
> ... il **top** è il massimo più alto di tutti e tre ... il massimo di un piccolo
> trend, formato da **due, meglio ancora tre**, candele rialziste che poi hanno
> **due, meglio ancora tre**, candele ribassiste successive"_

> 🟡 **Il "pivot" del corso è 2-3 barre per lato, simmetrico.** La nostra
> assunzione in `EASYTREND_CORSO_SPEC` è **5 a sinistra / 3 a destra**.
> **Non coincide**, e la differenza cambia quali divergenze esistono.
> → **secondo candidato dell'A/B.**

**E tre regole di igiene del pivot, dettate** (`[T]` lez. 5 an.tec.), che valgono
per qualunque nostro rilevatore di swing:
1. _"il top e il bottom devono essere sempre **su candele differenti**"_
2. _"**dopo un top c'è sempre un bottom e dopo un bottom c'è sempre un top**"_
   (alternanza obbligatoria; se due top consecutivi, il bottom in mezzo non è
   significativo e si salta)
3. _"**l'ultima candela non è mai un bottom** ... andrebbe sempre lasciata in
   sospeso"_ ← **è la regola anti-repaint, dettata dal corso.**

---

### 2.8 ✅ "FASE LATERALE" — la definizione formale che al FiboH4 mancava

`FIBOH4_CORSO_SPEC` §4.1 registra l'esclusione _"non la prendo mai in
considerazione quando sono in una fase laterale"_ con l'etichetta
🔴 **"senza definizione"**. **Il modulo base la definisce.**

`[TRASCRITTO chiaro, lez. 4 an.tec.]`
> _"Un trend è una successione di **top e di bottom**. Se io ho dei top e dei
> bottom che mano a mano continuano a salire, ho un trend rialzista ... Se ho dei
> top e dei bottom che continuano a scendere ... trend ribassista. Se invece ho
> dei top e dei bottom che fanno qualcosa di diverso, per esempio i top che
> salgono e i bottom che scendono ... allora ho un **trend laterale** ...
> **Il trend è rialzista quando i top e i bottom salgono, ribassista quando i
> top e i bottom scendono e laterale quando avviene, invece, QUALUNQUE ALTRO
> CASO.**"_

> ✅ **Definizione meccanizzabile al 100%:** con un rilevatore di swing (2-3
> barre per lato, §2.7), `rialzista := HH ∧ HL` · `ribassista := LH ∧ LL` ·
> `laterale := tutto il resto`. **È il filtro che manca al FiboH4**, e ora ha
> una forma, non un'opinione. ⚠️ Resta nostra la scelta di **quanti** swing
> guardare indietro: quello il corso non lo dice.

---

## 3. ⚠️ I TRE FALSI AMICI — dove la missione puntava e non c'era niente

Vanno detti per primi, perché **tre delle sei piste indicate erano piste
sbagliate**, e saperlo vale quanto una risposta.

### 3.1 🚫 IL RETTANGOLO (lez. 10-11 an.tec.) — **è un OGGETTO DIVERSO**

Era indicata come _"LA fonte più probabile della verità"_ su 15-vs-20 candele.
**Non lo è, e il corso stesso mette in guardia nella prima riga:**

`[TRASCRITTO chiaro, lez. 10 an.tec.]`
> _"È molto importante **distinguere il rettangolo dallo strumento di disegno
> rettangolo** che abbiamo usato invece nel video precedente ... Il rettangolo è
> una specie di figura che va a fondere due figure insieme. **È la fusione di un
> doppio minimo e di un doppio massimo** ... L'importante è che ci siano **due
> bottom e due top alternati**"_

> ❌ **Il "rettangolo" dell'analisi tecnica è una FIGURA a 4 punti (top-bottom-
> top-bottom), definita dai TOP e dai BOTTOM. Il "rettangolo di congestione" del
> Breakout è una FINESTRA MOBILE DI N CANDELE, definita dal conteggio.
> Non hanno in comune nulla oltre al nome.** In due lezioni intere sulla figura
> **non compare mai un conteggio di candele**: né 15, né 20, né altro.
> **Le ambiguità B3, B4, B5 restano APERTE, e questa fonte non le tocca.**

⚠️ **E c'è un rischio di contaminazione da segnalare a chi implementa:** è
tentante "spiegare" il 15-vs-20 col rettangolo-figura. **Non si può.** Sono due
concetti distinti dello stesso corso, e confonderli produrrebbe un EA che
cerca doppi massimi dove il Breakout conta candele.

**Cosa il rettangolo-figura dà comunque** (roba nuova, non risposte):
| voce | valore | citazione |
|---|---|---|
| Struttura | 2 top + 2 bottom alternati; 3-4 punti = meglio | _"Se ne ha tre o quattro, meglio ancora"_ |
| Tolleranza di allineamento | **sbavatura ≤ 1/20 dell'altezza** | _"all'interno di **un ventesimo** dell'altezza del rettangolo"_ |
| Direzione | **simmetrica**: long se rompe sopra, short se rompe sotto | _"il rettangolo può essere sia long che short in modo assolutamente indifferente"_ |
| Ingresso | **fine della candela di rottura** | _"è meglio mettere appunto l'entrata **alla fine di questa candela verde**"_ |
| Stop | lato opposto della figura | _"sempre sulla parte opposta rispetto a dove si è entrati"_ |
| Target | **proiezione dell'altezza** della figura | _"proiettiamo ... il take profit qui sopra"_ |
| **Regola del terzo** | se la candela di rottura chiude oltre **1/3** dell'altezza → o si scarta la figura, o si **sposta il TP sul punto d'entrata** | _"**solo quelle volte in cui la candela supera più di un terzo** ... del rettangolo ... si può, in via eccezionale, spostare il take profit sul punto di entrata"_ |

> 🟢 **Convergenza utile:** _ingresso alla chiusura della candela di rottura_ +
> _stop sul lato opposto_ + _target = proiezione dell'altezza_ è **la stessa
> grammatica** del Breakout (ingresso = close del segnale, SL oltre il
> rettangolo, TP = multiplo di R). **Coach diverso, stessa forma.**

### 3.2 🚫 GLI ESEMPI BUY/SELL JPY (lez. 18-21) — **sono didattici, non strategici**

Era chiesto: _"che strategia usano? confermano livelli/stop/target del Breakout?"_
**Risposta: NESSUNA strategia, e no.** Il corso lo dichiara tre volte:

`[TRASCRITTO chiaro, lez. 19]` _"**essendo puramente didattico**, continuiamo con
questo esempio"_ · _"**Ovviamente sarà poi la strategia che andrai a mettere in
campo a determinare l'esatto valore in pips** di stop loss e di take profit"_
`[T, lez. 18]` _"**ipotizziamo** di voler entrare a mercato perché la nostra
strategia, **magari** abbiamo già applicato tutte le regole di una determinata
strategia, ci dice di entrare al valore attuale"_
`[T, lez. 21]` _"la quantità di pips da aggiungere o da sottrarre **sarà sempre
dettata dalla strategia**"_

> ❌ **20 pip di SL e 40 di TP sono numeri inventati per l'esercizio.** Il fatto
> che il rapporto sia **1:2** non è una regola del corso e **non va usato per
> arbitrare** fra l'1:3 del Breakout e l'1:1 di EasyTrend.
> ✅ **Ma le lezioni non sono sprecate: danno le CONVENZIONI DI CALCOLO** (§2.6)
> e **due dei quattro test-case sul pip JPY** (§2.3). È lì che valgono.

### 3.3 🚫 LEZ. 6 "I DUE MODULI FONDAMENTALI" — **non è la mappa del corso**

Era chiesto: _"la mappa del corso (quali moduli esistono, in che ordine, con
quali coach)"_. **Il titolo inganna:** i "due moduli" non sono moduli didattici,
sono **due configurazioni grafiche**.

`[TRASCRITTO chiaro, lez. 6 an.tec.]`
> _"Che cosa sono dei moduli? Sono ... **delle parti del grafico** che,
> individuate, fanno accendere la lampadina ... **il modulo principale è una
> trend line orizzontale** ... **L'altro modulo principale è ... una successione
> di top e bottom che formano una trend line dinamica**"_

> ❌ Nessuna mappa del corso in questa lezione.
> ✅ **Ma la mappa si ricostruisce lo stesso**, da altre lezioni → §6.

---

## 4. 🔧 I PARAMETRI DEGLI INDICATORI — cosa il corso base detta davvero

**Il capitolo indicatori (lez. 8-14, Fasciano) è la fonte che tutti aspettavano.
Ecco cosa contiene, indicatore per indicatore, senza sconti.**

| indicatore | lez. | cosa detta il corso | verdetto |
|---|---|---|---|
| **Media mobile** | 9 | **100 periodi** (_"il valore che troviamo già di default"_), tipo **semplice**, **applicata alla chiusura della candela** | 🟡 il 100 è didattico; **"applied to Close" è la convenzione** |
| **SuperTrend** | 10 | ⛔ **NIENTE** — _"Facciamo ok senza fare nessuna variazione"_ | 🔴 §2.1 |
| **ATR** | 11 | **14 periodi** (default, _"lasciamo pure i valori di default"_) + **come si legge in pip** (0,0018 = 18 pip; su JPY 0,16 = 16 pip) | 🟡 default esplicito |
| **Stocastico** | 12 | _"**mettere quattordici periodi sul primo valore**, mentre lasciamo invariati gli altri due"_ = **14/3/3** · soglie **>80 / <20** | 🟡 **contraddice il PIANO** → §5.2 |
| **RSI** | 13 | **4 periodi** (_"un periodo un po' più reattivo ... il frutto di quattro candele"_) · soglie **70 / 30** | 🆕 **valore mai visto prima nel corpus** |
| **Williams %R** | 13 | ✅ **140 periodi**, con istruzione di digitazione | ✅ §2.2 |
| **CCI** | 13 | **14 periodi** (default) · linee **+100 / −100** | 🟡 §2.7 |
| **Bande di Bollinger** | 14 | ⛔ **NIENTE** — _"Il settaggio lo rimanderemo chiaramente alla strategia"_ · solo: bande = **2 deviazioni standard**, centrale = media mobile _"settabile sulla base dei periodi che la strategia ci suggerisce"_ | ❌ §4.4 |
| **Ritracciamento di Fibonacci** | 14 | ⛔ **NIENTE** — _"sarà poi chiaramente la strategia a spiegarti come utilizzare questi livelli"_ | ❌ §4.4 |

### 4.1 🟡 Media mobile — l'unico dato che serve davvero a Media 200
`[T]` _"In questo caso inseriamo la media mobile semplice, **applicata alla
chiusura della candela**"_ + _"la cosa che utilizzerai principalmente
all'interno delle strategie che troverai nel master saranno **la media mobile
semplice o la media mobile esponenziale**"_
> 🟡 Conferma `MEDIA200_CORSO_SPEC` domanda n.5 (_"pannello Moving Average
> (conferma EMA/close)"_) **limitatamente all'`applied price` = Close**.
> **Il 200 e la scelta EMA-vs-SMA restano della strategia, non del modulo base.**

### 4.2 🟡 ATR — lo strumento del filtro "candele molto ampie" del FiboH4
Il FiboH4 vieta i pattern su _"movimenti importanti"_ **senza soglia**
(`FIBOH4_CORSO_SPEC` §4.1, 🔴). Il modulo base **insegna a misurare esattamente
quella cosa**: `[T]` _"l'ATR ... ci dice quanto il mercato in quel particolare
momento sia volatile. È anche una sorta di **indicatore di pericolosità del
mercato** ... **queste ultime candele sono molto ampie** ... quindi [l'ATR] sarà
molto alto ... **fase di alta volatilità**"_
> 🟡 **Non dà la soglia** (il nostro `InpMaxEngulfAtr = 3.0` resta NOSTRO), ma
> conferma che **l'ATR è l'unità di misura giusta** per tradurre quella regola —
> non un'invenzione nostra. **Il denominatore è del corso, il numero è nostro.**

### 4.3 🆕 RSI a 4 periodi — un parametro orfano da tenere d'occhio
`[T]` lez. 13: _"in questo caso abbiamo settato **14 periodi di default**, però
**modifichiamolo e mettiamo un periodo un po' più reattivo** ... il frutto
dell'analisi delle **ultime quattro candele**"_
> ⚠️ È l'**unico** indicatore che il coach **modifica attivamente** oltre al
> Williams. Il Williams a 140 lo giustifica (_"funzionale per la strategia"_);
> **per l'RSI a 4 non dà nessuna ragione.** `[INCERTO]` se sia un settaggio
> strategico o una scelta didattica per rendere il grafico più mosso.
> ➡️ **Se esiste una strategia ABTG su RSI, il suo periodo potrebbe essere 4.**
> Nessuna delle 5 strategie che conosciamo usa l'RSI → **parametro orfano,
> agli atti per il futuro.**
> ⚠️ Nella stessa frase la trascrizione dice _"più 70 valori di ipercomprato e
> **meno 30** i valori di ipervenduto"_ → `[TRASCRITTO dubbio]`: l'RSI vive in
> [0,100], il "meno" è un lapsus o una storpiatura. Le soglie sono **70/30**,
> come conferma la frase successiva (_"inferiore a 30 ... superiore di 70"_).

### 4.4 ❌ Bollinger e Fibonacci — il corso DICHIARA di non dettarli
Questo chiude in negativo, ma **definitivamente**, due speranze:
- **Bollinger 37 / 1,4** del PIANO di Christian (`ANALISI_POINTBREAK` §5): il
  modulo base **non conferma né smentisce**, perché `[T]` _"Il settaggio lo
  rimanderemo chiaramente alla strategia che starai utilizzando"_.
  ⚠️ Nota tecnica: il corso descrive le bande come _"un valore pari a **due
  volte la deviazione standard**"_, cioè il **default 2,0** — che è **diverso da
  1,4**. Non è una smentita del PIANO (parla di default, non della strategia),
  **ma è la prima volta che il corpus pronuncia un numero per la deviazione**.
- **I livelli di Fibonacci** del FiboH4: `[T]` _"i livelli che mi va a
  identificare l'indicatore sono visibili qui a destra con dei numeri e **sarà
  poi chiaramente la strategia a spiegarti come utilizzare questi livelli** ...
  e soprattutto **come andare a posizionare sul grafico l'indicatore**"_.
  → **L'ambiguità degli ancoraggi (F8) non poteva essere qui**, ed è confermato
  dal corso stesso che quel contenuto sta nella lezione di strategia.

### 4.5 ✅ La grammatica generale, dettata: "il parametro lo dà la strategia"
La frase ricorre **cinque volte in sette lezioni**, quasi identica:
lez. 9 _"sarà la strategia che andrai ad utilizzare a dirti come settare
esattamente l'indicatore"_ · lez. 10 _"parametri che andrai a settare sulla base
della strategia"_ · lez. 11 _"i parametri sono sempre definiti all'interno della
strategia che stai andando ad operare"_ · lez. 13 _"ogni indicatore ha il suo
particolare settaggio sulla base della strategia"_ · lez. 14 _"Il settaggio lo
rimanderemo chiaramente alla strategia"_.
> 🔴 **Questa è la conferma strutturale del §2.1: il modulo base NON È e non
> vuole essere la fonte dei parametri. Chi cercava lì i settaggi del SuperTrend
> cercava nel posto che il corso stesso dichiara vuoto.** L'unica eccezione in
> tutto il capitolo è il **Williams a 140** — ed è per questo che vale tanto.

### 4.6 🟡 Spread — spiegato, quantificato una volta, e dichiarato irrilevante
`[T]` lez. 16: EURCHF, _"tra il valore di sell e il valore di buy in questo
particolare caso abbiamo **circa un pip e mezzo, due di spread** ... 0.97538 e
qui 0.97551 ... la differenza ... è circa di **1.6-1.7**"_
> ⚠️ `[TRASCRITTO dubbio]` sull'aritmetica: 0,97551 − 0,97538 = 0,00013 =
> **1,3 pip**, non 1,6-1,7. Il coach legge due coppie di quote diverse in due
> momenti. **Irrilevante per noi**, ma è la seconda imprecisione aritmetica del
> corpus (la prima è il 39→40 del Breakout): **conferma che i numeri detti a
> voce in questo corso vanno ricontrolati, sempre.**
>
> 🚩 **E c'è una posizione che va segnalata come attrito con la nostra
> metodologia:** `[T]` _"questo piccolo costo sarà assolutamente scontato
> dall'esito dell'operazione, quindi **sarà assolutamente ininfluente**"_ e
> _"non avrà **nessun problema** rispetto allo studio, all'analisi della
> strategia"_. **Su una strategia M15 con SL da 39 pip lo spread è ~3-5% del
> rischio; su una a RR 1:1 come EasyTrend incide sul break-even.** Da noi lo
> spread **si misura, non si dichiara ininfluente.**

---

## 5. ⚔️ LE CONTRADDIZIONI TROVATE

| # | punto | fonte A | fonte B | peso |
|---|---|---|---|---|
| **C1** | 🔴 **Fuso del server** | **corso lez. 3**: piattaforma **GMT** = IT−2 in agosto | **repo** (`CLAUDE.md`, `HANDOFF` r.496, `PIANO_PROP` r.170): **BCM = IT−1** in agosto | 🔴 **1 ora, su un broker che è lo STESSO** → misurabile, §2.5 |
| **C2** | 🟠 **Stocastico** | **corso lez. 12**: _"quattordici periodi sul primo valore"_ = **14/3/3**, e lo dice _"già anche in funzione di eventuali strategie"_ | **PIANO di Christian**: **5/3/3** (`ANALISI_POINTBREAK` §5 dom. 3) | 🟠 il modulo base **non conosce** il 5/3/3 |
| **C3** | 🟠 **CCI** | **corso lez. 13**: **14** (default), per _"una strategia che vedrai nel corso del master"_ | **nostra assunzione EasyTrend**: **20** | 🟠 §2.7 |
| **C4** | 🟠 **Pivot / swing** | **corso lez. 4 an.tec.**: **2-3 barre per lato, simmetrico** | **nostra assunzione EasyTrend**: **5 sinistra / 3 destra** | 🟠 §2.7 |
| **C5** | 🟡 **L'orario impatta o no?** | lez. 3: _"**impatterà** in un modo che ti verrà spiegato"_ | lez. 3, sei righe dopo: _"**non avrà nessun impatto** ... in nessun modo"_ | 🟡 stessa lezione, §2.5 |
| **C6** | 🟠 **"Rettangolo"** | an.tec. lez. 10: **figura** a 4 punti | Breakout lez. 36-40: **finestra** di 20 candele | 🟠 omonimia pericolosa, §3.1 |
| **C7** | 🟠 **Notizie macro** | an.tec. lez. 3: _"**dimentichiamo completamente le notizie macroeconomiche** ... a volte **non conoscere niente** ... **è meglio**"_ | FiboH4: filtro news **obbligatorio** (`FIBOH4_CORSO_SPEC` §8) | 🟠 §5.4 |
| **C8** | 🟡 **Momento d'ingresso** | an.tec. lez. 8/9: _"a **mezzanotte e un minuto**, oppure al mattino successivo, **ma non oltre il mattino**"_ | Breakout/EasyTrend: **ingresso = chiusura della candela di segnale**, senza finestra | 🟡 su D1 coincidono; la "finestra fino al mattino" è **discrezionalità umana**, non va in un EA |

### 5.2 🎛️ C2 per esteso — perché lo Stocastico conta
`[TRASCRITTO chiaro, lez. 12 piatt.]`
> _"**Ti consiglio di modificare, già anche in funzione di eventuali strategie,
> il parametro iniziale, cioè mettere quattordici periodi sul primo valore,
> mentre lasciamo invariati gli altri due valori.**"_
> ... _"in genere sono un valore **maggiore di 80** ... si dice area di
> ipercomprato ... nella zona di ipervenduto ... un'area definita con un valore
> **inferiore a 20**"_

> 🟠 Il coach lo dice **"in funzione di eventuali strategie"** — cioè con la
> stessa formula con cui giustifica il Williams a 140. **Ma il valore è 14, non
> 5.** Il PIANO di trading di Christian (`ANALISI_POINTBREAK`) prescrive
> **Stocastico 5/3/3**.
> ➡️ **Non è una prova che il PIANO sia sbagliato**: Christian è una fonte
> diversa dal Master ABTG, e §5 dello stesso referto già sospetta che il suo
> oscillatore sia un **custom con le frecce**, non lo stocastico standard.
> **Ma agli atti va scritto che il corso base ABTG insegna 14/3/3**, e che il
> 5/3/3 del PIANO **non ha nessuna radice nel corso.**

### 5.3 🕳️ Il silenzio che vale una risposta — la CORRELAZIONE
> **In 41 lezioni la parola "correlazione" non compare mai.** Né fra valute, né
> fra posizioni, né come rischio.
> ➡️ Risponde (in negativo) alla **domanda n.2 di `ANALISI_POINTBREAK` §5**
> (_"esiste una lezione o un video sulle correlazioni?"_) **limitatamente ai
> moduli base**: non è nei fondamentali. E rafforza il buco n.4 del Breakout
> (correlazione fra i 7 cross JPY, mai nominata) e l'attrito n.1 di Media200:
> **il corso, dalla prima lezione all'ultima, non insegna mai a contare il
> rischio aggregato.** È un dato strutturale, non una dimenticanza di un modulo.

### 5.4 🚩 C7 per esteso — il corso base è ANTI-news, per principio
`[TRASCRITTO chiaro, lez. 3 an.tec.]`
> _"In pratica **noi dimentichiamo completamente le notizie macroeconomiche**.
> Per esempio, se l'eurodollaro è rialzista o ribassista nel lungo termine a
> causa di interventi da parte delle banche centrali, **questo non ci
> interessa**. ... **Anzi, a volte non conoscere niente dell'analisi delle
> notizie macroeconomiche è meglio perché può confondere.** Noi ci basiamo
> soltanto sul prezzo"_

> 🚩 **Non è una dimenticanza: è una dottrina dichiarata.** Spiega perché
> Breakout, EasyTrend, Mediazione e Media200 **non hanno filtro news** — e
> perché l'esempio-principe del Breakout (lez. 37) entra **su un rilascio
> macro**: per questo corso è coerente, non un incidente.
> 🏛️ **Attrito con `report/METRO_PROP.md` §7:** diverse prop **vietano** il
> trading su news (FTMO Standard ±2 min **anche su SL/TP**, FundingPips ±10
> anche solo *tenendo* una posizione). **Il corso è metodologicamente
> incompatibile con quelle regole, e lo è per scelta esplicita.** Qualunque
> strategia di questo corso portata su una prop **deve** montare un filtro news
> che il corso non solo non fornisce, ma sconsiglia.
> ⚠️ **E il corso è incoerente con sé stesso**: il modulo FiboH4 rende il filtro
> news **obbligatorio**. Due coach, due dottrine opposte.

---

## 6. 🗺️ LA MAPPA DEL CORSO — ricostruita (la domanda 5 della missione)

La lez. 6 non la conteneva (§3.3), ma **si ricava da quattro passaggi**:

| modulo / capitolo | lezioni | coach | fonte |
|---|---|---|---|
| **PIATTAFORMA cap. 1** — MT4, ordini, pip | 1-7 | ⚠️ **NON NOMINATO** nelle trascrizioni | `[INCERTO]` — un _"Giuseppe"_ è citato da Baroni in an.tec. lez. 2, ma **non è dichiarato che sia lui** |
| **PIATTAFORMA cap. 2** — **INDICATORI** | **8-14** | 🎯 **LEONARDO FASCIANO** | `[T]` lez. 8: _"**Sono Leonardo Fasciano**, coach in area trading"_ + lez. 7: _"nel prossimo capitolo conoscerai un nuovo coach che si chiama Leonardo Fasciano"_ |
| **PIATTAFORMA cap. 3** — SL/TP, esempi | 15-21 | Fasciano `[INFERITO dallo stile e dalla continuità: _"nel prossimo capitolo ... parleremo di Stop Loss"_ chiude la lez. 14]` | 🟡 non dichiarato |
| **ANALISI TECNICA** — figure | 1-20 | 🎯 **FRANCESCO BARONI** | `[T]` an.tec. lez. 2 (video di presentazione): _"Ciao, io sono Francesco e **sono il coach di opzioni e criptovalute**"_ |
| **EASY TREND** | 12-17 | Leonardo Fasciano | `EASYTREND_CORSO_SPEC` §0 |
| **FIBO H4** | 18-20 | (relatore FiboH4) | `FIBOH4_CORSO_SPEC` |
| **MEDIA 200** | 21-25 | (stesso del FiboH4) | `MEDIA200_CORSO_SPEC` |
| **MEDIAZIONE** | 26-33 | Manuela Negro | `MEDIAZIONE_CORSO_SPEC` |
| **BREAKOUT** | 34-40 | Manuela Negro | `BREAKOUT_CORSO_SPEC` |

**L'ordine dichiarato, `[TRASCRITTO]`:**
`Piattaforma cap.1 → cap.2 (indicatori) → cap.3 (SL/TP) → [Money Management] → strategie`
- lez. 8: _"sulla MetaTrader 4 che è già visto **nel capitolo precedente**"_
- lez. 14: _"nel prossimo capitolo parleremo di ... **Stop Loss, Take Profit** e
  dei primi passi verso la gestione di una posizione"_
- lez. 18: _"non andiamo ancora ad inserire il volume perché **sarà argomento di
  un altro capitolo** ... riguarderà **il money management**"_
- lez. 6: _"quanto equivale in soldi ... questo lo capirai nel contesto del
  **capitolo dedicato al money management**"_

> ⚠️ **Nota di numerazione, e va detta:** i due moduli base hanno una numerazione
> **propria** (1-21 e 1-20) che **NON si allaccia** alla numerazione 12-40 delle
> strategie. L'inferenza della spec Breakout (_"modulo di Leonardo = lezioni
> < 26"_) **puntava alla cosa giusta ma con la scala sbagliata**: il modulo di
> Leonardo non ha un numero nella serie delle strategie, è **un modulo a monte**.
>
> ❓ **E resta aperto se ANALISI TECNICA venga prima o dopo PIATTAFORMA**:
> nessuna delle due lo dichiara. `[INCERTO]`

---

## 7. 🕳️ COSA RESTA SENZA RISPOSTA — e le NUOVE domande per Claudio

### 7.1 🥇 LE DUE DOMANDE CHE SBLOCCANO DI PIÙ (nuove, nate da questa lettura)

| # | domanda | perché sblocca | costo |
|---|---|---|---|
| **1** | 🔴🔴 **Il file `super trend.ex4` allegato alla lez. 10 del modulo Piattaforma.** Scaricarlo, trascinarlo su un grafico, **fotografare la finestra input** | **È l'UNICO modo rimasto di chiudere il buco bloccante di DUE strategie** (Breakout + Mediazione). Il coach applica l'indicatore premendo OK: **i default di quel file SONO i parametri del corso.** Se sono ATR 10 / mult 3,0, la nostra assunzione diventa un **dato**; se sono altro, **tutti i backtest Breakout vanno rifatti** | 3 click |
| **2** | 🔴 **Screenshot con l'orologio di Windows e la "Vista del mercato" di MT4/MT5 nella stessa foto** | Chiude **C1** (lo scarto di 1 ora fra il "GMT" del corso e l'"IT−1" del repo) su un broker che **è lo stesso**. Da qui dipendono gli orari di **FiboH4** (fattore: 2 ore) e l'allineamento **H4** di Media200 | 5 secondi |

### 7.2 🥈 LA RICHIESTA MIRATA CHE MANCA: **IL MODULO MONEY MANAGEMENT**

**Tre spec chiedono la stessa cosa e nessuna sa dove cercarla:**
`FIBOH4` dom. 5 (_"quale % di rischio insegna questo relatore — mai detta in 3
lezioni"_) · `MEDIA200` dom. 3 (_"mai detta in 5 lezioni"_) · `BREAKOUT` §8.1
(_"1% per operazione o complessivo?"_).

**Il modulo base dice DOVE STA, quattro volte** (§6): esiste un **capitolo
dedicato al Money Management**, che tratta **il volume/lotti** e la
**traduzione pip → euro**. `[T]` lez. 18: _"non andiamo ancora ad inserire il
volume perché sarà argomento di un altro capitolo ... riguarderà il money
management"_ · `[T]` an.tec. lez. 9: _"metteremo il volume che calcoleremo
**quando faremo i video sul money management**"_.

> 🥈 **DOMANDA N.3 PER CLAUDIO: le trascrizioni del MODULO MONEY MANAGEMENT.**
> È il modulo che, per costruzione, contiene **la % di rischio, il calcolo del
> lotto e (forse) la regola del rischio simultaneo**. È l'unico posto dove
> possono stare le risposte a `B8`, `F5`, `M3` — e `B8` (1% per operazione **o**
> complessivo) è **un fattore 7 sul rischio di portafoglio**.

### 7.3 ❌ I BUCHI CHE QUESTI MODULI HANNO CONFERMATO ESSERE BUCHI DEL CORSO

Non "non trovati": **cercati in 41 lezioni e assenti per struttura.**
1. **Correlazione fra strumenti** — mai nominata (§5.3)
2. **Cap di perdita giornaliera** — mai nominato
3. **Max posizioni contemporanee** — mai nominato
4. **Filtro news** — non solo assente: **sconsigliato** (§5.4)
5. **Filtro spread** — presente come concetto, **dichiarato ininfluente** (§4.6)
6. **Gap / slippage / weekend** — mai affrontati nei moduli base
7. **Parametri di Linear Regression Candles** — l'indicatore **non esiste** nei
   moduli base (è TradingView, il corso base è tutto MT4)

> 🏛️ **Lettura per la prop, secca:** i sette buchi qui sopra sono **esattamente**
> le sette cose che `report/METRO_PROP.md` misura. **Il corso ABTG, dai
> fondamentali alle strategie, non contiene un solo strumento di gestione del
> rischio di portafoglio.** Tutto ciò che nel nostro impianto è Guardian, cap
> C1, filtro news e cap giornaliero **è NOSTRO al 100%** — e va scritto accanto
> a qualunque numero di qualunque backtest "del corso".

### 7.4 🖼️ COSA C'ERA A SCHERMO E NON NEL PARLATO (in questi 41 file)

| lez. | cosa non è stato dettato | serve? |
|---|---|---|
| **10 piatt.** | 🔴 **la finestra input del SuperTrend** — aperta e chiusa con "ok" senza leggere un valore | 🔴🔴 §7.1 n.1 |
| 3 piatt. | 🔴 **l'orologio della "Vista del mercato"** — indicato a dito, mai letto | 🔴 §7.1 n.2 |
| 12/13 piatt. | i pannelli di Stocastico/RSI/CCI: letti **solo i valori modificati**, non gli altri | 🟠 conferma C2/C3 |
| 14 piatt. | i pannelli Bollinger e Fibo: aperti, **nessun numero letto** | 🟠 §4.4 |
| 18-21 piatt. | il **foglio Excel** del calcolo SL/TP (formule dettate a voce, ✅ ricostruite in §2.6) | 🟢 non serve più |
| 9 an.tec. | i prezzi dell'esempio EURGBP: **dettati** (SL 0,82816 · TP 0,89096) 🟢 | 🟢 |
| 11/13/16/18/20 an.tec. | **i grafici degli esempi**: cross e anni citati (EURGBP H1, AUDCHF 2017, CADJPY 2017, AUDNZD, AUDJPY, GBPZAR), **date esatte mai** | 🟡 impedisce la riverifica |

---

## 8. 🧰 ROBA NUOVA CHE NON RISPONDEVA A NESSUNA DOMANDA (ma è misurabile)

Il modulo di analisi tecnica è **l'unica parte del corpus ABTG con soglie
numeriche esplicite per la qualità di una figura**. Non serve a nessuna delle 5
strategie in corso, ma **è materiale meccanizzabile** e va agli atti.

| # | regola | valore | citazione | lez. |
|---|---|---|---|---|
| A1 | **Tolleranza di allineamento** doppio max/min e rettangolo | **sbavatura / altezza ≤ 1/20** (5%) | _"se la sbavatura è meno di **un ventesimo** dell'altezza vuol dire che è un bel doppio minimo"_ | 8, 10 |
| A2 | **Tolleranza** testa e spalle (fra le due "ascelle") | **≤ 1/10** (10%) | _"se la sbavatura è minore di **un decimo** ... il testa e spalle è inclinato in modo ragionevole"_ | 12 |
| A3 | **Conferma di rottura** | **CHIUSURA** oltre il livello, non il tocco | _"non solo superi la linea rossa ... ma **proprio chiuda sopra**"_ | 8 |
| A4 | **Ingresso** | apertura della candela successiva (_"mezzanotte e un minuto"_) o **entro il mattino** | _"non oltre il mattino, perché poi il mercato al pomeriggio inizia a essere molto volatile"_ | 8, 9 |
| A5 | **Stop loss** | sull'**estremo più recente** della figura (bottom di destra / spalla destra / ultimo estremo opposto) | _"**Sempre quello di destra, perché è tra i due il più fresco**, il più recente"_ | 9, 13, 15 |
| A6 | **Take profit** | **proiezione dell'altezza** della figura dal punto di rottura | _"proiettare l'altezza della mia figura verso l'alto"_ | 9, 13, 16, 18, 20 |
| A7 | **Regola del terzo** | se la candela di rottura chiude oltre **1/3** dell'altezza: si scarta la figura **o** si sposta il TP sul punto d'entrata | _"solo quelle volte in cui la candela supera più di **un terzo** ... del rettangolo"_ | 11, 20 |
| A8 | **Qualità di una trendline** | 2 punti = valida · **3+ punti = "di qualità"**, consigliata ai principianti | _"se tu riesci a unire **tre punti**, questo ti dà un grande senso di sicurezza"_ | 6, 15, 17, 19 |
| A9 | **Proporzione dei triangoli** | la linea più corta deve partire **da prima della metà** della più lunga | _"almeno la linea diagonale ... parta da **almeno prima della metà** di quell'altra"_ | 16, 18 |
| A10 | **Doppio max/min: filtro del trend di provenienza** | il trend deve provenire da **oltre la trigger line** proiettata all'indietro | _"il trend di provenienza **deve provenire da sopra la trigger line**"_ | 8 |
| A11 | **Trigger line** | il **top più alto** (o bottom più basso) **compreso fra i due estremi** della figura | _"non andare mai a sinistra o a destra di questi bottom, ma stare sempre all'interno di essi"_ | 8 |
| A12 | **Invalidazione** | doppio min: rottura del bottom precedente · triangolo asimm.: rottura della **diagonale** prima dell'orizzontale · cuneo/flag: rottura **contro** il trend di provenienza | _"in questo caso la figura viene annullata ... la buttiamo via"_ | 8, 17, 19 |
| A13 | **Cuneo/flag** | figure di **continuazione**: si accettano **solo** rotture nel verso del trend di provenienza; linee **convergenti o parallele**, **mai divergenti** | _"devono essere o parallele o convergenti"_ | 19 |

### 8.1 📊 L'unico numero di performance dei due moduli
`[dichiarato, NON verificato — lez. 9 an.tec.]`
> _"la probabilità di successo di queste figure se la facciamo come l'ho
> spiegata io, si attesta statisticamente guardando ... **tutte le nostre
> operazioni precedenti, più o meno il 60% delle volte andavano in profitto**"_
> _"mediamente figure come queste sono fatte in modo tale che **il guadagno sia
> leggermente inferiore alla perdita**"_

> 🚩 **Registrato, non pesato.** Nessun N, nessuna data, nessun broker, nessuna
> lista operazioni: **"guardando agli esempi che ho fatto nel passato"** è
> l'unica metodologia dichiarata. Con RR leggermente **sotto** 1:1 e win rate
> 60%, l'aspettativa è positiva ma **sottile**: basta che il RR vero sia 0,85 e
> il 60% diventa +2% lordo per operazione, **prima** di spread e slippage —
> che lo stesso corso dichiara "ininfluenti" (§4.6). **Non confrontabile coi
> nostri numeri.**

---

## 9. 🗑️ GLI SCARTI — lezioni senza niente di estraibile, e perché

| lezione | perché non estrae |
|---|---|
| **1 piatt.** (Introduzione alla piattaforma) | 1 paragrafo motivazionale |
| **2 an.tec.** (Chi è il tuo coach, Francesco Baroni) | biografia. ✅ **Unico dato utile estratto: il nome e il ruolo del coach** (_"coach di opzioni e criptovalute"_) — usato in §6. ⚠️ Contiene numeri autobiografici `[dichiarato, NON verificato]`: _"con ventimila euro, con un'opzione sola ... ho fatto ventimila euro ancora ... in soli sette mesi"_ (raddoppio in 7 mesi). **Nessuna strategia, nessun parametro: non pesa** |
| **1 an.tec.** (Introduzione all'analisi tecnica) | 2 paragrafi di presentazione |
| **4 piatt.** (Comprare e vendere) | didattica long/short, metafora del computer. Zero parametri |
| **7 an.tec.** (Le figure orizzontali) | indice di capitolo, 2 paragrafi |
| **14 an.tec.** (Le figure triangolari) | indice di capitolo, 2 paragrafi |
| **15 piatt.** (I calcoli applicati al TP e allo SL) | 3 righe di introduzione al capitolo. ⚠️ **Il titolo prometteva i "calcoli" — i calcoli sono nelle lez. 18-21** |
| **17 piatt.** (Stop loss e take profit) | concetto puro (sopra/sotto l'ingresso). Un solo dato di sostanza: `[T]` _"quando noi andiamo ad aprire un'operazione, **sempre, in ogni caso, lavoreremo con uno stop loss**"_ — 🟢 **nessuna strategia senza SL in questo corso** |
| **7 piatt.** (Ordini a mercato e pendenti) | didattica sui 4 tipi di pendenti. Un dato: `[T]` _"vedrai **quanto ricorso faremo agli ordini pendenti** poi nelle varie strategie"_ — 🟡 **contraddice il Breakout**, che li vieta (_"è bene non inserire degli ordini pendenti"_): il default del corso è **a favore** dei pendenti |
| **3 piatt.** (parte su colori/zoom) | UI. ✅ Ma la parte sul fuso è **la scoperta n.2** (§2.5) |
| **5 piatt.** (parte su formati e schemi colore) | UI (`black on white`, candela toro bianca / orso nera). ✅ Ma la parte sulle **ombre** è una chiusura (§2.4) |
| **3 an.tec.** (Cos'è l'analisi tecnica) | definizioni. ✅ Ma la posizione **anti-news** è una scoperta (§5.4) |
| **16, 18, 20 an.tec.** (esempi triangoli/cunei/flag) | ripetizioni applicative delle regole A1-A13. Nessun prezzo dettato, nessuna data completa |

---

## 10. 📌 COSA NE COPIAMO — la voce per la tabella degli esempi

| # | cosa | dove va | stato |
|---|---|---|---|
| 1 | **Williams %R = 140** (5ª occorrenza, 1ª fonte indipendente) | `BREAKOUT_CORSO_SPEC` §3.2 · `MEDIAZIONE_CORSO_SPEC` §3.1 | ✅ **applicato** |
| 2 | **SuperTrend: il corso non lo detta MAI** + la via del `.ex4` | `BREAKOUT_CORSO_SPEC` §4.1-bis, §3.3 | ✅ **applicato** |
| 3 | **1 pip JPY = 0,010 = 10 punti** | `BREAKOUT_CORSO_SPEC` §6.3 (era `[BUCO]`) | ✅ **applicato** |
| 4 | **Fuso piattaforma = GMT** + broker = BCM | `FIBOH4_CORSO_SPEC` §2.1 · `MEDIA200_CORSO_SPEC` §14 | ✅ **applicato** |
| 5 | **Wick, non corpo** (convenzione generale) | `BREAKOUT_CORSO_SPEC` §4.1 R5 | ✅ **applicato** |
| 6 | **CCI 14 e pivot 2-3** come candidati A/B | `EASYTREND_CORSO_SPEC` §10 buchi 1-2 | ✅ **applicato** |
| 7 | **Definizione di "laterale"** meccanizzabile | `FIBOH4_CORSO_SPEC` §4.1 | ✅ **applicato** |
| 8 | **Nessun arrotondamento del pip** (conferma R82) | `BREAKOUT_CORSO_SPEC` §6.2 | ✅ **applicato** |
| 9 | Le 13 regole A1-A13 dell'analisi tecnica | 🔵 **NIENTE per ora** — non servono a nessuna delle 5 strategie in corso. Agli atti qui, §8 |
| 10 | RSI 4 periodi | 🔵 **parametro orfano**, agli atti §4.3 |

---

_Compilato il 18/08/2026 sera. 41 trascrizioni lette integralmente. Ogni
chiusura porta la citazione testuale e la lezione. Dove il corso tace c'è
scritto "non trovata", non un valore ragionevole — e dove il corso **dichiara**
di tacere (SuperTrend, Bollinger, Fibonacci) c'è scritto che è **il corso** a
non averlo, non noi a non averlo trovato._
