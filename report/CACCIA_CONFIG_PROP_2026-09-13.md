# 🏹 CACCIA ALLE CONFIGURAZIONI PROP — dossier del 13/09/2026

> ⏱️ **Nota di data, dichiarata per onestà**: l'orologio di sessione dice
> **12/09/2026**. Il file porta la data **13/09** perché è la caccia del sabato
> commissionata per quel giorno. **Ogni pagina citata è stata aperta OGGI**, e
> la data di lettura scritta in tabella è **12/09/2026**.

🔒 **NON È STATO TOCCATO NULLA**: nessun EA, nessun preset, nessun `.set`,
nessun parametro in forward, niente comprato, nessuna iscrizione. Questo file
è **un dossier**; le proposte del §6 sono **[FIRMA DI CLAUDIO]**, non azioni.

---

> # 🎯 LA RIGA CHE CONTA
>
> **Ho letto il SORGENTE di 9 strumenti prop/rischio pubblicati fra marzo e
> settembre 2026 e il codice di 3 articoli MQL5, e il numero che Claudio
> cercava è arrivato: il tetto sul rischio AGGREGATO/CORRELATO sta a
> `3.0%` in TRE autori INDIPENDENTI** (`InpMaxBasketRiskPercent=3.0`,
> `MaxBasketLossPercent=3.0`, `AlertRiskPctEquity=3.0`).
> 👉 **La firma di Claudio del 07/09 sul 3,0% di cluster non è un numero
> inventato in casa: è ESATTAMENTE il valore di consenso esterno.** È la prima
> volta che quel 3,0% ha un riferimento fuori dal repo.
>
> **E il secondo reperto ribalta un verdetto di ieri.** Il cancello del 12/09
> ha scritto che il flottante e il massimo di posizioni contemporanee sono
> `[NON MISURABILI]` e che *"lo chiude solo un forward osservato"*.
> 🟢 **Metà di quella frase non regge, e la prova è dentro il nostro repo**:
> il **massimo di posizioni contemporanee** e il **rischio aperto SL-based**
> (che è esattamente la grandezza che C1 e C2 misurano, `InpRiskMode=0`)
> si ricostruiscono da backtest **appena il per-trade scrive `open_time`** —
> e il codice che lo scrive **esiste già in due nostri EA**
> (`ABTG_BreakinBox.mq5`, `ABTG_NySessionRetest.mq5`) più un esportatore
> dedicato (`ABTG_TradeExporter.mq5`). **46 EA su 48 non lo scrivono, e fra
> questi c'è `ABTG_EMA200.mq5` (r.622).** Resta `[NON MISURABILE]` solo il
> **P/L flottante istante per istante**, che è un'altra grandezza.
>
> **E il buco vero, quello dove siamo PIÙ ESPOSTI di tutte le fonti lette, è
> uno solo e non l'aveva nominato nessuno: il BUFFER prima del muro.** Noi
> abbiamo **0,1%** (emergenza 4,9 su muro 5,0 · 9,9 su 10,0). Le fonti lette:
> **0,5%** (PropFirmGuard, `InpBufferPct`), **1,0%** (`.set` prop di
> TheGoldReaper: 9,0 su 10), **1,0%** (`.set` prop di GoldTradePro: 4,0 su 5).
> 🔴 **Siamo da 5 a 10 volte più stretti di chiunque altro**, e 0,1% su 100k
> è meno di **un sesto** di un nostro singolo stop da 0,65%.

---

## 1. ✅ CONTROLLO POSITIVO DELLE FONTI — fatto PRIMA di cercare

| canale | bersaglio noto | esito | verdetto |
|---|---|---|---|
| **MQL5 Code Base — download zip** | `code/download/76767` deve dare uno zip col `.mq5` | ✅ **200, 122.612 byte, `application/zip`** | 🟢 **VIVO — è il canale della giornata** |
| **MQL5 Code Base — listati** | `code/mt5/experts` + `/scripts` (5 pagine) | ✅ **200 su 5/5**, 81-88 KB per pagina | 🟢 VIVO |
| **MQL5 Articoli** | `articles/24331` deve rendere il codice inline | ✅ **200, 133.637 byte** | 🟢 VIVO |
| **`raw.githubusercontent.com`** | `torvalds/linux/master/README` | ✅ **200, 6.034 byte** | 🟢 **VIVO** (novità: ieri GitHub era dato per 403) |
| **`github.com` — ricerca** | `/search?q=...` | ❌ **403** | 🛑 NULLA |
| **API GitHub — ricerca** | `api.github.com/search/repositories` | ❌ *"sessions are bound to their configured repositories"* | 🛑 NULLA (solo repo-scoped) |
| **`gh` CLI** | `gh auth status` | ❌ `command not found` | 🛑 NULLA |

### 🛑 E QUI IL FATTO CHE DECIDE TUTTO IL §5: **le prop sono TUTTE mute**

Provate **22 URL** di prop e aggregatori. **Risposta: `000` (EGRESS_BLOCKED al
CONNECT) su 22 su 22.** Non è solo FTMO:

`ftmo.com` · `prop.ftmo.com` · `help.ftmo.com` · `academy.ftmo.com` ·
`the5ers.com` · `fundednext.com` · `fundingpips.com` · `alphacapitalgroup.uk` ·
`e8markets.com` · `blueberryfunded.com` · `fundedtradingplus.com` ·
`myfundedfx.com` · `topstep.com` · `fundedunicorn.com` · `thefundedtrader.com` ·
`audacitycapital.co.uk` · `myforexfunds.com` · `instantfunding.io` ·
`brightfunded.com` · `goatfundedtrader.com` · `propfirmmatch.com` ·
`forexpropreviews.com`

> 🔴 **CONSEGUENZA DICHIARATA, e vale come criterio**: **oggi NON possiamo
> leggere una regola prop sulla fonte ufficiale.** Tutto ciò che riguarda le
> regole scritte è **`[LETTO-VIA-SEARCH]`** e, per la regola di casa,
> **NON si usa come criterio**. La richiesta n.4 della caccia (confermare la
> *Forbidden Practice n.8* di FTMO sulla fonte) **NON è stata soddisfatta**:
> vedi §5, dove è scritta come buco aperto e non come risposta.

---

## 2. 🥇 LA TABELLA DEGLI ESEMPI — 15 fonti, solo valori LETTI

**Legenda affidabilità**
- `[SORGENTE LETTO]` = ho scaricato lo zip ed estratto il valore dal `.mq5`.
  **È il grado più forte**: il default è codice, non marketing.
- `[CODICE IN ARTICOLO]` = valore estratto dall'HTML grezzo della pagina con
  `grep`, **non** dal riassunto automatico (vedi §3, dove il riassunto ha
  sbagliato).
- `[SET LETTO]` = file `.set` reale già in `biblioteca/set/`, scaricato il
  18/08 o 23/08, riletto oggi.
- `[LETTO-VIA-SEARCH]` = **solo frammento di motore di ricerca. NON criterio.**

| # | fonte (URL) | autore · data pubbl. | parametro | **VALORE** | contesto | affidabilità |
|---|---|---|---|---|---|---|
| **F1** | [PropFirmGuard, code/76767](https://www.mql5.com/en/code/76767) | GermanAndresSoto · 02/09/2026 | `InpDailyLossPct` · `InpTotalDdPct` · **`InpBufferPct`** · `InpResetHour` | **5.0** · **10.0** · **0.5** · **0** | guardiano puro (non opera), su chart a fianco di qualunque EA. DD totale **dal PICCO equity** (trailing). Muri **effettivi 4,5% e 9,5%** dopo il buffer | `[SORGENTE LETTO]` |
| **F2** | [ASQ RiskGuard, code/71120](https://www.mql5.com/en/code/71120) | Robin2.0 · 28/03/2026 | `InpMaxDrawdownPct` · `InpDailyLimitPct` · `InpRiskPercent` · **`InpMaxOpenPositions`** · `InpMaxTotalLots` · `InpMaxOrdersPerDay` · **`InpWarningPct`** · `InpCooldownSeconds` | **5.0** (da BALANCE) · **3.0** · **1.0** · **5** · **1.0** · **10** · **80** · **5 s** | EA di solo rischio, 1.063 righe, con sessione 08:00-20:00 server e spread guard 30 pt | `[SORGENTE LETTO]` |
| **F3** | [Equity Guard + Panic Panel, code/73870](https://www.mql5.com/en/code/73870) | KairosLab · 29/06/2026 | `InpLimitPercent` · **`InpTriggerPct`** · `InpBaseMode` · `InpResetHour`/`Minute` · `InpEnforceFlat` | **5.0** · **80.0** (% del limite) · **BASE_BALANCE** · **0 / 0** · true | 🔥 **il trigger all'80% di un limite 5,0 = blocco a 4,0%** | `[SORGENTE LETTO]` |
| **F4** | [Trade Guardian, code/76947](https://www.mql5.com/en/code/76947) | PetrKostal · 04/09/2026 | `InpMaxDailyLossPct` · `InpMaxTotalDDPct` · **`InpCooldownHours`** · `InpEnforceStopLoss` · `InpATR_Mult` · `InpMinStopPoints` · `InpCloseOnBreach` | **0.0** (=off) · **0.0** (=off) · **168** · **true** · **3.0** · **100** · **false** (solo allarme) | 🔥 **attacca uno SL dove manca** (ATR×3, mai sotto 100 pt) e **ri-arma** il picco dopo 168 h | `[SORGENTE LETTO]` |
| **F5** | [Quantora Drawdown Monitor, code/75794](https://www.mql5.com/en/code/75794) | Quantora · 07/08/2026 | `InpLowMaxPct` · `InpModerateMaxPct` · `InpHighMaxPct` · `InpCountAllPositions` | **2.0** · **5.0** · **10.0** · **true** | **come conta**: `g_daily_pl_total = g_daily_closed_pl + g_floating`, con `g_floating` = somma di `POSITION_PROFIT` su `PositionsTotal()` (r.120-140, r.266-267) | `[SORGENTE LETTO]` |
| **F6** | [Correlation-Aware Lot Size, code/77032](https://www.mql5.com/en/code/77032) | RanaAli878 · 06/09/2026 | **`InpMaxBasketRiskPercent`** · **`InpCorrelationThreshold`** · `InpCorrelationBars` · `InpCorrelationTimeframe` · `InpRiskPercent` · `InpStopLossPoints` | **3.0** · **0.70** · **100** · **H1** · **1.0** · **300** | 🔥🔥 **il cluster MISURATO, non dichiarato**: Pearson sui rendimenti barra-barra, **non** una tabella di coppie. ρ_eff = ρ se stessa direzione, −ρ se opposta → **stessa direzione e ρ≥0,70 = COMPOUNDS RISK; direzione opposta = NATURAL HEDGE, non contato** (r.244-264) | `[SORGENTE LETTO]` |
| **F7** | [RiskPilot Pro, code/77090](https://www.mql5.com/en/code/77090) | RanaAli878 · 07/09/2026 | `InpDailyLossLimitPercent` · `InpMaxDrawdownPercent` · **`InpMaxBasketRiskPercent`** · `InpRiskPercent` · `InpATRMultiplier` | **5.0** · **10.0** · **3.0** · **1.0** · **1.5** | ⚠️ **stesso autore di F6 → NON è una seconda fonte indipendente** sul 3,0. Il DD totale è dal **high watermark del BALANCE** | `[SORGENTE LETTO]` |
| **F8** | [Prop Firm Rule Checker, code/76955](https://www.mql5.com/en/code/76955) | RanaAli878 · 06/09/2026 | `InpProfitTargetPercent` · `InpMaxDailyLossPercent` · `InpMaxTotalDDPercent` · **`InpMaxSingleDayPercent`** · **`InpMinTradingDays`** | **8.0** · **5.0** · **10.0** · **30.0** · **5** | 🔥 **script che passa uno storico attraverso le regole prop e stampa PASS/FAIL**, regola di **consistenza** compresa. ⚠️ aggrega il profitto per **giorno di calendario** e **solo sui deal CHIUSI** (r.95-124): **lo stesso cieco che abbiamo noi** | `[SORGENTE LETTO]` |
| **F9** | [Server Clock and Daily Reset Hour, code/76288](https://www.mql5.com/en/code/76288) | sabari.kalathur · 18/08/2026 | `ResetZone` · **`ResetHour`** · `AutoDetectServerOffset` · zone disponibili | **ZONE_NEW_YORK** · **17** · true · NY(−300/−240) · Chicago · London(0/+60) · Frankfurt(+60/+120) · UTC · Custom | 🔥 **il default assume che la regola prop sia scritta in ora NEW YORK**, e converte in ora server avvisando prima del cambio DST | `[SORGENTE LETTO]` |
| **F10** | [Articolo 24331 — Basket Risk](https://www.mql5.com/en/articles/24331) | Solomon Anietie Sunday · 11/09/2026 | `MaxBasketPositions` · **`MaxBasketLossPercent`** · `MaxBasketMarginPercent` · `MaxBasketHoldBars` | **1** · **3.0** · **25.0** · **0** (off) | 🔥 fonte **indipendente** sul 3,0. Meccanica: cap sul rischio *implicito* per gamba **e** tetto di basket, con **`headroom` → riduce il lotto**, non blocca il trade | `[CODICE IN ARTICOLO]` |
| **F11** | [Articolo 23374 — Correlation-Aware Monitor](https://www.mql5.com/en/articles/23374) | eugenioguilarte · 24/07/2026 | **`AlertHiddenFactor`** · **`AlertRiskPctEquity`** · **`AlertTopSharePct`** · `CorrLookbackBars` · `VaRConfidenceZ` · `CheckSeconds` · `CooldownMinutes` | **130** (% del naive) · **3.0** · **50** · **200** · **1.645** · **15 s** · **60 min** | 🔥🔥 terza fonte **indipendente** sul 3,0. E un metro che non abbiamo: **rischio VERO (matrice di covarianza) contro rischio NAIVE (somma)**, allarme quando il vero ≥ **130%** del naive; e **concentrazione**: allarme se una posizione è ≥ **50%** del rischio totale | `[CODICE IN ARTICOLO]` |
| **F12** | [Articolo 20587 — Risk Enforcement EA](https://www.mql5.com/en/articles/20587) | billionaire2024 · 16/12/2025 | **`InpCountFloatingPL`** · `InpAutoCloseOnStop` · `InpDailyLossLimit` · `InpWeeklyLossLimit` · `InpMonthlyLossLimit` | **true** · **true** · **−300 $** · **−1.000 $** · **−5.000 $** | 🔥 *"Include open position P/L in limits"* è un **input esplicito, default TRUE**. Architettura **identica alla nostra**: `GlobalVariableSet(GV_DAILY_PL)` + `GV_ALLOW` letto dagli EA | `[CODICE IN ARTICOLO]` |
| **F13** | `biblioteca/set/GoldTradePro_V4.0_prop-firm_cmql5-31-1547_2026-08-23.set` | vendor MQL5 · letto 23/08 | **`MaxRiskPerStrategy`** · `PropFirmMaxDailyDD` | **1.00** (preset **prop**) · **4.00** | 🔥 **scala dello stesso autore**: prop **1,0** · low 1,5 · medium 3,0 · high **6,0** → **il preset prop è 1/6 dell'aggressivo**. E il DD giornaliero **4,0 su muro 5,0 = buffer 1,0** | `[SET LETTO]` |
| **F14** | `biblioteca/set/TheGoldReaper_propfirm_cmql5-31-1047_2026-08-18.set` | vendor MQL5 · letto 18/08 | `PropFirmMaxDailyDD` · **`MaxAllowedDD`** | **4.00** · **9.00** | **9,0 su muro 10,0 = buffer 1,0** | `[SET LETTO]` |
| **F15** | `biblioteca/set/TheImpossibleProp_v2.0-*_mql5blog769728_2026-08-18.set` | vendor MQL5 · letto 18/08 | `PropDailyDD` · `PropMaxDD` · **`ShieldDrawdownPct`** · **`MaxOpenTrades`** · `MaxTradesPerDay` · `RiskPerTrade` · `MaxConsecLosses` | **5.0** · **10.0** · **3.0** · **1** · **10** · **0.75** / **0.5** · **0** (off) | 🔥 **`MaxOpenTrades=1`**: un EA venduto come prop-ready tiene **una posizione sola**. E il rischio per trade **0,5-0,75%** | `[SET LETTO]` |

### 🔢 Il conteggio onesto del 3,0%

| grandezza | fonti | autori **distinti** |
|---|---|---|
| tetto sul rischio **aggregato/correlato** = **3.0%** | F6, F7, F10, F11 | **3** (RanaAli878, Solomon A. Sunday, eugenioguilarte) — F6 e F7 sono lo **stesso** autore |
| limite di **perdita giornaliera** = 3.0% | F2 | 1 (grandezza **diversa**: perdita realizzata, non rischio aperto) |
| `ShieldDrawdownPct` = 3.0% | F15 | 1 (grandezza **diversa**) |

> ⚠️ **E una distinzione che NON va schiacciata**, perché il numero è lo stesso
> ma la grandezza no: F6/F7/F11 misurano **rischio EX-ANTE** (somma delle
> distanze di stop × volume) — **la stessa cosa che misura il nostro C2 con
> `InpRiskMode=0`**. F10 invece misura **la perdita corrente del basket** e
> chiude. **Sono due meccanismi diversi che convergono sullo stesso 3,0%.**

---

## 3. 🛑 IL CONTRO-ESEMPIO CHE HO COSTRUITO — e ha beccato un errore

Regola di casa del 10/09: prima di consegnare, provare a **rompere** la
propria misura.

**Cosa ho provato a rompere.** Il riassunto automatico dell'articolo 24331 mi
ha restituito una tabella con **sei** valori, fra cui
`MaxImpliedRiskPercent = 2%` e `MaxBasketImpliedRiskPercent = 6%`.
Invece di scriverli, ho scaricato l'HTML grezzo (133.637 byte) e ho cercato
**la dichiarazione `input`** di ognuno dei sei.

**Risultato:** quattro si trovano alla lettera
(`MaxBasketPositions = 1`, `MaxBasketLossPercent = 3.0`,
`MaxBasketMarginPercent = 25.0`, `MaxBasketHoldBars = 0`).
🔴 **Gli altri due NO.** Le 8 occorrenze di `Implied` nella pagina sono tutte
dentro il **corpo** del codice (`maxRiskAmount = sizeBaseValue * (MaxImpliedRiskPercent/100.0)`)
o in una **tabella descrittiva senza numeri** (*"The loss one leg's stop
implies"*). **Il 2% e il 6% NON sono sulla pagina.**

👉 **In tabella stanno come `[NON MISURATO]`**, e la meccanica (cap per gamba +
tetto di basket con `headroom`) come **letta**, perché quella c'è.
📌 **La lezione operativa**: su questo canale il riassunto automatico va
trattato come un **indice**, mai come una fonte. Ogni valore del §2 marcato
`[CODICE IN ARTICOLO]` l'ho ri-verificato con `grep` sull'HTML grezzo.

**Secondo contro-esempio, sulla mia stessa riga forte.** Stavo per scrivere
*"quattro fonti indipendenti al 3,0%"*. Ho controllato gli autori: **F6 e F7
sono lo STESSO autore** (RanaAli878, a un giorno di distanza). Le fonti
indipendenti sono **tre**, non quattro. Corretto prima di consegnare.

---

## 4. 📊 IL CONFRONTO COI NOSTRI NUMERI — siamo più prudenti o più esposti?

| nostro parametro | nostro valore | riferimento esterno LETTO | **verdetto** | di quanto |
|---|---|---|---|---|
| **Rischio per sedia** | **0,65%** | 1,0 (F2, F6, F7) · 0,75 e 0,5 (F15) · `MaxRiskPerStrategy` 1,0 nel preset prop (F13) | 🟢 **PIÙ PRUDENTI** del default più comune; **in linea** con i preset prop dei vendor | −35% rispetto a 1,0; dentro la forbice 0,5-0,75 di F15 |
| **C1 rischio aperto** | **3,25%** (VIVO nei 2 preset) | **3,0** (F6, F10, F11) | 🟡 **LEGGERMENTE PIÙ ESPOSTI** | **+0,25 p.p. = +8,3%** sopra il consenso di tre autori |
| **C2 cluster** | **3,0%** 🔴 **firmato ma NON attivo** (default 0 · nessun preset lo valorizza · la versione in campo non ha la manopola) | **3,0** (F6, F10, F11) | 🟢 **IN LINEA ESATTA** sul valore · 🔴 **INFINITAMENTE PIÙ ESPOSTI nei fatti**: a 0 il tetto non esiste | il valore firmato è **il numero giusto**; il problema è **solo** che è spento |
| **Come si definisce il cluster** | **stringa a mano** (`InpClusterMappa`, es. `USD=EURUSD,GBPUSD`) | **Pearson misurato**, ρ_eff ≥ **0,70** su **100 barre H1**, hedge naturale escluso (F6) | 🟡 **più fragile**: una mappa scritta a mano non vede una correlazione nuova e **conta come rischio doppio un hedge naturale** | il valore da copiare è **0,70** |
| **Pausa morbida** | **4,0%** | **80% del limite giornaliero** → su muro 5,0 fa **4,0** (F3) · `InpWarningPct=80` (F2) | 🟢 **IN LINEA, ALLA CIFRA** — e da **due** autori indipendenti con la stessa regola dell'80% | scarto **0,0** |
| **Emergenza giornaliera** | **4,9%** (buffer **0,1**) | buffer **0,5** (F1) · **1,0** (F13: 4,0 su 5) | 🔴 **PIÙ ESPOSTI — è il buco peggiore** | buffer **5× più stretto** di F1, **10×** di F13 |
| **Emergenza totale** | **9,9%** (buffer **0,1**) | buffer **0,5** (F1) · **1,0** (F14: 9,0 su 10) | 🔴 **PIÙ ESPOSTI** | idem, **5×-10×** |
| **Unità del DD totale** | `InpDDMode = 0` = **STATICO** dal saldo iniziale | **dal PICCO equity** (F1, F4) · dal **high watermark del BALANCE** (F7) | 🟡 **più permissivo** del default esterno — 🔴 e coerente col buco già agli atti: **le nostre Monte Carlo sono su DD statico e col trailing NON valgono** (`METRO_PROP.md` §1) | non quantificabile qui: **[NON MISURATO]** |
| **Baseline giornaliera** | `InpDailyBaseline = 0` = **EQUITÀ** (e la manopola **non c'è in campo**) | **BASE_BALANCE** (F3) · equity (F1) · `InpCountFloatingPL=true` (F12) | 🟡 **[INCERTO]**: le fonti sono divise, e la scelta giusta dipende dalla prop | — |
| **Reset giornaliero** | **23** ora server (= 00:00 CE(S)T) | **17:00 ora NEW YORK** come default (F9) · 0:00 (F1, F3) | 🟡 **giusto SE la regola è scritta in CE(S)T** · 🔴 **sbagliato di un'ora se è scritta a 17:00 NY** | vedi il conto sotto |
| **Max posizioni contemporanee** | **nessun input** — implicito: C1 3,25% ÷ 0,65% = **5 stop vivi** | **5** (`InpMaxOpenPositions`, F2) · **1** (`MaxBasketPositions`, F10) · **1** (`MaxOpenTrades`, F15) | 🟢 **il nostro 5 implicito ha un gemello esterno esatto** (F2) · 🔴 ma **due fonti prop-oriented stanno a 1** | su `EMA200` Dow, che fa **2-8 posizioni in un giorno**, 8 × 0,65% = **5,2% > C1** |
| **Max trade al giorno** | **nessun tetto** su EMA200 (`InpMaxTradesPerDay=0`, agli atti 12/09) | **10** (F2, F15) | 🔴 **PIÙ ESPOSTI**: non abbiamo il tetto che entrambe le fonti hanno | — |
| **Regola di consistenza** | **nessuna misura, nessun input** | **max 30% del profitto totale da un solo giorno** (F8) · min **5** giorni di trading | 🔴 **BUCO APERTO**: non l'abbiamo mai misurata | **[NON MISURATO]** su tutte le sedie |
| **Posizioni senza SL** | `InpWarnNoSL = true` → **logga e basta** | **attacca uno SL** ATR×3, mai sotto 100 pt (F4) · F6 avvisa che *"basket risk may be higher than shown"* | 🟡 **più esposti**: noi sappiamo del rischio ignoto e non lo chiudiamo | — |
| **Cooldown fra passate di chiusura** | **[NON VERIFICATO oggi]** nel nostro sorgente | **5 s** (F1 `m_retry_seconds`, F2 `InpCooldownSeconds`) | — | da confrontare |

### 🕐 Il conto del reset, fatto per esteso (ed è `[INFERITO]` dall'aritmetica dei fusi, non letto)

Regola di casa: **server BCM = ora italiana − 1**. In settembre l'Italia è
**CEST = UTC+2** → **server = UTC+1**.

| se la regola della prop è scritta… | in UTC | ora **server BCM** | nostro `InpDailyResetHour=23` |
|---|---|---|---|
| **00:00 CE(S)T** | 22:00 | **23:00** | 🟢 **giusto** |
| **17:00 New York (EDT)** | 21:00 | **22:00** | 🔴 **sbagliato di 1 ora** |
| **00:00 UTC** | 00:00 | **01:00** | 🔴 sbagliato di 2 ore |

E in inverno (IT = CET = UTC+1 → server = UTC+0): 00:00 CET → server **23:00**
(stabile); 17:00 NY EST = 22:00 UTC → server **22:00** (stabile).
👉 **L'aritmetica è robusta al DST**, il dubbio è **solo** su quale fuso la
prop usi — e quello resta **`[INCERTO]`**, come già scritto in
`PIANO_PROP.md` (riga B3). **F9 è lo strumento che chiude il dubbio il giorno
in cui la regola si può leggere.**

---

## 5. 🔴 LE REGOLE PROP: COSA NON HO POTUTO VEDERE

**La richiesta n.4 della caccia NON è stata soddisfatta, e va detto chiaro.**

| domanda | esito | perché |
|---|---|---|
| FTMO — *Forbidden Practice n.8* (taglie non uniformi) sulla pagina ufficiale | 🛑 **NON LETTA** | `ftmo.com/en/forbidden-trading-practices/` → **`000`, EGRESS_BLOCKED al CONNECT** |
| Muri, trailing/statico, ora di reset di **qualunque** prop, da fonte ufficiale | 🛑 **NON LETTI** | 22 domini su 22 bloccati (§1) |
| Regola di consistenza ufficiale di una prop | 🛑 **NON LETTA** | idem |

**Quello che i frammenti di ricerca dicono** — e che scrivo **solo** per
tracciare la pista, **`[LETTO-VIA-SEARCH]`, NON usabile come criterio**:
i frammenti riferiscono che FTMO vieta *"substantially larger position sizes
compared to your other trades"* e che **non pubblica un elenco chiuso**, ma un
quadro di *"market standard risk management"* con valutazione a propria
discrezione.

🟢 **La sola cosa che questo permette di dire, e la dico come ipotesi non come
verdetto:** le nostre taglie sono **fisse allo 0,65%** per costruzione, quindi
il profilo *"taglie non uniformi"* **non ci descrive**. **[INFERITO dalle
nostre taglie, NON confermato sulla fonte.]**
🔴 **Resta la regola D3 di casa**: niente si compra prima di una risposta
**per iscritto** dal supporto. Questa caccia **non la sostituisce**.

---

## 6. 🔧 LE PROPOSTE — mappate su file e riga. **NESSUNA APPLICATA**

> 🔴 Rischio e taglie sono **di Claudio**. Tutte le proposte che toccano un
> numero di rischio sono **[FIRMA DI CLAUDIO]**. Le due che non toccano numeri
> di rischio (P1 e P6) sono **lavoro**, e comunque passano dall'imbuto.

### 🥇 P1 — `open_time` nel per-trade: il flottante NON è tutto perduto
```
PROPOSTA   aggiungere open_time al CSV per-trade, partendo da ABTG_EMA200
DOVE       mql5/Experts/ABTG_EMA200.mq5 r.622 (header) e il ciclo che segue
           DONATORE GIÀ IN CASA: mql5/Experts/ABTG_BreakinBox.mq5
             r.1147-1163  passata sui deal DEAL_ENTRY_IN -> array idIn/tmIn
             r.1187       header con "open_time" gia' scritto
             r.1205       lookup per position_id
           ALTERNATIVA SENZA TOCCARE EA: mql5/Experts/ABTG_TradeExporter.mq5
             r.177 esporta gia' pid;symbol;side;volume;open_time;open_price;close_time
FONTE      F5 (come si somma il flottante) - F8 (il checker pubblico ha lo
           STESSO cieco: aggrega solo i deal chiusi, r.95-124) - F12
           (InpCountFloatingPL come input esplicito)
COSTO      ~12 righe copiate per EA. 1 ricompilazione + 1 corsa di controllo
           per EA. Su EMA200 solo: ~1 ora. Su tutti e 46: ~1 giornata
RISCHIO    BASSO: tocca SOLO la scrittura del CSV, nessuna logica di trading.
           Il file cambia schema -> gli script che lo leggono vanno allineati
           (colonna in piu'). Da NON mettere in coda 1ª: nessun EA in forward
           va ricompilato senza il cancello
RESA       sblocca in BACKTEST: max posizioni contemporanee, rischio aperto
           SL-based (la grandezza ESATTA di C1/C2), rischio per cluster nel
           tempo. NON sblocca il P/L flottante istante per istante, che resta
           [NON MISURABILE] e richiede un log di equity intraday
```
🔴 **E corregge una riga di `EMA200_DOW_COSA_MANCA_2026-09-12.md` (r.359)**:
*"lo chiude solo un forward osservato, o un EA che logga l'equity intraday"* è
vero per **il flottante**, **non** per **il massimo di posizioni contemporanee**
né per il **rischio aperto** — quelli li chiude `open_time`, e il codice è in
casa da settimane.

### 🥈 P2 — Portare il buffer dei muri alla larghezza che usano gli altri
```
PROPOSTA   alzare il buffer prima dei muri: emergenza 4,9 -> 4,5 e 9,9 -> 9,5
           (buffer 0,1 -> 0,5), come F1
DOVE       mql5/Presets/ABTG_Guardian_FTMO_2Step.set
           mql5/Presets/conto_reale/ABTG_Guardian_REALE.set
           (il codice NON si tocca: ABTG_Guardian.mq5 r.130-131 ha gia' i muri
            5,0/10,0 come input; l'emergenza si tara nei preset)
FONTE      F1 InpBufferPct=0.5 - F13 4,0 su muro 5,0 - F14 9,0 su muro 10,0
COSTO      zero sviluppo. Una firma + un ricarico di preset + il canarino
RISCHIO    si chiude PRIMA -> qualche giornata chiusa che si sarebbe
           recuperata. E' il prezzo esplicito del buffer
[FIRMA DI CLAUDIO]  -- e' un parametro di rischio
```
🔥 **Perché è la 2ª e non la 5ª**: 0,1% su un conto da 100k è **meno di un
sesto** di un nostro singolo stop da 0,65%. **Tre fonti su tre stanno fra 0,5 e
1,0.** Siamo l'unico caso letto sotto 0,5.

### 🥉 P3 — Valorizzare il C2 e sostituire la mappa a mano con la correlazione misurata
```
PROPOSTA   (a) valorizzare InpMaxClusterRiskPct = 3.0 nei due preset
           (b) sostituire/integrare la mappa a mano con una soglia di
               correlazione misurata: rho_eff >= 0,70 su 100 barre H1
DOVE       (a) i due .set del Guardian (nessuna riga di cluster oggi)
               ABTG_Guardian.mq5 r.165 (default 0) - r.166 (InpClusterMappa "")
           (b) ABTG_Guardian.mq5 r.185 (la mappa, letta UNA volta in OnInit)
               r.471-472 (tetto per singolo cluster) - r.631 (cancello)
FONTE      F6 (InpMaxBasketRiskPercent 3.0 + InpCorrelationThreshold 0.70 +
           InpCorrelationBars 100 + H1, e l'hedge naturale ESCLUSO) - F10 -
           F11
COSTO      (a) zero sviluppo, solo firma. (b) ~1 giornata: la Pearson e'
           ~30 righe (F6 r.82-168 e' leggibile riga per riga), piu' cache
           e un autotest
RISCHIO    (a) 🔴 da misurare PRIMA su storico: con 5 sedie correlate il
               tetto a 3,0 potrebbe bloccare presto -- e' lo stesso allarme
               gia' agli atti per C1 (CONFIG_PROP_2026-08-31 r.491)
           (b) la correlazione calcolata a runtime costa tick e puo' mancare
               di storico (F6 lo dichiara: "correlation UNKNOWN")
NOTA       🔴 e comunque il C2 NON protegge niente finche' la versione IN CAMPO
           non ha la manopola: 1.10/1.11/1.12 non hanno InpMaxClusterRiskPct
           (IL_GUARDIAN_IN_CAMPO_2026-09-12.md par.2). Serve una
           RICOMPILAZIONE sui terminali, non solo una firma
[FIRMA DI CLAUDIO]  -- e' un parametro di rischio
```
🟢 **La buona notizia da dare per prima**: il **3,0 firmato il 07/09 è il
numero giusto**. Tre autori indipendenti ci sono arrivati da soli. Non serve
ridiscutere il valore: serve **accenderlo**.

### P4 — Il tetto sul numero di trade al giorno, che non abbiamo
```
PROPOSTA   tetto giornaliero di operazioni per sedia (o per famiglia)
DOVE       input nuovo nei singoli EA (EMA200 oggi ha InpMaxTradesPerDay=0)
           oppure contatore nel Guardian accanto a InpDailyPausePct (r.152)
FONTE      F2 InpMaxOrdersPerDay=10 - F15 MaxTradesPerDay=10
COSTO      ~mezza giornata nel Guardian (un contatore sul giorno prop, che
           il Guardian gia' calcola), oppure ~10 righe per EA
RISCHIO    su una sedia a raffiche puo' tagliare l'operazione buona.
           Da misurare sui per-trade PRIMA di scegliere il numero
[FIRMA DI CLAUDIO]
```

### P5 — La regola di consistenza: misurarla, prima di subirla
```
PROPOSTA   misurare su ogni sedia e sul portafoglio: quale % del profitto
           totale viene dal giorno migliore (soglia di riferimento 30%)
           e quanti giorni di trading distinti (soglia 5)
DOVE       nessun file da cambiare: e' una MISURA sui per-trade che abbiamo
           gia'. Strumento esterno pronto: F8 (script, 201 righe, girabile
           su uno storico)
FONTE      F8 InpMaxSingleDayPercent=30.0 - InpMinTradingDays=5
COSTO      ~2 ore di script Python sui CSV per-trade
RISCHIO    nessuno: e' sola lettura. 🔴 Ma il VALORE 30% e' il default di un
           autore, NON una regola prop letta: la soglia vera resta
           [LETTO-VIA-SEARCH]/[INCERTO] finche' il sito non e' leggibile
```
🔴 **Perché conta su di noi in particolare**: `EMA200` Dow lavora **a raffiche**
(2-8 posizioni, attiva il **37,5%** dei giorni, agli atti 12/09). Un profilo a
raffiche è **esattamente** quello che concentra il profitto in pochi giorni —
cioè il bersaglio della regola di consistenza.

### P6 — Il metro che non abbiamo: rischio VERO contro rischio NAIVE
```
PROPOSTA   misurare, sui per-trade, il rapporto fra rischio correlato VERO
           (matrice di covarianza) e rischio NAIVE (somma dei rischi):
           allarme a >= 130%. E la concentrazione: nessuna posizione >= 50%
           del rischio totale
DOVE       strumento di analisi nuovo (offline, sui CSV) -- NON nel Guardian
           in prima battuta. Richiede P1 (serve open_time)
FONTE      F11 AlertHiddenFactor=130 - AlertRiskPctEquity=3.0 -
           AlertTopSharePct=50 - CorrLookbackBars=200
COSTO      ~mezza giornata di Python, ZERO rischio (sola lettura)
RISCHIO    nessuno. E' la misura che DA' IL NUMERO al tetto per cluster,
           invece di assumerlo
```
🔥 **Questa è la proposta che vale di più per il 1° ottobre dopo P1**, perché è
quella che trasforma il 3,0% da **firma** a **numero misurato sul NOSTRO
portafoglio**: i portafogli larghi letti in casa hanno DD misurati del **32,6%**
e **45,6%**, e `AlertHiddenFactor` è precisamente il metro di quel fenomeno.

### P7 — Lo SL mancante: chiuderlo invece di loggarlo
```
PROPOSTA   valutare se il Guardian, oltre a loggare (InpWarnNoSL, r.155),
           deve AGIRE su una posizione senza stop
DOVE       ABTG_Guardian.mq5 r.155
FONTE      F4 InpEnforceStopLoss=true, ATR(14)x3.0, mai sotto 100 punti
COSTO      ~2 ore + autotest
RISCHIO    🔴 ALTO e va detto: un Guardian che PIAZZA stop diventa un EA che
           opera. Su spread larghi o su un simbolo con stop level stretto
           puo' fare danni. F4 stesso tiene InpCloseOnBreach=false per
           difetto (solo allarme)
[FIRMA DI CLAUDIO]
```

---

## 7. 🧭 LA BUSSOLA — cosa di questo avvicina una sedia al 1° ottobre

🟢 **P1 è l'unica proposta che produce una MISURA nuova su una sedia vera**, e
la sedia è quella migliore (`EMA200` Dow). Costa ~1 ora su un EA, il codice
donatore è in casa, e chiude metà di ciò che ieri era dichiarato
strutturalmente chiuso.

🟡 **P2, P3, P4, P7 sono firme**: costano zero ore e zero macchina, e sono le
uniche che cambiano davvero il rischio con cui si parte.

🔴 **Il resto è ponteggio, e lo dichiaro**: P5 e P6 sono strumenti di misura.
Utili, ma non schierano nessuno.

🎯 **Cosa questa caccia NON ha consegnato**: nessuna regola prop da fonte
ufficiale (22 domini bloccati su 22), nessuna conferma della *Forbidden
Practice n.8*, nessun valore per `MaxImpliedRiskPercent`. **Sono buchi, non
dettagli**, e restano aperti.

---

## 8. 📎 TRACCIABILITÀ — dove stanno i file scaricati oggi

Gli zip e i sorgenti letti oggi stanno nella cartella di lavoro temporanea
della sessione (`scratchpad`), **non** nel repo: sono materiale di terzi e non
vanno committati. **Ogni valore in tabella è ricostruibile** rilanciando
`https://www.mql5.com/en/code/download/<ID>` con gli ID della colonna "fonte" —
canale verificato **200** oggi, 10 download su 10.

ID scaricati e letti oggi: **76767 · 71120 · 73870 · 76947 · 75794 · 77032 ·
77090 · 76955 · 76288 · 75606**.
Articoli letti in HTML grezzo oggi: **24331 · 23374 · 20587**.
Piste **viste ma non aperte** (per tempo, non per blocco): `75380` Hidden Risk
of Ruin Auditor · `74240` Drawdown DNA Analyzer · `71307` Portfolio Scorer
(Multi-EA Correlation and Coverage Analyzer) · `76533` Drawdown Meter.
`75606` Portfolio Correlation Analyzer è **scaricato** e i suoi input sono nel
mio materiale, ma **non è entrato in tabella** perché i suoi default
(`InpMCRuns=2000`, `InpMinTrades=20`, `InpRefBalance=10000`) sono parametri di
**analisi**, non tetti di rischio: metterli fra i valori copiabili sarebbe
gonfiare la tabella.
