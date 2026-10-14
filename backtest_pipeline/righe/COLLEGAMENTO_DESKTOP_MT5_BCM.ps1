# COLLEGAMENTO_DESKTOP_MT5_BCM.ps1 -- MARCATORE_COLLEGAMENTO_DESKTOP_MT5_BCM_v1
# Crea UN collegamento MT5_BCM_PC_BACKTEST.lnk sul Desktop dell'utente, che punta a
# C:\Program Files\BCM Markets MT5 Terminal\terminal64.exe. Gira SOLO sul PC di backtest DESKTOP-H4D7CAJ.
# NON apre MT5, NON chiude processi, NON scarica niente, NON sovrascrive un collegamento esistente.
# ASCII puro.
param()
$ErrorActionPreference = 'Continue'
if ($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ') { Write-Host ('QUESTO SCRIPT GIRA SOLO SUL PC DI BACKTEST DESKTOP-H4D7CAJ. Qui la macchina si chiama: ' + $env:COMPUTERNAME) -ForegroundColor Red; exit 1 }
$exe = 'C:\Program Files\BCM Markets MT5 Terminal\terminal64.exe'
$cartella = 'C:\Program Files\BCM Markets MT5 Terminal'
if (-not (Test-Path -LiteralPath $exe)) { Write-Host ('NON ESISTE ' + $exe + ': nessun collegamento creato. Manda la foto di questa finestra.') -ForegroundColor Red; exit 1 }
$dsk = [Environment]::GetFolderPath('Desktop')
$lnk = Join-Path $dsk 'MT5_BCM_PC_BACKTEST.lnk'
Write-Host ('Desktop di questo utente: ' + $dsk) -ForegroundColor Cyan
if (Test-Path -LiteralPath $lnk) {
    Write-Host ('Il collegamento ESISTE GIA: ' + $lnk + '  (non lo tocco)') -ForegroundColor Yellow
} else {
    try {
        $ws = New-Object -ComObject WScript.Shell
        $sc = $ws.CreateShortcut($lnk)
        $sc.TargetPath = $exe
        $sc.WorkingDirectory = $cartella
        $sc.Description = 'MT5 BCM del PC di backtest DESKTOP-H4D7CAJ (cartella C:\Program Files\BCM Markets MT5 Terminal)'
        $sc.Save()
        Write-Host ('Creato: ' + $lnk) -ForegroundColor Green
    } catch {
        Write-Host ('NON creato: ' + $_.Exception.Message) -ForegroundColor Red
        exit 1
    }
}
if (-not (Test-Path -LiteralPath $lnk)) { Write-Host 'Il collegamento NON c e sul Desktop: manda la foto di questa finestra.' -ForegroundColor Red; exit 1 }
$v = (New-Object -ComObject WScript.Shell).CreateShortcut($lnk)
Write-Host ('Il collegamento punta a: ' + $v.TargetPath) -ForegroundColor Green
if ($v.TargetPath -eq $exe) {
    Write-Host 'VERIFICATO: e il terminale C:\Program Files\BCM Markets MT5 Terminal. Lo trovi sul Desktop con il nome MT5_BCM_PC_BACKTEST. Non lo apro io.' -ForegroundColor Green
    exit 0
} else {
    Write-Host 'ATTENZIONE: il collegamento che c e gia sul Desktop punta ALTROVE. Non usarlo e manda la foto.' -ForegroundColor Red
    exit 3
}
