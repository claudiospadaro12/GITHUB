# =====================================================================
#  MARCATORE_PULISCI_DESKTOP_ESAMINATI_v2
#  PULISCI_DESKTOP_ESAMINATI_V2.ps1 -- 19/10/2026. Richiesta di Claudio: la v1 (solo i giri GIA LETTI per nome) ha spostato 22 elementi su 220:
#  "deve essere piu forte lo spostamento".
#  v2: SPOSTA (non cancella, non sovrascrive) in Desktop\ARCHIVIO_ESAMINATI_<data e ora>\ TUTTE LE CARTELLE e TUTTI GLI ZIP del Desktop piu vecchi
#  di 48 ore, tranne:
#    - SCREEN_*, SETACCIO_*, ARCHIVIO* (il setaccio in corso scrive li; gli archivi gia fatti restano)
#    - NATCLA_F1_P (la cartella pilota che le righe NATCLA_F1_* rileggono, classe 607)
#    - qualunque cartella che CONTENGA terminal64.exe, metaeditor64.exe, origin.txt o una sottocartella MQL5 (un MT5, mai spostato)
#    - tutto cio che e stato modificato nelle ultime 48 ore
#    - OGNI ALTRO TIPO di file (.lnk, .url, .txt, .png, .xlsx, .pdf, .csv, .ps1, ...): restano dove sono
#  Gira SOLO su DESKTOP-H4D7CAJ. Non apre MT5, non lancia tester, non cancella niente, non scrive fuori dal Desktop.
#  Per tornare indietro: riportare le cartelle dall'archivio al Desktop.
#  NIENTE EMOJI QUI DENTRO (regola del 17/08): Windows PowerShell 5.1 legge i .ps1 come ANSI.
# =====================================================================
[CmdletBinding()]
param([int]$Ore = 48)
$ErrorActionPreference = 'Stop'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ throw ('PULISCI_DESKTOP_ESAMINATI_V2 gira SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui la macchina si chiama: ' + $env:COMPUTERNAME + '. Non si lancia sul VPS.') }
if($Ore -lt 24 -or $Ore -gt 720){ throw '-Ore fuori da 24-720.' }
$dsk = [Environment]::GetFolderPath('Desktop')
$limite = (Get-Date).AddHours(-$Ore)
$tutti = @(Get-ChildItem -LiteralPath $dsk -Force -ErrorAction Stop)
$cand = @(); $tenuti = @()
foreach($it in $tutti){
  $motivo = ''
  if($it.Name -like 'SCREEN_*' -or $it.Name -like 'SETACCIO_*' -or $it.Name -like 'ARCHIVIO*'){ $motivo = 'setaccio o archivio' }
  elseif($it.Name -eq 'NATCLA_F1_P'){ $motivo = 'cartella pilota riletta dalle righe NATCLA_F1_*' }
  elseif($it.PSIsContainer){
    $mt5 = $false
    foreach($x in @('terminal64.exe', 'metaeditor64.exe', 'origin.txt', 'MQL5')){ if(Test-Path -LiteralPath (Join-Path $it.FullName $x)){ $mt5 = $true } }
    if($mt5){ $motivo = 'contiene un MT5 (terminal64/metaeditor64/origin.txt/MQL5)' }
  }
  elseif($it.Extension -ne '.zip'){ $motivo = 'non e una cartella ne uno zip' }
  if($motivo -eq '' -and $it.LastWriteTime -gt $limite){ $motivo = ('modificato da meno di ' + $Ore + ' ore') }
  if($motivo -eq ''){ $cand += $it } else { $tenuti += ,@($it.Name, $motivo) }
}
Write-Host ('Elementi sul Desktop: ' + $tutti.Count + '   da spostare: ' + $cand.Count + '   restano: ' + $tenuti.Count + '   (cartelle e zip piu vecchi di ' + $Ore + ' ore)') -ForegroundColor Cyan
$gr = @{}
foreach($t in $tenuti){ if(-not $gr.ContainsKey($t[1])){ $gr[$t[1]] = 0 }; $gr[$t[1]] = $gr[$t[1]] + 1 }
foreach($k in $gr.Keys){ Write-Host ('   restano ' + $gr[$k] + ' : ' + $k) -ForegroundColor Gray }
foreach($t in $tenuti){ if($t[1] -like 'contiene un MT5*' -or $t[1] -like 'cartella pilota*' -or $t[1] -like 'modificato da meno*'){ Write-Host ('      NON TOCCATO (' + $t[1] + '): ' + $t[0]) -ForegroundColor Yellow } }
if($cand.Count -eq 0){ Write-Host 'Niente da spostare.' -ForegroundColor Green; exit 0 }
$arch = Join-Path $dsk ('ARCHIVIO_ESAMINATI_' + (Get-Date).ToString('yyyyMMdd_HHmmss'))
New-Item -ItemType Directory -Path $arch | Out-Null
$ok = 0; $ko = 0
foreach($it in $cand){
  $dest = Join-Path $arch $it.Name
  try {
    if(Test-Path -LiteralPath $dest){ throw 'la destinazione esiste gia' }
    Move-Item -LiteralPath $it.FullName -Destination $dest
    $ok = $ok + 1
    Write-Host ('   spostato: ' + $it.Name) -ForegroundColor Green
  } catch {
    $ko = $ko + 1
    Write-Host ('   NON spostato (' + $_.Exception.Message + '): ' + $it.Name) -ForegroundColor Yellow
  }
}
Write-Host ('FATTO: spostati ' + $ok + ', non spostati ' + $ko + '. Archivio: ' + $arch) -ForegroundColor Green
$resto = @(Get-ChildItem -LiteralPath $dsk -Force | Where-Object { $_.Name -like 'SCREEN_*' -or $_.Name -like 'SETACCIO_*' })
Write-Host ('Restano al loro posto, intatti, gli elementi del setaccio (SCREEN_* e SETACCIO_*): ' + $resto.Count) -ForegroundColor Gray
exit 0
