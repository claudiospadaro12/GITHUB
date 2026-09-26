# 🐻 SEDIA SHORT DOW su FTMO — la gemella al contrario della `770202`, gesto per gesto (26/09/2026)

**Scritto il 26/09/2026** · branch `lavoro` · stessa procedura della `770105` di ieri (`report/SEDIA_SHORT_DAX_FTMO_2026-09-25.md`)
🚫 **Nessun EA toccato, nessun preset esistente modificato, niente in campo.** Qui ci sono un preset nuovo,
una riga che lo porta sul terminale e i gesti a mano. **Niente parte verso Claudio prima del PASS del cancello.**
🚫 Conto reale **10105439**: compare solo per dire che **non** si tocca.

> ## 🖊️ LA FIRMA, e di chi è
> Claudio, chat del **26/09/2026**: lo **SHORT del Dow**, gemella della sedia `770202` (`ABTG_Dow_Apertura_US`,
> RETEST, solo long), **su FTMO 541452707 al 2%**, come ieri la `770105` per il DAX.
> 🔴 **La decisione e la taglia `InpRiskPercent=2.00` sono di Claudio.** Questo documento non propone
> nessun'altra taglia e non rimette in discussione la firma: mette accanto i numeri, come ieri.
> 🔴 **Entra per FIRMA, non per PROMOZIONE**: il numero misurato dice di no (§⑥). Va scritto così in ogni tabella.
> ⚪ Il testo letterale della firma è nel verbale `report/FIRME_2026-09-26.md` (commit `8b5b383f`).
> 🛑 **La riga del §⑦ NON parte verso Claudio finché lui non CONFERMA la firma con il numero di R54a davanti**
> (§⑥.2: OOS PF 0,840 su n 73, DD_fisso ~17,5% al 2%): la firma è arrivata **prima** di quel numero. Niente è in campo.

---

## ⓪ 🎯 IN UNA RIGA

**Magic nuovo `770212`** · preset `mql5/Presets/FTMO/ABTG_Dow_Apertura_US_770212_SHORT_FTMO.set` = il preset
della `770202` **byte per byte, salvo tre righe** · **stesso binario in campo** (`CLAU12_Dow_Apertura_US`) ·
**grafico NUOVO** `US30.cash` **M5** · slot del giorno, pendenti, gestione e chiusura **separati per magic**
(letto nel codice).

🟢 **La buona notizia, letta nel codice (§③.2)**: la `770202` e la `770212` hanno il **filtro EMA H4 acceso** e
lo leggono **sulla stessa candela allo stesso minuto**. Il long è ammesso solo sopra la EMA50 H4, lo short solo
sotto: **nel caso normale le due gemelle operano in giorni DISGIUNTI**. Contato nei CSV di R54a: long 74 + short
73 = due lati 147 in IS, 130 + 73 = 203 in OOS. Qui non succede quello che succede sul DAX (long e short nello
stesso giorno, uno stop dopo l'altro).

🔴 **La notizia che pesa (§⑤.2)**: lo short del Dow arma **allo stesso minuto** del Nasdaq `770260` (16:30 FTMO,
range 35, due lati, **nessun filtro di trend** — EMA spento — ma **filtro volumi acceso**, `InpUseVolumeFilter=true` nel
`.chr` vivo, `CODA_08` r.1971-2075, che può saltare la rottura). In un'apertura USA che rompe al ribasso **due short al 2% su due indici
correlati** possono entrare insieme, e il cap C1 non li ferma (gli ordini partono come pendenti).

---

## ① 🖥️ IL BERSAGLIO — detto prima di ogni cosa

| cosa | dove |
|---|---|
| **la riga del §⑦** | 🖥️ **finestra PowerShell sul VPS** `VMI3047753`. Scrive **un solo file** nella cartella dati del terminale FTMO. Non apre e non chiude nessun MT5, **non attacca niente** |
| **i gesti del §⑧** | ✋ **azione a mano dentro MT5**, **SOLO** sul terminale 🪟 **FTMO `541452707`** (cartella programma **`C:\FTMO`**) |

🚫 **NON si toccano, per nome** (elenco da `CODA_01_sedie_attaccate_20260926_033003.log` r.41-53):
- sul terminale FTMO: **i tre grafici `US30.cash` già vivi**: `chart02` M5 = **`770202`** Dow Apertura long;
  `chart04` H1 = **`771531`** EMA200, **con una posizione SHORT aperta sul weekend**; `chart05` H1 = **`770511`**
  SuperWave. E poi `770101` e `770105` (`GER40.cash` M5), `770260` (`US100.cash` M5), `770411` (`GER40.cash`
  M15), il **Guardian** `779001` (`NZDJPY`), `ABTG_TradeExporter`, `ABTG_SpreadLogger`, e il pulsante
  **Algo Trading** della barra in alto;
- sul VPS: il **REALE `10105439`** (`C:\BCM_Reale`), il **100k `50504263`** (`BCM Markets MT5 Terminal -V3`),
  il **piccolo `50503392`** (`BCM Markets MT5 Terminal`, senza `-V3`), il **manuale `50503635`**
  (`C:\MT5_MANUALE`), il **banco `50504400`** (`C:\MT5_Backtest`, **spento**: resta spento), **Pepperstone**,
  **Tickmill**.

---

## ② 🧾 IL PRESET — cosa cambia rispetto alla `770202`, e nient'altro

**File:** `mql5/Presets/FTMO/ABTG_Dow_Apertura_US_770212_SHORT_FTMO.set` · ASCII puro · committato in `8b5b383f`
(= il pin della riga). SHA256 del file al pin:
`9A6D249991B33937219F759130CF846BEC004B9234726395433CD6036A4FD3B4` (cambia solo se si tocca il file).

| riga | `770202` (long, in campo) | `770212` (short, nuova) |
|---|---|---|
| `InpAllowLong` | `true` | **`false`** |
| `InpAllowShort` | `false` | **`true`** |
| `InpMagic` | `770202` | **`770212`** |
| **tutte le altre 78** | identiche | identiche |

- 📎 **Come si verifica, a macchina**: sotto la riga `COPIA DEL PRESET 770202` il file è
  `ABTG_Dow_Apertura_US_770202_FTMO.set` (SHA256 `a6f642ec…`, ultimo commit `0127d449`). `diff` dei due file =
  **100 righe di commento aggiunte in testa** (`1a2,101`, tutte `;`) **+ esattamente tre righe vive**
  (`243,244c343,344` e `318c418`). Sulle sole righe vive: `18,19c18,19` e `81c81`.
- 🟢 **Confronto col grafico VIVO, non solo col repo**: la foto del `.chr` della `770202` su `C:\FTMO`
  (`CODA_08_preset_dai_chr_20260926_033003.log` r.1883-1970, `.chr` salvato il **25/09 20:47**) ha **81 input su
  81 uguali** al preset del repo (unico scarto di testo `2.0` contro `2.00`: stesso numero). E i nomi sono i
  **81 input del sorgente al pin `9fca63d9`, stesso ordine** (confronto meccanico, diff vuoto).
  ⚠️ Una modifica fatta a mano dopo il 25/09 20:47 **senza salvare il profilo** questa foto non la vede.
- **Resta quindi identico alla `770202`**: apertura **16:30** server FTMO, range **35** minuti, flat **19:30**,
  RETEST (`InpEntryMode=2`) con **buffer 1000** e **offset 400**, **TP1_R 1.0**, **parziale 50%** con
  **breakeven**, trailing **PREVBAR M5**, **`InpMinStopPts=500`** (`InpSkipIfTight=false`), **filtro EMA H4 1/50
  acceso**, `InpOneTradePerDay=true`, `InpUsaGuardian=true`, `InpMaxPosSimbolo=0`, **`InpRiskPercent=2.00`**.
- 📝 **Errata dell'intestazione copiata** (scritta nella testa nuova, non corretta sotto per restare byte per
  byte): *"Se FTMO e BCM cambiano nello STESSO giorno il delta resta +2"* è **falso** — BCM è UTC+1 fisso
  (`report/OROLOGIO_BCM_2026-09-24.md` §5.3). Vedi §⑥.3.

### Perché `770212`
`git grep 770212` = **0** occorrenze, `git log -S770212 --all` = **0** commit (26/09). **Non** `770206`/`770207`:
sono i magic del round **R16c** (`prove/R16c_pertrade_Dow.txt` r.41) e il per-trade
`abtg_trades_ABTG_Dow_Apertura_US_U30USD_770206.csv` è usato da `backtest_pipeline/dd_riordino_nasdaq.py` r.64
come **proxy della `770202` long**: con lo stesso magic, ogni conto per magic mescolerebbe la long di backtest con
la short in campo. `770208`-`770211` sono anch'essi già usati nel repo.

---

## ③ 🔍 LE DUE ISTANZE SULLO STESSO `US30.cash` — letto nel codice che gira davvero

### ③.1 Quale codice
Sul terminale FTMO gira **`CLAU12_Dow_Apertura_US`**, compilato il **20/09 16:58**
(`CODA_06_quale_codice_gira_20260926_033003.log` r.211; gli `ABTG_*` in `C:\FTMO` **non hanno `.ex5`**, r.184).
È la copia rinominata di `ABTG_Dow_Apertura_US.mq5` al pin **`9fca63d9`** (`report/SCHIERAMENTO_FTMO_2026-09-20.md`
r.181), **2205 righe** (CODA_06 ne conta 2206: lo scarto +1 di tutti i file). A HEAD il sorgente è **identico**
al pin (`git diff 9fca63d9 HEAD` vuoto). **Non serve nessun F7**: si attacca lo stesso EA una seconda volta.

### ③.2 🟢 Il filtro EMA H4 sul lato SHORT — la regola esatta (righe al pin `9fca63d9`)
| riga | cosa fa |
|---|---|
| r.403-411 | crea `iMA(_Symbol, InpFilterTF=H4, 1, …, MODE_EMA, PRICE_CLOSE)` e `iMA(…, 50, …)`; se non si creano → `INIT_FAILED` (l'EA non parte) |
| r.1495-1502 | `TrendBias()`: `CopyBuffer(…, 0, 1, 1, …)` = **ultima candela H4 CHIUSA**; `e = (EMA1 > EMA50) ? +1 : (EMA1 < EMA50 ? -1 : 0)` |
| r.620-621, r.654-658, r.1281 | il bias si legge **UNA volta**, all'armamento: `rangeEndMin = 16:30 + 35` = **17:05 server FTMO**; vale per tutto il giorno |
| r.1308 / r.1309 | `longOK = (gBias == 0 \|\| gBias == +1)` · `shortOK = (gBias == 0 \|\| gBias == -1)` |
| r.1345 | `SELL LIMIT` solo se `InpAllowShort && shortOK && !gBrokeLow && bid <= sellTrig` |

> 🔴 **REGOLA: lo SHORT è ammesso solo se la CHIUSURA dell'ultima H4 chiusa è SOTTO la EMA50 H4 della stessa
> candela** (EMA di periodo 1 = la chiusura stessa). Il long della `770202` solo se è **sopra**.

- 🟢 **Conseguenza**: le due istanze leggono **lo stesso simbolo, lo stesso TF, la stessa candela, allo stesso
  minuto**: il bias è +1 **oppure** −1, quindi nel caso normale **una sola delle due arma** quel giorno. Lo
  conferma il conteggio sui CSV di R54a (`risultati_archivio/csv_r54/*_r54a.csv`): **74 + 73 = 147** (IS) e
  **130 + 73 = 203** (OOS) sono esattamente i Trades della cella a due lati.
- ⚠️ **I residui, dichiarati (nessuno misurato)**: (1) **fail-open** — se EMA1 = EMA50 o se `CopyBuffer`
  fallisce, `e` resta 0 e il bias resta **0 = filtro NON applicato**: lo short passa senza filtro (r.1498-1501) e
  in quel giorno possono armare **tutte e due**; (2) **armamenti in ore diverse** — un'istanza attaccata o
  riavviata dopo le **20:00 server** legge un'**altra** candela H4 (la 16:00-20:00) e può avere un bias
  diverso dalla gemella; (3) i due preset che smettono di essere identici. Nei casi (1)-(3) vale la geometria
  a specchio del DAX: lo stop del long (`sellTrig`, r.1303, = `sellPx` r.1305, SL del BUY RETEST a r.1320) è il livello che arma lo short, e viceversa.
- 🕰️ **Quale candela, in campo e nel backtest** (non misurato quanto conti): in campo FTMO alle 17:05 la H4
  chiusa è la **12:00-16:00 server** (chiude alle **15:00 italiane** d'estate); nel backtest BCM alle 15:05 era
  la **08:00-12:00 BCM** (chiude alle **13:00 italiane**). È lo stesso rilievo già scritto nel preset `770202`
  r.40-47, e vale identico per lo short.

### ③.3 Cosa condividono e cosa no
| stato | dove (pin `9fca63d9`) | condiviso? |
|---|---|---|
| **slot del giorno** (`InpOneTradePerDay`) | `HaGiaOperatoOggi()` r.727-748: deal di **ENTRATA** del giorno filtrati per **simbolo + `DEAL_MAGIC == InpMagic`** (r.744); guardia r.581 | 🟢 NO: ogni magic ha il suo giorno |
| guardia anti-duplicato al riavvio | r.547-555: pendenti e posizioni **del proprio magic** | 🟢 NO |
| pendenti / OCO | `CancelMyPendings()` r.1664-1671, `ORDER_MAGIC` | 🟢 NO |
| posizioni gestite (parziale, BE, trailing) | `ManagePosition()` r.1694-1706, `POSITION_MAGIC` | 🟢 NO |
| chiusura di fine sessione / news | `ChiudiMiePosizioni()` r.1991-1999: **per TICKET** fra le proprie (toppa 19/09, r.1934-1938) | 🟢 NO |
| variabili (`gPhase`, `gBias`, range, ticket…) | globali del programma: **una copia per grafico** | 🟢 NO |
| GlobalVariable | l'EA **non ne scrive**; l'include in campo (v1.20, pin `26a18566`) **legge** quelle del Guardian, per CONTO | 🟢 condivise **apposta**: pausa B1 e cap C1 valgono per tutto il conto |
| tetto per simbolo contando tutti gli EA | `InpMaxPosSimbolo=0` in tutti e due (r.635-638) | 🟢 spento; **non va acceso**: si conterebbero a vicenda (e conterebbero `771531`/`770511`) |
| **commento degli ordini** | `ABTG_DEF_NAME+" RETEST BUY"` (r.1335) / `" RETEST SELL"` (r.1368) = **`Dow Apertura US RETEST SELL`** | 🟢 si distinguono: la long scrive solo BUY |

🟠 **Per leggere i log**: il prefisso nella scheda Esperti è **`[Dow Apertura US]`** per **tutte e due**
(`ABTG_DEF_NAME`, r.57; `ABTGLog` r.381-385) e l'intestazione è `CLAU12_Dow_Apertura_US (US30.cash,M5)` per tutte
e due. Si distinguono dal **contenuto**: `lati=SOLO SHORT` / `SOLO LONG`, `RETEST SELL` / `RETEST BUY`.

---

## ④ ⚖️ LE REGOLE FTMO — cosa dicono i documenti

### ④.1 Posizioni opposte sullo STESSO conto — ✅ ammesse per iscritto
Supporto FTMO, 24/09/2026 (`docs/RISPOSTA_SUPPORTO_FTMO_2026-09-24.md`): *«We allow hedging within the same
trading account on our platform.»* Per il §③.2 la coppia `770202`+`770212`, nel caso normale, **non** tiene
posizioni opposte insieme. Sul conto però esistono già sedie a due lati sullo stesso `US30.cash` (`771531`,
`770511`): posizioni opposte sullo stesso simbolo sono possibili da prima di questa sedia.

### ④.2 🔴 Posizioni opposte fra conti DIVERSI — vietate
Supporto FTMO, 25/09/2026 (`docs/RISPOSTA_SUPPORTO_FTMO_2026-09-25.md`): *«cross-hedging can also involve
correlated instruments, not only the exact same symbol. For example, long DAX on one account and short Dow Jones
or Nasdaq on another»*. 👉 **Con la `770212` aperta, una qualunque posizione LONG su Dow, DAX o Nasdaq in un
altro conto** (REALE `10105439`, 100k `50504263`, piccolo `50503392`, manuale `50503635`, Pepperstone, Tickmill —
**demo compresi**) **è la fattispecie vietata**.
- 🟢 **Misurato stanotte** (`CODA_01_sedie_attaccate_20260926_033003.log`): nei **profili attivi** dei terminali
  del VPS **zero sedie indice** fuori da FTMO — piccolo 25 sedie (nessuna su U30USD/D30EUR/NASUSD/225JPY),
  100k 2 (TradeExporter, Guardian), REALE 3 (SlippageLogger, Guardian, ORB EURAUD), manuale 1 (XAUUSD),
  Pepperstone 0, Tickmill 2 (XAUUSD, USDJPY).
- ⚠️ Il piccolo è loggato **anche sul PC di backtest** (classe 792): quel conto si verifica dallo **Storico lato
  server**, non dal VPS. E i **pendenti già piazzati** prima delle sospensioni non stanno nei `.chr`.

### ④.3 🟠 «Esposizione cumulata sullo stesso simbolo o simboli correlati»
Con la `770212` le sedie su `US30.cash` diventano **quattro** (`770202` long, `771531` e `770511` a due lati,
`770212` short). Nello **stesso verso short** possono stare aperte insieme `770212` + `771531` + `770511` sullo
stesso simbolo, e `770105` + `770411` (DAX) + `770260` (Nasdaq) sui correlati. Il documento del 20/09
(`docs/REGOLAMENTO_FTMO_2026-09-20.md` §④) chiama il cap C1 *«la difesa contro questa regola»*; la sanzione
descritta è gradata. **Fatto da sapere, nessuna decisione qui.**

### ④.4 Le 2.000 richieste al giorno — la raffica di modify è ancora viva
Il ramo SELL del trailing della `770212` (r.1820-1824 al pin) ha **lo stesso difetto a specchio** del DAX:
`newSL = iHigh(M5, 1)` (r.1848) è confrontato con lo stop e con l'ingresso, **mai con l'Ask**. `US30.cash` su FTMO ha
`StopsLevelPts=0` (`PREVOLO_FTMO_specifiche_2026-09-20.csv` r.41): se al riempimento del SELL LIMIT il massimo
della M5 precedente sta **sotto l'Ask**, la modify è rifiutata a **ogni tick** fino alla chiusura della candela.

Ricalcolo del referto `report/MODIFY_A_RAFFICA_FTMO_2026-09-25.md` §2 (≤ 657 richieste per sedia a candela intera
al ritmo medio misurato di 2,19/s — **tetto INFERITO**):

| sedie d'apertura sul conto (stesso difetto) | caso peggiore teorico, stesso giorno | contro 2.000 |
|---|---:|---|
| 3 (`770101`, `770202`, `770260`) — il referto | ≤ ~1.971 | sotto |
| 4 (+ `770105`, ieri) | ≤ ~2.628 | 🔴 sopra |
| **5 (+ `770212`), aritmetica nuda** | **≤ ~3.285** | 🔴 sopra |
| **5, con il §③.2** (`770202` e `770212` non operano lo stesso giorno) | **≤ ~2.628** | 🔴 sopra, ma **uguale a ieri** |

👉 Nel caso normale la `770212` **non alza** il caso peggiore dello stesso giorno (prende il posto della `770202`);
lo alza a ~3.285 solo nei residui del §③.2. Al ritmo **massimo** misurato (~12/s) basta **una** sedia per ~3.660.
Probabilità **bassa**, conseguenza **[NON VERIFICATA]** (non è verificato se il rifiuto conti come richiesta al
server, né l'unità del limite).
🟠 **La TrailFix** (`backtest_pipeline/righe/RICOMPILA_CLAU12_TRAILFIX_LEGGIMI.md`, **IN CODA**) ricompila anche
`CLAU12_Dow_Apertura_US`, quindi coprirà la `770212`. Due cose da sapere: (1) il suo prerequisito 1 elenca
**R254 NEUTRA su 4/4** (`770101`, `770105`, `770202`, `770260`) e dice *"nessuno per analogia"*: con la `770212`
il binario del Dow serve **due** sedie come quello del DAX, quindi la `770212` è una quinta verifica **che oggi
non c'è**; (2) la ricompilazione ricarica **tutti e due** i grafici Dow M5: si fa **senza posizioni aperte** né
della `770202` né della `770212` (weekend).

---

## ⑤ 🛡️ IL CONTO CON UNA SEDIA IN PIÙ AL 2% — solo numeri

**Guardian in campo** (`mql5/Presets/ABTG_Guardian_FTMO_2Step.set` = `chart06` di `C:\FTMO`):
`InpStartBalance=80000` · pausa giornaliera **3,5%** (2.800 €) · emergenza giornaliera **4,5%** (3.600 €) ·
emergenza totale **9,3%** (72.560 €) · cap rischio aperto **4,00%** (C1). Muro FTMO: giornaliero **5%** (4.000 €),
totale **10%** statico (72.000 €).

**Punto di partenza** [MISURATO, MetriX 26/09 09:15, `report/NOTTE_2026-09-26.md`]: saldo **75.090,72 €**, equity
**75.049,72 €** con la posizione **#170709416 SELL 4,84 `US30.cash`** della `771531` aperta sul weekend.
La taglia è il 2% del **SALDO** all'ordine (`CalcLotByRisk` r.1622-1625): **1.501,81 €** oggi.

### ⑤.1 La distanza che conta: l'emergenza TOTALE del Guardian
| | € |
|---|---:|
| dal saldo ai 72.560 | **2.530,72** = **1,69 stop** al 2% |
| dall'equity ai 72.560 | 2.489,72 |
| dal saldo al muro FTMO 72.000 | 3.090,72 (dall'equity 3.049,72 = la "perdita consentita" di MetriX) |

🔴 **Due stop al 2% nello stesso giorno o in fila** (1.501,81 + 1.471,78 … 1.501,81 = **2.973,59 … ~3.003,6 €**)
**superano** i 2.530,72: arriva prima l'**emergenza del Guardian**, che chiude tutto a 72.560 e ferma la
challenge (latch `GV_FAILED`, classe 796). È lo stesso esito di `TERZO_STOP` §3 e della `770105`: la `770212` è
**una strada in più** per arrivarci.

### ⑤.2 🔴 La correlazione NELLO STESSO VERSO — dove la `770212` cambia davvero il quadro
| coppia che può stare aperta insieme, stesso verso | quando | cosa la ferma |
|---|---|---|
| **`770212` + `770260` Nasdaq short** | **stesso minuto**: 16:30 FTMO + 35, due indici USA che rompono al ribasso insieme | **niente**: tutti e due entrano per **SELL LIMIT** piazzato alla rottura, e il cap C1 guarda il rischio delle **posizioni** già aperte (`ABTG_PausaGuardian.mqh` v1.20 r.27-30: *"un ordine PENDENTE già piazzato quando il cap era libero scatterà lo stesso"*) |
| `770212` + `771531` EMA200 Dow short | la EMA200 è a due lati su H1: col Dow sotto la EMA50 H4 lo short è il suo verso più probabile [INFERITO] | cap C1 solo se il rischio aperto è già ≥ 4,00% |
| `770212` + `770105` / `770411` DAX short | le due DAX restano aperte fino alle **19:30 FTMO** (`InpCloseHour=19`, `InpCloseMin=30` nei due preset): coprono tutta la finestra USA | idem |

- **Due posizioni al 2% insieme** (es. `770212` + `770260`): **~3.003,6 €** allo stop = **3,75% dei 80.000** → sopra la
  pausa (2.800) e **sopra l'emergenza totale** (2.530,72). **Un solo movimento avverso all'apertura USA**
  basta a fermare la challenge.
- **Il cap C1 al 4,00%**: blocca un ingresso nuovo solo se il rischio aperto è **già ≥ 4,00%**. Esempio aritmetico
  [DERIVATO]: `771531` con tutte e due le gambe (4,84 + 7,27 lotti, SL comune 51.993,81 → **~1.489 €**, ~1,98%) +
  `770105` (2,00%) = **~3,98% < 4,00** → la `770212` **entra** → **~5,98%** in campo nello stesso verso (~4.490 €).
- **Oggi, dal weekend** [DERIVATO a 0,86-0,871 €/pt/lotto, SL non riverificato]: la `771531` short aperta rischia
  **734,54-743,93 €** (0,98-0,99% del saldo). Se lunedì va a stop, il saldo scende a **~74.347-74.356**; uno stop
  successivo della `770212` (2% = ~1.487 €) lascia **~300-309 €** dall'emergenza totale. Il gap di riapertura
  (domenica sera) può superare lo SL.
- 🔴 **Quanto spesso capiterà, e quanto costa in probabilità di passare, è `[NON MISURATO]`**: il Monte Carlo
  dallo stato di oggi (`report/MC_DALLO_STATO_DI_OGGI_2026-09-25.md`) **non contiene né la `770105` né la
  `770212`**, e `mc_challenge_ftmo_stato.py` (r.216-223) conosce solo `770202 Dow` per il lato USA.

---

## ⑥ 📜 IL CONTRATTO DICHIARATO DELLA `770212` — e il numero che dice di no

### ⑥.1 L'interruttore — REGISTRO_TEST r.4035-4042
`ptc` sul Dow (`risultati_prove/ABTG_Dow_Apertura_US/..._{IS,OOS}_ptc.csv`), deposito 100.000, rischio 1%,
**EMA H4 1/50 acceso**, tre range: passando da solo long a due lati l'**OOS** perde
**−3.281,45 / −2.795,08 / −6.009,51** (range 25/35/45), con IS **positivo su 3 su 3**. È un fallimento di
coerenza dei segni su tutto l'asse (`report/ALLARGARE_LA_ROSA_2026-09-19.md` §3.2).
🟢 **E per il §③.2 qui il numero è più pulito che sul DAX**: coi giorni disgiunti la differenza fra due lati e
solo long **è quasi tutta lo short**.

### ⑥.2 Lo short da solo — R54a (la misura diretta)
`risultati_archivio/csv_r54/ABTG_Dow_Apertura_US_U30USD_{IS,OOS}_r54a.csv`, **SOLO SHORT**, U30USD M5 **BCM**, tick
reali, deposito **100.000**, rischio **1%**, EMA H4 1/50 acceso, range 35, armamento **14:30 BCM tutto l'anno**,
gemelle `772601`/`772602` identiche:

| gamba | finestra | n (Trades) | Profit | PF | EqDD % | DD_fisso |
|---|---|---:|---:|---:|---:|---:|
| IS | 2024.09.26-2025.06.09 | 73 | **+6.463,44** | **1,511** | 2,68 | 2,79% |
| OOS | 2025.06.10-2026.06.30 | 73 | **−2.591,58** | 🔴 **0,840** | 8,62 | **8,76%** |

(DD_fisso = Profit / Recovery Factor / deposito, come in `prove/R255a_short_DOW_ancora_1430.txt` r.50-53.)
- 🔴 **Alla taglia firmata (2,00%)** il DD_fisso OOS scala a **~17,5% (17,53%)** — **LIMITE SUPERIORE**, scala
  lineare (classe 547). Il muro FTMO è il **10% statico**.
- 🔴 **Campione**: 73 operazioni per gamba, **sotto le 150** della regola A: il **merito** è sospeso, il
  **rischio** no. E il segno si **ribalta** fra IS e OOS (il "28° ribaltamento" di `REFERTO_ROUND54_LATI_DOW.md`).
- 🪑 **Corsia RISCHIO del criterio di uscita** (firma del 18/08): il DD promesso da confrontare col forward è quello
  di questa tabella alla taglia vera, ~17,5% limite superiore. ⚠️ **Contro il muro del 10% quella corsia non
  scatterà mai prima del muro** (come per la `770105`): chi sorveglia la sedia deve saperlo.

### ⑥.3 🕰️ L'orologio — FTMO è in fase, il contratto no
- Preset `770202` r.35-36: `InpSessionHour 14 → 16`, `InpCloseHour 17 → 19` = **15:30 italiane = 14:30 BCM
  d'estate = 16:30 FTMO**. FTMO è **ora italiana +1 tutto l'anno** (`docs/REGOLAMENTO_FTMO_2026-08.md` r.130:
  GMT+2 inverno / GMT+3 estate) → **16:30 FTMO = apertura di Wall Street tutto l'anno**, *se* FTMO segue il
  calendario europeo (`report/OROLOGIO_BCM_2026-09-24.md` §5.3).
- BCM invece è **UTC+1 fisso**: R54a d'inverno armava alle 14:30 BCM = **8:30 di New York, un'ora prima della
  cash**. Il contratto qui sopra **mescola due tempistiche**; in campo FTMO la sedia arma **sempre** all'apertura.
  Sulla gemella long lo stesso taglio vale **PF 0,78 (n 73) nei mesi in fase contro 1,66 (n 57) in quelli
  sfasati** (`OROLOGIO_BCM` §5.1.1). **Per lo short la divisione è `[NON MISURATA]`**: la misura R255.
- ⚪ **Settimana 26/10-30/10/2026**: Europa già in ora solare, USA ancora in ora legale → la sedia arma alle
  **10:30 di New York**, un'ora tardi, per cinque sedute **[NON MISURATO]**. Da mettere in calendario come per la
  `770202`.

### ⑥.4 Cosa NON è misurato — R255
`backtest_pipeline/prove/R255a_short_DOW_ancora_1430.txt` (+ `R255_GENERA.py`, `r255_attese.py`), **in
preparazione**, misura sullo short Dow quello che manca al certificato: **(1)** la gestione dell'uscita (parziale,
TP1_R, trailing); **(2)** un filtro di regime diverso dall'EMA (Supertrend H4..D1); **(3)** l'EMA spento;
**(4)** l'orologio in fase con la cash tutto l'anno. **Il contratto del §⑥.2 può cambiare con quella misura**, in
un verso che oggi non si conosce. Per il certificato lo short dell'apertura Dow resta **NON ANCORA MISURATO**, non
morto.

---

## ⑦ 📦 COME ARRIVA IL PRESET SUL TERMINALE — una riga, come ieri

> # 🖥️ **BERSAGLIO: finestra PowerShell sul VPS `VMI3047753`.** Nessun MT5 da aprire o chiudere.
> Scrive **UN SOLO file** (`ABTG_Dow_Apertura_US_770212_SHORT_FTMO.set`) in `MQL5\Presets` della cartella dati del
> terminale **FTMO `541452707`** (`C:\FTMO`, cartella dati `46C9F8E9FF0C747B2B5E09BCC13D5237`). **Non attacca
> niente**: l'attacco è a mano (§⑧).
> 🚫 **NON tocca**: i grafici `US30.cash` già vivi (`770202` M5, `771531` H1 con la posizione aperta, `770511` H1), le
> altre sedie FTMO (`770101`, `770105`, `770260`, `770411`), il Guardian `779001`, `ABTG_TradeExporter`,
> `ABTG_SpreadLogger`, il pulsante **Algo Trading**, il REALE `10105439` (`C:\BCM_Reale`), il 100k `50504263` (`-V3`), il piccolo
> `50503392`, il manuale `50503635` (`C:\MT5_MANUALE`), il banco `50504400` (`C:\MT5_Backtest`), Pepperstone,
> Tickmill. Il terminale FTMO **può restare aperto**.

File: `backtest_pipeline/righe/RIGA_PRESET_SHORT_DOW_FTMO.txt` (una riga, ASCII). **Pinnata il 26/09** (commit
`05dd5628`): pin `8b5b383f4903c8c469846e1766dd05e1b5fc0fee`, SHA256 `9A6D2499…6A4FD3B4` (per intero nel §②). La riga **non** è ricopiata qui: la fonte è una sola, il file.

Cosa fa, in ordine (identica alla riga della `770105`, cambiano nome, marcatore e righe chiave):
guardia macchina `VMI3047753` → TLS 1.2 → banner BERSAGLIO + NON TOCCATI → cartella dati `46C9F8E9…` con
`origin.txt = C:\FTMO` → conto `541452707` nei 10 giornali più recenti → `MQL5\Presets` deve esistere (non la
crea) → scarico dal pin → marcatore `MARCATORE_PRESET_SHORT_DOW_FTMO_v1` → SHA256 → **righe chiave**
(`InpMagic=770212`, `InpAllowLong=false`, `InpAllowShort=true`, `InpRiskPercent=2.00`, `InpSessionHour=16`,
`InpSessionMin=30`, `InpCloseHour=19`, `InpCloseMin=30`, `InpOneTradePerDay=true`, `InpUsaGuardian=true`,
`InpUseEmaFilter=true`, `InpEmaFast=1`, `InpEmaSlow=50`, `InpFilterTF=16388`) → se il file c'è già: identico = niente,
diverso = **non sovrascrive** → copia e **rilettura dello SHA dal disco** → `ESITO: FATTO` / `FERMATO`.

⏱️ **~2-3 secondi.** Sul **Desktop del VPS**: cartella `PRESET_SHORT_DOW_FTMO_<data>` e lo zip accanto. **File
attesi dentro**: `REFERTO.txt` e `ABTG_Dow_Apertura_US_770212_SHORT_FTMO.set`. Ultima riga: `ESITO: FATTO` (o
`FATTO (gia presente)` al secondo lancio).

### ⑦.1 Le serrature, e i contro-esempi ESEGUITI (pwsh 7 su albero finto con l'esca del REALE)
| # | caso | esito | file scritti nel terminale FTMO |
|---|---|---|---|
| **A** | albero giusto | 🟢 `ESITO: FATTO`, SHA riletto dal disco = atteso, zip con i 2 file | **1** |
| **B** | secondo lancio di fila | 🟢 `GIA IDENTICO`, `FATTO (gia presente)` | invariati |
| **C** | file con lo stesso nome **ma diverso** già nel terminale | 🟢 **non sovrascritto**, copia nello zip, `FERMATO` | invariati |
| **D** | `origin.txt` = **`C:\BCM_Reale`** | 🟢 `VIETATO`, `FERMATO` | **0** |
| **E** | giornale con `5414527070` invece di `541452707` | 🟢 rifiuta | **0** |
| **F** | manca `MQL5\Presets` | 🟢 rifiuta, **non la crea** | **0** |
| **G** | macchina `DESKTOP-H4D7CAJ` (PC di backtest) | 🟢 muore **prima** di scaricare o creare qualunque cosa | **0**, niente sul Desktop |
| **H** | segnaposto **`NUOVOSHA` lasciato** nella riga | 🟢 `IMPRONTA DIVERSA`, rifiuta | **0** |
| **I** | preset senza marcatore (file vecchio) | 🟢 `FILE VECCHIO`, rifiuta | **0** |
| **J** | preset **sbagliato con SHA coerente** (`InpMagic=770202`) | 🟢 `il preset non contiene la riga InpMagic=770212`, rifiuta | **0** |

🟢 In **tutti** i casi la cartella dati **esca del REALE** (`E23E1504…`, col conto FTMO nel giornale apposta) ha
avuto **zero** file scritti. Il download era **simulato** alla prima stesura; dopo il push l'URL costruito
dalla riga risponde **HTTP 200** e il file scaricato ha lo SHA256 atteso (cancello di giudizio, 26/09). URL: `…/8b5b383f…/mql5/Presets/FTMO/ABTG_Dow_Apertura_US_770212_SHORT_FTMO.set`.
⚠️ **Limiti dichiarati**: banco **pwsh 7 su Linux**, il VPS ha **Windows PowerShell 5.1** (parse 0 errori, nessun
costrutto solo-pwsh-7 aggiunto rispetto alla riga di ieri, che su 5.1 **è girata**: zip del 25/09 20:45:34);
HTTP 200 dal pin vero **provato** dopo il push (vedi sopra).

### ⑦.2 Il cancello deterministico
`controlla_riga.py --riga` sul file pinnato, nel repo vero a `05dd5628` (rilanciato dal cancello di giudizio il 26/09):
**rc 0**, 6 verdi (ASCII, pin vero, marcatore controllato, marcatore **presente al
pin nel file giusto**, macchina inchiodata, raccolta). **Un rilievo, 671**: `C:\MT5_Backtest` compare **nella lista
dei NON toccati**. Col pin di un commit che **non** contiene il file il cancello dà **FAIL 187** (404): è il
comportamento giusto, e ricorda che **il pin va scritto dopo il commit**. Come ieri: la cartella in cui la riga
scrive (FTMO) **non passa da un flag `-Terminal`**, quindi il bersaglio vero lo giudicano le serrature del §⑦.1 e
lo **strato 2**.

---

## ⑧ ✋ I GESTI A MANO — sul terminale 🪟 FTMO `541452707` (`C:\FTMO`), e SOLO lì

### Passo 0 — riconoscere la finestra (sola lettura)
🖥️ **Finestra PowerShell sul VPS `VMI3047753`.** Non tocca niente: stampa PID, titolo e cartella di ogni MT5 aperto.
```powershell
Get-Process terminal64 | Select Id, MainWindowTitle, Path | Format-List
```
Il terminale giusto è il blocco con **`541452707`** nel titolo e **Path che comincia con `C:\FTMO`**. Se non c'è
un blocco così (o `Path` è vuoto), **ci si ferma** e mi si manda l'output.

### ⏰ QUANDO attaccarla — fuori dalla sessione
🔴 **Non fra le 16:30 e le 19:30 server FTMO (15:30-18:30 italiane).** Letto nel codice: se l'EA parte dopo le
17:05 server, arma **subito** sul range del giorno (r.654-658) e, se il prezzo è già sotto il livello, piazza il
SELL LIMIT **adesso**: un ingresso che il backtest non ha misurato. E dopo le 20:00 server leggerebbe un'altra
candela H4 (§③.2). **Oggi (sabato), domani, o lunedì prima delle 15:30 italiane** va bene.

### I passi
| # | gesto | ✅ come si vede che è andata |
|---|---|---|
| **1** | ▶️ la riga del §⑦ (PowerShell sul VPS, **dopo la conferma di Claudio col numero di R54a davanti**) | ultima riga `ESITO: FATTO` |
| **2** | nel terminale FTMO: **File → Nuovo grafico → `US30.cash`**, poi timeframe **M5** | un grafico `US30.cash` **in più**; i tre già vivi restano com'erano |
| **3** | dal **Navigatore → Expert Advisors**, trascinare **`CLAU12_Dow_Apertura_US`** sul grafico **nuovo**. 🔴 **MAI su uno dei tre `US30.cash` già vivi**: MT5 tiene UN solo EA per grafico e il trascinamento **LO SOSTITUISCE** senza errori. Su `chart02` sparirebbe la `770202`; su `chart04` sparirebbe la `771531` e la sua **posizione short aperta** resterebbe senza gestione (il magic `770212` non la conosce) | si apre la finestra delle proprietà dell'EA |
| **4** | scheda **Input → Carica** → `ABTG_Dow_Apertura_US_770212_SHORT_FTMO.set` | nella lista: **`InpMagic` = 770212**, **`InpAllowLong` = false**, **`InpAllowShort` = true**, **`InpRiskPercent` = 2.0**, `InpSessionHour` = 16, `InpSessionMin` = 30, `InpCloseHour` = 19, **`InpUseEmaFilter` = true**, `InpFilterTF` = H4 |
| **5** | scheda **Comune**: spunta **"Consenti trading algoritmico"** → **OK** | — |
| **6** | il pulsante **Algo Trading** in alto dev'essere **già verde**. 🔴 **Non premerlo**: lo spegneresti per **tutte** le sedie | resta verde |
| **7** | la **faccina** in alto a destra del grafico nuovo | 🙂 (se è triste/grigia, rifare il passo 5) |

### ✅ Verifica: tutte e due vive
- **Scheda Diario (Journal)**: `expert CLAU12_Dow_Apertura_US (US30.cash,M5) loaded successfully`, e **nessun**
  `removed` subito dopo.
- **Scheda Esperti**: subito dopo l'attacco compaiono le righe `[Dow Apertura US]`; quella di controllo deve dire
  **`lati=SOLO SHORT`** e **`rischio=2.00%`**:
  `[Dow Apertura US] avviato su US30.cash. Apertura server 16:30, range 35 min, flat 19:30.`
  `[Dow Apertura US] CONFIG IN USO -> motore=ABTG_RETEST | ... | lati=SOLO SHORT | rischio=2.00% | ...`
  ⚠️ Anche la `770202` scrive righe `[Dow Apertura US]`, con `lati=SOLO LONG`. Se sul grafico **nuovo** leggi
  `SOLO LONG` o `long+short`, il preset non è stato caricato: rifare il passo 4.
- **Qual è quale**: tasto destro sul grafico → **Expert Advisors → Proprietà → Input**: `InpMagic` **770202** su uno,
  **770212** sull'altro. E che la `770202` ci sia **ANCORA** (`InpAllowLong` true), e che su `chart04` ci sia ancora
  **`CLAU12_EMA200`** con `InpMagic` 771531.
- ⚠️ L'ora delle righe di Diario/Esperti è **ora del PC del VPS (italiana)**, non ora server.
- **La notte dopo**: `CODA_01` deve mostrare in `C:\FTMO` la riga `CLAU12_Dow_Apertura_US US30.cash M5 magic 770212
  rischio 2.00 lati SOLO SHORT` accanto a quella della `770202`. Se manca, il `.chr` non è ancora sul disco
  (**è successo con la `770105`**: attaccata alle 20:47 del 25/09, assente dal `CODA_01` del 26/09, verificata dal
  giornale, commit `c44370b7`). La conferma allora è la riga di giornale, sul modello di
  `RIGA_VERIFICA_770105_FTMO_VPS`.
- **Nello Storico, quando opererà**: commento **`Dow Apertura US RETEST SELL`**.

### ↩️ Rollback
1. Tasto destro sul grafico **nuovo** → **Expert Advisors → Rimuovi** (oppure chiudere il grafico nuovo). **Non**
   toccare i tre `US30.cash` già vivi.
2. 🔴 Togliere l'EA **non cancella** ordini e posizioni sul server: un SELL LIMIT pendente ha **SL, TP e scadenza
   di 120 minuti**; una posizione aperta resta con **SL e TP sul server** ma **senza** parziale, trailing e
   chiusura delle 19:30. Il rollback si fa **quando la `770212` non ha niente di vivo** (nessuna riga col commento
   `RETEST SELL` nelle schede Operazioni); se c'è, decide Claudio.
3. Il `.set` nella cartella Presets può restare: senza EA sul grafico non fa niente.

---

## ⑨ ⚪ COSA RESTA APERTO — dichiarato, non nascosto

1. 🔴 **Il contratto dice di no**: R54a OOS PF **0,840** su 73, DD_fisso ~17,5% al 2% (limite superiore) contro un
   muro del 10%; l'interruttore ptc ribalta il segno su 3 range su 3. La sedia è in campo per **firma**.
2. 🔴 **La coppia short `770212` + `770260` allo stesso minuto** (§⑤.2): due stop insieme superano l'emergenza
   totale; il cap C1 non li ferma perché entrano per pendente. **Frequenza `[NON MISURATA]`.**
3. 🔴 **Monte Carlo con la `770105` e la `770212`: `[NON MISURATO]`.**
4. 🔴 **Conferma della firma con R54a davanti: MANCA.** Il verbale `report/FIRME_2026-09-26.md` c'è (commit `8b5b383f`) e
   dice che la firma è arrivata **prima** del numero: finché Claudio non conferma, la riga non parte e niente va in campo.
5. 🟠 **TrailFix**: la `770212` non è nell'elenco R254 "4/4" (§④.4); la ricompilazione va fatta senza posizioni
   della `770202` né della `770212`.
6. 🟠 **R255** può spostare il contratto (uscita, regime, EMA spento, orologio in fase).
7. 🟠 **Strumenti che non conoscono `770212`** (né `770105`): `backtest_pipeline/hedging_demo_correlati.py` r.87
   (`FTMO_PROXY`) e `backtest_pipeline/mc_challenge_ftmo_stato.py` r.216-223. Non toccati.
8. 🟠 **Fail-open del filtro EMA** (§③.2): con `CopyBuffer` fallito lo short opera senza filtro. Nessun log lo
   segnala oltre a `bias 0` nella riga `RETEST armato` (r.1284-1285).
9. ⚪ **La foto del grafico vivo della `770202` è del 25/09 20:47**.
10. ⚪ **SL della `771531` riletto dalla foto del 25/09**: il suo trailing può averlo spostato; i numeri del §⑤.2
    che lo usano sono [DERIVATI].
11. ⚪ **Settimana 26/10-30/10** (§⑥.3) e griglia H4 diversa fra backtest e campo (§③.2): non misurate.
12. ⚪ **Nessuna compilazione serve e nessuna è stata provata**: si usa il binario `CLAU12_Dow_Apertura_US` già in campo.

---

## ⑩ 📎 FONTI
`mql5/Presets/FTMO/ABTG_Dow_Apertura_US_770202_FTMO.set` (l'origine, r.35-36 e r.40-47) ·
`mql5/Experts/ABTG_Dow_Apertura_US.mq5` al pin `9fca63d9` (= `CLAU12_…`) ·
`backtest_pipeline/coda/referti/CODA_08_preset_dai_chr_20260926_033003.log` r.1883-1970 (la `770202` viva) ·
`CODA_06_quale_codice_gira_20260926_033003.log` r.184, r.211 · `CODA_01_sedie_attaccate_20260926_033003.log`
r.41-96 · `backtest_pipeline/REGISTRO_TEST.md` r.4035-4042 · `report/ALLARGARE_LA_ROSA_2026-09-19.md` §3.2 ·
`backtest_pipeline/risultati_archivio/csv_r54/*_r54a.csv` · `backtest_pipeline/risultati_prove/ABTG_Dow_Apertura_US/*_ptc.csv` ·
`backtest_pipeline/prove/R255a_short_DOW_ancora_1430.txt` · `report/OROLOGIO_BCM_2026-09-24.md` §5.1.1, §5.3 ·
`report/MODIFY_A_RAFFICA_FTMO_2026-09-25.md` §2 · `backtest_pipeline/righe/RICOMPILA_CLAU12_TRAILFIX_LEGGIMI.md` ·
`mql5/Presets/ABTG_Guardian_FTMO_2Step.set` · `mql5/Include/ABTG_PausaGuardian.mqh` al pin `26a18566` (v1.20) ·
`report/NOTTE_2026-09-26.md` (MetriX 26/09) · `backtest_pipeline/risultati_prove/PREVOLO_FTMO_specifiche_2026-09-20.csv` r.41 ·
`docs/RISPOSTA_SUPPORTO_FTMO_2026-09-24.md` · `docs/RISPOSTA_SUPPORTO_FTMO_2026-09-25.md` ·
`docs/REGOLAMENTO_FTMO_2026-08.md` r.130 · `docs/REGOLAMENTO_FTMO_2026-09-20.md` §④ ·
`report/SEDIA_SHORT_DAX_FTMO_2026-09-25.md` (il modello) · `report/SCHIERAMENTO_FTMO_2026-09-20.md` r.181 ·
`backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md` classi 187, 547, 645, 671, 783, 792, 796.
