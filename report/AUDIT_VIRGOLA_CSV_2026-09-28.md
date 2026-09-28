# 🔎 AUDIT — la virgola nel CSV (classe 883): quali verdetti passati poggiano su colonne spostate?

**28/09/2026** · branch `lavoro` · audit di **sola lettura** · albero letto a `51bb44f5`, confrontato con
`a66dcb07` (origin, lo scrittore che quota) · scansione su tutto il repo escluse le 9 copie in `.claude/worktrees/`.

Etichette: **MISURATO** = numero letto da un file o da un comando eseguito qui; **DERIVATO** = conseguenza
per costruzione di un fatto misurato; **[NON MISURATO]** = non c'e' il dato nel repo.

---

## 🎯 0. La risposta in tre righe

1. 🟢 **MISURATO: NESSUN CSV di risultati nel repo ha righe piu' lunghe dell'intestazione.** 2.613 CSV letti,
   2.305 con formato OptFrame, 230 con la colonna `InpNewsCurrencies`, **14.122 righe dati: 0 spostate, 0 corte.**
   In tutti e 230 il valore e' `USD` (226 file) o `EUR` (4 file): **mai una virgola**. Quindi **nessun verdetto
   passato letto dal repo (promozione, bocciatura, certificato di morte, cella scelta) e' stato letto su una
   colonna spostata.** Vale per chi ha letto per nome (`Import-Csv`, `csv.DictReader`) e per chi ha letto per posizione.
2. 🔴 **L'unico round con la virgola dentro e' R258** (24 file `ABTG_Londra_ORB`, pin `InpNewsCurrencies=GBP,USD`,
   in corsa sul PC di backtest dal 27/09): i suoi CSV **non sono nel repo** → per questo audit **[NON MISURATO]**;
   per costruzione (classe 883, eseguita il 27/09 con pwsh 7.4 sui file veri) il **RIEPILOGO della riga A e'
   SOSPETTO** e il verdetto vale solo dal lettore `leggi_round_corti_a.py`. **Nessun referto ha ancora scritto un
   verdetto su R258** (MISURATO: `report/` nomina R258 solo come stato di corsa, in 4 file).
3. ✏️ **La premessa va corretta**: gli EA con la virgola nel **default** sono **2, non 10** — `ABTG_Londra_ORB`
   (`"GBP,USD"`) e `ABTG_DAX_M3` (`"EUR,USD"`). Gli altri 8 hanno sempre avuto `"USD"` / `"EUR"` (MISURATO su
   tutta la storia git di ciascun sorgente). E i due con la virgola **non hanno mai prodotto un CSV nel repo**.

---

## 📐 1. La premessa, misurata

### 1a. Il default a HEAD e in tutta la storia git (MISURATO)

Per ognuno dei 10 EA nominati ho letto `input string InpNewsCurrencies` in **ogni commit** del sorgente (`git log`
per file, `git show <commit>:mql5/Experts/<EA>.mq5`), a partire da `51bb44f5` all'indietro:

| EA | default (tutta la storia, dal primo commit) | primo commit | virgola? |
|---|---|---|---|
| `ABTG_DAX_M3` | `"EUR,USD"` | `a86089c8` 26/07 | 🔴 SI |
| `ABTG_Londra_ORB` | `"GBP,USD"` | `a86089c8` 26/07 | 🔴 SI |
| `ABTG_GoldenCross` | `"USD"` | `a86089c8` 26/07 | no |
| `ABTG_GoldenCross_Ottimizzato` | `"USD"` | `a86089c8` 26/07 | no |
| `ABTG_GoldenCross_V1` | `"USD"` | `912043c9` 19/08 | no |
| `ABTG_IntradayMomentum` | `"USD"` | `af8b8dda` 22/08 | no |
| `ABTG_ORB` | `"USD"` | `a86089c8` 26/07 | no |
| `ABTG_ORB_Fibo` | `"USD"` | `a86089c8` 26/07 | no |
| `ABTG_ORB_Ottimizzato` | `"USD"` | `099d6648` 08/08 | no |
| `ABTG_PostNews` | `"EUR"` | `a86089c8` 26/07 | no |

Nessuno dei 10 ha **mai cambiato** default. Un CSV di uno degli 8 "senza virgola" puo' essere colpito **solo se il
file prova pinna una lista con la virgola**: si verifica sui pin (1b), non sul default.

### 1b. I pin con la virgola nei file prova (MISURATO: `grep InpNewsCurrencies=` su `backtest_pipeline/prove/`)

- **Con la virgola (26 file, tutti `ABTG_Londra_ORB`)**: `R216a_stopmode_londra_orb_GBPUSD.txt` (`GBP,USD`) ·
  `R258a`..`R258x` (24 file, `GBP,USD`) · il generatore `R258_GENERA.py`.
- **Senza virgola**: `POSTNEWS_1330/ISM/NFP/ORO_*` (9 file, `USD`) · `R100_ABTG_GoldenCross_770301` e
  `R100_ABTG_GoldenCross_Ottimizzato_970301` (`USD`) · `R103_ABTG_ORB_Ottimizzato_U30USD_770611` (`USD`) ·
  `R114_C0_ORB`, `R133b_filtrovolumi`, `R147b_flatfineseduta` (`USD`) · `R267a_news_oro_770402` (`USD`) ·
  R220a-d e R259 (`""`, in commento).
- 👉 **Il rischio storico si restringe a un solo EA, `ABTG_Londra_ORB`, e a due round: R216a e R258.**

### 1c. Il formato dei CSV in archivio (MISURATO)

Tutti i 230 file con la colonna hanno il **formato vecchio** (valore grezzo, nessuna virgoletta): la correzione
`a66dcb07` (RFC 4180 nello scrittore `OnTesterDeinit` dei 10 EA) vale **dai prossimi CSV compilati**, non riscrive
quelli esistenti — che pero', come misurato in 2, **non ne hanno bisogno**.

---

## 🧮 2. La scansione (MISURATO)

**Metodo**: per ogni `.csv` del repo (escluse le copie di `.claude/worktrees/`) decodifica con fallback
`utf-16` (BOM o byte nulli) → `utf-8-sig` → `cp1252`; e' "OptFrame" se l'intestazione contiene `Trades` o `Pass`;
per ogni riga dati si contano i campi separati da virgola e si confrontano con l'intestazione.

| grandezza | valore |
|---|---|
| CSV letti (repo, senza worktree) | **2.613** |
| CSV con formato OptFrame | **2.305** |
| con colonna `InpNewsCurrencies` | **230** |
| righe dati nei 230 | **14.122** |
| righe **piu' lunghe** dell'intestazione | **0** |
| righe **piu' corte** dell'intestazione | **0** |
| valori distinti di `InpNewsCurrencies` | `USD` (226 file) · `EUR` (4 file) |
| CSV di `ABTG_Londra_ORB` o `ABTG_DAX_M3` nel repo (per nome file **e** per impronta degli input: `InpRangeStartHour`+`InpSLMode` / `InpTriggerTF`) | **0** — conferma il *"zero CSV"* di `report/I_MORTI_E_IL_PEDAGGIO_2026-09-23.md` r.415 |

**Le 21 cartelle con la colonna** (EA dal nome file; round dal commit che ha aggiunto la cartella):

| cartella (`backtest_pipeline/…`) | EA | file | valore | posizione della stringa | colonne DOPO la stringa |
|---|---|---|---|---|---|
| `risultati_archivio/GoldenCross/H1_OHLC` | GoldenCross | 48 | USD | 52/56 | InpComment, InpMagic, InpMaxSpread, InpVerbose |
| `risultati_archivio/GoldenCross/H4_OHLC` | GoldenCross | 48 | USD | 52/56 | idem |
| `risultati_archivio/GoldenCross/realtick_H4` | GoldenCross | 8 | USD | 52/56 | idem |
| `risultati_prove/GoldenCross_forex_r20` | GoldenCross | 4 | USD | 53/58 | InpComment, InpFridayClose, InpFridayCloseHour, InpMaxSpread, InpVerbose |
| `risultati_prove/ABTG_GoldenCross` | GoldenCross | 10 | USD | 59/64 | idem |
| `risultati_prove/ABTG_GoldenCross_Ottimizzato` | GoldenCross_Ottimizzato | 12 | USD | 53/58 | idem |
| `risultati_archivio/r86_r87_r89_csv` | GoldenCross, _V1, _Ottimizzato | 24 | USD | 61/67 | InpComment, InpFridayClose, InpFridayCloseHour, InpMagic, InpMaxSpread, InpVerbose |
| `risultati_prove/ABTG_ORB` | ORB (NASUSD) | 8 | USD | 47/52 | InpNewsFlatten, InpComment, InpMagic, InpMaxSpread, InpVerbose |
| `risultati_prove/ABTG_ORB_Fibo` | ORB_Fibo | 2 | USD | 45/49 | InpNewsFlatten, InpComment, InpMaxSpread, InpVerbose |
| `risultati_prove/ABTG_ORB_Ottimizzato` | ORB_Ottimizzato | 16 | USD | 53/58 | InpNewsFlatten, InpComment, InpMagic, InpMaxSpread, InpVerbose |
| `risultati_prove/ABTG_ORB_Ottimizzato/r44` | ORB_Ottimizzato | 4 | USD | 53/58 | idem |
| `risultati_prove/ABTG_ORB_Ottimizzato/r45` | ORB_Ottimizzato | 6 | USD | 53/58 | idem |
| `risultati_archivio/r88_csv` | ORB_Ottimizzato U30USD | 10 | USD | 55/61 | InpNewsFlatten, InpComment, InpMagic, InpMaxSpread, InpVerbose, InpSlippagePts |
| `risultati_archivio/csv_r54` | ORB_Ottimizzato U30USD | 2 | USD | 54/58 | InpNewsFlatten, InpComment, InpMaxSpread, InpVerbose |
| `risultati_archivio/csv_r55` | ORB_Ottimizzato U30USD | 2 | USD | 55/59 | idem |
| `risultati_archivio/r118_csv` | ORB_Ottimizzato U30USD | 2 | USD | 56/62 | InpNewsFlatten, InpComment, InpMagic, InpMaxSpread, InpVerbose, InpAutoTest |
| `risultati_archivio/ritardo_r119_csv` | ORB_Ottimizzato U30USD | 4 | USD | 56/62 | InpNewsFlatten, InpComment, InpMaxSpread, InpVerbose, InpAutoTest, InpSlippagePts |
| `risultati_archivio/ritardo_r119b_csv` | ORB_Ottimizzato U30USD | 8 | USD | 56/62 | idem |
| `risultati_archivio/ancora_passo7` | ORB_Ottimizzato U30USD | 2 | USD | 56/62 | idem |
| `risultati_prove/dal_vps/ABTG_ORB_Ottimizzato` | ORB_Ottimizzato U30USD (r133b) | 2 | USD | 55/62 | InpNewsFlatten, InpComment, InpMagic, InpMaxSpread, InpVerbose, InpAutoTest, InpSlippagePts |
| `risultati_prove/dal_vps/ABTG_IntradayMomentum` | IntradayMomentum (r141b) | 4 | USD | 36/42 | InpComment, InpMagic, InpMaxSpread, InpVerbose, InpAutoTest, InpSlippagePts |
| `risultati_prove/ABTG_PostNews` | PostNews (ECB 771201/2) | 4 | EUR | **18/37** | **19 colonne, fra cui gli ASSI di griglia**: InpBuyOffsetPips, InpSellOffsetPips, **InpTPpips, InpSLpips**, InpUseOCO, InpTrail…, InpRiskPercent, InpComment, InpMaxSpread, InpVerbose |

📌 **Due fatti strutturali che escono dalla tabella (DERIVATO)**:
- In **tutti** gli EA tranne PostNews, `InpNewsCurrencies` sta in **coda** all'intestazione: dopo di lei ci sono solo
  colonne di **identita'/costo/diagnostica** (`InpComment`, `InpMagic`, `InpMaxSpread`, `InpVerbose`, `InpNewsFlatten`,
  `InpAutoTest`, `InpSlippagePts`, `InpFridayClose*`). **Le metriche del verdetto** (`Profit`, `Profit Factor`,
  `Equity DD %`, `Trades`: colonne 2-8) **e le manopole di griglia** stanno **prima**: una virgola non le sposta mai.
- **`ABTG_PostNews` e' l'eccezione**: la stringa e' alla colonna 18 di 37 e **gli assi della griglia (`InpTPpips`,
  `InpSLpips`, gli offset) stanno DOPO**. Oggi i suoi 4 CSV hanno `EUR` (intatti) e i 9 file prova POSTNEWS pinnano
  `USD`; ma e' l'EA in cui un pin `EUR,USD` **sposterebbe la cella scelta**, non solo il magic. Va tenuto a mente
  finche' il binario in campo/sul PC di backtest non e' ricompilato con `a66dcb07` ([NON MISURATO] qui quale binario giri).

---

## 🧾 3. Round per round: come e' stato letto, e cosa sta dopo la virgola

Legenda esito: **INTATTO** = nessuna colonna del verdetto poteva essere spostata (nessuna virgola nel valore, e/o
colonne del verdetto prima della stringa) · **SOSPETTO** = verdetto che dipende da una colonna letta dopo una virgola
reale · **[NON MISURATO]** = i CSV non sono nel repo.

| round | EA · simboli | CSV (n) | come e' stato letto (fonte) | colonne del verdetto | rispetto alla stringa | esito |
|---|---|---|---|---|---|---|
| scan GoldenCross 31/07 (`dd19d17b`) | GoldenCross · 48 simboli H1/H4 + 8 tick | 104 | referto `risultati_archivio/GoldenCross/ANALISI_GOLDENCROSS.md`; riletto il 09/09 da `censimento_pf.py` (`csv.DictReader`, per NOME: `Profit Factor`, `Trades`, `Equity DD %`, `Profit`, r.159-167) | PF, n, DD, Profit | PRIMA (col 2-8) | ✅ INTATTO |
| R20 (`cb0962e5`) | GoldenCross · USDJPY/GBPUSD | 4 | `REFERTO_ROUND20_GOLDENCROSS_FOREX.md` (0/6, per PF/OOS) | PF, Profit | PRIMA | ✅ INTATTO |
| FASE 0 weekend 08/08 (`400a4624`) | GoldenCross 10, GC_Ottimizzato 12, ORB 8, ORB_Fibo 2, PostNews 4 | 36 | classifica FASE 0 (42 lavori) | PF, n, DD | PRIMA | ✅ INTATTO |
| R9 (`6ec1c405`) | ORB_Ottimizzato · NASUSD/D30EUR/U30USD/XAUUSD | 16 | referto R9 ("60 celle Nasdaq senza edge") | PF, Profit | PRIMA | ✅ INTATTO |
| R44 (`e38cb80c`) · **R45** (`7ffd2acb`) | ORB_Ottimizzato · XAUUSD/EURUSD/GBPUSD | 4 + 6 | `REFERTO_ROUND45_LONDRA.md` r.17: cella XAUUSD *"−411 (OR30/TP2/vol, PF 0,80)"* | Profit, PF, InpRangeEndMin, InpTP_R | PRIMA (col 2-4, 9-10) | ✅ INTATTO — **contro-esempio in §4** |
| R54 (`06c9b803`) · R55 (`f5fb1c25`) | ORB_Ottimizzato · U30USD | 2 + 2 | `REFERTO_ROUND54_LATI_DOW.md`, R55 (stop largo) | PF, DD, Profit | PRIMA | ✅ INTATTO |
| R86/R87/R89 (`5da84459`) · R88 (`a92cc2a8`) | GoldenCross/_V1/_Ottimizzato 24 · ORB_Ott 10 | 34 | `righe/RIGA_NOTTE_R88_R87_R89_R86.ps1`: `Import-Csv` per NOME, legge `Profit Factor`/`Trades`; **0 letture di InpMagic/InpComment/InpMaxSpread** | PF, n, DD | PRIMA | ✅ INTATTO |
| R97 (`RIGA_R97_ORB_NASUSD.ps1`) · R98 (`RIGA_R98_MOMENTUM_NASUSD.ps1`) | ORB NASUSD · IntradayMomentum | 8 · 4 | `Import-Csv` per NOME, **`InpMagic` letto 11 e 20 volte** (asse gemelle) | PF + InpMagic | **InpMagic DOPO** (col 50/52 e 38/42) | ✅ INTATTO **perche' il pin e' `USD`**: la classe di lettura sarebbe stata SOSPETTA con un pin a virgola |
| R100 · R102 · R103 (`RIGA_R100_ORO_FLOTTA.ps1`, `RIGA_R102_CLASSIFICA_LUNGA.ps1`, `RIGA_R103_CLASSIFICA_FLOTTA.ps1`) | GoldenCross 770301, GC_Ott 970301, ORB_Ott 770611 | (prove `risultati_prove/ABTG_GoldenCross*`, `…ORB_Ottimizzato`) | `Import-Csv` per NOME, **`InpMagic` 14-15 volte, `InpComment` 1-6** | PF + InpMagic/InpComment | **DOPO** | ✅ INTATTO (pin `USD` in `R100_*`, `R103_*`); stessa avvertenza di R97/R98 |
| R118 (`1e591195`) · R119/R119b (`e6041bce`, `d8581686`) · passo 7 (`f194ac5a`) · r133b dal VPS | ORB_Ottimizzato U30USD | 2+4+8+2+2 | `RIGA_RITARDO_TESTER.ps1`, `RIGA_ANCORA_R119.ps1`: `Import-Csv`, `Profit Factor`/`Trades` (InpMagic 1 volta) | PF, n, DD, ancore | PRIMA (+InpMagic dopo) | ✅ INTATTO (`USD`) |
| POSTNEWS ECB verifica (`RIGA_POSTNEWS_ECBFOMC_VERIFICA.ps1`) | PostNews EURUSD/EURJPY 771201/771202 | 4 (Trades=0) | InpMagic per nome, 2 volte | identita' | DOPO (col 9 e 35) | ✅ INTATTO (`EUR`, e comunque 0 operazioni) |
| POSTNEWS 1330 / ISM / NFP / ORO (`RIGA_POSTNEWS_*.ps1`) | PostNews | **0 nel repo** | pin `InpNewsCurrencies=USD` in tutti e 9 i file prova | — | — | ⚪ [NON MISURATO] i CSV; **nessuna virgola nel pin → nessuno spostamento possibile** (DERIVATO) |
| **R216a** (`prove/R216a_stopmode_londra_orb_GBPUSD.txt`, pin `GBP,USD`) | Londra_ORB GBPUSD | **0** | **mai girato**: zero CSV; il file e' stato assorbito da R258 (CHECKLIST classe 840, 26/09) | — | — | ⚪ mai girato: **nessun verdetto esiste** |
| **R258** (24 file `R258a`..`x`, pin `GBP,USD`) | Londra_ORB GBPUSD/EURUSD M5/M30, ore 7/8/9 | **0 nel repo** (in corsa sul PC di backtest dal 27/09) | `RIGA_ROUND_CORTI_A_R250_R258_R259.txt` @ `202505d6`: `Import-Csv` nudo (1 occorrenza, **0 menzioni di `InpNewsCurrencies`**), P0 su 37 pin per NOME fra cui `InpMagic`/`InpMaxSpread`/`InpVerbose`, asse del blocco G = `InpMagic` | P0 + asse InpMagic | **DOPO, e la virgola c'e' davvero** | 🔴 **SOSPETTO per costruzione** il RIEPILOGO della riga (classe 883: pwsh 7.4 sui file veri ha dato `InpMagic="R258A LDN GBPUSD H8"`); ⚪ [NON MISURATO] qui i CSV; ✅ il **lettore** `leggi_round_corti_a.py` ricuce (autotest T10/T17 + §4). **Nessun referto ha ancora scritto un verdetto R258** (MISURATO) |
| "morti" `Londra_ORB` e `DAX_M3` | — | 0 | `PROMEMORIA_APERTURE.md` r.22/46/214/250 (spenti per **forward sul demo**: PF<1, −116 EUR il 28/07); `I_MORTI_E_IL_PEDAGGIO_2026-09-23.md` r.415-416 (*"zero CSV"*, **NON ANCORA MISURATO**) | nessuna colonna CSV | — | ✅ INTATTO: il verdetto **non poggia su nessun CSV**; il "non ancora misurato" del 23/09 resta com'e' |

**Sintesi**: 20 letture su 20 con CSV nel repo sono **INTATTE**, e per la ragione piu' forte (nessuna virgola nel
valore), non per la posizione delle colonne. Le letture per nome di `InpMagic` (R97, R98, R100, R102, R103) sono
**la stessa classe** che in R258 e' saltata: sono salve perche' il pin era `USD`, non perche' il lettore contasse i
campi. **Un solo verdetto e' da sorvegliare, R258, e non e' ancora stato scritto.**

---

## 🧪 4. Il contro-esempio (MISURATO, eseguito qui)

Nel repo non esiste un CSV colpito. Allora l'ho **costruito** dal file vero di un verdetto vero, nel modo esatto in
cui lo scrittore vecchio l'avrebbe prodotto con un pin a virgola: `risultati_prove/ABTG_ORB_Ottimizzato/r45/ABTG_ORB_Ottimizzato_XAUUSD_OOS_r45a.csv`
(8 righe, 58 colonne), con `USD` → `GBP,USD` nel campo `InpNewsCurrencies` di ogni riga, e nient'altro. La cella del
referto (`REFERTO_ROUND45_LONDRA.md` r.17, *"−411 (OR30/TP2/vol, PF 0,80)"*) e' la riga con il Profit piu' alto.

Quattro letture della stessa cella:

```text
A) ORIGINALE, per nome (csv.DictReader):
   Pass=7 Profit=-410.61 PF=0.79665 DD=7.7342 Trades=186 InpRangeEndMin=30 InpTP_R=2.0
   InpNewsCurrencies=USD InpNewsFlatten=1 InpComment=ORB OTT InpMagic=770611 InpMaxSpread=0 InpVerbose=1
B) MUTATO (GBP,USD), per nome (csv.DictReader):
   Pass=7 Profit=-410.61 PF=0.79665 DD=7.7342 Trades=186 InpRangeEndMin=30 InpTP_R=2.0
   InpNewsCurrencies=GBP InpNewsFlatten=USD InpComment=1 InpMagic=ORB OTT InpMaxSpread=770611 InpVerbose=0
   (campo in eccesso finito sotto la chiave None: ['1'])
C) MUTATO, Import-Csv VERO (pwsh 7.4.6, non emulato): 8 righe, 58 proprieta'
   Pass=7 Profit=-410.61 PF=0.79665 OR=30 TP=2.0
   InpNewsCurrencies=GBP InpNewsFlatten=USD InpComment=1 InpMagic=ORB OTT InpMaxSpread=770611 InpVerbose=0
   (l'ultimo campo, InpVerbose=1, e' SCARTATO: come nella classe 883)
D) MUTATO e RICUCITO con allinea_riga() di leggi_round_corti_a.py: ricucite 8/8
   Pass=7 Profit=-410.61 PF=0.79665 DD=7.7342 Trades=186 InpRangeEndMin=30 InpTP_R=2.0
   InpNewsCurrencies=GBP,USD InpNewsFlatten=1 InpComment=ORB OTT InpMagic=770611 InpMaxSpread=0 InpVerbose=1
```

Lettura del contro-esempio:
- ✅ **La cella del referto coincide in A, B, C e D**: `Profit −410.61`, `PF 0.79665`, `OR 30`, `TP 2.0`, `n 186`
  (arrotondati: −411, 0,80). Il verdetto R45 **regge anche sul file spostato**, perche' tutte le sue colonne stanno
  prima della stringa. E la ricucitura restituisce **byte per byte** l'originale.
- 🔴 **Le colonne dopo la stringa sbagliano davvero, in silenzio**: `InpMagic` letto per nome vale **`ORB OTT`**
  (B e C) contro il vero **`770611`** (A e D); `InpMaxSpread` diventa `770611`, `InpVerbose` `0`. Un verdetto che
  usasse `InpMagic` come asse (blocco G di R258) o `InpMaxSpread` come cancello di costo **leggerebbe un altro numero
  senza nessun errore a schermo**: e' esattamente quello che la classe 883 ha visto il 27/09.
- ✅ **Lo scanner di §2 si accende sull'ipotesi alternativa**: sul file mutato conta **8/8 righe piu' lunghe** e
  nomina come prima colonna spostata `InpNewsFlatten`. Sui 230 file veri conta 0: la banda **misura**, non conferma.
- ✅ **Lato opposto della ricucitura**: `allinea_riga()` sui **230 file veri, 14.122 righe: 0 ricucite, 0 non
  ricucibili** — non tocca cio' che e' sano.

---

## 📬 5. Le righe consegnate e non ancora girate (MISURATO sui file in `backtest_pipeline/righe/`)

Per ogni riga: EA lanciati (dai nomi `ABTG_*` nel testo), default a HEAD, pin di `InpNewsCurrencies` nei file prova
che nomina, e come legge i CSV.

| riga | EA lanciati (default HEAD) | file prova · pin `InpNewsCurrencies` | lettura CSV | esito |
|---|---|---|---|---|
| **A** `RIGA_ROUND_CORTI_A_R250_R258_R259.txt` | `ABTG_Londra_ORB` (**`GBP,USD`**), `ABTG_Nasdaq_Apertura_US` (`""`), `ABTG_Nightly` (`""`) | R258a-x: **`GBP,USD`** (24 file) · R250a-f: non pinnato · R259 6 PIN: `""` in commento | `Import-Csv` nudo ×1, 0 conteggi di campi | 🔴 **R258 a rischio (classe 883, nota)** — R250 e R259 sicure. Fa fede il lettore |
| **R255** `RIGA_R255_SHORT_DOW_INFASE.txt` | `ABTG_Dow_Apertura_US` (`""`) | R255a-x (24 file): **nessun pin** | `Import-Csv` nudo ×1 | ✅ SICURA: nessuna stringa con virgola puo' entrare nel CSV |
| **B** `RIGA_ROUND_CORTI_B_R260_R263.txt` | `ABTG_MaxMinNotte` (`""`), `ABTG_Nasdaq_Apertura_US` (`""`) | R260a-c, R261a-d, R262a-d, R263a-g: **nessun pin** | `Import-Csv` nudo ×1 | ✅ SICURA |
| **C** `RIGA_ROUND_CORTI_C_R264_R267.txt` | `ABTG_EMA200` (`""`), `ABTG_MaxMinNotte` (`""`), `ABTG_Dow_Apertura_US` (`""`) | R260d, R264a-d, R265a-b, R266a-f, R267b-d: nessun pin · **R267a: `USD`** (senza virgola) | `Import-Csv` nudo ×1 | ✅ SICURA (il cancello C aveva gia' verificato `""`; confermato sui pin) |
| **C2** `RIGA_ROUND_CORTI_C2_R264D_ORO.txt` | `ABTG_EMA200` (`""`) | R264d: nessun pin | `Import-Csv` nudo ×1 | ✅ SICURA |
| **D** `RIGA_ROUND_CORTI_D_R268_R269.txt` | `ABTG_MaxMinNotte` (`""`) | R268a-d, R269a-c: nessun pin | `Import-Csv` nudo ×1 | ✅ SICURA |

📌 **DERIVATO, e va detto**: tutte e sei le righe leggono con `Import-Csv` **nudo** e **nessuna conta i campi contro
l'intestazione** (0 menzioni di `InpNewsCurrencies` in ognuna). Sono sicure **per i dati di oggi** (nessun EA con
virgola nel default, nessun pin con virgola), non per il metodo: la regola (1) della classe 883 — *"prima di un P0 su
un CSV di OptFrame si guarda se un input STRINGA contiene il separatore"* — non e' dentro le righe, e' dentro il lettore.
Con lo scrittore `a66dcb07` ricompilato, il problema sparisce **alla fonte** (il campo arriva quotato e `Import-Csv`
lo legge giusto); finche' un binario vecchio gira, resta il lettore.

Nella coda del runner (`backtest_pipeline/coda/CODA.txt`, 3.202 righe): **0 righe che nominano R216, R258, Londra o DAX_M3** (MISURATO).

---

## 🧰 6. Cosa resta a mano

1. **R258, quando torna lo zip dal PC di backtest**: prima del lettore, passare i 24 CSV allo scanner di §2 (conteggio
   campi vs intestazione) e **scrivere nel referto** che ogni riga ha esattamente **1 campo in piu'** e che la
   ricucitura e' stata fatta su `InpNewsCurrencies` — cosi' il verdetto R258 nasce col suo certificato. Il RIEPILOGO
   della riga A **non e' un verdetto** (gia' scritto in `RESOCONTO_2026-09-27.md` r.38 e in `HANDOFF.md` r.24-25).
2. **Quale binario gira davvero**: la correzione `a66dcb07` vale dal prossimo `.ex5` compilato. Per i 10 EA
   ([NON MISURATO] qui) va letto sul PC di backtest e sul VPS se l'`.ex5` e' anteriore o posteriore al commit; fino a
   quel momento ogni CSV nuovo di `Londra_ORB`/`DAX_M3` nasce spostato e va letto con ricucitura.
3. **`ABTG_PostNews`**: e' l'unico EA con gli **assi di griglia dopo la stringa** (§2). Se un file prova futuro pinnasse
   `EUR,USD` su un binario vecchio, si sposterebbe **la cella scelta**, non solo il magic. Vale una riga nel file di
   testa dei round PostNews finche' il binario non e' ricompilato.
4. **I lettori per nome** (51 script fra `righe/*.ps1` e `backtest_pipeline/*.py` leggono `Import-Csv`/`DictReader`;
   25 leggono per nome colonne che stanno dopo la stringa, in testa `RIGA_POSTNEWS_1330/ISM/NFP.ps1` e
   `leggi_r255.py`): oggi nessuno conta i campi tranne `leggi_round_corti_a.py`. Se `allinea_riga()` debba diventare
   una funzione condivisa (`abtg_csv.py`) invece di vivere in un solo lettore e' una **decisione**, non un lavoro di
   questo audit: la porto come proposta, col numero sopra.
5. **Sincronizzazione del branch**: questo referto e' stato committato sopra `a66dcb07` (origin). L'albero di lavoro
   conteneva le stesse 10 modifiche di `a66dcb07` non committate (diff vuoto contro origin, MISURATO): non le ho
   toccate; se dopo il rebase risultassero ancora "modificate", e' lo stash automatico che le ha rimesse com'erano.

---

### Fonti lette (tutte nel repo)
`backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md` (classi 840, 841, 883) · `backtest_pipeline/leggi_round_corti_a.py`
(`leggi_csv_opt`, `allinea_riga`, r.190-236) · `backtest_pipeline/censimento_pf.py` r.133-167 ·
`report/I_MORTI_E_IL_PEDAGGIO_2026-09-23.md` r.133-134, 164, 298-307, 415-417 · `report/CENSIMENTO_PF_MISURATI_2026-09-09.md`
· `report/RESOCONTO_2026-09-27.md` r.38, 54, 65 · `report/STATO_2026-09-26_SERA.md` r.15-25 · `HANDOFF.md` r.24-25 ·
`PROMEMORIA_APERTURE.md` r.22, 44-46, 193, 214, 250 · `backtest_pipeline/risultati_archivio/REFERTO_ROUND45_LONDRA.md` r.17-23 ·
`backtest_pipeline/risultati_archivio/REFERTO_ROUND20_GOLDENCROSS_FOREX.md` · `backtest_pipeline/prove/` (grep dei pin) ·
`backtest_pipeline/righe/RIGA_*.txt|.ps1` (conteggi) · `mql5/Experts/*.mq5` a ogni commit della storia dei 10 EA.
