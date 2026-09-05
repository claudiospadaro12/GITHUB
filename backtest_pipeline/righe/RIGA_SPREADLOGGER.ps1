# =====================================================================
#  MARCATORE_RIGA_SPREADLOGGER_v1
#  RIGA_SPREADLOGGER.ps1 -- INSTALLA E COMPILA ABTG_SpreadLogger.mq5
#  (logger dello spread vivo, SOLA LETTURA) sul SOLO terminale del
#  conto PICCOLO 50503392, sul VPS.
#
#  PERCHE' ESISTE: il "RealCost Spread P95 Logger" (Code Base 74148) e'
#  stato promosso il 23/08 (report/SWEEP_MECCANISMI_2026-08-23.md, voce
#  T1) e MAI USATO -- la caccia M15 del 05/09 lo ricita come "la settima
#  volta che lo scrivo". Tutta la tabella dei costi dei round poggia su
#  spread di CONVENZIONE; la sola misura vera che abbiamo (03/09,
#  risultati_archivio/SPREAD_FLOTTA_MISURA_2026-09-03.md) viene dai TICK
#  STORICI di tre indici, non dall'osservazione dal vivo e non copre il
#  forex. Questa riga mette in campo l'osservatore.
#
#  >>> COSA INSTALLA, E DOVE (solo in modo CORSA, e SOLO li'):
#        <cartella dati del PICCOLO>\MQL5\Experts\ABTG_SpreadLogger.mq5
#        <cartella dati del PICCOLO>\MQL5\Experts\ABTG_SpreadLogger.ex5
#      NIENT'ALTRO: nessun .set, nessun .ini, nessun .chr, nessun
#      profilo, nessun grafico. L'EA NON viene attaccato a niente: lo
#      attacca Claudio a mano, su un grafico NUOVO (vedi la pagina).
#      Che i parametri non siano stati toccati lo DIMOSTRA una foto:
#      conteggio, byte e ultima scrittura di Presets\, Profiles\Charts\
#      e config\ prima e dopo.
#
#  >>> IL 100k / -V3 (conto 50504263) NON SI TOCCA: e' in Fase 1 della
#      migrazione, e "resta intatto fino a fine Fase 1" (HANDOFF 03/09).
#      Questa riga non ha nessun percorso di scrittura fuori dalla
#      cartella scelta, e delle cartelle con traccia del 100k fotografa
#      quello che la sessione riesce davvero a leggere. Se non c'e'
#      nemmeno un file vero da fotografare il referto scrive
#      NON MISURATO, non INVARIATO (classe 117).
#
#  >>> PERCHE' IL PICCOLO E NON IL 100k, dichiarato:
#      1. e' un conto DEMO;
#      2. e' lo STESSO FEED BCM su cui lavora la flotta: lo spread che
#         misura e' quello che paghiamo davvero;
#      3. il 100k e' in Fase 1 e non si tocca;
#      4. i sette simboli sono gia' nel suo Market Watch (la flotta ci
#         opera), quindi il logger non deve aggiungere niente.
#
#  >>> MT5 PUO' RESTARE APERTO, ED E' VOLUTO (stessa scelta gia' pagata
#      dalla RIGA_CHIUDISEDIE del 24/08). Il divieto del punto 7 della
#      checklist riguarda gli script che scrivono dentro config\ e nei
#      .chr, che MT5 riscrive all'uscita: questa riga non li tocca. E la
#      compilazione qui NON scarica nessun EA dai grafici, perche'
#      ABTG_SpreadLogger e' un file NUOVO che non sta su nessun grafico:
#      il motivo che nel deploy dell'ORB imponeva il terminale chiuso
#      (una posizione lasciata senza gestione) qui NON esiste.
#      METAEDITOR invece si PRETENDE CHIUSO: e' single-instance e con
#      l'editor aperto la compilazione da riga di comando torna muta
#      (misurato il 22/08).
#
#  >>> IN MODO CONTROLLO (default) NON SCRIVE NIENTE NEL TERMINALE:
#      scarica al pin, passa i gate sul sorgente, sceglie la cartella
#      dati, fotografa e si ferma PRIMA del backup. Serve a vedere che
#      cosa farebbe la CORSA, con l'elenco delle cartelle guardate.
#
#  >>> LA CARTELLA DATI SI SCEGLIE PER FATTI, MAI PER NOME (classe 115):
#      1. ha bases\BCMMarkets-Server (e' il feed del broker giusto);
#      2. NESSUNA traccia del 100k (ne' "-V3" nell'origin.txt o nel
#         percorso, ne' il login 50504263 nei log degli ultimi 45 gg);
#      3. sta sotto il profilo della sessione che lancia (%APPDATA%);
#      4. il login 50503392 nei log e' la CONFERMA (se manca e' un
#         rilievo dichiarato, non un blocco).
#      Se le candidate automatiche sono ZERO o PIU' DI UNA la riga si
#      ferma e stampa l'elenco completo, con la manopola -CartellaDati.
#      La manopola NON salta i controlli.
#
#  >>> I GATE SUL SORGENTE (l'identita' dell'artefatto, prima di
#      installarlo): marcatore, #property version, i due #define
#      dell'autotest, e soprattutto il CENSIMENTO DEI TOKEN VIETATI --
#      invio/modifica/chiusura di ordini, classi di trading, variabili
#      globali del terminale, traffico esterno, import di DLL. Il
#      censimento gira sulle RIGHE DI CODICE (parte dopo // tolta) e
#      pretende ZERO. Si controlla anche che nel file non ci siano
#      commenti a blocco, perche' quelli il censimento non li toglie e
#      potrebbero nascondere una riga viva (e nascondere un token in un
#      commento renderebbe il gate rosso per sempre: classe 126).
#
#  >>> IL VERDETTO STA SULL'ARTEFATTO, NON SUL CODICE DI USCITA (classe
#      108): metaeditor64 sul VPS torna 1 anche quando compila. Decidono
#      l'.ex5 FRESCO e la riga "Result: N errors, M warnings" del log.
#      Il campo compilazione ha QUATTRO STATI (classe 94-ter):
#      NON TENTATA / FALLITA / FALLITA -- METAEDITOR MUTO / OK.
#
#  QUANTO CI METTE [STIMA]: scansione + 1 download + 1 compilazione =
#  1-3 minuti.
#
#  LA RIGA CHE SI INCOLLA sta in
#  righe\RIGA_SPREADLOGGER_DA_MANDARE.md
# =====================================================================
[CmdletBinding()]
param(
  # -Pin NON ha default: un default silenzioso ("lavoro") farebbe girare
  #  la punta del branch spacciandola per un commit congelato.
  [string]$Pin = "",
  [ValidateSet("CONTROLLO","CORSA")]
  [string]$Modo = "CONTROLLO",
  # -CartellaDati: si usa SOLO se la scelta automatica si ferma perche'
  #  non ha UN fatto per decidere (classe 115).
  [string]$CartellaDati = "",
  [int]$TimeoutSec = 180
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

$EA              = "ABTG_SpreadLogger"
$VersioneAttesa  = "1.00"
$MarcatoreEA     = "ABTG_SpreadLogger v1.00 - logger di SOLA LETTURA, spread P95 per ora server"
$BLOCCHI_ATTESI  = 8
$CASI_ATTESI     = 36
$CONTO_PICCOLO   = "50503392"
$CONTO_GRANDE    = "50504263"
$BASE_BCM        = "BCMMarkets-Server"
# I token che NON devono esistere nelle righe di codice del sorgente.
# Sono la definizione OPERATIVA di "sola lettura": se uno di questi
# compare, l'artefatto non e' piu' quello firmato e non si installa.
$VIETATI = @("OrderSend","OrderSendAsync","OrderModify","OrderClose","OrderDelete",
             "PositionOpen","PositionClose","PositionModify","PositionCloseBy",
             "CTrade","CPositionInfo","Trade.mqh",
             "GlobalVariableSet","GlobalVariableDel","GlobalVariableTemp","GlobalVariableGet","GlobalVariableCheck",
             "WebRequest","SendNotification","SendMail","SendFTP","#import","DllCall","TesterWithdrawal")

$Avvio = Get-Date
$Stamp = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
# IL DESKTOP SI CERCA, NON SI ASSUME (OneDrive sposta il Desktop vero).
function TrovaDesktop(){
  foreach($p in @([Environment]::GetFolderPath("Desktop"),
                  (Join-Path $env:USERPROFILE "Desktop"),
                  (Join-Path $env:USERPROFILE "OneDrive\Desktop"))){
    if($p -and (Test-Path -LiteralPath $p)){ return $p }
  }
  return $env:USERPROFILE
}
$Dsk        = TrovaDesktop
$Work       = Join-Path $env:USERPROFILE "abtg_spreadlogger"
$Scaricati  = Join-Path $Work "scaricati"
$Sentinella = Join-Path $Work "SPREADLOGGER_INSTALLA_IN_CORSO.txt"
$LogPath    = Join-Path $Work "COMPILAZIONE.log"
$RawPin     = ""

# --- tutto cio' che la raccolta usa nasce QUI, PRIMA del try: la
#     raccolta gira SEMPRE, e ogni campo parte da uno stato VERO ("non ci
#     siamo arrivati"), mai da uno stato che somigli a un risultato
#     (classe 125: una variabile nata dentro il try uccide la raccolta).
$Problemi   = New-Object System.Collections.ArrayList
$Rilievi    = New-Object System.Collections.ArrayList
$Cand       = New-Object System.Collections.ArrayList
$righeC     = New-Object System.Collections.ArrayList
[void]$righeC.Add("CARTELLE GUARDATE: nessuna scansione (il giro si e' fermato prima di cercare la cartella dati)")
$Fatale     = ""
$Compilato  = "NON TENTATA (non ci siamo arrivati)"
$InstallTxt = "NON AVVENUTA (il giro si e' fermato prima di scrivere nel terminale)"
$BackupTxt  = "NON FATTO (non ci siamo arrivati)"
$Ripristino = "niente da ripristinare (il terminale non e' mai stato scritto)"
$Scelta     = "NON SCELTA"
$Criterio   = "n/d"
$Inst       = "n/d"
$Me         = ""
$SorgTxt    = "NON SCARICATO"
$VersLetta  = "NON LETTA"
$DefineTxt  = "NON LETTI"
$VietatiTxt = "NON ESEGUITO"
$AsciiTxt   = "NON VERIFICATO"
$ResultTxt  = "NON LETTA"
$RcTxt      = "NON LETTO"
$V3Txt      = "NON VERIFICATO (non ci siamo arrivati)"
$ParamTxt   = "NON VERIFICATO (non ci siamo arrivati)"
$FilesTxt   = "NON VERIFICATA"
$GiaLi      = "NON VERIFICATO"
$ScrittoNelTerminale = $false
$BackupDir  = ""
$Piccolo    = $null
$V3Cand     = @()
$Due        = @()
$FotoP      = @{}
$FotoV3     = New-Object System.Collections.ArrayList
$FotoDopo   = New-Object System.Collections.ArrayList
$DirParam   = @()
$FotoDirP   = @{}
$LogRighe   = @()
$DestMq5    = ""
$DestEx5    = ""
# FotoPrese: dice se le foto PRIMA sono state davvero scattate. Senza
# questa bandiera, un giro fermato prima del punto 4 arriverebbe alla
# raccolta con zero cartelle da confrontare e scriverebbe "INVARIATI"
# avendo guardato il vuoto -- e' la classe 117, la stessa che ha fatto
# ri-pinnare il deploy dell'ORB.
$FotoPrese  = $false

function Ora(){ return (Get-Date).ToString("HH:mm:ss", $INV) }
function Dico([string]$t,[string]$c="Gray"){ Write-Host ("[" + (Ora) + "] " + $t) -ForegroundColor $c }
function Titolo([string]$t){ Write-Host ""; Write-Host ("=== " + $t + " ===") -ForegroundColor Cyan }

function Scarica([string]$url,[string]$dest){
  Remove-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue
  try{
    Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing -ErrorAction Stop
  }
  catch{
    throw ("SCARICO FALLITO da " + $url + " -- " + $_.Exception.Message +
           " | se e' un 404 su un pin appena creato: la cache di raw.githubusercontent dura qualche minuto, si aspetta e si rilancia LA STESSA riga (il pin non si cambia).")
  }
  if(-not (Test-Path -LiteralPath $dest)){ throw ("SCARICO FALLITO (nessun file scritto): " + $url) }
  if((Get-Item -LiteralPath $dest).Length -le 0){ throw ("SCARICO FALLITO (file vuoto): " + $url) }
}

function Hash16([string]$path){
  try{ return (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash.Substring(0,16) }catch{ return "n/d" }
}
function HashPieno([string]$path){
  try{ return (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash }catch{ return "" }
}
function Descrivi([string]$path){
  if(-not (Test-Path -LiteralPath $path)){ return "ASSENTE" }
  $i = Get-Item -LiteralPath $path
  return ("" + $i.Length + " byte, sha256 " + (Hash16 $path) + ", " + $i.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss",$INV))
}
# FOTO di un file: e' la prova. Si prende PRIMA e si RIFA' DOPO.
function Foto([string]$path){
  if([string]::IsNullOrEmpty($path)){ return [pscustomobject]@{ Esiste=$false; Len=-1; Ora="ASSENTE"; Hash="" } }
  if(-not (Test-Path -LiteralPath $path)){ return [pscustomobject]@{ Esiste=$false; Len=-1; Ora="ASSENTE"; Hash="" } }
  $i = Get-Item -LiteralPath $path
  return [pscustomobject]@{ Esiste=$true; Len=$i.Length; Ora=$i.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss",$INV); Hash=(Hash16 $path) }
}
function FotoTxt($f){
  if($null -eq $f){ return "NON PRESA" }
  if(-not $f.Esiste){ return "ASSENTE" }
  return ("presente, " + $f.Len + " byte, sha256 " + $f.Hash + ", " + $f.Ora)
}
function Confronta($a,$b){
  if($null -eq $a -or $null -eq $b){ return "NON CONFRONTABILE" }
  if($a.Esiste -ne $b.Esiste -or $a.Len -ne $b.Len -or $a.Hash -ne $b.Hash){ return "CAMBIATO" }
  if($a.Ora -ne $b.Ora){ return "stessi byte, data diversa" }
  return "INVARIATO"
}
function FotoDir([string]$path){
  if(-not (Test-Path -LiteralPath $path)){ return "ASSENTE" }
  $f = @(Get-ChildItem -LiteralPath $path -Recurse -File -ErrorAction SilentlyContinue)
  $tot = 0
  $ult = "-"
  $max = $null
  foreach($x in $f){ $tot = $tot + $x.Length; if($null -eq $max -or $x.LastWriteTime -gt $max){ $max = $x.LastWriteTime } }
  if($null -ne $max){ $ult = $max.ToString("yyyy-MM-dd HH:mm:ss",$INV) }
  return ("" + $f.Count + " file, " + $tot + " byte, ultima scrittura " + $ult)
}
# Legge un file di testo qualunque sia la codifica (i log di MetaEditor
# sono UTF-16LE col BOM).
function LeggiTesto([string]$path){
  if(-not (Test-Path -LiteralPath $path)){ return @() }
  $b = [System.IO.File]::ReadAllBytes($path)
  if($b.Length -eq 0){ return @() }
  $txt = ""
  if($b.Length -ge 2 -and $b[0] -eq 255 -and $b[1] -eq 254){
    $txt = [System.Text.Encoding]::Unicode.GetString($b,2,$b.Length-2)
  }
  elseif($b.Length -ge 2 -and $b[0] -eq 254 -and $b[1] -eq 255){
    $txt = [System.Text.Encoding]::BigEndianUnicode.GetString($b,2,$b.Length-2)
  }
  elseif($b.Length -ge 3 -and $b[0] -eq 239 -and $b[1] -eq 187 -and $b[2] -eq 191){
    $txt = [System.Text.Encoding]::UTF8.GetString($b,3,$b.Length-3)
  }
  else{
    $zeri = 0
    $fin = [math]::Min($b.Length,400)
    for($i=1; $i -lt $fin; $i=$i+2){ if($b[$i] -eq 0){ $zeri++ } }
    if($zeri -gt ($fin/4)){ $txt = [System.Text.Encoding]::Unicode.GetString($b) }
    else{ $txt = [System.Text.Encoding]::UTF8.GetString($b) }
  }
  return @($txt -split "`r`n|`n|`r")
}

# UNA CANDIDATA = una cartella che potrebbe essere una cartella dati MT5.
function AggiungiCandidata([string]$percorso,[string]$origine){
  if([string]::IsNullOrEmpty($percorso)){ return }
  $full = $percorso
  try{
    if(-not (Test-Path -LiteralPath $percorso)){ return }
    $full = (Get-Item -LiteralPath $percorso -ErrorAction Stop).FullName
  }catch{ return }
  $full = $full.TrimEnd("\")
  foreach($c in $Cand){ if($c.Percorso -ieq $full){ $c.Origine = $c.Origine + " + " + $origine; return } }
  $lg  = (Test-Path -LiteralPath (Join-Path $full "logs"))
  $mq  = (Test-Path -LiteralPath (Join-Path $full "MQL5"))
  $exe = (Test-Path -LiteralPath (Join-Path $full "terminal64.exe"))
  $me  = (Test-Path -LiteralPath (Join-Path $full "metaeditor64.exe"))
  if(-not $lg -and -not $mq -and -not $exe -and -not $me){ return }
  [void]$Cand.Add([pscustomobject]@{
    Percorso=$full; Origine=$origine; HaExe=$exe; HaMe=$me; HaLogs=$lg; HaMql=$mq
    Origin=""; BaseBcm=$false; Logins=""; FileLog=0; VistoPiccolo=$false; VistoGrande=$false
    TracciaV3=""; Eleggibile=$false; Profilo=$false; Scarto=""; Leggibile=$true
  })
}

# UNA COMPILAZIONE. Torna @{ Ex5=bool; Rc=<oggetto>; Log=<righe>; Muto=bool }
function Compila([string]$exe,[string[]]$argomenti,[string]$ex5,[string]$log,[int]$tetto){
  Remove-Item -LiteralPath $log -Force -ErrorAction SilentlyContinue
  $t0 = Get-Date
  Dico ("metaeditor64: " + $exe + " " + ($argomenti -join " ")) "Yellow"
  $global:LASTEXITCODE = $null
  # il campo si timbra PRIMA del lancio (classe 94-ter): se l'invocazione
  # stessa esplode, il referto non deve dire "non tentata".
  $script:Compilato = "FALLITA -- METAEDITOR NON PARTITO (eccezione al lancio di " + $exe + ": vedi la riga FERMATO)"
  # INVOCAZIONE DIRETTA: e' PowerShell a quotare ogni argomento (i path
  # hanno gli spazi di "Program Files").
  & $exe @argomenti | Out-Null
  $grezzo = $LASTEXITCODE
  $fresco = $false
  $muto   = $false
  $battito = 0
  while($true){
    if((Test-Path -LiteralPath $ex5) -and ((Get-Item -LiteralPath $ex5).LastWriteTime -ge $t0)){ $fresco = $true; break }
    $r = LeggiTesto $log
    $cLog = @($r).Count
    if($cLog -gt 0 -and (@($r) -match 'Result:').Count -gt 0){ break }
    $sec = (New-TimeSpan -Start $t0 -End (Get-Date)).TotalSeconds
    if($cLog -eq 0 -and $sec -ge 20){ $muto = $true; break }
    if($sec -ge $tetto){ break }
    if($sec -ge ($battito + 10)){ $battito = [int]$sec; Dico ("   ... aspetto l'.ex5 da " + $battito + "s (tetto " + $tetto + "s): NON interrompere, la riga si ferma da sola") }
    Start-Sleep -Seconds 2
  }
  if((Test-Path -LiteralPath $ex5) -and ((Get-Item -LiteralPath $ex5).LastWriteTime -ge $t0)){ $fresco = $true }
  return @{ Ex5=$fresco; Rc=$grezzo; Log=(LeggiTesto $log); Avvio=$t0; Muto=$muto }
}

function RipristinaDaBackup([string]$dir,[string[]]$dest){
  $esiti = New-Object System.Collections.ArrayList
  foreach($d in $dest){
    $nome = Split-Path -Leaf $d
    $b = Join-Path $dir $nome
    if(Test-Path -LiteralPath $b){
      Copy-Item -LiteralPath $b -Destination $d -Force
      if((HashPieno $b) -eq (HashPieno $d)){ [void]$esiti.Add($nome + ": rimesso dal backup (sha256 identico)") }
      else{ [void]$esiti.Add($nome + ": COPIATO MA SHA256 DIVERSO -- controllare a mano") }
    }
    else{
      Remove-Item -LiteralPath $d -Force -ErrorAction SilentlyContinue
      [void]$esiti.Add($nome + ": rimosso (prima del giro non c'era)")
    }
  }
  return @($esiti)
}

try{
  Titolo ("INSTALLA " + $EA + " v" + $VersioneAttesa + " sul SOLO PICCOLO " + $CONTO_PICCOLO + " -- modo " + $Modo)
  if($Modo -eq "CONTROLLO"){ Write-Host "MODO CONTROLLO: questo giro NON scrive niente nel terminale. Mostra cosa farebbe la CORSA." -ForegroundColor Yellow }
  else{ Write-Host "MODO CORSA: scrive DUE file nella sola cartella dati del piccolo (.mq5 + .ex5), con backup e ripristino su fallimento. Non attacca l'EA a nessun grafico." -ForegroundColor Yellow }

  # -------------------------------------------------------------------
  #  0. LE GUARDIE
  # -------------------------------------------------------------------
  if($Pin -eq ""){ throw "-Pin obbligatorio: senza, girerebbe la punta del branch spacciandola per un commit congelato." }
  if($Pin -notmatch '^[0-9a-f]{40}$'){ throw ("-Pin deve essere un commit di 40 caratteri esadecimali, ricevuto: " + $Pin) }
  $RawPin = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/" + $Pin

  $edit = @(Get-Process -Name metaeditor64 -ErrorAction SilentlyContinue)
  if($edit.Count -gt 0){
    $el = @($edit | ForEach-Object { $_.ProcessName + " pid " + $_.Id }) -join ", "
    if($Modo -eq "CORSA"){
      throw ("METAEDITOR APERTO (" + $el + "): con l'editor aperto la compilazione da riga di comando torna MUTA (misurato il 22/08). Chiudi MetaEditor e rilancia. MT5 puo' restare aperto: non ho toccato niente.")
    }
    [void]$Rilievi.Add("MetaEditor aperto durante il CONTROLLO (" + $el + "): tollerato qui, perche' questo giro non compila. La CORSA lo pretende chiuso e si ferma da sola.")
  }
  $term = @(Get-Process -Name terminal64 -ErrorAction SilentlyContinue)
  if($term.Count -gt 0){
    [void]$Rilievi.Add("MT5 APERTO (" + (@($term | ForEach-Object { "pid " + $_.Id }) -join ", ") + "): e' ATTESO e va bene. Questa riga installa un EA NUOVO che non sta su nessun grafico, quindi la compilazione non scarica nessuna sedia; e non scrive dentro config\ ne' nei .chr, che sono i file che MT5 riscrive all'uscita (checklist punto 7). La flotta continua a lavorare.")
    Dico "MT5 aperto: atteso, la flotta continua a lavorare" "Green"
  }
  else{
    [void]$Rilievi.Add("MT5 CHIUSO in questo giro: l'installazione riesce lo stesso, ma il logger comincera' a misurare solo quando riaprirai il terminale e attaccherai l'EA.")
  }
  Dico ("pin ......... " + $Pin)
  Dico ("cartella di lavoro: " + $Work)

  # -------------------------------------------------------------------
  #  1. CARTELLA DI LAVORO + SENTINELLA di un giro interrotto
  # -------------------------------------------------------------------
  Titolo "1. CARTELLA DI LAVORO e SENTINELLA"
  New-Item -ItemType Directory -Force -Path $Work | Out-Null
  if(Test-Path -LiteralPath $Scaricati){ Remove-Item -LiteralPath $Scaricati -Recurse -Force }
  New-Item -ItemType Directory -Force -Path $Scaricati | Out-Null
  Remove-Item -LiteralPath $LogPath -Force -ErrorAction SilentlyContinue
  if(Test-Path -LiteralPath $Sentinella){
    # riga 1..2: i due file di destinazione; riga 3: la cartella del backup
    $rs = @(Get-Content -LiteralPath $Sentinella -ErrorAction SilentlyContinue)
    $sDest = @()
    $sBack = ""
    if(@($rs).Count -ge 3){ $sDest = @($rs[0].Trim(), $rs[1].Trim()); $sBack = ("" + $rs[2]).Trim() }
    if($Modo -eq "CORSA" -and $sDest.Count -eq 2 -and $sBack -ne "" -and (Test-Path -LiteralPath $sBack)){
      $es = RipristinaDaBackup $sBack $sDest
      Remove-Item -LiteralPath $Sentinella -Force -ErrorAction SilentlyContinue
      [void]$Rilievi.Add("UN GIRO PRECEDENTE ERA STATO INTERROTTO fra backup e fine: i due file sono stati RIMESSI dal backup " + $sBack + " adesso, all'avvio (" + ($es -join "; ") + ").")
      Dico "sentinella di un giro interrotto: file rimessi dal backup" "Yellow"
    }
    else{
      [void]$Problemi.Add("SENTINELLA DI UN GIRO INTERROTTO trovata (" + $Sentinella + "): un giro precedente e' stato fermato a mano fra il backup e la fine. Questo giro in " + $Modo + " NON scrive nel terminale: rilancia in CORSA (rimette a posto da solo dal backup " + $sBack + ") oppure guarda a mano.")
      if($Modo -eq "CORSA"){ throw ("SENTINELLA ILLEGGIBILE o backup mancante (" + $sBack + "): non tocco il terminale finche' non e' chiaro cosa c'e' dentro.") }
    }
  }

  # -------------------------------------------------------------------
  #  2. SCARICO AL PIN + GATE DI IDENTITA' SUL SORGENTE
  # -------------------------------------------------------------------
  Titolo "2. SCARICO AL PIN E GATE SUL SORGENTE (marcatore, versione, autotest, token vietati)"
  $Mq5 = Join-Path $Scaricati ($EA + ".mq5")
  Scarica ($RawPin + "/mql5/Experts/" + $EA + ".mq5") $Mq5
  $SorgTxt = $EA + ".mq5: " + (Descrivi $Mq5)
  Dico ("scaricato " + $SorgTxt) "Green"

  $righeMq5 = LeggiTesto $Mq5
  $testoMq5 = ($righeMq5 -join "`n")
  if($testoMq5 -notmatch [regex]::Escape($MarcatoreEA)){
    throw ("MARCATORE ASSENTE nel sorgente al pin (cercato: '" + $MarcatoreEA + "'). O il pin e' vecchio (la cache di raw dura ~5 minuti), o non e' il file che credo: NON installo.")
  }
  $mv = [regex]::Match($testoMq5, '#property\s+version\s+"([^"]+)"')
  if(-not $mv.Success){ throw "nel sorgente scaricato non c'e' nessun #property version: non e' il file che credo." }
  $VersLetta = $mv.Groups[1].Value
  if($VersLetta -ne $VersioneAttesa){
    throw ("VERSIONE SBAGLIATA: il sorgente al pin e' la v" + $VersLetta + ", attesa la v" + $VersioneAttesa + ". NON installo.")
  }
  $mb = [regex]::Match($testoMq5, 'ABTG_SPREADLOG_AUTOTEST_BLOCCHI_ATTESI\s+(\d+)')
  $mc = [regex]::Match($testoMq5, 'ABTG_SPREADLOG_AUTOTEST_CASI_ATTESI\s+(\d+)')
  if(-not ($mb.Success -and $mc.Success)){ throw "nel sorgente non trovo i #define dell'autotest: non e' la v1.00 attesa." }
  $nBlocchi = [int]::Parse($mb.Groups[1].Value, $INV)
  $nCasi    = [int]::Parse($mc.Groups[1].Value, $INV)
  $DefineTxt = "" + $nBlocchi + " blocchi / " + $nCasi + " casi (dai #define del sorgente)"
  if($nBlocchi -ne $BLOCCHI_ATTESI -or $nCasi -ne $CASI_ATTESI){
    throw ("SORGENTE DIVERSO DA QUELLO FIRMATO: i #define dell'autotest dicono " + $DefineTxt + ", attesi " + $BLOCCHI_ATTESI + " blocchi / " + $CASI_ATTESI + " casi. NON installo.")
  }
  # il conteggio dei Caso( nel sorgente deve tornare col #define: un
  # numero dichiarato che nessuno conta e' una promessa, non un fatto.
  $nCasoVeri = 0
  foreach($riga in $righeMq5){
    $viva = ($riga -replace '//.*$','')
    $nCasoVeri = $nCasoVeri + ([regex]::Matches($viva, '(^|[^A-Za-z0-9_])Caso\s*\(')).Count
  }
  $nCasoVeri = $nCasoVeri - 1   # la definizione 'void Caso(' non e' una chiamata
  if($nCasoVeri -ne $CASI_ATTESI){
    throw ("I CASI DICHIARATI NON SONO QUELLI SCRITTI: il #define dice " + $CASI_ATTESI + ", nel codice ne conto " + $nCasoVeri + ". NON installo (classe 82: un numero dichiarato che nessuno conta non e' un controllo).")
  }
  # CENSIMENTO DEI TOKEN VIETATI sulle sole righe di CODICE.
  $blocchi = 0
  foreach($riga in $righeMq5){ if($riga -match '/\*' -or $riga -match '\*/'){ $blocchi++ } }
  if($blocchi -gt 0){
    throw ("IL SORGENTE USA COMMENTI A BLOCCO (" + $blocchi + " righe con /* o */): il censimento dei token vietati toglie solo la parte dopo //, quindi un commento a blocco potrebbe nascondergli una riga viva. NON installo.")
  }
  $trovati = New-Object System.Collections.ArrayList
  foreach($riga in $righeMq5){
    $viva = ($riga -replace '//.*$','')
    foreach($t in $VIETATI){
      if($viva.IndexOf($t, [System.StringComparison]::Ordinal) -ge 0){ [void]$trovati.Add($t + " -> " + $viva.Trim()) }
    }
  }
  if($trovati.Count -gt 0){
    throw ("TOKEN VIETATI NELLE RIGHE DI CODICE (" + $trovati.Count + "): " + (@($trovati) -join " | ") + ". Questo artefatto e' dichiarato di SOLA LETTURA: NON installo.")
  }
  $VietatiTxt = "0 occorrenze su " + $VIETATI.Count + " token cercati, su " + @($righeMq5).Count + " righe (commenti tolti); 0 commenti a blocco"
  # include: qui non ne deve esistere NESSUNO (l'EA e' autosufficiente).
  $inc = @()
  foreach($riga in $righeMq5){
    $viva = ($riga -replace '//.*$','')
    if($viva -match '^\s*#include'){ $inc += $viva.Trim() }
  }
  if(@($inc).Count -gt 0){
    throw ("IL SORGENTE CHIEDE DEGLI #include (" + (@($inc) -join " | ") + ") che questa riga non installa: mi fermo prima di compilare qualcosa che non ha tutti i pezzi.")
  }
  # ASCII puro: non e' un vezzo. Le lettere accentate nei sorgenti si
  # storpiano fra editor e console e i referti diventano illeggibili.
  $nonAscii = 0
  foreach($riga in $righeMq5){ foreach($ch in $riga.ToCharArray()){ if([int]$ch -gt 126){ $nonAscii++ } } }
  $AsciiTxt = "" + $nonAscii + " caratteri non-ASCII nel sorgente"
  if($nonAscii -gt 0){ [void]$Rilievi.Add("il sorgente al pin ha " + $nonAscii + " caratteri non-ASCII: non blocca la compilazione, ma va sistemato.") }
  Dico ("versione " + $VersLetta + " | autotest " + $DefineTxt + " (casi contati nel codice: " + $nCasoVeri + ") | vietati: " + $VietatiTxt) "Green"

  # -------------------------------------------------------------------
  #  3. LA CARTELLA DATI DEL PICCOLO -- scelta per FATTI (classe 115)
  # -------------------------------------------------------------------
  Titolo ("3. CARTELLA DATI DEL PICCOLO " + $CONTO_PICCOLO + " (scansione LARGA, scelta STRETTA)")
  foreach($pr in @(Get-Process -Name terminal64,metaeditor64 -ErrorAction SilentlyContinue)){
    $exe = ""
    try{ $exe = $pr.Path }catch{ $exe = "" }
    if($exe){ AggiungiCandidata (Split-Path -Parent $exe) ("processo " + $pr.ProcessName + " pid " + $pr.Id) }
  }
  $radici = New-Object System.Collections.ArrayList
  if($env:APPDATA){ [void]$radici.Add((Join-Path $env:APPDATA "MetaQuotes\Terminal")) }
  $drive = $env:SystemDrive
  if(-not $drive){ $drive = "C:" }
  try{
    foreach($u in @(Get-ChildItem -LiteralPath (Join-Path $drive "Users") -Directory -ErrorAction SilentlyContinue)){
      [void]$radici.Add((Join-Path $u.FullName "AppData\Roaming\MetaQuotes\Terminal"))
    }
  }catch{}
  foreach($rt in $radici){
    if(-not (Test-Path -LiteralPath $rt)){ continue }
    foreach($d in @(Get-ChildItem -LiteralPath $rt -Directory -ErrorAction SilentlyContinue)){
      if($d.Name -ieq "Common"){ continue }
      AggiungiCandidata $d.FullName ("cartella dati sotto " + $rt)
    }
  }
  $paroleChiave = @("MT5","BCM","MetaTrader","MetaQuotes","Terminal")
  $radiciInst = New-Object System.Collections.ArrayList
  foreach($ri in @($env:ProgramFiles, ${env:ProgramFiles(x86)}, (Join-Path $drive "Program Files"), (Join-Path $drive "Program Files (x86)"))){
    if(-not $ri){ continue }
    if(-not (Test-Path -LiteralPath $ri)){ continue }
    $giaVisto = $false
    foreach($x in $radiciInst){ if($x -ieq $ri){ $giaVisto = $true } }
    if(-not $giaVisto){ [void]$radiciInst.Add($ri) }
  }
  foreach($ri in $radiciInst){
    foreach($d1 in @(Get-ChildItem -LiteralPath $ri -Directory -ErrorAction SilentlyContinue)){
      $nome1 = $false
      foreach($k in $paroleChiave){ if($d1.Name -like ("*" + $k + "*")){ $nome1 = $true } }
      if($nome1 -or (Test-Path -LiteralPath (Join-Path $d1.FullName "terminal64.exe"))){ AggiungiCandidata $d1.FullName ("installazione in " + $ri) }
      foreach($d2 in @(Get-ChildItem -LiteralPath $d1.FullName -Directory -ErrorAction SilentlyContinue)){
        $int2 = (Test-Path -LiteralPath (Join-Path $d2.FullName "terminal64.exe"))
        if(-not $int2){ foreach($k in $paroleChiave){ if($d2.Name -like ("*" + $k + "*")){ $int2 = $true } } }
        if($int2){ AggiungiCandidata $d2.FullName ("installazione in " + $d1.FullName) }
      }
    }
  }
  if($CartellaDati -ne ""){ AggiungiCandidata $CartellaDati "IMPOSTA A MANO con -CartellaDati" }

  $limite = (Get-Date).AddDays(-45)
  foreach($c in $Cand){
    $o = Join-Path $c.Percorso "origin.txt"
    if(Test-Path -LiteralPath $o){
      try{ $c.Origin = ([string](Get-Content -LiteralPath $o -Raw -ErrorAction Stop)).Trim() }catch{ $c.Origin = ""; $c.Leggibile = $false }
    }
    $c.BaseBcm = (Test-Path -LiteralPath (Join-Path $c.Percorso ("bases\" + $BASE_BCM)))
    $loginSet = @{}
    foreach($sub in @("logs","MQL5\Logs")){
      $dir = Join-Path $c.Percorso $sub
      if(-not (Test-Path -LiteralPath $dir)){ continue }
      $files = @()
      try{
        $files = @(Get-ChildItem -LiteralPath $dir -Filter "*.log" -File -ErrorAction Stop |
                   Where-Object { $_.LastWriteTime -ge $limite -and $_.Length -lt 60000000 } |
                   Sort-Object LastWriteTime -Descending | Select-Object -First 12)
      }catch{ $c.Leggibile = $false }
      $c.FileLog = $c.FileLog + $files.Count
      foreach($f in $files){
        $righe = @()
        try{ $righe = LeggiTesto $f.FullName }catch{ $c.Leggibile = $false; continue }
        $txt = ($righe -join "`n")
        if($txt.IndexOf("'" + $CONTO_PICCOLO + "'") -ge 0){ $c.VistoPiccolo = $true }
        if($txt.IndexOf("'" + $CONTO_GRANDE + "'") -ge 0){ $c.VistoGrande = $true }
        foreach($m in [regex]::Matches($txt, "'(\d{5,})': (?:login|authorized) on")){ $loginSet[$m.Groups[1].Value] = 1 }
      }
    }
    if($loginSet.Keys.Count -gt 0){ $c.Logins = (@($loginSet.Keys | Sort-Object) -join ",") }
    $tr = New-Object System.Collections.ArrayList
    if($c.Origin -like "*-V3*"){ [void]$tr.Add("origin.txt contiene -V3") }
    if($c.Percorso -like "*-V3*"){ [void]$tr.Add("percorso contiene -V3") }
    if($c.VistoGrande){ [void]$tr.Add("login " + $CONTO_GRANDE + " nei log") }
    $c.TracciaV3 = (@($tr) -join "; ")
    if($env:APPDATA){ $c.Profilo = $c.Percorso.StartsWith(($env:APPDATA.TrimEnd("\")), [System.StringComparison]::OrdinalIgnoreCase) }
    if(-not $c.HaMql){ $c.Scarto = "nessuna cartella MQL5\ (installazione non portable: i dati stanno altrove)"; continue }
    if(-not $c.BaseBcm){ $c.Scarto = "nessuna bases\" + $BASE_BCM + " (non e' il feed BCM)"; continue }
    if($c.TracciaV3 -ne ""){ $c.Scarto = "E' IL 100k/-V3 (" + $c.TracciaV3 + "): fuori dal perimetro (Fase 1)"; continue }
    $c.Eleggibile = $true
    if(-not $c.Profilo){ $c.Scarto = "eleggibile per i fatti, ma sotto un ALTRO profilo utente (questa sessione e' " + $env:USERNAME + "): non scelta da sola. Se e' davvero il piccolo, imponila con -CartellaDati" }
  }

  $righeC.Clear()
  [void]$righeC.Add("CARTELLE GUARDATE (conto cercato " + $CONTO_PICCOLO + ", candidate " + $Cand.Count + "):")
  foreach($c in $Cand){
    $tag = "scartata"
    if($c.Eleggibile -and $c.Profilo){ $tag = "ELEGGIBILE, sotto il profilo di questa sessione" }
    elseif($c.Eleggibile){ $tag = "eleggibile per i fatti, ma sotto un ALTRO profilo" }
    [void]$righeC.Add("  --- " + $c.Percorso + "   [" + $tag + "]")
    [void]$righeC.Add("      trovata come: " + $c.Origine)
    [void]$righeC.Add("      terminal64.exe=" + $c.HaExe + " metaeditor64.exe=" + $c.HaMe + " logs\=" + $c.HaLogs + " MQL5\=" + $c.HaMql + " bases\" + $BASE_BCM + "=" + $c.BaseBcm + " file di log letti=" + $c.FileLog + " leggibile=" + $c.Leggibile)
    if($c.Origin -ne ""){ [void]$righeC.Add("      origin.txt: " + $c.Origin) }
    $lg = "nessuno"
    if($c.Logins -ne ""){ $lg = $c.Logins }
    [void]$righeC.Add("      login visti nei log: " + $lg + "   piccolo " + $CONTO_PICCOLO + "=" + $c.VistoPiccolo + "   grande " + $CONTO_GRANDE + "=" + $c.VistoGrande)
    if($c.TracciaV3 -ne ""){ [void]$righeC.Add("      traccia del 100k: " + $c.TracciaV3) }
    if($c.Scarto -ne ""){ [void]$righeC.Add("      scartata perche': " + $c.Scarto) }
  }
  foreach($r in $righeC){ Write-Host ("  " + $r) -ForegroundColor Gray }

  $V3Cand = @($Cand | Where-Object { $_.TracciaV3 -ne "" })
  $eleg = @($Cand | Where-Object { $_.Eleggibile })
  $auto = @($eleg | Where-Object { $_.Profilo })
  if($CartellaDati -ne ""){
    $imp = @($Cand | Where-Object { $_.Origine -like "*IMPOSTA A MANO*" })
    if($imp.Count -eq 0){ throw ("-CartellaDati '" + $CartellaDati + "' non esiste o non ha nessuna traccia di un terminale: non la uso.") }
    if(-not $imp[0].Eleggibile){ throw ("-CartellaDati '" + $CartellaDati + "' NON passa i gate: " + $imp[0].Scarto + ". La manopola non salta i controlli: mi fermo.") }
    $Piccolo = $imp[0]
    $Criterio = "IMPOSTA A MANO con -CartellaDati, e ha passato gli stessi gate (bases\" + $BASE_BCM + ", nessuna traccia del 100k)"
    if(-not $Piccolo.Profilo){ [void]$Rilievi.Add("la cartella imposta con -CartellaDati sta sotto un ALTRO profilo utente rispetto a questa sessione (" + $env:USERNAME + "): l'hai scelta tu, e' dichiarato.") }
  }
  elseif($auto.Count -eq 1){
    $Piccolo = $auto[0]
    $Criterio = "FATTO: unica cartella dati sotto il profilo di questa sessione (" + $env:USERNAME + ") con bases\" + $BASE_BCM + " e SENZA traccia del 100k"
    if($eleg.Count -gt 1){
      $altre = @($eleg | Where-Object { -not $_.Profilo } | ForEach-Object { $_.Percorso }) -join " | "
      [void]$Rilievi.Add("altre " + ($eleg.Count - 1) + " cartelle passano i fatti ma stanno sotto un ALTRO profilo utente, e NON sono state toccate: " + $altre)
    }
  }
  elseif($auto.Count -eq 0 -and $eleg.Count -ge 1){
    throw ("NON SO QUALE CARTELLA DATI E' IL PICCOLO (classe 115): " + $eleg.Count + " cartelle passano i fatti ma NESSUNA sta sotto il profilo di questa sessione (" + $env:USERNAME + "). O sei nella sessione sbagliata (sul VPS i terminali girano sotto ADMINISTRATOR, misurato il 03/09), o e' portable. L'elenco e' qui sopra e nel referto: se e' davvero quella, rilancia LO STESSO blocco aggiungendo al driver -CartellaDati ""<percorso>"".")
  }
  else{
    throw ("NON SO QUALE CARTELLA DATI E' IL PICCOLO (classe 115: eleggibili sotto questo profilo " + $auto.Count + ", ne serve 1). L'elenco completo e' qui sopra e nel referto. Rilancia LO STESSO blocco aggiungendo al driver: -CartellaDati ""<percorso della cartella dati del piccolo>"".")
  }
  if($Piccolo.VistoPiccolo){ $Criterio = $Criterio + "; login " + $CONTO_PICCOLO + " CONFERMATO nei log" }
  else{
    [void]$Rilievi.Add("il login " + $CONTO_PICCOLO + " NON compare nei log degli ultimi 45 giorni della cartella scelta (" + $Piccolo.Percorso + "): la scelta si regge su bases\" + $BASE_BCM + " + assenza di tracce del 100k. Dichiarato.")
  }
  $Scelta = $Piccolo.Percorso
  if($Piccolo.Origin -ne "" -and (Test-Path -LiteralPath (Join-Path $Piccolo.Origin "metaeditor64.exe"))){ $Inst = $Piccolo.Origin }
  elseif($Piccolo.HaMe){ $Inst = $Piccolo.Percorso }
  else{ throw ("metaeditor64.exe dell'installazione del piccolo NON trovato (origin.txt: '" + $Piccolo.Origin + "'): senza il SUO compilatore non installo niente.") }
  if($Inst -like "*-V3*"){ throw ("l'installazione che l'origin.txt indica per il piccolo contiene -V3 (" + $Inst + "): contraddice il perimetro, mi fermo.") }
  $Me = Join-Path $Inst "metaeditor64.exe"
  $MqlDir  = Join-Path $Scelta "MQL5"
  $DestMq5 = Join-Path $MqlDir ("Experts\" + $EA + ".mq5")
  $DestEx5 = Join-Path $MqlDir ("Experts\" + $EA + ".ex5")
  $Due     = @($DestMq5, $DestEx5)
  Dico ("cartella dati scelta: " + $Scelta) "Yellow"
  Dico ("criterio ............ " + $Criterio) "Yellow"
  Dico ("installazione ....... " + $Inst) "Yellow"

  # -------------------------------------------------------------------
  #  4. LE FOTO PRIMA
  # -------------------------------------------------------------------
  Titolo "4. FOTO PRIMA (piccolo, cartelle col 100k, parametri, Files\)"
  foreach($p in $Due){ $FotoP[$p] = Foto $p }
  $giaPresente = ($FotoP[$DestMq5].Esiste -or $FotoP[$DestEx5].Esiste)
  if($giaPresente){ $GiaLi = "SI: una copia di " + $EA + " era gia' in questo terminale (" + (FotoTxt $FotoP[$DestMq5]) + " / .ex5 " + (FotoTxt $FotoP[$DestEx5]) + "). Verra' sostituita, col backup." }
  else{ $GiaLi = "NO: " + $EA + " non c'era in questo terminale (installazione NUOVA)" }
  foreach($c in $V3Cand){
    foreach($n in @(($EA + ".mq5"), ($EA + ".ex5"))){
      $p = Join-Path $c.Percorso ("MQL5\Experts\" + $n)
      [void]$FotoV3.Add([pscustomobject]@{ Percorso=$p; Prima=(Foto $p); Dopo=$null })
    }
  }
  $DirParam = @((Join-Path $Scelta "MQL5\Presets"), (Join-Path $Scelta "Profiles\Charts"), (Join-Path $Scelta "config"))
  foreach($d in $DirParam){ $FotoDirP[$d] = FotoDir $d }
  $FotoPrese = $true
  $FilesTxt = "MQL5\Files del piccolo PRIMA: " + (FotoDir (Join-Path $Scelta "MQL5\Files")) + "  (questa riga NON ci scrive: ci scrivera' l'EA, quando lo attaccherai a un grafico)"
  Dico ($EA + ".mq5 nel piccolo: " + (FotoTxt $FotoP[$DestMq5]))
  Dico ($EA + ".ex5 nel piccolo: " + (FotoTxt $FotoP[$DestEx5]))

  if($Modo -eq "CONTROLLO"){
    $Compilato  = "NON TENTATA (modo CONTROLLO: non si scrive e non si compila)"
    $InstallTxt = "NON AVVENUTA (modo CONTROLLO). In CORSA scriverebbe: " + $DestMq5 + " + il suo .ex5"
    $BackupTxt  = "NON FATTO (modo CONTROLLO)"
  }
  else{
    # -----------------------------------------------------------------
    #  5. BACKUP + SENTINELLA, POI LA SCRITTURA
    # -----------------------------------------------------------------
    Titolo "5. BACKUP, SENTINELLA E COPIA NEL TERMINALE"
    $BackupDir = Join-Path (Join-Path $Dsk ("backup_spreadlogger_" + $Avvio.ToString("yyyyMMdd",$INV))) $Avvio.ToString("HHmmss",$INV)
    New-Item -ItemType Directory -Force -Path $BackupDir | Out-Null
    $bk = New-Object System.Collections.ArrayList
    foreach($p in $Due){
      if(Test-Path -LiteralPath $p){
        Copy-Item -LiteralPath $p -Destination (Join-Path $BackupDir (Split-Path -Leaf $p)) -Force
        [void]$bk.Add((Split-Path -Leaf $p) + ": " + (Descrivi $p))
      }
      else{ [void]$bk.Add((Split-Path -Leaf $p) + ": non c'era (il ripristino lo togliera')") }
    }
    Set-Content -LiteralPath (Join-Path $BackupDir "BACKUP_ORIGINE.txt") -Value (@("backup del " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV), "cartella dati: " + $Scelta) + @($bk)) -Encoding ASCII
    $BackupTxt = "FATTO in " + $BackupDir + " -- " + (@($bk) -join " | ")
    # SENTINELLA scritta PRIMA della prima scrittura nel terminale
    Set-Content -LiteralPath $Sentinella -Value @($DestMq5, $DestEx5, $BackupDir) -Encoding ASCII

    New-Item -ItemType Directory -Force -Path (Join-Path $MqlDir "Experts") | Out-Null
    Copy-Item -LiteralPath $Mq5 -Destination $DestMq5 -Force
    $ScrittoNelTerminale = $true
    if((HashPieno $Mq5) -ne (HashPieno $DestMq5)){ throw ("COPIA NON VERIFICATA: il .mq5 nel terminale non ha lo stesso sha256 di quello scaricato al pin.") }
    Dico ("copiato " + $DestMq5) "Green"

    # l'.ex5 vecchio si CANCELLA prima: un binario vecchio sopravvissuto
    # si spaccia per nuovo (checklist 54).
    if(Test-Path -LiteralPath $DestEx5){
      Remove-Item -LiteralPath $DestEx5 -Force -ErrorAction SilentlyContinue
      if(Test-Path -LiteralPath $DestEx5){ throw ("EX5 VECCHIO NON CANCELLABILE (" + $DestEx5 + "): qualcuno lo tiene aperto -- l'EA e' gia' su un grafico? NON compilo: un ex5 vecchio che sopravvive si spaccia per nuovo.") }
    }

    # -----------------------------------------------------------------
    #  6. COMPILAZIONE
    # -----------------------------------------------------------------
    Titolo "6. COMPILAZIONE"
    $esito = Compila $Me @(("/compile:" + $DestMq5), ("/inc:" + $MqlDir), ("/log:" + $LogPath)) $DestEx5 $LogPath $TimeoutSec
    $LogRighe = @($esito.Log)
    $RcTxt = "NON LETTO"
    if($null -ne $esito.Rc){ $RcTxt = "" + $esito.Rc + "   (1 e' NORMALE su questo VPS: e' il numero di file compilati, misurato il 03/09)" }
    $res = @($LogRighe | Where-Object { $_ -match 'Result:' })
    if(@($res).Count -gt 0){ $ResultTxt = ($res[0]).Trim() }
    if($esito.Ex5){
      $kb = [math]::Round((Get-Item -LiteralPath $DestEx5).Length / 1024, 1)
      $warn = 0
      $mw = [regex]::Match($ResultTxt, '(\d+)\s+warning')
      if($mw.Success){ $warn = [int]::Parse($mw.Groups[1].Value, $INV) }
      $err = -1
      $me2 = [regex]::Match($ResultTxt, '(\d+)\s+error')
      if($me2.Success){ $err = [int]::Parse($me2.Groups[1].Value, $INV) }
      if($err -gt 0){
        $Compilato = "FALLITA (" + $ResultTxt + ") nonostante un .ex5 fresco: non mi fido, ripristino."
        $Ripristino = (RipristinaDaBackup $BackupDir $Due) -join "; "
        [void]$Problemi.Add("compilazione con errori: " + $ResultTxt)
        $InstallTxt = "TENTATA E RIPRISTINATA"
      }
      else{
        $Compilato = "OK (" + $kb + " KB, " + (Get-Item -LiteralPath $DestEx5).Length + " byte, " + (Get-Item -LiteralPath $DestEx5).LastWriteTime.ToString("HH:mm:ss",$INV) + "), " + $ResultTxt
        $InstallTxt = "AVVENUTA: " + $DestMq5 + " + " + $DestEx5
        Remove-Item -LiteralPath $Sentinella -Force -ErrorAction SilentlyContinue
        if($warn -gt 0){ [void]$Rilievi.Add("la compilazione ha " + $warn + " warning: leggili nel log dello zip.") }
      }
    }
    elseif($esito.Muto){
      $Compilato = "FALLITA -- METAEDITOR MUTO (lanciato, tornato senza log ne' .ex5). Tipico: editor aperto, percorso, permessi."
      $Ripristino = (RipristinaDaBackup $BackupDir $Due) -join "; "
      [void]$Problemi.Add("MetaEditor muto: nessun log e nessun .ex5.")
      $InstallTxt = "TENTATA E RIPRISTINATA"
    }
    else{
      $Compilato = "FALLITA (" + $ResultTxt + ")"
      $Ripristino = (RipristinaDaBackup $BackupDir $Due) -join "; "
      [void]$Problemi.Add("compilazione fallita: nessun .ex5 fresco. " + $ResultTxt)
      $InstallTxt = "TENTATA E RIPRISTINATA"
    }
    Dico ("compilazione: " + $Compilato) "Yellow"
  }
}
catch{
  $Fatale = $_.Exception.Message
  Write-Host ("!!! FERMATO: " + $Fatale) -ForegroundColor Red
  if($ScrittoNelTerminale -and $BackupDir -ne "" -and (Test-Path -LiteralPath $BackupDir)){
    try{
      $Ripristino = ((RipristinaDaBackup $BackupDir $Due) -join "; ") + "  (dopo un'eccezione)"
      $InstallTxt = "TENTATA E RIPRISTINATA (eccezione)"
      Remove-Item -LiteralPath $Sentinella -Force -ErrorAction SilentlyContinue
      Write-Host ("ripristino: " + $Ripristino) -ForegroundColor Yellow
    }catch{ [void]$Problemi.Add("RIPRISTINO FALLITO dopo l'eccezione: guarda a mano " + $BackupDir) }
  }
}

# =====================================================================
#  RACCOLTA -- gira SEMPRE, anche quando il giro si e' fermato.
# =====================================================================
try{
  Titolo "RACCOLTA"
  # FOTO DOPO: si rifanno sempre, anche dopo un'eccezione.
  if($FotoPrese -and @($Due).Count -eq 2){
    foreach($p in $Due){
      $dopo = Foto $p
      [void]$FotoDopo.Add("PICCOLO " + $p + "   prima [" + (FotoTxt $FotoP[$p]) + "]   dopo [" + (FotoTxt $dopo) + "]   -> " + (Confronta $FotoP[$p] $dopo))
    }
    $cambi = 0
    foreach($d in $DirParam){
      $ora = FotoDir $d
      if($ora -ne $FotoDirP[$d]){ $cambi++ }
    }
    if($cambi -eq 0){ $ParamTxt = "INVARIATI su " + @($DirParam).Count + " cartelle guardate (Presets, Profiles\Charts, config: stesso numero di file, stessi byte, stessa ultima scrittura)" }
    else{
      $ParamTxt = "ATTENZIONE: " + $cambi + " cartelle di parametri risultano cambiate. Se MT5 e' aperto puo' averle riscritte DA SOLO (e' il suo mestiere): non e' una scrittura di questa riga, che non ha nessun percorso verso quelle cartelle. Va comunque letto."
      [void]$Rilievi.Add($ParamTxt)
    }
    $FilesTxt = $FilesTxt + "   ||   DOPO: " + (FotoDir (Join-Path $Scelta "MQL5\Files"))
  }
  else{
    $ParamTxt = "NON MISURATI (il giro si e' fermato prima di scattare le foto: non c'e' niente da confrontare, e un confronto sul vuoto direbbe INVARIATI senza aver guardato niente)"
    if($FotoDopo.Count -eq 0){ [void]$FotoDopo.Add("PICCOLO: nessuna foto scattata (il giro si e' fermato prima del punto 4)") }
  }
  # IL 100k: tre stati, e la foto di un file che non c'e' NON e' una prova (classe 117)
  $vere = 0; $cambiate = 0
  foreach($f in $FotoV3){
    $f.Dopo = Foto $f.Percorso
    if($f.Prima.Esiste -or $f.Dopo.Esiste){ $vere++ }
    if((Confronta $f.Prima $f.Dopo) -eq "CAMBIATO"){ $cambiate++ }
  }
  if($cambiate -gt 0){
    $V3Txt = "ATTENZIONE: " + $cambiate + " file sotto una cartella col 100k RISULTANO CAMBIATI"
    [void]$Problemi.Add($V3Txt)
  }
  elseif($vere -gt 0){ $V3Txt = "INVARIATO su " + $vere + " foto di file REALMENTE PRESENTI" }
  else{ $V3Txt = "NON MISURATO (nessun file vero da fotografare sotto le cartelle col 100k: la sua cartella dati sta sotto un profilo che questa sessione non legge). Il perimetro qui regge PER COSTRUZIONE -- questa riga scrive solo sotto la cartella scelta -- ma sul 100k non e' misurato, e non si regala un verde." }

  $ReferTxt = Join-Path $Work "REFERTO_SPREADLOGGER_INSTALLA.txt"
  $r = New-Object System.Collections.ArrayList
  [void]$r.Add("=====================================================================")
  [void]$r.Add("  INSTALLAZIONE DI " + $EA + " v" + $VersioneAttesa + " -- logger dello spread vivo (SOLA LETTURA)")
  [void]$r.Add("=====================================================================")
  [void]$r.Add("data: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   (E' L'ORA DI AVVIO DI QUESTO GIRO, non l'ora attuale)")
  [void]$r.Add("modo: " + $Modo + "     macchina: " + $env:COMPUTERNAME + "     sessione: " + $env:USERNAME)
  [void]$r.Add("pin : " + $Pin)
  [void]$r.Add("")
  [void]$r.Add("cartella dati del piccolo: " + $Scelta)
  [void]$r.Add("criterio di scelta ......: " + $Criterio)
  [void]$r.Add("installazione (compilatore): " + $Inst)
  [void]$r.Add("")
  [void]$r.Add("sorgente al pin ....: " + $SorgTxt)
  [void]$r.Add("versione letta .....: " + $VersLetta + "   (attesa " + $VersioneAttesa + ")")
  [void]$r.Add("autotest dichiarato : " + $DefineTxt)
  [void]$r.Add("token vietati ......: " + $VietatiTxt)
  [void]$r.Add("ASCII ..............: " + $AsciiTxt)
  [void]$r.Add("era gia' installato : " + $GiaLi)
  [void]$r.Add("")
  [void]$r.Add("backup .............: " + $BackupTxt)
  [void]$r.Add("compilazione .......: " + $Compilato)
  [void]$r.Add("riga Result del log : " + $ResultTxt)
  [void]$r.Add("codice di uscita di metaeditor64: " + $RcTxt)
  [void]$r.Add("INSTALLAZIONE ......: " + $InstallTxt)
  [void]$r.Add("ripristino .........: " + $Ripristino)
  [void]$r.Add("")
  [void]$r.Add("IL -V3 / 100k ......: " + $V3Txt)
  foreach($f in $FotoV3){ [void]$r.Add("   100k " + $f.Percorso + "   prima [" + (FotoTxt $f.Prima) + "]   dopo [" + (FotoTxt $f.Dopo) + "]   -> " + (Confronta $f.Prima $f.Dopo)) }
  [void]$r.Add("PARAMETRI (.set/.chr/.ini): " + $ParamTxt)
  [void]$r.Add($FilesTxt)
  foreach($x in $FotoDopo){ [void]$r.Add($x) }
  [void]$r.Add("")
  [void]$r.Add("COSA SUCCEDE DOPO (lo fa Claudio a mano, non questa riga):")
  [void]$r.Add("  1. in MT5 del piccolo: Navigatore > Expert Advisors > tasto destro > Aggiorna;")
  [void]$r.Add("     deve comparire " + $EA + ".")
  [void]$r.Add("  2. File > Nuovo grafico (un grafico NUOVO, mai uno che ha gia' un EA:")
  [void]$r.Add("     un grafico tiene UN SOLO EA e attaccare il logger su una sedia viva la")
  [void]$r.Add("     SOSTITUIREBBE).")
  [void]$r.Add("  3. trascina " + $EA + " su quel grafico, lascia gli input come sono, OK.")
  [void]$r.Add("  4. scheda ESPERTI: deve comparire '" + $MarcatoreEA + "' e la riga")
  [void]$r.Add("     '[SPREADLOG] AUTOTEST: 8 blocchi ... 36 casi ... 0 falliti'.")
  [void]$r.Add("  5. lo lasci girare per la finestra di raccolta, poi si lancia la riga di")
  [void]$r.Add("     RACCOLTA (RIGA_SPREADLOGGER_RACCOLTA.ps1), che NON tocca il terminale.")
  [void]$r.Add("")
  [void]$r.Add("PROBLEMI: " + $Problemi.Count)
  foreach($p in $Problemi){ [void]$r.Add("  - " + $p) }
  [void]$r.Add("RILIEVI: " + $Rilievi.Count)
  foreach($p in $Rilievi){ [void]$r.Add("  - " + $p) }
  if($Fatale -ne ""){ [void]$r.Add(""); [void]$r.Add("!!! FERMATO: " + $Fatale) }
  [void]$r.Add("")
  foreach($x in $righeC){ [void]$r.Add($x) }
  Set-Content -LiteralPath $ReferTxt -Value @($r) -Encoding ASCII

  $CandTxt = Join-Path $Work "CANDIDATE.txt"
  Set-Content -LiteralPath $CandTxt -Value @($righeC) -Encoding ASCII

  $daZip = New-Object System.Collections.ArrayList
  [void]$daZip.Add($ReferTxt)
  [void]$daZip.Add($CandTxt)
  if(Test-Path -LiteralPath $LogPath){
    [void]$daZip.Add($LogPath)
    $leggibile = Join-Path $Work "COMPILAZIONE_leggibile.txt"
    Set-Content -LiteralPath $leggibile -Value @($LogRighe) -Encoding ASCII
    [void]$daZip.Add($leggibile)
  }
  $zip = Join-Path $Dsk ("SPREADLOGGER_INSTALLA_" + $Modo + "_" + $Stamp + ".zip")
  Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
  Compress-Archive -LiteralPath @($daZip) -DestinationPath $zip -Force
  Write-Host ""
  Write-Host ("REFERTO: " + $ReferTxt) -ForegroundColor Cyan
  Write-Host ("ZIP DA MANDARE IN CHAT: " + $zip) -ForegroundColor Cyan
  Write-Host ("PROBLEMI: " + $Problemi.Count + "   RILIEVI: " + $Rilievi.Count)
}
catch{
  Write-Host ("RACCOLTA IN DIFFICOLTA': " + $_.Exception.Message) -ForegroundColor Red
  Write-Host "Manda in chat quello che vedi qui sopra: va bene uguale." -ForegroundColor Yellow
}

if($Fatale -ne "" -or $Problemi.Count -gt 0){ exit 1 }
exit 0
