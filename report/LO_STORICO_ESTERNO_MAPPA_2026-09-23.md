# 📚 LO STORICO ESTERNO — LA MAPPA, E COSA CI SI PUÒ FARE

**23/09/2026** · repo `/home/user/GITHUB`, branch `lavoro`
🛑 **SOLA LETTURA, ZERO TEMPO MACCHINA.** Nessun round lanciato, nessuna riga consegnata,
niente VPS, niente forward, nessun preset toccato, nessuna sedia promossa o spenta,
**nessun import eseguito**. L'unica cosa scritta è questo file, più il commit.

Nasce dalla correzione di Claudio (22/09, notte): _«ABBIAMO SCARICATO LO STORICO DA ALTRI
SITI SIA SU ORO CHE SU INDICI. CONTROLLA E NON TI DIMENTICARE»_.
**Aveva ragione. E controllando è venuto fuori parecchio di più di quello che cercavamo.**

---

# 🥇 LA NOTIZIA IN SEI RIGHE

> ### 1️⃣ **IL FRIGO È GIÀ APERTO A METÀ, DA QUASI UN MESE.** Le due misure che il brief
> dà per `[DA MISURARE]` — volatilità oraria e anatomia dell'evento 23/03 — **sono state
> fatte il 26/08**, e Claudio ha **FIRMATO**: *«FIRMO FRIGO NASUSD»*. `NASUSD_EXT` è
> **ammesso alla prova di regime** da allora, ed è già stato usato (R113, 18/18 celle).
>
> ### 2️⃣ **IL DAX ESTERNO ESISTE, ED È SANO — 9 ANNI, 1.718.805 BARRE M1.** Scaricato e
> convertito il **10/09**. 2010-2018, **0 barre fuori banda**, prezzi verificati contro la
> realtà. 🔴 **Ma NON è importato, e c'è un motivo che non si aggira: ZERO SOVRAPPOSIZIONE
> col nativo BCM.** Sul DAX il cancello ZERO non è *chiuso*: è **inapplicabile**.
>
> ### 3️⃣ 🔴 **IL DOW NON ESISTE, ED È IL BUCO PIÙ GROSSO — confermo il sospetto del brief.**
> Nessun `U30USD_EXT`. HistData il Dow **non ce l'ha proprio**. L'unico pezzo di Dow esterno
> è `U30USD_DK` (Dukascopy tick), **in frigo**, e copre **2024-10 → 2025-06**, cioè una
> finestra **già dentro** lo storico nativo: **storia in più, zero giorni.**
>
> ### 4️⃣ 🔴 **E QUI IL BRIEF VA CORRETTO SULL'ORO, nel verso che ci conviene:
> `XAUUSD_EXT` è 2018-2024, SETTE ANNI. Non ha mai visto il 2008 né il 2013.**
> Ma **non serve**: il **nativo BCM parte dal 2004.06.11 (22,1 anni)** — cioè **il nostro
> broker, sull'oro, è PIÙ PROFONDO del feed esterno**. E quei 22 anni **sono già stati
> girati** (R100, 23/08, 11 motori oro).
>
> ### 5️⃣ 🟢 **TROVATO OGGI, E NON ERA IN NESSUN REFERTO: UN MIRROR DI HISTDATA
> RAGGIUNGIBILE DAL CLOUD.** `histdata.com` e `dukascopy.com` sono egress-blocked
> (riverificato adesso: **403**). Ma `raw.githubusercontent.com/FutureSharks/financial-data`
> ha `GRXEUR`, `SPXUSD`, `JPXJPY` **2010-2018** — misurato anno per anno da me oggi.
> **È la finestra DAX sana, a costo macchina ZERO per Claudio.**
>
> ### 6️⃣ ⚖️ **E LA FRASE DEL BRIEF CHE MI ERA STATO CHIESTO DI ROMPERE, SI ROMPE.**
> *«Il feed `_EXT` è promosso, quindi i suoi numeri sono confrontabili con quelli BCM»* è
> **FALSA, ed è misurata falsa in casa**: R80, stessa cella, stessa finestra, stessi
> parametri, **cambia solo il feed → quattro cambi di SEGNO**. §5.

---

# 1. 🗺️ LA MAPPA — inventario per simbolo, con le date MISURATE DAI DATI

## 1.0 La legenda dei tre stati (sono cose diverse, e vanno tenute diverse)

| stato | vuol dire |
|---|---|
| 🟢 **(a) IMPORTATO E PROMOSSO** | esiste come simbolo nel terminale **e** ha il permesso d'uso (cancello ZERO passato o firma) |
| 🧊 **(b) IMPORTATO E IN FRIGO** | esiste come simbolo nel terminale, **il permesso NON c'è** |
| ⚪ **(c) SCARICATO MA MAI IMPORTATO** | il CSV esiste su un disco, **nessun simbolo esiste** |
| ⛔ **(d) MAI SCARICATO** | non esiste da nessuna parte |

🔴 **E una quarta domanda che nessun inventario precedente faceva: SU QUALE MACCHINA.**
I simboli `_EXT` e `_DK` vivono **tutti** su **`DESKTOP-H4D7CAJ` (il PC di backtest)**,
terminale `C:\Program Files\BCM Markets MT5 Terminal` — dichiarato nei referti d'import
(`STORICO_INDICI_20260826_2334/REFERTO_STORICO_INDICI.txt` r.6 `macchina: DESKTOP-H4D7CAJ`).
🟢 **E la firma del 21/09 (*«i round sul pc di backtest»*) li rimette esattamente dove
sono.** La casella `[NON MISURATO]` del 09/09 — *«`NASUSD_EXT` esiste su `C:\MT5_Backtest`?»*
— **non è più sul cammino critico**: quel terminale deve restare spento mentre la challenge
opera.

---

## 1.1 🟢 FOREX + ORO — otto simboli, stato **(a) IMPORTATO E PROMOSSO**

**Fonte primaria misurata**: `backtest_pipeline/risultati_prove/import_esterno/ABTG_ImportEsterno_referto.csv`
(sei simboli, 15/08) + `risultati_archivio/sonda_storico_17-08/215D85D7_ABTG_InfoBroker.csv`
(righe `_EXT`, che è la prova che i simboli **esistono davvero nel terminale**, non solo nel referto).

| simbolo | fonte | **prima data MISURATA** | **ultima data MISURATA** | barre M1 | scart. | **diff media** | copert. | shift | cancello |
|---|---|---|---|---:|---:|---:|---:|---:|---|
| `AUDJPY_EXT` | HistData | **2018.01.01 22:00** | **2024.12.31 21:58** | 2.558.215 | **0** | **0,0090%** | 99,6% | +5 | ✅ `OK CONFRONTABILE` |
| `CHFJPY_EXT` | HistData | 2018.01.01 22:00 | 2024.12.31 21:58 | 2.549.100 | **0** | **0,0080%** | 99,6% | +5 | ✅ |
| `EURJPY_EXT` | HistData | 2018.01.01 22:01 | 2024.12.31 21:58 | 2.556.391 | **0** | **0,0063%** | 99,6% | +5 | ✅ |
| `GBPCAD_EXT` | HistData | 2018.01.01 22:02 | 2024.12.31 21:58 | 2.547.121 | **0** | **0,0072%** | 99,5% | +5 | ✅ |
| **`XAUUSD_EXT`** | HistData | **2018.01.01 23:01** | **2024.12.31 21:57** | 2.432.995 | **0** | **0,0110%** | 99,2% | +5 | ✅ |
| `USDJPY_EXT` | HistData | 2018.01.01 22:00 | 2024.12.31 21:58 | 2.553.253 | **0** | **0,0054%** | 99,6% | +5 | ✅ |
| `EURUSD_EXT` | HistData | **2018.01.01** *(sonda terminale)* | *(idem set)* | *(42.779 barre H1)* | — | **0,0041%** | 99,6% | +5 | ✅ |
| `GBPUSD_EXT` | HistData | **2018.01.01** *(sonda terminale)* | *(idem set)* | *(42.761 barre H1)* | — | **0,0052%** | 99,6% | +5 | ✅ |

**Totale dichiarato: 15,2 M barre M1 sui sei del 15/08, zero righe scartate, zero proprietà guaste.**

> ### 🟢 IL CONTROLLO CHE VALE PIÙ DELLA TABELLA, e regge alla rilettura
> **Otto simboli su otto hanno calibrato +5 in modo indipendente** (scansione automatica
> −6…+6, nessun valore imposto), su giorni e import diversi. Otto ricerche indipendenti che
> convergono sullo stesso numero misurano una cosa vera (HistData = ora di New York), non
> rumore. **Questo pezzo del brief l'ho verificato e lo confermo.**

> ### 🔴 MA ATTENZIONE A COSA **NON** DICE QUESTA TABELLA — la correzione grossa
> **`XAUUSD_EXT` è 2018-2024. SETTE ANNI.** Non contiene il 2008, non contiene il 2013.
> Il brief parla di *«~20 anni di oro al minuto»* — quelli **esistono**, ma sono **altri
> due file, di altri due feed**, e **nessuno dei due è importato** (§1.4).

---

## 1.2 INDICI — quattro stati diversi in quattro righe

### 🟢 `NASUSD_EXT` (Nasdaq 100) — **(a) IMPORTATO E PROMOSSO**

| voce | valore misurato | fonte |
|---|---|---|
| barre M1 | **5.233.590**, **0 scartate** | `STORICO_INDICI_20260826_2334/ABTG_ImportEsterno_referto.csv` |
| **periodo** | **2010.11.14 23:01 → 2026.07.31 21:13** (~15,7 anni) | idem |
| serie derivate | M15 **362.325** · H1 **93.085** | `.../ABTG_ContaBarreEXT.csv` |
| copertura H1 vs nativo | **97,0%** (10.497 barre confrontate) | idem |
| diff media H1 | **0,0756%** (v1) · **0,0662%** fuori-finestre DST (v2) | `import_ext_v2_referto_2026-08-19.csv` |
| vol oraria 2025 **misurata** | **0,3324%** | `LETTURA_MISURE_LAMPO_2026-08-26.md` §1 |
| **rapporto diff/vol** | **0,199** contro soglia **0,20** | idem |
| macchina | `DESKTOP-H4D7CAJ`, import 26/08 23:39 (**0,8 min**) | `REFERTO_STORICO_INDICI.txt` F7 |
| **stato** | 🟢 **AMMESSO** — firma **«FIRMO FRIGO NASUSD»**, Claudio 26/08 | `prove/PROVA_REGIME_CRITERI.md` §2 |

✅ **E non è teoria: R113 (27/08) ha girato 18 celle su 16 anni, 5,4 min, 0 problemi.**

### 🧊 `SPXUSD_EXT` (S&P 500) — **(b) IMPORTATO E IN FRIGO**

**4.598.932** barre M1, **2010.11.14 23:00 → 2026.07.31 21:13**; M15 **360.619**, H1 **92.932**;
shift **+5**; copertura **97,0%**; diff **0,0608%** (v1) / **0,0527%** (fuori-finestre);
vol 2025 misurata **0,2602%** → **rapporto 0,203**. 🧊 **Sopra 0,20 per tre millesimi.**

### 🧊 `225JPY_EXT` (Nikkei 225) — **(b) IMPORTATO E IN FRIGO, e su finestra CORTA**

**2.357.431** barre M1, **2019.01.01 23:01 → 2026.07.31 21:13**; diff **0,1010%** / **0,0871%**;
vol 2025 **0,3747%** → **rapporto 0,232**. 🧊 Frigo.
⚠️ **E non è mai stato riscaricato su 2010-2026**: non era in D-B per il giro del 10/09.

### ⚪ `D30EUR` (DAX 40) — **(c) SCARICATO, CONVERTITO, MAI IMPORTATO**

| voce | valore misurato | fonte |
|---|---|---|
| barre M1 | **1.718.805** | `STORICO_INDICI_20260910_1356/dati/D30EUR_M1_ANTEPRIMA.txt` |
| **periodo (letto dalle righe, non dal nome)** | **2010.11.15 02:00 → 2018.12.28 16:13** | idem |
| anni | **9 su 9** chiesti (D-H: `D30EUR:2010-2018`) | `REFERTO_STORICO_INDICI.txt` |
| qualità 2010-2018 | **0 barre fuori banda in tutti e nove gli anni**, finestra modale 02:00-15:00 NY, densità 58,1-59,6 | `DIAGNOSI_DAX_20260910_SOGLIA41/REFERTO_DIAGNOSI_DAX.txt` |
| controprova prezzi | ultima barra 28/12/2018 = **10.566,51** (DAX chiuse il 2018 a ~10.559) ✅ | `report/STORICO_INDICI_SCARICATO_2026-09-10.md` |
| dove sta il CSV | `C:\Users\Administrator\abtg_storico_indici\D30EUR_M1.csv` (**VPS**) | anteprima r.1 |
| **stato** | ⚪ **nessun `D30EUR_EXT` esiste** | verificato: zero righe `_EXT` per D30EUR |

> ## 🕳️ **E IL MOTIVO PER CUI NON È IMPORTATO NON È PIGRIZIA: È ARITMETICA.**
> esterno **2010.11 → 2018.12** · nativo BCM **2024.09.26 → oggi** ⇒ **ZERO giorni in comune.**
> Il cancello ZERO si calcola **solo** sulla sovrapposizione. Sul DAX **non è chiuso: è
> INAPPLICABILE**, e la differenza conta — un cancello chiuso si apre con una misura
> migliore, uno inapplicabile **non si apre finché non cambia il dato**.

🔴 **Gli anni 2020-2023 di `grxeur` NON contengono il DAX**: contengono un altro indice
(2021 min-max **3.461-4.414**, 2022 **3.247-4.395**, quando il DAX vero stava a
**12.400-16.300**), per **42 mesi consecutivi**. Certificato tre volte.
🟡 Gli anni **2019 · 2024 · 2025 · 2026** sono classificati **RIPARABILE**: 0 fuori banda,
prezzi giusti, **solo un'altra convenzione oraria** (00:00-23:00 invece di 02:00-15:00).
👉 **Sono loro la chiave**: sono gli unici che potrebbero dare la sovrapposizione con BCM.

### ⛔ `U30USD` (Dow Jones) — **la risposta esplicita alla domanda del brief**

> ## 🔴 **CONFERMO: IL DOW ESTERNO NON ESISTE. NÉ `_EXT`, NÉ SCARICATO, NÉ ORDINABILE DA HISTDATA.**
> - **HistData non ha il Dow.** I suoi indici sono **dieci** e sono
>   `grxeur auxaud frxeur hkxhkd spxusd jpxjpy udxusd nsxusd ukxgbp etxeur`.
>   ⚠️ `udxusd` è il **Dollar Index**, non il Dow: il nome trae in inganno.
> - **Dukascopy ce l'ha** (`USA30IDXUSD`, dal **2012**), e la sonda a tre giri del 15/08
>   l'ha verificato **con controllo positivo EURUSD passato** e con **404 veri** sui nomi
>   sbagliati (`US30IDXUSD`, `USA30USD`, `WS30IDXUSD`).
> - **Ma il Dow profondo non è mai stato scaricato: zero byte.**

### 🧊 `U30USD_DK` (Dow, Dukascopy TICK) — **(b) importato e in frigo, e la finestra è quella sbagliata**

| voce | valore misurato | fonte |
|---|---|---|
| tick scritti | **20.753.611**, 0 scartati, **0 fuori ordine** | `duka/ABTG_ImportTick_referto.csv` |
| **primo / ultimo tick** | **2024.10.01 01:00 → 2025.06.17 00:59** | idem |
| crawl | **222/222 giorni in 0,2 h** con `curl` (~30× il preventivo `urllib`) | `duka/REFERTO_DUKA_A_20260903_2216_COMPLETA.txt` |
| sonda | **5/6 giorni dentro soglia**, peggiore **0,0696% il 2024.11.20** | `duka/REFERTO_IMPORT_SONDA_2026-09-03_2243.txt` |
| **stato** | 🧊 **CANCELLO CHIUSO per lettera del criterio** (il 20/11/2024 non è un giorno DST → *«altri giorni fuori → i `_DK` in frigo. Nessun "però quasi"»*) | idem |

> ### ⚠️ **E QUESTA È LA RIGA CHE NON VA DIMENTICATA:** 2024-10 → 2025-06 sta **DENTRO** lo
> storico nativo BCM (che parte dal 26/09/2024). 🎯 **Era la validazione del DECODER, non
> storia in più.** In termini di anni guadagnati sul Dow: **ZERO.**

### ⚪ `E50EUR` · `F40EUR` · `100GBP` · `200AUD` — **mai toccati**

HistData li ha tutti e quattro dal 2010-11 (`etxeur`, `frxeur`, `ukxgbp`, `auxaud`) e
**tutti e quattro hanno un gemello nativo BCM** su cui il cancello ZERO **si calcola**
(E50EUR 7.499 barre H1, F40EUR 6.713, 100GBP 10.338, 200AUD 10.345, tutti dal 2024.09.26).
⚪ **Stato (d): mai scaricati.**

---

## 1.3 🏦 IL CONFRONTO CHE CAMBIA LA STRATEGIA: dove il NATIVO è già più profondo

Fonte: `risultati_archivio/REFERTO_SONDA_STORICO_17-08.md` (conto 50503392, 59 simboli su 59).

| simbolo | **prima data NATIVA BCM** | prima data `_EXT` | chi vince |
|---|---|---|---|
| **USDJPY** | **1971.01.03** | 2018.01.01 | 🟢 **nativo, di 47 anni** |
| **EURUSD** | **1971.01.03** | 2018.01.01 | 🟢 **nativo** |
| **GBPUSD** | **1993.05.11** | 2018.01.01 | 🟢 **nativo, di 25 anni** |
| **XAUUSD** | **2004.06.11** (22,1 anni) | 2018.01.01 | 🟢 **nativo, di 14 anni** |
| NASUSD / SPXUSD / D30EUR / U30USD / 225JPY | **2024.09.26** (`COMPLETO` = il broker non ce l'ha) | 2010-11 (Nas/SPX) | 🔵 **esterno** |

> ## 🎯 **TRADOTTO: LO STORICO ESTERNO SERVE SUGLI INDICI. SU FOREX E ORO È IL PIANO B, NON IL PIANO A.**
> E il motivo per cui la prova di regime del 14-15/08 fu costruita sui `_EXT` **anche sul
> forex** non era la profondità: era che **le barre M1 native del 2019-2022 non erano state
> scaricate in locale** (sonda 17/08: `da scaricare (parziale)` su GBPUSD e USDJPY).
> 🔴 **Ed è lo stesso buco che ha fatto fallire il controllo di R80** (§5). **Non è un
> acquisto: è un download.**

---

## 1.4 🥇 L'ORO FUORI DAL TERMINALE — due feed, due epoche, **nessuno dei due importato**

| pezzo | fonte | **finestra MISURATA** | volume | dove sta | stato |
|---|---|---|---|---|---|
| **2006-2020** | **OANDA** via `FutureSharks/financial-data` (`currencies/oanda/XAU_USD/`) | **2006-03-19 20:29 → 2020-05-14 07:59** | **4.884.366 barre M1**, 0 scartate, 0 OHLC incoerenti | 🔴 **`/tmp/sonda_st_cache` — cache del CLOUD, 548 MB, EFFIMERA. NON è nel repo, NON è sul PC di Claudio** | ⚪ mai importato |
| **2021-2026** | **HistData** | **2021-01-03 18:00 → 2026-09-18 16:58** (ora NY) | **1.981.357 righe M1**, **14 zip su 14**, ogni zip con **SHA256** | 🟢 **`backtest_pipeline/risultati_prove/oro_m1_histdata_zip/` — 15 file TRACCIATI IN GIT**, scaricati su `DESKTOP-H4D7CAJ` il 22/09 | ⚪ mai importato |

🔴 **E i due NON si concatenano** — è già scritto e firmato in
`report/ORO_M1_2021_2026_PIANO_2026-09-22.md`: *«sono due feed di due broker diversi…
attaccare i due pezzi sarebbe il modo più elegante di rovinare una misura che oggi è buona»*.
**Quindi i «~20 anni» del brief sono 14 anni + 5,7 anni, separati, di due broker, e con un
buco di 7 mesi in mezzo (2020-05 → 2021-01).**

🟢 **Verificato da me oggi, ed è il controllo che vale**: il conteggio righe della cache
(`4.884.537` righe = **4.884.366 barre + 171 intestazioni**) **torna al numero esatto** del
referto. La ricostruzione del 22/09 è fedele.

---

## 1.5 🟢 LA PISTA NUOVA — **un mirror di HistData raggiungibile dal cloud**

**Misurato da me, oggi, anno per anno** (`curl -r 0-10`, solo header, nessun download):

| percorso | simboli | **anni con risposta 206** | anni con 404 |
|---|---|---|---|
| `raw.githubusercontent.com/FutureSharks/financial-data/master/pyfinancialdata/data/stocks/histdata/<SIM>/DAT_ASCII_<SIM>_M1_<anno>.csv` | **`GRXEUR` · `SPXUSD` · `JPXJPY`** | **2010 · 2011 · 2012 · 2013 · 2014 · 2015 · 2016 · 2017 · 2018** | 2019+ e tutto ciò che è prima del 2010 |
| stesso percorso | `NSXUSD`, `UDXUSD` | **nessuno** (404 su 2010, 2012, 2019, 2020, 2023) | tutti |

**E la prova che è già stato usato in casa**: `/tmp/sonda_st_cache` contiene
`DAT_ASCII_{GRXEUR,JPXJPY,SPXUSD}_M1_{2013..2018}.csv` scaricati da lì il **22/09 alle 17:38**
da `backtest_pipeline/sonda_supertrend_segnali.py` (r.67 `BASE`, r.70 `IDX_PATH`).

> ### 🎯 **PERCHÉ È UNA NOTIZIA, e non una curiosità**
> **`histdata.com` e `datafeed.dukascopy.com` sono egress-blocked dal cloud — riverificato
> adesso, `CONNECT tunnel failed, 403` su tutti e due.** `raw.githubusercontent.com` **no**.
> 👉 Quindi **`GRXEUR` 2010-2018 — esattamente la finestra DAX sana — è leggibile da un
> agente in cloud, gratis, senza toccare il PC di Claudio e senza un minuto di macchina.**
> ⚠️ **Non è una scorciatoia al cancello**: i dati restano di un altro broker e il problema
> della sovrapposizione zero **non si sposta di un millimetro** (§3.3). È una scorciatoia
> **al lavoro di analisi**, non al permesso.

---

# 2. 🎯 CHE COSA SI PUÒ FARE **OGGI**, senza nessuna firma nuova

## 2.0 🔴 PRIMA IL VINCOLO CHE NON SI AGGIRA — **con che modello girerebbe**

**Il feed `_EXT` è fatto di barre M1. Il modello 4 (tick reali) su quei simboli NON ESISTE**
(`importa_storico_esterno.ps1` r.525, citato in `R113_CRITERI.md` §1).
👉 **Ogni corsa proposta qui sotto è MODELLO 1 (OHLC su M1). Nessuna produce un verdetto.**

**E lo scarto OHLC→tick è misurato in casa — 🔴 ed è PIÙ LARGO di quello che dice il brief:**

| motore | PF **OHLC** | PF **tick reali** | **rapporto** | fonte |
|---|---:|---:|---:|---|
| `DAX_Live5m_v1` D30EUR M5 | 1,47 | **0,857** | **1,72×** | `CHI_ALTRO_PUO_SCHIERARSI_2026-09-22.md` r.78 |
| `DAX_Live5m_v2` D30EUR M5 | 1,71 | **0,925** | **1,85×** | idem |
| **`SupRev_DOW_H4`** | **2,77** | **0,79** | 🔴 **3,51×** | `COME_ALLUNGARE_STORICO_INDICI_2026-09-09.md` §0 (contratto **REVOCATO** il 30/07) |

> **La banda «1,71-1,85» del brief è l'estremo BUONO.** Il caso peggiore misurato è **3,51×**,
> e non è un caso qualunque: è quello che ci ha fatto revocare un contratto. **Il confronto
> coi numeri a tick non è diretto, e il fattore non è uno solo.**

---

## 2.1 📋 LA LISTA, ordinata per valore/costo

**Àncora di costo, misurata e non stimata**: R113 ha fatto **18 celle su `NASUSD_EXT`
(16 anni, modello 1) in 5,4 minuti** ⇒ **~0,3 min/cella**. Le celle forex/oro `_EXT` sono su
finestre di 3-12 mesi: **costano meno, non di più.**

| # | cosa | motore / simbolo | passate | **minuti** | cosa cambierebbe il risultato |
|---|---|---|---:|---:|---|
| **A1** | 🥇 **Prova di regime su `CostToCost` `exit 0`** — la cella che il riesame notturno del 22/09 dice essere meglio di quella in vivaio | `COST_EURJPY` + `COST_GBPCAD` su `_EXT`, **4 finestre** | **8** | **~3** | 🎯 `exit 2` (in vivaio) fa **DD 12,05%**; `exit 0` fa **PF 1,3427 · n=194 · DD 9,1158%** — **sotto il muro del 10%**. Ma quei numeri sono su **una** finestra. Le 4 finestre dicono se `exit 0` regge **anche nell'ORSO e nel CROLLO**, dove `COST_EURJPY` con l'uscita vecchia fece **PF 0,02 (n=23)** nel crollo a 3 mesi e **1,69 (n=67)** su CROLLO_ANNO. **Se `exit 0` tiene dove `exit 2` è crollato, è un'uscita migliore su due assi, non su uno.** |
| **A2** | 🥈 **Le gemelle `exit 0` sugli altri due simboli** | `CHFJPY` su `_EXT` (🔴 `USDCHF` **NON ha `_EXT`**) | **4** | **~1,5** | il riesame dà `exit 0` migliore anche su CHFJPY (1,1474 / DD 7,095). **Due gemelli che tengono nelle avverse = altopiano; uno solo = picco.** ⚠️ `USDCHF` non è misurabile su `_EXT`: **casella dichiarata scoperta**, non ignorata |
| **A3** | 🥉 **Chiudere R59 su `COST_EURJPY`** — l'unica cella mai arrivata a verdetto | `COST_EURJPY`, criterio **A** (sopravvivenza) | **0** | **0** | 🟢 **COSTO ZERO: è già misurato.** R59 dice *«B e C passati — promozione **sospesa al criterio A**»*. Il criterio A confronta il DD avverso col DD OOS originale: il numero OOS è agli atti. **È una lettura, non una corsa.** |
| **A4** | 🌙 **`Nightly` su 4 finestre** — il motore più veloce della flotta notturna (**1,937 op/giorno di famiglia**, ×1,94 sopra il pavimento) | `EURUSD`+`GBPUSD` su `_EXT`; 🔴 `EURCHF` e `USDCHF` **NON hanno `_EXT`** | **8** | **~3** | il riesame lo dà morto **per rischio** (DD 11,1-22,6% a 1%) su **una sola finestra 2024-2026**. Le 4 finestre dicono se il DD è **dell'epoca** o **del motore** — e l'Emendamento B dice che **il rischio si legge a qualunque n**. ⚠️ **Metà famiglia non è misurabile**: 2 simboli su 4 senza `_EXT` |
| **A5** | 🔁 **Rifare R113 sulla SOVRAPPOSIZIONE** — la coda che R113 si è lasciato aperta | `NASUSD_EXT` **2024.09→2026.06**, 3 celle | **3** | **~2** | 🎯 **È la misura che separa le due spiegazioni del crollo di frequenza** (nel 2022 il lato short non ha aperto **NEMMENO UNA** operazione). Stesse date, stesso motore, due feed: se gli `n` combaciano col nativo di R110, **il feed è innocente e le epoche sono vere**; se no, **ogni lettura delle finestre `_EXT` porta la riserva**. R113 stesso la propone e la quota **~2 minuti** |
| **A6** | 🔴 **CHIUDERE R80 — e questo NON è una corsa `_EXT`** | `ABTG_HistoryDownloader`, **M1 dal 2018 su GBPUSD e USDJPY** | 0 passate, 1 download | **`[NON MISURATO]`** | ⚠️ **È il prerequisito di TUTTI gli altri.** Finché non è fatto, il giro nativo di R80 è **SOSPESO** e la divergenza di segno fra `_EXT` e BCM resta **[IPOTESI]**. R80 lo scrive: *«se dopo il download la divergenza restasse, riguarderebbe R50, R56 e R59»* — **cioè tutta la prova di regime.** §5.1 |

**Totale A1+A2+A3+A5 = 15 passate, ~6,5 minuti** di banco sul **PC di backtest**.
**Non è un round: è una mattinata di letture più due caffè.**

## 2.2 🛑 E QUELLO CHE **NON** SI PUÒ FARE OGGI, detto per nome

| cosa | perché no |
|---|---|
| ❌ prova di regime su **DAX** | `D30EUR_EXT` **non esiste** e il cancello è **inapplicabile** (sovrapposizione zero) |
| ❌ prova di regime su **Dow** | **non esiste un feed Dow esterno con storia in più.** Zero byte scaricati |
| ❌ prova di regime su **S&P** e **Nikkei** | 🧊 frigo: 0,203 e 0,232 contro 0,20. **Si riaprono con una misura nuova, mai abbassando la soglia** |
| ❌ qualunque **promozione di cella** o **taratura** da dati `_EXT` | **D-C `SOLO_PROVA_REGIME`, FIRMATA.** Parametri congelati, sempre |
| ❌ qualunque **contratto** (DD promesso, frequenza promessa) da `_EXT` | un feed esterno non ha lo spread di BCM, né i suoi orari, né i suoi prezzi |
| ❌ prova di regime su **`ABTG_MaxMinNotte` oro a H4/H2 su 2008 o 2013** | **`XAUUSD_EXT` parte dal 2018.** Quelle epoche si prendono **dal NATIVO** (§4) |

---

# 3. ⚖️ IL CANCELLO ZERO SUGLI INDICI — **il numero, non la scappatoia**

## 3.1 🔴 LA CORREZIONE AL BRIEF: le due misure mancanti **SONO STATE FATTE**

Il brief le dà per `[DA MISURARE]`. **Sono state eseguite da Claudio il 26/08, ore 18:03-18:04
(1,2 min), pin `03268a2`, ESITO OK, vol misurata 4/4, eventi 3/3, 0 problemi.**
Referto: `risultati_archivio/LETTURA_MISURE_LAMPO_2026-08-26.md` · foglio di lancio:
`righe/RIGA_MISURE_LAMPO_DA_MANDARE.md`.

**Misura 1 — la volatilità oraria, non più inferita:**

| simbolo | diff (fuori finestre) | **vol oraria 2025 MISURATA** | **rapporto** | metro relativo 0,20×vol |
|---|---:|---:|---:|---|
| **NASUSD** | 0,0662% | **0,3324%** | **0,199** | 🟢 **sotto — per un pelo** |
| SPXUSD | 0,0527% | **0,2602%** | **0,203** | 🧊 sopra — per un pelo |
| 225JPY | 0,0871% | **0,3747%** | **0,232** | 🧊 sopra |
| EURUSD (controllo) | 0,0041% | 0,1232% (TOT) | **0,033** | ✅ largo, come tutti i forex |

**Misura 2 — i tre eventi di diff-max: 3 su 3 sono MOVIMENTI VERI, non buchi.**
23/03/2026: NASUSD **3,43%**, 225JPY **5,28%**, SPXUSD **3,66%** simultanei (+ un micro-buco
di 13 min sul NASUSD dentro il panico) · 20/11/2025: ~2,0-2,6% su tutti e tre, zero buchi ·
09/01/2026: 225JPY **3,09%** con **60 barre su 60**.
🎯 **L'evento C era la domanda che valeva doppio, ed è SANO**: cade **fuori** dalle finestre
DST e a gennaio. **Quindi il sospetto torna tutto sul calendario, e la «malattia sessioni»
del `grxeur` su questi tre feed NON si vede.**

**Esito: firma di Claudio, 26/08 — «FIRMO FRIGO NASUSD».** Metro relativo adottato **solo
per gli indici**, **solo** con eventi spiegati + copertura ≥80%. Forex invariato a 0,05%.

## 3.2 ✅ IL CONTROLLO DI ONESTÀ, che è la cosa migliore di tutta la vicenda

L'analisi del 25/08 aveva dichiarato **PRIMA** di misurare: *«con le stime attuali i tre
indici NON passerebbero nemmeno il metro relativo (0,18-0,38 contro 0,20)»*.
La soglia **0,20** era stata fissata **il 25/08** come tetto del peggior forex promosso
(AUDJPY 0,11-0,23), **prima** di vedere le volatilità degli indici.

> ### 🎯 **E ha bocciato 2 candidati su 3. Non è stato un condono: è un metro che morde.**
> La previsione ha sbagliato di poco e **nel verso scomodo per chi la scriveva** (NASUSD è
> passato invece di essere bocciato). **Quello è il modo giusto di sbagliare.**

## 3.3 🔴 E DI QUANTO SONO FUORI — la risposta alla domanda esatta del brief

**La domanda non è «come li promuoviamo». È «di quanto sono fuori».** Ecco il numero:

| simbolo | rapporto | **scarto dalla soglia 0,20** | in % della soglia | tradotto |
|---|---:|---:|---:|---|
| NASUSD | 0,199 | **−0,001** | **−0,5%** | 🟢 dentro, ma **il bordo più sottile possibile** |
| SPXUSD | 0,203 | **+0,003** | **+1,5%** | 🧊 fuori per **un centesimo e mezzo di soglia** |
| 225JPY | 0,232 | **+0,032** | **+16,0%** | 🧊 fuori, e **non per un pelo** |

> ### ⚠️ **LA RIGA CHE MI OBBLIGO A SCRIVERE, perché è quella scomoda**
> **NASUSD sta dentro per lo 0,5% della soglia. SPXUSD sta fuori per l'1,5%.**
> Fra i due c'è **il 2% di una soglia**, cioè **meno del rumore di qualunque rimisura**.
> 🔴 **Non sto proponendo di cambiare la soglia — le soglie le firma Claudio, e questa
> soglia è valida PROPRIO perché è stata scritta prima.** Sto scrivendo che **la
> differenza fra il simbolo ammesso e il primo escluso non è una differenza di qualità
> dei dati: è un confine.** Chi legge R113 deve saperlo.

## 3.4 📐 E IL DAX, che è un caso **diverso** e va tenuto diverso

Sul DAX il rapporto **non si può nemmeno calcolare**: `diff media` richiede barre H1 in
comune fra i due feed, e **non ce n'è una**.

| serve | per fare cosa | esiste? |
|---|---|---|
| gli anni DAX **RIPARABILE** (2019, 2024, 2025, 2026) con la convenzione oraria sistemata | dare **sovrapposizione** con BCM (dal 2024.09.26) ⇒ rendere **calcolabile** la diff | ⚪ **no**: mai scaricati né riparati |
| la diff `D30EUR_EXT` vs nativo su quella sovrapposizione | **il cancello** | ⛔ non esiste |
| `grxeur` 2020-2023 contro `etxeur` 2020-2023 | trasformare *«è un altro indice»* da **[INFERITO]** a **[MISURATO]** e chiudere la scheda in `REGISTRO_TEST.md` col certificato completo | ⚪ mai fatto — **ma `etxeur` 2013-2018 è sul mirror, e 2020-2023 no** |

🚫 **Non scrivo le righe di lancio** (le scrive chi mi ha chiamato e passano dal cancello).
**Quello che le righe devono produrre**, dichiarato qui perché serva da attesa:
1. gli **zip `grxeur` 2024-2025-2026** + una **mappa oraria** che dica se la convenzione
   00:00-23:00 è riconducibile a 02:00-15:00 **senza inventare un'ora**;
2. la **diff media H1** di `D30EUR_EXT` contro il nativo BCM sulla sovrapposizione risultante,
   con **copertura** e **shift calibrato in automatico** (−6…+6, mai imposto).

### 🧪 E l'esito atteso, dichiarato PRIMA — come fece l'analisi del 25/08
> **Non mi aspetto che il DAX passi.**
> **Il motivo, ed è un conto, non un presentimento**: la copertura degli indici `_EXT` già
> promossi è **97,0%** contro il **99,2-99,6%** dei forex, cioè **3 ore su 100** dell'importato
> non trovano una barra nativa. Sul `grxeur` gli anni 2024-2026 hanno **densità 46,2-47,6
> barre/ora** contro le **58,1-59,6** degli anni sani — **il 20% di barre in meno nelle stesse
> ore**. Se la densità è quella, la copertura del DAX partirà **sotto** il 97% dei fratelli, e
> la diff **sopra** la loro. 👉 **Attesa dichiarata: rapporto DAX ≥ 0,23**, cioè **peggio del
> Nikkei, che è già in frigo.**
> ✅ **E se sbaglio, l'avrò scritto prima**, che è l'unico modo perché la misura valga.

---

# 4. 🥇 L'ORO — il caso più maturo, ma **non per il motivo che pensavamo**

## 4.1 🔴 La domanda del brief va riscritta, perché la sua premessa è falsa

> Brief: *«~20 anni di M1 e un simbolo già promosso… quali motori non hanno mai visto il
> 2008, il 2013 o il 2020?»*

**`XAUUSD_EXT` è 2018-2024.** Il 2008 e il 2013 **non ci sono**. Quindi, se la domanda si
riferiva all'`_EXT`, la risposta è **«nessun motore può averli visti lì, perché lì non ci sono»**.

🟢 **Ma la risposta vera è molto migliore: quelle epoche ce le abbiamo NATIVE, e le abbiamo
già girate.**

## 4.2 📊 Chi ha già visto i 22 anni — **R100, 23/08/2026, nativo BCM 2004.06.11 → 2026.06.30**

`risultati_archivio/R100_REFERTO.md` — corsa OHLC M1, 36 minuti, **11 sedie su 12 misurate**:

| sedia oro | TF | DD promesso | **DD 22 anni @1%** | peggior giorno | verdetto del round |
|---|---|---:|---:|---:|---|
| `EMA200_Ottimizzato` (971501) | H4 | 4,40% | **45,91%** (10,4×) | −1,91% | 🔴 REVISIONE |
| **`MaxMinNotte` (770402)** | **H2** | 5,30% | **19,72%** (3,7×) | −1,07% | 🔴 REVISIONE |
| `PunteLarry` (772343) | H1 | 3,50% | **29,74%** (8,5×) | −3,91% | 🔴 REVISIONE |
| `EMA200` (base) | H4 | n/d | **55,02%** | −2,36% | 🟡 senza metro |
| `GoldenCross_Ott` · `GoldenCross` | H1 | n/d | 25,18 · 22,34 | −1,96 · −1,95% | 🟡 |
| `PTE` | H4 | n/d | 24,22 | −1,24% | 🟡 |
| `SupRev_Multi` · `_Multi_Ott` | H4 | n/d | 7,36 · 16,90 | −1,60 · −1,85% | 🟡 |
| 🟢 **`SupertrendReversal`** | H4 | n/d | **2,18** | −0,54% | 🟡 **il più pulito della flotta oro** |
| `WOL` | D1 | n/d | 1,17 *(finestra accorciata dal 2008)* | −0,06% | 🟡 |
| `SupertrendInvert` | H1 | — | ⛔ **NON MISURATA** (gate: EA del 2025) | — | ⛔ |

🔴 **Chi NON ha visto i 22 anni, per nome:** **`SupertrendInvert`** (fermato dal gate) e
**`Gold_Ichimoku`** (non misurabile per costruzione: l'EA non esporta risultati).
**Tutti gli altri undici li hanno visti.**

## 4.3 🎯 CHE COSA DIREBBE UNA PROVA DI REGIME CHE OGGI NON SAPPIAMO

**R100 ha misurato il DRAWDOWN e il peggior giorno. NON ha pubblicato n né PF** (il referto
lo dichiara: *«(non pubblicato)»*). **E non ha decomposto i 22 anni in regimi.**

👉 **La domanda aperta, quindi, è questa — ed è precisa:**
> ## **Il DD del 19,72% di `MaxMinNotte` oro è UN singolo episodio in UNA epoca, o è il
> metronomo del motore che si ripete in tutte e quattro le stagioni?**

**Perché la differenza vale una sedia:**
- se è **un episodio** (es. tutto dentro il 2011-2013, il grande orso dell'oro), allora il
  DD del contratto va riscritto **con un filtro di regime**, e la sedia può tornare;
- se è **il metronomo**, il contratto va riscritto e basta, o la taglia scende.
- 🔴 **E c'è un muro che non si muove comunque**: FTMO ha un DD **statico del 10%**, il preset
  FTMO porta `InpRiskPercent=2.00`, e **19,72% @1% fa ~39% @2%**. Nessun regime cambia questo.

## 4.4 💰 LA MISURA PIÙ CORTA CHE RISPONDE, col costo

| # | passo | costo | perché è questo |
|---|---|---|---|
| **O1** | 🟢 **Recuperare i CSV di `r151a` e `r170b`** dal banco — due round di USCITA su questa identica sedia, **girati il 15-17/09 e mai caricati** | 🟢 **ZERO tempo macchina** (è un trasporto, bloccato dal 13/09 insieme ad altri 47 round) | **La gestione dell'uscita — punto 3 del certificato — potrebbe essere già misurata e nessuno lo sa.** Si guarda prima di spendere un minuto |
| **O2** | 🥇 **`MaxMinNotte` oro, 4 finestre di regime sul NATIVO BCM** — parametri congelati al binario `5fc0bc31` (quello che ha misurato il contratto) | **4 passate** · **~8-10 min** *(àncora: R100 ha fatto 11 sedie × 22 anni in 36 min ⇒ ~3,3 min/sedia per 22 anni; 4 finestre da 10-12 mesi costano meno)* | 🎯 **Spacca il 19,72% in quattro numeri.** ORSO 2022 · CROLLO 2020 · TORO 2021 · LATERALE 2019 — e **sono tutte dentro il nativo**, che parte dal 2004. **Nessun `_EXT`, nessun cancello, nessuna firma nuova: è il nostro feed.** Il criterio A (sopravvivenza) e il B (tenuta) sono già congelati dal 14/08 |
| **O3** | 🔍 **Aggiungere due finestre «d'epoca» che il set standard non ha** | **2 passate** · **~5 min** | Le 4 finestre di casa stanno tutte nel **2019-2022**. L'oro ha avuto **due regimi che nessun motore nostro ha mai visto giudicati**: il **2008** (crollo Lehman, l'oro fa −30% e poi +?) e il **2013** (−28% in un anno, il vero orso dell'oro). 🔴 **Se il DD del 19,72% sta lì dentro, lo scopriamo con due passate.** ⚠️ Sono finestre **nuove**: vanno **dichiarate come tali** e il criterio va scritto prima |
| **O4** | ⚪ Importare l'oro esterno | **~5-10 min** + cancello | 🛑 **NON lo propongo per primo, e il motivo è un numero**: `XAUUSD_EXT` copre 2018-2024, il **nativo copre 2004-2026**. Sull'oro l'esterno è **strettamente peggio**. Ha senso **solo** come **secondo feed di controllo** (§5.3), mai come fonte di storia |

> ### 🎯 **IL PUNTO CHE VALE, in una riga**
> **Sull'oro non ci manca lo storico: ci manca la DECOMPOSIZIONE di uno storico che abbiamo
> già girato.** O1+O2+O3 = **6 passate, ~15 minuti**, zero firme nuove, zero dati esterni.
> **È la cosa col miglior rapporto valore/costo di tutto questo dossier.**

---

# 5. 🧪 I CONTRO-ESEMPI — quello che ho provato a rompere, e cosa si è rotto

## 5.1 🔴 **LA FRASE DEL BRIEF SI ROMPE, E SI ROMPE CON UN NUMERO DI CASA**

> Da rompere: *«il feed `_EXT` è promosso, quindi i suoi numeri sono confrontabili con quelli BCM»*

**SI ROMPE. Ed è già scritto in casa, in `REFERTO_ROUND80_REGIME_PTE.md` §2:**
stessa cella, stessa finestra, **stessi parametri**, cambia **solo il feed**:

| cella | finestra | **`_EXT`** | **NATIVO BCM** | |
|---|---|---:|---:|---|
| `PTEJPY_VIVA` | CROLLO_ANNO | **−2.863** (n52) | **+601** (n48) | 🔴 segno opposto |
| `PTEJPY_VIVA` | TORO | **+203** (n36) | **−4.660** (n22) | 🔴 segno opposto |
| `PTEGBP_VIVA` | ORSO | **+1.245** PF **1,62** (n18) | **−4.646** PF **0,23** (n16) | 🔴 segno opposto |
| `PTEGBP_VIVA` | TORO | **+1.362** (n37) | **−914** (n17) | 🔴 segno opposto |

**Quattro cambi di segno su quattro.** E non è la sola crepa:

**(a) Il cancello ZERO non misura quello che serve al backtest.** La formula è
`100 × Σ|Close_H1_importata − Close_H1_nativa| / Σprezzo`
(`ABTG_ImportaStoricoEsterno.mq5` rr.497-511). 👉 **Confronta le CHIUSURE ORARIE.** Un
backtest modello 1 fa scattare stop e target sul **massimo e minimo della barra M1**, che
il cancello **non guarda mai**. Due feed possono chiudere l'ora allo stesso prezzo e avere
percorsi interni diversi. **Il cancello certifica che i due feed guardano lo stesso oggetto.
Non certifica che producano lo stesso trade.**

**(b) E lo spread non entra proprio.** Nel tester lo spread è **quello che si imposta**, non
quello storico. Misurati su BCM: NASUSD **180 pt**, U30USD **200**, D30EUR **280**,
225JPY **35**. Un feed esterno non ha **nessuno** di questi numeri dentro. R55 ha misurato
che **1,5 punti indice sfondano il cancello del 10% sull'ORB**.

**(c) E il modello è diverso.** §2.0: fattore OHLC→tick misurato **1,72× · 1,85× · 3,51×**.

### 🟡 MA — e questa è la parte onesta — **R80 NON conclude «i dati importati sono sbagliati»**

Le operazioni sul nativo sono **sistematicamente MENO in tutte e sedici le celle
confrontabili** (46→32, 36→22, 37→17, 51→40, 18→16). **Un difetto di qualità darebbe
differenze a macchie; un calo sistematico del 20-55% ha una spiegazione più semplice:**
le **M1 native del 2019-2022 in locale NON C'ERANO** (sonda 17/08: `da scaricare (parziale)`
su GBPUSD e USDJPY), e senza M1 il tester le costruisce dai TF superiori ⇒ meno segnali.

🔴 **E ho verificato oggi se quel download è mai stato fatto: NO.** L'unico referto di
`ABTG_HistoryDownloader` in repo è `ABTG_StoricoScaricato.csv` (08/09) e contiene
**solo `D30EUR` e `U30USD`** — **zero forex**. 👉 **La cosa che R80 chiama *«la più
importante da chiudere di tutto questo blocco»* è aperta da 5 settimane.**

> ## ⚖️ **LA CONCLUSIONE, che è più sfumata della frase e più utile:**
> **Il cancello ZERO passato dice che i due feed guardano lo stesso oggetto** (bias mediano
> misurato **~0**: +0,0013 / +0,0062 / +0,0075% — **niente basis cash-vs-CFD**).
> **NON dice che i numeri sono confrontabili fra feed.** Ed è esattamente quello che i
> criteri di casa scrivono già dal 14/08:
> *«Il confronto di merito si fa **SEMPRE sullo stesso feed**… mai "`_EXT` 2022 contro BCM
> 2025"»* (`PROVA_REGIME_CRITERI.md` §2). 🎯 **Il brief ha proposto una frase che i nostri
> stessi criteri vietano. Il contro-esempio non ha trovato una crepa nuova: ha trovato che
> la regola c'era già, e che R80 l'ha verificata sul campo.**

## 5.2 🧪 Contro-esempio a ogni «si può fare oggi» del §2

| proposta | **l'argomento per cui NON si può** | regge? |
|---|---|---|
| **A1/A2** `CostToCost exit 0` su 4 finestre | *«`exit 0` sembra migliore perché l'hai pescata DENTRO un CSV dopo aver visto i numeri: è il picco di un'altra griglia»* | 🟡 **REGGE A METÀ, e va detto.** `exit 0` **non** è stata scelta prima. **Ma**: (i) non è un picco isolato — è la migliore su **tre gemelli** (EURJPY, USDCHF, CHFJPY), e tre gemelli nello stesso verso sono un **altopiano**, non una cella che sporge; (ii) **la prova di regime è proprio il prezzo che si paga per l'allargamento** (regola del 19/08). 👉 **Quindi la corsa si fa, ma il suo esito NON promuove niente**: se `exit 0` tiene, il risultato è *«l'uscita va rimessa ad asse in un round vero a tick»*, non *«cambiamo la cella»* |
| **A4** `Nightly` 4 finestre | *«metà famiglia non ha `_EXT` (EURCHF, USDCHF): misuri 2 simboli su 4 e chiami "famiglia" il risultato»* | 🔴 **REGGE, ed è un limite vero.** La corsa si fa lo stesso — **il RISCHIO si legge a qualunque n** (Emendamento B) — ma il verdetto è **per SIMBOLO**, mai per famiglia, e le due caselle mancanti vanno scritte accanto al numero |
| **A5** R113 sulla sovrapposizione | *«confronti `_EXT` con `R110` che è nativo: è esattamente il confronto fra feed che il §5.1 vieta»* | 🟢 **NON REGGE, ed è il caso che salva la regola.** Qui il confronto **non è di MERITO** (PF, profitto): è sul **CONTEGGIO DELLE OPERAZIONI `n`** a parametri identici e date identiche. `n` **non dipende dallo spread** e non dipende dal modello di riempimento: dipende da quante volte la condizione d'ingresso si accende. 🎯 **È la misura di CALIBRAZIONE del feed, non un verdetto sul motore** — ed è proprio per questo che funziona |
| **§4 O2/O3** oro sul nativo | *«22 anni sono tanti: stai violando l'Emendamento D, che dice che il difetto ricorrente è il contrario»* | 🟢 **NON REGGE.** L'Emendamento D avverte contro le finestre **troppo corte** (110 file prova su 21 mesi). E l'Emendamento A dice che l'unità è **l'operazione**: R103 ha fatto **n=693** su 6,5 anni ⇒ ~107 op/anno ⇒ **una finestra da 12 mesi dà ~107 operazioni**, **sotto il muro dei 150**. ⚠️ **Quindi il MERITO su una finestra singola resta SOSPESO** e va scritto. **Il RISCHIO no: si legge a qualunque n.** 👉 La corsa si fa **per il rischio**, e il merito si dichiara sospeso. Questo *è* il contro-esempio che morde, e cambia come si legge il risultato |

## 5.3 🧪 E un contro-esempio al mio stesso §1.3

> *«Hai scritto che sull'oro e sul forex il nativo è più profondo, quindi l'`_EXT` non serve.
> Ma allora perché la prova di regime del 15/08 fu costruita proprio lì?»*

🟡 **La domanda è giusta, e la mia frase va precisata.** L'`_EXT` su forex/oro **serve a una
cosa che il nativo non può fare: essere un SECONDO FEED.** Due feed indipendenti che dicono
la stessa cosa valgono più di dieci anni in più su uno solo — è lo stesso argomento con cui
`ORO_M1_2021_2026_PIANO` decide di **non concatenare** OANDA e HistData e di **confrontarli**.
👉 **Frase corretta: «sull'oro e sul forex l'`_EXT` non è la fonte della STORIA; è lo
strumento della RIPRODUZIONE».** E in quel ruolo **A5 e A6 sono esattamente il lavoro giusto.**

---

# 6. 🕳️ NON COPERTO — le caselle che questo dossier **non** chiude

| # | buco | perché non l'ho chiuso | costo per chiuderlo |
|---|---|---|---|
| **N1** | 🔴 **La divergenza `_EXT` vs nativo di R80 resta [IPOTESI]** | serve scaricare le M1 native 2018+ su GBPUSD/USDJPY: è un'azione su una macchina, e io sono in sola lettura | **`[NON MISURATO]`** — dipende dalla velocità del feed BCM |
| **N2** | 🔴 **`n` e `PF` di R100 (22 anni, 11 sedie oro) NON sono pubblicati** e **il CSV non è in repo** (cercato: esistono solo `R100_CRITERI.md` e `R100_REFERTO.md`) | il dato grezzo è nello zip `R100_ORO_FLOTTA_CORSA_20260823_1449`, che non è nel repo | recupero zip: **`[NON MISURATO]`** |
| **N3** | 🔴 **I CSV di `r151a` e `r170b` (uscita oro) sono fermi sul banco dal 15-17/09**, insieme ad altri **47 round** | trasporto bloccato dal 13/09 | 🟢 **zero tempo macchina** — è un trasferimento |
| **N4** | 🟡 **La diff dei forex `_EXT` non è mai stata spaccata dentro/fuori finestre DST** | richiederebbe un re-import v2 dei forex. ⚠️ **Asimmetria da dichiarare**: gli indici sono giudicati sul «fuori finestre», i forex sull'intero. §14-bis.2 dice che il numero forex **può solo scendere**, quindi l'asimmetria è **a sfavore dei forex** — ma resta un'asimmetria | re-import: **~5 min** |
| **N5** | 🟡 **La diff forex è misurata su ~7 anni di sovrapposizione, quella degli indici su ~22 mesi** | è una conseguenza strutturale (il nativo indici parte dal 2024.09.26). **I due numeri non hanno lo stesso peso statistico**, e nessun referto lo dice | non chiudibile: è il dato |
| **N6** | ⚪ **`E50EUR` · `F40EUR` · `100GBP` · `200AUD`: mai scaricati** — quattro indici che HistData ha dal 2010 e che hanno un **gemello nativo BCM** su cui il cancello **si calcola** | fuori perimetro (nessun download) | ~10-15 min/simbolo. ⚠️ **E prima va rifatta la frontiera `stop ≥ 40 × spread`**: `E35EUR` sta a **540 pt**, `E50EUR` a **200** |
| **N7** | ⚪ **Il Dow profondo Dukascopy (2012+): zero byte** | il ritmo `curl` è misurato **solo su 222 giorni** (0,2 h). **`[NON MISURATO]` se regge su 12 anni.** Le due àncore sono distanti **30×** | serve una **tranche pilota da ~200 giorni** per misurare il ritmo vero. Spazio disco: **~10 GB** |
| **N8** | ⚪ **`225JPY_EXT` non è mai stato riscaricato su 2010-2026** (ha solo 2019+) | non era in D-B | ~3-4 min. 🛑 **Ma è in frigo a 0,232: allungarlo non lo promuove** |
| **N9** | 🔴 **`SupertrendInvert` e `Gold_Ichimoku` non hanno MAI visto i 22 anni dell'oro** | `SupertrendInvert` fermato dal gate (EA del 2025); `Gold_Ichimoku` **non esporta risultati** — è un difetto del codice, non dei dati | il secondo richiede una **modifica all'EA**: è fuori dal mio perimetro |
| **N10** | 🟡 **La cache OANDA 2006-2020 (548 MB) vive in `/tmp` del CLOUD** | è **effimera**: sparisce con la sessione. 🟢 È **riproducibile** dalla sorgente (`FutureSharks/financial-data`, raggiungibile), ma **oggi non è "in casa"** — e il brief la descrive come se lo fosse | ri-download dal cloud: minuti. Ma **non è sul PC di Claudio** |
| **N11** | 🟡 **Nessuno ha mai misurato la correlazione DAX↔Stoxx sui 21 mesi di sovrapposizione BCM** | è il presupposto della «strada F» (proxy europeo) e resta **assunto, non misurato** | dati già in casa: è un calcolo, non un download |

---

# 🏆 E LA COSA BUONA, che va detta perché è vera

Questo dossier sembra un elenco di porte chiuse. **Non lo è, e i numeri lo dicono.**

- 🟢 **Il DAX lungo l'abbiamo.** Nove anni, 1,7 M barre, **zero barre fuori banda**, prezzi
  verificati contro la realtà a due estremi. **Scaricato, convertito, in cassaforte.** Quello
  che manca non è il dato: è **un ponte di sovrapposizione**, e sappiamo quali quattro anni
  lo costruirebbero.
- 🟢 **Il frigo ha una chiave e ha funzionato.** Una soglia scritta **prima**, due misure
  fatte **dopo**, **due bocciature su tre** e una firma. In un progetto che deve schierare
  sedie il 1° ottobre, **avere un metro che boccia è una notizia buona.**
- 🟢 **Il sospetto peggiore di tutti — il basis cash-vs-CFD — è MISURATO ed è ~ZERO** su
  tutti e tre gli indici. Il feed esterno e il nostro CFD **guardano lo stesso oggetto**.
- 🟢 **Sull'oro non ci manca niente da comprare e niente da scaricare**: ventidue anni nativi,
  già girati una volta, che aspettano solo di essere **letti per regime**. Sei passate.
- 🟢 **E la correzione di Claudio del 22/09 ha fruttato**: mi ha fatto trovare una firma
  dimenticata (**NASUSD è fuori dal frigo da quasi un mese**), nove anni di DAX in un
  cassetto, e un mirror che dal cloud si apre mentre la sorgente ufficiale è murata.
  **Aveva ragione lui, e questa è la terza volta che succede questo mese.**

> ## 🎯 **Non ci manca una tecnologia, e nemmeno un dato. Ci manca di LEGGERE quello che abbiamo già girato — e sull'oro sono quindici minuti di banco.**

---

_📌 Nessun EA, preset, parametro, taglia o forward è stato toccato. Nessun round lanciato,
nessuna riga consegnata, nessun import eseguito, nessun dato scaricato (le uniche richieste
di rete sono state **header HTTP a vuoto** su `raw.githubusercontent.com` per misurare la
copertura del mirror, e due test di raggiungibilità **falliti con 403** su `histdata.com` e
`datafeed.dukascopy.com`). Nessuna soglia proposta o modificata: **le soglie le firma Claudio.**_
