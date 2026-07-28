# =====================================================================
#  organizza.ps1  --  Riordina i file sparsi in cartelle pulite.
#  SICURO: di default fa solo ANTEPRIMA (non muove niente). Aggiungi
#  -Apply per spostare davvero. NON cancella mai nulla. Non tocca i
#  collegamenti (.lnk) sul desktop, quindi le icone dei programmi restano.
#
#  Uso:
#    .\organizza.ps1                 # anteprima (mostra cosa farebbe)
#    .\organizza.ps1 -Apply          # sposta davvero
#    .\organizza.ps1 -Source "C:\Users\Me\Desktop","C:\Users\Me\Downloads"
#    .\organizza.ps1 -Dest "C:\Users\Me\Desktop\Organizzato" -Apply
#
#  Va bene identico su PC fisso e su VPS.
# =====================================================================
param(
  [string[]]$Source = @("$env:USERPROFILE\Desktop","$env:USERPROFILE\Downloads"),
  [string]  $Dest   = "$env:USERPROFILE\Desktop\Organizzato",
  [switch]  $Apply
)
$ErrorActionPreference = "Stop"

function Get-Categoria($f) {
  $n = $f.Name; $e = $f.Extension.ToLower()
  # --- specifiche TRADING (prima delle generiche) ---
  if ($n -match '(?i)^(scan_|OptResults|OptReport|valid_|risultati)') { return "Trading\Backtest" }
  if ($n -match '(?i)ReportHistory|statement')                        { return "Trading\Statement" }
  if ($e -in '.mq5','.ex5','.mqh')                                    { return "Trading\EA" }
  if ($e -eq '.set')                                                  { return "Trading\Preset" }
  if ($e -eq '.ini')                                                  { return "Trading\Config" }
  if (($e -in '.html','.htm') -and $n -match '(?i)report')            { return "Trading\Report" }
  # --- generiche ---
  if ($e -in '.jpg','.jpeg','.png','.gif','.bmp','.webp','.heic')     { return "Immagini" }
  if ($e -in '.pdf','.doc','.docx','.txt','.md','.rtf','.odt')        { return "Documenti" }
  if ($e -in '.xlsx','.xls','.csv','.tsv')                            { return "Fogli" }
  if ($e -in '.ppt','.pptx')                                         { return "Presentazioni" }
  if ($e -in '.zip','.rar','.7z','.tar','.gz')                        { return "Archivi" }
  if ($e -in '.exe','.msi')                                          { return "Programmi" }
  if ($e -in '.mp4','.mov','.avi','.mkv','.webm')                    { return "Video" }
  if ($e -in '.mp3','.wav','.m4a','.flac')                           { return "Audio" }
  return "Altro"
}

function Destinazione-Univoca($cartella, $nomeFile) {
  $target = Join-Path $cartella $nomeFile
  if (-not (Test-Path $target)) { return $target }
  $base = [IO.Path]::GetFileNameWithoutExtension($nomeFile)
  $ext  = [IO.Path]::GetExtension($nomeFile)
  for ($i = 2; $i -lt 999; $i++) {
    $t = Join-Path $cartella ("{0} ({1}){2}" -f $base,$i,$ext)
    if (-not (Test-Path $t)) { return $t }
  }
  return (Join-Path $cartella ([Guid]::NewGuid().ToString()+$ext))
}

$modo = if ($Apply) { "SPOSTAMENTO REALE" } else { "ANTEPRIMA (nessun file spostato)" }
Write-Host "=== organizza.ps1 -- $modo ===" -ForegroundColor Cyan
Write-Host "Sorgenti: $($Source -join ' ; ')"
Write-Host "Destinazione: $Dest`n"

$destFull = [IO.Path]::GetFullPath($Dest)
$conteggi = @{}
$tot = 0

foreach ($src in $Source) {
  if (-not (Test-Path $src)) { Write-Host "  (salto, non esiste: $src)" -ForegroundColor DarkGray; continue }
  # solo i FILE direttamente nella sorgente (niente ricorsione: non svuoto le tue sottocartelle)
  $files = Get-ChildItem -LiteralPath $src -File -Force -ErrorAction SilentlyContinue
  foreach ($f in $files) {
    if ($f.Extension.ToLower() -eq '.lnk') { continue }                 # lascio i collegamenti/icone
    if ($f.Name -ieq 'organizza.ps1') { continue }                      # non muovo me stesso
    if ($f.Attributes -band [IO.FileAttributes]::Hidden) { continue }   # niente file nascosti/sistema
    if ($f.FullName.StartsWith($destFull, 'OrdinalIgnoreCase')) { continue } # gia' dentro Organizzato

    $cat = Get-Categoria $f
    $cartella = Join-Path $Dest $cat
    $target = Destinazione-Univoca $cartella $f.Name
    $conteggi[$cat] = 1 + ($conteggi[$cat]) ; $tot++

    if ($Apply) {
      try {
        New-Item -ItemType Directory -Force -Path $cartella | Out-Null
        Move-Item -LiteralPath $f.FullName -Destination $target -Force
        Write-Host ("  [OK]   {0,-22} <- {1}" -f $cat,$f.Name) -ForegroundColor Green
      } catch {
        Write-Host ("  [SALTO {0}] {1}" -f $f.Name,$_.Exception.Message) -ForegroundColor Yellow
      }
    } else {
      Write-Host ("  {0,-22} <- {1}" -f $cat,$f.Name) -ForegroundColor Gray
    }
  }
}

Write-Host "`n--- RIEPILOGO ---" -ForegroundColor Cyan
foreach ($k in ($conteggi.Keys | Sort-Object)) { Write-Host ("  {0,-22} {1} file" -f $k,$conteggi[$k]) }
Write-Host ("  TOTALE: {0} file" -f $tot) -ForegroundColor White
if (-not $Apply) {
  Write-Host "`nQuesta era solo l'ANTEPRIMA. Se ti va bene, rilancia con  -Apply  per spostare davvero." -ForegroundColor Yellow
} else {
  Write-Host "`nFatto. Trovi tutto ordinato in: $Dest" -ForegroundColor Green
}
