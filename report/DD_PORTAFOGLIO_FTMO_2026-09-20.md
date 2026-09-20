# 🧱 IL DD DI PORTAFOGLIO CONTRO I MURI FTMO — sei sedie a `InpRiskPercent=2.00`

**20/09/2026** · conto FTMO **541452707**, 100k 2-Step, già pagato 439 EUR, **AutoTrading SPENTO**.
**Sola scrivania**: nessun backtest eseguito, nessun preset, EA, taglia o magic toccato.
Tutto quello che c'è qui è **misurato su file in repo** o **dichiarato non misurabile**.

---

# 0️⃣ LE TRE RIGHE CHE CONTANO

> ## 🔴 **NO. Le sei sedie a 2,00% NON stanno sotto i muri, e il margine è NEGATIVO su tutti e due.**
>
> **Muro STATICO 10%** — il portafoglio di **quattro** delle sei (tick reali, stessa finestra OOS,
> scala lineare a 2,00%) fa **13,91%** di massima discesa e sfonda il 10% nel **12,4%** dei
> rimescoli Monte Carlo: **una challenge su otto muore**, e mancano ancora due sedie.
> **Margine: −3,91 punti** (e a 1,00% era **+3,05**).
>
> **Muro GIORNALIERO 5%** — non serve il Monte Carlo: **il 26/02/2026 è già successo.**
> Tre sedie prese lo stop lo stesso giorno (`770101` 09:00 · `770202` 16:07 · `771531` 16:21) =
> **−6,87%** a 2,00%. **Margine: −1,87 punti.** Giornate oltre il 5% nella sola finestra OOS: **2**.
>
> **E c'è il controllo REALIZZATO, che dice la stessa cosa**: `770101` sul demo piccolo ha girato
> davvero a **~2,0% per trade** (stop pieni misurati −1,87%…−2,23% del saldo) e in **25 giorni**
> ha prodotto **747,60 EUR di discesa = 13,69% dal picco**. **Da sola.** Il backtest a 2,00%
> prometteva 13,42-14,47%: **il forward l'ha confermato al decimo.**

---

# 1️⃣ LA TABELLA DELLE SEI — DD alla stessa unità (2,00%), con la fonte

**Convenzione di scala dichiarata**: il DD scala **linearmente** con `InpRiskPercent`
(convenzione di casa, già usata in `REFERTO_PORTAFOGLIO_R16.md` e in `CONTRATTI_SEDIE.md` §2).
Fattori: **da 1,00% → ×2,0000** · **da 0,65% → ×3,0769**.
⚠️ La linearità è **leggermente PESSIMISTICA** su una striscia perdente a size fissa-frazionale
(`1−(1−2r)^N < 2·(1−(1−r)^N)`), ed è **OTTIMISTICA** sul resto: i numeri sotto sono `Equity DD %`
del tester, che **non** include ciò che il muro FTMO include (il floating fra una chiusura e l'altra
è dentro, ma lo slippage di esecuzione della prop no).

| # | sedia | DD **misurato** | taglia della misura | ×fattore | **DD @2,00%** | fonte (file + riga) |
|---|---|---:|---:|---:|---:|---|
| 1 | **`770101`** DAX Apertura | **7,2328%** *(OOS, dep. 100k)* | 1,00% | ×2 | 🔴 **14,47%** | `backtest_pipeline/risultati_prove/aperture_r47/ABTG_DAX_Apertura_EU_D30EUR_OOS_r47a.csv` r.2-3 (`InpMagic` 772501/772502 · PF 1,39709 · n 270 · `InpRiskPercent=1`) |
| 1b | *idem, altro deposito* | 6,7111% *(OOS, dep. 10k)* | 1,00% | ×2 | 13,42% | `report/CONTRATTI_SEDIE.md` §5+1 storiche (serie R119) |
| 1c | *idem, finestra IS* | 5,4362% *(IS, n 175)* | 1,00% | ×2 | 10,87% | `.../aperture_r47/ABTG_DAX_Apertura_EU_D30EUR_IS_r47a.csv` |
| 2 | **`770411`** MaxMin DAX Short | **1,27%** *(OOS, n 21)* | 1,00% | ×2 | 🟢 **2,54%** | `backtest_pipeline/risultati_archivio/REFERTO_PORTAFOGLIO_R16.md` tab. serie (magic 770413) |
| 2b | *idem, promozione 26/07* | 🟠 **3,1%** *(n 41, PF 2,05)* | 1,00% | ×2 | 🟠 **6,20%** | `report/CONTRATTI_SEDIE.md` riga `770411` · `REGISTRO_TEST.md` §MaxMinNotte raffinamento |
| 3 | **`770202`** Dow Apertura | **4,3941%** *(OOS, n 130)* | 1,00% | ×2 | 🔴 **8,79%** | `.../aperture_r47/ABTG_Dow_Apertura_US_U30USD_OOS_r47c.csv` r.2-3 (772505/772506 · PF 1,27013) |
| 3b | *idem, finestra IS* | 5,6692% *(IS, n 74)* | 1,00% | ×2 | 11,34% | `.../aperture_r47/ABTG_Dow_Apertura_US_U30USD_IS_r47c.csv` |
| 4 | **`771531`** EMA200 Dow | **7,8323%** *(contratto rivisto, tick, dep. 100k)* | 1,00% | ×2 | 🔴 **15,66%** | `report/FIRME_2026-09-11.md` r.101-102 (*«passa da 7,21% a 7,8323%»*) · `report/CHE_SI_FA_2026-09-11.md` r.75 |
| 4b | *ricalcolo mio sui deal* | 7,54% *(aggregazione giornaliera, dep. 100k)* | 1,00% | ×2 | 15,08% | `backtest_pipeline/risultati_prove/trades_candidati_r23/abtg_trades_ABTG_EMA200_U30USD_771521.csv` (517 deal, 2025.06.12→2026.06.26) via `dd_portafoglio.py` |
| 5 | **`770511`** SuperWave Dow H1 | **3,9082%** *(OOS, n 143, PF 1,32770)* | 1,00% | ×2 | 🟠 **7,82%** | `backtest_pipeline/risultati_prove/ABTG_SuperWave_DOW_H1_Ottimizzato/..._U30USD_OOS.csv` Pass 3 |
| 5b | *stessa cella, corsa r3* | 🔴 **5,1118%** *(n 143, PF 1,09636)* | 1,00% | ×2 | 🔴 **10,22%** | `..._U30USD_OOS_r3.csv` Pass 3 — **due corse danno due DD diversi sulla stessa n** |
| 5c | *finestra IS, n 349* | 6,6941% | 1,00% | ×2 | 13,39% | `..._U30USD_IS.csv` Pass 0 |
| 6 | **`770260`** Nasdaq RETEST | **3,6753%** *(OOS, n 94)* | 1,00% | ×2 | 🟠 **7,35%** | `backtest_pipeline/risultati_archivio/Walkforward_Aperture/NASDAQ_B_motore_OOS.csv` Pass **8** (`InpEntryMode=2` · PF 1,10936 · `InpRiskPercent=1`) |
| 6b | *finestra IS, n 91* | 🔴 **5,9528%** | 1,00% | ×2 | 🔴 **11,91%** | `.../NASDAQ_B_motore_IS.csv` Pass **8** |

### ✏️ Due correzioni di fonte trovate strada facendo (non cambiano il verdetto, cambiano la tracciabilità)
1. 🔴 **`report/DUE_SEDIE_NASDAQ_IL_BLOCCO_2026-09-19.md` r.22 attribuisce a `770260` un DD **IS** di
   **5,8450**: quello è il **Pass 6** (BREAKOUT). Il Pass 8 (RETEST, la sedia schierata) in IS fa
   **5,9528**. Verificato riga per riga su `NASDAQ_B_motore_IS.csv`.
2. 🟠 `report/CONTRATTI_SEDIE.md` (riga `770101`) legge la coppia r47a/r47b come *«270 uscite, 193
   posizioni»*. **Non è così**: le due gemelle differiscono per `InpTP1_ClosePct` (**50** vs **0**),
   non per il conteggio deal/posizioni — verificato colonna per colonna. La cella **viva** è la r47a
   (`InpTP1_ClosePct=50.0` nel preset `mql5/Presets/FTMO/ABTG_DAX_Apertura_EU_770101_FTMO.set`),
   quindi il DD giusto è **7,2328%**, ed è quello che ho usato. Idem per il Dow: r47c
   (`TP1_ClosePct=50`) e non r47d.

### ➕ La somma banale — che NON è il DD di portafoglio, e si dice
| lettura | somma dei DD singoli @2,00% |
|---|---:|
| prendendo i DD **più favorevoli** (OOS) | **56,63%** |
| prendendo i DD **peggiori misurati** (regola di casa: *il rischio si legge a qualunque n*) | **72,97%** |

🔴 **Questa somma è un limite superiore inutile** (R16 ha misurato che 22,11% di somma diventano
8,91% combinati). Sta qui solo perché **nessuno l'aveva mai scritta**, e perché dà l'ordine di
grandezza del problema: **due sedie su sei sfondano il muro del 10% DA SOLE.**

---

# 2️⃣ IL DD DI PORTAFOGLIO — misurato su **quattro** sedie su sei

## 2.1 🟢 I dati per sommarle CI SONO, ma solo per quattro

| sedia | serie per-trade in repo | usata |
|---|---|---|
| `770101` | `risultati_prove/aperture_r47/abtg_trades_..._D30EUR_772502.csv` (270 deal) | ✅ |
| `770202` | `risultati_prove/aperture_r47/abtg_trades_..._U30USD_772505.csv` (130 deal) | ✅ |
| `770411` | `risultati_prove/trades_portafoglio/abtg_trades_..._D30EUR_770413.csv` (21 deal) | ✅ |
| `771531` | `risultati_prove/trades_candidati_r23/abtg_trades_..._U30USD_771521.csv` (517 deal) | ✅ |
| 🔴 **`770511`** | **[NON ESISTE]** — in repo solo i riepiloghi `..._OOS.csv`, nessun `abtg_trades_*` | ❌ |
| 🔴 **`770260`** | **[NON ESISTE]** — idem, solo `NASDAQ_B_motore_{IS,OOS}.csv` | ❌ |

🟢 **Perché le quattro sono confrontabili**: stessa finestra (**2025.06.10 → 2026.06.29**, 242
giorni con trade), stesso deposito (**100.000**), stesso rischio (**1,00%**), **tick reali**.
🔴 **E perché la misura resta parziale**: le due che mancano sono **entrambe correlate a quelle che
ci sono** — `770511` è la **terza** sedia su `U30USD` (dopo `770202` e `771531`), `770260` apre
sulla **stessa campana USA** di `770202`. L'aggiunta di due sedie correlate **non può** migliorare
il numero in modo prevedibile: **il 13,91% è un pavimento, non un tetto.**

## 2.2 🔢 IL NUMERO, nella metrica giusta

🔴 **La metrica di `dd_portafoglio.py` ("DD dal picco") NON è la metrica FTMO.** Il 2-Step ha un muro
**STATICO**: *«equity must not drop below 90% of the initial account balance at any given time»*
(`docs/REGOLAMENTO_FTMO_2026-08.md` §2). Quindi la domanda giusta è **"quanto scende sotto i
100.000"**, e la risposta dipende **dall'ORDINE** in cui arrivano i giorni — cioè esattamente ciò
che il Monte Carlo sui giorni interi misura.

| | **@1,00%** *(come misurato)* | **@2,00%** *(scala ×2)* |
|---|---:|---:|
| netto sulla finestra | +54.216 (+54,2%) | +108.433 (+108,4%) |
| max DD **dal picco**, in % del deposito | 6,95% | 🔴 **13,91%** |
| **peggior giornata storica** | −3,44% | 🔴 **−6,87%** *(26/02/2026)* |
| giornate oltre **−5,00%** (muro FTMO) | **0** | 🔴 **2** |
| giornate oltre **−4,90%** (emergenza Guardian) | 0 | 2 |
| giornate oltre **−4,00%** (pausa Guardian) | 0 | 🟠 **11** |
| MC 5000 rimescoli — discesa sotto il saldo iniziale **p95** | 7,26% | 🔴 **14,53%** |
| MC — **p99** | 11,46% | 🔴 **22,91%** |
| 🔴 **MC — quante sequenze sfondano il 10% STATICO** | **1,7%** | 🔴 **12,4%** |

- Correlazioni giornaliere: **tutte fra −0,01 e +0,13**. La più alta è `770202` vs `771531`
  (**+0,13**), le due sedie che dividono `U30USD`. 🟢 **La diversificazione esiste** (somma dei
  singoli 19,28% → storico combinato 5,19% dal picco a 1,00%): **non è questo il problema.**
- 🔴 **Il problema è la TAGLIA**: a 1,00% la stessa flotta sfonda il muro nell'**1,7%** delle
  sequenze, a 2,00% nel **12,4%**. Il rischio non raddoppia: **si moltiplica per 7,3**.
- ⚠️ **`dd_portafoglio.py` aggrega per GIORNO** e quindi ignora il floating *dentro* la giornata:
  sul DAX dà 6,25% dove il tester tick-by-tick dà **7,2328%** (**−15,7%**). 🔴 **Tutti i numeri di
  questa tabella sono quindi LIMITI INFERIORI**, e il muro FTMO giornaliero è su **equity**, cioè
  include proprio quel floating.

## 2.3 💥 LA GIORNATA CHE DECIDE — **26/02/2026**, e non è un'ipotesi

| ora (server backtest) | sedia | lotti @1,00% | netto @1,00% | **netto @2,00%** | **cumulato @2,00%** |
|---|---|---:|---:|---:|---:|
| 06:01 | `771531` (parziali) | 2,60→0,10 | −9,37 | −18,74 | −0,02% |
| **09:00:32** | **`770101`** DAX | 31,60 | −1.194,48 | **−2.388,96** | 🟠 **−2,41%** |
| **16:07:46** | **`770202`** Dow | 25,30 | −1.081,75 | **−2.163,50** | 🟠 **−4,57%** |
| **16:21:30** | **`771531`** EMA200 ×2 | 8,70 + 13,20 | −1.149,48 | **−2.298,96** | 🔴 **−6,87%** |

👉 **Tre finestre diverse, tre stop pieni, un giorno solo.** È la risposta misurata alla domanda
«quante possono perdere LO STESSO GIORNO»: **almeno tre, e con le due che mancano potrebbero
essere cinque.** Seconda peggiore, il **15/10/2025**: **quattro** sedie in perdita (`770202`,
`770411`, `771531`) per **−6,33%** a 2,00%.

---

# 3️⃣ 🔴 I DUE RIGHELLI — e il secondo NON dice quello che pensavamo

## 3.1 ⚠️ PRIMA UNA CORREZIONE, perché il numero «0,96% a 0,65%» in repo NON ESISTE

Cercato con `grep` su **tutto** il repository (escluse `.git` e le worktree degli agenti).
**L'unica occorrenza di `0,96%` è questa:**

> `report/P0_OPENINGREVERSALB_2026-09-08.md` r.38 — *«**Rischio: DD 0,96%** — leggibile a qualunque
> n, ed è un buon numero. Ma su due trade dice poco anche quello.»*

🔴 **È il DD di BACKTEST di `ABTG_OpeningReversalB`, un candidato BOCCIATO con n=2** (frequenza
0,0078 op/giorno, 128 volte sotto il pavimento). **Non è forward, non è realizzato, non è del
portafoglio, e non è di nessuna delle sei sedie.** Quindi anche il derivato «~2,96% a 2,00%» va
ritirato: **era un numero orfano**. Classe nuova: **492** in `CHECKLIST_RIGA_DI_LANCIO.md`.

## 3.2 ✅ IL RIGHELLO REALIZZATO VERO, misurato adesso su `data/statements/`

### ▸ (a) Sul **100k dry-run 50504263** — il conto a taglia uniforme 0,65%
Fonte: `data/statements/trades_100k.csv` (35 righe totali, **22** delle sei sedie).

| | |
|---|---|
| finestra | **10/08/2026 → 17/09/2026** (19 giorni con trade) |
| sedie che hanno **davvero** operato | 🔴 **3 su 6** — `770101` (n 15) · `770411` (n 4) · `770202` (n 3) |
| `771531`, `770511`, `770260` | 🔴 **ZERO operazioni** |
| netto | +3.176,36 |
| **DD realizzato** | **647,82 = 0,648%** |
| picco di sedie **aperte insieme** | 🔴 **UNA** |

> ## 🔴 **Quel 0,648% non è un drawdown di portafoglio: è UNA perdita singola.**
> 0,648% a taglia 0,65% = **1R esatto**. Il conto non ha mai avuto due sedie aperte insieme e tre
> sedie su sei non hanno mai sparato. 👉 **Presentarlo come "il realizzato del portafoglio" sarebbe
> la stessa mezza verità del caso peggiore da solo, al contrario.**

### ▸ (b) Sul **piccolo 50503392** — e qui c'è l'oro, perché `770101` girava DAVVERO al 2%
Fonte: `data/statements/trades_auto.csv` (1.322 righe, **85** delle sei sedie, 20/07→18/09/2026).
Saldo ricostruito col metodo di `report/M31_RISCHIO_REALIZZATO_2026-09-02.md` (ancora: `772361`
del 14/08 a saldo 5.102) — **riprodotto: i saldi 6.049 e 5.207 tornano all'euro con M31**.

**Gli stop pieni di `770101`, in % del saldo al momento dell'apertura:**

| data | netto € | saldo prima | **% del saldo** |
|---|---:|---:|---:|
| 23/07 | −114,30 | 5.807 | **−1,97%** |
| 29/07 | −115,04 | 5.658 | **−2,03%** |
| 29/07 | −120,80 | 5.422 | **−2,23%** |
| 29/07 | −115,04 | 5.301 | **−2,17%** |
| 06/08 | −102,96 | 5.542 | **−1,86%** |
| 10/08 | −101,83 | 5.322 | **−1,91%** |
| 14/08 | −104,60 | 5.207 | **−2,01%** |

> ## 🎯 **`770101` in forward ha girato a ~2,0% per trade — cioè ESATTAMENTE la taglia firmata per FTMO.** Non è una simulazione: è un conto vero, per 39 posizioni.

**E il risultato di quei due mesi:**

| | |
|---|---:|
| discesa massima di `770101` | **747,60 €** (picco 22/07 → fondo 14/08) |
| saldo al picco | 5.460,63 € |
| 🔴 **DD dal picco** | 🔴 **13,69%** |
| DD su 5.100 nominale | 14,66% |
| **contro il backtest a 2,00%** | 13,42% (dep. 10k) — **14,47%** (dep. 100k) |

> ## 🔥 **Il realizzato e il caso peggiore da backtest COINCIDONO: 13,69% contro 13,42-14,47%.**
> Non divergono. Il backtest **non** era pessimista: era **giusto**. E la sedia che l'ha prodotto è
> **una sola delle sei**.

**Il resto delle sei sul piccolo** (taglie MISTE — `770101` ~2,0%, le altre nominalmente 1,0% ma
`770511` col difetto del pavimento lotto, quindi **non normalizzabili a un solo fattore**):

| sedia | n | netto € | DD realizzato € | note |
|---|---:|---:|---:|---|
| `770101` | 39 | −509,66 | **747,60** | ~2,0%/trade, vedi sopra |
| `770411` | 5 | +155,78 | 0,00 | **5/5 vinte** |
| `770202` | 4 | +0,35 | 18,68 | campione nullo |
| `771531` | 21 | −19,39 | 93,08 | |
| `770511` | 16 | +344,33 | 16,97 | binario con lotto gonfiato |
| 🔴 `770260` | **0** | — | — | 🔴 **mai girata in forward, su nessun conto** |
| **le sei insieme** | **85** | −28,59 | **652,34** | **12,79%** di 5.100 — a taglie miste |

**Concorrenza realizzata**: picco di **2 sedie** aperte insieme (27/07) e **4 posizioni** insieme
(25/08 03:00). Massimo di **perdite chiuse in un giorno: 4** (04/09). E il **29/07** `770101` da
sola ha preso **tre stop nello stesso giorno = −6,88%** del conto — *(caveat onesto: M31 e il
verbale C1 del 02/09 attribuiscono la coppia gemella del 29/07 a una configurazione a doppio
grafico che **oggi non esiste più**; anche togliendo una delle due, restano **−4,62%** in un
giorno)*.

## 3.3 ⚖️ I DUE RIGHELLI FIANCO A FIANCO

| | **(a) caso peggiore da BACKTEST** | **(b) REALIZZATO in forward** |
|---|---|---|
| **cosa misura** | il peggio che quelle celle hanno fatto su 12,6 mesi di tick reali, con **tutte** le sedie accese **tutti** i giorni | quello che è successo **davvero**, con le sedie che erano accese **quando** erano accese |
| **numero @2,00%** | portafoglio (4/6): **13,91%** dal picco · p99 **22,91%** · peggior giorno **−6,87%** | `770101` da sola a ~2,0%: **13,69%** · peggior giorno **−6,88%** (29/07) |
| **campione** | 242 giorni, 938 deal | 39 posizioni in 25 giorni (`770101`) · 85 posizioni in 2 mesi (le sei) |
| **a favore** | copre regimi che il forward non ha visto | **esecuzione vera**, spread veri, slippage vero |
| **contro** | scala lineare, aggregazione giornaliera (sottostima il floating) | 🔴 **quasi nessuna sovrapposizione**: max **2** sedie insieme, **1** sul 100k |

> ## 🎯 **PERCHÉ NON DIVERGONO, ed è la notizia brutta.**
> Ci aspettavamo che il realizzato fosse più mite del backtest. **Non lo è.** Sul solo caso in cui
> forward e backtest si possono confrontare **alla stessa taglia** (`770101` a ~2%), i due numeri
> stanno a **8 decimi di punto** l'uno dall'altro. 🔴 **L'unica ragione per cui il conto piccolo non
> è saltato è che non era una prop**: 13,69% su un conto FTMO 2-Step è **challenge finita**.

---

# 4️⃣ 📅 IL GIORNALIERO AL 5% — chi apre quando, e quante possono perdere insieme

Orari **FTMO** dai preset installati (`mql5/Presets/FTMO/`, già rimappati +2 sull'orologio BCM,
`report/PRESET_FTMO_OROLOGIO_2026-09-20.md`):

| sedia | TF | finestra di **ingresso** | chiusura | sovrapposizione |
|---|---|---|---|---|
| `770411` MaxMin DAX Short | M15 | box 1→6, piazza **9**, cutoff **10** | **19** | tiene la posizione fino alle 19 |
| `770101` DAX Apertura | M5 | session **10** | **19** | |
| `770202` Dow Apertura | M5 | session **16** | **19** | |
| `770260` Nasdaq RETEST | M5 | session **16** | **19** | |
| `771531` EMA200 Dow | H1 | **0-24** (cutoff 21 e FriClose 22 **inerti**) | — | sempre |
| `770511` SuperWave Dow | H1 | **0-24 invariato** | — | sempre |

> ## 🔴 **Fra le 16:00 e le 19:00 FTMO possono essere vive TUTTE E SEI.** Sei × 2,00% = **12,00%** di rischio aperto simultaneo teorico — **sopra il muro STATICO del 10%**, non solo sopra il giornaliero.

**L'aritmetica del muro giornaliero, su 100.000:**

| | valore |
|---|---:|
| muro FTMO 5% | **5.000 $** |
| 1R a 2,00% | **2.000 $** |
| **stop pieni che il giorno regge** | 🔴 **DUE** (4.000 = 4,00%) |
| il **terzo** | 🔴 **6.000 = 6,00% → FUORI** |

**E il terzo è già successo**: 26/02/2026 (backtest, tre sedie) e 29/07/2026 (forward, `770101`
da sola, tre stop). 🟢 **Il mitigante misurato**: la perdita **media** è solo il **36%** della
peggiore sul piccolo (**0,40** sul 100k, come dice il commento del preset Guardian) — grazie a
breakeven e trailing, tre stop *pieni* nello stesso giorno sono l'eccezione. 🔴 **Ma il muro FTMO
non si tocca "in media".**

⚠️ **E tutto questo è calcolato su P&L CHIUSO.** Il 5% FTMO è su **equity, floating incluso**: una
posizione aperta in perdita conta **prima** di chiudere. Il nostro conteggio è quindi un **limite
inferiore** anche qui.

---

# 5️⃣ 🛡️ IL GUARDIAN — regge?

Preset: `mql5/Presets/ABTG_Guardian_FTMO_2Step.set` (letto riga per riga).
`InpStartBalance=100000` · `InpDailyLossPct=4.9` · `InpTotalDDPct=9.9` · `InpDDMode=0` ·
`InpDailyResetHour=1` · `InpAction=0` (CHIUDI+BLOCCA) · `InpCloseAllMagics=true` ·
`InpDailyPausePct=4.0` · **`InpMaxOpenRiskPct=4.00`** · `InpRiskMode=0`.

## 5.1 ✅ Domanda secca: **quante posizioni lascia aperte il C1 a 4,00% con sedie a 2,00%?**

> ## 🟢 **DUE. E la risposta è giusta.**
> `ABTG_Guardian.mq5` r.789: `if(InpMaxOpenRiskPct>0 && riskPct>=InpMaxOpenRiskPct)` → con **due**
> posizioni `riskPct` vale **4,00%**, che è **≥ 4,00%**: il cap si accende e **blocca la terza**.
> Due restano, la terza no. Il commento del preset lo dichiara e il conto torna:
> `2 × 2,00% = 4,00% dentro il 5%` · `3 × 2,00% = 6,00% sfonda`.

**🔴 Ma il C1 ha QUATTRO buchi dichiarati, e tre mordono proprio qui:**

| # | buco | dove sta scritto | perché morde a 2,00% |
|---|---|---|---|
| **B1** | 🔴 **non conta la perdita GIÀ REALIZZATA del giorno** | `OpenRiskPct()` r.385 legge **solo** le posizioni aperte | dopo due stop chiusi (−4,00%) il C1 vede **0,00%** di rischio aperto e **lascia entrare altre due**. Il tetto sul giorno lo fa **solo** `InpDailyPausePct=4.0` |
| **B2** | 🔴 **non è un cap istantaneo: un PENDENTE già piazzato passa** | `ABTG_PausaGuardian.mqh`, commento di testa: *«un ordine PENDENTE gia' piazzato quando il cap era libero scattera' lo stesso»* | `770101`, `770202` e `770260` hanno **`InpEntryMode=2` (RETEST con LIMIT)**: tre pendenti piazzati a cap libero possono riempirsi **tutti e tre** = **6,00%** |
| **B3** | 🟠 **fail-open** | stesso file: *«se il guardiano NON gira, tutto ritorna false»* | un Guardian non attaccato = flotta senza rete, **in silenzio** |
| **B4** | 🟢 *(non morde su FTMO)* la versione in campo sul piccolo è a 15 input | `CLAUDE.md` §Guardian | sul terminale FTMO si compila da HEAD: **tutti e sei i sorgenti leggono il Guardian** — verificato: `ABTG_DAX_Apertura_EU` (7 chiamate), `ABTG_Dow_Apertura_US` (7), `ABTG_Nasdaq_Apertura_US` (9), `ABTG_EMA200` (1), `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` (1), `ABTG_SuperWave_DOW_H1_Ottimizzato` (1) |

## 5.2 📏 Il margine fra 9,9% e 10%, in valore assoluto — **e basta per lo slippage?**

| | valore |
|---|---:|
| emergenza totale Guardian 9,9% | equity 90.100 $ |
| muro FTMO 10,0% | equity 90.000 $ |
| 🔴 **margine** | 🔴 **100 $** (0,10%) |
| idem sul giornaliero (4,9% vs 5,0%) | 🔴 **100 $** |

**Quanti PUNTI di slippage comprano 100 $ a 2,00%?** Lotti scalati ×3,0769 dalla tabella margini di
`report/PACCHETTO_SCHIERAMENTO_PROP_2026-09-21.md` §2.2 (valore punto 1 per lotto su `D30EUR`,
`U30USD`, `NASUSD` — verificato sui trade veri: 8,30 lotti × 3,00 punti = 24,90 €):

| sedia | lotti @2,00% | $/punto | 100 $ comprano |
|---|---:|---:|---:|
| `770101` DAX | 23,97 | 23,97 | **4,2 punti** |
| `770202` Dow | 16,15 | 16,15 | 6,2 punti |
| `771531` EMA200 | 19,17 | 19,17 | 5,2 punti |
| `770511` SuperWave | 25,94 | 25,94 | **3,9 punti** |
| `770260` Nasdaq | 24,03 | 24,03 | 4,2 punti |
| 🔴 **due aperte insieme** (le due più care, `InpCloseAllMagics=true` le chiude entrambe) | **45,11** | **45,11** | 🔴 **2,2 punti** |

> ## 🔴 **NO: 100 $ NON bastano.** A 0,65% quel cuscino valeva 6-13 punti; a 2,00% vale **2-4 punti**, e sul Dow all'apertura US 2 punti sono uno spread normale. 👉 **Il cuscino del Guardian non è stato riscalato quando è stata riscalata la taglia.**

## 5.3 🔴 IL MURO CHE NESSUNO HA GUARDATO: **il MARGINE**

Scalando la tabella verificata del pacchetto (fattore ×3,0769 da 0,65%):

| sedia | margine @2,00%, **1:15** | % del conto |
|---|---:|---:|
| `770101` | 47.757 $ | 47,8% |
| `770411` | 45.271 $ | 45,3% |
| `770202` | 57.295 $ | 57,3% |
| `771531` | 68.009 $ | 68,0% |
| 🔴 **`770511`** | 🔴 **92.003 $** | 🔴 **92,0%** |
| `770260` | 47.234 $ | 47,2% |
| **TOTALE sei** | 🔴 **357.569 $** | 🔴 **357,6%** |
| *(stesso conto a 1:50 indici, conto Standard)* | *107.268 $* | 🔴 *107,3%* |

> ## 🔴 **A 2,00% e 1:15, `770511` da sola prende il 92% del conto, e la SECONDA posizione viene rifiutata dal broker PRIMA che il C1 la veda.** Il cap C1 a 4,00% è stato alzato *«perché 3.25 lasciava passare UNA SOLA posizione»* (commento del preset): 🔴 **a 1:15 ne passa comunque una sola, ma per MARGINE.** E il sintomo è muto: `not enough money` nel Giornale, nessun allarme.
> ⚠️ Tutto `[INFERITO]` sull'ipotesi H2 (*margine = nozionale/leva*): **nessuno ha mai letto una
> specifica di contratto FTMO**. Si chiude con uno screenshot. **Ma anche a 1:50 si sfora il 100%.**

---

# 6️⃣ 🧪 IL CONTRO-ESEMPIO — costruito per far sbagliare questo referto

**La conclusione è «NON REGGE». Quindi il contro-esempio obbligato è: _perché allora il realizzato
è così basso?_** Quattro spiegazioni possibili, provate una per una.

| ipotesi che mi smentirebbe | verifica | esito |
|---|---|---|
| **H-A** — *«il forward mostra 0,648%, quindi il backtest è pessimista»* | il 0,648% viene dal 100k dove hanno operato **3 sedie su 6**, **22 posizioni**, **mai due insieme**, e vale **1R esatto** a 0,65% | 🔴 **smontata**: non è un DD di portafoglio, è una perdita singola |
| **H-B** — *«nessuna sedia ha mai realmente girato al 2%, quindi il 14% è teoria»* | `770101` sul piccolo: stop pieni a **−1,86…−2,23%** del saldo ricostruito, 7 occorrenze, saldi riprodotti all'euro contro M31 | 🔴 **smontata**: ha girato al 2%, e ha fatto **13,69%** |
| **H-C** — *«le sedie sono scorrelate, quindi la somma non conta»* | 🟢 **vero, ed è a loro favore**: correlazioni **−0,01…+0,13**, somma 19,28% → combinato 5,19% a 1,00% | 🟢 **regge… e non basta**: la diversificazione è già **dentro** il 13,91% |
| **H-D** — *«il Guardian chiude a 4,9% e a 9,9%, quindi il muro non si tocca mai»* | il 26/02 il Guardian sarebbe intervenuto fra le 16:07 (−4,57%) e le 16:21. Ma: **(1)** resta **100 $** = **2,2 punti** di slippage sulle due posizioni che chiude insieme; **(2)** il C1 non vede il realizzato (B1); **(3)** i pendenti LIMIT lo scavalcano (B2); **(4)** fail-open (B3) | 🟠 **parzialmente regge**: il Guardian **trasforma la morte in un quasi-incidente**, ma il margine di 0,10% **non è stato riscalato** con la taglia |

### 🔬 E il contro-esempio al contro-esempio: **se invece concludessi «regge», cosa lo smentirebbe?**
La giornata peggiore. **Ce l'ho, e non è ipotetica**: **26/02/2026, −6,87%**, contro un muro di
5,00%. Più il gemello forward del **29/07/2026, −6,88%**, prodotto da **una sola sedia**.
🔴 **Due giornate indipendenti, una simulata e una vissuta, arrivano allo stesso numero.**

### 🧮 Il controllo di scala che poteva ribaltare tutto
La scala lineare 1%→2% è **conservativa o ottimistica?** Su una striscia perdente a size
fissa-frazionale, `1−(1−0,02)^N < 2·(1−(1−0,01)^N)` per ogni N>1: la linearità **sovrastima**
leggermente il DD. 🔴 **Ma l'aggregazione giornaliera di `dd_portafoglio.py` lo sottostima di più**:
**−15,7%** misurato sul DAX (6,25% contro i 7,2328% del tester tick). **I due errori non si
annullano: il secondo è più grande, e va nella direzione brutta.**

---

# 7️⃣ ✍️ LE ALTERNATIVE, col loro costo — **la taglia resta firma di Claudio**

🔴 **Io porto il numero, non la decisione.** E **nessuna** di queste è un modo di "aggirare" niente:
fra le Forbidden Practices FTMO c'è *«substantially larger or smaller position sizes compared to
other trades»*, quindi **si sceglie UNA taglia e non si tocca più**.

**La scala completa, misurata sugli stessi quattro file** (5000 rimescoli, seed 42, deposito 100k):

| taglia | DD dal picco | **peggior giorno** | gg oltre −5% | MC p95 | MC p99 | 🧱 **sfonda il 10% statico** | margine 1:15 |
|---|---:|---:|---:|---:|---:|---:|---:|
| **0,65%** | 4,52% | −2,23% | **0** | 4,72% | 7,45% | 🟢 **0,1%** | 116.210 $ = 116% 🔴 |
| **1,00%** | 6,95% | −3,44% | **0** | 7,26% | 11,46% | 🟠 **1,7%** | 187.529 $ = 188% 🔴 |
| **1,30%** | 9,04% | −4,47% | **0** | 9,44% | 14,89% | 🟠 **4,1%** | 243.788 $ = 244% 🔴 |
| 🔴 **2,00%** *(firmata 20/09)* | 🔴 **13,91%** | 🔴 **−6,87%** | 🔴 **2** | 🔴 **14,53%** | 🔴 **22,91%** | 🔴 **12,4%** | 🔴 **357.569 $ = 358%** |

| # | opzione | cosa costa davvero |
|---|---|---|
| **A** | **0,65%** (taglia di casa, già validata) | ⏱️ nessun costo sul tempo: **FTMO non ha limite di tempo** (`REGOLAMENTO` §1). Il target 10% arriva più tardi, non "non arriva" |
| **B** | **1,00%** | è la taglia scritta nei contratti; ~1 challenge su 60 muore per il muro statico |
| **C** | **1,30%** | ~1 su 24 muore; nessuna giornata sfonda il 5% nella finestra misurata |
| **D** | ridurre la **ROSA** invece della taglia | **[NON MISURATO]** — ma a 1:15 il margine impone comunque un taglio: a 2,00% si gira **una sedia alla volta** |

🔴 **Fra 1,30% e 2,00% il salto non è graduale**: le giornate che sfondano il 5% passano da **0** a
**2**, e la probabilità di morire sul muro statico da 4,1% a **12,4%**. La frontiera sta lì in
mezzo, e **non è stata cercata da nessuno prima di firmare.**

🟢 **La cosa che toglie urgenza, e va detta perché è vera**: **FTMO non ha limite di tempo**
(*«There is no time limit… the Trading Period is indefinite»*). 👉 **Alzare i lotti compra
VELOCITÀ, che è l'unica cosa che FTMO non chiede.** Il muro del 10% invece è definitivo.

---

# 8️⃣ 🚧 COSA QUESTO REFERTO **NON** COPRE — dichiarato

1. 🔴 **`770511` e `770260` non sono nel DD di portafoglio**: in repo non esistono le loro serie
   per-trade. **Via più corta**: due corse OOS con `ExportTrades()` acceso sulla cella dei preset
   FTMO, finestra 2025.06.10→2026.06.30, deposito 100k, `InpRiskPercent=1` — **~40 minuti di banco**
   su `50504400` (`C:\MT5_Backtest`). Poi `dd_portafoglio.py` sulle SEI e questo referto si chiude.
2. 🔴 **Nessuna specifica di contratto FTMO letta**: leva, valore punto, margine e fuso sono
   `[INFERITO]`. Si chiude con **uno screenshot** della finestra Specifica del simbolo.
3. 🔴 **Standard o Swing: sconosciuto** (`FIRME_2026-09-19_SERA.md` §①). Cambia la leva, cioè
   cambia §5.3.
4. 🔴 **Slippage, requote e rifiuti della prop vera: non modellati.** I DD qui sono `Equity DD %`
   del tester su tick BCM.
5. 🔴 **`770202` ha un rischio H4 aperto e dichiarato** (`report/STASERA.md` r.219): le barre H4 di
   BCM e FTMO non cadono negli stessi istanti, e su una sedia solo-long un bias opposto **cancella**
   l'ingresso. **[NON MISURATO]** — se il Dow non spara, il DD del portafoglio cambia in meglio e la
   frequenza in peggio.
6. 🟠 **Il DD giornaliero è calcolato su P&L CHIUSO**; FTMO misura l'**equity col floating**.
   Limite inferiore.

---

## 📎 Riproducibilità
```
python3 backtest_pipeline/dd_portafoglio.py --deposito 100000 \
  backtest_pipeline/risultati_prove/aperture_r47/abtg_trades_ABTG_DAX_Apertura_EU_D30EUR_772502.csv \
  backtest_pipeline/risultati_prove/aperture_r47/abtg_trades_ABTG_Dow_Apertura_US_U30USD_772505.csv \
  backtest_pipeline/risultati_prove/trades_portafoglio/abtg_trades_ABTG_MaxMinNotte_DAX_Short_Ottimizzato_D30EUR_770413.csv \
  backtest_pipeline/risultati_prove/trades_candidati_r23/abtg_trades_ABTG_EMA200_U30USD_771521.csv
```
(`--deposito 50000` dà la lettura equivalente a 2,00%.) La metrica FTMO-statica e il Monte Carlo
sull'ordine dei giorni sono un calcolo aggiuntivo fatto in questa sessione sugli **stessi** file,
descritto in §2.2 — nessuno script nuovo committato.

---

## 🔬 CONTROPROVA INDIPENDENTE (sessione principale, 20/09 ore 12:45)

Le due affermazioni che cambiano una decisione già firmata **non si accettano
sulla parola di un agente**. Rimisurate a mano, sul CSV grezzo:

### ① Il «0,96% realizzato» che avevo dato a Claudio — **NON ESISTE**
`grep -rn "0,96%" --include=*.md .` su tutto il repo → **una sola occorrenza**:
`report/P0_OPENINGREVERSALB_2026-09-08.md` r.38, che è il **DD di backtest** di
`ABTG_OpeningReversalB`, un candidato **bocciato con n=2**. Non è forward, non è
realizzato, non è di nessuna delle sei sedie.
🔴 **Quel numero l'ho portato io in chat la mattina del 20/09, ed è il numero
che ha reso accettabile triplicare il rischio.** Il realizzato vero è
**−0,648%**, che è la peggior **giornata** sul 100k — e il repo stesso la
dichiara già come **pavimento**, non come peggior giornata vera, perché il
flottante non è nel CSV (`PIANO_CHALLENGE_OTTOBRE.md` r.344).

### ② `770101` ha DAVVERO girato al 2% in forward — **riprodotto al centesimo**
Su `data/statements/trades_auto.csv`, filtrando `magic=770101` e sommando
`profit + commission + swap`, **senza bisogno di ricostruire il saldo** (la
discesa massima di un flusso P/L è invariante all'ancora):

```
770101: 39 posizioni  (20/07/2026 -> 17/09/2026)
discesa massima del flusso P/L : 747,60 EUR
   su saldo 5.460 EUR  ->  13,69%
   su saldo 5.100 EUR  ->  14,66%
perdite: n=9, media -97,26 EUR, peggiore -120,80 EUR
   stop peggiore  ->  2,21% - 2,37% del conto
```

🔴 **Gli stop valgono il 2,2% del conto: la taglia firmata per FTMO non è
teoria, è già stata girata per 39 posizioni.** E il `747,60 EUR` coincide alla
cifra con quello dell'agente, calcolato per un'altra strada.

🔴 **E il confronto che chiude la questione**: backtest di `770101` a 2,00% →
**13,42% – 14,47%**. Forward realizzato alla stessa taglia → **13,69%**.
**Non divergono: coincidono.** L'argomento *«il backtest è pessimista, guarda il
realizzato»* — che era **mio** — è smontato da una misura, non da un'opinione.

### ⚠️ Un conto che ho sbagliato e che NON va usato
Il mio primo tentativo ricostruiva il saldo cumulando i P/L da un'ancora di
5.102 EUR posta all'**inizio** della serie, e dava un DD del **389%**: assurdo,
perché quell'ancora è di **metà serie** (`772361`, 14/08) e va ricostruita
all'indietro. Il numero buono è quello sopra, che **non usa nessuna ancora**.
Lo scrivo invece di cancellarlo: un 389% lasciato in giro sarebbe diventato una
citazione.
