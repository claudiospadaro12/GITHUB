# MARCATORE_RIDUCI_LIBRARY_PACK_v1
# SOLA LETTURA sul pacchetto originale (non lo modifica, non lo cancella). Cerca lo zip "UBS Library pack" sul PC, ne stampa il contenuto per tipo di file,
# e crea UNO zip ridotto con i soli file utili alla lettura (set, json, csv, md, txt, xml, ini, log; html/pdf piccoli) entro un tetto di MB compressi,
# piu l'elenco completo di TUTTI i file. Non apre MT5, non usa la rete, non tocca conti/VPS/reale.
param([double]$TettoMB = 20)
$ErrorActionPreference='Stop'
$INV=[Globalization.CultureInfo]::InvariantCulture
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem
$cerca=@([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Downloads'),(Join-Path $env:USERPROFILE 'Documents'),'C:\ABTG_RISULTATI')
$trovati=@()
foreach($d in $cerca){ if(Test-Path -LiteralPath $d){ $trovati += @(Get-ChildItem -LiteralPath $d -Recurse -Depth 3 -File -Filter *.zip -ErrorAction SilentlyContinue | Where-Object { $_.Name -match '(?i)library.?pack' }) } }
if($trovati.Count -eq 0){ Write-Host 'NON TROVO nessuno zip con "library pack" nel nome in Desktop, Download, Documenti, C:\ABTG_RISULTATI (anche nelle sottocartelle, es. Downloads\Telegram Desktop).' -ForegroundColor Red; Write-Host 'Dimmi dove e salvato (percorso completo) e rilancio.'; return }
$src=($trovati | Sort-Object LastWriteTime -Descending | Select-Object -First 1)
Write-Host ('Pacchetto trovato: ' + $src.FullName + '  (' + [math]::Round($src.Length/1MB,1).ToString($INV) + ' MB)') -ForegroundColor Green
$za=[IO.Compression.ZipFile]::OpenRead($src.FullName)
try {
  $voci=@($za.Entries | Where-Object { $_.Name -ne '' })
  $out='C:\ABTG_RISULTATI'; if(-not (Test-Path -LiteralPath $out)){ New-Item -ItemType Directory -Force -Path $out | Out-Null }
  $stamp=(Get-Date).ToString('yyyyMMdd_HHmm',$INV)
  $elenco=Join-Path $out ('LIBRARY_PACK_ELENCO_' + $stamp + '.txt')
  $righe=New-Object System.Collections.ArrayList
  [void]$righe.Add('percorso;byte_non_compressi;byte_compressi;data')
  foreach($e in $voci){ [void]$righe.Add($e.FullName + ';' + $e.Length + ';' + $e.CompressedLength + ';' + $e.LastWriteTime.ToString('yyyy-MM-dd HH:mm',$INV)) }
  Set-Content -LiteralPath $elenco -Value ($righe -join "`r`n") -Encoding UTF8
  Write-Host ''
  Write-Host ('File nello zip: ' + $voci.Count + '. Per tipo (estensione: numero, MB non compressi, MB compressi):')
  $voci | Group-Object { [IO.Path]::GetExtension($_.Name).ToLowerInvariant() } | Sort-Object { ($_.Group | Measure-Object CompressedLength -Sum).Sum } -Descending | ForEach-Object {
    $su=($_.Group | Measure-Object Length -Sum).Sum; $sc=($_.Group | Measure-Object CompressedLength -Sum).Sum
    Write-Host ('  ' + $(if($_.Name){ $_.Name } else { '(senza)' }) + ': ' + $_.Count + ', ' + [math]::Round($su/1MB,1).ToString($INV) + ' MB, ' + [math]::Round($sc/1MB,1).ToString($INV) + ' MB')
  }
  Write-Host 'I 12 file piu pesanti (compressi):'
  foreach($e in @($voci | Sort-Object CompressedLength -Descending | Select-Object -First 12)){ Write-Host ('  ' + [math]::Round($e.CompressedLength/1MB,2).ToString($INV) + ' MB  ' + $e.FullName) }
  # selezione: priorita ai file di testo piccoli; html/pdf per ultimi
  $prio=@{ '.set'=1; '.json'=1; '.csv'=1; '.tsv'=1; '.md'=1; '.txt'=1; '.xml'=1; '.ini'=1; '.yaml'=1; '.yml'=1; '.log'=2; '.htm'=3; '.html'=3; '.pdf'=4 }
  $cand=@()
  foreach($e in $voci){
    $x=[IO.Path]::GetExtension($e.Name).ToLowerInvariant()
    if(-not $prio.ContainsKey($x)){ continue }
    if($e.Length -gt 5MB){ continue }
    if(($x -eq '.html' -or $x -eq '.htm') -and $e.Length -gt 1MB){ continue }
    if($x -eq '.pdf' -and $e.Length -gt 3MB){ continue }
    $cand += [pscustomobject]@{ E=$e; P=$prio[$x] }
  }
  $cand = @($cand | Sort-Object P, @{Expression={$_.E.Length}})
  $zout=Join-Path $out ('LIBRARY_PACK_RIDOTTO_' + $stamp + '.zip')
  if(Test-Path -LiteralPath $zout){ Remove-Item -LiteralPath $zout -Force }
  $zo=[IO.Compression.ZipFile]::Open($zout,[IO.Compression.ZipArchiveMode]::Create)
  $somma=0.0; $tetto=$TettoMB*1MB; $presi=0; $saltati=0
  try {
    foreach($c in $cand){
      $e=$c.E
      if(($somma + $e.CompressedLength) -gt $tetto){ $saltati++; continue }
      $ne=$zo.CreateEntry($e.FullName,[IO.Compression.CompressionLevel]::Optimal)
      $si=$e.Open(); $so=$ne.Open()
      try { $si.CopyTo($so) } finally { $so.Dispose(); $si.Dispose() }
      $somma += $e.CompressedLength; $presi++
    }
    $ne2=$zo.CreateEntry('LIBRARY_PACK_ELENCO.txt',[IO.Compression.CompressionLevel]::Optimal)
    $so2=$ne2.Open(); $bytes=[Text.Encoding]::UTF8.GetBytes(($righe -join "`r`n")); $so2.Write($bytes,0,$bytes.Length); $so2.Dispose()
  } finally { $zo.Dispose() }
} finally { $za.Dispose() }
$dim=(Get-Item -LiteralPath $zout).Length
Write-Host ''
Write-Host ('Inclusi: ' + $presi + ' file; esclusi per tipo o per dimensione: ' + ($voci.Count - $presi - $saltati) + '; saltati per il tetto di ' + $TettoMB.ToString($INV) + ' MB: ' + $saltati)
Write-Host ('Zip ridotto: ' + [math]::Round($dim/1MB,2).ToString($INV) + ' MB')
if($dim -gt 25MB){ Write-Host 'ATTENZIONE: ancora sopra 25 MB. Rilancia con un tetto piu basso aggiungendo -TettoMB 10 al comando.' -ForegroundColor Yellow }
Write-Host ('File prodotti: 1) ' + $zout + '   2) ' + $elenco + ' (l elenco e gia dentro lo zip)')
Write-Host ('>>> ALLEGA QUESTO ZIP ALLA CHAT: ' + $zout + ' <<<') -ForegroundColor Black -BackgroundColor Yellow
Start-Process explorer.exe -ArgumentList ('/select,"' + $zout + '"')
