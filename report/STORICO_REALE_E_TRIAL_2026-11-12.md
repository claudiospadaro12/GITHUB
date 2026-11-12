# Storico REALE e TRIAL: tabelle con i valori reali (12/11/2026)

**Natura: MISURA dai report cronologici dei due conti** (file inviati da Claudio il 12/11/2026 alle 19:09 e 19:11). Conto reale BCM (EUR, hedging) e conto FTMO Free Trial 2-Step 80k EUR (demo). Valori in EUR, orari = server del conto. Script: `LIVE_dati/leggi.py`, `analisi_live.py`; tabelle complete in `LIVE_dati/STORICO_REALE_TRIAL_TABELLE_2026-11-12.xlsx`.
**Cosa e incluso**: operazioni chiuse (profitto + commissioni + swap). **Cosa NON c'e**: il flottante (equity intraday) e lo spread di ingresso: il report non li contiene. Quindi i "giorni" sono perdita CHIUSA nel giorno, non perdita in equity come la calcola FTMO.
**Definizioni**: base % = capitale iniziale (reale 7.500 = 5.000 versati + 2.500 di credito BCM; trial 80.000). Una perdita giornaliera e la somma dei deal chiusi nel giorno.

## 1. Riepilogo
| | REALE BCM | TRIAL FTMO 80k |
|---|---|---|
| Periodo operazioni | 08/09 - 12/11/2026 | 03/11 - 12/11/2026 |
| Giorni con operazioni | 13 | 6 |
| Operazioni chiuse | 349 | 51 |
| Lotti totali | 7,91 | 3,65 |
| Risultato netto | **-1.405,54 EUR** | **-2.729,18 EUR** (-3,41% di 80k) |
| Saldo ora | 3.594,40 (+2.500 credito) | 77.270,44 |
| Perdita dal capitale iniziale | -18,7% su 7.500 (-28,1% sui 5.000 versati) | -3,41% |
| Giorni di perdita chiusa >= 4,5% | **2** (16/10: -10,71%, 19/10: -6,70%) | **0** (peggiore 10/11: -4,34%) |
| Perdita dall'iniziale >= 9,5% | toccata il 16/10 alle 17:02 | mai (minimo saldo 77.151,50 = -3,56%) |
| Drawdown massimo del saldo | non significativo (conto con depositi) | 3.550,23 EUR = 4,44% (11/11 16:37) |

## 2. Per EA (operazioni chiuse)
**Reale**
| EA | Op. | % vinc. | Netto | PF | Peggiore | Lotti |
|---|---|---|---|---|---|---|
| Finlab X | 196 | 44% | -1.255,98 | 0,29 | -79,51 | 4,55 |
| Gold Phantom | 12 | 17% | -115,75 | 0,40 | -53,87 | 0,12 |
| Gold Reaper | 12 | 58% | -98,51 | 0,28 | -32,57 | 0,12 |
| CF | 112 | 67% | -50,86 | 0,55 | -32,75 | 1,12 |
| DZR | 1 | 100% | +0,88 | - | - | 0,01 |
| DAX Apertura EU Retest | 7 | 100% | +51,34 | - | +0,60 | 1,90 |
| Goldbot One | 9 | 56% | +63,34 | 5,09 | -10,79 | 0,09 |
Gli EA di Wim sul reale (Goldbot + Phantom + Reaper, solo 0,33 lotti): **-150,92 EUR**. Il resto della perdita del reale (-1.255,98) e di Finlab X, nei giorni 16/10 e 19/10.

**Trial**
| EA | Op. | % vinc. | Netto | PF | Peggiore | Lotti |
|---|---|---|---|---|---|---|
| Gold Reaper | 17 | 71% | -2.320,27 | 0,14 | -692,24 | 2,15 |
| Gold Phantom | 25 | 36% | -703,29 | 0,26 | -211,91 | 0,86 |
| Goldbot One | 9 | 56% | +294,38 | 7,00 | -23,70 | 0,64 |

## 3. Giorno per giorno (chiuso)
**Reale**
| Giorno | Netto | % su 7.500 | Chi |
|---|---|---|---|
| 08/09 - 24/09 (7 gg) | +51,34 | +0,7% | DAX Apertura Retest |
| 16/10 | -803,27 | -10,71% | Finlab X -774, CF -31 |
| 19/10 | -502,69 | -6,70% | Finlab X -482, CF -20 |
| 05/11 | +165,73 | +2,21% | Phantom +76, Goldbot +63, Reaper +26 |
| 09/11 | -9,54 | -0,13% | Phantom |
| 10/11 | -280,23 | -3,74% | Phantom -144, Reaper -136 |
| 12/11 | -26,94 | -0,36% | Phantom -38, Reaper +11 |

**Trial**
| Giorno | Netto | % su 80k | Chi |
|---|---|---|---|
| 03/11 | -22,18 | -0,03% | Phantom |
| 05/11 | +723,91 | +0,90% | Phantom +237, Reaper +241, Goldbot +246 |
| 09/11 | -76,25 | -0,10% | Phantom |
| 10/11 | -3.473,76 | -4,34% | **Reaper -2.705, Phantom -774** |
| 11/11 | +31,82 | +0,04% | - |
| 12/11 | +86,90 | +0,11% | Goldbot +49, Reaper +119, Phantom -80 |
Il -4,34% del 10/11 e l'unica perdita chiusa vicina al 4,5%. La posizione chiusa il 10/11 alle 02:32 era stata aperta il 09/11 alle 22:14 (Reaper/Phantom 0,07): il flottante intraday potrebbe aver superato il -4,34% (non misurabile qui).

## 4. Costi e slippage REALI (oro, XAUUSD)
| | Reale BCM | Trial FTMO |
|---|---|---|
| Lotti oro | 6,01 | 3,65 |
| Commissioni | 22,70 = **3,78 EUR/lotto** | 18,66 = **5,11 EUR/lotto** |
| Swap | 8,80 = 1,46 EUR/lotto | 116,99 = **32,05 EUR/lotto** |
| Commissioni + swap | 5,24 EUR/lotto | **37,16 EUR/lotto** |
| Slippage stop loss (uscita - livello SL, mediana) | **-0,18 USD/oncia** (n=127; peggiore -1,21) | **-0,04 USD** (n=31; peggiore -0,69) |
| Slippage take profit (mediana) | -0,04 (n=104) | +0,11 (n=6) |
Lo swap del trial (116,99) pesa: Reaper -88,52 e Phantom -28,47, posizioni tenute la notte. Lo spread di ingresso non si legge dal report: NON misurato.
Confronto con la mia ipotesi di costi "centrali" (36 EUR/lotto oro): coincide col trial (37,16) ma e dominata dallo swap; sul reale BCM i costi sono molto piu bassi (5,24).

## 5. Limiti
- Solo perdita CHIUSA, non equity: FTMO conta anche il flottante.
- Periodi brevi: trial 6 giorni di operativita (3-12/11), EA di Wim sul reale solo dal 05/11. Nessuna conclusione statistica.
- Il conto reale ha 0,01 lotti per gli EA di Wim (lotti 12 volte piu piccoli del trial): le % sul reale non sono confrontabili col trial.
- I giorni 16/10 e 19/10 del reale sono Finlab X, non gli EA di Wim.
- I report del tester non coprono novembre 2026, quindi non si puo confrontare lo stesso periodo tra tester e live.
