# =====================================================================
#  MARCATORE_RIGA_DEPLOY_CONTOREALE_v1
#  RIGA_DEPLOY_CONTOREALE.ps1 -- INSTALLA E COMPILA LE DUE SEDIE VERE
#  sul SOLO terminale del conto REALE, il cui numero lo deve dire
#  CLAUDIO con -LoginAtteso.
#
#  >>> QUESTA RIGA E' DIVERSA DA TUTTE LE ALTRE DI CASA, E VA DETTO
#      SUBITO: fino a ieri sul conto reale c'era ABTG_SlippageLogger,
#      un artefatto di SOLA LETTURA in cui le funzioni per mandare un
#      ordine NON ESISTEVANO nel sorgente. Qui no. Qui si installano
#      DUE EA che aprono, modificano e chiudono posizioni con SOLDI
#      VERI (7.500 EUR). Il perimetro non e' piu' "l'artefatto non puo'
#      fare danno per costruzione": e' "l'artefatto puo' fare danno, e
#      allora si controlla tutto quello che si puo' controllare PRIMA".
#
#  >>> COSA INSTALLA, E DOVE (solo in modo CORSA, e SOLO li'):
#        <dati>\MQL5\Experts\ABTG_DAX_Apertura_EU.mq5     (v1.01)
#        <dati>\MQL5\Experts\ABTG_DAX_Apertura_EU.ex5     (compilato qui)
#        <dati>\MQL5\Experts\ABTG_ORB_Ottimizzato.mq5     (v1.04)
#        <dati>\MQL5\Experts\ABTG_ORB_Ottimizzato.ex5     (compilato qui)
#        <dati>\MQL5\Include\ABTG_PausaGuardian.mqh       (include condiviso)
#        <dati>\MQL5\Presets\ABTG_DAX_Apertura_EU_770101_REALE.set
#        <dati>\MQL5\Presets\ABTG_ORB_Ottimizzato_770611_REALE.set
#      SETTE FILE, NIENT'ALTRO. Nessun .chr, nessun .ini, nessun
#      profilo, nessuna GlobalVariable.
#
#  >>> QUELLO CHE QUESTA RIGA NON FA, E NON PUO' FARE:
#      - NON ATTACCA MAI L'EA A UN GRAFICO. Non esiste in questo file
#        nessun percorso che scriva dentro Profiles\Charts o config\:
#        il gesto di trascinare l'EA sul grafico e caricare il preset
#        e' MANUALE, di Claudio, con la legge dello screenshot. Che i
#        parametri e i grafici non siano stati toccati lo DIMOSTRA una
#        foto (conteggio, byte, ultima scrittura) prima e dopo.
#      - NON TOCCA L'AUTOTRADING. Non c'e' nessun modo di accenderlo da
#        qui, e non ci si prova: lo accende Claudio, e finche' e'
#        spento nessuno di questi due EA puo' mandare un ordine.
#      - NON TOCCA ABTG_SlippageLogger. Sullo STESSO conto reale gira
#        gia' il logger dello slippage (installato il 05/09): questa
#        riga non lo reinstalla, non lo ricompila, non lo cancella e
#        non tocca il suo registro in MQL5\Files. I suoi due file sono
#        FOTOGRAFATI prima e dopo e devono risultare INVARIATI. Il suo
#        REGISTRO invece puo' benissimo crescere durante il giro (il
#        logger scrive ogni 10 secondi, se MT5 e' aperto): quello si
#        dichiara come ATTESO, non come problema -- pretendere che un
#        file vivo non cambi sarebbe un controllo finto.
#
#  >>> LA GUARDIA SUL CONTO E' LA STESSA DEL LOGGER, PAROLA PER PAROLA,
#      perche' e' gia' stata collaudata su quattro finti terminali:
#      1. -LoginAtteso E' OBBLIGATORIO. Senza, la riga non parte.
#      2. IL PICCOLO 50503392 E IL 100k 50504263 SONO VIETATI PER
#         SEMPRE, e non c'e' nessuna manopola che li sblocchi. Se
#         -LoginAtteso e' uno di quei due, la riga si ferma subito. Se
#         una cartella candidata mostra uno di quei due login nei log,
#         la cartella e' SCARTATA -- anche se ci fosse dentro pure il
#         login atteso, perche' un terminale che ha visto tutti e due
#         non dice a quale conto e' collegato ADESSO.
#      3. IL LOGIN ATTESO DEVE COMPARIRE NEI LOG della cartella scelta
#         (finestra di 180 giorni, larga apposta).
#      4. Se il login atteso NON si trova, la riga si FERMA e stampa
#         tutto quello che ha guardato. Si va avanti solo con
#         l'ATTESTAZIONE A MANO -- -CartellaDati "<percorso>" e
#         -ConfermoConto <lo stesso numero> -- cioe' scrivendo il
#         numero DUE VOLTE. E' una firma, non una scorciatoia, e il
#         referto la scrive come "SCELTA ATTESTATA A MANO, NON
#         MISURATA". Il punto 2 resta valido lo stesso.
#      5. CONFERMA INCROCIATA IN PIU', che il logger non aveva: nella
#         cartella scelta deve gia' esserci ABTG_SlippageLogger,
#         installato ieri sul reale. Se non c'e' e' un RILIEVO forte
#         (non un blocco: il logger potrebbe essere altrove), e va
#         letto prima di andare avanti.
#
#  >>> I GATE SUI PRESET SONO LA PARTE NUOVA, ED E' QUELLA CHE VALE
#      DI PIU'. Un preset e' il file che decide quanti soldi si
#      rischiano a ogni trade: qui viene APERTO E CONTATO, non copiato
#      a scatola chiusa.
#      a) ogni riga del .set dev'essere vuota, un commento ';' oppure
#         un 'chiave=valore' con chiave che e' un identificatore. Una
#         riga malformata NON e' innocua: MT5 la salta in silenzio, e
#         un preset che si carica a meta' non lo vedi;
#      b) OGNI CHIAVE del .set dev'essere un input DAVVERO DICHIARATO
#         nel .mq5 allo stesso pin (una chiave scritta male viene
#         ignorata da MT5 senza dire niente);
#      c) OGNI INPUT del .mq5 dev'essere presente nel .set. Un input
#         che manca prende il DEFAULT COMPILATO, in silenzio: e' esatta-
#         mente la trappola del 2% chiusa il 02/09 (verbale
#         VERBALE_CHIUSURA_770101_2026-09-02.md). Su un conto reale non
#         si accetta;
#      d) InpMagic dev'essere ESATTAMENTE quello atteso (770101 / 770611)
#         e i due magic devono essere DIVERSI fra loro;
#      e) InpRiskPercent dev'essere ESATTAMENTE 0.65, e comunque
#         qualunque chiave che contenga "Risk" dev'essere <= 1.0 (tetto
#         A4: mai sopra l'1% per trade). Un preset col rischio sbagliato
#         non entra nel terminale;
#      f) e il default COMPILATO del rischio nel .mq5 dev'essere <= 1.0
#         lo stesso, cosi' anche un RIPRISTINA fatto per sbaglio non
#         puo' riportare il 2%.
#
#  >>> MT5 PUO' RESTARE APERTO (il logger continua a misurare, e le
#      sedie del conto reale non ci sono ancora). METAEDITOR si
#      PRETENDE CHIUSO: e' single-instance e con l'editor aperto la
#      compilazione da riga di comando torna muta (misurato il 22/08).
#
#  >>> TUTTO O NIENTE. Se una sola delle due compilazioni fallisce,
#      TUTTI E SETTE i file tornano com'erano. Mezzo deploy su un conto
#      reale e' peggio di nessun deploy.
#
#  >>> IL VERDETTO STA SULL'ARTEFATTO, NON SUL CODICE DI USCITA (classe
#      108): metaeditor64 sul VPS torna 1 anche quando compila.
#
#  QUANTO CI METTE [STIMA]: 2-4 minuti (5 download + 2 compilazioni).
#
#  LA RIGA CHE SI INCOLLA sta in
#  righe\RIGA_DEPLOY_CONTOREALE_DA_MANDARE.md
# =====================================================================
[CmdletBinding()]
param(
  # -Pin NON ha default: un default silenzioso ("lavoro") farebbe girare
  #  la punta del branch spacciandola per un commit congelato.
  [string]$Pin = "",
  # -LoginAtteso NON ha default, ed e' OBBLIGATORIO.
  [string]$LoginAtteso = "",
  [ValidateSet("CONTROLLO","CORSA")]
  [string]$Modo = "CONTROLLO",
  [string]$CartellaDati = "",
  # -ConfermoConto: l'attestazione a mano. Lo stesso numero di
  #  -LoginAtteso, e serve SOLO quando il login non si trova nei log.
  #  Non sblocca i conti vietati.
  [string]$ConfermoConto = "",
  [string]$BaseAttesa = "",
  [int]$TimeoutSec = 240
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

# --- LE DUE SEDIE ----------------------------------------------------
$EA1     = "ABTG_DAX_Apertura_EU"
$VER1    = "1.01"
$MAGIC1  = "770101"
$SET1    = "ABTG_DAX_Apertura_EU_770101_REALE.set"
$SIMB1   = "D30EUR"
$AVVIO1  = "[DAX Apertura EU] avviato su " + $SIMB1

$EA2     = "ABTG_ORB_Ottimizzato"
$VER2    = "1.04"
$MAGIC2  = "770611"
$SET2    = "ABTG_ORB_Ottimizzato_770611_REALE.set"
$SIMB2   = "U30USD"
$AVVIO2  = "[ORB_OTT] avviato su " + $SIMB2
$ORB_BLOCCHI = 10
$ORB_CASI    = 33

$INC     = "ABTG_PausaGuardian.mqh"
$LOGGER  = "ABTG_SlippageLogger"

# IL RISCHIO. 0,65% per trade e' la taglia firmata per il conto reale
# (con 7.500 EUR fanno ~49 EUR a trade). Il TETTO 1,0 e' la riga rossa
# A4 e non si supera nemmeno per sbaglio di battitura.
$RISCHIO_ATTESO = 0.65
$RISCHIO_TETTO  = 1.0

# I DUE CONTI VIETATI: i due DEMO della flotta. Questa riga installa EA
# che APRONO ORDINI: se finisse sul piccolo o sul 100k, ci ritrovereb-
# bero due sedie doppie che tradano in parallelo a quelle gia' vive.
$VIETATI_CONTI = @("50503392","50504263")

$Avvio = Get-Date
$Stamp = $Avvio.ToString("yyyyMMdd_HHmm", $INV)

function TrovaDesktop(){
  foreach($p in @([Environment]::GetFolderPath("Desktop"),
                  (Join-Path $env:USERPROFILE "Desktop"),
                  (Join-Path $env:USERPROFILE "OneDrive\Desktop"))){
    if($p -and (Test-Path -LiteralPath $p)){ return $p }
  }
  return $env:USERPROFILE
}
$Dsk        = TrovaDesktop
$Work       = Join-Path $env:USERPROFILE "abtg_deploy_contoreale"
$Scaricati  = Join-Path $Work "scaricati"
$Sentinella = Join-Path $Work "DEPLOY_CONTOREALE_IN_CORSO.txt"
$Log1Path   = Join-Path $Work "COMPILAZIONE_DAX.log"
$Log2Path   = Join-Path $Work "COMPILAZIONE_ORB.log"
$RawPin     = ""

# --- ogni campo che la raccolta stampa nasce QUI, PRIMA del try, e
#     parte da uno stato VERO ("non ci siamo arrivati"), mai da uno
#     stato che somigli a un risultato (classe 125).
$Problemi   = New-Object System.Collections.ArrayList
$Rilievi    = New-Object System.Collections.ArrayList
$Cand       = New-Object System.Collections.ArrayList
$righeC     = New-Object System.Collections.ArrayList
[void]$righeC.Add("CARTELLE GUARDATE: nessuna scansione (il giro si e' fermato prima di cercare la cartella dati)")
$Fatale     = ""
$Comp1      = "NON TENTATA (non ci siamo arrivati)"
$Comp2      = "NON TENTATA (non ci siamo arrivati)"
$Result1    = "NON LETTA"
$Result2    = "NON LETTA"
$Rc1        = "NON LETTO"
$Rc2        = "NON LETTO"
$InstallTxt = "NON AVVENUTA (il giro si e' fermato prima di scrivere nel terminale)"
$BackupTxt  = "NON FATTO (non ci siamo arrivati)"
$Ripristino = "niente da ripristinare (il terminale non e' mai stato scritto)"
$Scelta     = "NON SCELTA"
$Criterio   = "n/d"
$Inst       = "n/d"
$Me         = ""
$SorgTxt    = New-Object System.Collections.ArrayList
$SetTxt     = New-Object System.Collections.ArrayList
$GateTxt    = New-Object System.Collections.ArrayList
$DemoTxt    = "NON VERIFICATO (non ci siamo arrivati)"
$ParamTxt   = "NON VERIFICATO (non ci siamo arrivati)"
$PresetsTxt = "NON VERIFICATO (non ci siamo arrivati)"
$LoggerTxt  = "NON VERIFICATO (non ci siamo arrivati)"
$GiaLi      = "NON VERIFICATO"
$ContoTxt   = "NON MISURATO"
$BasiTxt    = "NON LETTE"
$LoggerQui  = "NON VERIFICATO"
$ScrittoNelTerminale = $false
$SetCopiati = $false
$BackupDir  = ""
$Reale      = $null
$DemoCand   = @()
$Art        = @()
$FotoP      = @{}
$FotoDemo   = New-Object System.Collections.ArrayList
$FotoDopo   = New-Object System.Collections.ArrayList
$FotoLog    = New-Object System.Collections.ArrayList
$DirParam   = @()
$FotoDirP   = @{}
$InvPreP    = @{}
$InvFileP   = @{}
$Log1Righe  = @()
$Log2Righe  = @()
$FotoPrese  = $false
$MqlDir     = ""

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
# INVENTARIO di una cartella FILE PER FILE. Serve dove la cartella DEVE
# cambiare (Presets: ci scriviamo i due .set) e bisogna dimostrare che
# e' cambiato SOLO quello che dovevamo cambiare noi.
function Inventario([string]$path,[string]$filtro){
  $h = @{}
  if(-not (Test-Path -LiteralPath $path)){ return $h }
  $f = @()
  try{ $f = @(Get-ChildItem -LiteralPath $path -File -ErrorAction Stop | Where-Object { $_.Name -like $filtro }) }catch{ return $h }
  foreach($x in $f){ $h[$x.Name] = "" + $x.Length + "|" + (Hash16 $x.FullName) }
  return $h
}
function ConfrontaInventario($prima,$dopo,$attesi){
  $agg = New-Object System.Collections.ArrayList
  $cam = New-Object System.Collections.ArrayList
  $tolti = New-Object System.Collections.ArrayList
  foreach($k in $dopo.Keys){
    if(-not $prima.ContainsKey($k)){ [void]$agg.Add($k) }
    elseif($prima[$k] -ne $dopo[$k]){ [void]$cam.Add($k) }
  }
  foreach($k in $prima.Keys){ if(-not $dopo.ContainsKey($k)){ [void]$tolti.Add($k) } }
  $inattesi = New-Object System.Collections.ArrayList
  foreach($k in @($agg)){ $ok=$false; foreach($a in $attesi){ if($k -ieq $a){ $ok=$true } }; if(-not $ok){ [void]$inattesi.Add("AGGIUNTO " + $k) } }
  foreach($k in @($cam)){ $ok=$false; foreach($a in $attesi){ if($k -ieq $a){ $ok=$true } }; if(-not $ok){ [void]$inattesi.Add("CAMBIATO " + $k) } }
  foreach($k in @($tolti)){ [void]$inattesi.Add("SPARITO " + $k) }
  return [pscustomobject]@{ Agg=@($agg); Cam=@($cam); Tolti=@($tolti); Inattesi=@($inattesi) }
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

function CensisciInclude([string]$path){
  $trovati = New-Object System.Collections.ArrayList
  foreach($riga in (LeggiTesto $path)){
    $viva = ($riga -replace '//.*$','')
    $m = [regex]::Match($viva, '^\s*#include\s*[<"]([^>"]+)[>"]')
    if($m.Success){ [void]$trovati.Add($m.Groups[1].Value.Trim()) }
  }
  return @($trovati)
}

# GLI INPUT DICHIARATI in un .mq5. Torna la lista dei NOMI, in ordine.
# Le righe 'input group "..."' non matchano (dopo il tipo c'e' una
# virgoletta, non un identificatore): e' voluto, un gruppo non e' un
# parametro.
function InputDichiarati([string]$path){
  $nomi = New-Object System.Collections.ArrayList
  foreach($riga in (LeggiTesto $path)){
    $viva = ($riga -replace '//.*$','')
    $m = [regex]::Match($viva, '^\s*(?:input|sinput)\s+[A-Za-z_][A-Za-z0-9_]*\s+([A-Za-z_][A-Za-z0-9_]*)')
    if($m.Success){ [void]$nomi.Add($m.Groups[1].Value) }
  }
  return @($nomi)
}

# LEGGE UN .set. Torna chiavi (hashtable), l'ordine, e le righe che NON
# sono ne' vuote ne' commenti ';' ne' 'chiave=valore'.
function LeggiSet([string]$path){
  $kv = @{}
  $ordine = New-Object System.Collections.ArrayList
  $brutte = New-Object System.Collections.ArrayList
  $doppie = New-Object System.Collections.ArrayList
  $n = 0
  foreach($riga in (LeggiTesto $path)){
    $n++
    $s = $riga.Trim()
    if($s -eq ""){ continue }
    if($s.StartsWith(";")){ continue }
    $i = $s.IndexOf("=", [System.StringComparison]::Ordinal)
    if($i -lt 1){ [void]$brutte.Add("riga " + $n + ": " + $s); continue }
    $k = $s.Substring(0,$i)
    if($k -notmatch '^[A-Za-z_][A-Za-z0-9_]*$'){ [void]$brutte.Add("riga " + $n + ": " + $s); continue }
    # MT5 ammette 'nome=valore||start||step||stop||flag': si tiene solo
    # il valore, il resto e' roba da ottimizzatore e qui non serve.
    $v = $s.Substring($i+1)
    $j = $v.IndexOf("||", [System.StringComparison]::Ordinal)
    if($j -ge 0){ $v = $v.Substring(0,$j) }
    if($kv.ContainsKey($k)){ [void]$doppie.Add($k) }
    $kv[$k] = $v
    [void]$ordine.Add($k)
  }
  return [pscustomobject]@{ KV=$kv; Ordine=@($ordine); Brutte=@($brutte); Doppie=@($doppie) }
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
function Compila([string]$exe,[string[]]$argomenti,[string]$ex5,[string]$log,[int]$tetto,[string]$chi){
  Remove-Item -LiteralPath $log -Force -ErrorAction SilentlyContinue
  $t0 = Get-Date
  Dico ("metaeditor64 (" + $chi + "): " + $exe + " " + ($argomenti -join " ")) "Yellow"
  $global:LASTEXITCODE = $null
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
    if($sec -ge ($battito + 10)){ $battito = [int]$sec; Dico ("   ... aspetto l'.ex5 di " + $chi + " da " + $battito + "s (tetto " + $tetto + "s): NON interrompere, la riga si ferma da sola") }
    Start-Sleep -Seconds 2
  }
  if((Test-Path -LiteralPath $ex5) -and ((Get-Item -LiteralPath $ex5).LastWriteTime -ge $t0)){ $fresco = $true }
  return @{ Ex5=$fresco; Rc=$grezzo; Log=(LeggiTesto $log); Avvio=$t0; Muto=$muto }
}

function RipristinaDaBackup([string]$dir,[string[]]$dest){
  $esiti = New-Object System.Collections.ArrayList
  foreach($d in $dest){
    if([string]::IsNullOrEmpty($d)){ continue }
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
  Titolo ("DEPLOY DELLE DUE SEDIE VERE SUL SOLO CONTO REALE -- modo " + $Modo)
  Write-Host "ATTENZIONE: questi NON sono logger. Sono DUE EA CHE APRONO ORDINI CON SOLDI VERI." -ForegroundColor Red
  if($Modo -eq "CONTROLLO"){ Write-Host "MODO CONTROLLO: questo giro NON scrive niente nel terminale. Mostra cosa farebbe la CORSA." -ForegroundColor Yellow }
  else{ Write-Host "MODO CORSA: scrive SETTE file nella sola cartella dati scelta, con backup e ripristino TOTALE su qualunque fallimento." -ForegroundColor Yellow }
  Write-Host "QUESTA RIGA NON ATTACCA NESSUN EA A NESSUN GRAFICO E NON TOCCA L'AUTOTRADING: quelli sono gesti MANUALI di Claudio." -ForegroundColor Yellow
  Write-Host ("E NON TOCCA " + $LOGGER + ", che sullo stesso conto sta gia' misurando.") -ForegroundColor Yellow

  # -------------------------------------------------------------------
  #  0. LE GUARDIE
  # -------------------------------------------------------------------
  if($Pin -eq ""){ throw "-Pin obbligatorio: senza, girerebbe la punta del branch spacciandola per un commit congelato." }
  if($Pin -notmatch '^[0-9a-f]{40}$'){ throw ("-Pin deve essere un commit di 40 caratteri esadecimali, ricevuto: " + $Pin) }
  $RawPin = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/" + $Pin

  if($LoginAtteso -eq ""){
    throw "-LoginAtteso OBBLIGATORIO: devi dirmi il numero del conto REALE. Non lo indovino dal nome di una cartella, e qui si installano EA che aprono ordini veri."
  }
  if($LoginAtteso -notmatch '^\d{5,12}$'){ throw ("-LoginAtteso deve essere un numero di conto (5-12 cifre), ricevuto: " + $LoginAtteso) }
  foreach($v in $VIETATI_CONTI){
    if($LoginAtteso -eq $v){
      throw ("IL CONTO " + $v + " E' VIETATO PER QUESTA RIGA: e' uno dei due conti DEMO della flotta, dove " + $EA1 + " e " + $EA2 + " GIA' GIRANO. Installarli li' vorrebbe dire due sedie doppie sullo stesso magic. Se volevi il reale, ricontrolla il numero.")
    }
  }
  if($ConfermoConto -ne "" -and $ConfermoConto -ne $LoginAtteso){
    throw ("-ConfermoConto (" + $ConfermoConto + ") e -LoginAtteso (" + $LoginAtteso + ") non coincidono. L'attestazione a mano serve proprio a farti scrivere il numero DUE VOLTE: se i due numeri non sono uguali, mi fermo.")
  }
  if($MAGIC1 -eq $MAGIC2){ throw ("I DUE MAGIC SONO UGUALI (" + $MAGIC1 + "): due sedie con lo stesso magic si gestirebbero le posizioni a vicenda. Non installo.") }

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
    [void]$Rilievi.Add("MT5 APERTO (" + (@($term | ForEach-Object { "pid " + $_.Id }) -join ", ") + "): e' ATTESO e va bene. I due EA sono file NUOVI per questo terminale, non stanno su nessun grafico, quindi la compilazione non scarica niente; e questa riga non scrive dentro config\ ne' nei .chr, che sono i file che MT5 riscrive all'uscita (checklist punto 7). Il logger dello slippage continua a misurare.")
    Dico "MT5 aperto: atteso, il logger continua a misurare" "Green"
  }
  else{
    [void]$Rilievi.Add("MT5 CHIUSO in questo giro: l'installazione riesce lo stesso, ma le sedie cominceranno a lavorare solo quando riaprirai il terminale, le attaccherai ai grafici e accenderai l'AutoTrading.")
  }
  Dico ("pin ............ " + $Pin)
  Dico ("conto atteso ... " + $LoginAtteso + "   (vietati per sempre: " + ($VIETATI_CONTI -join ", ") + ")") "Yellow"
  Dico ("rischio preteso  " + $RISCHIO_ATTESO.ToString($INV) + "%   (tetto invalicabile " + $RISCHIO_TETTO.ToString($INV) + "%)") "Yellow"
  Dico ("cartella di lavoro: " + $Work)

  # -------------------------------------------------------------------
  #  1. CARTELLA DI LAVORO + SENTINELLA di un giro interrotto
  # -------------------------------------------------------------------
  Titolo "1. CARTELLA DI LAVORO e SENTINELLA"
  New-Item -ItemType Directory -Force -Path $Work | Out-Null
  if(Test-Path -LiteralPath $Scaricati){ Remove-Item -LiteralPath $Scaricati -Recurse -Force }
  New-Item -ItemType Directory -Force -Path $Scaricati | Out-Null
  Remove-Item -LiteralPath $Log1Path -Force -ErrorAction SilentlyContinue
  Remove-Item -LiteralPath $Log2Path -Force -ErrorAction SilentlyContinue
  if(Test-Path -LiteralPath $Sentinella){
    $rs = @(Get-Content -LiteralPath $Sentinella -ErrorAction SilentlyContinue)
    $sDest = @()
    $sBack = ""
    if(@($rs).Count -ge 2){
      $sBack = ("" + $rs[@($rs).Count - 1]).Trim()
      for($i=0; $i -lt (@($rs).Count - 1); $i++){ $sDest = $sDest + @(("" + $rs[$i]).Trim()) }
    }
    if($Modo -eq "CORSA" -and @($sDest).Count -ge 1 -and $sBack -ne "" -and (Test-Path -LiteralPath $sBack)){
      $es = RipristinaDaBackup $sBack $sDest
      Remove-Item -LiteralPath $Sentinella -Force -ErrorAction SilentlyContinue
      [void]$Rilievi.Add("UN GIRO PRECEDENTE ERA STATO INTERROTTO fra backup e fine: i file sono stati RIMESSI dal backup " + $sBack + " adesso, all'avvio (" + ($es -join "; ") + ").")
      Dico "sentinella di un giro interrotto: file rimessi dal backup" "Yellow"
    }
    else{
      [void]$Problemi.Add("SENTINELLA DI UN GIRO INTERROTTO trovata (" + $Sentinella + "): un giro precedente e' stato fermato a mano fra il backup e la fine. Questo giro in " + $Modo + " NON scrive nel terminale: rilancia in CORSA (rimette a posto da solo dal backup " + $sBack + ") oppure guarda a mano.")
      if($Modo -eq "CORSA"){ throw ("SENTINELLA ILLEGGIBILE o backup mancante (" + $sBack + "): non tocco il terminale finche' non e' chiaro cosa c'e' dentro.") }
    }
  }

  # -------------------------------------------------------------------
  #  2. SCARICO AL PIN + GATE DI IDENTITA' SUI CINQUE FILE
  # -------------------------------------------------------------------
  Titolo "2. SCARICO AL PIN E GATE (versioni, include, e soprattutto I DUE PRESET)"
  $Mq5_1 = Join-Path $Scaricati ($EA1 + ".mq5")
  $Mq5_2 = Join-Path $Scaricati ($EA2 + ".mq5")
  $Mqh   = Join-Path $Scaricati $INC
  $Set_1 = Join-Path $Scaricati $SET1
  $Set_2 = Join-Path $Scaricati $SET2
  Scarica ($RawPin + "/mql5/Experts/" + $EA1 + ".mq5") $Mq5_1
  Scarica ($RawPin + "/mql5/Experts/" + $EA2 + ".mq5") $Mq5_2
  Scarica ($RawPin + "/mql5/Include/" + $INC)          $Mqh
  Scarica ($RawPin + "/mql5/Presets/conto_reale/" + $SET1) $Set_1
  Scarica ($RawPin + "/mql5/Presets/conto_reale/" + $SET2) $Set_2
  [void]$SorgTxt.Add($EA1 + ".mq5 : " + (Descrivi $Mq5_1))
  [void]$SorgTxt.Add($EA2 + ".mq5 : " + (Descrivi $Mq5_2))
  [void]$SorgTxt.Add($INC + " : " + (Descrivi $Mqh))
  [void]$SorgTxt.Add($SET1 + " : " + (Descrivi $Set_1))
  [void]$SorgTxt.Add($SET2 + " : " + (Descrivi $Set_2))
  foreach($x in $SorgTxt){ Dico ("scaricato " + $x) "Green" }

  $righe1 = LeggiTesto $Mq5_1
  $righe2 = LeggiTesto $Mq5_2
  $testo1 = ($righe1 -join "`n")
  $testo2 = ($righe2 -join "`n")

  # --- versioni
  $mv1 = [regex]::Match($testo1, '#property\s+version\s+"([^"]+)"')
  $mv2 = [regex]::Match($testo2, '#property\s+version\s+"([^"]+)"')
  if(-not $mv1.Success){ throw ("in " + $EA1 + ".mq5 non c'e' nessun #property version: non e' il file che credo.") }
  if(-not $mv2.Success){ throw ("in " + $EA2 + ".mq5 non c'e' nessun #property version: non e' il file che credo.") }
  $v1 = $mv1.Groups[1].Value
  $v2 = $mv2.Groups[1].Value
  if($v1 -ne $VER1){ throw ("VERSIONE SBAGLIATA per " + $EA1 + ": al pin c'e' la v" + $v1 + ", attesa la v" + $VER1 + ". NON installo.") }
  if($v2 -ne $VER2){ throw ("VERSIONE SBAGLIATA per " + $EA2 + ": al pin c'e' la v" + $v2 + ", attesa la v" + $VER2 + ". NON installo.") }
  [void]$GateTxt.Add("versioni: " + $EA1 + " v" + $v1 + " (attesa " + $VER1 + ") | " + $EA2 + " v" + $v2 + " (attesa " + $VER2 + ")")

  # --- il magic COMPILATO del DAX (e' un #define, non un input nudo)
  $mm1 = [regex]::Match($testo1, 'ABTG_DEF_MAGIC\s+(\d+)')
  if(-not $mm1.Success){ throw ("in " + $EA1 + ".mq5 non trovo #define ABTG_DEF_MAGIC: non e' il file che credo.") }
  if($mm1.Groups[1].Value -ne $MAGIC1){ throw ("MAGIC COMPILATO SBAGLIATO in " + $EA1 + ": " + $mm1.Groups[1].Value + ", atteso " + $MAGIC1 + ". NON installo.") }

  # --- IL DEFAULT COMPILATO DEL RISCHIO. E' la cintura del 02/09: se un
  #     domani qualcuno rifacesse RIPRISTINA sul grafico, i parametri
  #     tornerebbero a QUESTO numero. Sopra 1,0 non si installa.
  $mr1 = [regex]::Match($testo1, 'ABTG_DEF_RISK\s+([0-9]+(?:\.[0-9]+)?)')
  if(-not $mr1.Success){ throw ("in " + $EA1 + ".mq5 non trovo #define ABTG_DEF_RISK: non posso verificare il default compilato del rischio, e su un conto reale questo non si salta.") }
  $r1def = [double]::Parse($mr1.Groups[1].Value, $INV)
  if($r1def -gt $RISCHIO_TETTO){ throw ("IL DEFAULT COMPILATO DEL RISCHIO di " + $EA1 + " e' " + $r1def.ToString($INV) + "%, sopra il tetto " + $RISCHIO_TETTO.ToString($INV) + "% (riga rossa A4). E' la trappola chiusa il 02/09: NON installo.") }
  $mr2 = [regex]::Match($testo2, 'input\s+double\s+InpRiskPercent\s*=\s*([0-9]+(?:\.[0-9]+)?)')
  if(-not $mr2.Success){ throw ("in " + $EA2 + ".mq5 non trovo il default di InpRiskPercent: non posso verificare il default compilato, e su un conto reale questo non si salta.") }
  $r2def = [double]::Parse($mr2.Groups[1].Value, $INV)
  if($r2def -gt $RISCHIO_TETTO){ throw ("IL DEFAULT COMPILATO DEL RISCHIO di " + $EA2 + " e' " + $r2def.ToString($INV) + "%, sopra il tetto " + $RISCHIO_TETTO.ToString($INV) + "%. NON installo.") }
  [void]$GateTxt.Add("default COMPILATI del rischio (quelli che tornerebbero con un RIPRISTINA sul grafico): " + $EA1 + " " + $r1def.ToString($INV) + "% | " + $EA2 + " " + $r2def.ToString($INV) + "%   -- tetto " + $RISCHIO_TETTO.ToString($INV) + "%: rispettato")

  # --- l'autotest della v1.04 dell'ORB: e' l'unica prova che in Esperti
  #     distinguera' la v1.04 dalla v1.02 (la v1.02 non lo stampa affatto)
  $mb = [regex]::Match($testo2, 'ORBOTT_AUTOTEST_BLOCCHI_ATTESI\s+(\d+)')
  $mc = [regex]::Match($testo2, 'ORBOTT_AUTOTEST_CASI_ATTESI\s+(\d+)')
  if(-not ($mb.Success -and $mc.Success)){ throw ("in " + $EA2 + ".mq5 non trovo i #define dell'autotest: non e' la v1.04 attesa.") }
  $nB = [int]::Parse($mb.Groups[1].Value, $INV)
  $nC = [int]::Parse($mc.Groups[1].Value, $INV)
  if($nB -ne $ORB_BLOCCHI -or $nC -ne $ORB_CASI){ throw ("SORGENTE ORB DIVERSO DA QUELLO FIRMATO: l'autotest dichiara " + $nB + " blocchi / " + $nC + " casi, attesi " + $ORB_BLOCCHI + " / " + $ORB_CASI + ". NON installo.") }
  $nSel = 0
  foreach($riga in $righe2){
    $viva = ($riga -replace '//.*$','')
    if($viva -match 'PositionSelect\s*\(\s*_Symbol'){ $nSel++ }
  }
  if($nSel -gt 0){ throw ("IL FIX HEDGING NON E' COMPLETO nell'ORB al pin: " + $nSel + " occorrenze di PositionSelect(_Symbol) fuori dai commenti (attese 0). Su un conto HEDGING quello e' il difetto curato dalla v1.04: NON installo.") }
  [void]$GateTxt.Add("autotest ORB dichiarato: " + $nB + " blocchi / " + $nC + " casi; PositionSelect(_Symbol) fuori dai commenti: 0 (fix hedging completo)")

  # --- include: solo Trade/Trade.mqh (di libreria) e il nostro
  $altriInc = New-Object System.Collections.ArrayList
  foreach($f in @($Mq5_1,$Mq5_2)){
    foreach($n in (CensisciInclude $f)){
      $nudo = ($n -split '[\\/]')[-1]
      if($nudo -match '^ABTG_'){
        if($nudo -ne $INC){ throw ("INCLUDE NOSTRO NON PREVISTO: " + (Split-Path -Leaf $f) + " chiede '" + $n + "', che questa riga NON scarica. Aggiungerlo alla riga e ri-pinnare.") }
      }
      else{
        $gia = $false
        foreach($x in $altriInc){ if($x -ieq $n){ $gia = $true } }
        if(-not $gia){ [void]$altriInc.Add($n) }
      }
    }
  }
  foreach($n in (CensisciInclude $Mqh)){
    $nudo = ($n -split '[\\/]')[-1]
    if($nudo -match '^ABTG_' -and $nudo -ne $INC){ throw ("L'INCLUDE " + $INC + " ne chiede un altro NOSTRO ('" + $n + "') che questa riga non scarica: mi fermo prima di installare.") }
  }
  $testoMqh = ((LeggiTesto $Mqh) -join "`n")
  # ancorato sulla parentesi (classe 116-ter): un nome rinominato non passa.
  if($testoMqh -notmatch 'bool\s+ABTG_GuardiaIngresso\s*\('){
    throw ("l'include scaricato al pin non definisce ABTG_GuardiaIngresso(...): i due EA lo chiamano, non compilerebbero.")
  }
  [void]$GateTxt.Add("include: nostri = " + $INC + " (presente, definisce ABTG_GuardiaIngresso); di libreria = " + (@($altriInc) -join ", "))

  # -------------------------------------------------------------------
  #  2-bis. I DUE PRESET, APERTI E CONTATI
  # -------------------------------------------------------------------
  $coppie = @(
    @{ Nome=$SET1; File=$Set_1; Mq5=$Mq5_1; EA=$EA1; Magic=$MAGIC1; Simbolo=$SIMB1 },
    @{ Nome=$SET2; File=$Set_2; Mq5=$Mq5_2; EA=$EA2; Magic=$MAGIC2; Simbolo=$SIMB2 }
  )
  foreach($c in $coppie){
    # ASCII puro: un .set con caratteri strani e' un .set che non si sa
    # come venga letto, e qui non si tira a indovinare.
    $bset = [System.IO.File]::ReadAllBytes($c.File)
    $nonAscii = 0
    foreach($b in $bset){ if($b -gt 126){ $nonAscii++ } }
    if($nonAscii -gt 0){ throw ("IL PRESET " + $c.Nome + " HA " + $nonAscii + " BYTE NON-ASCII: non installo un file di parametri di cui non so come verra' letto.") }

    $s = LeggiSet $c.File
    if(@($s.Brutte).Count -gt 0){
      throw ("IL PRESET " + $c.Nome + " HA " + @($s.Brutte).Count + " RIGHE MALFORMATE (ne' vuote, ne' commenti ';', ne' chiave=valore): " + (@($s.Brutte) -join " | ") + ". MT5 le salterebbe IN SILENZIO e il preset si caricherebbe a meta'. NON installo.")
    }
    if(@($s.Doppie).Count -gt 0){
      throw ("IL PRESET " + $c.Nome + " HA CHIAVI DOPPIE (" + (@($s.Doppie) -join ", ") + "): vincerebbe l'ultima, e quale sia non lo decide nessuno. NON installo.")
    }
    $ins = InputDichiarati $c.Mq5
    if(@($ins).Count -eq 0){ throw ("non ho trovato NESSUN input dichiarato in " + $c.EA + ".mq5: il confronto col preset non sarebbe una verifica. NON installo.") }
    # (b) ogni chiave del .set e' un input vero
    $estranee = New-Object System.Collections.ArrayList
    foreach($k in $s.Ordine){
      $ok = $false
      foreach($i in $ins){ if($i -ceq $k){ $ok = $true } }
      if(-not $ok){ [void]$estranee.Add($k) }
    }
    if($estranee.Count -gt 0){
      throw ("IL PRESET " + $c.Nome + " HA " + $estranee.Count + " CHIAVI CHE NON SONO INPUT DI " + $c.EA + " (" + (@($estranee) -join ", ") + "): MT5 le ignora senza dire niente, e chi legge il file crede di aver impostato qualcosa. NON installo.")
    }
    # (c) ogni input dell'EA c'e' nel .set
    $mancanti = New-Object System.Collections.ArrayList
    foreach($i in $ins){
      if(-not $s.KV.ContainsKey($i)){
        $gia = $false
        foreach($x in $mancanti){ if($x -ceq $i){ $gia = $true } }
        if(-not $gia){ [void]$mancanti.Add($i) }
      }
    }
    if($mancanti.Count -gt 0){
      throw ("IL PRESET " + $c.Nome + " NON COPRE " + $mancanti.Count + " INPUT DI " + $c.EA + " (" + (@($mancanti) -join ", ") + "). Un input che il preset non nomina prende il DEFAULT COMPILATO in silenzio: e' la trappola del 2% chiusa il 02/09. Su un conto reale non si accetta. NON installo.")
    }
    # (d) il magic
    if(-not $s.KV.ContainsKey("InpMagic")){ throw ("IL PRESET " + $c.Nome + " NON HA InpMagic: senza magic la sedia non e' riconoscibile. NON installo.") }
    if(("" + $s.KV["InpMagic"]).Trim() -ne $c.Magic){
      throw ("MAGIC SBAGLIATO nel preset " + $c.Nome + ": c'e' '" + $s.KV["InpMagic"] + "', atteso '" + $c.Magic + "'. NON installo.")
    }
    # (e) il rischio: quello atteso, e comunque sotto il tetto
    if(-not $s.KV.ContainsKey("InpRiskPercent")){ throw ("IL PRESET " + $c.Nome + " NON HA InpRiskPercent. NON installo.") }
    $rv = 0.0
    if(-not [double]::TryParse(("" + $s.KV["InpRiskPercent"]).Trim(), [Globalization.NumberStyles]::Float, $INV, [ref]$rv)){
      throw ("InpRiskPercent del preset " + $c.Nome + " non e' un numero leggibile ('" + $s.KV["InpRiskPercent"] + "'). NON installo.")
    }
    if([math]::Abs($rv - $RISCHIO_ATTESO) -gt 0.0000001){
      throw ("RISCHIO SBAGLIATO nel preset " + $c.Nome + ": InpRiskPercent = " + $rv.ToString($INV) + ", atteso ESATTAMENTE " + $RISCHIO_ATTESO.ToString($INV) + " (taglia firmata per il conto reale). NON installo.")
    }
    $sopra = New-Object System.Collections.ArrayList
    foreach($k in $s.Ordine){
      if($k -match 'Risk'){
        $x = 0.0
        if([double]::TryParse(("" + $s.KV[$k]).Trim(), [Globalization.NumberStyles]::Float, $INV, [ref]$x)){
          if($x -gt $RISCHIO_TETTO){ [void]$sopra.Add($k + "=" + $s.KV[$k]) }
        }
      }
    }
    if($sopra.Count -gt 0){
      throw ("NEL PRESET " + $c.Nome + " C'E' UNA CHIAVE DI RISCHIO SOPRA IL TETTO " + $RISCHIO_TETTO.ToString($INV) + " (" + (@($sopra) -join ", ") + "): riga rossa A4. NON installo.")
    }
    $lato = "long+short"
    if($s.KV.ContainsKey("InpAllowLong") -and $s.KV.ContainsKey("InpAllowShort")){
      if(("" + $s.KV["InpAllowLong"]).Trim() -ieq "true" -and ("" + $s.KV["InpAllowShort"]).Trim() -ine "true"){ $lato = "SOLO LONG" }
      elseif(("" + $s.KV["InpAllowLong"]).Trim() -ine "true" -and ("" + $s.KV["InpAllowShort"]).Trim() -ieq "true"){ $lato = "SOLO SHORT" }
      elseif(("" + $s.KV["InpAllowLong"]).Trim() -ine "true" -and ("" + $s.KV["InpAllowShort"]).Trim() -ine "true"){ $lato = "NESSUN LATO ABILITATO (questa sedia non aprirebbe mai niente)" }
    }
    if($lato -like "NESSUN LATO*"){ [void]$Rilievi.Add("il preset " + $c.Nome + " ha long e short spenti tutti e due: la sedia non aprirebbe niente. Dichiarato.") }
    $mx = "n/d"
    if($s.KV.ContainsKey("InpMaxSpread")){ $mx = "" + $s.KV["InpMaxSpread"] }
    $gu = "n/d"
    if($s.KV.ContainsKey("InpUsaGuardian")){ $gu = "" + $s.KV["InpUsaGuardian"] }
    [void]$SetTxt.Add($c.Nome + "  ->  simbolo atteso " + $c.Simbolo + " | " + @($s.Ordine).Count + " chiavi = " + @($ins).Count + " input dell'EA (copertura TOTALE) | InpMagic=" + $s.KV["InpMagic"] + " | InpRiskPercent=" + $rv.ToString($INV) + " | lati: " + $lato + " | InpMaxSpread=" + $mx + " | InpUsaGuardian=" + $gu)
    Dico ("preset OK: " + $c.Nome + "  (magic " + $s.KV["InpMagic"] + ", rischio " + $rv.ToString($INV) + "%, " + @($s.Ordine).Count + " chiavi, copertura totale)") "Green"
  }
  [void]$GateTxt.Add("preset: TUTTI E DUE passano i sei cancelli (ASCII, righe ben formate, nessuna chiave estranea, copertura TOTALE degli input, magic esatto, rischio esatto e sotto il tetto)")

  # --- ASCII dei sorgenti (non blocca: e' un rilievo)
  foreach($f in @($Mq5_1,$Mq5_2,$Mqh)){
    $na = 0
    foreach($b in [System.IO.File]::ReadAllBytes($f)){ if($b -gt 126){ $na++ } }
    if($na -gt 0){ [void]$Rilievi.Add((Split-Path -Leaf $f) + " ha " + $na + " byte non-ASCII: non blocca la compilazione, ma va saputo.") }
  }

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
    # atteso -- anzi, SOPRATTUTTO allora.
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
    $hasLog = (Test-Path -LiteralPath (Join-Path $c.Percorso ("MQL5\Experts\" + $LOGGER + ".mq5")))
    [void]$righeC.Add("      " + $LOGGER + " gia' installato qui: " + $hasLog)
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
      [void]$Rilievi.Add("SCELTA ATTESTATA A MANO: il login " + $LoginAtteso + " non e' stato trovato nei log della cartella scelta. La riga si e' fidata della tua firma (-ConfermoConto), non di una misura. QUI SI INSTALLANO EA CHE APRONO ORDINI: prima di attaccarli, guarda con gli occhi il numero di conto in MT5.")
    }
    else{
      throw ("-CartellaDati '" + $CartellaDati + "' NON mostra il login " + $LoginAtteso + " nei log degli ultimi 180 giorni. Qui si installano EA che aprono ordini veri e non installo su una cartella che non so riconoscere. Se sei SICURO che sia quella (aprila in MT5 e guarda il numero di conto), rilancia LO STESSO blocco aggiungendo anche: -ConfermoConto " + $LoginAtteso)
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
  $BasiTxt = "bases\ della cartella scelta: " + $basiScelta

  $MqlDir = Join-Path $Scelta "MQL5"
  # CONFERMA INCROCIATA: il logger dello slippage e' stato installato
  # QUI ieri sera. Se non c'e', o siamo su un altro terminale o il
  # deploy di ieri non e' andato dove crediamo.
  $LogMq5 = Join-Path $MqlDir ("Experts\" + $LOGGER + ".mq5")
  $LogEx5 = Join-Path $MqlDir ("Experts\" + $LOGGER + ".ex5")
  if(Test-Path -LiteralPath $LogMq5){
    $LoggerQui = "SI, " + $LOGGER + " e' gia' in questa cartella (" + (Descrivi $LogMq5) + "): conferma incrociata che e' il terminale del reale su cui abbiamo gia' lavorato."
  }
  else{
    $LoggerQui = "NO: " + $LOGGER + " NON e' in questa cartella. Non blocca (il logger potrebbe stare altrove), ma e' un rilievo forte: rileggi il referto del deploy del logger e controlla che sia la stessa cartella dati."
    [void]$Rilievi.Add($LoggerQui)
  }

  $MeOrigin = ""
  if($Reale.Origin -ne ""){ try{ $MeOrigin = (Join-Path $Reale.Origin "metaeditor64.exe") }catch{ $MeOrigin = ""; [void]$Rilievi.Add("l'origin.txt della cartella scelta ('" + $Reale.Origin + "') non e' un percorso usabile da questa sessione: cerco metaeditor64.exe nella cartella dati.") } }
  if($MeOrigin -ne "" -and (Test-Path -LiteralPath $MeOrigin)){ $Inst = $Reale.Origin }
  elseif($Reale.HaMe){ $Inst = $Reale.Percorso }
  else{ throw ("metaeditor64.exe dell'installazione del conto reale NON trovato (origin.txt: '" + $Reale.Origin + "'): senza il SUO compilatore non installo niente.") }
  $Me = Join-Path $Inst "metaeditor64.exe"

  # gli include DI LIBRERIA devono gia' esistere nel terminale, se no la
  # compilazione fallisce per un motivo di AMBIENTE e non di codice.
  foreach($a in $altriInc){
    $p = Join-Path (Join-Path $MqlDir "Include") ($a -replace '/','\')
    if(-not (Test-Path -LiteralPath $p)){
      throw ("INCLUDE DI LIBRERIA NON TROVATO nel terminale del reale: '" + $a + "' (cercato in " + $p + "). La compilazione fallirebbe per AMBIENTE: non installo.")
    }
  }

  # I SETTE ARTEFATTI
  $Dest1Mq5 = Join-Path $MqlDir ("Experts\" + $EA1 + ".mq5")
  $Dest1Ex5 = Join-Path $MqlDir ("Experts\" + $EA1 + ".ex5")
  $Dest2Mq5 = Join-Path $MqlDir ("Experts\" + $EA2 + ".mq5")
  $Dest2Ex5 = Join-Path $MqlDir ("Experts\" + $EA2 + ".ex5")
  $DestMqh  = Join-Path $MqlDir ("Include\" + $INC)
  $DestSet1 = Join-Path $MqlDir ("Presets\" + $SET1)
  $DestSet2 = Join-Path $MqlDir ("Presets\" + $SET2)
  $Art = @(
    @{ N="Experts\" + $EA1 + ".mq5"; P=$Dest1Mq5; S=$Mq5_1 },
    @{ N="Experts\" + $EA1 + ".ex5"; P=$Dest1Ex5; S="" },
    @{ N="Experts\" + $EA2 + ".mq5"; P=$Dest2Mq5; S=$Mq5_2 },
    @{ N="Experts\" + $EA2 + ".ex5"; P=$Dest2Ex5; S="" },
    @{ N="Include\" + $INC;          P=$DestMqh;  S=$Mqh   },
    @{ N="Presets\" + $SET1;         P=$DestSet1; S=$Set_1 },
    @{ N="Presets\" + $SET2;         P=$DestSet2; S=$Set_2 }
  )
  $TuttiDest = @()
  foreach($a in $Art){ $TuttiDest = $TuttiDest + @($a.P) }

  Dico ("cartella dati scelta: " + $Scelta) "Yellow"
  Dico ("criterio ............ " + $Criterio) "Yellow"
  Dico ("installazione ....... " + $Inst) "Yellow"
  Dico ("logger gia' qui ..... " + $LoggerQui) "Yellow"

  # -------------------------------------------------------------------
  #  4. LE FOTO PRIMA
  # -------------------------------------------------------------------
  Titolo "4. FOTO PRIMA (i sette artefatti, il LOGGER, Presets file per file, parametri, cartelle dei conti demo)"
  foreach($a in $Art){ $FotoP[$a.N] = Foto $a.P; Dico ("REALE prima -- " + $a.N + ": " + (FotoTxt $FotoP[$a.N])) }
  $gia = New-Object System.Collections.ArrayList
  foreach($a in $Art){ if($FotoP[$a.N].Esiste){ [void]$gia.Add($a.N) } }
  if($gia.Count -gt 0){ $GiaLi = "SI, " + $gia.Count + " dei 7 file erano gia' in questo terminale (" + (@($gia) -join ", ") + "). Verranno sostituiti, col backup." }
  else{ $GiaLi = "NO: nessuno dei 7 file era in questo terminale (installazione NUOVA di tutte e due le sedie)" }

  # IL LOGGER: i suoi due file NON si toccano e devono restare identici.
  foreach($p in @($LogMq5,$LogEx5)){
    [void]$FotoLog.Add([pscustomobject]@{ Percorso=$p; Prima=(Foto $p); Dopo=$null })
  }
  # il suo REGISTRO invece e' VIVO: si fotografa per dire cosa c'e', ma
  # se cresce e' NORMALE (il logger scrive ogni 10 s a MT5 aperto).
  $InvFileP = Inventario (Join-Path $MqlDir "Files") ($LOGGER + "*")

  # PRESETS: qui ci scriviamo, quindi non basta "invariato". Si fa
  # l'inventario FILE PER FILE e si pretende che cambino SOLO i due .set
  # nostri.
  $InvPreP = Inventario (Join-Path $MqlDir "Presets") "*"
  Dico ("Presets prima: " + $InvPreP.Keys.Count + " file")

  # cartelle che NON devono cambiare: i grafici e la configurazione.
  # (E' la prova che questa riga non attacca niente a nessun grafico.)
  $DirParam = @(@{N="MQL5\Profiles\Charts"; P=(Join-Path $MqlDir "Profiles\Charts")},
                @{N="Profiles\Charts (radice)"; P=(Join-Path $Scelta "Profiles\Charts")},
                @{N="config"; P=(Join-Path $Scelta "config")})
  foreach($d in $DirParam){ $FotoDirP[$d.N] = FotoDir $d.P; Dico ("parametri prima -- " + $d.N + ": " + $FotoDirP[$d.N]) }

  foreach($c in $DemoCand){
    foreach($a in $Art){
      $p = Join-Path $c.Percorso ("MQL5\" + $a.N)
      [void]$FotoDemo.Add([pscustomobject]@{ Percorso=$p; Prima=(Foto $p); Dopo=$null })
    }
  }
  $FotoPrese = $true

  if($Modo -eq "CONTROLLO"){
    $Comp1 = "NON TENTATA (modo CONTROLLO: non si scrive e non si compila)"
    $Comp2 = "NON TENTATA (modo CONTROLLO: non si scrive e non si compila)"
    $InstallTxt = "NON AVVENUTA (modo CONTROLLO). In CORSA scriverebbe questi 7: " + (@($TuttiDest) -join " | ")
    $BackupTxt  = "NON FATTO (modo CONTROLLO)"
  }
  else{
    # -----------------------------------------------------------------
    #  5. BACKUP + SENTINELLA, POI LA SCRITTURA
    # -----------------------------------------------------------------
    Titolo "5. BACKUP DEI SETTE, SENTINELLA E COPIA NEL TERMINALE"
    $BackupDir = Join-Path (Join-Path $Dsk ("backup_contoreale_" + $Avvio.ToString("yyyyMMdd",$INV))) $Avvio.ToString("HHmmss",$INV)
    New-Item -ItemType Directory -Force -Path $BackupDir | Out-Null
    $bk = New-Object System.Collections.ArrayList
    foreach($a in $Art){
      if(Test-Path -LiteralPath $a.P){
        Copy-Item -LiteralPath $a.P -Destination (Join-Path $BackupDir (Split-Path -Leaf $a.P)) -Force
        [void]$bk.Add((Split-Path -Leaf $a.P) + ": " + (Descrivi $a.P))
      }
      else{ [void]$bk.Add((Split-Path -Leaf $a.P) + ": non c'era (il ripristino lo togliera')") }
    }
    Set-Content -LiteralPath (Join-Path $BackupDir "BACKUP_ORIGINE.txt") -Value (@("backup del " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV), "cartella dati: " + $Scelta, "conto atteso: " + $LoginAtteso) + @($bk)) -Encoding ASCII
    $BackupTxt = "FATTO in " + $BackupDir + " -- " + (@($bk) -join " | ")
    # SENTINELLA scritta PRIMA della prima scrittura nel terminale.
    # Ultima riga = la cartella di backup.
    Set-Content -LiteralPath $Sentinella -Value (@($TuttiDest) + @($BackupDir)) -Encoding ASCII

    New-Item -ItemType Directory -Force -Path (Join-Path $MqlDir "Experts"),(Join-Path $MqlDir "Include"),(Join-Path $MqlDir "Presets") | Out-Null
    # PRIMA i sorgenti e l'include. I .set entrano SOLO IN FONDO, e solo
    # se tutte e due le compilazioni sono andate: un preset da caricare
    # senza l'EA compilato e' un invito a sbagliare.
    foreach($a in $Art){
      if($a.S -eq ""){ continue }
      if($a.N -like "Presets\*"){ continue }
      Copy-Item -LiteralPath $a.S -Destination $a.P -Force
      $ScrittoNelTerminale = $true
      if((HashPieno $a.S) -ne (HashPieno $a.P)){ throw ("COPIA NON VERIFICATA: " + $a.N + " nel terminale non ha lo stesso sha256 di quello scaricato al pin.") }
      Dico ("copiato " + $a.P) "Green"
    }

    # gli .ex5 vecchi si CANCELLANO prima: un binario vecchio sopravvis-
    # suto si spaccia per nuovo (checklist 54).
    foreach($e in @($Dest1Ex5,$Dest2Ex5)){
      if(Test-Path -LiteralPath $e){
        Remove-Item -LiteralPath $e -Force -ErrorAction SilentlyContinue
        if(Test-Path -LiteralPath $e){ throw ("EX5 VECCHIO NON CANCELLABILE (" + $e + "): qualcuno lo tiene aperto -- l'EA e' gia' su un grafico di questo terminale? NON compilo: un ex5 vecchio che sopravvive si spaccia per nuovo.") }
      }
    }

    # -----------------------------------------------------------------
    #  6. LE DUE COMPILAZIONI -- TUTTO O NIENTE
    # -----------------------------------------------------------------
    Titolo "6. COMPILAZIONE (due, separate, con due log distinti)"
    $err1 = -1; $war1 = -1; $err2 = -1; $war2 = -1
    $ok1 = $false; $ok2 = $false

    $e1 = Compila $Me @(("/compile:" + $Dest1Mq5), ("/inc:" + $MqlDir), ("/log:" + $Log1Path)) $Dest1Ex5 $Log1Path $TimeoutSec $EA1
    $Log1Righe = @($e1.Log)
    if($null -ne $e1.Rc){ $Rc1 = "" + $e1.Rc + "   (1 e' NORMALE su questo VPS: e' il numero di file compilati, misurato il 03/09)" }
    $res1 = @($Log1Righe | Where-Object { $_ -match 'Result:' })
    if(@($res1).Count -gt 0){ $Result1 = ($res1[0]).Trim() }
    $mx1 = [regex]::Match($Result1, '(\d+)\s+error');   if($mx1.Success){ $err1 = [int]::Parse($mx1.Groups[1].Value,$INV) }
    $mw1 = [regex]::Match($Result1, '(\d+)\s+warning'); if($mw1.Success){ $war1 = [int]::Parse($mw1.Groups[1].Value,$INV) }
    if($e1.Ex5 -and $err1 -eq 0){
      $ok1 = $true
      $Comp1 = "OK (" + [math]::Round((Get-Item -LiteralPath $Dest1Ex5).Length/1024,1) + " KB, " + (Get-Item -LiteralPath $Dest1Ex5).Length + " byte, " + (Get-Item -LiteralPath $Dest1Ex5).LastWriteTime.ToString("HH:mm:ss",$INV) + "), " + $Result1
    }
    elseif($e1.Muto){ $Comp1 = "FALLITA -- METAEDITOR MUTO (lanciato, tornato senza log ne' .ex5). Tipico: editor aperto, percorso, permessi." }
    elseif($e1.Ex5 -and $err1 -lt 0){ $Comp1 = "FALLITA -- .ex5 FRESCO MA RIGA 'Result:' NON LETTA nel log: non posso dire quanti errori ci sono, e su un conto reale un 'boh' vale come un no. Ripristino." }
    else{ $Comp1 = "FALLITA (" + $Result1 + ")" }
    Dico ($EA1 + ": " + $Comp1) "Yellow"

    if($ok1){
      $e2 = Compila $Me @(("/compile:" + $Dest2Mq5), ("/inc:" + $MqlDir), ("/log:" + $Log2Path)) $Dest2Ex5 $Log2Path $TimeoutSec $EA2
      $Log2Righe = @($e2.Log)
      if($null -ne $e2.Rc){ $Rc2 = "" + $e2.Rc + "   (1 e' NORMALE su questo VPS)" }
      $res2 = @($Log2Righe | Where-Object { $_ -match 'Result:' })
      if(@($res2).Count -gt 0){ $Result2 = ($res2[0]).Trim() }
      $mx2 = [regex]::Match($Result2, '(\d+)\s+error');   if($mx2.Success){ $err2 = [int]::Parse($mx2.Groups[1].Value,$INV) }
      $mw2 = [regex]::Match($Result2, '(\d+)\s+warning'); if($mw2.Success){ $war2 = [int]::Parse($mw2.Groups[1].Value,$INV) }
      if($e2.Ex5 -and $err2 -eq 0){
        $ok2 = $true
        $Comp2 = "OK (" + [math]::Round((Get-Item -LiteralPath $Dest2Ex5).Length/1024,1) + " KB, " + (Get-Item -LiteralPath $Dest2Ex5).Length + " byte, " + (Get-Item -LiteralPath $Dest2Ex5).LastWriteTime.ToString("HH:mm:ss",$INV) + "), " + $Result2
      }
      elseif($e2.Muto){ $Comp2 = "FALLITA -- METAEDITOR MUTO (lanciato, tornato senza log ne' .ex5)." }
      elseif($e2.Ex5 -and $err2 -lt 0){ $Comp2 = "FALLITA -- .ex5 FRESCO MA RIGA 'Result:' NON LETTA nel log: non posso dire quanti errori ci sono. Ripristino." }
      else{ $Comp2 = "FALLITA (" + $Result2 + ")" }
      Dico ($EA2 + ": " + $Comp2) "Yellow"
    }
    else{
      $Comp2 = "NON TENTATA: la prima compilazione (" + $EA1 + ") non e' andata, e questo deploy e' TUTTO O NIENTE."
    }

    if($ok1 -and $ok2){
      # I PRESET ENTRANO SOLO ADESSO
      foreach($a in $Art){
        if($a.N -notlike "Presets\*"){ continue }
        Copy-Item -LiteralPath $a.S -Destination $a.P -Force
        if((HashPieno $a.S) -ne (HashPieno $a.P)){ throw ("COPIA NON VERIFICATA: " + $a.N + " nel terminale non ha lo stesso sha256 di quello scaricato al pin.") }
        Dico ("copiato " + $a.P) "Green"
      }
      $SetCopiati = $true
      $InstallTxt = "AVVENUTA: 7 file su 7 (" + (@($TuttiDest) -join " | ") + ")"
      Remove-Item -LiteralPath $Sentinella -Force -ErrorAction SilentlyContinue
      if($war1 -gt 0 -or $war2 -gt 0){
        [void]$Problemi.Add("COMPILAZIONE CON WARNING (" + $EA1 + ": " + $war1 + ", " + $EA2 + ": " + $war2 + "). La regola di casa pretende 0 errors E 0 warnings: i file sono installati, ma NON ATTACCARE NIENTE prima di avermi mandato lo zip coi due log.")
      }
    }
    else{
      $Ripristino = (RipristinaDaBackup $BackupDir $TuttiDest) -join "; "
      $InstallTxt = "TENTATA E RIPRISTINATA (tutto o niente: una delle due compilazioni non e' andata, quindi TUTTI E SETTE i file sono tornati com'erano)"
      [void]$Problemi.Add("compilazione non riuscita -- " + $EA1 + ": " + $Comp1 + " || " + $EA2 + ": " + $Comp2)
      Remove-Item -LiteralPath $Sentinella -Force -ErrorAction SilentlyContinue
    }
  }
}
catch{
  $Fatale = $_.Exception.Message
  Write-Host ("!!! FERMATO: " + $Fatale) -ForegroundColor Red
  if($ScrittoNelTerminale -and $BackupDir -ne "" -and (Test-Path -LiteralPath $BackupDir)){
    try{
      $dest = @()
      foreach($a in $Art){ $dest = $dest + @($a.P) }
      $Ripristino = ((RipristinaDaBackup $BackupDir $dest) -join "; ") + "  (dopo un'eccezione)"
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
  if($FotoPrese -and @($Art).Count -eq 7){
    foreach($a in $Art){
      $dopo = Foto $a.P
      [void]$FotoDopo.Add("REALE " + $a.N + "   prima [" + (FotoTxt $FotoP[$a.N]) + "]   dopo [" + (FotoTxt $dopo) + "]   -> " + (Confronta $FotoP[$a.N] $dopo))
    }
    # PARAMETRI: grafici e config. Devono essere INVARIATI, ed e' LA
    # prova che questa riga non ha attaccato niente a nessun grafico.
    $cambi = New-Object System.Collections.ArrayList
    foreach($d in $DirParam){
      $ora = FotoDir $d.P
      if($ora -ne $FotoDirP[$d.N]){ [void]$cambi.Add($d.N + ": prima [" + $FotoDirP[$d.N] + "] dopo [" + $ora + "]") }
    }
    if($cambi.Count -eq 0){ $ParamTxt = "INVARIATI su " + @($DirParam).Count + " cartelle guardate (Profiles\Charts e config: stesso numero di file, stessi byte, stessa ultima scrittura). E' la prova che nessun EA e' stato attaccato a nessun grafico da questa riga." }
    else{
      $ParamTxt = "ATTENZIONE: " + $cambi.Count + " cartelle di grafici/configurazione risultano cambiate -- " + (@($cambi) -join " || ") + ". Se MT5 e' aperto puo' averle riscritte DA SOLO (e' il suo mestiere): questa riga non ha nessun percorso di scrittura verso quelle cartelle. Va comunque letto."
      [void]$Rilievi.Add($ParamTxt)
    }
    # PRESETS: qui ci abbiamo scritto, e si dimostra CHE COSA.
    $invPreD = Inventario (Join-Path $MqlDir "Presets") "*"
    $attesi = @()
    if($SetCopiati){ $attesi = @($SET1,$SET2) }
    $cmp = ConfrontaInventario $InvPreP $invPreD $attesi
    if(@($cmp.Inattesi).Count -gt 0){
      $PresetsTxt = "ATTENZIONE: nella cartella Presets sono cambiati file che questa riga NON doveva toccare -- " + (@($cmp.Inattesi) -join " | ")
      [void]$Problemi.Add($PresetsTxt)
    }
    elseif($SetCopiati){
      $PresetsTxt = "cambiati SOLO i due .set nostri (aggiunti: " + (@($cmp.Agg) -join ", ") + " | sovrascritti: " + (@($cmp.Cam) -join ", ") + "); gli altri " + $InvPreP.Keys.Count + " file gia' presenti sono INVARIATI uno per uno"
    }
    else{
      $PresetsTxt = "NESSUN .set scritto in questo giro; i " + $InvPreP.Keys.Count + " file gia' presenti in Presets sono INVARIATI uno per uno"
    }
  }
  else{
    $ParamTxt = "NON MISURATI (il giro si e' fermato prima di scattare le foto: un confronto sul vuoto direbbe INVARIATI senza aver guardato niente)"
    $PresetsTxt = "NON MISURATO (il giro si e' fermato prima delle foto)"
    if($FotoDopo.Count -eq 0){ [void]$FotoDopo.Add("REALE: nessuna foto scattata (il giro si e' fermato prima del punto 4)") }
  }

  # IL LOGGER DELLO SLIPPAGE: i suoi due file devono essere INVARIATI.
  $vereL = 0; $cambiateL = 0
  foreach($f in $FotoLog){
    $f.Dopo = Foto $f.Percorso
    if($f.Prima.Esiste -or $f.Dopo.Esiste){ $vereL++ }
    if((Confronta $f.Prima $f.Dopo) -eq "CAMBIATO"){ $cambiateL++ }
  }
  $regTxt = ""
  if($MqlDir -ne ""){
    $invFileD = Inventario (Join-Path $MqlDir "Files") ($LOGGER + "*")
    $cambiReg = 0
    foreach($k in $invFileD.Keys){ if((-not $InvFileP.ContainsKey($k)) -or $InvFileP[$k] -ne $invFileD[$k]){ $cambiReg++ } }
    $regTxt = "  ||  il suo REGISTRO in MQL5\Files: " + $InvFileP.Keys.Count + " file prima, " + $invFileD.Keys.Count + " dopo, " + $cambiReg + " nuovi o cresciuti -- e SE E' CRESCIUTO E' NORMALE E GIUSTO: il logger scrive ogni 10 secondi finche' MT5 e' aperto. Questa riga non ci ha scritto niente (non ha nessun percorso verso quella cartella)."
  }
  if($cambiateL -gt 0){
    $LoggerTxt = "ATTENZIONE: " + $cambiateL + " file di " + $LOGGER + " RISULTANO CAMBIATI. Questa riga non doveva toccarlo." + $regTxt
    [void]$Problemi.Add($LoggerTxt)
  }
  elseif($vereL -gt 0){ $LoggerTxt = "INVARIATO su " + $vereL + " foto di file REALMENTE PRESENTI (.mq5/.ex5 di " + $LOGGER + " intatti)" + $regTxt }
  else{ $LoggerTxt = "NON MISURATO: " + $LOGGER + " non e' in questa cartella dati, quindi non c'era niente da fotografare (classe 117: non si regala un verde)." + $regTxt }

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
  # (classe 132).
  $ReferTxt = Join-Path $Work ("REFERTO_DEPLOY_CONTOREALE_" + $Modo + ".txt")
  $r = New-Object System.Collections.ArrayList
  [void]$r.Add("=====================================================================")
  [void]$r.Add("  DEPLOY SUL CONTO REALE -- " + $EA1 + " (magic " + $MAGIC1 + ") e " + $EA2 + " (magic " + $MAGIC2 + ")")
  [void]$r.Add("  QUESTI DUE EA APRONO ORDINI VERI. Questa riga li INSTALLA e li")
  [void]$r.Add("  COMPILA: NON li attacca a nessun grafico e NON tocca l'AutoTrading.")
  [void]$r.Add("=====================================================================")
  $esitoGiro = "COMPLETATO (nessun gate ha fermato il giro)"
  if($Fatale -ne ""){ $esitoGiro = "FERMATO da un gate: " + $Fatale }
  if($Fatale -eq "" -and $Problemi.Count -gt 0){ $esitoGiro = "ARRIVATO IN FONDO MA CON " + $Problemi.Count + " PROBLEMI: leggi la riga INSTALLAZIONE e l'elenco PROBLEMI PRIMA di attaccare qualunque cosa" }
  [void]$r.Add("ESITO DEL GIRO: " + $esitoGiro)
  [void]$r.Add("data: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   (E' L'ORA DI AVVIO DI QUESTO GIRO, non l'ora attuale)")
  [void]$r.Add("modo: " + $Modo + "     macchina: " + $env:COMPUTERNAME + "     sessione: " + $env:USERNAME)
  [void]$r.Add("pin : " + $Pin)
  [void]$r.Add("")
  [void]$r.Add("CONTO ATTESO (-LoginAtteso): " + $LoginAtteso)
  [void]$r.Add("CONTI VIETATI PER SEMPRE ..: " + ($VIETATI_CONTI -join ", ") + "   (i due DEMO: li' queste due sedie GIA' girano)")
  [void]$r.Add("guardia sul conto .........: " + $ContoTxt)
  [void]$r.Add($BasiTxt)
  [void]$r.Add("cartella dati scelta ......: " + $Scelta)
  [void]$r.Add("criterio di scelta ........: " + $Criterio)
  [void]$r.Add("installazione (compilatore): " + $Inst)
  [void]$r.Add("conferma incrociata logger : " + $LoggerQui)
  [void]$r.Add("")
  [void]$r.Add("SORGENTI AL PIN:")
  foreach($x in $SorgTxt){ [void]$r.Add("   " + $x) }
  [void]$r.Add("GATE SUPERATI:")
  foreach($x in $GateTxt){ [void]$r.Add("   " + $x) }
  [void]$r.Add("I DUE PRESET, APERTI E CONTATI:")
  if($SetTxt.Count -eq 0){ [void]$r.Add("   NON LETTI (il giro si e' fermato prima)") }
  foreach($x in $SetTxt){ [void]$r.Add("   " + $x) }
  [void]$r.Add("rischio preteso: InpRiskPercent = " + $RISCHIO_ATTESO.ToString($INV) + " ESATTO, e nessuna chiave *Risk* sopra il tetto " + $RISCHIO_TETTO.ToString($INV))
  [void]$r.Add("erano gia' installati ....: " + $GiaLi)
  [void]$r.Add("")
  [void]$r.Add("backup ...................: " + $BackupTxt)
  [void]$r.Add("compilazione " + $EA1 + ": " + $Comp1)
  [void]$r.Add("   riga Result del log ...: " + $Result1)
  [void]$r.Add("   codice di uscita ......: " + $Rc1)
  [void]$r.Add("compilazione " + $EA2 + ": " + $Comp2)
  [void]$r.Add("   riga Result del log ...: " + $Result2)
  [void]$r.Add("   codice di uscita ......: " + $Rc2)
  [void]$r.Add("INSTALLAZIONE ............: " + $InstallTxt)
  [void]$r.Add("ripristino ...............: " + $Ripristino)
  [void]$r.Add("")
  [void]$r.Add("IL LOGGER DELLO SLIPPAGE (che NON si tocca): " + $LoggerTxt)
  foreach($f in $FotoLog){ [void]$r.Add("   LOGGER " + $f.Percorso + "   prima [" + (FotoTxt $f.Prima) + "]   dopo [" + (FotoTxt $f.Dopo) + "]   -> " + (Confronta $f.Prima $f.Dopo)) }
  [void]$r.Add("I TERMINALI DEI CONTI DEMO: " + $DemoTxt)
  foreach($f in $FotoDemo){ [void]$r.Add("   DEMO " + $f.Percorso + "   prima [" + (FotoTxt $f.Prima) + "]   dopo [" + (FotoTxt $f.Dopo) + "]   -> " + (Confronta $f.Prima $f.Dopo)) }
  [void]$r.Add("GRAFICI E CONFIGURAZIONE .: " + $ParamTxt)
  [void]$r.Add("CARTELLA Presets .........: " + $PresetsTxt)
  [void]$r.Add("")
  foreach($x in $FotoDopo){ [void]$r.Add($x) }
  [void]$r.Add("")
  [void]$r.Add("COSA SUCCEDE DOPO -- LO FA CLAUDIO A MANO, NON QUESTA RIGA:")
  [void]$r.Add("  QUESTA RIGA NON HA ATTACCATO NESSUN EA A NESSUN GRAFICO E NON HA")
  [void]$r.Add("  TOCCATO L'AUTOTRADING. Finche' non lo fai tu, nessuno dei due EA")
  [void]$r.Add("  puo' mandare un ordine.")
  [void]$r.Add("  1. Navigatore > Expert Advisors > tasto destro > Aggiorna: devono")
  [void]$r.Add("     comparire " + $EA1 + " e " + $EA2 + ".")
  [void]$r.Add("  2. File > Nuovo grafico > " + $SIMB1 + ", M5. Grafico NUOVO: un grafico")
  [void]$r.Add("     MT5 tiene UN SOLO EA, e trascinarcene un altro sostituisce quello")
  [void]$r.Add("     che c'era (li' c'e' il logger: non toccarlo).")
  [void]$r.Add("  3. Trascina " + $EA1 + ", scheda Dati in Ingresso > Carica... >")
  [void]$r.Add("     " + $SET1)
  [void]$r.Add("     e PRIMA DI PREMERE OK guarda a schermo: InpMagic = " + $MAGIC1)
  [void]$r.Add("     e InpRiskPercent = " + $RISCHIO_ATTESO.ToString($INV) + ". Screenshot.")
  [void]$r.Add("  4. Stessa cosa su un secondo grafico NUOVO " + $SIMB2 + " M5 con")
  [void]$r.Add("     " + $EA2 + " e " + $SET2)
  [void]$r.Add("     (InpMagic = " + $MAGIC2 + ", InpRiskPercent = " + $RISCHIO_ATTESO.ToString($INV) + ").")
  [void]$r.Add("  5. AutoTrading ACCESO e faccina SORRIDENTE su tutti e due i grafici.")
  [void]$r.Add("  6. Scheda ESPERTI (non Giornale): '" + $AVVIO1 + "...' e")
  [void]$r.Add("     '" + $AVVIO2 + "...', piu' la riga")
  [void]$r.Add("     'ORB AUTOTEST: " + $ORB_BLOCCHI + " blocchi su " + $ORB_BLOCCHI + " passati, " + $ORB_CASI + " casi dichiarati, 0 falliti'.")
  [void]$r.Add("     Nella riga CONFIG IN USO del DAX deve comparire rischio=" + $RISCHIO_ATTESO.ToString($INV) + "%.")
  [void]$r.Add("  7. PROMEMORIA DEI SOLDI: con 7.500 EUR e 0,65% il rischio per trade")
  [void]$r.Add("     e' circa 49 EUR. Due sedie insieme = circa 1,3% (circa 98 EUR).")
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
  if(Test-Path -LiteralPath $Log1Path){
    [void]$daZip.Add($Log1Path)
    $l1 = Join-Path $Work "COMPILAZIONE_DAX_leggibile.txt"
    Set-Content -LiteralPath $l1 -Value @($Log1Righe) -Encoding ASCII
    [void]$daZip.Add($l1)
  }
  if(Test-Path -LiteralPath $Log2Path){
    [void]$daZip.Add($Log2Path)
    $l2 = Join-Path $Work "COMPILAZIONE_ORB_leggibile.txt"
    Set-Content -LiteralPath $l2 -Value @($Log2Righe) -Encoding ASCII
    [void]$daZip.Add($l2)
  }
  $zip = Join-Path $Dsk ("DEPLOY_CONTOREALE_" + $Modo + "_" + $Stamp + ".zip")
  Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
  Compress-Archive -LiteralPath @($daZip) -DestinationPath $zip -Force
  Write-Host ""
  Write-Host ("REFERTO: " + $ReferTxt) -ForegroundColor Cyan
  Write-Host ("ZIP DA MANDARE IN CHAT: " + $zip) -ForegroundColor Cyan
  Write-Host ("PROBLEMI: " + $Problemi.Count + "   RILIEVI: " + $Rilievi.Count)
  Write-Host "RICORDA: nessun EA e' stato attaccato a nessun grafico. Quello lo fai TU, a mano, con gli screenshot." -ForegroundColor Yellow
}
catch{
  Write-Host ("RACCOLTA IN DIFFICOLTA': " + $_.Exception.Message) -ForegroundColor Red
  Write-Host "Manda in chat quello che vedi qui sopra: va bene uguale." -ForegroundColor Yellow
}

if($Fatale -ne "" -or $Problemi.Count -gt 0){ exit 1 }
exit 0
