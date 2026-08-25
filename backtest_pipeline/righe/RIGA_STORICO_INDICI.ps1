# =====================================================================
#  MARCATORE_RIGA_STORICO_INDICI_v1
#  RIGA_STORICO_INDICI.ps1  --  PIU' ANNI DI STORICO SUGLI INDICI
#                               (richiesta di Claudio, 25/08/2026)
# ---------------------------------------------------------------------
#  LA RICHIESTA:  "per gli Indici cerchiamo di fare i test con piu'
#  anni di storico".  BCM sugli indici parte dal 26/09/2024 ed e'
#  dichiarato COMPLETO: il broker non ha di piu'. Gli anni si prendono
#  fuori, e questa riga li va a prendere.
#
#  ###################################################################
#  #  QUELLO CHE QUESTA RIGA **NON** FA, e va letto prima di tutto:  #
#  #  NON sblocca i test sugli indici.                               #
#  #  Il CANCELLO ZERO sugli indici _EXT e' ANCORA CHIUSO (diff      #
#  #  media H1 0,061-0,101% contro il <=0,05% richiesto: par. 14-15  #
#  #  di REFERTO_HISTDATA_FATTIBILITA.md). Un NASUSD_EXT dal 2010    #
#  #  resta IN FRIGO esattamente come quello dal 2019.               #
#  #  Questa riga produce DATI. Il permesso di usarli e' un'altra    #
#  #  firma, e dipende da quel cancello.                             #
#  ###################################################################
#
#  I DATI SONO DI UN ALTRO BROKER. Spread, orari di seduta e prezzi
#  NON sono BCM. La riga lo scrive in testa a ogni referto che
#  produce, ogni volta, senza che nessuno debba ricordarselo.
#
#  LE DECISIONI NON STANNO QUI DENTRO
#  Le sei decisioni (fonte, simboli, uso, finestra, soglia, strada del
#  DAX) stanno in risultati_archivio\STORICO_INDICI_CRITERI.md e si
#  firmano LI'. Questa riga le LEGGE al pin: quelle DA_FIRMARE
#  spengono la fase che le consuma, e la fase finisce nel referto come
#  "NON ESEGUITA (decisione D-x non firmata)". Non esiste nessun
#  interruttore per scavalcarle: una decisione che si scavalca dalla
#  console non e' una decisione.
#
#  LE FASI, IN ORDINE
#   F0  pin, cultura invariante, cartelle, MT5 chiuso se serve
#   F1  CRITERI: scaricati al pin, letti a macchina, stampati
#   F2  SONDA DOW: GIA' MISURATA il 15/08 (giro3) -> NON si rilancia.
#       Con -RifaiSondaDow si rifanno le due sole caselle mai misurate
#       (DJIIDXUSD ERRORE 0 e USA2000IDXUSD 503): ~12 richieste.
#   F3  SPAZIO: stima dichiarata + spazio libero misurato PRIMA
#   F4  CANARINO DI RITMO: si misura un pezzo piccolo e si proietta.
#       Sopra la soglia firmata NON si scarica niente. E' un cancello.
#   F5  SCARICO RIPARTIBILE, UN ANNO ALLA VOLTA, col BATTITO che
#       guarda la CRESCITA DEI FILE (non il tempo: checklist 30)
#   F6  PREPARA L'IMPORT: CSV in MQL5\Files + preset generati DAL
#       SORGENTE (cosi' non puo' mancarci un input: checklist 25)
#   F7  IMPORTA (-Importa): MT5 in /config, AllowLiveTrading=false,
#       chiusura PULITA (la lezione dei 32 lanci a vuoto del 14/08)
#   F8  VERIFICA (-Verifica): ABTG_ContaBarreEXT -> prima e ultima
#       barra M15 e H1 + BARRE PER ANNO. Un anno vuoto in mezzo viene
#       DICHIARATO, non taciuto.
#   F9  REFERTO + raccolta su Desktop + zip, con l'elenco dei file
#       attesi stampato in console.
#
#  NESSUNA ASSENZA SILENZIOSA
#  Tutti e cinque gli indici (NASUSD, D30EUR, U30USD, SPXUSD, 225JPY)
#  compaiono nel referto SEMPRE, anche quelli fuori giro, con scritto
#  perche'. E' il difetto gia' pagato due volte: un simbolo chiesto e
#  non comparso si legge come una domanda mai fatta.
#
#  LA RIGA CHE SI INCOLLA sta nel foglio
#  backtest_pipeline\righe\RIGA_STORICO_INDICI_DA_MANDARE.md
#  (blocco INTERO, un comando solo: checklist 21).
#
#  !! SUL VPS NON SI LANCIA. -Importa e -Verifica aprono MT5 e
#     pretendono che sia chiuso: sul VPS spegnerebbero la flotta.
# =====================================================================
[CmdletBinding()]
param(
  [string]$Pin           = "",      # OBBLIGATORIO sha40: senza, non parte
  [switch]$SoloControllo,           # giro a vuoto: legge i criteri e misura lo spazio, poi si ferma.
                                    #   NON scarica dati e NON apre MT5. (La rete la tocca lo stesso:
                                    #   il file dei criteri si scarica al pin, o non si saprebbe cosa
                                    #   girerebbe la corsa vera.)
  [switch]$RifaiSondaDow,           # rifa' le 2 caselle Dow mai misurate (12 richieste)
  [switch]$Prepara,                 # F6: copia CSV in MQL5\Files e scrive i preset
  [switch]$Importa,                 # F7: import vero in MT5 (implica -Prepara)
  [switch]$Verifica,                # F8: conteggio barre per anno dei simboli _EXT
  [double]$OreMax        = 10.0,    # tetto: non si INIZIA niente di nuovo oltre. Mai si ammazza un lavoro in corso
  [int]   $FermoMinuti   = 25,      # battito: quanti minuti di NON CRESCITA prima di dichiarare fermo
  [int]   $PausaMs       = 0,       # 0 = lascia il default dello strumento (HistData 1500, Duka 250)
  [int]   $GBLiberiMin   = 0,       # 0 = lo calcola dalla stima, x3 di margine
  [string]$Cartella      = ""       # dove lavorare (default: ~\abtg_storico_indici)
)

$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

# ---------------------------------------------------------------------
#  IL PIN. Senza default, apposta: nella riga sorella il default era un
#  hash vecchio e si girava codice di ieri senza accorgersene.
# ---------------------------------------------------------------------
if($Pin -notmatch '^[0-9a-fA-F]{40}$'){
  Write-Host ""
  Write-Host "!!! PIN MANCANTE O NON VALIDO." -ForegroundColor Red
  Write-Host "    Usa il blocco di lancio del foglio RIGA_STORICO_INDICI_DA_MANDARE.md," -ForegroundColor Yellow
  Write-Host "    con l'hash dato in chat. Girare al pin sbagliato vuol dire girare" -ForegroundColor Yellow
  Write-Host "    codice di ieri senza saperlo." -ForegroundColor Yellow
  exit 1
}
$Pin = $Pin.ToLower()
if($Importa){ $Prepara = $true }

$Avvio  = Get-Date
$Stamp  = $Avvio.ToString("yyyyMMdd_HHmm",$INV)
$Dsk    = [Environment]::GetFolderPath("Desktop")
if([string]::IsNullOrWhiteSpace($Dsk)){ $Dsk = Join-Path $env:USERPROFILE "Desktop" }
$Work   = if($Cartella){ $Cartella } else { Join-Path $env:USERPROFILE "abtg_storico_indici" }
$Logs   = Join-Path $Work "log"
$Strum  = Join-Path $Work "strumenti"
$LavHD  = Join-Path $env:USERPROFILE "histdata_m1"       # cartella dello strumento HistData
$LavDK  = Join-Path $env:USERPROFILE "dukascopy_lavoro"  # cartella dello strumento Dukascopy
$RawPin = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

# la cartella di raccolta E' la cartella di sosta, con nome PROPRIO
# subito e UN solo zip in fondo (checklist 26 e 35).
$Cart    = Join-Path $Dsk ("STORICO_INDICI_" + $Stamp)
$CartDat = Join-Path $Cart "dati"
$CartLog = Join-Path $Cart "log"
$Referto = Join-Path $Cart "REFERTO_STORICO_INDICI.txt"
$Stato   = Join-Path $Dsk "STATO_STORICO_INDICI.txt"

$Problemi = New-Object System.Collections.ArrayList
$Note     = New-Object System.Collections.ArrayList
$Passi    = New-Object System.Collections.ArrayList
$Python   = ""

# --- TUTTO quello che il referto finale legge nasce QUI, FUORI dal try.
#     Se la corsa muore alla fase 1, il referto si scrive lo stesso e non
#     esplode su una variabile che non e' mai stata creata (checklist 48:
#     le variabili escono dal try, ma solo se ci sono entrate prima).
$Dec           = @{}
$Fonte         = "(non letta)"
$Simboli       = @()
$AnnoDa        = 0
$AnnoA         = 0
$SogliaOre     = 20.0
$Proiezione    = -1.0
$Canarino      = "NON MISURATO"
$CsvFinali     = @()
$Presets       = @()
$RigheVerifica = @()
$PuoScaricare  = $true
$DataFolder    = ""
$Terminal      = ""
$MetaEditor    = ""

function Ora(){ return (Get-Date).ToString("HH:mm:ss",$INV) }
function Dico($t,$c="Gray"){ Write-Host ("[" + (Ora) + "] " + $t) -ForegroundColor $c }
function Titolo($t){ Write-Host ""; Write-Host ("=== " + $t + " ===") -ForegroundColor Cyan }
function Trascorse(){ return (New-TimeSpan -Start $Avvio -End (Get-Date)).TotalHours }
function N2($d){ return ([double]$d).ToString("0.00",$INV) }
function N1($d){ return ([double]$d).ToString("0.0",$INV) }

function NuovoPasso($fase,$nome){
  $p = [pscustomobject]@{ Fase=$fase; Nome=$nome; Esito="NON ESEGUITO"; Inizio=""; Fine=""; Min=0.0; Nota="" }
  [void]$Passi.Add($p)
  return $p
}

function ScriviStato(){
  try{
    $o = New-Object System.Collections.ArrayList
    [void]$o.Add("STATO -- STORICO ESTERNO DEGLI INDICI")
    [void]$o.Add("data: " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   <-- QUESTA DATA DEVE ESSERE DI ADESSO")
    [void]$o.Add("avvio: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   pin: " + $Pin)
    [void]$o.Add("trascorse: " + (N2 (Trascorse)) + " h  su -OreMax " + (N1 $OreMax))
    [void]$o.Add("")
    [void]$o.Add(("{0,-5} {1,-40} {2,-9} {3,-9} {4,-7} {5}" -f "FASE","PASSO","INIZIO","FINE","MIN","ESITO"))
    foreach($p in $Passi){
      [void]$o.Add(("{0,-5} {1,-40} {2,-9} {3,-9} {4,-7} {5}" -f `
        $p.Fase,$p.Nome,$p.Inizio,$p.Fine,(N1 $p.Min),($p.Esito + $(if($p.Nota -ne ""){ "  -- " + $p.Nota }else{ "" }))))
    }
    Set-Content -LiteralPath $Stato -Value $o -Encoding ASCII
  }catch{ Write-Host ("   (stato non scritto: " + $_.Exception.Message + ")") -ForegroundColor DarkYellow }
}

# --- scarico blindato: niente copia vecchia, errore terminante, marcatore
function Scarica($url,$dest,$marcatore){
  Remove-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue
  Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing -ErrorAction Stop
  if(-not (Test-Path -LiteralPath $dest)){ throw ("scarico fallito: " + $url) }
  if($marcatore -ne "" -and -not (Select-String -LiteralPath $dest -SimpleMatch -Pattern $marcatore -Quiet)){
    throw ("file scaricato SENZA il marcatore '" + $marcatore + "': " + $url)
  }
}

# --- lancio di un eseguibile esterno, guardia abbassata SOLO qui intorno
#     (con $ErrorActionPreference='Stop' una riga di stderr di python fa
#      esplodere PowerShell 5.1 con NativeCommandError)
function EseguiNativo($exe,$argv,$logfile){
  $vecchio = $ErrorActionPreference
  $ErrorActionPreference = "Continue"
  $global:LASTEXITCODE = 0
  try{
    & $exe @argv 2>&1 | Tee-Object -FilePath $logfile | Out-Host
    $rc = $LASTEXITCODE
  }catch{
    $rc = 99
    Write-Host ("    eccezione lanciando " + $exe + ": " + $_.Exception.Message) -ForegroundColor Red
  }finally{ $ErrorActionPreference = $vecchio }
  if($null -eq $rc){ $rc = 0 }
  return [int]$rc
}

# ---------------------------------------------------------------------
#  IL BATTITO CHE GUARDA LA CRESCITA DEI FILE (checklist 30)
#  Il tempo NON e' un segnale: una corsa sana puo' stare zitta per ore.
#  Quello che una corsa sana NON puo' fare e' smettere di far crescere
#  i file: la cache dello scarico cresce a ogni pezzo preso.
#  Percio' si guarda: (a) i byte del log, (b) i byte della cartella
#  sorvegliata. Se NESSUNO dei due cresce per -FermoMinuti, la corsa e'
#  ferma davvero e si chiude -- e NON si esce 0 (checklist 19.2).
#  Le fasi SENZA segnale di crescita (la conversione, che e' solo CPU)
#  NON usano il battito: si dichiarano e vale solo il timeout.
# ---------------------------------------------------------------------
function ByteCartella($path){
  if(-not (Test-Path -LiteralPath $path)){ return [int64]0 }
  $s = [int64]0
  try{
    foreach($f in (Get-ChildItem -LiteralPath $path -Recurse -File -ErrorAction SilentlyContinue)){ $s += $f.Length }
  }catch{ }
  return $s
}

#  ATTENZIONE alle VIRGOLETTE: Start-Process non fa lo splatting come
#  '& $exe @argv'. Rimette insieme gli argomenti in UNA riga di comando,
#  e un percorso con uno spazio dentro ("C:\Users\Claudio Spadaro\...")
#  diventerebbe DUE argomenti. Qui ogni pezzo che contiene uno spazio
#  viene virgolettato a mano.
function Virgoletta($a){
  $s = [string]$a
  if($s -match '\s'){ return ('"' + $s + '"') }
  return $s
}

function EseguiConBattito($exe,$argv,$logfile,$sorveglia,$timeoutMin,$fermoMin){
  $errfile = $logfile + ".err"
  Remove-Item -LiteralPath $logfile,$errfile -Force -ErrorAction SilentlyContinue
  $cmd = @($argv | ForEach-Object { Virgoletta $_ })
  $p = Start-Process -FilePath $exe -ArgumentList $cmd -NoNewWindow -PassThru `
                     -RedirectStandardOutput $logfile -RedirectStandardError $errfile
  $t0 = Get-Date
  $ultimoByte = -1
  $ultimaCrescita = Get-Date
  $esito = "OK"
  while($true){
    try{ $p.Refresh() }catch{ }
    if($p.HasExited){ break }
    Start-Sleep -Seconds 20
    $b = (ByteCartella $sorveglia)
    if(Test-Path -LiteralPath $logfile){ $b += (Get-Item -LiteralPath $logfile).Length }
    if($b -gt $ultimoByte){
      $ultimoByte = $b
      $ultimaCrescita = Get-Date
    }
    $fermoDa = (New-TimeSpan -Start $ultimaCrescita -End (Get-Date)).TotalMinutes
    $andata  = (New-TimeSpan -Start $t0 -End (Get-Date)).TotalMinutes
    if($andata -ge $timeoutMin){
      $esito = "TIMEOUT dopo " + (N1 $andata) + " min"
      break
    }
    if($fermoDa -ge $fermoMin){
      $esito = "FERMO: nessun byte nuovo da " + (N1 $fermoDa) + " min (log e cache sorvegliata)"
      break
    }
  }
  try{ $p.Refresh() }catch{ }
  if(-not $p.HasExited){
    Write-Host ("    !! " + $esito + " -- chiudo il processo.") -ForegroundColor Red
    try{ Stop-Process -Id $p.Id -Force -ErrorAction SilentlyContinue }catch{ }
    Start-Sleep -Seconds 2
    return @{ Rc = 98; Esito = $esito }
  }
  $rc = $p.ExitCode
  if($null -eq $rc){ $rc = 0 }
  # stdout e stderr in un file solo, cosi' la raccolta ne porta uno
  if(Test-Path -LiteralPath $errfile){
    $e = Get-Content -LiteralPath $errfile -Raw -ErrorAction SilentlyContinue
    if($e -and $e.Trim() -ne ""){ Add-Content -LiteralPath $logfile -Value ("`r`n--- stderr ---`r`n" + $e) }
    Remove-Item -LiteralPath $errfile -Force -ErrorAction SilentlyContinue
  }
  return @{ Rc = [int]$rc; Esito = "uscito con " + $rc }
}

Write-Host ""
Write-Host "#####################################################################" -ForegroundColor Cyan
Write-Host "#  STORICO ESTERNO DEGLI INDICI -- piu' anni per i test             #" -ForegroundColor Cyan
Write-Host "#####################################################################" -ForegroundColor Cyan
Write-Host "  I DATI SONO DI UN ALTRO BROKER: spread, orari di seduta e prezzi" -ForegroundColor Yellow
Write-Host "  NON sono BCM. E il CANCELLO ZERO sugli indici _EXT e' ancora" -ForegroundColor Yellow
Write-Host "  CHIUSO: questa riga produce DATI, non il permesso di usarli." -ForegroundColor Yellow
Dico ("pin      : " + $Pin)
Dico ("lavoro   : " + $Work)
Dico ("raccolta : " + $Cart)

New-Item -ItemType Directory -Force -Path $Work,$Logs,$Strum,$Cart,$CartDat,$CartLog | Out-Null

# =====================================================================
#  F0. MT5 CHIUSO -- solo se serve davvero
# =====================================================================
if(($Importa -or $Verifica) -and -not $SoloControllo){
  if(Get-Process -Name "terminal64" -ErrorAction SilentlyContinue){
    Write-Host ""
    Write-Host "!!! MT5 E' APERTO e questa corsa deve scrivere nella sua cartella dati." -ForegroundColor Red
    Write-Host "    MT5 riscrive i suoi file all'uscita: quello che facciamo adesso" -ForegroundColor Yellow
    Write-Host "    verrebbe cancellato. Chiudi MetaTrader (TUTTE le istanze) e rilancia." -ForegroundColor Yellow
    Write-Host "    Non lo ammazzo io: potrebbe essere Claudio che sta guardando un grafico." -ForegroundColor Yellow
    exit 1
  }
}

# =====================================================================
#  LA TABELLA DEI CINQUE INDICI.
#  Esiste perche' NESSUNO possa sparire dal referto. Anche quelli fuori
#  giro ci compaiono, con scritto perche'.
# =====================================================================
function S($bcm,$che,$hd,$duka,$stato,$perche){
  return [pscustomobject]@{ Bcm=$bcm; Che=$che; HD=$hd; Duka=$duka; Stato=$stato; Perche=$perche
                            Fase="NON RICHIESTO"; Barre=-1; Anni="" }
}
$Sedi = @(
  (S "NASUSD" "Nasdaq 100"  "nsxusd" "USATECHIDXUSD" "-" "-"),
  (S "D30EUR" "DAX 40"      "grxeur" "DEUIDXEUR"     "-" "-"),
  (S "U30USD" "Dow Jones"   ""       "USA30IDXUSD"   "-" "-"),
  (S "SPXUSD" "S&P 500"     "spxusd" "USA500IDXUSD"  "-" "-"),
  (S "225JPY" "Nikkei 225"  "jpxjpy" "JPNIDXJPY"     "-" "-")
)
function Sede($bcm){ return ($Sedi | Where-Object { $_.Bcm -eq $bcm } | Select-Object -First 1) }

# --- lettura delle decisioni. Definite QUI, fuori dal try: una funzione
#     dichiarata dentro un try che muore prima non esiste (checklist 48).
function Firmata($id){ return ($Dec.ContainsKey($id) -and $Dec[$id].Stato -eq "FIRMATO") }
function Valore($id,$difetto){ if($Dec.ContainsKey($id)){ return $Dec[$id].Valore }; return $difetto }

# =====================================================================
#  UNA CHIAMATA A MT5 IN /config, fatta come si deve
#   - AllowLiveTrading=false SEMPRE (checklist 51: aprire MT5 per
#     misurare non deve poter riarmare niente)
#   - MaxBars illimitato (checklist 36: il tetto ritaglia lo storico)
#   - chiusura PULITA: col kill le BARRE restano e la REGISTRAZIONE del
#     simbolo no (i 32 lanci a vuoto del 14/08)
# =====================================================================
function ChiudiMT5Pulito([int]$secondi = 90){
  $procs = @(Get-Process -Name "terminal64" -ErrorAction SilentlyContinue)
  if($procs.Count -eq 0){ return $true }
  foreach($p in $procs){ try{ [void]$p.CloseMainWindow() }catch{ } }
  $scade = (Get-Date).AddSeconds($secondi)
  while((Get-Date) -lt $scade){
    Start-Sleep -Seconds 2
    if(@(Get-Process -Name "terminal64" -ErrorAction SilentlyContinue).Count -eq 0){
      Write-Host "    MT5 chiuso in modo pulito (simboli personalizzati salvati)." -ForegroundColor Green
      return $true
    }
  }
  Write-Host "    !! MT5 non si e' chiuso da solo: lo forzo. I simboli creati adesso" -ForegroundColor Yellow
  Write-Host "       potrebbero NON essere registrati (le barre restano, il simbolo no)." -ForegroundColor Yellow
  foreach($p in @(Get-Process -Name "terminal64" -ErrorAction SilentlyContinue)){
    try{ Stop-Process -Id $p.Id -Force -ErrorAction SilentlyContinue }catch{ }
  }
  Start-Sleep -Seconds 3
  return $false
}

function LanciaScriptMT5($nomeScript,$setName,$simboloGrafico,$fileAtteso,$timeoutMin){
  $ini = Join-Path $env:TEMP ("abtg_storico_indici_" + $nomeScript + ".ini")
  $testo = "[Charts]`r`nMaxBars=2000000000`r`n`r`n" +
           "[Experts]`r`nAllowLiveTrading=false`r`nEnabled=true`r`n`r`n" +
           "[StartUp]`r`nScript=" + $nomeScript + "`r`n" +
           "ScriptParameters=" + $setName + "`r`n" +
           "Symbol=" + $simboloGrafico + "`r`nPeriod=H1`r`n"
  Set-Content -LiteralPath $ini -Value $testo -Encoding Unicode
  $t0 = Get-Date
  Start-Process -FilePath $Terminal -ArgumentList ("/config:" + (Virgoletta $ini))
  $scade = (Get-Date).AddMinutes($timeoutMin)
  $fatto = $false
  while((Get-Date) -lt $scade){
    Start-Sleep -Seconds 10
    if(Test-Path -LiteralPath $fileAtteso){
      if((Get-Item -LiteralPath $fileAtteso).LastWriteTime -ge $t0){ $fatto = $true; break }
    }
  }
  [void](ChiudiMT5Pulito 90)
  Start-Sleep -Seconds 3
  return $fatto
}

try{

# =====================================================================
#  F1. I CRITERI, LETTI AL PIN E A MACCHINA
# =====================================================================
Titolo "F1 - I CRITERI (STORICO_INDICI_CRITERI.md, al pin)"
$pc = NuovoPasso "F1" "criteri al pin"
$pc.Inizio = (Ora)
$FileCrit = Join-Path $Work "STORICO_INDICI_CRITERI.md"
Scarica ("$RawPin/backtest_pipeline/risultati_archivio/STORICO_INDICI_CRITERI.md") $FileCrit '@DECISIONE'
Copy-Item -LiteralPath $FileCrit -Destination (Join-Path $Cart "STORICO_INDICI_CRITERI.md") -Force

$Dec = @{}
foreach($riga in (Get-Content -LiteralPath $FileCrit)){
  $m = [regex]::Match($riga,'^@DECISIONE\s+(\S+)\s+CHIAVE=(\S+)\s+VALORE=(\S+)\s+STATO=(\S+)\s*$')
  if($m.Success){
    $Dec[$m.Groups[1].Value] = [pscustomobject]@{
      Id=$m.Groups[1].Value; Chiave=$m.Groups[2].Value; Valore=$m.Groups[3].Value
      Stato=$m.Groups[4].Value.ToUpper() }
  }
}
if($Dec.Count -eq 0){ throw "nel file dei criteri non c'e' nessuna riga @DECISIONE leggibile: non invento le decisioni." }

Write-Host ("   {0,-5} {1,-22} {2,-24} {3}" -f "ID","CHIAVE","VALORE","STATO") -ForegroundColor Gray
$nonFirmate = 0
foreach($k in ($Dec.Keys | Sort-Object)){
  $d = $Dec[$k]
  $col = if($d.Stato -eq "FIRMATO"){ "Green" } else { "Yellow" }
  if($d.Stato -ne "FIRMATO"){ $nonFirmate++ }
  Write-Host ("   {0,-5} {1,-22} {2,-24} {3}" -f $d.Id,$d.Chiave,$d.Valore,$d.Stato) -ForegroundColor $col
}
$pc.Fine = (Ora); $pc.Esito = "OK"; $pc.Nota = ("" + $Dec.Count + " decisioni, " + $nonFirmate + " da firmare")
ScriviStato

$Fonte    = (Valore "D-A" "histdata").ToLower()
$SimStr   = (Valore "D-B" "NASUSD").ToUpper()
$Finestra = (Valore "D-D" "2010-2026")
$SogliaOre= 20.0
[void][double]::TryParse((Valore "D-E" "20"),[Globalization.NumberStyles]::Float,$INV,[ref]$SogliaOre)
$Simboli  = @($SimStr -split "," | ForEach-Object { $_.Trim() } | Where-Object { $_ })
$AnnoDa = 2010; $AnnoA = (Get-Date).Year
$mf = [regex]::Match($Finestra,'^(\d{4})-(\d{4})$')
if($mf.Success){ $AnnoDa = [int]$mf.Groups[1].Value; $AnnoA = [int]$mf.Groups[2].Value }
if($AnnoA -gt (Get-Date).Year){ $AnnoA = (Get-Date).Year }

Write-Host ""
Write-Host ("   fonte     : " + $Fonte)     -ForegroundColor White
Write-Host ("   simboli   : " + ($Simboli -join ", ")) -ForegroundColor White
Write-Host ("   finestra  : " + $AnnoDa + " -> " + $AnnoA) -ForegroundColor White
Write-Host ("   soglia canarino: " + (N1 $SogliaOre) + " ore") -ForegroundColor White

# lo stato di OGNI indice, compresi quelli fuori giro
foreach($s in $Sedi){
  if($Simboli -contains $s.Bcm){ $s.Fase = "IN GIRO" }
  else{
    $s.Fase = "FUORI GIRO (dichiarato)"
    if($s.Bcm -eq "U30USD"){ $s.Perche = "HistData non ha il Dow; Dukascopy si' (2012) ma costa ~12,7 giorni di crawl" }
    elseif($s.Bcm -eq "D30EUR"){ $s.Perche = "grxeur BOCCIATO (min 2.906 impossibile + sessione ballerina 2020-2023): prima la diagnosi, D-F" }
    else{ $s.Perche = "non incluso in D-B per questo giro" }
  }
}

$PuoScaricare = $true
if(-not (Firmata "D-A")){ $PuoScaricare = $false; [void]$Problemi.Add("D-A (FONTE) NON FIRMATA: lo scarico non parte.") }
if(-not (Firmata "D-B")){ $PuoScaricare = $false; [void]$Problemi.Add("D-B (SIMBOLI) NON FIRMATA: lo scarico non parte.") }
if(-not (Firmata "D-D")){ $PuoScaricare = $false; [void]$Problemi.Add("D-D (FINESTRA) NON FIRMATA: lo scarico non parte.") }
if(-not (Firmata "D-C")){ [void]$Note.Add("D-C (USO) non firmata: i dati si possono produrre, NON usare. Il limite d'uso resta quello dei forex _EXT: SOLO prova di regime.") }
if(-not (Firmata "D-E")){ [void]$Note.Add("D-E (SOGLIA CANARINO) non firmata: uso " + (N1 $SogliaOre) + " ore come valore di lavoro, e lo dichiaro.") }
if(-not $PuoScaricare){
  Write-Host ""
  Write-Host "   !! CI SONO DECISIONI DA FIRMARE: le fasi che le consumano NON partono." -ForegroundColor Yellow
  Write-Host "      Si firma nel file dei criteri (STATO=FIRMATO), si pusha, e la riga" -ForegroundColor Yellow
  Write-Host "      si rilancia col PIN NUOVO. Le fasi che non dipendono da nessuna" -ForegroundColor Yellow
  Write-Host "      decisione (sonda, spazio, anteprime) girano lo stesso." -ForegroundColor Yellow
}

# =====================================================================
#  F2. LA SONDA DEL DOW -- GIA' MISURATA, e non si rimisura
# =====================================================================
Titolo "F2 - SONDA DOW"
$ps = NuovoPasso "F2" "sonda Dow"
$ps.Inizio = (Ora)
Write-Host "   La missione chiedeva: 'verifica se un secondo giro e' mai tornato'." -ForegroundColor White
Write-Host "   E' TORNATO, due volte, ed e' agli atti in REFERTO_SONDA_DUKASCOPY.md:" -ForegroundColor White
Write-Host "     giro2 (15/08 16:25) e giro3 (15/08 16:45)" -ForegroundColor Gray
Write-Host "     USA30IDXUSD  OK  49.445 byte   -> PRIMO ANNO 2012   [VERIFICATO]" -ForegroundColor Green
Write-Host "     US30IDXUSD / USA30USD / WS30IDXUSD / GERIDXEUR  -> ASSENTE (404 veri)" -ForegroundColor Gray
Write-Host "     DJIIDXUSD (ERRORE 0) e USA2000IDXUSD (503)  -> NON MISURATE, e non ci servono" -ForegroundColor DarkYellow
Write-Host "   Quindi la fase 1 della missione era GIA' CHIUSA: non la rilancio." -ForegroundColor White
Write-Host "   Rilanciare una misura chiusa e' come non averla fatta." -ForegroundColor DarkGray
$ps.Esito = "GIA' MISURATA (giro3 15/08) - non rilanciata"
$ps.Nota  = "USA30IDXUSD = 2012"

if($RifaiSondaDow -and -not $SoloControllo){
  Write-Host ""
  Write-Host "   -RifaiSondaDow: rifaccio SOLO le due caselle mai misurate (~12 richieste)." -ForegroundColor Yellow
  $sonda = Join-Path $Strum "sonda_dukascopy.ps1"
  try{
    Scarica ("$RawPin/backtest_pipeline/sonda_dukascopy.ps1") $sonda 'SONDA DUKASCOPY'
    $logS = Join-Path $Logs "sonda_dow.txt"
    $rcS = EseguiNativo "powershell" @("-ExecutionPolicy","Bypass","-File",$sonda,"-Simboli","DJIIDXUSD,USA2000IDXUSD,USA30IDXUSD","-Anni","2025") $logS
    Copy-Item -LiteralPath $logS -Destination (Join-Path $CartLog "sonda_dow.txt") -Force -ErrorAction SilentlyContinue
    $csvS = Join-Path $Dsk "sonda_dukascopy\sonda_dukascopy.csv"
    if(Test-Path -LiteralPath $csvS){
      Copy-Item -LiteralPath $csvS -Destination (Join-Path $CartDat "sonda_dow_20260825.csv") -Force
      $ps.Esito = "RIFATTA (2 caselle) - rc " + $rcS
    } else {
      [void]$Problemi.Add("F2: -RifaiSondaDow non ha prodotto sonda_dukascopy.csv. Guarda " + $logS)
      $ps.Esito = "RIFATTA MA SENZA CSV (rc " + $rcS + ")"
    }
  }catch{
    [void]$Problemi.Add("F2: sonda non rilanciata (" + $_.Exception.Message + "). La misura del 15/08 resta valida.")
  }
}
$ps.Fine = (Ora)
ScriviStato

# =====================================================================
#  F3. SPAZIO: la stima si DICHIARA, il libero si MISURA, PRIMA
# =====================================================================
Titolo "F3 - SPAZIO SU DISCO (stima dichiarata, libero misurato)"
$psz = NuovoPasso "F3" "spazio disco"
$psz.Inizio = (Ora)
$anni = [Math]::Max(1, $AnnoA - $AnnoDa + 1)

# --- i numeri della stima, e da dove vengono. [INFERITO], non misurato
#     su una corsa piena: sono estrapolazioni da byte veri.
#   HistData: uno ZIP annuale M1 di un indice ~5 MB (330k barre/anno),
#             il CSV M1 ~15 MB/anno (45 byte a riga).
#   Dukascopy: 12,4 KB per ora di DAX (596 ore = 7,4 MB, corsa 18/08);
#             il Nasdaq nella sonda pesa 5,4 volte il DAX sulla stessa
#             ora (95.995 contro 17.875 byte). 7.512 ore l'anno.
$MBAnno = @{}
if($Fonte -eq "histdata"){
  foreach($s in $Simboli){ $MBAnno[$s] = 20.0 }          # 5 zip + 15 csv
} else {
  foreach($s in $Simboli){
    $kbOra = 12.4
    if($s -eq "NASUSD"){ $kbOra = 67.0 }
    if($s -eq "SPXUSD"){ $kbOra = 20.0 }
    $MBAnno[$s] = ($kbOra * 7512.0 / 1024.0) + 15.0      # cache .bi5 + csv
  }
}
$MBTot = 0.0
Write-Host ("   {0,-9} {1,-10} {2,12} {3,14}" -f "SIMBOLO","FONTE","MB / ANNO",("MB x " + $anni + " ANNI")) -ForegroundColor Gray
foreach($s in $Simboli){
  $tot = $MBAnno[$s] * $anni
  $MBTot += $tot
  Write-Host ("   {0,-9} {1,-10} {2,12} {3,14}" -f $s,$Fonte,(N1 $MBAnno[$s]),(N1 $tot)) -ForegroundColor White
}
$GBTot = $MBTot / 1024.0
Write-Host ("   TOTALE STIMATO: " + (N2 $GBTot) + " GB   [INFERITO: estrapolato da byte misurati, non da una corsa piena]") -ForegroundColor Yellow
Write-Host  "   Piu' lo spazio dentro MT5 per il simbolo custom: ~150 MB ogni 2,5 milioni" -ForegroundColor DarkGray
Write-Host  "   di barre M1 (misurato il 14/08 sui forex _EXT)." -ForegroundColor DarkGray

$soglia = if($GBLiberiMin -gt 0){ [double]$GBLiberiMin } else { [Math]::Max(3.0, $GBTot * 3.0) }
$drive  = (Split-Path -Qualifier $Work)
$liberi = -1.0
try{
  $d = Get-PSDrive -Name ($drive -replace ':','') -ErrorAction Stop
  $liberi = [double]$d.Free / 1GB
}catch{ }
if($liberi -lt 0){
  [void]$Note.Add("F3: non sono riuscito a misurare lo spazio libero su " + $drive + ": dichiarato, non assunto.")
  Write-Host ("   spazio libero su " + $drive + ": NON MISURABILE") -ForegroundColor Yellow
  $psz.Esito = "NON MISURABILE"
} else {
  Write-Host ("   spazio libero su " + $drive + ": " + (N2 $liberi) + " GB   (serve almeno " + (N2 $soglia) + " GB, x3 di margine)") -ForegroundColor White
  if($liberi -lt $soglia){
    $PuoScaricare = $false
    [void]$Problemi.Add("F3: SPAZIO INSUFFICIENTE. Liberi " + (N2 $liberi) + " GB, servono " + (N2 $soglia) + " GB. Lo scarico NON parte.")
    Write-Host "   !! SPAZIO INSUFFICIENTE: lo scarico non parte." -ForegroundColor Red
    $psz.Esito = "INSUFFICIENTE"
  } else { $psz.Esito = "OK" }
}
$psz.Fine = (Ora); $psz.Nota = (N2 $GBTot) + " GB stimati"
ScriviStato

# =====================================================================
#  PYTHON: MISURATO, mai dedotto (checklist 17)
# =====================================================================
if(-not $SoloControllo -and $PuoScaricare){
  $pp = NuovoPasso "F4" "python trovato e >= 3.8"
  $pp.Inizio = (Ora)
  $Python = (Get-Command python.exe -ErrorAction SilentlyContinue |
             Where-Object { $_.Source -notlike "*\WindowsApps\*" } |
             Select-Object -First 1 -ExpandProperty Source)
  if(-not $Python){ $Python = (Get-Command py.exe -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty Source) }
  if(-not $Python){
    $PuoScaricare = $false
    $pp.Esito = "ASSENTE"
    [void]$Problemi.Add("PYTHON ASSENTE (o solo lo stub del Microsoft Store): installalo da python.org spuntando 'Add python.exe to PATH'. Senza, lo scarico non e' eseguibile.")
  } else {
    $rcv = EseguiNativo $Python @("-c","import sys; print(sys.version); sys.exit(0 if sys.version_info>=(3,8) else 1)") (Join-Path $Logs "python_versione.txt")
    if($rcv -ne 0){
      $PuoScaricare = $false
      $pp.Esito = "TROPPO VECCHIO"
      [void]$Problemi.Add("PYTHON TROPPO VECCHIO O NON FUNZIONANTE: " + $Python)
    } else {
      $pp.Esito = "OK"; $pp.Nota = $Python
      Dico ("python: " + $Python) "Green"
    }
  }
  $pp.Fine = (Ora)
  ScriviStato
}

# --- lo strumento giusto, al pin, col suo marcatore
$ScriptPy = ""
$MarcaPy  = ""
$LavFonte = ""
if($Fonte -eq "histdata"){ $ScriptPy = "histdata_m1.py";  $MarcaPy = "HD-M1-v4";   $LavFonte = $LavHD }
else                     { $ScriptPy = "dukascopy_m1.py"; $MarcaPy = "DUKA-M1-v3"; $LavFonte = $LavDK }
$PyFile = Join-Path $Strum $ScriptPy

if(-not $SoloControllo -and $PuoScaricare){
  $pk = NuovoPasso "F4" ($ScriptPy + " al pin")
  $pk.Inizio = (Ora)
  try{
    Scarica ("$RawPin/backtest_pipeline/dukascopy/" + $ScriptPy) $PyFile $MarcaPy
    New-Item -ItemType Directory -Force -Path $LavFonte | Out-Null
    $pk.Esito = "OK"; $pk.Nota = "marcatore " + $MarcaPy + " verificato"
    Dico ($ScriptPy + " al pin (" + $MarcaPy + ")") "Green"
  }catch{
    $PuoScaricare = $false
    $pk.Esito = "FALLITO"
    [void]$Problemi.Add("F4: " + $_.Exception.Message)
  }
  $pk.Fine = (Ora)
  ScriviStato
}

# =====================================================================
#  F4. IL CANARINO DI RITMO -- un cancello deciso PRIMA di misurare
# =====================================================================
$Proiezione = -1.0
$Canarino   = "NON MISURATO"
if($PuoScaricare -and -not $SoloControllo){
  Titolo "F4 - CANARINO DI RITMO (cancello: soglia firmata, decisa PRIMA)"
  $pcn = NuovoPasso "F4" "canarino di ritmo"
  $pcn.Inizio = (Ora)
  $log = Join-Path $Logs "canarino.txt"
  $t0  = Get-Date
  $rc  = 0
  if($Fonte -eq "histdata"){
    # il canarino di HistData e' l'ESPLORAZIONE: dice se il canale e'
    # aperto E se gli anni chiesti esistono davvero (e' anche il
    # controllo positivo, EURUSD compreso). Costa 1 richiesta per
    # simbolo-anno: sui 17 anni sono ~20 richieste.
    $codici = @()
    foreach($x in $Simboli){
      $sx = Sede $x
      if($sx -and -not [string]::IsNullOrWhiteSpace($sx.HD)){ $codici += $sx.HD }
      else{ [void]$Problemi.Add("F4: " + $x + " non esiste su HistData (il Dow non c'e'): fuori dal canarino e fuori dallo scarico. DICHIARATO.") }
    }
    if($codici.Count -eq 0){ throw "nessuno dei simboli chiesti esiste su HistData: non c'e' niente da esplorare." }
    $argv = @("-u",$PyFile,"--esplora","--simboli",($codici -join ","),
              "--da",("" + $AnnoDa),"--a",("" + $AnnoA),"--cartella",$LavFonte)
    if($PausaMs -gt 0){ $argv += @("--pausa-ms",("" + $PausaMs)) }
    $rc = EseguiNativo $Python $argv $log
    $sec = (New-TimeSpan -Start $t0 -End (Get-Date)).TotalSeconds
    # la proiezione: l'esplorazione fa 1 richiesta per simbolo-anno,
    # lo scarico ne fa 1 per simbolo-anno. Stesso ordine di grandezza,
    # con i file veri da trasferire in piu': x6 di margine, dichiarato.
    $Proiezione = ($sec * 6.0) / 3600.0
    $pcn.Nota = "esplorazione " + (N1 $sec) + " s, rc " + $rc
  } else {
    # il canarino di Dukascopy e' UN GIORNO vero, come nella notte #2.
    # Il ritmo si proietta sui giorni che lo strumento ITERA davvero
    # (tutti tranne il sabato), non sui giorni di borsa.
    $primo = ($Simboli | Select-Object -First 1)
    $sd = Sede $primo
    $argv = @("-u",$PyFile,"--simboli",$sd.Duka,"--da","2020-06-16","--a","2020-06-16","--cartella",$LavFonte)
    if($PausaMs -gt 0){ $argv += @("--pausa-ms",("" + $PausaMs)) }
    $rc = EseguiNativo $Python $argv $log
    $sec = (New-TimeSpan -Start $t0 -End (Get-Date)).TotalSeconds
    $gg = 0
    $d = Get-Date -Year $AnnoDa -Month 1 -Day 1
    $fine = Get-Date -Year $AnnoA -Month 12 -Day 31
    while($d -le $fine){ if($d.DayOfWeek -ne [DayOfWeek]::Saturday){ $gg++ }; $d = $d.AddDays(1) }
    $Proiezione = ($sec * $gg * $Simboli.Count) / 3600.0
    $pcn.Nota = "1 giorno = " + (N1 $sec) + " s, " + $gg + " giorni x " + $Simboli.Count + " simboli"
    Write-Host ("   1 giorno vero = " + (N1 $sec) + " s   (comprende il controllo positivo: stima CONSERVATIVA)") -ForegroundColor White
  }
  Copy-Item -LiteralPath $log -Destination (Join-Path $CartLog "canarino.txt") -Force -ErrorAction SilentlyContinue
  Write-Host ("   PROIEZIONE sullo scarico chiesto: " + (N1 $Proiezione) + " ORE   (soglia " + (N1 $SogliaOre) + ")") -ForegroundColor White
  if($rc -ne 0){
    $Canarino = "ROSSO (lo strumento e' uscito con " + $rc + ")"
    $PuoScaricare = $false
    [void]$Problemi.Add("F4 CANARINO ROSSO: " + $ScriptPy + " e' uscito con " + $rc + " sul pezzo di prova. Non si scarica niente. Guarda " + $log)
    $pcn.Esito = "ROSSO (rc " + $rc + ")"
  }
  elseif($Proiezione -gt $SogliaOre){
    $Canarino = "ROSSO (" + (N1 $Proiezione) + " ore > " + (N1 $SogliaOre) + ")"
    $PuoScaricare = $false
    [void]$Problemi.Add("F4 CANARINO ROSSO: lo scarico chiesto costa " + (N1 $Proiezione) + " ore, sopra la soglia FIRMATA di " + (N1 $SogliaOre) + ". NON si scarica niente: si cambia strada o si firma un'altra soglia.")
    $pcn.Esito = "ROSSO"
    Write-Host "   !! CANARINO ROSSO. Il cancello era deciso PRIMA di misurare: non scarico." -ForegroundColor Red
  }
  else{
    $Canarino = "VERDE (" + (N1 $Proiezione) + " ore <= " + (N1 $SogliaOre) + ")"
    $pcn.Esito = "VERDE"
    Dico ("CANARINO " + $Canarino) "Green"
  }
  $pcn.Fine = (Ora)
  ScriviStato
}

# =====================================================================
#  F5. LO SCARICO -- RIPARTIBILE, UN ANNO ALLA VOLTA
#
#  LE DUE FONTI NON SI SPEZZANO ALLO STESSO MODO, ed e' una cosa letta
#  nel codice di chi scrive, non dedotta:
#
#   DUKASCOPY  --da/--a limitano DAVVERO il crawl e il CSV. E il CSV lo
#     scrive SOLO a fine simbolo (limite dichiarato nel suo commento):
#     una corsa lunga interrotta lascia la cache piena e ZERO CSV.
#     Percio': una chiamata per ANNO, il pezzo dell'anno copiato SUBITO
#     con un nome proprio, e la concatenazione in fondo.
#
#   HISTDATA   --scarica rispetta gli anni; --converti NO: ingerisce
#     TUTTI gli zip della cartella (ingerisci_zip, riga ~1393) e
#     IGNORA --da/--a. Spezzare la conversione per anno produrrebbe
#     ogni volta un CSV CUMULATIVO, e concatenarli darebbe un file
#     pieno di duplicati -- un difetto silenzioso, con un CSV grosso e
#     plausibile in mano. Percio': lo SCARICO si spezza per anno (e' la
#     parte lunga e interrompibile), la CONVERSIONE si fa UNA volta
#     sola in fondo, e il suo CSV E' GIA' quello finale.
#
#  IL BATTITO guarda la CRESCITA DEI FILE, mai il tempo (checklist 30).
#  La conversione, che e' solo CPU e non fa crescere niente, il battito
#  NON lo usa: e' dichiarata, e ha solo il timeout.
# =====================================================================
if($PuoScaricare -and -not $SoloControllo -and $Canarino -like "VERDE*"){
  Titolo "F5 - SCARICO (ripartibile, un anno alla volta, battito sulla CRESCITA dei file)"
  foreach($simbolo in $Simboli){
    $sd = Sede $simbolo
    if(-not $sd){ [void]$Problemi.Add("F5: " + $simbolo + " non e' fra i cinque indici noti: saltato."); continue }
    $codice = if($Fonte -eq "histdata"){ $sd.HD } else { $sd.Duka }
    if([string]::IsNullOrWhiteSpace($codice)){
      $sd.Fase   = "IMPOSSIBILE su questa fonte"
      $sd.Perche = "la fonte " + $Fonte + " non ha questo simbolo (il Dow su HistData non esiste)"
      [void]$Problemi.Add("F5: " + $simbolo + " non esiste sulla fonte " + $Fonte + ". Saltato, e DICHIARATO.")
      continue
    }
    $CartAnni = Join-Path $Work ("anni\" + $simbolo)
    New-Item -ItemType Directory -Force -Path $CartAnni | Out-Null
    $fattiAnni = @()
    $csvStrum  = Join-Path $LavFonte ($(if($Fonte -eq "histdata"){ "" } else { "m1\" }) + $simbolo + "_M1.csv")

    # ---------- il giro degli anni ----------
    for($anno = $AnnoDa; $anno -le $AnnoA; $anno++){
      if((Trascorse) -ge $OreMax){
        [void]$Problemi.Add("F5: " + $simbolo + " " + $anno + " NON INIZIATO (tetto -OreMax). Rilancia la STESSA riga: la cache riprende da dove era.")
        break
      }

      # --- l'artefatto che dice "questo anno e' gia' fatto"
      $pezzo = Join-Path $CartAnni ($simbolo + "_M1_" + $anno + ".csv")
      $giaFatto = $false
      if($Fonte -eq "histdata"){
        $zipAnno = @(Get-ChildItem -LiteralPath $LavFonte -Filter ("DAT_ASCII_" + $codice.ToUpper() + "_M1_" + $anno + "*.zip") -ErrorAction SilentlyContinue)
        $giaFatto = ($zipAnno.Count -gt 0)
      } else {
        $giaFatto = (Test-Path -LiteralPath $pezzo)
      }
      if($giaFatto){
        Write-Host ("   " + $simbolo + " " + $anno + ": gia' in cache, salto (ripresa).") -ForegroundColor DarkGray
        $fattiAnni += $anno
        continue
      }

      $pa = NuovoPasso "F5" ($simbolo + " " + $anno)
      $pa.Inizio = (Ora)
      $t0  = Get-Date
      $log = Join-Path $Logs ("scarico_" + $simbolo + "_" + $anno + ".txt")

      if($Fonte -eq "histdata"){
        $argv = @("-u",$PyFile,"--scarica","--simboli",$codice,"--da",("" + $anno),"--a",("" + $anno),"--cartella",$LavFonte)
        if($PausaMs -gt 0){ $argv += @("--pausa-ms",("" + $PausaMs)) }
        $r1 = EseguiConBattito $Python $argv $log $LavFonte 120 $FermoMinuti
      } else {
        # il CSV dello strumento ha SEMPRE lo stesso nome: si cancella
        # PRIMA, cosi' un file di ieri non puo' passare per uno di adesso
        Remove-Item -LiteralPath $csvStrum -Force -ErrorAction SilentlyContinue
        $argv = @("-u",$PyFile,"--simboli",$codice,"--da",("" + $anno + "-01-01"),"--a",("" + $anno + "-12-31"),"--cartella",$LavFonte)
        if($PausaMs -gt 0){ $argv += @("--pausa-ms",("" + $PausaMs)) }
        $r1 = EseguiConBattito $Python $argv $log (Join-Path $LavFonte "raw") 600 $FermoMinuti
      }
      $sec = (New-TimeSpan -Start $t0 -End (Get-Date)).TotalSeconds
      $pa.Fine = (Ora); $pa.Min = [Math]::Round($sec/60.0,1)
      Copy-Item -LiteralPath $log -Destination (Join-Path $CartLog (Split-Path -Leaf $log)) -Force -ErrorAction SilentlyContinue

      # --- IL GATE STA SULL'ARTEFATTO, non sul solo codice d'uscita
      $fresco = $false
      if($Fonte -eq "histdata"){
        $zipAnno = @(Get-ChildItem -LiteralPath $LavFonte -Filter ("DAT_ASCII_" + $codice.ToUpper() + "_M1_" + $anno + "*.zip") -ErrorAction SilentlyContinue)
        $fresco = ($zipAnno.Count -gt 0)
        $pa.Nota = "" + $zipAnno.Count + " zip, " + (N1 $sec) + " s"
      } else {
        if(Test-Path -LiteralPath $csvStrum){ $fresco = ((Get-Item -LiteralPath $csvStrum).LastWriteTime -ge $t0) }
        if($fresco){
          # nome PROPRIO SUBITO (checklist 26): la chiamata dell'anno dopo
          # riscrive lo stesso file, e senza questa copia il pezzo sparisce
          Copy-Item -LiteralPath $csvStrum -Destination $pezzo -Force
          $pa.Nota = "" + (@(Get-Content -LiteralPath $pezzo)).Count + " righe, " + (N1 $sec) + " s"
        }
      }
      if(-not $fresco){
        $pa.Esito = "NIENTE ARTEFATTO"
        [void]$Problemi.Add("F5: " + $simbolo + " " + $anno + ": niente artefatto scritto adesso (rc " + $r1.Rc + ", " + $r1.Esito + "). Guarda " + $log)
        ScriviStato
        continue
      }
      $pa.Esito = if($r1.Rc -eq 0){ "OK" } else { "CON BUCHI (rc " + $r1.Rc + ")" }
      if($r1.Rc -ne 0){
        [void]$Problemi.Add("F5: " + $simbolo + " " + $anno + ": lo strumento e' uscito con " + $r1.Rc + " (" + $r1.Esito +
                            "). Rilanciare la STESSA riga: la cache non riscarica quello che c'e' gia'.")
      }
      $fattiAnni += $anno
      Write-Host ("   " + $simbolo + " " + $anno + ": " + $pa.Esito + "   " + $pa.Nota) -ForegroundColor Green
      ScriviStato
    }

    # ---------- da pezzi a CSV finale ----------
    if($fattiAnni.Count -eq 0){
      $sd.Fase   = "NESSUN ANNO SCARICATO"
      $sd.Perche = "vedi i problemi"
      [void]$Problemi.Add("F5: " + $simbolo + ": nessun anno scaricato.")
      continue
    }
    $finale = Join-Path $Work ($simbolo + "_M1.csv")
    $tot = 0

    if($Fonte -eq "histdata"){
      # UNA conversione sola, in fondo, su tutta la finestra. Fase senza
      # segnale di crescita: niente battito, solo il codice d'uscita e
      # l'artefatto. E' DICHIARATA, non taciuta.
      $pcv = NuovoPasso "F5" ($simbolo + " conversione (tutta la finestra)")
      $pcv.Inizio = (Ora)
      Write-Host ("   " + $simbolo + ": converto TUTTI gli zip in cartella (fase di sola CPU: puo' stare zitta per minuti)") -ForegroundColor Gray
      Remove-Item -LiteralPath $csvStrum -Force -ErrorAction SilentlyContinue
      $t0 = Get-Date
      $logc = Join-Path $Logs ("converti_" + $simbolo + ".txt")
      $rcC = EseguiNativo $Python @("-u",$PyFile,"--converti","--simboli",$codice,"--da",("" + $AnnoDa),"--a",("" + $AnnoA),"--cartella",$LavFonte) $logc
      Copy-Item -LiteralPath $logc -Destination (Join-Path $CartLog (Split-Path -Leaf $logc)) -Force -ErrorAction SilentlyContinue
      $pcv.Fine = (Ora); $pcv.Min = [Math]::Round((New-TimeSpan -Start $t0 -End (Get-Date)).TotalMinutes,1)
      if((Test-Path -LiteralPath $csvStrum) -and ((Get-Item -LiteralPath $csvStrum).LastWriteTime -ge $t0)){
        Copy-Item -LiteralPath $csvStrum -Destination $finale -Force
        $tot = (@(Get-Content -LiteralPath $finale)).Count - 1
        $pcv.Esito = if($rcC -eq 0){ "OK" } else { "CON PROBLEMI (rc " + $rcC + ")" }
        $pcv.Nota  = "" + $tot + " barre M1"
        if($rcC -ne 0){ [void]$Problemi.Add("F5: " + $simbolo + ": la conversione e' uscita con " + $rcC + " (banda di prezzo? fuso EST fisso? zip rotti?). LEGGI " + $logc + ": il CSV c'e' ma il verdetto NON e' pulito.") }
      } else {
        $pcv.Esito = "NESSUN CSV DI ADESSO"
        [void]$Problemi.Add("F5: " + $simbolo + ": la conversione non ha scritto un CSV adesso (rc " + $rcC + "). Guarda " + $logc)
        ScriviStato
        continue
      }
      ScriviStato
    } else {
      # concatenazione dei pezzi IN ORDINE DI ANNO, una intestazione sola
      Remove-Item -LiteralPath $finale -Force -ErrorAction SilentlyContinue
      $sw = New-Object System.IO.StreamWriter($finale,$false,[System.Text.Encoding]::ASCII)
      $intestazioneScritta = $false
      foreach($anno in ($fattiAnni | Sort-Object)){
        $pezzo = Join-Path $CartAnni ($simbolo + "_M1_" + $anno + ".csv")
        if(-not (Test-Path -LiteralPath $pezzo)){ continue }
        $sr = New-Object System.IO.StreamReader($pezzo)
        while(($l = $sr.ReadLine()) -ne $null){
          if($l.StartsWith("Time,")){
            if(-not $intestazioneScritta){ $sw.WriteLine($l); $intestazioneScritta = $true }
            continue
          }
          if($l.Length -lt 10){ continue }
          $sw.WriteLine($l); $tot++
        }
        $sr.Close()
      }
      $sw.Close()
    }

    $sd.Barre = $tot
    $sd.Anni  = (($fattiAnni | Sort-Object) -join " ")
    $sd.Fase  = "SCARICATO (" + $fattiAnni.Count + " anni su " + ($AnnoA - $AnnoDa + 1) + ")"
    $CsvFinali += $finale
    Write-Host ("   " + $simbolo + ": " + $tot + " barre M1 -> " + $finale) -ForegroundColor Green

    # anteprima da mandare: solo testa e coda. Il CSV intero e' decine di
    # MB e nello zip non ci deve andare.
    try{
      $testa = @(Get-Content -LiteralPath $finale -TotalCount 6)
      $coda  = @(Get-Content -LiteralPath $finale -Tail 3)
      Set-Content -LiteralPath (Join-Path $CartDat ($simbolo + "_M1_ANTEPRIMA.txt")) -Encoding ASCII -Value `
        (@("file: " + $finale, "barre M1: " + $tot, "anni scaricati: " + $sd.Anni, "", "--- prime righe ---") + $testa + @("", "--- ultime righe ---") + $coda)
    }catch{ [void]$Note.Add("F5: anteprima di " + $simbolo + " non scritta (" + $_.Exception.Message + ")") }

    $mancanti = @($AnnoDa..$AnnoA | Where-Object { $fattiAnni -notcontains $_ })
    if($mancanti.Count -gt 0){
      [void]$Problemi.Add("F5: " + $simbolo + ": " + $fattiAnni.Count + " anni su " + ($AnnoA - $AnnoDa + 1) +
                          ". GLI ANNI MANCANTI SONO QUESTI, dichiarati: " + ($mancanti -join " "))
    }
  }
}

# =====================================================================
#  F6. PREPARA L'IMPORT
#  I preset si generano DAL SORGENTE dello script MQL5: cosi' non puo'
#  mancarci un input. Un input che il .set non nomina NON torna al suo
#  default: resta l'ultimo valore usato a mano, che MT5 si ricorda
#  (checklist 25, pagata con tre import che non hanno importato niente).
# =====================================================================
if($Prepara -and $CsvFinali.Count -gt 0 -and -not $SoloControllo){
  Titolo "F6 - PREPARA L'IMPORT (CSV in MQL5\Files + preset generati dal sorgente)"
  $pp6 = NuovoPasso "F6" "prepara import"
  $pp6.Inizio = (Ora)

  # --- il terminale PER NOME, mai Select-Object -First 1 alla cieca
  $tutti = @(Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue)
  $cand  = @($tutti | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*" })
  if($cand.Count -ne 1){ throw ("terminale BCM: trovati " + $cand.Count + " candidati invece di 1. Non tiro a indovinare.") }
  $InstDir    = $cand[0].DirectoryName
  $Terminal   = Join-Path $InstDir "terminal64.exe"
  $MetaEditor = Join-Path $InstDir "metaeditor64.exe"
  $termRoot   = Join-Path $env:APPDATA "MetaQuotes\Terminal"
  $DataFolder = Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue | Where-Object {
      $o = Join-Path $_.FullName "origin.txt"
      (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $InstDir)
    } | Select-Object -First 1 -ExpandProperty FullName
  if(-not $DataFolder){ throw "cartella dati MT5 non trovata (origin.txt non punta a nessuna cartella)." }
  $MqlFiles = Join-Path $DataFolder "MQL5\Files"
  $MqlScr   = Join-Path $DataFolder "MQL5\Scripts"
  $MqlPre   = Join-Path $DataFolder "MQL5\Presets"
  New-Item -ItemType Directory -Force -Path $MqlFiles,$MqlScr,$MqlPre | Out-Null
  Dico ("terminale : " + $Terminal)
  Dico ("dati      : " + $DataFolder)

  # --- lo script d'import al pin (la v1: e' quella promossa; la cura
  #     DST della v2 e' stata MISURATA e peggiora, par. 15)
  $srcImp = Join-Path $Strum "ABTG_ImportaStoricoEsterno.mq5"
  Scarica ("$RawPin/mql5/Scripts/ABTG_ImportaStoricoEsterno.mq5") $srcImp 'InpSimboloNuovo'
  Copy-Item -LiteralPath $srcImp -Destination (Join-Path $MqlScr "ABTG_ImportaStoricoEsterno.mq5") -Force

  # --- TUTTI gli input del sorgente, coi loro default
  $inputs = New-Object System.Collections.Specialized.OrderedDictionary
  foreach($riga in (Get-Content -LiteralPath $srcImp)){
    $m = [regex]::Match($riga,'^\s*input\s+\w+\s+(\w+)\s*=\s*([^;]+);')
    if($m.Success){
      $v = $m.Groups[2].Value.Trim().Trim('"')
      $inputs[$m.Groups[1].Value] = $v
    }
  }
  Write-Host ("   input trovati nel sorgente: " + $inputs.Count + " (il preset li nomina TUTTI)") -ForegroundColor Gray

  foreach($f in $CsvFinali){
    $simbolo = [IO.Path]::GetFileNameWithoutExtension($f) -replace "_M1$",""
    Copy-Item -LiteralPath $f -Destination $MqlFiles -Force
    $vals = @{}
    foreach($k in $inputs.Keys){ $vals[$k] = $inputs[$k] }
    $vals["InpSimboloSorgente"]   = $simbolo
    $vals["InpSimboloNuovo"]      = $simbolo + "_EXT"
    $vals["InpFileCsv"]           = (Split-Path -Leaf $f)
    $vals["InpFormato"]           = "1"
    $vals["InpShiftOre"]          = "0"
    $vals["InpAutoShift"]         = "true"
    $vals["InpShiftMax"]          = "6"
    $vals["InpCancellaEsistente"] = "true"
    if($vals.ContainsKey("InpAutoTest")){ $vals["InpAutoTest"] = "false" }
    $setName = "abtg_import_" + $simbolo + "_EXT.set"
    $righe = @()
    foreach($k in $inputs.Keys){ $righe += ($k + "=" + $vals[$k]) }
    Set-Content -LiteralPath (Join-Path $MqlPre $setName) -Value $righe -Encoding ASCII
    $Presets += ,@($simbolo,$setName)
    Write-Host ("   " + $simbolo + " -> MQL5\Files\" + (Split-Path -Leaf $f) + "  +  MQL5\Presets\" + $setName) -ForegroundColor Green
  }
  $pp6.Fine = (Ora); $pp6.Esito = "OK"; $pp6.Nota = "" + $Presets.Count + " preset"
  ScriviStato
}

# =====================================================================
#  F7. L'IMPORT VERO
# =====================================================================
if($Importa -and $Presets.Count -gt 0 -and -not $SoloControllo){
  Titolo "F7 - IMPORT IN MT5"
  $refImp = Join-Path $DataFolder "MQL5\Files\ABTG_ImportEsterno_referto.csv"
  Remove-Item -LiteralPath $refImp -Force -ErrorAction SilentlyContinue   # cosi' so che il referto e' NUOVO

  # compilazione: .ex5 SCRITTO ADESSO, altrimenti gira quello vecchio
  $mq5 = Join-Path $DataFolder "MQL5\Scripts\ABTG_ImportaStoricoEsterno.mq5"
  $ex5 = [IO.Path]::ChangeExtension($mq5,".ex5")
  $t0c = Get-Date
  Remove-Item -LiteralPath $ex5 -Force -ErrorAction SilentlyContinue
  & $MetaEditor "/compile:$mq5" "/log" | Out-Null
  if(-not (Test-Path -LiteralPath $ex5) -or (Get-Item -LiteralPath $ex5).LastWriteTime -lt $t0c){
    [void]$Problemi.Add("F7: ABTG_ImportaStoricoEsterno NON compilato adesso: l'import NON parte.")
  } else {
    Dico "ABTG_ImportaStoricoEsterno compilato adesso" "Green"
    foreach($p in $Presets){
      if((Trascorse) -ge $OreMax){
        [void]$Problemi.Add("F7: import di " + $p[0] + " NON INIZIATO (tetto -OreMax).")
        continue
      }
      $pi = NuovoPasso "F7" ("import " + $p[0] + "_EXT")
      $pi.Inizio = (Ora)
      $t0 = Get-Date
      $ok = LanciaScriptMT5 "ABTG_ImportaStoricoEsterno" $p[1] $p[0] $refImp 60
      $pi.Fine = (Ora); $pi.Min = [Math]::Round((New-TimeSpan -Start $t0 -End (Get-Date)).TotalMinutes,1)
      if($ok){
        $pi.Esito = "OK"
        $sd = Sede $p[0]; if($sd){ $sd.Fase = "IMPORTATO come " + $p[0] + "_EXT" }
      } else {
        $pi.Esito = "NESSUN REFERTO DI ADESSO"
        [void]$Problemi.Add("F7: " + $p[0] + ": l'import non ha scritto un referto adesso. Di solito e' il CSV che non e' in MQL5\Files.")
      }
      ScriviStato
    }
    if(Test-Path -LiteralPath $refImp){
      Copy-Item -LiteralPath $refImp -Destination (Join-Path $CartDat "ABTG_ImportEsterno_referto.csv") -Force
    }
  }
}

# =====================================================================
#  F8. LA VERIFICA: prima e ultima barra M15 e H1 + BARRE PER ANNO
#  Un anno vuoto in mezzo viene DICHIARATO. E' la domanda che il
#  referto dello scarico non puo' rispondere: li' contano le righe del
#  CSV, qui contano le barre che MT5 ha davvero costruito.
# =====================================================================
$RigheVerifica = @()
if($Verifica -and -not $SoloControllo){
  Titolo "F8 - VERIFICA DEI SIMBOLI _EXT (M15 e H1, barre per anno)"
  $pv = NuovoPasso "F8" "conta barre _EXT"
  $pv.Inizio = (Ora)
  try{
    if(-not $DataFolder){
      $tutti = @(Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue)
      $cand  = @($tutti | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*" })
      if($cand.Count -ne 1){ throw ("terminale BCM: " + $cand.Count + " candidati invece di 1.") }
      $InstDir  = $cand[0].DirectoryName
      $Terminal = Join-Path $InstDir "terminal64.exe"
      $MetaEditor = Join-Path $InstDir "metaeditor64.exe"
      $termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
      $DataFolder = Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue | Where-Object {
          $o = Join-Path $_.FullName "origin.txt"
          (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $InstDir)
        } | Select-Object -First 1 -ExpandProperty FullName
      if(-not $DataFolder){ throw "cartella dati MT5 non trovata." }
    }
    $MqlScr = Join-Path $DataFolder "MQL5\Scripts"
    $MqlPre = Join-Path $DataFolder "MQL5\Presets"
    New-Item -ItemType Directory -Force -Path $MqlScr,$MqlPre | Out-Null
    $srcV = Join-Path $Strum "ABTG_ContaBarreEXT.mq5"
    Scarica ("$RawPin/mql5/Scripts/ABTG_ContaBarreEXT.mq5") $srcV 'CONTA-EXT-v1'
    Copy-Item -LiteralPath $srcV -Destination (Join-Path $MqlScr "ABTG_ContaBarreEXT.mq5") -Force
    $mq5v = Join-Path $MqlScr "ABTG_ContaBarreEXT.mq5"
    $ex5v = [IO.Path]::ChangeExtension($mq5v,".ex5")
    $t0c = Get-Date
    Remove-Item -LiteralPath $ex5v -Force -ErrorAction SilentlyContinue
    & $MetaEditor "/compile:$mq5v" "/log" | Out-Null
    if(-not (Test-Path -LiteralPath $ex5v) -or (Get-Item -LiteralPath $ex5v).LastWriteTime -lt $t0c){
      throw "ABTG_ContaBarreEXT NON compilato adesso (guarda il .log accanto al .mq5)."
    }
    # TUTTI i simboli chiesti, anche quelli che potrebbero non esistere:
    # e' il referto che deve dire 'NON ESISTE', non il silenzio.
    $chiesti = @($Simboli | ForEach-Object { $_ + "_EXT" })
    $setV = "abtg_conta_ext.set"
    Set-Content -LiteralPath (Join-Path $MqlPre $setV) -Encoding ASCII -Value @(
      "InpSimboli=" + ($chiesti -join ","),
      "InpTF=M15,H1",
      "InpFileCsv=ABTG_ContaBarreEXT.csv",
      "InpAttesaSec=30",
      "InpTettoAtteso=100000",
      "InpAutoTest=false")
    $csvV = Join-Path $DataFolder "MQL5\Files\ABTG_ContaBarreEXT.csv"
    Remove-Item -LiteralPath $csvV -Force -ErrorAction SilentlyContinue
    $grafico = $Simboli[0]
    $okV = LanciaScriptMT5 "ABTG_ContaBarreEXT" $setV $grafico $csvV 30
    if($okV -and (Test-Path -LiteralPath $csvV)){
      Copy-Item -LiteralPath $csvV -Destination (Join-Path $CartDat "ABTG_ContaBarreEXT.csv") -Force
      $RigheVerifica = @(Import-Csv -LiteralPath $csvV)
      $pv.Esito = "OK"; $pv.Nota = "" + $RigheVerifica.Count + " righe"
      Write-Host ""
      $RigheVerifica | Format-Table Simbolo,Timeframe,Barre,PrimaBarra,UltimaBarra,AnniVuoti,Esito -AutoSize
    } else {
      $pv.Esito = "NESSUN CSV DI ADESSO"
      [void]$Problemi.Add("F8: la verifica non ha scritto ABTG_ContaBarreEXT.csv adesso.")
    }
    # le barre per anno stanno nella scheda Esperti: si prendono i log
    foreach($l in (Get-ChildItem (Join-Path $DataFolder "MQL5\Logs") -Filter "*.log" -ErrorAction SilentlyContinue |
                   Sort-Object LastWriteTime -Descending | Select-Object -First 2)){
      Copy-Item -LiteralPath $l.FullName -Destination $CartLog -Force -ErrorAction SilentlyContinue
    }
  }catch{
    $pv.Esito = "FALLITA"
    [void]$Problemi.Add("F8: " + $_.Exception.Message)
  }
  $pv.Fine = (Ora)
  ScriviStato
}

}catch{
  Write-Host ""
  Write-Host ("!!! CORSA FERMATA: " + $_.Exception.Message) -ForegroundColor Red
  [void]$Problemi.Add("CORSA FERMATA: " + $_.Exception.Message)
}

# =====================================================================
#  PRIMA DEL REFERTO: un simbolo "IN GIRO" che non e' mai arrivato allo
#  scarico non puo' restare con una casella vuota. Una casella vuota si
#  legge come "e' andato tutto bene e non c'era niente da dire".
# =====================================================================
foreach($s in $Sedi){
  if($s.Fase -eq "IN GIRO" -and $s.Barre -lt 0){
    $s.Fase   = "NON SCARICATO"
    $s.Perche = "la fase di scarico non e' stata eseguita (criteri non firmati, canarino rosso, spazio, o tetto ore): vedi PROBLEMI"
  }
}

# =====================================================================
#  F9. IL REFERTO -- si scrive SEMPRE, anche a corsa monca
# =====================================================================
$o = New-Object System.Collections.ArrayList
[void]$o.Add("=====================================================================")
[void]$o.Add(" REFERTO -- STORICO ESTERNO DEGLI INDICI")
[void]$o.Add("=====================================================================")
[void]$o.Add("data: " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   <-- QUESTA DATA DEVE ESSERE DI ADESSO")
[void]$o.Add("avvio: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   durata: " + (N2 (Trascorse)) + " h")
[void]$o.Add("macchina: " + $env:COMPUTERNAME + "   utente: " + $env:USERNAME)
[void]$o.Add("pin: " + $Pin)
[void]$o.Add("modo: " + $(if($SoloControllo){ "GIRO A VUOTO (-SoloControllo): criteri letti al pin, nessuno scarico di dati, nessun MT5" }else{ "CORSA VERA" }))
[void]$o.Add("")
[void]$o.Add("!!! I DATI SONO DI UN ALTRO BROKER (" + $Fonte + "), NON DI BCM.")
[void]$o.Add("    Spread, orari di seduta e prezzi NON sono quelli su cui si opera.")
[void]$o.Add("    Nel tester lo spread e' quello che si imposta, non quello storico:")
[void]$o.Add("    su stop stretti puo' spostare il verdetto (R55: 1,5 punti indice).")
[void]$o.Add("")
[void]$o.Add("!!! IL CANCELLO ZERO SUGLI INDICI _EXT E' ANCORA CHIUSO.")
[void]$o.Add("    diff media H1 misurata 0,061-0,101% contro il <=0,05% richiesto")
[void]$o.Add("    (REFERTO_HISTDATA_FATTIBILITA.md par. 14-15). Questi dati si")
[void]$o.Add("    PRODUCONO e si MISURANO; NON sono autorizzati per i round.")
[void]$o.Add("")
[void]$o.Add("REGOLA D'USO (D-C): i simboli _EXT sono PROVA DI REGIME a parametri")
[void]$o.Add("CONGELATI. Qui non si tara niente e non si promuove nessuna cella.")
[void]$o.Add("")
[void]$o.Add("--- DECISIONI LETTE AL PIN ---")
foreach($k in ($Dec.Keys | Sort-Object)){
  $d = $Dec[$k]
  [void]$o.Add(("  {0,-5} {1,-22} {2,-24} {3}" -f $d.Id,$d.Chiave,$d.Valore,$d.Stato))
}
[void]$o.Add("")
[void]$o.Add("--- I CINQUE INDICI: NESSUNO SPARISCE DA QUESTO ELENCO ---")
[void]$o.Add(("  {0,-8} {1,-12} {2,-34} {3}" -f "BCM","CHE","FASE","BARRE / PERCHE'"))
foreach($s in $Sedi){
  $coda = if($s.Barre -ge 0){ "" + $s.Barre + " righe M1, anni: " + $s.Anni } else { $s.Perche }
  [void]$o.Add(("  {0,-8} {1,-12} {2,-34} {3}" -f $s.Bcm,$s.Che,$s.Fase,$coda))
}
[void]$o.Add("")
[void]$o.Add("--- CANARINO DI RITMO ---")
[void]$o.Add("  " + $Canarino + $(if($Proiezione -ge 0){ "   (proiezione " + (N1 $Proiezione) + " ore, soglia " + (N1 $SogliaOre) + ")" }else{ "" }))
if($RigheVerifica.Count -gt 0){
  [void]$o.Add("")
  [void]$o.Add("--- VERIFICA DEI SIMBOLI _EXT (barre per anno: scheda Esperti nei log) ---")
  [void]$o.Add(("  {0,-14} {1,-12} {2,10} {3,-18} {4,-18} {5}" -f "SIMBOLO","TF","BARRE","PRIMA","ULTIMA","ANNI VUOTI / ESITO"))
  foreach($r in $RigheVerifica){
    [void]$o.Add(("  {0,-14} {1,-12} {2,10} {3,-18} {4,-18} {5}" -f $r.Simbolo,$r.Timeframe,$r.Barre,$r.PrimaBarra,$r.UltimaBarra,($r.AnniVuoti + " / " + $r.Esito)))
  }
}
[void]$o.Add("")
[void]$o.Add("--- PASSI ---")
[void]$o.Add(("  {0,-5} {1,-40} {2,-9} {3,-9} {4,-7} {5}" -f "FASE","PASSO","INIZIO","FINE","MIN","ESITO"))
foreach($p in $Passi){
  [void]$o.Add(("  {0,-5} {1,-40} {2,-9} {3,-9} {4,-7} {5}" -f $p.Fase,$p.Nome,$p.Inizio,$p.Fine,(N1 $p.Min),($p.Esito + $(if($p.Nota -ne ""){ "  -- " + $p.Nota }else{ "" }))))
}
if($Note.Count -gt 0){
  [void]$o.Add("")
  [void]$o.Add("--- NOTE ---")
  foreach($n in $Note){ [void]$o.Add("  - " + $n) }
}
[void]$o.Add("")
if($Problemi.Count -gt 0){
  [void]$o.Add("--- PROBLEMI (" + $Problemi.Count + ") ---")
  foreach($p in $Problemi){ [void]$o.Add("  - " + $p) }
  [void]$o.Add("")
  [void]$o.Add("ESITO: PARZIALE -- " + $Problemi.Count + " problemi")
} else {
  [void]$o.Add("ESITO: OK")
}
# la coda "prossimo passo" si stampa SOLO se gli artefatti che quel passo
# consuma esistono davvero (checklist 22)
if($CsvFinali.Count -gt 0 -and $Presets.Count -gt 0){
  [void]$o.Add("")
  [void]$o.Add("PROSSIMO PASSO: i CSV sono in MQL5\Files e i preset in MQL5\Presets.")
  [void]$o.Add("Se l'import non e' stato fatto in automatico: in MT5, Navigatore >")
  [void]$o.Add("Script > Aggiorna, trascina ABTG_ImportaStoricoEsterno su un grafico,")
  [void]$o.Add("Carica > il preset del simbolo, e guarda la scheda ESPERTI.")
}
Set-Content -LiteralPath $Referto -Value $o -Encoding ASCII
ScriviStato

# --- raccolta: UN solo zip, in fondo, sulla cartella di sosta
$zip = Join-Path $Dsk ("STORICO_INDICI_" + $Stamp + ".zip")
try{ Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $zip -Force }catch{ }
$n = @(Get-ChildItem -LiteralPath $Cart -Recurse -File -ErrorAction SilentlyContinue).Count

Write-Host ""
Write-Host "=====================================================================" -ForegroundColor Cyan
Get-Content -LiteralPath $Referto | Select-Object -Last 40 | ForEach-Object { Write-Host $_ }
Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host ("RACCOLTA: " + $n + " file in " + $Cart) -ForegroundColor Green
Write-Host ("ZIP PRONTO DA MANDARE: " + $zip) -ForegroundColor Green
Write-Host "Verifica che dentro ci siano, per nome:" -ForegroundColor DarkGray
Write-Host "   - REFERTO_STORICO_INDICI.txt        (la riga 'data:' deve essere di ADESSO)" -ForegroundColor DarkGray
Write-Host "   - STORICO_INDICI_CRITERI.md         (i criteri al pin, come li ha letti la corsa)" -ForegroundColor DarkGray
Write-Host "   - dati\*_M1_ANTEPRIMA.txt           (prime e ultime righe di ogni CSV prodotto)" -ForegroundColor DarkGray
if($Importa){ Write-Host "   - dati\ABTG_ImportEsterno_referto.csv (shift, copertura, verdetto)" -ForegroundColor DarkGray }
if($Verifica){ Write-Host "   - dati\ABTG_ContaBarreEXT.csv        (prima/ultima barra M15 e H1)" -ForegroundColor DarkGray }
Write-Host "   - log\*.txt e log\*.log             (console degli strumenti e log MT5)" -ForegroundColor DarkGray
Write-Host ""
if($Problemi.Count -gt 0){
  Write-Host ("ESITO: PARZIALE -- " + $Problemi.Count + " problemi. Sono nel referto, uno per riga.") -ForegroundColor Yellow
  exit 3
}
Write-Host "ESITO: OK" -ForegroundColor Green
exit 0
