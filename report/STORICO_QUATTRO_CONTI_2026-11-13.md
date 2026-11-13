# Storico dei quattro conti (due demo BCM, trial FTMO, reale) — analisi del 13/11/2026

**Natura: MISURA dai report cronologici** esportati il 13/11/2026 alle 08:23-08:25 (stessa analisi del 12/11, `STORICO_REALE_E_TRIAL_2026-11-12.md`). Solo operazioni CHIUSE (profitto + commissioni + swap); niente flottante, niente spread di ingresso. Orari = server del conto (BCM = ora italiana in inverno, FTMO = ora italiana + 1). Base % = capitale iniziale: demo 100.000 (coerente col `totDD` del Guardian), trial 80.000, reale 7.500 (5.000 versati + 2.500 di credito BCM; sui soli 5.000 le % x 1,5). I file NON contengono i versamenti iniziali: le basi sono mie deduzioni dal Guardian e da ieri.
**Finestre dei file** (diverse fra conti): demo 50504263 e 50504894 dal 10/11 17:21; trial dal 12/11 16:56; reale dal 12/11 15:56. Il trial e il reale riportano solo le posizioni chiuse dopo il cambio del 12/11 (le posizioni di prima non ci sono): non so se e un filtro dell'export.

## 1. Riepilogo
| | Demo 50504263 | Demo 50504894 | Trial FTMO 80k | Reale 10105439 |
|---|---|---|---|---|
| Operazioni chiuse (tutte SELL su XAUUSD) | 17 | 30 | 24 | 14 |
| Lotti totali | 12,32 | 2,52 | 0,90 | 0,14 |
| Netto | **+3.812,94** | **-131,35** | **-336,22** | **-116,98** |
| PF | 3,01 | 0,86 | 0,39 | 0,18 |
| Saldo ora | 110.377,45 | 103.961,11 | 76.847,32 | 3.504,36 (+2.500 credito) |
| Giorni con perdita >= 4,5% / >= 9,5% | 0 / 0 | 0 / 0 | 0 / 0 | 0 / 0 |
| Peggior giorno chiuso | +3,81% (guadagno) | -0,63% (13/11) | -0,48% (13/11) | -1,20% (13/11) |
| Drawdown massimo del saldo (da report) | 1,67% | 0,84% | 0,68% | 3,81% |
| Max posizioni aperte insieme | 16 | 29 | 24 | 14 |

## 2. Per EA (operazioni chiuse)
| Conto | EA | Op. | % vinc. | Netto | PF | Peggiore | Lotti |
|---|---|---|---|---|---|---|---|
| Demo 263 | Gold Reaper | 4 | 100% | +3.298,77 | - | +225,97 (min) | 4,60 |
| | Gold Phantom | 5 | 0% | -1.579,91 | 0,00 | -602,64 | 1,66 |
| | non attribuito (ordini senza commento) | 8 | 75% | +2.094,08 | 8,06 | -226,67 | 6,06 |
| Demo 894 | Gold Reaper | 4 | 100% | +414,46 | - | +34,43 (min) | 0,96 |
| | Goldbot One | 8 | 25% | -526,81 | 0,24 | -281,31 | 0,80 |
| | Gold Phantom | 9 | 0% | -192,61 | 0,00 | -52,85 | 0,19 |
| | non attribuito | 9 | 78% | +173,61 | 8,71 | -17,44 | 0,57 |
| Trial | Goldbot One | 8 | 25% | -334,71 | 0,22 | -166,42 | 0,46 |
| | Gold Phantom | 10 | 0% | -120,30 | 0,00 | -44,71 | 0,14 |
| | Gold Reaper | 6 | 100% | +118,79 | - | +4,58 (min) | 0,30 |
| Reale | Goldbot One | 8 | 25% | -89,98 | 0,15 | -41,95 | 0,08 |
| | Gold Phantom | 3 | 0% | -37,95 | 0,00 | -14,21 | 0,03 |
| | Gold Reaper | 3 | 100% | +10,95 | - | +1,53 (min) | 0,03 |
Su demo 263 il Goldbot non compare fra gli EA attribuiti (le sue posizioni possono stare nei "non attribuiti": ordini senza commento; NON verificato). Su tutti e quattro i conti: i tre EA di Wim (Goldbot, Phantom, Reaper), non le combinazioni scelte per le prop.

## 3. Giorno per giorno (chiuso)
| Conto | Giorno | Netto | % |
|---|---|---|---|
| Demo 263 | 12/11 | +3.813,26 | +3,81% |
| Demo 894 | 12/11 | +494,54 | +0,49% |
| | 13/11 | -625,87 | -0,63% (Goldbot) |
| Trial | 12/11 | +46,72 | +0,06% |
| | 13/11 | -382,94 | -0,48% (Goldbot) |
| Reale | 12/11 | -26,94 | -0,36% |
| | 13/11 | -90,04 | -1,20% (Goldbot) |

## 4. Lo stesso evento su quattro conti
Alle 15:56:48 BCM (16:56:48 FTMO) del 12/11 tutti e tre gli EA hanno aperto in 6 secondi una raffica di posizioni SELL attorno a 3.866-3.874: **12 (demo 263), 24 (demo 894), 22 (trial), 13 (reale)**. Nel cluster: netto demo 263 **+3.033,77** (+3,03%), demo 894 **-156,57** (-0,16%), trial **-323,53** (-0,40%), reale **-112,86** (-1,50% su 7.500). Chiusure: i Reaper e parte dei Goldbot a profitto in 20-70 minuti (16:10-17:50 BCM); i Phantom e 3-4 Goldbot a perdita fra le 17:51 e le 03:23 del 13/11 (prezzo salito a 3.895-3.915); 3 Goldbot del 13/11 mattina (SL) = la perdita del 13/11 su tutti e quattro i conti. Le posizioni di un cluster **non sono indipendenti**: sono un'unica scommessa aperta in 6 secondi, con 14-29 posizioni contemporaneamente. E la stessa dinamica del 9-10/11 sul trial (raffica, poi chiusura nello stesso minuto).

## 5. Costi e slippage sull'oro
| | Demo 263 | Demo 894 | Trial | Reale |
|---|---|---|---|---|
| Commissioni EUR/lotto | 3,61 | 3,63 | 4,87 | 4,00 |
| Swap EUR/lotto | -1,01 (credito) | -1,79 (credito) | 0,54 | -3,64 (credito) |
| Slippage stop loss (uscita - SL, mediana, USD/oncia) | 0,00 (n=16) | 0,00 (n=29) | -0,05 (n=23, peggiore -0,32) | **-0,28** (n=12, peggiore -0,47) |
Nel demo BCM l'uscita allo SL e sempre al prezzo esatto (slippage 0): le demo non sono rappresentative del reale. Sul reale lo slippage mediano e -0,28 USD/oncia (circa 28 USD/lotto): campione di 12 stop.

## 6. Letture
1. **Nessun giorno chiuso supera il 4,5%**; il peggiore in perdita e il reale (-1,20% su 7.500). Il conto reale ha lotti 0,01-0,03: le percentuali sono molto piu esposte a 3 stop (-90 EUR) che nei conti grossi.
2. **Il Goldbot perde su tutti e quattro i conti, e il Reaper vince su tutti e quattro: un singolo evento (12-13/11), non quattro prove.** Il PF diverso (0,18-3,01) viene dai lotti e dalle quote di ogni EA, non da prove indipendenti.
3. **Il cluster conferma il rischio gia misurato nei test**: 13-24 posizioni aperte in 6 secondi, tutte nello stesso verso.
4. **Costi**: BCM demo e reale 3,6-4,0 EUR/lotto, FTMO 4,9 EUR/lotto di commissione, swap quasi nullo su operazioni di poche ore.

## Limiti
Solo chiuso, nessun flottante; basi % dedotte; finestre diverse fra conti; i "non attribuiti" sono ordini senza commento (non so a quale EA appartengano); un solo evento; nessuna conclusione su lotti, taglie o acquisti.
