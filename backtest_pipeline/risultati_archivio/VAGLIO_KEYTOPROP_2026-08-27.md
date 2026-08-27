# 🔎 VAGLIO — **keytoprop.com** (Key to Prop) · 27/08/2026

_Mandato: vagliare la prop firm **keytoprop.com**, segnalata a Claudio da un amico
che lavora per il broker **BCM**. **La fonte della segnalazione e' dichiarata ma NON
e' un criterio**: si giudica su regole scritte e reputazione, esattamente come le
altre 10 prop censite il 26/08._

**Nessun commit, nessun push** (richiesta esplicita del mandato).
**Nessun acquisto autorizzato da questo file.** Vale la regola D3: risposta
scritta del supporto prima di ogni euro, e decide Claudio.

---

## 0. 🎯 CONTROLLO POSITIVO E STATO DELLE FONTI — leggere PRIMA di tutto

Bersaglio a risposta nota: la pagina obiettivi FTMO **deve** restituire
5% giornaliero / 10% totale / reset 00:00 CE(S)T. Tre canali provati oggi:

| canale | bersaglio | esito | uso |
|---|---|---|---|
| `curl` diretto (proxy) | `https://keytoprop.com/trading-rules/` | `CONNECT tunnel failed, response 403` | 🛑 **NULLO** |
| **WebFetch** | `en.wikipedia.org/wiki/Proprietary_trading` (controllo **neutro** di sanita') | ❌ `EGRESS_BLOCKED` | 🛑 **NULLO — blocco totale, non anti-prop** |
| **WebSearch** | FTMO trading objectives | ✅ restituisce **5% / 10% / reset 00:00 CE(S)T** = risposta nota **centrata** | 🟢 **UNICO CANALE VIVO** |

### 🏷️ L'ETICHETTA CHE VALE PER OGNI RIGA DI QUESTO FILE

> 🟡 **`[LETTO-VIA-SEARCH 27/08/2026]`** — stessa convenzione di
> `DOSSIER_PROP_CANDIDATE_2026-08-26.md`. **Non ho aperto con i miei occhi una
> sola pagina di keytoprop.com.** Il contenuto arriva dal canale di ricerca, che
> ha letto e riassunto le pagine indicate negli URL. La SOSTANZA e' affidabile
> (sono pagine ufficiali del sito), **ma non ho la citazione letterale**.
> Dove il numero non e' comparso scrivo **NON DICHIARATO** o **[INCERTO]** —
> mai una deduzione travestita da fatto.

🔴 **Avvertenza specifica di oggi, e conta:** il canale di ricerca, interrogato
con una domanda che conteneva gia' dei numeri (_"8% / 5% / daily 5% / max 10%"_),
me li ha **restituiti attribuendoli a Key to Prop** citando pero' pagine di
terzi. **Quella riga e' stata scartata come eco della mia stessa domanda, NON
come lettura.** Le percentuali dei muri di Key to Prop, in questo dossier,
restano **NON DICHIARATE**.

---

## 1. 📏 IL METRO DI CASA — contro cui si giudica (invariato dal 26/08)

Fonti interne: `DOSSIER_PROP_CANDIDATE_2026-08-26.md`,
`ANALISI_DD_TOTALE_2026-08-26.md`, `report/METRO_PROP.md`, `FIRME_2026-08-18.md`.

| voce | numero di casa |
|---|---|
| flotta | **35 sedie vive** su **MT5**, sorgenti posseduti |
| filtro news | 🔴 **NESSUNO** — gli EA tradano dentro le notizie |
| durata trade | da **4+ minuti** a swing con tenuta **overnight e weekend** |
| lati | **due** (long e short), sedie mono-direzione dichiarate nel nome |
| peggior giornata CHIUSA | **−4,74%** (25/05/26) a dial 1,00 |
| DD totale misurato (picco-valle, chiusi) | **−6,37%** su 481 giorni |
| Monte Carlo p99 (DD **statico**) | **~8,1%** |
| 🧱 **muri necessari** | **daily 5% / totale 10%, ENTRAMBI STATICI** |
| 🔴 sul trailing | un totale **trailing 6% si rompe PERSINO sui chiusi** (6,37% > 6%) — `ANALISI_DD_TOTALE` §4: **"Muri statici o niente"** |
| leva indici | **1:15 = margine che morde · 1:25 respira** |
| payout | 🔴 **niente cap stile $3k/ciclo** se possibile |

---

## 2. 🏢 ESISTE? DA QUANDO? CHI C'E' DIETRO?

### 2.1 Esiste — si', ed e' un sito vivo e strutturato

`[LETTO-VIA-SEARCH 27/08/2026]` — il canale restituisce **pagine distinte e
coerenti** dello stesso dominio, segno di un sito reale e non di una landing:

```
keytoprop.com/                     (home)
keytoprop.com/about-us/
keytoprop.com/how-it-works/
keytoprop.com/trading-rules/       <- la pagina che conta
keytoprop.com/faq/
keytoprop.com/challenges-overview
keytoprop.com/scaling/
keytoprop.com/refund-policy/
keytoprop.com/terms  ·  keytoprop.com/privacy
my.keytoprop.com/registration  ·  portal.keytoprop.com/portal/  ·  lp.keytoprop.com/
```

🟡 **DA QUANDO: NON DETERMINABILE oggi.** Il WHOIS non e' interrogabile
(binario `whois` assente sulla macchina, porta 43 comunque fuori dal proxy
HTTPS) e i servizi web di domain-age sono dietro `WebFetch` = bloccato.
🔴 **L'eta' del dominio resta [INCERTO]** — e va chiesta indirettamente
(§7, domanda Q5: data di inizio operativita').

### 2.2 🔑 CHI C'E' DIETRO — **il fatto piu' importante del dossier**

| voce | valore | etichetta |
|---|---|---|
| **entita' legale** | _"Key to Prop is a bundle of services offered exclusively by **KEY TO MARKETS INTERNATIONAL Limited**"_ (pagina `terms` / `privacy`) | 🟡 search 27/08 |
| **giurisdizione** | privacy che cita **Data Protection Act 2017 (Mauritius)** + GDPR → entita' **mauriziana**, mercato europeo | 🟡 search 27/08 |
| **broker di appoggio** | **Key to Markets** (gruppo). About-us: _"powered by a regulated brokerage with **15+ years** of expertise in CFD trading, execution technology, and risk management"_ — 🟠 la pagina About **non fa il nome**: il nome viene dai `terms` | 🟡 search 27/08 |
| **eta' del broker** | Key to Markets **opera dal 2010** — coerente col "15+ anni" | 🟡 search 27/08 |
| **regolamentazione** | Key to Markets International Ltd = **FSC Mauritius, licenza GB19024503**; il **gruppo** e' UK e **FCA-regolato** (entita' UK distinta) | 🟡 search 27/08 |
| **LEI** | 254900OLSDNUH52WP943 (censimento globalfinreg) | 🟡 search 27/08 |
| **piattaforme** | 🟢 **MT4 e MT5** | 🟡 search 27/08 |
| **strumenti** | forex major/minor/exotic 24/5 · indici (**Nasdaq, S&P 500, DAX** citati per nome) · **oro, argento, petrolio** · CFD crypto · CFD azionari | 🟡 search 27/08 |

### 2.3 🇮🇹 E BCM? — **la domanda esplicita del mandato**

> 🔴 **RISPOSTA: NO. Il broker di appoggio di Key to Prop NON e' BCM.**
> E' **Key to Markets International Limited**, che e' l'entita' che **vende il
> servizio Key to Prop** (non solo lo esegue: i `terms` dicono _"offered
> exclusively by"_).

Il confronto, perche' la coincidenza c'e' ed e' onesto dichiararla:

| | **Key to Markets International Ltd** | **BCM Markets** |
|---|---|---|
| sede/licenza | **Mauritius, FSC** (GB19024503) | **Mauritius, FSC** |
| dal | **2010** (gruppo UK/FCA) | **2024** (ingresso nel trading online) |
| piattaforme | MT4 + MT5 | MT4 + MT5 |
| relazione documentata fra le due | 🔴 **NESSUNA trovata** — sono due broker distinti che condividono giurisdizione e piattaforme | |

🟡 **[INFERITO, e lo dico da cosa]**: due broker mauriziani FSC su MT4/MT5 sono
un'accoppiata comunissima; **la segnalazione dell'amico BCM NON e' spiegata da
un legame societario che io abbia potuto documentare**. Le spiegazioni residue,
tutte **[INCERTO]**: (a) conoscenza personale/di settore, (b) **programma di
affiliazione** — e questo secondo canale e' documentato (§5), (c) un legame
commerciale non pubblico. **Non e' una bandiera rossa in se': e' una voce che
non pesa in nessuna direzione, e il mandato dice giustamente di non farla pesare.**

---

## 3. 📋 SCHEDA PROP — Key to Prop

```
PROP            KEY TO PROP  (Key to Markets International Limited, Mauritius)
URL REGOLE      keytoprop.com/trading-rules/
                keytoprop.com/faq/
                keytoprop.com/how-it-works/
                keytoprop.com/challenges-overview
                keytoprop.com/scaling/
                keytoprop.com/terms
LETTA IL        27/08/2026    [LETTO-VIA-SEARCH — WebFetch e curl NULLI]
SEGNALATA DA    amico di Claudio che lavora per BCM (dichiarato, NON un criterio)
```

| voce | valore | etichetta |
|---|---|---|
| **struttura** | **2 fasi** (challenge "standard"); esiste una linea **VIP a 1 fase**; citata anche una linea **"Lite"** | 🟡 search 27/08 (pagina partner, §5) |
| **durata** | 🔴 **180 giorni** sulla standard a 2 fasi · **illimitata** sulla VIP 1-fase | 🟠 **fonte terza** (partner ZenFX) |
| 🧱 **MURO GIORNALIERO** | _"Daily Drawdown is a daily loss limit calculated **from your initial balance**"_ · _"calcolato sull'**initial balance di ogni stage**"_ | 🟡 search 27/08 |
| — **quanti %?** | 🔴 **NON DICHIARATO** — il canale non ha mai restituito la cifra | 🔴 **BUCO** |
| 🧱 **MURO TOTALE** | 🔴🔴 _"Max Drawdown is an overall loss threshold calculated based on your **highest equity peak** and **resets dynamically**"_ = **TRAILING SUL PICCO DI EQUITY** | 🟡 search 27/08 |
| — **quanti %?** | 🔴 **NON DICHIARATO dalla prop**. Una rassegna terza (investfox) scrive _"il massimo drawdown del **9%** e' leggermente sotto il 10%"_ → 🟠 **terza parte, non confermata** | 🔴 **BUCO** |
| — si blocca mai? | 🔴 **NON DICHIARATO** se il trailing si ferma al breakeven / al balance iniziale una volta accumulato profitto. **E' la voce che decide tutto** (§6) | 🔴 **BUCO CRITICO** |
| 🔴 **STOP LOSS** | **OBBLIGATORIO**: _"Stop loss is mandatory and applicable for **ALL positions at all times**"_ | 🟡 search 27/08 |
| 🔴 **cap per operazione** | vietato rischiare **≥ 50% dei limiti di drawdown** in **una singola operazione O su piu' operazioni sullo STESSO STRUMENTO**; vietato rischiare **≥ 100%** dei limiti in trade aperti | 🟡 search 27/08 |
| 🔴 **DURATA MINIMA** | **1 minuto**. Se SL/TP chiude sotto il minuto **non e' breach automatico**, _"ma se diventa una strategia consistente si puo' incorrere in violazioni"_ | 🟡 search 27/08 |
| 🔴 **CONSISTENZA** | c'e', ed e' **discrezionale, non numerica**: _"consistenza di strategia, niente deviazioni sostanziali in **dimensione delle posizioni, strumenti, frequenza/quantita' di trade** rispetto ai propri schemi abituali"_ + _"si attendono **lotti costanti**"_ | 🟡 search 27/08 |
| — c'e' una % di consistency? | 🔴 **NON DICHIARATA** (nessun "40%", nessun "best day rule") | 🔴 buco |
| **EA / MT5** | 🟢 **permessi**: _"Use of EAs is permitted, provided they comply with General Trading and Risk Management Rules"_ | 🟡 search 27/08 |
| — EA di terzi | 🟠 **[INCERTO]** — la lettura restituisce due frasi che si mordono: _"using any other third-party EA is **not allowed**"_ e _"using a third-party EA **is allowed as long as it is a trade or risk manager**"_. **Per noi e' probabilmente irrilevante (sorgenti nostri), ma va chiarito** | 🔴 [INCERTO] |
| — copy trading | EA di copy **permessi**, ma **vietato** copiare trade di altri trader **dentro la stessa firm** e **vietati i segnali MQL5** | 🟡 search 27/08 |
| 🔴 **PRATICHE VIETATE** | _"trading che sfrutta le inefficienze della piattaforma: **gap trading**, high frequency trading, server spamming, latency arbitrage, **tick scalping**"_ + protocolli **API .Net / FIX-API / ITCH** vietati | 🟡 search 27/08 |
| **NEWS TRADING** | 🔴 **NON DICHIARATO** — nessuna delle letture di oggi ha trovato una regola news, ne' in un senso ne' nell'altro | 🔴 **BUCO ELIMINATORIO** |
| **OVERNIGHT / WEEKEND** | 🔴 **NON DICHIARATO** | 🔴 **BUCO ELIMINATORIO** |
| **LEVA per strumento** | 🔴 **NON DICHIARATA** (ne' forex, ne' indici, ne' oro) | 🔴 **BUCO** |
| **RESET del muro giornaliero** | 🔴 **NON DICHIARATO** (ora e fuso) | 🔴 **BUCO** |
| **fuso server** | 🔴 **NON DICHIARATO** | 🔴 buco |
| **TAGLIE** | 🟠 **fonti in conflitto**: home/about parlano di _"funded fino a **$250.000**"_ e _"fino a **$500k** in taglie simulate"_; una rassegna terza dice **10k / 25k / 100k** con scaling a 250k; la pagina Scaling parla di **$300k** | 🔴 **[INCERTO]** |
| **PREZZI** | 🟠 _"da **$125** per la 10k 1-step"_ (terza parte, investfox); il partner ZenFX listina una **VIP Gold a $850** (scontata $552,50 con coupon) | 🟠 terza parte |
| **SPLIT** | **70% base**, fino a **85-90%** salendo con lo scaling | 🟡 search + terza parte |
| **PAYOUT** | 🟢 **settimanali**. Richiesta lavorata **fino a 3 giorni lavorativi**, poi **5-7 giorni lavorativi** perche' i fondi arrivino | 🟡 search 27/08 |
| — 🔴 **CAP di payout?** | 🔴 **NON DICHIARATO** (nessun tetto tipo $3k trovato — **ma nemmeno una smentita**) | 🔴 buco |
| — primo payout / minimo | 🔴 **NON DICHIARATI** | 🔴 buco |
| **SCALING** | **ogni 4 mesi** di trading profittevole si sale, verso **$300k** e **split 90%**; _"un payout per stage funded, l'account avanza in automatico dopo il payout"_ | 🟡 search 27/08 |
| **REFUND della fee** | pagina `refund-policy` esiste; 🔴 **contenuto NON LETTO** | 🔴 buco |

---

## 4. 🩸 COSA CI MORDE — punto per punto, col numero di casa accanto

### 🔴 1. IL MURO TOTALE E' **TRAILING SUL PICCO DI EQUITY**. Da solo basta.

`ANALISI_DD_TOTALE_2026-08-26.md` §4, parola per parola:
_"Un muro totale TRAILING del 6% si romperebbe PERSINO sui chiusi (picco-valle
6,37% > 6%): **Muri statici o niente.**"_

E qui non e' nemmeno solo la percentuale:
- **tutto il nostro impianto probabilistico e' calcolato su DD STATICO**
  (Monte Carlo p99 = 8,1% statico; pass-rate 99,6% su muri 5/10 **statici**).
  Con un trailing su picco di equity **quei numeri non valgono piu': andrebbero
  RICALCOLATI DA ZERO**, ed e' un lavoro, non una postilla.
- il trailing e' **su EQUITY**, non su balance: significa che **il flottante
  che vinciamo e poi restituiamo alza il muro e non lo riabbassa**. La nostra
  misura −6,37% e' **sui chiusi** — `ANALISI_DD_TOTALE` avverte (b) che le
  chiusure giornaliere sono un **limite inferiore**. Su un trailing di equity
  il numero vero e' **peggiore di 6,37%, di quanto non lo sappiamo**.
- se il 9% di terza parte fosse confermato: **9% trailing su picco di equity**
  contro una p99 di **8,1% calcolata su statico**. 🔴 Il margine e'
  **negativo appena si passa da statico a trailing**.

### 🔴 2. STOP LOSS OBBLIGATORIO SU **TUTTE** LE POSIZIONI, SEMPRE

Non e' una raccomandazione: e' scritta come regola. 🔴 **In casa non esiste un
censimento che dimostri che tutte e 35 le sedie piazzano un SL hard su ogni
posizione** — abbiamo sedie con uscite a tempo, uscite a sessione e trailing.
**E' una misura di casa che manca**, ed e' esattamente lo stesso genere di buco
del debito `open_time` (M2). Prima di pagare qui, va fatto il censimento.

### 🔴 3. IL CAP DEL 50% "SULLO STESSO STRUMENTO" — e noi impiliamo sedie sullo stesso simbolo

Vietato rischiare **≥ 50% dei limiti di drawdown** _"in una singola operazione
**o su piu' operazioni sullo stesso strumento**"_.

Aritmetica di casa `[INFERITO]`, con le due letture possibili del "limite":

| se "drawdown limit" = | 50% di quel limite | quante nostre sedie da 0,65% ci stanno |
|---|---:|---|
| **daily** (ipotesi 5% su 100k = $5.000) | **$2.500 = 2,50%** | 🔴 **3 sedie sullo stesso simbolo** (1,95%) passano, **4 no** (2,60%) |
| **totale** (ipotesi 10% = $10.000) | **$5.000 = 5,00%** | 🟢 fino a 7 sedie |

🔴 **La regola non dice quale dei due limiti sia il riferimento.** Con piu' EA
DAX o piu' EA oro che aprono insieme — e il precedente di casa esiste
(29/07: **due EA, stesso segnale, stesso secondo**, `CENSIMENTO_ORDINI_PC.md`
§3) — **la lettura restrittiva ci morde**. E' lo stesso meccanismo per cui
FundingPips e' stata bocciata (il cap "per idea" all'1,2%).

### 🔴 4. **GAP TRADING** ESPLICITAMENTE FRA LE PRATICHE VIETATE

Terza prop su undici che lo scrive (FTMO nelle Forbidden Practices, Goat con la
finestra 3h venerdi'/lunedi', ora Key to Prop). 🔴 **La famiglia GapFill e' il
cluster che ha prodotto il nostro peggior giorno** (25/05/26, `ANALISI_DIAL`
Tab.1). Qui pero' e' peggio che su FTMO: **la clausola non ha finestra oraria e
non ha definizione** — e' messa nel calderone _"sfruttare le inefficienze della
piattaforma"_, cioe' e' **puramente discrezionale**.

### 🔴 5. LA CONSISTENZA DISCREZIONALE — la clausola piu' pericolosa per una FLOTTA

_"niente deviazioni sostanziali in **dimensione delle posizioni**, **strumenti**,
**frequenza/quantita' di trade**"_ + _"si attendono **lotti costanti**"_.

🔴 **Una flotta di 35 sedie su indici + oro + forex, con lotti diversi per
sedia (dial per famiglia) e frequenze diversissime, VIOLA questa descrizione
per COSTRUZIONE.** Non c'e' una soglia numerica da rispettare: c'e' un giudizio
umano su "sei stato coerente?". Le prop bocciate il 27/08 mattina lo insegnano:
**le clausole discrezionali si scoprono al payout, non prima.**

### 🟠 6. LA DURATA MINIMA DI 1 MINUTO — meno stretta di Alpha (2 min), ma NON MISURABILE

`ExportTrades()` **non esporta `open_time`** (debito M2, `PIANO_PROP.md` /
`METRO_PROP` §13.2). 🔴 **Oggi non possiamo dimostrare la conformita'.** Il
mitigante c'e' (SL/TP sotto il minuto non e' breach automatico) ma la coda
_"se diventa una strategia consistente"_ e' di nuovo discrezionale, e gli EA
di apertura (ingresso alle 08:00 server in punto) possono chiudere in secondi.

### 🔴 7. TRE VOCI ELIMINATORIE **NON DICHIARATE**: news, weekend/overnight, leva

Non e' "informazione mancante": sono **le tre voci su cui e' stata bocciata
meta' del dossier del 26/08**. Una flotta **senza filtro news** che **tiene
overnight e nel weekend** non puo' comprare una challenge dove queste due
regole **non si leggono da nessuna parte**. E la leva indici decide se il
margine morde (1:15) o respira (1:25).

### 🟠 8. 180 GIORNI DI DURATA sulla challenge standard

Se confermato (fonte terza), non ci morde: il pass-rate simulato ha
**mediana 12 giorni**. Lo scrivo solo perche' e' un vincolo che FTMO e
FundingPips **non hanno** (tempo illimitato).

---

## 5. ⭐ REPUTAZIONE — quello che ho potuto vedere, e quello che no

| voce | valore | etichetta |
|---|---|---|
| **Trustpilot — voto** | **4,8 / 5** | 🟡 search 27/08 |
| **Trustpilot — numero recensioni** | **89** | 🟡 search 27/08 |
| **risposte dell'azienda** | risponde al **100% delle recensioni negative**, tipicamente **entro 2 settimane** | 🟡 search 27/08 |
| 🔴 **CARTELLO "violazione linee guida / recensioni false"** | **NON EMERSO in nessuna delle interrogazioni** (ne' cercandolo per nome) — 🔴 **ma NON POSSO CONFERMARE L'ASSENZA**: il banner e' un elemento grafico della pagina Trustpilot, e **WebFetch e' bloccato**. Il canale search non lo restituisce ne' in positivo ne' in negativo | 🔴 **[INCERTO] — verifica visiva di Claudio** |
| 🟠 **CHI scrive le recensioni** | 🔴 **le recensioni positive che il canale mi ha restituito sono in prevalenza di AFFILIATI**, non di trader funded: _"promuovo KeyToProp da qualche mese"_, _"il portale **affiliati** e' semplice, trasparente… compensi flessibili ed equi"_. Una sola parla di aver fatto la challenge | 🟡 search 27/08 |
| 🔴 **Prop Firm Match** | **UNLISTED**: _"non recensita ne' verificata"_; sta sotto `/unlisted-prop-firms/`, **non ha superato la loro due diligence**, e' li' perche' la community l'ha proposta e vota per farla valutare | 🟡 search 27/08 |
| **rassegne terze** | esistono schede su **investfox** e **fxverify** — 🟠 la scheda fxverify non ha restituito contenuto | 🟠 parziale |
| **forum (ForexFactory / Reddit)** | 🔴 **NESSUNA discussione trovata**. Non e' una bandiera rossa: e' **assenza di traccia indipendente** | 🔴 buco |
| **eta' del dominio** | 🔴 **NON DETERMINABILE** (§2.1) | 🔴 buco |
| **canale di marketing** | 🟠 forte presenza **affiliati/partner in Italia** (partner ZenFX con coupon a sconto 15/20/35%, video YouTube _"la prop-firm italiana che rivoluziona il trading"_) | 🟡 search 27/08 |

> 🎯 **La lettura onesta della reputazione:** **4,8 su 89 recensioni non e' un
> brutto voto — e' un voto GIOVANE e a base stretta**, per giunta con una quota
> visibile di recensioni scritte da chi **guadagna una commissione** a mandarci
> gente. Nessun segnale negativo trovato (nessun caso di payout negato, nessun
> thread di lamentele). **Ma nemmeno un solo segnale POSITIVO indipendente e
> verificabile** (Prop Firm Match la tiene esplicitamente fuori dai verificati).
> **Non e' una prop con cattiva fama: e' una prop senza storia.**

---

## 6. ⚖️ VERDETTO CONTRO IL METRO DI CASA

### La tabella che decide

| requisito del metro di casa | Key to Prop | esito |
|---|---|---|
| 🧱 **muro TOTALE statico** | 🔴 **TRAILING sul picco di EQUITY, "resets dynamically"** | ❌ **FALLITO** |
| 🧱 muro totale **≥ 10%** | 🔴 **NON DICHIARATO** (terza parte: 9%) | ❌ non verificabile / probabilmente sotto |
| 🧱 muro **giornaliero 5%** | 🟢 base giusta (**initial balance**, non equity) ma la **% e' NON DICHIARATA** | ⚠️ **incompleto** |
| 🟢 **EA su MT5 ammessi esplicitamente** | 🟢 **SI** — _"Use of EAs is permitted"_, MT4 e MT5 | ✅ **PASSATO** |
| 📰 **news trading libero** (non abbiamo filtro) | 🔴 **NON DICHIARATO** | ❌ **buco eliminatorio** |
| 🌙 **overnight + weekend liberi** | 🔴 **NON DICHIARATO** | ❌ **buco eliminatorio** |
| ⏱️ **durata minima compatibile** (4+ min) | 🟠 **1 minuto** — compatibile sulla carta, **non dimostrabile** (debito `open_time`) | ⚠️ |
| ⚖️ **due lati / mono-direzione** | 🟢 nessuna clausola "one-sided bets" trovata (a differenza di FTMO e The5ers) | ✅ **PASSATO** |
| 📐 **niente consistency che ci congela** | 🔴 consistency **discrezionale su lotti, strumenti e frequenza** = su misura contro una flotta | ❌ **FALLITO** |
| 📈 **leva indici 1:25 o meglio** | 🔴 **NON DICHIARATA** | ❌ non verificabile |
| 💸 **niente cap payout $3k/ciclo** | 🟡 **nessun cap trovato**, ma nemmeno smentito · 🟢 **payout SETTIMANALI** = il piu' frequente del censimento | ⚠️ **promettente ma non confermato** |
| 🛡️ SL obbligatorio su ogni posizione | 🔴 requisito **che non sappiamo se la flotta soddisfa** | ⚠️ **misura di casa mancante** |
| 🏦 broker vero dietro | 🟢 **Key to Markets, dal 2010, gruppo UK/FCA + FSC Mauritius** | ✅ **PASSATO — e' il suo punto piu' forte** |
| 📊 taglie e scaling | 🟠 fonti in conflitto (250k / 300k / 500k), scaling **ogni 4 mesi**, split 70→90% | ⚠️ |

**Punteggio secco: 4 requisiti passati · 3 falliti · 7 non verificabili o incompleti.**

---

### 🔴🔴 VERDETTO: **BOCCIATA** (per la prima challenge di Claudio)

> **Non e' bocciata perche' e' piccola, e non e' bocciata perche' l'ha
> segnalata un amico. E' bocciata su UNA riga scritta sul loro sito:**
>
> > _"Max Drawdown is an overall loss threshold calculated based on your
> > **highest equity peak** and **resets dynamically**."_
>
> Il metro di casa, firmato il 26/08 dopo aver bocciato Upcomers ed E8 sulla
> stessa identica voce, dice: **"Muri statici o niente"**. Il nostro picco-valle
> misurato e' **6,37% sui soli chiusi**, e la nostra p99 di **8,1% e' calcolata
> su drawdown STATICO**: con un trailing su equity **non abbiamo piu' un solo
> numero valido** — andrebbe rifatta tutta la Monte Carlo prima di poter anche
> solo discutere il prezzo. **Comprare qui oggi significherebbe comprare al
> buio con soldi veri.**
>
> E il trailing non e' nemmeno l'unica: si aggiungono **la consistency
> discrezionale sui lotti/strumenti/frequenza** (che una flotta di 35 sedie
> viola per costruzione), **il gap trading vietato senza definizione**, **lo SL
> obbligatorio su ogni posizione** (requisito che **non sappiamo** se la flotta
> soddisfa) e **tre voci eliminatorie mai dichiarate**: news, weekend/overnight,
> leva.

### 🚪 PORTA DI RIENTRO — a **RISERVA**, e solo con risposte scritte

Key to Prop rientrerebbe come **RISERVA** (mai come candidata #1, non prima di
avere una storia) **solo se il supporto conferma PER ISCRITTO tutte e cinque**:

1. il **Max Drawdown si BLOCCA** (al balance iniziale o al breakeven) una volta
   accumulato profitto, **oppure** esiste un programma con **totale STATICO ≥ 10%**;
2. il **daily e' 5%** (non 4%, non 3%);
3. **news trading libero** e **tenuta overnight/weekend permessa** in challenge e funded;
4. il cap del **50% "sullo stesso strumento" e' riferito al muro TOTALE**, non al giornaliero;
5. **nessun cap di payout** e leva indici **almeno 1:20**.

Se anche **una sola** delle cinque va storta → resta **BOCCIATA** e non si
riapre. La shortlist resta quella del 26-27/08: **FTMO, FundedNext, Alpha**.

> ⚠️ **Nota di metodo, importante:** questo verdetto e' costruito su un canale
> che **non mi ha fatto vedere le percentuali dei muri**. Se Claudio apre
> `keytoprop.com/trading-rules/` e `/challenges-overview` **col suo browser** e
> trova numeri diversi da quanto qui dichiarato NON DICHIARATO, **il verdetto va
> rifatto**. L'unica riga che NON cambia col browser e' quella sul **trailing su
> picco di equity**, che e' testo loro, letto, ed e' gia' sufficiente a bocciare.

---

## 7. ✉️ LE 5 DOMANDE DA MANDARE AL SUPPORTO — **solo se Claudio vuole tenere la porta aperta**

Stesso formato delle quattro mail gia' inviate (FTMO, FundedNext, Alpha,
The5ers). Regola D3: **risposta scritta prima di ogni euro.**

```
Oggetto: Pre-purchase rule clarifications — algorithmic multi-EA portfolio (MT5)

Hello,

I run a portfolio of ~35 self-developed Expert Advisors on MT5 (own source
code, no martingale, no grid, no HFT, no third-party signals, no copy
trading). Before purchasing an evaluation I need five points in writing.

Q1 — MAX DRAWDOWN. Your Trading Rules state the Max Drawdown is "calculated
based on your highest equity peak and resets dynamically". (a) What is the
exact percentage, per program? (b) Does the trailing STOP at any point —
e.g. does it lock at the initial balance, or at breakeven, once a certain
profit is reached? (c) Is it computed on EQUITY (including floating P/L) or
on closed BALANCE? (d) Do you offer ANY program with a STATIC maximum
drawdown of 10% measured from the initial balance?

Q2 — DAILY DRAWDOWN. What is the exact percentage, and at what time and in
which server timezone does it reset? Is the reference the balance at reset
time, or the higher of balance and equity?

Q3 — NEWS, OVERNIGHT AND WEEKEND. Your public Trading Rules do not mention
them. (a) Is opening/closing/holding positions during high-impact news
allowed, in evaluation AND in funded? Is there a blackout window in minutes?
(b) Is holding positions overnight allowed? (c) Is holding positions over the
weekend allowed? Please answer separately for evaluation and funded.

Q4 — THE 50% RULE AND MULTIPLE EAs ON THE SAME SYMBOL. Your rules forbid
"risking 50% or more of drawdown limits in a single trade or across multiple
trades on the same instrument". (a) Is "drawdown limits" the DAILY limit or
the MAXIMUM limit? (b) I may have 3-4 independent EAs, each risking 0.65% of
the account, opening on the same symbol within the same session. Is that a
violation? (c) Same question for your consistency requirement ("consistent
lot sizes", "no substantial deviation in position sizes, instruments, trade
frequency"): a diversified multi-strategy portfolio produces, by design,
different lot sizes across instruments and very different trade frequencies.
Is that acceptable, and is there a NUMERIC threshold I can verify myself?

Q5 — GAP TRADING, STOP LOSS, LEVERAGE, PAYOUTS. (a) You list "gap trading"
among prohibited practices: what is the exact definition and time window?
Does holding a position through the weekend gap, or entering at the Monday
open, qualify? (b) The mandatory stop loss: must it be attached at order
submission, or is a stop loss set within X seconds/minutes acceptable?
(c) What is the leverage per asset class (FX, indices, gold), in evaluation
and in funded? (d) Is there any CAP on payout amount per cycle, a minimum
payout amount, and when is the first payout eligible? (e) Since when has Key
to Prop been operating, and is the challenge fee refunded on first payout?

Thank you — I will not purchase before receiving these answers in writing.
```

---

## 8. 🧾 COSA NON HO POTUTO VEDERE — l'elenco onesto

1. 🔴 **Le percentuali dei muri** (daily e totale). Il numero "9%" del totale e'
   di **terza parte** e non e' confermato.
2. 🔴 **Se e quando il trailing si blocca** — la voce che deciderebbe fra
   bocciatura definitiva e riserva.
3. 🔴 **Regola news · regola overnight · regola weekend** — mai comparse.
4. 🔴 **Leva per strumento**, **fuso server**, **ora di reset del giornaliero**.
5. 🔴 **Il banner Trustpilot** "violazione linee guida / recensioni false":
   **non emerso, ma non escludibile** — WebFetch e' bloccato, serve l'occhio
   di Claudio su `trustpilot.com/review/keytoprop.com`.
6. 🔴 **L'eta' del dominio** (WHOIS non interrogabile da qui).
7. 🔴 **Il contenuto di `refund-policy`** e la **tabella prezzi/taglie ufficiale**.
8. 🔴 **Qualunque traccia su ForexFactory o Reddit**: zero.
9. 🟠 **Due misure DI CASA che mancano**, e che qui servirebbero **prima** di
   pagare: (a) tutte le 35 sedie piazzano davvero uno **SL hard** su ogni
   posizione? (b) il debito **`open_time`** in `ExportTrades()`, che impedisce
   di dimostrare la durata minima — **lo stesso debito che blocca anche Alpha**.

---

## 9. 📎 URL usati (tutti [LETTO-VIA-SEARCH 27/08/2026], nessuno aperto direttamente)

**Ufficiali Key to Prop:** `keytoprop.com/` · `/about-us/` · `/how-it-works/` ·
`/trading-rules/` · `/faq/` · `/challenges-overview` · `/scaling/` ·
`/refund-policy/` · `/terms` · `/privacy` · `my.keytoprop.com/registration` ·
`portal.keytoprop.com/portal/` · `lp.keytoprop.com/`

**Societarie/broker:** `keytomarkets.com/about/` · `globalfinreg.com` (LEI
254900OLSDNUH52WP943) · `bcm-markets.com/en/` · `forexbrokerz.com/brokers/bcm-markets`

**Reputazione:** `trustpilot.com/review/keytoprop.com` (+ mirror au/ca) ·
`propfirmmatch.com/unlisted-prop-firms/key-to-prop` ·
`investfox.com/education/other/key-to-prop-forex-prop-firm-review/` ·
`fxverify.com/prop-firms/keytoprop-review-4518`

**Partner/affiliati:** `zenfxofficial.com/key-to-prop/` ·
`zenfxofficial.com/en/key-to-prop-en/`
