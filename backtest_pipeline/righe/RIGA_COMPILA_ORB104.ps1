# =====================================================================
#  MARCATORE_RIGA_COMPILA_ORB104_v1
#  RIGA_COMPILA_ORB104.ps1 -- COMPILAZIONE DI PROVA della v1.04 di
#  ABTG_ORB_Ottimizzato, sul PC DI BACKTEST.
#
#  E' il PASSO 1 della sequenza FIRMATA da Claudio il 03/09 alle 11:05
#  ("FIRMO IL PERIMETRO PICCOLO", verbale report/FIRME_2026-09-03.md):
#    1) si vede COMPILARE la v1.04 fuori dal terminale vivo   <-- QUESTO
#    2) SOLO se 0 errori, deploy sul SOLO conto piccolo (50503392) con
#       aggiorna_verifica_orb.ps1 (procedura collaudata il 22/08).
#  Il commit del fix e' 19312c8; la v1.04 non e' MAI stata compilata
#  (33 casi di autotest nuovi, gestione hedge-safe per TICKET).
#
#  >>> QUESTA RIGA NON INSTALLA NIENTE E NON FA NESSUN DEPLOY.
#      Il .mq5 e il suo include vengono messi in un ALBERO DI LAVORO
#      sotto %USERPROFILE%\abtg_compila_orb104\MQL5\ (Experts\ e
#      Include\), che e' il path RELATIVO che il compilatore si aspetta,
#      e metaeditor64.exe viene chiamato con /inc su QUELL'albero.
#      Il MQL5\Experts del terminale non viene toccato: il referto lo
#      DIMOSTRA con una foto (esiste? quanti byte? che data?) presa
#      PRIMA e RIFATTA DOPO, non con una frase.
#
#  >>> GLI INCLUDE SI CENSISCONO, NON SI INDOVINANO (lezione del 22/08,
#      report/ORB_GEMELLI_DIVERGENZA_2026-08-22.md: il primo giro fallii
#      perche' lo script installava solo l'EA e non ABTG_PausaGuardian.mqh).
#      Qui il sorgente scaricato viene LETTO e ogni sua riga #include
#      viene elencata. Gli include NOSTRI (prefisso ABTG_) devono stare
#      nella lista che questa riga scarica al pin: se ne compare uno in
#      piu', ci si FERMA PRIMA di compilare e si dice il nome. Gli altri
#      (libreria standard, es. Trade/Trade.mqh) devono ESISTERE
#      nell'albero di lavoro: si controlla con Test-Path, uno per uno.
#      Cosi' un include aggiunto domani non si trasforma in un giro a
#      vuoto: si trasforma in un messaggio.
#      NOTA: la v1.04 include ABTG_PausaGuardian.mqh, che al pin e' la
#      v1.51. La compilazione lega la v1.04 A QUELL'INCLUDE.
#
#  >>> INVOCAZIONE DIRETTA DI METAEDITOR (& $Me ...), col pipe a
#      Out-Null: il 22/08 Start-Process con -ArgumentList a stringa
#      pre-assemblata tornava rc=0 SENZA COMPILARE NIENTE, perche' i
#      path di "Program Files" hanno gli spazi. Qui e' PowerShell a
#      quotare ogni argomento. Il "| Out-Null" serve ad aspettare un
#      eseguibile GUI; in piu' c'e' un'attesa esplicita con tetto.
#
#  >>> IL VERDETTO STA SULL'ARTEFATTO, NON SUL CODICE DI USCITA
#      (classe 108 del 02/09: su Windows PowerShell 5.1 il codice di
#      uscita puo' essere VUOTO e '$null -ne 0' e' VERO). Qui il codice
#      di metaeditor64 si legge a TRE STATI e vale come conferma; a
#      decidere sono l'.ex5 FRESCO (piu' recente dell'avvio del
#      tentativo) e la riga "Result: N errors, M warnings" del log.
#
#  >>> IL CAMPO compilazione: HA TRE STATI E SI TIMBRA SUL RAMO CHE LO
#      DECIDE (classe 94-ter del 02/09):
#        NON TENTATA  = non ci siamo arrivati (o modo CONTROLLO)
#        FALLITA      = MetaEditor lanciato, nessun .ex5 -> E' IL
#                       RISULTATO DEL PASSO, con le prime 30 righe del
#                       log nel referto e il log intero nello zip
#        OK (... KB)  = .ex5 fresco + Result letta
#
#  >>> LA GUARDIA, DICHIARATA: qui si PRETENDE metaeditor64.exe CHIUSO
#      (con l'editor gia' aperto la compilazione da riga di comando
#      torna subito senza fare niente: e' il rc=0 muto del 22/08).
#      MT5 (terminal64.exe) PUO' RESTARE APERTO: questo giro non scrive
#      NIENTE nelle cartelle del terminale e non ricompila niente di
#      quello che il terminale sta usando. E' la differenza con
#      aggiorna_verifica_orb.ps1, che invece scrive in MQL5\Experts e
#      per quello pretende tutto chiuso.
#      Unica eccezione, dichiarata e reversibile: il TENTATIVO B qui
#      sotto, che parte SOLO se il tentativo A e' morto per un include
#      non risolto. Quello copia l'include (e SOLO l'include) in
#      MQL5\Include del terminale di backtest, con backup, e lo
#      RIPRISTINA a fine giro -- sempre, anche se il giro muore.
#      Nessun .mq5 e nessun .ex5 entrano mai in MQL5\Experts.
#
#  QUANTO CI METTE [STIMA, non una previsione]: copia della libreria
#  standard + 2 download + 1 compilazione = 1-3 minuti.
#
#  LA RIGA CHE SI INCOLLA sta in righe\RIGA_COMPILA_ORB104_DA_MANDARE.md
# =====================================================================
[CmdletBinding()]
param(
  # -Pin NON ha default: un default silenzioso ("lavoro") farebbe girare
  #  la punta del branch spacciandola per un commit congelato.
  [string]$Pin           = "",
  [switch]$SoloControllo,
  # -Terminale: si usa SOLO se la scelta automatica si ferma perche' non
  #  ha un FATTO per decidere (classe 115: l'ambiente non si indovina dal
  #  nome). La riga stampa l'elenco e il path da incollare qui.
  [string]$Terminale     = "",
  [int]$TimeoutSec       = 120
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

$EA        = "ABTG_ORB_Ottimizzato"
$IncNostro = "ABTG_PausaGuardian.mqh"
$VersioneAttesa = "1.04"
$BLOCCHI_ATTESI = 10
$CASI_ATTESI    = 33

$Avvio = Get-Date
$Stamp = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
# IL DESKTOP SI CERCA, NON SI ASSUME: con OneDrive il Desktop vero non e'
# %USERPROFILE%\Desktop, e una New-Item -Force ne creerebbe uno finto in
# cui Claudio non troverebbe mai lo zip (pattern di aggiorna_verifica_orb.ps1).
function TrovaDesktop(){
  foreach($p in @([Environment]::GetFolderPath("Desktop"),
                  (Join-Path $env:USERPROFILE "Desktop"),
                  (Join-Path $env:USERPROFILE "OneDrive\Desktop"))){
    if($p -and (Test-Path -LiteralPath $p)){ return $p }
  }
  return $env:USERPROFILE
}
$Dsk   = TrovaDesktop
$Work  = Join-Path $env:USERPROFILE "abtg_compila_orb104"
$MqlW  = Join-Path $Work "MQL5"
$ExpW  = Join-Path $MqlW "Experts"
$IncW  = Join-Path $MqlW "Include"
$Sentinella = Join-Path $Work "TENTATIVO_B_IN_CORSO.txt"
$RawPin = ""

# --- tutto cio' che la raccolta usa nasce QUI, prima del try: la
#     raccolta gira SEMPRE, anche nel giro fermato da un gate, e ogni
#     campo parte da uno stato VERO ("non ci siamo arrivati"), mai da
#     uno stato che somigli a un risultato.
$Problemi   = New-Object System.Collections.ArrayList
$Rilievi    = New-Object System.Collections.ArrayList
$Tentativi  = New-Object System.Collections.ArrayList
$Fatale     = ""
$Compilato  = "NON TENTATA"
$TermScelto = "NON SCELTO"
$TermCrit   = "n/d"
$DataFolder = "n/d"
$LibStd     = "NON COPIATA"
$SorgTxt    = "NON SCARICATO"
$IncTxt     = "NON SCARICATO"
$VersLetta  = "NON LETTA"
$DefineTxt  = "NON LETTI"
$IncluTxt   = "NON CENSITI"
$SelTxt     = "NON ESEGUITO"
$ResultTxt  = "NON LETTA"
$RcTxt      = "NON LETTO"
$Ex5Path    = ""
$LogRighe   = @()
$IncInstallato = $false
$IncBackup  = ""
$IncEraLi   = $false
$FotoPrese  = $false
$TExpMq5    = ""
$TExpEx5    = ""
$TIncMqh    = ""
$Deploy     = "NON VERIFICATO"
$Modo = "CORSA"
if($SoloControllo){ $Modo = "CONTROLLO" }

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

function Descrivi([string]$path){
  if(-not (Test-Path -LiteralPath $path)){ return "ASSENTE" }
  $i = Get-Item -LiteralPath $path
  $h = "n/d"
  try{ $h = (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash.Substring(0,16) }catch{ $h = "n/d" }
  return ("" + $i.Length + " byte, sha256 " + $h + ", " + $i.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss",$INV))
}

# FOTO di un file del TERMINALE: e' la prova del "nessun deploy". Si
# prende PRIMA e si RIFA' DOPO. Esistenza e lunghezza sono il test
# forte (un cambio = deploy); la data e' un test debole (rilievo).
function Foto([string]$path){
  if($path -eq "" -or $null -eq $path){ return [pscustomobject]@{ Esiste=$false; Len=-1; Ora="ASSENTE" } }
  if(-not (Test-Path -LiteralPath $path)){ return [pscustomobject]@{ Esiste=$false; Len=-1; Ora="ASSENTE" } }
  $i = Get-Item -LiteralPath $path
  return [pscustomobject]@{ Esiste=$true; Len=$i.Length; Ora=$i.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss",$INV) }
}
function FotoTxt($f){
  if(-not $f.Esiste){ return "ASSENTE" }
  return ("presente, " + $f.Len + " byte, " + $f.Ora)
}

# Legge un file di testo qualunque sia la codifica: il log di
# MetaEditor esce in UTF-16LE col BOM, e un Get-Content ingenuo su PS
# 5.1 puo' restituire byte spuri. Qui si guarda il BOM e, se non c'e',
# si conta quanti byte dispari sono a zero (firma dell'UTF-16 nudo).
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

# CENSIMENTO degli #include di un sorgente MQL5. Torna la LISTA dei
# nomi (fuori dai commenti di riga). Non si assume niente: si legge.
function CensisciInclude([string]$path){
  $trovati = New-Object System.Collections.ArrayList
  foreach($riga in (LeggiTesto $path)){
    $viva = ($riga -replace '//.*$','')
    $m = [regex]::Match($viva, '^\s*#include\s*[<"]([^>"]+)[>"]')
    if($m.Success){ [void]$trovati.Add($m.Groups[1].Value.Trim()) }
  }
  return @($trovati)
}

# UNA COMPILAZIONE. Torna @{ Ex5=bool; Rc=<oggetto>; Log=<righe>; Muto=bool }.
# L'attesa finisce quando c'e' l'.ex5 OPPURE quando il log ha gia' la sua
# riga Result (cosi' un fallimento vero non costa il tetto intero), e c'e'
# un battito a schermo ogni 10 secondi: un minuto di console ferma non
# deve poter sembrare un blocco (e nessuno deve interrompere a mano).
# MUTO = MetaEditor e' uscito e dopo 20 secondi non ha scritto NE' log
# NE' .ex5: e' il rc=0 muto del 22/08, e si dice con quel nome.
function Compila([string]$et,[string]$exe,[string[]]$argomenti,[string]$ex5,[string]$log,[int]$tetto){
  Remove-Item -LiteralPath $ex5 -Force -ErrorAction SilentlyContinue
  Remove-Item -LiteralPath $log -Force -ErrorAction SilentlyContinue
  $t0 = Get-Date
  Dico ("tentativo " + $et + ": " + $exe + " " + ($argomenti -join " ")) "Yellow"
  $global:LASTEXITCODE = $null
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

try{
  Titolo ("COMPILAZIONE DI PROVA -- " + $EA + " v" + $VersioneAttesa + " -- modo " + $Modo)
  Write-Host "NESSUN DEPLOY: si compila in una cartella di lavoro. Il deploy sul solo conto PICCOLO e' il PASSO 2." -ForegroundColor Yellow

  # -------------------------------------------------------------------
  #  0. LE GUARDIE
  # -------------------------------------------------------------------
  if($Pin -eq ""){ throw "-Pin obbligatorio: senza, girerebbe la punta del branch spacciandola per un commit congelato." }
  if($Pin -notmatch '^[0-9a-f]{40}$'){ throw ("-Pin deve essere un commit di 40 caratteri esadecimali, ricevuto: " + $Pin) }
  $RawPin = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/" + $Pin
  if(Get-Process metaeditor64 -ErrorAction SilentlyContinue){
    throw "METAEDITOR APERTO: con l'editor gia' aperto la compilazione da riga di comando torna subito SENZA compilare niente (rc=0 muto, 22/08). Chiudi MetaEditor e rilancia. MT5 invece puo' restare aperto: questo giro non scrive niente nel terminale."
  }
  if(Get-Process terminal64 -ErrorAction SilentlyContinue){
    [void]$Rilievi.Add("MT5 (terminal64) e' APERTO: qui e' TOLLERATO e dichiarato -- questo giro compila in una cartella di lavoro e non scrive niente nelle cartelle del terminale. Il PASSO 2 (deploy sul piccolo, aggiorna_verifica_orb.ps1) invece pretende TUTTO CHIUSO.")
  }
  Dico ("pin ......... " + $Pin)
  Dico ("cartella di lavoro: " + $Work)

  # -------------------------------------------------------------------
  #  1. L'ALBERO DI LAVORO, RIFATTO DA ZERO
  # -------------------------------------------------------------------
  Titolo "1. ALBERO DI LAVORO (MQL5\Experts + MQL5\Include), rifatto da zero"
  # si rifa' da zero apposta: un .ex5 o un .mqh di un giro precedente
  # rimasto qui dentro sarebbe il reperto che fa passare per fresco un
  # giro morto (classe dell'artefatto stantio).
  if(Test-Path -LiteralPath $MqlW){ Remove-Item -LiteralPath $MqlW -Recurse -Force }
  New-Item -ItemType Directory -Force -Path $Work,$MqlW,$ExpW,$IncW | Out-Null
  Dico "albero pulito: MQL5\Experts e MQL5\Include vuoti" "Green"

  # LA SENTINELLA DEL GIRO PRECEDENTE. Il ripristino del TENTATIVO B
  # gira alla fine; se un giro precedente e' stato INTERROTTO A MANO
  # (Ctrl+C, finestra chiusa, riavvio) fra l'installazione e il
  # ripristino, nel terminale resterebbe un include NOSTRO che nessuno
  # ha piu' tolto -- e nessun referto lo direbbe. Qui si rimedia PRIMA
  # di ogni altra cosa, e lo si dichiara.
  if(Test-Path -LiteralPath $Sentinella){
    $rigaS = @(Get-Content -LiteralPath $Sentinella -ErrorAction SilentlyContinue)
    $sDest = ""
    $sBack = ""
    if(@($rigaS).Count -ge 1){ $sDest = ("" + $rigaS[0]).Trim() }
    if(@($rigaS).Count -ge 2){ $sBack = ("" + $rigaS[1]).Trim() }
    $esitoS = "niente da fare"
    if($sDest -ne "" -and (Test-Path -LiteralPath $sDest)){
      if($sBack -ne "" -and (Test-Path -LiteralPath $sBack)){
        Copy-Item -LiteralPath $sBack -Destination $sDest -Force
        Remove-Item -LiteralPath $sBack -Force -ErrorAction SilentlyContinue
        $esitoS = "ripristinato dal backup " + $sBack
      }
      else{
        Remove-Item -LiteralPath $sDest -Force -ErrorAction SilentlyContinue
        $esitoS = "rimosso (non c'era prima)"
      }
    }
    Remove-Item -LiteralPath $Sentinella -Force -ErrorAction SilentlyContinue
    [void]$Rilievi.Add("UN GIRO PRECEDENTE ERA STATO INTERROTTO durante il TENTATIVO B: l'include " + $sDest + " e' stato " + $esitoS + " adesso, all'avvio di questo giro. Il terminale riparte pulito.")
    Dico ("sentinella di un giro interrotto: include " + $esitoS) "Yellow"
  }

  # -------------------------------------------------------------------
  #  2. IL TERMINALE DI BACKTEST -- scelto per FATTI, mai per nome
  # -------------------------------------------------------------------
  Titolo "2. TERMINALE DI BACKTEST (metaeditor64.exe) e LIBRERIA STANDARD"
  $termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
  $mappa = @{}
  foreach($d in @(Get-ChildItem -LiteralPath $termRoot -Directory -ErrorAction SilentlyContinue)){
    $o = Join-Path $d.FullName "origin.txt"
    if(Test-Path -LiteralPath $o){
      $instOrigin = (Get-Content -LiteralPath $o -Raw -ErrorAction SilentlyContinue)
      if($null -ne $instOrigin){
        $instOrigin = $instOrigin.Trim()
        if($instOrigin -ne "" -and -not $mappa.ContainsKey($instOrigin)){ $mappa[$instOrigin] = $d.FullName }
      }
    }
  }
  # + la scansione del disco, per le installazioni che non hanno ancora
  #   una cartella dati (o che sono portable).
  foreach($t in @(Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "metaeditor64.exe" -ErrorAction SilentlyContinue)){
    if(-not $mappa.ContainsKey($t.DirectoryName)){ $mappa[$t.DirectoryName] = "" }
  }
  $cand = New-Object System.Collections.ArrayList
  foreach($k in @($mappa.Keys)){
    $exeCand = Join-Path $k "metaeditor64.exe"
    if(-not (Test-Path -LiteralPath $exeCand)){ continue }
    $df = $mappa[$k]
    # I FATTI che dicono "questo e' un terminale BCM", in ordine di forza:
    #   1. una cartella bases\<server> che nomina BCM (e' il feed vero)
    #   2. il path di installazione
    $fatto = ""
    if($df -ne ""){
      $basi = @(Get-ChildItem -LiteralPath (Join-Path $df "bases") -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "*BCM*" })
      if($basi.Count -gt 0){ $fatto = "cartella dati con bases\" + $basi[0].Name }
    }
    if($fatto -eq "" -and $k -like "*BCM*"){ $fatto = "percorso di installazione" }
    [void]$cand.Add([pscustomobject]@{ Inst=$k; Data=$df; Fatto=$fatto })
  }
  Write-Host "  installazioni MT5 con metaeditor64.exe trovate:" -ForegroundColor Gray
  foreach($c in $cand){
    $f = $c.Fatto
    if($f -eq ""){ $f = "nessun fatto BCM" }
    Write-Host ("    " + $c.Inst + "   [" + $f + "]") -ForegroundColor Gray
  }
  $scelto = $null
  if($Terminale -ne ""){
    $scelto = @($cand | Where-Object { $_.Inst -ieq $Terminale.TrimEnd("\") }) | Select-Object -First 1
    if($null -eq $scelto){
      if(Test-Path -LiteralPath (Join-Path $Terminale "metaeditor64.exe")){
        $scelto = [pscustomobject]@{ Inst=$Terminale.TrimEnd("\"); Data=""; Fatto="SCELTO A MANO con -Terminale" }
      }
      else{ throw ("-Terminale '" + $Terminale + "' non contiene metaeditor64.exe.") }
    }
    $TermCrit = "SCELTO A MANO con -Terminale"
  }
  else{
    $conFatto = @($cand | Where-Object { $_.Fatto -ne "" })
    $senzaV3  = @($conFatto | Where-Object { $_.Inst -notlike "*-V3*" })
    if($senzaV3.Count -ge 1){
      $scelto = $senzaV3[0]
      $TermCrit = "FATTO: " + $scelto.Fatto + " (scartate le installazioni -V3: il perimetro firmato e' il PICCOLO)"
      if($senzaV3.Count -gt 1){ [void]$Rilievi.Add("piu' di una installazione BCM non -V3 (" + $senzaV3.Count + "): scelta la prima (" + $scelto.Inst + "). Se non e' quella del banco di backtest, rilancia con -Terminale.") }
    }
    elseif($conFatto.Count -ge 1){
      $scelto = $conFatto[0]
      $TermCrit = "FATTO: " + $scelto.Fatto + " (solo installazioni -V3 disponibili: DICHIARATO)"
      [void]$Rilievi.Add("l'unica installazione BCM trovata e' una -V3: compilo con quel MetaEditor (il compilatore e' lo stesso), ma il fatto va letto nel referto.")
    }
    elseif($cand.Count -eq 1){
      $scelto = $cand[0]
      $TermCrit = "NESSUN FATTO BCM: unica installazione presente sulla macchina (dichiarato)"
      [void]$Rilievi.Add("nessun fatto ha identificato un terminale BCM: si e' usata l'unica installazione MT5 presente. Il compilatore e' quello di quel build: dichiarato, non indovinato.")
    }
    else{
      $elenco = (@($cand | ForEach-Object { $_.Inst }) -join " | ")
      throw ("NON SO QUALE TERMINALE USARE (classe 115: l'ambiente non si indovina dal nome). Candidati: " + $elenco + ". Rilancia aggiungendo -Terminale ""<percorso di installazione>"".")
    }
  }
  $Inst = $scelto.Inst
  $Me   = Join-Path $Inst "metaeditor64.exe"
  $TermScelto = $Inst
  $DataFolder = $scelto.Data
  if($DataFolder -eq "" -or $null -eq $DataFolder){ $DataFolder = "n/d" }
  Dico ("terminale scelto: " + $Inst) "Yellow"
  Dico ("criterio ........ " + $TermCrit) "Yellow"
  Dico ("cartella dati ... " + $DataFolder) "Yellow"

  # LA LIBRERIA STANDARD: <Trade/Trade.mqh> e compagnia vivono nella
  # cartella dati (o nell'installazione, se portable). Si COPIA
  # nell'albero di lavoro: cosi' il terminale non viene toccato per
  # niente e /inc punta a roba nostra.
  $sorgenteInc = ""
  $baseTerm    = ""
  if($DataFolder -ne "n/d" -and (Test-Path -LiteralPath (Join-Path $DataFolder "MQL5\Include\Trade\Trade.mqh"))){
    $sorgenteInc = Join-Path $DataFolder "MQL5\Include"
    $baseTerm    = $DataFolder
  }
  elseif(Test-Path -LiteralPath (Join-Path $Inst "MQL5\Include\Trade\Trade.mqh")){
    $sorgenteInc = Join-Path $Inst "MQL5\Include"
    $baseTerm    = $Inst
    [void]$Rilievi.Add("libreria standard presa dalla cartella di INSTALLAZIONE (" + $sorgenteInc + "): installazione portable o senza cartella dati.")
  }
  else{
    throw ("LIBRERIA STANDARD NON TROVATA: ne' " + (Join-Path $DataFolder "MQL5\Include\Trade\Trade.mqh") + " ne' " + (Join-Path $Inst "MQL5\Include\Trade\Trade.mqh") + ". Senza <Trade/Trade.mqh> la v1.04 non puo' compilare: si ferma qui, senza toccare niente.")
  }
  Copy-Item -Path (Join-Path $sorgenteInc "*") -Destination $IncW -Recurse -Force -ErrorAction Stop
  $nFile = @(Get-ChildItem -LiteralPath $IncW -Recurse -File -ErrorAction SilentlyContinue).Count
  if(-not (Test-Path -LiteralPath (Join-Path $IncW "Trade\Trade.mqh"))){
    throw ("COPIA DELLA LIBRERIA STANDARD NON VERIFICATA: nell'albero di lavoro manca Trade\Trade.mqh dopo la copia da " + $sorgenteInc)
  }
  $LibStd = "copiata da " + $sorgenteInc + " (" + $nFile + " file), Trade\Trade.mqh VERIFICATO presente"
  Dico ("libreria standard: " + $LibStd) "Green"

  # -------------------------------------------------------------------
  #  3. LA FOTO DEL TERMINALE, PRIMA (e' la prova del NESSUN DEPLOY)
  # -------------------------------------------------------------------
  $TExpMq5 = Join-Path $baseTerm ("MQL5\Experts\" + $EA + ".mq5")
  $TExpEx5 = Join-Path $baseTerm ("MQL5\Experts\" + $EA + ".ex5")
  $TIncMqh = Join-Path $baseTerm ("MQL5\Include\" + $IncNostro)
  $F1Prima = Foto $TExpMq5
  $F2Prima = Foto $TExpEx5
  $F3Prima = Foto $TIncMqh
  $IncEraLi = $F3Prima.Esiste
  $FotoPrese = $true
  # residui di un TENTATIVO B interrotto in un giro precedente: non si
  # toccano da soli (la sentinella e' l'unica che sa cosa rimettere
  # dove), ma si DICONO -- un file .prima_* dimenticato in MQL5\Include
  # e' esattamente il genere di cosa che poi si trova per caso fra un
  # mese e non si sa piu' di chi sia.
  $residui = @(Get-ChildItem -LiteralPath (Join-Path $baseTerm "MQL5\Include") -Filter ($IncNostro + ".prima_compila_orb104_*") -ErrorAction SilentlyContinue)
  if($residui.Count -gt 0){
    [void]$Rilievi.Add("nel MQL5\Include del terminale ci sono " + $residui.Count + " backup .prima_compila_orb104_* di giri precedenti (il primo: " + $residui[0].Name + "). Non li tocco: guardali e cancellali a mano quando hai finito.")
  }
  Dico ("foto PRIMA -- Experts\" + $EA + ".mq5: " + (FotoTxt $F1Prima))
  Dico ("foto PRIMA -- Experts\" + $EA + ".ex5: " + (FotoTxt $F2Prima))
  Dico ("foto PRIMA -- Include\" + $IncNostro + ": " + (FotoTxt $F3Prima))

  # -------------------------------------------------------------------
  #  4. SCARICO AL PIN + GATE SUL SORGENTE
  # -------------------------------------------------------------------
  Titolo "4. SCARICO AL PIN E GATE SUL SORGENTE (versione, autotest, include censiti)"
  $Mq5 = Join-Path $ExpW ($EA + ".mq5")
  $Mqh = Join-Path $IncW $IncNostro
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
    throw ("VERSIONE SBAGLIATA: il sorgente al pin e' la v" + $VersLetta + ", attesa la v" + $VersioneAttesa + ". Il pin non contiene il fix 19312c8: NON compilo.")
  }

  $mb = [regex]::Match($testoMq5, 'ORBOTT_AUTOTEST_BLOCCHI_ATTESI\s+(\d+)')
  $mc = [regex]::Match($testoMq5, 'ORBOTT_AUTOTEST_CASI_ATTESI\s+(\d+)')
  if(-not ($mb.Success -and $mc.Success)){ throw "nel sorgente non trovo i #define dell'autotest (ORBOTT_AUTOTEST_BLOCCHI_ATTESI / _CASI_ATTESI): non e' la v1.04 attesa." }
  $nBlocchi = [int]::Parse($mb.Groups[1].Value, $INV)
  $nCasi    = [int]::Parse($mc.Groups[1].Value, $INV)
  $DefineTxt = "" + $nBlocchi + " blocchi / " + $nCasi + " casi (dai #define del sorgente)"
  # I GATE DI IDENTITA' SONO FATALI, non rilievi: questo passo misura la
  # compilazione di UN file preciso (la v1.04 del commit 19312c8). Se il
  # file al pin non e' quello, un "compilazione: OK" sarebbe una misura
  # vera su un oggetto sbagliato -- cioe' la cosa peggiore che un referto
  # possa dire.
  if($nBlocchi -ne $BLOCCHI_ATTESI -or $nCasi -ne $CASI_ATTESI){
    throw ("SORGENTE DIVERSO DAL FIX FIRMATO: i #define dell'autotest dicono " + $DefineTxt + ", attesi " + $BLOCCHI_ATTESI + " blocchi / " + $CASI_ATTESI + " casi (v1.04, commit 19312c8). NON compilo: compilare un file diverso darebbe un OK che non vale per la v1.04.")
  }
  foreach($tok in @("ScegliTicketMio_Calc","ElencaTicketMiei_Calc","PosMia_Calc","ORB SELEZIONE:")){
    if($testoMq5 -notmatch [regex]::Escape($tok)){
      throw ("SORGENTE DIVERSO DAL FIX FIRMATO: nel file al pin manca '" + $tok + "', che e' un pezzo dichiarato della v1.04 (nucleo di selezione hedge-safe). NON compilo.")
    }
  }
  # GREP del difetto CURATO: PositionSelect(_Symbol) non deve piu'
  # esistere FUORI dai commenti. Il modello sta QUI e non nel .mq5,
  # apposta: dentro il file combacerebbe con se' stesso.
  $nSel = 0
  foreach($riga in $righeMq5){
    $viva = ($riga -replace '//.*$','')
    if($viva -match 'PositionSelect\s*\(\s*_Symbol'){ $nSel++ }
  }
  $SelTxt = "" + $nSel + " occorrenze di PositionSelect(_Symbol) fuori dai commenti (attese 0)"
  if($nSel -gt 0){
    throw ("IL FIX NON E' COMPLETO NEL SORGENTE AL PIN: " + $SelTxt + ". La v1.04 deve selezionare per SIMBOLO+MAGIC e scrivere per TICKET (report/AUDIT_POSITIONSELECT_HEDGING_2026-09-03.md). NON compilo: un .ex5 verde da questo file porterebbe in forward il difetto che il round sta curando.")
  }
  Dico ("versione " + $VersLetta + " | autotest " + $DefineTxt + " | " + $SelTxt) "Green"

  # IL CENSIMENTO DEGLI INCLUDE (lezione 22/08): si LEGGONO dal file.
  $inclusi = CensisciInclude $Mq5
  $nostri  = @($inclusi | Where-Object { $_ -match '(^|/|\\)ABTG_' })
  $altri   = @($inclusi | Where-Object { $_ -notmatch '(^|/|\\)ABTG_' })
  $IncluTxt = "" + @($inclusi).Count + " (" + (@($inclusi) -join ", ") + ")"
  foreach($n in $nostri){
    $nudo = ($n -split '[\\/]')[-1]
    if($nudo -ne $IncNostro){
      throw ("INCLUDE NOSTRO NON PREVISTO: il sorgente al pin chiede '" + $n + "', che questa riga NON scarica. E' esattamente il giro a vuoto del 22/08 (include mancante). Aggiungerlo alla riga e ri-pinnare, poi rilanciare.")
    }
  }
  foreach($a in $altri){
    $p = Join-Path $IncW ($a -replace '/','\')
    if(-not (Test-Path -LiteralPath $p)){
      throw ("INCLUDE DI LIBRERIA NON TROVATO nell'albero di lavoro: '" + $a + "' (cercato in " + $p + "). La libreria standard copiata da " + $sorgenteInc + " non lo contiene: la compilazione fallirebbe per un motivo di AMBIENTE, non di codice.")
    }
  }
  # e l'include NOSTRO, a sua volta, non deve tirarsi dietro altri
  # nostri file che qui non ci sono.
  $inclDentro = CensisciInclude $Mqh
  foreach($n in @($inclDentro)){
    $nudo = ($n -split '[\\/]')[-1]
    if($nudo -match '^ABTG_' -and $nudo -ne $IncNostro){
      throw ("L'INCLUDE " + $IncNostro + " ne chiede un altro NOSTRO ('" + $n + "') che questa riga non scarica: si ferma prima di compilare.")
    }
    $p = Join-Path $IncW ($n -replace '/','\')
    if($nudo -notmatch '^ABTG_' -and -not (Test-Path -LiteralPath $p)){
      throw ("L'INCLUDE " + $IncNostro + " chiede '" + $n + "', che non c'e' nell'albero di lavoro (" + $p + ").")
    }
  }
  $testoMqh = ((LeggiTesto $Mqh) -join "`n")
  # il modello e' ANCORATO sulla parentesi: 'ABTG_GuardiaIngresso' senza
  # ancora combacia anche con 'ABTG_GuardiaIngressoQualcosAltro', e un
  # gate che passa su un nome rinominato non e' un gate (provato mutando
  # l'include sul banco).
  if($testoMqh -notmatch 'bool\s+ABTG_GuardiaIngresso\s*\('){
    throw ("l'include scaricato al pin non definisce ABTG_GuardiaIngresso(...): la v1.04 lo chiama in due punti, non compilerebbe.")
  }
  Dico ("include censiti nel sorgente: " + $IncluTxt + " -- tutti risolti nell'albero di lavoro") "Green"

  # -------------------------------------------------------------------
  #  5. LA COMPILAZIONE
  # -------------------------------------------------------------------
  if($SoloControllo){
    $Compilato = "NON TENTATA (modo CONTROLLO: questo giro a vuoto NON compila e NON e' il risultato del passo)"
    Dico "modo CONTROLLO: mi fermo PRIMA di MetaEditor." "Yellow"
  }
  else{
    Titolo "5. COMPILAZIONE (metaeditor64, invocazione diretta)"
    $Ex5Path = Join-Path $ExpW ($EA + ".ex5")
    $LogPath = Join-Path $Work "COMPILAZIONE.log"

    # TENTATIVO A: albero di lavoro puro, /inc sul nostro MQL5.
    #   Il terminale non viene toccato in nessun modo.
    $esito = Compila "A (/inc sull'albero di lavoro)" $Me @(("/compile:" + $Mq5), ("/inc:" + $MqlW), ("/log:" + $LogPath)) $Ex5Path $LogPath $TimeoutSec
    $LogRighe = @($esito.Log)
    $rcA = "NON LETTO"
    if($esito.Rc -is [int]){ $rcA = "" + $esito.Rc }
    $RcTxt = $rcA
    if($esito.Ex5){ [void]$Tentativi.Add("A (/inc sull'albero di lavoro): .ex5 PRODOTTO, codice di uscita " + $rcA) }
    else{ [void]$Tentativi.Add("A (/inc sull'albero di lavoro): nessun .ex5, codice di uscita " + $rcA) }

    if(-not $esito.Ex5){
      # SI SALE AL TENTATIVO B SOLO SE IL MOTIVO E' L'AMBIENTE (include
      # non risolto o log assente), MAI se il compilatore ha gia' detto
      # un errore vero: in quel caso l'errore E' il risultato del passo.
      $ambiente = $false
      if(@($LogRighe).Count -eq 0){ $ambiente = $true }
      elseif((@($LogRighe) -match "can't open|cannot open|include file|not found").Count -gt 0){ $ambiente = $true }
      if($ambiente -and $baseTerm -ne ""){
        Dico "tentativo A senza .ex5 per un motivo di AMBIENTE: provo con la cartella dati del terminale di backtest." "Yellow"
        # L'UNICA SCRITTURA nel terminale di tutto questo giro, e si
        # ripristina sempre: l'include (SOLO l'include) in MQL5\Include.
        $tInc = Join-Path $baseTerm "MQL5\Include"
        New-Item -ItemType Directory -Force -Path $tInc | Out-Null
        $bkTxt = "nessun backup: in quella cartella l'include NON c'era"
        if($IncEraLi){
          $IncBackup = $TIncMqh + ".prima_compila_orb104_" + $Stamp
          Copy-Item -LiteralPath $TIncMqh -Destination $IncBackup -Force
          $bkTxt = "backup " + $IncBackup
        }
        # LA SENTINELLA PRIMA DELLA SCRITTURA: se questo giro viene
        # interrotto a mano, il prossimo la trova e rimette a posto.
        Set-Content -LiteralPath $Sentinella -Value @($TIncMqh, $IncBackup) -Encoding ASCII
        Copy-Item -LiteralPath $Mqh -Destination $TIncMqh -Force
        $IncInstallato = $true
        [void]$Rilievi.Add("TENTATIVO B: " + $IncNostro + " copiato TEMPORANEAMENTE in " + $tInc + " (" + $bkTxt + "). Ripristinato a fine giro, e la foto DOPO lo dimostra. Nessun .mq5 e nessun .ex5 sono entrati in MQL5\Experts.")
        $esitoB = Compila "B (cartella dati del terminale, include installato e poi rimosso)" $Me @(("/compile:" + $Mq5), ("/inc:" + (Join-Path $baseTerm "MQL5")), ("/log:" + $LogPath)) $Ex5Path $LogPath $TimeoutSec
        $LogRighe = @($esitoB.Log)
        $rcB = "NON LETTO"
        if($esitoB.Rc -is [int]){ $rcB = "" + $esitoB.Rc }
        $RcTxt = $rcB
        if($esitoB.Ex5){ [void]$Tentativi.Add("B (cartella dati del terminale): .ex5 PRODOTTO, codice di uscita " + $rcB) }
        else{ [void]$Tentativi.Add("B (cartella dati del terminale): nessun .ex5, codice di uscita " + $rcB) }
        $esito = $esitoB
      }
      elseif($ambiente){
        [void]$Tentativi.Add("B non tentato: manca la cartella del terminale su cui appoggiarsi.")
      }
      else{
        [void]$Tentativi.Add("B non tentato: il log porta gia' errori di COMPILAZIONE veri, non un problema di ambiente. Quelli SONO il risultato del passo.")
      }
    }

    # LA LETTURA DEL LOG: la riga Result e' il contratto.
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
    if($nErr -lt 0){ $ResultTxt = "NON TROVATA nel log (il conteggio errori/warning non e' stato letto: fa fede l'.ex5)" }

    if($esito.Ex5 -and $nErr -le 0){
      $itm = Get-Item -LiteralPath $Ex5Path
      $kb  = [int]($itm.Length/1024)
      $wtxt = "warning NON LETTI"
      if($nWar -ge 0){ $wtxt = "" + $nWar + " warning" }
      $Compilato = "OK (" + $kb + " KB, " + $itm.Length + " byte, " + $itm.LastWriteTime.ToString("HH:mm:ss",$INV) + "), 0 errors, " + $wtxt
      Dico ("COMPILATA: " + $Compilato) "Green"
      if($nWar -gt 0){
        [void]$Rilievi.Add("la compilazione ha prodotto " + $nWar + " warning: NON bloccano il PASSO 2 (la firma del 03/09 dice 'solo se 0 errori'), ma vanno letti uno per uno nel log dentro lo zip.")
        foreach($r in @($LogRighe)){ if($r -match '(?i):\s*warning'){ [void]$Rilievi.Add("  warning: " + $r.Trim()) } }
      }
    }
    else{
      $quanti = "NON LETTI"
      if($nErr -ge 0){ $quanti = "" + $nErr }
      $Compilato = "FALLITA (MetaEditor lanciato, nessun .ex5 fresco; errori dal log: " + $quanti + ") -- QUESTO E' IL RISULTATO DEL PASSO: la v1.04 non compila cosi' com'e'"
      [void]$Problemi.Add("COMPILAZIONE FALLITA: nessun .ex5 prodotto in " + $Ex5Path + ". Le prime 30 righe del log sono qui sotto e il log intero e' nello zip. Il PASSO 2 (deploy sul piccolo) NON si fa.")
      if($esito.Muto -or @($LogRighe).Count -eq 0){
        # non e' un errore di codice: e' MetaEditor che torna senza fare
        # niente. E' il rc=0 muto del 22/08, e va detto con quel nome,
        # perche' la cura e' diversa (editor aperto / path / permessi).
        $Compilato = "FALLITA -- METAEDITOR MUTO: e' stato lanciato ed e' tornato SENZA scrivere ne' log ne' .ex5. NON e' un errore di compilazione della v1.04: e' il 'rc=0 muto' del 22/08 (MetaEditor gia' aperto, percorso o permessi). Da rifare dopo aver controllato che metaeditor64 sia chiuso davvero."
        [void]$Problemi.Add("MetaEditor non ha scritto NESSUN log: il passo non ha misurato la compilazione della v1.04, ha misurato un ambiente che non risponde. Non e' un verdetto sul codice.")
      }
      Dico ("COMPILAZIONE FALLITA. Prime 30 righe del log:") "Red"
      $k = 0
      foreach($r in @($LogRighe)){
        if($r.Trim() -eq ""){ continue }
        Write-Host ("      " + $r) -ForegroundColor Red
        $k++
        if($k -ge 30){ break }
      }
      if($k -eq 0){ Write-Host "      (nessun log prodotto: MetaEditor non ha nemmeno scritto il file di log)" -ForegroundColor Red }
    }
  }
}
catch{
  $Fatale = ("" + $_.Exception.Message)
  Write-Host ""
  Write-Host ("!!! FERMATO: " + $Fatale) -ForegroundColor Red
}

# =====================================================================
#  RIPRISTINO -- SEMPRE, anche se il giro e' morto a meta'.
# =====================================================================
$Ripristino = "niente da ripristinare (il terminale non e' mai stato scritto)"
if($IncInstallato){
  try{
    if($IncEraLi -and $IncBackup -ne "" -and (Test-Path -LiteralPath $IncBackup)){
      Copy-Item -LiteralPath $IncBackup -Destination $TIncMqh -Force
      Remove-Item -LiteralPath $IncBackup -Force -ErrorAction SilentlyContinue
      $Ripristino = "include del terminale RIPRISTINATO dal backup (c'era gia' prima di questo giro)"
    }
    else{
      Remove-Item -LiteralPath $TIncMqh -Force -ErrorAction SilentlyContinue
      $Ripristino = "include del terminale RIMOSSO (non c'era prima di questo giro)"
    }
    Remove-Item -LiteralPath $Sentinella -Force -ErrorAction SilentlyContinue
  }
  catch{
    $Ripristino = "RIPRISTINO FALLITO: " + $_.Exception.Message
    [void]$Problemi.Add("RIPRISTINO FALLITO dell'include nel terminale (" + $TIncMqh + "): controllalo a mano prima del PASSO 2.")
  }
}

# =====================================================================
#  RACCOLTA -- SEMPRE
# =====================================================================
Titolo "RACCOLTA"
$Cart = Join-Path $Dsk ("COMPILA_ORB104_" + $Modo + "_" + $Stamp)
if(Test-Path -LiteralPath $Cart){ Remove-Item -LiteralPath $Cart -Recurse -Force -ErrorAction SilentlyContinue }
New-Item -ItemType Directory -Force -Path $Cart | Out-Null

# LA FOTO DOPO: e' qui che il "NESSUN DEPLOY" diventa una MISURA.
$righeD = New-Object System.Collections.ArrayList
$Deploy = "NESSUN DEPLOY e' avvenuto: il giro si e' fermato prima ancora di guardare il terminale, quindi non e' stato scritto niente da nessuna parte"
if($FotoPrese){
  try{
    $F1Dopo = Foto $TExpMq5
    $F2Dopo = Foto $TExpEx5
    $F3Dopo = Foto $TIncMqh
    $toccato = $false
    foreach($t in @(@{N=("Experts\" + $EA + ".mq5"); A=$F1Prima; B=$F1Dopo},
                    @{N=("Experts\" + $EA + ".ex5"); A=$F2Prima; B=$F2Dopo},
                    @{N=("Include\" + $IncNostro);   A=$F3Prima; B=$F3Dopo})){
      $stato = "INVARIATO"
      if($t.A.Esiste -ne $t.B.Esiste -or $t.A.Len -ne $t.B.Len){ $stato = "CAMBIATO"; $toccato = $true }
      elseif($t.A.Ora -ne $t.B.Ora){ $stato = "stessa dimensione, data diversa" }
      [void]$righeD.Add("  " + $t.N + ": prima [" + (FotoTxt $t.A) + "] dopo [" + (FotoTxt $t.B) + "] -> " + $stato)
    }
    $Deploy = "NESSUN DEPLOY e' avvenuto (misurato, non dichiarato: foto prima/dopo dei file del terminale)"
    if($toccato){
      $Deploy = "ATTENZIONE: un file del terminale RISULTA CAMBIATO -- leggi le tre righe qui sotto"
      [void]$Problemi.Add("un file del terminale e' cambiato durante il giro: non doveva succedere. Controlla le foto prima/dopo nel referto PRIMA di qualunque altro passo.")
    }
  }
  catch{
    $Deploy = "FOTO DOPO NON RIFATTA (" + $_.Exception.Message + "): il confronto prima/dopo non e' stato possibile."
    [void]$Problemi.Add("non ho potuto rifare la foto dei file del terminale: il 'nessun deploy' resta DICHIARATO e non MISURATO in questo giro.")
  }
}

$Ref = New-Object System.Collections.ArrayList
[void]$Ref.Add("=====================================================================")
[void]$Ref.Add(" COMPILAZIONE DI PROVA -- " + $EA + " v" + $VersioneAttesa + " (PASSO 1)")
[void]$Ref.Add(" Sequenza firmata da Claudio il 03/09 alle 11:05 (FIRMO IL PERIMETRO")
[void]$Ref.Add(" PICCOLO): prima si vede compilare fuori dal terminale vivo, poi il")
[void]$Ref.Add(" deploy sul SOLO conto piccolo 50503392.")
[void]$Ref.Add("=====================================================================")
[void]$Ref.Add("modo: " + $Modo + "   <- CONTROLLO = giro a vuoto, NON compila e NON e' il risultato")
[void]$Ref.Add("data: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   <- ORA DI AVVIO del giro (non l'ora in cui leggi)")
[void]$Ref.Add("pin:  " + $Pin)
[void]$Ref.Add("")
[void]$Ref.Add("terminale: " + $TermScelto)
[void]$Ref.Add("criterio di scelta: " + $TermCrit)
[void]$Ref.Add("cartella dati: " + $DataFolder)
[void]$Ref.Add("libreria standard: " + $LibStd)
[void]$Ref.Add("cartella di lavoro: " + $MqlW + "  (Experts\ + Include\: e' l'albero che il compilatore si aspetta)")
[void]$Ref.Add("")
[void]$Ref.Add("sorgente al pin: " + $SorgTxt)
[void]$Ref.Add("include al pin:  " + $IncTxt)
[void]$Ref.Add("versione letta dal #property: " + $VersLetta + "   (attesa " + $VersioneAttesa + ", commit del fix 19312c8)")
[void]$Ref.Add("autotest dichiarato nel sorgente: " + $DefineTxt)
[void]$Ref.Add("   (NON viene eseguito qui: gira in OnInit e serve il terminale. Questo passo misura la COMPILAZIONE.)")
[void]$Ref.Add("include censiti nel sorgente: " + $IncluTxt)
[void]$Ref.Add("grep del difetto curato: " + $SelTxt)
[void]$Ref.Add("")
[void]$Ref.Add("compilazione: " + $Compilato)
[void]$Ref.Add("   <- TRE STATI: NON TENTATA (non ci siamo arrivati) / FALLITA (tentata, niente .ex5) / OK (con la dimensione)")
[void]$Ref.Add("riga Result del log: " + $ResultTxt)
[void]$Ref.Add("codice di uscita di metaeditor64: " + $RcTxt + "   (NON LETTO non e' un fallimento: fa fede l'.ex5 e il log)")
if(@($Tentativi).Count -eq 0){ [void]$Ref.Add("tentativi: nessuno") }
else{
  [void]$Ref.Add("tentativi:")
  foreach($t in $Tentativi){ [void]$Ref.Add("  - " + $t) }
}
if($Ex5Path -ne ""){ [void]$Ref.Add(".ex5 prodotto (se c'e') SOLO qui: " + $Ex5Path) }
[void]$Ref.Add("")
[void]$Ref.Add($Deploy)
foreach($r in $righeD){ [void]$Ref.Add($r) }
[void]$Ref.Add("  ripristino: " + $Ripristino)
[void]$Ref.Add("  Niente e' stato installato in MQL5\Experts del terminale: l'unica scrittura possibile")
[void]$Ref.Add("  in tutto questo giro era l'include del TENTATIVO B, con backup e ripristino.")
[void]$Ref.Add("")
if($Modo -eq "CORSA" -and $Compilato -like "OK*" -and $Problemi.Count -eq 0){
  [void]$Ref.Add("COSA SUCCEDE DOPO: la v1.04 COMPILA. Il PASSO 2 (deploy sul SOLO conto")
  [void]$Ref.Add("piccolo 50503392, terminale del VPS, MT5 E METAEDITOR CHIUSI) si fa con")
  [void]$Ref.Add("aggiorna_verifica_orb.ps1 -- e va lanciato con -VersioneAttesa 1.04,")
  [void]$Ref.Add("altrimenti il suo default (1.02) lo fa fermare da solo.")
  [void]$Ref.Add("ATTENZIONE, PRIMA DI LANCIARLO: quello script del 22/08 aggiorna ENTRAMBE")
  [void]$Ref.Add("le istanze (piccolo E 100k -V3). Il perimetro firmato il 03/09 dice SOLO")
  [void]$Ref.Add("il piccolo: va ristretto PRIMA, non dopo.")
}
else{
  [void]$Ref.Add("COSA SUCCEDE DOPO: il PASSO 2 (deploy sul piccolo) NON si fa. Questo passo")
  [void]$Ref.Add("non ha detto 'compila': ha detto quello che c'e' scritto nel campo")
  [void]$Ref.Add("compilazione: qui sopra.")
}
[void]$Ref.Add("")
if($Fatale -ne ""){ [void]$Ref.Add("!!! FERMATO: " + $Fatale); [void]$Ref.Add("") }
if(@($LogRighe).Count -gt 0){
  [void]$Ref.Add("--- PRIME 30 RIGHE DEL LOG DI METAEDITOR (il log intero e' COMPILAZIONE.log nello zip) ---")
  $k = 0
  foreach($r in @($LogRighe)){
    if($r.Trim() -eq ""){ continue }
    [void]$Ref.Add("  " + $r.Trim())
    $k++
    if($k -ge 30){ break }
  }
  [void]$Ref.Add("")
}
[void]$Ref.Add("PROBLEMI: " + $Problemi.Count)
foreach($p in $Problemi){ [void]$Ref.Add("  - " + $p) }
[void]$Ref.Add("RILIEVI: " + $Rilievi.Count)
foreach($p in $Rilievi){ [void]$Ref.Add("  - " + $p) }
[void]$Ref.Add("")
[void]$Ref.Add("COME SI RIPRENDE: dalla pagina righe/RIGA_COMPILA_ORB104_DA_MANDARE.md,")
[void]$Ref.Add("NON da questa riga (il pin nasce dentro il blocco e non sopravvive).")

$refPath = Join-Path $Cart "REFERTO_COMPILA_ORB104.txt"
Set-Content -LiteralPath $refPath -Value ($Ref -join "`r`n") -Encoding ASCII
Write-Host ($Ref -join "`r`n")

$logSrc = Join-Path $Work "COMPILAZIONE.log"
if(Test-Path -LiteralPath $logSrc){
  # il log esce in UTF-16: nello zip ci va ANCHE una copia in ASCII,
  # cosi' si legge da qualunque cosa senza sorprese di codifica.
  Copy-Item -LiteralPath $logSrc -Destination (Join-Path $Cart "COMPILAZIONE.log") -Force
  Set-Content -LiteralPath (Join-Path $Cart "COMPILAZIONE_leggibile.txt") -Value ((LeggiTesto $logSrc) -join "`r`n") -Encoding ASCII
}

$zip = $Cart + ".zip"
Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $zip -Force
Write-Host ""
Write-Host ("CARTELLA: " + $Cart) -ForegroundColor Green
Write-Host ("ZIP DA MANDARE: " + $zip) -ForegroundColor Green
Write-Host "FILE ATTESI NELLO ZIP: REFERTO_COMPILA_ORB104.txt + COMPILAZIONE.log + COMPILAZIONE_leggibile.txt" -ForegroundColor Gray
Write-Host "   (il log manca solo se MetaEditor non e' mai stato lanciato: modo CONTROLLO o gate scattato prima)" -ForegroundColor Gray
Write-Host "NESSUN .ex5 E NESSUN .mq5 SONO STATI INSTALLATI NEL TERMINALE: il referto lo dimostra con le foto prima/dopo." -ForegroundColor Gray

if($Fatale -ne ""){ Write-Host "ESITO: FERMATO" -ForegroundColor Red; exit 1 }
if($Problemi.Count -gt 0){ Write-Host "ESITO: COMPLETATO CON PROBLEMI" -ForegroundColor Yellow; exit 1 }
Write-Host ("ESITO: " + $Modo + " COMPLETATO") -ForegroundColor Green
exit 0
