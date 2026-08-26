# 🔎 DOSSIER PROP — **UPCOMERS** (upcomers.com)

_Richiesta di Claudio, 26/08/2026: pubblicita' Instagram — "Fase unica.
Obiettivo 5%. 90% di sconto su tutte le taglie, conti fino a 1,5M: 100k a
97,90 EUR, 1M a 655,70". Domande: **com'e' questa prop? che impostazioni ha?
accetta EA?**_

> ⚠️ **Non e' la prima volta che Upcomers passa da qui.** `report/METRO_PROP.md`
> la cita gia' due volte (15/08): _"Su Upcomers la pubblicita' diceva target 5%
> e le recensioni 8-10%"_ e _"vendeva un 100k a $115,90 invece di $1.159"_.
> Questo dossier e' il primo che ne legge le **regole**.

---

## 0. 🎯 CONTROLLO POSITIVO E STATO DELLE FONTI — **leggere prima di tutto**

**Il controllo positivo e' stato eseguito su due canali distinti**, con
bersaglio a risposta nota (pagina obiettivi FTMO: deve dare 10% totale / 5%
giornaliero / reset a mezzanotte CE(S)T).

| canale | bersaglio di controllo | esito | uso |
|---|---|---|---|
| `curl` diretto | `ftmo.com` · `upcomers.com` | ❌ **`CONNECT tunnel failed, response 403`** | 🛑 **NULLO** |
| **WebFetch** | `ftmo.com` · `upcomers.com` · `help.upcomers.com` · `forexpeacearmy.com` · `propfirmmatch.com` | ❌ **`EGRESS_BLOCKED`** su tutti | 🛑 **NULLO** |
| **WebSearch** | FTMO trading objectives | ✅ **restituisce 5% / 10% / reset midnight CE(S)T** = risposta nota **centrata** | 🟢 **UNICO CANALE VIVO** |

Registrato al proxy, non ipotizzato:
```
"kind": "connect_rejected",
"detail": "gateway answered 403 to CONNECT (policy denial or upstream failure)",
"host": "upcomers.com:443"
```
Bloccati anche `www.upcomers.com`, `help.upcomers.com`, `app.upcomers.com`,
`web.archive.org` (CDX), `r.jina.ai`.

### 🏷️ L'ETICHETTA CHE VALE PER TUTTO QUESTO DOSSIER

> 🟡 **`[LETTO-VIA-SEARCH 26/08/2026]`** — stessa convenzione gia' usata in
> `CONFIG_PROP_2026-08-18.md` §2A-2G. **Non ho aperto con i miei occhi una sola
> pagina di upcomers.com.** Il contenuto sotto arriva dal canale di ricerca, che
> **ha letto e riassunto le pagine ufficiali** `help.upcomers.com/...`.
>
> **Cosa significa in pratica:** la SOSTANZA delle regole e' affidabile (viene
> dall'help center ufficiale, non da recensioni), ma **non ho la citazione
> letterale** e **non posso escludere che il riassunto abbia arrotondato**.
> **Nessuna riga di questo dossier autorizza un acquisto**: vale la **regola
> D3** — conferma scritta del supporto prima di qualunque euro.

🔴 **E una prova che l'etichetta serve davvero:** il primo giro di ricerca, su
un sito di recensioni, mi ha restituito _"Expert Advisors, trading bots, copy
trading, and high-frequency systems are prohibited at every stage"_. **E'
FALSO** — le pagine ufficiali dicono l'opposto (§2). Se mi fossi fermato al
primo risultato avrei risposto "no, non accetta EA" a Claudio. **Il sito di
recensioni era invecchiato di due mesi rispetto alla regola vera.**

---

## 1. 🧾 LA SCHEDA PROP — "THUNDERBOLT", la fase unica dell'annuncio

Il prodotto della pubblicita' di Claudio (fase unica + target 5%) si chiama
**Thunderbolt**. Upcomers ne ha altri quattro (Ascended 2 fasi, Astral 3 fasi,
Eon 5 fasi, Vanguard/Ember instant funding): **qui si censisce solo Thunderbolt.**

```
PROP            Upcomers — programma THUNDERBOLT (1 fase)
URL REGOLE      help.upcomers.com/en/articles/12983894-thunderbolt-challenge-complete-rules-overview
LETTA IL        26/08/2026  [LETTO-VIA-SEARCH — dominio egress-blocked]
```

| voce | valore | fonte (URL) |
|---|---|---|
| **Fasi** | **1** ("one phase, one target") | help/12983894 |
| **Target** | **5%** dell'equity iniziale, tutte le posizioni chiuse | help/12983894 |
| 🧱 **MURO GIORNALIERO** | 🔴 **3%** — su 100k = **$3.000** | help/12983894 |
| — come si calcola | a inizio giornata registra **equity O balance, il PIU' ALTO dei due**; il limite e' il 3% di quel valore | help/12639478 · help/8496661 |
| — 🕐 **quando resetta** | **00:00 UTC**, giornata **00:00 → 23:59:59 UTC** | help/12749721 · help/15729222 |
| 🧱 **MURO TOTALE** | 🔴 **6% — TRAILING**, "Dynamic Risk Shield™" | help/12639372 |
| — come traila | segue la **massima equity mai toccata** (High Water Mark), il muro sta **sempre 6% sotto il picco**; **sale e non scende mai** | help/12639372 |
| — 🔴 include il flottante? | **SI'** — _"calculated on equity, not balance, and open trades count"_. Esempio ufficiale: equity a 103.000 **da profitti aperti** → muro sale a **96.820** | help/12639372 |
| — 🟢 **il trailing si BLOCCA?** | **SI'** — quando il **balance** raggiunge **+6%** (106.000 su 100k) lo scudo **si blocca in permanenza sul balance iniziale** (100.000) e smette di trailare | help/12639372 |
| — prelievi | ritirare profitti **NON** riabbassa lo scudo | help/12639372 |
| **Tempo** | **illimitato** | help/12983894 |
| **Giorni minimi** | **nessuno** | help/12983894 |
| **Leva** | **1:100** | help/12983894 |
| **Profit split** | **99%** (Upcomers tiene 1%) | help/12983894 |
| **EA AMMESSI** | 🟢 **SI'** — vedi §2 | help/11704867 |
| **COPY TRADING** | ⛔ **VIETATO** (anche signal service e gestione conti) | help/12640343 · help/8703143 |
| **OVERNIGHT** | 🟢 **AMMESSO** | help/8496693 |
| **WEEKEND** | 🟢 **AMMESSO**, anche sui funded | help/8496907 |
| **CONSISTENZA** | 🟡 **"Best Day Rule" 15% o 20%** (dipende dal conto) — vedi §3 | help/12657611 |
| **NEWS TRADING** | ❓ **[INCERTO]** — nessuna regola news specifica trovata | — |
| **PIATTAFORME** | 🟢 **MT5**, cTrader, TradeLocker, Match-Trader, Bybit | upcomers.com/platforms |
| **STRUMENTI** | 1.300+ (forex, indici, commodities, metalli, crypto, azioni), _"zero symbol restrictions"_ | help/8496680 |
| **TAGLIE** | da $5.000 a **$1.500.000** (cap totale 1,5M su tutti i programmi sommati) | upcomers.com/plans |
| **PREZZO** | da **$99,90** per il 100k Thunderbolt; sconto **90%** codice `SPRING90` | upcomers.com/plans · help/15095378 |

### 🕐 IL RESET IN ORA SERVER BCM — il numero che serve alle configurazioni

**Regola di casa: BCM = ora italiana − 1.** In agosto l'Italia e' CEST = UTC+2,
quindi **BCM = UTC+1**.

| | ora dichiarata | in UTC | 🕐 **in ORA SERVER BCM** |
|---|---|---|---|
| reset giornaliero Upcomers (estate) | 00:00 UTC | 00:00 | **01:00** |
| reset giornaliero Upcomers (inverno, IT=CET=UTC+1 → BCM=UTC+0) | 00:00 UTC | 00:00 | **00:00** |

> ⚠️ **Il reset SI SPOSTA con l'ora legale.** Un `InpDailyResetHour` fisso
> sbaglia di un'ora per meta' anno. Per confronto: FTMO resetta alle **23:00
> BCM** (gia' agli atti, B3 congelata 18/08) — **Upcomers e' un'ora piu' tardi
> d'estate e due d'inverno rispetto a FTMO.** Non e' un dettaglio: decide in
> quale "giorno prop" cade una perdita notturna, e **tre EA di casa lavorano
> proprio di notte** (`MaxMinNotte` 23:00-04:59, `Nightly` 22:00-04:59, variante
> oro 22:00-06:00).

---

## 2. 🤖 LA RISPOSTA ALLA DOMANDA DIRETTA DI CLAUDIO — **"accetta EA?"**

# 🟢 SI'. Gli EA sono AMMESSI, ed e' una regola RECENTE e DICHIARATA.

| fatto | fonte |
|---|---|
| _"Expert Advisors (EAs), trading bots, algorithms and automated trading tools **are allowed** at Upcomers, as long as they follow trading rules and represent a **real, unique and responsible** trading strategy"_ | help/11704867 |
| **Data di entrata in vigore: 26 maggio 2026** — _"participants in all Upcomers programs can use Expert Advisors, trade managers, risk management utilities, and other automation tools in their simulated trading"_ | comunicato stampa GlobeNewswire, **24/06/2026** |
| Supporto EA esteso a **tutte e cinque** le piattaforme (MT5 compreso) | TradeInformer, 06/2026 |
| Strumenti esplicitamente ammessi: **custom EA, bot personali, risk manager, calcolatori di lotto, gestori SL/TP, esecuzione semi-automatica** | help/11704867 |

> ✅ **Questo copre esattamente la nostra flotta**: EA scritti da noi, non
> distribuiti, con SL/TP gestiti dall'EA e sizing percentuale. E copre anche
> **il Guardian**, che ricade in pieno in _"risk management utilities"_.

### ⛔ MA la lista dei VIETATI tocca tre punti della flotta

| pratica vietata | testo/definizione | 🎯 **ci tocca?** |
|---|---|---|
| 🔴 **TICK SCALPING** | _"trades must be held for a **minimum of 2 minutes**; any trade closed in under 2 minutes is classified as tick scalping"_ (help/12640252) | 🔴 **SI', ed e' il rischio piu' sottovalutato** — vedi §2-bis |
| 🔴 **COPY TRADING** | vietato anche fra **conti diversi**; _"if multiple traders using the same EA exhibit **identical trading parameters** and similar trades are detected, it will be regarded as copy trading"_ (help/11704867) | 🟠 **POTENZIALMENTE** — oggi la stessa flotta gira su **50503392** e **50504263** (`METRO_PROP` §5). Sono due conti NOSTRI, ma il testo parla di attivita' identica, non di proprieta' |
| ⛔ HFT | vietato | 🟢 no |
| ⛔ Arbitraggio (latenza, reverse, hedge) | _"engaging in **any variant** of arbitrage trading is explicitly forbidden"_ | 🟢 no |
| ⛔ Emulatori / sfruttamento data-feed | vietato | 🟢 no |
| ⛔ "Pass your challenge" / gestione conti terzi | vietato, **ban permanente** | 🟢 no |
| ⛔ Bot di passaggio challenge distribuiti in massa | vietato | 🟢 no (i nostri non sono distribuiti) |
| 🚩 **ONE-SIDED BETS** | _"consistently opening positions in **one direction** across multiple instruments"_ — restrittiva perche' _"reflects **gambling behavior** rather than professional trading"_ (help/12640311) | 🔴 **SI'** — vedi §2-bis |
| **News trading** | ❓ nessuna regola trovata | ❓ **[INCERTO]** — la flotta **non ha news filter**: da chiedere per iscritto |

### 2-bis. 🚨 I DUE CAVILLI CHE COLPISCONO PROPRIO NOI

#### 🔴 A. La regola dei **2 MINUTI** — e il fatto che **non possiamo misurarla**

Ogni trade chiuso in **meno di 2 minuti** e' classificato **tick scalping =
pratica vietata**. La flotta e' piena di motori d'apertura e di breakout con SL
stretto: `ABTG_DAX_Apertura_EU` entra **alle 08:00 server in punto**, alla
campanella, e uno stop preso nella prima raffica **puo' chiudersi in secondi**.

> 🕳️ **E qui inciampiamo su un debito che abbiamo gia' agli atti:**
> `ExportTrades()` **non esporta `open_time`** — lacuna registrata in **M2 di
> `PIANO_PROP.md`** e ripetuta in **`METRO_PROP` §13.2**.
>
> 🔴 **Conseguenza nuova, e seria: oggi NON possiamo calcolare la durata di un
> nostro trade.** Non sappiamo dire quanti dei nostri trade violerebbero la
> regola dei 2 minuti — ne' in backtest, ne' in forward. **Non e' una stima
> mancante: e' una misura impossibile con l'impianto attuale.**
> Il debito `open_time`, che finora era un fastidio da griglia, **diventa un
> requisito di conformita'.**

#### 🔴 B. **ONE-SIDED BETS** — la clausola discrezionale, ed e' quella che nega i payout

Le recensioni a 1 stella (§4) si concentrano **proprio qui**: payout negati per
_"one-sided betting"_ **quando il mercato era in trend**. Un trader riporta:
_"Upcomers ha contato i trade e ha pagato **275 USD dei 900 USD** spettanti,
classificandoli come one-sided bets, mentre altre prop lo chiamano **trend
following"_ `[dichiarato su Trustpilot, NON verificato]`.

> ⚖️ **Perche' morde noi in particolare:** la flotta ha sedie **mono-direzione
> dichiarate nel nome** — `ABTG_MaxMinNotte_DAX_Short_Ottimizzato`,
> `ABTG_MaxMinNotte_DAX_Short_Ottimizzato_MFE`. E' esattamente la forma che
> quella clausola descrive: _"consistently opening positions in one direction"_.
>
> 🎯 **Nota che si aggancia a una regola di casa:** la **REGOLA DEI DUE LATI**
> firmata da Claudio il **25/08** ("ogni analisi misura SEMPRE long E short")
> nasce per motivi di misura — ma **su Upcomers diventerebbe anche un requisito
> contrattuale**. E' l'unico punto in cui questa prop e le nostre regole
> spingono nella stessa direzione.

---

## 3. 💰 PAYOUT E FASE FUNDED

| voce | valore | fonte |
|---|---|---|
| **Split** | **99%** (Thunderbolt) — 80% base sui programmi valutativi, 60% instant | help/12983894 |
| **Primo prelievo** | dopo **7 o 14 giorni** secondo il programma | help/12688538 |
| **Minimo prelevabile** | **$45** di quota trader (dopo lo split) | help/12688538 |
| **Profitto minimo** | **>= 1% del balance iniziale** — su 100k = **$1.000** | help/12688538 |
| **Metodo** | Wise o crypto | help/12688538 |
| 🟡 **BEST DAY RULE** | nessun singolo giorno puo' valere piu' del **15% o 20%** (secondo il conto) del profitto **totale** al momento della richiesta. Formula: `(miglior giorno / profitto totale) × 100` | help/12657611 |
| — natura | **soft rule**: **ritarda** il payout, **non** brucia il conto | help/12657611 |
| — dopo il payout | il Best Day **si azzera** e riparte | help/12657611 |
| **Muri sul funded** | identici: **$3.000 daily su 100k**, Dynamic Risk Shield 6% | help/12983894 |
| **Cap capitale** | **$1.500.000** totali su tutti i conti/programmi sommati | upcomers.com/plans |
| **Payout dichiarati** | _"oltre $6M"_, poi _"oltre $8,5M verificati"_, _"99% approval rate"_, processing < 1h | 🔴 **dichiarato dal vendor, NON verificato** |

### 🧮 La Best Day Rule contro la forma della NOSTRA curva

`[INFERITO]` — aritmetica nostra su un fatto gia' misurato.

Il **15%** e' la soglia dura: per poter prelevare, il **miglior giorno** deve
valere **al massimo 1/6,7 del profitto totale**. Con target 5% su 100k = 5.000$
di profitto, **nessun giorno puo' aver fatto piu' di 750$ (0,75%)**.

> 🔴 **`METRO_PROP` §6 lo dice gia', ed e' il punto:** _"27 serie con code Monte
> Carlo vuol dire che **una giornata grossa e' statisticamente attesa**, non
> un'anomalia."_ Un portafoglio di 44 sedie che sparano lo stesso giorno
> **produce per costruzione** giornate fuori scala. **La Best Day Rule non ci
> squalifica — ci congela il primo prelievo**, potenzialmente a lungo.

---

## 4. 🚩 AFFIDABILITA' — chi c'e' dietro, e i segnali d'allarme

### Chi e'

| voce | valore | etichetta |
|---|---|---|
| **CEO / fondatore** | **Jakub Zeliska** | [LETTO-VIA-SEARCH] |
| **Entita' 1** | **Upcomers Ltd.** — **Saint Lucia**, reg. **2025-00579** | 🔴 offshore, **numero 2025** = registrata **quest'anno** |
| **Entita' 2** | **Royal Flow FZCO** — **EAU**, licenza **35886** ("technology and education company") | 🔴 **licenza "tecnologia ed educazione", NON finanziaria** |
| **Entita' 3** | **UPCOMERS LTD (Cipro)** — *payment agent* | — |
| **Eta'** | fonti discordi: **2023** oppure **fine 2024**; hub Dubai + Praga | 🟡 **[INCERTO]** — comunque **1-3 anni** |
| **Regolamentazione** | 🔴 **NESSUNA** trovata. Nessuna autorita' finanziaria dietro | [VERIFICATO come assenza] |

### 🚨 I SETTE SEGNALI D'ALLARME

**1. 🔴 Il contratto dice che possono NON pagare.** Dai Terms & Conditions
ufficiali: servizio _"fully aimed at purely **SIMULATED AND EDUCATIONAL**
TRADING OPERATIONS"_, fondi _"purely **virtual**"_, e soprattutto:

> _"users shall **not be entitled to any fees or profits** and neither to any
> other (simulated) financial gain generated by or otherwise resulting from the
> virtual trading."_

Il programma "Breakout" aggiunge che non e' _"an investment service, portfolio
management, asset management, **prop trading**, an offer of trading capital, or
a funding arrangement"_.

> ⚖️ **Risposta alla domanda di Claudio su "SOLO SIMULAZIONE, NESSUN CAPITALE
> REALE": il modello e' DEMO PURO con payout pagati dalle FEE.** Non c'e'
> A-book, non c'e' B-book su mercato reale: le operazioni _"are simulated and
> reflected **exclusively within internal systems**, with no real trading on
> real markets"_. **Il payout non e' una quota di un profitto: e' un premio
> discrezionale su una gara.** Ed e' **la stessa clausola** che
> `report/INDAGINE_PROP_INSTAGRAM.md` (12/08) ha usato per bocciare **Alpine
> Funded** e **Meridian Funded**: _"il disclaimer in piccolo E' il contratto
> vero"_ — **lezione 1 di quel file, scolpita, che si ripresenta identica.**

**2. 🔴 DELISTATA da PropFirmMatch.** Upcomers sta fra le **unlisted**.
PropFirmMatch dichiara di ricevere 100+ candidature l'anno e approvarne **meno
di 10**, e di raccomandare _"extra caution before funding an account"_ per le
delistate. **Il motivo specifico non e' pubblicato** — `[INCERTO]`, ma il
precedente noto (Funding Traders) fu **dinieghi di payout**.

**3. 🔴 Il pattern dei payout negati, ripetuto e coerente.** Su Trustpilot le
recensioni a 1 stella convergono su **tre motivazioni discrezionali**:
_one-sided betting_ · _tick scalping_ (trade sotto 2 minuti) · _position
stacking / impulsive trading_, e le revisioni arrivano **DOPO** il profitto.
Casi riportati `[dichiarati, NON verificati]`:
- conto **$200.000**, obiettivi raggiunti, **~$22.732** di profitto: periodo di
  trading **invalidato interamente** dopo la richiesta del primo payout da $2.000;
- profitto **$7.462,26** annullato (rif. conto 311816);
- **penale permanente del 50%** sui prelievi futuri;
- pagati **$275** su **$900** spettanti.

**4. 🟡 Due profili Trustpilot con due voti diversi.**

| profilo | voto | recensioni |
|---|---|---|
| `upcomers.com` | **4,1 / 5** | ~446 |
| `app.upcomers.com` | 🔴 **2,7 / 5 — "Poor"** | — |

> ⚠️ **E' il pattern esatto gia' schedato**: `INDAGINE_PROP_INSTAGRAM.md` ha
> bocciato **Meridian Funded** anche per _"due domini gemelli con due profili
> Trustpilot separati"_. Qui il dominio **dell'app** — quello che usa chi ha
> gia' pagato — vale **1,4 stelle in meno** di quello del marketing.

**5. 🟡 L'aritmetica dello sconto 90% permanente.** `[INFERITO]`
Un 100k a **$99,90** invece di ~$999. Non e' un'offerta lampo: e' listino
mascherato, e l'annuncio di Claudio la ripropone identica in EUR (**97,90**).
Il conto che ne esce: **con target 5% e un solo passo**, la percentuale di
challenge superate e' alta; ogni passata costa alla ditta **un payout** contro
**~100$ di fee**. **Perche' il modello stia in piedi, servono o moltissime
challenge fallite, o payout che non escono.** I muri di questa prop (§5) e le
clausole discrezionali (§2-bis) fanno il primo; le recensioni (punto 3)
descrivono il secondo. 🔴 **Le due cose sono coerenti fra loro, e questo e'
il segnale piu' serio del dossier.**

**6. 🟡 Nessuna regolamentazione + entita' Saint Lucia registrata nel 2025.**
La licenza EAU e' di _"technology and education"_. **Non esiste un'autorita' a
cui reclamare un payout.**

**7. 🟡 Le stesse tecniche di urgenza gia' schedate.** Sconto 90%, "conto
gratis in regalo", pubblicita' Instagram. `INDAGINE_PROP_INSTAGRAM.md` lezione
5: _"le ditte serie non ti inseguono su Instagram con l'urgenza."_

### ⚖️ Il confronto onesto — c'e' anche l'altra faccia

Non e' Meridian Funded. **Le entita' esistono e sono nominate**, l'help center
e' dettagliato e coerente, i payout **esistono** (recensioni positive con
accrediti in poche ore, $8,5M dichiarati), la policy EA e' stata **ampliata**
in modo pubblico e datato. **Il problema non e' che non paghino mai: e' che
pagano finche' non conviene smettere, e il contratto dice per iscritto che
possono.**

---

## 5. 📐 IL CONFRONTO COI NOSTRI NUMERI — dove si decide tutto

> **Il metro di casa** (`report/METRO_PROP.md`): muri **10% totale / 5%
> giornaliero**, rischio **0,65%**, Monte Carlo **p99 ~8,1%** su DD **STATICO**
> (27 serie), **peggior giornata misurata −2,06%** (R51).

### 🧱 I muri, uno accanto all'altro

| | il nostro metro | **FTMO** | 🔴 **UPCOMERS Thunderbolt** |
|---|---|---|---|
| **muro totale** | 10% statico | 10% **statico** | 🔴 **6% TRAILING su equity** |
| **muro giornaliero** | 5% | 5% | 🔴 **3%** |
| **reset giornaliero** | — | 23:00 BCM | **01:00 BCM** (estate) |
| **target** | — | 10% + 5% | 🟢 **5%, fase unica** |
| **giorni minimi** | — | 4 (storico) | 🟢 **0** |
| **tempo** | — | limitato | 🟢 **illimitato** |

### 🔴 DEAL-BREAKER 1 — il muro totale del 6% TRAILING

**La nostra p99 e' 8,1% su DD STATICO. Il muro di Upcomers e' 6% TRAILING.**

> 🚨 **Si legge cosi': la nostra coda al 99° percentile sfonda un muro del 6%
> ANCHE SE FOSSE STATICO — e questo muro statico non e'.** E `METRO_PROP` §1 e'
> esplicito sul fatto che _"per una curva che sale a scalini come la nostra"_ il
> trailing e' **sempre peggiore** dello statico.
>
> **Non e' "stretto": e' sotto la nostra distribuzione misurata.**

🟢 **L'unica attenuante reale, e va detta:** lo scudo **si blocca sul balance
iniziale** appena il balance tocca **+6%**. Quindi la fase pericolosa e' solo
il tratto **da 0% a +6%** — dopo, diventa un muro **statico al 100.000**, cioe'
**breakeven**. 🔴 **Ma il target e' 5%: la challenge finisce PRIMA che lo scudo
si blocchi.** Tutta la challenge si corre **con il muro che insegue**.

### 🔴 DEAL-BREAKER 2 — il muro giornaliero del 3%

`METRO_PROP` §2 aveva gia' scritto la sentenza **prima** di conoscere questa
prop:

> _"cap **3% o meno** → 🔴 il nostro peggior giorno misurato ne mangia i due terzi"_

**Peggior giornata misurata −2,06% contro un muro di 3% = 69% del muro
consumato da un giorno gia' successo.** A rischio 0,65%, 1R = 650$: il muro
giornaliero e' a **~4,6 R**, contro i 7,7 R di FTMO.

### 🚨 DEAL-BREAKER 3 — **IL GUARDIAN, COSI' COM'E', NON SCATTEREBBE MAI**

Questo e' il punto piu' concreto del dossier. Le soglie del Guardian sono
**congelate il 18/08** e tarate sui muri **5% / 10%**:

| soglia Guardian (oggi) | valore | 🧱 muro Upcomers | esito |
|---|---:|---:|---|
| `InpDailyPausePct` (pausa morbida B1) | **4,0%** | 3,0% | 🔴 **il conto e' gia' MORTO da 1,0 punti** |
| `InpDailyLossPct` (emergenza) | **4,9%** *(input 5,0, emergenza a 4,9)* | 3,0% | 🔴 **morto da 1,9 punti** |
| `InpTotalDDPct` (emergenza totale) | **9,9%** *(input 10,0)* | 6,0% | 🔴 **morto da 3,9 punti** |
| `InpDailyResetHour` | **23** (tarato FTMO) | 01:00 BCM | 🔴 **giorno prop sfasato di 2 ore** |
| `InpDDMode` | **0 = STATICO** | trailing | 🔴 **misura il muro sbagliato** |

> 🔴 **In una riga: su Upcomers il Guardian di casa e' un allarme antincendio
> tarato su una temperatura che la casa raggiunge solo dopo essere bruciata.**
> Ogni singola soglia sta **oltre** il muro che dovrebbe proteggere.

🟢 **La buona notizia, e non e' piccola: il Guardian sa gia' fare il trailing.**
`ABTG_Guardian.mq5:53` ha gia' `InpDDMode = 0=STATICO / 1=TRAILING (dal picco
equity)`, implementato a `:355` e `:367`:
```
double totalDD = (InpDDMode==1)? (gPeak-eq) : (gStart-eq);
```
**Non serve scrivere il meccanismo: serve tararlo.** Manca **una sola cosa**:
il **blocco dello scudo al breakeven** (Upcomers congela il muro a `gStart`
quando il balance tocca +6%; il nostro traila **per sempre**, quindi sarebbe
**piu' severo del necessario** dopo il +6% — conservativo, ma costa operativita').

### 📋 I PARAMETRI PER RIFARE R106 SU QUESTE REGOLE (non li calcolo io)

> ⚠️ **Mandato rispettato: NESSUNA simulazione fatta qui.** R106 e le Monte
> Carlo sono della sessione principale. Questa e' solo **la lista della spesa**.

| # | parametro | valore Upcomers | nota |
|---|---|---|---|
| 1 | **modo del DD totale** | 🔴 **TRAILING su picco EQUITY** (flottante incluso) | **e' il cambio che invalida tutte le MC esistenti** |
| 2 | **soglia DD totale** | **6,0%** | contro 10% delle MC attuali |
| 3 | **blocco del trailing** | a `balance >= +6%` lo scudo si ferma a `gStart` | va modellato: cambia la coda **dopo** il +6% |
| 4 | **soglia giornaliera** | **3,0%** | contro 5% |
| 5 | **base del giorno** | `max(equity, balance)` a inizio giornata | non il solo balance |
| 6 | **ora di reset** | **00:00 UTC = 01:00 BCM** (estate) / **00:00 BCM** (inverno) | ri-aggregare le serie giornaliere su QUESTA finestra |
| 7 | **giornaliero su EQUITY** | si', flottante incluso | `gWorstDayPct` lo fa gia' (`METRO_PROP` §13.4) |
| 8 | **target** | **5%** (non 8-10%) | ⬅️ **l'unica voce a nostro favore**: il traguardo e' vicino |
| 9 | **rischio per trade** | **da RICALCOLARE** | 0,65% da' p99 8,1% statico: **fuori**. `[INFERITO]` scalando lineare, per portare la p99 sotto ~5% servirebbe **~0,40%** — **e il trailing peggiora ancora**, quindi 0,40% e' un **tetto ottimistico, non una risposta** |
| 10 | **Best Day** | miglior giorno <= **15%** del profitto totale | metrica **nuova**, mai calcolata: serve la distribuzione del **max-day / profitto** |
| 11 | 🔴 **durata dei trade** | **>= 2 minuti** | **NON MISURABILE OGGI** — manca `open_time` in `ExportTrades()` (M2) |
| 12 | **nomi simboli** | broker Upcomers ignoto | `METRO_PROP` §11: DAX = `D30EUR` su BCM, `GER40` altrove. **Da rimappare** |
| 13 | **fuso del server prop** | ❓ **[INCERTO]** | tutti gli `InpSessionHour` sono in ora **BCM**: se il server prop ha offset diverso, **ogni EA opera all'ora sbagliata** |

---

## 6. 🕳️ COSA NON HO POTUTO VEDERE — dichiarato, non riempito

| # | buco | perche' |
|---|---|---|
| 1 | 🔴 **Nessuna pagina aperta con i miei occhi** | `upcomers.com`, `help.upcomers.com`, `app.upcomers.com` **egress-blocked**. Zero citazioni letterali |
| 2 | **Il testo integrale dei T&C** | idem — ho frammenti, non il documento |
| 3 | **La regola NEWS TRADING** | nessun articolo trovato. **Non scrivo "ammesso": scrivo che non lo so.** La flotta **non ha news filter** |
| 4 | **Il motivo del delisting PropFirmMatch** | non pubblicato |
| 5 | **Broker/server/fuso reale e nomi simboli** | mai dichiarati nelle fonti raggiunte |
| 6 | **Tipo di conto: HEDGING o NETTING?** | 🔴 **mai trovato.** Il nostro conto e' HEDGING e piu' EA aprono insieme sullo stesso simbolo: **su netting si fonderebbero** |
| 7 | **Best Day: 15% o 20% su QUALE conto?** | le fonti dicono "dipende dal conto" senza tabella |
| 8 | **Prezzi in EUR** | trovato **$99,90** per il 100k, l'annuncio dice **97,90 EUR**: coerenti, ma **non confermati** |
| 9 | **Verifica indipendente dei payout** | ForexPeaceArmy e PropFirmMatch **bloccati**. Ho solo Trustpilot via search |

---

## 7. ⚖️ LE TRE RISPOSTE SECCHE A CLAUDIO

### ❓ 1. Com'e' questa prop?

> 🟡 **Sulla carta e' generosa; sul contratto e' fragile; sui muri e' la piu'
> stretta che abbiamo mai censito.** Target 5% in fase unica, tempo illimitato,
> zero giorni minimi, split 99%, EA ammessi, overnight e weekend liberi: **la
> vetrina e' ottima**. Ma dietro c'e' un'entita' Saint Lucia registrata **nel
> 2025**, **nessun regolatore**, il **delisting da PropFirmMatch**, un T&C che
> dice per iscritto che _"users shall not be entitled to any fees or profits"_,
> e un blocco coerente di recensioni che raccontano **payout annullati con
> motivazioni discrezionali dopo il profitto**. 🔴 **E' esattamente la
> struttura che il nostro `INDAGINE_PROP_INSTAGRAM.md` del 12/08 ha gia'
> bocciato due volte** — con la differenza, onesta, che **Upcomers paga
> davvero, ad alcuni.**

### ❓ 2. Che impostazioni ha?

> 🔴 **Muro giornaliero 3% · muro totale 6% TRAILING sull'equity · reset 00:00
> UTC (= 01:00 ora server BCM d'estate).** Il trailing si blocca al breakeven,
> **ma solo a +6% di balance — cioe' DOPO il target del 5%: nella challenge il
> muro insegue sempre.** Piu' una **Best Day Rule 15-20%** che congela il primo
> prelievo se un giorno pesa troppo. **Contro il nostro metro (10% statico / 5%
> giornaliero, p99 8,1%, peggior giorno −2,06%): non passiamo, e non di poco.**

### ❓ 3. Accetta EA?

> # 🟢 SI'.
> Ufficialmente e per iscritto, **dal 26 maggio 2026**, su tutte e cinque le
> piattaforme **MT5 compreso**, e la formula copre esplicitamente anche i
> **risk manager** — cioe' il nostro **Guardian**.
> 🔴 **Con due cavilli che ci riguardano davvero:** ogni trade chiuso **sotto i
> 2 minuti** e' _tick scalping_ **vietato** (e con `ExportTrades()` senza
> `open_time` **non possiamo nemmeno misurare se li violiamo**), e le posizioni
> **sempre nella stessa direzione** ricadono nei _one-sided bets_ — che e'
> **proprio la motivazione con cui piu' recensioni dicono di essersi viste
> negare il payout**.

---

## 8. 🛑 IL VERDETTO — e cosa NON autorizza questo dossier

> ## 🔴 **NON COMPRARE.** E la ragione dirimente **non e' l'affidabilita': e' l'aritmetica.**
>
> Anche se Upcomers fosse la prop piu' onesta del mercato, **un muro totale del
> 6% TRAILING sta SOTTO la nostra p99 di 8,1% misurata su DD STATICO**, e un
> muro giornaliero del **3%** lascia **meno di un giorno e mezzo** come la
> nostra peggior giornata gia' successa (−2,06%). **Non e' una prop difficile:
> e' una prop che i nostri numeri, come sono oggi, non possono passare.**
>
> Il target 5% in fase unica **non compensa**: `METRO_PROP` §9 lo dice gia' —
> _"in una prop il drawdown conta piu' del rendimento"_. Qui il rendimento
> richiesto e' **la meta'** di FTMO, ma il rischio concesso e' **il 60% del
> muro totale e il 60% del daily**, e per giunta **trailing**.

**Questo dossier NON autorizza:** nessun acquisto (vale **D3**: risposta scritta
del supporto prima di tutto), nessuna modifica al forward, nessun cambio di
soglia del Guardian, nessun round. **Le proposte del file gemello vanno in
lista: decide Claudio.**

---

## 9. 📌 LE PROPOSTE (in ordine di resa/costo) — nessuna si applica da sola

```
PROPOSTA   P1 — Preset "muri stretti" del Guardian (parametri, NON codice)
DOVE       ABTG_Guardian, solo input: InpDailyPausePct 2,4 . InpDailyLossPct 3,0
           . InpTotalDDPct 6,0 . InpDDMode 1 (trailing) . InpDailyResetHour 1
           (estate) / 0 (inverno). Rapporti conservati dalle soglie firmate
           18/08 (pausa = 80% del muro, emergenza = 98%).
FONTE      §5 di questo dossier
COSTO      ~0 ore di sviluppo (esistono gia' tutti gli input) + 1 round di
           autotest (InpAutotest) su conto demo separato
RISCHIO    con daily 3% la pausa a 2,4% scatta MOLTO piu' spesso: la flotta
           passerebbe giornate intere bloccata. Va misurato PRIMA, non dopo.
VALE ANCHE SENZA UPCOMERS?  🟢 SI' — e' il preset per QUALUNQUE prop a muri
           stretti. Vale la pena anche se la risposta a Upcomers e' no.
```

```
PROPOSTA   P2 — open_time + package_id in ExportTrades()
DOVE       tutti gli EA di casa (ExportTrades(), es. ABTG_PTE.mq5:569)
FONTE      §2-bis A — regola dei 2 minuti; gia' chiesto in M2 di PIANO_PROP.md
           e in METRO_PROP §13.2 per l'unita' PACCHETTO
COSTO      poche ore (una riga per EA) + rigenerazione degli export
RISCHIO    basso; nessun impatto sulla logica di trading
PERCHE' ORA  🔴 e' il TERZO mandato che chiede lo stesso campo. Oggi non
           sappiamo dire quanti nostri trade durano meno di 2 minuti: su
           Upcomers e' una VIOLAZIONE, e la misura oggi e' IMPOSSIBILE.
VALE ANCHE SENZA UPCOMERS?  🟢 SI' — serve gia' a G2 (pacchetti) e al rischio aperto.
```

```
PROPOSTA   P3 — "blocco al breakeven" del trailing nel Guardian
DOVE       ABTG_Guardian.mq5:367 — nuovo input InpTrailLockProfitPct (0=spento):
           quando balance >= gStart*(1+X/100), il pavimento si CONGELA a gStart
           invece di continuare a seguire gPeak
FONTE      §1 — meccanica Dynamic Risk Shield (help/12639372)
COSTO      1-2 ore + round di autotest
RISCHIO    se sbagliato, ALLENTA una protezione: va scritto in modo che il
           pavimento non possa MAI scendere sotto il valore gia' raggiunto
NOTA       oggi il nostro trailing e' PIU' severo del vero: non e' pericoloso,
           costa solo operativita'. Priorita' bassa finche' non serve davvero.
```

```
PROPOSTA   P4 — Monte Carlo con DD TRAILING (il buco piu' vecchio del metro)
DOVE       dd_portafoglio.py (PC backtest) — sessione principale, non qui
FONTE      METRO_PROP §1: "Verdetto onesto: NON LO SAPPIAMO... non l'abbiamo
           mai calcolato"; §13.4 buco 3 (serie giornaliera su EQUITY, non su
           close_time)
COSTO      dati gia' in casa; dipende da P2
RISCHIO    nessuno (e' un calcolo offline)
PERCHE'    🔴 il trailing e' lo standard di TUTTE le prop moderne. Senza questo
           numero non possiamo giudicare NESSUNA prop nuova, non solo Upcomers.
           E' la proposta con la resa piu' alta del dossier.
```

```
PROPOSTA   P5 — le domande scritte al supporto (SE mai si riaprisse D3)
DOVE       report/DOMANDE_SUPPORTO_PROP.md — da aggiungere in coda
FONTE      §6, i nove buchi
COSTO      ~1 ora
LE DOMANDE (testo pronto):
  1. "Is the account HEDGING or NETTING? Can two different EAs hold opposite
     positions on the same symbol at the same time?"
  2. "What is the exact server time zone (UTC offset) and the exact symbol
     names for DAX, Dow, Nasdaq, Gold?"
  3. "Do you restrict trading around high-impact news? If yes, what is the
     exact window in minutes, and which calendar is authoritative?"
  4. "The 2-minute minimum holding time: does it apply to a trade closed by its
     STOP LOSS? A breakout EA can be stopped out within seconds of entry
     through no action of the trader."
  5. "One-sided bets: an EA that is systematically SHORT-only on one index by
     design - is that a violation? Please confirm in writing."
  6. "I run the same self-written EA portfolio on two of MY OWN accounts. Is
     that copy trading under your rules?"
  7. "Best Day Rule: is it 15% or 20% on a 100k Thunderbolt account?"
```

---

## 10. 🧭 LA LEZIONE DA SCOLPIRE (vale oltre Upcomers)

1. 🔴 **Un sito di recensioni mi ha dato la risposta SBAGLIATA alla domanda
   principale di Claudio** ("EA vietati" quando sono ammessi da tre mesi).
   **Solo l'help center ufficiale l'ha corretta.** La gerarchia delle fonti del
   mandato non e' una formalita': **e' la differenza fra un si' e un no.**
2. 🔴 **Il target basso e' l'esca; il muro e' il prezzo.** 5% in fase unica
   sembra il regalo — ma il conto vero e' 3% daily e 6% trailing. **Si guarda
   sempre il muro prima del traguardo.**
3. 🔴 **Il nostro Guardian e' tarato su UNA prop (FTMO).** Su muri diversi non
   e' "meno efficace": e' **inerte**. Serve un **preset per famiglia di muri**,
   non un solo set di soglie.
4. 🔴 **`open_time` manca da tre mandati.** Oggi non e' piu' un debito tecnico:
   e' l'impossibilita' di dimostrare la conformita' a una regola scritta.
5. 🟢 **La regola dei DUE LATI di Claudio (25/08) ha appena preso un secondo
   motivo per esistere**: nata per la misura, si scopre essere anche una
   protezione contro le clausole "one-sided bets".

---

### 📚 FONTI (tutte `[LETTO-VIA-SEARCH 26/08/2026]`, nessuna aperta direttamente)

**Ufficiali Upcomers (help center + sito):**
- help.upcomers.com/en/articles/12983894-thunderbolt-challenge-complete-rules-overview
- help.upcomers.com/en/articles/12639372-what-is-dynamic-risk-shield
- help.upcomers.com/en/articles/12639478-what-is-daily-drawdown
- help.upcomers.com/en/articles/8496661-how-can-i-calculate-the-daily-drawdown
- help.upcomers.com/en/articles/8496666-how-does-a-drawdown-limit-work
- help.upcomers.com/en/articles/12749721-thunderbolt-turbo-1-phase-challenge
- help.upcomers.com/en/articles/11704867-are-expert-advisors-eas-trading-bots-and-automated-strategies-allowed
- help.upcomers.com/en/articles/8703143-what-trading-strategies-are-prohibited-at-upcomers
- help.upcomers.com/en/articles/12640252-tick-scalping
- help.upcomers.com/en/articles/12640311-one-sided-bets
- help.upcomers.com/en/articles/12640343-copy-trading
- help.upcomers.com/en/articles/12657611-best-day-rule
- help.upcomers.com/en/articles/12688538-payout-structure
- help.upcomers.com/en/articles/12639949-eligibility-for-payout
- help.upcomers.com/en/articles/8496693-can-i-hold-my-trades-overnight
- help.upcomers.com/en/articles/8496907-can-i-hold-my-trades-over-the-weekend
- help.upcomers.com/en/articles/8496680-what-instruments-can-i-trade
- help.upcomers.com/en/articles/15729222-trading-hours-and-globex-sessions
- help.upcomers.com/en/articles/15095378-spring-friday-90-off-everything-free-second-account
- upcomers.com/policies/terms-conditions · upcomers.com/plans · upcomers.com/platforms · upcomers.com/about

**Terzi:**
- globenewswire.com/news-release/2026/06/24/3316752/0/en/upcomers-expands-trading-automation-across-all-supported-platforms.html
- tradeinformer.com/broker-news/upcomers-enables-ea-and-automation-support-across-all-five-trading-platforms
- trustpilot.com/review/upcomers.com · trustpilot.com/review/app.upcomers.com
- propfirmmatch.com/unlisted-prop-firms/upcomers · propfirmmatch.com/unlisted-firms
- forexpeacearmy.com/forex-reviews/23346/upcomers-review (bloccato, solo via search)
- mypropgenius.com/reviews/upcomers · thetrustedprop.com/prop-firms/upcomers 🔴 **(fonte dell'informazione ERRATA sugli EA)**

**Interne:** `report/METRO_PROP.md` · `report/INDAGINE_PROP_INSTAGRAM.md` ·
`report/CONTRATTI_SEDIE.md` · `report/FIRME_2026-08-18.md` ·
`mql5/Experts/ABTG_Guardian.mq5` (righe 50-70, 355, 367)
