# 🪦📚 I MORTI E LO STORICO — per ognuno, la prova di regime si può fare OGGI?

**23/09/2026** · repo `/home/user/GITHUB`, branch `lavoro` · famiglia round **`R217`**
🛑 **SOLA LETTURA, ZERO TEMPO MACCHINA.** Nessun round lanciato, **nessuna riga di lancio
scritta** (le scrive chi mi ha chiamato), nessun import eseguito, niente VPS, niente forward,
nessun preset toccato, nessuna sedia promossa o spenta, **nessuna soglia proposta o
modificata**. Il conto reale `10105439` non compare in nessun comando. L'unica cosa scritta
è questo file, più il commit.

Nasce dal fatto del 22-23/09: per mesi abbiamo scritto che la **prova di regime** (regola **C**
dell'Emendamento della Finestra) *«non è possibile»*. 🔴 **È vero sugli indici BCM. È falso su
forex e oro** — e la mappa (`report/LO_STORICO_ESTERNO_MAPPA_2026-09-23.md`) lo ha dimostrato
ieri. Questo dossier fa il passo successivo: **candidato per candidato, si può o no, e cosa costa.**

---

# 0. 🥁 LA NOTIZIA IN SEI RIGHE

> ### 1️⃣ 🟢 **LA SCOPERTA CHE CAMBIA LA STRADA: SU FOREX E ORO LA PROVA DI REGIME NON HA BISOGNO DI `_EXT`.**
> Le quattro finestre di casa sono **LATERALE 2019 · CROLLO 2020.02-04 · TORO 2021 · ORSO
> 2022** (`prove/PROVA_REGIME_CRITERI.md` §3). **Stanno TUTTE dentro lo storico NATIVO BCM**
> di forex e oro. 👉 Si gira sul **nostro feed**, e il problema del segno che si inverte
> (§8.1) **scompare per costruzione**. L'`_EXT` era la strada del 14/08 perché le M1 native
> non erano a disco — **e quel motivo è caduto il 24/08** (R102: 9,6-10,0 M barre M1 scaricate
> per simbolo, `COMPLETO`).
>
> ### 2️⃣ 🟢 **E TRE DELLE QUATTRO FINESTRE SONO GIÀ GIRATE, NATIVE, A COSTO ZERO.**
> `R103_REFERTO_DRIVER_FOREX_METALLI_20260824_1922.txt` contiene, per **25 sedie forex/metalli**,
> la finestra **2020.01.01 → 2026.06.30 nativa** con **la spina dorsale ANNO PER ANNO** (n e
> netto EUR per ogni anno). **CROLLO 2020, TORO 2021 e ORSO 2022 sono lì dentro, misurati.**
> Nessuno li ha mai letti come prova di regime. **Costo per leggerli: zero minuti.**
>
> ### 3️⃣ 🔴 **MA LA «MINIERA» DEL CAMPIONE SOTTILE SU `_EXT` È MISURATA, E NON C'È.**
> L'unica prova di regime mai girata su un indice `_EXT` — **R113, `SupRev_NAS_H1` su
> `NASUSD_EXT`, 27/08** — ha prodotto sulle quattro finestre canoniche **8 · 7 · 3 · 5
> uscite**, cioè **~4 · 3 · 1 · 2 POSIZIONI**. Non «un campione piccolo»: **un campione che
> non c'è**. E la frequenza misurata su `_EXT` è **13,3 op/anno** contro le **77 op/anno**
> dello stesso motore su BCM nativo ⇒ per 300 operazioni servirebbero **22,5 anni**, e
> `NASUSD_EXT` ne ha **15,7**. 👉 **Sul Nasdaq lo storico lungo NON porta il campione.**
>
> ### 4️⃣ 🥇 **IL VERO RIAPRIBILE È L'ORO, E LA DOMANDA HA GIÀ MEZZA RISPOSTA IN CASA.**
> `MaxMinNotte` XAUUSD H2 (sedia `770402`): **DD 10,64% @1% su 2020-2026** (R103, n=693) contro
> **19,72% @1% su 2004-2026** (R100). 🎯 **I 9 punti di drawdown in più NON stanno nei sei anni
> recenti: stanno nel 2004-2019.** La domanda *«un episodio o il metronomo?»* si chiude con
> **4 passate native** — nessun cancello, nessuna firma, nessun dato esterno.
>
> ### 5️⃣ 🔴 **E UN DIFETTO TROVATO OGGI CHE COSTA UN CANDIDATO INTERO: `ABTG_Nightly` È STATO GIUDICATO SU 21 MESI PER UN ERRORE DI COPIA.**
> `prove/ABTG_Nightly_EURCHF_00_conta.txt` r.73 porta `@DAQUANDO 2024.09.26` e spiega:
> *«è il pavimento che SAPPIAMO esistere su questo broker (**misurato sugli indici** il 08/09)»*.
> 🔴 **È il pavimento degli INDICI, applicato a una coppia FOREX.** `EURCHF` su BCM parte dal
> **1993.04.27**, `USDCHF` dal **1971.01.03**. Lo stesso file scriveva: *«se il campione
> uscisse sottile, la prima cosa da fare è misurare la profondità, non cambiare i parametri»*.
> **Il campione è uscito sottile (n=63/85) e la profondità non è mai stata guardata — benché
> fosse misurata dal 17/08.**
>
> ### 6️⃣ ⚖️ **E LA FRASE CHE MI È STATO CHIESTO DI ROMPERE SI ROMPE, IN QUATTRO PUNTI.**
> *«Se il motore sopravvive a quattro epoche su `_EXT`, allora è robusto»* è **falsa**, e non
> per opinione: R80 (segno invertito 4/4 cambiando solo il feed) · R113 (le quattro finestre
> danno 1-4 posizioni: non c'è niente da far sopravvivere) · lo **spread del banco `_EXT` è
> `[NON MISURATO]` e forse ZERO** (R113 lo dichiara, con due meccanismi alternativi nel
> sorgente) · e le quattro finestre sommano **37 mesi**, che per un motore H1/H4 sono **sotto
> il muro dei 150 per costruzione**. §9.

---

# 1. 🔴 IL VINCOLO CHE NON SI AGGIRA — scritto qui una volta, e ripetuto in ogni riga

**Il feed `_EXT` è fatto di BARRE M1 importate, non di tick.** Una corsa su `_EXT` **NON è
modello 4**: è **modello 1 (OHLC su M1)**. Il modello 4 su quei simboli **non esiste**
(`importa_storico_esterno.ps1` r.525, citato in `R113_CRITERI.md` §1).

**Il fattore OHLC→tick è misurato in casa, ed è largo:**

| motore | PF **OHLC** | PF **tick reali** | rapporto | fonte |
|---|---:|---:|---:|---|
| `DAX_Live5m_v1` D30EUR M5 | 1,47 | 0,857 | **1,72×** | `CHI_ALTRO_PUO_SCHIERARSI_2026-09-22.md` r.78 |
| `DAX_Live5m_v2` D30EUR M5 | 1,71 | 0,925 | **1,85×** | idem |
| `SupRev_DOW_H4` | 2,77 | 0,79 | 🔴 **3,51×** | `COME_ALLUNGARE_STORICO_INDICI_2026-09-09.md` §0 |

**E c'è di peggio, ed è misurato**: `REFERTO_ROUND80_REGIME_PTE.md` §2 — stessa cella, stessa
finestra, **stessi parametri**, cambia **solo il feed**, e il **segno si inverte QUATTRO volte
su quattro** (`PTEJPY_VIVA` CROLLO_ANNO −2.863 `_EXT` / +601 nativo · TORO +203 / −4.660 ·
`PTEGBP_VIVA` ORSO +1.245 / −4.646 · TORO +1.362 / −914).

> ## 👉 **QUINDI: la prova di regime su `_EXT` risponde a UNA domanda sola — «questo motore
> sopravvive a un'epoca diversa?» — e NON produce un PF confrontabile con quelli a tick.**
> Il cancello ZERO certifica che i due feed **guardano lo stesso oggetto**. **Non** certifica
> che i numeri si confrontino. I criteri di casa lo dicono dal 14/08:
> *«il confronto di merito si fa **SEMPRE sullo stesso feed**»* (`PROVA_REGIME_CRITERI.md` §2).

## 1.1 🟢 E LA CONSEGUENZA CHE NESSUNO AVEVA TIRATO: **su forex e oro si evita il problema**

Il pavimento dei **tick reali BCM** è misurato: **forex 2024.07.05** · **indici 2024.09.26**
(`NOTA_PAVIMENTO_TICK_FOREX_2026-09-01.md`, `misura_tick/REFERTO_*`). 👉 **Qualunque finestra
2019-2022 è modello 1 anche sul nativo.** Nativo ed `_EXT` sono quindi **pari** sul modello.

Ma non sono pari su tutto il resto:

| | corsa 2019-2022 su **`_EXT`** | corsa 2019-2022 su **NATIVO BCM** |
|---|---|---|
| modello | 🟠 1 (OHLC M1) | 🟠 1 (OHLC M1) — **pari** |
| feed | 🔴 **altro broker** (segno invertito 4/4 in R80) | 🟢 **il nostro** |
| orari di seduta | 🔴 di HistData (shift +5 calibrato) | 🟢 di BCM |
| spread del banco | 🔴 **`[NON MISURATO]`, forse ZERO** (R113) | 🟢 spread corrente del simbolo (convenzione R100/R102/R103) |
| cancello / firma | 🔴 serve | 🟢 **nessuno** |
| profondità forex/oro | 7 anni (2018-2024) | 🟢 **22-27 anni** |

> ## 🎯 **Sul forex e sull'oro l'`_EXT` non è la fonte della STORIA: è, al massimo, un SECONDO
> FEED di riproduzione. La storia ce l'ha il nostro broker, ed è più profonda.**

---

# 2. 🗺️ LA MAPPA DEI SIMBOLI — misurata, non assunta

**Fonte unica per il nativo**: `risultati_archivio/sonda_storico_17-08/215D85D7_ABTG_InfoBroker.csv`
(59 simboli su 59, letta oggi riga per riga). Per l'`_EXT`:
`report/LO_STORICO_ESTERNO_MAPPA_2026-09-23.md`.

| simbolo | **nativo BCM** | barre H1 a disco | **`_EXT`** | 4 finestre 2019-2022 native? |
|---|---|---:|---|---|
| `EURUSD` | **1971.01.03** | 100.000 🔒 | ✅ promosso 0,0041% | 🟢 **SÌ** |
| `GBPUSD` | **1993.05.11** | 100.008 🔒 | ✅ 0,0052% | 🟢 **SÌ** |
| `USDJPY` | **1971.01.03** | 100.008 🔒 | ✅ 0,0054% | 🟢 **SÌ** |
| `EURJPY` | **1993.04.26** | 100.000 🔒 | ✅ 0,0063% | 🟢 **SÌ** |
| `CHFJPY` | **1992.02.18** | 58.182 | ✅ 0,0080% | 🟢 **SÌ** |
| `AUDJPY` | **1993.05.16** | 58.447 | ✅ 0,0090% | 🟢 **SÌ** |
| `GBPCAD` | **2007.08.21** | 56.982 | ✅ 0,0072% | 🟢 **SÌ** |
| **`XAUUSD`** | **2004.06.11** (22,05 anni) | 100.000 🔒 | ✅ 0,0110% (solo 2018-2024) | 🟢 **SÌ — e già girato, R100** |
| `USDCHF` | **1971.01.03** | 57.535 | 🔴 **nessuno** | 🟢 **SÌ, sul nativo** |
| `EURCHF` | **1993.04.27** | 55.685 | 🔴 **nessuno** | 🟢 **SÌ, sul nativo** |
| `GBPJPY` | **1993.04.18** | **28.723** (~4,6 anni) | 🔴 nessuno | 🟠 **sì, ma serve il download** |
| `XAGUSD` | **2008.11.07** | **26.036** (~4,2 anni) | 🔴 nessuno | 🟠 **sì, ma serve il download** |
| `NASUSD` | 2024.09.26 `COMPLETO` | 10.861 | 🟢 **`NASUSD_EXT` AMMESSO** (2010.11→2026.07, 15,71 anni) | 🔵 **solo su `_EXT`** |
| `SPXUSD` | 2024.09.26 `COMPLETO` | 10.860 | 🧊 **FRIGO** (0,203 vs 0,20) | ❌ **NO** |
| `225JPY` | 2024.09.26 `COMPLETO` | 11.009 | 🧊 **FRIGO** (0,232 vs 0,20) | ❌ **NO** |
| `D30EUR` | 2024.09.26 `COMPLETO` | 10.553 | ⚪ CSV 2010-2018 **mai importato** — sovrapposizione **ZERO** ⇒ cancello **INAPPLICABILE** | ❌ **NO** |
| `U30USD` | 2024.09.26 `COMPLETO` | 10.859 | ⛔ **non esiste**: HistData il Dow non ce l'ha; `U30USD_DK` copre 2024-10→2025-06 = **zero giorni in più** | ❌ **NO** |
| `F40EUR` | 2024.09.26 `COMPLETO` | 6.713 | ⚪ HistData `frxeur` esiste, **mai scaricato** | ❌ **NO** |
| `E50EUR` | 2024.09.26 `COMPLETO` | 7.499 | ⚪ HistData `etxeur` esiste, **mai scaricato** | ❌ **NO** |
| `100GBP` | 2024.09.26 `COMPLETO` | 10.338 | ⚪ HistData `ukxgbp` esiste, **mai scaricato** | ❌ **NO** |
| `E35EUR` | 2024.09.26 `COMPLETO` | — | ⛔ **non è fra i dieci indici HistData** | ❌ **NO** |

🔒 = **il numero 100.000 è il tetto «Max barre nel grafico» di MT5, non la profondità.**
Cinque simboli con profondità reali diversissime (1971 · 1993 · 2004) si fermano tutti allo
stesso numero tondo (sonda 17/08 §3-bis).

## 2.1 ⚠️ TRE CORREZIONI CHE DEVO FARE AL BRIEF, e tutte e tre contano

1. 🔴 **Il pavimento OPERATIVO del forex BCM non è il 1971 né il 1993: è il 1999.01.**
   **Misurato**, non dedotto: R102 Blocco 1 — GBPUSD prima operazione **1999.01.14**, EURUSD
   **1999.01.18**, AUDUSD **1999.01.07**. *«Prima del gennaio 1999 non producono nessuna
   operazione su nessuno dei tre»* ⇒ il numero onesto è **~27 anni**, non 33 né 55.
   👉 Non tocca la prova di regime (le finestre sono 2019-2022), ma **tocca la promessa
   «EURJPY dal 1993»**: su `EURJPY` c'è anche una ragione indipendente — **l'euro non
   esisteva prima del 1999.01.04**. La profondità *usabile* di `EURJPY` è **27,5 anni**.
2. 🟢 **`da scaricare (parziale)` NON è un blocco.** R100 §3.7 lo dice e R100 lo ha fatto:
   *«il tester completa da solo mentre gira»*. R100 ha girato **22 anni d'oro OHLC M1 in
   36 minuti per 11 sedie**, con lo scarico dentro la prima passata. **Non è un acquisto e
   non è nemmeno un passo separato obbligatorio.**
3. 🟢 **E il tetto delle 100.000 barre NON vale per il tester** — su questo il brief ha
   ragione, ed è dimostrato da due round: **R100** (oro 2004→2026, e il driver SEGNALA quando
   una finestra è accorciata: lo ha fatto su `WOL`, *«finestra ACCORCIATA dal 2008»*, e su
   nessun altro) e **R102** (GBPUSD 27,5 anni, n=522). L'`[INCERTO]` della sonda §3-bis
   **è chiuso dai fatti**.

---

# 3. 💰 LE ÀNCORE DI COSTO — tutte misurate in casa, nessuna stimata

| round | cosa ha fatto | durata | **costo unitario** |
|---|---|---:|---:|
| **R113** (27/08) | 18 celle `NASUSD_EXT`, finestre 1-2 anni, modello 1 | **5,4 min** | 🎯 **0,30 min/cella** |
| **R103** (24/08) | 25 sedie forex+metalli **NATIVE**, 6,49 anni, modello 1 | **36 min** | **1,44 min/sedia** |
| **R100** (23/08) | 11 sedie **oro NATIVO**, 22,05 anni, modello 1 | **36 min** | **3,3 min/sedia** |
| **R102 B1** (24/08) | 3 sedie forex **NATIVE**, 27,5 anni, modello 1 | **19 min** | **6,3 min/sedia** |

**Come le uso.** Le quattro finestre di regime sommano **37 mesi = 3,08 anni**. Riscalando
R103 (1,44 × 3,08/6,49) si ottiene **0,68 min/cella**; l'àncora R113 dà **0,30**.
👉 **Banda dichiarata: 0,30 min/cella (àncora del brief) — 0,70 min/cella (tetto prudente).**
Tutte le cifre di questo dossier sono scritte **con tutte e due**, mai con una sola.

📌 **Convenzione di casa**: una «cella» = un CSV = **2 passate** (la coppia gemella sul magic,
cancello G1 di determinismo — R113 l'ha usata su tutti e 18 i file). **Quando scrivo "passate"
sono già il doppio delle celle.**

🖥️ **E girano sul PC DI BACKTEST**, non sul VPS: firma di Claudio del 21/09 (*«sì, i round sul
pc di backtest»*), e il terminale banco `50504400` (`C:\MT5_Backtest`) resta **SPENTO** mentre
la challenge opera.

---

# 4. 🧨 LA TABELLA MADRE

**Legenda «prova di regime possibile OGGI»**: 🟢 **SÌ NATIVO** (nessun cancello, nessuna firma) ·
🔵 **SÌ ma solo su `_EXT`** (numeri non confrontabili coi tick, §1) · 🟠 **SÌ, ma serve un
download prima** · ❌ **NO**, col motivo per nome.
🔴 **Le quattro finestre sono SEMPRE le stesse** (`PROVA_REGIME_CRITERI.md` §3):
**LATERALE 2019.01.01-2019.12.31** · **CROLLO 2020.02.01-2020.04.30** · **TORO
2021.01.01-2021.12.31** · **ORSO 2022.01.01-2022.10.31**.

| # | candidato (verdetto attuale) | simbolo su cui è stato bocciato | storico disponibile | **possibile oggi?** | quattro finestre | celle | **passate** | **minuti** (0,30 / 0,70) |
|---|---|---|---|---|---|---:|---:|---:|
| **1** | 🥇 `MaxMinNotte` **oro** `770402` — 🔴 REVISIONE (DD 19,72% @1% su 22 anni) | **XAUUSD** | 🟢 **nativo 2004.06.11 = 22,05 anni** | 🟢 **SÌ NATIVO** — *e tre finestre su quattro sono già misurate, R103* | le 4 canoniche | 4 | **8** | **1,2 / 2,8** |
| **2** | 🥈 `CostToCost` EURJPY **`exit 0`** — ⏸️ RESUSCITABILE #1 (PF 1,3427 n=194 DD 9,1158%) | **EURJPY** | 🟢 nativo 1993 → **usabile dal 1999 = 27,5 anni** · `_EXT` 7 anni | 🟢 **SÌ NATIVO** | le 4 canoniche | 4 | **8** | **1,2 / 2,8** |
| **3** | 🥉 `CostToCost` CHFJPY `exit 0` — ⏸️ RESUSCITABILE #3 (1,1474 / DD 7,095) | **CHFJPY** | 🟢 nativo **1992.02.18** · `_EXT` ✅ | 🟢 **SÌ NATIVO** | le 4 canoniche | 4 | **8** | **1,2 / 2,8** |
| **4** | `CostToCost` USDCHF `exit 0` — ⏸️ RESUSCITABILE #2 (1,2617 / DD 8,611) | **USDCHF** | 🟢 nativo **1971.01.03** · 🔴 **`_EXT` NON ESISTE** | 🟢 **SÌ NATIVO** — *e il nativo risolve la casella che la mappa dava per scoperta* | le 4 canoniche | 4 | **8** | **1,2 / 2,8** |
| **5** | `CostToCost` GBPCAD `exit 1` — ⏸️ non misurato (**n=148**, due sotto il muro) | **GBPCAD** | 🟢 nativo **2007.08.21 = 19,0 anni** · `_EXT` ✅ | 🟢 **SÌ NATIVO** | le 4 canoniche | 4 | **8** | **1,2 / 2,8** |
| **6** | 🔴 `Nightly` EURCHF — ❌ bocciato per RISCHIO (DD 11,10/15,39% @1%) su **21 mesi** | **EURCHF** | 🟢 nativo **1993.04.27** (usabile dal 1999) · 🔴 `_EXT` non esiste | 🟢 **SÌ NATIVO** — 🔥 **e il verdetto attuale poggia su una finestra scelta con il pavimento degli INDICI** (§0.5) | le 4 canoniche | 4 | **8** | **1,2 / 2,8** |
| **7** | `Nightly` **USDCHF · EURUSD · GBPUSD** — ❌ rischio | USDCHF · EURUSD · GBPUSD | 🟢 nativo profondo su tutti e tre | 🟢 **SÌ NATIVO** | le 4 canoniche | 12 | **24** | **3,6 / 8,4** |
| **8** | `CanaleLento` XAUUSD D1 — ⏸️ «non scegliibile» (verdi OOS = rosse IS, n 29-112 / 47-164) | **XAUUSD** | 🟢 **nativo 22,05 anni** (oggi girato 2009-2026 = 17,0) | 🟢 **SÌ NATIVO** — 🟡 **ma vedi §7.3: solo la cella più veloce arriva a 150** | le 4 canoniche + finestra piena 2004 | 4 (+1) | **8 (+2)** | **1,2 / 2,8** (+ **3,3** per i 22 anni) |
| **9** | `SuperWave` **XAUUSD** H1/H4 — ⏸️ non misurato (n=122 / 28) | **XAUUSD** | 🟢 nativo 22,05 anni | 🟢 **SÌ NATIVO** | le 4 canoniche | 4 | **8** | **1,2 / 2,8** |
| **10** | `EMA200` H4 forex due lati — 🟠 «non è validato: è selezione» | GBPUSD · AUDJPY · **GBPJPY** · XAUUSD | 🟢 GBPUSD/AUDJPY/XAUUSD nativi profondi · 🟠 **GBPJPY solo 28.723 barre H1 a disco (~4,6 anni)** | 🟠 **SÌ, 3 simboli su 4 subito; GBPJPY dopo il download** | le 4 canoniche (3 simboli) | 12 | **24** | **3,6 / 8,4** *(+4 celle per GBPJPY dopo il download)* |
| **11** | `LiquiditySweep` GBPUSD/EURJPY — ⏸️ NON ANCORA MISURATO (n=14/24) | GBPUSD · EURJPY | 🟢 nativi profondi | 🟢 **SÌ NATIVO** — 🔴 **ma il MECCANISMO è già ucciso altrove (0/30, R95)**: vedi §5.2 | le 4 canoniche | 8 | **16** | **2,4 / 5,6** |
| **12** | `MeanRevert` GBPUSD H1 — 🪦 MORTO VERO (12/12 celle in perdita, n fino a 1.160) | **GBPUSD** | 🟢 nativo dal 1999 (oggi girato **dal 2015**) ⇒ **+16 anni disponibili** | 🟢 **SÌ NATIVO — ma vedi §5.1: è INUTILE** | — | — | — | — |
| **13** | `TurnaroundTuesday` GBPUSD H1 — 🪦 MORTO VERO (0/24 OOS su 11.928 trade) | **GBPUSD** | 🟢 nativo dal 1999 (oggi girato **dal 2010.07.06** = il tetto delle 100.000 barre!) ⇒ **+11,5 anni** | 🟢 **SÌ NATIVO — ma vedi §5.1: è INUTILE** | — | — | — | — |
| **14** | `SupRev_NAS_H1_Ott` NASUSD — ⏸️ merito NON MISURATO (n=86), rischio assolto (DD 0,86%) | **NASUSD** | 🔵 `NASUSD_EXT` **15,71 anni, AMMESSO per firma** | 🔵 **SÌ, MA GIÀ FATTA — R113, 27/08** — 🔴 **e il risultato è «campione inesistente»**: 8·7·3·5 uscite sulle quattro finestre. §7.2 | già girate | 0 | **0** | **0** |
| **15** | `SuperWave` NASUSD H1/H4 — ⏸️ non misurato (n=95 / 18) | **NASUSD** | 🔵 `NASUSD_EXT` 15,71 anni | 🔵 **SÌ su `_EXT`** — ⚠️ con l'avvertenza di R113: attendersi **campioni da 1-5 posizioni/finestra** | le 4 canoniche | 4 | **8** | **1,2 / 2,8** |
| **16** | `ORB_Fibo` NASUSD — 🟠 non misurato (n=91/75, mai a tick) | **NASUSD** | 🔵 `NASUSD_EXT` | 🔵 **SÌ su `_EXT`** — 🔴 **ma è un motore d'APERTURA: gli orari `_EXT` sono di HistData, non di BCM.** L'ora è il meccanismo ⇒ **la misura non è interpretabile**. §5.3 | — | — | — | — |
| **17** | `SupRev_DOW_H1/H4_Ott` U30USD — 🪦 morto (picco 2 assi su 3) / revocato | **U30USD** | 🔴 **nativo 21 mesi · nessun feed esterno esiste** | ❌ **NO** — §5 | — | — | — | — |
| **18** | `SupRev_DAX_H1/H4_Ott` D30EUR — 🪦 morto / n=60 | **D30EUR** | 🔴 nativo 21 mesi · CSV esterno 2010-2018 **con sovrapposizione ZERO** | ❌ **NO** — §5 | — | — | — | — |
| **19** | `SupRev` **F40EUR** H1 — ⏸️ non misurato (n=131, a 19 dal muro) | **F40EUR** | 🔴 nativo 21 mesi · `frxeur` **mai scaricato** | ❌ **NO** (oggi) — §5 | — | — | — | — |
| **20** | `SupRev` **E50EUR** H1/H4 — ⏸️ non misurato (n=60/49) | **E50EUR** | 🔴 nativo 21 mesi · `etxeur` **mai scaricato** | ❌ **NO** (oggi) | — | — | — | — |
| **21** | `SupRev` **100GBP** H1/H4 — 🪦 morto (0/27) / n=48 | **100GBP** | 🔴 nativo 21 mesi · `ukxgbp` **mai scaricato** | ❌ **NO** (oggi) | — | — | — | — |
| **22** | `SupRev` **225JPY** H1/H4 — 🪦 scartato per taglia del contratto | **225JPY** | 🧊 **`225JPY_EXT` IN FRIGO** (0,232 vs 0,20) e copre solo 2019+ | ❌ **NO** | — | — | — | — |
| **23** | `SuperWave` D30EUR H1 — 🪦 MORTO VERO (0/9, DD 12,58%) | **D30EUR** | 🔴 come #18 | ❌ **NO** | — | — | — | — |
| **24** | `MaxMinNotte` **F40EUR · E50EUR · 100GBP** — ⏸️ NON ANCORA MISURATI (manca il TF) | F40EUR · E50EUR · 100GBP | 🔴 nativo 21 mesi, nessun `_EXT` | ❌ **NO** | — | — | — | — |
| **25** | `DAX_Live5m` / `_v2` / `DAX_M3` — ⚪ non misurati, rischio sfondato | **D30EUR** | 🔴 come #18 | ❌ **NO** | — | — | — | — |
| **26** | `Nasdaq_Live5m` `770203` — ⚪ non misurato, bocciato sul COSTO | **NASUSD** | 🔵 `NASUSD_EXT` | 🔵 tecnicamente sì, ❌ **inutile**: è bocciato su `stop/spread = 13,33×` contro 40×, e **lo spread del banco `_EXT` è `[NON MISURATO]`/forse zero** ⇒ la misura **non tocca il cancello che lo ha ucciso** | — | — | — | — |
| **27** | `Londra_ORB` GBPUSD — ⚪ NON MISURATO, **0 punti su 5**, ha misurato l'ora sbagliata | **GBPUSD** | 🟢 nativo dal 1999 | 🟢 **SÌ NATIVO** — ⚠️ ma prima va corretta **l'ora** (canale 06:00-07:00 = un'ora **prima** dell'apertura): una prova di regime su un orologio sbagliato misura il nulla | — | — | — | — |
| **28** | `FiboH4_Multi` basket+GBPUSD — 🪦 MORTO PER RISCHIO (DD 17,2-23,3% @1%) | GBPUSD + basket | 🟢 nativi profondi | 🟢 **SÌ NATIVO — ma inutile**: Emendamento **B**, *il rischio si legge a qualunque n*, e un DD del 23% @1% è **un fatto accaduto**. §5.1 | — | — | — | — |
| **29** | Aperture `770101`/`770202`/`770260` (DAX/Dow/Nasdaq) — 🟢 **VIVE IN CHALLENGE** | D30EUR · U30USD · NASUSD | 🔴 nativo 21 mesi | ❌ **NO** — e su queste **è la casella più cara di tutte**, perché sono in campo. §5.4 | — | — | — | — |

### 💰 IL TOTALE DELLA PARTE 🟢 NATIVA (**righe 1-10**; la riga 11 è esclusa perché §5.2 la dichiara inutile)
**56 celle = 112 passate · 16,8 min (àncora R113) — 39,2 min (tetto prudente).**
👉 **Non è un round: è una mattinata di banco.** E **zero firme nuove, zero cancelli, zero
dati esterni** — perché è tutto sul nostro feed.

---

# 5. 🛑 CHI **NON** SI PUÒ FARE, ELENCATO PER NOME (classe 180: mai «tutto ciò che non è X»)

## 5.1 ❌ Non si può perché **il dato non esiste** — undici voci, per nome

| candidato | simbolo | perché no, col numero |
|---|---|---|
| `SupRev_DOW_H1_Ott` · `SupRev_DOW_H4_Ott` · `SuperWave_DOW_H1_Ott` · `PTE` U30USD · `WOL` U30USD · `Dow_Apertura_US` | **U30USD** | 🔴 **Nessun feed Dow esterno con storia in più ESISTE.** HistData i suoi dieci indici li ha (`grxeur auxaud frxeur hkxhkd spxusd jpxjpy udxusd nsxusd ukxgbp etxeur`) e **il Dow non c'è** (⚠️ `udxusd` è il **Dollar Index**). Dukascopy ce l'ha dal 2012 ma **non è mai stato scaricato: zero byte**. `U30USD_DK` copre **2024-10 → 2025-06**, **dentro** il nativo ⇒ **zero giorni in più**. Nativo: **2024.09.26 `COMPLETO`** = il broker non ce l'ha |
| `SupRev_DAX_H1_Ott` · `SupRev_DAX_H4_Ott` · `SuperWave` D30EUR · `DAX_Live5m` · `DAX_Live5m_v2` · `DAX_M3` · `DAX_Apertura_EU` · `MaxMinNotte_DAX_Short` | **D30EUR** | 🔴 Il DAX esterno **esiste e è sano** (1.718.805 barre M1, 2010.11→2018.12, **0 fuori banda**) **ma ha ZERO giorni in comune col nativo** (2024.09.26). Il cancello ZERO si calcola **solo** sulla sovrapposizione: sul DAX **non è chiuso, è INAPPLICABILE**. 🔴 E la differenza conta: *un cancello chiuso si apre con una misura migliore, uno inapplicabile no* |
| `SupRev` **F40EUR** H1 · `SupRev_CAC_H4_Ott` · `MaxMinNotte` F40EUR | **F40EUR** | ⚪ `frxeur` esiste su HistData dal 2010-11 **e non è mai stato scaricato**. Stato **(d) mai scaricato** |
| `SupRev` **E50EUR** H1/H4 · `MaxMinNotte` E50EUR · `EMA200` E50EUR | **E50EUR** | ⚪ `etxeur` esiste su HistData **e non è mai stato scaricato** |
| `SupRev` **100GBP** H1/H4 · `MaxMinNotte` 100GBP · `DAX_Apertura` 100GBP | **100GBP** | ⚪ `ukxgbp` esiste su HistData **e non è mai stato scaricato** |
| `SupertrendReversal` **E35EUR** | **E35EUR** | ⛔ **l'IBEX non è fra i dieci indici HistData.** Nessuna fonte esterna identificata |
| `SupRev` **225JPY** H1/H4 · `PTE` 225JPY · `GapFill` 225JPY · `GapContinuation` 225JPY | **225JPY** | 🧊 **`225JPY_EXT` è IN FRIGO**: rapporto **0,232** contro soglia **0,20**, cioè **+16,0% sopra** — *non per un pelo*. E copre solo **2019.01→2026.07**. 🔴 **Si riapre con una misura nuova, mai abbassando la soglia** — e le soglie le firma Claudio |
| `EMA200` **SPXUSD** · `WOL` SPXUSD · `SuperWave` SPXUSD · `GapFill` SPXUSD · `PTE` SPXUSD | **SPXUSD** | 🧊 **`SPXUSD_EXT` è IN FRIGO**: **0,203** contro **0,20**, cioè **+1,5%**. ⚠️ **E lo dico perché è scomodo**: fra `NASUSD` (0,199, dentro) e `SPXUSD` (0,203, fuori) ci sono **il 2% di una soglia**, meno del rumore di qualunque rimisura. **Non propongo di cambiarla — è valida proprio perché è stata scritta prima.** Ma chi legge deve sapere che è **un confine, non una differenza di qualità** |
| `EMA200` **200AUD** | **200AUD** | ⚪ HistData ha `auxaud` dal 2010-11 e **non è mai stato scaricato** |
| `GapFill` **UKOIL** / **USOIL** | UKOIL · USOIL | 🔴 nativo **2024.09.26 `COMPLETO`**, nessuna fonte esterna identificata |
| `GoldenCross` **XPDUSD** / **XPTUSD** | XPDUSD · XPTUSD | 🔴 nativo 2015.03.29, **ma 250 passate a ZERO operazioni** già in archivio: casella da chiudere «per dato mancante», non da riprovare |

## 5.2 🟡 Non si può **utilmente**, e il motivo è di merito, non di dati — cinque voci

| candidato | si potrebbe? | perché **non serve** |
|---|---|---|
| `MeanRevert` GBPUSD H1 | 🟢 sì, +16 anni nativi | **12/12 celle in perdita su n fino a 1.160.** Merito leggibile (≥150) su campione abbondante, con modello **ottimista**. 🔴 E la regola del 19/08 vieta di allargare su un motore già senza edge |
| `TurnaroundTuesday` GBPUSD H1 | 🟢 sì, +11,5 anni nativi (la sua finestra parte dal **2010.07.06** = il tetto del grafico, non il broker) | **0/24 celle OOS positive su 11.928 trade**, DD OOS 27,2-56,8% @1%. Stesso argomento |
| `FiboH4_Multi` | 🟢 sì | **DD 17,2-23,3% @1% su n 548-737 per gamba** = **34-46% alla taglia FTMO**. Emendamento **B**: il rischio si legge a qualunque n, ed è un **fatto accaduto** |
| `SuperWave` D30EUR H1 | ❌ no (dati) **e** no (merito) | best PF **0,84186** su **0/9 celle**, n=228, DD 12,58% @1% ⇒ ~25% @2,0% |
| `LiquiditySweep` GBPUSD/EURJPY | 🟢 tecnicamente sì | 🔴 **Il meccanismo è già ucciso altrove**: `R95_REFERTO.md` — **0/30, PF 0,65-0,80**. Una prova di regime su un meccanismo con 0/30 cerca il picco di rumore che la regola del 19/08 vieta. 👉 **La via corta qui è una SONDA di conteggio, 0 passate**, non un round |

## 5.3 🟠 Non si può **interpretare**, anche se gira — la trappola degli orari

`ORB_Fibo` NASUSD, `Nasdaq_PreOpen_Breakout`, e in generale **ogni motore di apertura/ORB**
sono **tipo C** del censimento del 22/09: *«il TF **è** il meccanismo»*. E l'orologio è la
stessa cosa. 🔴 **Il feed `_EXT` ha gli orari di HistData (calibrati con shift +5), non quelli
di BCM**, e la mappa lo scrive per il DAX con i numeri: gli anni «sani» hanno finestra modale
**02:00-15:00 NY** e densità 58,1-59,6 barre/ora, gli anni «riparabili» **00:00-23:00** e
densità 46,2-47,6. 👉 **Un motore che decide sull'ORA, misurato su un feed con un'altra
convenzione oraria, produce un numero che non vuol dire niente.** Lo dichiaro come
**inapplicabile**, non come «da fare con cautela».

## 5.4 🔴 E LA CASELLA CHE COSTA DI PIÙ, perché riguarda chi **sta operando adesso**

**Tre delle sei sedie FTMO `541452707` sono aperture su indici** — `770101` D30EUR,
`770202` U30USD, `770260` NASUSD — e una quarta (`770411` MaxMinNotte DAX Short) è su D30EUR.
👉 **Per nessuna delle quattro la prova di regime è possibile oggi**, e per due di esse
(`770202` Dow, `770101` DAX) **non lo è nemmeno in linea di principio**, perché il dato non
esiste al mondo nella forma che ci serve.

> ## 🎯 **Non è un difetto da riparare: è un LIMITE da dichiarare nel contratto della sedia.**
> Le sedie su indici BCM hanno, e avranno, **un solo regime alle spalle (21 mesi)**. Il loro
> rischio di lungo periodo è **`[NON MISURABILE]` con i dati esistenti** — non «alto» o
> «basso»: **non misurabile**. Chiunque scriva un DD promesso per quelle sedie sta scrivendo
> un numero di finestra corta, che è **esattamente l'errore che l'Emendamento B esiste per
> impedire** (R100 ha misurato lo scarto su un caso dove i dati c'erano: promesso 4,40% →
> misurato 45,91%, **10,4×**).

---

# 6. 🥇 L'ORO — la sezione a parte, perché è il caso maturo

## 6.1 🟢 Chi ha già visto i 22 anni, e chi no — **per nome**

`R100_REFERTO.md` (23/08, OHLC M1, nativo **2004.06.11 → 2026.06.30**, 36 minuti):

| sedia oro | TF | DD promesso | **DD 22 anni @1%** | peggior giorno | verdetto R100 |
|---|---|---:|---:|---:|---|
| `EMA200_Ottimizzato` (971501) | H4 | 4,40% | **45,91%** (10,4×) | −1,91% | 🔴 REVISIONE |
| **`MaxMinNotte` (770402)** | **H2** | 5,30% | **19,72%** (3,7×) | −1,07% | 🔴 REVISIONE |
| `PunteLarry` (772343) | H1 | 3,50% | **29,74%** (8,5×) | −3,91% | 🔴 REVISIONE |
| `EMA200` base | H4 | n/d | **55,02%** | −2,36% | 🟡 senza metro |
| `GoldenCross_Ott` · `GoldenCross` | H1 | n/d | 25,18 · 22,34 | −1,96 · −1,95% | 🟡 |
| `PTE` | H4 | n/d | 24,22 | −1,24% | 🟡 |
| `SupRev_Multi_Ott` · `SupRev_Multi` | H4 | n/d | 16,90 · 7,36 | −1,85 · −1,60% | 🟡 |
| 🟢 **`SupertrendReversal`** | H4 | n/d | **2,18** | −0,54% | 🟡 **il più pulito della flotta oro** |
| `WOL` | D1 | n/d | 1,17 *(finestra ACCORCIATA, dal 2008 — dichiarato dal driver)* | −0,06% | 🟡 |

🔴 **Chi NON ha mai visto i 22 anni, per nome — e sono DUE, non di più:**
- **`SupertrendInvert`** — fermato dal gate d'età (EA del 2025). E ha **11 CSV su 20 a
  `Trades = 0`**: metà del suo campione **non esiste**.
- **`Gold_Ichimoku_TK_ATR_EA`** — **non misurabile per costruzione**: l'EA non esporta
  risultati. 🔴 È il **n.1 della classifica R103** (+150.871 normalizzato) **col DD equity
  `n/d`**, ed è quello che ha scavato **−26,9k** nel biennio 2020-2022. **Un numero 1 senza
  misura di rischio non è un numero 1: è un buco.** Chiuderlo richiede una **modifica all'EA**.

🔴 **E `CanaleLento` XAUUSD D1 non è in questa lista** perché non è una sedia: è un candidato,
e la sua finestra oggi parte dal **2009.07.16** — cioè **5,1 anni dopo** il pavimento nativo.

## 6.2 🎯 LA DOMANDA DI CLAUDIO HA GIÀ MEZZA RISPOSTA IN ARCHIVIO — **e costa ZERO**

> **«Il DD del 19,72% di `MaxMinNotte` oro è UN episodio in UN'epoca, o è il metronomo del motore?»**

**Due misure native della stessa sedia, due finestre diverse, tutte e due già agli atti:**

| fonte | finestra | modello | PF | **n** | **DD @1%** |
|---|---|---|---:|---:|---:|
| **R103** F23 (24/08) | **2020.01.01 → 2026.06.30** (6,49 anni) | OHLC M1 nativo | **1,308** | **693** | **10,64%** |
| **R100** (23/08) | **2004.06.11 → 2026.06.30** (22,05 anni) | OHLC M1 nativo | *(non pubblicato)* | *(non pubblicato)* | **19,72%** |

> ## 🔴 **I 9,08 punti di drawdown in più NON stanno nei sei anni recenti: stanno nel 2004-2019.**
> Tradotto: **su 2020-2026 questa sedia sta SOTTO il muro del 10% a rischio 1%** (10,64% è a
> un soffio sopra, e l'OHLC **sottostima il DD** — quindi il numero è un limite inferiore e
> **non assolve**). Il pezzo che fa paura è **vecchio**.

**E c'è di più, sempre a costo zero — la spina dorsale anno per anno di R103 (n · netto EUR):**

| 2020 | 2021 | 2022 (**ORSO**) | 2023 | 2024 | 2025 | 2026 (parziale) |
|---:|---:|---:|---:|---:|---:|---:|
| n 89 · **+223** | n 107 · **−274** 🔴 | n 114 · **+6.603** | n 104 · **−2.703** 🔴 | n 124 · **+6.867** | n 113 · **+6.420** | n 42 · **+7.601** |

🎯 **Nell'anno ORSO (2022) questa sedia ha fatto il suo secondo miglior risultato dei sette.**
E gli anni negativi sono **2021 (toro)** e **2023**. 👉 **La lettura più semplice è che non è
un motore che soffre gli orsi.** ⚠️ **E lo dichiaro come [PARZIALE], non come verdetto**: la
spina dorsale è il **netto delle chiusure realizzate**, per esplicita dichiarazione del driver
*«NON è l'equity e NON è il DD»*. Un anno può chiudere positivo e contenere un drawdown
feroce. **Serve il DD per finestra, e quello non c'è.**

## 6.3 💰 LA MISURA PIÙ CORTA CHE CHIUDE LA DOMANDA

| # | passo | costo | perché questo |
|---|---|---|---|
| **O1** | 🟢 **Leggere la spina dorsale anno-per-anno di TUTTE E 25 le sedie R103** (non solo l'oro) | 🟢 **ZERO minuti** — è un file in repo | È una **decomposizione di regime nativa già misurata** che nessuno ha mai letto come tale. Copre **CROLLO 2020, TORO 2021, ORSO 2022** per 25 sedie forex/metalli |
| **O2** | 🟢 **Recuperare i CSV di `r151a` e `r170b`** (round di USCITA su questa identica sedia, girati il 15-17/09 e mai caricati) | 🟢 **ZERO minuti** — è un trasporto | Il punto ③ del certificato potrebbe essere **già misurato** e nessuno lo sa. Si guarda **prima** di spendere un minuto |
| **O3** | 🥇 **`MaxMinNotte` oro sulle 4 finestre canoniche, NATIVO**, parametri congelati | **4 celle = 8 passate · 1,2-2,8 min** | Dà il **DD per finestra**, che è esattamente quello che O1 non può dare |
| **O4** | 🔍 **Due finestre d'epoca che il set standard non ha: 2008 (Lehman) e 2013 (l'orso vero dell'oro, −28%)** | **2 celle = 4 passate · 0,6-1,4 min** | 🔴 **Se il 19,72% sta lì dentro, lo scopriamo con due passate.** ⚠️ Sono finestre **NUOVE**: vanno **dichiarate come tali** e il criterio va scritto **prima** dei numeri (regola del 14/08) |
| **O5** | ⚪ Importare l'oro esterno (`XAUUSD_EXT`, OANDA 2006-2020, HistData 2021-2026) | ~5-10 min + cancello | 🛑 **Non lo metto per primo, e il motivo è un numero**: `XAUUSD_EXT` copre **2018-2024**, il nativo **2004-2026**. Sull'oro l'esterno è **strettamente peggio come storia**. Ha senso **solo** come **secondo feed di riproduzione** |

**O1+O2+O3+O4 = 6 celle, 12 passate, 1,8-4,2 minuti, e due letture gratis.**

## 6.4 🔴 IL MURO CHE NESSUN REGIME SPOSTA, e va detto insieme al resto

FTMO ha un **DD statico del 10%**. Il preset FTMO porta **`InpRiskPercent = 2,00`**. E
**19,72% @1% fa ~39% @2%** (fattore misurato 1,956-1,990, classe 547). 👉 **Nessuna
decomposizione per regime cambia questo.** La prova di regime serve a decidere **se e a quale
taglia** la sedia può tornare, **non** a farla rientrare a taglia piena.

---

# 7. 🥇 LA DOMANDA CHE VALE DI PIÙ — «bocciato per campione sottile + storico lungo = campione ritrovato?»

## 7.1 📋 L'elenco dei bocciati/sospesi PER CAMPIONE, col conto degli anni

Regola usata: **n < 150 in almeno una gamba ⇒ merito SOSPESO** (Emendamento A).
**Frequenza** = `n / anni della finestra che l'ha prodotta`. **Anni per 300 operazioni** =
`300 / frequenza`.

| candidato | simbolo | n misurato | finestra che l'ha prodotto | **op/anno** | **anni per 300** | **anni disponibili** | ce la fa? |
|---|---|---|---|---:|---:|---:|---|
| `CostToCost` **GBPCAD** `exit 1` | GBPCAD | **148** | scan H4 unica | *(finestra non dichiarata nel CSV)* | — | **19,0 nativi** | 🟢 **quasi già fatto**: mancano **2 operazioni** |
| `CanaleLento` XAUUSD **cella più veloce** (EP20/ExP10) | XAUUSD | 164 OOS | 2016.04.28→2026.06.30 (10,17 a) | **16,1** | **18,6** | **22,05** | 🟢 **SÌ** (proiezione ~355 op totali) |
| `CanaleLento` XAUUSD **cella migliore** (EP60/ExP10, PF **2,017**) | XAUUSD | 88 OOS | idem | **8,7** | **34,9** | **22,05** | 🔴 **NO** — §7.3 |
| `SuperWave` XAUUSD H1 | XAUUSD | 122 | unica | `[NON MISURATO]` | — | **22,05** | 🟡 **probabile**, da misurare |
| `SupRev` **F40EUR** H1 | F40EUR | 131 | unica 2024.01→2026.06 | 53 *(sonda 17/08)* | **5,7** | **1,8** | ❌ **il dato non esiste** (§5.1) |
| `SupRev_NAS_H1_Ott` | NASUSD | 86 OOS | 2024.09.26→2026.06.30 | **77** *(sonda)* | **3,9** | 1,8 nativi · **15,71 `_EXT`** | 🔴 **NO su `_EXT`** (lì fa **13,3** op/anno ⇒ servirebbero **22,5** anni) — §7.2 |
| `SuperWave` NASUSD H1 / H4 | NASUSD | 95 / 18 | unica | `[NON MISURATO]` | — | 15,71 `_EXT` | 🟡 stesso dubbio di sopra |
| `ORB_Fibo` NASUSD | NASUSD | 91 / 75 | 2024.09.26→2026.06.30 | **71** *(sonda)* | **4,2** | 15,71 `_EXT` | 🟠 **numericamente sì, ma non interpretabile** (§5.3) |
| `SupRev` **100GBP** H4 | 100GBP | 48 | unica | ~19 | **15,8** | 1,8 | ❌ **il dato non esiste** |
| `SupRev` **E50EUR** H1/H4 | E50EUR | 60 / 49 | unica | ~24-30 | 10-12 | 1,8 | ❌ **il dato non esiste** |
| `SupRev_DAX_H4_Ott` | D30EUR | 60 | split | 60 *(sonda)* | **5,0** | 1,8 | ❌ **il dato non esiste** |
| `SupRev_DOW_H4_Ott` | U30USD | 49 | split | 54 *(sonda)* | **5,6** | 1,8 | ❌ **il dato non esiste** |
| `SuperWave_DOW_H1_Ott` `770511` | U30USD | **143** *(7 sotto il muro)* | split | 131 *(sonda)* | **2,3** | 1,8 | ❌ **il dato non esiste** — 🔴 e mancano **7 operazioni**: il campione arriverà **da solo in ~2 mesi di calendario** |
| `Nightly` EURCHF · USDCHF · EURUSD · GBPUSD | 4 coppie forex | 63-164 | **21 mesi** | vedi §7.4 | — | **27,5 nativi** | 🟢 **SÌ, LARGAMENTE** |

## 7.2 🔴 **LA RISPOSTA SCOMODA: SUL NASDAQ LO STORICO LUNGO NON PORTA IL CAMPIONE, ED È MISURATO**

**R113 (27/08) è l'unica prova di regime mai girata su un indice `_EXT`.** Ha girato
`SupRev_NAS_H1_Ottimizzato` su `NASUSD_EXT`, **18 celle, 6 finestre, 5,4 minuti, esito OK**.
Questi sono i suoi numeri, colonna `n` in **uscite** (~2 uscite = 1 posizione, misurato R112):

| finestra | periodo | metro | long | short | **posizioni ~** |
|---|---|---:|---:|---:|---|
| **TORO** | 2021 | **8** | 2 | 6 | ~4 · ~1 · ~3 |
| **ORSO** | 2022.01-10 | **7** | 7 | **0** | ~3 · ~3 · **0** |
| **CROLLO** | 2020.02-04 | **3** | 2 | 1 | ~1 · ~1 · ~0 |
| CROLLO_ANNO | 2020 | 5 | 4 | 1 | ~2 · ~2 · ~0 |
| LATERALE_NAS | 2015.01-2016.06 | 55 | 34 | 21 | ~27 · ~17 · ~10 |
| VECCHIA | 2011-2012 | 94 | 55 | 39 | ~47 · ~27 · ~19 |

> ### 🔴 **LE QUATTRO FINESTRE CANONICHE HANNO PRODOTTO 4, 3, 1 e 2 POSIZIONI.**
> Non un campione piccolo: **un campione che non c'è.** Il referto R113 lo classifica da solo,
> con la sua tassonomia meccanica: **`NON MIS.` in 4 finestre su 6**.

**E il conto che chiude la questione.** Sommando le celle `metro`, **contando UNA VOLTA SOLA le finestre annidate** (🔴 `CROLLO` 2020.02-04 sta **dentro** `CROLLO_ANNO` 2020: se si sommassero tutte e sei, quei tre mesi entrerebbero due volte — e il numero verrebbe gonfiato):
**169 uscite ≈ 84 posizioni su 6,33 anni di finestra = 13,3 op/anno.**
Lo stesso motore, stesso TF, stessi parametri, **su BCM nativo fa 77 op/anno** (sonda 17/08).

| | frequenza misurata | anni per 300 operazioni | anni disponibili |
|---|---:|---:|---:|
| `SupRev_NAS_H1` su **BCM nativo** | **77 op/anno** | **3,9** | 🔴 **1,8** |
| `SupRev_NAS_H1` su **`NASUSD_EXT`** | **13,3 op/anno** | **22,5** | 🔴 **15,71** |

> ## 🎯 **È UNA TENAGLIA, ed è misurata da tutte e due le parti.**
> Sul **nativo** la frequenza c'è e **manca lo storico**. Sull'**`_EXT`** lo storico c'è e
> **manca la frequenza** — di un fattore **5,8×**. 👉 **`NASUSD_EXT` non può dare a questo
> motore i 150+150, perché gliene mancherebbero 6,8 anni che non esistono.**

**E le due spiegazioni possibili vanno separate, perché cambiano cosa si deve fare:**
- **(a) è il FEED** — `_EXT` genera meno segnali (è lo stesso fenomeno di R80, dove il calo
  sistematico fu del 20-55% in 16 celle su 16) ⇒ **ogni lettura delle finestre `_EXT` porta
  la riserva**, e il DD 0,35% dell'ORSO non vuol dire «sicuro», vuol dire «tre operazioni»;
- **(b) è l'EPOCA** — il Nasdaq 2011-2021 aveva davvero molti meno flip di Supertrend del
  Nasdaq 2024-2026 ⇒ **la frequenza promessa dal forward NON è una proprietà del motore**, e
  il pavimento di frequenza della sedia è **sopravvalutato**.
🔴 **Sono tutte e due cattive notizie, e non sappiamo quale sia.**

### 🎯 LA MISURA CHE LE SEPARA, ed è la più preziosa del dossier — **3 celle, ~1 minuto**
**Rigirare R113 sulla SOVRAPPOSIZIONE 2024.09.26 → 2026.06.30**, stesse celle, su
`NASUSD_EXT`, e confrontare **solo `n`** con i numeri nativi di R110/R199.
- ✅ **`n` non dipende dallo spread** e non dipende dal modello di riempimento: dipende da
  quante volte la condizione d'ingresso si accende. **È calibrazione del feed, non un verdetto
  sul motore** — ed è l'unico confronto fra feed che i criteri di casa **permettono**.
- 🚦 **E ha valore di CANCELLO**: se gli `n` non combaciano, **ogni** numero `_EXT` di questo
  dossier (righe 14-16 e 26 della tabella madre) va letto con la riserva scritta accanto.
  👉 **Va fatta PRIMA di qualunque altra corsa `_EXT`.**

## 7.3 🟡 `CanaleLento` XAUUSD — il caso che **quasi** funziona, e perché il «quasi» conta

Letto oggi dai CSV (`Notte_16-08/ABTG_CanaleLento_XAUUSD_{IS,OOS}_ohlc_cl1.csv`, 20 celle
ciascuno, tre assi: `InpEntryPeriod` × `InpExitPeriod` × `InpExitMiddle`):

| cella | PF IS | n IS | PF OOS | n OOS | op/anno (OOS) | **proiezione su 22,05 anni** |
|---|---:|---:|---:|---:|---:|---:|
| EP60 / ExP10 — **la migliore in OOS** | 0,937 / 0,788 🔴 | 62 / 41 | **2,017** | 88 | **8,7** | **~190** ⇒ split 40/60 = **76 / 114** 🔴 |
| EP20 / ExP10 — **la più veloce** | 0,987 | 112 | 1,539 | **164** | **16,1** | **~355** ⇒ split 40/60 = **142 / 213** 🟢 |

> ### 🔴 **Nemmeno 22 anni portano a 150 la cella che ci interessava.**
> E il quadro «verdi OOS = rosse IS» è confermato al dettaglio: la cella da **PF 2,017** in
> OOS ha i suoi gemelli IS a **0,937 e 0,788**.
> 🟢 **Ma la cella veloce ci arriva**, e su **due gambe**. 👉 Quindi la domanda giusta non è
> *«resuscitiamo CanaleLento?»* ma *«la cella veloce, su 22 anni nativi e con uno split
> dichiarato, regge?»* — e quella è **una misura legittima, non un ripescaggio**.

🔴 **E poi c'è il muro che chiude comunque il discorso sedia**, ed è la frequenza: §7.4.

## 7.4 📐 IL CONTO DELLA FREQUENZA — perché quasi nessuno di questi diventa una sedia

Pavimento firmato il 07/09: **1,00 operazione/giorno per FAMIGLIA** (motore × simboli
schierabili). Frequenze **calcolate** su giorni feriali (261/anno):

| candidato | n | finestra | op/anno | **op/giorno feriale** | la famiglia regge? |
|---|---:|---|---:|---:|---|
| 🟢 **`Nightly`** (4 coppie) | 889 pos | 459 gg feriali | — | **1,937** | 🟢 **SÌ — ×1,94 sopra il pavimento.** È **l'unico candidato del dossier che il pavimento lo supera** |
| `MaxMinNotte` XAUUSD H2 | 693 | 6,49 anni | **106,8** | **0,409** | 🟡 **serve la famiglia**: oro da solo **non basta**. `MaxMinNotte` ha anche D30EUR (`770411`, viva) e le tre gemelle CAC/Stoxx/FTSE **bocciate**. **[NON MISURATO]** il totale di famiglia |
| `CostToCost` EURJPY H4 | 394 | 6,48 anni | **60,8** | **0,233** | 🟡 **serve la famiglia**: 4 simboli × 0,23 = **~0,93** — **sotto il pavimento per un soffio**, e 2 dei 4 (`USDCHF`, `GBPCAD`) sono su celle diverse. **Da misurare, non da assumere** |
| `SupRev_NAS_H1` su `_EXT` | ~84 | 6,33 anni | **13,3** | **0,051** | 🔴 no |
| `CanaleLento` XAUUSD D1 (veloce) | 164 | 10,17 anni | **16,1** | **0,062** | 🔴 **NO, e non c'è famiglia che lo salvi**: servirebbero **16 simboli** per fare 1,00 op/giorno |
| `CanaleLento` XAUUSD D1 (migliore) | 88 | 10,17 anni | **8,7** | **0,033** | 🔴 **NO** — ne servirebbero **30** |

> ## 🎯 **LA RIGA CHE METTE IN ORDINE TUTTO IL DOSSIER**
> **`CanaleLento` può ritrovare il campione e non diventerà mai una sedia.** Lo scrivo perché
> è la differenza fra *«riapribile»* e *«riapribile UTILMENTE»*: la prova di regime su
> `CanaleLento` è **una misura di ricerca** (utile: dice se un Donchian lento sull'oro ha un
> edge strutturale), **non** un candidato per il 1° ottobre.
> 🟢 **`Nightly` è l'opposto**: la frequenza ce l'ha, e quello che gli manca — **lo storico** —
> è **a portata di quattro passate native.**

---

# 8. 🏆 LA CLASSIFICA DEI RIAPRIBILI — ordinata per quanto avvicinano una sedia

> 🛑 **Premessa onesta, e va letta prima della classifica.** La challenge è **già partita** (21/09).
> **Nessuno di questi diventa una sedia schierabile in giorni**: una prova di regime **non
> promuove niente** — `PROVA_REGIME_CRITERI.md` D-C, *«parametri CONGELATI, MAI promozione di
> celle»*, e il limite vale **anche sul nativo**, perché il modello resta 1. 👉 **Sono
> ordinati per VALORE DELLA MISURA**, cioè per quanto ciascuno **toglie incertezza a una sedia
> che c'è o che ci sarà.**

| # | candidato | **la domanda che chiude** | attesa dichiarata PRIMA | cosa lo uccide (scritto prima) | costo |
|---|---|---|---|---|---|
| 🥇 **1** | **Lettura R103 anno-per-anno, 25 sedie** | *«CROLLO, TORO e ORSO sono già misurati NATIVI e nessuno li ha letti?»* | **Sì**: il driver stampa n e netto per ogni anno 2020-2026, sedia per sedia | niente: è un file in repo. 🔴 Il limite è **strutturale**: è il netto realizzato, **non il DD** | 🟢 **ZERO minuti** |
| 🥈 **2** | **R113 sulla SOVRAPPOSIZIONE** (`NASUSD_EXT` 2024.09→2026.06, 3 celle) | *«il feed `_EXT` conta le stesse operazioni del nativo?»* | `n` entro **±15%** dei numeri nativi R110/R199 | 🔴 se lo scarto supera il 15%, **tutte** le letture `_EXT` portano la riserva — e allora il Nasdaq esce dalla lista dei riapribili | **3 celle = 6 passate · 0,9-2,1 min** |
| 🥉 **3** | **`MaxMinNotte` oro `770402`, 4 finestre NATIVE** | *«il 19,72% è un episodio o il metronomo?»* | 🔴 **Dichiarata PRIMA, e contro di me**: mi aspetto **DD ≤ 8% in ORSO e in CROLLO**, perché R103 dice che il 2022 è il secondo anno migliore e che il DD 2020-2026 è 10,64% su 693 op. **Se sbaglio, l'avrò scritto** | se il DD in **ORSO o CROLLO** supera **2× il metro OOS e comunque il 20%** (criterio A, congelato dal 14/08), il motore **non si difende più** e la revisione R100 diventa spegnimento | **4 celle = 8 passate · 1,2-2,8 min** |
| **4** | **`Nightly` 4 coppie NATIVE** | *«il DD 11,1-22,6% è del MOTORE o dei 21 mesi in cui l'abbiamo misurato?»* | ⚠️ **Dichiarata PRIMA**: mi aspetto che **peggiori**, non che migliori — il 2020-2022 sul franco svizzero contiene il crollo Covid e l'abbandono del floor è già fuori finestra. **Attesa: DD ≥ 15% in almeno una finestra** | se il DD resta **sopra il 10% @1% in 3 finestre su 4**, il verdetto di rischio **si conferma su quattro epoche** invece che su una, e il candidato si chiude **col certificato completo** | **16 celle = 32 passate · 4,8-11,2 min** |
| **5** | **`CostToCost` `exit 0` × 4 simboli, NATIVO** | *«l'uscita `exit 0` tiene anche dove `exit 2` è crollata?»* | `exit 0` **sotto il DD di `exit 2`** in almeno 3 finestre su 4 | 🔴 se `exit 0` crolla in ORSO o CROLLO, era **il picco di un'altra griglia** (e l'argomento regge a metà: `exit 0` è stata pescata **dentro** un CSV **dopo** aver visto i numeri) | **16 celle = 32 passate · 4,8-11,2 min** |
| **6** | **`EMA200` H4 forex due lati, 3 simboli NATIVI** | *«le 24 celle a due lati sono un altopiano o la convergenza del genetico?»* | almeno **18/24** celle ≥1,10 su GBPUSD+AUDJPY+XAUUSD | sotto **12/24**, era selezione | **12 celle = 24 passate · 3,6-8,4 min** |
| **7** | **`CanaleLento` XAUUSD, cella VELOCE, 22 anni nativi con split dichiarato** | *«un Donchian lento sull'oro ha un edge strutturale?»* | n ≥ 140 per gamba; PF OOS ≥ 1,20 | PF < 1,10 su una gamba ⇒ chiuso. 🔴 **E comunque NON diventa una sedia: 0,062 op/giorno** | **1 cella = 2 passate · 3,3 min** *(àncora R100: 22 anni)* |

---

# 9. 🧪 I CONTRO-ESEMPI — quello che ho provato a rompere, e cosa si è rotto

## 9.1 🔴 **LA FRASE DA ROMPERE SI ROMPE, E IN QUATTRO MODI INDIPENDENTI**

> Da rompere: *«se il motore sopravvive a quattro epoche su `_EXT`, allora è robusto»*

**SI ROMPE. E non per opinione:**

**(a) 🔴 Il feed cambia il SEGNO, non il decimale.** R80: quattro celle, stessa finestra,
stessi parametri, cambia **solo** il feed ⇒ **quattro cambi di segno su quattro**. Un
esperimento in cui la variabile di controllo ribalta l'esito quattro volte su quattro **non
misura la variabile che credi**.

**(b) 🔴 Non c'è niente da far sopravvivere: il campione non si forma.** R113, misurato:
**4, 3, 1 e 2 posizioni** sulle quattro finestre canoniche. Con `n = 1` il PF esce **0,000**
e il DD **0,22%** — e sono i numeri **stampati nel referto**. 👉 *«Sopravvive all'ORSO con DD
0,35%»* è vero **e significa "ha fatto tre operazioni"**.

**(c) 🔴 Il banco `_EXT` potrebbe essere SENZA ATTRITO, e nessuno lo sa.** Il referto R113
dichiara due meccanismi alternativi, letti nel sorgente:
`ABTG_ImportaStoricoEsterno.mq5` r.327 **scrive spread = 0 in OGNI barra M1 importata** e
copia `SYMBOL_SPREAD_FLOAT` ma **non** `SYMBOL_SPREAD`. Se il tester prende lo spread dalla
**barra**, quel banco è **a spread zero**. **Quale delle due sia è `[NON MISURATO]`.**
👉 Un motore che «sopravvive» su un banco forse senza attrito non ha dimostrato niente — e
R55 ha misurato che **1,5 punti indice sfondano il cancello del 10% sull'ORB**.

**(d) 🔴 E c'è un vizio ARITMETICO che vale anche col feed perfetto.** Le quattro finestre
sommano **37 mesi**. Un motore H1/H4 che fa 25-80 op/anno produce **8-25 operazioni per
finestra**. 👉 **Per l'Emendamento A il merito è SOSPESO per costruzione, in tutte e quattro.**
La prova di regime **non può** produrre un giudizio di merito: **può solo produrre un giudizio
di RISCHIO** (Emendamento B: il rischio si legge a qualunque n). **Chi legge un PF di regime
come merito sta leggendo il rumore.**

> ## ⚖️ **LA FORMA CORRETTA DELLA FRASE, che è più debole e più utile:**
> **«Se il motore, su quattro epoche diverse dello STESSO feed su cui è stato misurato, non
> produce un drawdown fuori scala, allora il suo rischio non è un artefatto dei 21 mesi.»**
> Tre parole cambiate — *rischio* invece di *robusto*, *stesso feed* invece di `_EXT` — e la
> frase diventa **vera e verificabile**. 👉 **Ed è esattamente il motivo per cui questo
> dossier sposta il lavoro dal `_EXT` al NATIVO.**

## 9.2 🧪 Il contro-esempio a **ogni** «si può fare oggi» della tabella madre

| proposta | **l'argomento per cui NON si può** — costruito da me | regge? |
|---|---|---|
| **Tutte le corse native 2019-2022** | *«Dici che il nativo evita il problema del feed. Ma anche il nativo 2019-2022 è modello 1, e tu stesso misuri OHLC→tick a 1,72-3,51×. Quindi i numeri restano non confrontabili coi tick: hai spostato il problema, non risolto.»* | 🟡 **REGGE, e va scritto accanto a ogni numero.** **Ma non è lo stesso problema**: il fattore OHLC→tick è **una distorsione di scala misurata e di segno noto** (l'OHLC è ottimista sul PF, pessimista sul DD); la divergenza di feed di R80 è **un cambio di SEGNO**. 👉 **Uno si corregge dichiarandolo, l'altro no.** E sul **rischio** — l'unica cosa che queste corse possono giudicare (§9.1d) — **l'OHLC sottostima il DD**, quindi un DD brutto in OHLC è **a maggior ragione** brutto |
| **#1 `MaxMinNotte` oro, 4 finestre native** | *«R103 dice già che il 2022 è positivo. Stai per spendere 8 passate per confermare quello che vuoi sentirti dire.»* | 🟢 **NON REGGE, e il motivo è preciso.** R103 dà il **netto realizzato per anno**, e il driver stesso scrive *«NON è l'equity e NON è il DD»*. **Un anno chiuso a +6.603 può contenere un drawdown del 15%.** La misura nuova produce **una grandezza diversa**, non una conferma. 🔴 **E se producesse la conferma, resterebbe il muro FTMO del §6.4** |
| **#4 `Nightly` 4 coppie native** | *«Il motore è a M5 e opera di notte: su 2019-2022 non ci sono i tick, quindi l'EA vedrà barre M1 sintetiche proprio nelle ore in cui il book è vuoto. Stai misurando il generatore di tick, non il motore.»* | 🔴 **REGGE, ed è il limite più serio di tutta la proposta.** Va scritto nel file prova **prima**, e il verdetto va limitato al **RISCHIO** e alla **FORMA** (il DD peggiora o no), **mai** al PF. 🟢 **Non annulla la misura**: il verdetto attuale di `Nightly` è **già** un verdetto di rischio, e confrontare un DD OHLC con un DD OHLC è coerente. ⚠️ Confrontarlo col DD a **tick** del 2024-2026 **no** |
| **#5 `CostToCost` `exit 0`** | *«`exit 0` l'hai pescata dentro un CSV DOPO aver visto i numeri: è il picco di un'altra griglia.»* | 🟡 **REGGE A METÀ.** `exit 0` **non** è stata scelta prima. **Ma** non è una cella isolata: è la migliore su **tre gemelli** (EURJPY, USDCHF, CHFJPY), e tre gemelli nello stesso verso sono un **altopiano**, non una cella che sporge. 👉 **La corsa si fa, ma il suo esito NON promuove niente**: se `exit 0` tiene, il risultato è *«l'uscita va rimessa ad asse in un round vero a tick»*, **non** *«cambiamo la cella»* |
| **#6 `EMA200` H4 forex** | *«GBPJPY ha 28.723 barre H1 a disco = ~4,6 anni. Misuri 3 simboli su 4 e chiami "famiglia" il risultato.»* | 🔴 **REGGE.** La corsa si fa lo stesso (il rischio si legge a qualunque n), ma **il verdetto è PER SIMBOLO**, e la casella `GBPJPY` va scritta **accanto** al numero, non taciuta |
| **#7 `CanaleLento`** | *«22 anni sono tanti: stai violando l'Emendamento D, che dice che il difetto ricorrente del progetto è l'opposto.»* | 🟢 **NON REGGE.** L'Emendamento D avverte contro le finestre **troppo CORTE** (110 file prova su 21 mesi, il 2010 usato **una volta sola**). E l'unità è **l'operazione**, non l'anno: §7.3 mostra che **22 anni fanno appena 190-355 operazioni** su questo motore. 🔴 **Il contro-esempio che morde davvero è un altro, ed è la frequenza: 0,062 op/giorno.** Quello lo dichiaro io, al §7.4 |
| **Riga 14 (SupRev_NAS): «già fatta, R113»** | *«Stai usando R113 per DIRE DI NO. Ma R113 ha girato UNA cella (la sedia viva) su UN motore: forse un'altra configurazione sullo stesso `_EXT` farebbe più operazioni.»* | 🟢 **NON REGGE, e il motivo è la regola del 19/08.** Cercare «un'altra configurazione che faccia più operazioni» su un motore per cui non abbiamo un edge misurato **è esattamente l'allargamento di griglia vietato**. 🟡 **Ma una parte regge e la tengo**: il numero 13,3 op/anno vale **per quella cella**, non per il motore. Per questo la misura che propongo (**#2**, la sovrapposizione) è **di calibrazione del feed**, non di ricerca di una cella migliore |

## 9.3 🧪 E un contro-esempio contro **il mio stesso titolo**

> *«Hai intitolato il dossier "rileggere i morti con lo storico che abbiamo davvero". Ma di 29
> righe della tabella madre, **12 non si possono fare utilmente** e diverse delle 🟢 SÌ sono su motori che tu
> stesso dichiari inutili da rifare. Non stai rileggendo i morti: stai confermando che sono morti.»*

🟡 **REGGE IN PARTE, e la correzione è di lessico, non di numeri.** Il bilancio vero, contato riga per riga:
- **10 righe ❌ NO** (17·18·19·20·21·22·23·24·25·29) **+ 2 righe tecnicamente possibili ma non
  interpretabili** (16 `ORB_Fibo`, 26 `Nasdaq_Live5m`) = **12 candidati su cui la prova di
  regime non si può fare utilmente**. 🔴 **E sono 12 su 12 su INDICI BCM**: è **un limite del
  DATO, non del motore**. Per loro il verdetto corretto non è *«morto»* né *«riapribile»*: è
  **`[NON MISURABILE PER REGIME]`**, e va scritto nel `REGISTRO_TEST.md` così, perché è
  **un'informazione**, non un'assenza.
- **6 misure utili + 1 lettura a costo zero** (la classifica del §8).
- **5 candidati** dove si può fare **ed è inutile**, col motivo e il numero scritti (§5.2).
- 🟢 **E 2 ritrovamenti veri, che non erano in nessun referto**: la decomposizione nativa
  anno-per-anno di **25 sedie già in archivio** (§6.2), e il **pavimento degli indici copiato
  su una coppia forex** che ha ristretto `Nightly` a 21 mesi (§0.5).

👉 **Quindi il titolo onesto è: «i morti degli INDICI restano morti per mancanza di dati; i
morti del FOREX e dell'ORO hanno uno storico che non abbiamo mai usato, e due di loro hanno
già la risposta in archivio».** Meno epico, e vero.

---

# 10. 🕳️ NON COPERTO — quello che questo dossier **non** chiude

| # | buco | perché non l'ho chiuso | costo per chiuderlo |
|---|---|---|---|
| **N1** | 🔴 **`n` e `PF` di R100 (22 anni, 11 sedie oro) NON sono pubblicati e il CSV non è in repo** — quindi il confronto del §6.2 (19,72% vs 10,64%) poggia su **due DD**, senza sapere se il numero di operazioni è coerente | il dato grezzo è nello zip `R100_ORO_FLOTTA_CORSA_20260823_1449`, fuori dal repo | recupero zip: **`[NON MISURATO]`** |
| **N2** | 🔴 **I due DD del §6.2 vengono da due PIN DIVERSI** (R100 `adbc27c`, R103 `7e2fb0d`) e da due driver diversi | non posso verificare che la cella sia bit-identica fra i due round | lettura dei due file prova: **0 minuti**, ma serve accesso allo zip R100 |
| **N3** | 🔴 **La divergenza `_EXT` vs nativo di R80 resta `[IPOTESI]`** — la spiegazione più semplice (M1 native 2019-2022 non a disco) **non è mai stata verificata**, benché R102 dimostri che il download funziona | è un'azione su una macchina, e io sono in sola lettura | ri-corsa R80 sul nativo: **`[NON MISURATO]`** |
| **N4** | 🟡 **La finestra LATERALE 2019 non è dimostrata a disco per il forex**: R103 parte dal **2020.01.01**, quindi CROLLO/TORO/ORSO sono provati, **il 2019 no** | è un fatto di cache, non di broker | 🟢 si risolve da solo: *«il tester completa da solo mentre gira»* (R100 §3.7). **Ma la prima corsa del 2019 pagherà il download** — `[NON MISURATO]` quanto |
| **N5** | 🔴 **La frequenza di famiglia non è misurata per NESSUNA delle famiglie che propongo**, tranne `Nightly` (1,937) | richiede di sommare le op/giorno dei simboli schierabili per famiglia: è un calcolo sui CSV, ma i CSV di famiglia non sono omogenei per finestra | lettura: **0 minuti macchina**, ~1 agente |
| **N6** | 🟡 **Lo spread di `EURCHF`, `USDCHF`, `CHFJPY`, `GBPCAD` su BCM NON è misurato** — e il file prova `Nightly` lo dichiara come *«il limite più importante»*: senza, la frontiera `stop ≥ 40 × spread` **non si può calcolare** su quelle coppie | `spread_flotta/spread_orario_*.csv` non le copre | logger in sola lettura sul VPS: fuori perimetro |
| **N7** | 🔴 **Lo spread del banco `_EXT` è `[NON MISURATO]`, e potrebbe essere ZERO** (§9.1c). Finché non è letto, **ogni** numero `_EXT` di questo dossier ha un attrito ignoto | si legge a mano in MT5 → Vista → Simboli → `NASUSD_EXT` → campo Spread | 🟢 **zero minuti macchina**, è una lettura a schermo |
| **N8** | 🟡 **La finestra dello scan `CostToCost` H4 (la cella `exit 0`, n=194) non è dichiarata nel CSV** — quindi la sua frequenza è `[NON MISURATO]` e il §7.1 non può dire se i 194 sono su 2 anni o su 7 | i CSV di scan non portano le date; l'`.ini` generatore non è in repo per quella cartella | recupero `.ini`: `[NON MISURATO]` |
| **N9** | ⚪ **`E50EUR` · `F40EUR` · `100GBP` · `200AUD`: mai scaricati**, e hanno tutti un **gemello nativo BCM** su cui il cancello ZERO **si calcola** (a differenza del DAX) | fuori perimetro: nessun download | ~10-15 min/simbolo. ⚠️ **E prima va rifatta la frontiera del costo**: `E35EUR` sta a **540 pt** di spread, `E50EUR` a **200** |
| **N10** | ⚪ **Il Dow profondo Dukascopy (2012+): zero byte.** È il buco più grosso della flotta, perché `770202` **opera adesso** | il ritmo `curl` è misurato solo su 222 giorni (0,2 h); su 12 anni è `[NON MISURATO]`, e le due àncore distano **30×** | tranche pilota da ~200 giorni. Spazio disco: **~10 GB** |
| **N11** | 🟡 **Non ho verificato se la spina dorsale anno-per-anno di R103 esiste anche per il BLOCCO INDICI** (15 sedie, 21 mesi) | l'ho letta solo sul blocco forex+metalli | lettura: **0 minuti** |
| **N12** | 🔴 **Non ho scritto nessun file prova**, benché sia nel mio mandato generale | il brief di oggi dice **SOLA LETTURA** e *«nessuna riga di lancio (le scrivo io)»*. 👉 **Scelta deliberata, dichiarata qui per non farla sembrare una dimenticanza** | i file prova del §8 sono **7 famiglie × 1 file** — chi li scrive li fa passare da `controlla_prova.py` |

---

# 🏆 E LA COSA BUONA, perché è vera e perché conta

Questo dossier ha tredici «no». **Ma i tre «sì» che ha valgono più dei tredici «no».**

- 🟢 **Abbiamo una decomposizione di regime NATIVA, di 25 sedie, già misurata, in un file che
  è in repo da un mese.** CROLLO 2020, TORO 2021, ORSO 2022, anno per anno, con `n` e netto.
  **Costo per leggerla: zero.** Non ci mancava una tecnologia: ci mancava di aprire il file.
- 🟢 **Sull'oro la domanda di Claudio ha già mezza risposta, e la mezza che c'è è quella
  buona**: il drawdown che fa paura sta nel **2004-2019**, non nei sei anni recenti, e
  nell'anno **ORSO** quella sedia ha fatto il suo secondo miglior risultato di sette.
- 🟢 **E la prova di regime su forex e oro non costa una firma, non costa un cancello, non
  costa un import e non costa un download**: costa **18-42 minuti** sul PC di backtest, sul
  **nostro** feed, con le finestre che Claudio ha firmato il 14/08 e che **non si spostano**.

🔴 **E la notizia scomoda, detta lo stesso e per intero**: sugli indici — dove stanno **quattro
delle sei sedie in challenge** — la prova di regime **non è possibile, e su Dow e DAX non lo è
nemmeno in linea di principio.** Quelle sedie hanno **un solo regime alle spalle**, e il numero
onesto da scrivere nel loro contratto non è un DD: è **`[NON MISURABILE]`**.

> ## 🎯 **Non ci manca lo storico. Ci mancava di sapere DOVE ce l'avevamo — e sul forex e sull'oro ce l'avevamo in casa, sul nostro broker, da sempre.**

---

_📌 Nessun EA, preset, parametro, taglia, soglia o forward è stato toccato. Nessun round
lanciato, nessuna riga di lancio scritta, nessun import eseguito, nessun dato scaricato,
nessuna richiesta di rete. Le soglie citate (0,05% forex · 0,20 relativo indici · 150
operazioni · 1,00 op/giorno famiglia · 10% DD FTMO) sono **quelle già firmate da Claudio**:
nessuna è stata proposta, modificata o interpretata al ribasso._
