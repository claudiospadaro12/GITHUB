# 📜 REGOLAMENTI PROP — la verifica alla fonte (08/09/2026)

_Scritto dal **cacciatore di configurazioni prop** l'**08/09/2026**._
_Nasce dal **rischio n.2** di `report/PIANO_CHALLENGE_OTTOBRE.md` §5:
«la prop non e' scelta, e il regolamento non e' verificato per iscritto»._

---

# 0. 🥇 LA RIGA CHE SERVIVA PER PRIMA

> ## ❓ Esiste un limite di TEMPO su FTMO?
> # ✅ **NO. Nessun limite di tempo.**
>
> Testuale dalla pagina **Trading Objectives** di FTMO:
> _«There is no time limit within which you need to pass the Profit Target,
> the **Trading Period is indefinite**.»_
> 🔗 https://ftmo.com/en/trading-objectives/
> — **[LETTO-VIA-SEARCH il 08/09/2026]**, vedi §1 sulla classe di prova.
>
> Vincolo che resta: **minimo 4 giorni di trading** per ciascuna fase
> (🔗 https://academy.ftmo.com/lesson/minimum-trading-days/ ·
> https://ftmo.com/en/trading-objectives/).

### 👉 Conseguenza diretta sul piano
La frase del `PIANO_CHALLENGE_OTTOBRE.md` §5.3 —
_«su FTMO non c'e' limite di tempo, quindi partire il 1 o il 15 ottobre non
cambia l'esito»_ — **REGGE**. Lo slittamento di due settimane costa **zero**
sul lato regolamento. ✅ **La raccomandazione centrale del piano non cambia.**

⚠️ Ma **non e' vero per tutte**: FundingPips ed E8 hanno una **clausola di
inattivita'** (1 trade ogni 30 / 60 giorni), The5ers scade dopo **30 giorni
senza attivita'**. Il "nessun limite" e' di FTMO e FundedNext, non del settore.

---

# 1. 🚨 LA CLASSE DI PROVA — leggere PRIMA della tabella

## Controllo positivo, fatto oggi 08/09/2026

| canale | bersaglio noto | esito |
|---|---|---|
| **WebFetch su `ftmo.com`** | pagina Trading Objectives | ❌ **`EGRESS_BLOCKED` — 403 al CONNECT dal proxy aziendale** |
| **curl su ftmo.com / fundednext.com / the5ers.com / fundingpips.com / alphacapitalgroup.uk / e8markets.com / help.\*** | homepage | ❌ **tutti 403 `connect_rejected`** (registrato in `/__agentproxy/status`) |
| **WebFetch su `web.archive.org`** | snapshot | ❌ **bloccato anche l'archivio** |
| **WebFetch su `mql5.com`** | CodeBase 74553 | ✅ **funziona** (titolo corretto) — quindi il blocco e' **per dominio**, non del canale |
| **WebSearch con `allowed_domains` = domini ufficiali** | FTMO Trading Objectives | ✅ **restituisce contenuto della pagina ufficiale** |

> 🛑 **Nessuna pagina ufficiale di prop e' stata APERTA da me.** Il proxy
> dell'ambiente blocca **tutti** i domini prop, come gia' registrato il 31/08
> in `report/CONFIG_PROP_2026-08-31.md` («ftmo.com EGRESS_BLOCKED — FONTE
> NULLA»). Oggi il blocco e' **piu' esteso**: cadono anche gli help center e
> l'archivio.

### Che cosa significa l'etichetta che trovi in ogni cella

| etichetta | cosa vuol dire |
|---|---|
| **[LETTO-VIA-SEARCH]** | il motore di ricerca ha letto **la pagina ufficiale** (ricerca ristretta al dominio ufficiale) e me ne ha restituito il contenuto. **Io la pagina non l'ho aperta.** Il link e' quello ufficiale ed e' verificabile da Claudio in 30 secondi con un browser normale |
| **[INCERTO]** | fonti in contrasto, o dato non emerso |
| **[NON VERIFICATO]** | non sono riuscito a ottenerlo |

🔴 **Questo NON sostituisce la F4** (`PIANO_PROP.md`): _la challenge si compra
solo dopo **risposte scritte del supporto**_. Un documento letto di seconda
mano **non e' un impegno della prop verso di noi**. Le domande sono pronte in
`report/DOMANDE_SUPPORTO_PROP.md` dal 13/08 e **vanno inviate lo stesso**.
Questo file serve a **sapere cosa chiedere** e a **restringere il campo a
due nomi** prima di scrivere.

---

# 2. 📊 LA TABELLA COMPARATIVA — 7 righe × 6 prop

Tutte le celle: **[LETTO-VIA-SEARCH il 08/09/2026]** salvo diversa etichetta.

## 2.1 I due muri (le righe che decidono tutto)

| | **FTMO** 2-Step | **FundedNext** Stellar 2-Step | **The5ers** High Stakes | **The5ers** Hyper Growth | **FundingPips** 2 Step Standard | **Alpha Capital** | **E8 Markets** |
|---|---|---|---|---|---|---|---|
| **1. MURO TOTALE** | **10%** del saldo **iniziale** — **STATICO** ✅ | **10%** del saldo iniziale — **STATICO** ✅ (dichiarato testuale: _«The drawdown type is static»_) | **10%** dal saldo iniziale, **absolute drawdown** ✅ | 🔴 **6% TRAILING** (segue l'high-water mark) | **10%** della taglia iniziale — _«This is a **static floor; it never moves**»_ ✅ | **Alpha Pro**: statico ✅ · 🔴 **Alpha One**: **TRAILING 6%**, si blocca a initial una volta a +6% | 🔴 **E8 Signature**: **EOD Dynamic (trailing)**, si blocca a initial dopo il 1° payout · **E8 Classic**: **8%** |
| **fonte** | [trading-objectives](https://ftmo.com/en/trading-objectives/) · [academy Maximum Loss](https://academy.ftmo.com/lesson/maximum-loss/) | [help 8021076](https://help.fundednext.com/en/articles/8021076-what-rules-do-i-need-to-follow-in-the-stellar-2-step-challenge) | [help drawdown High Stakes](https://help.the5ers.com/what-is-the-drawdown-rule-for-high-stakes/) | [hyper-growth](https://the5ers.com/hyper-growth/) · [help drawdown](https://help.the5ers.com/what-is-drawdown-and-how-is-it-calculated/) | [help 2 Step Standard](https://help.fundingpips.com/hc/en-us/articles/34501809112081-2-Step-Standard) | [help Alpha One](https://help.alphacapitalgroup.uk/en/articles/10097421-alpha-one) · [help Max Total Loss](https://help.alphacapitalgroup.uk/en/articles/6934220-what-is-the-maximum-total-loss) | [help Trailing DD](https://help.e8markets.com/en/articles/11782996-trailing-drawdown) · [help EOD Dynamic](https://help.e8markets.com/en/articles/11864596-eod-dynamic-drawdown) · [help E8 Classic](https://help.e8markets.com/en/articles/12041696-e8-classic) |
| **2. MURO GIORNALIERO** | **5%** dell'iniziale. Limite = **saldo registrato alle 00:00 CE(S)T − 5% dell'iniziale**. Include **P/L flottante, swap e commissioni**: il vincolo e' sull'**EQUITY**, e conta **il punto piu' basso toccato, anche per una frazione di secondo** | **5%** dell'iniziale (2-Step). Reset **00:00 server**. Il profitto realizzato **nella giornata stessa allarga** il limite (100k, +2.000 a mezzogiorno -> limite del giorno 7.000) | **5%**, preso dall'**equity o saldo di CHIUSURA del giorno precedente** | 🔴 (compreso nel 6% trailing) | **5%** del **valore PIU' ALTO fra saldo di apertura ed equity di apertura** del giorno. L'equity non puo' scendere di piu' del 5% di quella base **in nessun momento**, flottante incluso | **4-5%** a seconda del prodotto, su **saldo e/o equity di inizio giornata** | **3%** (E8 One) dell'iniziale; livello fissato ogni giorno alle **00:00 server**; violazione se **equity O saldo** scendono sotto |
| **fonte** | [trading-objectives](https://ftmo.com/en/trading-objectives/) · [academy Max Daily Loss](https://academy.ftmo.com/lesson/maximum-daily-loss/) | [help 8019811](https://help.fundednext.com/en/articles/8019811-how-can-i-calculate-the-daily-loss-limit) · [help 8019914](https://help.fundednext.com/en/articles/8019914-what-is-the-maximum-daily-loss-limit) | [help drawdown High Stakes](https://help.the5ers.com/what-is-the-drawdown-rule-for-high-stakes/) | [hyper-growth](https://the5ers.com/hyper-growth/) | [help 2 Step Standard](https://help.fundingpips.com/hc/en-us/articles/34501809112081-2-Step-Standard) | [help Daily Risk Limits](https://help.alphacapitalgroup.uk/en/articles/6934210-what-are-the-daily-risk-limits-and-how-do-they-work) | [help Daily Drawdown](https://help.e8markets.com/en/articles/11769446-daily-drawdown) |
| **⏰ ORA DI RESET (dichiarata)** | **00:00 CE(S)T** (ora di Praga = **ora italiana**) | **00:00 server**: **GMT+3** con DST attiva, **GMT+2** senza | **00:00 UTC+3** | n/d | **00:00 Platform Time (UTC+3)** | **00:00 GMT+3** (apertura candela giornaliera, broker time) | **00:00 server** — quale fuso: **[INCERTO]** |
| **fonte** | [trading-objectives](https://ftmo.com/en/trading-objectives/) · [Trading Update 5 Mar 2026](https://ftmo.com/en/blog/trading-updates/trading-update-5-mar-2026/) | [help 8394309](https://help.fundednext.com/en/articles/8394309-when-does-the-daily-loss-limit-reset-with-fundednext-cfd) · [help 8019672 server time](https://help.fundednext.com/en/articles/8019672-what-is-fundednext-s-server-time) | [help drawdown High Stakes](https://help.the5ers.com/what-is-the-drawdown-rule-for-high-stakes/) | — | [Trading Conduct](https://help.fundingpips.com/hc/en-us/articles/34505029138449-Trading-Conduct-and-Security-Standards) · [help 2 Step Standard](https://help.fundingpips.com/hc/en-us/articles/34501809112081-2-Step-Standard) | [help Daily Risk Limits](https://help.alphacapitalgroup.uk/en/articles/6934210-what-are-the-daily-risk-limits-and-how-do-they-work) | [help Daily Drawdown](https://help.e8markets.com/en/articles/11769446-daily-drawdown) |
| **⏰ RESET in ORA SERVER BCM** _(ott. 2026, prima del 25/10 — vedi §3.4)_ | **23:00** ✅ = esattamente il nostro `InpDailyResetHour=23` | **22:00** ⚠️ | **22:00** ⚠️ | — | **22:00** ⚠️ | **22:00** ⚠️ | **[INCERTO]** |

## 2.2 Obiettivo, tempo, automazione, costo

| | **FTMO** 2-Step | **FundedNext** Stellar 2-Step | **The5ers** High Stakes | **FundingPips** 2 Step Standard | **Alpha Capital** | **E8 Markets** |
|---|---|---|---|---|---|---|
| **3. OBIETTIVO PROFITTO** | **10%** fase 1 · **5%** fase 2 (_«in Verification the Profit Target is always reduced to 50%»_) | **8%** fase 1 · **5%** fase 2 | **10%** fase 1 · **5%** fase 2 | **8%** fase 1 · **5%** fase 2 | funded a target 0%; fasi secondo il prodotto (**Alpha Pro 8%/10%**) | **6%** (E8 One / Signature) · **4%** (E8 Classic) |
| **GIORNI MINIMI** | **4 giorni** per fase | **5 giorni** distinti per fase, min. 1 trade/giorno | **3 giorni PROFITTEVOLI** per step (giorno profittevole = **≥0,5% dell'iniziale** da posizioni chiuse) | **3 giorni** in fase 1 | **Alpha One**: 1 giorno · **Alpha Pro**: 3 giorni per fase | n/d |
| **fonte** | [trading-objectives](https://ftmo.com/en/trading-objectives/) · [academy Profit Target](https://academy.ftmo.com/lesson/profit-target/) | [help 8021076](https://help.fundednext.com/en/articles/8021076-what-rules-do-i-need-to-follow-in-the-stellar-2-step-challenge) | [help drawdown](https://help.the5ers.com/what-is-the-drawdown-rule-for-high-stakes/) · [high-stakes](https://the5ers.com/high-stakes/) | [help 2 Step Standard](https://help.fundingpips.com/hc/en-us/articles/34501809112081-2-Step-Standard) | [help Alpha One](https://help.alphacapitalgroup.uk/en/articles/10097421-alpha-one) · [help Alpha Pro](https://help.alphacapitalgroup.uk/en/articles/8420429-alpha-pro-8-10) | [help E8 One](https://help.e8markets.com/en/articles/11775980-e8-one) |
| **4. 🕐 LIMITE DI TEMPO** | ✅ **NESSUNO** — _«Trading Period is indefinite»_ | ✅ **NESSUNO** | ✅ **NESSUNO** (_«unlimited time»_), ⚠️ ma **scadenza a 30 giorni consecutivi senza attivita'**, contati **dalla registrazione** | ✅ **NESSUNO**, ⚠️ ma serve **almeno 1 trade ogni 30 giorni** | ⚠️ **[NON VERIFICATO]** — non emerso dalle pagine ufficiali raggiunte | ✅ **NESSUNO** (E8 One), ⚠️ ma **1 trade aperto e chiuso ogni 60 giorni** |
| **fonte** | [trading-objectives](https://ftmo.com/en/trading-objectives/) | [help 8021076](https://help.fundednext.com/en/articles/8021076-what-rules-do-i-need-to-follow-in-the-stellar-2-step-challenge) | [2-step-challenge](https://the5ers.com/2-step-challenge/) · [challenge-programs](https://the5ers.com/challenge-programs-bootcamp-high-stakes-hyper-growth-explained/) | [help 2 Step Standard](https://help.fundingpips.com/hc/en-us/articles/34501809112081-2-Step-Standard) | — | [help E8 One](https://help.e8markets.com/en/articles/11775980-e8-one) |
| **5a. 🤖 EA AMMESSI** | ✅ **SI**, testuale: _«Automated trading with Expert Advisors (EAs) is allowed as long as your trading is legitimate... and does not resemble forbidden practices»_. ⚠️ Se usi software di terzi, la **stessa** EA non deve girare su altri trader: tetto di **400.000 $ per cliente o per strategia** | ✅ **SI**, MT4/MT5, ⚠️ **con una EA usage fee** (add-on a pagamento). Ogni EA deve avere **strategia distinta**; tetto **300.000 $ per strategia**; **vietate le EA che usano Telegram/WhatsApp** | ✅ **SI** («EAs are permitted across programs») | ⚠️ **SI, ma con distinzione decisiva**: EA di **terzi** ammesse **solo come trade/risk manager**; _«If the EA is **your own, developed by you**, **full automation is permitted** with proof of ownership»_ | 🔴 **NO per noi.** Testuale: _«Automated EAs that execute trades independently, without human oversight, are **strictly prohibited** and will not be approved under any circumstances»_. Ammesse **solo EA di risk-management pre-approvate** (invio dell'EX5 al supporto) | ✅ **SI** («any EA»), purche' la stessa strategia non sia usata da piu' utenti; **una strategia per utente** |
| **fonte** | [FAQ strategie](https://ftmo.com/en/faq/which-instruments-can-i-trade-and-what-strategies-am-i-allowed-to-use/) · [Forbidden Trading Practices](https://ftmo.com/en/forbidden-trading-practices/) | [help 8020763 Is EA allowed](https://help.fundednext.com/en/articles/8020763-is-ea-allowed-in-fundednext) · [help 8020351 prohibited](https://help.fundednext.com/en/articles/8020351-what-are-the-restricted-prohibited-trading-strategies) | [FAQ EA](https://the5ers.com/faqs/can-i-use-an-ea-expert-advisor-can-i-set-a-stealth-mode-stop-loss/) | [Trading Conduct](https://help.fundingpips.com/hc/en-us/articles/34505029138449-Trading-Conduct-and-Security-Standards) | [help 6934236 Can I use an EA](https://help.alphacapitalgroup.uk/en/articles/6934236-can-i-use-an-expert-advisor-ea) · [help 6934275 prohibited](https://help.alphacapitalgroup.uk/en/articles/6934275-what-are-prohibited-trading-strategies) | [Trading Policies](https://help.e8markets.com/en/articles/6929927-trading-policies-and-prohibited-trading-strategies) |
| **5b. COPY TRADING** | ❌ **Vietato dare accesso a terzi** o far eseguire trade da terzi in coordinamento | ✅ fra **conti Challenge propri** (tetto 300k), ❌ **vietato** fra FundedNext Account e qualunque altro conto | n/d | ❌ **Vietato** fra utenti diversi e la gestione conto da terzi -> **chiusura del conto** | ❌ **"No Group Trading"**: stessa EA + trade identici fra piu' trader = violazione | ❌ stessa strategia su piu' utenti |
| **5c. HFT / iperattivita'** | ❌ vietata l'**iperattivita'**: **oltre 2.000 richieste al server al giorno** su singoli trade/pendenti | ❌ HFT vietato (trade in **millisecondi-secondi**) | ❌ vietate EA di **scalping in rollover** e **bid-ask arbitrage**; vietato l'eccesso di richieste al server | ❌ HFT, gap trading, latency arbitrage, **server spamming** | ❌ HFT, latency arbitrage | ❌ vedi Trading Policies |
| **5d. NEWS TRADING** | ⚠️ **Solo conto Standard**: vietato **aprire O chiudere** trade da **−2 min a +2 min** dalla notizia selezionata. ✅ **Conto SWING: nessuna restrizione** | ✅ **Consentito** | ⚠️ ristretto entro **2 minuti** dalle notizie ad alto impatto | ✅ **Consentito**, ⚠️ ma i trade aperti **meno di 5 ore prima** della notizia **non contano il profitto** se chiusi nella finestra di **10 minuti** | ⚠️ **finestra 5 minuti** (Alpha One; e su Alpha Pro allo stadio Qualified Analyst) | n/d |
| **5e. WEEKEND / OVERNIGHT** | ⚠️ **Standard**: nessun vincolo **durante la valutazione**; da **FTMO Trader** in poi va **chiuso prima del weekend** e se il rollover dura **oltre 2 ore**. ✅ **SWING: nessun vincolo, mai** | ✅ **Consentito** su Challenge, FundedNext Account, competizioni e trial (⚠️ **NON** su Express-Consistency) | n/d | ✅ **Consentito** | ✅ su **Alpha Swing** | n/d |
| **fonte 5b-5e** | [Forbidden Trading Practices](https://ftmo.com/en/forbidden-trading-practices/) · [Can I trade news?](https://ftmo.com/en/faq/can-i-trade-news/) · [FAQ overnight/weekend](https://ftmo.com/en/faq/do-i-have-to-close-my-positions-overnight-or-before-the-weekend/) · [FTMO Swing](https://ftmo.com/en/faq/ftmo-swing-account-type/) | [help 8019805 copy trading](https://help.fundednext.com/en/articles/8019805-what-is-the-copy-trading-rule-at-fundednext) · [help 8917879 overnight/weekend](https://help.fundednext.com/en/articles/8917879-can-i-hold-my-trades-overnight-and-over-weekend-on-fundednext-cfd) | [Prohibited Trading Practices](https://www.the5ers.com/faqs/prohibited-trading-practices/) | [Trading Conduct](https://help.fundingpips.com/hc/en-us/articles/34505029138449-Trading-Conduct-and-Security-Standards) · [help 2 Step Standard](https://help.fundingpips.com/hc/en-us/articles/34501809112081-2-Step-Standard) | [help prohibited](https://help.alphacapitalgroup.uk/en/articles/6934275-what-are-prohibited-trading-strategies) · [Alpha Swing](https://alphacapitalgroup.uk/posts/alpha-capital-swing-account-explained-rules-conditions-and-who-it-is-for) | [Trading Policies](https://help.e8markets.com/en/articles/6929927-trading-policies-and-prohibited-trading-strategies) |
| **6. 💶 COSTO 100k** | **540 €** listino, **439 €** in promozione al momento della lettura. **Fee unica** che copre entrambe le fasi | **549 $**. Add-on: swap-free **+10%** (604 $), reward 95% lifetime **+30%** (713,70 $), on-demand **+5%** | **[NON VERIFICATO]** per la taglia 100k. La linea High Stakes e' pubblicizzata «da **39 $**» (taglie piccole) | **[NON VERIFICATO]** — taglie disponibili 5k/10k/25k/50k/**100k** | **[NON VERIFICATO]** | **[NON VERIFICATO]** |
| **RIMBORSO** | ✅ **100% della fee** restituito **col primo prelievo** dal conto FTMO | ✅ **Refundable Fee** col **primo Performance Reward** (150% con add-on) | n/d | n/d | n/d | n/d |
| **fonte** | [pricelist](https://ftmo.com/en/pricelist/) · [2-step-challenge](https://ftmo.com/en/2-step-challenge/) · [FAQ fee ricorrenti](https://ftmo.com/en/faq/are-the-fees-recurrent/) | [help 8592191 add-on](https://help.fundednext.com/en/articles/8592191-how-does-the-add-on-feature-work-with-the-fundednext-new-challenge-purchase) · [help 9430506 refundable](https://help.fundednext.com/en/articles/9430506-when-do-i-get-the-refundable-fee-in-the-stellar-2-step-model) | [high-stakes](https://the5ers.com/high-stakes/) | [help 2 Step Standard](https://help.fundingpips.com/hc/en-us/articles/34501809112081-2-Step-Standard) | — | — |
| **7. 🕰️ FUSO SERVER / BROKER** | Server **MetaTrader GMT+3**; il muro giornaliero e' pero' misurato in **ora di Praga (CE(S)T)** -> lo scarto server↔regola e' **2 ore d'inverno, 1 ora d'estate**. Leva **1:100** (Standard) · **1:30** (Swing) | Server **GMT+3** con DST, **GMT+2** senza | **UTC+3** | **UTC+3** | **GMT+3** | server time, **[INCERTO]** |
| **fonte** | [Trading Update 5 Mar 2026](https://ftmo.com/en/blog/trading-updates/trading-update-5-mar-2026/) · [Trading Update 26 Mar 2026](https://ftmo.com/en/blog/trading-updates/trading-update-26-mar-2026/) · [FTMO Swing](https://ftmo.com/en/faq/ftmo-swing-account-type/) | [help 8019672](https://help.fundednext.com/en/articles/8019672-what-is-fundednext-s-server-time) | [help drawdown](https://help.the5ers.com/what-is-the-drawdown-rule-for-high-stakes/) | [Trading Conduct](https://help.fundingpips.com/hc/en-us/articles/34505029138449-Trading-Conduct-and-Security-Standards) | [help Daily Risk Limits](https://help.alphacapitalgroup.uk/en/articles/6934210-what-are-the-daily-risk-limits-and-how-do-they-work) | [help Daily Drawdown](https://help.e8markets.com/en/articles/11769446-daily-drawdown) |

## 2.3 ➕ La riga che non era nella lista, e che morde

| | regola | fonte |
|---|---|---|
| **FTMO — Best Day Rule 50%** | Serve **per passare la 1-Step** E **per essere idonei a un Reward su conto FTMO**: il **giorno migliore non puo' valere piu' del 50% del profitto dei giorni positivi**. **Non e' una violazione**: si continua a operare finche' il rapporto rientra. Nuovo giorno alle **00:00 CE(S)T** | [trading-objectives](https://ftmo.com/en/trading-objectives/) · [FAQ consistency](https://ftmo.com/en/faq/do-you-have-any-consistency-rules/) |
| **FTMO — nessun'altra consistenza** | _«there are no additional consistency requirements for your trading»_ oltre ai Trading Objectives | [FAQ consistency](https://ftmo.com/en/faq/do-you-have-any-consistency-rules/) |
| **FTMO — 1-Step, da NON scegliere** | Muro giornaliero **3%** (non 5%) + Best Day 50% obbligatoria per passare | [trading-objectives](https://ftmo.com/en/trading-objectives/) · [1-step](https://ftmo.com/en/1-step-challenge/) |
| **FundedNext — consistenza di metodo** | Vietato passare la challenge con EA e poi operare a mano sul conto funded (o viceversa) | [help 8020351](https://help.fundednext.com/en/articles/8020351-what-are-the-restricted-prohibited-trading-strategies) |

---

# 3. 🔴 DOVE LE NOSTRE ASSUNZIONI NON REGGONO

## 3.1 🥇 IL BUCO PIU' GRAVE: la nostra baseline giornaliera e' l'EQUITY, la loro e' il SALDO

**Cosa fa il nostro Guardian** (`mql5/Experts/ABTG_Guardian.mq5`):
- riga 428 e 529: `GlobalVariableSet(GV_DAYSTART, eq);` — commento nel sorgente:
  _«v1.12: baseline giornaliera = EQUITA' a inizio giornata (non bilancio)»_
- riga 544: `dailyLimit = InpDailyLossPct/100.0 * gStart;`
- riga 548: `dailyLoss = dayStart - eq;`

Quindi il **pavimento del nostro Guardian** e':
`EQUITY alle 23:00 − 5% del saldo iniziale`.

**Cosa fanno le prop censite:**

| prop | baseline dichiarata |
|---|---|
| FTMO | **saldo** registrato alle 00:00 CE(S)T |
| FundingPips | il **PIU' ALTO** fra saldo ed equity di apertura |
| The5ers High Stakes | equity **o saldo** di chiusura del giorno prima |
| Alpha Capital | saldo **e/o** equity di inizio giornata |

> ## ⚠️ IL PUNTO
> Se all'ora del reset c'e' **una posizione aperta in perdita flottante**,
> l'**equity e' PIU' BASSA del saldo**. Il nostro pavimento scende con lei;
> **il loro NO**.
> **Conseguenza: il Guardian ci lascia scendere SOTTO il muro della prop.**

**Quantificato.** 100k, posizione aperta a **−0,8%** al momento del reset:

| | baseline | pavimento |
|---|---:|---:|
| **FTMO** (saldo) | 100.000 | **95.000** |
| **nostro Guardian** (equity) | 99.200 | **94.200** |

🔴 **800 € di scarto = la challenge e' gia' violata quando il nostro Guardian
e' ancora "in pausa morbida".** E il verso e' sempre lo stesso: **con
flottante negativo al reset siamo PIU' PERMISSIVI della prop**. (Con flottante
positivo siamo piu' prudenti: innocuo.)

**⚡ Quanto ci riguarda davvero:** riguarda **solo le sedie che tengono
posizioni attraverso le 23:00 server**. La flotta ha **sedie swing** (per
`ROTTA_PROP.md`: Supertrend 225JPY H2, SupRev NAS H1, EMA200 SPX H4,
SuperWave DOW H1 — tutte multi-day). **Non e' un caso teorico.**

**Quale numero va rifatto:** nessuna Monte Carlo. Va cambiato il **codice**:
la baseline giornaliera deve diventare **max(saldo, equity)** al reset, o
almeno il **saldo**, con un input che lo dichiari. Ed e' un cambio di **una
riga per due punti** (428 e 529) — ma tocca il Guardian, quindi passa
dall'imbuto con l'autotest (`InpAutotest`) prima.

---

## 3.2 🥈 IL TRAILING: quali prop lo usano, e cosa cade se ne scegliamo una

> ### 🔴 Prop censite che usano il DRAWDOWN TRAILING:
> 1. **The5ers Hyper Growth** — 6% trailing sull'high-water mark
> 2. **Alpha Capital "Alpha One"** — 6% trailing, si blocca a initial a +6%
> 3. **E8 Signature / EOD Dynamic** — trailing di fine giornata, si blocca dopo il 1° payout
>
> ### ✅ Prop censite a muro TOTALE STATICO:
> **FTMO 2-Step · FundedNext Stellar 2-Step · The5ers High Stakes ·
> FundingPips 2 Step Standard · Alpha Pro**

**Se si scegliesse una prop trailing, questi numeri del progetto CADONO tutti:**

| numero | dove sta | cosa succede col trailing |
|---|---|---|
| **p99 = 8,1%** a rischio 0,65% su 27 serie | `report/METRO_PROP.md` | ❌ **non vale**: e' calcolato su **DD statico dal deposito** |
| **p50 5,74% / p95 9,89% / p99 12,47%** a rischio 1% | `report/METRO_PROP.md` | ❌ **non valgono** |
| **p99 trailing = 12,05% > 10%** | `PIANO_CHALLENGE_OTTOBRE.md` §5.2 | 🔴 gia' agli atti: **la taglia di casa non reggerebbe** |
| **DD OOS per sedia** (0,86% – 6,7%) | `report/ROTTA_PROP.md` | ❌ misurati come **DD di equity dal picco della curva del singolo EA**, non come restituzione dal picco del **conto** con N motori accesi |
| **muri firmati del Guardian** (pausa 4,0 / emergenza 4,9 e 9,9) | firma 18/08 | ⚠️ i **numeri** restano ma vanno riletti su un muro che si **muove**: 9,9 su 10 statico e' un buffer di 0,1 punti; su 6 trailing e' **oltre il muro** |

✅ **Il MECCANISMO ce l'abbiamo gia'**: `InpDDMode = 1` (riga 100 del Guardian,
_«1=TRAILING (dal picco equity)»_, riga 549 `totalDD = gPeak - eq`).
🔴 **Quello che NON abbiamo e' la MISURA.** Il Guardian saprebbe difendersi;
**noi non sapremmo con che probabilita' il portafoglio tocca quel muro.**

> ### 👉 Proposta di vincolo (da firmare, non applicata da me)
> **Si compra SOLO una prop a muro totale STATICO.** Cosi' l'unica delle tre
> assunzioni di casa mai verificata resta fuori dal perimetro. Se un giorno si
> volesse una prop trailing, **prima** si rifa' la Monte Carlo su DD trailing.

---

## 3.3 🥉 L'ORA DEL RESET: `InpDailyResetHour = 23` e' giusto **SOLO per FTMO**

Conversione in **ora server BCM** (`CLAUDE.md`: BCM = ora italiana − 1;
ottobre 2026 prima del 25/10, Italia = CEST = UTC+2, quindi **BCM = UTC+1**):

| prop | reset dichiarato | in UTC | **in ora server BCM** | il nostro `23` |
|---|---|---|---:|---|
| **FTMO** | 00:00 CE(S)T (= mezzanotte italiana) | 22:00 | **23:00** | ✅ **combacia** |
| FundedNext | 00:00 GMT+3 | 21:00 | **22:00** | ❌ **1 ora di scarto** |
| The5ers | 00:00 UTC+3 | 21:00 | **22:00** | ❌ **1 ora di scarto** |
| FundingPips | 00:00 UTC+3 | 21:00 | **22:00** | ❌ **1 ora di scarto** |
| Alpha Capital | 00:00 GMT+3 | 21:00 | **22:00** | ❌ **1 ora di scarto** |

> ✅ **Conferma preziosa:** la firma del 18/08 che mette `InpDailyResetHour=23`
> e' **esatta per FTMO** — e lo e' per una ragione strutturale, non per caso:
> FTMO misura il muro giornaliero in **ora di Praga**, che e' **la stessa ora
> italiana**, e BCM sta un'ora indietro all'ora italiana. (Conferma indipendente
> gia' agli atti: il vendor E5 di `CONFIG_PROP_2026-08-31.md` usa reset 23:00.)
>
> ❌ **Ma su qualunque altra prop censita quel 23 e' SBAGLIATO di un'ora.**
> Un'ora di scarto significa che **contiamo una giornata diversa dalla loro**:
> una perdita fatta fra le 22:00 e le 23:00 BCM finisce nel giorno *dopo* per
> noi e nel giorno *prima* per loro — e in quella fascia c'e' **la chiusura
> di New York** (17:00 EDT = 21:00 UTC = **22:00 BCM**). 🔴 **La sedia
> `Dow Apertura` opera 15:30-19:30 IT: chiude prima. Ma le sedie swing sono
> aperte.**

### 3.4 ⚠️ E il 25 OTTOBRE 2026 sposta la sveglia

Il **25/10/2026** (ultima domenica di ottobre — **[INFERITO dal calendario]**,
non da fonte web) l'Italia passa da CEST a CET. **La challenge parte prima e
attraversa quella notte.**
- FTMO misura in ora **di Praga**: il suo reset resta **la mezzanotte italiana**.
- Il nostro `23` resta corretto **solo se BCM cambia ora nello stesso momento
  dell'Italia**. Molti broker seguono il **DST americano** (1° novembre 2026):
  in quel caso c'e' **una settimana, dal 25/10 al 1/11, in cui il nostro reset
  e' sfasato di un'ora**.
- 🧪 **Misura da mettere in calendario (costo: 2 minuti, lunedi' 26/10):**
  confrontare `TimeCurrent()` sul grafico con l'orologio di Windows sul VPS —
  esattamente il controllo lampo gia' scritto in `CLAUDE.md` §"Ora dei LOG".
  **[NON VERIFICATO]** oggi, e non e' verificabile da qui.

---

## 3.5 Gli altri scostamenti, in breve

| # | assunzione di casa | regolamento vero | cosa va rifatto |
|---|---|---|---|
| **A** | «obiettivo **+10%**» | ✅ giusto per **FTMO fase 1** (10%) e The5ers. ⚠️ **FundedNext e FundingPips chiedono 8%** | nulla da rifare: e' **piu' facile**, non piu' difficile |
| **B** | «muro giornaliero **5%**» | ✅ FTMO/FundedNext/The5ers/FundingPips 2-Step. ❌ **FTMO 1-Step = 3%**, **E8 One = 3%**, Alpha 4-5% | non scegliere prodotti **1-Step**: il nostro `InpDailyLossPct=5.0` andrebbe a 3.0 e la pausa 4,0 sarebbe **sopra il muro** |
| **C** | «giorni minimi: non ci pensiamo» | FTMO **4 giorni**/fase · FundedNext **5** · The5ers **3 PROFITTEVOLI da ≥0,5%** | 🔴 **The5ers e' incompatibile col nostro profilo**: 0,5% di profitto chiuso in un giorno, con rischio 0,65%/trade, chiede **~1R netto in una sola giornata** e la nostra frequenza per famiglia e' **~1 op/giorno**. Vincolo strutturale, non di configurazione |
| **D** | il **filtro NEWS non ce l'abbiamo** (buco N di `CONFIG_PROP_2026-08-31.md`) | FTMO **Standard**: vietato aprire **O CHIUDERE** ±2 min. **Un trailing o un breakeven che esegue li' dentro e' una violazione** | ✅ **si aggira scegliendo il conto SWING** (nessuna restrizione news). Costo: leva **1:30** invece di 1:100 |
| **E** | **nessuna chiusura weekend** nel Guardian | FTMO **Standard funded**: chiusura obbligatoria prima del weekend e se il rollover supera 2 ore | ✅ **si aggira col conto SWING**. Su Standard servirebbe un meccanismo che **non abbiamo** |
| **F** | nessuna nozione di **consistenza** | FTMO **Best Day 50%** per incassare il Reward | 🟡 **buco nuovo**: nessun EA e nessun report di casa misura «giorno migliore / somma dei giorni positivi». Non fa fallire la challenge, **blocca il payout**. Serve una riga nella pagella serale |
| **G** | «gli EA sono ammessi» | ✅ FTMO, FundedNext (a pagamento), The5ers, E8, FundingPips (**se sono NOSTRE**, con prova di proprieta') · 🔴 **Alpha Capital: VIETATE le EA che eseguono** | **Alpha Capital esce dalla lista.** ✅ E la nostra situazione e' quella buona: **gli EA li scriviamo noi**, quindi passiamo anche il filtro FundingPips |
| **H** | «cap C1 3,25% = 5 SL vivi» | nessuna prop lo vieta | ⚠️ resta il **rischio n.1 del piano** (moltiplicatore ignoto): il regolamento non c'entra, ma il muro giornaliero **5%** e' quello che il 6,50% reale sfonderebbe |
| **I** | tetto per **cluster 3,0%** | nessuna prop lo impone | 🔴 promemoria: **firmato ma NON ATTIVO** (`InpMaxClusterRiskPct = 0` alla riga 119). Va detto ogni volta |

---

# 4. 🏁 RACCOMANDAZIONE — quale prop, e perche'

## 🥇 PRIMA SCELTA: **FTMO — Challenge 2-Step, 100k, conto SWING**

| motivo | il fatto |
|---|---|
| 1️⃣ **Nessun limite di tempo** | _«Trading Period is indefinite»_ — lo slittamento del piano costa **zero** |
| 2️⃣ **Tutti e due i muri STATICI e ai nostri numeri** | 10% totale dall'iniziale, 5% giornaliero. **Le Monte Carlo di casa restano valide** (p99 ~8,1% a 0,65% contro un muro di 10%). E' l'unica prop che non ci obbliga a rifare le misure |
| 3️⃣ **Reset alla mezzanotte italiana** | **= 23:00 BCM**, esattamente `InpDailyResetHour=23` gia' firmato. **Nessuna riprogrammazione del Guardian** |
| 4️⃣ **Il conto SWING chiude da solo i due buchi che abbiamo** | ✅ niente restrizione news (**il nostro filtro news non esiste**) · ✅ niente chiusura obbligatoria del weekend (**non ce l'abbiamo**). Su un conto Standard entrambi sarebbero **meccanismi da scrivere in tre settimane** |
| 5️⃣ **EA ammesse per iscritto** | e la nostra e' proprietaria: nessun problema con la clausola «stessa EA su piu' clienti» |
| 6️⃣ **Costo noto e rimborsabile** | 540 € (439 € in promo), **100% rimborsati col primo prelievo** |

**Il prezzo da pagare, dichiarato:**
- ⚠️ **Leva 1:30** sul conto Swing invece di 1:100 → **da verificare che il
  margine regga 5 sedie contemporanee su indici**. Non e' un problema di
  rischio, e' un problema di **margine**: **[NON VERIFICATO]**, e va calcolato
  prima di comprare.
- ⚠️ **Best Day Rule 50%** per incassare: non blocca la challenge, **blocca il
  primo payout**. Da mettere nella pagella.
- ⚠️ **Obiettivo 10%** in fase 1 (contro l'8% di FundedNext/FundingPips).

## 🥈 SECONDA SCELTA: **FundingPips — 2 Step Standard, 100k**

Perche' e' la riserva giusta:
- ✅ muro totale **10% statico dichiarato testuale** (_«static floor; it never moves»_)
- ✅ muro giornaliero **5% sul PIU' ALTO fra saldo ed equity** → **piu' generoso
  di FTMO** e, soprattutto, 🔴 **elimina il buco 3.1** (loro prendono il massimo,
  noi prendiamo l'equity: col loro criterio il nostro pavimento non e' mai sopra il loro)
- ✅ **piena automazione ammessa se l'EA e' nostra**, con prova di proprieta'
- ✅ overnight e weekend liberi, news consentite, obiettivo **8%** (piu' basso)
- ❌ **reset 00:00 UTC+3 = 22:00 BCM** → `InpDailyResetHour` da **23 a 22**
- ❌ regola di **inattivita' 30 giorni**
- ❌ prezzo 100k **[NON VERIFICATO]**

## ❌ FUORI, e il motivo in una riga

| prop | perche' esce |
|---|---|
| **Alpha Capital** | 🔴 _«Automated EAs that execute trades independently are strictly prohibited»_. **Il nostro intero progetto e' quello che loro vietano.** Uscita netta |
| **The5ers High Stakes** | **3 giorni PROFITTEVOLI da ≥0,5%** per step: con 0,65% di rischio e ~1 op/giorno per famiglia e' un requisito **strutturale** che non controlliamo |
| **The5ers Hyper Growth** | 🔴 **trailing 6%** |
| **E8 Signature / One** | 🔴 **EOD dynamic (trailing)**, e daily **3%** su E8 One |
| **FTMO 1-Step** | daily **3%** + Best Day 50% obbligatoria per passare |
| **FundedNext Stellar 2-Step** | 🟡 **non esce, e' terza**: muri statici 5/10 e nessun limite di tempo (bene), ma **EA a pagamento**, reset **22:00 BCM**, **5 giorni** minimi e la clausola «stesso metodo challenge/funded» |

---

# 5. ✍️ COSA PROPONGO (nessuna di queste e' applicata — decide Claudio)

```
PROPOSTA   P1 - baseline giornaliera del Guardian: da EQUITY a max(SALDO, EQUITY)
DOVE       ABTG_Guardian.mq5 righe 428 e 529 (GlobalVariableSet(GV_DAYSTART, eq))
           + input nuovo InpDayBaseMode (0=equity com'e' oggi, 1=max(saldo,equity))
FONTE      §3.1 - FTMO usa il SALDO alle 00:00 CE(S)T, FundingPips e The5ers
           il PIU' ALTO fra saldo ed equity. Noi usiamo l'equity: col flottante
           negativo al reset il nostro pavimento sta SOTTO il loro
COSTO      ~1 ora di sviluppo + 1 giro di InpAutotest + 1 giro sul demo 50503392
RISCHIO    con flottante POSITIVO al reset il nuovo criterio e' piu' permissivo
           dell'attuale: va scelto max(), non "saldo" secco, per non allentare
PRIORITA'  ALTA - e' l'unico buco che ci fa violare una regola CREDENDO di essere a posto
```

```
PROPOSTA   P2 - vincolo di acquisto: SOLO prop a muro totale STATICO
DOVE       decisione, non codice (da aggiungere alla F4 di PIANO_PROP.md)
FONTE      §3.2 - p99 trailing 12,05% > muro 10% (PIANO_CHALLENGE_OTTOBRE §5.2)
COSTO      zero
RISCHIO    esclude prodotti con fee piu' bassa (Hyper Growth, E8, Alpha One)
```

```
PROPOSTA   P3 - misurare l'ora BCM il 26/10/2026 (dopo il cambio ora europeo)
DOVE       procedura manuale sul VPS, conto 50504263 (cartella "... -V3")
FONTE      §3.4 - se BCM segue il DST americano (1/11) c'e' una settimana
           in cui InpDailyResetHour=23 e' sfasato di un'ora rispetto a FTMO
COSTO      2 minuti: TimeCurrent() sul grafico vs orologio di Windows
RISCHIO    nessuno: e' sola lettura
```

```
PROPOSTA   P4 - riga "Best Day" nella pagella serale
DOVE       script della pagella (scarica_pagella.ps1 / report serale)
FONTE      §2.3 - FTMO: il giorno migliore non puo' superare il 50% della somma
           dei giorni positivi, o il Reward non si incassa
COSTO      ~1 ora. Non tocca nessun EA
RISCHIO    nessuno: e' una misura, non un'azione
```

```
PROPOSTA   P5 - inviare le domande al supporto FTMO (le 3 che restano aperte)
DOVE       report/DOMANDE_SUPPORTO_PROP.md, pronte dal 13/08, mai inviate
FONTE      F4: si compra solo dopo risposta SCRITTA. Questo dossier NON la sostituisce
LE TRE     (a) confermate che 5 EA proprietari diversi, con magic diversi, sullo
           stesso conto, non sono "copy trading" ne' "group trading"?
           (b) sul conto SWING 100k, con leva 1:30, quale margine serve per
               5 posizioni simultanee su DAX/US30/NAS100 a 0,65% di rischio?
           (c) il Max Daily Loss usa il SALDO alle 00:00 CE(S)T o il PIU' ALTO
               fra saldo ed equity? (la risposta cambia la riga di codice di P1)
COSTO      un'email. E' firma di Claudio: e' la sua identita' verso la prop
PRIORITA'  MASSIMA - e' l'unica voce con un tempo di risposta che non controlliamo
```

---

# 6. 🕳️ COSA NON HO POTUTO VEDERE — dichiarato

1. **Nessuna pagina ufficiale aperta da me.** Tutti i domini prop sono
   `EGRESS_BLOCKED` dal proxy (403 al CONNECT). Anche `web.archive.org`.
   Tutto il contenuto arriva dal motore di ricerca ristretto ai domini
   ufficiali: **[LETTO-VIA-SEARCH]**, non **[VERIFICATO]**.
2. **Termini e condizioni completi**: mai letti. Solo pagine regole/FAQ/help.
3. **Prezzi 100k di The5ers, FundingPips, Alpha Capital, E8**: **[NON VERIFICATO]**.
4. **Limite di tempo di Alpha Capital**: **[NON VERIFICATO]** (esce comunque per gli EA).
5. **Fuso del server E8**: **[INCERTO]** ("server time" senza offset).
6. **Un contrasto non risolto su FundingPips**: una pagina help dice daily
   **5%** (2 Step Standard), un'altra **3%** — probabilmente prodotti diversi
   (Standard vs Pro/Zero). **Da chiedere se si va su FundingPips.**
7. **Un contrasto su FTMO**: la pagina Trading Objectives parla di **«saldo
   registrato alle 00:00 CE(S)T»**, materiale FTMO piu' vecchio parlava di
   «saldo o equity, il maggiore». **[INCERTO]** → e' la domanda (c) di P5.
   ⚠️ **Il buco di §3.1 esiste con entrambe le letture**, perche' in tutte e
   due la loro baseline e' **≥ saldo** e la nostra e' l'equity.
8. **Margine reale con leva 1:30** sul conto Swing FTMO per 5 sedie su indici:
   **[NON VERIFICATO]**, e non e' calcolabile senza le specifiche del loro broker.

---

## 🧊 Nota di perimetro
**Nessun EA, preset, parametro, grafico o sedia viva e' stato toccato per
scrivere questo file.** L'unico file prodotto e' questo. Tutte le proposte
del §5 sono **proposte**: nessuna e' stata applicata.
