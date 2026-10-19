# =====================================================================
#  MARCATORE_PULISCI_DESKTOP_ESAMINATI_v1
#  PULISCI_DESKTOP_ESAMINATI.ps1 -- 19/10/2026, richiesta di Claudio ("una riga per pulire il Desktop dalle cartelle ormai esaminate").
#  SPOSTA (non cancella, non sovrascrive) in Desktop\ARCHIVIO_ESAMINATI_<data e ora>\ le cartelle e gli zip dei giri GIA LETTI:
#  GOLDREAPER, TIG, GRW2, GRSET, TIGW2, TIGR025, GTPL, GOLDBOTL, PHANTOML, GRC, GRSETC (nome <SIGLA>_TESTER_TRANCHE, con .zip e con le
#  copie _VECCHIA_*/_VECCHIO_*). NON tocca SCREEN_*, SETACCIO_* (il setaccio in corso scrive li) ne nient'altro. Salta tutto cio che e stato
#  modificato negli ultimi 15 minuti. Gira SOLO su DESKTOP-H4D7CAJ. Non apre MT5, non lancia tester, non scrive fuori dal Desktop.
#  Per tornare indietro: riportare le cartelle dall'archivio al Desktop.
#  NIENTE EMOJI QUI DENTRO (regola del 17/08): Windows PowerShell 5.1 legge i .ps1 come ANSI.
# =====================================================================
[CmdletBinding()]
param()
$ErrorActionPreference = 'Stop'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ throw ('PULISCI_DESKTOP_ESAMINATI gira SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui la macchina si chiama: ' + $env:COMPUTERNAME + '. Non si lancia sul VPS.') }
$dsk = [Environment]::GetFolderPath('Desktop')
$sigle = @('GOLDREAPER', 'TIG', 'GRW2', 'GRSET', 'TIGW2', 'TIGR025', 'GTPL', 'GOLDBOTL', 'PHANTOML', 'GRC', 'GRSETC')
$tutti = @(Get-ChildItem -LiteralPath $dsk -Force -ErrorAction Stop)
$cand = @(); $recenti = @()
foreach($it in $tutti){
  if($it.Name -like 'SCREEN_*' -or $it.Name -like 'SETACCIO_*'){ continue }
  $hit = $false
  foreach($s in $sigle){
    $b = $s + '_TESTER_TRANCHE'
    if($it.Name -eq $b -or $it.Name -eq ($b + '.zip') -or $it.Name -like ($b + '_VECCHI?_*')){ $hit = $true }
  }
  if($hit){ if($it.LastWriteTime -gt (Get-Date).AddMinutes(-15)){ $recenti += $it } else { $cand += $it } }
}
Write-Host ('Elementi sul Desktop: ' + $tutti.Count + '   da spostare: ' + $cand.Count + '   troppo recenti, NON toccati: ' + $recenti.Count) -ForegroundColor Gray
foreach($it in $recenti){ Write-Host ('   NON TOCCATO (modificato da meno di 15 minuti): ' + $it.Name) -ForegroundColor Yellow }
if($cand.Count -eq 0){ Write-Host 'Niente da spostare: nessuna cartella o zip dei giri gia letti sul Desktop.' -ForegroundColor Green; exit 0 }
$arch = Join-Path $dsk ('ARCHIVIO_ESAMINATI_' + (Get-Date).ToString('yyyyMMdd_HHmmss'))
New-Item -ItemType Directory -Path $arch | Out-Null
foreach($it in $cand){
  $dest = Join-Path $arch $it.Name
  if(Test-Path -LiteralPath $dest){ Write-Host ('   NON spostato (la destinazione esiste gia): ' + $it.Name) -ForegroundColor Yellow; continue }
  Move-Item -LiteralPath $it.FullName -Destination $dest
  Write-Host ('   spostato: ' + $it.Name) -ForegroundColor Green
}
Write-Host ('FATTO. Archivio: ' + $arch) -ForegroundColor Green
$resto = @(Get-ChildItem -LiteralPath $dsk -Force | Where-Object { $_.Name -like 'SCREEN_*' -or $_.Name -like 'SETACCIO_*' })
Write-Host ('Restano al loro posto, intatti, gli elementi del setaccio (SCREEN_* e SETACCIO_*): ' + $resto.Count) -ForegroundColor Gray
exit 0
