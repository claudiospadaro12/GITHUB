# =====================================================================
#  MARCATORE_RIGA_DEPLOY_ORB104_PICCOLO_v2
#  RIGA_DEPLOY_ORB104_PICCOLO.ps1 -- DEPLOY della v1.04 di
#  ABTG_ORB_Ottimizzato sul SOLO terminale del conto PICCOLO 50503392,
#  sul VPS, sessione Master.
#
#  E' il PASSO 2 della sequenza FIRMATA da Claudio il 03/09 alle 11:05
#  ("FIRMO IL PERIMETRO PICCOLO", verbale report/FIRME_2026-09-03.md):
#    1) si vede COMPILARE la v1.04 fuori dal terminale vivo
#       -> FATTO il 03/09 alle 14:18, 0 errori 0 warning
#          (risultati_archivio/REFERTO_COMPILA_ORB104_2026-09-03.txt)
#    2) SOLO se 0 errori, deploy sul SOLO conto piccolo    <-- QUESTO
#  Il terminale 100k (-V3, conto 50504263) resta INTATTO fino a fine
#  Fase 1: questa riga NON lo tocca, e lo DIMOSTRA con una foto
#  (esiste? quanti byte? che data?) di ogni sua copia dei tre file,
#  presa PRIMA e RIFATTA DOPO -- non con una frase.
#
#  >>> PERCHE' NON aggiorna_verifica_orb.ps1 (22/08): quello script
#      aggiorna ENTRAMBE le istanze (piccolo E -V3) e ha -VersioneAttesa
#      con default 1.02. Viola il perimetro firmato: non si lancia e non
#      si modifica (resta agli atti com'era). Questa e' una riga NUOVA,
#      col perimetro dentro.
#
#  >>> COSA SCRIVE, E DOVE (in modo CORSA, e SOLO li'):
#        <cartella dati del PICCOLO>\MQL5\Experts\ABTG_ORB_Ottimizzato.mq5
#        <cartella dati del PICCOLO>\MQL5\Experts\ABTG_ORB_Ottimizzato.ex5
#        <cartella dati del PICCOLO>\MQL5\Include\ABTG_PausaGuardian.mqh
#        (+ il log di MetaEditor nella cartella di lavoro)
#      NIENT'ALTRO: nessun .set, nessun .ini, nessun .chr, nessun
#      profilo. I parametri restano quelli salvati nel grafico (rischio
#      1,0% sul piccolo). Lo dimostra un'altra foto: conteggio e byte
#      totali di Presets\, Profiles\Charts\ e config\ prima e dopo.
#
#  >>> IN MODO CONTROLLO (default) NON SCRIVE NIENTE NEL TERMINALE, e lo
#      dice: scarica al pin nella cartella di lavoro, passa i gate sul
#      sorgente, individua la cartella dati del piccolo, fotografa
#      tutto, e si ferma PRIMA del backup. Serve a vedere CHE COSA
#      farebbe la CORSA, con l'elenco delle cartelle guardate.
#
#  >>> LA CARTELLA DATI DEL PICCOLO SI SCEGLIE PER FATTI, MAI PER NOME
#      (classe 115): si scandisce LARGO (cartelle dati di tutti i
#      profili, installazioni in Program Files per il caso portable,
#      processi vivi) e si sceglie STRETTO. I fatti, in ordine:
#        1. la cartella dati ha bases\BCMMarkets-Server (e' il feed
#           vero del broker);
#        2. NESSUNA traccia del 100k: ne' "-V3" nell'origin.txt o nel
#           percorso, ne' il login 50504263 nei log;
#        3. il login 50503392 nei log degli ultimi 45 giorni: e' la
#           CONFERMA. Se manca e' un RILIEVO dichiarato, non un blocco
#           (un terminale connesso da settimane puo' non avere una riga
#           di login recente);
#        4. la cartella sta sotto il PROFILO DI QUESTA SESSIONE (%APPDATA%):
#           il terminale gira sotto l'utente che lo lancia, e il piccolo
#           gira sotto Master (misurato al PASSO 1: C:\Users\Master\...).
#           Il 100k gira sotto Administrator (HANDOFF 03/09), e sotto
#           quel profilo puo' esserci anche una copia della stessa
#           installazione: passa i fatti 1-3 ma NON si sceglie da sola.
#      Se le candidate scelte in automatico sono ZERO o PIU' DI UNA, non
#      si indovina: ci si ferma stampando l'ELENCO COMPLETO (con dentro
#      login visti, origin.txt, bases, profilo) e la manopola -CartellaDati.
#      La manopola NON salta i controlli: la cartella imposta passa gli
#      stessi gate, e se non li passa la riga si ferma dicendo perche'.
#
#  >>> IL BACKUP PRIMA DI OGNI SCRITTURA, e il RIPRISTINO su fallimento:
#      i tre file del piccolo vanno in Desktop\backup_orb_v102_<data>\
#      <ora>\ (verificati per byte e sha256). Se la compilazione
#      FALLISCE, i tre file tornano com'erano (verificato per sha256) e
#      il referto lo dice con quel nome: RIPRISTINATO. Sentinella
#      (classe 116): scritta PRIMA della prima scrittura nel terminale,
#      con dentro dove sta il backup; se un giro viene interrotto a
#      mano, il giro dopo la trova e rimette a posto (in CORSA) o lo
#      dichiara come PROBLEMA (in CONTROLLO, che non scrive).
#
#  >>> IL VERDETTO STA SULL'ARTEFATTO, NON SUL CODICE DI USCITA (classe
#      108): metaeditor64 sul VPS torna 1 anche quando compila (e' il
#      numero di file compilati; misurato il 03/09). Decidono l'.ex5
#      FRESCO e la riga "Result: N errors, M warnings" del log (UTF-16).
#
#  >>> IL CAMPO compilazione: HA QUATTRO STATI e si timbra sul ramo che
#      lo decide (classe 94-ter): NON TENTATA / FALLITA (con ripristino)
#      / FALLITA -- METAEDITOR MUTO (con ripristino) / OK (... KB).
#
#  >>> LA GUARDIA: in CORSA si PRETENDONO terminal64 E metaeditor64
#      CHIUSI, e ci si ferma PRIMA di toccare qualunque cosa. Non e' un
#      vezzo: la ricompilazione scarica l'EA dai grafici, e una posizione
#      ORB aperta resterebbe senza gestione; e con l'editor aperto la
#      compilazione da riga di comando torna muta (22/08). In CONTROLLO
#      un MT5 aperto e' TOLLERATO e dichiarato (non si scrive niente).
#
#  QUANTO CI METTE [STIMA, non una previsione]: scansione delle cartelle
#  + 2 download + 1 compilazione = 1-3 minuti.
#
#  LA RIGA CHE SI INCOLLA sta in righe\RIGA_DEPLOY_ORB104_PICCOLO_DA_MANDARE.md
# =====================================================================
[CmdletBinding()]
param(
  # -Pin NON ha default: un default silenzioso ("lavoro") farebbe girare
  #  la punta del branch spacciandola per un commit congelato.
  [string]$Pin = "",
  [ValidateSet("CONTROLLO","CORSA")]
  [string]$Modo = "CONTROLLO",
  # -CartellaDati: si usa SOLO se la scelta automatica si ferma perche'
  #  non ha UN fatto per decidere (classe 115). La riga stampa l'elenco
  #  e il percorso da incollare qui. Passa gli stessi gate.
  [string]$CartellaDati = "",
  [int]$TimeoutSec = 120
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

$EA             = "ABTG_ORB_Ottimizzato"
$IncNostro      = "ABTG_PausaGuardian.mqh"
$VersioneAttesa = "1.04"
$BLOCCHI_ATTESI = 10
$CASI_ATTESI    = 33
$CONTO_PICCOLO  = "50503392"
$CONTO_GRANDE   = "50504263"
$BASE_BCM       = "BCMMarkets-Server"

$Avvio = Get-Date
$Stamp = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
# IL DESKTOP SI CERCA, NON SI ASSUME (OneDrive sposta il Desktop vero):
# le stesse tre righe stanno nel blocco di lancio (classe 116-bis).
function TrovaDesktop(){
  foreach($p in @([Environment]::GetFolderPath("Desktop"),
                  (Join-Path $env:USERPROFILE "Desktop"),
                  (Join-Path $env:USERPROFILE "OneDrive\Desktop"))){
    if($p -and (Test-Path -LiteralPath $p)){ return $p }
  }
  return $env:USERPROFILE
}
$Dsk        = TrovaDesktop
$Work       = Join-Path $env:USERPROFILE "abtg_deploy_orb104"
$Scaricati  = Join-Path $Work "scaricati"
$Sentinella = Join-Path $Work "DEPLOY_ORB104_IN_CORSO.txt"
$RawPin     = ""

# --- tutto cio' che la raccolta usa nasce QUI, prima del try: la
#     raccolta gira SEMPRE, e ogni campo parte da uno stato VERO ("non
#     ci siamo arrivati"), mai da uno stato che somigli a un risultato.
$Problemi   = New-Object System.Collections.ArrayList
$Rilievi    = New-Object System.Collections.ArrayList
$Cand       = New-Object System.Collections.ArrayList
$Fatale     = ""
$Compilato  = "NON TENTATA (non ci siamo arrivati)"
$DeployTxt  = "NON AVVENUTO (il giro si e' fermato prima di scrivere nel terminale)"
$BackupTxt  = "NON FATTO (non ci siamo arrivati)"
$Ripristino = "niente da ripristinare (il terminale non e' mai stato scritto)"
$ScrittiTxt = "NESSUNA SCRITTURA nel terminale"
$Scelta     = "NON SCELTA"
$Criterio   = "n/d"
$Inst       = "n/d"
$Me         = ""
$SorgTxt    = "NON SCARICATO"
$IncTxt     = "NON SCARICATO"
$VersLetta  = "NON LETTA"
$VersPrima  = "NON LETTA"
$DefineTxt  = "NON LETTI"
$IncluTxt   = "NON CENSITI"
$SelTxt     = "NON ESEGUITO"
$ResultTxt  = "NON LETTA"
$RcTxt      = "NON LETTO"
$LogRighe   = @()
$FotoPrese  = $false
$FotoDopoTxt = New-Object System.Collections.ArrayList
$V3Txt      = "NON VERIFICATO (non ci siamo arrivati)"
$ParamTxt   = "NON VERIFICATO (non ci siamo arrivati)"
$ScrittoNelTerminale = $false
$BackupDir  = ""
$Piccolo    = $null
$V3Cand     = @()
$LogPath    = Join-Path $Work "COMPILAZIONE.log"
$Ex5Nuovo   = ""
$Tre        = @()
$FotoP      = @{}
$FotoV3     = New-Object System.Collections.ArrayList
$DirParam   = @()
$FotoDirP   = @{}
$righeC     = New-Object System.Collections.ArrayList
[void]$righeC.Add("CARTELLE GUARDATE: nessuna scansione (il giro si e' fermato prima di cercare la cartella dati)")

function Ora(){ return (Get-Date).ToString("HH:mm:ss", $INV) }
function Dico([string]$t,[string]$c="Gray"){ Write-Host ("[" + (Ora) + "] " + $t) -ForegroundColor $c }
function Titolo([string]$t){ Write-Host ""; Write-Host ("=== " + $t + " ===") -ForegroundColor Cyan }

function Scarica([string]$url,[string]$dest){
  Remove-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue
  # -OutFile scrive i BYTE come arrivano: il .mq5 e' UTF-8 e non va
  # ri-codificato (un Get-Content/Set-Content lo storpierebbe).
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
# Esistenza e lunghezza sono il test forte; la data e' un test debole.
function Foto([string]$path){
  if($path -eq "" -or $null -eq $path){ return [pscustomobject]@{ Esiste=$false; Len=-1; Ora="ASSENTE"; Hash="" } }
  if(-not (Test-Path -LiteralPath $path)){ return [pscustomobject]@{ Esiste=$false; Len=-1; Ora="ASSENTE"; Hash="" } }
  $i = Get-Item -LiteralPath $path
  return [pscustomobject]@{ Esiste=$true; Len=$i.Length; Ora=$i.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss",$INV); Hash=(Hash16 $path) }
}
function FotoTxt($f){
  if(-not $f.Esiste){ return "ASSENTE" }
  return ("presente, " + $f.Len + " byte, sha256 " + $f.Hash + ", " + $f.Ora)
}
function Confronta($a,$b){
  if($a.Esiste -ne $b.Esiste -or $a.Len -ne $b.Len -or $a.Hash -ne $b.Hash){ return "CAMBIATO" }
  if($a.Ora -ne $b.Ora){ return "stessi byte, data diversa" }
  return "INVARIATO"
}
# FOTO DI UNA CARTELLA (per .set/.chr/.ini): quanti file, quanti byte,
# ultima scrittura. Se cambia una di queste tre cose, qualcosa e' stato
# scritto li' dentro.
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

# Legge un file di testo qualunque sia la codifica (log di MetaEditor e
# del terminale: UTF-16LE col BOM).
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

function CensisciInclude([string]$path){
  $trovati = New-Object System.Collections.ArrayList
  foreach($riga in (LeggiTesto $path)){
    $viva = ($riga -replace '//.*$','')
    $m = [regex]::Match($viva, '^\s*#include\s*[<"]([^>"]+)[>"]')
    if($m.Success){ [void]$trovati.Add($m.Groups[1].Value.Trim()) }
  }
  return @($trovati)
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

# UNA COMPILAZIONE. Torna @{ Ex5=bool; Rc=<oggetto>; Log=<righe>; Muto=bool }.
function Compila([string]$exe,[string[]]$argomenti,[string]$ex5,[string]$log,[int]$tetto){
  Remove-Item -LiteralPath $log -Force -ErrorAction SilentlyContinue
  $t0 = Get-Date
  Dico ("metaeditor64: " + $exe + " " + ($argomenti -join " ")) "Yellow"
  $global:LASTEXITCODE = $null
  # il campo si timbra PRIMA del lancio (classe 94-ter): se l'invocazione
  # stessa esplode, il referto non deve dire "non tentata".
  $script:Compilato = "FALLITA -- METAEDITOR NON PARTITO (eccezione al lancio di " + $exe + ": vedi la riga FERMATO)"
  # INVOCAZIONE DIRETTA: e' PowerShell a quotare ogni argomento (i path
  # hanno gli spazi di "Program Files"). MAI Start-Process con la
  # stringa di argomenti montata a mano: 22/08, rc=0 e zero compilazioni.
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

# RIPRISTINO dei tre file del piccolo dal backup, verificato per sha256.
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
      # nel backup non c'era = prima del giro NON esisteva: si toglie.
      Remove-Item -LiteralPath $d -Force -ErrorAction SilentlyContinue
      [void]$esiti.Add($nome + ": rimosso (prima del giro non c'era)")
    }
  }
  return @($esiti)
}

try{
  Titolo ("DEPLOY v" + $VersioneAttesa + " di " + $EA + " sul SOLO PICCOLO " + $CONTO_PICCOLO + " -- modo " + $Modo)
  if($Modo -eq "CONTROLLO"){ Write-Host "MODO CONTROLLO: questo giro NON scrive niente nel terminale. Mostra cosa farebbe la CORSA." -ForegroundColor Yellow }
  else{ Write-Host "MODO CORSA: scrive SOLO nella cartella dati del piccolo, con backup e ripristino su fallimento. Il -V3 non si tocca (misurato)." -ForegroundColor Yellow }

  # -------------------------------------------------------------------
  #  0. LE GUARDIE -- prima di toccare qualunque cosa
  # -------------------------------------------------------------------
  if($Pin -eq ""){ throw "-Pin obbligatorio: senza, girerebbe la punta del branch spacciandola per un commit congelato." }
  if($Pin -notmatch '^[0-9a-f]{40}$'){ throw ("-Pin deve essere un commit di 40 caratteri esadecimali, ricevuto: " + $Pin) }
  $RawPin = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/" + $Pin
  $vivi = @(Get-Process -Name terminal64,metaeditor64 -ErrorAction SilentlyContinue)
  if($vivi.Count -gt 0){
    $el = @($vivi | ForEach-Object { $_.ProcessName + " pid " + $_.Id }) -join ", "
    if($Modo -eq "CORSA"){
      throw ("MT5 O METAEDITOR APERTI (" + $el + "): in CORSA si pretendono CHIUSI, e mi fermo PRIMA di toccare qualunque cosa. La ricompilazione scarica l'EA dai grafici (una posizione ORB aperta resterebbe senza gestione) e con l'editor aperto MetaEditor torna muto (22/08). Chiudi MT5 e MetaEditor sul VPS e rilancia -- quando la flotta e' ferma (dopo le 22:15 IT o prima delle 07:30 IT).")
    }
    [void]$Rilievi.Add("processi aperti durante il CONTROLLO (" + $el + "): TOLLERATO qui, perche' questo giro non scrive niente. La CORSA li pretende CHIUSI e si ferma da sola.")
  }
  else{ Dico "terminal64 e metaeditor64: nessun processo vivo (misurato)" "Green" }
  if($Modo -eq "CORSA"){
    $hm = $Avvio.Hour*60 + $Avvio.Minute
    if($hm -ge (7*60+30) -and $hm -lt (22*60+15)){
      [void]$Rilievi.Add("ora di avvio " + $Avvio.ToString("HH:mm",$INV) + " (orologio del VPS): dentro la finestra in cui la flotta di solito lavora (07:30-22:15 IT). MT5 e' chiuso (misurato), quindi la flotta e' ferma per costruzione: dichiarato, non un blocco.")
    }
  }
  Dico ("pin ......... " + $Pin)
  Dico ("cartella di lavoro: " + $Work)

  # -------------------------------------------------------------------
  #  1. CARTELLA DI LAVORO + SENTINELLA di un giro interrotto
  # -------------------------------------------------------------------
  Titolo "1. CARTELLA DI LAVORO (scaricati\ rifatta da zero) e SENTINELLA"
  New-Item -ItemType Directory -Force -Path $Work | Out-Null
  if(Test-Path -LiteralPath $Scaricati){ Remove-Item -LiteralPath $Scaricati -Recurse -Force }
  New-Item -ItemType Directory -Force -Path $Scaricati | Out-Null
  Remove-Item -LiteralPath $LogPath -Force -ErrorAction SilentlyContinue
  if(Test-Path -LiteralPath $Sentinella){
    # riga 1..3: i tre file di destinazione; riga 4: la cartella del backup
    $rs = @(Get-Content -LiteralPath $Sentinella -ErrorAction SilentlyContinue)
    $sDest = @()
    $sBack = ""
    if(@($rs).Count -ge 4){ $sDest = @($rs[0].Trim(), $rs[1].Trim(), $rs[2].Trim()); $sBack = ("" + $rs[3]).Trim() }
    if($Modo -eq "CORSA" -and $sDest.Count -eq 3 -and $sBack -ne "" -and (Test-Path -LiteralPath $sBack)){
      $es = RipristinaDaBackup $sBack $sDest
      Remove-Item -LiteralPath $Sentinella -Force -ErrorAction SilentlyContinue
      [void]$Rilievi.Add("UN GIRO PRECEDENTE ERA STATO INTERROTTO fra backup e fine: i tre file del piccolo sono stati RIMESSI dal backup " + $sBack + " adesso, all'avvio (" + ($es -join "; ") + "). Il terminale riparte com'era prima di quel giro.")
      Dico "sentinella di un giro interrotto: file rimessi dal backup" "Yellow"
    }
    else{
      [void]$Problemi.Add("SENTINELLA DI UN GIRO INTERROTTO trovata (" + $Sentinella + "): un giro precedente e' stato fermato a mano fra il backup e la fine, e i tre file del piccolo potrebbero essere a meta'. Questo giro in " + $Modo + " NON scrive nel terminale: rilancia in CORSA (rimette a posto da solo dal backup " + $sBack + ") oppure ripristina a mano.")
      if($Modo -eq "CORSA"){ throw ("SENTINELLA ILLEGGIBILE o backup mancante (" + $sBack + "): non tocco il terminale finche' non e' chiaro cosa c'e' dentro. Guarda " + $Sentinella + " e il backup a mano.") }
    }
  }

  # -------------------------------------------------------------------
  #  2. SCARICO AL PIN + GATE SUL SORGENTE (identita' della v1.04)
  # -------------------------------------------------------------------
  Titolo "2. SCARICO AL PIN E GATE SUL SORGENTE (versione, autotest, difetto curato, include)"
  $Mq5 = Join-Path $Scaricati ($EA + ".mq5")
  $Mqh = Join-Path $Scaricati $IncNostro
  Scarica ($RawPin + "/mql5/Experts/" + $EA + ".mq5") $Mq5
  Scarica ($RawPin + "/mql5/Include/" + $IncNostro) $Mqh
  $SorgTxt = $EA + ".mq5: " + (Descrivi $Mq5)
  $IncTxt  = $IncNostro + ": " + (Descrivi $Mqh)
  Dico ("scaricato " + $SorgTxt) "Green"
  Dico ("scaricato " + $IncTxt) "Green"

  $righeMq5 = LeggiTesto $Mq5
  $testoMq5 = ($righeMq5 -join "`n")
  $mv = [regex]::Match($testoMq5, '#property\s+version\s+"([^"]+)"')
  if(-not $mv.Success){ throw "nel sorgente scaricato non c'e' nessun #property version: non e' il file che credo." }
  $VersLetta = $mv.Groups[1].Value
  if($VersLetta -ne $VersioneAttesa){
    throw ("VERSIONE SBAGLIATA: il sorgente al pin e' la v" + $VersLetta + ", attesa la v" + $VersioneAttesa + ". Il pin non contiene il fix 19312c8: NON installo.")
  }
  $mb = [regex]::Match($testoMq5, 'ORBOTT_AUTOTEST_BLOCCHI_ATTESI\s+(\d+)')
  $mc = [regex]::Match($testoMq5, 'ORBOTT_AUTOTEST_CASI_ATTESI\s+(\d+)')
  if(-not ($mb.Success -and $mc.Success)){ throw "nel sorgente non trovo i #define dell'autotest (ORBOTT_AUTOTEST_BLOCCHI_ATTESI / _CASI_ATTESI): non e' la v1.04 attesa." }
  $nBlocchi = [int]::Parse($mb.Groups[1].Value, $INV)
  $nCasi    = [int]::Parse($mc.Groups[1].Value, $INV)
  $DefineTxt = "" + $nBlocchi + " blocchi / " + $nCasi + " casi (dai #define del sorgente)"
  if($nBlocchi -ne $BLOCCHI_ATTESI -or $nCasi -ne $CASI_ATTESI){
    throw ("SORGENTE DIVERSO DAL FIX FIRMATO: i #define dell'autotest dicono " + $DefineTxt + ", attesi " + $BLOCCHI_ATTESI + " blocchi / " + $CASI_ATTESI + " casi (v1.04, commit 19312c8). NON installo.")
  }
  foreach($tok in @("ScegliTicketMio_Calc","ElencaTicketMiei_Calc","PosMia_Calc","ORB SELEZIONE:")){
    if($testoMq5 -notmatch [regex]::Escape($tok)){
      throw ("SORGENTE DIVERSO DAL FIX FIRMATO: nel file al pin manca '" + $tok + "', pezzo dichiarato della v1.04 (nucleo di selezione hedge-safe). NON installo.")
    }
  }
  $nSel = 0
  foreach($riga in $righeMq5){
    $viva = ($riga -replace '//.*$','')
    if($viva -match 'PositionSelect\s*\(\s*_Symbol'){ $nSel++ }
  }
  $SelTxt = "" + $nSel + " occorrenze di PositionSelect(_Symbol) fuori dai commenti (attese 0)"
  if($nSel -gt 0){
    throw ("IL FIX NON E' COMPLETO NEL SORGENTE AL PIN: " + $SelTxt + ". NON installo: porterebbe in forward il difetto che il round sta curando.")
  }
  Dico ("versione " + $VersLetta + " | autotest " + $DefineTxt + " | " + $SelTxt) "Green"

  $inclusi = CensisciInclude $Mq5
  $nostri  = @($inclusi | Where-Object { $_ -match '(^|/|\\)ABTG_' })
  $altri   = @($inclusi | Where-Object { $_ -notmatch '(^|/|\\)ABTG_' })
  $IncluTxt = "" + @($inclusi).Count + " (" + (@($inclusi) -join ", ") + ")"
  foreach($n in $nostri){
    $nudo = ($n -split '[\\/]')[-1]
    if($nudo -ne $IncNostro){
      throw ("INCLUDE NOSTRO NON PREVISTO: il sorgente al pin chiede '" + $n + "', che questa riga NON scarica (giro a vuoto del 22/08). Aggiungerlo alla riga e ri-pinnare.")
    }
  }
  $inclDentro = CensisciInclude $Mqh
  foreach($n in @($inclDentro)){
    $nudo = ($n -split '[\\/]')[-1]
    if($nudo -match '^ABTG_' -and $nudo -ne $IncNostro){
      throw ("L'INCLUDE " + $IncNostro + " ne chiede un altro NOSTRO ('" + $n + "') che questa riga non scarica: mi fermo prima di installare.")
    }
  }
  $testoMqh = ((LeggiTesto $Mqh) -join "`n")
  # ancorato sulla parentesi (classe 116-ter): un nome rinominato non passa.
  if($testoMqh -notmatch 'bool\s+ABTG_GuardiaIngresso\s*\('){
    throw ("l'include scaricato al pin non definisce ABTG_GuardiaIngresso(...): la v1.04 lo chiama, non compilerebbe.")
  }
  Dico ("include censiti nel sorgente: " + $IncluTxt) "Green"

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
    # traccia del 100k: "-V3" e' l'etichetta di casa (convenzione, usata
    # SOLO per escludere), il login 50504263 e' il fatto.
    $tr = New-Object System.Collections.ArrayList
    if($c.Origin -like "*-V3*"){ [void]$tr.Add("origin.txt contiene -V3") }
    if($c.Percorso -like "*-V3*"){ [void]$tr.Add("percorso contiene -V3") }
    if($c.VistoGrande){ [void]$tr.Add("login " + $CONTO_GRANDE + " nei log") }
    $c.TracciaV3 = (@($tr) -join "; ")
    # IL PROFILO DI QUESTA SESSIONE e' un fatto del sistema: il terminale
    # del piccolo gira sotto l'utente che lo ha lanciato (Master, misurato
    # al PASSO 1: cartella dati sotto C:\Users\Master). Una cartella
    # eleggibile sotto un ALTRO profilo (o portable) non si sceglie da sola:
    # si elenca, e si impone solo con -CartellaDati.
    if($env:APPDATA){ $c.Profilo = $c.Percorso.StartsWith(($env:APPDATA.TrimEnd("\")), [System.StringComparison]::OrdinalIgnoreCase) }
    if(-not $c.HaMql){ $c.Scarto = "nessuna cartella MQL5\ (installazione non portable: i dati stanno altrove)"; continue }
    if(-not $c.BaseBcm){ $c.Scarto = "nessuna bases\" + $BASE_BCM + " (non e' il feed BCM)"; continue }
    if($c.TracciaV3 -ne ""){ $c.Scarto = "E' IL 100k/-V3 (" + $c.TracciaV3 + "): fuori dal perimetro firmato"; continue }
    $c.Eleggibile = $true
    if(-not $c.Profilo){ $c.Scarto = "eleggibile per i fatti, ma sotto un ALTRO profilo utente (questa sessione e' " + $env:USERNAME + ", APPDATA " + $env:APPDATA + "): non scelta da sola. Se e' davvero il piccolo, imponila con -CartellaDati" }
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
    if($imp.Count -eq 0){ throw ("-CartellaDati '" + $CartellaDati + "' non esiste o non ha nessuna traccia di un terminale (logs\, MQL5\, terminal64.exe): non la uso.") }
    if(-not $imp[0].Eleggibile){ throw ("-CartellaDati '" + $CartellaDati + "' NON passa i gate: " + $imp[0].Scarto + ". La manopola non salta i controlli: mi fermo.") }
    $Piccolo = $imp[0]
    $Criterio = "IMPOSTA A MANO con -CartellaDati, e ha passato gli stessi gate (bases\" + $BASE_BCM + ", nessuna traccia del 100k)"
    if(-not $Piccolo.Profilo){ [void]$Rilievi.Add("la cartella imposta con -CartellaDati sta sotto un ALTRO profilo utente rispetto a questa sessione (" + $env:USERNAME + "): l'hai scelta tu, e' dichiarato.") }
  }
  elseif($auto.Count -eq 1){
    $Piccolo = $auto[0]
    $Criterio = "FATTO: unica cartella dati sotto il profilo di questa sessione (" + $env:USERNAME + ") con bases\" + $BASE_BCM + " e SENZA traccia del 100k (ne' -V3 ne' login " + $CONTO_GRANDE + ")"
    if($eleg.Count -gt 1){
      $altre = @($eleg | Where-Object { -not $_.Profilo } | ForEach-Object { $_.Percorso }) -join " | "
      [void]$Rilievi.Add("altre " + ($eleg.Count - 1) + " cartelle passano i fatti ma stanno sotto un ALTRO profilo utente, e NON sono state toccate: " + $altre + ". Se il piccolo fosse una di quelle, questo giro ha scritto nella cartella sbagliata: controlla il percorso scelto.")
    }
  }
  elseif($auto.Count -eq 0 -and $eleg.Count -ge 1){
    throw ("NON SO QUALE CARTELLA DATI E' IL PICCOLO (classe 115): " + $eleg.Count + " cartelle passano i fatti ma NESSUNA sta sotto il profilo di questa sessione (" + $env:USERNAME + ", APPDATA " + $env:APPDATA + "). O sei nella sessione sbagliata (il piccolo gira sotto Master, misurato al PASSO 1), o e' portable. L'elenco e' qui sopra e nel referto: se e' davvero quella, rilancia LO STESSO blocco aggiungendo al driver -CartellaDati ""<percorso>"".")
  }
  else{
    throw ("NON SO QUALE CARTELLA DATI E' IL PICCOLO (classe 115: eleggibili sotto questo profilo " + $auto.Count + ", ne serve 1). L'elenco completo di cosa ho guardato e' qui sopra e nel referto. Rilancia LO STESSO blocco aggiungendo al driver: -CartellaDati ""<percorso della cartella dati del piccolo>"".")
  }
  if($Piccolo.VistoPiccolo){ $Criterio = $Criterio + "; login " + $CONTO_PICCOLO + " CONFERMATO nei log" }
  else{
    [void]$Rilievi.Add("il login " + $CONTO_PICCOLO + " NON compare nei log degli ultimi 45 giorni della cartella scelta (" + $Piccolo.Percorso + "): la scelta si regge su bases\" + $BASE_BCM + " + assenza di tracce del 100k. Dichiarato.")
  }
  $Scelta = $Piccolo.Percorso
  # l'installazione (metaeditor64.exe): dall'origin.txt, o la cartella
  # stessa se e' portable.
  if($Piccolo.Origin -ne "" -and (Test-Path -LiteralPath (Join-Path $Piccolo.Origin "metaeditor64.exe"))){ $Inst = $Piccolo.Origin }
  elseif($Piccolo.HaMe){ $Inst = $Piccolo.Percorso }
  else{ throw ("metaeditor64.exe dell'installazione del piccolo NON trovato (origin.txt: '" + $Piccolo.Origin + "'): senza il SUO compilatore non installo niente.") }
  if($Inst -like "*-V3*"){ throw ("l'installazione che l'origin.txt indica per il piccolo contiene -V3 (" + $Inst + "): contraddice il perimetro, mi fermo.") }
  $Me = Join-Path $Inst "metaeditor64.exe"
  $MqlDir = Join-Path $Scelta "MQL5"
  Dico ("cartella dati scelta: " + $Scelta) "Yellow"
  Dico ("criterio ............ " + $Criterio) "Yellow"
  Dico ("installazione ....... " + $Inst) "Yellow"
  $v3n = @($V3Cand).Count
  # NIENTE VERDETTO QUI: quante di queste cartelle contengano davvero i tre
  # file si sa solo dopo le foto, e una cartella di INSTALLAZIONE con "-V3"
  # nel nome ne contiene ZERO (classe 117). Il campo IL -V3 / 100k lo decide
  # la raccolta, contando le foto su file REALMENTE presenti.
  if($v3n -eq 0){ [void]$Rilievi.Add("NESSUNA candidata con traccia del 100k/-V3 trovata da questa sessione (la sua cartella dati sta sotto un altro profilo utente che questa sessione non legge): il 100k risultera' NON MISURATO, non 'invariato'. Questa riga scrive SOLO sotto " + $Scelta + ", per costruzione.") }
  Dico ("candidate con traccia del 100k/-V3 da fotografare: " + $v3n)

  foreach($a in $altri){
    $p = Join-Path (Join-Path $MqlDir "Include") ($a -replace '/','\')
    if(-not (Test-Path -LiteralPath $p)){
      throw ("INCLUDE DI LIBRERIA NON TROVATO nel terminale del piccolo: '" + $a + "' (cercato in " + $p + "). La compilazione fallirebbe per un motivo di AMBIENTE: non installo.")
    }
  }

  # -------------------------------------------------------------------
  #  4. LE FOTO PRIMA (piccolo + ogni -V3) e la versione installata
  # -------------------------------------------------------------------
  Titolo "4. FOTO PRIMA: i tre file del PICCOLO, i tre file di OGNI -V3, e le cartelle dei parametri"
  $DestMq5 = Join-Path $MqlDir ("Experts\" + $EA + ".mq5")
  $DestEx5 = Join-Path $MqlDir ("Experts\" + $EA + ".ex5")
  $DestMqh = Join-Path $MqlDir ("Include\" + $IncNostro)
  $Tre = @(@{N="Experts\" + $EA + ".mq5"; P=$DestMq5}, @{N="Experts\" + $EA + ".ex5"; P=$DestEx5}, @{N="Include\" + $IncNostro; P=$DestMqh})
  $FotoP = @{}
  foreach($t in $Tre){ $FotoP[$t.N] = Foto $t.P; Dico ("PICCOLO prima -- " + $t.N + ": " + (FotoTxt $FotoP[$t.N])) }
  $FotoV3 = New-Object System.Collections.ArrayList
  foreach($c in $V3Cand){
    foreach($t in $Tre){
      $p = Join-Path $c.Percorso ("MQL5\" + $t.N)
      $f = Foto $p
      [void]$FotoV3.Add([pscustomobject]@{ Cart=$c.Percorso; N=$t.N; P=$p; Prima=$f })
      Dico ("-V3 prima -- " + $c.Percorso + " MQL5\" + $t.N + ": " + (FotoTxt $f))
    }
  }
  $DirParam = @(@{N="MQL5\Presets"; P=(Join-Path $MqlDir "Presets")}, @{N="MQL5\Profiles\Charts"; P=(Join-Path $MqlDir "Profiles\Charts")}, @{N="config"; P=(Join-Path $Scelta "config")})
  $FotoDirP = @{}
  foreach($d in $DirParam){ $FotoDirP[$d.N] = FotoDir $d.P; Dico ("parametri prima -- " + $d.N + ": " + $FotoDirP[$d.N]) }
  $FotoPrese = $true

  $VersPrima = "ASSENTE (nessun .mq5 installato)"
  if($FotoP["Experts\" + $EA + ".mq5"].Esiste){
    $tv = ((LeggiTesto $DestMq5) -join "`n")
    $mvp = [regex]::Match($tv, '#property\s+version\s+"([^"]+)"')
    if($mvp.Success){ $VersPrima = $mvp.Groups[1].Value }else{ $VersPrima = "NON LEGGIBILE (nessun #property version nel file installato)" }
  }
  Dico ("versione INSTALLATA prima del giro (letta dal .mq5 del piccolo): " + $VersPrima) "Yellow"
  if($VersPrima -eq $VersioneAttesa){
    [void]$Rilievi.Add("il .mq5 installato sul piccolo e' GIA' la v" + $VersioneAttesa + ": questo giro lo reinstalla e ricompila lo stesso (il pin decide), ma va letto.")
  }

  # -------------------------------------------------------------------
  #  5. CONTROLLO si ferma QUI. CORSA: backup, copia, compilazione.
  # -------------------------------------------------------------------
  if($Modo -eq "CONTROLLO"){
    $Compilato  = "NON TENTATA (modo CONTROLLO: questo giro NON scrive e NON compila, NON e' il risultato del passo)"
    $DeployTxt  = "NON AVVENUTO (modo CONTROLLO: nessuna scrittura nel terminale, per scelta)"
    $BackupTxt  = "NON FATTO (modo CONTROLLO: non c'e' niente da proteggere, non si scrive)"
    $BackupDir  = Join-Path $Dsk ("backup_orb_v102_" + $Avvio.ToString("yyyy-MM-dd",$INV) + "\" + $Avvio.ToString("HHmmss",$INV))
    Dico "modo CONTROLLO: mi fermo PRIMA del backup e della copia. La CORSA farebbe:" "Yellow"
    Dico ("   backup in  " + $BackupDir)
    Dico ("   scrittura  " + $DestMq5)
    Dico ("   scrittura  " + $DestMqh)
    Dico ("   compilazione con " + $Me + " /compile:<mq5> /inc:" + $MqlDir + " /log:" + $LogPath)
  }
  else{
    Titolo "5. BACKUP dei tre file del piccolo (Desktop), poi SENTINELLA, poi COPIA"
    $BackupDir = Join-Path $Dsk ("backup_orb_v102_" + $Avvio.ToString("yyyy-MM-dd",$INV) + "\" + $Avvio.ToString("HHmmss",$INV))
    New-Item -ItemType Directory -Force -Path $BackupDir | Out-Null
    $bk = New-Object System.Collections.ArrayList
    foreach($t in $Tre){
      if(Test-Path -LiteralPath $t.P){
        $b = Join-Path $BackupDir (Split-Path -Leaf $t.P)
        Copy-Item -LiteralPath $t.P -Destination $b -Force
        if((HashPieno $t.P) -ne (HashPieno $b)){ throw ("BACKUP NON VERIFICATO: " + $b + " ha sha256 diverso dall'originale. Non scrivo niente nel terminale.") }
        [void]$bk.Add((Split-Path -Leaf $t.P) + " (" + (Get-Item -LiteralPath $b).Length + " byte, sha256 " + (Hash16 $b) + ")")
      }
      else{ [void]$bk.Add((Split-Path -Leaf $t.P) + " (ASSENTE prima del giro: niente da salvare)") }
    }
    Set-Content -LiteralPath (Join-Path $BackupDir "BACKUP_ORIGINE.txt") -Value @(("cartella dati del piccolo: " + $Scelta), ("versione installata prima: " + $VersPrima), ("giro: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV)), ("pin: " + $Pin)) -Encoding ASCII
    $BackupTxt = "FATTO in " + $BackupDir + " -- " + ($bk -join "; ")
    Dico ("backup: " + $BackupTxt) "Green"

    # LA SENTINELLA PRIMA DELLA PRIMA SCRITTURA (classe 116).
    Set-Content -LiteralPath $Sentinella -Value @($DestMq5, $DestEx5, $DestMqh, $BackupDir) -Encoding ASCII
    $ScrittoNelTerminale = $true
    New-Item -ItemType Directory -Force -Path (Join-Path $MqlDir "Experts"),(Join-Path $MqlDir "Include") | Out-Null
    Copy-Item -LiteralPath $Mqh -Destination $DestMqh -Force
    Copy-Item -LiteralPath $Mq5 -Destination $DestMq5 -Force
    if((HashPieno $Mq5) -ne (HashPieno $DestMq5)){ throw ("COPIA NON VERIFICATA: " + $DestMq5 + " non e' identico (sha256) al sorgente scaricato al pin.") }
    if((HashPieno $Mqh) -ne (HashPieno $DestMqh)){ throw ("COPIA NON VERIFICATA: " + $DestMqh + " non e' identico (sha256) all'include scaricato al pin.") }
    $ScrittiTxt = "SCRITTI nel terminale del piccolo: " + $DestMq5 + " e " + $DestMqh + " (sha256 identici ai file al pin; l'.ex5 lo scrive MetaEditor qui sotto)"
    Dico $ScrittiTxt "Green"
    # L'INCLUDE E' CONDIVISO: si dichiara, non si nasconde dentro "tre file".
    if($FotoP["Include\" + $IncNostro].Esiste -and $FotoP["Include\" + $IncNostro].Hash -ne (Hash16 $Mqh)){
      [void]$Rilievi.Add($IncNostro + " NON e' un file del solo ORB: e' l'include CONDIVISO del Guardian, usato da decine di EA di questa flotta. Prima [" + (FotoTxt $FotoP["Include\" + $IncNostro]) + "], adesso la versione al pin (v1.51). Gli .ex5 GIA' in forward NON cambiano comportamento (ognuno si porta dentro il Guardian con cui fu compilato): cambia l'INGRESSO delle compilazioni FUTURE su questo terminale. Dichiarato, non un guasto -- ma va saputo prima del round di ricompilazione.")
    }

    Titolo "6. COMPILAZIONE con il metaeditor64 dell'installazione del piccolo"
    $esito = Compila $Me @(("/compile:" + $DestMq5), ("/inc:" + $MqlDir), ("/log:" + $LogPath)) $DestEx5 $LogPath $TimeoutSec
    $LogRighe = @($esito.Log)
    if($esito.Rc -is [int]){ $RcTxt = "" + $esito.Rc }
    $nErr = -1
    $nWar = -1
    foreach($r in @($LogRighe)){
      $m = [regex]::Match($r, '(?i)(\d+)\s+error[s]?\s*,\s*(\d+)\s+warning')
      if($m.Success){
        $nErr = [int]::Parse($m.Groups[1].Value,$INV)
        $nWar = [int]::Parse($m.Groups[2].Value,$INV)
        $ResultTxt = $r.Trim()
      }
    }
    if($nErr -lt 0){ $ResultTxt = "NON TROVATA nel log (il conteggio errori/warning non e' stato letto)" }

    if($esito.Ex5 -and $nErr -eq 0){
      $itm = Get-Item -LiteralPath $DestEx5
      $kb  = [int]($itm.Length/1024)
      $wtxt = "warning NON LETTI"
      if($nWar -ge 0){ $wtxt = "" + $nWar + " warning" }
      $Compilato = "OK (" + $kb + " KB, " + $itm.Length + " byte, " + $itm.LastWriteTime.ToString("HH:mm:ss",$INV) + "), 0 errors, " + $wtxt
      $Ex5Nuovo = $DestEx5
      $DeployTxt = "AVVENUTO: v" + $VersioneAttesa + " installata e compilata nel SOLO terminale del piccolo (" + $Scelta + ")"
      $Ripristino = "NON NECESSARIO (compilazione OK: i file nuovi restano; il backup dei vecchi resta sul Desktop, non si cancella da solo)"
      Remove-Item -LiteralPath $Sentinella -Force -ErrorAction SilentlyContinue
      Dico ("COMPILATA: " + $Compilato) "Green"
      if($nWar -gt 0){
        [void]$Rilievi.Add("la compilazione ha prodotto " + $nWar + " warning: NON bloccano (la firma dice 'solo se 0 errori'), ma vanno letti nel log dentro lo zip.")
        foreach($r in @($LogRighe)){ if($r -match '(?i):\s*warning'){ [void]$Rilievi.Add("  warning: " + $r.Trim()) } }
      }
    }
    else{
      $quanti = "NON LETTI"
      if($nErr -ge 0){ $quanti = "" + $nErr }
      if($esito.Ex5 -and $nErr -gt 0){
        # .ex5 fresco MA il log conta errori: contraddizione, si tratta
        # come fallimento (il log e' il contratto) e si ripristina.
        [void]$Problemi.Add("CONTRADDIZIONE: .ex5 fresco ma il log conta " + $nErr + " errori. Si tratta come FALLITA e si ripristina: un binario nato con errori nel log non va in forward.")
      }
      $Compilato = "FALLITA (MetaEditor lanciato, nessun .ex5 fresco valido; errori dal log: " + $quanti + ") -- il piccolo viene RIMESSO com'era dal backup"
      if($esito.Muto -or @($LogRighe).Count -eq 0){
        $Compilato = "FALLITA -- METAEDITOR MUTO: lanciato ed e' tornato SENZA scrivere ne' log ne' .ex5 (rc=0 muto del 22/08: editor aperto, percorso, permessi). NON e' un verdetto sulla v1.04. Il piccolo viene RIMESSO com'era dal backup"
        [void]$Problemi.Add("MetaEditor non ha scritto NESSUN log: il passo non ha misurato la compilazione, ha misurato un ambiente che non risponde.")
      }
      [void]$Problemi.Add("COMPILAZIONE FALLITA sul terminale del piccolo: v" + $VersioneAttesa + " NON installata. Le prime 30 righe del log sono nel referto, il log intero nello zip. Il PASSO 1 aveva compilato OK: se qui fallisce, la differenza e' l'AMBIENTE del terminale (include, permessi, editor), non il codice.")
      $es = RipristinaDaBackup $BackupDir @($DestMq5, $DestEx5, $DestMqh)
      $Ripristino = "RIPRISTINATO dal backup " + $BackupDir + " -- " + ($es -join "; ")
      $DeployTxt = "TENTATO E RIPRISTINATO: la compilazione e' fallita e i tre file del piccolo sono tornati com'erano (verificato per sha256 nelle foto DOPO)"
      Remove-Item -LiteralPath $Sentinella -Force -ErrorAction SilentlyContinue
      Dico ("COMPILAZIONE FALLITA. " + $Ripristino) "Red"
      $k = 0
      foreach($r in @($LogRighe)){ if($r.Trim() -eq ""){ continue }; Write-Host ("      " + $r) -ForegroundColor Red; $k++; if($k -ge 30){ break } }
      if($k -eq 0){ Write-Host "      (nessun log prodotto)" -ForegroundColor Red }
    }
  }
}
catch{
  $Fatale = ("" + $_.Exception.Message)
  Write-Host ""
  Write-Host ("!!! FERMATO: " + $Fatale) -ForegroundColor Red
  # se il giro e' morto DOPO aver scritto nel terminale (copia non
  # verificata, eccezione in compilazione): si rimette a posto SUBITO.
  if($ScrittoNelTerminale -and $BackupDir -ne "" -and (Test-Path -LiteralPath $BackupDir)){
    try{
      $es = RipristinaDaBackup $BackupDir @($DestMq5, $DestEx5, $DestMqh)
      $Ripristino = "RIPRISTINATO dal backup " + $BackupDir + " dopo un'eccezione -- " + ($es -join "; ")
      $DeployTxt = "TENTATO E RIPRISTINATO: il giro si e' fermato dopo aver scritto nel terminale, e i tre file sono tornati com'erano"
      Remove-Item -LiteralPath $Sentinella -Force -ErrorAction SilentlyContinue
    }
    catch{
      $Ripristino = "RIPRISTINO FALLITO: " + $_.Exception.Message
      [void]$Problemi.Add("RIPRISTINO FALLITO dei file del piccolo: la sentinella " + $Sentinella + " resta, e il prossimo giro in CORSA riprova. Nel frattempo NON riaprire MT5 sul piccolo: guarda il backup " + $BackupDir + " a mano.")
    }
  }
}

# =====================================================================
#  RACCOLTA -- SEMPRE
# =====================================================================
Titolo "RACCOLTA"
$Cart = Join-Path $Dsk ("DEPLOY_ORB104_PICCOLO_" + $Modo + "_" + $Stamp)
if(Test-Path -LiteralPath $Cart){ Remove-Item -LiteralPath $Cart -Recurse -Force -ErrorAction SilentlyContinue }
New-Item -ItemType Directory -Force -Path $Cart | Out-Null

# LE FOTO DOPO: qui il perimetro diventa una MISURA.
$V3Tocc = $false
if($FotoPrese){
  try{
    foreach($t in $Tre){
      $d = Foto $t.P
      $st = Confronta $FotoP[$t.N] $d
      [void]$FotoDopoTxt.Add("  PICCOLO " + $t.N + ": prima [" + (FotoTxt $FotoP[$t.N]) + "] dopo [" + (FotoTxt $d) + "] -> " + $st)
    }
    # LA FOTO DI UN FILE CHE NON C'E' NON E' UNA MISURA (classe 117).
    # Una candidata con traccia del 100k puo' essere la sola CARTELLA DI
    # INSTALLAZIONE in Program Files (quella si' che Master la vede): li'
    # dentro i tre file non esistono, e ASSENTE prima + ASSENTE dopo esce
    # "INVARIATO". Contarlo come prova vorrebbe dire scrivere "il 100k e'
    # intatto" avendo guardato il vuoto. Si conta quante foto stanno su un
    # file REALMENTE ESISTENTE prima del giro: se sono ZERO, il campo dice
    # NON MISURATO, non INVARIATO.
    $v3Vere = @($FotoV3 | Where-Object { $_.Prima.Esiste })
    foreach($f in $FotoV3){
      $d = Foto $f.P
      $st = Confronta $f.Prima $d
      if($st -eq "CAMBIATO"){ $V3Tocc = $true }
      [void]$FotoDopoTxt.Add("  -V3 " + $f.Cart + " MQL5\" + $f.N + ": prima [" + (FotoTxt $f.Prima) + "] dopo [" + (FotoTxt $d) + "] -> " + $st)
    }
    if($V3Tocc){
      $V3Txt = "ATTENZIONE: un file del -V3 RISULTA CAMBIATO -- leggi le righe qui sotto"
      [void]$Problemi.Add("un file del terminale -V3 e' cambiato durante il giro: NON doveva succedere (questa riga scrive solo sotto " + $Scelta + "). Controlla le foto prima/dopo PRIMA di riaprire il 100k.")
    }
    elseif(@($v3Vere).Count -eq 0){
      $V3Txt = ("NON MISURATO -- " + @($V3Cand).Count + " cartelle con traccia del 100k guardate, " +
                @($FotoV3).Count + " foto, e NESSUNA su un file che esisteva davvero (ASSENTE prima E dopo: e' la foto del vuoto, non una prova). " +
                "La cartella DATI del 100k sta sotto un altro profilo utente (Administrator, HANDOFF 03/09) che la sessione " + $env:USERNAME + " non legge. " +
                "Il perimetro qui e' DICHIARATO PER COSTRUZIONE -- questa riga scrive SOLO sotto " + $Scelta + ", e le righe PICCOLO/PARAMETRI lo misurano -- ma sul 100k NON e' misurato.")
      [void]$Rilievi.Add("IL 100k/-V3 NON E' STATO MISURATO in questo giro: nessuna copia REALE dei tre file sotto le cartelle con traccia del 100k (" + @($FotoV3).Count + " foto, tutte ASSENTE->ASSENTE). Il referto NON dice INVARIATO, dice NON MISURATO. La sua cartella dati sta sotto il profilo Administrator: per MISURARLO davvero il giro va rifatto da una sessione che legge quel profilo. Non e' un blocco: questa riga non ha nessun percorso di scrittura fuori da " + $Scelta + ".")
    }
    else{
      $V3Txt = ("INVARIATO su " + @($v3Vere).Count + " foto di file REALMENTE PRESENTI prima del giro (su " +
                @($FotoV3).Count + " foto totali, " + @($V3Cand).Count + " cartelle con traccia del 100k; le foto su file ASSENTI non contano come prova)")
    }
    $pOk = $true
    foreach($dd in $DirParam){
      $dopo = FotoDir $dd.P
      $st = "INVARIATO"
      if($dopo -ne $FotoDirP[$dd.N]){ $st = "CAMBIATO"; $pOk = $false }
      [void]$FotoDopoTxt.Add("  parametri " + $dd.N + ": prima [" + $FotoDirP[$dd.N] + "] dopo [" + $dopo + "] -> " + $st)
    }
    if($pOk){ $ParamTxt = "INVARIATI (Presets, Profiles\Charts, config: stessi file, stessi byte, stesse date). I parametri del grafico restano quelli: rischio 1,0% sul piccolo." }
    else{ $ParamTxt = "ATTENZIONE: una cartella dei parametri risulta CAMBIATA -- questa riga non ci scrive: leggi le righe qui sotto"; [void]$Problemi.Add("una cartella dei parametri (Presets/Charts/config) e' cambiata durante il giro: non doveva succedere.") }
  }
  catch{
    [void]$Problemi.Add("non ho potuto rifare le foto DOPO (" + $_.Exception.Message + "): il perimetro resta DICHIARATO e non MISURATO in questo giro.")
  }
}

$Ref = New-Object System.Collections.ArrayList
[void]$Ref.Add("=====================================================================")
[void]$Ref.Add(" DEPLOY -- " + $EA + " v" + $VersioneAttesa + " sul SOLO PICCOLO " + $CONTO_PICCOLO + " (PASSO 2)")
[void]$Ref.Add(" Perimetro firmato da Claudio il 03/09 alle 11:05 (FIRMO IL PERIMETRO")
[void]$Ref.Add(" PICCOLO): il 100k/-V3 " + $CONTO_GRANDE + " resta INTATTO fino a fine Fase 1.")
[void]$Ref.Add("=====================================================================")
[void]$Ref.Add("modo: " + $Modo + "   <- CONTROLLO = giro a vuoto, NON scrive nel terminale e NON e' il risultato")
[void]$Ref.Add("data: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   <- ORA DI AVVIO del giro (non l'ora in cui leggi)")
[void]$Ref.Add("pin:  " + $Pin)
[void]$Ref.Add("")
[void]$Ref.Add("cartella dati del piccolo: " + $Scelta)
[void]$Ref.Add("criterio di scelta: " + $Criterio)
[void]$Ref.Add("installazione (metaeditor64): " + $Inst)
[void]$Ref.Add("versione INSTALLATA prima del giro: " + $VersPrima + "   (letta dal .mq5 del terminale, non assunta)")
[void]$Ref.Add("")
[void]$Ref.Add("sorgente al pin: " + $SorgTxt)
[void]$Ref.Add("include al pin:  " + $IncTxt)
[void]$Ref.Add("versione letta dal #property: " + $VersLetta + "   (attesa " + $VersioneAttesa + ", commit del fix 19312c8)")
[void]$Ref.Add("autotest dichiarato nel sorgente: " + $DefineTxt)
[void]$Ref.Add("include censiti nel sorgente: " + $IncluTxt)
[void]$Ref.Add("grep del difetto curato: " + $SelTxt)
[void]$Ref.Add("")
[void]$Ref.Add("backup: " + $BackupTxt)
[void]$Ref.Add("scritture nel terminale: " + $ScrittiTxt)
[void]$Ref.Add("compilazione: " + $Compilato)
[void]$Ref.Add("   <- QUATTRO STATI: NON TENTATA / FALLITA (ripristinato) / FALLITA -- METAEDITOR MUTO (ripristinato) / OK (con la dimensione)")
[void]$Ref.Add("riga Result del log: " + $ResultTxt)
[void]$Ref.Add("codice di uscita di metaeditor64: " + $RcTxt + "   (1 con .ex5 e Result 0/0 e' NORMALE, misurato il 03/09; NON LETTO non e' un fallimento)")
[void]$Ref.Add("ripristino: " + $Ripristino)
[void]$Ref.Add("")
[void]$Ref.Add("DEPLOY: " + $DeployTxt)
[void]$Ref.Add("IL -V3 / 100k: " + $V3Txt)
[void]$Ref.Add("   <- TRE STATI: INVARIATO su N foto di file REALMENTE PRESENTI / NON MISURATO (nessun file vero da fotografare: la sua cartella dati sta sotto un altro profilo) / ATTENZIONE CAMBIATO")
[void]$Ref.Add("PARAMETRI (.set/.chr/.ini): " + $ParamTxt)
foreach($r in $FotoDopoTxt){ [void]$Ref.Add($r) }
if(-not $FotoPrese){ [void]$Ref.Add("  (nessuna foto: il giro si e' fermato prima di scegliere la cartella dati, quindi non e' stato scritto niente da nessuna parte)") }
[void]$Ref.Add("")
if($Modo -eq "CORSA" -and $Compilato -like "OK*" -and $Problemi.Count -eq 0){
  [void]$Ref.Add("COSA SUCCEDE DOPO: riapri MT5 del piccolo (sessione Master). I grafici ORB restano")
  [void]$Ref.Add("gli stessi: il terminale ricarica l'.ex5 nuovo da solo, coi parametri salvati nel")
  [void]$Ref.Add("grafico (rischio 1,0%); gli input NUOVI della v1.04 (InpAutoTest) prendono il default.")
  [void]$Ref.Add("Nella scheda ESPERTI (non Giornale: e' un Print dell'EA) cerca ABTG_ORB_Ottimizzato e")
  [void]$Ref.Add("la riga  ORB AUTOTEST: 10 blocchi su 10 passati, 33 casi dichiarati, 0 falliti.")
  [void]$Ref.Add("QUELLA riga e' la prova che gira la v1.04: la v1.02 non la stampa affatto (OnInit")
  [void]$Ref.Add("non stampa il numero di versione: cercare 'v1.04' nel Giornale NON trova niente).")
  [void]$Ref.Add("Nel Giornale, invece, cerca ABTG_ORB_Ottimizzato ... loaded successfully.")
  [void]$Ref.Add("Poi manda lo screenshot delle due schede.")
}
elseif($Modo -eq "CONTROLLO" -and $Fatale -eq "" -and $Problemi.Count -eq 0){
  [void]$Ref.Add("COSA SUCCEDE DOPO: il CONTROLLO e' pulito. La CORSA si lancia con MT5 e MetaEditor")
  [void]$Ref.Add("CHIUSI, dalla stessa sessione Master, con la flotta ferma (dopo le 22:15 IT o")
  [void]$Ref.Add("prima delle 07:30 IT). Scrivera' SOLO nella cartella dati scritta qui sopra.")
}
else{
  [void]$Ref.Add("COSA SUCCEDE DOPO: la v" + $VersioneAttesa + " NON e' in forward sul piccolo. Il campo")
  [void]$Ref.Add("compilazione: e la riga DEPLOY: qui sopra dicono dove ci si e' fermati; il ripristino")
  [void]$Ref.Add("(se c'e' stato) e' misurato dalle foto DOPO. Prima di riaprire MT5: leggere PROBLEMI.")
}
[void]$Ref.Add("")
if($Fatale -ne ""){ [void]$Ref.Add("!!! FERMATO: " + $Fatale); [void]$Ref.Add("") }
if(@($LogRighe).Count -gt 0){
  [void]$Ref.Add("--- PRIME 30 RIGHE DEL LOG DI METAEDITOR (il log intero e' COMPILAZIONE.log nello zip) ---")
  $k = 0
  foreach($r in @($LogRighe)){ if($r.Trim() -eq ""){ continue }; [void]$Ref.Add("  " + $r.Trim()); $k++; if($k -ge 30){ break } }
  [void]$Ref.Add("")
}
[void]$Ref.Add("PROBLEMI: " + $Problemi.Count)
foreach($p in $Problemi){ [void]$Ref.Add("  - " + $p) }
[void]$Ref.Add("RILIEVI: " + $Rilievi.Count)
foreach($p in $Rilievi){ [void]$Ref.Add("  - " + $p) }
[void]$Ref.Add("")
[void]$Ref.Add("--- L'ELENCO DI COSA HO GUARDATO (classe 115: la cartella si sceglie per fatti; anche in CANDIDATE.txt) ---")
foreach($r in $righeC){ [void]$Ref.Add($r) }
[void]$Ref.Add("")
[void]$Ref.Add("COME SI RIPRENDE: dalla pagina righe/RIGA_DEPLOY_ORB104_PICCOLO_DA_MANDARE.md,")
[void]$Ref.Add("NON da questa riga (il pin nasce dentro il blocco e non sopravvive).")

$refPath = Join-Path $Cart "REFERTO_DEPLOY_ORB104_PICCOLO.txt"
Set-Content -LiteralPath $refPath -Value ($Ref -join "`r`n") -Encoding ASCII
Write-Host ($Ref -join "`r`n")
Set-Content -LiteralPath (Join-Path $Cart "CANDIDATE.txt") -Value ($righeC -join "`r`n") -Encoding ASCII
if(Test-Path -LiteralPath $LogPath){
  Copy-Item -LiteralPath $LogPath -Destination (Join-Path $Cart "COMPILAZIONE.log") -Force
  Set-Content -LiteralPath (Join-Path $Cart "COMPILAZIONE_leggibile.txt") -Value ((LeggiTesto $LogPath) -join "`r`n") -Encoding ASCII
}
if($BackupDir -ne "" -and (Test-Path -LiteralPath $BackupDir)){
  Copy-Item -LiteralPath $refPath -Destination (Join-Path $BackupDir "REFERTO_DEL_GIRO.txt") -Force -ErrorAction SilentlyContinue
}

$zip = $Cart + ".zip"
Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $zip -Force
Write-Host ""
Write-Host ("CARTELLA: " + $Cart) -ForegroundColor Green
Write-Host ("ZIP DA MANDARE: " + $zip) -ForegroundColor Green
Write-Host "FILE ATTESI NELLO ZIP: REFERTO_DEPLOY_ORB104_PICCOLO.txt + CANDIDATE.txt (+ COMPILAZIONE.log e COMPILAZIONE_leggibile.txt solo in CORSA arrivata a MetaEditor)" -ForegroundColor Gray
if($BackupDir -ne "" -and (Test-Path -LiteralPath $BackupDir)){ Write-Host ("BACKUP DEI FILE DI PRIMA: " + $BackupDir) -ForegroundColor Gray }

if($Fatale -ne ""){ Write-Host "ESITO: FERMATO" -ForegroundColor Red; exit 1 }
if($Problemi.Count -gt 0){ Write-Host "ESITO: COMPLETATO CON PROBLEMI" -ForegroundColor Yellow; exit 1 }
Write-Host ("ESITO: " + $Modo + " COMPLETATO") -ForegroundColor Green
exit 0
