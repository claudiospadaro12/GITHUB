# Gold Reaper: Randomization 75/100 e TradeFrequency Auto, risultati (31/10/2026)
Zip `ANNO80K_REAPER_RANDOM_20261031_1204` (17 passate, 80.000 EUR, XAUUSD H1, Modello 1, `input_ok = si` e stato OK in 17/17). Criteri e previsioni: `REAPER_RANDOMIZATION_75_100_CRITERI_2026-10-30.md`. Non controllata da agenti. Origine: Wim consiglia per FTMO "Randomization 75 to 100" e "TradeFrequency Auto".

## Numeri (netto / DD equity / peggior giorno realizzato)
| Anno | Moderate, Rand 0 (rif.) | Rand 50 (rif. R50A) | Rand 75 (A / B) | Rand 100 (A / B) | **Auto**, Rand 0 |
|---|---|---|---|---|---|
| 2013 | +21.757 / 5.621 / -3.697 (509 op) | +21.095 / 7.790 (630) | +28.829 / 7.633 / -4.832 (722) ; +32.511 / 9.252 / -7.057 (742) | +23.982 / 9.720 / -6.891 (809) ; +21.311 / 8.430 / -6.213 (784) | **+23.578 / 5.798 / -3.753 (673)** |
| 2018 | +13.535 / 5.504 (548) | +16.197 / 5.908 (706) | +14.981 / 8.469 / -2.924 (839) | +10.126 / 9.333 / -3.563 (917) | +12.608 / 5.468 / -2.043 (737) |
| 2020 | +20.388 / 3.839 (460) | +21.283 / 5.232 (566) | +26.985 / 5.179 / -2.864 (665) ; +21.985 / 6.176 (660) | +20.851 / 5.849 (748) ; +27.317 / 5.480 (731) | +18.455 / 4.212 / -1.618 (605) |
| 2025 | +30.457 / 3.077 (497) | +35.966 / 4.498 (618) | +36.082 / 4.332 (716) | +39.493 / 4.606 (796) | +29.378 / 3.012 / -846 (636) |
5% di 80.000 = 4.000.

## Previsioni (scritte il 30/10)
- **A1** operazioni crescenti con la Randomization (0 < 50 < 75 < 100) in ogni anno: **SI**, 4/4 anni (a 100 circa +60-70% di operazioni contro Rand 0).
- **A2** DD 2013 >= 8.000: a 75 **in una passata su due** (7.633 e 9.252); a 100 **SI** (9.720 e 8.430). Giorno realizzato >= 5% in almeno un anno: **SI** sia a 75 (2013: -7.057, -4.832) sia a 100 (2013: -6.891, -6.213).
- **A3** PROP-ANNI: Rand 75 **NO** (2013 DD 9.252 e giorni oltre 4.000; 2018 DD 8.469), Rand 100 **NO** (2013 e 2018 DD oltre 8.000, giorni oltre 6.000). Erano 35% e 25% di passare: nessuna passa.
- **A4** ripetibilita: **SI**, differenze fra passate identiche nel netto fra 11% (2013 a 100) e 31% (2020 a 100): non ripetibile.
- **A5** netto medio entro +-25% di Rand 0: **SI** (75: +23-24%, 100: +10-12%), ma a spese del DD.
- **B0** controllo 2013 con moderate riproduce il riferimento (+21.757, DD 5.621): **SI**, esattamente (la passata e deterministica a Rand 0).
- **B1** Auto cambia le operazioni di almeno 10% in 3 anni su 4: **SI**, in 4/4 (+28% / +34% / +32% / +32%). **B2** Auto ha piu operazioni: **SI**, 4/4.
- **B3** DD 2013 di Auto > 5.621: **SI**, ma di poco (5.798, +3%).
- **B4** Auto passa PROP-ANNI: **SI**: netto positivo nei tre anni vecchi, DD massimo 5.798, giorno peggiore -3.753 nel 2013 (-4,7% dei 80.000: il bordo e vicino al 5%), nessun stop out.
- **B5** netto medio Auto entro +-25% di moderate: **SI**: 20.955 contro 21.534 (-2,7%).

## Cosa dicono i numeri
- **Randomization 75-100 peggiora il profilo di rischio.** Per FTMO non conviene alzarla: il DD 2013 passa da 5.621 a 7.600-9.700, il giorno peggiore realizzato da -3.700 a -4.800/-7.100 (oltre 5% in 2013), il netto non migliora in modo stabile (2018 peggiora a 100) e non e ripetibile. A 50 gia peggiorava (DD 7.790).
- **Auto e equivalente a moderate**: operazioni +30%, netto e DD entro circa +-10%, passa PROP-ANNI con lo stesso margine di moderate. Wim ha ragione che Auto funziona: non e meglio, e la stessa cosa con piu operazioni piu piccole. Per il demo prop e il reale non c'e un motivo misurato per cambiare da moderate (gia misurato e installato) ad Auto.
- Il 2013 di Auto ha lo stesso giorno peggiore (23/01/2013) del controllo moderate: -3.753 contro -3.697.

## Cosa NON dice
Un percorso per anno (Auto non ripetuto), Modello 1, 2013/2018/2020 probabilmente dentro l ottimizzazione del venditore, la Randomization del tester puo non rappresentare quella dal vivo, margine a leva FTMO e slippage non simulati. Nessun giudizio su acquisti, lotti o taglie.
