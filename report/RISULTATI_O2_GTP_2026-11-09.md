# O-2 per Gold Trade Pro: costo della chiusura del venerdi (09/11/2026)

Criteri e previsioni G1-G7 scritti PRIMA: `CRITERI_O2_GTP_2026-11-09.md`. Dati: `ANNO_ORO_GRADINI_GTPFRI19_20261109_1654.zip` (4 passate), parser `D160_dati/parse_cartelle.py`, dati `D160_dati/d160_gtpfri.json`. Gold Trade Pro COMBO (Risk=3, MaxRiskPerStrategy 0,5, PropFirmMaxDailyDD 4,0), XAUUSD D1, 80.000 EUR, Modello 1, terminale BCM, solo tester, **FridayStopHour=19** (unico input cambiato). Riferimento a FridayStopHour=25: `GTP_COMBO_TRE_ANNI_RISULTATI_2026-11-04.md` (deterministico, Randomization 0).

## Validita
4 passate su 4 valide: stato OK, deposito 80.000, qualita 99-100%, `FridayStopHour=19` e gli altri input confermati dal report, 0 stop out, 0 "no money".

## Risultati
| Anno | Netto base | Netto FRI19 | Rapporto | DD equity base -> FRI19 | Operazioni | Peggior giorno realizzato base -> FRI19 | Posizioni che attraversano il weekend base -> FRI19 |
|---|---|---|---|---|---|---|---|
| 2013 | 14.693 | 14.585 | **0,99** | 4,45 -> 4,46% | 325 -> 321 | -2.190 -> -2.190 | 4 (1,2%) -> 0 |
| 2018 | 8.753 | 8.766 | **1,00** | 3,52 -> 3,56% | 330 -> 328 | -1.360 -> -1.360 | 5 (1,5%) -> 1 (0,3%) |
| 2020 | 6.529 | 4.533 | **0,69** | 5,94 -> 4,61% | 288 -> 284 | -905 -> -1.128 | 17 (5,9%) -> 0 |
| 2025 | 8.843 | 8.073 | **0,91** | 1,91 -> 1,92% | 276 -> 271 | -818 -> -818 | 16 (5,8%) -> 0 |
| **Somma 4 anni** | **38.818** | **35.958** | **0,926** (costo 7,4%) | DD entro +0,05 punti, nel 2020 -1,33 | 1.219 -> 1.204 | peggiora solo nel 2020 | **3,4% -> 0,1%** |
Le posizioni che attraversano un weekend sono calcolate dai deal (apertura e chiusura che comprendono un sabato). Le aperture del venerdi dalle 19:00: 2 nel base (2025), 0 con la chiusura.

## Classificazione con la regola scritta
- **CHIUDE**: attraversamenti 3,4% -> 0,1% (soglia < 2%). Vero.
- **ALTO**: rapporto 0,69 nel 2020 (< 0,85), e il Gold Trade Pro e deterministico, quindi la differenza **non e rumore**. Il DD non peggiora (4/4 entro +1 punto).
- Sommando i 4 anni il costo e **7,4%**, in linea con il Goldbot (9-10%) e Reaper/Phantom (7-12%): il 2013 e il 2018 non perdono nulla, il 2025 perde 8,7%, il 2020 il 31%.
- **Non spiegato**: nel base 2020 le posizioni che attraversavano il weekend avevano un profitto totale di soli +459, mentre il netto cala di 1.996: il resto viene da altri effetti della chiusura (ordini e lotti dopo i cambi di saldo, ingressi del lunedi). **NON VERIFICATO** quale.

## Previsioni G1-G7 contro i risultati
| # | Previsione | Esito |
|---|---|---|
| G1 | 4 passate valide: 90% | **Vero** |
| G2 | Chiude (attraversamenti < 2%): 80% | **Vero** (0,1%) |
| G3 | Rapporto sommato fra 0,88 e 0,95: 60% | **Vero** (0,926) |
| G4 | DD entro +1 punto in almeno 3 anni su 4: 75% | **Vero** (4/4) |
| G5 | Almeno un anno con rapporto < 0,85: 35% | **Vero** (2020: 0,69) |
| G6 | Verdetto ZONA GRIGIA 50%; ACCETTABILE 15%; ALTO 35% | **ALTO** (la meno probabile fra le tre che avevo dato) |
| G7 | Il peggior giorno non peggiora in nessun anno: 70% | **Falso** (2020: -905 -> -1.128) |

## Cosa cambia
- **Gold Trade Pro: la chiusura del venerdi e misurata**: costa il 7,4% sul totale, ma con un anno (2020) a -31%. Per la regola per anno e **ALTO**, come Reaper e Phantom L0, e peggio del Goldbot (zona grigia). Il Gold Trade Pro resta **TESTATO CON QUESTI LIMITI** (la sorpresa del 2020 impedisce il "testato bene").
- **Per un conto finanziato FTMO Standard** (dove i weekend aperti sono vietati): la chiusura dei trade il venerdi costa sul Gold Trade Pro circa il 7% del profitto sui 4 anni, con forte variabilita fra anni (0%, 0%, -31%, -9%).

## Limiti
Un percorso per anno, Modello 1, tester senza slippage, `FridayStopHour=19` e ora del server BCM (GMT+1 fisso); l'equivalenza con le 3 ore prima della chiusura su FTMO NON VERIFICATA. Nessun giudizio su acquisti, taglie o lotti.
