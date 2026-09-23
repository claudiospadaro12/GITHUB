# 🏁 I 13 ROUND — REFERTO, letto con il protocollo congelato PRIMA dei numeri

**Corsa**: `DESKTOP-H4D7CAJ` · pin `c3ac4ada` · 19:05→21:18, **133 minuti** · VPS `VMI3047753` NON toccato.
**CATENA COMPLETA: 13 cartelle su 13.** 9 round `rc 0`, 4 round `rc 3`.
🟢 I quattro `rc 3` (R236c-f) hanno **un rilievo solo, e previsto**: *"round girato a Modello 1
(non tick reali): screening, non verdetto"*. Era dichiarato nei file prova. **Non è un guasto.**

Protocollo applicato: `report/COME_SI_LEGGONO_I_13_ROUND_2026-09-23.md`. Non è stato cambiato
nulla dopo aver visto i numeri.

---

## 0️⃣ I CANCELLI CROCIATI — **PASSATI TUTTI**, e si guardano per primi

### T1 · R234a cella H1 deve riprodurre R110
| | atteso | misurato | |
|---|---|---|---|
| IS | PF 1,23153 · DD 4,5113% · n 125 | **1.23153 · 4.5113 · 125** | ✅ |
| OOS | PF 1,89147 · DD 2,6628% · n 302 | **1.89147 · 2.6628 · 302** | ✅ |

**Identico cifra per cifra.** Il banco riproduce un numero noto → **i tre file R234 si leggono**.

### T2 · R235, gemelli e ancora R141
- **Ancora R141** (`n IS 146 · n OOS 261`): **ESATTA su tutti e quattro i file**, e su tutti e due i simboli.
- **Gemelli, cella L+S**: identica **al centesimo**. ✅
  - U30USD OOS: profit **1040.56 = 1040.56**, identico.
  - 🔎 **Residuo misurato e dichiarato**: su NASUSD OOS la stessa cella dà **6587,43** contro
    **6586,46** (Δ **0,97 €** su 6.587 = **0,015%**) e PF 1,24027 vs 1,24023. **`n` e DD identici.**
    Al centesimo il cancello passa; **il residuo resta NON SPIEGATO** e va agli atti così.

### T-falsificazione · additività `n(long) + n(short) = n(L+S)`
| simbolo | gamba | long | short | somma | L+S | |
|---|---|---|---|---|---|---|
| NASUSD | IS | 85 | 61 | **146** | 146 | ✅ |
| NASUSD | OOS | 141 | 120 | **261** | 261 | ✅ |
| U30USD | IS | 76 | 70 | **146** | 146 | ✅ |
| U30USD | OOS | 138 | 123 | **261** | 261 | ✅ |

🟢 **4 terne su 4, esatte. Il file NON è falsificato** (classe 676 confermata di nuovo).

---

## 1️⃣ R235 — IL LATO. Esito: **RAMO 3 su TUTTI E DUE I SIMBOLI**

`R = n(short)/n(long)` in OOS:
- **NASUSD: 120/141 = 0,851** → RAMO 3 (banda 0,667-0,923)
- **U30USD: 123/138 = 0,891** → RAMO 3

### L'aritmetica del ramo 3, coi numeri VERI di questa corsa
Sotto **deriva pura** il P/L short atteso è `− P/L long × n(short)/n(long)`:

| simbolo | long misurato | short PREDETTO dalla deriva | short MISURATO | quanto perde MENO |
|---|---|---|---|---|
| **NASUSD** | +7.687,72 (n 141) | **−6.542,7** | **−986,89** (n 120) | **6,6 volte meno** |
| **U30USD** | +2.434,37 (n 138) | **−2.169,8** | **−1.352,36** (n 123) | **1,6 volte meno** |

👉 **LA DERIVA NON BASTA A SPIEGARE LO SHORT.** Conclusione scritta nel file prova **prima**
della corsa: *"sarebbe LO SHORT ad avere il segnale per operazione migliore, non il long — che è
l'ESATTO CONTRARIO della lettura comoda «gli short perdono ovunque, teniamo i long»"*.

🟢 **Nota di validazione**: il long NASUSD misura **+7.687,72** e lo short **−986,89**, cioè i
**+7.688 / −987** di R98. La scomposizione riproduce l'archivio: quello che mancava era l'`n` per
lato, e adesso c'è.

### 🎯 Le due previsioni di DD scritte PRIMA hanno centrato
| | predetto nel protocollo | misurato |
|---|---|---|
| NASUSD IS (L+S) | ~11,94% | **11,7437%** |
| U30USD IS (L+S) | ~9,87% "sul filo" | **9,7997%** |

**T3 sulle celle PURE: passano tutte e quattro** (short 8,05 / long 4,93 / short 6,65 / long 4,28).

### 🔴 E IL LIMITE, congelato prima e non negoziabile
**NIENTE MERITO.** `@FRAZIONEIS 0.40` dà IS `n=146` sulla L+S — **sotto 150** — e le celle pure
stanno ancora più sotto (85 · 61 · 76 · 70). **Nessuna promozione, nessuno spegnimento, qualunque
PF sia uscito.** R98 non si riapre: in `REGISTRO_TEST.md` lo stato resta **NON ANCORA MISURATO**.

---

## 2️⃣ R234 — IL TIMEFRAME. Esito: **salire di TF per pagare meno spread UCCIDE il motore**

Cancello del costo (`40 × spread per barra`, classe 650) applicato **prima** del PF.

### U30USD (Dow) — l'unico con qualcosa di vivo
| cella | costo | IS PF (n) | **OOS PF (n)** | verdetto |
|---|---|---|---|---|
| M30 | 28,4× 🔴 | 1,351 (284) | 0,790 (587) · DD 15,94% | **ESCLUSA PER COSTO** |
| **H1** | **40,1× 🟠** | 1,232 (125) | **1,891 (302) · DD 2,66%** | 🟢 **viva, ma sul filo del costo** |
| H2 | 56,7× 🟢 | 2,821 (33) | **0,789** (111) | 🔴 negativa |
| H3 | 69,5× 🟢 | 1,877 (20) | **0,669** (63) | 🔴 negativa |
| H4 | 80,2× 🟢 | 3,501 (9) | **0,367** (20) | 🔴 negativa |

🔴 **IL RISULTATO, ed è netto**: le **tre** celle che passano comodamente il cancello del costo
(H2/H3/H4) sono **tutte negative in OOS**. L'unica viva è proprio quella **sul filo**.
⚠️ E le loro IS erano **bellissime** — 2,82 · 1,88 · 3,50 — su `n = 33 · 20 · 9`: **picchi di
rumore su campione minuscolo**, esattamente il difetto che la regola del 19/08 descrive. Se
avessimo scelto sull'IS avremmo schierato la cella peggiore.

### D30EUR (DAX) — 🔴 **morto su tutti e cinque i TF**
OOS PF: M30 **0,950** · H1 **0,724** · H2 **0,540** · H3 **0,758** · H4 **0,662**.
Le uniche due che passano il costo (H3 41-47×, H4 48-55×) fanno **0,758** e **0,662**.
👉 Il **corto `EMA200` sul DAX** non ha una cella viva a nessun timeframe.

### NASUSD — 🔴 nessuna cella viva che passi il costo
L'unica OOS positiva è **M30 (PF 1,230, n 569)** ed è **ESCLUSA PER COSTO a 23,7×** — col suo
numero accanto, come vuole la regola. H4 fa OOS 1,166 ma con **IS 0,318 su n=15**.

---

## 3️⃣ R236 — a/b SOSPESI, e/f la scoperta della serata

> ## 🔴 CANCELLO DEL COSTO: **NON PRONUNCIATO**
> Per **R236a/b** la FASE 1 (test singolo, `Optimization=0`, Giornale acceso) **non è stata
> lanciata**, e **nessuno strumento del repo oggi sa lanciarla**: `walkforward_generico.ps1`
> scrive `Optimization=1` cablato a r.2013, e in ottimizzazione `Print()` non gira (classe 526).
> 👉 Da questa corsa **NON** si scrive il verdetto sul **40×** (T7) né l'attribuzione del
> movimento dell'`n` (T3). **Si scrive SOLO la SOPRAVVIVENZA**, cioè il confronto fra celle.

### R236a/b — il buffer dello stop (tick reali)
`n` **identico su tutto l'asse** (25/42 e 44/76): ✅ corretto e atteso — il buffer cambia le
**uscite**, non gli **ingressi**.

| | short NASUSD (R236a) | long NASUSD (R236b) |
|---|---|---|
| OOS PF, da buffer 3 → 2603 | 1,598 → **1,743** (a 1303) → 1,448 | 0,948 → 1,033 → 0,994 → 1,048 → 1,040 |
| forma | 🟢 **altopiano al CENTRO**, non picco al bordo | 🔴 piatto intorno a 1,0 |
| IS | ~1,0 piatto (n 25) | 🔴 **cresce monotona** 1,545 → 1,773 |

🔴 **R236b è il caso da manuale**: il buffer **ottimizza l'IS in modo monotono e non porta nulla
in OOS**. Se si scegliesse sull'IS si prenderebbe il bordo (2603) per niente.
🟢 **Quello che invece è reale su entrambi**: il **DD scende in modo monotono** col buffer
(1,08→0,74 e 2,54→1,54). Il buffer compra **tranquillità**, non profitto.

### R236c/d — il lookback (OHLC, screening)
- **short**: asse quasi **inerte** (OOS 1,671 → 1,631, `n` fisso 42);
- **long**: OOS **migliora** col lookback (0,990 → 1,084) mentre l'IS **peggiora** (1,760 → 1,387).
  🔴 **Segni opposti fra IS e OOS = niente da promuovere.**

### 🔥 R236e/f — **l'asse vero era `InpUseTimeWindow` (0 → 1)**
| | finestra OFF | finestra **ON** |
|---|---|---|
| **SHORT NASUSD** IS | PF 0,963 (n 25) | **PF 1,846** (n 16) |
| **SHORT NASUSD** OOS | PF 1,671 (n 42) · DD 1,039% | 🔥 **PF 3,729** (n 24) · **DD 0,509%** |
| **LONG NASUSD** IS | PF 1,760 (n 45) | PF 2,809 (n 37) |
| **LONG NASUSD** OOS | PF 0,990 (n 76) | 🔴 **PF 0,990** (n 52) |

👉 **DUE MISURE INDIPENDENTI PUNTANO NELLO STESSO POSTO.** R235 dice che sul Nasdaq **lo short ha
il segnale per operazione migliore**; R236e dice che **la finestra oraria glielo più che
raddoppia** (1,671 → 3,729) **dimezzando il DD**. E il long muore in OOS in tutti e due i modi.

🔴 **MA: `n = 16 IS / 24 OOS`, e Modello 1 OHLC = SCREENING, NON VERDETTO.**
**È un SEGNALE, non una sedia.** Non si promuove niente, non si accende niente.

---

## 🎯 LA PROVA CHE SERVE DOPO, e una sola
**R236e ripetuto a TICK REALI, sul lato corto del Nasdaq, con la finestra oraria ad asse e più
`n`.** È l'unica misura che può trasformare la convergenza R235+R236e da segnale in candidato.
Tutto il resto di questa corsa ha **chiuso** porte, il che vale: il corto `EMA200` sul DAX è
morto a cinque timeframe, e salire di TF sul Dow non paga.
