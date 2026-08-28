# 🔎 RICERCA REGOLE FTMO — sito pubblico (28/08/2026)

> File richiesto come `RICERCA_REGOLE_FTMO_2026-08-27.md`. **Data reale di
> lettura delle fonti: 28/08/2026.** Uso la data reale in ogni scheda, come da
> protocollo (una regola prop letta ieri non e' una regola letta oggi).

---

## 0. ⛑️ CONTROLLO POSITIVO SULLE FONTI — leggere PRIMA di credere a una riga

| canale | esito | dettaglio |
|---|---|---|
| **WebFetch su `ftmo.com`** | ❌ **NULLO** | `EGRESS_BLOCKED`. Il proxy risponde **403 al CONNECT**: `{"kind":"connect_rejected","detail":"gateway answered 403 to CONNECT (policy denial…)","host":"ftmo.com:443"}`. **Non e' un 503 transitorio: e' un blocco di policy.** Riprovare non serve. |
| **WebFetch su `ftmo.oanda.com`** (mirror ufficiale FTMO x OANDA) | ❌ **NULLO** | `EGRESS_BLOCKED` |
| **WebFetch su `academy.ftmo.com`, `tradingfinder.com`, `r.jina.ai`** | ❌ **NULLO** | `EGRESS_BLOCKED` — anche i proxy di lettura e i siti terzi che citano FTMO |
| **curl diretto da bash** | ❌ **NULLO** | `curl: (56) CONNECT tunnel failed, response 403` |
| **WebSearch** | ✅ **VIVO** | restituisce contenuti pertinenti e cita gli URL ufficiali. Il motore **legge** le pagine e ne riporta il contenuto in parafrasi/citazione. |

### 🚨 CONSEGUENZA CHE VALE PER TUTTO IL FILE
**Nessuna pagina ftmo.com e' stata aperta direttamente da questo agente.**
Tutto cio' che segue e' **🟡 [LETTO-VIA-SEARCH]**: il motore di ricerca ha
letto la pagina ufficiale e me ne ha riportato il contenuto. E' una fonte di
**secondo grado**: piu' forte di una deduzione, piu' debole della pagina aperta.

⚠️ **Il testo fra virgolette in questo file e' come me l'ha restituito il
motore di ricerca, NON e' garantito verbatim al carattere.** Dove il motore
ha parafrasato, lo dichiaro.

🔴 **REGOLA OPERATIVA CHE NE DISCENDE: nessuna di queste righe basta da sola
a mettere soldi su una challenge.** Le voci marcate ⚠️ VERIFICA A MANO vanno
riconfermate da Claudio sulla pagina vera prima di comprare.

---

# 1. 🥇 IL PUNTO CRITICO — FTMO **STANDARD** vs **SWING**, e l'overnight

## 1.1 La risposta secca alla domanda di Claudio

> **DOMANDA:** "Intraday Trading" sullo Standard significa che e' **VIETATO**
> tenere posizioni overnight, o e' solo marketing?

> ## ✅ **RISPOSTA: NON e' un divieto durante la challenge. E' una regola che
> ## si accende SOLO sul conto FINANZIATO, e anche li' NON e' "vietato
> ## l'overnight" nel senso comune del termine.**

Due scoperte, tutte e due 🟡 [LETTO-VIA-SEARCH] dal 28/08/2026:

### 🅰️ La restrizione NON esiste durante l'Evaluation Process

Fonte: FAQ ufficiale `ftmo.com/en/faq/do-i-have-to-close-my-positions-overnight-or-before-the-weekend/`

> "While trading during the Evaluation Process, the restriction does not apply
> **regardless of the account type**. You are allowed to keep your positions
> open **overnight and over the weekend**."

Confermato in modo indipendente dalla FAQ news
(`ftmo.com/en/faq/can-i-trade-news/`):

> "for Standard accounts, these restrictions apply **only once you start
> trading on an FTMO Account** and **do not apply during the Evaluation
> Process**."

**Traduzione per noi:** Free Trial, Challenge (fase 1) e Verification (fase 2)
sono **Evaluation Process**. 👉 **Sul Free Trial la flotta puo' tenere
posizioni overnight e weekend, su Standard, senza violare niente.**

### 🅱️ Anche sul conto FINANZIATO, "overnight" ha una definizione TECNICA stretta

Fonte: stessa FAQ + `ftmo.com/en/faq/ftmo-swing-account-type/`

> "Once you become an FTMO Trader and start trading on an FTMO Account, you
> are required to close your positions shortly before the markets close for
> the weekend **or if the rollover (market break) lasts longer than 2 hours**."

E la FAQ Swing definisce l'esenzione con la stessa formula:

> "The FTMO Swing account type does not have any restrictions on trading during
> news releases or on holding positions **overnight (longer than 2 hours after
> market close)** or over the weekend."

**🎯 QUESTA E' LA SCOPERTA CHE CAMBIA LA CONFIGURAZIONE.**
"Overnight vietato" sullo Standard **non** vuol dire "non puoi tenere un trade
di notte". Vuol dire: **devi essere flat se il mercato di quello strumento
chiude per piu' di 2 ore.**

| strumento | pausa giornaliera tipica | Standard su conto FINANZIATO |
|---|---|---|
| Forex maggiori | rollover di pochi minuti | ✅ si tiene la notte — [INFERITO dalla regola delle 2 ore, ⚠️ VERIFICA A MANO] |
| Indici / CFD azionari / commodities | chiusura di molte ore | ❌ va chiuso — [INFERITO dalla regola delle 2 ore, ⚠️ VERIFICA A MANO] |
| Qualunque strumento | **weekend** | ❌ **flat prima della chiusura del venerdi'** |

🔴 **La parte [INFERITO] e' la riga piu' pericolosa del file**: la regola
"2 ore" e' [LETTO-VIA-SEARCH], ma **quali nostri simboli superino le 2 ore di
pausa non l'ha detto FTMO — lo deduco io dagli orari di mercato.** Va misurato
sul contract specification del server FTMO, simbolo per simbolo, **prima** che
un conto finanziato esista. Non prima del Free Trial: li' non serve.

## 1.2 Scheda comparativa STANDARD vs SWING

Tutto 🟡 [LETTO-VIA-SEARCH], 28/08/2026.

| voce | **STANDARD** | **SWING** |
|---|---|---|
| **Leva max** | **1:100** | **1:30** |
| **News trading** | vietato **±2 minuti** intorno a news selezionate ad alto impatto, **solo su conto finanziato** | ✅ **nessuna restrizione** |
| **Overnight (pausa >2h)** | vietato **solo su conto finanziato** | ✅ **nessuna restrizione** |
| **Weekend** | flat prima della chiusura, **solo su conto finanziato** | ✅ **nessuna restrizione** |
| **Durante Evaluation** | ✅ **nessuna delle tre restrizioni si applica** | ✅ nessuna |
| **Prezzo** | identico | **identico — il Swing NON costa di piu'** |
| **Disponibilita'** | tutte | **esclusivamente dentro FTMO Challenge: 2-Step** |

Testo esatto sulla finestra news (dalla FAQ `can-i-trade-news`, 🟡):

> "on the targeted instruments, it is not permitted to open or close any
> trades, **including the execution of pending orders**, within a time window
> starting **2 minutes before** and ending **2 minutes after** the release of
> selected news announcements."

⚠️ Nota tagliente: **"open OR CLOSE"** — la finestra vieta anche di USCIRE.
Un EA con SL/TP a mercato che chiude dentro la finestra e' una violazione, non
solo un ingresso. E vale anche per l'**esecuzione di ordini pendenti**.

Nota di prezzo (🟡): "Pricing is identical between Standard and Swing.
Despite the additional flexibility Swing accounts offer, there is no cost
premium."

### 💡 La conseguenza strategica per la nostra flotta

Se la flotta dei 35 EA e' progettata per **tenere overnight e weekend**, e se
il piano e' arrivare al conto finanziato, allora:

- sul **Free Trial e sulla challenge** → **Standard va benissimo**, e la leva
  1:100 (gia' confermata dalle nostre sonde margine su MT5) e' quella buona;
- sul **conto finanziato** → **Standard costringerebbe a chiudere il venerdi'
  e a stare flat sugli strumenti con pausa >2h**; **Swing toglie tutti e tre i
  vincoli** (news, overnight, weekend) **allo stesso prezzo**, ma **taglia la
  leva a 1:30**.

🔴 **Il costo del Swing non e' in euro, e' in MARGINE.** Con leva 1:30 invece
di 1:100 il margine richiesto si moltiplica per ~3,33. Le nostre sonde margine
su MT5 sono state fatte **a 1:100**: **su Swing NON VALGONO** e vanno rifatte
prima di qualunque decisione. Questa e' esattamente la stessa trappola gia'
dichiarata nel progetto per il DD trailing vs statico.

**VERDETTO PUNTO 1: 🟡 TROVATO VIA SEARCH, con testo riportato dal motore.
La risposta e' netta e coerente su 4 pagine ufficiali diverse.**

---

# 2. ⛔ FORBIDDEN TRADING PRACTICES

**Pagina ufficiale identificata: `https://ftmo.com/en/forbidden-trading-practices/`**
(esiste, indicizzata, ma **non apribile da qui**). 🟡 [LETTO-VIA-SEARCH], 28/08/2026.

Il documento T&C la richiama; la FAQ Swing la cita come **"Forbidden Trading
Practices as defined in the FTMO Challenge Terms & Conditions (clause 7.3)"**.
⚠️ Una fonte terza indica invece **clause 5.4**: **il numero di clausola e'
[INCERTO]**, il contenuto no.

## Elenco delle pratiche vietate raccolte

| # | pratica vietata | formulazione riportata | rilevanza per NOI |
|---|---|---|---|
| 1 | **Sfruttare errori tecnici** | "using trading strategies that exploit errors in their Services" — errori di visualizzazione prezzo, latenza del feed, **latency arbitrage**, tick manipulation | 🟢 non ci riguarda |
| 2 | **Feed dati lenti o esterni** | "using slow or external/unauthorized price feeds" | 🟢 non ci riguarda |
| 3 | **Trade simulati manipolativi / coordinamento fra conti** | "simulated trades for manipulative purposes such as **simultaneously entering into opposite positions between accounts**" | 🟠 **da guardare**: 35 EA sullo stesso conto possono generare posizioni opposte sullo stesso simbolo |
| 4 | **Violare i T&C della piattaforma** | "performing simulated trades in conflict with FTMO terms and conditions" | — |
| 5 | **Uso abusivo di strumenti automatici** | "using software or **artificial intelligence** that might manipulate or abuse the system"; bot, trading ultra-veloce, immissione massiva di dati | 🔴 **CI RIGUARDA — vedi #9** |
| 6 | **Gap trading su eventi** | "opening trades shortly before scheduled news events or extended market closures" | 🔴 **CI RIGUARDA** — una flotta che tiene il weekend apre per definizione prima di una "extended market closure" |
| 7 | **Comportamento anomalo / rischioso** | overleveraging, overexposure, **extreme one-sided bets**, account rolling | 🟠 **CI RIGUARDA** — 35 EA possono sommarsi tutti sullo stesso lato |
| 8 | **Concentrazione del rischio** | "opening a substantially smaller or larger number of positions compared to other simulated trades"; "undertaking repeated simulated trading activity that results in **higher Risk per Trade Idea**, thereby exposing the simulated account to **cumulative exposure in a specific symbol or correlated symbols**" | 🔴 **CI RIGUARDA — vedi §4** |
| 9 | **EA iperattivi** | "simulated trades operated or managed by automated robots/EAs that cause the trading account to become **hyperactive with an excessive number of more than 2,000 server requests per day** on individual simulated trades or pending orders" | 🔴 **NUMERO OPERATIVO: 2.000 richieste/giorno.** 35 EA che fanno polling ognuno possono avvicinarcisi |
| 10 | **Distribuzione artificiale del profitto** | "trading strategies that artificially distribute profit across multiple days without proportionally distributing market risk, such as **hedging or holding opposing positions on the same or highly correlated instruments**" | 🔴 **CI RIGUARDA — conto HEDGING con 35 EA** |
| 11 | **Condivisione del conto** | "letting someone else trade your account or you trading someone else's" | 🟢 |
| 12 | **Niente hedging** | ⚠️ **SOLO FTMO US** (MT5 in **netting**). **NON si applica al 2-Step europeo (hedging).** | ⚠️ trappola: molte guide mescolano FTMO US e FTMO |

⚠️ **Il punto 12 e' la trappola piu' facile di tutta la ricerca:** una delle
fonti che elencava "No Hedging" parlava di **FTMO US**, entita' diversa con
piattaforma in netting. Sul nostro 2-Step MT5 hedging quella riga **non vale**.
Se una guida ti dice "FTMO vieta l'hedging", controlla se sta parlando di US.

**VERDETTO PUNTO 2: 🟡 TROVATO VIA SEARCH — lista di 12 voci, l'URL ufficiale
e' identificato. ⚠️ NON e' garantito che sia COMPLETA: il motore mi ha dato
riassunti, non il testo integrale della pagina. Il numero di clausola e'
[INCERTO] (7.3 vs 5.4).**

---

# 3. ⏰ ORA DEL RESET GIORNALIERO — e la conversione in ora server

🟡 [LETTO-VIA-SEARCH], 28/08/2026. Fonti: FTMO Academy "Maximum Daily Loss",
`ftmo.com/en/trading-objectives/`, blog "Trading and Drawdowns".

## 3.1 Il testo

> "The MDL limit resets at **11:59:59 PM CE(S)T** when the MDL resets to the
> initial 5% limit of the initial account balance."

> "The Maximum Daily Loss Limit is recalculated daily at **00:00 CE(S)T** as
> the difference between: **the account balance recorded at 00:00 CE(S)T of
> the current day** and the Maximum Daily Loss Amount, which is **5% of the
> Initial Simulated Capital**."

> "The Max Daily Loss is monitored in **Prague time (CET)**, and the daily
> drawdown resets at **midnight CET**."

✅ **RISET = MEZZANOTTE CE(S)T (ora di Praga).** Confermato testualmente, non dedotto.

## 3.2 🚨 LA TRAPPOLA: mezzanotte CE(S)T ≠ mezzanotte del server MT5 di FTMO

🟡 [LETTO-VIA-SEARCH] dalle **Trading Update** ufficiali di FTMO:

> "Before **March 8, 2026**, times were expressed in MetaTrader platform time
> (**GMT+2 / CET+1**); starting on Sunday, **March 8, 2026**, following the DST
> change, times are displayed in MetaTrader platform time (**GMT+3 / CET+2**)."

**Il server MT5 di FTMO sta 1 ora AVANTI rispetto a CET** (e 2 ore avanti in
estate rispetto a CET base). Quindi:

| periodo | ora server MT5 FTMO | mezzanotte CE(S)T = che ora sul server? |
|---|---|---|
| estate (da 8 mar 2026) | GMT+3 (= **CET+2**, = CEST+1) | **01:00 server** [INFERITO dal testo GMT+3/CET+2] |
| inverno | GMT+2 (= **CET+1**) | **01:00 server** [INFERITO] |
| finestre di sfasamento DST (USA cambia prima dell'Europa) | — | FTMO stessa avvisa che lo scarto puo' diventare **2 ore invece di 1** |

🔴 **`InpDailyResetHour = 0` (mezzanotte broker) SUL SERVER FTMO SAREBBE
SBAGLIATO DI UN'ORA.** Il Guardian azzererebbe il contatore un'ora dopo FTMO.
Un'ora di disallineamento e' esattamente la finestra in cui il muro giornaliero
si rompe senza che il guardiano se ne accorga.

⚠️ Il calcolo 00:00 CET → 01:00 server e' **[INFERITO]** dal testo
"GMT+3 / CET+2": va **confermato guardando l'orologio dell'MT5 FTMO** appena
il Free Trial e' vivo. **Metodo a prova di errore, dichiarato da FTMO stessa:**

> "You can check your Account MetriX by hovering over **Today's Permitted
> Loss** to see a **countdown to the daily reset**."

👉 **Il countdown nel MetriX e' la verifica definitiva: dice quanti minuti
mancano al reset. Si legge quello, non si calcola.**

## 3.3 Sul nostro server BCM (dove gira la flotta OGGI)

Catena di conversione, tutta esplicita:
- regola di casa: **ora server BCM = ora italiana − 1**
- ora italiana = **CE(S)T** (stesso fuso di Praga)
- quindi **mezzanotte CE(S)T = 23:00 server BCM**

✅ **Su BCM: `InpDailyResetHour = 23`.** Coincide esattamente con il valore
gia' firmato da Claudio il 18/08 nel pacchetto Guardian ("reset 23").
**La ricerca di oggi CONFERMA quel numero invece di cambiarlo.**

## 3.4 Come si calcola la perdita giornaliera — e un punto contestato

Due letture, entrambe 🟡, che **non coincidono**:

- **Lettura A** (trading-objectives): importo = **5% del capitale INIZIALE**
  (fisso: 5.000$ su 100k), ancora = **balance registrato alle 00:00 CE(S)T**.
- **Lettura B** (Academy): "5% of the **starting equity or balance (whichever
  is higher)** at the start of the day".

🟠 **[INCERTO] su quale ancora usa FTMO: solo il balance, o il maggiore fra
balance ed equity.** Le due letture divergono **solo** quando a mezzanotte
c'e' un trade aperto in profitto flottante.

🔴 **REGOLA PRUDENZIALE:** si assume l'ancora **PIU' BASSA** (solo balance).
Un guardiano che usa l'ancora piu' bassa scatta prima del dovuto — errore
innocuo. Uno che usa quella piu' alta scatta tardi — errore che brucia il conto.

Concorde su tutto il resto (🟡): il conteggio include **posizioni chiuse +
P/L flottante delle aperte + commissioni + swap**. 👉 **E' un limite di
EQUITY, non di balance.** E FTMO ci ha scritto sopra un articolo intero:
*"Watch out for open losses: Why Equity Matters More Than Balance"*.

**VERDETTO PUNTO 3: 🟡 TROVATO VIA SEARCH con testo — reset a mezzanotte
CE(S)T confermato. ⚠️ La conversione in ora server FTMO e' [INFERITO] e va
letta dal countdown del MetriX. Ancora balance-vs-equity [INCERTO].**

---

# 4. 📐 "RISK PER TRADE IDEA" — esiste una percentuale dichiarata?

🟡 [LETTO-VIA-SEARCH], 28/08/2026.

## 4.1 Il termine E' un termine tecnico FTMO, e sta nelle Forbidden Practices

> "undertaking repeated simulated trading activity that results in **higher
> Risk per Trade Idea**, thereby exposing the simulated account to
> **cumulative exposure in a specific symbol or correlated symbols**."

## 4.2 Ma il numero e' una RACCOMANDAZIONE, non un limite

> "FTMO **recommends** risking **1–1.5% per trade**, however this is **only a
> best practice and not a restriction**. Occasional larger positions in terms
> of margin or risk can be part of a healthy trading approach, provided they
> are based on a **well-designed, functional strategy**."

Una fonte riporta anche: "FTMO recommends not risking more than **1% per trade
idea**". ⚠️ **[INCERTO]** se questo "1% per trade idea" sia una frase
letterale di FTMO o una parafrasi di terzi: le due formulazioni convivono nei
risultati e non le ho potute separare senza aprire la pagina.

## 4.3 ✅ RISPOSTA SECCA ALLA DOMANDA

> **NON esiste una percentuale di "Risk per Trade Idea" dichiarata come
> LIMITE VINCOLANTE.** Esiste una **raccomandazione dell'1–1,5%**, e una
> clausola qualitativa fra le pratiche vietate che colpisce la
> **concentrazione ripetuta** su un simbolo o su **simboli correlati**.

## 4.4 🎯 Cosa significa per NOI — ed e' la voce piu' importante del punto 4

Il nostro rischio di casa e' **0,65% per trade**: **sotto la raccomandazione
FTMO su ogni lettura** (0,65% < 1% < 1,5%). ✅ Nessun problema sul singolo trade.

🔴 **Il rischio vero non e' il singolo trade, e' la SOMMA.** La clausola non
misura il trade, misura la **"cumulative exposure in a specific symbol or
correlated symbols"**. Con **35 EA** su un conto solo:
- piu' EA sullo stesso simbolo/lato = una sola "trade idea" gonfiata;
- piu' EA su simboli **correlati** (EURUSD+GBPUSD, DAX+Dow+Nasdaq) = idem,
  e la clausola dice **esplicitamente "correlated symbols"**;
- il **cap C1 a 3,25%** gia' firmato limita il rischio aperto **totale**, ma
  **non impedisce che quel 3,25% sia tutto concentrato su un simbolo o su un
  gruppo correlato** — che e' precisamente il caso che la clausola descrive.

👉 **Questo e' il BUCO piu' concreto emerso dalla ricerca di oggi.** Vedi la
proposta P2.

**VERDETTO PUNTO 4: 🟡 TROVATO VIA SEARCH. Risposta = NESSUN LIMITE
NUMERICO VINCOLANTE, solo raccomandazione 1–1,5% + clausola qualitativa sulla
concentrazione. Il termine esatto "Risk per Trade Idea" e' confermato come
terminologia FTMO.**

---

# 5. 🧭 DOVE STANNO QUESTE INFORMAZIONI NELL'AREA CLIENTE

🟡 [LETTO-VIA-SEARCH], 28/08/2026. ⚠️ Il canale piu' debole di tutti:
l'area cliente e' dietro login, **nessuna fonte ufficiale navigabile**.

## 5.1 Percorso ricostruito

1. Login su **FTMO Client Area**
2. Aprire la **card del conto** (Evaluation / Rewards) da ispezionare
3. Cliccare **Account MetriX** — la dashboard di analisi

## 5.2 Cosa mostra Account MetriX

> "MetriX aggregates your trading activity and **overlays the Evaluation rules
> (profit targets, Maximum Daily Loss, Maximum Loss, minimum trading days)** so
> you always know where you stand."

Voci utili identificate:
- **Today's Permitted Loss** → 🎯 **passandoci sopra col mouse mostra il
  COUNTDOWN al reset giornaliero** (= la verifica definitiva del punto 3)
- tracking in tempo reale di drawdown, profit target, giorni di trading
- risultati della **Best Day Rule** (regola di consistenza), dentro il
  framework dei Trading Objectives

## 5.3 🔴 Il consiglio piu' utile: le regole NON stanno nell'area cliente

**Claudio non le trova perche' probabilmente non ci sono.** L'area cliente
mostra **lo STATO** del conto rispetto alle regole (MetriX = cruscotto).
Le **REGOLE** stanno sul sito pubblico:

| cosa cerchi | URL pubblico [identificato, non aperto] |
|---|---|
| obiettivi, muri, giorni minimi | `ftmo.com/en/trading-objectives/` |
| lista pratiche vietate | `ftmo.com/en/forbidden-trading-practices/` |
| overnight / weekend | `ftmo.com/en/faq/do-i-have-to-close-my-positions-overnight-or-before-the-weekend/` |
| news trading | `ftmo.com/en/faq/can-i-trade-news/` |
| conto Swing | `ftmo.com/en/faq/ftmo-swing-account-type/` |
| trading su weekend | `ftmo.com/en/faq/can-i-trade-on-the-weekend/` |
| quanti conti si possono avere | `ftmo.com/en/faq/how-many-accounts-can-i-have/` |
| indice FAQ | `ftmo.com/en/faq/` |
| pattern monitorati | `ftmo.com/en/blog/why-ftmo-monitors-certain-patterns-in-trading-behaviour/` |
| lezione sul muro giornaliero | `academy.ftmo.com/lesson/maximum-daily-loss/` |
| lezione sul muro totale | `academy.ftmo.com/lesson/maximum-loss/` |
| **cambi di fuso/DST del server** | `ftmo.com/en/trading-updates/` ← 🎯 **da mettere nei preferiti: e' dove FTMO annuncia i cambi di ORA SERVER** |

⚠️ Gli URL sono **comparsi nei risultati di ricerca**, quindi esistono e sono
indicizzati, ma **non li ho aperti**. Se uno da' 404, e' cambiato.

**VERDETTO PUNTO 5: 🟡 PARZIALE. Il percorso MetriX e' ricostruito da fonti
terze [NON confermato da doc ufficiale]. La scoperta utile e' negativa e vale
piu' del percorso: le regole stanno sul sito pubblico, non nell'area cliente.**

---

# 6. 📋 SCHEDA PROP — formato di casa

```
PROP            FTMO (2-Step, 100k, MT5)
URL REGOLE      ftmo.com/en/trading-objectives/ + /en/forbidden-trading-practices/ + /en/faq/
LETTA IL        28/08/2026  -- SOLO VIA WEBSEARCH, ftmo.com bloccato dal proxy (403 CONNECT)

MURO TOTALE     10% -- STATICO (dal saldo iniziale)          [dichiarato nei T&C gia' letti dal progetto]
MURO GIORNALIERO 5% dell'Initial Simulated Capital
                 calcolato su EQUITY (chiuse + flottante + commissioni + swap)
                 ancora = balance alle 00:00 CE(S)T  [oppure max(balance,equity): INCERTO -> si usa la piu' bassa]
RESET            mezzanotte CE(S)T / ora di Praga
                 = 23:00 ora server BCM
                 = ~01:00 ora server MT5 FTMO [INFERITO, da leggere dal countdown MetriX]
TARGET           fase 1: 10%   fase 2 (Verification): 5%
GIORNI MINIMI    4 per fase        LIMITE DI TEMPO: nessuno

EA AMMESSI       SI -- ma vietato l'EA "iperattivo": >2.000 richieste al server al giorno
COPY TRADING     consentito SOLO fra conti dello STESSO trader; vietati segnali di terzi,
                 conti condivisi, group trading. Tetto capitale: 400.000$ per trader/strategia
NEWS TRADING     Standard: vietato APRIRE E CHIUDERE (pendenti inclusi) da -2min a +2min
                 su news selezionate ad alto impatto -- SOLO su conto FINANZIATO
                 Evaluation: NESSUNA restrizione.   Swing: NESSUNA restrizione
OVERNIGHT        Standard: flat se la pausa di mercato supera le 2 ore -- SOLO su conto FINANZIATO
                 Evaluation: NESSUNA restrizione.   Swing: NESSUNA restrizione
WEEKEND          Standard: flat prima della chiusura del venerdi' -- SOLO su conto FINANZIATO
                 Evaluation: NESSUNA restrizione.   Swing: NESSUNA restrizione
LEVA             Standard 1:100 (confermata dalle NOSTRE sonde margine su MT5)
                 Swing 1:30 -> le sonde margine NON valgono, vanno rifatte
CONSISTENZA      esiste una "Best Day Rule", visibile nel MetriX. [INCERTO] soglia e formula:
                 NON trovata in questa ricerca
SCALING/PAYOUT   non indagato in questo giro

NOTE CHE SQUALIFICANO E NON SONO OVVIE:
 1. la finestra news vieta anche di CHIUDERE, e vale sui PENDENTI
 2. "overnight" = pausa di mercato > 2 ore, non "la notte"
 3. la clausola sulla concentrazione parla di SIMBOLI CORRELATI, non solo dello stesso simbolo
 4. tetto di 2.000 richieste server/giorno per gli EA
 5. il server MT5 di FTMO NON e' allineato al fuso in cui FTMO misura il muro giornaliero
 6. "FTMO vieta l'hedging" e' FALSO per il 2-Step europeo: vale per FTMO US (netting)
```

---

# 7. 🕳️ LA TABELLA DEI BUCHI — cosa dice FTMO vs cosa fa il nostro Guardian

Confronto con `mql5/Experts/ABTG_Guardian.mq5` (magic 779001), letto oggi.

| meccanismo richiesto da FTMO | il nostro Guardian | esito |
|---|---|---|
| muro giornaliero 5% su equity | `InpDailyLossPct = 5.0`, calcolato su equity | ✅ **COPERTO** |
| muro totale 10% statico | `InpTotalDDPct = 10.0`, `InpDDMode = 0` (statico) | ✅ **COPERTO** — e statico e' la modalita' giusta per FTMO |
| pausa morbida prima del muro | `InpDailyPausePct = 4.0` | ✅ **COPERTO, e va oltre**: FTMO non lo chiede, noi lo abbiamo |
| soglie di emergenza | 4,9 / 9,9 (firmate 18/08) | ✅ **COPERTO** |
| cap rischio aperto totale | `InpMaxOpenRiskPct = 3.25` (C1) | ✅ **COPERTO** |
| ora di reset allineata alla prop | `InpDailyResetHour` — **default 0 = mezzanotte broker** | 🟠 **INPUT C'E', DEFAULT SBAGLIATO per FTMO** → P1 |
| **no concentrazione su simbolo / simboli CORRELATI** | ❌ nessun input | 🔴 **BUCO** → P2 |
| **filtro news ±2 min (apertura E chiusura)** | ❌ assente | 🔴 **BUCO** (serve solo da conto finanziato Standard) → P3 |
| **flat prima del weekend** | ❌ assente | 🔴 **BUCO** (serve solo da conto finanziato Standard) → P4 |
| **flat se pausa mercato > 2h** | ❌ assente | 🔴 **BUCO** (serve solo da conto finanziato Standard) → P4 |
| **tetto 2.000 richieste server/giorno** | ❌ nessun contatore | 🔴 **BUCO, non misurato** → P5 |
| warning posizioni senza SL | `InpWarnNoSL = true` | ✅ **COPERTO, e va oltre** |
| modalita' monitor senza chiudere | `InpAction = 1` | ✅ **COPERTO** |

## 📊 Il conto secco

- meccanismi che FTMO impone e **noi copriamo gia': 7**
- meccanismi con l'input giusto ma il **default da cambiare: 1**
- **buchi veri: 5** — di cui **1 attivo SUBITO** (concentrazione/correlazione)
  e **3 che si accendono solo sul conto FINANZIATO Standard**, piu' 1 (le
  2.000 richieste) che **non e' nemmeno misurato**.

🎯 **Il Guardian regge la challenge. E' il conto FINANZIATO che ha i buchi
scoperti — e quello e' il conto dove i soldi sono veri.**

---

# 8. 📝 LE PROPOSTE — nessuna si applica da sola, decide Claudio

```
PROPOSTA  P1 -- allineare InpDailyResetHour alla mezzanotte CE(S)T della prop
DOVE      ABTG_Guardian, input gia' esistente (nessun codice nuovo)
FONTE     §3 -- reset a mezzanotte CE(S)T; server FTMO GMT+3/CET+2
VALORI    su BCM: 23 (= gia' firmato il 18/08, questa ricerca lo CONFERMA)
          su FTMO: ~1, DA LEGGERE dal countdown "Today's Permitted Loss" nel MetriX
COSTO     0 ore di sviluppo. 10 minuti di verifica sul MetriX
RISCHIO   se sbagliato di un'ora, il Guardian azzera il contatore in ritardo
          e il muro si rompe in una finestra cieca. E' l'errore piu' economico
          da fare e il piu' caro da subire
PRIORITA' 1 -- costo zero, rischio massimo
```

```
PROPOSTA  P2 -- cap di esposizione per SIMBOLO e per GRUPPO CORRELATO
DOVE      ABTG_Guardian, DUE input nuovi:
          InpMaxRiskPerSymbolPct  (es. 1,30% = 2 SL da 0,65%)
          InpMaxRiskPerGroupPct   (es. 1,95% = 3 SL) + una tabella di gruppi
                                   (USD-major / EUR / indici USA / indici EU / metalli)
FONTE     §4 -- "cumulative exposure in a specific symbol or CORRELATED SYMBOLS"
          (clausola delle Forbidden Trading Practices, non una raccomandazione)
COSTO     4-6 ore. Il grosso non e' il cap: e' DECIDERE la tabella dei gruppi
          e i valori. Serve 1 round di autotest (il canale InpAutotest esiste gia')
RISCHIO   1) un cap troppo stretto zittisce EA che avrebbero fatto il target
          2) va deciso COSA fa al limite: blocca i nuovi ingressi (come la pausa
             morbida) o chiude? Blocca. Chiudere per un cap = perdita certa
          3) la tabella dei gruppi e' una SCELTA NOSTRA: FTMO non pubblica
             la sua lista di correlati -> [INCERTO] per costruzione
PRIORITA' 2 -- l'unico buco che morde GIA' sul Free Trial, con 35 EA su un conto
```

```
PROPOSTA  P3 -- filtro news +/-2 minuti
DOVE      ABTG_Guardian (blocco centralizzato) oppure input nei singoli EA
FONTE     §1.2 -- vietato APRIRE E CHIUDERE, pendenti inclusi, -2/+2 min
COSTO     8-12 ore + il problema vero: DA DOVE arriva il calendario.
          MQL5 espone il calendario economico nativo (niente DLL) ma NON in
          backtest -- quindi il filtro non e' testabile nel tester come gli altri
RISCHIO   ALTO e sottovalutato: la regola vieta anche di CHIUDERE. Un filtro
          che blocca le uscite lascia posizioni aperte dentro la news = il
          contrario della protezione. Va scritto con la testa, non in fretta
QUANDO    NON serve durante l'Evaluation (nessuna restrizione).
          Serve dal primo giorno di conto FINANZIATO Standard
PRIORITA' 3 -- alta importanza, ma non urgente: rinviabile al post-challenge
```

```
PROPOSTA  P4 -- chiusura programmata: weekend + pause di mercato > 2 ore
DOVE      ABTG_Guardian, input nuovi:
          InpFlatBeforeWeekend (bool) + InpFlatWeekdayHour (ora server)
          InpFlatOnLongBreak (bool) + soglia in minuti (default 120)
FONTE     §1.1 -- "close positions shortly before the markets close for the
          weekend or if the rollover (market break) lasts longer than 2 hours"
COSTO     6-8 ore. La chiusura weekend e' facile; il rilevamento della pausa
          >2h va letto dalle sessioni del simbolo (SymbolInfoSessionTrade)
RISCHIO   1) chiusura forzata a spread largo -- il venerdi' sera lo spread si
             allarga: chiudere troppo tardi costa piu' della regola
          2) va misurato PRIMA quanto ci costa in performance chiudere il
             venerdi': su una flotta che tiene il weekend potrebbe essere tanto
          3) se costa troppo -> allora la risposta non e' P4, e' il conto SWING
QUANDO    solo conto FINANZIATO Standard
PRIORITA' 4 -- ma vedi P6: forse la risposta giusta e' non servirne affatto
```

```
PROPOSTA  P5 -- contatore delle richieste al server (misura, non protezione)
DOVE      ABTG_Guardian, sola diagnostica: conta ordini/modifiche/pendenti
          al giorno su tutti i magic e lo scrive nella pagella serale
FONTE     §2 voce 9 -- soglia dichiarata 2.000 richieste/giorno
COSTO     2-3 ore
RISCHIO   nessuno: non tocca niente, misura e basta
NOTA      NON SAPPIAMO quante ne fanno oggi i nostri 35 EA. Questo e' il punto:
          e' l'unica voce della tabella dei buchi che non e' nemmeno MISURATA.
          Prima si misura, poi semmai si protegge
PRIORITA' 5 -- costo bassissimo, e toglie un'incognita completa
```

```
PROPOSTA  P6 -- DECISIONE, non sviluppo: Standard o Swing sul conto finanziato?
DOVE      nessun codice. Una misura + una scelta di Claudio
FONTE     §1.2 -- stesso prezzo, ma Swing toglie news+overnight+weekend
          al costo di leva 1:30 invece di 1:100
COSTO     2 ore: rifare le sonde margine a 1:30 e vedere se la flotta ci sta.
          Piu' un backtest della flotta con chiusura obbligatoria del venerdi'
          (quanto costa P4 in performance?)
RISCHIO   scegliere il Swing senza rifare le sonde = scoprire a conto
          finanziato che il margine non basta. Le sonde attuali sono a 1:100
          e su Swing NON VALGONO
NOTA      Se la flotta ci sta a 1:30, il Swing rende INUTILI P3 e P4
          (14-20 ore di sviluppo risparmiate) allo stesso prezzo.
          E' la proposta con la resa piu' alta per ora spesa di tutto il file
PRIORITA' 2 a pari merito con P2 -- ma va decisa PRIMA di scrivere P3 e P4,
          altrimenti si sviluppa roba che non servira'
```

---

# 9. ❓ COSA NON HO POTUTO VEDERE — la lista onesta

1. 🔴 **Nessuna pagina ftmo.com aperta direttamente.** Proxy: 403 di policy sul
   CONNECT. Tutto e' di secondo grado. **Il testo fra virgolette non e'
   garantito verbatim.**
2. 🔴 **Il testo integrale di `forbidden-trading-practices`.** Ho 12 voci, ma
   **non so se sono tutte.**
3. 🔴 **La "Best Day Rule" / regola di consistenza**: confermata come esistente
   (compare nel MetriX) ma **soglia e formula NON trovate**. E' l'unico
   obiettivo FTMO su cui non abbiamo un numero.
4. 🔴 **Il numero di clausola** dei T&C: 7.3 o 5.4, fonti discordi.
5. 🔴 **L'ancora del muro giornaliero**: solo balance, o max(balance,equity)?
6. 🔴 **L'ora esatta del reset sul server MT5 di FTMO**: [INFERITO] ~01:00.
   Si legge dal countdown del MetriX, non si calcola.
7. 🔴 **La lista FTMO dei "correlated symbols"**: non pubblicata. La tabella
   di P2 sarebbe una nostra invenzione ragionata, non una regola loro.
8. 🔴 **Quali dei NOSTRI simboli abbiano una pausa di mercato > 2 ore**:
   [INFERITO] dagli orari di mercato, **mai misurato** sul contract
   specification FTMO.
9. 🔴 **L'area cliente**: dietro login, nessun agente puo' entrarci.
   Il percorso del §5 viene da fonti terze.

---

# 10. 🎯 LE TRE COSE DA RICORDARE

1. ✅ **Sul Free Trial e su tutta la challenge, lo Standard NON vieta niente
   di quello che facciamo.** Overnight e weekend sono liberi, le news pure.
   **"Intraday Trading" sulla pagina di acquisto e' un'etichetta di uso tipico,
   non un divieto.** Si parte con Standard e leva 1:100, come previsto.
2. ⚠️ **I vincoli si accendono TUTTI INSIEME il giorno del conto finanziato**
   (news ±2min, weekend flat, pause >2h) — e li' o si sviluppano P3+P4, o si
   sceglie il **Swing**, che li toglie tutti **allo stesso prezzo** ma a
   **leva 1:30** (sonde margine da rifare).
3. 🔴 **L'unico buco che morde GIA' oggi e' la concentrazione su simboli
   correlati** (P2): 35 EA su un conto solo, e la clausola FTMO nomina
   esplicitamente i "correlated symbols". Il cap C1 al 3,25% limita il totale,
   **non la concentrazione.**

---

*Dossier compilato il 28/08/2026. Canale WebFetch NULLO su ftmo.com
(403 di policy). Tutte le fonti sono 🟡 [LETTO-VIA-SEARCH].
Nessun numero e nessuna regola in questo file e' stato inventato: cio' che non
ho visto e' marcato [INCERTO] o [NON TROVATO] al §9.
Nessuna modifica applicata a nessun EA in forward.*
