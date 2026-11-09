# Margine dell'oro a leva 1:100, 1:30 e 1:9 per i conti solo oro (09/11/2026)

**Natura: MISURA per calcolo, senza passate nuove nel tester.** Il numero 5 della lista (test a leva 1:30) non si puo fare con una riga: nel tester la leva e quella del conto demo (il `.ini` con 500 fu ignorato: il report del conto reale 3.745 stampo 1:100 invece di 1:500) e il margine dell'oro nel tester BCM e fisso per lotto (nota R114: circa 10.000 USD a lotto), quindi una passata "a 1:30" misurerebbe la stessa cosa. Si calcola invece dai report gia raccolti: per ogni minuto **lotti d'oro aperti insieme x 100 once x prezzo x cambio / leva**, contro l'equity ricostruita (`RISULTATI_EQUITY_CONTI_ORO_2026-11-09.md`). Script: `ORO_GRADINI_dati/margine_oro.py`, dati `margine_oro.json`. 80k, anni 2013/2018/2020/2025, stessi lotti dei test. Un conto da 160k ha lo stesso rapporto (lotti e equity x2, D160).

## Risultato: margine usato come % dell'equity (anno peggiore) e livello di margine minimo a 1:30
| Conto | Lotti aperti max | 1:100 | **1:30** | 1:9 (ipotesi, NON verificata) | Livello di margine minimo a 1:30 |
|---|---|---|---|---|---|
| A Reaper L0 | 9,5 (2013) | 14% | **47%** | 156% | 213% |
| A Reaper L3 | 3,2 | 5% | 17% | 56% | 590% |
| B Phantom L1 + GTP Combo | 6,2 | 10% | **33%** | 110% | 303% |
| B Phantom L0 + GTP Combo | 5,3 | 8% | 28% | 94% | 354% |
| G-A Phantom L1 + Goldbot L0 | 5,4 | 6% | 19% | 65% | 516% |
| G-B Phantom L0 + Goldbot L0 | 4,1 | 4% | 14% | 45% | 733% |
| G-C Reaper L3 + GTP Combo | 7,7 | 12% | 41% | 138% | 242% |
| G-H Phantom L1 + Goldbot L0 + GTP | 8,4 | 11% | 36% | 119% | 279% |

## Letture
- **A 1:30 il margine non e un problema**: nel caso peggiore (Reaper L0 nel 2013) usa il 47% dell'equity, con livello di margine minimo 213%; le combo che consideriamo (B, G-A, G-B) usano il 14-33%. **Non serve tagliare i lotti per lo Swing a 1:30** (la mia ipotesi precedente, "circa 2/3 dei lotti", era sbagliata: NON misurata, ora smentita).
- **A 1:9** (leva sui metalli scritta nella nota di Massimo del 07/11, che il sito FTMO **non conferma**: lo Swing e indicato 1:30) il margine supererebbe il 100% dell'equity con Reaper L0 (156%), Phantom L1 + GTP (110%) e G-C/G-H nel 2013, e andrebbe al 94-95% con Phantom L0 + GTP: **non sarebbe praticabile**. Va chiesto a FTMO la leva dell'oro, per simbolo, su Standard e Swing.
- **Gli anni con prezzo basso (2013, circa 1.200-1.700 USD)** hanno piu lotti per euro di rischio, quindi il margine piu alto. Oggi l'oro vale molto di piu: i lotti dei set sono dimensionati sul rischio, quindi il margine in % dell'equity cala (2025: 15-27% a 1:30 per quasi tutti i conti).
- **Reaper L0** al 47% nel 2013 conferma che e il conto piu pesante: stesso verdetto dell'equity (9,4% di DD).

## Limiti
Solo oro (Daytrade Pro escluso: i margini forex sono piccoli ma non calcolati); soglie di margin call e stop out di FTMO NON TROVATE; l'equity e la ricostruzione prudente (flottante all'estremo di barra, cambio medio annuo); prezzo = chiusura della barra; ordini pendenti non usano margine finche non sono eseguiti; un percorso per anno; la leva dell'oro su FTMO non e verificata. Nessun giudizio su lotti o taglie.
