# REFERTO — ROUND 3 (sonde di robustezza) — 08/08/2026, sera

_Primo dei cinque lavori arrivato. Criteri nei file prova, scritti prima._

## 1. EMA200 @SPXUSD H4 — griglia sul periodo della media (live = 200)

| periodo | IS | OOS | PF OOS | DD OOS | n OOS |
|---:|---:|---:|---:|---:|---:|
| 150 | +285,90 | +45,09 | 1,031 | 4,90% | 132 |
| 175 | +143,64 | +108,84 | 1,094 | 2,70% | 108 |
| **200 (live)** | +109,47 | **+567,07** | **1,595** | 2,22% | 111 |
| 225 | **−140,26** | **−127,56** | 0,889 | 3,85% | 94 |
| 250 | −290,03 | +36,62 | 1,037 | 3,37% | 103 |

- ✅ Sanità: la cella 200 riproduce la FASE 0 **al centesimo** (+567,07). Terza
  riproduzione esatta su tre round: il banco di prova è affidabile.
- ❌ **Criterio dichiarato NON passato**: serviva 175 E 225 positivi nelle due finestre;
  il 225 è rosso in entrambe. **Esce dai candidati prop.**
- 🔎 La sfumatura, da scrivere per onestà: il profilo non è il picco "a caso" del
  GoldenCross. Il lato corto (150–175) è verde, il buco sta solo sopra il 200, e l'OOS
  a 200 vale 5× i vicini. Il numero 200 **non è stato pescato da una griglia**: è
  l'identità dichiarata della strategia, ed è la media più guardata del pianeta — che
  "solo il 200 funzioni" è *coerente* con la premessa comportamentale (il mercato
  reagisce al livello che tutti guardano, non al 225 che non guarda nessuno).
  Ma coerente non vuol dire dimostrato: con l'IS sottile (20–37 trade/cella) questa
  resta un'ipotesi affascinante, non un candidato. **La decide il forward.**

→ In classifica scende fra i 🥈 con questa motivazione. In live non cambia niente.

## 2. SupRev_NAS_H1_Ott @NASUSD H1 — griglia sul moltiplicatore Supertrend (live = 3,0)

| StMult | IS | OOS | PF OOS | DD OOS | n OOS |
|---:|---:|---:|---:|---:|---:|
| 2,0 | −220,94 | +13,36 | 1,014 | 3,12% | 154 |
| 2,5 | −46,40 | −56,35 | 0,930 | 2,03% | 131 |
| **3,0 (live)** | +118,82 | **+300,61** | **1,688** | **0,86%** | 86 |
| **3,5** | +116,29 | **+203,66** | **1,475** | **0,75%** | 83 |
| 4,0 | −58,75 | −12,80 | 0,973 | 2,29% | 79 |

- ✅ Sanità: cella 3,0 riproduce la FASE 0 **al centesimo** (+300,61) — quarta su quattro.
- ❌ Criterio stretto NON passato: serviva 2,5 E 3,5 positivi; il 2,5 è rosso in entrambe.
- 🔎 **Ma il disegno va scritto**: una CRESTA di due celle (3,0–3,5) verdi nelle due
  finestre, PF 1,47–1,69, DD sotto l'1%, 83–86 trade OOS (sopra il minimo). Ed è la
  **stessa forma** che questo EA mostra sull'asse dei TF (isola H1+H2). Due assi
  indipendenti, due creste da due celle, e la config live (3,0 · H1) sta **dentro
  entrambe**. Non è l'altopiano largo che i criteri chiedono, ma non è nemmeno il picco
  solitario del GoldenCross: è un edge con margini stretti. Verdetto: resta 🥈, il
  forward (che già gira su questa config) è il giudice giusto. In live non si tocca niente.
