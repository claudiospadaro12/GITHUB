# MARCATORE_ESTRAI_INDICI_2010_2014_v1
# SOLA LETTURA dei file sorgente. Copia le righe 2010-2014 (se presenti) di NASUSD_M1.csv e SPXUSD_M1.csv (storici esterni) in UN ZIP PER ANNO dentro una cartella nuova sul Desktop. Non apre MT5, non tocca conti ne VPS, non modifica ne cancella i sorgenti (cancella solo i suoi CSV temporanei dopo averli zippati).
$ErrorActionPreference='Stop'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Write-Host ('SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; return }
$dir=Join-Path (Join-Path ([Environment]::GetFolderPath('Desktop')) 'ABTG_RISULTATI') ('INDICI_2010_2014_' + (Get-Date).ToString('yyyyMMdd_HHmm'))
[void](New-Item -ItemType Directory -Path $dir -Force)
$utf=New-Object Text.UTF8Encoding($false); $elenco=New-Object System.Collections.ArrayList
foreach($nome in @('NASUSD','SPXUSD')){
  $src=Join-Path $env:USERPROFILE ('abtg_storico_indici\' + $nome + '_M1.csv')
  if(-not (Test-Path -LiteralPath $src)){ Write-Host ('Sorgente non trovato: ' + $src) -ForegroundColor Red; continue }
  Write-Host ('Leggo ' + $src + ' ...') -ForegroundColor Gray
  $rd=New-Object IO.StreamReader($src); $intest=$rd.ReadLine(); $wr=$null; $annoCorr=0; $n=0; $primo=''
  function Chiudi([string]$nm,[int]$a,[int]$righe){ $c=Join-Path $dir ($nm + '_M1_' + $a + '.csv'); $z=Join-Path $dir ($nm + '_M1_' + $a + '.zip'); Compress-Archive -LiteralPath $c -DestinationPath $z -Force; Remove-Item -LiteralPath $c -Force; Write-Host ('  ' + $nm + ' ' + $a + ': ' + $righe + ' righe, zip ' + [Math]::Round((Get-Item -LiteralPath $z).Length/1MB,1) + ' MB') -ForegroundColor Green; [void]$elenco.Add($z) }
  try{
    while($null -ne ($riga=$rd.ReadLine())){
      if($riga.Length -lt 16){ continue }
      $anno=0; if(-not [int]::TryParse($riga.Substring(0,4),[ref]$anno)){ continue }
      if($primo -eq ''){ $primo=$riga.Substring(0,16) }
      if($anno -lt 2010){ continue }
      if($anno -gt 2014){ break }
      if($anno -ne $annoCorr){ if($null -ne $wr){ $wr.Close(); Chiudi $nome $annoCorr $n }; $annoCorr=$anno; $n=0; $wr=New-Object IO.StreamWriter((Join-Path $dir ($nome + '_M1_' + $anno + '.csv')),$false,$utf); $wr.WriteLine($intest) }
      $wr.WriteLine($riga); $n++
    }
    if($null -ne $wr){ $wr.Close(); Chiudi $nome $annoCorr $n }
  } finally { if($null -ne $wr){ try{ $wr.Close() }catch{} }; $rd.Close() }
  Write-Host ($nome + ': prima riga del file = ' + $primo) -ForegroundColor Gray
}
if($elenco.Count -eq 0){ Write-Host 'Nessun dato 2010-2014 nei sorgenti: avvisa Claude (scrivi quale e la prima riga stampata sopra).' -ForegroundColor Red; return }
Write-Host ('>>> ALLEGA TUTTI GLI ZIP DELLA CARTELLA (Ctrl+A, poi trascinali nella chat): ' + $dir + ' <<<') -ForegroundColor Black -BackgroundColor Yellow
try{ Set-Clipboard -Value $dir } catch { }
Start-Process explorer.exe -ArgumentList ('/select,"' + $elenco[0] + '"')
