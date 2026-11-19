# Filtri di Leonardo su BreakingBand v4: risultato (19/11/2026) - CHIUSO

Criteri scritti prima: `BB_V4_FILTRI_LEONARDO_CRITERI_2026-11-19.md`. Dati: 56 passate (28 cross x H1/M30), 2013-2024, tester BCM Modello 1, EA invariato (rischio 0,5%). Calendario: 8 valute, solo impatto Alto. Hold-out 2025-26 non toccato. Script: `backtest_runner/simulatore/bb_v4_filtri.py`; operazioni una per una: `BB_V4_FILTRI_dati/operazioni_BB_v4_2013_2024.csv`. R = rendimento / 0,5% (costi inclusi).

## Baseline (nessun filtro)
| | operazioni | win | R medio (IC90) | pareggio atteso |
|---|---|---|---|---|
| H1 | 687 | 63,0% | **-0,052** [-0,099; -0,006] | 66,6% |
| M30 | 1.235 | 61,4% | **-0,087** [-0,121; -0,053] | 67,5% |
Vincita media 0,49R, perdita media 0,97R. Netto tester: H1 -17.700 EUR, M30 -53.000 EUR (somma dei 28 conti da 100k). H1 positivo solo in 3 anni su 12; M30 in 1.

## Filtri (R medio operazioni TENUTE contro ESCLUSE)
| Filtro | H1 IS | H1 OOS | M30 IS | M30 OOS | Esito |
|---|---|---|---|---|---|
| MATTINA 07-10 IT | -0,161 vs -0,024 | -0,046 vs -0,062 | -0,177 vs -0,096 | -0,259 vs -0,029 | **peggiora** (IS e OOS in M30, IS in H1); poche operazioni (83/55/76/41) |
| NOTIZIE | -0,053 vs -0,027 | -0,033 vs -0,213 | -0,086 vs -0,241 | -0,043 vs -0,122 | non sostenuto: H1 IS contrario |
| NOTIZIE 2H | -0,056 vs -0,009 | -0,031 vs -0,196 | -0,080 vs -0,245 | -0,032 vs -0,158 | non sostenuto: H1 IS contrario |
| MATT+NOT | -0,090 vs -0,042 | +0,023 vs -0,078 | -0,142 vs -0,100 | -0,218 vs -0,036 | non sostenuto |

**Regola 1 (tenute > escluse in IS e OOS, H1 e M30): nessun filtro la soddisfa. Nessun candidato.** Anche il filtro notizie, il piu' favorevole (esclude operazioni esposte, peggiori in 3 finestre su 4), lascia R tenute negativo in tutte le finestre (IC90 che include 0 solo nella parte alta): togliere le notizie riduce la perdita, non crea un vantaggio. La "mattina" di Leonardo e' l'opposto di quanto dice: le operazioni 07-10 sono le peggiori.

## Previsioni contro misure
- Operazioni 500-1.300 (H1) e doppio in M30: **giuste**. Baseline R tra -0,05 e +0,05 e win 70-77%: **sbagliata** (R -0,052 al limite, win 63%, ma anche il pareggio e' 66,6%, non 75,9% come stimato dalla sala). MATTINA migliora: 25% -> **no**. NOTIZIE migliora (in meta' delle finestre): previsto 30% per tutte -> **no** nell'insieme. Candidato 10% -> **no**. Stesso segno in M30 (55%): **no per la mattina, parziale per le notizie**.

## Esito
Breaking Band (v4, parametri di default) ha R negativo su 12 anni e 28 cross in H1 e M30, e i due filtri di Leonardo non lo portano oltre lo zero. Il 90% di vittorie dichiarato nelle lezioni non si riproduce (63%). **Filone archiviato** secondo la regola 3. Limiti: cross vicini all'euro non indipendenti; l'EA e' quello di Massimo, non una trascrizione esatta delle regole di Leonardo (entrate sulle bande in M5, protocollo scritto mai ricevuto: se arriva si puo' riaprire solo con il protocollo).
