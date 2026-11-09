# O-2: costo della chiusura del venerdi (`FridayStopHour=19`) sul trio oro (09/11/2026)

Criteri e previsioni W1-W10 scritti PRIMA: `CANCELLO_MINIMO_PRIMA_DI_UBS_2026-11-08.md` (O-2, con la revisione del 09/11). Dati: `ANNO_ORO_GRADINI_WEEKEND2_20261109_0600` in 8 zip (`WIM_01..08`; indice `00_INDICE.txt`, 0 file non letti), analisi in `FOREX_OOS_dati/o2_res.json` e `o2_celle.json`. Trio oro di Wim (Reaper H1, Phantom H1, Goldbot One D1, XAUUSD), L0 Prop e L3 Combo 3GOLD, 2013, 2020, 2025, 80.000 EUR, Modello 1, terminale BCM, solo tester. Reaper e Phantom (Randomization 50): FRI19 in 2 ripetizioni + 1 ripetizione del base (BASE_R1) + base del 06/11; Goldbot (Randomization 0): 1 FRI19 contro il base del 06/11.

## Validita
- **42 passate lanciate, 41 valide, 1 KO**: `FRI19_R1_L3_PH_2020` e **KO** (il tester ha scritto un report vuoto: periodo 1970, deposito 0, zero operazioni; "una misura mancante", non un errore dell'EA). Esclusa e dichiarata; la cella ha un solo percorso FRI19 (R2). Le altre 41: input confermati (`si` per FRI19, `nessuno_imposto` per BASE_R1), 0 stop out; qualita 99% nel 2013 e 100% negli altri anni (come i test base).
- I file di alcune passate stavano in zip diversi: ho unito tutto per etichetta; 42 report letti.

## 1) Cosa fa il parametro: CHIUDE le posizioni e blocca le nuove
| | Posizioni che attraversano un weekend | Aperture il venerdi dalle 19:00 |
|---|---|---|
| Base (tutti i test base, 18 passate + 12 BASE_R1) | **3,5%** in media (max 6,7%) | 29 |
| FRI19 (30 passate) | **0,15%** in media (max 0,8%) | **0** |
Con il parametro alle 19 le posizioni vengono chiuse prima del weekend e non si aprono ordini nuovi dopo le 19 del venerdi (soglia scritta: CHIUDE se < 2%).

## 2) Costo, sommando i 3 anni (netto medio dei percorsi; FRI19 contro base)
| EA, livello | Netto base | Netto FRI19 | Rapporto | DD medio base -> FRI19 |
|---|---|---|---|---|
| Reaper L0 | 76.168 | 70.654 | **0,93** | 5,0% -> 5,2% |
| Reaper L3 | 21.639 | 19.067 | **0,88** | 2,4% -> 2,2% |
| Phantom L0 | 17.376 | 16.037 | **0,92** | 1,4% -> 1,3% |
| Phantom L3 | 18.202 | 16.666 | **0,92** | 1,4% -> 1,3% |
| Goldbot L0 (deterministico) | 39.336 | 35.806 | **0,91** | 2,5% -> 2,2% |
| Goldbot L3 (deterministico) | 30.636 | 27.695 | **0,90** | 2,0% -> 1,8% |
**Costo complessivo: circa il 7-12% del profitto, il DD invariato o un po piu basso.** Il Goldbot e l'unica misura senza rumore: -9% e -10%.

## 3) Rapporti per anno e regola scritta (KO escluso)
Rapporto = netto medio FRI19 / netto medio base (in parentesi: la cella e NON DISTINGUIBILE DAL RUMORE se la differenza e minore dello scarto fra le ripetizioni).
| Cella | 2013 | 2020 | 2025 |
|---|---|---|---|
| Reaper L0 | 1,13 (rumore) | **0,74** | 0,94 (rumore) |
| Reaper L3 | 0,85 (rumore) | **0,79** | 0,98 (rumore) |
| Phantom L0 | **0,78** | 0,96 (rumore) | 0,99 (rumore) |
| Phantom L3 | 0,76 (rumore) | 0,94 (rumore; 1 solo percorso FRI19) | 1,00 (rumore) |
| Goldbot L0 | 0,96 | 0,87 | 0,86 |
| Goldbot L3 | 0,95 | 0,86 | 0,88 |
**Esito per la regola scritta** (ACCETTABILE se rapporto >= 0,92 in ogni anno e DD +<= 1 punto; ALTO se < 0,85 in un anno distinguibile o DD +3 punti): **Reaper L0, Reaper L3 e Phantom L0 = COSTO ALTO** (un anno con rapporto 0,74-0,79 distinguibile dal rumore); **Phantom L3 = NON CLASSIFICABILE** (tutte le celle nel rumore); **Goldbot L0 e L3 = ZONA GRIGIA** (rapporti 0,86-0,96, nessuno sotto 0,85). Il DD non peggiora mai di oltre 0,8 punti (18 celle su 18 entro +1).
**Come leggerlo**: sommando i 3 anni il costo e del 7-12% (tabella sopra); la regola "per anno" boccia Reaper e Phantom per anni singoli (2020 per il Reaper, 2013 per il Phantom) in cui un percorso casuale puo spostare il rapporto di 10-20 punti. La stima piu affidabile e quella del Goldbot, deterministico: circa **-9/-10%**.

## Previsioni W1-W10 contro i risultati
| # | Previsione | Esito |
|---|---|---|
| W1 | Il parametro chiude (attraversamenti < 2%): 50%; solo blocca nuove (> 10%): 35% | **Vero** (0,15%); il secondo falso |
| W2 | Perdita fra il 2% e l'8% per i tre EA a L0: 55%; oltre il 15% per almeno uno: 15% | **Quasi**: Reaper -7%, Phantom -8%, Goldbot -9% (appena fuori); oltre il 15%: falso sul totale |
| W3 | DD entro +1 punto in almeno 15 celle su 18: 65% | **Vero** (18 su 18) |
| W4 | Il Reaper ha la perdita relativa maggiore, il Goldbot la minore: 45% | **Falso** (Reaper L3 -12%, Reaper L0 -7%; Goldbot -9/-10%) |
| W5 | Nessuna passata invalida: 85% | **Falso** (1 KO) |
| W6 | Almeno meta delle 12 celle Reaper/Phantom NON DISTINGUIBILI dal rumore: 55% | **Vero** (9 su 12) |
| W7 | Goldbot COSTO ACCETTABILE in tutte e 6 le celle: 50% | **Falso** (rapporti 0,86-0,88 in 4 celle su 6) |
| W8 | BASE_R1 differisce dalla base 06/11 di oltre il 3% in almeno 6 celle su 12: 75% | **Vero** (9 su 12) |
| W9 | Il parametro chiude in tutti e tre gli EA: 40% | **Vero** |
| W10 | Tutte le 42 passate valide: 80% | **Falso** (41 su 42) |

## Letture per i piani
- **Sul conto finanziato Standard FTMO** (weekend vietato) una regola come `FridayStopHour=19` costa circa il **9-10% del profitto oro** (misura Goldbot) e **7-12%** sul trio sommato: piu della stima precedente 2-4%. Sulla challenge/verifica e sullo Swing non serve.
- Il valore 19 e **3 ore prima della chiusura**: anche le aperture del venerdi sera (29 nel base, tutte tagliate) sono perse. Un'ora piu tarda costerebbe meno, ma **non l'ho testata** e non conosco l'ora di chiusura dell'oro su FTMO: NON VERIFICATO. La v1.16 del Guardian legge l'ora reale della sessione.
- **Rumore**: Reaper e Phantom cambiano percorso a ogni corsa; i rapporti per singolo anno sono poco affidabili (9 celle su 12 non distinguibili). Sommare i 3 anni e la lettura piu prudente.
- Il weekend pesa meno di quanto stimato: solo il 3,5% delle posizioni del trio oro lo attraversa (le combo P1-P5 con Daytrade Pro erano al 9-18%).
- Limiti: 3 anni, barre da 1 minuto, un parametro a un solo valore (19), nessuna commissione/slippage FTMO.

## Effetto sul cancello (voce O-2: fatta)
Per Reaper, Phantom e Goldbot: "con la chiusura del venerdi (FridayStopHour 19) il parametro chiude davvero le posizioni, costo circa il 7-12% del profitto, DD invariato". Resta dichiarato che Reaper e Phantom hanno un solo percorso casuale nei test base.
