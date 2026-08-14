# R52 — CENSIMENTO DEI LATI, cella per cella (14/08/2026)

_Domanda di Claudio: "in ogni EA esiste anche il lato opposto?"_
Questo file **non propone niente e non lancia niente**: dice solo, per ogni
cella viva, **quale lato gira** e se il lato mancante e' **VINCOLATO** dalla
strategia (non esiste come idea) oppure **SCELTO** durante l'ottimizzazione
(esiste, ed e' stato spento su 21 mesi di mercato in salita).

Fonti incrociate: sorgenti `mql5/Experts/*.mq5` · `deploy_vivaio_*.ps1` ·
`verifica_vivaio_r23.ps1` (lista dei .chr attesi) · `report/DEPLOY_GUARDIANO_100K.md`
· `report/CAMPAGNA_ARSENALE.md` · referti in `risultati_archivio/`.

---

## 1. TABELLA MADRE

### 1a — I 5 TITOLARI (demo 100k, conto 50504263)

| # | Cella | EA | Simb | TF | Magic | Lato che gira | Come e' controllato | Lato mancante | Riferimento |
|---|---|---|---|---|---|---|---|---|---|
| 1 | DAX Apertura EU | ABTG_DAX_Apertura_EU | D30EUR | M5 | 770101 | **SOLO LONG** | input `InpAllowShort=false` messo sul GRAFICO (`.mq5:251-252` restano true) | **SCELTO** | FASE M 07/08 (`Walkforward_Aperture/REFERTO_FASE_M.md`) |
| 2 | Dow Apertura US | ABTG_Dow_Apertura_US | U30USD | M5 | 770202 | **SOLO LONG** | input `.mq5:227-228`, valore da grafico | **SCELTO** (short MAI misurato) | `REFERTO_ROUND6_DOW.md` |
| 3 | MaxMin DAX Short | ABTG_MaxMinNotte_DAX_Short_Ottimizzato | D30EUR | M15 | 770411 | **SOLO SHORT** | input col default gia' spento: `.mq5:58 InpAllowLong=false // OTT: solo SHORT` | **SCELTO** | griglia D30EUR (`MaxMinNotte/080957cf-*.csv`) + R2 |
| 4 | Nikkei STREV | ABTG_SupertrendReversal | 225JPY | H2 | 770901 | LONG + SHORT | input `.mq5:45-46`, entrambi true | — nessuno | R5 (prova non pinna i lati) |
| 5 | ORB-EMA200 | ABTG_ORB_Ottimizzato | U30USD | M5 | 770611 | **SOLO LONG** | input `.mq5:54-55`, prova `R15:43 InpAllowShort=0` | **SCELTO** (short MAI misurato sul Dow) | R13 -> R14 -> R15 |

### 1b — VIVAIO e OSSERVAZIONE (demo piccolo, conto 50503392)

| # | Cella | EA | Simb | TF | Magic | Lato che gira | Come e' controllato | Lato mancante | Riferimento |
|---|---|---|---|---|---|---|---|---|---|
| 6 | MAXMIN ORO | ABTG_MaxMinNotte | XAUUSD | H2 | 770402 | LONG + SHORT | input, entrambi 1 nella prova e nel deploy | — nessuno | R17 (`R17_oro_notte.txt:41-42`) |
| 7 | PTE Dow | ABTG_PTE | U30USD | H1 | 771321 | LONG + SHORT | input `.mq5:55-56`, default true/true, preset non li tocca | — nessuno | coda B -> R23 |
| 8 | PTE GBPUSD | ABTG_PTE | GBPUSD | H1 | 771322 | LONG + SHORT | idem | — nessuno | coda B -> R23 |
| 9 | PTE USDJPY | ABTG_PTE | USDJPY | H1 | 771323 | LONG + SHORT | idem | — nessuno | coda B -> R23 |
| 10 | SW Dow H2 | ABTG_SuperWave | U30USD | H2 | 770531 | LONG + SHORT | input `.mq5:46-47`, default true/true | — nessuno | coda B -> R23 |
| 11 | SW GBPUSD H2 | ABTG_SuperWave | GBPUSD | H2 | 770532 | LONG + SHORT | idem | — nessuno | coda B -> R23 |
| 12 | EMA200 Dow | ABTG_EMA200 | U30USD | H1 | 771531 | LONG + SHORT | input `.mq5:45-46`; prove R29/R31 pinnano 1/1 | — nessuno | R29 -> R31 |
| 13 | BB GBPUSD | ABTG_BreakingBand | GBPUSD | H1 | 772161 | L+S (pattern ENTRAMBI) | **nessun input di lato**: `.mq5:924 isLong=(gBulgeDir>0)` / `:949 isLong=(gBulgeDir<0)` | **VINCOLATO** | R33 -> R34 |
| 14 | BB EURUSD | ABTG_BreakingBand | EURUSD | H1 | 772162 | L+S (solo CONT) | idem | **VINCOLATO** | R33 -> R34 |
| 15 | BB AUDUSD | ABTG_BreakingBand | AUDUSD | H1 | 772163 | L+S (solo INV) | idem | **VINCOLATO** | R33 -> R34 |
| 16 | GAP GBPUSD | ABTG_GapFill | GBPUSD | H1 | 772231 | contro il gap (L o S) | **nessun input**: `.mq5:424 isLong=(gGap<0.0)` | **VINCOLATO** | R36 -> R37 |
| 17 | GAP EURUSD | ABTG_GapFill | EURUSD | H1 | 772232 | contro il gap | idem | **VINCOLATO** | R36 -> R37 |
| 18 | GAP AUDUSD | ABTG_GapFill | AUDUSD | H1 | 772233 | contro il gap | idem | **VINCOLATO** | R36 -> R37 |
| 19 | GAP Dow (osserv.) | ABTG_GapFill | U30USD | H1 | 772234 | contro il gap | idem | **VINCOLATO** | R36 |
| 20 | GAP Nikkei (osserv.) | ABTG_GapFill | 225JPY | H1 | 772235 | contro il gap | idem | **VINCOLATO** | R36 |
| 21 | LARRY Dow | ABTG_PunteLarry | U30USD | H1 | 772341 | LONG + SHORT | input `.mq5:152-153` (preset 1/1) | — nessuno | R38 -> R39 |
| 22 | LARRY EURAUD | ABTG_PunteLarry | EURAUD | H1 | 772342 | LONG + SHORT | idem | — nessuno | R38 -> R39 |
| 23 | LARRY ORO | ABTG_PunteLarry | XAUUSD | H1 | 772343 | **SOLO LONG** | input (preset `AllowShort=0`) | **SCELTO** | R38 (lati scelti sull'IS) |
| 24 | LARRY GBPJPY | ABTG_PunteLarry | GBPJPY | H1 | 772344 | **SOLO LONG** | idem | **SCELTO** | R38 (short OOS −1.166) |
| 25 | LARRY GBPUSD | ABTG_PunteLarry | GBPUSD | H1 | 772345 | **SOLO SHORT** | input (preset `AllowLong=0`) | **SCELTO** | R38 -> R39 · R50 |
| 26 | LARRY EURCAD | ABTG_PunteLarry | EURCAD | H1 | 772346 | **SOLO LONG** | idem | **SCELTO** | R38 -> R39 |
| 27 | COST EURJPY | ABTG_CostToCost | EURJPY | H4 | 772361 | **SOLO LONG** | input `.mq5:156-157`, preset `AllowShort=0` | **SCELTO** | R40 (sweep lati) -> R41 |
| 28 | COST GBPCAD | ABTG_CostToCost | GBPCAD | H4 | 772362 | **SOLO LONG** | idem | **SCELTO** | R40 -> R41 |
| 29 | COST XAGUSD | ABTG_CostToCost | XAGUSD | H4 | 772363 | **SOLO LONG** | idem | **SCELTO** | R40 -> R41 |
| 30 | EZ CHFJPY (osserv.) | ABTG_EasyTrend | CHFJPY | H1 | 772421 | LONG + SHORT | input `.mq5:199-200`, preset 1/1 | — nessuno | R48 (sweep) -> R49 |
| 31 | EZ GBPUSD (osserv.) | ABTG_EasyTrend | GBPUSD | H1 | 772422 | LONG + SHORT | idem | — nessuno | R48 -> R49 |
| 32 | EZ AUDJPY (osserv.) | ABTG_EasyTrend | AUDJPY | H1 | 772423 | LONG + SHORT | idem | — nessuno | R48 -> R49 |

### 1c — I GRAFICI STORICI ANCORA ACCESI SUL PICCOLO (lato NON verificato)

Sopravvissuti alla pulizia del 10/08 e al referto fuorilista dell'11/08. Non
sono "sedie" della campagna, ma **operano**. Il lato vero sta nei .chr / negli
screenshot, **non nel repo**: `flotta_attesa.csv` mette `*`, e i preset in
`mql5/Presets` sono del forward vecchio (alcuni con `AllowShort=false`).

| Grafico | EA | Simb | TF | Lato che gira | Categoria |
|---|---|---|---|---|---|
| squadra (2% storico) | ABTG_DAX_Apertura_EU | D30EUR | M5 | **[INCERTO]** | vedi §4.1 |
| squadra | ABTG_Dow_Apertura_US | U30USD | M5 | [INCERTO] | — |
| squadra | ABTG_MaxMinNotte_DAX_Short_Ott | D30EUR | M15 | SOLO SHORT (default file) | SCELTO (gemello di #3) |
| squadra | ABTG_SupertrendReversal | 225JPY | H2 | L+S (allineato 08/08) | nessuno |
| squadra (lab) | ABTG_ORB_Ottimizzato | U30USD | M5 | SOLO LONG | SCELTO (gemello di #5) |
| squadra | ABTG_EMA200_Ottimizzato | XAUUSD | H4 | [INCERTO] (preset repo: solo long) | — |
| squadra | ABTG_SupRev_NAS_H1_Ottimizzato | NASUSD | H1 | [INCERTO] (default L+S) | — |
| squadra | ABTG_SuperWave_DOW_H1_Ottimizzato | U30USD | H1 | [INCERTO] (default L+S) | — |
| osservato | ABTG_SupRev_DAX_H4_Ottimizzato | D30EUR | H4 | [INCERTO] | — |
| osservato | ABTG_SupRev_DOW_H4_Ottimizzato | U30USD | H4 | [INCERTO] | — |
| osservato | ABTG_SupertrendReversal_Ottimizzato | XAUUSD | H4 | [INCERTO] | — |
| osservato | ABTG_Nasdaq_Apertura_US (base) | NASUSD | M5 | long+short (flotta_attesa) | nessuno |

---

## 2. I CANDIDATI — le 11 celle dove il lato e' stato SCELTO

**Nessuno richiede di toccare il codice**: tutti hanno l'input, e il lato
speculare e' gia' stato eseguito almeno una volta dal tester (i rami esistono
e girano). L'ordine e' per **costo di prova**, dal piu' economico.

### Gruppo A — lato MAI misurato su quel mercato (2 celle)
Qui non serve nemmeno un dato nuovo: **il banco nativo BCM basta**, perche' il
numero non esiste proprio.

| # | Cella | Lato vivo | Cosa manca | Costo |
|---|---|---|---|---|
| 2 | **Dow Apertura US** | solo long | R6 ha spazzolato solo `AllowShort` **sopra** il long (SOLO LONG vs long+short): **SOLO SHORT mai lanciato** | 1 input, dati gia' in casa |
| 5 | **ORB-EMA200 Dow** | solo long | il "solo long" viene dalla FONTE (tradethatswing, R13) e resta pinnato in R14/R15: sul **Dow** lo short non e' mai stato misurato con questa geometria (lo sweep e' esistito solo sul Nasdaq, R7a/b) | 1 input, dati gia' in casa |

### Gruppo B — lato misurato e perdente NELLA finestra 2024-2026 (9 celle)
Qui il lato esiste come numero, ma il numero viene da **un regime solo**. E'
il perimetro proprio di R52: si rimisura in ORSO / CROLLO / TORO / LATERALE.

| # | Cella | Lato vivo | Numero del lato scartato | Dati per la prova di regime |
|---|---|---|---|---|
| 25 | LARRY GBPUSD | solo short | lati scelti sull'IS (R38) | ✅ **`GBPUSD_EXT` gia' importato** — misurabile subito |
| 27-29 | COST EURJPY / GBPCAD / XAGUSD | solo long | short OOS −1.870 / −3.007 (R40) | ❌ nessun `_EXT` per EURJPY/GBPCAD/XAGUSD |
| 23-24-26 | LARRY ORO / GBPJPY / EURCAD | solo long | GBPJPY: short OOS −1.166 ("il lato E' l'edge") | ❌ nessun `_EXT` |
| 1 | DAX Apertura EU | solo long | SOLO SHORT r35: IS −501,27 / OOS +254,74 PF 1,065 — **ma r45: OOS +715,98 PF 1,212** | ❌ HistData non ha indici -> attesa Pepperstone/import |
| 3 | MaxMin DAX Short | solo short | SOLO LONG: −290,93 PF 0,947 (grid D30EUR, tutti e 4 i combo misurati) | ❌ idem |

**Nota che pesa** (dal referto FASE M, gia' scritta allora): sul DAX gli short
non erano tutti perdenti, erano **nel posto sbagliato** — a range 45 lo short
puro fa PF 1,212 fuori campione. E' l'indizio piu' concreto che il lato spento
non sia morto, ma solo mal collocato.

**Trappola meccanica da ricordare per le aperture (#1, #2, #5):** con
`OneTradePerDay` "entrambi i lati" **non e' la somma** dei due lati — lo short
consuma il posto del long (FASE M: 256 + 243 = 316 trade, non 499). Le tre
varianti della tesi R52 (originale / speculare / entrambi) vanno quindi lette
sapendo che la terza e' un esperimento diverso, non la somma delle prime due.
Il caso "long e poi short nello stesso giorno" e' **R51**, non R52.

---

## 3. GLI EA CHE NON POSSONO CAMBIARE LATO

Due soli, ed entrambi perche' **il lato lo decide il mercato, non un input**.
Per loro il "lato mancante" non esiste come idea: non c'e' niente da riesumare.

**`ABTG_GapFill`** — direzione sempre CONTRO il gap:
```
mql5/Experts/ABTG_GapFill.mq5:424
   bool isLong=(gGap<0.0);                 // gap DOWN -> BUY ; gap UP -> SELL
```
(gia' dichiarato in testata, riga 14: "direzione: SEMPRE CONTRO il gap"). Un
"gap-fill long-only" sarebbe un filtro sul segno del gap, cioe' **una strategia
diversa**, non l'altro lato della stessa.

**`ABTG_BreakingBand`** — direzione dal verso del bulge:
```
mql5/Experts/ABTG_BreakingBand.mq5:924   bool isLong=(gBulgeDir>0);   // CONTINUAZIONE
mql5/Experts/ABTG_BreakingBand.mq5:949   bool isLong=(gBulgeDir<0);   // INVERSIONE (contro-bulge)
```
`InpPatternMode` (0/1/2) sceglie il **pattern**, non il lato: sia CONT sia INV
possono uscire long o short. Nessun `InpAllowLong/Short` esiste nel file.

**Controllo fatto e negativo:** ho cercato in tutti i ~70 `.mq5` un EA che apra
un solo verso per costruzione. Non ce n'e' fra quelli vivi: anche gli EA senza
input di lato (`AltaVelocita`, `PostNews`, `BULGE_MASTER`, `ORB_OpeningRange`,
`BREAKOUT_EA_JPY`) piazzano entrambi i versi con un ternario o una coppia
stop/limit.

---

## 4. QUELLO CHE NON HO POTUTO STABILIRE

1. **Il lato vivo del DAX Apertura sul conto piccolo.** Il magic 770101 ha
   prodotto SELL il 10/08 e il 13/08, ma il referto `report/DAX_14-08_DUE_MOTORI.md`
   attribuisce quei SELL all'**istanza fantasma del PC** (motore BREAKOUT,
   range 15), non al grafico del VPS. Quindi non so se il grafico del piccolo
   sia long+short (braccio di controllo, come raccomandava FASE M) o solo long.
   **Serve:** la riga `CONFIG IN USO` -> `backtest_pipeline/config_in_uso.ps1`.
2. **I lati dei 12 grafici storici di §1c** (EMA200_Ott oro, SupRev NAS/DAX
   H4/DOW H4, STREV_Ott oro, SuperWave DOW H1, Dow Apertura sul piccolo).
   `flotta_attesa.csv` mette `*` e i preset del repo sono vecchi.
   **Serve:** un giro tipo `verifica_vivaio_r23.ps1` esteso a quei grafici, o
   gli screenshot degli input.
3. **Se il lato dei 6 LARRY sia stato scelto SOLO sull'IS o anche guardando
   l'OOS.** R38 dice "cella lati scelta sull'IS" (criterio congelato) e il
   referto riporta anche numeri OOS del lato scartato: leggendo il referto non
   distinguo se quei numeri sono stati visti prima o dopo la scelta.
   **Serve:** i CSV `risultati_prove/ABTG_PunteLarry/notte/` con l'ordine dei
   lanci, oppure la memoria dello script `notte_larry.ps1`.
4. **Disponibilita' di storico esterno per XAUUSD/XAGUSD/GBPJPY/EURCAD/EURJPY/GBPCAD.**
   So che HistData non ha indici (dichiarato in R50); **non so** se copre oro,
   argento e quei cambi. Da questo dipende se il Gruppo B si puo' provare
   adesso o va in coda a Pepperstone. **Serve:** una verifica sulle fonti dati.
5. **Conteggio vivaio: 22 o 23?** `CAMPAGNA_ARSENALE.md` dice "5 titolari + 22
   vivaio + 5 osservazione = 32"; `HANDOFF.md` (14/08) dice "23 in prova + 5 in
   osservazione". La lista dei .chr attesi (`verifica_vivaio_r23.ps1`) contiene
   26 grafici + MAXMIN ORO = 27, che torna con la CAMPAGNA. Differenza di 1
   non risolta; qui ho usato **32 celle**.

---

## 5. I NUMERI CHE DICONO SE IL FILONE VALE UN ROUND

**32 celle vive nominate** (5 sul demo 100k + 27 sul demo piccolo).

| Categoria | Celle | Quota |
|---|---:|---:|
| **Lato SCELTO -> candidato R52** | **11** | 34% |
| VINCOLATO (direzione per costruzione: BB 3 + GAP 5) | 8 | 25% |
| Nessun lato mancante (gia' L+S) | 13 | 41% |
| [INCERTO] fra le 32 | 0 | — |

Dei **11 candidati**:
- **11 su 11** si provano cambiando **un solo input** — zero righe di codice;
- **2** hanno un lato **mai misurato** (Dow Apertura, ORB Dow): si misurano
  **subito, sul banco nativo**, e sono informazione nuova a costo zero;
- **1** ha gia' i dati per la prova di regime (LARRY GBPUSD su `GBPUSD_EXT`);
- **2** sono su indici e restano bloccati finche' non arriva uno storico lungo
  (Pepperstone/import) — cioe' la condizione F della tesi R52;
- **6** sono su cambi/metalli senza `_EXT`: prova di regime possibile solo dopo
  aver risolto il punto 4 di §4.

**Lettura onesta:** un terzo delle celle vive ha un lato spento a mano, e la
maggioranza di quei lati e' stata giudicata **dentro la stessa finestra amica
del long**. Il filone esiste. Ma nella forma "regime" e' **quasi tutto in
attesa di dati**: oggi si puo' toccare palla su **3 celle su 11** (Dow, ORB,
LARRY GBPUSD). Le altre 8 restano in lista finche' non c'e' lo storico.

**Vale sempre la regola madre della tesi R52:** i dati `_EXT` PROPONGONO,
non validano. E nessuna cella cambia lato in forward per effetto di questo
censimento.
