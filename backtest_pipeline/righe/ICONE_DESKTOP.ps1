# MARCATORE_ICONE_DESKTOP_v1
# Riduce la dimensione delle icone del Desktop dell'utente con cui si e' collegati.
# Scrive SOLO: HKCU\Software\Microsoft\Windows\Shell\Bags\1\Desktop\IconSize (questo utente).
# Riavvia SOLO l'explorer.exe della SESSIONE corrente (filtro per SessionId, mai per nome da solo).
# NON tocca terminal64, metaeditor64, MT5, EA, conti, preset, CODA.txt, runner, attivita' pianificate, file del Desktop.
param([int]$Size = 32)
$ErrorActionPreference = 'Stop'
if($Size -ne 16 -and $Size -ne 32 -and $Size -ne 48){ throw ('Size ammessi: 16, 32, 48. Ricevuto: ' + $Size) }
Write-Host ('macchina: ' + $env:COMPUTERNAME + '   utente: ' + $env:USERNAME) -ForegroundColor Green
$k = 'HKCU:\Software\Microsoft\Windows\Shell\Bags\1\Desktop'
if(-not (Test-Path -LiteralPath $k)){ throw 'Chiave del Desktop non trovata in questo profilo: non creo niente, mi fermo.' }
$old = (Get-ItemProperty -LiteralPath $k).IconSize
$oldTxt = 'assente (48 predefinito)'
if($null -ne $old){ $oldTxt = [string]$old }
Write-Host ('IconSize attuale: ' + $oldTxt + '   (48 = medie, 32 = piccole, 16 = minuscole)') -ForegroundColor Cyan
Set-ItemProperty -LiteralPath $k -Name IconSize -Value $Size -Type DWord
Write-Host ('IconSize nuova  : ' + (Get-ItemProperty -LiteralPath $k).IconSize) -ForegroundColor Green
$sid = (Get-Process -Id $PID).SessionId
$ex = @(Get-Process -Name explorer -ErrorAction SilentlyContinue | Where-Object { $_.SessionId -eq $sid })
Write-Host ('explorer.exe della sessione ' + $sid + ': ' + $ex.Count + ' da riavviare (si chiudono le finestre di Esplora risorse, i programmi no)') -ForegroundColor Cyan
$ex | Stop-Process -Force
Start-Sleep -Seconds 4
$ri = @(Get-Process -Name explorer -ErrorAction SilentlyContinue | Where-Object { $_.SessionId -eq $sid })
if($ri.Count -eq 0){ Start-Process explorer.exe; Start-Sleep -Seconds 3 }
Write-Host 'Fatto. Se il Desktop non e cambiato, esci e rientra nella sessione.' -ForegroundColor Green
Write-Host 'PER RIPRISTINARE: rilancia questa riga con -Size 48 (oppure il valore che aveva prima, stampato sopra).' -ForegroundColor Gray
