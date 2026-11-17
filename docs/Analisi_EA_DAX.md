# Analisi EA DAX — dalle 24 versioni al consolidato `DAX_MASTER_PROP`

Documento di sintesi sull'evoluzione degli Expert Advisor DAX (D30EUR / DE40)
e specifica del nuovo EA consolidato **`DAX_MASTER_PROP`**, orientato alle
regole prop-firm FTMO con profilo a basso drawdown.

> **Avvertenza.** I risultati di backtest citati nel changelog storico
> provengono dai commenti dei file originali e si riferiscono alla logica di
> trading ereditata. **Le 5 nuove protezioni FTMO introdotte in
> `DAX_MASTER_PROP` non sono ancora validate** e vanno verificate via Strategy
> Tester su dati tick reali prima di qualsiasi uso in demo o live. Nessun
> nuovo risultato è qui dichiarato come acquisito.

---

## 1. Le due famiglie di EA

### Famiglia A — `DAXMasterEA` (scaffolding "metodologia Emiliano")

È la linea principale: una catena di ~24 versioni (v0.1 → v2.0) costruita per
incrementi successivi e validata progressivamente su backtest aperture e tick
reali. Architettura a **macchina a stati** (`ETradingState`) con un solo ordine
per volta (single-order), strategia **ORB (Opening Range Breakout)** mattutina
sul DAX:

- Range di apertura costruito sulle prime N candele M15 dopo le 09:00 server.
- Segnale di breakout con corpo candela oltre l'ORB, conferma rispetto alla
  MA200 e buffer/range configurabili.
- Stack di filtri di qualità e anti-shock additivi (vedi tabella).
- Gestione uscita: parziale + break-even + trailing dinamico ATR.
- Sizing risk-based con cap lotti, journal CSV per analisi posteriore.

La **v2.0** è la versione più completa e pulita (clean rebuild da v1.9, dopo il
bugfix dell'array-out-of-range in `GetATRD1Ratio`). È la base di codice da cui
parte `DAX_MASTER_PROP`.

### Famiglia B — `DAXEmilianoEA` (replica diretta metodologia Emiliano Monza / ABTG)

Linea parallela più aderente al metodo discrezionale del coach: usa un **box
notturno** (livelli 00:00–05:59) invece dell'ORB, trigger con offset oltre il
livello, **candela di conferma** post-trigger (v1.0.2) per filtrare i falsi
breakout, filtro EMA 9/21 direzionale, pre-test del livello, HTF MA200 H4,
anti-shock e target sul max/min del giorno precedente.

Da questa famiglia si recupera in particolare il **circuit breaker su SL
consecutivi** (`g_consecutiveSL`, halt cross-day che si azzera solo su un trade
vincente) e la gestione esplicita delle **unità di prezzo** (`g_pointSize`):
sul DAX un "punto Emiliano" = 1.0 di prezzo, distinto dal tick del broker.

---

## 2. Tabella evolutiva `DAXMasterEA` v0.1 → v2.0

| Versione | Contributo principale | Stato |
|----------|-----------------------|-------|
| v0.1     | Scaffolding macchina a stati ORB, hooks (hedging disabilitato) | base |
| v0.2     | `OpenPosition` reale con sizing risk-based | tenuto |
| v0.3     | News filter reale via `CalendarValueHistory` | tenuto |
| v0.4     | Supporto sessione pomeridiana | tenuto, **OFF in prop** |
| v0.5     | Rilevazione Strategy Tester (workaround Calendar) | tenuto |
| v0.6     | Diagnostica verbose in `GenerateSignal` | tenuto |
| v0.7     | Rinomina input in price units, rimozione conversioni `Point()` | tenuto |
| v0.8     | Filtri direzionali HTF trend + Correlation S&P (post-signal) | tenuto, **edge zero → OFF** |
| v0.9     | Breakout buffer + range minimo candela trigger | tenuto (default 0) |
| v1.0     | Journal CSV; default permissivi (filtri opzionali OFF) | tenuto |
| v1.1     | Cap lotti assoluto, SL minimo; Lun/Ven OFF | tenuto |
| v1.2     | Daily Bias dalla candela DAX D1 di ieri | tenuto |
| v1.4     | Trailing dinamico ATR(D1) clamp Min/Max dopo BE | tenuto (causa Sharpe alto) |
| v1.5_edge / v1.6_edge_smart | Edge "ordine di riparazione" (martingala/hedge) | **SCARTATI** |
| v1.7     | Filtri qualità: ADX ≥ 25 + distanza MA200 ≥ 30 | tenuto |
| v1.8     | 4 filtri anti-shock (gap, ATR D1, shock M5, candela esplosa) | tenuto |
| v1.8.1   | Calibrazione anti-shock (gap 75, ATR 2.0, M5 4.0, candela 3.0) | tenuto |
| v1.8.2   | Ottimizzazione genetica: ADX 24, distanza MA200 35 | tenuto (default attuale) |
| v1.9     | Filtro Heiken Ashi (quality gate) + bugfix `GetATRD1Ratio` | **HA NON validato → OFF**, bugfix tenuto |
| v2.0     | Clean rebuild da v1.9 (storico Tester pulito) | **base di `DAX_MASTER_PROP`** |

---

## 3. Cosa è stato scartato e perché

- **Edge "ordine di riparazione" (v1.5_edge, v1.6_edge_smart).** Concetto
  valido sulla carta ma in pratica troppo delicato per essere automatizzato:
  introduce logiche di hedge / aggiunta in perdita assimilabili alla
  **martingala**, che amplificano il drawdown — esattamente l'opposto di un
  profilo prop low-DD. v1.5_edge ha rotto Q4 2025 (−621 USD). Entrambi non
  promossi. Lo scaffolding hedging resta nel codice ma **disabilitato**.
- **Filtri direzionali HTF trend e Correlation S&P (v0.8).** Hanno mostrato
  **edge ≈ zero** sui test: lasciati nel codice ma **default OFF**. In
  `DAX_MASTER_PROP` se vengono riattivati e i dati non sono pronti, **bloccano**
  (non passano permissivi).
- **Filtro Heiken Ashi (v1.9).** Mai validato: su M5 rischia di essere troppo
  "filtrato" e di bloccare i breakout. In `DAX_MASTER_PROP` è **default OFF**.
- **Soglie troppo aggressive (v1.8 default originale).** Generavano troppi
  pochi trade (Q4 2025: solo 4 trade, statisticamente irrilevante). Risolto con
  la calibrazione v1.8.1/v1.8.2, che è il set di default mantenuto.
- **Stub mai implementati (Supertrend, VWAP_ATR, S/R proximity, Market
  Profile).** In `DAX_MASTER_PROP` sono **default OFF** e — punto chiave — non
  possono più "passare silenziosamente" come filtri attivi: se attivati senza
  implementazione, **bloccano** o restano neutri, mai permissivi finti.

Il rischio trasversale evitato è il **sovra-adattamento (overfit)**: lo "sweet
spot" della v1.8.2 deriva da ottimizzazione genetica (122 test), ma la scelta è
stata di muovere solo 2 parametri rispetto al default per minimizzare
l'overfitting. `DAX_MASTER_PROP` non tocca questi valori.

---

## 4. Specifica di `DAX_MASTER_PROP`

File: `mql5/Experts/DAX_MASTER_PROP.mq5` — nome EA `DAX_MASTER_PROP`,
magic number invariato (`20260422`) per continuità di tracking.

### 4.1 Logica di trading preservata invariata (da v2.0)

- Macchina a stati ORB mattutino M15 (2 candele), apertura 09:00 server, EOD 21:00.
- Segnale: corpo candela oltre ORB + close vs MA200 + buffer/range.
- Filtri **attivi**: ADX ≥ 24, distanza MA200 ≥ 35, Daily Bias D1, 4 anti-shock
  (gap 75, ATR D1 2.0×, shock M5 4.0×, candela esplosa 3.0×), news,
  day-of-week (Lun/Ven OFF).
- Uscita: parziale 50% a +45, BE a +20 (offset +5), trailing ATR(D1)×0.30
  clamp 10–50 attivo dopo il BE.
- Sizing risk-based, cap lotti assoluto 3.0, SL min 15 / max 100, broker stop level.
- Journal CSV.

### 4.2 Disattivazioni (logica lasciata, default OFF)

- `InpHAFilterEnabled = false` (Heiken Ashi, non validato).
- `InpTradeAfternoon = false` (sessione pomeridiana).
- Stub Supertrend / VWAP_ATR / Market Profile / S/R / HTF / Correlation: OFF,
  non passano silenziosamente come filtri attivi.

### 4.3 Default prop-conservativi

- `InpRiskPerTradePercent = 0.5` (era 1.0).
- Max 2 trade/giorno (invariato).
- Soglie filtri ai valori v1.8.2/v2.0 (ADX 24, MA dist 35, gap 75, ATR 2.0,
  ATR M5 4.0, candela 3.0).

---

## 5. Le 5 protezioni FTMO aggiunte

### Protezione 1 — Daily loss su EQUITY (non balance)

- Input: `InpUseEquityDailyStop` (default `true`). Soglia condivisa con
  `InpMaxDailyLossPercent` (default 2.0%).
- `g_dayStartEquity` viene catturata al primo tick del nuovo giorno broker
  (resettata in `CheckDailyReset` insieme agli altri reset giornalieri).
- Su **ogni tick** (`CheckEquityDailyStop`, non solo all'apertura di nuovi
  trade): se `g_dayStartEquity − AccountEquity ≥ soglia% × g_dayStartEquity`,
  **chiude tutte le posizioni a mercato** e blocca l'operatività per il resto
  della giornata (`STATE_EOD`). Include il **floating** delle posizioni aperte.
- Il vecchio controllo su balance (`DailyLimitsOK`) resta come **fallback**; il
  driver primario è l'equity.

### Protezione 2 — Kill-switch drawdown totale (overall FTMO)

- Input: `InpInitialBalance` (default 0 = auto-capture di `AccountBalance` in
  `OnInit`), `InpMaxTotalDDPercent` (default 6.0%, margine di sicurezza sotto il
  10% FTMO).
- Su ogni tick (`CheckTotalDrawdownKillSwitch`, priorità assoluta in `OnTick`):
  se `AccountEquity ≤ g_initialBalance × (1 − InpMaxTotalDDPercent/100)`,
  **chiude tutto** e imposta `g_killSwitch = true`, con Print di allerta.
  Finché il flag è `true` l'EA **non apre più nulla**: il reset richiede
  riavvio / re-inizializzazione manuale.

### Protezione 3 — Stop su SL consecutivi (famiglia Emiliano)

- Input: `InpMaxConsecutiveSL` (default 3), `InpConsecutiveSLScope` enum
  `{SCOPE_DAILY, SCOPE_CROSSDAY}` (default `SCOPE_DAILY`).
- `UpdateConsecutiveSLCounter` (chiamata in `OnTradeTransaction` sul deal di
  uscita) incrementa `g_consecutiveSL` quando il deal ha profit netto < 0
  **oppure** `DEAL_REASON == DEAL_REASON_SL`; un trade vincente azzera il
  contatore.
- Al raggiungimento della soglia: scope **DAILY** → halt fino a fine giornata
  (`g_dailySLHalt`, reset in `CheckDailyReset`); scope **CROSSDAY** → halt
  finché non arriva un trade vincente (`g_crossdayHalt`, stile Emiliano).
  `g_consecutiveSL` e l'halt cross-day **non** si azzerano al cambio giorno.

### Protezione 4 — Fail-safe conservativo sui filtri

- Ovunque un filtro/indicatore non abbia dati pronti (CopyBuffer fallito,
  handle invalido, MA200/ATR/ADX non pronti, gap non leggibile), il
  comportamento è **"non operare"** (blocca il segnale), non "passa
  permissivo". In pratica:
  - `GetADXValue`, `GetATRD1Ratio`, `GetATRM5Ratio`, `GetATRM5Value`,
    `GetGapPoints` ritornano un valore sentinella negativo quando i dati non
    sono pronti, e `QualityFiltersPass` blocca.
  - `VolumeFilterPass` con dati insufficienti → blocca (in v2.0 era
    permissivo).
  - `DailyBiasFilterPass` con bias non ancora calcolato (`BIAS_NONE`) → blocca.
  - Stub `SRProximityFilterPass`: se attivato → blocca (con warning una tantum).
  - HTF / Correlation: se attivati e i dati non sono pronti → bloccano.
- **Eccezione news in Strategy Tester:** la Calendar API non è disponibile nel
  Tester (errore 4014); `NewsFilterPass` resta permissivo **solo** se
  `MQLInfoInteger(MQL_TESTER)` è `true`. In **LIVE**, se la Calendar non è
  leggibile (`HasBlockingNewsForCurrency` segnala `apiError`), il filtro è
  **conservativo**: non opera.

### Protezione 5 — Persistenza handle indicatori

- In v2.0 gli handle `iADX` e `iATR` venivano creati e rilasciati ad ogni
  chiamata (ad ogni tick/check). In `DAX_MASTER_PROP` sono **handle persistenti**
  creati in `OnInit` (`CreateIndicatorHandles`) e rilasciati in `OnDeinit`:
  - `g_handleADX` = `iADX(InpADXTimeframe, InpADXPeriod)`
  - `g_handleATRD1Spike` = `iATR(D1, 14)` (GetATRD1Ratio)
  - `g_handleATRM5Avg` = `iATR(M5, InpATRM5AvgPeriod)` (shock M5 + candela esplosa)
  - `g_handleATRD1Trail` = `iATR(D1, InpTrailingATRPeriod)` (trailing)
- Parametri e buffer identici alla v2.0: è un miglioramento di
  efficienza/stabilità, **non** cambia i valori calcolati.

---

## 6. Validazione raccomandata

1. **Sanity check**: confronto aperture con la v2.0 a parità di filtri (HA off,
   afternoon off) per verificare che la logica di trading sia rimasta identica.
2. **Strategy Tester su tick reali** (every-tick / real-ticks) su un anno, per
   misurare l'effetto delle 5 protezioni su drawdown e profit factor.
3. Test specifici dei trigger di protezione: giornata con perdita equity vicino
   al 2% (Protezione 1), scenario di DD totale al 6% (Protezione 2), serie di 3
   SL consecutivi nei due scope (Protezione 3).
4. Verifica in **demo live** del fail-safe news in assenza di Calendar
   (Protezione 4) e della stabilità degli handle persistenti (Protezione 5).

Solo dopo questa validazione l'EA è da considerare candidabile per una sfida
prop-firm reale.
