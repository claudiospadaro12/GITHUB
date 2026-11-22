# MARCATORE_RIDUCI_ZIP_RISULTATI_v1
# SOLA LETTURA sullo zip originale (non lo modifica, non lo cancella). Prende l ultimo zip dei risultati con il prefisso dato (default ANNO_ORO_GRADINI_UBSCLT_)
# in Desktop\ABTG_RISULTATI (o C:\ABTG_RISULTATI) e crea in C:\ABTG_RISULTATI UNO zip ridotto: toglie i PNG, gli zip interni (doppioni) e i log di servizio,
# tiene MANIFEST, REFERTO, ini (con il set), report .htm e i due log principali del tester. Non apre MT5, non usa la rete, non tocca conti/VPS/reale. ASCII PURO.
param([string]$Prefisso = 'ANNO_ORO_GRADINI_UBSCLT_')
$ErrorActionPreference='Stop'
$INV=[Globalization.CultureInfo]::InvariantCulture
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem
$cerca=@((Join-Path ([Environment]::GetFolderPath('Desktop')) 'ABTG_RISULTATI'),'C:\ABTG_RISULTATI')
$z=@()
foreach($d in $cerca){ if(Test-Path -LiteralPath $d){ $z += @(Get-ChildItem -LiteralPath $d -File -Filter ($Prefisso + '*.zip') -ErrorAction SilentlyContinue | Where-Object { $_.Name -notmatch '_RIDOTTO' }) } }
if($z.Count -eq 0){ Write-Host ('NON TROVO nessuno zip "' + $Prefisso + '*.zip" in Desktop\ABTG_RISULTATI o C:\ABTG_RISULTATI.') -ForegroundColor Red; return }
$src=($z | Sort-Object LastWriteTime -Descending | Select-Object -First 1)
Write-Host ('Zip trovato: ' + $src.FullName + '  (' + [math]::Round($src.Length/1MB,1).ToString($INV) + ' MB)') -ForegroundColor Green
$out='C:\ABTG_RISULTATI'; New-Item -ItemType Directory -Force -Path $out | Out-Null
$dst=Join-Path $out ([IO.Path]::GetFileNameWithoutExtension($src.Name) + '_RIDOTTO.zip')
if(Test-Path -LiteralPath $dst){ Remove-Item -LiteralPath $dst -Force }
$za=[IO.Compression.ZipFile]::OpenRead($src.FullName)
$zo=[IO.Compression.ZipFile]::Open($dst,[IO.Compression.ZipArchiveMode]::Create)
$presi=0; $esclusi=0
try {
  foreach($e in @($za.Entries)){
    if($e.Name -eq ''){ continue }
    $n=($e.FullName -replace '/','\').ToLowerInvariant()
    $skip=$false
    if($n.EndsWith('.png')){ $skip=$true }
    elseif($n.EndsWith('.zip')){ $skip=$true }
    elseif(($n -match '\\log\\') -and ($n -notmatch 'tranche22_0[23]_logs_')){ $skip=$true }
    if($skip){ $esclusi++; continue }
    $ne=$zo.CreateEntry($e.FullName,[IO.Compression.CompressionLevel]::Optimal)
    $si=$e.Open(); $so=$ne.Open()
    try { $si.CopyTo($so) } finally { $so.Dispose(); $si.Dispose() }
    $presi++
  }
} finally { $zo.Dispose(); $za.Dispose() }
$dim=(Get-Item -LiteralPath $dst).Length
Write-Host ''
Write-Host ('Inclusi: ' + $presi + ' file; esclusi (PNG, zip interni, log di servizio): ' + $esclusi + '. Zip ridotto: ' + [math]::Round($dim/1MB,2).ToString($INV) + ' MB')
if($dim -gt 25MB){ Write-Host 'ATTENZIONE: ancora sopra 25 MB: dimmelo e lo riduco di piu.' -ForegroundColor Yellow }
Write-Host ('File prodotto (uno solo): ' + $dst) -ForegroundColor Green
Write-Host ('>>> ALLEGA QUESTO ZIP ALLA CHAT: ' + $dst + ' <<<') -ForegroundColor Black -BackgroundColor Yellow
Start-Process explorer.exe -ArgumentList ('/select,"' + $dst + '"')
