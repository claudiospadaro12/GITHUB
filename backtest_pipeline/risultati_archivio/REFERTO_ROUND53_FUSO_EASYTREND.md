# 🕐 REFERTO ROUND 53 — **la fascia non decide: si tiene 8-18**

_Girato il 14/08/2026 notte sul PC di backtest. `ABTG_EasyTrend`, H1, tick
reali, deposito 100.000, rischio 1%. 128 passate (16 celle × 2 finestre × 4
simboli), **8 CSV su 8**. Criteri congelati a numeri non visti in testa a
`prove/R53_fuso_EZ.txt`._

---

## 0. Igiene: le celle vive si riproducono

Il file R53 pinna la geometria della famiglia e muove **solo** `InpHourStart` e
`InpHourEnd`. La cella `8-18` deve quindi ricalcare i numeri di R48. Li ricalca:

| simbolo | cella 8-18 OOS (R53, dep. 100k) | R48 (dep. 10k) |
|---|---|---|
| GBPUSD | PF **1,483** · DD **4,66%** · **n = 41** | PF 1,49 · DD 4,58% · **n = 41** |
| CHFJPY | PF **1,250** · n = 53 | PF **1,25** |

Stesso numero di trade, PF a due centesimi. Il banco è pulito.

> ⚠️ **Limite dichiarato su AUDJPY.** Il file R53 pinna `InpTP_R = 1.5` su tutti
> e quattro i simboli, ma la cella **viva** di AUDJPY è **TP 1,0** (R48/R49,
> magic 772423). Il voto di AUDJPY riguarda quindi una geometria che in campo
> non c'è. Non cambia il verdetto (vedi §2: senza AUDJPY il conteggio è ancora
> più lontano dalla soglia), ma va scritto.

---

## 1. Le quattro diagonali — le uniche che contano

Le altre 12 celle hanno larghezza diversa da 10 ore: **non sono la regola della
fonte**, sono una finestra qualunque. Criterio 1: ignorate.

### GBPUSD
| fascia | IS profit | IS PF | OOS profit | **OOS PF** | OOS DD | OOS n |
|---|---:|---:|---:|---:|---:|---:|
| 6-16 | −625,69 | 0,959 | +10.113,40 | 1,480 | 3,72% | 41 |
| **7-17** | +7.156,24 | **1,563** | +11.781,74 | **1,553** | 3,57% | 42 |
| 8-18 _(oggi)_ | +3.500,31 | 1,243 | +10.174,47 | 1,483 | 4,66% | 41 |
| 9-19 | +6.550,55 | 1,450 | +7.435,85 | 1,331 | 6,20% | 41 |

### EURGBP
| fascia | IS profit | IS PF | OOS profit | **OOS PF** | OOS DD | OOS n |
|---|---:|---:|---:|---:|---:|---:|
| 6-16 | −3.990,54 | 0,759 | −3.393,24 | 0,823 | 5,70% | 28 |
| **7-17** | −2.768,04 | 0,819 | −2.021,68 | **0,895** | 6,36% | 29 |
| 8-18 _(oggi)_ | −663,84 | 0,945 | −5.366,49 | 0,783 | 9,58% | 37 |
| 9-19 | −147,43 | 0,985 | −10.170,75 | 0,635 | 10,95% | 40 |

**Rosso in tutte e otto le celle.** Conferma indipendente della bocciatura di
R48: non è la fascia oraria a tenere fuori EURGBP.

### AUDJPY
| fascia | IS profit | IS PF | OOS profit | **OOS PF** | OOS DD | OOS n |
|---|---:|---:|---:|---:|---:|---:|
| 6-16 | +2.117,01 | 1,168 | +5.754,92 | 1,180 | 7,85% | 51 |
| 7-17 | −1.451,35 | 0,901 | +4.763,19 | 1,153 | 7,40% | 49 |
| **8-18** _(oggi)_ | −5.395,01 | **0,649** | +14.787,23 | **1,521** | 5,28% | 50 |
| 9-19 | −3.439,08 | 0,745 | +12.148,07 | 1,417 | 5,90% | 50 |

### CHFJPY
| fascia | IS profit | IS PF | OOS profit | **OOS PF** | OOS DD | OOS n |
|---|---:|---:|---:|---:|---:|---:|
| 6-16 | +2.271,79 | 1,134 | +1.551,38 | 1,053 | 9,78% | 47 |
| 7-17 | +6.022,81 | **1,398** | +6.422,19 | 1,206 | 8,62% | 52 |
| **8-18** _(oggi)_ | +2.792,38 | 1,154 | +7.859,78 | **1,250** | 6,31% | 53 |
| 9-19 | +3.842,35 | 1,227 | +1.566,12 | 1,058 | 5,23% | 43 |

---

## 2. Il conteggio — criterio 2

Miglior PF **fuori campione**, un voto per simbolo:

| simbolo | fuso vincente | coerente anche in IS? |
|---|---|---|
| GBPUSD | **7-17** | ✅ sì (7-17 è il migliore anche IS) |
| EURGBP | **7-17** | ❌ no (in IS vince 9-19) — e comunque tutto rosso |
| AUDJPY | **8-18** | ❌ no (in IS 8-18 è **la peggiore**) |
| CHFJPY | **8-18** | ❌ no (in IS vince 7-17) |

**7-17 → 2 voti. 8-18 → 2 voti. Serviva 3 su 4.**

Il criterio 2 chiede anche la coerenza **nella stessa direzione in campione**:
applicandolo per intero, **un solo simbolo su quattro** ha un fuso coerente
(GBPUSD, 7-17). Più lontano ancora dalla soglia.

Togliendo AUDJPY per il limite del §0 il conteggio diventa 2-1 su tre simboli:
la soglia di 3 su 4 resta irraggiungibile in ogni lettura.

# ⚖️ VERDETTO — criterio 3

> **LA FASCIA NON DECIDE. Si tiene il valore letterale della fonte: 8-18.**

Il default non si sposta senza una ragione, e _"ha reso di più su un simbolo"_
non è una ragione. Era scritto prima di vedere un solo numero.

---

## 3. Perché il risultato è più forte di un pareggio

L'ipotesi del round era: _la regola del coach è la stessa, ma letta su un altro
orologio._ Se fosse vero, **il fuso giusto vincerebbe dappertutto**: un fuso è
una proprietà dell'orologio, non del cambio. Era l'ipotesi 1 della tesi.

Non vince dappertutto. E il modo in cui perde è istruttivo:

- **GBPUSD preferisce la finestra più PRESTO** (7-17, e fra tutte e 16 celle la
  sua migliore è 9-**16**): la sterlina vive su Londra.
- **AUDJPY preferisce la finestra più TARDI** (8-18 e 9-19 staccano nettamente
  6-16 e 7-17).

Non è il pattern di un orologio spostato: è il pattern delle **sessioni proprie
di ogni cambio**, che è cosa nota e banale. **L'ipotesi 1 è falsificata**, e
scatta l'ipotesi 2 della tesi: _"se i simboli si contraddicono, la fascia conta
poco — informazione utile lo stesso, e si tiene 8-18"._

**Conseguenza pratica, criterio 5:** per **ogni** strategia futura della stessa
fonte, l'orario si mette **letterale** e non si spende tempo a rimapparlo. La
domanda aperta da settimane in `EASY_TREND_TESI.md` righe 41-44 è chiusa.

---

## 4. 🔁 Il 29° ribaltamento — AUDJPY

| AUDJPY 8-18 | profitto | PF |
|---|---:|---:|
| **in campione** | −5.395,01 | **0,649** — la PEGGIORE delle quattro |
| **fuori campione** | +14.787,23 | **1,521** — la MIGLIORE delle quattro |

**Circa 20.000 € di differenza fra le due finestre sulla stessa fascia**, e il
segno che si inverte. Chi avesse scelto il fuso guardando il campione avrebbe
buttato via proprio la finestra che poi ha fatto il risultato — e, per pura
coincidenza, avrebbe buttato via anche **quella che usiamo già**.

Nota amara e onesta: il ribaltamento riguarda la fascia **in uso oggi**. Non ci
salva un merito, ci salva il fatto che non abbiamo toccato niente.

---

## 5. La trappola che il criterio 1 ha disinnescato

Se avessimo guardato tutte e 16 le celle invece delle 4 diagonali:

| simbolo | migliore fra TUTTE le 16 (OOS) | larghezza | migliore fra le 4 diagonali |
|---|---|---:|---|
| GBPUSD | **9-16** · PF 1,580 · +9.345 | **8 h** | 7-17 · PF 1,553 |
| EURGBP | **6-18** · PF 0,969 · −612 | **13 h** | 7-17 · PF 0,895 |
| AUDJPY | 9-18 · PF 1,537 · +14.625 | 10 h | 8-18 · PF 1,521 |
| CHFJPY | **6-18** · PF 1,257 · +8.433 | **13 h** | 8-18 · PF 1,250 |

**Su tre simboli su quattro la cella più bella ha la larghezza sbagliata** —
cioè non è più la regola della fonte, è una finestra ottimizzata a posteriori.
E i guadagni rispetto alla diagonale sono ridicoli (PF +0,027 su GBPUSD, +0,007
su CHFJPY): si sarebbe rotta la regola del coach per due millesimi di PF.

Il criterio 1 era scritto prima proprio per questo. Ha funzionato.

---

## 6. Cosa NON cambia — criterio 4

**Easy Trend resta fuori.** Fuori dal portafoglio (R49: aggiunge +12,6% ma alza
**tutte** le code) e fuori dalla prova di regime (R50). Le tre sedie in
osservazione (772421-23) **non si toccano**: fascia 8-18, come sono.

Il round non riapre nulla e non era lì per riaprire: era lì per verificare se
sei settimane di verdetti erano stati dati con una regola spostata di un'ora.
**Non lo erano.**
