# 💸 SPREAD ALL'APERTURA SU FTMO — **la riga di lunedì 21/09/2026**

## 🖥️ BERSAGLIO: **finestra PowerShell sul VPS**

🔴 **E questa riga NON apre e NON tocca nessun MT5.** Legge e basta, da **UNA
sola** delle sei cartelle dati che convivono sul VPS: quella del terminale
**FTMO `541452707`** (`C:\FTMO`). **Non tocca** il piccolo `50503392`, **non
tocca** il 100k `50504263`, **non tocca** il banco `50504400`, **non tocca**
Pepperstone, **non tocca** Tickmill, e 🔴 **NON PUO' toccare il REALE
`10105439`**: il conto reale non e' un bersaglio ammesso nemmeno scrivendolo
a mano — `[ValidateSet("piccolo","ftmo")]` chiude la porta prima che il corpo
dello script giri (provato eseguendo).

**MT5 puo' e DEVE restare aperto**: la flotta non si ferma, e il logger
continua ad accumulare per conto suo. La riga si puo' lanciare **quante volte
si vuole**.

---

## ⏰ QUANDO LANCIARLA — due volte, e il perche' e' un numero

| giro | ora italiana | cosa cattura | ora SERVER FTMO |
|---|---|---|---|
| **1° — apertura DAX** | **~09:30** | l'apertura europea su `GER40.cash` | 10:00 (FTMO = UTC+3 = Italia +1) |
| **2° — apertura USA** | **~16:00** | l'apertura americana su `US30.cash` / `US100.cash` | 16:30 |

🟢 **Il secondo giro contiene anche il primo** (il logger accumula, non
azzera): se ne puoi lanciare uno solo, lancia **quello delle 16:00**.

---

## 🎯 COSA DECIDE QUESTO NUMERO, detto prima di leggerlo

Chiude la **classe 496**, che oggi e' un buco dichiarato: la frontiera del
costo `stop >= 40 x spread` poggia su **UNA lettura di tick all'ora piu'
calma**. Con mediana e P95 **ora per ora** si decide `InpMinStopPts` con un
fatto invece che con una convenzione.

📏 **Il metro di confronto, gia' misurato dal prevolo del 20/09**
(`backtest_pipeline/risultati_prove/PREVOLO_FTMO_specifiche_2026-09-20.csv`,
letto alle 17:08, **mercati chiusi**): `GER40.cash` **143 punti** ·
`US30.cash` **263** · `US100.cash` **153** · `XAUUSD` **47**.
🔴 **Quelli sono spread a mercato CHIUSO**: e' l'ipotesi alternativa da
battere. Se all'apertura il P95 ci somiglia, il prevolo vale; **se e' il
doppio, il numero che paghiamo e' questo.**

---

## 📌 IL PIN E IL MARCATORE

- pin: **`23aea54415454507b4af7e748a2740db837ca918`**
- marcatore preteso: **`MARCATORE_RIGA_SPREADLOGGER_RACCOLTA_v5`**
- prefisso dei file: **`ABTG_SpreadLogger_FTMO`** (e' quello che dice
  `mql5/Presets/FTMO/ABTG_SpreadLogger_FTMO.set`, riga `InpPrefissoFile`)

---

## ▶️ LA RIGA — incollala nella finestra PowerShell del VPS

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    $pin='23aea54415454507b4af7e748a2740db837ca918'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_SPREADLOGGER_RACCOLTA.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SPREADLOGGER_RACCOLTA.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_SPREADLOGGER_RACCOLTA_v5' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Bersaglio ftmo -Prefisso 'ABTG_SpreadLogger_FTMO'; $rc=$LASTEXITCODE;
    $d=$null; foreach($c in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if((-not $d) -and $c -and (Test-Path -LiteralPath $c)){ $d=$c } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'SPREADLOGGER_RACCOLTA_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    if($z.Count -eq 0){ throw 'NESSUNO ZIP SPREADLOGGER_RACCOLTA_ DI ADESSO SUL DESKTOP: mandami quello che vedi qui sopra, va bene uguale.' };
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): NON e'' un fallimento, fa fede il REFERTO nello zip.' -ForegroundColor Yellow };
    if(($rc -is [int]) -and ($rc -ne 0)){ Write-Host 'GIRO CON PROBLEMI: lo zip ESISTE lo stesso, mandalo.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan }
```

### 🩹 SE SI FERMA dicendo «NON SO DA QUALE CARTELLA DATI RACCOGLIERE»
Stampa **l'elenco delle cartelle guardate**: mandamelo cosi' com'e'. Oppure,
se vuoi chiudere subito, rilancia **la stessa riga** aggiungendo la cartella
dati di FTMO dopo `-Prefisso 'ABTG_SpreadLogger_FTMO'`:

```
 -CartellaDati "$env:APPDATA\MetaQuotes\Terminal\46C9F8E9FF0C747B2B5E09BCC13D5237"
```

🟢 **La manopola non salta i controlli**: pretende comunque un **fatto
positivo** che quella cartella sia di FTMO (il file di stato del logger, il
login `541452707` nei log, oppure `origin.txt`/percorso che nominano `FTMO`).
Se non ce n'e' nessuno, si ferma lo stesso.

---

## 🧪 LE PROVE GIA' FATTE — eseguite, non ragionate

Su **cartelle dati finte** (piccolo / FTMO / REALE) costruite apposta:

| prova | atteso | esito |
|---|---|---|
| `-Bersaglio ftmo` sulla cartella FTMO | SCELTA | 🟢 scelta, criterio: *login 541452707 nei log + origin.txt punta a FTMO* |
| `-Bersaglio ftmo` sulla cartella del **REALE** | RIFIUTATA | 🟢 *«E' UN TERMINALE FUORI PERIMETRO»* |
| `-Bersaglio ftmo` sulla cartella del **piccolo** | RIFIUTATA | 🟢 *«nessun fatto POSITIVO che sia la cartella del FTMO»* |
| `-Bersaglio piccolo` sulla cartella del piccolo | SCELTA (nessuna regressione) | 🟢 scelta |
| `-Bersaglio piccolo` sulla cartella del **REALE** | RIFIUTATA | 🟢 rifiutata |
| `-Bersaglio reale` | rifiutato **prima** di girare | 🟢 bloccato dal `ValidateSet` |

Piu': **parse PowerShell 0 errori**, **ASCII puro** (0 byte fuori range, regola
del 17/08).

---

## 🔒 COSA QUESTA RIGA NON PUO' FARE
- **non scrive niente dentro `MetaQuotes\Terminal`**: copia fuori e lavora in
  `%USERPROFILE%\abtg_spreadlogger_raccolta` e sul Desktop;
- **non compila**, **non attacca EA**, **non ferma processi**;
- **non tocca nessun parametro, nessuna taglia, nessun ordine**.
