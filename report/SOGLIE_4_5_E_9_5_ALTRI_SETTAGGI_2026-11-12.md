# Quante volte 4,5% giornaliero e 9,5% totale con TUTTI i livelli/settaggi (12/11/2026)

**Natura: MISURA dai report del tester** (BCM, Modello 1, 80.000 EUR, anni 2013/2018/2020/2025; Daytrade Pro 2013/2017/2020/2022/2025). Script `ORO_GRADINI_dati/equity_livelli.py` (equity con flottante ricostruito dalle barre M1, solo oro) e `dtp_livelli.py`-style in `dtp_livelli.json` (realizzato). Livelli: L0 = Prop, L1, L2 = Medium, L3 = Combo.
**Definizioni (come nel Guardian)**: 4,5% = perdita del giorno >= 4,5% del saldo iniziale; 9,5% = equity <= saldo iniziale -9,5% (limite STATICO, `InpTotalDDPct` con `InpDDMode` statico). Conto i GIORNI in cui la soglia e toccata almeno una volta. Il drawdown picco-valle (modalita trailing) e in una colonna a parte.

## 1. EA oro singoli (equity con flottante)
Giorni >= 4,5% (totale 4 anni; per anno 2013/2018/2020/2025) | giorni con perdita dall'iniziale >= 9,5% | peggior giorno | perdita max dall'iniziale | DD picco-valle max
| EA e livello | gg >= 4,5% | per anno | gg >= 9,5% | peggior giorno | perd. max da iniziale | DD picco-valle |
|---|---|---|---|---|---|---|
| Goldbot L0 (Prop) | 0 | 0/0/0/0 | 0 | 2,7% | 1,9% | 3,7% |
| Goldbot L1 | 2 | 2/0/0/0 | 0 | 6,9% | 3,9% | 9,0% |
| **Goldbot L2 (Medium)** | **39** | 17/4/10/8 | **2** (2013, 2018) | 24,6% | 10,5% | 34,7% |
| Goldbot L3 (Combo) | 0 | 0/0/0/0 | 0 | 2,2% | 1,5% | 2,9% |
| Phantom L0 | 0 | 0/0/0/0 | 0 | 1,2% | 1,7% | 2,0% |
| Phantom L1 (Gradino 1) | 0 | 0/0/0/0 | 0 | 3,6% | 3,9% | 5,0% |
| **Phantom L2 (Medium)** | **5** | 4/0/0/1 | **2** (2013) | 12,2% | 9,6% | 17,8% |
| Phantom L3 | 0 | 0/0/0/0 | 0 | 1,3% | 1,6% | 1,9% |
| Reaper L0 (Prop) | 4 | 4/0/0/0 | 0 | 6,0% | 4,2% | 9,4% |
| Reaper L1 | 10 | 7/0/1/2 | **4** (2013) | 10,9% | 9,8% | 15,4% |
| **Reaper L2 (Medium)** | **70** | 22/14/20/14 | **5** (2018) | 37,1% | 13,6% | 51,0% |
| Reaper L3 (Combo) | 0 | 0/0/0/0 | 0 | 2,1% | 2,9% | 3,8% |
| Gold Trade Pro Combo (unico livello testato) | 0 | 0/0/0/0 | 0 | 2,2% | 3,2% | 4,6% |

## 2. I tre EA oro insieme, stesso livello su tutti (conto solo oro 80k)
| Livello | gg >= 4,5% | per anno | gg >= 9,5% | per anno | peggior giorno | perd. max da iniziale | DD picco-valle |
|---|---|---|---|---|---|---|---|
| tutti L0 | 7 | 6/1/0/0 | 0 | - | 8,9% | 7,0% | 13,0% |
| tutti L1 | 23 | 11/2/6/4 | 22 | 21/1/0/0 | 15,7% | 16,8% | 22,9% |
| **tutti L2 (Medium)** | **161** | 42/36/42/41 | **52** | 21/30/0/1 | **56,0%** | 27,6% | 81,8% |
| tutti L3 (Combo) | 0 | 0/0/0/0 | 0 | - | 3,9% | 5,7% | 7,1% |
(Il Medium nel 2013 e nel 2018 tocca il 9,5% dall'iniziale gia in gennaio-febbraio e in 2018 il 10/01: tutti gli EA insieme.)

## 3. Daytrade Pro, tutti i set testati (realizzato, senza flottante; 2013/2017/2020/2022/2025)
| Set | gg >= 4,5% (anno per anno) | peggior giorno | perd. max (saldo) dall'iniziale | gg >= 9,5% |
|---|---|---|---|---|
| Max9 DD low risk (scelto) | 0/0/0/0/0 | 3,1% | 2,3% | 0 |
| daytradeProProp | 0/0/0/0/0 | 3,1% | 2,3% | 0 |
| Max20 DD medium risk | 1/1/0/1/0 (3) | 8,0% | 5,4% | 0 |
| Max50 DD high risk | 6/4/11/6/6 (33) | 28,8% | 13,9% | 28 (2017: 4, 2025: 24) |
Il flottante di Daytrade Pro non e ricostruibile (mancano le barre forex): i valori sono un limite inferiore.

## 4. Le combinazioni SCELTE (dal referto di oggi)
P1, P3, P4: 0 giorni >= 4,5% e 0 giorni >= 9,5% in tutti gli anni testati. Peggior giorno realizzato: P1 -4,2% (2013), con costi centrali -4,4%. Parte oro di P1 4,46% in equity il 31/12/2013 (ultimo giorno del test).

## 5. Lettura
- Tutti i livelli L3 (Combo) e L0/L1 di Goldbot e Phantom non toccano mai il 4,5% (Goldbot L1 2 volte nel 2013). Reaper L0 lo tocca 4 volte (2013) e L1 10 volte.
- Il **Medium (L2)** supera il 4,5% decine o centinaia di volte (Goldbot 39, Phantom 5, Reaper 70; tre insieme 161 giorni in 4 anni) e tocca il 9,5% (static) 2-5 volte per EA e 52 volte da tre insieme: e coerente con quello che hai visto sul trial e sul reale. Il 9,5% e invece piu raro del 4,5% perche gli anni 2020/2025 partono bene.
- Daytrade Pro: Max9 mai; Max20 (medium) 3 volte sopra 4,5% in 5 anni; Max50 33 volte.

## Limiti
- Tester, non live. Equity ricostruita dalle barre M1 con il flottante all'estremo (prudente, non il tick). 3-4 anni, un percorso per anno.
- Il "giorno" e quello del server BCM; FTMO azzera a mezzanotte CET.
- Il 9,5% e calcolato come perdita statica dall'iniziale (equity <= -9,5% in qualsiasi minuto). Dato che gli anni partono sempre dal saldo iniziale, nel 2013 e 2018 i primi mesi pesano molto.
- Combinazioni Medium con Daytrade Pro Max20 e con i set GTP diversi dal Combo NON calcolate (GTP: solo il livello Combo e stato testato per anno).
- Gli ultimi giorni dei test (31/12) possono includere chiusure forzate di fine test.
