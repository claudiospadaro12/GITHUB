# MARCATORE_CONTROLLO_UBS_FILE_v1
# SOLA LETTURA. Cerca sul PC: (1) gli zip dei set UBS (Ultimate-Breakout-System-Set-Files, TG_SET_PARTE*, SET_FOR_SALE, UBS_LIBPACK, UBS_GTPD1_SET e simili) sul Desktop, in Download, in Documenti e nel Desktop OneDrive; (2) l'EA Ultimate_Breakout_EA_WSC_V*.ex5 in OGNI cartella dati MT5 e nei terminali portatili (Experts, Experts\WIM, Market). Non apre MT5, non copia ne cancella niente. Scrive un referto TXT sul Desktop.
$ErrorActionPreference='Continue'; $ci=[Globalization.CultureInfo]::InvariantCulture
$out=New-Object System.Collections.ArrayList
function R($s){ [void]$out.Add($s); Write-Host $s }
R ('CONTROLLO FILE UBS - PC ' + $env:COMPUTERNAME + ' - ' + (Get-Date).ToString('yyyy-MM-dd HH:mm',$ci))
$home1=$env:USERPROFILE; $dirs=New-Object System.Collections.ArrayList
foreach($d in @([Environment]::GetFolderPath('Desktop'), (Join-Path $home1 'Downloads'), (Join-Path $home1 'Documents'), (Join-Path $home1 'OneDrive\Desktop'), (Join-Path $home1 'OneDrive\Documents'), (Join-Path $home1 'abtg_wim_sets'))){ if((Test-Path -LiteralPath $d) -and -not ($dirs -contains $d)){ [void]$dirs.Add($d) } }
R ''; R '== 1. ZIP DEI SET (cartelle cercate: ' + ($dirs -join ' | ') + ') =='
$rxz='(?i)(Ultimate-Breakout|UBS|TG_SET|SET_FOR_SALE|LIBPACK|GTPD1|CHRISTMAS|BREAKOUT.*SET|SET.*FILES)'
$trovati=0
foreach($d in $dirs){ foreach($f in @(Get-ChildItem -LiteralPath $d -Filter *.zip -File -Recurse -Depth 2 -ErrorAction SilentlyContinue | Where-Object { $_.Name -match $rxz })){ $trovati++; R ('  ZIP  ' + $f.Name + '  ' + ($f.Length/1MB).ToString('0.0',$ci) + ' MB  ' + $f.LastWriteTime.ToString('yyyy-MM-dd') + '  ' + $f.DirectoryName) } }
if($trovati -eq 0){ R '  NESSUNO ZIP DI SET TROVATO nelle cartelle sopra.' }
$cercati=@('Ultimate-Breakout-System-Set-Files','TG_SET_PARTE1','TG_SET_PARTE2','TG_SET_PARTE3','TG_SET_PARTE4','TG_SET_PARTE5','TG_SET_PARTE6','SET_FOR_SALE','UBS_LIBPACK')
R ''; R '  Attesi dal piano: ' + ($cercati -join ', ')
$tutti=@(); foreach($d in $dirs){ $tutti += @(Get-ChildItem -LiteralPath $d -Filter *.zip -File -Recurse -Depth 2 -ErrorAction SilentlyContinue) }
foreach($c in $cercati){ $m=@($tutti | Where-Object { $_.Name -like ('*' + $c + '*') }); if($m.Count -gt 0){ R ('  [OK]      ' + $c + '  ->  ' + $m[0].FullName + $(if($m.Count -gt 1){ '  (+' + ($m.Count-1) + ' copie)' } else { '' })) } else { R ('  [MANCA]   ' + $c) } }
R ''; R '== 2. EA UBS (Ultimate_Breakout_EA_WSC_V*.ex5) nei terminali MT5 =='
$radici=New-Object System.Collections.ArrayList; $baseT=Join-Path $env:APPDATA 'MetaQuotes\Terminal'
foreach($o in @(Get-ChildItem -LiteralPath $baseT -Directory -ErrorAction SilentlyContinue)){ $orig=''; $of=Join-Path $o.FullName 'origin.txt'; if(Test-Path -LiteralPath $of){ $orig=((Get-Content -LiteralPath $of -Raw -Encoding Unicode) -replace '[\r\n\0]','').Trim() }; if(Test-Path -LiteralPath (Join-Path $o.FullName 'MQL5')){ [void]$radici.Add(@{ dati=$o.FullName; et=('APPDATA ' + $orig) }) } }
foreach($pp in @('C:\MT5_BCM_Opt','C:\MT5_BCM_Tester2','C:\MT5_Backtest\Mt5_Ftmo_Prova','C:\MT5_Wim','C:\MT5_MANUALE','C:\FTMO','C:\FundedNext_Manuale')){ if(Test-Path -LiteralPath (Join-Path $pp 'MQL5')){ [void]$radici.Add(@{ dati=$pp; et=('CARTELLA ' + $pp) }) } }
$ea=0
foreach($r in $radici){ $exd=Join-Path $r.dati 'MQL5\Experts'; if(-not (Test-Path -LiteralPath $exd)){ continue }
  foreach($f in @(Get-ChildItem -LiteralPath $exd -Filter 'Ultimate_Breakout*.ex5' -File -Recurse -ErrorAction SilentlyContinue)){ $ea++; R ('  EA   ' + $f.Name + '  ' + ($f.Length/1KB).ToString('0') + ' KB  ' + $f.LastWriteTime.ToString('yyyy-MM-dd') + '  in ' + $r.et + '  ->  ' + $f.DirectoryName) } }
if($ea -eq 0){ R '  NESSUN Ultimate_Breakout*.ex5 trovato in MQL5\Experts di nessun terminale.' }
R ''; R '== 3. Cartella WIM nel terminale BCM principale e nel portatile =='
foreach($r in $radici){ if($r.et -match 'BCM'){ $w=Join-Path $r.dati 'MQL5\Experts\WIM'; R ('  ' + $r.et + '  WIM: ' + $(if(Test-Path -LiteralPath $w){ 'ESISTE (' + @(Get-ChildItem -LiteralPath $w -File -ErrorAction SilentlyContinue).Count + ' file)' } else { 'NON esiste' })) } }
$desk=[Environment]::GetFolderPath('Desktop'); $od=Join-Path $desk 'ABTG_RISULTATI'; New-Item -ItemType Directory -Force -Path $od | Out-Null
$ref=Join-Path $od ('CONTROLLO_UBS_FILE_' + (Get-Date).ToString('yyyyMMdd_HHmm') + '.txt'); Set-Content -LiteralPath $ref -Value ($out -join "`r`n") -Encoding UTF8
Write-Host ''
Write-Host '##########  FILE DA ALLEGARE ALLA CHAT  ##########' -ForegroundColor Black -BackgroundColor Yellow
Write-Host $ref -ForegroundColor Black -BackgroundColor Yellow
try { Start-Process explorer.exe -ArgumentList ('/select,"' + $ref + '"') } catch { }
