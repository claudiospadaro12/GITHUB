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
