# 📌 PROMEMORIA — far entrare CLAUDE direttamente sui siti delle fonti

_Chiesto da Claudio il 16/08/2026: **"dopo dobbiamo fare il discorso che tu
puoi entrare a trovare sui vari siti che mi hai elencato"**. Questo file
esiste per non perderlo._

**Non e' urgente e non blocca niente**: la caccia funziona lo stesso (Claudio
scarica a mano, e il mirror del Code Base su GitHub ce l'abbiamo offline).
Ma e' la cosa che moltiplica la resa per dieci.

---

## 1. 🧱 IL PROBLEMA, misurato

L'ambiente in cui giro ha una **allowlist di domini**. Le fonti utili
rispondono cosi' (misurato al proxy il 16/08, non ipotizzato):

```
"kind": "connect_rejected",
"detail": "gateway answered 403 to CONNECT (policy denial)",
"host": "mql5.com:443"
```

| 🟢 raggiungibili oggi | 🔴 bloccati (403 al CONNECT) |
|---|---|
| `github.com` · `api.github.com` · `raw.githubusercontent.com` | **`mql5.com`** ← la fonte piu' ricca |
| `gitlab.com` | **`arxiv.org`** · **`papers.ssrn.com`** |
| `bitbucket.org` | **`tradingview.com`** · **`forexfactory.com`** |
| | **`quantpedia.com`** · **`quantconnect.com`** · `codeberg.org` |

⚠️ **Il blocco sta PRIMA del login.** `CONNECT` e' il momento in cui si apre
la connessione: viene rifiutata li', prima di qualunque pagina. **Le
credenziali di Claudio non servirebbero a niente** — e non vanno date
comunque: l'account MQL5 e' anche profilo, MetaQuotes ID, acquisti e VPS,
mentre il materiale che ci serve e' **pubblico e gratuito**.

## 2. ✅ COSA FARE — la procedura esatta

Tutto dentro **claude.ai/code**: non c'e' una pagina impostazioni ne' un URL
diretto.

1. Cliccare l'**icona a nuvola** nella riga **sopra la casella del
   messaggio**. ⚠️ **L'ambiente di Claudio NON si chiama `Default`: si chiama
   `Claudio`** (`env_01Q6nDunTuex3xmeRPbtgzQs`, descrizione _"Claudio -
   trusted network access"_). E' l'unico che ha. Verificato il 16/08 con
   `list_environments`: cercare "Default" e' tempo perso.
2. Nella sezione **Cloud** del menu, passare il mouse sulla riga
   **`Claudio`** → compare a destra l'**icona ingranaggio**. Cliccarla.
   _(Oppure **Add cloud environment** per crearne uno nuovo e lasciare
   quello attuale intatto.)_
3. Alla voce **Network access**: da `Trusted` a **`Custom`**.
4. Nel campo **Allowed domains**, una riga per dominio:

```
mql5.com
*.mql5.com
tradingview.com
*.tradingview.com
arxiv.org
*.arxiv.org
ssrn.com
*.ssrn.com
forexfactory.com
*.forexfactory.com
quantpedia.com
*.quantpedia.com
quantconnect.com
*.quantconnect.com
```

5. 🔴 **SPUNTARE "Also include default list of common package managers".**
   Senza, restano SOLO i domini della lista e **si perde GitHub**, cioe' la
   fonte da cui stiamo cacciando adesso. Sarebbe uno scambio pessimo.

📝 **Perche' due righe per dominio:** `*.mql5.com` copre i sottodomini
(`www.mql5.com`) ma **non** il dominio nudo. Metterle entrambe costa niente.

🔒 **`Custom`, non `Full`.** Si aprono le sei porte che servono, non tutte.

## 3. ⚠️ DUE COSE DA SAPERE PRIMA DI FARLO

1. **Serve una sessione NUOVA.** L'ambiente si legge quando la sessione parte:
   la chat in corso continuera' a vedere i domini bloccati. Dopo la modifica
   si apre una sessione nuova e le si dice _"leggi HANDOFF.md e riprendi la
   caccia"_ — tutto il lavoro e' su GitHub, non si perde niente.
2. **Su TradingView aspettarsi meno di quanto sembra**: le pagine sono
   costruite in JavaScript e il Pine Script spesso non arriva nell'HTML
   grezzo. **MQL5 Code Base e arXiv invece sono pagine normali.**

## 4. 🎯 COSA CAMBIA DAVVERO, in numeri

| oggi | dopo lo sblocco |
|---|---|
| Code Base solo via **mirror GitHub** (1.185 sorgenti, fermo al commit del mirror) | Code Base **vivo**, con download, date, licenze e valutazioni |
| licenze e popolarita' dei candidati dal mirror: **[INCERTO]** | **[VERIFICATO]** |
| **zero letteratura**: nessuna delle tesi promosse ha un paper dietro | arXiv/SSRN → la fonte che consegna **la tesi prima del codice**, cioe' il primo requisito di ogni nostro round |
| Claudio fa da postino a ogni giro | la caccia gira da sola |

> ### La riga che riassume
> **Oggi il collo di bottiglia non e' il metodo ne' il materiale: e' un
> elenco di domini.** Il setaccio funziona (su 22 file letti nel sorgente,
> 1 promosso e 12 scartati con motivo). Serve solo dargli piu' roba da
> setacciare, senza passare da Claudio ogni volta.

---

## 🔓 AGGIORNAMENTO 28/08/2026 — DUE CANALI, misurati nella caccia intraday indici

_Fonte: `caccia_strategie/CACCIA_INTRADAY_INDICI_2026-08-28.md` §1-bis e §1-ter._

### A. TRADINGVIEW: usare la RICERCA TESTUALE, non i tag

La strada a tag (25/08) e la sua correzione (26/08) restano valide ma sono
lente. **Una sola richiesta fa tutto:**

```
https://www.tradingview.com/pubscripts-suggest-json/?search=<query+urlencoded>
```

JSON con, per ogni risultato:

| campo | cosa da' |
|---|---|
| `scriptIdPart` | **`PUB;<hash 32 cifre>` GIA' PRONTO** — salta il passo "apri la pagina script per estrarre l'hash" |
| `extra.kind` | `"strategy"` vs `"study"` — separa le strategie dagli indicatori |
| `access` | **`1` = sorgente leggibile · `2`/`3` = protetto** — si sa PRIMA di sprecare una richiesta |
| `agreeCount` | i like (l'unica popolarita' che TradingView espone) |
| `author.username` | l'attribuzione |

Poi il sorgente come sempre:
`https://pine-facade.tradingview.com/pine-facade/get/PUB;<hash>/last` → `source`.

**Verificato il 28/08 su 20 tentativi, nessuna eccezione:** con `access=2` il
pine-facade risponde `{"code":401,"message":"User is not allowed to see source
code of pine"}`; con `access=1` restituisce il Pine completo.

⚠️ **Limiti misurati:** ~50 risultati per query, e **molte query naturali
rendono ZERO** (`"DAX intraday"`, `"US30 intraday"`, `"afternoon reversal"`,
`"flat at close"`, `"opening range fade"`). E' un motore di **titoli**, non di
contenuti: servono **tante query corte**, non poche query precise.
Anche i **tag** hanno buchi: `previousdayhighlow`, `timeofday`, `powerhour`,
`lunch`, `indexfutures`, `poc`, `tpo`, `dailyrange`, `firsthour` → **0
strategie ciascuno**.

### B. GITHUB NON E' BLOCCATO: E' BLOCCATO `curl`

Sei dossier (16, 19, 21, 22, 23, 25, 26/08) dichiarano GitHub **NULLO**. La
diagnosi era sul dominio; il problema e' sul **trasporto**.

| via | esito 28/08/2026 |
|---|---|
| `curl` su `api.github.com/search/...` | 🔴 **403** |
| `curl` su `github.com/search?q=...` | 🔴 **403** |
| **strumento `WebFetch` su `github.com/topics/...`** | 🟢 **200, pagina letta** (20 repo con nome, owner, stelle, descrizione) |
| `curl` su `raw.githubusercontent.com/<url noto>` | 🟢 **200** |
| strumento `WebSearch` | 🟢 restituisce URL GitHub veri, usabili come punto di partenza |

**Ricetta:** `WebSearch` per trovare il repo → `WebFetch` per leggere la
pagina → `raw.githubusercontent.com` (via `curl`) per scaricare i file.

🟠 **Avvertenza dalla prima prova:** la pagina `topics/expert-advisor` e'
quasi tutta **spam SEO** (repo `C#`/`HTML` con nomi da vetrina, 0-2 stelle su
account nuovi, piu' tre repo con 115-117 stelle dal profilo "stelle
comprate"). **Non partire dai topic: partire da una ricerca mirata.**

### C. 🔧 IL PATTERN `PUB;` DEL 25/08 E' SBAGLIATO — l'identificatore NON e' esadecimale

_Aggiunto il 28/08 dalla caccia intraday FOREX+ORO
(`CACCIA_INTRADAY_FOREX_ORO_2026-08-28.md` §1-bis)._

La procedura del 25/08 (§ piu' sotto) dice di cercare nell'HTML
**`PUB;<32 cifre esadecimali>`**. **E' falso**, e ha gia' prodotto un buco a
verbale: il 25/08 lo script `9morbD5t-15-Minute-Gold-Trend-Following-Strategy`
e' finito nel dossier come **"NON VALUTATO — la pagina non contiene
l'identificatore"**, ed era in pieno bersaglio (oro, 15 minuti).

Misurato oggi sulla stessa pagina: `PUB;v0d1rwLHjXobyApD15BLp3iWRG8DxwkJ` —
**32 caratteri ALFANUMERICI MISTI**. Il pattern giusto e':

```
PUB;([0-9A-Za-z]{32})
```

**Confermato anche dal canale §A:** nel JSON di `pubscripts-suggest-json` il
campo `scriptIdPart` e' a volte esadecimale (`PUB;7150ebfb...`) e a volte
alfanumerico (`PUB;sYGbx3r01uJ8uIveIa5yqtaEPlA3dfeA`). **Sono entrambi validi.**

> ⚠️ **La lezione, e vale oltre TradingView:** un pattern sbagliato non
> produce un errore, produce **un candidato "non letto"** — che nel dossier
> sembra un buco dichiarato e invece era un candidato perso per un refuso di
> regex. **Su 7 script provati il 25/08, 1 era un falso-vuoto: il 14%.**
> Col pattern corretto quel candidato si e' aperto ed e' risultato **8 righe
> di Pine v3 senza stop**: scarto, ma con un verdetto invece che con un
> punto interrogativo.

### D. 🚨 "ZERO RISULTATI SU UN TAG" NON E' UNA MISURA DI ASSENZA

_Stessa caccia, §6.4 — ed e' una smentita a un errore mio._

I tag TradingView `killzone`, `timeofday`, `hourofday`, `overlap`,
`asiansession` rendono **zero strategie**. Da li' avevo concluso _"l'ora del
giorno come motore su TradingView non esiste"_. **La ricerca testuale del §A
sulla query `time of day` ne rende TRE**, tutte col sorgente leggibile.

➡️ **Regola operativa: un tag vuoto va verificato con
`pubscripts-suggest-json` PRIMA di scriverne una conclusione.** Costa una
richiesta; scriverne una conclusione sbagliata costa un dossier.

### E. 🔓 QUANTPEDIA: la sitemap rende 1.118 slug, non 82 — e la nota "non ricontrollarla" va CANCELLATA

_Stessa caccia, §1-ter._

Il dossier del 25/08 aveva scritto: _"la sezione gratuita di Quantpedia, per
un mandato intraday, non serve. **Non ricontrollarla.**"_ Quella nota nasceva
dagli **82 slug** che rende la pagina `/strategies`. **La sitemap ne rende
1.118:**

```
https://quantpedia.com/sitemap.xml                              <- indice
https://quantpedia.com/wp-sitemap-posts-pod_cpt_strategy-1.xml  -> 1.118 slug strategia
https://quantpedia.com/wp-sitemap-posts-post-1.xml              -> 1.155 post di blog (GRATUITI)
```

E fra i 1.118 ci sono, in tema intraday FX/oro:
`intraday-currency-seasonality` · `intraday-reversal-in-currency-markets` ·
`overnight-intraday-weekly-reversal-in-currency-futures` ·
`price-overreactions-in-the-forex` · `exponential-fx-mean-reversion-strategy` ·
`payroll-news-timing-in-fx` · `seasonality-in-gold` · `gold-market-timing`.

🔴 **Vittoria a meta', e va detta:** quelle pagine sono **PREMIUM** — aperte,
restituiscono la home page (Quantpedia dichiara _"~70 free strategies"_ contro
_"900+"_). **Dalla sitemap si legge il NOME dell'effetto, non le regole.**
I **post di blog** invece sono gratuiti e si leggono.

> 📌 **Forma corretta da usare d'ora in poi:** _"la sitemap di Quantpedia e' un
> INDICE DI EFFETTI da usare come punto di partenza bibliografico; le regole
> sono a pagamento e non si comprano."_ E' esattamente cosi' che il 28/08 e'
> nato il candidato P1 della caccia forex.

### F. 📕 `SETACCIO_MANUALE.md` NON e' l'indice completo degli scarti

Il grep degli id Code Base gia' setacciati su `caccia_strategie/*.md` ne rende
**53**, ma i file `report/SWEEP_MECCANISMI_*.md` ne contengono **altri che non
sono indicizzati li'**. Il 28/08 ho riletto e riscaricato `19500` e `17474`,
gia' scartati il 22/08 (§D5 di `SWEEP_MECCANISMI_LIBERI_2026-08-22.md`).
**Costo: ~15 minuti.**

➡️ **Il prossimo cacciatore deve grep-are `report/SWEEP_*` INSIEME a
`caccia_strategie/*`**, oppure qualcuno deve consolidare tutti gli id in un
unico file.

## AGGIORNAMENTO 19/08/2026 sera (misurato dalla caccia Londra)
- **MQL5.com: SBLOCCATO (HTTP 200)** — e soprattutto
  `https://www.mql5.com/en/code/download/<id>` restituisce lo ZIP col
  sorgente `.mq5`: **gli agenti possono leggere i sorgenti del Code Base da
  soli**, senza download manuale di Claudio. Controllo positivo su id 68951.
- Restano bloccati (dichiarati, non ipotizzati): SSRN 403, TradingView
  pagine script 404, GitHub 403 (web+API), Forex Factory 403, Quantpedia,
  RePEc egress-blocked.

---

## 🔓 AGGIORNAMENTO 25/08/2026 — TRADINGVIEW SI LEGGE, SORGENTE COMPRESO

_Misurato durante la caccia M5/M15 indici (`CACCIA_M5M15_INDICI_2026-08-25.md`)._

Per **cinque dossier di fila** (16/08, 19/08, 21/08, 22/08, 23/08)
TradingView è stata dichiarata **NULLA**, con due diagnosi diverse: prima
`404 Publication not found` sulle pagine script, poi `200 ma zero link
/script/ nell'HTML`. **Oggi la fonte risponde, e il Pine si scarica.**

| cosa | stato 25/08/2026 |
|---|---|
| pagina tag `tradingview.com/scripts/<tag>/` | 🟢 **200**, e l'HTML contiene **link + titoli** degli script |
| paginazione `/scripts/<tag>/page-N/` | 🟢 funziona |
| filtro `?script_type=strategies` | 🟢 funziona (separa le strategie backtestabili dagli indicatori) |
| pagina del singolo script | 🟢 200, `<title>` con nome + autore + tipo — **ma il Pine NON è nell'HTML** |
| **il sorgente Pine** | 🟢 **si scarica** — vedi sotto |

### La procedura, in tre passi

1. **Elenco**: `https://www.tradingview.com/scripts/<tag>/page-N/?script_type=strategies`
   → estrarre gli anchor con `data-qa-id="ui-lib-card-link-title"`
   (danno slug **e** titolo).
2. **Hash**: `https://www.tradingview.com/script/<slug>/`
   → cercare nell'HTML `PUB;<32 cifre esadecimali>`.
3. **Sorgente**: `https://pine-facade.tradingview.com/pine-facade/get/PUB;<hash>/last`
   → JSON con `source` (**il Pine completo**), `scriptName`, `created`,
   `scriptAccess` (`open_no_auth` = open source).

⚠️ **La trappola in cui sono caduto per primo:** usare lo *slug corto*
(`PUB;OkbSIHvu`) restituisce `{"code":404,"message":"Script is not found."}`.
**Serve l'hash a 32 cifre**, quello dentro l'HTML della pagina.

⏱️ Ritmo usato: **~1,2 s fra le richieste**. Nessun 429, nessun 503.

### E il resto della mappa, rimisurato lo stesso giorno

| fonte | 25/08/2026 |
|---|---|
| `mql5.com` (Code Base + download ZIP) | 🟢 **200** |
| `export.arxiv.org` (API) | 🟢 **200** — ⚠️ **solo `https://`**: `http://` risponde 301 e 0 entry |
| `quantpedia.com` (con `-L` + User-Agent) | 🟢 **200** sulle pagine strategia |
| `tradingview.com` + `pine-facade.tradingview.com` | 🟢 **200** ← **NOVITÀ** |
| `github.com` · `api.github.com` (ricerca) | 🔴 **403** — quinta caccia di fila |
| `papers.ssrn.com` | 🔴 **403** (Cloudflare) |
| `forexfactory.com` | 🔴 **403** |
| `alexandria.unisg.ch` · `researchgate.net` · `cxoadvisory.com` · `substack.com` · `quantitativo.com` | 🔴 **CONNECT tunnel 403** = egress bloccato dal proxy. Sono i mirror dei paper che SSRN non ci lascia leggere: **il buco della letteratura resta aperto** |

> 🎯 **Conseguenza operativa:** con il Code Base ormai esaurito sugli indici
> intraday (`vwap` → 0 titoli, `dax` → 0, `retest` → 1, misurato tre volte con
> filtri diversi), **TradingView diventa la fonte principale per i meccanismi
> nuovi.** Il prezzo resta quello del mandato §3D: **Pine → MQL5 non è un
> porting, è una riscrittura**, e i numeri mostrati dagli autori valgono zero.

---

## 📅 31/08/2026 (sera) — CACCIA FREQUENZA: due correzioni tecniche e un buco nuovo

Misurato oggi, non ipotizzato. Dossier:
`caccia_strategie/CACCIA_FREQUENZA_2026-08-31.md`.

### 1. 🔧 `pine-facade`: l'endpoint giusto e' `/get/`, NON `/translate/`

| endpoint | cosa restituisce davvero |
|---|---|
| `pine-facade.tradingview.com/pine-facade/translate/<sid>/last` | 🔴 campi **`IL`** e **`ilTemplate`**, che sono **base64 CIFRATO** (bytecode compilato), **non** il Pine. Utile solo per `metaInfo` |
| `pine-facade.tradingview.com/pine-facade/get/<sid>/last` | 🟢 **campo `source` = il Pine IN CHIARO**, piu' `scriptName`, `scriptAccess`, `created`, `lastVersionMaj` |

Verificato oggi su **4 hash**. Il `;` di `PUB;` va **url-encodato** in `%3B`.
Le sequenze `\r\n` vanno srotolate. **Da usare cosi' d'ora in poi.**

### 2. 🔴 La ricerca per parola chiave del Code Base NON ESISTE

`mql5.com/en/code/mt5/experts?keyword=<parola>` **ignora il parametro**:
provato con `intraday`, `session`, `pullback` → **restituisce le stesse
identiche 15 righe** della pagina 1 non filtrata. 👉 Il censimento del Code
Base si fa **solo sfogliando `/page2`, `/page3`, ...**, e quindi si vede
**solo cio' che e' recente per data**. Non scrivere piu' nei dossier "ho
cercato X sul Code Base": non e' possibile da qui.

### 3. 🕳️ IL BUCO NUOVO E IL PIU' GRAVE: **nessuna fonte di DATI di prezzo**

Servivano per **misurare** la frequenza di un candidato (il pavimento di
Claudio: >= 1 trade/giorno). Provate tre fonti indipendenti, **tutte e tre
murate dal proxy di egress** (`connect_rejected`, policy):

| host | esito 31/08 |
|---|---|
| `query1.finance.yahoo.com` (chart API, 5m/60d) | 🔴 **403 al CONNECT** |
| `stooq.com` (CSV) | 🔴 **403 al CONNECT** |
| `datafeed.dukascopy.com` (`.bi5`) | 🔴 **403 al CONNECT** — ⚠️ **e questo blocca anche l'IMPORT DUKASCOPY** preparato il 31/08 mattina: gli strumenti ci sono, il canale da qui no |

> 🎯 **Conseguenza:** da questo ambiente **nessun agente puo' MISURARE una
> frequenza, una distribuzione di take o uno spread.** Puo' solo leggere
> sorgenti e paper, e **dichiarare i numeri come [DA MISURARE]**. Il numero lo
> fa il PC di Claudio, sempre. E' il motivo per cui il PASSO 0 dei candidati
> di frequenza deve essere una **SONDA DI CONTEGGIO**, non una griglia.

### 4. Il resto della mappa, rimisurato oggi

| fonte | 31/08/2026 |
|---|---|
| `mql5.com` (pagine + download ZIP + articles) | 🟢 **200** |
| `export.arxiv.org` (API) + `arxiv.org/pdf` | 🟢 **200** (solo `https`) |
| `tradingview.com` + `pine-facade` | 🟢 **200** |
| `raw.githubusercontent.com` | 🟢 **200** |
| `api.github.com` (ricerca) | 🔴 **403** — ottava di fila |
| `papers.ssrn.com` | 🔴 **403** — ottava di fila |
| `forexfactory.com` | 🔴 **403** — ottava di fila |

### 5. 🏷️ TradingView: un tag nuovo da segnare come quasi-vuoto
`sessions` rende **2 sole strategie**, contro le **24** (tetto di pagina) di
`scalping`, `intraday`, `daytrading`, `futures`, `nasdaq`, `trendfollowing`,
`volatility`, `meanreversion`. `pullback` ne rende **17**.
Da affiancare ai buchi gia' noti (`falsebreakout`, `choch`, `rangebound`,
`previousdayhighlow`, `timeofday`, `powerhour`, `dailyrange`, `firsthour`).

## 📅 31/08/2026 (notte) — SECONDA BATTUTA: una fonte NUOVA, una correzione, due conferme

Misurato stanotte, non ipotizzato. Dossier:
`caccia_strategie/CACCIA_FREQUENZA2_2026-08-31.md`.

### 1. 🆕 QUANTCONNECT E' RAGGIUNGIBILE — e sei dossier dicono il contrario

Controllo positivo su bersaglio noto:
`quantconnect.com/learning/articles/investment-strategy-library/intraday-dynamic-pairs-trading-using-correlation-and-cointegration-approach`
→ **HTTP 200, 264.951 byte, `<title>` corretto**. L'indice
`/learning/articles/investment-strategy-library` si legge con `WebFetch`, e le
pagine strategia contengono **regole in chiaro + frammenti di codice Python**.

🔴 **MA il verdetto d'uso e' negativo, e va scritto per non riaprirla ogni
volta:** la libreria QC e' fatta di strategie **di PORTAFOGLIO a ribilancio
giornaliero/mensile**. Le poche "intraday" sono ETF/azionario US con **1 trade
al giorno** e **senza stop loss**. **Per un mandato di frequenza intraday su
CFD non e' una fonte.** Utile solo per un mandato di **allocazione**.

### 2. 🔧 LO SLUG PUBBLICO DI TRADINGVIEW E' `imageUrl`, NON `scriptIdPart`

Misurato sul promosso della battuta:

| URL provato | esito |
|---|---|
| `tradingview.com/script/yMINlAO3-...` (primi 8 di `scriptIdPart`) | 🔴 **404** |
| `tradingview.com/script/E6yr9CoN/` (campo **`imageUrl`** del JSON `pubscripts-suggest-json`) | 🟢 **200**, titolo corretto |

> ⚠️ Stessa lezione del pattern `PUB;` sbagliato del 25/08: **un identificatore
> sbagliato non da' un errore, da' un "candidato non letto"** — e nel dossier
> sembra un buco dichiarato invece che un refuso. **Per citare la pagina
> pubblica di uno script si usa `imageUrl`.**

### 3. 📕 IL CODE BASE HA SMESSO DI PRODURRE MOTORI (misurato sui 20 id piu' recenti)

Interrogati uno per uno da **76669 a 75473**: **15 attrezzi** (pannelli,
calcolatori, gestori, logger — fra cui **sei utility `Quantora` di fila**),
**3 recovery/basket**, 1 gia' bocciato, 1 motore generico. **Zero EA di
sessione, zero forex intraday, zero uscite a tempo.**
➡️ **Regola d'uso nuova: il Code Base si apre per gli ATTREZZI, non per i
motori intraday.** (E con `?keyword=` rotto si vede comunque solo il recente
per data.)

### 4. 🔴 QUANTPEDIA: PREMIUM RICONFERMATO — 4 slug reali, 4 volte la home page

`cross-market-intraday-time-series-momentum`,
`sp500-futures-return-during-the-eu-open-period`,
`intraday-currency-seasonality`,
`jump-only-momentum-and-reversal-in-currency-markets`:
**tutte HTTP 200 con 302.356 byte IDENTICI** = la home page.
➡️ Forma definitiva: *"Quantpedia si usa per SAPERE CHE UN EFFETTO ESISTE e
risalire al paper. Non per le regole. E su tre mandati intraday non ha mai
prodotto un candidato."*

### 5. 🟠 GITHUB: il topic `mql5` risponde ma e' SPAM SEO (conferma del 28/08)

`github.com/topics/mql5?o=desc&s=updated` via `WebFetch` → **200**, ma i primi
repo sono `NulveKN/*` e `ZrakD/*`: **0-3 stelle, linguaggio dichiarato `C#` su
codice MQL5, tutti aggiornati lo stesso giorno**. **Non si parte dai topic.**

### 6. Il resto della mappa, rimisurato stanotte

| fonte | 31/08/2026 notte |
|---|---|
| `mql5.com` (pagine + download ZIP + articles) | 🟢 **200** |
| `export.arxiv.org` (API, solo `https`) | 🟢 **200** |
| `tradingview.com` + `pine-facade /get/` | 🟢 **200** |
| `raw.githubusercontent.com` | 🟢 **200** |
| 🆕 `quantconnect.com` | 🟢 **200** (ma vedi §1) |
| `quantpedia.com` sitemap | 🟢 200 · pagine strategia 🔴 premium |
| `api.github.com` (ricerca) | 🔴 **403 — NONA di fila** |
| `papers.ssrn.com` | 🔴 **403 — NONA di fila** |
| `forexfactory.com` | 🔴 **403 — NONA di fila** |
| `query1.finance.yahoo.com` · `stooq.com` · `datafeed.dukascopy.com` | 🔴 **403 al CONNECT, tutti e tre** — **nessun agente puo' MISURARE una frequenza da qui** |

## 📅 02/09/2026 — QUARTA BATTUTA (FRONTE A): una diagnosi definitiva su FF e due misure di saturazione

Misurato oggi, non ipotizzato. Dossier:
`caccia_strategie/CACCIA_FREQUENZA4_GH_TV_FF_2026-09-02.md`.

### 1. 🔴 FOREX FACTORY E' MURATA AL DOMINIO, **NON al trasporto** — e questo chiude la questione

Il §B del 28/08 contiene la lezione preziosa _"GitHub non e' bloccato: e'
bloccato `curl`"_: li' il blocco stava sul **trasporto**, e `WebFetch` lo
aggirava. **Le nove dichiarazioni precedenti di "FF 403" erano TUTTE su
`curl`.** Oggi, prima misura indipendente dal trasporto sullo stesso URL
(`forexfactory.com/forum/71-trading-systems`):

| trasporto | esito 02/09 |
|---|---|
| `curl` | 🔴 **403** (5.469 byte di pagina di blocco) |
| **`WebFetch`** | 🔴 **403 Forbidden** |

> 📌 **Da scrivere una volta e non riprovare:** _"Forex Factory NON e' il caso
> GitHub. E' murata al dominio: `curl` e `WebFetch` rendono entrambi 403. Un
> mandato che assegna 'FF Trading Systems' non e' eseguibile da qui, e va
> dichiarato come buco — non compensato con la memoria."_
>
> ⚠️ **Il costo, che va nominato:** i thread storici di FF sono l'unico posto
> dove si legge **come una strategia e' INVECCHIATA**. Quell'informazione non
> ha sostituti fra le fonti vive.

### 2. 📉 TRADINGVIEW: la saturazione ora e' un numero — **28 query su 68 rendono ZERO strategie**

68 query in 7 ondate su angoli mai battuti. **Ventotto rendono zero
strategie** (rendono indicatori, o niente):

`cointegration` · `hurst exponent` · `kalman filter strategy` ·
`market profile strategy` · `close after n bars` · `intraday seasonality` ·
`hour of day strategy` · `multiple trades per day` · `15 min strategy forex` ·
`gbpusd 15 min` · `intraday range reversion` · `asian range fade` ·
`news spike fade` · `volatility contraction` · `standard deviation channel` ·
`half life` · `lead lag` · `spread trading` · `index divergence` (46 risultati,
**0 strategie**) · `es nq spread` · `beta neutral` ·
`convergence divergence pairs` · `new york session strategy` ·
`open range fade` · `vwap deviation strategy` · `quantile` · `tick imbalance` ·
`cumulative delta strategy`.

➡️ **Regola d'uso aggiornata:** `pubscripts-suggest-json` e' un motore di
**TITOLI**, e i titoli sul nostro bersaglio sono finiti. Sommato ai 207 del
01/09 e ai censimenti del 25-31/08, **la resa marginale di un'altra battuta
TradingView e' bassa e prevedibile.**

### 3. 📉 GITHUB: **quattro ricerche su cinque rendono lo STESSO pool gia' scartato**

Con `api.github.com` murata da **dieci** dossier, l'unico canale resta
`WebSearch` — che indicizza **il popolare, non il nuovo**. Cinque query nuove
e mirate (M15+sessione+uscita a tempo, mean reversion M5/M15, pairs/spread,
arbitraggio statistico, z-score fra due simboli) hanno restituito in
maggioranza `geraked` · `nyao_scalper` · `santiago-cruzlopez` ·
`sajidmahamud835` · `coler07` · `NadirAli*` · `abiodunaremu` — **tutti gia'
scartati fra il 16/08 e il 01/09.**

➡️ **GitHub come giacimento di EA MQL5 e' esaurito per noi.** Le uniche due
query che hanno prodotto qualcosa di nuovo sono state quelle su un
**meccanismo** (arbitraggio statistico / z-score fra due simboli), non su un
**formato** (EA / MQL5 / scalping). 🎯 **Si cerca il meccanismo, non il
contenitore.**

### 4. Il resto della mappa, rimisurato oggi

| fonte | 02/09/2026 |
|---|---|
| `tradingview.com` `pubscripts-suggest-json` | 🟢 **200** (30.538 byte sul bersaglio noto, identico al 01/09) |
| `pine-facade` `/get/` | 🟢 **200**, `source` in chiaro (controllo positivo su hash reale) |
| `raw.githubusercontent.com` | 🟢 **200** |
| GitHub `WebSearch` + `WebFetch` su pagina repo | 🟢 **200** |
| `forexfactory.com` | 🔴 **403 su DUE trasporti** — vedi §1 |
| `api.github.com` (ricerca) | 🔴 403 — **DECIMA di fila**, non riprovata |
| `papers.ssrn.com` | 🔴 403 — decima di fila, non riprovata |
| `query1.finance.yahoo.com` · `stooq.com` · `datafeed.dukascopy.com` | 🔴 non riprovati (murati tre volte) — **quarta battuta di fila senza poter MISURARE una frequenza** |
