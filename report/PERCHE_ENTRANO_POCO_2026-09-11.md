# 🔬 PERCHE' ENTRANO POCO — il vincolo che morde, sedia per sedia (11/09/2026)

> **Domanda di Claudio, 11/09:** _"Ricontrollate tutti gli EA sul conto demo
> piccolo perche' fanno pochi trade, i soliti. Ho notato meno trade negli
> ultimi due giorni."_
>
> `report/FREQUENZA_CAMPO_2026-09-11.md` ha gia' risposto **quanto** (58% del
> promesso su 8 sedie). Questo referto risponde alla domanda che nessuno aveva
> fatto: **CHE COSA le ferma.** Non "quante volte entra": **cosa la blocca.**

🛑 **E' SOLA LETTURA.** Nessun `.mq5`, `.set`, preset, parametro o terminale e'
stato toccato. Le proposte in §7 sono proposte, col costo accanto.
🎯 **Conto: demo piccolo 50503392** (cartella `C:\Program Files\BCM Markets MT5
Terminal`, profilo `ORO`), **40 sedie attaccate, 39 che tradano** (la 40a e'
`ABTG_TradeExporter`, un registratore).

---

# 🚀 LE TRE RIGHE

1. 🎯 **Vincolo identificato: 39 sedie su 39.** Nessuna e' ferma per un guasto:
   ogni sedia ha una condizione dominante **scritta nel suo disegno o nel suo
   preset**, e in 31 casi su 39 e' quella a spiegare il silenzio.
2. 🙈 **Cieche: 14 su 39** — non scrivono NIENTE quando rifiutano, quindi oggi
   **non possiamo distinguere _"non c'era il segnale"_ da _"il segnale c'era e
   qualcosa l'ha fermato"_. (§5: è il prodotto piu' utile di questo referto.)
3. 🏆 **La causa piu' diffusa NON e' un filtro: e' l'OCCUPAZIONE + il colpo
   unico.** 28 sedie su 39 hanno un tetto strutturale (`MaxPositions=1`,
   `OneTradePerDay`, un ciclo a settimana, un lato solo): **il motore non e'
   autorizzato a riprovare**, non e' che viene bocciato.
   📌 E il contro-esempio regge: misurate una per una, **solo 2 sedie su 39
   sono sotto il progetto in modo significativo** (`771531`, `770202`). Le
   altre fanno **quello per cui sono state disegnate** — ed e' il disegno,
   non un guasto, il problema da portare al 1° ottobre.

---

# 1. 🔴 IPOTESI 1 — IL LOTTO NULLO: **SMENTITA su 38 sedie su 39, VERA su UNA**

Era la prima da guardare, ed e' giusto averla guardata. **Ma il codice dice il
contrario di quello che temevamo**, e lo dice in modo uniforme.

## 1.1 Chi dimensiona l'ingresso — misurato su TUTTI i 22 EA vivi

| famiglia di EA | funzione che dimensiona l'INGRESSO | riga finale | lotto sotto il minimo ⇒ |
|---|---|---|---|
| PTE · BreakingBand · GapFill · PunteLarry · CostToCost · EasyTrend · SuperWave · SupRev (×4) · MaxMinNotte (×2) · EMA200 (×2) · ORB · PostNews | `LotByRisk(slDist)` | `return(MathMax(mn,MathMin(mx,lot)));` | ✅ **ORDINE AL MINIMO** |
| DAX_Apertura · Dow_Apertura · Nasdaq_Apertura | `CalcLotByRisk(dist)` | `lot = MathMax(minLot, MathMin(maxLot, lot));` | ✅ **ORDINE AL MINIMO** |
| 🔴 **GapContinuation** (774101) | `CalculateEntryVolume()` → `NormalizeVolumeDown()` | `if(volume<minimum) return(0.0);` | 🔴 **NESSUN ORDINE** |

👉 **`NormVol()` (quella che torna 0 sotto il minimo) esiste in 13 EA, ma NON
dimensiona MAI l'ingresso**: serve solo per i **parziali** e, nella famiglia
SuperWave/SupRev, per **spezzare** il lotto in 1/3 a mercato + 2/3 pendente — e
li' c'e' gia' il pavimento `if(lotMkt<=0) lotMkt=VOLUME_MIN`.

🔵 **E' la sorella del difetto `EMA200` di oggi, con l'esito opposto e migliore:
li' il pavimento ALZA in silenzio, qui non azzera niente.** Il rischio vero
resta quello gia' scritto in `CENSIMENTO_RISCHIO_VERO_2026-09-10.md` (il
pavimento fa salire il rischio sotto soglia), **non una frequenza mangiata.**

## 1.2 🚨 L'UNICA ECCEZIONE — e ha il peggior contorno possibile

**`774101` `ABTG_GapContinuation` 225JPY M1** e' l'unica sedia dove
**un lotto sotto il minimo NON diventa un ordine: diventa un setup CANCELLATO.**

```
double volume=CalculateEntryVolume(tick.ask,stop,applied_risk_percent);
if(volume<=0.0)
  { g_cancelled=true; g_setup_ready=false; cntVolZero++;
    g_status="Cancelled: minimum volume exceeds allowed risk";
    if(InpPrintDailyDiagnostics) PrintFormat("DIAG ... CANCELLED volume ..."); return; }
```

🔴 **E nel preset vivo `InpPrintDailyDiagnostics=false`.** Quindi: la sola sedia
che puo' perdere un ingresso per lotto nullo e' anche **la sola che ha la spia
spenta**. Resta solo `g_status` sul **commento del grafico** — che non finisce
nel giornale, non finisce in nessun file, e nessuno lo legge.
📌 **Non sto dicendo che sta succedendo**: sto dicendo che **se succedesse, non
lo sapremmo**, e che accenderlo costa un flag.

---

# 2. ⏰ IPOTESI 2 — LE FINESTRE ORARIE: **la causa piu' pesante di tutte**

Ore al giorno in cui la sedia e' **davvero autorizzata a decidere** (ora
SERVER BCM = ora italiana − 1):

| ore/giorno autorizzate | sedie | quali |
|---|---:|---|
| 🔴 **~0,25 h** (15 min di range + trigger) | 1 | `770611` ORB (14:30-14:45 → rottura fino alle 21:00, **un colpo solo**) |
| 🔴 **~0,5-1,1 h** | 4 | `770101` DAX (08:00+35'+30' delay) · `770202` Dow (14:30+35'+30') · `770250` NAS (14:30+15'+30') · `770402`/`770411` MaxMin (piazza 07:00, cutoff 08:30) |
| 🔴 **1,5 h** | 1 | `774101` GapCont (apertura 01:00, ingressi entro 90 min) |
| 🟠 **~1 h nei giorni di news, 0 negli altri** | 3 | `771201` `771202` `771203` PostNews |
| 🟠 **11 h (08-18)** | 2 | `772421` `772422` EasyTrend |
| 🟡 **1 occasione a SETTIMANA** | 5 | `772231-35` GapFill (solo la riapertura del lunedi', 3 barre) |
| 🟡 **1 ciclo al GIORNO** | 6 | `772341-46` PunteLarry (pattern su D1) |
| 🟢 **24 h** | 17 | PTE ×3 · BreakingBand ×3 · CostToCost ×2 · SuperWave ×2 · SupRev ×4 · EMA200 ×2 · (+1) |

E sopra la finestra c'e' il **tetto per giornata**:
- `InpOneTradePerDay=true` su **6 sedie** (`770101` `770202` `770250` `770402`
  `770411` `770611`): per disegno **non possono fare piu' di 1 operazione al
  giorno**, qualunque cosa faccia il mercato.
- `InpMaxTradesPerDay=0` (nessun tetto) su tutte le altre → **l'ipotesi 4 e'
  SMENTITA: nessuna sedia del piccolo e' ferma per `MaxTradesPerDay`.**

🔴 **E il vincolo piu' sottovalutato e' l'OCCUPAZIONE**: `InpMaxPositions=1` (o
la guardia `CountPositions()>0 || CountPendings()>0`) su **tutte** le sedie
H1/H2/H4. Con `InpMaxBarsHold=100` su `CostToCost` H4 = **fino a 16 giorni di
calendario** in cui la sedia **non guarda nemmeno** se c'e' un segnale. Su
`PunteLarry` `InpMaxDaysHold=5`. 👉 **Una sedia a mercato non e' una sedia muta:
e' una sedia occupata** — ed e' esattamente l'artefatto gia' trovato il 05/09.

---

# 3. 🎚️ IPOTESI 3 — I FILTRI SOVRAPPOSTI: quale morde davvero

| filtro | quante sedie lo hanno ACCESO | morde? |
|---|---:|---|
| **lato spento** (`AllowLong=false` o `AllowShort=false`) | 🔴 **10** | **SI, taglia meta' dei segnali** (`770101` `770202` `770250` `770411` `770611` `772343` `772344` `772345` `772346` `772361` `772362`) |
| filtro news (blackout) | 0 | ❌ spento ovunque (`InpUseNewsFilter=false`) |
| **spread massimo** | 12 | ⚠️ **solo 2 sono strette**: `772421`/`772422` EasyTrend a **30 punti**. Le altre a 300 o **spente** (`InpMaxSpread=0` su 20 sedie) |
| EMA200 / EMA H4 di trend | 4 | ⚠️ **SI su `770202` e `770250`** (`InpUseEmaFilter=true` su H4) e `770611` (`InpUseEma200Filter=true`) |
| confluenza EMA (SupRev) | 4 | ⚠️ SI: `InpUseConfluence=true` su `770924` `970901` `970912` `970913` |
| volumi / ATR / VWAP / Supertrend / correlazione / livelli tondi | 1 | ❌ quasi tutti spenti; solo `770411` ha `InpUseCorrelation=true` |

## 🥇 Il filtro piu' selettivo della flotta, con il numero accanto
**`772421` EasyTrend CHFJPY: `InpMaxSpreadPts=30`** — cioe' **3,0 pip** su un
**cross**. `CANCELLO_COSTO_FLOTTA_2026-09-10.md` (r.498) dice che quella sedia
**"passa solo se lo spread vero e' ≤ 1,17 pip"** e che lo spread BCM su CHFJPY
e' **illeggibile alla sonda (`SpreadPt=0`, nessun tick)**.
👉 **E' il caso da manuale: soglia vicinissima alla mediana, e mediana non
misurata.** Il valore 30 **non e' un errore di deploy** — e' scritto nel
verbale del 14/08 (`DIARIO.md`: _"spread 30, fascia 8-18"_), quindi e' voluto.
Ma "voluto" e "innocuo" sono due cose diverse, e la seconda **non e' misurata**.

---

# 4. 🚧 IPOTESI 5 — IL GUARDIAN: **SMENTITA, e non dal log: dal CODICE**

Il referto di stamattina lo escludeva leggendo `rischioAperto=0.00%`. Quella e'
un'inferenza. **Ecco il fatto**, da due misure indipendenti:

| misura | cosa dice |
|---|---|
| `CODA_06_quale_codice_gira_20260911` (scansione dei sorgenti sul terminale) | colonna **GUARD**: `SI` **solo** su `ABTG_ORB_Ottimizzato` e `ABTG_PostNews`. `no` su **tutti** gli altri 20 EA |
| `CODA_08_preset_dai_chr_20260911` (parametri nei `.chr`) | l'input `InpUsaGuardian` **esiste solo** nelle sedie `770611`, `771201`, `771202`, `771203`. **Assente in 35 sedie su 39** |

👉 **Il Guardian non puo' rifiutare ingressi su 35 sedie su 39, perche' in quei
binari non c'e'.** Puo' mordere solo su `770611` ORB e sulle 3 `PostNews` — e li'
la guardia **ritorna in silenzio** (`if(!ABTG_GuardiaIngresso(...)) return;`
senza `Log`), che e' l'unica cosa da sistemare del capitolo.

## 🚨 4.1 E la scoperta che viene di striscio — **IL CAMPO GIRA CODICE VECCHIO**

Se `InpUsaGuardian` manca, il binario e' **precedente** alla migrazione Guardian
(19/08). Verificato riga per riga, confrontando le **RIGHE** di `CODA_06` con il
repo (regola: PowerShell conta una riga in piu' di `wc -l`):

| EA | righe sul VPS | righe nel repo | esito |
|---|---:|---:|---|
| `ABTG_ORB_Ottimizzato` | 1464 | 1463 | 🟢 **allineato** |
| `ABTG_PostNews` | 667 | 666 | 🟢 **allineato** |
| **gli altri 20** | 486-2133 | 552-2566 | 🔴 **DIVERSI, sempre piu' corti** |

🔴 **20 EA su 22 che girano sul piccolo NON sono la versione del repo.**
Ricostruite le versioni esatte da `git` (commit il cui file ha esattamente
quelle righe, entro la data di compilazione): il campo gira gli snapshot del
**28/07 – 16/08**. Tutta l'analisi di questo referto e' fatta su **quelle**
versioni, non sul repo.

### 🧪 IL CONTRO-ESEMPIO CHE HO PROVATO A COSTRUIRE — e che NON regge
L'ipotesi alternativa era ovvia e plausibile: _"non e' codice vecchio, e'
l'albero **standalone**"_ — lo suggerisce lo script stesso (`COME SI LEGGE:
'GUARD = no' su un EA che nel repo ce l'ha vuol dire albero standalone`).
**Misurata, cade:**

| EA | VPS | standalone (repo) | main (repo) |
|---|---:|---:|---:|
| `ABTG_PTE` | 526 | **455** | 649 |
| `ABTG_EMA200` | 487 | **380** | 552 |
| `ABTG_MaxMinNotte` | 540 | **468** | 918 |
| `ABTG_DAX_Apertura_EU` | 2133 | **1069** | 2367 |
| `ABTG_Nasdaq_Apertura_US` | 2033 | **1072** | 2566 |

👉 **Il campo non e' ne' il main di oggi ne' lo standalone: e' un main VECCHIO.**
L'alternativa produce numeri lontanissimi (455 contro 526), quindi la misura
distingue davvero le due spiegazioni.

### 💸 E costa gia' un numero, oggi
Nella versione **che gira**, `SuperWave`/`SupRev` calcolano `lotPend` **prima**
del pavimento:
```
double lotMkt=NormVol(totLot*InpFirstFraction);
double lotPend=NormVol(totLot-lotMkt);            // <-- PRIMA del pavimento
if(lotMkt<=0) lotMkt=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
```
cioe' **il difetto che raddoppia il volume** (misurato in campo il 20/08:
**1,42% su un contratto da 1,0%**). La correzione e' nel repo dall'08/09 e
**NON e' in campo**: riguarda `770531` `770511` `770924` `970901` `970912`
`970913`. 🔴 **E' un fatto di RISCHIO, non di frequenza** — ma va scritto qui
perche' e' qui che e' saltato fuori.

---

# 5. 🙈 LE SEDIE CIECHE — la lista che dice DOVE NON VEDIAMO

Criterio: **quando la sedia rifiuta, scrive qualcosa nel giornale Esperti?**
Se no, uno zero e' indistinguibile da un blocco.

## 5.1 🔴 CIECHE (14) — nessun log sul rifiuto d'ingresso
| sedie | EA | cosa NON sapremo mai dal log |
|---|---|---|
| `771321` `771322` `771332` | `ABTG_PTE` | tutte le guardie sono `return;` nudi: doji, corpo fuori banda, color flip |
| `770531` `770511` | `ABTG_SuperWave` | `if(!crossUp && !crossDn) return;` muto |
| `770924` `970901` `970912` `970913` | `ABTG_SupRev*` | il cross e' muto (la confluenza invece parla) |
| `771531` `971501` | `ABTG_EMA200` | fascia di distanza, bias EMA14, occupazione: tutto muto |
| `774101` | `ABTG_GapContinuation` | ha il funnel **piu' bello della flotta** e lo ha **SPENTO** (`InpPrintDailyDiagnostics=false`) |
| `772361` `772362` | `ABTG_CostToCost` | 🔴 il rifiuto **per lato spento** e' muto (`cF_side++; return;` senza `Log`) — ed e' proprio il piu' frequente, visto che girano long-only |

## 5.2 🟡 SEMI-CIECHE (6) — parlano sui filtri, tacciono sul "niente pattern"
`772341-46` PunteLarry: ogni bocciatura ha il suo `Log` **tranne** `cS_none++`
(nessun pattern). Si deduce per esclusione, ma non e' scritto.

## 5.3 🟢 CHE PARLANO (19)
`770101` `770202` `770250` (famiglia Apertura: `ABTGLog` su ogni rifiuto, col
numero) · `770402` `770411` MaxMinNotte · `770611` ORB (salvo la guardia
Guardian, muta) · `771201` `771202` `771203` PostNews (salvo la guardia
Guardian) · `772161-63` BreakingBand (`ResetPattern("motivo")`) ·
`772231-35` GapFill (**provato in campo il 31/08**: _"spread 1000 sopra il
limite 300: rinvio (barra 2 di 3)"_) · `772421` `772422` EasyTrend (stampa lo
**spread misurato** accanto alla soglia — cioe' l'unica sedia che, letta oggi,
chiude da sola il sospetto del §3).

## 5.4 💡 LA COSA CHE FA PIU' RABBIA (e che e' anche la buona notizia)
**Sei EA hanno gia' dentro un funnel di mortalita' completo** (BreakingBand,
GapFill, PunteLarry, CostToCost, EasyTrend, GapContinuation: contatori
`cB_ cW_ cF_ cO_`), e stampano tutto con `PrintFunnel()`.
🔴 **Ma `PrintFunnel()` e' chiamata SOLO da `OnTester()`**, che **in forward non
viene mai eseguita.** In campo quei contatori si riempiono in memoria e muoiono
al `OnDeinit`.
👉 **La diagnosi che ci manca e' gia' scritta: basta farla girare nel Tester.**
Nessuna modifica al codice, nessun rischio sul conto (§7).

---

# 6. 📋 LA TABELLA MADRE — una riga per sedia viva del piccolo

Legenda `dim.` = chi dimensiona l'ingresso · `<min` = lotto sotto il minimo ⇒
`MIN` (ordine al minimo) o `ZERO` (nessun ordine) · `oss/att` = operazioni
osservate contro attese nella finestra **25/08 → 10/09 (13 giornate)**, attese
dalla frequenza promessa in `CENSIMENTO_CONTRATTI.md`.

| sedia | EA | sym | dim. | `<min` | ore/g | filtri ATTIVI | oss/att | 🎯 **IL VINCOLO CHE MORDE** | come si misura | scarto contro |
|---|---|---|---|---|---|---|---|---|---|---|
| `771321` | PTE | U30USD | `LotByRisk` | MIN | 24 | HeikinAshi · colorFlip · 1 pos | 1 / 1,95 | **la congiunzione doji(≤10% range) + corpo INTERO fuori dalla banda TMA veloce** sulla barra [2] | Tester sulla versione repo + contatore per stadio (il funnel qui **non esiste**, va aggiunto) | ⚪ **progetto** (p alto) |
| `771322` | PTE | GBPUSD | `LotByRisk` | MIN | 24 | idem | 0 / 2,34 | idem | idem | ⚪ progetto |
| `771332` | PTE | GBPUSD | `LotByRisk` | MIN | 24 | idem (cella B25) | 0 / 1,82 | idem | idem | ⚪ progetto (gia' chiuso il 05/09: P(zero)=15%) |
| `772161` | BreakingBand | GBPUSD | `LotByRisk` | MIN | 24 | ContRequireNarrow **+** ContRequireStdDown | 1 / 1,20 | **la catena del bulge**: ≥3 candele, ≥1 impulsiva, unidirezionale, **movimento netto ≥1,0 ATR**, distanza mediana ≥0,75 | log Esperti: `ResetPattern` dice gia' QUALE anello salta | ⚪ progetto |
| `772162` | BreakingBand | EURUSD | `LotByRisk` | MIN | 24 | idem | 1 / 0,60 | idem | idem | ⚪ progetto |
| `772163` | BreakingBand | AUDUSD | `LotByRisk` | MIN | 24 | idem | 1 / 0,48 | idem | idem | ⚪ progetto |
| `772231` | GapFill | GBPUSD | `LotByRisk` | MIN | **1 volta/sett.** | gapMin 0,3×ATR(D1) · spread 300 | 0 / 0,36 | 🔴 **UNA SOLA OCCASIONE A SETTIMANA, e serve un gap del weekend ≥30% dell'ATR D1**: sui major non succede quasi mai | log del lunedi': la riga `gap X (Y x ATR) sotto il minimo` esiste gia' | ⚪ **progetto** (misurato 05/09: P(zero)=63%) |
| `772232` | GapFill | EURUSD | `LotByRisk` | MIN | 1/sett. | idem | 0 / 0,42 | idem | idem | ⚪ progetto (P(zero)=59%) |
| `772233` | GapFill | AUDUSD | `LotByRisk` | MIN | 1/sett. | idem | 0 / 0,53 | idem | idem | ⚪ progetto (P(zero)=50%) |
| `772234` | GapFill | U30USD | `LotByRisk` | MIN | 1/sett. | idem | 1 / 0,90 | come sopra, ma sugli indici il gap c'e' (31/08: 0,34×ATR, **appena sopra**) | idem | 🟢 in linea |
| `772235` | GapFill | 225JPY | `LotByRisk` | MIN | 1/sett. | idem | 1 / 0,71 | ⚠️ **sospetto SPREAD**: 300 punti sul Nikkei in riapertura asiatica, su **3 sole barre** — finita la finestra, settimana persa | log: `spread N sopra il limite 300: rinvio (barra k di 3)` | 🟡 **da provare** |
| `772341` | PunteLarry | U30USD | `LotByRisk` | MIN | 1 ciclo/g | L+S · `MaxDaysHold=5` | 4 / 1,74 | **un ciclo al giorno + la posizione che resta fino a 5 giorni** (occupazione) | log: `posizione/pendente gia' in vita: nessun nuovo ciclo` | 🟢 **sopra** il promesso |
| `772342` | PunteLarry | EURAUD | `LotByRisk` | MIN | 1 ciclo/g | L+S | 3 / 1,50 | idem | idem | 🟢 sopra |
| `772343` | PunteLarry | XAUUSD | `LotByRisk` | MIN | 1 ciclo/g | 🔴 **solo LONG** | 1 / 0,48 | **il lato short spento** dimezza per costruzione + 1 ciclo/g | log: `setup SHORT rilevato ma lato disabilitato` (c'e' gia') | ⚪ progetto |
| `772344` | PunteLarry | GBPJPY | `LotByRisk` | MIN | 1 ciclo/g | 🔴 solo LONG | 1 / 0,90 | idem | idem | ⚪ progetto |
| `772345` | PunteLarry | GBPUSD | `LotByRisk` | MIN | 1 ciclo/g | 🔴 **solo SHORT** | 1 / 1,14 | idem (lato long spento) | idem | ⚪ progetto |
| `772346` | PunteLarry | EURCAD | `LotByRisk` | MIN | 1 ciclo/g | 🔴 solo LONG | 0 / 0,90 | idem | idem | ⚪ progetto |
| `772361` | CostToCost | EURJPY | `LotByRisk` | MIN | 24 (H4) | 🔴 solo LONG · `MaxBarsHold=100` | 2 / 2,82 | 🔴 **lato short spento + occupazione fino a 100 barre H4 (~16 giorni)**: quando e' a mercato, non guarda nemmeno | ⚠️ **il rifiuto per lato e' MUTO**: serve il funnel nel Tester | ⚪ progetto |
| `772362` | CostToCost | GBPCAD | `LotByRisk` | MIN | 24 (H4) | idem | 2 / 2,76 | idem | idem | ⚪ progetto |
| `772421` | EasyTrend | CHFJPY | `LotByRisk` | MIN | **11 (08-18)** | 🔴 **spread ≤30 pt (3,0 pip su un CROSS)** | 1 / 2,27 | 🔴 **IL TETTO SPREAD.** Soglia a ridosso della mediana su un cross, e la mediana vera **non e' mai stata misurata** (sonda: `SpreadPt=0`) | **costo zero**: il log stampa gia' `spread N su limite 30`. Contare le righe di una settimana | 🟡 **sospetto n.1 della flotta, MA p=0,34: il campione NON lo prova** |
| `772422` | EasyTrend | GBPUSD | `LotByRisk` | MIN | 11 (08-18) | spread ≤30 pt (≈3,0 pip su GBPUSD = largo) | 1 / 1,74 | **la fascia 08-18 + il pivot/divergenza CCI**: qui 30 punti NON stringe (GBPUSD viaggia a 10-15) | idem | ⚪ progetto |
| `774101` | GapContinuation | 225JPY | 🔴 `CalculateEntryVolume` | 🔴 **ZERO** | 1,5 (01:00-02:30) | gap ≥ **1,0%** · spread ≤10% dello stop | 1 / 2,21 | **la soglia gap 1,0% all'apertura del Nikkei** (rara). 🔴 **Secondaria ma cieca: il lotto sotto il minimo CANCELLA il setup** | 🔴 **oggi NON si misura**: `InpPrintDailyDiagnostics=false`. Accenderlo = 1 flag | 🟡 **non misurabile** |
| `770531` | SuperWave | U30USD | `LotByRisk` | MIN | 24 (H2) | confluenza OFF · pendente 2/3 | **8** / 2,34 | **l'incrocio EMA14×EMA200** (evento raro, ma a grappoli) | Tester col funnel | 🟢 **342% del promesso** |
| `770511` | SuperWave DOW H1 | U30USD | `LotByRisk` | MIN | 24 (H1) | idem | **8** / 6,50 | idem | idem | 🟢 sopra |
| `770924` | SupertrendReversal | 225JPY | `LotByRisk` | MIN | 24 (H2) | 🔴 **confluenza EMA ON** | 2 / 0,60 | **tocco del Supertrend + confluenza EMA entro 1,5 ATR** | il log dice gia' `nessuna confluenza EMA vicina: skip` | 🟢 sopra |
| `970901` | SupRev Ott | XAUUSD | `LotByRisk` | MIN | 24 (H4) | confluenza ON | 1 / 1,50 | idem | idem | 🟢 in linea |
| `970912` | SupRev DAX H4 | D30EUR | `LotByRisk` | MIN | 24 (H4) | confluenza ON | **0** / 2,34 | **confluenza EMA su H4**: 6 barre al giorno, e il tocco deve cadere vicino a una EMA | idem — 🔴 **ed e' l'unica sedia con tensione statistica gia' segnalata il 05/09 (P≈5%)** | 🟡 sospetto (p=0,096) |
| `970913` | SupRev NAS H1 | NASUSD | `LotByRisk` | MIN | 24 (H1) | confluenza ON | 2 / 4,42 | idem | idem | 🟡 da provare |
| `771531` | EMA200 | U30USD | `LotByRisk` | MIN | 24 (H1) | bias EMA14 · 2 pendenti · scadenza 6 barre | **9** / 20,15 | 🔴 **OCCUPAZIONE**: `HasPosition() \|\| HasPending()` blocca **tutto** finche' i due limit vivono (**6 barre H1**) o la posizione e' aperta; sopra, la **fascia 0,3-1,5 ATR** dalla EMA200 | Tester + contatore; **oggi tutto muto** | 🔴 **SOTTO IL PROGETTO, misurato: p=0,0046** (la piu' significativa della flotta) |
| `971501` | EMA200 Ott | XAUUSD | `LotByRisk` | MIN | 24 (H4) | idem (Order1 0,05 ATR) | 5 / 3,90 | idem | idem | 🟢 sopra |
| `770402` | MaxMinNotte | XAUUSD | `LotByRisk` | MIN | **1,5** (07:00-08:30) | OneTradePerDay · box 23-04 | 6 / 2,21 | **i pendenti devono essere presi entro 90 minuti**, poi si cancellano | il log lo dice gia': `cutoff ingressi superato: pendenti cancellati` | 🟢 **sopra** |
| `770411` | MaxMin DAX Short | D30EUR | `LotByRisk` | MIN | 1,5 | 🔴 solo SHORT · **correlazione ON** | 2 / 1,01 | **lato short + filtro correlazione + 90 minuti** | idem | 🟢 in linea |
| `770101` | DAX Apertura | D30EUR | `CalcLotByRisk` | MIN | **~0,5** | 🔴 solo LONG · OneTradePerDay | 7 / 12,61 | 🔴 **UN COLPO AL GIORNO SU UN LATO SOLO**: la promessa di 21 op/mese e' nata da una cella; in campo gira long-only | `ABTGLog` racconta gia' tutto (spread, range min/max, conferma) | 🟡 sospetto (p=0,066); **da verificare se la promessa R83 era a due lati** |
| `770202` | Dow Apertura | U30USD | `CalcLotByRisk` | MIN | ~0,5 | 🔴 solo LONG · **EMA filter su H4 ON** · OneTradePerDay | **1** / 5,98 | 🔴 **il filtro EMA su H4 + long-only**: e' l'unica Apertura del DAX/Dow con il filtro di trend acceso, ed e' quella con lo scarto peggiore (17%) | `ABTGLog` + log Esperti: cercare le righe di rifiuto di agosto-settembre | 🔴 **SOTTO IL PROGETTO, misurato: p=0,0177** |
| `770250` | Nasdaq GatedShort | NASUSD | `CalcLotByRisk` | MIN | ~0,5 | 🔴 **solo SHORT** · EMA H4 ON · OneTradePerDay | **0** / 2,99 | 🔴 **short-only + filtro di trend H4**: in mercato al rialzo il cancello e' chiuso quasi sempre — **e' il disegno del GatedShort** | `ABTGLog`; e il contratto (`CONTRATTO_GATEDSHORT_770250.md`) dichiara gia' "meno nella calma" | ⚪ **progetto** |
| `770611` | ORB Ott | U30USD | `LotByRisk` | MIN | **0,25 + rottura** | 🔴 solo LONG · EMA200 ON · range ≤0,8% · OneTradePerDay · **Guardian ON** | 3 / 5,59 | **range 14:30-14:45, un colpo, un lato, con il filtro EMA200** | log gia' ricco; ⚠️ **la sola guardia muta e' il Guardian** | 🟡 da provare |
| `771201` | PostNews ECB | EURJPY | `LotByRisk` | MIN | 1 h **nei soli giorni ECB** | `InpRestrictToNews=true`, match `ECB` | 1 / — | 🔴 **IL CALENDARIO.** Nel file vivo il **prossimo evento ECB e' il 2026.10.29**: da oggi **47 giorni a zero, matematicamente** | `awk` sul CSV delle news (fatto: §6.1) | ⚪ **progetto** — ma il contratto non lo diceva |
| `771202` | PostNews FOMC | EURUSD | `LotByRisk` | MIN | 1 h nei soli giorni FOMC | match `FOMC` | 0 / — | idem: **prossimo FOMC 16/09**, poi 28/10, poi 09/12 → **~8 occasioni l'anno** | idem | ⚪ progetto |
| `771203` | PostNews | USDJPY | `LotByRisk` | MIN | 1 h | file `abtg_news_live_2026-09-04.csv`, match `Unemployment Rate` | 1 / — | 🔴🔴 **IL FILE NEWS E' SCADUTO**: contiene **due sole righe, entrambe del 04/09/2026**. Da 05/09 in poi la sedia **non puo' piu' entrare, mai**, finche' nessuno rigenera il file | `cat` del CSV (fatto). ⚠️ **limite: ho letto la copia nel repo, non quella nella cartella Common del VPS** | 🔴 **DIFETTO, non progetto** |

## 6.1 🚨 La prova sul calendario delle news (le 3 sedie PostNews)
`mql5/Files/abtg_news.csv` — **18 righe in tutto**. Eventi da oggi in poi:
```
2026.09.16 20:00 USD FOMC     2026.10.28 20:00 USD FOMC
2026.10.29 14:15 EUR ECB      2026.12.09 20:00 USD FOMC
2026.12.17 14:15 EUR ECB      2027.01.27 20:00 USD FOMC
```
e `abtg_news_live_2026-09-04.csv` (quello di `771203`) contiene **solo**:
```
2026.09.04 12:30;High;USD;Nonfarm Payrolls
2026.09.04 12:30;High;USD;Unemployment Rate
```
👉 Tre sedie della flotta hanno una **frequenza massima teorica di ~8, ~2 e
~0 operazioni l'anno**. Non e' un filtro che morde ogni tanto: e' una **finestra
di opportunita' quasi vuota**, e per `771203` e' **chiusa a chiave**.

---

# 7. 🧪 I CONTRO-ESEMPI, prima di consegnare

| ipotesi che demolirebbe questo referto | prova che ho costruito | esito |
|---|---|---|
| 🧪 **"'entra poco' e' un difetto"** — e se invece fosse il motore che funziona? | Confronto con la **frequenza del suo backtest**, non con un desiderio, sedia per sedia, con **la probabilita' di Poisson di vedere quel numero o meno** (§7.2) | ⚠️ **VERA quasi ovunque**: **14 sedie sono PARI o SOPRA** il progetto, **20 sono statisticamente indistinguibili** dal progetto (p ≥ 0,05: il campione non basta), **3 non hanno contratto** (PostNews). 🔴 **Solo DUE sedie sono sotto in modo significativo: `771531` (p=0,0046) e `770202` (p=0,0177).** Per tutte le altre lo scarto e' **contro un desiderio**, non contro il progetto |
| 🧪 **"il codice del repo e' quello che gira"** | Righe di `CODA_06` contro `wc -l` del repo + ricostruzione del commit da `git` | ❌ **SMENTITA: 20 EA su 22 girano codice del 28/07-16/08.** Tutta l'analisi e' stata rifatta su quelle versioni |
| 🧪 **"GUARD=no vuol dire albero standalone (quindi e' voluto)"** | Confronto a **tre** valori (VPS / standalone / main): PTE 526 vs **455** vs 649 | ❌ **SMENTITA**: il campo non e' lo standalone. L'alternativa produce numeri lontani, quindi la misura **distingue** davvero |
| 🧪 **"il Guardian sta bloccando"** | Non il log (`rischioAperto=0`), ma **l'assenza dell'input nei binari**: 35 sedie su 39 non hanno `InpUsaGuardian` | ❌ **SMENTITA con una prova di codice**, non con un'inferenza |
| 🧪 **"il lotto nullo azzera gli ordini"** | Letta la riga finale di `LotByRisk`/`CalcLotByRisk` in **tutti** i 22 EA **nella versione che gira** | ❌ **SMENTITA 38 volte su 39.** Vera **1 volta**: `774101` |
| 🧪 **"13 giornate bastano per giudicare una sedia"** | A 0,2 op/g, 13 giorni = **2,6 operazioni attese**: zero osservazioni non e' informazione | ⚠️ **VERA**: 🔴 **nessuna riga individuale di questo referto conclude sul MERITO.** Il vincolo l'ho letto **nel codice e nel preset**, dove il campione non c'entra |
| 🧪 **"il conto operazioni e' pulito"** | `trades_auto.csv` contiene **solo posizioni CHIUSE** (bug A del 05/09) e **non ha la colonna del conto** | ⚠️ **LIMITE DOPPIO**: (a) gli `oss` sono un **PAVIMENTO** (le posizioni ancora aperte non ci sono); (b) i magic `770101` `770202` `770411` `770611` girano **anche** sul 100k e sul reale: i loro `oss` possono contenere copie di altri terminali → **il loro scarto vero potrebbe essere PEGGIORE** |

## 7.2 📐 LA CLASSIFICA ONESTA — scarto contro il PROGETTO o contro un DESIDERIO?

Metodo: Poisson, `P(X ≤ osservati | attesi)` sulla finestra **25/08 → 10/09**.

| classe | n | sedie |
|---|---:|---|
| 🔴 **SOTTO in modo significativo** (p < 0,05) | **2** | `771531` EMA200 Dow (9/20,2 · **p=0,0046**) · `770202` Dow Apertura (1/6,0 · **p=0,0177**) |
| 🟡 **sotto la media, ma il campione NON permette di concludere** (p ≥ 0,05) | **20** | i piu' tesi: `770250` (p=0,050) · `770101` (0,066) · `771322` e `970912` (0,096) · `771332` (0,162) · `970913` (0,183) · `770611` (0,192) · `772421` (0,338) · `774101` (0,352) |
| 🟢 **PARI o SOPRA il progetto** | **14** | `770531` (8/2,3 = **342%**) · `770402` (6/2,2) · `772341` (4/1,7) · `772342` (3/1,5) · `770924` (2/0,6) · `971501` (5/3,9) · `770511` (8/6,5) · `770411` · `772162` · `772163` · `772234` · `772235` · `772343` · `772344` |
| ⚪ **senza contratto** (frequenza promessa mai scritta) | **3** | `771201` `771202` `771203` PostNews |

🔴 **Quindi, alla lettera: oggi le sedie che possiamo dichiarare "sotto il
progetto" sono DUE.** Tutte le altre righe "sospette" della tabella madre sono
**sospetti da provare**, non verdetti — e il modo di provarli e' §8, non
l'intuizione.
🛑 **E questo NON assolve la flotta**: il referto di stamattina resta valido
perche' misurava l'**AGGREGATO** (p = 0,00035), e l'aggregato e' l'unita' giusta
per il pavimento di frequenza (firma del 07/09). **Sul singolo si sospende, sul
totale si condanna.**

## 7.1 ✅ E la buona notizia, che va detta perche' e' un fatto come gli altri
Sull'**intera flotta del piccolo** (39 sedie, non le 8 con la promessa piu'
grossa) il campo consegna **79 operazioni contro 101,9 attese = 78%**, cioe'
**6,08 op/giorno contro 7,84 promesse** — e **78% e' un pavimento**, non il
numero vero. **Sette sedie superano il contratto** (`770531` a 342%, `772341`,
`772342`, `770402`, `770924`, `971501`, `770511`).
👉 Il 58% del referto di stamattina **non e' sbagliato**: misura otto sedie
scelte, che sono proprio quelle con la promessa piu' alta. **Letta larga, la
flotta e' piu' vicina al progetto di quanto sembrasse** — e il problema resta
quello vero: **il progetto stesso promette poco**, perche' 28 sedie su 39 hanno
un tetto strutturale di un colpo al giorno o meno.

---

# 8. 🛠️ PROPOSTE — con il costo accanto. **Sono proposte, non modifiche.**

🛑 Nessuna e' stata applicata. Nessun `.mq5`, `.set` o terminale e' stato toccato.

| # | proposta | costo | cosa si guadagna | rischio |
|---:|---|---|---|---|
| 1 | 🥇 **Far girare nel TESTER le 6 versioni col funnel** (BreakingBand, GapFill, PunteLarry, CostToCost, EasyTrend, GapContinuation) sulla finestra 14/08-10/09, **con i preset veri letti da CODA_08** | ~30 min macchina | `[GAP-FUNNEL] SETTIMANE osservate=N \| scartate: sottoMin=x sopraMax=y ...` → **il vincolo che morde, contato**, senza toccare una riga | 🟢 **zero**: Strategy Tester, conto non coinvolto |
| 2 | 🥈 **Leggere il giornale Esperti delle 19 sedie che PARLANO** (una riga di raccolta, sola lettura) | ~10 min | chiude **subito** i sospetti su `772421` (spread CHFJPY), `772235` (spread Nikkei), `770202` (EMA H4), `970912` (confluenza) | 🟢 zero |
| 3 | 🔴 **Rigenerare il calendario news di `771203`** (file fermo al 04/09) e **dichiarare nel contratto** che `771201`/`771202` valgono ~2 e ~8 operazioni l'anno | 15 min | una sedia torna schierabile; due smettono di falsare la media di flotta | 🟡 tocca un file dati: **firma di Claudio** |
| 4 | 🟠 **Ricompilare sul piccolo i 20 EA fermi al 28/07-16/08** | 1 h + riverifica preset | allinea campo e repo, e porta in campo il **fix del doppio volume** SuperWave/SupRev (1,42% su contratto 1,0%) | 🔴 **alto**: ricompilare cambia i binari sotto 36 sedie vive. Va fatto **a mercato chiuso, con la legge dello screenshot**, e **firmato** |
| 5 | 💡 **Accendere `InpPrintDailyDiagnostics` su `774101`** | 1 flag | l'unica sedia col rischio "lotto zero" smette di essere cieca | 🟡 tocca un parametro vivo: firma |
| 6 | 📐 **Aggiungere un funnel ai 6 EA ciechi** (PTE, SuperWave, SupRev, EMA200) | ~2 h di codice | oggi su `771531` — **la sedia con lo scarto piu' grande e piu' significativo (p=0,020)** — non abbiamo **nessun** modo di sapere dove muore | 🟢 solo diagnostica, default spento |

🔴 **E la cosa che questo referto NON autorizza**: allentare un filtro. Le sedie
che possiamo dichiarare sotto il progetto sono **DUE** (`771531`, `770202`), e
per **nessuna delle due** abbiamo ancora il numero che dice *quale* condizione
le ferma — anzi, `771531` e' **cieca** e `770202` no. **Prima la misura, poi
semmai il parametro.** E la misura costa mezz'ora di Tester e dieci minuti di
lettura del giornale: e' il miglior rapporto che abbiamo, a tre settimane dal
1° ottobre.

---

## 📎 FONTI (tutte lette, tutte datate)
- `backtest_pipeline/coda/referti/CODA_01_sedie_attaccate_20260911_033002.log` — le 40 sedie
- `backtest_pipeline/coda/referti/CODA_06_quale_codice_gira_20260911_033002.log` — **quale codice gira**
- `backtest_pipeline/coda/referti/CODA_08_preset_dai_chr_20260911_033002.log` — i **parametri vivi**
- `data/statements/trades_auto.csv` — operazioni osservate (solo chiuse)
- `report/CENSIMENTO_CONTRATTI.md` — frequenza promessa per sedia
- `report/FREQUENZA_CAMPO_2026-09-11.md` · `report/DIAGNOSI_SEDIE_MUTE_2026-09-05.md` · `report/CANCELLO_COSTO_FLOTTA_2026-09-10.md` · `report/CENSIMENTO_RISCHIO_VERO_2026-09-10.md`
- sorgenti `.mq5` **ricostruiti da git alla versione che gira** (commit `344a11b`, `3af47ed`, `24f4b7a`, `9b1c611`, `95bc4ec`, `7246558`, `a766659`, `6074126`, `cb7dc20`, `0823951`, `19312c8`, `61dc18c`)

⚠️ **LIMITE PRINCIPALE, dichiarato**: i `.chr` sono una **foto al salvataggio
del profilo (06/09 22:55)**. Se un input e' cambiato dopo senza salvare il
profilo, qui esce il valore vecchio. E i file `.csv` delle news li ho letti
**nel repo**, non nella cartella `Common` del VPS: la riga 3 di §8 va verificata
sul terminale prima di agire.
