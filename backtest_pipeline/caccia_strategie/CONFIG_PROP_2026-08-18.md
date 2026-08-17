# 🎯 CACCIA CONFIGURAZIONI PROP — dossier del 18/08/2026

_Cacciatore di configurazioni prop. Missione lanciata da Claudio il 18/08 ~00:30
(ora italiana), **corretta in corsa**: la priorita' #1 e' diventata **ESEMPI
CONCRETI CON VALORI DA COPIARE**, il censimento delle regole prop scende a
contorno compatto._

> ⛔ **Nessun acquisto proposto in questo dossier.** Gli shop sono stati LETTI.
> ⛔ **Nessuna modifica applicata a niente.** Solo proposte, decide Claudio.
> ⛔ **Nessun numero di performance dei vendor usato come criterio.**

---

## 0. 🔌 CONTROLLO POSITIVO SULLE FONTI — cosa risponde e cosa no

Eseguito il **18/08/2026** con `curl` diretto al proxy + `WebFetch`.
**Questa tabella cambia rispetto a `PROMEMORIA_SBLOCCO_FONTI.md` del 16/08:
alcune porte si sono APERTE, altre si sono chiuse.**

| fonte | esito 18/08 | verdetto |
|---|---|---|
| **`www.mql5.com`** | ✅ **200, pagine intere** | 🟢 **APERTA — era bloccata il 16/08** |
| `raw.githubusercontent.com` (file diretti) | ✅ 200 su path reali | 🟢 aperta |
| `arxiv.org` · `tradingview.com` | ✅ 200 | 🟢 aperte |
| `api.github.com` — **search** | ❌ `sessions are bound to their configured repositories` | 🔴 **NULLA** (solo endpoint repo-scoped) |
| `github.com` (pagine HTML) | ❌ HTTP **429**, `Retry-After: 3600` | 🔴 nulla per oggi |
| **`ftmo.com`** | ❌ 403 al CONNECT | 🔴 **NULLA** |
| `academy.ftmo.com` · `fundednext.com` · `help.fundednext.com` | ❌ 403 al CONNECT | 🔴 NULLA |
| `the5ers.com` · `e8markets.com` · `fundingpips.com` | ❌ 403 al CONNECT | 🔴 NULLA |
| `alphacapitalgroup.uk` · `propfirmmatch.com` · `propjournal.net` | ❌ 403 al CONNECT | 🔴 NULLA |
| `blueguardian.com` · `myfundedfx.com` · `topstep.com` · `apextraderfunding.com` | ❌ 403 | 🔴 NULLA |
| `web.archive.org` · `archive.org` · `r.jina.ai` · motori di ricerca diretti | ❌ nessuna connessione | 🔴 NULLA |
| `www.forexfactory.com` | ❌ 403 | 🔴 NULLA |
| `WebSearch` (con `allowed_domains`) | ✅ risponde e cita | 🟡 **canale INDIRETTO** (vedi sotto) |

### ⚠️ La conseguenza onesta sull'etichettatura

**Nessun sito ufficiale di prop e' apribile da qui.** Quindi:

- **[VERIFICATO]** = pagina che ho **aperto io** (solo `mql5.com` e
  `raw.githubusercontent.com`).
- **[LETTO-VIA-SEARCH]** = contenuto restituito da `WebSearch` **ristretto al
  dominio ufficiale della prop**. E' di seconda mano: lo strumento ha letto la
  pagina, io no. **Non e' [VERIFICATO] e non basta per comprare una
  challenge** — vale la regola D3 (risposta scritta del supporto).
- **[INCERTO]** = non lo so, e lo scrivo.

---

# 🥇 PARTE 1 — LA TABELLA DEGLI ESEMPI (la pagina che conta)

Riga = un esempio trovato. Colonne = i **valori veri** dichiarati.
Ultima colonna = cosa ce ne portiamo a casa.

## 1A-ZERO. 🏆 I TRE FILE `.set` VERI, SCARICATI E APERTI

**Questa e' la parte che vale il giro.** Tre preset "prop firm" **ufficiali dei
vendor**, scaricati da `c.mql5.com` e letti riga per riga il **18/08/2026**.
Non sono opinioni di forum: sono i file che il venditore consegna al cliente
che va su una prop.

### 🥇 `The Gold Reaper MT5` — preset `propfirm__1.set`
`https://c.mql5.com/31/1047/propfirm__1.set` · HTTP 200 · **20 parametri, file
completo** · autore Profalgo Limited (Wim Schrynemakers) · [VERIFICATO 18/08]

```
TradeFrequency=2          MaxSpread=500            FridayStopHour=25   (=disabilitato)
setSL_TP_After_Entry=0    Virtual_expiration=1     Randomization=0.00
ST1_MagicNumber=8000      Risk=1234                StartLots=0.01
MaxAllowedDD=9.00         PropFirmMaxDailyDD=4.00
UseEquity=0               OnlyUp=0                 CheckMargin=1
```

### 🥇 `The Gold Phantom` — archivio `The_Gold_Phantom_setFiles.zip`
`https://c.mql5.com/31/1765/The_Gold_Phantom_setFiles.zip` · HTTP 200 ·
**7 file `.set`** salvati il **15/01/2026** + `readMe.txt` · [VERIFICATO 18/08]

I sette file sono: `LowRisk`, `MediumRisk`, `HighRisk`, `combo`, **`Propfirm`**,
**`Propfirm_combo`**, `live account settings`.
Il `readMe.txt`, parola per parola:
> _"the **Combo** Set files are for running the EA **together with other EAs on
> the same account** (lower risk per EA...) · the **prop firm** set files are
> for prop firm accounts · The **Live signal** set file is what I'm running on
> my own live account (on Intense with 30% max DD)"_

Valori del preset **`Propfirm`**:
```
TradeFrequency=5          MaxSpread=500            FridayStopHour=25 (disabilitato)
AutoGMT=true              Broker_GMT_OFFSET_Winter=2   Broker_GMT_OFFSET_Summer=3
UseMQL5Calendar=true
EnableNFP_Filter=true     NFP_CloseOpenTrades=true     NFP_ClosePendingOrders=true
NFP_MinutesBefore=100     NFP_MinutesAfter=60
EnableIR_Filter=false     IR_MinutesBefore=100    IR_MinutesAfter=60
EnableCPI_Filter=false    CPI_MinutesBefore=100   CPI_MinutesAfter=60
Randomization=50          AdjustEntry=0  AdjustSL=0  AdjustTP=0
PropFirmMaxDailyDD=4      MaxAllowedDD=9           MaxRiskPerStrategy_=1.0
StartLots=0.01            UseEquity=false          OnlyUp=false   CheckMargin=true
```

#### 🎯 IL DIFF — cosa cambia ESATTAMENTE passando da "conto normale" a "prop"

Ho fatto il `diff` dei file base. **Cambiano solo QUATTRO parametri**:

| parametro | MediumRisk (conto normale) | **Propfirm** |
|---|---:|---:|
| `Randomization` | 0.0 | **50** |
| `PropFirmMaxDailyDD` | 0.0 (spento) | **4** |
| `MaxAllowedDD` | **30** | **9** |
| `OnlyUp` | true | false |

E dal `live account settings` del venditore (quello che dichiara di girare lui):
`MaxAllowedDD=30.0`, `PropFirmMaxDailyDD=0.0`, `Randomization=0.0`,
`TradeFrequency=3`.

#### 🎯 IL SECONDO DIFF — cosa cambia quando l'EA CONDIVIDE il conto

`Propfirm` vs `Propfirm_combo`: **un solo parametro**.

| parametro | `Propfirm` (EA da solo) | **`Propfirm_combo`** (con altri EA) |
|---|---:|---:|
| `MaxAllowedDD` | 9 | **4** |

> 🔴 **QUESTA E' LA RIGA PIU' IMPORTANTE DEL DOSSIER PER NOI.**
> Il venditore, quando il suo EA divide il conto con altri, gli **taglia il
> budget di drawdown personale da 9% a 4%** — **meno della meta'** — per
> lasciare spazio agli altri. **Noi facciamo l'esatto contrario**: ogni sedia
> gira col suo rischio pieno (0,65%) come se fosse sola, e il muro del conto
> e' UNO solo. La `ROTTA_PROP.md` lo dice gia' a parole (_"il DD della prop e'
> UNO: quello del conto"_); qui c'e' il numero di come lo si traduce in
> configurazione.

### 🥇 `Prop Firm Pass EA` — archivio `V2_Set_Files.zip` + documentazione PDF
`https://c.mql5.com/31/1790/V2_Set_Files.zip` (5 `.set`, salvati il
**07/02/2026**) e `https://c.mql5.com/31/1790/PropFirmPass_V2_Documentation_pdf.zip`
· autore ALGOECLIPSE LTD (Bailey Wickens) · [VERIFICATO 18/08]

**E' la lista di input piu' vicina alla nostra**: usa perfino il prefisso
`Inp`. Valori del set n.2 "Aggressive":

```
; --- Prop Firm Challenge (Top Priority) ---
InpStartingBalance=0            (0 = usa il saldo corrente)
InpMaxDailyLossPercent=5        InpMaxOverallLossPercent=10   InpProfitTargetPercent=10
InpSafetyBufferPercent=0.1      <-- il BUFFER, con un numero vero
InpClosePositionsOnLimitBreach=true
InpResetChallengeState=false
InpDailyDDPauseEnabled=true     InpDailyDDPausePercent=4      InpDailyDDPauseDays=1
InpTargetAction=2
InpBuyEntryRandomPoints=0       InpSellEntryRandomPoints=0
; --- Broker Setup ---
InpMaxSpreadPoints=0            InpSlippagePoints=0           InpStrictBrokerChecks=true
InpAutoAdjustStops=true         InpMinStopDistanceOverridePoints=100
InpStopDistanceSafetyPoints=1   InpStopRetryExtraPoints=10
; --- Risk Settings ---
InpLots=0                       InpPercentageRiskOfAccount=0.5
; --- Strategy ---
InpTimeframe=5   InpBarZ=2   InpScanBars=100   InpMinBarsRequired=400
InpExpirationInHours=1          InpMinOppositeOrderDistancePoints=9000
InpDailyResetHour=0             InpDailyResetMinute=0     <-- ORA **E MINUTO**
; --- Trade Management ---
InpTpPoints=0   InpSlPoints=2000   InpTslTriggerPoints=1000   InpTslPoints=250
; --- Trading Schedule (Server Time) ---
InpTradeMonday..Friday=true     InpTradeSaturday=false    InpTradeSunday=false
InpTradeStartHour=0  InpTradeStartMinute=0  InpTradeEndHour=23  InpTradeEndMinute=59
InpCancelPendingOutsideHours=true
InpMagic=6145985
```

Dal PDF di documentazione (testo estratto, [VERIFICATO 18/08]), le definizioni
che contano:
- **`Max daily equity loss %`** = _"Daily loss limit (percent) computed from the
  **daily start balance versus current equity**"_ → **identica alla formula del
  nostro Guardian**;
- **`Max overall equity loss %`** = _"computed from the challenge **starting
  balance** versus current equity"_ → statico, come il nostro `InpDDMode=0`;
- **`Buffer % for loss target thresholds`** = _"Extra buffer added to loss
  target thresholds **for safety**"_;
- **`Pause trading when daily DD hits threshold`** = _"Enables a **cooldown**
  when daily drawdown reaches the specified threshold"_, con
  **`Daily DD % trigger (0 = disabled)`** e **`Pause duration in days`**;
- **`Action when profit target reached`** = _"**lock, reset or pause for a
  day**"_;
- **`Entry Randomization`** = _"Random points added to buy stop entry **for
  entry diversification**"_;
- **`Reset stats (set true once, then false)`** = _"Clears stored baseline,
  locks daily stats on next init"_.

I 5 set differiscono **solo** su `InpBarZ`, `InpScanBars`, `InpMinBarsRequired`,
`InpMinOppositeOrderDistancePoints`, `InpSlPoints` (1500→3000) e
`InpTslTriggerPoints` (500→1000): **i parametri di rischio prop restano
IDENTICI in tutti e cinque.** Cioe': l'aggressivita' si cambia nel motore,
**mai** nelle protezioni.

### 🧮 LA CONVERGENZA — tre vendor indipendenti, gli stessi due numeri

| preset | cap giornaliero interno | cap totale interno | muro della prop |
|---|---:|---:|---|
| Gold Reaper `propfirm` | **4%** | **9%** | 5% / 10% |
| Gold Phantom `Propfirm` | **4%** | **9%** | 5% / 10% |
| Gold Phantom `Propfirm_combo` | **4%** | **4%** | 5% / 10% |
| Prop Firm Pass (pausa morbida) | **4%** (+ buffer 0,1) | 10% − buffer | 5% / 10% |
| Blog MQL5 "Best EA Settings" (31/07/2025) | **2,5%** | 5% | — |

> ### 🎯 LA REGOLA CHE ESCE DA SOLA
> **Chi configura per una prop non mette il guardiano SUL muro: lo mette
> UN PUNTO PERCENTUALE PRIMA.** 4 invece di 5. 9 invece di 10.
> **Il nostro preset `ABTG_Guardian_FTMO_2Step.set` mette 5,0 e 10,0 —
> esattamente sul muro.** Quando il nostro Guardian scatta, la challenge e'
> **gia' persa**: chiude le posizioni un istante dopo la violazione, non un
> istante prima.

## 1A. 🔧 Altri esempi con VALORI NUMERICI dichiarati

| # | esempio / fonte | rischio per trade | cap giornaliero | DD totale | filtro news | orari / sessione | altri cap | cosa ne copiamo |
|---|---|---|---|---|---|---|---|---|
| E0 | **Blog MQL5 "Best EA Settings to Pass Prop Firm Challenges"** — Diego Arribas Lopez, 31/07/2025 · [VERIFICATO 18/08] `mql5.com/en/blogs/post/763469` | **0,25% – 0,4%** | **2,5%** | 5% | attivo su alto impatto | **08:00–18:00** (solo sovrapposizione Londra/NY) | **max 1-2 posizioni aperte alla volta** · target 8% | il rischio per trade **piu' basso del nostro 0,65%**, e un cap giornaliero al **2,5%** cioe' meta' del muro |
| E0-bis | **Blog MQL5 "Prop-Firm Friendly EA Settings"** — stesso autore, 29/06/2025 · [VERIFICATO 18/08] `mql5.com/en/blogs/post/762821` | lotto fisso | 5% | 10% | — | — | **fase 2: lotto ridotto della meta'** (o −20%) · niente martingala/griglia | l'idea di **cambiare taglia fra fase 1 e fase 2** |
| E1 | **NYAO Scalper MT5** — profilo `safe` · [VERIFICATO], README letto su raw.githubusercontent 18/08 | **0,5% equity** | — (usa basket) | **basket stop 3% equity** | **45 min prima / 45 dopo** | ore configurabili | max 3 posizioni · max lot 0,01 · max spread 0,20×ATR · min vol ratio 0,70 | il **basket stop** = cap su perdita FLOTTANTE totale, che noi non abbiamo |
| E2 | **NYAO Scalper MT5** — profilo `balanced` | 0,8% equity | — | basket stop **6%** | 30/30 min | " | max 6 posizioni · max lot 0,05 | rapporto **SL×maxpos ≈ basket stop** (0,8×6=4,8 vs 6) |
| E3 | **NYAO Scalper MT5** — profilo `default` | 1,0% equity | — | basket stop **8%** | 30/30 min | " | max 8 posizioni · max lot 0,05 | idem (1,0×8=8,0 vs 8) — **regola di taratura esplicita** |
| E4 | **NYAO Scalper MT5** — profilo `aggressive` | 1,5% equity | — | basket stop **12%** | 15/15 min | " | max 12 posizioni · max lot 0,10 | — (fuori metro prop) |
| E5 | **PROPstyle Risk Monitor** (LamaToes) — "Recommended Settings for Prop Traders" · [VERIFICATO], README letto 18/08 | `MaxTotalRiskPercent = 1.0` | `DailyLossLimitPercent = 5.0` | `TrailingDrawdownPercent = 10.0` | — | `SessionResetTime = "17:00"` (NY close) | `TrackBalanceDown = true` · `MaxPerTradeRiskPercent` · `MaxOpenPositions` | **`TrackBalanceDown`**: il saldo di riferimento scende ma **non risale mai** — modello che il nostro Guardian non ha |
| E6 | **PROPstyle Risk Monitor** — "Recommended for Live Trading" | `MaxTotalRiskPercent = 2.0` | — | — | — | — | `AutoTrackBalance=true` · `UseEquityInsteadOfBalance=true` | la coppia **balance vs equity** come *input*, non come scelta hardcoded |

### 📌 I due valori piu' interessanti della tabella

1. **`MaxTotalRiskPercent = 1.0`** (E5) — cioe' **rischio TOTALE aperto ≤ 1%
   del conto**, non per trade. Noi ragioniamo per trade (0,65%): con 3 sedie
   accese contemporaneamente sullo stesso momento siamo gia' a **1,95%**
   aperto. Nessuno lo misura oggi.
2. **La regola di taratura di NYAO** (E1-E4): `SL per trade × max posizioni ≈
   basket stop`. Applicata a casa: 0,65% × N sedie ≈ cap sul flottante. Con
   N=8 sedie → **5,2%**, che e' **oltre il muro giornaliero del 5%**.

## 1B. 🧰 Esempi di PANNELLO INPUT (elenco input dichiarati, senza default pubblici)

Fonte: pagine prodotto MQL5 Market, **[VERIFICATO] — aperte il 18/08**.
Nessuna di queste pagine pubblica i valori di default: pubblica la **lista
degli input**, che e' comunque la specifica di cosa serve.

### 🥇 `Bneu Prop Firm Pass System` — la specifica piu' completa trovata
`https://www.mql5.com/en/market/product/172892` · Marvinson Salavia Caballero ·
**$99** · v2.34 · aggiornato **14/08/2026** · [VERIFICATO 18/08]

Preset di firm dichiarati: **FTMO Phase 1, FTMO Phase 2, MyForexFunds,
The5ers, FundedNext, Custom**. Ogni preset configura: profit target, daily
loss, max drawdown, min/max giorni, weekend holding, **modo di calcolo del
drawdown**.

Gruppi di input dichiarati (trascritti dalla pagina):

| gruppo | input dichiarati |
|---|---|
| **Daily Loss Baseline** | **modo: equity / balance / il PIU' ALTO dei due** · **ora e MINUTO di reset** |
| Safety System | on/off · **buffer in %** · comportamento chiusura d'emergenza · cancellazione pendenti · **persistenza del lockdown** · **blocco re-entry** |
| Risk Sentinel | on/off · **SL obbligatorio** · **max trade al giorno** · **max perdite consecutive** · soglia di auto-close |
| Combined Risk | on/off · **cap % rischio aperto (default 3%)** · **cap % margine (default 70%)** · conteggio posizioni · SL obbligatorio |
| Volume Cap | on/off · modo **lotti vs rischio** · limite **per simbolo** · limite **di conto** · conteggio pendenti · priorita' di chiusura |
| **Duplicate Filter** | on/off · **finestra di rilevamento in SECONDI** · tolleranza di **prezzo** · tolleranza di **volume** · ignora magic · ambito |
| News Filter | on/off · **minuti prima / minuti dopo** · livello di impatto · cancellazione pendenti |
| Session Guard | **chiusura weekend: giorno / ora / minuto** · **inizio rollover + durata** |
| Firm Config | preset · account size · override saldo iniziale |
| Custom Rules | profit % · daily loss % · max DD % · min/max giorni · weekend holding |

> 🔴 **Il `Duplicate Filter` e' la nostra ferita del 29/07**: il 29/07 due EA
> hanno aperto **lo stesso segnale nello stesso secondo**
> (`CENSIMENTO_ORDINI_PC.md` §3). Qui c'e' un meccanismo con **tre parametri
> espliciti** (finestra in secondi, tolleranza prezzo, tolleranza volume) che
> risolve esattamente quel caso. **Noi non ce l'abbiamo, ne' nel Guardian ne'
> negli EA.**

### `KT Equity Protector MT5`
`https://www.mql5.com/en/market/product/79554` · KEENBASE · **$60** · v3.1 ·
aggiornato **01/07/2026** · [VERIFICATO 18/08]

Cinque regole dichiarate: Daily Loss Limit · Max Loss/Drawdown · Profit Target
· **Trailing Profit Lock** (traccia il punto massimo del conto e chiude se la
restituzione supera una soglia) · **Weekend Gap Protection** (chiude tutto
prima della chiusura di venerdi').

🔴 **Il pezzo di intelligence piu' importante di tutto il giro:**
il profilo "Prop Firm Account" dichiara **tre modelli di ancoraggio del
drawdown**:
1. **statico**
2. **trailing sul SALDO PIU' ALTO** (highest balance)
3. **trailing sull'EQUITY**

**Il nostro `ABTG_Guardian` ne ha DUE** (`InpDDMode` 0=statico, 1=trailing dal
picco di equity). **Manca il modello 2** — ed e' proprio quello che usa FTMO
1-Step (§2A). Inoltre KT dichiara **log CSV giornaliero di audit** e un menu
di azioni: solo allarme · chiudi le perdenti · chiudi le vincenti · chiudi
tutto · **chiudi tutto e rimuovi ogni altro EA dal terminale**.

### `Take a Break MT5`
`https://www.mql5.com/en/market/product/45264` · Eric Emmrich · **$70**
(rent $39/mese) · v26.81 · aggiornato **10/08/2026** · rating 4,76 su 90
recensioni · [VERIFICATO 18/08]

Meccanismi dichiarati, quelli che ci riguardano:
- **news filter con pause per LIVELLO DI IMPATTO** (Special / High / Medium /
  Low), **chiusura dei trade X minuti prima della news**, **timing NFP
  separato**, filtro per **nome evento** o per **simbolo**;
- limiti giornalieri di profitto/perdita in **modo Equity o Balance**;
- soglie **Min/Max Equity**;
- **pausa automatica dopo N perdite** (o dopo N profitti);
- **max spread per simbolo** · **max lotti totali** · **max ordini aperti**
  (totali / solo buy / solo sell) · **max ordini al giorno**;
- finestre orarie **per giorno della settimana**, filtri per giorno del mese /
  mese / giorno dell'anno, **durata massima del trade**, **chiusure
  programmate giornaliere**;
- **fuso orario e ora di reset configurabili** (supporta "CET");
- richiede **WebRequest abilitato** (→ prende il calendario news dal web).

### `Risk Manager Pro MT5`
`https://www.mql5.com/en/market/product/76627` · Roman Zhitnik · **$65** ·
v1.61 · aggiornato **16/07/2026** · [VERIFICATO 18/08]
Sorveglia: risultati **giornalieri e SETTIMANALI**, drawdown, posizioni
aperte, numero di trade, **perdite consecutive**, orari. Azioni: chiude
posizioni, cancella pendenti, **ferma gli altri EA**, notifica, **chiude il
terminale**. Ha "anti-grid protection". **Demo gratuita disponibile.**

### `Equity Protect Pro MT5`
`https://www.mql5.com/en/market/product/115530` · Shi Jie He · **$40** ·
[VERIFICATO 18/08 dalla pagina elenco]
Dichiara: equity protection · portfolio protection · profit protection ·
automatic risk control · **conditional liquidation**.

### `Anchor Trade Manager`
`https://www.mql5.com/en/market/product/165444` · Kalinskie Gilliam · **$89** ·
[VERIFICATO 18/08 dalla pagina elenco]
Slogan che descrive esattamente la nostra architettura: _"Your EAs manage
their own trades. **Anchor manages the account around them**"_ — controllo di
piu' EA e **enforcement del rischio a livello di CONTO**. E' la stessa tesi
del nostro Guardian, venduta come prodotto.

### `The News Filter MT5`
`https://www.mql5.com/en/market/product/97675` · Leolouiski Gan · **$70** ·
[VERIFICATO 18/08 dalla pagina elenco]
Filtra **tutti gli EA e i grafici manuali** durante le news, con gestione di
posizioni e ordini pendenti.

## 1C. 🧪 Il meccanismo tecnico che vale piu' di tutti i prezzi

> **`CalendarValueHistory` — il calendario news NATIVO di MT5, senza DLL.**

Dichiarato nel README di NYAO Scalper [VERIFICATO 18/08]:
> _"`CalendarValueHistory` (the high-impact **news filter**) generally returns
> nothing inside the Strategy Tester, so backtests run **without** news
> protection that live trading has. Treat tester drawdowns around news as
> optimistic."_

Due cose, entrambe pesanti per noi:
1. ✅ **Il filtro news si scrive in MQL5 puro**, con la funzione di calendario
   del terminale. Niente DLL, niente WebRequest, niente abbonamenti. E' il
   modo in cui possiamo aggiungere il filtro news ai nostri EA **senza
   dipendere da nessuno**.
2. ⚠️ **Nello Strategy Tester quel calendario NON risponde.** Quindi un filtro
   news **non e' backtestabile**: i nostri backtest restano "ottimistici sulle
   news" per costruzione, e questo va scritto accanto a ogni numero. Non e'
   un dettaglio: e' un limite strutturale del nostro imbuto.

## 1D. 📺 La pista del video segnalato da Claudio

**Fonte:** video YouTube di Petko Aleksandrov (canale EA Forex Academy /
`algotradingspace.com`), _"7 Expert Advisor adatti a conti finanziati (e
societa' di trading proprietario)"_, pubblicato **17/08/2026**,
`youtube.com/watch?v=XzNrfSUVa3M`.
⚠️ **YouTube e' bloccato dal proxy: il video NON e' stato aperto.** I nomi dei
7 EA arrivano dagli **screenshot della descrizione caricati da Claudio in chat
il 18/08/2026**. Il recensore usa **link affiliati e codici sconto**: i suoi
giudizi **non pesano**, i nomi si', perche' sono verificabili altrove.

Ho cercato i 7 su MQL5 Market e sui siti dei vendor. Ecco cosa hanno detto le
**loro** pagine:

| EA | dove l'ho letto | prezzo | 🚩 griglia / martingala / recovery? | input coi default? |
|---|---|---|---|---|
| **Dark Venus MT5** (Marco Solito) | `mql5.com/en/market/product/56365` · v5.70 · agg. **15/07/2026** · [VERIFICATO 18/08] | **GRATIS** | ✅ **NO** — la pagina dichiara esplicitamente niente griglia, niente martingala, niente recovery | ❌ elenca i nomi (Magic, Max Spread, Lots, Money Management + Risk Percent, periodo/deviazioni Bollinger, filtri orari) **ma NON i valori** |
| **Dark Algo MT5** (Marco Solito) | `mql5.com/en/market/product/92403` · v2.20 · agg. **05/02/2026** · [VERIFICATO 18/08] | $399 | ✅ **NO** ("No Martingale, No Grid, No Averaging") | ❌ nomi si' (Max Number of Orders, Max one Trade per Bar, Max Spread, Max Average Spread, Risk Percent, Stocastico, ATR, Entry Timing), valori no. Dichiara **"FTMO-compatible"** |
| **Dark Nova** (Marco Solito) | ricerca su `mql5.com` · [LETTO-VIA-SEARCH 18/08] | — | [INCERTO] | ❌ |
| **Dark Titan** _(nel video "Dark Tian" — [INFERITO]: e' un refuso)_ | `mql5.com/en/market/product/65522` (MT4) · [LETTO-VIA-SEARCH 18/08] | — | [INCERTO] | ❌ |
| **FX JetBot** (Forex Store) | ricerca web, recensioni terze · [LETTO-VIA-SEARCH 18/08] | — | 🚩 **SI'** — descritto come **trend + "controlled grid recovery system"**; una recensione parla di ingresso con **lotto ~5 volte piu' grande dopo una perdita**. Altre fonti dicono "lotto fisso, niente martingala": **fonti in contraddizione** | ❌ |
| **Infinity Trader** | ricerca web · [LETTO-VIA-SEARCH 18/08] | — | 🚩 **SI'/CONTRADDITTORIO** — alcune fonti "grid trading robot", il vendor "no martingala, FIFO, risk cap" | ❌ |
| **UnitedEuro** (Robot Forex Pro) | ricerca web · [LETTO-VIA-SEARCH 18/08] | — | **[INCERTO]** — non ho trovato una pagina prodotto attendibile | ❌ |

### 📌 Cosa ci portiamo a casa da questa pista

1. **Nessuno dei 7 pubblica i default degli input.** Zero valori copiabili.
   La resa e' **molto** piu' bassa dei tre `.set` del §1A-ZERO.
2. **Il dato che vale e' proprio il conteggio delle bandiere:** su 7 EA
   venduti come "adatti a conti finanziati", **almeno 2 sono recovery/griglia
   dichiarati o fortemente indiziati**, e per 3 non si sa. Solo la famiglia
   "Dark" dichiara nero su bianco niente griglia/martingala/averaging.
   > 🚩 **"Prop-ready" nel marketing non vuol dire "senza recovery".** E un
   > motore recovery su un muro giornaliero del 4-5% e' una bomba a orologeria:
   > il drawdown flottante di una griglia viola il cap **prima** di rientrare.
3. **Dark Venus e' GRATIS**: se un giorno serve vedere un pannello input
   completo di un EA "prop-ready", **si scarica e si guarda in MT5** — costo
   zero, e non e' un acquisto. (Non e' una proposta operativa, e' una nota.)

---

## 1E. 🎧 LE 11 TRASCRIZIONI TURBOSCRIBE — rimando all'analisi

Analisi completa il **18/08/2026** delle 11 trascrizioni caricate da Claudio in
`trascrizioni_2026-08-18/`. **Referto separato (non duplico qui):**
**`ANALISI_TRASCRIZIONI_2026-08-18.md`** (stessa cartella).

**Cosa dicono, in tre righe:**
- **Resa numerica BASSA:** i video dettano **concetti e trucchi**, quasi zero
  parametri di config (a differenza dei tre `.set` del §1A-ZERO). Nessun `.set`
  è mai stato letto ad alta voce.
- **I 4 punti caldi restano NON confermati dal parlato:** ❌ il buffer 4/9 non
  compare (resta appeso ai soli `.set`); ❌ nessuno detta l'ora di reset del muro
  né il fuso di reset; ❌ nessun valore di filtro news in minuti; ❌ nessuno dei 4
  EA schedati (FX JetBot / Dark / Infinity / UnitedEuro) è nominato.
- **Indipendenza:** su 11 video le fonti reali sono **7** — **Petko / EA Forex
  Academy** copre 3 video (contano 1), il canale "Cash & Prop" ne copre 2
  (contano 1).

**Le convergenze utili (fra fonti indipendenti):**
- 🟢 **RR-alto + win-rate-alto + varianza-bassa** per sopravvivere al muro → 3
  fonti su 7. È il dato più solido e SANO, ma è un **principio**, non un numero.
- ⚠️ 🔴 **randomizzazione/mascheramento anti-detection** (3 fonti) e **hedge
  cross-account** (3 fonti): documentati come **INTELLIGENCE, marcati VIETATO
  PER NOI** (violano i termini prop — es. FundedNext vieta l'hedge multi-account).
- ✅ **static-not-trailing** confermato a voce (`PropEA`): rinforza la proposta
  **P7**. **FundedNext 1-step 3%/6%** aggiunto dalla voce (dossier §2B aveva solo
  il 2-step): rinforza §2B/§2G.

> 🔴 **La proposta P2 (buffer 4/9) NON guadagna una terza gamba dal parlato:** i
> video non dettano protezioni numeriche. Il 4/9 resta un fatto dei `.set`.

---

# 🥈 PARTE 2 — CENSIMENTO PROP (versione compatta, come richiesto)

⚠️ **Tutte le righe qui sotto sono [LETTO-VIA-SEARCH] del 18/08/2026**, non
[VERIFICATO]: i domini delle prop sono bloccati (§0). **Nessuna di queste righe
autorizza un acquisto** — serve la risposta scritta del supporto (regola D3,
domande gia' pronte in `report/DOMANDE_SUPPORTO_PROP.md`).

## 2A. FTMO
Pagine citate dalla ricerca: `ftmo.com/en/trading-objectives/` ·
`ftmo.com/en/forbidden-trading-practices/` · `academy.ftmo.com/lesson/maximum-daily-loss/`
· `academy.ftmo.com/lesson/maximum-loss/` · `ftmo.com/en/faq/can-i-trade-news/`

| voce | valore |
|---|---|
| MURO GIORNALIERO | **5%** (2-Step) · **3%** (1-Step) del capitale iniziale |
| come si calcola | su **EQUITY**, include **flottante + commissioni + swap**. Formula: `saldo alle 00:00 CE(S)T − 5% del capitale iniziale` |
| **reset** | **00:00 CE(S)T** |
| MURO TOTALE | **10%** |
| **statico o trailing** | 🔴 **DIPENDE DAL PRODOTTO.** 2-Step: **statico**. **1-Step: trailing END-OF-DAY** sul **saldo di fine giornata piu' alto** ("il limite puo' solo salire, mai scendere"). Esempio citato: saldo a mezzanotte 104.000 → muro a 94.000 |
| EA AMMESSI | ✅ si', purche' non somiglino a pratiche vietate. **Limite duro: max 2.000 richieste server al giorno** |
| COPY / STESSA STRATEGIA | **cap di allocazione: $400.000 per trader O PER STRATEGIA** (prima dello scaling), valido su 1-Step e 2-Step insieme. Strategie identiche su piu' conti oltre il cap → sospensione |
| NEWS | **Standard**: vietato **aprire o chiudere ±2 minuti** attorno alle news selezionate (leva 1:100). **Swing: NESSUNA restrizione news** |
| CONSISTENZA | **50% Best Day Rule**: nessun singolo giorno > **50%** del profitto dei giorni positivi. Metrica: `(1 − (giorno migliore / somma assoluta di tutti i giorni)) × 100%` |
| ALTRO | target 10% (fase 1) / 5% (fase 2) · minimo **4 giorni** di trading |

## 2B. FundedNext (Stellar)
Pagine citate: `help.fundednext.com/en/articles/8019811-...` ·
`.../8021076-what-rules-do-i-need-to-follow-in-the-stellar-2-step-challenge`

| voce | valore |
|---|---|
| MURO GIORNALIERO | **5%** del saldo iniziale. **Cresce col profitto intraday**: con +2.000 a meta' giornata diventa 5.000+2.000 = **7.000** |
| **reset** | **00:00 ORA SERVER**; il server e' **GMT+3 in estate, GMT+2 in inverno** |
| MURO TOTALE | **10%** (il conto non deve scendere sotto il 90% del saldo iniziale) |
| EA AMMESSI | ✅ **"Using EAs or indicators is allowed"** |
| dopo la violazione | conto bloccato **per il resto della giornata**, **non si riattiva da solo**: serve reset manuale |
| CONSISTENZA | **40%** sul prodotto *Rapid Pro*; **nessuna** su *Rapid Daily* |

> ✅ **La formula giornaliera di FundedNext e' ESATTAMENTE quella del nostro
> Guardian**: `saldo a inizio giornata − equity ≤ 5% del capitale iniziale`.
> Su questo punto siamo gia' allineati.

## 2C. The5ers (High Stakes)
Pagine citate: `help.the5ers.com/what-is-the-drawdown-rule-for-high-stakes/` ·
`the5ers.com/faqs/what-are-the-general-rules-for-the-high-stakes-program/`

| voce | valore |
|---|---|
| MURO GIORNALIERO | **5%**, preso dalla **equity O saldo di CHIUSURA del giorno precedente** |
| **reset** | **00:00 ora server** |
| MURO TOTALE | **10% dal saldo iniziale (assoluto/statico)** |
| NEWS | ✅ **tenere aperto sulle news e' permesso**; ❌ **eseguire ordini da 2 minuti prima a 2 minuti dopo** una news ad alto impatto **non e' permesso**. I news trader devono scegliere *Hyper Growth*, non *High Stakes* |
| giorni minimi | **3 giorni profittevoli** per fase, dove "profittevole" = posizioni chiuse per almeno **0,5% del saldo iniziale** |
| target | 10% fase 1 · 5% fase 2 |
| violazione daily | **termina il conto immediatamente, senza recupero** |

> ⚠️ **Baseline "equity O balance di chiusura"**: il nostro Guardian usa **solo
> il balance**. Se una notte chiudiamo con flottante negativo, `equity <
> balance` e il muro vero e' piu' vicino di quello che il pannello mostra.

## 2D. FundingPips
Pagine citate: `help.fundingpips.com/hc/en-us/articles/34501809112081-2-Step-Standard`
· `.../34504137479441-News-Trading-Weekend-Holding` ·
`.../44559256768529-Understanding-Trading-Mechanics`

| voce | valore |
|---|---|
| MURO GIORNALIERO | **5% del PIU' ALTO fra saldo e equity di apertura giornata**. Include il flottante |
| **reset** | **00:00 Platform Time = UTC+3** |
| MURO TOTALE | **statico** (es. **6%** su alcuni modelli), "non si muove mai", vale anche col flottante |
| EA | 🔴 **REGOLA DURA:** un EA di terze parti e' ammesso **SOLO se funziona da trade/risk manager**. Qualunque **altro** EA di terze parti = **violazione + rifiuto del payout** |
| NEWS | ❌ **nessuna posizione aperta, chiusa O TENUTA entro 10 minuti prima/dopo** una news ad alto impatto sulla valuta interessata. Violazione = **hard breach** |
| WEEKEND | dipende dal prodotto: **Zero → weekend hold = hard breach sempre**; Master account di 1-Step Flex / 2-Step Standard / Flex / Pro → **chiusura automatica di sistema al Friday close** (non e' breach); fasi di valutazione → **permesso** |

> 🔴 **Due colpi diretti alla nostra flotta:**
> 1. la regola EA "solo trade/risk manager di terze parti" ci **premia** (i
>    nostri EA sono nostri) ma **vieterebbe** qualunque guardiano comprato;
> 2. **±10 minuti di divieto di TENERE una posizione** manda fuori legge, di
>    principio, ogni sedia che sta aperta durante una news ad alto impatto.
>    `ABTG_DAX_Apertura_EU` entra alle **08:00 server** = **09:00 CEST**, e i
>    dati tedeschi escono alle 08:00 CEST → **[INCERTO] ma da chiarire**.

## 2E. E8 Markets
Pagine citate: `help.e8markets.com/en/articles/11769446-daily-drawdown` ·
`.../6929927-trading-policies-and-prohibited-trading-strategies` ·
`.../9185497-can-i-trade-news` · `.../11864596-eod-dynamic-drawdown` ·
`.../11755943-e8-signature-forex`

| voce | valore |
|---|---|
| MURO GIORNALIERO | **4%** su piu' prodotti (piu' stretto dello standard) |
| **reset** | **00:00 ora server**, sul **saldo di inizio giornata** ("market rollover") |
| MURO TOTALE | **8%** statico su E8 Markets; alcuni prodotti **4-5% statico**; esiste un prodotto **"EOD Dynamic Drawdown"** (trailing di fine giornata) |
| EA | ✅ ammessi, **ma "una strategia per utente"**: se piu' utenti eseguono gli stessi trade/strategia → **terminazione**. HFT vietato |
| NEWS | ❌ **da 5 minuti prima a 5 minuti dopo** una news ad alto impatto: vietato **aprire E chiudere** |
| ORARI | 🔴 su **E8 Signature Forex/Crypto**: **tutte le posizioni chiuse alle 23:00 ora server**, riapertura **00:15 ora server** |
| CONSISTENZA | ~**40%** (One) / **35%** (Signature) sul giorno migliore — [INCERTO], letto su fonti terze non ufficiali |

> 🚨 **La riga delle 23:00 uccide tre nostre sedie sul colpo**:
> `ABTG_MaxMinNotte` (box **23:00-04:59**), `ABTG_Nightly` (**22:00-04:59**),
> variante oro (**22:00-06:00**). Su quel tipo di conto non e' "da adattare":
> **non esiste il setup**.

## 2F. Alpha Capital Group
Pagine citate: `alphacapitalgroup.uk/posts/alpha-capital-rules-explained-...-2026`
· `alphacapitalgroup.uk/posts/alpha-capital-news-trading-and-overnight-rules-explained-2026`
· `help.alphacapitalgroup.uk/en/articles/10097421-alpha-one`

| voce | valore |
|---|---|
| MURO GIORNALIERO | **3%-5%** secondo il piano, sull'**equity** |
| **reset** | **00:00 GMT+3** |
| MURO TOTALE | **Alpha One 6% STATICO** · **Pro / Swing / Three 10% STATICO** (dal saldo iniziale) |
| EA / COPY / NEWS | ✅ tutti **permessi** |
| regole "morbide" (flag, non ban) | violazioni di **durata trade < 2 minuti**, flag di copy trading, violazioni di consistenza |
| anti-HFT | **almeno il 50% dei profitti** deve venire da trade tenuti **piu' di 2 minuti** |

## 2G. 📊 Le sei prop a confronto, in una riga ciascuna

| prop | daily | reset | totale | tipo | news | EA |
|---|---|---|---|---|---|---|
| FTMO 2-Step | 5% equity | 00:00 CE(S)T | 10% | **statico** | ±2 min (Standard) · **nessuna su Swing** | ✅ max 2000 req/gg |
| FTMO 1-Step | 3% equity | 00:00 CE(S)T | 10% | **trailing EOD su saldo max** | idem | ✅ |
| FundedNext Stellar | 5% (+profitto del giorno) | 00:00 srv (GMT+2/+3) | 10% | statico | [INCERTO] | ✅ esplicito |
| The5ers High Stakes | 5% da equity/balance di chiusura | 00:00 srv | 10% | statico | **±2 min** | ✅ |
| FundingPips 2-Step Std | 5% del **max(bal,eq)** | 00:00 **UTC+3** | 6% | **statico** | **±10 min anche solo TENENDO** | ⚠️ solo propri o risk manager |
| E8 Markets | **4%** | 00:00 srv | **8%** | statico (+prodotto EOD) | **±5 min** | ✅ 1 strategia/utente |
| Alpha Capital | 3-5% | 00:00 **GMT+3** | 6% / 10% | statico | libere | ✅ |

## 2H. 🕐 Gli orari di reset tradotti in ORA SERVER BCM

Regola di casa: **ora server BCM = ora italiana − 1**. Ad agosto l'Italia e'
in **CEST = UTC+2**, quindi **BCM = UTC+1**.

| prop | reset dichiarato | in UTC | **in ORA SERVER BCM (agosto)** |
|---|---|---|---|
| FTMO | 00:00 CE(S)T | 22:00 | **23:00** |
| FundedNext (estate) | 00:00 GMT+3 | 21:00 | **22:00** |
| FundingPips | 00:00 UTC+3 | 21:00 | **22:00** |
| Alpha Capital | 00:00 GMT+3 | 21:00 | **22:00** |
| The5ers / E8 | 00:00 "ora server" | **[INCERTO]** — offset del loro server non verificato | **[INCERTO]** |

> 🔴 **Conseguenza immediata sul dry-run.** Il preset
> `mql5/Presets/ABTG_Guardian_FTMO_2Step.set` ha **`InpDailyResetHour=0`**.
> Su un demo BCM quello e' **mezzanotte BCM = 01:00 CEST**, cioe' **un'ora
> DOPO** il reset FTMO. Il dry-run misurerebbe una finestra giornaliera
> **sfasata di un'ora** rispetto a quella vera: una perdita fra le 23:00 e le
> 00:00 BCM finirebbe nel giorno prop **sbagliato**.
> ✅ Per replicare FTMO su BCM serve **`InpDailyResetHour=23`**.
> _(Nota: se un giorno si gira sul server della prop, li' `0` torna corretto —
> il numero dipende dal server, non dalla prop.)_

---

# 🥉 PARTE 3 — LA TABELLA DEI BUCHI

Confronto fra i meccanismi trovati fuori e cio' che abbiamo in
`mql5/Experts/ABTG_Guardian.mq5` (letto integralmente, 209 righe) e negli
input dei nostri EA.

| # | meccanismo trovato fuori | dove l'ho visto | ce l'abbiamo? |
|---|---|---|---|
| 1 | cap perdita giornaliera con chiusura totale | tutti | ✅ **SI'** (`InpDailyLossPct`, `FlattenAll()`) |
| 2 | DD totale **statico** | tutti | ✅ **SI'** (`InpDDMode=0`) |
| 3 | DD totale **trailing su picco EQUITY** | KT Equity Protector | ✅ **SI'** (`InpDDMode=1`) |
| 4 | DD totale **trailing su SALDO piu' alto di fine giornata** | KT (modello 2) · **FTMO 1-Step** | ❌ **NO** |
| 5 | **baseline giornaliera = equity / balance / il piu' alto** | Bneu · Take a Break · The5ers · FundingPips | ❌ **NO** — usiamo solo `balance` |
| 6 | reset giornaliero con **MINUTI**, non solo ore | Bneu · PROPstyle (`"17:00"`) | ⚠️ **PARZIALE** (`InpDailyResetHour` e' un `int` di sole ore) |
| 7 | **buffer di sicurezza** sotto il muro (scatta PRIMA) | Bneu (`buffer %`) · KT ("daily loss with safety buffer") | ❌ **NO** — scattiamo **al** muro, cioe' quando e' gia' violato |
| 8 | **riduzione del rischio** avvicinandosi al muro | — **nessun prodotto letto lo dichiara** | ❌ NO (e nemmeno loro) |
| 9 | **stop dopo N perdite consecutive** | Bneu · Risk Manager Pro · Take a Break | ❌ **NO** |
| 10 | **max trade al giorno** | Bneu · Take a Break | ❌ **NO** |
| 11 | **filtro NEWS** | Take a Break · The News Filter · Bneu · NYAO | ❌ **NO** — in nessun EA, in nessuna forma |
| 12 | **chiusura weekend programmata** (giorno/ora/minuto) | KT · Bneu (`Session Guard`) | ❌ **NO** |
| 13 | **cap sul rischio APERTO totale** (somma delle sedie) | Bneu (3% default) · PROPstyle (`MaxTotalRiskPercent=1.0`) | ❌ **NO** |
| 14 | **cap sulla perdita FLOTTANTE totale** (basket stop) | NYAO (3-12% per profilo) | ❌ **NO** |
| 15 | **cap sul margine usato** | Bneu (70% default) | ❌ **NO** |
| 16 | **cap sui LOTTI**, per simbolo e di conto | Bneu · Take a Break (`max total lots`) | ❌ **NO** |
| 17 | **max posizioni aperte simultanee** | PROPstyle · NYAO · Take a Break | ❌ **NO** |
| 18 | **filtro ordini DUPLICATI** (finestra sec + tolleranza prezzo/volume) | Bneu | ❌ **NO** — ed e' il bug misurato del 29/07 |
| 19 | **SL obbligatorio** (rifiuta/chiude posizioni senza stop) | Bneu · PROPstyle (conta i trade senza SL) | ❌ **NO** |
| 20 | **finestre orarie per giorno della settimana** | Take a Break · Bneu | ⚠️ **PARZIALE** — sta nei singoli EA, non nel Guardian |
| 21 | **durata massima del trade** | Take a Break | ❌ NO |
| 22 | **max spread** come veto d'ingresso | Take a Break · NYAO (0,20-0,35 × ATR) | ⚠️ **PARZIALE** — [INCERTO] EA per EA |
| 23 | **lockdown persistente + blocco re-entry** | Bneu · FundedNext (reset manuale) | ✅ **SI'** (GlobalVariable `BLOCKDAY`/`FAILED`, ricaccia gli ordini) |
| 24 | **azione graduata** (allarme / chiudi perdenti / chiudi tutto / rimuovi EA) | KT · Risk Manager Pro | ⚠️ **PARZIALE** — abbiamo solo allarme **o** chiudi-tutto |
| 25 | **log CSV di audit giornaliero** | KT | ❌ **NO** (solo `Print` nel giornale) |
| 26 | **contatore giorni di trading / giorni profittevoli** | Bneu · richiesto da FTMO (4) e The5ers (3 × 0,5%) | ❌ **NO** |
| 27 | **misura della consistenza / best day** | FTMO 50% · E8 40/35% · FundedNext 40% | ❌ **NO** — non lo misuriamo neanche a posteriori |
| 28 | **allarme di avvicinamento** al limite (non solo alla violazione) | PROPstyle · Take a Break | ❌ **NO** |
| 29 | **notifiche push/email/Telegram** | tutti | ❌ **NO** |
| 30 | **cap sulle richieste al server** (FTMO: 2.000/giorno) | FTMO | ❌ **NO** — [INCERTO] quante ne facciamo |
| 31 | **BUDGET DI DD RIDOTTO quando l'EA condivide il conto** (9%→4%) | Gold Phantom `Propfirm_combo` | ❌ **NO** — ogni sedia gira col rischio pieno come se fosse sola |
| 32 | **pausa MORBIDA di N giorni** a una soglia sotto il muro duro | Prop Firm Pass (`InpDailyDDPausePercent=4`, `InpDailyDDPauseDays=1`) | ❌ **NO** — abbiamo un solo livello, e sta sul muro |
| 33 | **randomizzazione degli ingressi** per non risultare "strategia identica" | Gold Phantom (`Randomization=50`) · Gold Reaper · Prop Firm Pass (`InpBuy/SellEntryRandomPoints`) · Gold Atlas | ❌ **NO** — e FTMO ($400k/strategia) ed E8 (1 strategia/utente) lo misurano |
| 34 | **auto-rilevamento dell'offset GMT del broker** | Gold Phantom (`AutoGMT=true`, `Broker_GMT_OFFSET_Winter=2` / `Summer=3`) | ❌ **NO** — i nostri orari sono **cablati in ora server BCM** |
| 35 | **azione al raggiungimento del TARGET** (lock / reset / pausa un giorno) | Prop Firm Pass (`InpTargetAction`) | ❌ **NO** — non abbiamo neanche il concetto di target |
| 36 | **cancellazione dei pendenti fuori orario** | Prop Firm Pass (`InpCancelPendingOutsideHours=true`) | ⚠️ **[INCERTO]** EA per EA |

### 📐 Il conto

**36 meccanismi censiti. Ne abbiamo interi 4 (nn. 1, 2, 3, 23), parziali 6
(6, 12, 20, 22, 24, 36). Ne mancano 26.**

Ma il numero da solo mente: molti dei 26 sono nastro adesivo. **I sette che
contano davvero, coi numeri copiabili accanto, sono nelle proposte.**

---

# 📋 PARTE 4 — LE PROPOSTE

_Nessuna si applica da sola. Vanno in lista, decide Claudio, e comunque prima
passano dall'imbuto come qualunque modifica._

Vedi il file separato: **`PROPOSTE_PROP_2026-08-18.md`** (stessa cartella).

---

## 🕳️ COSA NON HO POTUTO VEDERE — i buchi dichiarati

1. **Nessuna pagina ufficiale di prop aperta.** Sei prop censite interamente
   in [LETTO-VIA-SEARCH]. Le percentuali dei muri sono coerenti fra piu'
   ricerche indipendenti, ma **una regola letta male squalifica un conto
   vero**: prima di qualunque acquisto valgono solo le risposte scritte del
   supporto.
2. **Offset del server di The5ers e di E8**: dichiarano "00:00 ora server"
   senza dire quale. **[INCERTO]** — e senza quello non si converte in ora BCM.
3. **Ricerca su GitHub**: `api.github.com/search` e' repo-scoped, `github.com`
   ha risposto **429 con `Retry-After: 3600`**. Ho letto **due** sorgenti/README
   via `raw.githubusercontent.com` invece dei 2-3 repo previsti; **non ho letto
   nessun `.mq5` completo di guardiano open source**, solo i README.
4. **File `.set` pubblici**: **non ne ho trovato nemmeno uno** con valori.
   Forex Factory e' 403; i vendor MQL5 non pubblicano i default nelle pagine
   prodotto. **La tabella 1A ha 6 righe, non le 15-20 che speravo.**
5. **Numeri di performance dei vendor**: letti, **non riportati**, per regola.
6. **Le regole di consistenza di E8** vengono da fonti terze, non dal loro
   help center: **[INCERTO]**.
