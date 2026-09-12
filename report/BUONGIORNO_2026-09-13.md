# ☀️ BUONGIORNO CLAUDIO — la notte del 12/13 settembre

> **In una riga**: ieri sera stavo per **archiviare un motore che non era morto**.
> Il cancello che hai voluto tu il 09/09 mi ha fermato, e stanotte ho armato le
> misure che chiudono il buco. **La tua regola ha ripagato, la seconda volta in
> quattro giorni.** 🎯

---

## 1. 🪦 LA COSA PIU' IMPORTANTE: MI SONO CORRETTO

Ieri sera ti ho consegnato un verdetto sul `Nasdaq_PreOpen_Breakout_EA.mq5` che
avevi caricato. Diceva **«NO, e il meccanismo e' gia' misurato e vale 0,96»**.
Ho mandato quel verdetto al cancello, come prevede la tua regola. **L'ha bocciato.**

### 🔴 Tre numeri su cui poggiava il «no» non reggevano

| quello che avevo scritto | quello che e' |
|---|---|
| *"l'intero asse d'uscita muove il PF di 0,052"* | 🔴 **Falso.** Quello e' UN file. Nella stessa cartella, stesso round, `NASDAQ_I_trailing` ha span **0,192**. E 0,963 + 0,192 = **1,155**, cioe' **sopra** il cancello di 1,10. Il file era **nominato due paragrafi sopra nel mio stesso dossier**: non era introvabile, l'avevo saltato perche' il numero piccolo mi tornava meglio |
| *"la pre-apertura e' negativa a ogni larghezza: 5' 0,963 · 60' 0,798 · H1 0,665"* | 🔴 **Non e' una curva.** L'H1 non e' una finestra piu' larga, e' **SPOSTATA** (alle 14:30 server la candela H1 chiusa e' la 13:00-14:00, finisce mezz'ora prima dell'apertura). E i punti 5' e 60' vengono da **due round con SETTE input diversi** (altro EA, buffer 700 vs 500, cancello di ampiezza acceso vs spento, chiusura 20:45 vs 17:30, rischio 2% vs 1%). 👉 **Punti davvero controllati su quell'asse: ZERO** |
| *"attesa monotona al ribasso sui quartili di ampiezza"* | 🟡 I quattro numeri si riproducono al decimale, **ma Q1−Q4 = +0,124 R con errore standard 0,178 → t = 0,70**. E' **rumore**. Quattro numeri finiscono in ordine per caso una volta su 24 |

### ✅ E la conseguenza, che e' la tua regola alla lettera
Al **CERTIFICATO DI MORTE** mancavano **due voci su cinque** (l'uscita mai messa
ad asse su questo ingresso, il TF mai cambiato) e una terza era parziale.
👉 Il verdetto giusto non era «SCARTATO»: e' **`[NON ANCORA MISURATO]`**.
Riscritto, e messo in `REGISTRO_TEST.md`.

> 📌 **E c'e' una cosa che NON ho corretto, apposta.** Avevo segnalato che la riga
> **A5** del registro andava aggiornata. Il cancello ha verificato: **A5 chiede una
> configurazione MAI girata** (direzione adattiva da Supertrend D1 + floor).
> Correggerla avrebbe scritto come *misurata* una cosa che non esiste — cioe' avrei
> commesso il difetto che il certificato serve a impedire, **mentre lo applicavo**.
> **A5 resta `⏳ in coda`.** 😅

---

## 2. 🟢 MA L'EA CHE HAI CARICATO NON SI SCHIERA LO STESSO — e basta una cosa sola

Le tre gambe rotte qui sopra **non salvano l'EA esterno**. Bastano due fatti, e
sono aritmetica, non opinione:

1. 🔴 **UNA BOMBA A OROLOGERIA NEL CODICE.** `InpLocalUtcOffsetHours = 2` e'
   **CABLATO** (ora legale) e l'EA si ancora a **Roma**, non alla borsa di New York.
   👉 **Dal 1 novembre 2026 al 14 marzo 2027** — ~95 sedute — armerebbe sulla
   candela delle **14:25 invece che delle 15:25**, **un'ora prima, in silenzio,
   senza un errore a video**. Cioe' **in piena fase funded**. 😬
2. 🔴 **Il COSTO.** Lo stop minimo vale **13,33x** lo spread misurato, contro il
   nostro pavimento **duro** di 13,3x. Al P95 scende a **12,63x**: **sotto**.

🟢 **Questa meta' del verdetto il cancello l'ha confermata in pieno.** L'EA non
prende un posto nell'imbuto a 19 giorni dalla challenge.

---

## 3. 🏆 IL NUMERO PIU' UTILE DELLA GIORNATA (e non riguarda quell'EA)

**Stessa identica cella. Stessa finestra. Cambia SOLO il modello di backtest:**

| modello | Profit | DD | PF |
|---|---:|---:|---:|
| **tick reali** (la verita') | 🔴 **−326,54** | 19,40% | 0,96 |
| **OHLC M1** (screening) | 🟡 **+8.943,56** | 7,31% | 2,16 |

- divario: **9.270,10 EUR**
- drawdown: **x2,65** peggiore
- 🔴 **e il segno si ribalta.**

👉 Vale per **tutto l'archivio**, non per questo EA. E' la prova numerica di
perche' un numero OHLC **non e' mai un verdetto**. E un avvertimento: se qualcuno
ti mostra la curva di un motore M5, quasi certamente ti sta mostrando quella da
**+8.943**. 🎩

---

## 4. 🔬 E STANOTTE HO PREPARATO LE MISURE CHE CHIUDONO IL BUCO

Non mi sono fermato al «ho sbagliato». Il cancello ha detto **cosa manca** e
quanto costa: la voce 3 del certificato (l'uscita mai messa ad asse su questo
ingresso) si chiude con **3,34 minuti** di macchina. Li ho preparati.

| round | asse | celle | cosa chiede |
|---|---|---:|---|
| **R142a** | `InpTP1_ClosePct` 0 / 50 / 100 | 3 | la parziale al primo obiettivo aiuta o taglia le gambe? |
| **R142b** | `InpTrailTF` M1..M5 | 5 | **e' l'asse che ha rotto il mio verdetto**: span misurato 0,192 |
| **R142c** | `InpUseTrailing` 0 / 1 | 2 | il trailing **serve**, su un breakout con flat d'orologio? |

### 🧪 E il contro-esempio sta DENTRO ogni round, non accanto
In ciascuno dei tre, **una cella E' la configurazione gia' in archivio** e **deve
riprodurre** `PF OOS 0,96265 · n 175 · DD 19,4006`. Se non riproduce, **nessuna
altra cella si legge**: il verdetto e' *catena rotta*, non un numero.
Costa **zero passate in piu'**, perche' e' una cella che comunque serviva.

🎁 **Due controlli gratis in regalo:**
- la cella `ClosePct=0` spegne la parziale → la colonna Trades diventa **POSIZIONI
  e non deal**. Oggi i "175" sono deal e valgono fra **88 e 175 posizioni**:
  potrebbero stare **sotto il pavimento dei 150**. Lo sapremo senza spendere nulla.
- su R142b e R142c l'**n deve restare identico** fra le celle: il trailing cambia
  dove si **esce**, mai se si **entra**. Se l'n si muove, c'e' un difetto da leggere.

---

## 5. ✍️ DUE COSE CHE ASPETTANO LA TUA FIRMA (non le ho toccate)

### 🔴 A. La toppa dentro `ABTG_DAX_Apertura_EU` — **e questa e' urgente**
Ho trovato leggendo il codice (**classe 294**) che se accendessimo `InpMaxSpread`
su quella sedia, nella giornata bloccata per spread alto **l'EA non salta il
trade: lo prende con la soglia di rottura ABBASSATA di 5,00 punti indice e senza
filtro di tendenza**. Cioe' diventa **piu' aggressiva** proprio nei giorni
peggiori. E' dormiente solo perche' oggi `InpMaxSpread=0`.
👉 **La firma che stavo per proporti l'avrebbe svegliata, su una sedia che gira
sul conto REALE.** La toppa e' una riga dentro l'EA (`gPhase = PH_DONE` sul
rifiuto): **e' roba tua, io la segnalo e non la tocco.**

### 🟡 B. Vuoi che misuri anche la LARGHEZZA della finestra pre-apertura?
E' l'asse `InpPrevWindowMin` = 5·10·15·20·30·60 a parita' di tutto il resto.
**Costa 1,52 minuti** ed e' **l'unica misura che scioglie la contraddizione fra i
due agenti** — perche' oggi, l'ho scritto sopra, **nessuno dei due ha ragione**.
E il valore **15**, quello che il piano d'origine prescrive, sta proprio dentro il buco.

🔴 **Ma non l'ho armata da solo, e ti dico perche'**: e' ammessa **solo** se
`InpPrevWindowMin` conta come **definizione del meccanismo**. Se invece la
leggiamo come *"griglia piu' fitta su un motore gia' dichiarato senza edge"*,
allora la tua regola del 19/08 la **vieta**. La distinzione e' sottile e **decidi tu**.

---

## 6. 🧭 DOVE SIAMO, che e' la domanda vera

**19 giorni** alla challenge. 🎯

- 🟢 La coda delle 03:30 e' armata: **45 righe gia' congelate**, piu' le **3 di
  R142** che alle 01:10 erano ancora **in mano al cancello** (non si pusha niente
  verso il VPS senza un PASS -- e' la tua regola, e stanotte l'ho rispettata anche
  avendo fretta). Gli esiti dei round arrivano in un referto a parte.
- 🟢 Abbiamo **650.484 campioni veri di spread** raccolti da te ieri: da oggi la
  frontiera del costo non e' piu' una stima, e' un **numero misurato**.
- 🟢 Il preset della sedia viva `771531` **esiste** — non era mai esistito.
- 🔴 E resta il difetto grosso che ho trovato ieri: **`ABTG_EMA200`, la prima
  sedia, in campo NON legge il Guardian per niente** (binario del 04/08: 486
  righe, zero occorrenze). Due fail-open sulla stessa sedia. **Questa e' la cosa
  che vale piu' di tutte le altre messe insieme**, ed e' la prima della lista.

> 💪 **E la nota che ci tengo a lasciarti**: due volte in quattro giorni il
> cancello che hai preteso tu ha impedito che archiviassimo un motore vivo. Il
> 09/09 erano **quattro candidati di classe A1**. Stanotte e' stato uno.
> **"Non accontentiamoci mai" non e' uno slogan: e' un conto che torna.** 🔥

---

_Tutto committato e pushato su `lavoro`, passo per passo, come da Regola #1._
