# BREAKING BAND AGGIORNATO LEONARDO: riepilogo (sola lettura)

Data analisi: 2026-11-23. Fonti: chat "Analisi dei file" (progetto, 108 messaggi), file caricati in `codici/` e guida `Breaking_Bands_Guida_Completa.docx`.

## 1. Scopo del progetto
Sviluppo di un EA MT5 per la strategia Breaking Bands (mean reversion su Bande di Bollinger 20, 2.0), con due varianti: Continuazione e Inversione. Target sempre la mediana BB. Stop loss 3 × ATR(14), salvo le discrepanze al punto 4.
Primo messaggio della chat: ANALIZZA I FILE. Ultimo messaggio letto: domanda sull'RSI del grafico EURAUD H1 (RSI 36,13).

## 2. EA, versioni e stato
| File | Versione | Stato |
|---|---|---|
| BreakingBand_ALLCROSSES.mq5 | 2.00 | superato |
| BreakingBand_ALLCROSSES_v21 … v27 | 2.1 – 2.7 | superate (v2.7 = 10 coppie, dalla chat) |
| BreakingBand_ALLCROSSES_v30, v31 | 3.0 – 3.1 | superate |
| BreakingBand_ALLCROSSES_v40, v41 | 4.0 – 4.1 | superate |
| BreakingBand_ALLCROSSES_v42 | 4.2 | **ultima versione** (28 coppie, logica a tre fasi) |
| BreakingBand_EA.mq5 | 2.0 MT5 | versione autonoma precedente |
| BreakingBand_BACKTEST.mq5, BreakingBand_MultiBacktest.mq5 | 1.0 | strumenti di backtest |

### Logica v4.2 (intestazione del codice)
1. **Bulge**: il prezzo tocca una banda BB, e vengono salvati i valori fissi di banda di impulso, banda opposta, mediana e ATR.
2. **Continuazione** (1ª e 2ª bulge nella stessa direzione): entry LIMIT sul livello salvato della banda opposta, nella direzione del bulge. SL = 3 × ATR salvato, TP = mediana corrente.
3. **Inversione** (3ª bulge nella stessa direzione): entry LIMIT contro il bulge, sul ritorno alla banda originale dopo aver toccato la mediana. SL = 3 × ATR salvato, TP = mediana corrente.
4. **Contatore**: incrementa solo se il prezzo ha raggiunto la banda opposta dall'ultimo bulge. Timeout senza retrace: reset del contatore.

### Parametri v4.2 (input)
- Coppie: 28 flag `P_xxx` = true (maggiori, cross EUR, GBP, JPY, AUD, NZD, CAD, CHF).
- BB 20 / 2.0; ATR 14; rischio 2% per trade; SL 3 × ATR; max 10 posizioni; BE attivo a 1 × ATR; timeout 40 barre; magic 20250001.

## 3. Risultati di backtest (dalla chat e dalla guida)
Dalla guida (H1, 2022-2026):
| Versione | Trade | WR | Net P/L | Sharpe | DD max | Note |
|---|---|---|---|---|---|---|
| v2.0 | 86 | 68% | +$247 | 2.63 | 1.6% | 7 coppie |
| v2.2 | 179 | 66% | +$485 | 0.78 | 6.8% | 28 coppie |
| v2.3 (migliore dichiarata) | 107 | 56% | +$1.346 | 4.27 | 4.0% | 14 coppie, SL 2×ATR |
| v2.4 | ~63 | ~65% | ~+$1.977 | — | ~3% | 9 coppie |
| v2.5 | 159 | 48% | +$737 | 1.51 | 11.2% | peggiore |

Dalla chat (ultima versione discussa): v2.7 con 10 coppie (AUDUSD, AUDCAD, EURJPY, EURGBP, GBPJPY, AUDJPY, USDCAD, NZDCHF, EURNZD, GBPAUD); NZDCAD rimossa perché negativa. Il backtest di v2.7 con dati OHLC a 1 minuto non risulta nella chat letta.

## 4. Discrepanze da chiarire (importanti)
- **Stop loss**: la guida dice "3 × ATR" nella sezione principale, ma la tabella dei parametri della v2.3 dice "2 × ATR (ridotto da 3.0)" ed è la versione dichiarata migliore. Il codice v4.2 usa 3 × ATR.
- **Rischio**: la guida consiglia 1-2%; la v2.3 usa 1%; la v4.2 usa 2%.
- **Numero di coppie**: la guida elenca 9 coppie attive (v2.4+); la chat dichiara 10 (v2.7); il codice v4.2 ne attiva 28. Il messaggio di sviluppo chiedeva di ridurre i rumori con il metodo dei 9 o 10 coppie.
- **Protocollo**: il codice cita "Protocollo v.11", la guida no.
- **Frequenza**: la guida riconosce che H1 dà circa 2,2 trade al mese, e propone M30 o più istanze con magic diversi. Il codice non prevede istanze multiple.
- **Filtro banda**: la guida chiede che la banda sia piatta o in discesa prima del retest (inversione). Il codice v4.2 non lo mostra in modo esplicito nelle prime righe, da verificare nel corpo del file.

## 5. Decisioni e problemi aperti
- Scelta della versione definitiva: v2.3 (migliore dichiarata dalla guida) contro v4.2 (ultima, usata nella chat).
- Allineare SL (2× o 3× ATR), rischio e numero di coppie tra guida e codice.
- Ridurre la frequenza: M30, più istanze, o coppie dedicate (GBPJPY).
- Il trading journal richiesto dalla guida non risulta nelle chat lette.

## 6. Cosa NON è stato letto
- Il corpo completo delle funzioni di ciascun file: i codici sono copiati interi in `codici/`, ma non li ho riletti riga per riga.
- Le chat di risultati di backtest diverse da questa, se esistono.
