# 🗺️ Che motore usa ogni EA — mappa rapida

_Nata il 05/08 da una domanda di Claudio ("la SuperWave non è su quell'incrocio?"). Con 64 file in cartella confondersi è normale._

⚠️ **Distinzione che conta:** il **motore del segnale** è ciò che decide *se e quando* entrare. I **filtri** sono interruttori che possono solo *togliere* trade, e nelle aperture sono **spenti di default**. Una scansione automatica li confonde: questa mappa li tiene separati.

## Il motore del segnale

| Motore | EA |
|---|---|
| **Incrocio EMA 9/21** | **`ABTG_GoldenCross`** ← *l'unico* |
| **Rimbalzo sul Supertrend** (tocca e chiude vicino, poi conferma) | `ABTG_SupertrendReversal`, `_Multi`, `ABTG_SuperWave`, `ABTG_SuperWave_EA`, `ABTG_SupertrendInvert` |
| **Rottura del range di apertura** | `ABTG_DAX_Apertura_EU`, `ABTG_Nasdaq_Apertura_US`, `ABTG_Dow_Apertura_US`, `ABTG_Apertura_Marco`, `ABTG_DAX_Live5m`(+v2), `ABTG_Nasdaq_Live5m`, `ABTG_ORB`, `ABTG_Londra_ORB` |
| **EMA 200** (trend-following classico) | `ABTG_EMA200`, `ABTG_PTE`, `ABTG_WOL`, `ABTG_MaxMinNotte` |
| **Fibonacci** | `ABTG_FiboH4_Multi`, `ABTG_ORB_Fibo` |
| **Ichimoku** | `IchiTrend_Gold_Base` |
| **HARSI** | `ABTG_HARSI` |
| **Eventi macro** | `ABTG_PostNews` |
| **Nessuno** (utilità) | `ABTG_Guardian` (sorveglia il DD), `ABTG_TradeExporter` (scrive il CSV per la pagella) |

## I filtri (opt-in, spenti di default)

Gli EA delle aperture condividono lo stesso motore e portano dentro una cassetta di filtri accendibili: **Supertrend**, **EMA di trend**, **VWAP**, **correlazione con SPX**, **volumi**, **ATR**, **numeri tondi**, **news**.

Vederli nel sorgente **non** significa che siano attivi. Al 05/08, dopo l'ablazione:

| Filtro | Verdetto |
|---|---|
| **Volumi** | ✅ funziona **solo sul Nasdaq** (PF 0,90 → 1,15) |
| **Trend EMA su H4** | ✅ funziona **solo sul Dow** (1,03 → 1,24) · ❌ danneggia gli europei |
| ATR, correlazione SPX, Supertrend×3, VWAP, numeri tondi | ❌ rumore o danno |

## 📌 Perché la domanda era buona

La **SuperWave** non guarda l'incrocio 9/21: è un motore **Supertrend (10; 3,5)**. Le sue EMA 14/89/100/200 servono solo a dire *"il rimbalzo è avvenuto vicino a una media"*, e la confluenza è pure `false` di default.

**L'unico EA che opera l'incrocio 9/21 è `ABTG_GoldenCross`** — con però parecchio sopra: allineamento con la EMA 50, Heiken Ashi, ADX, filtro di distanza dall'ATR. Ed è tarato su **H1**.

→ Quindi *"perché il 9/21 non ha tradato l'oro?"* ha due risposte: sull'oro non c'è nessun EA 9/21 attaccato, e comunque il GoldenCross non è il cross nudo che si vede su TradingView.
