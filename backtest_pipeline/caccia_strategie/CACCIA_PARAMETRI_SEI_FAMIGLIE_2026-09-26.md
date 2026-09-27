# 🎯 CACCIA PARAMETRI — LE SEI FAMIGLIE IN CODA (26/09/2026)

**Richiesta di Claudio, testuale:** _"DOBBIAMO AVERE QUESTE SEDIE!! ASSOLUTAMENTE. NON FERMIAMOCI
DAVANTI A QUALCHE PARAMENTRO BASSO. SI CERCA SUL WEB SE QUALCHE PARAMETRO C'E' DA MIGLIORARE."_
**Regola che vincola** (seconda caccia, 19/08): si cercano **FILTRI, USCITE, MECCANISMI e VALORI
PUBBLICI** di EA simili — mai un'altra griglia sullo stesso motore morto. Criteri di casa **invariati**
(PF >= 1,10 IS e OOS · n >= 150 posizioni · DD alla taglia dentro il muro 10% · stop >= 40x costo
all-in · centro dell'altopiano).

**Perimetro rispettato:** sola lettura del repo + web + **tre sonde esterne** su dati pubblici
(Oanda/histdata via `raw.githubusercontent.com`, gia' canale di casa: `biblioteca/sonde_esterne/LEGGIMI.md`).
**Zero** EA, preset, file prova, righe di lancio o forward toccati. Tutte le pagine web lette il
**26/09/2026**. Etichette: **[DICHIARATO]** = numero dell'autore, non pesa · **[MISURATO-SONDA]** =
misurato da me su dati esterni, SCREENING mai verdetto · **[INFERITO]** · **[INCERTO]**.

---

## 0. 🧭 LA RIGA CHE CONTA, E IL VERDETTO IN SETTE RIGHE

> _"Ho letto **21 pagine** su **5 fonti vive** (13 domini murati, dichiarati in §1), girato **4 sonde
> esterne** (+1 nulla) su 5,4 anni di M1, e mappato **14 proposte** sui nostri input: **tutte e 14
> girano a zero righe di codice** (una ha anche una versione "giusta" con 2 input nuovi). La prima che farei e' il **filtro notizie USD con chiusura sul
> box dell'oro `770402`**, perche' e' l'unica famiglia a un passo dal campo, il suo tappo e' il **DD**
> e non il PF, e ha **693 deal di budget** per permettersi un filtro che tagli."_

1. 🥇 **ORO `770402` — il tappo si chiama TAGLIA, e va detto per primo.** Da 19,6% a <= 8% a 2,00%
   serve un DD a 0,5% <= **2,06%** (oggi 5,32%): **-61%**. Nessun filtro pubblico letto **promette**
   una cosa del genere. L'unico precedente di casa di quella forza e' la correlazione S&P sul DAX short
   (DD 7% -> 3%, trade / 2,4). 🟢 **Ma l'oro ha il campione per permetterselo**: 693 deal / 2,4 ≈ 290
   deal ≈ **214 posizioni**, sopra 150. Le leve DD **mai misurate** sono tre, tutte su input esistenti.
2. 🔴 **ORO, uno "spunto" pubblico e' GIA' CADUTO in casa**: lo **stop in ATR** di `GoldLondonBreakout`
   (1,2 x ATR) = il nostro `InpSLMode=1`, misurato in `oro_maxmin_fase1_*.csv`: a buffer 200 fa **DD
   9,3-26,5%** contro **3,7-5,7%** dello stop all'estremo opposto (`InpSLMode=0`). Non si riprova.
3. 🔴 **LONDRA ORB — la sonda chiude la domanda del costo PRIMA del round.** Canale 07-08 di Londra su
   GBPUSD (2015-2020): **mediana 22,7 pip**, e il 40x all-in con SL al centro chiede **W >= 61,2** =
   **2,2% dei giorni**. Con **SL all'estremo opposto** (input gia' nell'EA) la soglia scende a **W >=
   30,6** = **26,1% dei giorni**. E' l'unico blocco che R258 non ha.
4. 🟠 **LA "LONDON BREAKOUT" CLASSICA (box asiatico) passa il costo, ma sulla sonda e' PIATTA**:
   GBPUSD box 00-08 UK, SL opposto, filtro di costo acceso: **E +0,012 R, t +0,40, n 811**; il **long
   e' negativo in tutte le 12 celle** (2 simboli x 2 box x 3 TP). Si puo' misurare su BCM a costo zero di codice (`ABTG_MaxMinNotte`),
   ma il prior e' debole.
5. 🟠 **DOW SHORT — tre filtri e un'uscita mai misurati** su input esistenti (stop a tempo 90', volumi,
   VWAP). Il prior di famiglia e' cattivo: la replica pubblica dell'ORB 5' (25/09/2026) da' il **Dow
   netto -0,081 R**.
6. ⚪ **DAX LONG — dal web nessuna ragione per attendersi un ribaltamento**; la sonda notturna esterna
   e' **NULLA** (histdata `GRXEUR` non ha la notte, `DE30_EUR` Oanda = 404). La misura resta R261.
7. 🟢 **NIGHTLY — la sonda chiarisce un dubbio di R259**: il filtro QB del PDF (45 pip) su EURUSD
   **scatta nello 0,4% delle notti** = e' quasi inerte. Quindi `InpMaxNightVolPips=0` su oro/indici
   (R259) **non e' una deviazione pratica dal PDF**. 🟢 **EMA200 — l'ADR (`InpUseAdrFilter`) non e' MAI
   stato acceso in nessun file prova**: e' un filtro di casa, gia' codificato, mai misurato.

🔴 **Detto chiaro, perche' la grinta non tocca i numeri:** nessuna di queste proposte da sola porta una
sedia NUOVA in campo il **1° ottobre**. Quella piu' vicina resta l'oro, e il suo interruttore vero e'
**la taglia**, che e' **una firma di Claudio** (con `R193b` gia' scritto: 8 passate, ~2 min).

---

## 1. 🎯 CONTROLLO POSITIVO DELLE FONTI (§2 del ruolo)

| fonte | bersaglio noto | esito | uso |
|---|---|---|---|
| **mql5.com** (Code Base, Market, Blog, Forum) | `code/75586` `GoldLondonBreakout` gia' letto in casa il 23/08 (`SWEEP_MECCANISMI` §M1): deve dare `InpMinRangeATRFrac=0.15` / `0.70` | ✅ **ridato identico** | fonte principale (15 pagine) |
| **github.com** | repo `nsclk/Asian-Range-Breakout-Expert-Advisor-for-MT5` | ✅ contenuti veri (README, licenza MIT) | 1 pagina |
| **raw.githubusercontent.com** (FutureSharks, GPL-3.0) | orologio Oanda = UTC (collaudo di casa del 05/09) | ✅ **file 200**, dati M1 2015-01 → **2020-05-14** (da 2020-06 in poi **404**) | 3 sonde |
| **tradingview.com** | idea `XAU/USD Asian Range Backtesting` | ✅ pagina vera, **zero numeri** | scartata |
| **quantconnect.com** | ricerca ORB "stocks in play" | ✅ | 1 pagina |
| forexfactory.com | thread ORB DAX | ❌ **403** (come dal 12/09) | NULLA |
| erikssonsystems.com · lazyalgos.com · fxvps.biz · quantifiedstrategies.com · cxoadvisory.com · danfin.net · tradertom.com · newyorkfed.org · libertystreeteconomics.newyorkfed.org · fedinprint.org · research.cbs.dk · trademachine.substack.com | — | ❌ **EGRESS_BLOCKED** dal proxy | NULLE |
| github.com/HueRitzy/mt5-trendpulse | — | ❌ **404** (il repo non esiste piu') | NULLA |
| histdata `XAUUSD` 2021-2024 trovato nella scratchpad | — | ❌ **file troncati** (2023: 185.760 righe = 129 giorni) | **NON usato** |

⚠️ La pagina `mql5.com/en/market/product/160162` e' tornata come **elenco del Market**, non come la
scheda del prodotto: non citata come scheda.

---

## 2. 🔬 LE QUATTRO SONDE ESTERNE (+1 NULLA) — i numeri che mancavano (SCREENING, mai verdetto)

Dati: Oanda M1 (UTC) `GBP_USD` `EUR_USD` `XAU_USD` **2015-01-01 → 2020-05-14** (5,4 anni; ~1,86-1,89 M
barre per simbolo). OHLC M1, **ambiguita' intrabarra a sfavore**, costo dichiarato riga per riga,
**nessuno spread variabile, nessuno slippage**. **Non e' BCM e non copre il regime 2024-2026.**
Script in scratchpad (non committati per mandato: si committa solo questo file).

### 2.1 📏 Londra — l'ampiezza del canale, il numero che `ANALISI_PDF_LONDRA` §6.3 chiedeva
Ora di Londra con la regola DST britannica (ultima domenica di marzo/ottobre, 01:00 UTC). Soglie di
costo con l'**all-in di R258 §7** (GBPUSD 0,840 pip · EURUSD 0,664 pip) e buffer 3 pip:
SL al centro `W/2+3 >= 40c` · SL opposto `W+3 >= 40c`.

| simbolo | canale (ora UK) | P10 | P25 | **mediana** | P75 | P90 | W >= soglia **centro 40x** | W >= soglia **opposto 40x** | W >= centro **duro 13,3x** |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|
| GBPUSD | **06-07 (PDF)** | 6,7 | 9,0 | **12,8** | 18,0 | 25,2 | **0,9%** (>=61,2) | 5,8% (>=30,6) | 30,3% (>=16,3) |
| GBPUSD | **07-08 (Borsa)** | 13,1 | 16,8 | **22,7** | 31,0 | 41,6 | **2,2%** | **26,1%** | 77,2% |
| EURUSD | 06-07 | 4,7 | 6,8 | **10,1** | 14,4 | 19,4 | 0,7% (>=47,1) | 5,9% (>=23,6) | 39,5% (>=11,7) |
| EURUSD | 07-08 | 8,8 | 11,8 | **16,9** | 23,2 | 32,0 | 2,7% | **24,2%** | 75,8% |

- Mediane GBPUSD 07-08 per anno: 2015 23,2 · 2016 28,2 · 2017 20,5 · 2018 22,6 · 2019 18,9 · 2020 25,4
  (nessun anno vicino a 61). [MISURATO-SONDA]
- 👉 **Previsione scritta ORA, prima di R258**: il blocco T di R258 (SL al centro, `InpMinRangePips`
  0-70) finira' **FRAGILE o ESCLUSO PER COSTO su quasi tutta la griglia**; la riga F=70 terra' ~1-2%
  dei giorni (qualche operazione in 2 anni di tick). Se BCM 2024-2026 mostrasse canali doppi, la
  previsione cade: e' il **contro-esempio** che R258 stampera' per primo (curva `Trades(b=3,F)`).
- 📦 Box piu' lunghi (stessa sonda): GBPUSD **00-07 UK** mediana **28,4** (>= 61,2: 7,6% · >= 30,6:
  43,7%) · **00-08 UK** mediana **36,8** (13,3% · **68,3%**) · 03-07 mediana 20,7. EURUSD 00-07
  mediana 23,5 · 00-08 mediana 29,4 (>= 23,6: **68,1%**).

### 2.2 🌏 La "London breakout" classica sul box asiatico — c'e' qualcosa da misurare a BCM?
Geometria (= `ABTG_MaxMinNotte`, `InpSLMode=0`): box 00-07 o 00-08 UK, buy stop max+3 / sell stop
min-3, SL all'estremo opposto (+/-3), TP a 1,0/1,5/2,0 R, cutoff ingressi box+3h, flat 17:00 UK,
**solo giorni con W sopra la soglia di costo** (GBPUSD 30,6 · EURUSD 23,6), costo all-in dedotto.

| simbolo · box | lato | TP 1,0R | TP 1,5R | TP 2,0R |
|---|---|---|---|---|
| GBPUSD 00-08 | long | E -0,020 · n 412 · 2/6 anni | E -0,029 | E -0,012 |
| GBPUSD 00-08 | short | E +0,024 · t +0,62 · n 486 | E +0,003 | E +0,014 |
| GBPUSD 00-08 | due lati (OCO) | **E +0,012 · t +0,40 · n 811** | E -0,000 | E +0,009 |
| EURUSD 00-08 | long | E -0,028 | E -0,046 | E -0,049 |
| EURUSD 00-08 | short | E +0,033 · t +0,78 · **5/6 anni** | E +0,026 · 5/6 | E +0,036 · 4/6 |
| EURUSD 00-07 | due lati | E -0,063 · t -1,74 | **E -0,091 · t -2,28** | E -0,090 |

👉 [MISURATO-SONDA] **Piatto**: nessuna cella con |t| > 0,8 sul lato positivo; il **long e' negativo in
tutte e 12 le celle**; lo short di EURUSD 00-08 e' l'unico segno coerente (4-5 anni su 6) ma a t < 0,8.
Prior **debole** per la proposta P8.

### 2.3 🥇 Oro — il box notturno della sedia `770402` fuori dal suo regime
Orologio: server BCM **vecchio** (IT-1 = UTC+0 inverno / UTC+1 estate, regola UE), box **23:00-04:59**,
piazza 07:00, cutoff 08:30, flat 17:30 (= geometria del preset/R103), buffer 2,50 $, SL all'estremo
opposto +/- buffer, **uscita semplificata** (un solo TP a 2,5 R, niente parziale/BE/EMA200/trailing),
costo 0,55 $ a giro (spread FTMO 0,45 + 0,10 di commissione **[ipotesi]**), ATR14 D1 dei 14 giorni
**precedenti**.

| misura | LONG | SHORT |
|---|---|---|
| tutti | n 163 · **E -0,004 R** · PF(R) 0,98 | n 168 · **E -0,111 R** · t -1,85 · PF 0,69 |
| quintile 1 di W/ATR(D1) (box piu' stretti, < 0,26) | **E -0,132** · n 32 · t -0,81 | E -0,081 |
| quintili 2-4 | E +0,030 / +0,027 / +0,053 | E -0,280 / -0,061 / -0,108 |
| quintile 5 (> 0,54) | E -0,001 | E -0,033 |
| banda `GoldLondonBreakout` 0,15-0,70 | n 149 (**91%** dei trade) · E +0,002 | n 158 · E -0,129 |
| trend D1 **concorde** (EMA14 > EMA100, barra chiusa) | n 97 · **E -0,031** · PF 0,89 | n 58 · E -0,145 |
| trend D1 **discorde** | n 54 · **E +0,179** · t +1,78 · PF 1,88 | n 93 · E -0,088 |
| stop mediano / quota stop < 18 $ (40x di 0,45 $) | **10,26 $ / 94,5%** | 10,06 $ / 94,0% |

- 🔴 **Fatto di regime, non di motore**: nel 2015-2020 il box dell'oro era cosi' stretto che la sedia
  sarebbe stata **esclusa per costo nel 94% dei giorni**. Nel 2020-2026 lo stop mediano e' 32,94 $
  (n=2, `STATO_MAXMIN` §B.4): **la sedia vive in un regime di volatilita' che il passato non aveva.**
  Questo e' esattamente perche' un filtro d'ampiezza **relativo** (in ATR) ha senso e uno in **punti
  assoluti** no.
- 🟡 **Il filtro d'ampiezza relativo**: il quintile piu' stretto e' il peggiore sul long (coerente col
  vendor), ma n 32 e t -0,81 = **rumore**; la banda 0,15-0,70 del vendor **taglia solo il 9%** dei
  trade e non cambia niente. [MISURATO-SONDA]
- 🔴 **Il filtro di trend "alla vendor" va nel verso SBAGLIATO**: long concorde col trend D1 **peggiore**
  (-0,031) del long contro-trend (+0,179, t +1,78). Contro-esempio pronto per P3.

### 2.4 🌙 Il filtro QB del Nightly — quanto morde davvero
ATR(14) H1 alle 05:00 server (vecchio orologio), notti feriali 2015-2020, nelle unita' dell'EA
(`NightH1Vol()` r.198-202: `ATR/PipSize()`, e `PipSize()=_Point` su oro):

| simbolo | P10 | P50 | P90 | P99 | quota notti **escluse** dal QB=45 |
|---|---:|---:|---:|---:|---:|
| EURUSD (pip) | 7,2 | 12,3 | 20,8 | 35,9 | **0,4%** |
| XAUUSD (`_Point`) | 174 | 257 | 468 | 953 | **100%** (gia' noto: R259 la chiama "unita' sbagliata") |

👉 Il QB del PDF, sul simbolo per cui e' scritto, e' **quasi inerte**. Il suo equivalente sull'oro per
quantile (P99,6) e' ~**950 punti** a prezzi 2015-2020 (~**1.900** a prezzi raddoppiati **[INFERITO]**).
**Quindi R259 con `InpMaxNightVolPips=0` e' fedele nei fatti.** (GBPUSD non riportato: n 1.648 contro
1.389 feriali attesi = conteggio anomalo nella sonda, non indagato.)

### 2.5 ❌ Sonda NULLA: il DAX notturno
histdata `GRXEUR` 2011-2018 copre **solo 08:00-22:00 italiane** (conteggio per ora sul 2016: zero barre
fra le 00 e le 07 IT); Oanda `DE30_EUR` = **404**. La notte del DAX **non e' misurabile fuori** da
questo ambiente. Per il long DAX la misura e' e resta **R261**.

---

## 3. 🥇 FAMIGLIA 1 — BOX NOTTURNO ORO `770402`, LATO LONG (e il DD alla taglia)

**Stato di casa** (`STATO_MAXMIN_DAX_LONG_E_ORO` §B): R103 OHLC 2020-2026 **PF 1,308 · n 693 deal (~512
pos.) · DD 5,32% @0,5%** → **19,6-21,3% @2,00%**. Lato long da solo: **mai misurato** (R260a in coda).

### 3.1 Tabella degli esempi

| esempio · URL | box / finestra | filtri | uscita | numeri dell'autore | cosa ne copiamo |
|---|---|---|---|---|---|
| **GoldLondonBreakout** (Gbadebo, pub. 01/08/2026, agg. 15/09/2026) · <https://www.mql5.com/en/code/75586> | Asia **00-07 server**, ordini attivi **07-11** | **ampiezza box fra 0,15 e 0,70 x ATR(14) D1**; spread max **350 pt** | buffer **0,15 ATR**, SL **1,2 x ATR**, TP **1,8 R**, OCO, pendenti scadono alle 11 | nessuno | 🟢 il filtro **relativo** (P2) · 🔴 lo stop in ATR = **gia' caduto** (§3.2) |
| **Gold Asian Breakout** (W. J. Magda, 30 $ lancio / 50 $) · <https://www.mql5.com/en/market/product/166774> | Asia **22:00-05:00 GMT**, Londra 07-11, NY 13-17 GMT | trend **Weekly SMA100**, MA, RSI, spread dinamico, "range valido" (soglie non pubblicate), news (non dettagliato) | SL/TP in ATR, BE + blocco, trailing; **daily loss 3%**, daily profit 5%, **max 4 trade/giorno** | "5 anni", "PF piu' alto su D1" **[DICHIARATO, senza numeri]**; "no martingala/griglia/hedging" | 🟡 il **trend HTF** (P3) — la sonda lo **smentisce** |
| **Asian Range Breakout EA** (nsclk, **MIT**, 4 commit) · <https://github.com/nsclk/Asian-Range-Breakout-Expert-Advisor-for-MT5> | Asia **0-7 estate / 1-8 inverno** (DST automatico), attesa max 12 h | **range min 10 pip / max 100 pip**, spread max 3 pip | TP **1,5 x SL**, rischio 2% | nessuno | 🟡 conferma: min **e** max d'ampiezza |
| **Range Breakout Beast** — manuale (Igor Widiger, bozza 28/10/2025) · <https://www.mql5.com/en/blogs/post/765033> | 03:00-06:00, fine 18:00 | range **min 500 pt / 0,10%** · **max 1000 pt / 0,50% del prezzo**; ATR D1 14 soglia 1,3% (off) ; RSI (off); news **3'/3'** | SL oltre il range; BE a 100 pt +10; max 1 posizione | nessuno; **prop: daily -500 / totale -1000 su 10.000** | 🟢 soglia d'ampiezza **in % del prezzo** = relativa senza ATR |
| **Range Breakout EA with Range Filters** (J. P. Eriksson, **649 $**) · <https://www.mql5.com/en/market/product/122237> | Asia → apertura Londra; XAUUSD, USDJPY, BTCUSD, US30, DE40 | "breakout filter" (definizione **non pubblica**), spread, **daily DD protector**, "trade randomizer" | chiude "piu' tardi nella giornata" | "+300% live 23 mesi" **[DICHIARATO]** | 🟠 niente di copiabile: i valori stanno sul sito del vendor (**murato**) |
| **Range Breakout Day Trader** — manuale (A. Mughal, 21/12/2024) · <https://www.mql5.com/en/blogs/post/760349> | range libero | altezza **min/max**, **giorni della settimana**, trend, **news moderate/alte con chiusura N' prima** | SL punti **o distanza del range**, SL ATR, **4 TP parziali**, trailing con soglia d'attivazione | set per XAUUSD/US30/USDJPY/BTCUSD a 4 livelli di rischio (valori **non** nel manuale) | 🟢 la **chiusura prima della news** (P1) |

### 3.2 Gia' misurato in casa — non si ripaga
- 🔴 **Stop in ATR** (`InpSLMode=1`): `risultati_archivio/MaxMin_Oro/oro_maxmin_fase1_{M5,M15,M30,H1}.csv`
  (12 celle ciascuno, box 22-06): a buffer 200 **SL0 PF 1,42-1,60 DD 3,7-5,7%** contro **SL1 PF
  0,92-1,35 DD 9,3-26,5%**. Lo "spunto" di `GoldLondonBreakout` e' un **caduto con numero**.
- 🟢 `InpMgmtTF` ad asse (`oro_maxmin_fase2_*`, M5-H1): fatto. Uscite: `r151a`/`r170b` girati, CSV
  **mai trasportati** (`STATO_MAXMIN` §B.7).
- ⚪ **Mai accesi sull'oro in nessun CSV** (ricontato: i 12 CSV d'archivio che hanno le colonne `InpMinBoxPts`,
  `InpMaxBoxPts`, `InpUseCorrelation` = **0 in tutte le righe**): filtro d'ampiezza, correlazione/trend,
  notizie.

### 3.3 Proposte mappate sui nostri input (`mql5/Experts/ABTG_MaxMinNotte.mq5`)
Base: geometria di **R260c** (= R103, OHLC 2020-2026, 0,5%), un file per proposta, asse = la manopola,
ancora = cella a filtro spento (deve ridare R103 al centesimo). Metro: **~20 s per passata a finestra
piena** (base r151a citata in R260) + avvii.

| # | proposta | input esatti | fonte | costo | cosa puo' rompere |
|---|---|---|---|---|---|
| **P1** | 🗞️ **chiusura/blocco sulle notizie USD** (leva DD) | `InpUseNewsFilter` 0/1 · `InpNewsCurrencies="USD"` · `InpNewsMinImpact=3` · `InpNewsBeforeMin=30` · `InpNewsAfterMin=30` · `InpNewsFlatten` 0/1 → **3 celle** (spento / blocca / chiude) | Range Breakout Day Trader (chiusura N' prima), Range Breakout Beast (3'/3'), Gold Asian Breakout (news, non dettagliato). **[INFERITO]** dal preset: la posizione resta aperta fino alle 17:30 server, cioe' attraverso i dati USA delle 08:30 ET | **0 codice** · 3 celle × 2 gambe ≈ **1-2 min** + 🔴 **prerequisito**: il file news nel tester e la sua copertura 2020-2026 (`mql5/Files/abtg_news_2021_2025_UTC.csv` + `InpNewsShiftMinutes`) **[NON VERIFICATO per MaxMinNotte]** — R93b e' il precedente di come si prepara | taglia proprio i giorni grossi, che sono anche i vincenti: puo' abbassare il PF insieme al DD |
| **P2** | 📐 **ampiezza del box RELATIVA** (min e max) | oggi solo `InpMinBoxPts`/`InpMaxBoxPts` **in punti assoluti** (r.122-123, r.331-332). Proxy a costo zero: asse `InpMaxBoxPts` 0/6000/8000 e `InpMinBoxPts` 0/1500/2500 **[valori da tarare sul CSV `ABTG_Notte_Study_XAUUSD.csv`, mediana 41,56 $ = 4.156 pt]**. Versione giusta: **2 input nuovi** `InpMinBoxAtrD1`/`InpMaxBoxAtrD1` (proposta M1 del 23/08, **mai implementata**) | GoldLondonBreakout 0,15-0,70 ATR D1; Beast 0,10-0,50% del prezzo; nsclk 10-100 pip | proxy: **0 codice**, 5 celle ≈ 2-3 min. Versione ATR: **~1-2 h** di codice + F7 + controllo + 5 celle | 🔴 in punti assoluti su 2020-2026 (prezzo dell'oro circa raddoppiato fra 2020 e 2026 **[INFERITO]**: box mediano 10 $ nella sonda 2015-2020 contro stop mediano 32,94 $ in campo) il filtro **seleziona l'epoca**, non il giorno: la cella va letta per anno. La sonda §2.3 dice che il min relativo **da solo non basta** |
| **P3** | 📈 trend dell'oro stesso (controllo, non speranza) | `InpUseCorrelation=1` · `InpCorrSymbol="XAUUSD"` · `InpCorrTF=D1 (16408)` · `InpCorrEmaFast=14` · `InpCorrEmaSlow=100` (`CorrBias()` r.698-708 legge qualunque simbolo/TF) · 2 celle, **solo long** su R260a | Gold Asian Breakout (Weekly SMA100) | **0 codice** · ~1 min | la sonda §2.3 lo da' **contro** (-0,031 vs +0,179): atteso NO. Si gira solo perche' costa un minuto e chiude la domanda |
| — | 🚫 stop in ATR | `InpSLMode=1` | GoldLondonBreakout | **non si gira**: caduto (§3.2) | — |

---

## 4. ⚪ FAMIGLIA 2 — BOX NOTTURNO DAX, LATO LONG

**Stato di casa:** **0/33 celle distinte sopra PF 1** (tick, max 0,947), certificato incompleto (③
uscita, ⑤ TF, specchio S&P); R261a (correlazione 0/1) e R261b (`InpMgmtTF` M15→H4) **in coda**.

### 4.1 Tabella degli esempi

| esempio · URL | meccanismo | lato long | numeri dell'autore | cosa ne copiamo |
|---|---|---|---|---|
| **Ger40 Morning Breakout** (K. A. Terpstra, v1.1 27/01/2025, 249 $) · <https://www.mql5.com/en/market/product/131037> | ingresso **10:00 server** ("apertura di Londra/Europa"; **[INFERITO]** GMT+2/+3 = apertura Xetra), pendenti **cancellati alle 10:23**, max 1/giorno | **trend filter: long solo in mercato rialzista**, short solo in ribassista | backtest 2019→, "DD 2,5% su 10k a 0,01 lotti" **[DICHIARATO]** | 🟡 trend del DAX **stesso** come filtro (P11) · 🟡 finestra d'ingresso **23'** |
| **ORB V2** — set e backtest (L. Samson, 05/01/2023) · <https://www.mql5.com/en/blogs/post/751385> | DAX: range all'apertura 10:00 (server; **[INFERITO]** GMT+2/+3), rotture 10:05/10:10/10:15, ordini chiusi **11:30** | due lati, nessun filtro di lato | 1 anno 04/2021-04/2022, spread fisso 2, "ROD" 2,50-3,42 **[DICHIARATO, 1 anno]** | 🔴 niente: un anno, niente split |
| **Replica ORB su 5 indici** (T. Krueger, 25/09/2026) · <https://www.mql5.com/en/blogs/post/776235> | 5' d'apertura, SL al lato opposto, TP 10R o chiusura, 2015→06/2026 | lati **non separati** | **DAX lordo +0,116 R, netto -0,038 R** · Dow lordo +0,048, netto **-0,081 R** · costi 0,8-4,0 pt | 🟠 **prior**: l'apertura degli indici netta di costi sta a zero |
| "overnight drift" (Boyarchenko-Larsen-Whelan, NY Fed SR 917) | rendimento all'apertura europea (02-03 ET) | — | 🔴 **[INCERTO]**: solo estratto del motore di ricerca ("**vicino a zero dal 2021**"); newyorkfed, Liberty Street, fedinprint, CBS **murati**. Non pesa | niente finche' non si legge la pagina |

### 4.2 Proposte (`ABTG_MaxMinNotte.mq5`, base R261a: tick 2024.09.26→2026.06.30, `@FRAZIONEIS 1.0`)
Metro: **0,28-0,70 min/passata** (R261).

| # | proposta | input esatti | costo | nota |
|---|---|---|---|---|
| **P11a** | trend del DAX stesso (il "trend filter" del vendor) | `InpUseCorrelation=1` · `InpCorrSymbol="D30EUR"` · `InpCorrTF` H4 (16388) / D1 (16408) · 14/100 · **solo long** | 2 celle + ancora ≈ **1-2 min** | complementare a R261a (che guarda lo S&P). Il campione scende come con lo S&P (~/2): **merito sospeso per costruzione**, rischio letto |
| **P11b** | casella ③ del certificato: l'uscita sul long | `InpUseTrailing` 0 · `InpBreakeven` 0 · `InpTP1Pct` 0 (una manopola per cella, sulla cella R261c) | 3 celle ≈ **1-2 min** | chiude il certificato; con 0/33 l'attesa onesta e' "resta sotto 1" |
| — | gap rispetto alla chiusura Xetra | **nessun input** in `ABTG_MaxMinNotte` | codice nuovo | non proposto: sul DAX short la continuazione del gap **e' gia' in R253** (PF 0,898 su 29 pos.), e sul long non c'e' tesi |

---

## 5. 🟠 FAMIGLIA 3 — APERTURA DOW, LATO SHORT (`ABTG_Dow_Apertura_US`)

**Stato di casa:** R54a short OOS **PF 0,84 · n 73**; R255 (24 file, 96 passate, **in coda**) mette
ad asse parziale, TP1_R 0,5/1,5, trailing, EMA spento, Supertrend H4-D1 e i due orologi.
**Mai misurati** sullo short del Dow (grep dei 24 file: `InpUseVolumeFilter=false`,
`InpUseVwapFilter=false`, `InpUseAtrFilter=false`, `InpMaxRangePts=0` ovunque; `InpCloseHour` 17/18).

### 5.1 Tabella degli esempi

| esempio · URL | filtro / uscita | valori | numeri | cosa ne copiamo |
|---|---|---|---|---|
| **ORB V2** — backtest (Samson, 05/01/2023) · <https://www.mql5.com/en/blogs/post/751385> | **stop a tempo** | US open **16:30** server (**[INFERITO]** GMT+2/+3), rotture 16:35/40/45, **ordini chiusi 18:00** = **90'** dopo l'apertura | Dow "ROD 2,83", NAS-5 DD 9,01% n 732 **[DICHIARATO, 1 anno]** | 🟢 **uscita a open+90'** (P4) |
| **ORB V2** — impostazioni · <https://www.mql5.com/en/blogs/post/751352> | min/max del range, SL **% del range**, fino a 3 rotture, daily loss limit | *"NON usare i default"* (nessun valore consigliato) | nessuno | 🟡 conferma min/max range |
| **ORB "stocks in play"** (QuantConnect, da Zarattini-Barbon-Aziz) · <https://www.quantconnect.com/research/18444/opening-range-breakout-for-stocks-in-play/> | **volume relativo**: volume dei primi 5' / media 14 giorni, solo i top 20 | range 5'-25', stop in ATR14 | Sharpe 2,396 (2016) **[DICHIARATO]**; "~25% dei rendimenti in commissioni" (commenti) | 🟢 **volume relativo** = il nostro `InpUseVolumeFilter` (P5) |
| **Replica ORB 5 indici** (Krueger, 25/09/2026) · <https://www.mql5.com/en/blogs/post/776235> | 5', TP 10R o chiusura | costi 0,8-4 pt | **Dow netto -0,081 R** (lordo +0,048) | 🔴 prior di famiglia |
| **Range Breakout Day Trader** · <https://www.mql5.com/en/blogs/post/760349> | trend (TF a scelta), news con chiusura, giorni della settimana | — | — | 🟡 news (gia' nell'EA) |

### 5.2 Gia' misurato in casa
- 🔴 **Gap-down continuazione sullo S&P**: sonda del 25/09 **t 0,49 = NO** (`REGISTRO_TEST` r.4202).
  Il filtro "short solo dopo gap-down" per gli indici USA **ha gia' la sua sonda negativa**.
- 🟠 **Filtro volumi su NASUSD (R84b)**: IS PF **1,254 → 0,876**, OOS **0,873 → 0,950**, DD OOS **17,1% →
  4,6%**, n OOS 291 → 92 (`risultati_archivio/r84_csv/`). Lezione: **il filtro volumi e' un
  ammazza-DD, non un generatore di PF**.
- 🟠 **Pavimento d'ampiezza su NASUSD (R196A)**: IS su, OOS giu' = selezione (`REGISTRO_TEST` r.4142).
  Il `InpMinRangePts` sul Dow short **non si propone** per la stessa ragione.
- 🪦 `ABTG_VwapRevert` (VWAP come **motore**) falsificato il 03/09 — la VWAP come **filtro di lato** e'
  un'altra cosa e non e' mai stata accesa sul Dow.

### 5.3 Proposte (`ABTG_Dow_Apertura_US.mq5`, base = R255a/b ancora, stessi pin)
Metro: **93-102 s per file** (R255 §14); una configurazione = **2 file** (orologi 14:30 e 15:30) ≈
**3,3 min**.

| # | proposta | input esatti | costo | cosa puo' rompere |
|---|---|---|---|---|
| **P4** | ⏱️ **stop a tempo a open+90'** | `InpCloseHour=16` `InpCloseMin=0` (file 14:30) · `InpCloseHour=17` `InpCloseMin=0` (file 15:30) — oggi 17:30/18:30 | 2 file ≈ **3,3 min** | taglia i trend della giornata: sul long 770202 il trailing M5 e' stato la vittoria (PF 1,24 → 1,37) |
| **P5** | 📊 **volume relativo** | `InpUseVolumeFilter=true` · `InpVolMult=1.5` · `InpVolAvgBars=20` (default, = regola Emiliano) | 2 file ≈ **3,3 min** | n: da 73 per finestra a ~23-29 **[STIMA dai rapporti di R84b, x0,32 OOS / x0,40 IS]** → merito sospeso; il DD si legge |
| **P6** | 📉 **VWAP come filtro di lato** | `InpUseVwapFilter=true` · `InpVwapTF=M15` | 2 file ≈ **3,3 min** | 🔴 la VWAP dell'EA e' **ancorata all'inizio del GIORNO server** (r.1462), non all'apertura cash: include la notte. Va dichiarato nel file prova |
| — | ATR ≥ media (`InpUseAtrFilter`) | esiste (r.320-322) | 2 file | non in top 10: su NASUSD R84c OOS PF **0,97** — stesso ruolo del P5 |

---

## 6. 🔴 FAMIGLIA 4 — LONDRA ORB GBPUSD/EURUSD (`ABTG_Londra_ORB`)

**Stato di casa:** il motore del PDF **non e' mai nato** (0 CSV); R258 (24 file, 158 celle, 316
passate) **in coda**, SL al centro in tutti i blocchi. Tappo dichiarato: **il costo** (W >= 61,2 pip).
**La sonda §2.1 lo trasforma in un numero: il 2,2% dei giorni.**

### 6.1 Tabella degli esempi

| esempio · URL | canale | ampiezza | SL / TP | numeri | cosa ne copiamo |
|---|---|---|---|---|---|
| **Asian Range Breakout EA** (nsclk, MIT) · <https://github.com/nsclk/Asian-Range-Breakout-Expert-Advisor-for-MT5> | **Asia 0-7 (estate) / 1-8 (inverno)** | **min 10 / max 100 pip** | TP **1,5 x SL**, spread max **3 pip** | nessuno | 🟢 il canale **lungo** (P8) |
| **GoldLondonBreakout** · <https://www.mql5.com/en/code/75586> | Asia 00-07, ordini 07-11 | **0,15-0,70 ATR D1** | SL 1,2 ATR, TP 1,8R | nessuno | 🟡 ampiezza relativa |
| **Easy Range Breakout EA** (O. Sandoval Espinosa, 10/04/2026, agg. 11/09/2026) · <https://www.mql5.com/en/code/71460> | esempio 05-11, fine 22 | — | **SL al bordo OPPOSTO**, **TP = ampiezza del range** | nessuno; **8 bug** segnalati da un revisore | 🟢 conferma lo **SL opposto** (P7) |
| **Range Breakout Day Trader** · <https://www.mql5.com/en/blogs/post/760349> | libero | min/max altezza | SL **= distanza del range** (0 = usa il range) | — | 🟢 idem |
| **London Breakout GbpUsd M15** (M. Kupka, 2019, 99 $) · <https://www.mql5.com/en/market/product/43693> | — | — | ATR SL, TP fisso, **chiusura venerdi' 21:00 UTC+2** | "12+ anni tick, Monte Carlo, WFA" **[DICHIARATO senza numeri]** | 🔴 niente: ingresso su **divergenza RSI**, non e' un range |
| **Range Breakout Beast** · <https://www.mql5.com/en/blogs/post/765033> | 03-06 | **0,10-0,50% del prezzo** | SL oltre il range | — | 🟡 su GBPUSD a 1,30: 0,10% ≈ **13 pip** |

### 6.2 Proposte (`ABTG_Londra_ORB.mq5` r.30, r.60-62; `ABTG_MaxMinNotte.mq5`)
Metro R258 §10: **~5-9 s a passata** a tick.

| # | proposta | input esatti | costo | cosa puo' rompere |
|---|---|---|---|---|
| **P7** | 🧱 **blocco S di R258: SL all'estremo OPPOSTO, senza dimezzare** | `InpSLMode=1` (`LDN_SL_OPPOSITE`) · `InpHalveOnOpposite=false` (altrimenti si misurano due cose: `ANALISI_PDF_LONDRA` r.266) · `InpTPRangeMult` 1,5 / 2,0 (con TP=1,0 l'R:R e' **0,91**, r.155) · `InpMinRangePips` **31** (GBPUSD) / **24** (EURUSD) = soglia 40x all-in con SL opposto · orologio 07-08 UK | 2 file × 2 celle × 2 gambe ≈ **1 min** | 🔴 deviazione **dichiarata** dal PDF (lo SL del PDF e' al centro). Frequenza: **~26%** dei giorni prima del riempimento → sui ~2 anni di tick (pavimento **2024.07.05**) **merito sospeso quasi certo**; cio' che si legge e' **costo e rischio** |
| **P8** | 🌏 **la London breakout classica sul BOX ASIATICO**, via `ABTG_MaxMinNotte` | box `InpBoxStartHour=0` `InpBoxEndHour=7` `InpBoxEndMin=59` · `InpPlaceHour=8` · `InpEntryCutoffHour=11` · `InpCloseHour=17` · `InpSLMode=0` · **`InpBufferPoints=30`** (3 pip; l'unica corsa EURUSD d'archivio usava **1000 = 100 pip** → 1 e 0 trade = **mai misurato**, `risultati_prove/ABTG_MaxMinNotte/ABTG_MaxMinNotte_EURUSD_*_ohlc.csv`) · `InpMinBoxPts` 306 (GBPUSD) / 236 (EURUSD) · lati separati | **0 codice** · 2 simboli × 2 lati × ~3 celle TP2 ≈ **2-3 min** · box 00:00-07:59 dello stesso giorno **gestito dal codice** (`ComputeBox` r.301-306: toglie un giorno solo se inizio >= fine) | 🟠 **prior debole**: sonda §2.2 piatta, long negativo in 12/12. 🕰️ Orologio: server BCM **= ora di Londra** fino al cambio di fine 2024 (Passo 0 di `AllineaLondra`), poi UTC+1 fisso = **Londra+1 d'inverno**: la cella in ora fissa misura un'ora diversa negli inverni 2025 e 2025/26 |
| — | ampiezza minima sul canale 60' con SL al centro | `InpMinRangePips` 61 | — | **inutile scriverla**: e' gia' la riga F=70 del blocco T, e la sonda la da' al **2,2%** dei giorni |

---

## 7. 🌙 FAMIGLIA 5 — NIGHTLY FADE (`ABTG_Nightly`)

**Stato di casa:** EURUSD/GBPUSD/USDCHF (OHLC) ed EURCHF (tick) **bocciati** (6 finestre su 8 sotto
1); i sei simboli a zero **mai misurati**, R259 (6 file, 12 celle) **in coda**; R220a-d (`InpSLpips`)
**in coda**. Regola del 19/08: **niente allargamenti d'ingresso** sui quattro gia' bocciati.

### 7.1 Tabella degli esempi

| esempio · URL | meccanismo | coppie | uscita / filtri | numeri | cosa ne copiamo |
|---|---|---|---|---|---|
| **Night Scalper by NoCap FX** (B. Larsen, 199 $ o 75 $/mese) · <https://www.mql5.com/en/market/product/124331> | **Buy Limit + Sell Limit piazzati all'inizio della sessione**, scadono a fine finestra = **il nostro fade ai bordi** | **AUDNZD**; "coppie amiche della reversione: **AUD, CAD, NZD, CHF**" | **chiusura forzata dentro la finestra**; *"lo spread alto distrugge la profittabilita'"* | "+88% live" **[DICHIARATO]** | 🟢 **i simboli** (P9b) · 🟢 l'uscita a tempo (P9a) |
| **Night Scalper EA MT5** (Robots4Forex, 14/03/2019, 30 $) · <https://www.mql5.com/en/market/product/36779> | reversione a RSI, ordini a mercato | default EURUSD M15; AUDUSD, GBPUSD, NZDUSD, USDCAD, USDCHF | SL **25-200 pip** (gamma), TP 0-100; **TP che si riduce col tempo** fino a un pavimento; chiusura venerdi' | "vedi i commenti" | 🟡 il **TP decrescente** (nessun input da noi: codice) |
| **Blazing Night Scalper MT5** (S. Fredeman, 99 $, v3.96 del 23/08/2025) · <https://www.mql5.com/en/market/product/72234> | scalping notturno **con GRIGLIA DI RECUPERO** | AUDCAD, AUDCHF, AUDUSD, CADCHF, EURUSD, GBPAUD | "close by hour 2" | 🔴 **bandiera rossa: griglia**. Unico dato utile, dal vendor stesso: *"dal 2022 i night scalper sono diventati via via piu' difficili"* (spread) **[DICHIARATO]** | 🔴 niente del motore |

### 7.2 Proposte (`ABTG_Nightly.mq5`, base = R259)
Metro R259: **~29 min per 24 passate [tetto]** ≈ ≤ 1,2 min/passata.

| # | proposta | input esatti | costo | nota |
|---|---|---|---|---|
| **P9a** | ⏱️ uscita a tempo sulla notte | `InpCloseAtCutoff` 0/1 (r.57; cutoff `InpCutoffHour=7`) — una cella in piu' per file R259 | 6 celle ≈ **≤ 7 min** | e' una casella ③ (uscita) sui **sei simboli nuovi**, non un allargamento d'ingresso |
| **P9b** | 🔁 simboli gemelli "da reversione" del vendor | stessi pin di R259a (AUDUSD) su **AUDNZD, AUDCAD** con `InpBlockNightActive=0`, `InpMaxNightVolPips=45` | 2 file × 2 celle ≈ **≤ 5 min** + 🔴 **prerequisito**: esistenza dei simboli e dei loro tick a BCM **[NON VERIFICATO]** (la sonda del 17/08 legge `SpreadPt=0` su piu' croci AUD) | EURCHF (l'altra "coppia amica") e' gia' **bocciato per rischio** a tick (`REGISTRO_TEST` r.3546) |
| — | QB "in unita' giuste" su oro/indici | `InpMaxNightVolPips` in punti (~950 oro, prezzi 2015-2020) | — | **non serve**: §2.4, il QB del PDF e' quasi inerte (0,4%), R259 con 0 e' fedele |

---

## 8. 📈 FAMIGLIA 6 — EMA200 H4 A DUE LATI (`ABTG_EMA200`)

**Stato di casa:** R139a/b (OHLC dal 2010) **FAIL S3**: DD IS > 14% in tutte le celle (AUDJPY 15,4-20,4%,
GBPUSD 17,7-20,3%). R264 (17 file: O1/O2 oltre il bordo + `InpTP1Pct`) e R265 (EURUSD short) **in
coda**. 🔴 **`InpUseAdrFilter` e' `false` in TUTTI i file prova che lo nominano** (`LATI_A1/A2`,
`MIS_SIZING`): filtro codificato (r.61-65) e **mai misurato**. Idem `InpFridayClose` (r.102).

### 8.1 Tabella degli esempi

| esempio · URL | filtro | valori | uscita | numeri | cosa ne copiamo |
|---|---|---|---|---|---|
| **ADX Trend Pullback EA** (Duy Van Nguy, 14/06/2026, agg. 11/09/2026) · <https://www.mql5.com/en/code/73958> | **ADX(14) > 25 E in salita** sulla barra precedente; lato da **+DI/-DI** | EMA **20**, pullback = distanza in ATR **>= 0,5** che poi rientra; TF indicatori **H1** | SL **1,5 ATR**, TP **2,0 R**, 1 posizione per simbolo | nessuno | 🟡 ADX: **nessun input nostro** → codice (§8.3) |
| **Forum MQL5 "Multi-layer directional filter for XAUUSD"** (27/05-03/06/2026) · <https://www.mql5.com/en/forum/510341> | pendenza **EMA50 su 5 barre**, RSI14 > 55 blocca le vendite, **ADX14 classificato ULTIMO** | buffer 0,05% sulla EMA → consiglio: **in ATR** | H4 come **conferma morbida**, non AND duro | AUC vendite **> 0,62** OOS 2025-26; acquisti **0,50-0,55 = overfitting** **[DICHIARATO]** | 🟡 l'ADX **non** e' il filtro migliore secondo chi l'ha misurato; la pendenza si' |
| **Gold Asian Breakout** · <https://www.mql5.com/en/market/product/166774> | trend HTF Weekly SMA100 | — | BE + trailing | — | 🟡 |
| **London Breakout GbpUsd M15** · <https://www.mql5.com/en/market/product/43693> | — | — | **chiusura venerdi' 21:00 UTC+2** "contro i gap del weekend" | — | 🟢 = `InpFridayClose` (P10b) |

### 8.2 Proposte (`ABTG_EMA200.mq5`, base = R264 `*_o2_*` della cella centrale per simbolo)
Metro R264: OHLC lungo **10-40 s/passata**; tick (solo `*_controllo`) T = 0,6 + 0,077 × passate min.

| # | proposta | input esatti | costo | cosa puo' rompere |
|---|---|---|---|---|
| **P10a** | 📏 **distanza raggiungibile rispetto all'ADR** (filtro di casa, mai acceso) | `InpUseAdrFilter` 0/1 · `InpAdrDays=50` · `InpAdrDistMax` **0,8** (guida Paolo, r.65) — ancora = cella a 0 | 4 simboli × 2 celle × 2 gambe OHLC ≈ **3-11 min** | toglie gli ingressi lontani dalla media = forse proprio i pullback profondi (O2) che il genetico ha premiato |
| **P10b** | 📅 flat il venerdi' | `InpFridayClose=1` · `InpFridayCloseHour=20` (server; = 21 IT d'estate, **ricontrollare l'orologio d'inverno**, `OROLOGIO_BCM` 24/09) | 4 simboli × 2 celle ≈ **3-11 min** | taglia i trend H4 che attraversano il weekend: e' una leva sul **DD** (il tappo di R139), non sul PF |
| — | ADX / pendenza EMA | **nessun input** in `ABTG_EMA200` | ~2 h di codice (2-3 input) | non in top 10: il forum stesso classifica l'ADX ultimo; la pendenza e' l'idea migliore, da scrivere **solo** se R264 lascia vivo almeno un simbolo |

---

## 9. 🏆 LE 10 PROPOSTE, IN ORDINE (resa per ottobre / costo)

| # | famiglia | proposta | input | costo macchina | codice | perche' in questa posizione |
|---:|---|---|---|---|---|---|
| **1** | ORO 770402 | **P1 notizie USD: blocco/chiusura** | `InpUseNewsFilter`, `InpNewsCurrencies="USD"`, `InpNewsFlatten` 0/1 | 3 celle ≈ 1-2 min OHLC | 0 (🔴 file news nel tester da verificare) | la sedia piu' vicina, tappo = DD, 693 deal di budget per un filtro |
| **2** | ORO 770402 | **P2 ampiezza box relativa** | proxy `InpMinBoxPts`/`InpMaxBoxPts`; giusto: `InpMinBoxAtrD1`/`InpMaxBoxAtrD1` | 5 celle ≈ 2-3 min | 0 (proxy) · 1-2 h (ATR) | tre fonti indipendenti lo usano; sonda: da solo non basta |
| **3** | DOW SHORT | **P4 stop a tempo open+90'** | `InpCloseHour` 16/17, `InpCloseMin=0` | 2 file ≈ 3,3 min | 0 | unica uscita pubblica che R255 non ha |
| **4** | DOW SHORT | **P5 volume relativo** | `InpUseVolumeFilter=1`, 1,5, 20 | 2 file ≈ 3,3 min | 0 | precedente di casa: DD /3,7 su NASUSD |
| **5** | LONDRA | **P7 blocco S: SL opposto, niente dimezzo, TP 1,5-2 W, min 31/24 pip** | `InpSLMode=1`, `InpHalveOnOpposite=0`, `InpTPRangeMult`, `InpMinRangePips` | ≈ 1 min | 0 | l'unica geometria del canale 60' che passa il costo (26% dei giorni) |
| **6** | EMA200 | **P10a filtro ADR** (+ **P10b** venerdi') | `InpUseAdrFilter`, `InpAdrDistMax=0,8` · `InpFridayClose` | 3-11 min per ciascuno | 0 | filtro di casa mai acceso; attacca il DD di R139 |
| **7** | DOW SHORT | **P6 VWAP di lato** | `InpUseVwapFilter=1`, M15 | 2 file ≈ 3,3 min | 0 | mai acceso sul Dow; ancoraggio da dichiarare |
| **8** | NIGHTLY | **P9a uscita al cutoff** (+ **P9b** AUDNZD/AUDCAD) | `InpCloseAtCutoff` · simboli | ≤ 7 min (+ ≤ 5) | 0 | chiude la casella ③ sui sei nuovi; il vendor chiude in finestra |
| **9** | LONDRA | **P8 box asiatico via MaxMinNotte** | box 0-7:59, `InpBufferPoints=30`, `InpSLMode=0` | 2-3 min | 0 | passa il costo nel 68% dei giorni, ma sonda piatta |
| **10** | DAX LONG | **P11 trend DAX stesso + uscita ③** | `InpCorrSymbol="D30EUR"` H4/D1 · `InpUseTrailing`/`InpBreakeven`/`InpTP1Pct` | ≈ 2-4 min | 0 | completa il certificato; prior 0/33 |

**Totale se si girasse tutto:** ~**35-60 minuti** di tester sul **PC di backtest** (mai il VPS: firma
del 21/09) + un prerequisito (file news nel tester) + opzionali 1-2 h di codice per l'ATR del box.
Fuori classifica ma **da dire**: **P3** (trend dell'oro, 1 min, atteso NO dalla sonda) e il gia'
scritto **R193b** (curva DD-taglia dell'oro, 8 passate ~2 min), che **viene prima di tutto** perche'
risponde alla domanda vera dell'oro con la firma di Claudio accanto.

---

### 9.1 🚩 Bandiere rosse e setaccio dei caduti (applicati a tutti i 21 esempi)
- 🔴 **Scartato per griglia**: `Blazing Night Scalper MT5` ("grid recovery" dichiarata dal vendor). Nessun
  altro esempio letto dichiara martingala, griglia, recovery o assenza di SL; sei lo **escludono per
  iscritto** (Gold Asian Breakout, Range Breakout EA, Night Scalper NoCap, London Breakout GbpUsd,
  Ger40 Morning Breakout, Range Breakout Beast con SL obbligatorio).
- 🟠 **Numeri di vendor senza misura**: "+300% live 23 mesi" (Eriksson), "+88% live" (NoCap), "DD 2,5%"
  (Terpstra), "ROD 2,5-5,1" su **un anno** (Samson): **non pesano** su nessuna proposta.
- 🪦 **Setaccio di `REGISTRO_TEST.md` / archivio, per nome**: stop in ATR sull'oro (`oro_maxmin_fase1_*`,
  §3.2) · gap-down continuazione sullo S&P (r.4202, t 0,49) · pavimento d'ampiezza NASUSD (R196A, r.4142)
  · VWAP come motore (`ABTG_VwapRevert`, r.1274) · R45 0/48 Londra (motore diverso, non copre il PDF) ·
  Nightly su EURUSD/GBPUSD/USDCHF/EURCHF (niente allargamenti d'ingresso). **Nessuna delle 14 proposte
  ripete uno di questi**; le due che gli somigliano (P5 volumi, P7 SL opposto) portano accanto il
  precedente e cosa cambia.

---

## 10. 🧪 I CONTRO-ESEMPI — provati contro le mie stesse conclusioni

1. **"La sonda Londra e' 2015-2020, BCM 2024-2026 potrebbe avere canali piu' larghi."** Vero, e per
   questo la previsione di §2.1 e' scritta **prima** di R258: la mediana 07-08 per anno sta fra **18,9
   e 28,2** in sei anni che includono **Brexit (2016) e Covid (2020)**; per arrivare a 61 servirebbe un
   regime ~2,5 volte piu' largo del piu' largo visto. La curva `Trades(b=3,F)` di R258 decide.
2. **"Lo stop opposto (P7) non e' il PDF."** Esatto: e' una **deviazione dichiarata**, e il PDF alla
   lettera resta il blocco T. Il PDF stesso nomina la variante prudente con SL all'estremo opposto
   (`ANALISI_PDF_LONDRA` §3): cambiamo **solo** il dimezzamento dei lotti e il TP, per non avere R:R 0,91.
3. **"Il filtro notizie sull'oro (P1) potrebbe togliere proprio i giorni buoni."** Si', e lo scrivo come
   rischio: e' per questo che le celle sono tre (blocco senza chiusura / chiusura / spento). Se il PF
   scende quanto il DD, la leva non esiste e si torna alla sola taglia.
4. **"La sonda oro con uscita semplificata non e' la sedia."** Vero: non la uso **mai** per il merito
   della sedia (R103 resta il numero), solo per il **verso** di due filtri pubblici. Sul verso del
   trend (-0,031 contro +0,179) ho n 97/54: e' un'indicazione, non un certificato — per questo P3 resta
   in lista a 1 minuto di costo invece di sparire.
5. **"Il QB inerte (§2.4) potrebbe dipendere dall'orologio della sonda."** L'ATR14 H1 alle 05:00 media
   14 ore (dalle 15 del giorno prima): uno spostamento di un'ora cambia 1 barra su 14. Per portare la
   quota da 0,4% a qualcosa che morde servirebbe un ATR H1 notturno **3,7 volte la mediana**.

---

## 11. 🕳️ COSA NON HO POTUTO VEDERE

| buco | conseguenza |
|---|---|
| **Forex Factory 403** (ancora) | nessun thread "challenge passed/failed" sui box notturni |
| **erikssonsystems.com murato** | i valori del "breakout filter" del Range Breakout EA (649 $, XAUUSD/US30/DE40) — **l'unico prodotto con segnale live 23 mesi** — restano ignoti |
| **newyorkfed / Liberty Street / CBS / fedinprint murati** | "overnight drift sparita dal 2021" e' solo un **estratto di ricerca**: **[INCERTO]**, non citato come fatto |
| **quantifiedstrategies / cxoadvisory / danfin / fxvps / tradertom murati** | niente statistiche pubbliche long/short sul DAX e sull'ORB d'apertura |
| **nessun `.set` pubblico con valori** | i set dei vendor (Range Breakout Day Trader, ORB V2, Eriksson) stanno dietro download o siti murati: la tabella ha **default dichiarati**, non preset |
| **Oanda dati fino al 14/05/2020** · **histdata XAUUSD troncato** | nessuna sonda esterna sul regime 2021-2026 |
| **DAX notturno fuori** | nessuna sonda: la notte del DAX non esiste in `GRXEUR` histdata e `DE30_EUR` Oanda e' 404 |
| **simboli AUDNZD/AUDCAD a BCM** | P9b ha un prerequisito **[NON VERIFICATO]** |
| **file news nel tester per `ABTG_MaxMinNotte`** | P1 ha un prerequisito **[NON VERIFICATO]** |

---

_Redatto il 26/09/2026 sul branch `lavoro` (HEAD `98c0b703` alla lettura). Fonti di casa lette:
`report/STATO_MAXMIN_DAX_LONG_E_ORO_2026-09-26.md`, `report/NIGHTLY_SEI_SIMBOLI_2026-09-26.md`,
`caccia_strategie/ANALISI_PDF_LONDRA_2026-09-26.md`, `report/SWEEP_MECCANISMI_2026-08-23.md` §M1,
`REGISTRO_TEST.md` (r.640-700, 1335-1370, 2588-2640, 2830-2860, 4142, 4180-4255),
`prove/R255a`, `R258a` §7 e §10, `R260a`, `R264_TESTA.txt.in`, i sorgenti `ABTG_MaxMinNotte.mq5`,
`ABTG_Dow_Apertura_US.mq5`, `ABTG_Londra_ORB.mq5`, `ABTG_Nightly.mq5`, `ABTG_EMA200.mq5`, i CSV
`risultati_archivio/MaxMin_Oro/`, `r84_csv/`, `risultati_prove/ABTG_MaxMinNotte/`. Nessun EA, preset,
file prova, forward o conto toccato; nessuna taglia proposta: le taglie restano di Claudio._
