# 🔬 ROUND 88 — ORB: stop largo, ricetta del corso, geometria del range

_Girato la notte del 19→20/08/2026 (23:42→01:58, 2h16) sul PC di backtest, pin
`c7714a8`, U30USD, tick reali, deposito 100.000. **Criteri firmati da Claudio
il 19/08 alle ~18:05, a numeri mai visti** (`R88_CRITERI.md`). 27 file su 27
completati, tutte le celle attese prodotte. CSV agli atti in `r88_csv/`._

## 0. La prova di sanità (il cancello che rendeva valido tutto il resto)

La cella base (`InpSLMode=3` halfrange, `InpSLBufferPts=0`, `InpTPMode=1`) ha
riprodotto il riferimento della sedia viva **ai 4 decimali**:
**Profit 41.057,00 · PF 1,6742 · DD 9,7623% · 119 trade.**
L'input nuovo `InpSLBufferPts` e' un **no-op esatto** a default 0: i numeri di
questo round si possono leggere.

## 1. ⚖️ VERDETTO FORMALE: NESSUNA PROMOZIONE

**Nessuna cella supera tutti e quattro i cancelli firmati** (DD OOS <= 7,00% ·
PF OOS >= 1,40 · IS con profit > 0 e PF IS >= 1,10 · n OOS >= 95 / n IS >= 57).
La sedia in campo **resta quella che e'**. Nessun parametro cambia.

E c'e' un limite piu' profondo, gia' previsto: **n IS = 71, molto sotto 150**.
Per l'Emendamento della finestra (regola A) il giudizio di **MERITO e'
sospeso**: quello che segue si legge per il **RISCHIO** (regola B: un drawdown
e' un fatto accaduto) e come diagnosi.

## 2. 🥇 LO STOP LARGO — il fatto piu' importante della notte

Le sei celle migliori per PF sono **tutte `InpSLMode=0` (OPPRANGE = stop
all'estremo opposto del range, quello che prescrive il corso)**:

| SL | buffer | TP | PF IS | **Profit OOS** | **PF OOS** | **DD OOS** |
|---|---:|---|---:|---:|---:|---:|
| OPPRANGE | 1000 pt (10 pt indice) | in R 2,0 | 0,934 | 22.483,75 | **1,8437** | **5,300%** |
| OPPRANGE | 500 pt (5 pt indice) | in R 1,5 | 1,063 | 23.003,35 | **1,8385** | **3,840%** |
| OPPRANGE | 500 pt | in R 2,0 | 1,087 | 23.457,58 | 1,8375 | 5,580% |
| OPPRANGE | 0 | in R 2,0 | 1,046 | 24.135,73 | 1,8163 | 5,872% |
| **HALFRANGE 0 (LA SEDIA VIVA)** | **0** | **range 1,5x** | **1,250** | **41.057,00** | **1,6742** | **9,7623%** |
| FIXED | qualunque | range | 1,483 | 73.377,30 | 1,7801 | **17,901%** |

**Il fatto, misurato:** lo stop all'estremo opposto **dimezza il drawdown**
(9,76% -> **3,84-5,87%**) e **alza il Profit Factor** (1,674 -> **1,84**), al
prezzo di un profitto assoluto piu' basso (23k invece di 41k — stop piu' largo
= lotto piu' piccolo a parita' di rischio %).

E' esattamente la direzione indicata da R55 (*"l'ORB non muore di PF, muore di
drawdown"*) e dal criterio D di `ORB_100K_CRITERI.md` (*"la via e' ALLARGARE
LO STOP"*). Per una prop, **un DD del 3,8% invece del 9,8% e' la differenza fra
passare e fallire**.

🔴 **Perche' allora non promuove?** Perche' il **PF IS di quelle celle sta fra
0,93 e 1,09**, sotto il cancello firmato di 1,10. E' lo **stesso identico
inciampo di R15** (dove OPPRANGE fece OOS PF 1,68 / DD 4,1% e fu scartata per
IS piatto) — ma stavolta il no era **scritto prima**, e si rispetta.
📌 Da notare, senza cambiare niente: la cella HALFRANGE viva ha PF IS **1,250**,
il migliore del gruppo. In-sample la sedia attuale e' la piu' forte; out-of-
sample e' quella col rischio peggiore.

🚫 **FIXED bocciato secco**: profitto piu' alto di tutti (73k) ma **DD 17,9%**,
quasi doppio del muro. Il criterio di bocciatura secca (DD > 9,7623%) scatta.


## 2-bis. 🔴 IL DATO CHE COMPLETA IL QUADRO: il DD in ENTRAMBE le finestre

Guardato dopo (il PF IS da solo non basta a giudicare il rischio):

| cella | IS: PF | **IS: DD** | IS: profit | OOS: PF | **OOS: DD** | OOS: profit |
|---|---:|---:|---:|---:|---:|---:|
| **OPPRANGE buf 500, TP in R 1,5** | 1,063 | **4,78%** | **+1.190** | 1,8385 | **3,84%** | +23.003 |
| OPPRANGE buf 500, TP in R 2,0 | 1,087 | 4,26% | +1.685 | 1,8375 | 5,58% | +23.458 |
| OPPRANGE buf 0, TP in R 2,0 | 1,046 | 5,02% | +945 | 1,8163 | 5,87% | +24.136 |
| **HALFRANGE (SEDIA VIVA)** | 1,250 | **7,89%** | +9.509 | 1,6742 | **9,76%** | +41.057 |
| FIXED | 1,483 | 16,74% | +30.177 | 1,7801 | 17,90% | +73.377 |

**Lo stop largo ha un drawdown minore in TUTTE E DUE le finestre** (4,78 contro
7,89 nel vecchio; 3,84 contro 9,76 nel recente) **e profitto positivo in
entrambe**. Non e' un colpo di fortuna su una finestra: e' coerente su due
periodi indipendenti.

### ⚠️ La tensione fra il criterio firmato e l'Emendamento — dichiarata, non nascosta
Il cancello 3 firmato dice *"PF IS >= 1,10"*, cioe' giudica il **MERITO** sulla
finestra **vecchia**. L'Emendamento della finestra (regola B, congelato il
16/08) dice l'opposto: **il vecchio giudica il RISCHIO, il recente giudica il
MERITO**. Applicando la regola B:
- **RISCHIO** (finestra vecchia): DD IS **4,78% contro 7,89%** -> vince lo stop largo.
- **MERITO** (finestra recente): PF OOS **1,84 contro 1,67** -> vince lo stop largo.

**R88 non promuove lo stesso**, perche' i criteri firmati valgono per il round
in cui sono stati firmati e non si riscrivono dopo aver visto i numeri. La
regola di casa e' esplicita: *un criterio migliore vale dal round DOPO*.
Quello che segue e' quindi una **proposta per il round dopo**, non una
promozione mascherata.

### 📐 Il conto che interessa a una prop
Su un conto da 100.000, nel periodo OOS:

| | profitto | DD massimo | quanto budget di rischio consuma per arrivare a +10% |
|---|---:|---:|---|
| sedia viva | +41,1% | **9,76%** | tocca quasi il muro del 10% |
| stop largo (buf 500 / TP R 1,5) | +23,0% | **3,84%** | poco piu' di un terzo del muro |

La sedia viva guadagna di piu' **ma passa il round sfiorando il muro**; lo stop
largo arriva al target di una challenge consumando **un terzo** del budget di
drawdown. Per una prop e' la metrica che decide.

## 3. 🚫 LA RICETTA DEL CORSO: BOCCIATA, e senza appello

| CloseConfirm | Volumi | EMA 9/21 | PF IS | PF OOS | DD OOS | n OOS |
|---|---|---|---:|---:|---:|---:|
| **no (attuale)** | qualunque | qualunque | 1,250 | **1,6742** | 9,76% | 119 |
| si | si | si | 0,707 | 1,1706 | 9,79% | 120 |
| si | si | no | 0,523 | 1,1224 | 11,96% | 136 |
| si | no | no | 0,804 | **0,9751** | 16,57% | 191 |
| si | no | si | 0,729 | **0,9494** | 15,98% | 190 |

**La conferma di chiusura M5 — che il corso chiama "la cura dell'errore n.1" —
sul Dow a tick reali DISTRUGGE il motore**: PF da 1,674 a 1,17 nel caso
migliore, sotto 1,00 quando e' sola. Il nostro ingresso al tocco, che il corso
condanna, e' il ramo che paga.

🐤 **E il canarino previsto ha cantato**: con `CloseConfirm=0` le quattro celle
sono **identiche al centesimo** — conferma sperimentale del difetto trovato
leggendo il codice (volumi ed EMA 9/21 sono chiamati SOLO dentro il ramo della
conferma di chiusura). Il round ha verificato una previsione fatta sul sorgente.

## 4. 📐 LA GEOMETRIA DEL RANGE: la nostra batte entrambe quelle del corso

| range | fonte | PF IS | **PF OOS** | **DD OOS** | Profit OOS |
|---|---|---:|---:|---:|---:|
| **14:30-14:45 (15 min)** | **NOSTRA, R15** | 1,154-1,250 | **1,6866** | **9,76%** | **+41.841** |
| 14:30-15:00 (30 min) | **la DIDATTICA dei 2 PDF** | 0,826-0,911 | 1,0632 | 12,29% | +3.546 |
| 14:25-14:30 (5 min pre) | l'INDICATORE V15 | 0,741-0,761 | **0,7775** | **36,79%** | **−23.452** |

- Il **pre-apertura dell'indicatore** (che era il default del nostro sorgente!)
  e' un **disastro**: PF 0,78 e **DD 36,8%**. Chiuso.
- L'**OR30 consigliato dalla didattica** ("alta affidabilita'") sul Dow a tick
  reali sta **appena sopra il pareggio**: PF 1,06.
- La cella scelta da R15 nel 2026 regge: **e' la migliore delle tre, di molto.**

Fine giornata **21:00 vs 22:59**: differenza minima (1,6866 vs 1,6742, un trade
in piu'). Non e' una leva.

## 5. Cosa NON e' misurato (dichiarato)

- **Profondita' dei tick di U30USD: NON MISURATA.** Il referto di
  `scarica_storico.ps1` non aveva la riga TICK per il simbolo, quindi il
  `@DAQUANDO 2024.09.26` resta **prudente ma non verificato**. Va misurato.
- **Un solo regime** (Dow 2024-2026 prevalentemente rialzista) e **n IS 71**:
  il merito non e' giudicabile, per regola.
- Lo stop largo cambia il **lotto**: la sensibilita' allo slippage andrebbe
  rimisurata (un R55-bis), non e' stata fatta.

## 6. 🔭 Cosa propone il round (PROPONE, non promuove)

1. **La pista dello stop largo NON e' chiusa, e' sospesa per campione corto.**
   L'unico modo di giudicarla per il MERITO e' una finestra IS con >= 150
   operazioni, che i tick reali del Dow **non possono dare** (partono dal
   26/09/2024). Le due vie: (a) misurare davvero la profondita' tick, casomai
   fosse maggiore; (b) una prova di REGIME su barre OHLC lunghe per il solo
   giudizio di RISCHIO (regola B) — dichiarando che non e' tick.
2. **La ricetta del corso e' chiusa sul Dow.** Il ramo close-confirm non va
   riaperto senza un meccanismo nuovo.
3. **La geometria e' chiusa**: 14:30-14:45 resta.
4. Il difetto strutturale trovato nel sorgente (volumi/EMA attivi solo col
   close-confirm) va corretto **se e quando** quel ramo servira' davvero:
   oggi non serve.
