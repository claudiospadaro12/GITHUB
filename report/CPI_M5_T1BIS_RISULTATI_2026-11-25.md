# EA CPI M5, T1-bis (SL di sicurezza 3000 punti = quasi nessuno stop), risultato dal report del tester (25/11/2026)

Fonte: `YJTR.xlsx` (report Strategy Tester MT5): XAUUSD, 01/07/2024 -> 20/11/2026, **tick reali (98%)**, latenza zero, 0,10 lotti, deposito 100.000, preset `ABTG_CpiM5_XAUUSD_B100_SL3000` (InpSlMode=1, InpSlPoints=3000, buffer 100, uscita T+299 s). Criteri scritti prima: `CPI_M5_PAYOFF_E_STOP_2026-11-25.md`.

| Misura | T1 (stop sul livello opposto) | **T1-bis (SL 3000)** |
|---|---|---|
| Operazioni | 27 | **27** (70,4% vincenti: 19 vinte, 8 perse) |
| Profitto netto | -41 USD | **+1.077 USD** (+1,08%) |
| Profit factor | 0,97 | **1,88** (lordo +2.302, perdite -1.225) |
| Profitto medio / perdita media | +11,0 / 10,5 USD/oz | **+12,1 / 15,3 USD/oz** (rapporto 0,79) |
| Drawdown massimo (saldo / equity) | - | 684,8 (0,67%) / 786,8 (0,77%) |
| Massima vincita / perdita | +655 / -382 | +655 / -382 |
| Tempo di tenuta | - | min 1:31, medio 6:07, max 9:59 |
Long 21 (71,4% vincenti), short 6 (66,7%). Perdite consecutive massime: 2 (-684,8). Z-score -0,36.

## Verdetto con i criteri scritti prima
**Promettente** (profitto > 0, PF >= 1,3, >= 25 eventi: PF 1,88 su 27). Previsione scritta: PF 1,0-1,5, probabilita' di >= 1,3: 35%; il risultato la supera. **Ma non e' una prova**, per questi motivi (misurati):
- **Sample riusato.** L'ipotesi "togliere lo stop stretto" e' nata guardando proprio questi 27 eventi (la perdita reale era il doppio di quella simulata). Non e' una conferma indipendente.
- **Pochi eventi pesano tutto:** profitti per evento (USD): +655, +248, +240, +195, +143, +134, ... ; senza il migliore netto +422 (PF 1,34), senza i 2 migliori +174 (PF 1,14), **senza i 3 migliori -66 (PF 0,95)**. Bootstrap sul netto: 5% = -518, mediana +1.026, probabilita' netto <= 0: 14%.
- **Dipende dal regime:** la simulazione M1 senza stop da' 2013-2017 PF 0,81 (con 1 USD di penalita' 0,33), 2018-2022 PF 1,71 (1,05), 2023-2026 PF 1,76 (1,43). Il vantaggio compare quando l'ampiezza della candela CPI e' grande (dal 2021) e manca nel 2013-17.
- **Contesto di mercato:** 21 operazioni su 27 sono long, in un oro passato da 2.400 a 4.500: in parte e' tendenza, non solo reazione alla notizia. Inoltre **molti ingressi avvengono prima della notizia** (con buffer 1 USD gli ordini scattano anche nei 5 minuti prima: es. 13:25-13:29), cioe' la posizione attraversa lo spike senza averla "vista".
- **Le due perdite peggiori** (11/09/2026 -382 a 13:30:17, 14/10/2026 -303 a 13:31:13) sono stati toccati dallo stop di sicurezza a 30 USD durante lo spike (perdita effettiva 30-38 USD/oz): lo stop di sicurezza limita il danno, ma in uno spike peggiore potrebbe scivolare oltre.
- Limiti del test: latenza zero ("esecuzione ideale"), 27 eventi, nessuno slippage ritardato simulato, un solo simbolo e broker.

## Passi successivi (decide Claudio)
1. **T2 indipendente:** stesso preset, modello "1 minuto OHLC", 2018-01-01 -> 2024-06-30 (periodo diverso da T1-bis): la simulazione M1 e' fedele al tester (correlazione 0,89) e prevede PF 1,05-1,71 per il 2018-22; se T2 e' sotto 1,0 il vantaggio e' solo del 2024-26.
2. **Stress di latenza** su T1-bis (ritardo 200-500 ms) per vedere quanto regge senza esecuzione ideale.
3. **Forward demo** (non reale) con il magic 770801 solo sull'oro, per le prossime CPI (circa 12 l'anno).
4. Solo dopo, e con le regole prop lette dai testi ufficiali: eventuale scheda prop (`prop_kit`). Nessun consiglio su lotti.
