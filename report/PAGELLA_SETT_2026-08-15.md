# 📊 PAGELLA SETTIMANALE 10-15/08 — letta col fantasma tolto

_PDF ricevuto il 15/08 alle 13:26, dopo la correzione del branch. Copertura
statement **2026.03.30 → 2026.08.14**: l'avviso "lo statement arriva solo al
2026/07/24" è **sparito** e la sezione "Andamento dei trade" è piena._

---

## 0. ✅ La correzione ha funzionato

| | pagella delle 09:00 | pagella delle 13:26 |
|---|---|---|
| copertura statement | fino al **24/07** | **fino al 14/08** |
| 1. Andamento dei trade | *"Nessuno statement con trade nel periodo"* | **28 trade** |
| avviso in cima | presente | **sparito** |

Causa e rimedio: `report_scheduler/trigger_weekly.ps1` lanciava il workflow con
`$ref = "claude/creating-agents-SgGpD"` (branch fermo al 31/07). Ora `lavoro`.

---

## 1. 🎯 La pagella isola il fantasma DA SOLA — e non lo sapeva

Le due righe peggiori della tabella "Per strategia / EA" sono:

```
DAX Apertura EU BUY     1/2    -85,43
DAX Apertura EU SELL    1/2    -97,21
```

**Tutti e quattro quei trade sono del PC fantasma. Tutti e quattro.** Nessun
trade del VPS finisce in quelle due righe:

| commento | 12/08 | 14/08 | 10/08 | 13/08 | chi |
|---|---:|---:|---:|---:|---|
| `DAX Apertura EU BUY` | +19,17 | −104,60 | | | **PC** |
| `DAX Apertura EU SELL` | | | −101,83 | +4,62 | **PC** |

Il VPS, sullo stesso EA, scrive commenti **diversi** — `DAX Apertura EU OTT
BUY` (+15,80) e `DAX Apertura EU RETEST BUY` (+3,90), righe **positive**. È
esattamente la firma trovata il 14/08: due rami di codice diversi, due
macchine diverse, lo stesso magic.

**Somma delle due righe fantasma: −182,64.** Coincide al centesimo col calcolo
fatto dal censimento degli ordini, per una via completamente indipendente.

## 2. Il numero, prima e dopo

| | trade | netto | win rate | **PF** | aspettativa |
|---|---:|---:|---:|---:|---:|
| **come dice la pagella** | 28 | **−150,80** | 54% | **0,66** | −5,39 |
| **depurato dal PC** | 24 | **+31,84** | 54% | **1,13** | **+1,33** |
| _(i 4 del PC da soli)_ | 4 | −182,64 | 50% | **0,12** | −45,66 |

> **Il profit factor passa da 0,66 a 1,13.** La pagella descrive un sistema
> perdente; la flotta vera, quella sul VPS, è leggermente positiva.

**I 4 trade del fantasma hanno PF 0,12**: per ogni euro guadagnato ne
perdevano otto. Configurazione mai validata, rischio 2% invece di 0,65%.

### ⚠️ Ma il win rate NON migliora depurando: resta 54%

E questo è il punto da non perdere. **Il fantasma non gonfiava il win rate,
gonfiava la DIMENSIONE delle perdite.** Il problema aperto da R47 — **54% in
forward contro il 73-81% del tester** — **resta intero**, e non era colpa sua.

## 3. 🚨 Il limite di questa pagella: manca il 100k

La pagella copre **solo il conto piccolo (50503392)**. Il conto che conta per
la prop, il **100k (50504263), chiude la settimana a −826,86** — e lì i trade
del PC sono **ZERO**, quindi non c'è niente da depurare.

> **I due conti insieme, già depurati: −795,02.**
> Citare il +31,84 senza questo accanto è fuorviante.

## 4. Le voci, in chiaro (conto piccolo)

**Sopra**: NIGHTLY L +57,71 (1/1) · STREV DOW H1 L 2/3 +40,94 · EMA200 DOW L2
+30,43 · PTE GBPUSD S +22,16 · DAX OTT BUY +15,80 · **Dow Apertura RETEST +14,55
(2/2)** · **Nasdaq Apertura SELL +11,69 (2/2)** · EMA200 DOW L1 +9,81 · DAX
RETEST +3,90.

**Sotto**: le due righe fantasma (−182,64) · **ORB OTT BUY −69,77 (0/2)** ·
COST EURJPY L −51,02 · **ORB BUY −42,91 (0/1)** · Nasdaq OTT BUY −10,00 ·
MAXMIN ORO −2,60.

### 🆕 Sul conto piccolo girano DUE ORB, non uno

| commento | magic | trade | netto |
|---|---|---:|---:|
| `ORB BUY` | **770601** — l'ORB **del corso** | 1 (1,20 lotti) | −42,91 |
| `ORB OTT BUY` | **770611** — il nostro laboratorio | 2 | −69,77 |
| | | **3** | **−112,68**, **0 vinti su 3** |

R15 dice esplicitamente _"magic DIVERSO dal corso (770601)"_: sono due EA
distinti che operano sullo stesso setup. **Da verificare se il 770601 è
dichiarato in `FLOTTA_ATTIVA.md`** — se non lo è, è un'altra riga non censita
sul conto vivo.

## 5. Cosa NON si decide da qui

- **L'ORB resta**, per i criteri congelati in `report/ORB_100K_CRITERI.md`: la
  regola è 15 trade per famiglia, siamo a 2 segnali, e nessuna soglia di
  rischio è vicina. Tre trade a zero vinti **non spostano niente**, e il
  criterio lo diceva prima di vederli.
- **Nessun parametro si tocca da una pagella.**
