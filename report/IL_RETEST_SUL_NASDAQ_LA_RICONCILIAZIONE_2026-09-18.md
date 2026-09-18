# 🔬 IL RETEST SUL NASDAQ — **tre misure, due segni, e la spiegazione**

**18/09/2026 sera** · nasce da Claudio: *«PROVA IL RETEST SUL NASDAQ»* · e da **due miei errori
consecutivi**, corretti qui prima di consegnare.

> # 🔴 LE MIE DUE VERSIONE SBAGLIATE, IN FILA
> 1. **«il RETEST sul Nasdaq non è mai stato provato»** — falso: è misurato in **tre** posti.
> 2. **«è già provato e ha perso»** — **anche questa incompleta**: due celle sono **POSITIVE**
>    in OOS, e le avevo sepolte.
>
> ## ✅ **E la versione giusta è la più interessante delle tre: le misure NON si contraddicono. Misurano DUE STRATEGIE DIVERSE che si chiamano tutte e due «retest».**

---

## ① LE MISURE CHE ESISTONO, tutte ricontate da me sui CSV

### (A) Walk-forward `NASDAQ_B` — **EA core `ABTG_Nasdaq_Apertura_US`, magic `770201`**
`risultati_archivio/Walkforward_Aperture/NASDAQ_B_motore_{IS,OOS}.csv`, `InpEntryMode=2`
Finestre: **IS** 26/09/2024→30/06/2025 · **OOS** 01/07/2025→30/06/2026.

| filtro volumi | IS PF | IS n | IS DD% | OOS PF | OOS n | OOS DD% | OOS profit |
|---|---:|---:|---:|---:|---:|---:|---:|
| **OFF** | 0,8135 | 176 | 16,25 | **1,0408** | 240 | 8,79 | **+218,98** |
| **ON** | **1,1450** | 91 | 5,95 | **1,1094** | 94 | 3,68 | **+274,35** |

### (B) `NASDAQ_E_retest_fill_FULL` — 20 passate, offset del limit 0/100/200/300, finestra piena
Da **−3.122,22 · PF 0,765 · DD 41,25%** a **+9,93 · PF 1,001 · DD 14,65%**, n 382-430. **Negativo.**

### (C) **R83** — EA `ABTG_Apertura_3Ingressi`, magic `777020/777021`
OOS **PF 0,6239 · n=303 · DD 29,137% · −2.411,28**. Il peggiore dei tre stili del duello.
*(Sul DAX lo stesso duello dà il contrario: RETEST **PF OOS 1,1878, +999,42 su 311**.)*

---

## ② 🎯 PERCHÉ (A) E (C) NON SI CONTRADDICONO: **sono setup diversi in tre parametri STRUTTURALI**

Diff fatto riga per riga fra la riga `EntryMode=2` di `NASDAQ_B_motore_OOS.csv` e
`prove/R83n1_limit_NASUSD.txt`:

| parametro | **(A) walk-forward** *positivo* | **(C) R83** *negativo* | cosa cambia davvero |
|---|---|---|---|
| `InpRangeMode` | **0** | **2** | **da dove vengono i livelli**: range dei primi minuti ↔ candela H1 precedente |
| `InpRangeMinutes` | **35** | **15** | quanto dura la finestra di formazione |
| `InpTP1_R` | **0,5** (→ 1,5R) | **1,0** (→ 3R) | **il target**, tre volte più lontano |
| EA / magic | core `770201` | `3Ingressi` `777020` | motore diverso |

🟢 **Uguali**: simbolo, `InpSessionHour=14`, `InpLevelTF=H1`, `InpBufferPoints=200`,
`InpRiskPercent=1`, `InpOneTradePerDay=1`, e la finestra parte dallo stesso 26/09/2024.

> ## 🔴 **Quindi «il retest sul Nasdaq» non è UNA cosa: sono due.** Chiamarle con lo stesso nome e metterle in una tabella una sotto l'altra è un errore di misura, non una contraddizione dei dati. **Ed è l'errore che stavo per fare.**

---

## ③ COSA DICE OGNUNA, letta coi cancelli di casa

### 🔴 (C) R83 — **è la configurazione PIÙ VICINA alla sedia viva, ed è quella che perde**
Il preset vivo ha `InpRangeMode=2`, **come R83**. 👉 **Sul disegno della sedia, il retest è
misurato e perde**: PF 0,624 su 303 operazioni, DD 29,14%. Campione **sopra** il pavimento dei 150.
**Verdetto: negativo, con certificato.**

### 🟠 (A) volumi OFF — **S4 FALLITA: segni opposti fra IS e OOS**
IS PF 0,814 (n=176) contro OOS PF 1,041 (n=240). Campione ok in tutte e due,
**ma il segno cambia** → per la regola di casa è **«REGIME, non edge»**, non un promosso.

### 🟢 (A) volumi ON — **l'UNICA combinazione di casa positiva su TUTTE E DUE le finestre sul Nasdaq**
IS **PF 1,1450** (n=91, DD 5,95%) · OOS **PF 1,1094** (n=94, DD 3,68%).
Segni coerenti, PF sopra 1,10 in entrambe, **DD bassissimo**.
🔴 **E le manca UNA cosa sola: il campione.** 91 e 94 contro il pavimento di **150**.

> ## 🔥 **QUESTO È UN CANDIDATO FERMO PER UN NUMERO CHE MANCA, NON PER UN NUMERO BRUTTO.** E la regola di casa su questo è esplicita: *«non si archivia: si trova la via più corta al numero»*. È la stessa forma del caso `EMA200` Dow del 09/09.

⚠️ **Le riserve, dette insieme al numero e non dopo:**
- n=91/94 è **sotto soglia**: il PF 1,11 può essere rumore. Non è una promozione, è un **indizio**.
- Il filtro volumi **dimezza il campione** (240 → 94): fa esattamente quello che ci si aspetta da
  un filtro che taglia, e un PF che sale quando la n crolla è il sintomo classico del **sovra-filtro**.
- 🔴 **R84 ha già misurato il filtro volumi da solo** (senza retest): cella `B`, n=75,
  **OOS negativa** come tutte e nove. Quindi il volume filter **da solo non salva niente** —
  se qualcosa c'è, sta nella **combinazione** retest+volumi, e questa è un'ipotesi da misurare.
- 🔴 E la configurazione «volumi ON» **non ha MAI operato in campo**
  (`IL_DRAWDOWN_CHE_NON_ABBIAMO_MISURATO_2026-09-18.md` §10).

---

## ④ COSA NON SI FA

🚫 **Non si riaccende `770201`.** Resta spenta dal 18/08 09:41, 🔴 **[SENZA CONTRATTO]**:
PF 0,82 · DD 17% · 19/20 celle OOS negative (`CONTRATTI_SEDIE.md` r.54), e R83+R84 fanno
**12 configurazioni, 12 OOS negative** = terzo verdetto indipendente.
**Un indizio su 94 operazioni non ribalta 12 misure.**

🚫 **Non si lancia un round «proviamo il retest»**: è provato. Quello che manca è **campione**
sulla combinazione retest+volumi, e il vincolo è noto — il tester regge **~100.000 barre**, quindi
M5 ≈ 1,3 anni per corsa, e la finestra dei tick indici parte comunque dal **26/09/2024**
(profondità misurata, non assunta). 👉 **Più campione su quella finestra non c'è.** Le due vie
vere sono: **(a)** scendere di TF per moltiplicare le occasioni — e allora va dichiarato il
cancello di costo; **(b)** rifare il duello sui **simboli gemelli** (Dow, SPX), dove il retest
è già acceso in campo su `770202`.

---

## 📌 In una riga
**Il retest sul Nasdaq è misurato tre volte. Sul disegno della sedia viva perde, e perde bene
(PF 0,62 su 303). L'unica cosa positiva in casa è un'ALTRA strategia — range 35 minuti, target
1,5R, filtro volumi — che fa PF 1,11 su tutte e due le finestre con DD sotto il 6%, e che ha
n=91/94 contro un pavimento di 150.** 🔥 **Non è da archiviare e non è da schierare: è da
misurare, e il modo più corto è il duello sui gemelli, non una quarta corsa sul Nasdaq.**

---
*Fonti: `Walkforward_Aperture/NASDAQ_B_motore_{IS,OOS}.csv` (righe `InpEntryMode=2`) ·
`NASDAQ_E_retest_fill_FULL.csv` · `r83_csv/ABTG_Apertura_3Ingressi_NASUSD_{IS,OOS}_r83n1.csv` ·
`prove/R83n1_limit_NASUSD.txt` · `Walkforward_Aperture/REFERTO_WALKFORWARD.md` r.5 per le finestre ·
`report/CONTRATTI_SEDIE.md` r.54 · `backtest_pipeline/REGISTRO_TEST.md` §R83/R84 (indicizzato oggi).*
