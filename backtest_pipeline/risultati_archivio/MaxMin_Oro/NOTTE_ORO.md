# La notte dell'oro — studio + MaxMinNotte fase 1 (05/08)

## Parte 1 — lo studio (371 notti, 28/02/2025 → 04/08/2026)

**A che ora si muove.** Le **02:00 server (= 3:00 italiane)** sono l'ora più mossa della notte:

| ora server | notti | quota mediana sull'ampiezza della notte |
|---|---:|---:|
| 22:00 | 72 | 22,0% |
| 23:00 | 270 | 25,8% |
| 00:00 | 369 | 26,9% |
| 01:00 | 369 | 35,7% |
| **02:00** | **369** | **47,9%** |
| 03:00 | 369 | 34,9% |
| 04:00 | 369 | 28,0% |
| 05:00 | 369 | 22,5% |
| 06:00 | 370 | 34,6% |

+34% sulla seconda classificata, più del doppio della peggiore. Sull'istogramma degli
estremi le 02:00 fanno 15,6% contro 9-11% delle ore vicine: **una gobba in mezzo alla
valle**. Le 06:00 (23,9% degli estremi) non contano: sono l'ultima ora della finestra e
gli estremi di un percorso casuale si addensano ai bordi (legge dell'arcoseno).

**Quanto vale.** Ampiezza mediana della notte **41,6 $** (q25 26,1 · q75 60,9).
Ma la volatilità è raddoppiata: 2025-H1 29,8 $ · 2025-H2 26,4 $ · **2026-H1 59,5 $**.
Qualunque parametro in punti fissi tarato sul 2025 oggi è fuori scala.

**Cosa fa la sessione dopo.** Rompe il massimo 49,9% · rompe il minimo 41,2% ·
**resta dentro solo 8,9%**. Il fade ("entro sul minimo, chiudo sul massimo") è escluso.
Direzione imprevedibile (51,5% / 48,5%): serve l'OCO, non una previsione.
Escursione mediana oltre il livello rotto: **23,3 $** (la media 33,25 $ è gonfiata dalle
code, c'è un +308 $).

## Parte 2 — MaxMinNotte, fase 1 OHLC (48 pass, 2024.01 → 2026.06)

⚠️ **OHLC M1 = ottimista** su un sistema di rottura. Si legge in *relativo*.

**36 pass su 48 in utile.**

### I migliori

| TF gest. | buffer | stop | profit | PF | DD% | trade* |
|---|---:|---|---:|---:|---:|---:|
| H1 | 800 | ATR 1,5× | 1.692,93 | **1,742** | 3,95 | 107 |
| **H1** | **200** | **box opposto** | **3.142,67** | **1,600** | **3,69** | **353** |
| H1 | 800 | box opposto | 547,12 | 1,577 | 4,69 | 88 |
| H1 | 200 | fisso 3000 | 2.641,08 | 1,521 | 5,45 | 372 |
| M30 | 200 | box opposto | 2.460,59 | 1,515 | 5,71 | 393 |
| M30 | 200 | ATR 1,5× | 4.450,18 | 1,350 | 11,65 | 383 |

### I due gradienti — ed è qui la scoperta

| buffer | PF mediano | in utile |
|---|---:|---|
| 200 | **1,388** | 11/12 |
| 800 | 1,320 | 12/12 |
| 1400 | 1,131 | 9/12 |
| 2000 | 0,977 | 4/12 |

| TF gestione | PF mediano | in utile |
|---|---:|---|
| M5 | 1,121 | 8/12 |
| M15 | 1,147 | 8/12 |
| M30 | 1,175 | 9/12 |
| H1 | **1,327** | 11/12 |

**Entrambi monotòni, entrambi con il massimo sul BORDO della griglia.** Non è rumore
(il rumore non ordina quattro valori in fila), ma vuol dire che **l'ottimo sta fuori**:
la griglia era messa male. Da qui la fase 2: buffer **50/150/250/350** (sotto i 200) e
TF **M30/H1/H4** (sopra).

### Lo stop: pareggio, e una mia previsione sbagliata

| stop | PF mediano | DD mediano | in utile |
|---|---:|---:|---|
| box opposto | 1,231 | 4,06% | 12/16 |
| ATR 1,5× | 1,156 | 7,09% | 11/16 |
| fisso 3000 | 1,255 | 3,87% | 13/16 |

Avevo previsto che `SLMode=0` (stop all'estremo opposto del box) sarebbe stato bocciato,
perché lo studio dava un'escursione mediana di 23,3 $ contro un box da 41,6 $ → 0,56 R.
**Previsione sbagliata**: il box opposto dà il PF più alto a buffer 200 e il DD più basso
in assoluto. Il ragionamento non reggeva perché l'EA non punta a un solo target: chiude
50% a 1R, 50% a 2,5R, ha il target EMA200 e il trailing ATR. Il "0,56 R" non descrive
l'esito.

Per la fase 2 si fissa **SLMode = 0**: miglior PF a buffer 200, DD più basso, e non ha
parametri da tarare (l'ATR ne ha uno, il fisso pure).

## ⚠️ Due riserve, prima di entusiasmarsi

1. **Il numero di "trade" è gonfiato.** `InpTP1Pct=50` + `InpTP2Pct=50` + residuo = fino a
   **3 chiusure per posizione**, e MT5 le conta tutte. I "393 trade" sono forse 130-180
   posizioni vere. Il campione va giudicato su quelle.
2. **Lo storico potrebbe non coprire il periodo richiesto.** Lo studio ha trovato dati M5
   sull'oro solo dal **28/02/2025**, ma il backtest chiedeva dal 2024.01.01. Se anche l'M1
   parte nel 2025, il test copre ~16 mesi e non 30 — e quei 16 mesi sono proprio quelli in
   cui l'oro è raddoppiato di volatilità. **Da verificare** prima di dare peso ai numeri.

## Prossimo passo

`maxmin_oro.ps1 -Fase 2 -SLMode 0` → 12 pass a **tick reali**, buffer 50/150/250/350 ×
TF M30/H1/H4.
