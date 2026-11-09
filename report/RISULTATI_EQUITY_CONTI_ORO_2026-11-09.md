# DD equity vero dei conti solo oro, con il flottante ricostruito (09/11/2026)

**Natura: MISURA (ricostruzione), senza passate nuove nel tester.** Fino ad ora il DD equity delle combo era un "limite superiore" (somma dei massimi dei singoli EA). Qui si ricostruisce la curva di equity del conto sommando le posizioni dei report (80k, Modello 1) e il loro profitto/perdita flottante, calcolato dalle barre M1 dell'oro (`exp_all/`, export del 27/10/2026). Script: `ORO_GRADINI_dati/equity_conti_oro.py` (usa `equity_vero.py`), dati `equity_conti_oro.json`.

## Metodo e controlli
- Le posizioni si ricostruiscono dai deal (apertura e chiusura); il flottante e valutato **all'estremo sfavorevole di ogni barra M1** (minimo per i long, massimo per gli short): un valore prudente.
- USD -> EUR con il cambio medio dell'anno: 0,752 (2013), 0,847 (2018, **ipotesi mia**), 0,877 (2020), 0,888 (2025).
- **Controlli**: posizioni non abbinate 0 in tutti i conti e anni; il saldo finale della curva coincide con il netto del report (per esempio Reaper L0 2013: 24.148; Phantom L1 + GTP 2013: 25.566 = 10.873 + 14.693).
- **Non incluso**: Daytrade Pro (non ci sono le barre dei 13 cambi forex). Qui solo conti con EA oro.

## Risultati (80.000 EUR; DD equity picco-fondo %, peggior giorno in equity %, giorni con perdita in equity >= 4,3% / >= 5%)
| Conto | 2013 | 2018 | 2020 | 2025 | Peggior giorno (anno) | Giorni >= 4,3% / >= 5% (4 anni) |
|---|---|---|---|---|---|---|
| A Reaper L0 | **9,4%** | **9,1%** | 5,5% | 4,8% | **6,0%** (18/12/2013) | 4 / 2 |
| A Reaper L3 | 3,8% | 2,5% | 1,5% | 1,5% | 2,1% | 0 / 0 |
| B Phantom L1 + GTP Combo | **8,9%** | 4,5% | 4,8% | 3,9% | **4,3%** (18/12/2013) | 1 / 0 |
| B Phantom L0 + GTP Combo | 6,4% | 4,0% | 4,1% | 2,2% | 2,8% | 0 / 0 |
| G-A Phantom L1 + Goldbot L0 | 6,9% | 5,0% | 4,0% | 3,6% | 4,5% (31/12/2013, ultimo giorno del test) | 1 / 0 |
| G-B Phantom L0 + Goldbot L0 | 4,7% | 3,9% | 2,6% | 2,5% | 3,3% | 0 / 0 |
| G-C Reaper L3 + GTP Combo | 8,2% | 4,4% | 4,1% | 2,7% | 4,3% | 1 / 0 |
| Phantom L1 + Goldbot L0 + GTP (G-H) | **10,9%** | 6,9% | 6,2% | 4,6% | **6,2%** | 3 / 2 |

## Confronto con il "limite superiore" usato finora
| Conto | Limite superiore (somma dei massimi) | DD equity ricostruito (anno peggiore) |
|---|---|---|
| G-A | 9,1% | 6,9% (2013) |
| G-B | 5,9% | 4,7% (2013) |
| B Phantom L1 + GTP | 9,2% | 8,9% (2013) |
| G-C | 8,4% | 8,2% (2013) |
| G-H | 13,6% | 10,9% (2013) |
Il limite superiore sovrastima il DD di 0,3-2,2 punti.

## Letture
- **Reaper L0 da solo non regge**: DD equity 9,4% (2013) e 9,1% (2018), cioe oltre il 90% del limite del 10% a 80k in due anni su quattro, con un giorno a -6,0% in equity (2 giorni oltre -5%).
- **Conto B con Phantom L1 + GTP**: 8,9% nel 2013 e un giorno a -4,3% (18/12/2013): il margine dal 10% e circa 1 punto. Con **Phantom L0 + GTP** il DD e 6,4% e il peggior giorno 2,8%: nettamente piu sicuro.
- **G-A** (Phantom L1 + Goldbot L0): 6,9%, ma il peggior giorno 4,5% cade il 31/12/2013, ultimo giorno del test: puo includere la chiusura forzata di fine test.
- **G-H** supera il 10% nel 2013 (10,9%): conferma che non regge.
- Nei giorni di caduta dell'oro (18/12/2013, 23/01/2013, 11/02/2013) piu EA perdono insieme: i conti sono correlati.

## Limiti
Solo oro; un percorso per anno (Reaper e Phantom Randomization 50: rumore); Modello 1 (barre da 1 minuto) e flottante valutato all'estremo di barra (prudente, ma non e il tick); cambio medio annuo, 2018 ipotesi; Daytrade Pro non incluso; margine e leva FTMO NON VERIFICATI. Nessun giudizio su taglie o lotti.
