# 🔎 VAGLIO — **fintokei.com** (Fintokei · Purple Holding) · 27/08/2026

_Mandato: vagliare la prop firm **Fintokei**, vista da Claudio come **pubblicita'
sponsorizzata su Instagram** (prodotto "Fintokei Evaluation — ProTrader SWING",
sfida da 50.000 €). **La fonte della segnalazione e' dichiarata ma NON e' un
criterio**: si giudica su regole scritte e reputazione, esattamente come le 11
prop gia' censite il 26-27/08._

**Nessun acquisto autorizzato da questo file.** Vale la regola D3: risposta
scritta del supporto prima di ogni euro, e decide Claudio.

---

## 0. 🎯 CONTROLLO POSITIVO E STATO DELLE FONTI — leggere PRIMA di tutto

Bersaglio a risposta nota: gli obiettivi FTMO **devono** restituire
5% giornaliero / 10% totale / reset 00:00 CE(S)T. Tre canali provati oggi:

| canale | bersaglio | esito | uso |
|---|---|---|---|
| `curl` diretto (proxy) | `https://www.fintokei.com/it/` | `CONNECT tunnel failed, response 403` | 🛑 **NULLO** |
| **WebFetch** | `ftmo.com/en/trading-objectives/` (controllo a risposta nota) | ❌ `EGRESS_BLOCKED` | 🛑 **NULLO** |
| **WebFetch** | `www.fintokei.com/it/` (bersaglio) | ❌ `EGRESS_BLOCKED` | 🛑 **NULLO** |
| **WebSearch** | FTMO trading objectives | ✅ restituisce **5% / 10% / reset midnight CE(S)T** = risposta nota **centrata** | 🟢 **UNICO CANALE VIVO** |

### 🏷️ L'ETICHETTA CHE VALE PER OGNI RIGA DI QUESTO FILE

> 🟡 **`[LETTO-VIA-SEARCH 27/08/2026]`** — stessa convenzione di
> `VAGLIO_KEYTOPROP_2026-08-27.md` e `DOSSIER_PROP_CANDIDATE_2026-08-26.md`.
> **Non ho aperto con i miei occhi una sola pagina di fintokei.com.** Il
> contenuto arriva dal canale di ricerca, che ha letto e riassunto le pagine
> indicate negli URL. Dove il numero non e' comparso scrivo **NON DICHIARATO**
> o **[INCERTO]** — mai una deduzione travestita da fatto.

🟢 **Differenza importante rispetto al vaglio KeyToProp di stamattina:** li' il
canale non mi aveva restituito **una sola percentuale dei muri**. Qui invece la
knowledge base `support.fintokei.com` e' **ricca, indicizzata e citata con
esempi numerici espliciti** (articoli 6538826, 6538822, 12058210, 11315966,
11315971, 11315976, 11468666, 6538843, 6538829, 6538838). Le voci eliminatorie
del metro di casa sono **quasi tutte dichiarate**, non dedotte.

🔴 **Cautela di metodo applicata anche oggi:** ho interrogato il canale con
domande **senza numeri dentro** (la trappola dell'eco che ha bruciato una riga
del vaglio KeyToProp). I numeri qui sotto sono usciti dal canale, non dalla mia
domanda.

---

## 1. 📏 IL METRO DI CASA — contro cui si giudica (invariato dal 26/08)

Fonti interne: `report/METRO_PROP.md`, `ANALISI_DD_TOTALE_2026-08-26.md`,
`ANALISI_DIAL_TAGLIE_2026-08-26.md`, `report/FIRME_2026-08-18.md`,
`report/PIANO_PROP.md`, `mql5/Experts/ABTG_Guardian.mq5`.

| voce | numero di casa |
|---|---|
| flotta | **35 sedie vive** su **MT5**, **sorgenti posseduti** |
| filtro news | 🔴 **NESSUNO** — gli EA tradano dentro le notizie |
| durata trade | da **4+ minuti** a swing con tenuta **overnight e weekend** |
| lati | **due** (long e short), sedie mono-direzione dichiarate nel nome |
| rischio per trade | **0,65%** |
| peggior giornata CHIUSA | **−4,74%** (25/05/26) a dial 1,00 |
| DD totale misurato (picco-valle, chiusi) | **−6,37%** su 481 giorni |
| Monte Carlo p99 (DD **statico**) | **~8,1%** a 0,65% (12,47% a rischio 1%) |
| 🧱 **muri necessari** | **daily 5% / totale 10%, ENTRAMBI STATICI** |
| 🔴 sul trailing | un totale **trailing 6% si rompe PERSINO sui chiusi** (6,37% > 6%) — `ANALISI_DD_TOTALE` §4: **"Muri statici o niente"** |
| 🔴 **cap C1 rischio aperto firmato** | **3,25%** (= 5 SL vivi da 0,65%), `InpMaxOpenRiskPct=3.25` in `ABTG_Guardian.mq5` riga 60 |
| 🔴 **rischio aperto REALE misurato** | **5,85%** il 03/08 alle 08:15 (**9 posizioni di 8 sedie insieme**), p99 giornaliero **5,67%** — `REFERTO_M2_SOVRAPPOSIZIONE.md`, citato in `PIANO_PROP.md` §309 |
| leva indici | **1:15 = margine che morde · 1:25 respira** |
| payout | 🔴 **niente cap stile $3k/ciclo** se possibile |

---

## 2. 🏢 ESISTE? DA QUANDO? CHI C'E' DIETRO?

🟢 **Questa e' la sezione in cui Fintokei stacca nettamente tutto il resto del
censimento.** Non e' una landing page con un dominio anonimo.

| voce | valore | etichetta |
|---|---|---|
| **gruppo proprietario** | **Purple Holding** — conglomerato fintech **ceco fondato nel 2007**, opera **tre broker**, un fondo VC e un gateway di pagamento | 🟡 search 27/08 (Finance Magnates / FX News Group) |
| **broker di appoggio** | **Purple Trading** (entita' **registrata alle Seychelles** per il ramo prop) | 🟡 search 27/08 |
| **sede** | quartier generale in **Repubblica Ceca**; entita' prop **Seychelles** | 🟡 search 27/08 |
| **fondata** | Fintokei **2021/2022** (le fonti oscillano fra "lanciata nel 2021" e "fondata nel 2022") — 🟠 **[INCERTO di un anno]**, ma **non e' nata ieri** | 🟡 search 27/08 |
| **co-fondatore** | **David Varga** (co-fondatore anche di Purple Trading) — 🟢 **persona con nome e cognome, intervistata da testate di settore** | 🟡 search 27/08 |
| **mercato principale** | 🇯🇵 **Giappone = ~75% del business**; espansione UE recente (da cui la pubblicita' italiana vista da Claudio) | 🟡 search 27/08 |
| **scala dichiarata** | **200+ dipendenti**, **100.000+ trader**, **100+ paesi** | 🟠 dichiarato dall'azienda |
| **payout dichiarati** | **oltre €4M pagati nel 2024**; **oltre $20M** cumulati | 🟠 dichiarato, ripreso da Finance Magnates |
| **piattaforme** | 🟢 **MT4, MT5 e cTrader** | 🟡 search 27/08 |
| **taglie** | da **1.000 €** fino a **400.000 €** | 🟡 search 27/08 |
| **copertura stampa di settore** | 🟢 **Finance Magnates** (piu' articoli: espansione UE, payout 2024, instant withdrawals), **FX News Group**, **TradingView News**, **AziendaBanca** (IT) | 🟡 search 27/08 |

> 🎯 **Confronto secco con KeyToProp (stessa giornata, stesso metro):**
> KeyToProp = **89 recensioni Trustpilot**, **UNLISTED su Prop Firm Match**
> (non ha superato la loro due diligence), **zero traccia su forum**, **eta' del
> dominio non determinabile**. Fintokei = **~1.100-1.200 recensioni**, **listata
> E PREMIATA su Prop Firm Match**, **coperta dalla stampa di settore**, **gruppo
> madre del 2007**. **Non sono nella stessa categoria di rischio-esistenziale.**

---

## 3. 🧱 LA DOMANDA #1 DEL MANDATO — IL MURO E' STATICO O TRAILING?

**E' la bandiera rossa che il mandato chiedeva di verificare per prima**, perche'
"drawdown flessibile" e' la stessa formula ambigua che ha bocciato KeyToProp
(li': _"calculated based on your highest equity peak and resets dynamically"_).

### 🟢 RISPOSTA: **IL MURO TOTALE E' STATICO. NON E' LA TRAPPOLA DI KEYTOPROP.**

`[LETTO-VIA-SEARCH 27/08/2026]`, FAQ `support.fintokei.com/en/articles/6538826`:

> _"The overall drawdown **is the same every day** and is **10% of your starting
> capital** on ProTrader accounts... If you started with 100,000 USD and your
> overall drawdown limit is −10%, your equity can **never fall below 90,000 USD
> at any time**."_

e ancora:

> _"Maximum loss limit... is **calculated from your initial available capital**
> in your account right from the start in the case of SwiftTrader, or **after
> completing the evaluation** in the case of ProTrader."_

🟢 **Ancora = capitale iniziale. Percentuale = 10%. Non si muove col profitto.
E' ESATTAMENTE la specifica del metro di casa** (`ANALISI_DD_TOTALE` §4:
_"muri statici o niente"_).

### 🟡 E ALLORA COS'E' IL "DRAWDOWN FLESSIBILE" DELLA PUBBLICITA'?

E' il **GIORNALIERO**, ed e' flessibile **in nostro favore**, non contro:

> _"Every day at midnight (UTC+0), a snapshot of your EOD equity is taken.
> During the next 24 hours, your equity cannot get below 5% of your equity at
> midnight for ProTrader accounts."_
> _"...if you started with 100,000 USD and your equity at midnight after the
> first trading day is 103,000 USD, on the following day, you can't get below
> equity of **97,850 USD** (103,000 − (103,000×0.05))."_

🟢 **L'ancora del giornaliero si RIALLINEA ogni notte al saldo/equity corrente.**
Se il conto cresce, il cuscino giornaliero cresce **in valore assoluto**. E' piu'
generoso di FTMO, dove il giornaliero e' 5% del capitale **iniziale** (quindi in
dollari resta fisso mentre il conto cresce).

### 🔴 LA TRAPPOLA "HIGH-WATER MARK" — VERIFICATA E DISINNESCATA

Fintokei **ha** un concetto di High-Water Mark, e ha pure un articolo di blog
intitolato _"Drawdown and High-water mark — the only two parameters you must
watch"_. 🔴 **E' esattamente il tipo di pagina che su KeyToProp nascondeva il
trailing.** L'ho inseguita.

FAQ `support.fintokei.com/en/articles/8409192`:
> _"The High-Water Mark (HWM) is the **highest equity achieved** on a particular
> account... updated **once per day** at the beginning of the trading day."_

🟢 **Ma serve per il CALCOLO DEI PAYOUT (performance fee / profit split), NON per
il muro di perdita.** E' la funzione classica dell'HWM nei fondi: non ti pagano
due volte sullo stesso profitto. Il canale, interrogato specificamente, associa
l'HWM a _"determine performance fees and profit distribution"_.

> ⚠️ **[INCERTO residuo, e lo dichiaro]:** non ho letto la pagina blog con i miei
> occhi. Se Claudio apre
> `www.fintokei.com/blog/drawdown-high-water-mark-parameters-you-must-watch-when-trading-with-fintokei/`
> e trova che l'HWM entra nel calcolo del **max loss**, questo verdetto va
> rifatto da zero. **Ma le due FAQ ufficiali sul max loss dicono, con esempio
> numerico, "10% of your STARTING capital" e "never fall below 90,000".**

---

## 4. 📋 SCHEDA PROP — Fintokei · ProTrader Swing

```
PROP            FINTOKEI  (Purple Holding, Repubblica Ceca / Purple Trading, Seychelles)
PRODOTTO        ProTrader SWING  —  taglia vista in pubblicita': 50.000 EUR
URL REGOLE      support.fintokei.com/en/articles/6538826  (calcolo muri)
                support.fintokei.com/en/articles/12058210 (ProTrader vs Swing)
                support.fintokei.com/en/articles/6538822  (regole ProTrader)
                support.fintokei.com/en/articles/6538838  (EA)
                support.fintokei.com/en/articles/6538843  (news/weekend/overnight)
                support.fintokei.com/en/articles/6538829  (limite di tempo)
                support.fintokei.com/en/articles/11315976 (rischio su trade aperti)
                support.fintokei.com/en/articles/11468666 (oversized risk)
                support.fintokei.com/en/articles/11315966 (consistency, applicazione)
                support.fintokei.com/en/articles/11315971 (consistency, altre restrizioni)
                support.fintokei.com/en/articles/6538847  (leva)
                www.fintokei.com/protrader-swing/
LETTA IL        27/08/2026    [LETTO-VIA-SEARCH — WebFetch e curl NULLI]
VISTA COME      pubblicita' sponsorizzata Instagram (dichiarato, NON un criterio)
```

| voce | valore | etichetta |
|---|---|---|
| **struttura** | **2 fasi** (come ProTrader standard) | 🟡 search 27/08 |
| **target di profitto** | **Fase 1 = 8%** · **Fase 2 = 6%** — 🟠 una fonte terza dice **5%** in fase 2 per lo Swing: **[INCERTO]**, da confermare | 🟡/🟠 |
| 🧱 **MURO GIORNALIERO** | **−5%** | 🟢 dichiarato |
| — **base di calcolo (Swing)** | 🟢🟢 **EOD BALANCE** (solo trade CHIUSI): _"Daily loss limit is calculated from **balance only** (closed trades). **Open positions don't affect it**"_ | 🟢 **la voce che vende il prodotto** |
| — base di calcolo (ProTrader standard) | **EOD EQUITY** (include il flottante al rollover) | 🟡 search |
| — **reset** | **mezzanotte UTC+0** (= **01:00 ora italiana**, = **00:00 ora server BCM** in questo periodo) | 🟡 search |
| — si muove? | 🟢 **si riallinea ogni notte** al nuovo saldo: se il conto cresce, il cuscino cresce | 🟡 search |
| 🧱 **MURO TOTALE** | 🟢🟢 **−10% STATICO sul capitale iniziale**: _"the same every day"_, _"equity can never fall below 90,000 USD"_ | 🟢 **dichiarato con esempio numerico** |
| — trailing? | 🟢 **NO.** L'HWM esiste ma serve ai **payout**, non al muro (§3) | 🟢 verificato per esclusione |
| — enforcement | 🔴 **immediato**: _"Breaching a drawdown limit fails that account immediately, without waiting for the end of the day"_ | 🟡 search |
| 🔴🔴 **CAP RISCHIO SU TRADE APERTI** | 🔴🔴 **3%** — _"All accounts under ProTrader Swing are subject to a **3% maximum risk on open trades**"_ | 🔴 **LA REGOLA CHE CI MORDE (§5)** |
| — come lo calcolano | _"based on the **StopLosses set by the trader** (if applicable) and on **Value at Risk (VaR)** analysis in combination with your position sizing"_ · _"whichever is lower"_ | 🟡 search |
| — se manca lo SL | _"if you haven't set a stop-loss, or if your stop-loss is set **too far away**, risk is calculated based on **how the market typically moves during that trading session**"_ (VaR) | 🟡 search |
| — 🔴 **penale** | 🔴 **NON e' un breach**: e' **warning → Consistency Restrictions** (§5.2) | 🟡 search |
| — 🔴 aggregato o per-trade? | 🔴🔴 **[INCERTO] — LE FONTI SI CONTRADDICONO.** Una dice _"3% maximum risk on **any single open position**"_, un'altra dice _"your **total** risk on open trades never exceeds 3%"_. **E' la domanda n.1 al supporto** | 🔴 **BUCO CRITICO** |
| **STOP LOSS obbligatorio?** | 🟡 **no** in partenza (_"if applicable"_), **ma** senza SL scatta il VaR, e lo SL obbligatorio e' **una delle penali** delle Consistency Restrictions | 🟡 search |
| 📰 **NEWS TRADING** | 🟢 **PERMESSO, senza finestra di blackout**: _"News trading is allowed without any limits or restrictions"_ · lo Swing e' **venduto proprio per questo** · 🔴 **MA** _"can be restricted on an individual account as part of consistency measures"_ | 🟢 con 🔴 postilla |
| 🌙 **OVERNIGHT** | 🟢 **PERMESSO**: _"you can keep your positions open as long as you wish"_ | 🟢 |
| 📅 **WEEKEND** | 🟢 **PERMESSO** (con swap). ⚠️ avvisano che **il gap del lunedi' puo' bruciare il conto alla riapertura** · 🟠 **crypto non tradabile nel weekend** (ma le posizioni si possono tenere) | 🟢 |
| — gap trading vietato? | 🟢 **NESSUNA clausola "gap trading" trovata** (a differenza di FTMO, Goat e KeyToProp) | 🟡 assenza, non smentita |
| ⏱️ **LIMITE DI TEMPO** | 🟢 **ILLIMITATO** su entrambe le fasi: _"You have **unlimited time** to complete the first or second evaluation phase"_ — 🟢 **il claim pubblicitario e' VERO** | 🟢 |
| **GIORNI MINIMI** | **3 giorni** di trading (per passare e per il reward) | 🟡 search |
| 📐 **CONSISTENZA (payout)** | **40%**: nessun singolo giorno puo' valere ≥40% del profitto del ciclo di payout. 🟢 **NON e' un breach**: blocca solo la richiesta finche' non trada ancora. Si **azzera dopo ogni payout approvato** | 🟡 search |
| 🔴 **CONSISTENZA (discrezionale)** | 🔴 _"Fintokei **may apply a combination of restrictions to any of your active or future new accounts on an individual basis**, depending on your specific behavior"_ | 🔴 **clausola aperta** |
| 🤖 **EA / MT5** | 🟢 **PERMESSI**, a condizione che _"you're the **creator or full owner** of the strategy and **understand how it works**"_ | 🟢 |
| — vietato | EA **commerciali o gratuiti senza personalizzazione**, **black-box**, **signal package**, **HFT bot**, **"trading robots designed to pass a trading challenge"** | 🟡 search |
| — 🟠 la frase discrezionale | 🟠 _"Fintokei is looking for talented **traders**, not talented **robots**... your use of EA must clearly show that **you are at the helm, not the robot**"_ | 🟠 **[INCERTO] per una flotta di 35 EA** |
| — copy trading | 🔴 **VIETATO**: copiare da signal provider, altro trader, canale Telegram/Discord o mentor; vietato far tradare il conto da altri | 🟡 search |
| — profili multipli | 🔴 vietato aprire piu' profili/registrazioni nella client zone | 🟡 search |
| 📈 **LEVA (ProTrader e Swing)** | 🟢🟢 **1:100** FX, **oro e argento** · **1:50 INDICI** · **1:20** il resto | 🟢 **la migliore del censimento** |
| — altri programmi | 1:25 FX/oro/argento · 1:20 indici · 1:10 resto | 🟡 search |
| **POSIZIONI APERTE MAX** | 🟢 **200** ordini aperti o pendenti | 🟡 search |
| **ALLOCAZIONE MAX** | **400.000 EUR/USD** su ProTrader/ProTrader Swing (un solo conto a quella taglia) | 🟡 search |
| 💰 **SPLIT** | **80%** base, fino a **90-95%** (una fonte dice fino al 100% con loyalty tier) — 🟠 fonti che oscillano | 🟠 |
| 💸 **PAYOUT — frequenza** | **ogni 14 giorni**; il primo 14 giorni dopo il primo trade | 🟡 search |
| — minimo | **3%** di profitto | 🟡 search |
| — 🟢 **CAP di payout?** | 🟢 **NESSUN cap trovato** (niente stile $3k/ciclo) — 🟡 assenza, non smentita esplicita | 🟡 |
| — velocita' | **auto-approvazione in ~20 secondi** (record 2,8s), fondi entro **1 giorno lavorativo**, spesso 3-5 ore | 🟠 dichiarato |
| **PREZZI** | gamma generale **$44 → $2.399** secondo programma e taglia; 🔴 **il prezzo esatto della ProTrader Swing 50k EUR NON e' emerso** | 🔴 buco |

---

## 5. 🩸 COSA CI MORDE — punto per punto, col numero di casa accanto

### 🔴🔴 1. IL CAP DEL **3% SUL RISCHIO APERTO** — **e noi ne abbiamo misurati 5,85%**

**Questo e', da solo, il vero problema di Fintokei per la nostra flotta.** E non
e' una clausola discrezionale nascosta: e' una regola scritta, numerica,
automatizzata, con un motore di misura (SL + VaR) che gira sul loro server.

L'aritmetica di casa, in chiaro:

| voce | numero | fonte |
|---|---:|---|
| cap Fintokei sul rischio aperto | **3,00%** | FAQ 11315976 |
| 🔴 **nostro cap C1 FIRMATO** | **3,25%** | `ABTG_Guardian.mq5` riga 60, `FIRME_2026-08-18.md` |
| 🔴🔴 **nostro rischio aperto REALE misurato** | **5,85%** (03/08 h.08:15, **9 posizioni di 8 sedie**) | `REFERTO_M2_SOVRAPPOSIZIONE.md` |
| nostro p99 giornaliero di rischio aperto | **5,67%** | idem |

🔴 **Il nostro cap firmato e' GIA' SOPRA il loro limite, del 8,3%.** E il valore
**realmente osservato in forward** e' **quasi il doppio** del loro tetto.

⚠️ **MA — e conta moltissimo — dipende da una voce che NON SO:**

| se il 3% e'... | conseguenza per noi |
|---|---|
| **per singola posizione** | 🟢 **NON CI TOCCA**: giriamo a **0,65%** per trade, cioe' **meno di un quinto** del tetto |
| **aggregato su tutte le posizioni aperte** | 🔴🔴 **CI STRANGOLA**: significa **max 4 sedie da 0,65% aperte insieme** (2,60%), la quinta sfonda (3,25%) — e il 03/08 ne avevamo **otto** |

🔴 **Le due letture escono da due fonti diverse dello stesso canale e si
contraddicono.** Finche' non c'e' una risposta scritta, **questa e' la voce che
decide se Fintokei e' la nostra prop migliore o una prop impossibile.**
E' la domanda Q1 del §8.

### 🔴🔴 2. LA PENALE NON E' UN BREACH — E' **PEGGIO** DI UN BREACH

Il dettaglio che la pubblicita' non dice e che ho dovuto inseguire fino alla
FAQ 11315966. Sforare il 3% **non chiude il conto**. Fa scattare le
**Consistency Restrictions**, e l'elenco della "applicazione piu' comune" e':

> - **leva ridotta a 1:10 sul FX e 1:5 su tutto il resto**
> - **tetto al profitto giornaliero: +1%** del saldo di partenza
> - **tetto alla perdita giornaliera: −1%** del saldo di partenza
> - **stop loss obbligatori**

E la scala di escalation dichiarata: _"warning → consistency rules → restriction
or breach → **platform block** in severe cases"_.

🔴 **Perche' e' peggio di un breach, per NOI, in tre punti misurati:**

1. **Leva 1:10.** `METRO_PROP` / `ANALISI_TAGLIA_FASE1` dicono che **a 1:15 il
   margine gia' morde a 100k**. A **1:10** una parte della flotta indici
   **non riesce proprio ad aprire**.
2. **Tetto di profitto giornaliero +1%.** La nostra distribuzione di rendimento
   e' **a coda**: i giorni grossi fanno il risultato. Un tetto a +1%/giorno
   **taglia le code positive lasciando intatte quelle negative** — e' un
   massacro asimmetrico dell'aspettativa.
3. **Tetto di perdita giornaliera −1%.** Con 35 sedie e un worst-day misurato
   di **−4,74%**, un cap a −1% significa **flat forzato quasi ogni settimana
   cattiva**, con chiusura d'ufficio delle posizioni e read-only fino a
   mezzanotte UTC (FAQ 11315971, testuale).

🔴 **In pratica: si resta "vivi" ma su un conto che non puo' piu' produrre.**
E' la forma peggiore di fallimento, perche' non e' nemmeno rimborsabile.

### 🔴 3. LA CLAUSOLA APERTA — E LA PROVA CHE **VIENE USATA DAVVERO**

FAQ 11315971, testuale:
> _"Fintokei **may apply a combination of restrictions to any of your active or
> future new accounts on an individual basis, depending on your specific
> behavior**."_

Su KeyToProp una clausola simile l'ho segnalata come rischio **teorico**. 🔴 **Su
Fintokei ho trovato la controprova empirica**, ed e' una bandiera rossa vera:

**WikiFX, articolo del settembre 2025**, _"Fintokei Exposed: Profit Capping &
Harsh Account Rules Frustrate Traders"_ `[LETTO-VIA-SEARCH]`:
- trader che riferiscono di essere stati **ristretti all'1% di rischio DOPO aver
  ricevuto un payout**, e poi **terminati lo stesso** pur avendo rispettato le
  nuove restrizioni;
- account **terminati con accusa di pratiche proibite, senza rimborso e senza
  processo d'appello**; alla richiesta di prove, risposta che _"e' tutto interno
  e confidenziale"_;
- un trader riferisce che **un funzionario gli aveva autorizzato a voce il 3-4%
  per trade** e che poi gli e' arrivata **una mail che glielo proibiva** —
  🔴 **esattamente il rischio della regola D3: l'autorizzazione verbale non vale.**

🟠 **Come peso questa fonte, onestamente:** WikiFX **non e' una fonte di prima
qualita'** (aggregatore, tono sensazionalistico, raccoglie lamentele non
verificate). E le lamentele di trader falliti sono il rumore di fondo di
**ogni** prop firm, FTMO compresa. **Ma il pattern descritto combacia parola per
parola con la clausola scritta nella loro FAQ ufficiale** — e questa coincidenza
fra "quello che si riservano di fare" e "quello che i trader dicono che hanno
fatto" **non e' rumore: e' conferma.**

### 🟠 4. "YOU ARE AT THE HELM, NOT THE ROBOT" — la frase su misura contro di noi

La policy EA e' formalmente **ottima per noi**: _"you're the creator or full
owner of the strategy"_ — 🟢 **35 sorgenti nostri, condizione soddisfatta al
100%**, ed e' il requisito su cui cadrebbe chi compra EA dal Market.

🟠 **Ma la coda e' discrezionale:** _"Fintokei is looking for talented traders,
not talented robots"_ + _"your use of EA must clearly show that **you are at the
helm, not the robot**"_ + il divieto per _"trading robots **designed to pass a
trading challenge**"_.

🔴 **Una flotta di 35 EA che gira non presidiata su un VPS e' esattamente
l'immagine che quella frase descrive.** Non e' una violazione di nessuna regola
scritta — **e' proprio il punto**: e' un giudizio, e i giudizi si scoprono al
payout. Va messo per iscritto **prima** (Q3 del §8).

### 🟠 5. IL GIORNALIERO AL 5% RESTA IL VINCOLO CHE MORDE — ma qui meno del solito

`ANALISI_DD_TOTALE` §2, parola per parola: _"il vincolo che morde e' il
GIORNALIERO, non il totale: worst day −4,74% contro il muro −5% (margine 5%)"_.

🟢 **Su ProTrader SWING questo margine e' migliore che altrove, per due motivi
strutturali:**
1. **la base e' il BALANCE di fine giornata, non l'equity** → il flottante
   overnight **non entra nell'ancora**. Per una flotta che tiene overnight e
   weekend, e' precisamente la variante giusta;
2. **l'ancora si riallinea in su** quando il conto cresce, quindi dopo qualche
   settimana positiva il cuscino in valore assoluto e' **piu' largo** del 5%
   iniziale.

🔴 **Ma l'avvertenza (b) di `ANALISI_DD_TOTALE` resta INTERA**: il nostro −4,74%
e' **sui CHIUSI**, ed e' un **limite inferiore**. Fintokei misura **l'equity
intraday**, minimo assoluto compreso. **Il margine vero fra noi e il muro non lo
conosciamo**, e su un 5% giornaliero e' la differenza fra passare e bruciare.

### 🟠 6. IL GAP DEL LUNEDI' — avvisato da loro, e ci riguarda

Loro stessi scrivono che **il gap di riapertura puo' sfondare il conto**. La
flotta **tiene nel weekend** (`CLASSIFICA_WEEKEND.md` esiste apposta). 🟢 Il
mitigante: **nessuna clausola "gap trading vietato"** (a differenza di FTMO,
Goat e KeyToProp) → e' un **rischio di mercato**, non un rischio di squalifica.
E' molto meglio.

### 🟢 7. LE VOCI CHE SU KEYTOPROP ERANO BUCHI ELIMINATORI, QUI SONO DICHIARATE

News (🟢 libere), overnight (🟢 libero), weekend (🟢 libero), leva
(🟢 1:100/1:50), reset del giornaliero (🟢 mezzanotte UTC), limite di tempo
(🟢 nessuno). 🔴 **Su KeyToProp queste sei voci erano TUTTE "NON DICHIARATO".**

---

## 6. ⭐ REPUTAZIONE E VERIFICA DEI CLAIM PUBBLICITARI

### 6.1 I cinque claim della pubblicita', uno per uno

| # | claim della pubblicita' | verdetto | evidenza |
|---|---|---|---|
| 1a | _"trading **senza limite di tempo**"_ | 🟢 **VERO** | FAQ 6538829: _"unlimited time to complete the first or second evaluation phase"_. Minimo 3 giorni di trading |
| 1b | _"**drawdown flessibile**"_ | 🟢 **VERO, e in nostro favore** — 🔴 **ma la formula e' ambigua e va letta**: il **giornaliero** e' flessibile (si riancora ogni notte); il **totale e' RIGIDO al 10% del capitale iniziale**. **NON e' il trailing di KeyToProp** | §3 |
| 2 | _"**pagamenti istantanei — 99,9% processati immediatamente**"_ | 🟠 **DICHIARATO DALL'AZIENDA, NON verificato in modo indipendente** | il 99,9% copre apr-2023→giu-2025 ed e' un dato aziendale ripreso da Finance Magnates. Il *meccanismo* (auto-approvazione ~20s) e' reale e documentato |
| 3 | _"Prop Firm supportata da broker piu' popolare del 2024 — **Prop Firm Match**"_ | 🟢🟢 **VERO E VERIFICABILE** | annuncio sull'**account X ufficiale di Prop Firm Match** (`x.com/PropFirmMatch/status/1883130902135574763`): _"Most Popular Broker-Backed 2024: Fintokei"_, su **39 altre firm**, voto dei trader. Esiste anche `propfirmmatch.com/awards-2025` |
| 4 | _"Prop Firm piu' affidabile — 10/2025 **Forex Prop Reviews**"_ | 🟡 **VERO come esito, DEBOLE come metodo** | e' un **sondaggio anonimo** del comparatore, in cui Fintokei ha preso **tre premi** (most competitive / most reliable / most trusted). E' un premio vero di un sito vero, **ma un poll anonimo non e' un audit** |
| 5 | _"trading consentito durante i **rilasci di news**"_ | 🟢 **VERO a livello di regola** 🔴 **con clausola** | FAQ 6538843: news trading permesso **senza finestra di blackout**. 🔴 **MA**: _"can be restricted on an **individual account** as part of consistency measures"_ — **la pubblicita' non lo dice** |

> 🎯 **Lettura secca:** **nessuno dei cinque claim e' falso.** Due sono
> pienamente veri e verificabili (tempo illimitato, premio Prop Firm Match),
> uno e' vero ma con una postilla taciuta (news), uno e' vero ma va letto bene
> (drawdown), uno e' un dato aziendale non auditato (99,9%). 🟢 **Per una
> pubblicita' Instagram di prop firm, e' un risultato notevolmente onesto** —
> e va detto, perche' il sospetto iniziale era legittimo e non si e' avverato.

### 6.2 La reputazione, in tabella

| voce | valore | etichetta |
|---|---|---|
| **Trustpilot — voto** | **4,4 / 5** (una fonte) · **4,5 / 5** (altra) | 🟡 search 27/08 |
| **Trustpilot — numero recensioni** | **~1.063** · **~1.222** secondo la fonte — 🟢 **base larga**, ordine di grandezza **13× KeyToProp** | 🟡 search 27/08 |
| **distribuzione** | **79% cinque stelle**, **7% una stella** | 🟡 search 27/08 |
| 🟢 **Prop Firm Match** | 🟢 **LISTATA e PREMIATA** (vs KeyToProp: **unlisted**, esclusa dalla due diligence). Recensioni verificate sul loro sito: **4,3★ su 8** (🟠 base sottilissima) | 🟡 search 27/08 |
| **stampa di settore** | 🟢 **Finance Magnates** (≥3 articoli), **FX News Group** (intervista al co-fondatore), **TradingView News**, **PropInsider**, **AziendaBanca** | 🟡 search 27/08 |
| 🔴 **lamentele ricorrenti** | 🔴 account **bloccati/terminati dopo un payout**; restrizione all'**1% di rischio**; **nessun processo d'appello**, motivazioni _"interne e confidenziali"_; account disabilitati alla richiesta di payout con la scusa dei **conti multipli** | 🟠 **WikiFX + recensioni 1★ — non verificate** |
| **payout negati in massa?** | 🟢 **NO**: _"there are **no dated reports** of withheld or delayed payouts"_; molti riferiscono payout **in poche ore** | 🟡 search 27/08 |
| **forum indipendenti** | 🟠 nessun thread ForexFactory/Reddit sostanzioso emerso | 🟠 buco |

> 🎯 **La lettura onesta:** Fintokei **non e' una prop senza storia** (era il
> difetto fatale di KeyToProp): ha 4-5 anni, un gruppo madre del 2007, ~1.200
> recensioni, premi verificabili e copertura stampa. 🔴 **Il suo rischio non e'
> "sparisce coi soldi": e' "ti restringe fino a renderti improduttivo se il tuo
> stile non gli piace"** — ed e' un rischio **scritto nelle loro FAQ** prima
> ancora che nelle lamentele.

---

## 7. ⚖️ VERDETTO CONTRO IL METRO DI CASA

### La tabella che decide

| requisito del metro di casa | Fintokei ProTrader Swing | esito |
|---|---|---|
| 🧱 **muro TOTALE statico** | 🟢 **STATICO, 10% del capitale iniziale**, con esempio numerico ufficiale | ✅ **PASSATO** |
| 🧱 muro totale **≥ 10%** | 🟢 **esattamente 10%** (p99 di casa 8,1% statico → **~1,9 punti di margine**) | ✅ **PASSATO** |
| 🧱 muro **giornaliero 5%** | 🟢 **5%**, e per lo Swing **su BALANCE di fine giornata** (il flottante overnight non entra) + ancora che si rialza | ✅ **PASSATO — la variante migliore vista finora** |
| 🟢 **EA su MT5 ammessi** | 🟢 **SI**, con requisito _"creator or full owner"_ = **noi lo soddisfiamo** | ✅ **PASSATO** |
| 📰 **news trading libero** (non abbiamo filtro) | 🟢 **SI, senza blackout** · 🟠 restringibile individualmente | ✅ **PASSATO con riserva** |
| 🌙 **overnight + weekend liberi** | 🟢 **SI**, entrambi, dichiarati | ✅ **PASSATO** |
| ⏱️ **durata minima compatibile** | 🟢 **nessuna durata minima per trade** trovata (a differenza di Alpha 2min, KeyToProp 1min) → 🟢 **il debito `open_time` NON blocca qui** | ✅ **PASSATO** |
| ⚖️ **due lati / mono-direzione** | 🟢 nessuna clausola "one-sided bets" trovata | ✅ **PASSATO** |
| 📈 **leva indici 1:25 o meglio** | 🟢🟢 **1:50 indici, 1:100 FX/oro** — **la migliore del censimento** | ✅ **PASSATO alla grande** |
| 💸 **niente cap payout $3k/ciclo** | 🟢 nessun cap trovato · payout **ogni 14 gg**, auto-approvati | ✅ **PASSATO** |
| 🕐 **tempo illimitato** | 🟢 **SI** su entrambe le fasi | ✅ **PASSATO** |
| 🚫 **niente "gap trading" vietato** | 🟢 nessuna clausola trovata | ✅ **PASSATO** |
| 📐 **consistency che non ci congela** | 🟡 **40% best-day** = solo **gate di payout**, non breach, si azzera dopo ogni prelievo → 🟢 gestibile · 🔴 **ma esiste la consistency DISCREZIONALE sopra** | ⚠️ **misto** |
| 🔴🔴 **cap sul rischio APERTO** | 🔴🔴 **3%** contro il nostro **C1 firmato 3,25%** e un **reale misurato 5,85%** | ❌ **FALLITO come stiamo oggi** |
| 🔴 **penale della violazione** | 🔴 non un breach ma **leva 1:10 + tetto ±1%/giorno + SL obbligatori** = conto vivo ma **improduttivo** | ❌ **FALLITO** |
| 🏦 broker vero dietro | 🟢 **Purple Trading / Purple Holding, gruppo ceco dal 2007** | ✅ **PASSATO** |
| ⭐ storia e tracciabilita' | 🟢 ~1.200 recensioni, premi verificabili, stampa di settore | ✅ **PASSATO** |

**Punteggio secco: 14 requisiti passati · 2 falliti · 1 misto.**

Per confronto, stessa giornata: **Key to Prop = 4 passati, 3 falliti, 7 non
verificabili.**

---

### 🟡🟡 VERDETTO: **IN SOSPESO — CANDIDATA FORTE, CON DUE CONDIZIONI BLOCCANTI**

> 🟢 **Prima cosa, perche' e' la domanda che il mandato metteva davanti a tutto:
> Fintokei NON e' un secondo KeyToProp. Il muro totale e' STATICO, 10% del
> capitale iniziale, dichiarato con esempio numerico sulla loro knowledge base.
> Il "drawdown flessibile" della pubblicita' e' il GIORNALIERO, e la flessibilita'
> gioca a nostro favore. L'High-Water Mark esiste ma serve ai payout, non al
> muro. Il sospetto era legittimo, l'ho inseguito fino in fondo, e non si e'
> avverato.**
>
> 🟢 **Sui muri Fintokei ProTrader Swing e' la prop piu' vicina al nostro metro
> di tutto il censimento**: 5% giornaliero **calcolato sul BALANCE di fine
> giornata** (il flottante overnight non entra: e' precisamente cio' che serve a
> una flotta che tiene overnight e weekend) + 10% totale statico. Ci aggiunge
> **leva 1:50 sugli indici** (il doppio della nostra soglia "respira"), **news
> libere senza blackout**, **weekend e overnight liberi**, **nessun "gap trading"
> vietato**, **nessuna durata minima per trade** (quindi il debito `open_time`
> qui **non blocca**), **tempo illimitato** e **payout ogni 14 giorni senza cap**.
> Sulla carta e' la migliore combinazione di regole che abbiamo trovato.
>
> 🔴 **E allora perche' non e' PROMOSSA? Per una riga, e non e' la stessa di
> KeyToProp:**
>
> > _"All accounts under ProTrader Swing are subject to a **3% maximum risk on
> > open trades**."_
>
> 🔴 **Il nostro cap C1 firmato il 18/08 e' 3,25% — gia' sopra il loro tetto. E
> il rischio aperto REALMENTE MISURATO in forward e' 5,85% (03/08, nove
> posizioni di otto sedie insieme): quasi il doppio.** E la penale non e' la
> perdita della challenge — e' **leva tagliata a 1:10, tetto di profitto
> giornaliero a +1% e tetto di perdita a −1%**, cioe' **un conto vivo che non
> puo' piu' produrre**. Per una flotta a code come la nostra, un tetto di +1%
> al giorno e' un massacro asimmetrico dell'aspettativa.
>
> 🔴 **E c'e' un'ambiguita' che vale l'intero verdetto**: due fonti dello stesso
> canale dicono cose diverse — _"3% su **ogni singola posizione**"_ contro
> _"il **totale** del rischio aperto non superi il 3%"_. **Con la prima lettura
> non ci tocca nemmeno (giriamo a 0,65%). Con la seconda ci strangola a 4 sedie
> aperte.** Non e' un dettaglio da chiarire dopo: **e' la voce che decide.**

### 🚪 LE DUE CONDIZIONI PER PASSARE A **PROMOSSA**

**C-1 — la risposta scritta sul 3%** (Q1 del §8). Se il 3% e' **per singola
posizione** → 🟢 **Fintokei diventa immediatamente la candidata #1 del
censimento**, davanti a FTMO. Se e' **aggregato** → serve C-2, e comunque
si scende a **riserva**.

**C-2 — una misura di casa che oggi NON abbiamo fatto.** Se il 3% e' aggregato,
prima di pagare va **abbassato C1 da 3,25% a ≤ 2,50%** (margine sotto il loro
tetto) **e va RIMISURATO in forward quanto spesso la flotta lo tocca davvero** —
perche' il 5,85% del 03/08 dice che **il cap C1 oggi non basta a tenerci sotto
il 3%**, e non sappiamo nemmeno se il Guardian sia riuscito a farlo rispettare
quel giorno. 🔴 **Questa e' una modifica al forward: non si applica da qui,
si propone e decide Claudio.**

🔴 **Condizione di igiene che vale comunque, anche se C-1 va bene:** la clausola
_"may apply a combination of restrictions on an individual basis"_ e' aperta, e
il §5.3 mostra che **viene usata**. Su Fintokei si entra sapendo che **il
rischio non e' perdere la challenge: e' essere ristretti dopo averla vinta.**
Da cui la regola pratica: **prima challenge in taglia PICCOLA**, non 50k, e
**si porta a payout una volta prima di replicare su piu' conti**.

> ⚠️ **Nota di metodo, identica al vaglio KeyToProp:** questo verdetto e'
> costruito **senza aver aperto una sola pagina con i miei occhi**. Se Claudio
> apre `support.fintokei.com/en/articles/11315976` (rischio su trade aperti) e
> `.../6538826` (calcolo dei muri) **col suo browser**, chiarisce da solo la
> voce piu' importante di tutte — **e vale piu' di qualunque altra cosa in
> questo file.**

---

## 8. ✉️ LE 5 DOMANDE DA MANDARE AL SUPPORTO — regola D3, risposta scritta prima di ogni euro

Stesso formato delle mail gia' inviate (FTMO, FundedNext, Alpha, The5ers).

```
Oggetto: Pre-purchase rule clarifications — algorithmic multi-EA portfolio
         (MT5, ProTrader Swing)

Hello,

I run a portfolio of ~35 self-developed Expert Advisors on MT5. I own all the
source code, I built and tested every strategy myself. No martingale, no grid,
no HFT, no third-party or commercial EAs, no signals, no copy trading. Each EA
risks ~0.65% of the account per trade. Before purchasing a ProTrader Swing
evaluation I need five points in writing.

Q1 — THE 3% MAXIMUM RISK ON OPEN TRADES. This is my single most important
question. (a) Is the 3% limit applied PER INDIVIDUAL POSITION, or is it the
AGGREGATE risk across ALL simultaneously open positions on the account?
(b) If it is aggregate: I may have 6-9 independent EAs holding positions at
the same time, each with its own stop loss at ~0.65% of the account, for a
combined open risk of ~4-6%. Would that trigger a violation, even though no
single trade risks more than 0.65%? (c) Is the aggregate computed net of
correlation/hedging, or as a simple sum of the stop-loss distances? (d) When
a stop loss IS attached to every position, is VaR still applied on top, or
does the stop loss alone define the risk?

Q2 — CONSISTENCY RESTRICTIONS. Your FAQ states you "may apply a combination
of restrictions on an individual basis, depending on specific behavior", and
that the most common set is leverage cut to 1:10, plus a +1%/-1% daily
profit/loss cap. (a) What EXACTLY triggers these restrictions — is there a
numeric threshold I can monitor myself, or is it a discretionary review?
(b) Are they ever applied to a trader who has breached NO written rule?
(c) Are they permanent, or can they be lifted, and how? (d) Does receiving a
payout, or being consistently profitable, in itself increase the likelihood
of restrictions being applied?

Q3 — EXPERT ADVISORS AND "AT THE HELM". Your rules allow EAs when the trader
is the "creator or full owner" of the strategy — which I am, for all 35.
However you also state you look for "talented traders, not talented robots"
and that the trader must be "at the helm, not the robot". (a) Is a fully
automated portfolio of self-developed EAs running unattended on a VPS
acceptable under your rules? Please answer yes or no. (b) Is running MULTIPLE
different self-developed EAs on the SAME account acceptable? (c) You prohibit
"trading robots designed to pass a trading challenge": my EAs were developed
for long-term live trading, not for challenges — how do you distinguish the
two in practice?

Q4 — DRAWDOWN MECHANICS, CONFIRMATION IN WRITING. (a) Please confirm the
Maximum Loss on ProTrader Swing is 10% measured from the INITIAL balance and
is STATIC — it never trails an equity peak or a high-water mark, in evaluation
AND in the funded phase. (b) Please confirm the High-Water Mark is used ONLY
for payout/profit-split calculation and plays NO role in the loss limits.
(c) On ProTrader Swing, please confirm the daily 5% limit is anchored to the
previous day's closing BALANCE (closed trades only), so that floating profit
or loss carried overnight does NOT move the anchor. (d) What is the exact
reset time and timezone of the daily limit? (e) Is the intraday breach
measured on lowest EQUITY including floating P/L, tick by tick?

Q5 — NEWS, WEEKEND, LEVERAGE, PAYOUTS, PRICE. (a) Your FAQ says news trading
is allowed without restriction, but also that it "can be restricted on an
individual account as part of consistency measures" — under what conditions?
My EAs do not filter news and will trade through releases by design; is that
acceptable? (b) Please confirm holding positions overnight AND over the
weekend is permitted in evaluation and funded, with no time-window
restriction around the Friday close or Monday open. (c) Please confirm the
leverage on ProTrader Swing per asset class (FX, gold, indices), in both
evaluation and funded. (d) Is there any CAP on the payout amount per cycle?
(e) What is the exact price of the ProTrader Swing 50,000 EUR evaluation, and
is the fee refunded on the first payout? (f) What is the maximum total
allocation I may hold across ProTrader / ProTrader Swing accounts?

Thank you — I will not purchase before receiving these answers in writing.
```

> 📬 **AGGIORNAMENTO 27/08/2026: MAIL INVIATA.** Claudio ha mandato le 5
> domande al supporto Fintokei. **Nessun acquisto autorizzato finche' la
> risposta scritta (specialmente Q1, il cap 3% per-trade vs aggregato) non
> arriva e non entra agli atti** — regola D3. Il verdetto resta **IN
> SOSPESO** fino ad allora.

---

## 📬 RISPOSTA SCRITTA DI FINTOKEI — 27/08/2026 (support@fintokei.com, via Intercom)

`[RISPOSTA SCRITTA]` — rango massimo delle fonti, sopra le FAQ lette via search.
Risposta sintetica, punto per punto, con link agli articoli ufficiali:

- **Q1 — LA DOMANDA CHE DECIDEVA TUTTO IL VERDETTO:**
  > _"The 3% risk limit applies to **all open positions combined**, not just
  > individually."_
  🔴🔴 **È LA LETTURA PEGGIORE DELLE DUE. CONFERMATO: AGGREGATO, NON PER-TRADE.**
  Link: `support.fintokei.com/en/articles/11315976`.
- **Q2 — Consistency Restrictions:** confermano che scattano per violazione
  delle regole scritte **"and may also be applied at our discretion"** —
  🔴 la clausola discrezionale non viene smentita, viene **riconfermata a
  parole loro**.
- **Q3 — EA:** _"Self-developed, fully owned EAs are allowed; the standard is
  that the strategy logic and decisions must genuinely be yours."_ 🟡 **NON
  risponde al SI/NO diretto chiesto** ("un portfolio automatico di 35 EA che
  gira incustodito su un VPS è accettabile?") — resta la stessa formula
  generica della FAQ. Aggiunto un link nuovo, mai visto prima:
  `.../10419735-copy-trading-and-eas-what-is-allowed-and-what-prohibited`
  — **da leggere**, potrebbe contenere il criterio pratico che manca.
- **Q4 — muri:** nessuna informazione nuova, rimanda alle due FAQ già lette
  (`6538826`, `12058210`) — **confermano indirettamente** quanto gia' scritto
  al §3-4 (muro totale statico 10%, daily su balance per lo Swing).
- **Q5 — leva/weekend/news/conti:** rimanda alle FAQ gia' lette, piu' un link
  nuovo sul **rimborso**: `.../6921693-can-i-get-a-refund-for-my-purchase`
  — **da leggere**, rilevante per il prezzo/rimborso mai emerso al §4.

### ⚖️ COSA CAMBIA NEL VERDETTO — la condizione C-1 del §7 si e' risolta, in negativo

Il file prevedeva esattamente questo bivio (§7, "Le due condizioni per passare
a PROMOSSA"): _"Se il 3% e' aggregato → serve C-2, e comunque si scende a
riserva."_ **E' successo.**

🔴 **Aritmetica invariata, ora CONFERMATA e non piu' ipotetica:**
- cap Fintokei sul rischio aperto aggregato: **3,00%**
- nostro cap C1 **firmato**: **3,25%** — gia' sopra
- nostro rischio aperto **realmente misurato**: **5,85%** (03/08, 9 posizioni
  di 8 sedie) — quasi il doppio

🔴 **Fintokei, COSI' COM'E' OGGI LA FLOTTA, non passa.** Non per una bandiera
rossa di legittimita' (quella e' a posto, vedi §2 e §6) ma per un numero
nostro che non ci sta sotto il loro numero. La penale non e' la perdita del
conto: e' **leva tagliata a 1:10 + tetto ±1%/giorno** — un conto vivo ma
improduttivo (§5.2).

### 🚪 STATO ORA: **RISERVA, CONDIZIONATA A C-2 — decide Claudio**

Per passare da RISERVA a PROMOSSA serve **C-2**, esattamente come gia'
scritto al §7, e **non e' una modifica che si applica da questo file**:

1. Abbassare il cap C1 del Guardian da **3,25% a ≤ 2,50%** (margine sotto
   il 3% di Fintokei) — **proposta, non applicata: decide Claudio**.
2. **Rimisurare in forward** quanto spesso la flotta tocca davvero quella
   soglia col nuovo cap — il 5,85% del 03/08 dice che oggi il Guardian non
   ci tiene sotto il 3%, e non sappiamo se l'abbia mai fatto rispettare.
3. Restano da leggere i **due link nuovi** (copy-trading/EA, rimborso) prima
   di chiudere il fascicolo — potrebbero contenere il criterio pratico sulla
   Q3 che la risposta generica non ha dato.

🎯 **In una riga:** Fintokei resta un'ottima prop sulla carta (muri, leva,
tempo, EA-policy tutti passati), ma **la flotta cosi' com'e' oggi non ci
starebbe sotto il loro tetto di rischio aperto** — serve una decisione di
Claudio sul Guardian prima di riaprire il fascicolo, non un'altra mail.

---

## 9. 🧾 COSA NON HO POTUTO VEDERE — l'elenco onesto

1. 🔴🔴 **Se il cap del 3% sul rischio aperto e' PER TRADE o AGGREGATO.** Le
   fonti si contraddicono. **E' la voce che decide il verdetto**, e resta aperta.
2. 🔴 **Il prezzo esatto della ProTrader Swing 50.000 EUR** (la gamma generale
   e' $44-$2.399, ma la cella specifica non e' emersa).
3. 🟠 **Il target di fase 2 dello Swing**: 6% (coerente con ProTrader) o 5%
   (una fonte terza). **[INCERTO]**.
4. 🔴 **Se la fee viene rimborsata al primo payout.**
5. 🔴 **Il testo integrale dei Terms & Conditions legali** (ho letto la
   knowledge base `support.fintokei.com`, non il contratto).
6. 🟠 **La pagina blog sull'High-Water Mark** letta direttamente — la
   conclusione del §3 si regge su due FAQ ufficiali, non su quella pagina.
7. 🔴 **Il banner Trustpilot** "recensioni sollecitate/violazione linee guida":
   non emerso, **ma non escludibile** (WebFetch bloccato). Serve l'occhio di
   Claudio su `trustpilot.com/review/fintokei.com`.
8. 🟠 **La solidita' reale delle lamentele WikiFX**: sono racconti di trader,
   non atti. Il loro valore sta **solo** nel combaciare con una clausola scritta.
9. 🟠 **Il "Pilot Phase" con una regola di Maximum Loss all'1%** che il canale
   cita come test su un gruppo limitato di trader: **[INCERTO]** cosa sia e se
   possa diventare regola generale. 🔴 **Da tenere d'occhio: se diventasse
   standard, boccerebbe Fintokei istantaneamente.**
10. 🟠 **Due misure DI CASA che mancano e che qui servirebbero PRIMA di pagare:**
    (a) 🔴 **quante volte, in forward, la flotta supera il 3% di rischio aperto**
    — sappiamo solo che il 03/08 e' arrivata a **5,85%** e che il p99 e'
    **5,67%**, cioe' che **succede spesso**; (b) 🟠 se il cap C1 del Guardian
    stia davvero mordendo o se quel 5,85% sia passato indisturbato.

---

## 10. 📎 URL usati (tutti [LETTO-VIA-SEARCH 27/08/2026], nessuno aperto direttamente)

**Knowledge base ufficiale Fintokei:**
`support.fintokei.com/en/articles/6538826` (calcolo muri) ·
`.../6538822` (regole ProTrader) · `.../12058210` (ProTrader vs Swing) ·
`.../6538838` (EA) · `.../6538843` (news, weekend, overnight) ·
`.../6538829` (limite di tempo) · `.../8428030` (giorni minimi) ·
`.../8409192` (High-Water Mark) · `.../11315976` (rischio su trade aperti) ·
`.../11468666` (oversized risk) · `.../11315966` (consistency, applicazione) ·
`.../11315971` (consistency, altre restrizioni) ·
`.../11315949` (perche' applichiamo restrizioni) · `.../12017527` (perche' il
limite sul rischio aperto) · `.../6538847` (leva) · `.../6538886` (conti e
posizioni) · `.../6538884` (payout) · `.../9286450` (dimensione ordini) ·
`.../10166369` (profili multipli) · `.../8409176` (SwiftTrader) ·
`.../9680289` (StartTrader)

**Sito Fintokei:** `www.fintokei.com/it/` · `/protrader-swing/` · `/protrader/` ·
`/payouts/` · `/symbols/` · `/why-fintokei/` ·
`/blog/drawdown-high-water-mark-parameters-you-must-watch-when-trading-with-fintokei/` ·
`/blog/maximum-risk-on-open-trades-and-why-it-matters/` ·
`/blog/swing-traders-this-ones-for-you-meet-the-brand-new-protrader-swing-program/` ·
`/blog/fintokei-wins-the-award-for-the-most-popular-broker-backed-prop-firm/` ·
`/blog/forex-prop-reviews-says-it-all-fintokei-rocks/` ·
`/blog/fastest-payout-prop-firm/`

**Societarie / stampa di settore:**
`financemagnates.com` (espansione UE · payout €4M 2024 · instant withdrawals
+118%) · `fxnewsgroup.com` (intervista David Varga) · `tradingview.com/news/` ·
`propinsider.com/fintokei-launches-instant-withdrawals/` ·
`aziendabanca.it` (instant payout, IT)

**Reputazione / premi:**
`trustpilot.com/review/fintokei.com` · `x.com/PropFirmMatch/status/1883130902135574763` ·
`propfirmmatch.com/awards-2025` · `propfirmmatch.com/prop-firms/fintokei/reviews` ·
`wikifx.com/en/newsdetail/202509022884354296.html` (lamentele, sett. 2025) ·
`forexpropreviews.com/fintokei-new-protrader-swing-with-balance-based-daily-loss-limits/`

**Rassegne terze:** `propvator.com/fintokei/rules/` · `thetrustedprop.com/prop-firms/fintokei` ·
`lunefi.com` · `propnavi.io/en/firms/fintokei/` · `quantvps.com/prop-firms/fintokei` ·
`proptradingarea.com/prop-trading-firms/fintokei` · `tradingfinder.com/props/fintokei/rules/` ·
`fortunly.com/reviews/fintokei-review/` · `tradersunion.com/brokers/prop/view/fintokei/` ·
`propifycompare.com/firm/fintokei/` · `dealpropfirm.com/prop-firms/fintokei`

---

## 11. 🧭 DOVE SI COLLOCA NEL CENSIMENTO — la riga finale

| prop | muro totale | esito 26-27/08 |
|---|---|---|
| **FTMO** | 10% statico | 🟢 shortlist |
| **FundedNext** | statico | 🟢 shortlist |
| **Alpha Capital** | statico | 🟢 shortlist (bloccata dal debito `open_time`, min 2 min) |
| 🆕 **Fintokei ProTrader Swing** | 🟢 **10% STATICO** + 🟢 **daily su BALANCE** + 🟢 **leva 1:50 indici** | 🟠 **RISERVA — risposta scritta 27/08 conferma cap 3% AGGREGATO: la flotta com'e' oggi (5,85% misurato) non ci sta. Serve C-2 (abbassare C1 Guardian, decide Claudio) prima di riaprire** |
| **Key to Prop** | 🔴 trailing su picco equity | ❌ bocciata (27/08) |
| **Upcomers, E8** | 🔴 trailing | ❌ bocciate (26/08) |
| **FundingPips** | cap per idea 1,2% | ❌ bocciata (26/08) |

> 🎯 **AGGIORNAMENTO 27/08 pomeriggio: la risposta scritta e' arrivata, ed e'
> la lettura peggiore delle due su Q1 — "3% AGGREGATO su tutte le posizioni
> aperte insieme", non per singola posizione.** Fintokei resta sulla carta
> la prop con le regole migliori del censimento (muri, leva, tempo, EA), ma
> **il nostro rischio aperto reale (5,85%) e' quasi il doppio del loro tetto
> (3%), e il cap C1 firmato (3,25%) e' gia' sopra.** Non e' piu' una domanda
> aperta: e' una decisione di Claudio (abbassare il cap C1 del Guardian e
> rimisurare in forward) prima di poter comprare.
