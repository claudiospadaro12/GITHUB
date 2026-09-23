# 🗓️ IL PIANO DEGLI OTTO GIORNI — con le sei sedie che abbiamo, quanto vale la challenge e cosa la alza

**23/09/2026** · branch `lavoro` · conto FTMO **`541452707`** (`C:\FTMO`), **80.000 €**, 2-Step, **vivo dal 21/09**
🛑 **SOLA LETTURA ASSOLUTA.** Nessun round lanciato, nessuna riga consegnata a Claudio, niente VPS,
niente forward, nessun preset toccato, nessuna sedia accesa o spenta, nessuna taglia proposta.
Conto reale **`10105439`** mai nominato in un comando.
🔴 **Taglie, rischio, accensioni e acquisti restano firma di Claudio.** Qui ci sono il quadro e le
alternative, non la decisione.

---

# 0️⃣ 🎯 LE OTTO RIGHE CHE CONTANO

1. 🔴 **LA DOMANDA È CAMBIATA E LA RISPOSTA È UN NUMERO.** Con le sei sedie di oggi, partendo dal
   saldo vero di stasera (**78.242,32 €** dopo il primo stop del 22/09), la probabilità di arrivare
   al **+10%** prima di sbattere contro un muro FTMO è:
   **🟢 84,0% se il Guardian sta girando · 🔴 70,3% se non sta girando.**
   *(Monte Carlo mio, 20.000 sequenze, §3. Scenario pessimista al §7: 67,8% / 33,3%.)*
2. 🥇 **E LA MISURA CHE ALZA DI PIÙ LA PROBABILITÀ NON È UN ROUND: È UNA RIGA DI SOLA LETTURA CHE
   ESISTE GIÀ E CHE NESSUNO HA ANCORA INCOLLATO.** Verificare che il Guardian giri davvero su
   `C:\FTMO` vale **da +13,7 a +34,5 punti percentuali** di probabilità di passare. Costo: **zero
   tempo macchina, due minuti**, la riga è scritta e ha già passato il doppio cancello il 21/09
   (`report/BINARI_IN_CAMPO_FTMO_2026-09-21.md` §③).
3. 🧱 **IL MURO CHE UCCIDE NON È QUELLO CHE GUARDAVAMO.** Senza Guardian, a taglia 2,00%, la morte
   arriva dal **giornaliero 5%** nel **18,2%** dei casi e dallo **statico 10%** solo nell'**11,5%**.
   Tutti i nostri referti parlano del 10% statico. 👉 **Il pericolo principale è l'altro.**
4. 🟢 **DUE SEDIE SU SEI HANNO IL DD MISURATO ALLA TAGLIA VERA E SUL BANCO VERO**, e l'ho
   verificato io al CSV: **`770202`** (R197A) e **`770260`** (R199B), tutte e due `InpRiskPercent=2`
   e `deposito 80000`. Le altre quattro sono riscalate ×2 da misure a 1,00% — e **due di quelle
   quattro non sono nemmeno sul banco giusto** (`770411` a 100k, `770511` a **10k**).
5. 🔴 **IL RISCHIO NON PESATO PIÙ GROSSO HA UN NOME E UN NUMERO, E L'HO MISURATO STANOTTE:
   `770202` Dow è l'UNICA delle sei che dipende da un filtro su TF alto — `InpUseEmaFilter=true`
   su `InpFilterTF=PERIOD_H4` — e quel filtro NON è un dettaglio: È LA SEDIA.**
   Dal CSV `dow_motore.csv`: filtro **spento** → PF **1,03079**, DD **14,9407%**; filtro **acceso**
   → PF **1,23808**, DD **6,9201%**. 🔴 **La griglia H4 di FTMO è sfasata di 2 ore da quella BCM su
   cui il numero è stato misurato.** §6.1.
6. 🔴 **LE ALTRE CINQUE SEDIE SONO PULITE SU QUESTO PUNTO, e l'ho verificato preset per preset**:
   `InpUseEmaFilter=false`, `InpUseSupertrend=false`, `InpUseCorrelation=false`,
   `InpUseSRFilter=false`, `InpUseAtrFilter=false`. Le uniche griglie che leggono sono **H1 e M5**,
   **identiche fra i due server** perché lo sfasamento è di **2 ore piene**.
7. 📦 **I 14 FILE PROVA VERDI SUL TAVOLO (`R212a-e` 84 passate + `R214a-i` 58 passate) SPOSTANO LA
   CHALLENGE DI CIRCA ZERO**, e lo dico col numero: `R212` misura un **candidato** che alla taglia
   in campo **non si schiera** (3 celle su 40 in IS passano il muro, e 0,90 è quante ne prevede il
   puro caso — lo scrive il suo stesso dossier). **Un file scritto non è un file da lanciare.**
   Le eccezioni con un valore difendibile sono **due**, e valgono **16 passate in tutto**: `R214c/d` (il Nasdaq, dove il filtro volumi legge davvero la barra del grafico) e 🆕 **`R215a`**, consegnato stanotte da un agente in parallelo, che attacca **esattamente** il difetto del punto 5. §5 e §6.1.
8. 🧭 **E IL PIANO ONESTO DEGLI OTTO GIORNI È CORTO**, perché il 1° ottobre **non è più una
   scadenza**: la challenge è **già partita** il 21/09 e **FTMO non ha limite di tempo**
   (`docs/REGOLAMENTO_FTMO_2026-08.md` §1, testuale: *«There is no time limit… the Trading Period
   is indefinite»*). 👉 Con **13-18 giorni di borsa mediani** al target e **SEI** giorni di borsa da
   qui al 30/09, **la challenge non finisce entro il 1° ottobre, e va bene così.** §8.

---

# 1️⃣ 🪑 IL CONTRATTO DI OGNI SEDIA — una tabella sola

## 1.1 Le unità, dichiarate prima dei numeri

| cosa | come si legge qui |
|---|---|
| **DD** | `Equity DD %` del tester = `STAT_EQUITY_DDREL_PERCENT`, cioè **discesa dal PICCO**. Verificato al sorgente che **tutte e sei** le sedie scrivono quella costante (`IL_MURO_MISURATO_2026-09-22.md` §3.3). 🟢 È un **limite superiore rigoroso** della perdita statica che FTMO misura (dimostrazione al §2.1 dello stesso referto) |
| **riporto alla taglia vera** | i DD misurati a `InpRiskPercent=1` si portano a 2,00% con **×2,0000**, convenzione di casa `[APPROSSIMATO]`. 🟢 **Il fattore VERO è stato MISURATO su una sedia, due finestre**: `R202A` (risk 1) contro `R197A` (risk 2), stessa cella, stesso banco → **×1,9557** (IS) e **×1,9901** (OOS). **Il ×2 sovrastima: è l'errore nel verso giusto** |
| **`n`** | la colonna `Trades` conta i **DEAL DI USCITA**. Col parziale al 50% una posizione esce in due volte. Dove ho scritto «pos» è **contato sui `position_id`**, non stimato |
| **frequenza** | **posizioni ÷ giorni di borsa della finestra** (OOS `walkforward_generico` 2025.06.10→2026.06.30 = **276 gg**; OOS `walkforward_aperture` 2025.07.01→2026.06.30 = **261 gg**) |
| **modello** | `tick` = Modello 4 (tick reali) in **tutte e sei** |
| **banco della challenge** | **80.000 €** (`RESOCONTO_2026-09-21.md` r.38: saldo 80.000,00 letto da schermata di Claudio) |

## 1.2 🧾 LA TAVOLA DEI SEI CONTRATTI

> Ogni numero di questa tabella l'ho **riaperto io al CSV**, non ripreso dai referti.

| sedia | EA · simbolo BCM → FTMO · TF | magic | **DD promesso (come misurato)** | **a che `InpRiskPercent`** | banco della misura | modello | **`n` IS / OOS** | **PF IS / OOS** | **freq. promessa** | **DD alla TAGLIA VERA (2,00%)** |
|---|---|---|---|:--:|---:|:--:|---|---|---:|---|
| **`770101`** | `ABTG_DAX_Apertura_EU` · `D30EUR`→`GER40.cash` · **M5** | 770101 | IS **5,4089%** · OOS **7,2506%** | 🟠 **1** → riportato | 🟢 **80.000** | tick | **132 pos** (175 deal) / **193 pos** (270 deal) — **contate** | 1,12733 / **1,39520** | **0,699** op/g | 🔴 IS **10,82%** · OOS **14,50%** |
| **`770202`** | `ABTG_Dow_Apertura_US` · `U30USD`→`US30.cash` · **M5** | 770202 | IS **11,0936%** · OOS **8,7450%** | 🟢 **2 — LA TAGLIA VERA** | 🟢 **80.000** | tick | **56 pos** (74 deal) / **96 pos** (130 deal) — contate | 1,21214 / **1,25384** | **0,348** op/g | 🟢 **nessun riporto**: 🔴 IS **11,09%** · 🟠 OOS **8,75%** |
| **`770260`** | `ABTG_Nasdaq_Apertura_US` RETEST · `NASUSD`→`US100.cash` · **M5** | 770260 | IS **7,3069%** · OOS **7,8576%** | 🟢 **2 — LA TAGLIA VERA** | 🟢 **80.000** | tick | **82 pos** (135 deal) / **102 pos** (172 deal) | 1,22116 / **1,21546** | **0,370** op/g | 🟢 **nessun riporto**: **7,31%** · **7,86%** — 🟢 **tutti e due SOTTO il muro** |
| **`770411`** | `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` · `D30EUR`→`GER40.cash` · **M15** | 770411 | IS **3,0977%** · OOS **1,9213%** | 🟠 **1** → riportato | 🟠 **100.000** | tick | 🔴 **`[NON MISURATO]`** (20 deal, forbice 9-20) / **14 pos** (21 deal) — contate | 1,87803 / **2,15985** | 🔴 **0,051** op/g | 🟢 IS **6,20%** · OOS **3,84%** — 🟢 **l'unica DIMOSTRATA sotto il muro** |
| **`770511`** | `ABTG_SuperWave_DOW_H1_Ottimizzato` · `U30USD`→`US30.cash` · **H1** | 770511 | 🔴 **CONTESO**: IS **3,7267 ↔ 4,0393%** · OOS **3,9082 ↔ 4,1675%** | 🟠 **1** → riportato | 🔴 **10.000** | tick | 🔴 **`[NON MISURATO]`** (84 o 72 deal) / 🔴 **`[NON MISURATO]`** (143 o 131 deal, forbice pos. **62-143**) | 1,48166 / **1,24312** *(o 1,84892 / 1,32770)* | 🔴 **~0,294** `[STIMATO]` | 🟠 IS **8,08%** · OOS **8,34%** — 🔴 **ma su banco 10k: al banco vero SALE** |
| **`771531`** | `ABTG_EMA200` · `U30USD`→`US30.cash` · **H1** | 771531 | IS **5,7325%** · OOS **7,8323%** | 🟠 **1** → riportato | 🟠 **100.000** | tick | 🔴 **`[MISURATO FUORI REPO]` 132 pos** (237 deal; forbice dura in repo **103-237**) / **257 pos** (517 deal) — contate | 1,20110 / **1,52365** | **0,931** op/g | 🔴 IS **11,47%** · OOS **15,66%** |

**Fonti, file e riga** *(tutte riaperte da me il 23/09)*:
`770101` → `risultati_prove/R202B/ABTG_DAX_Apertura_EU_D30EUR_{IS,OOS}_R202B.csv` **Pass 3** ·
`770202` → `risultati_prove/R197A/ABTG_Dow_Apertura_US_U30USD_{IS,OOS}_R197A.csv` **Pass 2** (deposito `80000` letto in `REFERTO_ROUND_R197A.txt`) ·
`770260` → `risultati_prove/R199B/ABTG_Nasdaq_Apertura_US_NASUSD_{IS,OOS}_R199B.csv` **Pass 2** (deposito `80000` in `REFERTO_ROUND_R199B.txt`; ⚠️ **la frequenza di questa sedia va ricalcolata**: il vecchio contratto usava il denominatore di `walkforward_aperture` (261 gg) e dava 0,360 — ma `R199B` gira su `walkforward_generico` con `@DAQUANDO 2024.09.26` e `FrazioneIS` di default **0,40**, quindi l'OOS è **2025.06.10→2026.06.30 = 276 gg** ⇒ **102/276 = 0,370**) ·
`770411` → `risultati_prove/ABTG_MaxMinNotte_DAX_Short_Ottimizzato/..._D30EUR_{IS,OOS}_ptb.csv` ·
`770511` → `risultati_prove/dal_vps/ABTG_SuperWave_DOW_H1_Ottimizzato/..._U30USD_{IS,OOS}_r120b11.csv` ⚔️ contro `risultati_prove/ABTG_SuperWave_DOW_H1_Ottimizzato/..._{IS,OOS}.csv` Pass 3 ·
`771531` → `risultati_archivio/R112_CORSA_20260826/ABTG_EMA200_U30USD_{IS,OOS}_00_metro.csv`.

### ✅ La verifica che il mandato chiedeva, fatta: **quali sedie hanno il DD alla taglia vera**

| | sedie | conseguenza |
|---|---|---|
| 🟢 **taglia VERA (2,00%) e banco VERO (80.000)** | **`770202`** · **`770260`** | il loro DD promesso **non è una stima**: è la misura |
| 🟠 taglia 1,00%, banco **giusto** (80.000) | **`770101`** | riporto ×2, che il §1.1 misura **conservativo** |
| 🟠 taglia 1,00%, banco 100.000 | **`770411`** · **`771531`** | scarto fra 80k e 100k **misurato sotto il mezzo punto relativo** (−0,50% / +0,06%): trascurabile |
| 🔴 taglia 1,00%, banco **10.000** | **`770511`** | 🔴 **il pavimento del lotto taglia la taglia**: fra 10k e 100k lo scarto **misurato** è **+7,8%** (`770101`) e **+8,6%** (`771531`). 👉 **I suoi numeri sono un limite INFERIORE, non superiore.** È il **B1** del §5 |

### 🟢 E un numero che tre referti non avevano: **la PEGGIOR GIORNATA di backtest, alla taglia vera**

La colonna `Peggior Giornata %` esiste **solo in tre EA su sei**, ed è l'unico confronto diretto col
muro giornaliero del 5%. Letta da me sui CSV a `InpRiskPercent=2`:

| sedia | peggior giornata IS | peggior giornata OOS | contro il muro 5% |
|---|---:|---:|---|
| `770202` Dow | **−2,0177%** | **−2,0464%** | 🟢 largo |
| `770260` Nasdaq | **−2,0395%** | **−2,1327%** | 🟢 largo |
| `770101` DAX *(a risk 1: −1,0195 / −1,0782 → ×2)* | **−2,04%** | **−2,16%** | 🟢 largo |
| 🔴 `770411` · `770511` · `771531` | 🔴 **`[NON MISURATO]`** | 🔴 **`[NON MISURATO]`** | l'array `stats[]` di quei tre EA si ferma a **8 colonne** |

👉 **Una sedia da sola non tocca il 5%. È la SOMMA che lo tocca**, e la somma è il §2.

---

# 2️⃣ 🔴 IL DRAWDOWN DEL PORTAFOGLIO — che non è la somma dei drawdown

## 2.1 🧮 LA MISURA CHE HO FATTO IO, dai per-trade, oggi

Ho aggregato **per giornata** i quattro file per-trade che esistono in repo —
`770101` (`abtg_trades_…_D30EUR_772501.csv`, 270 deal/193 pos) · `770202`
(`…_U30USD_772505.csv`, 130/96) · `770411` (`trades_portafoglio/…_770413.csv`, 21/14) ·
`771531` (`trades_candidati_r23/…_771521.csv`, 517/257) — **stessa finestra, stesso deposito
(100.000), stesso rischio (1,00%), tick reali** — e ho contato.

| domanda del mandato | **risposta misurata** |
|---|---|
| giorni di borsa con almeno un trade chiuso | **242** |
| giornate con **2 sedie in perdita insieme** | **19** |
| giornate con **3 sedie in perdita insieme** | **2** |
| giornate con **4 sedie che chiudono** qualcosa | **1** |
| 🔴 **peggior giornata aggregata mai vista** | 🔴 **26/02/2026 = −3,435% @1,00% → −6,870% @2,00%** (`770101` −1.194,48 · `770202` −1.081,75 · `771531` −1.158,85) |
| seconda peggiore | **15/10/2025 = −3,164% @1% → −6,328% @2%** (quattro sedie che chiudono, tre in perdita) |
| giornate oltre **−4,0%** @2,00% (pausa morbida Guardian 3,5%) | 🟠 **11** |
| 🔴 giornate oltre **−5,0%** @2,00% (**muro FTMO**) | 🔴 **2 su 242** |

🟢 **Riproduce `DD_PORTAFOGLIO_FTMO_2026-09-20.md` al terzo decimale** (−6,87% e −6,33%), per una
strada che non è la sua: è la stessa misura fatta due volte da due persone diverse.

## 2.2 🔗 LE SOVRAPPOSIZIONI, per nome — e sono peggio di come le chiedeva il mandato

Il mandato temeva che `770101` DAX e `770202` Dow *«aprano a poche ore di distanza»*. **Dalla
lettura dei preset FTMO: no, aprono a 6 ore e mezza di distanza** — DAX `InpSessionHour=10`, Dow e
Nasdaq `InpSessionHour=16` (+`Min=30`). 🔴 **Ma il problema non è l'apertura: è la CHIUSURA.**
Tutte e tre hanno `InpCloseHour=19`. 👉 **Fra le 16:30 e le 19:30 ora server FTMO le tre aperture
sono vive insieme, e con loro `770411` (che tiene fino alle 19), `770511` e `771531` (0-24).
Possono essere vive TUTTE E SEI.**

E la concentrazione vera è **per SIMBOLO**, non per orario:

| simbolo FTMO | sedie | rischio nominale simultaneo a 2,00% |
|---|---|---:|
| 🔴 **`US30.cash`** | **`770202`** Dow · **`770511`** SuperWave · **`771531`** EMA200 | 🔴 **TRE sedie = 6,00%** |
| 🟠 **`GER40.cash`** | `770101` DAX · `770411` MaxMin | **DUE = 4,00%** |
| 🟢 `US100.cash` | `770260` Nasdaq | UNA = 2,00% |

🔴 **Il mandato citava `770202` + `770511` come «stesso simbolo». Sono TRE, non due**, e la terza è
`771531`, cioè la sedia più veloce della rosa (0,931 op/g) — e quella che ha già preso il primo
stop della challenge il 22/09.

🟢 **E la correlazione MISURATA le assolve in parte**: correlazioni giornaliere fra le quattro
sedie con per-trade **tutte fra −0,01 e +0,13**, la più alta proprio `770202` vs `771531`
(**+0,13**), le due che dividono il Dow. **La diversificazione esiste** (somma dei singoli 19,28% →
combinato 5,19% dal picco a 1,00%): **il problema non è la correlazione, è la TAGLIA.**

## 2.3 🛡️ E IL CAP C1 — che oggi **non è 3,25%**

🔴 **Correzione a una riga che gira nei referti del 20/09**: il preset del Guardian FTMO **è
cambiato lo stesso giorno, con tre firme di Claudio**, e chi cita i vecchi numeri sbaglia.

| | valore letto nel preset **oggi** | commit |
|---|---|---|
| `InpStartBalance` | **80000** | `a7f24c9f` 20/09 15:03 *«firma di Claudio "si 80000"»* |
| `InpDailyLossPct` (emergenza giorno) | **4,5** | `ac56d95f` 20/09 13:45 *«cuscino allargato»* |
| `InpTotalDDPct` (emergenza totale) | **9,3** | idem |
| `InpDailyPausePct` (pausa morbida) | **3,5** | idem |
| **`InpMaxOpenRiskPct` (C1)** | **4,00** | `a298e1d4` 20/09 07:18 *«cap C1 a 4,00% (firma di Claudio)»* |
| `InpDailyResetHour` | **1** | idem — 🟢 **corretto**: il muro giornaliero FTMO si azzera alle **00:00 CET = 01:00 ora server FTMO** |

🟢 **Due conseguenze buone che vanno dette**:
- il **cuscino** fra Guardian e muro non è più di **100 €** come denunciava `DD_PORTAFOGLIO_FTMO`
  (che leggeva 4,9/9,9 su banco 100k): oggi è **0,5 punti sul giorno = 400 €** e **0,7 punti sul
  totale = 560 €**. 👉 **Quel rilievo è OBSOLETO**, e lo scrivo perché sta ancora in repo.
- il **C1 a 4,00% con sedie a 2,00% lascia aperte DUE posizioni e blocca la terza**
  (`ABTG_Guardian.mq5`: `riskPct >= InpMaxOpenRiskPct` ⇒ 2×2,00 = 4,00 ≥ 4,00 → scatta).

🔴 **E la cosa che le sei sedie di oggi CAMBIANO nel conto del C2 (tetto per cluster).** CLAUDE.md
dice che il C2 *«diventa una rete alla QUARTA sedia sullo stesso cluster»*. 👉 **Su FTMO abbiamo
TRE sedie sullo stesso SIMBOLO, non su un cluster generico.** Non propongo di riaprire quella
decisione — **dichiaro solo che il conto si è avvicinato di una unità**, e che il C1 a 4,00% oggi
morde **prima** del C2 comunque (due posizioni, qualunque sia il simbolo). **Il C2 resta non
necessario, e la ragione è la stessa: `rischio_cluster ≤ rischio_totale` è un'identità.**

## 2.4 ⚠️ I limiti di questa misura, dichiarati

1. 🔴 **Sono QUATTRO sedie su sei.** Mancano `770260` e `770511` — **e sono entrambe correlate a
   quelle che ci sono** (`770511` è la terza sul Dow, `770260` apre **allo stesso minuto** di
   `770202`). 👉 **Il numero è un PAVIMENTO, non un tetto.** Al §7 lo rompo apposta.
2. 🔴 **È P&L REALIZZATO. Il muro giornaliero FTMO è su EQUITY, floating incluso.** L'aggregazione
   per giornata sottostima: misurato **−15,7%** sul DAX (6,25% contro 7,2328% del tester a tick).
3. ⚪ **La sovrapposizione `D30EUR` ↔ `F40EUR` (CAC) resta `[NON MISURATA]`** — e oggi **non
   morde**, perché **nessuna sedia sul CAC è in campo** e `R138a` l'ha già girata con **PF OOS
   0,76965**. Se un giorno si accendesse, aprirebbe **allo stesso minuto** del DAX.
4. 🔴 **Nessun dato del forward FTMO è in repo.** Il file che servirebbe si chiama
   **`data/statements/trades_ftmo.csv`**, e **la pipeline per produrlo ESISTE GIÀ**:
   `backtest_pipeline/pubblica_trades.ps1` r.202 lo aspetta, e
   `mql5/Presets/FTMO/ABTG_TradeExporter_FTMO.set` porta `InpFile=ABTG_Trades_FTMO.csv`. **Manca
   solo che l'esportatore sia attaccato su `C:\FTMO` e che lo script giri.** §5, misura **M3**.

---

# 3️⃣ 🎲 QUANTO VALE LA CHALLENGE — il numero, e come l'ho fatto

## 3.1 Il metodo, dichiarato prima del risultato

> 🧰 **Lo strumento è in repo e il numero si rifà**: `backtest_pipeline/mc_challenge_ftmo.py`
> (`python3 backtest_pipeline/mc_challenge_ftmo.py`). Stampa anche le giornate del §2.1, così
> le due misure escono dalla stessa corsa e non possono divergere.

Monte Carlo **sull'ORDINE DEI GIORNI**, 20.000 sequenze, seme fisso, sulle 242 giornate aggregate
del §2.1. Regole della simulazione, tutte prese dal regolamento e non inventate
(`docs/REGOLAMENTO_FTMO_2026-08.md` §1-§2):

| regola | come l'ho modellata |
|---|---|
| **Profit Target +10%** | si vince quando il saldo tocca **1,10 × capitale iniziale** |
| **Minimum Trading Days 4** | non si può vincere prima del 4° giorno con operazioni |
| **Max Loss 10% STATICO** | si muore se l'equity scende **sotto il 90% del capitale iniziale** |
| **Max Daily Loss 5%** | si muore se la perdita di una giornata supera **il 5% del capitale iniziale** (è così che FTMO lo calcola: 5% dell'*Initial* Simulated Capital) |
| **nessun limite di tempo** | la sequenza si rimescola e si allunga finché non c'è un esito |
| **taglia fissa-frazionale** | il P&L del giorno scala col saldo del giorno, come fa `InpRiskPercent` |
| **saldo di partenza** | 🔴 **quello VERO di stasera: 78.242,32 € = 0,97803** del capitale iniziale, dopo lo stop `771531` del 22/09 (`report/PRIMO_STOP_FTMO_2026-09-22.md`) |
| **il Guardian** | quando modellato: la perdita di una giornata viene **tagliata a 4,5%** (il Guardian chiude tutto e blocca) |

## 3.2 🏁 IL RISULTATO

| scenario | **PASS** | morte per **muro GIORNALIERO 5%** | morte per **muro STATICO 10%** | giorni di borsa mediani al +10% |
|---|---:|---:|---:|---:|
| 🔴 **2,00%, Guardian NON attivo** | **70,3%** | 🔴 **18,2%** | 11,5% | **16** |
| 🟢 **2,00%, Guardian attivo (4,5%/gg)** | 🟢 **84,0%** | 🟢 **0,0%** | 16,0% | **18** |
| **1,00%, Guardian attivo** | **96,6%** | 0,0% | 3,4% | 45 |
| *(a capitale pieno 80.000, senza lo stop del 22/09: 2,00% + Guardian = **88,6%**)* | | | | 15 |

> ## 🥇 **LA RIGA CHE DECIDE IL PIANO: il Guardian vale +13,7 punti percentuali, e li vale
> ANNULLANDO la modalità di morte principale.** Senza Guardian il 18,2% delle challenge muore
> per il muro *giornaliero* — quello di cui nessun nostro referto parlava.
> 🔴 **E il Guardian su `C:\FTMO` è `[NON VERIFICATO]`.** Non sappiamo se sta girando.
>
> ⚠️ **E il +13,7 poggia su un'ipotesi che va detta**: che il Guardian, quando chiude tutto a 4,5%, riesca davvero a **fermare la giornata dentro il 5%**. Il cuscino è **0,5 punti = 400 €**; lo slippaggio misurato il 22/09 su **una** chiusura da 22,78 lotti è stato **156,68 €**. 🟢 Con due posizioni aperte (il massimo che il C1 a 4,00% lascia) il caso peggiore misurato sta **sotto** i 400 €. 🔴 **Ma è `n = 1`**, ed è la stessa incognita della misura **M4**: le due domande sono la stessa domanda.

## 3.3 ⚠️ Cosa NON dice questo numero — cinque limiti, per nome

1. 🔴 **Quattro sedie su sei** (§2.4.1) — le due mancanti sono correlate ⇒ **il vero numero è più
   basso**. Quanto, lo misuro al §7.
2. 🔴 **P&L realizzato, non equity** ⇒ le giornate brutte sono **più brutte** di così.
3. 🔴 **Il rimescolamento distrugge l'ordine.** Se le giornate brutte si **ammucchiano** (e nei
   mercati veri lo fanno), lo statico morde di più.
4. 🔴 **UN SOLO REGIME.** La finestra 2024.09 → 2026.06 è **toro**, ed è dichiarato in tutti i
   contratti. **Nessun rimescolamento fabbrica un 2020 o un 2008.** Questo limite **non si chiude
   con la statistica**: si chiude con una prova di regime, e per queste sei sedie **non esiste**.
5. 🟠 **La scala ×2 sovrastima** il DD (misurato ×1,956-1,990) ⇒ questo pezzo è **conservativo**.
   Rifatto a ×1,97 il PASS sale di ~1 punto: **non cambia niente.**

---

# 4️⃣ 🔴 LO SLIPPAGGIO — il fattore che, se fosse sistematico, costa 8 punti

Il 22/09 il primo stop vero della challenge è costato **−1.757,68 €** contro **−1.590,37 €**
modellati: **+10,5%**, di cui **7,83 punti di slippaggio** sullo stop (3,3 × lo spread) e **+0,67%
di deriva del cambio** EUR/USD fra ingresso e uscita.
⚠️ **`n = 1`. Un campione non è un tasso.** Ma il prezzo dell'ignoranza si può calcolare:

| ipotesi | PASS a 2,00% + Guardian |
|---|---:|
| lo slippaggio del 22/09 è stato un **caso** | **84,0%** |
| lo slippaggio del 22/09 è **sistematico** (+10,5% su ogni perdita) | 🔴 **78,4%** |

👉 **Sapere quale delle due è vera vale 5,6 punti percentuali di challenge nello scenario ottimista — e 34,5 in quello pessimista (§7), perché è la misura che dice in quale dei due mondi siamo.** E si misura
accumulando `n` — non con un round.

---

# 5️⃣ 🎯 LA CLASSIFICA DELLE MISURE, per quanto spostano l'ESITO della challenge

> 🧭 La bussola non è *«quanto è interessante»*: è **quanti punti percentuali di probabilità di
> passare sposta**, e **quanto costa in passate e minuti**.

| # | misura | costo | **cosa sposta** | se esce BENE | se esce MALE | chi la lancia |
|---|---|---|---|---|---|---|
| **M1** 🥇 | **Il Guardian gira davvero su `C:\FTMO`?** La riga di sola lettura **esiste già**, pin e doppio cancello passati il 21/09 (`BINARI_IN_CAMPO_FTMO_2026-09-21.md` §③). Stampa **anche** `.ex5` vs `.mq5`, date, sorgenti mai compilati, righe `GUARDIAN` nei due giornali, EA nei `.chr` | **0 passate · ~2 min** | 🔴 **+13,7 punti** (70,3 → 84,0) e **annulla** la modalità di morte principale | sappiamo di essere all'84% e il piano si semplifica | 🔴 **sappiamo che siamo al 70,3% e che la rete non c'è** — e si interviene lo stesso giorno | ✍️ **Claudio**: incolla in una **finestra PowerShell sul VPS `VMI3047753`**. 🛑 Non tocca nessun terminale |
| **M2** 🥇 | **Gli `.ex5` in campo sono quelli che abbiamo letto?** 🟢 **È LA STESSA RIGA DI M1**: la sezione ① la stampa | **gratis dentro M1** | chiude il buco che il 12/09 trovò un binario di **486 righe contro 690**: un `.ex5` vecchio ignora **in silenzio** le chiavi del preset che non conosce | i sei preset descrivono i sei binari | 🔴 **i DD, i PF e i contratti di questo documento descrivono un'altra flotta** | idem M1 |
| **M3** 🥈 | **Far arrivare `data/statements/trades_ftmo.csv` in repo** (esportatore attaccato + `pubblica_trades.ps1`). Oggi **ogni numero sulla challenge viene da una foto del telefono** | **0 passate** | 🔴 **rende APPLICABILE il criterio di uscita del 18/08** (*«DD forward > DD promesso → revisione»*), che oggi **non lo è**; e alimenta M4 | la pagella serale include la challenge, e i contratti del §1.2 diventano controllabili ogni giorno | si scopre che l'esportatore non è attaccato — e si attacca | ✍️ **Claudio** (gesto in MT5 sul terminale **FTMO `541452707`, `C:\FTMO`**) + riga sul VPS |
| **M4** 🥈 | **Lo slippaggio: portare `n` da 1 a 10-20.** `ABTG_SpreadLogger_FTMO.set` è già in repo; `RIGA_SLIPPAGELOGGER` esiste | **0 passate** | 🔴 **−5,6 punti** diretti (§4) **e soprattutto**: è la misura che **discrimina** fra lo scenario ottimista (84,0%) e quello pessimista (67,8%) del §7 — cioè vale **16 punti di incertezza** | il +10,5% era un caso: restiamo all'84% | ogni DD promesso in questo repo va moltiplicato per un fattore — **e allora la taglia diventa una domanda vera** | ✍️ **Claudio** (riga di sola lettura sul VPS, passa dal cancello) |
| **M5** 🥉 | **Il filtro H4 di `770202` sulla griglia FTMO** (§6.1). 🟢 **Il file prova ESISTE GIÀ e è verde al cancello**: `backtest_pipeline/prove/R215a_filtrotf_DOW_U30USD.txt` (asse `InpFilterTF` H1/H2/H3/H4, banco 80.000, modello 4) | **8 passate · 2,6-12 min** | 🔴 la sedia vale **PF 1,24 / DD 6,92** col filtro e **PF 1,03 / DD 14,94** senza (**misurato**, §6.1). Il numero che gira su FTMO è **fra i due** e nessuno sa dove | **altopiano largo H1-H4** → il motore non è sensibile al TF del filtro, il contratto di `770202` regge e il buco si chiude | 🔴 **altopiano stretto** → il contratto di `770202` è **`[NON MISURATO]` su FTMO**, e serve il seguito su `InpEmaSlow` a TF fisso H2 (8 passate) per separare **fase** da **memoria** | 🖥️ **PC di backtest** (`DESKTOP-H4D7CAJ`). 🔴 **Mai sul VPS** (regola 21/09) |
| **M6** 🥉 | **`770511` al banco 80.000** — è il **B1** di `IL_MURO_MISURATO` §6. L'unica sedia il cui limite superiore sta **sotto** il 10% ma su banco **10.000** | **~4 passate · ~10 min** | chiude l'ultimo contratto misurato sul banco sbagliato **e** probabilmente promuove la sedia a «dimostrata sicura» | terza sedia su sei sotto il muro, dimostrata | il suo DD vero sfonda: allora è una sedia da guardare | 🖥️ PC di backtest |
| **M7** 🥉 | **`770511`: il contratto CONTESO** (n 143/DD 3,9082 ↔ n 131/DD 4,1675, **41 input identici su 41**). 🟢 **Gratis dentro M6** se si accende l'export per-trade | **gratis in M6** | chiude un `[CONTESO]` **e** dà il quinto per-trade, che migliora il §2.1 | il binario di settembre riproduce | il delta è fuori dal `.set` e va isolato prima di fidarsi del suo DD | 🖥️ PC di backtest |
| **M8** ⚪ | **`R214c` / `R214d`** — TF del grafico del Nasdaq `770260`, dove `InpUseVolumeFilter=TRUE` e `VolumeOK()` legge la barra del **grafico**: **misura vera, mai fatta, su una sedia in campo** | **8 passate · 2,6-12 min** | 🟠 può migliorare una sedia viva senza toccarne il meccanismo. **Non sposta la probabilità finché non è firmata** | c'è un TF migliore, e la sedia è già la più sicura delle tre aperture | `M5` resta il TF giusto: casella 5 del certificato chiusa | 🖥️ PC di backtest |
| **M9** ⚪ | **`R214a` / `R214b`** — TF del grafico del Dow: **cancelli di verifica**, l'attesa dichiarata è **identità alla quinta cifra** | 8 passate · 2,6-12 min | ⚪ **zero** sulla probabilità. Chiude una casella del certificato | l'invarianza è provata e i round futuri possono girare a M15/M30 | `@PERIODO` non arriva al tester — **e quello sarebbe un difetto di banco da sapere** | 🖥️ PC di backtest |
| **M10** ⚪ | **`R214g`** — `InpMgmtTF` su `770411` | 14 passate · 9,8-20,9 min | ⚪ **~zero**: `770411` è **già** la sedia dimostrata sicura e fa **0,051 op/g**. Migliorare la sedia che spara meno di tutte non muove la challenge | — | — | 🖥️ PC di backtest |
| **M11** 🛑 | **`R212a-e`** — Dow breakout a due lati, **84 passate, 28-125 min** | 🔴 **il più caro di tutti** | 🛑 **ZERO sulla challenge, e lo dice il suo stesso dossier**: alla taglia **2,00%** passano il muro **3 celle su 40 in IS** e **12 su 40 in OOS**, con **UNA in comune — e 0,90 è quante ne prevede il puro caso.** A **1,00%** ne passerebbero 39/40 e 40/40 | 🔴 **anche uscendo bene non si schiera**: è un candidato, e nessun candidato nuovo diventa sedia in otto giorni (verdetto concorde di sette riesami) | — | 🛑 **NON lanciarlo adesso.** Diventa utile **il giorno dopo** un'eventuale firma sulla taglia a 1,00% |
| **M12** 🛑 | **`R214e/f`** (CostToCost EURJPY) e **`R214h/i`** (Live5m DAX) — 28 passate | 9-42 min | 🛑 **zero sulla challenge**: candidati forex/DAX non schierabili in otto giorni. `R214h` lo dichiara da solo: *«alla taglia FTMO del 2,00% la cella migliore fa già 17,8-18,1% di DD»* | valore di **biblioteca** (`R214f` è l'unico round con `n ≥ 150` in **tutte e due** le finestre) | — | 🖥️ PC di backtest, **dopo** M5-M7 |

### 🔴 La riga scomoda sul pacchetto del mattino
**150 passate sono già scritte e verdi al cancello** (`R212` 84 + `R214` 58 + 🆕 **`R215a` 8**). **Di quelle, quante spostano la probabilità di passare la challenge? SEDICI: le 8 di `R215a` (M5) e le 8 di `R214c/d` (M8).** Le altre 134 chiudono caselle di
certificato o misurano candidati che non si schierano. 🟢 **Non è lavoro sprecato — è lavoro che
va messo DOPO**, e il motto dice di non accontentarsi, non di lanciare tutto.

---

# 6️⃣ 🔴 IL RISCHIO CHE NESSUNO AVEVA ANCORA PESATO

## 6.1 🕐 Il filtro H4 di `770202` legge candele diverse su FTMO — **e quel filtro È la sedia**

### Il fatto, misurato da me al preset e al sorgente

| sedia | `InpUseEmaFilter` | `InpFilterTF` | verdetto |
|---|---|---|---|
| 🔴 **`770202`** Dow | 🔴 **`true`** | 🔴 **`16388` = PERIOD_H4** | **DIPENDE da un TF alto** |
| `770101` DAX | `false` | `16385` = H1 | 🟢 inerte |
| `770260` Nasdaq | `false` | `16388` = H4 | 🟢 **inerte** (il TF è H4 ma il filtro è spento) |
| `770411` · `770511` · `771531` | — *(non hanno il filtro)* | — | 🟢 leggono **solo H1 e M15** |

🟢 **E ho controllato anche tutte le altre porte di TF alto, una per una**, sui tre preset delle
aperture: `InpUseSupertrend=false` · `InpUseSupertrend3=false` · `InpUseCorrelation=false` ·
`InpUseVwapFilter=false` · `InpUseAtrFilter=false` · `InpUseSRFilter=false` ·
`InpUseVolRegime=false` · `InpRangeMode=0` (⇒ `InpLevelTF` **inerte per costruzione**) ·
`InpOCTimeframe=0`. I riferimenti a `PERIOD_D1` nei tre sorgenti stanno **tutti** dentro
`TryPlaceGapFill()` (modalità `GAPFILL`) e dentro il filtro S/R: **spenti da `InpEntryMode=2` e da
`InpUseSRFilter=false`**. 🟢 `ABTG_EMA200` legge `PERIOD_D1` solo nel filtro ADR, e
`InpUseAdrFilter=false`.

> ## 👉 **UNA sedia su sei dipende da un TF alto. Le altre cinque sono pulite, e questo è un
> risultato, non un'assenza di risultato.** Era `[NON MISURATO]` fino a stanotte.

### Perché morde, in aritmetica

L'orologio: **BCM = ora italiana −1**, **FTMO = ora italiana +1** ⇒ **FTMO = BCM + 2**.
La griglia H4 di MT5 è ancorata alla **mezzanotte del server**. Quindi:

| | barre H4 (in ora BCM) | al momento dell'ingresso Dow (14:30 BCM = 16:30 FTMO), l'ultima barra H4 CHIUSA è… |
|---|---|---|
| **BCM** *(dove abbiamo misurato)* | 00 · 04 · 08 · 12 · 16 · 20 | quella chiusa alle **12:00 BCM** — **2 ore e mezza** prima dell'ingresso |
| 🔴 **FTMO** *(dove gira)* | 22 · 02 · 06 · 10 · **14** · 18 | quella chiusa alle **14:00 BCM** — **30 minuti** prima dell'ingresso |

`InpEmaFast=1` significa *«il prezzo di chiusura dell'ultima barra chiusa»*. 🔴 **Quindi il termine
veloce del filtro confronta, su FTMO, un prezzo di DUE ORE più fresco.** E l'`EMA50` lenta è
calcolata su **50 chiusure diverse**.

### Quanto vale il filtro — **misurato, non argomentato**

Dal CSV `risultati_archivio/Dow_Apertura/dow_motore.csv` (12 passate, asse `InpUseEmaFilter` ×
`InpUseVolumeFilter` × `InpVolMult`, `InpRiskPercent=1`), con il filtro volumi spento:

| `InpUseEmaFilter` | Profit | **PF** | **`Equity DD %`** | `n` |
|:--:|---:|---:|---:|---:|
| **0** (spento) | 632,94 | 🔴 **1,03079** | 🔴 **14,9407** | 445 |
| **1** (H4 acceso) | 3.917,49 | 🟢 **1,23808** | 🟢 **6,9201** | 329 |

> ## 🔴 **Il filtro H4 vale +20% di PF e −54% di DD. Non è una rifinitura: è la sedia.**
> A taglia 2,00% la versione senza filtro farebbe **29,88% di DD** — **tre volte il muro**.
> 👉 **Il PF che abbiamo promesso per `770202` è misurato su una griglia che su FTMO non esiste.**

🟢 **E una cosa che tranquillizza a metà, perché va detta**: sull'asse `InpEmaSlow` il filtro ha un
**altopiano largo** — walk-forward OOS, 40 celle, PF fra **1,267 e 1,560** da `EmaSlow=20` a
`EmaSlow=200`, **nessun pettine**. 🔴 **Ma quello è l'asse della LISCIATURA, non della FASE.** La
robustezza a un cambio di smoothing **non dimostra** la robustezza a uno slittamento di 2 ore della
griglia. Sono due assi diversi, e il secondo non è mai stato girato.

### 🟢 E LA MISURA ESISTE GIÀ — scritta stanotte da un altro agente, **e converge con la mia** (misura **M5**)

Mentre scrivevo questo documento, un agente in parallelo è arrivato **dalla parte opposta** alla
stessa manopola: `035c1fc5` del 23/09 00:28 consegna
**`backtest_pipeline/prove/R215a_filtrotf_DOW_U30USD.txt`** — asse unico `InpFilterTF`
**{H1 · H2 · H3 · H4}**, 4 celle, **8 passate**, banco **80.000**, modello 4, `controlla_prova.py`
**OK con 0 problemi**, magic vergine `721501`.
🟢 **Due strade indipendenti sulla stessa domanda in una notte**: io ci sono arrivato dai preset
FTMO (chi legge un TF alto?), lui dai CSV (*«`InpFilterTF` non varia in NESSUNO dei 240 CSV che
hanno quella colonna, 5.264 righe»*). **Questo è il segnale che la domanda è quella giusta.**

👉 **Quindi M5 non è un round da scrivere: è un round da LANCIARE.** E aggiungo solo la cosa che
il mio pezzo di analisi porta in più, perché è utile e **il suo stesso file la dichiara già al §4
come confondimento**:

| | |
|---|---|
| 🟢 **quello che `R215a` misura benissimo** | *«il motore è sensibile al TF del filtro?»* — cioè **la domanda di RISCHIO**, che è quella che serve oggi |
| 🔴 **quello che `R215a` NON può separare** (e lo scrive da sé) | con `InpEmaSlow=50` pinnato, cambiare TF cambia **due cose insieme**: la **fase** della barra di riferimento *e* la **memoria di calendario** dell'EMA (H1→50 h · H2→100 h · H3→150 h · H4→200 h) |
| 🧮 **il pezzo che ci metto io** | la barra **H2** che chiude alle **14:00 BCM** ha **esattamente la stessa chiusura** della barra H4 che su FTMO chiude alle 16:00: 👉 **la cella `H2` riproduce il termine veloce ESATTO di FTMO.** E con `InpEmaSlow=100` su H2 si pareggia anche la memoria (200 ore = la stessa span di `EMA50` su H4) |

> ## 🏁 La conseguenza operativa, in due righe
> 1. 🟢 **Si lancia `R215a` com'è** (8 passate). Se l'altopiano H1-H4 è **largo**, il contratto di
>    `770202` regge e la fase non conta: **il buco si chiude lì**.
> 2. 🔴 **Solo se l'altopiano esce STRETTO** serve il seguito — un asse su `InpEmaSlow` **a TF
>    fisso H2** (`{25 · 50 · 100 · 200}`, 8 passate), che è l'unico modo di separare **fase** da
>    **memoria**. `R215a` §4 lo nomina già come *«un ALTRO file, e non si scrive oggi: un asse per
>    volta»*, ed è la regola giusta. 🛑 **Non lo scrivo io e non lo propongo prima del risultato**:
>    scriverlo adesso sarebbe misurare una cosa di cui non sappiamo ancora se serve.

🛑 **Nessuna firma chiesta**: `770202` è viva, e `R215a` dichiara al suo §V4 che *«in nessun caso
questo round cambia `InpFilterTF` alla sedia viva»*. **Qui si misura, non si propone di cambiare
niente.**

## 6.2 🔎 Gli `.ex5` in campo — `[NON MISURATO]`, e la riga per chiuderlo esiste già

Il 12/09 il binario di `ABTG_EMA200` **in campo** era `344a11b` del 04/08: **486 righe** contro le
**690** del sorgente, e **zero occorrenze** di `InpUsaGuardian`. Un `.ex5` vecchio **ignora in
silenzio** le chiavi che non conosce: il preset diceva `InpUsaGuardian=true` e **non succedeva
niente**.

Oggi **tutti e sei** i preset FTMO portano `InpUsaGuardian=true`. 🔴 **E nessuno ha mai guardato i
binari su `C:\FTMO`.** L'attesa è già dichiarata nel documento del 21/09 (§②): sette `.ex5`, tutti
datati 19 o 20/09, nessun `.mq5` più recente del suo `.ex5`, righe `GUARDIAN` nella scheda Esperti,
hash cartella dati `46C9F8E9FF0C747B2B5E09BCC13D5237`.

👉 **È la stessa riga di M1.** Un solo incolla chiude **due** buchi, e tutti e due valgono punti.

---

# 7️⃣ 🧪 IL CONTRO-ESEMPIO — costruito per rompere «le sei sedie bastano»

🔴 **Non provo la mia tesi contro il nulla: la provo contro l'ipotesi alternativa.** Se *«le sei
sedie bastano»* è falsa, deve esistere uno scenario ragionevole in cui il numero crolla. **L'ho
costruito, e crolla davvero.**

## 7.1 Le tre rotture, applicate insieme

| rottura | perché è legittima | come l'ho modellata |
|---|---|---|
| **A — mancano due sedie correlate** | `770511` è la **terza** sul Dow, `770260` apre **allo stesso minuto** di `770202`. §2.4.1 dice che il numero è un pavimento | aggiungo una **quinta serie fantoccio = copia esatta di `770202`**: è il peggior caso ragionevole per una sedia che apre allo stesso minuto sullo stesso continente |
| **B — il floating** | il muro giornaliero è su **equity**; noi aggreghiamo il **realizzato**. Scarto misurato sul DAX: **−15,7%** | moltiplico **tutte le perdite** per **1,157** |
| **C — lo slippaggio** | misurato **+10,5%** sul primo stop vero (§4), `n=1` | moltiplico le perdite per **1,105** in più |

## 7.2 🏁 Il risultato — **e ribalta una conclusione che stavo per scrivere**

| scenario **PESSIMISTA** (A+B+C insieme), saldo di partenza 78.242,32 | **PASS** | morte **giornaliera** | morte **statica** | gg mediani |
|---|---:|---:|---:|---:|
| 🔴 2,00%, **Guardian NON attivo** | 🔴 **33,3%** | 🔴 **62,0%** | 4,7% | 8 |
| 2,00%, **Guardian attivo** | **67,8%** | 🟢 0,0% | 32,1% | 13 |
| 1,30%, Guardian attivo | **66,1%** | 0,0% | 33,9% | 25 |
| 1,00%, Guardian attivo | **69,0%** | 0,0% | 31,0% | 39 |
| 0,65%, Guardian attivo | **81,7%** | 0,0% | 18,3% | 🔴 **86** |

### 🔴 Cosa regge e cosa NON regge

**❌ NON regge la frase «le sei sedie bastano» come affermazione secca.** Fra **84,0%** (ottimista)
e **67,8%** (pessimista) c'è una forbice di **16 punti**, e **non sappiamo in quale dei due mondi
siamo**. 👉 La frase onesta è: **«le sei sedie bastano SE il Guardian gira e SE lo slippaggio del
22/09 è stato un caso»** — e tutte e due le condizioni **sono misurabili questa settimana a costo
zero** (M1 e M4).

**🟢 REGGE, e più forte di prima, che il Guardian è la leva numero uno.** In tutti e due i mondi è
la cosa che vale di più: **+13,7 punti** nell'ottimista, **+34,5 punti** nel pessimista. **Nessuna
altra azione si avvicina.**

> ## 🔴 **E QUI IL CONTRO-ESEMPIO HA ROTTO UNA COSA CHE STAVO PER SCRIVERE, ED È LA PARTE PIÙ
> UTILE DI TUTTO IL DOCUMENTO.**
> Stavo per scrivere: *«FTMO non ha limite di tempo, quindi abbassare la taglia è GRATIS»*.
> 🔴 **È FALSO, ed è misurato**: nello scenario pessimista scendere da **2,00% a 1,30% PEGGIORA**
> il risultato (**67,8% → 66,1%**), e a **1,00%** lo migliora appena (**69,0%**) pagando **39
> giorni invece di 13**.
> 🧮 **La ragione è aritmetica**: dimezzare la taglia dimezza le perdite **e i guadagni**, quindi
> raddoppia i giorni di esposizione. Con un edge forte (scenario ottimista) vince la protezione:
> **84,0% → 96,6%**. Con un edge debole (scenario pessimista) **vince il tempo di esposizione**, e
> la protezione non ripaga finché non si scende fino allo **0,65%** — che costa **86 giorni di
> borsa, cioè quattro mesi**.
> ## 👉 **Conclusione operativa: la domanda sulla taglia NON È DECIDIBILE OGGI, e chi la decidesse
> oggi tirerebbe a indovinare in un verso o nell'altro.** Diventa decidibile appena M1 e M4 dicono
> in quale dei due mondi siamo. **Per questo il piano degli otto giorni mette M1 e M4 PRIMA di
> qualunque proposta sulla taglia** — e non propone nessuna taglia.

⚠️ **E una cautela in più sulla taglia, che è di regolamento, non di statistica**: fra le
*Forbidden Practices* FTMO c'è *«substantially larger or smaller position sizes compared to other
trades»*. Cambiare la taglia **una volta** a challenge iniziata è **`[NON VERIFICATO]` col
supporto**. 👉 Va in `report/DOMANDE_SUPPORTO_PROP.md` **prima** di essere anche solo proposta.

---

# 8️⃣ 🧭 IL PIANO, IN GIORNI

## 8.0 🔴 La premessa che cambia la forma del piano

**Il 1° ottobre non è più una scadenza.** Il mandato dell'08/09 diceva *«la challenge parte ai
primi di ottobre»*: 🟢 **è partita il 21/09, con dieci giorni di anticipo.** E
`docs/REGOLAMENTO_FTMO_2026-08.md` §1 dice, testuale: *«There is no time limit within which you
need to pass the Profit Target, the Trading Period is indefinite»*.

| | |
|---|---|
| giorni di borsa da oggi al 30/09 | **6** (mer 23 · gio 24 · ven 25 · lun 28 · mar 29 · mer 30) |
| giorni di borsa mediani al +10% | **13-18** |
| 🏁 **la challenge finisce entro il 1° ottobre?** | 🔴 **NO, e non deve.** La probabilità di chiudere in 6 giorni è bassa, e **non c'è nessun premio per farlo in fretta** |
| che cosa DEVE succedere entro il 1° ottobre | 🟢 **che le sei sedie siano ancora vive e che la rete sia verificata.** Nient'altro |

## 8.1 📅 Il calendario

| giorno | cosa si fa | costo | 🔀 **il bivio che apre** |
|---|---|---|---|
| **MER 23/09** *(oggi)* | 🥇 **M1+M2** — Claudio incolla la riga dei binari nella **finestra PowerShell del VPS `VMI3047753`**. La riga **esiste**, ha il pin e ha passato il doppio cancello il 21/09. 🛑 Non apre, non avvia, non chiude e non scrive **niente** su nessuno dei sette terminali | **2 min, zero macchina** | 🔀 **Guardian ATTIVO** → siamo all'84% e il piano resta com'è · 🔴 **Guardian ASSENTE o `.ex5` di agosto** → siamo al 70,3% (33,3% nello scenario pessimista) e **la giornata cambia**: si ricompila e si riattacca, ed è l'unica cosa che conta |
| **MER 23/09** *(in parallelo, se M1 è verde)* | 🥈 **M3** — attaccare `ABTG_TradeExporter` su `C:\FTMO` col preset già in repo e far girare `pubblica_trades.ps1` | 5 min | 🔀 `trades_ftmo.csv` arriva → **il criterio del 18/08 diventa applicabile** e la pagella serale include la challenge · non arriva → si sa perché, e si ripara |
| **GIO 24/09** | 🥉 **M5** sul **PC di backtest**: si lancia **`R215a`**, che è **già scritto e già verde** (8 passate, ancora di regressione dai CSV grezzi, contro-esempio e confondimento dichiarati dentro il file). 🔴 **Resta da scrivere e far passare dal cancello solo la RIGA DI LANCIO** | **8 passate · 2,6-12 min** di tester | 🔀 **fase irrilevante** → il contratto di `770202` regge e si chiude un `[NON MISURATO]` · 🔴 **fase rilevante** → `770202` è **la sedia che non conosciamo**, e la decisione su di lei diventa urgente (resta di Claudio) |
| **VEN 25/09** | 🥉 **M6+M7** sul PC di backtest: `770511` al banco **80.000**, risk 2,00%, tick, IS+OOS, **con l'export per-trade acceso** — chiude il banco sbagliato, il contratto conteso e il quinto per-trade in una corsa sola | **~4 passate · ~10 min** | 🔀 DD sotto il 10% → **terza sedia dimostrata sicura**, e il §2.1 si rifà con **cinque** serie invece di quattro · sopra → sedia da guardare, e il §7 si sposta verso il pessimista |
| **SAB 26 · DOM 27** | 🛑 **mercati chiusi. Non si fa niente sul campo.** Lavoro di scrivania: rifare il §2.1 e il Monte Carlo con le serie nuove, aggiornare `report/PIANO_PROP.md` (fermo alla **v22 del 13/09**, cioè **prima della challenge**: le sei sedie non ci sono) | 0 | 🔀 il Monte Carlo a 5-6 serie conferma l'84% oppure lo abbassa: nel secondo caso **la domanda sulla taglia diventa decidibile** |
| **LUN 28/09** | 🥈 **M4** — prima lettura dello slippaggio accumulato. Con **una settimana di operatività** e ~2,7 op/giorno promesse dalla rosa, ci si aspettano **10-15 uscite**: abbastanza per dire se il +10,5% era un caso | 0 passate | 🔀 **slippaggio ~0** → siamo nello scenario ottimista, **84%**, e non si tocca niente · 🔴 **slippaggio confermato** → scenario pessimista, **67,8%**, e **allora** la taglia va portata a Claudio col numero |
| **MAR 29/09** | ⚪ **M8** (`R214c/d`, Nasdaq M15/M30) **solo se** M5 e M6 sono chiusi. Altrimenti: finire M5/M6 | 8 passate · 2,6-12 min | 🔀 un TF migliore sul Nasdaq → proposta a Claudio (firma sua) · nessuna differenza → casella 5 del certificato chiusa su una sedia in campo |
| **MER 30/09** | 📋 **Il punto**: contratti aggiornati coi numeri nuovi, Monte Carlo rifatto, e **la sola decisione da portare a Claudio** — la taglia, **se e solo se** M4 ha detto che siamo nel mondo pessimista | 0 | 🔀 — |
| **GIO 01/10** | 🟢 **Niente di speciale.** La challenge continua. Se serve un obiettivo per quel giorno, è: **sei sedie vive, Guardian verificato, `trades_ftmo.csv` in repo, contratti aggiornati** | 0 | — |

## 8.2 🛑 E la parte onesta: **cosa NON si fa in questi otto giorni**

Il mandato chiede di scriverlo se il piano onesto è corto. **Lo è**, e queste sono le cose che
**non** si fanno, con il motivo accanto:

- 🛑 **Non si cerca nessun motore nuovo.** Sette riesami indipendenti del 22-23/09 concordano:
  nessun candidato nuovo diventa una sedia in otto giorni. **Insistere sarebbe vendere speranza.**
- 🛑 **Non si lanciano `R212a-e`** (84 passate): misurano un candidato che alla taglia in campo non
  si schiera, e lo dice il suo stesso dossier.
- 🛑 **Non si lanciano `R214e/f/h/i`** (28 passate): candidati non schierabili.
- 🛑 **Non si tocca nessun preset, nessuna taglia, nessuna sedia.** Le due firme possibili
  (la taglia, e il TF del Nasdaq se M8 lo suggerisce) sono di Claudio, e **nessuna delle due va
  proposta prima che M1 e M4 siano tornate.**
- 🛑 **Non gira NIENTE sul VPS che consumi CPU.** Regola del 21/09: i round vanno sul PC di
  backtest. 🔴 **E resta aperto il punto che il 21/09 ha inchiodato la macchina**: il runner
  notturno delle **03:30** è un'attività pianificata **sul VPS**, e finché non è sospesa **ogni
  notte rifà da sola quello che è costato mezz'ora di paralisi mentre le sei sedie operavano**.
  La riga per sospenderlo esiste (`backtest_pipeline/righe/RIGA_SOSPENDI_RUNNER_DA_MANDARE.md`,
  pin `83664b6e`) e **non è mai stata eseguita**. 👉 **È la nona voce della classifica, e forse
  dovrebbe essere la seconda** — ma è un'azione **sul** VPS e la decide Claudio.

> ## 🎯 **In una riga: in questi otto giorni il lavoro che sposta la challenge costa 24 passate di
> tester e tre incolla. Tutto il resto è ponteggio, e lo dichiaro come tale.**

---

# 9️⃣ ✅ COSA È ANDATO BENE — perché un elenco di difetti senza le vittorie descrive male la realtà

- 🥇 **La challenge è VIVA da tre giorni**, con sei sedie, i preset rimappati sull'orologio giusto
  e il Guardian ridimensionato sul banco vero — **e il primo stop vero ha funzionato**: lo stop di
  `771531` del 22/09 ci ha risparmiato **il 13% in più di perdita**, perché il prezzo ha
  continuato a salire dopo.
- 🟢 **Due sedie su sei hanno il DD misurato alla taglia vera e sul banco vero.** Un mese fa non
  esisteva **nessun** contratto scritto per **nessuna** sedia.
- 🟢 **Due sedie sono DIMOSTRATE sotto il muro del 10%**: `770411` (6,27% peggior limite) e
  `770260` (7,31% / 7,86%). La seconda è arrivata **senza un round nuovo**, solo leggendo bene una
  firma di Claudio del 21/09 sera.
- 🟢 **Il cuscino del Guardian è stato allargato il 20/09** (4,5 / 9,3 / 3,5 su banco 80.000): il
  rilievo *«restano 100 $, cioè 2,2 punti di slippaggio»* **non vale più**, e oggi il cuscino è
  **400 € sul giorno e 560 € sul totale**.
- 🟢 **Cinque sedie su sei sono PULITE sul TF alto**, e adesso è **misurato** invece che sperato.
- 🟢 **E la misura più bella della notte è un contro-esempio che ha rotto la mia stessa tesi**
  (§7.2): *«non c'è limite di tempo, quindi abbassare la taglia è gratis»* era **falso**, e il
  numero l'ha detto prima che finisse in un consiglio a Claudio.

---

# 🔟 🕳️ NON COPERTO — per nome

1. 🔴 **Il Guardian su `C:\FTMO`**: `[NON VERIFICATO]`. È **M1**, ed è il buco che costa di più.
2. 🔴 **Gli `.ex5` in campo su `C:\FTMO`**: `[NON MISURATO]`. È **M2**, stessa riga di M1.
3. 🔴 **Il forward FTMO**: **nessun dato in repo.** Il file che servirebbe è
   `data/statements/trades_ftmo.csv`. Tutto quello che sappiamo della challenge viene da
   **schermate del telefono di Claudio**.
4. 🔴 **Il filtro H4 di `770202` sulla griglia FTMO**: `[NON MISURATO]`. 🟢 Il file prova (`R215a`)
   **esiste ed è verde**, ma **non è stato lanciato**. E anche dopo, se l'altopiano esce stretto,
   **fase** e **memoria dell'EMA** restano non separate finché non gira il seguito su `InpEmaSlow`.
5. 🔴 **`770511`**: contratto **CONTESO** (3,91 ↔ 4,17), banco **10.000** invece di 80.000,
   **posizioni `[NON MISURATO]`** (forbice 62-143), **nessun per-trade in repo**.
6. 🔴 **`770411` IS in posizioni**: `[NON MISURATO]`, forbice 9-20.
7. 🔴 **`771531` IS in posizioni**: `[MISURATO FUORI REPO]` (132), l'artefatto **non è in casa** e
   la scorciatoia della gemella **è stata provata e si rompe** (165 contro 257, −36%).
8. 🔴 **`Peggior Giornata %` non esiste per `770411`, `770511`, `771531`**: il loro confronto col
   muro giornaliero del 5% è `[NON MISURATO]` — l'array `stats[]` di quei tre EA si ferma a 8
   colonne.
9. 🔴 **`Equity Drawdown Absolute` vero: `[NON MISURATO]` per tutte e sei.** Costa **una riga** in
   `OnTester()`, che è una modifica a binari che stanno volando: **non la propongo**.
10. 🔴 **Lo slippaggio**: `n = 1`. **Nessuna conclusione.** Vale −5,6 punti diretti e **16 punti di incertezza** fra i due scenari del §7.
11. 🔴 **La deriva del cambio EUR/USD fra ingresso e uscita** (+0,67% misurato in due ore il
    22/09): non modellata da nessuna parte, e `US30.cash`/`US100.cash` sono quotati in USD su un
    conto in EUR.
12. 🔴 **UN SOLO REGIME.** Tutte e sei sono misurate su 2024.09 → 2026.06, dichiarato **toro**.
    **Nessun Monte Carlo fabbrica un regime che non c'è.** Il §7 rompe la statistica, **non
    rompe questo**.
13. 🔴 **Il runner notturno delle 03:30 sul VPS**: `[NON VERIFICATO]` se sia ancora attivo. Due
    notti senza referto (21 e 22/09), due spiegazioni possibili, **nessuna misurata**.
14. 🔴 **Il cambio di taglia a challenge iniziata contro le *Forbidden Practices*
    FTMO**: `[NON VERIFICATO]` col supporto. Va in `report/DOMANDE_SUPPORTO_PROP.md` prima di
    essere proposto.
15. 🟠 **`report/PIANO_PROP.md` è fermo alla v22 del 13/09**, cioè **prima** che la challenge
    esistesse: la tabella madre **non contiene le sei sedie in campo**. Va rifatto, ed è lavoro di
    scrivania del fine settimana (§8.1).
16. ⚪ **La sovrapposizione `D30EUR` ↔ `F40EUR`**: `[NON MISURATA]`, e **oggi non morde** (nessuna
    sedia sul CAC, e `R138a` dà PF OOS 0,76965).

---

*Misura prodotta in sola lettura il 23/09/2026. I numeri che decidono — i sei contratti, le due
sedie misurate alla taglia vera, le 242 giornate aggregate, le due giornate oltre il 5%, il filtro
H4 acceso su una sola sedia su sei, e il 1,03079 contro 1,23808 di `dow_motore.csv` — li ho letti
io al CSV e al preset, non ripresi dai referti. Il Monte Carlo è mio, il metodo è dichiarato prima
del risultato, e il contro-esempio del §7 ha rotto una mia conclusione prima che uscisse di qui.*
