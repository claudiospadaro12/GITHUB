# 🔎 REFERTO M2 — LA SOVRAPPOSIZIONE REALE DELLE SEDIE, MISURATA (18/08/2026)

**La domanda (riga C1 del PIANO_PROP)**: quante sedie sono aperte NELLO
STESSO momento, e quanto rischio aperto fa la somma, giorno per giorno?
Il timore aritmetico era: 8 sedie × 0,65% = 5,2% > muro giornaliero 5%.

**La risposta, misurata**: 🔴 **NON e' un timore teorico: e' SUCCESSO.**
Il 03/08 alle 08:15 server c'erano **9 posizioni di 8 sedie diverse aperte
insieme** = **5,85% per-posizione / 5,20% per-sedia** a taglia 0,65%.
Esattamente lo scenario "8 × 0,65" del piano, fotografato nel forward vero.

> **La riga che conta**: il rischio aperto simultaneo reale arriva a
> **5,85%** (p99 giornaliero **5,67%**) sulla flotta di agosto → il cap C1
> sensato e' **3,25% (5 SL vivi da 0,65%)**, con pausa nuovi ingressi B1 a
> 4,0% come seconda rete. Perche' proprio 3,25: vedi §5.

---

## 1. Metodo (congelato PRIMA dei numeri)

Criteri in `backtest_pipeline/prove/M2_SOVRAPPOSIZIONE_CRITERI.md`
(commit `0233835`, precedente a ogni numero). Script:
`backtest_pipeline/sovrapposizione_sedie.py` (sweep-line sugli eventi di
apertura/chiusura, sola lettura). In sintesi:

- **Dati**: `data/statements/trades_auto.csv` (forward conto piccolo,
  export con `open_time` E `close_time` per posizione) — l'unico dataset di
  casa con gli orari di apertura. `magic 0` = manuale, **escluso** (661
  posizioni, quasi tutte marzo-luglio).
- **Rischio aperto in t** = unita' aperte × **0,65%** (taglia prop, A1), in
  due letture: **per-POSIZIONE** (primaria, = "somma degli SL vivi" con SL
  pieno) e **per-SEDIA** (una sedia = un rischio). Il numero vero sta fra
  le due: le etichette `1/3`-`2/3` degli STREV dicono che alcune posizioni
  sono tranche parziali (la per-posizione le conta piene → sovrastima).
- **Limite dichiarato**: il CSV non registra parziali/BE/trailing → il
  rischio e' quello all'ingresso tenuto vivo = **limite superiore**. Per
  dimensionare un cap e' il verso giusto dell'errore.
- Metrica giornaliera = massimo intra-day; percentili sui giorni con
  almeno una posizione EA aperta.
- ⚠️ 2 righe a durata nulla (open==close) scartate e dichiarate: con la
  definizione `open <= t < close` non sono mai aperte. (Trovate perche' una
  delle due — un residuo `NQ_v21` di maggio — restava "aperta per sempre"
  nella prima passata dello sweep e falsava tutto il periodo lungo: bug
  trovato, corretto e documentato nello script PRIMA del referto.)

## 2. 📅 AGOSTO (01-17/08, la flotta attuale) — il campione che conta

**90 posizioni EA, 28 sedie, 15 giorni con posizioni aperte.** Le posizioni
aperte a fine luglio e ancora vive in agosto CONTANO (5 swing STREV portate
dentro dal 29-31/07: e' proprio li' che stava il rischio nascosto).

| metrica | per-POSIZIONE | per-SEDIA |
|---|---:|---:|
| **max storico** (03/08 08:15:34) | **9 pos = 5,85%** | **8 sedie = 5,20%** |
| p50 del massimo giornaliero | 2,60% | 1,95% |
| p95 | 4,94% | 4,29% |
| p99 | 5,67% | 5,02% |
| giornate > 4% | 2 su 15 | 1 su 15 |
| **giornate > 5%** | **1 su 15** | **1 su 15** |

**L'anatomia del giorno oltre il muro (03/08)**: 5 posizioni swing STREV
tenute da fine luglio (CAC H4 aperta il 29/07 e chiusa il 06/08 = 8 giorni;
piu' MULTI S, STREV S oro, NAS H1, STREV L) **piu'** il terzetto
dell'apertura DAX che spara nello stesso secondo (08:15:29-34: `770101` DAX
Apertura EU + `770111` OTT + `770311` Apertura Marco). Il pile-up e':
**gli swing si accumulano per giorni, le aperture ci si sommano sopra in
un secondo.**

## 3. 🧲 Le combinazioni ricorrenti (chi si sovrappone con chi)

1. **Il cluster swing STREV domina i minuti**: le coppie fra `770901` /
   `771001` / `770925` / `970913` / `970915` (oro, Nasdaq, CAC) stanno
   insieme aperte per **migliaia di minuti** (3.751-5.976 min in 17
   giorni). Posizioni multi-day = sovrapposizione strutturale, non
   coincidenza.
2. **I gemelli originale+Ottimizzato raddoppiano lo stesso segnale**
   (girano in parallelo per regola di casa, magic diversi): DAX Apertura
   EU + OTT nello stesso secondo ogni mattina; DAX Live 5m + v2 idem;
   EMA200 S1 + OTT S1 (180 min insieme). Sul conto di sviluppo e' voluto —
   **su una prop sarebbe una posizione doppia**, lo stesso difetto gia'
   scritto in PIANO_PROP §4 per le due posizioni oro del 03/08.
3. **Le aperture indici si sommano nello stesso minuto** (08:00-08:16
   server: DAX Apertura, OTT, Marco, Live5m×2, e la notturna NIGHTLY
   ancora aperta): burst brevi (minuti) ma ripetuti ogni mattina — 03, 04,
   06, 07/08 tutti col picco del giorno fra le 08:00 e le 08:16.
4. **Notturne**: MAXMIN ORO + STREV DOW H1 215 min; EMA200 DOW + LARRY
   EURAUD 225 min a cavallo della notte. Presenti ma secondarie.

## 4. 🧾 Le altre finestre (contesto)

- **Periodo intero EA (31/03-17/08, 516 posizioni, 40 magic, 85 giorni)**:
  max **12 posizioni / 10 sedie** insieme (30/07 08:21 = 7,80% / 6,50%);
  **11 giorni su 85 sopra il 5%** per-posizione. Dentro pero' c'e' la
  flotta VECCHIA (ripulita il 10/08): la griglia esterna
  `BULGE_MULTI_SIGNAL` da sola arrivava a **10 posizioni aperte di una
  sedia sola** (6,50% per-posizione, 0,65% per-sedia) — il caso che
  spacca in due le letture, e il motivo per cui il cap C1 va messo sulla
  SOMMA degli SL, non sul numero di sedie.
- **Dry-run 100k (6 posizioni dal 10/08)**: max 2 posizioni / 2 sedie =
  1,30%. La squadra da 5 col Guardian non si e' mai avvicinata a niente.
  Campione minuscolo, dichiarato.
- **Forward "pulito" (dal 15/08)**: 3 giorni, max 3 posizioni / 2 sedie =
  1,95% / 1,30%. Troppo corto per pesare, dichiarato.

## 5. ➡️ La proposta per C1 (decisione di Claudio, come da regola)

**`InpMaxOpenRiskPct` = 3,25% = 5 SL vivi da 0,65%.** Il ragionamento,
tutto su numeri di questo referto:

- **Contro il muro giornaliero 5%**: con 5 SL vivi il caso peggiore
  simultaneo e' −3,25%; sommato a una perdita gia' realizzata in giornata
  di ~1,3% (2 stop pieni) resta sotto la chiusura d'emergenza B1 a 4,9%.
  Con 8-9 SL vivi (il 03/08 reale) il caso peggiore da solo SFONDA il muro:
  nessun guardiano puo' piu' salvarla, puo' solo certificare la bocciatura.
- **Contro il comportamento reale**: in agosto il cap a 3,25% avrebbe
  morso 5 giorni su 15 — e sono ESATTAMENTE i giorni dell'accumulo swing
  (01-05/08). p50 = 2,60%: la meta' tranquilla dei giorni non lo
  sentirebbe mai.
- **Contro le fonti esterne di C1** (1% / 1,5% / 3% divergenti): la nostra
  misura sta col ramo alto — 3,25% e' il Bneu 3% arrotondato alla nostra
  unita' da 0,65.
- Le due code da chiudere INSIEME al cap, perche' il cap da solo non le
  vede: **(a)** i gemelli originale+OTT contano DUE unita' sullo stesso
  segnale (su una prop se ne porta UNO — gia' cosi' nel dry-run 100k);
  **(b)** una griglia tipo BULGE consuma tutto il budget da sola (il cap
  per fortuna la ferma comunque, perche' conta posizioni, non sedie).

Ricadute sulle righe aperte del piano: **C2** (max sedie accese) — il
numero misurato dice che il vincolo giusto non e' quante sedie sono
ACCESE ma quanti SL sono VIVI: con cap a 5 unita', 8+ sedie accese
convivono se operano in orari diversi (le correlazioni ~zero di R16
restano il motivo per tenerle); **C4** (budget diviso) — la strada
"rischio ÷ n. sedie" e' un'alternativa piu' rigida al cap: la misura dice
che il problema e' il PICCO simultaneo, non la somma astratta, quindi il
cap sul rischio aperto e' lo strumento piu' mirato.

## 6. 🕳️ Cosa questo referto NON misura (dichiarato)

1. **Le 27 serie del portafoglio backtest NON hanno `open_time`**
   (formato `ExportTrades()`: solo `close_time`) → la sovrapposizione
   intra-day dai backtest **non e' misurabile**, come previsto dai criteri.
   L'unico contorno lecito (co-attivita' per giorno di CHIUSURA, che NON
   e' rischio simultaneo): sulle 6 serie R16, in 249 giorni, 2+ sedie
   hanno chiuso lo stesso giorno 169 volte, massimo 6 su 6 una volta —
   dice solo che le sedie lavorano davvero negli stessi giorni, non
   quanto rischio era aperto insieme. Se un giorno serve la misura vera
   sui backtest, va aggiunto `open_time` a `ExportTrades()` e rifatto il
   giro (nota per il prossimo round, zero urgenza).
2. **Il rischio post-parziale/BE**: i numeri sono il tetto (SL pieni
   vivi). Il 03/08 le 5 swing erano tranche `1/3`-`2/3`: il valore vero di
   quel giorno sta fra 5,20 e ~3-4%. Il tetto e' comunque la grandezza
   giusta per dimensionare un cap.
3. **15 giorni sono 15 giorni**: p95/p99 di agosto si dichiarano per
   quello che sono. Ma il massimo storico (5,85%) e' un fatto, non una
   stima — e per la regola di casa (Emendamento B) il RISCHIO si giudica
   sui fatti accaduti.

---

*Dati: `data/statements/trades_auto.csv` (90 pos. EA con intervallo in
agosto, riconciliate al pezzo con le "90 operazioni, 28 magic" di
`DOVE_SIAMO_17-08.md`) · `trades_100k.csv` · serie R16 in
`risultati_prove/trades_portafoglio/`. Riproducibilita':
`python3 backtest_pipeline/sovrapposizione_sedie.py
data/statements/trades_auto.csv --da 2026.08.01` (e senza `--da` per il
periodo intero). Criteri congelati: commit `0233835`. NON tocca il
forward; PIANO_PROP.md lo aggiorna l'architetto al prossimo giro.*
