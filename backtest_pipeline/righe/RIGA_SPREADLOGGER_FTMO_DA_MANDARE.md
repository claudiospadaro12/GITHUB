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

## ⏰ QUANDO LANCIARLA — due volte, e le due colonne sono **OROLOGI DIVERSI**

| giro | QUANDO la lanci (ora ITALIANA, l'orologio di Windows) | che cosa cattura | quale riga guardare nel referto (ora SERVER FTMO) |
|---|---|---|---|
| **1° — apertura DAX** | **~09:30 IT** | l'apertura europea su `GER40.cash`, che avviene alle **09:00 IT** | la riga **`10`** |
| **2° — apertura USA** | **~16:00 IT** | l'apertura americana su `US30.cash` / `US100.cash`, che avviene alle **15:30 IT** | la riga **`16`** |

🔴 **Le due colonne NON sono una conversione l'una dell'altra**: a sinistra c'e' quando
premi invio, a destra c'e' l'ora con cui l'EA nomina i secchi.
🔴 **FTMO = UTC+3, Italia = UTC+2, quindi ora server = ora italiana PIU' 1** — misurato il
20/09 (`PREVOLO_FTMO_specifiche_2026-09-20.csv`: `DeltaServerGMT_hhmm +03:00` contro
`DeltaLocalePC_UTC_hhmm +02:00`), **non assunto**.
🔴 **E NON vale la regola di casa BCM, che e' l'OPPOSTO** (server = italiana meno 1): su
FTMO si **SOMMA** un'ora, non si sottrae. Applicarla al contrario sbaglia di **due ore** —
ed e' esattamente il difetto che il cancello ha trovato dentro lo script, e che nella v6
e' stato riparato: adesso il referto scrive da solo *«ore in ORA SERVER FTMO (= ora
italiana PIU' 1)»* e le fasce si chiamano `cash EUROPA 10-17 srv FTMO` e
`cash USA 16-22 srv FTMO`.

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

🔴 **E lunedi' la classe 496 NON si chiude del tutto — lo dico PRIMA dei numeri, non dopo.**
Il referto conta le **GIORNATE distinte** (colonna `GG`) e marca **SOTTILE** ogni riga con
`GG < 5`. Lunedi' `GG` varra' **1 su tutte le righe**: quello che leggiamo e' **una giornata
sola**, cioe' un ORDINE DI GRANDEZZA per `InpMinStopPts`, non una statistica. La classe 496
si chiude **venerdi' 25/09**, con cinque giornate.
🟢 **Quello che lunedi' decide davvero, ed e' gia' tanto**: se il P95 all'apertura somiglia
ai numeri del prevolo a mercato chiuso, il prevolo regge e si va avanti; **se e' il doppio,
`InpMinStopPts` si rifa' subito e non si aspetta venerdi'.**

---

## 📌 IL PIN E IL MARCATORE

- pin: **`582341cd19e365259494e38e17701d22c1d674a8`**
- marcatore preteso: **`MARCATORE_RIGA_SPREADLOGGER_RACCOLTA_v6`**
- prefisso dei file: **`ABTG_SpreadLogger_FTMO`** (e' quello che dice
  `mql5/Presets/FTMO/ABTG_SpreadLogger_FTMO.set`, riga `InpPrefissoFile`)

---

## ▶️ LA RIGA — incollala nella finestra PowerShell del VPS

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    $pin='582341cd19e365259494e38e17701d22c1d674a8'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_SPREADLOGGER_RACCOLTA.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SPREADLOGGER_RACCOLTA.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_SPREADLOGGER_RACCOLTA_v6' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
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

📌 **L'hash e' verificato in repo, non a memoria**: `report/STASERA.md` r.18 (colonna
*«com'e' ADESSO, misurato»*) e `report/RINOMINA_CLAU12_2026-09-20.md` r.111.

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
| file di stato col conto **10105439** dentro, in modo ftmo | ACCUSA | 🟢 `PROBLEMI: 1` — *«IL FILE DI STATO E' DI UN ALTRO CONTO»* |
| file di stato col conto giusto `541452707` | nessuna accusa | 🟢 silenzio |
| referto in modo **ftmo** | fuso e fasce FTMO | 🟢 *«ora italiana PIU' 1»*, `cash EUROPA 10-17 srv FTMO` |
| referto in modo **piccolo** | fuso e fasce BCM, invariati | 🟢 *«ora italiana MENO 1»*, `cash EUROPA 8-15 srv BCM` |

🔴 **E il cancello di giudizio le ha rifatte per conto suo, su un albero finto di CINQUE
cartelle**, compreso il caso peggiore: il terminale del **REALE «muto»** (nessun
`origin.txt`, nessun login riconoscibile — la grafia che il 12/09 passava). **12 prove su
12 corrette**, il REALE muto rifiutato con *«nessun fatto POSITIVO»*.

Piu': **parse PowerShell 0 errori**, **ASCII puro** (0 byte fuori range, regola
del 17/08).

---

## 🔒 COSA QUESTA RIGA NON PUO' FARE
- **non scrive niente dentro `MetaQuotes\Terminal`**: copia fuori e lavora in
  `%USERPROFILE%\abtg_spreadlogger_raccolta` e sul Desktop;
- **non compila**, **non attacca EA**, **non ferma processi**;
- **non tocca nessun parametro, nessuna taglia, nessun ordine**.
