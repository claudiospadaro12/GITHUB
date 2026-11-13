# P4 (conto 80k): elenco dei set e dei controlli prima e dopo la partenza (13/11/2026)

**Natura: ELENCO TECNICO** letto dai report del tester (corsa D160, input riportati nel report) e dai file `.set` di Wim; NON e un consiglio di acquisto, di lotto o di taglia. Va controllato file per file che le versioni dei set siano le correnti di Wim (versioni sul VPS e sul trial NON verificate). Il Gold Reaper Combo 3GOLD vive nel `combodeal.zip`; il file `.set` contiene solo gli input che cambiano rispetto al default dell'EA: gli altri input restano quelli di default dell'EA, da verificare uno a uno sul conto. Nessun conto reale, trial o VPS toccato.
## I tre EA di P4
| EA | Grafico (come nei test) | File del set | Input da controllare dopo il caricamento |
|---|---|---|---|
| **Gold Reaper** (The Gold Reaper MT5, V5.6) | XAUUSD, H1 | `Gold_reaper_propfirm_combo_3GOLD.set` | `TradeFrequency=2` (NON Auto), `Risk=1234`, `MaxAllowedDD=3`, `PropFirmMaxDailyDD=4`, `Randomization=50`, `OnlyUp=false`, `UseEquity=false`, `CheckMargin=true`, `ST1_MagicNumber=8000`, `RunStrat1..9=true`, NFP acceso 100/60, `FridayStopHour=25`, `EnableVirtualSLTP=false`, `AutoGMT=true`, `UseMQL5Calendar=true`, IR e CPI spenti |
| **Goldbot One** (Goldbot One MT5, V3.5) | XAUUSD, Daily | `Goldbot_PropFirm_5_2.5.set` | `Risk=3`, `MaxRiskPerStrategy=1.0`, `PropFirmMaxDailyDD=2.0`, `Randomization=0`, magic 2000, le 8 strategie accese, NFP 180/50, `EnableVirtualSLTP=false` (identico a P1) |
| **Daytrade Pro** (DayTradePro_WSC V4.5) | un solo grafico (EURUSD D1 nei test), `RunOneChartSetup=1` | `Daytrade_Pro_Max9%DD_lowrisk.set` | `Risk=99999`, `MaxRiskMaxDD=2.7`, `PropFirmMaxDailyDD=0`, magic 5656, 13 coppie incluso XAUUSD (identico a P1) |
**Reaper Combo e un livello fisso**: non va alzato a L1 o Medium (nel tester il solo Reaper a L1 fallisce il 47% delle sfide, a Medium il 70%).
## Prima di partire
1. Conto: 2-Step Swing da 80k (la taglia da 160k non e disponibile sullo Swing): leva oro 1:15, margine fino a circa 50% del saldo su P4 (calcolo del 11/11).
2. Tutte e 13 le coppie del Daytrade Pro devono esistere nel Market Watch FTMO (nomi esatti).
3. MT5 > Expert Advisors: trading algoritmico e URL di licenza degli EA di Wim consentiti ("licenza trovata" nel pannello di ogni EA).
4. **Guardian**: 4,5% giornaliero e 9,5% totale come hai impostato, `InpStartBalance` = saldo iniziale; le mie simulazioni usavano 4,3%. Filtro NFP acceso.
5. Un set per EA, un EA per grafico, magic diversi (8000, 2000, 5656). Nessuna posizione aperta da altri EA sul conto.
6. Se P1 e P4 girano su due conti: Goldbot Prop e Daytrade Pro sono identici (stesso EA e stesso set su entrambi); cambia solo Phantom (P1) contro Reaper (P4). Capitale per EA sotto il tetto di 400.000 $ (circa 180.000 $ per due conti da 80k).
## Dopo la partenza
Ogni giorno la riga `[GUARDIAN]` (equity, dayLoss, totDD), ordini pendenti, posizioni aperte, nessun errore di licenza. Mandami l'esportazione "Report cronistorico dei trade" dopo 2-3 giorni e dopo 2-3 settimane.
## Riferimenti dal tester (stime, non garanzie)
P4: mediana 173 giorni per le due fasi, entro 7 mesi il 77% (costi centrali), 0% di fallimenti; P1 + P4 insieme: entrambe entro 7 mesi 75%, entro 9 mesi 95%; ore di posizioni oro opposte fra i due conti 2.451 su 3 anni (il livello piu basso fra le coppie).
## Limiti
Tester, non conto reale; spread e slippage FTMO non misurati; il Daytrade Pro senza flottante; tre anni di dati (2013, 2020, 2025); Reaper con Randomization 50 (rumore); un solo percorso per anno.
