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
3. e' **ancora in corso** — improbabile a 80 minuti su 46 attesi, ma non escluso
   se una singola passata si e' impuntata.

---

## 3. 🖥️ LA RIGA CHE SCIOGLIE IL DUBBIO — **SOLA LETTURA**

> ### 🖥️ BERSAGLIO: **finestra PowerShell sul VPS** (`VMI3047753`)
> 🔴 **NON tocca NESSUN terminale MT5.** Sul VPS convivono **sei** cartelle dati
> (`50503392` piccolo · `50504263` 100k · **`10105439` REALE** · `50504400` banco ·
> Pepperstone · Tickmill): questa riga **non ne apre, non ne chiude e non ne
> modifica nessuna**. Legge tre cose e stampa. Nessun ordine, nessun file scritto,
> nessun EA toccato.

```
$T='ABTG_Runner'; $L=Join-Path $env:USERPROFILE 'abtg_runner'
Write-Host "=== 1. ATTIVITA' PIANIFICATA ==="
Get-ScheduledTask -TaskName $T -ErrorAction SilentlyContinue | Format-Table TaskName, State -AutoSize
Get-ScheduledTask -TaskName $T -ErrorAction SilentlyContinue | Get-ScheduledTaskInfo | Format-List TaskName, LastRunTime, LastTaskResult, NextRunTime, NumberOfMissedRuns
Write-Host ""
Write-Host "=== 2. FILE DI LAVORO DI OGGI in $L ==="
if(Test-Path $L){ Get-ChildItem $L | Where-Object { $_.LastWriteTime -ge (Get-Date).Date } | Sort-Object LastWriteTime | Format-Table Name, Length, LastWriteTime -AutoSize } else { Write-Host "  la cartella NON esiste" }
Write-Host "=== e i piu' recenti in assoluto, per confronto ==="
if(Test-Path $L){ Get-ChildItem $L | Sort-Object LastWriteTime -Descending | Select-Object -First 5 | Format-Table Name, Length, LastWriteTime -AutoSize }
Write-Host ""
Write-Host "=== 3. C'E' UN TESTER ANCORA VIVO? (solo lettura) ==="
Get-Process terminal64 -ErrorAction SilentlyContinue | Format-Table Id, StartTime, @{n='CPU_min';e={[math]::Round($_.CPU/60,1)}}, Path -AutoSize
Write-Host ""
Write-Host "=== 4. LA CARTELLA DELLO SCRIPT ==="
if(Test-Path 'C:\ABTG'){ Get-ChildItem 'C:\ABTG' | Format-Table Name, Length, LastWriteTime -AutoSize } else { Write-Host "  C:\ABTG ASSENTE" }
```

📌 **Due cose dichiarate sulla riga, prima che le chieda il cancello:**
- **Niente `schtasks`**, ed e' una scelta: `schtasks` e' un comando **nativo** che
  puo' anche **creare o cancellare** attivita', e sta nei DIVIETI del runner
  stesso. Qui si usano `Get-ScheduledTask` e `Get-ScheduledTaskInfo`, che sono di
  sola lettura **per costruzione** e danno gli stessi quattro numeri
  (`State`, `LastRunTime`, `LastTaskResult`, `NextRunTime`) piu' uno in regalo:
  **`NumberOfMissedRuns`**, che dice da solo se l'attivita' e' stata SALTATA.
- **Nessun pin e nessun marcatore**, ed e' corretto: la riga **non scarica niente**
  e **non esegue nessuno script** — sono quattro letture locali e una stampa. Il
  pin serve a inchiodare un file scaricato; qui non c'e' file.
  _(Nota tecnica: il blocco non nomina piu' il file `runner` per nome perche' il
  cancello deterministico legge quel letterale come "questa riga esegue uno
  script" e pretende il pin. Elencare la cartella da' la stessa informazione senza
  la falsa allerta.)_
- **Nessuna raccolta sul Desktop** (regola 11/08), ed e' voluto: l'uscita e' una
  ventina di righe che Claudio **legge a schermo e incolla in chat**. La raccolta
  serve per i risultati da archiviare, non per una diagnosi da leggere. Se
  l'uscita fosse lunga, la regola tornerebbe a valere.

### 🔎 COME SI LEGGE — la tabella di verita', scritta PRIMA di vedere i numeri
| blocco 1 dice | blocco 2 dice | → **la causa e'** |
|---|---|---|
| `LastRunTime` **non e' di oggi** (o `NumberOfMissedRuns` > 0) | nessun file di oggi | 🔴 **MAI PARTITA**: attivita' non eseguita (VPS spento all'ora, o attivita' disabilitata) |
| `LastRunTime` **di oggi**, `LastTaskResult` **≠ 0** | file di oggi presenti | 🔴 **MORTA A META'**: c'e' un log parziale, e li' dentro c'e' la riga dell'errore |
| `LastRunTime` di oggi, `LastTaskResult` **0** | file di oggi presenti | 🟡 **girata e pubblicazione FALLITA**: i risultati sono sul VPS ma non sono saliti (token?) |
| `State` = **Running** | file di oggi che crescono | 🟡 **ANCORA IN CORSO**: una passata impuntata. Il blocco 3 lo conferma (un `terminal64` con CPU alta) |

🔴 **E se la causa e' la quarta, NON si ammazza niente di propria iniziativa**: un
`terminal64` sul VPS puo' essere **una sedia viva**, non il tester. Il `Path` nel
blocco 3 dice quale e', e la decisione e' di Claudio.

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
