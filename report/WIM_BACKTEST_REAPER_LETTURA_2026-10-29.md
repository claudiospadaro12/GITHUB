# Backtest di Wim sul Gold Reaper (zip `backtests__1.zip`): LETTURA (29/10/2026)
**Natura: LETTURA di dati DICHIARATI dal venditore, non nostri. Non controllata da agenti.** Zip nuovo del 29/10 (10 report HTML del tester + immagini; 103 MB). Non e lo stesso zip dei backtest del Phantom (`GoldPhantom_Backtests.zip`, gia letto). Nessuna analisi precedente di questi 10 file (cercati nel repo per nome).

## Cosa sono
Tutti: expert **`GoldReaper_WSC_V1.0`** (non "The Gold Reaper MT5" delle nostre corse), **XAUUSD, periodo "Daily"** (le nostre corse sono H1), server MetaQuotes demo in USD, leva 1:500, `Risk=1234`, `Randomization=0`, `FridayStopHour=25`. Nel report non compare la riga `AutoGMT` che c'e nelle nostre corse: la versione e diversa. **Differenze di configurazione dal nostro set prop:** `OnlyUp=true` (il nostro e false), grafico D1 (il nostro H1).
| File | Deposito | Periodo | TradeFrequency / MaxAllowedDD / limite giorn. | Netto | PF | Operazioni | DD equity (rel.) | DD saldo |
|---|---|---|---|---|---|---|---|---|
| `PropMaxDD9_Intens` | 100.000 | 2020-01-01 / 2024-01-14 | 2 / 9 / 4, OnlyUp true | +164.184 (+164%) | 2,28 | 2.366 | 10.856 (5,72%) | 6.961 (3,50%) |
| `2020-2024_moderate10DD100K` | 100.000 | 2020-2024 | 2 / 10 / 0, OnlyUp true | +201.375 | 2,36 | 2.365 | 13.390 (6,44%) | 8.483 (3,87%) |
| `50KExtCons_10DD_20162024` | 50.000 | 2016-2024 | 0 / 10 / 0, OnlyUp false | +150.892 | 2,81 | 604 | 13.417 (6,96%) | 10.120 (5,57%) |
| `MaxDD30_moderate` | 1.000 | 2020-2024 | 2 / 30 / 0 | +27.602 | 2,71 | 2.360 | 1.809 (18,63%) | 1.305 (11,55%) |
| `10KAuto30DD` | 10.000 | 2020-2024 | 5 (auto) / 30 / 0 | +196.398 | 2,72 | 3.375 | 16.193 (22,68%) | 8.059 (11,75%) |
| `300to100KMaxDD50Auto` | **300** | 2020-2024 | 5 / 50 / 0 | +108.823 | 3,29 | 2.974 | 8.588 (11,85%) | 5.139 (4,52%) |
| `MaxDD50_Intens` | 5.000 | 2020-2024 | 3 / 50 / 0 | +765.956 | 3,26 | 3.384 | 60.874 (11,90%) | 36.397 (4,53%) |
| `MaxDD50_ExtCons` | 500 | 2020-2024 | 0 / 50 / 0 | +8.595 | 2,29 | 290 | 2.401 (**32,54%**) | 1.585 (28,98%) |
| `10KAuto75DD` | 10.000 | 2020-2024 | 5 / 75 / 0 | **+16.233.958** | 4,08 | 3.382 | 1.673.772 (17,49%) | 726.759 (4,31%) |
| `2008-2024_stability` | 10.000 | **2008-01-01 / 2024-01-14** | 2 / 30 / 0, **Risk=0 (lotto fisso 0,01)** | +19.301 | 1,78 | 9.913 | 877 (5,99%) | 621 (4,26%) |

## Il dato che manca a noi: il test lungo a lotto fisso 2008-2024 (DERIVATO dalla lista affari del report)
Netto per anno su 10.000 con lotto 0,01, operazioni fra parentesi: 2008 +749 (510); 2009 +1.173 (578); 2010 +567 (538); 2011 +1.615 (560); 2012 +487 (692); **2013 +1.305 (590)**; 2014 +665 (713); 2015 +945 (687); 2016 +1.920 (662); 2017 +1.437 (641); **2018 +1.193 (751)**; 2019 +980 (638); **2020 +1.329 (491)**; 2021 +1.333 (626); 2022 +1.288 (600); 2023 +2.326 (618); 2024 (14 giorni) -11 (18). **Positivo in tutti i 16 anni completi**, compresi i 2008-2012 fuori dal periodo di ottimizzazione dichiarato dal venditore (2013-2023). Peggior giorno realizzato -3,57% (lotto fisso, deposito 10.000). Le operazioni per anno (491-751) sono in linea con le nostre (460-548 nei tre anni vecchi).

## Lettura
- **Coerenza con le nostre misure:** il set prop di Wim (`PropMaxDD9_Intens`, 100.000, 2020-2024) fa +164% in 4 anni (circa +27% l'anno composto), DD di equity 5,72%: simile al nostro Reaper (2020 +25,5%, 2025 +34%, DD di equity 3-5%).
- **I set con MaxAllowedDD alto sono marketing:** +16,2 milioni su 10.000 (MaxAllowedDD 75), +766.000 su 5.000 (50): composizione del lotto su un percorso 2020-2024 senza costi ne slippage ne limiti di liquidita; NON utilizzabili come aspettativa. Il DD relativo sembra basso perche il saldo cresce enormemente.
- **I piccoli depositi:** `MaxDD50_ExtCons` (500) ha DD di equity 32,5% e DD di saldo 29%: sul tuo conto reale un MaxAllowedDD alto non e un modo prudente.
- **Non confrontabile alla lettera con le nostre corse:** versione `WSC_V1.0`, D1, MetaQuotes USD, `OnlyUp=true`. Per confrontarlo servirebbe una nostra corsa D1 con gli stessi input.

## Cosa NON dice
Sono report del venditore (DICHIARATI): non sappiamo con che dati e con che modello di tick sono stati fatti; il periodo 2013-2023 e probabilmente in-sample; nessuna slippage ne costi extra; il test 2008-2024 e a lotto fisso minimo e non misura il rischio a lotto normale. Nessun giudizio su acquisto, lotto o taglia.
