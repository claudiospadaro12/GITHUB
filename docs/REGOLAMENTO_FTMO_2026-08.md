# 🔍 REGOLAMENTO FTMO — DOSSIER UFFICIALE (aggiornato 13/08/2026)

> Indagine condotta SOLO su fonti ufficiali FTMO (ftmo.com, academy.ftmo.com, ftmo.com/au).
> ⚠️ NOTA TECNICA: il fetch diretto di ftmo.com (e sottodomini + web.archive.org) era BLOCCATO
> dal proxy di rete; i contenuti sono stati estratti tramite ricerche mirate che leggono le
> pagine ufficiali. Le citazioni vanno ri-verificate a occhio sulle URL indicate prima dell'acquisto.
> Contesto: valutazione FTMO per portafoglio EA su 100k, rischio 0,65%/trade.

---

## 1) 🏗️ Struttura: Challenge → Verification → FTMO Account

**FATTO ACCERTATO.** Oggi esistono DUE percorsi:
- **2-Step (classico)**: FTMO Challenge → Verification → FTMO Account.
  - Profit Target: **10%** Challenge, **5%** Verification ("In the Verification step, the Profit Target is always reduced to 50% compared to the first step").
  - **Minimum Trading Days: 4** per fase ("The Minimum Trading Days rule requires the trader to achieve at least 4 Trading Days. A Trading Day is any day – measured from 00:00:00 to 23:59:59 CE(S)T – during which at least one position is opened").
  - **Nessun limite di tempo**: "There is no time limit within which you need to pass the Profit Target, the Trading Period is indefinite."
- **1-Step (nuovo, introdotto nel 2025)**: una sola fase → FTMO Account con 90% dal primo payout, MA con Best Day Rule (v. §7) e Max Loss trailing; **niente opzione Swing** → per noi poco adatto.

URL: https://ftmo.com/en/trading-objectives/ · https://ftmo.com/en/2-step-challenge/ · https://ftmo.com/en/1-step-challenge/ · https://academy.ftmo.com/lesson/minimum-trading-days/ · https://ftmo.com/en/faq/how-ftmo-challenge-1-step-and-2-step-differs/

## 2) 📉 Max Daily Loss 5% e Max Loss 10%

**FATTO ACCERTATO.**
- **MDL 5% — su EQUITY, non balance**: "The Maximum Daily Loss rule establishes a limit below which your account **equity** (Balance + Open Positions P/L ± Swaps – Commissions) cannot drop." Limite ricalcolato **ogni giorno alle 00:00 CE(S)T** = mezzanotte ITALIANA: "recalculated daily at 00:00 CE(S)T as the difference between the account balance recorded at 00:00 CE(S)T of the current day and the Maximum Daily Loss Amount (5% of the Initial Simulated Capital)". Include floating P/L, commissioni e swap.
  - ⚠️ Il riferimento è il BALANCE delle 00:00, non max(balance,equity): se a mezzanotte hai floating loss aperti, il limite del giorno parte comunque dal balance.
- **Max Loss 10% (2-Step) — STATICO**: "The 2-Step FTMO Challenge uses a **Static** Maximum Loss type… equity must not drop below 90% of the initial account balance at any given time." (1-Step invece: End-of-Day trailing, si aggiorna alle 23:59:59 CE(S)T solo verso l'alto.)

URL: https://academy.ftmo.com/lesson/maximum-daily-loss/ · https://academy.ftmo.com/lesson/maximum-loss/ · https://ftmo.com/en/trading-objectives/

## 3) 🤖 EA / Algoritmi

**FATTO ACCERTATO — permessi, nessun obbligo di dichiarazione trovato.**
- "As long as your trading is legitimate…, conforms to the real market conditions, and does not resemble forbidden practices, FTMO has no reasons for limiting or restricting your trading strategy, whether it's discretionary trading, algorithmic trading, EAs, etc."
- Limite tecnico: vietati EA che rendono l'account "hyperactive" con **>2.000 richieste server/giorno** su ordini/pending.
- ⚠️ **EA commerciali di terzi**: "If you use an EA from a third party, there might be other traders already using the same EA and therefore exactly the same strategy… you potentially run a risk of being denied the FTMO Account if you exceed the maximum capital allocation rule." → I NOSTRI EA proprietari sono la situazione ideale.
- NON TROVATO: obbligo di dichiarare l'uso di EA. (Da confermare col supporto.)

URL: https://ftmo.com/en/faq/which-instruments-can-i-trade-and-what-strategies-am-i-allowed-to-use/ · https://ftmo.com/en/forbidden-trading-practices/

## 4) 📰 NEWS TRADING — Standard vs Swing

**FATTO ACCERTATO — punto DURISSIMO per noi (niente filtro news negli EA).**
- Conto **Standard, solo su FTMO Account (funded)**: "On the targeted instruments, it is not permitted to open or close any trades, **including pending orders (such as Stop Loss or Take Profit)**, within a time window starting **2 minutes before and ending 2 minutes after** the release of selected news announcements." E soprattutto: "**if a Stop Loss or Take Profit is triggered within the restricted time window, this will also be considered a breach** of the FTMO Account Agreement."
- La restrizione NON vale in Challenge/Verification: "Restrictions… apply only once you start trading on an FTMO Account. They do not apply during the Evaluation Process."
- Vale solo sugli strumenti "targeted" dall'evento: "during the US NFP release, you may trade EURGBP or AUDNZD; however, you must not open or close trades on USDJPY or GBPUSD". Eventi marcati "Restricted event" nel calendario FTMO (dati Forex Factory): NFP, CPI, GDP, tassi/banche centrali ecc.
- Posizioni aperte >2 min prima si possono TENERE: "You are allowed to hold open positions on the targeted instruments if they were opened more than 2 minutes before the restricted event."
- **Conto SWING: nessuna restrizione news**: "The FTMO Swing account type does not have any restrictions on trading during news releases."

URL: https://ftmo.com/en/faq/can-i-trade-news/ · https://ftmo.com/en/faq/ftmo-swing-account-type/ · https://ftmo.com/en/calendar/

## 5) 🌙 OVERNIGHT / WEEKEND / GAP alla riapertura

**FATTO ACCERTATO.**
- **Evaluation (Challenge+Verification): overnight e weekend LIBERI** per tutti: "While trading during the Evaluation Process, the restriction does not apply regardless of the account type."
- **FTMO Account Standard**: "you are required to close your positions shortly before the markets close for the weekend **or if the rollover (market break) lasts longer than 2 hours**."
  - ⚠️⚠️ La clausola "break >2 ore" COLPISCE ANCHE L'OVERNIGHT INFRASETTIMANALE sul DAX: indici europei ~01:00–22:00 London → pausa notturna di ~3 ore → su Standard funded il DAX NON si tiene overnight. Indici USA (pausa 1h) e oro (pausa 1h) ok overnight ma NON nel weekend.
- **FTMO Account SWING: zero restrizioni** overnight/weekend. "Available exclusively within the FTMO Challenge: **2-Step**" → per noi obbligatorio 2-Step + Swing.
- **APRIRE alla riapertura della domenica**: NESSUN divieto esplicito trovato di aprire trade alla riapertura. MA la pagina Forbidden Trading Practices vieta il "**gap trading**" così definito: "performing **gap trading** by opening simulated trades (i) **when major global news, macroeconomic events, or corporate reports or earnings are scheduled**…, or (ii) **two hours or less before a relevant financial market is closed for at least two hours**." → Letteralmente vieta aprire PRIMA della chiusura, non DOPO la riapertura; però FTMO etichetta il gap trading come "high-risk practice… due to increased volatility". **AMBIGUO per la nostra famiglia gap-fill: DA CHIEDERE PER ISCRITTO.** Nota: la clausola sta tra le Forbidden Practices (valgono sempre, anche su Swing e in Challenge).

URL: https://ftmo.com/en/faq/do-i-have-to-close-my-positions-overnight/ · https://ftmo.com/en/faq/ftmo-swing-account-type/ · https://ftmo.com/en/forbidden-trading-practices/

## 6) 🚫 FORBIDDEN TRADING PRACTICES (pagina dedicata)

**FATTO ACCERTATO** — pagina ufficiale: https://ftmo.com/en/forbidden-trading-practices/ (+ FAQ "What is 'Trading according to a real market?'"). Sintesi delle voci con citazioni raccolte:
1. Sfruttare errori dei servizi: "strategies that exploit errors in the Services, such as errors in the display of prices or **delays in their updates**, or an external or **slow data feed**" (= latency/da-feed arbitrage).
2. Trade "for manipulative purposes, for example by **simultaneously entering into opposite positions**" fra più conti (hedge-arbitrage cross-account) — eccezione: posizioni opposte sullo STESSO conto.
3. Terzi: vietato far tradare terzi sul proprio conto o coordinarsi con terzi ("account management", copy di gruppo).
4. **>2.000 server request/giorno** da EA (HFT/tick scalping di fatto vietati per questa via).
5. "strategies that **artificially distribute profit across multiple days** without proportionally distributing market risk, such as hedging or holding opposing positions on the same or highly correlated instruments."
6. **Gap trading** (definizione in §5).
7. "trades that contradict how trading is actually performed in the financial markets" + condotte che possono causare danno: "**overleveraging, overexposure, one-sided bets, or account rolling**."
8. Risk-management "market standard": vietate "substantially larger or smaller position sizes compared to other trades, or repeated trading activity that results in higher risk per trade / cumulative exposure in specific symbols" → il nostro rischio FISSO 0,65%/trade è perfetto.
- Conseguenze: "removal of simulated trades from history, restricted access…, disqualification…, forfeiture of any potential Rewards, or termination of all agreements."
- Grid/martingala: NON nominati esplicitamente nelle citazioni raccolte (ricadono in overleveraging/risk-management) — NON TROVATO divieto testuale, da verificare sulla pagina.

## 7) 📏 Consistency rules

**FATTO ACCERTATO — sul 2-Step NON esistono consistency rule dure**: "Your trading consistency is primarily evaluated based on the Trading Objectives. However, provided you maintain sustainable risk management practices, there are no additional consistency requirements." Il **Discipline Score** è SOLO informativo: "does not affect the Evaluation phase or your trading on an FTMO Account in any way."
⚠️ MA sul **1-Step** c'è la **Best Day Rule 50%**: "your Best Day does not represent more than 50% of your Positive Days' Profit" — vale per passare la fase E per l'eleggibilità dei Reward sul funded; non è breach, blocca solo il payout finché non riequilibri. Altro motivo per stare sul 2-Step.
URL: https://ftmo.com/en/faq/do-you-have-any-consistency-rules/ · https://ftmo.com/au/faq/how-does-the-best-day-rule-50-work-in-ftmo-challenge-1-step/

## 8) 👥 Conti multipli / replica su altre ditte

**FATTO ACCERTATO (parziale).**
- **Max capital allocation: 400.000 $ per trader O PER STRATEGIA** (pre-scaling; 200k se Aggressive): "At any given time, the total capital allocation across all accounts is limited to $400,000 per trader **or strategy**."
- "Holding multiple accounts through different registrations is not permitted. **If identically traded strategies are detected across multiple FTMO accounts** and the total fictitious capital exceeds the maximum capital allocation limit, FTMO reserves the right to suspend the affected accounts."
- Merge conti: possibile su richiesta solo se inutilizzati, stessa valuta, stesso prodotto.
- **Copy trading verso ALTRE prop firm: NON TROVATO nulla di ufficiale** (né divieto né permesso). Le regole citano solo terze parti e conti FTMO. **DA CHIEDERE PER ISCRITTO** (per altre ditte contano comunque i LORO regolamenti).
URL: https://ftmo.com/en/faq/how-many-accounts-can-i-have/ · https://ftmo.com/en/faq/can-i-combine-ftmo-accounts-from-ftmo-challenge-1-step-and-2-step/

## 9) 💰 Economics (100k, 2-Step)

**FATTO ACCERTATO.**
- **Prezzo 100k**: promo "10-Year Anniversary Deal, 19% off the $100,000 FTMO Challenge, now priced at **€439**" → listino ≈ **€540**. Fee one-time, no ricorrenti.
- **Refund**: "If you successfully pass the FTMO Challenge: 2-Step and receive your first Reward…, the paid fee is refunded with your first Reward withdrawal." (1-Step: fee NON rimborsata.)
- **Split**: **80/20**, sale a **90/10** con Scaling Plan o Premium Programme (1-Step: 90/10 subito).
- **Payout**: on-demand — "You can request a Reward claim on the **14th day or any following day after the first placed trade**"; review 1–2 giorni lavorativi, pagamento 1–2 giorni dopo l'invoice. Bonifico, Visa Direct/Mastercard Send (fino a 20k$), Skrill, crypto.
- **Scaling Plan**: "+25% every 4 months, up to **$2,000,000** (across all your FTMO Accounts)"; condizioni: "**at least 10% net profit in four consecutive monthly cycles** + **at least 2 payouts** within the 4 months; balance above initial at scale-up"; con lo scale-up split → 90/10.
URL: https://ftmo.com/en/how-it-works/ · https://ftmo.com/en/faq/how-do-i-withdraw-my-profits/ · https://ftmo.com/en/reward-growth-and-scaling-plan/

## 10) 🖥️ Piattaforme, feed, fuso server

**FATTO ACCERTATO.**
- Piattaforme: **MT4, MT5, cTrader, DXtrade** ("all trading platforms (MT5, MT4, cTrader and DXtrade) are available on FTMO").
- **Fuso server MetaTrader: GMT+2 inverno / GMT+3 estate** (i Trading Update ufficiali: "All times are expressed in MetaTrader platform time — GMT+3", con cambi al DST; cTrader/DXtrade mostrano il fuso scelto dall'utente). ⚠️ Diverso da BCM: FTMO server = ora italiana +1 (es. DAX apre 10:00 ora server FTMO), da RIMAPPARE in tutti gli .ini!
- Leva: Standard **1:100**; Swing **1:30** (forex; indici 1:15, metalli 1:9 su Swing).
- Costi: **indici ZERO commissioni** ("Trading simulated indices on the FTMO platform is completely commission-free"); forex con commissioni simulate "among the industry's lowest" (storicamente ~3$/lotto — cifra esatta sulla pagina Symbols, non confermata qui).
- **Esecuzione: SIMULATA** — "All accounts provided are demo accounts with fictitious funds and any trading is in a simulated environment only" (feed/commissioni che emulano il mercato reale; FTMO paga i reward). Confermato modello demo+payout.
URL: https://ftmo.com/en/trading-platforms/ · https://ftmo.com/en/faq/what-are-the-account-specifications/ · https://ftmo.com/en/blog/zero-commissions-on-indices/ · https://ftmo.com/en/symbols/ · https://ftmo.com/en/trading-updates/

## 11) 🆕 Novità 2025–2026

**FATTO ACCERTATO.**
- **1-Step Challenge** lanciato nel 2025 (90% dal primo reward, ML trailing EOD, MDL 3%, Best Day Rule 50%, niente Swing, fee non rimborsata).
- **FTMO ha completato l'acquisizione di OANDA** (press release ufficiale: "FTMO Completes Acquisition of OANDA from CVC") — prima prop firm a possedere un broker retail regolamentato; "OANDA Prop Trader" chiude il 31/03/2026; riapertura USA (ago 2025 via OANDA) e India (dic 2025).
- **Nessun limite di tempo** sulle Challenge (regola ormai stabile: "Trade without any time limit").
- Trading Updates settimanali ufficiali su orari/strumenti: https://ftmo.com/en/trading-updates/
URL: https://ftmo.com/en/press-release/ftmo-completes-acquisition-of-oanda-from-cvc/ · https://ftmo.com/en/blog/introducing-the-1-step-ftmo-challenge/

---

## 🚨 (a) I 4 PUNTI PIÙ PERICOLOSI PER IL NOSTRO PORTAFOGLIO

1. **🕳️ GAP-FILL ALLA RIAPERTURA DOMENICALE = ZONA GRIGIA UFFICIALE.** Il "gap trading" compare TESTUALMENTE tra le Forbidden Practices (che valgono anche su Swing e in Challenge). La definizione letterale vieta aprire ≤2h PRIMA di una chiusura ≥2h o con news maggiori in arrivo — non parla della riapertura — ma lo spirito ("high-risk practice… increased volatility") è contro di noi. SENZA risposta scritta del supporto, la famiglia gap-fill NON va caricata su FTMO.
2. **📰 NIENTE FILTRO NEWS = BOMBA sul funded Standard.** Anche uno SL/TP che scatta nella finestra ±2 min su strumento targeted è BREACH dell'Account Agreement. I nostri EA non hanno filtro news → su Standard funded è questione di tempo. Soluzione: **conto SWING** (nessuna restrizione news) oppure aggiungere filtro news a tutti gli EA.
3. **🌙 OVERNIGHT su Standard funded è vietato dove serve a noi**: chiusura obbligatoria prima del weekend E se la pausa di mercato dura >2h → il box notturno sul DAX (pausa ~3h) è fuori legge su Standard. → **Obbligatorio 2-Step + SWING** (unico percorso con Swing).
4. **👥 "$400k per trader OR STRATEGY" + replica su altre ditte.** Strategie identiche rilevate su più conti FTMO oltre il tetto = sospensione. Sul copy verso ALTRE prop firm FTMO non dice nulla di ufficiale → da chiarire per iscritto PRIMA, per non rischiare i reward.
5. (Bonus) **⏰ Fuso server FTMO GMT+2/+3 ≠ BCM**: tutti gli InpSessionHour vanno ricalcolati (DAX apre 10:00 ora server FTMO d'estate, non 08:00 come su BCM!).

## ✍️ (b) DOMANDE DA FARE PER ISCRITTO AL SUPPORTO FTMO (prima di pagare)

1. "Our strategy opens a MARKET order on gold/indices at the Sunday market reopening, trading against the weekend gap, with a fixed 0.65% risk and stop loss. Is this considered forbidden 'gap trading' under your Forbidden Trading Practices, on a Swing account and during the Challenge/Verification?"
2. "Does the gap trading prohibition (opening trades ≤2h before a ≥2h market close / before scheduled major news) apply to SWING accounts and to the Evaluation Process, or only to Standard FTMO Accounts?"
3. "Our EAs place two opposite pending orders (bracket/OCO) before session opens on the SAME account, the untriggered one is cancelled. Is this compliant?" (dovrebbe rientrare nell'eccezione 'stesso conto', ma meglio nero su bianco)
4. "On a Swing FTMO Account, are there ANY news-related or overnight/weekend restrictions, including SL/TP executions during news, given our EAs have no news filter?"
5. "We run the same proprietary EA portfolio on funded accounts at OTHER prop firms in parallel (no third party involved, our own strategy). Any issue with your rules, e.g. 'identically traded strategies' or max capital allocation?"
6. "Do we need to declare the use of proprietary EAs? Is there any limit besides the 2,000 server requests/day?"
7. "Holding overnight on DAX on a STANDARD FTMO Account: does the >2h market break rule force intraday-only trading on European indices?" (solo se mai considerassimo Standard)

---
*File creato dall'indagine del 13/08/2026 — fonti: solo pagine ufficiali FTMO. Fetch diretto bloccato dal proxy: citazioni estratte via ricerca, da ricontrollare visivamente sulle URL prima della firma.*
