# 📐 R105 — IL ROUND DI PORTAFOGLIO (criteri ✅ FIRMATI)

**FIRMATO da Claudio il 25/08/2026, in chat: "FIRMO TUTTE E TRE"** (F1+F2+F3, senza modifiche).

_Richiesto da Claudio il 25/08 ("INTANTO PREPARAMI R105 PORTAFOGLIO").
È il round della domanda vera: **"quali EA insieme mi fanno salire i
conti?"** — e della priorità di rischio dichiarata fin da R100: il DD
COMBINATO della flotta._

## 0. La natura del round: ZERO ORE DI TESTER
R105 non lancia backtest: analizza i per-trade GIÀ misurati da R103
(tick di lavoro: il dataset giornaliero per sedia, ora agli atti in
`R105_dataset_giornaliero.csv` — 481 giorni × 40 sedie, chiusure
realizzate). Gira dalla mia parte, riproducibile, in minuti.
Limiti ereditati e dichiarati: OHLC (DD = limite inferiore), un solo
regime (21 mesi), somma di conti indipendenti [APPROSSIMATO], riscalature
lineari [convenzione CONTRATTI_SEDIE].

## 1. Perimetro
**Le 35 sedie VIVE post-revisione "A+b"**, alle **taglie NUOVE** (le 5
ridotte riscalate; le 4 spente e il fantasma Ichimoku ESCLUSI).
Finestra: i 21 mesi comuni (2024.09.26 → 2026.06.30).

## 2. ANTEPRIMA già misurata (25/08, per calibrare le attese)
- Flotta vera alle taglie nuove: **+274.745 € · DD 6,37% · peggior
  giorno −4,74% (25/05/26)**.
- La revisione ha tagliato il DD (8,8→6,4%) **ma il peggior GIORNO è
  intatto**: i suoi motori (cluster U30USD) non erano fra i revisionati.
  👉 il muro giornaliero prop del 5% è IL fronte di questo round.

## 3. Le domande (= i capitoli del referto)
- **D1 — Anatomia dei giorni neri**: i 10 peggiori giorni di squadra,
  scomposti sedia per sedia. Chi perde INSIEME, su quale simbolo, a che
  ora. (Il 25/05/26 e il 19/02/25 già indiziati: cluster Dow.)
- **D2 — Sovrapposizione**: matrice di co-perdita per coppia di sedie
  (giorni in cui perdono entrambe / giorni operati insieme) + il peso di
  ogni SIMBOLO nel rischio di squadra (7 sedie su U30USD!).
- **D3 — Contributo marginale**: per ogni sedia, squadra CON vs SENZA
  (profitto, DD, peggior giorno) — il leave-one-out fatto bene, alle
  taglie nuove.
- **D4 — Il muro prop**: worst-day e DD vs muri 5%/10% alle taglie
  attuali; e la riscalatura GLOBALE che servirebbe per stare nel muro
  con margine dichiarato (es. peggior giorno ≤ 3,5%).
- **D5 — La squadra ottima, SENZA pesca** (vedi §4).

## 4. Il cancello anti-pesca (il cuore metodologico) [DA FIRMARE]
Scegliere "le migliori" sulla stessa finestra che le ha misurate è
curve-fitting di portafoglio. Regola proposta:
- **SPLIT temporale**: COSTRUZIONE sui primi 14 mesi (2024.09.26 →
  2025.11.30), VERIFICA sugli ultimi 7 (2025.12.01 → 2026.06.30).
- Qualunque "squadra ottima" o riscalatura viene scelta SOLO sui dati di
  costruzione e giudicata SOLO sulla verifica. Se non regge in verifica,
  il referto lo dice e NON la propone.
- Nessuna promozione automatica: l'output è una PROPOSTA con firma
  separata (come la revisione A+b).

## 5. Cosa NON fa
Non tocca il forward; non ottimizza parametri EA; non inventa correlazioni
di prezzo (misura CO-PERDITE realizzate, che è ciò che morde i muri);
non giudica il merito delle singole (fatto in R103; tagliando resta).

## 6. 🔴 LE TRE FIRME
```
[ ] F1 PERIMETRO: 35 sedie vive, taglie nuove, 21 mesi comuni
[ ] F2 ANTI-PESCA: split 14+7 mesi (costruzione/verifica) come al §4
[ ] F3 OUTPUT: D1-D5, e ogni proposta operativa (riscalatura globale,
     squadra ottima) resta [DA FIRMARE] a parte — questo round INFORMA
```
Alla firma: il round gira subito (niente PC di backtest, niente attese).
