# Gold Reaper a lotto minimo su 16 anni (2008-2023): RISULTATI (29/10/2026)
Criteri e previsioni scritti prima: `REAPER_LOTTO_FISSO_16_ANNI_CRITERI_2026-10-29.md`. Fonte: zip `ANNO80K_REAPER_FISSO_20261029_1000` (riga `RIGA_LANCIA_REAPER_FISSO_80K.txt`, pin 3e43646d; archivio `backtest_pipeline/risultati_archivio/ANNO80K_REAPER_FISSO_20261029_1000`). 19 passate OK (`input_ok = si`), 80.000 EUR, XAUUSD, Modello 1, `TradeFrequency=2`, `MaxAllowedDD=0` (lotto 0,01), limite giornaliero 0, `OnlyUp=false`. Non controllata da agenti.

## Netto per anno a lotto 0,01 (EUR) contro Wim (USD, 10.000, D1, `OnlyUp=true`, `MaxAllowedDD` 30, DICHIARATO)
| Anno | Operazioni | Netto | PF | DD equity | Qualita storico | Wim: netto / operazioni |
|---|---|---|---|---|---|---|
| 2008 | 453 | +371,50 | 2,60 | 48,84 | 98% | +749 / 510 |
| 2009 | 468 | +686,07 | 4,46 | 51,89 | 99% | +1.173 / 578 |
| 2010 | 451 | +494,29 | 2,49 | 70,86 | 95% | +567 / 538 |
| 2011 | 528 | +540,16 | 2,08 | 272,11 | 96% | +1.615 / 560 |
| 2012 | 604 | +619,32 | 1,77 | 175,02 | 94% | +487 / 692 |
| 2013 | 513 | +318,46 | 1,36 | 228,32 | 99% | +1.305 / 590 |
| 2014 | 577 | +340,43 | 1,53 | 171,59 | 100% | +665 / 713 |
| 2015 | 547 | +181,64 | 1,24 | 173,96 | 99% | +945 / 687 |
| 2016 | 529 | +545,86 | 2,09 | 113,78 | 99% | +1.920 / 662 |
| 2017 | 518 | +252,02 | 1,44 | 104,32 | 99% | +1.437 / 641 |
| 2018 | 548 | +264,58 | 1,36 | 158,38 | 100% | +1.193 / 751 |
| 2019 | 524 | +437,64 | 1,55 | 157,70 | 100% | +980 / 638 |
| 2020 | 460 | +570,78 | 1,75 | 151,52 | 100% | +1.329 / 491 |
| 2021 | 593 | +516,88 | 1,58 | 163,05 | 99% | +1.333 / 626 |
| 2022 | 530 | +432,64 | 1,45 | 202,04 | 99% | +1.288 / 600 |
| 2023 | 560 | +929,15 | 2,16 | 201,77 | 99% | +2.326 / 618 |
| **Totale** | 8.403 | **+7.501** | | max 272 (0,34%) | | **+19.312 / 10.104** |
**D1 contro H1 (2013, 2018, 2020): risultati IDENTICI** (stesse operazioni, stesso netto): il timeframe del grafico non cambia le operazioni del Reaper nel tester.

## Contro le previsioni (scritte prima)
F1 (positivo in 16 anni su 16: 55%; almeno 14: 85%): **SI, 16 su 16** (il peggiore e il 2015 con +182, PF 1,24). F2 (operazioni entro +-30% di Wim in ogni anno): **SI** (da -27% nel 2018 a -5% nel 2021). F3 (2013 / 2018 / 2020 entro +-40% di Wim): **NO** (318 contro 1.305, 265 contro 1.193, 571 contro 1.329: 24%, 22%, 43%). F4 (D1 diverso da H1 oltre il 25% in 2 anni su 3): **NO** (identici). F5 (totale fra 14.000 e 26.000): **NO** (7.501, il 39% del +19.312 di Wim). F6 (anno peggiore fra 2008, 2010, 2012): **NO** (il peggiore e il 2015). F7 (almeno un anno 2008-2012 KO o senza operazioni): **NO** (tutti presenti, qualita 94-99%). F8 (peggior giorno sotto lo 0,6% di 80.000): **SI** (il DD equity massimo e 272 EUR = 0,34%, quindi nessun giorno puo superarlo).

## Lettura
- **L'edge del Reaper c'e anche fuori dal periodo 2013-2023 che il venditore dichiara di aver ottimizzato:** 2008-2012 sono tutti positivi (PF 1,77-4,46) con i nostri dati BCM. Con i dati e il lotto minimo, nessun anno su 16 e in perdita. Conferma, con i nostri dati e la nostra versione, il risultato dichiarato nel test 2008-2024.
- **Le dimensioni NON coincidono con quelle di Wim:** a parita di lotto (0,01) il nostro netto e circa il 22-43% del suo (totale 39%). Il numero di operazioni e simile (da -5% a -27%). Cause NON verificate: versione diversa (`WSC_V1.0` contro `The Gold Reaper MT5`), spread e commissioni del tester (a 0,01 lotti lo spread BCM pesa molto: circa 0,2-0,7 USD a operazione contro un profitto medio di 0,62 EUR), modello dei tick, `OnlyUp`, `MaxAllowedDD` 30. Per il nostro scopo conta il segno e la stabilita, non il valore assoluto.
- **Il Reaper e positivo in ogni anno ma il margine cambia molto:** da +182 (2015) a +929 (2023). A lotto minimo il PF scende a 1,24-1,77 in molti anni: l'edge e piccolo e i costi pesano.

## Cosa NON dice
Lotto minimo: non misura il rischio a lotto normale. Modello 1 (OHLC), nessuna slippage, filtro news non simulato, orologio AutoGMT non verificato su BCM (negli anni vecchi l'orologio dell'EA non e verificabile), qualita del storico 94-100%. Nessun giudizio su acquisto, lotto o taglia.
