# 🥇 DOW BREAKOUT A DUE LATI — i tre buchi chiusi, e il quarto che nessuno aveva guardato

**22/09/2026** · branch `lavoro` · 🛑 **SOLA LETTURA E ZERO TEMPO MACCHINA**: nessun round
lanciato, nessuna riga consegnata, nessun VPS, nessun forward, nessun preset, nessuna sedia
toccata. Tutti i numeri qui sotto sono **ricalcolati dai CSV grezzi**, non copiati dai referti.

> ## 🎯 IN SEI RIGHE
> 1. 🟢 **BUCO 1 CHIUSO.** Il binario è `ABTG_Nasdaq_Apertura_US.ex5` — provato **due volte**
>    (lo script lo nomina; la colonna `InpMagic=770201` è il suo default compilato, il Dow ha
>    770202). **E non cambia i numeri**: al commit dei CSV i due sorgenti hanno **ZERO**
>    differenze nel corpo del codice e **14 dei 15** default discordanti erano pinnati.
> 2. 🟢 **BUCO 2 CHIUSO, e in direzione opposta a quella temuta.** La **classe 590 NON si
>    applica**: frazione di `n` IS venuta da tick fabbricati = **0,0%**, perché prima del
>    26/09/2024 **non esistono nemmeno le barre M1** da cui fabbricarli. Il difetto è
>    nell'**etichetta**, non nei numeri. Verificato con aritmetica indipendente: **−2,6%**
>    contro la finestra vera, **−50,7%** contro l'etichetta.
> 3. 🔴 **BUCO 3 CONFERMATO E PEGGIORATO.** Spearman IS→OOS: **−0,357** sul PF — ma anche
>    **−0,530** sul Recovery Factor, **−0,550** sul Profit e **−0,384** sul drawdown.
>    **Nessuna** delle quattro grandezze si trasporta. **E nemmeno il DD**, che è quello su
>    cui contavo.
> 4. 🔥 **E IL QUARTO BUCO, che vale più dei tre:** alla taglia FTMO del **2,00%** passano il
>    muro del 10% solo **3 celle su 40 in IS** e **12 su 40 in OOS**, con **UNA** cella in
>    comune — e **una è esattamente quante ne prevede il puro caso (0,90)**. 👉 *«sopravvive
>    su due finestre»* qui **non porta informazione**.
> 5. 🟢 **LA LEVA GIUSTA NON È IL PARAMETRO, È LA TAGLIA.** A rischio **1,00%** passano il
>    muro **39/40 in IS e 40/40 in OOS**. Il problema di schierabilità è un problema di
>    **size**, e il size è **firma di Claudio**.
> 6. 📦 **Consegnati 5 file prova**, `controlla_prova.py` **verde**, **84 passate**
>    (**28,2 – 125,4 min**, tetto), con **ancora di regressione** e **cancello di determinismo**.

---

# 0️⃣ 📐 LA GRIGLIA VERA — prima correzione, e va fatta subito

Il mandato diceva *«assi della griglia: `InpEmaSlow` (20/40/60/80) × `InpTP1_R`»*.
🔴 **È sbagliato.** Ricalcolato dai CSV:

| asse | valori **veri** nei CSV | quanti |
|---|---|---|
| `InpEmaSlow` | 20 · 40 · 60 · 80 · 100 · 120 · 140 · 160 · 180 · **200** | **10** |
| `InpTP1_R` | 0.33 · 0.50 · 0.67 · 0.84 | 4 |

10 × 4 = **40 celle** per finestra, 80 passate in tutto — il conto torna solo così.
Lo conferma lo script: `dow_apertura.ps1` r.172 `InpEmaSlow=50||20||20||200||Y`.
**Non è pignoleria**: chi avesse riletto la griglia come 4×4=16 avrebbe cercato un altopiano
su un dominio lungo **un quinto** di quello misurato.

Tutto il resto del mandato l'ho **verificato e confermato**: `U30USD` M5, `InpSessionHour=14`
`InpSessionMin=30`, `InpRangeMinutes=15`, chiusura 17:30, `InpAllowLong=1` **e**
`InpAllowShort=1`, `InpTP1_ClosePct=0` (⇒ uscite = **posizioni**), `InpRiskPercent=1`,
`InpUseTrailing=1` / `InpTrailMode=1` / `InpTrailTF=M5`, `InpMagic=770201` su tutte e 80 le
righe. OOS: **40/40 con PF ≥ 1,10**, banda **1,26748–1,55976**, mediana **1,37420**,
**186–198** posizioni. ✅

---

# 1️⃣ 🟢 BUCO 1 — QUALE SORGENTE HA PRODOTTO QUEI NUMERI: **risolto a macchina**

## 1.1 La domanda posta bene

`DOW_MOTORE.md` r.3 dichiara `ABTG_Nasdaq_Apertura_US` applicato a `U30USD`. Il mandato
chiedeva di risolverlo confrontando **le colonne `Inp*` del CSV con gli `input` di ogni
candidato**. L'ho fatto. 🔴 **E quel test da solo NON discrimina** — va detto, perché è un
contro-esempio contro il metodo proposto, non contro la risposta.

| sorgente al commit `c5654989` (04/08/2026) | n. `input` | colonne CSV mancanti | `input` in più |
|---|---:|---|---|
| `ABTG_Dow_Apertura_US.mq5` | **77** | **0** | **0** |
| `ABTG_Nasdaq_Apertura_US.mq5` | **77** | **0** | **0** |

**Insieme di input identico, e identico anche l'ORDINE di dichiarazione** (che è l'ordine
delle colonne del CSV). Il test degli input **non separa i due**.

## 1.2 Il test che separa: `InpMagic`

`InpMagic` **non è fra i 38 input pinnati** da `dow_apertura.ps1` ⇒ nel `.ini` non c'è ⇒ MT5
usa il **default compilato**. E i default compilati sono diversi:

| | `ABTG_DEF_MAGIC` |
|---|---|
| `ABTG_Nasdaq_Apertura_US` | **770201** |
| `ABTG_Dow_Apertura_US` | 770202 |

**I CSV portano `InpMagic = 770201` su tutte e 80 le righe.** 👉 Il binario è **quello del
Nasdaq**. Seconda prova, indipendente: `dow_apertura.ps1` r.36 `$EA="ABTG_Nasdaq_Apertura_US"`
(col commento *«è l'EA dell'apertura USA: il Dow apre alla stessa ora»*).

## 1.3 🟢 E la notizia buona: **non cambia un numero**

Due misure, fatte oggi:

**(a) il corpo del codice è identico.** Tolti commenti, `#define` e dichiarazioni `input`, i
due sorgenti a `c5654989` hanno **1.092 righe di codice ciascuno e ZERO differenze**.

**(b) i default discordanti erano quasi tutti pinnati.** I due sorgenti hanno **15 input** con
default diverso. **14 sono pinnati** dallo script (`InpEmaSlow`, `InpTP1_R`, `InpCloseHour`,
`InpCloseMin`, `InpBufferPoints`, `InpUseEmaFilter`, `InpEmaFast`, `InpFilterTF`,
`InpRiskPercent`, `InpTP1_ClosePct`, `InpBreakevenAtTP1`, `InpTrailTF`, `InpMinStopPts`,
`InpSkipIfTight`). **Il quindicesimo è `InpMagic`**, che non entra nel segnale.

> 🧪 **CONTRO-ESEMPIO che mi sono costruito contro.** *«Allora il binario non conta e la
> domanda era oziosa.»* **Falso, e la prova è a HEAD**: oggi i due sorgenti hanno **318
> differenze nel corpo** (il Nasdaq ha preso `R30` VolRegime/SRFilter e la FASE 2 DRIVE).
> **La coincidenza valeva il 04/08 e non vale più.** Per questo il round nuovo gira su
> `ABTG_Dow_Apertura_US` — il più vicino all'originale — **e pinna tutto**.

## 1.4 📜 La storia del file fra i CSV e oggi — quali commit toccano la LOGICA

I CSV sono del **05/08/2026** (fase `walkforward` di `dow_apertura.ps1`, girata dopo
`511cc977` del 04/08 e **prima** di `2f4c95ae` del 05/08 22:18, che corregge la data
nello script). Il binario ha **77 input** ⇒ è **antecedente** a `586e19d4` (che aggiunge
`InpOCTimeframe`, 78° input).

| commit | data | tocca la LOGICA della **nostra** configurazione? |
|---|---|---|
| `eba618ba` | 05/08 | 🟢 **NO** — corregge GAPFILL, RANGE_FADE e DELAYED. Con `InpEntryMode=0` (BREAKOUT) sono rami morti. Il commit stesso: *«con i filtri spenti e in modalità BREAKOUT il comportamento è identico a prima»* |
| `586e19d4`, `da0ac95b` | 05/08 | 🟢 NO — OPENCONFIRM (`EntryMode=5`), ramo morto |
| `ef3be41f` | 06/08 | 🟡 **FORSE** — *«il breakeven esce dal ramo della chiusura parziale»*. Qui `InpTP1_ClosePct=0` e `InpBreakevenAtTP1=0`: **dovrebbe** essere inerte. «Dovrebbe» non è una misura |
| `6e8c3f4c`, `8b922147` | 06–14/08 | 🟡 guardie A4 (93 e 22 righe) — **[NON VERIFICATO riga per riga]** |
| `e1609a01` | 07/08 | 🟢 NO — `InpTrailStartR`, **default 0** = *«arma subito»*, identico a prima |
| `3af47ed9` | 08/08 | 🔴 **SÌ, e può mordere** — il lotto si calcola con `OrderCalcProfit` invece del tick value nudo. Il commit dichiara *«sui simboli sani i due calcoli coincidono»*, ma `U30USD` è un indice **USD** su conto **EUR**: che sia «sano» è **[NON MISURATO]** |
| `d83c1960` | 19/08 | 🔴 **SÌ** — Guardian, `InpUsaGuardian` **default `true`**, 8 punti di chiamata. **Va pinnato a 0**, altrimenti la prova cambia senza dirlo |
| `9fca63d9` | 19/09 | 🟡 *«toppa per ticket»*, 64 righe — **[NON VERIFICATO riga per riga]** |

👉 **Proprio perché questa tabella ha tre `[NON VERIFICATO]` e un 🔴, l'ancora di regressione
non è un vezzo: è l'unico modo di rispondere alla domanda con una misura invece che con una
lettura di diff.**

---

# 2️⃣ 🟢 BUCO 2 — L'IS SU DATI CHE NON ESISTONO: **la classe 590 NON si applica**

## 2.1 Il conto dei giorni, come richiesto

| | giorni solari | **giorni feriali** |
|---|---:|---:|
| IS **dichiarato** 2024.01.01 → 2025.06.30 | 547 | **391** |
| IS **con dati** 2024.09.26 → 2025.06.30 | 278 | **198** |
| IS **senza dati** 2024.01.01 → 2024.09.25 | 269 | **193** |
| copertura | | 🔴 **50,6%** |

**Metà della finestra dichiarata non esiste.** Ma la domanda non è «quanta manca»: è
**«quanto del `n` e del DD viene dalla parte fabbricata»**. Risposta, col numero:

## 2.2 🟢 **Frazione di `n` IS e di DD IS venuta da tick fabbricati: 0,0%**

Non «poca»: **zero**, e per una ragione strutturale.
`backtest_pipeline/risultati_archivio/misura_tick/REFERTO_MISURA_TICK_U30USD.txt`:

```
I TICK REALI DI U30USD PARTONO DAL 2024.09.26   (67618571 tick)
MURO DELLE BARRE M1, colonna PrimaDataServer: 2024.09.26
U30USD M1 barre=650255 locale=2024.09.26 server=2024.09.26 -> IL BROKER NON HA PIU' STORICO
U30USD M5 barre=130126 locale=2024.09.26 server=2024.09.26 -> IL BROKER NON HA PIU' STORICO
```

👉 **MT5 fabbrica i tick DALLE BARRE M1. Prima del muro non ci sono nemmeno quelle.** Non c'è
niente da cui fabbricare: il tester comincia dove cominciano i dati.

## 2.3 🧮 La verifica aritmetica — fatta da me, non copiata

Cadenza OOS misurata: **197 posizioni mediane / 261 giorni feriali = 0,7548 pos/giorno**.

| ipotesi sulla finestra IS | feriali | `n` atteso | `n` **osservato** (mediana) | scarto |
|---|---:|---:|---:|---:|
| finestra **ETICHETTA** (18 mesi) | 391 | 295,1 | 145,5 | 🔴 **−50,7%** |
| finestra **REALE** (9,1 mesi) | 198 | 149,4 | 145,5 | 🟢 **−2,6%** |

## 2.4 🧪 IL CONTRO-ESEMPIO che ho costruito contro la mia stessa risposta

*«Il referto dei tick è del 20/08/2026; i CSV sono del 05/08. Se il muro fosse una finestra
MOBILE, il 05/08 sarebbe stato in un altro punto e il conto non varrebbe.»*

**Misurato, e l'ipotesi mobile è ESCLUSA su tre fronti:**
1. **Tre simboli, tre date di misura diverse, stesso muro**: `U30USD` misurato il **20/08**,
   `NASUSD` il **30/08**, `D30EUR` il **07/09** → tutti e tre **2024.09.26**. Una finestra
   mobile si sarebbe spostata di **18 giorni**. Non si è spostata di uno.
2. Il muro è **identico su M1, M5 e sui tick**, con verdetto testuale *«IL BROKER NON HA PIÙ
   STORICO»*: è l'inizio dei dati del server, non un ritaglio locale.
3. 🔴 **La prova diretta esisteva già e non l'avevo aperta**: il commit **`2f4c95ae` del
   05/08/2026 22:18** — cioè **lo stesso giorno dei CSV** — dice testualmente
   *«`SERIES_SERVER_FIRSTDATE == SERIES_FIRSTDATE == 2024.09.26` su D30EUR, NASUSD e U30USD,
   su tutti e 7 i timeframe»*, e **corregge la data dentro `dow_apertura.ps1`** da
   `2024.01.01` a `2024.09.26`.

👉 **Verdetto: il BUCO 2 non è un buco nei numeri. È un buco nell'etichetta**, già misurato e
già corretto nello script il giorno stesso, e mai propagato a `DOW_MOTORE.md`.
🟢 **Conseguenza operativa: l'IS dell'archivio è già l'IS pulito.** Il round nuovo non lo
«ripulisce»: lo **riproduce**, ed è per questo che l'IS può fare da seconda ancora.

---

# 3️⃣ 🔴 BUCO 3 — LA CORRELAZIONE DI RANGO: **confermata, e peggiore di come era scritta**

## 3.1 Ricalcolata dai CSV, non dal documento

| grandezza | **Spearman IS→OOS** | Pearson |
|---|---:|---:|
| **Profit Factor** | **−0,3570** | −0,3781 |
| **Recovery Factor** | 🔴 **−0,5304** | −0,5052 |
| **Profit** | 🔴 **−0,5495** | −0,5960 |
| **Equity DD %** | 🔴 **−0,3838** | −0,3458 |

Il **−0,357** di `DOW_MOTORE.md` è **esatto**. Ed è la *migliore* delle quattro.

Le cinque celle migliori in IS, e dove atterrano in OOS:

| cella | PF IS | rango IS | PF OOS | **rango OOS** |
|---|---:|---:|---:|---:|
| EMA 40 · TP1_R 0.50 | 1,5462 | 1ª | 1,3398 | **31ª/40** |
| EMA 40 · TP1_R 0.33 | 1,4346 | 2ª | 1,3668 | **23ª/40** |
| EMA 40 · TP1_R 0.67 | 1,3949 | 3ª | 1,3726 | **21ª/40** |
| EMA 120 · TP1_R 0.50 | 1,3939 | 4ª | 1,3135 | **35ª/40** |
| EMA 60 · TP1_R 0.50 | 1,3930 | 5ª | 1,3581 | **24ª/40** |

**31ª, 23ª, 21ª, 35ª, 24ª** — identico a quanto scritto nel documento. ✅ **Verificato.**

## 3.2 🔴 E la cosa che cercavo e NON c'è: nemmeno il DRAWDOWN si trasporta

L'idea era: *«se la classifica del PF è rumore, forse la struttura del DD lungo l'asse
`InpEmaSlow` no — la fase robustezza del 03/08 aveva misurato EMA corta = DD più basso»*.
**L'ho provata, e CADE.**

| gruppo | **DD mediano IS** | **DD mediano OOS** | PF mediano IS | PF mediano OOS |
|---|---:|---:|---:|---:|
| EMA **20–80** (corta) | **6,505%** | 🟢 **4,674%** | 1,2766 | 1,4255 |
| EMA **100–200** (lunga) | **6,280%** | 🔴 **6,398%** | 1,2751 | 1,3489 |

👉 In **OOS** lo stacco c'è (1,7 punti). **In IS NON ESISTE** — anzi è invertito di un soffio.

🔴 **E la fase robustezza del 03/08 non è una conferma indipendente**: girò sulla finestra
**piena 2024.09–2026.06**, che **contiene tutto l'OOS**. Quel *«EMA 20-80 → DD 7,42% contro
11,43%»* e il *«4,674 contro 6,398»* dell'OOS **sono in buona parte lo stesso dato letto due
volte.**

## 3.3 ❓ **Allora COME si sceglie la cella senza barare?** — le tre risposte, in ordine

### ❌ Risposta 1 (scartata): «si dichiara prima la regola, es. centro della banda»
La proposta del mandato è **metodologicamente giusta** e va scritta. Applicandola:
centro geometrico di `InpEmaSlow` (20…200) = **110** → celle adiacenti **100** e **120**;
mediana di `InpTP1_R` = **0,585** → celle adiacenti **0,50** e **0,67**.

| cella «centro» | PF OOS | **DD % OOS** | RF OOS | **DD @2,00% (×1,990)** |
|---|---:|---:|---:|---:|
| EMA 100 · TP 0.50 | 1,3777 | 6,358 | 2,992 | 🔴 **12,65%** |
| EMA 100 · TP 0.67 | 1,3431 | 5,726 | 3,184 | 🔴 **11,40%** |
| EMA 120 · TP 0.50 | 1,3135 | 6,358 | 2,553 | 🔴 **12,65%** |
| EMA 120 · TP 0.67 | 1,2910 | 6,231 | 2,545 | 🔴 **12,40%** |

🔴 **Il centro geometrico della griglia cade nella metà con il DD OOS peggiore e sfonda il
muro FTMO del 10% su tutte e quattro le celle.** Non lo scarto perché rende poco (*quello*
sarebbe selezione): lo scarto perché **non passa un cancello di rischio**.

### ✅ Risposta 2: il cancello di RISCHIO non è selezione — **ed è vero, ma qui non aiuta**
Il mandato dice, e **confermo**: un cancello di rischio **rifiuta**, non **ordina**; e per
l'Emendamento B (16/08) **si legge a qualunque `n`**. Applicato **indipendentemente alle due
finestre**, con `Equity DD % × 1,990 < 10,0%` *(fattore di casa, classe 547 — 🔴 **[NON
RIVERIFICATO DA ME]**, preso da `RIESAME_MORTI_NOTTURNI_2026-09-22.md` §1b)*:

| taglia | celle che passano in **IS** | in **OOS** | **in entrambe** | **attese per puro caso** |
|---|---:|---:|---:|---:|
| rischio **1,00%** | 🟢 39/40 | 🟢 **40/40** | **39** | 39,00 |
| rischio **2,00%** (×1,956) | 🔴 4/40 | 🔴 12/40 | **1** | 1,20 |
| rischio **2,00%** (×1,990) | 🔴 **3/40** | 🔴 **12/40** | **1** | **0,90** |

L'unica cella che sopravvive in entrambe alla taglia 2,00% è **`InpEmaSlow=20` /
`InpTP1_R=0.33`** (IS 8,80% · OOS 8,16%) — **esattamente quella proposta dal mandato.**

> 🧪 **E QUI IL CONTRO-ESEMPIO UCCIDE LA REGOLA, non la cella.**
> Se i due cancelli fossero **indipendenti**, l'intersezione attesa è
> `40 × (3/40) × (12/40) = **0,90 celle**`. **Ne osserviamo 1.**
> Ipergeometrica: `P(intersezione = 0) = 0,332`, quindi **`P(≥1) = 0,668`**.
> 👉 **Osservare una cella in comune è l'esito PIÙ PROBABILE del puro caso.**
> Sommato allo Spearman del DD (**−0,384**: il DD in IS *anti*-predice il DD in OOS), la
> conclusione onesta è: **«sopravvive al cancello di rischio su due finestre» non porta
> informazione su questo dato.** Non è un argomento per schierare quella cella.

### 🟢 Risposta 3, ed è quella vera: **la leva non è il parametro, è la TAGLIA**

Guardando la riga «rischio 1,00%» della tabella qui sopra:
**39/40 in IS e 40/40 in OOS stanno sotto il muro del 10%.** L'unica bocciata è
EMA 20 · TP 0.84 (DD IS **12,468%**).

👉 Riformulato: **alla taglia 1,00% la scelta della cella è quasi irrilevante per il rischio,
e allora la regola dichiarata prima («centro dell'altopiano») torna applicabile.
Alla taglia 2,00% NESSUNA scelta di cella è difendibile con questi dati.**

📌 **Il che significa che la domanda «quale cella» era la domanda sbagliata.** La domanda
giusta è **«a quale taglia»** — e quella è **firma di Claudio**, non mia.
Per riferimento, e **senza proporre niente**: perché la cella EMA20/TP0.33 stia sotto il 10%
nella **peggiore** delle due finestre servirebbe un rischio ≤ **2,26%** (scala lineare); per
EMA60/TP0.50 ≤ **1,57%**; per EMA40/TP0.50 (quella «scelta al buio sull'IS») ≤ **1,78%**.

### 📌 Quindi: **è meglio del DEFAULT?**
Il preset di casa (`InpEmaSlow=50`) **non è nella griglia**. I suoi due vicini a `TP1_R=0.50`:
EMA 40 → PF OOS **1,3398**, DD **5,278%**; EMA 60 → PF OOS **1,3581**, DD **4,292%**.
La mediana OOS di tutte e 40 è **1,3742**. 👉 **Il default sta dentro il rumore della griglia.**
La risposta onesta, e **è un risultato**: **sul PF il default va bene.** Sul DD alla taglia
2,00% **non va bene nessuno**, default compreso (EMA40/TP0.50 → **10,50%**).

---

# 4️⃣ 🧪 IL CONTRO-ESEMPIO CONTRO LA TESI «È IL CANDIDATO PIÙ VICINO A UNA SEDIA»

Mi è stato chiesto di costruirlo io. **Lo costruisco, e in parte REGGE.**

### 🔴 CE-1 — «Il 40/40 non sono 40 conferme: è una misura sola»
In OOS l'escursione del numero di posizioni fra le 40 celle è **12 su una mediana di 197 =
6,1%**. Le celle **condividono oltre il 94% delle operazioni**. 👉 *«40 su 40 sopra 1,20»*
è **una** misura ripetuta 40 volte con perturbazioni minime.
**REGGE.** Il numero seducente va scritto così ogni volta.

### 🔴 CE-2 — «Sull'IS il MERITO è sospeso, e nessuno l'ha detto»
`n` IS = **138–154**, mediana **145,5**. 🔴 **Solo 12 celle su 40 arrivano a 150.**
Per l'Emendamento B (16/08) **sull'IS il merito è SOSPESO**. Il walk-forward regge come test
di *rischio* e di *stabilità della regione*, **non** come conferma di merito bilaterale.
**REGGE.**

### 🔴 CE-3 — «Un regime solo, e non è colmabile»
2024.09.26 → 2026.06.30 sul Dow: **un toro**. Regola C dell'Emendamento della Finestra
(prova di regime): **NON soddisfatta**, e **NON soddisfacibile** su BCM (il broker non ha
storico prima del muro). **REGGE, ed è strutturale.**

### 🔴 CE-4 — «Il filtro che regge tutto legge candele che su FTMO non esistono»
L'edge di questo motore sta nel **filtro EMA su H4** (PF 1,03 → 1,24). La griglia H4 è
ancorata alla **mezzanotte del server**: su BCM (UTC+1) le H4 aprono alle 23-03-07-11-15-19
UTC; su FTMO (UTC+3) alle 21-01-05-09-13-17 UTC. **Sono griglie diverse.**
🔴 **Quindi il PF misurato qui non è il PF che girerebbe sul conto della challenge**, e
rimappare `InpSessionHour` **non lo sistema**.
Il rilievo **non è mio**: sta già scritto in
`mql5/Presets/FTMO/ABTG_Dow_Apertura_US_770202_FTMO.set`.
**REGGE, ed è il più grave dei cinque.** Il numero su FTMO è **[NON MISURATO]**.

### 🟡 CE-5 — «Non è una settima sedia: è la gemella di una che già opera»
`770202` opera **oggi** su FTMO su `U30USD` M5 alla stessa apertura con lo stesso filtro H4.
**Ma non è la stessa configurazione**, e l'ho verificato input per input contro il preset vivo:

| | candidato R212 | `770202` in campo |
|---|---|---|
| `InpEntryMode` | **0 = BREAKOUT** | **2 = RETEST** |
| `InpRangeMinutes` | **15** | **35** |
| `InpBufferPoints` | **200** | **1000** |
| `InpAllowShort` | **true** (due lati) | **false** (solo long) |
| `InpTP1_ClosePct` | **0** | **50** |
| `InpTP1_R` | 0,33–0,84 | **1,0** |
| `InpRiskPercent` | 1,00 | **2,00** |

🟡 **Quindi il contro-esempio non uccide: ridimensiona.** È un candidato autonomo, non un
doppione. 🔴 **Ma la CORRELAZIONE fra le due è `[NON MISURATA]`** (stesso mercato, stessa
ora, stesso filtro di trend), e il **tetto per cluster C2 non è attivo** (quattro modi, CLAUDE.md).
Non è un problema del round: è un problema di **schieramento**, e va detto insieme al PF.

### 🟢 Quello che REGGE in favore, e va detto
- `n` OOS **186–198 posizioni** (non «uscite»): **sopra il muro dei 150**, misurato.
- **OOS interamente dentro i tick veri**: nessuna finestra da giustificare.
- **Due lati accesi per costruzione**: regola del 25/08 soddisfatta senza rimaneggiamenti.
- **Frontiera del costo**: 61,9× (41,2× alla coda) contro il 40× di lavoro — 🔴 **[NON
  RIVERIFICATO DA ME]**, preso da `CANCELLO_COSTO_FLOTTA` r.400 via
  `RIESAME_MORTI_APERTURE_2026-09-22.md`.

## 🏁 Verdetto sul contro-esempio
**La tesi «è il candidato più vicino a una sedia» sopravvive come CLASSIFICA** (il campione e
la pulizia dell'OOS restano i migliori dell'archivio aperture) **ma NON come
SCHIERABILITÀ**: fra CE-4 (griglia H4 diversa su FTMO), il cancello di rischio a 2,00% e
l'assenza di prova di regime, **fra questo candidato e una sedia non c'è un round: ce ne sono
almeno tre, e uno di quelli non si può girare su BCM.**

---

# 5️⃣ 📦 IL ROUND PROPOSTO — `R212`, cinque file, tutti verdi al cancello

| file | asse (una variabile sola) | celle | passate | a cosa serve |
|---|---|---:|---:|---|
| `R212e_ancora_g1_dowbreakout_U30USD.txt` | `InpMagic` 770210 → 770220 | **2** | **4** | 🚦 **G1 determinismo** + 🎯 **ancora di regressione**. **Va girato PER PRIMO** |
| `R212a_emaslow_tp033_dowbreakout_U30USD.txt` | `InpEmaSlow` 20→200 ×20 | 10 | 20 | `InpTP1_R` = 0.33 |
| `R212b_emaslow_tp050_dowbreakout_U30USD.txt` | idem | 10 | 20 | `InpTP1_R` = 0.50 |
| `R212c_emaslow_tp067_dowbreakout_U30USD.txt` | idem | 10 | 20 | `InpTP1_R` = 0.67 |
| `R212d_emaslow_tp084_dowbreakout_U30USD.txt` | idem | 10 | 20 | `InpTP1_R` = 0.84 |
| | | **42** | **84** | |

```
$ python3 backtest_pipeline/controlla_prova.py backtest_pipeline/prove/R212*.txt
file: 5 | celle totali: 42 | passate (celle x 2 finestre): 84 | problemi: 0
ESITO: OK
```

🔴 **Sono CINQUE file e non uno**, perché `controlla_prova.py` impone **un solo asse `Y` per
file** — ed è la regola giusta. La griglia 40 celle si ricompone dai quattro file `a`-`d`.

> 🟢 **Due verifiche fatte alle 21:30, dopo che il coordinatore ha segnalato la collisione di
> sigla (classe 194):**
> 1. **`R212e` NON è un file a cella congelata e NON serve `-PermettiCellaSingola`.** Ha un
>    asse `Y` vero — `InpMagic=770210||770210||10||770220||Y` — e il cancello conta **2 celle**
>    (`|770220−770210|/10 + 1`). Le due celle sono la stessa configurazione girata due volte:
>    il magic non entra nel segnale e nel tester gira un EA solo. **È così che il G1 costa 4
>    passate invece di zero informazioni.**
> 2. **I magic `770210` e `770220` sono ancora VERGINI**, riverificati sull'intero *working
>    tree* — quindi **compresi i file non committati degli altri tre agenti** (`R214a`,
>    `R214b`, `R214c`) — e su **tutta la storia git** (`git log --all -S`): **0 occorrenze
>    ciascuno**. La sigla `R212` è rimasta a questi cinque file; gli altri sono passati a
>    `R214`.

## 5.1 🎯 L'ANCORA DI REGRESSIONE, coi suoi sei numeri

Cella **`InpEmaSlow=20` / `InpTP1_R=0.33`**, presa dai CSV grezzi:

| finestra | Profit | PF | Recovery F. | Equity DD % | Sharpe | n |
|---|---:|---:|---:|---:|---:|---:|
| **IS** | +1.045,93 | 1,26908 | 2,11290 | 4,4213 | 11,03898 | **138** |
| **OOS** | **+2.087,06** | **1,45236** | **4,48483** | **4,0996** | 18,39252 | **186** |

🔑 **Perché è un cancello e non un auspicio**: la finestra OOS del round nuovo è **identica al
giorno** a quella dell'archivio. `@DAQUANDO 2024.09.26` + `@FINOA 2026.06.30` = 642 giorni;
`walkforward_generico.ps1` r.934 fa `Meta = Inizio + floor(642 × FrazioneIS)`; con
**`@FRAZIONEIS 0.4320`** → `floor(277,34) = 277` → **Meta = 2025.06.30** ⇒
**IS 2024.09.26–2025.06.30**, **OOS 2025.07.01–2026.06.30**.
👉 Stessa finestra, stessi tick (tutti veri), stesso deposito, stesso modello:
**se l'OOS non torna, il binario è sbagliato.**

**Tolleranza congelata PRIMA**: `Trades` identico alla cifra · PF ±0,05 · `Equity DD %` ±0,5
punti · Profit ±5% · RF ±0,30. **Non bloccante** (dal 05/08 il binario è cambiato **per
volontà nostra** tre volte che possono mordere: `3af47ed9`, `ef3be41f`, `9fca63d9`): se
scarta, si scrive **di quanto** e **quale dei tre** lo spiega.
**L'unico cancello BLOCCANTE è il G1**: due celle gemelle sul magic **devono** dare numeri
identici alla cifra; se no, il banco non è deterministico e **niente** del round vale.

## 5.2 ⚠️ I due modi facili di rovinare questo round — scritti prima

1. 🔴 **La riga di lancio NON deve passare `-Deposito`.** L'archivio girò a **10.000 EUR**;
   `walkforward_generico.ps1` ha `Deposito=10000` di **default** (r.200) e `Model=4`,
   `OptimizationCriterion=6`, `Currency=EUR`, `Leverage=100`, `ExecutionMode=0`, **nessuna
   riga `Spread`** — cioè **esattamente** l'`.ini` dell'archivio (`dow_apertura.ps1`
   r.261-282). Con `-Deposito 80000` i lotti cambiano e **l'ancora non è più confrontabile**.
2. 🔴 **Niente `-Fino`, niente `-FrazioneIS`**: il driver **muore** se la riga ne dichiara uno
   diverso da quello del file (r.561-599 e r.723-742). È una guardia, non un fastidio.

*(🚦 La riga di lancio **non la scrivo io**: la scrive il coordinatore e passa dal cancello.)*

## 5.3 💰 IL COSTO, e perché è un TETTO

**Base MISURATA** (non stimata): `R202A` del 21/09 sul PC di backtest `DESKTOP-H4D7CAJ` —
stesso EA `ABTG_Dow_Apertura_US`, stesso simbolo `U30USD`, stesso TF **M5**, **modello 4**,
stessa finestra `2024.09.26–2026.06.30`: **8 passate in 2 min 41 s ⇒ ≤ 20,1 s/passata**.
Bordo alto della banda di casa: **89,6 s/passata**.

| | passate | **@20,1 s** | **@89,6 s** |
|---|---:|---:|---:|
| `R212e` (da girare per primo) | 4 | **1,3 min** | 6,0 min |
| `R212a`–`R212d` | 80 | **26,8 min** | 119,5 min |
| **TOTALE** | **84** | 🟢 **28,2 min** | 125,4 min |

🔴 **È un TETTO, non una stima centrale**, e lo dichiaro: la base fu presa a **deposito
80.000** mentre qui il deposito è **10.000**, e il tempo del tester a modello 4 dipende dal
flusso di tick, non dal deposito — ma non è misurato che siano identici.
📐 **Tetto delle 100.000 barre**: `U30USD` M5 sull'intera finestra fa **130.126** barre e
**sfonderebbe**; il walk-forward la spezza in **43,1% / 56,9% ≈ 56k e 74k**. Sotto il tetto
tutte e due. Dichiarato.

---

# 6️⃣ 🕳️ I BUCHI DICHIARATI — quelli che restano aperti anche DOPO `R212`

| # | buco | perché resta | come si chiuderebbe |
|---|---|---|---|
| 1 | 🔴 **TF mai cambiato** (punto ⑤ del certificato di morte) | `R212` è tutto M5: è il TF dell'archivio, e l'ancora esiste solo lì | file separati `@PERIODO M15` e `@PERIODO M30` a parità di cella — **4+4 passate ≈ 2,7 min** |
| 2 | 🔴 **Prova di regime assente** | un toro solo, e su BCM **non è colmabile**: niente storico prima del muro | storico esterno (HistData/Dukascopy) o un altro broker. **Costo non stimato qui** |
| 3 | 🔴 **Lato short mai isolato** | i due lati sono accesi **insieme**: quanto PF venga dai long e quanto dagli short è **[NON MISURATO]** | `InpAllowShort` ad asse a parità di cella — 4 passate |
| 4 | 🔴 **Griglia H4 diversa su FTMO** (CE-4) | l'edge sta nel filtro H4, e la griglia H4 dipende dalla mezzanotte del server | **misura a terminale FTMO acceso**: non è un backtest BCM |
| 5 | 🔴 **Correlazione con `770202`** | stesso mercato, stessa ora, stesso filtro; C2 non attivo | export per-trade delle due configurazioni + `dd_portafoglio.py` |
| 6 | 🔴 **Peggior giornata** | un CSV di ottimizzazione MT5 non ha la colonna | referto HTML per-trade sulla cella scelta |
| 7 | 🟡 **Fattore taglia 1,956–1,990** | **[NON RIVERIFICATO DA ME]** — preso dalla classe 547 | una passata gemella a `InpRiskPercent=2,0` sulla stessa cella |
| 8 | 🟡 **`3af47ed9`, `6e8c3f4c`, `8b922147`, `9fca63d9`** | **[NON VERIFICATI riga per riga]** sul nostro ramo di codice | li misura **l'ancora**, che è appunto il motivo per cui esiste |

---

# 7️⃣ 📋 COSA CHIEDO A CLAUDIO (una domanda sola, e non è tecnica)

Il punto 3.3 dice che **la cella non è la leva**: a **1,00%** va bene quasi tutta la griglia
(39/40 IS, 40/40 OOS sotto il muro); a **2,00%** non va bene nessuna in modo difendibile.
👉 **La domanda è: questo candidato lo vogliamo a 1,00% (metà del rendimento, rischio
dimostrato) o non lo vogliamo?** È un **parametro di rischio**, quindi è **firma sua**.
Io non propongo un numero: porto la tabella.

---

*Fonti primarie usate, tutte ricalcolate oggi:*
`backtest_pipeline/risultati_archivio/Dow_Apertura/dow_walkforward_{IS,OOS}.csv` ·
`backtest_pipeline/risultati_archivio/Dow_Apertura/DOW_MOTORE.md` ·
`backtest_pipeline/risultati_archivio/misura_tick/REFERTO_MISURA_TICK_{U30USD,NASUSD,D30EUR}.txt` ·
`backtest_pipeline/dow_apertura.ps1` · `backtest_pipeline/walkforward_generico.ps1` ·
`mql5/Experts/ABTG_{Dow,Nasdaq}_Apertura_US.mq5` (HEAD e commit `c5654989`) ·
`mql5/Presets/FTMO/ABTG_Dow_Apertura_US_770202_FTMO.set` ·
`backtest_pipeline/REGISTRO_TEST.md` r.2445-2455 ·
`report/RIESAME_MORTI_APERTURE_2026-09-22.md` · `report/IL_MURO_MISURATO_2026-09-22.md` ·
commit `2f4c95ae`, `eba618ba`, `3af47ed9`, `e1609a01`, `ef3be41f`, `d83c1960`, `9fca63d9`.
