# 🐻 CENSIMENTO DEL LATO SHORT — tutto il repo, motore per motore (09/09/2026)

_Richiesta diretta di Claudio, 09/09/2026: **"dobbiamo controllare tutti gli
expert lato SHORT"**. Nasce da un fatto: oggi il DAX ha fatto **−1,08%** e
nessuna sedia ha shortato._

> 🧾 **Questo e' un censimento DI CARTA. Zero minuti di macchina, zero backtest,
> zero file toccati.** Nessun EA, preset, parametro o forward e' stato
> modificato. Dove un numero non esiste c'e' scritto `[MAI MISURATO]`, non una
> stima. Fonti: 111 sorgenti `mql5/Experts/*.mq5` · 106 preset `mql5/Presets/`
> · ~630 file prova · **60.008 righe di CSV di risultato che portano la colonna
> `InpAllowShort`** · `data/statements/trades_auto.csv` + `trades_100k.csv`
> (30/03→08/09/2026) · referti R40/R42/R43/R52/R54/R65/R107/R109/R110/R112/R115.

---

## 🔴 IL VINCOLO DI REALTA' — VA LETTO PRIMA DI OGNI TABELLA

**Sugli INDICI, un round short su un ORSO NON E' POSSIBILE con i dati BCM.
Non e' un tetto di barre e non e' il nostro disco: il broker NON CE L'HA.**

La sonda del 17/08 (`backtest_pipeline/risultati_archivio/REFERTO_SONDA_STORICO_17-08.md`
§3) ha misurato **tutti e 59 i simboli**. Gli indici tornano con stato
**`COMPLETO`** — la parola che chiude la questione — e prima data **2024.09.26**:

| simbolo | prima data | stato |
|---|---|---|
| `D30EUR` `U30USD` `NASUSD` `100GBP` `200AUD` `225JPY` `E35EUR` `E50EUR` `F40EUR` `SPXUSD` `UKOIL` `USOIL` | **2024.09.26** | **`COMPLETO`** |

👉 **21 mesi, e dentro c'e' UN SOLO REGIME: un toro.** Qualunque verdetto short
sugli indici nasce con l'etichetta **"per questa epoca"**, mai "per sempre".
E i **8 simboli `_EXT`** importati (dal 2018) sono **tutti forex e oro:
nessun indice** (stessa sonda, §3 nota 📌).

**Su FOREX e METALLI, invece, l'orso c'e' — ed e' profondo:**

| simbolo | prima data | anni | cosa ci sta dentro |
|---|---|---:|---|
| **USDJPY** | **1971.01.03** | 55 | tutto |
| **EURUSD** | 1971.01.03 | 55 | tutto |
| **GBPUSD** | **1993.05.11** | 33 | 2008, 2016 Brexit, 2020, 2022 |
| EURJPY | 1993.04.26 | 33 | idem |
| **XAUUSD** | **2004.06.11** | 22 | 2008, 2013 crollo oro, 2020, 2022 |
| **XAGUSD** | **2008.11.07** | 17,6 | 2011 top, 2020 | 

> ### 🎯 **LA CONSEGUENZA OPERATIVA, e va detta forte**
> **I round short sensati OGGI si mandano su FOREX e METALLI, non sugli indici.**
> Sul forex/oro un rosso short e' un **verdetto**; sugli indici e' solo
> **"non in questo toro"**. Chi manda un round short sul DAX 2024-2026 sta
> comprando un'informazione che sa gia' di non poter usare per bocciare.
> ⚠️ Attenzione al tetto delle **100.000 barre** (stessa sonda §3-bis): su H1
> forex sono ~16 anni per corsa, quindi le finestre lunghe vanno **spezzate in
> tranche e dichiarate**. E resta `[INCERTO]` se il tetto valga anche nello
> Strategy Tester — la sonda lo dichiara aperto, e nessuno l'ha ancora chiuso.

---

## 📌 COSA AGGIUNGE QUESTO REFERTO — e cosa NON rifa'

I due censimenti dei lati esistono gia' e **restano validi**. Li ho letti e
**non li ho rifatti**; qui sotto c'e' solo il delta.

| referto | percorso vero | cosa diceva | cosa aggiungo io |
|---|---|---|---|
| **R52 — CENSIMENTO DEI LATI** (14/08) | `backtest_pipeline/prove/R52_CENSIMENTO_LATI.md` _(NON in `report/`)_ | 32 celle vive: lato VINCOLATO vs SCELTO; 11 candidati | ⬆️ Estende a **tutti i 111 sorgenti** (R52 ne guardava ~70) e aggiunge la colonna che li' non c'era: **le ASIMMETRIE DENTRO IL CODICE** fra ramo long e ramo short (§ TABELLA A.3) |
| **CENSIMENTO LATI SHORT INDICI** (25/08) | `backtest_pipeline/risultati_archivio/CENSIMENTO_LATI_SHORT_2026-08-25.md` _(NON in `report/`)_ | mappa degli short bocciati sugli indici + 5 proposte | ⬆️ **Tre delle cinque proposte sono state ESEGUITE e hanno numeri** (R110 il 26/08, R112, PASSO0 VwapRevert il 03/09): quel referto e' invecchiato di 15 giorni e qui viene aggiornato (§ TABELLA B.2) |
| **PERCHE' NESSUNO HA SHORTATO IL DAX** (oggi) | `report/PERCHE_NESSUNO_HA_SHORTATO_IL_DAX_2026-09-09.md` | risposta all'episodio di oggi sul DAX | ⬆️ Quello risponde **su un simbolo e un giorno**; questo e' il **censimento su tutto il parco**. E ne **verifica** un'affermazione (§ NOTA DI RICONCILIAZIONE in fondo) |

🆕 **Cosa e' davvero nuovo qui:** l'audit del **codice** (nessuno l'aveva fatto),
il conteggio **su 60.008 righe di CSV** di quali coppie hanno mai avuto una
corsa **solo-short**, e la fotografia del **campo** sedia per sedia.

---

# 📋 TABELLA A — CAPACITA': cosa il codice PUO' fare

## A.1 — I NUMERI DI TESTA

| | | |
|---|---:|---|
| sorgenti `.mq5` totali | **111** | `mql5/Experts/*.mq5` |
| **con un input di lato** (`InpAllowLong/Short`, `InpLato`, `InpSide`, `InpTradeDirection`, `InpDirectionMode`) | **80** | 72% |
| senza input di lato | **31** | di cui **6 utility che non tradano** e **25 motori** |
| **motori senza input che aprono comunque ENTRAMBI i versi** | **25 su 25** | ✅ verificato riga per riga |

> ✅ **Conferma della conclusione di R52, ri-misurata su 111 file invece che 70:**
> **NON esiste nel parco un EA che apra un solo verso per costruzione.** I 25
> senza input piazzano entrambi i versi (ternario o coppia stop/limit): per loro
> il lato lo decide **il mercato**, non un interruttore. Il lato short **non
> manca mai come idea**: quando manca, e' stato **spento**.

## A.2 — I DEFAULT, LETTI NEL SORGENTE (file e riga)

### 🔴 Short SPENTO nel default del sorgente — **4 file**

| file : riga | riga di codice |
|---|---|
| `mql5/Experts/ABTG_DAX_Apertura_EU_Ottimizzato.mq5:185` | `input bool InpAllowShort = false; // (false = SOLO LONG)` |
| `mql5/Experts/ABTG_Nasdaq_Apertura_US_Ottimizzato.mq5:186` | `input bool InpAllowShort = false; // (false = SOLO LONG)` |
| `mql5/Experts/ABTG_SondaOrologio.mq5:179` | `input bool InpAllowShort = false; // esattamente UNO dei due dev'essere acceso` — **per disegno**, e' una sonda a lati separati |
| `mql5/Experts/Gold_Ichimoku_TK_ATR_EA.mq5:92` | `input ENUM_TRADE_DIRECTION InpTradeDirection = DIR_LONG_ONLY;` — EA esterno, **sedia fantasma** (`report/CENSIMENTO_CONTRATTI.md` r.234) |

### 🐻 Long SPENTO nel default (short-only) — **2 file**

| file : riga | riga di codice |
|---|---|
| `mql5/Experts/ABTG_MaxMinNotte_DAX_Short_Ottimizzato.mq5:71` | `input bool InpAllowLong = false; // OTT: solo SHORT` |
| `mql5/Experts/ABTG_MaxMinNotte_DAX_Short_Ottimizzato_MFE.mq5:91` | idem |

### ✅ Tutti gli altri 74 EA con input di lato hanno **default `true`/`true`**
Esempi verificati: `ABTG_EMA200.mq5:58-59` · `ABTG_PTE.mq5:68-69` ·
`ABTG_SupertrendReversal.mq5:58-59` · `ABTG_SuperWave.mq5:59-60` ·
`ABTG_PunteLarry.mq5:165-166` · `ABTG_CostToCost.mq5:169-170` ·
`ABTG_DAX_Apertura_EU.mq5:271-272` · `ABTG_Dow_Apertura_US.mq5:240-241`.
Gli EA con enum: `DAX_MASTER_PROP.mq5:321` = `DIR_BOTH` ·
`EasyTrend_EURUSD.mq5:84` = `DIR_BOTH` · `Gold_Scalper_TK_BB_BE_EA.mq5:134` =
`SDIR_BOTH`. Quelli con intero: `ABTG_Relativo.mq5:375` · `ABTG_SondaRelativo.mq5:527`
· `ABTG_SondaGapCash.mq5:223` = `InpLato=0` (entrambi) ·
`ABTG_CRT_TurtleSoup.mq5:91` · `ABTG_DaxReEntry.mq5:82` ·
`ABTG_DaxValueArea.mq5:129` · `ABTG_OpeningReversalB.mq5:141` = `InpSide=2` (entrambi).

### 🚨 MA IL DEFAULT DEL SORGENTE NON E' QUELLO CHE GIRA — comandano i PRESET

**Il numero che conta e' questo: 14 preset spengono lo SHORT, 3 spengono il LONG.**

| preset | lato spento |
|---|---|
| 🔴 `mql5/Presets/conto_reale/ABTG_DAX_Apertura_EU_770101_REALE.set` | `InpAllowShort=false` |
| 🔴 `mql5/Presets/conto_reale/ABTG_ORB_Ottimizzato_770611_REALE.set` | `InpAllowShort=false` |
| `mql5/Presets/sedie_piccolo/recupero2/sedia_ABTG_DAX_Apertura_EU_770101.set` | `InpAllowShort=false` |
| `mql5/Presets/sedie_piccolo/recupero2/sedia_ABTG_Dow_Apertura_US_770202.set` | `InpAllowShort=false` |
| `mql5/Presets/sedie_piccolo/recupero2/sedia_ABTG_ORB_Ottimizzato_770611.set` | `InpAllowShort=false` |
| `mql5/Presets/ABTG_EMA200_FW_{200AUD,AUDJPY,GBPJPY,SPXUSD,XAUUSD}_H4.set` | `InpAllowShort=false` (×5) |
| `mql5/Presets/ABTG_SupertrendReversal_FW_{Argento,DAX,Nikkei,Oro}.set` | `InpAllowShort=false` (×4) |
| 🐻 `mql5/Presets/ABTG_EMA200_FW_GBPUSD_H4.set` | `InpAllowLong=false` (short-only) |
| 🐻 `mql5/Presets/ABTG_GoldenCross_FW_NZDUSD_H4.set` | `InpAllowLong=false` (short-only) |
| 🐻 `mql5/Presets/sedie_piccolo/recupero2/sedia_ABTG_MaxMinNotte_DAX_Short_Ottimizzato_770411.set` | `InpAllowLong=false` (short-only) |

> ### 🔴 **LE DUE SEDIE DEL CONTO REALE 10105439 SONO ENTRAMBE LONG-ONLY.**
> `ABTG_DAX_Apertura_EU` (770101, D30EUR M5) e `ABTG_ORB_Ottimizzato`
> (770611, U30USD M5) — le uniche due sul conto che paga
> (`report/CENSIMENTO_CONTRATTI.md` §2) — hanno **`InpAllowShort=false` scritto
> nel preset**. **Sul conto vero, oggi, il progetto e' al 100% long.**
> ⚠️ Per **entrambe** la scelta e' MISURATA, non un capriccio (R107 DAX short
> PF 0,957 n 257 · R54 ORB short PF 0,520 DD 26,37%): non e' un difetto da
> correggere, e' un **fatto da sapere** quando parte una challenge.

## A.3 — 🔬 ASIMMETRIE NEL CODICE — la domanda piu' preziosa

**Metodo, dichiarato perche' il risultato valga:** ho estratto da tutti i 111
sorgenti ogni decisione a due rami — i ternari `isLong ? A : B` (e
`isBuy`/`up`/`type==POSITION_TYPE_BUY`) — e ho confrontato **A specchiato**
con **B**, con specchiatura di token (`long↔short`, `alto↔basso`, `ask↔bid`,
`Max↔Min`, `iHighest↔iLowest`…) **e** di operatori (`>↔<`, `+↔−`), piu' la
forma canonica delle distanze (`X−Y` ↔ `Y−X`). Poi ho letto a mano il residuo.

### 📊 L'ESITO

| classe | quante | |
|---|---:|---|
| decisioni a due rami esaminate | **571** | ternari long/short in 111 file |
| ✅ **specchiate al centesimo** | **510** | 89% |
| 🔍 residuo letto a mano | **61** | 11% |
| 🟢 di cui **falsi positivi spiegati** | **61** | vedi sotto |
| 🔴 **ASIMMETRIE VERE CHE FALSANO I NUMERI SHORT** | **0** | — |

### 🎉 IL RISULTATO E' UNA BUONA NOTIZIA, e va detta: **il parco e' pulito.**

Nessun motore promette simmetria e poi calcola lo stop in modo diverso sui due
lati. Esempio, e vale da modello — `mql5/Experts/ABTG_EMA200.mq5:219-221`:
```
double o1 = isLong ? NormalizePrice(ema+InpOrder1Atr*atr) : NormalizePrice(ema-InpOrder1Atr*atr);
double o2 = isLong ? NormalizePrice(ema-InpOrder2Atr*atr) : NormalizePrice(ema+InpOrder2Atr*atr);
double sl = isLong ? NormalizePrice(o2-InpSLatr*atr)      : NormalizePrice(o2+InpSLatr*atr);
```
Anche la famiglia APERTURE, che e' **codice duplicato** e non un ternario, e'
specchiata riga per riga: `ABTG_DAX_Apertura_EU.mq5:1057-1103` (breakout BUY
vs SELL: `entry`, `sl`, `dist`, `skip`, `lot`, `tp` tutti simmetrici),
`:1146-1178` (fade), `:1481-1544` (retest). E il filtro di direzione
`TrendBias()` combina i bias **senza preferire un verso**
(`CombineBias`, `ABTG_DAX_Apertura_EU.mq5` §TrendBias).

### 🟢 I 61 RESIDUI, spiegati uno per classe (nessuno e' un difetto)

**Classe 1 — la guardia `sl>0`, e qui il parco e' DISCIPLINATO 15 su 15.**
`PositionGetDouble(POSITION_SL)` vale **0.0** quando lo stop non c'e'. Su un
prezzo positivo `0.0 >= openP` e' **falso** (il long e' immune) ma
`0.0 <= openP` e' **vero**: senza protezione, uno short **senza stop** verrebbe
giudicato "gia' in pari" e **il breakeven verrebbe saltato solo agli short**.
E' esattamente il difetto che stavo cercando. **Non c'e'**: tutti e 15 gli EA
che fanno quel test sono coperti, con due tecniche diverse —

| copertura | EA (file : riga della riga `beDone`) |
|---|---|
| ✅ guardia **inline** sul ramo short `&& sl>0` | `ABTG_EMA200.mq5:270` · `ABTG_EMA200_Ottimizzato.mq5:270` · `ABTG_PTE.mq5:399` · `ABTG_PTE_Ottimizzato.mq5:455` · `ABTG_SuperWave.mq5:315` · `ABTG_SupertrendReversal.mq5:335` · `ABTG_WOL.mq5:304` · `ABTG_SupRev_NAS_H1_Ottimizzato.mq5:322` (e i 5 gemelli SupRev :322) · `ABTG_FiboH4_Multi.mq5:479` · `ABTG_FiboH4_Corso.mq5:798` · `ABTG_BreakingBand.mq5:1447` · `ABTG_AltaVelocita.mq5:1192` |
| ✅ filtro **a monte** `if(sl<=0) continue;` | `ABTG_AtrExhaustVol.mq5:713` · `ABTG_VwapRevert.mq5:1112` · `ABTG_CrossEma.mq5:486` · `ABTG_CrossEmaApertura.mq5:709` · `ABTG_FvgRetest.mq5:1017` · `ABTG_LiquiditySweep.mq5:774` |

📌 Idem per il trailing: `ABTG_ORB_Ottimizzato.mq5:837` (long, `newSL>sl`)
contro `:857` (short, `(newSL<sl||sl==0)`). **Testo diverso, comportamento
identico**: il `||sl==0` serve solo allo short, per la stessa ragione.

**Classe 2 — trappole di NOME, non di logica.**
`ABTG_AltaVelocita.mq5:1213` usa `gStUp[1]` su **tutti e due** i rami e sembra
un errore madornale. Non lo e': `gStUp` e' il Supertrend del **TF superiore**
(`:436 SupertrendSeries(gTfUp,...)`), non la "banda alta". La linea e' una
sola e il buffer va sotto per il long, sopra per lo short. ✅ corretto.

**Classe 3 — sinonimi speculari che il confronto automatico non conosce.**
`sweepHigh↔sweepLow`, `boxHigh↔boxLow`, `vah↔val`, `gLastTop↔gLastBot`,
`gDivBullDetect↔gDivBearDetect`, `alto↔basso`, `bordoAlto↔bordoBasso`,
`swingHigh↔swingLow`. Tutti verificati a mano: **speculari**.

**Classe 4 — soglie negate correttamente.**
`ABTG_BreakingBand.mq5:1152` `slope > soglia` / `slope < −soglia`; `:1203`
`slope >= −tol` / `slope <= tol`. ✅ e' la specchiatura giusta.

### 🟠 QUELLO CHE HO TROVATO DAVVERO — non bug, ma **quattro cose da sapere**

**1. 🔴 LA REGOLA DELLO SLOT: `n(long) + n(short) ≠ n(entrambi)`.**
Quattro EA valutano il long **per primo** e fanno `return`, quindi con un solo
slot disponibile **il long consuma il posto dello short**:

| file : riga | codice |
|---|---|
| `ABTG_VwapRevert.mq5:753-756` | `if(InpAllowLong && bullFronte){ PiazzaOrdine(true,s1); return; }` / poi lo short |
| `ABTG_OutOfNoise.mq5:559-562` | idem, commento nel file: `// una sola decisione per barra` |
| `ABTG_AllineaLondra.mq5:904-905` | `if(InpAllowLong && AllineaLong_Calc(...)) return(+1);` |
| `ABTG_FiboH4_Multi.mq5:412-415` | `if(InpAllowLong && BullEngulf(...)){ ...; return; }` |

E lo stesso vale per l'`InpOneTradePerDay` delle APERTURE
(`ABTG_DAX_Apertura_EU.mq5:257`). **E' MISURATO, non dedotto**, in due posti
indipendenti: FASE M sulle aperture (**256 + 243 = 316 trade, non 499**, citato
in `R52_CENSIMENTO_LATI.md` §2) e il PASSO 0 di VwapRevert
(`risultati_archivio/vwaprevert/CORSA_2026-09-03_1711_FALSIFICATO.txt`, avvertenza 1:
**18+41 = 59 IS, ma il nudo ne fa 58**; **44+66 = 110 OOS, ma il nudo ne fa 107**).
> 🎯 **Conseguenza per chi legge i numeri:** in una cella "entrambi i lati" il
> lato short e' **sistematicamente sotto-rappresentato**. Un lato si giudica
> **solo** con una corsa `solo-short` dedicata. Le celle "entrambi" non lo
> misurano — lo diluiscono.

**2. 🟠 Spegnere lo short spegne anche il REVERSE (aperture).**
`ABTG_DAX_Apertura_EU.mq5:481` — `if(InpAllowReverse && !(InpAllowLong && InpAllowShort))`
avvisa che con **un solo lato** il secondo ciclo "quasi mai" parte. Le sedie
770101 (reale e piccolo) girano `InpAllowShort=false`: **il reverse, li', e'
gia' morto** e non e' un'opzione disponibile.

**3. 🟠 Filtri tarati SUL LONG che restano addosso allo short.**
`ABTG_DAX_Apertura_EU_Ottimizzato.mq5:200` — `input bool InpUseSupertrend = false;`
con il commento **`// OTT: Supertrend OFF (la versione LONG-only rende di piu')`**.
👉 Chi misura lo short su quella build eredita un filtro **scelto per il long**.
Non e' un bug del codice: e' un'**asimmetria del contratto**, e va dichiarata
accanto a qualunque numero short prodotto con quel file.

**4. 🟡 Soglie OB/OS indipendenti = asimmetria POSSIBILE per parametro.**
`ABTG_AltaVelocita.mq5:143-144` (`InpWprOB=-20` / `InpWprOS=-80`) ·
`ABTG_PTE.mq5:77-78` (idem) · `ABTG_Apertura_Marco.mq5:277-278`
(`InpRsiOB=70` / `InpRsiOS=30`) · `ABTG_BreakoutCorso.mq5:110-111`.
✅ **I default sono tutti simmetrici attorno al centro naturale.** Ma sono due
manopole separate: **una griglia puo' romperne la simmetria senza che nessuno
se ne accorga.** Da guardare quando si legge un CSV di ottimizzazione.

---

# 📐 TABELLA B — MISURA: il lato short ha mai avuto un numero SUO?

## B.1 — IL CONTEGGIO SU TUTTO L'ARCHIVIO

Ho letto **60.008 righe di CSV** che portano la colonna `InpAllowShort`
(`backtest_pipeline/**/*.csv`) e le ho raggruppate per coppia (EA, simbolo).

| | |
|---|---:|
| righe di risultato con la colonna di lato | **60.008** |
| di cui `InpAllowShort=1` | 32.768 |
| di cui `InpAllowShort=0` | 27.240 |
| coppie (EA, simbolo) presenti | **146** |
| 🟢 **con almeno una corsa `solo-short` (`AllowLong=0, AllowShort=1`)** | **20** |
| 🔴 **senza NESSUNA corsa solo-short** | **126** |

**Le 20 coppie con un numero short PROPRIO agli atti:**
`ABTG_CostToCost` CHFJPY·EURJPY·GBPCAD·XAGUSD · `ABTG_DAX_Apertura_EU` D30EUR ·
`ABTG_Dow_Apertura_US` U30USD · `ABTG_EMA200` U30USD · `ABTG_EasyTrend`
AUDJPY·CHFJPY·EURGBP·GBPUSD · `ABTG_GoldenCross` NZDUSD · `ABTG_GoldenCross_V1`
NZDUSD · `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` D30EUR ·
`ABTG_Nasdaq_Apertura_US` NASUSD · `ABTG_ORB_Ottimizzato` U30USD ·
`ABTG_PTE` GBPUSD·USDJPY · `ABTG_PunteLarry` GBPUSD · `ABTG_SondaOrologio` D30EUR.

## B.2 — I NUMERI SHORT CHE ESISTONO — round per round

_Finestra comune 2024.09.26→2026.06.30, split 40/60, salvo dove indicato.
**Tutti gli indici: UN SOLO REGIME (toro).**_

### 🥇 R110 (26/08/2026, **tick reali**) — i lati dei simmetrici vivi
Fonte: `backtest_pipeline/risultati_archivio/R110_REFERTO.md` (tabella madre).
⚠️ Solo `R110_CSV_EMADOW` e' archiviato nel repo; gli altri tre hanno il
referto ma **non il CSV**.

| EA (sedia) | Sym | cella | n OOS | PF OOS | DD OOS | PF IS | cancelli |
|---|---|---|---:|---:|---:|---:|---|
| `ABTG_EMA200` 771531 | U30USD | **short** | **302** | **1,891** | **2,66%** | 1,232 | ✅ G1+G2+**G4** (n≥150) |
| `ABTG_EMA200` 771531 | U30USD | long | 241 | 1,241 | 8,90% | 1,16 | ✅ |
| `ABTG_SupRev_NAS_H1_Ott` 970913 | NASUSD | **short** | 34 | 1,870 | 0,93% | — | 🟠 merito SOSPESO (n 34) |
| `ABTG_SuperWave_DOW_H1_Ott` 770511 | U30USD | **short** | 84 | **0,429** | 7,53% | 1,446 | 🔴 fallisce G2 |
| `ABTG_SupRev_DAX_H4_Ott` 970912 | D30EUR | **short** | **29** | 1,290 | 3,60% | — | ⚪ **NON MISURABILE** (n<30) |

> 🥇 **`EMA200` Dow short e' la prima cella "piena" dei lati del progetto**:
> PF 1,891 su **302 operazioni**, IS **e** OOS verdi, DD **2,66% contro 7,83%**
> della sedia intera. **Su questa finestra quasi tutto l'edge dell'EMA200 Dow
> sta nel lato CORTO, con un quinto del drawdown.** E' l'unico short del parco
> che guadagna **anche in un'epoca che sale**.
> 🔴 **Ma la sedia 771531 NON si tocca**: R110 §G5 dice che il cambio di
> contratto e' **un round successivo con la sua firma**, e R112 ha gia' misurato
> i dial 1/2/3% contro il cancello di portafoglio — **nessuno passa**
> (`report/CORSIA_DEMO_CANDIDATI.md` r.318).

### R112 (26/08) — i dial dello short EMA200 Dow
`risultati_archivio/R112_CORSA_20260826` — `01_short_r1`: PF OOS **1,891** n 302
DD **2,66%** · `02_short_r2`: PF **1,886** n 315 DD **5,30%** · `03_short_r3`:
PF **1,873** n 324 DD **7,92%**. _(riprodotto al centesimo su R110: il PF IS
1,23153 coincide cifra per cifra.)_

### R107 (25/08, tick reali) — le APERTURE, lato short
`backtest_pipeline/risultati_archivio/R107_REFERTO.md` r.26-33.

| FAM | Sym | IS PF (n) | OOS PF (n) | OOS DD | verdetto |
|---|---|---|---|---:|---|
| DOW retest | U30USD | 1,511 (73) | **0,840** (73) | 8,62% | 🔴 rosso — riproduce R54 al millesimo |
| **DAX retest** | D30EUR | **0,965** (138) | **0,957** (**257**) | 12,31% | ⛔ **rosso in ENTRAMBE, discesa feb-apr 2025 COMPRESA** — l'unico short bocciato con n≥150 |
| NAS retest | NASUSD | **3,220** (58) | **0,460** (59) | 11,34% | 🔴 l'edge vive nelle discese: l'OOS non ne ha |

### R115 (29/08) — la riprova a due lati sulle aperture
`risultati_archivio/REFERTO_R115_2026-08-29.md` r.12-20: `DOW_01_short` PF OOS
**0,844** n 73 · `NAS_01_short` PF OOS **0,517** n 96 DD 12,53% ·
`DAX_01_bilat` (due lati) PF **1,170** n 332 contro `DAX_00_vivo` (solo long)
PF **1,406** n 270 → **accendere lo short sul DAX PEGGIORA la cella viva**.

### R109 (25/08) — ATR Exhaustion, i due lati separati
`risultati_archivio/R109_REFERTO.md` r.25-32 — **campioni grossi, tutti rossi**:

| Sym | lato | n | PF | DD |
|---|---|---:|---:|---:|
| D30EUR | SHORT | 927 | 0,831 | **67,8%** |
| U30USD | SHORT | 923 | 0,917 | **57,2%** (pegg. giornata −9,72%) |
| NASUSD | SHORT | 743 | 0,990 | 44,1% |

_(i long sono rossi uguale: 0,911 / 0,978 / 0,885. Motore senza edge su
entrambi i lati — **non e' un problema di lato**.)_

### PASSO 0 VWAP REVERT (03/09) — 🆕 **la proposta n.5 del 25/08 e' stata FATTA**
`risultati_archivio/vwaprevert/CORSA_2026-09-03_1711_FALSIFICATO.txt`, D30EUR
M15, tick reali: **`02_short` n IS 41 · n OOS 66 · PF IS 0,87 · PF OOS 0,64 ·
DD OOS 21,60%**. `01_long`: PF OOS 0,80 (n 44). `00_nudo`: PF OOS 0,73 (n 107).
🔴 **E il cancello di costo S0 NON PASSA su nessuna delle 4 celle** (rapporto
−0,11 / −0,21 / −0,14 / −0,21 contro il 2,5 richiesto).
👉 Il referto del 25/08 dava questo candidato come *"EA da scrivere, 5-7 ore"*:
**l'EA esiste, il round e' stato fatto, e il numero e' rosso su entrambi i lati.**

### SHORTGATE (30/08) — l'unico short NUOVO messo in campo
`risultati_archivio/REFERTO_SHORTGATE_2026-08-30.md`: breakdown short gated H4,
**OHLC** n 93 PF **1,84** DD 2,07% — e per regime: **CROLLO 2020 +2.037 su 8
trade (win 100%)**, **ORSO 2022 +4.020 su 49 (win 89,8%)**. Su **tick BCM**
(21 mesi di toro): n 104 PF **1,097** DD 4,54%.
🔴 **Riserva scritta nel contratto** (`report/CONTRATTO_GATEDSHORT_770250.md`):
**il verdetto ORSO e' OHLC, non tick** — perche' nei tick BCM l'orso non c'e'.

### 🆕 R120 «gestione delle uscite» (09/09, stamattina) — **il buco di oggi**
`risultati_archivio/gestione_20260909` — **144 righe di risultato**, e la
distribuzione dei lati e' questa:

| (`InpAllowLong`, `InpAllowShort`) | righe |
|---|---:|
| **(1, 0) — SOLO LONG** | **96** |
| (1, 1) — entrambi | 48 |
| **(0, 1) — SOLO SHORT** | **0** |

> 🔴 **Due terzi del round di stamattina hanno misurato solo il lato long, e
> nessuna riga ha misurato lo short da solo.** E' la **REGOLA DEI DUE LATI del
> 25/08** — _"ogni analisi misura SEMPRE tutti e due i lati"_ — violata oggi.
> ⚠️ **Rettifica al referto gemello:** `PERCHE_NESSUNO_HA_SHORTATO_IL_DAX_2026-09-09.md`
> §3 dice *"nel CSV del round: `InpAllowShort = 0`"*. **E' vero, ma solo per 96
> righe su 144** — 48 righe hanno entrambi i lati. E i **file prova R120**
> (`prove/R120{a,b,c,d,e}_*.txt`, 18 file) pinnano tutti **`InpAllowShort=true`**:
> il long-only sta nei **risultati**, non nella prova. Il numero giusto e' questo.

## B.3 — LA TABELLA B VERA: le 40 coppie VIVE, una per una

| EA | Sym | Magic | stato del lato SHORT | fonte |
|---|---|---:|---|---|
| `ABTG_DAX_Apertura_EU` | D30EUR | 770101 | ✅ **MISURATO e BOCCIATO** — PF OOS 0,957 · n 257 · DD 12,31% | R107 · R115 |
| `ABTG_Dow_Apertura_US` | U30USD | 770202 | ✅ **MISURATO e BOCCIATO** — PF OOS 0,840 · n 73 (merito sospeso) | R54 · R107 · R115 |
| `ABTG_ORB_Ottimizzato` | U30USD | 770611 | ✅ **MISURATO e BOCCIATO** — PF OOS 0,520 · DD 26,37% (asimmetria strutturale) | R54 |
| `ABTG_MaxMinNotte_DAX_Short_Ott` | D30EUR | 770411 | ✅ **E' la sedia short** (il LONG e' quello bocciato) | sweep 26/07 · R81 |
| `ABTG_Nasdaq_Apertura_US` GATEDSHORT | NASUSD | 770250 | ✅ **MISURATO** — n 104 PF 1,097 (tick) / n 93 PF 1,84 (OHLC) | SHORTGATE 30/08 |
| `ABTG_EMA200` | U30USD | 771531 | ✅ **MISURATO e VERDE** — PF 1,891 · n 302 · DD 2,66% | R110 · R112 |
| `ABTG_SupRev_NAS_H1_Ott` | NASUSD | 970913 | ✅ MISURATO — PF 1,870 · **n 34** → indizio | R110 |
| `ABTG_SuperWave_DOW_H1_Ott` | U30USD | 770511 | ✅ MISURATO e ROSSO — PF 0,429 · n 84 | R110 |
| `ABTG_SupRev_DAX_H4_Ott` | D30EUR | 970912 | ⚪ **NON MISURABILE** — n 29 < 30 | R110 |
| `ABTG_PTE` | GBPUSD | 771322/771332 | ✅ MISURATO (corse solo-short in `csv_R79`/`csv_R80`) | R79 · R80 |
| `ABTG_CostToCost` | EURJPY | 772361 | ✅ MISURATO e ROSSO — short OOS **−1.870** | R40 (`r40` csv) |
| `ABTG_CostToCost` | GBPCAD | 772362 | ✅ MISURATO e ROSSO — short OOS **−3.007** | R40 |
| `ABTG_CostToCost` | XAGUSD | 772363 | ✅ MISURATO (corsa solo-short agli atti) | R40 |
| `ABTG_EasyTrend` | CHFJPY·GBPUSD·AUDJPY | 772421-23 | ✅ MISURATO (sweep lati R48, corse `(0,1)`) | R48 |
| `ABTG_PunteLarry` | GBPUSD | 772345 | ✅ **E' la sedia short** (il long e' spento) | R38 · R39 · R50 |
| `ABTG_SupertrendReversal` | 225JPY | 770901/770924 | 🟠 **SOLO DENTRO "ENTRAMBI"** — mai un numero suo | `[MAI MISURATO]` |
| `ABTG_MaxMinNotte` (oro) | XAUUSD | 770402 | 🟠 **SOLO DENTRO "ENTRAMBI"** | `[MAI MISURATO]` |
| `ABTG_PTE` | U30USD | 771321 | 🟠 **SOLO DENTRO "ENTRAMBI"** | `[MAI MISURATO]` |
| `ABTG_SuperWave` (H2) | U30USD | 770531 | 🟠 **SOLO DENTRO "ENTRAMBI"** | `[MAI MISURATO]` |
| `ABTG_EMA200_Ottimizzato` | XAUUSD | 971501 | 🟠 **SOLO DENTRO "ENTRAMBI"** | `[MAI MISURATO]` |
| `ABTG_SupertrendReversal_Ott` | XAUUSD | 970901 | 🟠 **SOLO DENTRO "ENTRAMBI"** | `[MAI MISURATO]` |
| `ABTG_PunteLarry` | U30USD | 772341 | 🟠 **SOLO DENTRO "ENTRAMBI"** | `[MAI MISURATO]` |
| `ABTG_PunteLarry` | EURAUD | 772342 | 🟠 **SOLO DENTRO "ENTRAMBI"** | `[MAI MISURATO]` |
| `ABTG_PunteLarry` | XAUUSD | 772343 | 🔴 **`[MAI MISURATO]`** — solo corse long-only | — |
| `ABTG_PunteLarry` | GBPJPY | 772344 | 🔴 **`[MAI MISURATO]`** come corsa dedicata (R38 cita short OOS −1.166) | R38 |
| `ABTG_PunteLarry` | EURCAD | 772346 | 🔴 **`[MAI MISURATO]`** — solo corse long-only | — |
| `ABTG_PostNews` | EURJPY·EURUSD·USDJPY | 771201-03 | 🔴 **`[MAI MISURATO]`** — **nessun CSV, per nessun lato** | `CENSIMENTO_CONTRATTI.md` r.225-227 |
| `ABTG_BreakingBand` | GBPUSD·EURUSD·AUDUSD | 772161-63 | ⚙️ **VINCOLATO** — nessun input di lato (`:924` `isLong=(gBulgeDir>0)`, `:949` `<0`) | R52 §3 |
| `ABTG_GapFill` | GBPUSD·EURUSD·AUDUSD·U30USD·225JPY | 772231-35 | ⚙️ **VINCOLATO** — `:424 isLong=(gGap<0.0)`, sempre contro il gap | R52 §3 |
| `ABTG_GapContinuation` | 225JPY | 774101 | ⚙️ VINCOLATO, **ma il P/L short e' agli atti: −2.182 OOS** (scritto nel contratto) | R65 · R66 |

---

# 🏟️ TABELLA C — CAMPO: chi ha davvero shortato, e quando

_Fonte: `data/statements/trades_auto.csv` (piccolo 50503392) +
`trades_100k.csv` (100k 50504263). Periodo coperto **30/03/2026 → 08/09/2026**._
🔴 **LIMITE DICHIARATO: l'ultima riga e' 08/09 12:50. Cosa hanno fatto le sedie
OGGI 09/09 NON E' IN QUESTI DATI.** Il conto reale 10105439 **non ha uno
statement nel repo**: le sue due sedie sono `[NON MISURATO]` in campo.

## C.1 — Lo squilibrio, misurato per simbolo (magic ≠ 0, cioe' niente manuale)

| simbolo | buy | sell | tot | **% short** |
|---|---:|---:|---:|---:|
| **D30EUR** | **99** | **38** | 137 | **28%** |
| U30USD | 57 | 24 | 81 | 30% |
| NASUSD | 29 | 22 | 51 | 43% |
| XAUUSD | 11 | 21 | 32 | 66% |
| GBPUSD | 14 | 13 | 27 | 48% |
| CADJPY | 9 | 18 | 27 | 67% |

✅ **Il 72/28 sul DAX e' confermato al numero.** E si legge una cosa che vale
la pena dire: **lo squilibrio e' degli INDICI, non della flotta.** Su oro,
CADJPY e GBPUSD siamo bilanciati o addirittura corti. **Il long-bias e' dove
il campione e' un toro solo.**

## C.2 — Sedia per sedia (le 40 vive)

| Magic | EA | Sym | buy | sell | %sh | ultimo SHORT | gg fa |
|---:|---|---|---:|---:|---:|---|---:|
| 770101 | `ABTG_DAX_Apertura_EU` | D30EUR | 37 | 9 | 20% | **2026-08-13** | **27** |
| 770202 | `ABTG_Dow_Apertura_US` | U30USD | 7 | 0 | 0% | **MAI** | — |
| 770250 | `ABTG_Nasdaq_Ap.` GATEDSHORT | NASUSD | — | — | — | **nessuna operazione** | — |
| 770402 | `ABTG_MaxMinNotte` oro | XAUUSD | 2 | 7 | 78% | 2026-09-08 | 1 |
| 770411 | `ABTG_MaxMinNotte_DAX_Short` | D30EUR | 0 | 9 | **100%** | 2026-08-31 | 9 |
| 770511 | `ABTG_SuperWave_DOW_H1_Ott` | U30USD | 8 | 7 | 47% | 2026-09-07 | 2 |
| 770531 | `ABTG_SuperWave` H2 | U30USD | 6 | 6 | 50% | 2026-08-31 | 9 |
| 770611 | `ABTG_ORB_Ottimizzato` | U30USD | 16 | 0 | 0% | **MAI** | — |
| 770901 | `ABTG_SupertrendReversal` Nik | 225JPY | 2 | 3 | 60% | 2026-07-31 | 🔴 **40** |
| 770924 | `ABTG_SupertrendReversal` NikFW | 225JPY | 2 | 0 | 0% | **MAI** | — |
| 771201 | `ABTG_PostNews` ECB | EURJPY | — | — | — | **nessuna operazione** | — |
| 771202 | `ABTG_PostNews` FOMC | EURUSD | 1 | 0 | 0% | **MAI** | — |
| 771203 | `ABTG_PostNews` NFP | USDJPY | 0 | 1 | 100% | 2026-09-04 | 5 |
| 771321 | `ABTG_PTE` | U30USD | 0 | 1 | 100% | 2026-09-03 | 6 |
| 771322 | `ABTG_PTE` storica | GBPUSD | 0 | 1 | 100% | 2026-08-14 | 26 |
| 771332 | `ABTG_PTE` B25 | GBPUSD | — | — | — | **nessuna operazione** | — |
| 771531 | `ABTG_EMA200` | U30USD | 12 | 9 | 43% | 2026-08-31 | 9 |
| 772161 | `ABTG_BreakingBand` | GBPUSD | 1 | 1 | 50% | 2026-08-20 | 20 |
| 772162 | `ABTG_BreakingBand` | EURUSD | 0 | 1 | 100% | 2026-08-31 | 9 |
| 772163 | `ABTG_BreakingBand` | AUDUSD | 1 | 0 | 0% | **MAI** | — |
| 772231-33 | `ABTG_GapFill` | GBP/EUR/AUD-USD | — | — | — | **nessuna operazione** | — |
| 772234 | `ABTG_GapFill` | U30USD | 1 | 0 | 0% | **MAI** | — |
| 772235 | `ABTG_GapFill` | 225JPY | 0 | 1 | 100% | 2026-09-06 | 3 |
| 772341 | `ABTG_PunteLarry` | U30USD | 2 | 1 | 33% | 2026-09-01 | 8 |
| 772342 | `ABTG_PunteLarry` | EURAUD | 3 | 0 | 0% | **MAI** | — |
| 772343 | `ABTG_PunteLarry` | XAUUSD | 2 | 0 | 0% | **MAI** | — |
| 772344 | `ABTG_PunteLarry` | GBPJPY | 1 | 0 | 0% | **MAI** | — |
| 772345 | `ABTG_PunteLarry` | GBPUSD | 0 | 2 | **100%** | 2026-09-01 | 8 |
| 772346 | `ABTG_PunteLarry` | EURCAD | 1 | 0 | 0% | **MAI** | — |
| 772361 | `ABTG_CostToCost` | EURJPY | 5 | 0 | 0% | **MAI** | — |
| 772362 | `ABTG_CostToCost` | GBPCAD | 4 | 0 | 0% | **MAI** | — |
| 772363 | `ABTG_CostToCost` | XAGUSD | 1 | 0 | 0% | **MAI** | — |
| 772421 | `ABTG_EasyTrend` | CHFJPY | 1 | 2 | 67% | 2026-08-20 | 20 |
| 772422 | `ABTG_EasyTrend` | GBPUSD | 2 | 3 | 60% | 2026-08-21 | 19 |
| 772423 | `ABTG_EasyTrend` | AUDJPY | 0 | 2 | 100% | 2026-08-18 | 22 |
| 774101 | `ABTG_GapContinuation` | 225JPY | 1 | 1 | 50% | 2026-08-19 | 21 |
| 970901 | `ABTG_STRev_Ott` | XAUUSD | 1 | 0 | 0% | **MAI** | — |
| 970912 | `ABTG_SupRev_DAX_H4_Ott` | D30EUR | — | — | — | **nessuna operazione** | — |
| 970913 | `ABTG_SupRev_NAS_H1_Ott` | NASUSD | 6 | 0 | 0% | **MAI** | — |
| 971501 | `ABTG_EMA200_Ottimizzato` | XAUUSD | 2 | 2 | 50% | 2026-08-05 | 🔴 **35** |

## C.3 — 🎯 IL DETTAGLIO CHE SPIEGA L'EPISODIO DI OGGI

Il magic 770101 sul DAX, **spaccato per geometria** (colonna `strategy`):

| geometria | buy | sell | finestra |
|---|---:|---:|---|
| `DAX Apertura EU BUY` (breakout) | 14 | 0 | 20/07 → 14/08 |
| **`DAX Apertura EU SELL` (breakout)** | 0 | **9** | 27/07 → **13/08** |
| **`DAX Apertura EU RETEST BUY`** (la geometria VIVA) | **22** | **0** | 07/08 → **08/09** |

> ### 🔴 **La geometria che gira oggi — il RETEST — ha fatto 22 long e ZERO short in un mese.**
> I 9 short del 770101 appartengono tutti alla **vecchia** geometria breakout,
> finita il 13/08. Quindi non e' che "il DAX non shorta da 27 giorni": e' che
> **la sedia viva sul DAX non ha MAI shortato da quando e' viva** — per preset
> (`InpAllowShort=false`) e per misura (R107: PF 0,957 su n 257).
> **L'unica sedia short dedicata sul DAX (770411) lavora sul box NOTTURNO in M15:
> alle 11 del mattino non sta guardando.**

---

# 🎯 I QUATTRO NUMERI CHE CLAUDIO DEVE VEDERE SUBITO

## 1️⃣ Quanti EA POSSONO shortare, e quanti hanno lo short SPENTO

| | |
|---|---:|
| sorgenti `.mq5` | **111** |
| ✅ **possono shortare** (input di lato + 25 senza input che aprono comunque entrambi i versi + utility escluse) | **105 su 105 motori** |
| 🔴 short **spento nel DEFAULT del sorgente** | **4** (2 sono `_Ottimizzato` di aperture, 1 e' una sonda per disegno, 1 e' una sedia fantasma) |
| 🔴 **short spento nel PRESET** (e' questo che gira) | **14 preset** |
| 🐻 long spento (short-only) | 2 sorgenti + 3 preset |

> 🔴 **E il numero che pesa: ENTRAMBE le sedie del conto REALE 10105439 hanno
> `InpAllowShort=false` nel preset. Sul conto che paga, oggi, siamo 100% long.**

## 2️⃣ Quante coppie EA × simbolo hanno il lato short MAI MISURATO

Sulle **40 coppie vive**:

| | |
|---:|---|
| **9** | ⚙️ **VINCOLATE** — nessun input di lato, il verso lo sceglie il mercato (BreakingBand ×3, GapFill ×5, GapContinuation ×1). La domanda non si pone: non c'e' una corsa "solo short" da fare |
| **17** | ✅ hanno un **numero short proprio** agli atti |
| 🔴 **14** | **`[MAI MISURATO]` come lato a se'** — su **31 coppie separabili** |

**Le 14, in chiaro:**
🟠 *misurate solo DENTRO "entrambi i lati"* (8) — `SupertrendReversal` 225JPY ·
`MaxMinNotte` XAUUSD · `PTE` U30USD · `SuperWave H2` U30USD ·
`EMA200_Ottimizzato` XAUUSD · `SupertrendReversal_Ott` XAUUSD ·
`PunteLarry` U30USD · `PunteLarry` EURAUD
🔴 *solo corse long-only* (3) — `PunteLarry` XAUUSD · GBPJPY · EURCAD
🔴 *nessun CSV per nessun lato* (3) — `PostNews` EURJPY · EURUSD · USDJPY

> ⚠️ E ricordando la **REGOLA DELLO SLOT** (§A.3.1): *"misurato dentro
> entrambi"* **non e' misurato**. In quelle celle il long mangia il posto dello
> short, e il numero che ne esce **sottostima il lato corto per costruzione**.

## 3️⃣ Sedie VIVE che non shortano da piu' di 30 giorni

Con lo statement fermo all'08/09, le sedie **che hanno shortato almeno una
volta** e sono oltre i 30 giorni sono **2**:

| Magic | EA | Sym | ultimo short | giorni |
|---:|---|---|---|---:|
| **770901** | `ABTG_SupertrendReversal` Nikkei H2 | 225JPY | **2026-07-31** | **40** |
| **971501** | `ABTG_EMA200_Ottimizzato` | XAUUSD | **2026-08-05** | **35** |

🔴 **Ma il numero vero e' molto piu' grande, e va detto: ci sono altre 15 sedie
vive che non hanno MAI shortato** in tutto lo statement (30/03→08/09) —
`770202` Dow Apertura · `770611` ORB · `770924` STRev Nikkei FW ·
`771202` PostNews FOMC · `772163` BB AUDUSD · `772234` GapFill Dow ·
`772342`·`772343`·`772344`·`772346` PunteLarry (EURAUD/oro/GBPJPY/EURCAD) ·
`772361`·`772362`·`772363` CostToCost · `970901` STRev_Ott oro ·
`970913` SupRev NAS — **piu' 7 sedie MUTE** che non hanno fatto **nessuna**
operazione (`770250` GatedShort, `771201` PostNews ECB, `771332` PTE B25,
`772231`·`772232`·`772233` GapFill, `970912` SupRev DAX H4).
🧮 **Totale: 2 oltre i 30 giorni + 15 mai + 7 mute = 24 sedie vive su 40 senza
uno short recente.**
👉 **Per 770202, 770611, 772343-46 e 772361-63 il long-only e' VOLUTO** (preset
o cella): non e' un guasto. **Per `970913` SupRev NAS (6 long, 0 short) e
`770924` STRev Nikkei, che girano dichiarati SIMMETRICI, il silenzio short e'
un dato che nessuno ha spiegato.**

## 4️⃣ Quali EA hanno ASIMMETRIE NEL CODICE fra i due lati

### 🎉 **ZERO. La lista e' vuota, ed e' la notizia migliore del referto.**

**571 decisioni a due rami esaminate in 111 sorgenti · 510 specchiate al
centesimo · 61 residui letti a mano · 0 asimmetrie che falsino i numeri short.**
Il punto piu' esposto — la guardia `sl>0` sul breakeven degli short, dove uno
zero non e' un valore neutro — e' **coperto 15 volte su 15**, con due tecniche
diverse (§A.3, Classe 1).

👉 **Conseguenza operativa, ed e' buona:** quando misuriamo un lato short,
**quel numero vale**. Il motore non lo sta zoppicando. Se lo short perde, perde
per il mercato o per la finestra — **non per un bug**.

### 🟠 Le 4 cose che NON sono bug ma vanno scritte accanto a ogni numero short

| # | cosa | dove |
|---|---|---|
| 1 | 🔴 **Lo SLOT: `n(long)+n(short) ≠ n(entrambi)`** — il long ha la precedenza e consuma il posto. **Misurato due volte** (FASE M aperture: 256+243=316 non 499 · PASSO 0 VwapRevert: 44+66=110 ma il nudo fa 107) | `ABTG_VwapRevert.mq5:753-756` · `ABTG_OutOfNoise.mq5:559-562` · `ABTG_AllineaLondra.mq5:904-905` · `ABTG_FiboH4_Multi.mq5:412-415` · `ABTG_DAX_Apertura_EU.mq5:257` |
| 2 | 🟠 **Spegnere lo short spegne anche il REVERSE** sulle aperture | `ABTG_DAX_Apertura_EU.mq5:481` |
| 3 | 🟠 **Filtro scelto PER IL LONG che resta addosso allo short**: `InpUseSupertrend=false` con commento *"la versione LONG-only rende di piu'"* | `ABTG_DAX_Apertura_EU_Ottimizzato.mq5:200` |
| 4 | 🟡 **Soglie OB/OS su due manopole separate**: default simmetrici ✅, ma una griglia puo' romperne la simmetria senza che si veda | `ABTG_AltaVelocita.mq5:143-144` · `ABTG_PTE.mq5:77-78` · `ABTG_Apertura_Marco.mq5:277-278` · `ABTG_BreakoutCorso.mq5:110-111` |

---

# 🙋 QUATTRO COSE DA PORTARE A CLAUDIO — nessuna e' una decisione presa qui

Nel rispetto del **CANCELLO** (niente esce senza PASS) e del **CERTIFICATO DI
MORTE**, questo referto **non archivia niente e non propone nessun lancio**.
Segnala solo dove il buco e' **una misura mancante**, non un numero brutto:

1. 🥇 **Il round short piu' economico che esista oggi non e' sugli indici.**
   `PunteLarry` **XAUUSD / GBPJPY / EURCAD** e `PTE` **USDJPY** hanno il lato
   short `[MAI MISURATO]` come corsa dedicata **e** hanno storico BCM vero:
   oro dal **2004.06.11** (22 anni: 2008, 2013, 2020, 2022), USDJPY dal
   **1971**. **Li' un rosso short e' un verdetto, non un'epoca.** Costo: un
   input, dati gia' in casa.
2. 🥈 **Le 8 celle "misurate solo dentro entrambi"** (SupertrendReversal 225JPY,
   MaxMinNotte oro, PTE Dow, SuperWave H2, EMA200_Ott oro, STRev_Ott oro,
   PunteLarry Dow/EURAUD) **non hanno un numero short: hanno un numero diluito.**
   Vale la regola dello slot: separarle e' informazione nuova, non una ripetizione.
3. 🔴 **`ABTG_PostNews` (771201/771202/771203) e' in campo con ZERO misure per
   ENTRAMBI i lati** — gia' agli atti in `CENSIMENTO_CONTRATTI.md` r.225-227.
   Non e' un problema di short: e' una sedia senza contratto che opera.
4. ⚠️ **Il round di stamattina (R120) va completato sul lato short** — 96 righe
   su 144 sono long-only e **zero righe sono solo-short**. E' la regola dei due
   lati del 25/08. ⏳ **Non e' una riga di lancio: e' una segnalazione.** La
   riga, se si decide di farla, passa dal cancello (`controlla_riga.py` +
   `controllo-preventivo`) come tutto il resto.

---

## 🧾 NOTA DI RICONCILIAZIONE col referto gemello di oggi

`report/PERCHE_NESSUNO_HA_SHORTATO_IL_DAX_2026-09-09.md` conta **88 long / 34
short su D30EUR**; io conto **99 / 38**. **Non e' una discordanza: e' un
perimetro diverso, e tutte e due le cifre danno 72/28.** Lui usa solo
`trades_auto.csv` ed esclude le righe senza commento; io sommo anche
`trades_100k.csv`. ✅ **La percentuale — che e' il numero che conta — coincide.**
Corretta invece la sua §3 (vedi §B.2, R120): il long-only e' in **96 righe su
144**, non in tutto il round, e i file prova pinnano `true`.

---

_Compilato il 09/09/2026, sola lettura d'archivio e di sorgente. Nessun EA,
preset, parametro o forward toccato. Nessun backtest lanciato. Dove il numero
non esiste c'e' `[MAI MISURATO]`. **Se un referto e questo censimento
divergono, comanda il referto.**_
