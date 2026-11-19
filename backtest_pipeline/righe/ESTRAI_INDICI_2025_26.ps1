# MARCATORE_ESTRAI_INDICI_2025_26_v1
# SOLA LETTURA dei file sorgente. Copia le righe 2025-2026 di NASUSD_M1.csv e SPXUSD_M1.csv (storico esterno, ora EST fissa, STESSO file da cui sono usciti gli zip 2015-2024) in UN ZIP PER SIMBOLO E ANNO dentro una cartella nuova sul Desktop. Non apre MT5, non tocca conti ne VPS, non modifica ne cancella i file sorgente (cancella solo i suoi CSV temporanei dopo averli zippati). Scopo: dati mai usati per il test Donchian (hold-out).
$ErrorActionPreference='Stop'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Write-Host ('SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; return }
$lavori=@(
  @{ nome='NASUSD'; src=(Join-Path $env:USERPROFILE 'abtg_storico_indici\NASUSD_M1.csv') },
  @{ nome='SPXUSD'; src=(Join-Path $env:USERPROFILE 'abtg_storico_indici\SPXUSD_M1.csv') }
)
foreach($lv in $lavori){ if(-not (Test-Path -LiteralPath $lv.src)){ Write-Host ('File sorgente non trovato: ' + $lv.src) -ForegroundColor Red; return } }
$dir=Join-Path (Join-Path ([Environment]::GetFolderPath('Desktop')) 'ABTG_RISULTATI') ('INDICI_2025_26_' + (Get-Date).ToString('yyyyMMdd_HHmm'))
[void](New-Item -ItemType Directory -Path $dir -Force)
$elenco=New-Object System.Collections.ArrayList; $utf=New-Object Text.UTF8Encoding($false); $riep=New-Object System.Collections.ArrayList
foreach($lv in $lavori){
  $ultima=(Get-Content -LiteralPath $lv.src -Tail 1)
  Write-Host ($lv.nome + ': ultima riga del file sorgente: ' + $ultima) -ForegroundColor Gray
  Write-Host ('Leggo ' + $lv.src + ' (1-3 minuti)...') -ForegroundColor Gray
  $rd=New-Object IO.StreamReader($lv.src); $intest=$rd.ReadLine(); $wr=$null; $annoCorr=0; $nAnno=0; $tot=0; $primo=''; $ultimo=''
  try{
    while($null -ne ($riga=$rd.ReadLine())){
      if($riga.Length -lt 16){ continue }
      $anno=0; if(-not [int]::TryParse($riga.Substring(0,4),[ref]$anno)){ continue }
      if($anno -lt 2025){ continue }
      if($anno -ne $annoCorr){
        if($null -ne $wr){
          $wr.Close(); $c=Join-Path $dir ($lv.nome + '_M1_' + $annoCorr + '.csv'); $z=Join-Path $dir ($lv.nome + '_M1_' + $annoCorr + '.zip')
          Compress-Archive -LiteralPath $c -DestinationPath $z -Force; Remove-Item -LiteralPath $c -Force; [void]$elenco.Add($z)
          Write-Host ('  ' + $lv.nome + ' ' + $annoCorr + ': ' + $nAnno + ' righe, zip ' + [Math]::Round((Get-Item -LiteralPath $z).Length/1MB,1) + ' MB') -ForegroundColor Green
        }
        $annoCorr=$anno; $nAnno=0
        $wr=New-Object IO.StreamWriter((Join-Path $dir ($lv.nome + '_M1_' + $anno + '.csv')),$false,$utf); $wr.WriteLine($intest)
      }
      if($primo -eq ''){ $primo=$riga.Substring(0,16) }; $ultimo=$riga.Substring(0,16)
      $wr.WriteLine($riga); $nAnno++; $tot++
    }
    if($null -ne $wr){
      $wr.Close(); $wr=$null; $c=Join-Path $dir ($lv.nome + '_M1_' + $annoCorr + '.csv'); $z=Join-Path $dir ($lv.nome + '_M1_' + $annoCorr + '.zip')
      Compress-Archive -LiteralPath $c -DestinationPath $z -Force; Remove-Item -LiteralPath $c -Force; [void]$elenco.Add($z)
      Write-Host ('  ' + $lv.nome + ' ' + $annoCorr + ': ' + $nAnno + ' righe, zip ' + [Math]::Round((Get-Item -LiteralPath $z).Length/1MB,1) + ' MB') -ForegroundColor Green
    }
  } finally { if($null -ne $wr){ try{ $wr.Close() }catch{} }; $rd.Close() }
  [void]$riep.Add($lv.nome + ': ' + $tot + ' righe dal ' + $primo + ' al ' + $ultimo)
  Write-Host ($lv.nome + ': ' + $tot + ' righe 2025-26, dal ' + $primo + ' al ' + $ultimo) -ForegroundColor Cyan
  if($tot -lt 50000){ Write-Host ('ATTENZIONE: ' + $lv.nome + ' ha solo ' + $tot + ' righe nel 2025-26 (il file sorgente potrebbe finire prima). Non allegare nulla e avvisa Claude.') -ForegroundColor Red; return }
}
$riepFile=Join-Path $dir 'RIEPILOGO.txt'; Set-Content -LiteralPath $riepFile -Value $riep -Encoding UTF8
Write-Host ('Zip prodotti (' + $elenco.Count + ') + RIEPILOGO.txt nella cartella: ' + $dir) -ForegroundColor Green
Write-Host ('>>> ALLEGA TUTTI I FILE DELLA CARTELLA (Ctrl+A, poi trascinali nella chat): ' + $dir + ' <<<') -ForegroundColor Black -BackgroundColor Yellow
try{ Set-Clipboard -Value $dir } catch { }
Start-Process explorer.exe -ArgumentList ('/select,"' + $elenco[0] + '"')
