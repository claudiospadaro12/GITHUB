# ❄️ IL MERITO È D'INVERNO: quanto del PF di R245 e di `770202` viene dai mesi "sfasati"

**25/09/2026** · branch `lavoro` · **SOLA LETTURA**: nessun backtest, nessun EA, preset o parametro toccato, nessuna riga
mandata al VPS o al PC di backtest, nessun terminale aperto. Taglie e rischio: di Claudio, **non toccati e non proposti**.
Script riproducibile: **`python3 backtest_pipeline/merito_inverno.py`** (~23 s) · autotest **`--autotest`** (10/10 OK).

Etichette: **[MISURATO]** = contato dai per-trade del repo · **[DERIVATO]** = calcolato da numeri misurati con una convenzione
dichiarata · **[INFERITO]** = ragionamento, non misura · **[NON MISURATO]** = buco dichiarato.

---

## 0. 🥇 La risposta in otto righe

1. ❄️ **R245 (candidato #1)**: il merito di contratto è **tutto invernale**, e il disegno **regge**. Sui due anni: estate PF
   **0,982 su 199** posizioni, inverno **1,800 su 152**; **102%** del netto viene dall'inverno. Bootstrap della differenza
   (+0,818): intervallo 95% **[+0,12 ; +1,69]**, permutazione **p = 0,018**. Il jackknife per mese **non la inverte mai**
   (0 mesi su 22). Anche **senza i 3 mesi d'inverno migliori** l'inverno resta a PF **1,421 su 99**. **[MISURATO]**
2. 🟠 **`770202` (sedia viva)**: stesso segno ma **più debole e più concentrato**. Estate **0,886 su 84**, inverno **1,493 su 68**.
   L'intervallo 95% della differenza è **[−0,42 ; +1,86]** e **contiene lo zero** (p = 0,15). Nel primo anno la differenza
   **non c'è** (A: 1,203 contro 1,231). **Togliendo 2 mesi d'inverno** (nov-2025 e gen-2025) l'inverno scende a **1,004**. **[MISURATO]**
3. 🧪 **Il contro-esempio non trova un "inverno buono per tutti"**, anzi il contrario. Quattro motori **senza orario** sullo
   stesso U30USD vanno **peggio** d'inverno: EMA200 H1 (`771521`) **2,053 → 0,868**, con intervallo **tutto sotto zero**.
   Stesso verso per AtrExhaust long e short (R109, due inverni) e per SuperWave H2. 👉 **La spaccatura non è la stagione
   "generica" del Dow.** Però il contro-esempio ha **poco potere** sulla stagione *intraday dell'apertura* (§3.3). Resta
   in piedi R246, che sul Dow dice **STAGIONE**, ma **sospeso, fragile e a n<150**. **Causa: NON DIMOSTRATA.**
4. 🔎 **Un indizio nuovo sul meccanismo di R245**: d'inverno **metà** delle posizioni (**76 su 152**) si chiude **prima delle
   15:30 BCM**, cioè **tutta nel pre-mercato** (8:30-9:30 NY). Quella metà fa PF **1,804**, uguale all'altra (1,797). Il merito
   invernale di R245 **non ha bisogno dell'apertura cash**. **[MISURATO]** sull'ora di chiusura. **[INFERITO]**: il range delle
   14:30-14:45 BCM d'inverno cade **sui dati USA delle 8:30 ET**.
5. 🔗 **Sovrapposizione per stagione**: d'estate le due sedie si muovono **più insieme** (ρ_C **0,54**), d'inverno meno
   (ρ_C **0,18**). Ma entrano insieme nell'**89-96%** dei giorni della viva **in tutte e due** le stagioni.
   🔴 **E c'è un numero nuovo**: sulla finestra A (l'IS col crollo di aprile, che R247 non vedeva) R245 perde in **12 dei 17**
   giorni in cui perde la viva (0,706 contro q95 0,529). **L'allarme di coda di R247 lì SCATTA.** È descrittivo e poggia su
   17 giorni. **[MISURATO]**
6. 🕰️ **FTMO (oggi server UTC+3, MISURATO il 20/09)**: `770202` arma alle 16:30 FTMO = **9:30 NY**, la cella **allineata**,
   quella che in backtest **perde** (0,886 su 84). **Dal 02/11** dipende da un numero **[NON MISURATO]**:
   - server **UTC+2** (calendario UE, 2 fonti su 3): **9:30 NY**, di nuovo la cella allineata;
   - server **fisso a UTC+3**: **8:30 NY**, la cella sfasata che guadagna.
   Nella settimana 26-30/10, con UTC+2, arma alle **10:30 NY**: una cella **mai misurata**. **[DERIVATO]** dalle regole di calendario.
7. 🏦 **BCM (UTC+1 fisso)**: d'inverno le due armano alle **8:30 NY**, **come il loro backtest**. Sulle BCM il contratto
   d'inverno descrive quello che faranno. **[DERIVATO]**
8. 📐 **Per R248**: **non cambia il disegno**, e conferma l'attesa scritta. La finestra vergine è tutta estate, e l'estate di
   R245 vale **PF 0,98 su 199** posizioni in casa. Un PF ~1 in R248 **non è una notizia**. R248 giudica il **rischio**;
   **il merito vive dove R248 non guarda**.

🎉 **Cosa è andato bene**: tutti i numeri di partenza si rifanno **alla cifra** da file scritti da altri, e il candidato ha un
merito invernale **largo** (regge a 3 mesi tolti), non un picco. E abbiamo trovato **prima** di schierarlo che il suo
contratto dice una cosa diversa sulle due piattaforme. A costo macchina **zero**.

---

## 1. 🚦 Controlli d'ingresso: prima si rifanno i numeri degli altri (tutti VERDI)

| ancora | scritto da | rifatto qui | esito |
|---|---|---|---|
| R245 IS `765271`: 154 deal = 154 posizioni, somma 1180,94 | R247 G0 | 154 / 154 / 1180,94 | ✅ |
| R245 OOS `765273`: 197 = 197, somma 2961,61 | R247 G0 | 197 / 197 / 2961,61 | ✅ |
| `770202` A `794603`: 74 deal, 2811,84 | R246 G2 (= IS di R47c) | 74 deal, 56 posizioni, 2811,84 | ✅ |
| `770202` B `772505`: 130 deal, 96 posizioni, 6721,93 | R246 G0 | 130 / 96 / 6721,93 | ✅ |
| `772505` sui deal: estate 73 PF 0,782, inverno 57 PF 1,662 | `OROLOGIO_BCM` §5.1.1 | 73 / 0,782 · 57 / 1,662 | ✅ |
| EMA200 `771521` sui deal: 347 PF 2,05, 170 PF 0,87 | `OROLOGIO_BCM` §5.1.1 | 347 / 2,053 · 170 / 0,868 | ✅ |
| R247 (a) sulla finestra B: ρ_U 0,160, ρ_C 0,247, C 92 | `REFERTO_R247` | 0,160 / 0,247 / 92 | ✅ |
| `770202` A+B per stagione: 0,886 su 84, 1,492 su 68 | `REFERTO_R246` §5.1 | 0,886 / 84 · 1,492 (deal) / 68 | ✅ |
| i numeri del coordinatore: OOS 0,954 su 120 · 2,126 su 77; IS 1,025 su 79 · 1,444 su 75 | coordinatore | identici | ✅ |
| calendario: `r246_bande_attese.INV` contro `r248.estate_usa` | due script | 0 giorni diversi su 668 | ✅ |

📌 Il "1,70" di `770202` citato in R248a è il PF **sui rendimenti %** (1,704), non in soldi (1,663): stessa sedia, altra unità.
Qui l'unità primaria è **PF in soldi sulle posizioni**. Accanto si stampano PF sui deal e sui rendimenti: nessuna delle
conclusioni cambia con l'unità.
⚠️ `794603` viene da R246c, **NULLO per G1** per **un centesimo** sul primo deal (−234,76 contro −234,77). Su questi numeri
l'effetto è ≤ 0,01 € e **nessun** PF cambia alla terza cifra.

---

## 2. 📊 Domanda 1: quanto del PF di contratto dipende dall'inverno

Stagione **per data di chiusura**, calendario **USA**. Con BCM a UTC+1 fisso, d'inverno le 14:30 server = **8:30 NY**. DD =
saldo chiuso **per posizione** della sola sotto-serie (rendimenti composti): **[DERIVATO]**, ed è un minorante dell'Equity DD
del tester.

### 2.1 R245, cella centrale (`ABTG_Nasdaq_Apertura_US` U30USD M5, EmaSlow 200, TP 0,50, due lati) · deposito 10.000 per tranche

| tranche | stagione | n | PF soldi | PF ret% | netto € | DD % [D] | quota netto dall'inverno |
|---|---|---:|---:|---:|---:|---:|---:|
| IS 2024.09.26-2025.06.30 | estate | 79 | **1,025** | 1,013 | +52,90 | 6,38 | |
| | inverno | 75 | **1,444** | 1,455 | +1.128,04 | 5,14 | **96%** |
| OOS 2025.07.01-2026.06.29 | estate | 120 | **0,954** | 0,941 | −150,75 | 7,00 | |
| | inverno | 77 | **2,126** | 2,129 | +3.112,36 | 4,66 | **105%** |
| **due anni** | estate | **199** | **0,982** | 0,970 | −97,85 | 7,00 | |
| | inverno | **152** | **1,800** | 1,793 | +4.240,40 | 5,14 | **102%** |

**Segmenti contigui [MISURATO]** (DD sul segmento; [D] quando attraversa la giuntura IS/OOS):

| segmento | n | PF | netto € | DD % |
|---|---:|---:|---:|---:|
| estate 30/09-01/11/2024 | 25 | 0,591 | −342,12 | 6,38 |
| ❄️ inverno 2024/25 | 75 | **1,444** | +1.128,04 | 5,14 |
| estate 2025 (11/03-31/10) | 115 | 1,015 | +44,85 | 5,78 [D] |
| ❄️ inverno 2025/26 | 77 | **2,126** | +3.112,36 | 4,66 |
| estate 2026 (09/03-29/06) | 59 | 1,131 | +199,42 | 3,62 |

👉 **Tutti e due gli inverni battono tutte e tre le estati.** Il disegno si ripete, non è un inverno solo.

### 2.2 `770202` (`ABTG_Dow_Apertura_US`, contratto R47c) · deposito 100.000 per tranche

| tranche | stagione | n | deal | PF soldi | PF ret% | netto € | DD % [D] | quota netto dall'inverno |
|---|---|---:|---:|---:|---:|---:|---:|---:|
| A 2024.09.27-2025.06.09 | estate | 26 | 33 | **1,203** | 1,200 | +740,34 | 2,28 | |
| | inverno | 30 | 41 | **1,231** | 1,242 | +2.071,50 | 4,65 | **74%** |
| B 2025.06.10-2026.06.29 | estate | 58 | 73 | **0,782** | 0,780 | −2.415,84 | 4,40 | |
| | inverno | 38 | 57 | **1,663** | 1,704 | +9.137,77 | 3,03 | **136%** |
| **due anni** | estate | **84** | 106 | **0,886** | 0,886 | −1.675,50 | 4,40 | |
| | inverno | **68** | 98 | **1,493** | 1,515 | +11.209,27 | 4,65 | **118%** |

Segmenti: estate autunno 2024 **0,104** (n 6) · ❄️ inverno 24/25 **1,231** (30) · estate 2025 **0,961** (51, [D]) · ❄️ inverno
25/26 **1,663** (38) · estate 2026 **0,951** (27).
👉 Anche qui i due inverni battono le estati vicine, ma nel **2024/25 di un soffio** (1,231 contro 1,203 della stessa tranche).

### 2.3 🎲 La differenza PF_inverno − PF_estate: bootstrap e permutazione [MISURATO]
Posizioni ricampionate **dentro** ogni stagione, seme **2509**, 10.000 repliche. Nullo per permutazione delle etichette:
10.000 permutazioni, stesso seme.

| sedia | diff. osservata | IC 90% | **IC 95%** | P(diff ≤ 0) boot | p permutazione |
|---|---:|---|---|---:|---:|
| **R245 due anni** (199 / 152) | **+0,818** | [+0,23 ; +1,54] | **[+0,12 ; +1,69]** | **0,011** | **0,018** |
| R245 solo IS (79 / 75) | +0,420 | [−0,38 ; +1,38] | [−0,54 ; +1,64] | 0,192 | 0,206 |
| R245 solo OOS (120 / 77) | +1,172 | [+0,31 ; +2,39] | [+0,15 ; +2,71] | 0,012 | 0,027 |
| **`770202` due anni** (84 / 68) | **+0,606** | [−0,24 ; +1,61] | **[−0,42 ; +1,86]** | **0,114** | **0,150** |
| `770202` solo A (26 / 30) | +0,028 | [−2,97 ; +1,65] | [−4,63 ; +2,16] | 0,511 | 0,485 |
| `770202` solo B (58 / 38) | +0,881 | [−0,13 ; +2,44] | [−0,32 ; +2,92] | 0,076 | 0,134 |

⚠️ **Onestà sul p**: la divisione estate/inverno è nata **guardando i dati** (`OROLOGIO_BCM` del 24/09 su 770202, poi R248a
su R245). Questi p sono **descrittivi**, non una conferma. Una conferma vera ha bisogno di un **inverno che nessuno ha
ancora visto** (dal 02/11/2026).

### 2.4 🔪 Jackknife per mese: togliendo un mese alla volta il disegno regge? [MISURATO]

| sedia | mesi | diff. min (mese tolto) | diff. max | diff ≤ 0 | PF inverno min | senza i 1 / 2 / 3 mesi d'inverno migliori |
|---|---:|---|---:|---:|---:|---|
| **R245** | 22 | **+0,656** (feb-2026) | +1,002 | **0 / 22** | 1,638 | **1,638** (134) · **1,539** (117) · **1,421** (99) |
| **`770202`** | 21 | **+0,366** (gen-2025) | +0,903 | **0 / 21** | 1,252 | 1,268 (60) · **1,004** (52) · **0,821** (37) |

- 🟢 **R245**: il merito invernale è **largo**. Anche senza i 3 mesi migliori (feb-26, gen-26, gen-25) l'inverno fa 1,42,
  contro 0,98 dell'estate.
- 🟠 **`770202`**: un mese tolto non basta a invertirla, ma **due mesi (nov-2025, gen-2025) la portano a pari**. Il suo
  merito invernale è **concentrato**.

### 2.5 🧪 Il contro-esempio: la stessa spaccatura su motori SENZA orario, stesso U30USD [MISURATO]

| motore (per-trade) | finestra | estate PF (n) | inverno PF (n) | diff. | IC 95% | jackknife diff ≤ 0 |
|---|---|---:|---:|---:|---|---:|
| EMA200 H1 `771521` (R31, sedia `771531`) | 2025.06.12-2026.06.26 | **2,053** (169) | **0,868** (88) | **−1,185** | **[−2,25 ; −0,35]** | 13/13 |
| AtrExhaustVol M15 LONG `774432` (R109) | 2024.09.30-2026.08.20 | 1,058 (557) | 0,852 (329) | −0,205 | [−0,48 ; +0,08] | 24/24 |
| AtrExhaustVol M15 SHORT `774442` (R109) | idem | 0,961 (581) | 0,849 (342) | −0,112 | [−0,37 ; +0,17] | 24/24 |
| SuperWave H2 `770521` (R23d) | 2025.06.19-2026.06.17 | 6,288 (22) | 1,250 (28) | −5,04 | [−25,5 ; −0,005] | 10/10 |

Per segmento, AtrExhaust copre **due inverni**:
- LONG: estati 1,105 · 0,952 · 1,228, inverni **0,759 · 0,989**;
- SHORT: estati 1,463 · 1,002 · 0,738, inverni **0,817 · 0,895**.

**Nessuno** dei quattro ha il disegno "tutti gli inverni meglio di tutte le estati".

**Che cosa dice e che cosa NON dice** (contro-esempio del contro-esempio):
- ✅ **Esclude la forma semplice di "è il mercato"**: l'inverno 2024/25-2025/26 **non** è stato buono per tutto quello che
  gira sul Dow. Per i motori di tendenza (EMA200, SuperWave) è stato **il periodo peggiore**. Se la causa fosse "d'inverno il
  Dow tira", EMA200 avrebbe dovuto guadagnare **di più**, e invece fa −1,19 con l'intervallo tutto negativo.
- ⚠️ **AtrExhaust è un fade**: se l'inverno avesse più spinta intraday, un fade andrebbe **peggio**. Il suo segno è quindi
  **compatibile con tutte e due** le spiegazioni, e **non discrimina** (classe 178).
- ❌ **Non esclude una stagione propria dell'apertura su M5**: in casa **non esiste** un motore breakout M5 senza orario sul
  Dow **[NON MISURATO]**. La prova giusta orologio-contro-stagione resta quella di R246:
  - `770202` armata a −1h d'estate (8:30 NY d'estate) fa PF **1,038 su 137**, contro 0,886 alla cash e 1,492 d'inverno.
    Q = 0,251, cioè **STAGIONE**, ma **sospeso dal G1**, **fragile** (2 prove su 289 in MISTO) e **a n<150**.
  - Sul DAX, armare prima d'estate **perde** (0,774 su 184).
  - 👉 **Per R245 quella prova non è mai girata.**
- **Sintesi onesta**:
  - **non** è la stagione generica del Dow [MISURATO, 4 motori];
  - per `770202` l'unico test diretto **pende verso la stagione dell'apertura**, [MISURATO ma sospeso];
  - per R245 la causa è **[NON MISURATO]**.

### 2.6 🔎 Due letture descrittive in più su R245 [MISURATO sull'ora di CHIUSURA; il per-trade non ha l'ora d'ingresso]

**Ora di chiusura**. D'inverno le 15:30 BCM sono **l'apertura cash**; d'estate sono **un'ora dopo** l'apertura.

| sedia | stagione | chiuse prima delle 15:30 BCM | chiuse dalle 15:30 in poi |
|---|---|---|---|
| R245 | ❄️ inverno | **n 76 · PF 1,804** · +1.697,80 | n 76 · PF 1,797 · +2.542,60 |
| R245 | estate | n 95 · PF 1,420 · +902,94 | n 104 · **PF 0,696** · −1.000,79 |
| `770202` | ❄️ inverno | n 8 · PF 0,219 · −1.591,45 | n 60 · PF 1,618 · +12.800,72 |
| `770202` | estate | n 7 · PF ∞ · +1.418,43 | n 77 · PF 0,790 · −3.093,93 |

- **R245**: d'inverno **metà delle posizioni nasce e muore nel pre-mercato** (8:30-9:30 NY) e rende **come l'altra metà**.
  D'estate a perdere sono le posizioni **lunghe**, oltre la prima ora. 👉 Il merito invernale di R245 **non** è "range sul
  pre-mercato, ingresso deciso dalla cash": è diverso dal meccanismo descritto per `r84a` (`OROLOGIO_BCM` §5.1.2).
  **[INFERITO]**: il range 14:30-14:45 BCM d'inverno cade **sulle 8:30 ET dei dati USA** (CPI, NFP, vendite). Verificarlo
  per giorno di dato è **[NON MISURATO]**: il calendario del repo è bucato proprio sull'inverno 2025/26
  (`abtg_news_2021_2025_UTC.csv` finisce a dicembre 2025 e ha 3-5 righe al mese da aprile 2025; `abtg_news.csv` ne ha 17).
- **`770202`** invece guadagna d'inverno **dopo** la cash (60 su 68). I due motori **non fanno la stessa cosa** d'inverno.

**Lati** (verso dal deal di uscita):
- R245 inverno: LONG **1,513** (109), SHORT **3,154** (43);
- R245 estate: LONG 1,180 (143), SHORT **0,671** (56);
- `770202`: solo lunghi (84 e 68).

👉 D'inverno R245 guadagna **su tutti e due i lati**. D'estate il corto perde.

### 2.7 🛡️ Il rischio per stagione (Emendamento B: il rischio si legge sempre)
- **R245**: DD della sotto-serie **7,00%** d'estate e **5,14%** d'inverno **[DERIVATO]**. Il DD massimo dell'IS (6,38%) sta
  nel **segmento estivo** di fine 2024 (25 posizioni, PF 0,591). D'estate il rischio **non** è più basso: è il
  **merito** a sparire. R248a lo aveva già visto sulle bande (p95 solo estate 7,44% contro 7,31% sull'anno).
- **`770202`**: 4,40% d'estate, 4,65% d'inverno **[DERIVATO]**. Stesso ordine.
- 📌 **Fuori domanda, ma è un fatto**: la sedia EMA200 (`771531` su FTMO) ha il suo **segmento peggiore d'inverno**, con DD
  **7,54%** sul segmento (88 posizioni, PF 0,868; un inverno solo). **[MISURATO]**

---

## 3. 🔗 Domanda 2: sovrapposizione R245 × `770202` PER STAGIONE

Metodo e funzioni di `r247_sovrapposizione.py` **importati, non copiati**. Giorni per data di chiusura, P/L% sul saldo di inizio
giornata, nullo per permutazione (2000, seme 247) **dentro la stagione**. La finestra B rifà R247 alla cifra (§1).
🔴 **Le soglie di R247a §6 sono congelate per la finestra B dell'anno.** Applicate a finestre diverse **non fanno
verdetto**: qui sono **descrittive**.

| finestra | giorni viva | C | quota viva | stesso verso | ρ_U | ρ_C | P(perde \| viva perde) (q95 nullo) | DD somma/(DDv+DDn) (q95) | allarme di coda |
|---|---:|---:|---:|---:|---:|---:|---|---|---|
| **B (= R247)** 2025.06.10-2026.06.29 | 96 | 92 | 0,958 | 91 | 0,160 | 0,247 | 0,419 (0,419) | 0,903 (0,851) | no |
| **A** 2024.09.27-2025.06.09 (col crollo) | 56 | 50 | 0,893 | — | — | 0,301 | **0,706 (0,529)**: 12 su 17 | — | 🔴 **SCATTA** |
| A+B, anno | 152 | 142 | 0,934 | 133 | 0,166 | 0,265 | **0,521 (0,417)** | 0,853 (0,902) | 🔴 SCATTA |
| A+B, **estate** | 84 | 77 | 0,917 | 70 | 0,290 | **0,539** | 0,522 (0,435) | 0,915 (0,940) | 🔴 SCATTA |
| A+B, **inverno** | 68 | 65 | 0,956 | 63 | 0,109 | **0,184** | 0,520 (0,480) | **0,971 (0,908)** | 🔴 SCATTA |

- 🔁 **Entrano insieme sempre**: 89-96% dei giorni della viva in **tutte e due** le stagioni, stesso verso in 91-99% dei
  giorni comuni. La quota **non dipende dalla stagione** (sono la stessa idea sullo stesso minuto).
- 📈 **D'estate i P/L si muovono di più insieme** (ρ_C **0,54** contro 0,18 d'inverno): perdono **insieme**, proprio nella
  stagione in cui **nessuna delle due guadagna**. **[MISURATO]**
- 🔴 **Il buco dichiarato da R247 è chiuso, e il numero non è bello**. Nell'IS col crollo (finestra A) R245 perde in **12 dei
  17** giorni in cui perde la viva: 0,706, contro 0,529 del nullo al q95. **È un'osservazione su 17 giorni**, e non un verdetto:
  il criterio non era congelato per quella finestra. **[MISURATO]**
- Peggior giornata della somma (1% + 1%, additivo **[DERIVATO]**):
  - A+B: −2,09%, rapporto 1,746 (q95 1,832);
  - inverno: −2,07%, rapporto 1,856 (q95 1,902).
  Nessuno dei due sopra il nullo.

---

## 4. 🕰️ Domanda 3: a che ora di New York arma ciascuna, BCM e FTMO

Orari dei preset:
- `770202` su FTMO: `InpSessionHour=16:30` (`mql5/Presets/FTMO/ABTG_Dow_Apertura_US_770202_FTMO.set`; in campo lo conferma
  `report/PERCHE_LE_SEDIE_NON_SPARANO_2026-09-24.md` r.112).
- `770202` su BCM: 14:30.
- R245: 14:30 BCM (R247b). Su FTMO **nessun preset**: con la rimappatura di casa `+2` sarebbe **16:30 [INFERITO]**.

Offset dei server:
- FTMO oggi **UTC+3**: `DeltaServerGMT +03:00`, 20/09, terminale `541452707` (`IL_CONFINE_DEL_GIORNO` §3.1) **[MISURATO]**.
- BCM **UTC+1 fisso** (`OROLOGIO_BCM`) **[MISURATO]** fino all'inverno 2025/26.
- FTMO dal 25/10: **[NON MISURATO]**. Il repo ha **due** letture incompatibili (`IL_CONFINE_DEL_GIORNO` §3.3).

Ore calcolate da `ora_ny()` (autotest T7/T8) **[DERIVATO]**:

| periodo | BCM 14:30 (UTC+1) | FTMO 16:30 se **UTC+2** d'inverno (calendario UE) | FTMO 16:30 se **fisso UTC+3** |
|---|---|---|---|
| oggi → 23/10 | 9:30 NY · allineata | 9:30 NY (oggi è UTC+3, **misurato**) | 9:30 NY |
| **26-30/10** (UE solare, USA legale) | 9:30 · allineata | **10:30 NY** · 🔴 cella **mai misurata** | 9:30 · allineata |
| **dal 02/11** (inverno USA) | **8:30 NY** · 🟢 **sfasata = come il backtest** | **9:30 NY** · 🔴 **allineata = la cella che perde** | **8:30 NY** · sfasata = come il backtest |

Che cosa vale ogni cella, dai numeri di §2 **[MISURATO]**:

| cella | `770202` | R245 |
|---|---|---|
| **allineata** (9:30 NY) | PF **0,886** su 84 | PF **0,982** su 199 |
| **sfasata** (8:30 NY) | PF **1,493** su 68 | PF **1,800** su 152 |

La cella **d'inverno alla cash**, cioè FTMO con UTC+2, **non è mai stata misurata** né per `770202` (R246m-r, file scritti
e non girati) né per R245 (nessun file). Quello che ci si aspetta lì è **[INFERITO]**:
- se la causa è **stagione**, circa PF invernale;
- se è **orologio**, circa PF estivo.

📌 **FTMO porta anche un secondo scarto che l'ora non risolve**: la griglia H4 del filtro EMA. BCM e FTMO distano 2h
d'estate e 1h d'inverno con UTC+2. Vale per tutte e due le celle (R248a, buco 7).

---

## 5. 👉 Che cosa cambia per R248 (e che cosa no)

- **Il disegno non cambia**: R248 è una finestra **tutta estiva**, di circa 41 posizioni, e giudica il **RISCHIO** con bande
  già congelate. Il rischio **non** dipende dalla stagione (§2.7). Le bande restano valide.
- **L'attesa di R248a ("PF vicino a 1") è confermata dai numeri di casa**:
  - estate R245 **0,982 su 199** sui due anni;
  - estate OOS **0,954 su 120**;
  - stessa finestra di calendario un anno prima: 1,04 (R248a).
  👉 **Un PF sotto 1 in R248 ripete il contratto, non lo smentisce. Un PF alto non lo conferma.**
- 🔴 **Quello che R248 NON può dire, e ora si sa quanto pesa**: **il 102% del netto di contratto di R245 è invernale**, e R248
  non vede inverno. **Per "sostituire o affiancare" il numero che manca non è in R248**:
  - la **casella orologio-contro-stagione** di R245 (R246 a −1h d'estate, mai girata per questo EA);
  - la **casella d'inverno alla cash** (d+1), cioè quello che farebbe su FTMO con UTC+2.
  Sono corse da **PC di backtest**, dell'ordine dei minuti (tempi di R248a §10: circa 17 s per passata-anno). Si scrivono
  e si passano ai cancelli **prima**.

---

## 6. 🙋 Le domande per Claudio (nessuna taglia, nessuno spegnimento proposto)

1. 🕰️ **Il contratto d'inverno di una sedia d'apertura è "armare alle 8:30 NY" o "armare alla cash"?** Su BCM le due cose sono
   diverse da novembre, e il **backtest ha misurato la prima**. È la domanda del 25/10, e decide quale numero di contratto usare.
2. 📞 **L'offset FTMO d'inverno**: la lettura di `TimeTradeServer()−TimeGMT()` sul terminale **`541452707` (`C:\FTMO`)** il
   **26/10**, oppure la domanda scritta al supporto FTMO. Da quel solo numero dipende se su FTMO `770202` (e un'eventuale R245)
   d'inverno arma sulla cella **che guadagna** o su quella **che perde**.
3. 🧪 **Vuoi le due caselle mancanti di R245 prima di scegliere fra sostituire e affiancare?** Cioè −1h d'estate
   (orologio contro stagione) e +1h d'inverno (alla cash). Costo: minuti di PC di backtest, file prova da scrivere e passare ai
   cancelli.
4. 🔗 **L'allarme di coda nella finestra A (12 giorni su 17)**: vuoi che il criterio di R247 venga **congelato anche per
   l'IS** e rigiudicato? Oggi è una lettura descrittiva, non un verdetto.
5. ⚖️ **Il G1 di R246** (il centesimo, strade a/b/c di `REFERTO_R246` §1.5) è ancora aperto. Il verdetto "STAGIONE" di
   `770202`, l'unico test diretto della causa, **resta sospeso finché non decidi tu**.

---

## 7. 🧭 Ponteggio o sedia?

**Misura di decisione, non ponteggio puro**:
- **non** crea una sedia;
- cambia **cosa va misurato prima di schierarla**, e mostra che lo stesso contratto vale cose diverse su BCM e su FTMO da
  novembre;
- quantifica la dipendenza invernale di R245 (larga) e di `770202` (concentrata) con intervalli e jackknife.

Costo macchina: **zero**. Il prossimo passo che **avvicina davvero** una sedia sono le due caselle del §5, e quelle girano sul
PC di backtest.

---

## 8. 🪦 Che cosa questo referto NON misura

1. **La causa** (orologio o stagione) per R245: **[NON MISURATO]**. Per `770202` c'è solo R246: sospeso, fragile, n<150.
2. **La cella d'inverno alla cash**, cioè FTMO con UTC+2: **[NON MISURATO]** per tutte e due.
3. **L'offset FTMO dal 25/10**: **[NON MISURATO]**.
4. **Il ruolo dei dati USA delle 8:30** nel merito invernale di R245: **[INFERITO]**. Il calendario del repo è bucato
   sull'inverno 2025/26.
5. **Un solo regime** (toro 2024-2026 col crollo di aprile), **due** inverni, **un** broker (feed BCM): l'Emendamento C
   non è soddisfatto.
6. **I p-value** sono su un'ipotesi nata dai dati: **descrittivi**.
7. **DD per stagione**: calcolato per posizione sul saldo chiuso della sotto-serie, quindi **minorante** del DD del tester
   **[DERIVATO]**.

---
_Riproduzione: `python3 backtest_pipeline/merito_inverno.py` (esce 1 se un'ancora non torna) · autotest 10/10:
- calendario;
- formula del PF;
- nullo (PF uguali → l'IC contiene 0);
- differenza piantata (0,95 contro 2,1 → l'IC esclude 0);
- permutazione sotto nullo e alternativa;
- mese outlier che il jackknife deve scoprire;
- ora NY per BCM e FTMO nei tre casi;
- DD composto;
- ancora spostata di un centesimo → ROSSO._
