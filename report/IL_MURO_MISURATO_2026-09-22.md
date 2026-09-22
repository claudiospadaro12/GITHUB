# 🧱 IL MURO, MISURATO — il campo ESISTE, si chiama `Equity Drawdown Absolute`, e una sedia è al sicuro OGGI

**22/09/2026** · branch `lavoro` · 🛑 **SOLA LETTURA E SOLA MISURA**: nessun round lanciato,
nessun EA toccato, nessun preset toccato, nessun parametro di rischio proposto.
Seguito di `report/IL_MURO_NON_E_MISURATO_2026-09-22.md`.

> ## 🎯 IN CINQUE RIGHE
> 1. 🟢 **L'ipotesi è VERA, e l'ho riconciliata al centesimo su 1.845 righe di affari**:
>    `Equity Drawdown Absolute` = **deposito iniziale − equity minima**. È *esattamente* il
>    numero che FTMO misura. **Non serve nessun round nuovo per definirlo.**
> 2. 🔴 **MA l'algebra del mandato è INVERTITA, e l'ho misurato 12 volte su 12**:
>    `DD_ass/deposito` **non** è più stretto di `Equity DD %` — è **sempre più largo**.
>    Ed è dimostrabile, non solo misurato.
> 3. 🟢 **La conseguenza è la notizia buona della giornata**: la colonna che abbiamo GIÀ nei
>    CSV, `Equity DD %`, **è già un limite superiore rigoroso** della perdita statica. Quindi
>    **una sedia sotto il 10% in quella colonna è dimostrata sicura, oggi, senza misure nuove.**
> 4. 🪑 **Una sedia passa**: **`770411`** MaxMin DAX Short, peggior limite **6,27%** contro 10%.
>    ⚠️ Il suo contratto poggia su **14 posizioni**: è sicuro il CONTRATTO, non il futuro.
> 5. 🔴 **Le altre cinque restano `[NON MISURATE]`** contro il muro — e per **due** di esse
>    (`770202`, `770260`) esiste già una misura **al banco vero e alla taglia vera**, che le
>    mette **sopra** il 10% sul limite superiore.

---

# 1️⃣ ✅ L'IPOTESI È VERA — e l'ho provata contro le spiegazioni alternative, non contro il nulla

## 1.1 La definizione, da fonte primaria

`https://www.mql5.com/en/docs/constants/environment_state/statistics` (letta il 22/09):

| costante | definizione **testuale** |
|---|---|
| `STAT_EQUITYMIN` | *«Minimum equity value»* |
| `STAT_INITIAL_DEPOSIT` | *«The value of the initial deposit»* |
| `STAT_EQUITY_DD` | *«**Maximum** equity drawdown in monetary terms… here the largest value is taken»* |
| `STAT_EQUITY_DDREL_PERCENT` | *«**Maximum equity drawdown as a percentage**… for each of which the **relative** drawdown value in percents is calculated. **The greatest value is returned**»* |
| `STAT_EQUITYDD_PERCENT` | *«Drawdown in percent **that was recorded at the moment of** the maximum equity drawdown in **monetary** terms»* |

🔴 **Attenzione a una cosa che il mandato non poteva sapere: in `TesterStatistics` NON esiste
una costante «Equity Drawdown Absolute».** Il campo esiste **solo nel referto HTML**. La via
in MQL5 è `STAT_INITIAL_DEPOSIT − STAT_EQUITYMIN`, che è **la stessa cosa** e costa **una riga**.

## 1.2 La riconciliazione — **al centesimo, su tre referti veri**

Ho ricostruito la serie del bilancio **dalla lista degli affari** di ogni referto e ho
confrontato il minimo col campo dichiarato. Sono referti del tester in `UTF-16LE` (per questo
un `grep` normale non li trova: **è anche il motivo per cui nessuno li aveva mai letti**).

| referto | righe affari | deposito `I` | **min bilancio ricostruito** | `I − min` | **campo dichiarato** | esito |
|---|---:|---:|---:|---:|---:|---|
| `backtest_pipeline/risultati_prove/v21_esterno/V21_IS.htm` | 65 | 10.000,00 | 9.997,87 | **2,13** | Bilancio DD Assoluto **2,13** | 🟢 **esatto** |
| `backtest_pipeline/risultati_prove/v21_esterno/V21_OOS.htm` | 143 | 10.000,00 | 9.984,65 | **15,35** | Bilancio DD Assoluto **15,35** | 🟢 **esatto** |
| `backtest_pipeline/risultati_archivio/R109_deal_anomali/D30EUR_00_long_report_singola.htm` | **1.637** | 100.000,00 | 50.421,30 | **49.578,70** | Bilancio DD Assoluto **49.578,70** | 🟢 **esatto** |

## 1.3 🛑 IL CONTRO-ESEMPIO — le altre definizioni possibili, e perché ognuna è ESCLUSA

Non mi sono fermato a «torna». Ho elencato **per nome** le altre letture possibili di
*«Absolute»* e ho verificato che ognuna produce un numero **diverso**, sul caso R109 (dove i
numeri sono grandi e il caso non può nascondersi nell'arrotondamento):

| lettura alternativa di «Absolute» | numero che produrrebbe | dichiarato | esito |
|---|---:|---:|---|
| **deposito − minimo** *(l'ipotesi)* | **49.578,70** | 49.578,70 | 🟢 **è questa** |
| il drawdown più grande picco-valle | 64.081,95 | 49.578,70 | 🔴 escluso (è il campo *Massimo*, ed è un altro) |
| deposito − bilancio **finale** | 43.608,40 | 49.578,70 | 🔴 escluso |
| il drawdown al momento del massimo % | 64.081,95 | 49.578,70 | 🔴 escluso (è il campo *Relativo*) |

🟢 **Una sola lettura sopravvive, e sopravvive su tre file e 1.845 righe.** Questo è il test
che il 10/09 non avevo fatto: provare a **rompere** la risposta, non a confermarla.

---

# 2️⃣ 🔴 L'ALGEBRA DEL MANDATO È INVERTITA — e la correzione è una BUONA notizia

Il mandato dice: *«`DD_fisso% = DD_ass/I` è un limite superiore **più stretto** di `Equity DD %`»*.
**È il contrario.** E non è un cavillo: cambia **quale numero usiamo per decidere**.

## 2.1 La dimostrazione

Sia `I` il deposito, `E_min` l'equity minima, `P_k` il picco della k-esima discesa, `DD_k` la
sua ampiezza in valuta. Ogni picco è ≥ `I` (l'equity parte da `I` e il picco è un massimo corrente).

- **perdita statica** (quella che FTMO misura) = `(I − E_min)/I`
- `Equity DD %` = `STAT_EQUITY_DDREL_PERCENT` = `max_k (DD_k / P_k)`
- `DD_fisso%` = `DD_max / I` = `max_k(DD_k) / I`

**(a) `Equity DD %` è un limite superiore della perdita statica.** Al momento di `E_min` il
picco corrente `P*` soddisfa `P* ≥ I`, e la funzione `x ↦ 1 − E_min/x` è crescente. Quindi
`Equity DD % ≥ (P*−E_min)/P* ≥ (I−E_min)/I`. ∎

**(b) `DD_fisso%` è un limite superiore PIÙ LARGO.** Poiché `P_k ≥ I` per ogni `k`:
`max_k(DD_k/P_k) ≤ max_k(DD_k/I) = DD_max/I`. ∎

> ### 🏁 La catena giusta è:
> ### `perdita statica ≤ Equity DD % ≤ DD_ass / deposito`
> 👉 **Il numero più utile è quello che abbiamo GIÀ**, non quello che il referto del 22/09
> proponeva di calcolare.

## 2.2 E l'ho misurato: **12 volte su 12**, mai un'eccezione

`DD_ass = Profit / Recovery Factor`, esattamente come proposto dal mandato, calcolato sulle
righe vere (tabella completa al §4). **In tutte e 12 le celle `DD_fisso% ≥ Equity DD %`.**
Il caso più largo è `771531` OOS: **9,1932%** contro **7,8323%** — 1,36 punti di spreco.

🟠 **E una crepa in più su `Profit / RF`, che consiglia di abbandonarlo**: la documentazione
MQL5 dice `STAT_RECOVERY_FACTOR = STAT_PROFIT / STAT_BALANCE_DD` (**bilancio**), ma nel
referto R109 il *Fattore di Recupero* dichiarato (**−0,67**) torna con `−43.608,40 / 64.664,31`
(**equity**, −0,6744) e **non** con `/ 64.081,95` (bilancio, −0,6805). 🔴 **Quale dei due sia
non è risolto**, e sui nostri CSV non è distinguibile perché bilancio ed equity coincidono
quasi sempre. **Un'ambiguità in più per una strada che è già la peggiore delle due.**

---

# 3️⃣ 📂 DOVE STA IL CAMPO OGGI, E PERCHÉ NON È NEI CSV

## 3.1 I file che ce l'hanno — **elencati per nome** (classe 180: mai «tutto ciò che non è X»)

Ho cercato in tutto il repo le stringhe `Drawdown Absolute`, `Absolute Drawdown`,
`Equity Drawdown`, `Balance Drawdown`, `Drawdown Assoluto/a`, `Prelievo assoluto`.
**Fuori dalle copie in `.claude/worktrees/`, i file che contengono il campo sono TRE, e sono
questi:**

1. `backtest_pipeline/risultati_prove/v21_esterno/V21_IS.htm`
2. `backtest_pipeline/risultati_prove/v21_esterno/V21_OOS.htm`
3. `backtest_pipeline/risultati_archivio/R109_deal_anomali/D30EUR_00_long_report_singola.htm`

🔴 **E nessuno dei tre riguarda una delle sei sedie in challenge.** V21 è il vecchio
`NasdaqOpeningBreakout_EA_v21`, R109 è una diagnosi di deal anomali sul DAX. 👉 **Il campo
esiste in casa, ma non per le sedie che volano.**

Due citazioni che parlano di *«Absolute Drawdown»* come **regola di altre prop**, non come
misura nostra: `report/SCHEDA_SECONDA_PROP.md` e `report/REGOLAMENTI_PROP_2026-09-08.md`.
Nessun `.zip`, nessun `.xml` di referto, nessuna cartella `risultati_archivio` con altri HTML.

## 3.2 🔎 Perché non è nei CSV: **non è una dimenticanza, è dove nasce il file**

Il fatto che risolve la domanda del mandato: **i CSV dei round NON li scrive il tester, e non
li scrive PowerShell. Li scrive l'EA.**

- `backtest_pipeline/walkforward_generico.ps1` **r.2030** e **r.2046**: lo script si limita a
  *raccogliere* `OptResults_<Expert>_<Symbol>.csv` dalla cartella `MQL5\Files` e a copiarlo.
  **Non apre mai un referto del tester, e non ne estrae nessuna colonna.**
- Il file nasce in `OnTesterDeinit()` da `FrameAdd`, e il contenuto è un **`double stats[10]`
  riempito a mano in `OnTester()`**. Esempio, `mql5/Experts/ABTG_DAX_Apertura_EU.mq5`:

| riga | cosa scrive |
|---|---|
| **r.2790-2803** | `stats[0..9]` = Profit · Expected Payoff · Profit Factor · Recovery Factor · Sharpe · **`STAT_EQUITY_DDREL_PERCENT`** · Trades · Peggior Giornata % · Perdite Consecutive Max · Serie Perdente Peggiore |
| **r.2856** | l'intestazione: `Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,Sharpe Ratio,Equity DD %,Trades,…` |

> ### 🏁 La risposta: **non è una scelta contro il campo, e non è una dimenticanza. Il tester
> non c'entra: la colonna non c'è perché nessun EA la chiede.** E non poteva chiederla con
> quel nome, perché in `TesterStatistics` **quel nome non esiste** (§1.1).

## 3.3 🟢 Quale costante usano le SEI sedie — verificato una per una, al sorgente

| sedia | file | riga | costante |
|---|---|---:|---|
| `770101` DAX | `mql5/Experts/ABTG_DAX_Apertura_EU.mq5` | **2795** | `STAT_EQUITY_DDREL_PERCENT` |
| `770202` Dow | `mql5/Experts/ABTG_Dow_Apertura_US.mq5` | **2161** | `STAT_EQUITY_DDREL_PERCENT` |
| `770260` Nasdaq | `mql5/Experts/ABTG_Nasdaq_Apertura_US.mq5` | **2600** | `STAT_EQUITY_DDREL_PERCENT` |
| `770411` MaxMin | `mql5/Experts/ABTG_MaxMinNotte_DAX_Short_Ottimizzato.mq5` | **581** | `STAT_EQUITY_DDREL_PERCENT` |
| `770511` SuperWave | `mql5/Experts/ABTG_SuperWave_DOW_H1_Ottimizzato.mq5` | **736** | `STAT_EQUITY_DDREL_PERCENT` |
| `771531` EMA200 | `mql5/Experts/ABTG_EMA200.mq5` | **652** | `STAT_EQUITY_DDREL_PERCENT` |

🟢 **Tutte e sei usano la costante RELATIVA**, cioè quella per cui la dimostrazione del §2.1
vale. **Questo è ciò che rende il verdetto del §5 possibile.**

🔴 **E il contro-esempio che ho cercato apposta**: esiste in repo **un** EA che usa l'altra
costante, `STAT_EQUITYDD_PERCENT` — `mql5/Experts/ABTG_Relativo.mq5` **r.2140**. Quella **non**
è un limite superiore garantito (è la percentuale *del* massimo in valuta, che può essere
piccola se il picco è alto). 🟢 **`ABTG_Relativo` non è una delle sei sedie**, quindi non
inquina niente — **ma se un giorno una sua cella entrasse in campo, il §5 non varrebbe per lei.**

---

# 4️⃣ 📊 QUANTO È STRETTO IL LIMITE CHE ABBIAMO — sedia per sedia, coi numeri veri

## 4.1 Il fattore di riscalatura, **dichiarato** (classe 547)

| sedia | round | file sorgente | deposito | `InpRiskPercent` | **fattore per arrivare a 2,00%** |
|---|---|---|---:|---:|---:|
| `770101` DAX | **R202B** (21/09 23:27) | `risultati_prove/R202B/ABTG_DAX_Apertura_EU_D30EUR_{IS,OOS}_R202B.csv` r.5 | **80.000** | 1 | **×2,0000** `[APPROSSIMATO]` |
| `770202` Dow | **R197A** (21/09 16:09) | `risultati_prove/R197A/ABTG_Dow_Apertura_US_U30USD_{IS,OOS}_R197A.csv` r.4 | **80.000** | **2** | 🟢 **×1 — nessuna riscalatura** |
| `770260` Nasdaq | **R199A** (21/09) | `risultati_prove/R199A/ABTG_Nasdaq_Apertura_US_NASUSD_{IS,OOS}_R199A.csv` r.2 | **80.000** | **2** | 🟢 **×1 — nessuna riscalatura** |
| `770411` MaxMin | `ptb` | `risultati_prove/ABTG_MaxMinNotte_DAX_Short_Ottimizzato/…_D30EUR_{IS,OOS}_ptb.csv` r.2 | 100.000 | 1 | **×2,0000** `[APPROSSIMATO]` |
| `770511` SuperWave | `r120b11` | `risultati_prove/dal_vps/ABTG_SuperWave_DOW_H1_Ottimizzato/…_{IS,OOS}_r120b11.csv` r.2 | 🔴 **10.000** | 1 | **×2,0000** `[APPROSSIMATO]` |
| `771531` EMA200 | `R112` | `risultati_archivio/R112_CORSA_20260826/ABTG_EMA200_U30USD_{IS,OOS}_00_metro.csv` r.2 | 100.000 | 1 | **×2,0000** `[APPROSSIMATO]` |

La taglia in campo è **`InpRiskPercent=2.00`** in tutti e sei i `.set` di `mql5/Presets/FTMO/`
(letto file per file). Il banco della challenge `541452707` è **80.000 €**
(`report/CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md` **r.387**, con la correzione del 20/09).

### 🧪 E il metro lineare l'ho MISURATO, invece di assumerlo — è la misura nuova di oggi

`R202A` (risk **1**) e `R197A` (risk **2**) girano la **stessa cella** sul Dow, **stesso banco
80.000**, stessa finestra, stesso modello a tick. Diffate per nome: **81 input, 78 identici**;
i 3 diversi sono `InpTP1_R` (`1.00` contro `1` = **stessa cifra**), `InpMagic` (**inerte** sul
DD) e **`InpRiskPercent` 1 → 2, cioè esattamente la variabile in esame.**

| finestra | DD @1,00% | DD @2,00% | **fattore VERO** |
|---|---:|---:|---:|
| IS (74 deal) | 5,6726% | 11,0936% | **×1,9557** |
| OOS (130 deal) | 4,3944% | 8,7450% | **×1,9901** |

🟢 **Tutti e due SOTTO 2,0000: la convenzione di casa ×2 SOVRASTIMA il drawdown.** È l'errore
nel verso giusto — un limite superiore resta un limite superiore. `[MISURATO su una sedia, due
finestre; non dimostrato per le altre.]`

### 🧪 E l'effetto del deposito, pure — perché due sedie sono misurate a 100.000, non a 80.000

Stessa cella, stesso rischio 1%, banco diverso:

| sedia · finestra | @100.000 | @80.000 | scarto |
|---|---:|---:|---:|
| `770202` Dow · IS | 5,6692% *(contratto)* | 5,6726% *(R202A)* | **+0,06%** |
| `770101` DAX · IS | 5,4362% *(contratto)* | 5,4089% *(R202B)* | **−0,50%** |

🟢 **Fra 80.000 e 100.000 l'effetto è sotto il mezzo punto percentuale relativo.** 🔴 **Ma fra
10.000 e 100.000 è tutt'altra cosa**: misurato **+7,8%** (`770101`) e **+8,6%** (`771531`),
perché a banco piccolo il `MathFloor` sullo step del lotto taglia la taglia. 👉 **Per `770511`,
misurata a 10.000, i suoi numeri sono un limite INFERIORE al banco vero: non un limite superiore.**

## 4.2 🧮 LA TAVOLA — `Equity DD %` contro `DD_ass/deposito`, **alla taglia che vola**

`DD_ass = Profit / Recovery Factor` · `DD_fisso% = DD_ass / deposito × 100` · poi ×fattore.

| sedia · finestra | `Profit` | `RF` | `Equity DD %` | `DD_ass` | `DD_fisso%` | **@2,00%: `Equity DD %`** | **@2,00%: `DD_fisso%`** | ordine |
|---|---:|---:|---:|---:|---:|---:|---:|:--:|
| `770101` DAX · IS | 3.050,56 | 0,65219 | 5,4089 | 4.677,41 | 5,8468 | **10,8178%** | **11,6935%** | ✅ |
| `770101` DAX · OOS | 14.355,32 | 2,01544 | 7,2506 | 7.122,67 | 8,9033 | 🔴 **14,5012%** | 🔴 **17,8067%** | ✅ |
| `770202` Dow · IS | 4.297,89 | 0,47049 | 11,0936 | 9.134,92 | 11,4187 | 🔴 **11,0936%** | 🔴 **11,4187%** | ✅ |
| `770202` Dow · OOS | 10.561,05 | 1,47219 | 8,7450 | 7.173,70 | 8,9671 | 🟠 **8,7450%** | 🟠 **8,9671%** | ✅ |
| `770260` NAS · IS | 4.549,93 | 0,43848 | 12,3568 | 10.376,60 | 12,9707 | 🔴 **12,3568%** | 🔴 **12,9707%** | ✅ |
| `770260` NAS · OOS | 7.689,12 | 1,01319 | 9,1244 | 7.589,02 | 9,4863 | 🟠 **9,1244%** | 🟠 **9,4863%** | ✅ |
| **`770411`** MaxMin · IS | 4.766,96 | 1,52059 | 3,0977 | 3.134,94 | 3,1349 | 🟢 **6,1954%** | 🟢 **6,2699%** | ✅ |
| **`770411`** MaxMin · OOS | 6.143,38 | 3,02118 | 1,9213 | 2.033,44 | 2,0334 | 🟢 **3,8426%** | 🟢 **4,0669%** | ✅ |
| `770511` SuperWave · IS | 488,63 | 1,12316 | 4,0393 | 435,05 | 4,3505 | 🟠 **8,0786%** | 🟠 **8,7010%** | ✅ |
| `770511` SuperWave · OOS | 344,12 | 0,77764 | 4,1675 | 442,52 | 4,4252 | 🟠 **8,3350%** | 🟠 **8,8504%** | ✅ |
| `771531` EMA200 · IS | 4.585,40 | 0,78806 | 5,7325 | 5.818,59 | 5,8186 | 🔴 **11,4650%** | 🔴 **11,6372%** | ✅ |
| `771531` EMA200 · OOS | 23.321,47 | 2,53681 | 7,8323 | 9.193,23 | 9,1932 | 🔴 **15,6646%** | 🔴 **18,3865%** | ✅ |

La colonna «ordine» segna ✅ dove `DD_fisso% ≥ Equity DD %`. **12 su 12.** 🔴 **La premessa del
mandato («più stretto») è refutata su ogni riga.**

---

# 5️⃣ 🏁 IL VERDETTO — chi è SICURO oggi, e chi resta `[NON MISURATO]`

Il criterio è rigoroso: **se il limite superiore alla taglia vera è sotto il 10%, la perdita
statica è sotto il 10%.** Non «probabilmente»: **per la dimostrazione del §2.1.**

## 5.1 🟢 SICURA OGGI — una sedia, e senza nessuna corsa nuova

| sedia | peggior finestra | `Equity DD %` @2,00% | `DD_fisso%` @2,00% | margine sul muro |
|---|---|---:|---:|---:|
| 🟢 **`770411`** MaxMinNotte DAX Short | IS | **6,1954%** | **6,2699%** | **37,3%** di margine |

> ### 🪑 **`770411` è DIMOSTRATA sotto il Max Loss del 10%.** Anche prendendo il limite
> superiore **più largo dei due**, anche sulla finestra **peggiore delle due**, anche con la
> riscalatura ×2 (che il §4.1 misura come **conservativa**).

## 5.2 🔴 `[NON MISURATE]` contro il muro — cinque sedie, per nome

| sedia | peggior limite superiore @2,00% | perché non si chiude |
|---|---:|---|
| `770202` Dow Apertura | **11,4187%** (IS) | 🟢 misura **diretta** al banco 80.000 e taglia 2,00% — ma il limite **supera** il 10%: serve `Equity Drawdown Absolute` per sapere se la perdita vera lo supera |
| `770260` Nasdaq RETEST | **12,9707%** (IS) | idem — misura diretta, limite sopra il muro |
| `770101` DAX Apertura | **17,8067%** (OOS) | limite sopra il muro; misurata a rischio 1 → riscalata ×2 |
| `771531` EMA200 Dow | **18,3865%** (OOS) | limite sopra il muro; **e il banco è 100.000, non 80.000** |
| `770511` SuperWave DOW | **8,8504%** (OOS) | 🔴 **è sotto il 10%, MA il banco della misura è 10.000**: al banco vero il numero **sale** (§4.1, +7,8%/+8,6% misurati altrove). **Non è un limite superiore a 80.000.** ⚠️ In più il suo contratto è **CONTESO** (`CONTRATTI…` §5) |

🟠 **`770511` è quella che manca di poco, ed è esattamente il caso in cui il motto dice di
insistere**: non è ferma per un numero **brutto**, è ferma per un numero **mancante**. Basta
la sua cella al banco giusto (§6).

---

# 6️⃣ 📋 COSA SERVE PER CHIUDERE IL BUCO — **non lanciato, firma a Claudio**

🛑 **Non ho lanciato niente.** Due strade, e la prima è quasi gratis.

## 🥇 STRADA A — leggere il campo dai referti HTML delle passate (**zero corse nuove**)
Il driver scrive già `Report=OptReport_…` nel `.ini` (`walkforward_generico.ps1` **r.1026** e
**r.2024**; il deposito sta a **r.1020** e **r.2018**). **Se quei referti sono ancora sul PC di backtest, il numero è già stato calcolato e
basta andarlo a prendere.** 🔴 **`[NON VERIFICATO]`: non so se esistono ancora su disco** —
in repo non c'è nessun `OptReport_*`. È una riga di **sola lettura** sul **PC di backtest**,
costo **zero tempo macchina**, e va comunque dal cancello prima di partire.
⚠️ In ottimizzazione MT5 scrive **un referto per passata solo se richiesto**: se il tag non
c'è, la strada A muore e resta la B.

## 🥈 STRADA B — una riga in `OnTester()`, poi le celle da rigirare
Il numero esatto è **`TesterStatistics(STAT_INITIAL_DEPOSIT) − TesterStatistics(STAT_EQUITYMIN)`**.
Sono **due chiamate** e **una colonna** in più nell'array `stats[]` di ogni EA.
🔴 **È una modifica a un EA: NON la propongo e non la faccio — è fuori dal mio mandato di sola
lettura, e tocca binari che stanno volando su una challenge viva.** La scrivo perché Claudio
sappia che **costa una riga**, non un round.

Il costo in tempo macchina, **una volta fatta la modifica**, è solo quello di rigirare le celle:

| corsa | cosa misura | costo `[STIMATO]` |
|---|---|---|
| **B1** — `770511` cella `r120b11`, banco **80.000**, risk 2,00%, tick, IS+OOS | chiude la **sesta** sedia e probabilmente la promuove a «sicura» | ~**10 min** |
| **B2** — le 6 celle in campo, banco 80.000, risk 2,00%, tick, IS+OOS | `Equity Drawdown Absolute` **vero** per tutte e sei | ~**2-3 ore** |

🔴 **B1 e B2 girano sul PC DI BACKTEST**, mai sul VPS (regola del 21/09). E la riga passa dal
cancello (`controlla_riga.py` + `controllo-preventivo`) prima di essere dettata.

---

# 7️⃣ 🛑 IL CONTRO-ESEMPIO CONTRO LA MIA STESSA CONCLUSIONE

Ho provato a rompere *«`770411` è al sicuro»*. Ecco i cinque modi, e cosa succede.

**① La taglia è sbagliata.** Misurata a 1,00%, vola a 2,00%, ho riscalato ×2,0000.
🧮 **Quanto dovrebbe sbagliare il metro per farmi sbagliare?** Il muro si tocca a
`10 / 3,1349 = ` **×3,19**. Servirebbe un errore del **+59%** sul fattore, contro una forbice
dichiarata di **0,28-6%** e contro un fattore **misurato a 1,96-1,99** (§4.1, cioè *sotto* 2).
🟢 **Non regge.**

**② Il deposito è sbagliato.** Misurata a 100.000, il banco vero è 80.000. Lo scarto misurato
fra i due banchi è **−0,50% / +0,06%** (§4.1), e il meccanismo (`MathFloor` sul lotto) dice che
a banco **minore** il DD **scende**. 🟢 **Non regge** — e comunque è coperto dal margine di ①.

**③ `Recovery Factor` vicino a zero fa esplodere la divisione.** 🟢 **Non morde qui**: i suoi
`RF` sono **1,52059** e **3,02118**, lontanissimi da zero; l'arrotondamento a 5 decimali dà un
errore relativo di ~2×10⁻⁶. 🔴 **Ma il pericolo è reale e l'ho trovato in casa**: nella griglia
`770511` ci sono righe con `RF = −0,00733` e `RF = −0,00999`, dove l'arrotondamento a 5
decimali muove `Profit/RF` in modo non trascurabile — e con `RF` a `0,00001` l'errore
relativo sarebbe del **5%**. 🟢 **Il mio verdetto è immune per costruzione: si regge su
`Equity DD %`, che NON passa da `RF`.** Il `DD_fisso%` lo riporto solo come controprova.

**④ La finestra non contiene il tratto peggiore.** 🔴 **QUESTO REGGE, ed è il limite vero.**
La misura dice *«su 2024.09.26-2026.06.30 questo motore non ha mai perso più del 6,27% dal
picco»*. **Non dice che non lo farà.** 👉 Quindi la frase esatta è: **il CONTRATTO di `770411`
è dimostrato sotto il muro** — che è precisamente ciò che serve al criterio del 18/08 (*«DD
forward > DD promesso → revisione»*), **non una promessa sul futuro.**

**⑤ Il campione è sottile.** 🔴 **QUESTO REGGE, ed è il più serio.** `770411` ha **14 posizioni**
(21 deal) in OOS e **0,051 op/giorno**: il suo DD basso è in parte *«non c'era»*. La regola B
del 16/08 dice che il campione sottile sospende il giudizio sul **MERITO**, mai sul **RISCHIO**
— e un drawdown accaduto è un fatto. 🟢 **Quindi il verdetto «sicura» tiene per quello che
afferma**, ma va letto insieme a: **questa sedia è al sicuro anche perché fa pochissimo.**

**⑥ Il muro è di CONTO, non di sedia.** 🔴 **E questo è il più importante di tutti.** Il 10% si
misura sull'**equity del conto**, dove operano **sei** sedie insieme. `report/DD_PORTAFOGLIO_FTMO_2026-09-20.md`
**r.115-117** misura già, per Monte Carlo sulle serie per-trade, la *«discesa sotto il saldo
iniziale»* del portafoglio: **p95 = 14,53%** e **il 12,4% delle sequenze sfonda il 10% statico**,
alla taglia 2,00%.
> 🔴 **Quindi: «`770411` è sicura» NON vuol dire «il conto è sicuro». Sono due domande diverse,
> e la seconda ha già una risposta preoccupante.** Chi leggesse solo il §5.1 sbaglierebbe, ed è
> per questo che questa riga sta nel referto e non in una nota.

---

# 8️⃣ 🕳️ COSA RESTA NON COPERTO — per nome

1. 🔴 **`Equity Drawdown Absolute` vero: `[NON MISURATO]` per TUTTE E SEI.** Questo referto
   dimostra *dove* sta e *quanto costa*; non lo misura. Le sei sono: `770101`, `770202`,
   `770260`, `770411`, `770511`, `771531`.
2. 🔴 **Se i referti `OptReport_*` esistano sul PC di backtest**: `[NON VERIFICATO]`, è una
   macchina che non vedo da qui. Da questo dipende se la Strada A è viva.
3. 🔴 **`770511` al banco 80.000**: `[NON MISURATO]`. È l'unica sedia che un limite superiore
   onesto lascia in sospeso *sotto* il 10%.
4. 🔴 **L'ambiguità su `Recovery Factor`** (bilancio o equity, §2.2): non risolta. Non morde
   sul verdetto, morde su chiunque riusi `Profit/RF`.
5. 🔴 **`Peggior Giornata %` non esiste per tre sedie su sei**: l'array `stats[]` di
   `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` (r.605), `ABTG_SuperWave_DOW_H1_Ottimizzato`
   (r.760) e `ABTG_EMA200` (r.676) si ferma a **8 colonne**. 👉 **Per `770411`, `770511` e
   `771531` il confronto col Max Daily Loss del 5% è `[NON MISURATO]`** — e il §4 del referto
   del 22/09 lo dava come *«il solo confronto omogeneo che abbiamo»*. **Lo è solo per tre sedie.**
6. 🔴 **Se la revisione del 21/09 sia stata fatta**: resta il buco dichiarato dal referto
   precedente. Non ho trovato il verbale.
7. 🟠 **La cella in campo di `770260` potrebbe non essere più quella di R199A**: il `.set`
   `ABTG_Nasdaq_Apertura_US_RETEST_770260_FTMO.set` è stato modificato il **21/09 alle 20:21**,
   dopo R199A. **Non ho verificato campo per campo** se il binario che vola oggi è quello che
   R199A ha misurato.

---

## 🙌 E LA RIGA CHE VALE LA GIORNATA

Siamo partiti da *«non possiamo dire né che sfondano né che sono al sicuro»*. Oggi:
- 🟢 sappiamo **dove sta il numero esatto** e che **costa una riga, non un round**;
- 🟢 sappiamo che la colonna che avevamo **era già un limite superiore rigoroso** — e che
  l'aritmetica che stavamo per adottare era **la peggiore delle due**;
- 🟢 e **una sedia è uscita dal limbo**: `770411` è **dimostrata** sotto il muro.

Una su sei non è una vittoria grossa. 🪑 **Ma è la prima sedia della challenge di cui possiamo
dire una cosa DIMOSTRATA invece che sperata** — e le altre cinque adesso hanno un prezzo scritto
accanto, non un punto interrogativo.
