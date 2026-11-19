# MARCATORE_CERCA_EXCEL_BULGE_v1
# SOLA LETTURA: cerca su tutti i dischi di QUESTO PC i file Excel/foglio di calcolo (xlsx, xlsm, xlsb, xls, csv, ods) il cui NOME richiama il Bulge/Breaking Band/Bollinger/Fasciano, oppure il cui CONTENUTO (nomi dei fogli, testi, titolo) cita bulge, breaking band, bollinger, uccellino o Fasciano. Scrive un elenco (CSV) sul Desktop. Non apre in Excel, non sposta, non scarica, non cancella, non modifica niente.
$ErrorActionPreference='Continue'
$ci=[Globalization.CultureInfo]::InvariantCulture
Write-Host ('PC: ' + $env:COMPUTERNAME + ' - ricerca dei fogli di calcolo in corso (puo durare diversi minuti)') -ForegroundColor Cyan
try { Add-Type -AssemblyName System.IO.Compression.FileSystem } catch { }
$drives=@(Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Root -match '^[A-Za-z]:\\$' } | ForEach-Object { $_.Root })
$ext=@('xlsx','xlsm','xlsb','xls','csv','ods')
$rxEsc='(?i)\\(Windows|Program Files|Program Files \(x86\)|ProgramData|\$Recycle\.Bin|node_modules|bases|Tester|WinSxS)\\'
$rxNome='(?i)bulge|breaking|bollinger|uccellin|fasciano|in-bulge|bband'
$rxCont='(?i)bulge|breaking ?band|bollinger|uccellin|fasciano'
$out=New-Object System.Collections.ArrayList; [void]$out.Add('tipo;percorso;KB;ultima_modifica;motivo')
$visti=@{}; $esaminati=0
function CercaZip([string]$p){
  $trovato=''
  try {
    $z=[IO.Compression.ZipFile]::OpenRead($p)
    try {
      foreach($e in $z.Entries){
        $nm=$e.FullName
        if($nm -eq 'xl/sharedStrings.xml' -or $nm -eq 'xl/workbook.xml' -or $nm -eq 'docProps/core.xml' -or $nm -eq 'content.xml'){
          if($e.Length -gt 40MB){ continue }
          $sr=New-Object IO.StreamReader($e.Open()); $tx=$sr.ReadToEnd(); $sr.Close()
          $m=[regex]::Match($tx,$rxCont)
          if($m.Success){ $trovato=('contenuto:' + $m.Value + ' in ' + $nm); break }
        }
      }
    } finally { $z.Dispose() }
  } catch { }
  return $trovato
}
function CercaBytes([string]$p){
  try {
    $fs=[IO.File]::Open($p,[IO.FileMode]::Open,[IO.FileAccess]::Read,[IO.FileShare]::ReadWrite)
    try { $n=[int][Math]::Min($fs.Length,5MB); $b=New-Object byte[] $n; [void]$fs.Read($b,0,$n) } finally { $fs.Close() }
    $t1=[Text.Encoding]::ASCII.GetString($b); $m=[regex]::Match($t1,$rxCont); if($m.Success){ return ('contenuto:' + $m.Value) }
    $t2=[Text.Encoding]::Unicode.GetString($b); $m=[regex]::Match($t2,$rxCont); if($m.Success){ return ('contenuto:' + $m.Value) }
  } catch { }
  return ''
}
foreach($r in $drives){
  Write-Host ('  disco ' + $r + ' ...') -ForegroundColor Gray
  $pv=@($ext | ForEach-Object { '"' + $r + '*.' + $_ + '"' }) -join ' '
  $lst=@(cmd /c ('dir ' + $pv + ' /s /b /a-d 2>nul'))
  foreach($p in $lst){
    if($p -match $rxEsc){ continue }
    if($visti.ContainsKey($p)){ continue }; $visti[$p]=1
    try { $fi=Get-Item -LiteralPath $p -ErrorAction Stop } catch { continue }
    $esaminati++
    $motivo=''
    if(($fi.Name -match $rxNome) -or ($fi.DirectoryName -match $rxNome)){ $motivo='nome' }
    if($fi.Length -lt 40MB -and $fi.Length -gt 0){
      $c=''
      $e=$fi.Extension.ToLowerInvariant()
      if($e -eq '.xlsx' -or $e -eq '.xlsm' -or $e -eq '.xlsb' -or $e -eq '.ods'){ $c=CercaZip $fi.FullName }
      elseif($e -eq '.xls' -or $e -eq '.csv'){ $c=CercaBytes $fi.FullName }
      if($c -ne ''){ if($motivo -ne ''){ $motivo=$motivo + ' + ' + $c } else { $motivo=$c } }
    }
    if($motivo -ne ''){ [void]$out.Add('foglio;' + $p + ';' + [math]::Round($fi.Length/1KB) + ';' + $fi.LastWriteTime.ToString('yyyy-MM-dd HH:mm') + ';' + $motivo) }
  }
}
$desk=[Environment]::GetFolderPath('Desktop'); $dirOut=Join-Path $desk 'CERCA_EXCEL_BULGE'; New-Item -ItemType Directory -Force -Path $dirOut | Out-Null
$f=Join-Path $dirOut 'ELENCO_EXCEL_BULGE.csv'; Set-Content -LiteralPath $f -Value ($out -join "`r`n") -Encoding UTF8
try { Set-Clipboard -Value ($out -join "`r`n") } catch { }
Write-Host ''
Write-Host ('Fogli di calcolo esaminati: ' + $esaminati + '. Trovati con nome o contenuto che richiama il bulge: ' + ($out.Count-1)) -ForegroundColor Green
$out | Select-Object -Skip 1 -First 30 | ForEach-Object { Write-Host $_ }
Write-Host ''
Write-Host '##########  FILE DA ALLEGARE ALLA CHAT  ##########' -ForegroundColor Black -BackgroundColor Yellow
Write-Host $f -ForegroundColor Black -BackgroundColor Yellow
Write-Host '(un solo CSV con l elenco dei file trovati; Esplora file si apre con il file selezionato; l elenco e anche negli appunti. Poi dimmi quali aprire e te li chiedo uno per uno)' -ForegroundColor Black -BackgroundColor Yellow
try { Start-Process -FilePath 'explorer.exe' -ArgumentList ('/select,"' + $f + '"') } catch { }
