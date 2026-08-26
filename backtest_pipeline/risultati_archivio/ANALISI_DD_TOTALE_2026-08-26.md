# 📉 ANALISI DD TOTALE — "con il muro del 5% giornaliero, quanto DD totale serve?" (26/08/2026)

_Domanda di Claudio (26/08 sera): "Simulami una prop: DD 5% giornaliero —
il massimo DD totale quanto sarebbe? 10%?". Stessa base delle analisi
firmate: `R105_dataset_giornaliero.csv`, **finestra 2024.09.26→2026.06.30
(481 giorni)**, flotta post-revisione A+b (35 sedie vive, 5 ridotte),
base 100k. SOLO ANALISI: niente righe, niente criteri, niente EA toccati._

_⚠️ Valgono INTERE le tre avvertenze dell'analisi dial (a: scala lineare
ottimista; b: **chiusure giornaliere = limite inferiore**, il flottante
intraday che le prop guardano è invisibile qui; c: Guardian non modellato).
Controllo di coerenza superato: il worst-day tocca −5,00% esattamente a
dial 1,055, come nell'analisi del pomeriggio._

## 📊 LA TABELLA (challenge rolling: 481 partenze, corsa fino a +8%)

Metro del "DD totale" = **peggior discesa sotto il saldo di partenza**
dentro la challenge (è così che le prop a muri statici misurano il totale).

| dial | worst day | **DD tot worst** | p99 | p95 | mediana | viol. −10% | viol. −8% | viol. −6% |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| **1,00** | −4,74% | **−6,37%** | −5,83% | −4,23% | −0,42% | **0** | **0** | 4 |
| 1,055 | −5,00% | −6,73% | −6,16% | −4,46% | −0,45% | 0 | 0 | 6 |
| 1,15 | −5,45% | −7,33% | −6,71% | −4,86% | −0,49% | 0 | 0 | 12 |
| 1,30 | −6,16% | −8,29% | −7,58% | −5,50% | −0,55% | 0 | 4 | 19 |
| 1,60 | −7,58% | −10,20% | −9,34% | −6,77% | −0,67% | 3 | 15 | 36 |
| 2,00 | −9,47% | −12,75% | −11,67% | −8,46% | −0,59% | 15 | 28 | 58 |

Serie intera 21 mesi a dial 1,00: sotto-partenza massimo **−0,72%**
(l'equity sta sopra il saldo iniziale quasi sempre), picco-valle **6,37%**.

## 🎯 LE QUATTRO RISPOSTE

1. **Al dial firmato 1,00 il DD totale peggiore mai visto è −6,37%** (sui
   chiusi). **Un muro totale del 10% lascia ~3,6 punti di margine** per il
   flottante che qui non si vede — è il muro giusto da chiedere alla prop.
2. **Il vincolo che morde è il GIORNALIERO, non il totale**: worst day
   −4,74% contro il muro −5% (margine 5%), DD totale −6,37% contro −10%
   (margine 36%). La sorveglianza operativa va sul giorno (ed è dove il
   Guardian già lavora: pausa a 4,0).
3. **Il DD totale è "un giorno cattivo più poco"**: 6,37 ≈ 1,3 × il worst
   day. La flotta storicamente recupera — le discese non si accumulano su
   settimane. (Sui chiusi; il flottante può allungarle.)
4. **Un muro totale TRAILING del 6% si romperebbe PERSINO sui chiusi**
   (picco-valle 6,37% > 6%): la bocciatura di Upcomers esce confermata da
   un'altra strada. **Muri statici o niente.**

## 🧭 Bonus per il dossier prop

Un totale statico **8%** reggerebbe ancora a dial 1,00 (0 violazioni su
481; le prime compaiono a dial 1,30) — ma senza necessità non si compra
margine più stretto: **la specifica per il cacciatore resta 5% g / 10%
tot statici.**
