# =====================================================================
#  MARCATORE_RIGA_ANCORA_R119_v3
# ---------------------------------------------------------------------
#  IL PASSO 7 DEL QUARTO MT5: la macchina nuova RIPRODUCE un numero gia'
#  misurato, oppure non e' la stessa macchina.
#
#  Rifa' DUE corse gia' fatte il 07/09 (R119, ExecutionMode=0) sul
#  terminale da backtest, e CONFRONTA i risultati con i numeri agli
#  atti. Il confronto lo fa QUESTO SCRIPT, non l'occhio di chi legge:
#  una condizione stampata non e' un controllo (classe 37-quater).
#
#  I NUMERI ATTESI, dal referto R119 del 07/09/2026 (OOS). VERIFICATI
#  SUI CSV AGLI ATTI, non ricordati:
#    risultati_archivio\ritardo_r119b_csv\
#      ABTG_ORB_Ottimizzato_U30USD_OOS_R119_ORB_D0000.csv
#      ABTG_DAX_Apertura_EU_D30EUR_OOS_R119_DAX_D0000.csv
#    ABTG_ORB_Ottimizzato  U30USD : 2484.17 . PF 1.67490 . DD 6.5389% . 119 trade
#    ABTG_DAX_Apertura_EU  D30EUR : 1103.31 . PF 1.41105 . DD 4.3501% . 270 trade
#
#  >>> SE ESCE DIVERSO NON SI PROSEGUE. Non si "aggiusta l'attesa": si
#      cerca la differenza. Le fonti note di scarto, in ordine:
#      1. tetto delle barre nel grafico (deve essere ILLIMITATO);
#      2. storico non completo sul terminale nuovo;
#      3. tipo di conto diverso (il 50504400 e' HEDGING: verificato);
#      4. specifiche del simbolo diverse.
#
# ---------------------------------------------------------------------
#  COSA E' CAMBIATO DALLA v1 (08/09/2026, verificatore di stringhe).
#  La v1 aveva DUE difetti che facevano fallire il passo 7 al 100%:
#
#  1. CLASSE 158 -- IL CSV DELLA CELLA CONGELATA HA **DUE** RIGHE, NON
#     UNA. I file prova R119 portano l'asse TECNICO sul magic
#     (InpMagic=770611||770611||50||770661||Y): due celle identiche per
#     costruzione, che sono i GEMELLI DI DETERMINISMO G1. La v1
#     pretendeva $righe.Count -eq 1 e avrebbe stampato NON RIPRODUCE su
#     una corsa perfettamente riuscita -- ore di tick reali buttate per
#     un falso negativo. Riprodotto leggendo i CSV veri di R119.
#     Adesso: le righe devono essere TUTTE IDENTICHE (e' il cancello
#     G1, gratis), il confronto si fa sulla prima, e un numero di righe
#     diverso da 2 e' un RILIEVO dichiarato, non un verdetto.
#
#  2. CLASSE 159 -- LA GUARDIA "MT5 APERTO" DEL DRIVER E' GLOBALE, MA
#     SUL VPS I TERMINALI SONO QUATTRO. walkforward_generico.ps1 muore
#     se vede UN QUALSIASI terminal64 vivo. Sul VPS ce ne sono quattro,
#     e uno e' il CONTO REALE con posizioni aperte: la corsa non sarebbe
#     nemmeno partita. Il vincolo vero -- gia' scritto in
#     scarica_storico.ps1 -- e' che dev'essere chiusa QUELLA
#     installazione, non che la macchina sia senza MT5.
#     Adesso: la guardia la fa QUESTO script, CHIRURGICA (solo i
#     processi sotto -TerminaleBacktest), e al driver si passa -Force.
#     I PID degli altri terminali si contano PRIMA e DOPO, e il
#     confronto lo fa il codice.
#
#  COSA E' CAMBIATO DALLA v2 (08/09/2026, dopo il fallimento delle 17:43).
#
#  3. CLASSE 161 -- IL DRIVER NON PORTAVA GLI #include NOSTRI. Il passo 7
#     e' morto SUBITO con "CSV OOS assente o non fresco" su tutte e due
#     le sedie ed ESITO "NON MISURATO -- ZERO CSV letti". Causa:
#     walkforward_generico.ps1 scaricava e copiava solo il .mq5, ma
#     ABTG_ORB_Ottimizzato (r.106) e ABTG_DAX_Apertura_EU (r.132) hanno
#     #include <ABTG_PausaGuardian.mqh>, e C:\MT5_Backtest e'
#     un'installazione NUOVA E VUOTA: niente include, niente .ex5,
#     driver morto a codice 1 prima ancora di aprire MT5.
#     Rimedio nel driver, non qui: la v5 porta gli include nostri in
#     MQL5\Include (sottocartelle comprese) e li dichiara a schermo.
#     Qui cambia UNA COSA SOLA: il marcatore preteso passa da
#     MARCATORE_WALKFORWARD_GENERICO_v4_TERMINALE_BACKTEST a
#     MARCATORE_WALKFORWARD_GENERICO_v5_INCLUDE. Senza questa riga
#     l'ancora rifiuterebbe il driver CORRETTO dicendo "e' vecchio".
#
#  NIENTE EMOJI: Windows PowerShell 5.1 legge i .ps1 come ANSI.
# =====================================================================

param(
  [string]$Pin               = "lavoro",
  [string]$TerminaleBacktest = "C:\MT5_Backtest",
  [string]$Work              = "$env:USERPROFILE\abtg_ancora",
  [switch]$ChiudiBacktest,
  [switch]$SoloControllo
)

$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$MARC_MIO = "MARCATORE_RIGA_ANCORA_R119_v3"
$MARC_DRV = "MARCATORE_WALKFORWARD_GENERICO_v5_INCLUDE"
$RawBase  = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"
$Avvio    = Get-Date

$RILIEVI = New-Object System.Collections.ArrayList
function Muori($m){ Write-Host ""; Write-Host ("ERRORE: " + $m) -ForegroundColor Red; exit 1 }
function Rilievo($m){ [void]$RILIEVI.Add($m); Write-Host ("    RILIEVO: " + $m) -ForegroundColor DarkYellow }

# --- le due sedie e i numeri attesi -----------------------------------
$SEDIE = @(
  @{ Chi="ORB"; EA="ABTG_ORB_Ottimizzato"; Sim="U30USD";
     Prova="ABTG_ORB_Ottimizzato_RITARDO.txt";
     Profit=2484.17; PF=1.67490; DD=6.5389; Trades=119 },
  @{ Chi="DAX"; EA="ABTG_DAX_Apertura_EU"; Sim="D30EUR";
     Prova="ABTG_DAX_Apertura_EU_RITARDO.txt";
     Profit=1103.31; PF=1.41105; DD=4.3501; Trades=270 }
)

# --- tolleranze DICHIARATE (mezza unita' dell'ultima cifra stampata) ---
#     Profit 2 decimali -> 0.005 ; PF 5 -> 0.000005 ; DD 4 -> 0.00005.
$TOL_PROFIT = 0.005
$TOL_PF     = 0.000005
$TOL_DD     = 0.00005

Write-Host "=== ANCORA R119 SUL TERMINALE DA BACKTEST ==="
Write-Host ("    " + $MARC_MIO) -ForegroundColor DarkGray
Write-Host ("data: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss"))
Write-Host ("pin : " + $Pin)
Write-Host ("term: " + $TerminaleBacktest)

# =====================================================================
#  0. IL TERMINALE: SI NOMINA, E LE GUARDIE NON SI ALLENTANO
# =====================================================================
$cartellaBT = $TerminaleBacktest.TrimEnd('\','/')
if($cartellaBT -like "*-V3*" -or $cartellaBT -like "*BCM_Reale*"){
  Muori ("TERMINALE VIETATO: '" + $cartellaBT + "'. Il 100k (-V3, 50504263) e il conto REALE (BCM_Reale, 10105439) non si toccano. Il terminale da backtest e' C:\MT5_Backtest (demo 50504400).")
}
if(-not (Test-Path -LiteralPath $cartellaBT -PathType Container)){ Muori ("la cartella '" + $cartellaBT + "' non esiste su questa macchina.") }
$exeBT = Join-Path $cartellaBT "terminal64.exe"
if(-not (Test-Path -LiteralPath $exeBT -PathType Leaf)){ Muori ("in '" + $cartellaBT + "' non c'e' terminal64.exe: va passata la CARTELLA PROGRAMMA del terminale.") }

# --- censimento PRIMA. Il bersaglio e' UNO SOLO: quello sotto $cartellaBT.
function Terminali(){ return @(Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) }
function Bersagli($proc){ return @($proc | Where-Object { $_.Path -and ($_.Path -like ($cartellaBT + "\*")) }) }
function Risparmiati($proc){ return @($proc | Where-Object { -not ($_.Path -and ($_.Path -like ($cartellaBT + "\*"))) }) }

$tutti  = Terminali
$berPri = Bersagli $tutti
$salPri = Risparmiati $tutti
$pidSalvi = @($salPri | ForEach-Object { $_.Id })

Write-Host ""
Write-Host "--- TERMINALI MT5 VISTI ADESSO (PRIMA) ------------------------------" -ForegroundColor Cyan
if($berPri.Count -eq 0){ Write-Host "  BERSAGLIO (terminale da backtest): nessuno vivo. Bene." -ForegroundColor Green }
else{
  Write-Host "  BERSAGLIO (terminale da backtest, l'unico che posso chiudere):" -ForegroundColor Yellow
  $berPri | ForEach-Object { Write-Host ("    PID " + $_.Id + "    " + $_.Path) -ForegroundColor Yellow }
}
Write-Host "  LASCIATI VIVI (forward e CONTO REALE: NON li tocco):" -ForegroundColor Green
if($salPri.Count -eq 0){ Write-Host "    (nessuno)" -ForegroundColor Green }
else{ $salPri | ForEach-Object { Write-Host ("    PID " + $_.Id + "    " + $(if($_.Path){$_.Path}else{"<percorso non leggibile: NON e' un bersaglio>"})) -ForegroundColor Green } }
Write-Host "---------------------------------------------------------------------" -ForegroundColor Cyan

if($berPri.Count -gt 0 -and -not $SoloControllo){
  if($ChiudiBacktest){
    Write-Host ""
    Write-Host "  -ChiudiBacktest: chiudo SOLO il terminale da backtest." -ForegroundColor Yellow
    $berPri | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 6
    $berPri = Bersagli (Terminali)
  }
  if($berPri.Count -gt 0){
    Muori ("il terminale da backtest e' APERTO: il tester non partirebbe e uscirebbero ZERO CSV.`n" +
           "    Chiudi a mano " + $exeBT + " oppure rilancia con -ChiudiBacktest:`n" +
           "    verra' chiuso SOLO quel processo, gli altri terminali (forward e CONTO REALE) restano vivi.")
  }
}

# =====================================================================
#  0-bis. IL TETTO DELLE BARRE NEL GRAFICO
#  D30EUR M5 = 129.930 barre, U30USD M5 = 133.819: sopra il tetto di
#  default (100.000). Con quel tetto l'ancora gira su MENO storico e il
#  numero esce diverso -- e passeremmo la giornata a cercare il difetto
#  nel posto sbagliato.
# =====================================================================
$DataFolder = ""
$termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
if(Test-Path -LiteralPath $termRoot){
  foreach($d in @(Get-ChildItem -LiteralPath $termRoot -Directory -ErrorAction SilentlyContinue)){
    if($d.Name -ieq "Common"){ continue }
    $o = Join-Path $d.FullName "origin.txt"
    if(-not (Test-Path -LiteralPath $o)){ continue }
    $inst = ""
    try{ $inst = (Get-Content -LiteralPath $o -Raw -ErrorAction Stop).Trim() }catch{ continue }
    if($inst -ieq $cartellaBT){ $DataFolder = $d.FullName; break }
  }
}
if(-not $DataFolder -and (Test-Path -LiteralPath (Join-Path $cartellaBT "config\common.ini"))){ $DataFolder = $cartellaBT }

$MaxBars = $null
if($DataFolder){
  $ciFile = Join-Path $DataFolder "config\common.ini"
  if(Test-Path -LiteralPath $ciFile){
    foreach($l in @(Get-Content -LiteralPath $ciFile -ErrorAction SilentlyContinue)){
      if($l -match '^\s*MaxBars(InChart)?\s*=\s*([0-9]+)\s*$'){ $MaxBars = [int64]$matches[2] }
    }
  }
}
Write-Host ""
if($null -ne $MaxBars -and $MaxBars -ge 1000 -and $MaxBars -lt 200000){
  Muori ("TETTO BARRE NEL GRAFICO = " + $MaxBars + " (config\common.ini di " + $DataFolder + ").`n" +
         "    Serve ILLIMITATO: D30EUR M5 ha 129.930 barre e U30USD M5 ne ha 133.819.`n" +
         "    Con questo tetto l'ancora gira su MENO storico e NON puo' riprodurre.`n" +
         "    Apri " + $exeBT + " (conto 50504400), Strumenti > Opzioni > Grafici >`n" +
         "    'Max barre nel grafico' = Illimitato, CHIUDI il terminale, e rilancia.")
}
elseif($null -ne $MaxBars){ Write-Host ("    tetto barre: MaxBars=" + $MaxBars + " -- sufficiente.") -ForegroundColor Green }
else{
  Write-Host "    tetto barre: NON VERIFICABILE da qui (nessuna chiave MaxBars leggibile)." -ForegroundColor Yellow
  Write-Host "    CONTROLLALO A MANO PRIMA DI LASCIAR GIRARE: Strumenti > Opzioni >" -ForegroundColor Yellow
  Write-Host "    Grafici > 'Max barre nel grafico' = Illimitato sul terminale 50504400." -ForegroundColor Yellow
  Rilievo "tetto barre nel grafico NON verificato dal codice (chiave MaxBars non trovata)"
}

# =====================================================================
#  1. SCARICO DRIVER E FILE PROVA (regola delle righe di lancio, punto 1)
# =====================================================================
$Prove = Join-Path $Work "prove"
New-Item -ItemType Directory -Force -Path $Work  | Out-Null
New-Item -ItemType Directory -Force -Path $Prove | Out-Null

function Scarica($url,$dst){
  Remove-Item -LiteralPath $dst -Force -ErrorAction SilentlyContinue
  $u = $url + "?cb=" + [Guid]::NewGuid().ToString("N")   # cache di GitHub raw (~5 min)
  try  { Invoke-WebRequest -Uri $u -OutFile $dst -UseBasicParsing -TimeoutSec 120 }
  catch{ Muori ("scarico fallito: " + $url + " -- " + $_.Exception.Message) }
  if(-not (Test-Path -LiteralPath $dst)){ Muori ("file non scaricato: " + $url) }
}

$drv = Join-Path $Work "walkforward_generico.ps1"
Scarica ($RawBase + "/backtest_pipeline/walkforward_generico.ps1") $drv
if(-not (Select-String -LiteralPath $drv -SimpleMatch -Pattern $MARC_DRV -Quiet)){
  Muori ("il driver scaricato NON ha il marcatore " + $MARC_DRV + ": e' una copia vecchia. Senza la v5 non porta gli #include nostri sul terminale, l'EA non compila e il round muore con ZERO CSV. Non si prosegue.")
}
Write-Host ""
Write-Host "    driver: scaricato e marcatore v5 verificato." -ForegroundColor Green

foreach($s in $SEDIE){ Scarica ($RawBase + "/backtest_pipeline/prove/" + $s.Prova) (Join-Path $Prove $s.Prova) }
Write-Host ("    file prova: " + $SEDIE.Count + " scaricati.") -ForegroundColor Green

# 155/155-bis: i CSV di una corsa precedente NON devono finire nello zip di oggi.
$Ris = Join-Path $Work "risultati_prove"
if(Test-Path -LiteralPath $Ris){ Remove-Item -LiteralPath $Ris -Recurse -Force; Write-Host "    risultati_prove SVUOTATA (lo zip e' di QUESTA corsa)." -ForegroundColor DarkYellow }

# =====================================================================
#  2. LE DUE CORSE
# =====================================================================
function Corri($sedia){
  $et = "ANCORA"
  $pr = Join-Path $Prove $sedia.Prova
  # -Force: la guardia "MT5 aperto" del driver e' GLOBALE (classe 159) e sul
  # VPS ci sono quattro terminali. Quella CHIRURGICA l'ha gia' fatta questo
  # script qui sopra: il bersaglio e' chiuso, gli altri tre restano vivi.
  $arg = @("-NoProfile","-ExecutionPolicy","Bypass","-File",$drv,
           "-Expert",$sedia.EA,"-Prova",$pr,"-Ritardo","0",
           "-Etichetta",$et,"-Modello","4","-Rifai","-Force",
           "-TerminaleBacktest",$cartellaBT)
  if($SoloControllo){ $arg += "-SoloControllo" }
  Write-Host ""
  Write-Host ("--- " + $sedia.Chi + " (" + $sedia.EA + " " + $sedia.Sim + ") ---") -ForegroundColor Cyan
  $t0 = Get-Date
  $p  = Start-Process -FilePath "powershell.exe" -ArgumentList $arg -NoNewWindow -PassThru -Wait
  $base = Join-Path $Work ("risultati_prove\" + $sedia.EA + "\" + $sedia.EA + "_" + $sedia.Sim + "_")
  $csv  = $base + "OOS_" + $et + ".csv"
  $isc  = $base + "IS_"  + $et + ".csv"
  if($p.ExitCode -ne 0){
    Rilievo ("driver uscito con codice " + $p.ExitCode + " su " + $sedia.Chi + " -- classe 154: e' l'ultimo .exe lanciato dentro, NON un verdetto. Il verdetto sta sul CSV.")
  }
  $fresco = (Test-Path -LiteralPath $csv) -and ((Get-Item -LiteralPath $csv).LastWriteTime -ge $t0)
  return @{ Csv=$csv; Is=$isc; Fresco=$fresco }
}

function Numero($s){
  if($null -eq $s){ return $null }
  $t = ("" + $s).Trim().Replace(",",".")
  $v = 0.0
  if([double]::TryParse($t,[Globalization.NumberStyles]::Float,[Globalization.CultureInfo]::InvariantCulture,[ref]$v)){ return $v }
  return $null
}

if($SoloControllo){
  Write-Host ""
  Write-Host "=== GIRO A VUOTO (-SoloControllo): MT5 NON viene aperto ===" -ForegroundColor Yellow
  foreach($s in $SEDIE){ [void](Corri $s) }
  Write-Host ""
  Write-Host "  CONTROLLA QUI SOPRA, PER TUTTE E DUE LE SEDIE:" -ForegroundColor Yellow
  Write-Host "    a) il conto delle celle deve dire 2 (l'asse tecnico sul magic)." -ForegroundColor Yellow
  Write-Host "    b) nell'anteprima dell'.ini ci deve essere  ExecutionMode=0" -ForegroundColor Yellow
  Write-Host "    c) IS/OOS devono partire da 2024.09.26 e finire al 2026.06.30." -ForegroundColor Yellow
  Write-Host "  ATTENZIONE: con -SoloControllo il driver esce PRIMA di scegliere il" -ForegroundColor Yellow
  Write-Host "  terminale, quindi questo giro NON collauda -TerminaleBacktest." -ForegroundColor Yellow
  exit 0
}

$esiti = @()
foreach($s in $SEDIE){
  $r = Corri $s
  $ok = $true; $note = @()

  if(-not $r.Fresco){
    $ok = $false; $note += "CSV OOS assente o non fresco: la corsa non ha prodotto risultati"
  } else {
    $righe = @(Import-Csv -LiteralPath $r.Csv)
    if($righe.Count -eq 0){
      $ok = $false; $note += "il CSV OOS ha ZERO righe (solo intestazione): nessuna passata eseguita"
    } else {
      # G1 -- GEMELLI DI DETERMINISMO: le celle dell'asse tecnico sul magic
      # sono identiche per costruzione. Se divergono, il banco non e'
      # deterministico e l'ancora non vuol dire niente.
      $firme = @()
      foreach($y in $righe){ $firme += ("{0}|{1}|{2}|{3}" -f $y.Profit, $y.'Profit Factor', $y.'Equity DD %', $y.Trades) }
      $uniche = @($firme | Select-Object -Unique)
      if($righe.Count -ne 2){ Rilievo ($s.Chi + ": il CSV OOS ha " + $righe.Count + " righe, l'asse tecnico sul magic ne vuole 2") }
      if($uniche.Count -ne 1){
        $ok = $false; $note += ("gemelli G1 DIVERSI su " + $righe.Count + " righe: banco NON deterministico")
      }

      $x = $righe[0]
      $pProfit = Numero $x.'Profit'
      $pPF     = Numero $x.'Profit Factor'
      $pDD     = Numero $x.'Equity DD %'
      $pTr     = Numero $x.'Trades'

      if($null -eq $pProfit -or $null -eq $pPF -or $null -eq $pDD -or $null -eq $pTr){
        $ok = $false; $note += "colonne non leggibili nel CSV (Profit / Profit Factor / Equity DD % / Trades)"
      } else {
        if([math]::Abs($pProfit - $s.Profit) -gt $TOL_PROFIT){ $ok=$false; $note += ("Profit " + $pProfit + " atteso " + $s.Profit) }
        if([math]::Abs($pPF     - $s.PF)     -gt $TOL_PF)    { $ok=$false; $note += ("PF "     + $pPF     + " atteso " + $s.PF) }
        if([math]::Abs($pDD     - $s.DD)     -gt $TOL_DD)    { $ok=$false; $note += ("DD "     + $pDD     + " atteso " + $s.DD) }
        if([int]$pTr -ne [int]$s.Trades)                     { $ok=$false; $note += ("Trades " + $pTr     + " atteso " + $s.Trades) }
        Write-Host ("    letto : Profit " + $pProfit + " . PF " + $pPF + " . DD " + $pDD + " . Trades " + $pTr + "   (righe: " + $righe.Count + ", gemelli G1: " + $(if($uniche.Count -eq 1){"IDENTICI"}else{"DIVERSI"}) + ")")
        Write-Host ("    atteso: Profit " + $s.Profit + " . PF " + $s.PF + " . DD " + $s.DD + " . Trades " + $s.Trades)
      }
    }
  }

  if($ok){ Write-Host ("    " + $s.Chi + " RIPRODUCE: IDENTICO ALLA CIFRA") -ForegroundColor Green }
  else   { Write-Host ("    NON RIPRODUCE: " + ($note -join " . ")) -ForegroundColor Red }
  $esiti += @{ Chi=$s.Chi; Ok=$ok; Note=($note -join " . "); Csv=$r.Csv; Is=$r.Is; Fresco=$r.Fresco }
}

# =====================================================================
#  3. IL CONTO REALE E' INTATTO? SI CONTA, NON SI SPERA.
# =====================================================================
$dopo   = Terminali
$salDopo= Risparmiati $dopo
$pidDopo= @($salDopo | ForEach-Object { $_.Id })
$persi  = @($pidSalvi | Where-Object { $pidDopo -notcontains $_ })
Write-Host ""
Write-Host "--- TERMINALI MT5 (DOPO) --------------------------------------------" -ForegroundColor Cyan
Write-Host ("  PID vivi PRIMA (non bersaglio): " + $(if($pidSalvi.Count -gt 0){$pidSalvi -join " . "}else{"nessuno"}))
Write-Host ("  PID vivi DOPO  (non bersaglio): " + $(if($pidDopo.Count -gt 0){$pidDopo -join " . "}else{"nessuno"}))
if($persi.Count -eq 0){ Write-Host "  STESSI PID: forward e conto reale NON sono stati toccati." -ForegroundColor Green }
else{
  Write-Host ("  MANCANO ALL'APPELLO: " + ($persi -join " . ")) -ForegroundColor Red
  Rilievo ("terminali NON bersaglio spariti durante la corsa: PID " + ($persi -join ", ") + " -- CONTROLLA SUBITO IL CONTO REALE 10105439")
}
Write-Host "---------------------------------------------------------------------" -ForegroundColor Cyan

# =====================================================================
#  4. IL VERDETTO
# =====================================================================
$buone = @($esiti | Where-Object { $_.Ok }).Count
$letti = @($esiti | Where-Object { $_.Fresco }).Count
Write-Host ""
Write-Host "====================================================================="
foreach($e in $esiti){
  if($e.Ok){ Write-Host ("  " + $e.Chi.PadRight(6) + " RIPRODUCE") -ForegroundColor Green }
  else     { Write-Host ("  " + $e.Chi.PadRight(6) + " NO -- " + $e.Note) -ForegroundColor Red }
}
if($letti -eq 0){ $esitoFinale = "NON MISURATO -- ZERO CSV letti" }
elseif($buone -eq $SEDIE.Count -and $persi.Count -eq 0){ $esitoFinale = "ANCORA SUPERATA" }
elseif($buone -eq $SEDIE.Count){ $esitoFinale = "ANCORA SUPERATA MA CON RILIEVI SUI TERMINALI" }
else{ $esitoFinale = "ANCORA NON SUPERATA -- " + $buone + " sedie su " + $SEDIE.Count }

Write-Host ""
if($esitoFinale -eq "ANCORA SUPERATA"){
  Write-Host "  ANCORA SUPERATA: la macchina nuova riproduce i numeri agli atti." -ForegroundColor Green
  Write-Host "  Da qui in avanti i round possono girare su questo terminale." -ForegroundColor Green
} else {
  Write-Host ("  " + $esitoFinale) -ForegroundColor Red
  Write-Host "  NON si aggiusta l'attesa: si cerca la differenza." -ForegroundColor Red
  Write-Host "  Guardare, in ordine: tetto barre nel grafico (ILLIMITATO), storico" -ForegroundColor Red
  Write-Host "  completo, tipo di conto (HEDGING), specifiche del simbolo." -ForegroundColor Red
}
Write-Host "====================================================================="

# =====================================================================
#  5. REFERTO + RACCOLTA (regola delle righe di lancio, punti 2 e 3)
# =====================================================================
$dsk = [Environment]::GetFolderPath("Desktop")
$d   = Join-Path $dsk "ANCORA_R119"
if(Test-Path -LiteralPath $d){ Remove-Item -LiteralPath $d -Recurse -Force }
New-Item -ItemType Directory -Force -Path $d | Out-Null

$R = New-Object System.Collections.ArrayList
function W($t){ [void]$R.Add($t) }
W ("REFERTO ANCORA R119 -- PASSO 7 DEL QUARTO MT5")
W ("marcatore riga  : " + $MARC_MIO)
W ("marcatore driver: " + $MARC_DRV)
W ("pin             : " + $Pin)
W ("data            : " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss") + "   <-- SE QUESTA DATA NON E' DI OGGI, IL FILE E' VECCHIO")
W ("terminale       : " + $exeBT)
W ("tetto barre     : " + $(if($null -ne $MaxBars){"MaxBars=" + $MaxBars}else{"NON VERIFICATO (chiave MaxBars non trovata)"}))
W ("")
W ("--- LE DUE SEDIE ---")
foreach($e in $esiti){
  W ("  " + $e.Chi + " : " + $(if($e.Ok){"RIPRODUCE"}else{"NO -- " + $e.Note}))
}
W ("")
W ("CSV OOS attesi: " + $SEDIE.Count + "   LETTI: " + $letti)
W ("PID non bersaglio PRIMA: " + $(if($pidSalvi.Count -gt 0){$pidSalvi -join ", "}else{"nessuno"}))
W ("PID non bersaglio DOPO : " + $(if($pidDopo.Count -gt 0){$pidDopo -join ", "}else{"nessuno"}))
W ("")
W ("RILIEVI: " + $RILIEVI.Count)
foreach($x in $RILIEVI){ W ("  - " + $x) }
W ("")
W ("ESITO: " + $esitoFinale)
$ref = Join-Path $d "REFERTO_ANCORA_R119.txt"
($R -join "`r`n") | Set-Content -LiteralPath $ref -Encoding ASCII

$n = 0
foreach($e in $esiti){
  foreach($f in @($e.Csv,$e.Is)){
    if((Test-Path -LiteralPath $f) -and ((Get-Item -LiteralPath $f).LastWriteTime -ge $Avvio)){ Copy-Item -LiteralPath $f -Destination $d -Force; $n++ }
  }
}
foreach($s in $SEDIE){ Copy-Item -LiteralPath (Join-Path $Prove $s.Prova) -Destination $d -Force -ErrorAction SilentlyContinue }

$zip = Join-Path $dsk "ANCORA_R119.zip"
if(Test-Path -LiteralPath $zip){ Remove-Item -LiteralPath $zip -Force }
Compress-Archive -Path (Join-Path $d "*") -DestinationPath $zip -Force

Write-Host ""
Write-Host ("RACCOLTA: " + $d)
Write-Host ("CSV di QUESTA corsa copiati: " + $n + "   (attesi 4: IS+OOS per sedia)")
Write-Host ("ZIP PRONTO DA MANDARE: " + $zip) -ForegroundColor Green
Write-Host "FILE ATTESI NELLO ZIP:" -ForegroundColor Gray
Write-Host "   REFERTO_ANCORA_R119.txt" -ForegroundColor Gray
foreach($s in $SEDIE){
  Write-Host ("   " + $s.EA + "_" + $s.Sim + "_IS_ANCORA.csv") -ForegroundColor Gray
  Write-Host ("   " + $s.EA + "_" + $s.Sim + "_OOS_ANCORA.csv") -ForegroundColor Gray
  Write-Host ("   " + $s.Prova) -ForegroundColor Gray
}
# Out-Host: senza, Format-Table esce DOPO le Write-Host che seguono e l'ESITO
# finirebbe stampato sopra la tabella. Cosmetico, ma si legge al contrario.
Get-ChildItem -LiteralPath $d | Select-Object Name,Length,LastWriteTime | Format-Table -AutoSize | Out-Host
Write-Host ""
Write-Host ("ESITO: " + $esitoFinale) -ForegroundColor $(if($esitoFinale -eq "ANCORA SUPERATA"){"Green"}else{"Yellow"})
Write-Host ("Nel referto la riga 'data:' dice " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss") + ": e' quella da leggere per sapere se il file e' di oggi.") -ForegroundColor Gray

if($esitoFinale -eq "ANCORA SUPERATA"){ exit 0 }
exit 3
