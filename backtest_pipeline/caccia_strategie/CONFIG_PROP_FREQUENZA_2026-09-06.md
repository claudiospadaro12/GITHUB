# 🎯 CACCIA CONFIG-PROP — **CECCHINI O MACINA?** — 06/09/2026 (notte)

_Mandato: Claudio ha chiuso la serata con **"dobbiamo trovare ancora nuovi
motori, non bastano questi"**. Il miglior candidato della giornata fa **0,14
op/giorno** (~33/anno) contro un pavimento di casa di **0,70-1,00 op/giorno per
motore/lato** (criterio C2 delle cacce TF, 05/09). La domanda vera: **chi passa
le prop davvero lo fa con UN motore che macina o con TANTI cecchini in
parallelo?**_

**Questo file non tocca niente.** Nessun EA, nessun preset, nessun parametro in
forward. Sono carta, misure e proposte: decide Claudio.

---

## 🔴 LA RIGA CHE CONTA

> Ho censito **6 prop** (tutte `[LETTO-VIA-SEARCH]`: i siti ufficiali restano
> murati) e **14 prodotti/fonti** su **mql5.com**, l'unica fonte davvero aperta
> stanotte. E la risposta alla domanda di Claudio **e' misurata, non opinata**:
>
> ## 🥇 **IL CAMPO NON MACINA CON UN MOTORE. IL CAMPO SCHIERA CECCHINI IN PARALLELO SU TANTI SIMBOLI.**
>
> Il dato piu' pesante della notte e' un **conto vero, con statistiche
> calcolate da MQL5 (non dal venditore)**: il portafoglio Profalgo
> (`signals/2204998`) gira **3-5 EA su 26 simboli** e fa **37,8-61 operazioni a
> settimana di CONTO**. Diviso per i simboli fa **0,29-0,47 operazioni al
> giorno PER SIMBOLO**: cioe' **ogni singola istanza e' un cecchino**, nella
> stessa fascia del nostro candidato da 0,14 — ed e' il **numero di simboli**,
> non la velocita' del motore, a produrre la portata.
>
> 👉 **Conseguenza diretta sul criterio di casa**: il pavimento **0,70-1,00
> op/giorno** e' calibrato **all'estremo ALTO** di cio' che il campo misurato
> fa per istanza (0,29-1,0). Applicato alla **sedia singola** butta via motori
> che il campo userebbe; applicato alla **FAMIGLIA** (motore × simboli
> schierabili) e' esattamente il metro giusto — **ed e' gia' l'unita' di misura
> del criterio di uscita firmato il 18/08 ("MERITO per FAMIGLIA a 20
> operazioni")**. La proposta n.1 di stanotte costa **zero righe di codice**.
>
> ⚠️ **E il prezzo di quella strada e' misurato pure lui**: i due portafogli
> "prop firm ready" a larga base che ho letto hanno **drawdown misurato del
> 32,59% e del 45,64%** (per saldo). La larghezza senza controllo della
> correlazione **e' esattamente la trappola** — ed e' il buco che il nostro
> cap C1 3,25% + P0 (simbolo+lato) copre solo a meta': **manca il tetto per
> VALUTA/cluster**, che nel campo esiste e vale **3,0%**.

---

## 1. 🧪 CONTROLLO POSITIVO — fonte per fonte, fatto PRIMA di cercare

| fonte | prova | esito | conseguenza |
|---|---|---|---|
| **ftmo.com** | `GET /en/trading-objectives/` | ❌ **EGRESS_BLOCKED** (gateway 403 al CONNECT, registrato in `__agentproxy/status` alle 21:35:51Z) | 🛑 **NULLA.** Zero lettura diretta del normativo FTMO |
| **help.fundingpips.com** | `GET /en/` | ❌ **EGRESS_BLOCKED** (403 al CONNECT, 21:35:52Z) | 🛑 **NULLA** |
| **www.mql5.com** (Market, CodeBase, Articoli, Blog, Forum, **Signals**, Freelance) | 5 pagine diverse | ✅ **200, contenuti veri, pagine piene** | 🥇 **la fonte della notte.** Ci ho trovato l'unica evidenza MISURATA |
| **api.github.com** | `/rate_limit` ✅ 200 · `/search/repositories` ❌ **403** _"sessions are bound to their configured repositories"_ | 🟡 **mezza NULLA** | 🛑 **niente scoperta su GitHub stanotte.** `raw.githubusercontent.com` risponde (200) ma solo se conosco gia' il percorso esatto |
| **github.com** (web) | `/search`, `/topics/mql5` | ❌ **403** | 🛑 NULLA |
| **forexfactory.com** | `GET /` | ❌ **403** | 🛑 NULLA |
| **myfxbook.com · fxblue.com · reddit.com/r/propfirm** | `GET /` | ❌ **000** (connessione non stabilita) | 🛑 NULLA — **niente track record verificati di terze parti** |
| stampa di settore: propfirmatlas · propjournal · tradetanto · propfirmmatch · propscorer · damnpropfirms · propvator · luxalgo · h2tfunding · eafunded · robotfx · alfatactix | 12 URL provati | ❌ **000 / EGRESS_BLOCKED** (12 su 12) | 🛑 NULLA. **Nessuna tabella comparativa di terze parti apribile** |
| **WebSearch** | 14 interrogazioni | ✅ restituisce estratti dalle pagine murate | 🥉 usato per **tutte** le regole prop, con etichetta dedicata |

### ⚠️ L'ETICHETTA DA LEGGERE PRIMA DEL §5

**Nessun sito ufficiale di prop e' raggiungibile** (identico al 31/08). Quindi
**ogni riga di regola nel §5 e' `[LETTO-VIA-SEARCH]`**, mai `[VERIFICATO]`:
viene dall'estratto che il motore di ricerca ha tratto dalla pagina, non dalla
pagina che ho aperto io. **Prima di comprare una challenge si rilegge tutto sul
sito, quel giorno.**

Al contrario, **tutto il §3 e' `[LETTO]`**: le pagine mql5.com le ho aperte.

---

## 2. 📕 COSA HO LETTO IN CASA PRIMA DI USCIRE

`CLAUDE.md` (criterio di uscita delle sedie 18/08, pacchetto rischio firmato),
`report/PIANO_PROP.md` **area H integrale** (H0-H5: portata misurata,
aritmetica del fabbisogno, requisiti di frequenza contro i nostri numeri),
`report/CONFIG_PROP_2026-08-31.md` (il dossier config-prop precedente, 11
esempi + 12 buchi + 7 proposte), `mql5/Experts/ABTG_Guardian.mq5` (input reali,
righe 68-88), `backtest_pipeline/caccia_strategie/CACCIA_TF_M15_2026-09-05.md`
(criterio **C2**, il pavimento di frequenza).

**Cio' che NON riapro** (gia' fatto il 31/08, non lo rifaccio): il censimento
dei guardiani di conto, la clausola HFT per tempo di tenuta, la Risk Per Trade
Idea di FundingPips, la catena del calendario news. Stanotte si batte **solo**
il versante FREQUENZA + TAGLIE + regole aggiornate.

---

## 3. 🥇 LA DOMANDA DELLA NOTTE — CECCHINI IN PARALLELO O MOTORE CHE MACINA?

### 3.1 L'evidenza MISURATA — statistiche calcolate dalla piattaforma, non dal venditore

Questa e' la parte che pesa: le pagine **MQL5 Signals** pubblicano statistiche
che **MQL5 calcola dallo storico del conto**, non che il venditore scrive.

| # | conto · fonte | struttura | operazioni | **frequenza CONTO** | **frequenza PER SIMBOLO** | tenuta media | **DD misurato** |
|---|---|---|---|---|---|---|---|
| **S1** | **The Gold Reaper Live default settings** · [signals/2195619](https://www.mql5.com/en/signals/2195619) `[LETTO]` | **1 EA, 1 simbolo** (XAUUSD.p), multi-TF | **1.308** "trades" in **939 giorni** (dal 03/02/2024) | **5 op/settimana** = **~1,0 op/g** | 1,0 op/g (un simbolo solo) | **7 ore** | 🔴 **45,64%** (per saldo) · crescita 229,08% · win 72,09% |
| **S2** | **Gold Reaper + Goldtrade Pro + Daytrade Pro** · [signals/2204998](https://www.mql5.com/en/signals/2204998) `[LETTO]` | 🥇 **3-5 EA su 26 SIMBOLI** (XAUUSD 2.660 · USTEC 1.040 · US500 896 · US30 599…) | **7.930** in **210 settimane** | **37,8 op/sett** (rapporto grezzo) — **61/sett** dichiarato dalla pagina | 🥇 **1,45-2,35 op/sett per simbolo = 0,29-0,47 op/GIORNO** | **16 ore** | 🔴 **32,59% per saldo** · 🟡 **9,00% per equity** · PF **1,19** · win 62,13% · crescita 953,77% |
| **S3** | **Chiroptera** (4 signal su 4 broker) · prodotto [152565](https://www.mql5.com/en/market/product/152565) `[LETTO]`, statistiche `[LETTO-VIA-SEARCH]` | **1 EA su 28 COPPIE**, sessione notturna 2-3 h/giorno | **2.276** in **~24 settimane** | **~95 op/sett** = ~13,5 op/g | **~3,4 op/sett per coppia = ~0,68 op/g** | n/d | 🔴 **36% - 49%** su quattro broker |

> ⚠️ **Onesta' sui numeri, dichiarata**: su **S1** il rapporto grezzo
> (1.308/939 gg = 9,7/settimana) **non torna** col "5 per settimana" della
> pagina; torna **se "trades" conta i DEAL** (entrata+uscita) e le posizioni
> sono ~654 → 4,9/settimana ✅ — **[INFERITO]**, non letto. Su **S2** succede
> il **contrario** (7.930/210 = 37,8 contro "61/settimana" scritto in pagina) e
> **non ho una spiegazione**: riporto **entrambi** i numeri e uso l'intervallo.
> Non aggiusto una fonte per farla tornare.

### 3.2 L'evidenza DICHIARATA — quello che vendor, autori e COMPRATORI scrivono

| # | fonte `[LETTO]` salvo diverso | struttura dichiarata | **frequenza dichiarata** |
|---|---|---|---|
| **D1** | 🥇 **Freelance MQL5 [job/186785](https://www.mql5.com/en/job/186785)** — la specifica scritta da **chi COMPRA** un EA per FTMO/E8/MFF (50-150 $) | — | **"At least 3 trades per week"** = **0,6 op/g** · _"Good Risk Settings (5-10% maximum drawdown)"_ · _"No martingale, or grid or any risky methods, only SL and TP or Trail"_ · **"At least 10-20% profit per month"** |
| **D2** | **Prop Firm Gold EA** · [market/153540](https://www.mql5.com/en/market/product/153540), 339 $ | 1 simbolo (XAUUSD) | _"almost every day, sometimes takes around **1-3 trades per day**"_ |
| **D3** | **blog 769158** (vendor, prodotto 169254) | 1 simbolo (XAUUSD) | _"Average: **1 trade per day**"_ |
| **D4** | 🥇 **blog 767576** — "Best EA Settings for Funded Accounts: Portfolio + Daily Limits" | **5 moduli di strategia su 4 strumenti** (XAUUSD, ETHUSD, EURJPY ×2 strategie, USDJPY) | frequenza non dichiarata; **0,5% di rischio per modulo**, conto minimo **10.000 $** |
| **D5** | 🥇 **PROPHECY 1.16** · [blog 774924](https://www.mql5.com/en/blogs/post/774924) (28/08/2026) | **12 moduli su 12 COPPIE** (AUDCAD H4, CADJPY H4, CHFJPY M30 ×2, EURGBP H1, GBPAUD H4, GBPNZD H4, GBPUSD M30, NZDCHF H1, EURCAD H1, USDCHF H4, EURNZD H4) | non dichiarata (e' a **panieri**, vedi bandiere rosse §6) |
| **D6** | **blog 751550** — presentazione + **preset** di un EA multi-indicatore per prop | 4 preset su **3 coppie** (EURUSD M5/M10, AUDUSD M10, GBPUSD M5/M10) | _"developed to only **open one trade at a time**"_ · _"doesn't necessarily have to open every day"_ |
| **D7** | **forum [456749](https://www.mql5.com/en/forum/456749)** — trader veri `[LETTO]` | Torbjoern Brenden: **"4 different EAs on a 10k account"** → _"+0.6% out of 8% in phase 1"_ in 7 giorni (e prima aveva _"blew up the first account in only 3 days"_) · Abdul Salam Basit: _"**2 different EA's** to pass prop firm's Challenges on regular basis"_, _"their DD is quiet low"_ | — |
| **D8** | aggregatore `[LETTO-VIA-SEARCH]`, **NON verificato** | un trader (manuale) | _"Phase 1 with **18 trades over 67 days**, achieving 11.2% profit"_ = **0,27 op/g** — **passata** |

### 3.3 🎯 IL VERDETTO, con i numeri

**1. Il campo NON usa un motore che macina. Usa POCHI motori × MOLTI simboli.**
Su 8 configurazioni con struttura dichiarata o misurata: **1 simbolo** in 3
casi (S1, D2, D3), **3-5 strumenti** in 2 casi (D4, D6), **12-28 simboli** in 3
casi (S2, S3, D5). **Nessuna** e' "un solo motore veloce su un solo simbolo che
fa 3-5 operazioni al giorno".

**2. La frequenza PER ISTANZA del campo sta fra 0,29 e 1,0 op/giorno.**
S2 (il piu' largo e il piu' misurato): **0,29-0,47**. S3: ~0,68. S1: ~1,0.
D1 (la specifica del compratore): **0,6**. D2/D3: 1-3 e 1,0.
👉 **Il nostro pavimento 0,70-1,00 op/g sta all'estremo ALTO di quella scala.**
Il candidato da **0,14** e' comunque **2-3× sotto** anche la piu' lenta delle
istanze misurate — non e' "normale", ma **non e' fuori dal mondo come sembrava**:
la distanza da colmare e' un **fattore 2-3 di simboli**, non un motore nuovo.

**3. Nessuna regola prop, di nessuna delle 6 censite, misura la frequenza per
MOTORE.** Le uniche regole di attivita' esistenti sono **di CONTO**:
- **giorni minimi di trading**: FTMO **4** per fase · FundingPips **3** (P1) `[LETTO-VIA-SEARCH]`
- **inattivita'**: FundingPips **30 giorni** senza un trade = **HARD BREACH**;
  The5ers **60 giorni**; FundedNext la applica **anche in evaluation** `[LETTO-VIA-SEARCH]`
- **consistenza**: FTMO 1-Step **best day ≤ 50%**; FundingPips Zero **15%** +
  **7 giorni profittevoli ≥0,25%** ogni 30 `[LETTO-VIA-SEARCH]`
👉 **Tutte e tre si soddisfano con la LARGHEZZA, non con la velocita' di una
sedia.** E la piu' cattiva (l'inattivita' a 30 giorni) e' l'unica che un
cecchino **da solo** rischia davvero: a 0,14 op/g in regime di Poisson,
**P(nessun trade in 30 giorni) = 1,50% per intervallo → ~0,53 buchi l'anno**.
Con **due** cecchini in parallelo il rischio crolla a **0,02 buchi/anno**.
Calcolato stanotte, ipotesi Poisson dichiarata (un cecchino vero e' a raffiche,
quindi il rischio reale e' **peggiore** di cosi').

**4. E allora dov'e' il vero costo di un cecchino? NON nella challenge: nel
NOSTRO CALENDARIO DI GIUDIZIO.** Calcolo di stanotte:

| op/giorno del motore | op/anno | giorni per **150 op** (finestra IS di casa) | anni | giorni per **20 op** (giudizio di MERITO, 18/08) |
|---:|---:|---:|---:|---:|
| **0,14** | 35 | **1.071** | **4,3** | **143** (~7 mesi) |
| 0,30 | 76 | 500 | 2,0 | 67 |
| 0,50 | 126 | 300 | 1,2 | 40 |
| **0,70** | 176 | 214 | 0,9 | **29** |
| 1,00 | 252 | 150 | 0,6 | 20 |

> 🔴 **Il cecchino non fallisce la challenge: fallisce il TAGLIANDO.** A 0,14
> op/g una **sedia** arriva a 20 operazioni in **7 mesi** — cioe' **dopo** il
> tagliando dei 6 mesi, che la troverebbe "sotto 20 op" e la manderebbe in
> revisione senza mai averla giudicata. **Ma la stessa regola dice "MERITO per
> FAMIGLIA"**: cinque simboli dello stesso motore fanno **0,70 op/g di
> famiglia** e chiudono il giudizio in **29 giorni**. La regola di casa e'
> gia' scritta giusta; e' il **pavimento della caccia** ad essere applicato
> all'unita' sbagliata.

**5. Quanto costa in TEMPO, al conto** (E di casa, rischio 0,65%, +10% fase 1):

| frequenza di CONTO | +10% a E=0,075R (205 trade) | a E=0,046R (334 trade) |
|---:|---|---|
| 0,14 (un cecchino solo) | **69,7 mesi** | 113,6 mesi |
| 0,70 (5 simboli) | 13,9 mesi | 22,7 mesi |
| 1,12 (8 simboli) | **8,7 mesi** | 14,2 mesi |
| 3,70 (**la flotta viva di oggi**) | 2,6 mesi | 4,3 mesi |
| 5,60 | 1,7 mesi | 2,8 mesi |
| 8,70 (**S2, il portafoglio misurato**) | **1,1 mesi** | 1,8 mesi |

👉 Il portafoglio Profalgo misurato (**8,7 op/g di conto, fatte da 26 istanze
lente**) e' **2,4× la portata della nostra flotta intera** — e ci arriva
**senza un solo motore veloce**.

**6. 🔴 IL PREZZO, misurato: la larghezza senza controllo della correlazione
paga in DRAWDOWN.** S1 **45,64%**, S2 **32,59% per saldo**, S3 **36-49%**.
Tutti e tre marchiati **"PROP FIRM READY"**. Su un muro totale del 10% sono
**3-5 volte il muro**. 🚩 **Il marchio "prop firm ready" e' marketing, non una
misura** — e questa e' la lezione piu' dura della notte.
Nota: S2 dichiara **9,00% di DD per EQUITY** contro 32,59% per saldo: la
differenza fra i due numeri **e' il segno di posizioni tenute in perdita**
(e/o di prelievi) — da leggere sempre **entrambi**, come facciamo in casa.

---

## 4. 📏 LE TAGLIE — dove siamo fuori scala, e di quanto

**I nostri numeri** (firmati 18/08, letti stanotte dal sorgente
`ABTG_Guardian.mq5` righe 68-79): rischio/trade **0,65%** · `InpMaxOpenRiskPct`
**3,25%** · `InpDailyPausePct` **4,0** · `InpDailyLossPct` **5,0** (blocco a
4,9 come da preset) · `InpTotalDDPct` **10,0** (9,9) · `InpDDMode` **0**
(statico) · reset **23** (preset, confermato dal canarino 02/09).

| grandezza | 🌍 cosa ho trovato fuori (valore · fonte · etichetta) | 🏠 noi | 📐 verdetto |
|---|---|---|---|
| **rischio per trade** | **0,15-0,25%** profilo challenge (`InpBaseRiskPct 0.15` challenge, `0.25` generale, `0.20` funded — blog **775436**, 06/09, `[LETTO]`, **vendor**) · **0,5%** "the funded account standard" (blog 767576 + articolo 20587/19655 famiglia `[LETTO]`) · **1,0%** (preset D6 `[LETTO]`) · **1,5-2,0%** default di mercato (blog 769682 `[LETTO]`; articolo **19655**: `RiskPct = 2.0`) · _"most MQL5 Market EAs default to 2-3%… **0,5-0,75% is the realistic prop setting**"_ `[LETTO-VIA-SEARCH]` · **0,1%** su 100k (forum `[LETTO-VIA-SEARCH]`) | **0,65%** | 🟢 **IN SCALA.** Sta dentro la finestra "0,5-0,75% realistica per prop" e sotto i default di mercato. **Non e' qui il problema** |
| **rischio APERTO totale** | **4-6% di equity** _"professional standard"_ · input d'esempio **5%** (blog 769682 `[LETTO]`) · `PositionsTotal() < 5` (articolo 19655 `[LETTO]`) · **max 3 posizioni** in configurazione day-trading conservativa `[LETTO-VIA-SEARCH]` · **max 1** posizione (blog 775436, profilo trailing/funded) · **max 2 per simbolo** (RiskGate, art. 21720, gia' agli atti) | **3,25%** (= 5 SL vivi) | 🟢 **PIU' PRUDENTI del campo.** Siamo **sotto** il 4-6% dichiarato standard. Nessuna azione — ma vedi la riga sotto, che e' il vero buco |
| 🔴 **tetto per VALUTA / cluster correlato** | **3,0% di equity** massimo su **una singola valuta** · **3,5%** combinato per coppie parzialmente correlate (EURUSD+GBPUSD) _"non 2%+2%=4%"_ (blog 769682 `[LETTO]`) · `InpMaxRiskPerCurrency = 2.0` (blog 775436 `[LETTO]`) · _"lotto ×0,5 se lo stesso gruppo magic ha gia' una posizione"_ (RiskGate, agli atti) | ❌ **NIENTE** — abbiamo il cap globale 3,25% e P0 (simbolo+lato, costruito il 02/09, **spento**) | 🔴 **BUCO VERO.** Il grappolo DAX delle 08:15 e il grappolo Dow delle 14:30 sono **cluster di valuta/indice**, non "stesso simbolo". Il campo ha un numero per questo e noi no |
| 🟠 **freno giornaliero** | **2-3%** _"positioned as **half the prop firm limit**"_ (blog 767576 `[LETTO]`) · `InpMaxRiskPerDay = 1.0` + `InpPanicCloseAtLossPct = 2.0` (blog 775436 `[LETTO]`) · `DailyDDLimit = 2.5` con `OverallDDLimit = 5.5` su muri 5/10 (articolo **19655** `[LETTO]`) · **3%** _"of start-of-day equity"_ (blog 769682) · **4,5% invece di 5%** (KT Equity Protector, agli atti) · **4,9 se la regola e' 5** (preset D6 `[LETTO]`) | **pausa 4,0 · blocco 4,9** su muro 5,0 | 🟠 **QUI SIAMO L'ESTREMO PIU' AGGRESSIVO DEL CAMPIONE.** Il campo frena a **meta' muro** (2-3%), noi a **0,1 punti dal muro**. ⚖️ **Attenuante forte, e va scritta**: la nostra **peggior giornata MISURATA e' −2,06%** (R51) e la p99 Monte Carlo e' 8,1% su 27 serie — un freno a 2,5-3,0% non morderebbe quasi mai. **Cioe' costa poco e compra margine**: e' la proposta P-C |
| **DD totale** | **10%** statico (FTMO 2-Step) · **5,5%** come limite interno su muro 10 (art. 19655) · **12-15%** su conti personali (blog 769682) | 9,9 su 10 | 🟢 in scala |
| **max richieste al server** | 🆕 **2.000 al giorno** — FTMO: _"an excessive number of more than 2,000 server requests per day on individual simulated trades or pending orders being opened, modified, or closed"_ = motivo di **terminazione**; e _"every tick-by-tick stop-loss trail… counts as a request"_ `[LETTO-VIA-SEARCH]`, **due fonti indipendenti concordi** | ❌ **mai misurato** | 🟡 **BUCO NUOVO, non era nei dossier.** Con 37 sedie, trailing e pendenti che si modificano, e' un numero **che sappiamo contare dai log**. Proposta P-D |
| **sorveglianza INATTIVITA'** | **30 giorni** = hard breach (FundingPips) · **60** (The5ers) · anche in evaluation (FundedNext) `[LETTO-VIA-SEARCH]` | ❌ nessun contatore | 🟡 irrilevante oggi (3,7 op/g), **diventa reale il giorno in cui si va sui cecchini**. Proposta P-E |

---

## 5. 🏛️ LE SCHEDE PROP — rilette stanotte, tutte `[LETTO-VIA-SEARCH]`

```
PROP            FTMO 2-Step        URL REGOLE  ftmo.com/en/trading-objectives (BLOCCATO)
LETTA IL        06/09/2026         ETICHETTA   [LETTO-VIA-SEARCH]
MURO TOTALE     10%  STATICO ("non-trailing", confermato da 2 estratti indipendenti)
MURO GIORNAL.   5%   calcolato sul saldo di APERTURA della giornata di trading
TARGET          Fase 1 10%  ·  Fase 2 5%
TEMPO           NESSUN limite (entrambe le fasi, "unlimited time")
GIORNI MINIMI   4 per fase  <-- CONFERMATO: una ricerca dedicata dice che NON risulta
                alcuna rimozione del minimo di 4 giorni nel 2026. Un primo estratto
                diceva "10 giorni": e' RISULTATO ISOLATO E NON CONFERMATO -> [INCERTO],
                ma il peso delle fonti sta sul 4. Sul funded: nessun minimo.
CONSISTENZA     NESSUNA sul 2-Step ("no Best Day Rule or equivalent consistency mechanic")
NEWS            regola gia' agli atti (31/08): +/-2 min sugli strumenti colpiti,
                INCLUSA l'esecuzione dei pendenti. Conto SWING esente.
EA              ammessi. NUOVO: tetto di 2.000 richieste al server al giorno.
INATTIVITA'     nessun limite fisso: "FTMO ti contatta dopo qualche settimana"; esiste
                il congelamento del conto. Un solo trade nella finestra basta.
```

```
PROP            FTMO 1-Step        LETTA IL 06/09/2026     [LETTO-VIA-SEARCH]
NOVITA' 2026    lanciato a FEBBRAIO 2026, una fase sola, target 10%, split 90% dal
                primo giorno.
MURO GIORNAL.   3%  (contro il 5% del 2-Step)
MURO TOTALE     10%, ma con PAVIMENTO TRAILING DI FINE GIORNATA ("end-of-day trailing floor")
CONSISTENZA     BEST DAY 50% dei "Positive Days' Profit", in evaluation E sul funded.
                *** Sfumatura che cambia la lettura: superare la soglia NON e' un breach:
                "can be resolved by continuing to trade and increasing your Positive
                Days' Profit until the proportion falls below 50%". E' un cancello di
                avanzamento, non una ghigliottina. ***
VERDETTO CASA   -> il 2-Step resta la scelta giusta: muro giornaliero 5 invece di 3,
                DD STATICO (le nostre Monte Carlo valgono), nessuna consistenza.
                Il nostro best-day misurato e' 43,6% sul 100k: sul 1-Step sarebbe
                un problema aperto, sul 2-Step non esiste.
```

```
PROP            FundingPips        LETTA IL 06/09/2026     [LETTO-VIA-SEARCH]
2-STEP STANDARD 5% giornaliero · 10% totale · leva 1:100 · NEWS TRADING PERMESSO
ZERO            3% giornaliero · consistenza 15% (biggest winning day / profitto totale)
                · almeno 7 giorni con profitto netto >= 0,25% del Master ogni 30
                per tenere il conto attivo · NEWS VIETATE
INATTIVITA'     almeno un trade ogni 30 giorni consecutivi, altrimenti TERMINAZIONE.
                Dichiarata HARD BREACH insieme a Max Daily Loss e Max Trailing Loss.
GIORNI MINIMI   3 (P1), come gia' agli atti
```

```
PROP            The5ers · FundedNext · E8 · Alpha   LETTE IL 06/09/2026   [LETTO-VIA-SEARCH]
The5ers         inattivita' 60 giorni (la piu' generosa del gruppo). Consistenza 50%
                (gia' agli atti 31/08).
FundedNext      applica la regola di inattivita' ANCHE in evaluation (unico caso trovato).
E8 / Alpha      nessuna novita' rispetto al 31/08 (E8: max 50% dei trade sotto 1 minuto;
                Alpha: sorgente MQ5 da sottoporre per approvazione).
```

---

## 6. 🚩 BANDIERE ROSSE CENSITE (da scartare, ma sapere che girano serve)

| prodotto · fonte | prezzo | la bandiera, testuale |
|---|---|---|
| 🔴 **HFT PropFirm EA MT5** · [market/117386](https://www.mql5.com/en/market/product/117386) `[LETTO]` | **200 $** | Richiede _"VPS of 200ms or less latency"_ e dichiara **in pagina di vendita**: _"**not intended to be used on live, real, or funded account** because of introduced slippage and high spread by your broker"_ + _"Brokers/Prop Firms add slippage… thus making this EA cannot profit"_. 👉 **E' un prodotto che si vende dicendo che funziona SOLO sul server della challenge.** Elenca 15+ prop "passate" (Paid to Trade, Irizone, We Fund, Coin Funded, Delta Funding…). **Questo e' esattamente il tipo di cosa per cui le prop hanno scritto la clausola HFT.** Fuori |
| 🔴 **PROPHECY 1.16** · [blog 774924](https://www.mql5.com/en/blogs/post/774924) `[LETTO]` | — | **A PANIERI**: lotto iniziale 0,01 → **"Max Total" 0,10** (×10) · _"New-Basket Ceiling"_ 0,08 · **"hard basket age limit: 21 days"** prima della chiusura forzata · _"Emergency ATR Stop: **disabled by default**"_ (16 ATR quando acceso) · curva "Stagnation TP" che **abbassa il target** dal giorno 7 al giorno 16 (80% → 50%). 🚩 **Mediazione + niente stop di default + target che si abbassa per non chiudere in perdita** = la famiglia griglia/recovery. 12 coppie in parallelo la rendono peggiore, non migliore |
| 🟠 **"trade randomizer" / "Randomization"** · Prop Firm Gold EA [153540](https://www.mql5.com/en/market/product/153540) e The Gold Reaper [111357](https://www.mql5.com/en/market/product/111357) `[LETTO]` | 339 $ / 949 $ | Input dedicato a rendere **"unique entries/exits"** fra conti diversi. Esiste **perche'** le prop segnalano i trade identici su piu' conti (FTMO: rischio di classificazione come copy/group trading; E8: **una sola strategia unica per utente**). 🟠 **Zona grigia**: non e' un trucco sui muri, ma e' un meccanismo nato per **non farsi riconoscere**. **Da NON copiare** — a noi non serve: i nostri EA sono nostri e girano su un conto solo |
| 🟠 **il marchio "PROP FIRM READY"** · S1, S2, S3 | 199-949 $ | DD **misurato** 32,59% / 45,64% / 36-49% su un muro totale del **10%**. 👉 **il marchio non e' una misura** |
| 🟠 **la specifica del compratore** · [job/186785](https://www.mql5.com/en/job/186785) `[LETTO]` | 50-150 $ | _"At least 10-20% profit per month (Average)"_ con _"5-10% maximum drawdown"_, per **50-150 dollari**, in **2-15 giorni** di sviluppo. 👉 Utile come misura di **quanto e' scollata l'aspettativa del mercato**: il nostro banco a taglie piene da **6,6%/mese** ed e' gia' il numero ottimista |

---

## 7. 🕳️ LA TABELLA DEI BUCHI — cosa manca a noi, meccanismo per meccanismo

| # | meccanismo trovato fuori | ce l'abbiamo? | il buco in una riga |
|---|---|---|---|
| **F1** | 🔴 **portata per LARGHEZZA (1 motore × N simboli), non per velocita'** | 🟡 **a meta'**: PTE gira su 2 coppie, ma **il criterio di caccia scarta il motore lento PRIMA di chiedersi su quanti simboli vive** | e' la proposta **P-A**, costo **zero codice** |
| **F2** | 🔴 **tetto di esposizione per VALUTA / cluster** (3,0% · 3,5% correlate · `InpMaxRiskPerCurrency 2.0`) | ❌ **NO** (cap globale 3,25% + P0 simbolo+lato, spento) | proposta **P-B**. E' il buco che il grappolo DAX/Dow rende concreto |
| **F3** | 🟠 **freno giornaliero a META' muro** (2-3% su muro 5%) | ❌ noi freniamo a 4,0/4,9 | proposta **P-C**, costa una riga di preset |
| **F4** | 🟡 **budget di richieste al server** (FTMO 2.000/giorno) | ❌ mai misurato | proposta **P-D** |
| **F5** | 🟡 **sorveglianza inattivita'** (30/60 giorni) | ❌ nessun contatore | proposta **P-E** |
| **F6** | 🟡 **simulatore di challenge RIPETUTE** (pass-rate + distribuzione del tempo per passare) — articolo MQL5 **22969** `[LETTO]`: `InpPropMaxDailyLossPct 5.0` · `InpPropMaxOverallLossPct 10.0` · `InpPropProfitTargetPct 8.0` · `InpPropMinTradingDays 5` · `InpPropDurationDays 30`, con **tentativi mobili** e ragioni di fallimento | 🟡 **in parte**: C7 (pass-rate, dirupo d≈1,055) e R105 (mediana 12 giorni a +8%) fanno gia' questo | proposta **P-F**: renderlo il **collaudo standard di ogni candidato**, non un round speciale |
| **F7** | 🟢 **verificatore indipendente delle regole sui nostri CSV** — CodeBase **76955** "Prop Firm Rule Checker", **pubblicato il 06/09/2026** (oggi), gratis: controlla target, max daily loss, max DD, **consistenza**, giorni minimi su uno storico chiuso | 🟡 lo facciamo a mano/script | proposta **P-G**, costo minimo |
| **F8** | ✅ riduzione taglia vicino ai muri, chiusura a gradini, reset consapevole del fuso, filtro news, cancellazione pendenti | ✅ **SI'** (gia' censito il 31/08) | nessun buco nuovo |

---

## 8. 📋 LE PROPOSTE — cosa / dove / fonte / costo / rischio

🔴 **Nessuna si applica da sola.** Decide Claudio; poi passano dall'imbuto come
qualunque modifica.

```
PROPOSTA P-A  IL PAVIMENTO DI FREQUENZA SI APPLICA ALLA FAMIGLIA, NON ALLA SEDIA
DOVE          criterio di caccia C2 (dossier TF M5/M15/M30) + report/PIANO_PROP.md area H8.
              NESSUN codice, nessun EA, nessun preset.
FORMULA       "un motore entra nell'imbuto se  f_per_simbolo x N_simboli_con_edge_MISURATO
               >= 0,70 op/giorno di FAMIGLIA", con TRE paletti non negoziabili:
               (1) ogni simbolo porta il SUO edge misurato (niente cherry-picking: vale
                   la regola dei due lati del 25/08);
               (2) il conteggio dei simboli e' quello su cui l'edge REGGE, non quelli su
                   cui il motore "gira";
               (3) la famiglia dichiara la sua CORRELAZIONE attesa: se le N sedie sparano
                   nella stessa mezz'ora sullo stesso cluster, N non vale N (vedi P-B).
FONTE         S2 (26 simboli a 0,29-0,47 op/g per simbolo = 8,7 op/g di conto, MISURATO),
              S3 (28 coppie), D4 (5 moduli/4 strumenti), D5 (12 moduli/12 coppie);
              + il calcolo di casa del 3.3 (a 0,14 op/g una SEDIA si giudica in 7 mesi,
              una FAMIGLIA da 5 simboli in 29 giorni);
              + la coerenza col criterio firmato il 18/08 ("MERITO per FAMIGLIA a 20 op").
COSTO         ZERO ore di codice. E' una riga di criterio + una colonna in piu' nei
              dossier di caccia ("simboli su cui l'edge e' misurato").
RISCHIO       ALTO se si sbaglia il paletto (3): moltiplicare le sedie senza misurare la
              correlazione e' ESATTAMENTE come si arriva ai DD del 32-49% misurati su
              S1/S2/S3. Il paletto non e' un ornamento: e' il prezzo del biglietto.
PRIORITA'     1 -- costa zero, e cambia il verdetto sul candidato di oggi (0,14 op/g)
              da "scartato" a "da misurare su N simboli". E' la cosa che Claudio
              ha chiesto stanotte.
```

```
PROPOSTA P-B  TETTO DI ESPOSIZIONE PER VALUTA / CLUSTER CORRELATO
DOVE          ABTG_PausaGuardian.mqh, accanto a P0 (gia' costruito il 02/09, spento):
              un tetto sul RISCHIO sommato dei simboli che condividono una valuta
              (o un cluster dichiarato: indici US, indici EU, metalli).
              Default 0 = spento, come P0. Nessun EA da toccare per compilare.
FONTE         blog 769682 [LETTO]: "3% max exposure to any single currency",
              "3.5% combined EURUSD+GBPUSD, not 2%+2%=4%";
              blog 775436 [LETTO]: InpMaxRiskPerCurrency = 2.0;
              RiskGate art. 21720 (agli atti): lotto x0,5 sul gruppo correlato.
COSTO         ~4 ore (la funzione di rischio esiste gia', si riusa) + casi di autotest
              + la TABELLA DEI CLUSTER, che e' la parte vera del lavoro e va firmata.
RISCHIO       il tetto conta il RISCHIO, non le teste (a differenza di P0): un valore
              troppo stretto spegne il grappolo DAX delle 08:15, che e' fatto APPOSTA
              di 3 sedie. Si misura prima in modalita' allarme (InpAction=1), come P1.
PRIORITA'     2 -- e' il paletto (3) di P-A. Senza, P-A e' pericolosa.
```

```
PROPOSTA P-C  UN GRADINO MORBIDO GIORNALIERO A META' MURO (2,5-3,0%)
DOVE          preset del Guardian: un terzo livello sotto InpDailyPausePct 4,0 --
              a -2,5/-3,0% di giornata NON si blocca tutto, si RIDUCE (nuovi ingressi
              a taglia meta', oppure stop ai nuovi ingressi lasciando gestire gli aperti).
FONTE         blog 767576 [LETTO]: daily limit "2-3%", "half the prop firm limit";
              blog 775436 [LETTO]: InpMaxRiskPerDay 1.0 + InpPanicCloseAtLossPct 2.0;
              articolo 19655 [LETTO]: DailyDDLimit 2.5 su muro 5.
              CONTRO-MISURA DI CASA: peggior giornata misurata -2,06% (R51).
COSTO         ~2 ore se si riusa il canale GV esistente (GV_RISKPCT c'e' gia'!) +
              una settimana di misura in sola lettura per contare quante giornate
              lo toccherebbero.
RISCHIO       taglia il recupero di giornata: una giornata che scende a -2,6% e poi
              risale chiude piu' piccola. VA MISURATO sui nostri CSV PRIMA
              (quante giornate su 22+13 hanno toccato -2,5%? A occhio pochissime:
              il minimo misurato e' -2,06%) -- se sono zero, il gradino e' gratis
              e compra 2 punti di muro. Se sono molte, si scarta.
PRIORITA'     3 -- economica, ma e' l'unico numero dove siamo l'estremo aggressivo
              del campione esterno.
```

```
PROPOSTA P-D  CONTATORE DELLE RICHIESTE AL SERVER (tetto FTMO 2.000/giorno)
DOVE          misura, non modifica: conteggio giornaliero di OrderSend/OrderModify
              (aperture, modifiche di SL/TP, trailing, pendenti) dai log del VPS,
              per conto e per magic. Una colonna nella pagella serale.
FONTE         FTMO [LETTO-VIA-SEARCH], due estratti indipendenti concordi:
              "more than 2,000 server requests per day ... opened, modified or closed"
              = motivo di terminazione; "every tick-by-tick stop-loss trail counts".
COSTO         ~2 ore (script di conteggio sui log) + zero rischio (sola lettura).
RISCHIO       nessuno. Il rischio e' NON saperlo: con 37 sedie, trailing e pendenti
              modificati, il numero puo' essere gia' alto e nessuno l'ha mai contato.
PRIORITA'     4 -- e' una misura, e le misure in questa casa vengono prima delle opinioni.
```

```
PROPOSTA P-E  SORVEGLIANZA DELL'INATTIVITA' (30 gg FundingPips = HARD BREACH, 60 The5ers)
DOVE          Guardian: un contatore "giorni dall'ultima operazione CHIUSA sul conto"
              + un avviso nella pagella a 20 giorni. Nessuna azione automatica.
FONTE         FundingPips/The5ers/FundedNext [LETTO-VIA-SEARCH];
              + il calcolo di casa: a 0,14 op/g, P(buco > 30 gg) = 1,50% per intervallo,
              ~0,53 buchi l'anno. Con 2 cecchini: 0,02/anno.
COSTO         ~1 ora.
RISCHIO       nessuno (e' un avviso). Diventa NECESSARIA se si adotta P-A con poche sedie.
PRIORITA'     5 -- irrilevante oggi (3,7 op/g), obbligatoria il giorno dei cecchini.
```

```
PROPOSTA P-F  IL SIMULATORE DI CHALLENGE RIPETUTE COME COLLAUDO STANDARD
DOVE          backtest_pipeline: trasformare il calcolo C7/R105 in un passo fisso
              dell'imbuto -- ogni candidato promosso esce con "pass-rate su N tentativi
              mobili" e "distribuzione del tempo per passare", non solo con E, DD e n.
FONTE         articolo MQL5 22969 [LETTO] (tentativi mobili, ragioni di fallimento
              separate daily/overall, defaults 5,0 / 10,0 / 8,0 / 5 giorni / 30 gg);
              + C7 e R105 gia' in casa.
COSTO         ~1 giorno (il motore di calcolo esiste, va reso di serie e messo in referto).
RISCHIO       nessuno tecnico. Il rischio e' l'opposto: continuare a promuovere motori
              su E e DD senza mai chiedere "in quanti giorni passa, e quante volte su 100".
PRIORITA'     6
```

```
PROPOSTA P-G  CONTROPROVA INDIPENDENTE CON IL "PROP FIRM RULE CHECKER"
DOVE          CodeBase 76955 (gratis, pubblicato OGGI 06/09/2026, autore Rana Ali):
              script di sola lettura che rivaluta uno storico chiuso contro target,
              max daily loss, max DD, CONSISTENZA e giorni minimi.
FONTE         [LETTO] www.mql5.com/en/code/76955
COSTO         ~1 ora (e' uno script, gira sullo storico; nessun contatto col forward).
RISCHIO       quasi zero, MA: e' codice di terzi, quindi gira SOLO su un terminale
              di prova e su storico, mai su un conto vivo. Serve come SECONDA OPINIONE
              sui nostri conti (best day 43,6%, muri) -- non come fonte di verita'.
PRIORITA'     7
```

### Ordine raccomandato (raccomandazione dichiarata: decide Claudio)

| # | proposta | costo | perche' proprio questa |
|---|---|---|---|
| 1 | **P-A** pavimento sulla FAMIGLIA | 0 h | **e' la risposta alla domanda di stanotte**, costa zero e sblocca i candidati "cecchino" che oggi buttiamo alla porta |
| 2 | **P-B** tetto per valuta/cluster | 4 h | e' il **prezzo del biglietto** di P-A, ed e' l'unico buco di meccanismo vero del giro |
| 3 | **P-C** gradino a 2,5-3,0% | 2 h + misura | unico numero dove siamo l'estremo aggressivo; probabilmente **gratis** (peggior giornata −2,06%) |
| 4 | **P-D** richieste al server | 2 h | misura mai fatta, tetto di terminazione FTMO |
| 5 | **P-E** inattivita' | 1 h | obbligatoria solo dopo P-A |
| 6 | **P-F** simulatore di challenge | 1 g | rende di serie ciò che oggi è un round speciale |
| 7 | **P-G** rule checker esterno | 1 h | seconda opinione, non verita' |

---

## 9. 🕳️ COSA NON HO POTUTO VEDERE — dichiarato

1. 🛑 **Nessun sito ufficiale di prop.** ftmo.com e help.fundingpips.com sono
   **EGRESS_BLOCKED** (403 di policy al CONNECT, registrati nello stato del
   proxy). **Tutto il §5 e' `[LETTO-VIA-SEARCH]`.** Le due righe che possono
   cambiare una decisione — **i giorni minimi FTMO (4 contro un estratto
   isolato che diceva 10)** e il **tetto delle 2.000 richieste** — vanno
   rilette sul sito prima di comprare qualunque challenge.
2. 🛑 **GitHub: niente scoperta.** `api.github.com/search` risponde **403**
   (_"sessions are bound to their configured repositories"_) e `github.com`
   web risponde **403**. Ho potuto solo constatare che `raw.githubusercontent`
   e' vivo: **utile solo se qualcuno mi da' il percorso esatto di un file**.
   Quindi: **nessun sorgente MQL5 open source letto stanotte**, e il
   `PropFirmGuard` (con i suoi `InpDailyLossPct 5.0` / `InpTotalDdPct 10.0`)
   resta `[LETTO-VIA-SEARCH]`: la sua pagina, `mql.robotfx.org`, e' bloccata.
3. 🛑 **Nessun track record verificato di terze parti**: myfxbook, fxblue,
   Forex Factory e reddit sono tutti irraggiungibili. **L'unica evidenza
   misurata che ho e' quella dei MQL5 Signals** — che e' calcolata dalla
   piattaforma, ma **sui conti che i venditori scelgono di pubblicare**
   (selezione del sopravvissuto: i conti bruciati non diventano signal).
   👉 **Va scritto: il campione del §3.1 e' inevitabilmente distorto verso i
   sopravvissuti, e nonostante questo i DD misurati sono 32-49%.**
4. ⚠️ **Nessun `.set` scaricato.** Come il 31/08: i valori del §4 vengono da
   pannelli input, articoli, manuali e blog, **non da preset aperti**. I preset
   di PROPHECY e del "prop firm set file" del Gold Reaper sono **citati** nelle
   pagine, ma il file sta dietro l'acquisto o il download del Market.
5. ⚠️ **Nessun conto di challenge PASSATA con statistiche verificabili.**
   L'unico dato "18 trade in 67 giorni, +11,2%" e' `[LETTO-VIA-SEARCH]` da un
   aggregatore, riguarda un trader **manuale**, ed e' **non verificato**.
   👉 La domanda "quante operazioni fa CHI PASSA davvero" **non ha una risposta
   misurata** in questo dossier: ha una risposta misurata sulla **struttura di
   cio' che il campo SCHIERA** (§3.1), che e' una cosa diversa e va detta.
6. ⚠️ **Il blog 767423** ("Why Your Prop Firm EA is Getting Detected") non e'
   piu' leggibile: la fetch restituisce l'indice dei blog, non il post.
7. ⚠️ **Niente sullo SHORT.** Il mandato lo assegna all'altro cacciatore: in
   tutto il materiale prop letto stanotte **non esiste una sola configurazione
   che distingua long da short**. E' un'assenza, e la dichiaro.

---

## 10. 🧾 IL VERDETTO ONESTO, in quattro righe

1. **Alla domanda "cecchini in parallelo o motore che macina": il campo
   risponde CECCHINI IN PARALLELO, e l'evidenza e' misurata** — 26 simboli a
   0,29-0,47 op/giorno ciascuno che fanno 8,7 op/giorno di conto. **Nessuna
   delle 8 configurazioni censite e' un motore veloce solo.**
2. **Ma l'evidenza e' misurata sulla STRUTTURA, non sul SUCCESSO**: i tre conti
   che ho potuto misurare hanno DD **32-49%** e **fallirebbero** una challenge.
   La lezione non e' "copiamo la larghezza": e' **"la larghezza da' portata e
   toglie diversificazione se non si governa la correlazione"**.
3. **Sulle taglie non siamo fuori scala dove pensavamo**: 0,65% per trade e
   3,25% di rischio aperto sono **dentro o sotto** i valori del campo. L'unico
   numero dove siamo l'estremo aggressivo e' il **freno giornaliero** (4,0/4,9
   contro un campo che frena a 2-3%), e la nostra peggior giornata misurata
   (−2,06%) dice che stringerlo **costerebbe quasi niente**.
4. **Il buco di meccanismo vero e uno solo: il tetto per VALUTA/CLUSTER.**
   Tutto il resto del Guardian regge il confronto con quello che ho letto.

_E la cosa piu' utile che ho trovato non era una configurazione: e' che
**il nostro pavimento di frequenza e' applicato all'unita' sbagliata**. La
regola di casa firmata il 18/08 giudica per FAMIGLIA; la caccia scarta per
SEDIA. Bastano quelle due parole per non buttare via il candidato di oggi._

---

_Compilato nella notte del 06/09/2026. Fonti aperte davvero: **mql5.com**
(Market, CodeBase, Articoli, Blog, Forum, **Signals**, Freelance) —
14 pagine lette. Fonti dichiarate NULLE: §1 (18 domini). Calcoli di casa
eseguiti stanotte (aritmetica della frequenza, Poisson dell'inattivita',
tempo al target) sui numeri gia' agli atti di `PIANO_PROP.md` area H.
**Nessun EA, preset, grafico o parametro toccato. Nessun acquisto proposto.**_

---

## 🔗 RIMANDO — ANALISI LIVE EMILIANO 07/09/2026

➡️ **`backtest_pipeline/risultati_archivio/ANALISI_LIVE_EMILIANO_2026-09-07.md`**

Non duplico i contenuti; le **due voci che toccano la corsia prop-hardening**:

- 🇺🇸 **Festivi USA e filtro correlazione.** La sedia viva `770411` gira con
  `InpUseCorrelation=true` su `SPXUSD` e `InpUseNewsFilter=false`. Nei giorni di
  festivo americano `CorrBias()` (`ABTG_MaxMinNotte.mq5` r.698-711) legge un
  SPXUSD fermo e **non se ne accorge**: restituisce il bias del giorno prima.
  **Quanto costi non è mai stato contato** → spunto S2 del referto.
- 🌙 **Il box notturno `23:00–04:59` non è mai stato ottimizzato** (verificato:
  324 righe di CSV di corsa, un solo valore distinto per `InpBoxStartHour` e
  `InpBoxEndHour`). Non cambia nessun cancello prop, ma è una **convenzione
  spacciata per misura** in più di un documento: va saputo prima di costruirci
  sopra un ragionamento di rischio.

⚪ **Zero regole prop citate nella live** (grep: 0 occorrenze di
`prop`/`FTMO`/`challenge`/`funded`/`drawdown`) — quarta live consecutiva.
