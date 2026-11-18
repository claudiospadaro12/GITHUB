# MARCATORE_ESPORTA_SERIE_GIORNALIERE_v2
# SOLA LETTURA: cerca sul PC i risultati archiviati dei test a 4.000 EUR dei 4 EA forex di Wim (cartelle/zip ANNO4K_WIM_FOREX_*) e del trio oro sul conto reale (ANNO_ORO_GRADINI_R21_*), legge i report HTM del tester e ne ricava il profitto REALIZZATO per giorno. Non avvia MT5, non modifica niente, non scrive fuori da Desktop e TEMP. Criteri: report/PROBABILITA_RADDOPPIO_CRITERI_2026-11-18.md
$ErrorActionPreference='Continue'
$ci=[Globalization.CultureInfo]::InvariantCulture
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Write-Host ('SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; return }
function Num([string]$s){ $c=($s -replace '[^0-9.\-]',''); $v=0.0; if([double]::TryParse($c,[Globalization.NumberStyles]::Float,$ci,[ref]$v)){ return $v } else { return [double]::NaN } }
function LeggiTesto([string]$p){ $b=[IO.File]::ReadAllBytes($p); if($b.Length -ge 2 -and (($b[0] -eq 255 -and $b[1] -eq 254) -or ($b[0] -eq 254 -and $b[1] -eq 255))){ return [Text.Encoding]::Unicode.GetString($b) } else { return [Text.Encoding]::UTF8.GetString($b) } }
$desk=[Environment]::GetFolderPath('Desktop'); $roots=@((Join-Path $desk 'ABTG_RISULTATI'),$desk,(Join-Path $env:USERPROFILE 'Downloads'),(Join-Path $env:USERPROFILE 'Documents')) | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -Unique
$pat='^(ANNO4K_WIM_FOREX_\d{8}_\d{4}|ANNO_ORO_GRADINI_R21_)'
$dirs=New-Object System.Collections.ArrayList; $zips=New-Object System.Collections.ArrayList
foreach($r in $roots){
  foreach($d in @(Get-ChildItem -LiteralPath $r -Directory -Recurse -Depth 3 -ErrorAction SilentlyContinue | Where-Object { $_.Name -match $pat })){ [void]$dirs.Add($d.FullName) }
  foreach($z in @(Get-ChildItem -LiteralPath $r -File -Recurse -Depth 3 -Filter '*.zip' -ErrorAction SilentlyContinue | Where-Object { $_.BaseName -match $pat })){ [void]$zips.Add($z) }
}
$tmp=Join-Path $env:TEMP 'serie_giornaliere_rolling'; New-Item -ItemType Directory -Force -Path $tmp | Out-Null
foreach($z in $zips){ if(@($dirs | Where-Object { (Split-Path $_ -Leaf) -eq $z.BaseName }).Count -eq 0){ $dd=Join-Path $tmp $z.BaseName; if(-not (Test-Path -LiteralPath $dd)){ Write-Host ('Espando ' + $z.FullName) -ForegroundColor Gray; try { Expand-Archive -LiteralPath $z.FullName -DestinationPath $dd -Force } catch { Write-Host ('NON espandibile: ' + $z.FullName) -ForegroundColor Red; continue } }; [void]$dirs.Add($dd) } }
$dirs=@($dirs | Select-Object -Unique)
if($dirs.Count -eq 0){ Write-Host 'NESSUNA cartella o zip ANNO4K_WIM_FOREX_* / ANNO_ORO_GRADINI_R21* trovata in Desktop, ABTG_RISULTATI, Download, Documenti. Dimmi dove sono i risultati dei test a 4.000 EUR dei forex.' -ForegroundColor Black -BackgroundColor Yellow; return }
Write-Host ('Cartelle/zip dei test trovati: ' + $dirs.Count) -ForegroundColor Cyan
$out=New-Object System.Collections.ArrayList; [void]$out.Add('sorgente;percorso_relativo;data;pnl_realizzato_EUR;deposito_EUR'); $nrep=0
foreach($d in $dirs){
  foreach($h in @(Get-ChildItem -LiteralPath $d -Recurse -File -Filter '*.htm' -ErrorAction SilentlyContinue | Where-Object { $_.DirectoryName -match '\\report$' })){
    $html=LeggiTesto $h.FullName; $inDeals=$false; $iDi=-1; $iBa=-1; $dep=0.0; $prev=0.0; $giorni=@{}
    foreach($rg in [regex]::Split($html,'(?i)<tr')){
      $celle=@(); foreach($mc in [regex]::Matches($rg,'(?is)<t[dh][^>]*>(.*?)</t[dh]>')){ $celle += (([regex]::Replace($mc.Groups[1].Value,'<[^>]*>','') -replace '&nbsp;',' ' -replace '\s+',' ').Trim()) }
      if($celle.Count -lt 8){ continue }
      $p1=-1; $d1=-1; $b1=-1
      for($i=0; $i -lt $celle.Count; $i++){ if($celle[$i] -match '^(Profit|Profitto|Utile)$'){ $p1=$i } elseif($celle[$i] -match '^(Direction|Direzione)$'){ $d1=$i } elseif($celle[$i] -match '^(Balance|Bilancio|Saldo)$'){ $b1=$i } }
      if($p1 -ge 0 -and $d1 -ge 0 -and $b1 -ge 0){ $inDeals=$true; $iDi=$d1; $iBa=$b1; continue }
      if(-not $inDeals){ continue }
      if($celle[0] -notmatch '^(\d{4})\.(\d{2})\.(\d{2}) \d{2}:\d{2}:\d{2}$'){ continue }
      if($celle.Count -le $iBa){ continue }
      $dir=$celle[$iDi]; $bal=Num $celle[$iBa]
      if($dir -eq ''){ if($dep -eq 0.0){ $dep=$bal; $prev=$bal }; continue }
      if($dir -ne 'out'){ continue }
      $kd=$celle[0].Substring(0,10); $pn=$bal-$prev; $prev=$bal
      if($giorni.ContainsKey($kd)){ $giorni[$kd]=$giorni[$kd]+$pn } else { $giorni[$kd]=$pn }
    }
    $rel=$h.FullName.Substring($d.Length).TrimStart('\')
    foreach($k in ($giorni.Keys | Sort-Object)){ [void]$out.Add((Split-Path $d -Leaf) + ';' + $rel + ';' + $k + ';' + $giorni[$k].ToString('0.00',$ci) + ';' + $dep.ToString('0',$ci)) }
    $nrep++; Write-Host ('[' + (Get-Date).ToString('HH:mm:ss') + '] report ' + $nrep + ': ' + $rel + ' (' + $giorni.Count + ' giorni)') -ForegroundColor Gray
  }
}
$dirOut=Join-Path $desk 'SERIE_GIORNALIERE_ROLLING'; New-Item -ItemType Directory -Force -Path $dirOut | Out-Null
$f=Join-Path $dirOut 'SERIE_GIORNALIERE.csv'; Set-Content -LiteralPath $f -Value ($out -join "`r`n") -Encoding UTF8
$zip=Join-Path $desk 'SERIE_GIORNALIERE_ROLLING.zip'; Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
try { Compress-Archive -Path (Join-Path $dirOut '*') -DestinationPath $zip -Force } catch { Write-Host 'ZIP non creato: allega il CSV a mano.' -ForegroundColor Red }
Write-Host ('Report letti: ' + $nrep + '; righe giornaliere: ' + ($out.Count-1)) -ForegroundColor Green
Write-Host ''
Write-Host '##########  FILE DA ALLEGARE ALLA CHAT  ##########' -ForegroundColor Black -BackgroundColor Yellow
Write-Host $zip -ForegroundColor Black -BackgroundColor Yellow
Write-Host '(contiene: SERIE_GIORNALIERE.csv; Esplora file si apre con lo zip selezionato)' -ForegroundColor Black -BackgroundColor Yellow
try { Start-Process -FilePath 'explorer.exe' -ArgumentList ('/select,"' + $zip + '"') } catch { }
