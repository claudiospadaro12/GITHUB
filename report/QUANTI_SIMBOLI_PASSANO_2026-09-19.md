# 🔎 QUANTI SIMBOLI PASSANO — **censimento di TUTTA la flotta contro i cancelli**

**19/09/2026** · richiesta di Claudio: *«ALLARGHIAMO»* → *«Fammi sapere quanti simboli passano»*
→ *«GUARDA TUTTI GLI EA, EASY TREND, COST, GAP, MINMAX, QUALUNQUE»*

**Metodo**: 879 CSV appaiati IS/OOS, **163 combinazioni EA × simbolo**, cella per cella.
**Cancelli applicati insieme**: `n ≥ 150 deal` in **entrambe** le finestre · `PF ≥ 1,10` in
**entrambe** · `DD ≤ 14%` in entrambe.

---

## ① IL NUMERO SECCO

> # **6 combinazioni su 163** hanno almeno una cella che passa tutti e quattro i cancelli.
> # 🔴 **Ma una delle sei passa SOLO su OHLC. Le vere sono CINQUE.**

| EA | simbolo | celle che passano | su totali | |
|---|---|---:|---:|---|
| `ABTG_DAX_Apertura_EU` | **D30EUR** | **67** | 521 | 🟢 già in campo, è la sedia n.1 |
| `ABTG_EMA200` | **U30USD** | **44** | 67 | 🟡 in campo (`771531`), ma **−19,39 su 21** |
| `ABTG_EMA200` | 🆕 **EURUSD** | **15** | 30 | 🟢 **NON schierato** |
| `ABTG_CostToCost` | EURJPY | 8 | 13 | 🔴 **tutte OHLC → non valgono** |
| `ABTG_Dow_Apertura_US` | U30USD | 3 | 48 | 🟡 in campo (`770202`), n=4 |
| `ABTG_PTE` | GBPUSD | 2 | 228 | 🟡 in campo (`771322`) |

## ② 🔴 IL CASO `CostToCost`, e perché l'ho tolto

Sembrava **il miglior tasso di passaggio della flotta: 8 celle su 13, il 62%.** E nel report
settimanale `COST EURJPY L` ha fatto **+22,38, 1 su 1**.

🔴 **Ma le 8 celle stanno TUTTE in `..._ohlc_r127c.csv`**, e la regola di casa **S7** dice che
l'**OHLC è screening, mai un verdetto**. Sui dati pieni (`r40`, `r41`) le celle sono **5 in
tutto** e **ne passano ZERO**.
📌 E il campo dice la stessa cosa: `772361` EURJPY fa **−130,83 su 7 operazioni, 3 vinte su 7**.

> ## 🟢 **Averlo verificato è valso la ricerca: era il candidato più bello della tabella, ed era un miraggio.**

## ③ 🟢 L'UNICO ALLARGAMENTO VERO: **`EMA200` su EURUSD**

**15 celle su 30 (il 50%)**, su **dato pieno**, `r29a`. Le tre migliori:

| cella | IS | OOS |
|---|---|---|
| P19 | PF **1,206** · n **423** · DD 8,88% | PF **1,140** · n **712** · DD 10,48% |
| P26 | PF 1,137 · n 347 · DD 9,44% | PF 1,147 · n **643** · DD **9,88%** |
| P15 | PF 1,148 · n 317 · DD 9,23% | PF 1,148 · n 598 · DD 11,98% |

**Campioni enormi** (fino a 712 deal OOS), segni coerenti, DD sotto il 12%.

### ⚠️ MA LA RISERVA VA DETTA INSIEME AL NUMERO, ed è mia, del 18/09
La finestra di `r29a` è **`@DAQUANDO 2024.09.26` — circa 21 mesi, UN SOLO REGIME**, e le 30 celle
girano in gran parte **sulle stesse operazioni**. Inoltre sulla scansione H4 dello stesso motore
il **LONG fa 0 celle positive su 28** contro lo **SHORT 26 su 26**.
👉 **È un candidato forte per il campione, debole per il regime.** La prova di regime non c'è.

---

## ④ 🟠 E LA LISTA CHE VALE DI PIÙ: **ferme SOLO per CAMPIONE**

Combinazioni dove **nessuna cella arriva a n=150**, quindi il merito **non è stato misurato** —
non bocciato:

`GoldenCross_Ottimizzato`×XAUUSD (152 celle) · `SupertrendInvert`×USDJPY · `WOL`×SPXUSD/NASUSD/
GBPUSD/U30USD · `BreakingBand`×EURUSD/GBPUSD · `SupertrendReversal`×225JPY (27) ·
`GoldenCross`×USDCHF/NZDUSD (148 ciascuno) · `MaxMinNotte_DAX_Short`×D30EUR (21)

🔴 **Attenzione ai PF giganti**: `GoldenCross_Ottimizzato` XAUUSD ha `min(PF)` **420,7** e
`SupertrendInvert` USDJPY **108,6**. Non sono scoperte: sono **celle degeneri** con pochissime
operazioni. **È esattamente il motivo per cui il cancello del campione viene prima di quello del
merito.**

---

## ⑤ 📌 CONCLUSIONE PER L'ALLARGAMENTO

🔴 **La flotta è più stretta di quanto sembrasse: su 163 combinazioni misurate, CINQUE passano, e
quattro sono già in campo.** L'unico simbolo nuovo che passa è **EURUSD su `EMA200`**, con la
riserva del regime.

🟢 **E la via d'uscita non è cercare fra i round già fatti — è che la maggior parte delle
combinazioni non è mai arrivata a 150 operazioni.** Quelle non sono morte: sono **non misurate**.
Lì l'allargamento è ancora tutto da fare, e costa tempo macchina, non fortuna.

---
*Fonti: 879 CSV `ABTG_*_{IS,OOS}_*.csv` sotto `backtest_pipeline/risultati_prove/` e
`risultati_archivio/`, letti cella per cella · `report/CONTRATTI_SEDIE.md` rr.150-152 per
`CostToCost` · `data/statements/trades_auto.csv` per il campo ·
`report/AUDJPY_E_GBPUSD_IL_NUMERO_CHE_MANCAVA_2026-09-18.md` per la riserva su `r29a`.*
