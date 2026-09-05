# =====================================================================
#  MARCATORE_RIGA_SLIPPAGELOGGER_v1
#  RIGA_SLIPPAGELOGGER.ps1 -- INSTALLA E COMPILA ABTG_SlippageLogger.mq5
#  (logger dello slippage vero, SOLA LETTURA) sul SOLO terminale del
#  conto REALE, il cui numero lo deve dire CLAUDIO con -LoginAtteso.
#
#  PERCHE' ESISTE: BCM ha confermato che il conto DEMO NON simula lo
#  slippage. Quindi la differenza fra prezzo richiesto e prezzo
#  eseguito -- il numero che manca a tutti i round, e che
#  ABTG_SpreadLogger dichiara esplicitamente di NON misurare -- esiste
#  SOLO su un conto reale. Questa riga mette l'osservatore li'.
#
#  >>> COSA INSTALLA, E DOVE (solo in modo CORSA, e SOLO li'):
#        <cartella dati del REALE>\MQL5\Experts\ABTG_SlippageLogger.mq5
#        <cartella dati del REALE>\MQL5\Experts\ABTG_SlippageLogger.ex5
#      NIENT'ALTRO: nessun .set, nessun .ini, nessun .chr, nessun
#      profilo, nessun grafico. L'EA NON viene attaccato a niente: lo
#      attacca Claudio a mano, su un grafico NUOVO (vedi la pagina).
#      Che i parametri non siano stati toccati lo DIMOSTRA una foto:
#      conteggio, byte e ultima scrittura di Presets\, Profiles\Charts\
#      e config\ prima e dopo.
#
#  >>> LA GUARDIA SUL CONTO E' PIU' SEVERA di quella della riga gemella
#      dello Spread Logger, e il motivo e' uno solo: LI' SOTTO CI SONO
#      SOLDI VERI. Nello Spread Logger il login non trovato nei log era
#      un RILIEVO e si andava avanti. Qui non si va avanti.
#
#      1. -LoginAtteso E' OBBLIGATORIO. Non ha default e non si indovina
#         dal nome di niente: il numero del conto reale lo sa Claudio e
#         lo deve scrivere lui. Senza, la riga non parte.
#      2. DUE CONTI SONO VIETATI PER SEMPRE, e non c'e' nessuna manopola
#         che li sblocchi: il PICCOLO 50503392 e il 100k 50504263.
#         Se -LoginAtteso e' uno di quei due, la riga si ferma subito.
#         Se una cartella candidata mostra uno di quei due login nei
#         log, la cartella e' SCARTATA -- anche se ci fosse dentro pure
#         il login atteso, perche' un terminale che ha visto tutti e
#         due non dice quale conto e' collegato ADESSO.
#      3. IL LOGIN ATTESO DEVE COMPARIRE NEI LOG della cartella scelta.
#         Nello Spread Logger questa era una conferma facoltativa; qui
#         e' IL fatto, ed e' l'unico che distingue davvero un terminale
#         dall'altro.
#      4. Se il login atteso NON si trova, la riga si FERMA e stampa
#         tutto quello che ha guardato. Si puo' andare avanti solo con
#         una ATTESTAZIONE A MANO -- -CartellaDati "<percorso>" e
#         -ConfermoConto <lo stesso numero di -LoginAtteso> -- cioe'
#         scrivendo il numero DUE VOLTE. Non e' una scorciatoia: e' una
#         firma, e il referto la scrive a lettere maiuscole come
#         "SCELTA ATTESTATA A MANO, NON MISURATA". Il punto 2 resta
#         valido lo stesso: l'attestazione non sblocca i conti vietati.
#      5. E c'e' una SECONDA serratura, indipendente da questa riga:
#         l'EA stesso ha l'input InpLoginAtteso e si RIFIUTA DI PARTIRE
#         se il terminale su cui lo trascini non e' quel conto. Anche
#         se questa riga sbagliasse cartella, il logger non misurerebbe
#         il conto sbagliato: si fermerebbe dicendolo.
#
#  >>> IL NOME DEL SERVER BCM DEL CONTO REALE NON LO SAPPIAMO, e non lo
#      si inventa. I terminali demo stanno su "BCMMarkets-Server"; il
#      reale potrebbe stare su un altro nome. Quindi qui NON si pretende
#      un nome di base: si pretende il LOGIN nei log, e la riga STAMPA
#      quali cartelle bases\ ha trovato, cosi' il nome vero lo si legge
#      dal referto invece di indovinarlo. Se lo si vuole comunque
#      pretendere, c'e' -BaseAttesa.
#
#  >>> MT5 PUO' RESTARE APERTO, ED E' VOLUTO: la flotta non si ferma, e
#      ABTG_SlippageLogger e' un file NUOVO che non sta su nessun
#      grafico, quindi la compilazione non scarica nessuna sedia. Non
#      si scrive dentro config\ ne' nei .chr, che sono i file che MT5
#      riscrive all'uscita (checklist punto 7).
#      METAEDITOR invece si PRETENDE CHIUSO: e' single-instance e con
#      l'editor aperto la compilazione da riga di comando torna muta
#      (misurato il 22/08).
#
#  >>> IN MODO CONTROLLO (default) NON SCRIVE NIENTE NEL TERMINALE:
#      scarica al pin, passa i gate sul sorgente, sceglie la cartella
#      dati, fotografa e si ferma PRIMA del backup.
#
#  >>> I GATE SUL SORGENTE (l'identita' dell'artefatto, prima di
#      installarlo): marcatore, #property version, i due #define
#      dell'autotest, il conteggio VERO dei casi nel codice, la
#      presenza degli input della guardia sul conto, e soprattutto il
#      CENSIMENTO DEI TOKEN VIETATI. La lista qui e' piu' lunga di
#      quella dello Spread Logger: oltre alle funzioni di invio ordini
#      ci sono le STRUTTURE della richiesta di trading (senza quelle,
#      in MQL5, un ordine non si puo' proprio comporre), la
#      cancellazione e lo spostamento di file, e il tocco al Market
#      Watch. Il censimento gira sulle RIGHE DI CODICE (parte dopo //
#      tolta) e pretende ZERO.
#
#  >>> IL VERDETTO STA SULL'ARTEFATTO, NON SUL CODICE DI USCITA (classe
#      108): metaeditor64 sul VPS torna 1 anche quando compila.
#
#  QUANTO CI METTE [STIMA]: 1-3 minuti.
#
#  LA RIGA CHE SI INCOLLA sta in
#  righe\RIGA_SLIPPAGELOGGER_DA_MANDARE.md
# =====================================================================
[CmdletBinding()]
param(
  # -Pin NON ha default: un default silenzioso ("lavoro") farebbe girare
  #  la punta del branch spacciandola per un commit congelato.
  [string]$Pin = "",
  # -LoginAtteso NON ha default, ed e' OBBLIGATORIO: qui sotto c'e'
  #  capitale vero e il conto non si indovina.
  [string]$LoginAtteso = "",
  [ValidateSet("CONTROLLO","CORSA")]
  [string]$Modo = "CONTROLLO",
  [string]$CartellaDati = "",
  # -ConfermoConto: l'attestazione a mano del punto 4. Va scritto lo
  #  stesso numero di -LoginAtteso, e serve SOLO quando il login non si
  #  trova nei log. Non sblocca i conti vietati.
  [string]$ConfermoConto = "",
  [string]$BaseAttesa = "",
  [int]$TimeoutSec = 180
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

$EA              = "ABTG_SlippageLogger"
$VersioneAttesa  = "1.00"
$MarcatoreEA     = "ABTG_SlippageLogger v1.00 - logger di SOLA LETTURA, slippage vero dai deal"
$BLOCCHI_ATTESI  = 9
$CASI_ATTESI     = 101
# I DUE CONTI VIETATI. Non e' una preferenza: sono i due conti DEMO
# della flotta, e su un conto demo questo artefatto misurerebbe zero
# per costruzione (BCM ha confermato che li' lo slippage non c'e').
# Installarlo li' non farebbe danno ai soldi -- farebbe una cosa
# peggiore, cioe' un file di zeri che somiglia a una misura.
$VIETATI_CONTI   = @("50503392","50504263")

# I token che NON devono esistere nelle righe di codice del sorgente.
# Sono la definizione OPERATIVA di "sola lettura". Rispetto alla lista
# dello Spread Logger qui ci sono in piu':
#   - MqlTradeRequest / MqlTradeResult / MqlTradeCheckResult / TRADE_ACTION:
#     sono le STRUTTURE con cui in MQL5 si compone un ordine. Senza
#     quelle un ordine non si puo' nemmeno scrivere, e questo e' un
#     cancello strutturale, non una promessa;
#   - OnTradeTransaction: la sua firma pretende quelle strutture, per
#     questo l'EA non ce l'ha (e paga qualche secondo di ritardo);
#   - FileDelete / FileMove / FileCopy / Folder*: cosi' l'artefatto non
#     puo' cancellare o spostare NESSUN file, nemmeno i propri;
#   - SymbolSelect: cosi' non tocca il Market Watch del conto reale;
#   - ObjectCreate / ChartApplyTemplate / ExpertRemove: niente oggetti
#     grafici, niente template, non si stacca da solo.
$VIETATI = @("OrderSend","OrderSendAsync","OrderModify","OrderClose","OrderDelete","OrderCloseBy",
             "PositionOpen","PositionClose","PositionModify","PositionCloseBy","PositionClosePartial",
             "CTrade","CPositionInfo","CAccountInfo","Trade.mqh","Trade\Trade",
             "MqlTradeRequest","MqlTradeResult","MqlTradeCheckResult","TRADE_ACTION",
             "OnTradeTransaction",
             "GlobalVariableSet","GlobalVariableDel","GlobalVariableTemp","GlobalVariableGet",
             "GlobalVariableCheck","GlobalVariableName","GlobalVariablesTotal","GlobalVariablesFlush",
             "WebRequest","SendNotification","SendMail","SendFTP","#import","DllCall","TesterWithdrawal",
             "SymbolSelect","FileDelete","FileMove","FileCopy","FolderCreate","FolderDelete","FolderClean",
             "ObjectCreate","ObjectSetInteger","ChartApplyTemplate","ChartSetSymbolPeriod","ExpertRemove")
# Input che nel sorgente CI DEVONO ESSERE: sono la seconda serratura.
$RICHIESTI = @("InpLoginAtteso","InpSoloContoReale","InpPrefissoFile")

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
$Work       = Join-Path $env:USERPROFILE "abtg_slippagelogger"
$Scaricati  = Join-Path $Work "scaricati"
$Sentinella = Join-Path $Work "SLIPPAGELOGGER_INSTALLA_IN_CORSO.txt"
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
$RichTxt    = "NON VERIFICATO"
$AsciiTxt   = "NON VERIFICATO"
$ResultTxt  = "NON LETTA"
$RcTxt      = "NON LETTO"
$DemoTxt    = "NON VERIFICATO (non ci siamo arrivati)"
$ParamTxt   = "NON VERIFICATO (non ci siamo arrivati)"
$FilesTxt   = "NON VERIFICATA"
$GiaLi      = "NON VERIFICATO"
$ContoTxt   = "NON MISURATO"
$BasiTxt    = "NON LETTE"
$ScrittoNelTerminale = $false
$BackupDir  = ""
$Reale      = $null
$DemoCand   = @()
$Due        = @()
$FotoP      = @{}
$FotoDemo   = New-Object System.Collections.ArrayList
$FotoDopo   = New-Object System.Collections.ArrayList
$DirParam   = @()
$FotoDirP   = @{}
$LogRighe   = @()
$DestMq5    = ""
$DestEx5    = ""
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
  # DUE ASSENZE NON SONO UNA PROVA (classe 117): un file che non c'era e
  # non c'e' non si timbra INVARIATO, perche' quella parola in un referto
  # vuol dire "l'ho guardato ed era uguale".
  if(-not $a.Esiste -and -not $b.Esiste){ return "ASSENTE prima e dopo (niente da confrontare)" }
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
    Origin=""; Basi=""; Logins=""; FileLog=0; VistoAtteso=$false; VistiVietati=""
    Eleggibile=$false; Profilo=$false; Scarto=""; Leggibile=$true
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
  Titolo ("INSTALLA " + $EA + " v" + $VersioneAttesa + " sul SOLO conto REALE -- modo " + $Modo)
  if($Modo -eq "CONTROLLO"){ Write-Host "MODO CONTROLLO: questo giro NON scrive niente nel terminale. Mostra cosa farebbe la CORSA." -ForegroundColor Yellow }
  else{ Write-Host "MODO CORSA: scrive DUE file nella sola cartella dati scelta (.mq5 + .ex5), con backup e ripristino su fallimento. Non attacca l'EA a nessun grafico." -ForegroundColor Yellow }
  Write-Host "QUI SOTTO C'E' CAPITALE VERO: la guardia sul conto e' piu' severa del solito, e si ferma invece di indovinare." -ForegroundColor Yellow

  # -------------------------------------------------------------------
  #  0. LE GUARDIE
  # -------------------------------------------------------------------
  if($Pin -eq ""){ throw "-Pin obbligatorio: senza, girerebbe la punta del branch spacciandola per un commit congelato." }
  if($Pin -notmatch '^[0-9a-f]{40}$'){ throw ("-Pin deve essere un commit di 40 caratteri esadecimali, ricevuto: " + $Pin) }
  $RawPin = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/" + $Pin

  if($LoginAtteso -eq ""){
    throw "-LoginAtteso OBBLIGATORIO: devi dirmi il numero del conto REALE. Non ce l'ho scritto da nessuna parte e non lo indovino dal nome di una cartella. Lo trovi in MT5 in alto a sinistra nel Navigatore, sotto Conti."
  }
  if($LoginAtteso -notmatch '^\d{5,12}$'){ throw ("-LoginAtteso deve essere un numero di conto (5-12 cifre), ricevuto: " + $LoginAtteso) }
  foreach($v in $VIETATI_CONTI){
    if($LoginAtteso -eq $v){
      throw ("IL CONTO " + $v + " E' VIETATO PER QUESTA RIGA: e' uno dei due conti DEMO della flotta, e BCM ha confermato che sul demo lo slippage NON e' simulato. Installarlo li' produrrebbe un file di zeri che somiglia a una misura. Se volevi il reale, ricontrolla il numero.")
    }
  }
  if($ConfermoConto -ne "" -and $ConfermoConto -ne $LoginAtteso){
    throw ("-ConfermoConto (" + $ConfermoConto + ") e -LoginAtteso (" + $LoginAtteso + ") non coincidono. L'attestazione a mano serve proprio a farti scrivere il numero DUE VOLTE: se i due numeri non sono uguali, mi fermo.")
  }

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
  Dico ("pin ............ " + $Pin)
  Dico ("conto atteso ... " + $LoginAtteso + "   (vietati per sempre: " + ($VIETATI_CONTI -join ", ") + ")") "Yellow"
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
  Titolo "2. SCARICO AL PIN E GATE SUL SORGENTE (marcatore, versione, autotest, token vietati, input della guardia)"
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
  $mb = [regex]::Match($testoMq5, 'ABTG_SLIPLOG_AUTOTEST_BLOCCHI_ATTESI\s+(\d+)')
  $mc = [regex]::Match($testoMq5, 'ABTG_SLIPLOG_AUTOTEST_CASI_ATTESI\s+(\d+)')
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
  $nBloccoVeri = ([regex]::Matches($testoMq5, 'blocchi\+\+;')).Count
  if($nBloccoVeri -ne $BLOCCHI_ATTESI){
    throw ("I BLOCCHI DICHIARATI NON SONO QUELLI SCRITTI: il #define dice " + $BLOCCHI_ATTESI + ", nel codice ne conto " + $nBloccoVeri + ". NON installo.")
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
  # GLI INPUT DELLA GUARDIA CI DEVONO ESSERE: sono la seconda serratura,
  # quella che impedisce all'EA di misurare un conto che non e' il suo.
  $mancanti = New-Object System.Collections.ArrayList
  foreach($r in $RICHIESTI){
    if($testoMq5.IndexOf($r, [System.StringComparison]::Ordinal) -lt 0){ [void]$mancanti.Add($r) }
  }
  if($mancanti.Count -gt 0){
    throw ("NEL SORGENTE MANCANO GLI INPUT DELLA GUARDIA SUL CONTO (" + (@($mancanti) -join ", ") + "): senza quelli l'EA misurerebbe qualunque terminale su cui finisce. NON installo.")
  }
  $RichTxt = "presenti tutti e " + $RICHIESTI.Count + " (" + ($RICHIESTI -join ", ") + ")"
  # include: qui non ne deve esistere NESSUNO (l'EA e' autosufficiente).
  $inc = @()
  foreach($riga in $righeMq5){
    $viva = ($riga -replace '//.*$','')
    if($viva -match '^\s*#include'){ $inc += $viva.Trim() }
  }
  if(@($inc).Count -gt 0){
    throw ("IL SORGENTE CHIEDE DEGLI #include (" + (@($inc) -join " | ") + ") che questa riga non installa: mi fermo prima di compilare qualcosa che non ha tutti i pezzi.")
  }
  $nonAscii = 0
  foreach($riga in $righeMq5){ foreach($ch in $riga.ToCharArray()){ if([int]$ch -gt 126){ $nonAscii++ } } }
  $AsciiTxt = "" + $nonAscii + " caratteri non-ASCII nel sorgente"
  if($nonAscii -gt 0){ [void]$Rilievi.Add("il sorgente al pin ha " + $nonAscii + " caratteri non-ASCII: non blocca la compilazione, ma va sistemato.") }
  Dico ("versione " + $VersLetta + " | autotest " + $DefineTxt + " (casi contati: " + $nCasoVeri + ", blocchi contati: " + $nBloccoVeri + ") | vietati: " + $VietatiTxt) "Green"

  # -------------------------------------------------------------------
  #  3. LA CARTELLA DATI DEL CONTO REALE -- scelta per FATTI, e severa
  # -------------------------------------------------------------------
  Titolo ("3. CARTELLA DATI DEL CONTO REALE " + $LoginAtteso + " (scansione LARGA, scelta STRETTISSIMA)")
  foreach($pr in @(Get-Process -Name terminal64,metaeditor64 -ErrorAction SilentlyContinue)){
    $exe = ""
    try{ $exe = $pr.Path }catch{ $exe = "" }
    if($exe){ AggiungiCandidata (Split-Path -Parent $exe) ("processo " + $pr.ProcessName + " pid " + $pr.Id) }
  }
  $radici = New-Object System.Collections.ArrayList
  if($env:APPDATA){ [void]$radici.Add((Join-Path $env:APPDATA "MetaQuotes\Terminal")) }
  $drive = $env:SystemDrive
  if(-not $drive){ $drive = "C:" }
  # IL DISCO SI VERIFICA PRIMA DI USARLO: Join-Path su un disco che non
  # esiste NON torna un percorso brutto, LANCIA.
  $driveOk = $false
  try{ $driveOk = (Test-Path -LiteralPath ($drive + "\")) }catch{ $driveOk = $false }
  if(-not $driveOk){ [void]$Rilievi.Add("il disco di sistema '" + $drive + "' non e' leggibile da questa sessione: la scansione ha guardato solo %APPDATA% e i processi vivi. Dichiarato.") }
  if($driveOk){
    try{
      foreach($u in @(Get-ChildItem -LiteralPath (Join-Path $drive "Users") -Directory -ErrorAction SilentlyContinue)){
        [void]$radici.Add((Join-Path $u.FullName "AppData\Roaming\MetaQuotes\Terminal"))
      }
    }catch{}
  }
  foreach($rt in $radici){
    if(-not (Test-Path -LiteralPath $rt)){ continue }
    foreach($d in @(Get-ChildItem -LiteralPath $rt -Directory -ErrorAction SilentlyContinue)){
      if($d.Name -ieq "Common"){ continue }
      AggiungiCandidata $d.FullName ("cartella dati sotto " + $rt)
    }
  }
  $paroleChiave = @("MT5","BCM","MetaTrader","MetaQuotes","Terminal")
  $radiciInst = New-Object System.Collections.ArrayList
  $radiciPF = @($env:ProgramFiles, ${env:ProgramFiles(x86)})
  if($driveOk){ $radiciPF = $radiciPF + @((Join-Path $drive "Program Files"), (Join-Path $drive "Program Files (x86)")) }
  foreach($ri in $radiciPF){
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

  # la finestra dei log e' LARGA (180 giorni) apposta: un conto reale
  # aperto tempo fa e mai usato puo' avere una sola riga di login vecchia,
  # e quella riga e' l'unico fatto che distingue il terminale giusto.
  $limite = (Get-Date).AddDays(-180)
  foreach($c in $Cand){
    $o = Join-Path $c.Percorso "origin.txt"
    if(Test-Path -LiteralPath $o){
      try{ $c.Origin = ([string](Get-Content -LiteralPath $o -Raw -ErrorAction Stop)).Trim() }catch{ $c.Origin = ""; $c.Leggibile = $false }
    }
    $basi = @()
    $bd = Join-Path $c.Percorso "bases"
    if(Test-Path -LiteralPath $bd){
      try{ $basi = @(Get-ChildItem -LiteralPath $bd -Directory -ErrorAction Stop | ForEach-Object { $_.Name }) }catch{ $c.Leggibile = $false }
    }
    $c.Basi = (@($basi) -join ", ")
    $loginSet = @{}
    $vietatiVisti = @{}
    foreach($sub in @("logs","MQL5\Logs")){
      $dir = Join-Path $c.Percorso $sub
      if(-not (Test-Path -LiteralPath $dir)){ continue }
      $files = @()
      try{
        $files = @(Get-ChildItem -LiteralPath $dir -Filter "*.log" -File -ErrorAction Stop |
                   Where-Object { $_.LastWriteTime -ge $limite -and $_.Length -lt 60000000 } |
                   Sort-Object LastWriteTime -Descending | Select-Object -First 40)
      }catch{ $c.Leggibile = $false }
      $c.FileLog = $c.FileLog + $files.Count
      foreach($f in $files){
        $righe = @()
        try{ $righe = LeggiTesto $f.FullName }catch{ $c.Leggibile = $false; continue }
        $txt = ($righe -join "`n")
        if($txt.IndexOf("'" + $LoginAtteso + "'") -ge 0){ $c.VistoAtteso = $true }
        foreach($v in $VIETATI_CONTI){ if($txt.IndexOf("'" + $v + "'") -ge 0){ $vietatiVisti[$v] = 1 } }
        foreach($m in [regex]::Matches($txt, "'(\d{5,})': (?:login|authorized) on")){ $loginSet[$m.Groups[1].Value] = 1 }
      }
    }
    if($loginSet.Keys.Count -gt 0){ $c.Logins = (@($loginSet.Keys | Sort-Object) -join ",") }
    if($vietatiVisti.Keys.Count -gt 0){ $c.VistiVietati = (@($vietatiVisti.Keys | Sort-Object) -join ",") }
    if($env:APPDATA){ $c.Profilo = $c.Percorso.StartsWith(($env:APPDATA.TrimEnd("\")), [System.StringComparison]::OrdinalIgnoreCase) }

    if(-not $c.HaMql){ $c.Scarto = "nessuna cartella MQL5\ (installazione non portable: i dati stanno altrove)"; continue }
    # IL CANCELLO CHE NON SI APRE MAI: un terminale che ha visto uno dei
    # due conti DEMO e' fuori, punto. Anche se avesse visto pure quello
    # atteso -- anzi, SOPRATTUTTO allora: un terminale che ha visto tutti
    # e due non dice a quale conto e' collegato ADESSO.
    if($c.VistiVietati -ne ""){
      $c.Scarto = "HA VISTO UN CONTO VIETATO nei log (" + $c.VistiVietati + "): fuori dal perimetro, e non c'e' manopola che lo sblocchi"
      continue
    }
    if($BaseAttesa -ne ""){
      $trovataBase = $false
      foreach($b in $basi){ if($b -ieq $BaseAttesa){ $trovataBase = $true } }
      if(-not $trovataBase){ $c.Scarto = "nessuna bases\" + $BaseAttesa + " (chiesta con -BaseAttesa); qui c'e': " + $c.Basi; continue }
    }
    $c.Eleggibile = $true
    if(-not $c.VistoAtteso){ $c.Scarto = "il login " + $LoginAtteso + " NON compare nei log degli ultimi 180 giorni: non e' scartata, ma NON si sceglie da sola" }
    elseif(-not $c.Profilo){ $c.Scarto = "il login c'e', ma la cartella sta sotto un ALTRO profilo utente (questa sessione e' " + $env:USERNAME + "): non scelta da sola. Se e' davvero lei, imponila con -CartellaDati" }
  }

  $righeC.Clear()
  [void]$righeC.Add("CARTELLE GUARDATE (conto cercato " + $LoginAtteso + ", vietati " + ($VIETATI_CONTI -join "/") + ", candidate " + $Cand.Count + "):")
  foreach($c in $Cand){
    $tag = "scartata"
    if($c.Eleggibile -and $c.VistoAtteso -and $c.Profilo){ $tag = "SCEGLIBILE: login confermato nei log e sotto il profilo di questa sessione" }
    elseif($c.Eleggibile -and $c.VistoAtteso){ $tag = "login confermato, ma sotto un ALTRO profilo" }
    elseif($c.Eleggibile){ $tag = "passa i gate ma SENZA il login nei log" }
    [void]$righeC.Add("  --- " + $c.Percorso + "   [" + $tag + "]")
    [void]$righeC.Add("      trovata come: " + $c.Origine)
    [void]$righeC.Add("      terminal64.exe=" + $c.HaExe + " metaeditor64.exe=" + $c.HaMe + " logs\=" + $c.HaLogs + " MQL5\=" + $c.HaMql + " file di log letti=" + $c.FileLog + " leggibile=" + $c.Leggibile)
    if($c.Origin -ne ""){ [void]$righeC.Add("      origin.txt: " + $c.Origin) }
    $bb = "nessuna"
    if($c.Basi -ne ""){ $bb = $c.Basi }
    [void]$righeC.Add("      bases\ (i server visti da questo terminale): " + $bb)
    $lg = "nessuno"
    if($c.Logins -ne ""){ $lg = $c.Logins }
    [void]$righeC.Add("      login visti nei log: " + $lg + "   atteso " + $LoginAtteso + "=" + $c.VistoAtteso)
    if($c.VistiVietati -ne ""){ [void]$righeC.Add("      CONTI VIETATI VISTI QUI: " + $c.VistiVietati) }
    if($c.Scarto -ne ""){ [void]$righeC.Add("      nota: " + $c.Scarto) }
  }
  foreach($r in $righeC){ Write-Host ("  " + $r) -ForegroundColor Gray }

  $DemoCand = @($Cand | Where-Object { $_.VistiVietati -ne "" })
  $conLogin = @($Cand | Where-Object { $_.Eleggibile -and $_.VistoAtteso })
  $auto     = @($conLogin | Where-Object { $_.Profilo })

  if($CartellaDati -ne ""){
    $imp = @($Cand | Where-Object { $_.Origine -like "*IMPOSTA A MANO*" })
    if($imp.Count -eq 0){ throw ("-CartellaDati '" + $CartellaDati + "' non esiste o non ha nessuna traccia di un terminale: non la uso.") }
    if($imp[0].VistiVietati -ne ""){
      throw ("-CartellaDati '" + $CartellaDati + "' HA VISTO UN CONTO VIETATO (" + $imp[0].VistiVietati + "). Questo cancello NON si apre nemmeno a mano: mi fermo.")
    }
    if(-not $imp[0].Eleggibile){ throw ("-CartellaDati '" + $CartellaDati + "' NON passa i gate: " + $imp[0].Scarto + ". La manopola non salta i controlli: mi fermo.") }
    if($imp[0].VistoAtteso){
      $Reale = $imp[0]
      $Criterio = "IMPOSTA A MANO con -CartellaDati, E col login " + $LoginAtteso + " CONFERMATO nei suoi log; nessun conto vietato visto qui"
    }
    elseif($ConfermoConto -ne ""){
      $Reale = $imp[0]
      $Criterio = "SCELTA ATTESTATA A MANO, NON MISURATA: il login " + $LoginAtteso + " NON compare nei log di questa cartella. La cartella e' stata imposta con -CartellaDati e il numero e' stato riscritto con -ConfermoConto. Nessun conto vietato e' stato visto qui, e questo resta MISURATO."
      [void]$Rilievi.Add("SCELTA ATTESTATA A MANO: il login " + $LoginAtteso + " non e' stato trovato nei log della cartella scelta. La riga si e' fidata della tua firma (-ConfermoConto), non di una misura. La SECONDA serratura resta: quando attacchi l'EA metti InpLoginAtteso = " + $LoginAtteso + ", e se il terminale e' quello sbagliato l'EA si rifiutera' di partire.")
    }
    else{
      throw ("-CartellaDati '" + $CartellaDati + "' NON mostra il login " + $LoginAtteso + " nei log degli ultimi 180 giorni. Qui sotto c'e' capitale vero e non installo su una cartella che non so riconoscere. Se sei SICURO che sia quella (aprila in MT5 e guarda il numero di conto), rilancia LO STESSO blocco aggiungendo anche: -ConfermoConto " + $LoginAtteso)
    }
  }
  elseif($auto.Count -eq 1){
    $Reale = $auto[0]
    $Criterio = "FATTO: unica cartella dati con il login " + $LoginAtteso + " nei log, sotto il profilo di questa sessione (" + $env:USERNAME + "), e senza nessuna traccia dei conti vietati"
    if($conLogin.Count -gt 1){
      $altre = @($conLogin | Where-Object { -not $_.Profilo } | ForEach-Object { $_.Percorso }) -join " | "
      [void]$Rilievi.Add("altre " + ($conLogin.Count - 1) + " cartelle mostrano lo stesso login ma stanno sotto un ALTRO profilo utente, e NON sono state toccate: " + $altre)
    }
  }
  elseif($conLogin.Count -eq 0){
    throw ("NON HO TROVATO NESSUNA CARTELLA CON IL LOGIN " + $LoginAtteso + " nei log degli ultimi 180 giorni. L'elenco completo di quello che ho guardato e' qui sopra e nel referto (CANDIDATE.txt), con i login visti in ognuna. Due strade: (1) se il terminale del reale sta sotto un'altra sessione Windows, cambia sessione e rilancia LO STESSO blocco; (2) se lo riconosci nell'elenco, rilancia con -CartellaDati ""<percorso>"" -ConfermoConto " + $LoginAtteso + ". NON ho toccato niente.")
  }
  else{
    throw ("NON SO QUALE CARTELLA E' IL REALE: " + $conLogin.Count + " cartelle mostrano il login " + $LoginAtteso + ", ma " + $auto.Count + " sotto il profilo di questa sessione (ne serve esattamente 1). L'elenco e' qui sopra e nel referto. Rilancia LO STESSO blocco aggiungendo: -CartellaDati ""<percorso>"".")
  }

  $Scelta = $Reale.Percorso
  $vistoTxt = "NON TROVATO (scelta attestata a mano)"
  if($Reale.VistoAtteso){ $vistoTxt = "TROVATO" }
  $loginTxt = "nessuno"
  if($Reale.Logins -ne ""){ $loginTxt = $Reale.Logins }
  $basiScelta = "nessuna"
  if($Reale.Basi -ne ""){ $basiScelta = $Reale.Basi }
  $ContoTxt = "atteso " + $LoginAtteso + "; nei log della cartella scelta: " + $vistoTxt +
              "; login visti qui: " + $loginTxt +
              "; conti vietati visti qui: NESSUNO (verificato su " + $Reale.FileLog + " file di log)"
  $BasiTxt = "bases\ della cartella scelta: " + $basiScelta + "   (il nome del server del conto reale si LEGGE qui, non si indovina)"

  $MeOrigin = ""
  if($Reale.Origin -ne ""){ try{ $MeOrigin = (Join-Path $Reale.Origin "metaeditor64.exe") }catch{ $MeOrigin = ""; [void]$Rilievi.Add("l'origin.txt della cartella scelta ('" + $Reale.Origin + "') non e' un percorso usabile da questa sessione: cerco metaeditor64.exe nella cartella dati.") } }
  if($MeOrigin -ne "" -and (Test-Path -LiteralPath $MeOrigin)){ $Inst = $Reale.Origin }
  elseif($Reale.HaMe){ $Inst = $Reale.Percorso }
  else{ throw ("metaeditor64.exe dell'installazione del conto reale NON trovato (origin.txt: '" + $Reale.Origin + "'): senza il SUO compilatore non installo niente.") }
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
  Titolo "4. FOTO PRIMA (cartella scelta, cartelle dei conti DEMO, parametri, Files\)"
  foreach($p in $Due){ $FotoP[$p] = Foto $p }
  $giaPresente = ($FotoP[$DestMq5].Esiste -or $FotoP[$DestEx5].Esiste)
  if($giaPresente){ $GiaLi = "SI: una copia di " + $EA + " era gia' in questo terminale (" + (FotoTxt $FotoP[$DestMq5]) + " / .ex5 " + (FotoTxt $FotoP[$DestEx5]) + "). Verra' sostituita, col backup." }
  else{ $GiaLi = "NO: " + $EA + " non c'era in questo terminale (installazione NUOVA)" }
  foreach($c in $DemoCand){
    foreach($n in @(($EA + ".mq5"), ($EA + ".ex5"))){
      $p = Join-Path $c.Percorso ("MQL5\Experts\" + $n)
      [void]$FotoDemo.Add([pscustomobject]@{ Percorso=$p; Prima=(Foto $p); Dopo=$null })
    }
  }
  $DirParam = @((Join-Path $Scelta "MQL5\Presets"), (Join-Path $Scelta "Profiles\Charts"), (Join-Path $Scelta "config"))
  foreach($d in $DirParam){ $FotoDirP[$d] = FotoDir $d }
  $FotoPrese = $true
  $FilesTxt = "MQL5\Files della cartella scelta PRIMA: " + (FotoDir (Join-Path $Scelta "MQL5\Files")) + "  (questa riga NON ci scrive: ci scrivera' l'EA, quando lo attaccherai a un grafico)"
  Dico ($EA + ".mq5 nel reale: " + (FotoTxt $FotoP[$DestMq5]))
  Dico ($EA + ".ex5 nel reale: " + (FotoTxt $FotoP[$DestEx5]))

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
    $BackupDir = Join-Path (Join-Path $Dsk ("backup_slippagelogger_" + $Avvio.ToString("yyyyMMdd",$INV))) $Avvio.ToString("HHmmss",$INV)
    New-Item -ItemType Directory -Force -Path $BackupDir | Out-Null
    $bk = New-Object System.Collections.ArrayList
    foreach($p in $Due){
      if(Test-Path -LiteralPath $p){
        Copy-Item -LiteralPath $p -Destination (Join-Path $BackupDir (Split-Path -Leaf $p)) -Force
        [void]$bk.Add((Split-Path -Leaf $p) + ": " + (Descrivi $p))
      }
      else{ [void]$bk.Add((Split-Path -Leaf $p) + ": non c'era (il ripristino lo togliera')") }
    }
    Set-Content -LiteralPath (Join-Path $BackupDir "BACKUP_ORIGINE.txt") -Value (@("backup del " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV), "cartella dati: " + $Scelta, "conto atteso: " + $LoginAtteso) + @($bk)) -Encoding ASCII
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
        Remove-Item -LiteralPath $Sentinella -Force -ErrorAction SilentlyContinue
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
      Remove-Item -LiteralPath $Sentinella -Force -ErrorAction SilentlyContinue
    }
    else{
      $Compilato = "FALLITA (" + $ResultTxt + ")"
      $Ripristino = (RipristinaDaBackup $BackupDir $Due) -join "; "
      [void]$Problemi.Add("compilazione fallita: nessun .ex5 fresco. " + $ResultTxt)
      $InstallTxt = "TENTATA E RIPRISTINATA"
      Remove-Item -LiteralPath $Sentinella -Force -ErrorAction SilentlyContinue
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
  if($FotoPrese -and @($Due).Count -eq 2){
    foreach($p in $Due){
      $dopo = Foto $p
      [void]$FotoDopo.Add("REALE " + $p + "   prima [" + (FotoTxt $FotoP[$p]) + "]   dopo [" + (FotoTxt $dopo) + "]   -> " + (Confronta $FotoP[$p] $dopo))
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
    if($FotoDopo.Count -eq 0){ [void]$FotoDopo.Add("REALE: nessuna foto scattata (il giro si e' fermato prima del punto 4)") }
  }
  # I TERMINALI DEI CONTI DEMO: tre stati, e la foto di un file che non
  # c'e' NON e' una prova (classe 117)
  $vere = 0; $cambiate = 0
  foreach($f in $FotoDemo){
    $f.Dopo = Foto $f.Percorso
    if($f.Prima.Esiste -or $f.Dopo.Esiste){ $vere++ }
    if((Confronta $f.Prima $f.Dopo) -eq "CAMBIATO"){ $cambiate++ }
  }
  if($cambiate -gt 0){
    $DemoTxt = "ATTENZIONE: " + $cambiate + " file sotto una cartella di un conto DEMO RISULTANO CAMBIATI"
    [void]$Problemi.Add($DemoTxt)
  }
  elseif($vere -gt 0){ $DemoTxt = "INVARIATO su " + $vere + " foto di file REALMENTE PRESENTI nelle cartelle dei conti demo" }
  else{ $DemoTxt = "NON MISURATO (nessun file vero da fotografare sotto le cartelle dei conti demo). Il perimetro qui regge PER COSTRUZIONE -- questa riga scrive solo sotto la cartella scelta -- ma non e' misurato, e non si regala un verde (classe 117)." }

  # IL MODO STA NEL NOME DEL REFERTO, non solo in quello dello zip
  # (classe 132): due referti che si somigliano riga per riga, con lo
  # stesso nome, si cancellano a vicenda scompattando i due zip.
  $ReferTxt = Join-Path $Work ("REFERTO_SLIPPAGELOGGER_INSTALLA_" + $Modo + ".txt")
  $r = New-Object System.Collections.ArrayList
  [void]$r.Add("=====================================================================")
  [void]$r.Add("  INSTALLAZIONE DI " + $EA + " v" + $VersioneAttesa + " -- logger dello slippage vero (SOLA LETTURA)")
  [void]$r.Add("=====================================================================")
  $esitoGiro = "COMPLETATO (nessun gate ha fermato il giro)"
  if($Fatale -ne ""){ $esitoGiro = "FERMATO da un gate: " + $Fatale }
  if($Fatale -eq "" -and $Problemi.Count -gt 0){ $esitoGiro = "ARRIVATO IN FONDO MA CON " + $Problemi.Count + " PROBLEMI: leggi la riga INSTALLAZIONE e l'elenco PROBLEMI qui sotto PRIMA di attaccare l'EA" }
  [void]$r.Add("ESITO DEL GIRO: " + $esitoGiro)
  [void]$r.Add("data: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   (E' L'ORA DI AVVIO DI QUESTO GIRO, non l'ora attuale)")
  [void]$r.Add("modo: " + $Modo + "     macchina: " + $env:COMPUTERNAME + "     sessione: " + $env:USERNAME)
  [void]$r.Add("pin : " + $Pin)
  [void]$r.Add("")
  [void]$r.Add("CONTO ATTESO (-LoginAtteso): " + $LoginAtteso)
  [void]$r.Add("CONTI VIETATI PER SEMPRE ..: " + ($VIETATI_CONTI -join ", ") + "   (i due demo: li' lo slippage non e' simulato)")
  [void]$r.Add("guardia sul conto .........: " + $ContoTxt)
  [void]$r.Add($BasiTxt)
  [void]$r.Add("cartella dati scelta ......: " + $Scelta)
  [void]$r.Add("criterio di scelta ........: " + $Criterio)
  [void]$r.Add("installazione (compilatore): " + $Inst)
  [void]$r.Add("")
  [void]$r.Add("sorgente al pin ....: " + $SorgTxt)
  [void]$r.Add("versione letta .....: " + $VersLetta + "   (attesa " + $VersioneAttesa + ")")
  [void]$r.Add("autotest dichiarato : " + $DefineTxt)
  [void]$r.Add("token vietati ......: " + $VietatiTxt)
  [void]$r.Add("input della guardia : " + $RichTxt)
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
  [void]$r.Add("I TERMINALI DEI CONTI DEMO: " + $DemoTxt)
  foreach($f in $FotoDemo){ [void]$r.Add("   DEMO " + $f.Percorso + "   prima [" + (FotoTxt $f.Prima) + "]   dopo [" + (FotoTxt $f.Dopo) + "]   -> " + (Confronta $f.Prima $f.Dopo)) }
  [void]$r.Add("PARAMETRI (.set/.chr/.ini): " + $ParamTxt)
  [void]$r.Add($FilesTxt)
  foreach($x in $FotoDopo){ [void]$r.Add($x) }
  [void]$r.Add("")
  [void]$r.Add("COSA SUCCEDE DOPO (lo fa Claudio a mano, non questa riga):")
  [void]$r.Add("  1. in MT5 del conto REALE: Navigatore > Expert Advisors > tasto destro >")
  [void]$r.Add("     Aggiorna; deve comparire " + $EA + ".")
  [void]$r.Add("  2. File > Nuovo grafico (un grafico NUOVO, mai uno che ha gia' un EA:")
  [void]$r.Add("     un grafico tiene UN SOLO Expert Advisor e attaccare il logger su una")
  [void]$r.Add("     sedia viva la SOSTITUIREBBE).")
  [void]$r.Add("  3. trascina " + $EA + " su quel grafico e nella finestra degli input METTI")
  [void]$r.Add("     InpLoginAtteso = " + $LoginAtteso + "   <-- E' LA SECONDA SERRATURA: se il")
  [void]$r.Add("     terminale non e' quel conto, l'EA NON PARTE e lo scrive in Esperti.")
  [void]$r.Add("     Gli altri input si lasciano come sono.")
  [void]$r.Add("  4. scheda ESPERTI: deve comparire '" + $MarcatoreEA + "', la riga")
  [void]$r.Add("     '[SLIPLOG] AUTOTEST: " + $BLOCCHI_ATTESI + " blocchi ... " + $CASI_ATTESI + " casi ... 0 falliti'")
  [void]$r.Add("     e la riga del conto col suo tipo (deve dire REALE).")
  [void]$r.Add("  5. lo lasci girare mentre le due sedie lavorano; poi si lancia la riga di")
  [void]$r.Add("     RACCOLTA (RIGA_SLIPPAGELOGGER_RACCOLTA.ps1), che NON tocca il terminale.")
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
  $zip = Join-Path $Dsk ("SLIPPAGELOGGER_INSTALLA_" + $Modo + "_" + $Stamp + ".zip")
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
