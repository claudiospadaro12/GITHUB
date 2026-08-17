# 📦 RACCOLTA `.set` — la seconda notte del cacciatore-config-prop

_18/08/2026, notte. Missione dettata da Claudio: **"speriamo che trovino
parametri, settaggi in giro per il web da poter prendere spunto ed analizzare"**.
Una cosa sola: **allargare il campione dei `.set` veri e dei valori copiabili.**_

> ⛔ Nessun acquisto proposto. Nessuna modifica applicata a niente.
> ⛔ Nessun numero di performance dei vendor usato come criterio.
> 📚 **Tutto il materiale e' depositato in `biblioteca/`** e indicizzato nel
> `CATALOGO.md`: le pagine spariscono (ne e' sparita una stanotte, §7).

**Questo file e' il seguito di `CONFIG_PROP_2026-08-18.md`** (prima notte:
3 preset, censimento 6 prop, 36 buchi). Qui ci sono i **44 `.set` nuovi**.

---

## 0. 🔌 CONTROLLO POSITIVO — fatto prima di partire, fonte per fonte

| fonte | prova | esito |
|---|---|---|
| `c.mql5.com` | riscaricato `propfirm__1.set` gia' noto (Gold Reaper) | ✅ **HTTP 200, 2.009 byte, contenuto identico** |
| `www.mql5.com` | pagina Market Bneu 172892 | ✅ HTTP 200, 250.956 byte |
| `raw.githubusercontent.com` | README del kernel Linux | ✅ HTTP 200 |
| ricerca interna di MQL5 (`/en/search?keyword=`) | pagina servita ma **vuota di risultati** (e' JS) | ❌ **NULLA** — si passa da `WebSearch` ristretto a `mql5.com` e poi si apre la pagina |
| `www.mql5.com/en/blogs/post/768516` ("The Impossible Gold — Prop Firm Settings Guide") | | ❌ **HTTP 302 -> `/en/blogs`: LA PAGINA NON C'E' PIU'** (esiste ancora nell'indice di ricerca) |
| `www.mql5.com/en/blogs/post/767571` ("Prop Firm Hedge Master") | | ❌ HTTP 302, pagina rimossa |

Metodo: ogni pagina scaricata con `curl`, poi **grep dei link
`c.mql5.com/**.set|.zip|.mqh|.csv`**. Nessun path inventato: ogni URL in questo
file ha restituito un HTTP 200 con byte veri, e il file e' in biblioteca.

---

# 1. 🥇 IL BOTTINO — 44 `.set` nuovi, letti riga per riga

| famiglia | n. file | fonte (aperta il 18/08) | cosa contiene di prop |
|---|---:|---|---|
| **Range Breakout Daytrader** | **32** | blog MQL5 `760349` | 4 livelli di rischio × 4 simboli × piu' versioni; filtro news a **5 min** con calendario Forex Factory |
| **Ultimate EA for Prop Firms** | **8** | blog MQL5 `752189` | **Phase 1 / Phase 2 / Funded** dello stesso EA |
| **The Impossible Prop** | **4** | blog MQL5 `769728` | sezioni PROTECTION / NEWS / SHIELD / PROP FIRM / PARALLEL AWARENESS |
| **FTMO Smart Trader** | **6** | blog MQL5 `765121` | cap giornaliero in **valuta**, moltiplicatore lotti |
| _(riscaricati e depositati dalla prima notte)_ | 13 | c.mql5.com | Gold Reaper 1 · Gold Phantom 7 · Prop Firm Pass 5 |

Piu' **2 sorgenti gratuiti completi**, **6 schede** e **2 calendari news CSV**.

## 1A. ⭐ `The Impossible Prop` — il preset piu' istruttivo trovato finora

`biblioteca/set/TheImpossibleProp_v2.0-EURUSD_*.set` · [VERIFICATO 18/08]
File con **intestazione commentata riga per riga**: per ogni parametro cambiato
c'e' il PERCHE' quantitativo. Valori veri:

```
; === RISK ===            RiskPerTrade=0.5      MaxLotSize=10.0   MagicNumber=88800
; === PROTECTION ===      MaxDrawdown=0.0   MaxDailyLoss=0.0   (spenti: li fa il blocco PROP)
                          MaxOpenTrades=1   MaxTradesPerDay=10   MaxConsecLosses=0
; === NEWS FILTER ===     EnableNewsFilter=true   NewsMinutesBefore=30   NewsMinutesAfter=15
; === SHIELD ===          EnableShield=true   ShieldArmPct=5.0   ShieldDrawdownPct=3.0
                          ShieldRecovery=1 (=next day)   ShieldRecoveryPct=50.0
; === PROP FIRM ===       EnablePropFirm=true   PropMaxDD=10.0   PropDailyDD=5.0
                          PropPhaseTargetPct=10.0
; === PARALLEL ===        EnableParallel=true   SiblingSymbol=GBPUSD   SiblingMagic=88801
                          BlockIfSiblingHalted=true   BlockIfSameDir=false
                          MaxCombinedTradesDay=0        SiblingStaleSec=30
; === SESSION ===         SessionStart=8  SessionEnd=16  ExcludeStart=12  ExcludeEnd=14
```

⏰ **Fuso dichiarato:** _"Trading is restricted to configurable **GMT** session
hours"_. Quindi `SessionStart=8` = **08:00 UTC = 09:00 ora server BCM** in agosto
(BCM = italiana − 1 = UTC+1). **Il primo preset trovato che dichiara il fuso.**

### 🔴 Le due righe che colpiscono direttamente il PIANO_PROP

**(a) La matematica del rischio combinato — riga C1.** Dalla guida, parola per
parola:
> _"**Combined risk math**: at the shipped **0.75%** RiskPerTrade per EA,
> worst case where both pairs lose simultaneously equals **0.75 × 2 = 1.5%**
> account risk per concurrent loss event — well under the 5% daily DD limit even
> in correlated stop runs."_
> _"**Both EAs share the daily DD budget when running in parallel.** ... If you
> only run **one** EA (single pair), you can **raise RiskPerTrade to 1.0–1.25%**."_

E' esattamente il conto che a noi manca (8 sedie × 0,65% = **5,2% > muro 5%**),
fatto da un venditore che **sceglie di fermarsi a 2 EA** per restare a 1,5%.

**(b) Il canale di blocco fra EA — riga B6.** Il PIANO_PROP dice che il canale
per la "pausa morbida" **non esiste**. Qui c'e' un progetto funzionante e
gratuito da copiare come idea:
> _"Each instance broadcasts **seven fields every tick via terminal-local
> GlobalVariables**, and the sibling reads them with built-in **staleness
> detection (default 30s)**"_ — battito, n. posizioni aperte, direzione, trade
> di oggi, P&L di oggi, P&L totale, **stato di halt**.
> _"no external coordinator, no shared file with locking issues"_

**Il nostro Guardian gia' scrive GlobalVariable** (`BLOCKDAY`/`FAILED`): manca
solo che gli EA le LEGGANO, e manca il **battito con staleness** (se il Guardian
muore, gli EA devono accorgersene).

## 1B. ⭐ `Ultimate EA for Prop Firms` — l'unico con i TRE STADI

`biblioteca/set/UltimateEAPropFirms_*.set` (UTF-16) · [VERIFICATO 18/08]

| parametro | **Phase 1** | **Phase 2** | **Funded** |
|---|---:|---:|---:|
| `riskPercentage` | **1,0** | **1,0** | **1,0** |
| `profitTargetPercentage` | **8** | **5** | **2** |
| `dailyDrawdownPercentage` | **4,9** | **4,9** | **4,9** |
| `monthlyDrawdownPercentage` | 11,0 / 12,0 | 11 | 11,5 |
| `recuperoPerdita` | false | false | **true** |
| `restartMensile` | true | true | false |

> ### 🔴 RISPOSTA ALLA RIGA **A3** DEL PIANO ("taglia in fase 2: dimezzare?")
> **Questo vendor NON tocca il rischio per trade fra fase 1 e fase 2.**
> Cambia **solo il target** (8 → 5 → 2). Il PIANO_PROP A3 ha oggi UNA fonte
> (blog E0-bis: "fase 2, lotto dimezzato"). **Ora ne ha una CONTRARIA, e piu'
> forte** — perche' e' un file di configurazione, non una frase.
> **A3 resta APERTO, ma da "una fonte a favore" passa a "1 contro 1".**

E la riga del manuale che vale il giro, parola per parola:
> _"Daily Drawdown -> the maximum daily drawdown imposed by the rules of the prop
> firm you are doing. **Advice: keep it slightly lower than the rule to have some
> margin in case of fast price movements (Ex: if the prop imposes a 5% daily dd,
> set this option to max 4.9)**."_

⚠️ **Il motore va scartato**: ha input `martingala` e una modalita' **TIME GRID**
(griglia a lotto fisso, `maxTrades=15`, senza SL individuali, con TP/SL
aggregati all'1%/2%). **Si copia la configurazione, non il motore.**

## 1C. ⭐ `Range Breakout Daytrader` — 32 preset, ed e' la NOSTRA famiglia

`biblioteca/set/RangeBreakoutDaytrader_*.set` (UTF-16) · [VERIFICATO 18/08]
Breakout del range intraday su **USDJPY, US30, XAUUSD, BTCUSD** — cioe' lo
stesso mestiere delle nostre sedie di apertura.

**La scala di rischio, identica su tutti e quattro i simboli:**

| profilo | `RiskPercentage` | `_MaxLoss` |
|---|---:|---:|
| **ExtraLowRisk** (quello consigliato per la prop) | **2,4** | **2,4** |
| LowRisk | 4,7 – 4,8 | 4,7 – 4,8 |
| MediumRisk | 10 | 10 |
| HighRisk | 20 | 20 |

I quattro profili di uno stesso simbolo differiscono **SOLO** su questi due
parametri — e i due sono **sempre tenuti uguali fra loro**. Orari, filtri,
trailing e news sono **identici**. (Stessa regola dei 5 preset di Prop Firm
Pass: l'aggressivita' si cambia nel motore o nella taglia, **mai** nelle
protezioni.)

**Filtro news, uguale su tutti i 32 file:**
```
HighImpactNewsFilter=true    ModImpactNewsFilter=false    TimeToClose=5
FFCalendar=true    FFURL=https://nfs.faireconomy.media/ff_calendar_thisweek.xml
NewsUpdateFreq=60    IgnoreNews=Crude oil
ReportForUSD/EUR/GBP/... (un toggle per valuta)
```
`TimeToClose=5` = **minuti prima della news in cui chiude posizioni E pendenti**.

**Orari e chiusura di sessione** (ora del server dell'autore, UTC+2, con input
`TimeOffset` per correggere):

| simbolo | inizio range | fine range | `InpSessionEndH` |
|---|---|---|---|
| USDJPY | 01:00 | 13:50 | **20:00** |
| US30 | 01:00 | 13:50 | **22:00** |
| XAUUSD | 02:00 | — | **17:00** |
| BTCUSD | 04:00 | — | **17:00** |

`InpClosingSession=true` ovunque = **chiusura programmata di fine sessione**.
Noi non ce l'abbiamo in nessuna sedia.

### 🔴 E qui c'e' il **buco n.8** che la prima notte risultava DI NESSUNO

Il manuale, parola per parola:
> _"it's recommended to **start with the EXTRA LOW RISK settings and switch to
> the LOW RISK once the balance has grown enough. But once the profit drops below
> zero, then make sure to switch back to the EXTRA LOW RISK settings**."_

E:
> _"Make sure that the **max. equity drawdown percentage is lower than the daily
> allowed drawdown** for the challenge."_

## 1D. `FTMO Smart Trader` — il preset da NON copiare (e per cui vale la pena)

`biblioteca/set/FTMOSmartTrader_*.set` · [VERIFICATO 18/08]

| parametro | Conservative | Moderate | Aggressive |
|---|---:|---:|---:|
| `Lots` | 0,01 | 0,05 | 0,10 |
| `MAX_LOTS` | 0,1 | 0,5 | 1,0 |
| **`DOWN_LOTS`** (moltiplicatore) | **1,01** | **1,50** | **2,02** |
| **`DAILY_DD_`** | **−500** | **−1000** | **−2000** |
| `equity_stop` | 0 (**spento**) | 0 | 0 |
| `Monday` / `Friday` | 1 / 0 | 1 / 1 | **0** / 1 |

Tre cose, tutte utili come **contro-esempio**:
1. 🚩 **`DOWN_LOTS` e' un moltiplicatore di recupero**: 2,02 = raddoppio.
   Il preset "Conservative", cioe' quello venduto per la challenge, lo mette a
   **1,01** — praticamente lo **spegne**. Tradotto: _il preset prop di questo
   EA e' "il mio EA, con la martingala disinnescata"._
2. 🚩 **`DAILY_DD_` e' in VALUTA, non in percentuale.** −500 / −1000 / −2000.
   Su un conto da 100k sono 0,5% / 1% / 2%; su uno da 10k sono 5% / 10% / 20%.
   **Lo stesso file passa o sfonda a seconda della taglia del conto.** E' il
   difetto di progetto piu' pericoloso visto stanotte, e i vendor lo fanno.
3. `Monday=0` in Aggressive, `Friday=0` in Conservative: **filtro per giorno
   della settimana usato come protezione**, non come edge.

## 1E. 📋 Le altre configurazioni con valori, dalle guide (nessun `.set`)

| fonte | valori dichiarati | cosa aggiunge |
|---|---|---|
| **Prop Firm Gold EA** (Eriksson Systems) `blogs/post/765213` | _"if max allowed is 5%, **set it to 4%**"_ · _"1% risk -> **up to ~3% total daily loss**" (max 3 trade/giorno)_ · _"divide total account risk equally across multiple EAs"_ | 2ª fonte **davvero indipendente** del 4% + l'aritmetica del giorno |
| **Guida impostazioni comuni** `blogs/post/772732` (17/07/2026) | **Safety Buffer = 0,10 punti** (5,00→**4,90**, 10→**9,90**) · **Best Day Rule 50%** · **Minimum Trading Days 4** · **Challenge Start Date** · news **30 prima / 30 dopo**, con **chiusura dell'aperto a 10 min** (parametro separato) | 3ª fonte del buffer, e la **consistenza misurata DENTRO l'EA** |
| **EquityGuard AI** `blogs/post/767554` | `Maximum Drawdown %` **default 4,5** su picco di equity · **`Warning at % of Threshold` default 80** (= allarme a 3,6%) · soglie alternative in **valuta** e **equity minima** | l'**allarme di avvicinamento** (buco n.28) con un numero |
| **The Impossible Bullion** `blogs/post/770314` | `PropYellowPct`/`PropRedPct`/`PropDeadPct` + **`YellowRiskMult`/`RedRiskMult`** + `Yellow/RedMaxTrades` + `Yellow/RedMinScore` · `PropDDMode = DD_STATIC_INITIAL` \| **`DD_TRAILING_HWM`** · `PropStartBalance=0` = auto-ricostruzione dallo storico | 🔴 **il buco n.8 tappato per la seconda volta**, qui in AUTOMATICO e a **tre manopole** |
| **Ultimate EA** manuale | `profitTarget` raggiunto -> _"no more trades will be opened in the current month"_ · funded: _"non andare oltre il **3%** al mese"_ | 2ª fonte dell'azione al target |

---

# 2. 🧮 LA CONVERGENZA — e le due DIVERGENZE che vanno dette

## 2A. ✅ Converge: **il guardiano sta PRIMA del muro, mai SUL muro**

**Sette fonti, di cui almeno cinque indipendenti**, lo dicono con un numero:

| fonte | cap giornaliero interno | buffer sotto il muro del 5% |
|---|---:|---:|
| Gold Reaper `propfirm` (Profalgo) | 4,0 | **1,0 pt** |
| Gold Phantom `Propfirm` (Profalgo) | 4,0 | **1,0 pt** |
| **Prop Firm Gold EA** (Eriksson) | 4,0 | **1,0 pt** |
| EquityGuard AI (default) | 4,5 | **0,5 pt** |
| Ultimate EA (manuale, esplicito) | 4,9 | **0,1 pt** |
| Guida impostazioni comuni | 4,90 | **0,10 pt** |
| Prop Firm Pass (`InpSafetyBufferPercent`) | 4,0 (pausa) + buffer 0,1 sul muro | **0,1 pt** |
| _(script CrewAI, dal PIANO v1.1)_ | 4,3–4,5 | 0,5–0,7 pt |
| The Impossible Prop | **5,0 esatto** | **0** — ma con lo **Shield** su un asse diverso |

**Il nostro preset mette 5,0 e 10,0: esattamente sul muro. Siamo l'unico caso.**

## 2B. ⚠️ DIVERGE: **quanto** dev'essere il buffer — e va corretto il PIANO

Il `PIANO_PROP` B1/B2 propone **4,0 / 9,0** citando _"convergenza tre vendor
indipendenti"_. **Due delle tre non sono indipendenti.**

🔎 **Prova, verificata stanotte:** il file `GoldPhantom_Propfirm.set` dichiara in
testa l'EA **`The_Gold_Phantom_V1.0_WSC`** — **WSC = Wim Schrynemakers**, cioe'
**Profalgo Limited**, lo stesso autore di The Gold Reaper (confermato sulla
pagina Market `product/161561`: venditore Wim Schrynemakers — Profalgo Limited).
I due preset condividono **l'intera lista di input** (`PropFirmMaxDailyDD`,
`MaxAllowedDD`, `TradeFrequency`, `Randomization`, `OnlyUp`, `CheckMargin`,
`UseEquity`, `StartLots`): **e' lo stesso framework, non due opinioni.**

Quindi la vera fotografia e':

- **PRINCIPIO** ("prima del muro"): **convergenza fortissima**, 5+ fonti
  indipendenti. **Il PIANO ha ragione al 100% sulla direzione.**
- **VALORE** del buffer: **DIVERGE per un fattore 10.**
  - **1,0 punto** (4/9): Profalgo (1 fonte, 2 prodotti) + Eriksson (1 fonte).
  - **0,1 punto** (4,9 / 9,9): Ultimate EA + guida impostazioni comuni + Prop
    Firm Pass. **Tre fonti indipendenti.**
  - **0,5 punto**: EquityGuard AI + script CrewAI.

> 📌 **Cosa cambia per Claudio:** B1/B2 restano **da fare** (siamo sul muro, e
> quello e' certo sbagliato), ma il **4/9** non e' "quello che dicono tutti".
> Chi mette 4 lo fa perche' **ferma l'EA per la giornata**; chi mette 4,9 lo fa
> perche' **e' solo il margine contro spread/slippage/commissioni in chiusura**
> (lo dice esplicitamente la guida 772732: _"the buffer helps reduce the risk of
> violating the official limit because of spread, commission, swap, slippage,
> execution delay, or equity movement during position closure"_).
> **Sono due meccanismi diversi che il PIANO oggi confonde in uno.**
> La forma giusta e' quella di Prop Firm Pass: **due livelli** — pausa morbida a
> 4,0 · chiusura d'emergenza a 4,9 (muro 5 − 0,1 tecnico).

## 2C. ✅ Converge: **il budget di DD si DIVIDE fra gli EA del conto**

**Quattro fonti indipendenti**, ed e' la falla aritmetica del nostro portafoglio:

| fonte | come lo dice |
|---|---|
| Gold Phantom `Propfirm_combo` (Profalgo) | `MaxAllowedDD` **9 → 4** quando l'EA condivide il conto |
| **The Impossible Prop** | _"Both EAs **share the daily DD budget**"_; 0,75 × 2 = 1,5%; da solo **1,0–1,25%** |
| **Prop Firm Gold EA** (Eriksson) | _"**Divide total account risk equally across multiple EAs**"_ |
| _(prima notte)_ PROPstyle · NYAO | `MaxTotalRiskPercent=1.0` · `SL × maxpos ≈ basket stop` |

**Noi facciamo l'opposto**: ogni sedia gira col rischio pieno come se fosse sola.

## 2D. ✅ Converge: **rischio per trade** — e noi siamo nella norma

| fonte | rischio/trade dichiarato per conto prop |
|---|---:|
| blog "Best EA Settings" (1ª notte) | 0,25 – 0,4% |
| Prop Firm Pass `InpPercentageRiskOfAccount` | **0,5** |
| The Impossible Prop v2.0 (preset) | **0,5** (guida: 0,75 di listino) |
| **NOI** | **0,65** |
| Ultimate EA (manuale: _"usually 1% is risked"_) | **1,0** |
| Range Breakout ExtraLowRisk | **2,4** ⚠️ |

**Lo 0,65% di casa sta nel corpo della distribuzione.** Nessuna fonte di
stanotte lo mette in discussione. ⚠️ Ma vale solo per **una sedia**: il problema
e' la somma (§2C).

## 2E. ⚠️ DIVERGE: **le finestre news** — e le due famiglie non vanno mescolate

| fonte | prima | dopo | cosa fa |
|---|---:|---:|---|
| **Regolamenti prop** (1ª notte, [LETTO-VIA-SEARCH]) | 2 / 5 / 10 min | idem | e' un **obbligo** |
| Range Breakout `TimeToClose` | **5** | — | chiude aperto + pendenti |
| The Impossible Prop | **30** | **15** | blocca ingressi |
| Guida impostazioni comuni | **30** (chiusura a **10**) | **30** | due parametri distinti |
| `NewsFilter.mqh` (gratuito) default | **60** | **60** | blocca ingressi |
| Gold Phantom NFP (1ª notte) | **100** | **60** | chiude tutto |

> **Sono DUE cose diverse, e il PIANO le tiene gia' separate (D1 vs D2) — bene.**
> **D1 (conformita')** = 2–10 min, lo detta il regolamento.
> **D2 (protezione)** = 15–100 min, **cambia l'edge** e non e' misurabile
> a occhio. Il campione di stanotte, per D2, va da 5 a 100: **nessuna
> convergenza**, quindi nessun numero da copiare.

---

# 3. 🔴 IL RITROVAMENTO PIU' IMPORTANTE: il filtro news **E' backtestabile**

Il `PIANO_PROP` D1 e' bloccato da questa riga: _"🔴🔴 **non backtestabile**:
`CalendarValueHistory()` non risponde nello Strategy Tester ([VERIFICATO]) —
l'imbuto di casa non si applica"_.

**Il fatto resta vero, la conclusione no.** Dal manuale di Range Breakout
Daytrader, parola per parola [VERIFICATO 18/08]:

> _"If you want to use the news filter in back testing, you have to **save the
> MT5 economic calendar as a CSV-file in the Common/Files directory** for the
> time period you want to test."_
> _"Another advantage of this EA is that it **can also do back testing with the
> news filter on**... Doing back tests with avoiding high impact news releases
> will give **more realistic results**."_

**Non risponde la FUNZIONE dentro il tester. Il CALENDARIO si esporta una volta
dal terminale vivo (dove la funzione risponde) e si rilegge da file.**

E il file, pubblico e gia' scaricato, e' in biblioteca:

| file | righe | periodo | formato |
|---|---:|---|---|
| `CALENDARIO_news-2022-2025_UTC+2_...csv` | 17.413 | 2022.01.01 → 2025.12.26 | `data ora;paese;impatto;evento` |
| `CALENDARIO_news-2021-2024_UTC+2_...csv` | 20.386 | 2021.01.01 → 2024.12.31 | idem |

Impatto: `3` = alto (2.335 eventi nel primo file), `2` = medio, `1` = basso,
`0` = festivita'.

⏰ **Fuso [VERIFICATO per ricalcolo]:** gli orari sono in **UTC+2**. Prova: `ISM
Manufacturing PMI` (rilascio 10:00 EST = 15:00 UTC d'inverno) e' scritto
**17:00**; `ADP` (08:15 EST = 13:15 UTC) e' scritto **15:15**. Coerente col
manuale che parla di _"correct time from GMT/UTC+2"_.
👉 **Su BCM (UTC+1 in agosto) va tolta UN'ORA.**

E il **codice per leggere il calendario dal vivo e' gia' in biblioteca**, con
sorgente completo e gratuito: `sorgenti/NewsFilter_IvanPochta_*.mqh`, 283 righe,
`CalendarValueHistory` + `CalendarEventById`, filtro per valuta e per importanza,
cache ogni 3600 s, **zero DLL e zero WebRequest** (l'autore spiega perche' evita
Forex Factory: _"WebRequest is blocked on VPS, websites change layouts, Strategy
Tester cannot reproduce them, Market validation rejects them"_).

---

# 4. 🕳️ LA TABELLA DEI BUCHI — cosa cambia rispetto alla prima notte

| # | meccanismo | stato dopo la 1ª notte | **stato dopo la 2ª** |
|---|---|---|---|
| **8** | **riduzione del rischio vicino al muro** | ❌ NO — _"nessun prodotto letto lo dichiara"_ | 🔴 **TROVATO, due volte**: Bullion (zone Yellow/Red con `YellowRiskMult`/`RedRiskMult` + cap trade + soglia di qualita') · Range Breakout (scala manuale ExtraLow↔Low legata al cuscinetto) |
| **11** | **filtro NEWS** | ❌ NO, e "non backtestabile" | 🟡 **il pezzo mancante c'e'**: modulo `.mqh` gratuito in biblioteca + due CSV di calendario che **rendono il filtro backtestabile** |
| **28** | **allarme di avvicinamento** | ❌ NO | 🟡 **numero trovato**: EquityGuard `Warning at 80% of threshold` · PropGuard `InpWarningThresholdPercent=10` (% di budget residuo) |
| **26/27** | giorni di trading · consistenza best-day | ❌ NO | 🟡 **misurati DENTRO l'EA** da un vendor: `Best Day Rule Max=50%`, `Minimum Trading Days=4`, e un `Challenge Start Date` per non contare lo storico vecchio |
| **13** | cap sul rischio APERTO totale | ❌ NO | 🔴 **4 fonti indipendenti** che lo impongono (§2C) — resta il buco piu' grave |
| **17** | max posizioni simultanee | ❌ NO | 🟡 valore trovato: TIP `MaxOpenTrades=1`, `MaxTradesPerDay=10` |
| **12** | chiusura programmata | ❌ NO | 🟡 `InpClosingSession=true` + ora, su 32 preset su 32 |
| **NUOVO** | **coordinamento fra EA sullo stesso conto** (battito + halt + staleness) | non censito | 🔴 **progetto completo e gratuito** in TIP: 7 campi su GlobalVariable, `BlockIfSiblingHalted`, `SiblingStaleSec=30` |
| **NUOVO** | **cap giornaliero espresso in VALUTA invece che in %** | non censito | 🚩 **anti-pattern**: FTMO Smart Trader lo fa, e lo stesso file passa o sfonda a seconda della taglia del conto |

---

# 5. 📌 COSA GUADAGNA (E COSA NO) OGNI RIGA DEL PIANO_PROP

| riga | guadagna una gamba? | cosa e' cambiato stanotte |
|---|---|---|
| **B1** cap giornaliero interno 4,0% | ✅ **SI', il principio · ❌ NO, il valore** | +2 fonti sul "prima del muro" (Eriksson 4%, EquityGuard 4,5). **MA**: Gold Reaper e Gold Phantom sono **lo stesso autore** (Profalgo/WSC, provato dal nome file `_WSC` e dalla lista input identica) → la "convergenza tre vendor" citata nel PIANO e' in realta' **due**. E tre fonti indipendenti usano **0,1 pt**, non 1,0. 👉 **Riscrivere B1 come DUE livelli**: pausa morbida 4,0 · chiusura 4,9 |
| **B2** cap totale interno 9,0% | ✅ principio · ⚠️ valore | stesso discorso: il 9 viene da **una** casa (Profalgo). Le fonti a buffer sottile direbbero **9,9** |
| **B3** `InpDailyResetHour=23` | ❌ **NESSUNA gamba nuova** | nessun `.set` di stanotte dichiara un'ora di reset del muro. **TIP dichiara il fuso di SESSIONE (GMT), non del reset.** ⚠️ **Il campione dice pero' una cosa nuova e utile: gli EA prop-ready NON hanno affatto un input di reset del muro** (solo Prop Firm Pass ce l'ha, `InpDailyResetHour/Minute`). Resta [INCERTO], si chiude solo col supporto |
| **B6** pausa morbida 2,5% | ✅ **SI', e il meccanismo pure** | il PIANO diceva _"il canale di blocco non esiste"_. **TIP lo ha**: GlobalVariable + battito + `SiblingStaleSec=30` + `BlockIfSiblingHalted`. E la soglia a 2 livelli e' confermata da Prop Firm Pass |
| **C1** cap sul rischio aperto | ✅ **SI', due gambe forti** | TIP fa il conto esplicito (0,75×2=1,5% < 5%) e **si ferma a 2 EA**; Eriksson fa 1%×3 trade = 3%. **Ma i VALORI restano divergenti** (PROPstyle 1%, Bneu 3%): C1 **resta APERTO**, e la chiusura resta la misura M2 |
| **C4** budget DD per sedia condivisa | ✅ **SI', da 1 fonte a 3** | Profalgo (9→4) + TIP ("share the budget", e per una sedia sola si sale a 1,0–1,25%) + Eriksson ("divide equally"). 👉 **la regola implicita: rischio per sedia ≈ budget totale ÷ n. sedie** |
| **C5 / F3** DD trailing | ⚪ neutro | Bullion conferma i due modelli (`DD_STATIC_INITIAL` / `DD_TRAILING_HWM`) e avverte _"use the firm's actual rule wording, not marketing shorthand"_. **Nessuna Monte Carlo trailing: il blocco resta** |
| **D1** filtro news di conformita' | ✅✅ **SI', la gamba piu' grossa della notte** | (a) **modulo gratuito completo** gia' in biblioteca; (b) **il "non backtestabile" cade**: calendario esportato in CSV in `Common/Files`, e **due CSV pubblici sono gia' scaricati** (2021-2025, impatto 0-3, fuso UTC+2 verificato) |
| **D2** filtro news di protezione | ❌ **NO** | il campione va da 5 a 100 minuti: **nessuna convergenza**. La cautela del PIANO ("non accenderla senza decisione") **e' confermata dai numeri** |
| **D3** Auto-GMT | 🟡 mezza gamba | TIP dichiara le sessioni in **GMT** (non in ora broker) e Range Breakout ha un input `TimeOffset` per correggere da UTC+2: **due modi diversi di risolvere lo stesso problema**, entrambi con l'offset come INPUT, mai cablato |
| **A1** rischio 0,65% | ⚪ confermato per contorno | 0,5 · 0,5 · **0,65** · 0,75 · 1,0: siamo dentro. **Congelato, e nessuna misura nuova lo contraddice** |
| **A3** taglia in fase 2 | 🔴 **PEGGIORA (ed e' un bene saperlo)** | l'unica fonte diceva "dimezzare". **Ultimate EA, coi file alla mano, NON cambia il rischio fra fase 1 e 2** — cambia solo il target (8→5→2). Ora e' **1 contro 1** |
| **E3** consistenza / best day | ✅ **SI'** | un vendor la **misura dentro l'EA** (`Best Day Rule Max=50%`), con `Minimum Trading Days=4` e `Challenge Start Date` |

---

# 6. 🚩 IL SETACCIO — cosa NON si copia, di quello che ho letto

| EA | bandiera |
|---|---|
| **Ultimate EA for Prop Firms** | input `martingala` + **TIME GRID** (fino a 15 trade a lotto fisso, senza SL individuali) |
| **FTMO Smart Trader** | `DOWN_LOTS` fino a **2,02** = raddoppio dopo la perdita; `equity_stop=0` (spento in tutti e 6 i preset) |
| **vendor della guida 772732** | `Drawdown Recovery` con **`Multiplier After Loss=2,0`** e `Max Lot for Recovery=20,48` |
| The Impossible Prop / Bullion / Range Breakout / Prop Firm Gold | **nessuna bandiera trovata** nelle pagine lette (SL per trade, niente moltiplicatori dichiarati) — [INCERTO], non ho il sorgente |

> **Su 8 famiglie lette stanotte, 3 hanno un moltiplicatore di recupero
> dichiarato nei parametri.** "Prop-ready" continua a non voler dire "senza
> recovery". Nota che fa riflettere: **il preset "prop" di questi EA e' spesso
> il preset normale con la martingala disinnescata** (`DOWN_LOTS` 2,02 → 1,01).

---

# 7. 🕳️ COSA NON HO POTUTO VEDERE

1. **`blogs/post/768516`** — "The Impossible Gold — **Prop Firm Settings Guide**",
   che l'indice di ricerca descrive come _"ogni parametro col suo valore di
   default E il valore prop-adjusted, piu' un `.set` scaricabile"_: **sarebbe
   stato il file migliore della notte.** HTTP **302 → `/en/blogs`**: rimossa.
   Idem `767571`. **Le pagine spariscono: e' la giustificazione della biblioteca.**
2. **La ricerca interna di MQL5 non e' usabile** (JS): tutti i ritrovamenti sono
   passati da `WebSearch` ristretto a `mql5.com` + apertura diretta. **Non ho
   modo di sapere quanto del sito NON ho visto.**
3. **I commenti dei prodotti Market non sono stati spulciati** uno per uno (li'
   girano `.set` "prop" nelle risposte del venditore): resa potenziale alta,
   costo alto.
4. **GitHub**: `api.github.com/search` resta repo-scoped. `raw.githubusercontent`
   risponde, **ma senza ricerca non ho path da provare** e **non invento URL**.
   Nessun repo nuovo stanotte. Le due sorgenti gratuite vengono da MQL5.
5. **Nessuna pagina ufficiale di prop** (403): tutto il §2 dei regolamenti resta
   [LETTO-VIA-SEARCH] della prima notte. **Nessuna riga qui autorizza un
   acquisto.**
6. **The Impossible Bullion non pubblica i valori** (lo dichiara): del sistema a
   zone conosco i NOMI degli input e la logica, **non le soglie**. [INCERTO].
7. Il `.set` di **Prop Firm Gold EA** (voce M8.3 del PIANO) **non esiste
   pubblicamente**: c'e' il manuale, non i valori.

---

# 8. 📊 IL CONTO DELLA NOTTE

- **44 file `.set` nuovi** scaricati e letti (32 + 8 + 4 + 6, meno i 6 conteggiati
  a parte) → **50 `.set` totali in biblioteca** contando i 13 riscaricati della
  prima notte.
- **11 pagine** aperte con contenuto vero · **2 morte** (302) · 1 canale nullo
  (ricerca interna).
- **2 sorgenti gratuiti completi** (969 righe in tutto) · **6 schede** ·
  **2 calendari news** (37.799 righe).
- **4 righe del PIANO guadagnano una gamba** (B6, C1, C4, D1, E3 = 5) ·
  **2 non ne guadagnano** (B3, D2) · **1 peggiora onestamente** (A3) ·
  **1 va corretta nell'evidenza** (B1/B2: la "convergenza a tre" e' a due).
