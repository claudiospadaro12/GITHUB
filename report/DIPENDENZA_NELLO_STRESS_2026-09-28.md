# 🧯 La dipendenza nelle giornate di stress — il punto 2 di Emiliano, misurato (28/09/2026)

Nasce dal punto 2 del parere di Emiliano (`docs/PARERE_EMILIANO_2026-09-28.md`): *"le correlazioni giornaliere vicine
allo zero non bastano: controlla la dipendenza condizionale nelle giornate di stress (apertura USA, shock macro,
volatilita' estrema, piu' EA sullo stesso indice che ricevono segnali insieme)"*.

Misura di **SOLA LETTURA**, costo macchina zero (CPU su dati gia' in repo). Nessuna proposta di taglia, di soglia del
Guardian o di sedia: sono firme di Claudio.

## §0. ⚡ In breve (scritto DOPO i numeri; i criteri del §1 sono stati committati prima, `20b05a43`)

1. 🟢 **Nessuna coppia delle 4 sedie con per-trade e' LEGATA** al criterio congelato, su nessun insieme leggibile. Le
   piu' vicine: `770101`×`771531` (lift 1,66, Fisher p **0,0526**) e `770202`×`771531` nelle 22 giornate in cui
   operano insieme (lift 1,57, p **0,0588**). [MISURATO]
2. 🔴 **"Lo stress le lega di piu'" non si puo' dire ne' si' ne' no**: (b-US) ha 10 giornate, (c) come scritta e'
   [NON MISURATO], (a) ha 28 giornate ma **non separa** (flag vero sull'89% dei feriali del tratto completo, classe
   862), la sua parte NFP/CPI/Fed ne ha 14. Il "no" delle celle leggibili e' assenza di prova, non prova d'assenza.
3. 🔴 **Il legame che c'e' passa dal CALENDARIO, non dagli esiti** — ed e' il punto di Emiliano: `770101`×`770105`
   perdono insieme piu' del caso (lift 1,66, p **0,020**) perche' operano **le stesse mattine** (coop lift **0,99** su
   127 giornate); idem `771531`×proxy SuperWave (lift 4,07, p 0,0034; coop 0,98). Una correlazione degli esiti non
   lo vede.
4. 🔴 **La coda del portafoglio al 2%, senza Guardian e senza C1** [MISURATO sul realizzato]: 4 sedie, 277 giornate:
   peggiore **6,87%**, p99 **4,76%**, **11** giornate sopra 3,5% e **4** sopra 4,5%. Con la `770105` (finestra B):
   peggiore **8,35%**, p95 **4,02%**, **19** e **7**. Nelle 22 giornate in cui `770202` e `771531` operano insieme
   cadono 4 delle 11 e 2 delle 4 (18% e 9% contro 4,0% e 1,4%).
5. 🔴 **Quanto di quella coda il Guardian avrebbe fermato e' [NON MISURATO]**: il per-trade scrive solo le uscite.
   Mancano del tutto `770260` (Nasdaq), `770511` vera e `770212`: su G i numeri sono un **pavimento**.

---

## §1. 🧊 I CRITERI, CONGELATI PRIMA DEI NUMERI

Scritti e committati **prima** di far girare lo script sulle sedie. Ogni numero del §3 in poi si legge contro queste
righe, e solo contro queste.

### §1.1 Le sedie, e quali hanno un per-trade (la stessa base del Monte Carlo)

Fonte dei per-trade: **gli stessi file che carica `backtest_pipeline/mc_challenge_ftmo_v2.py`** (`SORGENTI_V2`, letti
con la sua `carica_v2()`, importata e non modificata), cosi' la misura e' coerente col Monte Carlo del 27/09.

| sedia FTMO `541452707` al 28/09 | per-trade usato | stato nella misura |
|---|---|---|
| `770101` DAX long M5 | `risultati_prove/aperture_r47/..._772501.csv` (100k, 1%) | [MISURATO] |
| `770202` Dow long M5 | `risultati_prove/aperture_r47/..._772505.csv` (100k, 1%) | [MISURATO] |
| `770411` MaxMinNotte DAX short M15 | `risultati_prove/trades_portafoglio/..._770413.csv` (100k, 1%) | [MISURATO] |
| `771531` EMA200 Dow H1 L+S | `risultati_prove/trades_candidati_r23/..._771521.csv` (100k, 1%) | [MISURATO] |
| `770260` Nasdaq L+S M5 | **nessuno** (il MC la dichiara gia' `[NON MODELLATA]`; i per-trade `ABTG_Nasdaq_Apertura_US` in repo girano su **U30USD**, non su NASUSD: non sono questa sedia) | 🔴 **[NON MISURATO]** |
| `770511` SuperWave Dow H1 L+S | **nessuno della cella**. In repo c'e' `770521` = `ABTG_SuperWave` **H2**, cella R23d, 100k, rischio di default **1,0% letto a HEAD** (non verificato alla data del round) | 🔴 **[NON MISURATO]**; `770521` entra **solo** come PROXY etichettato `[DERIVATO]` nelle righe di sensibilita' |
| `770212` Dow short (in firma) | nessuno in repo (R255 non arrivato; il MC la dichiara `[NON MODELLATA]`) | 🔴 **[NON MISURATO]** |
| `770105` DAX short (fuori dall'elenco CODA_01 del 28/09, ma `loaded` il 25/09 20:47 nel giornale FTMO: `NOTTE_2026-09-26.md`) | `risultati_archivio/R251/PERTRADE/..._792520.csv` (10k, 1%), solo 2025.07.01 → 2026.06.29 | riga di **sensibilita'** sulla finestra B, come nel MC |

### §1.2 L'universo e le unita'

- **Universo U = calendario A del MC**: `calendario(dati, V1)` = feriali dal 2025.06.10 al 2026.06.29 + giornate con
  operazioni (277 giornate). Sensibilita' con la `770105`: **calendario B** del MC (2025.07.01 → 2026.06.29, 262).
- **Giornata di una sedia** = somma dei deal chiusi in quella data (colonna `close_time`, ora BCM), come `carica_v2()`.
  Sedia **in perdita nel giorno** = quella somma < 0. Sedia **che ha operato** = almeno un deal chiuso in quella data.
- **% al 2%** = netto / deposito di misura × 2 × 100 (fattore 2,0 del MC: misura all'1% portata al 2,00% di campo).
- 🔴 **Il per-trade ha SOLO le uscite** (`close_time`, nessun orario di apertura): gli orari di apertura non si
  ricostruiscono, quindi **il cap C1 al 4,00% NON si simula**. Si dichiara cosi', e vale per tutto il §3-§5:
  - **netto di giornata N_d** (somma dei deal chiusi quel giorno): rispetto al C1 **ne' tetto ne' pavimento** — il C1
    toglie posizioni, e togliere una posizione vincente peggiora il netto, togliere una perdente lo migliora;
  - **lordo di giornata G_d** (somma dei soli deal in perdita chiusi quel giorno): rispetto al C1 e' un **TETTO**
    (il C1 puo' solo togliere deal); rispetto alle sedie mancanti (`770260`, `770511`, `770212`) e' un **PAVIMENTO**
    (aggiungere una sedia puo' solo aggiungere deal in perdita);
  - rispetto al **muro giornaliero FTMO**, che conta l'equity **con il flottante**, nessuno dei due e' un limite: il
    per-trade non vede il percorso dentro la giornata ne' il flottante delle posizioni che scavalcano la mezzanotte.
    Stesso limite del MC (`mc_challenge_ftmo.py`, limite 2: *"P/L REALIZZATO, non equity"*).
  - la pausa del Guardian (3,5%) **non** e' applicata: si CONTANO le giornate che la supererebbero, non si tagliano.

### §1.3 Le tre definizioni di STRESS (congelate)

**(a) Dato USA ad alto impatto.** Righe `Impatto=High`, `Valuta=USD` di `mql5/Files/abtg_news_2021_2025_UTC.csv`,
a **grana di GIORNO** (la data della riga). Classe 862, applicata: prima di usarlo si stampano i **buchi** (distanza
fra eventi USD consecutivi) e si usa **solo il tratto dove il file e' completo**. Dentro U il file e' completo solo dal
2025.06.10 al **2025.07.03**; dopo restano **solo le decisioni Fed**. Quindi l'insieme (a) e', per nome:
  - (a1) tutte le giornate USD High del file fra 2025.06.10 e 2025.07.03;
  - (a2) le righe `Fed Interest Rate Decision` del file dopo il 2025.07.03;
  - (a3) le righe USD High di `mql5/Files/abtg_news.csv` (2026; orologio del file non verificato, irrilevante a grana
    di giorno: nessun evento cade vicino alla mezzanotte).
  L'insieme si **elenca per nome** nel referto (classe 180): non si usa MAI il suo complemento ("giornate senza
  news"), perche' fuori dal tratto completo "senza news" vuol dire "file bucato" (classe 862 (b)). Il confronto e'
  **STRESS contro TUTTE**. Lo spostamento UTC-1 del file dal 2025.03.30 (classe 862 (c)) **non tocca la data**:
  gli eventi USD dei due file dentro U cadono fra le 11:15 e le 20:00 (lo script lo stampa), lontani dalla
  mezzanotte in ogni orologio in gioco.
  La grana di giorno e' quella giusta **per questa domanda** (il muro FTMO e' giornaliero), non per dire "lo stop lo
  fa il dato" (che vivrebbe nei minuti, classe 862 (a)): quella frase qui NON si dice.

**(b) Volatilita' estrema.** Il range giornaliero dell'indice richiederebbe un archivio prezzi giornaliero di
U30USD/NASUSD/D30EUR sulla finestra U: **in repo non c'e'** (cercato: `studio_apertura/` non ha date, `r91_csv/` ha
due giornate M1 isolate). Quindi **(b) come scritta = [NON MISURATO]**. PROXY dichiarato, e NON circolare (si decide
all'ingresso, non dall'esito):
  - lo stop delle sedie d'apertura e' sul **range d'apertura** (`ABTG_Dow_Apertura_US.mq5` r.282 `InpSLMode =
    ABTG_SL_RANGE`, floor r.313), e il lotto e' dimensionato sul saldo: **stop ∝ saldo / volume della posizione**.
    Saldo = 100.000 + netto cumulato delle posizioni della sedia chiuse prima; volume = somma dei volumi dei deal
    d'uscita della posizione; per giornata il massimo.
  - **(b-US)** = le `ceil(n/10)` giornate col proxy piu' alto fra le n giornate in cui `770202` ha operato
    ("volatilita' all'apertura USA", non "range giornaliero"); **(b-DAX)** = idem su `770101` ("apertura DAX").
  - Limiti dichiarati: vede solo le giornate in cui la sedia ha operato; sul Dow il cambio EURUSD sposta il proxy di
    qualche punto percentuale nell'anno; il floor dello stop satura il fondo, non la cima.

**(c) Almeno 3 sedie USA che hanno operato nello stesso giorno.** Le sedie USA in campo sono quattro (`770202`,
`770260`, `771531`, `770511`); con per-trade misurato ce ne sono **due**. Quindi **(c) come scritta = [NON
MISURATO]**. Si calcolano accanto, etichettati:
  - **(c2) [MISURATO]**: giornate in cui `770202` **e** `771531` hanno operato (>=2, non >=3: e' un sostituto piu'
    debole, e si dice);
  - **(c3) [DERIVATO, proxy]**: giornate in cui `770202`, `771531` **e** il proxy `770521` hanno operato.

### §1.4 Le misure e le soglie di lettura

**Domanda 1 — co-perdita per coppia**, su ogni insieme S (TUTTE = U; poi a, b-US, b-DAX, c2, c3):
- n = giornate di S; pA, pB = frazione di giornate di S in cui la sedia e' in perdita; pAB = frazione in cui lo sono
  **tutte e due**; **lift = pAB / (pA × pB)** (1 = indipendenti; > 1 = perdono insieme piu' del caso);
- **p di Fisher** a una coda (ipergeometrica: co-perdite >= osservate date le marginali dentro S);
- accanto, la versione **"solo giornate in cui operano entrambe"** (n2 = co-operative in S): separa il legame
  degli ESITI dal semplice fatto di operare insieme;
- 🔴 **n < 20 giornate (o n2 < 20 per la versione accanto) = NON LEGGIBILE**, e al posto del numero si scrive la
  parola. Se pA o pB = 0 in S: **NON DEFINITO**.
- Verdetto per coppia e insieme: **LEGATE** se leggibile, lift > 1 e Fisher p < 0,05; **NESSUN LEGAME MISURABILE**
  se leggibile e p >= 0,05; altrimenti NON LEGGIBILE / NON DEFINITO.
- **"Lo stress le lega di piu'"** (per coppia e insieme S): S leggibile **e** lift_S > lift_TUTTE **e** p di
  permutazione < 0,05, dove la permutazione estrae 10.000 sottoinsiemi casuali di U della stessa taglia di S
  (seme 20260928) e conta la frazione con **co-perdite >= quelle di S**. Per (c2)/(c3) il conteggio e' gonfiato per
  costruzione (le sedie operano per definizione): li' vale solo il lift nella versione "operano entrambe", e il test
  di permutazione si estrae fra le giornate co-operative di U.

**Domanda 2 — perdita del portafoglio nel giorno**, sulle 4 sedie misurate al 2,00% (poi la sensibilita'):
- per ogni S: n, peggior giornata, p95, p99 di **L_d = −N_d** (netto) e di **G_d** (lordo), in % del saldo;
  quante giornate con L_d > **3,5%** (pausa del Guardian) e > **4,5%** (taglio giornaliero), idem per G_d;
- percentili a rango piu' vicino su tutte le giornate di S (zeri compresi); 🔴 **il p99 si stampa solo con n >= 100**,
  sotto e' "= massimo osservato", non un p99; **n < 20 = NON LEGGIBILE**.

**Domanda 3 — le tre sedie Dow** (`770202`, `771531`, `770511`): con i dati misurati e' la **coppia** `770202` ×
`771531` (giornate con 2 in perdita, su U e sugli insiemi di stress, criteri della domanda 1). Il **tris** con
`770521` al posto di `770511` e' `[DERIVATO, proxy]`: giornate con 2 o 3 in perdita, stesse soglie.

**Sensibilita' congelate**: (s1) finestra B con `770105` (5 sedie); (s2) + proxy `770521` (per la domanda 2 alla
taglia 2% assumendo misura all'1% = default a HEAD, `[DERIVATO]`).

**Contro-esempio prima della consegna** (regola del 10/09): lo script ha un `--autotest` con serie sintetiche a
dipendenza NOTA — due serie identiche (lift = 1/pA, Fisher ~0), due serie indipendenti (lift ~1, Fisher non
significativo), una coppia indipendente fuori dallo stress e identica dentro (lo strumento deve dire "lo stress le
lega di piu'"), e il suo **placebo** (etichetta di stress a caso: non deve dirlo); piu' la soglia n < 20 e i conteggi
della domanda 2 fatti a mano. Se l'autotest fallisce, i numeri non si leggono.

---

## §2. 🧪 IL CONTRO-ESEMPIO, PRIMA DEI NUMERI (regola del 10/09)

Script: **`backtest_pipeline/dipendenza_stress.py`** (ASCII puro, rieseguibile). Autotest:
`python3 backtest_pipeline/dipendenza_stress.py --autotest` → **PASS, 9 controlli su 9**:

| # | caso costruito a dipendenza NOTA | cosa deve dire | cosa dice |
|---|---|---|---|
| i | due serie **identiche** (3.000 giornate) | lift = 1/pA, Fisher ~0, LEGATE | x = K = M = 1054, lift **2,846 = 1/pA**, Fisher 0, **LEGATE** ✅ |
| ii | due serie **indipendenti** (200 semi, n 400) | lift ~1, LEGATE in ~5% dei semi | lift medio **0,994**, LEGATE **8/200 = 4%** ✅ |
| iii | indipendenti fuori, **identiche dentro** uno stress di 60 giornate su 600 | "lo stress le lega di piu' = SI" | lift_S **2,00** contro TUTTE **1,13**, permutazione **0,0008** → **SI** ✅ |
| iii-placebo | stesse serie, etichetta di stress **a caso** fuori dallo stress vero | NON deve dire SI | lift_S 1,08, permutazione 0,161 → **NO** ✅ |
| iv | soglia di lettura | 19 → NON LEGGIBILE, 20 → leggibile | ✅ |
| v | Fisher contro un conto a mano (n 4, K 2, M 2, x 2 = 1/6) | 0,166667 | **0,166667** ✅ |
| vi | domanda 2 a mano: −1000/+300 e −1000/−1200 su 100k al 2% | L = 1,4 / 4,4; G = 2,0 / 4,4 | ✅ |
| vii | percentile a rango su 1..100; p99 nascosto sotto n 100 | 95 / 99 / nascosto | ✅ |
| viii | proxy dello stop: 0,01 × saldo / volume, saldo aggiornato, partial sommati | 100 e 198 | ✅ |
| ix | dati veri: netto per giornata ricalcolato dai deal **==** `carica_v2()` del MC, 5 sedie; calendari 277 / 262 | coincide | ✅ (se no lo script si ferma) |

**Riscontro contro numeri scritti da altri** (il MC, non io): le co-perdite per coppia sull'universo A
(**5 / 1 / 10 / 6 / 2**) e le giornate con >=2 sedie in perdita (**21**) coincidono con `correlazione()` di
`mc_challenge_ftmo_v2.py` sullo stesso calendario; le **22** giornate comuni `770202`×`771531` sono le stesse del
**ρ +0,62** di `MC_CON_ORO_E_BLOCCHI_2026-09-27.md`.

---

## §3. 🗓️ GLI INSIEMI DI STRESS, PER NOME E PER NUMERO [MISURATO]

Universo A: **277 giornate** (2025.06.10 → 2026.06.29). Giornate con operazioni / in perdita: `770101` 193/49 ·
`770202` 96/31 · `770411` **14**/6 · `771531` 102/34 · (`770105` 181/48 in B) · (proxy `770521` 35/10).

| insieme | n in A | come e' fatto | nota |
|---|---|---|---|
| **(a) news** | **28** | a1 **16** giornate (2025.06.10 → 07.03, il tratto completo) + a2 **4** Fed (2025.07.30, 09.17, 10.29, 12.10) + a3 **8** dal file 2026 (01.07, 01.09, 01.14, 01.28, 02.06, 02.11, 03.06, 03.18) | 🔴 **classe 862 (1)**: nel tratto completo il flag e' vero su **16 feriali su 18 (89%)** = **non separa**. Solo NFP/CPI/Fed (a-T1, contato **dopo** la prima corsa, nessun verdetto): **14 giornate = NON LEGGIBILE** |
| buchi del file (dal 2024.09, > 6 gg) | — | 2024.11.15→12.18 (33), 12.18→2025.01.02 (15), **2025.07.03→07.30 (27), →09.17 (49), →10.29 (42), →12.10 (42)** | ore degli eventi in U fra **11:15 e 20:00**: nessuno vicino alla mezzanotte |
| **(b-US)** proxy | **10** | decile alto del proxy dello stop di `770202` (96 giornate) | 🔴 **NON LEGGIBILE** per costruzione |
| **(b-DAX)** proxy | **20** | decile alto del proxy di `770101` (193 giornate → `ceil` 20) | leggibile **sul filo** (20 esatte; 18 in B) |
| **(c)** >=3 sedie USA | — | due sole sedie USA con per-trade | 🔴 **[NON MISURATO]** |
| **(c2)** | **22** | `770202` **e** `771531` hanno operato | [MISURATO], sostituto piu' debole |
| **(c3)** proxy | **5** | + `770521` | 🔴 NON LEGGIBILE |

---

## §4. 📊 DOMANDA 1 — la co-perdita per coppia [MISURATO sulle 4 sedie; proxy DERIVATO]

Formato: **lift** (Fisher) · stato. "coop" = solo giornate in cui operano entrambe. Tabella completa (tutte le celle,
comprese le illeggibili) nell'uscita dello script; qui ogni coppia per insieme.

| coppia | TUTTE (n 277) | TUTTE coop | (a) news n 28 | (b-DAX) n 20 | (c2) n 22 | lo stress le lega di piu'? |
|---|---|---|---|---|---|---|
| `770101`×`770202` | 0,91 (0,68) · nessun legame | 1,10 (0,50) n 74 | 1,87 (0,46) · nessun legame | NON DEFINITO (`770202` 0 perdite) | 1,10 (0,59) · nessun legame | **NO** in (a); non leggibile/definito altrove |
| `770101`×`770411` | 0,94 (0,69) | NON LEGG. (n 9) | NON DEFINITO | 0,00 (1,00) | 0,00 (1,00) | **NO** |
| `770101`×`771531` | **1,66 (0,0526)** · nessun legame | 1,33 (0,15) n 73 | 5,60 (0,18) su **1** co-perdita | 0,00 (1,00) | 1,26 (0,52) | **NO** (perm. 0,66 in (a)) |
| `770202`×`770411` | 1,49 (0,51) | NON LEGG. (n 3) | NON DEFINITO | NON DEFINITO | 1,83 (0,55) | non leggibile/definito |
| `770202`×`771531` | 1,58 (0,16) | **1,57 (0,0588)** n 22 | 0,00 (1,00) | NON DEFINITO | **1,57 (0,0588)** · nessun legame | **NO** in (a); c2 = riferimento coop |
| `770411`×`771531` | 2,72 (0,16) su **2** co-perdite | NON LEGG. (n 9) | NON DEFINITO | 0,00 (1,00) | 3,14 (0,32) su 1 | **NO** |

**Verdetto contro i criteri del §1.4:**
- ✅ **Nessuna coppia delle 4 sedie misurate e' LEGATA**, ne' su TUTTE ne' su un insieme di stress leggibile. Le due
  piu' vicine alla soglia sono **`770101`×`771531`** (lift 1,66, p **0,0526**) e **`770202`×`771531` quando operano
  insieme** (lift 1,57, p **0,0588**, n 22). 🔴 "Nessun legame misurabile" **non e' "indipendenti"**: su 22 giornate
  un lift di 1,57 non si distingue dal caso, e il ρ del MC sulle stesse 22 e' **+0,62**. Si scrive col suo n.
- 🔴 **"Lo stress le lega di piu'" non risulta MAI SI** — ma perche' quasi tutte le celle di stress sono **NON
  LEGGIBILI o NON DEFINITE**, non perche' sia stato dimostrato il contrario. (a) e' leggibile per n ma **non separa**
  (classe 862); (b-US) ha 10 giornate; (b-DAX) ne ha 20 esatte e `770202` in quelle non perde mai.
- 🟠 **Dove un legame c'e', viene dall'OPERARE insieme, non dall'ESITO** — ed e' esattamente il punto di Emiliano:
  - `771531`×proxy `770521` [DERIVATO]: **LEGATE** su TUTTE (lift **4,07**, p **0,0034**), ma fra le giornate in cui
    operano entrambe il lift e' **0,98** (n 11, non leggibile): i due motori di tendenza sul Dow **scelgono le stesse
    giornate**;
  - `770101`×`770105` (finestra B): **LEGATE** su TUTTE B (lift **1,66**, p **0,020**), ma coop lift **0,99** (p 0,61,
    n **127**): DAX long e DAX short all'apertura **operano le stesse mattine** (127 su 181), e quando operano insieme
    perdono insieme esattamente quanto il caso prevede. Una correlazione "sugli esiti" vicina allo zero **non vede**
    questo legame, perche' sta nel calendario.

---

## §5. 💥 DOMANDA 2 — la perdita del portafoglio nel giorno [MISURATO; al 2%, SENZA C1 ne' Guardian applicati]

In % del saldo, alla taglia 2,00%. **N** = netto realizzato (ne' tetto ne' pavimento rispetto al C1); **G** = lordo
dei deal in perdita (TETTO rispetto al C1, PAVIMENTO rispetto alle sedie mancanti). Nessuno dei due vede il flottante.

| portafoglio · insieme | n | peggiore N / G | p95 N / G | p99 N / G | giornate N > 3,5 / > 4,5 | G > 3,5 / > 4,5 |
|---|---|---|---|---|---|---|
| **4 sedie · TUTTE A** | 277 | **6,87 / 6,87** | 2,46 / 4,28 | **4,76 / 6,42** | **11 / 4** | 17 / 7 |
| 4 sedie · (a) news | 28 | 4,46 / 4,46 | 2,18 / 2,70 | = max | 1 / 0 | 1 / 0 |
| 4 sedie · (b-US) | 10 | NON LEGGIBILE | | | | |
| 4 sedie · (b-DAX) | 20 | 2,44 / 2,44 | 2,39 / 2,43 | = max | 0 / 0 | 0 / 0 |
| 4 sedie · **(c2)** | 22 | **6,87 / 6,87** | **6,33 / 6,59** | = max | **4 / 2** | 7 / 3 |
| 4 sedie · TUTTE **B** (riferimento) | 262 | 6,87 / 6,87 | 2,46 / 4,28 | 4,76 / 6,42 | 11 / 4 | 17 / 7 |
| **4 sedie + `770105` · TUTTE B** | 262 | **8,35 / 8,43** | **4,02 / 4,32** | **6,33 / 6,87** | **19 / 7** | **30 / 11** |
| 4 + `770105` · (a) / (b-US) / (b-DAX) in B | 15 / 10 / 18 | NON LEGGIBILE | | | | |
| 4 sedie + proxy `770521` · TUTTE A [DERIVATO] | 277 | 8,37 / 8,90 | 2,50 / 4,28 | 6,09 / 6,59 | 12 / 5 | 18 / 8 |
| 4 + proxy · (c2) [DERIVATO] | 22 | 8,37 / 8,90 | 7,55 / 7,64 | = max | 4 / 2 | 7 / 3 |

**Letture:**
- 🔴 **Il rischio di coda sta dove piu' sedie OPERANO nello stesso giorno, non (dimostrabilmente) nei giorni di
  news.** Nelle 22 giornate (c2) cadono **4 delle 11** giornate sopra la pausa e **2 delle 4** sopra 4,5%: frequenza
  **18% e 9%** contro **4,0% e 1,4%** su TUTTE. Sulle news (a): 1 su 28 (3,6%), in linea con TUTTE. La regola di
  casa vale qui a rovescio: **un DD accaduto vale a qualunque n** — le due giornate da 6,87 e 6,33 sono **fatti**.
- 🔴 **La `770105` (attaccata il 25/09, fuori dall'elenco CODA_01 per la classe 822) e' la sedia che sposta di piu' la
  coda**: sulla stessa finestra B le giornate nette sopra la pausa passano da **11 a 19**, sopra 4,5% da **4 a 7**, il
  p95 da **2,46 a 4,02**. Il motivo e' misurato al §4: opera **le stesse mattine** della `770101`.
- Composizione delle giornate peggiori (ora BCM dei deal in perdita, dall'uscita dello script) — 4 sedie, A:

| giornata | N % | chi perde, e quando (ora BCM di chiusura) | insieme |
|---|---|---|---|
| 2026.02.26 | **6,87** | `770101` −2,39 (09:00) · `770202` −2,16 (16:07) · `771531` −2,32 (16:21; i 7 deal delle 06:01 valgono in tutto −9 EUR) | c2 |
| 2025.10.15 | **6,33** | `770411` −2,14 (08:56) · `770202` −1,96 (16:37) · `771531` −2,32 (18:09) | c2 |
| 2026.02.19 | 4,76 | `770101` −2,50 (09:12) · `771531` −2,26 (11:05) | |
| 2026.04.02 | 4,74 | `770101` −2,37 (10:37) · `771531` −2,37 (12:40) | |
| 2026.02.06 | 4,46 | `770101` −2,30 (09:06) · `771531` −2,16 (15:31) | a (NFP) |
| 2026.06.23 | 4,44 | `771531` **−4,90 da sola** (08:55 + 14:35, 4 deal) | |

  Con la `770105` in B entrano sopra 4,5%: 2026.02.06 (**6,33**), 2025.12.02 (6,29), 12.16 (6,19), 2026.01.23 (5,91);
  la 2026.02.19 sale da 4,76 a **6,70**; la 2026.04.02 scende da 4,74 a 3,59 (li' la `770105` guadagna). In
  **quattro** delle sette giornate sopra 4,5% la `770105` perde **nella stessa mezz'ora** della `770101` (08:47-09:22
  BCM). La peggiore di B e' **2025.10.15 a 8,35%**.
- ⚠️ **Questi numeri NON sono quello che il conto avrebbe fatto**: la pausa del Guardian al 3,5% e il cap C1 al 4,00%
  sarebbero intervenuti, e dall'ordine delle chiusure si vede che in piu' giornate la soglia sarebbe stata passata
  **prima** dell'ultima perdita (es. 2025.10.15: 770411 alle 08:56 + 770105 alle 11:10 = 4,16% realizzato prima
  delle 16:37). 🔴 **Quanto avrebbe salvato e' [NON MISURATO]**: senza gli orari di APERTURA non si sa se la
  posizione era gia' aperta quando la soglia e' scattata, e la pausa guarda l'equity col flottante. E' la misura
  del **carico** che arriva sul Guardian, non del danno a valle del Guardian.
- La peggior giornata **di una sola sedia** e' della `771531` (**−4,90**, 2026.06.23): due coppie di ordini nella
  stessa giornata. E' co-movimento DENTRO la sedia, gia' dichiarato dal MC (fino a 8 posizioni).

---

## §6. 🏭 DOMANDA 3 — le tre sedie Dow

| insieme | n | `770202`+`771531` in perdita insieme [MISURATO] | tris con proxy: >=2 in perdita [DERIVATO] | tris: 3 in perdita [DERIVATO] |
|---|---|---|---|---|
| TUTTE | 277 | **6 (2,2%)** | 9 (3,2%) | 2 |
| (a) news | 28 | 0 | 1 (3,6%), perm. 0,62 | 0 |
| (b-US) | 10 | NON LEGGIBILE | NON LEGGIBILE | NON LEGGIBILE |
| (b-DAX) | 20 | 0 | 0 | 0 |
| (c2) | 22 | **6 (27,3%)** — tutte e sei le co-perdite stanno qui, per costruzione | 6 (27,3%) | 2 |

- ✅/🔴 **La coppia misurata perde insieme 6 volte su 277 giornate, tutte nelle 22 in cui operano insieme** (lift 1,57,
  p 0,0588: al criterio congelato **nessun legame misurabile**, sul filo). Le co-perdite cadono **dopo l'apertura
  USA**: le sei giornate sono 2025.10.15, 11.03, 11.13, 12.30, 2026.01.23, 02.26; `770202` chiude in perdita fra
  15:30 e 16:37 BCM, `771531` fra 15:50 e 21:21 (i 7 deal delle 06:01 del 26/02 valgono in tutto −9 EUR).
- **"Lo stress le lega di piu'": NON DIMOSTRATO** — 0 co-perdite in (a) e in (b-DAX), (b-US) illeggibile. Il tris con
  la `770511` vera e' **[NON MISURATO]**. Il proxy [DERIVATO] dice 9 giornate con >=2 in perdita e **2 con tutte e
  tre: 2025.10.15 e 2026.02.26 — cioe' proprio le due giornate peggiori del portafoglio** (6,33 e 6,87 senza il
  proxy; il 26/02 il proxy chiude in perdita **nello stesso minuto** della `771531`, 16:21). E' **un'altra cella, H2
  invece di H1**: dice dove guardare, non quanto.

---

## §7. 🔴 COSA RESTA [NON MISURATO], e la via piu' corta a ciascun numero

| buco | perche' | la via piu' corta (costo) — le decisioni restano di Claudio |
|---|---|---|
| `770260` Nasdaq, la sedia che apre **allo stesso minuto** della `770202` | nessun per-trade della cella in repo | per-trade della cella R199B su NASUSD al PC di backtest (**M8/M6** del piano degli otto giorni: minuti di tester) |
| `770511` vera (terza sul Dow) | nessun per-trade della cella; `770521` e' H2 | per-trade al banco 80.000 (**M6/M7**, "gratis dentro M6") |
| `770212` (in firma) | R255 non arrivato | la raccolta R255: lo script la leggerebbe come fa il MC con `--r255` (non implementato qui) |
| (a) news **completa** | il file news di casa ha buchi dal 2025.07.03 (solo Fed); il tratto completo **non separa** | un calendario USD 2025.07 → 2026.06 (export Forex Factory o MQL5), controllato con le due ancore NFP/CPI per anno (classe 862 (2)) |
| (b) **range giornaliero** vero | nessun archivio prezzi giornaliero dell'indice in repo | export D1 di U30USD / NASUSD / D30EUR 2025.06 → 2026.06 dal tester o da `CopyRates` al PC di backtest (secondi), poi decile su **tutte** le 277 giornate |
| (c) >=3 sedie USA | 2 sole sedie USA con per-trade | chiuso dai primi due punti |
| Guardian e C1 rigiocati | il per-trade scrive **solo le uscite** | gli orari di ingresso stanno nel **rapporto del tester** (deal in/out) delle stesse corse `[NON VERIFICATO che siano archiviati]` |
| flottante dentro la giornata | il per-trade e' realizzato | come sopra: serve il percorso, non solo la chiusura |
| regimi diversi | una sola finestra (2025.06 → 2026.06, toro) | per-trade sulla storia lunga (regola B del 16/08: il vecchio giudica il RISCHIO) |

**Non proposto qui, e non per dimenticanza:** nessuna taglia, nessuna soglia del Guardian, nessuna sedia da
togliere o aggiungere. Sono firme di Claudio; questo referto porta solo le misure su cui firmarle.

---

## §8. Come si rifa'

```
python3 backtest_pipeline/dipendenza_stress.py --autotest
python3 backtest_pipeline/dipendenza_stress.py
```
Seme 20260928, 10.000 permutazioni, ~10 s. Legge solo file del repo; non scrive nulla.
