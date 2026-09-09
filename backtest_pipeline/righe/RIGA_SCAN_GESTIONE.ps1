# =====================================================================
#  MARCATORE_RIGA_SCAN_GESTIONE_v1
#  RIGA_SCAN_GESTIONE.ps1 -- lo STUDIO DELLA GESTIONE sul terminale da
#  backtest, con le guardie di RIGA_ROUND_VPS.ps1 (non reinventate).
# ---------------------------------------------------------------------
#  PERCHE' ESISTE (09/09/2026)
#  scan_gestione.ps1 e' scritto dal 14/08 e NON E' MAI STATO LANCIATO
#  (audit delle uscite, report\AUDIT_USCITE_2026-09-09.md). Ma e' del
#  tempo in cui c'era UN SOLO MT5: lanciato oggi sul VPS avrebbe
#  ricompilato l'EA dentro la cartella del PICCOLO (50503392), che ha le
#  sedie VIVE. La v2 dello script chiude quel buco alla radice; questa
#  riga aggiunge il resto del cinturone gia' collaudato:
#    - MUORE su -V3 (100k 50504263) e BCM_Reale (REALE 10105439);
#    - censimento PID PRIMA e DOPO, con allarme rosso se sparisce un
#      terminale NON bersaglio: e' la prova STAMPATA che il reale non e'
#      stato toccato;
#    - chiusura CHIRURGICA del solo terminale da backtest (classe 159);
#    - PIN di commit sullo script e sull'EA (classe 164);
#    - raccolta con ZIP sul Desktop, sempre, anche se una corsa fallisce.
#
#  COSA MISURA (e cosa NO)
#    48 combinazioni di USCITA a tick reali, INGRESSO FISSATO ai default:
#      parziale 0/50% x BE-dopo-parziale x BE indipendente x
#      trailing OFF/ATR/PREVBAR/FIXED.
#    NON tocca l'ingresso, NON promuove niente, NON scrive in forward.
#    Il metro esiste gia': R46 ha misurato che la sola struttura d'uscita
#    sposta il DAX da PF 0,88 a PF 1,49 fuori campione. Qui si cerca il
#    CENTRO DELL'ALTOPIANO, mai il picco.
#
#  NIENTE EMOJI: Windows PowerShell 5.1 legge i .ps1 come ANSI.
# =====================================================================
param(
  [string]$Pin               = "lavoro",
  [string]$TerminaleBacktest = "C:\MT5_Backtest",
  [string]$Work              = "$env:USERPROFILE\abtg_gestione",
  [string]$Fase              = "struttura",
  [switch]$ChiudiBacktest,
  [switch]$SoloControllo
)
$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$MARC_MIO = "MARCATORE_RIGA_SCAN_GESTIONE_v1"
$MARC_SCN = "MARCATORE_SCAN_GESTIONE_v2_VPS"
$RawBase  = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"
$Avvio    = Get-Date

function Muori($m){ Write-Host ""; Write-Host ("ERRORE: " + $m) -ForegroundColor Red; exit 1 }

# --- LE DUE CORSE. Ora SERVER BCM (= italiana - 1): DAX 8, Nasdaq 14.
$CORSE = @(
  @{ Robot="ABTG_DAX_Apertura_EU";    Symbol="D30EUR"; Ora=8  },
  @{ Robot="ABTG_Nasdaq_Apertura_US"; Symbol="NASUSD"; Ora=14 }
)

Write-Host ""
Write-Host "=== STUDIO GESTIONE -- fase '$Fase' -- pin $Pin ===" -ForegroundColor Cyan

# =====================================================================
#  1. IL TERMINALE: SI NOMINA, E LE GUARDIE NON SI ALLENTANO
# =====================================================================
$cartellaBT = $TerminaleBacktest.TrimEnd('\','/')
if($cartellaBT -like "*-V3*" -or $cartellaBT -like "*BCM_Reale*"){
  Muori ("TERMINALE VIETATO: '" + $cartellaBT + "'. Il 100k (-V3, 50504263) e il conto REALE (BCM_Reale, 10105439) non si toccano. Il terminale da backtest e' C:\MT5_Backtest (demo 50504400).")
}
if(-not (Test-Path -LiteralPath $cartellaBT -PathType Container)){ Muori ("la cartella '" + $cartellaBT + "' non esiste.") }
$exeBT = Join-Path $cartellaBT "terminal64.exe"
$medBT = Join-Path $cartellaBT "metaeditor64.exe"
if(-not (Test-Path -LiteralPath $exeBT -PathType Leaf)){ Muori ("in '" + $cartellaBT + "' non c'e' terminal64.exe.") }
if(-not (Test-Path -LiteralPath $medBT -PathType Leaf)){ Muori ("in '" + $cartellaBT + "' non c'e' metaeditor64.exe: senza compilatore lo studio non parte.") }

function Terminali(){ return @(Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) }
function Bersagli($p){ return @($p | Where-Object { $_.Path -and ($_.Path -like ($cartellaBT + "\*")) }) }
function Risparmiati($p){ return @($p | Where-Object { -not ($_.Path -and ($_.Path -like ($cartellaBT + "\*"))) }) }

$tutti = Terminali; $berPri = Bersagli $tutti; $salPri = Risparmiati $tutti
$pidSalvi = @($salPri | ForEach-Object { $_.Id })

Write-Host ""
Write-Host "--- TERMINALI MT5 VISTI ADESSO (PRIMA) ------------------------------" -ForegroundColor Cyan
if($berPri.Count -eq 0){ Write-Host "  BERSAGLIO (backtest): nessuno vivo. Bene." -ForegroundColor Green }
else{ Write-Host "  BERSAGLIO (backtest, l'unico che posso chiudere):" -ForegroundColor Yellow
      $berPri | ForEach-Object { Write-Host ("    PID " + $_.Id + "    " + $_.Path) -ForegroundColor Yellow } }
Write-Host "  LASCIATI VIVI (forward e CONTO REALE: NON li tocco):" -ForegroundColor Green
if($salPri.Count -eq 0){ Write-Host "    (nessuno)" -ForegroundColor Green }
else{ $salPri | ForEach-Object { Write-Host ("    PID " + $_.Id + "    " + $(if($_.Path){$_.Path}else{"<percorso non leggibile: NON e' un bersaglio>"})) -ForegroundColor Green } }
Write-Host "---------------------------------------------------------------------" -ForegroundColor Cyan

if($berPri.Count -gt 0 -and -not $SoloControllo){
  if(-not $ChiudiBacktest){ Muori "il terminale da backtest e' aperto: rilancia con -ChiudiBacktest (chiudo SOLO quello)." }
  Write-Host "  chiudo SOLO il bersaglio..." -ForegroundColor Yellow
  $berPri | ForEach-Object { try{ Stop-Process -Id $_.Id -Force -ErrorAction Stop }catch{} }
  Start-Sleep -Seconds 4
}

# --- CARTELLA DATI: prima il portable (MQL5 dentro l'installazione), poi
#     origin.txt in APPDATA. Si STAMPA quale delle due ha vinto.
$DataFolder = ""; $viaDati = ""
if(Test-Path -LiteralPath (Join-Path $cartellaBT "MQL5") -PathType Container){
  $DataFolder = $cartellaBT; $viaDati = "PORTABLE (MQL5 dentro l'installazione)"
} else {
  $termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
  if(Test-Path $termRoot){
    $d = Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue | Where-Object {
           $o = Join-Path $_.FullName "origin.txt"
           (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $cartellaBT)
         } | Select-Object -First 1
    if($d){ $DataFolder = $d.FullName; $viaDati = "APPDATA via origin.txt" }
  }
}
if(-not $DataFolder){ Muori "cartella dati MT5 non trovata ne' portable ne' via origin.txt." }
Write-Host ("  cartella dati : " + $DataFolder + "   [" + $viaDati + "]") -ForegroundColor Gray

# =====================================================================
#  2. LO SCRIPT DALLO STESSO PIN, COL SUO MARCATORE
# =====================================================================
New-Item -ItemType Directory -Force -Path $Work | Out-Null
$scn = Join-Path $Work "scan_gestione.ps1"
Remove-Item $scn -ErrorAction SilentlyContinue
$u = $RawBase + "/backtest_pipeline/scan_gestione.ps1?cb=" + [guid]::NewGuid().ToString()
try{ Invoke-WebRequest -Uri $u -OutFile $scn -UseBasicParsing }catch{ Muori ("download di scan_gestione.ps1 fallito dal pin " + $Pin) }
if(-not (Select-String -Path $scn -SimpleMatch -Pattern $MARC_SCN -Quiet)){
  Muori ("scan_gestione.ps1 scaricato NON e' la v2 (manca " + $MARC_SCN + "): la v1 puo' ricompilare dentro il terminale del PICCOLO. Fermato.")
}
Write-Host ("  scan_gestione : v2 verificata (" + $MARC_SCN + ")") -ForegroundColor Green

if($SoloControllo){
  Write-Host ""
  Write-Host "GIRO A VUOTO: guardie passate, dati e script a posto. Niente e' stato lanciato." -ForegroundColor Cyan
  Write-Host "ATTENZIONE: il giro a vuoto NON compila e NON collauda il tester." -ForegroundColor Yellow
  exit 0
}

# =====================================================================
#  3. LE DUE CORSE
# =====================================================================
$esiti = @()
foreach($c in $CORSE){
  Write-Host ""
  Write-Host ("=== CORSA: " + $c.Robot + " su " + $c.Symbol + "   (SessionHour SERVER=" + $c.Ora + ") ===") -ForegroundColor Cyan
  & powershell -NoProfile -ExecutionPolicy Bypass -File $scn `
      -Robot $c.Robot -Symbol $c.Symbol -SessionHour $c.Ora -Fase $Fase -Pin $Pin `
      -Terminal $exeBT -MetaEditor $medBT -DataFolder $DataFolder -Force
  $rc = $LASTEXITCODE
  $esiti += [pscustomobject]@{ Robot=$c.Robot; Symbol=$c.Symbol; Rc=$rc }
  Write-Host ("--- ESITO " + $c.Symbol + ": rc=" + $rc) -ForegroundColor Cyan
}

# =====================================================================
#  4. CENSIMENTO DOPO -- LA PROVA STAMPATA
# =====================================================================
$dopo = Terminali; $salDopo = Risparmiati $dopo
$pidDopo = @($salDopo | ForEach-Object { $_.Id })
$spariti = @($pidSalvi | Where-Object { $pidDopo -notcontains $_ })
Write-Host ""
Write-Host ("PID non bersaglio PRIMA: " + ($pidSalvi -join ", ")) -ForegroundColor Gray
Write-Host ("PID non bersaglio DOPO : " + ($pidDopo  -join ", ")) -ForegroundColor Gray
if($spariti.Count -gt 0){
  Write-Host ("!!! ALLARME: sono spariti terminali NON bersaglio: " + ($spariti -join ", ")) -ForegroundColor Red
} else {
  Write-Host "OK: nessun terminale non bersaglio e' stato toccato." -ForegroundColor Green
}

# =====================================================================
#  5. RACCOLTA -- SEMPRE, anche se una corsa e' fallita
# =====================================================================
$dsk = [Environment]::GetFolderPath("Desktop")
$dir = Join-Path $dsk ("GESTIONE_" + $Fase.ToUpper())
if(Test-Path -LiteralPath $dir){ Remove-Item -LiteralPath $dir -Recurse -Force }
New-Item -ItemType Directory -Force -Path $dir | Out-Null

$sorgente = Join-Path $Work "risultati_gestione"
$copiati = 0
if(Test-Path -LiteralPath $sorgente){
  Get-ChildItem -LiteralPath $sorgente -Filter *.csv -ErrorAction SilentlyContinue |
    Where-Object { $_.LastWriteTime -ge $Avvio } |
    ForEach-Object { Copy-Item $_.FullName -Destination $dir -Force; $copiati++ }
}
$ref = Join-Path $dir "REFERTO_GESTIONE.txt"
$righe = @()
$righe += "REFERTO STUDIO GESTIONE"
$righe += ("marcatore riga  : " + $MARC_MIO)
$righe += ("marcatore script: " + $MARC_SCN)
$righe += ("pin             : " + $Pin)
$righe += ("data            : " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss") + "   <-- SE NON E' DI OGGI, IL FILE E' VECCHIO")
$righe += ("terminale       : " + $exeBT)
$righe += ("cartella dati   : " + $DataFolder + "   [" + $viaDati + "]")
$righe += ("fase            : " + $Fase)
$righe += ""
foreach($e in $esiti){ $righe += ("  " + $e.Robot + " / " + $e.Symbol + "   rc=" + $e.Rc) }
$righe += ""
$righe += ("CSV raccolti    : " + $copiati)
if($copiati -eq 0){ $righe += "  ATTENZIONE: zero CSV. NON vuol dire 'nessun edge': vuol dire NON E' GIRATA. Guardare il log." }
$righe += ""
$righe += ("PID non bersaglio PRIMA: " + ($pidSalvi -join ", "))
$righe += ("PID non bersaglio DOPO : " + ($pidDopo  -join ", "))
# NOTA: niente "(if ...)" come espressione fra parentesi -- pwsh 7 lo
# accetta, Windows PowerShell 5.1 no. Sul VPS gira la 5.1.
if($spariti.Count -gt 0){ $righe += ("ALLARME: spariti " + ($spariti -join ", ")) }
else                    { $righe += "OK: nessun terminale non bersaglio toccato." }
$righe | Set-Content -Path $ref -Encoding ASCII

$zip = Join-Path $dsk ("GESTIONE_" + $Fase.ToUpper() + ".zip")
if(Test-Path -LiteralPath $zip){ Remove-Item -LiteralPath $zip -Force }
Compress-Archive -Path (Join-Path $dir "*") -DestinationPath $zip -Force
Write-Host ""
Write-Host ("ZIP PRONTO DA MANDARE: " + $zip) -ForegroundColor Green
Write-Host ("  CSV dentro: " + $copiati) -ForegroundColor Gray
Write-Host "  REFERTO_GESTIONE.txt" -ForegroundColor Gray
if($copiati -eq 0){ exit 2 } else { exit 0 }
