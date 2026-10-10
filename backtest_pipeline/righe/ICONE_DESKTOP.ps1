# MARCATORE_ICONE_DESKTOP_v2
# Riduce la dimensione delle icone del Desktop dell'utente con cui si e' collegati.
# Scrive SOLO: HKCU\Software\Microsoft\Windows\Shell\Bags\1\Desktop\IconSize (questo utente).
# Riavvia SOLO l'explorer.exe della SESSIONE corrente (filtro per SessionId, mai per nome da solo).
# NON tocca terminal64, metaeditor64, MT5, EA, conti, preset, CODA.txt, runner, attivita' pianificate, file del Desktop.
param([int]$Size = 32, [string]$Macchina = 'NESSUNA')
$ErrorActionPreference = 'Stop'
if($Size -lt 16 -or $Size -gt 256){ throw ('Size ammessi: da 16 a 256 (32 piccole, 48 medie, 96 grandi, 256 molto grandi). Ricevuto: ' + $Size) }
Write-Host ('macchina: ' + $env:COMPUTERNAME + '   utente: ' + $env:USERNAME) -ForegroundColor Green
if($env:COMPUTERNAME -ne $Macchina){ throw ('Questa riga e per la macchina ' + $Macchina + ', e sei su ' + $env:COMPUTERNAME + ': non scrivo niente e non riavvio niente, mi fermo.') }
$k = 'HKCU:\Software\Microsoft\Windows\Shell\Bags\1\Desktop'
if(-not (Test-Path -LiteralPath $k)){ throw 'Chiave del Desktop non trovata in questo profilo: non creo niente, mi fermo.' }
$old = (Get-ItemProperty -LiteralPath $k).IconSize
$oldTxt = 'assente (48 predefinito)'
if($null -ne $old){ $oldTxt = [string]$old }
Write-Host ('IconSize attuale: ' + $oldTxt + '   (256 = molto grandi, 96 = grandi, 48 = medie, 32 = piccole, 16 = minuscole)') -ForegroundColor Cyan
Set-ItemProperty -LiteralPath $k -Name IconSize -Value $Size -Type DWord
Write-Host ('IconSize nuova  : ' + (Get-ItemProperty -LiteralPath $k).IconSize) -ForegroundColor Green
$sid = (Get-Process -Id $PID).SessionId
$ex = @(Get-Process -Name explorer -ErrorAction SilentlyContinue | Where-Object { $_.SessionId -eq $sid })
Write-Host ('explorer.exe della sessione ' + $sid + ': ' + $ex.Count + ' da riavviare (si chiudono le finestre di Esplora risorse, i programmi no)') -ForegroundColor Cyan
$ex | Stop-Process -Force
Start-Sleep -Seconds 4
$ri = @(Get-Process -Name explorer -ErrorAction SilentlyContinue | Where-Object { $_.SessionId -eq $sid })
if($ri.Count -eq 0){ Start-Process explorer.exe; Start-Sleep -Seconds 3; Write-Host 'explorer riavviato da questo script (se si apre anche una finestra di Esplora risorse in piu, chiudila: e innocua)' -ForegroundColor Gray }
Write-Host 'Fatto. Se il Desktop non e cambiato: clic destro su un punto vuoto del Desktop > Visualizza > Icone piccole. NON usare Esci / Disconnetti utente / Riavvia: chiudono TUTTI i programmi della sessione, MT5 compresi.' -ForegroundColor Green
Write-Host ('PER RIPRISTINARE: rilancia la riga con -Size ' + $(if($null -ne $old){[string]$old}else{'48'}) + ' al posto di -Size ' + $Size + ' (e il valore di prima, stampato sopra), oppure tasto destro sul Desktop > Visualizza > Icone medie.') -ForegroundColor Gray
