# 🌙 ANALISI DEL PDF DI CORSO — "Strategia NIGHTLY" (ABTG, 33 pagine)

**File analizzato:** `ABTGNIGHTLY_20240505.pdf` — Alfio Bardolla Training Group,
_"Strategia NIGTLY [sic] — Massimizzare i profitti in condizioni di bassa
volatilità"_. Data stampata in copertina: **"Realise 09.04.2025"** [PAG 1]
(⚠️ **non coincide col nome del file**, che dice `20240505`: una delle due date
è sbagliata — [INCERTO], non usare né l'una né l'altra come data di riferimento).

**Letto:** tutte e 33 le pagine, due chiamate (1-16, 17-33). Nessuna pagina
saltata. Ogni estrazione qui sotto porta il **numero di pagina** e, dove serve,
la **citazione testuale**.

**Chi scrive:** analista di trascrizioni/documenti. Regola di casa applicata
integralmente: **i numeri del materiale didattico si registrano, non pesano.**
Il verdetto lo dà l'imbuto di casa, mai il documento.

---

# 🚦 IL VERDETTO IN UNA RIGA

> **Su 33 pagine: 14 parametri con valore, 7 meccanismi, 3 bandiere rosse,
> ZERO numeri di performance dichiarati.** Il documento **non contiene niente
> che la casa non abbia già scritto in codice** — `ABTG_Nightly.mq5` (439
> righe, magic 771701) È GIÀ la traduzione di questa strategia, ed è **già
> stato bocciato 9 volte**. **MA** il PDF contiene **due meccanismi che il
> nostro EA NON ha mai implementato** e che il codice stesso dichiara di aver
> lasciato fuori: il **box medio a 5 mesi** [PAG 13/16] e il **BREAKIN**
> [PAG 26/28]. Il secondo è genuinamente nuovo, è **già scritto altrove in
> casa** (`ABTG_LiquiditySweep`) e risponde esattamente all'obiezione con cui
> R89 aveva chiuso quel motore. **Verdetto (b): UN file prova, uno solo.**

---

# 1. 🕐 GLI ORARI — E LA SCOPERTA CHE VALE PIÙ DELL'OROLOGIO

## 1.1 🎯 Il PDF è girato SUL NOSTRO BROKER

Gli screenshot delle pagine 11 e 16 mostrano i nomi dei simboli della
piattaforma: **`EURUSD.bcm`** [PAG 11], **`AUDCAD.bcm`**, **`D30EUR.bcm`**,
**`SPXUSD.bcm`**, **`USDJPY.bcm`**, **`GBPUSD.bcm`**, **`NZDJPY.bcm`**,
**`EURUSD.bcm,M1 / M5 / Daily`** nella barra delle schede [PAG 16].

> 🔴 **Il suffisso `.bcm` è il nostro broker.** Quindi la riga
> _"Orario calcolo Max/Min Sessione **(Broker)** — 22:00:00-04:59:59
> (orario del broker)"_ [PAG 9] **è già in ORA SERVER BCM**: non va convertita.
>
> - **22:00–04:59 = ora server BCM** (quella che va negli `.ini` e negli input).
> - **= 23:00–05:59 ora italiana** (regola di casa: server = IT − 1).
>
> **[INFERITO]** dai nomi dei simboli negli screenshot, non da una frase del
> testo. Confidenza alta ma **da far confermare a Claudio** (è il suo corso:
> gli basta guardare che broker ha aperto in aula).

## 1.2 ⚠️ E il PDF si contraddice da solo sull'orario

| Pagina | Cosa dice | In ora server BCM |
|---|---|---|
| **PAG 9** | `22:00:00-04:59:59` **(orario del broker)** — pannello dell'indicatore | **22:00–04:59** (se broker = BCM) |
| **PAG 8** | _"parametri orari specifici, in base alla sessione asiatica (**es. 00:00–06:00 CET**)"_ | **23:00–05:00** |
| **PAG 23** | _"Durante la sessione asiatica (indicativamente tra le **00:00 e le 06:00/08:00 CET**)"_ | **23:00–05:00 / 07:00** |

**Tre finestre diverse nello stesso documento**, e il fuso è dichiarato solo
due volte su tre. La finestra **operativa** (quella dentro il pannello, PAG 9)
è **22:00–04:59 broker**; le altre due sono descrittive ("indicativamente").

📌 **Nota di casa, e non è una coincidenza:** in repo esistono **entrambe le
letture, già in codice**:
- `ABTG_Nightly` → `InpBoxStartHour=22`, `InpBoxEndHour=4/59` **server** = la
  lettura PAG 9. ✅ **corrisponde al PDF alla lettera.**
- `ABTG_MaxMinNotte` → `23:00–04:59` server (commento nel codice:
  _"BCM: 23 = 00:00 CET"_) = la lettura PAG 8/23.
- variante oro → `22:00–06:00` (`report/METRO_PROP.md` §3).

**Nessuno dei tre va corretto in base a questo PDF**: il documento non
distingue, la casa sì, e lo ha fatto misurando.

---

# 2. 📐 TUTTI I PARAMETRI CON VALORE (pagina per pagina)

| # | Parametro | Valore | Pagina | Etichetta |
|---|---|---|---|---|
| 1 | **Box notturno (calcolo max/min)** | `22:00:00–04:59:59` **ora broker (= server BCM)** | PAG 9 | [DOCUMENTO — pannello a schermo, leggibile] |
| 2 | Sessione asiatica (descrittiva) | `00:00–06:00 CET` | PAG 8 | [DOCUMENTO] — in conflitto col n.1 |
| 3 | Sessione asiatica (descrittiva 2) | `00:00–06:00/08:00 CET` | PAG 23 | [DOCUMENTO] — terzo valore |
| 4 | **"Mesi precedenti"** (profondità della media del box) | **5** | PAG 9, PAG 16 | [DOCUMENTO] — _"media dei MAX e MIN degli ultimo «n» mesi (nel caso in esame 5 mesi)"_ |
| 5 | **Cutoff ordini non eseguiti** | **07:00** | PAG 20 | [DOCUMENTO] — _"Da rimuovere entro le 07:00"_. ⚠️ **fuso NON dichiarato in questa riga** → [INCERTO]: se coerente col box è ora broker = server BCM (= 08:00 IT) |
| 6 | **Soglia QB di esclusione** | **45** | PAG 14, PAG 15, PAG 22 | [DOCUMENTO ma **SENZA UNITÀ**] — vedi bandiera rossa §5.1 |
| 7 | QB esempio 1 | `560 / 160` (_"560 punti corrispondono a 56 PIPs"_) | PAG 14 | [DOCUMENTO] — è l'unica riga che dà il fattore di conversione punti→pip (×10) |
| 8 | QB esempio 2 | `561 / 220` | PAG 15 | [DOCUMENTO] |
| 9 | QB esempio 3 | `364 / 133` | PAG 16 | [DOCUMENTO — a schermo] |
| 10 | QB esempio 4 | `347 / 135` | PAG 11 | [DOCUMENTO — a schermo] |
| 11 | QB esempio 5 | `191 / 71` | PAG 19 | [DOCUMENTO — a schermo] |
| 12 | Filtro news | **notizie a 3 stelle / forte impatto**, durante o subito dopo la sessione asiatica | PAG 22 | [DOCUMENTO] — nessuna finestra in minuti dichiarata |
| 13 | Valute escluse | **JPY, AUD, NZD** | PAG 22 | [DOCUMENTO] — _"Evita valute i cui mercati principali sono attivi durante la notte"_ |
| 14 | Cosmetici indicatore | Stile `Dash`, Font `8`, spessore livelli `2` | PAG 9, PAG 10 | [DOCUMENTO] — irrilevanti operativamente, registrati per completezza |

## 2.1 🕳️ I PARAMETRI CHE IL PDF **NON** DÀ (e sono quelli che decidono il conto)

Questo elenco vale quanto il precedente:

- ❌ **Rischio per trade: MAI dichiarato.** In 33 pagine non c'è un solo `%`.
  PAG 32 pone la domanda (_"Quanto rischio per trade?"_) e **non risponde**.
- ❌ **Nessun rapporto rischio/rendimento numerico.** PAG 5 dice
  _"rapporto rischio/rendimento favorevole"_, senza un numero.
- ❌ **Nessuna distanza d'ingresso in punti/pip.** Gli ordini vanno
  _"sui limiti esterni"_ dei box [PAG 18]: la distanza è **quella che disegna
  l'indicatore**, e l'indicatore è proprietario.
- ❌ **Nessun SL/TP numerico.** SL = _"oltre il terzo ordine, fisso per tutti"_
  [PAG 19] e _"sopra/sotto la candela precedente"_ [PAG 28/29]; TP = _"calcolato
  sul valore medio della volatilità H1 rilevata dal QB"_ [PAG 19] — **nessuna
  formula, nessun moltiplicatore.**
- ❌ **Nessuna gestione: zero parziali, zero breakeven, zero trailing.** Il
  documento dice l'opposto: _"Di notte non gestisci: decidi prima e lasci
  lavorare la strategia"_ [PAG 20]. **Set-and-forget puro.**
- ❌ **Nessun filtro giorni della settimana**, nessuna esclusione di lunedì/venerdì.
- ❌ **Nessuna soglia di ampiezza minima/massima del box.**
- ❌ **Nessuna regola prop citata.** Zero menzioni di challenge, daily loss,
  drawdown massimo, overnight. (È un corso di trading personale, non prop.)
- ❌ **ZERO numeri di performance dichiarati.** Nessun win rate, nessun PF,
  nessun "€ al mese", nessuno screenshot di conto. ✅ **Questo va a merito del
  documento**: non promette niente, quindi non c'è niente da smontare.

---

# 3. ⚙️ I MECCANISMI, COME DESCRITTI

### M1 — Box notturno "medio a 5 mesi" (il cuore operativo) [PAG 13, PAG 16]
> _"Box GRIGIO SCURO — rappresenta **la fascia media di prezzo della sessione
> asiatica calcolata su «n» mesi precedenti**. È il **cuore operativo della
> strategia**, da cui si parte per posizionare gli ordini pendenti (BUY/SELL
> LIMIT)."_ [PAG 13]
> _"Esso è una **media dei MAX e MIN degli ultimo «n» mesi** (nel caso in esame
> 5 mesi). Pertanto stante la modesta influenza dell'ultimo giorno sulla media
> [...] il box del giorno successivo sarà pressappoco identico a quello mostrato
> dall'indicatore."_ [PAG 16]

🔴 **QUESTO NON È IL BOX DELLA NOTTE SCORSA.** È una banda statistica
lentissima (5 mesi di medie), praticamente ferma da un giorno all'altro — il
documento lo dice esplicitamente come *pregio*. **È la differenza n.1 rispetto
a tutto ciò che gira in casa.**

### M2 — Box "grigio chiaro" di contingenza/estensione [PAG 13, PAG 18]
Seconda banda, più larga: _"area di estensione oltre il range medio notturno,
ideale per chi adotta un approccio più conservativo"_, serve a
_"filtrare falsi segnali"_. Ordini conservativi sui suoi bordi.

### M3 — Le due varianti d'ingresso [PAG 18]
- **Aggressiva**: LIMIT BUY/SELL **sui limiti esterni del box grigio SCURO**.
- **Conservativa**: LIMIT BUY/SELL **sui limiti esterni del box grigio CHIARO**.
- Entrambe: _"Tenere conto dei livelli del Multipivot se compatibili"_.

### M4 — QB (Quiete Box), il filtro di volatilità [PAG 14, PAG 15, PAG 22]
Due numeri: **1°** = range medio/massimo della notte in **punti**; **2°** =
media dell'estensione delle candele **H1** notturne in **punti**.
> _"Se la media oraria (secondo numero) è **> 45**, il cross va **escluso**
> dalle operazioni future."_ [PAG 14]
> _"**Regola pratica: più il QB è basso, più la strategia Nightly è efficace.**"_ [PAG 22]

### M5 — BREAKOUT [PAG 26, PAG 27, PAG 29]
> _"La candela «A» **rompe** il MAX della notte e la candela successiva **apre
> OLTRE** il livello di MAX della notte → Strategia «Trend following»"_ [PAG 26]
- Ingresso: **a mercato** sopra/sotto il livello; se la candela apre **distante**
  dal MAX/MIN → **ordine pendente LIMIT** invece del market [PAG 29].
- **SL: sotto/sopra la candela precedente** [PAG 29].
- **TP: "spazio fino al target, valutando livelli chiave"** [PAG 29] — non numerico.
- Conferma richiesta: _"Chiusura della candela oltre il livello = conferma di
  breakout"_ [PAG 27].

### M6 — BREAKIN (falsa rottura → reversal) [PAG 26, PAG 27, PAG 28] 🆕
> _"La candela «A» **viola** il MAX della notte e la candela successiva **apre
> ENTRO** il livello di MAX della notte → Strategia «reversal»"_ [PAG 26]
- **Ingresso: a mercato quando la candela apre dentro il livello violato** [PAG 28].
- **SL: sopra/sotto la candela precedente** [PAG 28].
- **TP: parte OPPOSTA del box, salvo ostacoli (livelli tecnici importanti)** [PAG 28].

### M7 — Gestione degli ordini e non-operatività [PAG 20, PAG 30]
- Pendenti non scattati: **cancellati entro le 07:00** — _"non portare nel vivo
  della sessione europea ordini pensati per la notte"_ [PAG 20].
- Eseguiti: **SL e TP automatici obbligatori** perché _"non si è presenti in
  tempo reale"_ [PAG 20].
- **Non si opera** se: SL troppo distante dall'ingresso _"il rischio non è più
  sostenibile"_; TP bloccato da ostacoli (PIVOT, EMA, Supertrend) [PAG 30].

---

# 4. 📊 NUMERI DI PERFORMANCE DICHIARATI

**NESSUNO.** In 33 pagine non compare un solo dato di rendimento, win rate,
profit factor, drawdown o equity. Le uniche affermazioni quantitative sono i
valori QB degli screenshot (§2, righe 7-11), che sono **misure di volatilità,
non risultati**.

> Se e quando emergessero numeri in altre parti del corso (video/aula), la
> regola resta: **[DICHIARATO DAL CORSO, NON MISURATO DA NOI]**, mai criterio.

---

# 5. 🚩 BANDIERE ROSSE

## 5.1 🔴 La soglia "45" **non ha unità di misura, e i suoi stessi esempi la contraddicono**

Il PDF dice tre volte _"45"_ [PAG 14, 15, 22] e **mai in quale unità**. E i
numeri che mostra a schermo sono dichiarati **in punti** [PAG 14: _"Media della
estesione delle candele H1 durante la notte **in punti**"_]. Ma allora:

| Screenshot | 2° numero (punti) | Se la soglia è **45 punti** | Se la soglia è **45 pip** (=450 punti) |
|---|---:|---|---|
| PAG 19 | 71 | ❌ escluso | ✅ operabile |
| PAG 16 | 133 | ❌ escluso | ✅ operabile |
| PAG 11 | 135 | ❌ escluso | ✅ operabile |
| PAG 14 | 160 | ❌ escluso — **eppure la pagina lo usa come esempio di "buon setup"** | ✅ operabile |
| PAG 15 | 220 | ❌ escluso | ✅ operabile |

**Letta in punti, la regola esclude TUTTI e cinque gli esempi del documento,
compreso quello presentato come buono.** Letta in pip regge, ma allora
_"45"_ significa **450 punti** e il documento non lo dice mai.

> 🔴 **Un parametro-filtro senza unità di misura, incoerente coi propri
> esempi, è un parametro magico.** Chi lo copia alla lettera o non tradà mai,
> o non filtra mai. **DOMANDA PER CLAUDIO (§8, D2).**

**E ha già lasciato un cadavere in casa** — vedi §6.3: è la spiegazione
meccanica di 6 simboli su cui `ABTG_Nightly` fa **ZERO trade in tutto
l'archivio**.

## 5.2 🟠 "Oltre il terzo ordine, fisso per tutti" — la frase che sa di griglia

> _"STOP LOSS: **oltre il terzo ordine**, fisso per tutti."_ [PAG 19]

In tutto il PDF **non esiste nessun'altra riga che definisca "tre ordini"**:
non c'è la loro spaziatura, non c'è la size, non c'è se sono sullo stesso lato
o due lati diversi. Ma la frase presuppone **almeno tre ordini pendenti con un
UNICO stop comune posto oltre l'ultimo**.

Se i tre ordini sono **scalati sullo stesso lato con SL condiviso**, allora:
- il rischio dell'idea **non è 1R ma fino a 3R** su un solo evento;
- la meccanica è **averaging contro-movimento**, cioè esattamente quella che la
  casa ha già classificato nel modulo Mediazione dello stesso corso —
  `ANALISI_CORSO_MEDIAZIONE_2026-08-18.md` §1.4:
  _"GRIGLIA DI AVERAGING CONTRO-MOVIMENTO, A CAP FISSO 6"_, con la fonte che
  ammette a voce _"propriamente appunto un sistema di Martingala"_ (lez. 31).

🟠 **Classificazione onesta: [INCERTO], non [BANDIERA CONFERMATA].** La frase è
troppo monca per condannarla, ma è **l'unica riga del PDF che moltiplichi il
rischio**, ed è appesa a un impianto mai descritto. **DOMANDA PER CLAUDIO
(§8, D3).** Finché non è chiarita: **nel file prova si assume UN ordine per
lato**, mai tre.

## 5.3 🟠 Il numero "5 mesi" senza un solo rigo di razionale

_"Mesi precedenti: 5"_ [PAG 9, PAG 16]. Perché 5 e non 3, 6 o 12? Il documento
non lo dice, non mostra una sensitività, non cita una misura. È il classico
**parametro ereditato**: si copia perché era nel template.

📌 Peggio: il PDF trasforma la staticità del parametro in un **argomento di
vendita** — _"stante la modesta influenza dell'ultimo giorno [...] il box del
giorno successivo sarà **pressappoco identico**"_ [PAG 16]. Cioè: **il livello
d'ingresso non reagisce al mercato di ieri notte.** Può essere un pregio
(stabilità) o il difetto fatale (livello scollegato dalla volatilità corrente).
**È misurabile, ed è la ragione per cui questo è l'unico altro candidato a un
file prova.**

## 5.4 ⚪ Cosa NON c'è (e va detto, perché è il metro delle bandiere)

- ❌ Nessuna **martingala esplicita**, nessun raddoppio dichiarato.
- ❌ Nessun **recovery mode**, nessuna riapertura dopo lo stop.
- ❌ Nessun **"no stop loss"**: al contrario, PAG 20 lo rende **obbligatorio**
  (_"è fondamentale che ogni operazione sia protetta da uno Stop Loss e un
  Take Profit automatici"_) e PAG 30 fa dello stop-troppo-largo una
  **condizione di non-operatività**. ✅ **Igiene del rischio corretta.**
- ❌ Nessuna **promessa di rendimento**, nessuna urgenza commerciale.
- ✅ Disclaimer legali completi [PAG 2, 3, 7, 12, 17, 21, 25, 31].

> Su 6 bandiere classiche, il documento ne inciampa in **una sicura**
> (parametro magico senza unità) e **una sospetta** (i "tre ordini").
> **È materiale didattico sano, non un imbuto di vendita.**

---

# 6. 🏠 IL CONFRONTO CON LA CASA — REGOLA PER REGOLA

## 6.1 ⚡ Il fatto che cambia tutta la lettura: **l'EA esiste già, e nasce da QUESTO documento**

`mql5/Experts/ABTG_Nightly.mq5` (439 righe, magic **771701**) — intestazione
testuale del file:

> _"EA «NIGHTLY» (fade box notturno) [...] **Basato sulla Strategia NIGHTLY
> (ABTG)**. [...] **NON automatizzato (proprietario/discrezionale): box «medio
> 5 mesi» e QB dell'indicatore ABTG-Nightly, Multipivot.** Orari in ORA SERVER
> (BCM = ora italiana - 1)."_

**Il codice dichiara da solo cosa ha lasciato fuori del PDF.** Questa analisi
non scopre una strategia nuova: **verifica se la traduzione era fedele, e cosa
è rimasto sul tavolo.**

## 6.2 📋 LA TABELLA REGOLA PER REGOLA

| # | Regola del PDF | Pag | In casa? | Dove / con che valore |
|---|---|---|---|---|
| 1 | Box notturno 22:00–04:59 ora broker | 9 | ✅ **IDENTICO** | `ABTG_Nightly`: `InpBoxStartHour=22`, `InpBoxEndHour=4`, `InpBoxEndMin=59` — **ora server**, come da nostra lettura §1.1 |
| 2 | Ordini **LIMIT** ai bordi del box (fade) | 18 | ✅ **IDENTICO** | `ABTG_Nightly.TryPlace()`: `SellLimit` sul MAX, `BuyLimit` sul MIN |
| 3 | Variante aggressiva (bordo stretto) / conservativa (bordo esteso) | 18 | ✅ **PARAMETRIZZATO** | `InpEdgeOffsetPips` (0 = bordo, >0 = più esterno/conservativo) |
| 4 | Cancellare i pendenti entro le 07:00 | 20 | ✅ **IDENTICO** | `InpCutoffHour=7`, `InpCutoffMin=0` + scadenza `ORDER_TIME_SPECIFIED` sull'ordine stesso |
| 5 | SL e TP automatici obbligatori | 20 | ✅ **IDENTICO** | SL e TP passati sempre nell'ordine; nessuna via per aprire nudi |
| 6 | Escludere JPY / AUD / NZD | 22 | ✅ **IDENTICO** | `NightActiveSymbol()`: `StringFind(s,"JPY"/"AUD"/"NZD")` + `InpBlockNightActive=true` |
| 7 | Filtro QB ≥ 45 | 14/22 | ⚠️ **IMPLEMENTATO, MA È IL PUNTO CHE ROMPE** | `InpMaxNightVolPips=45` confrontato con `ATR(H1)/PipSize()` — vedi §6.3 |
| 8 | Filtro news forte impatto | 22 | ✅ **PIÙ RICCO DEL PDF** | filtro CSV con `InpNewsMinImpact=3`, finestre before/after in minuti (il PDF non dà minuti) |
| 9 | Non operare se SL troppo distante | 30 | 🟡 **SOLO INDIRETTO** | non c'è un cancello "SL max"; c'è il sizing a rischio % che riduce il lotto. **Non è la stessa cosa** |
| 10 | TP verso il centro / su misura QB | 19 | 🟡 **DIVERSO** | `InpTPfrac=0.5` (metà range del box). Il PDF dice "valore medio della volatilità H1 (QB)" — **due formule diverse**, nessuna delle due numerica nel PDF |
| 11 | **Box = media MAX/MIN a 5 mesi** | 13/16 | ❌ **MAI IMPLEMENTATO** | `ComputeBox()` usa `iHighest/iLowest` sulle barre **M1 della notte scorsa**. Il codice lo ammette in testata |
| 12 | **Box grigio chiaro (banda di estensione)** | 13 | ❌ **MAI IMPLEMENTATO** | esiste solo come `InpEdgeOffsetPips` costante, non come banda calcolata |
| 13 | **Multipivot (Classic B + Fibonacci + Custom, 3 istanze)** | 10/18/30 | ❌ **MAI IMPLEMENTATO** | nessun pivot nel codice Nightly |
| 14 | **BREAKOUT del livello notturno** | 26/29 | ✅ **È UN ALTRO EA, ED È LA SEDIA VIVA** | `ABTG_MaxMinNotte` → BUY/SELL **STOP** oltre il box + buffer, OCO |
| 15 | **BREAKIN (falsa rottura → reversal)** | 26/28 | ❌ **MAI IMPLEMENTATO SUL BOX NOTTURNO** | il meccanismo esiste in `ABTG_LiquiditySweep` ma su **swing H4**, non sul box — §6.5 |
| 16 | Set-and-forget, niente gestione | 20 | ❌ **LA CASA FA L'OPPOSTO, E CON RAGIONE** | `MaxMinNotte_DAX_Short_Ott`: parziale 50% a 1R, **breakeven**, TP2 a 3R, target EMA200, trailing 2×ATR |
| 17 | Rischio per trade | — | ➕ **LA CASA CE L'HA, IL PDF NO** | flotta a **0,65%**; cap rischio aperto **3,25%** (firma C1 18/08) |

**Bilancio: 8 regole identiche, 3 diverse/parziali, 5 mai implementate,
1 dove è la casa ad avere in più (il rischio).**

## 6.3 🔬 IL REPERTO TECNICO: perché `ABTG_Nightly` fa ZERO trade su 6 simboli

`CENSIMENTO_REGOLA_FINESTRA.md` §4 dice, testuale:
> _"⚰️ 17 coppie fanno ZERO trade. `SupertrendInvert` su 9 simboli, **`Nightly`
> su 6**, `PostNews` su 2. **Non è un problema di finestra: quel codice non
> opera.**"_

I 6 simboli a zero: **U30USD, D30EUR, XAUUSD, AUDUSD, USDJPY** (+1).
E la tabella dei simboli che invece operano: EURUSD 164 trade, GBPUSD 163,
USDCHF 131.

**Lo schema è perfetto, e la causa è nel codice** [INFERITO, ma meccanicamente
verificabile in una riga]:
- **AUDUSD e USDJPY** → bloccati di proposito da `NightActiveSymbol()` (regola
  PDF PAG 22). ✅ **Corretto, è voluto.**
- **U30USD, D30EUR, XAUUSD** → bloccati dal **filtro QB**:
  `PipSize()` restituisce `_Point` quando i decimali non sono 3 o 5 (indici e
  oro), quindi `NightH1Vol() = ATR(H1)/_Point` esce in **punti**, non in pip.
  Su DAX/Dow/oro l'ATR H1 notturno vale decine o centinaia di punti → **sempre
  ≥ 45** → `TryPlace()` esce con _"QB alto: escluso"_ **ogni singola notte**.

> 🔴 **La soglia magica senza unità di misura del §5.1 è arrivata fino in
> produzione e ha spento tre mercati in silenzio.** Un EA che non piazza ordini
> non è "un EA senza edge": è un grafico acceso a vuoto (parole del referto
> coda fascia B su `SupertrendInvert`).
>
> **Conseguenza sul verdetto, e va detta contro il nostro stesso archivio:**
> la bocciatura "Nightly 0/8" **non ha davvero misurato 8 mercati**. Ne ha
> misurati **3 (EURUSD, GBPUSD, USDCHF, ~160 trade a testa)** e ne ha lasciati
> **5 senza un solo ordine**. Su forex il verdetto regge; su indici e oro
> **non esiste**, non è negativo.

## 6.4 ⚖️ IL FADE CONTRO LA MISURA DI CASA — con l'onestà che serve

`risultati_archivio/MaxMin_Oro/NOTTE_ORO.md`, studio su **371 notti di XAUUSD**
(28/02/2025 → 04/08/2026), che **non è un backtest ma un conteggio di fatti**:

> _"**Cosa fa la sessione dopo.** Rompe il massimo **49,9%** · rompe il minimo
> **41,2%** · **resta dentro solo 8,9%**. **Il fade («entro sul minimo, chiudo
> sul massimo») è escluso.** Direzione imprevedibile (51,5% / 48,5%): serve
> l'OCO, non una previsione."_

**Cosa questo colpisce e cosa NO — e la distinzione è tutta:**

| Meccanismo del PDF | Colpito dalla misura? |
|---|---|
| **BREAKIN, TP = parte opposta del box** [PAG 28] | 🔴 **COLPITO IN PIENO.** È letteralmente il fade misurato: entra da un lato, punta all'altro. Sull'oro riesce **8,9% delle notti** |
| **Fade a LIMIT sui bordi, TP verso il centro** [PAG 18-19] | 🟡 **NON colpito direttamente.** La misura conta le notti che "restano dentro"; un fade con TP al 50% del range può vincere **prima** che il box venga rotto. Dire il contrario sarebbe barare |
| **BREAKOUT** [PAG 29] | 🟢 **CONFERMATO dalla misura** (91,1% delle notti rompe un lato) — ed è infatti il motore della sedia viva |

⚠️ **Limite dichiarato della misura:** è **solo XAUUSD**, ed è **solo 371
notti** in un periodo in cui la volatilità dell'oro è **raddoppiata**
(2025-H1 29,8 $ → 2026-H1 59,5 $, stesso file). Il PDF **non parla di oro**:
parla di cambi con mercati dormienti. **Trasferire il 8,9% dall'oro
all'EURUSD sarebbe esattamente l'errore che questa casa non fa.**

## 6.5 🆕 IL BREAKIN — E IL CERCHIO CHE SI CHIUDE CON R89

Il PDF descrive il Breakin così [PAG 26/28]: **il prezzo viola il livello, e la
candela successiva riapre dentro → si entra in reversal, SL oltre la candela
precedente, TP alla parte opposta del box.**

La casa ha **già in codice** questo identico meccanismo — `ABTG_LiquiditySweep`,
testata del file:
> _"GRILLETTO — su chiusura di barra del TF operativo (M15): `high[1] > livello`
> **E** `close[1] < livello` → SHORT [...] cioè: il prezzo ha BUCATO il livello
> ed è RIENTRATO alla chiusura. **La conferma è il RIENTRO, non la rottura.**"_

Ma i suoi **livelli** sono swing strutturali H4 con `InpSwingBars=21`. E R89
(`REFERTO_R86_R87_R89_NOTTE.md` §2) l'ha chiuso così:

> _"**Bocciato dal canarino di frequenza** [...] l'IS fa **14 trade** nudo e
> **1-4** con la finestra. **Il round non è misurabile.** [...] ➡️ **Non è una
> bocciatura del meccanismo**: è la prova che con 21 barre H4 per lato i
> livelli sono troppo pochi. Se il motore merita un round vero, **servono
> swing più corti (o un TF di struttura più basso)** — e sarebbe un round
> nuovo, con criteri nuovi."_

> 🎯 **Il PDF fornisce esattamente il livello che R89 chiedeva.** Il MAX e il
> MIN della notte sono **due livelli nuovi ogni giorno di mercato**: ~250
> livelli/anno per lato contro i ~14 trade IS degli swing H4. **Il collo di
> bottiglia che ha ucciso R89 sparisce per costruzione.**
>
> Questa non è "un'altra griglia di parametri sullo stesso motore morto"
> (vietato dalla Regola della Seconda Caccia, 19/08). È **un meccanismo vivo
> ma non misurabile, a cui una fonte indipendente porta una sorgente di
> livelli con la frequenza giusta.** È la Seconda Caccia applicata bene.

## 6.6 📁 IL REGISTRO DEI CADUTI — cosa dice su meccanismi simili

| Voce | Fonte | Cosa dice |
|---|---|---|
| **`ABTG_Nightly` — fade box notturno** | `REFERTO_CODA_FASCIA_B.md` | _"0/8 promossi. Nemmeno una cella OHLC positiva in entrambe le finestre su 8 mercati. [...] **Capitolo chiuso, 9 bocciature totali contando EURUSD.**"_ ⚠️ **da rileggere alla luce di §6.3: 3 mercati misurati, 5 senza ordini** |
| **`ABTG_Nightly`** | `REFERTO_WEEKEND_FASE0.md` | fra i 15 lavori su 42 **senza edge nemmeno in OHLC** |
| **`ABTG_Nightly` @EURUSD** | `PIANO_MIGLIORAMENTO.md` §4 | _"RR **0,86** dichiarato in flotta: serve il **54% di vincenti** solo per pareggiare — **è un problema di geometria, non di parametri**"_ 🔴 |
| **`ABTG_Nightly`** | `PULIZIA_VPS_10-08.md` | Tier 1, **bocciato con referto**, staccato dal VPS |
| **BREAKOUT notturno (`MaxMinNotte`)** | `REGISTRO_TEST.md` §MaxMinNotte | DAX SHORT **PF 1,19 → 2,05** con correlazione S&P ON; FTSE/CAC/Stoxx **morti**. 🟢 **unica sedia viva della famiglia** |
| **Fade sul box (oro)** | `NOTTE_ORO.md` | _"Il fade è escluso"_ — 8,9% (§6.4, con i limiti dichiarati) |
| **Breakin su swing H4** | `REFERTO_R86_R87_R89_NOTTE.md` §2 | **non misurabile** (14 trade IS), **non bocciato** |
| **Box notturno e prop** | `CONFIG_PROP_2026-08-18.md` §2E · `ANALISI_PIANI_APERTURA` | 🔴 **Su E8 Signature la chiusura forzata 23:00-00:15 server AMMAZZA il box notturno** — vale per `MaxMinNotte`, `Nightly` e qualunque figlio di questo PDF |

## 6.7 🟠 IL NODO PROP, che il PDF ignora completamente

Il documento **non nomina mai** una prop. Ma la casa l'ha già scritto in
`METRO_PROP.md` §3:

> _"🚨 **Se l'overnight è vietato, tre EA della flotta sono fuori dal giorno
> uno.** Non «vanno adattati»: sono strategie il cui setup **vive di notte**."_

Con `ABTG_Nightly` esplicitamente citato su **22:00–04:59**. Qualunque cosa
nasca da questo PDF **eredita quel vincolo**: prima di spenderci un'ora,
la domanda D4 del `PIANO_PROP` va chiusa per iscritto.

---

# 7. 🏁 VERDETTO FINALE

## (a) ❌ NON è "niente di nuovo" — ma quasi

**8 regole su 17 sono già in casa identiche**, e l'EA che le implementa è
**bocciato 9 volte** su forex, con una diagnosi geometrica micidiale
(_"RR 0,86: serve il 54% di vincenti solo per pareggiare"_). **Il fade a limit
sui bordi del box della notte scorsa non si riapre.** Su questo il documento
non porta un solo argomento nuovo: non dà un rischio %, non dà un RR, non dà
una formula di TP.

## (b) ✅ CI SONO DUE DIFFERENZE MISURABILI — e se ne propone UNA SOLA

### 🥇 PROPOSTA UNICA — **file prova `BREAKIN_BOX_NOTTURNO`** (spec, non scritto)

**La tesi, in una riga:** _il livello che il PDF indica (MAX/MIN della notte) è
la sorgente di livelli ad alta frequenza che manca al motore sweep+reclaim già
scritto in casa e chiuso da R89 per campione insufficiente._

| Voce | Spec |
|---|---|
| **Motore** | `ABTG_LiquiditySweep` **con sorgente di livelli sostituita**: non swing H4 a 21 barre, ma **MAX e MIN della sessione 22:00–04:59 server** (§1.1). Nuovo input `InpLivelloDaBoxNotturno` — **modifica di codice, non ancora scritta** |
| **Grilletto** | invariato e **fedele al PDF PAG 26/28**: barra che **viola** il livello e **richiude/riapre dentro** → ingresso reversal. `high[1] > MAXnotte` **E** `close[1] < MAXnotte` → SHORT (e simmetrico) |
| **SL** | PDF PAG 28: _"sopra/sotto la candela precedente"_ → in casa `InpSLMode=0` (strutturale oltre lo sweep) + `InpSLBufferAtr=0.5` — **già esistente, nessun codice nuovo** |
| **TP** | PDF PAG 28: **parte opposta del box**. In casa si sweepa `InpTP_RR` per confronto (il TP-al-box-opposto è la variante fedele; l'RR fisso è il controllo) |
| **Finestra operativa** | il livello nasce alle 04:59; opera nella **sessione europea**, cutoff da spazzolare. ⚠️ Il PDF dice **07:00** per i pendenti [PAG 20], ma il Breakin è **a mercato**, non pendente: il cutoff è un parametro nostro, non del documento |
| **Mercati** | 🔴 **NON i JPY/AUD/NZD** (PAG 22 + coerenza con `NightActiveSymbol()`). Primo giro: EURUSD, GBPUSD, USDCHF — **gli stessi 3 dove `Nightly` ha davvero operato**, così il confronto è ad armi pari |
| **Rischio** | **0,65%** (standard di casa), non il silenzio del PDF |
| **Filtro QB** | ⛔ **SPENTO al primo giro.** È il parametro rotto del §5.1/§6.3: si accende **dopo**, come gamba opzionale, e **solo espresso in ATR relativo**, mai in "punti/pip" |
| **Canarino, da scrivere PRIMA dei numeri** | il round è **misurabile solo se n IS ≥ 150** (Emendamento della Finestra, regola A). Con ~250 livelli/anno per lato deve arrivarci; **se non ci arriva, il verdetto è "non misurabile", non "senza edge"** — stessa disciplina di R89 |
| **Criteri di promozione** | quelli congelati di casa: PF > 1 in **entrambe** le finestre, **DD ≤ 15%** (muro firmato), n OOS ≥ 30, **cella al centro dell'altopiano, MAI il picco** |

### 🥈 CANDIDATO SECONDARIO — **box medio a 5 mesi**, e perché NON parte adesso

La differenza n.11 (§6.2) è reale e misurabile: il PDF entra su una **banda
media a 5 mesi** [PAG 13/16], non sul box di ieri notte. Nessun EA di casa lo
fa. **Ma:**
1. il motore che la userebbe è il **fade**, cioè quello con **9 bocciature** e
   il difetto **geometrico** (RR 0,86) che un livello diverso non ripara;
2. cambiare il livello di un motore bocciato è **a un passo dalla "pesca"**
   vietata dalla Regola della Seconda Caccia;
3. il PDF stesso ammette che il livello è **quasi immobile** [PAG 16]: è una
   media lenta, non un livello di mercato.

➡️ **Si registra come ipotesi, non si apre un round.** Rientra **solo se** il
Breakin dà segno di vita: allora il box medio diventa una **gamba** da
confrontare col box della notte scorsa, dentro un motore che ha già mostrato
qualcosa. Mai prima.

## (c) ⚠️ DOVE IL PDF CONTRADDICE UNA NOSTRA MISURA — dichiarato con le fonti

| Il PDF dice | La casa ha misurato | Chi vince |
|---|---|---|
| _"Di notte non gestisci: decidi prima e lasci lavorare la strategia"_ [PAG 20] — set-and-forget, zero gestione | La sedia viva `MaxMinNotte_DAX_Short_Ott` è **piena di gestione** (parziale 1R, breakeven, TP2 3R, EMA200, trailing 2×ATR) e in `NOTTE_ORO.md` la gestione **ribalta una previsione**: _"il box opposto dà il PF più alto [...] il ragionamento non reggeva perché l'EA non punta a un solo target"_ | 🏠 **LA CASA**, con numeri. Il set-and-forget del PDF è una scelta di comodità (l'operatore dorme), **non una tesi di mercato** |
| _"il box del giorno successivo sarà pressappoco identico"_ = **pregio** [PAG 16] | `NOTTE_ORO.md`: la volatilità dell'oro **raddoppia in 12 mesi** (29,8 $ → 59,5 $) e _"qualunque parametro in punti fissi tarato sul 2025 oggi è fuori scala"_ | 🏠 **LA CASA.** Un livello che non reagisce alla volatilità è un rischio, non una virtù — **[INCERTO] su forex**, misurato sull'oro |
| Filtro QB con soglia **numerica assoluta "45"** [PAG 14/22] | §6.3: quella soglia, portata in codice, **ha spento 3 mercati per sempre senza che nessuno se ne accorgesse per settimane** | 🏠 **LA CASA**, e con un cadavere in mano. **Le soglie di volatilità si scrivono in ATR relativo, mai in punti assoluti.** Regola candidata |
| _"Capitalizzare i breakout **o ritest**"_ [PAG 5] su livelli notturni | `REGISTRO_TEST.md` r.228: _"NON entrare se al segnale il prezzo è **troppo lontano** dal livello [...] il retest è affidabile solo se **vicino** al livello (es. scartare se >50 punti)"_ | 🤝 **CONCORDI** — e il PDF dice la stessa cosa a PAG 29 (_"se la candela apre distante dal MAX/MIN [...] ordine pendente LIMIT"_). **Convergenza fra due fonti dello stesso corso: vale UNA fonte, non due** |

---

# 8. ❓ LE DOMANDE PER CLAUDIO (in ordine di valore)

| # | Domanda | Perché conta |
|---|---|---|
| **D1** | 🔴 **In aula, l'indicatore ABTG-Nightly girava su MT5 con broker BCM?** Gli screenshot dicono `.bcm` [PAG 11, 16] | Se sì, **`22:00–04:59` del PDF è già ora server BCM** e il nostro `ABTG_Nightly` è tarato giusto. Se no, **tutta la §1.1 salta** e gli orari vanno rifatti |
| **D2** | 🔴 **La soglia QB "45" è in PUNTI o in PIP?** In punti esclude **tutti e 5** gli esempi del PDF (§5.1) | Decide se un filtro in produzione è tarato 10× sbagliato. **Ha già spento 3 mercati** (§6.3) |
| **D3** | 🟠 **Cosa sono i "tre ordini" di PAG 19** (_"STOP LOSS: oltre il terzo ordine, fisso per tutti"_)? Tre livelli scalati sullo stesso lato con SL comune, o tre setup diversi? | Se scalati sullo stesso lato → **è averaging, il rischio è 3R non 1R**, e va classificato come il modulo Mediazione |
| **D4** | 🟠 **Screenshot al PAG 10**: i valori di `% Livelli Custom`, `Numero livelli up/down`, `Numero giorni da visualizzare` **sono a schermo ma illeggibili/non dettati** | Sono i parametri dei Multipivot, citati come **ostacolo al TP** in tre pagine [18, 20, 30]. Senza, il Multipivot **non è replicabile** |
| **D5** | 🟠 **Screenshot al PAG 19**: si vede una **media mobile magenta e una rossa** sul grafico, e PAG 30 nomina **"EMA, Supertrend"** come ostacoli. **Nessun periodo è dettato** | Se il metodo prevede un filtro di trend, **il PDF non lo dice** e noi lo stiamo ignorando |
| **D6** | 🟡 **Esiste il file dell'indicatore `ABTG-Nightly.ex5/mq5`?** PAG 16 mostra _"ABTG - Nightly - **unlicensed**"_ | Con il sorgente, il box a 5 mesi e il QB smettono di essere "proprietari" e diventano misurabili. Senza, restano fuori per sempre |
| **D7** | 🟡 **C'è un video/aula di questa strategia con i numeri?** Il PDF ha **zero** dati di performance | Non per crederci — per sapere **cosa il corso promette**, e misurarlo |
| **D8** | 🔵 Il cutoff **07:00** [PAG 20] è ora broker come il box, o ora italiana? | Un'ora di sfasamento sul cutoff cambia quali ordini sopravvivono all'apertura di Londra |

---

# 9. 📌 COSA RESTA AGLI ATTI (in tre righe)

1. **Niente si spegne e niente si accende** per effetto di questo documento.
   `MaxMinNotte_DAX_Short_Ott` (770411) resta la sedia viva; `Nightly` (771701)
   resta bocciato **su forex** — con la **rettifica** del §6.3 messa a verbale:
   su indici e oro **non è stato misurato, non è stato bocciato**.
2. **UNA proposta, con spec scritta e canarino dichiarato prima dei numeri:**
   `BREAKIN_BOX_NOTTURNO` (§7b). **Non è stato scritto nessun file prova, non è
   stato toccato nessun EA, nessuna modifica al forward.**
3. **Una regola candidata, nata da un difetto vero:** _"le soglie di volatilità
   si scrivono in ATR relativo, mai in punti o pip assoluti"_ — costo di
   ignorarla, già pagato: **3 mercati spenti in silenzio** (§6.3).

---

_Referto prodotto il 2026-08-23 dall'analista di trascrizioni. Fonte unica: il
PDF citato + i file di repo linkati. Nessuna integrazione da memoria, nessuna
navigazione. Ogni numero porta la sua pagina; ogni confronto porta il suo file._
