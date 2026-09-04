# 🎙️ ANALISI LIVE PAOLO — 03/09/2026 sera (~21:30) + I PARAMETRI DEL SUO INDICATORE ORB

**Data referto:** 04/09/2026 · **Analista:** estrattore trascrizioni
**Mandato:** estrarre OGNI valore, OGNI meccanismo, OGNI regola. **Non riassumere.**
**Fonti (due, e solo due):**
1. `docs/live_paolo/LIVE PAOLO 03.09.26 2026-09-03 21-30-00-388.txt` — trascrizione TurboScribe
2. `docs/live_paolo/ORB_Indicator_V17_parametri_2026-09-04.txt` — parametri letti da uno screenshot

Niente memoria, niente web, niente "completamento" dei buchi. Ogni incrocio col
repo è verificato **nel sorgente o nel referto citato**, mai a memoria.

> ⛔ **REGOLA CHE VALE SOPRA TUTTO: nessun parametro della flotta si muove da
> questo materiale.** Questo è un referto di LETTURA. In chiusura: **nessuna
> azione sulla flotta, zero modifiche al forward.**

**Etichette:** `[T]` = `[TRASCRITTO chiaro]` (c'è scritto e il contesto lo
conferma) · `[T?]` = `[TRASCRITTO dubbio]` (lo speech-to-text ha quasi
certamente storpiato) · `[I]` = `[INFERITO]` (lo deduco da più passaggi, e dico
quali) · `[?]` = `[INCERTO]` · `[D]` = `[DICHIARATO, NON VERIFICATO]` (numero
del relatore: si registra, non pesa).

---

## 0. 🗂️ I DUE FILE — che cosa sono davvero

| Voce | Dato |
|---|---|
| File 1 | `LIVE PAOLO 03.09.26 2026-09-03 21-30-00-388.txt` |
| Dimensione | **56.453 caratteri · 10.171 parole · 121 righe** |
| ⚠️ Struttura | **La riga 91 da sola è 38.976 caratteri** (69% del file) e la **riga 17 è 4.996**: due blocchi monolitici senza punteggiatura di paragrafo. Tutte le citazioni della parte centrale sono marcate `r.91 (blocco unico)` |
| Lettura | **Integrale, 121/121 righe.** Verifica per grep sulle stringhe critiche eseguita in `python3`, non a occhio |
| Relatore | **PAOLO** — `[T]`, nominato dagli allievi **20+ volte** (_"Paolo, quando dici che nasce intendi la doji?"_ r.17; _"Paolo ma tu lavori anche con gli alert?"_ r.91; ecc.) |
| Allievi nominati | **Mauro** (r.1), **Natalia** (r.91, 2 volte), **Anna** (r.91), **Stefano** (r.91), **Emiliano** (citato come co-docente, 6 volte) — tutti `[T]` |
| Formato | Live di gruppo su schermo condiviso. **Studio serale multi-strumento** (CHFJPY, AUDNZD, CADJPY, DAX, Nasdaq, Dow) + Q&A + coda organizzativa privata |
| Timestamp nel nome | `2026-09-03 21-30-00` → `[I]` la live è la **sera del 03/09**. Il testo lo conferma: _"perché **domani ci sono gli NFP**"_ (r.17) e **04/09/2026 è un venerdì** — giorno canonico degli NFP. ✅ **Data coerente, questa volta senza il pasticcio del 27/08** |
| Fuso del timestamp | ⛔ **non dichiarato da nessuna parte. Non lo converto** |

| Voce | Dato |
|---|---|
| File 2 | `ORB_Indicator_V17_parametri_2026-09-04.txt` |
| Contenuto | **59 righe**, parametri dell'indicatore **`ORB_Indicator_V17` versione 1.17**, letti da uno screenshot |
| Grafico su cui era applicato | **`NASUSD_EXT`, M15** |
| ⚠️ Nota di provenienza | 🔴 **`NASUSD_EXT` è un simbolo CUSTOM DI CASA NOSTRA**, non un simbolo BCM nativo: nasce dall'import HistData (`report/PIANO_PROP.md` M12, `SWEEP_MECCANISMI_2026-08-23.md` r.108) ed è **IN FRIGO per il cancello ZERO** (diff media H1 **0,0756%** > 0,05%). `[I]` **Quello screenshot è quasi certamente di un terminale NOSTRO, non di Paolo.** Conseguenza pesante, §1.3: quei valori **non provano** che siano il preset "ORB Wall Street" di Paolo |

---

---

# ⭐ PARTE 1 — LA SINTESI INCROCIATA (la pagina da leggere per prima)

## 1. 🚨 IL TITOLO: LA SUA VOCE DICE "I PRIMI 15 MINUTI DOPO L'APERTURA". IL SUO INDICATORE MISURA I 5 MINUTI *PRIMA*. E DUE NOSTRE SEDIE VIVE STANNO SUL SECONDO.

Questo è il risultato numero uno della giornata, ed è possibile **solo** perché
Claudio ha mandato la trascrizione **e** i parametri insieme.

### 1.1 🗣️ Quello che la VOCE dice — `[T]`, r.91 (blocco unico)

> _"bisogna noi aspettare la **prima candela che si forma interamente fuori
> dall'orb**, la prima candela che si è formata interamente fuori
> dall'**opening range breakout**, **che sarebbe questa casella che è composta
> dai PRIMI 15 MINUTI DELLA CONTRATTAZIONE**"_

E gli orari, dettati due righe dopo — `[T]` sui numeri:

> _"**la mattina si fa dalle 9 alle 9 e un quarto col DAX**, pomeriggio **si fa
> dalle 15 e 30 alle 15 e 45** con Dow Jones, Nasdaq o Standard [& Poor's].
> **Uno solo che ne prendete, se no impazzite**"_

| | ora dichiarata | fuso | ora server BCM |
|---|---|---|---|
| **DAX** | **09:00 → 09:15** | `[I]` **italiana** (il DAX cash apre alle 09:00 IT) | **08:00 → 08:15** |
| **USA** (Dow / Nasdaq / S&P) | **15:30 → 15:45** | `[I]` **italiana** (apertura USA = 15:30 IT) | **14:30 → 14:45** |

⚠️ **Il fuso NON è dichiarato a voce.** Lo inferisco dal fatto che 09:00 e 15:30
sono le due aperture in ora italiana, e la regola di casa (`CLAUDE.md`) dice
server = IT − 1. **Se il fuso fosse un altro, tutta questa riga cade.** Lo
segnalo, non lo firmo.

### 1.2 🔧 Quello che l'INDICATORE misura — dal file dei parametri

```
InpTime1     14:25:00
InpTime2     14:29:59
InpTimeEnd   22:59:59
```

**14:25:00 → 14:29:59 sono i CINQUE MINUTI IMMEDIATAMENTE PRECEDENTI le
14:30 server**, cioè **l'ultima candela M5 prima dell'apertura USA**.
La voce dice **14:30 → 14:45 server**. **Sono due finestre che non si toccano
nemmeno per un secondo**, e sono di durata diversa (5 minuti contro 15).

### 1.3 ⚖️ Come si legge, onestamente — TRE letture, tutte aperte

**Non risolvo la contraddizione. La dichiaro, con le tre strade che restano.**

| # | Lettura | Cosa la sostiene | Cosa la indebolisce |
|---|---|---|---|
| **A** | L'indicatore fa davvero un **ORB PRE-APERTURA** (range dell'ultimo tratto di pre-market) e la voce descrive la definizione "da manuale" senza guardare il proprio pannello | 🟢 **La stessa finestra c'era già nella V15**: `mql5/Experts/ABTG_ORB.mq5` righe 7-8, testuale nell'header: _"RANGE = candela **14:25-14:30 (server)** = 15:25-15:30 IT (**i 5 minuti prima dell'apertura USA**)"_. Due versioni dell'indicatore a distanza di mesi, **stesso numero**. E Paolo conferma la continuità: _"questo indicatore ORB ha delle modifiche rispetto al precedente? **No, [è] lo stesso**"_ (r.91) `[T]` | Un ORB pre-apertura è una scelta insolita e lui **non la nomina mai** |
| **B** | Quei valori sono il **DEFAULT DI FABBRICA** dell'indicatore, e i **preset** di Paolo li sovrascrivono | 🟢 Lo dice lui: _"ho i miei salvataggi, ho **il salvataggio con la preimpostazione ORB DAX e ORB Wall Street**, così non deve impazzire […] uno volendo **può cambiare solo l'orario**, basta"_ (r.91) `[T]` → **esistono due preset che noi NON abbiamo** | Non spiega perché il default di fabbrica sia una finestra pre-apertura |
| **C** | Lo screenshot è di **un terminale nostro**, con valori messi da noi | 🟢 **`NASUSD_EXT` è un simbolo custom di casa** (§0), Paolo lavora su simboli BCM nativi | La V15 aveva già lo stesso numero **prima** che ci arrivasse questo screenshot |

🔴 **E qui la riga che pesa davvero per il conto:**

**Le nostre DUE sedie ORB vive girano sulla finestra PRE-apertura**, verificato
nel sorgente:

| EA | Simbolo | Magic | Range (input) | Verificato |
|---|---|---|---|---|
| `ABTG_ORB.mq5` v1.01 | NASUSD | **770601** | `InpRangeStartHour=14 / Min=25` → `InpRangeEndHour=14 / Min=30` | righe 108-111 |
| `ABTG_ORB_Ottimizzato.mq5` | U30USD | **770611** | idem | righe 128-131 |

`report/CONTRATTI_SEDIE.md` riga 83 dà a **770611** una promessa misurata
(**DD 9,92%**, R15, "col doppio asterisco"; R16 a 100k: 9,72%; **119 trade**,
OOS 12,6 mesi).

➡️ 🟢 **La finestra che usiamo ha una MISURA dietro. La finestra che lui detta a
voce NON l'abbiamo mai misurata su Nasdaq/Dow.** Non è "noi abbiamo sbagliato":
è che **il valore misurato batte il valore dettato**, sempre, in questa casa.

➡️ 🥇 **E questo genera lo spunto migliore del referto (S1, §11): la finestra è
un INPUT.** Provare `14:30-14:45` contro `14:25-14:30` costa **una corsa e zero
righe di codice**. È un gradino G1 pulito, un fattore per volta.

---

## 2. 📰 IL SECONDO TITOLO: PAOLO SMENTISCE IL BREAKOUT IMMEDIATO SUGLI NFP — E LO SMENTISCE CON LO STESSO ARGOMENTO DEL NOSTRO DOSSIER DI IERI

**Testuale, r.17, `[T]`:**
> _"Tu lo sai gli NFP, Paolo? **Io li faccio, ma non con la strategia quella del
> breakout immediato**, ne faccio con **un'altra strategia che stiamo testando**,
> **già due volte che va bene**, vediamo un po' se continua ad andare bene, poi
> quando stiamo sicuri […] **l'NFP non si può fare con lo slippage, perché lì lo
> slippage è troppo forte**"_

### 2.1 🎯 Perché questa frase vale più di tutta la lezione tecnica

`report/coach_paolo/NEWS_BREAKOUT_OCO_NFP_2026-09-03.md` è stato scritto **il
giorno prima** partendo dall'osservazione di Claudio (commenti
`News Breakout M15 OCO | NFP BUY/SEL` sul conto di Paolo, USDJPY e D30EUR,
**07/08 alle 13:30 server**). Il dossier §5.2 elencava quattro insidie, e la
**numero 1** era:

> _"**Slippage all'attivazione** — sul rilascio il book si svuota: uno stop
> order viene eseguito **al prezzo che c'è**, non a quello scritto. È l'unico
> momento della giornata in cui lo slippage può valere più dello stop."_

🟢 **Ventiquattr'ore dopo, il proprietario di quel conto dice la stessa cosa
con parole sue.** Non è convergenza fra fonti indipendenti (è la fonte stessa
che parla del proprio conto): **è una CONFERMA DIRETTA dell'insidia n.1 dalla
bocca di chi la strategia l'ha usata.**

### 2.2 📌 Cosa cambia nel dossier di ieri — tre righe

| Punto del dossier 03/09 | Stato dopo questa live |
|---|---|
| §5.4 _"la contraddizione col corso: il corso dice «no giorni FOMC/NFP», il conto di Paolo trada NFP"_ | 🟢 **RISOLTA, dalla sua voce**: quei trade sono **il metodo VECCHIO**. Oggi dichiara di **non fare più il breakout immediato su NFP** |
| §5.2 insidia n.1 (slippage) | 🟢 **CONFERMATA dal relatore** |
| _"cercare il prodotto è cercare una cosa che probabilmente non esiste"_ | ⚪ **invariata**: non nomina nessun EA, nessun prodotto, nessun parametro |
| **La "altra strategia"** | 🔴 **ZERO dettagli.** Non dice cosa sia, su quale simbolo, con che stop, con che orario. Solo _"stiamo testando, **già due volte** che va bene"_ → `[D]` con **n=2**. ➡️ **domanda Q2 per Claudio** |

### 2.3 🏠 E il confronto col nostro `ABTG_PostNews` — verificato nel sorgente

| | `ABTG_PostNews.mq5` v1.10 (nostro) | quello che Paolo descrive stasera |
|---|---|---|
| Evento | **ECB / FOMC** (`InpNewsTitleMatch = "ECB"` / `"FOMC"`, riga 91) | **NFP** |
| Momento | **DOPO** la notizia, a un orario fisso (`InpActionHour/Min`, + `InpNewsShiftMinutes`; commento riga 75: _"FOMC (news+10)"_) | **immediato sul rilascio** (quello che dice di **non** fare più) |
| Geometria | `BuyOffset 3 pip` / `SellOffset 3` · **TP 50 / SL 25** · `InpUseOCO=true` · chiusura a scadenza | non dettagliata |
| Rischio | `InpRiskPercent = 3.0` (documento del corso) | — |
| 🔴 **Il pezzo che nessuno si aspetta** | L'AutoTest del nostro EA ha un **caso 3 dedicato: _"slide NFP/USDJPY del corso"_** (righe 176-181), con `X=150.500 / Y=150.000`, `BUY X+3 / SL X−22 / TP X+33`, `SELL Y−2 / SL Y+23 / TP Y−32` | ⚠️ **Cioè: il corso HA una slide NFP su USDJPY, noi l'abbiamo meccanizzata — e stasera il docente dice che su NFP quel meccanismo non si può fare per lo slippage** |

➡️ **Verdetto: NON è la stessa cosa** (evento diverso, timing diverso: il nostro
è **post**-news, il suo era **sul rilascio**). 🟡 **Ma la slide NFP/USDJPY che
sta dentro il nostro autotest è, per ammissione del docente, la parte del
metodo che lui ha smesso di usare.** Non tocco niente: **il caso 3 dell'autotest
verifica l'ARITMETICA, non la bontà della strategia**, e va lasciato dov'è.
➡️ **SPUNTO S6**: quando si rimisurerà PostNews (il verdetto del 07/08 è
**NULLO** per calendario cieco, changelog v1.10), il ramo **NFP** parte con una
smentita esplicita della fonte. **Da scrivere nel round PRIMA di lanciarlo.**

---

## 3. 🔴 IL TERZO TITOLO: LA "GOLDEN AREA" CAMBIA CONFINE PER LA **TERZA** VOLTA IN NOVE GIORNI

| Fonte | Definizione dettata |
|---|---|
| **Live 25/08** (agli atti, §S8) | _"l'area compresa tra **38,2 e 61,8**"_ |
| **Live 27/08** (agli atti, §2) | _"il suo Fibonacci è proprio **tra 61 e 78** all'interno della golden area"_ |
| **Live 03/09** — r.53, `[T]` | _"ha ritestato, guardate **in golden area. Da 50, 61 e 8**"_ → **50 → 61,8** |

E il **78,6** compare di nuovo come **punto di ingresso**, non come invalidazione
(r.91, `[T]`):
> _"è arrivata a **78.6**, qui la **media a 50** […] che coincide con Fibonacci,
> il prezzo gira e torna giù"_

🔴 **Tre definizioni in nove giorni, dallo stesso docente.**
➡️ **Lo spunto S8 del 25/08 (Fibonacci golden area come filtro) resta
⛔ NON IMPLEMENTABILE**, e ora con **tre** prove invece di due. La scelta dei
confini la farebbe **l'implementatore, non la fonte**: è la definizione di curve
fitting. **Riaprire solo col documento scritto della strategia in mano.**

---

## 4. 🚩 IL QUARTO TITOLO: STASERA UNA BANDIERA ROSSA VERA C'È — ED È UNA SOLA FRASE

Il mandato diceva _"in questa trascrizione NON sembra essercene, ma verificalo
tu, non assumerlo"_. **Verificato. Ce n'è una, ed è pesante.**

**Testuale, r.91, `[T]`:**
> _"ora se voi andate a vedere **questa sono entrato proprio sul massimo**,
> vabbè, poi **questa la andiamo a ri[te]nere perché gli indici alla fine
> RIPRENDONO SEMPRE**"_

E il piano di uscita, dichiarato poche righe dopo — `[T]`:
> _"**questa ce l'ho aperta perché ormai la sto seguendo** e **questa qua me la
> voglio rifare per rientrare**, perché io **appena c'ho un saldo positivo la
> chiudo e esco senza danno**"_

E la posizione in questione, `[T]`:
> _"**questo è il negativo, è l'unica che mi è rimasta il negativo**, quell'altre
> sono tutte chiuse in positivo, **questa la devo ancora chiudere**"_

### 🔬 Che cos'è, col metro di casa

| | |
|---|---|
| **NON è** | martingala, griglia, mediazione, recovery a raddoppio. ⚪ **Verificato per grep sul file intero**: `martingal`=**0**, `griglia`=**0**, `mediaz`=**0**, `recovery`=**0**, `raddoppi`=**0** |
| **È** | 🔴 **la premessa mentale di tutte e tre**: tenere aperta una posizione in perdita **senza uno stop di uscita**, con **una tesi non di mercato ma di fede** (_"gli indici alla fine riprendono sempre"_) e **un obiettivo di uscita al pareggio** (_"appena c'ho un saldo positivo la chiudo"_) |
| **Perché ci riguarda** | Su un conto prop questo è **esattamente il comportamento che consuma il Maximum Daily Loss senza chiudere una perdita**: il MDL FTMO è **sull'EQUITY, floating incluso** (`docs/REGOLAMENTO_FTMO_2026-08.md` r.25). Una posizione tenuta "finché non torna" **brucia il muro dei 5% giornaliero mentre è ancora aperta** |
| **Il contrasto interno** | ⚠️ Nella stessa live dice **cinque volte** che lo stop si mette sempre e dove. **La regola la insegna. Su una posizione sua, non l'ha applicata** |

🏠 **Cosa cambia per noi: niente, e va detto perché.** La flotta ha `InpSLMode`
obbligatorio su ogni EA, il **cap 0,65%/sedia** e il **cap rischio aperto 3,25%
(C1)** + **Guardian B1 (pausa 4,0%)** firmati il 18/08. **Questa bandiera non
attacca nessuna nostra porta.** Si archivia come **osservazione sulla fonte**:
👉 quando un numero di questa fonte sarà tentante, va ricordato che **il suo
money management non è il nostro**.

---

## 5. 📊 TABELLA DEI VALORI CONVERGENTI — parametro per parametro

> ⚠️ **Avvertenza di conteggio, sempre la stessa e mai negoziabile:**
> **Paolo (25/08, 27/08, 03/09) è UNA fonte, non tre.** Lo stesso docente che si
> ripete **non è convergenza**: è memoria. **L'unica seconda strada indipendente
> è il nostro repo, misurato real-tick.** Dove scrivo "2 strade" intendo
> *accademia + nostra misura*, mai "due video".

| Parametro / meccanismo | 🎙️ Paolo 03/09 | 🎙️ Paolo 27/08 | 🎙️ Paolo 25/08 | 🔬 Nostro repo (verificato) | Strade **INDIP.** |
|---|---|---|---|---|---|
| **SuperTrend: 3 livelli 2.5 / 3.0 / 3.5, ATR period 10** | ✅ _"moltiplicatore **3.5** […] **e poi? 3 e 2.5** […] **ATR 10** […] **10 periodo**"_ (r.91) | 🟡 3.5 e 3.0 | ✅ 2.5/3/3.5 ATR 10 | ✅ `InpStMult=3.5` / `InpStAtrPeriod=10` (Invert righe 52-53) | **2** 🟢 |
| **Il 3.5 è il valore della strategia Reversal** | ✅ _"noi usiamo per la strategia **super trend reversal il 3.5-10**"_ (r.91) | ✅ "il più solido" | ✅ "ci è sufficiente il 3.5" | 🟡 **misurato: 3.5 su DAX H1/DOW H4/DOW H1 · 3.0 su DAX H4/NAS H1 · 2.5 su CAC H4** | **§7, X1** |
| **Il 3.0 è "il livello che usano tutti"** | ✅ _"il livello più sensibile è **il livello centrale**, perché è **quello che usano tutti i trader**"_ (r.91) | ✅ identico | ❌ "non ci interessano i tre livelli" | 🟡 idem sopra | **2** 🟢 |
| **Stop = "tre stoppini" / 3 candele indietro** | ✅ _"lo stop era **sui tre stoppini**"_ (r.17) · _"**1, 2, 3**, stop qua sopra […] **sulla terza candela, 3 candele indietro** […] perché tu hai **3 candele in direzione**"_ (r.91) | ✅ P16 | ⚪ | 🔴 **diverso**: `InpSLLookback=5` (min/max ultime **5** barre) + `InpSLBufferPips=3` | **1 + delta misurabile** |
| **Trailing: inseguire il prezzo sul SuperTrend, uscire al flip** | ✅ _"metto un **super trend** e inseguo il prezzo sul super trend, **a mano a mano che scende la linea rossa scende lo stop**; quando esco? **Quando il super trend si inverte**"_ (r.91) | ✅ | ✅ | ✅ `InpTrailOnST` + `InpExitOnOpposite` | **2** 🟢🟢 |
| **Trailing alternativo: stop sull'estremo di 3 candele** | ✅ _"inseguivo il prezzo **sulla terza candela**"_ (r.91) | ⚪ | ⚪ | 🔴 assente | **1** |
| **Medie 9 / 21 / 50 "ordinate" come conferma** | ✅ _"quando la **media 50** è andata sopra la **media a 21** e la **media a 9**"_ (r.29) · _"non ho nemmeno un incrocio nella **media 9 con la media 21**"_ (r.91) | ✅ 9/21 | ⚪ | ✅ `ABTG_GoldenCross.mq5` righe 102-104: **`InpEmaFast=9` · `InpEmaMid=21` · `InpEmaSlow=50`** + `InpRequireAlignment=true` | **2** 🟢🟢 |
| **Heiken Ashi: 3 candele, "a cavallo dell'incrocio" (±3)** | ✅ _"le Kinashi le conti dopo l'incrocio della 9-21? **No, al cavallo dell'incrocio** […] **tre candele prima, tre candele dopo o in mezzo all'incrocio**"_ (r.21) | ⚪ | ⚪ | 🟡 `InpHACount=3` ✅ **ma** `InpCrossLookback=8` (l'incrocio nelle ultime **8** barre, **solo all'indietro**) | **2 sul "3", 🔴 delta sulla FINESTRA** |
| **La media 200 come ostacolo/target e l'ingresso alla sua rottura** | ✅ _"**rottura EMA 200 confermata**, vado in D1 […] entro a mercato"_ (r.91) | ✅ | ✅ | ✅ SupRev `InpEma4=200` | **2** 🟢 |
| **Bollinger: il movimento è ESAURITO solo quando il prezzo RIENTRA nelle bande** | ✅ _"il prezzo si intende **esaurito quando dopo l'espansione rientra all'interno delle bande**; **finché il prezzo [non] rientra nelle bande è anticipare il movimento e tirare una monetina**"_ (r.91) | 🟡 mediana/banda opposta | 🟡 accennate | 🔴 **assenti** da SupRev/Invert (esistono in `ABTG_Bulge`, `GoldenCross` `InpUseBBExpand=false`) | **1, ma 🏆 vedi S3** |
| **Compressione (bande strette/parallele) = benzina** | ✅ _"quando le bande di Bollinger si stringono […] **fa la finta da una parte e va da quell'altra**"_ (r.91) · _"**compressione = prezzo si carica, sta facendo benzina**"_ | ✅ P11 | ✅ | 🟡 `InpUseBBExpand` esiste ma **default false** | **1** |
| **La candela IMPULSIVA che conferma l'uscita dalla compressione** | ✅ _"come lo capisci che va da quell'altra? **La candela impulsiva**"_ (r.91) | ✅ P10 | ⚪ | 🔴 assente (esiste `InpMinBodyPct=50` in ORB, **default off**) | **1** |
| **ADR come metro (Range Analysis)** | ✅ **4ª comparsa in 9 giorni** — _"se voi mettete in **range analysis** […] questo fa **115 pip** di movimento, oggi il Japan ha fatto **248 pip** […] ieri **270**"_ (r.69-73) + la dashboard nuova mostra _"quanto movimento ha fatto durante il giorno **in percentuale rispetto all'ADR**"_ (r.91) | ✅ lookback 50 gg | ✅ "50 giorni" | 🔴 **MAI IMPLEMENTATO** — `REGISTRO_TEST.md` righe 284 e 299 = **due idee**, ferme da settimane | **1 + 🔴 buco nostro, 4ª volta** 🏆 |
| **ADR come filtro di ESAURIMENTO (>2× ADR → si riposa)** | 🆕 ✅ _"ha fatto **più del doppio** della media […] questa è una situazione che ha fatto questa **corsa: si deve riposare**"_ (r.71-75) | 🟡 (distanza ≤ ADR) | ⚪ | 🔴 assente | **1, NUOVO** |
| **Cascata dei TF con moltiplicatore 4-5** | 🆕 ✅ _"se stai su **15** andrai a cercare meglio in **H4** che non in H1 […] **normalmente il moltiplicatore è 4-5**: da D1 a Weekly è **5**, da H4 a D1 sono **6** candele, da H1 a H4 sono **4**"_ (r.91) | ✅ D1→H4→H1 | ✅ teorema 3 TF | 🔴 **assente come filtro esplicito** | **1 + 🔴 buco nostro, 4ª volta** |
| **SuperTrend: pavimento di timeframe** | ✅ _"**in super trend si fa bene dall'H1 in su**, perché l'H1 fa il segnale più solido […] **va bene anche in M5, non in M1 o M3**"_ (r.91) | 🟡 "Invert meglio in **H1**, poi M15" | ❌ "da H4 a Weekly" | 🟡 flotta M15/H1/H2/H4 | **§7, X3** |
| **ORB: si aspetta la CHIUSURA di una candela fuori dal range** | ✅ _"la **prima candela che si forma INTERAMENTE fuori** dall'ORB"_ (r.91) | ⚪ | ⚪ | 🟡 `InpUseCloseConfirm` **esiste ma default FALSE**: i nostri ORB entrano con **pendenti STOP** a `EntryPoints×K` | **§7, X2 — delta reale** |
| **ORB: stop sull'estremo OPPOSTO del range** | ✅ _"**l'ORB si mette lo stop sul livello opposto**, quindi era bello ampio"_ (r.91) | ⚪ | ⚪ | ✅ `InpSLMode = ORB_SL_OPPRANGE` (**default**) | **2** 🟢🟢 |
| **ORB: chiusura a fine giornata** | 🟡 _"l'ORB è un'operazione che **si chiude in giornata**"_ — **ma poi la contraddice** (§6, Y2) | ⚪ | ⚪ | ✅ `InpCloseAtEnd=true`, `InpEndHour=22 / Min=59` | **2** 🟢 (sulla versione "in giornata") |
| **ORB: 1 solo strumento per sessione** | ✅ _"Dow Jones, Nasdaq o S&P: **uno solo che ne prendete, se no impazzite**"_ (r.91) | ⚪ | ⚪ | 🟡 `InpOneTradePerDay=true` (per **simbolo**, non per famiglia) | **1** |
| **Filtro di ampiezza del range ORB** | 🔴 ✅ **NESSUNO**: _"hai un limite sulla dimensione del range dell'ORB? **No, l'ampiezza mi condiziona lo stop loss, la size** […] **mi condiziona la size e basta**"_ (r.91) | ⚪ | ⚪ | 🔴 **`REGISTRO_TEST.md` riga 230 dice l'OPPOSTO**: _"Niente trade se **range troppo ampio** / stop troppo largo (ORB tardivo con canale ~140 pt → skip)"_ | **§6, Y1 — CONTRADDIZIONE COL MATERIALE DEL CORSO** |
| **Volumi come conferma** | 🟡 nominati sui "buchi volumetrici" e _"questo è il prezzo salito **con volume**"_ (r.91), **mai come soglia** | ✅ | ✅ | ✅ **R101: `02_volumi` unico filtro sopravvissuto a G1+G2+G3** | **2** 🟢 (ma stasera non aggiunge un numero) |
| **Imbalance da coprire** | ✅ _"non sono entrato in modo meccanico **perché qui c'è ancora un imbalance aperto**"_ (r.91) · _"questo è un **imbalance di 14** [pip], io me lo stanno mettendo qua"_ | ✅ P7 | 🟡 | 🟡 `ABTG_GapFill` / `GapContinuation` (dominio diverso) | **1,5** 🟡 |
| **S/R: forza = numero di tocchi** | ✅ _"questo livello è stato già **testato 12 volte sui minimi, 5 volte sui massimi**, pertanto c'è già stato **17 volte** fermo: **è un livello forte**"_ (r.91) | ✅ (l'indicatore regalato conta i tocchi) | ⚪ | 🔴 assente | **1 — ma conferma che l'indicatore Q3 del 27/08 è IN USO** |
| **S/R: massimi/minimi CONTRAPPOSTI pesano più di quelli interni** | 🆕 ✅ _"massimi e minimi presi **all'interno** di quest'area **non hanno lo stesso significato** di massimi e minimi **contrapposti** […] sono degli **estremi**"_ (r.91) | 🟡 | ⚪ | 🔴 assente | **1, NUOVO** |
| **Filtro news / rischio-evento** | 🟡 _"**domani è giornata che può scombinare tutto questo ragionamento**"_ (r.17) — **avverte, non blocca** | 🟡 opera lo stesso | 🔴 "non si fa quella" | ✅ **news OUT per criterio, MISURATO (R101)** + Guardian B1 | **§6, Y4** |
| 🔴 **REGOLE PROP** | ⚪ **ZERO** | ⚪ ZERO | ⚪ ZERO | — | **niente da confrontare** |

### 🏆 IL DATO PIÙ SOLIDO DELLA SERATA

**Il set di medie 9 / 21 / 50 "ordinate" del Golden Cross**, e non perché lui lo
ripeta: perché è l'unico parametro della serata che sta **già scritto identico
nel nostro sorgente** (`ABTG_GoldenCross.mq5`, righe 102-104, `InpEmaFast=9`,
`InpEmaMid=21`, `InpEmaSlow=50`, `InpRequireAlignment=true`) e che stasera lui
usa **due volte per DECIDERE** — una per entrare (r.29), una per **scartare** un
trade (_"non devo fare la shortata perché **non ho nemmeno un incrocio nella
media 9 con la media 21**: questo è un **ingresso da FOMO**"_, r.91).

⚠️ **Il limite, come sempre: convergenza fra "l'accademia" e "il nostro codice
scritto dall'accademia" NON è convergenza fra fonti indipendenti.** È
**tracciabilità**: sappiamo da dove viene il numero. **Nota agli atti, non edge.**

---

## 6. ⚔️ LE CONTRADDIZIONI

| # | Contraddizione | Le due voci | Gravità |
|---|---|---|---|
| **Y1** | 🔴 **ORB: nessun filtro di ampiezza (03/09) vs "skip se range troppo ampio" (materiale del corso già agli atti)** | 03/09, r.91: _"**mi condiziona la size e basta**"_ e anzi _"è **più difficile che ti prenda lo stop** con range ampio molto molto ampio"_. `REGISTRO_TEST.md` r.230: _"**Niente trade se range troppo ampio** / stop troppo largo"_ | 🔴 **ALTA** — sono due politiche **opposte** sullo stesso parametro. Il registro attribuisce quella nota al corso; oggi il docente la nega |
| **Y2** | 🔴 **ORB: intraday o multiday?** | _"l'ORB è un'operazione che **si chiude in giornata**"_ **e**, tre righe dopo, _"perché non la porti avanti? **Se io mi [entro] con la size bassa questa me la porto avanti**"_ + _"si lascia in macchina **tutto il giorno**, si lascia **finché non ti prende lo stop**"_ (r.91) | 🔴 **ALTA** — e tocca il prop: §8.3 |
| **Y3** | 🔴 **ORB: voce 15 min DOPO l'apertura vs indicatore 5 min PRIMA** | §1 | 🔴 **ALTA — il titolo del referto** |
| **Y4** | 🟡 **NFP: "domani può scombinare tutto" ma nessuna regola di astensione** | Avverte (r.17, r.43: _"peccato, domani c'è gli NF[P], perché […] possono scombinare un po' tutto"_) e continua a pianificare ingressi per domani | 🟡 **MEDIA** — stesso schema del 27/08 su Jackson Hole (Y2 di quel referto): **avverte e opera** |
| **Y5** | 🔴 **Golden area: terza definizione in 9 giorni** | §3 | 🔴 **ALTA — affossa definitivamente S8** |
| **Y6** | 🟡 **SuperTrend: "3.5 è il migliore" ma "il 3.0 è il più sensibile perché lo usano tutti"** | _"perché non usiamo il 3.5? […] perché è **un livello più estremo** e quando il prezzo va a testare questo livello **è più facile [che avvenga] l'inversione** […] però **il livello di trading normale che si usa è il 3[/]10**"_ → poi _"noi usiamo per la strategia super trend reversal **il 3.5-10**"_ (r.91) | 🟡 **MEDIA** — `[T?]` il passaggio è biascicato. 🟢 **Ma i NOSTRI numeri già dicono che nessuno dei due è universale** (3.5 su 3 sedie, 3.0 su 2, 2.5 su 1) |
| **Y7** | 🟡 **COT: "sugli indici non c'è" — un allievo lo smentisce in diretta** | Paolo: _"per vedere invece **gli indici** bisogna andare **con le opzioni**, è un altro mondo"_. Allievo: _"io però sul **COT ho trovato sia DAX che NASDAQ**"_. Paolo: _"**No, questo non c'è**"_ (r.9-13) | 🟡 **MEDIA** — non risolta in diretta. `[?]` Non ho modo di dirimerla da questa fonte |
| **Y8** | 🟡 **La forza valutaria dichiarata è aritmeticamente incoerente** | _"CHF meno **0,26**, Japan più **0,25**. **Il fatto che sono tutti e due negativi** cosa vuol dire?"_ (r.13) — **uno dei due è positivo** | 🟡 `[T?]` **numeri non firmabili.** Uso: nessuno |
| **Y9** | 🟡 **Insegna lo stop e poi tiene aperto un perdente "perché gli indici riprendono sempre"** | §4 | 🔴 **ALTA sul piano della disciplina, NULLA sul piano operativo per noi** |
| **Y10** | 🟢 **"Non si fanno le cose per provare" — e lo dice contro se stesso** | _"non ero convinto su questo ingresso, tant'è che sono **[partito] con 0,1**, neanche con 0,2, con la size minima: questo vuol dire che **l'ho fatto per provare**, non perché ero convinto. E **non si fanno le cose per provare**: le cose si fanno **quando c'è il setup**, perché se no diventa **una scommessa**"_ (r.91) | 🟢 **A SUO FAVORE** — autocritica, non vanteria |

---

## 7. 🏠 CONFRONTO COL REPO — verificato nel sorgente, mai a memoria

| Elemento della live | Stato in casa (file + riga) | Verdetto |
|---|---|---|
| 🏆 **ORB: finestra del range** | `ABTG_ORB.mq5` righe 108-111 e `ABTG_ORB_Ottimizzato.mq5` righe 128-131 → **14:25→14:30 server** (pre-apertura) | 🔴 **X-1: DIVERGE dalla voce** (14:30→14:45). ➡️ **S1, il gradino migliore del referto** |
| 🏆 **ORB: distanza d'ingresso** | `InpEntryPoints = 10.0` × `InpK = 1.0` (riga 123-124) | 🟢🟢 **COMBACIA AL DECIMALE** con `InpEntryPoints 10.0` del file dei parametri |
| 🏆 **ORB: tabella K per strumento** | header righe 11-13: _"indici/oro=**1.0**, 225JPY=**10**, cross JPY=**0.01**, altri forex=**0.0001**, oil=**0.01**"_ | 🟢🟢 **COMBACIA 6 GRUPPI SU 6** con `InpK1..InpK6` del file dei parametri |
| 🏆 **ORB: fine giornata** | `InpEndHour=22 / InpEndMin=59`, commento _"Indicatore: 22:59"_ | 🟢🟢 **COMBACIA** con `InpTimeEnd 22:59:59` |
| **ORB: stop sull'estremo opposto** | `InpSLMode = ORB_SL_OPPRANGE` (default, riga 129) | 🟢 **COMBACIA** con _"l'ORB si mette lo stop sul livello opposto"_ |
| 🔴 **ORB: come si entra** | `InpUseCloseConfirm = false` (default, riga 143) → **pendenti STOP** | 🔴 **X-2: DIVERGE.** Lui aspetta **la chiusura di una candela interamente fuori**. Il nostro input **esiste già**: è un `bool`. ➡️ **S2** |
| 🔴 **ORB: filtro ampiezza range** | ⚪ **nessuno** in entrambi gli EA | 🟡 **oggi il docente dice che non serve** (Y1). Noi non ce l'abbiamo: **coerenti con la voce di stasera, incoerenti col registro r.230** |
| 🔴 **ORB: breakeven** | `InpBreakeven=true` **dopo la parziale** (`InpTP1Pct=50` a `InpTP_R=2.0`) | 🔴 **X-3: meccanismo DIVERSO.** Lui porta lo stop in pari a **30-40 punti fissi**, prima di qualunque parziale. ➡️ **S4** |
| **ORB: trailing** | `InpUseTrailEMA=true` su **EMA 9** (M5), `InpEmaFast=9 / InpEmaSlow=21` | 🟢 stessa famiglia (medie 9/21), 🟡 lui traila **sul SuperTrend** o su **3 candele** |
| **Golden Cross: medie** | `InpEmaFast=9 · InpEmaMid=21 · InpEmaSlow=50` + `InpRequireAlignment=true` | 🟢🟢 **COMBACIA ALLA LETTERA** |
| 🟡 **Golden Cross: finestra dell'incrocio** | `InpCrossLookback = 8` — l'incrocio nelle ultime **8 barre**, **solo all'indietro** | 🟡 **X-4: DIVERGE.** Lui: _"**al cavallo dell'incrocio**: tre candele **prima**, tre **dopo** o **in mezzo**"_ → finestra **±3, simmetrica**. ⚠️ **Il "prima" non è implementabile in un EA su barra chiusa** (guarderebbe il futuro). ➡️ **S5, e la nota di realismo che serve** |
| **Golden Cross: Heiken Ashi 3 candele** | `InpHACount = 3` | 🟢 **COMBACIA** |
| **SuperTrend 3.5 / ATR 10** | `InpStMult=3.5` / `InpStAtrPeriod=10` (Invert righe 52-53) | 🟢 **COMBACIA — terza conferma della stessa fonte** |
| **Trailing su ST + uscita al flip** | `InpTrailOnST`, `InpExitOnOpposite` | 🟢 **già dentro** |
| 🔴 **ADR (Range Analysis)** | 🔴 **MAI IMPLEMENTATO** — `REGISTRO_TEST.md` righe 284, 299 = **due idee** | 🔴 **BUCO CONFERMATO, QUARTO PASSAGGIO in 9 giorni** |
| 🔴 **Filtro trend TF superiore (×4-5)** | 🔴 **assente** (le EMA stanno sul TF operativo) | 🔴 **BUCO, quarto passaggio.** Resta **SPUNTO**, non candidato: **stessa fonte che si ripete non è convergenza** |
| 🔴 **Bollinger "rientro nelle bande = esaurito"** | 🔴 assente da SupRev/Invert; `InpUseBBExpand=false` in GoldenCross | 🟡 **delta, ma stasera è la regola più PULITA e meccanizzabile della serata** ➡️ **S3** |
| 🔴 **Williams %R con soglia 50** | 🟡 esiste **solo** in `ABTG_AltaVelocita.mq5` (righe 19, 36-37, 45), **non** nella famiglia SupRev/GoldenCross/ORB | 🆕 **indicatore NUOVO per questa famiglia.** `[T?]` la trascrizione scrive _"William per center range"_ = **Williams Percent Range**. ➡️ **S7, bassa** |
| **Regole prop** | ⚪ **zero contenuto nella live** | ⚪ **niente da confrontare con `report/METRO_PROP.md`** |

### 7.1 🧾 La verifica che vale la pena scrivere: **l'indicatore V17 NON è cambiato, e il nostro EA non è andato alla deriva**

Il nostro `ABTG_ORB.mq5` dichiara nell'header di replicare **`ORB_Indicator_V15`**.
Il file dei parametri di oggi è la **V17 1.17**. Su **quattro parametri
verificabili** (finestra del range, `EntryPoints`, tabella K a 6 gruppi, fine
giornata) **la V17 dà gli stessi numeri della V15**, e Paolo lo conferma a voce:
_"ha delle modifiche rispetto al precedente? **No, [è] lo stesso**"_ (r.91).

🟢 **Conclusione: due versioni e qualche mese dopo, la nostra replica è ancora
fedele allo strumento. Nessuna deriva da correggere.** Questo è un controllo
che non era mai stato fatto, ed è passato.

---

---

# 📋 PARTE 2 — LA SCHEDA COMPLETA

```
FILE            LIVE PAOLO 03.09.26 2026-09-03 21-30-00-388.txt
                (56.453 caratteri, 121 righe — r.91 e' un blocco unico da 38.976)
                + ORB_Indicator_V17_parametri_2026-09-04.txt (59 righe)
RELATORE        PAOLO — [T], nominato 20+ volte dagli allievi. Co-docente di
                Emiliano nella stessa accademia (FTD/ABTG): lo cita 6 volte
                ("questo lo presento a Emiliano", "Emiliano usa tre livelli").
ALLIEVI         Mauro, Natalia, Anna, Stefano [T]
OGGETTO         (1) studio serale multi-strumento sui cross JPY (CHFJPY, GBPJPY,
                    CADJPY) dopo il movimento dello yen
                (2) AUDNZD / "CAD" su PTE + livelli
                (3) 🏆 ORB su indici (DAX / Dow / Nasdaq / S&P) — il blocco piu'
                    denso, con il racconto di due operazioni reali e degli errori
                (4) SuperTrend a 3 livelli, parametri e timeframe
                (5) lettura di price action guidata per un'allieva (compressione,
                    candela impulsiva, medie che si allargano)
                (6) anteprima di una DASHBOARD in Python
NESSUNA PROP, NESSUN EA NOMINATO, NESSUNA CHALLENGE, NESSUN TRUCCO ANTI-PROP.
```

## 8. 🔢 PARAMETRI CON VALORE — tutti i numeri, con citazione ed etichetta

### 8.1 🎯 ORB — la strategia del blocco principale

| Parametro | Valore dichiarato | Citazione (r.91 salvo indicato) | Etichetta |
|---|---|---|---|
| **Range DAX** | **09:00 → 09:15** | _"la mattina si fa **dalle 9 alle 9 e un quarto** col DAX"_ | `[T]` sui numeri · `[I]` sul fuso (italiano) → **08:00-08:15 server** |
| **Range USA** | **15:30 → 15:45** | _"pomeriggio si fa **dalle 15 e 30 alle 15 e 45** con Dow Jones, Nasdaq o Standard [& Poor's]"_ | `[T]` sui numeri · `[I]` sul fuso → **14:30-14:45 server** |
| **Durata del range** | **15 minuti** | _"questa casella che è composta dai **primi 15 minuti** della contrattazione"_ | `[T]` |
| **Trigger d'ingresso** | **prima candela chiusa INTERAMENTE fuori dal range** | _"bisogna aspettare la **prima candela che si forma interamente fuori** dall'ORB"_ | `[T]` — ⚠️ "interamente" (ombre comprese) è **più stretto** del "corpo fuori" già a registro (r.224) |
| **Deroga discrezionale** | ⚠️ **non entra se c'è un imbalance aperto** | _"perché non sono entrat[o] in modo meccanico? **Perché qui c'è ancora un imbalance aperto**, ho detto: ve lo vengo ad aspettare qua"_ | `[T]` — 🚩 **la regola meccanica ha una deroga a occhio: non automatizzabile 1:1** |
| **Stop** | **estremo OPPOSTO del range** | _"l'ORB si mette **lo stop sul livello opposto**, quindi era bello ampio, lo stop era **un stop ampio**"_ | `[T]` |
| **Filtro di ampiezza** | 🔴 **NESSUNO** | _"hai un limite sulla dimensione del range? **No**, l'ampiezza mi condiziona **lo stop loss, la size** […] **mi condiziona la size e basta**"_ | `[T]` — vedi Y1 |
| **Ampiezza grande = ?** | 🟡 **meno rischio di stop** | _"è **più difficile che ti prenda lo stop** con range ampio, molto molto ampio"_ | `[T]` — `[D]` come tesi, **nessun numero a sostegno** |
| **Breakeven** | 🏆 **a 30-40 punti** | _"**quando il prezzo mi fa 30-40 punti io porto lo stop in profit**"_ · confermato dalla domanda dell'allievo: _"tu metti lo stop in profit **dopo 30-40 punti a prescindere dai livelli tecnici**? — **Quando faccio l'ORB sull'indice io mi trovo bene a fare così**"_ | 🟢 `[T]` — **due passaggi indipendenti nella stessa risposta** |
| **Regola size ↔ gestione** | 🆕 **size robusta → parzializzo · size leggera → lascio correre** | _"fa 30-40 punti: **[se sono] entrato con una size più robusta parzializzo** […] invece **[se sono] entrato con una size più leggera lo lascio correre**"_ | `[T?]` sul verbo biascicato ("scinto"), `[T]` sul meccanismo |
| **Strumenti** | **DAX** (mattina) · **Dow / Nasdaq / S&P** (pomeriggio), **UNO SOLO** | _"uno solo che ne prendete, **se no impazzite**"_ | `[T]` |
| **Durata** | 🔴 **contraddittoria** | _"si chiude in giornata"_ **vs** _"si lascia in macchina tutto il giorno, **finché non ti prende lo stop**"_ **vs** _"con la size bassa **questa me la porto avanti**"_ | 🔴 Y2 |
| **Reattività degli indici** | S&P **il più lento** · DAX **il più nervoso** · Dow **il più nervoso** · Nasdaq **segue l'S&P** | _"lo S&P è il più lento, il DAX è il più nervoso, il Dow Jones è il più nervoso, il Nasdaq segue abbastanza in questo periodo l'andamento dello S&P"_ | `[T?]` — **"il più nervoso" detto di DUE indici**: probabile duplicazione della trascrizione. **Non firmo la classifica** |
| **Peso dei tech nell'S&P** | **70-80%** | _"i tecnologici rappresentano quasi il **70-80% del mercato dello S&P**"_ | 🔴 `[D]` — **nessuna fonte, nessuna data. Non verificabile da questa trascrizione. Non si usa** |

**I numeri dell'operazione ORB reale raccontata (Nasdaq/Dow, `[?]` quale):**

| Numero | Contesto | Citazione | Etichetta |
|---|---|---|---|
| **90 punti** | movimento catturato | _"qui ha fatto questo movimento, **ha fatto 90 punti**, io non ho parzializzato perché ero convinto che andasse avanti"_ | `[T]` |
| **100 punti** | distanza al livello successivo | _"visto che il percorso non era tanto, **erano solo 100 punti**"_ | `[T]` |
| **0,2 lotti** | taglia | _"ero dentro **con 0,2**, non ero dentro con un lotto"_ | `[T]` |
| **~150 €** | profitto perso allo stop-in-pari | _"**ho perso i 150 euro di profitto** perché ero dentro con 0,2"_ | 🟡 `[D]` — ⚠️ **poche righe prima aveva detto "almeno 100 euro"**. Due numeri per lo stesso evento |
| **~250 €** | quello che avrebbe fatto entrando all'incrocio | _"uno si [me]tteva con **0,2**, qua **facevi 250 euro**"_ | `[D]` |
| **18 €** | lo stop preso per distrazione | _"per uno stop di **18 euro** […] **io ero al telefono** e ho fatto questa cosa"_ | `[T]` |
| **5.000 € / lotto** | controvalore del movimento | _"questa operazione la fai **con un lotto: sono 5 mila euro**"_ | 🟡 `[D]` — coerente con 0,2 → 1.000 € |
| **500 € (drawdown a 0,2)** | 🔴 **conto rifatto in diretta** | _"se entro qua con un lotto qui sono **due [migliaia] di euro**, invece se entro con 0,2 qui c'è un drawdown di **100 euro** — **scusate, 500 euro, ho sbagliato, io ho sbagliato conto**"_ | 🔴 `[T? rotto]` — **si autocorregge e il conto resta incoerente. NON firmo nessuno di questi tre numeri** |

### 8.2 📐 SUPERTREND — i tre livelli (terza conferma della stessa fonte)

| Parametro | Valore | Citazione (r.91) | Etichetta |
|---|---|---|---|
| **ATR period** | **10** | _"poi **ATR 10** […] quanto? **ATR 10** […] **10 periodo**"_ | 🟢 `[T]` — ripetuto 3 volte |
| **Moltiplicatori** | **2.5 · 3 · 3.5** | _"moltiplicatore **3.5** […] **e poi? 3 e 2.5**"_ | 🟢 `[T]` |
| **Valore della strategia Reversal** | **3.5 / 10** | _"noi usiamo per la strategia super trend reversal **il 3.5-10**"_ · _"super trend si mette nella strategia super trend reversal **3 barra punto 5**"_ | `[T]` sul valore, `[T?]` sulla dettatura |
| **Oro** | **3.5 e basta** | _"ma l'oro che strategia fai? Il super trend reversal? — Sì. — E allora **usa 3.5 e basta**"_ | `[T]` |
| **DAX M3** | **3.5 funziona bene** | _"il **3.5 funziona bene anche sul 3 minuti DAX, molto bene**"_ | `[D]` — ⚠️ **e il DAX M3 noi l'abbiamo MISURATA MORTA** (`REGISTRO_TEST.md` r.78: OHLC 33% pos, short 0%; capitolo BREAKOUT M5 **CHIUSO** il 26.07.26). **Non si riapre** |
| **Il livello più "sensibile"** | **quello CENTRALE (3.0)** | _"tra questi tre livelli il livello più sensibile è **il livello centrale**, perché è **quello che usano tutti i trader**"_ | `[T]` — combacia col 27/08 |
| **Livello di BREAKOUT** | **il terzo (3.5)** | _"noi teniamo come **livello di breakout il terzo livello**"_ | `[T]` |
| **Scalping progressivo** | **1° / 2° / 3° livello** | _"**normalmente a fare scalping si fa uno scalping progressivo**: lo fa sul primo livello, sul secondo e sul terzo […] la reazione più significativa normalmente ce l'hai **sul secondo o sul terzo**"_ | `[T]` — 🔎 **è la scala d'ingresso del P3 del 27/08, ora a TRE gradini** |
| **Pavimento di TF** | **M5** (meglio **H1+**) | _"va bene anche in M5, **non in M1 o M3** […] **in super trend si fa bene dall'H1 in su**, perché l'H1 fa il segnale più solido"_ | `[T]` |
| **Costo del TF basso** | in M15 lo stop va portato in pari subito | _"se [entri] a questo livello devi portarti lo stop — **questi sono 9 punti** — diventa un problema […] sono **quasi operazioni [di] scalping**"_ | `[T]` |

### 8.3 📊 GOLDEN CROSS + HEIKEN ASHI

| Parametro | Valore | Citazione | Etichetta |
|---|---|---|---|
| **Medie** | **9 · 21 · 50** | _"quando la **media 50** è andata sopra la **media a 21** e la **media a 9**"_ (r.29) | `[T]` |
| **Finestra Heiken Ashi** | **±3 candele attorno all'incrocio** | _"le Kinashi le conti dopo l'incrocio della 9-21? **No, al cavallo dell'incrocio** […] **tre candele prima, tre candele dopo o in mezzo all'incrocio**"_ (r.21) | 🟢 `[T]` — ⚠️ "kinashi" = **Heiken Ashi**, `[I]` alta confidenza (lui stesso poi le chiama "tenaci"/"a pienarci": la trascrizione le storpia in 4 modi) |
| **Ritardo tollerato** | fino a **4 candele** dopo l'incrocio | _"l'incrocio c'è stato qua, io l'ho visto un po' [in] ritardo […] **una, due, tre, quattro: io l'ho vista sulla quarta candela**"_ (r.27) | `[T]` |
| **Cosa fare se sei in ritardo** | **non inseguire: aspettare il pullback** | _"**io non sono entrato subito, io mi sono messo [sul] pullback**, l'ho aspettato un po' il prezzo, e **questo è stato utile** perché poi **non ho sofferto un drop**"_ (r.27) | 🟢 `[T]` — **quarta conferma del RETEST** (la nostra `RETEST` è +64,76 su 6 pos) |
| **Contesto obbligatorio** | sotto **EMA 200** e **EMA 50** in H4 | _"lo vuoi [fare] in H4 **se siete sotto la media 200, se siete sotto la media 50**: questo ingresso era un ingresso abbastanza **confident**"_ (r.33) | `[T]` |
| **Trade reale** | stop **50 punti** → **512 punti**, R:R **1 a 10** | _"lo stop era **sui tre stoppini** […] con un **stop di 50 punti ha fatto 512 punti**, [rischio rendimento] **di uno a 10**"_ (r.17) | 🟡 `[D]` — ✅ **aritmeticamente coerente** (512/50 = 10,24) |
| ⚠️ **Attribuzione** | 🔴 **NON è un trade ORB** | Il 50/512 sta nel blocco **CHFJPY / Golden Cross** (r.17), **non** nel paragrafo ORB (r.91). ⚠️ **Nel mandato era attribuito all'ORB: la lettura riga per riga dice il contrario.** Nel paragrafo ORB i numeri sono 90 punti / 30-40 di breakeven / 0,2 lotti | 🔴 **correzione di attribuzione** |
| **Il trade "500 pip"** | **500 punti** su CHFJPY | _"avendo fatto l'operazione su CHF Japan, **il 500 pip** […] **dopo 500 punti uno può anche uscire soddisfatto**"_ (r.15-17) | `[D]` — `[?]` se sia lo stesso trade del 512 |

### 8.4 📏 ADR / RANGE ANALYSIS — quarta comparsa in nove giorni 🏆

| Cosa | Dichiarato | Citazione | Etichetta |
|---|---|---|---|
| Strumento | **"range analysis"** | _"se voi mettete in **range analysis**, il Japan **oggi ha fatto quasi il doppio del movimento normale**"_ (r.69) | 🟢 `[T]` — **il nome corretto, finalmente**: il 27/08 la trascrizione lo storpiava in _"regionalist"_ |
| ADR del simbolo | **115 pip** | _"**questo fa 115 pip di movimento**"_ (r.69) | `[T]` — 🔴 **simbolo `[?]`**: dice "il Japan", che è una **valuta**, non un cross |
| Movimento di oggi | **248 pip** | _"**oggi il Japan ha fatto 248 pip**, ha fatto **più del doppio**"_ (r.69-71) | `[T]` |
| Movimento di ieri | **270 pip** | _"**ieri ha fatto 270 pip**, oggi 248"_ (r.73) | `[T]` |
| 🆕 **La regola d'uso NUOVA** | **oltre ~2× ADR → il mercato "si deve riposare"** | _"questa è una situazione che chiaramente ha fatto questa cor[sa]: **si deve riposare**"_ (r.73-75) | 🟢 `[T]` — ➡️ **filtro di esaurimento meccanizzabile: `ADR_consumato(oggi) > 2 → niente nuovi ingressi in direzione`** |
| **Nella dashboard nuova** | **% del movimento giornaliero rispetto all'ADR** + **ADR giornaliero** | _"e qua **quanto movimento ha fatto durante il giorno in percentuale rispetto all'ADR**, e qui **qual è l'ADR giornaliero**"_ (r.91) | 🟢 `[T]` |
| ⚠️ **Il lookback** | ⚪ **NON ridetto stasera** | resta quello del 27/08 (**10 settimane = 50 giorni**) | ⚪ **buco**: stasera non lo conferma |

### 8.5 🧮 TUTTI GLI ALTRI NUMERI

| Valore | Contesto | Citazione | Etichetta |
|---|---|---|---|
| **Moltiplicatore fra TF: 4-5** | scelta del TF di contesto | _"**normalmente il moltiplicatore è 4-5**: da D1 a Weekly è **5** perché la week sono **5 candele**; da H4 a D1 sono **6** candele; da H1 a H4 sono **4**; da M30 a H1 non è una candela. Pertanto **[da] H4 [vai in] M15**; [da] M15 si va in H1 o in H4"_ (r.91) | 🟢 `[T]` sui numeri, `[T?]` sull'ultima frase invertita |
| **TF operativo M15 → contesto H4** | | _"se noi mettiamo su 15 minuti, il trend di fondo vedi il daily? **No, devi moltiplicare per 4**: se stai su 15 andrai a cercare meglio in **H4** che non in H1"_ (r.91) | `[T]` |
| **TF operativo M15 → esecuzione M3/M5** | | _"se stai in tempo operativo in **M15** lo fai in **M3 o in M5**"_ (r.91) | `[T]` |
| **Stop del pendente speculativo: 10-20 pip** | ingresso in controtendenza su resistenza forte | _"uno potrebbe anche mettere un pendente su quest'area […] con uno stop **molto molto stretto**, uno stop di un **10-20** al massimo"_ (r.89) | `[T]` — 🟡 **e poi lo sconsiglia**: _"è meglio **mettersi un allarme** invece di mettere l'ordine pendente"_ |
| **Forza del livello: 17 tocchi** | **12 sui minimi + 5 sui massimi** | _"questo livello è stato **già testato 12 volte sui minimi, 5 volte sui massimi**, pertanto c'è già stato **17 volte fermo**: il prezzo è un livello forte"_ (r.91) | `[T]` |
| **Imbalance da 14 pip** | motivo per NON entrare | _"io non sarei mai entrato qua perché ho tutto questo imbalance […] questo è un **imbalance di 14** […] se lo ricaccio **30** mi dà la media 50"_ (r.91) | `[T?]` sull'unità |
| **Distanza al target: 30 punti** | valutazione di un ingresso | _"questo pezzettino qua, da qua a qua, sono **30 punti**"_ (r.91) | `[T]` |
| **Fibonacci: 50 · 61,8 · 78,6** | livelli di lavoro | r.53, r.91 | `[T]` sui numeri, 🔴 **incoerente sull'etichetta "golden area"** (§3) |
| **Williams %R: soglia 50** | 🆕 conferma direzionale | _"vedi che **William Per[cent] [Ce]nter Range** ti si è messo bello in direzione e **t'ha superato il 50** diretto verso l'alto: **il punto critico è superare il livello di 50**"_ (r.91) | 🟢 `[T]` sul meccanismo, `[T?]` sul nome |
| **Taglie usate** | **0,1** e **0,2** lotti | _"sono [partito] con **0,1**, neanche con **0,2**, con la size minima"_ · _"entro con **0,2**"_ | `[T]` |
| **Drawdown a 0,2: "2 pip = 2 euro"** | esempio didattico | _"questi sono **2 pip** di drawdown, nulla […] entrando con **0[,]10** sono **2 euro** di drawdown"_ (r.91) | 🟡 `[T?]` — **il lotto cambia dentro la frase** (0,2 → 0,10) |
| **Swap** | ⚠️ **zero sul Nasdaq e sul Dow** — ma **lui non sa perché** | §8.6 | 🔴 `[D]` |

### 8.6 💰 COSTI E OVERNIGHT — il passaggio che merita una riga tutta sua

**Testuale, r.91, `[T]`:**
> _"poi vedete che **non c'è swap sul Nasdaq, sul D[ow] Jones non si paga
> commissioni, non si paga swap**: uno **si può permettere in macchina anche
> 2-3 settimane**, capito?"_

E poi, alla domanda diretta dell'allievo — **e qui la risposta cambia tutto**:

> _"ho capito bene che sugli indici, su qualsiasi indice, non si parla di swap?
> — **No, su questo non so.** Perché **qui a me non mi fa pagare swap**, **sugli
> altri pago**, e **il sabato si paga 3 volte**. Ok, **o hanno sbagliato e non
> me l'hanno messo: io torno e sto zitto finché non le pago**"_

| Lettura | |
|---|---|
| 🔴 **Il numero "swap = 0"** | `[D]` **e ritrattato dal relatore stesso nella stessa risposta.** Non è una regola di mercato: è **una riga del contratto del SUO broker su UN suo simbolo**, che lui stesso **sospetta essere un errore** |
| 🚩 **Bandiera ambra sulla postura** | _"io torno e sto zitto finché non le pago"_ — approfittare di un errore sospetto del broker senza segnalarlo. **Registrato come dato sulla fonte, non come pratica** |
| 🟢 **Il dato utile per noi** | _"**il sabato si paga 3 volte**"_ — **triplo swap del mercoledì/sabato**, `[T]`. È l'unico pezzo di questo passaggio che vale come promemoria |
| 🏠 **Regola di casa che ne discende** | ⛔ **Nessun costo si assume: si legge nella specifica del simbolo BCM, simbolo per simbolo.** "Sugli indici non c'è swap" **non entra in nessun conto nostro** |

---

## 9. ⚙️ I MECCANISMI — la griglia completa

| # | Meccanismo | Citazione | Etichetta |
|---|---|---|---|
| **M1** | 🏆 **ORB: attendere la prima candela CHIUSA interamente fuori dal range** | §8.1 | `[T]` |
| **M2** | ⚠️ **…con deroga discrezionale se c'è un imbalance aperto** | _"perché non sono entrat[o] in modo meccanico? **Perché qui c'è ancora un imbalance aperto**"_ | 🚩 `[T]` — **il punto in cui la strategia smette di essere meccanica** |
| **M3** | 🏆 **ORB: stop in pari a 30-40 punti, a prescindere dai livelli tecnici** | §8.1 | `[T]` |
| **M4** | **ORB: stop sull'estremo opposto del range** | §8.1 | `[T]` |
| **M5** | **Size piccola = si tiene per giorni; size grossa = si parzializza** | _"io **tenendole tante entro con lotti piccoli** perché **cerco di fare percorsi lunghi**; questo mi consente anche **psicologicamente**, quando vado in drawdown, **di non agitarmi** perché sono **drawdown modesti**"_ | 🟢 `[T]` — **è la sua tesi centrale di money management** |
| **M6** | **Trailing su SuperTrend: lo stop segue la linea, si esce al flip** | §5 | `[T]` |
| **M7** | **Trailing a 3 candele: stop sull'estremo della terza candela indietro** | _"inseguivo il prezzo **sulla terza candela**, ogni volta che scendev[a] […] **lasciandomi un po' di respiro**"_ | `[T]` |
| **M8** | ⚠️ **…ma non stretto vicino al target** | _"è ovvio che quando sono qua **non me lo sto a mettere proprio stretto**, magari me lo tengo un pochettino più sopra"_ | 🟡 `[T]` — **discrezionale** |
| **M9** | 🏆 **Bollinger: il movimento è ESAURITO solo al rientro dentro le bande** | _"il prezzo si intende **esaurito quando dopo l'espansione rientra all'interno delle bande**; finché il prezzo [non] rientra nelle bande **è anticipare il movimento e tirare una monetina**"_ | 🟢🟢 `[T]` — **la regola più pulita e meccanizzabile della serata** |
| **M10** | **Compressione = carica; l'uscita è impulsiva** | _"quando le bande si stringono è come quando hai una **pistola** in mano […] normalmente **fa la finta da una parte e va da quell'altra**"_ | `[T]` |
| **M11** | **Distinzione: compressione ORIZZONTALE (bande parallele) vs DIREZIONALE** | _"questa è una **compressione direzionale** […] guardate come il prezzo **sale in modo costante** […] se qui ci mettete le bande di Bollinger **troverete le bande parallele**"_ | `[T]` — 🔎 **meccanizzabile** (pendenza della mediana + larghezza costante) |
| **M12** | **Le medie che SI ALLARGANO = il prezzo inizia a correre** | _"qui si incrociano proprio **e si allargano fra di loro**: vedi la **media a 9 si allarga rispetto alla media a 21** […] vuol dire che **il prezzo sta iniziando a correre**"_ | 🟢 `[T]` — 🔎 **meccanizzabile**: `|EMA9−EMA21|` crescente su N barre |
| **M13** | **Le medie che SI ATTORCIGLIANO = nessuna direzione** | _"qui si **attorcigliano**, [e] non hanno una direzione chiara"_ | `[T]` |
| **M14** | **Ritorno sulla EMA50 dopo la candela impulsiva = ingresso "professionale"** | _"questa candela è stata talmente impulsiva che **ha lasciato un vuoto** […] è tornato indietro, **ha ritestato la media a 50** e poi è partito: **questo sarebbe stato il punto di ingresso da strategia**"_ | 🟢 `[T]` — **quinta conferma del retest** |
| **M15** | **Rottura → ritest → ripartenza (il pattern base)** | _"quando ha rotto qua, ha preso, **è andato a ritestare e poi è risceso**"_ (r.49) · _"qui si è rotto il livello, **ha ritestato** e poi è risceso"_ (r.51) | `[T]` |
| **M16** | **Ingresso alla ROTTURA della EMA200, confermata** | _"io penso che entr[o] alla **rottura dell'EMA 200** […] rottura EMA 200 **confermata**, vado in D1"_ | `[T]` — ⚠️ "confermata" **non è definita** |
| **M17** | **Trend di fondo prima, TF operativo dopo (cascata ×4-5)** | §8.5 | `[T]` |
| **M18** | **Il ritracciamento si misura da dove è partito il movimento** | _"il ri[trac]ciamento lo penserei di tirarlo **da dove è partito il movimento**"_ (r.17) | `[T]` |
| **M19** | **Doji / candela di inversione: vale quando "mangia" la precedente** | _"la candela che nasce **inizia a essere buona quando mangia tutta la [candela] precedente**"_ (r.17) | `[T]` — ⚠️ "che nasce" = **doji**, chiarito dall'allievo in diretta |
| **M20** | **Più alto è il TF, più solida è la doji** | _"**più alto è il timeframe, più solida è la doji**"_ | `[T]` |
| **M21** | **S/R: gli estremi CONTRAPPOSTI pesano più dei massimi/minimi interni** | §5 | `[T]` |
| **M22** | **S/R: la forza si conta in numero di tocchi** | §8.5 (17 tocchi) | `[T]` |
| **M23** | **Livelli SuperTrend su TF alti = zone di liquidità** | _"**la liquidità si forma esattamente lì dove ci sono soprattutto i super trend in timeframe alti**"_ | `[D]` — tesi, nessuna misura |
| **M24** | **Wyckoff / sweep di liquidità: il prezzo va a prendere stop e TP** | _"questo potrebbe essere uno **swing che prelude un movimento di Wyckoff** dove va a **prendere liquidità** qua […] perché sicuramente qua ci sono **o dei take profit o dei stop**"_ (r.89) | ⛔ **già classificato «Da NON automatizzare (Paolo)»**, `REGISTRO_TEST.md` r.245. **Riconfermato** |
| **M25** | **Preferire l'ALLARME al pendente sui livelli rischiosi** | _"è meglio **mettersi un allarme** invece di mettere l'ordine pendente"_ · _"quando non ci sono [davanti] **li metto sul pop-up**"_ | `[T]` |
| **M26** | **Studio la sera / esecuzione la mattina** | _"quando uno ha poco tempo […] **la sera si fa lo studio, la mattina si alza e si vede che ci sono le condizioni e entra al mercato**"_ (r.89) | `[T]` — identico a 25/08 e 27/08 |
| **M27** | 🟢 **Le operazioni SOLO in direzione del trend** | _"**le operazioni si fanno in direzione di trend**"_ · _"cosa vado a fare con uno short qua? **Questo è un errore**"_ | `[T]` |
| **M28** | 🟢 **Anti-FOMO esplicito** | _"non devo fare la shortata perché **non ho nemmeno un incrocio nella media 9 con la media 21**: questo è **un ingresso da FOMO**, è **un ingresso sconsiderato**"_ | 🟢🟢 `[T]` |
| **M29** | 🟢 **Anti-"tanto per provare"** | Y10, §6 | 🟢 `[T]` |
| **M30** | **COT: il mercato va contro il posizionamento retail** | _"**normalmente il mercato va dalla parte opposta di dove si posizionano i trader retail**"_ (r.7) | `[D]` — nessun numero, nessun periodo |
| **M31** | **Uscita: "la vera ganzata è uscire alla fine del trend"** | _"la vera ganzata è quando uno **esce proprio alla fine del trend**"_ · le tre uscite dettate: **(a)** primo segnale contrario, **(b)** stop-in-profit inseguito a 3 candele, **(c)** flip del SuperTrend | `[T]` |

---

## 10. 🚩 BANDIERE ROSSE — col metro di casa

| # | Bandiera | Esito | Prova |
|---|---|---|---|
| **C1** | 🔴 **TENERE UN PERDENTE "perché gli indici alla fine riprendono sempre", con uscita al pareggio** | 🔴 **ROSSA — la prima rossa vera in tre live di Paolo** | §4. Citazioni testuali e piano di uscita dichiarato |
| **C2** | 🟢 **RECOVERY / GRIGLIA / MARTINGALA / MEDIAZIONE** | ⚪ **ASSENTI.** ✅ **Verificato per grep sul file intero**: `martingal`=0 · `griglia`=0 · `mediaz`=0 · `recovery`=0 · `raddoppi`=0 | — |
| **C3** | 🟢 **NO-STOP-LOSS come regola** | ⚪ **ASSENTE. Posizione opposta, esplicita, in 5 punti diversi** | _"lo stop **per regola** si mette sempre sotto lo swing"_ · _"e mettere **subito uno stop** sotto"_ · _"l'ORB si mette **lo stop sul livello opposto**"_. ⚠️ **In tensione con C1** |
| **C4** | 🟢 **TRUCCHI ANTI-PROP / elusione del rilevamento** | ⚪ **ASSENTI.** ✅ **Verificato per grep su 56 KB**: `FTMO`=**0** · `challenge`=**0** · `funded`=**0** · `payout`=**0** · `leva`=**0** (le 2 occorrenze sono "rilevanti"/"livelli"). Le **16** occorrenze di `prop` sono tutte **"proprio" / "propenso"** | — |
| **C5** | 🟡 **La regola meccanica ha una deroga discrezionale (M2: imbalance aperto)** | 🟡 **AMBRA** | È la stessa lezione già a registro (r.299): _"la sua lettura discrezionale live **non è automatizzabile 1:1**"_ |
| **C6** | 🟡 **Consiglia il SuperTrend 3.5 sul DAX M3 — che noi abbiamo misurato MORTO** | 🟡 **AMBRA** | `REGISTRO_TEST.md` r.78 e r.40 (capitolo BREAKOUT M5 **CHIUSO**). **Non si riapre da una live** |
| **C7** | 🟡 **"Non pago swap, forse hanno sbagliato, sto zitto finché non me lo fanno pagare"** | 🟡 **AMBRA** | §8.6 |
| **C8** | 🟡 **Operatività dal telefono in contesti inadatti** | 🟡 **AMBRA, ma con autocritica** | _"questa operazione **l'ho fatta durante il funerale di mio socio**, mi stavo annoiando […] mi sono messo sul telefonino"_ — **ed è esattamente la posizione ancora in perdita di C1** |
| **C9** | 🟡 **Numeri di controvalore incoerenti nella stessa frase** (100 vs 150 €; 100 vs 500 € di DD) | 🟡 **AMBRA** | §8.1 — ⛔ **quei numeri non si usano** |
| **C10** | 🟡 **"70-80% dell'S&P sono i tecnologici"** presentato come fatto | 🟡 **AMBRA** | `[D]`, nessuna fonte. **Non verificabile da questa trascrizione** |
| **C11** | 🟢 **Ammissioni di errore, quattro, tutte spontanee** | 🟢 **A SUO FAVORE** | §12 |

**Conteggio: 11 bandiere — 3 VERDI · 7 AMBRA · 1 ROSSA.**
🔴 **La rossa (C1) è la prima in tre live di questo relatore**, e va scritta
esattamente per questo: fino a ieri il materiale era pulito sui difetti classici.

---

## 11. 📢 REGOLE PROP CITATE

⚪ **NESSUNA. Zero occorrenze in 56 KB**, verificato per grep (C4).
**Niente da confrontare con `report/METRO_PROP.md` né con `report/PIANO_PROP.md`.**
La sezione della griglia resta vuota, e va detto.

🔎 **MA due cose della live TOCCANO il prop indirettamente, e vanno agganciate
al regolamento che abbiamo già agli atti** (`docs/REGOLAMENTO_FTMO_2026-08.md`):

| Cosa dice la live | Cosa dice il regolamento agli atti | Verdetto per noi |
|---|---|---|
| _"uno si può permettere in macchina anche **2-3 settimane**"_ (indici) · _"con la size bassa questa **me la porto avanti**"_ (ORB) | **§5**, r.56-58: su **FTMO Standard funded** vige la chiusura _"shortly before the markets close for the weekend **or if the rollover (market break) lasts longer than 2 hours**"_; l'**FTMO SWING** ha _"zero restrizioni"_. **Il DAX ha una pausa notturna di ~3 ore** → su Standard **non si tiene overnight** | 🔴 **Il suo ORB multiday sul DAX sarebbe VIETATO su Standard funded.** Sul suo conto personale è affar suo. **Per noi: la scelta 2-Step + Swing, già firmata, è confermata da un altro lato** |
| _"tenendole tante entro con lotti piccoli […] sono **drawdown modesti**"_ | **§MDL**, r.25: il Maximum Daily Loss è **sull'EQUITY (floating incluso)**, ricalcolato **alle 00:00 CE(S)T** sul **balance** di quell'ora | 🔴 **"Drawdown modesti perché la size è piccola" non protegge dal MDL se la posizione resta aperta a cavallo di mezzanotte in perdita.** Il floating **conta**. ➡️ **nota per il metro prop, non azione** |

---

## 12. 🧠 GLI ERRORI AMMESSI — non sono parametri, ma sono dati

Il mandato chiedeva di registrarli. **Sono quattro, tutti spontanei.**

| # | Errore | Citazione | Che dato è |
|---|---|---|---|
| **E1** | 🏆 **Stop in profit messo per distrazione, poi rimpianto** | _"che stop ho preso io oggi? Un **stop in profit** che **mi sarei mangiato le mani** […] quando sono rientrato **mi sono messo a fare un lavoro, mi sono distratto** […] **qui mi sono mangiato le mani** perché guardate: **se avessi mantenuto**, se **mi avessi dato un pochettino più spazio** e qui **non avessi [messo] questo stop in profit**, guardate **che movimento me lo sono perso**"_ (r.17, r.91) | 🟢 **La riflessione che segue vale più dell'errore**: _"la riflessione è: **ho fatto bene a mettere lo stop in profit o dovevo guardare il contesto?** **Probabilmente l'avrei preso uguale**, perché anche se non avessi messo lo stop in profit, lo stop l'avrei messo comunque **allineato col massimo della notte del giorno precedente**"_ → **non conclude che il breakeven sia sbagliato.** Conclude che **sarebbe stato colpito lo stesso** |
| **E2** | **Short contro trend perché era arrabbiato** | _"questo è **un errore mio** […] **il trend è lungo**, cosa vado a fare con uno short qua? […] **non faccio l'operazione perché ero incazzato** […] **stavo al telefono** e ho fatto questa cosa"_ — costo: **18 €** | 🟢 **tilt riconosciuto e nominato** |
| **E3** | **Ingresso "tanto per provare" con size minima** | Y10, §6 | 🟢 **regola derivata: la size che scegli ti dice se credi al setup** |
| **E4** | **Trade fatto dal telefono durante un funerale** — ed è **l'unica posizione ancora in perdita** | C8, §10 | 🚩 **il contesto operativo come fattore di rischio** |

🟢 **La frase che li lega, e che va agli atti:**
> _"come si dice le cose quando si fanno bene, **bisogna dire le cose quando si
> fanno male, se no non si migliora mai**"_ (r.91) `[T]`

---

## 13. 🖥️ LA DASHBOARD PYTHON — annotata, non azionabile

**Testuale, r.91, `[T]`:**
> _"**ho rifatto la dashboard della strategia** […] andando **sul quadratino col
> mouse** vi dice anche **il trend, come sono messi i tre trend: quello
> superiore e quello inferiore**; vi dice **prezzo, EMA, posizione sopra [o
> sotto]**, **distanza attuale dall'EMA** […] **EMA fuori range di portata
> giornaliera** […] questo vi dice **qual è la possibilità di successo H4 con
> direzione D1**, vi dà **la coerenza delle varie medie**, e qua **quanto
> movimento ha fatto durante il giorno in percentuale rispetto all'ADR**, e qui
> **qual è l'ADR giornaliero**. Premete **il tasto INFO** e vi dice ogni casella
> che informazioni vi dà"_

E la conferma tecnica, alla domanda dell'allievo:
> _"ma se il dashboard è fatto con **Python**? — Questo è il dashboard che li
> fai con Python. Sì, prima le studio, sono **calibrate**, però **il linguaggio
> è Python**"_ `[T]`

| Voce | Contenuto dichiarato |
|---|---|
| Consegna | _"ora **ve la darò penso la prossima settimana**"_ `[D]` |
| Colonne dichiarate | trend **superiore** e **inferiore** · prezzo · EMA · posizione sopra/sotto · **distanza attuale dall'EMA** · "**EMA fuori range di portata giornaliera**" · **probabilità di successo H4 con direzione D1** · **coerenza delle medie** · **% ADR consumato** · **ADR giornaliero** · tasto **INFO** |
| 🏆 Perché è la voce più interessante | ⚠️ **Non perché sia azionabile — non lo è.** Perché **due colonne su dieci sono l'ADR**, che è il **quarto passaggio in nove giorni** dello stesso metro **che noi non abbiamo mai implementato**. E perché il **precedente d'oro** è documentato: `ABTG_SuperWave` **è nato da una dashboard del corso** ed è finito validato real-tick (DOW H1 PF 1,52 · DAX H4 PF 1,28) |
| ⛔ Cosa NON so | **niente dei calcoli**: cosa sia la "probabilità di successo", su quale campione, con quale definizione di "coerenza". **Non lo invento** ➡️ **Q3** |

---

## 14. 📸 COSA C'ERA A SCHERMO E NON NEL PARLATO — le domande per Claudio

La live è **interamente su grafico condiviso**. Indica col mouse (_"eccolo qua"_,
_"questo livello"_, _"guardate qua"_, _"qua giù"_) **senza leggere i valori**:
sono **oltre 80** riferimenti deittici puri.

| # | Buco | Dove (min. approssimativo `[?]`) | Che cosa serve |
|---|---|---|---|
| **Q1** | 🏆🏆 **I DUE PRESET dell'indicatore ORB: "ORB DAX" e "ORB Wall Street"** | r.91 — _"ho **il salvataggio con la preimpostazione ORB DAX e ORB Wall Street**"_ · _"il **DAX mio**, quello dell'ORB, **è settato su BCM**, dovete settarlo"_ | 🥇 **I DUE FILE `.set`, o due screenshot del pannello con i preset CARICATI.** ⚠️ **È l'unica cosa che scioglie la contraddizione §1**: se il preset DAX dice `InpTime1 = 08:00:00 / InpTime2 = 08:14:59` (server) → la voce ha ragione e il 14:25-14:29:59 è un default di fabbrica. Se dice `07:55:00 / 07:59:59` → **l'ORB di Paolo è davvero PRE-apertura** e la voce descrive un'altra cosa. **Priorità massima, costo zero** |
| **Q1-bis** | 🔴 **Di CHI è il terminale dello screenshot?** | file dei parametri, intestazione | Il simbolo **`NASUSD_EXT` è nostro, non di BCM nativo** (§0). **Chiedere a Claudio se quello screenshot è del suo MT5 o di quello di Paolo.** Cambia il valore probatorio di tutto il §1 |
| **Q2** | 🏆 **L'"altra strategia" per gli NFP** | r.17 — _"ne faccio con **un'altra strategia che stiamo testando**, già **due volte** che va bene"_ | **Chiedere a Paolo cos'è**: evento, simbolo, orario, stop, se è un EA o manuale. È l'unico pezzo che **muove** il dossier `NEWS_BREAKOUT_OCO_NFP_2026-09-03.md` |
| **Q3** | 🏆 **La DASHBOARD Python** | r.91, §13 | **Il file quando esce** (annunciato "la prossima settimana") + **il testo del tasto INFO**, che per sua stessa ammissione **documenta cella per cella**. ⚠️ Serve soprattutto per capire **come calcola l'ADR** (High-Low o True Range? weekend esclusi? qual è il confine di giornata?) — 🔴 **domanda Q6 del 27/08, ancora aperta al terzo passaggio** |
| **Q4** | 🔴 **Il "Range Analysis": quali erano i SIMBOLI dei numeri 115 / 248 / 270 pip?** | r.69-73 | Dice _"il Japan"_, che è **una valuta, non un cross**. **Un ADR senza simbolo è un numero orfano** |
| **Q5** | 🔴 **Le due operazioni ORB reali: simbolo, orario, direzione** | r.91 | Racconta due trade con numeri (90 punti, 0,2 lotti, stop a 18 €) **senza mai dire su quale indice**. Servono **screenshot dei grafici** per capire se il suo trigger (candela chiusa fuori) sia riproducibile |
| **Q6** | 🟡 **L'indicatore di supporti/resistenze: il nome esatto** | r.91 — _"questo indicatore che è **l'ultimo che vi ho mandato**"_ | 🔴 **È la QUARTA variante del nome in tre live**: 25/08 _"RERRI"_ e _"Larry"_, 27/08 _"Rayleigh"_ e _"diciotto diciotto"_, stasera **non lo nomina affatto**. **Chiedere il nome del file** |
| **Q7** | 🟡 **Il FUSO del suo terminale** | r.91 | Stasera c'è **un indizio nuovo e forte**: _"il DAX mio, quello dell'ORB, **è settato su BCM**"_ `[T?]` sulla frase, `[T]` sulla parola "BCM". **Se conferma di lavorare su BCM, i suoi orari diventano convertibili** — ed è la prima volta in tre live. **Da chiedere esplicitamente** |
| **Q8** | 🟡 **La licenza dell'indicatore scade** | file parametri: `InpExpiryDate 2026.12.31 00:00:00` | ⚠️ **L'indicatore ORB smette di funzionare il 31/12/2026.** Se Claudio ci si appoggia per il controllo visivo delle sedie 770601/770611, **va saputo adesso, non a gennaio** |
| **Q9** | ⚪ **Il "documento della strategia" riscritto** | annunciato il 27/08 (_"la sto riscrivendo […] tagliandola"_), **stasera non ne parla** | **Resta la richiesta del 27/08.** È l'unico modo di chiudere la questione "golden area" (§3) |

---

## 15. 🧺 GLI SCARTI — quello che c'è nel file e NON è estraibile

Si dichiara, col motivo. **Circa il 30% del testo**, più della media delle live
precedenti (il finale privato pesa da solo il 20% delle righe).

| Blocco | Righe | Perché è scarto |
|---|---|---|
| 🔴 **Tutta la coda privata dopo la fine della live** | **r.93-121 (29 righe su 121)** | Paolo resta in call con un'organizzatrice: gestione della **sala d'attesa Zoom**, condivisione schermo, un appuntamento per il weekend e **uno scambio di NUMERO DI TELEFONO** (_"328 … 526"_). ⛔ **Zero contenuto di trading, e un dato personale che NON riporto e NON deve finire in nessun referto.** Segnalo solo che c'è, per la catena di custodia |
| **Gestione sala d'attesa / problemi tecnici DURANTE la live** | r.35-41, r.91 (3 volte) | _"Mi sa che ho disattivato"_, _"non si vede Paolo"_, _"ci sono altre persone in attesa"_, _"vuoi mettere come aiutante"_. Nessun contenuto |
| **Organizzazione del corso** | r.91 | _"la prossima settimana direi che ti chiamo a mercoledì la lezione di giovedì perché giovedì c'è il wake-up […] abbiamo la cena"_. Utile solo a datare la prossima live |
| **Tutti i livelli di prezzo indicati col mouse** | ovunque | _"qua"_, _"qui"_, _"questo livello"_, _"eccolo qua"_, _"qua giù"_ — **oltre 80 occorrenze. Puro deittico, zero informazione senza schermo** |
| **Digressione geopolitica sullo yen** | r.5-15 | _"pressioni geopolitiche effettive sul **G20** e sul **governatore Ueda**"_, _"intervento reale del **poi colluso**"_ `[T? rotto]`. 🔴 `[D]` — **narrativa macro senza fonte, senza data, senza numero.** Si registra, non pesa |
| **I nomi dei simboli** | ovunque | _"CHF Japan"_ = **CHFJPY** `[I]` alta confidenza · _"Audi Japan / Kadde Japan"_ = **AUDJPY / CADJPY** `[I]` · _"ODNZD / odm zd"_ = **AUDNZD** `[I]`, coerente con _"è partito a **marzo 2025**"_ · _"drone jones"_ = **Dow Jones** `[I]` · _"un'asda che è US"_ = **Nasdaq/US** `[?]`. ⚠️ **Nessuno è compitato: restano tutti `[I]`/`[?]`** |
| **Frasi strutturalmente rotte** | sparse | _"il **datocod**"_ (= dato COT? `[?]`) · _"il prezzo **attrazza** questo altro livello"_ · _"**standard impulse**"_ (= Standard & Poor's, `[I]`) · _"**patroni storia** sono quasi tutte blu"_ (= i pattern nello storico? `[?]`) · _"su oro e anche su sul proprio sul **partitosto**"_ (`[?]`, **irrecuperabile**) · _"**wiki**"_ = weekly `[I]`. **Scartate dove il contesto non le salva** |
| **I conti di controvalore** | r.91 | 🔴 **Si autocorregge in diretta e il conto resta incoerente** (§8.1). ⛔ **Irrecuperabili** |
| **"Il Japan"** come nome di strumento | r.5-15, 69-73 | Usa "il Japan" per indicare **la valuta**, **il cross del momento** e **il movimento** indifferentemente. ⛔ **Gli ADR di §8.4 restano senza simbolo** |

---

## 16. 🎯 GLI SPUNTI — etichettati SPUNTO, MAI candidati

> 🏷️ **Nessuno di questi è un candidato, nessuno entra in una coda, nessuno
> muove un parametro. Il ponte fra una lettura e un parametro vivo è un round
> misurato, mai un referto.**

| # | Spunto | Costo | Perché ha senso | Priorità |
|---|---|---|---|---|
| **S1** | 🥇🥇 **ORB: finestra del range `14:25-14:30` (attuale) vs `14:30-14:45` (quella che il docente detta a voce)** | ⚡ **ZERO: sono 4 input** (`InpRangeStartHour/Min`, `InpRangeEndHour/Min`), **nessuna ricompilazione** | **Il gradino G1 più pulito uscito da queste tre live.** Un fattore per volta, on/off numerico, su **due sedie vive con una promessa già misurata** (770601, 770611). ⚠️ **Da fare DOPO Q1**: se il preset di Paolo dice un'altra cosa ancora, la griglia cambia | 🔴 **ALTA (dopo Q1)** |
| **S2** | 🥈 **ORB: `InpUseCloseConfirm` false → true** (entra alla chiusura di una candela oltre il livello, invece che col pendente STOP) | ⚡ **ZERO: è già un `bool`** | Il docente lo dice due volte e **in una delle due lo usa per NON entrare**. Ed è già a registro (r.224) come regola ricorrente del corso. ⚠️ **Attenzione seria: è un filtro IN PIÙ.** Va misurato **il costo in numero di operazioni**, non solo il PF — e la sedia 770601 è già sotto osservazione per frequenza (v1.01) | 🔴 **ALTA** |
| **S3** | 🥉 **Bollinger: "movimento esaurito = rientro dentro le bande"** come gate anti-inseguimento | 🔧 ~15 righe | 🏆 **La regola più pulita e meccanizzabile della serata** (M9), con un **verso definito** e **zero discrezionalità**. E attacca lo stesso problema di `InpMaxExtAtr` (anti-inseguimento) con un metro diverso. ⚠️ **Due parametri liberi in più** (periodo, deviazioni) = rischio curve fitting da dichiarare | 🟡 **MEDIA** |
| **S4** | **ORB: breakeven a 30-40 punti fissi** invece che dopo la parziale | 🔧 poche righe (esiste già `InpBreakeven`, cambia il **trigger**) | Delta reale e ben documentato (due passaggi indipendenti). ⚠️ **E il docente stesso, nella stessa live, dubita che sia stato giusto** (E1) — poi conclude che sarebbe stato stoppato lo stesso. **Da misurare proprio perché la fonte è incerta** | 🟡 **MEDIA** |
| **S5** | **Golden Cross: finestra dell'incrocio ±3 candele invece di `InpCrossLookback=8`** | ⚡ **ZERO: è un input** (per la parte "dopo") | ⚠️ **Nota di realismo obbligatoria: le "tre candele PRIMA dell'incrocio" NON sono implementabili** su barra chiusa senza guardare il futuro. **Misurabile solo la metà "dopo": 3 invece di 8.** Va scritto nel round, o il round misura un'altra cosa | 🟢 **BASSA** |
| **S6** | 📌 **Nota da scrivere PRIMA di rimisurare `ABTG_PostNews`** | 📖 due righe nel round | Il verdetto 07/08 è **NULLO** (calendario cieco, changelog v1.10). Quando si rilancia: **il ramo NFP parte con una smentita esplicita della fonte** (§2). Non è un motivo per non misurarlo — **è un motivo per scrivere la previsione prima** | 🟡 **MEDIA** |
| **S7** | **Williams %R con soglia 50** come conferma direzionale | 🔧 media | 🆕 Indicatore **nuovo per questa famiglia** (esiste solo in `ABTG_AltaVelocita`). ⚠️ **Un solo passaggio, `[T?]` sul nome, nessun periodo dichiarato.** Troppo poco | 🟢 **BASSA** |
| **S8** | 🏆 **ADR: filtro di ESAURIMENTO (`ADR consumato > 2× → stop ai nuovi ingressi`)** | 🔧 ~15 righe | 🆕 **Uso NUOVO dell'ADR** rispetto al 27/08 (lì era distanza ≤ ADR, qui è **consumo giornaliero**). **Quarto passaggio dell'ADR in 9 giorni, e noi continuiamo a non averlo** (`REGISTRO_TEST.md` r.284, 299). ⚠️ **Prerequisito ancora aperto: Q3** (come si calcola?) | 🔴 **ALTA (dopo Q3)** |
| **S9** | 🌊 **Filtro trend TF superiore con moltiplicatore ×4** (M15→H4, H1→H4) | 🔧 un handle + un `if` | **Quarto passaggio consecutivo della stessa accademia**, e stasera **con la regola numerica esplicita** (×4-5) invece che qualitativa. **Resta SPUNTO, non promosso: stessa fonte che si ripete non è convergenza** | 🟡 **MEDIA (invariata)** |
| **S10** | 📉 **Medie che si ALLARGANO** (`\|EMA9−EMA21\|` crescente) come conferma di partenza | 🔧 poche righe | Misura **pulita, meccanica, con un verso** (M12). Attacca lo stesso problema di S3 da un altro lato | 🟢 **BASSA** |

### ⛔ SPUNTI RESPINTI O DECLASSATI STASERA

| Cosa | Perché |
|---|---|
| 🔴 **Fibonacci "golden area" (era S8 del 25/08)** | **RESTA ⛔ NON IMPLEMENTABILE**, ora con **tre** definizioni diverse in 9 giorni (§3) |
| 🔴 **SuperTrend 3.5 sul DAX M3** | Il capitolo **BREAKOUT M5/M3 è CHIUSO per misura** (`REGISTRO_TEST.md` r.40, r.78). Una raccomandazione a voce **non riapre un verdetto real-tick** |
| 🔴 **Wyckoff / sweep di liquidità / "il prezzo va a prendere gli stop"** | Già «**Da NON automatizzare (Paolo)**», `REGISTRO_TEST.md` r.245. **Terzo riconferma** |
| 🔴 **Qualsiasi numero di controvalore della serata** | Si autocorregge in diretta e il conto non torna (§8.1) |
| 🔴 **"Sugli indici non c'è swap"** | **Ritrattato dal relatore stesso nella stessa risposta** (§8.6). ⛔ **I costi si leggono nella specifica del simbolo, non in una live** |
| ⚠️ **Il filtro di ampiezza del range ORB** | 🔴 **NON si tocca in nessuna direzione**: la voce di stasera e il materiale del corso già a registro (r.230) **si contraddicono** (Y1). **Prima si chiede quale delle due vale (Q1), poi eventualmente si misura** |
| ⚠️ **La deroga "non entro se c'è un imbalance aperto"** | **Discrezionale per costruzione.** Meccanizzarla richiederebbe una definizione di imbalance che **la fonte non dà** |

---

## 17. 🔒 CONCLUSIONE

> ### ⛔ **NESSUNA AZIONE SULLA FLOTTA.**
>
> Non un filtro, non una soglia, non un orario, non una taglia, non un magic,
> non un EA. **Zero modifiche al forward.**
>
> Questo referto è **lettura e contesto**: **~55 valori numerici** con etichetta,
> **31 meccanismi** archiviati, **10 contraddizioni** documentate, **11 bandiere
> pesate (3 verdi, 7 ambra, 1 ROSSA)**, **10 spunti** etichettati **SPUNTO**,
> **9+1 domande** per Claudio, **4 errori ammessi** registrati.
>
> 🏆 **Il pezzo che vale di più è un CONFRONTO, non un'idea:**
> **la voce di Paolo colloca l'ORB nei 15 minuti DOPO l'apertura; il suo
> indicatore — in due versioni, V15 e V17 — misura i 5 minuti PRIMA; e le
> nostre due sedie ORB vive (770601 NASUSD, 770611 U30USD) stanno sulla
> seconda finestra, che è l'unica delle due ad avere una MISURA dietro
> (R15/R16: DD 9,92%, 119 trade, OOS 12,6 mesi).**
>
> **Costo di verificarlo: una domanda a Paolo (i due file `.set`) e una corsa
> su quattro input. Costo di non verificarlo: non sapere se due sedie vive
> misurano la cosa che il loro autore intendeva.**
>
> 🟢 **E un controllo passato che non era mai stato fatto:** su 4 parametri
> verificabili, la V17 dell'indicatore dà gli stessi numeri della V15 su cui è
> scritto il nostro EA. **La replica non è andata alla deriva.**

---

### 🔗 Referti collegati
- `caccia_strategie/ANALISI_LIVE_PAOLO_2026-08-25.md` — la lezione SuperTrend (§B2: la DAX M3 "cavallo di battaglia"; S8 golden area, oggi affossato per la terza volta)
- `risultati_archivio/ANALISI_LIVE_PAOLO_2026-08-27.md` — il seguito diretto (P16 tre stoppini, ADR lookback 50 gg, Q6 sul Range Analysis **ancora aperta**)
- `risultati_archivio/ANALISI_LIVE_EMILIANO_2026-08-27.md` / `_2026-08-28.md` / `_2026-08-31.md` — l'altra voce dello **stesso** corso (non una seconda fonte)
- `report/coach_paolo/NEWS_BREAKOUT_OCO_NFP_2026-09-03.md` — **§5.2 insidia n.1 e §5.4: entrambe toccate da questa live** (§2)
- `mql5/Experts/ABTG_ORB.mq5` v1.01 (righe 7-8, 108-124) e `ABTG_ORB_Ottimizzato.mq5` (righe 128-140) — **le due sedie sulla finestra pre-apertura**
- `mql5/Experts/ABTG_GoldenCross.mq5` righe 102-113 — **9/21/50 + HA 3 candele, identici alla voce**
- `mql5/Experts/ABTG_PostNews.mq5` v1.10 righe 176-181 — **il caso 3 dell'autotest è la slide NFP/USDJPY del corso**
- `backtest_pipeline/REGISTRO_TEST.md` righe **40, 78, 224, 230, 244, 245, 284, 299** — i punti che questa live tocca
- `docs/REGOLAMENTO_FTMO_2026-08.md` §5 (overnight/weekend) e §MDL — **l'unico aggancio prop, e indiretto**
- `report/CONTRATTI_SEDIE.md` riga 83 — **la promessa misurata della sedia ORB 770611**

---

_Referto compilato leggendo il file **integralmente, 121/121 righe** (compresi i
due blocchi monolitici di r.17 e r.91) e il file dei parametri **59/59 righe**.
Ogni valore ha la sua citazione. Ogni incrocio col repo è verificato **nel
sorgente o nel referto citato**, mai a memoria. Le verifiche di assenza
(martingala, griglia, prop, leva) sono state fatte **per grep in `python3` sul
testo intero**, non a impressione._
