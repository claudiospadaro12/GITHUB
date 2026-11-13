# UBS U3b: il margine di sicurezza 1,5 sul DD misurato, fuori periodo — RISULTATI (13/11/2026)

**Natura: MISURA dal tester** (BCM, Modello 1, XAUUSD, deposito 100.000 EUR, qualita 98%). Criteri e previsioni scritti prima: `UBS_U3B_CRITERI_2026-11-13.md`; confronto con `RISULTATI_UBS_U3T_2026-11-13.md`. Dati `D160_dati/ubsu3b.json`, script `analisi_ubs_u3t.py` (adattato alle etichette UBSU3B). Solo tester; nessun giudizio su lotti, taglie, acquisti.
**Validita**: 17 passate valide su 18; 1 KO (`PH_strat8` incrocio X, 2019-2025: report vuoto dopo 1.383 s, lo stesso difetto delle 3 passate KO di OTT1: rilanciabile con una riga da 1 passata). Nelle 17: input imposti confermati, deposito 100.000, nessuno stop out, tutti gli altri input uguali al set.

## Tabella (DD% = DD equity in % del deposito; stesso incrocio di U3T, con `HistoricalMaxDD` x 1,5)
| Set | Inc. | DD% U3T | **DD% U3b** | Netto U3b / U3T | Lotto medio U3b |
|---|---|---|---|---|---|
| Phantom strat8 | X | 1,58 | KO | - | - |
| | Y | 3,03 | **1,94** | 0,66 | 0,27 |
| Phantom strat3 | X / Y | 2,31 / 2,58 | **1,50 / 1,63** | 0,63 / 0,66 | 0,13 / 0,22 |
| Goldbot dailyC | X | 0,72 | 0,46 | 0,65 | 0,46 |
| | Y | 8,84 | **5,60** | 0,63 | 2,57 |
| Gold Trade Pro E | X / Y | 3,09 / 2,02 | **1,90 / 1,33** | 0,64 / 0,65 | 0,57 / 0,70 |
| Phantom Gold_c | X / Y | 2,31 / 2,58 | 1,50 / 1,63 | 0,63 / 0,66 | 0,13 / 0,22 |
| Goldbot dailyI | X / Y | 1,62 / 2,88 | 1,07 / **1,83** | 0,64 / 0,66 | 0,11 / 0,22 |
| Gold Trade Pro a | X / Y | 2,43 / 2,03 | 1,60 / 1,31 | 0,65 / 0,65 | 0,17 / 0,23 |
| Reaper s5 H1 | X / Y | 1,18 / 3,79 | 0,72 / **2,49** | 0,65 / 0,66 | 0,12 / 0,36 |
| Reaper s1 D1 | X / Y | 1,76 / 2,44 | 1,14 / 1,50 | 0,62 / 0,73 | 0,05 / 0,10 |
Phantom strat3 e Gold_c sono la stessa strategia (non due prove indipendenti).
**Sintesi (17 valide)**: casi contenuti (DD% <= 2,5): **16 su 17** (U3T sugli stessi 17: 10); casi sopra 3,0: **1** (U3T: 4); **massimo 5,60%** (U3T 8,84%); DD% mediano **1,50** (U3T 2,43); netto mediano al **65%** di U3T (da 62% a 73%).

## Verdetto (regola fissata prima)
UTILE richiedeva almeno 15 casi contenuti su 18 e massimo <= 4,0%. Qui i contenuti sono 16 su 17 ma il massimo e 5,60% (Goldbot dailyC, incrocio Y, dove il DD01 del periodo di prova era 3,08 volte quello di misura) → **PARZIALE**.

## Previsioni
| | Previsione | Esito |
|---|---|---|
| U3b-1 | >= 16 passate valide su 18 (90%) | **confermata** (17) |
| U3b-2 | contenuti >= 15 su 18 (55%) | **confermata** (16) |
| U3b-3 | massimo DD% > 4,0 (70%) | **confermata** (5,60) |
| U3b-4 | Goldbot dailyC incrocio Y ancora > 3,0% (85%) | **confermata** (5,60) |
| U3b-5 | DD% mediano fra 1,4 e 1,9 (65%) | **confermata** (1,50) |
| U3b-6 | rapporto netto mediano fra 0,55 e 0,80 (75%) | **confermata** (0,65) |
| U3b-7 | PARZIALE 50% (UTILE 25%, INUTILE 25%) | **PARZIALE** |

## Letture
1. Il cuscinetto 1,5 funziona come previsto: il DD% scende di circa 1/3 (mediana da 2,43 a 1,50), il netto scende del 35% (65%): per ogni punto di DD in meno si perde circa lo stesso peso di netto.
2. Il difetto che resta e uno solo: i set il cui DD01 cambia molto fra i periodi (Goldbot dailyC: rapporto 3,08 → 5,60%). Un cuscinetto fisso non basta per questi: serve almeno il rapporto fra i due periodi (nel caso dailyC circa 3).
3. Fuori periodo il DD% di tutti gli altri 15 casi e <= 2,49%.
## Limiti
17 passate su 18; lotto arrotondato a 0,01 (Reaper s1 D1 e Goldbot dailyI hanno lotti 0,05-0,11: la proporzione e meno esatta); due periodi (2013-18 / 2019-25); un percorso per set; cambio EUR/USD 1,15; Modello 1.
