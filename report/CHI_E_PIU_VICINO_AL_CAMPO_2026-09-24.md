# 🧭 CHI È PIÙ VICINO AL CAMPO — la classifica per VICINANZA, non per PF

**24/09/2026** · branch `lavoro` · scritto dall'**architetto-prop**
🛑 **SOLA LETTURA ASSOLUTA, ZERO MINUTI MACCHINA.** Nessun round lanciato, nessuna riga verso il
VPS o verso il PC di backtest, nessun `.mq5`, nessun `.set`, nessun terminale aperto, nessuna
sedia accesa o spenta. La challenge FTMO `541452707` sta operando: **non è stato toccato niente.**
🔴 **Nessuna taglia, nessun parametro di rischio, nessun acquisto proposto. Conto reale
`10105439` mai nominato come bersaglio.** Qui ci sono i numeri e i costi: **decide Claudio.**

> ## ❓ LA DOMANDA DELLA BUSSOLA
> **Quale candidato è PIÙ VICINO a diventare una sedia schierabile, e che cosa esattamente gli manca?**

---

# 0️⃣ 🎯 LA RISPOSTA IN OTTO RIGHE

1. 🥇 **Il più vicino è il `770201` — il motore d'APERTURA USA in versione BREAKOUT A DUE LATI,
   range 15', `U30USD` M5.** Non è la sedia `770202` che vola (quella è RETEST, solo long,
   range 35'): è **un altro motore sullo stesso simbolo e sulla stessa ora**.
2. 🟢 **E ho contato io, riga per riga, nei CSV grezzi**
   (`risultati_archivio/Dow_Apertura/dow_walkforward_{IS,OOS}.csv`, 40 celle per finestra):
   **OOS 40/40 celle con PF ≥ 1,10**, banda **1,26748–1,55976**, mediana **1,37416** ·
   **n OOS 186–198 POSIZIONI** (`InpTP1_ClosePct=0` verificato in tutte e 40 le righe: deal =
   posizioni) · **DD OOS 4,0996–8,6965 % a rischio 1,00 %**.
3. 🔥 **E il numero che nessun referto in repo aveva mai contato: a rischio 1,00 % passano TUTTI
   i cancelli di casa insieme — PF ≥ 1,10, n ≥ 150 e DD ≤ 10 % in TUTTE E DUE le finestre —
   ESATTAMENTE 11 CELLE SU 40.** Nessun altro candidato del parco arriva a una cella sola.
4. 🔴 **MA LE 11 CELLE STANNO TUTTE SUL BORDO DESTRO DELL'ASSE** (`InpEmaSlow` ∈ {160, 180, 200},
   e **200 è l'estremo della griglia**). 👉 La regola di casa *«centro dell'altopiano, MAI il
   picco»* **non si può applicare**: l'altopiano è **tagliato dal bordo**, non chiuso.
   **Questo è il difetto numero uno, ed è quello più economico che esista in tutto il documento:
   si chiude con 24 passate, ≈ 2,0 minuti di macchina.**
5. 🔴 **E il difetto numero due NON è una misura: è una FIRMA.** Alla taglia che vola sulla
   challenge (**2,00 %**) il DD rescalato sfonda il muro statico del 10 % in **39 celle su 40**
   — e **l'unica che sopravvive cade sul campione** (`EmaSlow 20 / TP1_R 0,33`: n IS 138 < 150).
   A **1,00 %** il muro lo rispettano **39 su 40**. **Il problema è di size, e il size è di Claudio.**
6. 🟢 **Il cancello di costo lo passa, e il conto lo faccio qui col numero prudente**:
   stop BREAKOUT = `range(15') + 2×buffer` = **119,75 + 4,00 = 123,75 punti indice**, contro
   uno spread `U30USD` di **3,00** all'ora d'ingresso → **41,3×** contro il pavimento di 40×.
   Col numero d'archivio (2,00) sale a **61,9×**.
7. 📉 **E la classifica dice una cosa scomoda: dietro il `770201` il campo si dirada in fretta.**
   Il secondo (`CostToCost` EURJPY) è fermo su un muro **giornaliero** misurato a **−8,02 %**;
   il terzo (`ORB` Dow long) ha un `n` **invariante a 119** — non è un numero che si può
   *comprare* con una griglia, è una proprietà del motore su quella finestra.
8. 🔴 **E la cosa che va detta prima di tutte: UNA SEDIA IN PIÙ NON È GRATIS.** `R232` misura che
   a 2,00 % per sedia il muro **giornaliero** del 5 % si tocca **alla TERZA sedia aperta
   insieme**. 👉 *«aggiungere la settima»* è una firma di rischio, non un'aggiunta di portata.

---

# 1️⃣ 📏 IL METRO — dichiarato PRIMA della tabella, e non si ammorbidisce

Una candidata è **schierabile** solo se ha **tutte e sei**:

| # | cancello | soglia | dove è scritto |
|---:|---|---|---|
| **C-a** | **MERITO** | PF ≥ 1,10 **in tutte e due** le finestre | criterio di casa, usato in R242/R239 |
| **C-b** | **CAMPIONE** | **n ≥ 150**, contato in **POSIZIONI**, non in deal | Emendamento A (16/08) + classe 226 |
| **C-c** | **RISCHIO** | DD **alla taglia che vola** dentro il muro (10 % statico FTMO) | criterio di uscita 18/08 |
| **C-d** | **COSTO** | `stop ≥ 40 × spread` all'ora d'ingresso | `CLAUDE.md`, frontiera che non si sposta |
| **C-e** | **FREQUENZA** | ≥ 1,00 op/giorno **per FAMIGLIA** | firma 07/09 |
| **C-f** | **SELEZIONE** | la cella è il **CENTRO di un altopiano**, mai il picco, mai il bordo | regola 16/08 |

🔴 **E due regole di lettura, prese di peso e non negoziate:**
- **`n` si conta in POSIZIONI.** La colonna `Trades` dell'OptFrame conta i **deal di uscita**:
  dove l'EA ha `InpTP1Pct/InpTP1_ClosePct > 0`, quel numero va **diviso** (forbice di casa
  misurata **1,00–2,31**; sul `MaxMinNotte` il fattore misurato è **1,50** = 21 deal / 14
  posizioni). Dove `= 0`, deal **sono** posizioni.
- **«Fermo su un numero MANCANTE» ≠ «fermo su un numero BRUTTO».** Il primo è una coda
  dell'imbuto e si insiste; il secondo è un archivio e si scrive il numero. Le due liste
  stanno al §4 e al §5, **elencate per nome** (classe 180), mai per differenza.

📌 **Orari, sempre in tre fusi** (regola di casa): l'apertura USA è **15:30 IT = 14:30 server
BCM = 16:30 server FTMO** (FTMO = BCM + 2, verificato nella rimappatura dei preset FTMO).
Nei CSV del `770201`: `InpSessionHour=14`, `InpSessionMin=30` — **ora server BCM, corretta.**

---

# 2️⃣ 🏆 LA TABELLA — ORDINATA PER VICINANZA AL CAMPO

**Colonna «cert.»** = le cinque caselle del certificato di morte del 09/09, in ordine:
**① PF · ② n+DD · ③ gestione dell'uscita messa ad asse · ④ simboli gemelli · ⑤ TF cambiato.**
**Etichetta della fonte**: 🔬 = **aperto e ricontato da me nel CSV grezzo** · 📄 = **preso da un
referto di casa** (marcato come tale) · ⚪ = `[NON MISURATO]`.

| # | candidato · simbolo · TF | **PF / n / DD misurati** (fonte) | **frequenza** promessa · finestra | **C-d costo `40×`** | 🔴 **CHE COSA MANCA, in una riga, col costo** | **cert.** |
|---:|---|---|---|---|---|:--:|
| **1** 🥇 | **`770201` APERTURA US *BREAKOUT 2 LATI* range 15'** · `U30USD` M5 | 🔬 **OOS PF 1,26748–1,55976** (med. 1,37416), **40/40 ≥ 1,10**, **n 186–198 POS**, **DD 4,0996–8,6965 % @1 %** · IS PF 0,98793–1,54617 (38/40), **n 138–154**, DD 4,4213–12,4677 % — `dow_walkforward_{IS,OOS}.csv`, 40 righe ciascuno, `InpTP1_ClosePct=0` su 40/40 | 📄 **0,720 pos/g** — la più alta del parco · WF vero IS→OOS | 🟢 **41,3×** al numero **prudente** (3,00) · **61,9×** all'archivio (2,00) — `[DERIVATO]`, conto al §3.1 | **① l'altopiano è TAGLIATO dal bordo dell'asse** (`InpEmaSlow` max = 200 e le 11 celle buone sono 160/180/200) → **24 passate ≈ 2,0 min** per estenderlo a 220/240/260. **② la TAGLIA**: a 2,00 % **0 celle su 40** passano insieme merito+campione+muro 10 % (a 1,00 % ne passano **11**) → **firma di Claudio, zero macchina** — oppure **80 passate ≈ 6,8 min** per misurare il DD a 2,00 % invece di rescalarlo. ③ il `.set` + il magic sul conto FTMO → **un file, zero macchina** | **4½/5** |
| **2** 🥈 | **`ABTG_CostToCost`** · `EURJPY` H4 (`772361`) | 📄 **OOS PF 1,52341 · n 242 · DD 12,2627 % @1 %** (IS 1,17686 / 153 / 10,9946) · 🔴 **peggior giornata −8,0159 % OOS e −10,0654 % nell'ORSO 2022** — `R224`, da `r127c` e `regime_r59` | 📄 **394 op su 6,5 anni** ≈ 0,24/g · finestra 2020→2026, **5 regimi misurati** | 📄 🟠 **25,6×** — passa il duro (13,3×), **non** il pavimento di lavoro. Spread EURJPY su BCM **mai misurato** | **manca il round che dice se l'uscita `exit 0/1` tiene la giornata sotto il 5 % anche a TICK: 12 passate, tetto 18 min, i due file prova (`R214e`, `R214f`) sono GIÀ SCRITTI in repo dal 22/09 e mai lanciati** | **2/5** |
| **3** 🥉 | **`ABTG_ORB_Ottimizzato` LONG · stop OPPRANGE** · `U30USD` M5 (`770611`) | 🔬 **OOS PF 1,64233–1,84372 su 12 celle · n 119 · DD 3,7018–5,8722 % @1 %** · 🔴 **IS PF 0,93427–1,08728: 0 celle su 12 arrivano a 1,10, 7 su 12 stanno sotto 1,00** — `r88_csv/..._{IS,OOS}_r88a.csv`, `InpTP1Pct=0` ⇒ deal = posizioni | 📄 **0,449 pos/g** · IS 71 / OOS 119, finestra 2024.09.26→2026.06.30 | 📄 🟢 **~64,0×** con OPPRANGE (**42,7 ×** anche al P95) contro i 29,5× della geometria HALFRANGE viva | 🔴 **manca un numero che NON si può comprare con una griglia: `n` è INVARIANTE a 119 su tutte e 48 le celle di `r88a`** — lo stop non crea ingressi. E l'IS non arriva a 1,10 in nessuna cella. **`R211a` (8 passate ≈ 1,2 min) misura lo stop, NON il campione** | **3/5** |
| **4** | **`ABTG_MaxMinNotte` DAX *box del giorno precedente* SHORT** · `D30EUR` M15 | 🔬 **PF 1,019–1,469 su 7 celle, tutte in utile · DD 1,4257–5,63 % @0,65 % · `Trades` 96–130** — `risultati_archivio/R242/..._IS_R242b.csv` · 🔴 **e `InpTP1Pct=50` in tutte e 7 le righe ⇒ quei numeri sono DEAL: in posizioni fanno ~64–87** (fattore 1,50 misurato sulla `770411`) | 🔬 96–130 deal su ~440 giornate = **0,22–0,30 deal/g** ≈ **0,15–0,20 pos/g** | 📄 🟢 **~160× a H=0** (stop ~272,5 idx) — allargato 7 volte rispetto all'archivio | 🔴 **manca il CAMPIONE, ed è più lontano di quanto dicesse il referto: non 96–130 ma ~64–87 posizioni contro 150.** E **la via della finestra lunga è MORTA** (`@DAQUANDO 2024.09.26` è il fondo del barile BCM: al massimo +14,3 %). Via viva: **il censimento del tasso di riempimento** con `ABTG_Notte_Study` — sola lettura, **zero passate di tester** | **4/5** (manca ⑤ TF) |
| **5-8** | **`ABTG_EMA200` H4 A DUE LATI** · `GBPUSD` · `AUDJPY` · `GBPJPY` · `XAUUSD` H4 | 📄 finestra **UNICA**: PF **1,231 / 1,514 / 1,240 / 1,381** · **362 / 265 / 221 / 187 DEAL** (≈ 180 / 132 / 110 / 93 pos, derivate) · DD **7,21 / 6,26 / 4,42 / 6,15 % @1 %** | 📄 **0,276 / 0,202 / 0,169 / 0,143 pos/g** · 🟢 la famiglia `EMA200` il pavimento lo tocca già con la `771531` | 🟢 `GBPUSD` non morde (spread 0,3 pip med., 84.968 campioni) · ⚪ `AUDJPY` **[NON MISURATO]** | 🔴 **manca lo SPLIT IS/OOS: oggi è una finestra sola con ottimizzatore GENETICO, cioè in-campione per costruzione. 48 / 56 / 38 / 58 passate ≈ 4,3 / 4,9 / 3,5 / 5,1 min.** ⚠️ **E su `AUDJPY` c'è un CONFLITTO fra due misure di casa: vedi §6** | **3/5** |
| **9** | **`ABTG_EMA200` EURUSD H4 — lato CORTO** | 📄 scansione a finestra unica: **SHORT-only 26 celle su 26 positive, PF mediano 1,324** (1,184–1,565), **DD 3,94–6,48 % @1 %** · 🔴 **LONG-only 0 celle positive su 28** | ⚪ **[NON MISURATO]** | 🔴 **`[NON RISOLTO]`: due ancore di casa danno verdetti OPPOSTI — 54,2× (Oanda) contro 22,2× (`772162` su BCM)** | **manca una lettura diretta di `iATR(EURUSD, H4, 14)` sul feed BCM — costo UNA passata — e va fatta PRIMA delle 8 passate del round, perché decide se è un candidato o un escluso** | **2/5** |
| **10** | **`ABTG_SupertrendReversal` NASUSD CORTO + finestra oraria** (`R238`) | 📄 **tick reali**: OOS PF **3,52418 con finestra accesa** contro 1,59763 spenta (**R_tick 2,2059**), **DD 0,5100 % contro 1,0233 %** (fattore **0,498**) · 🔴 **n OOS = 24** | ⚪ 24 op sulla finestra OOS → **[molto sotto il pavimento]** | 🔴 **SOSPESO**: serve la FASE 1 a passata singola, che **nessuno strumento di casa sa lanciare oggi** (`walkforward_generico.ps1` cabla `Optimization=1`) | 🔴 **manca il campione di un fattore DIECI (24 contro 150).** La via più corta è una finestra più lunga o un TF più basso **sul solo lato corto**: costo `[NON STIMATO]`, il file prova non esiste | **3/5** |
| **11** | **`ABTG_SupertrendReversal` U30USD, ancora del DOW** (`R240`) | 📄 **OOS PF 0,97084 spenta / 0,93376 accesa · R_tick 0,9618 · DD 3,302 / 3,504 % · n 76/54** — e **il controllo (il lungo) NON ha tenuto: R_tick 0,6978** | ⚪ | ⚪ | 🔴 **il round c'è già stato e ha risposto NO — ma con l'ancora del NASDAQ.** Manca **il round gemello con l'ancora del Dow** (`StMult 3.5`, `StAtrPeriod 9`, `TP_RR 3.0`): **~18 min**, misurati stamattina sullo stesso EA | **3/5** |
| **12** | **`ABTG_ORB_Ottimizzato` — gemello DAX mai provato** · `D30EUR` M5 | ⚪ **[NON MISURATO]** — nessuna corsa esiste | ⚪ | 🟢 il DAX passa (~50×, `[DERIVATO]`, vedi §3.2) | **manca TUTTO. `R211b` è scritto e mai eseguito — costo `[NON STIMATO]` nel referto d'origine; al ritmo misurato di 0,085 min/passata una griglia da 48 celle costa ≈ 8 min** | **0/5** |
| **13** | **`OPENCONFIRM` DAX, filtro volumi OFF** | 📄 walk-forward tick 06/08: **OOS +209,36 · PF 1,035 · n 250 · DD 13,52 %** (IS PF 0,935 / n 186) | ⚪ | ⚪ | 🟠 **è l'unico del parco con `n` OOS sopra 150 e segno positivo che nessuno stia lavorando — ma il PF 1,035 è un numero BRUTTO, non mancante** (sotto 1,10 e con IS sotto 1,00). Prima di un round serve un motivo, non una griglia | **3/5** |
| **14** | **`ABTG_HVAncora`** · `U30USD` | 📄 OOS PF **1,03844** · **n 35** · DD **3,841 %** — il più basso della lista | ⚪ | ⚪ | 🔴 **il tappo è a monte ed è misurato: 91 ancore IS e 165 OOS SCADONO prima di diventare operazioni.** Non è una manopola, è il meccanismo. `[NON STIMATO]` finché non si decide se si tocca la scadenza | **2/5** |

---

# 3️⃣ 🔬 LE TRE SCHEDE CHE CONTANO — coi conti fatti qui, non altrove

## 3.1 🥇 `770201` — perché è il primo, e i due conti che l'ho fatto io

### A. Il conto dei cancelli, cella per cella — **11 su 40, e nessuno l'aveva contato**

Ho appaiato le 40 celle IS con le 40 OOS per `(InpEmaSlow, InpTP1_R)` e ho applicato
**tutti e tre** i cancelli numerici insieme (PF ≥ 1,10 · n ≥ 150 · DD ≤ 10 %) **in tutte e due
le finestre**, a rischio 1,00 %:

| `InpEmaSlow` | 0,33 | 0,50 | 0,67 | 0,84 | `n` IS |
|---:|:--:|:--:|:--:|:--:|---:|
| 20 · 40 · 60 · 80 · 100 · 120 · 140 | ❌ | ❌ | ❌ | ❌ | **138 – 147** |
| **160** | ✅ | ✅ | ✅ | ✅ | **153** |
| **180** | ✅ | ✅ | ✅ | ✅ | **154** |
| **200** | ✅ | ✅ | ✅ | ❌ *(IS PF 1,07556)* | **154** |

🔴 **E il fatto che va letto per primo: l'UNICO cancello che separa le 11 buone dalle 29 scartate
è `n IS ≥ 150`.** Le celle 20–140 hanno PF e DD a posto in tutte e due le finestre e cadono
**solo** sul campione (138–147). E `n` IS **cresce in modo monotono** con `InpEmaSlow`
(138 → 154), cioè **proprio nella direzione in cui l'asse è tagliato**.

> ## 🔴 QUESTO È IL DIFETTO NUMERO UNO, E NON È IL PF: **l'altopiano buono coincide col BORDO DESTRO dell'asse.** La regola di casa dice *«centro dell'altopiano, MAI il picco»* — ma un altopiano che **tocca il bordo** non ha un centro noto: non sappiamo se a 220 o 240 continua o finisce.

🧪 **Il contro-esempio che mi sono costruito contro, e che NON rompe la conclusione.**
*«Stai scegliendo 160-200 perché lì `n` passa la soglia: è selezione sul cancello, non merito.»*
👉 **È vero, e va scritto** — ma la conseguenza è l'**opposto** di un permesso: proprio perché il
blocco buono nasce dove `n` attraversa il pavimento, **non si può schierare finché non si sa dove
finisce l'altopiano.** L'obiezione **rafforza** la richiesta del round, non la promozione.
Sull'altro asse (`InpTP1_R`, 0,33–0,84) l'altopiano **è chiuso** e il centro esiste: 0,50–0,67.

### B. Il conto del costo — **passa, e col numero prudente**

Geometria letta nel **sorgente**, non trasportata da un'altra sedia
(`INVENTARIO_MOTORI_APERTURA_2026-09-24.md` §2, modo 0 `ABTG_BREAKOUT`):
`entry = rangeHigh + B` · `sl = rangeLow − B` ⇒ **stop = `R + 2B` (+ `InpSlippagePts`)**.

| ingrediente | valore | etichetta |
|---|---:|---|
| `R` = range mediano dei primi **15'** su `U30USD` | **119,75** punti indice | 🟢 `[MISURATO, n = 446]` |
| `B` = `InpBufferPoints` letto in **tutte e 40** le righe del CSV | 200 pt = **2,00** idx | 🔬 `[LETTO]` |
| `InpSlippagePts` | **0** su 40/40 | 🔬 `[LETTO]` |
| **stop = 119,75 + 4,00** | **123,75 idx** | 🟡 `[DERIVATO]` |
| spread `U30USD` all'ora 14 BCM | archivio **2,00** · logger vivo **3,00** → **prudente 3,00** | 🟢 `[MISURATO]`, disaccordo dichiarato |
| **`stop / spread`** | 🟢 **41,3×** (prudente) — **61,9×** (archivio) | contro il pavimento **40×** |

🧪 **Contro-esempio**: *«e se lo stop vero fosse più stretto?»* — le due cose che potrebbero
stringerlo sono il **pavimento** `InpMinStopPts=500` (= 5,0 idx: **inerte**, sta 25 volte sotto
i 123,75) e il **trailing** (`InpUseTrailing=1`, `InpTrailMode=1` su `InpTrailTF=M5`), che però
muove lo stop **dopo** l'ingresso e **a favore**: il cancello misura ingresso→SL **iniziale**.
👉 Per far cadere il 41,3× servirebbe un range mediano sotto **76,0 idx**, cioè un errore del
**−37 %** su una misura con **n = 446**. Non regge.
⚠️ **E il limite del cancello, che vale qui come ovunque**: il pedaggio si paga **due volte**
(ingresso e uscita) e l'ora dell'uscita è `[NON MISURATO]` su ogni sedia del parco.

### C. 🔴 Il difetto numero due — **la TAGLIA, e non è una misura: è una firma**

Rescalando lineare alla taglia che vola sulla challenge (**2,00 %**, classe 547: è una
**derivazione**, non una misura):

| a rischio | celle con DD dentro il muro statico 10 %, **in tutte e due le finestre** |
|---|---:|
| **1,00 %** | 🟢 **39 / 40** — l'unica fuori è `EmaSlow 20 / TP1_R 0,84` (DD IS **12,4677 %**), che cade **anche** su PF IS (0,98793) e su `n` |
| **2,00 %** | 🔴 **1 / 40** — e quell'una è `EmaSlow 20 / TP1_R 0,33` (IS **8,84 %**, OOS **8,20 %**), che ha **n IS 138 < 150**: 🔴 **cade sul campione.** Delle **11 celle che passano tutti i cancelli a 1,00 %**, la meno peggio è `EmaSlow 200 / TP1_R 0,67` e a 2,00 % fa **12,18 % IS / 12,39 % OOS** |

> ## 🔴 **Quindi alla taglia che vola non esiste NESSUNA cella che passi insieme merito, campione e muro: zero su quaranta.** Il `770201` non è bloccato da un numero che manca — **a 2,00 % è bloccato da un numero che c'è.**

👉 Rientrare è una decisione di **size**, e il size è di Claudio. **Io non lo propongo.**
🧪 **E il contro-esempio, perché il numero sopra è una DERIVAZIONE e non una misura**: il
riscalamento lineare (classe 547) è **pessimistico** su una striscia perdente a size frazionale e
**ottimistico** sul resto — il lotto si calcola su `ACCOUNT_BALANCE`, cioè a capitale composto.
👉 L'unico modo per chiudere davvero questa riga è **rigirare le due finestre a `InpRiskPercent=2`**
(80 passate ≈ **6,8 min**), non rescalare. 🔴 **Ma una corsa a 2,00 % non è una proposta di
taglia**: è una misura, e resta tale solo finché nessuno la legge come un permesso.

### D. Le altre tre cose che restano aperte, per nome

1. 🔴 **La sovrapposizione con la `770202`** — stesso simbolo (`U30USD`), stessa ora d'armo
   (14:30 BCM), **stesso filtro EMA su H4 acceso** (`InpUseEmaFilter=1` su 40/40 righe).
   Quanto delle sue 186-198 posizioni cadrebbe **nelle stesse giornate** della sedia viva è
   **`[NON MISURATO]`**. Costo per misurarlo: una lettura dei per-trade, **zero macchina**.
2. 🔴 **Il filtro EMA su H4 è esattamente il difetto già misurato sulla `770202`**: la griglia
   H4 di FTMO è **sfasata di 2 ore** da quella BCM su cui i numeri sono stati misurati, e su
   quella sedia il filtro **non è un dettaglio, è la sedia** (spento: PF 1,03079 / DD 14,9407 %;
   acceso: PF 1,23808 / DD 6,9201 %). 👉 **Lo stesso rischio si trasferisce di peso al `770201`.**
3. 🟠 **Spearman IS→OOS negativo su tutte e quattro le grandezze** (PF −0,357 · RF −0,530 ·
   Profit −0,550 · DD −0,384): **la classifica delle celle non si trasporta.** Per questo la
   cella si sceglie **al centro dell'altopiano** e non al picco — e per questo il bordo tagliato
   (punto A) è un problema vero e non un pignoleria.

### E. 🪦 Il certificato — **4½ su 5**

| casella | esito |
|---|---|
| ① **PF misurato** | 🟢 80 celle, walk-forward vero, tick reali |
| ② **n e DD** | 🟢 n 186–198 **posizioni** OOS · DD 4,10–8,70 % @1 % |
| ③ **gestione dell'uscita ad asse** | 🟢 `InpTP1_R` su 4 valori (0,33 / 0,50 / 0,67 / 0,84) |
| ④ **simboli gemelli** | 🟠 la **famiglia** è misurata su `D30EUR`, `NASUSD`, `F40EUR` — ma **non in questa configurazione** (breakout 2 lati, range 15'). **Mezza casella** |
| ⑤ **TF cambiato** | 🟢 **chiusa PER SORGENTE, non per round**: su `BREAKOUT` il range si legge su `PERIOD_M1` **cablato** e lo stop non guarda il TF del grafico — il TF è una **manopola INERTE** (7 punti di chiamata verificati). Cambiarlo non cambierebbe un numero |

## 3.2 🥈 `CostToCost` EURJPY — il secondo, e il suo tappo **non è quello che c'era scritto**

Per mesi il blocco di questa sedia è stato scritto come *«DD 12,26 % contro 9,33 % promesso»*.
📄 **`R224` (23/09) lo corregge, ed è una correzione che cambia l'azione**: il numero che
sfonda un muro prop qui **non è il drawdown, è la PEGGIOR GIORNATA** — **−8,0159 %** (OOS, BCM,
100k) e **−10,0654 %** (ORSO 2022), contro un muro **giornaliero** del 5 %. Era **nella stessa
riga di CSV**, in una colonna che nessuna classifica aveva mai ordinato.

🟢 **E una via c'è, ed è un MECCANISMO, non un pescaggio**: `InpExitMode` 0 e 1 tengono la
giornata dentro il 5 % dove `exit 2` la sfonda — misurato su **864 celle** (48 simboli × 3
uscite × 3 lati × 2 TF), appaiato per simbolo: **135/144 su H4** e **128/144 su H1**.
🔴 **Ma costa il motore**: `exit 0` contro `exit 2` fa **−49,8 % di profitto**, **−26,1 % di
Recovery Factor**, **−13,1 % di PF**.

👉 **Che cosa manca, in una riga**: **le 12 passate di `R214e` + `R214f`, tetto 18 minuti, con i
due file prova già scritti in repo dal 22/09 e mai lanciati.** È la misura più economica del
documento dopo quella del `770201`.
📌 E una richiesta che costa **zero passate**: le soglie congelate di `R214e` sono scritte su
`Equity DD %`, mentre la colonna che decide è **`Peggior Giornata %`** — che quei CSV **già
producono**. Va aggiunta una soglia **C7 (muro giornaliero, −5,00 %)** prima del lancio.
*Io quei file non li tocco: è una proposta a chi li tiene.*

## 3.3 🥉 `ORB` Dow LONG — perché è terzo e non primo, con **un numero mio che il piano non aveva**

Il `PIANO_CHALLENGE_OTTOBRE_v2` dà la `770611` in **OPPRANGE** come *«passa 5/5»*. 🔬 **Ho
riaperto i CSV di `r88a` e ho contato le celle una per una. Due cose vanno aggiunte, e tutte e
due stringono:**

| | OPPRANGE (`InpSLMode=0`), 12 celle | HALFRANGE (`=3`, la geometria viva) |
|---|---|---|
| **PF OOS** | 🟢 **1,64233 – 1,84372** | 1,24682 – 1,67419 |
| **DD OOS @1 %** | 🟢 **3,7018 – 5,8722** | 7,9551 – 12,0187 |
| 🔴 **PF IS** | **0,93427 – 1,08728** — **0 celle su 12 arrivano a 1,10**, e **7 su 12 stanno sotto 1,00** | 1,03507 – 1,26939 |
| **`n`** | **IS 71 · OOS 119**, identici in **tutte e 48** le celle del file | idem |

👉 **Due conclusioni, e nessuna delle due è un archivio:**
1. **OPPRANGE compra un DD dimezzato e un PF OOS altissimo, e lo paga con un IS che non passa
   mai il cancello del merito.** Segni discordanti fra le due finestre: è lo schema *«regime,
   non edge»*, e va scritto accanto al 1,84.
2. 🔴 **`n` è INVARIANTE a 119.** Lo stop non crea ingressi: **nessuna griglia sullo stop porterà
   mai questa sedia a 150.** `R211a` (8 passate ≈ 1,2 min) è utile e va fatto — ma **misura lo
   stop, non il campione**, e va detto prima, non dopo.
👉 La via al campione, se esiste, è **un altro simbolo** (`R211b`, DAX) o **una finestra più
lunga**, e sugli indici BCM la finestra **non esiste**: `2024.09.26` è il fondo del barile.

---

# 4️⃣ 🟢 FERMI SU UN NUMERO **MANCANTE** — la coda dell'imbuto, per nome

Qui si insiste (motto 09/09). Ordinati per **costo crescente della misura che manca**:

| candidato | misura che manca | costo | chi la firma |
|---|---|---:|---|
| **`770201`** bordo destro di `InpEmaSlow` | 3 valori nuovi × 4 `TP1_R` × 2 finestre = **24 passate** | 🟢 **≈ 2,0 min** (a 0,085 min/passata `[MISURATO]`) | Claudio (è un round) |
| **`EMA200` EURUSD H4** | una lettura di `iATR(EURUSD, H4, 14)` sul feed **BCM** | 🟢 **1 passata** | Claudio |
| **`770201`** sovrapposizione con `770202` | lettura dei per-trade, giornata per giornata | 🟢 **zero macchina** | nessuno: è lettura |
| **`ORB` Dow, stop** | `R211a`, **8 passate** | 🟢 **≈ 1,2 min** | Claudio |
| **`770201`** DD **misurato** a 2,00 % invece che rescalato | le stesse 40 celle × 2 finestre a `InpRiskPercent=2` = **80 passate** | 🟡 **≈ 6,8 min** | Claudio — 🔴 **è una MISURA, non una proposta di taglia** |
| **`MaxMinNotte` box PD** tasso di riempimento | `ABTG_Notte_Study`, **sola lettura, zero tester** | 🟢 **zero passate** | Claudio (è una riga) |
| **`EMA200` H4 `GBPJPY` / `GBPUSD`** split IS/OOS | 38 / 48 passate | 🟢 **≈ 3,5 / 4,3 min** | Claudio |
| **`EMA200` H4 `AUDJPY` / `XAUUSD`** | 56 / 58 passate (+ 1 sonda spread su `AUDJPY`) | 🟢 **≈ 4,9 / 5,1 min** | Claudio |
| **`ORB` DAX** (`R211b`) | griglia intera su simbolo vergine | 🟡 **≈ 8 min** (stima al ritmo misurato) | Claudio |
| **`CostToCost`** le tre uscite | `R214e` + `R214f`, **12 passate** | 🟡 **tetto 18 min** | Claudio |
| **`SupRev` U30USD** ancora del Dow | round gemello di `R240` | 🟡 **≈ 18 min** `[MISURATO stamattina]` | Claudio |
| **`SupRev` NASUSD corto** | il campione, da 24 a 150 | 🔴 `[NON STIMATO]` — **il file prova non esiste** | va scritto prima |

---

# 5️⃣ 🪦 FERMI SU UN NUMERO **BRUTTO** — archivio, col numero accanto

Elencati **per nome**, e nessuno di questi va riaperto senza una misura nuova che lo contraddica:

| candidato | il numero che lo chiude |
|---|---|
| **`MaxMinNotte` box PD, lato LONG** (`R242a`) | 🔴 **0 celle su 7 arrivano a 1,00**, e **5 su 7 hanno n ≥ 150** ⇒ **il merito si LEGGE, ed è negativo.** Lo stop allargato **7 volte** (22,8× → 160×) ha mosso il PF di **+0,002** contro i +0,057 che prediceva la sola rimozione del pedaggio: **il costo non era la spiegazione** |
| **`ORB` U30USD SHORT / due lati** | PF **0,5197** (DD 26,37 %) e **1,0475** (DD 17,16 %, n 219) — **è la via ai 150 che non esiste** |
| **`ORB` NASUSD** | DD IS **19,71–23,86 % a rischio 1 %** |
| **`Nasdaq_Live5m` · `DAX_Live5m` v1/v2** | a tick reali **0,96265 / 0,92490 / 0,85701** — il PF alto era un **artefatto OHLC** |
| **`DAX_Apertura` gemello CAC `F40EUR`** | PF **0,76965**, profitto **−7.266,30** (`R138a`, girato e mai letto) |
| **`MaxMinNotte` gemelli indici** `F40EUR` · `E50EUR` · `100GBP` | PF massimo **0,999 / 0,840 / 0,672** su 54 celle ciascuno |
| **`EMA200` AUDJPY H4 2010-2026** | **MORTO con certificato COMPLETO**: DD 15,35–20,44 % su 8 celle su 8 **e** PF max 0,807 IS / 1,008 OOS |
| **`EMA200` DAX corto, 5 timeframe** | OOS **0,950 · 0,724 · 0,540 · 0,758 · 0,662** — nessuna cella viva a nessun TF |
| **`SuperWave` GBPUSD H2** | **è un PICCO**: i vicini in IS fanno H1 0,703 · H3 0,807 · H4 0,153 |
| **`IntradayMomentum` NASUSD M30** | IS **PF 0,5994 su n = 146**, segno ribaltato su 4 celle su 4 e 2 simboli su 2 |
| **`RANGE_FADE`** (modo 3 delle aperture) | **0 celle positive su 48**, PF sempre fra 0,50 e 0,93, con campioni **195–333 per cella** |

---

# 6️⃣ ⚔️ I CONFLITTI FRA FONTI — dichiarati, non nascosti

| # | conflitto | chi vince, e perché |
|---:|---|---|
| **1** | **`CostToCost`**: `CHI_ALTRO_PUO_SCHIERARSI` (22/09) lo mette fra i **🪦 archiviabili** (*«DD sopra il 10 % in tutte e due le finestre»*); `R224` (23/09) lo dichiara **`NON ANCORA MISURATO`** con 3 caselle su 5 incomplete | 🟢 **Vince `R224`**: è più recente, ha **aperto i CSV** e ha trovato che il tappo vero è un'**altra colonna**. Il DD sopra il 10 % resta vero e resta scritto |
| **2** | **`EMA200` H4 `AUDJPY`**: `CHI_ALTRO` §2.3 dà **PF 1,514 · DD 6,261 % @1 %** (finestra unica, genetico); `R139a` (18/09) lo dà **MORTO** con DD **15,35–20,44 %** e PF max **1,008** | 🔴 **APERTO, e le due misure NON sono la stessa cosa**: finestre diverse (21 mesi contro 16,5 anni) e ottimizzatori diversi. 👉 **Il verdetto di morte di `R139a` regge** (finestra lunga, certificato completo); il 1,514 descrive **una fetta**, ed è esattamente l'errore già pagato su questo simbolo (*«non descriveva un motore: descriveva due anni e mezzo»*) |
| **3** | **`MaxMinNotte` short, via al campione**: `REGISTRO_TEST.md` porta ancora *«via più corta: allungare la finestra a ~4 anni → n ≈ 220-300»*; `REFERTO_R242` la dichiara **MORTA** (BCM sugli indici parte dal 26/09/2024, `COMPLETO`) | 🟢 **Vince il referto**, che è più recente ed è una **misura** (sonda sul PC di backtest, confermata da 3 fonti indipendenti). 🔴 **La riga del registro è scaduta** — io il registro non lo tocco, ma lo segnalo |
| **4** | **Costo del DAX**: quattro documenti dicono *«33,0×, non passa»*; `IL_COSTO_DEL_DAX_RISOLTO` (24/09) dice **~50×, passa** | 🟢 **Vince il risolto, e per GEOMETRIA**: il 33,0× implicava che il range di **35'** fosse più piccolo di quello di **15'** (54,65, `[MISURATO, n=440]`) — **impossibile**, la finestra lunga contiene la corta |
| **5** | **`770101` frequenza**: contratto **0,699 op/g**, campo sul piccolo **0,886** | 🟠 **Nessuno dei due si butta**: il campo include `NASUSD` (magic doppio). Resta il contratto |

---

# 7️⃣ 🔴 CHE COSA QUESTA CLASSIFICA **NON** DICE — e va detto

1. **Non dice che una settima sedia si può accendere.** `R232` misura che a 2,00 % per sedia
   l'ordine dei muri è: pausa morbida del Guardian (3,5 %) → **2ª** sedia aperta insieme · muro
   **giornaliero 5 %** → **3ª** · statico 10 % → **5ª** · margine → **6ª**.
   👉 **Aggiungere una sedia è una firma di RISCHIO**, non un'aggiunta di portata.
2. **Non risolve il problema di stamattina.** La rosa ha aperto **1-2 posizioni in due giornate**
   contro **~5,4** attese (contratto sommato **2,683 op/g**). 🔴 **Una settima sedia non ripara
   una rosa che non spara: la diluisce.** Se il tappo fosse un **filtro** (l'indiziato è la
   `770260`, 0 posizioni su **tre conti diversi** e 2 rifiuti su 2 per volumi), aggiungere
   motori non lo tocca. **Quella misura arriva da sola nei giornali delle prossime notti, a
   costo zero, e va aspettata.**
3. **Nessuno di questi numeri è misurato sul feed FTMO.** Sono tutti su **BCM**: spread, tick,
   range. Lo spread FTMO che abbiamo è **`[MISURATO, GG=1]` e all'ora 10, non all'apertura USA**,
   e **commissioni e swap FTMO sono `[NON MISURATO]`** ⇒ ogni `×` su FTMO qui dentro è un
   **tetto**, non un valore.
4. **Non ho verificato che nessun `.ex5` in campo corrisponda al `.mq5` a HEAD.** È il difetto
   che il 12/09 ha trovato `ABTG_EMA200` in campo con un binario di 486 righe contro 690.
5. **Non ho aperto**, e lo dico per nome: `backtest_pipeline/prove/R243*`, `R244*` e
   `report/GUARDIAN_SEI_SEDIE_2026-09-24.md` — tre agenti ci stanno lavorando in parallelo.
   Se uno di quei tre cambia un numero di questa tabella, **questa tabella è più vecchia di lui.**
6. **Non ho proposto nessuna taglia, nessun rischio, nessun acquisto**, e non ho toccato niente
   in forward.

---

# 8️⃣ 🎯 LA RIGA CHE CHIUDE

> ## **«Se oggi potessimo fare UNA cosa sola per avere una sedia in più il 1° ottobre, sarebbe:**
> ## **girare le 24 passate che chiudono il BORDO DESTRO dell'asse `InpEmaSlow` del `770201`** — cioè estendere la griglia a **220 / 240 / 260** × i quattro `InpTP1_R`, su tutte e due le finestre, **sul PC di backtest**.»

| | |
|---|---|
| **perché proprio questa** | È l'**unica** misura del parco che trasforma un *«altopiano tagliato»* in una **cella scelta col centro dell'altopiano** — cioè il prerequisito senza il quale tutto il resto (`.set`, magic, taglia) sarebbe una cella scelta col picco. E il `770201` è l'**unico** candidato che oggi mette **11 celle su 40** dentro **tutti** i cancelli a 1,00 %, con **n OOS 186-198 in posizioni** e il cancello di costo passato a **41,3×**. |
| **costo** | 🟢 **≈ 2,0 minuti di macchina** (24 passate × 0,085 min/passata `[MISURATO]` sullo stesso EA, stesso simbolo, stesso TF, a tick reali) + la scrittura di un file prova e i **due strati del cancello**. Sigla libera al momento della scrittura: **`R245`** (grepata: 0 occorrenze). |
| **chi deve firmarla** | 🔴 **Claudio.** È un round, e i round girano **sul PC di backtest**, non sul VPS, finché la challenge è viva (firma del 21/09). |
| 🔴 **e la seconda firma, che non si può nascondere** | Anche con `R245` verde, **il `770201` non è schierabile alla taglia che vola**: a 2,00 % **nessuna delle 40 celle** passa insieme merito, campione e muro del 10 % (l'unica che tiene il muro ha n IS 138); a **1,00 %** ne passano **11**. La sedia esiste; **la taglia a cui esiste è una decisione di Claudio**, e io non la propongo. |

---

## 🔒 PERIMETRO
Sessione in **sola lettura**. File aperti da me e ricontati: `dow_walkforward_{IS,OOS}.csv` ·
`r88_csv/ABTG_ORB_Ottimizzato_U30USD_{IS,OOS}_r88a.csv` ·
`risultati_archivio/R242/ABTG_MaxMinNotte_D30EUR_{IS}_R242{a,b}.csv` ·
`mql5/Presets/FTMO/*.set` · `backtest_pipeline/prove/R211a_*.txt` · `R214f_*.txt`.
Referti letti e citati come tali: `LA_CHALLENGE_NON_STA_OPERANDO_2026-09-24` ·
`PERCHE_LE_SEDIE_NON_SPARANO_2026-09-24` · `REFERTO_R240_2026-09-24` · `REFERTO_R242_2026-09-24` ·
`REFERTO_R238_2026-09-23` · `REFERTO_R239_2026-09-24` · `REFERTO_13_ROUND_2026-09-23` ·
`MAPPA_COSTO_SIMBOLI_TF_2026-09-24` · `IL_COSTO_DEL_DAX_RISOLTO_2026-09-24` ·
`INVENTARIO_MOTORI_APERTURA_2026-09-24` · `COSTTOCOST_LA_SETTIMA_SEDIA_2026-09-23` ·
`QUANTE_SEDIE_CI_STANNO_2026-09-23` · `CHI_ALTRO_PUO_SCHIERARSI_2026-09-22` ·
`DOW_BREAKOUT_DUE_LATI_IL_BUCO_2026-09-22` · `CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20` ·
`IL_PIANO_DEGLI_OTTO_GIORNI_2026-09-23` · `AUDJPY_E_GBPUSD_IL_NUMERO_CHE_MANCAVA_2026-09-18` ·
`PIANO_CHALLENGE_OTTOBRE_v2` · `IL_TAPPO_2026-09-11` · `REGISTRO_TEST.md`.
**Nessun candidato promosso, nessuno archiviato d'autorità.**

*Referto del 24/09/2026 — architetto-prop.*
