# DOMANDE SCRITTE AI SUPPORTI PROP (D3) — pronte da inviare, 13/08/2026

⏸️ DECISIONE DI CLAUDIO (13/08): INVIO RINVIATO — prima 1-2 settimane
di forward del vivaio nuovo (BB + GAP), poi si mandano. Le domande
restano pronte qui sotto; quando si inviano, aggiungere una riga tipo
"my portfolio has been running live for X weeks" per dare peso.

REGOLA: si manda dal proprio account/email, si chiede risposta SCRITTA,
si salva la risposta (PDF o screenshot con data). Niente acquisti prima
delle risposte. Le domande citano i comportamenti REALI dei nostri EA,
senza rivelare le strategie.

---

## FTMO — support@ftmo.com (o live chat, chiedendo conferma via email)

Subject: Rule clarification before purchasing a 2-Step Challenge (Swing account)

Hello,
I am an algorithmic trader planning to purchase a 100k 2-Step Challenge
with a Swing account. Before purchasing, I would like written
clarification on three points regarding my fully automated strategies:

1. GAP TRADING / WEEKEND REOPEN. One of my EAs opens a market position
   shortly AFTER the weekly market reopen (Sunday evening / Monday
   morning), trading in the direction of closing the weekend opening
   gap, with a fixed stop loss and a time-based exit. Your Forbidden
   Trading Practices mention "gap trading" as opening trades shortly
   BEFORE market close. Is opening a position AFTER the reopen, as
   described, permitted on Swing accounts (both during the Challenge/
   Verification and on the funded FTMO Account)?

2. BRACKET PENDING ORDERS. Another EA places two opposite pending stop
   orders (a buy stop above and a sell stop below a price range) on the
   same instrument at a fixed time of day; when one side is triggered,
   the other is cancelled (OCO logic). Both orders always carry a stop
   loss. Is this compliant on the same account?

3. MULTIPLE FIRMS. My strategies are proprietary (developed by me, not
   purchased). If I run the same proprietary portfolio in parallel on a
   funded account at ANOTHER prop firm (not FTMO), does this violate any
   FTMO rule (e.g. the USD 400k capital allocation rule or the
   "identical strategies" policy, which I understand applies across
   FTMO accounts)?

Thank you — please confirm in writing so I can keep the reply for my
records before purchasing.

---

## The5ers (High Stakes) — dalla live chat/ticket sul loro sito

Subject: Rule clarification before purchasing a High Stakes account

Hello,
I trade a portfolio of my own fully automated EAs and I am considering
a High Stakes account. Three written clarifications before purchasing:

1. SIMULTANEOUS POSITIONS ACROSS INSTRUMENTS. My portfolio trades
   several UNCORRELATED instruments (indices, gold, FX pairs), each
   with its own EA and its own stop loss, risking about 0.65% per
   position. On busy days, 5-8 positions may be open at the same time
   on DIFFERENT instruments and in different directions. Is this
   considered "bulk trading" or "over-exposure" under your rules, or is
   it acceptable as normal portfolio diversification?

2. OPPOSITE PENDING ORDERS (SAME INSTRUMENT). One EA places a buy stop
   and a sell stop simultaneously around a pre-session price range on
   the SAME instrument (OCO: the first fill cancels the other order;
   both carry stop losses). Is this compliant, or would it fall under
   any "hedging"/"straddling news" restriction even when no news event
   is targeted?

3. ONE-SIDED BETS. Some of my EAs are long-only or short-only on a
   given instrument, because backtesting showed the edge exists on one
   side only. Positions are held from minutes to a few days. Does your
   "one-sided bets" clause apply to this behavior?

Please reply in writing; I will keep the reply for my records.

---

## 🕛 FTMO — BLOCCO NUOVO DEL **23/09/2026**: IL CONFINE DELLA GIORNATA

> **Perché**: la challenge `541452707` è **già viva** e il Monte Carlo delle 242 giornate dice
> che la modalità di morte principale è il **muro GIORNALIERO (18,2%)**, non lo statico (11,5%).
> Il nostro Guardian azzera il contatore a un'ora **costante** (`InpDailyResetHour=1`, ora server
> FTMO) e parte dall'**equità**; FTMO parte dal **saldo** delle 00:00 CE(S)T. Le tre domande qui
> sotto sono **esattamente** i tre punti che il repo non sa decidere da solo.
> Misura che le genera: `report/IL_CONFINE_DEL_GIORNO_2026-09-23.md` §2 e §7 (N1, N6).
> 🔴 Queste domande **non sono ancora state inviate**: inviarle è una decisione di Claudio.

Subject: Daily Loss Limit — exact reset time and the balance used when a position is open at 00:00

Hello,
I hold an active 2-Step Challenge (account 541452707, EUR 80,000, MT5).
I run fully automated strategies and I need to align my own risk
software to your Maximum Daily Loss calculation. Three technical
questions:

1. SERVER TIME AND DAYLIGHT SAVING. Your MT5 server is currently GMT+3
   (measured on 20 Sep 2026). European DST ends on Sunday 25 October
   2026, US DST on Sunday 1 November 2026. On which of those two dates
   does your MT5 server switch to GMT+2? In other words, between 25 Oct
   and 1 Nov 2026, at which MT5 SERVER hour does 00:00 CE(S)T fall —
   01:00 or 02:00? I need this to schedule my own daily reset.

2. BALANCE AT 00:00 WITH OPEN POSITIONS. Your rule reads: "the account
   balance recorded at 00:00 CE(S)T of the current day". If I am
   holding an open position across 00:00 CE(S)T with a floating loss,
   is the reference the pure BALANCE at that instant (excluding the
   floating P/L), or the EQUITY at that instant (including it)?

3. FLOATING PROFIT AT 00:00. Symmetrically: if at 00:00 CE(S)T I am
   holding a position with a floating PROFIT, does the daily limit
   level stay anchored to the balance, or does it move up with the
   equity?

Please reply in writing; I will keep the reply for my records.

---

## Registro risposte

> ### 🟢 23/09/2026 — **IL BLOCCO DEL 13/08 E' PARTITO**, dopo 41 giorni fermo
> Claudio l'ha inviata a `support@ftmo.com`, adattata: la stesura originale diceva
> *"before purchasing"*, la challenge invece e' **gia' in corso** (80k 2-Step, Swing,
> conto **541452707**), quindi il testo inviato parla di *"currently running"*.
>
> 💰 **PERCHE' CONTA, col numero**: la **domanda 1** (gap trading / riapertura della
> domenica) e' l'unica cosa che tiene ferma la variante col **PF piu' alto che abbiamo
> a tick reali** -- `GAPFILL`, **IS 2,09-2,54 · OOS 1,54-2,87 · DD 2,9-6,0%**
> (`report/ORB_NASDAQ_PERCHE_E_SPENTO_2026-09-23.md`). 🔴 **E' ferma per una REGOLA,
> non per un numero**: e' l'unico candidato della flotta in questa condizione.
> La **domanda 2** (ordini pendenti opposti con OCO) tocca le tre sedie d'apertura, che
> operano cosi' tutti i giorni.
>
> ⏳ **COSA FARE QUANDO ARRIVA LA RISPOSTA**, deciso ORA per non improvvisare dopo:
> 1. si incolla **verbatim** in questo registro, con la data;
> 2. se la domanda 1 e' **SI'**, `GAPFILL` rientra nell'imbuto e va rimisurata **prima**
>    di qualunque schieramento: il suo PF viene da un banco, non dal campo;
> 3. se e' **NO**, si scrive il **certificato** (motivo: REGOLA, non merito) e non ci si
>    torna piu' -- ed e' comunque un risultato, perche' oggi quel motore ci costa
>    attenzione a ogni censimento;
> 4. se la risposta e' **ambigua**, vale come **NO** fino a una conferma scritta. Su una
>    Forbidden Trading Practice non si interpreta a favore.
>
> 📌 Nessun sollecito prima di **5 giorni lavorativi** (dal 30/09). Se al 30/09 non c'e'
> risposta, si rimanda con la live chat chiedendo conferma via email, come dice la
> testata di questo blocco.

| Ditta | Inviata il | Risposta il | Esito | Allegato |
|---|---|---|---|---|
| FTMO (blocco 13/08) | 🟢 **23/09/2026** (inviata da Claudio) | — | ⏳ **in attesa** | — |
| FTMO (blocco 23/09, confine del giorno) | — | — | — | — |
| The5ers | — | — | — | — |
