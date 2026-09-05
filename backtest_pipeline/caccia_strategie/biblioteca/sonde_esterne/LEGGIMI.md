# 🔬 SONDE ESTERNE — contare le occasioni SENZA MT5

_Nate il 03/09/2026 nella quinta battuta della caccia frequenza
(`CACCIA_FREQUENZA5_IMPLEMENTAZIONI_2026-09-03.md`)._

## A COSA SERVONO

Da quattro dossier di fila (31/08, 01/09, 02/09 ×2) sta scritto:
> _"Da questo ambiente **nessun agente puo' MISURARE una frequenza**: Yahoo,
> Stooq e Dukascopy sono murati al CONNECT."_

**Il 03/09/2026 quel buco e' chiuso**, e non con un sito nuovo: con un REPO
GITHUB che passa da `raw.githubusercontent.com` (canale gia' verde da 5
dossier). Vedi `PROMEMORIA_SBLOCCO_FONTI.md`, blocco del 03/09.

## LA FONTE DATI

`github.com/FutureSharks/financial-data` — **licenza GPL-3.0**, dichiarata
nel repo. Barre M1 OHLC(V).

| famiglia | percorso `raw` | simboli | anni |
|---|---|---|---|
| indici histdata (volume = 0) | `pyfinancialdata/data/stocks/histdata/<SYM>/DAT_ASCII_<SYM>_M1_<ANNO>.csv` | `SPXUSD` (S&P500), **`GRXEUR` (DAX 30, stessa scala di D30EUR)**, `JPXJPY` (Nikkei), `ETXEUR` (EuroStoxx) | 2010-2018 |
| Oanda (con volume, file MENSILI) | `pyfinancialdata/data/currencies/oanda/<SYM>/<ANNO>/oanda-<SYM>-<ANNO>-<MESE>.csv` | `NAS100_USD`, `SPX500_USD`, `US2000_USD`, `UK100_GBP`, `FR40_EUR`, `JP225_USD`, `AU200_AUD`, `XAU_USD`, `EUR_USD`, `GBP_USD`, `AUD_JPY`, `AUD_USD`, `USD_CAD`, `EUR_JPY`, `WTICO_USD`, `NATGAS_USD`, `USB10Y_USD`, ... | 2005-2020 |

Prefisso: `https://raw.githubusercontent.com/FutureSharks/financial-data/master/`

**Misurato il 03/09/2026:** `GRXEUR` 2014-2018 = 5 file, 200 OK, ~14,7 MB e
~213.000 barre M1 l'uno. `SPXUSD` 2016-2018 idem. `NAS100_USD/2018/…-3.csv`
= 200, 28.578 barre M1 **con volume**.

## ⚠️ I LIMITI, DA DICHIARARE SEMPRE ACCANTO A OGNI NUMERO

1. **NON e' il nostro broker.** BCM ha altri orari, altri spread, altri gap.
   Un numero di qui **non e' mai un verdetto**: e' una MISURA DI OCCASIONI.
2. 🔧 **FUSO — CORRETTO IL 05/09/2026, MISURANDO** (`CACCIA_TF_M15_2026-09-05.md` §3.1).
   Qui c'era scritto _"histdata e' in EST"_ (fisso): **e' sbagliato.**
   Misurato col minuto a piu' alta |variazione| media M1, separando i mesi
   invernali dagli estivi: **il picco NON si sposta** (SPXUSD 09:30 e 15:59 in
   entrambe le stagioni; GRXEUR 03:00 in entrambe). Quindi gli indici histdata
   sono in **ORA DI NEW YORK CON ORA LEGALE**, non in EST fisso.
   ➡️ **ora file + 5 = ora server BCM, tutto l'anno**, e il collaudo passa
   contro due verita' di casa (DAX 03:00 file = **08:00 server**; apertura USA
   09:30 file = **14:30 server**).
   ➡️ **I file Oanda sono invece in UTC**, verificato allo stesso modo (EURUSD
   picca a **13:30 in inverno e 12:30 in estate** = NFP delle 8:30 ET).
   ⚠️ Attenzione: per confrontare gli indici col calendario FF (che e' in UTC)
   serve la regola DST **americana**, non europea. Sta gia' dentro
   `sonda_salti_m15*.py` (funzione `us_dst`).
   🔧 Il collaudo si rifa' su qualunque fonte nuova con
   `sonda_orologio_fonte_esterna.py`: **si verifica l'orologio PRIMA di leggere
   qualunque altro numero.**
3. **Volume = 0 sugli indici histdata** → la VWAP vera non si calcola: si
   approssima con la media cumulativa di `hlc3`. **Va scritto.** Gli Oanda
   il volume ce l'hanno.
4. **OHLC M1, non tick.** L'ambiguita' intrabarra si risolve **sempre a
   sfavore** (se TP e SL cadono nella stessa barra → perdita).
5. **Zero costi, zero slippage** dentro queste sonde. Il costo si confronta
   a parte con `SPREAD_FLOTTA_MISURA_2026-09-03.md`.
6. **Finestra 2005-2020**: NON copre il regime 2024-2026 in cui girano le
   sedie. Copre pero' i regimi che a BCM sugli indici NON abbiamo
   (2011 crollo, 2015-2016 laterale, 2018 orso) — vedi emendamento §C.

## COSA C'E' QUI DENTRO

| file | cosa misura |
|---|---|
| 🆕 `sonda_m30_drift.py` | **M30, 05/09** — deriva per **mezz'ora del giorno** in punti indice (media, mediana, t, %>0) + sessione cash contro notte. **Ha chiuso M27**: la mezz'ora migliore del DAX su 1.518 sedute vale **0,33× il cancello 3× spread** |
| 🆕 `sonda_m30_crossasset.py` | **M30** — **correlazione ritardata** indice × valuta della stessa area (lag 0-3) + condizionamento a 1/1,5/2 σ con base di confronto. Un solo provider per le due gambe |
| 🆕 `sonda_m30_onid.py` | **M30** — reversione **overnight → intraday** univariata a quintili. I cancelli **K1-K4 sono scritti nell'intestazione del file**, non nel referto |
| 🆕 `sonda_m30_panel.py` | **M30** — pannello **cross-sezionale** overnight→intraday **+ la diagnosi dell'artefatto**: scomposizione per coppia, ingresso ritardato, controllo casuale. 🚨 **Da leggere prima di costruire qualunque pannello cross-fuso** (vedi il riquadro sotto) |
| 🆕 `sonda_fix_profilo.py` | **M5, 05/09** — collaudo F6 dei **FIX VALUTARI**: profilo del range M1 per minuto in ora di Londra, estate contro inverno. **Trova i tre fix nei dati** (WMR 15:59 = 1,34-1,45× il fondo; ECB 13:15 = 1,49×; Tokyo 01:55 = 1,93×) |
| 🆕 `sonda_fix.py` | **M5** — M11: run-up, **quota di rientro**, MFE/MAE/RR del fade a fix+1, controllo casuale |
| 🆕 `sonda_fix_cond.py` | **M5** — M11 condizionato al **quintile di run-up** (il meccanismo dichiarato dagli autori: rischio d'inventario dei dealer) |
| 🆕 `sonda_tondi.py` | **M5** — M23 **numeri tondi** (Osler): tocchi/giorno, rimbalzi contro rotture, MFE/MAE/RR su griglie 100/50/10 pip |
| 🆕 `sonda_tondi_wr.py` | **M5** — M23: **TP-prima-di-SL** contro controllo casuale **e contro controllo APPAIATO** (vedi il riquadro qui sotto) |
| 🆕 `uscite_m5_2026-09-05/` | le uscite grezze della battuta M5: salti EURUSD/DAX in **R**, lead-lag S&P→DAX, tondi appaiati |
| `sonda_volexp.py` | compressione ATR → espansione: segnali/giorno per lato, take/stop, MFE/MAE |
| `sonda_volexp_wr.py` | stesso motore: tasso **TP-prima-di-SL** contro **controllo a ingressi casuali** |
| `sonda_vwapband.py` | banda ATR su ancora di sessione + rientro (fade): segnali/giorno, RR, MFE/MAE |
| `sonda_sweep.py` | sweep di micro-pivot(3,3) + rientro: segnali/giorno, take/stop, MFE/MAE |
| `sonda_sweep_wr.py` | stesso motore: TP-prima-di-SL contro controllo casuale |
| 🆕 `sonda_orologio_fonte_esterna.py` | **collaudo dell'OROLOGIO** di una fonte dati: minuto a piu' alta \|variazione\| media, inverno contro estate. **Da girare per PRIMO su ogni fonte nuova** |
| 🆕 `sonda_salti_m15.py` | **salto statistico di Lee-Mykland (RFS 2008)** su M15: segnali/giorno, MFE/MAE/RR, WR contro controllo casuale, quota di salti su notizia |
| 🆕 `sonda_salti_m15_b.py` | stesso motore: split **con notizia / senza notizia** (contro il calendario FF di casa), per lato e per anno |
| 🆕 `sonda_salti_m15_c.py` | stesso motore: 🎯 **aspettativa E in R**, confrontabile col cancello H8 (0,075R), con **1R in punti e il costo in R** dichiarati in testa |
| 🆕 `sonda_salti_m15_d.py` | `_c` con geometria e orizzonte da ambiente (`SLM`/`TPM`/`HH`): serve a rispondere a *"muore di edge o di costo?"* |

Uso: `export S=<cartella con dati/>` e `python3 sonda_*.py`. I CSV vanno in
`$S/dati/<SYM>_<ANNO>.csv`.

## 🎯 LA COSA CHE VALE PIU' DEGLI SCRIPT: **IL CONTROLLO CASUALE**

Un tasso di vittoria da solo non dice niente: qualunque geometria SL/TP
produce un tasso. **La domanda giusta e' "quanto fa MEGLIO di un ingresso a
caso, con la stessa geometria, sugli stessi dati?"**

Il 03/09 la risposta e' stata: **su 16 celle e 32.339 segnali, il delta contro
il caso sta fra −3,9 e +3,5 punti percentuali, con media ≈ −0,70.** Due
meccanismi diversi, due indici, due timeframe, due lati: **nessuno dei due
distingue il proprio ingresso dal caso.**

➡️ **Regola d'uso: ogni sonda di conteggio futura porta il suo controllo
casuale.** Costa dieci righe e trasforma un numero in un confronto.

---

## 🔬 IL CONTROLLO CASUALE VA **APPAIATO** — correzione misurata il 05/09/2026

_(battuta M5, `caccia_strategie/CACCIA_TF_M5_2026-09-05.md` §5)_

Il controllo casuale **non appaiato** (l'ingresso di controllo cade a un'ora
qualsiasi) e' **artificialmente facile da battere**: i segnali si concentrano
nelle ore vive, dove un TP fisso e' raggiungibile; l'ora morta non ci arriva mai.

Misurato sugli **stessi identici segnali** (numeri tondi, EURUSD M5, 93.000+):

| controllo | delta apparente del meccanismo |
|---|---:|
| **casuale NON appaiato** | **da +6,72 a +12,67 punti** 🟢 sembra un edge |
| **APPAIATO** (stessa barra, stessa geometria, **lato opposto**) | **da −1,50 a +0,90 punti** 🔴 non c'e' niente |

➡️ **7-12 punti percentuali di artefatto.**

🖊️ **Regola d'uso, da qui in avanti:** il controllo di una sonda **direzionale**
e' **lo stesso ingresso, sulla stessa barra, dal lato opposto**. La media dei
due lati e' il valore atteso **esatto** di una monetina su quella barra:
**zero varianza, zero contaminazione da ora del giorno e volatilita'.**
Il controllo casuale non appaiato resta valido solo per domande **non
direzionali** (es. "questa geometria e' raggiungibile?").

✅ **Le lapidi del 03/09 non cambiano — si rafforzano:** L2 (sweep) e L3
(compressione) erano gia' a **−0,2 e −1,2 punti** contro un controllo
**generoso**; contro quello appaiato starebbero **piu' in basso**, non piu' in alto.

---

## 🚨 LA TRAPPOLA DEI PANNELLI CROSS-FUSO — trovata il 05/09 (battuta M30)

_(`caccia_strategie/CACCIA_TF_M30_2026-09-05.md` §4.4 — la sonda che la dimostra
e' `sonda_m30_panel.py`)_

Un pannello cross-sezionale overnight→intraday su **3 indici** (DAX, EuroStoxx,
S&P) rendeva **+29,64 bp al giorno, t = +8,49, 61,3% di giorni positivi**, contro
un controllo casuale a **−1,43 bp**. **E' tutto artefatto.**

> **La "notte" del mercato che apre DOPO contiene la "giornata" del mercato che
> apre PRIMA.**
>
> | | finestra di orologio |
> |---|---|
> | notte del **DAX** per il giorno t | 18:00 CET (t−1) → **09:00 CET (t)** |
> | notte dell'**S&P** per il giorno t | 22:00 CET (t−1) → **15:30 CET (t)** |
> | seduta del **DAX** del giorno t | **09:00 → 17:30 CET (t)** |
>
> Ordinare i tre indici sul rendimento notturno per decidere un trade sul DAX che
> **parte alle 09:00** usa un prezzo delle **15:30**: e' **look-ahead**, bandiera
> rossa §4.

**Le tre prove che lo inchiodano, e sono il modo giusto di smontare un numero
troppo bello:**
1. **scomposizione per coppia** → tutto il P/L sta nelle coppie Europa-vs-USA; la
   **sola coppia a stesso orario** (DAX vs ESTX50) e' **negativa in entrambe le
   direzioni** (−4,90 e −5,35 bp). E' la cella di controllo, ed e' rossa;
2. **ingresso ritardato** di 30 e 60 minuti → l'effetto **non muore** (+23,15 e
   +19,33 bp): quindi **non** e' prezzo stantio all'apertura;
3. **la versione univariata**, che non ha nessuno sfasamento di fuso, e' **piatta**
   (monotonia fallita su DAX e S&P, 2.775 coppie notte/giorno).

🖊️ **Regola d'uso:** prima di costruire qualunque sonda che confronti **due
mercati con sessioni sfasate**, si disegnano **le finestre di orologio delle due
gambe una sotto l'altra**. Se la finestra del predittore **si sovrappone** a
quella della risposta, il numero e' rotto — per quanto bello sia.
✅ Contro-esempio in casa: **`RELATIVO` NON e' esposto**, perche' lavora **solo
nella sovrapposizione** 14:30-22:00 server, dove i due mercati sono aperti
**insieme**, e non calcola nemmeno lo z-score fuori finestra.
