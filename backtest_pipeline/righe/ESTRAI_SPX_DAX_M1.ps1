# MARCATORE_ESTRAI_SPX_DAX_M1_v1
# SOLA LETTURA dei file sorgente. Copia le righe di SPXUSD_M1.csv (S&P 500, 2015-2024) e di D30EUR_M1.csv (DAX, 2019-2024), storici esterni, in UN ZIP PER ANNO dentro una cartella nuova sul Desktop. Non apre MT5, non tocca conti ne VPS, non modifica ne cancella i file sorgente (cancella solo i suoi CSV temporanei dopo averli zippati). Il 2025-2026 NON viene incluso (hold-out).
$ErrorActionPreference='Stop'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Write-Host ('SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; return }
$lavori=@(
  @{ nome='SPXUSD'; src=(Join-Path $env:USERPROFILE 'abtg_storico_indici\SPXUSD_M1.csv'); da=2015; a=2024 },
  @{ nome='D30EUR'; src=(Join-Path $env:USERPROFILE 'histdata_m1\D30EUR_M1.csv'); da=2019; a=2024 }
)
foreach($lv in $lavori){ if(-not (Test-Path -LiteralPath $lv.src)){ Write-Host ('File sorgente non trovato: ' + $lv.src) -ForegroundColor Red; return } }
$dir=Join-Path (Join-Path ([Environment]::GetFolderPath('Desktop')) 'ABTG_RISULTATI') ('SPX_DAX_PARTI_' + (Get-Date).ToString('yyyyMMdd_HHmm'))
[void](New-Item -ItemType Directory -Path $dir -Force)
$elenco=New-Object System.Collections.ArrayList; $utf=New-Object Text.UTF8Encoding($false)
foreach($lv in $lavori){
  Write-Host ('Leggo ' + $lv.src + ' (1-3 minuti)...') -ForegroundColor Gray
  $rd=New-Object IO.StreamReader($lv.src); $intest=$rd.ReadLine(); $wr=$null; $annoCorr=0; $nAnno=0; $tot=0
  try{
    while($null -ne ($riga=$rd.ReadLine())){
      if($riga.Length -lt 16){ continue }
      $anno=0; if(-not [int]::TryParse($riga.Substring(0,4),[ref]$anno)){ continue }
      if($anno -lt $lv.da){ continue }
      if($anno -gt $lv.a){ break }
      if($anno -ne $annoCorr){
        if($null -ne $wr){
          $wr.Close(); $c=Join-Path $dir ($lv.nome + '_M1_' + $annoCorr + '.csv'); $z=Join-Path $dir ($lv.nome + '_M1_' + $annoCorr + '.zip')
          Compress-Archive -LiteralPath $c -DestinationPath $z -Force; Remove-Item -LiteralPath $c -Force; [void]$elenco.Add($z)
          Write-Host ('  ' + $lv.nome + ' ' + $annoCorr + ': ' + $nAnno + ' righe, zip ' + [Math]::Round((Get-Item -LiteralPath $z).Length/1MB,1) + ' MB') -ForegroundColor Green
        }
        $annoCorr=$anno; $nAnno=0
        $wr=New-Object IO.StreamWriter((Join-Path $dir ($lv.nome + '_M1_' + $anno + '.csv')),$false,$utf); $wr.WriteLine($intest)
      }
      $wr.WriteLine($riga); $nAnno++; $tot++
    }
    if($null -ne $wr){
      $wr.Close(); $wr=$null; $c=Join-Path $dir ($lv.nome + '_M1_' + $annoCorr + '.csv'); $z=Join-Path $dir ($lv.nome + '_M1_' + $annoCorr + '.zip')
      Compress-Archive -LiteralPath $c -DestinationPath $z -Force; Remove-Item -LiteralPath $c -Force; [void]$elenco.Add($z)
      Write-Host ('  ' + $lv.nome + ' ' + $annoCorr + ': ' + $nAnno + ' righe, zip ' + [Math]::Round((Get-Item -LiteralPath $z).Length/1MB,1) + ' MB') -ForegroundColor Green
    }
  } finally { if($null -ne $wr){ try{ $wr.Close() }catch{} }; $rd.Close() }
  if($tot -lt 500000){ Write-Host ('ATTENZIONE: ' + $lv.nome + ' solo ' + $tot + ' righe, meno del previsto. Non allegare nulla: avvisa Claude.') -ForegroundColor Red; return }
}
Write-Host ('Zip prodotti (' + $elenco.Count + ') nella cartella: ' + $dir) -ForegroundColor Green
Write-Host ('>>> ALLEGA TUTTI GLI ZIP DELLA CARTELLA (Ctrl+A, poi trascinali nella chat): ' + $dir + ' <<<') -ForegroundColor Black -BackgroundColor Yellow
try{ Set-Clipboard -Value $dir } catch { }
Start-Process explorer.exe -ArgumentList ('/select,"' + $elenco[0] + '"')
