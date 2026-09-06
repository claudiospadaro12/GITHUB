# 🛡️ IL GUARDIANO SUL CONTO REALE — **le due righe da mandare** (controllo · corsa)

**Che cos'è:** l'installazione di **`ABTG_Guardian` v1.11** (magic **779002**) sul
terminale del **conto REALE**, con il preset **`ABTG_Guardian_REALE.set`** che
porta **i numeri già firmati da te il 18/08**: **pausa 4,0 · emergenza 4,9 e 9,9 ·
reset 23 · cap rischio aperto 3,25%**.

È il pezzo che **mancava** dopo stamattina: sul reale ci sono due EA che aprono
ordini veri, ma **a livello di conto non c'è nessuna rete**. Questa la mette.

---

> # 🛑🛑 QUESTO EA PUÒ CHIUDERE POSIZIONI. VA LETTO PRIMA DI TUTTO IL RESTO.
>
> I tre artefatti già sul reale sono, in ordine di potere:
> | | cosa può fare |
> |---|---|
> | `ABTG_SlippageLogger` (05/09) | **niente**: sola lettura, le funzioni per mandare un ordine **non esistevano nel sorgente** |
> | `ABTG_DAX_Apertura_EU` · `ABTG_ORB_Ottimizzato` (06/09) | **aprono e chiudono**, ma **solo le proprie** posizioni (il proprio magic) |
> | **`ABTG_Guardian` (questo)** | **CHIUDE TUTTE LE POSIZIONI E CANCELLA TUTTI I PENDENTI DEL CONTO**, di **QUALSIASI magic** — quindi **anche quelle che hai aperto TU a mano** (magic 0) |
>
> **Non è una svista: è esattamente il motivo per cui lo si installa.** La regola
> di rischio del 18/08 è **sul CONTO**, non sulla singola sedia — e una regola sul
> conto la può far rispettare solo qualcosa che guardi il conto intero.
>
> 💶 **I numeri, su ~7.500 €, per averli in testa PRIMA:**
> | soglia | in euro | cosa succede |
> |---|---|---|
> | **pausa 4,0%** | **~300 €** persi oggi | 🟡 **non chiude niente**: nessun EA **apre** più fino alle 23. Le posizioni vive restano e continuano a essere gestite |
> | **giorno 4,9%** | **~367 €** persi oggi | 🔴 **CHIUDE TUTTO** e blocca fino al reset delle 23 |
> | **totale 9,9%** | **~742 €** (equity **~6.757 €**) | ⛔️ **CHIUDE TUTTO e blocca PER SEMPRE** |
> | cap 3,25% | ~244 € di SL vivi | 🟡 nessun nuovo ingresso finché non rientra |
>
> ⛔️ **QUEL «PER SEMPRE» È LETTERALE, ed è la cosa che devi sapere adesso e non
> dopo.** Lo stop totale scrive una GlobalVariable
> `ABTG_GUARD_<login>_FAILED = 1` che **non si azzera da sola**: da quel momento
> il guardiano **richiude tutto ogni secondo**, comprese le posizioni che apriresti
> a mano. **Si sblocca SOLO cancellando quella variabile a mano** (F3 nel
> terminale → seleziona → Elimina). Sul demo era la challenge fallita; qui è il
> tuo conto, quindi **è una decisione tua**, e la riga te la mette davanti.

---

## 0. 🚫 LE CINQUE COSE CHE QUESTA RIGA **NON FA** (e non può fare)

| | |
|---|---|
| **NON ATTACCA MAI L'EA A UN GRAFICO** | e qui **pesa il doppio**: 👉 **finché il guardiano non sta su un grafico, non sorveglia niente e non può chiudere niente a nessuno.** Nel driver **non esiste nessun percorso di scrittura** verso `Profiles\Charts` o `config\`, ed è **misurato**: quelle cartelle sono fotografate prima e dopo e devono uscire `INVARIATI` |
| **NON TOCCA MAI L'AUTOTRADING** | non c'è nessun modo di accenderlo da lì. ⚠️ E senza AutoTrading il guardiano **scrive lo stesso** le sue GlobalVariable (pausa, cap, battito) ma **NON PUÒ CHIUDERE**: il braccio armato resta spento |
| **NON RISCRIVE L'INCLUDE** — *lo VERIFICA* | è la scelta più importante di questa riga, spiegata al §3 |
| **NON TOCCA I TRE EA GIÀ IN CAMPO** | `SlippageLogger`, `DAX_Apertura_EU`, `ORB_Ottimizzato`: i loro 6 file sono fotografati prima e dopo e devono uscire **INVARIATI**. ⚠️ Il **registro** del logger in `MQL5\Files` invece **può crescere** durante il giro: è **ATTESO**, non un problema |
| **NON SI INSTALLA SUI DEMO** | **50503392 e 50504263 VIETATI PER SEMPRE**, senza manopola. E il motivo qui è **peggiore** che stamattina: sul **100k gira già un Guardian** (magic `779001`) per il dry-run FTMO, e **due guardiani sullo stesso conto** vorrebbero dire **due `FlattenAll` che si accavallano** |

**Scrive TRE file, nient'altro:**
```
<dati>\MQL5\Experts\ABTG_Guardian.mq5        (v1.11)
<dati>\MQL5\Experts\ABTG_Guardian.ex5        (compilato sul posto)
<dati>\MQL5\Presets\ABTG_Guardian_REALE.set
```
**Backup di tutti e tre** in `Desktop\backup_guardian_<data>\<ora>\` **prima** di
scrivere, **sentinella** per il giro interrotto a mano, **ripristino TOTALE** su
qualunque fallimento. **Il `.set` entra SOLO IN FONDO**, e solo se la
compilazione è andata.

---

## 1. 🔑 IL NUMERO DEL CONTO REALE, E LE CINQUE SERRATURE

Il numero va scritto nelle righe qui sotto al posto di `SCRIVI_QUI_IL_NUMERO`
(lo stesso delle due righe di stamattina). Le righe **si rifiutano di partire**
se lo lasci lì com'è.

> ## 🛡️ LA GUARDIA È **QUELLA DI STAMATTINA, PAROLA PER PAROLA**
> 1. **`-LoginAtteso` è obbligatorio.** Senza, la riga non parte.
> 2. **`50503392` e `50504263` sono VIETATI PER SEMPRE**, e **non c'è nessuna
>    manopola che li sblocchi**.
> 3. **Una cartella che ha visto uno di quei due conti nei log è SCARTATA** —
>    anche se ci fosse dentro *pure* il conto atteso. Anzi: **soprattutto allora**.
> 4. **Il login atteso DEVE comparire nei log** della cartella scelta (finestra di
>    **180 giorni**).
> 5. 🧷 **CONFERMA INCROCIATA, più severa di stamattina:** nella cartella scelta
>    devono già esserci **tutti e tre** gli EA (`SlippageLogger`, `DAX`, `ORB`)
>    **e i magic `770101` / `770611` devono comparire nei loro `.mq5`**. Se manca
>    qualcosa **non è un blocco** (potrebbero stare altrove) ma è un **RILIEVO
>    FORTE** — un guardiano su un terminale che non ospita le sedie sorveglia un
>    conto che non trada.

---

## 2. 📌 IL PIN — **`a01e1573015685157a2faa6cce7bd6b0261d7392`** ✅ **INSERITO E VERIFICATO**

Commit di `lavoro`. **Verificato file per file prima di scrivere questa pagina**,
non dichiarato: presente in `git ls-tree`, **HTTP 200** via `raw`, e **sha256 del
contenuto scaricato identico al file nel repo**.

| file al pin | esito |
|---|---|
| `backtest_pipeline/righe/RIGA_DEPLOY_GUARDIAN_CONTOREALE.ps1` | 200, identico (`00fbf8d9…`, **97.545 byte**), marcatore `MARCATORE_RIGA_DEPLOY_GUARDIAN_CONTOREALE_v1` presente **nel file scaricato**, **ASCII puro** (0 byte > 126), `Parser::ParseFile` **0 errori** |
| `mql5/Experts/ABTG_Guardian.mq5` | 200, identico (`5675d222…`, **23.320 byte**), `#property version "1.11"` — 👉 **gli stessi 23.320 byte censiti come «v1.11, vivo»** in `report/CONFIG_PROP_2026-08-31.md` |
| `mql5/Presets/conto_reale/ABTG_Guardian_REALE.set` | 200, identico (`393b723a…`, **8.593 byte**), **16 chiavi = 16 input dell'EA** |
| `mql5/Include/ABTG_PausaGuardian.mqh` | 200, identico (`b7462cd5…`, **112.481 byte**, **v1.51**) — 👉 **lo stesso `b7462cd5…` scritto nella pagina di deploy di stamattina**: è il file che sta **già** nel terminale del reale |

Il pin è scritto **quattro volte** in questa pagina (qui, nei **due** blocchi e in
fondo) ed è sempre **la stessa identica stringa da 40 hex**.

---

## 3. 🔧 **COSA HO TROVATO, E COSA HO DECISO** (è la parte che conta)

### ① Il preset FTMO **non si poteva riusare**, e i motivi sono tre — non uno

`mql5/Presets/ABTG_Guardian_FTMO_2Step.set` esiste ed è quello del dry-run sul
demo. **Aprendolo e contandolo** sono venute fuori **tre differenze obbligate**:

| | preset FTMO (demo) | preset REALE (nuovo) | perché |
|---|---|---|---|
| `InpStartBalance` | **100000** | **0** | 🔴 **la più grave.** Il 100000 **simulava** una challenge FTMO da 100k su un demo. Su **7.500 € veri** significherebbe soglie calcolate su un capitale **13 volte più grande del conto**: il limite giornaliero sarebbe **4.900 €** su un conto da 7.500 — cioè **nessuna rete, mai**. **0** = cattura in automatico il saldo vero al primo avvio e lo persiste |
| `InpMagic` | 779001 | **779002** | vedi ② |
| `InpAutotest` | **NON C'ERA** | **`true`** | 🟡 il preset FTMO **non lo nominava affatto**: prendeva il **default compilato `false`**, **in silenzio**. È la stessa forma della **trappola del 2% chiusa il 02/09** — un input che il preset non dichiara decide da solo |

**Tutto il resto è IDENTICO**: 4,9 / 9,9 / statico / reset 23 / pausa 4,0 / cap
3,25 / azione 0 / tutti i magic. ✅ **Copertura TOTALE verificata contando:
16 chiavi = 16 input**, ASCII puro, zero righe malformate, zero doppie.

> 🧾 **I numeri non li ho scelti io.** Sono la tua firma del **18/08/2026**
> (`CLAUDE.md`, *«cap rischio aperto 3,25% (C1) e pacchetto Guardian (pausa 4,0 /
> emergenza 4,9 e 9,9 / reset 23)»*, verbale `report/FIRME_2026-08-18.md`). Erano
> firmati **come politica di rischio di casa**, non solo per FTMO. **Non si tarano
> su un backtest: si cambiano con un'altra firma.**

### ② Il magic: **779002**, e perché non ho riusato il 779001

- **`779001` è il Guardian del dry-run FTMO sul demo.** Tenerli distinti vuol dire
  che, guardando la cronologia, **si sa sempre quale guardiano ha chiuso cosa** —
  e le chiusure d'emergenza portano il magic del guardiano (`SetExpertMagicNumber`).
- La famiglia **`779xxx` è il blocco dei guardiani** per convenzione di casa
  (`779001` Guardian, `7797xx`/`7799xx` blocchi di griglia dei round R97/R99).
- **`779002` è VERGINE**: **zero occorrenze in tutto il repository**, verificato
  con una ricerca su tutto l'albero **prima** di sceglierlo.
- Non collide con **`770101`** (DAX) né **`770611`** (ORB), i due magic vivi su
  quel terminale. **Il driver lo ricontrolla lui**, e si ferma se coincide.

### ③ `InpAutotest=true` è **sicuro** — e questo l'ho **letto nel codice**, non assunto

`ABTG_AutotestGuardia()` (in `ABTG_PausaGuardian.mqh` v1.51) gira **114 casi** sul
**nucleo puro**: funzioni che **ricevono numeri finti come argomenti** e
rispondono. **Nell'intero blocco dell'autotest** (le ~490 righe che lo compongono)
**non c'è NESSUNA `GlobalVariableSet`, NESSUNA `GlobalVariableDel`, NESSUN
`OrderSend`, NESSUN `PositionClose`, NESSUN `HistorySelect`** — contate a
macchina, non a occhio. **Non tocca il conto, non scrive nel canale, stampa e
basta.** E gira **prima** che il guardiano legga il saldo.

> ✅ **Precedente sullo stesso terminale, dichiarato:** `ABTG_ORB_Ottimizzato`
> gira sul reale **da stamattina** con `InpAutoTest=true`. Un autotest all'avvio
> su quel conto **non è una novità di oggi**.

Serve a due cose: è **la prova in Esperti** che gira davvero la v1.11 con
l'include v1.51, e la riga **«TUTTI I CASI PASSATI»** è il cancello prima di
fidarsi del guardiano.

### ④ 🧵 **L'INCLUDE NON SI RISCRIVE: SI VERIFICA** *(cancello NUOVO, non c'era stamattina)*

`ABTG_PausaGuardian.mqh` **è già** in quel terminale — ce l'ha messo la riga di
stamattina — e **i due `.ex5` già in campo sono stati compilati CONTRO QUEL
FILE**. Riscriverlo vorrebbe dire **cambiare la dipendenza sotto i piedi a due
binari vivi**. Allora:

- **manca** → **FATALE** (e vuol dire che siamo sul terminale sbagliato);
- **c'è ma con sha256 DIVERSO dal pin** → **FATALE** (o il pin è sbagliato, o
  qualcuno ha toccato il terminale: in tutti e due i casi, su un conto vero,
  **un «boh» vale un no**);
- **identico** → **non lo tocco**, e il referto lo dichiara.

👉 È anche **la conferma incrociata più forte che si potesse mettere**: quel file,
con **quei byte esatti**, ce l'ha messo la nostra riga.

### ⑤ 🪡 **IL FILO, verificato a tavolino PRIMA di installare** *(cancello NUOVO)*

Il guardiano **SCRIVE** su nomi di GlobalVariable costruiti dentro
`ABTG_Guardian.mq5`; gli EA **LEGGONO** da nomi costruiti dentro
`ABTG_PausaGuardian.mqh`. **Sono due posti diversi.** Se divergono — un refuso,
una radice cambiata a metà — **il canale muore in SILENZIO**: il guardiano scrive,
nessuno legge, **nessun errore da nessuna parte**.

Il sorgente ha una `VerificaFilo()` che se ne accorge **a runtime**. Qui i
**cinque nomi** (`ABTG_PAUSA_GIORNO`, `ABTG_PAUSA_FINO`, `ABTG_CAP_RISCHIO`,
`ABTG_RISCHIO_APERTO`, `ABTG_GUARDIAN_BATTITO`) si confrontano **PRIMA**, sui due
file scaricati al pin, **e se non coincidono non si installa**. ✅ Al pin: **5 su 5**.

### ⑥ ⚖️ La **coerenza** delle soglie, non solo i numeri

Non basta che ogni numero sia giusto: devono stare **nell'ordine giusto**. Il
driver pretende **`pausa 4,0% < giorno 4,9% < totale 9,9%`**. Se la pausa non
stesse sotto l'emergenza, **il freno morbido non frenerebbe mai prima della
chiusura d'autorità**: il gradino B1 sarebbe decorativo.

---

## ▶️ BLOCCO 1 — **CONTROLLO** (giro a vuoto: non scrive niente nel terminale)

Si lancia **prima**, anche di giorno, con MT5 aperto. Torna l'elenco delle
cartelle guardate, la cartella scelta col suo **criterio**, i gate sul sorgente,
**il preset aperto e contato**, **l'esito del filo** e le foto.

**🔴 Sostituisci `SCRIVI_QUI_IL_NUMERO` col numero del conto reale.**

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    $conto='SCRIVI_QUI_IL_NUMERO';
    if($conto -notmatch '^\d{5,12}$'){ throw 'DEVI SCRIVERE IL NUMERO DEL CONTO REALE al posto di SCRIVI_QUI_IL_NUMERO. Non ho toccato niente.' };
    if($conto -eq '50503392' -or $conto -eq '50504263'){ throw 'QUELLO E'' UN CONTO DEMO: sul 100k gira gia'' un Guardian. Serve il numero del conto REALE.' };
    $pin='a01e1573015685157a2faa6cce7bd6b0261d7392'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_DEPLOY_GUARDIAN_CONTOREALE.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_DEPLOY_GUARDIAN_CONTOREALE.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_DEPLOY_GUARDIAN_CONTOREALE_v1' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -LoginAtteso $conto -Modo CONTROLLO; $rc=$LASTEXITCODE;
    $d=$null; foreach($c in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if((-not $d) -and $c -and (Test-Path -LiteralPath $c)){ $d=$c } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'DEPLOY_GUARDIAN_CONTROLLO_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    if($z.Count -eq 0){ throw 'NESSUNO ZIP DEPLOY_GUARDIAN_CONTROLLO_ DI ADESSO SUL DESKTOP: la riga non e'' arrivata alla raccolta. Mandami quello che vedi qui sopra: va bene uguale.' };
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): NON e'' un fallimento, fa fede il REFERTO nello zip.' -ForegroundColor Yellow };
    if(($rc -is [int]) -and ($rc -ne 0)){ Write-Host 'GIRO CON PROBLEMI: lo zip ESISTE lo stesso, mandalo -- la riga ESITO DEL GIRO dice dove si e'' fermato.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan;
    $iv=[Globalization.CultureInfo]::InvariantCulture;
    Write-Host ('NEL REFERTO la riga data: e'' l''ORA DI AVVIO di questo giro (circa ' + $t0.ToString('yyyy-MM-dd HH:mm',$iv) + '), NON l''ora attuale (' + (Get-Date).ToString('HH:mm',$iv) + ').') -ForegroundColor Gray }
```

---

## ▶️ BLOCCO 2 — **CORSA** (installa e compila nel SOLO terminale del reale)

**Solo dopo un CONTROLLO pulito** — `ESITO DEL GIRO: COMPLETATO`, `PROBLEMI: 0`,
la riga `guardia sul conto` che dice **TROVATO**, la
`conferma incrociata` che dice **SI, tutti e tre**, e `L'INCLUDE` che dice
**IDENTICO al pin e NON TOCCATO** — e con **MetaEditor CHIUSO**.
**MT5 resta aperto**: le due sedie e il logger continuano a lavorare.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process metaeditor64 -EA SilentlyContinue){ throw 'METAEDITOR APERTO: chiudilo (MT5 puo'' restare aperto) e rilancia. Non ho scaricato e non ho toccato niente.' };
    $conto='SCRIVI_QUI_IL_NUMERO';
    if($conto -notmatch '^\d{5,12}$'){ throw 'DEVI SCRIVERE IL NUMERO DEL CONTO REALE al posto di SCRIVI_QUI_IL_NUMERO. Non ho toccato niente.' };
    if($conto -eq '50503392' -or $conto -eq '50504263'){ throw 'QUELLO E'' UN CONTO DEMO: serve il numero del conto REALE.' };
    $pin='a01e1573015685157a2faa6cce7bd6b0261d7392'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_DEPLOY_GUARDIAN_CONTOREALE.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_DEPLOY_GUARDIAN_CONTOREALE.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_DEPLOY_GUARDIAN_CONTOREALE_v1' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -LoginAtteso $conto -Modo CORSA; $rc=$LASTEXITCODE;
    $d=$null; foreach($c in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if((-not $d) -and $c -and (Test-Path -LiteralPath $c)){ $d=$c } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'DEPLOY_GUARDIAN_CORSA_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    if($z.Count -eq 0){ throw 'NESSUNO ZIP DEPLOY_GUARDIAN_CORSA_ DI ADESSO SUL DESKTOP: la riga non e'' arrivata alla raccolta. NON attaccare niente: mandami quello che vedi qui sopra, va bene uguale.' };
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): NON e'' un fallimento, fa fede il REFERTO nello zip.' -ForegroundColor Yellow };
    if(($rc -is [int]) -and ($rc -ne 0)){ Write-Host 'GIRO CON PROBLEMI: lo zip ESISTE lo stesso, mandalo. NON ATTACCARE L''EA prima di aver letto la riga INSTALLAZIONE del referto.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan;
    Write-Host 'RICORDA: il guardiano NON e'' su nessun grafico. Finche'' non ce lo metti TU, non sorveglia e non chiude niente.' -ForegroundColor Yellow;
    $iv=[Globalization.CultureInfo]::InvariantCulture;
    Write-Host ('NEL REFERTO la riga data: e'' l''ORA DI AVVIO di questo giro (circa ' + $t0.ToString('yyyy-MM-dd HH:mm',$iv) + '), NON l''ora attuale (' + (Get-Date).ToString('HH:mm',$iv) + ').') -ForegroundColor Gray }
```

> 📄 **I due referti hanno nomi DIVERSI, apposta**:
> `REFERTO_DEPLOY_GUARDIAN_CONTROLLO.txt` e `REFERTO_DEPLOY_GUARDIAN_CORSA.txt`.
> Con lo stesso nome, scompattando i due zip nella stessa cartella, uno
> cancellerebbe l'altro in silenzio (checklist classe 132).

---

# 🖱️ **I PASSI MANUALI — LI FA CLAUDIO, NON LA RIGA**

> # 🛑🛑 **LA RIGA NON HA ATTACCATO NIENTE E NON HA ACCESO NIENTE.**
> # **IL GUARDIANO NON È SU NESSUN GRAFICO.**
> # **FINCHÉ NON FAI TU I PASSI QUI SOTTO, NON SORVEGLIA E NON CHIUDE NIENTE.**

### PASSO 1 — far comparire l'EA
**Navigatore → Expert Advisors → tasto destro → Aggiorna.** Deve comparire
**`ABTG_Guardian`**. Se non c'è, la CORSA non è andata su **questo** terminale:
rileggi `cartella dati scelta` nel referto e **fermati**.

### PASSO 2 — un **TERZO** grafico, **NUOVO**
> 🛑 **GRAFICO NUOVO, MAI UNO CHE HA GIÀ UN EA.** Un grafico MT5 tiene **UN SOLO
> Expert Advisor**: trascinare il guardiano sul grafico del **DAX** o dell'**ORB**
> **SOSTITUIREBBE la sedia**, spegnendola in silenzio. `File > Nuovo grafico`.

**Simbolo e timeframe NON contano** — il guardiano guarda il **CONTO**, non il
grafico. Deve solo essere un grafico **senza EA**.

### PASSO 3 — carica il preset e **fotografa PRIMA di premere OK**
Trascina **`ABTG_Guardian`** → scheda **«Dati in Ingresso» → `Carica...`** →
**`ABTG_Guardian_REALE.set`** (te lo apre già nella cartella giusta).

📸 **PRIMA DI OK, guarda a schermo e fai lo screenshot:**

| input | deve dire |
|---|---|
| **`InpAction`** | **0** ← *se leggi 1, il guardiano guarda e non fa niente* |
| **`InpCloseAllMagics`** | **true** |
| **`InpStartBalance`** | **0** ← *🛑 se leggi **100000**, NON premere OK: è il preset del demo* |
| **`InpMagic`** | **779002** |
| `InpDailyLossPct` / `InpTotalDDPct` | **4.9** / **9.9** |
| `InpDailyPausePct` / `InpMaxOpenRiskPct` | **4.0** / **3.25** |
| `InpDailyResetHour` | **23** (ora **SERVER**) |
| `InpAutotest` | **true** ← **non spegnerlo** |

### PASSO 4 — **AutoTrading acceso, e la faccina che sorride**
Faccina **triste** = quell'EA **non** è abilitato: **senza AutoTrading il
guardiano scrive le sue GlobalVariable ma NON PUÒ CHIUDERE.** 📸 Screenshot.

### PASSO 5 — 🖼️ **IL PANNELLO SUL GRAFICO: è QUI che si verifica tutto**
```
=== ABTG GUARDIAN ===
Stato: OK - operativo
Saldo iniziale: 7500.00        <-- IL SALDO VERO. Se leggi 100000: STACCA L'EA.
Equity: 7500.00   Balance: 7500.00
--- GIORNO ---
Inizio giorno: 7500.00
Perdita oggi: 0.00  (0.00% / limite 4.9%)
--- TOTALE (statico) ---
Picco equity: 7500.00
Drawdown: 0.00  (0.00% / limite 9.9%)
Azione: CHIUDI+BLOCCA
--- NUOVI INGRESSI ---
Pausa morbida (4.0%): libera
Rischio aperto: 0.00% / cap 3.25% -> ok
```
*(riprodotto dalla stringa di formato del pannello in `ABTG_Guardian.mq5`, non a
memoria: le cifre dipendono dal tuo saldo, le etichette e l'ordine no.)*
📸 **Screenshot del pannello: è la prova fotografica del deploy.**
🛑 Se `Saldo iniziale` **non** è il saldo vero: **stacca l'EA**, cancella da **F3**
la variabile `ABTG_GUARD_<login>_START` e riattaccalo.

### PASSO 6 — la scheda **ESPERTI** (⚠️ **non** «Giornale»)
```
[AUTOTEST] ABTG_PausaGuardian v1.51 -- nucleo puro, ora finta=1000000 tolleranza=120 s
[AUTOTEST] ABTG_PausaGuardian: TUTTI I CASI PASSATI.
[GUARDIAN] filo verificato: 5 GlobalVariable su 5 con lo stesso nome fra guardiano e include (conto ...)
[GUARDIAN] avviato. Saldo iniziale=7500.00  DailyLoss=4.9%  DD=9.9% (statico)  Azione=CHIUDI+BLOCCA
[GUARDIAN] pausa morbida=4.00%  cap rischio aperto=3.25% (modo ingresso)  reset giorno=23:00 server
```
🛑 **Se compare `*** FILO ROTTO ***` o `CASI FALLITI`: STACCA L'EA** e mandami lo
screenshot. Sono **le due righe che dicono che la rete non è collegata a niente.**
📸 Screenshot della scheda Esperti.

### PASSO 7 — 🎁 **il regalo: da adesso le DUE SEDIE hanno davvero una rete**
Fino a ieri `ABTG_GuardiaIngresso()` dentro DAX e ORB era **fail-open a vuoto**:
non trovava le GlobalVariable e **lasciava passare tutto**. Da quando il guardiano
gira, **quelle variabili esistono**: la **pausa B1** e il **cap C1** cominciano a
mordere **senza ricompilare niente**. 👉 **Non serve toccare le due sedie.**

> ⏰ **Le ore dei log MT5 sono in ORA LOCALE del VPS (= ora italiana); il grafico è
> in ora SERVER (un'ora indietro).** Non si confrontano. Regola fissa del `CLAUDE.md`.

---

## 🔎 COME SI LEGGE IL REFERTO — le righe, in quest'ordine

1. **`ESITO DEL GIRO`** + **`data:`** (= l'ora in cui hai **lanciato**) + **`modo:`**.
2. **`guardia sul conto`** — deve dire **`TROVATO`** e **`conti vietati visti qui: NESSUNO`**.
3. **`cartella dati scelta`** + **`criterio di scelta`**. Un
   `SCELTA ATTESTATA A MANO, NON MISURATA` **non è un verde**: vuol dire che ci
   siamo fidati della tua firma.
4. **`conferma incrociata (i tre EA gia' in campo)`** — deve dire **`SI, tutti e tre`**
   coi magic `770101` e `770611` trovati.
5. 🔥 **`L'INCLUDE (si verifica, NON si riscrive)`** — deve dire **`IDENTICO al pin
   e NON TOCCATO`**.
6. 🔥 **`IL FILO guardiano -> EA`** — deve dire **`5 GlobalVariable su 5`**.
7. **`GATE SUPERATI`** — versione 1.11, il nucleo (`FlattenAll`/`OpenRiskPct`/
   `VerificaFilo`/`SetPausa` + `EventSetTimer(1)`), i **default COMPILATI**
   (`InpAction=0`, `InpCloseAllMagics=true`: **anche un RIPRISTINA sulla finestra
   dei parametri non spegne la rete**).
8. 🔥 **`IL PRESET, APERTO E CONTATO`** — **la riga che vale di più**: **16 chiavi =
   16 input** (copertura **TOTALE**), il saldo di riferimento, le due soglie che
   **chiudono**, i due freni che **non chiudono**, l'azione, il magic, e
   **`coerenza delle soglie: pausa 4.0% < giorno 4.9% < totale 9.9%`**.
9. **`compilazione ABTG_Guardian`** con la sua **`riga Result del log`**: si
   pretende **`0 errors, 0 warnings`**.
10. **`INSTALLAZIONE`** — `AVVENUTA: 3 file su 3` / `TENTATA E RIPRISTINATA` /
    `NON AVVENUTA`, e **`ripristino`** dice cosa è stato rimesso e da dove.
11. **`I TRE EA GIA' IN CAMPO E L'INCLUDE`** — deve dire **`INVARIATI su N foto di
    file REALMENTE PRESENTI`**. Subito dopo, il **registro** del logger: se è
    **cresciuto**, è **normale e giusto**.
12. **`GRAFICI E CONFIGURAZIONE`** — deve dire **`INVARIATI`**: 👉 **è la prova che
    il guardiano non è stato attaccato a nessun grafico, cioè che non è ancora in
    condizione di chiudere niente a nessuno.**
13. **`CARTELLA Presets`** — deve dire **«cambiato SOLO il `.set` nostro; gli altri
    N file già presenti sono INVARIATI uno per uno»** — **compresi i due preset
    delle sedie messi stamattina**.
14. Le **tre righe `REALE ...`**: in una CORSA riuscita dicono **`CAMBIATO`** (o
    `ASSENTE → presente`); in CONTROLLO o dopo un ripristino, `INVARIATO` /
    `ASSENTE prima e dopo`.
15. **`PROBLEMI:`** e **`RILIEVI:`**, poi l'elenco delle cartelle guardate.

---

## 🚦 LE USCITE, UNA PER UNA (**c'è lo zip? sì o no**)

| Cosa succede | Zip sul Desktop | Il terminale del reale | Cosa mandare |
|---|---|---|---|
| **`SCRIVI_QUI_IL_NUMERO` lasciato lì** | ❌ NO | **intatto** | il messaggio rosso; metti il numero e rilancia |
| **Numero di un conto DEMO** | ❌ NO | **intatto** | il messaggio rosso — e **non si forza** |
| **MetaEditor aperto**, blocco CORSA (si ferma **prima** di scaricare) | ❌ NO | **intatto** | il messaggio rosso; chiudi MetaEditor e rilancia |
| **`SCRIPT VECCHIO`** o download fallito | ❌ NO | **intatto** | il messaggio (404 su un pin appena creato: aspetta 5 minuti e **rilancia la stessa riga**) |
| **Gate sul sorgente** (versione ≠ 1.11, funzioni del nucleo, `EventSetTimer(1)`, **default compilati non sicuri**, include) | ✅ SÌ | **intatto** | lo zip: `ESITO DEL GIRO: FERMATO ...` col motivo |
| 🧵 **IL FILO ROTTO** (un nome di GlobalVariable diverso fra `.mq5` e `.mqh`) | ✅ SÌ | **intatto** | lo zip — **è il caso peggiore che si potesse evitare**: senza questo gate il guardiano girerebbe scrivendo su nomi che nessuno legge |
| **Gate sul PRESET** (non-ASCII, riga malformata, chiave doppia/estranea, copertura non totale, magic sbagliato o collidente, **`InpAction=1`**, **`InpStartBalance=100000`**, un numero ≠ dalla firma, soglie incoerenti) | ✅ SÌ | **intatto** | lo zip — **non si forza** |
| 🧷 **INCLUDE assente o diverso dal pin** | ✅ SÌ | **intatto** (l'include **non** viene toccato) | lo zip: prima di installare un guardiano si capisce su quale terminale siamo |
| **I tre EA NON ci sono nella cartella** | ✅ SÌ | **intatto** | lo zip — **RILIEVO forte**, non blocco: leggilo prima della CORSA |
| **Cartella col login non trovata / ambigua** | ✅ SÌ | **intatto** | lo zip + `CANDIDATE.txt` (vedi il riquadro giallo) |
| **Cartella che ha visto un conto demo** | ✅ SÌ | **intatto** | lo zip — **non c'è manopola** |
| **CONTROLLO pulito** | ✅ SÌ | **intatto** | lo zip → si passa alla CORSA |
| **CORSA, compilazione fallita / muta** | ✅ SÌ (+ backup) | **RIPRISTINATO, tutti e tre** | lo zip, **prima di riprovare**. **Non attaccare niente** |
| **CORSA, eccezione dopo la scrittura** | ✅ SÌ (+ backup) | **RIPRISTINATO** (`ripristino: ... dopo un'eccezione`) | lo zip |
| **CORSA con WARNING di compilazione** | ✅ SÌ | **i file ci sono**, ma è un **PROBLEMA** | lo zip **col log**, e **NON attaccare niente** finché non l'ho letto |
| **CORSA OK** | ✅ SÌ (+ backup) | 3 file su 3, grafici e config `INVARIATI`, i tre EA e l'include `INVARIATI` | lo zip → **i PASSI MANUALI** |
| **Sentinella di un giro interrotto, in CONTROLLO** | ✅ SÌ | **intatto** | lo zip: `PROBLEMI: 1` che dice di rilanciare in CORSA (che rimette a posto da sola) |

## 🟡 SE LA RIGA SI FERMA SU «NON HO TROVATO NESSUNA CARTELLA COL LOGIN…»
Non è un guasto: è la regola di casa (**classe 115** — l'ambiente non si indovina
dal nome, si decide con un fatto). Nel referto e in `CANDIDATE.txt` c'è **l'elenco
di tutto quello che ha guardato**, coi login visti in ognuna e il perché di ogni
scarto. Tre casi:
- **sessione sbagliata** → sul VPS i terminali girano sotto **Administrator**:
  cambia sessione e rilancia **lo stesso blocco**;
- **la riconosci nell'elenco ma il login non compare** → aprila in MT5, **guarda
  con gli occhi il numero di conto**, e rilancia aggiungendo al driver:
  `-CartellaDati "<percorso incollato>" -ConfermoConto <lo stesso numero>`. Il
  numero va scritto **due volte**: è una **firma**, e il referto la registra come
  **`SCELTA ATTESTATA A MANO, NON MISURATA`**;
- **la cartella ha visto un conto demo** → **non si sblocca**, e non c'è manopola.

## 🔴 AVVISI ATTESI (nessuno è un guasto)
1. Rilievo **`MT5 APERTO`** — **atteso e voluto**: le sedie e il logger continuano.
2. **`codice di uscita di metaeditor64: 1`** con `.ex5` fresco e `Result: 0 errors`
   → comportamento **misurato** su questo VPS (**classe 108**).
3. **Nessun rilievo di byte non-ASCII**: sia `ABTG_Guardian.mq5` sia
   `ABTG_PausaGuardian.mqh` sia il `.set` sono **ASCII puro** (0 byte > 126,
   contati). Se ne compare uno, **è un file diverso da quello che ho verificato**.
4. Il **registro del logger cresciuto** fra la foto prima e quella dopo: **giusto così**.
5. La cartella **`backup_guardian_...`** resta sul Desktop: si cancella a mano,
   **dopo** che i passi manuali sono chiusi.

---

## ⚠️ **QUELLO CHE QUESTO DEPLOY NON PROTEGGE** — da sapere prima di accendere

- ⛔️ **IL BLOCCO TOTALE È DEFINITIVO E LO SBLOCCHI SOLO TU.** A **-9,9%** il
  guardiano scrive `ABTG_GUARD_<login>_FAILED=1` e **da lì in poi richiude tutto
  ogni secondo**, comprese le posizioni che apriresti **a mano**. Si toglie **solo**
  cancellando quella GlobalVariable da **F3**. Non è un difetto: è la definizione
  di «stop». Ma **va saputo prima**, non alle 15:40 di un martedì.
- 🎯 **IL DD TOTALE È STATICO, NON TRAILING** (`InpDDMode=0`, firma del 18/08). Il
  pavimento resta a **~6.757 €** anche se il conto sale: 👉 **questo guardiano
  difende il CAPITALE DI PARTENZA, non i profitti già fatti.** Se un domani vorrai
  proteggere anche quelli, il trailing è una **regola diversa** e va **firmata a
  parte** — non la cambio io in un preset.
- 🟡 **IL CAP C1 (3,25%) OGGI È INERTE, e lo dico invece di spacciarlo per rete.**
  Con **due sole sedie** a 0,65% il rischio aperto massimo possibile è **~1,3%**:
  il cap **non morde mai**. Non è un errore — è **margine già firmato**, pronto per
  quando le sedie saranno di più. Ma **oggi non protegge da niente**.
- 🕳️ **NON C'È lo STOP A OBIETTIVO RAGGIUNTO (S1).** Il guardiano difende **il muro
  in basso**; **non** sa che a un certo punto conviene smettere di guadagnare. S1
  esiste nell'include ma **è per-sedia e va acceso sugli EA**, non qui.
- ⏱️ **LA PAUSA MORBIDA E IL CAP NON SONO ISTANTANEI.** Bloccano **l'AGGIUNTA** di
  rischio: un ordine **PENDENTE** già piazzato quando il cap era libero **scatterà
  lo stesso** (sta scritto nell'include, e lo riporto come letto).
- 🧮 **`InpStartBalance=0` cattura il saldo UNA VOLTA e lo persiste.** Se domani
  versi o prelevi, le soglie restano calcolate sul **vecchio** saldo finché non
  cancelli `ABTG_GUARD_<login>_START` da F3 e riavvii l'EA.
- 🔌 **Guardiano spento = niente rete, e anche niente freni.** Se MT5 è chiuso o
  l'EA non è sul grafico, il **battito** si ferma: pausa e cap **scadono da soli**
  entro 120 s (fail-open voluto) e i due EA tornano a operare **senza** B1 e C1.
  **Non è un guasto: è la scelta di casa** — un cane da guardia morto non deve
  fermare la flotta per sempre.

---

## 🧪 COSA È STATO PROVATO **ESEGUENDO**, NON LEGGENDO — **136 casi, 0 rossi**

Qui sotto c'è capitale vero e un EA che può chiudere posizioni, quindi il conto lo
do per esteso:

- **62 casi** sul banco a terra, sulle **funzioni VERE estratte dal driver con
  l'AST** (non su una copia: è il testo del file che gira). Fra questi **11
  sabotaggi**, e ognuno è stato **beccato**: intestazione `=== ... ====` senza `;`,
  **chiave doppia `InpAction=1`**, chiave storpiata, input **tolto** dal preset,
  **`InpStartBalance=100000`** (il finto saldo FTMO), **`InpAction=1`** (guardiano
  in solo allarme), **pausa 5,5 ≥ giornaliera 4,9** (incoerenza), **magic 770101**
  che collide col DAX, forma `valore||start||step||stop` dell'ottimizzatore, byte
  non-ASCII, e **`4,9` con la virgola** invece del punto.
  ➕ il **sabotaggio del filo**: una GlobalVariable rinominata nel guardiano →
  **beccata**.
- **8 casi** sulla guardia del conto: i **due** conti vietati come `-LoginAtteso`
  (anche in CORSA), `-LoginAtteso` mancante e non numerico, `-Pin` mancante e non a
  40 hex, `-ConfermoConto` diverso.
- **52 casi end-to-end** con **lo script SCARICATO DAL PIN** contro **sei finti
  terminali**: CONTROLLO su un terminale sano (sceglie, non scrive, zip e referto
  prodotti); cartella che **ha visto un conto demo** → scartata **anche imposta a
  mano**; **include assente** → fatale; **include diverso dal pin** → fatale **e
  l'include non viene toccato**; i tre EA mancanti → **rilievo forte, non blocco**;
  **CORSA con compilazione fallita** → **tutti e tre i file ripristinati**, il
  `.mq5` preesistente rimesso **con sha256 identico**, il `.set` **estraneo** e il
  `.ex5` di una **sedia viva** intatti, sentinella pulita; **CORSA riuscita** →
  3 file su 3, il `.set` col **magic 779002**, l'include **non riscritto**, grafici
  e config `INVARIATI`; **sentinella** di un giro interrotto.
- **14 casi sulle DUE RIGHE CHE INCOLLI TU**, prese **verbatim da questa pagina**
  (estratte dal `.md` con un parser, non ricopiate): tutte e due **parsano con 0
  errori**; col `SCRIVI_QUI_IL_NUMERO` lasciato lì si fermano **prima di
  scaricare** (e si verifica che **non abbiano scaricato niente**); col conto demo
  **50503392** e col 100k **50504263** si fermano col messaggio giusto; col numero
  buono il blocco CONTROLLO **scarica davvero dal pin**, passa il **marcatore**,
  arriva alla raccolta e stampa **`MANDA IN CHAT QUESTO FILE`**.
- **`Parser::ParseFile` sul file al pin: 0 errori.** **ASCII puro: 0 byte > 126**
  in tutti e due i file nuovi. Il **pin** compare **4 volte** nella pagina, sempre
  come la **stessa identica stringa da 40 hex** (contato, non guardato).

> ⚠️ **QUELLO CHE NON È PROVATO, E VA DETTO: LA COMPILAZIONE VERA.** Qui non c'è
> MetaEditor. Il sorgente passa tutti i gate statici, l'include è **byte per byte
> lo stesso** (`b7462cd5…`) contro cui stamattina hanno compilato **0 errors,
> 0 warnings** i due EA delle sedie, e nel banco il compilatore è **finto**. Il
> primo `Result:` **vero** lo vedremo **nel referto della CORSA**.
>
> ⚠️ **E un secondo limite, dichiarato:** il banco end-to-end gira su Linux, dove
> `MQL5\Experts\x.mq5` è **un nome di file**, non un percorso annidato. I finti
> terminali sono costruiti **chiedendo allo script stesso** i percorsi, quindi **la
> logica provata è quella vera**; cambia solo dove finiscono i byte. Su Windows i
> percorsi si annidano davvero.

---

_Artefatti al pin `a01e1573015685157a2faa6cce7bd6b0261d7392`:
`backtest_pipeline/righe/RIGA_DEPLOY_GUARDIAN_CONTOREALE.ps1`,
`mql5/Experts/ABTG_Guardian.mq5`,
`mql5/Presets/conto_reale/ABTG_Guardian_REALE.set`,
`mql5/Include/ABTG_PausaGuardian.mqh` (**solo per confronto: non viene installato**).
Pagine gemelle già eseguite: `RIGA_DEPLOY_CONTOREALE_DA_MANDARE.md` (le due sedie),
`RIGA_SLIPPAGELOGGER_DA_MANDARE.md`. Le firme dei numeri:
`CLAUDE.md` § «CRITERIO DI USCITA DELLE SEDIE» e `report/FIRME_2026-08-18.md`.
Il preset del dry-run FTMO da cui questo diverge in tre punti:
`mql5/Presets/ABTG_Guardian_FTMO_2Step.set`._
