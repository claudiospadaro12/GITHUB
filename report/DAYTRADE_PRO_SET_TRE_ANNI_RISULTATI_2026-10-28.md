# Daytrade Pro Algo con i set del venditore nei tre mercati: RISULTATI (28/10/2026)
Criteri e previsioni scritti prima: `DAYTRADE_PRO_SET_TRE_ANNI_CRITERI_2026-10-27.md`. Fonte: `ANNO80K_DTP_20261028_0253.zip` (archivio `backtest_pipeline/risultati_archivio/ANNO80K_DTP_20261028_0253`, MANIFEST e report .htm.gz). Lettori: `leggi_tre_anni_80k.py` (congelato) e `leggi_dtp_extra.py` (simboli, payoff, posizioni insieme). Non controllata da agenti. Riga `RIGA_LANCIA_DTP_80K.txt`, pin 3e43646d, 80.000 EUR, EURUSD D1 con OneChartSetup e 13 coppie, Modello 1.

**Validita delle corse:** 12 passate a Modello 1 OK (qualita 99-100%, `input_ok = si`, finestre giuste, nessuno stop out, nessun "no money"). **La passata a tick reali di 21 mesi (PROPFIRM) e KO: timeout di 420 minuti (25.214 s), nessun report.** Calibrazione 2025 quindi NON MISURATA.

## Numeri (EUR, 80.000 di deposito)
| Set | Anno | Ops | Netto | PF | DD equity | Peggior giorno | gg >=5% (realizzati) |
|---|---|---|---|---|---|---|---|
| PROPFIRM R27 | 2013 | 382 | +9.044 (+11,3%) | 1,52 | 4.900 | -2,5% | 0 |
| | 2018 | 474 | +9.559 (+11,9%) | 1,45 | 5.282 | -4,0% | 0 |
| | 2020 | 486 | +16.884 (+21,1%) | 2,09 | 3.450 | -1,4% | 0 |
| | 2025 (12 mesi) | 415 | **+720 (+0,9%)** | 1,04 | 3.841 | -1,7% | 0 |
| MEDIUM R6 | 2013 / 2018 / 2020 / 2025 | 382 / 474 / 486 / 415 | +20.312 / +17.428 / +41.522 / +1.288 | 1,50 / 1,31 / 2,05 / 1,04 | 11.682 / 15.445 / 9.136 / 8.791 | -5,7% / -10,7% / -3,3% / -3,7% | 1 / 1 / 0 / 0 |
| HIGHRISK R15 | 2013 / 2018 / 2020 / 2025 | 384 / 477 / 486 / 413 | +56.168 / +45.480 / +137.817 / +752 | 1,48 / 1,27 / 1,95 / 1,01 | 33.240 / 50.228 / 35.609 / 23.546 | -14,2% / -27,5% / -8,4% / -9,3% | 4 / 7 / 2 / 5 |

Esito del lettore: tutti e tre "NON PROP-ANNI". **PROPFIRM: per i tre anni passa tutto** (netto > 0, DD equity <= 8.000, nessuno stop out, nessun giorno >= 5%); l'unico motivo del NO e la calibrazione assente (M4 in timeout). MEDIUM e HIGHRISK falliscono sul DD equity (> 8.000 in tutti gli anni) e sui giorni >= 5%; la loro calibrazione non e valutabile (si misura solo sul PROPFIRM).

## Letture aggiuntive (DERIVATO dalle liste affari, `leggi_dtp_extra.py`)
- Tutte e 13 le coppie operano in ogni anno, 2013 compreso (EURUSD, XAUUSD, AUDUSD, CHFJPY, EURNZD, USDJPY, GBPUSD, USDCAD, NZDUSD, AUDJPY, GBPJPY, EURAUD, EURJPY).
- Vincenti 69-75%, **payoff 0,45-0,56 nel 2013, 2018 e 2025; 0,86-0,92 nel 2020** (quasi nessuna vincita grande: molte piccole vincite, poche perdite grandi).
- Posizioni aperte insieme (conteggio grezzo ingressi meno uscite, approssimato): 19 (2013), 29 (2018), 25 (2020), 28 (2025): sopra il tetto 10 di S-NOSCALA.
- MEDIUM e PROPFIRM fanno le stesse operazioni (stesso numero): cambia solo la taglia (netto circa 2,2x).

## Contro le previsioni
Q1 (PROPFIRM PROP-ANNI, 30%): **non confermabile**: tre anni sì, calibrazione NON MISURATA. Q2 (>= 8 coppie nel 2025): **SI** (13). Q3 (HIGHRISK DD > 8.000 o stop out): **SI**. Q4 (MEDIUM DD > 8.000 in un anno): **SI**. Q5 (calibrazione OK): **NON MISURATA**. Q6 (corsa lunga): **NON MISURATA**. Q7 (>= 10 posizioni insieme): **SI** (conteggio grezzo). Q8 (payoff < 1): **SI**. Q9 (500-1.500 ops in 21 mesi): **NON MISURATA** (415 in 12 mesi del 2025). Q10 (2013 valido): **SI**.

## Cosa dicono e cosa no
- Il set PROPFIRM tiene i tre anni vecchi con DD bassi (3.450-5.282), ma **nel 2025 rende +0,9% con PF 1,04** nello stesso anno in cui l'oro e salito molto: coerente con il rallentamento del segnale live del venditore (34,6% -> 19,5% -> 6,9%), che e un dato dichiarato dal venditore e non nostro. Un solo anno a Modello 1; 2025 non e confermato a tick reali.
- 2013, 2018 e 2020 sono probabilmente dentro la finestra di ottimizzazione del venditore (periodo non verificato per questo EA).
- Il profilo (payoff ~0,5, molte posizioni insieme, 13 coppie) concentra il rischio nelle code: il DD di equity e vicino al DD di saldo qui solo perche i giorni sono ripuliti dai giornalieri D1; non misurato con barre M1 di tutte le coppie.
- Non misurati: correlazione con il Reaper, costi, equity intraday, tick reali, set v2.4 su EA alla 4.51. Nessun giudizio su acquisto o taglia.
