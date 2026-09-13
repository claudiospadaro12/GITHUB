# 🔴 LA CODA DELLE 03:30 NON HA PUBBLICATO — e dal repo **non si sa perche'**

_13/09/2026, 04:50 ora Roma. **80 minuti** dall'avvio contro **46** attesi, e su
`origin/lavoro` **zero commit del runner**. Questo file dice esattamente cosa so,
cosa non so, e la riga di SOLA LETTURA che scioglie il dubbio._

---

## 1. 📏 I FATTI, misurati

| cosa | valore |
|---|---|
| righe armate nella coda | **48** (36 round + 12 sola lettura) |
| durata attesa | `36 x 0,6 + 0,077 x ~322` = **~46 minuti** → fine ~04:16 |
| ora del controllo | **04:50** (80 minuti dall'avvio) |
| commit di `claudiospadaro12` con messaggio `Runner ABTG: referto automatico` oggi | 🔴 **ZERO** |
| ultimo referto in archivio | `REFERTO_RUNNER_20260912_033002.txt` — **ieri** |

### ✏️ E il primo allarme era MIO, sbagliato
Alle 04:27 stavo per dichiarare il guasto. Avevo in testa **"~26 minuti"** di durata:
🔴 **sbagliato** — avevo riusato una cifra per 300 passate **senza il costo fisso
per round**, cioe' **36 x 0,6 = 21,6 minuti** non contati. A 04:27 la corsa poteva
essere ancora in piedi, e dichiararla morta sarebbe stato un falso allarme
costruito su un mio errore di aritmetica. **A 04:50 il margine e' finito.**

---

## 2. 🔴 PERCHE' NON SI SA COSA E' SUCCESSO — ed e' una proprieta' del runner

`backtest_pipeline/runner_abtg.ps1` **pubblica SOLO ALLA FINE** (r.801-832) e
**non ha nessun marcatore d'avvio**. Conseguenza, letta nel codice:

> ## Dal repository, una corsa **MORTA A META'** e una corsa **MAI PARTITA** sono **INDISTINGUIBILI**.

🟡 E ieri questo non si era visto perche' la corsa del 12/09 e' durata **90
secondi** (avvio 03:30:02, pubblicazione 03:31): non aveva round veri. Oggi ne ha
**36**. E' esattamente il caso in cui l'assenza di un battito cardiaco inganna.

🚫 **Quindi NON dico quale delle due e'.** Le tre ipotesi restano aperte:
1. l'attivita' pianificata **non e' partita** (VPS spento, attivita' disabilitata,
   credenziali scadute);
2. e' partita ed e' **morta a meta'** (e allora non pubblica niente, per come e'
   scritta);
3. e' **ancora in corso**, impuntata su una riga.

🔴 **CORREZIONE DEL 13/09, 05:30 — e sposta la terza ipotesi da "improbabile"
a PIU' PROBABILE.** Avevo scritto che una corsa viva a 80 minuti era improbabile.
Poi ho aperto il modo in cui il runner esegue una riga, **r.773-775**:
```
$p = Start-Process -FilePath "powershell.exe" -ArgumentList $argv -NoNewWindow -PassThru -Wait `
      -RedirectStandardOutput $log -RedirectStandardError ($log + ".err")
```
👉 **`-Wait` SENZA NESSUN TETTO DI TEMPO.** Non c'e' un `-Timeout`, non c'e' un
`WaitForExit(ms)`, non c'e' nessun controllo di durata da nessuna parte del file.
**Una singola riga che si impunta blocca l'intera corsa per SEMPRE**, e il runner
non se ne accorge, non la uccide e non va avanti.
🔴 Quindi a **3 ore** dall'avvio la spiegazione *"e' ancora li', ferma su una
riga"* non e' la meno probabile: **e' quella che il codice rende piu' facile**. E
ha una conseguenza pratica: e' la sola ipotesi in cui **le misure non sono perse**,
perche' i round gia' fatti hanno gia' scritto i loro CSV sul banco.
👉 **Per questo la riga 0 della tabella di verita' (`State = Running`) sta in
CIMA e si legge per prima.** E vale piu' che mai: 🔴 **NON si chiude niente di
propria iniziativa** — un `terminal64` sul VPS puo' essere una sedia in forward.

---

## 3. 🖥️ LA RIGA CHE SCIOGLIE IL DUBBIO — **SOLA LETTURA**

> ### 🖥️ BERSAGLIO: **finestra PowerShell sul VPS** (`VMI3047753`)
> 🔴 **NON tocca NESSUN terminale MT5.** Sul VPS convivono **sei** cartelle dati
> (`50503392` piccolo · `50504263` 100k · **`10105439` REALE** · `50504400` banco ·
> Pepperstone · Tickmill): questa riga **non ne apre, non ne chiude, non ne
> modifica nessuna**. Legge e stampa.
> 🔴 **E SE ESCE FUORI UN `terminal64` VIVO: NON SI CHIUDE NIENTE.** Sul VPS un
> `terminal64` puo' essere **una sedia in forward**, non il tester. La
> `CommandLine` dice quale e', e la decisione e' **di Claudio**.

```
$T='ABTG_Runner'; $OGGI=(Get-Date).Date; $TAG=(Get-Date -Format 'yyyyMMdd')
$CART=@((Join-Path $env:USERPROFILE 'abtg_runner'),'C:\Users\Administrator\abtg_runner') | Select-Object -Unique
Write-Host "=== 1. ATTIVITA' PIANIFICATA ==="
$tk = Get-ScheduledTask -TaskName $T -ErrorAction SilentlyContinue
if($tk){ $tk | Format-Table TaskName, State -AutoSize
  $inf = $tk | Get-ScheduledTaskInfo
  $inf | Format-List TaskName, LastRunTime, LastTaskResult, NextRunTime, NumberOfMissedRuns
  $partita = ($inf.LastRunTime -ne $null) -and ($inf.LastRunTime.Date -eq $OGGI)
  Write-Host ("  RISPOSTA: PARTITA OGGI (LastRunTime)? " + $(if($partita){"SI"}else{"NO"})) }
else { Write-Host "  RISPOSTA: ATTIVITA' 'ABTG_Runner' NON TROVATA per questo utente" }
Write-Host ""
Write-Host "=== 2. FILE DI LAVORO DI OGGI ==="
foreach($L in $CART){ Write-Host ("--- cartella: " + $L)
  if(Test-Path $L){
    $og = @(Get-ChildItem $L -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -ge $OGGI })
    if($og.Count -eq 0){ Write-Host "    NESSUN file di oggi" } else { $og | Sort-Object LastWriteTime | Format-Table Name, Length, LastWriteTime -AutoSize }
    $rf = @(Get-ChildItem $L -Filter ("REFERTO_RUNNER_" + $TAG + "*.txt") -ErrorAction SilentlyContinue)
    Write-Host ("    RISPOSTA: REFERTO DI OGGI: " + $(if($rf.Count -ge 1){"SI -- " + $rf[0].Name + "  (la corsa E' ARRIVATA IN FONDO)"}else{"NO  (la corsa NON e' arrivata in fondo, oppure e' ancora in corso)"}))
    Write-Host "    ultimi 5 in assoluto, per confronto:"
    Get-ChildItem $L -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 5 | Format-Table Name, Length, LastWriteTime -AutoSize
  } else { Write-Host "    la cartella NON esiste" } }
Write-Host ""
Write-Host "=== 3. LA CARTELLA DELLO SCRIPT ==="
if(Test-Path 'C:\ABTG'){ Get-ChildItem 'C:\ABTG' | Format-Table Name, Length, LastWriteTime -AutoSize } else { Write-Host "  C:\ABTG ASSENTE" }
Write-Host ""
Write-Host "=== 4. C'E' UN TESTER ANCORA VIVO? SOLA LETTURA: qui non si chiude niente ==="
Write-Host ("    processi terminal64 attivi: " + @(Get-Process terminal64 -ErrorAction SilentlyContinue).Count)
Get-WmiObject Win32_Process -Filter "Name='terminal64.exe'" -ErrorAction SilentlyContinue | Select-Object ProcessId, CreationDate, @{n='CPU_min';e={[math]::Round(($_.UserModeTime + $_.KernelModeTime)/600000000,1)}}, CommandLine | Format-List
```

📌 **Due cose dichiarate sulla riga:**
- **Niente `schtasks`**: e' un comando **nativo** che puo' anche **creare o
  cancellare** attivita', e sta nei DIVIETI del runner stesso. `Get-ScheduledTask`
  e `Get-ScheduledTaskInfo` sono di sola lettura **per costruzione**.
- **Nessun pin, nessun marcatore, nessuna raccolta**, ed e' corretto: la riga **non
  scarica niente** e **non esegue nessuno script**; l'uscita e' una ventina di
  righe che Claudio **legge a schermo e incolla in chat**.

### 🔎 LA TABELLA DI VERITA' — si legge dall'alto, ci si ferma alla PRIMA che combacia
🔴 **Questa e' la versione 2. La 1 aveva TRE difetti, e uno mandava Claudio
nel posto sbagliato con la sicurezza di chi ha un metodo** — vedi §3-bis.

| # | blocco 1 | blocco 2 | → **la causa e'** |
|---|---|---|---|
| 0 | `State` = **Running** | — | 🟡 **ANCORA IN CORSO**. Il blocco 4 conferma (`CPU_min` che sale). 🔴 **Non si chiude niente.** |
| 1 | attivita' **NON TROVATA** | — | 🔴 **NON ESISTE per questo utente**: cancellata, o la shell e' di un altro profilo |
| 2 | `PARTITA OGGI?` **NO** | nessun file di oggi in **nessuna** delle due cartelle | 🔴 **MAI PARTITA**: VPS spento alle 03:30, attivita' disabilitata, o utente non connesso (`schtasks` senza `/RU` gira **solo a utente connesso**) |
| 3 | `PARTITA OGGI?` **SI** | **nessun** file di oggi | 🟠 **CARTELLA SBAGLIATA** (altro profilo utente) **oppure** morta prima del primo round. Il blocco 3 discrimina |
| 4 | `PARTITA OGGI?` **SI** | file di oggi **SI**, `REFERTO DI OGGI` **NO** | 🔴 **MORTA A META'**: guarda `RIGA_SOTTILE_ROUND_*.log`. ⚠️ dice **l'ultimo** round tentato, non quanti ne ha fatti |
| 5 | `PARTITA OGGI?` **SI**, `LastTaskResult` = **4** | `REFERTO DI OGGI` **SI** | 🟡 **CORSA COMPLETA, TOKEN NON TROVATO** (r.806). Referto **integro sul VPS**: si recupera a mano. 🟢 **Nessuna misura persa** |
| 6 | `PARTITA OGGI?` **SI**, `LastTaskResult` = **0** | `REFERTO DI OGGI` **SI** | 🟡 **CORSA COMPLETA, PUBBLICAZIONE FALLITA** (token scaduto / API): `PubblicaFile` fallisce e il runner esce **0** lo stesso (r.836). 🟢 Referto **integro sul VPS** |
| 7 | qualunque altra combinazione | | ❓ **non prevista**: si incolla l'uscita intera e si ragiona, **non si indovina** |

📌 **`NumberOfMissedRuns` e' una NOTA, non un criterio**: e' **cumulativo** dalla
creazione dell'attivita' e parla del **passato**, non di stanotte.

---

## 3-bis. 🚨 LA MIA PRIMA TABELLA ERA SBAGLIATA — e in un modo che costava

Il cancello l'ha rotta in tre punti, e li ho verificati tutti nel sorgente:

| il difetto | la prova |
|---|---|
| 🔴 ~~`LastTaskResult != 0` = "morta a meta'"~~ | **FALSO.** `runner_abtg.ps1` **r.806**: `if(-not $tok){ ...; exit 4 }` → **`exit 4` e' una corsa COMPLETA**, referto scritto, solo **non pubblicata**. La mia tabella mandava Claudio a cercare *"la riga dell'errore"* in un log che dice che e' **andato tutto bene** — ed e' fra le cause **piu' probabili** del sintomo |
| 🔴 ~~`NumberOfMissedRuns > 0` in OR con LastRunTime~~ | E' **cumulativo**. Basta **una notte di VPS spento la settimana scorsa** perche' resti positivo, e la tabella dichiarava *"MAI PARTITA"* una corsa **partita regolarmente** |
| 🔴 **una combinazione MANCANTE** | `LastRunTime` oggi **+** `LastTaskResult` 0 **+** **nessun file di oggi** non era in tabella. E' il caso *"stai guardando la cartella di un ALTRO profilo"* — e senza quella riga si conclude **MAI PARTITA**, cioe' **il contrario del vero** |

### 🥇 E il discriminante buono ce l'avevo in mano e non l'avevo usato
**Non e' il codice di uscita: e' l'ARTEFATTO.** `REFERTO_RUNNER_<oggi>*.txt` si
scrive a **r.793**, cioe' **dopo l'ultimo round e PRIMA della pubblicazione**. La
sua sola presenza separa *"morta a meta'"* da *"arrivata in fondo e non
pubblicata"* **senza interpretare nessun numero**. E' la **classe 154** di casa
(*il verdetto sta sull'artefatto, non sul codice di uscita*) — scritta per i lanci,
e che non avevo applicato alla diagnosi.

🔴 **E un difetto del runner trovato per strada**: `$nome` viene dal **nome dello
script** (r.767), e tutte e 36 le righe round puntano allo stesso
`RIGA_SOTTILE_ROUND.ps1`. Quindi **i 36 round si sovrascrivono lo stesso log**, e
anche in una corsa riuscita ne resta **uno solo**. Il log dice *l'ultimo* round
tentato, e **non si potra' sapere a quale dei 36 era arrivata.**

---

## 4. 🧭 COSA NON SI PERDE, comunque vada

🟢 Le 48 righe sono **armate e pinnate**, e nessuna e' stata consumata: la coda
riparte **identica** alla prossima corsa, senza rifare niente. I tre `R142` sono
passati da **quattro** passate del cancello e restano validi al byte.
🟢 Il lavoro della notte che **non dipende** dalla coda e' tutto in casa: il
verdetto Nasdaq corretto, i cinque preset verificati, il Guardian `779001` scritto
su file, il gemello DAX ritrovato, e il pacchetto `EMA200` **PASSATO**.
🔴 Cio' che manca sono **le misure**: la voce 3 del certificato resta aperta, e
`canfrz`/`cemad02` non hanno risposto. **Un giorno di macchina perso, non un
giorno di lavoro perso.**

---

## 5. 🔧 E UN DIFETTO DA RIPARARE, quando si e' svegli
Il runner dovrebbe scrivere un **marcatore d'avvio** appena parte — un file di due
righe pubblicato subito — cosi' che *"mai partita"* e *"morta a meta'"* si
distinguano **dal repo**, senza chiedere niente a Claudio. Oggi non si distinguono,
e questa notte e' costata **23 minuti** di indagine solo per capire che non si
poteva capire. Non lo tocco adesso: modificare il runner e' lavoro da fare da
svegli e da far verificare.
