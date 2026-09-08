# 🧾 CENSIMENTO DEL RISCHIO DICHIARATO — 08/09/2026

**Cosa misura:** per OGNI sedia realmente attaccata sui terminali del VPS, tre
numeri messi uno accanto all'altro — **quello che GIRA**, **quello che il PRESET
dice**, **il DEFAULT del sorgente** — e il verdetto se coincidono.

**Chi l'ha scritto:** agente in sola lettura. Nessun `.set`, nessun `.mq5`,
nessun parametro e' stato toccato: l'unico file scritto e' questo referto.

---

## 📌 LE TRE FONTI E I LORO LIMITI (dichiarati prima dei numeri)

| # | Fonte | File | Limite da tenere presente |
|---|---|---|---|
| 1 | **quello che GIRA** | `backtest_pipeline/coda/referti/CODA_01_sedie_attaccate_20260908_033003.log` (lettura 2026-09-08 03:30:06, ora locale) | ⚠️ **E' UNA FOTO, NON LO STATO VIVO.** I valori arrivano dai file `.chr`, che MT5 riscrive **quando il profilo viene salvato**. Se qualcuno ha cambiato un parametro nella finestra dell'EA senza che il profilo sia stato salvato dopo, il `.chr` racconta il valore vecchio. **E' esattamente la domanda che la riga CODA_05 misurera'.** |
| 2 | **quello che il PRESET dice** | `mql5/Presets/**/*.set` + `mql5/presets/*.set` (due cartelle, maiuscola diversa) | Abbinamento fatto **sul magic** (`InpMagic`, o `InpMagicNumber` dove l'EA usa quel nome). Se nessun preset porta il magic della sedia -> **NESSUN PRESET**, che e' un fatto, non un buco da riempire a intuito. |
| 3 | **il DEFAULT del sorgente** | `mql5/Experts/ABTG_*.mq5`, riga `input double InpRiskPercent = ...` (o `#define ABTG_DEF_RISK` per la famiglia Aperture) | E' cosa succede **se qualcuno riattacca l'EA senza caricare il preset**, o preme RIPRISTINA nella finestra dei parametri. |

Solo il blocco **PROFILO ATTIVO** di ogni cartella entra nel censimento. I
**RESIDUI SU DISCO** sono elencati a parte, in fondo, e **non sono nei totali**.

---

# 🚨 DISCORDANZE — ordinate per gravita'

Una discordanza e' `rischio che gira` != `rischio del preset` (abbinati sul magic).

## 🔴 1. CONTO REALE 10105439 (`C:\BCM_Reale`) — **NESSUNA DISCORDANZA**

Entrambe le sedie girano esattamente sul preset del conto reale.

| EA | magic | gira | preset | file |
|---|---|---|---|---|
| ABTG_DAX_Apertura_EU | 770101 | 0,65 | **0,65** | `mql5/Presets/conto_reale/ABTG_DAX_Apertura_EU_770101_REALE.set` |
| ABTG_ORB_Ottimizzato | 770611 | 0,65 | **0,65** | `mql5/Presets/conto_reale/ABTG_ORB_Ottimizzato_770611_REALE.set` |

✅ **Il conto vero e' l'unico terminale pulito del censimento.**

⚠️ Un fatto misurato che non e' una discordanza di rischio ma va detto qui:
nel profilo attivo fotografato del REALE **non compare `ABTG_Guardian`**, anche
se il preset `mql5/Presets/conto_reale/ABTG_Guardian_REALE.set` (magic 779002,
cap 3,25) esiste nel repo. Il Guardian risulta attaccato **solo** sul 100k.

---

## 🟠 2. DRY-RUN 100K 50504263 (`C:\Program Files\BCM Markets MT5 Terminal -V3`) — **4 DISCORDANZE + 1 AMBIGUITA'**

Tutte hanno la stessa forma: le sedie girano a **0,65 / 0,30** (le taglie C1
firmate il 18/08), ma **nel repo non esiste nessun preset del 100k**. I preset
che portano quei magic sono quelli del piccolo (`sedie_piccolo/recupero2`, a
1,0) o quelli del reale (`conto_reale`, a 0,65).

| # | EA | simbolo/TF | magic | gira | preset (file) | scarto | esito |
|---|---|---|---|---|---|---|---|
| 1 | ABTG_ORB_Ottimizzato | U30USD M5 | 770611 | **0,30** | 0,65 (`conto_reale/...770611_REALE.set`) **e** 1,0 (`sedie_piccolo/recupero2/...770611.set`) | −0,35 / −0,70 | ⚠️ **DISCORDA CON ENTRAMBI** |
| 2 | ABTG_Dow_Apertura_US | U30USD M5 | 770202 | **0,65** | 1,0 (`sedie_piccolo/recupero2/sedia_ABTG_Dow_Apertura_US_770202.set`) | −0,35 | ⚠️ DISCORDANZA |
| 3 | ABTG_MaxMinNotte_DAX_Short_Ottimizzato | D30EUR M15 | 770411 | **0,65** | 1,0 (`sedie_piccolo/recupero2/...770411.set`) | −0,35 | ⚠️ DISCORDANZA |
| 4 | ABTG_SupertrendReversal | 225JPY H2 | 770901 | **0,65** | 1,0 (`ABTG_SupertrendReversal_H4.set`) | −0,35 | ⚠️ DISCORDANZA — e **il preset e' H4, la sedia gira H2** |
| 5 | ABTG_DAX_Apertura_EU | D30EUR M5 | 770101 | **0,65** | **tre** preset con lo stesso magic: 0,65 (REALE) · 1,0 (recupero2) · 2,0 (`ABTG_DAX_Apertura_EU_LEGACY_2pct.set`) | — | ⚠️ **AMBIGUO**: coincide col preset del REALE, discorda con gli altri due |

📌 **Tutte e cinque discordano VERSO IL BASSO**: il terminale gira piu' prudente
di ogni preset che porta quei magic. Non e' un pericolo immediato — e' un
**pericolo di ricarica**: chi domani caricasse "il preset di quella sedia"
alzerebbe il rischio senza accorgersene.

📌 **NON ESISTE UNA CARTELLA DI PRESET PER IL 100K.** Le taglie 0,65/0,30 che
girano su quel terminale **non sono scritte in nessun file `.set` del repo**:
vivono solo dentro i `.chr`. Se quel profilo si perde, la configurazione del
dry-run non e' ricostruibile da questo repository.

---

## 🟡 3. DEMO PICCOLO 50503392 (`C:\Program Files\BCM Markets MT5 Terminal`, profilo `ORO`) — **4 DISCORDANZE**

### 3a. 🔥 LE DUE POSTNEWS CHE GIRANO AL 3,0% — la piu' grave del censimento

| EA | simbolo/TF | magic | gira | preset | default sorgente | esito |
|---|---|---|---|---|---|---|
| ABTG_PostNews | EURJPY M5 | 771201 | **3,0** | **1,30** (`ABTG_PostNews_ECB_EURJPY.set`) | **3,0** | 🔥 **+1,70 punti** |
| ABTG_PostNews | EURUSD M5 | 771202 | **3,0** | **1,30** (`ABTG_PostNews_ECB_EURUSD.set` e `ABTG_PostNews_FOMC_EURUSD.set`, entrambi 1,30) | **3,0** | 🔥 **+1,70 punti** |

**Perche' e' la piu' grave, e non solo per il numero:** il valore che gira
(3,0) e' **identico al default compilato del sorgente**
(`mql5/Experts/ABTG_PostNews.mq5` r.113: `input double InpRiskPercent = 3.0;`).
La firma e' quella di un EA **attaccato senza caricare il preset** — o
ripristinato ai default dopo. E' lo **stesso meccanismo** gia' diagnosticato e
firmato il 02/09 sul DAX 770101 (C4: default 2,0 = doppio del contratto, ogni
RIPRISTINA lo rimetteva in silenzio).

⚠️ Aggravante misurata, presa da `report/CENSIMENTO_CONTRATTI.md` r.169-170:
**771201 e 771202 hanno DD promesso 🔴 NESSUNO — "NON MISURATO"**. Girano al 3%
per operazione due sedie di cui non esiste nessun drawdown misurato agli atti.
Le due insieme fanno **6,0 punti di rischio**, cioe' **da sole 1,85 volte il
cap C1 di 3,25%**.

📎 La gemella `771203` (PostNews NFP USDJPY) gira invece a **1,30 = preset**: ✅.
Le tre sedie sono lo stesso EA, e due su tre hanno il preset non caricato.

### 3b. Le due sedie dell'ORO: girano PIU' PRUDENTI del preset (preset scaduto)

| EA | simbolo/TF | magic | gira | preset | default sorgente | esito |
|---|---|---|---|---|---|---|
| ABTG_MaxMinNotte | XAUUSD M15 | 770402 | **0,5** | **1,0** (`sedie_piccolo/sedia_MAXMIN_ORO_770402.set`) | **2,0** | ⚠️ preset SCADUTO |
| ABTG_EMA200_Ottimizzato | XAUUSD H4 | 971501 | **0,25** | **1,0** (`sedie_piccolo/recupero2/...971501.set`) | **1,0** | ⚠️ preset SCADUTO |

Qui il terminale ha **ragione** e il preset ha torto: `report/CONTRATTI_SEDIE.md`
r.95 e r.113 riportano le riduzioni firmate il 23/08 (REVISIONE R100) —
770402 da 1,0 a **0,5**, 971501 da 1,0 a **0,25**. **La riduzione e' stata fatta
sul grafico ma non e' mai stata riportata nei file `.set`.**

🚩 Conseguenza concreta: chi ricaricasse quei due preset **raddoppierebbe**
l'oro notte e **quadruplicherebbe** l'EMA200 oro — su una sedia il cui DD
misurato a 1% e' **45,91% a 22 anni** (`CENSIMENTO_CONTRATTI.md` r.131).

### 3c. Discordanze col SOLO SORGENTE (preset ok, default pericoloso)

Non sono discordanze secondo la definizione, ma sono la stessa trappola vista
da un altro lato: **cosa succede se si riattacca senza preset.**

| EA | magic | gira | preset | default sorgente | delta se si ripristina |
|---|---|---|---|---|---|
| ABTG_SupertrendReversal_Ottimizzato | 970901 | 1 | 1 | **2,0** (`ABTG_SupertrendReversal_Ottimizzato.mq5` r.86) | **x2** |
| ABTG_MaxMinNotte | 770402 | 0,5 | 1,0 | **2,0** (`ABTG_MaxMinNotte.mq5` r.171) | **x4** |
| ABTG_Nasdaq_Apertura_US (GatedShort) | 770250 | 0,35 | 0,35 ✅ | **2,0** (`#define ABTG_DEF_RISK` r.47) | **x5,7** |
| ABTG_PostNews (tutte e tre) | 7712xx | — | 1,30 | **3,0** (r.113) | **x2,3** |

🔴 **E una copia doppia del sorgente che porta ancora il default vecchio:**
`mql5/Experts/standalone/ABTG_DAX_Apertura_EU.mq5` r.33 ha ancora
`#define ABTG_DEF_RISK 2.0`, mentre la copia buona
`mql5/Experts/ABTG_DAX_Apertura_EU.mq5` r.90 e' stata portata a **1.0** col fix
firmato C4 del 02/09. **Il fix e' stato applicato a un solo file dei due.**
Chi compilasse la copia `standalone/` rimetterebbe in campo il 2%.

---

# 📊 SOMMA DEL RISCHIO PER TERMINALE

> ⚠️ **E' UN CASO PEGGIORE TEORICO, NON UNA PREVISIONE.** E' la somma aritmetica
> del rischio dichiarato di tutte le sedie del profilo attivo: "se aprissero
> tutte insieme, e ognuna andasse sul suo stop". **Molte di queste sedie non
> possono aprire lo stesso giorno** (motori a sessione diversa, filtri di
> calendario, un-trade-al-giorno). Il numero serve a misurare la **capienza**
> del terminale, non a prevedere una perdita.

| Terminale | Conto | Sedie attive | Con rischio leggibile | **Somma rischio** | vs cap C1 = **3,25%** |
|---|---|---|---|---|---|
| `C:\Program Files\BCM Markets MT5 Terminal` (ORO) | **50503392** demo piccolo | 40 | 38 | 🔥 **35,90%** | **11,0x il cap** |
| `C:\Program Files\BCM Markets MT5 Terminal -V3` (SQUADRA 100K) | **50504263** dry-run 100k | 7 | 5 | **2,90%** | ✅ sotto (margine 0,35) |
| `C:\BCM_Reale` (Default) | **10105439** REALE | 3 | 2 | **1,30%** | ✅ sotto (margine 1,95) |
| `C:\MT5_Backtest` (Default) | **50504400** | 0 | 0 | **0,00%** | — (vuoto) |
| `C:\Program Files\Tickmill Europe MT5 Terminal` | ❌ NON NOSTRO | 2 | 1 | 0,50% | non si applica |
| `C:\Program Files\Pepperstone MetaTrader 5` | ❌ NON NOSTRO | 0 | 0 | 0,00% | non si applica |

### Come si legge il 35,90% del piccolo

- **Non e' un allarme di perdita**: e' un demo, e la maggior parte di quelle 38
  sedie e' su motori e sessioni che non aprono insieme.
- **E' un allarme di GOVERNO**: 24 delle 38 sedie girano a **1,0 esatto**, cioe'
  al default del sorgente, non a una taglia scelta. Il piccolo e' un banco di
  prova largo, non un portafoglio dimensionato.
- ⚠️ **Nel profilo attivo `ORO` del piccolo NON compare `ABTG_Guardian`.** Il
  cap C1 di 3,25% e' implementato **solo dentro l'EA Guardian**
  (`InpMaxOpenRiskPct`), e il Guardian risulta attaccato **solo sul 100k**
  (magic 779001, `SQUADRA 100K\chart07.chr`). **Sul terminale che somma 35,90%
  non c'e' nessuna riga che applichi il cap.**
- 🔴 E il **tetto per cluster/valuta al 3,0%** firmato il 07/09 **e' firmato ma
  NON ATTIVO**: nel Guardian il cap per cluster esiste come input
  (`InpMaxClusterRiskPct`, r.119) ma il suo **default e' 0 = spento**. Finche'
  non e' impostato e collaudato **e' un'intenzione, non una protezione** — e
  sul piccolo, con 40 sedie e **U30USD a 8,00% da solo** (tabella qui sotto),
  sarebbe proprio il tetto che serve.

### Concentrazione misurata sul piccolo (per simbolo, solo profilo attivo, TradeExporter escluso)

| Simbolo | Sedie | Rischio sommato |
|---|---|---|
| **U30USD** | **8** | 🔥 **8,00%** |
| **EURUSD** | 3 | 🔥 **5,00%** (di cui 3,00 dalla sola PostNews 771202) |
| **GBPUSD** | **6** | **4,50%** |
| EURJPY | 2 | **3,65%** (di cui 3,00 dalla sola PostNews 771201) |
| D30EUR | 3 | 3,00% |
| XAUUSD | 4 | 2,05% |
| AUDUSD | 2 | 2,00% |
| 225JPY | 3 (+1 senza rischio leggibile) | 2,00% + n/d |
| NASUSD | 2 | 1,35% |
| USDJPY | 1 | 1,30% |
| GBPJPY · EURCAD | 1 + 1 | 1,00% + 1,00% |
| EURAUD | 1 | 0,50% |
| CHFJPY | 1 | 0,30% |
| GBPCAD | 1 | 0,25% |

📌 **Quattro simboli su quindici sforano da soli il tetto per cluster di 3,0%**
firmato il 07/09 (U30USD 8,00 · EURUSD 5,00 · GBPUSD 4,50 · EURJPY 3,65). E il
tetto e' 🔴 **firmato ma NON attivo** — quindi nulla lo applica.

---

# 🧰 SEDIE SENZA MAGIC — sono STRUMENTI, non sedie

Nel log compaiono come `magic -` e `rischio -`. **Non aprono posizioni proprie e
non entrano in nessun totale di rischio.**

| EA | Terminale | Simbolo/TF | Cosa e' |
|---|---|---|---|
| `ABTG_TradeExporter` | piccolo 50503392 | NZDCAD H1 | 🧰 esportatore CSV dei trade. Il sorgente **non ha nessun input di rischio ne' di magic** (`ABTG_TradeExporter.mq5`: solo file/anno/minuti). |
| `ABTG_TradeExporter` | 100k 50504263 | EURUSD H1 | 🧰 idem |
| `ABTG_SlippageLogger` | **REALE 10105439** | EURJPY H1 | 🧰 misuratore di slippage. Il sorgente **non ha input di rischio ne' di magic** (`ABTG_SlippageLogger.mq5`: solo parametri di scansione e file). |
| `ABTG_Guardian` | 100k 50504263 | AUDNZD H1 | 🛡️ **guardiano, non sedia.** Ha un magic (779001, coincide col preset `ABTG_Guardian_FTMO_2Step.set`) ma **non ha `InpRiskPercent`**: il suo parametro e' `InpMaxOpenRiskPct = 3.25` (il cap C1). Non apre, **chiude**. |

## ⚠️ MA ATTENZIONE — due righe `magic -` NON sono strumenti

Il lettore che ha prodotto il log cerca dentro il `.chr` i nomi `InpMagic` e
`InpRiskPercent`. **Due EA usano nomi diversi**, quindi appaiono vuoti pur
essendo sedie a tutti gli effetti:

| EA | Terminale | Simbolo/TF | Cosa e' davvero |
|---|---|---|---|
| `ABTG_GapContinuation` | piccolo 50503392 | 225JPY M1 | 🪑 **E' UNA SEDIA VERA.** Il sorgente usa `InpMagicNumber = 774101` (non `InpMagic`) e `InpBuyRiskPercent = 0.50` / `InpSellRiskPercent = 0.50` (non `InpRiskPercent`). Preset esistenti col magic 774101: `ABTG_GapContinuation_FORWARD.set` (buy 1,0 / sell 1,0 / sell ridotto 0,25) e `ABTG_GapContinuation_R65_cella.set` (idem). **Il rischio che gira e' 🔴 NON MISURATO** in questa foto: il suo contributo NON e' nel 35,90%, che quindi e' un **limite inferiore**. |
| `BREAKOUT_EA_JPY_v3` | Tickmill ❌ non nostro | USDJPY M15 | Non nostro. Il sorgente piu' vicino in repo (`BREAKOUT_EA_JPY.mq5`) usa `RiskPercent` / `MagicNumber` **senza prefisso `Inp`** — stessa cecita' del lettore. **Nessun file `BREAKOUT_EA_JPY_v3` esiste nel repo.** |

📌 **Azione suggerita per CODA_05**: far cercare al lettore anche
`InpMagicNumber`, `InpBuyRiskPercent`, `InpSellRiskPercent`, `MagicNumber`,
`RiskPercent`. Con i nomi attuali due sedie su 52 sono invisibili.

---

# 📋 TABELLE COMPLETE PER TERMINALE

## 🖥️ `C:\Program Files\BCM Markets MT5 Terminal` — DEMO PICCOLO **50503392** — profilo attivo `ORO` — 40 sedie

| EA | Simbolo | TF | Magic | Gira | Preset | Default sorgente | ESITO |
|---|---|---|---|---|---|---|---|
| ABTG_TradeExporter | NZDCAD | H1 | — | — | — | nessun input di rischio | 🧰 STRUMENTO |
| ABTG_PTE | U30USD | H1 | 771321 | 1.0 | **1.0** `sedia_PTE_DOW_771321.set` | 1.0 | ✅ COINCIDE |
| ABTG_BreakingBand | GBPUSD | H1 | 772161 | 1.0 | 🔴 **NESSUN PRESET** | 1.0 | 🔴 NESSUN PRESET (gira sul default) |
| ABTG_BreakingBand | EURUSD | H1 | 772162 | 1.0 | 🔴 **NESSUN PRESET** | 1.0 | 🔴 NESSUN PRESET (gira sul default) |
| ABTG_BreakingBand | AUDUSD | H1 | 772163 | 1.0 | 🔴 **NESSUN PRESET** | 1.0 | 🔴 NESSUN PRESET (gira sul default) |
| ABTG_GapFill | GBPUSD | H1 | 772231 | 1.0 | 🔴 **NESSUN PRESET** | 1.0 | 🔴 NESSUN PRESET (gira sul default) |
| ABTG_GapFill | EURUSD | H1 | 772232 | 1.0 | 🔴 **NESSUN PRESET** | 1.0 | 🔴 NESSUN PRESET (gira sul default) |
| ABTG_GapFill | AUDUSD | H1 | 772233 | 1.0 | 🔴 **NESSUN PRESET** | 1.0 | 🔴 NESSUN PRESET (gira sul default) |
| ABTG_GapFill | U30USD | H1 | 772234 | 1.0 | 🔴 **NESSUN PRESET** | 1.0 | 🔴 NESSUN PRESET (gira sul default) |
| ABTG_GapFill | 225JPY | H1 | 772235 | 1.0 | **1.0** `ABTG_GapFill_225JPY_R36_cella.set` | 1.0 | ✅ COINCIDE |
| ABTG_PunteLarry | U30USD | H1 | 772341 | 1.0 | 🔴 **NESSUN PRESET** | 1.0 | 🔴 NESSUN PRESET (gira sul default) |
| ABTG_PunteLarry | EURAUD | H1 | 772342 | 0.5 | 🔴 **NESSUN PRESET** | 1.0 | 🔴 NESSUN PRESET (e non e' il default) |
| ABTG_PunteLarry | XAUUSD | H1 | 772343 | 0.3 | 🔴 **NESSUN PRESET** | 1.0 | 🔴 NESSUN PRESET (e non e' il default) |
| ABTG_PunteLarry | GBPJPY | H1 | 772344 | 1.0 | 🔴 **NESSUN PRESET** | 1.0 | 🔴 NESSUN PRESET (gira sul default) |
| ABTG_PunteLarry | GBPUSD | H1 | 772345 | 1.0 | 🔴 **NESSUN PRESET** | 1.0 | 🔴 NESSUN PRESET (gira sul default) |
| ABTG_PunteLarry | EURCAD | H1 | 772346 | 1.0 | 🔴 **NESSUN PRESET** | 1.0 | 🔴 NESSUN PRESET (gira sul default) |
| ABTG_CostToCost | EURJPY | H4 | 772361 | 0.65 | 🔴 **NESSUN PRESET** | 1.0 | 🔴 NESSUN PRESET (e non e' il default) |
| ABTG_CostToCost | GBPCAD | H4 | 772362 | 0.25 | 🔴 **NESSUN PRESET** | 1.0 | 🔴 NESSUN PRESET (e non e' il default) |
| ABTG_EasyTrend | CHFJPY | H1 | 772421 | 0.3 | 🔴 **NESSUN PRESET** | 1.0 | 🔴 NESSUN PRESET (e non e' il default) |
| ABTG_EasyTrend | GBPUSD | H1 | 772422 | 0.5 | 🔴 **NESSUN PRESET** | 1.0 | 🔴 NESSUN PRESET (e non e' il default) |
| ABTG_GapContinuation | 225JPY | M1 | — (774101 nel sorgente) | 🔴 **NON MISURATO** | buy 1.0 / sell 1.0 `ABTG_GapContinuation_FORWARD.set` | buy 0.50 / sell 0.50 | ⚠️ **SEDIA INVISIBILE AL LETTORE** (nomi input diversi) |
| ABTG_PTE | GBPUSD | H1 | 771332 | 0.5 | 🔴 **NESSUN PRESET** | 1.0 | 🔴 NESSUN PRESET |
| ABTG_PTE | GBPUSD | H1 | 771322 | 0.5 | **0.5** `sedia_PTE_GBPUSD_771322.set` | 1.0 | ✅ COINCIDE |
| ABTG_SuperWave | U30USD | H4 | 770531 | 1.0 | **1.0** `sedia_SW_DOW_H2_770531.set` | 1.0 | ✅ COINCIDE (⚠️ preset nominato H2, sedia su H4) |
| ABTG_MaxMinNotte | XAUUSD | M15 | 770402 | **0.5** | **1.0** `sedia_MAXMIN_ORO_770402.set` | **2.0** | ⚠️ **DISCORDANZA** — preset scaduto (contratto 23/08 = 0,5) |
| ABTG_DAX_Apertura_EU | D30EUR | M5 | 770101 | 1.0 | **1.0** `recupero2/...770101.set` | 1.0 (fix C4 02/09) | ✅ COINCIDE |
| ABTG_Dow_Apertura_US | U30USD | M5 | 770202 | 1.0 | **1.0** `recupero2/...770202.set` | 1.0 | ✅ COINCIDE |
| ABTG_MaxMinNotte_DAX_Short_Ottimizzato | D30EUR | M15 | 770411 | 1.0 | **1.0** `recupero2/...770411.set` | 1.0 | ✅ COINCIDE |
| ABTG_EMA200 | U30USD | H1 | 771531 | 1.0 | **1.0** `recupero2/...771531.set` | 1.0 | ✅ COINCIDE |
| ABTG_EMA200_Ottimizzato | XAUUSD | H4 | 971501 | **0.25** | **1.0** `recupero2/...971501.set` | 1.0 | ⚠️ **DISCORDANZA** — preset scaduto (contratto 23/08 = 0,25) |
| ABTG_SupertrendReversal | 225JPY | H2 | 770924 | 1.0 | **1.0** `recupero2/...770924.set` e `..._FW_Nikkei.set` | 1.0 | ✅ COINCIDE |
| ABTG_SupertrendReversal_Ottimizzato | XAUUSD | H4 | 970901 | 1 | **1** `recupero2/...970901.set` | **2.0** | ✅ col preset · ⚠️ default doppio |
| ABTG_SuperWave_DOW_H1_Ottimizzato | U30USD | H1 | 770511 | 1.0 | **1.0** `recupero2/...770511.set` | 1.0 | ✅ COINCIDE |
| ABTG_SupRev_DAX_H4_Ottimizzato | D30EUR | H4 | 970912 | 1.0 | **1.0** `recupero2/...970912.set` | 1.0 | ✅ COINCIDE |
| ABTG_SupRev_NAS_H1_Ottimizzato | NASUSD | H1 | 970913 | 1.0 | **1.0** `recupero2/...970913.set` | 1.0 | ✅ COINCIDE |
| ABTG_ORB_Ottimizzato | U30USD | M5 | 770611 | 1.0 | **1.0** `recupero2/...770611.set` | 1.0 | ✅ COINCIDE |
| ABTG_Nasdaq_Apertura_US (GatedShort) | NASUSD | M15 | 770250 | 0.35 | **0.35** `mql5/presets/ABTG_GatedShort_NASUSD_770250_LIVE.set` | **2.0** | ✅ col preset · ⚠️ default 5,7x |
| ABTG_PostNews | USDJPY | M5 | 771203 | 1.30 | **1.30** `ABTG_PostNews_NFP_USDJPY[_LIVE_2026-09-04].set` | 3.0 | ✅ COINCIDE |
| ABTG_PostNews | EURJPY | M5 | 771201 | **3.0** | **1.30** `ABTG_PostNews_ECB_EURJPY.set` | **3.0** | 🔥 **DISCORDANZA GRAVE** — gira sul default |
| ABTG_PostNews | EURUSD | M5 | 771202 | **3.0** | **1.30** `ABTG_PostNews_ECB_EURUSD.set` / `..._FOMC_EURUSD.set` | **3.0** | 🔥 **DISCORDANZA GRAVE** — gira sul default |

**Somma rischio (38 sedie leggibili): 🔥 35,90%** — limite inferiore, manca GapContinuation.

🔴 **18 delle 40 sedie di questo terminale non hanno NESSUN preset col loro
magic** (BreakingBand x3, GapFill x4, PunteLarry x6, CostToCost x2, EasyTrend x2,
PTE 771332). Di queste, **11 girano esattamente sul default del sorgente (1,0)**
e **7 girano su un valore che non sta ne' in un preset ne' nel sorgente**
(0,5 · 0,3 · 0,65 · 0,25 · 0,3 · 0,5 · 0,5): quei sette numeri **esistono solo
dentro il `.chr`**. Se il profilo `ORO` si perde, non sono ricostruibili.

---

## 🖥️ `C:\Program Files\BCM Markets MT5 Terminal -V3` — DRY-RUN 100K **50504263** — profilo attivo `SQUADRA 100K` — 7 sedie

| EA | Simbolo | TF | Magic | Gira | Preset | Default sorgente | ESITO |
|---|---|---|---|---|---|---|---|
| ABTG_DAX_Apertura_EU | D30EUR | M5 | 770101 | 0.65 | 0.65 (REALE) · 1.0 (recupero2) · 2.0 (LEGACY) | 1.0 | ⚠️ **AMBIGUO** — 3 preset con lo stesso magic |
| ABTG_Dow_Apertura_US | U30USD | M5 | 770202 | 0.65 | **1.0** `recupero2/...770202.set` | 1.0 | ⚠️ DISCORDANZA (−0,35) |
| ABTG_MaxMinNotte_DAX_Short_Ottimizzato | D30EUR | M15 | 770411 | 0.65 | **1.0** `recupero2/...770411.set` | 1.0 | ⚠️ DISCORDANZA (−0,35) |
| ABTG_SupertrendReversal | 225JPY | H2 | 770901 | 0.65 | **1.0** `ABTG_SupertrendReversal_H4.set` | 1.0 | ⚠️ DISCORDANZA (−0,35) + TF diverso |
| ABTG_TradeExporter | EURUSD | H1 | — | — | — | nessun input di rischio | 🧰 STRUMENTO |
| ABTG_ORB_Ottimizzato | U30USD | M5 | 770611 | 0.30 | 0.65 (REALE) · 1.0 (recupero2) | 1.0 | ⚠️ DISCORDANZA con entrambi |
| ABTG_Guardian | AUDNZD | H1 | 779001 | — | `ABTG_Guardian_FTMO_2Step.set` (cap 3.25) | `InpMaxOpenRiskPct = 3.25` | 🛡️ GUARDIANO (non e' una sedia) |

**Somma rischio (5 sedie leggibili): 2,90%** — ✅ sotto il cap C1 di 3,25%, margine 0,35 punti.
🛡️ **E' l'unico terminale con il Guardian attaccato**, quindi l'unico dove il cap C1 e' davvero applicato da una riga di codice.

### RESIDUI SU DISCO su questo terminale (profilo `Default`, **NON nel totale**)

Sei grafici salvati in un profilo non attivo. **Non girano**, ma se qualcuno
cambia profilo tornano vivi con questi valori:

| EA | Simbolo | TF | Magic | Rischio salvato |
|---|---|---|---|---|
| ABTG_Guardian | AUDCAD | H1 | 779001 | — |
| ABTG_DAX_Apertura_EU | D30EUR | M5 | 770101 | 0.65 |
| ABTG_Dow_Apertura_US | U30USD | M5 | 770202 | 0.65 |
| ABTG_MaxMinNotte_DAX_Short_Ottimizzato | D30EUR | M15 | 770411 | 0.65 |
| ABTG_SupertrendReversal | 225JPY | H2 | 770901 | 0.65 |
| ABTG_ORB_Ottimizzato | U30USD | M5 | 770611 | 0.30 |

(Somma dei residui: 2,90% — **identica** al profilo attivo: e' una copia, non una configurazione diversa.)

---

## 🖥️ `C:\BCM_Reale` — CONTO REALE **10105439** — profilo attivo `Default` — 3 sedie

| EA | Simbolo | TF | Magic | Gira | Preset | Default sorgente | ESITO |
|---|---|---|---|---|---|---|---|
| ABTG_DAX_Apertura_EU | D30EUR | M5 | 770101 | 0.65 | **0.65** `conto_reale/ABTG_DAX_Apertura_EU_770101_REALE.set` | 1.0 | ✅ COINCIDE |
| ABTG_ORB_Ottimizzato | U30USD | M5 | 770611 | 0.65 | **0.65** `conto_reale/ABTG_ORB_Ottimizzato_770611_REALE.set` | 1.0 | ✅ COINCIDE |
| ABTG_SlippageLogger | EURJPY | H1 | — | — | — | nessun input di rischio | 🧰 STRUMENTO |

**Somma rischio (2 sedie): 1,30%** — ✅ sotto il cap C1 di 3,25%, margine 1,95 punti (= 3 stop C1 liberi).
⚠️ Nessun `ABTG_Guardian` nel profilo attivo, pur esistendo il preset `ABTG_Guardian_REALE.set` (magic 779002).

---

## 🖥️ `C:\MT5_Backtest` — conto **50504400** — profilo attivo `Default` — 0 sedie

Terminale vuoto nel profilo attivo. **Somma rischio: 0,00%.**

---

## ❌ TERMINALI NON NOSTRI (elencati per completezza, fuori da ogni totale di casa)

### `C:\Program Files\Tickmill Europe MT5 Terminal` — profilo `Default` — 2 sedie

| EA | Simbolo | TF | Magic | Gira | Preset | Default sorgente | ESITO |
|---|---|---|---|---|---|---|---|
| Gold_Ichimoku_TK_ATR_EA | XAUUSD | M5 | 250604 | 0.5 | 🔴 **NESSUN PRESET** | **0.5** (`Gold_Ichimoku_TK_ATR_EA.mq5` r.105) | 🔴 NESSUN PRESET (gira sul default) |
| BREAKOUT_EA_JPY_v3 | USDJPY | M15 | — | 🔴 **NON MISURATO** | 🔴 nessuno | `RiskPercent = 1.0` in `BREAKOUT_EA_JPY.mq5` (file `_v3` **non esiste in repo**) | ⚠️ nomi input senza `Inp` |

### `C:\Program Files\Pepperstone MetaTrader 5` — profilo `Euro` — 0 sedie

---

# 🧭 COSA RESTA DA MISURARE (dichiarato, non riempito a intuito)

| # | Domanda aperta | Perche' non e' rispondibile da qui |
|---|---|---|
| 1 | **Il `.chr` dice la verita' viva?** | I `.chr` si riscrivono al salvataggio del profilo. Serve la lettura dello stato **vivo** degli EA — la riga **CODA_05**. |
| 2 | Il rischio vero di `ABTG_GapContinuation` 225JPY (774101) | Il lettore non conosce `InpBuyRiskPercent`/`InpSellRiskPercent`. Va esteso. |
| 3 | Perche' 771201 e 771202 girano al default 3,0 | Serve la data di attacco dei due grafici (giornale MT5), fuori dal perimetro di questo referto. |
| 4 | Quale preset e' "quello giusto" per il magic 770101 | Tre file diversi portano lo stesso magic con tre rischi diversi (0,65 / 1,0 / 2,0). Serve una firma di Claudio su quale sia canonico per quale conto. |
| 5 | Il DD promesso di 771201 / 771202 | 🔴 **NESSUNO agli atti** (`CENSIMENTO_CONTRATTI.md` r.169-170). Girano al 3% senza contratto. |

### Note di lettura
- Il giornale del terminale piccolo (`CODA_03`) mostra **due conti** nella stessa
  cartella dati: `10105439` (ultimo accesso 07/08) e `50503392` (05/09). Il piu'
  recente e' il **50503392**: e' quello che ho usato come identita' del piccolo.
- I preset del progetto stanno in **due cartelle con maiuscola diversa**:
  `mql5/Presets/` (58 file) e `mql5/presets/` (1 file, il GatedShort 770250).
  Su Windows le due si fondono; su Linux/Git no. **E' una trappola da sapere.**

---

*Referto prodotto in sola lettura da fonti gia' nel repo. Cap C1 3,25% = firma
18/08 (`report/FIRME_2026-08-18.md`). Tetto per cluster 3,0% = firma 07/09
(`report/FIRME_2026-09-07.md`), 🔴 firmato ma NON attivo.*

---

# 🔎 VERIFICA DI CLAUDE SUL REFERTO DELL'AGENTE — 08/09/2026

Ho ricontrollato **a campione** le affermazioni più pesanti, perché un referto
che nessuno verifica è un'opinione con le tabelle.

## ✅ CONFERMATE, con la prova
| affermazione | verifica |
|---|---|
| tre preset con lo **stesso magic 770101** a taglie diverse | ✅ `ABTG_DAX_Apertura_EU_LEGACY_2pct.set` = **2.0** · `conto_reale/…_770101_REALE.set` = **0,65** · `sedie_piccolo/recupero2/sedia_…_770101.set` = **1** |
| `standalone/ABTG_DAX_Apertura_EU.mq5` ancora a `ABTG_DEF_RISK 2.0` | ✅ riga **33**. La copia principale è a **1.0** dal 02/09 (riga 90). **Il fix C4 ha toccato una copia sola.** |

> ### 🙋 E un errore mio, agli atti
> La mia prima verifica sui preset 770101 ne trovava **uno solo**: avevo
> cercato in `mql5/Presets/` senza le **sottocartelle** (`conto_reale/`,
> `sedie_piccolo/`, `sedie_piccolo/recupero2/`). L'agente aveva ragione, io
> avevo guardato male. Verificare prima di correggere, sempre.

## ⚠️ DA CORREGGERE nel referto dell'agente
**"REALE ✅ sotto il cap — ma senza Guardian nel profilo attivo"** è vero come
lettura dei `.chr`, ma **quasi certamente falso come stato reale**:
- esiste `mql5/Presets/conto_reale/ABTG_Guardian_REALE.set` — il Guardian per
  quel conto è previsto e configurato;
- `CODA_02` dell'08/09 lo vede scrivere **464 righe**, ultima alle **23:56**,
  con `eq=7500.00 dayLoss=0.00% totDD=0.00%`.

👉 Un EA che scrive **sta girando**. La spiegazione economica è che il `.chr`
del terminale reale sia una **foto vecchia** — la stessa domanda che `CODA_05`
misura stanotte. **Fino ad allora: non si dice che il conto reale è senza
Guardian.** Sarebbe un allarme costruito su una fonte che sappiamo di non
saper ancora leggere.
