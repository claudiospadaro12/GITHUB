# 🔍 REGOLAMENTO FTMO — RIVERIFICA DEL **20/09/2026**

> **Documento NUOVO.** Non sostituisce `docs/REGOLAMENTO_FTMO_2026-08.md` (13/08/2026):
> gli si affianca, perché Claudio vuole poter mettere i due a confronto.
> **Contesto vero, non ipotetico**: challenge **comprata oggi 20/09/2026**, conto
> **`541452707`**, «€80k FTMO Challenge 2-Step», **80.000 EUR**, Standard, MT5, 439 EUR.
> Taglia firmata **`InpRiskPercent=2.00`** uniforme su **sei** sedie + Guardian `779001`.

---

## 🛑 ⓿ PRIMA DI TUTTO: IL CANALE DI LETTURA — **leggere questo o il resto si fraintende**

### Il controllo positivo, eseguito oggi 20/09/2026

| canale | bersaglio | esito |
|---|---|---|
| `curl` diretto | `https://ftmo.com/en/trading-objectives/` | ❌ **`CONNECT tunnel failed, response 403`** |
| `curl` diretto | `https://ftmo.com/en/forbidden-trading-practices/` | ❌ **403** |
| `curl` diretto | `https://academy.ftmo.com/` · `https://help.ftmo.com/` | ❌ **403** |
| `curl` diretto | `https://web.archive.org/…` | ❌ **403** |
| WebFetch | `https://ftmo.com/en/trading-objectives/` | ❌ `EGRESS_BLOCKED` |
| WebFetch | `https://www.simtrade.io/…` · `https://en.wikipedia.org/…` | ❌ `EGRESS_BLOCKED` |
| **WebSearch** con `allowed_domains=["ftmo.com"]` | pagina Trading Objectives | ✅ **restituisce contenuti veri** (i due muri e le percentuali che già conoscevo) |

🔴 **Il blocco NON è di FTMO ed è PEGGIO di come lo raccontava il dossier di agosto: è un
allowlist di rete che nega OGNI dominio esterno**, Wikipedia compresa. Registrato dal proxy:
`connect_rejected — gateway answered 403 to CONNECT (policy denial)`. Il README del proxy dice
testualmente *«do not retry or route around it — report the blocked host»*: **non ho tentato
scorciatoie** (un tentativo via mirror di lettura è stato fatto una volta, ha dato 403 anch'esso,
e non è stato ripetuto).

### 🔴 CHE COSA VUOL DIRE, IN UNA RIGA CHE NON AMMETTE SCONTI

> ## **Nessuna riga di questo documento è una citazione certificata parola-per-parola.**
> **Non ho potuto APRIRE nessuna pagina di ftmo.com.** Quello che segue è il **testo restituito
> dal canale di ricerca che legge le pagine ufficiali**, con il dominio ristretto a `ftmo.com`.
> È **più forte** di una parafrasi a memoria — il motore ha letto la pagina oggi — ma è **più
> debole** di una lettura a occhio, ed è **lo stesso identico limite** che ha reso non affidabile
> il dossier del 13/08.

**Le etichette usate qui sotto, e sono tre:**
- ✅ **[CONFERMATO — LETTO-VIA-SEARCH]** — il canale ha restituito oggi, dalla pagina ufficiale
  indicata, un testo che dice la stessa cosa del dossier di agosto.
- ✏️ **[PRECISATO / CAMBIATO — LETTO-VIA-SEARCH]** — il testo di oggi dice **qualcosa in più o
  di diverso** rispetto ad agosto. Riporto il vecchio e il nuovo.
- ⛔ **[NON RAGGIUNGIBILE]** — non l'ho potuto vedere e **non lo riempio**.

🔴 **Nessuna voce di questo documento può portare l'etichetta [VERIFICATO A OCCHIO].**
👉 Quella riverifica **la può fare solo Claudio**, dal suo browser, in **dieci minuti**: le sette
URL sono in fondo, §⑨, in una lista pronta da cliccare.

---

## 📊 ① COSA È CAMBIATO DAL 13/08 — **la tabella che Claudio ha chiesto in testa**

| # | punto | dossier **13/08** | riverifica **20/09** | 💥 ci costa? |
|---:|---|---|---|---|
| **1** | **Tetto richieste server EA** | *«>2.000 richieste server/giorno su ordini/pending»* | ✏️ **PRECISATO — e la precisazione è cara**: il numero **è ancora 2.000**, ma il conteggio è su trade/ordini **«opened, modified, or closed»**, e il limite di piattaforma nomina esplicitamente **«order modifications such as updates of TP/SL»** | 🔴 **SÌ** — il dossier vecchio **non conteneva la parola "modified"**: chi lo leggeva contava solo gli INGRESSI. **Trailing e breakeven contano.** |
| **2** | **Max Loss 10% statico** | «Static… equity must not drop below 90% of the initial account balance» | ✅ **CONFERMATO** | no |
| **2b** | **Max Daily Loss 5% su equity, reset 00:00 CE(S)T** | confermato | ✅ **CONFERMATO alla lettera**, e **CONFERMATO anche per il conto in EUR** | no |
| **2c** | **Il conto da 80.000 EUR** | ❌ **non esisteva nel dossier** (parlava di «100k, rischio 0,65%») | ✏️ **NUOVO**: EUR **80.000 è la taglia EUR del 100k**. Muri in valuta conto: **4.000 EUR** / **8.000 EUR** | 🟢 no — il preset Guardian è **già** a `InpStartBalance=80000` |
| **3** | **Target 10%/5% · 4 giorni · no time limit** | confermato | ✅ **CONFERMATO**, + due dettagli nuovi: i 4 giorni **non devono essere consecutivi**, e l'obiettivo esiste **solo** in Evaluation | 🟢 no, anzi: **ci aiuta** |
| **4** | **Taglie e overexposure** | *«il nostro rischio FISSO 0,65%/trade è perfetto»* | 🔴 **PRECISATO, e la conclusione di agosto era MEZZA**: compare la nozione **«Risk per Trade Idea»** e il divieto di **«cumulative exposure in a specific symbol or correlated symbols»** | 🟠 **SÌ, ed è il punto su cui ci siamo messi stasera** (3 sedie su `US30.cash` + 1 su `US100.cash`) |
| **5** | **News/overnight non valgono in Evaluation** | confermato | ✅ **CONFERMATO**, con il rinforzo **«regardless of the account type»** | 🟢 no — **è la nostra licenza per le due sedie 0-24** |
| **6** | **Standard funded: flat nel weekend / rollover >2h** | confermato | ✅ **CONFERMATO** (vale **solo** sul funded Standard) | 🟡 non ora — **dopo** |
| **7** | **Commissioni indici** | «indici ZERO commissioni» | ✅ **CONFERMATO** — *«All index symbols… zero commission»* | 🟢 no — chiude il `[NON MISURATO]` del collaudatore |
| **8** | **Leva sugli indici** | «Standard **1:100**» | ✏️ **CAMBIATO/CORRETTO**: il testo di oggi dice indici **1:50 Normal**, 1:15 Swing | 🟢 **nessuna conseguenza** — stasera il margine è stato **misurato**, non dedotto |
| **9** | **Gap trading** | «(ii) **two hours or less before** a relevant market is closed for at least two hours» | ⚠️ **FORMULAZIONE DIVERSA nel testo di oggi**: *«when a relevant financial market is closed **or will be closed** for at least two hours»* | 🟠 **forse** — vedi §④.3, riguarda il **venerdì sera** delle sedie 0-24 |

---

## 🔴 ② PUNTO 1 — **IL TETTO DELLE RICHIESTE SERVER.** Il più importante, e quello che è cambiato

### ✏️ [PRECISATO — LETTO-VIA-SEARCH · 20/09/2026]

**Il numero è ancora 2.000.** Ma la **definizione** che il dossier di agosto aveva abbreviato è
quella che decide, e contiene una parola che ad agosto non c'era.

**Testo restituito oggi da `https://ftmo.com/en/forbidden-trading-practices/`:**

> «trades operated by automated robots / Expert Advisors (EAs) which cause the trading account to
> become **hyperactive** in the sense of an excessive number of **more than 2,000 server requests
> per day** on individual simulated trades or pending orders being **opened, modified, or closed**,
> causing overload of the trading server»

**E il limite tecnico di piattaforma, restituito da
`https://ftmo.com/en/faq/which-instruments-can-i-trade-and-what-strategies-am-i-allowed-to-use/`
(e/o `https://ftmo.com/en/faq/how-does-the-ftmo-technical-infrastructure-work/`):**

> «Platform servers have **200 orders at a time** and **2000 max positions per day** limitation,
> just as the limited acceptance of the server messages (**orders and order modifications such as
> updates of TP/SL and updates of limit orders**).»

**E la conseguenza dichiarata, che NON è la squalifica automatica:**

> «If an EA causes hyperactivity to a platform server, FTMO might **alert traders and ask them to
> adjust the EA logic or parameters** of their strategy.»

### 🎯 LE TRE RISPOSTE ALLE TRE DOMANDE DI CLAUDIO

| domanda | risposta | etichetta |
|---|---|---|
| **2.000 è ancora il numero?** | ✅ **SÌ.** Invariato dal 13/08 | [CONFERMATO — LETTO-VIA-SEARCH] |
| **Conta solo gli ORDINI, o anche le modifiche di stop (`PositionModify`)?** | 🔴 **CONTA ANCHE LE MODIFICHE.** Due testi indipendenti lo dicono: *«opened, **modified**, or closed»* e *«order **modifications such as updates of TP/SL**»* | [PRECISATO — LETTO-VIA-SEARCH] |
| **È un muro o un avviso?** | 🟠 **Formalmente sta fra le Forbidden Practices** (quindi sanzionabile), **ma il testo descrive un avviso prima**: *«might alert traders and ask them to adjust»*. **Non è un cancello automatico come il 5%** | [PRECISATO — LETTO-VIA-SEARCH] |

### 🔴 PERCHÉ È IL PUNTO PIÙ CARO, DETTO COME VA DETTO

> Il dossier del 13/08 riassumeva la voce in **undici parole**: *«vietati EA che rendono l'account
> hyperactive con >2.000 richieste server/giorno su ordini/pending»*. **Chi legge quella riga conta
> gli INGRESSI.** Il testo vero conta **ingressi + modifiche + chiusure**, e nomina per esteso
> **gli aggiornamenti di SL/TP**.
>
> 🎯 **È esattamente la differenza fra un portafoglio che sta larghissimo dentro il tetto e uno che
> non lo sa.** Sei EA con trailing attivo che ritoccano lo stop su ogni barra — o peggio su ogni
> tick — producono richieste di **modifica**, non di ordine.

**🚧 CONFINE DEL MIO MANDATO**: il conteggio **sul nostro codice** lo sta facendo un altro agente.
Io consegno **il numero (2.000/giorno) e la definizione (aperture + modifiche + chiusure, SL/TP
inclusi)**. 👉 **Quella è la specifica contro cui va misurato.** Se il conteggio dell'altro agente
è stato fatto contando le sole aperture, **va rifatto**.

---

## 🧱 ③ PUNTI 2 e 3 — I MURI E GLI OBIETTIVI. **Tutti confermati, e valgono in EURO**

### ✅ [CONFERMATO — LETTO-VIA-SEARCH · 20/09/2026]

**Max Loss 10% — STATICO sul 2-Step.** Da `https://ftmo.com/en/trading-objectives/` e
`https://academy.ftmo.com/lesson/maximum-loss/`:

> «The Maximum Loss limit requires that **equity** on a trading account **must not drop below 90%
> of the initial account balance at any given time** during the account duration.»

**Max Daily Loss 5% — su EQUITY, reset 00:00 CE(S)T.** Da
`https://academy.ftmo.com/lesson/maximum-daily-loss/`:

> «The Maximum Daily Loss Limit is **recalculated daily at 00:00 CE(S)T** as the difference between
> the account balance recorded at 00:00 CE(S)T of the current day and the Maximum Daily Loss
> Amount, which is **5% of the Initial Simulated Capital**.»
> «On the first day, the account balance used for the calculation is the Initial Simulated Capital.»
> «The rule is based on **equity**, not only on closed results, and includes both the results of
> closed positions and the **floating P/L of open positions**, as well as **commissions and swaps**.»

**Profit Target e giorni minimi.** Da `https://ftmo.com/en/trading-objectives/` e
`https://academy.ftmo.com/lesson/minimum-trading-days/`:

> «you must make **10% of the initial balance** in the FTMO Challenge and **5% in the Verification**»
> «A Trading Day is defined as any day – measured from **00:00:00 to 23:59:59 CE(S)T** – during
> which **at least one position is opened**.»
> «You **do not have to trade for 4 days consecutively**, you just simply have to complete at least
> 4 Trading Days in total by the end of the trading period. The Minimum 4 trading days Trading
> Objective is present **only during the Evaluation Process** – FTMO Challenge and Verification.»
> «There is **no maximum time limit** to complete the FTMO Challenge: 2-Step.»

### 💶 E IL PEZZO CHE NEL DOSSIER DI AGOSTO **NON C'ERA**: il conto è in EURO

✏️ **[NUOVO — LETTO-VIA-SEARCH · 20/09/2026]** — da
`https://ftmo.com/en/faq/what-are-the-account-specifications/`:

> «initial capital of **EUR 80,000**, which is **equivalent to USD 100,000**, GBP 70,000,
> CHF 80,000, CAD 120,000, or AUD 130,000»

🟢 **Quindi le percentuali si applicano a 80.000 EUR**, che è l'*Initial Simulated Capital*:

| muro | % | **in EURO, sul nostro conto `541452707`** |
|---|---:|---:|
| Max Daily Loss | 5% | **4.000 EUR** |
| Max Loss (statico) | 10% | **8.000 EUR** → pavimento equity **72.000 EUR** |
| Profit Target Challenge | 10% | **+8.000 EUR** |
| Profit Target Verification | 5% | **+4.000 EUR** |

### 🛡️ IL GUARDIAN È TARATO GIUSTO — verificato nel file, non a memoria

Letto oggi in `mql5/Presets/ABTG_Guardian_FTMO_2Step.set`:

| input | valore | in EURO | distacco dal muro FTMO |
|---|---:|---:|---|
| `InpStartBalance` | **80000** | — | 🟢 **ancora giusta** |
| `InpDailyLossPct` | **4.5** | 3.600 EUR | 🟢 **400 EUR di cuscino** sotto i 4.000 |
| `InpTotalDDPct` | **9.3** | 7.440 EUR | 🟢 **560 EUR di cuscino** sotto gli 8.000 |
| `InpDailyPausePct` | **3.5** | 2.800 EUR | pausa morbida prima dell'emergenza |
| `InpDailyResetHour` | **1** | — | 🟢 **ora 1 sul server FTMO = 00:00 CE(S)T** |
| `InpMaxOpenRiskPct` | **4.00** | 3.200 EUR | cap C1: **max 2 posizioni** da 2,00% |

🟢 **E il reset è quello giusto per una ragione MISURATA, non inferita**: il prevolo delle 17:08
di oggi ha misurato `DeltaServerGMT = +03:00` sul terminale FTMO. Mezzanotte CE(S)T (= GMT+2 in
ora legale) cade all'**ora 1** del server FTMO. ✅ **`InpDailyResetHour=1` coincide.**

⚠️ **L'unico residuo [INCERTO]**: FTMO scrive **CE(S)T**, cioè segue l'ora legale europea. Il
server MT5 FTMO è a **GMT+3** d'estate e **GMT+2** d'inverno. **Al cambio d'ora (25/10/2026,
ultima domenica di ottobre) i due si muovono insieme, quindi `InpDailyResetHour=1` resta giusto** —
ma va **riletto**, non dato per scontato, perché la challenge arriva a cavallo di quella data.
🔴 **Questo è un promemoria per fine ottobre, non un difetto di stasera.**

---

## ⚖️ ④ PUNTO 4 — FORBIDDEN PRACTICES. **Qui la conclusione di agosto era MEZZA GIUSTA**

### ✏️ [PRECISATO — LETTO-VIA-SEARCH · 20/09/2026] — da `https://ftmo.com/en/forbidden-trading-practices/`

**Il testo restituito oggi:**

> «When performing simulated trades, you must not engage in practices which are **not reasonably
> replicable in the actual market**, meaning that such a strategy is not in line with risk
> management rules a reasonable person would apply when trading on financial markets with their
> own money.
> Market standard risk management rules include avoiding **opening substantially larger position
> sizes compared to your other simulated trades**, opening a **substantially smaller or larger
> number of positions** compared to your other simulated trades, or **undertaking repeated
> simulated trading activity that results in higher Risk per Trade Idea**, thereby **exposing your
> simulated account to cumulative exposure in a specific symbol or correlated symbols**.»

E dalla pagina «Why FTMO Monitors Certain Patterns in Trading Behaviour»
(`https://ftmo.com/en/blog/why-ftmo-monitors-certain-patterns-in-trading-behaviour/`):

> «Traders are **first warned** about inappropriate behaviour; if they **continue despite the
> warning**, their account may be terminated, and the reward may not be paid. In **severe cases**,
> the account may be terminated immediately.»

### 🔴 LA COSA DA DIRE CHIARA: IL DOSSIER DI AGOSTO CHIUDEVA COSÌ

> *«→ il nostro rischio FISSO 0,65%/trade è perfetto.»*

**È vero per METÀ della regola, e la metà che restava fuori è quella che riguarda stasera.**

| la regola ha **tre** gambe | noi | verdetto |
|---|---|---|
| **(a)** «substantially larger or **smaller** position sizes compared to your other trades» | **taglia FISSA 2,00% su tutte e sei**, mai raddoppi, mai martingala | 🟢 **PERFETTI.** Questa gamba la passiamo meglio del 99% dei clienti |
| **(b)** «substantially smaller or larger **number of positions** compared to your other trades» | flusso regolare, guidato da sei motori con regole fisse | 🟢 **bene** (il cap C1 tiene il numero *sotto* controllo, non lo fa oscillare) |
| **(c)** 🔴 «repeated activity that results in higher **Risk per Trade Idea**, thereby exposing your account to **cumulative exposure in a specific symbol or correlated symbols**» | 🟠 **QUI CI SIAMO MESSI STASERA** | vedi sotto |

### 🎯 «SEI EA, TRE SULLO STESSO SIMBOLO, SONO OVEREXPOSURE?» — la risposta onesta

**La rosa di stasera, letta dai preset installati:**

| magic | simbolo | rischio | cluster |
|---|---|---:|---|
| `770101` DAX Apertura | `GER40.cash` | 2,00% | 🇪🇺 indici EU |
| `770411` MaxMin DAX Short | `GER40.cash` | 2,00% | 🇪🇺 indici EU |
| `770202` Dow Apertura | `US30.cash` | 2,00% | 🇺🇸 **indici USA** |
| `771531` EMA200 | `US30.cash` | 2,00% | 🇺🇸 **indici USA** |
| `770511` SuperWave | `US30.cash` | 2,00% | 🇺🇸 **indici USA** |
| `770260` Nasdaq RETEST | `US100.cash` | 2,00% | 🇺🇸 **indici USA** (correlato a US30) |

👉 **Quattro sedie su sei stanno su indici azionari USA, e tre sullo STESSO simbolo.** Questa è,
alla lettera, la fattispecie che la regola nomina: *«cumulative exposure in a specific symbol or
correlated symbols»*.

**MA — e questa è la buona notizia, ed è misurata, non sperata:**

> ## 🟢 **IL CAP C1 DEL GUARDIAN A 4,00% È PRECISAMENTE LA DIFESA CONTRO QUESTA REGOLA.**
> Con `InpMaxOpenRiskPct=4.00` e taglia 2,00%, **non possono esistere più di DUE posizioni aperte
> insieme su tutto il conto**. Tre sedie su `US30.cash` **non fanno 6% di esposizione**: ne fanno
> **al massimo 4%**, e solo se due scattano insieme. **Il numero che FTMO guarderebbe è 4%, non 6%.**

**E la seconda buona notizia**: la sanzione descritta è **gradata** — *«first warned… if they
continue despite the warning»*. Non è il muro del 5% che squalifica al centesimo.

### ⚠️ MA TRE COSE VANNO DETTE LO STESSO, perché sono vere

1. 🟠 **Il cap C1 vale solo se ogni EA lo legge.** Verificato oggi nei preset: `InpUsaGuardian=true`
   è **esplicito in cinque** dei sei (`770101` `770411` `770202` `771531` `770260`).
   🟢 **`770511` NON ha la riga** — ma il suo sorgente
   (`mql5/Experts/ABTG_SuperWave_DOW_H1_Ottimizzato.mq5` r.45) dichiara
   `input bool InpUsaGuardian = true`, quindi **il default copre il buco**.
   👉 **Non è un difetto operativo. È una riga mancante che sarebbe meglio scrivere**, perché oggi
   la protezione dipende da un default invece che da una dichiarazione. *(Costo: una riga.)*
2. 🔴 **Il Guardian è fail-open**: se non gira, il cap non esiste e le sei sedie possono aprire
   tutte. Limite **già dichiarato** nel preset stesso, non scoperto da me.
3. 🟠 **La concentrazione resta visibile a FTMO anche se il RISCHIO è capato**: quattro sedie su
   indici USA significa che il **P/L del conto** avrà una firma fortemente correlata. Il cap C1
   limita il **rischio simultaneo**, non la **correlazione nel tempo**.

### 🔴 3. E LA COSA CHE HO TROVATO GUARDANDO I PRESET: **il venerdì sera delle sedie 0-24**

⚠️ **[PRECISATO — LETTO-VIA-SEARCH · 20/09/2026]** La formulazione del **gap trading** restituita
oggi **non coincide** con quella trascritta ad agosto:

| | testo |
|---|---|
| **13/08** | «(ii) **two hours or less before** a relevant financial market is closed for at least two hours» |
| **20/09** | «Gap trading… involves opening simulated trades when major global news, macroeconomic events, or corporate reports or earnings are scheduled and they might affect the relevant financial market, or **when a relevant financial market is closed or will be closed for at least two hours**» |

🔴 **Non posso dire quale delle due sia la lettera esatta della pagina** — non l'ho aperta, e il
canale di ricerca può aver riformulato. **[INCERTO], e lo dichiaro invece di sceglierne una.**
Ma **in tutte e due le versioni** la fattispecie colpita è la stessa: **aprire una posizione a
ridosso di una chiusura di mercato ≥ 2 ore.** E il weekend **è** una chiusura ≥ 2 ore.

**Letto oggi nei preset installati:**

```
ABTG_EMA200_771531_FTMO.set          InpUseCutoff=false   InpFridayClose=false
ABTG_SuperWave_DOW_H1_770511_FTMO.set  InpStartHour=0   InpEndHour=24
```

👉 **Nessuna delle due sedie 0-24 sul Dow ha una chiusura del venerdì attiva.** Possono **aprire**
una posizione nelle ultime ore di venerdì e portarla nel weekend.

**La misura del rischio, per non drammatizzare:**
- 🟢 **TENERE** una posizione nel weekend durante la Challenge è **esplicitamente permesso** (§⑤).
  Quello **non** è un problema.
- 🟠 **APRIRLA nelle ultime 2 ore del venerdì** è la fattispecie letterale del gap trading — che
  è una **Forbidden Practice, e quelle valgono anche in Challenge**.
- 📐 **Quanto spesso può succedere**: `771531` fa ~33 operazioni/mese su H1 a orologio pieno. Due
  ore su ~120 ore di mercato settimanali ≈ **1,7% degli ingressi** ≈ **una volta ogni due mesi**.
  **Basso. Non nullo.**

---

## 📰 ⑤ PUNTO 5 — NEWS E OVERNIGHT IN CHALLENGE. ✅ **CONFERMATO, ed è la nostra licenza**

### ✅ [CONFERMATO — LETTO-VIA-SEARCH · 20/09/2026]

Da `https://ftmo.com/en/faq/can-i-trade-news/`:

> «**Restrictions… apply only once you start trading on an FTMO Account. They do not apply during
> the Evaluation Process.**»
> «While trading during the Evaluation Process, the restriction **does not apply regardless of the
> account type**. You may trade freely during all macroeconomic news releases, **provided you do
> not engage in any Forbidden Trading Practices**.»

Da `https://ftmo.com/en/faq/do-i-have-to-close-my-positions-overnight-or-before-the-weekend/`:

> «You are allowed to **keep your positions open overnight and over the weekend** while
> participating in the evaluation phase.»

### 🟢 COSA VUOL DIRE PER NOI, STASERA

**Sì: le due sedie 0-24 sul Dow sono in regola.** In Challenge e in Verification:
- ✅ nessun filtro news richiesto — e i nostri EA **non ce l'hanno**;
- ✅ nessun obbligo di chiudere overnight;
- ✅ nessun obbligo di essere flat nel weekend;
- ✅ **e vale per QUALUNQUE tipo di conto** (`regardless of the account type`), quindi il fatto che
  il nostro sia **Standard e non Swing** **non toglie niente**.

⚠️ **L'UNICA clausola che resta appesa**: *«provided you do not engage in any Forbidden Trading
Practices»*. 👉 **Le Forbidden Practices valgono SEMPRE, anche in Challenge** — ed è il gancio del
gap trading del §④.3. Il permesso sulle news è pieno; il permesso sul *quando si apre* non lo è.

---

## 🌙 ⑥ PUNTO 6 — STANDARD vs SWING **SUL CONTO FUNDED**. ✅ **CONFERMATO — serve dopo**

### ✅ [CONFERMATO — LETTO-VIA-SEARCH · 20/09/2026]

Da `https://ftmo.com/en/faq/do-i-have-to-close-my-positions-overnight-or-before-the-weekend/`:

> «Once you become an FTMO Trader and start trading on an FTMO Account, you are **required to close
> your positions shortly before the markets close for the weekend or if the rollover (market break)
> lasts longer than 2 hours**.»
> «If there is an overnight rollover of **up to two hours** on any instrument, it is **permitted to
> keep your positions open**.»
> «Overnight and weekend position restrictions apply **only to the Standard account type**.»

Da `https://ftmo.com/en/faq/ftmo-swing-account-type/`:

> «The **Swing account type does not have any restrictions** on holding positions overnight or over
> the weekend.»

### 🟡 LA PIANIFICAZIONE, in due righe — **da leggere PRIMA di passare la Verification**

- 🔴 **Sul funded Standard**, `771531` e `770511` (0-24 sul Dow) andrebbero **fuori legge nel
  weekend** e, se la pausa notturna di `US30.cash` superasse le 2 ore, anche **overnight**.
- 🟢 **Su un funded Swing** non servirebbe toccare niente: né news, né overnight, né weekend.
- 📌 **Non è una decisione di stasera.** La challenge appena comprata è **Standard**, e **in
  Challenge queste regole NON valgono** (§⑤). La scelta Standard/Swing si presenta **alla fine
  della Verification**, ed è di Claudio.

---

## 💸 ⑦ PUNTO 7 — COMMISSIONI SUGLI INDICI. ✅ **ZERO — il `[NON MISURATO]` si chiude**

### ✅ [CONFERMATO — LETTO-VIA-SEARCH · 20/09/2026]

Da `https://ftmo.com/en/blog/zero-commissions-on-indices/`:

> «**All index symbols on the FTMO platform offer zero commission**, with every trade executed
> within this category being **completely commission-free**.»

### 🟢 CONSEGUENZA DIRETTA SULLA REGOLA DI COSTO DI CASA

La frontiera di casa è **`stop >= 40 x (spread + commissione)`**. Su FTMO, per
**`GER40.cash` · `US30.cash` · `US100.cash`**:

> ## **commissione = 0 → il costo È LO SPREAD, e basta.**

🟢 **Il `[NON MISURATO]` del collaudatore si chiude senza bisogno di misurare niente**: non c'è
una commissione da misurare. La sonda dello spread (`ABTG_SpreadLogger_FTMO.set`, già installato)
**è sufficiente** a calcolare la frontiera di costo su FTMO.

⚠️ **Due cose restano fuori dalla commissione e NON sono zero:**
1. **Lo swap**: *«CFDs… traders can be charged swaps for overnight holding… it is the trader's
   responsibility to check these swaps in the contract specification for each symbol»*. 🔴 Per le
   due sedie **0-24 sul Dow**, lo swap è un costo **reale e ricorrente** mai messo a bilancio nei
   nostri contratti. **[NON MISURATO]** — si legge in MT5, scheda *Specification*.
2. 🔴 **Sul FOREX la commissione NON è zero** (le tre sedie PostNews, fuori stasera, sono su
   `EURUSD`/`USDJPY`). La pagina Symbols dichiara una tabella con *«leverage, commission, contract
   size»* per strumento. **[NON RAGGIUNGIBILE]** — non ho letto la cifra.

---

## ✏️ ⑧ PUNTO BONUS — **LA LEVA SUGLI INDICI: il dossier di agosto dice 1:100, il testo di oggi dice 1:50**

### ✏️ [CAMBIATO — LETTO-VIA-SEARCH · 20/09/2026]

Da `https://ftmo.com/en/faq/what-are-the-account-specifications/`:

> «The leverage offered for **Standard** type accounts is **up to 1:100** and cannot be increased.»
> «For **indices**, the leverage is **1:15 for Swing** accounts and **1:50 for the Normal** account
> type (except for HK50.cash, US2000.cash and SPN35.cash where the leverage is 1:9 for Swing and
> 1:30 for Normal).»

🔴 **Il «1:100» è la leva di testata (forex). Sugli INDICI, su conto Standard, il testo di oggi
dice 1:50.** Il verdetto di prevolo di stasera (`report/PREVOLO_IL_VERDETTO_2026-09-20.md` r.37)
titola **«LA LEVA È 1:100, NON 1:15»**: l'etichetta è imprecisa per gli indici.

> ## 🟢 **MA LA CONCLUSIONE DEL PREVOLO NON CAMBIA DI UN CENTESIMO, e il motivo è che era MISURATA.**
> Quel verdetto **non ha dedotto il margine dalla leva**: ha **letto i margini dal terminale**
> (`GER40.cash` 506,24 € · `US30.cash` 900,87 € · `US100.cash` 516,94 € per lotto).
> **Un numero misurato batte un'etichetta sbagliata.** Il margine resta non-problema.

⚠️ **Ma l'etichetta va corretta**, perché chiunque riderivasse un margine da «1:100» otterrebbe
**la metà di quello vero** e si crederebbe il doppio più largo di quanto è.

---

## 🔗 ⑨ LE SETTE URL DA RIGUARDARE A OCCHIO — **dieci minuti di Claudio, e questo dossier diventa VERIFICATO**

🔴 **Nessuna di queste l'ho potuta aprire.** In ordine di quanto ci costano se sbaglio:

| # | cosa guardare | URL |
|---:|---|---|
| **1** | 🔴 la frase con **«2,000 server requests»** — controllare che ci sia la parola **«modified»** | `https://ftmo.com/en/forbidden-trading-practices/` |
| **2** | 🔴 la frase **«Risk per Trade Idea… cumulative exposure in a specific symbol or correlated symbols»** | `https://ftmo.com/en/forbidden-trading-practices/` |
| **3** | 🟠 la definizione esatta di **gap trading** (le due versioni del §④.3) | `https://ftmo.com/en/forbidden-trading-practices/` |
| **4** | 🔴 **5% / 10% / 00:00 CE(S)T**, e che il **10% sia «Static»** sul 2-Step | `https://ftmo.com/en/trading-objectives/` |
| **5** | ✅ **news e overnight non valgono in Evaluation** | `https://ftmo.com/en/faq/can-i-trade-news/` |
| **6** | ✅ **zero commissioni sugli indici** | `https://ftmo.com/en/blog/zero-commissions-on-indices/` |
| **7** | 🟡 **leva indici 1:50** e la tabella commissioni forex | `https://ftmo.com/en/faq/what-are-the-account-specifications/` · `https://ftmo.com/en/symbols/` |

### ✍️ E LE DUE DOMANDE DA MANDARE AL SUPPORTO FTMO — **solo due, le più corte possibile**

> **1)** *«Our account trades six proprietary EAs, three of which on US30.cash and one on
> US100.cash. A portfolio-level guard caps total simultaneous open risk at 4% of the account
> (max two open positions at a time). Does this constitute "cumulative exposure in a specific
> symbol or correlated symbols" under your Forbidden Trading Practices?»*
>
> **2)** *«Two of our EAs trade 0-24 and may open a position within two hours before the Friday
> weekend close, holding it over the weekend. During the Challenge/Verification, does this fall
> under the prohibited "gap trading" practice?»*

📌 **Sono le due che decidono qualcosa. Le altre cinque di agosto non servono più**: le news, il
weekend, la consistenza e le commissioni **hanno una risposta** in questo documento.

---

## 🆕 ⑩ CLASSE NUOVA — **500**

> ## CLASSE 500 — 📜⏳ **LA RIVERIFICA CHE IL DOCUMENTO STESSO DICHIARA OBBLIGATORIA, E CHE NESSUNO ESEGUE PRIMA DI SPENDERE** (20/09/2026)
>
> **Il fatto.** `docs/REGOLAMENTO_FTMO_2026-08.md` porta **in testa**, dal 13/08, l'avviso
> testuale *«Le citazioni vanno ri-verificate a occhio sulle URL indicate **prima
> dell'acquisto**»*. L'acquisto è avvenuto **oggi 20/09, trentotto giorni dopo**, e nel repo
> **non esiste traccia di quella riverifica**. Nel frattempo su quel dossier sono stati costruiti:
> l'orologio dei **dieci preset** (`+2`), il **reset giornaliero** del Guardian, e la conclusione
> *«il rischio fisso è perfetto»* — che oggi risulta **coprire metà della regola**.
>
> **Perché è una classe e non un episodio.** Un documento che contiene la propria condizione di
> validità la rende **invisibile** appena qualcuno ne cita una riga: la citazione viaggia, l'avviso
> in testa no. 📐 **Misurato col grep oggi**: i file del repo che citano quel dossier sono **29**;
> **11** portano da qualche parte una cautela (`LETTO-VIA-SEARCH`), **18 non ne portano nessuna**.
> 🔴 E fra i 18 c'è **`report/PRESET_FTMO_OROLOGIO_2026-09-20.md`**, cioè **proprio il file che ha
> rimappato l'orologio dei dieci preset** sul `+2` preso da lì.
> 🟢 `report/STASERA.md` invece la cautela ce l'ha, ed è scritta bene: `[LETTO-VIA-SEARCH, 13/08]`.
>
> **Il controllo.** Un documento con una **condizione sospensiva** («da riverificare prima di X»)
> **non può essere citato come fonte per X finché la condizione non è sciolta**, e lo scioglimento
> si scrive **con la data** dentro il documento. Se X è già successo, la riverifica **non si
> cancella: si fa dopo, e si dichiara cosa era stato deciso senza di essa.**
>
> 🟢 **Assoluzione parziale, ed è giusto scriverla**: le due cose che il dossier vecchio ha
> davvero deciso — **orologio** e **reset giornaliero** — sono state **misurate stasera** dal
> prevolo, **indipendentemente dal dossier**, e **coincidono**. Il metodo ha fallito; la fortuna
> ha coperto. **E la fortuna non è un metodo.**

---

## 📌 ⑪ IN UNA PAGINA: **CI SONO DUE COSE, E NESSUNA DELLE DUE È UN MURO**

| # | cosa | gravità | cosa fare |
|---:|---|---|---|
| **1** | 🔴 **Il tetto 2.000/giorno conta le MODIFICHE di SL/TP**, non solo le aperture. Il dossier di agosto non conteneva la parola «modified» | 🔴 **da misurare subito** | ripassare il conteggio dell'altro agente **includendo `PositionModify`** |
| **2** | 🟠 **«cumulative exposure in a specific symbol or correlated symbols»**: 3 sedie su `US30.cash` + 1 su `US100.cash` | 🟠 **mitigato, non annullato** | 🟢 il **cap C1 a 4,00%** tiene l'esposizione simultanea a 4%, non 6%. Domanda 1 al supporto |
| **3** | 🟠 **Venerdì sera**: `771531` e `770511` possono aprire a ridosso della chiusura del weekend (`InpFridayClose=false`) | 🟠 ~1 volta ogni 2 mesi | Domanda 2 al supporto. **Non toccare niente stasera** |
| **4** | 🟡 `770511` non dichiara `InpUsaGuardian` nel preset (default `true` copre) | 🟡 cosmetico | una riga nel `.set`, quando si tocca |
| **5** | 🟡 Etichetta «leva 1:100» sugli indici: il testo dice **1:50** | 🟡 nessuna conseguenza | correggere l'etichetta in `PREVOLO_IL_VERDETTO` |
| **6** | 🟡 **Swap** sulle due sedie 0-24 mai messo a bilancio | 🟡 `[NON MISURATO]` | leggerlo dalla *Specification* in MT5 |
| **7** | 🟡 Cambio ora legale **25/10/2026**: rileggere `InpDailyResetHour=1` | 🟡 promemoria | fine ottobre |

### 🟢 E LE SETTE COSE CHE SONO GIÀ GIUSTE — perché un elenco di difetti senza le vittorie descrive male la realtà

1. ✅ **`InpStartBalance=80000`**: il buco più caro possibile (Guardian ancorato a 100.000 su un
   conto da 80.000 = rete che scatta **dopo** il muro) è **già chiuso**, oggi, con firma.
2. ✅ **`InpDailyResetHour=1`** coincide con 00:00 CE(S)T, e stasera è **misurato**.
3. ✅ **Cuscini 4,5% / 9,3%**: 400 e 560 EUR di margine sotto i muri veri.
4. ✅ **News: nessun filtro richiesto in Challenge.** Il difetto più temuto del dossier di agosto
   («NIENTE FILTRO NEWS = BOMBA») **non morde in questa fase**, per nessun tipo di conto.
5. ✅ **Overnight e weekend liberi** in Challenge: le sedie 0-24 sono legittime.
6. ✅ **Zero commissioni sugli indici**: la regola di costo su FTMO è solo spread.
7. ✅ **Taglia fissa 2,00%**: sulla gamba (a) delle Forbidden Practices siamo **esemplari**.

---

*Riverifica del **20/09/2026**. Canale: **WebSearch con dominio ristretto a `ftmo.com`**.
🔴 **Fetch diretto di ftmo.com e di ogni dominio esterno: BLOCCATO dal proxy di rete (403 al
CONNECT), verificato oggi.** Nessuna citazione qui dentro è certificata parola-per-parola: le
sette URL del §⑨ restano da riguardare a occhio. Nessun EA, preset, taglia o magic è stato
toccato da questo lavoro — sola lettura.*
