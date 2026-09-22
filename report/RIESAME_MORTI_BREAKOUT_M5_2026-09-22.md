# 🪦➡️🔍 RIESAME DEI MORTI — FAMIGLIA **BREAKOUT M5 / LIVE5M** — 22/09/2026

> **Richiesta di Claudio (22/09):** _"VOGLIO RIGUARDARE ED RIANALIZZARE CON TUTTI
> GLI AGENTI TUTTI GLI EA CHE ABBIAMO CONSIDERATI MORTI... DAX LIVE 5 MIN,
> LONDRA ORB..."_
>
> **Direttiva arrivata a lavoro in corso, stesso giorno, testuale:**
> _"INTANTO: DA PROVARE IN + TF MI RACCOMANDO, OGNI STRATEGIA."_

🛑 **SOLA LETTURA.** Nessun round lanciato, nessuna riga consegnata, niente sul
VPS, niente sul forward, nessun preset toccato, nessuna sedia promossa o spenta.
Questo file e' l'unica cosa scritta, piu' il commit.

---

## 🔥 LA RISPOSTA IN QUATTRO RIGHE

> **1.** La frase del 26/07 chiude **sei motori in una riga**. Verificati uno per
> uno: **due di quei sei non hanno MAI avuto un CSV** (`DAX_M3`, `Londra_ORB`) —
> verificato su **tutta la storia di git**, non solo sull'albero di oggi — e i
> loro numeri sono dichiarati **OHLC** dall'`.ini` che li ha girati. **E anche le
> corse a tick che la frase cita (27 + 27 passate) non hanno CSV agli atti.**
>
> **2.** L'**unica griglia a tick reali con CSV** di tutta la famiglia
> (`valid_DAX_Live5m_v2_D30EUR_realtick.csv`, 32 passate) e' **LONG-ONLY**, a
> **cancello d'ampiezza SPENTO**, con **2 manopole su 5 completamente inerti**
> (32 passate → **8 esiti distinti**), e parte dal **2024.01.01** contro un
> pavimento tick misurato al **2024.09.26** → **29,5% della finestra su tick
> fabbricati**.
>
> **3.** 🎯 **E dentro quello stesso CSV c'e' la risposta alla domanda di
> Claudio sui TF, gia' misurata e mai letta: allargare la finestra d'ingresso
> da 5 a 15 minuti ALZA il PF e ABBASSA il DD in QUATTRO coppie su QUATTRO**
> (+0,077 · +0,085 · +0,089 · +0,136 di PF; −5,6 · −7,0 · −9,3 · −11,3 punti di
> DD). **Quattro misure indipendenti nello stesso verso non sono un picco di
> rumore: sono un gradiente.** E **30 e 60 minuti non sono MAI stati provati.**
>
> **4.** 👉 Quindi la frase del 26/07 **e' un verdetto sul TF M5, non sul
> meccanismo** — e il **COSTO** dice perche': lo stop minimo strutturale di
> quelle corse sta fra **1,2× e 8,8× lo spread misurato**, contro i **40×** della
> regola di casa. **Su M5 quel motore non poteva pagare nemmeno se avesse avuto
> ragione.**

😄 **E una buona notizia, perche' va detta**: questo riesame **non trova una
lavagna vuota**. Trova `R142a/b/c` (uscita del Nasdaq Live5m gia' misurata a
tick, 11 celle), trova `R45` (48/48 su Londra a tick, campioni 149-408), trova
il censimento delle manopole inerti del 09/09 che aveva **gia' inchiodato** due
delle manopole di cui parlo qui. **Il lavoro fatto regge. E' la CONCLUSIONE che
va riscritta, non le misure.**

---

## 📐 0. COME HO MISURATO, e cosa ho aperto

| Fonte | Cosa ne ho tratto |
|---|---|
| `backtest_pipeline/risultati_prove/**` · `risultati_archivio/**` | **I CSV grezzi.** Ogni PF/DD/n qui sotto e' letto da un CSV, colonna per colonna |
| `git log --all --pretty=format: --name-only` filtrato sui quattro nomi | **L'elenco COMPLETO dei CSV mai esistiti** per questi motori. Serve a distinguere "cancellato" da "mai esistito" |
| `backtest_pipeline/ini/valid_*.ini` · `ini/ABTG_*.ini` (tutti committati il **26/07/2026**, commit `a86089c8`, mai piu' toccati) | **Il `Model=` di ogni corsa** (1 = OHLC, 4 = tick), la **finestra**, e **quali manopole erano davvero sull'asse** |
| `mql5/Experts/*.mq5` | Se una manopola sull'asse era **letta** dal codice (due non lo erano) |
| `risultati_archivio/misura_tick/REFERTO_MISURA_TICK_*.txt` | Pavimento tick BCM: **D30EUR 2024.09.26** · **NASUSD 2024.09.26** · **U30USD 2024.09.26** · **GBPUSD 2024.07.05** (classe 590) |
| `risultati_archivio/spread_flotta/spread_orario_*.csv` | Spread **misurati per ORA SERVER**, non a memoria |
| `report/MANOPOLE_INERTI_2026-09-09.md` · `report/AUDIT_USCITE_2026-09-09.md` | Conferma indipendente delle manopole inerti e della Tabella B |
| `backtest_pipeline/walkforward_generico.ps1` r.934 | Il taglio IS/OOS vero: `FrazioneIS 0,40`, `Fino 2026.06.30` |

**Spread misurati che uso qui sotto** (`spread_flotta`, tick veri, `solo_bid 0,000%`):

| Simbolo | ora server | mediana | P95 | frontiera `40 × spread` |
|---|---|---:|---:|---:|
| **D30EUR** | 8 (apertura DAX) | **1,70 idx** | 2,70 | **68,0 idx** (P95: 108,0) |
| **NASUSD** | 14 (pre-apertura US) | **1,80 idx** | 2,70 | **72,0 idx** (P95: 108,0) |
| **GBPUSD** | — (lettura UNICA, non oraria) | **0,2 pip** | `[NON MISURATO]` | **8,0 pip** |

**Costo macchina** — due calibrazioni misurate in casa, le uso come banda:
- `report/PREOPEN_NASDAQ_IL_VERDETTO_2026-09-12.md` §8: **22 passate = 3,50 min** · 44 = 3,99 min (NASUSD **M5 tick**, stessa finestra) → grosso costo fisso d'avvio (~3 min) + **~0,022 min/passata**;
- `r88_csv/REFERTO_R88.txt`: **96 passate = 8,0 min** → **0,083 min/passata**;
- 🆕 **misura del 21/09 sul PC di backtest** (indici, Modello 4, finestra 2024.09.26-2026.06.30, **8 passate M5**): **2 min 41 s – 11 min 57 s** → **0,34 – 1,50 min/passata**.
👉 **Uso la banda del 21/09** perche' e' la piu' recente, la piu' conservativa e
la piu' vicina alla macchina vera. **Salendo di TF il costo SCENDE** (meno barre
da caricare, stesso numero di tick): i costi M15/M30/H1 qui sotto sono **tetti**.

---

## 🧨 1. LA TABELLA MADRE

_Legenda dei cinque punti del certificato: **1** PF misurato · **2** n e DD ·
**3** gestione dell'uscita ad asse · **4** simboli gemelli · **5** TF cambiato._
🔴 **Il punto 5 e' scritto con i TF PROVATI PER NOME**, come chiesto il 22/09.

| # | Motore | Sym | TF girati (per nome) | **MODELLO** | Finestra | Rischio | PF IS | PF OOS | n | DD | 1 | 2 | 3 | 4 | 5 | **VERDETTO** |
|---|---|---|---|---|---|---|---|---|---|---|:-:|:-:|:-:|:-:|:-:|---|
| **L1** | `ABTG_DAX_Live5m` | D30EUR | **solo M5** (chart) · finestra ingresso **solo 5 min** | 🟡 **tick** | 2024.09.26→2026.06.30 | **2,00%** | **0,93488** | **0,85701** | 225 / **342 deal** | IS 26,07% · **OOS 39,74%** | ✅ | ✅ | ❌ | ❌ | ❌ | ⚪ **NON ANCORA MISURATO** — 🔴 ma **la cella che HA il CSV e' BOCCIATA SUL RISCHIO** |
| L1-bis | *(le "27/27 combo NEGATIVE" del 26/07)* | D30EUR | solo M5 | 🔴 **tick, ma 29,5% della finestra FUORI dai tick** | **2024.01.01**→2026.06.30 | `[NON MISURATO]` | `[NESSUN CSV]` | `[NESSUN CSV]` | `[NESSUN CSV]` | `[NESSUN CSV]` | ❌ | ❌ | 🟠 | ❌ | ❌ | 🔴 **NUMERO NON VERIFICABILE** — nessun CSV e' mai esistito nel repo |
| **L2** | `ABTG_Nasdaq_Live5m` `770203` | NASUSD | **solo M5** · finestra ingresso **solo 5 min** | 🟡 **tick** | idem | **2,00%** | 1,01621 | **0,96265** | 116 / **175 deal** | IS 11,52% · **OOS 19,40%** | ✅ | ✅ | ✅ **R142** | 🟠 | ❌ | ⚪ **NON ANCORA MISURATO** (confermato 12/09) — 🔴 **ma l'uscita ora E' misurata e il numero e' BRUTTO** |
| **L3** | `ABTG_DAX_Live5m_v2` | D30EUR | **solo M5** · finestra ingresso **5 e 15 min** ⬅️ *l'unico TF mai mosso in tutta la famiglia* | 🟡 **tick** (ma vedi sotto) | **2024.01.01**→2026.06.30, finestra UNICA | **1,00%** | — | **best 1,04296** · resto 0,846-0,965 | **239 deal** (best) · fino a 501 | **best 9,10%** · resto 11,9-26,1% | ✅ | ✅ | ❌ | ❌ | 🟠 | ⚪ **NON ANCORA MISURATO** — 🔥 **e qui c'e' il gradiente sul TF** |
| **O2** | `ABTG_ORB_Fibo` | NASUSD | **solo M5** (`InpExecTF` mai mosso) · OR **solo 30 min** | 🔴 **OHLC** | 2024.09.26→2026.06.30 | 1,00% *(nominale)* | 0,83507 | **0,96816** | 91 / **75** | IS 3,02% · **OOS 3,10%** ⚠️ | 🟠 | 🟠 | ❌ | ❌ | ❌ | 🟠 **NON ANCORA MISURATO** (confermato 10/09) |
| **O3** | `ABTG_DAX_M3` | D30EUR | **solo M3** (trigger) + **solo H4** (bias) — 🔴 **mai M5!** | 🔴 **OHLC** (`Model=1` nell'ini) | **2024.01.01**→2026.06.30 | `[NON MISURATO]` | `[NESSUN CSV]` | `[NESSUN CSV]` | `[NESSUN CSV]` | `[NESSUN CSV]` | ❌ | ❌ | ❌ | ❌ | ❌ | ⚪ **NON ANCORA MISURATO — 0 PUNTI SU 5** |
| **O4** | `ABTG_Londra_ORB` | GBPUSD | **solo M5** · canale **solo 06:00-07:00** (= **un'ora PRIMA** dell'apertura) | 🔴 **OHLC** (`Model=1` nell'ini) | **2024.01.01**→2026.06.30 | `[NON MISURATO]` | `[NESSUN CSV]` | `[NESSUN CSV]` | `[NESSUN CSV]` | `[NESSUN CSV]` | ❌ | ❌ | ❌ | ❌ | ❌ | ⚪ **NON ANCORA MISURATO — 0 PUNTI SU 5** |
| *(A4)* | *aperture Nasdaq* — **fuori perimetro**, altro agente | NASUSD | M5 | tick | — | — | — | **0,82-0,91** | — | — | ✅ | ✅ | 🟠 | ✅ | ❌ | 🔴 **l'UNICO dei sei con un certificato quasi pieno**: WF **19/20 celle OOS negative**, sedia `770201` spenta il 18/08 |

⚠️ **Classe 550 applicata**: in L1/L2/L3 la parziale e' ACCESA
(`InpTP1_ClosePct=50` in ogni passata) → **`Trades` conta le USCITE, non le
posizioni**. L1 OOS `n=342` = **171-342 posizioni**; L2 OOS `n=175` = **88-175**;
L3 best `n=239` = **120-239**.
⚠️ **Classe 547 applicata**: il rischio e' scritto accanto a ogni numero. **L1 e
L2 girano al 2,00% — la taglia FTMO — quindi i loro DD si confrontano DIRETTO col
muro del 10%. L3 gira all'1,00%**: il suo DD va **raddoppiato** (fattore
1,956-1,990) prima del confronto.

---

## 🔬 2. MOTORE PER MOTORE — cosa manca, la via piu' corta, il costo

### 2.1 · L1 `ABTG_DAX_Live5m` (D30EUR) — *"27/27 combo NEGATIVE"*

**🔴 IL FATTO CHE CAMBIA TUTTO: quelle 27 passate non hanno un CSV, e non e'
che sia andato perso.** `git log --all --pretty=format: --name-only` su tutta la
storia del repo restituisce **21 CSV** per i quattro motori, e **nessuno** di
essi e' la griglia a 27 celle. Non e' stato cancellato: **non e' mai stato
committato**.

**Quello che l'`.ini` agli atti dice** (`ini/valid_DAX_Live5m.ini`, 26/07/2026):
```
Model=4              <- tick reali
FromDate=2024.01.01  <- 🔴 i tick BCM su D30EUR partono dal 2024.09.26
InpAllowLong  = 1||1||0||1||N   <- PINNATO
InpAllowShort = 1||1||0||1||N   <- PINNATO   => i due lati MAI separati (regola 25/08)
InpUseSupertrend = 0||0||0||0||N <- 🔴 PINNATO A ZERO
InpRangeMinutes   = 5||5||10||25||Y   -> 5, 15, 25
InpBufferPoints   = 100||100||100||300||Y -> 100, 200, 300 punti = 1, 2, 3 punti indice
InpTrailFixedPts  = 200||200||200||600||Y -> 200, 400, 600
```
→ 3 × 3 × 3 = **27**. Combacia con la frase. **Ed e' proprio l'`.ini` a
demolirla:**

1. 🔴 **29,5% della finestra e' fuori dai tick.** 2024.01.01→2024.09.25 = **269
   giorni su 911**. Il driver di casa lo scrive nella propria intestazione
   (`walkforward_generico.ps1` r.39-40): _"Sugli indici il driver diceva
   2024.01.01 e i dati partivano dal 26/09/2024: meta' finestra IS non
   esisteva."_ **Il difetto e' documentato in casa: e' quello.**
   ⚠️ *Contro-esempio che mi sono costruito*: e se a luglio 2026 il broker avesse
   avuto **piu'** storico, poi perso? Il referto misura **la stessa identica data
   (2024.09.26) su tre simboli diversi** e la fa coincidere col muro delle barre
   M1: un pavimento **fisso del feed**, non una finestra che rotola. Resta un
   `[NON VERIFICABILE]` formale — ma nella direzione che **peggiora** il numero
   del 26/07, non che lo salva.
2. 🔴 **Il Supertrend era pinnato a ZERO** — e sul gemello v2, **misurato a tick
   con CSV**, il Supertrend e' **l'unica manopola che ribalta il segno**
   (0,92241 → 1,04296). La griglia del 26/07 ha spento apposta l'interruttore
   che decide.
3. 🔴 **I due lati sempre insieme.** La regola del 25/08 (long **E** short,
   separati) e' del **25/08**: quella corsa e' del 26/07 e non poteva
   rispettarla. Ma il verdetto **oggi** viene letto come se la rispettasse.
4. 🔴 **IL COSTO, ed e' il colpo che chiude il discorso.** Lo stop di questo
   motore e' `range + 2 × buffer` (SL al livello pendente opposto,
   `InpSLMode=0 / RANGE`). Col buffer spazzolato a **100-300 punti = 1-3 punti
   indice**, il **pavimento strutturale** dello stop e' **2-6 punti indice**,
   cioe' **1,2× – 3,5× lo spread mediano D30EUR delle 8:00 (1,70)** e **0,7× –
   2,2× il P95 (2,70)**. La regola di casa chiede **40×**, cioe' **68 punti
   indice**.
   👉 **Quella griglia ha misurato il pedaggio, non l'edge.** Un motore che paga
   il 30-80% dello stop in spread non puo' essere positivo, e il fatto che non lo
   fosse **non dice niente sul meccanismo**.
   ⚠️ *Onesta*: 2-6 idx e' il **limite inferiore** (range → 0). La
   **distribuzione vera di `range`** su D30EUR e' `[NON MISURATO]` — ed e' esattamente
   la sonda che propongo al §4.

**Quello che HA un CSV** (asse tecnico a 2 celle gemelle sul magic 770103/770104,
10/08, finestra corretta 2024.09.26→2026.06.30, **rischio 2,00%**, cancello
d'ampiezza SPENTO, Supertrend OFF, entrambi i lati):

| Modello | IS PF | IS n | IS DD | OOS PF | OOS n | **OOS DD** |
|---|---:|---:|---:|---:|---:|---:|
| 🔴 **OHLC** | 1,27364 | 228 | 18,77% | **1,46853** | 352 | 11,83% |
| 🟡 **tick** | 0,93488 | 225 | 26,07% | **0,85701** | 342 | **39,74%** |

🔴 **Fattore OHLC/tick = 1,71 sul PF OOS.** E' la conferma diretta della nota
r.39 del registro (_"in OHLC i Live5m davano numeri finti enormi"_): **su questo
motore l'OHLC mente di 71 punti percentuali di PF.**
🔴 **E il DD OOS 39,74% a rischio 2,00% e' un NUMERO BRUTTO, non un numero
mancante**: l'Emendamento B dice che **il rischio si legge a qualunque n**. →
**Quella configurazione e' MORTA, e con certificato.** Il motore no.

**COSA MANCA (voci 3, 4, 5):** uscita mai ad asse (il blocco e' pinnato in blocco:
`TP1_R 1 · ClosePct 50 · BE 1 · Trailing ON · TrailMode 1 · TrailTF M1 ·
AtrMult 2 · FixedPts 410`) · **zero gemelli** (solo D30EUR; U30USD e SPXUSD mai) ·
**TF: solo M5, finestra d'ingresso solo 5 minuti**.

---

### 2.2 · L2 `ABTG_Nasdaq_Live5m` `770203` (NASUSD) — gia' ⚪ dal 12/09

Le 27 passate del 26/07 hanno **lo stesso identico impianto** (stesso `.ini`
gemello: `Model=4`, `FromDate=2024.01.01`, due lati pinnati insieme,
`InpUseSupertrend` pinnato a 0, griglia `RangeMinutes {10,25,40} × Buffer
{100,200,300} × TrailFixedPts {200,400,600}`) e **lo stesso identico problema:
nessun CSV mai committato**.

🟢 **MA la via piu' corta e' stata percorsa, ed e' agli atti.** Le tre righe
**R142a/b/c** hanno girato nella notte del **13/09**, a **tick reali**, stessa
finestra, **rischio 2,00%**. I sei CSV sono su disco in
`risultati_prove/dal_vps/ABTG_Nasdaq_Live5m/`. **Li ho letti io, riga per riga:**

| Asse | cella | **PF OOS** | **DD OOS** | n OOS | PF IS | DD IS |
|---|---|---:|---:|---:|---:|---:|
| **R142a** parziale `InpTP1_ClosePct` | 0 | 0,96409 | 24,28% | 131 | 1,05441 | 15,55% |
| | 25 | 0,97001 | 23,43% | 175 | 1,04495 | 12,91% |
| | **50** *(default)* | 0,95624 | 22,47% | 175 | 1,01472 | 12,28% |
| | 75 | 0,94458 | 21,52% | 175 | 0,98776 | 12,25% |
| **R142b** TF del trailing `InpTrailTF` | M1 | 0,95624 | 22,47% | 175 | 1,01472 | 12,28% |
| | **M2** | **1,07031** | **17,62%** | 185 | 1,23757 | 15,45% |
| | M3 | 1,00971 | 25,78% | 188 | 1,26238 | 15,50% |
| | M4 | 1,00096 | 27,88% | 190 | 1,21401 | 15,57% |
| | M5 | 1,04705 | 27,07% | 194 | 1,23143 | 15,32% |
| **R142c** trailing on/off | ON | 0,95624 | 22,47% | 175 | 1,01472 | 12,28% |
| | OFF | 0,99949 | **33,62%** | 195 | 1,32199 | 12,95% |

**LA LETTURA CON LA REGOLA DI CASA — centro dell'altopiano, MAI il picco:**
- La cella M2 e' **il picco**: le vicine fanno 0,956 (M1) e 1,010 (M3), e il DD
  **salta da 17,62% a 25,78% con un solo passo**. 🔴 **Una cella che sporge e le
  vicine no: non c'e' altopiano.**
- **Centro** sulle quattro celle sopra 1 (M2..M5): **PF ≈ 1,032** — **sotto il
  cancello 1,10**.
- 🔴 **E il RISCHIO chiude la partita**: **ogni singola cella OOS** ha
  **DD ≥ 17,62% a rischio 2,00%**, cioe' la taglia FTMO. Il muro e' **10%**.
  Anche la migliore lo sfonda di **1,76 volte**.
- 🟢 Un fatto che vale comunque: **spegnere il trailing alza il PF e PEGGIORA il
  DD** (22,47% → 33,62%). Il trailing un lavoro lo fa.

**COSA MANCA ANCORA:** voce **4** (gemelli U30USD/SPXUSD mai provati — il gemello
DAX col cancello acceso esiste ma a rischio 1% e con altri confondimenti) e voce
**5** (il TF dell'INGRESSO — vedi §3, e' **firma di Claudio**).
**`R150a`** (`InpTrailStartR`) e' **armata ma SOSPESA il 21/09** (`coda/CODA.txt`
r.1522: _"[SOSPESO 21/09 — CHALLENGE VIVA]"_) 👉 **la via piu' corta e' bloccata
da una decisione, non da una mancanza di conoscenza.**

---

### 2.3 · L3 `ABTG_DAX_Live5m_v2` (D30EUR) — 🔥 **QUI C'E' LA SCOPERTA**

**Questo e' l'unico dei sei che ha una griglia a tick con CSV**:
`risultati_archivio/Live5m/valid_DAX_Live5m_v2_D30EUR_realtick.csv`, **32
passate**, committato il **26/07/2026** con lo stesso commit degli `.ini`.

**🔴 Il CSV dice QUATTRO cose che la riga L3 del registro NON dice:**

| # | Cosa dice il registro | Cosa dice il CSV |
|---|---|---|
| a | *"+range filter (32 combo)"* | 🔴 **`InpMinRangePts=0` e `InpMaxRangePts=0` in TUTTE e 32.** Il filtro d'ampiezza **non c'era**. La riga descrive una griglia che non e' quella girata |
| b | *(niente sui lati)* | 🔴 **`InpAllowShort=0` in TUTTE e 32.** E' un round **LONG-ONLY**. **Lo short di questo motore non e' mai stato misurato** |
| c | *"32 combo"* | 🔴 **32 passate → 8 esiti distinti.** `InpMinStopPts` **e** `InpSkipIfTight` sono **totalmente inerti** (16 gruppi ciascuna). Gia' misurato il 09/09 (`MANOPOLE_INERTI_2026-09-09.md` r.105-106, 208) |
| d | *"real tick"* | 🔴 Vero, **ma la finestra parte dal 2024.01.01**: **29,5% su tick fabbricati** |

**Perche' quelle due manopole sono inerti — dal SORGENTE, non per ipotesi**
(`ABTG_DAX_Live5m_v2.mq5:678` long, `:702` short):
```
if(InpMinStopPts > 0 && dist < InpMinStopPts*_Point) { if(InpSkipIfTight) skip=true; else sl = entry - InpMinStopPts*_Point; }
```
Il pavimento scatta **solo se lo stop e' piu' stretto di `InpMinStopPts`**. La
griglia l'ha provato a **200 e 400 punti = 2 e 4 punti indice**. 🔴 **La
frontiera del costo di casa ne chiede 68.** 👉 **Il pavimento dello stop — che e'
un parametro di RISCHIO e un filtro di COSTO — e' stato provato 17-34 volte sotto
il valore che la regola di casa impone.** `InpSkipIfTight` non e' nemmeno stato
guardato, perche' vive dentro quel `if`.

**🔥 IL GRADIENTE SUL TF — gli 8 esiti veri, letti dal CSV**
_(finestra UNICA 2024.01.01→2026.06.30 · rischio **1,00%** · long-only · cancello
spento · uscita interamente pinnata)_

| finestra d'ingresso | Supertrend | buffer | **PF** | **DD %** | n (deal) | Profit |
|---|---|---:|---:|---:|---:|---:|
| **15 min** | **ON** | 700 | **1,04296** | **9,10%** | 239 | +192,33 |
| **15 min** | **ON** | 500 | **1,04062** | 11,92% | 249 | +210,83 |
| **15 min** | OFF | 500 | 0,96493 | 14,79% | 463 | −331,61 |
| 5 min | ON | 500 | 0,95138 | 17,55% | 264 | −351,77 |
| **15 min** | OFF | 700 | 0,92241 | 16,82% | 445 | −658,02 |
| 5 min | ON | 700 | 0,90663 | 16,11% | 258 | −613,24 |
| 5 min | OFF | 500 | 0,87966 | 26,05% | 501 | −1.518,26 |
| 5 min | OFF | 700 | 0,84571 | 26,08% | 492 | −1.818,62 |

**LE QUATTRO COPPIE, a parita' di TUTTO il resto — 5 min → 15 min:**

| coppia (ST, buffer) | PF 5' | PF 15' | **Δ PF** | DD 5' | DD 15' | **Δ DD** |
|---|---:|---:|---:|---:|---:|---:|
| OFF, 500 | 0,87966 | 0,96493 | **+0,085** | 26,05% | 14,79% | **−11,26** |
| OFF, 700 | 0,84571 | 0,92241 | **+0,077** | 26,08% | 16,82% | **−9,26** |
| ON, 500 | 0,95138 | 1,04062 | **+0,089** | 17,55% | 11,92% | **−5,63** |
| ON, 700 | 0,90663 | 1,04296 | **+0,136** | 16,11% | 9,10% | **−7,01** |

> 🎯 **QUATTRO COPPIE SU QUATTRO. PF sempre su, DD sempre giu'. Nessuna
> eccezione.** Questo **non** e' il "picco isolato" che la regola di casa vieta
> di inseguire: e' un **gradiente monotono su due rami indipendenti** (Supertrend
> acceso e spento), replicato su due buffer. **E' il tipo di segnale che in casa
> si chiama altopiano, non picco.**

**E il COSTO spiega PERCHE', senza bisogno di una storia:** lo stop e'
`range + 2×buffer + slippage`. Allargare la finestra da 5 a 15 minuti **allarga
il range**, quindi allarga lo stop, quindi **migliora il rapporto stop/spread**.

| configurazione | stop MINIMO strutturale | vs spread mediano 1,70 | vs P95 2,70 |
|---|---:|---:|---:|
| L3 buffer 500 + slippage 100 | **11 punti indice** | **6,5×** | 4,1× |
| L3 buffer 700 + slippage 100 | **15 punti indice** | **8,8×** | 5,6× |
| **frontiera di casa** | **68 punti indice** | **40×** | — |

👉 **Il motore sta fra 4 e 6 volte sotto la frontiera del costo.** Allargare la
finestra e' **l'unica leva che lo muove nel verso giusto** — ed e' l'unica che e'
stata mossa, **una volta sola, di un passo solo, e ha funzionato tutte e quattro
le volte.**

**🔴 E ADESSO IL PUNTO CHE RIBALTA IL NOME DEL CAPITOLO.** La cella migliore di
tutta la famiglia ha `InpPrevWindowMin = 15` e `InpUseSupertrend = 1`:
👉 **non e' "Live 5 minuti", e' un canale di 15 minuti con un filtro di trend
sopra.** Il **breakout M5 puro** (`PrevWin 5`, Supertrend OFF) fa **0,846-0,880
con DD 26,05-26,08% a rischio 1%** — cioe' **50,9-51,9% a rischio 2%**. 🔴 **QUEL
motore li' e' MORTO, e col numero.** Ma **non e' il motore che la cella migliore
descrive.**

**Il DD della cella migliore, riportato alla taglia FTMO:** 9,097% @ 1,00% →
**17,8-18,1% @ 2,00%** (fattore 1,956-1,990). 🔴 **Sfonda il muro del 10%.**
Alla taglia FTMO **questa cella non si schiera**, nemmeno se il PF salisse.

---

### 2.4 · O2 `ABTG_ORB_Fibo` (NASUSD) — gia' 🟠 dal 10/09

Confermo quanto scritto il 10/09, **e aggiungo tre cose che cambiano la lettura**.

**🔴 Prima: non e' un breakout.** `ABTG_ORB_Fibo.mq5` r.219-220: la rottura
dell'Opening Range serve **solo a fissare la direzione**; l'ingresso e' un
**LIMIT nella Golden Zone 50%-61,8%** del ritracciamento, con **stop oltre il
78,6%** (invalidazione). 👉 **E' un RETEST**, cioe' esattamente la geometria che
in casa **PAGA** — lo scrive `REFERTO_ROUND45_LONDRA.md`: _"il breakout
d'apertura non paga MAI al tocco/alla conferma semplice... **Paga solo con
RETEST** (titolari DAX/Dow) o filtrato EMA200 con gestione (sedia 5)."_
🔴 **Metterlo nella frase "il breakout in apertura su M5 non ha edge" e' un
errore di categoria.**

**🔴 Seconda: il suo unico numero e' OHLC, e l'OHLC su questa famiglia mente di
71 punti di PF** (misurato su L1, §2.1). `ini/ABTG_ORB_Fibo.ini` dice
`Model=1`. I due CSV in `risultati_prove/ABTG_ORB_Fibo/` sono **2 passate, 1
esito distinto**, asse = `InpMagic` 770602/770603: **un asse tecnico, non una
griglia.** 👉 **Su questo motore non esiste UNA SOLA passata a tick reali.**

**⚠️ Terza, e va detta prima di citare ancora "il DD piu' basso della tabella":
il 3,10% e' a rischio REALIZZATO ignoto.** `LotByRisk` (r.414-419) fa
`lot = MathFloor(lot/step)*step` e poi `MathMax(volume_min, ...)`. Su un indice
con **passo lotto 0,10** (misurato in casa piu' volte) il rischio effettivo e'
**quantizzato**: puo' essere molto **sotto** l'1% dichiarato (arrotondamento in
giu') o **sopra** (pavimento al minimo). 🔴 **Il rapporto DD/rischio-vero e'
`[NON MISURATO]`.** Il PF non ne risente; **il DD si'**.

**COSA MANCA:** voce 1-2 (il PF/n/DD esistono ma sono **OHLC** → per un
certificato di morte **non contano**) · voce 3 (`InpExitOnEmaClose`,
`InpUseTrailEMA`, `InpTP1Pct` mai ad asse — e `prove/R15_ORB_gestione_DD.txt`
scrive nero su bianco _"niente ExitOnEmaClose in questo giro... e' il candidato
del giro successivo"_ 👉 **quel giro non c'e' mai stato**, Tabella B
dell'`AUDIT_USCITE`) · voce 4 (solo NASUSD) · voce 5 (**`InpExecTF` e' un
`ENUM_TIMEFRAMES` vero e non e' mai stato mosso da `PERIOD_M5`; `InpORMinutes`
mai mosso da 30**).

---

### 2.5 · O3 `ABTG_DAX_M3` (D30EUR) — **0 punti su 5, il piu' scoperto dei sei**

**🔴 Zero CSV. Mai esistito nel repo, in tutta la storia di git.** Il numero
*"OHLC 33% pos, short 0%"* **non e' verificabile**: non c'e' la colonna MODELLO
accanto al PF perche' **non c'e' la colonna PF**. L'unico atto e'
`ini/ABTG_DAX_M3.ini`, committato il 26/07/2026, che dichiara **`Model=1` = OHLC
1 minuto**. 👉 **Una bocciatura che poggia su OHLC non e' una bocciatura.**

**🔴 E dentro quell'`.ini` c'e' una manopola INERTE PER COSTRUZIONE, dimostrata
dal sorgente:**
```
ini:  InpSLFixedPts = 800||800||300||2500||Y     -> 6 valori: 800,1100,1400,1700,2000,2300
mq5:  input ENUM_M3_SL InpSLMode = M3SL_SUPERTREND;          (r.67, MAI messo sull'asse)
      r.270:  if(InpSLMode==M3SL_SUPERTREND) sl = isLong ? stLine-buf : stLine+buf;
      r.271:  else if(InpSLMode==M3SL_FIXED) sl = ... InpSLFixedPts ...
```
👉 **`InpSLFixedPts` e' letto SOLO in modalita' FIXED. La griglia l'ha spazzolato
su 6 valori tenendo `InpSLMode` su SUPERTREND: sei passate identiche, ogni volta.**

**Il conto della griglia** *(derivato dall'`.ini` + dal sorgente; il CSV che lo
confermerebbe non esiste, quindi lo marco così)*:

| | |
|---|---:|
| passate nominali (7 StMult × 6 SLFixedPts × 6 TPPoints × 2 × 2) | **1.008** |
| `InpSLFixedPts` inerte → esiti distinti | **≤ 168** |
| di cui `AllowLong=0 & AllowShort=0` = **zero operazioni** | **42** |
| **ricerca effettiva** | **126 celle** `[DERIVATO]` |

🔴 **E "short 0%" e' 0 su 42 celle distinte, non su 252 passate** — e tutte e 42
con lo stesso identico stop (linea Supertrend M3), la stessa uscita
(`InpTrailOnST=true`, `InpExitOnFlip=true`, entrambi **al default e mai ad
asse**) e lo stesso identico TF.

**🔴 E NON E' UN BREAKOUT M5. E' un errore di categoria DOPPIO:**
- **TF sbagliato**: gira su **M3**, non M5 (`Period=M3` nell'`.ini`,
  `InpTriggerTF=PERIOD_M3`);
- **meccanismo sbagliato**: `InpBiasTF=PERIOD_H4` con **Supertrend + EMA200 +
  ADX ≥ 25**, `InpEntryMode` = rottura **oppure continuazione su
  ritracciamento**, finestra 08:30-17:00 server. 👉 E' **trend-following
  filtrato della famiglia Supertrend** — la stessa famiglia che in casa e'
  **VIVA e validata a tick**: `S1v` DAX H1 **PF 1,45 DD 5,6% n 223** · `S4v` DAX
  H4 **PF 1,96 DD 5,7%** · `S5v` NAS H1 **PF 1,57 DD 1,17%**.

**Voce 5 del certificato, netta:** `InpBiasTF` e `InpTriggerTF` sono
`ENUM_TIMEFRAMES` **veri e modificabili**, e **non sono mai stati mossi**. Il
motore e' stato girato **su un TF solo (M3 trigger / H4 bias)** — e per di piu'
**il TF piu' basso e piu' caro della scala**, quello che la nota di `CLAUDE.md`
esclude apertamente (_"la banda buona sugli indici e' M30/H1"_).

**Voce 3, netta:** `InpTrailOnST` e `InpExitOnFlip` sono **le righe 8 e 15 della
Tabella B** dell'`AUDIT_USCITE_2026-09-09.md` — **zero occorrenze come asse in
tutto il repo**, su **15 e 14 EA** rispettivamente. E il fenomeno registrato tre
volte in pagella (_"2,19 R disponibili, 0% catturato"_) punta **esattamente li'**.

---

### 2.6 · O4 `ABTG_Londra_ORB` (GBPUSD) — **ha misurato l'ORA SBAGLIATA**

**🔴 Zero CSV. Mai esistito.** `ini/ABTG_Londra_ORB.ini` (26/07/2026):
`Model=1` → **OHLC**. Il *"DD 23%"* e' **a rischio ignoto** (`InpRiskPercent` non
compare nell'`.ini`; il default del sorgente e' 1,0, ma senza CSV **non e'
verificabile**) → **classe 547 non soddisfatta**.

**🔴 IL DIFETTO STRUTTURALE, e vale piu' del numero mancante.**
Gli input (`ABTG_Londra_ORB.mq5` r.36-45): `InpRangeStartHour=6`,
`InpRangeEndHour=7`, `InpPlaceHour=7` — canale **06:00-07:00 server**, ingresso
alle **07:00 server**.
E il **03/09** e' stato **MISURATO** (Passo 0 di `ABTG_AllineaLondra`,
`risultati_archivio/allinealondra/REFERTO_PASSO0_2026-09-03_1651.txt`) che
_"l'orologio del server BCM segna la STESSA ora di Londra tutto l'anno"_ →
**Londra apre alle 08:00 ORA SERVER**.
👉 **Quella griglia ha costruito il canale e ha piazzato gli ordini UN'ORA PRIMA
dell'apertura di Londra.** Il registro lo dice gia' a r.1141 — ma poi la riga O4
resta "🔴 morto".
🔴 **E le tre ore non sono MAI state su un asse**: l'`.ini` spazzola solo
`InpBufferPips` (8 valori), `InpTPRangeMult` (7) e i due lati. **224 passate, e
nemmeno una tocca l'orologio.**

**🔴 E tutta la gestione dell'uscita e' SPENTA per default e mai ad asse:**
`InpUsePartial=false` · `InpBreakeven=false` · `InpUseTrailing=false` ·
`InpSLMode` MIDPOINT/OPPOSITE mai provati · `InpHalveOnOpposite` = **una riga
dedicata della Tabella B** (_"Londra ORB — dimezza su segnale opposto — MAI"_,
1 EA, ed e' questo) · `InpMinRangePips`/`InpMaxRangePips = 0`, mentre sul gemello
`Live5m_v2` **il cancello d'ampiezza e' misurato mordere nel verso giusto**.

**🟢 E QUI C'E' L'UNICA BUONA NOTIZIA SUL COSTO DI TUTTO IL DOSSIER:** GBPUSD ha
uno **spread misurato di 0,2 pip** → la frontiera `40×` chiede **8,0 pip** di
stop. Lo stop MIDPOINT e' **meta' del canale orario**: l'ampiezza vera e'
`[NON MISURATO]`, ma **e' l'unico dei sei che non ha un problema di costo
evidente**. 👉 **Su GBPUSD il pedaggio non e' la spiegazione.**

**🔴 IL CONTRO-ESEMPIO CHE ME LO UCCIDEREBBE, e me lo sono costruito:**
**R45 (14/08)** ha misurato la sessione di Londra **a tick reali**, `ABTG_ORB_Ottimizzato`,
su **XAUUSD + EURUSD + GBPUSD**: **0 celle positive su 48**, campioni **149-262
IS** e **186-408 OOS**, e su **GBPUSD il migliore fa PF 0,61** — il peggiore dei
tre. E' la misura piu' seria che abbiamo sulla sessione, e il referto congela il
criterio 4 ("la famiglia ORB chiude su ogni sessione misurata").
⚠️ **MA ho aperto il file prova, e R45 ha girato alla STESSA ORA SBAGLIATA**:
`prove/R45c_londra_GBPUSD.txt` r.20-22 → `InpRangeStartHour=7`,
`InpRangeEndHour=7` (range 07:00→07:15/07:30 server). Il registro lo scrive a
r.1141: _"`Londra_ORB` ('06-07 server') **e R45** ('07:00 server') misuravano la
**pre-apertura**, non l'apertura."_
👉 **R45 non falsifica "ORB all'apertura di Londra": falsifica "ORB un'ora prima
dell'apertura di Londra", e lo fa due volte.** Il contro-esempio esiste, e'
pesante, ed e' **spostato di un'ora**.

---

## 🎯 3. IL VERDETTO SULLA FRASE DEL 26/07 — **verdetto sul MECCANISMO o sul TF?**

> **La frase, r.41 di `backtest_pipeline/REGISTRO_TEST.md`:**
> _"VERDETTO DEFINITIVO — capitolo BREAKOUT M5 CHIUSO (26.07.26). Provati e morti
> in real-tick: Live5m nativo, Live5m_v2, DAX_M3, aperture Nasdaq, ORB_Fibo,
> Londra_ORB. Il breakout in apertura su M5 NON ha edge sul tick vero. Non
> costruire altri v2 M5."_

### 🔴 RISPOSTA DIRETTA ALLA DOMANDA DI CLAUDIO: **e' un verdetto sul TF M5.**

Con i numeri sotto, e sono tutti letti da CSV o da `.ini` agli atti:

| Prova | Numero | Cosa dice |
|---|---|---|
| **I sei motori sono stati girati su quanti TF?** | `L1` M5 · `L2` M5 · `L3` M5 · `O2` M5 · `O3` **M3** · `O4` M5 | **UNO ciascuno.** Nessuno e' mai stato girato su **M15, M30 o H1** |
| **Quando il TF effettivo e' stato alzato, cos'e' successo?** | **4 coppie su 4**: PF **+0,077…+0,136**, DD **−5,6…−11,3 punti** | Il TF **morde**, e morde **nel verso di salire** |
| **Il motore paga il pedaggio su M5?** | stop minimo strutturale **1,2× – 8,8×** lo spread, contro **40×** | **NO.** Il pedaggio da solo basta a spiegare i numeri negativi |
| **I due motori "morti" con numeri OHLC** | `O3` e `O4`: `Model=1` nell'`.ini`, **zero CSV mai esistiti** | Non hanno **mai** avuto un verdetto a tick |
| **Le corse a tick citate dalla frase** | 27 + 27 passate, **zero CSV in tutta la storia di git** | Il numero che chiude il capitolo **non e' verificabile** |
| **Due dei sei non sono breakout d'apertura** | `O3` = Supertrend H4/M3 (famiglia **viva** su H1/H4) · `O2` = **retest** in Golden Zone | **errore di categoria** |
| **Uno dei sei ha misurato un'altra ora** | `O4` a **07:00**, Londra apre alle **08:00 server** (misurato 03/09) | ha misurato la **pre-apertura** |

### 🟢 COSA REGGE, e va detto perche' chiudere davvero un capitolo e' una vittoria

**Il nucleo regge, ed e' misurato TRE volte con CSV in mano:**

| Cella | Modello | PF | n | DD | rischio |
|---|---|---:|---:|---:|---:|
| `L1` D30EUR, PrevWin 5, ST OFF, due lati, cancello spento — **OOS** | tick | **0,85701** | 342 deal | **39,74%** | 2,00% |
| `L2` NASUSD, PrevWin 5, ST OFF, due lati, cancello 1700/4000 — **OOS** | tick | **0,96265** | 175 deal | **19,40%** | 2,00% |
| `L3` D30EUR, PrevWin **5**, ST **OFF** — 4 celle su 8 | tick | **0,846 – 0,951** | 258-501 deal | **16,1 – 26,1%** (= **31,5 – 51,9% @ 2%**) | 1,00% |

> 🔴 **La rottura secca della candela pre-apertura di 5 minuti, a due lati
> insieme, senza filtro di trend e senza cancello d'ampiezza, e' MORTA — e
> muore due volte: sul PF e (piu' duramente) sul DRAWDOWN.** Quel capitolo si
> puo' chiudere, **e si chiude prima per COSTO che per PF**: 1,2-8,8× lo spread
> contro i 40× richiesti.

### ✍️ IL TESTO NUOVO CHE PROPONGO per r.41

> **⚠️ VERDETTO DEL 26/07/2026 — RISCRITTO IL 22/09/2026 (`report/RIESAME_MORTI_BREAKOUT_M5_2026-09-22.md`).**
> **Cosa resta VERO e chiuso:** la **rottura secca della candela pre-apertura da
> 5 minuti**, a **due lati insieme**, **senza filtro di trend** e **senza
> cancello d'ampiezza**, **non paga a tick veri sugli indici BCM** — e muore
> prima sul RISCHIO che sul PF: `DAX_Live5m` OOS **PF 0,857 · n 342 deal · DD
> 39,74% @ rischio 2%**; `Nasdaq_Live5m` OOS **PF 0,963 · n 175 deal · DD 19,40%
> @ 2%**; `DAX_Live5m_v2` ramo `PrevWin=5 / ST OFF` **PF 0,846-0,951 · DD
> 16,1-26,1% @ 1%** (= 31,5-51,9% alla taglia FTMO). 🔴 **E il COSTO lo spiega da
> solo**: lo stop minimo strutturale di quelle corse vale **1,2× – 8,8× lo spread
> D30EUR misurato (1,70 idx alle 8:00)**, contro i **40×** della regola di casa
> (= **68 punti indice**). **Su M5 quel motore paga il pedaggio, non il
> mercato.**
> **🔴 Cosa NON e' mai stato misurato, e la frase vecchia dava per morto:**
> **(1)** `ABTG_DAX_M3` e `ABTG_Londra_ORB` **non hanno MAI avuto un CSV** —
> verificato su tutta la storia di git — e i loro `.ini` del 26/07 dichiarano
> **`Model=1` = OHLC**: sono **⚪ NON ANCORA MISURATI**, non morti. **(2)** Anche
> le corse a tick citate (27+27 passate su `L1` e `L2`) **non hanno CSV agli
> atti**, girarono dal **2024.01.01** contro un pavimento tick misurato al
> **2024.09.26** (**29,5% della finestra su tick fabbricati**), coi **due lati
> pinnati insieme** e con **`InpUseSupertrend` pinnato a ZERO** — cioe'
> spegnendo l'unico interruttore che nel CSV gemello ribalta il segno
> (0,922 → 1,043). **(3)** **NESSUNO dei sei e' mai stato girato su un TF
> diverso dal suo**: `L1/L2/L3/O2/O4` **solo M5**, `O3` **solo M3** — e nella
> sola volta in cui il TF effettivo e' stato alzato (finestra d'ingresso 5 → 15
> minuti, `valid_DAX_Live5m_v2_D30EUR_realtick.csv`) il **PF e' salito in 4
> coppie su 4 (+0,077…+0,136) e il DD e' sceso di 5,6-11,3 punti**. **30 e 60
> minuti non sono mai stati provati.** **(4)** Due dei sei **non sono breakout
> d'apertura**: `ABTG_DAX_M3` e' Supertrend **H4 bias / M3 trigger** con EMA200 e
> ADX (la famiglia **viva** su H1/H4: PF 1,45-1,96 a tick), e `ABTG_ORB_Fibo`
> entra con un **LIMIT nella Golden Zone 50-61,8%** — cioe' un **RETEST**, la
> geometria che in casa **paga**. **(5)** `ABTG_Londra_ORB` ha costruito il
> canale **06:00-07:00 server** ed e' entrato alle **07:00**, mentre il 03/09 e'
> stato **misurato** che **Londra apre alle 08:00 server**: ha misurato la
> **pre-apertura**, e le ore non sono **mai** state su un asse. _(Lo stesso vale
> per **R45**, `prove/R45c` r.20: `InpRangeStartHour=7`.)_
> **👉 CONCLUSIONE: "Non costruire altri v2 M5" RESTA IN PIEDI. "Il breakout in
> apertura non ha edge" NON e' dimostrato: e' dimostrato che NON PAGA SU M5, che
> e' il TF dove il pedaggio se lo mangia.** Il capitolo si riapre **solo** su
> **TF piu' alti**, **meccanismi** (cancello d'ampiezza, filtro di trend,
> retest), **simboli** e **gestione dell'uscita** — **mai** su una griglia piu'
> fitta degli stessi parametri su M5.

---

## 📊 4. CLASSIFICA DEI RESUSCITABILI + **QUALI TF MANCANO E QUANTO COSTANO**

🔴 **Vincolo che viene prima di tutto, e lo scrivo in cima:** la challenge FTMO
**e' viva dal 21/09**, e la regola firmata lo stesso giorno dice che **i round
girano sul PC di backtest, non sul VPS**, e che **il runner notturno delle 03:30
va sospeso**. `R150a` e' gia' **sospesa** per questo. 👉 **Niente di quanto
segue e' lanciabile senza una decisione di Claudio.** Io propongo, con il costo
accanto; non armo e non consegno righe.

**Vincoli tecnici che accompagnano OGNI TF proposto** (scritti una volta qui,
richiamati in tabella):
- **Frontiera del costo** `stop ≥ 40 × spread`: **D30EUR 68 idx · NASUSD 72 idx ·
  GBPUSD 8,0 pip**. 🔴 **E' il motivo tecnico per cui il capitolo M5 poteva
  essere morto per COSTO e non per assenza di edge**: salire di TF allarga lo
  stop e **riduce il pedaggio in proporzione**. **Salire di TF e' quindi una
  riapertura LEGITTIMA** (si allarga su TF, non sui parametri di un motore morto).
- **Tetto delle ~100.000 barre**: su **M5** la finestra di 21 mesi passa **solo
  perche' il walk-forward la spezza in due tranche** (IS 2024.09.26→2025.06.09,
  OOS 2025.06.10→2026.06.30). Su **M15 (~4 anni)**, **M30 (~8)** e **H1 (~16)**
  il vincolo **sparisce**.
- **Banda buona sugli indici per la challenge: M30/H1** (`CLAUDE.md`).
- **Frequenza**: pavimento **1,00 op/giorno PER FAMIGLIA** (firmato 07/09). Piu'
  alto il TF, meno operazioni → **la dichiaro attesa, cella per cella**.
- 🔴 **AVVERTENZA CHE VALE PER TUTTA LA FAMIGLIA LIVE5M, e che ho verificato nel
  sorgente: cambiare il TF DEL GRAFICO non cambia i numeri.** In
  `ABTG_DAX_Live5m.mq5` / `_v2` / `ABTG_Nasdaq_Live5m.mq5` il TF del grafico
  entra **solo** in `iATR(_Symbol, PERIOD_CURRENT, …)` (r.293/306/296, **ramo
  morto** con `InpTrailStartR=0`) e, nel solo v2, in un filtro volumi
  `CopyTickVolume(_Symbol, PERIOD_CURRENT, …)` (r.1246) che e' **SPENTO in tutte
  e 32 le passate** (`InpUseVolumeFilter=0`). **Il range nasce da barre M1.**
  👉 **Il TF VERO di questo motore e' `InpPrevWindowMin`** (larghezza in minuti
  della finestra pre-apertura) **e `InpRangeMode`/`InpLevelTF`.** Spazzolare
  `Period=M15` darebbe **gli stessi identici numeri**: sarebbe una misura finta.

### 🥇 1° — `ABTG_DAX_Live5m_v2` (L3), asse **LARGHEZZA DELLA FINESTRA**

| | |
|---|---|
| **Perche' primo** | E' l'unico posto del dossier dove **un gradiente misurato** punta in una direzione **mai percorsa**: 4 coppie su 4, PF su e DD giu', 5 → 15 minuti. E il CSV c'e' gia' |
| **TF provati** | **finestra d'ingresso 5 e 15 minuti** (chart M5, irrilevante) |
| 🔴 **TF che MANCANO** | **30 e 60 minuti** — e **60 minuti e' esattamente `InpRangeMode=PREVBAR` con `InpLevelTF=H1`**, cioe' *"il livello H1 e non il breakout M5"*, che e' **la geometria della sedia VIVA `A2`** (DAX apertura LONG, PF 1,49 DD 3,8% n 314, real tick) |
| **LA misura che lo sblocca** | `InpPrevWindowMin` ∈ **{15, 30, 60}** × `InpUseSupertrend` **ON** (fissato: e' la meta' vincente) × **lato** {long, short} — **due lati separati**, regola del 25/08, perche' lo short di questo motore **non e' mai stato misurato**. Piu' un **asse tecnico** a 2 celle gemelle sul magic (cancello G1) |
| **Passate** | 3 TF × 2 lati × 2 finestre (IS/OOS) = **12** + 2 tecniche = **14** |
| **Costo** | 14 × (0,34-1,50 min) = **🟢 4,8 – 21,0 min** *(tetto: il costo scende salendo di TF; calibrazione 21/09 su M5)* |
| **Attesa dichiarata PRIMA** | Se il gradiente e' reale, **PF ≥ 1,04 su tutte e tre le finestre in long** e **DD in calo monotono**; il pedaggio scende da 8,8× verso 20-40× lo spread. **Frequenza attesa in calo**: da 239 deal (15') verso **~150-200** a 30' e **~100-150** a 60' `[STIMA, NON MISURATO]` — sotto il pavimento **per sedia**, ma il pavimento e' **per FAMIGLIA** dal 07/09 |
| **Soglia di scarto congelata PRIMA** | Se a 30' **e** 60' il PF long scende sotto 1,00, **il gradiente e' un artefatto e il capitolo si chiude davvero**. Se lo short resta < 1,00 su tutte e tre, **long-only e scritto nel preset** |
| 🔴 **IL CONTRO-ESEMPIO CHE LO UCCIDEREBBE** | **(a)** La cella migliore fa **DD 9,10% @ 1% = 17,8-18,1% @ 2%**: **alla taglia FTMO sfonda gia' il muro**, e allargare la finestra allarga lo stop, quindi **allarga anche il DD in punti**. **(b)** Il gradiente e' misurato su **una finestra unica** (nessun IS/OOS) e **con il 29,5% dei tick fabbricati**: potrebbe essere un artefatto del periodo fabbricato. **(c)** A 60 minuti il motore **diventa `A2`**, che e' gia' vivo — quindi il "successo" sarebbe una **riscoperta**, non una sedia nuova. 👉 **Per questo la misura va rifatta sulla finestra 2024.09.26→2026.06.30 con split IS/OOS, non sulla finestra del 26/07** |

### 🥈 2° — `ABTG_DAX_M3` (O3), asse **`InpTriggerTF`**

| | |
|---|---|
| **Perche' secondo** | **0 punti su 5**, zero CSV, unico numero OHLC — e appartiene alla **famiglia che in casa VINCE** (SupRev a tick: DAX H1 **1,45** · DAX H4 **1,96** · NAS H1 **1,57**). E' il candidato con il rapporto "informazione mancante / costo" piu' alto del dossier |
| **TF provati** | **trigger M3** · **bias H4**. 🔴 Nient'altro. **Mai M5, mai M15, mai M30** |
| 🔴 **TF che MANCANO** | **M15, M30** sul trigger (la banda buona degli indici). M5 lo **escludo io, per costo**: con `InpSLMode=SUPERTREND` lo stop e' `StMult × ATR(10)` sul TF del trigger, e l'ATR(10) M3/M5 su D30EUR e' `[NON MISURATO]` ma quasi certamente **ben sotto i 68 punti indice** della frontiera |
| **LA misura che lo sblocca** | **Una corsa a TICK REALI** (mai fatta) con `InpTriggerTF` ∈ **{M15, M30}**, `InpBiasTF` = H4 **fisso**, `InpSLMode` **pinnato esplicitamente** a `M3SL_SUPERTREND` (per non ripetere l'asse inerte), **lati separati** |
| **Passate** | 2 TF × 2 lati × 2 finestre = **8** + 2 tecniche = **10** |
| **Costo** | 10 × (0,34-1,50 min) = **🟢 3,4 – 15,0 min** — **tetto**: su M15/M30 il costo per passata **scende** rispetto alla calibrazione M5 |
| **Prerequisito a costo zero (1 sonda)** | **ATR(10) mediano su D30EUR per TF** (M3/M5/M15/M30): senza, la frontiera del costo su questo motore **non e' compilabile**. Una sonda, non un round |
| **Attesa dichiarata PRIMA** | Su M30 mi aspetto **frequenza 0,2-0,5 op/giorno** `[STIMA]` e uno stop `3,5 × ATR(10) M30` **sopra i 68 punti indice** → **il cancello di costo passa**. Sul merito: la famiglia su H1/H4 fa 1,45-1,96, quindi **PF ≥ 1,20 in almeno una finestra** o l'ipotesi "e' SupRev travestito" e' falsa |
| 🔴 **IL CONTRO-ESEMPIO CHE LO UCCIDEREBBE** | Se su M30 questo motore **converge su `ABTG_SupRev_DAX_H1`**, allora non e' un candidato nuovo: e' **una seconda copia di una sedia che c'e' gia'**, e aggiungerla **peggiora la correlazione** (il tetto per cluster C2 e' firmato ma **NON attivo**). 👉 **La misura va letta con la sovrapposizione degli ingressi accanto, non solo col PF.** Secondo contro-esempio: `InpUseADX=true` con `InpAdxMin=25` su M30 potrebbe tagliare la frequenza sotto la soglia utile — **da misurare, non da assumere** |

### 🥉 3° — `ABTG_ORB_Fibo` (O2), asse **TICK** (e poi `InpExecTF`)

| | |
|---|---|
| **Perche' terzo** | E' un **RETEST**, non un breakout — la geometria che in casa paga. **Zero passate a tick in assoluto.** E il suo DD e' il piu' basso della tabella (con l'avvertenza del §2.4) |
| **TF provati** | **solo M5** (`InpExecTF` mai mosso) · **OR solo 30 minuti** |
| 🔴 **TF che MANCANO** | **M15** sull'esecuzione. **M30 no**: con un Opening Range di 30 minuti, un TF d'esecuzione da 30 minuti dara' **1 barra per OR** — e' geometricamente incoerente. 👉 **Qui il TF utile e' `InpORMinutes` (15/30/60), non `InpExecTF`** |
| **LA misura che lo sblocca (UNA sola)** | 🔴 **La stessa identica cella, a TICK REALI invece che OHLC.** NASUSD, 2024.09.26→2026.06.30, **lati separati**. **E' il passo che trasforma uno screening in un fatto**, e senza di esso qualunque altra misura su questo motore e' aria |
| **Passate** | 2 lati × 2 finestre = **4** + 2 tecniche = **6** |
| **Costo** | 6 × (0,34-1,50 min) = **🟢 2,0 – 9,0 min** |
| **Attesa dichiarata PRIMA** | Fattore OHLC/tick misurato sulla famiglia = **1,71 in eccesso** (L1). Se vale qui, **0,968 OHLC → ~0,57 a tick** e il motore e' finito. **Se invece regge sopra 0,90, il retest e' diverso dal breakout e merita il secondo passo.** Scrivo l'attesa **prima**: mi aspetto che **scenda**, e sarei sorpreso del contrario |
| 🔴 **IL CONTRO-ESEMPIO CHE LO UCCIDEREBBE** | **n OOS 75 < 150** → **merito SOSPESO comunque**, e a tick il campione **scende ancora**. Piu': **R97+R98** hanno chiuso il capitolo ORB su Nasdaq (_"due meccanismi, stesso mercato, 0 edge"_) — su ingressi di **rottura**, non su un limit in Golden Zone, ma e' un avvertimento serio. Terzo: il **DD 3,10% e' quantizzato dal passo lotto 0,10**, quindi non e' confrontabile finche' non si misura il rischio realizzato |

### 4° — `ABTG_Londra_ORB` (O4), asse **L'ORA**

| | |
|---|---|
| **Perche' quarto e non piu' su** | L'unico dei sei **senza problema di costo** (GBPUSD 0,2 pip), e il difetto e' **riparabile con tre input**. Ma ha **contro se' la misura piu' pesante del dossier** (R45, 48/48 a tick) |
| **TF provati** | **solo M5** · canale **solo 06:00-07:00** (un'ora **prima** dell'apertura) |
| 🔴 **TF che MANCANO** | **M15** d'esecuzione; e soprattutto **il canale ad altre ore e altre durate**: `07:00-08:00` e `08:00-09:00` server (= **l'apertura vera**) |
| **LA misura che lo sblocca (UNA sola)** | **L'ORA ad asse.** `InpRangeStartHour/EndHour/PlaceHour` = **{06-07, 07-08, 08-09}** server, GBPUSD, **TICK reali dal 2024.07.05** (pavimento GBPUSD **misurato**), **lati separati** |
| **Passate** | 3 ore × 2 lati × 2 finestre = **12** + 2 tecniche = **14** |
| **Costo** | Il forex e' piu' rado degli indici → **🟢 stimo 3 – 12 min** `[STIMA per analogia, la calibrazione 21/09 e' sugli INDICI]` |
| **Attesa dichiarata PRIMA** | Se il difetto e' **l'orologio**, la cella **08-09** deve battere la **06-07** in modo **netto** su entrambe le finestre. Se tutte e tre sono rosse, **l'orologio non era la causa e la sessione di Londra chiude per la terza volta** |
| 🔴 **IL CONTRO-ESEMPIO CHE LO UCCIDEREBBE** | **R45: 0/48 a tick, n 149-408, GBPUSD PF 0,61** — il peggiore dei tre simboli. Se anche la cella 08-09 e' rossa, **questo e' il colpo di grazia definitivo** e va scritto cosi'. **E ne esiste un secondo**, gia' congelato il 03/09: _"L'APERTURA DI LONDRA E' CHIUSA IN TUTTE E DUE LE FORME A LIVELLO"_, perche' i 4 migliori candidati esterni si sono rivelati **riga per riga `ABTG_BreakinBox`**, misurato a tick e chiuso da lettera congelata (**PF 1,007 DD 24,1%** / **PF 1,106 DD 19,7%**). 👉 **Se passa, passa contro due misure. Serve un margine ampio, non un 1,05** |

### 5° — `ABTG_Nasdaq_Live5m` (L2) · 6° — `ABTG_DAX_Live5m` (L1)

Li metto **in fondo**, e la ragione e' la stessa per tutti e due: 🔴 **il loro
numero non manca piu', e' BRUTTO.**
- **L2**: l'uscita e' misurata (R142, 11 celle a tick). Il centro dell'altopiano
  sulle celle sopra 1 fa **≈1,032**, sotto il cancello 1,10; e **ogni cella OOS
  ha DD ≥ 17,62% alla taglia FTMO del 2%**, contro un muro del 10%. 👉 **Resta
  ⚪ per le voci 4 e 5, ma sale di priorita' solo se il TF d'ingresso lo salva —
  e quello e' firma di Claudio.** `R150a` e' **sospesa** per la challenge.
- **L1**: la cella con CSV fa **DD OOS 39,74% @ 2%**. Emendamento B: il rischio
  si legge **a qualunque n**. 👉 **Quella configurazione e' MORTA, con
  certificato.** Il motore resta ⚪ sulle voci 3/4/5, ma **il suo gemello L3 e'
  lo stesso motore con piu' manopole**: qualunque risorsa va su L3, non su L1.

---

## 🪦 5. I MORTI VERI, col numero brutto scritto

| Cosa muore | Modello | Numero | Perche' e' un morto e non un "non misurato" |
|---|---|---|---|
| **La rottura secca a 5 minuti, due lati, ST OFF, cancello spento** — `L1` cella CSV | 🟡 **tick** | OOS **PF 0,85701** · n **342 deal** · **DD 39,74% @ rischio 2,00%** | Emendamento B: **il rischio si legge a qualunque n**. 39,74% e' **quasi 4 volte** il muro FTMO del 10%, alla taglia vera |
| **Lo stesso motore, ramo `PrevWin 5 / ST OFF`** — `L3`, 4 celle su 8 | 🟡 **tick** | **PF 0,846-0,951** · n 258-501 deal · **DD 16,1-26,1% @ 1%** = **31,5-51,9% @ 2%** | Quattro celle indipendenti, **tutte** negative, **tutte** oltre il muro. Non e' un campione sottile |
| **La gestione d'uscita del pre-apertura Nasdaq** — `L2`, 11 celle R142 | 🟡 **tick** | OOS **PF 0,945-1,070** · **DD 17,62-33,62% @ 2,00%** | **Nessuna** cella sotto il muro del 10%. E il PF migliore e' un **picco** (vicine 0,956 e 1,010), non un altopiano |
| **`InpMinStopPts` / `InpSkipIfTight`** come sono stati provati — `L3` | 🟡 **tick** | **32 passate → 8 esiti**: 16 gruppi ciascuna, **zero effetto** | Provati a **2-4 punti indice** contro una frontiera di **68**. 🔴 **Non e' "provato e non funziona": e' "provato al valore sbagliato"** — la casella e' **libera**, non consumata |
| **`InpSLFixedPts`** come e' stato provato — `O3` | 🔴 **OHLC** | **6 valori sull'asse, letti ZERO volte** (`InpSLMode` su SUPERTREND, `ABTG_DAX_M3.mq5:270-271`) | Inerte **per costruzione**, dimostrato dal sorgente. **Casella libera** |
| **La sessione di Londra alle 07:00 server** | 🟡 **tick** | **R45: 0 celle positive su 48** · n **149-262 IS / 186-408 OOS** · GBPUSD migliore **PF 0,61** | Campione enorme, rosso ovunque, tre simboli. 🔴 **Ma e' l'ORA SBAGLIATA** (Londra apre alle 08:00 server): uccide **quell'ora**, non la sessione |
| *(fuori perimetro, citato)* **aperture Nasdaq `A4`** | 🟡 **tick** | **PF 0,82-0,91** · walk-forward **19/20 celle OOS negative** · sedia `770201` **spenta il 18/08** | 🔴 **E' l'unico dei sei della frase con un certificato quasi pieno.** Verdetto lasciato all'agente delle aperture |

---

## 🕳️ 6. NON COPERTO — cosa non ho potuto verificare, e perche'

| # | Cosa | Perche' |
|---|---|---|
| 1 | **I numeri del 26/07 di `DAX_M3` (33% pos, short 0%) e `Londra_ORB` (11% pos, DD 23%)** | **Nessun CSV e' MAI esistito** nel repo (verificato su `git log --all`). Non li posso ne' confermare ne' smentire: posso solo dire che l'`.ini` che li ha prodotti dichiara **`Model=1` = OHLC**. Il conto "1008 passate → ≤168 esiti → 126 effettivi" e' **`[DERIVATO]` dall'`.ini` + sorgente**, non letto da un CSV |
| 2 | **Se le 27+27 passate a tick siano davvero partite dal 2024.01.01** | L'`.ini` agli atti lo dice; **senza CSV non e' verificabile** se la riga di lancio l'abbia sovrascritto. 👉 Ma l'assenza del CSV **e' gia' di per se'** il motivo per cui quel verdetto non regge |
| 3 | **La profondita' tick del broker a LUGLIO 2026** | Misurata ad **agosto/settembre 2026**. Se fosse una finestra che **rotola**, a luglio sarebbe partita ~luglio 2024 e il buco sarebbe minore. 🟢 Contro-indizio forte: **la stessa identica data (2024.09.26) su tre simboli diversi**, coincidente col muro delle barre M1 → **pavimento fisso del feed**. Resta `[NON VERIFICABILE]` formalmente |
| 4 | **La distribuzione vera del `range` pre-apertura su D30EUR e NASUSD** | Mai misurata (`MANOPOLE_INERTI_2026-09-09.md` la dichiara `[NON MISURATO]` a r.105). 👉 Senza, il rapporto **stop/spread vero** (non il pavimento strutturale) resta ignoto. **E' una sonda, non un round** |
| 5 | **L'ATR(10) su D30EUR per TF (M3/M5/M15/M30)** | Mai misurato. Senza, la frontiera del costo su **`ABTG_DAX_M3`** non e' compilabile. **Sonda** |
| 6 | **Il rischio REALIZZATO di `ABTG_ORB_Fibo`** | `LotByRisk` fa `MathFloor` sullo step del lotto: su indici a passo 0,10 il rischio e' **quantizzato**. Il **DD 3,10% non e' confrontabile** finche' non si misura. `[NON MISURATO]` |
| 7 | **L'ampiezza vera del canale 06:00-07:00 su GBPUSD** | Mai misurata → non so se lo stop MIDPOINT superi gli **8,0 pip** della frontiera. Lo **stimo** sopra, ma e' una stima |
| 8 | **Lo spread GBPUSD per ORA SERVER** | Esiste solo una **lettura unica** (0,2 pip, `CACCIA_SABATO_2026-09-13.md`). Non c'e' un `spread_orario_GBPUSD.csv` come per i tre indici |
| 9 | **A4 (aperture Nasdaq)** | **Fuori perimetro** (agente aperture). Ho riportato i numeri esistenti, non ho rifatto la verifica |
| 10 | **Il costo macchina su M15/M30/H1** | La calibrazione del 21/09 e' su **M5**. Dico "il costo scende salendo di TF" perche' ci sono **meno barre a parita' di tick**, ma **non l'ho misurato**: i miei numeri sono **tetti**, non stime centrali |

---

## 🛡️ 7. IL CONTRO-ESEMPIO CONTRO ME STESSO (regola del 10/09)

**La tesi centrale di questo dossier e': _"il verdetto del 26/07 e' sul TF M5,
non sul meccanismo"_. Ecco l'argomento migliore che so costruire CONTRO di essa,
e perche' non mi convince — ma non del tutto.**

> **L'ARGOMENTO CONTRARIO.** Il gradiente 5'→15' che cito e' **una sola
> manopola, su un solo simbolo, su una finestra unica senza IS/OOS, con il 29,5%
> dei tick fabbricati, in una griglia long-only**. Quattro coppie non sono
> quattro esperimenti indipendenti: sono **quattro letture della stessa corsa**,
> che condividono lo stesso periodo e lo stesso identico blocco d'uscita. E
> l'effetto potrebbe non essere affatto "il TF": allargare la finestra **alza il
> tasso di rottura falsa filtrata** e **riduce il numero di trade del 8-13%** —
> potrebbe essere semplicemente **selezione di giornate piu' volatili**, cioe'
> lo stesso cancello d'ampiezza sotto mentite spoglie. E il finale scomodo: a
> **60 minuti il motore diventa `A2`**, che e' gia' vivo — quindi "il gradiente"
> potrebbe essere solo la strada che riporta a una sedia che abbiamo gia'.

**PERCHE' LA TESI REGGE LO STESSO, ma in forma piu' debole di come l'avevo
scritta all'inizio:**
1. La tesi **non e' "il motore e' vivo"**. La tesi e' **"non e' stato misurato su
   altri TF"**, e quella e' **un fatto di censimento**, non un'inferenza: sei
   motori, sei TF unici, zero varianti. Non serve il gradiente per sostenerla.
2. Il **costo** e' un argomento **indipendente dal gradiente**: 1,2-8,8× contro
   40× e' aritmetica su due quantita' misurate (buffer dal CSV, spread dal file
   dei tick). **Regge anche se il gradiente fosse rumore.**
3. Il gradiente **non decide niente**: lo uso per ordinare la classifica, **non**
   per dire che il motore funziona. E infatti la cella migliore la dichiaro
   **fuori dal muro del DD** (17,8-18,1% @ 2%).
4. 🔴 **E accolgo la critica dove morde**: ho **riscritto la proposta #1** per
   girare su **2024.09.26→2026.06.30 con split IS/OOS** — cioe' **non** sulla
   finestra contaminata del 26/07 — e ho messo "se a 30' e 60' il PF scende sotto
   1,00, **il gradiente e' un artefatto e il capitolo si chiude davvero**" come
   **soglia di scarto congelata PRIMA**.
5. 🟢 E sull'obiezione "a 60' diventa `A2`": **e' vera, ed e' scritta nel
   contro-esempio della proposta #1.** Se succede, il risultato onesto e'
   *"abbiamo riscoperto A2"*, che **non e' una sedia nuova** — e va detto cosi'.

**E il contro-esempio al contrario, come chiesto: cosa SALVEREBBE i morti veri?**
Un solo argomento serio, e lo scrivo perche' esiste: **i DD del 26/07 sono
misurati con `InpRiskPercent` al 1-2% su un deposito di 10.000 €, dove il
`MathFloor` sullo step del lotto 0,10 distorce la taglia.** Un DD del 39,74% su
banco piccolo **potrebbe** essere un DD molto diverso su banco da 100.000. 🔴 **Ma
non li salva**: il PF **non dipende dalla taglia**, e i PF sono 0,846-0,963.
**Un DD sbagliato non trasforma un PF sotto 1 in un edge.**

---

## 📌 8. RIGHE DA CAMBIARE NEL REGISTRO (proposta, non eseguita)

| Riga | Oggi | Proposta |
|---|---|---|
| **r.35 (L1)** | 🔴 morto | ⚪ **NON ANCORA MISURATO** + la cella CSV **bocciata sul RISCHIO** (DD OOS 39,74% @ 2%) + "TF provati: **solo M5**, finestra ingresso **solo 5 min**" |
| **r.37 (L3)** | 🔴 morto · *"+range filter (32 combo)"* | ⚪ **NON ANCORA MISURATO** + 🔴 **correggere la descrizione**: il range filter **non c'era** (`MinRange=MaxRange=0`), la griglia era **LONG-ONLY**, e **2 manopole su 5 erano inerti** + il **gradiente 5'→15'** con i quattro delta |
| **r.41 (la frase)** | *"capitolo BREAKOUT M5 CHIUSO"* | **Il testo nuovo del §3** |
| **r.135 (O3)** | 🔴 morto · *"OHLC 33% pos, short 0%"* | ⚪ **NON ANCORA MISURATO — 0/5** + **zero CSV mai esistiti** + `Model=1` + `InpSLFixedPts` **inerte per costruzione** + **non e' un breakout M5** (H4 bias / M3 trigger, famiglia Supertrend) |
| **r.136 (O4)** | 🔴 morto · *"OHLC 11% pos, DD 23%"* | ⚪ **NON ANCORA MISURATO — 0/5** + **zero CSV mai esistiti** + `Model=1` + **DD a rischio ignoto** + 🔴 **ha misurato le 07:00, Londra apre alle 08:00 server** |
| **r.39 (la nota OHLC)** | *"in OHLC i Live5m davano numeri finti enormi"* | 🟢 **CONFERMATA e quantificata**: fattore **1,71 sul PF OOS** di `L1` (1,46853 OHLC → 0,85701 tick) e **1,85** su `L3` (1,71088 → 0,92490). **Tenerla, e mettere il numero** |

---

## 🚀 9. IN CHIUSURA — cosa ci portiamo via oggi

😄 **Tre cose buone, e una scomoda.**

🟢 **La prima cosa buona:** il metodo di casa **ha funzionato**. Le manopole
inerti di `L3` erano gia' state trovate il 09/09; la Tabella B aveva gia' messo
`InpTrailOnST` e `InpExitOnFlip` in cima alla lista dei mai provati, ed erano
**esattamente** i due di `DAX_M3`; la classe 590 sui tick era gia' scritta
**dentro l'intestazione del driver**. 👉 **Non ho scoperto che sbagliavamo: ho
trovato che le nostre stesse misure non erano state incrociate.**

🟢 **La seconda:** la direttiva di Claudio sui TF **aveva gia' una prova nei
nostri dati, e nessuno l'aveva letta.** Quattro coppie su quattro, PF su e DD
giu'. **Ha ragione, e ce l'aveva scritto in casa.**

🟢 **La terza:** i costi. **14 + 10 + 6 + 14 = 44 passate**, cioe' **fra 15 e 57
minuti** di macchina (tetto) per chiudere il certificato dei **quattro** motori
piu' scoperti. 👉 **Un capitolo di sei motori, chiuso male da due mesi, si
riapre o si sigilla davvero per meno di un'ora di tester.**

🔴 **E quella scomoda, che viene prima di tutte:** **la challenge e' viva dal
21/09**, i round girano **solo sul PC di backtest**, il runner notturno va
sospeso, e **`R150a` e' gia' ferma per questo**. Quei 15-57 minuti **non sono
gratis oggi**: costano una decisione di Claudio, e **la decisione e' sua.**
Io ho preparato il terreno; **non ho armato niente.**

🎯 **E la bussola, perche' e' l'unica cosa che conta:** nessuno di questi quattro
diventa una **sedia schierabile** entro il 1° ottobre — le celle migliori che
conosciamo **sfondano gia' il muro del 10% alla taglia FTMO**. 👉 **Questo
dossier non produce una sedia: produce un capitolo onesto al posto di uno
sbagliato, e quattro caselle libere dove credevamo di aver gia' cercato.** Va
detto cosi', senza venderlo per piu' di quello che e'.

---

_Misure lette da: `risultati_prove/ABTG_DAX_Live5m/**` · `ABTG_DAX_Live5m_v2/**` ·
`ABTG_Nasdaq_Live5m/**` · `ABTG_ORB_Fibo/**` · `dal_vps/ABTG_Nasdaq_Live5m/**` ·
`risultati_archivio/Live5m/valid_DAX_Live5m_v2_D30EUR_realtick.csv` ·
`risultati_archivio/spread_flotta/*` · `risultati_archivio/misura_tick/*` ·
`risultati_archivio/REFERTO_ROUND45_LONDRA.md` ·
`risultati_archivio/allinealondra/REFERTO_PASSO0_2026-09-03_1651.txt` ·
`ini/valid_*.ini` · `ini/ABTG_{DAX_M3,Londra_ORB,ORB_Fibo}.ini` ·
`mql5/Experts/ABTG_{DAX_Live5m,DAX_Live5m_v2,Nasdaq_Live5m,DAX_M3,Londra_ORB,ORB_Fibo}.mq5` ·
`report/{MANOPOLE_INERTI,AUDIT_USCITE}_2026-09-09.md` ·
`report/PREOPEN_NASDAQ_IL_VERDETTO_2026-09-12.md` · `git log --all`._
