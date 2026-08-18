# =====================================================================
#  sistema_cartelle.ps1 -- porta le CARTELLE DEI TEST del Desktop
#  dentro ARCHIVIO_DESKTOP\cartelle_test. SPOSTA, NON CANCELLA MAI.
#
#  PERCHE' ESISTE (18/08/2026): lo screenshot del Desktop del PC
#  mostra ~60 cartelle di round e prove (r48..r59, R70..R79, pte*,
#  regime_*, sonde, gapnas, tetto, ...) sparse fra le icone dei
#  programmi. Questo script le impacchetta sotto un'unica casa madre.
#
#  COME DECIDE: per LISTA DI RICONOSCIMENTO (pattern dei nomi dei
#  nostri test, letti dallo screenshot del 18/08). Una cartella che
#  NON combacia con nessun pattern viene LASCIATA DOV'E' e segnata
#  nel referto: meglio una cartella in piu' sul Desktop che una
#  spostata per sbaglio.
#
#  COSA NON TOCCA MAI: file, collegamenti, ARCHIVIO_DESKTOP stesso,
#  le cartelle ABTG_* (sono gia' archivi ordinati), e qualunque nome
#  non riconosciuto.
#
#  USO:
#    .\sistema_cartelle.ps1 -Prova    -> elenca cosa sposterebbe, non tocca nulla
#    .\sistema_cartelle.ps1           -> sposta davvero
# =====================================================================
param(
  [switch]$Prova,
  [switch]$ConTematiche
)
$ErrorActionPreference = "Stop"

$desk = [Environment]::GetFolderPath("Desktop")
$arch = Join-Path $desk "ARCHIVIO_DESKTOP"
$dest = Join-Path $arch "cartelle_test"
$tema = Join-Path $arch "cartelle_tema"

# i nomi dei NOSTRI test (dallo screenshot del 18/08). -like, case-insensitive.
$riconosciute = @(
  "r[0-9]*","pte*","regime_*","ez_r*","gc[0-9]*","gapnas*","GapContin*",
  "sonda_*","storico_*","diag_*","pertrade_*","mr[0-9]*","tetto*",
  "censiment*","broker_est*","caccia_ticket","da_setacciare","stacca_ea*",
  "config_dax","estrai_set*","import_est*","ea_attaccati","conferma_*",
  "dow_apertura","trades","ReportTester*","wetransfer_*","Ciclo"
)
# le cartelle TEMATICHE di Claudio: gia' ordine suo, NON sono test.
# Si spostano (in cartelle_tema, non in cartelle_test) SOLO con -ConTematiche.
$tematiche = @(
  "NOTTE*","EASYTREND","BREAKOUT","PROCE*","INDICATORI","ALTA VELOCIT*",
  "NASDAQ APERTU*","DAX E NASD*","PIANO DI TRADI*","FILE WORD*","FILE CHE SCARICO*"
)
# mai toccare, nemmeno se un pattern combaciasse
$protette = @("ARCHIVIO_DESKTOP")

$Righe = New-Object System.Collections.ArrayList
$Mosse = New-Object System.Collections.ArrayList
function Rec($s,$col){ [void]$Righe.Add($s); if($col){Write-Host $s -ForegroundColor $col}else{Write-Host $s} }

$titolo = if($Prova){"PROVA (non tocco niente)"}else{"SPOSTAMENTO VERO"}
Rec ("=== CARTELLE DEI TEST -> ARCHIVIO_DESKTOP\cartelle_test - " + $titolo + " ===") White
Rec ("data: " + (Get-Date -Format "yyyy.MM.dd HH:mm")) Gray
Rec ""

$cartelle = Get-ChildItem $desk -Directory
$daSpostare = 0; $lasciate = 0
foreach($c in $cartelle){
  if($protette -contains $c.Name -or $c.Name -like "ABTG_*"){
    Rec ("  protetta, resta: " + $c.Name) Gray
    $lasciate++
    continue
  }
  $match = $false; $dirDest = $dest; $etichetta = "cartelle_test"
  foreach($p in $riconosciute){ if($c.Name -like $p){ $match = $true; break } }
  if(-not $match){
    foreach($p in $tematiche){ if($c.Name -like $p){ $match = $true; $dirDest = $tema; $etichetta = "cartelle_tema"; break } }
    if($match -and -not $ConTematiche){
      Rec ("  tematica, resta (per archiviarla: rilancia con -ConTematiche): " + $c.Name) Gray
      $lasciate++
      continue
    }
  }
  if(-not $match){
    Rec ("  NON riconosciuta, resta (dimmelo se va archiviata): " + $c.Name) Yellow
    $lasciate++
    continue
  }

  if($Prova){
    Rec ("  [PROVA] " + $c.Name + "  ->  ARCHIVIO_DESKTOP\" + $etichetta) Cyan
    $daSpostare++
    continue
  }

  if(-not (Test-Path -LiteralPath $dirDest)){ New-Item -ItemType Directory -Path $dirDest -Force | Out-Null }
  $nomeDest = Join-Path $dirDest $c.Name
  $n = 2
  while(Test-Path -LiteralPath $nomeDest){
    $nomeDest = Join-Path $dirDest ($c.Name + "_" + $n)
    $n++
  }
  try{
    Move-Item -LiteralPath $c.FullName -Destination $nomeDest -ErrorAction Stop
    [void]$Mosse.Add([pscustomobject]@{ Origine=$c.FullName; Destinazione=$nomeDest })
    Rec ("  spostata: " + $c.Name) Green
    $daSpostare++
  } catch {
    Rec ("  NON spostata (in uso o protetta dal sistema): " + $c.Name + " -- " + $_.Exception.Message) Red
    $lasciate++
  }
}

Rec ""
Rec ("cartelle " + $(if($Prova){"da spostare"}else{"spostate"}) + ": " + $daSpostare + "   lasciate: " + $lasciate) White
Rec "NIENTE e' stato cancellato. Spostare NON libera spazio su disco: mette ordine." Gray

if($Prova){
  $ref = Join-Path $desk ("prova_cartelle_" + (Get-Date -Format "yyyy-MM-dd_HHmm") + ".txt")
  $Righe | Set-Content -Path $ref -Encoding UTF8
  Write-Host ("Referto della prova (unico file creato): " + $ref) -ForegroundColor Cyan
} else {
  if(-not (Test-Path $arch)){ New-Item -ItemType Directory -Path $arch -Force | Out-Null }
  $stamp = Get-Date -Format "yyyy-MM-dd_HHmm"
  $log = Join-Path $arch ("log_cartelle_" + $stamp + ".txt")
  $Righe | Set-Content -Path $log -Encoding UTF8
  if($Mosse.Count -gt 0){
    $csv = Join-Path $arch ("mosse_cartelle_" + $stamp + ".csv")
    $Mosse | Export-Csv -Path $csv -NoTypeInformation -Encoding UTF8
    Write-Host ("Elenco per rimettere tutto a posto: " + $csv) -ForegroundColor Cyan
  }
  Write-Host ("Log scritto in: " + $log) -ForegroundColor Cyan
}
