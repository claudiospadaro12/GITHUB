# ⚪ IL PREOPEN NASDAQ DI CLAUDIO — **l'EA NO, il MECCANISMO `[NON ANCORA MISURATO]`**

_Claudio ha caricato `Nasdaq_PreOpen_Breakout_EA.mq5` il 12/09 sera chiedendo
«questo lo abbiamo mai analizzato?». Due agenti in parallelo (codice + imbuto),
poi il **cancello** (regola 09/09) sul verdetto._

> ## 🔴 QUESTA E' LA VERSIONE 2. LA 1 DICEVA **«SCARTATO»** ED ERA SBAGLIATA.
> Il secondo strato del cancello ha rotto **tre** dei pilastri su cui poggiava —
> e ha trovato che al **certificato di morte** mancano **due voci su cinque**.
> **Un morto senza certificato non e' un morto.** La v1 resta nella storia di
> git (`dc0e3aa`); qui sotto i punti caduti sono ~~barrati~~ e sostituiti.

---

## 0. 📌 LE DUE RISPOSTE, SEPARATE — perche' NON sono la stessa domanda

| domanda | risposta |
|---|---|
| **L'EA esterno si schiera?** | 🔴 **NO**, e regge da solo (vedi §6). **Deciso.** |
| **Il MECCANISMO pre-apertura e' morto?** | ⚪ **`[NON ANCORA MISURATO]`**. Costa **3,99 minuti** di macchina saperlo (§8). |

🔴 **La v1 fondeva le due in un "NO" solo.** E' il difetto esatto che il
CERTIFICATO DI MORTE esiste per impedire: archiviare un candidato che non era
morto, per risparmiare quattro minuti a 19 giorni dalla challenge.

---

## 1. 🔎 LA RISPOSTA ALLA DOMANDA DI CLAUDIO: **l'EA no, la FAMIGLIA si'**

`NPO_PREFIX`, `InpEntryBufferPoints`, magic `20260617`: **zero occorrenze** nel repo.
🟡 **Ma la FAMIGLIA ce l'abbiamo**: `mql5/Experts/ABTG_Nasdaq_Live5m.mq5`, magic
**`770203`**, intestazione r.7-12 — verificata alla lettera:
> *"candela TRIGGER = i 5 minuti PRIMA dell'apertura (15:25-15:30 IT), non la
> candela H1 precedente · ordini a **7 punti indice** oltre max/min (buffer 700)
> · FILTRO ampiezza candela: opera solo se e' tra **17** e 40"*

### 🟢 Cosa combacia davvero (verificato riga per riga dal cancello)
| ingrediente | casa `770203` | esterno | esito |
|---|---|---|---|
| ora | `SESSION_HOUR 14:30` **server** | 15:30 **Roma** = 14:30 server | 🟰 stessa candela **in estate** |
| buffer | `BUFFER 700` = 7 idx | `InpEntryBufferPoints=7.0` | 🟰 identico |
| soglia minima | `MINRANGE 1700` = 17 idx | `InpMinCandlePoints=17.0` | 🟰 identico |
| stop | bordo opposto (`InpSLMode=0`) | `buySL=g_preLow` (r.469-470) | 🟰 identico |
| 1 trade/giorno | `InpOneTradePerDay=1` | `InpMaxTradesPerDay=1` | 🟰 identico |
| filtro spread | 🟢 `SpreadOK()` + `InpMaxSpread` | 🔴 **assente** | ❌ esterno peggiore |
| Guardian | 🟢 `ABTG_GuardiaIngresso` | 🔴 **assente** | ❌ esterno peggiore |

### 🔴 ~~«Identici al punto indice»~~ — **FALSO**, e le differenze sono DUE
- **D-A · la finestra di casa e' di SEI barre M1, non cinque.**
  `ABTG_Nasdaq_Live5m.mq5` r.600-625: `iBarShift(..., tEnd=14:30, exact=false)`
  restituisce **la barra che contiene le 14:30**, e `count = |start−end| + 1 = 6`.
  👉 **Il livello di casa ingloba gia' i primi tick della cassa USA**; l'esterno
  legge la M5 **chiusa** 15:25-15:30 Roma e l'apertura **mai**.
  Il livello di casa e' **≥** a quello dell'esterno. **Di quanto: `[NON MISURATO]`**
  (servirebbe il per-trade coi livelli, in archivio non c'e').
- **D-B · l'esterno opera su un SOVRAINSIEME di giornate.** La cella misurata ha
  `MaxRange=4000` (40 idx); l'esterno **non ha tetto**. Lo `0,96265` e' il PF di un
  **sottoinsieme** della popolazione che l'esterno tratterebbe.
  _(Il verso della correzione e' **contro** l'esterno — ma va scritto, non sottinteso.)_

👉 **La frase corretta e': «stessa FAMIGLIA, stesso segnale a meno della barra
d'apertura e del tetto di ampiezza».** Non *"identico"*.

---

## 2. 💀 I NUMERI, LETTI DA ME DAI CSV GREZZI

`backtest_pipeline/risultati_prove/ABTG_Nasdaq_Live5m/`:

| finestra | modello | PF | n (deal) | DD% | Profit |
|---|---|---:|---:|---:|---:|
| IS | tick reali | 1,01621 | 116 | 11,5160 | +98,96 |
| **OOS** | **tick reali** | 🔴 **0,96265** | **175** | 🔴 **19,4006** | 🔴 **−326,54** |
| IS | OHLC M1 | 1,36567 | 125 | 8,0081 | +2.403,74 |
| **OOS** | **OHLC M1** | 🟡 **2,16249** | 198 | 7,3108 | 🟡 **+8.943,56** |

🔴 **DUE ETICHETTE OBBLIGATORIE, aggiunte dal cancello:**
1. **`@ rischio 2%`** — la cella gira a `InpRiskPercent=2`, mentre il riferimento
   di casa (`REGISTRO_TEST.md` r.7) e' **1%**. *"DD 19,40%"* citato **nudo**,
   accanto a cancelli prop scritti per l'1%, vale **circa il doppio** di quel che
   sembra. Si scrive sempre **«DD 19,40% @ rischio 2%»**.
2. **175 sono DEAL, non posizioni** (classe 226): con `InpTP1_ClosePct=50` il
   fattore sta fra 1,0 e 2,0 → **88-175 posizioni**. 🔴 **Potrebbe stare SOTTO 150.**
   Serve il per-trade con `position_id`: **aperto**.

### 🏆 E QUESTO RESTA IL NUMERO PIU' UTILE DELLA GIORNATA, e non riguarda questo EA
**Stessa cella** — il cancello ha confrontato le colonne di input una per una e
l'**unica** differenza e' `InpMagic` (`770204` vs `770203`), **inerte** per la
logica ✅ — **stessa finestra OOS, cambia SOLO il modello:**
- profitto: **+8.943,56** contro **−326,54** → divario **9.270,10 EUR**
- drawdown: **7,31%** contro **19,40%** → peggiora di **x2,65**
- 🔴 **e il SEGNO SI RIBALTA.**
- il salto n 175→198 e' **coerente**: OHLC idealizza l'intrabarra → **piu' TP1
  parziali raggiunti** → +23 deal di uscita. **Stessa cella, modello che regala.**

👉 Questa e' la misura che **quantifica** perche' `Modello 1` e' **solo
screening**. Vale per tutto l'archivio. 🟢 **Questo pilastro il cancello lo ha
CONFERMATO.**

---

## 3. ⚖️ LA CONTRADDIZIONE FRA I DUE AGENTI — ~~«l'ho chiusa»~~ **era chiusa MALE**

| | diceva |
|---|---|
| **agente 1** (codice) | *"allarga `InpPrevWindowMin` a 10/15/20/30: il range cresce e la frontiera del costo migliora"* |
| **agente 2** (imbuto) | *"pre-apertura OOS-negativa a **ogni** larghezza: 5' 0,963 · 60' 0,798 · H1 0,665"* |

### 🔴 ~~«L'agente 2 ha ragione»~~ — **NESSUNO DEI DUE ha ragione: l'asse non e' MAI stato misurato**

- **(a) `RangeMode=2` non e' una finestra piu' larga: e' SPOSTATA** — classe 296.
  `ABTG_Nasdaq_Live5m.mq5` r.578-583 usa `iHigh(_Symbol, PERIOD_H1, 1)`: alle
  **14:30 server** la H1 **chiusa** e' la **13:00-14:00**, che finisce **30 minuti
  PRIMA** dell'apertura. Su un asse "larghezza della finestra pre-apertura"
  **non ci sta**. 👉 **Il punto 0,665 e' ESPULSO dalla curva.**
- **(b) I punti «5'» e «60'» vengono da DUE ROUND con SETTE input diversi:**

  | | 5' | 60' |
  |---|---|---|
  | EA / magic | `770203` | `770201` |
  | buffer | **700** | **500** |
  | MinRange / MaxRange | **1700 / 4000** | **0 / 0** |
  | CloseHour | **20:45** | **17:30** |
  | rischio | **2%** | **1%** |

  **3h15m di detenzione in meno** su un breakout direzionale, **nessun cancello di
  ampiezza**, **meta' del rischio**. Non sono due punti della stessa curva.
  _(E c'e' un'**ottava** differenza possibile, non esclusa: le finestre IS/OOS dei
  due round non sono scritte nei CSV e il file che le fissa non e' stato trovato.)_
- **(c) Le sei passate del CSV sono QUATTRO esiti**: `InpRangeMinutes` e' **inerte**
  per `RangeMode != 0` (r.588-591), e le righe 15 e 35 danno numeri identici al
  quinto decimale.
- **(d) 🟡 E va NOMINATO (classe 180) il `RangeMode=0` che fa 1,02233**:
  ```
  RangeMode=0  RangeMinutes=35  ->  PF OOS 1.02233  n 301  DD  7.8775  (IS 0.92822)
  RangeMode=0  RangeMinutes=15  ->  PF OOS 0.88615  n 311  DD 11.6978  (IS 0.86304)
  ```
  E' il range di **APERTURA** (post, non pre): **meccanismo diverso**, fuori dalla
  frase sulla pre-apertura, e comunque **IS negativo** → non promuove nulla.
  **Ma chi legge "tutto negativo" viene ingannato**, quindi sta scritto.

> ➡️ **PUNTI REALMENTE CONTROLLATI SULL'ASSE DELLA LARGHEZZA: ZERO.**
> La riscrittura onesta: *"le due misure che esistono (5' con un set di input, 60'
> con un altro) sono entrambe sotto 1,10. La differenza **non** e' attribuibile
> alla larghezza. L'asse e' `[NON MISURATO]`."* Piu' debole, e **vera**.

---

## 4. 📐 LA FORMA DEL MOTORE E' UNA TENAGLIA — 🟢 **questo regge**

Il parziale del 50% a +20 (r.661-690 dell'EA caricato) fa si' che la vincita
piena valga **35 punti, non 50**. Spread NASUSD **misurato** all'ora **14 SERVER**
(`SPREAD_VIVO_2026-09-12`: n=3578, GG=5, **mediana 1,800**, P95 1,900):

| range | stop | RR **vero** (35/stop) | win% per PF 1,10 | `stop/spread` |
|---:|---:|---:|---:|---:|
| **17** | 24 | 1,46 | 43,0% | 🔴 **13,3x** (= il pavimento duro, al decimale) |
| 40 | 47 | 0,74 | 59,6% | 26,1x |
| **65** | 72 | 0,49 | 🔴 **69,4%** | ✅ **40,0x** |

🟢 **Aritmetica verificata dal cancello al decimale** (35/24=1,458 · 35/72=0,486 ·
24/1,80=13,33x · 72/1,80=40,0x · le win% ✅). 🔴 **Non esiste un range che passa
il COSTO e il PAYOFF insieme**: e' **algebra sulla forma** (target fisso, stop
variabile). 📌 E il mio RR di ieri sera (2,08/1,56/1,06) era **ottimista**: non
avevo contato il parziale.

### 🧪 ~~«attesa monotona al ribasso»~~ — **e' RUMORE**, classe 298
Su 447 breakout veri (`studio_apertura/Studio_NASUSD.csv`) i quattro quartili si
riproducono al decimale (+0,055 · +0,039 · −0,021 · −0,069) ✅ **ma**:

| misura | valore |
|---|---|
| **Q1 − Q4** | +0,124 R, err.std **0,178** → 🔴 **t = 0,70** |
| Pearson ampiezza~R (n=447) | **−0,036** (t = −0,77) |
| IC 95% dei quartili | **si sovrappongono tutti, scavalcano lo zero** |

Quattro numeri finiscono in ordine perfetto per caso **1 volta su 24**.
🟢 **Il contro-esempio funziona lo stesso, ma SOLO nella forma negativa**: era
stato dichiarato **prima** che *"Q4 ≥ +0,20 R"* sarebbe stato un SI', e l'IC 95%
di Q4 arriva a **+0,158 < +0,20** → **ipotesi alternativa respinta al 95%** ✅.
🔴 Ma *"pendenza monotona"* **non e' un numero che chiude una porta**.

---

## 5. 🟢 COSA E' USCITO A FAVORE — va detto, e' meta' della realta'

- **Frequenza**: **0,82 op/giorno** su un simbolo; con U30USD+SPXUSD la
  **famiglia** supera il pavimento di 1,00. La frequenza **non e' il blocco**.
- 🟢 **Quattro accuse al codice smontate dai contro-esempi**: la chiamata prima
  della definizione **compila**, `InpPointSize=1.0` e' **corretto**, i pesi 70/30
  **non raddoppiano** il rischio, il pattern hedging e' giusto.
- 🟢 **Zero errori di fuso**: lo spread e' letto all'ora **14 SERVER**, che e' la
  candela giusta (il file dichiara a r.14 "ore in ORA SERVER").
- 🟢 **Confini rispettati**: nessun EA toccato, nessun preset, `CODA.txt` intatta,
  nessun backtest girato, nessun saldo di `10105439` / `50504263` scritto.

---

## 6. 🚨 PERCHE' L'EA ESTERNO NON SI SCHIERA — e regge **anche senza** i pilastri caduti

1. 🔴 **`InpLocalUtcOffsetHours = 2` CABLATO** (CEST) + ancoraggio a **Roma**
   invece che alla **borsa**: dal **1 nov 2026 al 14 mar 2027** (~95 sedute) arma
   sulla candela delle **14:25**, un'ora prima, **in silenzio** — cioe' **dentro
   la fase funded**. E metterlo a 1 il 25 ottobre **peggiora** (nelle due settimane
   di sfasamento DST i due errori si compensano).
2. 🔴 **COSTO**: stop minimo **13,33x** lo spread misurato = **il pavimento duro al
   decimale**; al P95 (1,90) scende a **12,63x**, cioe' **sotto**.
3. 🔴 **Doppio fill possibile** con posizione **orfana** non gestita, e
   `g_tradesToday` che ne conta **1**.
4. 🔴 **`InpTimeframe != M5` da' ZERO trade in silenzio** (r.36 e r.834: l'input esiste, e `OnInit` stampa un avviso e **prosegue**).
5. Piu': **nessun filtro di spread, nessun filtro news, nessun Guardian**.

👉 **D1 + il costo bastano da soli.** 🟢 Questa parte del verdetto e' **confermata
dal cancello**: l'EA esterno **non prende un posto nell'imbuto a 19 giorni**.

---

## 7. ⚖️ IL CERTIFICATO DI MORTE — **due voci su cinque sono NO**

_(la v1 non aveva questa sezione: andava da "NO" alla riga di registro. E' il
difetto formale che ha fatto scattare il FAIL.)_

| # | voce | esito verificato |
|---|---|---|
| 1 | **PF** | 🟢 **SI** — 1,01621 IS / **0,96265** OOS, tick reali |
| 2 | **n e DD** | 🟢 **SI** — 116 / 175 **deal** · 11,52% / **19,40% @ rischio 2%** ⚠️ (175 deal = **88-175 posizioni**: potrebbe stare sotto 150) |
| 3 | **uscita ad asse** | 🔴 **NO** — `NASDAQ_{A..M}` girano **tutti** con `RangeMode=0`. **Nessun asse d'uscita e' MAI girato su `RangeMode=1/PrevWin=5`**, cioe' su QUESTO ingresso |
| 4 | **gemelli** | 🟠 **PARZIALE** — `ABTG_DAX_Live5m.mq5` r.32-33 ha `MINRANGE 0`/`MAXRANGE 0`: 🔴 **il cancello 17-40, che e' ingrediente DEFINITORIO, era SPENTO sul gemello**. U30USD/SPXUSD mai provati |
| 5 | **TF cambiato** | 🔴 **NO**, ma ✅ **CORRETTO IL 13/09 — la prima ragione era di un ALTRO EA.** Avevo scritto *"non e' cambiabile: `InpTimeframe != M5` da' zero trade"*: 🔴 **quell'input e' dell'EA ESTERNO** (r.36), e in `ABTG_Nasdaq_Live5m` le occorrenze di `InpTimeframe` sono **ZERO**. La ragione vera e' **piu' forte**: il TF del grafico **non entra nei numeri** — il range nasce da barre **M1**, il trailing da `InpTrailTF`, i filtri sono spenti, e l'**unica** occorrenza di `PERIOD_CURRENT` in tutto il sorgente e' r.296 (l'ATR), il cui ramo e' morto con `InpTrailStartR=0`. 👉 Girare a M15 darebbe **gli STESSI numeri, non zero trade**: cambiare il TF del grafico **non e' una misura**. ✍️ **E la voce 5 si chiude solo toccando il TF che definisce l'INGRESSO** (`InpPrevWindowMin` / `InpLevelTF`) — che e' **FIRMA DI CLAUDIO**. E' una porta da portargli, non una chiusa |

### 🔴 E il ponte che doveva tappare la voce 3 **e' rotto** — classe 297
~~*"l'INTERO asse uscita muove il PF di 0,052"*~~. L'aritmetica citata era giusta
(`NASDAQ_F_gestione_OOS.csv`: 1,02413 − 0,97237 = 0,05176 ✅) **ma quello non e'
l'intero asse**. Nella **stessa cartella, stesso round, stesso `RangeMode=0`**:
```
NASDAQ_I_trailing_OOS.csv  -- varia SOLO InpTrailTF (manopola d'USCITA), 5 passate
  M1 0.85808 | M2 0.93460 | M3 0.74308 | M4 0.75179 | M5 0.78510     span = 0.19152
```
**0,963 + 0,192 = 1,155 > 1,10.** Con **la stessa logica di trasferimento** usata
per costruire la difesa, **la difesa cade**. E il file `I` era **nominato due
paragrafi sopra** nel dossier: non e' introvabile, e' **non usato perche' il numero
piccolo tornava meglio**. 🔴 **Terzo strato**: il **target a punti fissi** non sta
in **nessuno** dei due assi — un limite superiore su A, B, C non dice niente su D.

> # 🪦 IL VERDETTO, VERSIONE 2
> ### 🔴 **L'EA ESTERNO: NO.** Non si schiera. `[SCARTATO]`, e basta D1 + il costo.
> ### ⚪ **IL MECCANISMO `770203`: `[NON ANCORA MISURATO]`.**
> Alla lettera di `CLAUDE.md` mancano le voci **3** e **5**, e la **4** e' parziale.
> **Torna in coda all'imbuto — MAI in campo in automatico.**

---

## 8. 💰 COSA COSTA SAPERLO DAVVERO — `T = 0,6 + 0,077 × passate`

| # | misura | passate | **T** |
|---|---|---:|---:|
| 1 | 🔴 **Asse USCITA su QUESTO ingresso** (`RangeMode=1, PrevWin=5, 1700/4000`) — ✅ **REALIZZATO nella notte del 13/09 come `R142a/b/c`**, e la forma e' cambiata dopo tre passate del cancello: `InpTP1_ClosePct` 0/25/50/75 (4) + `InpTrailTF` M1..M5 (5) + `InpUseTrailing` 0/1 (2) = **11 celle**, × 2 finestre. _(`InpTP1_R` e `InpBreakevenAtTP1` sono usciti dall'asse: sono **inerti** nella cella 0, r.977.)_ | **22** | **3,50 min** |
| 2 | 🔴 **Asse LARGHEZZA controllato**: `InpPrevWindowMin` = 5·10·15·20·30·60 **a parita' di tutto il resto**, × 2 finestre | **12** | **1,52 min** |
| 3 | 🟠 **Gemelli VERI**: D30EUR **col cancello 1700/4000 ACCESO** + U30USD + SPXUSD, × 2 finestre | **6** | **1,06 min** |
| 4 | 🟢 **Range M5 pre-open diretto**: `anatomia_aperture.py --minuti-pre 5` | **0** | ~0,5 min, **zero tester** |
| | **TOTALE in un round unico** | **44** | 🔴 **3,99 minuti** |

🔥 **La misura 2 e' l'unica che scioglie la contraddizione fra i due agenti** —
perche' oggi **nessuno dei due ha ragione**. E il valore **15**, quello che il
piano d'origine **prescrive** (`CACCIA_MOTORE_APERTURE.md` r.112), **sta dentro il
buco**. Costa **1,52 minuti**.

### ✍️ MA LA MISURA 2 VUOLE LA FIRMA DI CLAUDIO **PRIMA**, non dopo
E' ammessa **solo** perche' `InpPrevWindowMin` e' la **definizione del meccanismo**,
non un parametro tarabile. La distinzione dalla pesca su un motore senza edge
(regola 19/08) e' **sottile**: se la si legge come "griglia piu' fitta su un motore
gia' dichiarato senza edge", e' **vietata**. 👉 **Decide Claudio.**

---

## 9. 🔴 LA SEGNALAZIONE SUL REGISTRO — **la v1 aveva sbagliato, DUE VOLTE**

~~*"`REGISTRO_TEST.md` r.35 dice ⏳ in coda per una cosa gia' girata e che vale
0,96"*~~ — **falso**:

1. **r.35 non dice "in coda": dice MORTO.** L'"in coda" sta a **r.22**, riga **A5**.
2. 🔴 **E A5 NON e' la cella misurata.** A5 chiede **direzione ADATTIVA da
   Supertrend D1 + floor**; i CSV hanno `InpUseSupertrend=0`, `InpUseEmaFilter=0`,
   nessun floor, `InpAllowLong=1`/`InpAllowShort=1` **fissi**.
   👉 **Correggere A5 in "gia' girata, vale 0,96" scriverebbe come MISURATA una
   configurazione MAI girata** — cioe' si commetterebbe il difetto che il
   certificato di morte esiste per impedire, **mentre lo si applica**.

✅ **Fatto quindi**: **A5 resta `⏳ in coda`** (lo e' davvero). La riga promossa a
certificato e' **L2** (r.35), che portava solo *"27/27 combo NEGATIVE"* e adesso ha
PF, n, DD e **l'elenco di cosa manca**. Piu' la nuova **A16** per l'EA esterno.

---

## 10. 🚫 NON COPERTO — dichiarato

| cosa | perche' |
|---|---|
| quanto pesa la barra M1 dell'apertura nel livello di casa (D-A) | servirebbe il per-trade coi livelli: in archivio non c'e' |
| se `TimeGMT() == TimeTradeServer()` nel tester BCM (D2) | serve un giro visivo su `50504400` (`C:\MT5_Backtest`) |
| le finestre IS/OOS dei due round di §3 | non scritte nei CSV: **ottava differenza possibile, non esclusa** |
| compilazione dei due EA | nessun MetaEditor in questo ambiente |
| il fattore deal→posizione dei 175 OOS | serve il per-trade con `position_id`: **il campione potrebbe essere sotto 150** |

---

_Cancello: `controlla_riga.py --md` (5 PASS + 1 rilievo classe 225 sano) +
agente `controllo-preventivo` → **FAIL sulla v1**, classi nuove **296 · 297 · 298**
in `backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md` (commit `4c87b4f`).
Questa v2 e' la correzione richiesta dal FAIL._
