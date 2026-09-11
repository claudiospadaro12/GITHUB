# R131 — QUANTO IN ALTO CONVIENE GUARDARE (`InpFilterTF` / `InpStTF`, magic 770101)

**Criteri congelati PRIMA dei numeri. Scritti l'11/09/2026.**
Sedia: `ABTG_DAX_Apertura_EU` — **D30EUR M5** — magic **770101** (vivo sul piccolo
50503392, sul 100k 50504263 e sul **REALE 10105439**: il round gira su magic
**vergini 779952-779959**, non lo sfiora).
Perimetro: **si PREPARA, non si esegue.** Il runner è in sola lettura.

**La domanda, dichiarata prima dei numeri:**
> *"Salire con il timeframe del filtro di direzione (H1 → H4 → D1 → W1) migliora
> il merito, e a quale prezzo in frequenza?"*

**Da dove nasce** — Claudio, 11/09/2026: *"Emiliano dice che la candela weekly è
la più importante. Io ho visto che 15min, H1, H4, daily e weekly erano short e
sono entrato."*

---

## 0. 🔴 LE TRE COSE CHE HO TROVATO LEGGENDO PRIMA DI SCRIVERE, e che cambiano il round

### 0.1 Il filtro è un **VETO**, non un selettore di lato — e la sedia è long-only
`ABTG_DAX_Apertura_EU.mq5` r.1660 `TrendBias()` → 0 / +1 / −1 / 2, valutato **una
volta al giorno all'arming** (r.1444) e congelato in `gBias`; r.1477-1478
`longOK = (gBias==0 || gBias==+1)`, e l'ordine parte solo se `InpAllowLong && longOK`
(r.1480). La cella viva ha **`InpAllowShort=false`**: il ramo short è già chiuso.

👉 **Il filtro può fare una cosa sola: togliere giornate long quando il suo TF dice
giù.** Non è un ramo morto — il veto morde davvero — ma **la domanda si restringe**,
ed è onesto scriverlo: non *"il filtro sceglie la direzione giusta"*, ma
**"le giornate che toglie erano peggiori di quelle che tiene?"**.
La versione a due lati (che è la regola letterale di Claudio) è un round diverso:
vedi §8.

### 0.2 🔴 Il muro dei dati: **92 barre W1 in tutta la finestra**
`[MISURATO]` `risultati_archivio/ABTG_StoricoScaricato.csv`:

| simbolo | TF | barre | prima data | verdetto |
|---|---|---:|---|---|
| D30EUR | M1 | 643.567 | **2024.09.26** | COMPLETO |
| D30EUR | M5 | 129.930 | **2024.09.26** | COMPLETO |

*(controprova: 129.930 × 5 = 649.650 ≈ 643.567 — i due conteggi tornano)*
COMPLETO = *"non manca sul disco"*: **il broker non ce l'ha.** Da 2024.09.26 a
2026.06.30 ci sono **al massimo 92 barre W1**.

**Quante barre serve al filtro prima di essere DEFINITO** (D1 = 1 barra/giorno
feriale, W1 = 1/settimana: per questi due il conto è **esatto**, non stimato):

| strumento | H1 | H4 | D1 | **W1** |
|---|---|---|---|---|
| **EMA50** (r.1664 pretende `CopyBuffer==1` su entrambe) | ~2-3 gg → cieco <1,5% IS | ~9-10 gg → ~4% IS | 50 gg → **~2024.12.05, 21,7% dell'IS cieco** | 50 sett. → **~2025.09.11: 100% DELL'IS CIECO**, 8,8% dell'OOS |
| **Supertrend** (r.1574: basta `copied >= atrPeriod+5 = 15`) | <1 gg | ~3 gg | 15 gg → ~2024.10.17, 6,5% IS | 15 sett. → **~2025.01.09: 32,6% dell'IS cieco, 0% dell'OOS** |

> ### 🔴 **Con l'EMA, la cella W1 NON È UNA MISURA: è un placebo.** Per tutto l'IS `CopyBuffer` non ha 50 barre settimanali, `bias` resta 0 e **il filtro non blocca niente — senza dirlo**.
> ### 🟢 **L'unico strumento di casa che arriva davvero a W1 è il SUPERTREND**, perché si accontenta di 15 barre invece di 50. Per questo il round ha **due scale**, e la prova secca dell'affermazione di Emiliano sta su **R131d (Supertrend W1)**, non sull'EMA.

Se avessi lasciato `InpEmaSlow=200` (il default compilato di questo EA) sarebbe
stato peggio: D1 definita solo da ~2025.07.11 (90% dell'IS cieco) e W1 **cieca per
sempre** (servono 200 settimane, ce ne sono 92). **A 200 questo round non avrebbe
misurato "il TF alto non serve": avrebbe misurato "il filtro non era acceso".**

### 0.3 🔴 Il verso della colonna `Trades` è **l'opposto** di quello che verrebbe da dire
L'intuizione *"più in alto vai, più il filtro è raro, meno trade"* vale per un
**allineamento a più TF**, non per lo **scambio di TF di un filtro solo**.
Su un veto a un lato solo il conto è aritmetico: il filtro toglie i giorni in cui
il suo TF dice **giù**; su un mercato con deriva positiva il segno di un orizzonte
**lungo** dice "su" **più spesso** di uno corto (la deriva cresce come *T*, il
rumore come √*T*). Quindi:

> **ATTESA:** `Trades(H1) ≤ Trades(H4) ≤ Trades(D1) ≤ Trades(W1) ≤ 325`
> — `Trades` **cresce** salendo di TF, e il controllo è il **tetto**.

Il tetto 325 è **duro** (viene dal codice: un veto non può aggiungere operazioni);
l'ordinamento in mezzo è un'attesa di mercato e **può essere smentito** — se lo è,
si scrive che la deriva del DAX in questa finestra non era quella prevista.

---

## 1. COSA È GIÀ STATO PROVATO — censimento rifatto da me l'11/09/2026

Lettura della **colonna** su tutti i CSV del repo (non del nome del file):

| manopola | file | righe | valori distinti |
|---|---:|---:|---|
| `InpFilterTF` | 198 | 5.068 | 🔴 **`16385` (H1, 2.749) · `16388` (H4, 2.319)** — D1 `16408` **MAI**, W1 `32769` **MAI** |
| `InpStTF` | 198 | 5.068 | 🔴 **`16385` (H1)** e basta |
| `InpUseSupertrend` | 198 | 5.068 | acceso in **20 righe = 0,39%**, sempre H1, **mai su questa sedia** (sono `r84f` Nasdaq e `DAX_Live5m_v2`) |
| `InpUseEmaFilter` | 263 | 5.892 | acceso in 1.257 righe — ma su `ABTG_DAX_Apertura_EU`/D30EUR in **ZERO** |
| *(confronto)* `InpLevelTF` | 198 | 5.068 | `16385` (4.801) e **`16408` D1 (267)** — il D1 in casa **esiste**, ma su un'altra manopola |

> ### 🔴 Su questa sedia il filtro di direzione **non è mai stato acceso**, né EMA né Supertrend. Non è *"già provato"*: è **una casella libera**.
> ### 🔴 E in tutto l'archivio **la weekly non è mai stata usata come filtro di direzione. Nemmeno una volta.**

**Il precedente che esiste, ed è il motivo per cui il round vale**
`risultati_archivio/Dow_Apertura/dow_motore.csv` (03/08/2026, **tick reali**,
U30USD M5, BREAKOUT, gestione nuda, **due lati**, EmaFast 1 / EmaSlow 50):

| filtro H4 | Trades | Profit | PF | DD% |
|---|---:|---:|---:|---:|
| spento | 445 | +632,94 | 1,03079 | 14,9407 |
| **acceso** | **329** | **+3.917,49** | **1,23808** | **6,9201** |

−26,1% di operazioni, PF 1,03 → 1,24, **drawdown dimezzato**. E
`dow_robustezza.csv` misura l'**altopiano del periodo**: `InpEmaSlow` da 20 a 200,
**10 celle su 10 sopra PF 1,20** (min 1,202 · max 1,299), con la regola scritta lì:
*"stare sotto i 100"*. 👉 È su **un altro indice** e con **un'altra geometria**:
è una ragione per **misurare**, non un numero da riportare sul DAX.

**Il contro-precedente, e va detto per primo perché è contro di noi**
`DOW_MOTORE.md` riporta la stima di FASE A secondo cui il filtro di trend H4 è
**dannoso sugli indici europei**: DAX **−0,043 R/trade**, CAC −0,053, IBEX −0,081.
È una **stima di FASE A**, non una misura a tick su questa sedia — ed è esattamente
il numero che R131 va a falsificare o a confermare.

---

## 2. LA SEDIA: perché la `770101` e non un'altra — **la risposta è il campione**

| sedia | cella | n | verdetto |
|---|---|---:|---|
| **D30EUR 770101** | R120 tick reali, parziale spento, finestra piena | **325 INGRESSI** → IS ~163 / OOS ~162 | 🟢 **sopra 150 tutte e due** |
| U30USD 770202 | `..._ptc.csv` cella viva (Range 35, long-only, filtro H4 ON) | IS **74** · OOS **130** *(e sono Trades **con** i parziali: gli ingressi sono meno)* | 🔴 **già sotto 150 prima di filtrare** — ESCLUSA PER CAMPIONE |
| NASUSD 770201 | R120 stessa cella | n 483, **PF 0,99284**, tutte e 48 le celle del CSV a Profit negativo | 🔴 **ESCLUSA**: la regola del 19/08 vieta una griglia su un motore senza edge |

Numeri U30USD per esteso (fonte `risultati_prove/ABTG_Dow_Apertura_US/..._ptc.csv`,
riga `InpRangeMinutes=35`, `InpAllowShort=0`):
IS 74 tr · +2.811,84 · PF 1,22247 · DD 5,6692% — OOS 130 tr · +6.721,93 · PF
1,27013 · DD 4,3941%. *(Il censimento contratti la segna già* **SOSPESO 130<150**.*)*

E la `770101` **non è un motore senza edge**: R120, tick reali, finestra piena,
parziale spento → **PF 1,37886**. La regola del 19/08 non morde.

---

## 3. L'ANCORA — cancello bloccante, e la cella di controllo è **replicata 8 volte**

Cella **filtro spento** = cella R120 del 09/09, **tick reali**, finestra piena
2024.09.26→2026.06.30, `InpMagic=770101`, `TP1_ClosePct=0`, `UseTrailing=1`,
`TrailMode=1`, `BEatTP1=1`, `BEatR=0`:

> ### **Trades 325 · Profit +2.970,43 · PF 1,37886 · DD 6,0271% · peggior giornata −1,0569%**
> Fonte: `risultati_prove/gestione_20260909/gestione_ABTG_DAX_Apertura_EU_D30EUR_gestione.csv`

In quel CSV **`Trades = 325` in tutte e 24 le righe col parziale spento**, con
quattro strutture d'uscita diverse: **325 è l'invariante degli ingressi.**

**Tolleranze congelate** (la corsa R120 è a finestra piena, senza split: non può
tornare al centesimo su una singola finestra):
- `Trades(IS) + Trades(OOS)` **fra 321 e 329**
- `Profit(IS) + Profit(OOS)` **entro ±5% di 2.970,43**

Fuori da lì **il banco è sporco e il round si ferma.**

🔑 **E le OTTO celle OFF devono uscire IDENTICHE fra loro** — con il filtro spento
`InpFilterTF` e `InpStTF` sono inerti (r.444 crea i buffer EMA solo dentro
`if(InpUseEmaFilter)`; `SupertrendDir` è chiamata solo dentro `if(InpUseSupertrend)`).
Tolleranza: `Trades` uguale **all'unità**, `Profit` entro **±0,01 EUR** (è la
tolleranza già misurata in casa fra magic gemelli: `ptc` 770202 vs 770203
differiscono di 0,01). **Cancello di determinismo a otto repliche, costo zero.**

---

## 4. LA GRIGLIA — 8 file, 16 celle, 32 passate

| file | scala | TF del filtro | codice | asse | magic |
|---|---|---|---|---|---|
| `R131a_supertrend_H1_D30EUR.txt` | Supertrend (ATR 10 × 2,5) | H1 | 16385 | `InpUseSupertrend` 0/1 | 779952 |
| `R131b_supertrend_H4_D30EUR.txt` | Supertrend | H4 | 16388 | idem | 779953 |
| `R131c_supertrend_D1_D30EUR.txt` | Supertrend | **D1** | 16408 | idem | 779954 |
| `R131d_supertrend_W1_D30EUR.txt` | Supertrend | 🏆 **W1** | 32769 | idem | 779955 |
| `R131e_ema_H1_D30EUR.txt` | EMA 1/50 | H1 | 16385 | `InpUseEmaFilter` 0/1 | 779956 |
| `R131f_ema_H4_D30EUR.txt` | EMA 1/50 | H4 | 16388 | idem | 779957 |
| `R131g_ema_D1_D30EUR.txt` | EMA 1/50 | **D1** | 16408 | idem | 779958 |
| `R131h_ema_W1_D30EUR.txt` | EMA 1/50 | **W1** (placebo) | 32769 | idem | 779959 |

**Magic 779952-779959: cercati su tutto il repo l'11/09/2026, ZERO occorrenze.**

### 4.1 Perché otto file e non un asse sul timeframe — **il conto vero delle celle**
`InpFilterTF` e `InpStTF` sono `ENUM_TIMEFRAMES`. `walkforward_generico.ps1`
r.526-536: su un enum **MT5 ignora lo step e spazzola i MEMBRI** fra start e stop
(tabella dei membri nel driver stesso, r.380-387). Quindi un asse
`16385||16385||1||32769||Y` **non fa 4 celle: ne fa NOVE** —
H1 16385 · H2 16386 · H3 16387 · H4 16388 · H6 16390 · H8 16392 · H12 16396 ·
D1 16408 · W1 32769 — e per di più **non conterrebbe la cella di controllo**, che è
l'ancora e il cancello G1. In più `controlla_prova.py` non conosce gli enum e
stamperebbe `int(|32769−16385|/1)+1 = ` **16.385 celle**: un numero falso in faccia
a chi approva la riga.

👉 **Perciò il TF è un PIN e l'asse è l'interruttore: 2 celle vere per file.**
✅ Esito reale di `controlla_prova.py`: **celle=2 per file, 16 totali, 32 passate,
0 problemi** — il numero stampato è quello **giusto**, non c'è discrepanza da
dichiarare.

### 4.2 Le scelte di pin che si discostano dall'archivio, dichiarate
1. **`InpEmaFast=1`, `InpEmaSlow=50`** (non i 14/200 compilati): sono i valori della
   sedia **gemella viva 770202**; l'altopiano 20-200 è misurato (`dow_robustezza`);
   e a 200 le celle D1/W1 sarebbero **cieche** (§0.2). Identici in tutti e 8 i file:
   **la variabile è una sola, il timeframe.**
2. **`InpTP1_ClosePct=0`** (parziale spento): così **`Trades` è un contatore di
   ingressi esatto**, che è la misura primaria del round. Col parziale al 50% la
   cella viva fa 445 Trades su 325 ingressi e il cancello G1 non esisterebbe.
   Dichiarato: **non è la geometria di campo**; è quella dell'ancora, ed è anche la
   variante che R120 misura **migliore** (PF 1,37886 contro 1,29574).
3. **`InpUsaGuardian=true`**: è il valore della riga-ancora nel CSV R120.
   🔴 **`R130a` pinna `false` sulla stessa ancora: è una discrepanza segnalata, non
   copiata.** Con rischio 1% e `InpOneTradePerDay` la pausa B1 (−4,0%) e il cap C1
   (3,25%) non sono raggiungibili da questa sedia da sola — le due scelte *devono*
   dare lo stesso numero, e il cancello dell'ancora lo **dimostra** invece di darlo
   per buono.
4. **`InpNewsCurrencies` non è pinnato**: è una stringa vuota, MT5 ignora un pin
   vuoto e `controlla_prova.py` lo blocca. Default e valore voluto coincidono.
   **Scritto perché non c'è, non dimenticato.**
5. **`InpVerbose=false`** mentre l'ancora girava con `1`: `ABTGLog` (r.422-426) fa
   **solo `Print()`** — letto, non ricordato. Non può cambiare un trade.

---

## 5. 💰 COSTO IN TEMPO MACCHINA

| | |
|---|---|
| passate | **32** (16 celle × 2 finestre) |
| calibrazione A | `r88_csv/REFERTO_R88.txt`: R88a 48 celle/finestra = 96 passate in **8,0 min** → **5,0 s/passata** → **2,7 min** |
| calibrazione B | R86 su **D30EUR** (stesso simbolo): 4 passate in **0,5 min/file** → 8 file → **4,0 min** *(include l'avvio di MT5 per file)* |
| **stima congelata** | **4-8 minuti** per tutto il round |

👉 Il primo file da lanciare è **`R131h` (EMA W1)**: costa **4 passate ≈ 20 secondi**
ed è il **contro-esempio eseguibile** dell'intera analisi di riscaldamento (§7.1).
Se fallisce, il round si ferma dopo venti secondi invece che dopo otto minuti.
Subito dopo, **`R131a`** per il cancello dell'ancora.

---

## 6. 🔴 IL CANCELLO DI FREQUENZA — congelato PRIMA, perché è quello che decide

Il controllo fa **325 ingressi in 459 giorni feriali = 0,708 operazioni/giorno**.
Il pavimento firmato il 07/09 è **1,00 op/g per FAMIGLIA** (motore × simboli): la
famiglia Aperture ci arriva già col fiatone, e **ogni giornata che il filtro toglie
la allontana**.

> ## 🔴 **UN PF PIÙ ALTO CON METÀ DEI TRADE NON È UN MIGLIORAMENTO: È UN MOTORE DIVERSO, E PIÙ LENTO.**
> Scritto qui, prima dei numeri, perché dopo non ci sia modo di raccontarla
> diversamente.

**Sotto quale TF il campione IS scende sotto 150** — il conto, e fa paura:

| | |
|---|---|
| ingressi IS del controllo | **~163** |
| pavimento | **150** |
| margine | **+13 operazioni = +8,7%** |

> ### 🔴 **Basta che il filtro tolga il 9% delle giornate perché l'IS scenda sotto 150.** Quindi **ci si aspetta che il MERITO di quasi tutte le celle filtrate sia SOSPESO finestra per finestra** (Emendamento A/B), e il round va letto così:
> - **MERITO** → sulla **somma delle due finestre** (`Profit(IS)+Profit(OOS)`,
>   `ExpectedPayoff` pesato = somma profit / somma trades). Su ~230-300 operazioni
>   dopo il filtro, **sopra 150** ✅.
> - **STABILITÀ** → lo split serve a chiedere *"il segno dell'effetto è lo stesso
>   nelle due metà?"*, **non** a dare un verdetto di merito per finestra.
> - **RISCHIO** (DD, peggior giornata) → si legge **a qualunque n**, sempre
>   (Emendamento B).
> - 🚫 **Nessuna cella si propone per lo schieramento se toglie più del 30% delle
>   operazioni** (ingressi totali < 227 ≈ 0,495 op/g). La soglia è una **scelta**
>   fatta prima dei numeri, con la sua ragione misurata: sotto quel taglio questa
>   sedia da sola perde più frequenza (−0,21 op/g) di quanta ne porti **l'intera
>   sedia Dow** (0,46 op/g nel censimento contratti… e la Dow è già sospesa). Le
>   celle sotto soglia **restano in griglia per leggere la forma**, come le celle
>   fuori costo di R128c.

---

## 7. ⚖️ COME SI LEGGONO I CSV — e il contro-esempio, prima dei numeri

### 7.1 🧪 «Se il TF del filtro non contasse niente, quale forma vedrei?»
Quattro ipotesi **distinguibili**, e la griglia le separa:

| ipotesi | forma attesa nei CSV |
|---|---|
| **A. il filtro è CIECO** (dati insufficienti) | `Trades` **identico** al controllo e `Profit` identico **al centesimo** |
| **B. il filtro filtra, ma il TF non porta informazione** (setaccio casuale) | `Trades` scende; **Expected Payoff e PF restano dentro la banda di rumore**; il DD scende ~come √n |
| **C. il TF porta informazione crescente** (tesi di Emiliano) | l'Expected Payoff **cresce** salendo di TF, **in tutte e due le finestre** |
| **D. il filtro schiva UN episodio** | il guadagno è **tutto in IS** (dove sta l'unica discesa), l'OOS pareggia o peggiora |

🔑 **La colonna `Trades` è un controllo gratis**, ma va letta nel verso giusto
(§0.3): **non** "deve calare salendo di TF" — **deve stare sotto 325 e ordinarsi in
crescita**. Se una cella ON avesse **più** operazioni del controllo, il banco è
sporco e il round è **nullo** prima di leggere altro. Se **nessuna** cella tocca
`Trades`, il filtro non sta filtrando e il round è **nullo** allo stesso modo.

🧪 **Il contro-esempio eseguibile**, ed è la ragione per cui `R131h` esiste:
> **`R131h` (EMA W1) deve dare `Trades(cella 1, IS) = Trades(cella 0, IS)` ESATTAMENTE
> e `Profit` uguale al centesimo**, perché la EMA50 su W1 **non è definita** in
> nessun giorno dell'IS. Se non esce così, **la mia lettura del codice o del conteggio
> delle barre è sbagliata** e tutto il round va rifatto. Costa 4 passate.

### 7.2 La misura vera del round **non è il PF**: è il P/L dei giorni tolti
La cella filtrata è un **sottoinsieme** del controllo, non un campione indipendente:
confrontare due PF su insiemi annidati **sovrastima** la differenza. La domanda
giusta si calcola dal CSV **senza una passata in più**:

- `m = 325 − Trades(ON)` → **giorni tolti**
- `medio_tolti = [Profit(OFF) − Profit(ON)] / m`
- `medio_tenuti = Profit(ON) / Trades(ON)`

> ### 🔴 Il filtro porta informazione **solo se `medio_tolti < 0`, in ENTRAMBE le finestre.**

**Soglia di rumore congelata.** σ per trade **`[DERIVATO, non misurato]`**: 1R = 1%
di 10.000 = **100 EUR**, TP totale 3R → esiti fra −100 e +300 → **σ ≈ 120 EUR**.
Serve `|medio_tolti| > 2·120/√m`:

| m (giorni tolti) | soglia |
|---:|---:|
| 40 | **38 EUR/trade** |
| 60 | **31 EUR/trade** |
| 100 | **24 EUR/trade** |

Sotto quella soglia la risposta onesta è **«IL DEFAULT (filtro spento) VA BENE»** —
ed è **un risultato**, non un fallimento.

### 7.3 🏆 LA PROVA SECCA DELL'AFFERMAZIONE DI EMILIANO
Se la weekly è davvero la più importante, **la cella W1 deve battere H1 e H4 da
sola**. Il confronto si legge su **`R131a/b/c/d`** (scala Supertrend: è l'unica che
arriva a W1 con questi dati) sulla riga `medio_tolti`.

> ### 🔴 **LA TABELLA CHE SIGNIFICHEREBBE «È UNA CONVINZIONE, NON UNA MISURA»** — scritta in anticipo. Basta **una** di queste tre:
> 1. `medio_tolti(W1) ≥ 0` in **almeno una** delle due finestre;
> 2. `medio_tolti(W1)` non batte `medio_tolti(H4)` di più di **un errore standard**
>    (`120/√m`);
> 3. il vantaggio di W1 esiste **solo in IS** — cioè è la forma **D** di §7.1, la
>    firma di **un solo episodio**.
>
> In tutti e tre i casi si scrive, con rispetto e col numero:
> *«Sui dati che abbiamo, la weekly non porta più informazione di H1/H4 al filtro di
> direzione della 770101. L'affermazione resta non falsificata solo perché 92 barre
> settimanali non bastano a falsificarla.»*

E se **vincesse**: 🔴 **W1 è una cella di BORDO.** Non ha un vicino sopra (MN1 avrebbe
21 barre in tutta la finestra: non esiste). La regola di casa è **centro
dell'altopiano, mai il picco**: un massimo di bordo **da solo non promuove niente**.
Il seguito sarebbe **riempire H12 (16396) e H8 (16392) sotto di lei** — 2 file, 8
passate, ~1 minuto — non schierarla.

### 7.4 Il regime, e il buco che ne esce
- **IS** 2024.09.26 → 2025.08.13 · 230 feriali · ~163 ingressi
- **OOS** 2025.08.14 → 2026.06.30 · 229 feriali · ~162 ingressi
- L'IS contiene la **correzione di feb-apr 2025**, unico tratto di discesa vera
  dentro i tick BCM *(regime dichiarato in `R130a`, stessa fonte)*.

> 🔴 **Un filtro di direzione su una sedia solo-long guadagna quando c'è una discesa
> da schivare. In questa finestra la discesa è UNA SOLA ed è tutta in IS.** La prova
> di regime dell'Emendamento C (toro/orso/laterale/crollo) **non è eseguibile** su
> questi dati, e va scritto accanto a **ogni** tabella del referto.

Nota a favore del disegno: il riscaldamento del Supertrend W1 finisce ~2025.01.09,
cioè **prima** della correzione — il tratto cieco **non mangia l'evento**.
`[DA VERIFICARE nel referto sulla spina dorsale mensile: è una collocazione
dichiarata, non una misura mia.]`

### 7.5 Il costo del trade **non cambia in nessuna cella**
Spread mediano D30EUR all'ora server 8 = **1,7000 punti indice** su 1.847.049 tick
(`risultati_archivio/spread_flotta/spread_orario_D30EUR.csv`). Lo stop è il bordo
opposto del range ≈ **49,10 punti indice = 28,9× lo spread** (derivato in R130, n=2):
**sotto** il pavimento di lavoro 40× (al 72%), **sopra** il pavimento duro 13,3×.
👉 Il filtro **non tocca né lo stop né l'ingresso**: quel 28,9× è **identico in tutte
e 16 le celle**. **R131 non è un round di costo**: nessuna cella si esclude per costo
e nessuna lo migliora. E la regola *"si preferiscono i TF più bassi"* riguarda il
**TF dell'ingresso** (qui M5 sempre), non quello del filtro.

---

## 8. 🕳️ I BUCHI, DICHIARATI

1. 🔴 **La weekly non è misurabile alla pari con H1 e H4 su dati BCM.** 92 barre. Il
   massimo che R131 può dire è *"il Supertrend W1, cieco per un terzo dell'IS e vivo
   per tutto l'OOS, batte o non batte H1 e H4"*. **Un NO non boccia l'idea di
   Emiliano: boccia ciò che 92 barre permettono di dire.** E un SÌ va riprovato su
   un feed lungo prima di crederci.
2. 🙋 **E c'è un buco che Claudio può chiudere.** `report/STORICO_INDICI_SCARICATO_2026-09-10.md`:
   **NASUSD e SPXUSD esterni coprono 2010.11 → 2026.08** (5,26 e 4,63 milioni di
   barre M1) = **oltre 800 barre W1**. Su quel feed la domanda di Emiliano è
   **pienamente misurabile**. 🔴 Ma il **cancello ZERO `_EXT` è chiuso** (diff media
   H1 0,061-0,101% contro ≤0,05%) e **sul DAX non è nemmeno applicabile** (zero
   giorni di sovrapposizione col nativo BCM). 👉 Serve **una firma** che autorizzi
   i dati `_EXT` per un **round di MISURA** (non di promozione), sul **Nasdaq**.
   È una decisione di Claudio, non mia.
3. ⚠️ **La regola di Claudio è a CINQUE timeframe allineati** (M15·H1·H4·D1·W1); in
   casa ce ne sono **DUE** filtri indipendenti. R131 ne misura **uno alla volta** —
   che è il passo giusto (*prima la misura, poi il codice*), ma **non è la regola
   intera**. L'allineamento a due scale (es. EMA D1 **+** Supertrend W1) è un round
   **successivo**, e attenzione: con due filtri attivi `CombineBias` (r.1706-1713)
   torna **2** sul conflitto e **blocca tutto**, quindi lì `Trades` crolla davvero
   e il cancello di frequenza morde molto prima.
4. ⚠️ **La versione a DUE LATI non è in questo round.** La regola dei due lati
   (25/08) chiede di misurare sempre long **e** short: qui `InpAllowShort=false` è
   pinnato per restare sull'ancora. Il round a due lati **raddoppierebbe la
   variabile** e va fatto dopo, dichiarando che cambia anche il campione.
   **`[NON MISURATO]`**
5. ⚠️ **`medio_tolti` usa una σ DERIVATA, non misurata** (§7.2): i CSV
   dell'ottimizzatore non portano il gross profit/loss né la deviazione standard per
   trade. Se serve la banda vera, va estratta dai report per-trade, ed è un lavoro
   in più **`[NON MISURATO]`**.
6. ⚠️ **`R130a` e `R131` pinnano `InpUsaGuardian` in modo diverso sulla STESSA
   ancora** (§4.2 punto 3). Va chiuso prima che uno dei due round giri, altrimenti
   uno dei due non riprodurrà l'ancora e nessuno saprà perché.

---

## 9. ✅ ESITO DEI CANCELLI (11/09/2026)

| controllo | esito |
|---|---|
| `python3 backtest_pipeline/controlla_prova.py backtest_pipeline/prove/R131*.txt` | **OK** — 8 file, **celle 2 per file**, 16 totali, **32 passate**, **0 problemi** |
| `python3 backtest_pipeline/controlla_riga.py --oggetto prova …` (tutti e 8) | **nessun difetto meccanico** — 8 × «file prova ASCII puro»; unico rilievo, atteso, il [225] («i controlli PowerShell sono spenti su questo oggetto») |

🚫 **Restano i controlli di GIUDIZIO** (agente `controllo-preventivo`) e, prima di
qualunque riga verso il VPS, il **PASS** previsto dalla regola del 09/09.
**Qui si è preparato: non si è eseguito niente.**
