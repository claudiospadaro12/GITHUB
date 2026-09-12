# 🔓 IL WIP `b45dd00` SUI QUATTRO EA: È DIAGNOSTICA — verifica hunk per hunk

**12/09/2026** · nessuna compilazione, nessun backtest, nessun EA modificato.
Solo lettura di `git diff` + tre controlli meccanici + quattro contro-esempi.

> 🔴 **QUESTO NON È UN PASS.** Dopo di me il pacchetto passa dall'agente
> `controllo-preventivo`. È scritto per farsi rompere, non per convincere.

---

## 🥇 0. LA RISPOSTA, IN UNA RIGA

🟢 **Tutti e quattro gli EA sono NEUTRI.** **Nessuno dei quattro ha un hunk che
tocca segnali, ingressi, stop, taglie, uscite o ordini.** Non c'è il
ritrovamento brutto che temevamo: **zero** condizioni alterate, **zero**
contatori dentro un `if`.

🟡 **Ma ho trovato DUE cose che il mandato non chiedeva e che valgono di più
di una conferma**, e stanno in §4 e §5:
1. 🔵 **il compile-chain ha un SECONDO file in «LAVORO IN CORSO»** che nessuno
   aveva nominato: `mql5/Include/ABTG_PausaGuardian.mqh` è a `cdb2037`
   (07/09, *"LAVORO IN CORSO — tetto cluster C2 collegato, SPENTO di
   default"*). 🟢 Ed è **inerte E già collaudato in campo** — con una prova
   misurata, non un'inferenza (§4);
2. 🔴 **per `r127b` l'ancora NON è garantita dal mio verdetto**, e il motivo
   **non è `b45dd00`**: fra l'ancora (R99, 23/08) e oggi c'è `872dba8`
   (08/09), che su quell'EA è un **cambio di comportamento vero** sul volume.
   Vale la **classe 267-bis**: il round resta **LEGGIBILE**, muore solo il
   confronto con l'archivio (§5).

---

## 🔎 1. PRIMA HO CERCATO IL FILE CHE AVEVA GIÀ LA RISPOSTA

`grep -rl b45dd00 report/ backtest_pipeline/` → **12 file**. Cosa ha cambiato
il lavoro:

| cosa cercavo | cosa ho trovato | effetto |
|---|---|---|
| esiste già un'analisi di `b45dd00`? | **SÌ, ma solo su `ABTG_EMA200`** (`report/CODA_NOTTE_2_2026-09-12.md` §1 punto 2 e §7 punto 9): diff letto, +154/−16, diagnostica pura | ✅ nessuna sovrapposizione: i miei quattro non erano coperti |
| l'elenco dei 12 round bloccati esiste già? | **SÌ**: `report/CORRI_OGGI_2026-09-13.md` §2, tabella a r.34-39 | ✅ i nomi sono suoi, non miei (§6) |
| la deriva del binario è già stata misurata? | 🟢 **SÌ, e bene**: `prove/R126a_costo_bufferatr_U30USD.txt` r.255-288 nomina il **commit del binario dell'ancora (`400a462`, 08/08)** e i **tre sospetti** successivi, con una predizione aritmetica falsificabile su ciascuno | ✅ non ho rifatto il lavoro: l'ho **esteso** (quel blocco dice *"il sorgente è cambiato quattro volte"* — oggi sono **cinque**, §5) |
| il tetto cluster nel Guardian: implementato o no? | `CLAUDE.md` (correzione 12/09): **implementato, spento in tre modi** | ✅ mi ha risparmiato di ri-misurarlo, e mi ha indirizzato sull'include |

---

## 📋 2. LA TABELLA PER EA — hunk per hunk

Padre del WIP: **`e2a10a7`**. Comando usato su ognuno:
`git diff e2a10a7 b45dd00 -- mql5/Experts/<NOME>.mq5`

🔴 **E va detto subito, perché cambia cosa significa la tabella:** per **tutti
e quattro** `b45dd00` è **la TESTA del branch** — verificato con
`git diff b45dd00 HEAD -- <file>` = **vuoto** su tutti e quattro. Quindi il
diff `e2a10a7..b45dd00` **è esattamente ciò che il driver compilerebbe** in
più rispetto a prima. Non è un commit intermedio.

| EA | righe | hunk | diagnostica | toccano il trading | **verdetto** |
|---|---|---|---|---|---|
| `ABTG_SuperWave_DOW_H1_Ottimizzato` | +147 / −18 | 7 | **7** | **0** | 🟢 **NEUTRO** |
| `ABTG_SuperWave` | +147 / −18 | 7 | **7** | **0** | 🟢 **NEUTRO** |
| `ABTG_SupertrendReversal_Ottimizzato` | +145 / −16 | 8 | **8** | **0** | 🟢 **NEUTRO** |
| `ABTG_CostToCost` | +120 / −3 | 8 | **8** | **0** | 🟢 **NEUTRO** |

**Nessun NON NEUTRO. Quindi il §"per i NON NEUTRI: quale riga" resta VUOTO**,
e lo scrivo esplicitamente invece di ometterlo: non c'è nessuna riga da
segnalare.

### Dettaglio degli hunk (SuperWave e SuperWave_DOW, 7 hunk identici)

| # | dove | cosa fa | classe |
|---|---|---|---|
| 1 | dopo `input bool InpVerbose` | aggiunge `input bool InpLogImbuto = true` + 6 righe di commento | diagnostica |
| 2 | dopo `void Log(...)` | 18 contatori `long` + 3 variabili di stato `gImb*` + le 3 funzioni `ImbutoRaccogli` / `ImbutoStampa` / `ImbutoGiro` (**solo `Print`**) | diagnostica |
| 3 | `OnDeinit` | `+ ImbutoStampa("parziale del ...")` | diagnostica |
| 4 | `OnTick`, prima riga | `+ ImbutoGiro();` | diagnostica |
| 5 | `OnNewBar` | `cV_valutate++` in testa + **14 `return` rivestiti** | diagnostica |
| 6 | `Enter` | `cO_sl++` / `cO_lotto++` in due `return` | diagnostica |
| 7 | `Enter` | `cO_guardian++` / `cO_invio++` + `cI_entrate++` dopo l'invio riuscito | diagnostica |

### 🟢 E i due SuperWave non sono «la stessa forma»: sono lo STESSO DIFF

Il mandato avvisava che *"la stessa forma NON è una prova"*. Giusto, e non
l'ho usata. L'ho **sostituita con un'uguaglianza**:

```
diff <(sed 's/ABTG_SuperWave_DOW_H1_Ottimizzato/ABTG_SuperWave/g' swd.diff) sw.diff
```

→ **UNA SOLA differenza**, ed è una **riga di contesto** (non modificata) nel
titolo di un hunk: `input long InpMagic = 770511;` contro `= 770501;`.
👉 Il verdetto su `ABTG_SuperWave_DOW_H1_Ottimizzato` è **lo stesso oggetto
matematico** di quello su `ABTG_SuperWave`, non un'analogia.

### Dettaglio: `ABTG_SupertrendReversal_Ottimizzato` (8 hunk)

Identico allo schema sopra, con **un hunk in più** (il 6°) sul blocco pattern:
`cF_pattern++` nel `return` del pattern di rimbalzo e `cF_confl++` in quello
della confluenza EMA. Condizioni invariate (sotto).

### Dettaglio: `ABTG_CostToCost` (8 hunk)

Qui il funnel `[COST-FUNNEL]` **esisteva già** ma lo stampava **solo
`OnTester()`** — quindi in backtest parlava e in forward mai. Il WIP aggiunge
un riepilogo di **fine giornata** e **4 contatori nuovi** (`cT_busy`,
`cT_dup`, `cT_guardian`, `cA_armati`, `cV_conferme`) per **chiudere la somma**.

🔎 **Una cosa da guardare, e non è un difetto ma va detta:** al punto 7
l'autore ha lasciato `cF_busy++` **e** aggiunto `cT_busy++` sulla **stessa**
riga:

```
- { cF_busy++; DisarmaSegnale(); return; }
+ { cF_busy++; cT_busy++; DisarmaSegnale(); return; }
```

👉 È la scelta **giusta** e la più conservativa possibile: `cF_busy` continua a
contare **esattamente** come prima, quindi la riga `[COST-FUNNEL] FILTRI` di
`OnTester()` **non cambia di un'unità**, e `cT_busy` serve solo a separare i
due punti che alimentano `cF_busy`. 🟢 **Il funnel storico resta confrontabile
con l'archivio.**

---

## 🔴 3. I TRE CONTROLLI CHE CONTANO — e i CONTRO-ESEMPI che li validano

### 3.1 ✅ Le condizioni sono identiche — dimostrato, non guardato

Non mi sono fidato dell'occhio. Ho normalizzato ogni riga (via i commenti, via
gli incrementi `cX_++;`, via le graffe aggiunte, via lo spazio) e ho chiesto:
**ogni riga RIMOSSA ha una gemella IDENTICA fra le aggiunte?**

| EA | righe rimosse | **rimosse SENZA gemella identica** |
|---|---|---|
| `ABTG_SuperWave_DOW_H1_Ottimizzato` | 18 | **0** |
| `ABTG_SuperWave` | 18 | **0** |
| `ABTG_SupertrendReversal_Ottimizzato` | 16 | **0** |
| `ABTG_CostToCost` | 3 | **0** |

🔴 **E QUI STA IL CONTRO-ESEMPIO, perché senza di lui quel «0» non vale
niente.** «Zero differenze» è esattamente il risultato che uscirebbe anche da
uno strumento rotto. Quindi ho costruito io i difetti che DEVE trovare:

| contro-esempio | atteso | ottenuto |
|---|---|---|
| `if(A && (...))` → `if(A \|\| (...))` dentro un blocco di diagnostica | deve emergere | 🟢 **emerge** |
| `if(risk<minDist)` → `if(risk<=minDist)` (**un solo carattere**) | deve emergere | 🟢 **emerge** |
| `InpAllowShort = true` → `= false` travestito da commento *"IMBUTO: solo log"* | deve emergere | 🟢 **emerge** |
| la riga **vera** di `b45dd00` | NON deve emergere | 🟢 **non emerge** |

👉 Lo strumento distingue un `&&` da un `||` e un `<` da un `<=`. **Poi** il suo
zero vuol dire qualcosa.

E le 14 condizioni di `OnNewBar` le riporto per nome, perché un conteggio
aggregato nasconde: `!SupertrendSeries(5,dir,line)` · `HasPending()` ·
`InpMaxTradesPerDay>0 && gTradesToday>=InpMaxTradesPerDay` ·
`InpUseTimeWindow && (now.hour<InpStartHour || now.hour>=InpEndHour)` ·
`InpUseNewsFilter && InNewsBlackout(TimeCurrent())` · `!SpreadOK()` ·
`CopyBuffer(hE1,0,1,2,e14)!=2` · `CopyBuffer(hE4,0,1,2,e200)!=2` ·
`!crossUp && !crossDn` · `crossUp && d1<=0` · `crossDn && d1>=0` ·
`up && !InpAllowLong` · `!up && !InpAllowShort` · `atr<=0`.
**Tutte e 14 byte per byte identiche.** (Su SupRev, al posto delle due EMA e
dei due cross: `d1!=d2`, `!(touch && closeNear && opensInside && bodyOK)`,
`InpUseConfluence && !ConfluenceOK(stTouch,atr)`.)

🟡 **Un caso che merita una riga a sé**, perché è l'unico dove l'incremento non
sta dentro un `return`: in `OnNewBar` il blocco `if(HasPosition())` ha
`cB_occupata++` messo come **prima istruzione del blocco**, prima di
`int d1=(int)dir[1];`. Il blocco ha **due uscite** (uscita al flip, e il
`return` finale) e l'incremento è **uno solo** per entrambe — dichiarato nel
commento dell'autore. 🟢 Non tocca il comportamento: `CloseAllPositions()` e
`CancelPendings()` restano dentro la **stessa** condizione
`InpExitOnFlip && ((d1<0 && LongOpen())||(d1>0 && ShortOpen()))`, invariata.

### 3.2 ✅ Nessun contatore entra in una condizione — dimostrato

Ho estratto il **testo fra le parentesi** di ogni `if` / `while` / `for`
(parser a profondità di parentesi, non un grep di riga) e cercato dentro **solo
quello** i nomi dei contatori:

| EA | contatori | **contatori DENTRO una condizione** |
|---|---|---|
| `ABTG_SuperWave_DOW_H1_Ottimizzato` | 18 | **0** |
| `ABTG_SuperWave` | 18 | **0** |
| `ABTG_SupertrendReversal_Ottimizzato` | 18 | **0** |
| `ABTG_CostToCost` | 32 | **0** |

🔴 **Contro-esempio, di nuovo**, perché un grep ingenuo di riga direbbe «0»
anche su un EA compromesso (il contatore nel corpo e la condizione sulla stessa
riga si confondono):

| riga data in pasto | atteso | ottenuto |
|---|---|---|
| `if(cB_spread<3 && !SpreadOK()){ cB_spread++; return; }` | **BECCATO** | 🟢 beccato |
| `if(InpMaxTradesPerDay>0 && cI_entrate>=InpMaxTradesPerDay) return;` | **BECCATO** | 🟢 beccato |
| `if(!SpreadOK()){ cB_spread++; return; }` (la riga vera) | **pulito** | 🟢 pulito |

⚠️ **E dichiaro l'unica eccezione, invece di nasconderla dietro lo «0»:** i
contatori entrano in una condizione **due volte**, e **solo dentro
`ImbutoStampa()`**: `if(d[0]<=0 && somma<=0) return;` (salta la riga nei giorni
senza candidate) e il ternario `((somma==d[0])?"OK":"ROTTA: ...")` dentro la
**stringa** della quadratura. Il mio parser non le conta perché lavorano su
`d[]` e `somma`, non sui contatori: le ho trovate a occhio e le scrivo qui.
🟢 Governano **se e cosa si stampa**, niente altro — `ImbutoStampa` non ha
nessuna via d'uscita verso il trading (§3.3).

### 3.3 ✅ Le righe AGGIUNTE non introducono niente — il buco che avevo io

🔴 **Il 3.1 ha un buco, e me lo dichiaro:** prova che le righe **rimosse**
sopravvivono, **non** che le **aggiunte** non portino logica nuova. Su +147
righe quel buco è grosso. Tre chiusure:

**(a) classificazione di tutte le righe aggiunte.** Il residuo «da guardare a
mano» è **62 righe** su 147, e sono **esattamente** i corpi delle tre funzioni
`Imbuto*` — che ho letto per intero: `ArrayResize` / `ArrayInitialize`, una
sottrazione, `IntegerToString`, `TimeToStruct`, `Print`. **Nessuna chiamata al
mercato, nessuna assegnazione a stato dell'EA.**

**(b) il conteggio delle chiamate di trading, prima e dopo.** Su
`OrderSend`, `gTrade.Buy`, `gTrade.Sell`, `gTrade.BuyStop`, `gTrade.SellStop`,
`PositionModify`, `PositionClose`, `OrderDelete`:

> 🟢 **su tutti e quattro gli EA, il conteggio è IDENTICO fra `e2a10a7` e
> `b45dd00`.** L'**unica** differenza su tutta la lista di controllo è
> `input `: **+1** su ognuno — cioè `InpLogImbuto`, ed è l'unica cosa che
> deve cambiare.

**(c) lo stato nuovo è confinato.** `gImbSnap` / `gImbGiorno` / `gImbData`
compaiono **solo** dentro le tre funzioni `Imbuto*` più la chiamata in
`OnDeinit` — elencate riga per riga su tutti e quattro. **Nessun'altra parte
dell'EA le legge.** Stessa cosa per `InpLogImbuto`: **3 occorrenze** per file
(la dichiarazione + le due guardie `if(!InpLogImbuto) return;` in
`ImbutoStampa` e `ImbutoGiro`). 🟢 Quindi `ImbutoGiro()`, che gira in testa a
`OnTick()` **prima** di `ManageAll()`, non può spostare niente di ciò che
`ManageAll()` legge dopo.

### 3.4 ⚠️ Le DUE cose che cambiano davvero, e non sono il trading

Le dichiaro perché «neutro sul trading» non è «identico»:

1. 📜 **il volume dei log.** In una **passata singola** esce **1 riga al
   giorno** (3 su CostToCost). Su EURJPY 6,5 anni ≈ **1.700 giorni** → ~5.000
   righe. Innocuo, ma è spazio su disco e un Giornale più lento da aprire.
   🟢 In **ottimizzazione** MT5 sopprime `Print`, e i 12 round sono
   ottimizzazioni: lì il costo è ~zero.
2. ⏱️ **`ImbutoGiro()` gira a OGNI tick** e chiama `TimeCurrent()` +
   `TimeToStruct()`. Su modello «ogni tick» sono milioni di chiamate: due
   operazioni banali, ma **non gratis**. Potrebbe far salire di poco il tempo
   per passata. 🔴 **Non cambia i risultati** (nessuno dei due tocca stato
   letto dal trading): cambia l'orologio del tester. Se una notte dovesse
   sforare, questa è la riga da guardare.

---

## 🔗 4. LA CATENA DEGLI `#include` — e il secondo WIP che nessuno aveva nominato

### 4.1 Qual è la catena

🟢 **Tutti e quattro hanno la STESSA catena, e conta due voci sole:**

```
#include <Trade/Trade.mqh>            -> DI SISTEMA (MT5 ce l'ha)
#include <ABTG_PausaGuardian.mqh>     -> NOSTRO, scaricato dalla testa di `lavoro`
```

`ABTG_PausaGuardian.mqh` **non include niente di nostro** (le sue uniche
occorrenze di `#include` sono in due commenti): la catena è **profonda 1**, non
c'è un terzo livello da inseguire.

E il driver li porta davvero: `walkforward_generico.ps1` r.239
`$EABranch="lavoro"`, r.240 `$RawBase=.../$EABranch`, poi la lista
`$NostriInclude` (`ABTG_PausaGuardian.mqh` con `Serve=$true`) scaricata e
copiata sul terminale. **Stessa testa del `.mq5`.**

### 4.2 🔵 IL RITROVAMENTO: c'è un SECONDO file in «LAVORO IN CORSO»

`git log -1 -- mql5/Include/ABTG_PausaGuardian.mqh` →
**`cdb2037` (07/09/2026)**, messaggio: **«LAVORO IN CORSO — tetto cluster C2
collegato, SPENTO di default. E PIANO_PROP»**.

🔴 Quindi il binario di questi round nasce da **DUE** file col cartello
«lavoro in corso», non uno. `b45dd00` **non ha toccato l'include**
(`git diff --stat e2a10a7 b45dd00 -- mql5/Include/` è **vuoto**): è un WIP
**indipendente e più vecchio di quattro giorni**.

Dall'ultima verifica dell'include (`e72546e`) a `cdb2037` sono **+506 / −2**
righe.

### 4.3 🟢 Perché quel movimento è INERTE per questi quattro EA

**Per quanti argomenti chiamano la libreria** — è la domanda del mandato, e la
risposta è la stessa su tutti e quattro:

```
ABTG_GuardiaIngresso(InpUsaGuardian, "<nome EA>")      // 2 argomenti su 13
```

`SuperWave_DOW` r.395 · `SuperWave` r.395 · `SupertrendReversal_Ottimizzato`
r.402 · `CostToCost` r.855. **Gli altri 11 parametri restano ai default**, e
sono default **opt-in**. Percorso dentro `ABTG_GuardiaIngresso` (r.1587-1752),
cancello per cancello:

| # | cancello | perché non morde |
|---|---|---|
| 1 | `if(!attiva) return(true)` | `InpUsaGuardian = true` in tutti e quattro → **passa oltre** (non è qui che si ferma) |
| 2 | **S1** obiettivo | `obiettivo_pct=0.0` e `saldo_riferimento=0.0` → `if(obiettivo_pct>0.0 && ...)` falso |
| 3 | **P1** perdite consecutive | `soglia_perdite_consecutive=0` → `if(soglia>0 && ...)` falso |
| 4 | **P0** tetto simbolo+lato | `tetto_simbolo_lato=0` **e** `lato_ingresso=ABTG_LATO_NULLO` → `if(tetto>0 && lato!=NULLO)` falso su **entrambi** i termini |
| 5 | **C2** tetto cluster *(il codice nuovo di `cdb2037`)* | `cluster_mappa=""` → `if(StringLen(cluster_mappa)>0)` falso. 👉 **Tutte** le funzioni nuove (`ABTG_ClusterParse_Calc`, `ABTG_ClusterSaturo`, `ABTG_ClusterFiloOk`, `ABTG_ClusterGVRadice`) sono raggiungibili **solo** da dentro quel blocco: sono **codice morto** per un chiamante a 2 argomenti |
| 6 | **B1/C1** | `if(!ABTG_CanaleEsiste()) return(true);` — r.699-705: vero solo se esiste una `GlobalVariable` fra `ABTG_GUARDIAN_BATTITO` / `ABTG_PAUSA_GIORNO` / `ABTG_CAP_RISCHIO` (nome suffissato con `ACCOUNT_LOGIN`, r.658-661). **Nessuno dei quattro EA contiene un solo `GlobalVariableSet`** (verificato: 0, 0, 0, 0) → nel tester il canale non esiste → **fail-open** |

E le **2 righe cancellate** da `cdb2037`? Sono `const string simbolo_tetto="")`
(l'ultimo parametro della vecchia firma, che ora continua con due parametri in
più) e la stringa di versione dell'autotest `v1.51`. 🟢 Nessuna delle due è
raggiungibile da una chiamata a 2 argomenti.

### 4.4 🟢 E IL CONTRO-ESEMPIO, che qui è una MISURA in archivio

🔴 Tutto il §4.3 è **lettura di codice**: dice che *dovrebbe* essere inerte.
Il mandato chiede di provare a **romperlo**. La domanda che lo romperebbe è
una sola: **«e se l'include a `cdb2037` non compilasse, o se la guardia nel
tester bloccasse gli ingressi?»** — in quel caso i round escono con
`Trades = 0` e non lo scopriremmo leggendo.

👉 **Ho cercato una corsa GIÀ FATTA dopo il 07/09 con la stessa catena, e c'è.**

`mql5/Experts/ABTG_SupRev_DOW_H1_Ottimizzato.mq5` (fermo a `872dba8`, 08/09,
**non** toccato da `b45dd00`) ha **la catena identica**: r.32
`#include <Trade/Trade.mqh>`, r.33 `#include <ABTG_PausaGuardian.mqh>`, r.275
`ABTG_GuardiaIngresso(InpUsaGuardian,"...")` — **2 argomenti su 13**, esattamente
come i nostri quattro. Ed è passato dal driver **sul VPS il 09/09 alle 20:19**
(commit `7209f76` e gemelli), cioè **due giorni DOPO `cdb2037`** e **un giorno
DOPO** che il driver ha iniziato a scaricare gli include (`0de31c0`, «driver
v5: porta gli #include NOSTRI sul terminale», 08/09).

Cosa dicono quei CSV:

| file | celle | `InpUsaGuardian=1` | celle che OPERANO | trade |
|---|---|---|---|---|
| `..._IS_R123AGATE.csv` | 2 | 2 | 2 | 234 |
| `..._IS_R123BSTMULT.csv` | 5 | 5 | 5 | 638 |
| `..._IS_R123CATRP.csv` | 7 | 7 | 7 | 820 |
| `..._IS_R123DNEARATR.csv` | 5 | 5 | 5 | 530 |
| `..._OOS_R123AGATE.csv` | 2 | 2 | 2 | 304 |
| `..._OOS_R123BSTMULT.csv` | 5 | 5 | 5 | 842 |
| `..._OOS_R123CATRP.csv` | 7 | 7 | 7 | 1067 |
| `..._OOS_R123DNEARATR.csv` | 5 | 5 | 5 | 751 |
| **TOTALE** | **38** | **38/38** | **38/38** | **5.186** |

🟢 **Due fatti, non due inferenze:**
1. **l'include a `cdb2037` COMPILA** — se no, il driver moriva sul `.ex5`
   mancante e non c'erano CSV;
2. **la guardia a 2 argomenti è fail-open nel tester** — `InpUsaGuardian = 1`
   in **38 celle su 38** e ci sono **5.186 operazioni**. Se mordesse,
   vedremmo `Trades = 0`.

📌 Caveat onesto: questo assolve **l'include**, non il `.mq5`. `872dba8` non
è `b45dd00`: il codice dell'imbuto **non è mai stato compilato da nessuno**.
E il **driver** si è mosso 4 volte dopo il 09/09 (fra cui `d33b23a`, un altro
«IN CORSO D'OPERA»; la testa oggi è `9cba7a1`, che non lo è) — fuori dal mio
mandato, ma chi lancia lo sappia.

---

## 📌 5. L'ANCORA DI OGNUNO, con il commit del binario che l'ha prodotta

| round | EA | ancora (PF · n · DD) | fonte | **commit del BINARIO** | commit di deriva **fino a oggi** | l'ancora è un cancello di validità? |
|---|---|---|---|---|---|---|
| **r126a** · r126b · r126c | `SuperWave_DOW_H1_Ott.` | IS **PF 1,84892 · n 84 · DD 3,7267%** / OOS **PF 1,32770 · n 143 · DD 3,9082%** | `risultati_prove/ABTG_SuperWave_DOW_H1_Ottimizzato/..._{IS,OOS}.csv`, **dichiarato nel file prova r.262-263** | 🟢 **`400a462` (08/08/2026)** — scritto nel file prova, non ricavato da me | `7f80a87`(17/08) · `f8ebc32`(19/08) · `872dba8`(08/09) · **`b45dd00`(11/09)** | 🟡 **NO come cancello, SÌ come metro** — e il file prova lo sa già: ha **tre gradi** (A/B/C) e la finestra è diversa (`-Fino` taglia 642 giorni) |
| r120b ×4 · r120e ×2 | `SuperWave_DOW_H1_Ott.` | finestra piena **PF 1,52 · n 227 · DD 4,0%**; r3 tick: IS **PF 1,44 n 75 DD 4,77%** / OOS **PF 1,33 n 143 DD 3,91%** | `REGISTRO_TEST.md` r.476 (26/07) + censimento 09/09 r.111 | 🟡 **`a4107cf` (26/07/2026)** — *ricavato da me* dalla data del CSV d'archivio, **non dichiarato nel file prova** | **sei** commit, fra cui `3af47ed`(08/08 sizing) e `872dba8`(08/09) | 🔴 **NO**: il file prova chiama quei numeri *"il METRO, non il verdetto"* — ed è la parola giusta |
| **r126d** | `SuperWave` | **PF 1,02213 · n 97 · DD 3,3131%** (OHLC) | `risultati_archivio/SuperWave/valid_SuperWave_NASUSD_H1.csv` | 🟡 **`a4107cf`/`a86089c` (26/07/2026)** — *ricavato da me* | come sopra + `a5d36d8`(11/08) | 🔴 **NO**, e il file prova lo dice da sé: *"NON è un'ancora al centesimo, è un ordine di grandezza"* |
| **r127b** | `SupertrendReversal_Ott.` | **DD 9,02% · n 657** · PF **[NON MISURATO]** | `prove/R99_ORO_22ANNI_RISCHIO.txt` (23/08) | 🟢 **`f8ebc32` (19/08/2026)** — *ricavato da me* (è l'unico commit del `.mq5` prima del 23/08) | 🔴 **`872dba8`(08/09)** + **`b45dd00`(11/09)** | 🔴 **NO — e il motivo NON è `b45dd00`**: vedi §5.1 |
| **r127c** | `CostToCost` | **PF 1,41 · n 394 · DD 12,3%** (OHLC M1, finestra piena 6,5 anni) | `prove/R103_ABTG_CostToCost_EURJPY_772361.txt`, copiato riga per riga nel file prova | 🟢 **`26a1856` (19/08/2026)** — *ricavato da me* | 🟢 **SOLO `b45dd00`** | 🟢 **SÌ, ed è il caso più pulito dei quattro**: vedi §5.2 |

### 5.1 🔴 `r127b`: l'ancora è a rischio per una ragione che non è il WIP

Fra R99 (23/08, binario `f8ebc32`) e oggi c'è **`872dba8`** (08/09), che su
`ABTG_SupertrendReversal_Ottimizzato` **non è diagnostica**: sposta il
pavimento del lotto minimo **prima** del calcolo di `lotPend`.

```
- double lotPend=NormVol(totLot-lotMkt);
  if(lotMkt<=0) lotMkt=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
+ double lotPend=NormVol(totLot-lotMkt);
```

È una **correzione di un bug reale** (col vecchio ordine il volume totale
poteva arrivare a `totLot+volMin`, misurato in campo 1,42% su un contratto
dell'1,0%), quindi **si vuole tenere**. Ma **cambia i volumi** quando
`NormVol(totLot*InpFirstFraction)=0` — e su XAUUSD H4 a 22 anni, con equity
piccola nei primi anni, quel ramo **può** scattare.

👉 Conseguenza operativa, ed è la **classe 267-bis**
(`R124a_U30USD_04_firstfraction.txt` r.103-127): **se l'ancora di `r127b` non
torna, il round resta LEGGIBILE** — tutte e 7 le celle girano sullo **stesso**
binario, quindi la **forma dell'asse `InpSLLookback`** è valida. Muore solo il
confronto col numero del 23/08. 🔴 E chi legge il referto **non deve
attribuire la differenza a `b45dd00`**: il sospetto numero 1 è `872dba8`, e
`b45dd00` è quello con l'alibi (§3).

⚠️ Nota aggiuntiva: R99 **non dichiara il PF**. Quindi su `r127b` l'ancora
sarebbe comunque solo **n + DD**, e il PF si leggerebbe lì **per la prima
volta**. Il file prova lo scrive già (r.64-67). 🟢 Onestà già in casa.

### 5.2 🟢 `r127c`: il round che collauda il WIP

`ABTG_CostToCost` ha una storia di **tre** commit in tutto: `9b1c611` (13/08,
nascita), `26a1856` (19/08, Guardian), **`b45dd00`** (11/09). L'ancora R103 è
del **24/08** → binario `26a1856`.

👉 **Fra l'ancora e oggi c'è UN SOLO commit, ed è quello che ho appena
verificato.** Quindi `r127c` è anche il **collaudo empirico** del mio verdetto:
se `b45dd00` è davvero diagnostica, `n_IS + n_OOS` deve ricomporre **394 ±2%**
e il PF stare a **1,41 ±0,03**, come il file prova pretende (r.54-64).
🔴 **Se non torna, il mio §3 ha sbagliato** — e sarà l'unico caso dei dodici in
cui l'ancora punta il dito su `b45dd00` senza ambiguità.

### 5.3 ✏️ Un aggiornamento che serve a `R126a` (non l'ho fatto io: non tocco i file prova)

`prove/R126a_costo_bufferatr_U30USD.txt` r.269-270 dice: *«fra l'08/08 e oggi
il sorgente è cambiato **quattro** volte, git log alla mano»* e poi elenca
**tre** sospetti (`872dba8`, `f8ebc32`, `7f80a87`).

🟡 **Oggi sono CINQUE**: manca **`b45dd00`**, che è arrivato dopo che quel file
è stato scritto. 🟢 Il **sospetto nuovo è il meno sospetto di tutti** (§3), ma
la lista va chiusa, perché il valore di quel blocco è di essere **completo**:
una lista di sospetti con un buco è peggio di nessuna lista.
👉 Segnalato, **non modificato** — i file prova non sono nel mio mandato.

---

## 🚀 6. QUALI DEI 12 ROUND SI POSSONO LANCIARE, PER NOME

L'elenco dei 12 è di `report/CORRI_OGGI_2026-09-13.md` §2 (r.34-39), non mio.
Verdetto **limitato a questo cancello**: *«l'EA sta su un commit NON
COMPILARE»*.

| # | file prova | EA | 🔓 sbloccato da questa lettura? |
|---|---|---|---|
| 1 | `prove/R120b_U30USD_00_nuda.txt` | `SuperWave_DOW_H1_Ott.` | 🟢 **SÌ** |
| 2 | `prove/R120b_U30USD_01_notrail.txt` | `SuperWave_DOW_H1_Ott.` | 🟢 **SÌ** |
| 3 | `prove/R120b_U30USD_10_noflip.txt` | `SuperWave_DOW_H1_Ott.` | 🟢 **SÌ** |
| 4 | `prove/R120b_U30USD_11_vivo.txt` | `SuperWave_DOW_H1_Ott.` | 🟢 **SÌ** |
| 5 | `prove/R120e_U30USD_00_nuda_TAGLIA.txt` | `SuperWave_DOW_H1_Ott.` | 🟢 **SÌ** |
| 6 | `prove/R120e_U30USD_11_vivo_TAGLIA.txt` | `SuperWave_DOW_H1_Ott.` | 🟢 **SÌ** |
| 7 | **`prove/R126a_costo_bufferatr_U30USD.txt`** | `SuperWave_DOW_H1_Ott.` | 🟢 **SÌ** — la sedia al **96% del pavimento di costo** |
| 8 | `prove/R126b_stop_lookback_U30USD.txt` | `SuperWave_DOW_H1_Ott.` | 🟢 **SÌ** |
| 9 | `prove/R126c_gemelli_U30USD.txt` | `SuperWave_DOW_H1_Ott.` | 🟢 **SÌ** |
| 10 | `prove/R126d_costo_bufferatr_NASUSD.txt` | `SuperWave` | 🟢 **SÌ** |
| 11 | **`prove/R127b_sllookback_XAUUSD.txt`** | `SupertrendReversal_Ott.` | 🟢 **SÌ** — `InpSLLookback`, **1 dei 3 assi d'uscita mai mossi** (5 valori in 290 CSV) · ⚠️ leggere §5.1 sull'ancora |
| 12 | **`prove/R127c_orologio_EURJPY.txt`** | `CostToCost` | 🟢 **SÌ** — `InpMaxBarsHold`, **1 dei 3 assi mai mossi** (100 in 128 CSV) · 🟢 ancora la più solida (§5.2) |

### 🔴 MA «SBLOCCATO DA QUESTO CANCELLO» ≠ «LANCIABILE». Cosa NON ho verificato

Il mio verdetto apre **una** porta. Le altre le tiene chiuse qualcun altro, e
**due sono già scritte in casa**:

1. 🔴 **`CORRI_OGGI` §3 dice che 20 dei 53 non sono lanciabili per un'altra
   ragione** (la riga `-FrazioneIS 0.50 NON E' OPZIONALE`). **Non ho
   controllato se qualcuno di questi 12 è fra quei 20.** Va fatto prima di
   metterli in coda — è fuori dal mio mandato ma dentro il rischio.
2. 🔴 **Nessuno di questi quattro `.mq5` è mai stato compilato.** «Il diff è
   neutro» **non è** «compila». Ho fatto solo i controlli che si possono fare
   a occhio: `ABTG_LATO_NULLO` è a r.1124 e le quattro funzioni cluster a
   r.1333-1485, tutte **prima** di `ABTG_GuardiaIngresso` (r.1587) → nessuna
   dipendenza in avanti; le tre `Imbuto*` sono dichiarate prima di chi le
   chiama; i contatori di `CostToCost` (r.229-238 e r.267-271) prima di
   `ImbutoRaccogli` (r.293). 🟡 **Sono indizi, non una prova.**
   👉 **Il fallimento, se c'è, è quello giusto: rumoroso e innocuo** — il
   driver non trova il `.ex5`, esce con un messaggio che dice perché, e non
   produce nessun numero falso.
3. 🟡 **Il modo più economico di chiudere il punto 2 esiste già** e non sono io
   a doverlo inventare: `backtest_pipeline/righe/RIGA_COLLAUDO_RICOMPILA.ps1`
   cita `b45dd00`. 👉 **Una compilazione sola su UNO dei quattro** (consiglio
   **`ABTG_SuperWave`**: il diff più grande dei tre gemelli, e il suo verdetto
   è matematicamente lo stesso di `SuperWave_DOW`, quindi copre **10 round su
   12** in un colpo) chiude il dubbio su tutti. È il rapporto
   valore/costo più alto che resta su questo tavolo.

---

## 📋 7. CAVEAT, tutti in un posto

1. 🔴 **Non ho compilato e non ho eseguito nulla.** Non ho MetaEditor né
   Strategy Tester.
2. 🔴 **Non ho modificato nessun EA**, nessun `#define`, nessun default,
   nessun file prova, **nessuna riga di `CODA.txt`**, nessun preset, niente
   forward, nessuna taglia, nessun rischio.
3. 🟡 **«Neutro sul trading» è dimostrato per i 30 hunk letti**, con tre
   controlli meccanici **validati da contro-esempi**. Non è dimostrato che il
   codice **compili** (§6 punto 2).
4. 🟡 **Due commit del binario sono ricavati da me, non dichiarati in un
   file**: `a4107cf` (r120b/r120e/r126d) e `f8ebc32` (r127b), ottenuti dalla
   data dell'artefatto d'ancora incrociata col `git log` del `.mq5`. 🔴 È
   un'**inferenza**, non un fatto scritto: se qualcuno ha un pin esplicito,
   vince il suo. I due 🟢 (`400a462`, `26a1856`) sono più solidi — il primo è
   **scritto nel file prova**, il secondo è **l'unico commit possibile** (l'EA
   ne ha tre in tutto).
5. 🟡 **Il §4.4 assolve l'INCLUDE, non il `.mq5`**: `ABTG_SupRev_DOW_H1_Ottimizzato`
   è a `872dba8`, non a `b45dd00`.
6. 🟡 **Il driver si è mosso 4 volte dopo il collaudo del 09/09** (uno di quei
   commit è un altro «IN CORSO D'OPERA», `d33b23a`; la testa di oggi
   `9cba7a1` non lo è). Fuori mandato, dentro il rischio di chi lancia.
7. 🟢 **Nessun numero di performance è mio.** PF, n e DD di questo referto
   vengono tutti da un CSV o da un file prova **citato per nome**. Gli unici
   conti che ho fatto io sono conteggi di righe, di hunk e di trade —
   riproducibili con i comandi in §2 e §3.
