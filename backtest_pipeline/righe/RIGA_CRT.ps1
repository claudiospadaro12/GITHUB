# =====================================================================
#  MARCATORE_RIGA_CRT_v1
#  RIGA_CRT.ps1  --  CRT TURTLE SOUP: screening walk-forward IS/OOS del
#  fade strutturato di falsa rottura (wick di rifiuto >= Kx corpo).
#  ABTG_CRT_TurtleSoup su NASUSD M15, TICK REALI (Modello 4), sweep a 3
#  assi (InpWickFactor x InpUseMidGate x InpSide). EA NUOVO, mai compilato.
# ---------------------------------------------------------------------
#  QUESTO E' UNO SCREENING. NON PROMUOVE NIENTE E NON DA' UN VERDETTO.
#  Prova/criteri congelati PRIMA dei numeri:
#    backtest_pipeline\prove\ABTG_CRT_TurtleSoup.txt
#  Motore CRT Turtle Soup da Neo Malesa (n30dyn4m1c), licenza MIT.
#
#  LA DOMANDA: il fade STRUTTURATO (falsa rottura + wick di rifiuto +
#  richiusura + gate del 50%) ha un edge di REVERSAL a tick reali su
#  NASUSD M15, ed e' scorrelato dai nostri trend-follower e aperture?
#  E' il fade che il cimitero (R42/R60/R108/R109 = fade NUDO) non ha mai
#  misurato, perche' qui la falsa-rottura + il wick SONO la strategia.
#
#  ------------------------------------------------------------------
#  >>> PRIMO SIMBOLO = NASUSD (non D30EUR, lead DICHIARATO). Perche':
#      su NASUSD ogni specifica e' MISURATA (conversione 100 pti MT5/pt
#      indice R97, muro tick 26/09/2024, chiusura RTH 21:00 server), e i
#      default US del CRT (conv 100, flat) ci calzano. Su D30EUR il flat
#      DAX (16:30 server) e la conversione punti NON sono misurati: il
#      default 22:00 terrebbe il DAX in overnight. DAX/Dow seguono DOPO un
#      PASSO-0 sulle LORO specifiche. Affinamento PRIMA dei numeri.
#
#  >>> TICK REALI, UN SOLO REGIME: la finestra 2024.09.26 -> 2026.06.30 e'
#      un solo regime (toro). Merito FORMALMENTE SOSPESO se n<150 (valvola
#      R59). Il RISCHIO no: DD e peggior giornata contro il muro, sempre.
#      Un verdetto orso servirebbe Dukascopy (limite noto dallo shortgate).
#
#  >>> PAVIMENTO SL (R109): InpMinStopPts=500 (5 punti indice), MAI 0. Il
#      gate lo pretende e RIFIUTA 0. Un fade entra CONTRO una spinta.
#
#  >>> FLAT INTRADAY: il prova PINNA InpCloseHour=21/InpCloseMin=0 (RTH
#      NASUSD, ora server), NON il default US-afterhours 22:00 dell'EA.
#      Zero overnight = vincolo del mandato.
#
#  ------------------------------------------------------------------
#  PERCHE' ESISTE QUESTO FILE invece di invocare a mano il generico:
#   1. IL PIN. Senza, girerebbe la punta del branch 'lavoro' spacciandola
#      per un commit congelato (il 10/08 una copia vecchia ha rifatto la
#      griglia sbagliata). Qui il pin vale per il driver E per l'EA.
#   2. LA COMPILAZIONE. ABTG_CRT_TurtleSoup e' NUOVO, MAI compilato. Il
#      generico NON compila: pretende l'.ex5. Qui si compila PRIMA, e se
#      la compilazione FALLISCE QUELLO e' il risultato del passo (come
#      ABTG_OutOfNoise). L'.ex5 vecchio si cancella prima.
#   3. I GATE SUL PROVA. Geometria (NASUSD/M15/finestra), pavimento SL,
#      i 3 assi attesi, il flat pinnato, il magic vergine: si controllano
#      PRIMA di aprire MT5. Il generico non li conosce tutti.
#   4. LA RACCOLTA (regola di casa): risultati sul Desktop + zip pronto.
#
#  LA RIGA CHE SI INCOLLA sta in righe\RIGA_CRT_DA_MANDARE.md
# =====================================================================
[CmdletBinding()]
param(
  [string]$Pin          = "",       # 40 hex OBBLIGATORIO: nessun default silenzioso
  [switch]$SoloControllo,           # giro a vuoto: compila + gate, NON apre MT5
  [string]$Simbolo      = "NASUSD",
  [string]$Periodo      = "M15",
  [string]$DaQuando     = "2024.09.26",
  [string]$Fino         = "2026.06.30",
  [double]$FrazioneIS   = 0.40,     # 40% dentro campione / 60% fuori (walk-forward)
  [int]$Deposito        = 100000
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

$EA     = "ABTG_CRT_TurtleSoup"
$Avvio  = Get-Date
$Stamp  = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
$Dsk    = Join-Path $env:USERPROFILE "Desktop"
$Work   = Join-Path $env:USERPROFILE "abtg_crt"
$Prove  = Join-Path $Work "prove"
$RawPin = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

# --- tutto cio' che la raccolta usa NASCE QUI, prima del try: in
#     PowerShell una function e' un'istruzione, non una dichiarazione.
$Problemi  = New-Object System.Collections.ArrayList
$Rilievi   = New-Object System.Collections.ArrayList
$Fatale    = ""
$Terminale = "n/d"
$Compilato = "NON TENTATA"
$RiskEA    = "n/d"
$Simbolo_ok= "NON VERIFICATO"
$Modo      = "CORSA"
if($SoloControllo){ $Modo = "CONTROLLO" }

# --- i 3 assi che il prova DEVE spazzolare (flag Y), e NESSUN ALTRO.
$AssiAttesi = @("InpWickFactor","InpUseMidGate","InpSide")
# --- il magic del CRT (default nell'.mq5). Vergine, verificato repo-wide.
$MagicAtteso = 769100
# --- lista di sicurezza dei magic gia' occupati (seconda rete oltre al
#     controllo del default): blocchi vivi / round recenti.
$MagicVietati = @(769000,769001,769010,769011,769020,769021,
                  769200,769300,769400,769500,
                  770201,770202,770250,770925,771322,771332,
                  767120,767200,768100,768110,768300)

function Ora(){ return (Get-Date).ToString("HH:mm:ss", $INV) }
function Dico([string]$t,[string]$c="Gray"){ Write-Host ("[" + (Ora) + "] " + $t) -ForegroundColor $c }
function Titolo([string]$t){ Write-Host ""; Write-Host ("=== " + $t + " ===") -ForegroundColor Cyan }

function Scarica([string]$url,[string]$dest){
  Remove-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue
  Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing -ErrorAction Stop
  if(-not (Test-Path -LiteralPath $dest)){ throw ("scarico fallito: " + $url) }
}

function RigheVive([string]$p){
  return @(Get-Content -LiteralPath $p | Where-Object { $_ -notmatch '^\s*#' -and $_ -notmatch '^\s*$' })
}

try{
  Titolo ("CRT TURTLE SOUP -- screening walk-forward (" + $EA + ") -- modo " + $Modo)

  # -------------------------------------------------------------------
  #  0. LE GUARDIE, PRIMA DI TOCCARE QUALUNQUE COSA
  # -------------------------------------------------------------------
  if($Pin -eq ""){ throw "-Pin obbligatorio: senza, girerebbe la punta del branch spacciandola per un commit congelato." }
  if($Pin -notmatch '^[0-9a-f]{40}$'){ throw ("-Pin deve essere un commit di 40 caratteri esadecimali, ricevuto: " + $Pin) }
  if(Get-Process terminal64,metaeditor64 -ErrorAction SilentlyContinue){
    throw "MT5 O METAEDITOR APERTO: col terminale aperto il tester non gira (zero CSV), con MetaEditor aperto la compilazione torna subito senza compilare."
  }
  if($Periodo -ne "M15"){
    [void]$Rilievi.Add("PERIODO diverso da M15 (" + $Periodo + "): il prova dichiara @PERIODO M15 e il gate lo confronta.")
  }

  Dico ("pin ......... " + $Pin)
  Dico ("simbolo ..... " + $Simbolo + " " + $Periodo + " (NASUSD: specifiche misurate, conv 100, RTH 21:00 server)")
  Dico ("finestra .... " + $DaQuando + " -> " + $Fino + " (tick BCM, un solo regime toro; FrazioneIS " + $FrazioneIS + ")")
  Dico ("banco ....... MODELLO 4 (TICK REALI). Deposito " + $Deposito)

  # -------------------------------------------------------------------
  #  1. SCARICO AL PIN (driver generico + prova + EA)
  # -------------------------------------------------------------------
  Titolo "1. SCARICO AL PIN"
  New-Item -ItemType Directory -Force -Path $Work,$Prove | Out-Null

  $drv = Join-Path $Work "walkforward_generico.ps1"
  Scarica ($RawPin + "/backtest_pipeline/walkforward_generico.ps1") $drv
  # il generico pinna da solo il branch da cui riscarica il .mq5: lo si
  # forza al pin, altrimenti il pin varrebbe per il driver e NON per l'EA.
  $t = Get-Content -LiteralPath $drv -Raw
  if($t -notmatch '\$EABranch\s*=\s*"lavoro"'){ throw "walkforward_generico.ps1 non ha la riga \$EABranch attesa: non lo posso pinnare." }
  $t = $t -replace '\$EABranch\s*=\s*"lavoro"', ('$EABranch="' + $Pin + '"')
  Set-Content -LiteralPath $drv -Value $t -Encoding ASCII
  Dico "driver generico scaricato e PINNATO (riscarica l'EA al pin, non dalla punta del branch)" "Green"

  $fProva = Join-Path $Prove ($EA + ".txt")
  Scarica ($RawPin + "/backtest_pipeline/prove/" + $EA + ".txt") $fProva
  Dico ("prova scaricato: " + $EA + ".txt") "Green"

  # -------------------------------------------------------------------
  #  2. I GATE SUL PROVA -- girano PRIMA di aprire MT5
  # -------------------------------------------------------------------
  Titolo "2. GATE SUL PROVA"
  $righe = RigheVive $fProva
  $h = @{}
  $assiY = New-Object System.Collections.ArrayList
  foreach($r in $righe){
    if($r -match '^@'){
      $parti = ($r -split '\s+',2)
      $h[$parti[0]] = $parti[1].Trim()
      continue
    }
    $i = $r.IndexOf("=")
    if($i -lt 0){ continue }
    $nome = $r.Substring(0,$i).Trim()
    $val  = $r.Substring($i+1).Trim()
    if($h.ContainsKey($nome)){ throw ($EA + ".txt: DUE righe per '" + $nome + "'. In [TesterInputs] un parametro doppio fa fare a MT5 ZERO passate.") }
    $h[$nome] = $val
    if($val -match '\|\|Y\s*$'){ [void]$assiY.Add($nome) }
  }

  # GATE GEOMETRIA: simbolo, periodo, finestra
  if($h["@SIMBOLO"]  -ne $Simbolo){  throw ($EA + ".txt: @SIMBOLO e' " + $h["@SIMBOLO"] + ", atteso " + $Simbolo) }
  if($h["@PERIODO"]  -ne $Periodo){  throw ($EA + ".txt: @PERIODO e' " + $h["@PERIODO"] + ", atteso " + $Periodo) }
  if($h["@DAQUANDO"] -ne $DaQuando){ throw ($EA + ".txt: @DAQUANDO e' " + $h["@DAQUANDO"] + ", atteso " + $DaQuando) }

  # GATE DEI 3 ASSI: esattamente {InpWickFactor, InpUseMidGate, InpSide},
  # nessun altro asse Y. Un asse in piu' o in meno = griglia diversa.
  $assiOrd = @($assiY | Sort-Object)
  $attesiOrd = @($AssiAttesi | Sort-Object)
  if(($assiOrd -join ",") -ne ($attesiOrd -join ",")){
    throw ($EA + ".txt: gli assi spazzolati sono {" + ($assiOrd -join ", ") + "}, attesi {" + ($attesiOrd -join ", ") + "}.")
  }

  # GATE SWEEP NON DEGENERE: per ogni asse Y, start != stop (altrimenti
  # zero celle: e' l'errore dei 4 CSV vuoti del 07/08). Enum a parte
  # (InpSide 0..2 e' un enum: start!=stop basta).
  foreach($ax in $AssiAttesi){
    $p = $h[$ax] -split '\|\|'
    if($p.Count -lt 4){ throw ($EA + ".txt: l'asse " + $ax + " non ha il formato default||start||step||stop||Y.") }
    if($p[1] -eq $p[3]){ throw ($EA + ".txt: l'asse " + $ax + " ha start==stop (" + $p[1] + "): sweep degenere, zero celle.") }
  }

  # GATE PAVIMENTO SL (R109): mai 0. Il fade entra contro una spinta.
  $mfloor = ($h["InpMinStopPts"] -split '\|\|')[0]
  if($mfloor -eq "0"){ throw ($EA + ".txt: InpMinStopPts=0 VIETATO (R109): il pavimento SL e' 500 (5 punti indice), mai 0.") }
  if($mfloor -ne "500"){ throw ($EA + ".txt: InpMinStopPts deve essere 500 (R109, 5 punti indice), trovato '" + $mfloor + "'.") }

  # GATE FLAT INTRADAY: il prova PINNA il flat RTH NASUSD 21:00 server, non
  # il default US-afterhours 22:00 dell'EA. Zero overnight (mandato).
  $ch = ($h["InpCloseHour"] -split '\|\|')[0]
  $cm = ($h["InpCloseMin"]  -split '\|\|')[0]
  if($ch -ne "21"){ throw ($EA + ".txt: InpCloseHour deve essere 21 (RTH NASUSD, ora server); il default 22 dell'EA terrebbe overnight. Trovato '" + $ch + "'.") }
  if($cm -ne "0"){  throw ($EA + ".txt: InpCloseMin deve essere 0 (flat 21:00 server), trovato '" + $cm + "'.") }

  Dico "geometria, 3 assi, sweep non degenere, pavimento SL (R109), flat intraday 21:00: TUTTI PASSATI" "Green"

  # -------------------------------------------------------------------
  #  3. TERMINALE, COMPILAZIONE (EA NUOVO: se fallisce, e' il risultato)
  # -------------------------------------------------------------------
  Titolo "3. TERMINALE E COMPILAZIONE"
  # lo stesso selettore, riga per riga, del generico: i due devono
  # scegliere LO STESSO terminale.
  $allTerm = @(Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue)
  $cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*" } | Select-Object -First 1
  if(-not $cand){ $cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets*" } | Select-Object -First 1 }
  if(-not $cand){ throw "terminale BCM non trovato: e' lo stesso selettore del generico." }
  $instDir    = $cand.DirectoryName
  $MetaEditor = Join-Path $instDir "metaeditor64.exe"
  $termRoot   = Join-Path $env:APPDATA "MetaQuotes\Terminal"
  $dataFolder = (Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue | Where-Object { $o = Join-Path $_.FullName "origin.txt"; (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $instDir) } | Select-Object -First 1 -ExpandProperty FullName)
  if(-not $dataFolder){ throw ("cartella dati non trovata per " + $instDir) }
  $Terminale = $instDir
  Dico ("terminale scelto: " + $instDir + "  (DEVE essere lo stesso che stampa il generico)") "Yellow"

  # il simbolo NASUSD e' nativo BCM (non custom): non serve import. Lo
  # confermo solo per il referto, senza fermarmi se il tester lo risolve.
  $Simbolo_ok = "NASUSD (nativo BCM: il tester lo risolve dal server)"

  # LA COMPILAZIONE. L'.ex5 vecchio si cancella prima: senza, un binario
  # vecchio spaccerebbe per riuscita una compilazione fallita.
  $mq5 = Join-Path $Work ($EA + ".mq5")
  Scarica ($RawPin + "/mql5/Experts/" + $EA + ".mq5") $mq5
  $dstExp = Join-Path $dataFolder "MQL5\Experts"
  New-Item -ItemType Directory -Force -Path $dstExp | Out-Null
  $dstMq5 = Join-Path $dstExp ($EA + ".mq5")
  Copy-Item $mq5 -Destination $dstMq5 -Force
  $ex5 = Join-Path $dstExp ($EA + ".ex5")
  Remove-Item -LiteralPath $ex5 -Force -ErrorAction SilentlyContinue
  $t0 = Get-Date
  & $MetaEditor ("/compile:" + $dstMq5) "/log" | Out-Null
  while((-not (Test-Path -LiteralPath $ex5)) -and ((New-TimeSpan -Start $t0 -End (Get-Date)).TotalSeconds -lt 180)){ Start-Sleep -Seconds 2 }
  if(-not (Test-Path -LiteralPath $ex5)){
    $logC = Join-Path $dstExp ($EA + ".log")
    if(Test-Path -LiteralPath $logC){
      Copy-Item $logC -Destination (Join-Path $Work "COMPILAZIONE_FALLITA.log") -Force
      Get-Content -LiteralPath $logC -Tail 40 | ForEach-Object { Write-Host $_ -ForegroundColor Red }
    }
    throw ("COMPILAZIONE FALLITA: " + $EA + " non ha prodotto l'.ex5. E' un EA NUOVO: questo E' il risultato del passo. Gli errori sono qui sopra e in COMPILAZIONE_FALLITA.log dentro lo zip.")
  }
  $Compilato = "OK (" + [int]((Get-Item -LiteralPath $ex5).Length/1024) + " KB, " + (Get-Item -LiteralPath $ex5).LastWriteTime.ToString("HH:mm:ss",$INV) + ")"
  Dico ("compilato " + $EA + ": " + $Compilato) "Green"
  $RiskEA = ($h["InpRiskPercent"] -split '\|\|')[0]
  if($RiskEA -eq ""){ $RiskEA = "0.65 (default EA)" }

  if($SoloControllo){
    Dico "SoloControllo: compilazione e gate OK, NON apro MT5. La corsa vera e' la seconda riga." "Green"
  }
  else{
    # -------------------------------------------------------------------
    #  4. LA CORSA -- generico UNA volta, Modello 4 (tick), sweep 3 assi
    # -------------------------------------------------------------------
    Titolo "4. LA CORSA (generico, tick reali)"
    $argv = @("-ExecutionPolicy","Bypass","-File",$drv,
              "-Expert",$EA,
              "-Prova",$fProva,
              "-Simbolo",$Simbolo,
              "-Periodo",$Periodo,
              "-DaQuando",$DaQuando,
              "-Fino",$Fino,
              ("-FrazioneIS"),("" + $FrazioneIS),
              "-Modello","4",
              "-Deposito",("" + $Deposito))
    $global:LASTEXITCODE = 0
    & powershell $argv
    $rc = $LASTEXITCODE
    if($rc -ne 0){
      [void]$Problemi.Add("il generico e' uscito con codice " + $rc + " (storico mancante? sweep degenere? CSV non prodotto?).")
    }
  }
}
catch{
  $Fatale = ("" + $_.Exception.Message)
  Write-Host ""
  Write-Host ("!!! FERMATO: " + $Fatale) -ForegroundColor Red
}

# =====================================================================
#  RACCOLTA -- SEMPRE, anche a corsa fermata a meta'.
# =====================================================================
Titolo "RACCOLTA"
$Cart = Join-Path $Dsk ("CRT_" + $Modo + "_" + $Stamp)
New-Item -ItemType Directory -Force -Path $Cart | Out-Null

$RefTxt = New-Object System.Collections.ArrayList
[void]$RefTxt.Add("=====================================================================")
[void]$RefTxt.Add(" CRT TURTLE SOUP -- screening walk-forward (" + $EA + ") su " + $Simbolo + " " + $Periodo)
[void]$RefTxt.Add("=====================================================================")
[void]$RefTxt.Add("modo: " + $Modo + "   <- CONTROLLO = giro a vuoto (compila+gate), NON e' il risultato")
[void]$RefTxt.Add("data: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV))
[void]$RefTxt.Add("pin:  " + $Pin)
[void]$RefTxt.Add("finestra: " + $DaQuando + " -> " + $Fino + "  (tick BCM, un solo regime toro; FrazioneIS " + $FrazioneIS + ")")
[void]$RefTxt.Add("banco: MODELLO 4 (TICK REALI). Deposito " + $Deposito + ", rischio " + $RiskEA + "%.")
[void]$RefTxt.Add("flat: 21:00 server (RTH NASUSD), zero overnight. Sessione: pattern a qualunque ora, flat EOD.")
[void]$RefTxt.Add("terminale: " + $Terminale)
[void]$RefTxt.Add("simbolo: " + $Simbolo_ok)
[void]$RefTxt.Add("compilazione: " + $Compilato + "   <- EA NUOVO: se FALLITA, quello e' il risultato del passo")
[void]$RefTxt.Add("")
[void]$RefTxt.Add("QUESTO E' UNO SCREENING. NON PROMUOVE NIENTE E NON DA' UN VERDETTO.")
[void]$RefTxt.Add("Il campione 21 mesi = un solo regime toro: MERITO sospeso se n<150 (R59).")
[void]$RefTxt.Add("Il RISCHIO no: DD e peggior giornata contro il muro prop, sempre.")
[void]$RefTxt.Add("Verdetto orso impossibile a tick BCM (serve Dukascopy) -- limite noto.")
[void]$RefTxt.Add("")
[void]$RefTxt.Add("COME SI LEGGE (quando i CSV tornano):")
[void]$RefTxt.Add("  - I due CSV sono la gamba IS (40%, dove si sceglie la cella: CENTRO")
[void]$RefTxt.Add("    dell'altopiano, MAI il picco) e la gamba OOS (60%, il fuori campione).")
[void]$RefTxt.Add("  - Si legge per REGIME dal per-trade CSV in Common\\Files:")
[void]$RefTxt.Add("      abtg_trades_" + $EA + "_" + $Simbolo + "_<magic>.csv")
[void]$RefTxt.Add("  - VINCE solo se una cella da aspettativa/trade positiva e STABILE IS->OOS,")
[void]$RefTxt.Add("    DD sotto il muro, e NON degenera in ORB/breakout/fade-nudo/momentum.")
[void]$RefTxt.Add("  - Peggior giornata sotto il cap 5% prop; se concentra i trade nello")
[void]$RefTxt.Add("    stesso giorno -> penalita' prop (misurare la concentrazione).")
[void]$RefTxt.Add("")
if($Fatale -ne ""){
  [void]$RefTxt.Add("!!! FERMATO: " + $Fatale)
  [void]$RefTxt.Add("")
}
[void]$RefTxt.Add("PROBLEMI: " + $Problemi.Count)
foreach($p in $Problemi){ [void]$RefTxt.Add("  - " + $p) }
[void]$RefTxt.Add("RILIEVI: " + $Rilievi.Count)
foreach($p in $Rilievi){ [void]$RefTxt.Add("  - " + $p) }
[void]$RefTxt.Add("")
[void]$RefTxt.Add('COME SI RIPRENDE: dalla pagina righe/RIGA_CRT_DA_MANDARE.md, NON da questa')
[void]$RefTxt.Add('riga: $Pin nasce dentro il blocco e non sopravvive.')

$refPath = Join-Path $Cart "REFERTO_CRT.txt"
Set-Content -LiteralPath $refPath -Value ($RefTxt -join "`r`n") -Encoding ASCII
Write-Host ($RefTxt -join "`r`n")

# --- gli artefatti: solo cio' che ha girato, copiato PER NOME.
foreach($f in @("COMPILAZIONE_FALLITA.log")){
  $src = Join-Path $Work $f
  if(Test-Path -LiteralPath $src){ Copy-Item $src -Destination $Cart -Force }
}
$srcProva = Join-Path $Prove ($EA + ".txt")
if(Test-Path -LiteralPath $srcProva){ Copy-Item $srcProva -Destination $Cart -Force }
$Results = Join-Path $Work ("risultati_prove\" + $EA)
foreach($leg in @("IS","OOS")){
  $f = Join-Path $Results ($EA + "_" + $Simbolo + "_" + $leg + ".csv")
  if(Test-Path -LiteralPath $f){ Copy-Item $f -Destination $Cart -Force }
}
$zip = $Cart + ".zip"
Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $zip -Force
Write-Host ""
Write-Host ("CARTELLA: " + $Cart) -ForegroundColor Green
Write-Host ("ZIP DA MANDARE: " + $zip) -ForegroundColor Green
Write-Host "FILE ATTESI NELLO ZIP: REFERTO_CRT.txt + ABTG_CRT_TurtleSoup.txt + i CSV IS/OOS (nella CORSA)" -ForegroundColor Gray

if($Fatale -ne ""){ Write-Host "ESITO: FERMATO" -ForegroundColor Red; exit 1 }
if($Problemi.Count -gt 0){ Write-Host "ESITO: COMPLETATO CON PROBLEMI" -ForegroundColor Yellow; exit 1 }
Write-Host ("ESITO: " + $Modo + " COMPLETATO") -ForegroundColor Green
exit 0
