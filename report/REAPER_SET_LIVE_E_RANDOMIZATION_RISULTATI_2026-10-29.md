# Gold Reaper: set del segnale live e Randomization 50: RISULTATI (29/10/2026)
Criteri e previsioni scritti prima: `REAPER_SET_LIVE_E_RANDOMIZATION_CRITERI_2026-10-29.md`. Fonte: zip `ANNO80K_REAPER_SETLIVE_20261029_1150` (riga `RIGA_LANCIA_REAPER_SETLIVE_80K.txt`, pin 3e43646d; archivio `backtest_pipeline/risultati_archivio/ANNO80K_REAPER_SETLIVE_20261029_1150`). 80.000 EUR, XAUUSD H1, Modello 1, tutti gli input imposti. Non controllata da agenti.
**Validita:** 15 passate su 16 OK (`input_ok = si`). **KO: 2018 R50B** (il tester ha scritto un report vuoto, periodo 1970 e deposito 0: guasto del terminale, NON MISURATO).

## Risultati (netto EUR / DD equity EUR / peggior giorno realizzato / giorni >= 5%)
| Anno | LIVE30 (live del venditore) | LIVE9 (live con MaxAllowedDD 9 e limite 4) | R50A (prop con Randomization 50) | R50B (stessa) | Riferimento prop, Randomization 0 |
|---|---|---|---|---|---|
| 2013 | +103.468 / **32.679** / **-11,4%** / 3 | +21.053 / 5.708 / -4,6% / 0 | +21.095 / 7.790 / -4,9% / 0 | +23.072 / 7.688 / -5,0% / 0 | +21.757 / 5.621 / -4,6% |
| 2018 | +35.596 / **20.369** / -7,5% / 3 | +13.631 / 5.637 / -2,2% / 0 | +16.197 / 5.908 / -2,9% / 0 | **KO** | +13.535 / 5.504 / -2,2% |
| 2020 | +85.671 / **20.758** / -5,4% / 1 | +20.131 / 3.838 / -1,6% / 0 | +21.283 / 5.232 / -2,9% / 0 | +24.742 / 4.895 / -2,7% / 0 | +20.388 / 3.839 / -1,6% |
| 2025 (12 mesi) | +148.797 / **19.927** / -4,0% / 0 | +29.542 / 3.324 / -1,1% / 0 | +35.966 / 4.498 / -1,1% / 0 | +33.137 / 3.796 / -1,7% | +30.457 / 3.077 / -1,1% |
Operazioni: LIVE9 500 / 545 / 456 / 492 (come il prop: 509 / 548 / 460 / 497); **R50 630-638 / 706 / 566-572 / 615-618, cioe circa +24-29%** rispetto a Randomization 0.

## Contro le previsioni (scritte prima)
L1 (LIVE30 DD > 8.000 in tutti e 4 gli anni, un giorno >= 5%, netto 2013 > +50.000): **SI, SI, SI**. L2 (LIVE9 entro +-10% del prop in almeno 3 anni su 4; LIVE9 passa i tre anni): **SI** (differenze da -3% a +1%, in tutti e 4 gli anni; passa DD <= 8.000 e nessun giorno >= 5%, calibrazione non misurata). L3 (R50A e R50B differiscono oltre il 5% in un anno): **SI** (2020: +21.283 contro +24.742, +16%; 2013 +9%; 2025 -8%): la corsa NON e ripetibile. L4 (R50 entro +-25% di Randomization 0): **SI** (da -3% a +21%). L5 (R50A e R50B passano PROP-ANNI): **NON misurabile per R50B (2018 KO); R50A passa i tre anni** ma con DD 2013 7.790 (sul bordo di 8.000) e giorno -4,9%; R50B 2013 -5,0%. L6 (16 su 16 valide): **NO** (15).

## Lettura
- **Il set live del venditore a 80.000 non e per una prop:** DD di equity 20-33 mila, giorni a -11,4% (2013) e -7,5% (2018), anche se il netto e alto (+103 mila nel 2013, +149 mila nel 2025). E il `MaxAllowedDD` 30: coerente con i nostri test sul 15.
- **`OnlyUp` true e `Virtual_expiration` false non cambiano praticamente niente** (LIVE9 = prop entro il 3%): la differenza fra set live e set prop e solo `MaxAllowedDD` (e il limite giornaliero).
- **`Randomization` 50 NON e neutra:** aumenta le operazioni di circa un quarto, il DD di equity del 2013 sale da 5.621 a circa 7.700-7.800 (+38%) e il giorno peggiore da -4,6% a -4,9/-5,0%; il netto cambia fra due corse identiche (fino a +16%). Il prop set del venditore la usa per i conti multipli; su un solo conto non conviene (peggiora il 2013) e rende i test non ripetibili. Questo e un risultato nostro, con Modello 1.
## Cosa NON dice
Un percorso per anno; Modello 1; 2013/2018/2020 probabilmente dentro l'ottimizzazione del venditore; nessuna slippage; filtro news non simulato; la Randomization del tester puo non rappresentare quella dal vivo; margine con leva FTMO non simulato. Nessun giudizio su acquisto, lotto o taglia.
