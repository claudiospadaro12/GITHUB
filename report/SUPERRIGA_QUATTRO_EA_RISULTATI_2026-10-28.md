# Superriga (Gold Trade Pro, Gold Phantom, Stability Pro, DAX Morning Scalp): RISULTATI (28/10/2026)
Criteri e previsioni scritti prima: `GOLD_TRADE_PRO_SET_TRE_ANNI_CRITERI_2026-10-27.md`, `GOLD_PHANTOM_SET_TRE_ANNI_CRITERI_2026-10-27.md`, `STABILITY_PRO_LOTSIZESTEP_TRE_ANNI_CRITERI_2026-10-27.md`, `DAX_MORNING_SCALP_CRITERI_2026-10-27.md`. Fonte: 4 zip leggeri `SUPER_LEGGERO_{GTP,PHANTOM,STAB,DAXMS}.zip` del giro `ANNO80K_SUPER_20261028_1933` (71 passate, 80.000 EUR, pin 3e43646d); archivio `backtest_pipeline/risultati_archivio/ANNO80K_SUPER_20261028_1933` (MANIFEST, REFERTO, report .htm.gz). Lettori: `leggi_tre_anni_80k.py` (GTP, Phantom), `leggi_dax_morning.py` (DAX). Non controllata da agenti.

## Validita delle corse
- **Gold Trade Pro 20/20 OK, Phantom 21/21 OK, DAX 10/10 OK**, `input_ok = si` ovunque.
- **Stability Pro: 20/20 KO per input NON APPLICATI.** `MaxAllowedDD` e `LotsizeStep` NON esistono in questo EA: nel report i nomi veri sono **`MaxAllowedDD_`** e **`LotsizeStep_manually`** (errore MIO sui nomi: nella riga erano quelli del report del venditore). I quattro "livelli" sono quindi la stessa corsa (stessi numeri di operazioni e di netto, controllato). Misura dei livelli: NON VALIDA. Valgono solo come lettura del default (AutoLotMode=3 applicato, passo manuale 0).

## Gold Trade Pro (XAUUSD D1)
| Set | 2013 | 2018 | 2020 | 2025 (12 mesi) | DD equity (2013/2018/2020) | esito |
|---|---|---|---|---|---|---|
| PROPFIRM R1 | +32.907 (+41,1%) | +18.666 (+23,3%) | +14.585 (+18,2%) | +19.645 (+24,6%) | 6.766 / 7.155 / **10.278** | NON PROP-ANNI (solo 2020: DD > 8.000) |
| LOWRISK R15 | +54.744 | +28.889 | +22.914 | +31.412 | 11.043 / 9.092 / 15.678 | NON |
| MEDIUM R3 | +92.889 | +31.043 | +55.423 | +74.874 | 29.884 / 8.098 / 23.882 | NON |
| HIGHRISK R6 | +83.952 | +29.887 | +98.727 | +177.805 | 42.703 / 13.549 / 22.618 | NON (giorni -6% / -9,5% / -13,5%) |
- **Calibrazione 2025 OK per tutti e 4** (rapporto M1/M4 1,01-1,04, correlazione mensile 0,98-0,99).
- **Corsa lunga 21 mesi, PROPFIRM, tick reali:** 472 operazioni, **+38.029 (+47,5%)**, PF 2,81, DD equity **5.588**, peggior giorno -2,1%, nessun giorno oltre -3%.
- PROPFIRM: nessuno stop out, nessun giorno realizzato >= 5% in nessun anno; il solo difetto e il DD equity del 2020 (10.278 contro 8.000).
- HIGHRISK ha righe "no money" (ordini rifiutati per margine): fino a 10.716 nel 2018 e 170 nel 2013: i suoi lotti non stanno nel conto da 80.000.

## The Gold Phantom (XAUUSD H1)
| Set | 2013 | 2018 | 2020 | 2025 (12 mesi) | DD equity (2013/2018/2020) | esito |
|---|---|---|---|---|---|---|
| **PROPFIRM D9** | +9.137 (+11,4%) | +4.859 (+6,1%) | +9.540 (+11,9%) | +13.607 (+17,0%) | 2.992 / 2.000 / 1.801 | **PROP-ANNI** |
| PROPCOMBO D4 | +3.759 | +2.034 | +3.926 | +5.560 | 1.177 / 776 / 615 | NON valutabile (calibrazione solo sul PROPFIRM) |
| LOWRISK D10 | +9.997 | +5.426 | +11.037 | +15.164 | 3.594 / 2.227 / 1.924 | idem |
| MEDIUM D30 | +34.164 | +17.988 | +37.797 | +60.530 | 14.774 / 7.970 / 7.121 | NON (2013 DD 14.774) |
| HIGHRISK D60 | +79.512 | +32.273 | +93.627 | +167.277 | 48.024 / 14.351 / 19.538 | NON (giorno -9,6%) |
- **Calibrazione PROPFIRM OK** (rapporto 1,03, correlazione 1,00). **Corsa lunga 21 mesi:** 1.211 operazioni, **+21.136 (+26,4%)**, PF 2,49, DD equity **1.950**, peggior giorno -0,7%.
- **Rendimento basso:** il PROPFIRM fa circa +6% - +12% l'anno (+17% nel 2025) con DD bassi; il Reaper nello stesso periodo fa +74,7% in 21 mesi.

## Tempi per la challenge, da conto nuovo (calendario, primo giorno di ogni corsa, 80.000; +8.000 poi +4.000)
| Set | 2013 | 2018 | 2020 | 21 mesi |
|---|---|---|---|---|
| Reaper prop (gia riportato) | 120 / 91 | 236 / 176 | 51 / 48 | 112 / 92 |
| GTP PROPFIRM | 99 / 89 | 176 / 100 | 308 / 188 | 201 / 133 |
| Phantom PROPFIRM | 189 / 113 | +8.000 **non raggiunto** / 227 | 328 / 53 | 244 / 120 |
(prima cifra: giorni per +8.000; seconda: giorni per +4.000 sullo stesso conto nuovo). Il GTP e il Phantom sono piu lenti del Reaper; il GTP PROPFIRM non supera il DD solo nel 2020.

## Correlazione dei risultati giornalieri realizzati, 21 mesi, set prop (DERIVATO dalle liste affari)
Reaper/GTP **0,63** (mensile 0,66); Reaper/Phantom **0,55** (mensile 0,72); GTP/Phantom **0,50** (mensile 0,72). Tutte sopra 0,50: i tre soffrono insieme (stesso oro, stesse direzioni).

## Stability Pro (griglia forex, default, NON i livelli)
Default (AutoLotMode=3, passo manuale 0, AutoLotsizeRisk 1): 2013 +52.400 (PF 1,92, DD equity 16.457 = 15,7%), 2018 +16.137 (DD equity 8.184), 2020 +28.740 (6.201), 2025 +14.026 (DD equity 17.731 = 21,3%; a tick reali +12.039, DD 16.545). **DD di saldo solo 2,1-3,4% contro DD di equity 7-21%**: il flottante della griglia e da 3 a 6,6 volte il DD di saldo. 2013 ha 1.092 operazioni (storico presente). Da rifare con i nomi giusti.

## The DAX Morning Scalp (D30EUR M15, 21 mesi, stagioni chiuse)
| Set | Ops | Netto | PF | Vincenti / payoff | DD realizzato |
|---|---|---|---|---|---|
| DEFAULT | 585 | **-22.670 (-28,3%)** | 0,49 | 74% / 0,17 | 24.075 |
| SENZAAGGR | 25 | -329 | 0,96 | 60% / 0,64 | 2.315 |
| UNOAUNO | 614 | **-53.863 (-67,3%)** | 0,77 | 42% / 1,05 | 56.871 (38 giorni >= 3%) |
| REVERSAL | 14 | -1.838 | 0,71 | 43% / 0,95 | 2.419 |
| BRUNCH | 20 | -1.078 | 0,81 | 20% / 2,84 | 4.088 |
**Nessun set passa.** Il DEFAULT d'inverno perde -1.741 (PF 0,83), d'estate -20.929 (PF 0,40). Nota: SENZAAGGR, REVERSAL e BRUNCH fanno pochissime operazioni (14-25) contro 458-1.116 dichiarate dal venditore per i suoi test: NON VERIFICATO se dipende dai set (ore o input) o dal mercato; le percentuali di quei tre set non sono un giudizio sul prodotto.

## Previsioni contro esito
- **GTP:** G1 (PROPFIRM PROP-ANNI, 40%) NO; G2 (almeno un set PROP-ANNI, 50%) NO; G3 (HIGHRISK DD > 8.000) SI; G4 (anno peggiore il 2018) NO (il peggiore e il 2020); G5 (calibrazione >= 3 su 4) SI (4); G6 (2020 fra +10% e +60%) SI (+18,2%); G7 (corsa lunga > +20% e DD <= 8.000) SI; G8 (al massimo 1 giorno >= 3%) SI (0).
- **Phantom:** H1 SI; H2 SI; H3 SI; H4 SI; H5 SI; H6 SI (+26,4%, DD 1.950); H7 SI; H8 SI (1.211 contro 1.199, di misura); H9 SI (2018 il peggiore).
- **Stability:** S1-S5 NON MISURABILI (corse non valide); S7 (2013 ha operazioni) SI; S8 (DD equity >= 3x DD di saldo) SI sul default.
- **DAX:** D1 (almeno un set passa) NO; D2 (DEFAULT PF > 1,15) NO (0,49); D3 (REVERSAL batte DEFAULT per netto) SI (-1.838 contro -22.670); D4 (SENZAAGGR < 55% delle operazioni del DEFAULT) SI (25 contro 585, molto meno del previsto); D5 (vincenti > 70% con payoff < 0,5) SI; D6 (almeno un giorno >= 3%) SI (UNOAUNO); D7 (differenza PF inverno/estate > 0,3) SI (0,43); D8 (DEFAULT 800-1.300 operazioni) NO (585).

## Cosa NON dice
Un percorso per anno, Modello 1 sui tre anni vecchi, nessuna slippage, filtro news non simulato, orologio AutoGMT non verificato su BCM, 2013/2018/2020 probabilmente dentro l'ottimizzazione del venditore. Equita intraday dal flottante non ricostruita da barre M1 per GTP e Phantom (DD equity del report). Nessun giudizio su acquisto, lotto o taglia.
