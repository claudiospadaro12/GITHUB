# 🛑 DUE RIGHE — SPEGNERE LA CORSA NOTTURNA DELLE 03:30 SUL VPS

> data: 2026-09-21 · pin `77121d37` · marcatore `MARCATORE_SOSPENDI_RUNNER_NOTTURNO_v1`
> referto: `report/IL_RUNNER_DELLE_0330_2026-09-21.md`
> attività bersaglio: **`ABTG_Runner`** — registrata da `backtest_pipeline/runner_abtg.ps1`
> r.653 (`schtasks /Create /TN ABTG_Runner /SC DAILY /ST 03:30`), azione
> `powershell -NoProfile -ExecutionPolicy Bypass -File C:\ABTG\runner_abtg.ps1`.

## ⏰ Perché è urgente stasera
Stamattina alle ~09:29 il VPS si è inchiodato con lo Strategy Tester a tick reali
acceso sulla stessa macchina dove operavano le **sei sedie della challenge FTMO**.
La regola è firmata (i round girano sul PC di backtest), **ma la regola non spegne
un'attività pianificata**: finché `ABTG_Runner` è abilitata, alle **03:30** il VPS
riapre la coda da solo.

🕐 **Quel 03:30 è ora di Windows sul VPS, cioè ora ITALIANA** (= 02:30 ora server BCM).
Non è un orario di sessione: è l'orologio della macchina.

🔥 **E la coda non è vuota.** Contate adesso su `backtest_pipeline/coda/CODA.txt`
(righe non commentate): **127 attive**, di cui **115 in corsia ROUND**, di cui
🔴 **82 con `-Modello 4`, cioè «Ogni tick basato su tick reali»** — lo stesso modello
che stamattina ha inchiodato la macchina. Il runner legge la coda dal branch `lavoro`
in HEAD (r.722) e la esegue riga per riga (r.774): la memoria di «questa è già girata»
è il commento `#` messo a mano, non un registro. Senza il gesto di stasera, **quelle
82 ripartono**.

---

# 1️⃣ PASSO 1 — LA DIAGNOSI (non cambia niente)

## 🖥️ **BERSAGLIO: una finestra PowerShell sul VPS.** Nessun MT5 da aprire.

🔴 **Che cosa NON tocca.** Questa riga parla **solo con l'Utilità di pianificazione
di Windows**. Non apre, non chiude e non modifica nessuno dei terminali che
convivono sul VPS — li elenco apposta per escluderli: il conto **50503392** nella
cartella programma di BCM Markets, il **50504263** nella cartella con il suffisso
V3, il conto **REALE** in `C:\` sotto BCM, il banco **50504400** in
`C:\MT5_Backtest`, Pepperstone, Tickmill, e soprattutto **`541452707` in `C:\FTMO`
che in questo momento sta operando la challenge**. Nessun processo viene chiuso.
Nessuna cartella dati viene letta o scritta.

🟢 Non serve l'amministratore per questa: legge e basta.

```powershell
& { $ErrorActionPreference='Continue'; $INV=[System.Globalization.CultureInfo]::InvariantCulture; Write-Host ('ORA LOCALE DI QUESTA MACCHINA: ' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss',$INV)) -ForegroundColor Cyan; $attese=@('ABTG_Runner','ABTG_AggiornaNews','ABTG_PubblicaTrades','ABTG_ScaricaPagella','ABTG_ArchiviaTestDesktop','ReportMercatoGiornaliero','ReportSettimanaleTrading'); $tutte=@(Get-ScheduledTask -ErrorAction SilentlyContinue); Write-Host ('attivita pianificate viste in tutto: ' + $tutte.Count); $nostre=@($tutte | Where-Object { ($attese -contains $_.TaskName) -or ($_.TaskName -like '*ABTG*') -or ($_.TaskName -like '*Report*') -or (((@($_.Actions) | ForEach-Object { [string]$_.Execute + ' ' + [string]$_.Arguments }) -join ' ') -match 'runner|ABTG|coda') }); foreach($t in $nostre){ $s=[string]$t.State; Write-Host ('--- ' + $t.TaskName) -ForegroundColor White; Write-Host ('    cartella : ' + $t.TaskPath); Write-Host ('    stato    : ' + $s) -ForegroundColor $(if($s -eq 'Disabled'){'Green'}else{'Yellow'}); foreach($tr in @($t.Triggers)){ Write-Host ('    trigger  : inizio=' + [string]$tr.StartBoundary + '  attivo=' + [string]$tr.Enabled) }; foreach($a in @($t.Actions)){ Write-Host ('    ESEGUE   : ' + [string]$a.Execute + ' ' + [string]$a.Arguments) -ForegroundColor Yellow }; $i=Get-ScheduledTaskInfo -TaskName $t.TaskName -TaskPath $t.TaskPath -ErrorAction SilentlyContinue; if($i){ Write-Host ('    ultima   : ' + [string]$i.LastRunTime + '   esito=' + [string]$i.LastTaskResult + ' (0=bene)'); Write-Host ('    PROSSIMA : ' + [string]$i.NextRunTime) -ForegroundColor Magenta } }; foreach($a in $attese){ if(@($nostre | Where-Object { $_.TaskName -eq $a }).Count -eq 0){ Write-Host ('ATTESA MA NON TROVATA: ' + $a) -ForegroundColor Yellow } }; Write-Host 'DA QUALE PERCORSO GIRA (copie del runner su disco):' -ForegroundColor Cyan; foreach($r in @('C:\ABTG', ($env:USERPROFILE + '\Desktop'))){ if(Test-Path -LiteralPath $r){ foreach($f in @(Get-ChildItem -LiteralPath $r -Filter 'runner_abtg*' -Recurse -ErrorAction SilentlyContinue)){ Write-Host ('    ' + $f.FullName + '   byte=' + $f.Length + '   modificato=' + $f.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss',$INV)) } } }; Write-Host 'FINE: questa riga ha solo LETTO. Niente e stato cambiato, nessun terminale toccato.' -ForegroundColor Green }
```

### 👀 Che cosa si guarda nell'output, in quest'ordine
| riga | che cosa dice |
|---|---|
| `stato` di **`ABTG_Runner`** | `Ready` = **accesa, stanotte parte**. `Disabled` = già spenta. `Running` = **sta girando adesso** |
| `PROSSIMA` | la data/ora della prossima corsa. È il numero che deve sparire dopo il passo 2 |
| `ESEGUE` / argomenti | **da quale percorso** parte lo script. Atteso: `C:\ABTG\runner_abtg.ps1` |
| `DA QUALE PERCORSO GIRA` | se compare una copia sul **Desktop**, quella arriva da uno zip di un branch vecchio: è la trappola già pagata il 12/09 con l'attività delle 07:20 |
| `ATTESA MA NON TROVATA` | attività di casa che su questa macchina non esistono — non è un errore, è una foto |

🔎 La riga cattura anche un'attività **con un nome diverso dal nostro**, se la sua
azione nomina `runner`, `ABTG` o `coda`: così un runner ribattezzato non resta
invisibile.

---

# 2️⃣ PASSO 2 — LA SOSPENSIONE ⏸️ (solo dopo aver letto il passo 1)

## 🖥️ **BERSAGLIO: la stessa finestra PowerShell sul VPS.**

🔴 **Che cosa NON tocca**: identico al passo 1 — **nessun terminale MT5 viene
chiuso, aperto o modificato**, e in particolare **`541452707` (`C:\FTMO`) resta
esattamente com'è, con le sedie attaccate e `Algo Trading` verde**. Lo script
*conta* i processi dei terminali prima e dopo e stampa i due numeri: se sono
uguali, il "non ho toccato niente" è un fatto misurato.

🔑 **Può servire PowerShell da amministratore** (tasto destro → *Esegui come
amministratore*): se l'attività è stata registrata da un altro utente, Windows
rifiuta. In quel caso la riga **te lo dice e non lascia mezzo lavoro fatto**.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; $pin='77121d37de7d1cd097a26c50c2fdae9decaa8770'; $p="$env:USERPROFILE\SOSPENDI_RUNNER_NOTTURNO.ps1"; Remove-Item $p -EA SilentlyContinue; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/SOSPENDI_RUNNER_NOTTURNO.ps1" -OutFile $p; if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_SOSPENDI_RUNNER_NOTTURNO_v1' -Quiet)){ throw 'SCRIPT VECCHIO: manca il marcatore MARCATORE_SOSPENDI_RUNNER_NOTTURNO_v1.' }; $ErrorActionPreference='Continue'; $global:LASTEXITCODE=0; & $p; if($LASTEXITCODE -eq 0){ Write-Host 'FATTO: la corsa notturna e SOSPESA, ed e stato verificato rileggendo l attivita. Manda lo zip dal Desktop.' -ForegroundColor Green } else { Write-Host ('NON RIUSCITO (uscita ' + $LASTEXITCODE + '): sopra ce scritto il perche. NON dare per spenta la corsa: rileggi il passo 1.') -ForegroundColor Red } }
```

### ✅ Come si sa che ha funzionato davvero
Non dal fatto che «non ha dato errori». Lo script **rilegge l'attività da zero**
dopo averla toccata e pretende di trovarla in uno stato preciso:

| stampa | significato |
|---|---|
| `stato DOPO : Disabled` + `prossima corsa prevista: nessuna` | 🟢 **spenta davvero** |
| `stato DOPO` diverso da `Disabled` | 🔴 **uscita 1**: il comando può aver detto di sì senza cambiare niente. Non è spenta |
| `L'attività 'ABTG_Runner' NON esiste` | 🟡 **uscita 1, niente toccato**: o non è mai stata installata qui, o ha un altro nome (lo vedi dal passo 1) |
| `processi dei terminali PRIMA/DOPO` uguali | 🟢 nessun terminale chiuso o avviato |

## 📦 LA RACCOLTA (già dentro lo script)
Sul **Desktop del VPS**: cartella `SOSPENDI_RUNNER_<AAAAMMGG_HHMMSS>\` con dentro
**un** file `SOSPENDI_RUNNER_<...>_referto.txt`, e accanto lo **zip** omonimo.
Il referto contiene tutto l'output, foto prima e foto dopo comprese.

---

# 3️⃣ LA RIGA PER RIACCENDERLA — a challenge finita 🔁

⚠️ **Non si lancia adesso.** Sta qui perché la sospensione sia reversibile per
iscritto e non per memoria. Stesso bersaglio: **finestra PowerShell sul VPS**,
nessun terminale toccato.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; $pin='77121d37de7d1cd097a26c50c2fdae9decaa8770'; $p="$env:USERPROFILE\SOSPENDI_RUNNER_NOTTURNO.ps1"; Remove-Item $p -EA SilentlyContinue; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/SOSPENDI_RUNNER_NOTTURNO.ps1" -OutFile $p; if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_SOSPENDI_RUNNER_NOTTURNO_v1' -Quiet)){ throw 'SCRIPT VECCHIO: manca il marcatore MARCATORE_SOSPENDI_RUNNER_NOTTURNO_v1.' }; $ErrorActionPreference='Continue'; $global:LASTEXITCODE=0; & $p -Riaccendi; if($LASTEXITCODE -eq 0){ Write-Host 'FATTO: la corsa notturna e di nuovo ATTIVA. Manda lo zip dal Desktop.' -ForegroundColor Green } else { Write-Host ('NON RIUSCITO (uscita ' + $LASTEXITCODE + '): sopra ce scritto il perche.') -ForegroundColor Red } }
```

---

# 🚫 QUELLO CHE QUESTE RIGHE **NON** FANNO — e va saputo

1. **Non fermano una corsa già in esecuzione.** `Disable` blocca le corse *future*.
   Se il passo 1 dice `Running`, lo script lo scrive in rosso e **non ammazza
   niente**: quella decisione si prende a occhi aperti (e il pronto soccorso in
   `CLAUDE.md` dice di chiudere **solo** `metatester64.exe`, mai i terminali).
2. **Non cancellano l'attività.** Nessun `Unregister-ScheduledTask`, nessun
   `schtasks /Delete`: la registrazione resta, e la riga 3 la riaccende.
3. **Non spengono il terminale banco `50504400`.** La regola firmata dice che
   resta installato ma **spento** mentre la challenge opera: quello è un gesto
   a mano dentro Windows, non è questa riga.
4. **Non toccano le altre attività di casa.** Restano accese — e devono: la
   pagella serale, la pubblicazione dei trade e l'aggiornamento news **leggono**
   e non consumano CPU in modo apprezzabile. Il passo 2 le **elenca con il loro
   stato**, così si vede cosa gira stanotte invece di sperarlo.
5. 🔴 **E la cosa che può disfare tutto senza dirlo**: `runner_abtg.ps1 -Installa`
   fa `schtasks /Delete` **e poi** `/Create` (r.677-678), cioè **ricrea l'attività
   da zero, ABILITATA**. Finché la challenge è viva, `-Installa` **non si lancia**.
   Verificato che è l'unico modo in cui la sospensione può tornare indietro da
   sola: il runner non si re-registra e non si ri-abilita quando gira.

---

## ✏️ RI-PINNATA IL 22/09 SERA — e la ragione conta

Il pin originale `83664b6e` puntava a una versione dello script che stampava
*«l'attivita' e' DISABILITATA e non ha piu' una prossima corsa»*. 🔴 **Quella frase era
falsa**: Windows continua a mostrare un'ora di partenza **anche su un'attivita'
disabilitata**, e chi la legge pensa che non sia servito a niente.

🟢 La versione su `lavoro` lo dice giusto (*«quella e' memoria di Windows, non un
impegno: il campo che comanda e' lo STATO»*), ma il pin vecchio **non la conteneva**:
`git rev-parse` al pin dava un blob **diverso** da quello su disco. Ri-pinnata a
`77121d37`, dove blob al pin == blob su disco.

🔎 **E le due verifiche che contano, fatte prima di consegnare:**
- `Unregister-ScheduledTask` e `schtasks` compaiono **solo nei COMMENTI** (r.14, 20, 21),
  che dichiarano di NON usarli. L'unica azione e' **r.177 `Disable-ScheduledTask`**:
  🟢 **reversibile**, la registrazione resta.
- Cancello sulle due righe: **11 PASSATI**, `nessun difetto meccanico`, sintassi **0
  errori**, **0 binding rotti**, raw al pin nuovo **200**.
