# =====================================================================
#  scan_gestione.ps1  --  STUDIO STRUTTURA DI GESTIONE (BE/parziale/trailing)
#  Trova, a TICK REALI, quale COMBINAZIONE di uscita rende meglio per un
#  EA di apertura M5 (DAX o Nasdaq). Non riscopre l'ingresso: fissa
#  l'ingresso ai default e ottimizza SOLO i toggle di gestione.
#
#  Le strutture testate (48 pass, poi Claude collassa alle ~16 distinte):
#    - Parziale/dimezza:  OFF | 50% a 1R
#    - BE dopo parziale:  OFF | ON
#    - BE indipendente:   OFF | a 1R (InpBEatR)
#    - Trailing:          OFF | ATR | PREVBAR | FIXED
#
#  MARCATORE_SCAN_GESTIONE_v2_VPS
#
#  PC FISSO, MetaTrader CHIUSO.
#
#  ---------------------------------------------------------------------
#  PERCHE' ESISTE LA v2 (09/09/2026) -- ERA UN PERICOLO, NON UN DIFETTO
#  Questo script e' del tempo in cui c'era UN SOLO MT5. Sul VPS ce ne
#  sono QUATTRO (piccolo 50503392, 100k 50504263, REALE 10105439,
#  backtest 50504400) e la v1 faceva due cose che oggi costano care:
#    1. senza -Terminal cercava in "C:\Program Files*" il primo
#       "*BCM Markets MT5 Terminal*" -> che sul VPS e' IL PICCOLO, cioe'
#       il terminale con le sedie VIVE. Avrebbe copiato e RICOMPILATO
#       l'EA dentro la cartella di un terminale in FORWARD;
#    2. la guardia "MetaTrader aperto" era GLOBALE: con quattro terminali
#       vivi o si ferma sempre, o con -Force parte mentre il bersaglio e'
#       ancora aperto (classe 159).
#  La v2 chiude tutte e due:
#    - MUORE se il terminale risolto e' -V3 (100k) o BCM_Reale (REALE);
#    - si RIFIUTA di indovinare il terminale se non e' stato passato
#      -Terminal e c'e' piu' di un terminal64 vivo;
#    - la guardia diventa CHIRURGICA: guarda solo i processi che girano
#      DENTRO la cartella del terminale bersaglio;
#    - l'EA si scarica da un PIN (commit), non da HEAD del branch.
#  E ha tolto i caratteri non-ASCII che erano nel file dal giorno uno:
#  Windows PowerShell 5.1 legge i .ps1 come ANSI (regola di CLAUDE.md).
#  ---------------------------------------------------------------------
#
#  Uso:
#    # DAX apertura (server hour 8):
#    .\scan_gestione.ps1 -Robot ABTG_DAX_Apertura_EU -Symbol D30EUR -SessionHour 8
#    # Nasdaq apertura (server hour 14):
#    .\scan_gestione.ps1 -Robot ABTG_Nasdaq_Apertura_US -Symbol NASUSD -SessionHour 14
# =====================================================================
param(
  [string]$Robot="ABTG_DAX_Apertura_EU",
  [string]$Symbol="D30EUR",
  [int]$SessionHour=8,                    # ORA SERVER BCM (DAX=8, Nasdaq=14). NON l'ora italiana!
  [string]$Tf="M5",
  [ValidateSet("struttura","distanze")]
  [string]$Fase="struttura",              # struttura = QUALI toggle - distanze = QUANTO larghi
  [switch]$UseSpare,[string]$Terminal="",[string]$MetaEditor="",[string]$DataFolder="",[switch]$Force,
  [string]$Pin="lavoro"
)
$ErrorActionPreference="Stop"
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
$EA=$Robot
# gli EA con InpBEatR vivono sul branch di lavoro (non ancora sul default)
$EABranch=$Pin   # v2: un PIN di commit, non HEAD del branch (classe 164)
$RawBase="https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$EABranch"

# --- GRIGLIA STRUTTURA DI GESTIONE (48 combo; ingresso fissato ai default) ---
#   TrailMode: 0=ATR, 1=PREVBAR, 2=FIXED (l'enum dell'EA)
$Inputs=@"
InpRiskPercent=1.0||1.0||0||1.0||N
InpSessionHour=$SessionHour||$SessionHour||0||$SessionHour||N
InpTP1_R=1.0||1.0||0||1.0||N
InpTP1_ClosePct=0||0||50||50||Y
InpBreakevenAtTP1=0||0||1||1||Y
InpBEatR=0||0||1||1||Y
InpUseTrailing=0||0||1||1||Y
InpTrailMode=0||0||1||2||Y
"@

# ---------------------------------------------------------------------
#  FASE "DISTANZE": la struttura non basta.
#  Il 03/08 in forward tre EA sul DAX sono stati chiusi dal proprio trailing
#  in 39 SECONDI (+12 punti su un movimento da +83): il trailing era a
#  InpTrailFixedPts=410 = 4,1 punti indice, mentre una candela M5 del DAX
#  all'apertura si muove 20-40 punti. La fase "struttura" avrebbe detto
#  "trailing FIXED e' cattivo" senza rivelare che era cattiva la DISTANZA.
#  Qui la struttura si FISSA (parziale 50% + BE + trailing a punti fissi) e
#  si spazzolano i tre numeri che decidono davvero:
#    - TP1_R    dove metto il primo obiettivo
#    - BEatR    QUANDO vado in pari (troppo presto = mi butta fuori il respiro)
#    - TrailFixedPts  quanto largo il trailing (4 / 10 / 20 / 40 punti indice)
# ---------------------------------------------------------------------
if($Fase -eq "distanze"){
  $Inputs=@"
InpRiskPercent=1.0||1.0||0||1.0||N
InpSessionHour=$SessionHour||$SessionHour||0||$SessionHour||N
InpTP1_ClosePct=50||50||0||50||N
InpBreakevenAtTP1=1||1||0||1||N
InpUseTrailing=1||1||0||1||N
InpTrailMode=2||2||0||2||N
InpTP1_R=1.0||0.5||0.5||2.0||Y
InpBEatR=0||0||0.5||1.5||Y
InpTrailFixedPts=1000||410||1197||4000||Y
"@
}

$EAtag="${EA}_${Symbol}_gestione"
if($Fase -eq "distanze"){ $EAtag="${EAtag}_distanze" }
$Work= if($PSScriptRoot){$PSScriptRoot}else{(Get-Location).Path}; Set-Location $Work
Write-Host "=== STUDIO GESTIONE: $EA su $Symbol $Tf (SessionHour SERVER=$SessionHour) a TICK REALI ===" -ForegroundColor Cyan
Write-Host "   48 combinazioni BE/parziale/trailing. Ingresso ai default." -ForegroundColor Gray
New-Item -ItemType Directory -Force -Path (Join-Path $Work "src_gest") | Out-Null
try{Invoke-WebRequest -Uri "$RawBase/mql5/Experts/$EA.mq5" -OutFile (Join-Path $Work "src_gest\$EA.mq5") -UseBasicParsing; Write-Host "   OK src_gest\$EA.mq5 (da $EABranch)" -ForegroundColor Green}
catch{Write-Host "   ERRORE download $EA da $EABranch" -ForegroundColor Red; exit 1}

if(-not $Terminal){
  # v2 -- IL RIFIUTO DI INDOVINARE. Con piu' di un MT5 vivo, "il primo che
  # trovo in Program Files" e' una lotteria che puo' uscire sul terminale
  # delle sedie in forward. Meglio fermarsi e farsi dare il percorso.
  $vivi=@(Get-Process -Name "terminal64" -ErrorAction SilentlyContinue)
  if($vivi.Count -gt 1){
    Write-Host ""
    Write-Host ("STOP: ci sono " + $vivi.Count + " terminali MT5 vivi e -Terminal non e' stato passato.") -ForegroundColor Red
    Write-Host "      Non indovino: qui indovinare vuol dire poter ricompilare un EA" -ForegroundColor Red
    Write-Host "      dentro il terminale di un conto in FORWARD." -ForegroundColor Red
    $vivi | ForEach-Object { Write-Host ("      PID " + $_.Id + "   " + $(if($_.Path){$_.Path}else{"<percorso non leggibile>"})) -ForegroundColor Yellow }
    Write-Host "      Rilancia con:  -Terminal 'C:\MT5_Backtest\terminal64.exe'" -ForegroundColor Cyan
    exit 1
  }
  $allTerm=Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue
  if($UseSpare){$c=$allTerm|?{$_.DirectoryName -like "*BCM Markets*" -and $_.DirectoryName -like "*-V3*"}|Select -First 1}
  else{$c=$allTerm|?{$_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*"}|Select -First 1}
  # 12/09/2026: TOLTO IL RIPIEGO CHE ALLARGAVA IL BERSAGLIO.
  # Qui c'era: se il selettore stretto non ha trovato niente, cerca
  # "*BCM Markets*" e prendi il PRIMO. Due difetti in una riga sola:
  #  - "*BCM Markets*" comprende anche il 100k -V3 (50504263);
  #  - "-First 1" su un insieme trovato per RICERCA non e' una scelta,
  #    e' un SORTEGGIO: nessun ordinamento, cioe' "quello che il
  #    filesystem ha restituito per primo".
  # E questo script SCRIVE e RICOMPILA dentro il terminale che sceglie.
  # Il bersaglio non si allarga mai da solo: si muore.
  if(-not $c){
    Write-Host "Terminale non trovato col selettore stretto, e NON allargo la ricerca." -ForegroundColor Red
    Write-Host "  Il ripiego '*BCM Markets*' comprendeva anche il 100k -V3 (50504263)," -ForegroundColor Red
    Write-Host "  e questo script scrive e compila dentro il terminale che sceglie." -ForegroundColor Red
    exit 1
  }
  if($c){$Terminal=$c.FullName; $MetaEditor=Join-Path $c.DirectoryName "metaeditor64.exe"}
}
if($Terminal -and -not $DataFolder){
  $instDir=Split-Path -Parent $Terminal; $termRoot=Join-Path $env:APPDATA "MetaQuotes\Terminal"
  if(Test-Path $termRoot){$DataFolder=Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue|?{$o=Join-Path $_.FullName "origin.txt";(Test-Path $o)-and((Get-Content $o -Raw).Trim() -ieq $instDir)}|Select -First 1 -ExpandProperty FullName}
}
if(-not $DataFolder -or -not (Test-Path $DataFolder)){Write-Host "Cartella dati non trovata." -ForegroundColor Red; exit 1}
$MqlExperts=Join-Path $DataFolder "MQL5\Experts"; $MqlFiles=Join-Path $DataFolder "MQL5\Files"
$Results=Join-Path $Work "risultati_gestione"; New-Item -ItemType Directory -Force -Path $MqlExperts,$Results|Out-Null
# --- v2: LE DUE PORTE CHIUSE A CHIAVE. Valgono anche se -Terminal e' stato
#     passato a mano: un dito storto non deve poter arrivare al conto reale.
$instDirBT = Split-Path -Parent $Terminal
if($instDirBT -like "*-V3*" -or $instDirBT -like "*BCM_Reale*"){
  Write-Host ("TERMINALE VIETATO: '" + $instDirBT + "'. Il 100k (-V3, 50504263) e il conto REALE (BCM_Reale, 10105439) non si toccano.") -ForegroundColor Red
  exit 1
}
# --- v2: GUARDIA CHIRURGICA (classe 159): solo i processi che girano DENTRO
#     la cartella del bersaglio. Gli altri terminali restano vivi e non
#     bloccano la corsa.
$vivoBersaglio=@(Get-Process -Name "terminal64" -ErrorAction SilentlyContinue | Where-Object { $_.Path -and ($_.Path -like ($instDirBT + "\*")) })
if($vivoBersaglio.Count -gt 0 -and -not $Force){
  Write-Host "!!! Il terminale BERSAGLIO e' aperto: chiudilo (0 CSV altrimenti)." -ForegroundColor Red
  $vivoBersaglio | ForEach-Object { Write-Host ("    PID " + $_.Id + "   " + $_.Path) -ForegroundColor Yellow }
  exit 1
}
Copy-Item (Join-Path $Work "src_gest\$EA.mq5") -Destination $MqlExperts -Force
& $MetaEditor "/compile:$(Join-Path $MqlExperts "$EA.mq5")" "/log" | Out-Null
if(-not (Test-Path (Join-Path $MqlExperts "$EA.ex5"))){Write-Host "ERRORE compilazione $EA" -ForegroundColor Red; exit 1}
Write-Host "   compilato $EA.ex5" -ForegroundColor Green

$iniPath=Join-Path $Work "gestione_${EA}_$Symbol.ini"
@"
[Experts]
AllowLiveTrading=false
AllowDllImport=false

[Tester]
Expert=$EA.ex5
Symbol=$Symbol
Period=$Tf
Model=4
Optimization=1
OptimizationCriterion=6
FromDate=2024.09.26
ToDate=2026.06.30
ForwardMode=0
Deposit=10000
Currency=EUR
Leverage=100
ExecutionMode=0
ReplaceReport=1
ShutdownTerminal=1
Report=OptReport_$EAtag

[TesterInputs]
$Inputs
"@ | Set-Content -Path $iniPath -Encoding ASCII
$csv=Join-Path $MqlFiles "OptResults_${EA}_$Symbol.csv"; if(Test-Path $csv){Remove-Item $csv -Force}
Write-Host "   avvio ottimizzazione 48 combo (TICK REALI M5)... puo' volerci parecchio" -ForegroundColor Cyan
(Start-Process -FilePath $Terminal -ArgumentList "/config:`"$iniPath`"" -PassThru).WaitForExit()
$done=Join-Path $Results "gestione_${EAtag}.csv"
if(Test-Path $csv){Copy-Item $csv -Destination $done -Force; Remove-Item $csv -Force; Write-Host "   OK -> $done" -ForegroundColor Green}
else{Write-Host "   (no CSV: simbolo senza storico tick o nome diverso? verifica)" -ForegroundColor Yellow}
Write-Host "`n=== FINITO === Zippa 'risultati_gestione' e caricamela: ti dico quale STRUTTURA di gestione vince per $Symbol." -ForegroundColor White
