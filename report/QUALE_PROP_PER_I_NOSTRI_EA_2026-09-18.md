# 🏛️ QUALE PROP PER I NOSTRI EA — e quale ammette il POST-NEWS

**Scritto il 18/09/2026**, il giorno del breach FundedNext Stellar Lite
(`report/BREACH_FUNDEDNEXT_2026-09-18.md`).
Richiesta testuale di Claudio: _«MANDA UN'AGENTE PER CAPIRE QUALE PUO' ESSERE
UNA PROP ADATTA AGLI EA ED AGLI EA SULLE POST NEWS»_.

🔒 **Nessun acquisto, nessuna iscrizione, nessuna taglia consigliata, nessun EA
toccato.** Questo file è **materiale per una decisione di Claudio**, non una
decisione. Dove scrivo «costa X» è un fatto letto, non una proposta di spesa.

---

# 0. 🥇 LE TRE RIGHE CHE CAMBIANO LA DOMANDA

> ## ① Il muro giornaliero non ha UNA forma: ne ha DUE, e nessuno ce l'aveva mai scritto.
> **Su 6 prop censite, 5 uccidono il conto al muro giornaliero. UNA lo mette solo
> in PAUSA fino al giorno dopo** (The5ers **Hyper Growth**, «daily pause» 3%:
> _«The daily pause does not terminate an account. It only disables the account for
> the current day»_). 👉 **Il 18/09 quel prodotto avrebbe restituito il conto il
> giorno dopo invece di chiuderlo.** Il prezzo che chiede: muro totale al **6%**
> contro il nostro p99 misurato a **8,1%** — cioè **incompatibile con la taglia di
> casa senza rifare le misure**. Non è una raccomandazione: è il fatto.

> ## ② Sul muro TOTALE, Stellar Lite era fuori misura già in partenza — e non ce ne eravamo accorti.
> Lo **Stellar Lite** ha muro totale **8%**, non 10%
> ([help 9094072](https://help.fundednext.com/en/articles/9094072-what-rules-do-i-need-to-follow-in-the-stellar-lite-challenge)).
> Il nostro **p99 Monte Carlo a rischio 0,65% è 8,1%** (`report/METRO_PROP.md`).
> 🔴 **8,1 > 8,0: il nostro stesso metro dice che quel prodotto non lo reggevamo
> nel percentile 99.** Il breach del 18/09 è avvenuto sul muro GIORNALIERO, ma
> anche quello TOTALE era sotto misura. **Due muri stretti, zero verifiche.**

> ## ③ E sulle NEWS le prop si dividono in due famiglie che NON vanno confuse.
> Alcune regolano la **FINESTRA** (vietato aprire/chiudere entro ±X minuti):
> **FTMO**, **FundedNext**, **E8**. Altre regolano la **STRATEGIA** (vietato *fare*
> news trading, comunque e quando che sia): **The5ers** vieta per nome la
> _«bracketing strategy … opening buy and sell stops close to the price»_,
> **FundingPips** scrive _«purposely trading news in both evaluation and master
> phase is prohibited and will lead to account closure»_.
> 👉 **`ABTG_PostNews` è compatibile PER COSTRUZIONE solo con la prima famiglia**:
> entra a **news + 45 minuti**, quindi fuori da qualunque finestra da 2, 5 o 10
> minuti. Ma contro un divieto di STRATEGIA la finestra non lo salva: lo salva
> solo il fatto che la regola parli di minuti e non di intenzioni.

---

# 1. 🚨 CLASSE DI PROVA — da leggere PRIMA delle tabelle

## Controllo positivo, fatto oggi 18/09/2026

| canale | bersaglio noto | esito |
|---|---|---|
| `curl` su **ftmo.com, academy.ftmo.com, fundednext.com, help.fundednext.com, help.the5ers.com, help.fundingpips.com, help.e8markets.com, help.alphacapitalgroup.uk** | homepage | ❌ **8 domini su 8: `CONNECT tunnel failed, response 403`** |
| **WebFetch su `mql5.com`** (`/en/code/76767`) | deve dare "PropFirmGuard" | ✅ **200, titolo corretto** → il canale è vivo, **il blocco è PER DOMINIO** |
| **WebSearch ristretta ai domini ufficiali** | FTMO Trading Objectives deve mostrare 5% e 10% | ✅ **restituisce il contenuto della pagina ufficiale** |

> 🛑 **Nessuna pagina ufficiale di prop è stata APERTA da me.** Identico all'08/09
> (`REGOLAMENTI_PROP_2026-09-08.md` r.43) e al 31/08. **Il blocco non è
> migliorato.**

| etichetta | significato |
|---|---|
| **[LETTO-VIA-SEARCH]** | il motore ha letto **la pagina ufficiale** (ricerca ristretta al dominio) e me ne ha restituito il contenuto. **Io non l'ho aperta.** Verificabile da Claudio in 30 secondi con un browser |
| **[VERIFICATO]** | letto da me in repo (codice, preset, verbali) o aritmetica che ho rifatto |
| **[INFERITO]** | dedotto, e dico da cosa |
| **[INCERTO]** | fonti in contrasto |
| **[NON VERIFICATO]** | non ottenuto |

🔴 **Questo file NON sostituisce la F4** (`PIANO_PROP.md`): _la challenge si compra
solo dopo risposte SCRITTE del supporto_. Il 18/09 dimostra il costo di saltarla:
il muro del Lite era `[MAI VERIFICATO]` (`ROSA_OTTOBRE_2026-09-18.md` r.347) fino
a poche ore prima della mail di breach.

---

# 2. 📊 LA TABELLA MADRE

Tutte le celle **[LETTO-VIA-SEARCH il 18/09/2026]** salvo etichetta diversa.
Prodotti censiti, per nome: **FTMO 2-Step**, **FundedNext Stellar 2-Step**,
**FundedNext Stellar Lite**, **FundingPips 2 Step Standard**, **The5ers High
Stakes**, **The5ers Hyper Growth**, **E8 Classic**. (Alpha Capital resta fuori
dall'08/09: vieta le EA che eseguono.)

## 2.1 🔴 IL MURO GIORNALIERO — e la colonna che ci ha uccisi

| prodotto | **%** | **BASE DI CALCOLO** 🔴 | **flottante?** | **breach o pausa?** | **ora reset** | **reset in ORA SERVER BCM** |
|---|---:|---|---|---|---|---|
| **FTMO 2-Step** | **5%** dell'iniziale | 🟢 **SALDO registrato alle 00:00 CE(S)T** — limite = saldo 00:00 − 5% dell'iniziale | ✅ sì: il vincolo è sull'**EQUITY** (balance + P/L aperto ± swap − commissioni) | 🔴 **breach** | 00:00 CE(S)T | **23:00** ✅ = il nostro `InpDailyResetHour=23` |
| **FundedNext Stellar 2-Step** | **5%** dell'iniziale | 🟠 **inizio giornata** (+ profitti realizzati **dello stesso giorno**) | ✅ sì | 🔴 **breach** | 00:00 server (GMT+3 con DST) | **22:00** ⚠️ |
| **FundedNext Stellar Lite** | 🔴 **4%** dell'iniziale | 🟠 **inizio giornata** (+ profitti dello stesso giorno) | ✅ sì | 🔴 **breach** | 00:00 server | **22:00** ⚠️ |
| **FundingPips 2 Step Standard** | **5%** | 🟢🟢 **il PIÙ ALTO fra saldo di apertura ed equity di apertura** | ✅ sì | 🔴 **breach** | 00:00 UTC+3 | **22:00** ⚠️ |
| **The5ers High Stakes** | **5%** ⚠️ *(vedi §6 buco 2)* | 🟢 **il PIÙ ALTO fra equity e saldo di CHIUSURA del giorno prima** | ✅ sì | 🔴 **breach**, _«immediately terminated with no possibility of recovery»_ | 00:00 server | **22:00** ⚠️ |
| **The5ers Hyper Growth** | **3%** | **giornata** (dettaglio `[NON VERIFICATO]`) | ✅ sì | 🟢🟢 **PAUSA** — conto sospeso per la giornata, **riparte il giorno dopo alle 00:00 MT5 server** | 00:00 MT5 server | **22:00** ⚠️ |
| **E8 Classic** | **4%** | 🟠 **starting balance of the day** | ✅ sì (_«Maximum Floating or Closed loss»_) | 🔴 **breach** | 00:00 server | **[INCERTO]** (fuso non dichiarato) |

**Fonti riga per riga** — FTMO: [trading-objectives](https://ftmo.com/en/trading-objectives/) ·
[academy Max Daily Loss](https://academy.ftmo.com/lesson/maximum-daily-loss/) ·
FundedNext 2-Step: [help 8019811](https://help.fundednext.com/en/articles/8019811-how-can-i-calculate-the-daily-loss-limit) ·
[help 8394569](https://help.fundednext.com/en/articles/8394569-what-are-today-s-permitted-loss-limit-and-maximum-permitted-loss-limit) ·
Lite: [help 9094072](https://help.fundednext.com/en/articles/9094072-what-rules-do-i-need-to-follow-in-the-stellar-lite-challenge) ·
FundingPips: [2 Step Standard](https://help.fundingpips.com/hc/en-us/articles/34501809112081-2-Step-Standard) ·
The5ers HS: [drawdown High Stakes](https://help.the5ers.com/what-is-the-drawdown-rule-for-high-stakes/) ·
Hyper Growth: [how does the daily pause work](https://help.the5ers.com/how-does-the-daily-pause-work/) ·
[hyper-growth](https://the5ers.com/hyper-growth/) ·
E8 Classic: [help 12041696](https://help.e8markets.com/en/articles/12041696-e8-classic).

### 🧮 LA BASE DI CALCOLO, ricostruita sul breach vero — **e torna**
La formula FundedNext letta oggi è: **limite = % FISSA dell'iniziale, misurata a
partire dall'inizio della giornata** (i profitti dei giorni PRECEDENTI **non**
allargano il limite: _«after the reset, previous day profits will no longer count
toward your daily loss limit»_).

| | valore | da dove |
|---|---:|---|
| inizio giornata 18/09 | **103.258,16** | ricavato dalla mail (`BREACH…` §2) **[VERIFICATO: aritmetica rifatta]** |
| limite = 4% × 100.000 | **4.000,00** | regola Lite **[LETTO-VIA-SEARCH]** |
| **pavimento del giorno** | **99.258,16** | 103.258,16 − 4.000 |
| equity al blocco | **99.048,73** | mail |

> ✅ **La regola letta oggi RIPRODUCE il breach al centesimo.** Non è
> un'interpretazione: è un **contro-esempio superato**. Se la base fosse stata il
> saldo iniziale (100.000), il pavimento sarebbe stato **96.000** e il conto
> sarebbe **vivo**. 🔴 **La base di calcolo vale 3.258 dollari — più della
> differenza fra un muro al 4% e uno al 5%.**

## 2.2 🧱 MURO TOTALE, obiettivo, tempo

| prodotto | **muro totale** | statico? | **il nostro p99 8,1%** ci sta? | obiettivo | giorni minimi | limite di tempo |
|---|---|---|---|---|---|---|
| **FTMO 2-Step** | **10%** dell'iniziale | ✅ **STATICO** (il 1-Step è **EOD-trailing**: prodotto diverso) | ✅ **sì**, margine **1,9 punti** | 10% F1 · 5% F2 | 4/fase | ✅ **nessuno** |
| **FundedNext Stellar 2-Step** | **10%** | ✅ statico | ✅ **sì**, margine **1,9 punti** | 8% F1 · 5% F2 | 5/fase | ✅ nessuno |
| **FundedNext Stellar Lite** | 🔴 **8%** | ✅ statico | 🔴 **NO: 8,1 > 8,0** | 8% F1 · 4% F2 | 5/fase | ✅ nessuno |
| **FundingPips 2 Step Standard** | **10%** — _«static floor; it never moves»_ | ✅ statico | ✅ **sì**, margine 1,9 | 8% F1 · 5% F2 | 3 (F1) | ✅ nessuno, ⚠️ 1 trade/30 gg |
| **The5ers High Stakes** | **10%** absolute | ✅ statico | ✅ sì | 10% F1 · 5% F2 (New HS) · 8%/5% (Classic HS) | 🔴 **3 giorni PROFITTEVOLI ≥0,5%** | ✅ nessuno, ⚠️ scade a 30 gg senza attività |
| **The5ers Hyper Growth** | 🔴 **6%** sotto l'iniziale | **[INCERTO]** — vedi §6 buco 1 | 🔴 **NO: 8,1 ≫ 6,0** | 10% (1 step) | **[NON VERIFICATO]** | **[NON VERIFICATO]** |
| **E8 Classic** | 🔴 **8%** | ✅ statico | 🔴 **NO: 8,1 > 8,0** | 4% | — | ✅ nessuno, ⚠️ 1 trade/60 gg |

Fonti: [FTMO trading-objectives](https://ftmo.com/en/trading-objectives/) ·
[FTMO Academy Maximum Loss](https://academy.ftmo.com/lesson/maximum-loss/) ·
[FundedNext help 9133001](https://help.fundednext.com/en/articles/9133001-what-is-the-profit-target-in-fundednext-stellar-lite) ·
[FundedNext help 9094074](https://help.fundednext.com/en/articles/9094074-how-many-days-will-i-get-to-complete-phases-1-2-of-the-stellar-lite-challenge) ·
[FundingPips 2 Step Standard](https://help.fundingpips.com/hc/en-us/articles/34501809112081-2-Step-Standard) ·
[The5ers general rules HS](https://the5ers.com/faqs/what-are-the-general-rules-for-the-high-stakes-program/) ·
[The5ers hyper-growth](https://the5ers.com/hyper-growth/) ·
[E8 Classic](https://help.e8markets.com/en/articles/12041696-e8-classic).

> 🔴 **Il criterio del p99 elimina TRE prodotti su sette a tavolino**, senza
> discutere di news, di EA o di prezzo: **Stellar Lite (8%)**, **E8 Classic (8%)**,
> **Hyper Growth (6%)**. Non perché siano "brutti": perché **la nostra taglia
> firmata (0,65%) è tarata su un muro del 10%**. Rientrerebbero abbassando la
> taglia — 🔴 **ed è una firma di Claudio, non una mia proposta.**

## 2.3 🤖 EA, copy, frequenza, leva

| prodotto | **EA ammessi?** | **copy** | **limiti di frequenza/ordini** | **LEVA INDICI** 🔴 | weekend/overnight |
|---|---|---|---|---:|---|
| **FTMO 2-Step Standard** | ✅ sì, gratis, _«as long as your trading is legitimate»_; tetto 400k $/strategia se software di terzi | ❌ vietato dare accesso a terzi | ❌ **oltre 2.000 richieste/giorno al server** = iperattività | **1:50** | ⚠️ da **funded**: chiusura prima del weekend e se il rollover supera 2 ore |
| **FTMO 2-Step SWING** | ✅ idem | ❌ idem | ❌ idem | 🔴 **1:15** (e **1:9** su HK50/US2000/SPN35) | ✅ **nessun vincolo, mai** |
| **FundedNext Stellar 2-Step** | ✅ sì ⚠️ **solo su MetaTrader e con EA usage fee** (add-on a pagamento) | ✅ fra conti Challenge **propri** (tetto 300k) · ❌ verso conti esterni | ❌ HFT (trade in ms-secondi) | **1:25** | ✅ consentiti |
| **FundedNext Stellar Lite** | ✅ sì _«EAs and custom indicators are allowed»_ ⚠️ stessa EA usage fee | ✅/❌ come sopra | ❌ HFT | **[NON VERIFICATO]** | **[NON VERIFICATO]** |
| **FundingPips 2 Step Standard** | ⚠️ **sì SE l'EA è NOSTRA**, con prova di proprietà (_«full automation is permitted»_); EA di terzi solo come risk manager | ❌ vietato fra utenti, gestione da terzi = chiusura | ❌ server spamming, HFT, gap trading | **1:20** in valutazione 🔴 **ma sui Master account vige la LEVA DINAMICA a scaglioni dal 16/03/2026: oltre 0,50 lotti → 1:5** | ✅ in valutazione · 🔴 **weekend VIETATO sui Master** |
| **The5ers High Stakes** | ⚠️ sì, ma sono ristretti _«third-party EAs you don't own the source code for»_ e 🔴 **_«bulk or simultaneous automated orders»_** | ❌ copy da conti esterni | ❌ eccesso di richieste al server da EA | **fino a 1:100** (asset non dettagliato) | **[NON VERIFICATO]** |
| **E8 Classic** | ✅ _«you can use any EA»_ purché **non condivisa** fra utenti | ❌ stessa strategia su più utenti | ❌ vedi Trading Policies | **[NON VERIFICATO]** | **[NON VERIFICATO]** |

Fonti: [FTMO FAQ strategie](https://ftmo.com/en/faq/which-instruments-can-i-trade-and-what-strategies-am-i-allowed-to-use/) ·
[FTMO Forbidden Practices](https://ftmo.com/en/forbidden-trading-practices/) ·
[FTMO account specifications](https://ftmo.com/en/faq/what-are-the-account-specifications/) ·
[FTMO Swing](https://ftmo.com/en/faq/ftmo-swing-account-type/) ·
[FundedNext help 8020763](https://help.fundednext.com/en/articles/8020763-is-ea-allowed-in-fundednext) ·
[FundedNext leverage](https://help.fundednext.com/en/articles/8019669-what-is-the-leverage-of-the-trading-account) ·
[FundingPips Trading Conduct](https://help.fundingpips.com/hc/en-us/articles/34505029138449-Trading-Conduct-and-Security-Standards) ·
[FundingPips 2 Step Standard](https://help.fundingpips.com/hc/en-us/articles/34501809112081-2-Step-Standard) ·
[The5ers EA FAQ](https://help.the5ers.com/can-i-use-an-ea-expert-advisor-can-i-set-a-stealth-mode-stop-loss/) ·
[The5ers Prohibited Practices](https://www.the5ers.com/faqs/prohibited-trading-practices/) ·
[E8 Classic](https://help.e8markets.com/en/articles/12041696-e8-classic).

### 🧮 LA LEVA SUGLI INDICI: la domanda aperta di casa ha finalmente un numero — **ed è 1:15, non 1:25**

La domanda di casa era *«1:15 o 1:25?»*. **Sono tutte e due, su prop diverse.** E il
conto del margine dice che **la differenza non è cosmetica**.

**Formula** (assunzioni dichiarate: 1 punto indice = 1 $ per lotto, contract size 1
— ⚠️ **le specifiche del broker della prop non le ho lette: [NON VERIFICATO]**):
`margine = rischio€ × (prezzo / stop_in_punti) / leva`

Con rischio **0,65% di 100k = 650 $** e i **nostri stop MISURATI**
(`ANCORA_ADR_FLOTTA_INDICI_2026-09-18.md`: `U30USD` **123,8 pt** `[MISURATO, n=446]`,
`NASUSD` **83,2 pt** `[INFERITO]`) e prezzi indice di settembre 2026 `[INFERITO]`:

| leva indici | margine 1 pos. U30USD | margine 1 pos. NASUSD | **5 posizioni** (= cap C1 3,25%) | su un conto da 100k |
|---|---:|---:|---:|---|
| **1:50** — FTMO Standard | 4.831 | 3.281 | **~20.000 $** | ✅ comodo |
| **1:25** — FundedNext Stellar 2-Step | 9.662 | 6.562 | **~40.000 $** | ✅ ok |
| **1:20** — FundingPips (valutazione) | 12.077 | 8.203 | **~50.000 $** | 🟠 stretto |
| **1:15** — 🔴 **FTMO SWING** | 16.103 | 10.937 | **~67.000 $** | 🔴 **67% del conto impegnato a margine** |
| **1:10** — FundedNext Stellar 1-Step | 24.154 | 16.406 | **~100.000 $** | 🔴 **impossibile** |
| **1:5** — 🔴 FundingPips Master, oltre 0,50 lotti | 48.308 | 32.812 | **~200.000 $** | 🔴 **impossibile** |

> ## 🔴 QUESTO RIBALTA MEZZA RACCOMANDAZIONE DELL'08/09
> L'08/09 il conto **FTMO 2-Step SWING** era la prima scelta, **con la leva
> dichiarata `[NON VERIFICATO]`**. Oggi il numero c'è: **1:15 sugli indici**, e con
> i nostri stop stretti il portafoglio pieno impegna **~67% del conto a margine**.
> Non è una violazione di regolamento — è un **rischio di stop-out per margine**
> che non avevamo in conto. 👉 **Il conto Swing resta l'unico che azzera il
> problema news+weekend, ma NON è più gratis: costa margine.**
> 🔴 **E la scelta Standard-vs-Swing è quindi una scelta di RISCHIO: firma di Claudio.**

---

# 3. 📰 LA TABELLA NEWS — e la risposta alla domanda decisiva

## 3.0 I TIPI sono QUATTRO, non tre

Claudio ne aveva elencati tre. **Ne ho trovato un quarto e va separato**, perché
non squalifica: **tassa**.

| tipo | cosa vieta | chi lo usa |
|---|---|---|
| **T1 — finestra d'APERTURA/CHIUSURA** | vietato aprire *o chiudere* entro ±X min (esecuzione di pendenti, SL e TP inclusi) | **FTMO** (funded), **The5ers**, **E8** |
| **T2 — divieto di TENERE** attraverso la notizia | vietato avere posizione aperta sull'evento | ❌ **nessuno dei censiti**: FTMO, FundedNext, The5ers, FundingPips (valutazione) dichiarano tutti che **tenere è permesso** |
| **T3 — libero in valutazione, vincolato da FUNDED** | la regola compare solo sul conto finanziato | **FTMO** (Standard), **FundingPips** (Master), **FundedNext**, **E8** (SimFI) |
| **T4 — 💰 penale ECONOMICA, non breach** | il trade è lecito, ma il **profitto** viene decurtato o non conta | **FundedNext** (40% del profitto) · **FundingPips** (profitto dedotto) · **The5ers** (profitto dedotto, «soft breach») |

## 3.1 La tabella

| prop | **tipo** | **finestra esatta** | **quali notizie / calendario** | **vale in valutazione?** | **vale da funded?** | **`ABTG_PostNews` (entra a news+45′) è ammesso?** |
|---|---|---|---|---|---|---|
| **FTMO — conto SWING** | 🟢 **nessuna** | — | — | ❌ no | ❌ **no: _«no restrictions on trading during news releases»_** | ✅✅ **SÌ, senza finestra da rispettare** |
| **FTMO — conto Standard** | **T1 + T3** | **−2 min → +2 min**, e vieta anche di **CHIUDERE**, **incluse le esecuzioni di pendenti, SL e TP** | «selected news announcements»: PIL, inflazione, lavoro (NFP). Calendario: FTMO News Indicator | ❌ **NO** — _«do not apply during the Evaluation Process … regardless of the account type»_ | ✅ **sì** | ✅ **sì per la lettera della regola** (entriamo 45′ dopo) ⚠️ **ma vedi la trappola T-FTMO in §5** |
| **FundedNext** (2-Step, Lite, 1-Step) | **T4 + T3** | **−5 min → +5 min** (finestra da 10′) | «listed high-impact news» sul simbolo colpito | ❌ **no: news trading consentito in TUTTE le challenge** | ✅ sì: **solo il 40% del profitto conta, il 100% della perdita sì** | ✅ **SÌ** — e in **valutazione senza nessuna penale** |
| **The5ers** (High Stakes) | 🔴 **T1 + divieto di STRATEGIA** | **−2 min → +2 min** sull'esecuzione ordini; **tenere aperto è permesso** | high-impact | ✅ **sì** | ✅ sì | 🔴 **NO per la clausola di strategia**: _«bracketing strategy … opening pending orders around high-impact news by opening buy and sell stops close to the price»_ è **pratica proibita per nome** |
| **FundingPips** | 🔴 **divieto di STRATEGIA + T1/T4 sul Master** | Master: **−5 → +5 min** (notizie) · **−10 min dall'inizio a +10 min dalla fine** per i **DISCORSI** | calendario **FundingPips** sulla dashboard (fonte ufficiale dichiarata) | ⚠️ **nessun vincolo sul TENERE**, 🔴 **ma _«purposely trading news in both evaluation and master phase is prohibited and will lead to account closure»_** | ✅ sì | 🔴 **NO** — e la clausola sui **discorsi** colpisce esattamente la conferenza stampa BCE, che dura ~1 ora: la finestra copre tutta la nostra ora d'azione |
| **E8** | **T1**, ma **dipende dal prodotto** | **−5 min → +5 min** | high-impact | 🟢 **no su E8 Classic fasi 1 e 2**, no su E8 Zero/Signature/Pro | dipende dal prodotto | 🟠 **[INCERTO]**: i prodotti dicono «nessuna restrizione», la Trading Policy vieta per nome _«straddles, strangles, capitalizing on the initial surge following news releases»_ |

Fonti: [FTMO Can I trade news](https://ftmo.com/en/faq/can-i-trade-news/) ·
[FTMO Swing](https://ftmo.com/en/faq/ftmo-swing-account-type/) ·
[FundedNext help 10701615 (Lite)](https://help.fundednext.com/en/articles/10701615-is-news-trading-allowed-in-the-stellar-litechallenge-and-fundednext-account) ·
[FundedNext help 10701447](https://help.fundednext.com/en/articles/10701447-is-news-trading-allowed-at-fundednext) ·
[The5ers is news trading allowed HS](https://help.the5ers.com/is-news-trading-allowed-in-the-high-stakes-program/) ·
[The5ers Prohibited Practices](https://www.the5ers.com/faqs/prohibited-trading-practices/) ·
[FundingPips News Trading & Weekend Holding](https://help.fundingpips.com/hc/en-us/articles/34504137479441-News-Trading-Weekend-Holding) ·
[E8 Can I trade news](https://help.e8markets.com/en/articles/9185497-can-i-trade-news) ·
[E8 Trading Policies](https://help.e8markets.com/en/articles/6929927-trading-policies-and-prohibited-trading-strategies).

## 3.2 🔴 LA RISPOSTA ALLA DOMANDA DECISIVA

> ### ❓ *«Un EA che entra DOPO la notizia, a finestra chiusa, è ammesso?»*
>
> # ✅ SÌ — ma solo dove la regola è scritta in MINUTI. Dove è scritta in INTENZIONI, no.

**Il nostro dato di fatto**, letto nel sorgente e nel contratto della sedia
(`ABTG_PostNews.mq5`, `CONTRATTO_POSTNEWS_ECB_771201_2026-09-10.md`) **[VERIFICATO]**:
- ora d'azione **14:00 server = 15:00 italiane**; la decisione BCE è alle **14:15
  italiane** → **entriamo 45 minuti dopo l'annuncio**;
- **fuori da ogni finestra censita**: ±2 min (FTMO/The5ers), ±5 min
  (FundedNext/E8), ±5/±10 min (FundingPips).

**Quindi, prop per prop:**

| | verdetto | perché, in una riga |
|---|---|---|
| ✅ **FTMO Swing** | **compatibile senza condizioni** | nessuna finestra esiste, in nessuna fase |
| ✅ **FundedNext** (qualunque Stellar) | **compatibile**, e **in valutazione zero penali** | ±5 min: siamo a +45 min. Da funded solo la penale T4, e **fuori finestra non si applica** |
| ✅ **FTMO Standard** | **compatibile in valutazione** (nessuna regola news), ⚠️ **da funded** vale il ±2 min | il rischio non è l'ingresso: è che un **pendente ancora vivo** scatti dentro la finestra di **un'altra** notizia (§5) |
| 🟠 **E8 Classic** | **[INCERTO]** | il prodotto dice «nessuna restrizione in fase 1 e 2», la policy generale vieta gli «straddle» per nome. **Contraddizione non risolta** |
| 🔴 **The5ers** | **NON compatibile** | il **bracketing** (buy stop + sell stop attorno al prezzo su notizia high-impact) è **vietato per nome**, e la nostra forma è quella |
| 🔴 **FundingPips** | **NON compatibile** | _«purposely trading news … is prohibited and will lead to account closure»_, **in tutte e due le fasi**; e i **discorsi** hanno una finestra che copre l'intera conferenza BCE |

> 🔴 **E va detto chiaro: la nostra forma È un bracket.** BUY STOP a max+3 pip e
> SELL STOP a min−3 pip, OCO, su un giorno di conferenza stampa. **L'unica
> differenza dal bracketing vietato è QUANDO**: loro lo descrivono *prima* della
> notizia, noi lo mettiamo **45 minuti dopo**. 👉 **È una differenza vera e
> difendibile, ma è una differenza che deve dirla LORO per iscritto, non noi.**
> Nessun regolamento letto oggi distingue esplicitamente il bracket *pre-news* da
> quello *post-news*.

---

# 4. 🥇 LA CLASSIFICA — motivata in numeri

⚖️ **Come è costruita** (i criteri sono dichiarati prima dei risultati):
1. **il muro TOTALE deve reggere il nostro p99 8,1%** a taglia 0,65% → elimina chi sta sotto il 10% statico;
2. **il muro GIORNALIERO**, valore **e** base di calcolo, contro la **peggior giornata misurata −2,06%** (R51);
3. **gli EA devono essere ammessi** senza clausole che colpiscono *molte sedie simultanee*;
4. **il margine** deve reggere 5 posizioni su indici (cap C1 3,25%);
5. **il post-news** deve essere compatibile per COSTRUZIONE (finestra, non intenzione).

## 🥇 1° — **FTMO Challenge 2-Step, 100k**

| criterio | numero |
|---|---|
| muro totale | **10% STATICO** → p99 8,1% con **1,9 punti** di margine ✅ |
| muro giornaliero | **5%**, base **SALDO alle 00:00 CE(S)T**. Peggior giornata misurata **2,06%** = **41% del muro**, margine **2,94 punti** ✅ |
| ora di reset | **23:00 BCM = il nostro `InpDailyResetHour=23` già firmato**. 🥇 **È l'unica prop censita per cui il Guardian è già tarato giusto** |
| EA | ✅ ammessi, **gratis**, e le nostre sono proprietarie |
| post-news | ✅ **libero in valutazione su entrambi i conti**; **libero per sempre su Swing** |
| tempo | ✅ nessun limite |
| 🔴 il prezzo | **Standard**: da funded, news ±2 min e chiusura weekend — **due meccanismi che NON abbiamo**. **Swing**: li azzera entrambi ma porta la leva indici a **1:15 → ~67% del conto a margine** |

**Perché prima**: è **l'unico prodotto censito che non chiede di cambiare nessuno
dei tre numeri firmati di casa** (taglia 0,65%, muro 10, reset 23). Tutti gli
altri chiedono di cambiarne almeno uno.

## 🥈 2° — **FundedNext Stellar 2-Step, 100k** (🔴 **NON** il Lite)

| criterio | numero |
|---|---|
| muro totale | **10% statico** → ✅ regge il p99 |
| muro giornaliero | **5%** (🔴 **non 4%: quello è il Lite**), base inizio giornata |
| leva indici | **1:25** → 5 posizioni ≈ **40.000 $** di margine: 🟢 **il doppio più comodo di FTMO Swing** |
| post-news | ✅ **consentito in tutte le challenge, senza penali**; da funded solo la penale del 40% **e solo dentro ±5 min** |
| 🔴 i prezzi da pagare | **EA usage fee** (add-on a pagamento) · reset **22:00 BCM** ≠ il nostro 23 · **5 giorni minimi**/fase · clausola _«stesso metodo challenge e funded»_ |

**Perché secondo e non primo**: è **la prop più permissiva sulle news fra le
sette censite** e la migliore sul margine indici, ma **l'automazione si paga** e
il reset è disallineato di un'ora dal nostro Guardian.
🟢 **E va detto**: passare dal Lite allo Stellar 2-Step sposta il muro giornaliero
da **4.000** a **5.000 $** e quello totale da **8.000** a **10.000 $**. **Con i
numeri del 18/09 (perdita giornaliera 4.209) il conto sarebbe VIVO.**

## 🥉 3° — **The5ers High Stakes, 100k**

| criterio | numero |
|---|---|
| muro totale | **10% absolute statico** ✅ |
| muro giornaliero | **5%**, base **il PIÙ ALTO fra equity e saldo di chiusura del giorno prima** 🟢 (base generosa) |
| 🔴 trappole strutturali | **3 giorni PROFITTEVOLI da ≥0,5%** (con 0,65% di rischio ≈ **1R netto chiuso in giornata**, contro ~1 op/giorno per famiglia) · EA con restrizione su _«bulk or simultaneous automated orders»_ = **esattamente la nostra flotta** · 🔴 **post-news INCOMPATIBILE** (bracketing vietato per nome) |

**Perché terzo e non escluso**: sui **due muri** è a posto e la base giornaliera è
buona. **Ma non può ospitare il PostNews**, e i 3 giorni profittevoli sono un
requisito che **non controlliamo**. È la riserva se FTMO e FundedNext cadessero.

## ❌ FUORI, e il motivo in una riga ciascuno

| prodotto | perché esce |
|---|---|
| **FundedNext Stellar Lite** | 🔴 muro totale **8%** < p99 **8,1%** · daily **4%** contro un Guardian tarato 4,9 · **è il prodotto che ci ha già ucciso** |
| **E8 Classic** | 🔴 muro totale **8%** < p99 8,1% · daily **4%** · contraddizione news non risolta |
| **The5ers Hyper Growth** | 🟢 **la daily PAUSE è il meccanismo migliore che ho trovato** 🔴 ma muro **6%** contro p99 **8,1%**: rientra solo abbassando la taglia a ~**0,48%** `[INFERITO: scalatura lineare 0,65 × 6/8,1]` — **firma di Claudio, non mia** |
| **FundingPips 2 Step Standard** | 🔴 **post-news vietato per intenzione in ENTRAMBE le fasi** · leva dinamica sui Master (**oltre 0,50 lotti → 1:5**) = portafoglio indici impossibile da funded · weekend vietato sui Master. **Scende dal 2° posto dell'08/09 al fuori-lista** |
| **FTMO 1-Step** | 🔴 daily **3%** + muro totale **EOD-TRAILING** (non statico) |
| **Alpha Capital** | 🔴 _«Automated EAs that execute trades independently … are strictly prohibited»_ (dall'08/09, invariato) |

---

# 5. ⚠️ LE TRAPPOLE — la regola che ci farebbe fuori senza accorgercene

| # | prop | 🪤 la trappola | perché non la vedremmo |
|---|---|---|---|
| **T-FTMO** | FTMO Standard **funded** | Il ±2 min vieta anche di **CHIUDERE**, e _«including the execution of pending orders (such as Stop Loss or Take Profit)»_ | 🔴 **Non serve che sia l'EA a decidere**: basta che uno **SL o un TP** di una sedia qualsiasi scatti dentro la finestra di una notizia. **Non abbiamo NESSUN filtro news**, e nessuna sedia sa quando c'è un dato. È una violazione che il conto si autoinfligge |
| **T-FTMO-2** | FTMO, tutte le fasi | «Gap trading» fra le **Forbidden Trading Practices**: _«opening simulated trades when major global news, macroeconomic events … are scheduled and they might affect the relevant financial market»_ | 🔴 Letta alla lettera, **`ABTG_PostNews` apre SOLO nei giorni in cui una notizia è programmata**: è la definizione testuale del comportamento descritto. È una clausola **discrezionale**, non una soglia. 👉 **Va chiesta per iscritto prima di comprare** |
| **T-FN** | FundedNext | _«Vietato passare la challenge con EA e poi operare a mano»_ (e viceversa) | Claudio ha **appena operato a mano** su un conto FundedNext. Se la challenge la passano gli EA, **il conto funded non si tocca a mano** — nemmeno per chiudere una posizione «al volo» |
| **T-FN-2** | FundedNext | **EA usage fee** come add-on | Un conto comprato senza l'add-on **è un conto su cui gli EA non sono attivi**. Si scopre dopo aver pagato |
| **T-5ERS** | The5ers | **«bulk or simultaneous automated orders»** fra i pattern ristretti | La nostra flotta apre **più sedie insieme sullo stesso minuto d'apertura** (DAX 08:00, Dow 14:30 server). È **esattamente** la forma descritta |
| **T-FP** | FundingPips | **leva dinamica a scaglioni** sui Master: oltre 0,50 lotti → **1:5** | Si scopre **dopo aver passato due fasi**, quando il portafoglio indici non entra più nel margine |
| **T-FP-2** | FundingPips | finestra dei **DISCORSI**: da 10 min prima dell'inizio a 10 min dopo la **fine** | Una conferenza stampa BCE dura **~1 ora**: la finestra copre **tutta** la nostra ora d'azione (15:00 IT). Non è un buco di 10 minuti, è un buco di 80 |
| **T-TUTTE** | tutte tranne FTMO | **reset a 22:00 BCM**, il nostro Guardian a **23:00** | 🔴 In quell'ora c'è **la chiusura di New York (22:00 BCM)**. Una perdita fatta fra le 22 e le 23 finisce **nel giorno dopo per noi e nel giorno prima per loro** |
| **T-CAMBIO-ORA** | tutte | il **25/10/2026** l'Italia passa a CET; molti broker seguono il DST americano (**1/11**) | Una **settimana** in cui il reset è sfasato di un'ora. La challenge di ottobre **attraversa quella notte** |

---

# 6. 🛡️ COSA IL NOSTRO GUARDIAN **NON** SA REPLICARE — il lavoro, prima della spesa

Letto oggi in `mql5/Experts/ABTG_Guardian.mq5` e nei tre preset **[VERIFICATO]**.

## 🟢 Buone notizie prima
- 🟢 **`InpDailyBaseline` ESISTE GIÀ** (r.147: `0=EQUITA' . 1=SALDO (FTMO) . 2=MAX(saldo,equita)`).
  La proposta **P1 dell'08/09 è stata implementata**. **Non è un lavoro: è una riga di preset.**
- 🟢 Il limite giornaliero è già calcolato **come % dell'iniziale** (r.738
  `dailyLimit = InpDailyLossPct/100.0*gStart`): **stessa struttura di FTMO e FundedNext** ✅
- 🟢 La **pausa morbida** (`InpDailyPausePct`) è già la forma della «daily pause» di Hyper Growth ✅

## 🔴 I buchi veri

| # | buco | quanto costa | che lavoro è |
|---|---|---|---|
| **G1** | 🔴 **`InpDailyBaseline` non è valorizzato in NESSUNO dei tre preset** (`ABTG_Guardian_FTMO_2Step.set`, `..._REALE.set`, `..._50504263_779001_VIVO.set`) → resta a **0 = EQUITÀ**. Su FTMO (base = SALDO) e su FundingPips/The5ers (base = MAX) **il nostro pavimento sta SOTTO il loro** quando c'è flottante negativo al reset | con **−0,8% di flottante** al reset su 100k: **800 $** di scarto, tutto nella direzione sbagliata (noi più permissivi della prop) | ✏️ **una riga di preset**, zero codice. 🔴 Ma il valore giusto **dipende dalla prop scelta** → si decide dopo la scelta |
| **G2** | 🔴 **Il buffer prima del muro è tarato su un muro al 5%.** `InpDailyLossPct=4.9` su muro 5,0 = **0,1 punti**. Su un muro al **4%** (Lite, E8 Classic) il 4,9 è **SOPRA il muro**: la protezione è invertita | il 18/09, misurato: l'emergenza sarebbe scattata **900 $ dopo** la morte del conto (`IL_GUARDIAN_CONTRO_LA_REGOLA…`) | il **meccanismo** c'è; il **numero** è un parametro di rischio = **firma di Claudio**. La forma proposta: *emergenza = muro − buffer*, col buffer dichiarato (le fonti esterne del 13/09 usano **0,5-1,0 punti**, noi **0,1**) |
| **G3** | 🔴 **`InpDailyResetHour=23` è giusto SOLO per FTMO.** Su FundedNext, The5ers, FundingPips va **22** | contiamo una giornata diversa dalla loro, e nella fascia sbagliata c'è la chiusura di NY | ✏️ **una riga di preset** |
| **G4** | 🔴 **Nessun filtro NEWS, da nessuna parte.** Il Guardian non sa cosa sia una notizia e nessuna sedia lo sa | su **FTMO Standard funded** basta uno SL che scatta dentro ±2 min per violare. Non è un rischio di perdita: è un rischio di **squalifica** | 🔴 **meccanismo che NON esiste**. O si scrive, o si sceglie un prodotto senza finestra (**FTMO Swing**, **FundedNext in valutazione**) |
| **G5** | 🟠 **Il nostro «trailing» non è il loro.** `InpDDMode=1` misura **dal picco di equity tick-per-tick**; FTMO 1-Step, E8 Signature e FundedNext FNL usano un **EOD trailing** (dal saldo di **fine giornata**) | il nostro è **più stretto** → ci fermerebbe prima, quindi **è sicuro ma non è la stessa regola**: non possiamo dire «sappiamo replicarlo» | 🔴 **Nessun lavoro se si resta su prop a muro STATICO** (proposta P2 dell'08/09, mai firmata) |
| **G6** | 🔴 **Nessun meccanismo di chiusura WEEKEND** | serve su FTMO Standard funded e su **tutti i Master FundingPips** | meccanismo assente. Si aggira scegliendo **FTMO Swing** o **FundedNext** |
| **G7** | 🟠 **Nessuna misura di CONSISTENZA** (Best Day 50% di FTMO; consistency di FundedNext) | non fa fallire la challenge: **blocca il payout** | una riga nella pagella serale |

> 🔴 **Il punto che vale più di tutti**: dei sette buchi, **G1 e G3 si chiudono con
> DUE RIGHE DI PRESET** e sono quelli che il 18/09 avrebbero contato. **Non sono un
> progetto: sono un pomeriggio.** G2 è un numero e quindi una firma. G4 e G6 sono
> gli unici veri lavori di codice — **ed entrambi si evitano scegliendo il
> prodotto giusto invece di scriverli.**

---

# 7. 🕳️ BUCHI DICHIARATI

1. 🔴 **Nessuna pagina ufficiale aperta da me.** 8 domini su 8 in `403` al CONNECT.
   Tutto è **[LETTO-VIA-SEARCH]**. Verificabile da Claudio in un browser, **ma non
   è una lettura diretta e non è un impegno della prop verso di noi.**
2. ⚠️ **Buco 1 — The5ers Hyper Growth, statico o trailing? [INCERTO] e conta.**
   La stessa fonte contiene due cose incompatibili: la frase _«uses a trailing
   drawdown model»_ e l'esempio numerico _«stopout 6% below the INITIAL account
   size … se il conto sale a 10.300 il drawdown massimo è ora 900»_ — che descrive
   un **pavimento FISSO a 9.400**, cioè **statico**. 👉 Il nostro
   `REGOLAMENTI_PROP_2026-09-08.md` lo dà per **trailing**. **Non lo risolvo: lo
   dichiaro.** Se fosse statico, il prodotto cambia natura (soft-daily + muro fisso)
   e va rivalutato.
3. ⚠️ **Buco 2 — The5ers High Stakes, daily 5% o 3%? [INCERTO].**
   L'help center dice **5%** ([drawdown High Stakes](https://help.the5ers.com/what-is-the-drawdown-rule-for-high-stakes/));
   un articolo comparativo dello stesso sito dice _«High Stakes and Pro Growth apply
   a 3% and 5% daily loss respectively»_. **Ho messo 5% perché viene dall'help
   center**, ma è da confermare.
4. ⚠️ **Buco 3 — E8, news: contraddizione non risolta.** Le pagine prodotto dicono
   «nessuna restrizione in fase 1 e 2»; la Trading Policy vieta per nome
   _«straddles, strangles, capitalizing on the initial surge following news»_.
5. **Il conto margine del §2.3 è [INFERITO]**: assume **1 $ per punto indice per
   lotto** e **contract size 1**, e usa prezzi indice di settembre 2026 stimati.
   🔴 **Le specifiche contrattuali dei broker delle prop NON le ho lette.** I
   rapporti fra le leve (1:50 vs 1:15 vs 1:5) restano validi anche se le cifre
   assolute si spostano, perché il rapporto non dipende dalle assunzioni.
6. **[NON VERIFICATO] oggi**: prezzi 100k di tutti i prodotti (l'08/09 FTMO era
   540 € listino / 439 € promo, FundedNext 549 $ — **non riverificati oggi**);
   leva e weekend di Stellar Lite; leva di E8 e The5ers per asset class; limite di
   tempo e muro totale di Hyper Growth; fuso server di E8.
7. **Termini e condizioni completi: mai letti.** Solo pagine regole/FAQ/help.
8. **Non ho verificato** se il conto FTMO Swing sia acquistabile anche in **fase di
   Verification** o solo alla configurazione iniziale (letto: si sceglie
   all'ordine del 2-Step).

---

# 8. ✍️ LE TRE DOMANDE DA MANDARE AL SUPPORTO — prima di qualunque spesa

Si aggiungono a `report/DOMANDE_SUPPORTO_PROP.md` (pronte dal 13/08, **mai
inviate**). 🔴 **Non sono una proposta di acquisto: sono le domande che rendono
possibile una decisione.**

```
D1  (FTMO)  Un EA che piazza BUY STOP e SELL STOP su un livello calcolato
            45 MINUTI DOPO un annuncio macro, con i pendenti che restano
            vivi fino a fine sessione, e' considerato "gap trading" ai sensi
            delle Forbidden Trading Practices?
            >> e' la trappola T-FTMO-2, ed e' l'unica che puo' squalificare
               un conto che rispetta TUTTE le soglie numeriche

D2  (FTMO)  Il Max Daily Loss usa il SALDO alle 00:00 CE(S)T o il PIU' ALTO
            fra saldo ed equity? (decide il valore di InpDailyBaseline: 1 o 2)
            >> gia' aperta dall'08/09, mai chiusa

D3  (tutte) 5 EA proprietari con magic diversi, sullo stesso conto, che
            aprono nello stesso minuto d'apertura di sessione: e' "copy
            trading", "group trading" o "bulk/simultaneous automated orders"?
            >> e' la trappola T-5ERS, e vale per FTMO e FundedNext allo stesso modo
```

---

## 🧊 Nota di perimetro
**Nessun EA, preset, parametro, `.set`, grafico o sedia viva è stato toccato.**
L'unico file prodotto è questo. Nessun acquisto proposto, nessuna taglia
consigliata: **il muro totale contro il p99, la taglia del rischio e la scelta
Standard-vs-Swing sono firme di Claudio.**
