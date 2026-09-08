# =====================================================================
#  MARCATORE_RIGA_ANCORA_R119_v1
# ---------------------------------------------------------------------
#  IL PASSO 7 DEL QUARTO MT5: la macchina nuova RIPRODUCE un numero gia'
#  misurato, oppure non e' la stessa macchina.
#
#  Rifa' DUE corse gia' fatte il 07/09 (R119, ExecutionMode=0) sul
#  terminale da backtest, e CONFRONTA i risultati con i numeri agli
#  atti. Il confronto lo fa QUESTO SCRIPT, non l'occhio di chi legge:
#  una condizione stampata non e' un controllo (classe 37-quater).
#
#  I NUMERI ATTESI, dal referto R119 del 07/09/2026 (OOS):
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
#  NIENTE EMOJI: Windows PowerShell 5.1 legge i .ps1 come ANSI.
# =====================================================================

param(
  [string]$Pin               = "lavoro",
  [string]$TerminaleBacktest = "C:\MT5_Backtest",
  [string]$Work              = "$env:USERPROFILE\abtg_ancora",
  [switch]$SoloControllo
)

$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$MARC_DRV = "MARCATORE_WALKFORWARD_GENERICO_v4_TERMINALE_BACKTEST"
$RawBase  = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

function Muori($m){ Write-Host ""; Write-Host ("ERRORE: " + $m) -ForegroundColor Red; exit 1 }

# --- le due sedie e i numeri attesi -----------------------------------
$SEDIE = @(
  @{ Chi="ORB"; EA="ABTG_ORB_Ottimizzato"; Sim="U30USD";
     Prova="ABTG_ORB_Ottimizzato_RITARDO.txt";
     Profit=2484.17; PF=1.67490; DD=6.5389; Trades=119 },
  @{ Chi="DAX"; EA="ABTG_DAX_Apertura_EU"; Sim="D30EUR";
     Prova="ABTG_DAX_Apertura_EU_RITARDO.txt";
     Profit=1103.31; PF=1.41105; DD=4.3501; Trades=270 }
)

# --- tolleranze DICHIARATE (l'ultima cifra stampata dal tester) --------
$TOL_PROFIT = 0.005
$TOL_PF     = 0.000005
$TOL_DD     = 0.00005

Write-Host "=== ANCORA R119 SUL TERMINALE DA BACKTEST ==="
Write-Host ("data: " + (Get-Date -Format "yyyy-MM-dd HH:mm:ss"))
Write-Host ("pin : " + $Pin)
Write-Host ("term: " + $TerminaleBacktest)

if(-not (Test-Path -LiteralPath $TerminaleBacktest)){ Muori ("la cartella '" + $TerminaleBacktest + "' non esiste su questa macchina.") }

$Prove = Join-Path $Work "prove"
New-Item -ItemType Directory -Force -Path $Work  | Out-Null
New-Item -ItemType Directory -Force -Path $Prove | Out-Null

# --- 1. scarico driver e file prova -----------------------------------
$drv = Join-Path $Work "walkforward_generico.ps1"
Remove-Item $drv -ErrorAction SilentlyContinue
Invoke-RestMethod ($RawBase + "/backtest_pipeline/walkforward_generico.ps1") -OutFile $drv
if(-not (Test-Path -LiteralPath $drv)){ Muori "driver non scaricato." }
if(-not (Select-String -Path $drv -SimpleMatch -Pattern $MARC_DRV -Quiet)){
  Muori ("il driver scaricato NON ha il marcatore " + $MARC_DRV + ": e' una copia vecchia, senza -TerminaleBacktest. Non si prosegue.")
}
Write-Host "    driver: scaricato e marcatore v4 verificato."

foreach($s in $SEDIE){
  $dst = Join-Path $Prove $s.Prova
  Remove-Item $dst -ErrorAction SilentlyContinue
  Invoke-RestMethod ($RawBase + "/backtest_pipeline/prove/" + $s.Prova) -OutFile $dst
  if(-not (Test-Path -LiteralPath $dst)){ Muori ("file prova non scaricato: " + $s.Prova) }
}
Write-Host ("    file prova: " + $SEDIE.Count + " scaricati.")

# --- 2. le due corse ---------------------------------------------------
function Corri($sedia){
  $et = "ANCORA"
  $pr = Join-Path $Prove $sedia.Prova
  $arg = @("-NoProfile","-ExecutionPolicy","Bypass","-File",$drv,
           "-Expert",$sedia.EA,"-Prova",$pr,"-Ritardo","0",
           "-Etichetta",$et,"-Modello","4","-Rifai",
           "-TerminaleBacktest",$TerminaleBacktest)
  if($SoloControllo){ $arg += "-SoloControllo" }
  Write-Host ""
  Write-Host ("--- " + $sedia.Chi + " (" + $sedia.EA + " " + $sedia.Sim + ") ---") -ForegroundColor Cyan
  $t0 = Get-Date
  $p  = Start-Process -FilePath "powershell.exe" -ArgumentList $arg -NoNewWindow -PassThru -Wait
  $csv = Join-Path $Work ("risultati_prove\" + $sedia.EA + "\" + $sedia.EA + "_" + $sedia.Sim + "_OOS_" + $et + ".csv")
  if($p.ExitCode -ne 0){
    Write-Host ("    NOTA: driver uscito con codice " + $p.ExitCode + " -- classe 154: e' l'ultimo .exe lanciato dentro, NON un verdetto. Il verdetto sta sul CSV.") -ForegroundColor Yellow
  }
  $fresco = (Test-Path -LiteralPath $csv) -and ((Get-Item -LiteralPath $csv).LastWriteTime -ge $t0)
  return @{ Csv=$csv; Fresco=$fresco }
}

function Numero($s){
  if($null -eq $s){ return $null }
  $t = ("" + $s).Trim().Replace(",",".")
  $v = 0.0
  if([double]::TryParse($t,[Globalization.NumberStyles]::Float,[Globalization.CultureInfo]::InvariantCulture,[ref]$v)){ return $v }
  return $null
}

$esiti = @()
foreach($s in $SEDIE){
  $r = Corri $s
  $ok = $true; $note = @()

  if(-not $r.Fresco){
    $ok = $false; $note += "CSV OOS assente o non fresco: la corsa non ha prodotto risultati"
  } else {
    $righe = @(Import-Csv -LiteralPath $r.Csv)
    if($righe.Count -ne 1){
      $ok = $false; $note += ("il CSV OOS ha " + $righe.Count + " righe: la cella congelata ne vuole 1")
    } else {
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
        Write-Host ("    letto: Profit " + $pProfit + " . PF " + $pPF + " . DD " + $pDD + " . Trades " + $pTr)
        Write-Host ("    atteso: Profit " + $s.Profit + " . PF " + $s.PF + " . DD " + $s.DD + " . Trades " + $s.Trades)
      }
    }
  }

  if($ok){ Write-Host ("    " + $s.Chi + " RIPRODUCE: IDENTICO ALLA CIFRA") -ForegroundColor Green }
  else   { Write-Host ("    NON RIPRODUCE: " + ($note -join " . ")) -ForegroundColor Red }
  $esiti += @{ Chi=$s.Chi; Ok=$ok; Note=($note -join " . "); Csv=$r.Csv }
}

# --- 3. il verdetto ----------------------------------------------------
Write-Host ""
Write-Host "=====================================================================" 
$buone = @($esiti | Where-Object { $_.Ok }).Count
foreach($e in $esiti){
  if($e.Ok){ Write-Host ("  " + $e.Chi.PadRight(6) + " RIPRODUCE") -ForegroundColor Green }
  else     { Write-Host ("  " + $e.Chi.PadRight(6) + " NO -- " + $e.Note) -ForegroundColor Red }
}
if($buone -eq $SEDIE.Count){
  Write-Host ""
  Write-Host "  ANCORA SUPERATA: la macchina nuova riproduce i numeri agli atti." -ForegroundColor Green
  Write-Host "  Da qui in avanti i round possono girare su questo terminale." -ForegroundColor Green
} else {
  Write-Host ""
  Write-Host "  ANCORA NON SUPERATA. NON si aggiusta l'attesa: si cerca la differenza." -ForegroundColor Red
  Write-Host "  Guardare, in ordine: tetto barre nel grafico (ILLIMITATO), storico" -ForegroundColor Red
  Write-Host "  completo, tipo di conto (HEDGING), specifiche del simbolo." -ForegroundColor Red
}
Write-Host "====================================================================="

# --- 4. raccolta -------------------------------------------------------
$dsk = [Environment]::GetFolderPath("Desktop")
$d   = Join-Path $dsk "ANCORA_R119"
Remove-Item $d -Recurse -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path $d | Out-Null
foreach($e in $esiti){
  if(Test-Path -LiteralPath $e.Csv){ Copy-Item $e.Csv $d -Force }
  $is = $e.Csv -replace "_OOS_","_IS_"
  if(Test-Path -LiteralPath $is){ Copy-Item $is $d -Force }
}
foreach($s in $SEDIE){ Copy-Item (Join-Path $Prove $s.Prova) $d -Force -ErrorAction SilentlyContinue }
Compress-Archive -Path (Join-Path $d "*") -DestinationPath (Join-Path $dsk "ANCORA_R119.zip") -Force
Write-Host ""
Write-Host ("RACCOLTA: " + $d)
Write-Host ("ZIP PRONTO DA MANDARE: " + (Join-Path $dsk "ANCORA_R119.zip"))
Get-ChildItem $d | Select-Object Name,Length,LastWriteTime | Format-Table -AutoSize
exit 0
