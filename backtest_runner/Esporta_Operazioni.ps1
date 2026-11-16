# Esporta_Operazioni.ps1 - dal report HTML di una passata singola del tester ricava il profitto NETTO per giorno (data;profitto).
# Serve a Correlazione.py (tappa 3: scorrelazione tra EA). Funziona su QUALUNQUE EA, non solo sui nostri.
# Profitto netto del giorno = commissione + swap + profitto di tutte le operazioni (deal) di quel giorno; i versamenti ("balance") sono esclusi.
# AUTOCONTROLLO: la somma deve coincidere con il "Profitto Totale Netto" del report (tolleranza max(1, 0,5%)); se no lo scrive e marca la serie NON VERIFICATA.
# NON VERIFICATO su un report reale: le intestazioni della tabella "Deals/Operazioni" sono cercate per nome (italiano e inglese); se non le trova, si ferma senza scrivere niente.
# Solo lettura del report. Windows PowerShell 5.1.
# Uso: .\Esporta_Operazioni.ps1 -Report C:\MT5_BCM_Opt\ENG_xxx.htm -Uscita .\Risultati\serie [-Nome MioEA_XAUUSD]
param(
  [Parameter(Mandatory=$true)][string]$Report,
  [string]$Uscita = '.\Risultati\serie',
  [string]$Nome = ''
)
$ErrorActionPreference = 'Continue'
$ci = [Globalization.CultureInfo]::InvariantCulture
function Num([string]$s){
  $c = ($s -replace '[^0-9.\-]','')
  $v = 0.0
  if([double]::TryParse($c,[Globalization.NumberStyles]::Float,$ci,[ref]$v)){ return $v } else { return 0.0 }
}
function Pulisci([string]$s){ return (([regex]::Replace($s,'<[^>]*>','') -replace '&nbsp;',' ') -replace '\s+',' ').Trim() }
if(-not (Test-Path -LiteralPath $Report)){ Write-Host ('Non trovo il report: ' + $Report) -ForegroundColor Red; return }
$b = [IO.File]::ReadAllBytes($Report)
if($b.Length -ge 2 -and (($b[0] -eq 255 -and $b[1] -eq 254) -or ($b[0] -eq 254 -and $b[1] -eq 255))){ $html = [Text.Encoding]::Unicode.GetString($b) } else { $html = [Text.Encoding]::UTF8.GetString($b) }
# profitto totale atteso (per l'autocontrollo)
$piatto = [regex]::Replace($html,'<[^>]*>','|'); $piatto = [regex]::Replace($piatto,'\s*\|[\s|]*','|')
$mt = [regex]::Match($piatto,'(?:Profitto Totale Netto:|Total Net Profit:)\|([^|]*)\|')
$atteso = [double]::NaN; if($mt.Success){ $atteso = Num $mt.Groups[1].Value }
$righe = [regex]::Split($html,'(?i)<tr')
$iData = 0; $iProf = -1; $iComm = -1; $iSwap = -1; $iTipo = -1; $inDeals = $false
$giorni = @{}; $nOp = 0
foreach($rg in $righe){
  $celle = @(); foreach($mc in [regex]::Matches($rg,'(?is)<t[dh][^>]*>(.*?)</t[dh]>')){ $celle += (Pulisci $mc.Groups[1].Value) }
  if($celle.Count -lt 8){ continue }
  # intestazione della tabella dei deal: contiene profitto, commissione e swap
  $p = -1; $c = -1; $w = -1; $t = -1
  for($i = 0; $i -lt $celle.Count; $i++){
    if($celle[$i] -match '^(Profit|Profitto|Utile)$'){ $p = $i }
    elseif($celle[$i] -match '^(Commission|Commissione|Commissioni)$'){ $c = $i }
    elseif($celle[$i] -match '^Swap$'){ $w = $i }
    elseif($celle[$i] -match '^(Type|Tipo)$'){ $t = $i }
  }
  if($p -ge 0 -and $c -ge 0 -and $w -ge 0){ $iProf = $p; $iComm = $c; $iSwap = $w; $iTipo = $t; $inDeals = $true; continue }
  if(-not $inDeals){ continue }
  if($celle[$iData] -notmatch '^(\d{4})\.(\d{2})\.(\d{2}) \d{2}:\d{2}:\d{2}$'){ continue }
  if($celle.Count -le $iProf){ continue }
  if($iTipo -ge 0 -and $celle[$iTipo] -match '^(balance|saldo|credit|credito|charge|correction|bonus)'){ continue }
  $chiave = $celle[$iData].Substring(0,10)
  $net = (Num $celle[$iProf]) + (Num $celle[$iComm]) + (Num $celle[$iSwap])
  if($giorni.ContainsKey($chiave)){ $giorni[$chiave] = $giorni[$chiave] + $net } else { $giorni[$chiave] = $net }
  $nOp = $nOp + 1
}
if($nOp -eq 0){ Write-Host 'Nessuna riga di operazione trovata: intestazioni della tabella diverse dal previsto. NON scrivo niente. Mandami le prime righe della tabella Deals/Operazioni del report.' -ForegroundColor Red; return }
$somma = 0.0; foreach($k in $giorni.Keys){ $somma = $somma + $giorni[$k] }
$verificata = $false
if(-not [double]::IsNaN($atteso)){ $tol = [math]::Max(1.0, 0.005 * [math]::Abs($atteso)); $verificata = ([math]::Abs($somma - $atteso) -le $tol) }
if($Nome -eq ''){ $Nome = [IO.Path]::GetFileNameWithoutExtension($Report) }
if(-not $verificata){ $Nome = $Nome + '_NONVERIFICATA' }
New-Item -ItemType Directory -Force -Path $Uscita | Out-Null
$out = Join-Path $Uscita ($Nome + '.csv')
$linee = @('data;profitto')
foreach($k in ($giorni.Keys | Sort-Object)){ $linee += ($k + ';' + $giorni[$k].ToString('0.00',$ci)) }
Set-Content -LiteralPath $out -Value $linee -Encoding ASCII
if($verificata){ Write-Host ('Serie scritta: ' + $out + ' (' + $giorni.Count + ' giorni, ' + $nOp + ' deal). Somma ' + $somma.ToString('0.00',$ci) + ' = profitto del report: VERIFICATA.') -ForegroundColor Green }
else { Write-Host ('Serie scritta: ' + $out + ' - NON VERIFICATA: somma ' + $somma.ToString('0.00',$ci) + ' contro profitto del report ' + $atteso.ToString('0.00',$ci) + '. Non usarla per la correlazione finche non capiamo la differenza.') -ForegroundColor Yellow }
