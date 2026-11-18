# MARCATORE_ESTRAI_NASUSD_M1_v2
# SOLA LETTURA del file sorgente. Copia le righe 2015-2024 di NASUSD_M1.csv (storico esterno, ora EST fissa) in UN ZIP PER ANNO dentro una cartella nuova sul Desktop. Non apre MT5, non tocca conti ne VPS, non modifica ne cancella il file sorgente (cancella solo i suoi CSV temporanei dopo averli zippati). Il 2025-2026 NON viene incluso (hold-out).
$ErrorActionPreference='Stop'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Write-Host ('SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; return }
$src=Join-Path $env:USERPROFILE 'abtg_storico_indici\NASUSD_M1.csv'
if(-not (Test-Path -LiteralPath $src)){ Write-Host ('File sorgente non trovato: ' + $src) -ForegroundColor Red; return }
$desk=[Environment]::GetFolderPath('Desktop')
$dir=Join-Path (Join-Path $desk 'ABTG_RISULTATI') ('NASUSD_PARTI_' + (Get-Date).ToString('yyyyMMdd_HHmm'))
[void](New-Item -ItemType Directory -Path $dir -Force)
Write-Host ('Leggo ' + $src + ' (1-3 minuti)...') -ForegroundColor Gray
$rd=New-Object IO.StreamReader($src); $intest=$rd.ReadLine()
$utf=New-Object Text.UTF8Encoding($false); $wr=$null; $annoCorr=0; $nr=0; $nAnno=0; $tot=0; $elenco=New-Object System.Collections.ArrayList
function ChiudiAnno([int]$a,[int]$n){
  $c=Join-Path $dir ('NASUSD_M1_' + $a + '.csv'); $z=Join-Path $dir ('NASUSD_M1_' + $a + '.zip')
  Compress-Archive -LiteralPath $c -DestinationPath $z -Force; Remove-Item -LiteralPath $c -Force
  $mb=[Math]::Round((Get-Item -LiteralPath $z).Length/1MB,1)
  Write-Host ('  ' + $a + ': ' + $n + ' righe, zip ' + $mb + ' MB') -ForegroundColor Green
  [void]$elenco.Add($z)
}
try{
  while($null -ne ($riga=$rd.ReadLine())){
    if($riga.Length -lt 16){ continue }
    $anno=0; if(-not [int]::TryParse($riga.Substring(0,4),[ref]$anno)){ continue }
    if($anno -lt 2015){ continue }
    if($anno -gt 2024){ break }
    if($anno -ne $annoCorr){
      if($null -ne $wr){ $wr.Close(); ChiudiAnno $annoCorr $nAnno }
      $annoCorr=$anno; $nAnno=0
      $wr=New-Object IO.StreamWriter((Join-Path $dir ('NASUSD_M1_' + $anno + '.csv')),$false,$utf); $wr.WriteLine($intest)
    }
    $wr.WriteLine($riga); $nAnno++; $tot++
  }
  if($null -ne $wr){ $wr.Close(); ChiudiAnno $annoCorr $nAnno }
} finally { if($null -ne $wr){ try{ $wr.Close() }catch{} }; $rd.Close() }
if($tot -lt 1000000){ Write-Host ('ATTENZIONE: solo ' + $tot + ' righe totali, meno del previsto. Non allegare nulla: avvisa Claude.') -ForegroundColor Red; return }
Write-Host ('Zip prodotti (' + $elenco.Count + ') nella cartella: ' + $dir) -ForegroundColor Green
Write-Host ('>>> ALLEGA TUTTI GLI ZIP DELLA CARTELLA (Ctrl+A, poi trascinali nella chat): ' + $dir + ' <<<') -ForegroundColor Black -BackgroundColor Yellow
try{ Set-Clipboard -Value $dir } catch { }
Start-Process explorer.exe -ArgumentList ('/select,"' + $elenco[0] + '"')
