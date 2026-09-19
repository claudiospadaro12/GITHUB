# 🏛️ LE PROP E GLI EA — TUTTO QUELLO CHE ABBIAMO GIÀ IN CASA

**19/09/2026 · archeologia nel repo, NON una caccia sul web.**
Richiesta testuale di Claudio: _«Vai con l'agente a vedere in passato cosa aveva
trovato e cosa ho postato io sulle prop. Quali accettano Ea, quali accettano ea
su post news»_.

🔒 **Nessun EA, preset, forward, conto reale `10105439` o taglia è stato toccato.**
Nessuna pagina web è stata aperta per questo file: **ogni riga viene da un file
che è già in questo repo**, e la fonte è scritta col numero di riga.

---

# 0. 🥇 LE QUATTRO RIGHE CHE RISPONDONO ALLA DOMANDA

> ## ① 🟢 **FTMO NON VIETA IL TRADING SULLE NOTIZIE NELLA FASE CHE PARTE LUNEDÌ.** E vale per tutti e due i tipi di conto.
> Citazione ufficiale, già in casa dal 13/08:
> _«Restrictions… apply only once you start trading on an FTMO Account. **They do
> not apply during the Evaluation Process**»_
> (`docs/REGOLAMENTO_FTMO_2026-08.md` **r.45**).
> 👉 **La challenge di lunedì non ha NESSUNA regola news, comunque sia andata la firma.**
> La decisione di stasera **non va rimessa in discussione per le news**: il rischio news
> su FTMO nasce dal **conto finanziato**, cioè fra settimane, non lunedì.

> ## ② 🔵 **«Leva 1:15» compare DUE VOLTE nel repo, e tutte e due le volte vuol dire CONTO SWING.**
> `docs/REGOLAMENTO_FTMO_2026-08.md` **r.131**: _«Leva: Standard **1:100**; Swing
> **1:30** (forex; **indici 1:15**, metalli 1:9 su Swing)»_ ·
> `report/QUALE_PROP_PER_I_NOSTRI_EA_2026-09-18.md` **r.158**: _«FTMO 2-Step SWING …
> **1:15** (e 1:9 su HK50/US2000/SPN35)»_.
> 👉 **Se è davvero lo Swing, è la notizia MIGLIORE possibile sul fronte news**:
> _«The FTMO Swing account type does **not have any restrictions** on trading during
> news releases»_ (r.48) — **mai, in nessuna fase, nemmeno da funded.**
> 🔴 **Ma è un'INFERENZA MIA, non un documento**: in repo non c'è nessuna prova
> d'acquisto. **Buco B1 del §5, e si chiude con uno screenshot.**

> ## ③ 🔴 **IL PREZZO DELLO SWING NON È UNA REGOLA: È IL MARGINE.**
> Con la leva **1:15** sugli indici, **una sola** posizione `U30USD` a rischio 0,65%
> su 100k impegna **~16.103 $** di margine, e cinque posizioni **~67.000 $ = il 67%
> del conto** (`QUALE_PROP_PER_I_NOSTRI_EA_2026-09-18.md` **r.195**, etichettato
> `[INFERITO]`). La rosa di lunedì ha **TRE sedie sullo stesso `U30USD`**.
> 👉 **Il pericolo vero di lunedì non è una regola scritta: è uno stop-out per
> margine.** Ed è un conto, non un'opinione.

> ## ④ 📰 **E LA FAMIGLIA `ABTG_PostNews` NON È NELLA ROSA DI LUNEDÌ — quindi oggi il problema news non la riguarda proprio.**
> Le sei sedie sono DAX Apertura, MaxMin DAX Short, Dow Apertura, EMA200 Dow,
> SuperWave Dow, MaxMin ORO: **nessun `ABTG_PostNews`**. E il motivo era già
> scritto il 10/09: _«~0,07 op/giorno, questa famiglia non costruirà un campione
> entro la challenge e non è candidabile»_ (`report/DIARIO.md` **r.10**).
> 🟢 **Su FTMO Swing sarebbe comunque ammessa**; su FundingPips e The5ers **no**, e
> per un motivo che non è la finestra (§2.3).

---

# 1. 🚨 CLASSE DI PROVA — da leggere PRIMA delle tabelle

🔴 **In questo repo NON ESISTE una sola pagina di prop letta direttamente.**
Il proxy d'ambiente blocca **tutti** i domini prop, e lo ha registrato **tre volte
in tre giornate diverse**: il **21/08**
(`backtest_pipeline/caccia_strategie/DOSSIER_NEWS_FILTER_2026-08-21.md` **r.25**,
_«ftmo.com ❌ EGRESS_BLOCKED → 🛑 FONTE NULLA»_), l'**08/09**
(`report/REGOLAMENTI_PROP_2026-09-08.md` **r.48**), il **18/09**
(`report/QUALE_PROP_PER_I_NOSTRI_EA_2026-09-18.md` **r.53**, _«8 domini su 8: CONNECT
tunnel failed, response 403»_).

| etichetta | che cosa vuol dire |
|---|---|
| **[POSTATO DA CLAUDIO]** | 🥇 materiale caricato da lui: testo copiato da un sito ufficiale, una mail, uno screenshot, un documento del corso. **È il rango più alto che abbiamo su questa materia** |
| **[LETTO-VIA-SEARCH]** | il motore di ricerca ha letto la pagina ufficiale e ne ha restituito il contenuto. **Nessuno di noi l'ha aperta** |
| **[INFERITO]** | dedotto, e dico da cosa |
| **[INCERTO]** | due fonti nostre in contrasto |
| **[NON VERIFICATO]** | mai ottenuto |

> 🔴 **Regola di casa, ancora valida: `report/PIANO_PROP.md` F4 — la challenge si
> compra solo dopo risposte SCRITTE del supporto.** Le domande sono pronte in
> `report/DOMANDE_SUPPORTO_PROP.md` **dal 13/08** e **non sono MAI state inviate**
> (r.3-7: _«DECISIONE DI CLAUDIO (13/08): INVIO RINVIATO»_).
> Il **18/09** abbiamo misurato quanto costa saltare quella porta: il muro del
> FundedNext Stellar Lite era `[MAI VERIFICATO]` **fino a poche ore prima della
> mail di breach** (`report/BREACH_FUNDEDNEXT_2026-09-18.md`).

## 1bis. 📅 L'ETÀ DELLE INFORMAZIONI — e perché la soglia dei 60 giorni non morde

Claudio ha chiesto di marcare 🔴 tutto ciò che ha più di 60 giorni. **Applicata
alla lettera, quella regola non cattura NIENTE**: il materiale in repo va dal
**13/08** al **18/09**, cioè **1-37 giorni**. Dirlo e basta sarebbe però un falso
senso di sicurezza, quindi uso **due assi insieme**:

| età | classe | trattamento |
|---|---|---|
| 0-14 gg (dal 05/09) | 🟢 fresca | usabile |
| 15-40 gg (13/08 → 04/09) | 🟠 **da riconfermare** — le prop cambiano le regole senza avvisare, e ne abbiamo la prova in casa: FundingPips ha vietato il weekend sui Master **dal 29/01/26**, cambio retroattivo (`report/SCHEDA_SECONDA_PROP.md` r.8) | riconfermare prima di agire |
| **senza data** | 🔴 **DA RIVERIFICARE, sempre** | le **13 trascrizioni** postate da Claudio: **nessuna porta una data**, e una parla di una challenge _«iniziata il 14 novembre»_ → è di **un altro anno** (§3) |

---

# 2. 📊 LA TABELLA MADRE

## 2.1 🤖 EA — quali prop li accettano

| prop / prodotto | **EA ammessi?** | **limiti** | fonte (file · riga) | data | stato |
|---|---|---|---|---|---|
| **FTMO** (Standard e Swing) | ✅ **SÌ** — _«As long as your trading is legitimate… FTMO has no reasons for limiting or restricting your trading strategy, whether it's discretionary trading, **algorithmic trading, EAs**»_ | ❌ >**2.000 richieste server/giorno** = "hyperactive" · ⚠️ tetto **400.000 $ per trader O PER STRATEGIA** · ❌ terzi sul conto / copy di gruppo · ⚠️ EA **commerciali** di terzi a rischio tetto → **i nostri proprietari sono il caso ideale** | `docs/REGOLAMENTO_FTMO_2026-08.md` **r.34-36**, **r.89-97**, **r.110** | 13/08 | 🟠 LETTO-VIA-SEARCH, da riconfermare |
| **FundedNext** (Stellar 2-Step / Lite / 1-Step) | ✅ **SÌ** — _«EAs and custom indicators are allowed»_ | 🔴 **EA usage fee: add-on A PAGAMENTO** (un conto comprato senza add-on è un conto su cui gli EA non sono attivi) · ❌ HFT (ms-secondi), QuickStrike, tick scalping, **grid**, arbitraggio, latency, iperattività · ✅ **hedging SÌ ma solo DENTRO LO STESSO CONTO** · ❌ vietato passare la challenge con EA e poi operare a mano · tetto 300k/strategia | `report/QUALE_PROP_PER_I_NOSTRI_EA_2026-09-18.md` **r.159-161** · `report/SCHEDA_SECONDA_PROP.md` **r.117** · **[POSTATO DA CLAUDIO]** `trascrizioni_2026-08-18/I found the Best Prop Firm That Allows EAs.txt` (elenco completo dei divieti, letto dal ToS in video) | 18/09 · 18/08 | 🟠 |
| **The5ers** (High Stakes) | ⚠️ **SÌ, con restrizioni che ci colpiscono** | 🔴 _«**bulk or simultaneous automated orders**»_ fra i pattern ristretti · ⚠️ EA di terzi di cui non possiedi il sorgente · ❌ scalping in rollover, bid-ask arbitrage | `QUALE_PROP…_2026-09-18.md` **r.162** · `report/REGOLAMENTI_PROP_2026-09-08.md` **r.96** | 18/09 | 🟠 |
| **FundingPips** | ⚠️ **SÌ SOLO SE L'EA È NOSTRA** — _«If the EA is your own, developed by you, **full automation is permitted** with proof of ownership»_; EA di terzi **solo** come risk manager | ❌ copy fra utenti e gestione da terzi = **chiusura** · ❌ server spamming, HFT, gap trading | `report/REGOLAMENTI_PROP_2026-09-08.md` **r.96** · `QUALE_PROP…` r.161 | 08/09 | 🟠 |
| **E8 Markets** | ✅ **SÌ** — _«you can use any EA»_ | ❌ stessa strategia condivisa fra utenti (una strategia per utente) | `report/REGOLAMENTI_PROP_2026-09-08.md` **r.96** | 08/09 | 🟠 |
| 🔴 **Alpha Capital** | ❌ **NO, ESCLUSA** — _«Automated EAs that execute trades independently, without human oversight, are **strictly prohibited** and will not be approved under any circumstances»_ | ammesse solo EA di **risk-management pre-approvate** (invio dell'EX5 al supporto) | `report/REGOLAMENTI_PROP_2026-09-08.md` **r.96** | 08/09 | 🟠 **ma è un NO netto, ripetuto identico l'08/09 e il 18/09** |
| **Orbit Funded** (1M Instant, $999) | 🔴 **[INCERTO — CRITICO]** | non trovato | `backtest_pipeline/caccia_strategie/DOSSIER_PROP_ORBITFUNDED_2026-08-30.md` **riga 11 della tabella** | 30/08 | 🔴 **MAI VERIFICATO** |
| **FunderFX / FundedTradingPlus / XT Prop** | ⚠️ citate come "permissive sugli EA" **solo in un video** | — | **[POSTATO DA CLAUDIO]** `trascrizioni_2026-08-18/Top 3 Prop Firms For EA Trading.txt` | **senza data** | 🔴 **MAI VERIFICATO — video affiliato, vedi §3** |

### 🎯 La risposta secca alla prima domanda
**Accettano gli EA: FTMO · FundedNext · The5ers · FundingPips · E8.**
**Li vieta: Alpha Capital.**
🔴 **Ma per la NOSTRA flotta le clausole che mordono non sono quelle sugli EA: sono
quelle sul "molte sedie che aprono insieme".** The5ers vieta per nome i _«bulk or
simultaneous automated orders»_, e la nostra flotta apre **più sedie nello stesso
minuto d'apertura** (DAX 08:00, Dow 14:30 server) — è **esattamente** la forma
descritta (`QUALE_PROP…_2026-09-18.md` **r.354**, trappola `T-5ERS`).

## 2.2 📰 NEWS — i quattro tipi, che NON vanno confusi

| tipo | che cosa vieta | chi lo usa |
|---|---|---|
| **T1 — finestra di ESECUZIONE** | vietato **aprire *o chiudere*** entro ±X min (**incluse le esecuzioni di pendenti, SL e TP**) | FTMO (funded Standard), The5ers, E8, FundingPips (Master) |
| **T2 — vietato TENERE** attraverso la notizia | — | 🟢 **NESSUNA delle prop censite.** FTMO scrive l'opposto: _«You are allowed to hold open positions… if they were opened more than 2 minutes before the restricted event»_ (`docs/REGOLAMENTO_FTMO_2026-08.md` **r.47**) |
| **T3 — libero in VALUTAZIONE, vincolato da FUNDED** | la regola compare solo sul conto finanziato | **FTMO**, FundingPips, FundedNext, E8 |
| **T4 — 💰 penale ECONOMICA, non breach** | il trade è lecito ma il **profitto** viene decurtato | FundedNext (**40%** del profitto conta), FundingPips, The5ers |
| **T5 — 🔴 divieto di STRATEGIA** (non di minuti) | vietato *fare* news trading, comunque e quando | **FundingPips**, **The5ers** |

| prop | **tipo** | **finestra esatta** | **quali eventi** | **in valutazione?** | **da funded?** | **`ABTG_PostNews` (+45′) ammesso?** | fonte (file · riga) | data |
|---|---|---|---|---|---|---|---|---|
| 🟢 **FTMO SWING** | **nessuna** | — | — | ❌ no | ❌ **no** — _«does not have **any** restrictions on trading during news releases»_ | ✅✅ **SÌ, senza condizioni** | `docs/REGOLAMENTO_FTMO_2026-08.md` **r.48** | 13/08 |
| **FTMO Standard** | **T1 + T3** | **−2 min → +2 min**, e vieta anche di **CHIUDERE**: _«including pending orders (such as Stop Loss or Take Profit)… **if a Stop Loss or Take Profit is triggered within the restricted time window, this will also be considered a breach**»_ | **lista chiusa**, vedi §3.1 | ❌ **NO** (r.45) | ✅ sì | ✅ per la lettera (entriamo a +45′) ⚠️ ma vedi trappola `T-FTMO-2` | `docs/REGOLAMENTO_FTMO_2026-08.md` **r.44-47** | 13/08 · lista **[POSTATO DA CLAUDIO 04/09]** |
| **FundedNext** | **T4 + T3** | **−5 → +5 min** | _«listed high-impact news»_ sul simbolo colpito | 🟢 **nessun vincolo, in TUTTE le challenge** | ✅ solo il **40%** del profitto conta, il 100% della perdita sì | ✅ **SÌ**, e in valutazione senza penali | `QUALE_PROP…_2026-09-18.md` **r.230** · `SCHEDA_SECONDA_PROP.md` **r.98** | 18/09 |
| 🔴 **The5ers** | **T1 + T5** | **−2 → +2 min** sull'esecuzione; **tenere è permesso** | high-impact | ✅ sì | ✅ sì | 🔴 **NO** — il _«bracketing strategy … opening buy and sell stops close to the price»_ su notizia high-impact è **pratica proibita PER NOME** | `QUALE_PROP…_2026-09-18.md` **r.231** | 18/09 |
| 🔴 **FundingPips** | **T5 + T1/T4 sul Master** | Master: **−5 → +5 min**; **DISCORSI: −10 min dall'inizio a +10 min dalla FINE** | calendario proprio in dashboard | 🔴 _«purposely trading news in **both evaluation and master phase** is prohibited and will lead to account closure»_ | ✅ sì | 🔴 **NO**, e due volte: divieto di strategia **+** la finestra "discorsi" copre **un'ora intera** di conferenza BCE | `QUALE_PROP…_2026-09-18.md` **r.232** | 18/09 |
| 🟠 **E8** | **T1**, dipende dal prodotto | **−5 → +5 min** | high-impact | 🟢 nessuna su E8 Classic fasi 1-2 | dipende | 🟠 **[INCERTO]** — le pagine prodotto dicono «nessuna restrizione», la Trading Policy vieta per nome _«capitalizing on the initial surge following news releases»_ | `QUALE_PROP…_2026-09-18.md` **r.233**, buco 3 **r.411** | 18/09 |
| **Alpha Capital** | T1 | **5 minuti** | — | — | — | — (già fuori: vieta gli EA) | `report/REGOLAMENTI_PROP_2026-09-08.md` **r.100** | 08/09 |
| **Orbit Funded** | 🔴 **[INCERTO]** | — | — | — | — | — | `DOSSIER_PROP_ORBITFUNDED_2026-08-30.md` riga 12 | 30/08 |

### 🎯 La risposta secca alla seconda domanda
> # ✅ **Un EA che entra DOPO la notizia è ammesso dove la regola è scritta in MINUTI. Dove è scritta in INTENZIONI, no.**
> **Ammettono il post-news**: 🟢 **FTMO Swing** (nessuna finestra, mai) · 🟢 **FTMO
> Standard in valutazione** · 🟢 **FundedNext** (tutte le challenge, senza penale;
> da funded solo il taglio del 40% **dentro** i ±5 min) · 🟠 **E8 Classic** in fase 1-2 `[INCERTO]`.
> **NON lo ammettono**: 🔴 **The5ers** · 🔴 **FundingPips** — e non per la finestra:
> **per il divieto di strategia**, che la finestra non aggira.

### ⚠️ E la cosa onesta da scrivere: **la nostra forma È un bracket**
BUY STOP a max+3 pip e SELL STOP a min−3 pip in OCO, su un giorno di conferenza
stampa. **L'unica differenza dal bracketing vietato è QUANDO** (+45 minuti invece
che prima). 👉 È una differenza vera e difendibile, **ma deve dirla LORO per
iscritto, non noi**: nessun regolamento letto distingue il bracket *pre-news* da
quello *post-news* (`QUALE_PROP…_2026-09-18.md` **r.269**).

## 2.3 🧱 I MURI, per completezza (è il criterio che ha già ucciso un conto)

| prodotto | daily | base di calcolo | totale | regge il **p99 8,1%** di `METRO_PROP.md`? | reset in **ora server BCM** |
|---|---:|---|---:|---|---|
| **FTMO 2-Step** | **5%** | 🟢 **SALDO alle 00:00 CE(S)T** | **10% STATICO** | ✅ sì, margine 1,9 pt | **23:00** ✅ = il nostro `InpDailyResetHour=23` |
| FundedNext Stellar 2-Step | 5% | inizio giornata | 10% statico | ✅ sì | 22:00 ⚠️ |
| 🔴 FundedNext Stellar **Lite** | **4%** | inizio giornata | **8%** | 🔴 **NO: 8,1 > 8,0** | 22:00 ⚠️ |
| The5ers High Stakes | 5% `[INCERTO]` | 🟢 max(equity, saldo chiusura ieri) | 10% | ✅ sì | 22:00 ⚠️ |
| The5ers Hyper Growth | 3% 🟢 **PAUSA, non breach** | giornata | **6%** | 🔴 NO | 22:00 ⚠️ |
| E8 Classic | 4% | saldo inizio giornata | **8%** | 🔴 NO | `[INCERTO]` |
| FundingPips 2 Step | 5% | 🟢🟢 max(saldo, equity) apertura | 10% statico | ✅ sì | 22:00 ⚠️ |

Fonte unica di questa tabella: `report/QUALE_PROP_PER_I_NOSTRI_EA_2026-09-18.md`
§2.1-2.2 (r.80-130) · `report/REGOLAMENTI_PROP_2026-09-08.md` §2.1.
🟢 **FTMO è l'unica prop censita per cui il Guardian è già tarato giusto sull'ora
di reset.**

---

# 3. 📂 COSA HA POSTATO CLAUDIO — il materiale caricato da lui

Quattro depositi distinti. **E il più prezioso non sono i video.**

## 3.1 🥇 LA TABELLA DEGLI EVENTI RISTRETTI FTMO — copiata da lui dal sito, il 04/09
`docs/REGOLAMENTO_FTMO_2026-08.md` **r.50**, etichetta testuale:
_«✅ [VERIFICATO 04/09/2026, **fonte Claudio — testo copiato direttamente da
ftmo.com**]»_.

> 🥇 **È l'UNICO pezzo di regolamento prop in tutto il repo che non passa da un
> motore di ricerca.** In un progetto dove 8 domini su 8 sono in 403, questo è il
> rango più alto che abbiamo — e lo ha portato lui.

| strumento colpito | annunci ristretti |
|---|---|
| **USD** — coppie FX con USD, 🔴 **XAUUSD**, 🔴 **indici USA US2000/US500/US100/US30**, DXY | Federal Funds Rate & Statement · **Non-Farm Employment Change** · Unemployment Rate & Wages · GDP q/q (advance) · FOMC minutes · **CPI y/y** (**NON** CPI m/m) |
| **EUR** — *coppie FX con EUR* | ECB Main Refinancing Rate |
| GBP · CAD · AUD · NZD · CHF (coppie FX) | tassi + CPI + occupazione, per valuta |
| USOIL/UKOIL | Crude Oil Inventories |

**Fuori dalla lista, quindi MAI ristretti**: ISM Manufacturing, ISM Services,
CB Consumer Confidence, Retail Sales USD, PPI USD, **CPI m/m USD** (r.66-71).

🔴 **E la riga che conta per la rosa di lunedì**: la colonna USD nomina
**`XAUUSD` e gli indici USA per esteso**, ma **il DAX non compare da nessuna
parte** — la riga EUR parla solo di *«coppie FX con EUR»*. 👉 Ne segue che **le
due sedie DAX non sono su strumento ristretto** — ⚠️ **ma è un'inferenza per
ASSENZA**, la classe di errore che il 10/09 ci è costata una giornata (regola del
contro-esempio). **Va confermata, non usata come scudo** (buco **B3**).

## 3.2 📼 LE 13 TRASCRIZIONI — `backtest_pipeline/caccia_strategie/trascrizioni_2026-08-18/`
Caricate il 18/08. Dodici parlano di prop + EA, una è la live di Paolo.
**Analizzate dal cacciatore in `ANALISI_TRASCRIZIONI_2026-08-18.md`, e il suo
verdetto sull'indipendenza va usato così com'è:**

> 🔴 **12 video ≠ 12 fonti: sono 7.** Un solo canale (Petko / EA Forex Academy)
> copre **4 video** — _«contano come 1»_ (`ANALISI_TRASCRIZIONI_2026-08-18.md`
> **r.26-29**). Tutti i canali sono **affiliati o venditori** di EA/app.

**Che cosa dicono di utile sulle prop** (tutto **[POSTATO DA CLAUDIO]**, tutto
**senza data**, tutto 🔴 **DA RIVERIFICARE**):

| fonte | contenuto | incrocio col nostro materiale |
|---|---|---|
| `I found the Best Prop Firm That Allows EAs.txt` | 🥇 **il più sostanzioso**: legge il ToS FundedNext a voce. EA ✅ ammessi; vietati **HFT, QuickStrike, latency, latency da altri conti, arbitraggio, tick scalping, grid, side betting/account rolling, iperattività**. 🟢 **_«hedging è permesso solo NELLO STESSO conto»_** · 🔴 _«se ho un EA EURUSD in un conto e un altro EURUSD in un ALTRO conto… è hedging cross-account, proibito»_. Stellar **1-Step: 3% daily / 6% totale**; 2-Step 5%/10% | ✅ **CONFERMA** `REGOLAMENTI_PROP_2026-09-08.md` r.96 e `QUALE_PROP…` r.159. 🔴 **E AGGIUNGE UNA COSA CHE NON AVEVAMO**: se un giorno girassimo la stessa flotta su **due** conti prop, le sedie long e short sullo stesso simbolo diventano hedging cross-account = **vietato**. Rilevante: `770101` (DAX long) e `770411` (DAX **short**) sullo stesso simbolo |
| `Top 3 Prop Firms For EA Trading.txt` | classifica: **FunderFX** ("libertà di EA, overnight, weekend, **news**"), **FundedTradingPlus**, **FundedNext** 3ª | 🔴 **INUTILIZZABILE COME FONTE**: traduzione automatica degradata ("FungerFX", "firme proppi"), **zero date**, canale affiliato, e afferma che *«FundedNext permette una sola posizione alla volta»* — **cosa che nessuna nostra fonte conferma e che il video §sopra contraddice**. 👉 **Conflitto dichiarato: vince il nostro materiale.** |
| `This Prop Firm Robot Passed 1,000 Challenges.txt` (Titan X / Blue Edge) | dichiara un "news filter" e un "Max Daily Loss" dentro l'EA | ✅ conferma che **il filtro news è un componente standard** di una EA da prop. 🔴 **Nessun numero in minuti** (`ANALISI_TRASCRIZIONI_2026-08-18.md` **r.53**: _«Nessun video dà finestre in minuti»_) |
| `#1 Prop Firm HACK How to hide your EAs in Challenges.txt` | insegna a **nascondere** gli EA alla prop | 🔴 **Segnalato dal cacciatore come da NON seguire** (`ANALISI_TRASCRIZIONI_2026-08-18.md` **r.10-13**): _«violare i termini di una prop = conto perso»_. Serve solo a capire **cosa cercano** le prop |
| `Prop EA Review` (Petko) | _«usa solo firme con drawdown **STATICO**, non trailing»_ · FTMO **4 giorni minimi** | ✅ coincide con `METRO_PROP.md` §1 e col dossier FTMO r.16 |

🔴 **Il buco che le trascrizioni NON colmano, e il cacciatore lo ha già scritto:**
_«Qualcuno detta l'ora di reset del muro giornaliero e il fuso? **❌ NO.** …
Qualcuno detta valori di filtro news in minuti? **❌ NO.**»_
(`ANALISI_TRASCRIZIONI_2026-08-18.md` **r.52-53**).

## 3.3 📑 I DOCUMENTI DEL CORSO — `corso_documenti_2026-08-18/`
Quattro file (3 `.pptx` + 1 `.pdf`). **Non parlano di prop.** Ma dentro *Piano di
Trading America* e *Strategia Nasdaq* c'è una regola di metodo sulle notizie,
testuale dalle slide:

> _«Le notizie a 3 tori, identificate con il colore rosso, sono quelle notizie che
> impattano maggiormente. **Se abbiamo operazioni in macchina o pendenti, prima di
> ogni rilascio di un dato a 3 tori, vado a togliere tutto.**»_

🔴 **Questa è la regola del corso che Claudio ha comprato, ed è esattamente quella
che la nostra flotta NON applica**: verificato preset per preset, **tutte e sei le
sedie di lunedì hanno `InpUseNewsFilter=false`** (§4). Non è una violazione di
regolamento prop — **è una distanza fra il metodo scritto e il codice che gira**,
e va detta.

## 3.4 📧 IL MATERIALE OPERATIVO POSTATO DA CLAUDIO
| cosa | dove | valore |
|---|---|---|
| **La mail di breach FundedNext del 18/09** | `report/BREACH_FUNDEDNEXT_2026-09-18.md` **r.11-13** | 🥇 documento primario: _«Daily Loss Limit: $4000 · Total Loss: $4209.43 · Equity: $99048.73»_ |
| **La verifica del 4% sul suo account** | idem **r.45** — **[VERIFICATO DA CLAUDIO sul suo account, 18/09]** | 🥇 ha chiuso a mano un parametro che era `[MAI VERIFICATO]` |
| **L'ad Orbit Funded** (screenshot + nota) | `docs/prop_offerte/NOTA_OrbitFunded_1M_20260830.md` + `.jpg` | 🟠 marketing: 10% statico / 5% daily / no consistency. 🔴 **EA e news: [INCERTO]** |

---

# 4. 🔴 FTMO: COSA CAMBIA PER LUNEDÌ — verdetto SEDIA PER SEDIA

**Premessa, e va letta per prima:**
🟢 **In fase di valutazione, su FTMO, NON esiste nessuna regola news** — né su
Standard né su Swing (`docs/REGOLAMENTO_FTMO_2026-08.md` r.45). **Quindi nessuna
delle sei sedie è toccata da una regola news LUNEDÌ.** Le colonne qui sotto dicono
che cosa succederebbe **sul conto finanziato**, cioè fra settimane — ed è lì che si
decide **adesso** se serve il conto Swing.

Orari e filtri **letti oggi, preset per preset** `[VERIFICATO]` — in due set
indipendenti, e **danno lo stesso risultato**: `mql5/Presets/sedie_piccolo/recupero2/`
(le sedie del `50503392`) e i `..._100K.set` del dry-run. 🔴 **`InpUseNewsFilter=false`
in tutti e due i set, per tutte e sei le sedie.**

Orari e simboli:

| magic · sedia | simbolo | orari (**ora server BCM**) | 🔴 strumento **RISTRETTO** FTMO? | filtro news nel preset | **lunedì (valutazione)** | **da funded STANDARD** | **da funded SWING** |
|---|---|---|---|---|---|---|---|
| **`770101`** DAX Apertura EU | `D30EUR` | ingresso **08:00** (=09:00 IT) · chiusura **17:00** · pendenti 120′ | 🟢 **NO** *(inferito per assenza, §3.1)* | `InpUseNewsFilter=false` | 🟢 **nessun problema** | 🟢 ok *(se l'inferenza regge)* ⚠️ ma **BCE alle 13:15 server** cade dentro la sua finestra di apertura: se il DAX fosse targeted, uno SL lì dentro sarebbe breach | 🟢 **ok, sempre** |
| **`770411`** MaxMin DAX Short | `D30EUR` | box 23:00-04:59 · pendenti **07:00** · cutoff 08:00 · chiusura **17:00** | 🟢 **NO** *(inferito)* | `false` | 🟢 **nessun problema** | 🟢 ok *(stessa riserva)* | 🟢 **ok** |
| **`770202`** Dow Apertura US | `U30USD` | ingresso **14:30** (=**15:30 IT, l'apertura USA**) · chiusura **17:00** | 🔴 **SÌ** — *«indici USA US30»* | `false` | 🟢 **nessun problema** | 🟠 **rischio REALE ma non all'ingresso**: NFP e CPI escono alle **13:30 server**, cioè **un'ora PRIMA** che apra. Il rischio è che un **SL/TP** scatti nei ±2 min di un evento successivo | 🟢 **ok** |
| **`771531`** EMA200 Dow | `U30USD` | cutoff ingressi **19:00** · chiusura venerdì **20:00** · nessun `InpCloseHour` | 🔴 **SÌ** | `false` *(ma la manopola c'è: `InpNewsBeforeMin=60`, `InpNewsAfterMin=30`)* | 🟢 **nessun problema** | 🔴 **LA PIÙ ESPOSTA DELLE SEI**: può avere posizione aperta alle **19:00 server = 20:00 IT = FOMC**. Un SL/TP lì dentro = _«this will also be considered a breach»_ | 🟢 **ok** |
| **`770511`** SuperWave Dow | `U30USD` | 🔴 **`InpStartHour=0` / `InpEndHour=24`** = sempre | 🔴 **SÌ** | `false` | 🟢 nessun problema news ⚠️ **ma vedi `T-FTMO-2` sotto** | 🔴 **doppiamente esposta**: 24h su strumento ristretto **+** obbligo di chiusura pre-weekend e per rollover >2h | 🟢 **ok** |
| **`770402`** MaxMin ORO | `XAUUSD` | box 23:00-04:59 · pendenti **07:00** · chiusura **17:00** | 🔴 **SÌ — `XAUUSD` è NOMINATO per esteso** | `false` | 🟢 **nessun problema** | 🔴 **grave**: la posizione è viva dalle 07-08 alle 17:00 server, quindi **attraversa le 13:30 server (NFP/CPI)** ogni volta. Uno SL sull'oro su NFP = breach | 🟢 **ok** ⚠️ **ma vedi il margine: metalli su Swing 1:9** |

## 4.1 🪤 LE DUE COSE CHE MORDONO **ANCHE LUNEDÌ**, anche su Swing

Le *Forbidden Trading Practices* **non sono regole di conto**: valgono **sempre,
anche su Swing e anche in Challenge** (`docs/REGOLAMENTO_FTMO_2026-08.md` **r.83**,
nota finale).

| # | clausola | chi tocca, della rosa | perché |
|---|---|---|---|
| **T-FTMO-2** | 🔴 **«gap trading»**: _«opening simulated trades (i) **when major global news, macroeconomic events… are scheduled**…, or (ii) **two hours or less before a relevant financial market is closed for at least two hours**»_ | ⚠️ **`770511` SuperWave** (`0-24h`: può aprire il venerdì **entro 2 ore dalla chiusura del weekend** = la lettera (ii)) · ⚠️ in teoria chiunque apra in un giorno di dato macro, clausola **(i)**, che è **discrezionale** | È **l'unica clausola che può squalificare un conto che rispetta TUTTE le soglie numeriche.** Va chiesta per iscritto |
| **Risk management «market standard»** | vietate _«substantially larger or smaller position sizes compared to other trades»_ | 🟢 **nessuno** | Il nostro rischio **fisso** per trade è _«perfetto»_ per questa clausola (`docs/REGOLAMENTO_FTMO_2026-08.md` **r.97**) |

## 4.2 🔴 IL VERO PERICOLO DI LUNEDÌ NON È UNA REGOLA: È IL MARGINE A 1:15

| leva | margine 1 posizione `U30USD` a 0,65% su 100k | 5 posizioni |
|---|---:|---:|
| 1:50 (FTMO **Standard**, indici) | 4.831 $ | ~20.000 $ ✅ |
| 🔴 **1:15 (FTMO SWING, indici)** | **16.103 $** | 🔴 **~67.000 $ = 67% del conto** |

Fonte: `report/QUALE_PROP_PER_I_NOSTRI_EA_2026-09-18.md` **r.190-196**, etichettato
**`[INFERITO]`** (assume 1 $/punto indice per lotto, contract size 1, **specifiche
del broker FTMO mai lette**).
🔴 **La rosa di lunedì ha TRE sedie su `U30USD`** (`770202`, `771531`, `770511`)
**+ una su `XAUUSD`** — e sullo Swing i **metalli stanno a 1:9**
(`docs/REGOLAMENTO_FTMO_2026-08.md` r.131), cioè **peggio** degli indici.
⚠️ **E i margini di `D30EUR` e `XAUUSD` non li abbiamo MAI calcolati** (buco **B4**).

> ## 👉 **IL VERDETTO PER LUNEDÌ, in una riga**
> 🟢 **Nessuna regola news di FTMO ferma nessuna delle sei sedie lunedì: la scelta
> NON va rimessa in discussione per le notizie.**
> 🔴 **Ma se il conto è davvero Swing (1:15), va rifatto il conto del MARGINE prima
> di accendere sei sedie, e vanno guardate `770511` (24h, clausola gap trading) e
> `770402` (oro a 1:9).** E la decisione su quante sedie/che taglia **è una firma di
> Claudio**, non mia.

---

# 5. 🕳️ I BUCHI — cosa NON sappiamo, e come si chiude ognuno

| # | buco | perché costa | **come si chiude** | chi |
|---|---|---|---|---|
| 🔴 **B1** | **Standard o Swing?** In repo **non c'è nessuna prova d'acquisto FTMO.** Tutto il §4 poggia sull'inferenza "1:15 ⇒ Swing" | decide **tutto**: news da funded, weekend, margine, e se la rosa da sei sedie entra o no | **Uno screenshot della dashboard FTMO** (tipo conto + leva per simbolo) oppure la mail d'ordine. **Costa 30 secondi** | **Claudio** |
| 🔴 **B2** | **Le domande al supporto FTMO sono pronte dal 13/08 e MAI INVIATE** (`report/DOMANDE_SUPPORTO_PROP.md` r.3) | la clausola **gap trading** può squalificare un conto che rispetta tutti i numeri | Inviare le 3 già scritte (gap, bracket OCO, conti multipli) + le 2 nuove del 18/09. **Risposta SCRITTA, salvata in PDF** | **Claudio** (dal suo account) |
| 🔴 **B3** | **Il DAX è "targeted" da FTMO?** La nostra conclusione «no» è un'inferenza **per assenza** dalla tabella postata da Claudio | se il DAX fosse targeted, **`770101` e `770411` diventano esposte** (BCE alle 13:15 server, dentro la loro finestra) | domanda secca al supporto: *«Is GER40/DE40 a targeted instrument for the ECB Main Refinancing Rate restriction?»* | **Claudio** / supporto |
| 🔴 **B4** | **Il margine di `D30EUR` e `XAUUSD` a leva Swing non è MAI stato calcolato**, e quello di `U30USD` è `[INFERITO]` con specifiche di contratto **mai lette** | è il rischio n.1 di lunedì (stop-out per margine, non per drawdown) | leggere le **specifiche di contratto** sul terminale FTMO appena è attivo (contract size, valore punto, margine richiesto) e rifare il conto sulle **6 sedie vere** | **cacciatore-config-prop** + screenshot di Claudio |
| 🟠 **B5** | **1:9 su Swing = metalli o alcuni indici?** 🔴 **Due nostri file si contraddicono**: `docs/REGOLAMENTO_FTMO_2026-08.md` r.131 dice *metalli*; `QUALE_PROP…_2026-09-18.md` r.158 dice *HK50/US2000/SPN35*. Stesso rango, nessuno vince | l'oro `770402` è in rosa: 1:30 o 1:9 cambia il margine di **3,3 volte** | stessa lettura di B4 (specifiche a terminale) | **cacciatore-config-prop** |
| 🟠 **B6** | **The5ers daily: 5% o 3%?** `[INCERTO]` da due pagine dello stesso sito · **Hyper Growth statico o trailing?** `[INCERTO]` | solo se FTMO cadesse | pagina ufficiale + supporto | **cacciatore-config-prop** |
| 🟠 **B7** | **E8: contraddizione news non risolta** (prodotto dice «libero», policy vieta «capitalizing on the initial surge») | idem | idem | **cacciatore-config-prop** |
| 🟠 **B8** | **Orbit Funded: EA e news [INCERTO], mai trovati** | Claudio ha postato l'ad il 30/08 e la risposta non c'è ancora | ToS ufficiale + supporto. ⚠️ Prodotto "instant funding": categoria diversa | **cacciatore-config-prop** |
| 🔵 **B9** | **Nessuna prop firm ha MAI risposto a noi per iscritto.** Zero mail, zero chat salvate | è la regola **F4** di `PIANO_PROP.md`, ed è **aperta dal 13/08** | vedi B2 | **Claudio** |
| 🔵 **B10** | Il canale del **filtro news** (`data/abtg_news.csv`) è stato riparato **oggi** ed è ancora **magro: 16 righe, ferme al 14/09** (verificato oggi) | se un giorno servisse un filtro news vero (conto Standard funded), oggi **non lo avremmo** | riempire e verificare la sorgente prima di qualunque conto funded Standard | squadra news/VPS |

---

# 6. 📌 IN UNA RIGA
**Accettano gli EA: FTMO, FundedNext, The5ers, FundingPips, E8 — li vieta Alpha
Capital.** **Accettano il post-news: FTMO (Swing sempre, Standard in valutazione) e
FundedNext — lo vietano The5ers e FundingPips, e non per la finestra ma per
l'intenzione.** **FTMO non ha nessuna regola news nella fase che parte lunedì**, per
tutti e due i tipi di conto: 🟢 **la firma non va rimessa in discussione per le
notizie.** 🔴 **Va invece chiuso stasera un buco più banale e più caro: quale conto
abbiamo comprato, e se sei sedie entrano nel margine a 1:15.**

---
*Nessun EA, preset, forward, conto reale o taglia toccato. Nessuna pagina web
aperta: tutte le fonti sono file di questo repo, citati con la riga.*
