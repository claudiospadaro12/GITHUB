# 🛑 R73 — **LA PROPOSTA CADE.** Con la sedia VERA dentro la griglia, la candidata perde soldi su entrambi i simboli.

_R72 con **un solo pin cambiato**: `InpTP1_ATRmult = 0.5`, cioè quello che gira
davvero in forward (vivaio R23, magic 771321/22/23). Tutta la serie R68→R72
aveva girato col default `0`._

**Banco:** `ABTG_PTE` · H1 · **Modello 4 (tick reali)** · IS `2024.07.05 →
2025.04.21` · OOS `2025.04.22 → 2026.06.30` · 14 celle · rischio 1%.
**Igiene: 4 CSV su 4, 14 celle su 14, e il pin che conta verificato nei quattro
`.ini`: `InpTP1_ATRmult=0.5` ✅, `InpTP1Pct=50` ✅.**

---

## 1. 🎯 IL CONTROLLO CHE VALE PIÙ DI TUTTO IL ROUND: **R58 SI RIPRODUCE AL CENTESIMO**

La cella viva di GBPUSD era già stata misurata in **R58**, mesi di lavoro fa,
con la stessa finestra e lo stesso modello:

| | OOS | PF | DD | n | pegg. GG |
|---|---:|---:|---:|---:|---:|
| **R58** (allora) | **+2.091,17** | **1,378** | **3,27%** | **49** | **−1,02%** |
| **R73** (adesso) | **+2.091** | **1,38** | **3,27%** | **49** | **−1,02%** |

> ### 🏆 **Identici. Due round indipendenti, a mesi di distanza, stesso numero fino al centesimo.**
>
> 📌 **E chiude l'`[INCERTO]` lasciato aperto in R58** (le righe di parametro
> che non erano passate e la griglia da 16 celle): **quel numero era giusto.**

## 2. 🛑 IL CRITERIO 2 **NON PASSA. SU NESSUNO DEI DUE SIMBOLI.**

Criterio congelato: _"la candidata abbassa il DD **SENZA perdere profitto OOS**"_.

### GBPUSD

| | **OOS** | PF | **DD** | pegg. GG | n |
|---|---:|---:|---:|---:|---:|
| 🪑 **VIVA** `buf 5 / TP 2,0` | **+2.091** | **1,38** | 3,27% | −1,02% | 49 |
| 🎯 candidata `buf 25 / TP 3,0` | **+1.172** | 1,36 | **3,12%** | −0,93% | 51 |

**DD meglio di 0,15 punti, profitto in meno di 919 euro (−44%). ❌**

### USDJPY — **ed è qui che la correzione di stamattina si è rivelata decisiva**

| | **OOS** | PF | **DD** | pegg. GG | n |
|---|---:|---:|---:|---:|---:|
| 🪑 **VIVA** `buf 5 / TP 2,0` | **+979** | 1,15 | 4,90% | −1,05% | 42 |
| 🎯 candidata `buf 25 / TP 3,0` | **+654** | 1,15 | **3,81%** | −1,01% | 44 |

**DD meglio di 1,09 punti, profitto in meno di 325 euro (−33%), PF identico. ❌**

> ## 🔴 **E GUARDA COSA AVEVA FATTO IL PIN SBAGLIATO:**
> | `InpTP1_ATRmult` | OOS della cella viva su USDJPY |
> |---|---:|
> | **0** (R72, quello che NON gira) | **−837** 🔴 |
> | **0,5** (R73, quello che GIRA) | **+979** 🟢 |
>
> **Il take-profit parziale a 0,5 ATR ribalta il segno della sedia viva.**
> In R72 avevo scritto _"la config viva è l'unica cella negativa"_ e avevo
> proposto di cambiarla. **Con la configurazione vera, quella sedia guadagna —
> e la candidata che volevo metterle al posto guadagna un terzo in meno.**

## 3. 🚦 VERDETTO SUL CRITERIO 3

Il file prova diceva: _"solo se il punto 1 **E** il punto 2 passano ENTRAMBI si
può proporre un cambio."_

| | GBPUSD | USDJPY |
|---|---|---|
| punto 1 (rischio) | ✅ | ✅ |
| punto 2 (merito) | ❌ | ❌ |

> # 🛑 **PROPOSTA RITIRATA. Le sedie della PTE restano ESATTAMENTE come sono.**
>
> **Non è "non ancora": è NO.** Misurato sui tick reali, contro la
> configurazione che gira davvero, la candidata **paga drawdown con profitto**
> su tutti e due i simboli.

## 4. ✅ MA IL §1 REGGE — **NONA E DECIMA CONFERMA**

**Drawdown OOS:**

| buffer | 0 | 5 | 10 | 15 | 20 | 25 | 30 |
|---:|---:|---:|---:|---:|---:|---:|---:|
| **GBPUSD** | 4,26 | 3,27 | 3,22 | 3,17 | 3,15 | 3,12 | **3,10** |
| **USDJPY** | 5,08 | 4,90 | 4,21 | 4,05 | 3,94 | 3,81 | **3,78** |

**Monotone, di nuovo, su una configurazione di uscita DIVERSA.** Dieci conferme
in totale, due modelli, tre finestre, due simboli, due impostazioni di TP1.

> 🎯 **`InpSLbufferPips` governa il drawdown della PTE. Questo è il risultato
> solido della serie, ed è l'unico che è sopravvissuto a ogni controllo.**

📉 **Ma il prezzo si vede adesso**: su GBPUSD il profitto scende col buffer
(+1.392 → +731 lungo la riga), su USDJPY pure (+2.248 → +206). **Con il TP1
parziale acceso, il buffer costa rendimento su ENTRAMBI i simboli** — mentre
in R72 (senza TP1) su USDJPY lo faceva salire. **Regola B, quarta replica: il
rischio si comporta uguale ovunque, il rendimento no.**

## 5. ⏸️ E LA SELEZIONE RESTA SOSPESA — vale anche per le celle che sembrano buone

n IS = **24-30**, contro la soglia di **150** del punto A.

Nella griglia si vedono celle appetitose — `buffer 0` su USDJPY fa **+2.248
PF 1,33**, `buffer 15` fa **+1.698 PF 1,38 con DD 4,05%** — e **nessuna di
queste può essere scelta**. Le due celle giudicate erano nominate prima; tutto
il resto è materiale per un round con campione vero, non per una decisione.

## 6. ⚠️ E UN NUMERO CHE VA GUARDATO, ANCHE SE NON È IL TEMA

L'IS di GBPUSD ha **PF fino a 37,21**. Non è un edge: sono nove mesi con quasi
nessuna perdita, e infatti l'OOS scende a **1,38-1,50**. **È la ragione per cui
in questa casa non si guarda l'IS per giudicare, solo per scegliere.**

---

## 7. 🚦 COSA RESTA IN PIEDI DELLA SERIE R67→R73

| | |
|---|---|
| ✅ **Il buffer governa il drawdown** | 10 conferme, 2 modelli, 2 simboli, 3 finestre, 2 configurazioni di uscita |
| ✅ **`InpSLbufferPips` è in pip, l'ATR no** | sul Dow vale ~0,03 ATR: parametro **non portabile** (R69) |
| ✅ **Regola B** | rischio replicabile, rendimento no — quattro volte |
| ✅ **R58 riprodotto al centesimo** | e chiuso il suo `[INCERTO]` |
| 🛑 **Cambiare la PTE in forward** | **NO. Misurato, non rimandato.** |

## 8. ➡️ IL SEGUITO

1. 🔧 **Buffer in multipli di ATR** (`sl = entry − atr*(1+InpSLbufferATR)`) su
   copia **`_Ottimizzato`**. È l'unica strada che resta aperta dalla serie: se
   il buffer governa il drawdown ma **in unità sbagliate**, la cosa da
   sistemare è l'unità, non il valore.
2. 🔬 **Sonda dello storico su tutti i simboli** — trasforma metà del
   `CENSIMENTO_REGOLA_FINESTRA.md` da **[STIMA]** a misura.
3. 📥 **Import Dukascopy indici dal 2012** — sblocca **94 coppie su 155**.

**E la lezione operativa del round, che vale più dei numeri:**
> 🎯 **Prima di confrontare una candidata con "quello che gira", si verifica
> che "quello che gira" sia davvero dentro la griglia.** Cinque round hanno
> confrontato contro una configurazione che in forward non esisteva.
