# =====================================================================
#  studio_apertura.ps1  --  FASE A: MISURARE il comportamento delle
#  aperture su piu' indici, per tarare UN motore unico.
#
#  Lancia ABTG_Apertura_Study_EA (che SIMULA, non manda ordini) su ogni
#  indice, ognuno alla SUA ora di apertura. L'EA misura per ogni giorno:
#  ampiezza range, MAE (quanto va contro), MFE (quanto corre a favore),
#  durata. Da questi numeri decidiamo SL, BE, trailing, dimezza-lotto.
#
#  Va sul PC FISSO (non sul VPS: li' girano gli EA in forward).
#  MetaTrader dev'essere CHIUSO prima di lanciarlo.
#
#  Uso:
#    powershell -ExecutionPolicy Bypass -File .\studio_apertura.ps1
#  Ripresa: salta gli indici gia' fatti (CSV gia' presente).
#
#  A fine giro: zippa .\risultati_studio_apertura e mandamela.
# =====================================================================
param(
  [switch]$UseSpare,[string]$Terminal="",[string]$MetaEditor="",[string]$DataFolder="",[switch]$Force
)
$ErrorActionPreference="Stop"
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
$EA="ABTG_Apertura_Study_EA"
$Branch="lavoro"     # branch di lavoro (prima puntava a claude/ea-market-openings-d79m8l, ormai fermo)
$RawBase="https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Branch"

# --- BUCKET: ogni indice con la SUA ora di apertura (ORA SERVER = IT-1) ---
#  EU  : apre 09:00 IT = 08:00 server ; chiusura studio 17:30 IT = 16:30 server
#  USA : apre 15:30 IT = 14:30 server ; chiusura studio 22:00 IT = 21:00 server
#  ⚠️ Verifica l'apertura sul TUO grafico BCM e correggi qui se serve.
$Jobs=@(
  # --- EUROPA: apertura 09:00 IT = 08:00 server, cutoff 17:30 IT = 16:30 server ---
  @{ Sym="D30EUR"; Nome="DAX";        SH=8;  SM=0;  CH=16; CM=30 },
  @{ Sym="F40EUR"; Nome="CAC40";      SH=8;  SM=0;  CH=16; CM=30 },
  @{ Sym="E50EUR"; Nome="EuroStoxx";  SH=8;  SM=0;  CH=16; CM=30 },
  @{ Sym="100GBP"; Nome="FTSE100";    SH=8;  SM=0;  CH=16; CM=30 },
  @{ Sym="E35EUR"; Nome="IBEX35";     SH=8;  SM=0;  CH=16; CM=30 },
  # --- USA: apertura 15:30 IT = 14:30 server, cutoff 22:00 IT = 21:00 server ---
  @{ Sym="NASUSD"; Nome="Nasdaq";     SH=14; SM=30; CH=21; CM=0  },
  @{ Sym="U30USD"; Nome="Dow";        SH=14; SM=30; CH=21; CM=0  },
  @{ Sym="SPXUSD"; Nome="SP500";      SH=14; SM=30; CH=21; CM=0  }
  # --- ASIA (opzionali): apertura notturna, ora server DA VERIFICARE sul grafico ---
  # @{ Sym="225JPY"; Nome="Nikkei"; SH=1; SM=0; CH=7; CM=0 },   # Tokyo ~09:00 JST -> ~01:00 server (verifica!)
  # @{ Sym="200AUD"; Nome="ASX";    SH=1; SM=0; CH=6; CM=0 },   # Sydney ~10:00 AEST -> ~01:00 server (verifica!)
)

$Work= if($PSScriptRoot){$PSScriptRoot}else{(Get-Location).Path}; Set-Location $Work
Write-Host "=== STUDIO APERTURA: $($Jobs.Count) indici (passaggio singolo, OHLC) ===" -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path (Join-Path $Work "src_v2"),(Join-Path $Work "ini_studio") | Out-Null

# --- scarica l'EA di studio ---
try{Invoke-WebRequest -Uri "$RawBase/mql5/Experts/$EA.mq5" -OutFile (Join-Path $Work "src_v2\$EA.mq5") -UseBasicParsing; Write-Host "   OK src_v2\$EA.mq5" -ForegroundColor Green}
catch{Write-Host "   ERRORE download $EA" -ForegroundColor Red; exit 1}

# --- trova terminale/metaeditor/cartella dati (come lo scan) ---
if(-not $Terminal){
  $allTerm=Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue
  if($UseSpare){$c=$allTerm|?{$_.DirectoryName -like "*BCM Markets*" -and $_.DirectoryName -like "*-V3*"}|Select -First 1}
  else{$c=$allTerm|?{$_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*"}|Select -First 1}
  if(-not $c){$c=$allTerm|?{$_.DirectoryName -like "*BCM Markets*"}|Select -First 1}
  if($c){$Terminal=$c.FullName; $MetaEditor=Join-Path $c.DirectoryName "metaeditor64.exe"}
}
if($Terminal -and -not $DataFolder){
  $instDir=Split-Path -Parent $Terminal; $termRoot=Join-Path $env:APPDATA "MetaQuotes\Terminal"
  if(Test-Path $termRoot){$DataFolder=Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue|?{$o=Join-Path $_.FullName "origin.txt";(Test-Path $o)-and((Get-Content $o -Raw).Trim() -ieq $instDir)}|Select -First 1 -ExpandProperty FullName}
}
if(-not $DataFolder -or -not (Test-Path $DataFolder)){Write-Host "Cartella dati non trovata." -ForegroundColor Red; exit 1}
$MqlExperts=Join-Path $DataFolder "MQL5\Experts"
# l'EA scrive con FILE_COMMON -> i CSV finiscono in ...\Terminal\Common\Files
$CommonFiles=Join-Path $env:APPDATA "MetaQuotes\Terminal\Common\Files"
$Results=Join-Path $Work "risultati_studio_apertura"; New-Item -ItemType Directory -Force -Path $MqlExperts,$Results,$CommonFiles|Out-Null
if((Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) -and -not $Force){Write-Host "!!! Chiudi MetaTrader prima (0 CSV altrimenti)." -ForegroundColor Red; exit 1}

# --- compila ---
Copy-Item (Join-Path $Work "src_v2\$EA.mq5") -Destination $MqlExperts -Force
& $MetaEditor "/compile:$(Join-Path $MqlExperts "$EA.mq5")" "/log" | Out-Null
if(-not (Test-Path (Join-Path $MqlExperts "$EA.ex5"))){Write-Host "ERRORE compilazione $EA" -ForegroundColor Red; exit 1}
Write-Host "   compilato $EA.ex5" -ForegroundColor Green

# --- giro sugli indici ---
$n=0
foreach($j in $Jobs){
  $n++; $sym=$j.Sym
  $done=Join-Path $Results "Studio_$sym.csv"
  if(Test-Path $done){Write-Host ("   [{0}/{1}] {2} ({3}): gia' fatto, salto" -f $n,$Jobs.Count,$sym,$j.Nome) -ForegroundColor DarkGray; continue}
  $iniPath=Join-Path $Work "ini_studio\studio_$sym.ini"
  @"
[Tester]
Expert=$EA.ex5
Symbol=$sym
Period=M5
Model=1
Optimization=0
FromDate=2024.01.01
ToDate=2026.06.30
ForwardMode=0
Deposit=10000
Currency=EUR
Leverage=100
ExecutionMode=0
ReplaceReport=1
ShutdownTerminal=1
Report=Report_Studio_$sym

[TesterInputs]
InpSessionHour=$($j.SH)
InpSessionMin=$($j.SM)
InpRangeMinutes=15
InpCutoffHour=$($j.CH)
InpCutoffMin=$($j.CM)
InpBufferPts=200
InpSlippagePts=100
InpTP_R=2.0
InpH4EmaPeriod=50
"@ | Set-Content -Path $iniPath -Encoding ASCII

  # pulisco eventuali CSV vecchi di questo simbolo in Common\Files
  $det=Join-Path $CommonFiles "ABTG_Apertura_Study_$sym.csv"
  $rie=Join-Path $CommonFiles "ABTG_Apertura_Study_${sym}_RIEPILOGO.csv"
  foreach($f in @($det,$rie)){ if(Test-Path $f){Remove-Item $f -Force} }

  Write-Host ("   [{0}/{1}] {2} ({3})  apertura {4:00}:{5:00} server..." -f $n,$Jobs.Count,$sym,$j.Nome,$j.SH,$j.SM) -ForegroundColor Cyan
  (Start-Process -FilePath $Terminal -ArgumentList "/config:`"$iniPath`"" -PassThru).WaitForExit()

  if(Test-Path $det){
    Copy-Item $det -Destination $done -Force
    if(Test-Path $rie){ Copy-Item $rie -Destination (Join-Path $Results "Studio_${sym}_RIEPILOGO.csv") -Force }
    Write-Host ("        OK -> Studio_$sym.csv  (+ _RIEPILOGO)") -ForegroundColor Green
  } else {
    Write-Host ("        (no CSV: {0} senza storico/nome diverso? verifica) " -f $sym) -ForegroundColor Yellow
  }
}
Write-Host "`n=== FINITO === risultati in $Results" -ForegroundColor Cyan
Write-Host "Zippa la cartella risultati_studio_apertura e caricamela: analizzo MAE/MFE/ampiezza e ti dico SL, BE, trailing e dimezza-lotto per indice." -ForegroundColor White
