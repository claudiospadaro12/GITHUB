# 🌙 RIESAME DEI MORTI — FAMIGLIA NOTTURNI / MEAN-REVERSION

**22/09/2026 · scavo d'archivio in SOLA LETTURA · branch `lavoro`**
🛑 **Zero round lanciati, zero righe consegnate, niente sul VPS, niente sul forward,
nessun preset toccato, nessuna sedia promossa o spenta.** Il conto reale `10105439` non
è stato nominato in nessuna riga di comando.

Richiesta di Claudio (22/09, testuale): _«VOGLIO RIGUARDARE ED RIANALIZZARE CON TUTTI GLI
AGENTI TUTTI GLI EA CHE ABBIAMO CONSIDERATI MORTI. CE NE SONO UNA VALANGA… NIGHTLY…»_
Direttiva aggiunta in corsa: _«INTANTO: DA PROVARE IN + TF MI RACCOMANDO, OGNI STRATEGIA»_.

---

# 0. 🥇 IL VERDETTO IN CINQUE RIGHE

1. 🟢 **IL RITROVAMENTO PIÙ GROSSO — `CostToCost` H4, uscita `InpExitMode = 0`.**
   La cella messa in vivaio è `exit 2` (flip di struttura, PF 1,546, **DD 12,05%**).
   Nello **stesso CSV, già in archivio**, `exit 0` (cost-to-cost puro) fa **PF 1,3427,
   n=194, DD 9,1158%** — **DD −24,3%, operazioni +25%**, e **sotto il muro del 10% a
   rischio 1%**. Abbiamo scelto il **PICCO** invece del **CENTRO**, contro la regola di
   casa, e ci è costato il cancello del rischio. 👉 E non è una cella sola: `exit 0`
   long-only è la migliore anche su **USDCHF** (1,2617 / DD 8,611) e **CHFJPY**
   (1,1474 / DD 7,095). **Tre gemelli, stessa uscita, tutti sotto il muro.**
2. 🔴 **`ABTG_MaxMinNotte` su CAC/Stoxx/FTSE NON HA IL CERTIFICATO COMPLETO**, al
   contrario di quanto scrive oggi `REGISTRO_TEST.md` r.3772 (*«TRE MORTI COL
   CERTIFICATO COMPLETO»*). Manca il **punto 5 (TF)**: `InpMgmtTF` vale **15 in tutte e
   216 le passate** dei tre simboli, e l'unico asse TF mai girato su questo motore (`r17`
   sull'oro) dimostra che **quella manopola morde**. Verdetto corretto:
   **⏸️ NON ANCORA MISURATI**, con priorità BASSA (il §2 spiega perché).
3. 🎯 **LA DOMANDA SPECIALE HA UNA RISPOSTA MISURATA, e non è la direzione.**
   Scomponendo le celle gemelle long/short: il **segnale direzionale** su Stoxx è
   **più grande** che sul DAX (6,73 contro 5,33 EUR/uscita). Quello che uccide i tre
   gemelli è il **DRAG SIMMETRICO** — la parte di perdita che colpisce long e short
   **allo stesso modo**: **−2,08 EUR/uscita sul DAX contro −11,68 (CAC) / −22,39
   (Stoxx) / −24,00 (FTSE)**, cioè **5,6× · 10,8× · 11,6×**. Non è un problema di lato:
   è **costo e/o falsa rottura**. Dettaglio e contro-esempio al §2.
4. 🔴 **`ABTG_Nightly` è il MOTORE PIÙ VELOCE DELLA FLOTTA NOTTURNA e nessuno l'ha
   notato**: 889 posizioni su 4 coppie in 459 giorni feriali = **1,937 op/giorno di
   famiglia**, cioè **quasi il doppio del pavimento 1,00** firmato il 07/09. È l'unico
   candidato del dossier che il pavimento lo **supera**. Muore sul merito e sul rischio,
   non sulla frequenza — e **la sua gestione dell'uscita non è MAI stata messa ad asse**:
   **20 CSV su 20 muovono solo `InpMagic`**.
5. 🪦 **I morti veri col numero brutto restano tre**: `MeanRevert` GBPUSD (12/12 celle in
   perdita, n fino a 1.160), `TurnaroundTuesday` GBPUSD (0/24 OOS su 11.928 trade),
   `CostToCost` sul **lato SHORT** (0/28 coppie positive a H4, PF mediano 0,708).

---

# 1. 📋 LA TABELLA MADRE — il certificato a cinque punti, candidato per candidato

**Legenda dei cinque punti (regola del 09/09):** ①PF misurato · ②n e DD · ③gestione
dell'uscita ad asse · ④simboli gemelli · ⑤**TF cambiato — elencati PER NOME**.
🔴 **Dal 22/09 il punto ⑤ è il più pesante dei cinque** (direttiva di Claudio): se è
vuoto, il verdetto è **NON ANCORA MISURATO** anche con gli altri quattro pieni.

| # | motore · simbolo | TF (grafico) | **modello** | finestra | rischio | PF IS / OOS | n | DD % | ① | ② | ③ | ④ | ⑤ TF provati, per nome | VERDETTO |
|---|---|---|---|---|---|---|---|---|:-:|:-:|:-:|:-:|---|---|
| A1 | **`CostToCost` EURJPY** `exit 0` long | H4 | 🟠 **OHLC** | finestra unica scan | 1,0% | — / — · **1,3427** (unica) | 194 | **9,1158** | ✅ | ✅ | ✅ 3 modi | ✅ 28 simboli | 🟡 **H1 · H4** (mai D1, mai M30/H2) | ⏸️ **RESUSCITABILE #1** |
| A2 | **`CostToCost` EURJPY** `exit 2` long (r127c) | H4 | 🟠 **OHLC** | IS+OOS | 1,0% | 1,17686 / 1,52341 | **153 / 242 = 395** | 10,9946 / 12,2627 | ✅ | ✅ | ✅ | ✅ | 🟡 **H1 · H4** | ❌ **rischio** (ma vedi A1) |
| A3 | **`CostToCost` USDCHF** `exit 0` long | H4 | 🟠 OHLC | unica | 1,0% | — / — · **1,2617** | 186 | **8,611** | ✅ | ✅ | ✅ | ✅ | 🟡 **H1 · H4** | ⏸️ **RESUSCITABILE #2** |
| A4 | **`CostToCost` CHFJPY** `exit 0` long | H4 | 🟠 OHLC | unica | 1,0% | — / — · **1,1474** | 190 | **7,095** | ✅ | ✅ | ✅ | ✅ | 🟡 **H1 · H4** | ⏸️ **RESUSCITABILE #3** |
| A5 | `CostToCost` GBPCAD `exit 1` long | H4 | 🟠 OHLC | unica | 1,0% | — · **1,2745** | 148 | 9,174 | ✅ | ✅ | ✅ | ✅ | 🟡 **H1 · H4** | ⏸️ non misurato (n<150) |
| A6 | `CostToCost` **lato SHORT**, 28 coppie | H4+H1 | 🟠 OHLC | unica | 1,0% | PF **mediano 0,708**, 6 celle >1 su 144 | 134-223 | 19-48 | ✅ | ✅ | ✅ | ✅ | 🟡 H1 · H4 | 🪦 **MORTO VERO** |
| B1 | **`MaxMinNotte` F40EUR** (CAC) | M15 *(dichiarato)* | tick reali | **[NON MISURATA]** | 1,0% | — · **max 0,99852** (0/54) | 97-196 | 10,12-**40,67** | ✅ | ✅ | ✅ `TP2_R`×6 | ✅ | 🔴 **UNO SOLO — `InpMgmtTF`=15 su 72/72** | ⏸️ **NON ANCORA MISURATO** (priorità bassa) |
| B2 | **`MaxMinNotte` E50EUR** (Stoxx) | M15 *(dichiarato)* | tick reali | **[NON MISURATA]** | 1,0% | — · **max 0,83979** (0/54) | 52-160 | 12,80-**35,25** | ✅ | ✅ | ✅ | ✅ | 🔴 **UNO SOLO — `InpMgmtTF`=15 su 72/72** | ⏸️ **NON ANCORA MISURATO** (priorità bassa) |
| B3 | **`MaxMinNotte` 100GBP** (FTSE) | M15 *(dichiarato)* | tick reali | **[NON MISURATA]** | 1,0% | — · **max 0,67170** (0/54) | 71-238 | 16,03-**48,26** | ✅ | ✅ | ✅ | ✅ | 🔴 **UNO SOLO** | 🪦 **MORTO, quasi certificato** (vedi §2c) |
| B4 | `MaxMinNotte` **NASUSD** | — | — | — | — | **nessuna corsa** | — | — | ❌ | ❌ | ❌ | ❌ | 🔴 **NESSUNO** | 🆓 **CASELLA LIBERA — 2 file prova PRONTI e PASS** |
| B5 | `MaxMinNotte` EURUSD | M15 | 🟠 OHLC | FASE 0 | **2,0%** | 0,00 / 0,00 | **1 / 0** | 2,09 / 0,00 | ❌ | ❌ | ❌ | — | 🔴 uno solo | ⚠️ **`Trades≈0` = NON È UNA MISURA** |
| C1 | **`Nightly` EURCHF** | **M5** | ✅ **tick reali (4)** | 2024.09.26→2026.06.30 | 1,0% | 0,89113 / 0,81429 | 63 / 85 | **11,0988 / 15,3861** | ✅ | ✅ | ❌ **mai** | ✅ 4 coppie | 🔴 **M5 soltanto** (e vedi §3b) | ❌ **rischio** + merito concorde |
| C2 | `Nightly` EURUSD | M5 | 🟠 OHLC | idem | 1,0% | 1,04884 / 0,86117 | 106 / 164 | 10,7967 / 15,4930 | ✅ | ✅ | ❌ **mai** | ✅ | 🔴 **M5 soltanto** | ❌ rischio (DD>10 in 2/2) |
| C3 | `Nightly` GBPUSD | M5 | 🟠 OHLC | idem | 1,0% | 0,58619 / **1,04013** | 96 / **163** | **22,6211** / 11,2786 | ✅ | ✅ | ❌ **mai** | ✅ | 🔴 **M5 soltanto** | ❌ rischio |
| C4 | `Nightly` USDCHF | M5 | 🟠 OHLC | idem | 1,0% | 0,86342 / 0,97011 | 81 / 131 | 11,4246 / 14,1590 | ✅ | ✅ | ❌ **mai** | ✅ | 🔴 **M5 soltanto** | ❌ rischio |
| C5 | `Nightly` **AUDUSD · USDJPY · XAUUSD · D30EUR · U30USD** | M5 | 🟠 OHLC | idem | 1,0% | **0,00** | **0 / 0** | 0,00 | ❌ | ❌ | ❌ | — | 🔴 uno solo | ⚠️ **`Trades=0` = NON È UNA MISURA** (causa nota solo a metà) |
| C6 | `Nightly` XAGUSD | M5 | 🟠 OHLC | idem | 1,0% | 0,00 / 1,26185 | **0 / 4** | 0 / 1,66 | ❌ | ❌ | ❌ | — | 🔴 uno solo | ⚠️ **numero senza campione** |
| D1 | `MeanRevert` GBPUSD | H1 | 🟠 OHLC | 2015→2026 (11,5 anni) | 1,0% | max **0,94595** / max **0,98559** | 120-774 / 185-1.160 | 12,9-30,8 / 19,6-37,0 | ✅ | ✅ | 🟡 solo `Lookback` | ❌ **1 simbolo** | 🔴 **H1 soltanto** | 🪦 **MORTO VERO** (12/12 in perdita) |
| D2 | `TurnaroundTuesday` GBPUSD | H1 | 🟠 OHLC | 2010→2026 (16 anni) | 1,0% | max 1,00475 / max **0,91435** | 333 / **497** ×24 celle | 13,4-22,8 / **27,2-56,8** | ✅ | ✅ | ✅ `SL×ATR`, `TP_R`, ora | ❌ **1 simbolo** | 🔴 **H1 soltanto** | 🪦 **MORTO VERO** (0/24 OOS, 11.928 trade) |
| D3 | `CanaleLento` XAUUSD | D1 | 🟠 OHLC | IS/OOS | 1,0% | max 1,1234 (**2/20**) / max **2,01738** (13/20) | 29-112 / 47-164 | 5,5-10,2 / 5,6-15,3 | ✅ | ✅ | ✅ `ExitPeriod`, `ExitMiddle` | ❌ **1 simbolo** | 🔴 **D1 soltanto** | ⏸️ **non scegliibile** (le verdi OOS sono le rosse IS) + **doppione** di Donchian 55/20 |

> 📌 **Perché la colonna MODELLO sta accanto al PF**: separando OHLC da tick, il censimento
> del 09/09 perde 3 dei primi 12 posti. **Nessun numero 🟠 di questa tabella è un verdetto**:
> è screening. L'unico candidato a **tick reali** è `Nightly` EURCHF — e quello è negativo.

## 1b. ⚖️ GLI STESSI DD RILETTI ALLA TAGLIA FTMO (classe 547 — fattore misurato 1,956-1,990)

| cella | DD @ **1,0%** | DD @ **2,00%** (la taglia FTMO) | muro 10% |
|---|---:|---:|---|
| **`CostToCost` EURJPY H4 `exit 0` long** | **9,1158** | 17,83 – 18,14 | 🟢 **PASSA a 1,0%** · 🔴 sfonda a 2,0% |
| `CostToCost` CHFJPY H4 `exit 0` long | **7,0950** | 13,88 – 14,12 | 🟢 **PASSA a 1,0%** · 🔴 sfonda a 2,0% |
| `CostToCost` USDCHF H4 `exit 0` long | **8,6110** | 16,84 – 17,14 | 🟢 **PASSA a 1,0%** · 🔴 sfonda a 2,0% |
| `CostToCost` EURJPY `exit 2` (cella vivaio) | 12,0482 | 23,57 – 23,98 | 🔴 sfonda in tutte e due |
| `CostToCost` EURJPY r127c IS / OOS | 10,9946 / 12,2627 | 21,51 / 24,40 | 🔴 sfonda in tutte e due |
| `Nightly` EURCHF IS / OOS | 11,0988 / 15,3861 | 21,71 / 30,62 | 🔴 sfonda ovunque |
| `MaxMinNotte` F40EUR / E50EUR / 100GBP (migliori) | 10,12 / 13,90 / 16,03 | 19,80 / 27,20 / 31,35 | 🔴 sfonda ovunque |

> 🔵 **E la lente della CLASSE 562, che il brief chiede di applicare prima di uccidere.**
> `Equity DD %` è un **limite SUPERIORE** della perdita statica FTMO. Quindi:
> **sotto la soglia DIMOSTRA la sicurezza; sopra NON conclude niente.**
> 👉 Le tre celle `exit 0`/`exit 1` **a rischio 1,0% sono DIMOSTRATE sicure** sul vincolo
> statico (9,12 · 8,61 · 7,10 < 10,00). Tutte le righe "sfonda" qui sopra sono
> **NON DECISE**, non condannate — ma a 22-31% di limite superiore la distanza dal muro è
> tale che nessuna misura più fine le salverà. 🔴 **Il vincolo giornaliero FTMO (5%) NON è
> misurabile da questa colonna: resta `[NON MISURATO]` per tutte.**

---

# 2. 🎯 LA DOMANDA SPECIALE: perché `MaxMinNotte` vive sul DAX e muore su CAC/Stoxx/FTSE

## 2a. La misura che separa le due spiegazioni — **drag simmetrico contro segnale direzionale**

Le quattro corse del 26/07/26 (`risultati_archivio/MaxMinNotte/*.csv`, 72 passate ciascuna)
contengono, **per ogni coppia (buffer, TP2_R)**, la cella **solo-long** e la cella
**solo-short**. Da lì si separano due grandezze che di solito restano impastate:

```
drag     = ( EP_long + EP_short ) / 2     <- la perdita che colpisce I DUE LATI UGUALI
segnale  = | EP_long - EP_short | / 2     <- la parte che dipende dalla DIREZIONE
```
*(`EP` = `Expected Payoff`, EUR per USCITA, deposito 10.000, rischio 1%, 18 coppie per simbolo)*

| simbolo | **drag medio** | **segnale medio** | segnale / \|drag\| | migliore cella |
|---|---:|---:|---:|---|
| **D30EUR (DAX)** | **−2,08** | **5,33** | **2,56** | PF **1,187** short, n=107, DD 7,29 |
| F40EUR (CAC) | **−11,68** | 4,50 | 0,39 | PF 0,999 long, n=112, DD 10,12 |
| E50EUR (Stoxx) | **−22,39** | **6,73** | 0,30 | PF 0,840 long, n=80, DD 13,90 |
| 100GBP (FTSE) | **−24,00** | 2,19 | **0,09** | PF 0,672 short, n=82, DD 16,03 |

> ## 🔴 **IL SEGNALE DIREZIONALE NON È IL DISCRIMINANTE.**
> Lo **Stoxx ha il segnale più grande dei quattro** (6,73 contro i 5,33 del DAX), e alle
> celle a buffer 500 arriva a **11,3-12,8 EUR/uscita** contro gli **1,5-3,4** del DAX.
> Quello che cambia è il **DRAG**: 5,6× (CAC) · 10,8× (Stoxx) · 11,6× (FTSE) quello del DAX.
> 👉 **Il DAX non vince perché ha più direzione: vince perché paga 11 volte meno pedaggio.**

**Cosa è un drag simmetrico, in pratica.** Una perdita che colpisce long e short allo stesso
modo non può essere "il mercato saliva": è **spread + slippage + falsa rottura**. A rischio
1% su 10.000 l'unità di rischio vale ~100 EUR, quindi **−24 EUR/uscita sul FTSE = ~0,24 R
bruciati a ogni uscita, comunque vada**, contro **~0,02 R sul DAX**.

## 2b. 🔧 E il drag ha un COLPEVOLE CANDIDATO, misurato: il **buffer in PUNTI ASSOLUTI**

`ABTG_MaxMinNotte.mq5` r.140: `InpBufferPoints` è in **punti del simbolo**, non in ATR, non
in percentuale. Lo stop invece **scala** (r.379/387: `sl = entry ± ATR × InpAtrSLmult`).
👉 **La distanza d'ingresso è assoluta, la distanza di stop è relativa: su uno strumento più
"piccolo" del DAX l'ingresso finisce a due o tre volte lo stop oltre il bordo del box.**

E il dato lo conferma, **monotòno sul CAC e sullo Stoxx**:

| buffer | drag CAC | drag Stoxx | drag FTSE | drag DAX |
|---:|---:|---:|---:|---:|
| **500** | **−5,7 … −6,4** | **−18,1 … −20,2** | −22,0 … −26,2 | **−0,1 … −0,8** |
| 1000 | −11,3 … −13,7 | −22,6 … −27,0 | −25,3 … −30,4 | −2,0 … −3,1 |
| 1500 | −13,8 … −17,5 | −20,0 … −23,8 | **−15,3 … −19,7** | −3,4 … −4,9 |

🔴 **E la griglia data ai tre gemelli NON scende mai sotto 500.** La cella migliore di CAC e
di Stoxx sta **esattamente sul bordo dell'asse** (`InpBufferPoints = 500`, il valore più
piccolo provato): è il segnale da manuale che **l'ottimo sta FUORI dalla griglia**.
🟢 E che la griglia larga esista è un fatto: `backtest_pipeline/ini/ABTG_MaxMinNotte.ini`
spazza **`200 → 2000`**, e sull'oro l'ottimo a M5/M15/M30 è risultato **200** — cioè
**2,5 volte sotto il minimo mai provato su CAC, Stoxx e FTSE**.

## 2c. 🪦 Ma il FTSE rompe lo schema, e va detto — è l'unico dei tre con il certificato quasi pieno

Sul **100GBP** il drag **non è monotòno** nel buffer (il migliore è a 1500, non a 500) e il
**segnale direzionale è ~0**: a buffer 1000 e 1500 long e short perdono **la stessa cifra**
(segnale 0,09-0,71 EUR contro un drag di 15-30). 👉 **Perdita simmetrica pura, senza
struttura**: è la firma di uno strumento dove il breakout del box notturno è **solo rumore
più costo**. Aggiungi il **DD fino al 48,26% a rischio 1%** (= 94-96% a taglia FTMO) e
**0,084 op/giorno**, e il FTSE è il candidato meno interessante dell'intero dossier.

## 2d. 🔴 MA IL CONFRONTO, COSÌ COM'È, **NON È UN CONFRONTO** — cinque assi di differenza

Il DAX non ha vinto la stessa gara dei tre gemelli. Ha corso **una gara diversa e più ricca**:

| asse | i tre gemelli (`valid_MaxMin_{F40EUR,E50EUR,100GBP}`) | il DAX (`valid_MaxMin_DAX_short_refine`) | la sedia VIVA `770411` |
|---|---|---|---|
| `InpBufferPoints` | 500 / 1000 / 1500 | 700 / 1000 / 1300 | **1000** |
| `InpAtrSLmult` | 🔴 **FISSO 1,5** | **1,5 / 2,0 / 2,5** | 🔴 **2,5** |
| `InpUseCorrelation` (filtro S&P) | 🔴 **FISSO 0 (spento)** | **0 / 1** | 🔴 **1 (acceso)** |
| `InpMinBoxPts` | fisso 0 | 0 / 1500 | 0 |
| `InpMgmtTF` | 🔴 **FISSO 15** | 🔴 **FISSO 15** | **15** |
| `InpMaxSpread` | 🔴 **0 = guardia SPENTA** | 🔴 **0 = guardia SPENTA** | 0 (spenta) |

> ## 🔴 **I TRE GEMELLI SONO STATI GIUDICATI CON DUE DEI TRE PARAMETRI CHE FANNO VIVERE IL DAX MESSI AL VALORE SBAGLIATO.**
> `InpAtrSLmult` a **1,5** invece che **2,5** e la correlazione S&P **spenta**.
> Nel round del DAX, con corr **spenta** il PF sta a **1,036-1,248**; accendendola sale a
> **1,140-2,246**. 🔴 **Il numero che ha "ucciso" i tre gemelli è stato misurato nella
> configurazione in cui anche il DAX fa 1,0-1,25, non 2,05.**

## 2d-bis. 🔧 DUE MANOPOLE INERTI TROVATE LEGGENDO I CSV — caselle LIBERE, non caselle provate

Il censimento del 09/09 dice che **874 CSV su 1.960 hanno passate con esito IDENTICO**.
Due di quelle stanno in questa famiglia, e vanno dichiarate perché **"l'abbiamo già provato"
qui vuol dire "l'abbiamo girato senza che cambiasse niente"**:

| CSV | manopola | passate | **esiti distinti** | cosa è successo |
|---|---|---:|---:|---|
| `valid_MaxMin_DAX_short_refine.csv` | `InpMinBoxPts` (0 / 1500) | 36 | **18** | 🔴 **ogni cella a 0 è IDENTICA alla stessa cella a 1500**: il filtro di ampiezza del box **non ha mai morso** (le notti del DAX sono sempre più larghe di 15 punti indice). Il registro lo aveva già intuito (*«filtro ampiezza box irrilevante»*): qui è **contato**. 🟢 La soglia che morde davvero è stata trovata dopo, in `r133c` su M5 (asse 0→12.000: `Trades` da 38 a 10). |
| `ABTG_CostToCost_EURJPY_{IS,OOS}_ohlc_r127c.csv` | `InpMaxBarsHold` (25→200) | 8 | **3** | 🔴 **da 75 a 200 le righe sono identiche bit a bit**: il time-stop è **non vincolante** su 6 valori su 8. Il round ha misurato **3 celle**, non 8. |

👉 In tutti e due i casi **non c'è niente da "rifare": c'è da girare la manopola dove morde**
(`InpMinBoxPts` ≥ 3.000 sul DAX; `InpMaxBarsHold` ≤ 50 su EURJPY). E non è allargare una
griglia su un motore morto: è **scoprire che un asse dichiarato non era un asse.**

---

## 2e. 🧪 IL CONTRO-ESEMPIO CHE COSTRUISCO CONTRO ME STESSO (regola del 10/09)

**L'argomento che SALVEREBBE i tre**: «accendi la correlazione e alza l'ATR-SL come sul DAX».
Aritmeticamente il filtro S&P sul DAX moltiplica il PF per ~1,9 (1,187 → 2,246); applicato
al CAC (0,9985) darebbe 1,90.

**🔴 E perché quell'argomento NON REGGE, in tre passi:**
1. **Il filtro taglia gli n a un terzo** (107 → 38-41 sul DAX). Sul CAC si passerebbe da 112
   a **~40 uscite ≈ 27 posizioni**: sotto le 150, **merito SOSPESO per costruzione**. Il
   round non potrebbe promuovere niente, qualunque PF esca.
2. **Il PF non si moltiplica.** Il filtro toglie un SOTTOINSIEME di notti; che sul CAC tolga
   proprio le notti cattive è **un'ipotesi, non un'aritmetica**. Sul DAX il meccanismo ha un
   racconto («il DAX non scende se l'America tira»); sul FTSE e sul CAC quel racconto non è
   né misurato né ovvio.
3. **Il drag resta.** Il filtro S&P non tocca lo spread né la falsa rottura: cambia
   *quando* entri, non *quanto paghi*. Su un drag 10× quello del DAX, dimezzare il numero
   di trade dimezza la perdita, non la inverte.

**E l'argomento che UCCIDEREBBE `CostToCost` `exit 0`** (il mio resuscitabile #1) sta al §4.

---

# 3. 📉 IL TIMEFRAME — la direttiva del 22/09 applicata alla lettera

## 3a. 🔴 SU `MaxMinNotte` "CAMBIARE TF" NON VUOL DIRE CAMBIARE `Period=`. È UN'ALTRA MANOPOLA.

Letto nel sorgente, non supposto:
- `ABTG_MaxMinNotte.mq5` **r.308-318**: il box notturno è letto su **`PERIOD_M1` CABLATO**.
- **r.146 · r.218 · r.219**: ATR ed EMA200 girano su **`InpMgmtTF`, che è un INPUT
  SEPARATO dal grafico**.
- Conseguenza: **il TF del grafico non tocca la geometria della strategia.** Un round che
  muove solo `@PERIODO` misura il passo del tester, **non il motore** — ed è per questo che
  `REGISTRO_TEST.md` r.2787 lo elenca fra le 21 sedie ancorate al calendario dove scendere
  di TF **non compra un'operazione**.
👉 **La manopola TF di questo motore si chiama `InpMgmtTF`.**

### E `InpMgmtTF` MORDE — misurato a TICK REALI, con IS/OOS, una volta sola in tutto il repo

**`risultati_prove/MaxMin_Oro_r17/ABTG_MaxMinNotte_XAUUSD_{IS,OOS}_r17.csv`** — XAUUSD,
tick reali, asse `InpMgmtTF` × `InpBufferPoints`, 20 celle per finestra:

| `InpMgmtTF` | PF OOS @buf 250 | n OOS | DD OOS |
|---|---:|---:|---:|
| M30 | 1,8946 | 99 | 4,095 |
| **H1** | **2,2664** | 89 | **3,308** |
| H4 | 1,9081 | 82 | 5,322 |
| H6 | 1,9885 | 83 | 5,546 |
| H8 | 2,1934 | 83 | 4,899 |

🟢 **20 celle su 20 positive in OOS** (PF 1,455-2,266): è un **ALTOPIANO**, non un picco.
🟡 E **sopra M30 l'asse è PIATTO**: la forbice 1,895-2,266 è dentro il rumore cella-a-cella.

E il pezzo mancante viene dalla seconda corsa, sempre a tick reali
(`risultati_prove/MaxMin_Oro_fase2_vecchioscript/*.csv`), che copre **la parte BASSA** dell'asse:

| buffer | M5 | M15 | M30 | **H1** |
|---:|---|---|---|---|
| 200 | PF 1,2407 · DD 8,56 | 1,2831 · 7,71 | 1,3705 · 7,62 | **1,4821 · 4,02** |
| 800 | 1,0790 · 5,62 | 1,1975 · 5,12 | 1,4555 · 3,98 | **1,5437 · 4,70** |
| 1400 | 0,7074 | 0,6938 | 1,0406 | **1,1847** |
| 2000 | 0,7404 | 0,9585 | 1,1095 | **1,2726** |

> ## 🔴 **MONOTÒNO SU 4 RIGHE SU 4: da M5 a H1 il PF SALE e il DD SCENDE (a buffer 200: DD 8,56% → 4,02%, cioè −53%, con PF +19,5%).**
> Le due corse si incastrano: **l'asse morde da M5 a M30-H1, poi si appiattisce.**

### 🔴 E LE DUE SEDIE VIVE STANNO SU DUE PUNTI DIVERSI DI QUELL'ASSE
- **`770402` ORO** → `InpMgmtTF = 16386 = H4` → **dentro l'altopiano.** 🟢
- **`770411` DAX** → `InpMgmtTF = 15 = M15` → 🔴 **dentro il tratto dove l'asse morde, sul
  lato BASSO.** Sull'oro, passare da M15 a H1 a parità di tutto vale **+15,5% di PF e −47,9%
  di DD**.
🛑 **Non propongo di toccare la sedia viva: propongo di MISURARLA.** La decisione sul
parametro in campo è di Claudio, e il changelog v1.11 dell'EA impone comunque un backtest di
riferimento nuovo prima di sostituire una sedia.

🔴 **E su D30EUR / F40EUR / E50EUR / 100GBP / EURUSD `InpMgmtTF` vale 15 in OGNI CSV
dell'archivio** (verificato su tutti i **43** CSV del repo che hanno quella colonna): **mai
mosso, nemmeno una volta.** È una **casella libera**, non una casella provata.

## 3b. ⚪ SU `ABTG_Nightly` IL PUNTO ⑤ È **STRUTTURALMENTE IMPOSSIBILE**, e la ragione è nel codice

`ABTG_Nightly.mq5`: box su **`PERIOD_M1` cablato** (r.183-193), ATR su **`PERIOD_H1` cablato**
(r.120), TP = frazione del range (r.231/242). **Non esiste alcun input di timeframe.**
👉 **Cambiare il TF del grafico su questo EA non cambia NIENTE** (a tick reali; a OHLC
cambierebbe solo la finezza del modello, cioè peggiorerebbe la misura, non la strategia).

✅ **Quindi per `Nightly` il punto ⑤ si dichiara "NON APPLICABILE — cablato nel codice,
r.120 e r.183-193", e NON si spende tempo macchina su un asse TF.** L'asse vero, e
**totalmente vergine**, è quello del §4.

## 3c. 💰 QUALI TF MANCANO E QUANTO COSTANO

**Base di costo MISURATA**: `0,700 min/passata` su `MaxMinNotte` D30EUR M15 a tick reali
(`R104_REFERTO_DRIVER_20260825_0738.txt` r.15). Il riferimento del 21/09 sul PC di backtest
(indici, modello 4, 8 passate M5: **2 min 41 s – 11 min 57 s**) è coerente e **scende
salendo di TF**.

| candidato | TF/asse che MANCA | passate | **minuti stimati** |
|---|---|---:|---:|
| 🥇 `MaxMinNotte` **D30EUR** (sedia viva) | `InpMgmtTF` = **M15 / M30 / H1 / H4** (vivo al 1° posto, 4 valori) × IS+OOS | **8** | **≈ 5,6 min** |
| 🥈 `MaxMinNotte` **F40EUR · E50EUR · 100GBP** | `InpMgmtTF` = M15/M30/H1/H4, un file prova per simbolo | 8 × 3 = **24** | **≈ 17 min** *(tick di quei 3 simboli `[NON MISURATO]`: se sono ~35 M come D30EUR il fattore è 1,0)* |
| 🥉 `MaxMinNotte` **NASUSD** (`R187a`/`R187b`, **già scritti e PASS**) | M15, box EU e box US | 4 + 4 = **8** | **15-25 min** *(già stimato: ×4,69 per i 166,5 M tick)* |
| `CostToCost` EURJPY/USDCHF/CHFJPY | **`InpTF` = D1** (mai provato; la TESI lo prescriveva: *«H4/D1 da spazzolare»*) + **H2/H3** fra H1 e H4 | 3 simboli × 3 TF × IS/OOS = **18** | **≈ 20-30 min** *(H4/D1 su forex: poche barre, corse rapide)* |
| `Nightly` | **nessuno** — TF cablato nel codice | **0** | **0** |
| `MeanRevert` · `TurnaroundTuesday` | H4/D1 esistono ma **non si spendono** (§5) | — | — |

### 🌙 E LA FRONTIERA DEL COSTO, calcolata e scritta — di notte lo spread è il DOPPIO
Spread misurato di `D30EUR` per ora server (`risultati_archivio/spread_flotta/spread_orario_D30EUR.csv`,
**30,97 M tick**, punti indice):

| ora server | 22 | 23 | 0-6 | **7 (piazzamento)** | **8 (riempimento)** | 9-16 (giorno) |
|---|---:|---:|---:|---:|---:|---:|
| media | **4,09** | 3,48 | 3,51-3,78 | **2,82** | **1,92** | 1,65-1,88 |
| p95 | 5,30 | 4,10 | 4,30 | **4,10** | **2,70** | 1,90-2,90 |

🟢 **Contro-esempio a me stesso, e va a favore di questa famiglia**: lo spread notturno del
DAX è **2,1-2,5× quello diurno**, ma **`MaxMinNotte` NON opera di notte**. Il box si
*misura* alle 23:00-04:59, l'ordine si piazza alle **07:59** e si riempie fra le **08:00 e
le 08:30**, cioè alle due ore in cui lo spread sta a **1,92-2,82 medi**. 👉 **La frontiera
notturna non morde su questo motore.** Chi scrivesse «è un notturno, quindi lo spread lo
uccide» starebbe sbagliando misura.
🔴 **Invece morde su `Nightly`**, che piazza alle **05:00 server** e taglia alle 07:00:
ora 5 = **3,51 medio / 4,30 p95 sul DAX** — e lo spread di **EURCHF, la coppia della corsa
vera, è `[NON MISURATO]`** (dichiarato nel file prova prima della corsa, e resta aperto).
🔴 **E su `CostToCost` EURJPY H4 la frontiera è MISURATA e NON passa il pavimento di
lavoro**: `report/IL_CANCELLO_IN_DUE_UNITA_2026-09-18.md` r.184 → **73,0× / 25,6×** nelle
due unità (stop **29,20 pip [MISURATO] n=3**). Il **13,3× duro passa**, il **40× di lavoro
NO** nell'unità stretta. *(A M30 lo stesso motore fa **3,4×**: sotto il duro → M30 e più
sotto sono **esclusi PER COSTO, col numero**, `REGISTRO_TEST.md` r.2774 e
`report/LA_BANDA_BASSA_2026-09-12.md` r.468.)*

## 3d. 📊 LA FREQUENZA A OGNI TF PROPOSTO (pavimento 1,00 op/giorno **per FAMIGLIA**, firma 07/09)

| famiglia | op/giorno misurate | contro il pavimento |
|---|---:|---|
| **`Nightly`** (EURUSD+GBPUSD+USDCHF+EURCHF, 889 posizioni / 459 gg feriali) | **1,937** | 🟢 **×1,94 SOPRA** — l'unico del dossier |
| `MaxMinNotte` in campo (`770411` 0,078 + `770402` ~0,121) | **~0,199** | 🔴 **5,0× sotto** |
| `MaxMinNotte` + i tre gemelli europei resuscitati (0,115+0,082+0,084) | **~0,480** | 🔴 **2,1× sotto — NON basta comunque** |
| `CostToCost` H4 **EURJPY** (`r127c`: 395 posizioni / 1.695 gg feriali 2020-2026) | **0,233** | 🔴 4,3× sotto — con 4 coppie **~0,9**: servono **~5 simboli** |

- 🔴 **Alzare `InpMgmtTF` su `MaxMinNotte` COSTA FREQUENZA**: sull'oro M15→H1 toglie il
  **14,6%** delle uscite (412 → 352 a buffer 200). Su una famiglia già 5× sotto, è un costo
  che va dichiarato e non nascosto — si compra PF e DD, si paga in operazioni.
- 🟢 **Su `Nightly` il TF non esiste, quindi non c'è niente da pagare** (§3b).
- 🔴 **E il numero che chiude il discorso sui tre gemelli europei**: anche resuscitandoli
  TUTTI E TRE, la famiglia `MaxMinNotte` arriva a **0,48 op/g**, cioè **resta 2,1× sotto**.
  La frequenza, su questo motore, **si compra solo con altri simboli** — ed è esattamente
  quello che `R187` (NASUSD) è pronto a misurare.

---

# 4. 🏆 LA CLASSIFICA DEI RESUSCITABILI — ordinata per vicinanza a una sedia schierabile

## 🥇 #1 — `CostToCost` H4 LONG con `InpExitMode = 0`: **la cella sbagliata è stata promossa**

**Il fatto, dal CSV** (`risultati_prove/ABTG_CostToCost/scan_h4/scan_ABTG_CostToCost_H4_EURJPY.csv`,
9 celle, rischio 1%, OHLC):

| lato | `exit 0` (cost-to-cost puro) | `exit 1` (R-based) | `exit 2` (flip di struttura) |
|---|---|---|---|
| **LONG** | **PF 1,3427 · n 194 · DD 9,12** | PF 1,2379 · n 160 · DD 10,84 | 🔴 PF 1,5459 · n 155 · **DD 12,05** ← *la cella messa in vivaio* |
| SHORT | PF 0,9083 · n 157 · DD 27,67 | PF 0,6438 · n 144 · DD 32,89 | PF 0,6302 · n 153 · DD 44,77 |

> ## 🎯 **TRE MECCANISMI DI USCITA DIVERSI, TUTTI E TRE POSITIVI SUL LATO LONG (1,24 · 1,34 · 1,55). QUESTO È UN ALTOPIANO.**
> E il **centro** dell'altopiano — non il picco — è **`exit 0`**: PF 1,3427, **+25% di
> operazioni** e **−24,3% di drawdown** rispetto alla cella promossa.
> 🔴 **Abbiamo promosso il picco e poi l'abbiamo bocciata per il drawdown del picco.**

**E non è un caso isolato**: filtrando le **432 celle** dello scan H4 con
`PF ≥ 1,10` **e** `n ≥ 100` **e** `DD < 10%`, ne restano **quattro**, e **tre sono `exit 0`
long-only**: EURJPY 1,3427/9,12 · USDCHF 1,2617/8,61 · CHFJPY 1,1474/7,10 (+ GBPCAD `exit 1`
1,2745/9,17). 👉 **Stessa uscita, tre simboli diversi, tutti sotto il muro a rischio 1%.**

**E il lato SHORT è escluso PER MISURA, non per assunzione**: su 28 coppie × 3 uscite, le
celle short con PF > 1 sono **6 su 144** e la **mediana è 0,708** (long: 0,789, 32/144 > 1).

### 🧪 IL CONTRO-ESEMPIO CHE LO UCCIDEREBBE — e lo costruisco io, per intero
1. 🔴 **CONFRONTI MULTIPLI.** Lo scan H4 è **432 celle su 48 simboli**. Le celle con
   `PF > 1,00` sono **45 (10,4%)**, con `PF ≥ 1,10` **26 (6,0%)**. Pescare 4 celle belle da
   432 **è quello che fa anche il rumore**. 🟢 *La difesa*: le 4 non sono sparse a caso —
   sono **lo stesso lato** (long) e **la stessa uscita** (exit 0) su **3 simboli su 4**, e
   il lato short è negativo in modo sistematico. Un pescaggio casuale non si ordina così.
2. 🔴 **FINESTRA UNICA, NIENTE IS/OOS, NIENTE REGIME.** Lo scan è una corsa sola. E le
   coppie vincenti sono **tre cross JPY/CHF in un periodo di yen debole**: «long il cross in
   trend su» potrebbe essere **una scommessa di regime travestita da edge**. 🟢 *La difesa
   parziale*: `r127c` **ha** l'IS/OOS su EURJPY e dà **1,17686 / 1,52341 con n 153 / 242 =
   395** — sopra il pavimento delle 150 **in tutte e due le finestre**, che in questo
   progetto riesce a pochissimi (`REGISTRO_TEST.md`: *«ZERO round su 48 passa tutti e
   quattro i cancelli, e quello che blocca è SEMPRE il CAMPIONE»*). 🔴 *Il buco che resta*:
   `r127c` gira su **`exit 2`**, cioè sulla cella **sbagliata**. **L'IS/OOS di `exit 0` NON
   ESISTE.**
3. 🔴 **TUTTO OHLC.** `r127c` è `_ohlc_`, lo scan pure. **Nessun numero di questo motore è
   un verdetto.** E l'OHLC tende a **sottostimare il DD** (le escursioni intra-barra non si
   vedono): il 9,1158% potrebbe crescere a tick.
4. 🔴 **IL COSTO.** `25,6×` nell'unità stretta contro il pavimento di lavoro `40×`.
   Passa il duro `13,3×`, non passa il lavoro. Va dichiarato prima, non dopo.
5. 🔴 **LA TAGLIA.** A **2,00% FTMO** il DD di `exit 0` diventa **17,8-18,1%**. Sotto il muro
   ci sta **solo a rischio ≈1,0%**, che è una **firma di Claudio**, non una misura mia.
6. 🟡 **Manopola inerte trovata in `r127c`**: `InpMaxBarsHold` ha **8 valori e 3 esiti
   distinti** — da **75 a 200 le righe sono identiche bit a bit** (PF 1,17686, n 153,
   DD 10,9946). Quell'asse **non ha morso**: il round ha misurato **3 celle**, non 8.

### ✅ **LA MISURA CHE LO SBLOCCA — una sola, e dice tutto**
> **`InpExitMode` ad asse (0 / 1 / 2) su EURJPY H4 LONG-only, IS+OOS, a TICK REALI**, stessa
> finestra di `r127c`. **6 passate.** Se `exit 0` tiene il PF sopra 1,10 in **tutte e due** le
> finestre **e** il DD resta sotto il 10% a 1%, **abbiamo una sedia**; se il DD a tick sale
> sopra il 10%, il candidato è chiuso per rischio **con il numero giusto** invece che col
> numero della cella sbagliata.
> 🔴 **Prerequisito misurato**: i tick reali BCM sul forex partono dal **2024.07.05**
> (`NOTA_PAVIMENTO_TICK_FOREX_2026-09-01.md`). La finestra di `r127c` è **2020.01.01 →
> 2026.06.30**: a modello 4, i primi **4,5 anni girerebbero su tick GENERATI dalle barre
> M1**. 👉 **O si dichiara la corsa come "tick veri solo nell'ultimo quarto", o si accorcia
> la finestra al 2024.07.05 — e allora l'n crolla e il merito torna sospeso.** Questa
> tensione va sciolta **prima** di lanciare, non dopo.

## 🥈 #2 — `CostToCost` **USDCHF** e **CHFJPY** H4 `exit 0`: i gemelli con il DD più basso di tutti
`USDCHF` **PF 1,2617 · n 186 · DD 8,611** · `CHFJPY` **PF 1,1474 · n 190 · DD 7,095**.
🟢 **Sono la risposta diretta alla domanda del brief** («i gemelli yen/cross sono stati
provati?»): **sì, 28 coppie a H4 e 40 a H1**, e questi due sono i migliori sul rischio.
🟢 **La strada al pavimento è "più simboli", e le celle ci sono già**: `EURJPY` da sola fa
**0,233 op/g** (`r127c`, 395 posizioni su 1.695 giorni feriali; l'EA **non ha parziale**,
quindi `Trades` = posizioni). Con quattro coppie si arriva **vicino a 1,00**; con cinque si
passa. 🔴 **La finestra dello scan H4 è `[NON MISURATA]`** (n=194 contro i 395 di `r127c`
sullo stesso simbolo: è più corta), quindi il contributo degli altri tre non è calcolabile
oggi — è un conto da rifare sui round IS/OOS, non sullo scan.
**Misura che li sblocca**: stessa corsa del #1, aggiunta come **secondo e terzo file prova**
(un simbolo per file). **+12 passate.**

## 🥉 #3 — `MaxMinNotte` **D30EUR**, asse `InpMgmtTF` — 5,6 minuti, tocca una sedia della challenge
🟢 **L'unico round del dossier che può migliorare una sedia GIÀ IN CAMPO senza cambiarle il
meccanismo.** Asse `InpMgmtTF` = M15 / M30 / H1 / H4, IS+OOS, tick reali, **8 passate**.
**Attesa dichiarata prima**: sulla base dell'oro, PF in salita da M15 verso M30-H1 e DD in
discesa; **n in calo del 10-20%**. 🔴 **Soglia congelata**: si guarda il **centro
dell'altopiano**, e se le quattro celle stanno dentro ±0,10 di PF **la risposta onesta è
"M15 va bene"** — ed è un risultato, non un fallimento.
🛑 **Nessuna proposta di cambiare il preset vivo esce da qui.**

## 4️⃣ #4 — `MaxMinNotte` **NASUSD** (`R187a` / `R187b`): due file prova PRONTI, mai lanciati
✅ **Riverificati oggi**: `controlla_prova.py` → **OK, 0 problemi**, 52 pin, 2 celle ciascuno.
Cancello di costo **52,8× PASS**. Attesa congelata **n = 180 (banda 120-220)**. 15-25 min.
🟢 È **casella LIBERA** (zero CSV, zero `.ini`, zero file prova prima del 19/09), e la
frequenza è l'unica cosa che manca a questa famiglia.
🔴 **Attesa di PF dichiarata: NESSUNA** — la base storica fuori dal DAX è 0/54 tre volte.

## 5️⃣ #5 — `MaxMinNotte` **F40EUR / E50EUR** con gli assi del DAX: **legittimo ma a bassa resa**
Per il certificato sono **NON ANCORA MISURATI** (§2d: `InpAtrSLmult` e la correlazione al
valore sbagliato, `InpMgmtTF` mai mosso, buffer mai sotto 500).
🔴 **Ma lo dico chiaro invece di venderlo bene**: anche riuscendo, il filtro S&P porta l'n a
~40 (merito sospeso), il drag resta 5,6-10,8× quello del DAX, e la famiglia **non arriva
comunque al pavimento** (§3d). 👉 **Dopo il #1, il #2 e il #3.**

## 6️⃣ #6 — `Nightly`: **la gestione dell'uscita è una casella totalmente VERGINE**
🔴 **20 CSV su 20 di questo motore muovono soltanto `InpMagic`.** Non è stata girata **una
sola volta** nessuna di queste: `InpTPfrac` (0,5 = esci a metà range — la manopola che decide
tutto), `InpSLatrMult`, `InpCloseAtCutoff`, `InpEdgeOffsetPips`, `InpMaxNightVolPips`.
👉 Il punto ③ del certificato è **VUOTO**, e questo motore è l'unico della flotta notturna
che **supera il pavimento di frequenza (1,937 op/g)**.
🔴 **MA il limite del 19/08 morde qui più che altrove**: PF **0,814-1,049 su 8 finestre** e
**DD sopra il 10% in 7 casi su 8** non è "una griglia da infittire", è un motore senza edge.
✅ **La forma legittima della domanda**: `InpTPfrac` **non è un parametro d'ingresso, è il
MECCANISMO D'USCITA** (fade a metà range contro fade completo). Un asse a 4 valori
(0,25 / 0,50 / 0,75 / 1,00) su **EURUSD M5 a tick reali**, IS+OOS = **8 passate ≈ 6-10 min**,
è un **meccanismo diverso**, non una griglia più fitta.
🔴 **Soglia congelata PRIMA**: se **nessuna** delle 4 celle porta il DD sotto il 10% in
**tutte e due** le finestre, la famiglia si chiude **definitivamente**, e quel round vale
come **certificato di morte**, non come candidato.
🆓 **E resta in piedi, non toccato da nessun numero qui: il BOX PROIETTATO** (media degli N
box precedenti, ordine piazzato **prima** della notte) — è un **meccanismo diverso**, spec in
`caccia_strategie/ANALISI_LIVE_PAOLO_2026-09-08.md`.

## 7️⃣ #7 — Il backlog `MaxMinNotte` già scritto e mai girato (tutti **PASS**)
| file prova | asse | TF | passate |
|---|---|---|---:|
| `R206a_moltiplicatore_stop_MAXMINDAX_D30EUR.txt` | `InpAtrSLmult` 1,5→4,0 | M15 | 12 |
| `R194a_correlazione_MAXMINDAX_D30EUR.txt` | `InpUseCorrelation` 0/1 | M15 | 4 |
| `R191a_orologio_ordine_MAXMINDAX_D30EUR.txt` | `InpEntryCutoffMin` 10-90 | M15 | 10 |
| `R170c_closeatend_maxminnottedax_D30EUR.txt` | `InpCloseAtEnd` 0/1 | M15 | 4 |
| `R170b_closeatend_maxminnotte_XAUUSD.txt` | `InpCloseAtEnd` 0/1 | **H2** | 4 |
| `R134a_scatolanotte_D30EUR.txt` | `InpBoxEndHour` 3→6 | M15 | 8 |
| `R193b_taglia_MaxMinNotte_XAUUSD.txt` | `InpRiskPercent` 0,5→2,0 | **H2** | 8 |
🔴 **Nessuno dei sette mette `InpMgmtTF` ad asse. Nessuno dei sette tocca F40EUR/E50EUR/100GBP.**

---

# 5. 🪦 I MORTI VERI — col numero brutto scritto

| candidato | il numero che lo uccide | modello | perché è un VERDETTO e non un'ipotesi |
|---|---|---|---|
| **`MeanRevert` GBPUSD H1** | **12 celle su 12 in perdita**, PF migliore **0,98559**, DD fino al **37,0%**, n fino a **1.160** | 🟠 OHLC | 11,5 anni, IS **e** OOS, e l'asse `InpLookback` (6 valori) **morde** (n da 120 a 774): non è un campione sottile, è un motore che perde. ⚠️ *Restano vuoti ④ (1 simbolo) e ⑤ (1 TF): formalmente il certificato NON è pieno. 🛑 **Ma non si spende**: con PF ≤ 0,986 su 1.160 operazioni, cercare il simbolo giusto dopo un rosso è pesca, non misura (criterio congelato PRIMA del round R60).* |
| **`TurnaroundTuesday` GBPUSD H1** | **0 celle positive su 24 OOS**, PF OOS **0,730-0,914**, DD OOS **27-57%**, **497 trade per cella**, **11.928 trade** | 🟠 OHLC | 16 anni, un trade ogni martedì per dieci anni. Famiglia chiusa il 16/08 **col criterio scritto prima**. Stessa nota ④/⑤ del precedente, stessa conclusione. |
| **`CostToCost` lato SHORT** (28 coppie × 3 uscite) | **6 celle > 1,00 su 144**, PF **mediano 0,708**, DD fino a **48,3%** | 🟠 OHLC | Il lato è stato misurato su **28 simboli e 3 meccanismi d'uscita**: è la definizione di "provato". 🟢 E serve: **giustifica `InpAllowShort=false`** nelle celle vive invece di lasciarlo come scelta non spiegata. |
| **`MaxMinNotte` 100GBP (FTSE)** | PF max **0,67170**, **0/54**, DD fino a **48,26%** (= **94-96% a taglia FTMO**), **segnale direzionale ~0** (§2c), **0,084 op/g** | tick reali | 🔴 **Formalmente resta ⏸️ per il punto ⑤**, ma è il candidato meno interessante del dossier: perdita simmetrica pura, senza struttura, con il DD più alto misurato in questa famiglia. |

## 🧪 IL CONTRO-ESEMPIO CONTRO I MIEI STESSI MORTI (regola del 10/09)
- **`MeanRevert`**: *«è un fade simmetrico su UNA coppia e UN TF: su D1, o su un indice, potrebbe
  vivere»*. 🔴 **Non regge come priorità**: il PF **migliore** di 12 celle è **0,986**, cioè
  **sotto 1 anche il migliore**, su 1.160 operazioni. Un motore che su un campione così non
  arriva nemmeno al pareggio non si salva cambiando strumento — e il tempo macchina, a 9
  giorni dalla challenge, rende di più sul #1.
- **`TurnaroundTuesday`**: *«la letteratura sta sull'AZIONARIO, non sul forex»*. 🟢 **Vero, ed è
  agli atti**: il referto R63 lo dice esplicitamente. 🔴 **Ma il vincolo era congelato PRIMA
  del round** («se è rosso la famiglia si chiude») e i criteri si cambiano prima dei numeri,
  non dopo. Resta chiuso.
- **`CostToCost` SHORT**: *«forse serve un filtro di regime»*. 🔴 Un filtro di regime è un
  **motore nuovo**, non un parametro: passa dalla lista dei caduti e dall'imbuto, non da qui.
- **`100GBP`**: *«con `InpAtrSLmult=2,5` e la correlazione accesa, come il DAX»*. 🔴 Il filtro
  S&P su un indice **britannico** chiede *«tira l'America?»* a uno strumento dove il racconto
  non è né misurato né ovvio, e comunque porterebbe l'n a ~30. **Non è una priorità.**

---

# 6. 🔴 NON COPERTO — cosa NON ho potuto verificare, e perché

1. 🔴 **La FINESTRA VERA delle tre corse che hanno ucciso CAC/Stoxx/FTSE è `[NON MISURATA]`.**
   Gli `.ini` in repo dicono `FromDate=2024.01.01`, `Period=M15`, `Model=4`. **Ma quegli
   `.ini` NON POSSONO aver prodotto quei CSV**: danno **12 combinazioni** (3 buffer × 2 × 2)
   e i CSV ne hanno **72**, perché contengono un quinto asse — `InpTP2_R`, 6 valori — che
   **nell'`.ini` non c'è e non c'è mai stato** (unico commit: `a86089c8`, 26/07/2026).
   👉 **L'artefatto che ha girato non è in repo.** Quindi TF, finestra e modello di B1/B2/B3
   restano **dichiarati, non misurati**. *(Il round del DAX, `valid_MaxMin_DAX_short_refine`,
   **torna invece esatto**: 3×3×2×2 = 36 = le 36 passate del CSV. 🔴 **Il round che ha ucciso
   tre simboli è proprio quello che non si riproduce.**)*
2. 🔴 **Lo spread di `F40EUR`, `E50EUR`, `100GBP`, `EURCHF` e `EURJPY` presso BCM non è
   misurato.** Abbiamo `spread_orario` solo per **D30EUR, U30USD, NASUSD**. Senza quello, il
   "drag simmetrico" del §2a **non si può attribuire** fra spread, slippage e falsa rottura.
   🟢 **La via più corta, e non costa un minuto di tester**: `ABTG_SpreadLogger` /
   `ABTG_SpreadOrario` esistono già in `mql5/Scripts/` e `mql5/Experts/`.
3. 🔴 **La profondità TICK di `F40EUR`, `E50EUR`, `100GBP` non è misurata.** Il pavimento
   2024.09.26 è verificato su **D30EUR, U30USD, NASUSD** soltanto
   (`risultati_archivio/misura_tick/`). Non l'ho esteso per assunzione.
4. 🔴 **La CURVA DI EQUITY iniziale di `r127c` non esiste in archivio** — solo gli aggregati.
   Ho potuto ricavare il **DD assoluto** dal `Recovery Factor` (IS: 13.368,74 / 1,17244 =
   **11.402,5 EUR**, su un picco di equity di **~103.700 EUR**; OOS: 71.284,16 / 4,30178 =
   **16.570,2 EUR** su un picco di **~135.100**) — cioè **i drawdown avvengono TARDI, a
   equity già decuplicata**. 🟡 Questo **suggerisce** che il vincolo statico FTMO (misurato
   dal saldo iniziale) non sia in pericolo, ma **NON lo dimostra**: senza la curva iniziale
   non so se l'equity sia mai scesa sotto i 9.000 nei primi mesi. **Resta `[NON MISURATO]`.**
5. 🔴 **Il vincolo GIORNALIERO FTMO (5%) non è misurabile** da nessuna colonna di questi CSV,
   per nessun candidato del dossier.
6. 🔴 **La causa dei `Trades = 0` di `Nightly` su AUDUSD e USDJPY resta ignota.** La rettifica
   del 23/08 (`PipSize() = _Point` sugli indici e sui metalli) spiega D30EUR, U30USD, XAUUSD,
   XAGUSD — **non spiega due coppie forex**. Non ho eseguito niente per chiuderla.
7. 🟡 **Correzione a `REGISTRO_TEST.md` r.459**: la riga dice *«Stoxx50 (E50EUR) max 0.59»*.
   Il massimo vero del CSV è **0,83979**; **0,5897** è il massimo del **solo lato SHORT**.
   *(La r.2527 riporta già il valore giusto: le due righe si contraddicono.)*
8. ⚪ **Non ho scritto file prova nuovi**, per rispettare il perimetro di sola lettura di
   questo incarico. Gli assi proposti al §4 sono descritti al valore e al numero di passate,
   pronti da trascrivere. I sette file già esistenti sono stati **solo verificati** (PASS).
9. ⚪ **Fuori perimetro, non guardati**: aperture DAX/Nasdaq/Marco, Live5m, DAX_M3, ORB_Fibo,
   Londra_ORB, SupRev, Supertrend, FiboH4, LiquiditySweep. E **non ho toccato**
   `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` sulla cella viva `770411`: ne ho **letto** i CSV,
   come da mandato.

---

# 7. 📌 LE DUE RIGHE CHE VORREI CORREGGERE IN `REGISTRO_TEST.md` (proposta, non fatto)

1. **r.3772** — *«TRE MORTI COL CERTIFICATO COMPLETO — `MaxMinNotte` sui gemelli europei»*
   → il certificato **non è completo**: manca il punto ⑤ (`InpMgmtTF` = 15 in 216 passate su
   216) e la finestra/TF del round è `[NON MISURATA]` perché l'artefatto non si riproduce.
   Verdetto corretto: **⏸️ NON ANCORA MISURATI** (F40EUR, E50EUR) e **🪦 morto quasi
   certificato** (100GBP, §2c).
2. **r.459** — *«Stoxx50 max 0.59»* → **0,83979** (0,5897 è il massimo del solo lato short).

---

🏁 **La cosa da ricordare di questa giornata**, se se ne ricorda una sola:
> **Su `CostToCost` avevamo già in casa, nello stesso CSV, la cella che passa il muro del
> drawdown. L'abbiamo scartata perché abbiamo promosso il PICCO invece del CENTRO
> dell'altopiano — e poi abbiamo bocciato il motore per il drawdown del picco.**
> Costo per rimetterlo in gioco: **6 passate.**
