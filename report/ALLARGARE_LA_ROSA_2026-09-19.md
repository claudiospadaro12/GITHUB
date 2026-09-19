# 🌍 ALLARGARE LA ROSA — **simbolo × TF, scavato nell'archivio che abbiamo già**

**19/09/2026** · bussola: **+1 sedia schierabile il 1° ottobre** · seguito di
`report/FREQUENZA_DELLA_ROSA_2026-09-19.md` (*nessuna famiglia raggiunge 1,00*),
`report/QUANTI_SIMBOLI_PASSANO_2026-09-19.md` e `report/LA_VIA_PIU_CORTA_AI_150_2026-09-19.md`.

**Metodo**: 2.376 CSV sotto `backtest_pipeline/risultati_archivio/`, `risultati_prove/`,
`risultati_ottimizzazione/`; **315** appartengono ai tre motori della rosa e portano la colonna
`Profit Factor`; letti **cella per cella**, appaiando IS↔OOS sullo stesso `Pass` dove le due gambe
esistono. 🚫 **Round `ohlc` esclusi dai verdetti** (S7: screening, mai verdetto).

---

# ⓪ 🔴 PRIMA DI TUTTO — **tre correzioni alla premessa, e cambiano i conti**

## 0.1 🟢 **La famiglia Aperture il pavimento LO SUPERA GIÀ — 1,047 op/giorno**

Il referto della frequenza contava **solo `770101`**. Ma `ABTG_Dow_Apertura_US` **è lo stesso
motore** (`ABTG_Dow_Apertura_US.mq5` r.53: *«stesso motore dell'EA Nasdaq apertura, con altri
default»*, e tutti e tre montano `ABTG_ApertureCore.mqh`). Contata come famiglia, sul **backtest
OOS a tick reali** e **in POSIZIONI, non in deal**:

| gamba | posizioni OOS | giorni lavorativi | **op/giorno** |
|---|---:|---:|---:|
| `770101` **D30EUR** ora 08 | **193** | 276 | **0,699** |
| `770202` **U30USD** ora 14:30 | **96** | 276 | **0,348** |
| **famiglia Aperture** | **289** | 276 | 🟢 **1,047** |

> # 🟢 **1,047 contro un pavimento di 1,00.** Non serve un simbolo nuovo: serve che la seconda sedia giri davvero.

## 0.2 🔴 **Lo `0,864` del DAX è GONFIATO da un difetto noto: il numero vero è `0,705`**

`data/statements/trades_auto.csv`, `magic=770101`, `symbol=D30EUR`: **38 posizioni su 31 giornate
distinte**. Le 7 in più stanno **tutte su tre giornate**:

| giorno | posizioni | orari di apertura |
|---|---:|---|
| 2026.07.28 | 2 | 08:17 · 16:14 |
| 2026.07.29 | 3 | 08:53 · 08:53 · 13:01 |
| 2026.07.30 | **5** | 08:20 · 08:34 · 08:51 · 09:23 · 09:53 |

Le altre **28 giornate su 31 fanno una posizione esatta**. 👉 È la *«guardia "un trade al giorno"
col buco»* già censita in `report/LA_ROSA_PER_LA_PROP_2026-09-19.md` §⑤.
🔴 **Quando la guardia viene riparata la frequenza di campo scende a 31/44 = `0,705`.**

🟢 **E `0,705` è il numero GIUSTO, perché tre misure indipendenti ci cascano dentro:**

| misura | fonte | op/gg |
|---|---|---:|
| campo, depurato dal difetto | `trades_auto.csv` | **0,705** |
| backtest OOS `ptd`, 193 pos / 276 gg | `..._OOS_ptd.csv` r.75 + per-trade `770115` | **0,699** |
| backtest OOS `M_direzione`, 183 pos / 261 gg | `DAX_M_direzione_OOS.csv` r.4 | **0,701** |
| backtest IS `ptd`, 125 pos / 183 gg | `..._IS_ptd.csv` r.77 | **0,684** |

## 0.3 🔴 **«Una posizione al giorno» è vero per il motore, NON per `770101` in campo**

La premessa diceva *«posizioni = giornate distinte, 193=193 e 96=96»*. È vero **nel backtest** (e
l'ho verificato: 193 `position_id` su 193 giornate di chiusura, 96 su 96). 🔴 **In campo no**: il
massimo di `770101` è **5 posizioni in un giorno**. La differenza è il binario, non il motore.

---

# ① 📏 LA MISURA CHE MANCAVA A TUTTI: **il rapporto deal → posizioni, MISURATO**

Stamattina `QUANTI_SIMBOLI_PASSANO` ha dovuto scrivere *«la misura vera — le posizioni — per la
maggior parte delle combinazioni NON CE L'ABBIAMO»*. 🟢 **Per i motori della rosa ce l'abbiamo, e
stava in una cartella che nessun referto aveva aperto**: `risultati_prove/trades_portafoglio/`
(sei file `abtg_trades_*`, prodotti dai round per-trade R16b/c/d dell'09/08/2026).

Conteggio dei **`position_id` distinti**, contro la colonna `Trades` del CSV di ottimizzazione:

| EA · simbolo | file per-trade | **deal** | **POSIZIONI** | **rapporto** | 1 deal | 2 deal | 3 deal |
|---|---|---:|---:|---:|---:|---:|---:|
| `DAX_Apertura_EU` · D30EUR | `..._D30EUR_770115.csv` | 270 | **193** | **1,399** | 116 | 77 | — |
| `Dow_Apertura_US` · U30USD | `..._U30USD_770206.csv` | 130 | **96** | **1,354** | 62 | 34 | — |
| `MaxMinNotte_DAX_Short` · D30EUR | `..._D30EUR_770413.csv` | 21 | **14** | 1,500 | 7 | 7 | — |
| `MaxMinNotte` · XAUUSD | `..._XAUUSD_770405.csv` | 92 | **68** | 1,353 | 47 | 18 | 3 |
| `ORB_Ottimizzato` · U30USD | `..._U30USD_770612.csv` | 119 | **119** | **1,000** | 119 | — | — |
| `SupertrendReversal` · 225JPY | `..._225JPY_770903.csv` | 50 | **31** | 1,613 | 12 | 19 | — |

🧪 **CONTRO-ESEMPIO, costruito apposta**: se il rapporto fosse un artefatto del conteggio,
l'`ORB_Ottimizzato` dovrebbe averlo anche lui. **Fa 119 = 119, esattamente 1,000** — ed è l'unico
dei sei **senza parziale**. Il rapporto misura la parziale, non il lettore. ✅

🔴 **E il limite, dichiarato**: ogni rapporto vale **per la cella su cui è misurato**. Trasportarlo
a un'altra cella è `[DERIVATO]`, e sotto si vede un caso in cui il pavimento dei 150 **cade dentro
la banda** (§③.3).

### 1.1 🔗 La catena è CHIUSA, e l'ho verificata invece di assumerla
Il round `ptd` a 360 passate **non ha un file prova in `prove/`** (l'etichetta `ptd` è stata
riusata: `R16d_pertrade_DAX.txt` la assegna a una cella singola, non a una griglia 12×15). Quindi
la sua finestra **non è dichiarata da nessuna parte** e andava dimostrata, non supposta. Tre fatti
indipendenti la chiudono:

| controllo | numero | esito |
|---|---|---|
| `ptd` rng35/buf500: `Trades` IS + OOS | 175 + 270 = **445** | — |
| `DAX_M_direzione` stessa cella (finestra **dichiarata** in `REFERTO_FASE_B_C5.md`: IS 26/09/2024→30/06/2025, OOS 01/07/2025→30/06/2026) | 189 + 256 = **445** | 🟢 **identico** — stesso arco totale, taglio IS/OOS diverso (39,3% contro 42,5%) |
| per-trade `770115` | 270 righe, **2025.06.11 → 2026.06.25** | 🟢 coincide col `Trades` OOS di `ptd` **e** con l'inizio dell'OOS a `@FRAZIONEIS 0,40` (10/06/2025) |

👉 **Il round `ptd` gira `2024.09.26 → 2026.06.30`, sopra il pavimento tick degli indici, e il
per-trade che uso per il rapporto è esattamente la sua gamba OOS.** Se avessi solo assunto la
finestra, il `193` di §0.1 sarebbe stato un numero senza catena.

🟢 **Stessa verifica sul Dow, e torna allo stesso modo**: il per-trade `770206` ha **130 righe**,
esattamente il `Trades` OOS della cella `ptc` P1 (L-only, rng 35, buf 1000, retest 400), e il suo
file prova `prove/R16c_pertrade_Dow.txt` **dichiara** `@DAQUANDO 2024.09.26`. La finestra di `ptc`
è quella, e il `96` di §0.1 ha la sua catena.

---

# ② 🗺️ LA TABELLA — **simbolo × TF × motore, contro i cancelli**

Cancelli: **S1** n ≥ 150 *(qui dichiarato `[deal]` o `[pos]`)* · **S2** PF ≥ 1,10 · **S3** DD ≤ 14% ·
**S4** segni concordi · **S7** niente `ohlc`.
Finestra standard: `@DAQUANDO 2024.09.26 → @FINOA 2026.06.30`, `@FRAZIONEIS 0,40`
(IS 183 gg lav · OOS 276 gg lav), **tick reali** (pavimento tick indici **2024.09.26**, misurato).

## 2.1 🏛️ FAMIGLIA **APERTURE** (`770101` · `770202` · `770250`)

| simbolo | TF | lati | cella | IS n | IS PF | IS DD | OOS n | OOS PF | OOS DD | S1 pos | esito | fonte (file · riga) |
|---|---|---|---|---:|---:|---:|---:|---:|---:|---|---|---|
| 🟢 **D30EUR** | M5 | **L** | `ptd` rng35 buf500 | 175 | **1,126** | 5,44 | 270 | **1,397** | 7,23 | IS 125 ❌ · **OOS 193 ✅** | 🟢 **PASSA** (merito letto su OOS) | `risultati_prove/ABTG_DAX_Apertura_EU/..._{IS,OOS}_ptd.csv` rr. **77** / **75** |
| D30EUR | M5 | S | `M_direzione` P7 | 152 | **0,846** | 10,54 | 243 | 1,065 | 12,05 | — | 🔴 **NO** (S2 su IS, S4) | `Walkforward_Aperture/DAX_M_direzione_{IS,OOS}.csv` rr. **7** / **2** |
| D30EUR | M5 | L+S | `M_direzione` P10 | 224 | **0,998** | 8,41 | 316 | 1,237 | 10,49 | — | 🔴 **NO** (S2 su IS) | idem rr. **10** / **12** |
| 🟡 **U30USD** | M5 | **L** | `ptc` P1 rng35 | 74 | 1,222 | 5,67 | 130 | 1,270 | 4,39 | IS 55 ❌ · OOS 96 ❌ | 🟠 **merito SOSPESO** (campione) | `risultati_prove/ABTG_Dow_Apertura_US/..._{IS,OOS}_ptc.csv` rr. **8** / **7** |
| U30USD | M5 | L+S | `ptc` P3 rng25 | 150 | 1,132 | 9,07 | 218 | 1,205 | 9,92 | IS 111 ❌ · OOS **161 ❓** | 🔴 **NO su S4** — vedi §③.3 | idem rr. **7** / **5** |
| NASUSD | M5 | L | `M_direzione` P4 | 156 | **0,963** | 7,22 | 196 | 1,130 | 4,90 | — | 🔴 **NO** (S2 su IS, S4) | `Walkforward_Aperture/NASDAQ_M_direzione_{IS,OOS}.csv` rr. **5** / **6** |
| NASUSD | M5 | S | `M_direzione` P7 | 142 | 1,165 | 7,54 | 197 | **0,823** | 9,10 | — | 🔴 **NO** (S2 su OOS, S4) | idem rr. **6** / **9** |
| NASUSD | M5 | L+S | `M_direzione` P10 | 220 | **0,928** | 11,56 | 301 | 1,022 | 7,88 | — | 🔴 **NO** (S2 su tutte e due) | idem rr. **12** / **10** |
| 100GBP | M5 | L+S | `valid_Apertura_100GBP` | — | — | — | — | — | — | — | 🔴 **NO**: **0 celle su 96 con PF ≥ 1,00**, DD fino a **42,1%** | `Apertura_nuovi_indici/valid_Apertura_100GBP_FTSE.csv` |
| F40EUR · E50EUR · E35EUR · SPXUSD | M5 | L+S | studio per-trade | — | — | — | — | — | — | — | 🔴 **NO**: aspettativa **negativa** — vedi §2.4 | `studio_apertura/Studio_*_RIEPILOGO.csv` |

## 2.2 🌙 FAMIGLIA **MaxMinNotte** (`770411` D30EUR short · `770402` XAUUSD)

| simbolo | TF | cella | passate | celle con PF ≥ 1,10 | DD max | esito | fonte |
|---|---|---|---:|---:|---:|---|---|
| D30EUR | M15 | `r81a` / `valid_MaxMin_DAX_short_refine` | 36 | 18 su 36 | 9,27% | 🟠 **merito SOSPESO**: n max **107 [deal] = 71 [pos]** | `MaxMinNotte/valid_MaxMin_DAX_short_refine.csv` |
| XAUUSD | H2 | `770402` | — | — | — | 🟠 **merito SOSPESO**: **68 posizioni** OOS | per-trade `..._XAUUSD_770405.csv` |
| 🔴 **F40EUR** | M15 | `valid_MaxMin_F40EUR` | 72 | **0** | **40,7%** | 🔴 **NO, MISURATO** (PF max 0,999) | `MaxMinNotte/4528c79b-valid_MaxMin_F40EUR.csv` |
| 🔴 **E50EUR** | M15 | `valid_MaxMin_E50EUR` | 72 | **0** | **35,2%** | 🔴 **NO, MISURATO** (PF max 0,840) | `MaxMinNotte/8eefb007-valid_MaxMin_E50EUR.csv` |
| 🔴 **100GBP** | M15 | `valid_MaxMin_100GBP` | 72 | **0** | **48,3%** | 🔴 **NO, MISURATO** (PF max 0,672) | `MaxMinNotte/efe054b5-valid_MaxMin_100GBP.csv` |
| ⚪ **NASUSD** | M15 | `R187a` / `R187b` | — | — | — | ⚪ **NON MISURATO** — file prova pronti, **mai girati** | `prove/R187{a,b}_*.txt` |

## 2.3 🌊 FAMIGLIA **SuperWave** (`770511`/`770512` U30USD H1)

Qui l'archivio ha una cosa che nessuno aveva letto: **una scala completa di timeframe, su 9
simboli, a tick reali**, girata il 07-09/08/2026 (`prove/ABTG_SuperWave.txt`, asse `InpTF` M15→D1,
11 membri ENUM). Sotto solo le righe dove **almeno una finestra supera 150 [deal]**, cioè dove il
merito **è leggibile**:

| simbolo | TF | IS n | IS PF | OOS n | OOS PF | OOS DD | verdetto |
|---|---|---:|---:|---:|---:|---:|---|
| **U30USD** | **H1** | 84 | 1,849 | **143** | **1,328** | 3,91 | 🟠 merito sospeso *(n<150 in tutte e due)* — **è la sedia viva** |
| **U30USD** | **M30** | 140 | 0,991 | **320** | 🔴 **0,868** | 11,44 | 🔴 **NO — merito LETTO sull'OOS** |
| **U30USD** | **M20** | 262 | 1,235 | **512** | 🔴 **0,753** | **14,17** | 🔴 **NO** (merito **e** rischio) |
| **U30USD** | **M15** | 349 | 0,998 | **637** | 🔴 **0,826** | **14,07** | 🔴 **NO** (merito **e** rischio) |
| D30EUR | M15 | 302 | 0,738 | 578 | 1,046 | 7,59 | 🔴 **NO** (S2 su tutte e due) |
| D30EUR | H1 | 80 | 0,546 | 149 | 0,892 | 8,93 | 🔴 **NO** |
| NASUSD | M15 | 139 | 1,496 | **256** | 🔴 **0,906** | 2,40 | 🔴 **NO** — merito letto sull'OOS |
| SPXUSD | M15 | 173 | 1,235 | **280** | 🔴 **0,836** | 3,65 | 🔴 **NO** *(+ spread `[NON MISURATO]` su SPXUSD)* |
| 225JPY | M20 | 179 | 0,662 | **283** | 1,239 | 1,89 | 🔴 **NO** (S2 su IS, S4) |
| XAUUSD | M15 | 153 | 0,641 | 202 | 0,986 | 5,18 | 🔴 **NO** |
| USDJPY | M15 | 268 | 0,895 | 360 | 0,939 | 5,80 | 🔴 **NO** |
| GBPUSD | M15 | 267 | 0,812 | 360 | 0,724 | 8,88 | 🔴 **NO** |

*(fonte: `risultati_prove/ABTG_SuperWave/ABTG_SuperWave_<SIM>_{IS,OOS}.csv` e
`risultati_prove/ABTG_SuperWave_DOW_H1_Ottimizzato/ABTG_SuperWave_DOW_H1_Ottimizzato_U30USD_{IS,OOS}.csv`
righe 7-9 per M15/M20/M30 e 3/7 per H1 — **file NON `ohlc`**)*

E la scansione di validazione separata (`risultati_archivio/SuperWave/valid_SuperWave_*.csv`,
9 passate per simbolo·TF) dice la stessa cosa sui simboli gemelli:

| simbolo · TF | celle PF ≥ 1,10 | n | verdetto |
|---|---:|---:|---|
| 🟢 **U30USD H1** | **9 su 9** | 209-227 | 🟢 altopiano pieno — **è la sedia** |
| U30USD H4 | 8 su 9 | **23-28** | 🟠 campione nullo |
| D30EUR H4 | 6 su 9 | **54-59** | 🟠 campione nullo |
| NASUSD H1 | 2 su 9 | **89-97** | 🟠 campione sotto |
| D30EUR H1 | **0 su 9** | 228-258 | 🔴 **NO, MISURATO** (PF 0,61-0,84) |
| XAUUSD H1 | 0 su 9 | 98-122 | 🔴 NO |
| NASUSD H4 · XAUUSD H4 | 0 su 9 | 16-35 | 🔴 NO |

## 2.4 📐 E LA SONDA CHE CHIUDE GLI INDICI EUROPEI **prima di spendere un minuto**

`risultati_archivio/studio_apertura/Studio_*_RIEPILOGO.csv` — studio per-trade del breakout
d'apertura **cieco**, ~430-690 giornate per simbolo, aspettativa in **R per trade**:

| simbolo | trade | **aspettativa R (cieco)** | con filtro H4 |
|---|---:|---:|---:|
| 🟢 **U30USD** | 446 | **+0,074** | **+0,126** |
| 🟢 **D30EUR** | 440 | **+0,026** | −0,017 |
| 🟡 NASUSD | 447 | +0,001 | +0,055 |
| 🔴 SPXUSD | 444 | −0,017 | −0,002 |
| 🔴 E35EUR | 211 | −0,048 | −0,129 |
| 🔴 E50EUR | 440 | −0,048 | −0,068 |
| 🔴 F40EUR | 443 | −0,056 | −0,109 |
| 🔴 **100GBP** | 431 | **−0,138** | −0,137 |

> ## 🔴 **L'edge dell'apertura esiste su DUE indici: quelli che già usiamo.** Gli europei non-DAX sono negativi su 4 su 4, e su `100GBP` la misura indipendente dell'EA (0 celle positive su 96) dice la stessa cosa.

🔴 **E anche se fossero stati positivi non sarebbero promuovibili**: su `F40EUR`, `SPXUSD`,
`E35EUR`, `E50EUR`, `100GBP` **non esiste nessuno spread misurato**
(`report/ANCORA_ADR_FLOTTA_INDICI_2026-09-18.md` §6) → cancello di costo `[NON CALCOLABILE]`.

---

# ③ 🧪 I TRE CONTRO-ESEMPI, costruiti PRIMA di consegnare

## 3.1 🔴 **«Si scende di TF per comprare operazioni»** — su SuperWave è MISURATO, e non funziona

`LA_VIA_PIU_CORTA_AI_150` mette al **🥇 posto** l'intervento *«`SuperWave_DOW_H1_Ott` U30USD —
`InpTF` H1 → M30, Δn +61…+99, 🟢 un CANDIDATO»*. 🔴 **Quella discesa è già in archivio, a tick
reali, sulla stessa finestra**:

| TF | IS n | IS PF | OOS n | **OOS PF** | OOS DD | riga |
|---|---:|---:|---:|---:|---:|---|
| H1 | 84 | 1,849 | 143 | **1,328** | 3,91 | IS r.7 · OOS r.3 |
| **M30** | 140 | 0,991 | **320** | 🔴 **0,868** | 11,44 | IS r.8 · OOS r.8 |
| M20 | 262 | 1,235 | 512 | 🔴 0,753 | 14,17 | OOS r.7 |
| M15 | 349 | 0,998 | 637 | 🔴 0,826 | 14,07 | OOS r.9 |

*(`risultati_prove/ABTG_SuperWave_DOW_H1_Ottimizzato/ABTG_SuperWave_DOW_H1_Ottimizzato_U30USD_{IS,OOS}.csv`)*

> ## 🎯 **A M30 l'OOS ha 320 operazioni: il merito NON è sospeso, è LETTO — e dice 0,868.** Scendendo di TF le operazioni salgono del 4× e il PF fuori campione **crolla in modo monotòno**.

### 🧪 E il contro-contro-esempio, perché l'obiezione è legittima
*«Quel round non è la cella `r120e11`.»* Verificato **a macchina, colonna per colonna**: fra la
cella H1 del round base e `r120e11` **ogni input condiviso è IDENTICO** — l'unica differenza è
`InpMagic`. Cambia il **binario**: `r120e11` gira su un build più recente che ha quattro colonne in
più (`InpPendingAtr`=0, `InpSLBufferAtr`=0, `InpUsaGuardian`=1, `InpLogImbuto`=1).
🔴 **Quindi non è la prova definitiva.** 🟢 **Ma il verso è quello brutto**: sul binario vecchio la
cella H1 fa **PF OOS 1,328**, su `r120e11` fa **1,220** — il binario che fallisce a M30 è quello
che a H1 andava **meglio**. Se l'edge muore scendendo sotto il build migliore, è improbabile che
sopravviva sotto quello peggiore.
👉 **`R190b` resta utile — costa 2 minuti e chiude la casella — ma va lanciato come CERTIFICATO,
non come candidato.** Il suo file prova dichiara *«la cella non-promossa più bella
dell'archivio»*: quella frase, con questi numeri accanto, va corretta prima della corsa.

## 3.2 🔴 **«Si accende il lato SHORT per raddoppiare la frequenza»** — misurato, e costa soldi

### Sul **Dow** (`ptc`, stesso round, stessi gemelli, tre valori di `InpRangeMinutes`)

| rng | LONG-only OOS profit | **L+S OOS profit** | Δ profit | Δ deal |
|---:|---:|---:|---:|---:|
| 25 | **11.720,93** | 8.439,48 | 🔴 **−3.281,45** | +80 |
| 35 | **6.721,93** | 3.926,85 | 🔴 **−2.795,08** | +73 |
| 45 | **11.793,89** | 5.784,38 | 🔴 **−6.009,51** | +72 |

In IS lo stesso confronto è **positivo su 3 su 3** (+2.291 · +6.649 · +8.013).
> ## 🔴 **Segno IS positivo su 3/3, segno OOS negativo su 3/3: è il fallimento di S4 (coerenza dei segni), e non è una cella sola — è tutto l'asse.**

⚠️ **Limite dichiarato**: con `InpOneTradePerDay=1` la differenza *non è esattamente «il lato
short»* (uno short può prendere il posto di un long nella stessa giornata). 🟢 **Ma la conclusione
utile non dipende da questo**: la configurazione a due lati **guadagna meno fuori campione su 3
range su 3** pur facendo **+55% di operazioni**. La frequenza non è gratis.

### Sul **DAX** (`Walkforward_Aperture/DAX_M_direzione`, IS 26/09/2024→30/06/2025, OOS 01/07/2025→30/06/2026, tick reali)

| lati | IS n | **IS PF** | OOS n | OOS PF |
|---|---:|---:|---:|---:|
| **LONG** (la sedia) | 189 | **1,131** | 256 | **1,423** |
| SHORT | 152 | 🔴 **0,846** | 243 | 1,065 |
| L+S | 224 | 🔴 **0,998** | 316 | 1,237 |

🔴 **Lo short affonda l'IS su 3 range su 3 (0,824 · 0,846 · 0,771) e trascina sotto anche la
combinazione.** Due simboli indipendenti, stesso verdetto.
🟢 **E così la REGOLA DEI DUE LATI del 25/08 è soddisfatta su tutti e tre gli indici**: il lato
short dell'apertura **è stato misurato** su D30EUR, U30USD e NASUSD, ed è un no su tutti e tre.

## 3.3 🔴 **«La cella a due lati del Dow passa S1»** — no: il pavimento cade DENTRO la banda

La cella `ptc` P3 fa **218 deal in OOS**. Con il rapporto misurato sul Dow (**1,354**) sono
**161 posizioni**, sopra il pavimento. 🔴 **Ma quel 1,354 è misurato sulla cella LONG-ONLY**, e il
rapporto dipende da quante posizioni arrivano al parziale di 1R.

| rapporto ipotizzato | posizioni da 218 deal | S1 |
|---:|---:|---|
| 1,000 (nessuna parziale) | 218 | ✅ |
| **1,354** (misurato su LONG-only, stesso EA/simbolo) | **161** | ✅ |
| **1,453** (soglia di rottura) | **150** | ⚖️ **esatto sul filo** |
| 1,500 (misurato su `MaxMinNotte` D30EUR) | 145 | ❌ |

> ## 🔴 **Il valore che rompe il verdetto (1,453) sta DENTRO la banda dei rapporti già misurati in casa (1,000–1,613).** Quindi `S1` su quella cella è `[NON MISURATO]`, non «passato».
> **Via più corta al numero**: un round a cella singola con asse sul **magic** (2 gemelli, che sono
> anche il cancello G1) fa scrivere il per-trade e dà il conteggio vero. **2 passate, ~0,8 min.**

---

# ④ 🕳️ LA CASELLA LIBERA CHE NESSUNO HA MAI TOCCATO: **`InpSessionHour`**

Scansione dei **2.376 CSV**: **230** portano la colonna `InpSessionHour`.

| colonna | CSV che la contengono | CSV che la hanno **AD ASSE** |
|---|---:|---:|
| `InpRangeMinutes` | 230 | **54** |
| `InpSessionMin` | 230 | 🔴 **0** |
| **`InpSessionHour`** | **230** | 🔴 **0** |

> ## 🎯 **In due anni di round, l'ORA della sessione non è MAI stata messa ad asse.** È una casella **libera**, non una casella provata — esattamente la distinzione che il censimento del 09/09 chiede di fare.

**Perché vale**: la famiglia Aperture fa **al massimo una posizione al giorno per simbolo**
(`InpOneTradePerDay=true`, e il per-trade lo conferma: 193 posizioni su 193 giornate). La sua
portata cresce solo con **un simbolo in più** — e i simboli sono esauriti (§2.4) — **oppure con una
SESSIONE in più sullo stesso simbolo**. È lo stesso meccanismo che `R187b` usa sul `MaxMinNotte`
(una seconda "notte", quella americana), applicato al motore che funziona meglio.

🔴 **Attenzione**: per `MaxMinNotte` e per `Aperture` il **timeframe NON è una leva di frequenza**
(il box notturno e il range d'apertura sono definiti in minuti di orologio, non in barre). Per
`SuperWave` **lo è** — ed è quella che §3.1 ha appena misurato e bocciato.

---

# ⑤ 📊 LA FREQUENZA NUOVA, famiglia per famiglia

| famiglia | oggi (campo, `FREQUENZA_DELLA_ROSA`) | **corretta / misurata oggi** | contro **1,00** |
|---|---:|---:|---|
| 🟢 **Aperture** (`770101`+`770202`) | 0,864 *(solo `770101`, con il difetto dentro)* | **1,047** *(0,699 + 0,348, backtest OOS in posizioni)* | 🟢 **SUPERATO (+4,7%)** |
| ↳ *la stessa, in campo a oggi* | — | 0,705 + **0,129** = **0,834** | 🔴 sotto — è un problema **operativo** |
| 🔴 **MaxMinNotte** (`770411`+`770402`) | 0,552 | **0,552** *(nessun simbolo nuovo passa)* | 🔴 sotto · +NASUSD `[NON MISURATO]` |
| 🔴 **SuperWave** (`770511`) | 0,290 *(segnali)* | **0,290** *(ogni TF più basso è refutato)* | 🔴 sotto, **e la via del TF è chiusa** |

## 🔴 IL VERO BUCO DELLA FAMIGLIA CHE PASSA
`770202` in campo: **4 posizioni in 31 giorni lavorativi = 0,129 op/giorno**, contro **0,348**
promessi dal backtest — un **fattore 2,7**. Ultima operazione **28/08/2026**, poi nulla per 16
giorni lavorativi.
👉 **Non è una domanda di ricerca: è una domanda su cosa sta facendo quella sedia.** È la via più
corta a `+0,22 op/giorno` di tutto questo dossier, e **non costa un minuto di macchina**.

---

# ⑥ ⚪ COSA RESTA **"NON ANCORA MISURATO"** — con la via più corta e il costo

*(certificato di morte del 09/09: senza PF, n, DD, uscita ad asse, gemelli, TF cambiato → **non
misurato**, mai **morto**)*

| # | combinazione | cosa manca del certificato | via più corta | costo macchina |
|---:|---|---|---|---|
| 1 | `Dow_Apertura_US` U30USD L+S — **conteggio in POSIZIONI** | ① n in posizioni | round a cella singola, asse sul **magic** (2 gemelli) | **2 passate · ~0,8 min** |
| 2 | `DAX_Apertura_EU` D30EUR — **altra ORA di sessione** | ⑤ *(manopola mai ad asse)* | 🟢 **`prove/R192a_sessionhour_DAXAPERTURA_D30EUR.txt`** | **12 passate · 1,1–9,0 min** |
| 3 | `DAX_Apertura_EU` D30EUR — **apertura USA 14:30** | ⑤ | 🟢 **`prove/R192b_aperturaUSA_DAXAPERTURA_D30EUR.txt`** | **4 passate · 0,8–3,4 min** |
| 4 | `MaxMinNotte` **NASUSD** (notte EU e notte US) | ①②③④⑤ tutto | `prove/R187a` + `R187b` — **già scritti, mai girati** | 15–25 min *(stima R187)* |
| 5 | `MaxMinNotte` D30EUR — **`InpMgmtTF` mai mosso da M15** a dato pieno | ⑤ TF | asse `InpMgmtTF` M5→H1 | 4 celle · 8 passate |
| 6 | `SuperWave_DOW_H1_Ott` U30USD **M30** sul binario nuovo | ⑤ *(misurato sul binario vecchio)* | `prove/R190b` — già scritto | 4 passate · 0,9–2,1 min |
| 7 | `Aperture` D30EUR — **ampiezza del range alle 14:30** | cancello di **costo** | sonda per-trade sullo Studio | *(analisi, zero macchina)* |
| 8 | `SuperWave` NASUSD **H1** (n 89-97) | ① campione | ⚪ nessuna: la finestra è già al pavimento tick | — |

🔴 **E una cosa che NON è "non misurata", è un buco di dati**: `F40EUR`, `SPXUSD`, `E35EUR`,
`E50EUR`, `100GBP` non hanno **nessuno spread misurato**. Su quei simboli la via più corta **non è
un round: è una sonda di spread**.

🪦 **E tre morti col certificato completo, che da oggi si possono archiviare:**
`MaxMinNotte` × **F40EUR** · × **E50EUR** · × **100GBP** — 72 passate ciascuno, **zero celle con
PF ≥ 1,10**, DD fino al **48,3%**, gestione e simboli gemelli già ad asse nel round stesso.

---

# ⑦ 📦 I DUE FILE PROVA PRONTI — **e NON sono stati lanciati**

| file | asse unico | celle | passate | costo *(estremo alto)* | `controlla_prova.py` |
|---|---|---:|---:|---:|---|
| `backtest_pipeline/prove/R192a_sessionhour_DAXAPERTURA_D30EUR.txt` | **`InpSessionHour`** 8→13 | **6** | **12** | **9,0 min** | ✅ **OK, 0 problemi** |
| `backtest_pipeline/prove/R192b_aperturaUSA_DAXAPERTURA_D30EUR.txt` | `InpMagic` (2 gemelli G1) | **2** | **4** | **3,4 min** | ✅ **OK, 0 problemi** |

**Totale: 8 celle, 16 passate, ~12,4 minuti** all'estremo alto della banda (base **misurata** sullo
stesso EA e simbolo: 0,700 min/passata, R104).

🟢 **Quattro scelte di metodo che valgono più del costo**, e stanno scritte **dentro** i file:
1. **L'ÀNCORA è dentro il round.** La cella *ora 8* di `R192a` deve riprodurre `ptd` al centesimo
   (IS n=175 · PF 1,12634 · DD 5,4362% · OOS n=270 · PF 1,39709 · DD 7,2328%, letti oggi alle
   righe **77** e **75** del CSV grezzo). Se non riproduce, **le altre cinque celle non si
   leggono**: si è misurato il binario, non l'ora.
2. 🔴 **Due pin cambiano rispetto a `ptd`, e sono dichiarati**: `InpUsaGuardian` a HEAD ha
   default **`true`** (r.144) e va pinnato **`false`**, altrimenti l'àncora non può riprodurre un
   round girato su un binario che il Guardian non aveva. `InpAllowReverse` (r.279) è già `false`
   di default, pinnato lo stesso.
3. 🔴 **Il confondente è dichiarato PRIMA, con una regola di lettura asimmetrica**:
   `InpCloseHour` resta 17:30 per tutte le celle (serve all'àncora), quindi le ore tarde hanno meno
   spazio. **Una cella che BATTE l'ora 8 con meno spazio è un segnale vero; una che perde può
   perdere contro la tagliola, e il suo verdetto è `[NON MISURATO]`.**
4. 🔴 **`R192a` non può usare il per-trade** (magic pinnato, sei celle sullo stesso nome file =
   classe 455): la sua `n` si dichiara `[deal]`. **`R192b` sì**, perché lì l'asse *è* il magic.

🖥️ **Bersaglio dichiarato in testa a tutti e due**: banco da backtest `C:\MT5_Backtest`, demo
**50504400**. **NON** il piccolo `50503392`, **NON** il 100k `50504263`, **NON** il reale
`10105439`.
⏳ **Il secondo strato del cancello (`controllo-preventivo`) NON è stato invocato da me: lo lancia
il coordinatore. Finché non torna, questi file non vanno verso il VPS.**

---

# ⑧ 🚨 UN AVVISO CHE NASCE DA QUESTO DOSSIER E NON È DI QUESTO DOSSIER

Se `R192b` promuovesse, la seconda sessione girerebbe **sullo stesso simbolo** di `770101`. Su
conto **HEDGING** la chiusura di fine sessione usa `PositionClose(_Symbol)`, che chiude la
posizione **più vecchia del simbolo di chiunque**
(`report/AUDIT_POSITIONSELECT_HEDGING_2026-09-03.md` r.39) — **lo stesso blocco che stamattina ha
fermato le due sedie Nasdaq** (`report/DUE_SEDIE_NASDAQ_IL_BLOCCO_2026-09-19.md`).
🔴 **Due sedie Aperture sullo stesso simbolo non si accendono finché quella chiusura non è per
TICKET.** Il backtest non lo vede: nel tester gira un EA solo.

---

# ⑨ 📌 IN UNA RIGA

🟢 **La famiglia che passa è UNA, ed è quella che abbiamo già: Aperture su D30EUR + U30USD, 1,047
op/giorno misurate in POSIZIONI.** 🔴 **Tutte le strade per allargare le altre due sono già state
percorse e sono negative: i simboli gemelli del `MaxMinNotte` (0 celle su 216), i TF bassi del
`SuperWave` (OOS PF 0,868 · 0,826 · 0,753 con 320-637 operazioni), il lato short dell'apertura (IS
+ / OOS − su 3 su 3, due simboli).** 🎯 **L'unica casella davvero libera è l'ORA della sessione —
mai messa ad asse in 230 CSV su 230 — e costa 16 passate.**

---
*Fonti principali, tutte con percorso e riga nel testo: `risultati_prove/trades_portafoglio/*.csv`
(conteggio `position_id`) · `risultati_prove/ABTG_DAX_Apertura_EU/..._ptd.csv` ·
`risultati_prove/ABTG_Dow_Apertura_US/..._ptc.csv` ·
`risultati_archivio/Walkforward_Aperture/{DAX,NASDAQ}_M_direzione_{IS,OOS}.csv` ·
`risultati_prove/ABTG_SuperWave*/...` · `risultati_archivio/SuperWave/valid_*.csv` ·
`risultati_archivio/MaxMinNotte/*valid_MaxMin_*.csv` ·
`risultati_archivio/Apertura_nuovi_indici/valid_Apertura_*.csv` ·
`risultati_archivio/studio_apertura/Studio_*_RIEPILOGO.csv` · `data/statements/trades_auto.csv` ·
`report/ANCORA_ADR_FLOTTA_INDICI_2026-09-18.md` §6 per gli spread mancanti.*
