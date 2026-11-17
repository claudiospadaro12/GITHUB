# MARCATORE_BUSCA_STORICO_INDICI_ORO_v1
# SOLA LETTURA. Cerca sul PC di backtest file di storico grandi (CSV, TXT, HST, ZIP, RAR, 7Z) con nome da indici (DAX, Dow, CAC, Nasdaq, S&P) o oro, e per i CSV/TXT legge la prima e l'ultima riga (date di inizio e fine). Non apre MT5, non modifica niente, non tocca conti ne VPS. Scrive un solo file di testo sul Desktop.
$ErrorActionPreference='SilentlyContinue'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ Write-Host ('SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui: ' + $env:COMPUTERNAME) -ForegroundColor Red; return }
$ci=[Globalization.CultureInfo]::InvariantCulture
$rx='(?i)(dax|d30|ger30|ger40|de40|de30|us30|u30|dow|dj30|wall|f40|cac|fra40|nas|us100|ndx|spx|us500|sp500|xau|gold|oro)'
$ext=@('.csv','.txt','.hst','.zip','.rar','.7z','.gz','.parquet')
$radici=New-Object System.Collections.ArrayList
foreach($p in @($env:USERPROFILE,'C:\MT5_Backtest','C:\MT5_BCM_Opt','C:\FundedNext_Manuale','C:\Program Files\BCM Markets MT5 Terminal',(Join-Path $env:APPDATA 'MetaQuotes'))){ if($p -and (Test-Path -LiteralPath $p)){ [void]$radici.Add($p) } }
foreach($d in @(Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Root -match '^[A-Z]:\\$' })){ if($d.Root -ne 'C:\'){ [void]$radici.Add($d.Root) } }
foreach($c in @('C:\dati','C:\Dati','C:\storico','C:\Storico','C:\data','C:\Data','C:\CSV','C:\csv','C:\Temp','C:\tmp')){ if(Test-Path -LiteralPath $c){ [void]$radici.Add($c) } }
$out=New-Object System.Collections.ArrayList
[void]$out.Add('percorso;MB;modificato;prima_riga;ultima_riga')
function Estremi([string]$p){
  $pr=''; $ul=''
  try{
    $fs=[IO.File]::Open($p,'Open','Read','ReadWrite')
    try{
      $rd=New-Object IO.StreamReader($fs)
      $l1=$rd.ReadLine(); $l2=$rd.ReadLine(); $pr=(($l1 + ' || ' + $l2) -replace ';',',')
      $len=$fs.Length; $n=[Math]::Min(3000,$len); [void]$fs.Seek(-$n,'End'); $buf=New-Object byte[] $n; [void]$fs.Read($buf,0,$n)
      $tx=[Text.Encoding]::UTF8.GetString($buf); $ls=@($tx -split "`r?`n" | Where-Object { $_.Trim() -ne '' }); if($ls.Count -gt 0){ $ul=($ls[$ls.Count-1] -replace ';',',') }
    } finally { $fs.Close() }
  } catch { $pr='(non leggibile)'; $ul='' }
  return @($pr,$ul)
}
$visti=@{}
foreach($r in $radici){
  Write-Host ('Cerco in ' + $r) -ForegroundColor Gray
  foreach($f in @(Get-ChildItem -LiteralPath $r -Recurse -File -Force -ErrorAction SilentlyContinue)){
    if($f.Length -lt 20MB){ continue }
    if($ext -notcontains $f.Extension.ToLowerInvariant()){ continue }
    if($f.FullName -match '\\(bases|ticks|Tester\\Agent|Windows|WinSxS|node_modules|\.git)\\'){ continue }
    if($f.Name -notmatch $rx -and $f.DirectoryName -notmatch $rx){ continue }
    if($visti.ContainsKey($f.FullName)){ continue }; $visti[$f.FullName]=$true
    $e=@('',''); if($f.Extension -match '(?i)^\.(csv|txt)$'){ $e=Estremi $f.FullName }
    [void]$out.Add($f.FullName + ';' + ($f.Length/1MB).ToString('0.0',$ci) + ';' + $f.LastWriteTime.ToString('yyyy-MM-dd') + ';' + $e[0] + ';' + $e[1])
  }
}
$desk=[Environment]::GetFolderPath('Desktop'); $fo=Join-Path $desk 'BUSCA_STORICO_INDICI_ORO.txt'
Set-Content -LiteralPath $fo -Value ($out -join "`r`n") -Encoding UTF8
try { Set-Clipboard -Value ($out -join "`r`n") } catch { }
Write-Host ('FATTO. File trovati: ' + ($out.Count-1) + '. File: ' + $fo + ' (allegalo alla chat).') -ForegroundColor Green
