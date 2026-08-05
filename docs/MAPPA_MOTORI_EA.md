# 🗺️ Che motore usa ogni EA — mappa rapida

_Nata il 05/08 da una domanda di Claudio ("la SuperWave non è su quell'incrocio?"). Con 64 file in cartella confondersi è normale._

⚠️ **Distinzione che conta:** il **motore del segnale** è ciò che decide *se e quando* entrare. I **filtri** sono interruttori che possono solo *togliere* trade, e nelle aperture sono **spenti di default**. Una scansione automatica li confonde: questa mappa li tiene separati.

## Il motore del segnale

| Motore | EA |
|---|---|
| **Incrocio EMA 9/21** | **`ABTG_GoldenCross`**(+`_Ottimizzato`) ← *l'unico sul 9/21* |
| **Incrocio EMA 14/200** (accettato solo se concorde col Supertrend) | **`ABTG_SuperWave`**(+`_DAX_H4_Ottimizzato`, `_DOW_H1_Ottimizzato`) |
| **Rimbalzo sul Supertrend** (tocca e chiude vicino, poi conferma) | `ABTG_SupertrendReversal`, `_Multi`, `ABTG_SuperWave_EA`, `ABTG_SupertrendInvert` |
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

## ⚠️ Attenzione al `ABTG_SuperWave`: l'intestazione mente

Il file **`ABTG_SuperWave.mq5`** porta ancora in cima il commento del suo progenitore (`ABTG_SupertrendReversal`), che descrive il rimbalzo sul Supertrend. **Il codice non fa quello.** Il segnale vero è alle righe 176-195:

```mql5
//--- SEGNALE SuperWave: incrocio EMA14 x EMA200 sulla barra chiusa [1],
//    ACCETTATO solo se a favore del Supertrend (dir[1]).
bool crossUp = (e14[0] <= e200[0]) && (e14[1] > e200[1]);
bool crossDn = (e14[0] >= e200[0]) && (e14[1] < e200[1]);
```

Quindi **la SuperWave È un motore a incrocio di medie** — ma **14/200**, non 9/21. Il Supertrend (10; 3,5) qui fa da **cancello direzionale** (cross rialzista scartato se il Supertrend è giù) e da **trailing/uscita su flip**, non da innesco. `InpUseConfluence` è `false` e infatti la funzione `ConfluenceOK()` non viene mai chiamata dal ramo del segnale.

Chi fa davvero il rimbalzo sul Supertrend: `ABTG_SupertrendReversal`, `_Multi`, `ABTG_SuperWave_EA`.

## 📌 Perché la domanda era buona

Claudio ha chiesto *"la SuperWave non è su quell'incrocio?"*. La risposta corretta è: **sì, è su un incrocio — ma sul 14/200, non sul 9/21**. Le due EMA della domanda (9 e 21) le opera **solo `ABTG_GoldenCross`**, con parecchio sopra: allineamento con la EMA 50, Heiken Ashi, ADX/DI, filtro di distanza dall'ATR. Ed è tarato su **H1**.

→ Quindi *"perché il 9/21 non ha tradato l'oro?"* ha due risposte: sull'oro non c'è nessun EA 9/21 attaccato, e comunque il GoldenCross non è il cross nudo che si vede su TradingView.
