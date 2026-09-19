# 📐 LA MISURA DEL DELTA LOTTI — `771531` e `770511` su U30USD

**19/09/2026** · branch `lavoro` · firma di Claudio: *«Misura prima, lancia la corsa nel tester»*
Pacchetto che questa misura sblocca: `report/COMPILAZIONE_771531_770511_2026-09-19.md`
Script: `backtest_pipeline/righe/MISURA_LOTTI_U30USD.ps1` · **PIN `fbd31099`**
Prove: `backtest_pipeline/prove/MIS_SIZING_EMA200_U30USD.txt` · `..._SWDOW_U30USD.txt`
EA di misura: `mql5/Experts/ABTG_MIS_SIZING_EMA200.mq5` · `ABTG_MIS_SIZING_SWDOW.mq5`

---

## 🎯 LA DOMANDA, E NE HA UNA SOLA

> **Di quanti LOTTI cambia il volume piazzato, a parità di segnale, passando dal sizing
> del binario IN CAMPO (`344a11b9`) a quello dei pin che stiamo per compilare?**

Non PF. Non DD. Non frequenza. 🔴 **E se cambia anche il numero di operazioni, non è un
risultato: è un difetto**, e la tabella lo dice a caratteri cubitali invece di spiegarlo via.

---

## 🧨 IL PIANO PROPOSTO NON ERA ESEGUIBILE, e l'ho scoperto col `grep` prima di accendere

Il piano diceva: *«confronta la colonna `volume` di `abtg_trades_*.csv` per le quattro
gambe, attento alla classe 455»*. Canale giusto, classe giusta. **Ma:**

```
git show 344a11b9:mql5/Experts/ABTG_EMA200.mq5 | grep -c ExportTrades   ->  0
git show 26a18566:mql5/Experts/ABTG_EMA200.mq5 | grep -c ExportTrades   ->  1
```

🔴 **Il binario VECCHIO quel file non lo scrive.** `ExportTrades()` nasce in `6074126d`
(**08/08**), cioè **dopo** `344a11b9` (**04/08**). Stessa storia su SuperWave. 👉 **Due
gambe su quattro non potevano produrre il dato su cui si reggeva tutto il confronto**, e
lo avremmo scoperto **dopo** aver acceso il banco. È la **classe 470**, nuova: *la
diagnostica è quasi sempre più giovane del codice che deve diagnosticare*.

### ✅ COME L'HO RIDISEGNATA — si isola la variabile, non si ibrida il vecchio

Aggiungere l'export al binario vecchio avrebbe prodotto un ibrido: non sarebbe più stato
«il vecchio». Quindi il contrario:

> **Si prende il ramo NUOVO (che la diagnostica ce l'ha) e gli si mette un INTERRUTTORE
> che riproduce ALLA LETTERA il calcolo vecchio.**

Due EA di misura, ognuno è il `.mq5` **al pin copiato senza toccare niente** più
`input bool InpSizingVecchio`. Le differenze non-di-commento rispetto al pin sono
**cinque** per file, verificate con `diff`: il magic (vergine), l'input nuovo, i due rami
di sizing, il nome del file per-trade, e l'etichetta del `Log`.

🟢 **Il regalo, e non è piccolo:** il binario `.ex5` è **LO STESSO** nelle due gambe,
quindi *«a parità di segnale»* smette di essere una speranza da dimostrare e diventa un
**fatto strutturale**. Se il numero di operazioni differisce, non c'è niente da
interpretare.

| sedia | cosa muove l'interruttore |
|---|---|
| `771531` EMA200 | **un** delta: `LotByRisk` — tick value nudo ↔ `OrderCalcProfit` (`3af47ed9`) |
| `770511` SuperWave | **due**, mossi insieme perché insieme stanno nel binario in campo: `LotByRisk` come sopra **+** l'ordine del pavimento del lotto minimo in `Enter()` (`872dba82`) |

---

## 📏 L'ATTESA, SCRITTA PRIMA DEI NUMERI — e cosa mi farebbe dire che ho sbagliato

### `770511` SuperWave — **mi aspetto una differenza, e verso il BASSO**
Il difetto (b) scatta quando `NormVol(totLot*0.3333)` arrotonda a **0**: allora il vecchio
piazza `totLot + volMin` invece di `totLot`.
- 📉 **Direzione attesa: `SIZNEW / SIZOLD < 1`** (il nuovo piazza **meno**).
- 📊 **Ordine di grandezza atteso: fino a circa 0,5** nel caso peggiore (il vecchio arriva
  a raddoppiare). Il `1,42%` contro un contratto `1,0%` misurato il 20/08 **sulla gemella
  `770531`** suggerisce un rapporto intorno a **0,70** quando il difetto morde a
  intermittenza.
- 🔬 **Dove deve mordere di più: a DEPOSITO 10000**, dove il lotto è piccolo e
  l'arrotondamento a zero è frequente. A 100000 il difetto può non scattare mai.
- 🔴 **Cosa mi farebbe dire che la mia spiegazione è SBAGLIATA**: un rapporto **= 1,0000
  a tutti e due i depositi**. Vorrebbe dire che `totLot*0.3333` non finisce mai sotto il
  lotto minimo su U30USD, e allora il difetto che abbiamo scritto nel referto del
  pacchetto **in campo non si è mai manifestato** — e il «fino al doppio del rischio»
  andrebbe riscritto come **[POSSIBILE MA MAI ACCADUTO su questa sedia]**.
- 🔴 **E un rapporto > 1 (il nuovo piazza di PIÙ) smonterebbe la mia lettura del fix**: la
  correzione dovrebbe solo togliere volume, mai aggiungerne. Se succede, il fix non fa
  quello che il suo commit dichiara, e l'F7 si ferma lì.

### `771531` EMA200 — **mi aspetto NESSUNA differenza, ed è la previsione più a rischio**
Il commit `3af47ed9` dichiara: *«sui simboli sani i due calcoli coincidono»*. U30USD dovrebbe
essere sano (indice USD, conto EUR, tick value che il broker converte).
- 📐 **Attesa: rapporto = 1,0000 esatto**, a tutti e due i depositi, e **volume identico
  deal per deal**.
- 🔴 **Cosa mi farebbe dire che ho sbagliato**: **qualunque** scostamento da 1,0000.
  Vorrebbe dire che su U30USD il tick value **mente**, cioè esattamente il caso `225JPY`
  che ha generato il fix — e allora il binario in campo sta dimensionando male da agosto,
  e la notizia sarebbe molto più grossa di questa misura.
- ⚠️ **Perché questa è la previsione a rischio**: sto prevedendo uno ZERO. Uno zero
  «previsto» è l'attesa più facile da confermare per sbaglio — se la corsa non produce
  nulla, anche quello «sembra» zero. Per questo lo script distingue **`2 = NON MISURATO`**
  da **`0 = girato`**, e per questo la tabella stampa il **conteggio dei deal** accanto al
  volume: uno zero con `deal 0` non è una conferma, è un buco.

---

## ⚙️ COME GIRA, e perché DUE depositi

**2 EA × 2 depositi = 4 chiamate al driver di round.** Ogni chiamata gira **2 celle**
(`InpSizingVecchio` 0 e 1) **× 2 finestre** (IS/OOS) = 4 passate. **16 passate in tutto.**

🔴 **I due depositi non sono prudenza, sono il cuore della misura.** Il difetto del
pavimento si vede **solo dove il lotto è piccolo**. Misurare a un deposito solo vuol dire
rischiare di certificare *«nessuna differenza»* proprio sul caso in cui non ce n'è — è la
**classe 178**, la banda provata contro il nulla invece che contro l'ipotesi alternativa.
**100000** = dove il parziale esegue. **10000** = dove si arrotonda.

📌 **IS e OOS qui non selezionano niente**: sono **due repliche** della stessa misura su
finestre che non si sovrappongono. Costano **le stesse barre** di una tranche sola
(40%+60% = la finestra intera) e danno il doppio delle prove. *(La prima stesura metteva
`@FRAZIONEIS 1.0`: l'avrei pagata con una gamba OOS degenere a finestra vuota, che il
driver stesso avvisa non descrivere niente.)*

**La finestra: `2024.09.26 → 2026.06.30`, MISURATA e non scelta** — U30USD ha inizio
storico `2024.09.26` con stato COMPLETO (`risultati_archivio/REFERTO_SONDA_STORICO_17-08.md`
r.46, la stessa fonte già usata dalla sonda dell'orologio).

### 🔒 La classe 455, uccisa alla radice
Il file per-trade di casa si chiama `abtg_trades_<EA>_<SIM>_<MAGIC>.csv` — **l'EA stesso
dichiara nel commento** che in griglia ogni cella sovrascrive la precedente. Nello
strumento di misura il nome porta dentro **tutte** le variabili della corsa:
`abtg_mis_<EA>_<SIM>_<MAGIC>_SIZ{OLD|NEW}_DEP<deposito>_<data>.csv`.
👉 Collisione impossibile **per costruzione**, non per attenzione. E lo script **cancella**
i file della corsa precedente **prima** di lanciare (classe 23) e raccoglie **solo** quelli
scritti dopo l'avvio.

---

## ⏱️ IL COSTO IN TEMPO MACCHINA — con la banda, e col tetto nella riga

| voce | stima |
|---|---|
| passate totali | **16** (4 chiamate × 2 celle × 2 finestre) |
| barre per passata | ~11.000 (H1, 21 mesi) — **modello 4, tick reali** |
| per chiamata (avvio MT5 + compilazione + 4 passate) | **4-15 min** |
| **totale atteso** | 🟢 **20-60 minuti** |
| **tetto nella riga** | **20 min PER CORSA** (`-TettoMinutiPerCorsa 20`), cioè **80 min** nel caso peggiore |

🔴 **Il tetto non ferma tutto: ferma QUELLA corsa e va avanti.** Una gamba che sfonda il
tetto esce come **NON MISURATA** con il suo rilievo, e le altre tre si misurano lo stesso.
*«Non è girata»* è già una risposta, e si consegna comunque.

---

## 🖥️ DOVE SI MANDANO QUESTE STRINGHE

👉 **In una finestra PowerShell sul VPS.**

🎯 **BERSAGLIO, per esteso:** **solo** il banco da backtest `C:\MT5_Backtest`, demo
**50504400**. È l'unico terminale che viene aperto, usato e chiuso.

🚫 **CHE COSA NON VIENE TOCCATO:** **NON** il piccolo **50503392** (`C:\Program Files\BCM
Markets MT5 Terminal`) · **NON** il 100k **50504263** (`... -V3`) · **NON** il **REALE
10105439** (`C:\BCM_Reale`) · **NON** `C:\MT5_MANUALE` · **NON** Pepperstone · **NON**
Tickmill.

🔴 **E non è una promessa a parole**: lo script **fotografa i PID** di tutti i `terminal64`
**prima**, li rilegge **dopo**, e se è sparito un terminale che non era il banco esce con
codice **`4` = ALLARME**. Nessuna sedia, nessun preset, nessun `.set`, nessuna taglia in
campo viene toccata: la misura gira su **EA nuovi con magic vergini** (`778411`, `778412`)
che non sono e non saranno mai sedie.

---

## ▶️ LE DUE STRINGHE — **prima la A, e solo dopo la B**

### A) 🧪 GIRO A VUOTO — non lancia niente, controlla tutto
```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    $pin='fbd3109920e95e8d0d406b98104758a85bce07ba'; $p="$env:USERPROFILE\MISURA_LOTTI_U30USD.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/MISURA_LOTTI_U30USD.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_MISURA_LOTTI_U30USD_v1' -Quiet)){ throw 'SCRIPT VECCHIO: manca il marcatore MARCATORE_MISURA_LOTTI_U30USD_v1.' };
    $global:LASTEXITCODE = 0; & $p -Pin $pin -SoloElenco;
    if($LASTEXITCODE -ne 0){ Write-Host ('GIRO A VUOTO FALLITO (uscita ' + $LASTEXITCODE + '): NON mandare la stringa B. Manda a me tutto l output qui sopra.') -ForegroundColor Red }
    else { Write-Host 'GIRO A VUOTO OK: non e stata lanciata nessuna corsa. Se l elenco qui sopra e quello giusto, manda la stringa B.' -ForegroundColor Green } }
```
⏱️ **Pochi secondi.** Verifica il banco, `metaeditor64.exe`, le variabili d'ambiente, il
driver di round **col suo marcatore**, e stampa le quattro corse che farebbe. **Non apre
nessun MT5.**

### B) ▶️ LA MISURA VERA
```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    $pin='fbd3109920e95e8d0d406b98104758a85bce07ba'; $p="$env:USERPROFILE\MISURA_LOTTI_U30USD.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/MISURA_LOTTI_U30USD.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_MISURA_LOTTI_U30USD_v1' -Quiet)){ throw 'SCRIPT VECCHIO: manca il marcatore MARCATORE_MISURA_LOTTI_U30USD_v1.' };
    $global:LASTEXITCODE = 0; & $p -Pin $pin -TettoMinutiPerCorsa 20;
    $rc = $LASTEXITCODE;
    if($rc -eq 0){ Write-Host 'FATTO (0): misura completa e senza rilievi. Mandami lo zip MISURA_LOTTI_U30USD_<data>.zip dal Desktop.' -ForegroundColor Green }
    elseif($rc -eq 3){ Write-Host 'FATTO CON RILIEVI (3): la tabella ce, ma ci sono righe RILIEVI da leggere. Mandami lo zip lo stesso.' -ForegroundColor Yellow }
    elseif($rc -eq 2){ Write-Host 'NON MISURATO (2): zero file per-trade. Mandami lo zip e tutto l output: e un risultato, non un guasto.' -ForegroundColor Red }
    elseif($rc -eq 4){ Write-Host 'ALLARME (4): e sparito un terminale che NON era il banco. Fermati e chiamami SUBITO.' -ForegroundColor Red }
    else { Write-Host ('FERMATO (uscita ' + $rc + '): la corsa non e partita. Manda a me tutto l output qui sopra.') -ForegroundColor Red } }
```

📦 **Raccolta**: `Desktop\MISURA_LOTTI_U30USD_<data>\` + lo **zip** pronto.
**File attesi**: `REFERTO_MISURA_LOTTI.txt` + **8** `abtg_mis_*.csv` (2 EA × 2 depositi ×
2 rami). 🔴 **La riga `data:` in cima al referto deve essere di ADESSO**: se è vecchia, è
uno scroll di prima.

---

## 🧪 I CONTRO-ESEMPI — **eseguiti**, e due hanno trovato difetti veri

`pwsh` disponibile: **parse reale** dello script → **0 errori**. Poi:

| # | scenario | esito |
|---|---|---|
| 1 | banco `C:\MT5_Backtest` assente | ✅ uscita **1**, rifiuto, niente aperto |
| 2 | `USERPROFILE` vuoto · `APPDATA` vuoto | ✅ uscita **1**, messaggio che **nomina la variabile** |
| 3 | giro a vuoto `-SoloElenco` con pin vero | ✅ uscita **0**, quattro corse elencate, **zero** processi lanciati |
| 4 | pin inesistente → 404 sul driver | ✅ uscita **1**, messaggio leggibile |
| 5 | CSV fabbricati: parziale su una posizione | ✅ **3 deal → 2 posizioni**, volume = somma per `position_id` |
| 6 | CSV fabbricati: volumi diversi | ✅ rapporto **0,5000** calcolato giusto |
| 7 | CSV fabbricati: **deal count diverso** fra le gambe | ✅ **allarme «è un DIFETTO»** + rilievo + uscita **3** |
| 8 | EA **muto** (non compila / zero operazioni) | 🔴 **usciva 3** → corretto (**classe 471**), ora **2 = NON MISURATO** |
| 9 | cultura `it-IT` sul parsing dei volumi | ✅ misurato: `::Parse` senza cultura sbaglia di **100×** |
| 10 | la stringa **A** e la **B** intere, banco assente | ✅ *«GIRO A VUOTO FALLITO»* / *«FERMATO (uscita 1)»* |
| 11 | marcatore sbagliato nella stringa | ✅ `throw` prima di eseguire qualunque cosa |

### 🐛 I due difetti veri, trovati **eseguendo** e non rileggendo
1. 🔴 **Classe 79, e ci sono cascato io**: `$R` (l'ArrayList del referto) e `$r` (variabile
   di ciclo) sono **la stessa variabile** — PowerShell è case-insensitive. Il `foreach`
   distruggeva l'ArrayList e il referto moriva con *«PSCustomObject does not contain a
   method named Add»*. Rinominata `$REFERTO`, e poi **scansione case-SENSITIVE di tutte le
   69 variabili** dello script (classe 118: il rilevatore non dev'essere vittima del
   difetto che cerca) → **zero** altre collisioni.
2. 🔴 **Classe 471, nuova**: con un EA muto la corsa usciva **`3` = girato con rilievi**
   invece di **`2` = non misurato**, perché il controllo sui rilievi veniva prima. Una
   corsa che non ha misurato niente si presentava come riuscita. Corretto l'ordine, e
   l'allarme terminali si è preso un codice suo (**`4`**).
3. 🟠 **Il Desktop dato per presente**: `GetFolderPath('Desktop')` può tornare stringa
   vuota e il `Join-Path` esplodeva con un messaggio che **non nomina né il Desktop né lo
   script**, dopo aver già fatto il lavoro. Ora c'è il ripiego e una morte che dice quale
   variabile manca.

---

## 🚦 ESITO DEL CANCELLO

- **`controlla_riga.py --ps1`** sullo script → `ESITO: nessun difetto meccanico`, uscita
  **0**. Passati 6: ASCII puro · **0 errori dal parser PowerShell vero** · param block ·
  nessun costrutto pwsh-7-only · formati .NET · **nessun parse decimale senza cultura**.
- **`--riga`** sulla **A** e sulla **B** → uscita **0** entrambe (pin è un commit vero,
  marcatore controllato **e presente al pin**).
- **`controlla_prova.py`** sui due file prova → `ESITO: OK`, **0 problemi**, 4 celle.

### I rilievi `[457]`, letti a mano uno per uno
- **r.65** — `BCM_Reale` sta in `$VIETATI`, la **lista di rifiuto**. Unica occorrenza nel
  file; unico uso nella guardia che chiama `Muori`.
- **r.245** — `Stop-Process -Id $pr.Id`: chiude **il processo powershell figlio che ho
  avviato io**, non un terminale.
- **r.250** — `Get-Process metatester64,terminal64 | Where { $_.Path -like ($BANCO+'\*') }`:
  `$BANCO` è una **COSTANTE** (`C:\MT5_Backtest`), assegnata una volta sola a r.63 e **mai**
  da un parametro. È esattamente la condizione che il cancello chiede.
- **[RACCOLTA] sulla stringa A** — corretto e voluto: **il giro a vuoto non produce
  risultati**, quindi non ha niente da raccogliere. La raccolta ce l'ha la **B**.

---

## ⚠️ NON COPERTO, e lo dico

- **L'esecuzione su Windows PowerShell 5.1 vero.** I contro-esempi girano su **pwsh 7 su
  Linux**; i costrutti sono tutti 5.1-compatibili (nessun ternario, nessun `&&`/`||` fra
  comandi, nessun `-AsHashtable`), ma **5.1 vero non è stato provato**.
- 🔴 **I due EA di misura NON sono mai stati compilati da nessuno** — qui non c'è
  MetaEditor. Brace e parentesi sono bilanciate e il `diff` col pin mostra solo le cinque
  differenze volute, ma **il primo F7 del banco è anche il primo collaudo**. Se MetaEditor
  si lamenta, quello è il risultato e va riportato com'è.
- 🟠 **Il driver scarica l'EA dal RAMO `lavoro`, non dal pin**: `walkforward_generico.ps1`
  r.251 ha `$EABranch="lavoro"` **inchiodato**, non è un parametro. Per file **nuovi** come
  questi il modo in cui la cache può sbagliare è **404**, non «versione vecchia» — cioè un
  fallimento **rumoroso**, non silenzioso. Se la corsa dice *«non trovo l'EA»*, si aspettano
  ~5 minuti e si rilancia.
- **Il volume «per segnale» su SuperWave**: la tranche a mercato e il pendente 2/3 sono
  **due posizioni** distinte; la tabella le conta per `position_id` senza raggrupparle per
  segnale.

---

## 🔭 E DOPO, COSA SI FA CON QUESTI NUMERI

1. Se **EMA200 = 1,0000** e **SuperWave < 1** → il quadro del referto del pacchetto è
   confermato: l'F7 **abbassa** la taglia di `770511` verso il contratto e **non tocca**
   quella di `771531`. Resta da chiedere a Claudio il sì su *«e la taglia cambia»*.
2. Se **EMA200 ≠ 1,0000** → 🔴 notizia grossa: su U30USD il tick value mente, e il binario
   in campo dimensiona male da agosto. Si ferma tutto e si misura quello.
3. Se **SuperWave = 1,0000 a tutti e due i depositi** → il *«fino al doppio del rischio»*
   va riscritto come **[POSSIBILE MA MAI ACCADUTO su questa sedia]**, e il peso del fix
   nel referto del pacchetto va abbassato di conseguenza.
