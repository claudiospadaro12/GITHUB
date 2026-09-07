# =====================================================================
#  lancia_r118.ps1  --  ROUND 118: IL PAVIMENTO DELLO STOP SOTTO SLIPPAGE
# ---------------------------------------------------------------------
#  COSA FA:
#    1. riscarica walkforward_generico.ps1, i TRE file prova e il file
#       dei CRITERI, tutti PINNATI allo stesso riferimento (-Rif), e
#       verifica un MARCATORE dentro ognuno prima di usarli (senza il
#       marcatore la riga muore qui, invece di girare una copia vecchia);
#    2. lancia le tre corse NELL'ORDINE GIUSTO:
#         c = DAX RETEST (20 passate)  <- la piu' corta, ed e' il CANCELLO
#         a = ORB U30USD (50 passate)
#         b = DAX STOP   (100 passate) <- la piu' cara, per ultima
#    3. raccoglie i CSV sul Desktop in \r118 e ne fa lo zip, con
#       l'elenco dei file attesi controllato uno per uno.
#
#  DOVE: sul PC di BACKTEST, con MT5 e MetaEditor CHIUSI. MAI SUL VPS.
#
#  QUANTO DURA: 170 passate a tick reali in tutto (85 celle x 2
#  finestre). NON e' misurato quanto ci mette: R88 ha fatto 27 file in
#  2h16 sullo stesso simbolo e sulla stessa finestra. Lanciare SEMPRE
#  prima con -SoloControllo, che non apre MT5 e stampa quante celle
#  sono, cioe' quante ore di macchina.
#
#  QUESTO SCRIPT NON MODIFICA NESSUN EA E NESSUN PRESET.
#  Usa magic VERGINI (778220 / 778230 / 778240): NON tocca il 770611
#  ne' il 770101, che sono gli stessi due EA vivi sul conto REALE
#  10105439. Nessun parametro di forward viene sfiorato.
#
#  I CRITERI SONO CONGELATI in prove\R118_PAVIMENTO_STOP_CRITERI.md e
#  si leggono PRIMA delle tabelle. Da questo round NON esce nessun
#  cambio ai parametri vivi: esce una raccomandazione per Claudio.
#
#  LE TRE ANCORE (si controllano PRIMA di leggere qualunque altra riga):
#    corsa c, pavimento 0  -> R83 V: IS 282,12 / PF 1,07810 / DD 7,0257 / n 197
#                                    OOS 999,42 / PF 1,18776 / DD 10,5984 / n 311
#    corsa a, slippage 0, buffer 0 -> R55/R88: OOS 41057,00 / PF 1,67419
#                                    / DD 9,7623 / n 119
#    corsa b, pav 0 slip 0 -> R83 D0 (ATTESO, non garantito: D0 e'
#                                    girata sul fork)
#  Se un'ancora non torna, il round non si legge: si cerca cosa e'
#  cambiato. Il driver riscarica l'EA dalla PUNTA del branch 'lavoro'.
# =====================================================================
param(
  [string]$Rif      = "lavoro",                        # commit SHA (o branch)
  [string]$Cartella = (Join-Path $env:USERPROFILE "r118"),
  [switch]$SoloControllo,                              # stampa l'ini e NON lancia MT5
  [switch]$SoloA,                                      # solo l'ORB
  [switch]$SoloB,                                      # solo il DAX a STOP
  [switch]$SoloC                                       # solo il DAX RETEST (il cancello)
)
$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$Raw = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Rif"

function Titolo($t) { Write-Host ""; Write-Host $t -ForegroundColor Cyan }
function Muori($t)  { Write-Host ""; Write-Host "!!! $t" -ForegroundColor Red; exit 1 }

function Trova-Desktop {
  $c = @()
  try { $c += [Environment]::GetFolderPath("Desktop") } catch {}
  $c += (Join-Path $env:USERPROFILE "Desktop")
  $c += (Join-Path $env:USERPROFILE "OneDrive\Desktop")
  foreach ($d in $c) { if ($d -and (Test-Path $d)) { return $d } }
  return $env:USERPROFILE
}

Write-Host "=== ROUND 118 - IL PAVIMENTO DELLO STOP SOTTO SLIPPAGE ===" -ForegroundColor Cyan
Write-Host ("MACCHINA: " + $env:COMPUTERNAME + "   utente: " + $env:USERNAME) -ForegroundColor Cyan
Write-Host ("riferimento: " + $Rif) -ForegroundColor DarkGray

if (Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) {
  Muori "MetaTrader e' APERTO. Chiudilo prima di lanciare, altrimenti escono 0 CSV."
}
if (Get-Process -Name "metaeditor64" -ErrorAction SilentlyContinue) {
  Muori "MetaEditor e' APERTO. Chiudilo: con MetaEditor aperto la compilazione torna subito senza compilare."
}

Write-Host ""
Write-Host "    170 passate a tick reali (85 celle x 2 finestre)." -ForegroundColor Yellow
Write-Host "    NESSUN EA e NESSUN PRESET viene modificato." -ForegroundColor Yellow
Write-Host "    Magic vergini 778220 / 778230 / 778240: i vivi 770611 e" -ForegroundColor Yellow
Write-Host "    770101 non vengono sfiorati." -ForegroundColor Yellow
Write-Host "    I gradini di SLIPPAGE sono SCENARI ASSUNTI, non misure:" -ForegroundColor Yellow
Write-Host "    il logger sul conto reale ha ZERO deal registrati." -ForegroundColor Yellow

# =====================================================================
#  1. ATTREZZI (riscaricati sempre, con marcatore verificato)
# =====================================================================
Titolo "1) attrezzi (riscaricati sempre, mai la copia vecchia)"
$Prove = Join-Path $Cartella "prove"
New-Item -ItemType Directory -Force -Path $Prove | Out-Null

# nome locale = @{ url; marcatore che deve esistere DENTRO il file }
$file = [ordered]@{
  "walkforward_generico.ps1" = @{
      url = "$Raw/backtest_pipeline/walkforward_generico.ps1"
      mar = "PermettiCellaSingola" }
  "prove\R118_PAVIMENTO_STOP_CRITERI.md" = @{
      url = "$Raw/backtest_pipeline/prove/R118_PAVIMENTO_STOP_CRITERI.md"
      mar = "R118" }
  "prove\R118a_pavimento_ORB_U30USD.txt" = @{
      url = "$Raw/backtest_pipeline/prove/R118a_pavimento_ORB_U30USD.txt"
      mar = "InpSLBufferPts=0||0||500||2000||Y" }
  "prove\R118b_pavimento_DAX_STOP_D30EUR.txt" = @{
      url = "$Raw/backtest_pipeline/prove/R118b_pavimento_DAX_STOP_D30EUR.txt"
      mar = "InpSlippagePts=0||0||100||400||Y" }
  "prove\R118c_pavimento_DAX_RETEST_D30EUR.txt" = @{
      url = "$Raw/backtest_pipeline/prove/R118c_pavimento_DAX_RETEST_D30EUR.txt"
      mar = "InpSkipIfTight=0||0||1||1||Y" }
}

foreach ($k in $file.Keys) {
  $dest = Join-Path $Cartella $k
  Remove-Item $dest -Force -ErrorAction SilentlyContinue     # niente copia vecchia da eseguire
  try {
    Invoke-WebRequest -Uri $file[$k].url -OutFile $dest -UseBasicParsing -ErrorAction Stop
  } catch {
    Muori ("non sono riuscito a scaricare " + $k + " da " + $Rif + "`n    " + $_.Exception.Message)
  }
  if (-not (Select-String -Path $dest -SimpleMatch -Pattern $file[$k].mar -Quiet)) {
    Muori ("il file scaricato NON contiene il marcatore atteso (" + $file[$k].mar + "):`n" +
           "    " + $k + "`n" +
           "    E' una copia vecchia (cache di raw.githubusercontent, ~5 minuti) oppure`n" +
           "    il file e' cambiato. NON si lancia: i numeri non sarebbero leggibili.")
  }
  Write-Host ("    ok  " + $k) -ForegroundColor Green
}

# =====================================================================
#  2. LE TRE CORSE, NELL'ORDINE GIUSTO
#     c per prima: e' la piu' corta ed e' il CANCELLO (ancora R83 V).
# =====================================================================
$wf = Join-Path $Cartella "walkforward_generico.ps1"
$tutte = -not ($SoloA -or $SoloB -or $SoloC)
$giri = @()
if ($tutte -or $SoloC) { $giri += @{ EA="ABTG_DAX_Apertura_EU";  Prova="prove\R118c_pavimento_DAX_RETEST_D30EUR.txt"; Sim="D30EUR"; Dep=10000;  Tag="r118c"; Celle=10; Nota="DAX RETEST - la cella VIVA, slippage NON simulabile su un LIMIT" } }
if ($tutte -or $SoloA) { $giri += @{ EA="ABTG_ORB_Ottimizzato"; Prova="prove\R118a_pavimento_ORB_U30USD.txt";        Sim="U30USD"; Dep=100000; Tag="r118a"; Celle=25; Nota="ORB - il R55-bis chiesto dai criteri di R88" } }
if ($tutte -or $SoloB) { $giri += @{ EA="ABTG_DAX_Apertura_EU";  Prova="prove\R118b_pavimento_DAX_STOP_D30EUR.txt";   Sim="D30EUR"; Dep=10000;  Tag="r118b"; Celle=50; Nota="DAX a STOP - l'unico posto dove i TRE rami e lo slippage sono vivi insieme" } }

foreach ($g in $giri) {
  Titolo ("2) " + $g.Tag + " - " + $g.EA + " su " + $g.Sim + "   (" + $g.Nota + ")")
  Write-Host ("    celle attese per finestra: " + $g.Celle + "   (se il driver ne stampa altre, FERMATI)") -ForegroundColor White
  $arg = @("-ExecutionPolicy","Bypass","-File",$wf,$g.EA,
           "-Prova",$g.Prova,"-Simbolo",$g.Sim,"-Deposito","$($g.Dep)",
           "-Modello","4","-Etichetta",$g.Tag)
  if ($SoloControllo) { $arg += "-SoloControllo" }
  & powershell $arg
  if ($LASTEXITCODE -ne 0) {
    Write-Host ("    " + $g.Tag + " e' uscito con codice " + $LASTEXITCODE + ": vado avanti, la raccolta dira' cosa manca.") -ForegroundColor Yellow
  }
}

if ($SoloControllo) {
  Write-Host ""
  Write-Host "SoloControllo: nessuna passata lanciata, nessun CSV da raccogliere." -ForegroundColor Yellow
  Write-Host "Controlla le celle stampate sopra: 10 (c), 25 (a), 50 (b)." -ForegroundColor Yellow
  exit 0
}

# =====================================================================
#  3. RACCOLTA SUL DESKTOP + ZIP  (regola delle righe di lancio)
# =====================================================================
Titolo "3) raccolta sul Desktop"
$desk = Trova-Desktop
$dest = Join-Path $desk "r118"
if (Test-Path $dest) { Remove-Item $dest -Recurse -Force -ErrorAction SilentlyContinue }
New-Item -ItemType Directory -Force -Path $dest | Out-Null

$attesi = @()
foreach ($g in $giri) {
  $attesi += ($g.EA + "_" + $g.Sim + "_IS_"  + $g.Tag + ".csv")
  $attesi += ($g.EA + "_" + $g.Sim + "_OOS_" + $g.Tag + ".csv")
}

$radice = Join-Path $Cartella "risultati_prove"
if (Test-Path $radice) {
  foreach ($f in (Get-ChildItem $radice -Recurse -Filter "*r118*.csv" -ErrorAction SilentlyContinue)) {
    try { Copy-Item $f.FullName (Join-Path $dest $f.Name) -Force } catch { Write-Host ("    non copiato: " + $f.Name) -ForegroundColor Yellow }
  }
}
foreach ($n in @("R118_PAVIMENTO_STOP_CRITERI.md","R118a_pavimento_ORB_U30USD.txt",
                 "R118b_pavimento_DAX_STOP_D30EUR.txt","R118c_pavimento_DAX_RETEST_D30EUR.txt")) {
  Copy-Item (Join-Path $Prove $n) $dest -Force -ErrorAction SilentlyContinue
}

Write-Host ""
Write-Host "    FILE ATTESI (controllali uno per uno):" -ForegroundColor White
$mancanti = 0
foreach ($a in $attesi) {
  if (Test-Path (Join-Path $dest $a)) { Write-Host ("      OK      " + $a) -ForegroundColor Green }
  else { Write-Host ("      MANCA  " + $a) -ForegroundColor Red; $mancanti++ }
}

$zip = Join-Path $desk "r118.zip"
if (Test-Path $zip) { Remove-Item $zip -Force -ErrorAction SilentlyContinue }
try {
  Compress-Archive -Path (Join-Path $dest "*") -DestinationPath $zip -Force
  Write-Host ""
  Write-Host ("    ZIP PRONTO DA MANDARE:  " + $zip) -ForegroundColor Cyan
} catch {
  Write-Host ""
  Write-Host ("!!! lo zip NON e' stato creato: " + $_.Exception.Message) -ForegroundColor Red
  Write-Host ("    i file comunque sono qui: " + $dest) -ForegroundColor Yellow
}

Write-Host ""
if ($mancanti -gt 0) {
  Write-Host ("=== $mancanti CSV su " + $attesi.Count + " MANCANO. Guarda sopra qual e' stato l'errore. ===") -ForegroundColor Red
} else {
  Write-Host ("=== TUTTI E " + $attesi.Count + " I CSV CI SONO. ===") -ForegroundColor Green
  Write-Host "    CONTROLLO D'IGIENE NUMERO UNO, prima di qualunque lettura:" -ForegroundColor Gray
  Write-Host "      corsa c, riga InpMinStopPts=0  -> deve dare OOS 999,42 / PF 1,18776" -ForegroundColor Gray
  Write-Host "                                        / DD 10,5984 / n 311   (R83 V)" -ForegroundColor Gray
  Write-Host "      corsa a, buffer 0 slippage 0   -> deve dare OOS 41057,00 / PF 1,67419" -ForegroundColor Gray
  Write-Host "                                        / DD 9,7623 / n 119    (R55 e R88)" -ForegroundColor Gray
  Write-Host "    Se non le riproduce, i numeri NON si leggono: si cerca cosa e' cambiato." -ForegroundColor Gray
  Write-Host "    E i criteri (R118_PAVIMENTO_STOP_CRITERI.md) si leggono PRIMA delle tabelle." -ForegroundColor Gray
}
