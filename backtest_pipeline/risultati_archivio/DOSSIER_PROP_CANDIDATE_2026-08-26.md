# 🏛️ DOSSIER PROP CANDIDATE — la prima challenge di Claudio (26/08/2026)

> 📨 **AGGIORNAMENTO 27/08/2026 ~00:30 — MAIL INVIATA A FTMO** (support@ftmo.com)
> con le 5 domande scritte (leva per strumento, margini overnight/stop-out,
> tetti di volume, clausola 2x200k/strategie identiche, gap trading).
> 📨 **E MAIL A FUNDEDNEXT INVIATA alle 23:56** (5 domande: fee add-on EA,
> leva eval/funded, volumi, multi-conto/cap strategia, ciclo Scale-Up).
> Auto-risposta del loro bot alle 23:57: risposta promessa in 12-24 ore.
> In attesa di risposta scritta: quando arriva va negli atti e decide la
> classifica (Q1 e Q4). Fonte del testo: ANALISI_TAGLIA_FASE1 par. 6 +
> domande del dossier.

_Mandato: trovare 3-5 prop firm che reggano il NOSTRO profilo misurato, con i
valori esatti presi dalle fonti ufficiali, la riga "cosa ci morde" e un verdetto
preliminare per ciascuna. **Nessun acquisto e' autorizzato da questo file**:
vale la regola D3 (risposta scritta del supporto prima di ogni euro) e decide
Claudio._

**Nessun commit, nessun push** (richiesta esplicita del mandato).

> 📌 **DUE AGGIUNTE AL MANDATO, arrivate il 26/08 sera e lavorate qui dentro:**
> 1. **TAGLIA ALTA** — Claudio si orienta sulle taglie piu' grandi disponibili
>    (200k/300k/400k+). → **§5-bis**: taglia massima per conto e prezzo · tetti
>    di allocazione per persona **e per strategia** · se le regole cambiano con
>    la taglia (**verificato, non assunto**) · leva su indici e oro · e
>    l'aritmetica dei nostri lotti alla taglia scelta.
> 2. **PAYOUT** — _"ogni quanto si puo' prelevare? anche tutti i giorni?"_ →
>    **§5-quater**: primo prelievo · frequenza e opzioni a pagamento · minimo e
>    split · cosa BLOCCA un payout · e **cosa succede al muro totale dopo un
>    prelievo** (la voce che quasi nessuno guarda, e che su due prop su quattro
>    e' dichiarata: **il cuscinetto si azzera**).
> 3. **IL MILIONE** — _"da 1 milione non c'e' nulla?"_ → **§5-ter**: chi vende
>    davvero a 7 cifre (cercate, non assunte) · le quattro scale delle candidate
>    (passo, cadenza, condizioni) · **il tempo minimo teorico da 200k a 1M** ·
>    se lo split migliora · e se i tetti **per strategia** sopravvivono allo
>    scaling. 🔴 **Anticipazione del verdetto: a 7 cifre, comprando, non c'e'
>    NIENTE per noi — tutte le ditte che vendono $500k-$1,5M hanno muri totali
>    fra 6% e 7%, sotto il nostro drawdown gia' misurato.**

---

## 0. 🎯 CONTROLLO POSITIVO E STATO DELLE FONTI — leggere PRIMA di tutto

Bersaglio a risposta nota: la pagina obiettivi FTMO **deve** restituire 5%
giornaliero / 10% totale / reset 00:00 CE(S)T. Provati tre canali:

| canale | bersaglio | esito | uso |
|---|---|---|---|
| `curl` diretto (proxy) | stato proxy | proxy attivo, ma i domini prop rispondono 403 al CONNECT (come il 18 e il 26/08) | 🛑 **NULLO** |
| **WebFetch** | `ftmo.com` · `the5ers.com` · `help.fundingpips.com` · `e8markets.com` · **`en.wikipedia.org`** (controllo di sanita') | ❌ `EGRESS_BLOCKED` su **TUTTI**, compreso il controllo neutro | 🛑 **NULLO — non e' un blocco anti-prop, e' un blocco totale** |
| **WebSearch** | FTMO trading objectives | ✅ restituisce **5% / 10% / static / 00:00 CE(S)T** = risposta nota **centrata** | 🟢 **UNICO CANALE VIVO** |

### 🏷️ L'ETICHETTA CHE VALE PER OGNI RIGA DI QUESTO DOSSIER

> 🟡 **`[LETTO-VIA-SEARCH 26/08/2026]`** — stessa convenzione di
> `CONFIG_PROP_2026-08-18.md` e di `DOSSIER_PROP_UPCOMERS_2026-08-26.md`.
> **Non ho aperto con i miei occhi una sola pagina.** Il contenuto arriva dal
> canale di ricerca, che **ha letto e riassunto le pagine ufficiali** indicate
> negli URL. La SOSTANZA e' affidabile (help center e FAQ ufficiali), ma **non
> ho la citazione letterale** e non posso escludere che il riassunto abbia
> arrotondato. Dove il numero non e' comparso, scrivo **"NON DICHIARATO dalla
> prop"** o **[INCERTO]** — mai una deduzione travestita da fatto.

🔴 **E una prova che l'etichetta serve:** su The5ers due letture della stessa
giornata danno _"news trading vietato"_ (pagina Prohibited Trading Practices) e
_"news trading allowed... holding open trades over the news is allowed"_
(pagina FAQ). **Non e' una contraddizione: sono due regole diverse** (esecuzione
vietata ±2 min, mantenimento permesso) — ma se mi fossi fermato alla prima riga
avrei bocciato o promosso per il motivo sbagliato. §5.2.

---

## 1. 📏 IL METRO — il nostro profilo misurato, contro cui si giudica tutto

Fonti interne: `ANALISI_DIAL_TAGLIE_2026-08-26.md`,
`ANALISI_SOPRAVVIVENZA_FUNDED_2026-08-26.md`, `report/METRO_PROP.md`,
`report/FIRME_2026-08-18.md`.

| voce | numero di casa | dove sta scritto |
|---|---|---|
| flotta | **35 sedie vive** su MT5 (indici, oro, forex), 5 ridotte | ANALISI_DIAL §base dati |
| dial firmato | **1,00** | FIRME 18/08 |
| cap rischio aperto | **3,25%** (C1) | FIRME 18/08 |
| Guardian | pausa **4,0%** giornaliero · emergenza **4,9%** / **9,9%** · reset **23** (BCM) · `InpDDMode=0` STATICO | FIRME 18/08 |
| 🔴 **peggior giornata CHIUSA** | **−4,74%** (25/05/26) a dial 1,00 · −4,03% a 0,85 · −3,51% a 0,74 | ANALISI_DIAL Tab.1 |
| drawdown totale misurato | **6,37%** su 481 giorni | R105, riprodotto in ANALISI_DIAL |
| Monte Carlo p99 (DD **statico**, rischio 0,65%) | **~8,1%** | METRO_PROP §1 |
| pass-rate simulato (muri 5%/10% statici, target +8%) | **99,6%**, mediana 12 giorni | ANALISI_DIAL Tab.2 |
| durata trade | da **4+ minuti** a swing con tenuta **overnight e weekend** | mandato 26/08 |
| filtro news | 🔴 **NESSUNO** — gli EA tradano dentro le notizie | mandato 26/08 |
| martingala / griglia / hedge fra conti | 🟢 **assenti** | mandato 26/08 |

### 🧮 LE TRE SOGLIE DI DIAL — l'aritmetica che decide le bocciature

`[INFERITO]` — scaling lineare del dial sui numeri misurati sopra (stessa
approssimazione, e stesse avvertenze (a)(b)(c), di `ANALISI_DIAL_TAGLIE`).

| muro della prop | dial massimo che regge il **giorno gia' accaduto** | lettura |
|---|---:|---|
| daily **5%** | **d ≤ 1,055** | 🟢 il dial firmato (1,00) passa, con **263 € di capello** |
| daily **4%** | **d ≤ 0,844** | 🟠 il dial firmato **SFONDA** — servirebbe scendere del 16% |
| daily **3%** | **d ≤ 0,633** | 🔴 dial quasi dimezzato |
| totale **10%** statico | d ≤ 1,57 (misurato) — e p99 8,1% < 10% | 🟢 passa **anche** in Monte Carlo |
| totale **8%** statico | d ≤ 1,256 (misurato) — ma **p99 8,1% > 8%** | 🟠 passa la storia, **non** la Monte Carlo |
| totale **6%** statico | **d ≤ 0,942** (misurato) — p99 8,1% ≫ 6% | 🔴 **sotto la nostra distribuzione**, statico o no |

> 🎯 **Questa tabella e' il vero setaccio del dossier.** Un muro giornaliero al
> 4% non e' "un po' piu' stretto": e' **un taglio del 16% alla taglia firmata**,
> cioe' ~2.000 €/mese di lordo mediano in meno (ANALISI_SOPRAVVIVENZA Tab.2).
> Un muro totale al 6% e' fuori discussione **anche se statico**.

---

## 2. 🥇 CANDIDATA #1 — **FTMO, FTMO Challenge 2-Step + tipo conto SWING**

```
PROP            FTMO — FTMO Challenge: 2-Step, account type SWING
URL REGOLE      ftmo.com/en/trading-objectives/
                academy.ftmo.com/lesson/maximum-daily-loss/
                academy.ftmo.com/lesson/maximum-loss/
                ftmo.com/en/faq/ftmo-swing-account-type/
                ftmo.com/en/faq/can-i-trade-news/
                ftmo.com/en/faq/do-i-have-to-close-my-positions-overnight-or-before-the-weekend/
                ftmo.com/en/forbidden-trading-practices/
LETTA IL        26/08/2026   [LETTO-VIA-SEARCH]
RILETTURA DI    docs/REGOLAMENTO_FTMO_2026-08.md (13/08/2026) — tutti i numeri
                chiave RICONFERMATI oggi, nessuna divergenza trovata
```

| voce | valore | etichetta |
|---|---|---|
| **Fasi / target** | 2 fasi: **10%** (Challenge) + **5%** (Verification) | 🟡 search 26/08 |
| 🧱 **MURO TOTALE** | **10% — STATICO** sul 2-Step: _"equity must not drop below 90% of the initial account balance at any given time"_ | 🟡 search 26/08 |
| — 🔴 **attenzione al gemello** | sul prodotto **1-Step** il Max Loss e' **TRAILING EOD** (ricalcolato a mezzanotte sul massimo balance di fine giornata, **sale e non scende**). **Il 2-Step e' l'unico statico** | 🟡 search 26/08 |
| 🧱 **MURO GIORNALIERO** | **5% del capitale INIZIALE**, sottratto al **balance delle 00:00 CE(S)T**. Formula ufficiale: `balance a mezzanotte CE(S)T − 5% del capitale iniziale`. Esempio ufficiale: 204.000 − 10.000 = **194.000** (conto 200k) | 🟡 search 26/08 |
| — base di calcolo | su **EQUITY** (flottante + commissioni + swap inclusi); il **riferimento** e' il **BALANCE** di mezzanotte, **non** max(balance, equity) | 🟡 search 26/08 + repo 13/08 |
| — 🕐 **reset** | **00:00 CE(S)T** = **23:00 ORA SERVER BCM**, tutto l'anno | 🟢 conversione di casa |
| **EA su MT5** | 🟢 **AMMESSI**: _"no reasons for limiting your trading strategy, whether it's discretionary trading, algorithmic trading, or EAs"_. Piattaforme: **MT4, MT5, cTrader, DXtrade** | 🟡 search 26/08 |
| — limite tecnico | **max 2.000 richieste server/giorno** (ordini/pending/modifiche) | 🟡 repo 13/08, non ri-verificato oggi |
| **NEWS TRADING** | 🟢 **SWING: nessuna restrizione** — _"The FTMO Swing account type does not have any restrictions on trading during news releases"_. Su **Standard funded**: vietato aprire/chiudere ±2 min, **anche uno SL/TP che scatta e' breach** | 🟡 search 26/08 |
| — in Challenge/Verification | 🟢 **nessuna restrizione news per nessun tipo di conto** | 🟡 search 26/08 |
| **OVERNIGHT / WEEKEND** | 🟢 **SWING: nessuna restrizione**, ne' overnight (anche con pausa mercato > 2h) ne' weekend. **Standard funded**: chiusura obbligatoria prima del weekend e se la pausa dura > 2h | 🟡 search 26/08 |
| **COPY TRADING / conti multipli** | tetto **$400.000 per trader O PER STRATEGIA**; _"if identically traded strategies are detected across multiple FTMO accounts"_ oltre il tetto → sospensione. Terzi sul conto: vietato | 🟡 repo 13/08 |
| **CONSISTENZA** | 🟢 **NESSUNA sul 2-Step**: _"provided you maintain sustainable risk management practices, there are no additional consistency requirements"_. Discipline Score solo informativo. (La **Best Day Rule 50%** esiste **solo sul 1-Step**) | 🟡 repo 13/08 |
| **TEMPO / GIORNI MINIMI** | nessun limite di tempo; **4 giorni di trading minimi per fase** | 🟡 repo 13/08 + search 26/08 |
| **LEVA (Swing)** | **1:30 forex · 1:15 indici · 1:9 metalli · 1:1 crypto/commodities/equity CFD** | 🟡 search 26/08 |
| **PREZZO 100k** | ≈ **€540** di listino (promo anniversario **€439**, −19%) | 🟡 search 26/08 + repo |
| **REFUND** | 🟢 **fee rimborsata col primo Reward** (solo 2-Step; sul 1-Step **no**) | 🟡 repo 13/08 |
| **SPLIT** | **80%**, → **90%** con Scaling Plan / Premium | 🟡 search + repo |
| **FUSO SERVER** | **GMT+2 inverno / GMT+3 estate** = **BCM + 2 ore** tutto l'anno | 🟡 repo 13/08 |
| **ESECUZIONE** | simulata (demo + reward), FTMO ha **acquisito OANDA** | 🟡 repo 13/08 |

### 🩸 COSA CI MORDE — FTMO Swing

1. 🔴 **La clausola "gap trading" fra le Forbidden Practices** (vale **sempre**,
   anche su Swing e in Challenge): _"performing gap trading by opening simulated
   trades (i) when major global news, macroeconomic events... are scheduled, or
   (ii) two hours or less before a relevant financial market is closed for at
   least two hours."_ La lettera vieta di aprire **prima** della chiusura, non
   **dopo** la riapertura — **ma la nostra famiglia GapFill vive li'**, ed e'
   **il cluster che ha prodotto il nostro peggior giorno** (25/05/26, "lunedi'
   dei gap", `ANALISI_DIAL` Tab.1). **AMBIGUO → domanda scritta, D3.**
2. 🔴 **"one-sided bets"** nell'elenco delle pratiche vietate (voce 7, insieme a
   overleveraging/overexposure/account rolling): abbiamo sedie mono-direzione
   **dichiarate nel nome** (`ABTG_MaxMinNotte_DAX_Short_Ottimizzato`). Stessa
   clausola che su Upcomers e' la motivazione piu' citata nei payout negati.
3. 🟠 **Il tetto delle 2.000 richieste server/giorno con 35 sedie.** Non e' una
   regola di rischio, e' una regola tecnica — e **noi non l'abbiamo mai
   contata**. EA con trailing stop che modificano l'SL a ogni barra generano
   `OrderModify` in quantita'. **Misurabile in casa, non ancora misurato.**
4. 🟠 **Leva metalli 1:9 sullo Swing.** `[INFERITO]` — 1 lotto oro a ~3.400 $
   vale ~340.000 $ di nozionale: a 1:9 sono **~37.800 $ di margine per lotto**.
   Con piu' sedie oro aperte insieme su un 100k il margine libero puo' stringere
   **prima** che stringa il rischio. **Da misurare sulla flotta vera** (SL medi
   e lotti effettivi delle sedie XAU), non da assumere.
5. 🟡 **Il riferimento del muro giornaliero e' il BALANCE di mezzanotte, non
   l'equity.** Un flottante in perdita aperto alle 23:00 BCM **non alza** il
   pavimento del giorno nuovo: mangia il budget del giorno dopo. E
   `ABTG_MaxMinNotte` apre il box **alle 23:00 BCM in punto**, cioe' **esattamente
   sul reset FTMO**.
6. 🟡 **Fuso server BCM+2**: tutti gli `InpSessionHour` vanno rimappati (DAX
   08:00 BCM = **10:00 server FTMO**). Errore silenzioso e totale se dimenticato.

### ⚖️ VERDETTO PRELIMINARE — 🥇 **CANDIDATA (la prima della classifica)**

> ✅ Muri **5% / 10% ENTRAMBI STATICI** = esattamente i muri su cui girano le
> nostre Monte Carlo e il pass-rate 99,6%: **e' l'unica prop del dossier che non
> richiede di rifare un solo numero del metro.** ✅ **Swing risolve i nostri due
> buchi strutturali in un colpo**: nessuna restrizione news (e noi **non abbiamo
> filtro news**) e nessuna restrizione overnight/weekend (e tre EA vivono di
> notte, uno paga swap). ✅ Zero consistency rule sul 2-Step. ✅ Fee rimborsata.
> 🔴 **Restano DUE domande scritte obbligatorie prima di pagare** (gap trading e
> one-sided bets) e **una misura di casa** (le 2.000 richieste/giorno).

---

## 3. 🥈 CANDIDATA #2 — **FundedNext, Stellar 2-Step (CFD)**

```
PROP            FundedNext — Stellar 2-Step
URL REGOLE      help.fundednext.com/en/articles/8021076-what-rules-do-i-need-to-follow-in-the-stellar-2-step-challenge
                help.fundednext.com/en/articles/9941519-daily-loss-limit-vs-maximum-loss-limit
                help.fundednext.com/en/articles/8019811-how-can-i-calculate-the-daily-loss-limit
                help.fundednext.com/en/articles/10701685-is-news-trading-allowed-in-the-stellar-2-step-account
                help.fundednext.com/en/articles/8020763-is-ea-allowed-in-fundednext
                help.fundednext.com/en/articles/8019805-what-is-the-copy-trading-rule-at-fundednext
                fundednext.com/cfds/stellar-2-step
LETTA IL        26/08/2026   [LETTO-VIA-SEARCH]
```

| voce | valore | etichetta |
|---|---|---|
| **Fasi / target** | 2 fasi: **8%** + **5%** | 🟡 search 26/08 |
| 🧱 **MURO TOTALE** | **10% — STATICO**: _"the account must not drop below 90% of its initial balance"_, pavimento **fisso a 90.000** per tutta la vita del conto | 🟡 search 26/08 |
| — nota | i profitti **allargano il cuscinetto** (max permitted loss = 10.000 + profitto), **il pavimento non si muove** | 🟡 search 26/08 |
| 🧱 **MURO GIORNALIERO** | **5% del balance INIZIALE** = **5.000 $ su 100k**; i profitti di giornata **allargano** il limite del giorno (2.000 di profitto → 7.000 di margine) | 🟡 search 26/08 |
| — base di calcolo | _"misurati contro il balance iniziale, non l'equity corrente"_ sui tre modelli challenge | 🟡 search 26/08 |
| — 🕐 **reset** | **00:00 ora server** — server **GMT+3 estate / GMT+2 inverno** → **22:00 ORA SERVER BCM tutto l'anno** | 🟢 conversione di casa |
| **EA su MT5** | 🟢 **AMMESSI su MT4 e MT5** (🔴 **vietati su cTrader**), con un **"EA usage fee"** = add-on a pagamento | 🟡 search 26/08 |
| — 💰 **quanto costa l'add-on EA** | 🔴 **NON DICHIARATO dalla prop** nelle pagine raggiunte — l'help dice solo che la fee esiste ed e' **non rimborsabile anche se non usi l'add-on** | 🔴 buco |
| — vincoli EA | strategia **unica**; _"copying the same trade setups across any account within FundedNext is not allowed"_; **cap $300.000 per singola strategia EA**; vietati EA "passa-challenge" e EA via Telegram/WhatsApp | 🟡 search 26/08 |
| **NEWS TRADING** | 🟢 **libero in Challenge**: _"you are free to open, close, or hold trades during high-impact news events. No restrictions or profit adjustments apply during the Challenge Phases"_ | 🟡 search 26/08 |
| — sul conto funded | 🟡 **soft, non breach**: ±5 min da news ad alto impatto → **solo il 40% del profitto** di quel trade viene contato | 🟡 search 26/08 |
| **OVERNIGHT / WEEKEND** | 🟢 **AMMESSI su tutti i modelli Stellar, in challenge E in funded**; _"no forced-flat rule at any stage"_ | 🟡 search 26/08 |
| **CONSISTENZA** | 🟢 **NESSUNA sui conti CFD** (Stellar 2-Step/1-Step/Lite/Instant). Il **40%** si applica **solo** se si compra l'add-on **On-Demand Rewards**, e solo al momento della richiesta | 🟡 search 26/08 |
| **COPY TRADING** | vietato fra persone diverse **e** fra Stellar Instant e qualunque altro conto FundedNext, **anche se lo stesso proprietario**. "Group trading" = piu' conti con trade identici | 🟡 search 26/08 |
| **GIORNI MINIMI** | **5 giorni** con almeno 1 trade, per fase | 🟡 search 26/08 |
| **PREZZO 100k** | **$549,99** base — 🔴 letto su **fonte terza** (proptradingvibes), **non** sulla pagina ufficiale | 🔴 terza parte |
| **REFUND** | fee rimborsata **col primo reward**; primo ciclo reward a **21 giorni**, poi ogni **14** | 🟡 search 26/08 |
| **SPLIT** | 80% base; **95% con add-on "Lifetime Reward" (+30% sul prezzo)** | 🔴 terza parte |
| **FUSO SERVER** | GMT+3 / GMT+2 = **BCM + 2 ore** | 🟢 conversione di casa |

### 🩸 COSA CI MORDE — FundedNext

1. 🔴 **La fee dell'EA add-on non e' pubblicata.** E' l'unica prop del dossier
   dove **usare un EA costa un supplemento** e **il supplemento non e' un numero
   che ho potuto leggere**. Va chiesto prima, non al checkout.
2. 🟠 **"copying the same trade setups across any account within FundedNext is
   not allowed"** + **cap $300.000 per strategia**. Con **35 sedie** su un conto,
   la domanda diventa: contano 35 strategie o una flotta sola? E se un giorno
   volessimo un secondo conto FundedNext con la stessa flotta, **e' copy
   trading**. Da chiedere per iscritto (e' la domanda 5 di `METRO_PROP`).
3. 🟡 **Sul funded, i trade dentro ±5 min dalle news pagano il 60% del profitto.**
   Non e' un breach — e' un **costo silenzioso** che, senza filtro news, si
   applica a una quota **che non abbiamo mai misurato** (quanti nostri trade
   aprono o chiudono in quella finestra? **Non lo sappiamo**).
4. 🟡 **5 giorni minimi per fase** (contro i 4 di FTMO): irrilevante per noi che
   operiamo tutti i giorni, ma va detto.

### ⚖️ VERDETTO PRELIMINARE — 🥈 **CANDIDATA**

> ✅ **Muri 5% / 10%, entrambi statici e sul balance iniziale**: le nostre Monte
> Carlo e il pass-rate 99,6% valgono **senza ricalcoli**. ✅ **News libere in
> challenge** e soft sul funded (nessun breach possibile per le news: e' l'unica
> prop del dossier dove la mancanza di filtro news **non puo' uccidere il
> conto**, al massimo costa profitto). ✅ **Weekend e overnight liberi
> ovunque, senza dover scegliere un tipo di conto speciale** (a differenza di
> FTMO, dove serve lo Swing e si paga con la leva). ✅ Zero consistency sui CFD.
> 🔴 Perde il primo posto per **due incognite economico-contrattuali** (fee EA
> non dichiarata, clausola "trade identici") e perche' su FTMO abbiamo gia' un
> dossier interno di 142 righe e su questa no.

---

## 4. 🥉 CANDIDATA #3 — **Alpha Capital Group, Alpha Swing**

```
PROP            Alpha Capital Group — programma ALPHA SWING (2 fasi)
URL REGOLE      help.alphacapitalgroup.uk/en/articles/9789907-alpha-swing
                help.alphacapitalgroup.uk/en/articles/6934210-what-are-the-daily-risk-limits-and-how-do-they-work
                alphacapitalgroup.uk/posts/alpha-capital-swing-account-explained-rules-conditions-and-who-it-is-for
                alphacapitalgroup.uk/posts/alpha-capital-rules-explained-drawdown-profit-targets-daily-loss-and-evaluation-rules-2026
LETTA IL        26/08/2026   [LETTO-VIA-SEARCH]
```

| voce | valore | etichetta |
|---|---|---|
| **Fasi / target** | 2 fasi: **10%** + **5%** | 🟡 search 26/08 |
| 🧱 **MURO TOTALE** | **10% — STATICO** (dal balance iniziale). E' il piu' largo della gamma Alpha | 🟡 search 26/08 |
| 🧱 **MURO GIORNALIERO** | **5%** — su Alpha Swing la base e' **BALANCE-based** (su Alpha One / Three / Pro 6% invece e' il **maggiore fra balance ed equity** di inizio giornata) | 🟡 search 26/08 |
| — in drawdown | _"if the account is in a drawdown at the time of reset, the max daily loss is calculated by 5% subtracted from the account balance"_ | 🟡 search 26/08 |
| — 🕐 **reset** | 🔴 **NON DICHIARATO** nelle pagine raggiunte oggi. (`CONFIG_PROP_2026-08-18.md` riportava **00:00 GMT+3 = 22:00 BCM**, lettura di 8 giorni fa **non riconfermata**) | 🔴 [INCERTO] |
| **EA su MT5** | 🟢 **AMMESSI**: _"News trading, Expert Advisors (EAs), and copy trading are permitted"_, purche' coerenti con etica e risk management | 🟡 search 26/08 |
| — 🔴 piattaforme MT5? | **NON VERIFICATO oggi** che MT5 sia fra le piattaforme offerte — la frase parla di EA, non di piattaforma | 🔴 buco |
| **NEWS TRADING** | 🟢 **PERMESSO** (dichiarato esplicitamente insieme a EA e copy trading). Alpha Swing e' venduta come programma per chi tiene _"across major news events"_ | 🟡 search 26/08 |
| **OVERNIGHT / WEEKEND** | 🟢 **PERMESSI a tutti gli stadi** su Swing, One e Three (con swap a carico) | 🟡 search 26/08 |
| 🔴 **TEMPO MINIMO PER TRADE** | **2 MINUTI** di durata minima, piu' una **"1% cooling-off rule"** | 🟡 search 26/08 |
| — cos'e' la cooling-off | 🔴 **NON DICHIARATO** in modo comprensibile nelle pagine raggiunte | 🔴 [INCERTO] |
| **CONSISTENZA** | 🟡 **c'e', ed e' sui PAYOUT**: consistency score = **miglior giorno / profitto totale della finestra**; se **> 0,40 (40%)** il payout non e' erogabile finche' non si riequilibra. ⚠️ Una seconda lettura della stessa giornata parla di **15%** per singolo giorno: 🔴 **le due cifre non coincidono → [INCERTO], da chiarire** | 🔴 divergenza |
| **GIORNI MINIMI** | **3 per fase** (giorni con almeno un round trip completo) | 🟡 search 26/08 |
| **PREZZO 100k Swing** | **$577** listino / **$403,90** scontato — 🔴 **fonte terza** (PropFirmMatch / TheTrustedProp) | 🔴 terza parte |
| **SPLIT** | **80%** (on-demand e bi-weekly), **90%** su Alpha Direct o con add-on | 🟡 search 26/08 |
| **REFUND** | fee rimborsata col primo prelievo — 🔴 **fonte terza** | 🔴 terza parte |

### 🩸 COSA CI MORDE — Alpha Capital Swing

1. 🔴 **La regola dei 2 MINUTI, e il fatto che NON POSSIAMO MISURARLA.** Il
   mandato dichiara trade "da 4+ minuti, non tick scalping sotto i 2 minuti" —
   ma **`ExportTrades()` non esporta `open_time`** (debito M2 di `PIANO_PROP.md`,
   ripetuto in `METRO_PROP` §13.2 e nel dossier Upcomers §2-bis). 🔴 **Oggi non
   possiamo dimostrare la conformita': non e' una stima mancante, e' una misura
   impossibile con l'impianto attuale.** E gli EA di apertura (`DAX_Apertura_EU`
   entra alle 08:00 server in punto) possono prendere lo stop **in secondi**.
2. 🔴 **La consistency 40% (o 15%) sui payout.** `METRO_PROP` §6 lo dice gia':
   _"27 serie con code Monte Carlo vuol dire che una giornata grossa e'
   statisticamente attesa"_. Una flotta di 35 sedie che sparano lo stesso giorno
   **produce per costruzione** giornate fuori scala. **Non ci squalifica: ci
   congela il prelievo.** E la metrica "max-day / profitto totale" **non e' mai
   stata calcolata in casa**.
3. 🟠 **Reset giornaliero NON DICHIARATO** e **MT5 non confermato**: due buchi su
   voci che decidono la configurazione, non dettagli.

### ⚖️ VERDETTO PRELIMINARE — 🥉 **CANDIDATA (con due domande bloccanti)**

> ✅ E' **l'unica del dossier che dichiara news + EA + copy trading permessi in
> una sola frase**, con muri **5% / 10% statici** e weekend/overnight liberi a
> tutti gli stadi. ✅ Il target 10%+5% e' quello di FTMO. 🔴 Ma porta **due
> clausole che ci toccano dove siamo scoperti**: il **minimo di 2 minuti**
> (non misurabile oggi) e una **consistency sui payout** con **due numeri
> discordanti nelle fonti**. **Candidata, ma dietro le prime due**, e non prima
> di aver chiuso il debito `open_time`.

---

## 5. ⚖️ LE ALTRE CENSITE — riserve e bocciature, con la misura accanto

### 5.1 🟡 **Goat Funded Trader — 2-Step Standard** → **RISERVA**

```
URL REGOLE   help.goatfundedtrader.com/en/articles/13575169-2-step-standard
             help.goatfundedtrader.com/en/articles/13575348-2-step-goat-model
             help.goatfundedtrader.com/en/articles/10742084-is-news-trading-allowed
             help.goatfundedtrader.com/en/articles/14123389-do-you-allow-trading-the-weekend-gap
LETTA IL     26/08/2026   [LETTO-VIA-SEARCH]
```

| voce | valore |
|---|---|
| target | **5% + 5%** — 🟢 **il piu' basso del dossier** |
| muro totale | **10% statico**: _"equity or balance must never drop below 90% of your starting capital"_ |
| muro giornaliero | **5%** sul **maggiore fra balance ed equity**, fissato alle **17:00 EST** → **22:00 BCM** (🟡 la pagina scrive "EST" anche d'estate: **[INCERTO]** se sia EST fisso o EDT) |
| ⚠️ modello gemello | il **2 Step GOAT Model** ha daily **4%** → 🔴 con il nostro −4,74% **e' gia' sfondato** al dial firmato: **si guarda solo lo "Standard"** |
| EA su MT5 | 🟢 ammessi, strategie automatiche standard; vietati HFT / latency arbitrage / Gold Arbitrage EA |
| news | 🟢 permesse — **ma** trade aperti/chiusi entro ±5 min da news ad alto impatto **rendono al massimo l'1% del balance iniziale** |
| weekend | 🟢 tenuta permessa — 🔴 **MA**: trade aperti nelle **ultime 3 ore del venerdi'** e chiusi nelle **prime 3 ore del lunedi'** vanno **in revisione** e sul funded **i profitti vengono rimossi** |
| giorni validi | **3** (4 sul funded per i conti dal 25/07/2026), e un giorno vale **solo se fa ≥ 0,5% di profitto** |
| 🔴 cap di profitto | **$3.000 al giorno sui conti funded** |
| consistenza | 🟢 nessuna sui funded da evaluation (15% solo su Instant Funding GOAT) |
| leva | indici **1:20** in valutazione, **1:10** sul funded |
| prezzo 100k | 🔴 **NON LETTO** |

**🩸 Cosa ci morde:** 🔴 **la regola weekend-gap e' scritta apposta contro la
nostra famiglia GapFill** — e quella famiglia e' **il cluster del 25/05/26**, il
nostro peggior giorno. 🔴 **Il cap di 3.000 $/giorno sul funded** mangia la coda
destra della nostra distribuzione (a dial 1,00 il lordo mediano e' 12.125 €/mese:
le giornate grosse sono **il modo in cui li facciamo**). 🟠 **"giorno valido =
≥ 0,5% di profitto"** e' un cancello che **non abbiamo mai misurato**.

**⚖️ Verdetto: RISERVA.** Muri giusti (5%/10% statici), news e weekend
formalmente aperti, target bassissimo — ma **due regole tagliano proprio i nostri
due estremi** (i lunedi' dei gap e le giornate grosse). Tornerebbe candidata se
Claudio decidesse di **spegnere GapFill sulla prop** e se il cap giornaliero
risultasse solo un rinvio del profitto e non una perdita.

### 5.2 🟠 **The5ers — High Stakes** → **BOCCIATA (per tre clausole, non per i muri)**

```
URL REGOLE   the5ers.com/faqs/prohibited-trading-practices/
             help.the5ers.com/what-is-the-maximum-loss-and-the-maximum-daily-loss-in-the-high-stakes-program/
             help.the5ers.com/what-is-the-drawdown-rule-for-high-stakes/
             the5ers.com/faqs/can-i-trade-during-news/
LETTA IL     26/08/2026   [LETTO-VIA-SEARCH]
```

| voce | valore |
|---|---|
| target | **10% + 5%** (nuova versione High Stakes) |
| muro totale | **10% dal balance iniziale — assoluto (statico)** 🟢 |
| muro giornaliero | **5%** preso dall'**equity o balance di CHIUSURA del giorno prima** (il maggiore); rollover **23:59 ora server** (🔴 fuso server **NON DICHIARATO** → [INCERTO]) |
| overnight / weekend | 🟢 **permessi su tutti i programmi**, FX, metalli, indici, oil, crypto |
| EA | 🟢 permessi... **ma** con tre eccezioni che ci riguardano (sotto) |
| giorni minimi | **3 giorni PROFITTEVOLI** |

**🩸 Le tre clausole che bocciano:**
1. 🔴 **News**: _"executing orders 2 minutes before until 2 minutes after
   high-impact news is prohibited"_ — **tenere e' permesso, ESEGUIRE no**. Noi
   **non abbiamo filtro news** e gli EA piazzano ordini a ogni ora.
2. 🔴 **One-sided bets** esplicitamente vietati (_"consistently takes positions
   in one single direction"_): sedie mono-direzione in flotta.
3. 🔴 **EA che scalpano nella notte del rollover** esplicitamente vietati
   (_"scalp during the rollover night to take advantage of the price feed"_):
   `ABTG_MaxMinNotte` **23:00-04:59**, `ABTG_Nightly` **22:00-04:59**, variante
   oro **22:00-06:00**. 🔴 **Tre EA della flotta lavorano esattamente li'.**
   (La regola parla di sfruttamento del price feed, non di qualunque trade
   notturno — **ma e' una clausola discrezionale, ed e' su di noi che cadrebbe
   l'onere di spiegarlo dopo il payout, non prima.**)

**⚖️ Verdetto: BOCCIATA per la prima challenge.** I muri andrebbero benissimo
(5% / 10% statici). E' il regolamento che ci chiede tre modifiche alla flotta
prima ancora di partire. **Riapribile solo con filtro news + risposta scritta
sul rollover.**

### 5.3 🔴 **FundingPips** → **BOCCIATA**

```
URL REGOLE   help.fundingpips.com/hc/en-us/articles/34504137479441-News-Trading-Weekend-Holding
             help.fundingpips.com/hc/en-us/articles/34501809112081-2-Step-Standard
             help.fundingpips.com/hc/en-us/articles/34505029138449-Trading-Conduct-and-Security-Standards
             help.fundingpips.com/hc/en-us/articles/48174287980177-Risk-Per-Trade-Idea
             fundingpips.com/trading-objectives
LETTA IL     26/08/2026   [LETTO-VIA-SEARCH]
RIFERIMENTO INTERNO   docs/REGOLAMENTO_FUNDINGPIPS_2026-08.md (13/08)
```

Muri del 2 Step Standard 🟢 giusti (**daily 5%** sul maggiore fra balance ed
equity d'apertura, **max 10% statico**, target 8%+5%, 3 giorni minimi, tempo
illimitato). **Bocciano tre regole:**

1. 🔴 **News**: _"no position may be opened, closed, **or held** within 10 minutes
   before or after a high-impact news event on the affected currency"_ — e per gli
   speech, da 10 min prima a 10 min dopo la fine. 🔴 **Vietato anche TENERE**:
   e' l'unica prop del dossier dove la nostra assenza di filtro news e'
   incompatibile **anche restando fermi**.
2. 🔴 **Weekend**: _"weekend holds are temporarily not allowed on Master Accounts
   across all four standard models"_, chiusura automatica al close del venerdi'
   (non e' breach sui modelli Standard/Flex/Pro, ma **la strategia muore**).
   ⚠️ Il "temporaneamente" e' in vigore **dal 29/01/2026** (repo 13/08): **sette
   mesi di "temporaneo"** = rischio regolamentare, non incidente.
3. 🟠 **Striking System / Risk per Trade Idea** sui Master > 25k: ogni "idea"
   che tocca **1,2% di perdita flottante combinata** prende un warning e **i
   profitti di quell'idea vengono dedotti**. ⚠️ **Il numero e' CAMBIATO**: il
   nostro dossier del 13/08 leggeva **2%**, oggi la lettura dice **1,2%**.
   Con "idea" definita come ingressi nella **stessa direzione entro 10 minuti**,
   e il precedente di casa del 29/07 (**due EA, stesso segnale, stesso secondo**,
   `CENSIMENTO_ORDINI_PC.md` §3), **0,65% × 2 = 1,30% supera 1,2%**.

**⚖️ Verdetto: BOCCIATA.** Non per i muri — per **news, weekend e un cap per
"idea" che due nostre sedie possono sfondare aprendo insieme**.

### 5.4 🔴 **Blueberry Funded** → **BOCCIATA (per aritmetica)**

Letta il 26/08 [LETTO-VIA-SEARCH] (fonti: help.blueberryfunded.com + rassegne
terze). 🟢 Drawdown **statico dal balance iniziale**, 🟢 **nessuna consistency
rule**, 🟢 **EA su MT5 senza pre-approvazione**, 🟢 broker vero dietro
(Blueberry Markets). **Ma:**

- 🔴 **daily drawdown 4%** sul conto di riferimento: il nostro **−4,74% gia'
  accaduto lo SFONDA** al dial firmato. Servirebbe **d ≤ 0,844** (§1).
- 🔴 **news vietate**: nessuna apertura/chiusura, **pendenti compresi**, ±2 min
  dalle news ad alto impatto.

**⚖️ BOCCIATA.** Il muro al 4% e' un taglio del 16% alla taglia **prima** di
discutere le news. Riapribile solo con filtro news **e** dial 0,74-0,84.

### 5.5 🔴 **E8 Markets** → **BOCCIATA**

Letta il 26/08 [LETTO-VIA-SEARCH]. 🔴 **E8 Signature: drawdown TRAILING**
(3-4%, si blocca solo dopo aver accumulato profitto); 🔴 **E8 Pro: 8% statico**
— sotto la nostra **p99 di 8,1%**; 🔴 **consistency 35-40%**, fra le piu' dure;
🔴 **news ±2 min vietate**; 🔴 regola HFT che pretende **almeno il 50% dei trade
aperti per ≥ 1 minuto**; 🟠 fonti **in conflitto** sugli EA (una dice "MT5 senza
pre-approvazione", un'altra "EA e copy trading esplicitamente vietati") →
**[INCERTO] su una voce eliminatoria**. **BOCCIATA.**

### 5.6 ⚫ **Upcomers** → **GIA' BOCCIATA il 26/08 (qui solo come confronto)**

3% daily / **6% TRAILING** su equity. `DOSSIER_PROP_UPCOMERS_2026-08-26.md`:
_"non e' una prop difficile: e' una prop che i nostri numeri, come sono oggi, non
possono passare"_. **Con la tabella §1 di oggi:** il 6% totale — **anche se fosse
statico** — richiederebbe **d ≤ 0,942** sul solo DD gia' misurato, e il 3% daily
**d ≤ 0,633**. **Non si ripropone.**

---

## 5-bis. 💰 LE TAGLIE ALTE — la domanda nuova di Claudio (26/08 sera)

> _"Orientamento dichiarato: partire da una challenge di TAGLIA ALTA — le piu'
> grandi disponibili (200k/300k/400k+), ha la possibilita' economica."_

### 🅰️ Taglia massima IN UN SOLO CONTO, e prezzo

| prop | 🔝 **taglia max di UN conto** | 💶 **prezzo della taglia max** | prezzo del 100k (riferimento) | etichetta |
|---|---:|---:|---:|---|
| **FTMO 2-Step Swing** | **$200.000** — _"you can gain an account with up to $200,000 in simulated capital"_ | **€1.080** | ≈ €540 (promo €439) | 🟡 search 26/08 · prezzo 200k da **fonte terza** |
| **FundedNext Stellar 2-Step** | **$200.000** (taglie: 6k · 15k · 25k · 50k · 100k · 200k) | **$1.099,99** | $549,99 | 🔴 taglie e prezzi da **fonti terze** (proptradingvibes / brokeranalysis) |
| **Alpha Capital Alpha Swing** | **$200.000** (_"Evaluation up to $200K simulated funds"_, homepage) | 🔴 **NON LETTO** | $577 list / $403,90 scontato (fonte terza) | 🟡 search 26/08 |
| **Goat Funded Trader** | 🔴 **[INCERTO]** — le fonti dicono _"account sizes up to $400K"_, altre _"fino a $800K"_, altre _"$2M di capitale simulato"_ (probabilmente **dopo** scaling) | fascia prezzi dichiarata: da **$36** (GOAT 2 Step 5K) a **$2.998** (GOAT **Instant** 400K) | 🔴 non letto | 🔴 **fonti terze e in conflitto** |

> 🔴 **Il fatto piu' importante di questa tabella: NESSUNA delle quattro candidate
> vende un conto singolo sopra i $200.000 (Goat forse, ma le fonti non
> concordano).** La "taglia alta" oltre i 200k **non si compra: si compone** —
> piu' conti, oppure lo scaling. E li' entrano i tetti del punto B.

### 🅱️ I TETTI DI ALLOCAZIONE — quanto capitale puo' avere UNA PERSONA, e UNA STRATEGIA

| prop | tetto per **persona** | 🔴 tetto per **STRATEGIA** | scaling | etichetta |
|---|---|---|---|---|
| **FTMO** | **$400.000** totali su tutti i conti (prima dello scaling) | 🔴 _"limited to $400,000 per trader **or strategy**"_ + _"if **identically traded strategies** are detected across multiple FTMO accounts"_ oltre il tetto → **sospensione** | **+25% ogni 4 mesi fino a $2.000.000**; condizioni: ≥10% di profitto netto in 4 cicli mensili consecutivi + ≥2 payout; con lo scale-up lo split va a **90%** | 🟡 search 26/08 + repo |
| **FundedNext** | merge dei conti fino a **$300.000** | 🔴 **$300.000 per singola strategia EA** (_"a single EA or bot strategy is limited to a maximum allocation of $300,000"_) | scale-up **+25% per ciclo** fino a **$4.000.000** dichiarati | 🟡 search 26/08 |
| **Alpha Capital** | **$400.000** per **nucleo familiare** (prima della crescita) | 🔴 **$300.000 per strategia** — _"you cannot trade the same asset on accounts totalling over $300,000"_ | Scaling Plan (pagina letta come esistente, valori **non letti**) | 🟡 search 26/08 |
| **Goat Funded Trader** | **$400.000** di allocazione combinata (una lettura); scaling dichiarato fino a $2M | 🔴 **NON DICHIARATO** nelle pagine raggiunte | scale-up calcolato **sulla taglia originale**, non sui saldi uniti | 🔴 parziale |

> 🎯 **La lettura che conta per NOI, ed e' seria.** Noi abbiamo **una sola
> flotta**. Se la prop conta il tetto **per strategia** — e **tutte e quattro lo
> fanno** — allora il capitale massimo che il NOSTRO sistema puo' avere e':
> **FTMO $400k** (= due conti da 200k, esattamente al tetto) · **FundedNext
> $300k** · **Alpha Capital $300k** · **Goat [INCERTO]**.
> 🔴 **Non e' un limite di portafoglio: e' un limite del NOSTRO EA.** Comprare
> 400k su FundedNext con la stessa flotta significherebbe **sforare per
> costruzione** il tetto dichiarato dei $300k per strategia.

### 🅲 LE REGOLE CAMBIANO CON LA TAGLIA? — **verificato, non assunto**

| prop | esito | citazione / etichetta |
|---|---|---|
| **FTMO** | 🟢 **NO** — _"the trading objectives are the same for every account size: 10% Step 1, 5% Step 2, 5% max daily loss, 10% max loss"_ | 🟡 search 26/08 |
| **FundedNext** | 🟡 **nessuna variazione per taglia trovata** sui muri del Stellar 2-Step (5% / 10% su tutte le taglie da 6k a 200k). 🔴 **Ma NON DICHIARATO in modo esplicito** in una frase che dica "identiche a ogni taglia" | 🟡/🔴 |
| **Alpha Capital** | 🔴 **le regole cambiano per PROGRAMMA, non per taglia** (Alpha One 6% · Pro 6/8/10% · Swing 10% · Three 6%) — e sui conti funded esiste **un limite di LOTTI** con sanzione: prima violazione = la fee guadagnata con i lotti in eccesso **non e' prelevabile**; **seconda violazione = conto disattivato**, e _"violations are assessed per position, not per trade idea"_. 🔴 **Il valore del limite per taglia NON e' DICHIARATO** nelle pagine raggiunte | 🔴 **buco su una voce sanzionatoria** |
| **Goat Funded Trader** | 🔴 **SI', e con effetto retroattivo per data d'acquisto**: sui **1-Step** comprati **dal 1° agosto 2026** il daily passa da 4% a **3%**; sui conti comprati **dal 25/07/2026** il funded richiede **4** giorni validi invece di 3. (Sul 2-Step Standard i muri restano 5%/10%) | 🟡 search 26/08 |

### 🅳 LA LEVA SU INDICI E ORO — e cosa vuol dire per i nostri lotti

| prop / conto | forex | 🔵 **indici** | 🟡 **oro / metalli** | crypto |
|---|---|---|---|---|
| **FTMO Swing** (unica opzione utile per noi) | **1:30** | **1:15** | **1:9 metalli** — 🔴 **[INCERTO]**: il *Trading Update del 2 Feb 2026* dice che le coppie **XAU** sono passate a **1:15 su Swing** (e 1:50 su Standard), mentre la FAQ letta oggi riporta ancora **1:9 metalli**. **Due letture, due numeri: da confermare** | 1:1 |
| **FTMO Standard** (non utilizzabile: news + weekend) | 1:100 | — | 1:50 su XAU dal 01/02/2026 | — |
| **FundedNext Stellar 2-Step** | **1:100** | 🟢 **1:25 in challenge**, **1:15 sul funded** (indici e commodities) | dentro "commodities/metals": **stessa fascia** — 🟡 valore separato per XAUUSD **non dichiarato** | 1:1 |
| **Alpha Capital** | fino a **1:100** (Alpha Pro) | 🔴 **NON DICHIARATO per Alpha Swing** | **1:9 su Alpha One** (XAUUSD sotto le regole "Metals"); 🔴 **per Alpha Swing NON DICHIARATO** | — |
| **Goat Funded Trader** | 1:100 eval / 1:50 funded | **1:20 eval / 1:10 funded** | 🔴 **[INCERTO]** — le letture di oggi si contraddicono (1:5 funded? 1:50?) | 1:2 |

#### 🧮 L'aritmetica dei lotti alla taglia alta — `[INFERITO]`, ancorato a numeri di casa

`METRO_PROP` §12 ha gia' il punto fisso: **a 1,5M, rischio 0,65% = 9.750 € =
177 lotti sul DAX in un colpo solo**. Scalando quel numero (lineare, come il
dial):

| taglia conto | rischio 0,65% per trade | 🔵 lotti DAX su UN ingresso `[INFERITO]` | nota |
|---:|---:|---:|---|
| 100k | 650 € | **~11,8** | la taglia su cui e' misurato tutto |
| 200k | 1.300 € | **~23,6** | 🟡 |
| 300k | 1.950 € | **~35,4** | 🟠 |
| 400k | 2.600 € | **~47,2** | 🔴 |

> 🔴 **Le tre avvertenze che vanno lette insieme a questa tabella, tutte
> MISURATE in casa, non temute:**
> 1. **R109**: il lotto sbatte su `SYMBOL_VOLUME_MAX` (**=100 sul Dow**) e sui
>    pavimenti di volume. A 400k siamo a ~47 lotti sul DAX: **sotto il tetto, ma
>    dentro la zona in cui il tetto esiste**.
> 2. **R109, misurato**: **21,5 punti di slippage** su uno stop Nasdaq, con
>    perdita **quasi doppia** del previsto. Lo slippage **cresce con la taglia**.
> 3. **METRO_PROP §12**: l'aspettativa del DAX Apertura e' **+0,075R**, e **1
>    punto indice di slippage se ne mangia il 24%**.
>
> 🎯 **Quindi la frase onesta sulla taglia e' questa: la taglia NON cambia la
> probabilita' di passare** (tutte le regole sono in percentuale, e le nostre
> percentuali sono identiche a 100k e a 400k — `METRO_PROP` §12) **ma cambia
> quanto il mondo reale si discosta dal backtest.** Il rischio della taglia alta
> **non e' regolamentare: e' di esecuzione**, e cresce in modo che oggi **non
> abbiamo misurato oltre il 100k**.
> 🔴 **E c'e' un secondo effetto, meno ovvio:** a leva bassa (FTMO Swing 1:15
> indici, 1:9 metalli) **il margine** occupato da 47 lotti di DAX + le sedie oro
> **puo' stringere prima del rischio**. Su un conto grande e' l'unico vincolo
> che **peggiora** con la taglia invece di restare in percentuale.

---

## 5-ter. 🚀 LA STRADA VERSO IL MILIONE — _"da 1 milione non c'e' nulla?"_

> _Domanda di Claudio, 26/08 sera._ Risposta in una riga, poi i numeri:

> ## 🔴 **SI', qualcosa a 7 cifre esiste — ma NON UNA SOLA di quelle che lo vendono ha muri che passiamo.**
> Ho cercato (non assunto) le ditte che vendono **direttamente** 500k-1M+. Ne ho
> trovate **quattro serie**. **Tutte e quattro hanno un muro totale fra il 6% e
> il 7%** — sotto il nostro drawdown **gia' misurato di 6,37%** e sotto la nostra
> **p99 di 8,1%**. 🎯 **E il motivo e' strutturale, non casuale: piu' grande e' la
> taglia che una ditta ti vende subito, piu' stretto e' il muro con cui te la
> vende.** Il **10% statico** — l'unico muro che i nostri numeri passano —
> **esiste solo fino a $200k-$400k**.
> **Quindi: il milione non si compra. Si costruisce, con lo scaling.**

### 🅰️ CHI VENDE DIRETTAMENTE A 7 CIFRE — e perche' nessuna passa

| ditta | 🔝 max ACQUISTABILE subito | daily | totale | EA / MT5 | 🔴 perche' e' FUORI per noi |
|---|---:|---:|---:|---|---|
| **Ment Funding** | 🟢 **$1.000.000** (gamma $25k → $1M) | **5%** | 🔴 **6% STATICO** _"fixed on starting balance, never trails"_ | 🟢 EA **custom** ammessi (🔴 **vietati** quelli comprati da terzi) · MT4/MT5/cTrader/Match/DXTrade | 🔴 **il nostro DD misurato 6,37% > 6%**: sfonda **con la storia gia' accaduta**, a dial 1,00. Piu': **news vietate ±3 min** (noi zero filtro) e **weekend solo con add-on a pagamento (+10% della fee)**, altrimenti chiusura forzata venerdi' 15:45 EST |
| **Lux Trading Firm** | 🟢 piani fino a **$1.000.000** | 🔴 **4%** (balance-based, sforo = **terminazione immediata**) | 🔴 **6%** | EA e news: regole esistenti, dettaglio **NON LETTO** | 🔴 **doppia bocciatura aritmetica**: 4% daily contro il nostro **−4,74%** (servirebbe d ≤ 0,844) **e** 6% totale contro 6,37% |
| **Axi Select** | 🟢 fino a **$1.000.000** (stadio "Pro M") — 🔴 **ma NON e' una challenge**: si depositano **$500 propri**, si chiudono 20 trade, si costruisce un "Edge Score" > 50 e si sale in **sei stadi** | NON DICHIARATO nelle pagine raggiunte | 🔴 **7%** (10% **solo** allo stadio Pro M), _"calculated in real time... based on unrealized losses"_ | 🟢 _"Axi Select supports MT5 Expert Advisors fully"_ | 🟠 **7% sta sotto la nostra p99 di 8,1%**; e il milione e' **l'ultimo di sei stadi**, non un prodotto in vendita. Modello **diverso** (broker + allocazione), da valutare a parte se mai |
| **Upcomers** | 🟢 fino a **$1.500.000** | 🔴 3% | 🔴 **6% TRAILING** | 🟢 si | ⚫ **GIA' BOCCIATA il 26/08** — dossier dedicato |
| _(quasi: )_ **FXIFY** | 🟡 **$400k** diretti (Two Phase **Classic**: $250k) | 🔴 **4%** sul Two Phase Classic | 🟢 **10% STATICO** (Classic) · 8% statico (2-Phase Pro) | 🟢 EA ammessi (**non** su Instant/Lightning) · news ammesse · weekend ammesso · MT5 | 🔴 **daily 4%** → il nostro −4,74% lo sfonda. Piu' **consistency 25%** sul conto funded (_"the highest single daily profit cannot exceed 25% of the total profit"_). 🟡 Ma **e' la piu' vicina del gruppo**: se un giorno si scendesse a d ≤ 0,84, la sua scala (**$400k → $4M**) sarebbe la piu' dichiarata di tutte |

> 🔴 **Il pattern, scritto nero su bianco:** Ment **6%** · Lux **6%** · Axi **7%**
> · Upcomers **6% trailing** · FXIFY Pro **8%**. **Nessuna arriva al 10% statico
> sulle taglie grandi.** Non e' sfortuna: e' il modello di business — **piu'
> capitale nominale dai subito, meno corda lasci.**

### 🅱️ LE QUATTRO SCALE DELLE NOSTRE CANDIDATE — passo, cadenza, condizioni

| | 🥇 **FTMO** | 🥈 **FundedNext (Pro Scale-Up)** | 🥉 **Alpha Capital** | 🟡 **Goat Funded Trader** |
|---|---|---|---|---|
| **max acquistabile subito** | **$200.000** | **$200.000** | **$200.000** | **[INCERTO]** ($400k? $800k?) |
| **tipo di scala** | 🟢 **COMPOSTA: +25%** | 🟢 **COMPOSTA: +25%** | 🔴 **LINEARE: +10% del balance INIZIALE** (_"not 10% of the current balance"_) | 🟢🟢 **RADDOPPIO (×2)** |
| **cadenza** | **ogni 4 mesi** | **ogni "qualifying cycle"** — 🔴 **durata NON DICHIARATA** chiaramente | a ogni richiesta, dopo il traguardo | a ogni traguardo |
| **condizione per salire** | 🔴 **≥10% di profitto NETTO in 4 cicli mensili CONSECUTIVI** | 🟢 **4 payout ricevuti + ≥4% di crescita in ogni ciclo di payout qualificante + ≥2 mesi di attivita'** | **+10% di crescita**, e si chiede allo stadio del prelievo della performance fee | 🟢 **+10% di profitto sul balance iniziale** |
| 🔴 **quante volte si puo' salire** | fino al tetto | fino al tetto | fino al tetto | 🔴 **MASSIMO 3 VOLTE** (dichiarato) |
| **tetto dichiarato** | **$2.000.000** per trader (**$1M** sui conti Aggressive) | **$4.000.000** | 🔴 **due numeri**: _"$2M cumulative virtual capital growth ceiling"_ **ma** _"max combined simultaneous allocation $400.000"_ → **[INCERTO]** | **$2.000.000** dichiarato — 🔴 in conflitto con il tetto di **allocazione combinata $400.000** letto altrove |
| **(c) lo split migliora?** | 🟢 **SI': 80% → 90%** (_"FTMO Traders being on the scale-up plan have their Profit Split ratio upgraded to 90/10"_) | 🟢 **SI': 80% → 90%** (fino a 95% con add-on) | 🔴 **NO in automatico**: _"you may request scaling of the account and your performance fee of **80%**"_ — il 90% arriva solo con Alpha Direct / add-on | 🟡 **[INCERTO]**: base 80% → 100% con add-on; una fonte parla di progressione 65%→95% legata alla taglia. 🔴 **E scalando si incassa solo il 50%** di quel 10% di profitto (invece dello split normale) |
| 🔴 **(d) i tetti PER STRATEGIA restano sui conti scalati?** | 🟢 **NO — ed e' dichiarato**: il tetto di **$400.000** e' _"per trader **or strategy** (**prior to any scaling**)"_. 🎯 **Lo scaling e' la via ufficialmente prevista per superarlo** | 🔴 **NON DICHIARATO**: il cap **$300k per strategia EA** non e' mai messo in relazione con lo scale-up | 🔴 **NON DICHIARATO**: restano scritti **$300k per strategia** e **$400k simultanei**, senza dire cosa succede scalando | 🔴 **NON DICHIARATO**: il tetto per strategia **non esiste** nelle pagine raggiunte |

### 🅲 (b) QUANTO CI VUOLE, AL MINIMO TEORICO, DA 200k A 1M

> ⚠️ **`[INFERITO]` — calcolo dichiarato, non una promessa.** Applico la scala
> pubblicata di ogni ditta partendo da **$200.000**, **assumendo che ogni
> traguardo venga centrato al primo colpo** (cioe' il **caso migliore
> possibile**, senza un solo ciclo mancato). Nessuna delle ditte dichiara un
> tempo: **il numero e' aritmetica sulla loro scala, non una loro affermazione.**

| ditta | scala | passi necessari da 200k a ≥1M | ⏱️ **tempo MINIMO teorico** | la condizione che lo rende difficile |
|---|---|---:|---|---|
| **FTMO** | ×1,25 ogni 4 mesi | **8** (200 → 250 → 312,5 → 390,6 → 488,3 → 610,4 → 763,0 → 953,7 → **1.192**) | 🔴 **32 mesi ≈ 2 anni e 8 mesi** | 🔴 **ogni passo vuole 4 mesi CONSECUTIVI a ≥10% netto** → **32 mesi di fila sopra il 10%.** Vedi il confronto sotto |
| **FundedNext** | ×1,25 per ciclo | **8** (stessa aritmetica) | 🟡 **NON CALCOLABILE**: la durata del "qualifying cycle" **non e' dichiarata**. Se il ciclo e' il payout (14 gg) → ~4 mesi; se e' mensile → ~8 mesi. 🔴 **Non lo so, e non lo invento** | 🟢 la soglia e' **+4% per ciclo**, molto piu' morbida del 10% FTMO |
| **Alpha Capital** | **+$20.000 fissi** per scala (10% di 200k) | 🔴 **40** | 🔴 **NON RAGGIUNGIBILE per questa strada**: il tetto di **allocazione simultanea e' $400.000**, che si tocca dopo **10** scale. Oltre, c'e' solo la frase sul _"$2M cumulative"_ → **[INCERTO]** | la scala **non compone**: piu' cresci, meno pesa ogni scatto |
| **Goat Funded Trader** | 🟢 **×2**, ma **massimo 3 volte** | **3** (200 → 400 → 800 → **1.600**) | 🟢 **il piu' rapido di tutti**: 3 traguardi da +10% ciascuno. Al nostro ritmo mediano (sotto) sarebbero **~3 mesi** | 🔴 **il tetto delle 3 scalate e' dichiarato**: da 200k il massimo raggiungibile e' **$1,6M e poi ci si ferma**. E ogni scalata costa: si incassa **solo il 50%** di quel 10% |

#### 🎯 IL CONFRONTO CHE CONTA — la scala di FTMO contro il NOSTRO ritmo misurato

`ANALISI_SOPRAVVIVENZA` Tab.2, dial 1,00: **lordo mediano 12.125 €/mese su 100k
= 12,1% al mese**, con la banda annuale p10-p90 fra **130,0 e 165,5 k€**.

| | numero |
|---|---|
| che cosa chiede FTMO per ogni scatto | **≥10% netto**, per **4 mesi consecutivi** |
| il nostro mese mediano misurato | **12,1% lordo** |
| 🔴 **il margine** | **2,1 punti percentuali** — e il requisito e' sul **NETTO** |
| quanti mesi di fila servono per andare da 200k a 1M | 🔴 **32** |

> 🔴 **La lettura onesta, e non e' incoraggiante:** il nostro mese **mediano**
> supera il requisito FTMO **di due punti** — il che vuol dire che **circa meta'
> dei nostri mesi NON lo supererebbe**, e ne basta **uno** per azzerare il ciclo
> di quattro. **La probabilita' di 32 mesi consecutivi sopra il 10% non l'abbiamo
> mai calcolata** — ma con un mediano a 12,1% e una banda larga, **e' bassa**.
> 🎯 **Quindi il numero vero da dire a Claudio non e' "32 mesi": e' "32 mesi
> SENZA MAI SBAGLIARE UN MESE".** La scala FTMO e' progettata per essere
> raggiunta da pochi, ed e' l'unica cosa che si puo' dire con certezza.
> ⚠️ E c'e' un secondo effetto misurato: `METRO_PROP` §12 + R109 dicono che a
> taglie alte **il rendimento reale scende** (cap di volume, slippage). Il 12,1%
> mediano e' misurato **a 100k**: **usarlo a 800k e' l'ipotesi piu' ottimista
> del dossier.**

#### 🚨 E il cavillo che uccide la scala di Goat, proprio dove sembra vincere
`[INFERITO]` — aritmetica nostra su un numero letto oggi. Goat dichiara un
**cap di profitto di $3.000 al giorno sui conti funded**, e 🔴 **non e'
dichiarato che il cap cresca con la taglia**:

| taglia | $3.000/giorno valgono | il nostro ritmo mediano (12,1%/mese ≈ 0,57%/giorno) |
|---:|---:|---|
| 100k | **3,00%/giorno** | 🟢 comodissimo |
| 200k | 1,50%/giorno | 🟢 comodo |
| 800k | 🔴 **0,375%/giorno** | 🔴 **il cap sta SOTTO il nostro ritmo mediano** |

> 🎯 **Cioe': la scala piu' veloce del dossier (×2 tre volte) porta dritta dentro
> un tetto che, alla taglia di arrivo, vale meno di quanto la flotta produce di
> media.** Se il cap non scala — **e la prop non dice che scali** — allora su
> Goat **il milione e' nominale**: il conto e' grande, il rubinetto no.
> 🔴 **DOMANDA SCRITTA OBBLIGATORIA prima di qualunque euro su Goat.**

### 🅳 IL VERDETTO SULLA STRADA VERSO IL MILIONE

1. 🔴 **A 7 cifre, comprando, NON C'E' NIENTE PER NOI.** Le quattro ditte serie
   che vendono $500k-$1,5M subito (**Ment, Lux, Axi Select, Upcomers**) hanno
   muri totali fra **6% e 7%**, tutti **sotto il nostro drawdown gia' accaduto
   (6,37%)** e tutti sotto la **p99 (8,1%)**. **Non e' una questione di prezzo:
   e' che quei conti non li finiremmo.**
2. 🟢 **Il milione, per noi, e' una destinazione, non un acquisto.** Si parte a
   **$200.000** (il massimo che le nostre candidate vendono) e si sale.
3. 🥇 **Sulla SCALA, FTMO resta la migliore — per un motivo solo, ma decisivo:
   e' l'UNICA che dichiara che il tetto per STRATEGIA ($400k) vale
   _"prior to any scaling"_.** Su una casa che ha **una sola flotta**, quello e'
   il punto in cui le altre tre tacciono — e un tetto per strategia non
   dichiarato, su un conto scalato, e' esattamente il tipo di clausola che si
   scopre **al momento del payout**.
4. 🔴 **Ma la scala FTMO e' lenta e spietata: 32 mesi, tutti sopra il 10% netto.**
   Il nostro mese mediano e' **12,1%**: ci passa sopra di due punti, il che
   significa che **meta' dei mesi no**. **Vendere questa strada come "due anni e
   mezzo" sarebbe disonesto.**
5. 🟡 **La scala piu' rapida e' Goat (×2, tre volte, ~3 mesi teorici) — ma si
   ferma a $1,6M per regola e sbatte contro il cap dei $3.000/giorno.** La piu'
   morbida nelle condizioni e' **FundedNext** (+4% per ciclo invece del 10%
   mensile di FTMO), **ma la cadenza dei cicli non e' dichiarata** e il cap per
   strategia EA ($300k) **non e' mai messo in relazione con lo scaling**.
6. 🔴 **La piu' lenta e' Alpha Capital, e non di poco: la sua scala e' LINEARE**
   (+10% del balance **iniziale**, non del corrente). Da 200k servirebbero **40
   scatti**, e il tetto di **$400.000 simultanei** arriva al decimo.

---

## 5-quater. 🏦 I PAYOUT — "ogni quanto si puo' prelevare? anche tutti i giorni?"

> _Domanda diretta di Claudio, 26/08 sera._

### 🎯 LA RISPOSTA SECCA, PRIMA DELLA TABELLA

> **No, "tutti i giorni" non esiste da nessuna parte come regola base.**
> Il piu' vicino e' **FTMO**: dopo i **primi 14 giorni** dal primo trade, il
> Reward si puo' chiedere **il 14° giorno o QUALUNQUE giorno successivo**
> (on-demand) — quindi in pratica **quando vuoi, ma non prima di 14 giorni** e
> 🔴 **solo con il conto PIATTO** (_"no open positions or pending orders"_).
> Su **FundedNext** serve l'**add-on a pagamento** per l'on-demand (altrimenti:
> primo a 21 giorni, poi ogni 14). Su **Alpha Capital** si sceglie **una volta
> sola all'iscrizione** fra bisettimanale e on-demand, **e non si cambia piu'**.
> Su **Goat** e' **bisettimanale**, punto.

| voce | 🥇 **FTMO** | 🥈 **FundedNext Stellar 2-Step** | 🥉 **Alpha Capital** | 🟡 **Goat 2-Step Standard** |
|---|---|---|---|---|
| **(a) primo prelievo** | **14° giorno** dal **primo trade** piazzato | **21 giorni** | 🔴 **NON DICHIARATO** nelle pagine raggiunte | dopo il ciclo di **14 giorni**, con i giorni validi fatti |
| **(b) frequenza successiva** | 🟢 **ON-DEMAND: il 14° giorno "o qualunque giorno successivo"** | **ogni 14 giorni**; 🟡 **on-demand con add-on a pagamento** (+5% della fee base per l'add-on On-Demand Rewards) | **bisettimanale OPPURE on-demand**, 🔴 **scelto all'iscrizione e NON piu' modificabile** | **bisettimanale (ogni 14 giorni)** |
| — condizione tecnica | 🔴 conto in **profitto** e **NESSUNA posizione aperta ne' ordine pendente** al momento della richiesta | non dichiarata nelle pagine raggiunte | non dichiarata | non dichiarata |
| **(c) minimo prelevabile** | **$20** bonifico · **$50** crypto | **$250** | 🔴 **NON DICHIARATO** | **$100** |
| **(c) split** | **80%** → **90%** con Scaling Plan / Premium | **80%** → **90%** con Scale-Up → **95%** con add-on | **80%** (on-demand e bisettimanale) → **90%** con Alpha Direct o add-on | **80%** → **100%** con add-on al checkout |
| — bonus | fee della challenge **rimborsata col primo Reward** | fee rimborsata col primo reward **+ 15% del profitto fatto in challenge** pagato col primo prelievo | fee rimborsata col primo prelievo (🔴 fonte terza) | 🔴 non letto |
| **(d) cosa BLOCCA il payout** | 🟢 **nessuna consistency sul 2-Step**; blocca solo l'assenza dei requisiti (14 gg, profitto, conto piatto) | 🟢 **nessuna consistency sui CFD** — 🟡 **40%** solo se si compra l'add-on On-Demand | 🔴 **consistency: miglior giorno / profitto totale > 40% → payout NON erogabile** (e una seconda lettura dice **15%**: [INCERTO]). 🔴 Piu' il **limite di lotti**: la fee guadagnata coi lotti in eccesso **non e' prelevabile** | 🔴 **3 giorni validi** (4 per i conti dal 25/07/2026), e un giorno vale **solo se fa ≥ 0,5% di profitto**. 🔴 Piu' il **cap di 3.000 $/giorno** di profitto sul funded. 🟢 Nessuna consistency |
| **(e) 🔴 il prelievo AZZERA il cuscinetto?** | 🔴 **SI'**: _"when a Reward is withdrawn and a new FTMO Account is provided, the **Maximum Loss Limit fully resets**, returning the first-day limit to **90% of the Initial Simulated Capital**"_ | 🔴 **SI'**: dopo il primo Performance Reward _"your **maximum loss limit will be set to your initial account balance**"_ | 🔴 **NON DICHIARATO** | 🔴 **NON DICHIARATO** |

> 🚨 **IL PUNTO (e) E' IL PIU' IMPORTANTE DI QUESTA SEZIONE, ed e' quello che
> nessuno guarda.** Su FTMO e FundedNext — le due che l'hanno dichiarato — **il
> prelievo riporta il pavimento del muro totale al punto di partenza**: tutto il
> profitto accumulato **smette di essere cuscinetto** nel momento in cui lo
> incassi.
> 🎯 **Tradotto nei nostri numeri:** il nostro drawdown misurato e' **6,37%** e
> il muro e' **10%**. Se non si preleva mai, il cuscinetto cresce col profitto e
> il muro diventa via via lontano; **se si preleva spesso, si vive PERMANENTEMENTE
> a 10 punti dal pavimento**, cioe' **sempre nella condizione peggiore misurata**
> — quella su cui `ANALISI_SOPRAVVIVENZA` calcola il 100% di sopravvivenza a 12
> mesi **ma con l'avvertenza (a): sono chiusure, il limite inferiore del rischio.**
> 🔴 **"Prelevare il piu' spesso possibile" e "restare al dial 1,00" sono due
> scelte che si sommano nella stessa direzione: massimo incasso, minimo
> cuscinetto.** Non e' un divieto — e' un tradeoff da firmare consapevolmente.
> ⚠️ Su Alpha Capital e Goat **non lo sappiamo**: **domanda scritta obbligatoria**.

> 🔴 **E un secondo cavillo, solo FTMO:** il Reward si chiede **a libro piatto**.
> La nostra flotta ha **quasi sempre qualcosa di aperto** (EasyTrend tiene per
> giorni, alcune sedie tengono nel weekend). **Su FTMO il prelievo richiede una
> finestra in cui la flotta e' TUTTA fuori.** Non e' un problema di regole: e'
> una **procedura operativa che oggi non esiste** (e che il Guardian, che sa
> chiudere tutto, potrebbe eseguire su comando).

---

## 6. 📊 LA TABELLA UNICA — tutte le censite, una riga per prop

| prop / programma | daily | totale | statico? | EA MT5 | news | weekend | consistenza | tempo min/trade | 🔝 **taglia max / prezzo / leva indici** | 🏦 **payout** | dial max che regge il **giorno gia' accaduto** | verdetto |
|---|---:|---:|---|---|---|---|---|---|---|---|---:|---|
| 🥇 **FTMO 2-Step SWING** | **5%** | **10%** | 🟢 **entrambi STATICI** | 🟢 si | 🟢 **nessuna restrizione** | 🟢 libero | 🟢 nessuna | non dichiarato | **$200k** conto singolo · **€1.080** · indici **1:15** (oro 1:9 o 1:15 → [INCERTO]) · tetto **$400k/strategia** | 🟢 **on-demand dal 14° gg** (conto **piatto**) · min $20 · 80→90% · 🔴 il prelievo **azzera il cuscinetto** | **1,055** | ✅ **CANDIDATA** |
| 🥈 **FundedNext Stellar 2-Step** | **5%** | **10%** | 🟢 **entrambi STATICI** | 🟢 si (**fee add-on**) | 🟢 libere in challenge · 🟡 −60% profitto ±5 min sul funded | 🟢 libero ovunque | 🟢 nessuna sui CFD | non dichiarato | **$200k** conto singolo · **$1.099,99** · indici **1:25 eval / 1:15 funded** · tetto **$300k/strategia EA** | 🟡 **21 gg poi ogni 14**; on-demand **solo con add-on** · min **$250** · 80→90→95% · 🔴 il prelievo **azzera il cuscinetto** | **1,055** | ✅ **CANDIDATA** |
| 🥉 **Alpha Capital Alpha Swing** | **5%** | **10%** | 🟢 **entrambi STATICI** | 🟢 si (MT5 da confermare) | 🟢 permesse | 🟢 libero | 🔴 **40% (o 15%?) sui payout** | 🔴 **2 minuti** | **$200k** conto singolo · prezzo max **NON LETTO** · leva indici **NON DICHIARATA** su Swing · tetto **$400k persona / $300k strategia** · 🔴 **limite di LOTTI** con sanzione | 🟡 **bisettimanale O on-demand, scelto UNA VOLTA all'iscrizione** · min **NON DICHIARATO** · 80→90% · 🔴 consistency blocca | **1,055** | ✅ **CANDIDATA** (2 domande bloccanti) |
| 🟡 **Goat 2-Step Standard** | **5%** | **10%** | 🟢 **entrambi STATICI** | 🟢 si | 🟡 permesse, profitto cappato all'1% ±5 min | 🟡 si, **ma gap ven/lun punito** | 🟢 nessuna | non dichiarato | taglia max **[INCERTO]** ($400k? $800k?) · prezzi $36→$2.998 · indici **1:20 eval / 1:10 funded** · oro **[INCERTO]** | 🔴 **solo bisettimanale** · min **$100** · 80→100% con add-on · 🔴 servono **3-4 giorni con ≥0,5%** + **cap $3.000/giorno** | **1,055** | 🟡 **RISERVA** |
| 🟠 **The5ers High Stakes** | **5%** | **10%** | 🟢 statici (daily su chiusura giorno prima) | 🟢 si | 🔴 **esecuzione vietata ±2 min** | 🟢 libero | 🟢 nessuna dura | non dichiarato | 🔴 non censito (bocciata prima) | 🔴 non censito | **1,055** | ❌ **BOCCIATA** (news · one-sided · rollover) |
| 🔴 **FundingPips 2 Step Standard** | **5%** | **10%** | 🟢 statici | 🟢 si | 🔴 **vietato anche TENERE ±10 min** | 🔴 **auto-close il venerdi'** | 🟢 nessuna in eval | non dichiarato | 🔴 non censito (bocciata prima) — tetto $400k (repo 13/08) | 🟡 repo 13/08: Weekly 60% · Bi-weekly 80% · Monthly 100% · On-Demand 90% | **1,055** | ❌ **BOCCIATA** |
| 🔴 **Blueberry Funded** | **4%** | **10%** | 🟢 statici | 🟢 si | 🔴 vietate ±2 min | 🟢 si | 🟢 nessuna | non dichiarato | 🔴 non censito (bocciata prima) | 🔴 non censito | **0,844** | ❌ **BOCCIATA** |
| 🔴 **E8 Markets** | 2% soft (Signature) | 3-4% **TRAILING** / 8% statico (Pro) | 🔴 no | ❓ fonti in conflitto | 🔴 vietate ±2 min | ❓ | 🔴 **35-40%** | 🔴 50% trade ≥ 1 min | 🔴 non censito | 🔴 non censito | — | ❌ **BOCCIATA** |
| ⚫ **Upcomers Thunderbolt** | **3%** | **6% TRAILING** | 🔴 no | 🟢 si | ❓ | 🟢 si | 🟡 15-20% | 🔴 **2 minuti** | fino a **$1,5M** (cap totale) · 100k a ~$99,90 | primo a 7-14 gg · min **$45** · split **99%** · 🟡 Best Day 15-20% | **0,633** | ❌ **GIA' BOCCIATA 26/08** |

---

## 7. 🕐 GLI ORARI IN ORA SERVER BCM — il numero che entra nelle configurazioni

**Regola di casa: BCM = ora italiana − 1** (in agosto Italia = CEST = UTC+2 →
**BCM = UTC+1**; d'inverno Italia = CET = UTC+1 → **BCM = UTC+0**).

| prop | reset dichiarato | in UTC | 🕐 **in ORA SERVER BCM** | fuso del server della prop |
|---|---|---|---|---|
| **FTMO** | 00:00 **CE(S)T** | 22:00 est. / 23:00 inv. | **23:00** (tutto l'anno) | GMT+2/+3 = **BCM + 2** |
| **FundedNext** | 00:00 **server** (GMT+3 est. / GMT+2 inv.) | 21:00 / 22:00 | **22:00** (tutto l'anno) | **BCM + 2** |
| **Goat Funded Trader** | **17:00 EST** | 21:00 / 22:00 | **22:00** (se EDT d'estate) — 🔴 **[INCERTO]**: la pagina scrive "EST" anche d'estate | NON DICHIARATO |
| **FundingPips** | 00:00 **UTC+3** | 21:00 | **22:00** est. / **21:00** inv. | UTC+3 fisso |
| **Alpha Capital** | 🔴 **NON DICHIARATO dalla prop** | — | **[INCERTO]** | NON DICHIARATO |
| **The5ers** | 23:59 **"ora server"** | — | **[INCERTO]** — fuso non dichiarato | NON DICHIARATO |

> 🔴 **Due conseguenze operative, non accademiche.**
> 1. Il Guardian ha `InpDailyResetHour = 23` (congelato 18/08, **tarato su
>    FTMO**). Su FundedNext, Goat e FundingPips il reset e' alle **22:00 BCM**:
>    **un'ora di sfasamento**, e una perdita fra le 22:00 e le 23:00 finirebbe
>    nel giorno-prop sbagliato.
> 2. `ABTG_MaxMinNotte` apre il box **alle 23:00 BCM in punto** = **esattamente
>    sul reset FTMO**, e **un'ora dopo** il reset di FundedNext. La scelta della
>    prop sposta il confine del giorno **dentro** una delle nostre finestre
>    operative. Non e' un dettaglio: e' una configurazione.

---

## 8. 🕳️ COSA NON HO POTUTO VEDERE — dichiarato, non riempito

| # | buco | perche' |
|---|---|---|
| 1 | 🔴 **Nessuna pagina aperta con i miei occhi** | WebFetch `EGRESS_BLOCKED` su **tutti** i domini (anche il controllo neutro Wikipedia). Zero citazioni letterali verificate a schermo |
| 2 | **Prezzi 100k su pagina ufficiale** | letti su **fonti terze** per FundedNext ($549,99), Alpha Swing ($577 / $403,90). **NON LETTO** per The5ers e Goat. Solo FTMO (~€540) e' coerente con un dossier interno |
| 3 | **Fee dell'add-on EA di FundedNext** | 🔴 **NON DICHIARATA dalla prop** nelle pagine raggiunte |
| 4 | **Reset giornaliero di Alpha Capital** e **fuso server di The5ers/Goat** | NON DICHIARATI |
| 5 | **MT5 fra le piattaforme di Alpha Capital** | non confermato oggi (confermato solo che gli EA sono ammessi) |
| 6 | **Consistency Alpha Capital: 40% o 15%?** | due letture della stessa giornata, due numeri |
| 7 | **HEDGING o NETTING?** su tutte e quattro le candidate | 🔴 **mai trovato.** Il nostro conto e' HEDGING e piu' EA aprono insieme sullo stesso simbolo: **su netting si fonderebbero** |
| 8 | **Nomi dei simboli e broker/feed** di ogni prop | mai dichiarati. `METRO_PROP` §11: DAX = `D30EUR` su BCM, `GER40` altrove |
| 9 | **Le 2.000 richieste server/giorno di FTMO contro 35 sedie** | 🔴 **non e' un buco delle fonti: e' un buco NOSTRO.** Non abbiamo mai contato le richieste che la flotta genera |
| 10 | **Durata dei nostri trade** | 🔴 **misura IMPOSSIBILE oggi**: `ExportTrades()` non esporta `open_time` (debito M2, terzo mandato che lo chiede) |
| 11 | **Quota dei nostri trade dentro le finestre news** | mai calcolata: serve per pesare le regole "soft" di FundedNext (−60%) e Goat (cap 1%) |
| 12 | **Reputazione: verifica indipendente** | ForexPeaceArmy, PropFirmMatch e Trustpilot **non apribili**; ho solo rassegne di terzi via search |
| 13 | **Prezzo della taglia MASSIMA** di Alpha Capital e di Goat | 🔴 **NON LETTO** (per Goat ho solo la forbice $36 → $2.998, e il 2.998 e' su un **Instant**, non sul 2-Step) |
| 14 | **Taglia massima reale di Goat** | 🔴 fonti in conflitto: $400k / $800k / $2M. **Non risolto** |
| 15 | **Leva su indici e oro di Alpha Capital Swing** | 🔴 **NON DICHIARATA** (ho solo Alpha One: metalli 1:9) |
| 16 | **Leva sull'oro di FTMO Swing** | 🔴 **due letture in conflitto nella stessa giornata**: FAQ = 1:9 metalli · Trading Update 02/02/2026 = XAU 1:15 su Swing |
| 17 | **Il limite di LOTTI di Alpha Capital, per taglia** | 🔴 **NON DICHIARATO** — ed e' una regola **sanzionatoria** (2ª violazione = conto disattivato) |
| 18 | **Primo prelievo e minimo prelevabile di Alpha Capital** | 🔴 **NON DICHIARATI** |
| 19 | **Se il prelievo azzera il cuscinetto su Alpha Capital e Goat** | 🔴 **NON DICHIARATO** — su FTMO e FundedNext e' **dichiarato SI'** |
| 20 | **Il nostro tempo di libro piatto** | 🔴 buco NOSTRO: FTMO chiede **zero posizioni e zero pendenti** per il payout, e **non sappiamo quante finestre piatte la flotta lasci in un mese** |
| 21 | **Durata del "qualifying cycle" di FundedNext** | 🔴 **NON DICHIARATA** → il tempo da 200k a 1M su FundedNext **non e' calcolabile** |
| 22 | **Se i tetti PER STRATEGIA valgono sui conti SCALATI** | 🔴 **NON DICHIARATO** su FundedNext, Alpha e Goat. **Solo FTMO lo dice** (_"prior to any scaling"_) |
| 23 | **Se il cap di $3.000/giorno di Goat cresce con la taglia** | 🔴 **NON DICHIARATO** — ed e' il numero che decide se la sua scala rapida porta a un milione **vero** o **nominale** |
| 24 | **Alpha: "$2M cumulative growth" contro "$400k simultaneous allocation"** | 🔴 **due tetti che non si parlano** nelle fonti raggiunte |
| 25 | **La probabilita' di 32 mesi consecutivi sopra il 10% netto** | 🔴 buco NOSTRO: **mai calcolata.** Abbiamo il mediano (12,1%) e la banda annuale, **non la distribuzione dei mesi** |
| 26 | **EA di Ment Funding** | 🔴 fonti in conflitto: _"EAs, scripts and copy trading without restrictions"_ contro _"custom EA si', bot comprati da terzi no"_ (irrilevante: bocciata sui muri) |
| 27 | **Regole EA/news di Lux Trading Firm** | 🔴 **NON LETTE** (bocciata prima sull'aritmetica dei muri) |

---

## 9. 📣 REPUTAZIONE — di contorno, MAI criterio principale (etichettata)

> ⚠️ **Regola del mandato: la reputazione e' contorno.** Nessuna riga qui sotto
> sposta un verdetto; serve a decidere **quali domande fare**.

| fatto | etichetta |
|---|---|
| FTMO, FundedNext, The5ers, MyFundedFX e Topstep **dichiarano tutte di permettere gli EA** | 🟡 rassegna terza, 26/08 |
| Il pattern ricorrente dei payout negati sono **12 categorie**, in testa: hedging fra conti, firme di latency/tick scalping, copy-trading, **violazioni news**, **tenuta weekend/overnight**, taglie fuori scala | 🟡 rassegna terza — 🎯 **quattro di queste sei ci riguardano direttamente** |
| Sistemi che **segnalano piu' utenti che eseguono trade identici con lo stesso EA** → possibile chiusura conto | 🟡 rassegna terza |
| **MyFundedFX ha chiuso a febbraio 2026 con poco preavviso** | 🟡 rassegna terza — 🔴 promemoria che il rischio-ditta esiste |
| **FundingPips ha cambiato le regole sui funded** (weekend vietato dal 29/01/2026, "temporaneo" da sette mesi; Risk per Trade Idea passato da 2% a 1,2% fra il 13 e il 26/08) | 🟡 repo + search 26/08 — 🔴 **e' l'unico caso in cui ho MISURATO un cambio di regola fra due letture nostre** |
| FTMO ha **completato l'acquisizione di OANDA** (broker retail regolamentato) | 🟡 repo 13/08 |
| Su Goat: **nessuna lamentela specifica trovata** nelle ricerche di oggi | ❓ assenza di dato, non prova di solidita' |

---

## 10. 🏆 LA CLASSIFICA MOTIVATA

### 🥇 1° — **FTMO, Challenge 2-Step, tipo conto SWING**
**Perche' prima:** e' **l'unica prop su cui il nostro metro non va rifatto**.
Muri **5% / 10% entrambi STATICI** = le stesse convenzioni di R106, di
`ANALISI_DIAL` e delle Monte Carlo: pass-rate **99,6%**, sopravvivenza 12 mesi
**100%**, p99 **8,1% < 10%**. Il tipo Swing chiude **in una riga di
configurazione** i nostri due buchi strutturali (nessun filtro news, tenuta
overnight/weekend). Zero consistency sul 2-Step, fee **rimborsata** col primo
reward, ed e' l'unica ditta del dossier con **un broker regolamentato in
pancia**. **Costo del primo posto:** leva **1:9 sui metalli** (margine, da
misurare) e **due clausole discrezionali** — gap trading e one-sided bets — che
vanno chiuse **per iscritto**, non interpretate.

### 🥈 2° — **FundedNext, Stellar 2-Step**
**Perche' seconda:** stessi muri statici 5%/10%, ma con **due vantaggi reali su
FTMO** — il weekend e l'overnight sono liberi **senza dover scegliere un conto
speciale e senza pagare in leva**, e le news **non possono mai bruciare il
conto** (libere in challenge, solo penalita' di profitto sul funded). Target
piu' basso in fase 1 (8% contro 10%). **Perche' non prima:** **la fee dell'EA
add-on non e' un numero che abbiamo**, e la clausola sui **"trade identici fra
conti"** tocca in pieno il modo in cui giriamo (stessa flotta su piu' conti).

### 🥉 3° — **Alpha Capital Group, Alpha Swing**
**Perche' terza:** muri **5% / 10% statici**, e l'unica frase del dossier che
dichiara **news + EA + copy trading permessi insieme**, con weekend e overnight
liberi a ogni stadio. **Perche' non piu' su:** il **minimo di 2 minuti per
trade** — che oggi **non possiamo misurare** — e una **consistency sui payout**
che nelle fonti compare con **due numeri diversi** (40% e 15%). Piu' due voci
non dichiarate (reset giornaliero, MT5).

### 🟡 4° — **Goat Funded Trader, 2-Step Standard** → RISERVA
Muri giusti e **target 5%+5%, il piu' basso di tutti**. Ma **la regola sul gap
venerdi'-lunedi'** colpisce la famiglia che ha prodotto il nostro peggior giorno,
e il **cap di 3.000 $/giorno sul funded** taglia la coda destra da cui viene il
nostro rendimento.

### ❌ Fuori — **The5ers** (news ±2 min in esecuzione · one-sided bets · EA nel
rollover notturno: **tre EA della flotta**), **FundingPips** (vietato **tenere**
posizioni ±10 min dalle news · weekend auto-chiuso · cap 1,2% per "idea" che due
nostre sedie possono sfondare insieme), **Blueberry Funded** (daily **4%**: il
nostro −4,74% **gia' accaduto** lo sfonda, servirebbe d ≤ 0,844 · news vietate),
**E8 Markets** (trailing o 8% statico sotto la nostra p99 · consistency 35-40% ·
50% dei trade ≥ 1 minuto), **Upcomers** (gia' bocciata: 3% / **6% trailing**).

---

### 🔝 E CON L'ORIENTAMENTO "TAGLIA ALTA", la classifica cambia? — **si', in parte**

| criterio della taglia alta | vince |
|---|---|
| **taglia massima in UN conto** | 🤝 **pari a $200.000**: FTMO, FundedNext e Alpha Capital sono **identiche**. Nessuna vende di piu' in un colpo (Goat forse, ma le fonti si contraddicono) |
| 🔴 **capitale massimo per la NOSTRA (unica) strategia** | 🥇 **FTMO: $400.000** (= due conti da 200k, esattamente al tetto "per trader **o strategia**"). FundedNext e Alpha si fermano a **$300.000 per strategia** |
| **scaling oltre il tetto** | 🥇 FTMO **fino a $2M** con condizioni **scritte e verificabili** (≥10% netto in 4 cicli mensili + ≥2 payout). FundedNext dichiara **$4M** ma senza condizioni lette |
| **leva sugli indici** (piu' leva = meno margine impegnato) | 🥇 **FundedNext 1:25 in challenge / 1:15 sul funded** batte FTMO Swing (1:15) e Goat funded (1:10) |
| **prezzo della taglia grande** | 🥇 **FTMO €1.080** per il 200k contro **$1.099,99** di FundedNext: praticamente pari, con FTMO leggermente sotto al cambio corrente |
| **regole che cambiano con la taglia** | 🥇 **FTMO: dichiarato NO** (_"same for every account size"_). 🔴 **Goat: SI'**, e cambia **per data d'acquisto** |
| 🚀 **la scala verso il milione** (§5-ter) | 🥇 **FTMO** — unica che dichiara che il tetto per **STRATEGIA** vale _"**prior to any scaling**"_, cioe' che **lo scaling e' la via prevista per superarlo**. Le altre tre **tacciono** su cosa succede al cap per strategia sui conti scalati. 🔴 Ma e' anche la piu' **lenta e severa**: **32 mesi tutti sopra il 10% netto** |
| ⚡ **la scala piu' rapida** | 🟡 **Goat**: ×2 per tre volte (200k → **1,6M**, ~3 traguardi) — 🔴 **ma si ferma li' per regola**, e sbatte contro il **cap di $3.000/giorno** che a 800k vale **0,375%/giorno**, sotto il nostro ritmo mediano |
| 🐌 **la scala piu' lenta** | 🔴 **Alpha Capital**: **LINEARE** (+10% del balance **iniziale**), **40 scatti** da 200k a 1M, e il tetto di **$400.000 simultanei** arriva al decimo |

> ⚖️ **Verdetto sull'aggiornamento: la classifica NON si ribalta, si rinforza.**
> FTMO resta prima **anche sul criterio nuovo**, e per un motivo che prima non
> avevamo scritto: **e' l'unica che porta la NOSTRA singola strategia fino a
> $400.000** (le altre due la fermano a 300k) e **l'unica che dichiara per
> iscritto che le regole non cambiano con la taglia**.
> 🔴 **Ma la taglia alta introduce un rischio che nessuna prop puo' togliere e
> che e' NOSTRO: l'esecuzione.** A 400k un ingresso DAX vale **~47 lotti**
> `[INFERITO]`, e i 21,5 punti di slippage misurati in R109 su un solo stop
> Nasdaq dicono che **il divario fra backtest e realta' cresce con la taglia**.
> **La taglia non si sceglie sul listino: si sceglie dopo aver misurato lo
> slippage alla taglia scelta.** Oggi quella misura, sopra il 100k, **non
> esiste in casa.**
>
> 🚀 **E sul milione (§5-ter) la classifica NON cambia neppure li': FTMO resta
> prima.** Non perche' la sua scala sia comoda — e' la piu' dura — ma perche'
> e' **l'unica che dichiara in che rapporto sta lo scaling col tetto per
> STRATEGIA**, che per una casa con **una sola flotta** e' il tetto vero.

---

## 10-bis. 🚨 LA RISPOSTA SECCA SULLA STRADA DEL MILIONE

> ### 🔴 **A 7 cifre, comprando, NON C'E' NIENTE PER NOI.**
> Le quattro che vendono davvero $500k-$1,5M subito — **Ment Funding ($1M),
> Lux Trading Firm ($1M), Axi Select ($1M), Upcomers ($1,5M)** — hanno muri
> totali fra il **6% e il 7%**. Il nostro drawdown **gia' accaduto** e' **6,37%**
> e la p99 e' **8,1%**: **sono conti che non finiremmo, non conti che costano
> troppo.**
> ### 🟢 **Il milione, per noi, si costruisce: $200.000 + scala.**
> E la scala migliore e' **FTMO** — non la piu' veloce, **la piu' dichiarata**.
> ### 🔴 **E il numero da non nascondere: 32 mesi, tutti sopra il 10% netto.**
> Il nostro mese mediano misurato e' **12,1%**. Due punti di margine
> significano che **circa meta' dei mesi non ce la farebbe**, e **uno solo
> azzera il ciclo di quattro**.

---

## 11. ❓ LE DOMANDE CHE RESTANO APERTE — **decide Claudio, non io**

### ❓ Q1 — Quale pedaggio si preferisce pagare: **la leva o la clausola**?
FTMO Swing e FundedNext hanno **gli stessi muri** e passano entrambe il metro.
Si dividono su cosa costano:
- **FTMO Swing** costa **leva 1:9 sui metalli / 1:15 sugli indici** → e' un
  problema di **MARGINE**, misurabile in casa sulle taglie vere delle sedie oro,
  **prima** di comprare;
- **FundedNext** costa una **fee EA non dichiarata** + una **clausola sui trade
  identici** → e' un problema **contrattuale**, che si scioglie solo con una
  risposta scritta (**D3**).
> 🎯 **La domanda a Claudio:** partiamo dalla prop dove il rischio residuo e'
> **misurabile da noi** (FTMO) o da quella dove e' **piu' comodo operare** ma il
> rischio residuo dipende da una **risposta altrui** (FundedNext)?

### ❓ Q2 — **La famiglia GapFill sale sulla prop, si', o no?**
E' il nodo che ritorna su **tre** prop: FTMO la lascia in una **zona grigia**
("gap trading" fra le Forbidden Practices, con definizione che letteralmente non
la copre), **Goat la punisce esplicitamente** sul funded (profitti rimossi),
FundingPips la vieta per nome. E `ANALISI_DIAL` Tab.1 dice che **il nostro
peggior giorno (25/05/26, −4,74%) e' proprio il cluster GapFill**, e che il
25/05 e' **strutturale**: nessuna esclusione di sedia lo toglie.
> 🎯 **Le tre uscite, tutte legittime:** (a) si chiede per iscritto a FTMO e si
> decide dopo; (b) si spegne GapFill **solo sul conto prop**, tenendola sul
> nostro — e allora **il peggior giorno da rimisurare non e' piu' −4,74%**;
> (c) si accetta la zona grigia. **Non e' una scelta tecnica: e' una scelta di
> rischio contrattuale, e la firma e' di Claudio.**

### ❓ Q3 — **A che dial si compra la prima challenge?**
`ANALISI_DIAL` dice che il picco di pass-rate e' **a 1,00** (99,6%, mediana 12
giorni) e che sopra **1,055** c'e' il dirupo. `ANALISI_SOPRAVVIVENZA` raccomanda
**1,00 in challenge e 0,74 in funded**. Su una prop a **daily 5%** questa e' una
**scelta**; su una a **daily 4%** (Blueberry, Goat GOAT Model) sarebbe un
**obbligo** (d ≤ 0,844).
> 🎯 **La domanda a Claudio:** si parte a **1,00** accettando i **263 € di
> capello** dal muro giornaliero — sapendo che quel numero e' su **chiusure**,
> cioe' il **limite inferiore** del rischio vero — oppure si compra margine
> partendo a **0,85** (0,97 pt di capello) o **0,74** (1,49 pt)?

---

### ❓ Q4 — **Quanto grande, davvero? E si accetta di misurare PRIMA?**
Nessuna candidata vende piu' di **$200.000 in un conto solo**. Sopra i 200k si
va **per composizione** (due conti) o **per scaling**, e li' mordono i tetti
**per STRATEGIA**: FTMO **$400k**, FundedNext e Alpha **$300k**. Noi abbiamo
**una sola flotta**: e' quella la strategia che il tetto conta.
> 🎯 **Le tre uscite:** (a) **200k singolo** e si guarda come si comporta lo
> slippage prima di raddoppiare; (b) **2 × 200k su FTMO** = 400k, al tetto
> esatto, sapendo che la clausola _"identically traded strategies across
> multiple FTMO accounts"_ e' scritta **proprio** per questo caso e va chiusa
> per iscritto; (c) 200k + scaling FTMO (+25% ogni 4 mesi, condizioni scritte).
> 🔴 **La casa raccomanda di NON saltare il passo della misura**: `METRO_PROP`
> §12 e R109 dicono che la taglia **non cambia le percentuali ma cambia
> l'esecuzione**, e sopra il 100k **non l'abbiamo mai misurata**. Costerebbe
> **una serie di trade reali alla taglia nuova**, non un backtest.

### ❓ Q6 — **Il milione e' un obiettivo o un'aspettativa?**
La strada c'e' (**200k + scala**), ma nessuna delle quattro la regala:
**FTMO 32 mesi tutti sopra il 10% netto** · **FundedNext cadenza non
dichiarata** · **Alpha lineare, 40 scatti e un tetto a 400k** · **Goat
velocissima ma ferma a $1,6M e con un cap di $3.000/giorno che a 800k vale
0,375%/giorno**.
> 🎯 **La domanda:** si sceglie la prop **per la scala** (e allora FTMO, con
> tutte le sue clausole grigie) o **per l'operativita' del primo anno** (e
> allora FundedNext, che ci lascia lavorare meglio e chiede il 4% invece del
> 10%)? 🔴 **La casa dice una cosa sola con certezza: il milione NON si compra —
> ogni ditta che oggi te lo vende subito lo vende con un muro che non passiamo,
> e questo e' un fatto misurato contro il nostro 6,37%, non un'opinione.**

### ❓ Q5 — **Prelevare spesso, o tenere il cuscinetto?**
FTMO e FundedNext **dichiarano entrambe** che il prelievo **riporta il pavimento
del muro totale al capitale iniziale**: il profitto smette di essere cuscinetto
nel momento in cui lo incassi.
> 🎯 **Il tradeoff, coi nostri numeri:** a dial 1,00 il lordo mediano e'
> **12.125 €/mese** (netto 80% ≈ 9.700 €) e il DD misurato e' **6,37%** contro
> un muro del **10%**. **Prelevare ogni ciclo = vivere sempre a 10 punti dal
> pavimento** (la condizione peggiore misurata). **Lasciar correre due-tre cicli
> = comprare cuscinetto pagandolo in liquidita'.**
> 🔴 E su **FTMO** c'e' il vincolo operativo in piu': il payout si chiede **a
> libro piatto**, e la nostra flotta ha quasi sempre qualcosa di aperto.
> **Serve una procedura di "finestra piatta" — che oggi non esiste.**

---

## 12. 🛑 COSA NON AUTORIZZA QUESTO DOSSIER

- **Nessun acquisto.** Vale la **regola D3**: risposta **scritta** del supporto
  prima di ogni euro. Le domande gia' pronte stanno in
  `report/DOMANDE_SUPPORTO_PROP.md` e in `docs/REGOLAMENTO_FTMO_2026-08.md` §(b);
  a quelle si aggiungono le nuove: **fee EA di FundedNext**, **hedging o
  netting**, **consistency Alpha 40% o 15%**, **reset giornaliero Alpha**,
  **fuso server The5ers/Goat**, e le sei nate dagli aggiornamenti di stasera:
  1. _"Our single proprietary EA portfolio would run on TWO accounts of $200,000
     each with you. Does that hit the '$400,000 per trader OR strategy' cap, and
     does it count as 'identically traded strategies across multiple accounts'?"_
     (FTMO) / _"...against the $300,000 per EA strategy cap?"_ (FundedNext, Alpha)
  2. _"What is the exact leverage on INDICES and on XAUUSD on a SWING account of
     $200,000? Your FAQ says 1:9 for metals, your Trading Update of 2 Feb 2026
     says 1:15 for XAU on Swing. Which one is in force today?"_ (FTMO)
  3. _"Is there a maximum LOT SIZE limit per position on a funded account, and
     what is its exact value for each account size?"_ (Alpha Capital — regola
     sanzionatoria, valore non pubblicato)
  4. _"After a payout, is the maximum loss floor recalculated back to the initial
     balance?"_ (Alpha Capital, Goat — le altre due l'hanno gia' dichiarato)
  5. _"Can a Reward be requested while positions are still open? Our portfolio is
     rarely flat."_ (FTMO)
  6. _"What is the exact price of the LARGEST 2-Step account you sell?"_
     (Alpha Capital, Goat — prezzo non letto)
  7. _"Does the per-strategy allocation cap ($300,000) still apply AFTER a
     scale-up, or is it — as at FTMO — a limit that applies 'prior to any
     scaling'?"_ (FundedNext, Alpha, Goat — **la domanda del milione**)
  8. _"Is the $3,000 daily profit cap on funded accounts scaled with account
     size? On an $800,000 scaled account, is it still $3,000?"_ (Goat)
  9. _"How long is one 'qualifying cycle' for the Pro Scale-Up program?"_
     (FundedNext)
  10. _"Is the $2M cumulative growth ceiling compatible with the $400,000
      maximum simultaneous allocation? Which one binds a scaled account?"_
      (Alpha Capital)
- **Nessuna modifica al forward**, nessun cambio di soglia del Guardian, nessun
  cambio di dial, nessun round. Ogni spostamento e' una **FIRMA di Claudio sui
  contratti**.
- **Nessun numero di questo file e' una citazione verificata a schermo**: tutto
  e' `[LETTO-VIA-SEARCH 26/08/2026]`, e va **ricontrollato aprendo gli URL**
  prima della firma.

---

### 📚 FONTI (tutte `[LETTO-VIA-SEARCH 26/08/2026]`, nessuna aperta direttamente)

**FTMO:** ftmo.com/en/trading-objectives/ · academy.ftmo.com/lesson/maximum-daily-loss/ ·
academy.ftmo.com/lesson/maximum-loss/ · ftmo.com/en/faq/ftmo-swing-account-type/ ·
ftmo.com/en/faq/is-the-swing-account-type-available-for-ftmo-challenge-1-step/ ·
ftmo.com/en/faq/can-i-trade-news/ ·
ftmo.com/en/faq/do-i-have-to-close-my-positions-overnight-or-before-the-weekend/ ·
ftmo.com/en/forbidden-trading-practices/ ·
ftmo.com/en/faq/which-instruments-can-i-trade-and-what-strategies-am-i-allowed-to-use/ ·
ftmo.com/en/how-it-works/ · ftmo.com/en/1-step-challenge/ ·
ftmo.com/en/reward-growth-and-scaling-plan/ ·
ftmo.com/en/faq/what-capital-will-i-trade-on-an-ftmo-account/ ·
ftmo.com/en/faq/how-many-accounts-can-i-have/ ·
ftmo.com/en/faq/how-do-i-withdraw-my-profits/ ·
ftmo.com/en/blog/trading-updates/trading-update-2-feb-2026/ (leva oro, letto **di
riflesso** via thepayoutreport.com)

**FundedNext:** help.fundednext.com/en/articles/8021076 (regole Stellar 2-Step) ·
/9941519 (daily vs max loss) · /8019811 (calcolo daily) · /10701685 (news Stellar 2-Step) ·
/10701447 (news) · /8020763 (EA) · /8388896 (restrizioni strategia) · /8019805 (copy trading) ·
/8027523 (conti multipli) · /8592191 (add-on) · fundednext.com/cfds/stellar-2-step ·
/8020768 (reward share) · /8020084 (come prelevare) · /8019659 (scale-up) ·
/13349186 (FundedNext Pro scale-up) · /8019669 (leva) ·
fundednext.com/general-rules/cfds/symbols-and-conditions · fundednext.com/symbols

**Alpha Capital:** help.alphacapitalgroup.uk/en/articles/9789907 (Alpha Swing) ·
/8420429 (Alpha Pro) · /10097421 (Alpha One) · /6934210 (daily risk limits) ·
/10102634 (performance fee on demand) · alphacapitalgroup.uk/posts/alpha-capital-rules-explained... ·
alphacapitalgroup.uk/posts/alpha-capital-swing-account-explained... ·
/8804535 (quanti conti / allocazione max per strategia) ·
/6934289 (limite di lotti sui conti funded) · /6933852 (scaling plan) ·
/10192958 (Alpha Three) · alphacapitalgroup.uk/ (homepage: "up to $200K") ·
alphacapitalgroup.uk/product

**Goat Funded Trader:** help.goatfundedtrader.com/en/articles/13575169 (2-Step Standard) ·
/13575348 (2 Step GOAT) · /10742084 (news) · /14123389 (weekend gap) ·
/collections/11969353 (Rules) · /9549359 (reward e profit split) ·
/10741910 (leva) · /10741905 (strumenti)

**The5ers:** the5ers.com/faqs/prohibited-trading-practices/ ·
help.the5ers.com/what-is-the-maximum-loss-and-the-maximum-daily-loss-in-the-high-stakes-program/ ·
help.the5ers.com/what-is-the-drawdown-rule-for-high-stakes/ ·
the5ers.com/faqs/can-i-trade-during-news/ · the5ers.com/high-stakes/

**FundingPips:** help.fundingpips.com/hc/en-us/articles/34504137479441 (news e weekend) ·
/34501809112081 (2 Step Standard) · /34505029138449 (trading conduct) ·
/48174287980177 (risk per trade idea) · /34502157694865 (Zero) · fundingpips.com/trading-objectives

**Blueberry Funded:** help.blueberryfunded.com/en/articles/11880026 (+ rassegne terze)

**Taglie a 7 cifre (§5-ter):** mentfunding.com · luxtradingfirm.com/rules-of-engagement-3/ ·
support.devrev.ai/.../how-is-the-7-maximum-loss-calculated-in-axi-select (help ufficiale Axi) ·
fxify.com/blog/top-prop-firms-with-static-drawdown/ · fxify.com/blog/introducing-fxify-2-phase-pro/ ·
help.goatfundedtrader.com/en/articles/10831213-how-does-the-scaling-plan-work ·
help.fundednext.com/en/articles/13349186-fundednext-pro-the-scale-up-program ·
help.fundednext.com/en/articles/8019659-does-fundednext-offer-a-scale-up-plan ·
help.alphacapitalgroup.uk/en/articles/6933852-how-does-the-scaling-plan-work ·
ftmo.com/en/reward-growth-and-scaling-plan/ · ftmo.com/en/premium-programme/

**E8 Markets:** help.e8markets.com/en/articles/11775980 (E8 One) (+ rassegne terze)

**Terze parti (etichettate come tali, mai criterio):** proptradingvibes.com ·
tradetanto.com · propfirmmatch.com · thetrustedprop.com · tradingfinder.com ·
brokeranalysis.com · eafunded.com · fortraders.com · nordman-algorithms.com ·
thepayoutreport.com (aggiornamenti FTMO feb-2026) · quantvps.com · fxempire.com ·
luxalgo.com · myfxbook.com

**Interne:** `backtest_pipeline/risultati_archivio/ANALISI_DIAL_TAGLIE_2026-08-26.md` ·
`ANALISI_SOPRAVVIVENZA_FUNDED_2026-08-26.md` ·
`backtest_pipeline/caccia_strategie/DOSSIER_PROP_UPCOMERS_2026-08-26.md` ·
`report/METRO_PROP.md` · `report/FIRME_2026-08-18.md` ·
`docs/REGOLAMENTO_FTMO_2026-08.md` · `docs/REGOLAMENTO_FUNDINGPIPS_2026-08.md`
