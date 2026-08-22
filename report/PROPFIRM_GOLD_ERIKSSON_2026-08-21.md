# 🔬 PROP FIRM GOLD EA — Jimmy Peter Eriksson

_Referto scritto il **22/08/2026**. Tutte le pagine citate sono state **aperte
davvero**; la data di lettura e' **22/08/2026**. Ogni numero che viene da fuori
e' etichettato **[DICHIARATO DALL'AUTORE, NON MISURATO DA NOI]**. Stesso rigore
di `DOSSIER_EA_NASDAQ_ESTERNI_2026-08-21.md`._

**Mandato di Claudio (6° EA esterno)**: indagare "Prop Firm Gold EA", stesso
autore del Range Breakout (`jimmy282`), rating 4,56 — **con attenzione
particolare a cosa dichiara davvero sulle prop**, visto che le prop sono nel
nome. Referto gemello: `report/RANGE_BREAKOUT_ERIKSSON_2026-08-21.md`.

> ## 🎯 LA RIGA CHE CONTA
> **E' il prodotto piu' istruttivo dei sei EA esterni guardati finora — e non
> perche' sia buono: perche' e' l'unico che dichiara PER ISCRITTO, nel suo
> changelog, di essere costruito per NON FARSI RILEVARE dai sistemi delle prop.**
> Testo dell'autore, v1.87: *"Updated trade-comment suffixes to 'a','b','c' —
> **Reduces pattern recognition and avoids detection by prop-firm systems**."*
> Questo, per il metro di casa, non e' una funzione: e' **la ragione per cui il
> prodotto non entra**, indipendentemente da quanto guadagni.
>
> **I numeri lo accompagnano**: rischio dichiarato **Low 1,5% / Medium 3% /
> High 4,5% PER OPERAZIONE** (noi: 0,65%), fino a **3 operazioni al giorno**,
> **nessun filtro news** su un EA che si chiama "Prop Firm", **broker GMT+2/+3
> obbligatorio** (BCM e' GMT+1), e un cliente che nei commenti pubblici
> **dichiara di aver bruciato un conto funded da 200.000 USD**.

---

## 0. ✅ CONTROLLO POSITIVO DELLE FONTI

| fonte | bersaglio noto | esito |
|---|---|---|
| MQL5 Market (curl) | pagina 153540: nome/autore/prezzo/versione | ✅ HTTP 200, 296 kB |
| MQL5 `/comments` pag. 1-5 | 82 commenti dichiarati | ✅ 200, **tutti e 82 letti** |
| MQL5 `/updates` | changelog | ✅ 200, **17 versioni** |
| MQL5 recensioni (schema.org) | 34 dichiarate in intestazione | 🟠 **20 testi + voti**, il resto no (§4.1) |
| MQL5 Signals `/2356196` | signal vivo del prodotto | ✅ 200, statistiche complete |
| MQL5 Blogs `/765211` e `/765213` | FAQ prop e manuale | ✅ 200, **FAQ letta per intero** |
| MQL5 Signals `/2339929` | il signal usato come PROVA nell'ott. 2025 | 🔴 **CANCELLATO** (§7.3) |
| endpoint AJAX recensioni | pagina 2 | ❌ **404 senza sessione** (§4.1) |
| Trustpilot / Myfxbook | tracce indipendenti | ❌ **BLOCCATI dal proxy** |

🔴 **Cosa NON ho potuto vedere:** **12 recensioni su 32** (testo). L'aritmetica
(§4.1) dice che fra quelle **mancano 3 punti di voto**, quindi **ci sono da 1 a
3 recensioni sotto le 5 stelle che non ho letto**. E' l'unico buco vero di
questo referto, e lo dichiaro invece di riempirlo.

---

## 1. 🪪 SCHEDA PRODOTTO

| voce | valore | fonte |
|---|---|---|
| **nome esatto** | Prop Firm Gold EA | [VERIFICATO] |
| **piattaforma** | **MetaTrader 5**, Experts | [VERIFICATO] |
| **URL** | https://www.mql5.com/en/market/product/153540 | [VERIFICATO] |
| **autore** | Jimmy Peter Eriksson (`jimmy282`), Australia | [VERIFICATO] |
| **prezzo** | **399 USD** (schema.org `"price":"399.00"`) · scheda: *"Final Price: **$990**"* | [VERIFICATO] |
| **pubblicato** | **29 ottobre 2025** (`2025-10-29T14:55:37`) → **10 mesi** di vita | [VERIFICATO] |
| **versione attuale** | **2.5**, aggiornata **28 marzo 2026** — 🟠 **ferma da 5 mesi** | [VERIFICATO] |
| **attivazioni** | 10 | [VERIFICATO] |
| **demo scaricate** | **3.514** | [VERIFICATO] |
| **acquisti/mese** | 5 | [VERIFICATO] |
| **rating** | **4,5625** su **32** (schema.org); intestazione: 34 | [VERIFICATO] |
| **commenti** | **82** | [VERIFICATO] |
| **simbolo** | 🔵 **SOLO XAUUSD** | [VERIFICATO] |
| **timeframe** | irrilevante (*"logic is internal"*); **logica su barra M1** | [VERIFICATO] |
| **deposito minimo** | ⚠️ **NON dichiarato** | [VERIFICATO — assenza] |

📌 **Il prezzo di 399 USD non e' il prezzo che tutti hanno pagato**: nel
commento #50 il cliente Fatih Yayli scrive *"the **$200** you took from me"*
(dicembre 2025). **Il prezzo e' raddoppiato in 8 mesi**, e la scheda ne annuncia
un altro salto a 990.

---

## 2. ⚙️ IL MECCANISMO DICHIARATO — che genere di motore e'

**[VERIFICATO 22/08, testo integrale della scheda]**:
> *"Prop Firm Gold EA is a **multi-strategy** trading system designed
> specifically for Gold (XAUUSD)… The system combines **multiple logics**,
> using **breakout-based concepts** to capture the dominant intraday direction,
> together with **intraday price patterns**… The strategy is **not based on
> indicators or fixed timeframes** and uses **minimal optimisation** to reduce
> curve fitting… The system has been tested on **over 15 years** of
> high-quality historical price data and was **traded live for 15 months
> before being released** on MQL5."*

### 2.1 Risposta alla domanda del mandato: trend / mean-reversion / griglia / scalping?
**Nessuna delle quattro etichette in purezza. E' un BREAKOUT INTRADAY A USCITA
TEMPORALE, multi-modulo.** Ecco i pezzi, tutti [VERIFICATO] da fonti diverse:

| caratteristica | valore | dove l'ho letto |
|---|---|---|
| **numero di strategie** | *"multiple"*; almeno **una aggiunta in v1.7** | changelog v1.7 |
| **direzione** | breakout + pattern intraday | scheda |
| **take profit** | 🔵 **NON ESISTE** — *"The system uses **time-based exits** instead of take-profit targets"* | FAQ §9 |
| **stop loss** | *"**volatility-based** for long-term robustness"*, **grande** | FAQ §9 + §4 |
| **operazioni/giorno** | *"Normally **1-2 trades per day, occasionally 3**"* | FAQ §6 |
| **overnight / weekend** | 🔵 *"All trades close automatically **before the end of the trading day**. It **never holds trades over the weekend**"* | FAQ §7 |
| **griglia / martingala / recovery** | ⚫ **nessuna traccia** — vedi §2.2 | ricerca dedicata |

**Conferma indipendente dal cliente shino1486 (recensione 04/12/2025)**, ed e'
la descrizione tecnica migliore che ho trovato di questo motore:
> *"Since it's a **single-position trading system** and avoids risky methods
> like averaging down or grid trading, I feel secure with the SL and TP
> settings. However, so far I'm **16 losses out of 27 trades, with a win rate
> around 40%**, putting me in the red. **It seems weak in ranges, with
> noticeable buying at highs and selling at lows, so I suspect it targets
> breakouts.**"*

Risposta del venditore: *"the system uses a mix of **directional intraday
patterns and breakout logic**. Gold has strong breakout characteristics
historically, so it makes sense to buy or sell near the breakout areas."*

### 2.2 ⚫ Verifica esplicita di griglia / martingala / recovery — **NEGATIVA**
Criterio di scarto immediato del `CANCELLO_ACQUISTI_EA.md` (gradino 2).
**Ho cercato su quattro fronti e non ho trovato niente:**
1. **Changelog (17 voci)**: nessun moltiplicatore di lotto, nessun layer,
   nessun "recovery", nessun "basket", nessun "averaging".
2. **FAQ dell'autore (15 domande)**: dichiara **1 SL per trade**, SL grandi,
   uscita a tempo.
3. **Signal live (249 operazioni)**: **max deposit load 0,95%** — un motore a
   griglia/martingala produce carichi di margine crescenti, qui non succede mai.
4. **Recensioni**: **cinque clienti diversi** lo confermano spontaneamente
   (*"single-position"*, *"no grid style, no martingale, no risky recovery
   method"*, *"All trades secured with SL"*).

> ✅ **Verdetto sul gradino 2: PASSATO.** Va scritto con la stessa forza con cui
> avrei scritto il contrario. Non e' un prodotto a recupero.

---

## 3. 📜 CHANGELOG — 17 versioni in 5 mesi, poi silenzio

**[VERIFICATO 22/08, tab `/updates`, tutte le voci]**

| ver | data | testo dell'autore |
|---|---|---|
| 1.7 | 2025.11.03 | **+ una strategia in piu'** "for even better diversification and smoother equity curve" · + rischio Automatico/Manuale |
| 1.8 | 2025.11.05 | + **randomizzazione** di ingressi/uscite/SL · 🔵 **+ salta il primo giorno dopo l'installazione** "to avoid finding incorrect patterns" |
| 1.81 | 2025.11.06 | rimosso un Print ripetuto |
| 1.84 | 2025.11.11 | + **lotto fisso** · 🔵 **fix: dopo una disconnessione VPS o riavvio MT5 l'EA METTE IN PAUSA la giornata** · **randomizzazione rinforzata** |
| **1.87** | **2025.11.13** | + **First Trade Entry Delay** (minuti; *"specifically useful for FundedNext, where Gold opens at 01:15"*) · fix flickering · fix cambio TF · **+ randomizzazione del LOTTO per conti grandi** · 🔴 **"Updated trade-comment suffixes to 'a','b','c' — Reduces pattern recognition and avoids detection by prop-firm systems"** |
| 1.91 | 2025.11.20 | livelli di rischio ritoccati · **SL raffinato su una strategia per ridurre la perdita intraday massima nei rari casi in cui capitano 3 posizioni nello stesso giorno** |
| 1.92 | 2025.11.21 | fix calcolo lotti su **The5ers** e conti MetaQuotes |
| 1.93 | 2025.11.23 | ancora lotti The5ers |
| **1.94** | **2025.11.26** | 🔵 **+ input "quanti miei EA giri sullo stesso conto", il rischio si divide automaticamente in parti uguali** · **randomizzatore reso SEMPRE ATTIVO, interruttore rimosso**: *"this **prevents cases where users forget to enable it and accidentally generate identical trades, which can trigger prop-firm detection**"* |
| 1.96 | 2025.12.01 | + modalita' **FIFO** |
| **2.0** | **2025.12.28** | 🔵 **+ PROP FIRM SIMULATION MODE: simula le challenge e conta passaggi e fallimenti** in base a target e regole di DD scelti, risultati nel Journal dello Strategy Tester · + base di calcolo del rischio (saldo iniziale / equity / saldo custom) |
| **2.2** | **2026.02.10** | 🔴 **"CRITICAL RISK CHANGE: Risk is now based on risk PER TRADE. So if you set 1% you will lose that amount if one trade hits SL"** · + dashboard, curva equity, 21 metriche, log eventi |
| 2.3 | 2026.02.14 | **SL ricalcolato per ridurre la sensibilita' alla volatilita' estrema** · *"**Major reduction in worst-case losses**"* · **+ spread filter** · 🔴 **"Risk Levels: Low = 1.5% · Medium = 3% · High = 4.5%"** |
| 2.4 | 2026.02.21 | dimensione del pannello |
| **2.5** | **2026.03.28** | + first trade delay per **FundedNext** |
| — | — | 🕳️ **NESSUN AGGIORNAMENTO DA 5 MESI** (l'ultimo e' del 28/03/2026) |

### 3.1 🔴 Il reperto piu' grave: la v2.2 dice che PRIMA il rischio non era quello
> *"**CRITICAL RISK CHANGE**: Risk is now based on risk per trade. So if you set
> 1% you will lose that amount if one trade hits SL."* — 10/02/2026.

> ⚠️ **Tradotto: dal 29/10/2025 al 10/02/2026 — i primi TRE MESI E MEZZO di
> vendita — l'input "rischio %" NON significava il rischio per operazione.**
> Chi ha comprato in quel periodo e ha impostato "1%" **non stava rischiando
> l'1% per trade**, e non lo sapeva. Ed e' **esattamente** il periodo dei
> commenti #23-#55: krzys1973 che perde in 2 giorni, Fatih Yayli che brucia il
> conto funded da 200k, Alexander Seidel e Qing Dui Meng che lasciano 1 stella.
>
> **Questo e' il tipo di fatto che il ruolo esiste per trovare**: non "l'EA
> perde", ma **"il numero che l'utente scriveva nella casella del rischio non
> era il rischio"**. Su una prop, e' la definizione di conto bruciato per
> errore di configurazione.

### 3.2 🔴 E i livelli di rischio, quando finalmente sono definiti, sono ENORMI

**v2.3 (14/02/2026)** — *"Risk Levels: **Low = 1.5% · Medium = 3% · High = 4.5%**"*
(per operazione, dopo la v2.2), con **1-3 operazioni al giorno** (FAQ §6).

| livello | rischio/trade | **peggior giornata teorica (3 trade)** | vs muro giornaliero **5%** | vs cap C1 **3,25%** | vs casa **0,65%** |
|---|---|---|---|---|---|
| **Low** | 1,5% | **4,5%** | 🟠 sotto il muro, ma **sopra la pausa Guardian (4,0%) e quasi all'emergenza (4,9%)** | 🔴 **1,4×** | **2,3×** |
| **Medium** | 3,0% | **9,0%** | 🔴 **sfonda il muro giornaliero** | 🔴 **2,8×** | **4,6×** |
| **High** | 4,5% | **13,5%** | 🔴 **sfonda anche il muro TOTALE del 10%** | 🔴 **4,2×** | **6,9×** |

**E la FAQ dell'autore (07/11/2025) lo dice esplicitamente lei stessa:**
> *"**Low risk: around 2-4% max daily risk. Medium risk: around 5-10% max daily
> risk.** High risk: aggressive setting for faster prop firm challenges."*

> 🔴 **Il venditore scrive, sulla FAQ del suo EA "Prop Firm", che il rischio
> MEDIO arriva al 10% giornaliero.** Il muro giornaliero di FTMO e' **5%**.
> Non e' una nostra interpretazione: e' il suo numero, sulla sua pagina.

**E la giustificazione che segue e' il ragionamento che brucia i conti:**
> *"**Trades rarely hit the stop loss**, so even though the max risk % might seem
> high, **it is very uncommon to lose that full amount** — it would only happen
> if all strategies hit stop loss on the same day, **which is very rare**."*

> ⚫ **"Raro" non e' un numero.** La regola B dell'Emendamento e' scritta apposta:
> *"SI boccia se nel 2020 avrebbe fatto un drawdown del 25% — perche' un
> drawdown e' un fatto accaduto, non una stima."* Su un conto prop, il giorno
> "raro" non costa una brutta giornata: **costa il conto, ed e' irreversibile**.

---

## 4. ⭐ RECENSIONI E COMMENTI — 32 voti, 82 commenti, letti tutti quelli visibili

### 4.1 L'aritmetica dei voti, e il buco che dichiaro
**[VERIFICATO 22/08, `schema.org/aggregateRating` + blocchi `review_*`]**
- `ratingValue` **4,5625** su `ratingCount` **32** → somma totale = **146**.
- Ho letto **20 recensioni**: **16 da 5 stelle, 1 da 4, 1 da 3, 2 da 1**.
  Somma = **89**.
- Restano **12 recensioni** che sommano **57** su un massimo di 60.
- 🟠 **→ fra quelle 12 mancano 3 punti: ci sono da 1 a 3 recensioni sotto le
  5 stelle che NON ho potuto leggere.** L'endpoint AJAX di MQL5 richiede una
  sessione autenticata (404 senza). **[INCERTO], dichiarato.**

### 4.2 🔴 IL CASO PIU' GRAVE: un conto funded da 200.000 USD bruciato
**[VERIFICATO 22/08, commenti #45-#55, testo verbatim]**

- **Fatih Yayli, 30/11/2025 (#45)**: *"Imagine a robot where every trade is a
  loss. **Don't buy it.**"*
- **01/12 (#48)**: *"**All the trades it took throughout November were wrong.**
  I kept losing money, even though I pulled the stop level down to around 2%…
  **Could I please get a refund of my money?**"*
- **Venditore (#49)**: *"In November the EA took a total of **37 trades: 16
  winners and 21 losers**, ending the month at around **-3% on low risk**. Yes,
  it wasn't a great month, but it was nothing extreme… If your results were
  worse, it's usually because **the system wasn't used correctly**."*
- **Fatih Yayli (#50)**: *"Intervening in the robot? These are the usual excuses
  when a robot fails… **These are the completely original settings. And the stop
  level was 4%. My 200k funded account blew up because of this robot.** All I
  want is a refund."*
- **Venditore (#51)**: *"That is **less than 5% drawdown**, which is completely
  normal for this system… There is nothing wrong with the EA, and **MQL5 does
  not offer refunds**."*
- **Fatih Yayli (#52)**: *"5%? So you're denying what you're seeing. **There is
  an 8% drawdown here.**"*
- **Venditore (#53)**: *"**8k on a 200k account is 4% sir**"*
- **Fatih Yayli (#54)**: *"**You took a real account from 200k down to 183k**,
  but sure… good luck to you and your 'amazing robot' and all your excuses."*
- **Venditore (#55)**: *"Good luck"*

> ### 🔴 Facciamo il conto noi, perche' nessuno dei due l'ha fatto giusto.
> **200.000 → 183.000 = −17.000 = −8,5%.** Il venditore risponde su una cifra
> diversa (8k = 4%) e **non replica mai** quando il cliente porta i due saldi.
> Su una FTMO 200k, un **−8,5% totale** e' a **un passo e mezzo dal muro del
> 10%**, e a quel punto il conto e' finito nei fatti anche se non e' scattata
> la regola.
>
> 🎯 **Per il nostro ruolo questo e' il reperto piu' prezioso di tutto il
> referto**: non e' un'opinione su un EA, e' **il verbale pubblico di come si
> brucia un conto prop** — rischio impostato su un input che (in quel periodo,
> §3.1) **non significava quello che l'utente credeva**, drawdown protector
> messo al 4%, e **il muro totale raggiunto lo stesso**, perche' il protector
> giornaliero **non protegge dal muro TOTALE**.
>
> 🔵 **E questa e' anche la conferma piu' forte del nostro impianto**: il
> Guardian ha **entrambi** i muri (`InpDailyLossPct=4,9` **e**
> `InpTotalDDPct=9,9`). Il suo ha **solo quello giornaliero**. Il cliente e'
> caduto **esattamente nel buco che a noi manca... a lui**.

### 4.3 Gli altri clienti critici (tutti letti per intero)

| chi | quando | cosa dice | voto |
|---|---|---|---|
| **krzys1973** | 12→22/11/2025 | posta i risultati giorno per giorno: *"+88 +40 −259 −830. **Risk level: low**"*, poi *"+2, +86, −148, −231"*, poi *"I had to **turn off this EA**, it generates too many losses"*, poi la recensione: *"you're a cool guy, but I also had to disable EA **because it ruined my account**"* | **3★** |
| **Alexander Seidel** | 26/11/2025 | *"ist den Marktanforderungen nicht gewachsen… **Ergebnisse sind eher zufälliger Natur**"* (= i risultati sono di natura piuttosto casuale) | **1★** |
| **Qing Dui Meng** | 20/11/2025 | *"The result was disappointing and a complete waste of time."* | **1★** |
| **shino1486** | 04/12/2025 | 16 perdite su 27 trade, ~40% di vincenti, in rosso dopo 3 settimane — **ma tecnicamente onesto** (§2.1) | **4★** |
| **Effekt The Spycat** | 23/04/2026 (#72) | *"**7 positions perdantes 1 gagnante** qui ne rattrape même pas une des positions perdantes… Si vous avez 400 € à perdre **en plus d'une prop firm**, c'est le bot qu'il vous faut"* | commento |
| **Minh Hung Pham** | 06/12/2025 | 5★ ma con una critica precisa: *"**There are too many exchanges/prop firms, and the author needs to test the EA himself to adapt to all of them**… currently my account is not as expected"* | **5★** |

### 4.4 🔴 Il venditore AMMETTE di aver perso un conto lui stesso
**Recensione a 5 stelle di Thomas Fredy Gachter (16/03/2026)** — e' una
recensione **positiva**, ed e' proprio per questo che il dettaglio pesa:
> *"I did challenges along the way, and **Jimmy himself even mentioned that he
> lost an account during one of those phases**. So it is definitely not a
> perfect bot that only wins… **Despite those periods, I still managed to get
> funded using this EA.** … It trades very regularly, almost every day, and
> sometimes takes around **1-3 trades per day**."*

> **[DICHIARATO, NON MISURATO DA NOI]** — E' **l'unica dichiarazione di
> challenge superata** che ho trovato in 82 commenti e 20 recensioni, e arriva
> nello stesso paragrafo in cui si dice che **l'autore ha perso un conto col
> proprio EA**. Vanno tenute insieme: sono la stessa frase.

### 4.5 ⚠️ Recensioni gemelle dello stesso utente in un giorno
**Carl-Gustav Öberg, 07/02/2026, ore 20:37 e 20:38** — ha lasciato due
recensioni quasi identiche, una su Prop Firm Gold e una su Range Breakout,
**a un minuto di distanza**, entrambe in un inglese artificiale
(*"MQL5 is cluttered with **flashy, manipulated duds**… Jimmy's practices
**gleam** with their direct, hardy designs… **stochastic touches** for
individualized trades, and **prop entity adaptability**"*).
**[INFERITO]**: testo generato/parafrasato. **Non e' prova di recensioni
comprate** — l'accusa che Julien Metz fa sull'altro prodotto resta **non
dimostrata** — ma **due recensioni gemelle in 60 secondi non sono due
opinioni**, e sul totale di 32 pesano.

---

## 5. 🏛️ "PROP FIRM" NEL NOME: promessa o marketing? — la risposta e' ENTRAMBE

Questa era la domanda esplicita del mandato. La risposta ha **due meta' opposte**,
e vanno lette insieme.

### 5.1 ✅ La meta' VERA: dichiarazioni prop concrete e verificabili
A differenza di Master Nasdaq (che aveva "FTMO" nel nome e la scritta
*"Propfirm & FTMO no longer supported"* nella scheda), **qui il supporto prop
e' presente, dettagliato e mantenuto nel tempo**:

| dichiarazione | dove | verificabile? |
|---|---|---|
| **Daily Drawdown Protector su EQUITY in tempo reale vs saldo di inizio giornata** | scheda + FAQ §3 + commento #13 | ✅ **identico alla formula del nostro Guardian** (§6.1) |
| **First Trade Entry Delay** in minuti, *"useful for prop firms with later market open times"*; per **FundedNext** il valore consigliato e' **10** | scheda + changelog v1.87/v2.5 + commento #71 | ✅ istruzione operativa precisa |
| **FIFO-compliant trading mode** (per i broker USA) | scheda + changelog v1.96 | ✅ |
| **Prop-firm pass rate tester**: simula le challenge nel tester e **conta passaggi e fallimenti** | scheda + changelog v2.0 | ✅ 🔵 **funzione che a noi manca** |
| **fix specifici** per The5ers (leva bassa sull'oro → *"use Manual risk 0,25-0,5%"*) e FundedNext | changelog v1.92/1.93 + commento #38 | ✅ |
| *"the EA has to be on a broker **GMT+2/+3**"*, elenco brokers compatibili | FAQ §1 + commenti #63, #17 | ✅ |
| stima onesta del tempo di challenge: *"Low 3-6 mesi · Medium 1-3 mesi · High <1 mese"* | FAQ §12 | ✅ |

> 📌 **Su questo il venditore e' piu' serio di tutti gli altri cinque prodotti
> esterni messi insieme.** Ha una FAQ dedicata alle prop, risponde nel merito
> sulla differenza equity/balance, e ha un simulatore di challenge nel tester.
> **Va riconosciuto.**

### 5.2 🔴 La meta' che lo squalifica: il randomizzatore e' EVASIONE, non conformita'
**Le stesse funzioni, descritte in due posti diversi, cambiano nome.**

**Sulla FAQ pubblica (marketing) — v. §14:**
> *"It slightly randomises entry, exit, and stop-loss timing to ensure every
> user's trades are unique. **This helps ensure COMPLIANCE with prop firm
> rules** by preventing identical trade patterns across accounts."*

**Nel changelog (tecnico) — v1.87 e v1.94:**
> *"+ slight **lot-size randomisation** for larger accounts — Ensures users do
> not have identical lot sizes, **increasing uniqueness for prop-firm
> environments**."*
> *"Updated trade-comment suffixes to 'a','b','c' — **Reduces pattern
> recognition and AVOIDS DETECTION BY PROP-FIRM SYSTEMS**."*
> *"…this **prevents cases where users forget to enable it and accidentally
> generate identical trades, WHICH CAN TRIGGER PROP-FIRM DETECTION**."*
> *(v1.94: il randomizzatore diventa **sempre attivo, interruttore rimosso**.)*

> ### 🔴 **La differenza non e' semantica, e' giuridica.**
> Randomizzare **ingressi, uscite, stop loss, LOTTI e persino il SUFFISSO DEL
> COMMENTO DELL'ORDINE** non rende una strategia conforme: rende **piu' difficile
> per la prop accorgersi che N clienti girano lo stesso software**. La regola
> che le prop applicano non e' "vietato che i trade si somiglino": e'
> **vietato il copy trading / il trading coordinato fra conti**. Un
> meccanismo il cui scopo dichiarato dall'autore e' *"avoids detection"*
> **presume che ci sia qualcosa da non far vedere**.
>
> **E il problema non e' teorico:** i suoi EA sono venduti su almeno **tre siti
> di "group buy"** (`eafxstore.com`, `ecomforex.com`, `simpleforextools.com`,
> [VERIFICATO via ricerca 22/08]). Il numero di conti che girano questo codice
> **e' ignoto e incontrollabile**.
>
> ⚫ **Per il metro di casa questo e' un NO, e non e' negoziabile.** Regola D3:
> *confermare per iscritto con la prop prima di comprare una challenge*. Qui non
> c'e' niente da confermare — **si comprerebbe un prodotto la cui documentazione
> dichiara di aggirare i controlli della controparte**. Un payout negato dopo
> sei mesi di lavoro costa infinitamente piu' di 399 USD.

### 5.3 🔴 E la terza cosa: **nessun filtro news, su un EA che si chiama "Prop Firm"**
**[VERIFICATO 22/08, commenti #76-#79]**

- **Shahzad Kotia, 01/05/2026**: *"I've just installed 2.5, but **I can't see
  the news filter**… Are these already automatically built in?"*
- **Venditore, stesso giorno**: *"**There is no News Filter built into this EA**
  as it **relies on strong moves that are sometimes made by news events**."*
- **Shahzad, 06/05**: *"So if I want to prevent the EA from trading major news
  releases, just simply pause and restart the EA after?"*
- **Venditore, 06/05**:
  > *"the problem with this is that **if a trade hit SL because of the news
  > event, that will ALSO break the news rule**. So the best option is to
  > **close all trades before the news event**, then turn the EA off, and after
  > the news event start the EA again. **It's not optimal and that's why I
  > never recommend anyone to trade with a prop firm that has news rules. It's
  > made only so that you will break a rule and fail the challenge. Best is
  > FTMO Swing.**"*

E la FAQ §2 lo conferma: *"It **may occasionally hold trades during high-impact
news**… so make sure your prop firm allows news trading — or simply disable the
EA before major events."*

> ⚠️ **Questa e' un'ammissione onesta e una bandiera rossa insieme.**
> Il prodotto si chiama **"Prop Firm" Gold EA**, e il suo autore consiglia di
> **non usarlo con le prop che hanno regole sulle news** — cioe' **quasi tutte
> quelle a due fasi**, incluso il conto FTMO standard. La sua raccomandazione
> (*"Best is FTMO Swing"*) e' un prodotto **diverso e piu' caro** da quello
> che il progetto sta valutando in `ROTTA_PROP.md`.
> 📌 E la sua osservazione tecnica **e' corretta e vale anche per NOI**:
> *uno SL colpito durante la finestra news viola comunque la regola news*.
> **Va scritta nel nostro `DOMANDE_SUPPORTO_PROP.md`** come domanda da fare per
> iscritto: *"una posizione APERTA PRIMA della finestra news e CHIUSA DENTRO la
> finestra viola la regola?"* — vedi §9, proposta P5.

---

## 6. ⏰ FUSO E ORARI — e il "no" dell'autore a chi ha esattamente il nostro caso

### 6.1 Cosa dichiara
Paragrafo **identico parola per parola** a quello di Range Breakout:
> *"This system is designed for brokers using **standard US trading time
> (GMT+2 / GMT+3)**."*
FAQ §1: *"The EA **only works correctly** with brokers using **GMT+2 or GMT+3**
(FTMO, IC Markets, Pepperstone, Darwinex, Vantage). VPS location doesn't
matter — **only the broker's server time matters**."*

### 6.2 🔴 Il commento che chiude la questione per BCM
**Commento #62-#65, 13/02/2026** — un cliente tedesco su FTMO chiede:
> *"**The broker has a GMT+1 server, not GMT+2 — is that a problem?**"*

Risposta del venditore:
> 🔴 *"**Yes the broker has to be GMT+2/3 or it will not take correct trades.**"*

> ### 🚨 **BCM oggi (agosto 2026) e' GMT+1.**
> Regola di casa: ora server BCM = ora italiana − 1; l'Italia e' CEST (UTC+2)
> → **BCM = UTC+1 = GMT+1**. Il broker di riferimento dell'autore, che segue
> l'ora legale USA, oggi e' **GMT+3**: **scarto di 2 ore**.
> **E' il caso che l'autore dichiara esplicitamente NON supportato**, sul suo
> stesso thread, a un cliente nella nostra identica situazione.

📌 **Nota tecnica utile per noi**: il cliente aveva il **grafico in GMT+1** ma
il pannello dell'EA leggeva **GMT+2** perche' era su un **server FTMO**, non sul
suo broker. Il venditore ha risolto guardando il pannello, non il grafico. E'
la stessa trappola della regola di casa *"ora dei LOG ≠ ora del GRAFICO"*
(06/08): **prima di dire in che fuso sei, stabilisci quale orologio stai
leggendo.**

### 6.3 Altri orari dichiarati
- **FundedNext**: l'oro apre **01:15 ora broker**, quindi `First Trade Entry
  Delay = 10` (changelog v1.87, commento #71).
- **Uscita**: *"All trades close automatically before the end of the trading
  day"* — orario **non pubblicato**, e' interno. **[INCERTO]**
- **Weekend**: mai.

---

## 7. 📈 IL TRACK RECORD

### 7.1 Il signal vivo: **Prop Firm Gold EA** (`/signals/2356196`)
**[VERIFICATO 22/08 — statistiche MQL5]**

| voce | valore |
|---|---|
| Growth | **42,77%** ("growth since 2025") |
| Initial Deposit | **2.500 USD** · 🔵 **depositi 0, prelievi 0** (conto pulito) |
| Broker / leva | ICMarketsSC-MT5-2 · 1:500 |
| Settimane | **34** · vita del signal **236 giorni** · giorni operativi 148 (62,7%) |
| Operazioni | **249** · **6/settimana** · durata media **8 ore** |
| Vincenti | **128 (51,40%)** |
| Profit Factor | **1,25** · Expected payoff 4,29 USD |
| **Sharpe Ratio** | 🔴 **0,09** |
| Media vinta / persa | +41,51 / −35,07 USD |
| Miglior / peggior trade | +204,54 / **−198,45 USD** |
| Max perdite consecutive | **9** (−231,82) |
| **Drawdown max sul saldo** | 🔴 **686,33 USD = 18,43%** |
| Max deposit load | **0,95%** |
| **Long / Short** | 🔴 **202 (81,1%) / 47 (18,9%)** |
| **Subscribers** | **0** |
| Simboli | XAUUSD 247 · XAUAUD 2 |

### 7.2 🔴 Le tre cose che questo signal dice, e nessuna e' buona per noi

**a) L'avviso automatico di MQL5** (non mio, non del venditore):
> *"**80% of growth achieved within 4 days.** This comprises **1,69% of days**
> out of 236 days of the signal's entire lifetime."*
> → Il +42,77% e' **quattro giornate**. Con Sharpe 0,09, il resto e' rumore.

**b) Drawdown 18,43% contro il muro totale del 10%.**
> Il signal **ufficiale del venditore**, sul suo broker, al suo rischio,
> **avrebbe fallito una challenge FTMO da 10%**. Regola B dell'Emendamento:
> il drawdown e' un fatto accaduto, non una stima.

**c) 🔴 81% di operazioni LONG sull'oro.**
> 202 long contro 47 short, in un periodo (2026) di oro in tendenza rialzista.
> **[INFERITO, e lo dico da cosa]**: uno squilibrio 4:1 in un motore che
> dichiara di essere *"directional breakout"* simmetrico **non e' simmetria: e'
> un motore che ha guadagnato perche' l'oro saliva**. Il campione non contiene
> **nessun regime di oro in discesa prolungata** — che e' precisamente cio' che
> la regola C dell'Emendamento (prova di regime) chiede di avere prima di
> giudicare il merito.

### 7.3 🔴 Il signal usato come PROVA all'uscita del prodotto e' stato cancellato
**[VERIFICATO 22/08]** Nel **commento #5 del 31/10/2025** — due giorni dopo la
pubblicazione — il venditore scrive:
> *"So far the system is up **20% with a drawdown of 2,9%** in October.
> Signal: https://www.mql5.com/en/signals/**2339929**"*

**Quell'URL oggi risponde**: *"The signal you requested has probably been
deleted."* Idem per `/signals/2290544`, citato sull'altro prodotto.

> ⚠️ **Non e' prova di malafede** (si cancella un signal anche per chiudere un
> conto). **Ma e' un fatto**: la prova con cui il prodotto e' stato lanciato
> **non e' piu' verificabile da nessuno**, e il signal vivo che la sostituisce
> parte **tre mesi dopo** (28/01/2026), cioe' **dopo** il mese di novembre 2025
> in cui i clienti si lamentavano.

### 7.4 🧨 Il confronto con `METRO_PROP.md`

| metro | **casa nostra** | **Prop Firm Gold EA** | verdetto |
|---|---|---|---|
| muro totale | **10% statico** | **DD 18,43%** sul suo signal | 🔴 **1,8× il muro** |
| muro giornaliero | **5%** (pausa 4,0 / emergenza 4,9) | Low **4,5%/giorno**, Medium **9%**, High **13,5%** | 🔴 Medium e High **sfondano** |
| rischio per trade | **0,65%** | Low **1,5%** / Med **3%** / High **4,5%** | 🔴 **2,3× / 4,6× / 6,9×** |
| cap rischio aperto | **3,25% (C1)** | fino a **3 posizioni** × il livello scelto | 🔴 Low = 4,5% > C1 |
| peggior giornata misurata | **−2,06% (R51)** | peggior trade **−198,45 su 2.500** = **−7,9% in UNA operazione** | 🔴 |
| perdite consecutive | — | **9** | a Low (1,5%) = **13,5%**: 🔴 **oltre il muro totale** |
| filtro news | 🟠 esiste sui nostri EA | ❌ **assente per scelta** | 🔴 |

---

## 8. 🧱 TABELLA DEI BUCHI — cosa ha lui che a noi manca

Confronto contro `ABTG_Guardian.mq5` (v1.11, letto oggi) e gli input dei nostri EA.

| meccanismo | **noi** | **Prop Firm Gold EA** |
|---|---|---|
| cap giornaliero: **equity vs saldo di inizio giornata** | ✅ Guardian riga 366: `dailyLoss = dayStart − eq`, emergenza **4,9%**, pausa **4,0%** | ✅ **identico** (FAQ §3, commento #13) |
| **muro TOTALE** | ✅ **9,9% statico** (+ `InpDDMode=1` trailing) | 🔴 **ASSENTE** — ed e' il buco in cui e' caduto il conto da 200k (§4.2) |
| cap rischio APERTO simultaneo | ✅ **C1 3,25%** | ❌ assente (3 posizioni × livello) |
| chiude posizioni di **qualsiasi magic** | ✅ `InpCloseAllMagics` | ❌ solo le sue |
| **pausa dopo disconnessione VPS / riavvio MT5** | ❌ **BUCO** | 🔵 ✅ **v1.84: sospende la giornata** |
| **salta il primo giorno dopo l'installazione** | ❌ **BUCO** | 🔵 ✅ v1.8 |
| **ritardo del primo ingresso della giornata** (minuti) | ❌ **BUCO** | 🔵 ✅ `First Trade Entry Delay` |
| **divisione automatica del rischio fra piu' EA sullo stesso conto** | 🟠 il C1 fa una cosa **migliore** (cap sul rischio, non spartizione) | ✅ v1.94 |
| **simulatore di challenge nel tester (conta pass/fail)** | ❌ **BUCO** (abbiamo Monte Carlo offline, non un contatore nel round) | 🔵 ✅ **v2.0 "Prop Firm Simulation Mode"** |
| **flat a fine giornata / mai overnight / mai weekend** | ❌ **BUCO** (gia' segnato ieri) | ✅ sempre |
| guardia spread | 🟠 da verificare EA per EA | ✅ v2.3 |
| **modalita' FIFO** | ❌ | ✅ v1.96 |
| filtro news | 🟠 `InpUseNewsFilter` sui nostri EA | 🔴 **assente per scelta dichiarata** |
| stop dopo N perdite di fila | ❌ **BUCO** | ❌ assente (ne ha fatte **9**) |
| randomizzatore anti-impronta | ❌ | 🔴 ✅ ma **dual-use** (§5.2) |
| parametri del motore ispezionabili | ✅ i nostri | 🔴 chiusi (plug & play) |

> ### 🎯 **Il pezzo piu' prezioso che ho trovato in questo prodotto e' UNA RIGA
> ### DI CHANGELOG, e non e' una strategia.**
> **v1.84**: *"Fixed issue where a **VPS disconnection or MT5 restart could
> cause inaccurate trade entries** — the EA now **pauses trading for that day**
> to stay safe."*
> Noi giriamo **in forward su un VPS**. Un riavvio a meta' sessione, su un EA di
> apertura che costruisce un range, produce **un range sbagliato e un ingresso
> sbagliato** — ed e' esattamente il bug che l'altro prodotto ha avuto in
> pubblico (Range Breakout, commento #7: *"buy&sell at the same time"*, risposta
> #8: *"if you… **restarted the terminal** or similar, **the range will not be
> correct and it can open wrong positions**"*).
> **Non abbiamo nessuna protezione di questo tipo. E' il buco piu' concreto
> emerso in due notti di lavoro sugli EA esterni.**

---

## 9. ⚖️ RACCOMANDAZIONE ONESTA E PROPOSTE

### 🔴 **SI SCARTA. Non per come opera — per come e' costruito il rapporto con le prop.**

**Motivo primario, formale e non opinabile:**
il changelog dell'autore dichiara che il prodotto **modifica lotti, orari,
stop e suffissi del commento d'ordine per "evitare la rilevazione da parte dei
sistemi delle prop firm"** (v1.87, v1.94). **Non compriamo uno strumento la cui
documentazione dichiara di aggirare i controlli della controparte con cui
firmeremmo un contratto.** Il costo di un payout negato non e' 399 USD.

**Motivi che si sommano, tutti verificati:**
1. 🌍 **Il fuso lo esclude**: *"the broker **has to be GMT+2/3 or it will not
   take correct trades**"* (#63). BCM e' **GMT+1**, scarto **2 ore**, e i
   parametri sono chiusi (plug & play).
2. 📉 **Il suo signal fa 18,43% di drawdown** contro il nostro muro del 10%,
   con **Sharpe 0,09**, **81% long** in un mercato che saliva, e l'avviso
   automatico di MQL5 *"80% of growth achieved within 4 days"*.
3. 💣 **I livelli di rischio sono 2,3-6,9 volte i nostri** e la FAQ dell'autore
   dichiara il livello *Medium* a **"5-10% max daily risk"** — sopra il muro
   giornaliero del 5%.
4. 📰 **Nessun filtro news, per scelta**, con l'autore che consiglia di non
   usarlo sulle prop che hanno regole news — cioe' quasi tutte.
5. 🧾 **Il changelog ammette che per 3 mesi e mezzo l'input del rischio non
   significava il rischio per trade** (§3.1), e quel periodo coincide con il
   conto funded da 200k bruciato (§4.2).
6. ⏸️ **Fermo da 5 mesi** (ultima versione 28/03/2026), mentre il prodotto
   gemello e' stato aggiornato ieri l'altro.

**Cosa NON e' un motivo di scarto, e va detto per correttezza:**
- ✅ **Nessuna griglia, nessuna martingala, nessun recovery** — verificato su
  quattro fronti indipendenti (§2.2). **Il gradino 2 del cancello lo passa.**
- ✅ **Il supporto prop e' reale e documentato** (§5.1): FAQ dedicata, risposta
  corretta sulla differenza equity/balance, simulatore di challenge, fix
  specifici per The5ers e FundedNext.
- ✅ **Il venditore risponde in pubblico anche a chi lo attacca**, e ammette
  cose contro il proprio interesse (di aver perso un conto lui stesso, che il
  trailing non funziona, che il bug dei lotti c'era).

### 💰 E il CANCELLO ACQUISTI?
**Non arriva al gradino 3.** Si ferma al **gradino 2**, e non per griglia — per
il randomizzatore anti-rilevazione, che e' una bandiera rossa di natura
**contrattuale**, non tecnica. **Nessuna proposta d'acquisto.**

---

### 📋 LE PROPOSTE — cosa ci portiamo a casa (NON applicate, decide Claudio)

| # | proposta | dove | fonte | costo | rischio |
|---|---|---|---|---|---|
| **P1** ⭐ | **PAUSA DOPO RIAVVIO / DISCONNESSIONE**: se l'EA riparte a sessione gia' iniziata (range gia' in formazione o gia' rotto), **non opera per quella giornata** | input nuovo negli EA di apertura + una `GlobalVariable` di "giornata sporca" | changelog v1.84 + il bug pubblico di Range Breakout (#7/#8) | ~3h + 1 giro di autotest | un riavvio legittimo prima dell'apertura non deve bloccare la giornata: serve una condizione precisa ("range gia' iniziato") |
| **P2** ⭐ | **SIMULATORE DI CHALLENGE NEL TESTER**: a fine run, conta quante volte una challenge (target +10%, muro 5%/10%) sarebbe stata **passata o fallita** partendo da ogni giorno della serie, e lo scrive nel Journal | script di analisi sui CSV dei round, **non** codice negli EA | changelog v2.0 | ~4h (una volta sola, poi vale per ogni round) | 🔵 e' **misura, non comportamento**: rischio nullo sul conto. **Migliora l'imbuto, non lo tocca** |
| **P3** | **RITARDO DEL PRIMO INGRESSO** in minuti (per prop con apertura ritardata) | input negli EA di apertura | `First Trade Entry Delay` (v1.87) + commento #71 | ~1h | dimezza il campione se usato senza misurarlo |
| **P4** | **SALTA IL PRIMO GIORNO** dopo l'installazione/aggiornamento di un EA | Guardian o EA | changelog v1.8 | ~1h | perde una giornata a ogni deploy |
| **P5** | **DOMANDA DA FARE PER ISCRITTO ALLA PROP**: *"una posizione aperta PRIMA della finestra news e chiusa DENTRO la finestra (per SL colpito) viola la regola news?"* | `report/DOMANDE_SUPPORTO_PROP.md` | commento #79, argomento tecnico corretto dell'autore | 10 minuti | 🔵 **costo quasi zero, e la risposta cambia come si configura il filtro news** |
| **P6** | **Verificare che il Guardian NON abbia il buco del muro TOTALE** che ha bruciato il conto da 200k | controllo, non codice | §4.2 | 30 min | ✅ **gia' verificato oggi in lettura: `InpTotalDDPct=9,9` c'e'.** Resta da confermare che sia attivo sul demo prop |

🔴 **Nessuna di queste si applica da sola.** Vanno in coda all'imbuto come
qualunque modifica; gli `_Ottimizzato` girano in parallelo, mai sostituiti.

---

## 10. 👤 IL VENDITORE, VISTO ATTRAVERSO I SUOI DUE PRODOTTI

_(sezione condivisa, identica in `report/RANGE_BREAKOUT_ERIKSSON_2026-08-21.md` §11)_

### 10.1 I numeri del profilo
**[VERIFICATO 22/08, `mql5.com/en/users/jimmy282/seller`]**
Jimmy Peter Eriksson · **Australia** · reputazione **8.619** ·
**4,4 stelle su 146 recensioni** a livello venditore · **7 prodotti** ·
🔵 **13 signals** · 1 commento · sito proprio **erikssonsystems.com** ·
esperienza dichiarata: *"over 5 years"* · metodo dichiarato: *"**no martingale,
no grid systems, and no hidden risk mechanics**"*.

> 🔵 **I 13 signals sono la differenza piu' importante rispetto ai tre venditori
> di stanotte** (Artemis: 0 signals; Yudi Warsito: 0 signals). Qui c'e'
> materiale verificabile da terzi. Che poi quel materiale **lo bocci** e' un
> altro discorso — ma **e' verificabile**.

### 10.2 I 13 signals, tutti, coi loro drawdown
**[VERIFICATO 22/08, `mql5.com/en/signals/author/jimmy282`]**

| # | signal | crescita | sett. | trade | vinc. | PF | **max DD** | subs |
|---|---|---|---|---|---|---|---|---|
| 1 | **Range Breakout EA Live** | 320% | 92 | 1.876 | 42% | 1,16 | 🔴 **28%** | **1** |
| 2 | Complete Portfolio 1 | 289% | 102 | 4.403 | 48% | 1,10 | 🔴 **41%** | 0 |
| 3 | Pattern Recognition Portfolio | 100% | 54 | 1.210 | 55% | 1,13 | 🔴 **28%** | 0 |
| 4 | Prop Firm Gold x Market Anomalies | 67% | 40 | 846 | 48% | 1,11 | 🔴 **28%** | 0 |
| 5 | Market Anomalies EA | 52% | 41 | 571 | 51% | 1,17 | 🔴 **25%** | 0 |
| 6 | Index Test | 47% | 17 | 255 | 56% | 1,16 | 🔴 **31%** | 0 |
| 7 | **Prop Firm Gold EA** | 43% | 34 | 249 | 51% | 1,25 | 🔴 **18%** | 0 |
| 8 | Pulse Engine Live | 41% | 27 | 1.663 | 51% | 1,16 | 🟠 **17%** | 0 |
| 9 | Gold Atlas Live | 40% | 36 | 285 | 36% | 1,17 | 🟠 **16%** | 0 |
| 10 | The Bitcoin Core Live | 26% | 34 | 937 | 40% | 1,15 | 🔴 **20%** | 0 |
| 11 | Eriksson Systems TEST | 13% | 31 | 1.776 | 46% | 1,03 | 🔴 **23%** | 0 |
| 12 | Portfolio Test | 97% | **3** | 257 | 51% | 2,94 | 5% | 0 |
| 13 | **Eriksson Systems Complete Portfolio** | 601% | 76 | 5.576 | 47% | 1,20 | 🔴🔴 **75%** | 3 |

> ### 🎯 **Guardate la colonna del drawdown, non quella della crescita.**
> **Su 13 signals, DODICI hanno un drawdown massimo SOPRA il nostro muro
> totale del 10%.** L'unico sotto (Portfolio Test, 5%) ha **3 settimane di
> vita**. Il portafoglio completo — quello che il venditore consiglia ai
> clienti come "diversificazione" — fa **75% di drawdown**.
>
> **E i profit factor sono tutti fra 1,03 e 1,25**, cioe' motori a margine
> sottile che vivono di coda destra. Con 4 subscribers totali su 13 signals.
>
> ⚫ **Non e' un giudizio sul venditore: e' il suo stesso archivio pubblico.
> Nessuno dei suoi sistemi, cosi' com'e' configurato da lui, sopravvive al
> metro di `METRO_PROP.md`.**

### 10.3 Il catalogo — 7 prodotti, non 19 in 77 giorni

| prodotto | prezzo | rating | pubblicato |
|---|---|---|---|
| Pulse Engine | 599 USD | 4,08 (37) | — |
| Range Breakout EA with Range Filters | 649 USD | 4,55 (22) | **25/08/2024** |
| Gold Atlas | 449 USD | 4,61 (23) | — |
| Market Anomalies EA (solo USDJPY) | 349 USD | 4,71 (17) | — |
| **Prop Firm Gold EA** (solo XAUUSD) | **399 USD** | **4,56 (32)** | **29/10/2025** |
| The Bitcoin Core (solo BTC) | 349 USD | 4,85 (13) | — |
| EA Portfolio Analyzer (utility) | 49 USD | 4 (1) | — |

📌 **Il ritmo e' sostenibile.** 7 prodotti, il piu' vecchio di 2 anni.
**Non e' una fabbrica** (Artemis: 19 prodotti in 77 giorni). Ma **cinque dei
sette sono usciti dopo ottobre 2025**, cioe' **in dieci mesi** — e questo,
insieme al §10.4, e' il punto.

### 10.4 🔴 I DUE MOTORI SI SOMIGLIANO — e lo dicono i suoi stessi clienti
Domanda esplicita del mandato. **La risposta e' SI, e non e' un sospetto mio.**

**Prova 1 — un cliente, in una recensione a 5 stelle su Range Breakout
(bi mo, 02/05/2026):**
> *"Great system… but **Be mindful that some strategies have high correlation
> with other EAs from the author.**"*

**Prova 2 — le due schede si sovrappongono, in alcuni punti alla lettera:**

| elemento | Range Breakout | Prop Firm Gold |
|---|---|---|
| *"not based on indicators or fixed timeframes"* | ✅ | ✅ |
| *"No Martingale / No Grid"* | ✅ | ✅ |
| *"Daily drawdown protector (prop firm friendly, e.g. FTMO)"* | ✅ | ✅ **identico** |
| *"Built-in trade randomizer (prop firm friendly)"* | ✅ | ✅ **identico** |
| paragrafo **"Broker Time"** GMT+2/GMT+3 | ✅ | ✅ **identico parola per parola** |
| paragrafo **"Warning"** su AI/ICT/SMC | ✅ | ✅ **identico parola per parola** |
| risk level Low / Medium / High + manual % + lotto fisso | ✅ | ✅ |
| uscita a **tempo**, niente TP, mai overnight, mai weekend | ✅ | ✅ |
| XAUUSD | uno dei 5 mercati | **l'unico mercato** |
| *"Plug & Play, no set-files"* | ✅ (dalla v2.10) | ✅ (da sempre) |

**Prova 3 — il venditore stesso, commento #20 di Prop Firm Gold (11/11/2025)**,
a un cliente che aveva comprato entrambi e chiedeva la differenza:
> *"The Prop Firm EA uses **multiple strategies inside the same EA**.
> RangeBreakout is **just one strategy**, but it works for 3 markets."*

> ### 🎯 **Traduzione col nostro vocabolario: e' UNA CASA con UN telaio.**
> Uscita a tempo · niente indicatori · niente timeframe · rischio Low/Medium/High
> · randomizzatore · daily drawdown protector · GMT+2/3 · XAUUSD al centro.
> **Range Breakout = un motore su cinque mercati. Prop Firm Gold = piu' moduli
> su un mercato.**
>
> ⚠️ **Comprarli entrambi non e' diversificare: e' concentrare** — e infatti
> esiste un signal "Prop Firm Gold **x** Market Anomalies Combo" che fa **28%
> di drawdown**, peggio del Prop Firm Gold da solo (18%). **La combinazione
> peggiora il rischio invece di attenuarlo.** E' lo stesso difetto misurato sui
> "5 blocchi diversi" di Master Nasdaq (§3.2 del dossier di ieri), con la
> differenza che **qui e' scritto in una recensione a 5 stelle e nei numeri dei
> suoi stessi signals**.

### 10.5 🎭 Il tono con i clienti scontenti — un dato, non un giudizio
Ho letto **115 commenti** (33 + 82) e **40 recensioni** fra i due prodotti.
Lo schema di risposta e' **sempre lo stesso**:
1. *"due settimane sono troppo poche per giudicare"*;
2. il numero aggregato del proprio signal contro il conto del cliente;
3. *"se vuoi vincere ogni giorno, comprati un martingala"*.

A volte e' **corretto** (chi molla dopo 3 giorni ha torto, e il venditore ha
ragione a dirlo). A volte e' **una scorciatoia**:
- a **Oly.FX**, cliente da **14 mesi** con un bug dei lotti **dimostrato con
  screenshot**: prima il silenzio, poi la spiegazione tecnica solo dopo la
  recensione a 3 stelle;
- a **Fatih Yayli**, che dichiara un conto funded da 200k bruciato: *"There is
  nothing wrong with the EA, and **MQL5 does not offer refunds**"*;
- a **Qing Dui Meng**: *"**Quitting after 1-2 weeks says more about you than
  about the EA**… **Maybe time for you to come back to reality**."*

> 📌 **Perche' lo scrivo in un referto tecnico**: perche' il supporto e'
> **l'unica cosa che tutte le 33 recensioni positive nominano**, ed e' quindi
> **il vero prodotto che si compra**. Sapere come si comporta quel supporto
> **quando il conto va male** e' un dato, e i quattro casi sopra dicono che si
> comporta **difendendo il prodotto**, non il cliente.

### 10.6 ⚠️ I suoi EA sono PIRATATI su almeno tre siti di "group buy"
**[VERIFICATO 22/08 via ricerca]**: `eafxstore.com`, `ecomforex.com`,
`simpleforextools.com` rivendono/regalano **entrambi** i prodotti.

> 🔴 Significa che un numero **ignoto e incontrollabile** di conti gira lo
> stesso codice — ed e' il motivo per cui esiste il randomizzatore (§5.2).
> Su una prop, **"molti conti che fanno gli stessi trade" e' la definizione
> operativa di copy trading**, che quasi tutte vietano. **Regola D3 di casa:
> si applica in pieno.**

---

## 11. 🗂️ ELENCO DELLE PAGINE APERTE (per chi verra' dopo)

| URL | cosa ci ho preso |
|---|---|
| `mql5.com/en/market/product/153540` | scheda integrale, 399 USD, v2.5 del 28/03/2026, schema.org (4,5625 / 32, 20 voti nominali) |
| `mql5.com/en/market/product/153540/comments` (+ `/page2..5`) | 🔵 **tutti gli 82 commenti verbatim** — conto 200k, GMT+1, filtro news, The5ers |
| `mql5.com/en/market/product/153540/updates` | **changelog completo, 17 versioni** — randomizzatore, CRITICAL RISK CHANGE, livelli 1,5/3/4,5% |
| `mql5.com/en/blogs/post/765211` | 🔵 **FAQ "Prop Firm Gold EA (Read Before Using)"** integrale — 15 domande, rischi giornalieri, GMT, DD protector |
| `mql5.com/en/signals/2356196` | **signal vivo**: 249 trade, DD 18,43%, Sharpe 0,09, 81% long, avviso "80% in 4 days" |
| `mql5.com/en/signals/2339929` | 🔴 **CANCELLATO** — era la prova del lancio (commento #5) |
| `mql5.com/en/signals/author/jimmy282` | **i 13 signals con crescita, DD e subscribers** (§10.2) |
| `mql5.com/en/users/jimmy282/seller` | 7 prodotti coi prezzi, 4,4 (146), 13 signals |
| ricerca web (eafxstore / ecomforex / simpleforextools) | **pirateria confermata su 3 siti** |
| `www.trustpilot.com` · `www.myfxbook.com` | ❌ **bloccati dal proxy** — **[INCERTO]** |
