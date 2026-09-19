# 🪑 QUALI SEDIE NELLA PROP — **la rosa a oggi, incrociando contratto e campo**

**19/09/2026** · domanda di Claudio: *«Quindi quali sedie metteremo nella prop?»*
Incrocio fra `report/CONTRATTI_SEDIE.md` (il **DD promesso**, firmato) e
`data/statements/trades_auto.csv` (il **campo vero**, ricontato oggi per MAGIC).

---

## ① IL QUADRO COMPLETO — tutte le sedie con un contratto firmato

| magic | EA | simb | contratto | **DD promesso** | **campo** | |
|---|---|---|---:|---:|---|---|
| **`770511`** | SuperWave DOW H1 Ott | U30USD | 1,0 | **4,0%** | 🟢 **+344,33** · 10/16 | 🥇 |
| **`770411`** | MaxMinNotte DAX Short | D30EUR | 1,0 | 🟢 **1,27%** | 🟢 **+155,78** · **5/5** | 🥈 |
| **`770402`** | MaxMinNotte ORO | XAUUSD | **0,5** | 🟠 **10,0%** | 🟢 +43,73 · 6/11 | 🥉 |
| **`770101`** | DAX Apertura EU | D30EUR | 1,0 | **4,35%** | 🟠 −509,66 · 30/39 *(ma **+149,16** nella sola parte RETEST, 14/15)* | 4 |
| `770250` | Nasdaq GatedShort | NASUSD | — | 🔴 **nessuno** | 🟢 +7,56 · 2/2 | — |
| `770202` | Dow Apertura | U30USD | 1,0 | 4,22% | ⚪ +0,35 · 3/4 *(campione nullo)* | — |
| `771531` | EMA200 | U30USD | 1,0 | 7,21% | 🟠 −19,39 · 10/21 | ❌ |
| `770531` | SuperWave H2 | U30USD | 1,0 | 2,96% | 🔴 −41,68 · **4/14** | ❌ |
| `770611` | ORB Ottimizzato | U30USD | 1,0 (+0,3) | 🔴 **9,92%** *(cella di confine, doppio asterisco)* | 🔴 **−209,18 · 1 vinta su 8** | ❌ |
| `770901` | SupRev Nikkei H2 | 225JPY | 0,65 | 🟢 0,88% | 🔴 −81,85 · **0 vinte su 3** | ❌ |
| `771321` | PTE Dow | U30USD | 1,0 | 2,18% | ⚪ +3,78 · 1/1 | — |

---

## ② 🥈 LA SORPRESA: **`770411` MaxMinNotte DAX Short**

**5 operazioni, 5 vinte, +155,78** — e il **DD promesso più basso di tutta la flotta: 1,27%**
(R16; promozione del 26/07 con PF 2,05 · DD 3,1% su 41 trade).
🔴 **Non l'avevo mai messa nella rosa**, e non c'era una ragione misurata: c'era che guardavo le
sedie di cui si parlava di più. ⚠️ Il limite vero è il **campione: n=5**.

## ③ 🥇 E `770511` è meglio di come l'avevo detto
Ieri avevo scritto **+244,94**: veniva dal ponte per **commento**. Ricontato per **magic** fa
**+344,33 su 16 posizioni**. 👉 Il numero giusto è il secondo.

## ④ ❌ CHI ESCE, e col numero
- **`770611` ORB**: **1 vinta su 8**, −209,18 in campo, e un DD promesso **9,92%** che l'archivio
  marca *«cella di confine, passa il muro del 10% per 8 centesimi»*. **Due bandiere rosse insieme.**
- **`770901` Nikkei**: **0 vinte su 3**. DD promesso ottimo (0,88%), campo inesistente.
- **`770531` SuperWave H2**: 4 vinte su 14.
- **`771531` EMA200**: metà e metà su 21, netto negativo. *(Decisione di Claudio del 18/09: resta
  accesa sul demo, non si spegne niente.)*

---

## ⑤ 🔴 MA LA ROSA NON SI CHIUDE OGGI, E IL MOTIVO NON È INDECISIONE

**Tre delle quattro migliori hanno un difetto ATTIVO nel binario che gira in campo**
(`report/CENSIMENTO_BINARI_50503392_2026-09-18.md`):

| sedia | difetto nel binario in campo |
|---|---|
| **`770511`** | 🧨 pavimento del lotto → **doppio del rischio** (misurato 20/08: 1,42% su contratto 1,0%) |
| **`770402`** | 🧨 breakeven annegato nel parziale **a 0,01 lotti — cioè come opera davvero** |
| **`770101`** | 🧨 guardia «un trade al giorno» col buco · e il FIX C4 non in campo |

> ## 🔴 **Una sedia il cui binario in campo è diverso dal sorgente validato non è quella sedia. Il DD promesso dal contratto si riferisce a codice che su quel conto non gira.**

👉 **Ecco perché la toppa firmata stamattina viene prima della rosa.** Non è una deviazione: è il
**primo cancello** dello schieramento.

---

## ⑥ ✍️ E LE DUE COSE CHE MANCANO, TUTTE DI CLAUDIO
1. **La prop**: FTMO (1:15) o FundedNext (1:25). Decide **quante sedie entrano in margine** — con
   quattro sedie su tre simboli diversi il margine morde prima del drawdown.
2. **Le taglie** (`InpRiskPercent` per sedia). I contratti sono scritti a 1,0% e 0,5%; sul conto
   piccolo girano a 0,25-0,35%. **Il numero per la prop non è nessuno dei due, ed è suo.**

## 📌 In una riga
**Oggi la rosa per numeri è `770511` · `770411` · `770402` · `770101` (in RETEST).** 🔴 Ma tre su
quattro girano codice difettoso, e finché non si ricompila **il contratto che promettono non è
quello che farebbero**. La toppa per ticket e la ricompilazione sono il passo che le rende sedie
vere invece che candidate.

---
*Fonti: `report/CONTRATTI_SEDIE.md` (righe per magic, colonne rischio e DD promesso) ·
`data/statements/trades_auto.csv` aggregato per `magic` · `report/CENSIMENTO_BINARI_50503392_2026-09-18.md` ·
`report/LE_SEDIE_PER_LA_PROP_2026-09-18.md` per la separazione BREAKOUT/RETEST di `770101`.*
