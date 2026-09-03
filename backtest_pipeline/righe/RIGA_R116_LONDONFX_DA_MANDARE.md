# 🎯 R116 — LONDONFX A **TICK REALI**: **LA RIGA DA MANDARE** (EURUSD + GBPUSD, un simbolo per giro)

**Che cos'è:** la **prima misura di MERITO** del **primo superstite della missione
frequenza**. `ABTG_LondonFx` v1.00 (**EA NUOVO, MAI COMPILATO** — la compilazione
avviene qui e **se fallisce, QUELLO è il risultato del passo**) gira a **Modello 4,
tick reali**, su **M15**, con **UN contenitore e TRE motori a interruttore**:
motore **1** = canale nudo (controllo), motore **2** = canale + RSI (**la BASELINE, l'unico
promuovibile**), motore **3** = allineamento 5 medie (secondo controllo). Fra una cella e
l'altra cambia **UNA riga sola** (`InpMotore`): è un'**ABLAZIONE**, non una griglia.
Criteri **FIRMATI** da Claudio il 03/09 ~09:45 (_"FIRMO TUTTO, ANCHE LA A SU F5"_):
`risultati_archivio/LONDONFX_TICK_CRITERI.md` + `report/FIRME_2026-09-03.md`.
Passo 0 già superato su entrambe le gambe: `REFERTO_SONDALONDONFX_2026-09-03.md`.

> 🔮 **La previsione, scritta PRIMA dei numeri (criteri §0.2): NO probabile.** La MAE
> mediana del passo 0 (11,8 pip) sta **sopra** lo stop della fonte (8,0 pip) e il
> costo è **da 1,7 a 3,3 volte l'edge richiesto**. Un NO qui è un verdetto **valido e
> pieno** — e ci lascia in mano lo **spread BCM di Londra**, che oggi non abbiamo.

## 🚦 LE DUE GAMBE — **DUE GIRI, uno per simbolo**, in quest'ordine

| Gamba | Simbolo | Blocchi | Stato |
|---|---|---|---|
| **LEAD** | **EURUSD** | **1️⃣** giro a vuoto → **2️⃣** corsa vera | 🟡 da fare |
| **GEMELLA** | **GBPUSD** | **3️⃣** giro a vuoto → **4️⃣** corsa vera | 🟡 da fare **dopo** la lead |

Ogni giro = **12 passate a tick reali** (6 celle: 3 motori × 2 magic gemelli, × IS e OOS)
**+ 4 di FASE 2** (slippage 2/5 sul solo motore 2) **solo se** il motore 2 passa tutti i
cancelli A su quella gamba — lo decide **il driver, a macchina**, dal CSV OOS.

| voce | valore (FIRMATO, non scelto qui) |
|---|---|
| finestra | **2024.07.05** (pavimento **tick reali** forex BCM, misurato il 01/09) → **2026.06.30** |
| split | **40/60** come lo calcola il generico: **IS 2024.07.05 → 2025.04.21** · **OOS 2025.04.22 → 2026.06.30** |
| operazioni attese (regola A dell'Emendamento) | motore 2: **IS 540–680, OOS 810–1.030** (dalle frequenze misurate al passo 0; anche a conversione dimezzata IS 270+/OOS 400+) → **≥150 con margine doppio**. Motore 3: **mai contato**, se < 150 il suo confronto è **SOSPESO** |
| regime contenuto | **UN SOLO REGIME** (forex major 2024.07→2026.06; IS = dollaro forte fino a gen-2025 + inversione; OOS = da apr-2025 in poi). **Nessuna prova di regime → da qui NON esce una sedia** (F12) |
| modello / TF | **4 = tick REALI**, **M15** |
| ora | **8 ORA SERVER** (= ora italiana − 1 = Londra): sessione **08:00–16:00**, fine esclusa. **Congelata**, niente sweep |
| rischio | **0,65%** (taglia di campo), deposito **100.000** (taglia prop: DD letto contro il muro **senza scalature**) |
| geometria | **TP 15,0 / SL 8,0 pip su ENTRAMBE le gambe**, non adattata (su GBPUSD lo stop vale ~1 ATR: strettissimo, e resta) |
| F5 | soglia RSI short **20, simmetrica** (più permissiva del 10 dell'autore: se lo short passa e il long no, va scritto) |
| costo | `InpMaxSpread=0`: **lo spread si MISURA** all'ingresso (mediana + P95, chiude **H12** anche se il round boccia); `Spread=0` nell'.ini = corrente, **dichiarato** |
| magic | **774001 / 774002** (blocco 7740xx **vergine**, ri-verificato oggi: unica occorrenza = il default dell'EA) |

> ⚙️ **LE SCELTE CHE I CRITERI NON FISSAVANO — dichiarate (clausola severa):**
> **(a)** i **gemelli** sono un asse `InpMagic` nel prova principale (pattern di casa
> R103/R115/CRT): **3 coppie per finestra** invece delle "2 passate" dei criteri →
> **24 passate a tick** in tutto invece di 14, un vincolo in più, non in meno;
> **(b)** la **FASE 2** la decide **il driver** dal CSV OOS con le disuguaglianze
> ricopiate dai criteri, e la accoda nello stesso giro (`-SoloFase2` la forza: misura di
> fragilità, **non può promuovere**); **(c)** deposito **100.000**; **(d)** `Spread=0`
> agli atti; **(e)** il modello si verifica sull'**.ini VERO** (`gen_*.ini`) e sulla riga
> del Diario `ticks data begins from`, **non** sull'anteprima (che scrive `Model=4`
> hardcoded, classe 96) — il report `.htm` del tester **non è letto a macchina**;
> **(f)** 🔴 **l'EA v1.00 NON esporta il per-trade** (nessun `abtg_trades_*`): i punti
> **5.0.5** (prima data del per-trade) e **S4** (correlazione P&L giornalieri) dei
> criteri **non sono eseguibili** in questo giro. **Segnalato, non corretto** (gli
> `.mq5` non si toccano da una riga di lancio).

| | |
|---|---|
| **Driver** | `righe/RIGA_R116_LONDONFX.ps1` (marcatore `MARCATORE_RIGA_R116_LONDONFX_v1`, `-Pin` obbligatorio, `-Simbolo`) |
| **File prova** | `prove/LONDONFX_R116_TICK.txt` (principale, 3 motori × 2 magic) + `prove/LONDONFX_R116_FASE2_SLIPPAGE.txt` (slip 2/5, motore 2) |
| **Dove** | **PC di backtest**, non VPS. **MT5 e MetaEditor CHIUSI.** **Max 4 agenti locali e RAM pulita** (nota del 01/09: 8 agenti hanno saturato 16 GB) |
| **Quanto ci mette** | compilazione + 12 passate a tick reali su ~2 anni di M15 (+4 se fase 2) + 2–3 avvii del terminale = **20–60 minuti a gamba** [STIMA: nessuna corsa di casa a tick reali su 2 anni di forex è mai stata cronometrata; il numero vero lo dice questo giro]. Il giro a vuoto **compila** (è lì che un EA mai compilato può cadere) e finisce in **1–3 minuti** [STIMA] |

> 🧭 **L'OVERRIDE DI SIMBOLO, DICHIARATO.** `-Simbolo` (default **EURUSD**, il lead)
> con whitelist `EURUSD`/`GBPUSD`: USDJPY viene **fermato PRIMA** di scaricare qualunque
> cosa (l'EA rifiuterebbe di partire con `InpPipSize=0.0001`, ed è voluto). I due prova
> **restano dichiarati sul lead** (`@SIMBOLO EURUSD`) anche nella corsa GBPUSD e il
> driver **lo pretende**: il parametro `-Simbolo` del generico **vince** sulla direttiva
> (righe 303–305). Le etichette `R116_EUR` / `R116_GBP` entrano **nel nome dei CSV**,
> nella cartella e nello zip: le due gambe **non possono sovrascriversi**.

> 🧹 **COSA SCRIVE NEL TERMINALE, e come lo rimette (classe 116).** L'EA include
> `ABTG_PausaGuardian.mqh`: il driver **lo censisce dal sorgente**, lo scarica **al pin**,
> lo installa in `MQL5\Include` **con backup e sentinella**, compila con `metaeditor64`
> diretto (`.ex5` vecchio cancellato prima, log letto in qualunque codifica), e **a fine
> giro — su QUALUNQUE uscita — rimette l'include com'era**. L'EA `.mq5`/`.ex5` **resta**
> in `MQL5\Experts` (il tester lo richiede, come ogni EA della pipeline): il referto lo
> dice **con la foto prima/dopo**, non con una frase. `Tester\cache` svuotata (solo
> quella, mai `bases\ticks`).

## 📌 IL PIN — **`@@PIN@@`**

> 🔴 **IL PIN QUI SOPRA È UN SEGNAPOSTO E NON FUNZIONA.** Va sostituito col commit vero
> dopo il push (ricetta in fondo), e finché è così **LA RIGA NON PARTE**.

---

# 🟢 GAMBA LEAD — EURUSD

## 1️⃣ EURUSD — giro a vuoto (scarica, gatta, **COMPILA**, generico `-SoloControllo`: MT5 non gira)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='@@PIN@@'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_R116_LONDONFX.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R116_LONDONFX.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R116_LONDONFX_v1' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Simbolo EURUSD -SoloControllo; $rc=$LASTEXITCODE;
    $d=$null; foreach($k in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if((-not $d) -and $k -and (Test-Path $k)){ $d=$k } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'R116_LONDONFX_CONTROLLO_EURUSD_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP R116_LONDONFX_CONTROLLO_EURUSD_ DI ADESSO SUL DESKTOP: il controllo non e'' arrivato alla raccolta. Mandami quello che vedi qui sopra.' };
    $ko=(($rc -is [int]) -and ($rc -ne 0));
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): fa fede il REFERTO nello zip qui sotto.' -ForegroundColor Yellow };
    if($ko){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera. Mandami questo zip:' -ForegroundColor Red; Write-Host $z[0].FullName -ForegroundColor Yellow } else { Write-Host 'CONTROLLO OK (fa comunque fede il referto nello zip: compilazione: OK, celle 6 + 2): lancia il blocco 2.' -ForegroundColor Green } }
```

## 2️⃣ EURUSD — corsa vera (12 passate a tick reali + fase 2 se dovuta)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='@@PIN@@'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_R116_LONDONFX.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R116_LONDONFX.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R116_LONDONFX_v1' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Simbolo EURUSD; $rc=$LASTEXITCODE;
    $d=$null; foreach($k in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if((-not $d) -and $k -and (Test-Path $k)){ $d=$k } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'R116_LONDONFX_EURUSD_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP R116_LONDONFX_EURUSD_ DI ADESSO SUL DESKTOP: la corsa non e'' arrivata alla raccolta. Mandami quello che vedi qui sopra.' };
    $ko=(($rc -is [int]) -and ($rc -ne 0));
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): fa fede il REFERTO nello zip.' -ForegroundColor Yellow };
    if($ko){ Write-Host 'CORSA CON PROBLEMI: lo zip esiste lo stesso, mandalo -- il referto dice dove si e'' fermata.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan;
    $iv=[Globalization.CultureInfo]::InvariantCulture;
    Write-Host ('POI nel REFERTO_R116_LONDONFX_EURUSD.txt: riga modo: = CORSA, riga simbolo di questa corsa: = EURUSD, e riga data: = ORA DI AVVIO di questa corsa (circa ' + $t0.ToString('yyyy-MM-dd HH:mm',$iv) + '), NON l''ora attuale (' + (Get-Date).ToString('HH:mm',$iv) + '): il referto si timbra all''INIZIO e la corsa dura decine di minuti. La freschezza dello zip l''ha gia'' controllata a macchina la riga qui sopra.') -ForegroundColor Gray }
```

---

# 🟡 GAMBA GEMELLA — GBPUSD (**dopo** la lead: stesso prova, override dichiarato)

## 3️⃣ GBPUSD — giro a vuoto

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='@@PIN@@'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_R116_LONDONFX.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R116_LONDONFX.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R116_LONDONFX_v1' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Simbolo GBPUSD -SoloControllo; $rc=$LASTEXITCODE;
    $d=$null; foreach($k in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if((-not $d) -and $k -and (Test-Path $k)){ $d=$k } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'R116_LONDONFX_CONTROLLO_GBPUSD_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP R116_LONDONFX_CONTROLLO_GBPUSD_ DI ADESSO SUL DESKTOP: il controllo non e'' arrivato alla raccolta. Mandami quello che vedi qui sopra.' };
    $ko=(($rc -is [int]) -and ($rc -ne 0));
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): fa fede il REFERTO nello zip qui sotto.' -ForegroundColor Yellow };
    if($ko){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera. Mandami questo zip:' -ForegroundColor Red; Write-Host $z[0].FullName -ForegroundColor Yellow } else { Write-Host 'CONTROLLO OK (fa comunque fede il referto nello zip: simbolo di questa corsa: = GBPUSD OVERRIDE DICHIARATO): lancia il blocco 4.' -ForegroundColor Green } }
```

## 4️⃣ GBPUSD — corsa vera

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='@@PIN@@'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_R116_LONDONFX.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R116_LONDONFX.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R116_LONDONFX_v1' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Simbolo GBPUSD; $rc=$LASTEXITCODE;
    $d=$null; foreach($k in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if((-not $d) -and $k -and (Test-Path $k)){ $d=$k } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'R116_LONDONFX_GBPUSD_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP R116_LONDONFX_GBPUSD_ DI ADESSO SUL DESKTOP: la corsa non e'' arrivata alla raccolta. Mandami quello che vedi qui sopra.' };
    $ko=(($rc -is [int]) -and ($rc -ne 0));
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): fa fede il REFERTO nello zip.' -ForegroundColor Yellow };
    if($ko){ Write-Host 'CORSA CON PROBLEMI: lo zip esiste lo stesso, mandalo -- il referto dice dove si e'' fermata.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan;
    $iv=[Globalization.CultureInfo]::InvariantCulture;
    Write-Host ('POI nel REFERTO_R116_LONDONFX_GBPUSD.txt: riga modo: = CORSA, riga simbolo di questa corsa: = GBPUSD OVERRIDE DICHIARATO, e riga data: = ORA DI AVVIO di questa corsa (circa ' + $t0.ToString('yyyy-MM-dd HH:mm',$iv) + '), NON l''ora attuale (' + (Get-Date).ToString('HH:mm',$iv) + '): il referto si timbra all''INIZIO e la corsa dura decine di minuti. La freschezza dello zip l''ha gia'' controllata a macchina la riga qui sopra.') -ForegroundColor Gray }
```

---

## 5️⃣ (solo se serve) LA FASE 2 DA SOLA — `-SoloFase2`, **un simbolo per volta**

**Quando:** la corsa vera è finita, il referto dice che il motore 2 **passa tutti i cancelli
A**, ma la fase 2 accodata è morta a metà (o Claudio la vuole comunque come misura di
fragilità). **Non rifà le 12 passate**: gira le 4 di slippage 2/5 sul motore 2. Sostituire
`EURUSD` con `GBPUSD` per la gemella. ⚠️ **Non può promuovere niente**: è una sensibilità.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='@@PIN@@'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_R116_LONDONFX.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R116_LONDONFX.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R116_LONDONFX_v1' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Simbolo EURUSD -SoloFase2; $rc=$LASTEXITCODE;
    $d=$null; foreach($k in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop'))){ if((-not $d) -and $k -and (Test-Path $k)){ $d=$k } }; if(-not $d){ $d=$env:USERPROFILE };
    $z=@(Get-ChildItem (Join-Path $d 'R116_LONDONFX_FASE2_EURUSD_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 });
    if($z.Count -eq 0){ throw 'NESSUNO ZIP R116_LONDONFX_FASE2_EURUSD_ DI ADESSO SUL DESKTOP: la fase 2 non e'' arrivata alla raccolta. Mandami quello che vedi qui sopra.' };
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): fa fede il REFERTO nello zip.' -ForegroundColor Yellow };
    if(($rc -is [int]) -and ($rc -ne 0)){ Write-Host 'FASE 2 CON PROBLEMI: lo zip esiste lo stesso, mandalo.' -ForegroundColor Yellow };
    Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan }
```

## 📦 COSA TORNA
Zip sul Desktop **`R116_LONDONFX_EURUSD_...zip`** (poi `R116_LONDONFX_GBPUSD_...zip`) con:
`REFERTO_R116_LONDONFX_<SIMBOLO>.txt` + `COMPILAZIONE.log` (UTF-16, il log vero di
MetaEditor) + `COMPILAZIONE_leggibile.txt` + i **2 prova** + i **CSV OPTFRAME**
`ABTG_LondonFx_<SIMBOLO>_IS_R116_<PFX>.csv` e `_OOS_` (**6 righe l'uno** = 3 motori × 2
magic, **56 colonne nostre** — le 8 del canarino PRIME, poi il conto economico, l'anatomia,
l'eco dei fissi, l'autotest — **+ le 20 colonne di input** accodate dal tester) + gli
**`.ini VERI`** della corsa (`gen_*.ini`, con `Model=4`) + i **log del tester cresciuti**
durante il giro. Se la fase 2 è girata: anche `*_R116_<PFX>_SLIP.csv` (**2 righe l'uno**:
slip 2 e 5). **Niente per-trade** (l'EA v1.00 non lo esporta: segnalato).
⚠️ **Nessun suffisso `_ohlc`** nei nomi: è la marca del generico per i modelli non-tick,
e qui il modello è 4. Se un CSV lo porta, **non è di questo round**.

## 🔎 COME SI LEGGE — nell'ordine, e **i cancelli uno per uno**
🕐 **PRIMA DI TUTTO** apri il referto e controlla:
- **`data:`** = **l'ora in cui hai lanciato il blocco** (si timbra all'**AVVIO**; la corsa dura
  decine di minuti: **l'ora attuale non è il metro**). La riga te la stampa in console col
  valore atteso; la freschezza dello zip l'ha già controllata a macchina (`LastWriteTime -ge $t0`).
- **`modo:`** = **CORSA** (CONTROLLO = giro a vuoto, non è il risultato; FASE2 = blocco 5).
- **`simbolo di questa corsa:`** = `EURUSD, il LEAD` **oppure** `GBPUSD, OVERRIDE DICHIARATO`.
  Se nella gamba gemella c'è scritto EURUSD, **l'override non è passato**: si rilancia il blocco 4.
- **`compilazione:`** — **tre stati, tutti veri**: `OK (… KB …), errori 0` → si va avanti;
  `FALLITA (…)` → **QUELLO È IL RISULTATO DEL PASSO** (errori nelle prime 30 righe del
  log a schermo e nel log dentro lo zip; i fix tornano in `mql5/Experts/`, nessun numero
  esiste); `FALLITA -- METAEDITOR MUTO` → non è un verdetto sul codice (editor aperto,
  percorso, permessi): si ricontrolla e si rifà; `NON TENTATA` → un gate ha fermato prima
  (`!!! FERMATO:` in fondo).
- **identità**: `versione letta dal #property: 1.00`, `autotest dichiarato nel sorgente: 17
  blocchi / 112 casi`, `magic: InpMagic default 774001`, `hedge-safe (N1): 0 chiamate`,
  `include censiti: 2 (Trade/Trade.mqh, ABTG_PausaGuardian.mqh)`, `include al pin: bool
  ABTG_GuardiaIngresso( trovata 1 volta`.
- **`foto PRIMA/DOPO`**: `Include\ABTG_PausaGuardian.mqh → INVARIATO`; `Experts\.mq5` e
  `.ex5 → CAMBIATO` (atteso: sono l'EA compilato qui, che resta).
- **`cache tester: prima N file, dopo 0`** · **`celle: 6 a finestra … + 2 … FASE 2`** ·
  **`gemellaggio prova: VALIDO`** · **`Model letto: … Model=4`** (dall'.ini VERO) ·
  **`riga del Diario 'ticks data begins from'`** ricopiata (se `NON TROVATA`, la copertura
  tick va cercata a mano nel Diario: **"non l'ho letta" ≠ "i tick c'erano"**) · **`log del
  tester letti: N`** (un gate che non legge niente non è verde).

🧪 **POI LA SANITÀ (§5.0) — se cade una, il round NON si legge:**
`righe 6 (attese 6)` in IS **e** OOS · `gemelli: IDENTICI al centesimo su 3 coppie` ·
`Autotest Falliti 0`, `17 / 112` (sta nei PROBLEMI se no) · `Canarino Torna = 1` ·
`Notti Attraversate = 0` · nessun `eco … invece di …` nei PROBLEMI (= i pin sono passati:
ora 8, 8 ore, TP 15,0 / SL 8,0, slip 0, rischio 0,65, tetto 6, cap 2,0, RSI 80/20, pip 0,00010 e 10,00).

🐤 **POI IL CANARINO, PRIMA DEL CONTO ECONOMICO (§4.3)** — tabella per motore/finestra:
`Segnali Generati`, `Soppressi Posizione`, `Soppressi Tetto`, `Giorni col Tetto Colpito`
(**> 20% dei giorni = motore STROZZATO, confronto S1 contaminato — atteso sul motore 1**),
`Giorni fermati dal Cap`, `Trade chiusi dal Flat %` (**> 40% = il round misura l'OROLOGIO**),
**`Spread mediano` e `P95`** in pip (il numero che chiude **H12**, si archivia anche se
boccia tutto). Le dichiarazioni, se scattano, stanno nei **RILIEVI**.

📊 **POI IL CONTO ECONOMICO** (n IS e n OOS **accanto a ogni numero**, e per lato) e
**I VERDETTI PER MOTORE**, letti in OOS con le **fasce disgiunte** (§5.8):

| cancello | 🟢 PASSA | 🟠 NON PASSA (zona morta) | ⚫ BOCCIATA |
|---|---|---|---|
| **A1** `E In R` OOS | ≥ 0,075 | 0,050 ≤ E < 0,075 | < 0,050 |
| **A2** `PF` OOS | ≥ 1,15 | 1,10 ≤ PF < 1,15 | < 1,10 |
| **A3** segno IS/OOS coerente **e** PF IS > 1,00 | sì | — | IS negativo |
| **A4** `Equity DD %` OOS | ≤ 8,0 | 8,0 < DD ≤ 10,0 | > 10,0 **per RISCHIO, a qualunque n** |
| **A5** `Peggior Giornata %` OOS | ≥ −4,0 | −5,0 ≤ PG < −4,0 | < −5,0 **per RISCHIO, a qualunque n** |
| **A6** `n` IS e OOS | ≥ 150 | 30–149 **merito sospeso** | < 30 = **non misurabile** |

Il driver scrive per ogni motore **una riga di esito** (`PASSA TUTTI I CANCELLI A` /
`NON PASSA` / `BOCCIATA SECCA` / `BOCCIATA PER RISCHIO` / `MERITO SOSPESO` /
`NON MISURABILE`) **e sotto i sei numeri con la loro fascia**. Regole ferree:
**promuovibile SOLO il motore 2, gamba per gamba** · un motore 1 o 3 che "passa" **si
scrive e basta** (è un controllo) · **vietato nominare "la cella migliore"** · **A5 passa
anche grazie al cap del 2% che sta nella fonte** (non è merito del segnale); se A5 fallisce
lo stesso, il cap non funziona come crediamo → si indaga il **contenitore**.

🧬 **POI L'ABLAZIONE S1/S2/S3** (§3.2, OOS): `max(E) − min(E) ≤ 0,05R` **e** stesso segno
**e** n ≥ 150 su tutti e tre → *"i tre vanno uguale: **il contenitore è l'edge**, il
segnale non conta, NESSUNA sedia sul segnale"*. Motore 2 che stacca entrambi di > 0,05R →
il segnale guadagna il suo posto. Motore 1 il migliore → lezione di casa (filtro
appiccicato = 0/5), **non si promuove il nudo**. Un motore sotto 150 → confronto **SOSPESO**.

🪓 **POI LA FASE 2** (solo se il motore 2 passa A): **il verdetto si legge a 5 punti**
(`E In R` della riga `slip5` OOS ≥ 0,075R → *regge*; sotto → *"vive solo a taglia
piccola"*, **NON si propone**). Stato `NON DOVUTA` = il motore 2 non passa: **nessuna
passata spesa, ed è giusto così**.

🛑 **E COSA NON SI PUÒ DIRE (§5.10, ricopiato nel referto):** "regge nel tempo" (un solo
regime), "il DD sarà quello", "il forex BCM ha questi spread" in generale, promuovere i
controlli, "basta cambiare l'ora", "su GBPUSD serve uno stop più largo", passare al forward
senza la **prova di rischio sul vecchio** (round separato R-C) e il contratto della sedia.
**Da questo round NON esce una sedia.** E la previsione (§0.2, NO probabile) va giudicata:
*avevo detto NO — cos'è successo?*

## 🚦 LE USCITE, UNA PER UNA (**c'è lo zip? sì o no**)
| Cosa succede | Zip sul Desktop | Cosa mandare |
|---|---|---|
| **MT5 o MetaEditor aperto** (il blocco si ferma **prima** di scaricare) | ❌ **NO** | il messaggio rosso; chiudili e rilancia |
| **`SCRIPT VECCHIO`** o `irm` fallito (404 su un pin appena creato: cache raw ~5 min) | ❌ **NO** | il messaggio; aspetta 5 minuti e rilancia **la stessa riga** |
| **Guardie del driver**: `-Pin` mancante/corto, `-Simbolo` fuori whitelist (USDJPY), MT5 riaperto nel frattempo | ✅ **SÌ** (`!!! FERMATO:` nel referto, tutto `NON TENTATA`) | lo zip |
| **Scarico al pin fallito** (404 sul generico/prova/EA/include) | ✅ **SÌ** | lo zip; se è la cache raw, rilancia la stessa riga dopo 5 min |
| **Gate sul sorgente** (versione ≠ 1.00, define ≠ 17/112, magic, hedge, include nuovo) o **sui prova** (direttive, assi, celle, fissi, gemellaggio) | ✅ **SÌ** | lo zip: il motivo è in `!!! FERMATO:` — non si aggiusta a mano, si torna in chat |
| **Terminale non unico** (`NON SO QUALE TERMINALE USARE`, elenco stampato) | ✅ **SÌ** | rilancia lo stesso blocco con `& $p -Pin $pin -Simbolo … -Terminale '<cartella dell'installazione>'` |
| **Compilazione FALLITA** (o MUTA) | ✅ **SÌ** | lo zip: **è il risultato del passo** (include già rimesso a posto: foto DOPO) |
| **Corsa con PROBLEMI** (CSV stantio/mancante, righe ≠ 6, gemelli divergenti, autotest, eco dei pin, `no memory`) | ✅ **SÌ** (esito `COMPLETATO CON PROBLEMI`, exit 1) | lo zip: il referto dice quale sanità è caduta |
| **Corsa OK** (con o senza fase 2) | ✅ **SÌ** | lo zip |
_(I rami "guardie", "scarico fallito", "-SoloControllo/-SoloFase2 insieme" sono stati
**eseguiti** su banco con `pwsh` prima dell'invio e arrivano tutti allo zip — il primo
giro NON ci arrivava (`$logC` non definito nel giro morto prima della compilazione: preso
e corretto **eseguendo**, classe 94-bis). I rami dal terminale in poi non sono eseguibili
qui (niente MT5): sono coperti dalla struttura try/raccolta-sempre, e vanno nel NON COPERTO.)_

## 🟡 SE LA RIGA SI FERMA SU **«NON SO QUALE TERMINALE USARE»**
È la regola di casa (**classe 115**). Il selettore è quello della sonda del passo 0
(`BCM Markets MT5 Terminal`, non `-V3`, girato pulito il 03/09 sulla stessa macchina); se
trova zero o due candidate, **stampa l'elenco** delle installazioni con `terminal64.exe`.
Copia la cartella di quella di backtest e rilancia **lo stesso blocco** aggiungendo al
driver `-Terminale '<cartella incollata>'` (il driver la passa al generico come
`-Terminal`/`-MetaEditor`).

## 🔴 AVVISI ATTESI (nessuno è un guasto)
1. **Giallo del generico** _"Questo EA usa PERIOD_CURRENT e non ha un input InpTF: il
   timeframe operativo E' il Period del tester: adesso e' M15"_ — **corretto e voluto**.
2. **Giallo del generico** _"Lo storico parte DAVVERO dal 2024.07.05?"_ — sì: **misurato**
   il 01/09 dal Diario (`ticks data begins from 2024.07.05`), e la riga del Diario viene
   ricopiata nel referto.
3. **Giallo** `Spread=0 -> spread CORRENTE, dichiarato` — voluto (agli atti).
4. **Giallo** sulla riga `simbolo .....` nella gamba GBPUSD (override attivo) — voluto.
5. `include … installato AL PIN in MQL5\Include (backup …)` e poi `ripristino del
   terminale: … RIPRISTINATO/RIMOSSO` — è la classe 116 al lavoro. Se un giro viene
   **interrotto a mano**, il **giro dopo** trova la sentinella, rimette a posto e lo
   scrive nei RILIEVI.
6. Ogni 10 s durante la compilazione: `... aspetto l'.ex5 da Ns` — **non interrompere**.
7. `fase 2 (slippage 2/5, motore 2): NON DOVUTA` — il motore 2 non passa A: **nessuna
   passata spesa** (è il criterio §5.6, non un guasto).
8. ⚠️ **NON aprire `anteprima_*.ini`** del giro a vuoto per leggere il modello: scrive
   `Model=4` **hardcoded** (classe 96). Il modello vero si legge da `gen_*.ini` nello zip.
9. **RAM**: se nei log compare `no memory for ticks generating` finisce nei **PROBLEMI**:
   riavvio del PC, **max 4 agenti**, e si rilancia la stessa riga (nota del 01/09).
10. `CODICE DI USCITA NON LETTO` a fine blocco — non è un fallimento (classe 108): fa
    fede il referto.

## 🔁 RICETTA DEL PIN (prima pinnatura) — si prova su una COPIA prima di scriverla
```bash
F=backtest_pipeline/righe/RIGA_R116_LONDONFX_DA_MANDARE.md
SHA=$(git rev-parse HEAD)          # il commit che CONTIENE driver + 2 prova + EA + include + generico
TOK='@@PIN'"@@"                    # composto: la ricetta non contiene la stringa che cerca (punto 77)
sed -i "s|\$pin='$TOK'|\$pin='$SHA'|g; s|\*\*\`$TOK\`\*\*|\*\*\`$SHA\`\*\*|" "$F"
grep -c "\$pin='$SHA'" "$F"        # DEVE dare 5 (blocchi 1-5)
grep -c "\$pin='$TOK'" "$F"        # DEVE dare 0
grep -ci "segnaposto\|non funziona\|la riga non parte" "$F"   # DEVE dare 0 dopo aver RISCRITTO il cartello (classe 101)
```
**Ri-pinnatura** (vecchio → nuovo): il pin vecchio si legge **dai punti d'uso**
(`grep -oE "\\\$pin='[0-9a-f]{40}'" "$F" | head -1`), si sostituisce **solo lì** e nel
titolo, poi **quattro conteggi**: 5 nuovi / 0 vecchi a 40 / 0 cartelli / **0 occorrenze del
prefisso a 7** del vecchio in tutta `backtest_pipeline/` (classe 103). Le menzioni in prosa
di un pin sono storia e **non si toccano**.
