# =====================================================================
#  FOTO_PROFILO_PICCOLO.ps1            MARCATORE_FOTO_PROFILO_PICCOLO_v1
#  BERSAGLIO: VPS VMI3047753, cartella dati del piccolo 50503392
#    %APPDATA%\MetaQuotes\Terminal\215D85D767A1C39E22D242C8114BF9F5 , profilo ORO.
#  SOLA LETTURA sul terminale: COPIA la cartella dei grafici sul Desktop e
#  conta EA e simboli dai file .chr. Non scrive, non cancella e non chiude
#  niente nel terminale. Si puo lanciare anche a terminale APERTO.
#  Uscita: Desktop\FOTO_PROFILO_ORO_PICCOLO_<ts> (copia) e
#          Desktop\ELENCO_GRAFICI_PICCOLO_<ts>.csv (File,Simbolo,EA,Modificato).
# =====================================================================
$ErrorActionPreference = 'Stop'
$INV = [Globalization.CultureInfo]::InvariantCulture
if($env:COMPUTERNAME -ne 'VMI3047753'){ throw ('VIETATO: macchina ' + $env:COMPUTERNAME + ', non VMI3047753.') }
$TSR = (Get-Date).ToString('yyyyMMdd_HHmmss', $INV)
$DSK = [Environment]::GetFolderPath('Desktop')
$DATI = Join-Path $env:APPDATA 'MetaQuotes\Terminal\215D85D767A1C39E22D242C8114BF9F5'
if(-not (Test-Path -LiteralPath $DATI)){ throw ('cartella dati non trovata: ' + $DATI) }
$OR = ((Get-Content -LiteralPath (Join-Path $DATI 'origin.txt') -Raw) -replace '[^\x20-\x7E]','').Trim()
Write-Host ('origin.txt -> ' + $OR)
$CI = Get-Content -LiteralPath (Join-Path $DATI 'config\common.ini') -Raw
$PL = [regex]::Match($CI, '(?im)^[ \t]*ProfileLast[ \t]*=[ \t]*(.*?)[ \t]*$').Groups[1].Value
Write-Host ('ProfileLast (profilo attivo) -> ' + $PL) -ForegroundColor Cyan
$P = Join-Path $DATI 'MQL5\Profiles\Charts\ORO'
if(-not (Test-Path -LiteralPath $P)){ throw ('cartella profilo ORO non trovata: ' + $P) }
$B = Join-Path $DSK ('FOTO_PROFILO_ORO_PICCOLO_' + $TSR)
Copy-Item -LiteralPath $P -Destination $B -Recurse -Force
$na = @(Get-ChildItem -LiteralPath $P -Recurse -File).Count
$nb = @(Get-ChildItem -LiteralPath $B -Recurse -File).Count
Write-Host ('COPIA: file nel profilo ' + $na + ', nella copia ' + $nb + ' -> ' + $B) -ForegroundColor Green
$RIG = @()
foreach($f in @(Get-ChildItem -LiteralPath $P -Filter 'chart*.chr' -File | Sort-Object Name)){
  $t = Get-Content -LiteralPath $f.FullName -Raw
  $sy = [regex]::Match($t, '(?m)^symbol=(\S+)').Groups[1].Value
  $ea = '-'
  $m = [regex]::Match($t, '(?s)<expert>(.*?)</expert>')
  if($m.Success){ $e = [regex]::Match($m.Groups[1].Value, '(?m)^name=(\S+)').Groups[1].Value; if($e){ $ea = $e } }
  $RIG += [pscustomobject]@{ File = $f.Name; Simbolo = $sy; EA = $ea; Modificato = $f.LastWriteTime.ToString('yyyy-MM-dd HH:mm', $INV) }
}
$CSV = Join-Path $DSK ('ELENCO_GRAFICI_PICCOLO_' + $TSR + '.csv')
$RIG | Export-Csv -LiteralPath $CSV -NoTypeInformation -Encoding UTF8
$conEA = @($RIG | Where-Object { $_.EA -ne '-' })
Write-Host ('GRAFICI nel profilo: ' + $RIG.Count + '   con un EA: ' + $conEA.Count + '   senza EA: ' + ($RIG.Count - $conEA.Count)) -ForegroundColor Cyan
$idx = @($conEA | Where-Object { $_.Simbolo -match 'U30USD|D30EUR|NASUSD|225JPY' })
Write-Host ('di cui su indici (U30USD D30EUR NASUSD 225JPY): ' + $idx.Count) -ForegroundColor Cyan
foreach($x in $idx){ Write-Host ('   ' + $x.File + '  ' + $x.Simbolo + '  ' + $x.EA) }
Write-Host ('ELENCO: ' + $CSV) -ForegroundColor Green
Write-Host 'FINE. Niente e stato scritto nel terminale.' -ForegroundColor Yellow
