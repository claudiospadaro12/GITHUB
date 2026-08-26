# 🎛️ ANALISI DIAL TAGLIE — "quanto si può alzare la manopola?" (26/08/2026)

_Richiesta di Claudio del 26/08: "vorrei aumentare i lotti confidando nel
Guardian per non superare il 5% giornaliero". La casa risponde MISURANDO il
tradeoff sui dati agli atti, invece di indovinare. SOLO ANALISI: nessuna riga,
nessun criterio, nessun EA toccato. Ogni cambio taglia in campo resta una
FIRMA sui contratti, non un'ottimizzazione._

**Base dati**: `R105_dataset_giornaliero.csv` (481 giorni × 40 sedie,
chiusure giornaliere nette, taglie R103-bench), finestra 2024.09.26 →
2026.06.30. Flotta POST-REVISIONE "A+b" del 24/08 applicata qui come in
R105: **35 sedie vive** (spente F06 CostToCost XAGUSD, F09 EasyTrend AUDJPY,
F15 PTE USDJPY, F21 SuperWave GBPUSD; escluso il fantasma F25 Ichimoku) e
**5 ridotte** (F04 ×0,65 · F05 ×0,25 · F07 ×0,30 · F08 ×0,50 · F16 ×0,50).
Il dial `d` scala linearmente TUTTA la flotta post-revisione. Base conti: 100k.

---

## ⚠️ AVVERTENZE MISURATE — da leggere PRIMA dei numeri

- **(a) Lo scaling lineare è un'APPROSSIMAZIONE OTTIMISTA.** Lezione R109,
  misurata ieri: il lotto sbatte su `SYMBOL_VOLUME_MAX` (=100 sul Dow) e sui
  pavimenti di volume, e lo **slippage cresce con la taglia** (21,5 punti
  misurati su uno stop Nasdaq, perdita quasi doppia del previsto). Moltiplicare
  per `d` i P&L storici ignora tutto questo: **i numeri a dial alto sono
  MIGLIORI del vero**, e lo sono sempre di più man mano che `d` sale.
- **(b) Chiusure giornaliere = LIMITE INFERIORE del rischio.** L'equity
  FLOTTANTE intraday — quella che le prop guardano davvero — è invisibile a
  questo dataset. Ogni "worst day" e ogni conteggio di violazioni qui sotto
  può solo peggiorare nel mondo reale, mai migliorare (onestà centrale di R106).
- **(c) Il Guardian NON è modellato — e non è gratis.** La simulazione corre
  i giorni storici così come sono chiusi. Il Guardian vero che scatta (pausa
  4,0 / emergenza 4,9) **trasforma drawdown temporanei in perdite chiuse**:
  a dial alti il sistema reale sarebbe un sistema DIVERSO da quello misurato
  qui — giornate che nel dataset recuperano nel pomeriggio verrebbero chiuse
  in perdita al mattino. "Alzare confidando nel Guardian" cambia la macchina,
  non solo la scala. Nessun numero di questa pagina include quell'effetto.

---

## ✅ CONTROLLO POSITIVO — la base è riconciliata con gli atti

Prima di produrre numeri nuovi, ho riprodotto i numeri noti con le stesse
convenzioni. **Tutto torna al centesimo**:

| numero agli atti | riprodotto | verdetto |
|---|---|---|
| R105: flotta 35 → **+274.745 €** | +274.745 € | ✅ |
| R105: DD **6,37%** | 6,37% | ✅ |
| R105: peggior giorno **−4,74% (25/05/26)** | −4.737 € = −4,74%, 25/05/26 | ✅ |
| R106 A (target +10%): **99,2% / 97,5%** (21m / verifica 7m), mediana **16 gg** | 99,2% (477/481) / 97,5% (159/163), mediana 16 | ✅ |
| R106 B ×0,74: **98,3% / 95,1%**, mediana **22 gg** | 98,3% (473/481) / 95,1% (155/163), mediana 22 | ✅ |
| R106: worst day B **−3,5 k€** | −3.505 € | ✅ |
| R106: violazioni muri **ZERO** in A e B, non-passate tutte TRONCATE | 0 daily, 0 total; 4 e 8 troncate | ✅ |

📌 **Dichiarazione di convenzione**: R106 agli atti usa target **+10%**;
la richiesta di oggi chiede la challenge a target **+8%**. Le colonne di
controllo qui sopra sono a +10% (per riconciliare); la simulazione nuova
sotto è a **+8%** come richiesto, con la colonna +10% accanto per il ponte.
Muri identici a R106: giornaliero −5%, totale −10%, statici su base 100k
(trailing FTMO NON modellato).

---

## 📊 TABELLA 1 — I giorni neri per dial (chiusure giornaliere = LIMITE INFERIORE)

Il peggior giorno è SEMPRE il 25/05/26 (lunedì dei gap, cluster GapFill —
strutturale per R105-D3: nessuna esclusione di sedia lo toglie). Il secondo
è sempre il 19/02/25.

| dial `d` | peggior giorno | 2° peggiore | gg oltre −3,5% | oltre −4,0% | oltre −5,0% |
|---:|---:|---:|---:|---:|---:|
| 0,50 | −2,37% | −1,95% | 0 | 0 | 0 |
| 0,65 | −3,08% | −2,53% | 0 | 0 | 0 |
| 0,74 | −3,51% | −2,88% | 1 | 0 | 0 |
| 0,85 | −4,03% | −3,31% | 1 | 1 | 0 |
| **1,00 (firmata)** | **−4,74%** | **−3,89%** | **2** | **1** | **0** |
| 1,15 | −5,45% | −4,48% | 6 | 3 | **1** |
| 1,30 | −6,16% | −5,06% | 7 | 6 | **2** |
| 1,50 | −7,11% | −5,84% | 11 | 7 | **5** |

👉 **Il punto di rottura è misurabile: a `d` = 1,055 il peggior giorno CHIUSO
tocca esattamente il −5%.** Sopra quel dial il muro giornaliero è bucato da
un giorno REALMENTE ACCADUTO — su chiusure, cioè nel caso più gentile
possibile. E già a d=1,00 il 25/05/26 passa a 263 € dal muro (il "filo di
rasoio travestito da margine" di R106).

## 🏁 TABELLA 2 — Challenge rolling (481 partenze, target +8%, muri −5% g / −10% tot)

| dial `d` | pass % | mediana gg | bruciate dal muro GIORNALIERO | muro totale | troncate |
|---:|---:|---:|---:|---:|---:|
| 0,50 | 97,3% | 26 | 0 | 0 | 13 |
| 0,65 | 98,5% | 20 | 0 | 0 | 7 |
| 0,74 | 99,0% | 17 | 0 | 0 | 5 |
| 0,85 | 99,2% | 15 | 0 | 0 | 4 |
| **1,00 (firmata)** | **99,6%** | **12** | **0** | **0** | **2** |
| 1,15 | 96,7% | 11 | **15** | 0 | 1 |
| 1,30 | 96,7% | 9 | **15** | 0 | 1 |
| 1,50 | 89,2% | 8 | **51** | 0 | 1 |

⚡ **La lettura che conta: il pass rate NON sale col dial — fa il PICCO a
1,00 e poi CROLLA.** Sopra 1,055 il 25/05/26 (e poi altri giorni) diventa
un muro giornaliero sfondato: a d=1,15 brucia 15 partenze, a d=1,50 ne
brucia 51. Alzare la taglia oltre la firma attuale NON compra probabilità
di passare: la vende, in cambio di 1-4 giorni di viaggio in meno.

## 💰 TABELLA 3 — Il guadagno atteso per dial

| dial `d` | profitto mediano per challenge passata | profitto/mese flotta (21 mesi) |
|---:|---:|---:|
| 0,50 | 8.458 € | +6.542 € |
| 0,65 | 8.615 € | +8.504 € |
| 0,74 | 8.604 € | +9.681 € |
| 0,85 | 8.728 € | +11.121 € |
| **1,00 (firmata)** | **8.900 €** | **+13.083 €** |
| 1,15 | 8.928 € | +15.046 € |
| 1,30 | 9.229 € | +17.008 € |
| 1,50 | 9.323 € | +19.625 € |

Nota onesta: il "profitto mediano per challenge passata" è quasi piatto
(~8,5-9,3 k€) perché la corsa si ferma al target: il dial alto arriva prima,
non più in alto. Il profitto/mese invece scala linearmente PER COSTRUZIONE
(è la stessa serie moltiplicata) — vale l'avvertenza (a): a dial alto quel
numero è il tetto ottimista, non la stima.

## 🎯 TABELLA 4 — IL TRADEOFF (la tabella della decisione)

"Capello dal muro" = distanza del peggior giorno CHIUSO dal −5% (in punti
percentuali; negativo = muro già bucato). Pass % a target +8%; tra parentesi
il ponte a +10% (convenzione R106).

| dial `d` | worst day | pass % (+8%) | mediana gg | capello dal muro |
|---:|---:|---:|---:|---:|
| 0,50 | −2,37% | 97,3% (95,0%) | 26 | 2,63 pt |
| 0,65 | −3,08% | 98,5% (97,7%) | 20 | 1,92 pt |
| 0,74 | −3,51% | 99,0% (98,3%) | 17 | 1,49 pt |
| 0,85 | −4,03% | 99,2% (98,8%) | 15 | 0,97 pt |
| **➡️ 1,00 (RIGA FIRMATA ATTUALE)** | **−4,74%** | **99,6% (99,2%)** | **12** | **0,26 pt (263 €)** |
| 1,15 | −5,45% | 96,7% (96,3%) | 11 | **−0,45 pt (BUCATO)** |
| 1,30 | −6,16% | 96,7% (95,6%) | 9 | **−1,16 pt (BUCATO)** |
| 1,50 | −7,11% | 89,2% (86,9%) | 8 | **−2,11 pt (BUCATO)** |

---

## 🧭 RACCOMANDAZIONE (onesta, coi numeri sotto)

1. **Sopra la taglia firmata NON c'è spazio: c'è un dirupo a d≈1,05.**
   Già alla firma attuale (d=1,00) il peggior giorno passa a 263 € dal muro
   — SU CHIUSURE, il limite inferiore. A d=1,055 lo tocca; a d=1,15 lo
   sfonda e il pass rate SCENDE (99,6→96,7%). L'idea "alzo i lotti, tanto
   c'è il Guardian" non regge alla misura: il Guardian non evita il giorno
   nero, lo CHIUDE (avvertenza c) — e sopra 1,05 il giorno nero storico
   sfonda il muro da solo, Guardian o no. Il guadagno comprato (12→11 giorni
   di mediana a d=1,15) è spiccioli contro il rischio venduto.
2. **Se si vuole toccare la manopola, la direzione con senso è tenerla DOVE
   STA (challenge alla firma attuale) o SOTTO (0,74) per margine vero.**
   La 0,74 resta la raccomandazione R106 per la challenge: −3,5% di worst
   day = 1,49 pt di capello anche contro i picchi intraday invisibili,
   pagando ~5 giorni di viaggio. La d=1,00 è il massimo difendibile, col
   filo di rasoio dichiarato. Tutto ciò che sta sopra è, ai dati di casa,
   un peggioramento su ENTRAMBI i fronti che contano per una prop
   (probabilità di passare E distanza dal muro).
3. **Nessun cambio è operativo da questa pagina.** Questo è un round che
   INFORMA (come R105): ogni spostamento del dial in campo è una **FIRMA di
   Claudio sui contratti** (CONTRATTI_SEDIE, taglie riga per riga), con le
   avvertenze (a)(b)(c) lette ad alta voce — in particolare che a dial alto
   il sistema reale (lotti cappati, slippage, Guardian-as-stop) è DIVERSO
   e PEGGIORE di quello simulato qui.

_Riproducibilità: script della simulazione riscrivibile in minuti dal
dataset agli atti (filtro finestra, revisione A+b come sopra, scala lineare,
rolling challenge R106). Controllo positivo integrale in testa a questa
pagina: nessun numero pubblicato su base non riconciliata._
