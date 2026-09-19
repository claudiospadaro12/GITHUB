# 🧭 LA VIA PIÙ CORTA AI 150 — **quante operazioni si comprano con un minuto di macchina**

**19/09/2026** · nasce da *«ALLARGHIAMO»* e da *«SE DOVETE ANDARE + A FONDO SU ALCUNI PER VEDERE
SE SI TROVANO PARAMETRI MIGLIORI, FATE PURE»* (Claudio) · seguito operativo di
`report/QUANTI_SIMBOLI_PASSANO_2026-09-19.md`

**Metodo**: censimento rifatto da zero sui **2.376 CSV** di `backtest_pipeline/risultati_prove/`,
`risultati_archivio/` e `risultati_ottimizzazione/`. Di questi, **964** hanno un nome appaiabile
`EA_SIMBOLO_{IS,OOS}_etichetta.csv` e sono stati letti **cella per cella** (stesso `Pass`, gamba
IS ↔ gamba OOS): **195 combinazioni EA × simbolo**, **444 round distinti**.
🔴 Il simbolo è preso dal **nome del file**, non da una colonna: dentro i CSV il simbolo **non
c'è** (classe 444). Dove una riga di questo referto pesa, la catena è chiusa sul file prova
(`@SIMBOLO`), e dove non lo è sta scritto.
Tabella completa: **`report/VIA_PIU_CORTA_AI_150_2026-09-19.csv`** (113 righe, 16 colonne).

---

## ① 🔴 PRIMA DI TUTTO: **LA COSA CHE RENDE INUTILE METÀ DELLA LISTA, E VA DETTA PRIMA**

> # **Su BCM, «più finestra» e «tick reali» SI ESCLUDONO A VICENDA.**

| pavimento | valore | fonte |
|---|---|---|
| tick reali **indici** (`D30EUR` `U30USD` `NASUSD`) | **2024.09.26** | `risultati_archivio/misura_tick/REFERTO_MISURA_TICK_*.txt` — 35,4 M · 67,6 M · 166,5 M tick, `[MISURATO]` |
| tick reali **forex e metalli** | **2024.07.05** | Diario MT5 *«ticks data begins from 2024.07.05»*, `report/DIAGNOSI_GBPUSD_LENTA_2026-09-02.md` F4 |
| **barre** forex a H1 | **1999** operativo (storico dichiarato 1971/1993) | `risultati_archivio/REFERTO_SONDA_STORICO_17-08.md` + `R102_REFERTO_BLOCCO1.md` |
| **barre** indici | **2024.09.26**, stato `COMPLETO` | sonda 17/08 — *il broker non ce l'ha* |

🔴 **Conseguenza, scritta col nome di casa**: su qualunque simbolo, allungare la finestra oltre
il pavimento dei tick trasforma il round in **OHLC/M1 generato**, cioè in **SCREENING, mai un
verdetto** (regola S7). E **MT5 a `Model=4` non si ferma quando i tick mancano: se li fabbrica
dalle barre M1, in silenzio.**
👉 Quindi la voce *«si allunga la finestra»* — che sarebbe la risposta ovvia a «manca campione» —
**vale zero su 12 simboli su 12 degli indici e vale al massimo +13% sul forex** (2,7 mesi in più
su 21). **Non è una cosa da provare: è una cosa da smettere di sperare.**

🟢 **E la contropartita c'è**: le leve che restano (taglio IS/OOS, timeframe) **non costano dati,
costano minuti** — che è esattamente la valuta che abbiamo.

---

## ② 📊 IL CENSIMENTO, RIFATTO — e **non coincide col mio elenco di stamattina**

Cancelli applicati **cella per cella**, con le regole di casa **nel verso giusto**:
- 🛡️ il **RISCHIO** (`DD ≤ 14%`) si legge a **QUALUNQUE n** — Emendamento B, 16/08;
- ⚖️ il **MERITO** (`PF ≥ 1,10`) si legge **solo sopra 150, e PER FINESTRA** — Emendamento A;
- 🚫 i round **OHLC sono esclusi**: screening, mai verdetto.

| classe | combinazioni | che vuol dire |
|---|---:|---|
| 🟢 **PASSA** | **4** | almeno una cella con `n≥150` + `PF≥1,10` + `DD≤14%` in **entrambe** |
| 🔴 **BOCCIATA per RISCHIO** | **10** | `DD > 14%` in una finestra, a qualunque n |
| 🔴 **BOCCIATA per MERITO** | **5** | `n≥150` in una finestra **e** `PF<1,10` **in quella finestra** |
| 🟠 **FERMA per CAMPIONE** | **113** | nessuna cella refutata, e nessuna sopra il pavimento in entrambe |

> ### 🟢 **Le 4 che passano sono le stesse del referto di stamattina** (`DAX_Apertura_EU` D30EUR ·
> `EMA200` U30USD · `EMA200` EURUSD · `Dow_Apertura_US` U30USD), e questo è un buon segno: due
> conteggi indipendenti, stesso risultato.

🔴 **Ma ci sono DUE correzioni al referto di stamattina, e vanno scritte:**
1. **`PTE` GBPUSD non passa a dato pieno.** Le due celle «che passano» stanno in un CSV `ohlc`.
   A dato pieno il miglior `min(n)` della combinazione è **42**. → 🟠 ferma per campione.
2. **La lista «ferme SOLO per campione» di stamattina conteneva combinazioni GIÀ REFUTATE.**
   Esempio misurato: `SuperWave` NASUSD a **M15** fa `OOS n=256 PF 0,906` — l'OOS è **sopra** il
   pavimento, quindi il merito **non è sospeso, è LETTO, ed è un no**. Stessa cosa per
   `AltaVelocita` **GBPUSD** (**DD OOS 37,47%** su n=256) e `Nasdaq_Live5m` NASUSD (**DD OOS
   33,62%** su n=195), che cadono sul **rischio**, che si legge a qualunque n.
   🔴 **E una trappola che ho evitato per un soffio**: stavo per citare `AltaVelocita` **U30USD**
   con «DD OOS 22,60%». **Quel numero sta in un CSV `ohlc`**: su quel simbolo il motore **non ha
   MAI girato a dato pieno**, quindi il suo verdetto è **`[NON MISURATO]`**, non «bocciato».
   Citarlo sarebbe stata la stessa S7 che contesto al `CostToCost` di stamattina.
   👉 **Il pavimento dei 150 sospende il merito su UNA finestra alla volta, non sulla coppia.**

---

## ③ 🔴 IL CONTRO-ESEMPIO CHE MI ERO IMPEGNATO A COSTRUIRE — **e la mia lista lo passa**

### 3.1 Il PF non ordina niente, e qui c'è la prova dentro UN SOLO CSV
`ABTG_SupertrendReversal` su **225JPY**, round `r5`, scansione di timeframe, stesso file:

| TF | n IS | **PF IS** |
|---|---:|---:|
| **H12** | **7** | **621,4** |
| H8 | 2 | 245,0 |
| H3 | 12 | 3,02 |
| H4 | 30 | 1,36 |
| **H1** | **99** | **1,28** |

> ### 🎯 **Ordinando per PF si sceglie H12 con SETTE operazioni. Ordinando per n si sceglie H1 con NOVANTANOVE. È lo stesso round, lo stesso simbolo, lo stesso giorno.**

Gli altri PF degeneri dell'archivio, col loro `n` accanto — **e si legge il secondo, mai il primo**:
`BreakingBand` NZDJPY **148,7** (n=**6**) · `SupertrendInvert` USDJPY **98,1** (n=**2**) ·
`BreakingBand` AUDUSD **66,7** (n=**11**) · `PTE_Ottimizzato` GBPUSD **37,7** (n=**26**) ·
`PTE` GBPUSD **17,2** (n=**42**).
🟢 **La tabella qui sotto è ordinata per COSTO e per DISTANZA DAI 150. Il PF c'è, ma non decide.**

### 3.2 🔴 E il contro-esempio contro **la mia stessa classifica**: *ordinare per distanza produce CERTIFICATI, non candidati*
Le **sei** combinazioni con totale ≥ 300 — cioè quelle che il taglio IS/OOS può portare sopra il
pavimento **senza un dato nuovo** — hanno tutte il **PF già sotto 1,10 nella finestra che morde**:

| combinazione | n IS | **PF IS** | n OOS | PF OOS | TOT |
|---|---:|---:|---:|---:|---:|
| `IntradayMomentum` NASUSD | 146 | **0,609** | 261 | 1,243 | 407 |
| `ORB_Ottimizzato` NASUSD | 137 | **0,796** | 221 | 1,111 | 358 |
| `ORB_Ottimizzato` U30USD | 134 | **0,912** | 215 | 1,276 | 349 |
| `SupertrendReversal_Multi_Ott` XAUUSD | 137 | **0,984** | 188 | 1,603 | 325 |
| `SupRev_DOW_H1_Ott` U30USD | 136 | **0,781** | 179 | 1,164 | 315 |
| `SupRev_DOW_H4_Ott` U30USD | 132 | **0,741** | 180 | 1,149 | 312 |

> ### 🔴 **Sei su sei. Portarle a 150 non le promuove: le CHIUDE.** E non è sfortuna, è selezione:
> le celle con IS buono **e** campione pieno erano già passate — sono le 4 della classe 🟢.

🟢 **E chiuderle è esattamente ciò che Claudio ha chiesto il 09/09** (*«un morto senza certificato
non è un morto»*): la casella 1 del certificato — **un PF misurato** — si spunta a **~1 minuto per
combinazione**. Ma **va detto prima**, non dopo, altrimenti questa lista sembra una caccia al
tesoro e invece è per metà un lavoro di archivio.

### 3.3 🟢 **Allora la classifica vera è un'ALTRA, e sta nelle celle che il PF ce l'hanno già**
Filtro: `PF ≥ 1,10` **in entrambe** · `DD ≤ 14%` **in entrambe** · `min(n) < 150`, **sulle sole
combinazioni dove NIENTE passa**. Ne restano **603 celle**; queste sono le prime per totale:

| combinazione | round · cella | IS | OOS | TOT | manca a 300 |
|---|---|---|---|---:|---:|
| 🥇 `SuperWave_DOW_H1_Ott` **U30USD** H1 | `r120e11` P0/P1 | n **106** · PF **1,397** · DD 3,48% | n **184** · PF **1,220** · DD 4,21% | **290** | **10** |
| 🥈 `ORB_Ottimizzato` **U30USD** M5 | `r15` P44 | n 102 · PF 1,423 · DD 6,85% | n 172 · PF 1,166 · DD 12,35% | 274 | 26 |
| 🥉 `SuperWave_DOW_H1_Ott` **U30USD** H1 | `r3` P0 | n 91 · PF 1,198 · DD 3,51% | n 165 · PF 1,606 · DD 3,28% | 256 | 44 |
| `SupRev_DOW_H1_Ott` **U30USD** H1 | `R123CATRP` P6 | n **106** · PF **1,177** · DD 4,93% | n **133** · PF **1,359** · DD 2,84% | 239 | 61 |
| `MaxMinNotte` **XAUUSD** M5 | `r17` P1 | n 88 · PF 1,173 · DD 4,31% | n 113 · PF 1,468 · DD 6,95% | 201 | 99 |
| `CrossEma` **XAUUSD** H1 | `r86coro` | n 84 · PF 1,107 · DD 10,92% | n 119 · PF 1,183 · DD 12,30% | 203 | 97 |

> ### 🟢 **`SuperWave_DOW_H1_Ottimizzato` su U30USD è la cella non promossa più bella dell'archivio a dato pieno: PF sopra 1,10 in tutte e due le finestre, DD sotto il 5% in tutte e due, e le mancano DIECI operazioni.**

---

## ④ 🏁 LA CLASSIFICA — **operazioni guadagnate per minuto di macchina**

### 4.1 Il metro del costo, **dichiarato**
Modello affine `T(min) = 0,6 + b × passate`, con `b` **misurato per simbolo** dove esiste:

| base | simbolo · TF · modello | passate | minuti | **b (min/passata)** | tag |
|---|---|---:|---:|---:|---|
| **R88a** | U30USD · M5 · tick | 96 | 8,0 | **0,083** | `[MISURATO]` `REFERTO_R88.txt` |
| **R112** | U30USD · H1 · tick (`EMA200`) | 16 | ~6 | **0,375** | `[MISURATO]` |
| **R87b** | USDCHF · tick | 288 | 14,0 | **0,049** | `[MISURATO]` |
| **R87b** | NZDUSD · tick | 288 | 13,8 | **0,048** | `[MISURATO]` |
| **R87b** | USDCAD · tick | 288 | 25,6 | **0,089** | `[MISURATO]` |
| **R87b** | XAUUSD · tick | 288 | 44,2 | **0,154** | `[MISURATO]` |
| **R104** | D30EUR · M15 · tick (`DAX_Apertura`) | — | — | **0,700** | `[MISURATO]` |
| *riscalata* | NASUSD = U30USD × 166,5/67,6 | — | — | **0,204** | `[DERIVATO]`, classe 192 |
| *riscalata* | D30EUR = U30USD × 35,4/67,6 | — | — | **0,043** | `[DERIVATO]`, classe 192 |

🔴 **CONTRO-ESEMPIO CONTRO IL MIO STESSO MODELLO DI COSTO, e lo dichiaro perché cambia i numeri:**
se il costo dipendesse **solo** dai tick, `D30EUR` (35,4 M) dovrebbe costare **metà** di `U30USD`
(67,6 M). Invece **R104 misura 0,700 min/passata su D30EUR** contro i **0,083 di R88a su
U30USD**: un fattore **8,4 nel verso sbagliato**. La differenza è **l'EA** (quanto lavoro fa per
tick), non il feed.
👉 **La riscalatura sui tick (classe 192) è NECESSARIA ma NON SUFFICIENTE.** Perciò ogni stima
qui sotto è una **BANDA**, e la banda usa come estremo alto la base misurata sullo **stesso EA**
quando esiste. Chi pianifica **usa l'estremo alto**.

### 4.2 La classifica
Δn = operazioni guadagnate **sulla finestra che morde**. Costo = banda, estremo alto per pianificare.

| # | intervento | Δn (finestra che morde) | passate | **minuti** | **Δn / min** | che cosa COMPRA |
|---:|---|---:|---:|---:|---:|---|
| 🥇 **1** | `SuperWave_DOW_H1_Ott` U30USD — **InpTF H1 → M30** | **+61 … +99** (106 → 167-205) | 4 | 0,9 – **2,1** | **29 – 47** | 🟢 **un CANDIDATO**: la cella ha già PF 1,40/1,22 e DD <5% |
| 🥈 **2** | `EMA200` **SHORT** U30USD H1 — **@FRAZIONEIS 0,50** | **+32 … +51** (125 → 157-176) | 4 | 0,9 – **2,1** | **15 – 24** | 🟢 **un CANDIDATO**: PF 1,232/1,891, DD 4,5%/2,7% |
| 🥉 **3** | `SupRev_DOW_H1_Ott` U30USD — **InpTF H1 → M30** | **+61 … +99** (106 → 167-205) | 4 | 0,9 – **2,1** | **29 – 47** | 🟢 **un CANDIDATO** + la **replica** della legge del TF |
| 4 | `IntradayMomentum` NASUSD — **@FRAZIONEIS 0,50** | +37 … +44 (146 → 183-190) | 4 | 1,4 – **2,5** | 15 – 18 | 🔴 **un CERTIFICATO** (PF IS 0,609) |
| 5 | `SupRev_DOW_H4_Ott` U30USD — **@FRAZIONEIS 0,50** | +24 (132 → 156) | 4 | 0,9 – 2,1 | 11 – 26 | 🔴 **un CERTIFICATO** (PF IS 0,741) |
| 6 | `SupertrendReversal_Multi_Ott` XAUUSD — **@FRAZIONEIS 0,50** | +26 (137 → 163) | 4 | 1,2 – **2,5** | 10 – 22 | 🔴 **un CERTIFICATO** (PF IS 0,984) |
| 7 | `ORB_Ottimizzato` U30USD M5 — **@FRAZIONEIS 0,50** | +41 (134 → 175) | 4 | 0,9 – 2,1 | 20 – 44 | 🟠 **INFORMATIVO**: 🔴 **fuori costo** — vedi §4.3 |
| 8 | `ORB_Ottimizzato` NASUSD M5 — **@FRAZIONEIS 0,50** | +42 (137 → 179) | 4 | 1,4 – 2,5 | 17 – 30 | 🟠 **INFORMATIVO**: 🔴 **fuori costo** |

### 4.3 🚦 I CANCELLI DI COSTO, **col numero accanto** — chi esce e perché

| candidato · TF | stop | spread `[MIS]` | `stop/spread` | verdetto |
|---|---:|---:|---:|---|
| `SuperWave_DOW` U30USD **M30** | 2,5 × ATR(M30) = **140 idx** `[DER]` | 2,00 / 3,00 | **70,0× / 46,7×** | 🟢 **PASSA il 40× in tutta la banda oraria** |
| `SupRev_DOW` U30USD **M30** | 3,5 × ATR(M30) = **196 idx** `[DER]` | 2,00 / 3,00 | **98,0× / 65,3×** | 🟢 **PASSA largo** |
| `SuperWave_DOW` U30USD **M15** | 2,5 × 39,6 = **99 idx** `[DER]` | 2,00 / 3,00 | 49,5× / **33,0×** | 🟠 **ESCLUSO PER COSTO all'ora 14** (33,0 < 40) |
| `EMA200` U30USD **H1** | ATR(H1)×1,0 = **78,05-88,25 idx** `[MIS]` | 2,00 | **39,0 – 44,1×** | 🟠 **FRAGILE**, a cavallo del 40× |
| `SupertrendReversal` **225JPY M30** | 3,5 × ATR(M30) = **409 idx** `[INF]` | **35 / 22-23** | **11,7× – 18,6×** | 🔴 **ESCLUSO PER COSTO** (sotto il 40×; all'estremo pessimista **sotto il duro 13,3×**) |
| `ORB_Ottimizzato` U30USD **M5** | `HALFRANGE` = **59,0 idx** `[MIS]` (n=7) | **3,00** (ora 14) | **19,7×** | 🔴 **ESCLUSO PER COSTO** dal pavimento di LAVORO (sopra il duro 13,3×) |
| `AtrExhaustVol` NASUSD M5 · `HVAncora` U30USD M5/M15 · `DaxValueArea` M5/M15/M30 | — | — | 10,9× · 9,3×/12,3× · 5,6-11,3× | 🪦 **già esclusi per costo**, `REGISTRO_TEST.md` |

🔴 **E due caselle `[NON CALCOLABILI]`, che non sono «bocciature»:** su **`F40EUR`, `SPXUSD`,
`E35EUR`, `E50EUR`, `100GBP`, `200AUD` non esiste NESSUNO spread misurato**
(`ANCORA_ADR_FLOTTA_INDICI_2026-09-18.md` §6). Qualunque round su quei simboli produce un numero
**non promuovibile finché lo spread non è misurato**. 👉 Su quei simboli **la via più corta ai 150
non è un round: è una sonda di spread.**

---

## ⑤ 🩺 PERCHÉ LA `n` È BASSA — **le 113 classificate, con la prova**

| causa | combinazioni | che si fa | costo |
|---|---:|---|---|
| **TAGLIO IS/OOS** (totale ≥ 300) | **6** | `@FRAZIONEIS 0.50` — il pavimento cade **senza un dato nuovo** | 4 passate ciascuna |
| **TF ALTO** (H1…D1) | **22** | si scende di un gradino, **se il cancello di costo passa** | 4 passate ciascuna |
| **FINESTRA** (il round parte **dopo** il pavimento tick) | **28** | si riporta `@DAQUANDO` al pavimento — 🔴 **guadagno reale ≤ +13%** sul forex | 4 passate |
| **MOTORE LENTO** (TF già basso, finestra al pavimento) | **8** | 🪦 **non si risolve**: va scritto | 0 |
| **TF `[NON DETERMINATO]`** | **49** | i round `(nolab)` non hanno un file prova e il CSV non porta `InpTF` | — |

🔴 **Le 49 `[NON DETERMINATO]` sono un buco vero e lo dichiaro invece di indovinarlo.** Sono le
corse di validazione originali (etichetta vuota): nessun file prova in `prove/`, nessuna colonna
`InpTF` nei CSV. **Il timeframe di quelle corse si ricostruisce solo dalla catena
`.ini → riga di lancio`, che per quelle non è in repo.** Non lo deduco dal nome del file: sarebbe
la **classe 444**.

### 5.1 🔴 Il caso che spiega meglio di tutti **perché «allunga la finestra» quasi mai funziona**
`MaxMinNotte` **XAUUSD** (`r17`, M5): IS n=103 · OOS n=129 · totale **232**. `@DAQUANDO 2025.03.01`,
cioè **16 mesi** contro i 21 di tutti gli altri. Sembra il candidato perfetto per «allarga e vai».
🔴 **Non lo è, e il motivo è scritto nel file prova stesso** (r.17-19):
> *«ATTENZIONE STORICO: l'M5 dell'oro parte dal 28/02/2025 (misurato nello studio).»*

**Le barre M5 dell'oro prima del 28/02/2025 NON ESISTONO.** La finestra non è una scelta
prudente: **è il muro.** 🟢 E la prova del nove: `R170b` gira lo stesso motore sullo stesso
simbolo con `@DAQUANDO 2020.01.01` — **ma a `@PERIODO H2`**, perché a H2 le barre ci sono.
👉 **Su questo simbolo finestra e timeframe sono la stessa manopola**, e salire di TF per comprare
anni **toglie** operazioni invece di darne.

---

## ⑥ 📐 L'ARITMETICA DEL TAGLIO IS/OOS — **perché 300 è la soglia, e perché sotto è una trappola**

Il driver (`walkforward_generico.ps1` r.921) taglia **per TEMPO**:
`Meta = Inizio + floor(giorni × FrazioneIS)`, con **default di fabbrica `0,40`** (r.179).
Sulla finestra di casa `2024.09.26 → 2026.06.30` = **642 giorni**:

| taglio | IS | OOS |
|---|---|---|
| **0,40** (default) | 2024.09.26 → **2025.06.09** (256 gg) | 2025.06.10 → 2026.06.30 (386 gg) |
| **0,50** (`@FRAZIONEIS`) | 2024.09.26 → **2025.08.13** (321 gg) | 2025.08.14 → 2026.06.30 (321 gg) |

🟢 Le due date **non sono mie**: sono scritte dal driver stesso nel proprio commento (r.605-607).
La direttiva `@FRAZIONEIS` **esiste, è implementata e collaudata dal 12/09** — ed è l'**unico**
canale, perché la corsia ROUND passa sei argomenti e `-FrazioneIS` non è fra quelli.

> ## 🔴 **E LA TRAPPOLA, che è il motivo per cui la soglia è 300 e non 150:**
> il taglio **non crea operazioni, le sposta**. Alzare l'IS **abbassa l'OOS**. Con un totale di
> **282** (`DAX_Live5m_v2` D30EUR) il taglio a 0,50 dà **141 e 141**: si passa da *«una finestra
> sotto»* a **DUE finestre sotto**. 👉 **Il pavimento è sul TOTALE (150+150), non sulla finestra.**
> *(Classe nuova **450**, registrata oggi in `CHECKLIST_RIGA_DI_LANCIO.md`.)*

🔴 **E il taglio NON conserva il PF**: 32-51 operazioni cambiano finestra, e il PF di 150 non è il
PF di 125. 🟢 **Ma il verso dell'errore si può dichiarare**, ed è quello che ho fatto nel file
prova di `EMA200` short: le operazioni che migrano vengono dalla **testa di un blocco che fa PF
1,891**, quindi se portassero con sé quel PF **l'IS salirebbe**. Il rischio vero è sull'**OOS
nuovo**, che per costruzione perde la sua parte migliore — ed è lì che ho messo il falsificatore.

---

## ⑦ 📦 I TRE FILE PROVA, **già passati dal primo strato del cancello**

| file | EA · simbolo · TF | asse unico | celle | passate | costo | cancello |
|---|---|---|---:|---:|---|---|
| **`prove/R190b_tfM30_SUPERWAVEDOW_U30USD.txt`** | `SuperWave_DOW_H1_Ott` · U30USD · H1→**M30** | `InpTF` (ENUM, 2 membri) | 2 | 4 | 0,9–**2,1** min | ✅ `controlla_prova.py` **OK, 0 problemi** |
| **`prove/R190a_taglio050_EMA200SHORT_U30USD.txt`** | `EMA200` short · U30USD · H1 | `InpMagic` (gemello G1) | 2 | 4 | 0,9–**2,1** min | ✅ **OK, 0 problemi** |
| **`prove/R190c_tfM30_SUPREVDOW_U30USD.txt`** | `SupRev_DOW_H1_Ott` · U30USD · H1→**M30** | `InpTF` (ENUM, 2 membri) | 2 | 4 | 0,9–**2,1** min | ✅ **OK, 0 problemi** |

**Totale: 3 round, 12 passate, ~3 – 6,3 minuti di macchina.** Bersaglio dichiarato in ogni file:
🖥️ **banco da backtest `C:\MT5_Backtest`, demo `50504400`** — **NON** il piccolo `50503392`,
**NON** il 100k `50504263`, **NON** il reale `10105439`.

🟢 **Due dettagli di metodo che valgono più del costo:**
1. **`R190b` e `R190c` portano l'ÀNCORA dentro il round.** La cella `H1` **deve** riprodurre
   `r120e11` / `R123c P6` al centesimo. Se non riproduce, **la cella M30 non si legge**: si riapre
   il baco. Non è un twin in più, è **gratis** — è l'altro estremo dell'asse.
2. 🔴 **`InpTF` è un `ENUM_TIMEFRAMES` e il passo viene IGNORATO** (classe 287): fra `30` e `16385`
   i membri sono **esattamente due**. Il cancello lo ha confermato a schermo:
   *«celle = membri fra 30 e 16385 = 2 [il conto aritmetico direbbe 16356: NON guardarlo]»*.
   **Se avessi fatto partire l'asse da `15`** entrerebbero anche **M15 e M20**, e M15 su questo
   motore è **fuori costo a 33,0×**. Lo start è `30` **apposta**.

⏳ **Il secondo strato del cancello — l'agente `controllo-preventivo` — NON l'ho invocato io: lo
lancia il coordinatore.** Finché non torna, **questi file non vanno verso il VPS**. Lo dichiaro e
non lo aggiro (regola del 09/09).

---

## ⑧ 🪦 QUELLO CHE NON SI SALVA, col numero — **perché anche questo è un risultato**

| combinazione | numero che chiude | verdetto |
|---|---|---|
| `WOL` su **tutti e 8** i simboli | PF a dato pieno: GBPUSD **0,021** · SPXUSD **0,000** · NASUSD **0,017** · D30EUR **0,079** | 🪦 **non è campione che manca: è un motore che non funziona.** Nessun minuto di macchina lo merita |
| `SupertrendInvert` su **9 simboli** | `n` massimo di tutto il motore: **2** | 🪦 il PF 98,1 su USDJPY **non è un'informazione** |
| `GapFill` su **9 simboli** | `n` totale 11-35; sonda 17/08: **8-20 trade/anno** → servono **15,8-39,5 anni** | 🪦 **motore lento**, e gli indici hanno 1,8 anni |
| `SupertrendReversal` **225JPY** | M30 = **11,7-18,6×** contro il 40× | 🪦 **escluso per costo**: H1 è già il gradino più basso pagabile |
| `MaxMinNotte` **XAUUSD** M5 | barre M5 dell'oro dal **2025.02.28** `[MIS]` | 🪦 **finestra al muro**, TF già in basso, e salire toglie operazioni |
| `Nasdaq_Live5m` NASUSD | **DD OOS 33,62%** · stop/spread **13,33×** | 🪦 già chiuso in `REGISTRO_TEST.md` L2, confermato qui |

---

## ⑨ 🕳️ I BUCHI, DICHIARATI

1. 🔴 **49 combinazioni su 113 hanno il TF `[NON DETERMINATO]`** — round `(nolab)`, nessun file
   prova, nessuna colonna `InpTF`. Non lo deduco dal nome (classe 444). **Per chiuderle servirebbe
   ritrovare le `.ini` di quelle corse, che in repo non ci sono.**
2. 🔴 **Lo spread di `F40EUR`, `SPXUSD`, `E35EUR`, `E50EUR`, `100GBP`, `200AUD` non è misurato.**
   Il cancello di costo su quei simboli è `[NON CALCOLABILE]`, **non «fallito»**. È la via più
   corta *per una famiglia intera*, e costa una sonda, non un round.
3. 🔴 **L'`ATR` di `NASUSD` e `225JPY` è `[INFERITO]`**, e l'ancora di `225JPY` è `[SOTTILE]`
   (n=9). I loro cancelli di costo reggono **finché l'inferenza non sovrastima**.
4. 🔴 **La profondità a TICK è misurata su TRE simboli soltanto** (`D30EUR`, `U30USD`, `NASUSD`).
   Su `XAUUSD`, `225JPY`, `F40EUR` e su tutto il forex il pavimento **2024.07.05** viene dal
   Diario MT5, non da una sonda di casa.
5. 🔴 **La banda di costo è larga un fattore 8** (0,083 → 0,700 min/passata) e il fattore **non è
   il feed, è l'EA**. La banda si stringe solo misurando: al primo giro di `R190a/b/c` si annota
   il tempo vero e il metro migliora.
6. 🟡 **Tre azioni del referto 17/08 sono ancora aperte** e non so se siano state fatte:
   alzare *«Massimo barre nel grafico»* a `Illimitato` sul banco `C:\MT5_Backtest` (segnalato
   l'08/09, esito non registrato) · scaricare lo storico profondo che il broker **ha già** ·
   l'import Dukascopy per gli indici dal 2012. 👉 **La terza è l'unica cosa al mondo che sposta il
   pavimento 2024.09.26 degli indici**, ed è **una decisione di Claudio**, non un round.

---

## ⑩ 🎯 LA RISPOSTA IN UNA RIGA

> # 🟢 **Tre round, dodici passate, sei minuti: e il primo — `SuperWave_DOW_H1` su M30 — punta alla cella non promossa più bella dell'archivio, a cui mancano DIECI operazioni.**
> 🔴 **E l'altra metà della lista non cerca candidati: chiude certificati. Sei combinazioni con il
> campione a portata hanno già il PF sotto 1,10 nella finestra che morde, sei su sei. Vanno
> girate lo stesso — un morto senza certificato non è un morto — ma va detto prima, non dopo.**

---
*Fonti: 2.389 CSV sotto `backtest_pipeline/risultati_{prove,archivio,ottimizzazione}` letti cella
per cella · `risultati_archivio/misura_tick/REFERTO_MISURA_TICK_{D30EUR,U30USD,NASUSD}.txt` ·
`risultati_archivio/REFERTO_SONDA_STORICO_17-08.md` · `risultati_archivio/R102_REFERTO_BLOCCO1.md` ·
`risultati_archivio/r88_csv/REFERTO_R88.txt` · `risultati_archivio/R112_CORSA_20260826/REFERTO_R112.txt` ·
`report/ANCORA_ADR_FLOTTA_INDICI_2026-09-18.md` · `report/DIAGNOSI_GBPUSD_LENTA_2026-09-02.md` ·
`backtest_pipeline/walkforward_generico.ps1` rr.179, 588-660, 921 · `backtest_pipeline/REGISTRO_TEST.md`.
Tabella integrale: `report/VIA_PIU_CORTA_AI_150_2026-09-19.csv`.*
