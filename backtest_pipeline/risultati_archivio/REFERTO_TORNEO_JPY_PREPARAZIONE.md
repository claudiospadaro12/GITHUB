# 🏗️ R82 — TORNEO JPY: REFERTO DI PREPARAZIONE

_18/08/2026, sera. **Nessun numero di backtest in questo referto: non e' ancora
girato niente.** Qui c'e' cosa e' stato costruito, cosa e' stato verificato **a
mano** (non compilato: in questo ambiente non c'e' MetaEditor), quanto costa la
corsa e la riga di lancio proposta._

**Ordine di Claudio, parola esatta:** _"fai fare agli agenti le analisi per avere
magari solo 1 vincitore tra tutti i cross jpy"_.

**Commit di riferimento: `2478ec5d04238c694bddc1ffba8abb430f7b4fc5`** (branch `lavoro`).

---

## 1. 📦 COSA E' STATO COSTRUITO

| file | cos'e' |
|---|---|
| `mql5/Experts/ABTG_BreakoutCorso.mq5` | **EA nuovo**, implementazione fedele della strategia BREAKOUT del corso di Manuela Negro (lez. 34-40) |
| `backtest_pipeline/prove/TORNEO_JPY_CRITERI.md` | **i criteri, congelati PRIMA di qualunque numero** |
| `prove/R82a..g_scr_<SYM>.txt` | 7 file prova — **giro 1**, screening OHLC, finestra lunga |
| `prove/R82h..p_tick_<SYM>.txt` | 7 file prova — **giro 2**, verdetto a tick reali |
| `backtest_pipeline/lancia_r82.ps1` | il driver del round (stile `lancia_r81.ps1`, con le correzioni della checklist) |

### 1.1 L'EA: cosa c'e' dentro, regola per regola

Il sorgente si apre con una **tabella regola-del-corso ↔ funzione**, cosi' la
fedelta' e' verificabile riga per riga senza fidarsi di questo referto.

🔴 **Le due divergenze del vecchio `BREAKOUT_EA_JPY.mq5` sono chiuse:**

1. **Il vincolo delle 20 candele dall'ingresso in zona** (spec §4.5) —
   `InpAttesaCandeleZona` + `BarreDaIngressoZona()`, che conta le barre
   **dalla candela in cui il Williams e' entrato in zona** usando `iBarShift`
   (robusto a riavvii e buchi di storico). Il vecchio EA **non aveva alcuna
   variabile che contasse quelle barre**: apriva su rettangoli composti in
   maggioranza da candele **precedenti** la fase che il corso vuole misurare.
   **Effetto atteso: meno segnali, piu' selettivi.**
2. **Le uscite come le vuole il PDF** (slide S8: SL / TP / segnale contrario, e
   nient'altro). La regola discrezionale del video (§7.4, _"il Williams arriva
   all'estremo opposto prima del target"_) **non e' in nessuna slide**: qui e'
   un input **spento di default** (`InpChiudiSuWilliamsOpposto=false`). Nel
   vecchio EA era **accesa** dentro `CloseOnOppositeSignal`, mescolata alla
   chiusura su segnale contrario: due regole diverse sotto un unico flag.

**Gli altri punti fedeli** (gia' giusti nel vecchio EA e mantenuti): livelli
ancorati alla **chiusura della candela di segnale**, SL a 1 pip oltre il
rettangolo, TP 3R, **break-even sulla chiusura del segnale e non sul fill**,
niente trailing, R:R minimo 1:2, ordini a mercato, OB⇒solo sell / OS⇒solo buy,
rottura con **chiusura** oltre il livello, estremi assoluti di wick.

**Le assunzioni NOSTRE, dichiarate nel sorgente** (A1-A4): SuperTrend 10/3.0
(il corso tace — decisione di Claudio), significato di
`InpIncludiCandelaRottura`, morte del setup oltre la mediana, rientro dopo un
trade chiuso.

### 1.2 Gli input chiave richiesti dalla missione

| input | default | nota |
|---|---|---|
| `InpWilliamsPeriod` | **140** | confermato da Claudio sul video |
| `InpCandeleRettangolo` | **20** | asse di disambiguazione 15/20, **fase 2** |
| `InpIncludiCandelaRottura` | **false** | assunzione dichiarata, **fase 2** |
| `InpSuperTrendATR` / `InpSuperTrendMult` | **10 / 3.0** | standard, decisione di Claudio |
| `InpChiudiSuSegnaleContrario` | **true** | slide S8: e' un obbligo |
| `InpRischioMode` | `RISCHIO_PER_OPERAZIONE` | l'altra lettura (`RISCHIO_COMPLESSIVO`) divide per `InpCrossFamiglia` |

---

## 2. 🧪 IL TEST-CASE NUMERICO DEL CORSO — **riprodotto a meta', e la meta' che manca e' del CORSO**

Il codice ha una funzione **pura** (`LivelliDaSegnale`) usata **sia** dal motore
**sia** dall'autotest stampato in `OnInit` (`InpAutoTest=true`). Applicata ai
numeri della lez. 37 su USDJPY (massimo congestione **155,95**, chiusura del
segnale **155,57**, pip = 0,01):

| voce | corso | **calcolo dell'EA** | esito |
|---|---|---|---|
| Stop loss | **155,96** | `155,95 + 1 pip` = **155,96** | ✅ **COINCIDE** |
| R (rischio unitario) | _"40 pip"_ | `\|155,57 − 155,96\|` = **0,39 = 39,0 pip** | ⚠️ **−1 pip** |
| Take profit | **154,37** | `155,57 − 3 × 0,39` = **154,40** | ⚠️ **+3 pip** |

> ### 🎯 **La differenza non e' un difetto dell'EA: e' un'incoerenza aritmetica del corso.**
> `155,96 − 155,57 = 0,39`. Sono **39 pip**, non 40. La relatrice dice _"40 pip
> per 3, quindi andiamo a 154 e 37"_ — cioe' **arrotonda R a 40 e da li' calcola
> il target**. I due numeri che pronuncia (SL e chiusura) e il numero che usa (R)
> **non stanno insieme**.

⚠️ **Va corretto un errore agli atti nostri**, non solo del corso: la spec
(§6.2) e il referto di analisi scrivono _"aritmetica verificata, i tre numeri
chiudono"_. **Chiude solo la seconda meta'** (155,57 − 1,20 = 154,37, che e'
esatta); **la prima meta' — dalla quale nasce l'1,20 — no.** Chi ha verificato
ha controllato la sottrazione del target e non quella dello stop.

**Cosa fa l'EA:** usa il valore **esatto** (39 pip → TP 154,40) e **stampa il
confronto nel log a ogni init**, cosi' il collaudo si legge dal Giornale di MT5
senza fidarsi di questo referto. Le tre righe attese sono:

```
[BRK][AUTOTEST] SL: corso 155.96 | EA 155.96000 | COINCIDE
[BRK][AUTOTEST] R : corso 40.0 pip | EA 39.0 pip | scarto -1.0 pip
[BRK][AUTOTEST] TP: corso 154.37 | EA 154.40000 | scarto 3.0 pip
```

🔴 **PRIMO CONTROLLO DI IGIENE DEL ROUND:** se dopo la compilazione queste righe
non escono cosi', **il round non parte**. E' un test che costa zero secondi.

---

## 3. 🔍 REVIEW STATICA — cosa ho verificato senza poter compilare

**Non posso compilare ne' backtestare: qui non c'e' MetaEditor.** Quindi:

✅ **Verificato leggendo il codice**
- ogni input e' letto da almeno una funzione (nessun input dichiarato e mai
  usato — e' il difetto trovato l'08/08 su `InpOneTradePerDay`);
- normalizzazione ai decimali del simbolo su SL/TP (`NormalizeDouble(_Digits)`)
  e sul volume (decimali del `VOLUME_STEP`);
- rispetto di `SYMBOL_TRADE_STOPS_LEVEL` **sia** in apertura **sia** nel
  break-even (se il livello e' troppo vicino non si forza: si riprova al tick
  dopo);
- vincoli di volume min/max/step, con **avviso esplicito** quando il lotto
  minimo porta il rischio sopra l'1% richiesto;
- retcode controllato dopo ogni ordine e dopo ogni modifica;
- handle indicatori creati in `OnInit` e **rilasciati in `OnDeinit`**;
- `OnTester` presente (senza, `walkforward_generico.ps1` **si rifiuta di
  partire**) + export per-trade nella cartella comune + blocco OPTFRAME;
- lo stop e' sempre **dalla parte giusta** del prezzo prima di inviare
  (guardia contro il caso "il prezzo ha gia' superato lo stop");
- filtro spread e deviazione massima parametrizzati.

⚠️ **NON verificabile senza compilare** (e va detto):
- che compili (F7). Se qualcosa non compila, sara' una sciocchezza di sintassi,
  non di logica;
- il **costo macchina** del `SuperTrend` ricalcolato su 300 barre a **ogni**
  chiusura di candela (routine ripresa da `ABTG_AltaVelocita.mq5`, pattern gia'
  in casa). Su 19 anni di M15 sono ~680.000 ricalcoli: e' la voce di costo
  dominante del giro 1. **Se la corsa risulta troppo lenta, la leva e' nota**
  (SuperTrend incrementale) e **non cambierebbe un solo segnale** — ma e' una
  modifica al codice e va fatta **prima** del round, non in mezzo.

---

## 4. 🏟️ IL TORNEO: quante celle, quanto dura

### 4.1 La struttura

| | giro 1 — SCREENING | giro 2 — VERDETTO |
|---|---|---|
| modello | **1** (OHLC su M1) | **4** (tick reali) |
| finestra | **2007.02.12 → 2026.06.30** (identica per tutti e 7) | **2024.07.05 → 2026.06.30** |
| perche' quella data | e' la prima data del simbolo **piu' giovane** (CADJPY e NZDJPY), misurata dalla sonda del 17/08 | **a BCM i tick veri partono da li'** (R58/R72/R76/R78) |
| chi ci va | tutti e 7 | **solo i sopravvissuti** (`-Solo` obbligatorio) |
| celle per finestra | **2** (le due passate gemelle del magic) | **2** |
| passate totali | 7 × 2 finestre × 2 = **28** | per cross: 2 × 2 = **4** |

**La cella e' UNA SOLA e congelata**: nessun parametro della strategia viene
spazzolato. L'unico asse e' `InpMagic` su due valori **gemelli**, che DEVONO
uscire identici al centesimo (e' il controllo gratis che dice se qualcosa e'
rotto). **Curve-fitting: zero per costruzione.**

### 4.2 Durata — **STIMA, non misura**

| lavoro | stima |
|---|---|
| **passo 0** — scarico storico 7 cross, M1 dal 2007, **senza tick** | **1-3 ore** (dipende dal server) |
| **giro 1** — 28 passate OHLC su ~19 anni di M15 | **2-5 ore** |
| **passo 0-bis** — scarico **tick reali** dei sopravvissuti dal 2024.07 | 30-90 min per cross |
| **giro 2** — 4 passate a tick reali per cross | **1,5-4 ore per cross** |

⏰ **Nota temporale, importante:** **stanotte sul PC gira il download Dukascopy.**
**Una macchina, un lavoro:** il torneo si fa **DOMANI**, non stanotte — e
`lancia_r82.ps1` si rifiuta di partire se trova MT5 aperto.

---

## 5. 🚀 LA RIGA DI LANCIO — **BOZZA, da far passare dal verificatore-stringhe**

🛑 **Queste righe NON vanno ancora mandate a Claudio.** Passano prima dal
controllo stringhe (`backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md`).

**Hash a cui sono pinnate:** `2478ec5d04238c694bddc1ffba8abb430f7b4fc5`
**SHA256 di `lancia_r82.ps1`:** `f8b8d583a7a893e5bda01a7b96dbcb94d71168f7fd5c06a282e3b1884b7ca6d1`
**SHA256 di `ABTG_BreakoutCorso.mq5`:** `a5b84d4a4d4b1be9547c0ce8cd0566fc42df0d89a4b3db93158f841c46e9d392`

### PASSO 0 — lo storico (PRIMA di tutto, MT5 chiuso)

```powershell
$s="$env:USERPROFILE\scarica_storico.ps1"; Remove-Item $s -EA SilentlyContinue; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/2478ec5d04238c694bddc1ffba8abb430f7b4fc5/backtest_pipeline/scarica_storico.ps1" -OutFile $s -EA Stop; powershell -ExecutionPolicy Bypass -File $s -Simboli "USDJPY,EURJPY,GBPJPY,AUDJPY,CHFJPY,CADJPY,NZDJPY" -Da 2007.01.01 -SenzaTick -Auto
```

**Si LEGGE il suo referto prima di andare avanti.** Se anche **un solo** cross
non arriva al **2007.02.12**, il round si ferma e la finestra si ridichiara:
mezza finestra vuota ha gia' rovinato un round sugli indici.

### PASSO 1 — il giro a vuoto (un minuto, non apre MT5)

```powershell
$p="$env:USERPROFILE\lancia_r82.ps1"; Remove-Item $p -EA SilentlyContinue; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/2478ec5d04238c694bddc1ffba8abb430f7b4fc5/backtest_pipeline/lancia_r82.ps1" -OutFile $p -EA Stop; if(-not (Select-String -Path $p -SimpleMatch -Pattern 'R82 TORNEO JPY' -Quiet)){throw 'SCRIPT VECCHIO'}; $global:LASTEXITCODE=0; & powershell -ExecutionPolicy Bypass -File $p -Rif 2478ec5d04238c694bddc1ffba8abb430f7b4fc5 -Giro 1 -SoloControllo; if($LASTEXITCODE -ne 0){throw 'GIRO A VUOTO FALLITO'}
```

Si legge riga per riga la cella stampata e la si confronta con la tabella del
**§4 dei criteri**. Se anche una riga non coincide, ci si ferma li'.

### PASSO 2 — il giro 1 (screening), MT5 CHIUSO

```powershell
$p="$env:USERPROFILE\lancia_r82.ps1"; Remove-Item $p -EA SilentlyContinue; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/2478ec5d04238c694bddc1ffba8abb430f7b4fc5/backtest_pipeline/lancia_r82.ps1" -OutFile $p -EA Stop; if(-not (Select-String -Path $p -SimpleMatch -Pattern 'R82 TORNEO JPY' -Quiet)){throw 'SCRIPT VECCHIO'}; $global:LASTEXITCODE=0; & powershell -ExecutionPolicy Bypass -File $p -Rif 2478ec5d04238c694bddc1ffba8abb430f7b4fc5 -Giro 1; if($LASTEXITCODE -ne 0){throw 'CORSA INCOMPLETA: leggi quali CSV mancano'}
```

Raccolta, zip e referto li fa lo script: **Desktop → `R82_TORNEO_JPY_giro1\` +
`R82_TORNEO_JPY_giro1.zip`**, e dentro c'e' `REFERTO_RACCOLTA_R82_giro1.txt`
con una riga **`data:` che deve essere di ADESSO**.

### PASSO 3 — il giro 2, SOLO sui sopravvissuti (esempio con un cross)

```powershell
$p="$env:USERPROFILE\lancia_r82.ps1"; Remove-Item $p -EA SilentlyContinue; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/2478ec5d04238c694bddc1ffba8abb430f7b4fc5/backtest_pipeline/lancia_r82.ps1" -OutFile $p -EA Stop; if(-not (Select-String -Path $p -SimpleMatch -Pattern 'R82 TORNEO JPY' -Quiet)){throw 'SCRIPT VECCHIO'}; $global:LASTEXITCODE=0; & powershell -ExecutionPolicy Bypass -File $p -Rif 2478ec5d04238c694bddc1ffba8abb430f7b4fc5 -Giro 2 -Solo "USDJPY"; if($LASTEXITCODE -ne 0){throw 'CORSA INCOMPLETA'}
```

Nel giro 2 `-Solo` e' **obbligatorio**: lo script si rifiuta di girare sette
cross a tick reali.

### 5.1 Cosa e' stato controllato su questa riga (checklist eseguita)

| # | controllo | esito |
|---|---|---|
| 1 | **ho aperto lo script a cui punta** | ✅ scritto e riletto |
| 2 | difetti gemelli (`fermoDa`, raccolta Desktop) | ✅ nessuna euristica del silenzio; raccolta Desktop + zip presenti |
| 3 | **il file dei parametri e' quello giusto?** | ✅ la riga **VERIFICA una cella congelata**, non cerca: 14 file prova con una sola cella, zero griglie |
| 4 | il SHA contiene la correzione annunciata | ✅ tutti i file sono **dentro** `2478ec5` |
| 5 | giro a vuoto obbligatorio | ✅ passo 1 |
| 6 | cache di raw ~5 minuti | ✅ pinnato all'**hash**, non al branch, + marcatore |
| 8 | `irm` che fallisce e la riga tira dritto | ✅ `Remove-Item` + `-EA Stop` + `Select-String` sul marcatore |
| 10 | `ErrorActionPreference=Stop` nei cicli su file | ✅ le copie dei per-trade sono in `try/catch`, il referto si scrive comunque |
| 13 | `exit 1` dello script chiamato | ✅ `$global:LASTEXITCODE=0` prima, `-ne 0` dopo |
| 14 | **il giro a vuoto che esce 0 anche se un pezzo e' fallito** | ✅ **corretto**: il codice d'uscita del `-SoloControllo` dipende dai cross falliti **e** dalle anteprime mancanti; le anteprime vecchie si cancellano prima |
| 15 | rilancio mirato che non rilancia niente | ✅ `-Rifai` presente **e inoltrato** al driver, e la riga finale lo dice |
| — | cultura invariante | ✅ **nessun numero viene convertito**: i campi dei CSV si stampano come stringhe |

### 5.2 Un limite della riga, dichiarato

`walkforward_generico.ps1` scarica il **sorgente dell'EA** dal **branch
`lavoro`** (`$EABranch` e' fisso nel driver), **non** dal SHA passato con
`-Rif`. Oggi coincidono (il commit e' la punta di `lavoro`), ma **se qualcuno
pusha un altro EA prima della corsa, la corsa userebbe quello**. Vale per tutti
i round di casa, non solo per questo: lo scrivo perche' sia agli atti.

---

## 6. ⚖️ COSA QUESTO ROUND PUO' E NON PUO' DIRE

- 🟢 **Puo' dire**: se **un** cross regge i cancelli in due giri (storico lungo
  in OHLC + tick reali) con la strategia implementata **fedelmente**.
- 🔴 **Non puo' dire** che il corso funziona: i parametri del SuperTrend sono
  **nostri**, e finche' lo sono qualunque numero misura **la nostra versione**.
- 🔴 **Non tocca il forward**: `BREAKOUT_EA_JPY_v3 USDJPY` e' **spenta dal
  18/08** (FIRMA 5) e resta spenta. Un vincitore rientra con **firma di Claudio
  e contratto**, non da un referto.
- 🟥 **Zero vincitori e' un verdetto valido**, ed e' l'esito piu' probabile a
  priori: il paniere misurato nel 2024 faceva **PF 0,67-0,95 su tutte e sette**.

---

## 7. 🙋 COSA SERVE DA CLAUDIO

1. **Il via libera alla corsa di domani** (stanotte il PC ha il Dukascopy: una
   macchina, un lavoro).
2. **F7 su `ABTG_BreakoutCorso.mq5`** in MetaEditor e — se compila — le **tre
   righe `[BRK][AUTOTEST]`** copiate qui: sono il collaudo del test-case del
   corso e costano dieci secondi. *(Il driver ricompila da solo prima di ogni
   corsa, quindi un errore di compilazione si vedrebbe comunque: ma si vedrebbe
   dopo, e a MT5 aperto.)*
3. **Una risposta, se l'ha**: il corso, nel modulo precedente, dava dei
   parametri al SuperTrend? Finche' la risposta manca, **10/3.0 e' nostro** e va
   scritto accanto a ogni numero.
4. **Conferma della regola di portafoglio** che ho firmato in anticipo al suo
   posto (§2 dei criteri): **dalla famiglia JPY al massimo UNA sedia, mai il
   paniere.** L'ho congelata **prima** dei numeri apposta per non doverla
   decidere davanti a una tabella verde — ma la firma e' sua.
