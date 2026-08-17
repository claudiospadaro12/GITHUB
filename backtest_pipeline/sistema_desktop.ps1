# =====================================================================
#  sistema_desktop.ps1 -- riordina il Desktop SENZA CANCELLARE NIENTE.
#
#  PERCHE' ESISTE (18/08/2026): settimane di referti, pagelle, zip e
#  csv di raccolta hanno riempito il Desktop. Questo script li SPOSTA
#  (mai cancella) in Desktop\ARCHIVIO_DESKTOP, divisi per tipo.
#
#  COSA NON TOCCA, MAI:
#    - collegamenti (.lnk, .url), programmi (.exe), desktop.ini
#    - le CARTELLE (nessuna cartella viene spostata o toccata)
#    - i file di OGGI e ieri (default -GiorniVecchi 2): quello su cui
#      stai lavorando resta davanti agli occhi
#
#  USO:
#    .\sistema_desktop.ps1 -Prova     -> fa vedere cosa sposterebbe, NON tocca nulla
#    .\sistema_desktop.ps1            -> sposta davvero
#    .\sistema_desktop.ps1 -GiorniVecchi 0  -> archivia anche i file di oggi
#
#  Ogni spostamento e' scritto nel log dentro l'archivio. Se un nome
#  esiste gia' nell'archivio, il file viene rinominato con _2, _3...
#  niente viene mai sovrascritto.
# =====================================================================
param(
  [int]$GiorniVecchi = 2,
  [switch]$Prova
)
$ErrorActionPreference = "Stop"

$desk = [Environment]::GetFolderPath("Desktop")
$arch = Join-Path $desk "ARCHIVIO_DESKTOP"
$oggi = Get-Date
$limite = $oggi.Date.AddDays(-($GiorniVecchi - 1))

# categoria -> pattern (il primo che combacia vince)
$regole = @(
  @{ Cartella = "pagelle";  Pattern = @("pagella_*.txt") },
  @{ Cartella = "referti";  Pattern = @("censimento_*.txt","abbassa_rischio*.txt","sonda_*.txt","*referto*.txt","*referto*.md","verifica_*.txt","tetto_*.txt") },
  @{ Cartella = "zip";      Pattern = @("*.zip","*.7z","*.rar") },
  @{ Cartella = "csv";      Pattern = @("*.csv") },
  @{ Cartella = "log";      Pattern = @("*.log") },
  @{ Cartella = "set_ini";  Pattern = @("*.set","*.ini") },
  @{ Cartella = "immagini"; Pattern = @("*.png","*.jpg","*.jpeg","*.bmp") },
  @{ Cartella = "testi";    Pattern = @("*.txt","*.md") }
)
$nonToccare = @(".lnk",".url",".exe",".msi",".bat",".ps1")

$Righe = New-Object System.Collections.ArrayList
function Rec($s,$col){ [void]$Righe.Add($s); if($col){Write-Host $s -ForegroundColor $col}else{Write-Host $s} }

$titolo = if($Prova){"PROVA (non tocco niente)"}else{"SPOSTAMENTO VERO"}
Rec ("=== SISTEMAZIONE DESKTOP - " + $titolo + " ===") White
Rec ("data: " + (Get-Date -Format "yyyy.MM.dd HH:mm") + "   restano i file degli ultimi " + $GiorniVecchi + " giorni") Gray
Rec ""

$file = Get-ChildItem $desk -File | Where-Object {
  $nonToccare -notcontains $_.Extension.ToLower() -and
  $_.Name -ne "desktop.ini" -and
  $_.LastWriteTime -lt $limite
}

if(-not $file){
  Rec "Niente da archiviare: il Desktop e' gia' in ordine (o e' tutto recente)." Green
  exit 0
}

$spostati = 0; $lasciati = 0
foreach($f in $file){
  $dest = $null
  foreach($r in $regole){
    foreach($p in $r.Pattern){
      if($f.Name -like $p){ $dest = $r.Cartella; break }
    }
    if($dest){ break }
  }
  if(-not $dest){
    Rec ("  lasciato (tipo non gestito): " + $f.Name) Gray
    $lasciati++
    continue
  }

  $cartDest = Join-Path $arch $dest
  $nomeDest = Join-Path $cartDest $f.Name
  if($Prova){
    Rec ("  [PROVA] " + $f.Name + "  ->  ARCHIVIO_DESKTOP\" + $dest) Cyan
    $spostati++
    continue
  }

  if(-not (Test-Path $cartDest)){ New-Item -ItemType Directory -Path $cartDest -Force | Out-Null }
  $n = 2
  while(Test-Path $nomeDest){
    $nomeDest = Join-Path $cartDest ($f.BaseName + "_" + $n + $f.Extension)
    $n++
  }
  Move-Item -Path $f.FullName -Destination $nomeDest
  Rec ("  spostato: " + $f.Name + "  ->  ARCHIVIO_DESKTOP\" + $dest) Green
  $spostati++
}

Rec ""
Rec ("file " + $(if($Prova){"da spostare"}else{"spostati"}) + ": " + $spostati + "   lasciati: " + $lasciati) White
if($Prova){
  Rec "Era solo la PROVA. Per spostare davvero: rilancia SENZA -Prova" Yellow
} else {
  Rec ("Tutto dentro: " + $arch) Cyan
  Rec "NIENTE e' stato cancellato: solo spostato. Le cartelle e i collegamenti non sono stati toccati." Gray
  $log = Join-Path $arch ("log_sistemazione_" + (Get-Date -Format "yyyy-MM-dd_HHmm") + ".txt")
  $Righe | Set-Content -Path $log -Encoding UTF8
  Write-Host ("Log scritto in: " + $log) -ForegroundColor Cyan
}
