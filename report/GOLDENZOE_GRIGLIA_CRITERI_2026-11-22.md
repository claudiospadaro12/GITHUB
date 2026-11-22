# GoldenZoe: griglia di ottimizzazione sul simulatore — criteri e previsioni (22/11/2026, scritti PRIMA di vedere un numero)
Richiesta di Claudio: "scrivi i criteri e lancia la griglia". Solo simulatore Python, nessun PC di backtest, nessun ordine. Dati: oro FTMO M1 2004-2026 (riga 00:00 con tickvol > 2000 scartata), candele H4, **solo acquisti**, ingresso all'apertura dopo la chiusura sopra il massimo delle N candele precedenti, stop iniziale `mi` x ATR(14), stop mobile Chandelier `mt` x ATR, nessun target, una posizione alla volta. Costi: 0,35 USD per operazione + swap proporzionale 5,5% annuo del valore (stesso metodo di `goldenzoe_piu_operazioni.py`). Misura in R (rischio = stop iniziale).
- **Griglia (48 celle):** N in {30, 40, 55, 80} x mi in {2, 3, 4} x mt in {2, 3, 4, 5}. La cella di base e N=55, mi=3, mt=3 (= GoldenZoe v1.12). Contatore di campagna +48.
- **Periodi:** A 2004-01 -> 2014-10, B 2014-11 -> 2020-12, C 2021-01 -> 2026-11. **La selezione usa SOLO A e B; C e il periodo di verifica, non entra nella scelta.** (Limite dichiarato: C e gia stato visto per la cella di base e per il canale N, non per mi e mt.)
- **Cella idonea:** n >= 50 in A e in B, PF >= 1,20 in A e in B. **Plateau:** almeno il 70% delle celle vicine (un passo in N, mi o mt) ha PF >= 1,10 sia in A sia in B.
- **Miglioramento candidato:** idonea + plateau + min(PF_A, PF_B) >= quello della base + 0,10 + operazioni A+B >= 80% della base.
- **Miglioramento CONFERMATO:** il candidato in C ha PF >= PF della base in C, PF >= 1,30 e R medio > 0. Se nessuno: "GoldenZoe non migliorabile con questa griglia"; nessun cambio di soglia, nessuna seconda griglia dopo i numeri.
- **Previsioni:** P-1 almeno un candidato (A+B): 35%. P-2 almeno un miglioramento confermato in C: 15%. P-3 la cella con il PF_min piu alto in A/B NON e la migliore in C: 80%. P-4 il parametro con la maggiore variazione di PF e lo stop mobile `mt`: 55%. P-5 la base ha PF in A/B tra 1,2 e 1,7 (cioe nessun errore di riproduzione rispetto a 1,27 / 1,67 gia misurati): 85%.
- **Limiti:** 20 operazioni circa l'anno; l'oro e salito per venti anni; lo swap del conto reale (BCM piu pesante di FTMO) non e questo; qualunque vincitore va poi confermato nel tester BCM con tick e swap vero.

## RISULTATI (`backtest_runner/simulatore/goldenzoe_griglia.py`; dati `GOLDENZOE_GRIGLIA_dati/griglia.csv`)
Base riprodotta (A n188 PF 1,27 | B n99 PF 1,67 | C n109 PF 1,61; tutto n396 PF 1,48 t 2,61): P-5 si. Celle idonee 31 su 48.
**Esito con le porte scritte: 2 celle "confermate"** — N55/mi2/mt4 (A 1,44, B 1,43, C 1,85) e N55/mi3/mt4 (A 1,47, B 1,39, C 1,66). Entrambe cambiano solo lo stop mobile da 3 a 4 ATR (e, la prima, lo stop iniziale da 3 a 2).
| Cella | Tutto: n / PF / t | A+B: PF | C: PF |
|---|---|---|---|
| base 55/3/3 | 396 / 1,48 / 2,61 | 1,42 | 1,61 |
| 55/2/4 | 340 / 1,55 / 2,52 | 1,44 | 1,85 |
| 55/3/4 | 319 / 1,50 / 2,36 | 1,44 | 1,66 |
| 40/3/3 (ref.) | 441 / 1,52 / 2,90 | 1,42 | 1,83 |
**Lettura onesta (le soglie NON si cambiano):** formalmente 2 celle passano, ma la regola scelta (min(PF_A, PF_B) + 0,10) premia l'equilibrio fra i due periodi: il PF A+B sale solo da 1,42 a 1,44, il t DIMINUISCE (2,61 -> 2,52 / 2,36) e le operazioni scendono del 14-19%. In pratica A guadagna quello che B perde. Il PF in C passa da 1,61 a 1,66-1,85 (poche operazioni: 87-91). R medio non confrontabile fra mi diversi (il R e in unita di stop iniziale). Il piano mt 3-4 e piatto (medie di PF_min 1,273 contro 1,275): **non e una scoperta, e un vicino del valore attuale**. **Verdetto sostanziale: nessun miglioramento reale; GoldenZoe non e migliorabile in modo apprezzabile su N, stop, stop mobile.** Previsioni: P-1 si (35%); P-2 si (15%, ma vedi sopra); P-3 si (80%: migliore A/B = 55/2/4, migliore in C = 80/2/5); P-4 NO (variazione maggiore su N, 0,115, poi mt 0,089, mi 0,023); P-5 si. Non si adotta nulla senza conferma nel tester BCM con tick e swap vero.

## Aggiunta (22/11, domanda di Claudio: "con costi FTMO?")
**Si: il simulatore usava il costo FTMO** (0,35 USD per operazione + swap 5,5% annuo del valore). Ripetuta la griglia con lo **swap BCM 9,7%** annuo (`SW=0.097`, dati `griglia_swap97.csv`; stessa porta, nessuna soglia cambiata): base A 1,15 / B 1,53 / C 1,49 (PF totale 1,35, t 2,03); celle idonee 6 su 48 (prima 31); unica "confermata" 55/2/4, ma t totale 1,94 e PF A+B uguale alla base (1,29 contro 1,29). **Conclusione invariata (nessun miglioramento reale) e valore assoluto piu basso: con costi BCM il vantaggio e circa 0,13 PF piu piccolo.** Lo spread BCM non e modellato (0,35 USD fisso).
