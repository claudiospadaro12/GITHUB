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

## 3. SuperWave_DOW_H1_Ott @U30USD H1 — griglia sul moltiplicatore (live = 2,5)

| StMult | IS | OOS | PF OOS | DD OOS | n OOS |
|---:|---:|---:|---:|---:|---:|
| 1,5 | +189,49 | **+746,21** | 1,606 | 3,28% | 165 |
| 2,0 | **−65,33** | +649,44 | 1,484 | 3,67% | 153 |
| **2,5 (live)** | +1022,29 | +463,44 | 1,328 | 3,91% | 143 |
| 3,0 | +711,71 | +144,32 | 1,096 | 5,11% | 143 |
| 3,5 | +674,88 | +282,25 | 1,187 | 5,02% | 134 |

- ✅ Sanità: cella 2,5 riproduce la FASE 0 **al centesimo** (+463,44) — quinta su cinque.
- ❌ Criterio stretto NON passato: il 2,0 è negativo in campione (−65,33 su 89 trade).
- 🔎 **Ma questa è la superficie più larga vista finora**: fuori campione TUTTE e cinque
  le celle sono verdi (da +144 a +746, PF 1,10–1,61) con 134–165 trade ciascuna — ben
  sopra il minimo. In campione 4 su 5. L'EA ha perso la promozione due volte "per un
  soffio": alla FASE 0 per l'H2 a −13,73, qui per un −65 su 89 trade, che è rumore.
  Nota di metodo: in OOS il moltiplicatore migliore è 1,5, in IS è 2,5 — nessun
  ribaltamento di segno, ma l'ennesima conferma che l'IS non ordina le celle.
  Verdetto: resta 🥈 **in cima** ai quasi; il forward su U30USD H1 è il giudice.
  In live non si tocca niente.

## 4. SupertrendReversal_Multi_Ott @XAUUSD H4 — griglia sul moltiplicatore (live = 2,5)

| StMult | IS | OOS | PF OOS | DD OOS | n OOS |
|---:|---:|---:|---:|---:|---:|
| 1,5 | −990,91 | +1664,42 | 1,714 | 5,79% | 105 |
| 2,0 | **−643,61** | +303,90 | 1,121 | 8,40% | 75 |
| **2,5 (live)** | +1098,26 | **+2108,11** | **2,907** | 4,50% | 49 |
| 3,0 | +54,40 | +724,92 | 2,985 | 3,57% | 27 |
| 3,5 | +160,68 | −576,93 | 0,319 | 6,18% | 19 |

- ✅ Sanità: cella 2,5 riproduce la FASE 0 **al centesimo** (+2108,11) — sesta su sei.
- ❌ Criterio NON passato: il 2,0 in campione fa −643,61.
- 🔎 Cresta di due (2,5–3,0) verde nelle due finestre, ma il 3,0 poggia su 11/27 trade —
  sotto il minimo. E il quadro d'insieme resta quello della FASE 0: sull'asse TF il suo
  H4 era un picco con l'H3 a −701. Un picco che su un secondo asse mostra una mezza
  cresta sottile non diventa un altopiano. **Resta su MT5**; l'OOS a PF 2,9 con 49 trade
  merita rispetto nel forward, non un conto che conta.

## 5. SupertrendReversal @XAUUSD H3 — griglia sul moltiplicatore (default 3,5)

| StMult | IS | OOS | PF OOS | n OOS |
|---:|---:|---:|---:|---:|
| 2,5 | −103,47 | −44,35 | 0,906 | 33 |
| **3,0** | +138,10 | **+580,09** | **4,419** | 35 |
| **3,5** | +7,90 | +284,74 | 2,530 | 21 |
| 4,0 | −19,02 | −58,23 | 0,466 | 15 |
| 4,5 | −40,24 | −111,33 | 0,125 | 15 |

- ✅ Sanità: cella 3,5 riproduce la FASE 0 **al centesimo** — settima su sette.
- ❌ Criterio non passato (il 4,0 è rosso in entrambe). Cresta di due (3,0–3,5) come nel
  resto della famiglia; campioni piccoli, come dichiarato in anticipo nel file prova.
  **Resta su MT5.**

---

# Chiusura del ROUND 3 — cosa hanno detto le cinque sonde

**Sette riproduzioni al centesimo su sette fra R2 e R3: il banco di prova è affidabile.**

Nessuna delle cinque sonde ha promosso: è il loro mestiere. Il quadro:

| EA | asse sondato | esito |
|---|---|---|
| EMA200 @SPXUSD | periodo EMA | ❌ 225 rosso — ma il "200" ha una storia comportamentale: giudica il forward |
| SupRev_NAS_H1 | StMult | ❌ cresta di due su DUE assi, live dentro entrambe |
| SuperWave_DOW_H1 | StMult | ❌ per −65 su 89 trade in IS — **OOS verde 5/5**, il più vicino alla promozione |
| Multi_Ott @XAUUSD | StMult | ❌ resta MT5 |
| STREV @XAUUSD H3 | StMult | ❌ resta MT5 |

**La famiglia Supertrend ha una firma ricorrente: creste di due celle, mai altopiani.**
L'edge c'è ma coi margini stretti — il tipo di edge che il forward conferma o consuma,
non quello che si porta in prop sulla fiducia. L'unico promosso resta il MaxMinNotte
(altopiano vero su 4 celle), col suo asterisco sul campione.
