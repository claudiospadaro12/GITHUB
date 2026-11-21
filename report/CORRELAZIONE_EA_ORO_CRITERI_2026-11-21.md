# Correlazione del Supertrend long / trend D1 dell'oro con gli EA oro della flotta (criteri PRIMA dei numeri, 21/11/2026)
**Dati disponibili (limite dichiarato):** solo il **forward del conto 100k dry-run** (`data/statements/trades_100k.csv` del ramo `lavoro`): XAUUSD 119 operazioni dal 10/08 al 18/11/2026 (83 sell, 36 buy) di The Gold Reaper, The Gold Phantom, Gold Trade Pro. **Nessuna serie giornaliera di backtest degli EA oro e' disponibile qui** (solo riepiloghi): il confronto copre ~3 mesi, un solo regime (oro in discesa da ~4.300 a ~3.700). Script `backtest_runner/simulatore/correlazione_ea_oro.py`.
## Misure
P&L realizzato giornaliero (in EUR) degli EA oro per giorno di chiusura (totale, solo sell, solo buy) contro le serie giornaliere del 21/11: Supertrend H1 long, Supertrend H4 long, Donchian 55 D1 long, oro fermo (stesse serie di `supertrend_correlazione.py`, FTMO M1, rendimento % pesato per esposizione). **Correlazione di Pearson giornaliera e settimanale**, solo sui giorni con almeno un'operazione chiusa degli EA (e confronto con tutti i giorni). Un solo valore per misura, nessuna soglia ottimizzata.
## Previsioni (prima dei numeri)
- P&L totale EA oro contro **oro fermo: negativa**: 70% (prevalgono i sell e l'oro scende). Contro Supertrend H4 long: **<= 0,1**: 60%. Contro Donchian D1 long: **|r| < 0,3**: 65%. Il solo lato buy degli EA: correlazione con oro fermo > 0,3: 60%.
## Lettura (fissata ora)
|r| >= 0,7: "stesso rischio"; 0,4-0,7: "diversifica poco"; < 0,4: "diversifica" **solo per questo periodo**: con ~60 giorni e un solo regime il margine d'errore e' grande (il coefficiente a 60 giorni ha un intervallo di +/- 0,25 circa) e **non e' una stima della correlazione di lungo periodo**. Nessun consiglio di taglie.

## RISULTATI (script `correlazione_ea_oro.py`; output `CORRELAZIONE_EA_ORO_RISULTATI_2026-11-21.txt`) — **NON CONCLUSIVO**
- **Campione realmente disponibile: 119 operazioni XAUUSD (83 sell, 36 buy) chiuse in soli 9 giorni diversi** (dal 23/09 al 18/11/2026, 41 giorni lavorativi): gli EA chiudono a blocchi. P&L realizzato totale **+22.308 EUR (sell +14.161, buy +8.147)**: entrambi i lati in guadagno mentre l'oro perdeva il 15,4%.
- **Correlazione giornaliera (41 giorni) del P&L degli EA contro:** Supertrend H1 long +0,11, Supertrend H4 long +0,08, oro fermo -0,06; Donchian 55 D1 **non calcolabile** (nessuna posizione nel periodo, serie costante). Sui soli 9 giorni con chiusure: +0,28 / +0,13 / +0,14. **Settimanale (9 settimane): +0,74 con Supertrend H1, +0,58 con H4, +0,39 con oro fermo; il solo lato buy +0,67 / +0,68 / +0,80.** Il lato sell: +0,29 / +0,07 / -0,31.
- **Previsioni:** totale contro oro fermo negativo (70%): giornaliera -0,06 (si', di niente), settimanale +0,39 (no); contro Supertrend H4 <= 0,1 (60%): si' giornaliera, no settimanale; Donchian |r| < 0,3 (65%): non valutabile; solo buy contro oro fermo > 0,3 (60%): si' settimanale (0,80), no giornaliera (0,07).
- **Lettura onesta: nessuna conclusione utilizzabile.** Con 9 giorni di chiusure e 9 settimane l'intervallo di confidenza del coefficiente copre quasi tutto l'intervallo -0,5 / +0,9, un solo regime (oro in discesa), P&L realizzato a blocchi (non marcato a mercato). I numeri giornalieri dicono "quasi nessuna relazione", quelli settimanali "relazione positiva": **non sono la correlazione di lungo periodo.**
- **Cosa servirebbe:** serie giornaliere di backtest degli EA oro (Reaper, Phantom, GTP, Goldbot One) su piu' anni. **Quelle presenti sono solo i riepiloghi e, dentro gli zip `ANNO_ORO_GRADINI_*` (es. `PH2026` Phantom 2026, `TICKP3` Goldbot 2025), report MT5 annidati (`ANNO80K_*.zip`) da cui si possono ricavare le operazioni;** `CONTROLLO_14EA_ORO.zip` ha le serie ma dei 14 EA "ottimizzati" (EMA200, GoldenCross, SupertrendReversal, Multi), non della flotta Wim.

## ESTENSIONE (21/11, su richiesta "estrai le operazioni dagli zip e misura"): report MT5 dei backtest a tick reali
**Dati:** i report `.htm` dentro gli zip `ANNO_ORO_GRADINI_*` (BCM, Modello 4 tick reali, XAUUSD): **Phantom 2026-01-01 -> 2026-11-12** (deposito 5.000, 532 operazioni, netto +2.118, PF 1,74; esiste anche una passata gemella da 80.000 con 832 operazioni, usata come controllo), **Goldbot One 2025** (80.000, 238 operazioni, +6.028, PF 1,97), **Gold Trade Pro 2025** (80.000, ~278 operazioni). **Reaper: nessun report in questi zip.** P&L realizzato giornaliero (profitto + commissioni + swap per data del deal), confrontato con le serie del 21/11 (Supertrend H1/H4 long, Donchian 55 D1 long, oro fermo) **nella stessa finestra**; correlazione giornaliera, settimanale e mensile; correlazione fra gli EA (Goldbot-GTP 2025). Un solo valore per misura. **Limite:** P&L realizzato, non marcato a mercato (i grid/trailing chiudono a blocchi); i backtest sono di EA di terzi (scatola nera) con input di default.
**Previsioni (prima dei numeri):** Goldbot One e Gold Trade Pro 2025 contro Supertrend H4 long, settimanale >= 0,4: **60%**; Phantom 2026: **50%**; Goldbot contro oro fermo (settimanale) >= 0,4: **55%**; Goldbot-GTP settimanale >= 0,5: **65%**; correlazione mensile con Donchian 55 D1 >= 0,5 per almeno uno dei tre: **45%**. Lettura (invariata): >= 0,7 stesso rischio; 0,4-0,7 diversifica poco; < 0,4 diversifica (per questo periodo).

### RISULTATI estensione (script `correlazione_ea_oro_report.py`; output `CORRELAZIONE_EA_ORO_REPORT_RISULTATI_2026-11-21.txt`)
Correlazione del P&L realizzato giornaliero/settimanale/mensile con le serie del 21/11 (n = 224-258 giorni, 46-53 settimane, 11-12 mesi):
| EA (backtest tick reali) | Contro | Giorn. | Sett. | Mens. |
|---|---|---|---|---|
| **Goldbot One 2025** (238 op., +6.028) | Supertrend H4 long | 0,26 | 0,40 | 0,60 |
| | Supertrend H1 long | 0,19 | 0,15 | 0,77 |
| | Donchian 55 D1 | 0,19 | 0,16 | 0,56 |
| | oro fermo | 0,14 | 0,17 | 0,66 |
| **Gold Trade Pro 2025** (+8.047) | Supertrend H4 long | 0,24 | 0,29 | 0,29 |
| | Supertrend H1 long | 0,22 | 0,15 | 0,35 |
| | Donchian 55 D1 | 0,04 | 0,07 | 0,26 |
| | oro fermo | 0,10 | 0,13 | 0,29 |
| **Phantom 2026** (532 op., +2.118) | Supertrend H4 long | 0,23 | 0,34 | 0,32 |
| | Supertrend H1 long | 0,17 | 0,02 | -0,02 |
| | Donchian 55 D1 | 0,05 | 0,14 | 0,07 |
| | oro fermo | 0,00 | 0,03 | -0,07 |
| Phantom 2026 (passata da 80.000, controllo) | Supertrend H4 long | 0,26 | 0,38 | 0,46 |
| | Donchian 55 D1 | 0,08 | 0,17 | 0,20 |
| **Goldbot-GTP 2025** (fra gli EA) | | **0,50** | **0,73** | **0,81** |
- **Lettura con la regola scritta:** Phantom e Gold Trade Pro **diversificano** rispetto al Supertrend/trend D1 (tutte le correlazioni < 0,4 tranne mensile Phantom 80k 0,46); **Goldbot One "diversifica poco" a livello mensile** (0,56-0,77 con Supertrend e Donchian, su 12 mesi, quindi stima debole). **Goldbot e Gold Trade Pro fra loro: 0,73 settimanale, 0,81 mensile = "stesso rischio"** (relevante per la flotta, non per il Supertrend).
- **Previsioni:** Goldbot e GTP contro Supertrend H4 settimanale >= 0,4 (60%): Goldbot 0,40 **sul filo si'**, GTP **no (0,29)**; Phantom (50%): **no (0,34-0,38)**; Goldbot contro oro fermo settimanale >= 0,4 (55%): **no (0,17; mensile 0,66)**; Goldbot-GTP settimanale >= 0,5 (65%): **si' (0,73)**; Donchian mensile >= 0,5 per almeno uno (45%): **si' (Goldbot 0,56)**.
- **Limiti:** P&L **realizzato** (non marcato a mercato: sottostima le correlazioni giornaliere e settimanali), 11-12 mesi per la misura mensile (incertezza ampia), backtest con input di default su EA di terzi, periodi diversi (2025 e 2026), **Reaper e Goldbot/GTP/Phantom sullo stesso anno non disponibili** (nessun report del Reaper in questi zip). Nessun consiglio di taglie.
- **Conclusione per il Supertrend:** rispetto agli EA oro Phantom e Gold Trade Pro il Supertrend long non e' lo stesso rischio (correlazioni basse), e rispetto a Goldbot e' moderato. **Non e' stata misurata la correlazione fra il Supertrend e il Reaper.**
