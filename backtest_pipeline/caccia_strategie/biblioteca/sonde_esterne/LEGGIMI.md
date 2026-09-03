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
2. **Fuso: histdata e' in EST**, non in ora server BCM. Per le sonde di
   CONTEGGIO non cambia il totale; per un filtro orario **va convertito**.
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
| `sonda_volexp.py` | compressione ATR → espansione: segnali/giorno per lato, take/stop, MFE/MAE |
| `sonda_volexp_wr.py` | stesso motore: tasso **TP-prima-di-SL** contro **controllo a ingressi casuali** |
| `sonda_vwapband.py` | banda ATR su ancora di sessione + rientro (fade): segnali/giorno, RR, MFE/MAE |
| `sonda_sweep.py` | sweep di micro-pivot(3,3) + rientro: segnali/giorno, take/stop, MFE/MAE |
| `sonda_sweep_wr.py` | stesso motore: TP-prima-di-SL contro controllo casuale |

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
