# 🏺 RIESAME DEI MORTI — FAMIGLIA **APERTURE**

**22/09/2026** · branch `lavoro` · 🛑 **SOLA LETTURA**: nessun round lanciato, nessuna riga
consegnata a Claudio, niente sul VPS, niente sul forward, nessun preset toccato, nessuna sedia
promossa o spenta. **Numeri, non decisioni.**

Richiesta di Claudio (22/09): _«VOGLIO RIGUARDARE ED RIANALIZZARE CON TUTTI GLI AGENTI TUTTI GLI
EA CHE ABBIAMO CONSIDERATI MORTI»_ · direttiva della stessa giornata: _«INTANTO: DA PROVARE IN +
TF MI RACCOMANDO, OGNI STRATEGIA»_.

✅ **DOCUMENTO CHIUSO.** Cancello deterministico passato
(`python3 backtest_pipeline/controlla_riga.py --oggetto md` → **EXIT 0, nessun difetto
meccanico**). Nessuna riga di lancio è contenuta qui dentro: il documento **non consegna
comandi**, consegna numeri. 🔴 **Una correzione mia è rimasta scritta apposta al §5.4**: una
prima stesura contestava il verdetto OPENCONFIRM del registro, il contro-esempio l'ha rotta, e
la traccia resta agli atti invece di sparire.

---

> ## 🎯 IN SETTE RIGHE
> 1. 🔴 **LA FAMIGLIA APERTURE NON È MORTA: È METÀ DELLA CHALLENGE.** Tre delle sei sedie
>    FTMO `541452707` sono aperture — `770101` DAX, `770202` Dow, `770260` Nasdaq. E
>    `REGISTRO_TEST.md` porta ancora, a riga 21, *«A4 Nasdaq_Apertura_US — 🔴 morto»*.
> 2. 🔴 **IL REGISTRO È FERMO AL 26/07.** Contiene **ZERO** occorrenze di `R172`, `R196`,
>    `R197`, `R198`, `R199`, `R200`, `R201`, `R202` — cioè **dell'intera campagna del 20-21/09
>    sulla famiglia**, 13 round `ROUND GIRATO` / `RILIEVI: 0` al banco vero (80.000) e alla
>    taglia vera (2,00%).
> 3. 🏆 **HO CHIUSO UN BUCO CHE IL REGISTRO DICHIARA APERTO** (r.2465-2468): lo *«studio aperture
>    FASE A su 8 INDICI»* di cui *«non ho trovato la tabella per simbolo»* **è nel repo** —
>    `risultati_archivio/studio_apertura/Studio_<SIM>_RIEPILOGO.csv`. Identificato con **4
>    riconciliazioni su 4 alla terza cifra** contro numeri che un altro referto citava di
>    seconda mano.
> 4. 🔴 **E quella tabella RIBALTA la «CONCLUSIONE APERTURA (definitiva)»**: su 8 indici il
>    **Dow è PRIMO** (+0,074 R/trade cieco, +0,126 col filtro H4) e il **Nasdaq è quinto**
>    (+0,001). **L'idea di Marco «Dow > Nasdaq» REGGE**, ed è misurata. Il registro scrive il
>    contrario.
> 5. 📉 **IL TF, come chiede Claudio, è il punto che sta peggio — e l'ho contato a macchina.**
>    Su **221 CSV** della famiglia: `InpLevelTF` **varia in 0**, `InpFilterTF` **in 0**,
>    `InpStTF` **in 0**, `InpVwapTF` **in 0**, `InpCorrTF` **in 0**, `InpPrevWindowMin` **in 0**.
>    **Sei manopole di timeframe su sette non sono MAI state messe ad asse dentro un round.**
>    Le due che un confronto ce l'hanno sono `InpTrailTF` (14 file) e `InpOCTimeframe`
>    (confrontato fra due corse, **e quel confronto ha ucciso l'OPENCONFIRM**).
> 6. 🔴 **`ABTG_Dow_Apertura_US` U30USD — la sedia `770202`, viva su FTMO da ieri — è girata
>    SOLO ED ESCLUSIVAMENTE SU M5**, in ogni CSV che esiste. Per la direttiva di Claudio il suo
>    verdetto è **NON ANCORA MISURATO** sul punto 5, e lo è **mentre opera**.
> 7. 💰 **Chiudere il punto 5 per TUTTA la famiglia costa 56 passate = 18,8 minuti** al costo
>    MISURATO di casa (20,1 s/passata, R202A del 21/09), **83,6 minuti** al bordo alto della
>    banda. Due file sono **già scritti e già gatati**: `R133a` e `R140c`.

---

# 0️⃣ COME HO MISURATO, e cosa NON ho usato

- **Il fatto è il CSV.** Ho letto **221 CSV** della famiglia (`risultati_archivio/{DAX_Apertura,
  Nasdaq_Apertura,Dow_Apertura,Apertura_nuovi_indici,Walkforward_Aperture,Aperture_Ingresso,
  Aperture_Trailing,Openconfirm,Marco_Emiliano,studio_apertura,r83_csv,r84_csv,r118_csv,csv_r51,
  csv_r54,ancora_passo7,ritardo_r119b_csv}` + `risultati_prove/{aperture_r35,r42,r43,r46,r47,
  apert_fade_realtick,ABTG_*_Apertura_*,dal_vps/*,R172D,R196A,R197A,R197B,R198,R199A,R199B,
  R200A,R200C,R200E,R201A,R202A,R202B}`), colonna per colonna.
- **Il MODELLO sta accanto al PF, sempre.** Dove è OHLC lo scrivo e **non lo chiamo verdetto**.
- **Classe 550**: dove `InpTP1_ClosePct > 0` la colonna `Trades` conta **USCITE**. Dove ho il
  numero in posizioni lo scrivo `[pos]`; dove non ce l'ho scrivo `[uscite]` e **non lo confronto
  col pavimento dei 150**.
- **Classe 547**: ogni DD porta accanto il rischio a cui è misurato. FTMO gira al **2,00%**.
- **NON ho usato** i referti come fonte di un numero: li uso solo per datare e per citare
  contraddizioni.

---

# 1️⃣ 🔴 LA COSA PIÙ GRAVE: IL REGISTRO È DI TRE MESI FA, E LA FAMIGLIA È IN CAMPO

## 1.1 Tre delle sei sedie FTMO sono aperture

| magic | EA | simbolo | TF | fonte |
|---|---|---|---|---|
| **`770101`** | `ABTG_DAX_Apertura_EU` | `D30EUR` | **M5** | `report/PACCHETTO_SCHIERAMENTO_PROP_2026-09-21.md` r.199 |
| **`770202`** | `ABTG_Dow_Apertura_US` | `U30USD` | **M5** | id. r.201 |
| **`770260`** | `ABTG_Nasdaq_Apertura_US` | `NASUSD` | **M5** | id. r.152 · preset `mql5/Presets/ABTG_Nasdaq_Apertura_US_RETEST_770260.set` |

Le altre tre sono `770411` MaxMinNotte DAX Short (M15), `771531` EMA200 (H1), `770511` SuperWave
(H1). 👉 **La famiglia che questo dossier doveva "riesumare" è il 50% della challenge.**

## 1.2 E il registro dice ancora che è morta

| `REGISTRO_TEST.md` | riga | testo | cosa dice il CSV, oggi |
|---|---|---|---|
| **A4** | r.21 | *«Nasdaq_Apertura_US NASUSD … 0% combo pos, best PF 0,91 · 🔴 morto»* | `R199B` OOS **PF 1,21546 · DD 7,8576% @ rischio 2%** su tick reali, banco 80.000 |
| **Tabella nuovi indici** | r.375-377 | *«U30USD Dow … PF 0,997 · 🔴 morto (a malapena in pari)»* | `R202A` OOS **PF 1,27175 · DD 4,3944% @1%** · `dow_walkforward_OOS` **40/40 celle in utile** |
| **Conclusione** | r.379 | *«CONCLUSIONE APERTURA (definitiva). … Su Nasdaq/FTSE/Dow → morto … L'idea di Marco (Dow>Nasdaq) NON regge … Fine dell'espansione della famiglia aperture»* | `studio_apertura/Studio_*_RIEPILOGO.csv`: **il Dow è PRIMO degli 8 indici**, il Nasdaq quinto |

🔴 **E il registro non contiene nemmeno una riga** su `R172`, `R196`, `R197`, `R198`, `R199`,
`R200`, `R201`, `R202` — verificato con `grep`. **I 13 round del 20-21/09 sulla famiglia non
sono archiviati.** È esattamente il difetto che Claudio ha chiamato *«NON È ACCETTABILE»* il
09/09: il numero esiste, ma chi cerca dove si cerca non lo trova.

---

# 2️⃣ 🏆 IL BUCO CHIUSO — la tabella FASE A per simbolo **è nel repo**

## 2.1 Il buco, com'era scritto

`REGISTRO_TEST.md` r.2465-2468 e `backtest_pipeline/prove/R138a_gemello_F40EUR_770101.txt`
r.56-60 dichiarano, testuale:

> *«Esiste in casa uno "studio aperture FASE A" su 8 INDICI … citato da almeno quattro referti …
> **ATTENZIONE: NON HO TROVATO LA SUA TABELLA PER SIMBOLO nel repo**, e quindi NON SO se F40EUR
> abbia già un'aspettativa misurata lì dentro.»*

## 2.2 Dove sta

**`backtest_pipeline/risultati_archivio/studio_apertura/Studio_<SIMBOLO>_RIEPILOGO.csv`** — otto
file, uno per indice, committati il **03/08/2026** (`ff3ca93b`). Più gli otto CSV per-trade.

## 2.3 La prova che è LEI — e l'ho costruita **contro** la mia ipotesi, non a favore

`Dow_Apertura/DOW_MOTORE.md` cita **di seconda mano** quattro numeri della FASE A senza mai
linkarne il file. Se i miei CSV sono quelli, l'effetto del filtro H4 (= riga *«Con FILTRO H4»*
meno riga *«TUTTI i breakout»*) deve riprodurli **tutti e quattro**.

| indice | FASE A cieco | FASE A con H4 | **Δ calcolato** | **Δ citato da `DOW_MOTORE.md`** | esito |
|---|---:|---:|---:|---:|---|
| `U30USD` Dow | **+0,074** | **+0,126** | **+0,052** | *«+0,052 R/trade»* (r.37) | ✅ |
| `D30EUR` DAX | +0,026 | −0,017 | **−0,043** | *«DAX −0,043»* (r.45) | ✅ |
| `F40EUR` CAC | −0,056 | −0,109 | **−0,053** | *«CAC −0,053»* (r.45) | ✅ |
| `E35EUR` IBEX | −0,048 | −0,129 | **−0,081** | *«IBEX −0,081»* (r.45) | ✅ |

🟢 **4 su 4, alla terza cifra.** Una coincidenza su quattro numeri indipendenti a tre decimali
non è una coincidenza. **La tabella è identificata.**

## 2.4 E cosa dice — **la classifica degli 8 indici in apertura**

Aspettativa in **R per operazione**, buffer 200 pt, slippage 100 pt, TP 2,0R, stop all'estremo
opposto. 🔴 **Modello 1 = OHLC M1. Screening, NON verdetto** (`studio_apertura.ps1` r.93 al pin
`ff3ca93b`).

| # | simbolo | strumento | cieco (n) | solo LONG (n) | solo SHORT (n) | con filtro H4 (n) |
|---|---|---|---:|---:|---:|---:|
| **1** | **`U30USD`** | **Dow** | 🟢 **+0,074** (446) | 🟢 **+0,095** (231) | 🟢 +0,052 (215) | 🟢 **+0,126** (212) |
| 2 | `D30EUR` | DAX | 🟢 +0,026 (440) | +0,007 (225) | 🟢 **+0,045** (215) | −0,017 (203) |
| 3 | `NASUSD` | Nasdaq | +0,001 (447) | −0,005 (226) | +0,007 (221) | 🟢 +0,055 (234) |
| 4 | `SPXUSD` | S&P 500 | −0,017 (444) | −0,022 (227) | −0,013 (217) | −0,002 (227) |
| 5 | `E50EUR` | Stoxx 50 | −0,048 (440) | −0,055 (245) | −0,040 (195) | −0,068 (211) |
| 6 | `E35EUR` | IBEX 35 | −0,048 (211) | −0,032 (106) | −0,065 (105) | −0,129 (104) |
| 7 | `F40EUR` | CAC 40 | −0,056 (443) | −0,054 (235) | −0,058 (208) | −0,109 (202) |
| 8 | `100GBP` | FTSE 100 | 🔴 **−0,138** (431) | −0,072 (216) | 🔴 −0,205 (215) | −0,137 (213) |

**Totale 3.302 rotture** (non «~3.500» come scrivono quattro referti: il conto esatto è 3.302).

### 🔴 Le tre conseguenze, e nessuna è piccola

1. **«Dow > Nasdaq» di Marco REGGE.** +0,074 contro +0,001 sul cieco, +0,126 contro +0,055 col
   filtro. Il registro r.379 dice *«NON regge in versione automatica»* — e sulla versione
   automatica a tick reali (§4) il Dow è ancora il migliore della famiglia. **La frase del
   registro è smentita da due misure indipendenti.**
2. 🔴 **Sul DAX, in FASE A, lo SHORT batte il LONG** (+0,045 contro +0,007). Tutta la dottrina
   di casa *(«sul DAX funziona SOLO LONG»)* nasce dall'EA a tick reali, dove il LONG vince
   davvero (§4.1). **Le due misure discordano**, e la differenza è la GESTIONE: la FASE A usa
   TP fisso 2R e niente trailing, l'EA usa parziale + BE + trailing a candela. 👉 **Non è un
   errore di nessuno dei due: è la prova che su questo motore la direzione e l'uscita non sono
   separabili.** E il lato corto del DAX ha un file prova pronto e mai girato (`R205a`).
3. 🔴 **`E50EUR`, `E35EUR`, `SPXUSD` hanno un numero NEGATIVO qui, e sono gli stessi simboli che
   il registro r.2457 chiama «MAI PROVATI, casella LIBERA».** Non sono liberi: sono **provati in
   OHLC e negativi**. Per la regola della seconda caccia, rifarli chiede una **tesi nuova** — e
   la tesi c'è, la stessa scritta per `F40EUR`: la FASE A misura la **rottura cieca**, la cella
   viva è un **RETEST** con offset, che la FASE A non contempla.

---

# 3️⃣ 📉 IL PUNTO 5 — IL TIMEFRAME, contato a macchina su 221 CSV

> Direttiva di Claudio del 22/09: il TF è **il più pesante dei cinque punti**, si elenca **per
> nome**, e un solo TF ⇒ **NON ANCORA MISURATO** anche con gli altri quattro pieni.

## 3.1 🔴 Sei manopole di TF su sette non sono MAI state messe ad asse dentro un round

Censimento mio, su tutti i CSV della famiglia che contengono la colonna:

| manopola | a cosa serve | file che la contengono | **file in cui VARIA** | valori mai visti diversi da |
|---|---|---:|---:|---|
| `InpLevelTF` | **il TF che DECIDE i livelli** quando `RangeMode≠0` | 221 | 🔴 **0** | H1 (218 file), D1 (2) |
| `InpFilterTF` | TF del filtro EMA — **è quello che porta il Dow da 1,03 a 1,24** | 221 | 🔴 **0** | H1, H4 (mai confrontati) |
| `InpStTF` | TF del Supertrend | 221 | 🔴 **0** | H1 |
| `InpOCTimeframe` | TF su cui OPENCONFIRM guarda l'apertura | 186 | 🟡 **0 DENTRO un file** — ma confrontato **fra due corse** (`Openconfirm/*graficoM5* vs *M15*`) | `PERIOD_CURRENT`(=M5), M15 |
| `InpVwapTF` | TF della VWAP | 215 | 🔴 **0** | M15 |
| `InpCorrTF` | TF della correlazione | 221 | 🔴 **0** | H1 |
| `InpTrailTF` | TF della candela del trailing | 221 | 🟢 **14** | M1·M2·M3·M4·M5·M6·M10·M12·M15·M20 |

### 3.1-bis 🔴 E lo stesso vale per il SUPERTREND, che è il cuore di due «morti»

Stesso conto, stessi 221 CSV:

| manopola | file che la contengono | **file in cui VARIA** | valori mai visti diversi da |
|---|---:|---:|---|
| `InpUseSupertrend` | 221 | 🔴 **0** | 0 e 1, ma **mai nello stesso round** |
| `InpStMultiplier` | 221 | 🔴 **0** | **2,5** — un valore solo, in tutto l'archivio |
| `InpStAtrPeriod` | 221 | 🔴 **0** | **10** — un valore solo |
| `InpUseSupertrend3` | 212 | 🔴 **0** | 0 e 1, mai nello stesso round |

👉 **A1** (*«entrambe + Supertrend ON»*, bocciata il 26/07) e **A5** (*«direzione adattiva
Supertrend D1»*, mai girata) poggiano tutte e due su un meccanismo di cui **non è mai stato
mosso nemmeno un parametro**, su **un solo TF** (H1) e con **un solo moltiplicatore** (2,5).
🔴 **Non è «già provato»: è una casella chiusa a chiave**, come lo era `InpRangeMinutes` prima
che si scoprisse che `InpRangeMode` la teneva ferma.

🔴 **Controprova indipendente su TUTTO il repo**: `InpLevelTF` compare in **240** CSV (famiglia
e non) e **varia in ZERO**. È lo stesso numero che `prove/R133a_livelliTF_NASUSD.txt` r.24-29
dichiara di aver misurato il 12/09 su 2.083 file — **riprodotto oggi, da un conto mio**.

## 3.2 🔬 E il TF DEL GRAFICO: quando morde e quando no — **letto nel sorgente, non dedotto**

Per questa famiglia il segnale è **ancorato al CALENDARIO**, non alle barre: il range si calcola
su `PERIOD_M1` **cablato** e la macchina a fasi gira su **minuti d'orologio**.

| dipendenza da `PERIOD_CURRENT` | riga | vive solo se |
|---|---|---|
| `gAtrH = iATR(_Symbol, PERIOD_CURRENT, …)` | `ABTG_DAX_Apertura_EU.mq5` r.510 · `Nasdaq` r.450 · `Dow` r.396 | `InpSLMode≠0` **oppure** `InpUseAtrFilter=true` |
| `octf = (InpOCTimeframe==PERIOD_CURRENT) ? Period() : …` | DAX r.1508 · Nasdaq r.1316 · Dow r.1207 | `InpEntryMode=5` (OPENCONFIRM) |
| **`VolumeOK(){ return VolumeOKtf(PERIOD_CURRENT); }`** | DAX r.2720 · **Nasdaq r.2530** · Dow r.2091 | **`InpUseVolumeFilter=true`** |
| `iTime(_Symbol, PERIOD_CURRENT, 0)` in `UpdateVolRegime` | Nasdaq r.1907 | `InpUseVolRegime=true` |
| il range vero | DAX r.1145-1158 · Nasdaq r.941-953 · Dow r.844-857 | **mai**: è `PERIOD_M1` cablato |

Incrociando col pinning delle tre celle vive (letto nei CSV `R202A`/`R202B`/`R199B`):

| sedia | `SLMode` | `AtrFilter` | `EntryMode` | `VolumeFilter` | `VolRegime` | **il TF del grafico morde?** |
|---|---|---|---|---|---|---|
| `770101` DAX | 0 | false | 2 | **false** | — | 🔵 **NO — invarianza PREVISTA dal sorgente** |
| `770202` Dow | 0 | false | 2 | **false** | — | 🔵 **NO — invarianza PREVISTA** |
| **`770260` Nasdaq** | 0 | false | 2 | 🟢 **TRUE** (`VolAvgBars=20`) | false | 🔴 **SÌ, MORDE** — il volume si legge sulla barra del grafico |

> ## 🔴 LA CONSEGUENZA CHE CAMBIA IL LAVORO
> Su **DAX e Dow** cambiare `@PERIODO` deve dare **gli stessi numeri**: non è una misura nuova,
> è un **cancello di verifica** — e va fatto lo stesso, perché un'identità perfetta può essere
> una misura **o** un artefatto (se `@PERIODO` non arrivasse al tester la corsa girerebbe due
> volte a M5 e darebbe lo stesso CSV: si legge il `.ini` / il Giornale).
> Su **Nasdaq `770260`** cambiare `@PERIODO` è una **misura vera e mai fatta**, perché il filtro
> volumi legge la barra del grafico.

## 3.3 🟢 La frontiera del costo **NON dipende dal TF, su questa famiglia** — e va detto col numero

La legge di casa (`REGISTRO_TEST.md` r.2781-2789): *«un motore guadagna operazioni scendendo di
TF se e solo se il suo stop si stringe scendendo di TF»*. Qui lo stop è **l'estremo opposto del
range di N MINUTI**: 35 minuti restano 35 minuti a M5 come a H1. 👉 **Lo stop non cambia con il
TF, quindi il rapporto `stop/spread` non cambia con il TF.**

| sedia | geometria dello stop | stop MISURATO | spread mediano (ora modale) | **stop/spread** | 40x? | 13,3x? |
|---|---|---|---|---|---|---|
| `770101` D30EUR | estremo opposto range 35' + buffer 500 pt | **71,9 idx** [MIS, n=7 gambe] | **1,70** (ora 08) | **42,3x** · 🟠 **26,6x al P95 2,70** · 33,0x sulla geometria viva | 🟡 al limite | 🟢 sì |
| `770202` U30USD | range 15' + 2×buffer, floor `MinStopPts=500` | **123,8 idx** [MIS, n=446] | **2,00** (ora 15) | 🟢 **61,9x** · **41,2x** alla coda 3,00 | 🟢 **sì (+55%)** | 🟢 sì |
| `770250` NASUSD **M15** | candela H1 prec. + buffer 300 pt | **83,2 idx** [INF] | **1,80** (ora 14) | 🟢 **46,2x** (coda 43,8x) | 🟢 sì (+16%) | 🟢 sì |

Fonte: `report/CANCELLO_COSTO_FLOTTA_2026-09-10.md` r.396/400/414, con le errata del 18/09.
🔴 **Nessun TF di questa famiglia è escludibile PER COSTO**, e il numero è questo. Chi scrivesse
*«M5 sugli indici sfonda la frontiera, quindi saliamo di TF»* avrebbe ragione **in generale** e
torto **qui**: su un motore a calendario quella leva non esiste.

## 3.4 📏 Il tetto delle ~100.000 barre — coi numeri misurati

Barre disponibili dal muro dei tick (`risultati_archivio/misura_tick/REFERTO_MISURA_TICK_*.txt`,
tutte e tre le sonde: **i tick e le barre M1 partono dal 2024.09.26**):

| simbolo | M1 [MIS] | M5 [MIS] | M15 [derivato] | M30 | H1 |
|---|---:|---:|---:|---:|---:|
| `D30EUR` | 642.270 | **129.666** | ~43.200 | ~21.600 | ~10.800 |
| `NASUSD` | 660.018 | **132.017** | ~44.000 | ~22.000 | ~11.000 |
| `U30USD` | 650.255 | **130.126** | ~43.400 | ~21.700 | ~10.800 |

👉 A **M5** la finestra piena 2024.09.26→2026.06.30 **sfonda** il tetto delle 100.000 barre: ci
sta **solo perché il walk-forward la spezza in due tranche** (IS 40% ≈ 52k, OOS 60% ≈ 78k). Da
**M15 in su il problema sparisce**. È un argomento **a favore** di salire, indipendente dal PF.

## 3.5 💰 IL COSTO DI CHIUDERE IL PUNTO 5 PER TUTTA LA FAMIGLIA

**Base di costo MISURATA** (non stimata): `R202A` del 21/09 — `ABTG_Dow_Apertura_US`, `U30USD`,
**M5**, modello 4, finestra 2024.09.26-2026.06.30, deposito 80.000, **8 passate**, avvii
23:24:38 → 23:27:19 = **2 min 41 s ⇒ ≤ 20,1 s/passata** su `DESKTOP-H4D7CAJ`
(`backtest_pipeline/righe/RIGA_R211A_DA_MANDARE.md` r.138). Bordo alto della banda di casa
indicato dal coordinatore: **89,6 s/passata**. Salendo di TF il costo **scende**, quindi questi
sono **tetti**, non stime centrali.

| # | misura | bersaglio | passate | **@20,1 s** | **@89,6 s** | stato del file |
|---|---|---|---:|---:|---:|---|
| 1 | `InpLevelTF` ad asse (M15·M20·M30·H1·H2·H3·H4) | NASUSD | **14** | **4,7 min** | 20,9 min | 🟢 **`prove/R133a_livelliTF_NASUSD.txt` — `controlla_prova.py` ESITO OK, 7 celle, MAI GIRATO** |
| 2 | `@PERIODO M15` a parità di cella | D30EUR `770101` | **4** | **1,3 min** | 6,0 min | 🟢 **`prove/R140c_tfingresso_M15_770101_D30EUR.txt` — MAI GIRATO** |
| 3 | `@PERIODO M15` a parità di cella | U30USD `770202` | 4 | 1,3 min | 6,0 min | ⚪ da scrivere |
| 4 | `@PERIODO M30` a parità di cella | U30USD `770202` | 4 | 1,3 min | 6,0 min | ⚪ da scrivere |
| 5 | `@PERIODO M15` — **morde davvero** | NASUSD `770260` | 4 | 1,3 min | 6,0 min | ⚪ da scrivere |
| 6 | `@PERIODO M30` — **morde davvero** | NASUSD `770260` | 4 | 1,3 min | 6,0 min | ⚪ da scrivere |
| 7 | `InpFilterTF` ad asse (H1·H2·H3·H4) — la manopola del +0,21 di PF sul Dow | U30USD | 8 | 2,7 min | 11,9 min | ⚪ da scrivere |
| 8 | `InpLevelTF` ad asse | U30USD | 14 | 4,7 min | 20,9 min | ⚪ da scrivere |
| | **TOTALE** | | **56** | 🟢 **18,8 min** | 83,6 min | |

> 🔴 **Verifica obbligatoria su 2-3-4** (e la scrivo prima, non dopo): l'identità attesa fra M5
> e M15 su DAX/Dow si legge **solo** se si controlla nel `.ini` / nel Giornale che il TF sia
> davvero cambiato. Un'identità perfetta ottenuta girando due volte a M5 sarebbe indistinguibile
> dal risultato giusto.

## 3.6 📊 Frequenza attesa salendo di TF — dichiarata

Il motore ha `InpOneTradePerDay=true` e il segnale è a calendario: **salire di TF NON toglie
operazioni** su DAX e Dow (il TF non entra nel segnale). Su NASUSD `770260` il TF entra dal
filtro volumi: la frequenza può muoversi **in tutte e due le direzioni** ed è **[NON MISURATA]**.
Base attuale: `770101` **0,728 pos/g** · `770202` **0,362 pos/g** · `770260` **≈0,37 pos/g**
(102 posizioni OOS su ~276 giorni feriali) — pavimento firmato **1,00 per FAMIGLIA**, e la
famiglia aperture da sola fa **≈1,46 pos/g** sommando le tre sedie.

---

# 4️⃣ 📋 LA TABELLA MADRE

**Legenda dei cinque punti**: ① PF misurato · ② n e DD · ③ gestione dell'uscita messa ad asse ·
④ simboli gemelli provati · ⑤ **TF cambiato (elencati per nome)**.
🔴 Per la direttiva del 22/09, ⑤ con **un solo TF** ⇒ verdetto **NON ANCORA MISURATO**.

| # | candidato | simb | **TF provati (per nome)** | modello | finestra REALE | rischio | PF IS/OOS | n IS/OOS | DD IS/OOS | ① | ② | ③ | ④ | ⑤ | **VERDETTO** |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| **A** | `ABTG_Dow_Apertura_US` / motore aperture su **U30USD** *(registro: «morto, a malapena in pari»)* | `U30USD` | 🔴 **solo M5** | tick (4) | IS 2024.09.26-2025.06.09 · OOS →2026.06.30 | 1% | **1,22247 / 1,27175** | 74/130 `[uscite]` = **56/96 `[pos]`** | 5,67 / **4,39%** | ✅ | ✅ | ✅ | ✅ | 🔴 **NO** | ⚪ **NON ANCORA MISURATO** — e **opera su FTMO** |
| **B** | `Dow_Apertura` **BREAKOUT 2 LATI + EMA H4 + trail candela M5** *(il «40/40»)* | `U30USD` | 🔴 **solo M5** | tick (4) | IS 2024.09.26-2025.06.30 (etichetta 2024.01) · **OOS 2025.07.01-2026.06.30 pulita** | 1% | 0,988-1,546 / **1,267-1,560** | 138-154 / **186-198 `[pos]`** | ≤12,47 / **≤8,70%** | ✅ | ✅ | ✅ | ✅ | 🔴 **NO** | ⚪ **NON ANCORA MISURATO** — 🏆 **il numero più forte dell'archivio aperture** |
| **C** | `ABTG_Nasdaq_Apertura_US` `770260` RETEST+volumi+gap *(registro A4: «morto, best PF 0,91»)* | `NASUSD` | **M5** (R196-R209) · **M15** (R84a-i, 770250) — mai a parità | tick (4) | 2024.09.26→2026.06.30, taglio 0,40 | 🟢 **2,00%** | **1,22116 / 1,21546** | 135/172 `[uscite]` = **82/102 `[pos]`** | 7,31 / **7,86%** | ✅ | ✅ | ✅ | ✅ | 🟡 **parziale** | ⚪ **NON ANCORA MISURATO** (merito sospeso: 102 pos < 150) — **opera su FTMO** |
| **D** | `ABTG_DAX_Apertura_EU` `770101` LONG RETEST | `D30EUR` | **M5** (R47/R137/R202B) · **M15** (R83v, R118b/c) — mai a parità | tick (4) | id. | 1% | **1,12733 / 1,39520** | 175/270 `[uscite]` = **132/193 `[pos]`** | 5,41 / **7,25%** | ✅ | ✅ | ✅ | ✅ | 🟡 **parziale** | 🟢 **VIVO** (prima classificata al 2° seggio) — ⑤ da isolare con `R140c` |
| **E** | **A1** `DAX_Apertura` *«entrambe + Supertrend ON»* *(registro: «morto (config sbagliata)»)* | `D30EUR` | 🔴 **solo M5** | tick (4) | 2024.09.26→2026.06.30 (etichetta 2024.01) | 1% | — / — (finestra unica, best 1,03 — 🔴 **CSV non in repo**) | — | — | 🟡 | 🔴 | 🔴 | 🔴 | 🔴 | ⚪ **NON ANCORA MISURATO, e a metà è ANCORA APERTO** — il «due lati» **è misurato** (`DAX_M_direzione`) ed è **peggio del solo-LONG in tutte e due le finestre** — IS 0,975-0,998 vs 1,001-1,156 · OOS 1,039-1,237 vs 1,118-1,423; il **Supertrend NO**: `InpUseSupertrend` varia in **0 file su 221**, `InpStMultiplier` e `InpStAtrPeriod` **mai mossi** (§3.1-bis) |
| **F** | **A3** `DAX_Apertura` **SOLO SHORT** *(registro: «⏳ in coda»)* | `D30EUR` | 🔴 **solo M5** | tick (4) | IS/OOS puliti (`Walkforward_Aperture/DAX_M_direzione`) | 1% | **0,84559 / 1,21230** (best) | 152 / 237 `[uscite]` | 10,54 / **9,02%** | ✅ | ✅ | ✅ | ✅ | 🔴 **NO** | ⚪ **NON ANCORA MISURATO** — 🔴 **segno che si INVERTE fra IS e OOS su 3 celle su 3** |
| **G** | `ABTG_DAX_Apertura_EU` su **100GBP** (FTSE) *(registro: «morto»)* | `100GBP` | 🔴 **solo M5** | tick (4) | finestra unica, etichetta 2024.01 (reale ≈2024.09.26) | 1% | — / **0,90423** (best di 72) | — / 283 `[uscite]` | — / **9,58%** | ✅ | ✅ | 🟡 (solo `TrailFixedPts`, **inerte**) | ✅ | 🔴 **NO** | 🪦 **MORTO** sul merito (§7.1) · ⚪ non certificato su ③⑤ |
| **H** | `ABTG_DAX_Apertura_EU` su **F40EUR** (CAC) — `R138a` | `F40EUR` | 🔴 **solo M5** | tick (4) | IS/OOS puliti | 1% | **1,44028 / 0,76965** | 130/195 `[uscite]` = **—/152 `[pos]`** | 7,36 / 🔴 **11,82%** | ✅ | ✅ | 🔴 **NO** (1 cella sola) | 🟡 | 🔴 **NO** | 🪦 **LA CELLA È MORTA PER RISCHIO** (F3, soglia congelata 10,0%) · ⚪ **il SIMBOLO no** |
| **I** | `ABTG_DAX_Apertura_EU` su **E50EUR / E35EUR / SPXUSD / US2000** | — | 🔴 **nessuno** | 🔴 **solo OHLC** (FASE A) | — | — | **[NON MISURATO]** con l'EA | — | — | 🔴 | 🔴 | 🔴 | 🔴 | 🔴 | ⚪ **NON ANCORA MISURATO** — e 🔴 **NON è una casella libera**: FASE A li dà negativi (§2.4) |
| **J** | `ABTG_Apertura_Marco` (famiglia Marco) | `D30EUR` | 🔴 **solo M5** | tick (4) | **finestra unica**, nessun IS/OOS | 1% | — / **1,24419** (best) | — / 309 `[uscite]` | — / 4,69% | ✅ | ✅ | 🔴 **NO** | ✅ | 🔴 **NO** | ⚪ **NON ANCORA MISURATO** — manca lo **split IS/OOS**: il «best di 22» è selezione |
| **K** | `ABTG_Apertura_Marco` | `NASUSD` | 🔴 **solo M5** | tick (4) | finestra unica | 1% | — / **0,84203** (best di 22) | — / 335 `[uscite]` | — / 5,96% | ✅ | ✅ | 🔴 | ✅ | 🔴 | 🪦 **MORTO** sul merito: **22 celle su 22 sotto 0,85** |
| **L** | `ABTG_Apertura_3Ingressi` — duello ingressi | `NASUSD` | **M15** | tick (4) | 2024.09.26, taglio 0,40 | 1% | 0,70-1,25 / **0,62-0,98** | 156-198 / 291-313 `[uscite]` (**260 pos**) | ≤9,7 / ≤29,1% | ✅ | ✅ | ✅ | ✅ | 🔴 **solo M15** | 🪦 **MORTO** sul merito: **0 su 3 stili positivi in OOS** |
| **M** | `ABTG_Apertura_3Ingressi` — duello ingressi | `D30EUR` | **M15** | tick (4) | id. | 1% | 1,0467-1,0781 / **1,0409-1,1878** | 197-220 / 311-325 `[uscite]` (**245 pos**) | ≤8,97 / ≤13,26% | ✅ | ✅ | ✅ | ✅ | 🔴 **solo M15** | 🟢 **VIVO** — il RETEST vince, e incorona `770101` |
| **N** | **DELAYED** (`EntryMode=4`) + volumi — round `Openconfirm` | `D30EUR`·`NASUSD` | 🔴 **solo M5** (grafico) | tick (4) | finestra unica, etichetta 2024.01 | 1% | — / **1,19714** DAX · **1,19981** NAS | — / 120 · 99 `[uscite]` | — / 8,12% · **4,78%** | ✅ | ✅ | 🟡 | ✅ | 🔴 **NO** | ⚪ **NON ANCORA MISURATO** — positivo su **due mercati**, ma **finestra unica** e campione sottile (§5.4) |
| **O** | **OPENCONFIRM** (`EntryMode=5`) | `D30EUR`·`NASUSD` | **M5** (grafico) · `InpOCTimeframe` **M5 e M15** | tick (4) | finestra unica **+** IS/OOS (`B_motore`) | 1% | **1,81587 / 0,69553** (NAS, vol ON) | 108 / 108 `[uscite]` | 3,75 / 12,73% | ✅ | ✅ | ✅ | ✅ | 🟢 **SÌ** (l'unico TF mai confrontato nella famiglia) | 🪦 **MORTO CERTIFICATO** — **1 cella positiva su 8** e crollo IS→OOS (§7.5) |
| **P** | **RANGE-FADE** (`EntryMode=3`) | `D30EUR`·`NASUSD` | **M5 e M15** | tick (4) | IS/OOS puliti | 1% | 0,68-0,84 / **0,70-0,93** | 113-181 / 51-245 | ≤19,1 / **≤17,3%** | ✅ | ✅ | ✅ | ✅ | 🟢 | 🪦 **MORTO CERTIFICATO** — negativo su 2 mercati × 2 finestre × 2 TF |
| **Q** | **A5** «stile Monza» (direzione adattiva Supertrend **D1**) | `D30EUR`·`NASUSD` | 🔴 **nessuno** | 🔴 **mai girato** | — | — | **[NON MISURATO]** | — | — | 🔴 | 🔴 | 🔴 | 🔴 | 🔴 | ⚪ **NON ANCORA MISURATO** — e 🟢 **la casella è DAVVERO libera**: `InpStTF` vale **H1 in tutti e 221 i CSV**, il **D1 che la tesi richiede non è mai stato usato** |
| **R** | **A16** `Nasdaq_PreOpen_Breakout_EA` (ESTERNO) | `NASUSD` | 🔴 **nessuno** | 🔴 **mai girato** | — | — | **[NON MISURATO]** | — | — | 🔴 | 🔴 | 🔴 | 🔴 | 🔴 | 🔴 **NON SI SCHIERA** — e il motivo **non è il PF**: fuso cablato + costo 13,33x. Resta com'è |

---

# 5️⃣ 🏆 LA CLASSIFICA DEI RESUSCITABILI

Ordinata per *«quanto vicino a una sedia schierabile il 1° ottobre»*. Per ognuno: **l'UNA misura
che lo sblocca** e il suo costo.

### 🥇 1 — **`Dow_Apertura` BREAKOUT 2 LATI su `U30USD`** (riga **B**)

**Perché è primo.** È l'unica configurazione dell'intero archivio aperture che mette insieme le
quattro cose che servono:

| requisito | numero | fonte |
|---|---|---|
| **n OOS in POSIZIONI ≥ 150** | 🟢 **186-198** (`InpTP1_ClosePct=0` ⇒ uscite = posizioni) | `Dow_Apertura/dow_walkforward_OOS.csv` |
| **OOS a tick VERI** | 🟢 la finestra **2025.07.01-2026.06.30 è tutta dopo il muro 2024.09.26** | `misura_tick/REFERTO_MISURA_TICK_U30USD.txt` |
| **altopiano, non picco** | 🟢 **40/40 celle sopra 1,00 · 40/40 sopra 1,20** · min 1,267 · mediana 1,374 | id. |
| **frontiera del costo** | 🟢 **61,9x** (41,2x alla coda) contro il 40x | `CANCELLO_COSTO_FLOTTA` r.400 |
| **due lati** | 🟢 `InpAllowLong=1` **e** `InpAllowShort=1` | colonne del CSV |
| DD max OOS | **8,70% @ rischio 1%** | id. |

**LA MISURA CHE LO SBLOCCA: il TF.** È l'unico dei cinque punti vuoto. **8 passate = 2,7 min**
(`@PERIODO M15` e `@PERIODO M30` a parità di cella, due file, una variabile per file).

🔴 **E la seconda cosa da misurare, che NON è opzionale**: `Equity DD %` **8,70% è a rischio
1,00%**. Alla taglia FTMO del 2,00% il fattore misurato in casa è **1,956-1,990** ⇒ **17,0-17,3%**,
cioè **sopra il muro del 10%**. 👉 **Questa cella non è schierabile alla taglia di campo senza
scalare il rischio**, e va detto insieme al PF, non dopo.

> **🧪 CONTRO-ESEMPIO — l'argomento che lo ucciderebbe, e perché non regge.**
> *«Quel 40/40 è la trappola già disinnescata dal registro r.2445: misura un'ALTRA sedia, dodici
> input diversi da `770202`.»*
> ✅ **Vero, e resta vero — ma non uccide: sposta.** Il registro stesso chiude scrivendo *«Il
> 40/40 resta valido: per il motore BREAKOUT a due lati con range di 15 minuti, che non è una
> sedia del parco»*. 👉 Cioè: **non è un numero da attribuire a `770202`, è un CANDIDATO
> AUTONOMO mai schierato.** Usarlo per `770202` sarebbe classe 224; **archiviarlo perché non
> serve a `770202` è l'errore opposto**, ed è quello che è successo.
> *«Ma l'IS parte dal 2024.01.01, prima del muro dei tick: numeri fabbricati (classe 590).»*
> 🔴 **Falso, e l'ho verificato con l'aritmetica invece di fidarmi.** Se l'IS fosse davvero 18
> mesi, alla cadenza dell'OOS (196 op / 12,0 mesi = 16,33/mese) dovrebbe avere **~294**
> operazioni. Ne ha **141**. Su 9,15 mesi reali (2024.09.26→2025.06.30) l'atteso è **149,4**:
> scarto **5,6%**. 👉 **MT5 non ha fabbricato niente: ha semplicemente cominciato dove
> cominciano i dati.** È la stessa conclusione che il commit `2f4c95ae` del 05/08 aveva già
> misurato (*«la finestra IS non era corrotta, era più corta dell'etichetta»*). **Il difetto di
> classe 590 qui è nell'ETICHETTA, non nei numeri** — e va corretto ovunque si scriva «2,5 anni»
> per gli indici, che sono **21 mesi**.

---

### 🥈 2 — **`ABTG_Nasdaq_Apertura_US` `770260`** (riga **C**) — *il «morto» che sta operando*

| numero | valore | nota |
|---|---|---|
| PF OOS | **1,21546** | 🟢 tick reali, **rischio 2,00% = la taglia FTMO** |
| DD OOS | **7,8576%** | 🟢 **già sotto il muro del 10% ALLA TAGLIA VERA** — non serve raddoppiare niente |
| n OOS | **172 `[uscite]` = 102 `[pos]`** | 🔴 sotto il pavimento dei 150 ⇒ **merito SOSPESO** |
| altopiano | 🟢 `ClosePct` **25/50/75 → 1,224 / 1,215 / 1,204**, e **`0` sta sotto a 1,149** | tre celle adiacenti, il centro è dentro |

🟢 **Corroborazione incrociata che non avevo cercato**: il rapporto uscite/posizioni 172/102 =
**1,686** dice che il **68,6%** delle posizioni ha toccato `TP1_R=0,5`. Lo studio MAE/MFE di
stamattina (`report/MFE_E_DURATA_APERTURE_2026-09-22.md`, fonte del tutto indipendente) misura
che su NASUSD il **65,3%** arriva a 0,50R. **Due strade diverse, stesso numero al 3%.**

**LA MISURA CHE LO SBLOCCA: il TF — e qui MORDE DAVVERO.** `InpUseVolumeFilter=true` ⇒
`VolumeOKtf(PERIOD_CURRENT)` legge la barra del grafico. **`R133a` è già scritto e già gatato**
(`InpLevelTF` su 7 TF, `controlla_prova.py` ESITO OK) = **14 passate, 4,7 min**; più `@PERIODO`
M15/M30 = 8 passate, 2,7 min. **Totale 7,4 minuti.**

> **🧪 CONTRO-ESEMPIO.** *«102 posizioni: il merito è sospeso, quindi il PF 1,215 non vuol dire
> niente e la sedia va spenta.»*
> ✅ **La prima metà è giusta, la seconda no, e la differenza è firmata (16/08, Emendamento B):
> il campione sottile sospende il MERITO, MAI il RISCHIO.** Il DD **7,86% alla taglia vera** è
> un fatto accaduto e si legge a qualunque n. E il pavimento dei 150 è **per FAMIGLIA** dal
> 07/09: la famiglia aperture fa ≈1,46 pos/g con tre sedie. 👉 **«Merito sospeso» non è «morto»:
> è «aspetta il campione»** — ed è esattamente la casella in cui il certificato di morte dice di
> scrivere *cosa manca*.

---

### 🥉 3 — **`ABTG_DAX_Apertura_EU` `770101`** (riga **D**) — vivo, ma ⑤ non isolato

Non è un resuscitato: è la prima classificata. Entra in classifica per **una sola ragione**:
`R140c` è scritto, gatato, **mai girato**, costa **4 passate = 1,3 min**, e senza di lui il
punto 5 del suo certificato resta formalmente aperto — **su una sedia che opera**.
🟡 Nota di rischio già agli atti: **26,6x al P95 dello spread**, sotto il 40x di lavoro.

---

### 4 — **DELAYED (`EntryMode=4`) + volumi** (riga **N**) — positivo su due mercati, mai portato a fuori campione

| mercato | PF | DD% | n `[uscite]` | profitto |
|---|---:|---:|---:|---:|
| `D30EUR` M5 | **1,19714** | 8,1222 | 120 | +619,91 |
| `NASUSD` M5 | **1,19981** | 🟢 **4,7841** | 99 | +387,22 |

🟢 **Due mercati, stesso segno, stesso ordine di grandezza, DD basso su entrambi.** È l'unico
meccanismo alternativo della famiglia che riesce a fare questo.

**LA MISURA CHE LO SBLOCCA: lo split IS/OOS.** Oggi è **una finestra sola** e il «migliore di 9
esiti» è **selezione, non altopiano**. Costo: 2 celle × 2 finestre × 2 mercati = **8 passate,
2,7 min**.

> **🧪 CONTRO-ESEMPIO — e questo MI HA CORRETTO, quindi lo scrivo per intero.**
> Avevo scritto, in una prima stesura di questo dossier, che la bocciatura del registro
> (*«OPENCONFIRM: una cella positiva su otto, cambia segno con timeframe, volumi e mercato»*)
> era **falsa**, perché i file `DAX_openconfirm_M15.csv` e `DAX_openconfirm_graficoM5.csv`
> danno **numeri identici alla quinta cifra**.
> 🔴 **Ero io a sbagliare, su due cose insieme.**
> **(1)** Quei numeri identici sono di `EntryMode=4` (**DELAYED**), non di `EntryMode=5`
> (**OPENCONFIRM**): sono due motori diversi dello stesso enum.
> **(2)** E sono identici per una ragione **strutturale che conferma il registro invece di
> smentirlo**: `InpOCTimeframe` entra nel codice in **un punto solo**
> (`ABTG_DAX_Apertura_EU.mq5` r.1508, `octf = (InpOCTimeframe==PERIOD_CURRENT) ? Period() : …`)
> e quel punto è dentro il ramo OPENCONFIRM. 👉 **Su ogni `EntryMode` diverso da 5 la manopola
> è INERTE per costruzione.**
> **(3)** Infine: `aperture_openconfirm.ps1` r.208 scrive `Period=M5` **fisso**. Il nome
> `graficoM5` vs `M15` nei CSV **non è il TF del grafico**: è il valore di `InpOCTimeframe`
> (r.197: `$tfNome = if($OCTimeframe -eq 0){"graficoM5"}else{"M$OCTimeframe"}`).
> ✅ **Sull'OPENCONFIRM vero il registro ha ragione, e i numeri sono al §7.5.**
> 📌 **Perché lo lascio scritto invece di cancellarlo**: era esattamente il tipo di errore che
> la regola del 10/09 esiste per prendere — avevo controllato che la mia risposta fosse
> *coerente* con quello che mi aspettavo (*«il TF non morde su questa famiglia»*) invece di
> provare a **romperla**. L'ho rotta aprendo il driver, ed è caduta.

---

### 5 — **A3, il lato SHORT del DAX** (riga **F**) — misurato, e la risposta è «regime»

`Walkforward_Aperture/DAX_M_direzione_{IS,OOS}.csv`, tick reali, finestre pulite:

| cella | IS PF (n) | OOS PF (n) |
|---|---:|---:|
| SHORT · range 25' | 0,82352 (153) | 🔴 0,93414 (245) |
| SHORT · range 35' | 0,84559 (152) | 1,06519 (243) |
| SHORT · range 45' | 0,77140 (153) | 🟢 **1,21230** (237) |

🔴 **Il segno si inverte fra IS e OOS su 3 celle su 3.** Per il criterio di casa (S4, *«segno
opposto su tutte le celle = REGIME, non edge»*) **questo non è un edge**: è una finestra.
**LA MISURA CHE LO SBLOCCA: una PROVA DI REGIME** (le quattro finestre toro/orso/laterale/crollo),
che sugli indici BCM **non è possibile** — lo storico parte dal 2024.09.26 e contiene **un
regime e mezzo**. 👉 **Questo candidato non è sbloccabile entro ottobre**, e il motivo è il
banco, non il motore. `prove/R205a_lato_corto_DAX_D30EUR.txt` è pronto e mai girato: **darebbe
un numero, non un verdetto.**

---

# 6️⃣ ⚖️ LE CONTRADDIZIONI FRA DOCUMENTI — **vince il CSV**

| # | il `.md` dice | il CSV dice | verdetto |
|---|---|---|---|
| **1** | `REGISTRO_TEST.md` r.21: *«A4 Nasdaq_Apertura_US … 🔴 morto»* | `R199B` OOS **PF 1,21546 · DD 7,86% @2%** · e la sedia `770260` **opera su FTMO** | 🔴 **il registro è da riscrivere** |
| **2** | `REGISTRO_TEST.md` r.379: *«L'idea di Marco (Dow>Nasdaq) NON regge»* | FASE A: Dow **+0,074** vs Nasdaq **+0,001**; a tick reali Dow OOS 1,27 vs Nasdaq 1,22 | 🔴 **l'idea di Marco REGGE** |
| **3** | `REGISTRO_TEST.md` r.2465-2468 e `prove/R138a…` r.56: *«la tabella FASE A per simbolo non l'ho trovata nel repo»* | `risultati_archivio/studio_apertura/Studio_*_RIEPILOGO.csv`, **8 file**, dal 03/08/2026 | 🟢 **buco CHIUSO** (§2) |
| **4** | Registro r.2457: *«F40EUR/E50EUR/E35EUR: non esclusi, MAI PROVATI. Casella LIBERA»* | FASE A li dà **tutti e tre negativi** (−0,056 / −0,048 / −0,048) | 🔴 **non è una casella libera**: serve la tesi nuova, ed è già scritta |
| **5** | Registro r.41: *«aperture Nasdaq … morte in real-tick. Il breakout in apertura su M5 NON ha edge sul tick vero»* | `Walkforward_Aperture/NASDAQ_B_motore`: `EntryMode=2`+volumi **IS 1,145 / OOS 1,109** | 🟡 vero per il **breakout cieco**, falso per il **retest filtrato** |
| **6** | Registro §2 (Openconfirm): *«una cella positiva su otto, cambia segno con timeframe, volumi e mercato»* | `Openconfirm/*.csv`: **1 cella positiva su 8**; `InpOCTimeframe` M5→M15 porta il DAX da **+1.032,77 a −669,00** | 🟢 **il registro ha RAGIONE** — l'avevo contestato e **mi sono corretto prima di consegnare** (§5.4) |
| **7** | Il mandato di questo dossier: *«`R138a` è girato e **nessun referto lo cita**»* | **Falso**: lo citano `report/LETTURA_BACKLOG_NOTTE_2026-09-13.md`, `report/I_QUARANTOTTO_2026-09-18.md`, `report/NOTTE_2026-09-18.md`, `report/LETTURA_BACKLOG_COMPLETA_2026-09-21.md`, `risultati_archivio/R136_R137_LA_NOTTE_… .md` e **il REGISTRO stesso a r.3300** | 🟢 **la premessa era superata**: lo dico invece di confermarla |
| **8** | Contesto fisso del registro r.6: *«Periodo backtest: 01.01.2024 → 30.06.2026 (2,5 anni)»* | Sugli indici BCM lo storico parte dal **2024.09.26**: sono **21 mesi**, non 30 | 🔴 **etichetta falsa** — e ha prodotto «IS 18 mesi» quando erano **9,15** |
| **9** | `REGISTRO_TEST.md` (tutto) | **ZERO** occorrenze di R172/R196/R197/R198/R199/R200/R201/R202 | 🔴 **13 round girati non archiviati** |

---

# 7️⃣ 🪦 I MORTI VERI — cinque punti pieni e il numero brutto scritto

Questi **non si riaprono**, ed è una buona notizia: liberano tempo prima del 1° ottobre.

### 7.1 `ABTG_DAX_Apertura_EU` su **100GBP** (FTSE 100)
- **72 passate con operazioni su 96, migliore PF 0,90423**, DD 9,58%, 283 uscite, rischio 1%,
  tick reali. **Nessuna cella sopra 0,91.** Peggiore: **0,38577 con DD 32,17%**.
- **Conferma indipendente, altro strumento, altro modello**: FASE A dà al FTSE **−0,138 R/op su
  431 rotture — il peggiore degli 8 indici**, e **−0,205 sul lato SHORT**.
> **🧪 CONTRO-ESEMPIO — l'argomento che lo salverebbe.** *«La gestione dell'uscita non è mai
> stata messa ad asse davvero: `InpTrailFixedPts` è INERTE in quel file (`InpTrailMode=1`), e il
> TF non è mai cambiato. Certificato incompleto ⇒ non è morto.»*
> ✅ **La premessa è vera** (l'ho misurata: 96 passate → **73 esiti**, e l'asse del trailing non
> mordeva). 🔴 **Ma non salva, e il motivo è aritmetico**: il candidato è negativo **su due
> misure indipendenti**, con **modelli diversi** (tick vs OHLC), **meccanismi diversi** (rottura
> cieca vs rottura+trailing), **su entrambi i lati** e su **431+283 operazioni**. Per resuscitarlo
> servirebbe una gestione che **da sola** recuperi 0,10 di PF e **0,138 R/operazione**: nessun
> asse di uscita mai misurato in casa su questa famiglia sposta tanto (il massimo misurato è
> +0,13 di PF, `R199B` su NASUSD). 👉 **Il 40x del costo non c'entra e il TF nemmeno: manca
> troppo.** Archiviato col numero.

### 7.2 `ABTG_Apertura_Marco` su **NASUSD**
- **22 celle su 22 negative**, migliore **0,84203**, peggiore 0,50216 con DD 12,27%. Tick reali.
  Assi mossi: buffer (4 valori), lato (2), EMA (2), correlazione (2), volumi (2). **454 uscite.**
- Conferma: `ablaz_1_nofilt_NASUSD.csv` → **0,91997 su 484 uscite** col motore nudo.
> **🧪 CONTRO-ESEMPIO.** *«È girato su una finestra sola: senza IS/OOS il numero non vale.»*
> 🔴 **Qui l'obiezione lavora CONTRO il candidato, non a favore.** Una finestra unica è il caso
> **più generoso** possibile (nessuna penalità di fuori campione) e il **migliore di 22 celle**
> è già una selezione a favore. Con il vento in poppa da tutte e due le parti **non arriva a
> 0,85**. 👉 Aggiungere lo split IS/OOS può solo peggiorarlo.

### 7.3 **RANGE-FADE** (`InpEntryMode=3`)
- `Walkforward_Aperture/{DAX,NASDAQ}_B_motore`: **0,68-0,84 in IS, 0,70-0,93 in OOS**, su **due
  mercati × due finestre × volumi ON/OFF**. DD fino a **19,97% (IS)** e **17,29% (OOS)**.
- `Openconfirm` (altro round, altro TF): **0,70520 DAX con DD 39,74%** · **0,74463 NAS con DD
  31,66%**, su 440 uscite.
- Storico: `CACCIA_MOTORE_APERTURE.md` — *«sul DAX 0/136 pass sopra PF 1, DD mediano 23,5%»*.
> **🧪 CONTRO-ESEMPIO.** *«Il fade è il meccanismo che la FASE A suggerisce: il 40% dei giorni
> RIENTRA, quindi fadare le rotture dovrebbe pagare.»*
> 🔴 **È esattamente l'errore che i criteri della FASE A avevano scritto PRIMA di guardare i
> numeri** (`STUDIO_APERTURE_CRITERI.md` §10.4): *«Una classe frequente NON è un edge: è una
> frequenza.»* E qui il conto è stato fatto: **su 4 round, 2 mercati, 2 TF e 2 modelli, zero
> celle positive.** Il fade in apertura è **il più misurato dei nostri morti**. 🪦

### 7.4 `ABTG_Apertura_3Ingressi` su **NASUSD** (R83/R84)
- **0 su 3 stili positivi in OOS**: STOP 0,8731 · **LIMIT/RETEST 0,6239 con DD 29,14%** ·
  MARKET 0,9785. **260 posizioni contate**, M15, tick reali.
- `R84`: **9 celle su 9 OOS negative**; la migliore (volumi OR ATR) è un **riduttore di perdita,
  mai un edge**.
> **🧪 CONTRO-ESEMPIO — e questo NON regge del tutto, quindi lo dichiaro.** *«`R83` non è tutta
> la storia: lo stesso `EntryMode=2` su NASUSD è POSITIVO nel walk-forward del core `770201`
> (IS 1,145 n=91 · OOS 1,109 n=94).»*
> ✅ **Vero, ed è già scritto nel registro a r.3489.** 👉 Quindi il verdetto onesto è: **morto è
> `ABTG_Apertura_3Ingressi` a filtri SPENTI**; **il RETEST sul Nasdaq con i filtri ACCESI non è
> morto** — ed è infatti quello che oggi opera come `770260`. **Due cose diverse con lo stesso
> nome.** Il morto qui è lo scheletro nudo, non il meccanismo.

### 7.5 **OPENCONFIRM** (`InpEntryMode = 5`) — *«la candela deve APRIRE oltre il livello»*
Le **otto celle**, tick reali, M5, gestione buona (TP 1,5R + trailing candela M5)
(`risultati_archivio/Openconfirm/MOTORI_INGRESSO.md` + i quattro CSV):

| mercato | `InpOCTimeframe` | volumi | profitto | PF | n `[uscite]` |
|---|---|---|---:|---:|---:|
| DAX | M5 (grafico) | ON | 🟢 **+1.032,77** | **1,086** | 429 |
| DAX | M5 | off | −1.377,66 | 0,890 | 440 |
| DAX | M15 | ON | −669,00 | 0,947 | 438 |
| DAX | M15 | off | +71,31 | 1,006 | 439 |
| Nasdaq | M5 | ON | −1.552,28 | 0,857 | 332 |
| Nasdaq | M5 | off | 🔴 **−2.944,39** | **0,735** | 444 |
| Nasdaq | M15 | ON | −450,16 | 0,955 | 403 |
| Nasdaq | M15 | off | −1.387,92 | 0,868 | 431 |

**Una cella positiva su otto**, e il segno si ribalta con **tutte e tre** le manopole toccate:
TF (+1.033 → −669), volumi (+1.033 → −1.378), mercato (+1.033 → −1.552).
Controprova su finestre separate: `Walkforward_Aperture/NASDAQ_B_motore` dà `EntryMode=5`+volumi
**IS 1,81587 (n=108) → OOS 0,69553 (n=108)**, cioè **un crollo a campione costante**.
> **🧪 CONTRO-ESEMPIO — l'argomento che lo salverebbe.** *«Il DAX su M5 fa +1.032,77 con PF
> 1,086 su 429 operazioni: il campione è pieno, non è rumore.»*
> 🔴 **Il campione è pieno e il numero è vero — ed è comunque una cella fortunata, perché il
> punto 5 del certificato in questo caso È STATO CHIUSO, e l'ha ucciso.** È l'unico meccanismo
> della famiglia dove il TF è stato davvero confrontato, e il confronto ribalta il segno.
> Quando una cella è positiva **solo** al suo valore di TF, **solo** col filtro acceso e
> **solo** su un mercato, non è un motore: è il massimo di una griglia da otto. 🪦 **Chiuso.**

---

# 8️⃣ 🕳️ NON COPERTO — quello che non ho potuto verificare, e perché

1. 🔴 **I CSV originali di A1/A2/A4 (26/07) NON SONO NEL REPO.** `ini/valid_DAX_Apertura.ini`,
   `valid_DAX_Apertura_LONG/SHORT.ini`, `valid_Nasdaq_Apertura.ini` esistono; i loro risultati
   no. 👉 **I numeri «PF 1,03 / 1,49 / 0,91» del registro NON sono verificabili contro un CSV.**
   Li ho riportati come **citazione del registro**, mai come misura. Quello che ho potuto fare
   è misurare **le stesse domande** su round successivi con finestre pulite.
2. ⚪ **`A2` (il «KEEPER», PF 1,49 / DD 3,8% / 314 tr) non l'ho potuto rileggere.** Stessa
   ragione. Nota di merito: la sua `.ini` gira `InpRangeMinutes` con `InpRangeMode=0`, quindi
   lì la manopola **mordeva** (a differenza dei file `doc_*`).
3. ⚪ **`n` in POSIZIONI** è contato davvero solo dove esiste un per-trade
   (`abtg_trades_*.csv`): `770101` (193 OOS), `770202` (96 OOS), `R83` (245-260). Altrove ho
   scritto `[uscite]` e **non l'ho confrontato con 150**.
4. ⚪ **`Equity Drawdown Absolute`** (il campo che FTMO misura davvero) **non è nei CSV**: uso
   `Equity DD %`, che il referto di oggi (`report/IL_MURO_MISURATO_2026-09-22.md`) dimostra
   essere un **limite superiore rigoroso**. Quindi i miei DD sono **conservativi**, mai
   ottimisti.
5. ⚪ **Spread di `F40EUR`, `E50EUR`, `E35EUR`, `SPXUSD`, `100GBP`: [NON MISURATO]**.
   `risultati_archivio/spread_flotta/` ha **3 file su 13 simboli** (D30EUR, NASUSD, U30USD).
   👉 **R5 su quei simboli non è né verde né rosso**, ed è per questo che nessuna sedia europea
   nuova può accendersi prima di quel numero (costo: zero passate di tester, `ABTG_SpreadOrario`).
6. ⚪ **Prova di REGIME: assente per tutta la famiglia**, e non colmabile: lo storico BCM sugli
   indici parte dal **2024.09.26** — 21 mesi, un regime e mezzo. Dichiarato, non nascosto.
7. ⚪ **Sovrapposizione dei giorni operativi fra `770101` (D30EUR) e un eventuale gemello europeo
   (F40EUR): [NON MISURATA]**. Aprono **allo stesso minuto**: la frequenza sommata sarebbe
   doppia e la diversificazione **zero**. Strumenti in casa (`sovrapposizione_sedie.py`,
   `chi_va_con_chi.py`), zero passate di tester.
8. ⚪ **Non ho toccato** Live5m / DAX_M3 / ORB_Fibo / Londra_ORB / Nightly / MaxMinNotte /
   CostToCost / SupRev / Supertrend / FiboH4 / LiquiditySweep / cross: sono di altri agenti.
   Dove li cito (es. `L2` Nasdaq_Live5m) è solo per **non attribuirgli** numeri della mia
   famiglia.

---

# 9️⃣ 📌 LE QUATTRO COSE DA FARE, in ordine di costo — **proposte, non decisioni**

| # | cosa | costo MISURATO | chi decide |
|---|---|---|---|
| 1 | **Riscrivere le righe 21, 375-379 e 2465-2468 di `REGISTRO_TEST.md`** e archiviarci R172/R196-R202 | **0 minuti macchina** | — (è archivio) |
| 2 | Girare **`R133a`** (`InpLevelTF` × 7 TF su NASUSD) e **`R140c`** (`@PERIODO M15` su `770101`): i due file già scritti e già gatati | **18 passate = 6,0 min** | 🖊️ Claudio (riga di lancio) |
| 3 | Scrivere e girare i **quattro file `@PERIODO`** mancanti (Dow M15/M30, Nasdaq M15/M30) | **16 passate = 5,4 min** | 🖊️ Claudio |
| 4 | `InpFilterTF` e `InpLevelTF` ad asse sul **Dow** — le due manopole di TF che sul Dow valgono **+0,21 di PF** e non sono mai state girate | **22 passate = 7,4 min** | 🖊️ Claudio |

> 🔴 **E la cosa che NON propongo**: nessuna griglia nuova sui **parametri d'ingresso** di FTSE,
> CAC, Marco-Nasdaq o RANGE-FADE. Sono i motori dichiarati senza edge del §7: lì una griglia più
> fitta trova **solo picchi di rumore** (regola del 19/08), e la cella «verde per caso» è quella
> che brucia la challenge.

---

## 🧾 Fonti primarie usate (tutte CSV, salvo dove indicato)

`risultati_archivio/studio_apertura/Studio_{D30EUR,NASUSD,U30USD,SPXUSD,F40EUR,E50EUR,E35EUR,100GBP}_RIEPILOGO.csv` ·
`risultati_archivio/Dow_Apertura/dow_{walkforward_IS,walkforward_OOS,motore,robustezza,distanze,trailing,trailing2}.csv` ·
`risultati_archivio/Walkforward_Aperture/{DAX,NASDAQ}_{A_geometria,B_motore,C_slippage,D_retest,E_retest_fill,F_gestione,G_rischio,H_drawdown,I_trailing,L_rangemode,M_direzione}_{IS,OOS,FULL}.csv` ·
`risultati_archivio/Apertura_nuovi_indici/valid_Apertura_{U30USD_Dow,100GBP_FTSE}.csv` ·
`risultati_archivio/{DAX_Apertura,Nasdaq_Apertura}/apert_*.csv` ·
`risultati_archivio/{Openconfirm,Aperture_Ingresso,Aperture_Trailing,Marco_Emiliano}/*.csv` ·
`risultati_archivio/{r83_csv,r84_csv,r118_csv}/*.csv` ·
`risultati_prove/{R172D,R196A,R197A,R197B,R198,R199A,R199B,R200A,R200C,R200E,R201A,R202A,R202B}/*.csv` ·
`risultati_prove/dal_vps/ABTG_DAX_Apertura_EU/*_r13[78]*.csv` ·
`risultati_archivio/misura_tick/REFERTO_MISURA_TICK_{D30EUR,NASUSD,U30USD}.txt` ·
`risultati_archivio/spread_flotta/spread_orario_{D30EUR,NASUSD,U30USD}.csv` ·
sorgenti `mql5/Experts/ABTG_{DAX_Apertura_EU,Nasdaq_Apertura_US,Dow_Apertura_US}.mq5` ·
file prova `backtest_pipeline/prove/{R133a_livelliTF_NASUSD,R140c_tfingresso_M15_770101_D30EUR,R138a_gemello_F40EUR_770101}.txt` ·
driver `backtest_pipeline/{studio_apertura,walkforward_aperture,dow_apertura,conferma_apertura_us,aperture_*,rilancia_apertura_nuovi_indici}.ps1` (anche alle revisioni storiche, via `git show`).
