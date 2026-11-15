# Full results di 12 conti di Wim su Karnek: cosa contengono davvero (15/11/2026)

**Fonte**: zip `KARNEK_FULL_RESULTS_2026-11-15` (archiviato in `KARNEK_FULL_RESULTS_2026-11-15/`: 12 testi, 12 schede "dati chiave", 36 schermate JPEG). Il pannello "Full results" non e leggibile come testo: **i valori sono stati trascritti dalle schermate** (rischio di errore di lettura; dove non leggibile e scritto "non leggibile"). Dati dichiarati da Karnek, selezione del venditore. Le mie osservazioni sono marcate come tali. **Nessun conto mostra lotti, rischio per operazione, nomi degli EA o magic number**; mostrano solo: strumenti e quota delle operazioni (per alcuni conti), leva, durata media, miglior e peggior giorno, DD massimo, PF, win rate.

## Conti con la composizione per strumento (quota delle OPERAZIONI)
| Conto | Strumenti (quota operazioni) | Leva | Durata media |
|---|---|---|---|
| **UBS Live Portfolio** (Raw Trading, dal 14/05/2026) | XAUUSD 39,9% - BTCUSD 28,6% - USTEC 11,5% - US30 8,7% - EURUSD 7,1% - US500 3,0% - altri 1,3% | 1:1000 | 9 h 13 m |
| **Darwinex UBS Gold+USTEC** (dal 19/05/2025) | NDX 59,7% - XAUUSD 40,3% | 1:200 | 8 h 26 m |
| **MEX COMBO** (22 strumenti, dal 16/07/2024) | XAUUSD 36,3% - UT100 11,4% - US500 10,3% - BTCUSD 7,7% - AUDCAD 7,0% - GBPAUD 4,7% - altri 22,6% | 1:500 | 16 h 38 m |
| **indicement** | USTEC 43,3% - US500 34,6% - US30 22,1% | 1:500 | 4 h 10 m |
| **Stability Pro** | AUDCAD 58,0% - NZDCAD 35,0% - AUDNZD 6,9% | 1:500 | 1,5 giorni |
| **Luna AI** (14 strumenti) | GBPAUD 20,7% - EURAUD 17,4% - AUDCAD 13,2% - EURCAD 11,0% - GBPCHF 7,8% - AUDUSD 6,1% - altri 23,8% | 1:500 | 4 h 18 m |
Conti **senza** elenco strumenti nel pannello: UBS Scalp SetC, Steady Yeti, Axi Select, Daytrade Pro ICM, Pro Stability, Combo Setup High Risk ICM.

## Rischio e coda (miglior/peggior giorno, DD massimo, PF)
| Conto | Peggior giorno | DD max | PF | Mesi vincenti | Win rate |
|---|---|---|---|---|---|
| UBS Live Portfolio | -7,8% | -26,1% | 1,10 | 4/7 | 56,2% |
| Darwinex UBS Gold+USTEC | **-4,3%** | -20,5% | 1,27 | 11/19 | 52,8% |
| UBS Scalp SetC (54 s a operazione, 95 trade, 4 mesi) | -4,4% | -8,3% | 3,48 | 4/4 | 80,0% |
| Steady Yeti | -10,3% | -19,1% | 1,40 | 43/56 | 75,6% |
| Axi Select (1 anno) | -7,9% | -12,0% | 2,29 | 11/13 | 87,5% |
| Daytrade Pro ICM | -14,0% | -15,5% | 1,25 | n.d. | 72,0% |
| Pro Stability | -17,0% | -33,1% | 1,52 | 39/51 | 67,7% |
| **Stability Pro** | **-38,5%** | -38,6% | 1,12 | 37/39 | 79,5% |
| **Luna AI** | -10,5% | **-80,4%** | 1,26 | n.d. | 86,8% |
| indicement | -8,4% | -27,8% | 1,02 | n.d. | 57,2% |
| Combo Setup High Risk ICM | -15,7% | -27,1% | n.d. | 15/23 | n.d. |
| MEX COMBO | -29,3% | -56,4% | 1,27 | 18/29 | 64,1% |

## Letture (mie, non dichiarate da Wim)
1. **Il portafoglio di Wim e per classe di mercato, non per un solo EA**: i conti "combo" e "UBS Live Portfolio" mescolano oro (circa 36-40% delle operazioni), indici (circa 15-45%), bitcoin (8-29%) e forex (7-35%). L'oro e la quota singola piu grande, non l'unica.
2. **Gli EA non oro della famiglia "alto win rate, vincita piccola"** (Stability Pro, Luna AI: win rate 79-87%, vincita media circa un terzo della perdita media "AVG WIN / LOSS 0,3:1") hanno **code enormi**: peggior giorno -38,5% (Stability Pro) e DD -80,4% (Luna AI). Per FTMO (-5% al giorno, -10% totale) sono inutilizzabili senza un freno esterno, e anche con il freno restano il tipo di strategia che da pochi giorni vincenti piccoli e un giorno disastroso.
3. **UBS con Nasdaq conta**: nel conto Darwinex UBS Gold+USTEC il 59,7% delle operazioni e sull'indice e il peggior giorno e il piu basso del lotto (-4,3%); PF 1,27, DD -20,5%, 11 mesi vincenti su 19. E il dato piu vicino a "UBS non solo oro". Campione: 19 mesi, 1.644 operazioni.
4. **Il conto con il PF piu basso e proprio quello con piu mercati (UBS Live Portfolio, PF 1,10, 4 mesi vincenti su 7)**: diversificare per mercato non ha reso quanto il solo oro, nei primi 6 mesi. Un conto, 6 mesi: campione piccolo.
5. **"UBS Scalp SetC"** (54 s a operazione, 95 operazioni, +204,6% in 4 mesi, PF 3,48): troppo breve per fidarsi, e a quella durata spread e slippage pesano molto (vedi lo Scalper Claudio).

## Cosa possiamo prendere per "una cosa simile" (decisione di Claudio)
- La **struttura**: oro come pilastro, piu indici (UBS su Nasdaq e US500), piu eventualmente forex e bitcoin, con quote di operazioni dichiarate.
- I **limiti**: nessun lotto o rischio per EA e visibile; i valori sono di conti ad alto rischio e leva 1:200-1:1000, non confrontabili con una challenge a 1:15 (Swing).
- **Per le nostre challenge** serve un peggior giorno ben sotto il 5%: dei 12 conti solo Darwinex UBS Gold+USTEC (-4,3%) e UBS Scalp SetC (-4,4%, ma 95 operazioni) ci stanno, e solo come dato dichiarato.

## Cosa NON c'e
Lotti, rischio per operazione, nomi degli EA, magic number, tabelle dei trade, depositi e prelievi, rendimenti giornalieri, long contro short, data del drawdown massimo. Per i conti combo non e indicata la composizione (tranne MEX COMBO).
