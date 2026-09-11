# R128 -- L'USCITA DELLA SEDIA `ABTG_DAX_Apertura_EU` **RETEST** (magic 770101)

**Criteri congelati PRIMA dei numeri. Scritti l'11/09/2026.**
Sedia: `ABTG_DAX_Apertura_EU` - **D30EUR M5** - magic **770101** - gira sul
piccolo **50503392**, sul 100k **50504263** e sul **conto REALE 10105439**.
Perimetro: **si PREPARA, non si esegue**. Il runner e' in sola lettura.

> ### v2 -- RISCRITTO DOPO LA CORREZIONE DEL COORDINATORE (11/09)
> La prima stesura era tarata sul profilo *"vincita 7 punti / perdita 72 punti,
> rapporto 1:14"*. **Quel profilo non e' della sedia viva.**
> Correzione agli atti: `report/CORREZIONE_TRAILING_770101_2026-09-11.md`.
> **Ho rifatto il conto io, dalla fonte, prima di riscrivere** (par. 0).

---

## 0. IL PROFILO VERO DELLA SEDIA VIVA -- rifatto da me sulla fonte

Fonte: `data/statements/trades_auto.csv` (separatore `;`), filtro `magic=770101`,
**n=35**, spaccato con la colonna `strategy` -- che e' il commento che l'EA scrive
all'ordine e che separa i due rami del codice:
`gTrade.BuyStop(... ABTG_DEF_NAME+" BUY")` (r.1073, ramo **BREAKOUT**) contro
`gTrade.BuyLimit(... ABTG_DEF_NAME+" RETEST BUY")` (r.1504, ramo **RETEST**).

| | n | punti | EUR | vinc. mediana | perd. mediana | rapporto | periodo |
|---|---:|---:|---:|---:|---:|---:|---|
| **ROTTURA** (`BUY`/`SELL`) | **24** | **-482,10** | **-658,82** | +6,90 | -71,90 | **1 : 10,42** | 20/07 -> 14/08 |
| **RETEST** (`RETEST BUY`) | **11** | **+176,30** | **+94,35** | **+14,75** | **-23,40** | **1 : 1,59** | 07/08 -> 08/09 |

**Riprodotto al centesimo dai numeri del coordinatore.** Tutta la perdita sta
nella configurazione **ROTTURA**, che e' **spenta dal 14/08**.
**La sedia viva e' la RETEST, ed e' in attivo.**

### 0.1 E c'e' un dettaglio che il conto per configurazione fa uscire, e cambia il round

Spaccando le 11 operazioni RETEST per **`close_reason`**:

| `close_reason` | n | esito |
|---|---:|---|
| **`sl`** (= il **trailing**: lo stop e' stato spostato in profitto) | **10** | **tutte e dieci in GUADAGNO**: +4,50 +3,00 +17,00 +4,40 +65,00 +36,20 +12,50 +28,10 +5,40 +23,60 |
| **`expert`** (= il **flat di fine sessione**, `InpCloseAtEnd`) | **1** | **-23,40** -- 28/08, aperta **16:56:41** |

> ### Le conseguenze, e sono tre, tutte MISURATE:
> 1. **In 11 operazioni la RETEST non ha MAI preso uno stop pieno.** Le sette
>    gambe finite sullo stop iniziale (52,3 / 59,9 / 71,9 / 71,9 / 75,5 / 114,4 /
>    127,0 punti) sono **TUTTE di ROTTURA**, nessuna di RETEST.
> 2. **L'unica perdita delle 11 e' dell'OROLOGIO, non del trailing.** Il trade
>    del 28/08 e' entrato alle 16:56:41 ed e' stato chiuso dal flat delle 17:30
>    server a -23,40. **Il trailing, su questa configurazione, ha chiuso 10 volte
>    su 10 in profitto.**
> 3. Quindi **la tesi "il trailing butta via i soldi" NON e' dimostrata sulla
>    sedia viva**, e R128 **non parte da quella tesi.**

⚠️ **n=11 non dimostra nemmeno il contrario.** Dieci vincenti su undici in un mese
di DAX che sale e' esattamente il campione che non decide niente. **Ed e' questo
il motivo del round**: la configurazione viva e' `[NON ANCORA MISURATA]` **in
tutte e due le direzioni**, e le manopole d'uscita non sono comunque mai state
messe ad asse su meta' del loro dominio.

### 0.2 UN CONFLITTO CHE NON SO RISOLVERE, e lo lascio aperto
Il preset vivo dichiara `InpTP1_ClosePct=50.0`. Ma la pagella del **03/09**
(`report/DIARIO.md` r.14) misura il parziale **su due conti**: `0,70 -> 0,20+0,50`
(28,6%) e `9,20 -> 3,00+6,20` (32,6%), e lo chiama esplicitamente **"1/3"**.
**Un terzo non e' meta'.** O il parziale in campo non e' quello del preset, o una
delle due letture e' di un'altra cosa. 🔴 **[CONFLITTO APERTO]**: si chiude
**leggendo gli input dell'EA sul terminale** (sola lettura), non deducendolo.
**Conta per R128**: se in campo il parziale e' 1/3, la mia cella di controllo
pinnata a 50 **non e' la cella viva**. Fino a prova contraria uso **50**, che e'
cio' che dicono i due file `.set`, e **lo dichiaro**.

---

## 1. LA CORREZIONE CHE VIENE PRIMA DELLA GRIGLIA -- cosa e' GIA' stato provato

> Il brief diceva: *"le manopole di trailing e stop di questa famiglia non sono
> MAI state messe ad asse"*. **HO PROVATO A ROMPERLO E SI E' ROTTO.**

Scansione dell'11/09 su **tutti e 46 i CSV** del repo con `DAX_Apertura` nel nome
(**1.148 righe** con colonne `Inp*`), contando i valori distinti colonna per colonna:

| manopola d'uscita | valori distinti | dove, quando, con quale modello |
|---|---|---|
| `InpTrailTF` | **5** (M1..M5) | `risultati_prove/ABTG_DAX_Apertura_EU/*_{IS,OOS}.csv` -- **08/08/2026, TICK REALI**, 25 celle x 2 finestre |
| `InpTrailStartR` | **5** (0 / 0,25 / 0,50 / 0,75 / 1,00) | idem, stessa griglia |
| `InpUseTrailing` | **2** (0/1) | `gestione_20260909/` (**R120, 09/09, TICK REALI**) + `aperture_r46/` (14/08) |
| `InpTrailMode` | **3** (ATR/PREVBAR/FIXED) | idem |
| `InpTP1_ClosePct` | **2** (0/50) | idem |
| `InpBreakevenAtTP1` | **2** (0/1) | `gestione_20260909/` |
| `InpBEatR` | **2** (0/1) | `gestione_20260909/` |
| `InpMinStopPts` | **5** (0/2000/4000/6000/8000) | `r118_csv/` (R118) |
| `InpSkipIfTight` | **2** (0/1) | `r118_csv/` |

**Nove manopole d'uscita su questa sedia sono gia' state messe ad asse, e tre di
quelle corse sono a TICK REALI sulla geometria RETEST long-only identica alla
viva** (verificato pin per pin nei CSV: `InpEntryMode=2`, `InpRangeMinutes=35`,
`InpBufferPoints=500`, `InpRetestOffsetPts=200`, `InpAllowLong=1`,
**`InpAllowShort=0`**, `InpRiskPercent=1`).
**R128 non le rifa'.**

### 1.1 Quello che invece NON e' MAI stato mosso -- sulle stesse 1.148 righe

| manopola | valore in archivio | volte diverse |
|---|---|---|
| `InpTP1_R` | **1** in tutte e 1.148 | **ZERO** |
| `InpTrailFixedPts` | **410** in tutte e 1.148 | **ZERO** |
| `InpTrailAtrMult` | **2** in tutte e 1.148 | **ZERO** |
| `InpCloseHour` | **17** in tutte e 1.148 | **ZERO** |
| `InpCloseAtEnd` | **1** in tutte e 1.148 | **ZERO** |
| `InpSLMode` | **0** in tutte e 1.148 | **ZERO** |
| `InpUseRoundLevels` | **0** in tutte e 1.148 | **ZERO** |
| `InpTrailTF` **SOPRA M5** | mai: l'asse dell'08/08 va da **M1 a M5** | **ZERO** |

> **La griglia dell'08/08 si e' fermata ESATTAMENTE sul valore vivo, e la
> superficie si stava ancora muovendo sul bordo.** Profitto OOS a soglia 0:
> `M1 +1139,64 - M2 +1865,70 - M3 +1861,04 - M4 +2155,58 - **M5 +1810,72**`.
> **Meta' manopola provata non e' manopola provata.**

E **`InpCloseHour` non e' mai stato mosso in 1.148 righe** -- mentre in campo
**l'unica perdita della sedia viva e' proprio sua** (par. 0.1).

---

## 2. L'EA: LE MANOPOLE D'USCITA CHE ESISTONO DAVVERO

Lette da `mql5/Experts/ABTG_DAX_Apertura_EU.mq5` (2.367 righe), non a memoria.

| manopola | riga | default | VIVO (preset 770101) | cosa fa |
|---|---:|---|---|---|
| `InpSLMode` | 314 | `ABTG_SL_RANGE` (0) | **0** | stop sul bordo opposto del range di 35' |
| `InpAtrSlMult` | 315 | 1.5 | 1.5 (**ramo morto**) | stop = X x ATR |
| `InpMinStopPts` | 345 | 0 | **0** | pavimento dello stop in punti (0 = spento) |
| `InpSkipIfTight` | 346 | true | **true** | stop sotto il pavimento -> **SALTA** il trade |
| `InpTP1_R` | 317 | 1.0 | **1.0** | livello del parziale **E** (x3) il TP dell'ordine |
| `InpTP1_ClosePct` | 318 | 50 | **50** (⚠️ par. 0.2) | % chiusa al 1o obiettivo |
| `InpBreakevenAtTP1` | 319 | true | **true** | stop a pari dopo la parziale |
| `InpBEatR` | 320 | 0 | **0** | BE indipendente a N R (0 = spento) |
| `InpUseTrailing` | 321 | true | **true** | accende il trailing |
| `InpTrailStartR` | 322 | 0 | **0** | il trailing non arma prima di N R |
| `InpTrailMode` | 323 | 1 = `PREVBAR` | **1** | 0=ATR, 1=base candela prec., 2=punti fissi |
| `InpTrailTF` | 324 | `PERIOD_M5` | **5 (M5)** | (PREVBAR) TF della candela |
| `InpTrailAtrMult` | 325 | 2.0 | 2.0 (**ramo morto**) | (ATR) trailing = X x ATR |
| `InpTrailFixedPts` | 326 | 410 | 410 (**ramo morto**) | (FIXED) trailing in punti MT5 |
| `InpCloseAtEnd` | 256 | true | **true** | flat a fine sessione |
| `InpCloseHour`/`InpCloseMin` | 254/255 | 17 / 30 | **17 / 30** (ora SERVER) | quando scatta il flat |
| `InpUseRoundLevels` | 329 | false | **false** | 1o obiettivo sui numeri tondi |

### 2.1 IL DEBITO DI CODICE -- il TP totale NON e' un input

```
mql5/Experts/ABTG_DAX_Apertura_EU.mq5:1621-1627
double TpTotalR()
  {
   double r = InpTP1_R > 0 ? InpTP1_R*3.0 : 0.0;
   return(r <= 0 ? 3.0 : r);
  }
```

**Il take profit dell'ordine e' CABLATO a `3 x InpTP1_R`.** Quindi:
1. muovere `InpTP1_R` muove **insieme** parziale e TP finale: **una manopola, due
   effetti**, non un asse pulito;
2. si rende pulito spegnendo il parziale: `InpTP1_ClosePct=0` fa saltare tutto il
   blocco (r.1898: `if(!partialDone && InpTP1_ClosePct > 0 && InpTP1_ClosePct < 100)`)
   e con lui **anche `InpBreakevenAtTP1`, che vive dentro quel blocco**.
   **E' esattamente quello che fa R128b.**
3. per misurare parziale e TP **separatamente** servirebbe un input nuovo
   (`InpTpTotaleR`): **non lo scrivo, lo segnalo.** Una modifica all'EA non si fa
   dentro un round di misura.

### 2.2 LE MANOPOLE CHE NON ESISTONO -- servirebbe modificare l'EA

| meccanismo | stato | nota |
|---|---|---|
| **time-stop a durata** (chiudi dopo N ore/barre) | **NON ESISTE** | c'e' solo il flat a **ORA FISSA**. `InpMaxBarsHold`/`InpOreDurata` sono di altri EA |
| **passo (step) del trailing** | **NON ESISTE** | ne' PREVBAR ne' FIXED: lo stop si sposta a ogni tick utile |
| **soglia del trailing in PUNTI** | **NON ESISTE** | esiste solo in R (`InpTrailStartR`) |
| **secondo parziale / TP2** | **NON ESISTE** | un solo parziale |
| **breakeven con offset** (BE + X punti) | **NON ESISTE** | il BE e' esattamente `openP` (r.1936, r.1955) |
| **TP totale indipendente** | **NON ESISTE** | cablato a 3x (par. 2.1) |
| **non entrare dopo l'ora X** | **NON ESISTE** | ⚠️ e' la manopola che avrebbe evitato l'unica perdita in campo (ingresso 16:56 con flat alle 17:30). **Si segnala, non si mette in griglia.** `InpPendingExpiryMin=120` non basta: quel pendente era armato da poco |

**Nessuna di queste entra nella griglia.** Un input che l'EA non ha viene
**ignorato in silenzio** da MT5, e la passata risponde a un'altra domanda:
e' il controllo 1 di `controlla_prova.py`.

---

## 3. LA CELLA DI CONTROLLO -- il preset VIVO, per intero

Fonti primarie:
`mql5/Presets/sedie_piccolo/recupero2/sedia_ABTG_DAX_Apertura_EU_770101.set` (rischio **1,0%**)
`mql5/Presets/conto_reale/ABTG_DAX_Apertura_EU_770101_REALE.set` (rischio **0,65%**, resto IDENTICO)

```
InpSessionHour=8  InpSessionMin=0  InpRangeMinutes=35  InpCloseHour=17  InpCloseMin=30
InpCloseAtEnd=true  InpOneTradePerDay=true  InpMaxPosSimbolo=0
InpEntryMode=2 (RETEST)  InpRangeMode=0  InpBufferPoints=500  InpRetestOffsetPts=200
InpAllowLong=true  InpAllowShort=false        <-- SOLO LONG
InpRiskPercent=1.0  (0.65 sul conto reale)
InpSLMode=0  InpAtrSlMult=1.5  InpAtrPeriodMgmt=14
InpTP1_R=1.0  InpTP1_ClosePct=50.0  InpBreakevenAtTP1=true  InpBEatR=0.0
InpUseTrailing=true  InpTrailStartR=0.0  InpTrailMode=1  InpTrailTF=5
InpTrailAtrMult=2.0  InpTrailFixedPts=410.0
InpMinStopPts=0.0  InpSkipIfTight=true  InpSlippagePts=0.0
tutti i filtri (EMA, Supertrend, correlazione, VWAP, volumi, ATR, news) SPENTI
```

**Questa cella sta dentro la griglia in tutti e cinque i file**, e in tutti e
cinque e' l'**ANCORA** con un numero d'archivio da riprodurre.

---

## 4. LA FINESTRA -- Emendamento A, coi numeri veri

**Pavimento dei tick reali BCM sugli indici: `2024.09.26`** -- misurato, non
assunto (`walkforward_generico.ps1` r.39-40). Sotto quella data **non ci sono
tick**: non esistono finestre piu' lunghe da comprare, e **non si spezza in
tranche cio' che non esiste**. Il tetto delle ~100.000 barre **non e' il vincolo
che morde qui**: il terminale di backtest gira a **`MaxBars=10000000`**, stampato
in `risultati_archivio/ancora_passo7/REFERTO_ANCORA_R119.txt`.

Il driver taglia IS/OOS con `-FrazioneIS` sui giorni di **calendario**:

| `-FrazioneIS` | IS | feriali | OOS | feriali |
|---|---|---:|---|---:|
| **0,40** (default = archivio 08/08) | 2024.09.26 -> **2025.06.09** | 183 | 2025.06.10 -> 2026.06.30 | 276 |
| **0,50** (R128b/c/d/e) | 2024.09.26 -> **2025.08.13** | 230 | 2025.08.14 -> 2026.06.30 | 229 |

### 4.1 QUANTE OPERAZIONI CI SONO DAVVERO -- e qui c'e' una brutta notizia

La frequenza regge: IS 175/183 = **0,956 op/giorno feriale**, OOS 270/276 =
**0,978**. A questo ritmo servono **~155 giorni feriali = ~7,1 mesi di
calendario** per fare 150 operazioni.

> **MA QUEL 175 E QUEL 270 NON SONO INGRESSI.**

`InpTP1_ClosePct=50` chiude meta' posizione al primo obiettivo e **MT5 conta
quella chiusura come una riga in piu' nella colonna `Trades`**. La prova sta
nell'archivio (R120, 09/09, tick reali, finestra piena, stessa geometria RETEST):

| struttura d'uscita | `Trades` |
|---|---:|
| parziale **0** + trailing **OFF** | **325** |
| parziale **0** + trailing **ATR** | **325** |
| parziale **0** + trailing **PREVBAR** | **325** |
| parziale **0** + trailing **FIXED** | **325** |
| parziale 50% + FIXED (quasi nessuno arriva a 1R) | 330 |
| parziale 50% + PREVBAR | 445 |
| parziale 50% + OFF | 476 |
| parziale 50% + ATR | 524 |

**Con il parziale spento il conteggio e' 325 in TUTTE E QUATTRO le strutture:
quello e' il numero di INGRESSI, ed e' invariante per costruzione**
(`InpOneTradePerDay` + `InpCloseAtEnd` fissano gli ingressi; l'uscita non li
tocca). Le righe in piu' sono parziali: 445 - 325 = **120**.

> ### CONSEGUENZA, e va scritta forte:
> **Gli INGRESSI veri sono 325 su tutta la finestra.** Ripartiti sui feriali:
> - a `FrazioneIS 0,40`: **IS ~130** / OOS ~195 -> **l'IS E' SOTTO IL PAVIMENTO
>   DEI 150 DELL'EMENDAMENTO A**;
> - a `FrazioneIS 0,50`: **IS ~163** / OOS ~162 -> **tutte e due sopra**, con
>   margine sottile (+8%).
>
> Cioe': **questa sedia non ha mai avuto 150 operazioni vere in campione**, e i
> referti che citano "n=175" stavano contando anche i parziali. Non e' un errore
> dei referti (la colonna la scrive MT5): e' una cosa che nessuno aveva letto.

**Regola del round, congelata qui:**
- **R128a** gira a **`-FrazioneIS 0.40`**, perche' la sua ancora e' una corsa
  d'archivio fatta a 0,40 e deve tornare **al centesimo**. Li' **il MERITO in IS
  e' SOSPESO** (~130 ingressi): l'IS si legge per il **RISCHIO** (Emendamento B)
  e per il **segno** della correlazione IS->OOS. Il merito lo dice l'OOS (~195).
- **R128b/c/d/e** girano a **`-FrazioneIS 0.50`**: entrambe sopra 150 ingressi.

### 4.2 IL REGIME, dichiarato
- **IS (sia 0,40 sia 0,50)**: contiene la **correzione di febbraio-aprile 2025**
  (minimi di aprile), unico tratto di discesa vera dentro i tick BCM. Fonte gia'
  agli atti per questa identica finestra: `risultati_archivio/R110_CRITERI.md`
  r.263-266 e `R107_CRITERI.md` r.225.
- **OOS (0,40)**: *"quasi tutto salita"* (stessa fonte, r.266).
- **OOS (0,50)**: 2025.08.14 -> 2026.06.30. Range di prezzo del DAX misurato da
  un **feed indipendente** (HistData M1, `report/DAX_13_ANNI_2026-09-10.md`):
  2025 **18.809,68 - 24.773,30**, 2026 **21.859,78 - 25.903,90**.
  **L'ORDINE dei due estremi NON e' misurato da quei dati, e non lo invento.**
- **Emendamento C (prova di regime) NON e' eseguibile**: niente orso 2022,
  niente crollo 2020. **R128 valida la GEOMETRIA DELL'USCITA, mai la robustezza
  di regime.**

---

## 5. LA FRONTIERA DEL COSTO `stop >= 40 x spread` -- rifatta sulla RETEST

Fonte primaria: `backtest_pipeline/risultati_archivio/spread_flotta/spread_orario_D30EUR.csv`,
riga **ora server 8** (l'ora d'ingresso di questa sedia), su **1.847.049 tick**:

```
ora 8:  media 1,9194   MEDIANA 1,7000   P95 2,7000   MAX 12,0000   (punti indice)
```

Unita': D30EUR ha `Digits=2`, `_Point = 0,01` -> **1 punto indice = 100 punti MT5**
(`report/CANCELLO_COSTO_FLOTTA_2026-09-10.md` r.290, verificato contro
`InfoBroker: D30EUR SpreadPt = 280` che cade dentro la distribuzione dell'ora 17).

### 5.1 🔴 CORREZIONE AL CANCELLO DEL COSTO: **i 71,9 idx NON sono della sedia viva**

`CANCELLO_COSTO_FLOTTA_2026-09-10.md` par.5.1 attribuisce a `770101` uno stop
mediano di **71,9 idx (n=7) -> 42,3x -> PASSA**, e un sotto-campione *"della
geometria VIVA"* di **56,1 idx (n=2, gambe del 10/08 e 14/08) -> 33,0x**.

**Ho controllato quelle sette gambe una per una nella colonna `strategy`:**

| data | punti | `strategy` | ramo |
|---|---:|---|---|
| 23/07 | -127,00 | `DAX Apertura EU BUY` | ROTTURA |
| 29/07 | -75,50 | `DAX Apertura EU SELL` | ROTTURA |
| 29/07 | -71,90 | `DAX Apertura EU SELL` | ROTTURA |
| 29/07 | -71,90 | `DAX Apertura EU BUY` | ROTTURA |
| 06/08 | -114,40 | `DAX Apertura EU BUY` | ROTTURA |
| **10/08** | **-59,90** | `DAX Apertura EU **SELL**` | **ROTTURA** |
| **14/08** | **-52,30** | `DAX Apertura EU **BUY**` | **ROTTURA** |

> **Sette su sette sono ROTTURA. Zero sono RETEST.**
> Il sotto-campione chiamato *"geometria VIVA"* era selezionato **per DATA**
> (dopo il cambio range 15->35 / buffer 200->500) e **non per la colonna
> `strategy`**: contiene il range nuovo ma **il ramo d'ingresso sbagliato**.
> 🔴 **Lo stop realizzato della sedia VIVA e' `[NON MISURATO IN CAMPO]`, n=0.**

### 5.2 Allora lo si DERIVA dal codice, e si dichiara che e' derivato

```
BREAKOUT (r.1045-1046, 1059-1060):  entry = rangeHigh + buffer ; SL = rangeLow - buffer
                                    -> stop = range + 2 x buffer = range + 10 idx
RETEST   (r.1471-1474, 1488-1489):  entry = rangeHigh - offset ; SL = rangeLow - buffer
                                    -> stop = range + buffer - offset = range + 3 idx
```
(buffer `InpBufferPoints=500` = 5 idx, offset `InpRetestOffsetPts=200` = 2 idx)

> **Lo stop della RETEST e' PIU' STRETTO di quello della ROTTURA di ESATTAMENTE
> 7 punti indice, sullo stesso range.** Non e' una stima: e' sottrazione fra due
> righe di codice.

Applicato alle **sole due gambe con la geometria di range giusta** (10/08 e
14/08, range 35' + buffer 500):

| gamba | stop ROTTURA misurato | range implicito | **stop RETEST derivato** |
|---|---:|---:|---:|
| 10/08 | 59,90 | 49,90 | **52,90** |
| 14/08 | 52,30 | 42,30 | **45,30** |
| | | **mediana** | **49,10 idx** `[DERIVATO, n=2]` |

| stop | / 1,70 (mediana h8) | 40x? | / 2,70 (P95) | 40x? |
|---:|---:|:---:|---:|:---:|
| **49,10 idx** (RETEST, derivato) | **28,9x** | 🔴 **NO -- 72% del pavimento** | 18,2x | 🔴 **NO** |
| 56,10 idx (il numero del cancello, ramo ROTTURA) | 33,0x | 🔴 NO | 20,8x | 🔴 NO |
| 71,90 idx (mediana ROTTURA, geometrie miste) | 42,3x | 🟢 SI (+6%) | 26,6x | 🔴 NO |

> ### 🔴 IL VERDETTO DI COSTO, e va detto anche se non fa piacere:
> **La sedia VIVA sta al 72% del pavimento `40 x spread`, non al 106%.**
> L'unico numero che passava il cancello (42,3x) e' la mediana di un campione
> **misto di geometrie** e **interamente di un ramo spento**.
>
> ⚠️ **Discrepanza dichiarata**: l'altro agente riporta uno stop RETEST di
> **54,90**. `59,90 - 5 = 54,90` e' quello che esce se si toglie **solo** il
> buffer e **si dimentica l'offset del retest** (altri 2 idx). Il mio numero e'
> **52,90** su quella gamba. **Non so quale delle due sia stata calcolata
> pensando a cosa: va riconciliato leggendo il codice insieme.** Nessuno dei due
> cambia il verdetto (54,90 -> 32,3x, sempre sotto 40x).
>
> 🔧 **E la manopola che lo aggiusterebbe esiste ed e' gia' stata misurata**:
> `InpMinStopPts` (pavimento dello stop) + `InpSkipIfTight`. In **R118c** (tick,
> stessa finestra, RETEST **ma con lo short ACCESO**, quindi *non* la geometria
> viva) il floor a **6000 pt = 60 idx = 35,3x** con `SkipIfTight=1` da'
> **OOS PF 1,4382 - DD 6,64% - n 226** contro **1,1878 - 10,60% - n 311** a floor
> 0: **PF migliore, DD migliore, e 85 operazioni in meno.** 🔴 **Non e' una
> promozione e non entra in R128**: e' un'altra domanda (lo STOP, non l'USCITA),
> e va rifatta **long-only** prima di significare qualcosa. **Ma e' la cosa piu'
> promettente che questo scavo ha trovato, e va segnalata a Claudio.**

### 5.3 La DISTANZA DEL TRAILING -- qui la frontiera morde davvero

Pavimento in valore assoluto: **40 x 1,70 = 68,0 idx = 6.800 punti MT5**
(mediana) e **40 x 2,70 = 108,0 idx = 10.800 punti MT5** (P95).

| cella `InpTrailFixedPts` | punti indice | /1,70 | /2,70 | schierabile? |
|---:|---:|---:|---:|---|
| **410 (IL VALORE VIVO)** | **4,10** | **2,4x** | **1,5x** | 🔴 **NO -- 17 volte sotto il pavimento** |
| 2210 | 22,10 | 13,0x | 8,2x | 🔴 NO |
| 4010 | 40,10 | 23,6x | 14,9x | 🔴 NO |
| 5810 | 58,10 | 34,2x | 21,5x | 🔴 NO (85%) |
| **7610** | 76,10 | **44,8x** | 28,2x | 🟢 SI alla mediana, 🔴 no al P95 |
| 9410 | 94,10 | 55,4x | 34,9x | 🟢 SI alla mediana |
| **11210** | 112,10 | 65,9x | **41,5x** | 🟢 **SI anche al P95** |
| 13010 | 130,10 | 76,5x | 48,2x | 🟢 SI anche al P95 |

> **`InpTrailFixedPts = 410` -- default compilato, valore del preset vivo, valore
> scritto nel piano DAX -- vale 4,10 punti indice: 2,4 volte lo spread mediano
> dell'ora in cui questa sedia opera.** Il ramo e' morto nel preset
> (`InpTrailMode=1`), quindi **non ha mai fatto danni in campo** -- ma il 03/08
> quel numero e' gia' costato tre EA del DAX chiusi in **39 secondi** con +12
> punti su un movimento da +83 (`scan_gestione.ps1` r.68-74).

**Le celle sotto 6.800 restano in griglia per leggere la FORMA della curva, ma
sono DICHIARATE NON SCHIERABILI PER COSTO, col numero accanto, prima di vedere i
risultati.** Nessuna di loro puo' essere proposta, nemmeno se e' la piu' verde.

### 5.4 E il TF del trailing PREVBAR? -- non si converte, e si dice perche'
`ABTG_TRAIL_PREVBAR` mette lo stop sul **minimo della candela precedente**
(r.2001-2005): la distanza **non e' un parametro**, e' l'ampiezza di una candela,
che cambia ora per ora. **L'ampiezza mediana della candela M5/M30 del DAX
all'ora 8 e' `[NON MISURATO]` in questo repo.** Quindi la frontiera del costo su
R128a **non si puo' calcolare prima della corsa**: si calcola **dopo**, e solo se
una cella viene proposta. **Non invento una conversione.**

---

## 6. LA GRIGLIA -- 5 file, 30 celle, 60 passate

**Una variabile per file** (`controlla_prova.py` lo impone). Tutto il resto
pinnato **per nome** sulla cella viva RETEST long-only.

| file | asse | celle | ancora | `-FrazioneIS` |
|---|---|---:|---|---:|
| **R128a** | `InpTrailTF` **M5 -> M30** (sopra il valore vivo) | **7** | M5 = corsa 08/08, **al centesimo** | 0.40 |
| **R128b** | `InpTP1_R` 0 -> 3,0 (TP da "nessuno" a 9R), parziale SPENTO | **7** | TP1_R 1,0 = R120, sul **totale** | 0.50 |
| **R128c** | `InpTrailFixedPts` 410 -> 13010 (`TrailMode=2`) | **8** | 410 = R120, sul **totale** | 0.50 |
| **R128d** | `InpUseTrailing` 0/1 -- **IL CONTROLLO** | **2** | tutte e due = R120, sul **totale** | 0.50 |
| **R128e** | `InpCloseHour` 11 -> 21 -- **l'orologio, mai mosso** | **6** | 17 = cella `TP1_R=1,0` di R128b, **al centesimo** | 0.50 |

### 6.1 Perche' proprio questi assi
- **`InpTrailTF` sopra M5**: la distanza del trailing **nella modalita' che gira
  davvero**. Meta' asse mai percorsa, e la superficie si muoveva sul bordo.
- **`InpTP1_R` col parziale spento**: l'asse che **lascia crescere il vincitore**
  (TP da 1,5R a 9R, piu' la cella "nessun TP"). **Mai mosso in 1.148 righe.**
- **`InpTrailFixedPts`**: la distanza del trailing in **punti assoluti** -- l'unica
  forma su cui la frontiera del costo si calcola **prima**. **Mai mosso.**
- **`InpUseTrailing`**: il controllo richiesto. R120 l'ha misurato su **una**
  finestra; qui su **due**.
- **`InpCloseHour`**: **la manopola che in campo ha prodotto l'unica perdita
  delle 11 operazioni vive**, e che non e' mai stata mossa. 12 passate.

### 6.2 Cosa NON e' in griglia, e quante passate risparmia
- `InpTrailStartR`: misurato 08/08 (tick, 25 celle, IS+OOS). Soglia 0 vince in
  **tutte e cinque** le righe TF fuori campione, decrescita monotona.
  **Non si ricompra.** *(-50 passate)*
- `InpTrailMode=0 (ATR)` e `InpTrailAtrMult`: il ramo ATR e' misurato (R120:
  PF 1,0961 contro 1,3789 del PREVBAR). Tararlo vuol dire partire **0,28 di PF
  sotto**. **Rimandato, e la ragione e' scritta.**
- `InpBEatR`, `InpBreakevenAtTP1`: misurate 09/09 (R120). E col parziale spento
  `InpBreakevenAtTP1` e' **inerte per costruzione** (vive dentro il blocco del
  parziale, r.1898): **girarlo costerebbe passate e non misurerebbe niente**.
- `InpMinStopPts`/`InpSkipIfTight`: misurate in R118 -- **e vanno rifatte
  long-only** (par. 5.2), ma sono un round diverso: toccano lo STOP, non l'uscita.
- `InpSLMode`/`InpBufferPoints`: **non si toccano**, altrimenti cambia lo stop
  iniziale e il round smette di misurare l'USCITA.

---

## 7. LE ATTESE, SCRITTE PRIMA DEI NUMERI

> ### 🔴 L'ATTESA GENERALE, e va letta per prima:
> **NON mi aspetto necessariamente un miglioramento.**
> La configurazione viva a tick reali su 21 mesi fa **PF OOS 1,4152** (08/08,
> M5/soglia 0) e **PF 1,3789 - DD 6,03%** senza parziale sulla finestra piena
> (R120). **Non e' una sedia rotta: e' una sedia senza `n`.**
> **Il risultato che mi aspetto di piu' e' un ALTOPIANO PIATTO centrato sul
> default, cioe' "il default va bene".** E' un risultato, non un fallimento --
> ed e' quello che questo round va a comprare: **un `n` e un altopiano per una
> configurazione che oggi ha 11 operazioni in campo.**

| file | attesa | cosa la FALSIFICA |
|---|---|---|
| **R128a** | l'altopiano resta su M2-M5; M10-M30 peggiorano PF e alzano il DD (trailing piu' largo = restituisce di piu') | **una cella fra M6 e M30 con profitto OOS >= +1.991,79 (+10% su M5) e DD OOS <= 6,711%** -> il trailing **era** troppo stretto e il 08/08 si era fermato troppo presto |
| **R128b** | asse **quasi inerte** da TP1_R 1,0 in su: il TP a 3R su uno stop di ~49 idx sta a ~147 idx, e il DAX intraday quasi mai ci arriva | celle 1,5 / 2,0 / 2,5 / 3,0 **diverse fra loro oltre l'1%** -> il TP morde e va tarato. Oppure: la cella **0 (nessun TP)** batte 1,0 su profitto **e** DD |
| **R128c** | profitto in salita con la distanza, DD in salita, e convergenza verso la cella "trailing spento" di R128d | **il massimo del profitto OOS cade SOTTO 6.800 punti** -> la cella migliore e' **fuori dalla frontiera del costo** e il verdetto e' "non schierabile", NON "abbiamo trovato 4.010" |
| **R128d** | il trailing ACCESO vince sul DD in tutte e due le finestre, di molto (R120 sulla finestra piena: **6,03% contro 22,21%**) | la cella **SPENTA** vince su profitto **E** PF in OOS -> la tesi "il trailing taglia i vincitori" torna in gioco |
| **R128e** | 15/17/19/21 **identici al centesimo** (la sessione cash finisce alle 16:30 server: dopo non c'e' quasi mai una posizione viva), 11/13 tagliano vincitori | 19 e 21 **diversi** da 17 -> esistono posizioni vive nel dopo-borsa, l'orologio e' una manopola viva, **e l'unica perdita in campo smette di essere un aneddoto** |

---

## 8. LE SOGLIE, CONGELATE ORA

- **G0 -- ANCORA (fatale, per file).** Tolleranze **diverse e dichiarate**:
  - **R128a**: stesso driver, finestra, modello e deposito dell'08/08 ->
    **n IDENTICO** (IS 175 / OOS 270) e **PF entro +/- 0,5%**. Fuori: STOP.
  - **R128b/c/d**: l'ancora e' una corsa a **finestra piena senza split**, quindi
    il confronto e' sul **TOTALE**: `n(IS)+n(OOS)` fra **320 e 330** e somma dei
    profitti entro **+/- 5%** del numero R120. Fuori: STOP.
  - **R128e**: la cella `InpCloseHour=17` deve riprodurre **al centesimo** la
    cella `InpTP1_R=1,0` di R128b (stessi pin, stessa finestra). Fuori: STOP.
- **G1 -- INGRESSI INVARIANTI (fatale).** In R128b/c/d il parziale e' spento:
  la colonna `Trades` deve essere **IDENTICA in tutte le celle della stessa
  finestra**. Se si muove, l'uscita sta cambiando gli INGRESSI e il round si
  ferma **prima** di leggere altro. *(Eccezione dichiarata: in R128e puo'
  muoversi, ed e' proprio la cosa da guardare.)*
- **G2 -- CAMPIONE.** Il merito si legge solo sopra **150 INGRESSI** (non 150
  righe `Trades`). R128a: **IS sospeso per merito**. R128b/c/d/e: entrambe.
- **G3 -- RISCHIO (a qualunque n, Emendamento B).** DD OOS **> 10,00%** al
  rischio 1% -> cella **scartata secca**. *(In campo il rischio e' 0,65%, ma il
  confronto fra celle si fa a rischio uguale e la soglia resta questa.)*
- **G4 -- MERITO.** PF OOS **>= 1,10**.
- **G5 -- ALTOPIANO, MAI IL PICCO.** Si propone una cella **solo** se i suoi
  **due vicini sull'asse** passano anch'essi G3 e G4. Sui bordi basta il vicino
  che c'e', **e va scritto che e' un bordo**.
- **G6 -- PER SPOSTARE LA CELLA VIVA servono tutte e tre** (regola dell'08/08,
  quella che boccio' M4, e non si riscrive oggi):
  **(a)** profitto OOS **>= +10%**; **(b)** DD OOS **non peggiore**;
  **(c)** vicini sull'asse anch'essi migliori della cella viva.
- **G7 -- SEGNO DELLA CORRELAZIONE.** Spearman IS->OOS sul profitto **negativo**
  -> **non si sceglie niente sull'IS**. Su questa identica sedia e' gia' successo:
  08/08, Spearman globale **-0,44**, negativo in tutte e cinque le righe TF.
  **E' il caso base, non l'eccezione.**
- **G8 -- COSTO.** Nessuna cella di R128c sotto **6.800 punti MT5** e' proponibile
  per lo schieramento, qualunque numero faccia. E **ogni** cella proposta porta
  accanto il suo rapporto stop/spread, che oggi vale **28,9x = 72% del
  pavimento** (par. 5.2).
- **G9 -- UN NUMERO OHLC NON E' UN VERDETTO.** Tutto il round e' `-Modello 4`
  (tick reali). Se una corsa girasse a Modello 1, quei numeri sono **screening**.

---

## 9. IL COSTO IN TEMPO MACCHINA

Calibrazione **misurata**: R88a = 48 celle x 2 finestre = **96 passate in 8,0
minuti** a **tick reali, M5, 21 mesi** (`risultati_archivio/r88_csv/REFERTO_R88.txt`)
-> **5,0 s a passata**. Sovraccarico per corsa (compilazione + avvio + due `.ini`):
**~0,4 min**, misurato sulle righe `R86*_D30EUR` dello stesso referto (4 passate
in 0,5 min).

| file | celle | passate | passate x 5,0 s | + avvio |
|---|---:|---:|---:|---:|
| R128a | 7 | 14 | 1,2 min | 1,6 min |
| R128b | 7 | 14 | 1,2 min | 1,6 min |
| R128c | 8 | 16 | 1,3 min | 1,7 min |
| R128d | 2 | 4 | 0,3 min | 0,7 min |
| R128e | 6 | 12 | 1,0 min | 1,4 min |
| **TOTALE** | **30** | **60** | **5,0 min** | **~7,0 min** |

**Banda dichiarata: 6-12 minuti** sul terminale di backtest (`C:\MT5_Backtest`,
demo **50504400**, zero EA attaccati). La calibrazione viene da **U30USD**, non da
D30EUR: **il numero vero si misura col primo giro.**

---

## 10. IL CONTRO-ESEMPIO, costruito PRIMA della consegna

> **"Se il trailing non fosse il problema, quale risultato vedrei?"**
> *(e, dopo la correzione del par. 0: la domanda giusta e' diventata "il trailing
> e' un problema, un beneficio, o e' indifferente?")*

| | **il trailing TAGLIA i vincitori** | **il trailing PROTEGGE** | **il trailing e' INDIFFERENTE** |
|---|---|---|---|
| **R128a** | una cella M6-M30 fa **>= +10%** di profitto OOS a DD non peggiore | le celle M10-M30 peggiorano | tutte le celle entro +/- 5% fra loro |
| **R128c** | il massimo del profitto sta a distanza **>= 5.810 punti** | il profitto sale poco e si appiattisce presto | curva piatta oltre le prime celle |
| **R128d** | la cella **SPENTA** batte quella accesa sul **profitto OOS** | la spenta perde su PF **e** sfonda il DD | profitto simile, DD comunque peggiore da spenta |
| **R128b** | TP 1,5R perde nettamente contro 3R e oltre | il TP non c'entra | asse piatto da 1,0 in su |

**I tre scenari danno segni diversi su R128a, R128c e R128d insieme, e non esiste
combinazione di parametri che li faccia coincidere**, perche':
- R128a e R128c allargano la distanza del trailing **per due strade
  indipendenti** (candela di TF piu' lungo / punti assoluti). Se la diagnosi
  "taglia troppo presto" fosse giusta, **devono salire tutte e due**. Se ne sale
  una sola, non e' la distanza: e' quel meccanismo.
- R128d porta la distanza **a infinito**. E' il **limite** dei due assi: se
  R128a/c salgono e R128d e' il massimo, la relazione e' monotona; se R128a/c
  salgono e poi R128d ricade, **esiste un ottimo interno** ed e' quello che si
  cerca.
- E la cella `InpTrailFixedPts=13010` (130,1 idx, **piu' larga dello stop
  iniziale stesso**) **deve convergere** verso la cella "trailing spento" di
  R128d: se le due non si avvicinano, il banco e' sporco. **E' un cancello
  incrociato che non costa nemmeno una passata in piu'.**

### 10.1 Le quattro cose che ho provato a rompere -- **TRE si sono rotte**

1. **"Le manopole del trailing non sono mai state messe ad asse"** -> 🔴 **FALSO.**
   Nove manopole d'uscita sono gia' state mosse, tre volte a tick reali sulla
   geometria viva. Il round e' stato riscritto: misura **solo cio' che resta**.
2. **"n = 175 in campione, quindi il campione c'e'"** -> 🔴 **FALSO.** 175 sono
   righe `Trades`, non ingressi. Gli ingressi veri sono ~130.
   **L'IS di questa sedia non ha mai raggiunto i 150.**
3. **"Lo stop di questa sedia e' 71,9 idx e passa il 40x"** -> 🔴 **FALSO.**
   Tutte e sette le gambe di stop sono del ramo **ROTTURA**, spento dal 14/08.
   Lo stop della RETEST, **derivato dal codice**, e' ~**49,1 idx = 28,9x = 72%
   del pavimento**.
4. **"MT5 sugli enum ignora lo step e spazzola i membri"** -> 🟢 **VERO, ma la
   prova che avevamo NON provava niente.** La nota dell'08/08 dice *"misurato il
   07/08"* su `InpTrailTF=5||1||1||5||Y`: da M1 a M5 con passo 1 **l'aritmetica
   e l'enumerazione danno la STESSA risposta** (`1,2,3,4,5`). **Quel test non
   distingue.** La prova che distingue sta nell'archivio:
   `InpTF=16385||15||1||16408||Y` ha prodotto **11 righe** con i valori
   `15, 20, 30, 16385, 16386, 16387, 16388, 16390, 16392, 16396, 16408`
   (oltre 40 CSV in `risultati_prove/`) -- l'aritmetica ne avrebbe fatte
   **16.394**. E il driver lo implementa cosi' apposta
   (`walkforward_generico.ps1` r.348-349 e r.526-530, tabella con `PERIOD_M20=20`).
   **Quindi `InpTrailTF=5||5||1||30||Y` = 7 celle: M5 M6 M10 M12 M15 M20 M30.**
   📌 **Classe nuova per `CHECKLIST_RIGA_DI_LANCIO.md`: "VERIFICA CHE NON
   DISCRIMINA" -- un test in cui l'ipotesi alternativa produce lo STESSO
   risultato non e' una verifica, e' una coincidenza. Nato qui, 11/09/2026.**

### 10.2 Avvertenza sul conteggio delle celle
`controlla_prova.py` non sa che `InpTrailTF` e' un enum e stampera' **26 celle**
per R128a (aritmetica su 5..30 passo 1). **Il numero vero e' 7**, e lo dice il
driver. **`-SoloControllo` deve stampare `InpTrailTF 7 celle (enum
ENUM_TIMEFRAMES - lo step e' ignorato)`. Se stampa 26, ci si ferma.**

---

## 11. COSA QUESTO ROUND NON PUO' DIRE -- i buchi, dichiarati

1. **Niente prova di regime.** Tick dal 2024.09.26: nessun orso 2022, nessun
   crollo 2020. Valida la geometria dell'uscita, **mai** la robustezza di regime.
2. **Questo OOS e' gia' stato guardato molte volte** su questa sedia (FASE M,
   08/08, R101, R103, R107, R115, R118, R120...). Con tante guardate qualcosa
   esce verde per caso: **e' la ragione di G5, G6 e G7.**
3. **La frontiera del costo sul trailing PREVBAR non e' calcolabile prima**
   (par. 5.4): manca l'ampiezza mediana della candela per TF all'ora 8.
   **`[NON MISURATO]`**, e serve **prima** di proporre una cella di R128a.
4. **Il TP non e' separabile dal parziale** senza toccare l'EA (par. 2.1). R128b
   lo aggira spegnendo il parziale: misura il TP **in assenza di parziale**, che
   non e' la geometria viva.
5. **`InpTP1_ClosePct` in campo e' un conflitto aperto** (par. 0.2): preset 50%,
   pagella del 03/09 1/3. **Va letto sul terminale.**
6. **Lo stop realizzato della RETEST e' derivato, non misurato** (par. 5.2), e
   c'e' una **discrepanza di 2 punti indice** con l'altro agente da riconciliare.
7. **Il rischio del round e' 1,0%**, quello del conto reale **0,65%**: i DD vanno
   riscalati (x0,65) per il confronto col campo. La **direzione** del confronto
   fra celle non cambia; il numero assoluto si'.
8. **Nessuna promozione esce da qui.** R128 produce numeri. Toccare una sedia
   viva -- e questa gira anche sul **conto REALE 10105439** -- **e' una decisione
   di Claudio.**
