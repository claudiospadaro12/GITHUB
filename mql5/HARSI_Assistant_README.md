# HARSI Assistant — README

Trade-assistant per MetaTrader 5 basato sulla strategia **Heikin Ashi RSI Oscillator (HARSI)** di JayRogers.

Due componenti:

1. **`Indicators/HARSI_JayRogers.mq5`** — indicatore in sotto-finestra che replica l'HARSI.
2. **`Experts/HARSI_Assistant.mq5`** — l'Expert Advisor (assistente + trade manager).

---

## Installazione

1. Copia `HARSI_JayRogers.mq5` in `MQL5/Indicators/` e compilalo (F7 in MetaEditor).
2. Copia `HARSI_Assistant.mq5` in `MQL5/Experts/` e compilalo.
3. **Compila prima l'indicatore**: l'EA lo carica via `iCustom("HARSI_JayRogers", ...)`. Se non è compilato, l'EA fallisce in `OnInit`.
4. Trascina l'EA sul grafico; abilita "Algo Trading".

---

## L'indicatore HARSI_JayRogers

Pipeline (vedi commenti nel sorgente):

1. Costruisce candele **Heikin-Ashi** dai prezzi del grafico.
2. Calcola un **RSI di Wilder** (lunghezza 14 di default) su *ognuna* delle 4 serie HA (open/high/low/close), poi **ri-centra sottraendo 50** → oscilla in ~[-50, +50].
3. Dalle 4 serie RSI ri-centrate costruisce nuove candele "HA-RSI":
   - `haOpen  = (prevHaOpen + prevHaClose) / 2`
   - `haClose = (o + h + l + c) / 4`
   - `haHigh  = max(h, haOpen, haClose)`
   - `haLow   = min(l, haOpen, haClose)`
4. Le disegna come `DRAW_COLOR_CANDLES`. Verde = bullish (`haClose >= haOpen`), rosso = bearish.
5. Linea RSI overlay opzionale (RSI sul source, ri-centrata, con smoothing EMA).

### Livelli / fasce
Linee orizzontali a `+30, +20, 0, -20, -30`. Fascia **rossa** (overbought, `+20..+30`) e fascia **verde** (oversold, `-20..-30`) tramite i colori dei livelli.

### Buffer leggibili via iCustom
| Indice | Nome | Contenuto |
|---|---|---|
| 0 | `HA_Open`  | apertura candela HA-RSI ri-centrata |
| 1 | `HA_High`  | massimo candela HA-RSI |
| 2 | `HA_Low`   | minimo candela HA-RSI |
| 3 | `HA_Close` | chiusura candela HA-RSI (l'EA legge questo) |
| 4 | `HA_Color` | indice colore (0=verde/bull, 1=rosso/bear) |
| 5 | `RSI_Line` | linea RSI overlay ri-centrata + smoothing |

### Input indicatore
| Input | Default | Descrizione |
|---|---|---|
| `RSI_Length` | 14 | periodo RSI |
| `RSI_Smoothing` | 1 | smoothing EMA della linea RSI overlay |
| `SourcePrice` | Close | source della linea RSI overlay (Close oppure OHLC4) |
| `ShowRSILine` | true | mostra/nascondi la linea RSI |
| `UpperExtreme` | +30 | banda estrema superiore (~RSI 80) |
| `UpperMild` | +20 | banda lieve superiore (~RSI 70) |
| `LowerMild` | -20 | banda lieve inferiore (~RSI 30) |
| `LowerExtreme` | -30 | banda estrema inferiore (~RSI 20) |

---

## L'EA: HARSI_Assistant

### Input

**Rischio / Gestione**
| Input | Default | Descrizione |
|---|---|---|
| `RiskPct` | 1.0 | % del balance rischiata per trade |
| `RR` | 2.0 | reward:risk per il TP |
| `MaxConcurrentTrades` | 3 | max trade aperti contemporanei sul simbolo |
| `MaxTotalRiskPct` | 3.0 | tetto rischio totale aperto; blocca nuovi ingressi managed se superato |
| `SwingLookback` | 10 | barre per cercare swing high/low (per lo SL) |
| `SL_BufferPoints` | 50 | buffer extra oltre lo swing, in unità `_Point` |

**Comportamento**
| Input | Default | Descrizione |
|---|---|---|
| `ManageManualTrades` | true | aggancia SL/TP a posizioni aperte a mano (prive di SL o TP) |
| `AutoTradeSignals` | false | se true, auto-apre sul segnale HARSI alla chiusura barra. **Default OFF** |
| `ShowPanel` | true | mostra i pulsanti BUY/SELL sul grafico |
| `MagicNumber` | 20260626 | magic dell'EA |

**HARSI** (passati a `iCustom`): `RSI_Length`, `RSI_Smoothing`, `UpperExtreme`, `UpperMild`, `LowerMild`, `LowerExtreme` — devono combaciare con l'indicatore.

### Le 4 condizioni HARSI → codice

Valutate sulla **barra appena chiusa (index 1)**; per il flip serve anche index 2. Vedi `ShortConds()` / `LongConds()` in `HARSI_Assistant.mq5`.

**SHORT** (mean-reversion da overbought) — tutte vere:

| # | Condizione | Codice |
|---|---|---|
| 1 | HA-RSI chiusa nella fascia rossa | `haClose1 >= UpperMild` (+20) |
| 2 | RSI all'estremo (~80) | `rsi1 >= UpperExtreme` (+30) |
| 3 | flip colore a ribasso | `haClose2 > haOpen2 && haClose1 < haOpen1` |
| 4 | RSI gira giù | `rsi1 < rsi2` |

**LONG** (mirror, da oversold) — tutte vere:

| # | Condizione | Codice |
|---|---|---|
| 1 | HA-RSI chiusa nella fascia verde | `haClose1 <= LowerMild` (-20) |
| 2 | RSI all'estremo (~20) | `rsi1 <= LowerExtreme` (-30) |
| 3 | flip colore a rialzo | `haClose2 < haOpen2 && haClose1 > haOpen1` |
| 4 | RSI gira su | `rsi1 > rsi2` |

Al segnale l'EA disegna una freccia (`OBJ_ARROW_UP/DOWN`) sul bar e aggiorna il `Comment()` con lo stato delle 4 condizioni (`[X]`/`[ ]`), così puoi anche tradare manualmente. Se `AutoTradeSignals=true`, apre un trade managed.

### Lot sizing universale (parte critica)

Funziona su FX/indici/commodity perché deriva il valore monetario dal tick value/size del simbolo — niente pip/contratto hardcoded:

```
tickValue = SymbolInfoDouble(sym, SYMBOL_TRADE_TICK_VALUE);
tickSize  = SymbolInfoDouble(sym, SYMBOL_TRADE_TICK_SIZE);
moneyPerLotPerPricePoint = tickValue / tickSize;   // valore di 1.0 di prezzo, 1 lotto, in valuta conto
riskMoney = AccountInfoDouble(ACCOUNT_BALANCE) * RiskPct/100.0;
rawLot    = riskMoney / (stopDistancePrice * moneyPerLotPerPricePoint);
```
Poi clamp a `SYMBOL_VOLUME_MIN/MAX` e arrotondamento **DOWN** allo `SYMBOL_VOLUME_STEP`. Se il lotto minimo rischia più del budget, il trade è **rifiutato** con Alert. Vedi `CalcRiskLot()` / `MoneyPerLotPerPricePoint()`.

### Ingresso managed (pulsanti)

Click su **BUY x%** / **SELL x%**:
- SL: BUY → `min low ultime SwingLookback barre − buffer`; SELL → `max high + buffer`.
- `stopDistance = |entry − SL|` (entry = Ask per buy / Bid per sell).
- lot = lot a rischio (formula sopra); TP = `entry ± RR*stopDistance`.
- Prima di aprire: controlla `MaxConcurrentTrades` e `MaxTotalRiskPct` (somma rischio aperto + questo trade). Se violati → Alert e niente trade.
- Apertura con `CTrade`, SL/TP/Magic/commento impostati dall'EA.

### Gestione posizioni manuali/esterne (`ManageManualTrades`)

Ad ogni nuova barra scansiona le posizioni sul simbolo corrente:
- Per posizioni con `SL==0` o `TP==0` (aperte a mano), calcola SL dallo swing rispetto al **prezzo di apertura** e TP = `RR*stopDistance`, poi `PositionModify`. Riempie solo il valore mancante.
- Se la posizione è **over-sized** (`volume*|open−SL|*moneyPerLotPerPricePoint > RiskPct` del balance) → **Alert** soltanto (NON chiude né ridimensiona).
- Se le posizioni sul simbolo superano `MaxConcurrentTrades` → Alert.

`CurrentOpenRiskPct()` somma il rischio di ogni posizione aperta (con SL) e serve a far rispettare `MaxTotalRiskPct`.

---

## Come fare backtest

1. MetaEditor → compila indicatore poi EA (0 errori).
2. Strategy Tester → seleziona `HARSI_Assistant`, simbolo e timeframe desiderati.
3. **Modello: "Every tick based on real ticks"** (l'aggancio SL/TP e il lot sizing dipendono da prezzi realistici).
4. Per testare gli ingressi automatici imposta `AutoTradeSignals=true` (default OFF).
5. I pulsanti BUY/SELL non sono cliccabili nel tester (interazione manuale): testa gli ingressi via `AutoTradeSignals`, e valida la gestione manuale in **demo forward test** cliccando i pulsanti.
6. Vai per gradi: prima un singolo simbolo/TF, poi confronta con forward test su demo.

---

## CAVEATS ONESTI (leggere)

- La strategia HARSI è uno **scalp contro-tendenza**; il video sorgente **non rivela** le distanze esatte di SL/TP, il timeframe migliore né l'asset migliore (contenuto a pagamento). Le SL/TP qui sono **nostre definizioni** e **DEVONO essere validate con backtest** prima dell'uso reale.
- Forzare **RR ≥ 2** su uno scalp di mean-reversion **abbasserà il win rate**; per questo `RR` è configurabile (un valore < 1 può essere più realistico per questo tipo di scalp).
- Rischiare **1% per trade** su uno scalp ad alta frequenza è **aggressivo**; valuta **0.25–0.5%** per gli ingressi automatici.
- `AutoTradeSignals` è **OFF di default di proposito**. Valida con lo Strategy Tester (real ticks) e un **demo forward test** prima di usarlo dal vivo.
