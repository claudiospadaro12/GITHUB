# 📰 DOSSIER FILTRO NEWS — materiale per l'imbuto del FiboH4 (R93)

**Data del lavoro:** 21/08/2026
**Perimetro:** riga **D5** di `report/PIANO_PROP.md` (filtro news del FiboH4,
dichiarato OBBLIGATORIO dal corso, presente nel nostro EA e **spento**).
**Cosa NON e' questo file:** non e' un round, non e' una promozione, non e'
una richiesta di accendere niente in forward. E' materiale per l'imbuto.

> 🔒 **`mql5/Experts/ABTG_FiboH4_Multi.mq5` NON e' stato toccato** (audit di un
> altro agente in corso). Qui il sorgente e' stato solo **letto**.

---

## 0. 🎯 CONTROLLO POSITIVO DELLE FONTI — cosa risponde e cosa no

Eseguito **prima** della caccia, su ogni canale.

| canale | esito | conseguenza |
|---|---|---|
| **WebSearch** (motore generale) | ✅ risponde con contenuti veri | usato |
| **mql5.com** (docs, forum, articoli, Market, blog) | ✅ **200**, pagine leggibili | usato come fonte primaria |
| **github.com** (pagine repo + `raw.githubusercontent.com`) | ✅ **200** | usato come fonte primaria |
| **api.github.com** | ❌ **403** "GitHub access not enabled for this session" | metadati (licenza/stelle/ultimo commit) solo via pagina HTML |
| **ricerca repository di GitHub** (`/search?type=repositories`) | ❌ ritorna **0 results** senza autenticazione | repo trovati via WebSearch, poi aperti a mano |
| **ftmo.com** | ❌ **EGRESS_BLOCKED** | 🛑 FONTE NULLA |
| **the5ers.com** · **help.the5ers.com** | ❌ EGRESS_BLOCKED | 🛑 FONTE NULLA |
| **fundingpips.com** · **fundednext.com** · **help.fundednext.com** | ❌ EGRESS_BLOCKED | 🛑 FONTE NULLA |
| **alphacapitalgroup.uk** · **e8markets.com** | ❌ EGRESS_BLOCKED | 🛑 FONTE NULLA |
| **forexfactory.com** | ❌ **403** | 🛑 FONTE NULLA (il dato ci arriva da mirror, §1) |
| **nfs.faireconomy.media** (feed CSV settimanale FF) | ❌ EGRESS_BLOCKED | 🛑 non verificabile da qui |
| **huggingface.co** | ❌ EGRESS_BLOCKED | 🛑 FONTE NULLA |
| **propfirmsfinder.com** (aggregatore) | ❌ EGRESS_BLOCKED | 🛑 FONTE NULLA |

### 🔴 La conseguenza che pesa sul §3
**Nessun sito ufficiale di prop e' apribile da questa macchina.** Quindi
**tutto il §3 e' `[LETTO-VIA-SEARCH]`**: sono snippet restituiti dal motore di
ricerca sulle pagine ufficiali, **non pagine che ho aperto io**. E' lo stesso
rango di evidenza gia' usato in `PIANO_PROP` per il censimento prop, e
**nessuna riga del §3 autorizza da sola un acquisto o una configurazione
finale**: i minuti vanno riconfermati sul sito della prop scelta, il giorno
che si sceglie (regola di casa: le prop cambiano le regole senza avvisare).

---

## 1. 🗄️ LE FONTI DATI DEL CALENDARIO — cosa si scarica davvero

### 1A. Tabella delle fonti

| # | fonte | copertura | granularita' / fuso | campo IMPATTO | campo VALUTA | licenza | registrazione | verdetto |
|---|---|---|---|---|---|---|---|---|
| 1 | **`spoluan/forex-factory-scraper`** — cartella `datasets/`, branch **`master`** ([repo](https://github.com/spoluan/forex-factory-scraper/tree/master/datasets)) | **2010→2023**, 14 file annuali, **65.271 righe** | data+ora al minuto; **UTC+8 fisso, DST USA corretta** — 🧪 **MISURATO DA NOI**, non dichiarato | `High` / `Medium` / `Low` / `Non-economic` | ✅ `USD,EUR,GBP,JPY,AUD,CAD,NZD,CHF,CNY,All` | **MIT** (dichiarato in pagina) | ❌ no | 🥇 **LA FONTE** — vedi §1C |
| 2 | **`EPSOFT/dataset-forexfactory`** ([repo](https://github.com/EPSOFT/dataset-forexfactory)) | **2007→marzo 2023** (dichiarato) | non verificato | non verificato (README non elenca le colonne) | non verificato | **GPL-3.0** ⚠️ virale | ❌ no | 🥈 **riserva**: copre 2007-2009 che alla n.1 mancano. Colonne **[INCERTO]**, da aprire se servono quegli anni |
| 3 | **Feed ufficiale Forex Factory** `nfs.faireconomy.media/ff_calendar_thisweek.csv` | **solo settimana corrente** | — | — | — | — | ❌ no | 🛑 **non apribile da qui** + copre solo il futuro prossimo → **inutile per il backtest** |
| 4 | **forexfactory.com/calendar** diretto | 2007→oggi | — | — | — | — | — | 🛑 **403**, e i ToS non li ho potuti leggere → **non si scrapa** |
| 5 | **`Ehsanrs2/Forex_Factory_Calendar`** (Hugging Face) | "dal 2007" (dichiarato dallo snippet di ricerca) | — | — | — | **[INCERTO]** | — | 🛑 **huggingface bloccato** → non verificabile |
| 6 | **Calendario nativo MQL5** (`CalendarValueHistory`) | dal **2007** circa, ~90.000 eventi (dichiarato da un moderatore sul forum) | ora del server di trading | `ENUM_CALENDAR_EVENT_IMPORTANCE` | ✅ filtro nativo per valuta e paese | MetaQuotes | ❌ (serve solo il terminale) | 🔴 **NON usabile in tester** — vedi §1B |
| 7 | **I 2 CSV gia' in biblioteca** (`CALENDARIO_news-2021-2024_*` e `-2022-2025_*`) | **2021→dic 2025**, 37.799 righe | data+ora; **UTC+2** (dichiarato nel nome file) | `0/1/2/3` numerico | ❌ **NO: c'e' il PAESE** ("United States"), non la valuta | — | — | 🔴 **NON compatibili col nostro EA cosi' come sono** — vedi §1D |

### 1B. 🧪 La domanda vera: `CalendarValueHistory` funziona nel tester?

**Risposta: NO. `[VERIFICATO]` su fonte primaria, letta il 21/08/2026.**

- La **pagina ufficiale della funzione** ([mql5.com/en/docs/calendar/calendarvaluehistory](https://www.mql5.com/en/docs/calendar/calendarvaluehistory)) e la **sezione Calendar** ([mql5.com/en/docs/calendar](https://www.mql5.com/en/docs/calendar)) — entrambe aperte da me — **non dicono nulla** sul tester. 👉 quindi *la documentazione ufficiale non promette il supporto, ma nemmeno lo nega*: da sola **non risponde**.
- La risposta sta sul **forum ufficiale MQL5**, thread [326554](https://www.mql5.com/en/forum/326554) (aperto da me il 21/08/2026): l'utente Eric Emmrich (15/11/2019) — _"CalendarValueHistory ... returns no results during backtest"_. Il moderatore **Chris70** conferma e indica il rimedio: _"the trick is to read all relevant information from a file that has previously been created ... if the EA/script/indicator has at least once been started in live mode"_.
- ⚠️ **Nel thread NON c'e' nessuna risposta ufficiale MetaQuotes.** E' consenso di comunita' su forum ufficiale, non normativa.
- **Corroborazione**: gli articoli MQL5 dedicati al problema esistono e propongono lo stesso rimedio — l'[articolo 17603](https://www.mql5.com/en/articles/17603) (aperto da me) descrive il metodo a due fasi: fase **live** che scrive `Database\EconomicCalendar.csv` con `CalendarValueHistory()`, e fase **tester** che rilegge quel file incorporato come risorsa (`#resource "\\Files\\Database\\EconomicCalendar.csv" as string EconomicCalendarData`).

> ✅ **Conclusione operativa: la strada CSV che il nostro EA ha gia' e' quella
> giusta, non un ripiego.** `LoadNews()` che legge un file e' *esattamente* il
> rimedio che la comunita' MQL5 usa. Il pezzo che ci manca **non e' il codice:
> e' il file di dati giusto** (§1C).

### 1C. 🥇 La fonte scelta, e perche' — con la misura del fuso

`spoluan/forex-factory-scraper`, `datasets/`, branch `master`, **MIT**.
Scaricato e profilato da me il 21/08/2026 (14 file, 5,5 MB, 65.271 righe).

**Formato reale, misurato (non dal README):**
```
Date,Time,Currency,Event,Impact,Actual,Forecast,Previous,Combined DateTime
2012-01-06,9:30pm,USD,Non-Farm Employment Change,High,200K,152K,100K,2012-01-06 21:30:00
```

**🧪 IL FUSO — misurato, ed e' la trappola che valeva il lavoro.**
Il repo **non dichiara il fuso**. L'ho ricavato da due eventi di orario noto:

| evento | orario ufficiale | valore nel dataset | offset implicito |
|---|---|---|---|
| Non-Farm Payrolls, gennaio (inverno) | 08:30 **EST** = 13:30 UTC | `21:30` | **UTC+8** |
| Non-Farm Payrolls, giugno/luglio (estate) | 08:30 **EDT** = 12:30 UTC | `20:30` | **UTC+8** |
| FOMC Statement 13/03/2012 | 14:15 **EDT** = 18:15 UTC | `2012-03-14 02:15` | **UTC+8** |

Controprova su **4 anni indipendenti** (2012, 2015, 2019, 2023): **sempre**
21:30 d'inverno e 20:30 d'estate. 👉 il dataset e' in **UTC+8 fisso** (fuso
asiatico, che la DST **non** la fa) e **segue correttamente la DST americana**.
**Sottrarre 8 ore da' UTC esatto, tutto l'anno, senza eccezioni.**

> 🔴 **Se questo non lo misuri, sbagli di 8 ore ogni finestra news** e il
> filtro "funziona" bloccando l'ora sbagliata. E' il modo silenzioso di
> ripetere l'incidente **M17** (`PIANO_PROP`: _"e' stato misurato il nulla"_).

**Volume misurato:**

| anno | High | Medium | totale |
|---|---|---|---|
| 2010 | 1.167 | 1.937 | 4.585 |
| 2012 | 1.169 | 1.850 | 4.551 |
| 2015 | 1.193 | 1.457 | 4.592 |
| 2018 | 838 | 1.169 | 4.669 |
| 2020 | 751 | 691 | 4.793 |
| 2021 | 546 | 762 | 4.809 |
| 2023 | 908 | 619 | 4.803 |

⚠️ **La definizione di "High" non e' stabile nel tempo** (1.167 nel 2010 →
546 nel 2021 → 908 nel 2023). Non e' il mondo che cambia: e' **Forex Factory
che ha ri-etichettato**. Conseguenza per l'imbuto: **un backtest 2010-2023 col
filtro acceso non applica lo stesso filtro nei due estremi del campione.**
Va dichiarato in qualunque round, e per l'Emendamento della Finestra e' un
argomento in piu' per **giudicare per regime**, non su 14 anni contigui.

**High per valuta (2010-2023, totale):** USD 4.504 · GBP 2.216 · CAD 1.666 ·
AUD 1.622 · EUR 1.267 · NZD 996 · CNY 519 · JPY 485 · CHF 348.

### 1D. 🔴 I 2 CSV che abbiamo gia' in casa: **non bastano, e il modo in cui non bastano e' insidioso**

`PIANO_PROP` D1 li da' per pronti ("2 CSV gia' in `biblioteca/dati/`"). **Li ho
aperti e misurati: al nostro EA non si possono dare cosi'.**

Il loro formato e':
```
2022.01.04 17:00;United States;3;ISM Manufacturing PMI (Dec)
      ^data           ^PAESE   ^impatto  ^evento
```
Il parser del nostro EA (`LoadNews()`, righe 454-476) legge invece:
```
campo1 = data/ora    campo2 = IMPATTO    campo3 = VALUTA
```
👉 **le colonne 2 e 3 sono invertite rispetto a quello che l'EA si aspetta.**

`ImpactToInt()` riceverebbe `"United States"` e cerca le sottostringhe
`HIGH`/`MED`/`LOW`. **Controprova eseguita su tutti i nomi di paese distinti
dei due file: NESSUNO le contiene** → ogni evento verrebbe classificato
**impatto 0**. Con `InpNewsMinImpact = 3`:

> 🧪 **0 eventi bloccanti su 37.799 righe. Il filtro si accende, scrive
> "news caricate: 37799" nel log, e non blocca NIENTE.**

**Questo e' un fallimento silenzioso**, identico per meccanica all'incidente
M17 (calendario con soli eventi 2026-2027 → `Trades=0` → verdetto emesso sul
nulla). Un round R93 col filtro acceso e questo file darebbe risultati
**identici al filtro spento**, e li chiameremmo "il filtro non cambia niente".

Altri due difetti degli stessi file, minori ma reali:
- **manca la valuta** (c'e' il paese) → la deroga per-valuta del corso e'
  impossibile senza una tabella paese→valuta;
- **coprono solo 2021-2025**: il nostro perimetro parte dal 2010.

---

## 2. 🔧 COME LO FANNO GLI ALTRI — la tabella dei valori copiabili

⚠️ Colonna "rango": 🥇 = sorgente/manuale aperto da me · 🥈 = pagina prodotto
aperta da me · 🥉 = snippet di ricerca `[LETTO-VIA-SEARCH]`.

| # | fonte (URL) | min PRIMA | min DOPO | impatti | per valuta? | chiude/cancella o solo blocca? | rango |
|---|---|---|---|---|---|---|---|
| 1 | **`NewsFilter.mqh` di Ivan Pochta** — copia in `biblioteca/sorgenti/`, 283 righe ([blog 766702](https://www.mql5.com/en/blogs/post/766702)) | **60** | **60** | `NEWS_IMP_HIGH_ONLY` (default) | ✅ **si**, input `NewsCurrencies = "USD,EUR"` | 🟡 solo blocco ingressi | 🥇 sorgente letto |
| 2 | **Articolo MQL5 17603** (calendario nel tester) ([link](https://www.mql5.com/en/articles/17603)) | `HoursBefore=4` + `MinutesBefore=10` → **250** | `HoursAfter=1` + `MinutesAfter=5` → **65** | enum a 15 combinazioni | ✅ si, 8 major | 🟡 solo blocco | 🥇 articolo letto |
| 3 | **"The News Filter MT5"**, Leolouiski Gan — $70 perpetuo / $45 mese ([market 97675](https://www.mql5.com/en/market/product/97675)) | configurabile per chart | configurabile | per livello di impatto | ✅ si, "qualsiasi numero di coppie" | 🔴 **tutti e tre**: chiude posizioni · **cancella pendenti** · rimuove/sposta SL-TP, con **ripristino dopo** | 🥈 pagina letta |
| 4 | **Guida dello stesso prodotto** ([blog 752543](https://www.mql5.com/en/blogs/post/752543)) | **20** (esempio high su EURUSD) | **30** (stesso esempio) | BEFORE/AFTER **separati per livello** | ❌ nell'esempio no | rimuove l'EA dal grafico e lo riattacca | 🥈 pagina letta — ⚠️ e' un **esempio**, non un default dichiarato |
| 5 | **Range Breakout Daytrader** (32 preset pubblici, gia' in `PIANO_PROP` F6) | **5** | **5** | — | — | blocco ingressi + chiusura di sessione | 🥉 gia' agli atti |
| 6 | **TIP** (gia' agli atti in `PIANO_PROP` D2) | **30** | **15** | — | — | — | 🥉 gia' agli atti |
| 7 | **guida 772732** (gia' agli atti) | **30** | **30** | — | — | — | 🥉 gia' agli atti |
| 8 | **Gold Phantom** su NFP (gia' agli atti) | **100** | **60** | solo NFP | — | 🔴 **chiude l'aperto** | 🥉 gia' agli atti |
| 9 | 🎓 **IL CORSO, lezione 18 (FiboH4)** — `modulo_fiboh4/18. FIBO H4 SET UP...txt` | **"prima del rilascio"** (nessun numero) | non detto | "ogni dato macroeconomico" | ✅ **si, esplicitamente** | 🔴 **"gli ordini vanno tolti"** = cancella i pendenti | 🥇 trascrizione letta |

### 2A. 📉 Il verdetto sul campione dei minuti

**Il campione va da 5 a 250 minuti prima e da 5 a 65 dopo. Non converge, e
nessun numero si puo' copiare.** E' esattamente la conclusione gia' registrata
in `PIANO_PROP` D2 (_"nessuna convergenza, nessun numero da copiare"_): questa
caccia la **conferma allargando il campione**, non la ribalta.

👉 **Quindi i minuti NON si scelgono imitando: si scelgono dalla REGOLA DELLA
PROP** (§3), che e' un vincolo verificabile, invece che da una media di
opinioni commerciali. Questa e' la scelta di metodo che propongo al §5.

### 2B. 🔴 Il meccanismo che TUTTI hanno e che a noi manca

La riga che conta di tutta la tabella:

| meccanismo | chi ce l'ha | il nostro FiboH4 |
|---|---|---|
| blocco dei **nuovi ingressi** in finestra | tutti (1,2,3,5,6,7) | ✅ **ce l'ha** (riga 225) |
| **cancellazione dei pendenti** prima del dato | n.3 (prodotto a pagamento) · **n.9 IL CORSO** | ❌ **NON ce l'ha** |
| **chiusura delle posizioni aperte** | n.3, n.8 | ❌ non ce l'ha |
| filtro **per valuta** | n.1, n.2, n.3, **n.9 il corso** | ⚠️ **a meta'** — vedi §4 |
| **ripristino** dopo la finestra | n.3 | ❌ non ce l'ha (e per noi non serve) |
| deroga per **distanza dal livello** | 🚫 **nessuno dei 9** | ❌ non ce l'ha |

> 🎓 **La deroga "si opera lo stesso se il prezzo dista >=100 pip" non esiste
> in natura fuori dal corso.** Su 8 fonti esterne lette, **zero** la
> implementano. E' una regola **originale del corso** — il che non la rende
> ne' buona ne' cattiva, ma significa che **non c'e' niente da copiare** e che
> se la vogliamo va scritta e **misurata** da noi. Citazione esatta (lez. 18):
> _"nel momento in cui ci sono dati macroeconomici che impattano la valuta, ma
> il prezzo e' distante almeno di 100 pip, posso prendere in considerazione
> ... ci sono dati molto importanti tipo Non Farm Payroll dove io personalmente
> cancello tutto, ma se c'e' un dato che impatta sul dollaro e i prezzi sono
> distanti 100, 150 pip, puoi anche prenderli in considerazione"_

📐 Nota di aritmetica di casa: il FiboH4 ha gia' `InpMinDistPips = 50`. La
deroga del corso a **100 pip** e' quindi **il doppio** della distanza minima
che l'EA gia' pretende per piazzare l'ordine. **[INFERITO]** — dedotto dal
confronto fra l'input e la trascrizione: la deroga a 100 pip non e' una
condizione rara, e' una condizione che **una parte consistente dei nostri
setup soddisfa gia'**; quindi accendere la deroga **annacquerebbe molto** il
filtro. Quanto, non lo so: **[INCERTO]**, si misura, non si stima.

---

## 3. ⚖️ LE REGOLE PROP SULLE NEWS

🔴 **TUTTA questa sezione e' `[LETTO-VIA-SEARCH]`, data 21/08/2026.** I siti
ufficiali sono bloccati (§0). **Nessuna riga qui e' una pagina che ho aperto.**
Prima di comprare una challenge, ogni riga va riletta sul sito della prop.

| prop | finestra vietata | solo high impact? | challenge o funded? | penalita' dichiarata | overnight | weekend |
|---|---|---|---|---|---|---|
| **FTMO Standard** | **±2 min** ("2 minuti prima e 2 dopo") | ✅ si, **lista di eventi + strumenti specifici** | 🔴 **solo FUNDED** — _"FTMO does not enforce the 2-minute restricted window during your evaluation phases"_; si attiva **nell'istante** in cui arriva il conto reale | violazione (breach). ⚠️ **conta anche l'esecuzione di un pendente e lo scatto di SL/TP dentro la finestra** | ammesso | 🔴 **vietato sul funded Standard**; ammesso in evaluation |
| **FTMO Swing** | 🟢 **nessuna** | — | — | — | ammesso | 🟢 **ammesso** |
| **FundedNext** (Stellar 2-Step / Lite) | **±5 min** | ✅ si, "listed high-impact", **solo se correlato alla coppia** | 🟢 challenge: **nessuna restrizione**; funded: regola attiva | 🟡 **non e' un breach**: e' il **News Reward Share** — solo il **40%** del profitto di quel trade conta; **le perdite restano intere al trader** | 🟢 ammesso | 🟢 ammesso, tutti i conti |
| **The5ers — High Stakes** | **±2 min** | ✅ si | funded | deduzione di profitto; **tenere aperto attraverso la news e' permesso**, **eseguire** dentro la finestra no | ammesso | 🟢 ammesso (⚠️ una fonte dice vietato in challenge → **[INCERTO]**) |
| **The5ers — Hyper-Growth / Bootcamp** | 🟢 nessuna (vietato il **bracketing**) | — | — | — | ammesso | ammesso |
| **E8 — Signature** | 🟢 nessuna | — | — | — | ⚠️ **chiusura forzata 23:00 server** (gia' agli atti, `PIANO_PROP` D4) | — |
| **E8 — One (funded)** | **±5 min** | ✅ si | 🟢 evaluation libera; funded ristretta | vietato aprire/chiudere | — | — |
| **FundingPips — Master** | **±5 min** (e da 5 min prima dell'inizio di uno **speech** a 5 min dalla fine) | "red folder Forex Factory" | funded | 🔴 **profitto INTERO dedotto** — 🟢 **ma c'e' la deroga: salva il trade aperto ≥5 ORE prima dell'evento** | — | — |
| **FundingPips — Zero** | **±10 min** | id. | — | 🔴 **hard breach** — e vale anche **solo TENENDO** la posizione (non serve eseguire) | — | — |
| **Alpha Capital — Pro 8% / Pro 10%** | **±2 min** | ✅ si | 🟢 challenge libera; funded ristretta | **Soft Breach**: il profitto non e' eleggibile alla performance fee | — | — |
| **Alpha Capital — Pro 6% / One / Three** | **±5 min** | ✅ si | funded | id. | — | — |
| **Alpha Capital — Swing** | si opera, **ma il trade aperto in finestra deve restare aperto ≥2 min** | ✅ si | funded | — | — | — |

### 3A. 🧠 Le tre cose che questa tabella insegna e che valgono piu' dei minuti

**1. 🥇 In CHALLENGE il filtro news quasi non serve.**
FTMO, FundedNext, E8, Alpha Capital: **tutte** dichiarano evaluation **libera**
dalla restrizione news. Il filtro serve **dopo**, sul funded.
👉 **Conseguenza diretta su R93: la scelta "filtro acceso o spento" NON e' una
scelta di conformita' in fase challenge. E' una scelta di STRATEGIA** — cioe'
va misurata nell'imbuto come qualunque filtro, esattamente come e' successo in
R84 dove **9 celle su 9** hanno detto che i filtri del corso non creano edge.
Il filtro news non ha alcuno sconto d'ufficio.

**2. 🔴 La finestra piu' stretta e' la piu' pericolosa per NOI.**
FTMO ±2 min sembra generosissimo. Ma la regola dice che **conta l'esecuzione
di un ordine pendente e lo scatto di SL/TP** dentro la finestra. Il FiboH4
**vive di ordini limite che restano appesi fino a 24 ore** (`InpPendingExpiryBars
= 6` × H4). Un limit che si riempie alle 14:29:30 su un dato delle 14:30 e'
una violazione **anche se l'EA non ha "deciso" niente in quel momento**.
👉 **Il rischio prop del FiboH4 non e' negli ingressi: e' nei pendenti appesi.**
E il nostro filtro, oggi, **guarda solo gli ingressi**.

**3. 🟢 Due prop regalano una deroga a orologeria che il FiboH4 puo' usare.**
FundingPips salva il trade aperto **≥5 ore prima**; Alpha Swing chiede che il
trade aperto in finestra **duri ≥2 minuti**. Il FiboH4 arma al mattino e
cancella a fine giornata: e' **strutturalmente** un motore a ordini vecchi di
ore. 👉 **[INFERITO]** dal confronto fra la regola e `InpCutoffHour=17:45`:
il FiboH4 e' piu' compatibile con FundingPips di quanto sembri, **purche' il
riempimento non cada in finestra**. Da confermare per iscritto (voce per la
lista D3 di `report/DOMANDE_SUPPORTO_PROP.md`).

### 3B. Le altre due voci del corso, viste dalle prop

| voce del corso (FiboH4) | cosa dice il corso | cosa dicono le prop |
|---|---|---|
| **overnight vietato** — cancellare i pendenti **18:30-19:00** | _"se gli ordini non vengono eseguiti entro le 18.30-19 vanno cancellati, non vanno portati over night"_ (lez. 18) | 🟢 **nessuna prop censita vieta l'overnight.** E8 Signature **chiude tutto alle 23:00 server** (gia' in `PIANO_PROP` D4). 👉 la regola e' **del corso, non della prop** |
| **weekend vietato** — _"mai e qua dico mai"_ | _"non stare mai e qua dico mai aperto durante il weekend ... succede una guerra, succede qualsiasi cosa, ti trovi il mercato alla domenica con un gap up o gap down"_ (lez. 18) | 🔴 **FTMO Standard FUNDED lo vieta davvero.** FTMO Swing, FundedNext, The5ers: ammesso. 👉 **e' l'unica delle tre voci che coincide con una regola prop vera**, e coincide **solo su FTMO Standard funded** — che e' proprio la F1 del piano |

> ✅ **Buona notizia gia' in cassa:** il nostro EA queste due le implementa
> **gia', e in ora server**: `InpUseCutoff=true` a **17:45 server** (= 18:45
> italiana, **dentro** la finestra 18:30-19:00 del corso) e
> `InpFridayClose=true` a **21:50 server** (= 22:50 italiana, **lo stesso
> numero** che il relatore detta nel modulo PostNews: _"venerdi' alle 22.50 lo
> chiuderai tu manualmente"_). **Su overnight e weekend non manca niente.**

---

## 4. 🕳️ LA TABELLA DEI BUCHI — fuori vs `ABTG_FiboH4_Multi.mq5`

Lettura del sorgente al 21/08/2026 (righe 75-80, 127, 225, 454-495).

| # | meccanismo | fuori (chi) | **noi** | gravita' |
|---|---|---|---|---|
| **B1** | **File dati compatibile col parser** | tutti | 🔴 **ASSENTE.** `abtg_news.csv` in `mql5/Files/` ha **17 righe, tutte del 2026** → in backtest 2010-2023 **blocca zero volte**. `data/abtg_news.csv` e' **0 byte**. I 2 CSV di biblioteca hanno **le colonne invertite** (§1D) | 🔴🔴 **il piu' grave: e' il bis di M17** |
| **B2** | **Cancellare i pendenti prima del dato** | prodotto n.3 · **il corso** | 🔴 **ASSENTE.** Il gate e' a riga 225, dentro `OnNewBar()`, e fa `return`: impedisce di **piazzare**, non tocca l'appeso | 🔴🔴 **e' il buco di CONFORMITA' prop** (§3A punto 2) |
| **B3** | **Filtro per valuta** | n.1, n.2, n.3, **il corso** | 🟠 **A META'.** L'EA **legge e memorizza** la valuta (`gNewsCcy[]`, riga 472) ma `InNewsBlackout()` (righe 487-495) **non la guarda mai**: blocca **tutti** i simboli su **qualunque** valuta. Un dato **NZD** ferma anche EURUSD | 🟠 grave ma **mezzo lavoro e' gia' fatto** |
| **B4** | **Chiudere le posizioni aperte in finestra** | n.3, n.8 | ❌ assente | 🟢 **e non lo voglio**: `PIANO_PROP` D2 lo classifica _"modifica di strategia travestita da protezione"_. **Nessuna prop censita vieta di TENERE** (tranne FundingPips Zero) |
| **B5** | **Deroga a >=100 pip** | 🚫 **nessuno fuori** | ❌ assente | 🟡 originale del corso, **da misurare, non da copiare** |
| **B6** | **Gestione del fuso / DST** | — | 🔴 **STRUTTURALMENTE INSUFFICIENTE.** `InpNewsShiftMinutes` e' **uno shift fisso**: se il server osserva la DST, **un solo valore sbaglia di un'ora per meta' anno**. E su `PIANO_PROP` M15a il fuso BCM e' **materia di conflitto dichiarato** (corso: IT−2 · repo: IT−1) | 🔴 **silenzioso**: sposta ogni finestra, non rompe niente |
| **B7** | Blocco anche in **gestione** (parziale/BE/trailing che eseguono in finestra) | — | ❌ assente (il gate e' solo su ingresso) | 🟡 gia' segnalato in `PIANO_PROP` D1 come "finestra 16:00 IT da governare" |
| **B8** | Prestazione: `InNewsBlackout()` scandisce **tutto** l'array a ogni chiamata | — | 🟡 O(N) su N eventi × barre × simboli | 🟢 tollerabile: **8.313 righe**, e la chiamata e' 6 volte al giorno per simbolo |

### 4A. 🧪 QUANTO BLOCCA DAVVERO — la misura che `PIANO_PROP` M16 dice mancante

> `PIANO_PROP` M16: _"Resta in coda R84-bis: **la copertura del filtro news sul
> CSV non e' misurata**"_. 👉 **Eccola. Misurata qui, 21/08/2026.**

Base: 62.100 eventi convertiti in UTC dal dataset FF; anni **2019-2023**;
solo lunedi'-venerdi'; ora server assunta **UTC+1** (regola di casa "BCM =
italiana − 1", agosto).

**(a) Sul gate COM'E' OGGI** — cioe' aperture di barra H4 bloccate
(00/04/08/12/16/20 server), **7.825 aperture nel campione**:

| configurazione | aperture bloccate | % |
|---|---|---|
| 🔴 **default attuale dell'EA: 60/30, High, TUTTE le valute** | 675 | **8,6 %** |
| 60/30, High, solo EUR+USD | 283 | 3,6 % |
| 30/30, High, tutte | 570 | 7,3 % |
| **15/15, High, tutte** | 370 | **4,7 %** |
| 15/15, High, EUR+USD | 174 | 2,2 % |
| 10/10, High, tutte (FundingPips Zero) | 279 | 3,6 % |
| 5/5, High, EUR+USD (E8 One) | 133 | 1,7 % |
| 2/2, High, EUR+USD (FTMO / The5ers) | 133 | 1,7 % |
| 60/30, **High+Medium**, tutte | 1.244 | **15,9 %** |

🔍 **Il dettaglio che sorprende: 2/2 e 5/5 bloccano lo STESSO numero (133).**
Perche' le aperture H4 cadono sull'ora tonda e **moltissimi dati americani
escono esattamente all'ora tonda** (15:00 UTC = apertura barra 16:00 server).
👉 **[INFERITO]** dalla coincidenza dei due conteggi: sul FiboH4 la finestra
stretta non e' "quasi niente" — **prende in pieno** un gruppo di barre molto
specifico e sempre lo stesso.

**(b) Sull'ESPOSIZIONE VERA** — % di tempo di mercato in cui un pendente
appeso puo' riempirsi dentro una finestra vietata (il buco **B2**):

| finestra / valute | eventi | finestre distinte | **% tempo mercato** | finestre a settimana |
|---|---|---|---|---|
| 2/2 EUR+USD (FTMO, The5ers) | 1.671 | 1.136 | **0,24 %** | 4,4 |
| 5/5 EUR+USD (E8, FundingPips, Alpha) | 1.671 | 1.135 | **0,61 %** | 4,4 |
| 10/10 EUR+USD (FundingPips Zero) | 1.671 | 1.064 | **1,19 %** | 4,1 |
| 15/15 EUR+USD | 1.671 | 1.013 | 1,76 % | 3,9 |
| 30/30 EUR+USD | 1.671 | 966 | 3,36 % | 3,7 |
| 60/30 EUR+USD (default EA) | 1.671 | 915 | 4,91 % | 3,5 |
| 🔴 **60/30 TUTTE le valute (default EA)** | 3.565 | 1.886 | **10,43 %** | 7,3 |
| 10/10 tutte le valute | 3.565 | 2.304 | 2,54 % | 8,9 |

> 🟢 **La notizia buona, e conta molto:** stare conformi a FTMO/The5ers costa
> **lo 0,24 % del tempo di mercato**, e a E8/FundingPips/Alpha lo **0,61 %**.
> **La conformita' prop e' quasi gratis.** Cio' che costa caro e' il
> **default 60/30 su tutte le valute: 10,43 %** — cioe' **~43 volte** il
> perimetro che una prop chiede davvero.

**(c) Carico per simbolo** (High/anno, finestra 15/15, 2019-2023):

| simbolo | eventi High/anno | finestre/sett | % tempo |
|---|---|---|---|
| GBPUSD | 366 | 4,5 | 1,99 % |
| USDJPY | 282 | 3,5 | 1,54 % |
| EURUSD | 334 | 3,9 | 1,76 % |
| 🔴 **comportamento ATTUALE** (cieco alla valuta) | **452** | 5,3 | **2,41 %** |

👉 il buco **B3** costa **+35 %** di finestre su USDJPY e **+23 %** su GBPUSD:
tempo in cui l'EA sta fermo **per un dato che non riguarda la sua coppia**.

---

## 5. 📋 LA PROPOSTA OPERATIVA

🔴 **Niente di tutto questo si accende da solo, e niente tocca il forward.**
Sono candidati **per l'imbuto**, mappati sugli input che l'EA **ha gia'**.

### 5A. Il preset che propongo come CENTRALE per R93

Mappato uno a uno sugli input esistenti — **zero righe di codice nuove**:

| input esistente | oggi | 📋 **proposto** | perche' (fonte) |
|---|---|---|---|
| `InpUseNewsFilter` | `false` | **`true`** *solo nel braccio sperimentale del round* | D5: e' la variabile in prova |
| `InpNewsFile` | `abtg_news.csv` (17 righe, **2026**) | **`CALENDARIO_FF_High_2010-2023_UTC.csv`** (8.313 righe) | §1C — e' il buco **B1** |
| `InpNewsMinImpact` | `3` | **`3` (invariato)** | tutte le prop del §3 restringono **solo su high impact**; e "Medium" quasi raddoppia il blocco (8,6 % → 15,9 %) senza che nessuna regola lo chieda |
| `InpNewsBeforeMin` | `60` | **`15`** | 🔴 **non copiato da nessuno**: scelto come **il piu' stretto che copre TUTTE e sei le prop censite** (max = ±10 di FundingPips Zero) **+ 5 min di margine**. Costa **1,76 %** del tempo contro il **4,91 %** di oggi |
| `InpNewsAfterMin` | `30` | **`15`** | idem, e simmetrico: nessuna prop del §3 usa finestre asimmetriche |
| `InpNewsShiftMinutes` | `0` | **`0`, e si rigenera il CSV** con `--shift-min` | buco **B6**: uno shift fisso **non sa gestire la DST**. Meglio zero e file gia' in ora server |

🔬 **E il braccio di controllo obbligatorio:** `InpUseNewsFilter=false` con
**tutto il resto identico**. Senza il gemello spento, R93 non puo' dire se il
filtro aggiunge o toglie — e la lezione R84 (9/9 celle OOS negative) dice che
**l'ipotesi di partenza sana e' "il filtro non aiuta"**.

### 5B. Le proposte di codice, in ordine di resa su costo

```
PROPOSTA 1   Dare al filtro un file che funziona (buco B1)
DOVE         nessun codice. File dati + convertitore, gia' fatti:
             tools/converti_calendario_news.py
             biblioteca/dati/CALENDARIO_FF_High_2010-2023_UTC.csv (8.313 righe)
FONTE        §1C (dataset MIT, fuso misurato) + §1D (perche' i 2 CSV di casa non bastano)
COSTO        ~0 (fatto). Resta: MISURARE l'offset del server BCM e rigenerare.
RISCHIO      il file e' in UTC: se lo si usa senza convertire, ogni finestra
             sbaglia di 1-2 ore. -> il round DEVE dichiarare l'offset usato.
             + canarino obbligatorio: il log deve dire "news caricate: 8313"
             E il round col filtro deve avere un numero di trade DIVERSO
             dal braccio spento. Se e' identico, il filtro non sta mordendo.
```
```
PROPOSTA 2   Rendere il filtro consapevole della VALUTA (buco B3)
DOVE         ABTG_FiboH4_Multi.mq5, InNewsBlackout() -> passargli il simbolo e
             confrontare gNewsCcy[i] con le due valute del simbolo.
             Il dato c'e' GIA' in memoria (gNewsCcy[], riga 472): oggi e' letto,
             salvato e mai usato.
COSTO        ~1 ora + 1 giro di autotest (canarino: stesso seme, il conteggio
             delle finestre deve scendere da 452/anno a 366/282/334)
RISCHIO      basso. Il rischio VERO e' l'opposto: SENZA questo, un dato NZD
             ferma EURUSD -> il round misura un filtro piu' severo di quello
             che il corso descrive, e lo boccia per il motivo sbagliato.
NOTA         input nuovo suggerito: InpNewsPerCurrency (default false = com'e' oggi)
```
```
PROPOSTA 3   Cancellare i pendenti prima del dato (buco B2)  <- la CONFORMITA'
DOVE         ABTG_FiboH4_Multi.mq5: chiamare CancelPendings(sym) - la funzione
             ESISTE GIA' (riga 440) - quando si entra in finestra news.
             Il gancio c'e' gia': CutoffCheck() la usa allo stesso modo.
FONTE        corso lez. 18 ("gli ordini vanno tolti") + regola FTMO/FundedNext
             (§3: l'esecuzione di un PENDENTE dentro la finestra conta come
             violazione / decurtazione)
COSTO        ~1-2 ore + 1 round. Va chiamata su OnTick, non su OnNewBar:
             una barra H4 e' lunga 240 minuti, una finestra ne dura 30.
RISCHIO      🔴 CAMBIA L'EDGE, non e' una protezione neutra: toglie ordini che
             sarebbero stati eseguiti. -> braccio SEPARATO nel round, mai
             mescolato alla Proposta 1.
           🔴 secondo rischio: cancella e NON ripristina (il prodotto n.3
             ripristina). Con finestre a 15 min e cutoff alle 17:45 server, una
             news mattutina puo' azzerare la giornata di quel simbolo.
             -> [INCERTO] quanto costi: si misura, non si stima.
```
```
PROPOSTA 4   Deroga a >=100 pip (buco B5)
DOVE         input nuovo InpNewsDerogaPips (0 = spenta), confronto fra prezzo
             corrente e livello EZ prima di applicare il blackout
FONTE        SOLO il corso, lez. 18. Zero riscontri su 8 fonti esterne (§2B)
COSTO        ~2 ore + 1 round dedicato
RISCHIO      l'EA pretende gia' InpMinDistPips=50: la deroga a 100 pip
             potrebbe disattivare il filtro in buona parte dei setup
             -> [INFERITO], da misurare. ULTIMA in ordine di priorita':
             e' l'unica proposta che non ha NESSUN riscontro esterno.
```
```
NON PROPONGO  chiusura delle posizioni aperte in finestra (B4)
PERCHE'       PIANO_PROP D2 la classifica gia' "modifica di strategia travestita
              da protezione". E nessuna prop censita vieta di TENERE aperto
              (solo FundingPips Zero) -> zero guadagno di conformita',
              costo di edge certo. Resta agli atti, non in lista.
```

### 5C. ⚠️ Le tre cose da dichiarare in qualunque round che accenda il filtro

1. **L'offset di fuso usato**, e che il file sorgente e' UTC. (B6 + conflitto
   M15a ancora aperto.)
2. **Che l'etichetta "High" di Forex Factory non e' stabile** fra 2010 e 2023
   (1.167 → 546 → 908 eventi/anno): il filtro **non e' lo stesso filtro** ai
   due estremi del campione (§1C).
3. **Il canarino anti-M17**: se il braccio filtrato e quello spento producono
   **lo stesso numero di operazioni**, il filtro **non sta mordendo** e il
   round va buttato, non interpretato.

---

## 6. 🙈 COSA NON HO POTUTO VEDERE — dichiarato, non riempito

- 🛑 **Nessuna pagina ufficiale di prop** (§0). **Tutto il §3 e'
  `[LETTO-VIA-SEARCH]`.** In particolare **non ho potuto leggere la LISTA degli
  eventi e degli strumenti** che FTMO dichiara "targeted": senza quella lista,
  "±2 minuti su high impact" **non e' implementabile alla lettera** — noi
  filtreremmo su Forex Factory, loro su una loro lista. **[INCERTO], e conta.**
- 🛑 **Forex Factory diretto: 403.** Non ho potuto leggere i **ToS**: se il
  dataset MIT sia ridistribuibile secondo FF **[INCERTO]**. Uso interno da
  ricerca, non redistribuzione.
- 🛑 **`EPSOFT/dataset-forexfactory`**: colonne, fuso e formato **non
  verificati** (README non li elenca). Copre 2007-2009 che alla fonte n.1
  mancano, ma e' **GPL-3.0**.
- 🛑 **api.github.com 403**: non ho **date di ultimo commit** ne' numero di
  commit per i repo citati. Licenze e stelle vengono dalla pagina HTML.
- ❓ **L'offset reale del server BCM non l'ho misurato** (nessun accesso al
  terminale). E `PIANO_PROP` M15a segnala un **conflitto aperto** corso-vs-repo
  sullo stesso broker. **Va misurato prima del round.**
- ❓ **Se BCM osservi la DST**: **[INCERTO]**. Decide se un solo
  `InpNewsShiftMinutes` puo' bastare (B6).
- ❓ **Il campo "Non-economic"** di Forex Factory (1.383 righe nel solo 2012):
  festivita' e simili. Escluso dal file generato perche' non e' `High`, ma
  **le festivita' bancarie sono informazione di rischio** (mercati sottili) e
  qui non le stiamo usando. Pista, non proposta.

---

## 7. 📦 ARTEFATTI PRODOTTI DA QUESTA CACCIA

| file | cosa e' |
|---|---|
| `tools/converti_calendario_news.py` | convertitore FF → formato `LoadNews()`; sottrae le 8 ore **misurate**, filtra impatto/valute, opzione `--shift-min` per generare direttamente in ora server |
| `backtest_pipeline/caccia_strategie/biblioteca/dati/CALENDARIO_FF_High_2010-2023_UTC.csv` | **8.313 righe**, 2010-01-03 → 2023-12-22, **UTC**, solo `High`, valute `USD,EUR,GBP,JPY`, formato `Data Ora;Impatto;Valuta;Titolo`, **ASCII puro** (0 byte non-ASCII) |
| questo dossier | — |

**Controprove eseguite sul file generato:**
- NFP → `13:30` UTC d'inverno, `12:30` UTC d'estate ✅
- `ImpactToInt("High")` → `3` ✅ (contro lo `0` che darebbero i CSV di biblioteca)
- 0 caratteri non-ASCII ✅

> ⚠️ **Il CSV e' in UTC, non in ora server.** Prima di darlo a un round va
> rigenerato con l'offset BCM misurato, oppure il round deve dichiarare
> l'offset applicato. **Non e' pronto all'uso alla cieca — di proposito.**
