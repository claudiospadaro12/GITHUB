# =====================================================================
#  SONDA DELLO STORICO -- installa e raccoglie ABTG_InfoBroker
#
#  PERCHE' ESISTE (17/08/2026):
#  il CENSIMENTO_REGOLA_FINESTRA.md ha misurato che su 155 coppie
#  EA x simbolo lo storico e' stato MISURATO su DUE (GBPUSD e USDJPY).
#  Su tutte le altre usiamo `2024.09.26` per abitudine, non per misura.
#  Finche' non giriamo questa sonda, meta' di quel censimento e' [STIMA].
#
#  USO:
#     .\sonda_storico.ps1              -> installa lo script in MT5
#     .\sonda_storico.ps1 -Raccogli    -> raccoglie il CSV sul Desktop
#
#  ⚠️ NON e' il driver dei backtest: qui MT5 deve essere APERTO.
# =====================================================================
param(
  [switch]$Raccogli,
  [string]$Ref = "lavoro"
)

$ErrorActionPreference = "Stop"
$Raw  = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Ref/mql5/Scripts/ABTG_InfoBroker.mq5"
$Root = Join-Path $env:APPDATA "MetaQuotes\Terminal"

function Cartelle-Dati {
  if(-not (Test-Path $Root)){ throw "Non trovo $Root : MT5 e' installato su questo PC?" }
  # una cartella dati vera ha MQL5\Experts. Le altre (Common, cache) no.
  Get-ChildItem $Root -Directory -ErrorAction SilentlyContinue |
    Where-Object { Test-Path (Join-Path $_.FullName "MQL5\Experts") }
}

$dirs = @(Cartelle-Dati)
if($dirs.Count -eq 0){ throw "Nessuna cartella dati MT5 trovata sotto $Root" }

if(-not $Raccogli){
  # ---------------- INSTALLA ----------------
  $tmp = Join-Path $env:TEMP "ABTG_InfoBroker.mq5"
  Invoke-WebRequest -Uri $Raw -OutFile $tmp -UseBasicParsing
  $kb = [math]::Round((Get-Item $tmp).Length/1KB,1)
  Write-Host "Scaricato ABTG_InfoBroker.mq5 ($kb KB) dal branch '$Ref'." -ForegroundColor Green

  foreach($d in $dirs){
    $dest = Join-Path $d.FullName "MQL5\Scripts"
    New-Item -ItemType Directory -Force -Path $dest | Out-Null
    Copy-Item $tmp -Destination $dest -Force
    Write-Host ("  -> " + (Join-Path $dest "ABTG_InfoBroker.mq5"))
  }

  Write-Host ""
  Write-Host "ADESSO, DENTRO MT5:" -ForegroundColor Yellow
  Write-Host "  1. Navigatore -> Script -> tasto destro -> Aggiorna"
  Write-Host "  2. Metti in Market Watch SOLO i simboli che ti interessano"
  Write-Host "     (la sonda misura quelli, non tutti i 120 del broker)"
  Write-Host "  3. Trascina ABTG_InfoBroker su un grafico qualsiasi e metti:"
  Write-Host "        InpSondaStorico    = true      <- SENZA QUESTO NON MISURA NIENTE" -ForegroundColor Yellow
  Write-Host "        InpNonBloccare     = true      <- lascialo true: e' quello che evita"
  Write-Host "                                          il quarto d'ora PER SIMBOLO"
  Write-Host "        InpSoloMarketWatch = true"
  Write-Host "        InpTF              = H1"
  Write-Host "        InpEsportaH1       = false"
  Write-Host "        InpMaxSecScansione = 1800"
  Write-Host "  4. Guarda la scheda Esperti: alla fine fa un SECONDO GIRO e"
  Write-Host "     scrive quanti simboli restano 'da svegliare'."
  Write-Host ""
  Write-Host "Poi torna qui e lancia:  .\sonda_storico.ps1 -Raccogli" -ForegroundColor Green
}
else {
  # ---------------- RACCOGLI ----------------
  $dest = Join-Path ([Environment]::GetFolderPath("Desktop")) "SONDA_STORICO"
  Remove-Item $dest -Recurse -Force -ErrorAction SilentlyContinue
  New-Item -ItemType Directory -Force -Path $dest | Out-Null

  $n = 0
  foreach($d in $dirs){
    foreach($f in @("ABTG_InfoBroker.csv","ABTG_InfoBroker_H1.csv")){
      $src = Join-Path $d.FullName "MQL5\Files\$f"
      if(Test-Path $src){
        Copy-Item $src -Destination (Join-Path $dest ($d.Name.Substring(0,8) + "_" + $f)) -Force
        $n++
      }
    }
  }
  if($n -eq 0){
    Write-Host "NESSUN CSV TROVATO." -ForegroundColor Red
    Write-Host "Vuol dire che lo script non e' ancora girato, oppure e' girato" -ForegroundColor Red
    Write-Host "con InpSondaStorico = false. Guarda la scheda Esperti di MT5." -ForegroundColor Red
    exit 1
  }
  $zip = Join-Path ([Environment]::GetFolderPath("Desktop")) "sonda_storico.zip"
  Compress-Archive -Path (Join-Path $dest "*") -DestinationPath $zip -Force
  Get-ChildItem $dest | Select-Object Name,Length | Format-Table -AutoSize
  Write-Host "ZIP pronto da mandare: $zip" -ForegroundColor Green
}
