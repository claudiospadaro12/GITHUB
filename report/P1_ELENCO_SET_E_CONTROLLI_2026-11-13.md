# P1 (conto 160k): elenco dei set e controlli prima e dopo la partenza (13/11/2026)

**Natura: ELENCO TECNICO** letto dai file `.set` di Wim e dai report del tester; NON e un consiglio di acquisto, di lotto o di taglia. I nomi dei set sono quelli dei test; **va controllato file per file che siano le versioni correnti di Wim** (versioni sul VPS e sul trial NON verificate). Nessun conto reale, trial o VPS e stato toccato da me.

## I tre EA di P1
| EA | Grafico (come nei test) | File del set | Input da controllare dopo il caricamento |
|---|---|---|---|
| **Gold Phantom** (The Gold Phantom, V2.5) | XAUUSD, H1 | `GoldPhantom_Propfirm.set` | `TradeFrequency=5` (Auto), `Risk=1234` (Max Allowed Total DD), `MaxAllowedDD=9`, `PropFirmMaxDailyDD=4`, `Randomization=50`, `OnlyUp=false`, `AdjustLotsizeToVariableValues=true`, `ST1_MagicNumber=75000`, `RunStrat1..9=true`, NFP acceso con finestre 100/60, `FridayStopHour=25`, `UseMQL5Calendar=true`, `AutoGMT=true` |
| **Goldbot One** (Goldbot One MT5, V3.5) | XAUUSD, Daily | `Goldbot_PropFirm_5_2.5.set` | `Risk=3` (Max Risk Per Strategy), `MaxRiskPerStrategy=1.0`, `PropFirmMaxDailyDD=2.0`, `Randomization=0`, `OnlyUp=0`, `ST1_MagicNumber=2000`, `RunStrategyA..H=true`, NFP acceso con finestre 180/50, `FridayStopHour=25`, `EnableVirtualSLTP=false`, `CheckMargin=1` |
| **Daytrade Pro** (DayTradePro_WSC V4.5) | un solo grafico (EURUSD D1 nei test): `RunOneChartSetup=1` apre da solo le altre coppie | `Daytrade_Pro_Max9%DD_lowrisk.set` | `Risk=99999`, `MaxRiskMaxDD=2.7`, `PropFirmMaxDailyDD=0`, `Randomization=0`, `ST1_MagicNumber=5656`, `OneChartSetupPairs` = EURUSD;GBPUSD;USDJPY;AUDUSD;**XAUUSD**;GBPJPY;USDCAD;EURJPY;EURNZD;EURAUD;NZDUSD;AUDJPY;CHFJPY, `FridayStopHour=25`, `MaxNumberOfTrade=99` |
**Il Daytrade Pro opera ANCHE sull'oro** (nel tester 48-62 aperture l'anno su XAUUSD, 5-15 lotti round turn): la mia nota dell'11/11 ("Daytrade Pro no" per la regola news sull'oro) era sbagliata. Impatto: sullo Swing la regola news non vale; il costo extra dell'oro nel Daytrade Pro (36 invece dei 4 EUR/lotto che avevo usato) vale circa 350 EUR l'anno su 80k.
## Prima di partire
1. Conto: 2-Step Swing (leva oro 1:15 confermata da FTMO: margine fino a circa 51-56% del saldo su P1, calcolo del 11/11). Valuta: EUR ammesso.
2. Tutte e 13 le coppie del Daytrade Pro devono esistere nel Market Watch del conto FTMO (nomi esatti, es. EURNZD, CHFJPY). Se un nome e diverso il set non le apre.
3. Opzioni MT5 > Expert Advisors: consenti trading algoritmico e gli URL richiesti dagli EA di Wim (licenza); nel pannello dell'EA deve comparire "licenza trovata".
4. **Guardian**: soglie 4,5% giornaliero e 9,5% totale come hai impostato; `InpStartBalance` = saldo iniziale del conto; il filtro NFP resta acceso. I test e le simulazioni di oggi usavano 4,3%.
5. Un solo set per EA e un solo EA per grafico; magic number diversi (75000, 2000, 5656). Nessuna posizione aperta da altri EA sul conto.
6. Controllo del server FTMO (ora italiana + 1): gli EA usano AutoGMT, quindi non toccare gli offset (Inverno 2, Estate 3).
## Dopo la partenza (primi giorni)
- Ogni giorno: ultima riga `[GUARDIAN]` (equity, dayLoss, totDD), numero di ordini pendenti e di posizioni aperte, nessun errore di licenza nel registro.
- Mandami l'esportazione "Report cronistorico dei trade" del conto dopo 2-3 giorni e dopo 2-3 settimane: la analizzo con le stesse tabelle (EA, giorni, costi, slippage).
- Se compaiono ordini rifiutati per margine, o risultati fuori scala rispetto alla tabella dei tempi (P1: circa 137 giorni di mediana per le due fasi, 89% entro 7 mesi nel tester), dimmelo subito.
## Limiti
Tester, non conto reale; spread e slippage FTMO non misurati; il Daytrade Pro non ha flottante nei test; tre anni di dati (2013, 2020, 2025).
