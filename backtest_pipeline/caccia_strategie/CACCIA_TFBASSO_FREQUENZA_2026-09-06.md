# 🏹 CACCIA NOTTURNA — **TF BASSI CHE FANNO OPERAZIONI** — 06/09/2026

**Mandato (Claudio, notte del 06/09, testuale):**
_"EA di qualsiasi tipo ma con TF bassi che fanno operazioni. Dobbiamo farcela.
Da cercare ovunque."_

**Perimetro assegnato:** la **FREQUENZA a TF basso** (M1 / M5 / M15). Non il lato
short (altro agente), non le configurazioni prop (altro agente). Criterio che
comanda: **frequenza reale ≥ ~1,00 operazione al giorno**.

**Non toccati, come da coordinamento:** `backtest_pipeline/righe/RIGA_LOG_SEDIE_MUTE.ps1`,
`mql5/Experts/ABTG_SondaGapCash.mq5`, `backtest_pipeline/righe/RIGA_SONDA_OROLOGIO*`.

---

## ⚡ IL RISULTATO IN CINQUE RIGHE

> **10 canali passati al controllo positivo (6 vivi, 2 murati, 2 a metà).
> 120 titoli Code Base incrociati con i 78+400 già setacciati → 3 id MAI
> setacciati, tutti e tre APERTI stanotte. 2 sorgenti `.mq5` scaricati e letti
> (3.638 righe). 82 slug Quantpedia enumerati. 3 sweep arXiv. 1 repo GitHub mai
> visto in casa, letto per intero.**
> 🔴 **PROMOSSI: ZERO. Nessun file prova scritto, e §11 spiega perché scriverne
> uno sarebbe stato il danno peggiore.**
>
> 🥇 **MA LA BATTUTA NON TORNA A MANI VUOTE, E IL PEZZO GROSSO È UNA PORTA
> RIAPERTA: GITHUB NON È AL BUIO — LO È SOLO `/search`.** Tre dossier di fila
> (02/09, 05/09 ×2) hanno chiuso il fronte GitHub con _"429, fronte NON
> battuto"_. Stanotte, misurato: `github.com/<owner>/<repo>/tree/...` via
> `WebFetch` risponde **200 con contenuto leggibile**, e
> `raw.githubusercontent.com` via `curl` risponde **200**. È **solo `/search`**
> (429, `Retry-After: 3600`) e **`api.github.com`** (403) a essere murati.
> 👉 **Il fronte GitHub si batte per NOME DI REPO, non per ricerca** — e
> stanotte ha già consegnato un repo mai visto in casa (§5.3).
>
> 🔬 **E IL NUMERO CHE VALE PIÙ DI TUTTI I CANDIDATI — LA FRONTIERA DEL COSTO
> (§6).** Dal cancello H8 (E ≥ 0,075R) e dagli spread **MISURATI in casa** esce
> una sola disuguaglianza, e vale per qualunque motore su qualunque TF:
> **stop ≥ 40 × spread** perché il pedaggio costi al massimo un terzo del
> cancello. Su D30EUR fa **65 punti indice**, su NASUSD **64-72**, su U30USD
> **76-80**. 🔴 **Gli stop che la casa ha misurato su M5 (20 pt) e M15 (17,4 pt)
> stanno sotto anche al pavimento DURO (21-23 pt).** Il primo timeframe la cui
> volatilità naturale entra nella banda di lavoro è **M30**.
>
> 🟢 **E LA NOTIZIA BUONA, PERCHÉ C'È E VA DETTA: il pavimento di 1,00
> operazione/giorno NON è un muro fisico.** Con 65 punti di stop e il percorso
> di seduta misurato del DAX (~510 punti su 16 barre M30), il budget di
> percorso consente **1-3 operazioni/giorno per simbolo a costo sostenibile**.
> **Non manca lo spazio: manca l'edge dentro quello spazio.** È una diagnosi
> diversa, e cambia cosa si cerca il giro dopo (§11).

---

## 0. ⚖️ I CRITERI, CONGELATI PRIMA DI APRIRE UN BROWSER

Ereditati dalle otto battute precedenti (31/08 → 05/09). Nessuno toccato dopo
aver visto un numero.

| # | criterio | soglia per QUESTA battuta |
|---|---|---|
| **C1** | **TF di lavoro M1 / M5 / M15** | dal mandato. M30 e H1 sono già stati battuti il 05/09 e il 30/08: non li rifaccio |
| **C2** | **FREQUENZA ≥ 1,00 operazione/giorno** | pavimento di casa, e la firma del 31/08 lo dice con le parole di Claudio: _"minimo 1-2 trade/giorno"_ |
| **C3** | **il §4 non si ammorbidisce** | martingala · griglia · recovery · hedge di recupero · niente SL · **SL virtuale** · repaint · look-ahead → fuori, **con la riga di codice che lo prova** |
| **C4** | **MECCANISMO nuovo** | regola della seconda caccia (19/08). **Include il cambio di TF e il cambio di tipo di barra**: portare a M5 (o su barre Renko) un motore falsificato **è** un parametro diverso |
| **C5** | **il conto del cancello di costo, PRIMA del merito** | **C2-costo**: take ≥ **3× lo spread dell'ORA**; **S0**: take/spread ≥ **2,5**; e la frontiera del §6 |
| **C6** | **due lati** | regola 25/08 |
| **C7** | **numeri d'autore** | si leggono, si etichettano, **non entrano in nessun punteggio** |
| **C8** | **giudicabilità** | un candidato **forex** vale di più a parità di bontà: pavimento dati **gen-1999** (R102) → n=150 IS + 150 OOS **raggiungibile**. Sugli indici il pavimento tick è **26/09/2024** (~503 giorni feriali) → merito **sospeso per anni** |
| **P5** | **vincolo prop HFT** | max 25% dei trade sotto 60 s |

---

## 1. 📕 COSA HO LETTO IN CASA PRIMA DI USCIRE

`CLAUDE.md` (Emendamento della Finestra · Regola dei due lati · fuso BCM),
`report/PIANO_PROP.md` §H1/H8/H11/H12, `report/METRO_PROP.md`,
`report/CENSIMENTO_FREQUENZA_FLOTTA_2026-08-22.md` (tabella A, 40 sedie),
`report/FIRME_2026-08-31.md` (FIRMA 2 = cancello H8),
`backtest_pipeline/REGISTRO_TEST.md` (dalla riga 670 alla fine, integrale),
`backtest_pipeline/prove/GAPCASH_NAS_PASSO0.txt` (modello di file prova),
e **le otto cacce che mi precedono sul medesimo problema**: M5/M15 del 25/08,
M1 del 29/08, frequenza 1-5 del 31/08→03/09, TF M5/M15/M30 del 05/09, e i tre
dossier del 06/09 (Nasdaq, DAX/Dow, oro/argento).

### ⛔ Il cimitero che il mandato mi vieta di riaprire — verificato, non a memoria

| famiglia | il numero che l'ha uccisa | dove |
|---|---|---|
| **breakout / ORB M5 d'apertura** | **CHIUSO a tick**, ~210 celle. _"Non costruire altri v2 M5"_ | REGISTRO r.40 |
| **ORB di sessione** (R45/R97) | **0 celle su 48** · PF OOS 0,84-0,91 | REGISTRO |
| **fade estremi del range** (R42) | **0/24 IS e 0/24 OOS** | REGISTRO |
| **incroci di medie / RSI+EMA (V8)** | il filtro toglie il **9-13%** degli incroci: è un incrocio EMA(5/20) | 03/09 |
| **VwapRevert** | cancello **S0 negativo su 4 celle su 4** | 03/09 |
| **sweep micro-pivot M5/M15** (L2) | 22.616 segnali, **8/8 sotto** il richiesto | 03/09 |
| **compressione ATR → espansione** (L3) | 9.723 segnali, **0/8 sopra il pavimento** | 03/09 |
| **gap intraday** | **uno al giorno per costruzione**: non può superare il pavimento | 03/09 |
| **momentum intraday di Gao** (R98) | **−0,31 punti indice per operazione** su 410, già netto | REGISTRO |
| **CRT / BreakinBox / Liquidity Sweep** (M24) | cimitero **tre volte**, DD 19,7-24,1% | REGISTRO |
| **fix valutari** (M11) | quota di rientro **0,038-0,082**: il fade non esiste | 05/09 |
| **numeri tondi / Osler** (M23) | 93.000+ segnali, delta appaiato **−1,50 / +0,90**, **5 letture su 6 negative** | 05/09 |
| **salto Lee-Mykland** (M31) | **16 celle su 16** sotto il cancello, due mercati | 05/09 |
| **lead-lag S&P → DAX M5** (M25) | frequenza **sì** (2-7/gg), **8 celle su 8 negative al netto** | 05/09 |
| **barre alternative (tick/volume/imbalance)** | 60,5 M di tick, **AUC OOS 0,42-0,55** | 01/09 |
| **reversione overnight DAX/S&P · post-news** | chiusi 04-05/09 su 686 giornate-evento | 05/09 |
| **`geraked/metatrader5`** (repo) | **CHIUSA, 11 EA su 11 misurati** | PIANO_PROP r.1276 |

📌 **La frase-bussola, ora alla sesta conferma:**
> _"La frequenza NON la compreremo scendendo di timeframe. Va presa con PIÙ
> SIMBOLI a M15-H1."_ (caccia M1, 29/08)

E la domanda che il 05/09 ha lasciato aperta, che è il vero bersaglio di stanotte:
> _"esiste UN meccanismo che produca 0,16-0,20R LORDI su M5? E se no, perché
> cerchiamo la portata SCENDENDO di timeframe invece che AGGIUNGENDO SIMBOLI?"_
> (REGISTRO r.1531)

---

## 2. 📡 CONTROLLO POSITIVO — misurato STANOTTE, prima di cercare

Ogni riga è un comando eseguito, col codice HTTP e i byte veri.

| # | canale | bersaglio noto | esito misurato | verdetto |
|---|---|---|---|---|
| 1 | **MQL5 Code Base** `/en/code/mt5/experts` | lista EA con titoli e id | **HTTP 200, 84.129 byte**, 40 id, max **77015** | 🟢 **VIVO** |
| 2 | **MQL5 Code Base** pagina 2 | idem | **HTTP 200, 85.232 byte** | 🟢 **VIVO** |
| 3 | 🆕 **GitHub — pagine repo/tree** (`WebFetch`) | `GeneralTradingSarl/expert-mt5/tree/main/...` | **200, elenco cartelle leggibile** | 🟢 **VIVO — ed è la scoperta di stanotte (§3)** |
| 4 | **raw.githubusercontent.com** (`curl`) | `FutureSharks/financial-data/README.md` | **HTTP 200, 3.610 byte** | 🟢 **VIVO** |
| 5 | **arXiv API** `export.arxiv.org` | `id_list=2605.04004` | **HTTP 200, 3.359 byte**, titolo esatto | 🟢 **VIVO** |
| 6 | **Quantpedia** `/strategies` | screener gratuito | **HTTP 200, 641.789 byte**, **82 slug** enumerati | 🟢 **VIVO** |
| 7 | **TradingView** `/scripts/` | pagina script | **HTTP 200, 613.975 byte** | 🟢 **VIVO** |
| 7b | **TradingView** `pubscripts-suggest-json` | `search=range bars` | **200, 34.412 byte, 8 risultati**; ma `order flow imbalance` / `cumulative delta` / `tick imbalance bars` / `renko strategy` → **200 con 47 e 34 byte = zero risultati** | 🟡 **VIVO A METÀ**: risponde, ma è cieco sui termini di microstruttura |
| 8 | **QuantConnect** `/learning/articles/`, `/strategies` | indice strategie | **200** (19.484 e 162.296 byte) ma l'indice della libreria **non è nell'HTML** (guidato da JS): **0 slug estraibili** | 🟡 **VIVO A METÀ** — e comunque **fonte già chiusa il 01/09** (83 slug, 0 candidati) |
| 9 | 🔴 **GitHub `/search`** | `?q=mql5+expert+advisor&type=repositories` | `curl` → **403 (249 byte)** · `WebFetch` → **429, `Retry-After: 3600`** | 🔴 **MURATO** (⚠️ **429 ≠ 404**) |
| 10 | 🔴 **`api.github.com`** | `search/repositories?q=mql5` | **403** | 🔴 **MURATO** |
| 11 | 🔴 **Forex Factory** | `/forum/71-trading-systems` | **403, 5.469 byte** | 🔴 **MURATO** |
| 12 | 🔴 **`codeload.github.com`** | `/robots.txt` | **403** | 🔴 **MURATO** (niente zip di repo) |

⚠️ **`gh` non è installato** su questa macchina (`which gh` → vuoto): il canale
autenticato GitHub **non è disponibile**, e non l'ho simulato.

---

## 3. 🔓 LA PORTA RIAPERTA — **GitHub non è al buio, lo è solo `/search`**

Questo è il rilievo operativo che vale più di un candidato, perché **restituisce
una fonte intera** che tre dossier di fila avevano dichiarato non battibile.

| endpoint GitHub | trasporto | esito stanotte |
|---|---|---|
| `github.com/search?q=…` | `curl` | 🔴 **403** |
| `github.com/search?q=…` | `WebFetch` | 🔴 **429**, `Retry-After: 3600` |
| `api.github.com/search/…` | `curl` | 🔴 **403** |
| `codeload.github.com/…` | `curl` | 🔴 **403** |
| 🟢 **`github.com/<owner>/<repo>`** | `WebFetch` | 🟢 **200, contenuto leggibile** |
| 🟢 **`github.com/<owner>/<repo>/tree/<branch>/<path>`** | `WebFetch` | 🟢 **200, elenco cartelle leggibile** |
| 🟢 **`raw.githubusercontent.com/<owner>/<repo>/<branch>/<path>`** | `curl` | 🟢 **200, sorgente scaricabile** |

👉 **Procedura che funziona, e che lascio scritta per il prossimo cacciatore:**
1. si **scopre** il nome del repo con `WebSearch` (etichetta `[LETTO-VIA-SEARCH]`);
2. si **apre l'albero** con `WebFetch` sulla pagina `/tree/` (etichetta `[LETTO]`);
3. si **scarica il sorgente** con `curl` da `raw.githubusercontent.com`
   (etichetta `[LETTO]`), e **si legge**.

⚠️ **Il limite onesto della procedura:** senza `/search` **non si può enumerare**.
Si arriva solo ai repo di cui si conosce (o si indovina via `WebSearch`) il nome.
**È un buco parziale, non una fonte piena** — e va dichiarato così.

📌 **Un sottoprodotto già utile:** esiste un **mirror del Code Base su GitHub**,
`GeneralTradingSarl/expert-mt5` (autore *Ismael LADJOHOUNLOU*, `mql5_experts_mt5/`,
una cartella per EA con `.mq5` + README) — è la strada che il file prova
`ABTG_RangeBudget.txt` aveva già usato il 16/08 per leggere *Range Follower*
quando `www.mql5.com` rispondeva 403. **Stanotte quel mirror risponde 200 ed è
navigabile.** ⚠️ Ma la prima pagina dell'elenco (100 cartelle, A-B) è **lo stesso
acquitrino del §4**: `Advisor Based on RSI and Martingale`, `Basic Martingale EA v3`,
`Angry Bird (Scalping)`, `AK-47 Scalper EA`, `2MA Bunny Cross`, `3MACross`,
`5_8 MACross`, `55 MA`, `Bollinger Bands` ×8. **Valore per il mandato: basso.**
Valore come **canale di riserva quando mql5.com è murato: alto.**

---

## 4. 🔭 COSA HO SFOGLIATO

| fonte | cosa ho guardato | candidati visti | arrivati al sorgente |
|---|---|---:|---:|
| **MQL5 Code Base** | 3 pagine, **120 titoli con id**, incrociati con i **478 id già setacciati** (78 dei dossier + 400 del crawl 02/09) | 120 | **3 pagine EA aperte, 2 `.mq5` scaricati e letti (3.638 righe)** |
| **GitHub** (via §3) | 1 mirror Code Base (100 cartelle) + 3 repo indicati da `WebSearch` | 4 repo | **1 README letto per intero (23.533 byte)** |
| **Quantpedia** | screener gratuito, **82 slug enumerati uno per uno** | 82 | 0 (motivo in §8) |
| **arXiv** | 3 sweep (`intraday momentum`, `currency strength`, `high frequency + FX`) + listing `cat:q-fin.TR` (25 titoli) | ~45 | 2 abstract aperti |
| **TradingView** | 5 interrogazioni di microstruttura | 8 | 0 (motivo in §8) |
| **QuantConnect** | indice libreria | 0 leggibili | 0 |
| **Forex Factory** | — | — | 🔴 403 |

---

## 5. 🔬 I CANDIDATI LETTI NEL SORGENTE — tre schede, tre scarti

### 5.1 `EA KCI N-Matrix engine` — **SCARTO §4, e lo prova il sorgente**

```
NOME          EA KCI N-Matrix engine
FONTE / URL   https://www.mql5.com/en/code/74840          [LETTO]
AUTORE / DATA RitzFalih (`ritzfalih`) · 2026.07.10
POPOLARITA'   non leggibile nella pagina (guidata da JS)   [INCERTO]
LICENZA       non dichiarata nella pagina                  [INCERTO]
RIGHE/INPUT   2.843 righe · 222 `input`
```
🔴 **BANDIERE ROSSE, con le righe:**
- riga **144** `input double InpLotMultiplier = 1.3;  // Multiplier Lot for Averaging/Hedging` → **martingala**
- riga **143** `input double InpAveragingKVRStep = 2.0;  // Averaging Distance` → **griglia / averaging**
- riga **139** (commentata dall'autore stesso) `InpKVRMultiplierSL = 12.0; // 12.0=Grid/hedge Survival` → **il "sopravvivere" è la strategia**
- riga **281** `lot = (count_sell > 0 && InpHedgeOnSignal) ? NormalizeVolume(max_lot_sell * InpLotMultiplier) : base_lot;` → **il lotto dipende dalle posizioni aperte in perdita**
- **222 input** contro il tetto di casa di ~15.

**VERDETTO: SCARTO** — tripla violazione §4 (martingala + griglia + hedge di
recupero). **Non è rifinibile: è marcio nel motore.** Zero minuti da spenderci.

---

### 5.2 `GDS Renko Donchian Demo EA` — **SCARTO C4, ma con due pezzi da tenere**

```
NOME          GDS Renko Donchian Demo EA v1.11
FONTE / URL   https://www.mql5.com/en/code/76813          [LETTO]
AUTORE / DATA gavaav ("Golden Delta", goldendeltaea.com) · 2026.09.06 (di ieri)
LICENZA       non dichiarata                              [INCERTO]
RIGHE/INPUT   795 righe · **10 input** (sotto il tetto: buon segno)
DIPENDENZE    NESSUNA — l'autore lo dichiara: "No external indicators, DLLs,
              custom symbols or offline charts are required"
```

**MECCANICA** (letta nel sorgente): costruisce Renko classico a mattone fisso
**dai tick BID dentro l'EA** (classe `CRenkoBuilder`, inversione a due mattoni);
canale di **Donchian su 25 mattoni completati**; ingresso alla rottura del canale
+ buffer di 0,20 mattoni, con `InpEntryRunBricks` mattoni consecutivi richiesti;
TP **8,0** mattoni / SL **8,2** mattoni (**RR 0,976**); tenuta massima
`InpMaxHoldMinutes = 4935` (**82 ore**); cooldown di 6 mattoni.

**🟢 PERCHÉ L'HO APERTO INVECE DI SCARTARLO DAL TITOLO** — e perché lo scarto
del 02/09 (fatto **per analogia**, non leggendo) meritava una verifica: su barre
Renko la **frequenza è una manopola** (la dimensione del mattone) e **il costo/R
è controllabile per costruzione** (stop = N mattoni). Col mattone da 14 punti e
SL 8,2 mattoni → **stop 114,8 punti** → pedaggio `1,65/114,8 =` **0,0144R**,
cioè **il 19% del cancello H8**: batte di 5,7 volte il pedaggio di M5. Era
l'unica geometria che poteva sfuggire alla legge del costo, e andava misurata,
non intuita.

🔴 **E MUORE LO STESSO, per tre motivi separati:**
1. **C4 — il motore non è nuovo, è un Donchian breakout.** La barra è nuova, la
   decisione no. In casa il breakout è **0/48** e **~210 celle a tick**.
   Cambiare il tipo di barra **è** un parametro diverso dello stesso motore.
2. **C1 — non è un TF basso.** `InpMaxHoldMinutes = 4935` = **82 ore**: è uno
   swing multigiorno travestito da Renko. **Fuori dal mandato.**
3. **§4 — SL virtuale + lotto fisso.** L'autore lo dichiara in `#property
   description`: _"TP/SL are **virtual**: the EA and terminal must remain
   running"_ e riga 24 `input double InpLots = 0.01; // Fixed lot size`.
   ⚠️ Questi due sarebbero **GESTIONE**, cioè roba che rifaremmo noi — **non
   sono il motivo dello scarto**. Il motivo è (1) e (2).

🟢 **COSA TERREI COMUNQUE** (regola F del mandato: motore e gestione separati):
riga 23, `input double InpMaxSpreadFraction = 0.35; // Max spread as fraction of
brick size`. **È la regola R55 di casa** — _"spread come percentuale dello stop,
non in punti"_ — scritta da un autore che non ci conosce. Vedi §5.4.

---

### 5.3 `elrizwiraswara/nyao_scalper_mt5` — **il repo mai visto in casa, e lo scarto lo firma l'autore**

```
NOME          Nyao Scalper v43.0 — "Indicator-Based Signal Strength EA for MT5"
FONTE / URL   https://github.com/elrizwiraswara/nyao_scalper_mt5      [LETTO]
              README letto per intero via raw.githubusercontent (23.533 byte, HTTP 200)
IN CASA       grep su tutto il repo: **ZERO menzioni**. È materiale nuovo.
TF DICHIARATO M1 / M5 — **esattamente il perimetro del mandato**
```
**MECCANICA:** punteggio di confidenza 0,0-10,0 come **media pesata** di
Trend (incrocio EMA veloce/lenta + pendenza), Momentum (RSI), Impulso,
Volatilità (ATR), Price Action, Velocità del punteggio.

🔴 **SCARTO, e il motivo più grosso è scritto dall'autore stesso in grassetto
nel suo README:**
> _"### Hedge Chain Recovery (Optional) — ⚠️ **This is a martingale.** Lot size
> grows as a losing trade is hedged and re-hedged. It can recover many drawdowns
> smoothly but carries genuine **ruin risk**… it converts frequent small losses
> into rarer large ones."_

Più, dalla stessa pagina: `HedgeLotMultiplier`, `HedgeMaxLot`, `HedgeRecoveryPct`,
e **`Virtual SL + Re-entry`** (_"Closes losing positions at the health threshold,
then immediately re-enters"_) → **SL virtuale**, seconda bandiera §4.
E il cuore del segnale è **una pila di indicatori** (EMA + RSI + ATR + candele) =
la famiglia _"scalping a pila di indicatori"_ già sepolta il 05/09, con dentro
un **incrocio EMA** (cimitero, due volte).

⚠️ **Onestà sul martingala:** è `Optional`, `opt-in per profile`, e **spento nel
profilo `safe`**. **Non cambia il verdetto** — perché il resto (SL virtuale +
pila di indicatori + incrocio EMA) basta da solo, e perché un motore la cui
strada maestra di recupero è un martingala non è una base che vogliamo rifinire.

🟢 **COSA TERREI, e sono due cose serie:**
1. **`MaxSpreadATRRatio`** — soglia di spread massimo **derivata dall'ATR**
   invece che fissa in punti. **Di nuovo la R55 di casa** (§5.4).
2. **`Dead-Market Filter`**: _"When ATR collapses relative to its average
   (`ATR/AvgATR < MinVolRatioToTrade`), the signal is **zeroed** — the EA does
   not scalp a market too quiet to **overcome costs**."_ È un **gate di costo
   costitutivo**, non un filtro appiccicato, ed è esattamente la forma che in
   casa ha dato **30/30** (`ABTG_EMA200`) contro lo **0/5** dei filtri aggiunti
   dopo. ⚠️ **Da non confondere con L3** (compressione ATR → espansione), che è
   il contrario: L3 **entra** sulla compressione, questo **si astiene**.

---

### 5.4 🎯 IL RILIEVO CHE VIENE DA DUE SORGENTI INDIPENDENTI

Due autori che non si conoscono, un `.mq5` del Code Base (06/09/2026) e un repo
GitHub, hanno **entrambi** messo il gate dello spread **in proporzione alla
volatilità/alla taglia dello stop**, e non in punti fissi:

| sorgente | parametro | testuale |
|---|---|---|
| `GDS Renko Donchian` r.23 | `InpMaxSpreadFraction = 0.35` | _"Max spread as fraction of brick size"_ |
| `Nyao Scalper` README | `MaxSpreadATRRatio` | _"auto-derived from ATR… **Critical for cost control on M1 gold**"_ |

👉 **È la regola R55 di casa, confermata da fuori due volte in una notte.**
Non è un candidato: è una **conferma indipendente** che la difesa che abbiamo
già montato è quella che monta chi lavora davvero su M1/M5. Vale scriverla.

---

## 6. 💸 LA FRONTIERA DEL COSTO — **il contributo numerico di questa battuta**

Il mandato chiede _"il conto del cancello di costo per ogni candidato"_. Invece
di farlo tre volte, l'ho **risolto una volta in forma generale** — così vale per
tutti i candidati futuri e diventa una **specifica di caccia**, non un veto.

### 6.1 La disuguaglianza

- Cancello **H8** (`FIRME_2026-08-31.md`, FIRMA 2): **E ≥ 0,075R misurata a tick**.
- Pedaggio di una operazione, in R: **`pedaggio = spread ÷ stop_in_punti`**.
- Se vogliamo che il pedaggio si mangi **al massimo un terzo** del cancello:
  `spread / stop ≤ 0,025` → 🎯 **`stop ≥ 40 × spread`** *(pavimento DI LAVORO)*
- Se accettiamo che il pedaggio valga **tutto** il cancello (cioè il motore deve
  produrre **il doppio** in lordo): `spread / stop ≤ 0,075` →
  **`stop ≥ 13,3 × spread`** *(pavimento DURO — sotto, non si prova nemmeno)*

### 6.2 I numeri, con gli spread **MISURATI** in casa

Fonte spread: `risultati_archivio/SPREAD_FLOTTA_MISURA_2026-09-03.md`
(252 milioni di tick BCM, 2024.09.26 → 2026.06.30, % solo-bid **0,000%**).

| simbolo | ore | spread mediano **[MISURATO]** | 🧱 pavimento DURO (13,3×) | 🎯 pavimento DI LAVORO (40×) |
|---|---|---:|---:|---:|
| **NASUSD** | 14-20 srv | **1,6 - 1,8** pt indice | **21 - 24** pt | **64 - 72** pt |
| **U30USD** | 14-20 srv | **1,9 - 2,0** pt indice | **25 - 27** pt | **76 - 80** pt |
| **D30EUR** | 8-16 srv | **1,6 - 1,7** pt indice | **21 - 23** pt | **64 - 68** pt |
| **D30EUR NOTTE** | fuori sessione | **3,5 - 3,9** pt indice | **47 - 52** pt | **140 - 156** pt |
| **EURUSD / GBPUSD / USDJPY** | — | 🔴 **NON MISURATO** (H12 / M36 aperte) | — | — |

### 6.3 🔴 Il confronto che chiude il capitolo M5/M15

Metto accanto gli stop che **la casa stessa ha misurato**, non stimati da me:

| TF | stop tipico misurato in casa | fonte | pedaggio su D30EUR | in % del cancello H8 | contro il pavimento |
|---|---:|---|---:|---:|---|
| **M5** | **20,0** pt | REGISTRO r.1444 | **0,0825R** | **110%** | 🔴 **sotto anche il DURO (21-23)** |
| **M15** | **17,4** pt (1R a taglia ATR) | `CACCIA_TF_M15_2026-09-05.md` §3 | **0,0948R** | **126%** | 🔴 **sotto anche il DURO** |
| **M15** a 3×ATR | ~52 pt | derivato dal precedente | **0,0317R** | **42%** | 🟡 sopra il DURO, **sotto** il DI LAVORO |
| **M30** a 2×ATR | **50 - 80** pt (ATR M30 = 25-40) | `CACCIA_TF_M30_2026-09-05.md` | **0,021 - 0,033R** | **27 - 44%** | 🟢 **DENTRO la banda di lavoro** |

> 🎯 **LA RIGA CHE VA RICORDATA: IL TIMEFRAME DELLE BARRE È GRATIS. LA TAGLIA
> DEL RISCHIO NON LO È.**
> Si può decidere su barre M1 o M5 quanto si vuole — ma **si deve rischiare
> 65-80 punti indice**, altrimenti il pedaggio si mangia il cancello prima che
> il motore abbia detto una parola. **Non è "M5 è morto": è "uno stop da 20
> punti è morto", su qualunque timeframe lo si guardi.**

⚠️ **Il limite dichiarato di questa frontiera:** l'ho costruita **solo** sui tre
indici, perché sono i soli tre simboli con lo spread **misurato**. Sul **forex**
e sull'**oro** la stessa tabella **non è compilabile stanotte** — il numero manca
(H12 aperta da sette cacce, M36). Il mandato dice che una **misura dal vivo su
8 strumenti** sta girando: 👉 **quando quei numeri atterrano, questa tabella si
completa in dieci minuti ed è la prima cosa da fare**, perché il capitolo
"forex a TF basso" oggi è giudicato su **1,0 pip di CONVENZIONE**, non su un
dato. Detto brutalmente: **una delle due colonne che decidono il capitolo più
promettente del mandato (§6.5) è ancora una supposizione.**

### 6.4 🟢 E ADESSO LA NOTIZIA BUONA — quanta frequenza ci sta dentro?

Se lo stop deve essere ~65 punti, quante operazioni al giorno ci stanno
fisicamente? Il conto, tutto **[INFERITO]** da numeri misurati:

- Seduta DAX 08:00-16:00 server = **16 barre M30**.
- **ATR(M30) del DAX = 25-40 punti** `[VERIFICATO su CACCIA_TF_M30_2026-09-05.md]`.
- Percorso tipico di seduta ≈ 16 × 32 ≈ **510 punti**.
- Un'operazione con stop 65 pt e RR ~1 **consuma 65-130 punti** di percorso.
- → budget lordo **4-8 operazioni**; scontando sovrapposizioni, tempi morti e la
  parte non direzionale del percorso → **1-3 operazioni/giorno per simbolo.**

> ✅ **Il pavimento di 1,00 operazione/giorno NON è un muro fisico: ci sta
> dentro, a costo sostenibile, su UN SOLO indice.**
> 🔴 **Quindi il problema non è "non c'è spazio per fare trade". È "in quello
> spazio, nessuno dei ~20 meccanismi provati ha edge".** È una diagnosi
> diversa da quella che si stava scrivendo, e cambia dove si punta il prossimo
> round (§11).

### 6.5 ➗ E LA STRADA CHE LA CASA HA GIÀ INDICATO DUE VOLTE — l'aritmetica

Il miglior candidato di oggi (gap sessione cash Nasdaq) fa **0,14 op/giorno**.
L'arsenale ha **3 indici + 8 cambi + 2 metalli = 13 strumenti**.

**0,14 × 13 = 1,82 operazioni/giorno di PORTAFOGLIO.**

👉 **Il pavimento di frequenza è già superabile OGGI, senza trovare nessun
motore 7 volte più veloce** — serve un motore che **regga su più simboli**,
non uno che spari più spesso su uno solo. È esattamente la frase-bussola del
29/08 e la domanda lasciata aperta il 05/09, e stanotte ha un numero.

🔴 **E il "ma" grosso, che va scritto insieme al numero, se no è un imbroglio:**
sommare le frequenze è lecito **solo se i trade non arrivano insieme**. Il
§7-bis di casa è chiarissimo: _"il DD della prop è UNO: quello del conto.
Accendere N EA a DD basso aiuta solo se NON perdono insieme."_ E la casa ha già
una firma in senso opposto sul paniere correlato: _"dalla famiglia JPY entra al
massimo UNA sedia. Mai il paniere"_ (`TORNEO_JPY_CRITERI.md`).
👉 **La frequenza di portafoglio va MISURATA sulla correlazione, non sommata
sulla carta.** Quel numero — la matrice di sovrapposizione temporale fra i lati
di un motore multi-simbolo — **non esiste in repo.** È il buco che segnalo.

---

## 7. 🪑 LA PROVA DI ESISTENZA CHE ABBIAMO GIÀ IN CASA

Il mandato dice _"Dobbiamo farcela"_. **Un caso che ce l'ha già fatta esiste, ed
è nostro** — vale la pena averlo scritto in chiaro perché è l'unico metro reale.

`ABTG_DAX_Apertura_EU` · D30EUR · magic 770101:

| cosa | numero | etichetta |
|---|---|---|
| **frequenza reale misurata** | **25,5 op/mese** su finestra di 31 giorni (26 trade) | 🟢 **[VERIFICATO]** `CENSIMENTO_FREQUENZA_FLOTTA_2026-08-22.md` tabella A |
| **in operazioni per giorno feriale** (÷21) | **≈ 1,21 /giorno** | 🟢 **[INFERITO] dal precedente** |
| **contro il pavimento di casa** | **1,00 /giorno** | ✅ **LO SUPERA** |
| **contro la frequenza promessa** | 21,0/mese → scarto **✅ in linea** | 🟢 **[VERIFICATO]** |
| **TF del grafico** | **M5** | 🟢 **[VERIFICATO]** — `InpTrailTF = PERIOD_M5`, `InpOCTimeframe = PERIOD_CURRENT // = M5` |
| **TF della DECISIONE** | **H1** | 🟢 **[VERIFICATO]** nel sorgente: `ABTG_DEF_LEVEL_TF = PERIOD_H1` (r.168), `InpFilterTF = PERIOD_H1` (r.294), `InpStTF = PERIOD_H1` (r.298), `InpCorrTF = PERIOD_H1` (r.304) |
| **taglia dello stop in punti** | 🔴 **NON MISURATA** | ⚠️ **[INCERTO]** — `InpAtrSlMult = 1.5` (r.315) è su `PERIOD_CURRENT`, ma la cella viva è **RETEST, range 35**: **non deduco il numero, si misura** |

> 🎯 **LA FORMA, in una riga:** *barre M5 per l'ingresso · livello, filtro,
> Supertrend e correlazione tutti su **H1** · rischio in percentuale.*
> È esattamente ciò che il REGISTRO r.1535 dice con parole sue:
> _"M5 non è morto **come TEMPO DI INGRESSO** di una tesi più lenta… è l'unica
> M5 viva in casa, e adesso si sa perché."_
>
> ⚠️ **E il pezzo che manca per chiudere il ragionamento è UN numero: quanti
> punti indice rischia davvero quella sedia.** Se sta sopra i 65, la frontiera
> del §6 e la sedia viva raccontano la stessa storia e la specifica è
> confermata sul campo. Se sta sotto, la frontiera va rivista.
> 👉 **Non l'ho dedotto e non l'ho inventato: lo dichiaro come misura mancante.**
> Il Code Base ha anche l'attrezzo giusto già censito il 05/09 —
> **76934 `Position Peak Logger — how far your trades actually travelled, in R`**
> (`petrkostal`, 2026.09.04) — **sorgente NON letto stanotte** `[NON LETTO]`.

---

## 8. 🗑️ GLI SCARTI — uno per riga, col motivo

### 8.1 Sorgenti letti

| # | candidato | fonte | motivo dello scarto |
|---|---|---|---|
| S1 | **EA KCI N-Matrix engine** (74840) | Code Base `[LETTO]` | 🔴 §4 ×3: `InpLotMultiplier=1.3` (r.144) **martingala**, `InpAveragingKVRStep` (r.143) **griglia**, hedge di recupero (r.281). 222 input |
| S2 | **GDS Renko Donchian Demo EA** (76813) | Code Base `[LETTO]` | 🔴 **C4**: Donchian **breakout** (0/48, ~210 celle) con barra nuova = stesso motore. 🔴 **C1**: `InpMaxHoldMinutes=4935` (**82 ore**) = swing, non TF basso. (SL virtuale + lotto fisso sono gestione, non il motivo) |
| S3 | **Nyao Scalper v43.0** | GitHub `[LETTO]` | 🔴 §4: _"**This is a martingale**"_ (parole dell'autore) + **SL virtuale** (`Virtual SL + Re-entry`). 🔴 C4: pila di indicatori con **incrocio EMA** dentro |

### 8.2 Scartati prima del sorgente, col motivo

| # | candidato / famiglia | fonte | motivo |
|---|---|---|---|
| S4 | `Market Miner` (74818) | Code Base | **fuori C1**: gli `.ini` allegati sono `C4GBPUSD**1HR**` → è **H1**, non TF basso. (⚠️ **non è un cadavere**: è fuori dal MIO perimetro. Chi batte H1 lo apra — porta preset e screenshot) |
| S5 | `SuperTrend TV EA` (77009) | Code Base | già setacciato (REGISTRO + caccia DAX/Dow 06/09) |
| S6 | `Session Opening Range Breakout EA` (76153) · `AAPL cfd - ORB` (76333) · `GoldLondonBreakout` (75586) | Code Base | **ORB/breakout**, cimitero (0/48, ~210 celle) |
| S7 | `Sniper Gold Hybrid **Recovery**` (76605) · `Daily Zone **Recovery**` (75922) · `**Grid**CapitalCalculator` (76972) | Code Base | **§4 dal titolo**, confermato dalla classe |
| S8 | `Relative Moving Average EA` (75473) · `SteepMA` · `Simple EMA Cross` · `Pro MA Crossover` · `2MA`/`3MACross`/`5_8 MACross`/`55 MA` (mirror GitHub) | Code Base + mirror | **incroci di medie**: cimitero due volte |
| S9 | `HybridMicrostructure EA` (76331) · `OHLCMTF Scalper` (70796) · `ASQ Safe Scalping` (71189) · `ExMachina SafeScalping` (70052) · `ICE` (69651) · `Price Action Intraday` (68704) · `GDS Renko` (76793/76794/76811) | Code Base | **già setacciati** nelle cacce 25/08, 29/08, 31/08, 02/09, 06/09. Non si ricontrollano |
| S10 | ~150 pannelli/calcolatori/logger + ~60 snippet didattici | Code Base | **non sono motori**: niente da backtestare |
| S11 | **Quantpedia — tutti e 82 gli slug** | Quantpedia `[LETTO]` | 🔴 **fonte confermata inutile per questo mandato, e stavolta con la prova**: enumerati uno per uno, sono **tutti giornalieri o mensili e quasi tutti cross-sectional su azioni** (momentum, value, accrual, earnings, seasonality). **L'unico intraday è `intraday-seasonality-in-bitcoin`** — cripto, strumento che non abbiamo. **Zero intraday sui nostri simboli** |
| S12 | `Supertrend ANY INDICATOR + Range Filter` (wbburgin) · `[RS]Open Range Breakout V3` · `Stochastic RSI Range Market` · `Range Strat MACD/RSI` · `RSI Prediction by Range Segmentation` (LuxAlgo) · `Bollinger Range RSI` (ChartPrime) · `RSI Dynamic OB/OS` (Trendoscope) · `[RS]Monthly Dynamic Range Levels` | TradingView `[LETTO-VIA-SEARCH]` | **8 su 8 in famiglie già sepolte**: ORB, banda+oscillatore (M14, 6 finestre su 6 rosse), pile di indicatori. **Zero sorgenti aperti, e il motivo è quantitativo, non pigrizia** |
| S13 | `2609.02660` (deep learning su order book) | arXiv `[LETTO-VIA-SEARCH]` | serve il **libro ordini di livello 2**: BCM su CFD/forex **non lo dà**. Non traducibile |
| S14 | `1912.09524` (lead-lag FX) | arXiv `[LETTO-VIA-SEARCH]` | **C4**: il lead-lag direzionale è **M25**, misurato il 05/09, **8 celle su 8 negative al netto**. Cambiare mercato allo stesso meccanismo è un parametro diverso |
| S15 | `2605.11423` (VVG classifier MNQ) · `2605.04004` (overreaction AAPL) · `2407.13908` · `2212.12687` | arXiv `[LETTO-VIA-SEARCH]` | **già a registro come lapidi** (REGISTRO r.683; caccia 02/09 §269). ⚠️ Su `2605.11423` l'abstract riletto stanotte conferma con le parole dell'autore: _"**None of the evaluated strategies satisfy** the same validation criteria… out-of-sample walk-forward testing, positive net returns after transaction costs"_ |
| S16 | `geraked/metatrader5` · `yulz008/GOLD_ORB` | GitHub | **fonti già chiuse**: 11 EA su 11 misurati (PIANO_PROP r.1276); GOLD_ORB già letto il 22/08, ultimo commit **29/07/2023** |
| S17 | `GeneralTradingSarl/expert-mt5` — prime 100 cartelle | GitHub `[LETTO]` | mirror del Code Base **vecchio**: martingala, scalper a indicatori, incroci di medie. 🟢 **Tenuto come CANALE DI RISERVA** (§3), non come giacimento |

---

## 9. 🚧 COSA NON HO POTUTO VEDERE — dichiarato

1. 🔴 **GitHub `/search` e `api.github.com`**: 429 (`Retry-After: 3600`) e 403.
   **Non posso ENUMERARE i repo**, solo aprirli per nome. ⚠️ **429 ≠ 404**: il
   fronte non è vuoto, è **non indicizzabile da qui**. Ripresa con attesa
   crescente non tentata oltre la finestra della caccia.
2. 🔴 **`gh` non installato**: canale autenticato GitHub non disponibile.
3. 🔴 **Forex Factory: 403.** I thread storici — l'unico posto dove si legge
   **come una strategia è invecchiata** — restano chiusi.
4. 🟡 **QuantConnect**: le pagine rispondono 200 ma **l'indice della libreria è
   guidato da JS** e non estraibile. (Fonte comunque già chiusa il 01/09.)
5. 🟡 **MQL5 Code Base**: i **titoli e gli id** si leggono, **autori, date e
   download NO** dalla lista (JS). Li ho recuperati **aprendo la pagina del
   singolo id** — per i 3 aperti sono `[VERIFICATO]`, per gli altri 117 **no**.
   **Licenze e popolarità: `[INCERTO]` su tutti e tre i candidati.**
6. 🟡 **TradingView `pubscripts-suggest-json`** è **cieco sui termini di
   microstruttura** (`order flow imbalance`, `cumulative delta`, `tick imbalance
   bars`, `renko strategy` → 0 risultati). Non so se è assenza vera o filtro
   dell'endpoint: **`[INCERTO]`**.
7. 🔴 **Sorgente NON letto** di `Position Peak Logger` (76934) e `Round Trip Cost
   Reconciler` (76117) — i due attrezzi che centrano il debito H12. `[NON LETTO]`.
8. 🔴 **SSRN**: non tentato stanotte (403 agli atti dal 06/09 sul dossier Nasdaq).
9. 🔴 🎯 **IL BUCO PIÙ GRAVE, ED È UN NUMERO DI CASA: lo spread FOREX e ORO di
   BCM resta NON MISURATO** (H12 / M36, aperte da sette cacce). Tutta la
   colonna "netta" su EURUSD in ogni dossier di caccia poggia su **1,0 pip di
   CONVENZIONE**. 👉 **Il capitolo più promettente del mandato (forex a TF
   basso = l'unico GIUDICABILE, §10) è oggi giudicato su un numero inventato
   da noi.** La misura dal vivo su 8 strumenti sta girando: **è il primo
   numero da incassare.**

---

## 10. 🏛️ IN OTTICA PROP — la riga per ogni promosso (e non ce ne sono)

Nessun promosso, quindi nessuna riga di candidato. Ma tre rilievi di rotta che
il mandato mi chiede espressamente e che valgono comunque:

1. 🧱 **Il muro giornaliero è quello che morde, non il totale.** Su 100k:
   DD totale 10% = **90.000**, DD giornaliero 5% = **−5.000 in una seduta**.
   Un motore a TF basso che spara **3-5 operazioni correlate la stessa
   mattina** è un rischio **giornaliero**, anche col DD complessivo basso: la
   peggior giornata misurata in casa (R51) è **−2,06%** ≈ 3,2R a 0,65%.
   👉 **Qualunque candidato ad "alta frequenza" va misurato sulla PEGGIOR
   GIORNATA prima che sul PF.**
2. ⚖️ **Giudicabilità = valore prop, non estetica.** Sugli **indici** il
   pavimento tick è **26/09/2024** (~503 giorni feriali): a 1,00 op/giorno
   servono ~300 giorni per fare n=150+150, e il verdetto di merito arriva
   **oltre l'orizzonte di una challenge**. Sul **forex** il pavimento è
   **gen-1999** (R102) e lo stesso motore riceve un **verdetto vero**.
   👉 **A parità di bontà, il candidato forex vale di più** — ed è il motivo
   per cui il buco del §9.9 (spread forex non misurato) **è il collo di
   bottiglia della rotta prop, non un dettaglio contabile.**
3. ➗ **La frequenza di portafoglio è un'arma a doppio taglio.** 13 strumenti ×
   0,14 = 1,82 op/giorno (§6.5), ma **solo se non perdono insieme**. Senza la
   **matrice di sovrapposizione temporale** — che in repo **non esiste** — la
   somma è una speranza, non un numero. **Non la spaccio per un risultato.**

---

## 11. 🛑 PERCHÉ NON HO SCRITTO NESSUN FILE PROVA

Il mandato chiede un file prova **"per ogni PROVA SUBITO"**. I PROVA SUBITO sono
**zero**, quindi i file prova sono **zero** — e questa è la scelta giusta, non
una rinuncia. Precedente esplicito, 03/09:

> _"Scrivere un `.txt` per un candidato che il §2 dichiara caduto sarebbe la
> cosa peggiore che questa caccia potesse consegnare."_

E c'è un secondo motivo, più concreto: **l'unico file prova sensato che potevo
scrivere stanotte avrebbe avuto la riga `@DAQUANDO` vuota e la colonna del costo
compilata su uno spread di convenzione** (§9.9). Un file prova con una
pre-registrazione poggiata su un numero inventato non congela niente: **dà
l'apparenza di un criterio dove c'è un buco.** La regola di casa è chiara:
`@DAQUANDO` non si inventa, e il costo nemmeno.

---

## 12. ❓ LA DOMANDA A CUI IL PROSSIMO TEST DEVE RISPONDERE

Dopo nove battute sulla stessa parete, la domanda utile **non è più** _"quale EA
a TF basso proviamo"_. Il §6 l'ha riscritta, e adesso è misurabile:

> ### 🎯 **"Quanti punti indice rischia davvero `ABTG_DAX_Apertura_EU` — l'unica sedia M5 che in casa supera il pavimento di frequenza (25,5 op/mese = 1,21/giorno) — e quel numero sta sopra o sotto i 65 punti della frontiera del §6?"**

**Perché è questa e non un'altra:**
- **Costa una misura, non un round.** Non serve un EA nuovo, non serve una
  griglia, non si tocca niente in forward.
- 🟢 **Se sta SOPRA i 65 punti**: la frontiera e la sedia viva raccontano la
  stessa storia, e la casa ha finalmente una **specifica di caccia con dei
  numeri** al posto di un divieto: *"cerco un motore con ingresso su barre M5,
  decisione su struttura H1, stop ≥ 65 punti indice, ≥ 1 trigger/giorno,
  su più simboli scorrelati"*. **È una domanda a cui il web può rispondere** —
  al contrario di *"trovami un EA M5 che guadagna"*, a cui ha risposto **no**
  nove volte.
- 🔴 **Se sta SOTTO i 65**: allora una sedia viva prospera **dentro** la zona
  che la frontiera dichiara morta, e **la frontiera è sbagliata o incompleta** —
  il che è ancora più importante da sapere, perché quella stessa aritmetica ha
  già archiviato interi capitoli.

**E il numero da incassare per primo, in parallelo:** lo **spread forex/oro di
BCM** (§9.9). Senza, metà della frontiera resta una supposizione — e proprio
sulla metà (il forex) che è l'unica **giudicabile**.

---

## 13. 🧾 ONESTÀ FINALE

**Nove battute, zero motori a TF basso promossi.** A un certo punto la ripetizione
del "zero" smette di essere una notizia e diventa un dato: **non è che non
cerchiamo bene — è che stiamo cercando un oggetto che la nostra aritmetica dei
costi vieta.** Uno stop da 20 punti su un simbolo con 1,65 punti di spread non
può passare un cancello da 0,075R, **e nessun autore, paper o repo cambierà
questa disuguaglianza.**

Ciò che questa battuta aggiunge alle otto precedenti è **smettere di dirlo come
impressione e scriverlo come vincolo**: `stop ≥ 40 × spread`, che su D30EUR fa
**65 punti**, e che il mercato **concede 1-3 volte al giorno** — quindi il
pavimento di Claudio **è raggiungibile**, ma da un motore che **rischia da M30 e
decide da M5**, non da uno scalper.

E aggiunge una porta: **GitHub non era chiuso, era chiusa la sua ricerca.**
Tre dossier di fila l'avevano data per murata. Non lo era.

🛑 **Nessun EA scritto · nessun parametro toccato · nessuna sedia accesa o
spenta · nessun preset modificato · nessun acquisto proposto · nessun candidato
promosso al forward.**

---

_Cacciatore-strategie · battuta notturna del 06/09/2026 · perimetro FREQUENZA a
TF basso. Fonti etichettate `[LETTO]` / `[LETTO-VIA-SEARCH]` / `[NON LETTO]`
riga per riga. Nessun numero d'autore è entrato in un punteggio._
