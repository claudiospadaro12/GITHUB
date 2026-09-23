# 🏹 CACCIA AI MECCANISMI — 23/09/2026 (R228)

_Cacciatore di strategie · **SOLA LETTURA**: zero EA scritti, zero EA toccati,
zero round lanciati, zero preset, zero terminali, zero righe verso Claudio._

**Mandato**: dopo che tre assi su tre sedie vive hanno dato ragione al valore
già schierato (`770202` profondità retest, `770260` modo trailing, `770511`
fattoriale SuperWave), la conclusione scritta oggi è *«il margine che manca
NON sta nei parametri: sta nei MECCANISMI e nei SIMBOLI»*. Questa è la battuta
di caccia che ne consegue.

---

## 🎯 LA RIGA CHE CONTA, PRIMA DI TUTTO

> **Su 319 sorgenti `.mq5` scaricati e decodificati + 2 paper + ~60 script
> TradingView guardati su 4 fonti, 5 sono arrivati alla lettura del sorgente
> riga per riga, 2 li proverei — e il primo è `RegimeRouter`, perché è l'unico
> che porta un meccanismo che in casa NON esiste (voto di regime a 3 giudici)
> con dentro un INTERRUTTORE DI ABLAZIONE che lo fa falsificare in 3 passate.**

E la seconda riga, che vale quanto la prima:

> 🔴 **Il raccolto del Code Base di oggi NON sono motori: sono pannelli.** Dei
> **197 ID mai citati nel nostro repo**, la stragrande maggioranza sono
> calcolatori di lotto, pannelli di trading, copiatori e guardiani di equity.
> **Solo 14 sorgenti su 319 (4,4%)** sono puliti dalle bandiere rosse E hanno
> insieme uno stop vero e un ATR. Il giacimento del Code Base, per noi, si sta
> esaurendo — ed è un'informazione operativa, non uno sfogo.

---

## 0. ✅ CONTROLLO POSITIVO, FONTE PER FONTE

Regola di casa: prima di cercare, si verifica che il canale risponda su un
bersaglio di cui si conosce già la risposta.

| fonte | controllo | esito | uso |
|---|---|---|---|
| **MQL5 Code Base** | `mql5.com/en/code/mt5/experts` | 🟢 **HTTP 200**, 89.342 byte, **40 ID+titolo per pagina** | 8 pagine, 320 ID, 319 sorgenti scaricati |
| **MQL5 sorgente** | `/en/code/download/<ID>` (senza nome file) | 🟢 **200**, `application/zip` | 🥇 **scoperta di canale**: lo zip arriva SENZA conoscere il nome del `.mq5` |
| **TradingView** | `pubscripts-suggest-json/?search=…` | 🟢 **200**, JSON con nome/autore/`agreeCount`/`scriptIdPart` | 18 query |
| **TradingView sorgente** | `pine-facade.tradingview.com/pine-facade/get/PUB%3B<hash>/last` | 🟢 **200**, campo `source` = Pine in chiaro, `scriptAccess: open_no_auth` | 1 sorgente letto |
| **arXiv q-fin.TR** | `arxiv.org/list/q-fin.TR/2026-09` | 🟢 **200**, 45.214 byte, titoli leggibili | 26 titoli + 5 ricerche API |
| **arXiv `/recent`** | `arxiv.org/list/q-fin.TR/recent` | 🟠 **200 ma 0 titoli** nell'HTML (pagina a JS) | ⚠️ **usare l'URL MENSILE**, non `/recent` |
| **GitHub API** | `api.github.com/search/repositories` | 🔴 **HTTP 403** | ❌ **FONTE NULLA oggi** (vedi §6) |

🔎 **Sul 403 di GitHub, la distinzione che il mandato impone**: lo status del
proxy riporta `"recentRelayFailures": []` — quindi **il 403 NON viene dalla
policy di uscita, viene da GitHub** (limite per richieste non autenticate).
`gh` non è installato in questa sessione. **Non è un 404: la fonte esiste e
risponderà.** Si dichiara come buco, non si sostituisce con la memoria.

---

## 1. 🧭 QUALE BUCO STAVO CERCANDO DI RIEMPIRE

Letto PRIMA di aprire un browser: `report/ROBUSTEZZA.md`,
`report/ROTTA_PROP.md`, `backtest_pipeline/REGISTRO_TEST.md` (4.145 righe, i
titoli di tutte le lapidi), `backtest_pipeline/caccia_strategie/SETACCIO_MANUALE.md`,
`backtest_pipeline/caccia_strategie/PROMEMORIA_SBLOCCO_FONTI.md`,
`report/ANCORA_ADR_FLOTTA_INDICI_2026-09-18.md`,
`report/ALLARGARE_LA_ROSA_2026-09-19.md`,
`report/AUDIT_POSITIONSELECT_HEDGING_2026-09-03.md`.

E **censito cosa c'è già**: `find` su `ABTG_*.mq5` → **~112 file**, di cui ~70
motori. Il catalogo di casa copre: ORB/apertura, EMA200+ADX, Supertrend
reversal, breakout a volumi, retest, mean reversion su bande, cost-to-cost,
max/min notturni, gap fill, gap continuation, PTE, Donchian lento, liquidity
sweep, post-news, VWAP revert, inside bar, turnaround Tuesday, FVG, value
area, Lyapunov.

I tre buchi che ho inseguito, e perché:

| # | buco | prova che è un buco |
|---|---|---|
| **A** | **un meccanismo che sceglie SE operare in base al REGIME misurato**, e che non sia l'ADX appiccicato | `grep -li hurst --include=*.mq5` → **zero EA**. `autocorr` → solo `ABTG_SpreadLogger` (diagnostica). E i filtri aggiunti dopo fanno **0 successi su 5** (R20, R12, R26, R45, R54) |
| **B** | **un'uscita CONDIZIONATA che tronca la giornata**, non un altro trailing | `grep -l "MaxBarsInTrade\|TimeStop\|MaxMinutes\|MaxHold"` → **3 motori su ~70** (`GapFill`, `PunteLarry`, `Relativo`). La MAE in casa è **misurata e usata per DIMENSIONARE lo stop** (`ABTG_Relativo` r.371: *«stop REALE = 2,75 × ATR = 2 × MAE mediana misurata»*), **mai come regola di uscita** |
| **C** | **simboli nuovi** | 🔴 **non l'ho inseguito, ed è una scelta**: `report/ALLARGARE_LA_ROSA_2026-09-19.md` §2.1-2.4 ha già scavato simbolo × TF in archivio e ha chiuso gli indici europei con una sonda. Rifarlo dall'esterno sarebbe stato rumore sopra un lavoro già fatto meglio |

---

## 2. 📊 IL SETACCIO DEL CODE BASE, COL NUMERO

**Metodo**: 8 pagine di elenco → 320 ID → 319 zip scaricati (1 fallito, ID
`49171`, HTTP 200 ma contenuto sotto i 500 byte) → **1.578 file `.mq5`/`.mqh`
estratti**, decodificati da UTF-16 dove serviva (trappola dichiarata nel
`PROMEMORIA_SBLOCCO_FONTI`) → regex del §4 del mandato.

| bandiera | EA colpiti su 319 | % |
|---|---:|---:|
| **martingala** (`MathPow(..lot`, `lot*=`, `Multiplier`, `LotExponent`) | **81** | **25,4%** |
| **griglia / averaging** | 32 | 10,0% |
| `iCustom` (indicatore esterno) | 24 | 7,5% |
| `WebRequest` | 16 | 5,0% |
| `#import` di `.dll` | 3 | 0,9% |
| — *nomina uno stop loss* | 169 | 53,0% |
| — *usa un ATR* | 79 | 24,8% |
| — *rischio in percentuale* | 85 | 26,6% |
| 🟢 **PULITI** (nessuna bandiera **E** stop **E** ATR) | **14** | **4,4%** |

> ⚠️ **Conteggi `[DERIVATI]` da regex**, non da lettura integrale: `\bGrid\b`
> prende anche i pannelli che disegnano una griglia sul grafico, e `Multiplier`
> prende anche i moltiplicatori di ATR. **Sovrastimano le bandiere rosse**,
> cioè sbagliano dalla parte prudente. I 5 candidati arrivati in fondo sono
> stati letti a mano, riga per riga.

**Incrocio col repo**: dei 320 ID, **123 sono già citati** in qualche nostro
`.md` (le cacce del 08/09, 12/09, 13/09) e **197 non lo erano mai**. La caccia
del 13/09 aveva fatto 25 pagine su 999 titoli: quindi il nuovo vero sono
**le pubblicazioni degli ultimi 10 giorni**. Ed è esattamente lì che stanno i
due promossi (20/09 e 16/09).

---

## 3. 🥇 PROMOSSO 1 — `RegimeRouter`

| campo | valore |
|---|---|
| **NOME** | `RegimeRouter — trend/range classifier with a per-regime win rate ledger` |
| **FONTE** | `https://www.mql5.com/en/code/77535` · sorgente: `https://www.mql5.com/en/code/download/77535` |
| **AUTORE / DATA** | `RanaAli878` (`#property copyright "Ali Rajput"`) · **2026.09.20** `[VERIFICATO]` sulla scheda |
| **LICENZA** | 🔴 **NON dichiarata nel sorgente** — c'è solo `#property copyright`. Code Base = sorgente aperto e scaricabile. `[INCERTO]` → **uso interno di ricerca**, attribuzione obbligatoria in testa a qualunque derivato |
| **RIGHE / INPUT** | **1.321 righe · 45 `input`** (contati: `grep -c "^input"`) |
| **COSTO DI PORTING** | 🟢 **zero**: è `.mq5`, gira nel nostro tester così com'è |

### Che cosa fa, in due righe (il meccanismo, non il marketing)

Su **ogni barra chiusa** misura tre proprietà indipendenti della serie —
**ADX**, **esponente di Hurst** (R/S su 256 barre di log-rendimenti) e
**autocorrelazione a lag 1** (120 barre) — e ognuna vota `+1 TREND`, `−1 RANGE`
o `0`. Se la somma non raggiunge `InpMinVotes` (default 2 su 3) il regime è
**NEUTRAL e l'EA non opera**; se è TREND abilita un **breakout** (rottura del
massimo/minimo a 20 barre, solo nella direzione della MA veloce/lenta), se è
RANGE abilita un **fade** (z-score del prezzo contro la sua media, si compra la
coda bassa e si vende l'alta).

### Su quale inefficienza scommette, e perché dovrebbe esistere

**Tesi in una riga**: *«il mercato alterna fasi in cui i rendimenti sono
persistenti e fasi in cui sono anti-persistenti, e la persistenza è MISURABILE
in anticipo — quindi si può scegliere il motore invece di subirlo.»* Hurst > 0,5
= persistente, < 0,5 = a ritorno alla media: è una proprietà statistica della
serie, non un pattern grafico. L'inefficienza scommessa non è direzionale: è
**quando NON operare**.

### 🔴 IL CANCELLO DI COSTO, COL NUMERO

Stop dell'EA = `InpTrendSLATRMult × ATR(14)`, default **1,5 × ATR** — cioè
**strutturale**, cresce col mercato. Conto fatto con **l'ancora nuova**
(`report/ANCORA_ADR_FLOTTA_INDICI_2026-09-18.md` r.98-100, ADR **max-per-data
MISURATA**) e con la **finestra attiva** al denominatore (DAX **780 min**,
indici USA **1380**), **senza** riaggiungere il vecchio +18-27% (la regola del
«si corregge una volta sola», in testa a quel referto):

`ATR(t) = ADR × √(t / finestra_attiva)` · spread MISURATI 12/09:
`D30EUR 1,70` · `NASUSD 1,80` · `U30USD 2,00` punti indice

| simbolo / TF | ATR stimato | stop a k=1,5 | **× spread** | stop a k=2,0 | × spread |
|---|---:|---:|---:|---:|---:|
| D30EUR M30 | 49,5 | 74,3 | 🟢 **43,7x** | 99,0 | 58,3x |
| D30EUR H1 | 70,0 | 105,0 | 🟢 **61,8x** | 140,1 | 82,4x |
| U30USD M30 | 56,0 | 83,9 | 🟢 **42,0x** | 111,9 | 56,0x |
| U30USD H1 | 79,1 | 118,7 | 🟢 **59,3x** | 158,3 | 79,1x |
| NASUSD M30 | 56,7 | 85,1 | 🟢 **47,3x** | 113,4 | 63,0x |
| NASUSD H1 | 80,2 | 120,3 | 🟢 **66,8x** | 160,4 | 89,1x |

> 🟢 **Passa il pavimento 40x su tutti e tre i simboli, a M30 e a H1, già col
> default.** È la banda buona dichiarata dal mandato.

🔴 **MA c'è un contro-esempio che ho costruito contro il mio stesso numero, e
mezza tabella cade.** Il referto del 18/09 §6 dichiara un **disaccordo di casa
sullo spread di coda del DAX: 1,70 contro 2,70**. Con **2,70**:

| D30EUR | k=1,5 | k=2,0 | k=2,5 |
|---|---:|---:|---:|
| M30 | 🔴 **27,5x** | 🔴 36,7x | 🟢 45,9x |
| H1 | 🔴 **38,9x** | 🟢 51,9x | 🟢 64,8x |

> 👉 **Sul DAX il default 1,5 NON passa se lo spread di coda è 2,70** — e a M30
> non passa nemmeno a k=2,0. **Conseguenza operativa**: il primo round parte su
> **`U30USD` e `NASUSD`**, dove il verdetto non dipende da un disaccordo
> aperto. Il DAX entra **solo** dopo che lo spread di coda è deciso, e comunque
> a `kStop ≥ 2,0` su H1.

### Frequenza attesa

🔴 **`[NON MISURATO]`, e non la invento.** Dal codice si sa solo che: una
posizione alla volta (`g_activeTicket`), `InpMaxTradesPerDay = 10` (cappello
non vincolante), e che il gate di regime **toglie** operazioni al breakout
(che da solo è una rottura di Donchian 20). **Il conto si fa in una passata
sola**: `InpForceRegime = ALWAYS_TREND` su H1, si contano i deal, si divide
per i giorni. Il pavimento è **1,00 op/giorno per FAMIGLIA** (firma 07/09),
e la famiglia qui sarebbe **3 simboli** → servono **~0,34 op/giorno/simbolo**,
che è dentro la forbice misurata dei conti veri (0,29-0,47).

### 🔎 Che cosa lo distingue da quello che abbiamo già — e la parte scomoda

🔴 **I DUE MODULI, PRESI DA SOLI, SONO NOSTRI DOPPIONI, e va detto per primo:**
- il modulo TREND (rottura di N barre + direzione della MA) **è**
  `ABTG_CanaleLento` (Donchian) con sopra il filtro di direzione di `EMA200`;
- il modulo RANGE (z-score contro la media) **è** `ABTG_MeanRevert` /
  `ABTG_BreakingBand` / `ABTG_Bulge`.

🟢 **Il NUOVO è il ROUTER, e non è cosmetico**, per tre ragioni verificate:
1. **Hurst e autocorrelazione non esistono in nessun nostro EA** (`grep`: zero
   e uno-diagnostico). Il nostro unico giudice di regime è stato l'**ADX**, ed
   è uno dei cinque filtri che hanno fatto 0/5;
2. **lo stato NEUTRAL = non operare** è un meccanismo che in casa non c'è: i
   nostri motori scelgono la direzione, non l'astensione;
3. 🥇 **il filtro È il motore, non un cerotto.** Il regime non scarta gli
   ingressi di un motore già tarato: **sceglie quale motore ha diritto di
   parlare**. È la forma che nel nostro progetto ha prodotto il miglior
   risultato di sempre (`ABTG_EMA200` Dow, R29, **30 celle su 30**), non quella
   che ha fatto 0/5.

E c'è un buco di portafoglio che tocca: **«roba che lavora nel laterale»**
(`ROBUSTEZZA`/mandato: LARRY muore lì, **−6.445 nel 2019**). Il modulo RANGE
è long **e** short per costruzione — e quasi tutte le nostre celle sono
long-only.

### 🚩 Le bandiere rosse, una per una, LETTE SUL SORGENTE

| bandiera | esito | prova |
|---|---|---|
| martingala / raddoppio | 🟢 **assente** | nessun `MathPow` su lotto, nessun `Multiplier` di volume; lotto = `InpRiskPercent` / distanza stop |
| griglia / averaging | 🟢 **assente** | **una posizione alla volta**: `g_activeTicket` singolo, nessun array di ordini |
| nessuno stop loss | 🟢 **c'è, ed è VERO** (al broker) | r.1149-1151 calcola `sl` dal **fill reale** e r.1153 `trade.PositionModify` |
| recovery / hedge | 🟢 **assente** | nessuna apertura del lato opposto |
| lotto fisso | 🟢 **assente** | `InpRiskPercent = 0.5` — % del saldo |
| repaint / look-ahead | 🟢 **assente** | r.328-333: *«all reads use shift 1, the last CLOSED bar, never the forming one»*, e `ReadBuffer` usa `CopyBuffer(..., shift, 1, ...)` |
| DLL / WebRequest / licenze | 🟢 **assenti** | zero `#import`, zero `WebRequest` |
| `iCustom` esterno | 🟢 **assente** | solo indicatori di piattaforma |
| niente sorgente | 🟢 **c'è**, 1.321 righe | scaricato e letto |

### 🔴 I TRE DIFETTI VERI, trovati leggendo (non stimati)

**1. `PositionSelect(_Symbol)` — è il difetto di classe che abbiamo GIÀ un
referto per riconoscere.** r.1138: dopo aver aperto **nudo** (r.1130:
`trade.Buy(lot,_Symbol,0.0,0.0,0.0,...)` → SL e TP a **zero**), rilegge la
posizione con `PositionSelect(_Symbol)` per prendere il fill. Su conto
**HEDGING** — e BCM e FTMO lo sono — quella chiamata seleziona **la posizione
più vecchia del simbolo, qualunque sia il magic**
(`report/AUDIT_POSITIONSELECT_HEDGING_2026-09-03.md`). 🔴 **Conseguenza qui è
peggio che nei nostri EA**: non diventa cieco, diventa **invasivo** — prende il
ticket altrui e gli fa `PositionModify`, cioè **sposta lo stop di un altro
EA**. ⛔ **Sul VPS non ci va, né così né per prova.** Nel tester da solo è
innocuo. Si ripara in una riga (`PositionSelectByTicket` sul ticket del deal).

🟢 **Ma va detto anche il contrario**, perché è raro e buono: se il
`PositionModify` fallisce, **l'EA CHIUDE la posizione** invece di lasciarla
nuda (r.1153-1162, commento dell'autore: *«An unprotected position is the one
failure mode that can end an account in a single trade»*). È la disciplina
giusta, scritta da chi sa cosa fa.

**2. 🔴 COLLISIONE DI MAGIC, e non è teorica.** `InpMagicBase = 772000` e il
magic è `base + regime id`. `grep -rhoE "7720[0-9][0-9]"` sul repo: **772001,
772002, 772003, 772026, 772060 sono GIÀ IN USO in casa.** Il default
collide **direttamente**. Prima di qualunque passata il blocco va cambiato in
uno vergine, grepato al momento. *(→ classe nuova, §7)*

**3. 45 input contro il nostro tetto di ~15.** Non è squalifica automatica ma è
**un punto in meno, scritto**. Attenuante misurabile: 11 dei 45 sono di
display/log/sessione e 5 sono il ramo `InpHurstAdaptive` (default `false`), che
si può lasciare spento. Il nucleo che decide resta ~20 — sopra il tetto lo
stesso.

### 🧪 CHE COSA LO UCCIDEREBBE — scritto PRIMA, con il numero

| # | la misura | il numero che lo ammazza |
|---|---|---|
| **K1** | 🥇 **l'ABLAZIONE, che l'autore ci regala già fatta**: 3 passate identiche con `InpForceRegime` = `AUTO`, `ALWAYS_TREND`, `ALWAYS_RANGE` | se **`AUTO` non batte il MIGLIORE dei due moduli forzati sul Recovery Factor in TUTTE E DUE le finestre**, il router non aggiunge niente → è `CanaleLento` con 45 manopole → **SCARTO**, e il costo è stato 3 passate |
| **K2** | frequenza, `ALWAYS_TREND` H1, deal / giorni | **famiglia (3 simboli) sotto 1,00 op/giorno** → fuori per pavimento |
| **K3** | peggior giornata su 100k | **oltre −5,00%** = muro giornaliero sfondato → fuori (è il muro che uccide più spesso: 18,2% contro 11,5%) |
| **K4** | campione | **sotto 150 operazioni per finestra** il MERITO non si legge (il RISCHIO sì, a qualunque n) |

**K1 è il motivo per cui questo candidato è il primo**: è l'unico dei cinque
che **si falsifica da solo in tre passate**, senza scrivere una riga di codice.
La domanda a cui risponde — *«un voto di regime aggiunge qualcosa al motore da
solo?»* — è la **sesta** misura di una serie che finora fa **0 su 5**. Se esce
0/6, quella è una legge di casa, non una delusione.

### 🏛️ In ottica prop

Porta **già dentro** due cose che noi mettiamo a mano: `InpDailyLossLimitPercent
= 3.0` (blocca i nuovi ingressi quando la perdita di giornata raggiunge il 3%
del saldo d'apertura del giorno) e `InpMaxSpreadPoints` / `InpMinTPToSpreadRatio`
(cancello di costo sul TP). 🟢 **Una posizione alla volta** = rischio aperto
massimo **un solo SL**, quindi non muove il cap C1 al 3,25%. 🔴 **Ma il cap
giornaliero al 3% è del SALDO, non dell'equity, e non conosce le altre sedie**:
sul conto vero il muro è **uno solo, quello del conto** — quel 3% va letto come
un attrezzo del singolo EA, **non** come una rete di portafoglio. La rete
resta il Guardian.

---

## 4. 🥈 PROMOSSO 2 — `Smart Loss Exit` (il meccanismo, non l'EA)

| campo | valore |
|---|---|
| **NOME** | `Smart Loss Exit — early exit for losing positions (ATR adverse excursion)` |
| **FONTE** | `https://www.mql5.com/en/code/77386` · sorgente: `https://www.mql5.com/en/code/download/77386` |
| **AUTORE / DATA** | `amul1` (`#property copyright "Amul R"`) · **2026.09.16** `[VERIFICATO]` |
| **LICENZA** | 🔴 **non dichiarata**, solo copyright · `[INCERTO]` → uso interno di ricerca |
| **RIGHE / INPUT** | 522 righe · 22 `input` |
| **COSTO DI PORTING** | 🟢 zero come EA a sé · 🟠 **~2-3 ore** per innestare la regola come `input` in un nostro motore (lavoro di EA, **non mio**) |

### Che cosa fa

Non apre **niente**. Cammina sulle posizioni aperte e **chiude in anticipo solo
quelle in perdita** quando scatta una di cinque regole: **(1)** escursione
avversa oltre `N × ATR`; **(2)** **da più di N minuti e ancora in perdita**;
**(3)** la EMA veloce ha incrociato la lenta **contro** la posizione su barra
chiusa; **(4)** RSI contro; **(5)** tetto in denaro. Ha un **grace period** e
una modalità **`InpObserveOnly`** che scrive su CSV *cosa AVREBBE chiuso*
— con regola, età del trade e **MAE** — senza chiudere nulla.

### 🔴 LA PARTE ONESTA, E VA PRIMA DELL'ENTUSIASMO

**La regola 1 NON è un meccanismo nuovo: è uno stop più stretto.** Chiudere
quando l'escursione avversa supera `1,5 × ATR` è, algebricamente, uno stop a
`1,5 × ATR`. L'unica differenza reale è che l'ATR viene **ricalcolato a ogni
barra**, quindi è uno stop che *respira* con la volatilità invece di essere
congelato al prezzo d'ingresso. È una sfumatura, non un motore. **Chi la
vendesse come "uscita nuova" starebbe vendendo il nostro stop ATR in un
vestito diverso.**

🟢 **Quello che invece NON abbiamo è la regola 2** — *«sei passato da N minuti
e sei ANCORA in perdita: esci»*. Non è riducibile a uno stop, perché **scatta
sul TEMPO, non sul prezzo**, e solo **condizionata alla perdita**. E questo è
esattamente il tipo di attrezzo che serve contro il muro del **5% giornaliero**
misurato oggi su `CostToCost` (**peggior giornata −8,01%**): tronca il sanguinamento
di una posizione che non va né allo stop né al target e si trascina verso la
chiusura. In casa il time-stop esiste in **3 motori su ~70** e **nessuno** lo
ha condizionato alla perdita.

### 🚩 Bandiere rosse, una per una

| bandiera | esito | prova |
|---|---|---|
| martingala / griglia / recovery | 🟢 assenti | **non apre nessuna posizione**, per costruzione |
| repaint / look-ahead | 🟢 assente | `ClosedBarValue(g_handles[hidx].atr)` — barra chiusa |
| tocca i vincenti | 🟢 **mai** | r.360: `if(profit>=0) continue;` — e il `profit` include **swap e commissione** |
| ⭐ `PositionSelect(_Symbol)` cieco | 🟢 **NON ce l'ha** | usa `g_position.SelectByIndex(i)` → **corretto su conto hedging**, meglio di diversi EA nostri |
| DLL / WebRequest / `iCustom` | 🟢 assenti | — |

### 🔴 I due difetti che contano per noi

1. ⛔ **`InpMagic = 0` di default = gestisce TUTTE le posizioni del simbolo.**
   Sul VPS chiuderebbe le posizioni in perdita **degli altri nostri EA**. È lo
   stesso difetto per cui il 16/08 `ProAutoSL_DynamicTP` fu fermato sul
   `SETACCIO_MANUALE`. **Sul VPS non ci va**, né così né per prova.
2. `InpMaxLossMoney` è in **valuta del conto**, non in %: non scalabile a 100k
   e non confrontabile. Se la regola 5 servisse, va riscritta in percentuale.

### 🧪 CHE COSA LO UCCIDEREBBE — scritto PRIMA

| # | la misura | il numero che lo ammazza |
|---|---|---|
| **K5** | 🥇 **la misura VERA, e non richiede di innestare niente**: si gira `InpObserveOnly = true` sui per-trade già in archivio delle sedie vive e si conta, **fra le operazioni chiuse in perdita, quante avevano superato `N × ATR` di MAE e poi sono TORNATE in profitto** | se la frazione di **recuperi** supera il punto di pareggio (recuperi × guadagno medio recuperato ≥ perdita risparmiata), la regola **costa** più di quanto salva → **SCARTO** |
| **K6** | applicata a `CostToCost`, la **peggior giornata** | se **non scende sotto −5,00%** su 100k, non serve al muro per cui è stata proposta → **SCARTO per quello scopo** (resterebbe eventualmente utile sul PF, che è un'altra domanda) |
| **K7** | il PF del motore ospite | se il PF **scende**, la regola sta tagliando i vincenti in ritardo, non i perdenti → **SCARTO** |

**K5 è un costo macchina ZERO**: la misura si fa sui CSV per-trade che abbiamo
già, non serve una passata. 🔴 **E va fatta PRIMA di scrivere una riga di
codice**, perché è la misura che può bocciare il meccanismo prima di pagarlo.

### 🏛️ In ottica prop

È l'unico dei cinque che attacca **il muro che uccide più spesso** (5%
giornaliero, 18,2% contro 11,5% nelle nostre simulazioni) invece del PF. 🔴
**Ma attenzione alla direzione dell'effetto sul DD trailing**: tagliare presto
accorcia i ritorni dal picco, e il trailing punisce proprio i lunghi ritorni
dal picco — quindi qui l'effetto atteso è **favorevole**, ma le nostre Monte
Carlo sono tutte su **DD statico dal deposito** e col trailing **non valgono**.
Da non spacciare per misurato.

---

## 5. 📚 IL PAPER CHE VALE PIÙ DI UN CANDIDATO (e non è un candidato)

**`Structural Limits of OHLCV-Based Intraday Momentum Signals in MNQ Futures:
A Systematic Falsification Study`** · Mathias Mesfin · **arXiv 2605.04004v3**,
maggio 2026 · `https://arxiv.org/abs/2605.04004v3` · 8 pagine, **letto per
intero** (PDF decodificato a mano: font CID, `cid = ascii − 29`).

**Che cos'è**: 14 famiglie di segnale intraday testate su **947 giorni** di
barre a 5 minuti di **MNQ** (Micro E-mini Nasdaq, 2021-2025), walk-forward a
finestra espansiva, con **cinque** criteri da superare insieme (T ≥ 2,0 sui
netti OOS · ≥ 30 trade per fold · netto positivo dopo attrito · direzione
coerente nei tre anni di test · permutazione p < 0,05). **Nessuna passa.**

### 🔴 Perché ci riguarda: falsifica SEI famiglie che abbiamo in casa

| famiglia loro | numero `[VERIFICATO]` sul paper | nostra famiglia |
|---|---|---|
| **ORB long, tenuta 75 min** | netto **+2,82 pt**, **T = 0,88** su 447 trade OOS | `ABTG_ORB`, `Apertura_*` |
| ORB short | netto **−2,16 / −3,45 pt**, T −0,58 / −3,16 | lato short aperture |
| ORB con **ingresso su pullback** | **80,7% di stop-out** a stop 20 punti | ingresso a retest |
| **gap fill fade** (3 orari) | netto **−1,05 / −1,92 pt**, T fra −0,26 e −0,44 | `ABTG_GapFill` |
| **gap continuation short** | lordo **+16,53**, netto **+14,52**, **T = 1,46** → bocciato per instabilità d'anno (2024: **−11,87**) e 35 trade OOS in 3 fold | `ABTG_GapContinuation` |
| **post-news drift** (993 eventi ForexFactory) | da barra +6 in poi **T fra 0,14 e 0,69**; 2025 parziale **−9,56 pt** su 12 trade | `ABTG_PostNews` (già nostra lapide 05/09) |
| OU mean reversion su **oro** (MGC) | **tutte** le configurazioni negative, T da −1,63 a −5,32; half-life **~8 ore** = incompatibile con l'intraday | mean reversion su XAUUSD |

**Undici famiglie su quattordici falliscono per un solo motivo: il lordo sta
fra 0,07 e 1,50 punti, sotto il pavimento d'attrito di 2,0 punti.**
🟢 **Che è, misurato da un altro su un altro strumento, ESATTAMENTE il nostro
cancello `stop ≥ 40 × spread`.** Una conferma esterna e indipendente che il
cancello di costo non è nostra severità: è dove sta la frontiera.

### 🥇 E il risultato che vale da solo il tempo speso — §4.2

Testando l'espansione di range in sessione Asia, l'autore trova **T = −11,52**
a barra+1, *«il risultato direzionale più forte di tutto lo studio»*: il segnale
non è nullo, **è attivamente sbagliato**. La spiegazione è meccanica, e la
misura è questa:

> mean return **apertura barra → apertura barra successiva** = **+32,24 punti**
> nella direzione dell'espansione;
> mean return **CHIUSURA barra → apertura barra successiva** = **−0,17 punti**.

👉 **Il movimento esiste tutto DENTRO la barra di rottura.** Chi entra alla
chiusura della barra compra l'esaurimento, non il movimento. 🟢 **E dà ragione
a una scelta che in casa abbiamo già fatto**: i nostri motori d'apertura
piazzano un **ordine pendente sul livello** (si arma dentro la barra), non un
market alla chiusura. **Vale come conferma, non come candidato** — e vale come
avvertimento per qualunque futuro candidato che entri `at bar close` su una
rottura.

### 🪦 E i suoi due "controlli positivi" sono SCARTI per noi

| segnale | i suoi numeri | perché per noi è SCARTO |
|---|---|---|
| **RTH Confluence** | OOS T = 3,11, netto +11,82 pt, N=196 | **GMM** (Gaussian Mixture Model) + matrice di Markov a 200 barre: in MQL5 è una **riscrittura**, non un porting. E l'autore dichiara lui stesso: **«53 o più combinazioni su sette parametri»** provate prima di congelare, baseline ATR 10,34 calcolata su tutto l'in-sample (**look-ahead ammesso**), fold W1 contaminato. **Sopra i nostri 15 input e sotto i nostri criteri** |
| **London Session Signal B** | OOS T = 4,30, netto +4,09 pt, N=247, p = 0,000025 | 🔴 **lo uccide un numero suo**: con **un solo ritardo di barra (15 min)** il T passa da **+4,30 a −2,78** — *cambio di SEGNO, non decadimento*. L'autore scrive che non si può distinguere un artefatto di confine-barra da un edge vero senza dati tick. **Un edge che muore in 15 minuti non è eseguibile da noi** |

---

## 6. 🪦 GLI SCARTI, COL MOTIVO E COL NUMERO

_Si registrano anche gli scarti: servono a non ricercarli il giro dopo._

| # | candidato | fonte | motivo dello scarto, **col numero** |
|---|---|---|---|
| S1 | **`Turn of the Month`** (Honestcowboy) | TV `PUB;5aeeea18…`, `scriptAccess: open_no_auth`, 200 agree — **sorgente letto per intero** | 🔴 **NESSUNO STOP LOSS**: `strategy.entry` poi `strategy.close` su data di calendario, zero `stop=`. Più: **~12 operazioni l'anno** → per 150 op per finestra servirebbero **12,5 anni per finestra**, e i nostri tick partono dal **2024.09.26**. Doppia bocciatura: §4 e campione |
| S2 | `Turn of the Month on Steroids` (Botnet101) | TV, 46 agree | Stesso meccanismo di S1 → **stesso scarto**, non riletto |
| S3 | **`RTH Confluence Signal`** | arXiv 2605.04004v3 §5.1 | GMM + Markov = riscrittura; **53+ combinazioni** dichiarate dall'autore; look-ahead sulla baseline ATR ammesso dall'autore |
| S4 | **`London Session Signal B`** | arXiv 2605.04004v3 §5.2 | **T da +4,30 a −2,78 con un ritardo di 1 barra** — cambio di segno |
| S5 | **`RiskGuard Lite`** (`77470`, 196 righe, **9 input**) | Code Base, mai citato in repo | 🟢 pulitissimo (ATR, rischio %, 9 input) 🔴 **DOPPIONE**: incrocio EMA 20/50 + stop ATR = `ABTG_CrossEma` / `ABTG_GoldenCross`, che abbiamo e abbiamo già misurato |
| S6 | `Aegis Quantum Lite` (`75002`) | Code Base, mai citato | 🔴 **`FixedLot = 0.01`** (lotto fisso, non scalabile a 100k) + **`StopLossPoints = 500`** (stop costante, non strutturale) |
| S7 | `VR Breakdown level` (`69545`) | Code Base, mai citato | 🔴 **`iLots = 0.01`** lotto fisso |
| S8 | `EA Trend Follower` (`77595`, 1.534 righe) | Code Base, mai citato | 🔴 griglia **e** `iCustom` (indicatore esterno non allegato → **non compila**) |
| S9 | **Blocco "guardiani di equity"**: `PropFirm Risk Guardian` (`77591`), `Prop-Firm Equity Guard` (`77350`), `Safe Risk Manager` (`76999`), `PropFirm Equity Protector` (`76437`), `Risk Guard` (`77364`) | Code Base, **tutti mai citati in repo** | 🔴 **DOPPIONI di `ABTG_Guardian`**, che fa di più: pausa B1, cap C1 al 3,25% (**vivo e acceso in tutti e due i preset**), preset FTMO 5%/10% CHIUDI+BLOCCA, tetto per cluster implementato. **Nessuno apre posizioni** → zero ingressi = niente su cui girare l'imbuto |
| S10 | Blocco "calcolatori e pannelli": `Quantora` ×4, `XPro Trade Panel`, `BEC` ×2, `One-Click Trade Manager`, `Trading Panel EA`, `Trade Manager Panel`, `Frontend EA`, `Market Replay Tool`, `Stealth Trade Manager`, `Symbol Swap Panel` | Code Base | **Non sono strategie**: non aprono posizioni per una regola. Fuori imbuto per tipo di oggetto, non per merito |
| S11 | `BreakRevertPro` (`56773`), `PulseStrike` (`77167`), `ZetaBurst` (`77220`), `002 Inside Bar` (`73884`), `003 Weekly Day Reversal` (`74137`), `AAPL cfd ORB` (`76333`), `Nikkei 225 Gap Continuation` (`75301`) | Code Base | 🔵 **GIÀ SETACCIATI**: tutti e sette compaiono in `CACCIA_SABATO_2026-09-13.md` / `CACCIA_STOP_STRUTTURALE_2026-09-13.md` / `CACCIA_APERTURE_ORO_2026-09-08.md`. **Non si ricontrolla ciò che è già stato setacciato** |
| S12 | Le 81 martingale e 32 griglie del §2 | Code Base | §4, nessuna eccezione. **Il 25,4% del catalogo** |

---

## 7. 🕳️ CHE COSA NON HO POTUTO VEDERE — dichiarato, non taciuto

1. 🔴 **GitHub: FONTE NULLA oggi.** `api.github.com/search/repositories` →
   **HTTP 403**; `gh` non installato; `recentRelayFailures` del proxy **vuoto**
   → il rifiuto è di GitHub (limite non autenticato), **non della policy di
   uscita**. ⚠️ **403 ≠ 404**: la fonte esiste e va ritentata, non cancellata.
   **Costo di questo buco**: GitHub è l'unica fonte che porta il contorno
   (`.set`, risultati, storia dei commit per vedere se l'autore ha aggiustato
   la strategia dopo aver visto i risultati). **Va riaperta al prossimo giro.**
2. 🟠 **La ricerca interna del Code Base resta in JS**: `?s=`, `?sort=` sono
   ignorati. **Si può solo scorrere l'elenco in ordine di data** — quindi
   questa battuta ha visto **le 8 pagine più recenti**, non "il Code Base".
   Le pagine 9-25 erano già state fatte il 13/09; **dalla 26 in giù nessuno ha
   mai guardato**.
3. 🟠 **TradingView è un SUGGERITORE**, non un motore di ricerca: le query
   lunghe rendono 0 risultati (`pairs spread` → 0 strategie, `session close
   exit` → 0, `lead lag` → 0). Non posso dire *«su TradingView non c'è un
   meccanismo intermarket»*: posso dire *«il suggeritore non me l'ha proposto
   con queste 18 query»*. Sono due frasi diverse.
4. 🔴 **SSRN, Quantpedia, QuantConnect e Forex Factory: NON INTERROGATE oggi.**
   Non per un errore: il tempo è finito sul Code Base e sul paper MNQ. **Vanno
   dichiarate come non fatte**, e sono il primo posto dove guardare al prossimo
   giro — SSRN in particolare, perché è l'unica che consegna **la tesi prima
   del codice**.
5. 🔴 **La frequenza di `RegimeRouter` è `[NON MISURATO]`** e senza quel numero
   il candidato non ha un posto in graduatoria: ha solo un posto in coda.
6. 🟠 **Il disaccordo di casa sullo spread di coda del DAX (1,70 vs 2,70)**
   decide da solo se il DAX entra o no nel primo round. **Non l'ho risolto**:
   l'ho aggirato proponendo `U30USD`/`NASUSD`.

---

## 8. 🔢 CLASSE NUOVA PER LA CHECKLIST

Numero grepato al momento di scrivere: la **639**.
🔴 **E il primo grep era già vecchio**: aveva dato 633, ma mentre scrivevo un
altro agente ha depositato **634, 635, 636, 637 e 638**. La classe ha rischiato
di nascere in collisione con se stessa — che è, letteralmente, il difetto che
descrive. Rigrepato prima del commit: `CLASSE 63x` repo-wide si ferma a **638**.

> **CLASSE 639 — IL MAGIC DI DEFAULT DI UN EA ESTERNO CHE COLLIDE CON UN BLOCCO
> GIÀ VIVO IN CASA: si grepa PRIMA di proporre il candidato, non alla
> compilazione** (23/09/2026, R228).
> **Il caso reale**: `RegimeRouter` (Code Base 77535) ha `InpMagicBase = 772000`
> e usa `base + regime id`. `grep -rhoE "7720[0-9][0-9]"` sul repo restituisce
> **772001, 772002, 772003, 772026, 772060 già in uso**. Un candidato
> proposto e poi compilato senza quel grep entra in campo con il magic di
> un'altra sedia: da lì in poi i per-trade si mescolano, il `TradeExporter`
> scrive sullo stesso nome di file e **l'attribuzione delle operazioni è
> persa** — cioè il difetto si manifesta **dopo**, sui numeri, non alla
> compilazione, che passa benissimo.
> **La regola**: ogni scheda di candidato esterno porta la riga *«blocco magic
> proposto: `<blocco>` — grepato il `<data>`, zero occorrenze»*. Senza quella
> riga la scheda è incompleta. Vale anche per il magic di un **preset**, non
> solo del sorgente.

---

## 9. 🎯 LA DOMANDA A CUI IL PRIMO TEST DEVE RISPONDERE

> **«Un voto di REGIME misurato su tre giudici indipendenti (ADX, Hurst,
> autocorrelazione) aggiunge qualcosa al modulo che lo stesso EA gira da solo —
> oppure è il sesto filtro che non salva un motore?»**

E la forma è già decisa dall'autore, non da noi: **tre passate identiche** su
`U30USD` H1, stessa finestra, stessi parametri, unica differenza
`InpForceRegime` = `AUTO` / `ALWAYS_TREND` / `ALWAYS_RANGE`. Recovery Factor
a confronto, **centro dell'altopiano mai il picco**, verdetto solo a tick reali.
Se `AUTO` non batte il migliore dei due forzati **in tutte e due le finestre**,
il candidato muore lì e ci è costato tre passate.

🔴 **Nessun file prova consegnato con questo dossier, ed è una scelta
dichiarata**: `RegimeRouter` non è nel nostro albero, il suo magic collide
(§8) e portarlo dentro è **lavoro di EA**, che questo mandato mi vieta
esplicitamente. Un file prova che punta a un EA inesistente sarebbe un file
che non gira. `@DAQUANDO` per gli indici a tick reali è comunque **noto e
misurato: `2024.09.26`** — non va inventato al momento del lancio.

---

## 10. 📋 RIEPILOGO PER CLAUDIO

| | candidato | fonte | costo porting | passa i 40x? | che cosa riempie |
|---|---|---|---|---|---|
| 🥇 | **RegimeRouter** | Code Base 77535, 20/09 | 🟢 **zero** (`.mq5`) | 🟢 **42,0-66,8x** su U30USD/NASUSD M30-H1 · 🔴 DAX solo se lo spread di coda è 1,70 | il **regime come motore** (mai avuto), lo **stato NEUTRAL**, il **fade simmetrico nel laterale** |
| 🥈 | **Smart Loss Exit** (regola 2) | Code Base 77386, 16/09 | 🟠 2-3 h di innesto | n/a (è un'uscita) | l'**uscita condizionata sul TEMPO** — 3 motori su ~70 hanno un time-stop, **nessuno** condizionato alla perdita |
| 📚 | paper MNQ | arXiv 2605.04004v3 | — | — | **non un candidato**: una lapide esterna su 6 nostre famiglie + il pavimento d'attrito confermato da fuori |

**Punteggio, compilato PRIMA di guardare qualunque numero di performance
dell'autore** (e nessuno dei due autori ne dichiara):

| voce (0-2) | RegimeRouter | Smart Loss Exit |
|---|---:|---:|
| semplicità (pochi input, poche regole) | **0** (45 input) | 1 |
| il filtro **È** il motore | **2** | n/a → 1 |
| tesi di mercato scrivibile | **2** | **2** |
| riempie un **BUCO** del portafoglio | **2** | **2** |
| testabile **senza riscritture** | **2** | 1 |
| **TOTALE** | **8/10 → 🟢 PROVA SUBITO** | **7/10 → 🟡 IN CODA** |

🔴 **E il vero ordine della coda lo decide un'altra cosa, non il punteggio**:
**K5 (Smart Loss Exit) costa ZERO tempo macchina** — si misura sui per-trade
già in archivio. **K1 (RegimeRouter) costa tre passate.** Se domani mattina c'è
un'ora e non una notte, si fa **K5 prima**.

---

_Fine. Zero EA scritti, zero round lanciati, zero righe verso Claudio, zero
file altrui toccati. Tutto ciò che è etichettato `[VERIFICATO]` viene da una
pagina aperta o da un sorgente scaricato in questa sessione._
