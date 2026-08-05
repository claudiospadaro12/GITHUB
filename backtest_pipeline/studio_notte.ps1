# =====================================================================
#  studio_notte.ps1  --  installa lo STUDIO DEL MOVIMENTO NOTTURNO
#
#  Domanda di Claudio (05/08): "Emiliano dice che l'oro di notte fa dei
#  bei movimenti, intorno alle 3 (2 su BCM). Dovremmo capire quante
#  volte fa il movimento min e max della notte."
#
#  Questo NON e' un backtest: e' una MISURA. Non apre trade, conta i
#  fatti. Tre risposte in un colpo:
#    1) a che ora nascono davvero massimo e minimo della notte
#    2) quanto vale lo swing fra i due estremi
#    3) cosa fa la sessione del giorno dopo: rompe il box o resta dentro
#
#  Il punto 3 e' quello che decide la strategia:
#    - se la sessione ROMPE spesso  -> ha ragione il MaxMinNotte (breakout)
#    - se resta spesso DENTRO       -> ha ragione il fade (compri sul minimo,
#                                      vendi sul massimo) come dice Claudio
#  Sono due strategie OPPOSTE sugli stessi due livelli: prima si misura,
#  poi si scrive l'EA. Non il contrario.
#
#  MT5 puo' restare APERTO: qui si compila soltanto.
#
#  Uso:
#    powershell -ExecutionPolicy Bypass -File .\studio_notte.ps1
# =====================================================================
$ErrorActionPreference="Stop"
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
$EABranch="lavoro"
$RawBase="https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$EABranch"

Write-Host "=== STUDIO DEL MOVIMENTO NOTTURNO ===" -ForegroundColor Cyan

$allTerm=Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue
$cand=$allTerm|Where-Object{$_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*"}|Select-Object -First 1
if(-not $cand){$cand=$allTerm|Where-Object{$_.DirectoryName -like "*BCM Markets*"}|Select-Object -First 1}
if(-not $cand){Write-Host "Terminale BCM non trovato." -ForegroundColor Red; exit 1}
$MetaEditor=Join-Path $cand.DirectoryName "metaeditor64.exe"
$instDir=$cand.DirectoryName
$termRoot=Join-Path $env:APPDATA "MetaQuotes\Terminal"
$DataFolder=Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue|Where-Object{
    $o=Join-Path $_.FullName "origin.txt"
    (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $instDir)
}|Select-Object -First 1 -ExpandProperty FullName
if(-not $DataFolder){Write-Host "Cartella dati non trovata." -ForegroundColor Red; exit 1}

$MqlScripts=Join-Path $DataFolder "MQL5\Scripts"
New-Item -ItemType Directory -Force -Path $MqlScripts|Out-Null

# cache-buster: la CDN di GitHub serve volentieri la versione vecchia
$stamp=[DateTimeOffset]::UtcNow.ToUnixTimeSeconds()
foreach($f in @("ABTG_Notte_Study","ABTG_HistoryDownloader")){
  $dst=Join-Path $MqlScripts "$f.mq5"
  try{
    Invoke-WebRequest -Uri "$RawBase/mql5/Scripts/$f.mq5?cb=$stamp" -OutFile $dst -UseBasicParsing
    & $MetaEditor "/compile:$dst" "/log" | Out-Null
    if(Test-Path (Join-Path $MqlScripts "$f.ex5")){ Write-Host "    compilato $f" -ForegroundColor Green }
    else { Write-Host "    ERRORE compilazione $f" -ForegroundColor Red }
  }catch{ Write-Host "    ERRORE download $f" -ForegroundColor Red }
}

Write-Host ""
Write-Host "ADESSO, A MANO (2 minuti):" -ForegroundColor White
Write-Host "  1) Apri MT5, grafico XAUUSD su M5." -ForegroundColor Gray
Write-Host "  2) Navigatore > Script > ABTG_HistoryDownloader: trascinalo sul grafico." -ForegroundColor Gray
Write-Host "     (serve solo se lo storico M5 dell'oro non c'e' gia')" -ForegroundColor DarkGray
Write-Host "  3) Navigatore > Script > ABTG_Notte_Study: trascinalo sul grafico." -ForegroundColor Gray
Write-Host "     Lascia i valori di default: notte 22-07 server, ora sospetta 2 (= 3 IT)." -ForegroundColor DarkGray
Write-Host "  4) Guarda il tab ESPERTI: ci sono i tre blocchi di risposte." -ForegroundColor Gray
Write-Host "     Copiami quel testo, oppure mandami il CSV:" -ForegroundColor Gray
Write-Host "     $DataFolder\MQL5\Files\ABTG_Notte_Study_XAUUSD.csv" -ForegroundColor DarkGray
Write-Host ""
Write-Host "Poi ripetilo su D30EUR e NASUSD: cosi' vediamo se la notte dell'oro" -ForegroundColor Gray
Write-Host "e' davvero diversa da quella degli indici, o se ci sembra e basta." -ForegroundColor Gray
