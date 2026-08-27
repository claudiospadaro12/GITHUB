# 📐 ANALISI — COSA CAMBIA ABBASSANDO IL CAP C1 (Guardian) PER FINTOKEI

_Richiesta di Claudio dopo la risposta scritta di Fintokei (Q1 = cap 3%
AGGREGATO, confermato). Domanda: quanto costerebbe abbassare
`InpMaxOpenRiskPct` da 3,25% a ≤2,50% per starci sotto? Analisi, non
esecuzione: **nessuna modifica applicata al forward**._

## 📊 Dati aggiornati (24 giorni, 01-26/08, non piu' i 15 di M2)

Rieseguito lo script di M2 (`sovrapposizione_sedie.py`) sulla finestra
piena disponibile oggi — campione piu' largo del referto originale (15→24
giorni), stesso metodo, stesse etichette:

- **Picco storico invariato**: 03/08, 9 posizioni/8 sedie = 5,85%/5,20%
- **Nuova distribuzione (24 gg)**: mediana 5 posizioni aperte (3,25%!),
  p95 7 pos (4,55%), p99 8,5 pos (5,55%)
- **Istogramma**: 1pos×3gg · 2×2 · 3×4 · 4×2 · 5×3 · 6×7 · 7×2 · 9×1

## 🎯 LA TABELLA CHE RISPONDE ALLA DOMANDA

| Cap C1 | Max posizioni permesse | Rischio al tetto | Giorni su 24 in cui la flotta avrebbe CHIESTO di sforare |
|---:|---:|---:|---:|
| **3,25%** (attuale, firmato) | 5 | 3,25% | **10/24 = 42%** |
| 3,00% (il tetto Fintokei) | 4 | 2,60% | **13/24 = 54%** |
| 2,75% | 4 | 2,60% | 13/24 = 54% |
| **2,50%** (proposta C-2) | 3 | 1,95% | **15/24 = 62%** |

## ⚖️ La lettura onesta

🔴 **Non e' un ritocco piccolo.** Il cap attuale (3,25%) gia' interviene
quasi un giorno su due (42%). Scendendo a 2,50% il Guardian dovrebbe
**bloccare nuovi ingressi o forzare chiusure quasi due giorni su tre
(62%)** — non solo nei picchi eccezionali (03/08), ma anche nei giorni
"normali" con 4-5 posizioni, che nell'istogramma sono la maggioranza
(9 giorni su 24 = 38% dei giorni ha proprio 4 o 5 posizioni: la fascia
che un cap a 2,50% comincia a tagliare).

🟡 **Cosa vuol dire "bloccare" in pratica**: dipende da come il Guardian
applica il cap C1 in `ABTG_Guardian.mq5` — se impedisce SOLO nuovi
ingressi (le posizioni gia' aperte restano) o se forza chiusure. Questo
referto non lo misura: e' scritto nel codice, va controllato prima di
decidere (`InpMaxOpenRiskPct` righe attorno alla 60).

🟢 **Un mitigante parziale gia' scritto nel referto M2, non ancora
applicato**: i **gemelli originale+OTT** (DAX Apertura EU + DAX Apertura
EU OTT, stesso segnale, stesso secondo) contano DUE posizioni per lo
STESSO evento. Sono presenti nei due giorni piu' affollati (03/08 e
04/08). **Portarne uno solo su una prop** (invece di entrambi) taglia 1
posizione proprio nei giorni di picco, senza toccare il resto della
flotta — un intervento chirurgico invece di un cap generale piu' stretto.
Non basta da solo a risolvere il 62% sopra, ma alleggerisce i giorni
peggiori a costo zero di opportunita' sulle altre famiglie.

## 🧾 In una riga

**Abbassare C1 a 2,50% tiene la flotta sotto il tetto Fintokei, ma al
prezzo di restrizioni quasi il doppio piu' frequenti di oggi (62% vs 42%
dei giorni) — non solo nei picchi rari, ma nell'operativita' ordinaria.**
Prima di decidere, vale la pena controllare (a) cosa fa ESATTAMENTE il
Guardian quando il cap morde (blocca o chiude?), (b) quanto aiuta da solo
il taglio dei gemelli originale+OTT su Fintokei specificamente.

_Nessuna modifica applicata. Script: `sovrapposizione_sedie.py
data/statements/trades_auto.csv --da 2026.08.01` (dati fino al 26/08).
Decide Claudio._
