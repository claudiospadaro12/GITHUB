# REFERTO ROUND 49 — Easy Trend in portafoglio: BOCCIATA (14/08/2026)

**Domanda:** le tre serie promosse da R48 entrano nel portafoglio secondo
lo standard di sempre — **aggiunge profitto E non alza le code**?

**Risposta: NO. La famiglia aggiunge +12,6% di profitto e ALZA TUTTE le
code. Nessun sottoinsieme salva la situazione. Famiglia BOCCIATA per il
portafoglio.**

## Igiene: gemelli perfetti

| Serie | magic A | magic B | Esito |
|---|---|---|---|
| CHFJPY | 772411 → +8.199,61 (53) | 772412 → +8.199,61 (53) | identici |
| GBPUSD | 772413 → +10.419,56 (41) | 772414 → +10.419,56 (41) | identici |
| AUDJPY | 772415 → +9.525,40 (54) | 772416 → +9.525,40 (54) | identici |

**Famiglia: +28.145 su 148 chiusure** (finestra OOS, 100k, rischio 1%).

## Il portafoglio: 27 -> 30 serie

| | 27 serie | **30 serie** | |
|---|---|---|---|
| Netto OOS | +223.230 | **+251.375** | +12,6% ✅ |
| DD storico | 5,50% | **7,32%** | ❌ |
| MC p50 | 5,74% | **6,12%** | ❌ |
| MC p95 | 9,89% | **10,80%** | ❌ |
| MC p99 | 12,47% | **14,63%** | ❌ |

A taglia prop (0,65%) il p99 passa da 8,1% a **9,5%**: a un soffio dal
pavimento del 10% FTMO, per un guadagno del 12,6%. **Scambio rifiutato.**

## I sottoinsiemi (provati tutti, come in R37)

| Ingresso | Netto | DD stor | p50 | p95 | p99 |
|---|---|---|---|---|---|
| _baseline 27_ | +223.230 | 5,50 | 5,74 | 9,89 | 12,47 |
| +GBPUSD | +233.650 | 6,00 | 5,98 | 10,37 | 13,25 |
| +AUDJPY | +232.755 | 6,02 | **5,60** | **9,80** | 12,78 |
| +CHFJPY | +231.430 | 5,91 | 5,93 | 10,43 | 14,42 |
| +GBP+AUD | +243.175 | 6,50 | 5,81 | 10,10 | 13,52 |
| +GBP+CHF | +241.849 | 6,39 | 6,13 | 10,68 | 14,49 |
| +AUD+CHF | +240.955 | 6,85 | 5,94 | 10,41 | 13,56 |

Il meno peggio e' **AUDJPY da solo**: abbassa p50 e p95, ma alza p99
(+0,31) e DD storico (+0,52).

**E qui si applica la disciplina, non l'entusiasmo.** In R37 il trio forex
del gap-fill fu promosso con p99 +0,09 PERCHE' c'era una tesi strutturale
scritta prima (il cumulo del lunedi' sugli indici contro la riapertura
domenicale del forex). **Qui una tesi del genere non esiste**: scegliere
AUDJPY dopo aver visto le code sarebbe pesca a posteriori, cioe' il vizio
che l'imbuto esiste per impedire. **Nessun ripescaggio.**

## Il payoff: la domanda di Claudio ha la sua risposta

Con `analizza_payoff.py` sulle serie del tester:

| Serie | win rate | vincita media | perdita media | PAYOFF |
|---|---|---|---|---|
| GBPUSD | 51,2% | 1.488 | 1.042 | **1,43** |
| CHFJPY | 49,1% | 1.512 | 1.152 | **1,31** |
| AUDJPY | 61,1% | 1.017 | 1.145 | 0,89 |

Un motore sano puo' vivere in due modi diversi: GBPUSD e CHFJPY vincono
**circa una volta su due ma guadagnano il 30-40% in piu' di quanto
perdono**; AUDJPY vince spesso (61%) con payoff sotto 1. Entrambe le
forme funzionano. Il conto 100k in forward oggi mostra win rate 60% con
payoff **0,385**: e' la forma di AUDJPY ma con un payoff meta' —
il confronto giusto lo dara' R47 sulle Aperture, che sono gli EA
effettivamente in campo.

## Cosa resta dell'Easy Trend

Il motore **esiste e regge i cancelli**: tick 4/4, walk-forward 3/4, PF
OOS 1,25-1,49, DD sotto il 7% sulle singole serie. Non entra in
portafoglio perche' il portafoglio e' gia' pieno di rischio nelle stesse
ore e sugli stessi cambi: e' un problema di CORRELAZIONE DI CONTESTO, non
di qualita' del motore.

**Proposta (decisione a Claudio):** vivaio in **OSSERVAZIONE** con 3
grafici H1 (come i gap Dow/Nikkei, sedie 19-20): collaudo tecnico pieno e
forward reale, **porta del 100k CHIUSA** finche' una prova di portafoglio
non cambia verdetto. Due cose potrebbero cambiarlo: (a) l'allungamento
della finestra, che permetterebbe le celle MONO-LATO (al tick erano molto
migliori: EURGBP short +2.502, GBPUSD long +1.843, ma in IS non
raggiungevano 20 trade); (b) l'uscita dal portafoglio di serie oggi
correlate. Alternativa: archiviare e basta.

_Dati: `risultati_prove/trades_ez/` (3 serie), `ABTG_EasyTrend/r48/`.
Prove: `prove/R49a-c_ez_*.txt`. Referto precedente: R48._
