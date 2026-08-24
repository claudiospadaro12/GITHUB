# =====================================================================
#  MARCATORE_RIGA_R104_v1
#  RIGA_R104_MFE_MAXMIN_DAX.ps1  --  R104: QUANTO SPESSO IL PROFITTO
#  FLOTTANTE VIENE RESTITUITO PRIMA DI 1R, sulla sedia viva
#  ABTG_MaxMinNotte_DAX_Short_Ottimizzato (D30EUR M15).
# ---------------------------------------------------------------------
#  CRITERI: backtest_pipeline\risultati_archivio\R104_CRITERI_MFE_MAXMIN_DAX.md
#  AUTORIZZAZIONE: Claudio in chat, 24/08/2026 -- "Si, misuriamo quanto
#  succede". Essendo una misura a rischio bassissimo (una sedia sola,
#  nessun cambio in forward, nessuna promozione possibile) i criteri
#  dicono che non serve altra firma.
#
#  LA DOMANDA, ed e' di Claudio davanti al trade #3221475 (D30EUR short,
#  +200 EUR flottanti visti, chiuso a +15,10 EUR):
#    su quante operazioni il prezzo raggiunge un profitto flottante
#    importante e POI torna indietro SENZA mai toccare il 1o target
#    (1R)?  E quanto, in media, viene restituito?
#
#  COSA FA, in ordine, e DA SOLA:
#    0. si rifiuta di partire se MT5 O MetaEditor sono aperti
#    1. trova il terminale BCM (per NOME, mai il primo che capita) e la
#       sua cartella dati (via origin.txt)
#    2. scarica AL PIN: il sorgente di misura, il file prova, l'include
#       ABTG_PausaGuardian.mqh -- con i gate di versione e di contenuto
#    3. compila il .mq5 di misura (invocazione DIRETTA di
#       metaeditor64.exe, verdetto sul LastWriteTime del .ex5)
#    4. scrive UN solo .ini di passata SINGOLA (Optimization=0,
#       Model=4 tick reali) e lo verifica riga per riga
#    5. cancella gli artefatti VECCHI dalla cartella COMUNE, poi lancia
#       la passata e ASPETTA CHE IL TERMINALE ESCA DA SOLO
#    6. raccoglie ABTG_MFE_MaxMinDAX.csv, lo conta, lo istogramma e
#       risponde alla domanda -- oppure scrive NON MISURABILE
#    7. raccolta SEMPRE: cartella sul Desktop + zip + REFERTO_R104.txt
#
#  QUELLO CHE NON FA, dichiarato:
#    - NON tocca il forward, NON tocca nessuna sedia viva, NON tocca il
#      sorgente vivo. Gira sulla COPIA DI MISURA
#      ABTG_MaxMinNotte_DAX_Short_Ottimizzato_MFE.mq5, che e' un file
#      diverso e produce un .ex5 diverso: quello vivo non viene ne'
#      letto ne' riscritto ne' ricompilato.
#    - NON promuove e NON boccia niente. Il risultato e' INFORMAZIONE su
#      un meccanismo gia' in campo, non un verdetto (criteri par. 5).
#    - NON ottimizza NIENTE: una cella sola, i parametri vivi esatti,
#      zero assi spazzolati. Il driver si RIFIUTA di girare se nel file
#      prova compare anche un solo asse con flag Y.
#    - NON scarica storico e NON svuota bases\<server>\ticks: i tick
#      reali di D30EUR dal 2024.09.26 sono gia' agli atti (sonda 17/08,
#      verdetto COMPLETO; i tick partono dal 2024.07.05).
#    - NON misura lo spread e non inventa nessun numero non letto in un
#      artefatto.
#
#  PERCHE' NON C'E' NESSUN TIMEOUT SULLA PASSATA (checklist 19).
#  L'.ini ha ShutdownTerminal=1: a test finito il terminale si chiude da
#  solo, e la riga aspetta con WaitForExit -- lo stesso meccanismo di
#  R100/R102. Un timeout che ammazza MT5 a meta' lascerebbe sul disco un
#  CSV TRONCATO che ha tutta l'aria di un risultato: e' esattamente il
#  difetto pagato il 18/08 con -TimeoutMin. La prova che la corsa e'
#  finita davvero non e' il tempo: e' il processo uscito PIU' gli
#  artefatti freschi (report .htm e CSV scritti DOPO l'avvio).
#
#  IL CONTROLLO D'IGIENE DI QUESTO ROUND (e non e' quello solito).
#  Di norma si girano DUE passate gemelle su due magic e si pretende che
#  escano identiche. Qui NON si puo': le due passate scriverebbero SULLO
#  STESSO file comune ABTG_MFE_MaxMinDAX.csv e la seconda cancellerebbe
#  la prima. Al suo posto c'e' un controllo altrettanto duro e su due
#  strumenti indipendenti: il numero di righe del CSV MFE (contate dal
#  contatore tick-su-tick) deve coincidere col numero di POSIZIONI
#  CHIUSE contate in abtg_trades_*.csv, che lo stesso EA scrive da
#  OnTester leggendo lo STORICO DEI DEAL. Due strade diverse sullo
#  stesso fatto: se non tornano, il file non si legge.
#
#  LA RIGA CHE SI INCOLLA (blocco INTERO, un comando solo - checklist 21).
#  <PIN> = il commit che contiene QUESTO file: e' l'hash dato in chat.
#
#  & { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
#      if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
#      $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_R104.ps1"; Remove-Item $p -EA SilentlyContinue;
#      irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R104_MFE_MAXMIN_DAX.ps1" -OutFile $p;
#      if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R104_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
#      $global:LASTEXITCODE=0; & $p -Pin $pin; if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - leggi il REFERTO' -ForegroundColor Yellow } }
#
#  GIRO A VUOTO (pochi minuti, nessuna passata): la stessa riga con
#  -SoloControllo in coda. Scrive e verifica LO STESSO .ini che gira
#  nella corsa vera: non c'e' un secondo artefatto (checklist 33).
#  >>> E NON MISURA NESSUN NUMERO: senza tester non esiste nessun n,
#      nessun istogramma, nessuna percentuale. Sta scritto anche nel suo
#      referto, perche' non lo si scambi per il round (checklist 57).
# =====================================================================
param(
  # -Pin NON ha default: un default silenzioso ("lavoro") farebbe girare
  #  la punta del branch spacciandola per un commit congelato.
  [string]$Pin           = "",
  [switch]$SoloControllo,
  # la fine della finestra sta QUI e non nel file prova: e' la
  #  convenzione di casa (il file prova porta solo @DAQUANDO).
  [string]$Fino          = "2026.08.24",
  [switch]$TieniArtefatti   # non cancella i CSV comuni prima di partire.
                            #  SOLO per diagnosi: con questo switch il
                            #  referto NON puo' garantire che i file
                            #  siano di adesso, e lo scrive.
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

$Avvio  = Get-Date
$Stamp  = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
$Dsk    = Join-Path $env:USERPROFILE "Desktop"
$Work   = Join-Path $env:USERPROFILE "abtg_r104"
$Prove  = Join-Path $Work "prove"
$Logs   = Join-Path $Work "log_r104"
$SrcDir = Join-Path $Work "src_motori"
$Sosta  = Join-Path $Work "sosta"
$RawPin = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

# --- LA CELLA, LETTA NEGLI ARTEFATTI, NON A MEMORIA ------------------
$Ea         = "ABTG_MaxMinNotte_DAX_Short_Ottimizzato_MFE"
$EaVivo     = "ABTG_MaxMinNotte_DAX_Short_Ottimizzato"
$NomeProva  = "R104_MaxMinDAX_MFE.txt"
$Simbolo    = "D30EUR"
$Periodo    = "M15"
$DaQuando   = "2024.09.26"
$Modello    = 4          # 4 = TICK REALI. Su D30EUR ci sono dal 2024.07.05.
$Deposito   = 100000     # taglia prop, la stessa di R46/R54/R101
$SpreadIni  = 0          # 0 = spread CORRENTE, ma SCRITTO nell'ini invece
                         #  che lasciato allo stato nascosto del terminale.
                         #  NON e' uno stress di spread e NON e' una misura.
$MagicMis   = 750010     # blocco 750xxx, VERIFICATO libero il 24/08/2026
$RigheVive  = 55         # 52 parametri + 3 direttive  (MISURATE sul file)
$ParAttesi  = 52         # gli input del sorgente, contati sul sorgente
$Rischio    = "1.0"
$Commento   = "MAXMIN DAX SHORT"
$CsvMfe     = "ABTG_MFE_MaxMinDAX.csv"
$MarkSrc    = "MARCATORE_MFE_R104_v1"
$SogliaG1   = 30         # G1: sotto 30 operazioni si scrive NON MISURABILE

# --- I MAGIC VIETATI: il magic VIVO di questa sedia e la sua gemella di
#     file prova, piu' i vivi che stanno sullo stesso simbolo o vicino.
#     Un magic vivo dentro un .ini non cambia il comportamento dell'EA,
#     ma il tester non deve poter incrociare i deal del forward.
$MagicVietati = @(770411,770412,770101,770202,770611,770901,771531,971501)

# =====================================================================
#  TUTTO CIO' CHE LA RACCOLTA USA NASCE QUI, PRIMA DEL try, FUNZIONI
#  COMPRESE (checklist 41-bis e 48: in PowerShell una `function` non e'
#  dichiarativa, e' un'istruzione -- se il flusso non ci passa sopra, il
#  nome non esiste e la raccolta esplode proprio nella corsa fermata da
#  un gate).
# =====================================================================
$Problemi = New-Object System.Collections.ArrayList
$Note     = New-Object System.Collections.ArrayList
$Fatale   = ""
$Modo     = "CORSA"
if($SoloControllo){ $Modo = "CONTROLLO" }

$Ris = [pscustomobject]@{
  Eseguita      = $false
  MinutiPassata = 0.0
  CsvTrovato    = $false
  CsvPath       = ""
  N             = -1
  NLette        = -1
  NSenzaMfe     = 0
  NSenzaReal    = 0
  Buckets       = @{}
  NMfe05        = 0
  NMfe05NoTp1   = 0
  PctSuTot      = -1.0
  PctSuMfe05    = -1.0
  MediaRestit   = -1.0
  NMediaRestit  = 0
  NMfe05NoGeom  = 0
  PctGeomSuTot  = -1.0
  SommaReal     = 0.0
  SommaTetto    = 0.0
  NMfe1R        = 0
  IgieneStato   = "NON MISURATA"
  Misurabile    = $false
}

function Ora(){ return (Get-Date).ToString("HH:mm:ss", $INV) }
function Dico($t,$c="Gray"){ Write-Host ("[" + (Ora) + "] " + $t) -ForegroundColor $c }
function Titolo($t){ Write-Host ""; Write-Host ("=== " + $t + " ===") -ForegroundColor Cyan }

function Scarica($url,$dest,$marcatore){
  Remove-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue
  Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing -ErrorAction Stop
  if(-not (Test-Path -LiteralPath $dest)){ throw ("scarico fallito: " + $url) }
  $v = Get-Item -LiteralPath $dest
  if($v.PSIsContainer){ throw ("in destinazione c'e' una CARTELLA con quel nome (checklist 27-ter): " + $dest) }
  if($marcatore -ne "" -and -not (Select-String -LiteralPath $dest -SimpleMatch -Pattern $marcatore -Quiet)){
    throw ("file scaricato SENZA il marcatore '" + $marcatore + "': " + $url)
  }
}

function RigheVive($p){
  return @(Get-Content -LiteralPath $p | Where-Object { $_ -notmatch '^\s*#' -and $_ -notmatch '^\s*$' })
}
function NomeDi($riga){
  if($riga -match '^@'){ return ($riga -split '\s+')[0] }
  return (($riga -split '=')[0]).Trim()
}
function ValoreDi($riga){
  $resto = $riga.Substring($riga.IndexOf("=")+1)
  return (($resto -split '\|\|')[0]).Trim()
}
#  CULTURA INVARIANTE, SEMPRE (checklist 5 del 18/08): su Windows in
#  italiano [double]::TryParse("0.5") senza cultura legge il punto come
#  separatore delle MIGLIAIA e restituisce CINQUE.
function NumInv($s){
  $v = 0.0
  $t = ("" + $s).Trim()
  if($t -eq "" -or $t -eq "n/d"){ return $null }
  if([double]::TryParse($t,[Globalization.NumberStyles]::Float,$INV,[ref]$v)){ return $v }
  return $null
}
function Fmt($v,$dec){
  if($v -eq $null){ return "n/d" }
  return ([double]$v).ToString(("0." + ("0" * $dec)),$INV)
}
function Pct($v){
  if($v -eq $null -or [double]$v -lt 0){ return "NON MISURABILE" }
  return ([double]$v).ToString("0.0",$INV) + "%"
}

#  LETTURA DEI LOG A OFFSET (checklist 23-bis): si legge SOLO cio' che e'
#  stato scritto dopo la fotografia. Un file NON cresciuto non si rilegge
#  da capo, o il "finito" di ieri sera passa per quello di adesso.
function LeggiNuovo($path,$da){
  $b = $null
  try{
    $fs = [IO.File]::Open($path,[IO.FileMode]::Open,[IO.FileAccess]::Read,[IO.FileShare]::ReadWrite)
    $len = $fs.Length
    if($da % 2 -ne 0){ $da = $da - 1 }
    if($da -ge $len){ $fs.Close(); return "" }
    if($da -gt 0){ [void]$fs.Seek($da,[IO.SeekOrigin]::Begin) }
    $n = [int]($len - $da); $b = New-Object byte[] $n; $letti = 0
    while($letti -lt $n){ $q = $fs.Read($b,$letti,$n-$letti); if($q -le 0){ break }; $letti += $q }
    $fs.Close()
  }catch{ return "" }
  if($b -eq $null -or $b.Count -lt 4){ return "" }
  #  ENCODING SCELTO DAI BYTE, mai per decreto: i log MT5 sono UTF-16LE
  #  ma non sempre col BOM, e leggendo a offset il BOM non c'e' proprio.
  $utf16 = ($b[0] -eq 0xFF -and $b[1] -eq 0xFE)
  if(-not $utf16){
    $zeri = 0; $n2 = [math]::Min(400,$b.Count)
    for($i=1;$i -lt $n2;$i+=2){ if($b[$i] -eq 0){ $zeri++ } }
    $utf16 = ($zeri -gt ($n2/4))
  }
  if($utf16){ return [Text.Encoding]::Unicode.GetString($b) }
  return [Text.Encoding]::UTF8.GetString($b)
}

Write-Host ""
Write-Host "=====================================================================" -ForegroundColor White
Write-Host "  R104 - MFE: QUANTO VIENE RESTITUITO PRIMA DI 1R" -ForegroundColor White
Write-Host ("  " + $EaVivo + "  |  " + $Simbolo + " " + $Periodo) -ForegroundColor White
Write-Host "=====================================================================" -ForegroundColor White
Write-Host ("    modo .......................  " + $Modo) -ForegroundColor White
Write-Host ("    pin ........................  " + $(if($Pin -eq ""){ "MANCANTE" } else { $Pin })) -ForegroundColor White
Write-Host ("    finestra ...................  " + $DaQuando + " -> " + $Fino) -ForegroundColor White
Write-Host ("    modello ....................  " + $Modello + " = TICK REALI (dal 2024.07.05 su questo simbolo)") -ForegroundColor White
Write-Host ("    passate ....................  1 (UNA. Non e' una griglia e non e' un walk-forward)") -ForegroundColor White
Write-Host ("    magic di misura ............  " + $MagicMis + "   (il magic VIVO 770411 e' VIETATO e controllato)") -ForegroundColor White
Write-Host ("    deposito ...................  " + $Deposito) -ForegroundColor White
Write-Host ("    cancello G1 ................  n >= " + $SogliaG1 + " operazioni, altrimenti NON MISURABILE") -ForegroundColor White
Write-Host ""
Write-Host  "    >>> QUESTO ROUND NON PROMUOVE E NON BOCCIA NIENTE. E' una misura" -ForegroundColor Yellow
Write-Host  "        su un meccanismo gia' in campo, e non cambia una virgola del" -ForegroundColor Yellow
Write-Host  "        forward. Se dicesse che il trailing e' troppo largo, quella" -ForegroundColor Yellow
Write-Host  "        conversazione e' SUCCESSIVA e SEPARATA, con firma propria." -ForegroundColor Yellow

if($Pin -eq ""){
  Write-Host ""
  Write-Host "!!! MANCA -Pin. Questa riga gira SOLO su un commit congelato." -ForegroundColor Red
  Write-Host "    Rilancia col blocco intero, che passa -Pin <hash>." -ForegroundColor Yellow
  exit 1
}

try{

# =====================================================================
#  0. MT5 E METAEDITOR CHIUSI. Prima di qualunque altra cosa.
# =====================================================================
$vivi = @(Get-Process -Name "terminal64","metaeditor64" -ErrorAction SilentlyContinue)
if($vivi.Count -gt 0){
  Write-Host ""
  Write-Host ("!!! APERTO: " + (($vivi | ForEach-Object { $_.ProcessName } | Sort-Object -Unique) -join ", ")) -ForegroundColor Red
  Write-Host "    Non parto: col terminale aperto il tester non gira, e con MetaEditor" -ForegroundColor Red
  Write-Host "    aperto la compilazione torna subito SENZA compilare." -ForegroundColor Red
  #  DICHIARATO: questo exit sta DENTRO il try e salta la raccolta. Qui e'
  #  accettabile -- siamo a due secondi dal lancio e non e' stato prodotto
  #  NIENTE. Il messaggio a schermo E' il referto di questo caso.
  exit 1
}

# =====================================================================
#  1. TERMINALE E CARTELLA DATI (per NOME, mai il primo che capita)
# =====================================================================
Titolo "1. TERMINALE E CARTELLA DATI"
New-Item -ItemType Directory -Force -Path $Work,$Prove,$Logs,$SrcDir,$Sosta | Out-Null
$tutti = @(Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue)
$cand  = @($tutti | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*" })
if($cand.Count -eq 0){ throw "non trovo il terminale 'BCM Markets MT5 Terminal' (quello NON -V3). Non tiro a indovinare." }
if($cand.Count -gt 1){ throw ("trovati " + $cand.Count + " terminali che corrispondono: ambiguo, mi fermo.") }
$InstDir    = $cand[0].DirectoryName
$Terminal   = Join-Path $InstDir "terminal64.exe"
$MetaEditor = Join-Path $InstDir "metaeditor64.exe"
if(-not (Test-Path -LiteralPath $MetaEditor)){ throw ("manca metaeditor64.exe in " + $InstDir) }
$termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$DataFolder = Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue | Where-Object {
    $o = Join-Path $_.FullName "origin.txt"
    (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $InstDir)
  } | Select-Object -First 1 -ExpandProperty FullName
if(-not $DataFolder){ throw "cartella dati MT5 non trovata (origin.txt non punta a nessuna cartella)." }
$MqlExperts = Join-Path $DataFolder "MQL5\Experts"
$MqlInclude = Join-Path $DataFolder "MQL5\Include"
$MqlFiles   = Join-Path $DataFolder "MQL5\Files"
$Comune     = Join-Path $termRoot   "Common\Files"
New-Item -ItemType Directory -Force -Path $MqlExperts,$MqlInclude,$MqlFiles,$Comune | Out-Null
Dico ("terminale : " + $Terminal)
Dico ("dati      : " + $DataFolder)
Dico ("comune    : " + $Comune + "   <- e' qui che nasce " + $CsvMfe)

# --- 1-bis. LA SOSTA SI SVUOTA A OGNI GIRO (checklist 56). Senza, gli
#     artefatti del giro a vuoto finirebbero nello zip della corsa vera,
#     indistinguibili da quelli veri.
$nSosta = @(Get-ChildItem -LiteralPath $Sosta -File -ErrorAction SilentlyContinue).Count
if($nSosta -gt 0){
  Get-ChildItem -LiteralPath $Sosta -File -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
  $nDopo = @(Get-ChildItem -LiteralPath $Sosta -File -ErrorAction SilentlyContinue).Count
  if($nDopo -gt 0){
    [void]$Problemi.Add("sosta: " + $nDopo + " file su " + $nSosta + " di un giro PRECEDENTE non sono stati cancellati. Possono finire nello zip di questo round spacciandosi per artefatti di adesso: controllare le date dentro lo zip.")
  }
  Dico ("sosta svuotata: " + $nSosta + " file di un giro precedente rimossi (rimasti: " + $nDopo + ")") "Green"
}

# --- 1a. L'INCLUDE CHE NESSUN DRIVER INSTALLA (checklist 33-bis).
#     Il sorgente fa #include <ABTG_PausaGuardian.mqh>: senza, la
#     compilazione fallisce e il round muore prima di cominciare.
#     NOTA: nel tester il Guardian e' FAIL-OPEN TOTALE (le sue
#     GlobalVariable non esistono li'): non cambia una virgola.
$mqh = Join-Path $MqlInclude "ABTG_PausaGuardian.mqh"
Scarica ("$RawPin/mql5/Include/ABTG_PausaGuardian.mqh") $mqh 'ABTG_GuardiaIngresso'
$vfy = Get-Item -LiteralPath $mqh
if($vfy.Length -lt 4000){ throw ("ABTG_PausaGuardian.mqh e' lungo " + $vfy.Length + " byte: troppo poco, scarico monco.") }
Dico ("include installato: ABTG_PausaGuardian.mqh (" + $vfy.Length + " byte)") "Green"

# =====================================================================
#  2. IL FILE PROVA E I SUOI GATE
# =====================================================================
Titolo "2. IL FILE PROVA"
$ProvaFile = Join-Path $Prove $NomeProva
Scarica ("$RawPin/backtest_pipeline/prove/" + $NomeProva) $ProvaFile '@SIMBOLO'
$Vive = RigheVive $ProvaFile
if($Vive.Count -ne $RigheVive){ throw ("file prova: " + $Vive.Count + " righe vive invece di " + $RigheVive + ": artefatto cambiato.") }
$ProvaPar = @($Vive | Where-Object { $_ -notmatch '^@' })
if($ProvaPar.Count -ne $ParAttesi){ throw ("file prova: " + $ProvaPar.Count + " parametri invece di " + $ParAttesi + ".") }
$txtProva = Get-Content -LiteralPath $ProvaFile -Raw
#  >>> OGNI $ DI UNA REGEX MULTILINEA SI SCRIVE \r?$ (checklist 40): i
#      file arrivano da GitHub con CRLF.
$m1 = [regex]::Match($txtProva,'(?m)^@SIMBOLO\s+(\S+)')
if(-not $m1.Success -or $m1.Groups[1].Value -ne $Simbolo){ throw ("@SIMBOLO non e' " + $Simbolo) }
$m2 = [regex]::Match($txtProva,'(?m)^@PERIODO\s+(\S+)')
if(-not $m2.Success -or $m2.Groups[1].Value -ne $Periodo){ throw ("@PERIODO non e' " + $Periodo + " (la sedia viva gira su quel timeframe di grafico)") }
$m3 = [regex]::Match($txtProva,'(?m)^@DAQUANDO\s+([0-9]{4}\.[0-9]{2}\.[0-9]{2})')
if(-not $m3.Success -or $m3.Groups[1].Value -ne $DaQuando){ throw ("@DAQUANDO non e' " + $DaQuando + " (il muro del feed BCM sugli indici, MISURATO dalla sonda del 17/08)") }
#  --- il rischio e il commento: sono la TAGLIA e l'identita' della sedia
if($txtProva -notmatch ('(?m)^InpRiskPercent=' + [regex]::Escape($Rischio) + '\|\|')){ throw ("file prova: InpRiskPercent non e' " + $Rischio) }
if($txtProva -notmatch ('(?m)^InpComment=' + [regex]::Escape($Commento) + '\r?$')){ throw ("file prova: InpComment non e' '" + $Commento + "'.") }
#  --- il magic: quello di MISURA, e MAI uno vivo
if($txtProva -notmatch ('(?m)^InpMagic=' + $MagicMis + '\|\|')){ throw ("file prova: InpMagic non e' " + $MagicMis) }
foreach($v in $MagicVietati){
  if($txtProva -match ('(?m)^InpMagic=' + $v + '\b')){ throw ("file prova: usa il magic " + $v + ", che e' di una SEDIA VIVA. Fermo tutto.") }
}
#  --- NESSUN asse spazzolato. Questa e' UNA passata, non una griglia.
$assiY = @([regex]::Matches($txtProva,'(?m)^(\w+)=[^\r\n]*\|\|\s*[Yy]\s*\r?$') | ForEach-Object { $_.Groups[1].Value })
if($assiY.Count -ne 0){
  throw ("file prova: ci sono " + $assiY.Count + " assi con flag Y [" + ($assiY -join ", ") + "]. R104 gira UNA passata singola: un asse Y vorrebbe dire un'ottimizzazione, e i criteri dicono 'nessuna cella nuova, nessuna ottimizzazione'.")
}
Dico ("file prova: " + $Vive.Count + " righe vive (" + $ProvaPar.Count + " parametri + 3 direttive), " + $Simbolo + " " + $Periodo + " dal " + $DaQuando + ", rischio " + $Rischio + "%, magic " + $MagicMis + ", ZERO assi Y") "Green"

# =====================================================================
#  3. IL SORGENTE DI MISURA E I SUOI GATE
# =====================================================================
Titolo "3. IL SORGENTE DI MISURA"
$srcMq5 = Join-Path $SrcDir ($Ea + ".mq5")
Scarica ("$RawPin/mql5/Experts/" + $Ea + ".mq5") $srcMq5 $MarkSrc
$txtSrc = Get-Content -LiteralPath $srcMq5 -Raw
if($txtSrc -notmatch ('InpMagic\s*=\s*' + $MagicMis)){ throw ($Ea + ".mq5 non dichiara InpMagic = " + $MagicMis + ": non e' il motore che credo.") }
if($txtSrc -match 'InpMagic\s*=\s*770411'){ throw ($Ea + ".mq5 dichiara ancora il magic VIVO 770411: mi fermo.") }
if($txtSrc -notmatch 'ABTG_PausaGuardian\.mqh'){ throw ($Ea + ".mq5 non include ABTG_PausaGuardian.mqh: non e' la copia del sorgente vivo.") }
if($txtSrc -notmatch 'OnTesterDeinit'){ throw ($Ea + ".mq5 non ha OnTesterDeinit: la copia ha perso l'OPTFRAME del sorgente vivo.") }
if($txtSrc -notmatch [regex]::Escape('ABTG_MFE_MaxMinDAX.csv')){ throw ($Ea + ".mq5 non nomina " + $CsvMfe + ": il contatore non scriverebbe dove il driver lo cerca.") }
if($txtSrc -notmatch 'MfeAggiorna\(\)'){ throw ($Ea + ".mq5 non chiama MfeAggiorna(): il contatore non gira.") }
#  >>> LE COSE CHE DEVONO ESSERE RIMASTE IDENTICHE AL SORGENTE VIVO.
#      Non e' un diff completo (quello sta nel commit): sono le cinque
#      decisioni di trading del round, e se una fosse sparita la misura
#      descriverebbe un'ALTRA sedia.
foreach($pezzo in @('PositionClosePartial','InpTP1_R','InpTrailAtrMult','InpAtrSLmult','InpUseEMA200Target')){
  if($txtSrc -notmatch [regex]::Escape($pezzo)){ throw ($Ea + ".mq5 non contiene piu' '" + $pezzo + "': la copia di misura NON e' piu' la sedia viva.") }
}
$mv = [regex]::Match($txtSrc,'#property\s+version\s+"([^"]+)"')
$ver = "n/d"; if($mv.Success){ $ver = $mv.Groups[1].Value }
Dico ($Ea + ".mq5 al pin, version " + $ver + " (magic " + $MagicMis + ", marcatore " + $MarkSrc + ", include Guardian, OPTFRAME, contatore MFE)") "Green"

# =====================================================================
#  4. FASE COMPILA. .ex5 SCRITTO ADESSO.
#     >>> INVOCAZIONE DIRETTA di metaeditor64.exe (checklist 54): con
#         Start-Process -ArgumentList a stringhe pre-quotate, sui path
#         con spazi ("Program Files") torna rc=0 SENZA compilare.
#     >>> IL VERDETTO E' IL LastWriteTime DEL .ex5 PRIMA/DOPO, non
#         "esiste" e non "e' recente".
#     >>> QUI NON SI TOCCA NESSUNA SEDIA VIVA: il file compilato si
#         chiama ..._MFE.mq5 e produce ..._MFE.ex5. Il .mq5 e il .ex5
#         del sorgente VIVO non vengono ne' letti ne' riscritti. Il
#         backup datato c'e' lo stesso, per la copia di misura.
# =====================================================================
if(-not $SoloControllo){
  Titolo "4. FASE COMPILA"
  $mq5 = Join-Path $MqlExperts ($Ea + ".mq5")
  $ex5 = Join-Path $MqlExperts ($Ea + ".ex5")
  $logC= Join-Path $MqlExperts ($Ea + ".log")
  $bakMq5 = $mq5 + ".prima_r104_" + $Stamp
  $bakEx5 = $ex5 + ".prima_r104_" + $Stamp
  #  UN BACKUP SI SCRIVE SOLO SE NON ESISTE GIA' (checklist 12): al
  #  secondo lancio -Force ci scriverebbe sopra la versione nuova e il
  #  rollback morirebbe in silenzio.
  if((Test-Path -LiteralPath $mq5) -and -not (Test-Path -LiteralPath $bakMq5)){ Copy-Item -LiteralPath $mq5 -Destination $bakMq5 -Force }
  if((Test-Path -LiteralPath $ex5) -and -not (Test-Path -LiteralPath $bakEx5)){ Copy-Item -LiteralPath $ex5 -Destination $bakEx5 -Force }
  $lenSrc = (Get-Item -LiteralPath $srcMq5).Length
  Copy-Item -LiteralPath $srcMq5 -Destination $mq5 -Force
  #  la copia si verifica sul CONTENUTO, non sull'esistenza del nome
  #  (checklist 27-ter).
  $vc = Get-Item -LiteralPath $mq5 -ErrorAction SilentlyContinue
  if(-not $vc -or $vc.PSIsContainer -or $vc.Length -ne $lenSrc){ throw "copia del .mq5 in MQL5\Experts NON verificata (lunghezza diversa o e' una cartella)." }
  $ex5Prima = (Get-Date).AddYears(-100)
  if(Test-Path -LiteralPath $ex5){ $ex5Prima = (Get-Item -LiteralPath $ex5).LastWriteTime }
  Remove-Item -LiteralPath $logC -Force -ErrorAction SilentlyContinue
  & $MetaEditor "/compile:$mq5" "/log:$logC" | Out-Null
  $rcMe = $LASTEXITCODE
  #  metaeditor64 puo' tornare PRIMA di aver finito di scrivere .ex5/.log:
  #  senza questa attesa si dichiara "COMPILAZIONE FALLITA" su un sorgente
  #  sano (pattern di RIGA_R95).
  $scad = (Get-Date).AddMinutes(5)
  while((Get-Date) -lt $scad){
    if((Test-Path -LiteralPath $ex5) -and ((Get-Item -LiteralPath $ex5).LastWriteTime -gt $ex5Prima)){ break }
    Start-Sleep -Seconds 2
  }
  $ex5Dopo = $null
  if(Test-Path -LiteralPath $ex5){ $ex5Dopo = (Get-Item -LiteralPath $ex5).LastWriteTime }
  $compileOk = ($ex5Dopo -ne $null) -and ($ex5Dopo -gt $ex5Prima)
  $testoLog = ""
  if(Test-Path -LiteralPath $logC){
    try{ $testoLog = (Get-Content -LiteralPath $logC -Raw -Encoding Unicode) }catch{ $testoLog = "" }
    if($testoLog -notmatch '(?i)error'){ try{ $testoLog = (Get-Content -LiteralPath $logC -Raw) }catch{} }
    Copy-Item -LiteralPath $logC -Destination (Join-Path $Sosta ("compile_" + $Ea + ".log")) -Force -ErrorAction SilentlyContinue
  }
  if(-not $compileOk){
    if($testoLog -ne ""){
      Write-Host "--- log del compilatore (ultime righe) ---" -ForegroundColor DarkYellow
      foreach($r in @($testoLog -split "\r?\n" | Select-Object -Last 20)){ Write-Host ("   " + $r) -ForegroundColor DarkYellow }
    } else { Write-Host "   (nessun log prodotto da MetaEditor)" -ForegroundColor DarkYellow }
    if(Test-Path -LiteralPath $bakMq5){ Copy-Item -LiteralPath $bakMq5 -Destination $mq5 -Force }
    throw ("COMPILAZIONE FALLITA per " + $Ea + " (metaeditor rc=" + $rcMe + ", .ex5 NON riscritto). Sospetto n.1: MetaEditor gia' aperto, oppure l'include ABTG_PausaGuardian.mqh.")
  }
  $mw = [regex]::Match($testoLog,'(?i)(\d+)\s+warning')
  if($mw.Success -and [int]$mw.Groups[1].Value -gt 0){
    [void]$Note.Add($Ea + ": compilazione con " + $mw.Groups[1].Value + " warning (0 errori). Non fermano il round, ma vanno letti in compile_" + $Ea + ".log dello zip.")
  }
  Dico ("COMPILATO " + $Ea + " (.ex5 riscritto adesso, rc=" + $rcMe + ")") "Green"
}

# =====================================================================
#  5. L'.ini DELLA PASSATA SINGOLA. Un solo artefatto: le righe le
#     detta il FILE PROVA, non questa riga (checklist 33). I valori si
#     scrivono SECCHI e Optimization=0: un "||" rimasto vorrebbe dire
#     un'ottimizzazione travestita, e in ottimizzazione le Print non le
#     legge nessuno (checklist 34).
# =====================================================================
Titolo "5. L'.ini DELLA PASSATA"
$Report  = "R104_MFE_" + $Stamp
$IniFile = Join-Path $Work "R104_passata.ini"
$out = New-Object System.Collections.ArrayList
foreach($r in $ProvaPar){ [void]$out.Add((NomeDi $r) + "=" + (ValoreDi $r)) }
$inputs = ($out -join "`r`n")
if(@($out).Count -ne $ParAttesi){ throw ("ini: " + @($out).Count + " parametri invece di " + $ParAttesi) }
if($inputs -match '\|\|'){ throw "ini: e' rimasto uno sweep '||'. Sarebbe un'ottimizzazione, non una passata singola." }
if($inputs -notmatch '(?m)^InpVerbose=true\r?$'){ throw "ini: InpVerbose non e' true: l'EA non stamperebbe niente nel log e la corsa sarebbe cieca." }
if($inputs -notmatch ('(?m)^InpMagic=' + $MagicMis + '\r?$')){ throw ("ini: InpMagic non pinnato a " + $MagicMis) }
if($inputs -notmatch ('(?m)^InpRiskPercent=' + [regex]::Escape($Rischio) + '\r?$')){ throw ("ini: InpRiskPercent non e' " + $Rischio) }
$testoIni = @"
[Charts]
MaxBars=2000000000

[Experts]
AllowLiveTrading=false
AllowDllImport=false

[Tester]
Expert=$Ea.ex5
Symbol=$Simbolo
Period=$Periodo
Model=$Modello
Spread=$SpreadIni
Optimization=0
FromDate=$DaQuando
ToDate=$Fino
ForwardMode=0
Deposit=$Deposito
Currency=EUR
Leverage=100
ExecutionMode=0
ReplaceReport=1
ShutdownTerminal=1
Report=$Report

[TesterInputs]
$inputs
"@
Set-Content -LiteralPath $IniFile -Value $testoIni -Encoding ASCII
#  --- I GATE SULLO STATO FINALE DEL FILE, non sul replace (checklist 33).
$verifica = Get-Content -LiteralPath $IniFile -Raw
if($verifica -notmatch '(?m)^AllowLiveTrading=false\r?$'){ throw "ini: manca [Experts] AllowLiveTrading=false. Aprire il terminale per MISURARE riarmerebbe la flotta sul conto vivo (checklist 51)." }
if($verifica -notmatch ('(?m)^Model=' + $Modello + '\r?$')){ throw ("ini: Model non e' " + $Modello + " (tick reali).") }
if($verifica -notmatch '(?m)^Optimization=0\r?$'){ throw "ini: Optimization non e' 0." }
if($verifica -notmatch '(?m)^ShutdownTerminal=1\r?$'){ throw "ini: manca ShutdownTerminal=1. Senza, il terminale non esce da solo e l'attesa non finirebbe mai." }
if($verifica -notmatch ('(?m)^FromDate=' + [regex]::Escape($DaQuando) + '\r?$')){ throw "ini: FromDate sbagliata." }
if($verifica -notmatch ('(?m)^ToDate=' + [regex]::Escape($Fino) + '\r?$')){ throw "ini: ToDate sbagliata." }
Copy-Item -LiteralPath $IniFile -Destination (Join-Path $Sosta "R104_passata.ini") -Force
Copy-Item -LiteralPath $ProvaFile -Destination (Join-Path $Sosta $NomeProva) -Force
Dico ("ini scritto e verificato: " + $IniFile + "  (" + @($out).Count + " parametri, Model=" + $Modello + ", Optimization=0)") "Green"

# =====================================================================
#  6. LA PASSATA. E gli artefatti VECCHI si cancellano PRIMA.
# =====================================================================
$CsvMfePath  = Join-Path $Comune $CsvMfe
$CsvTradePath= Join-Path $Comune ("abtg_trades_" + $Ea + "_" + $Simbolo + "_" + $MagicMis + ".csv")
if($SoloControllo){
  Titolo "6. LA PASSATA -- SALTATA (giro a vuoto)"
  Write-Host "    -SoloControllo NON apre MT5: nessuna passata, nessun CSV, NESSUN numero." -ForegroundColor Yellow
} else {
  Titolo "6. LA PASSATA"
  #  >>> SI CANCELLA PRIMA (checklist 14 e 23). Se la passata non
  #      producesse niente, un file di IERI resterebbe li' e verrebbe
  #      letto come il risultato di ADESSO: e' il referto stantio.
  if($TieniArtefatti){
    [void]$Note.Add("-TieniArtefatti: i CSV comuni NON sono stati cancellati prima della corsa. Il referto NON puo' garantire che siano di adesso: guardare le date.")
  } else {
    Remove-Item -LiteralPath $CsvMfePath   -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath $CsvTradePath -Force -ErrorAction SilentlyContinue
    if(Test-Path -LiteralPath $CsvMfePath){ [void]$Problemi.Add("non sono riuscito a cancellare il CSV MFE vecchio (" + $CsvMfePath + "): se resta li', quello che leggo potrebbe non essere di questa corsa. Controllare la data.") }
  }
  $tAvvioPassata = Get-Date
  #  le radici dei log, fotografate a OFFSET
  $RadiciLog = @( (Join-Path $DataFolder "Tester"), (Join-Path $InstDir "Tester"),
                  (Join-Path $env:APPDATA "MetaQuotes\Tester"), (Join-Path $DataFolder "MQL5\Logs") )
  $primaLen = @{}
  foreach($rad in $RadiciLog){
    if(-not (Test-Path -LiteralPath $rad)){ continue }
    foreach($f in @(Get-ChildItem -LiteralPath $rad -Recurse -Filter "*.log" -File -ErrorAction SilentlyContinue)){ $primaLen[$f.FullName] = $f.Length }
  }
  Write-Host ("  -- lancio la passata " + $DaQuando + " -> " + $Fino + " a tick reali. Puo' durare." ) -ForegroundColor White
  Write-Host  "     NON c'e' nessun timeout: l'ini ha ShutdownTerminal=1 e il terminale" -ForegroundColor White
  Write-Host  "     esce DA SOLO a test finito. Un timeout che lo ammazza a meta'" -ForegroundColor White
  Write-Host  "     lascerebbe un CSV troncato che sembra un risultato (checklist 19)." -ForegroundColor White
  (Start-Process -FilePath $Terminal -ArgumentList ("/config:`"" + $IniFile + "`"") -PassThru).WaitForExit()
  $Ris.MinutiPassata = [math]::Round((New-TimeSpan -Start $tAvvioPassata -End (Get-Date)).TotalMinutes,1)
  $Ris.Eseguita = $true
  Dico ("  ... passata finita (il terminale e' uscito da solo): " + $Ris.MinutiPassata.ToString("0.0",$INV) + " minuti") "Gray"

  #  --- IL LOG, letto SOLO nei byte scritti dopo l'avvio (checklist 23-bis)
  $righeEa = New-Object System.Collections.ArrayList
  foreach($rad in $RadiciLog){
    if(-not (Test-Path -LiteralPath $rad)){ continue }
    foreach($lg in @(Get-ChildItem -LiteralPath $rad -Recurse -Filter "*.log" -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime)){
      $da = 0
      if($primaLen.ContainsKey($lg.FullName)){ $da = $primaLen[$lg.FullName] }
      $tx = LeggiNuovo $lg.FullName $da
      if($tx -eq ""){ continue }
      foreach($r in ($tx -split "`r?`n")){
        if($r -match '\[MaxMinNotte\]' -or $r -match '\[MFE\]'){ [void]$righeEa.Add($r.Trim()) }
      }
    }
  }
  if($righeEa.Count -gt 0){
    $dump = New-Object System.Collections.ArrayList
    [void]$dump.Add("R104 - righe di log dell'EA scritte DOPO l'avvio della passata (" + $righeEa.Count + ")")
    [void]$dump.Add("")
    foreach($x in @($righeEa | Select-Object -First 400)){ [void]$dump.Add($x) }
    Set-Content -LiteralPath (Join-Path $Sosta "log_ea.txt") -Value $dump -Encoding ASCII
    Dico ("log dell'EA: " + $righeEa.Count + " righe nuove (le prime 400 sono nello zip)") "Gray"
  } else {
    [void]$Note.Add("nessuna riga di log dell'EA letta dopo l'avvio della passata. Non e' di per se' un guasto (i log del tester possono finire in una cartella diversa), ma senza log l'unica prova che la corsa e' avvenuta sono i CSV e il report.")
  }

  #  --- IL REPORT .htm: e' la seconda prova che la passata e' di ADESSO
  foreach($rad in @($InstDir,$DataFolder,$Work,$MqlFiles)){
    if(-not (Test-Path -LiteralPath $rad)){ continue }
    $c = @(Get-ChildItem -LiteralPath $rad -Filter ($Report + "*.htm*") -File -ErrorAction SilentlyContinue |
           Where-Object { $_.LastWriteTime -ge $tAvvioPassata } | Sort-Object LastWriteTime -Descending)
    if($c.Count -gt 0){ Copy-Item -LiteralPath $c[0].FullName -Destination (Join-Path $Sosta "report_passata.htm") -Force -ErrorAction SilentlyContinue; break }
  }
  if(-not (Test-Path -LiteralPath (Join-Path $Sosta "report_passata.htm"))){
    [void]$Note.Add("report .htm della passata non trovato (cercato '" + $Report + "*.htm' in " + $InstDir + ", " + $DataFolder + ", " + $Work + ", " + $MqlFiles + "). Il round non ne ha bisogno -- i suoi numeri vengono dal CSV MFE -- ma era la prova cartacea in piu'.")
  }
}

# =====================================================================
#  7. IL CSV MFE: LO SI LEGGE, LO SI CONTA, E SI RISPONDE
# =====================================================================
if(-not $SoloControllo){
  Titolo "7. IL CSV MFE"
  if(-not (Test-Path -LiteralPath $CsvMfePath)){
    $Fatale = "il CSV " + $CsvMfe + " NON esiste in " + $Comune + ". La passata non ha prodotto niente: o l'EA non e' partito (guarda compile_*.log e log_ea.txt nello zip), o il tester non ha girato. NON si inventa nessun numero."
  }
  else{
    $fi = Get-Item -LiteralPath $CsvMfePath
    if($fi.LastWriteTime -lt $tAvvioPassata){
      $Fatale = "il CSV " + $CsvMfe + " e' del " + $fi.LastWriteTime.ToString("yyyy-MM-dd HH:mm",$INV) + ", cioe' PRIMA dell'avvio di questa passata: e' STANTIO e NON descrive questa corsa. Non lo leggo."
    }
    else{
      $Ris.CsvTrovato = $true
      $Ris.CsvPath = $CsvMfePath
      Copy-Item -LiteralPath $CsvMfePath -Destination (Join-Path $Sosta $CsvMfe) -Force -ErrorAction SilentlyContinue
      if(Test-Path -LiteralPath $CsvTradePath){ Copy-Item -LiteralPath $CsvTradePath -Destination (Join-Path $Sosta ("abtg_trades_" + $MagicMis + ".csv")) -Force -ErrorAction SilentlyContinue }
      $righe = @(Import-Csv -LiteralPath $CsvMfePath -Delimiter ';')
      $Ris.NLette = $righe.Count
      #  CONTROLLO POSITIVO SUL PARSER (checklist 55): le colonne si
      #  cercano PER NOME. Se non ci sono, si torna indietro e si dice
      #  cosa si e' visto -- non si tira a indovinare la posizione.
      $colonne = @()
      if($righe.Count -gt 0){ $colonne = @($righe[0].PSObject.Properties.Name) }
      $servono = @("mfe_R","realizzato_R","tp1_toccato","esito","tp1_geom_1R")
      $mancano = @($servono | Where-Object { $colonne -notcontains $_ })
      if($righe.Count -eq 0){
        $Ris.N = 0
        [void]$Problemi.Add("il CSV MFE esiste ed e' di adesso, ma ha ZERO righe (solo intestazione). Vuol dire che la passata non ha chiuso NESSUNA posizione col magic " + $MagicMis + ". E' una risposta, non un guasto: ma il round non e' misurabile.")
      }
      elseif($mancano.Count -gt 0){
        $Fatale = "il CSV MFE non ha le colonne attese (mancano: " + ($mancano -join ", ") + "). Colonne viste: [" + ($colonne -join ", ") + "]. Il formato e' cambiato: NON leggo niente per non leggere la colonna sbagliata."
      }
      else{
        # ------------------------------------------------------------
        #  I CONTI. Tutti su numeri letti a cultura INVARIANTE.
        # ------------------------------------------------------------
        $Ris.N = $righe.Count
        $bk = [ordered]@{ "<0.3R"=0; "0.3-0.5R"=0; "0.5-0.8R"=0; "0.8-1.0R"=0; ">=1R"=0 }
        $sommaDelta = 0.0; $nDelta = 0
        foreach($r in $righe){
          $mfe = NumInv $r.mfe_R
          $rea = NumInv $r.realizzato_R
          $tp1 = ("" + $r.tp1_toccato).Trim()
          $tpg = ("" + $r.tp1_geom_1R).Trim()
          if($mfe -eq $null){ $Ris.NSenzaMfe++ ; continue }
          if($rea -eq $null){ $Ris.NSenzaReal++ }
          if    ($mfe -lt 0.3){ $bk["<0.3R"]++ }
          elseif($mfe -lt 0.5){ $bk["0.3-0.5R"]++ }
          elseif($mfe -lt 0.8){ $bk["0.5-0.8R"]++ }
          elseif($mfe -lt 1.0){ $bk["0.8-1.0R"]++ }
          else                { $bk[">=1R"]++ ; $Ris.NMfe1R++ }
          if($mfe -ge 0.5){
            $Ris.NMfe05++
            if($tp1 -eq "0"){
              $Ris.NMfe05NoTp1++
              if($rea -ne $null){ $sommaDelta += ([double]$mfe - [double]$rea); $nDelta++ }
            }
            if($tpg -eq "0"){ $Ris.NMfe05NoGeom++ }
          }
          #  IL TETTO TEORICO (criteri par. 6): quanto sarebbe uscito se
          #  OGNI mfe >= 1R fosse stato incassato a 1R esatto, lasciando
          #  gli altri come sono andati. >>> E' UN LIMITE SUPERIORE
          #  IRREALIZZABILE, MAI UN OBIETTIVO OPERATIVO: nessuno sa in
          #  anticipo quale trade tocchera' 1R, e incassare a 1R spegne
          #  anche i trade che poi andavano a 3R.
          if($rea -ne $null){
            $Ris.SommaReal += [double]$rea
            if($mfe -ge 1.0){ $Ris.SommaTetto += 1.0 } else { $Ris.SommaTetto += [double]$rea }
          }
        }
        $Ris.Buckets = $bk
        $Ris.NMediaRestit = $nDelta
        if($nDelta -gt 0){ $Ris.MediaRestit = [math]::Round($sommaDelta / $nDelta,3) }
        # --- IL CANCELLO G1
        if($Ris.N -lt $SogliaG1){
          [void]$Note.Add("G1 NON PASSATO: " + $Ris.N + " operazioni, sotto le " + $SogliaG1 + " del criterio. Le PERCENTUALI sono NON MISURABILI e il referto le scrive cosi'. L'istogramma resta stampato, perche' contare non e' stimare -- ma non se ne ricava nessuna frequenza.")
        } else {
          $Ris.Misurabile = $true
          $Ris.PctSuTot     = [math]::Round(100.0 * $Ris.NMfe05NoTp1 / $Ris.N,1)
          $Ris.PctGeomSuTot = [math]::Round(100.0 * $Ris.NMfe05NoGeom / $Ris.N,1)
          if($Ris.NMfe05 -gt 0){ $Ris.PctSuMfe05 = [math]::Round(100.0 * $Ris.NMfe05NoTp1 / $Ris.NMfe05,1) }
        }
        # --- IL CONTROLLO D'IGIENE, sul secondo strumento
        if(Test-Path -LiteralPath $CsvTradePath){
          try{
            $tr = @(Import-Csv -LiteralPath $CsvTradePath -Delimiter ';')
            $colT = @()
            if($tr.Count -gt 0){ $colT = @($tr[0].PSObject.Properties.Name) }
            if($colT -contains "position_id"){
              $nPos = @($tr | Select-Object -ExpandProperty position_id -ErrorAction SilentlyContinue | Sort-Object -Unique).Count
              if($nPos -eq $Ris.N){ $Ris.IgieneStato = "OK: " + $Ris.N + " righe MFE = " + $nPos + " posizioni chiuse contate nello storico dei deal" }
              else{
                $Ris.IgieneStato = "DIVERGONO: " + $Ris.N + " righe MFE contro " + $nPos + " posizioni nello storico dei deal"
                [void]$Problemi.Add("CONTROLLO D'IGIENE FALLITO: il contatore tick-su-tick ha registrato " + $Ris.N + " operazioni, lo storico dei deal ne conta " + $nPos + ". I due strumenti non dicono la stessa cosa: le percentuali di questo referto vanno lette come SOSPETTE finche' lo scarto non e' spiegato.")
              }
            } else {
              $Ris.IgieneStato = "NON MISURATA (in abtg_trades manca la colonna position_id; colonne viste: " + ($colT -join ", ") + ")"
            }
          }catch{ $Ris.IgieneStato = "NON MISURATA (abtg_trades non leggibile: " + $_.Exception.Message + ")" }
        } else {
          $Ris.IgieneStato = "NON MISURATA (abtg_trades_*.csv non trovato nella cartella comune)"
          [void]$Note.Add("il controllo d'igiene non e' stato eseguito: manca " + $CsvTradePath + ". 'NON MISURATO' non e' 'va bene'.")
        }
      }
    }
  }
}

}catch{
  $Fatale = $_.Exception.Message
  Write-Host ""
  Write-Host ("!!! FERMATO: " + $Fatale) -ForegroundColor Red
}

# =====================================================================
#  8. LA RACCOLTA. SEMPRE, anche a corsa fermata.
# =====================================================================
$Cart    = Join-Path $Dsk ("R104_MFE_MAXMIN_DAX_" + $Modo + "_" + $Stamp)
$Zip     = $Cart + ".zip"
$Referto = Join-Path $Cart "REFERTO_R104.txt"
try{
  New-Item -ItemType Directory -Force -Path $Cart | Out-Null
  if(Test-Path -LiteralPath $Sosta){
    Get-ChildItem -LiteralPath $Sosta -File -ErrorAction SilentlyContinue | ForEach-Object {
      try{ Copy-Item -LiteralPath $_.FullName -Destination $Cart -Force }catch{}
    }
  }
  $R = New-Object System.Collections.ArrayList
  [void]$R.Add("=====================================================================")
  [void]$R.Add(" R104 - MFE: QUANTO VIENE RESTITUITO PRIMA DI 1R")
  [void]$R.Add(" " + $EaVivo + "  --  " + $Simbolo + " " + $Periodo)
  [void]$R.Add("=====================================================================")
  [void]$R.Add("data:     " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   <<< DEVE essere di ADESSO")
  [void]$R.Add("modo:     " + $Modo + $(if($SoloControllo){ "   <<< GIRO A VUOTO: NON e' il round, non e' un risultato" } else { "" }))
  [void]$R.Add("pin:      " + $Pin)
  [void]$R.Add("criteri:  backtest_pipeline\risultati_archivio\R104_CRITERI_MFE_MAXMIN_DAX.md")
  [void]$R.Add("          (autorizzati da Claudio in chat il 24/08/2026: 'Si, misuriamo quanto succede')")
  [void]$R.Add("driver:   backtest_pipeline\righe\RIGA_R104_MFE_MAXMIN_DAX.ps1  (MARCATORE_RIGA_R104_v1)")
  [void]$R.Add("motore:   " + $Ea + ".mq5   (COPIA DI MISURA, marcatore " + $MarkSrc + ")")
  [void]$R.Add("prova:    backtest_pipeline\prove\" + $NomeProva)
  [void]$R.Add("finestra: " + $DaQuando + " -> " + $Fino + "   modello " + $Modello + " = TICK REALI   deposito " + $Deposito)
  [void]$R.Add("magic:    " + $MagicMis + " (di MISURA). Il magic VIVO 770411 e' VIETATO e controllato nel codice.")
  [void]$R.Add("durata:   " + $Ris.MinutiPassata.ToString("0.0",$INV) + " minuti di passata")
  [void]$R.Add("")
  [void]$R.Add("--- LA DOMANDA, ed e' di Claudio (24/08, davanti al trade #3221475) ---")
  [void]$R.Add("  su quante operazioni il prezzo raggiunge un profitto flottante importante")
  [void]$R.Add("  e POI torna indietro SENZA mai toccare il 1o target (1R, dove scatta la")
  [void]$R.Add("  parziale + lo stop in pari)?  E quanto, in media, viene restituito?")
  [void]$R.Add("")
  [void]$R.Add("--- COME SI LEGGE, PRIMA DEI NUMERI ---")
  [void]$R.Add("  * R = distanza fra prezzo di apertura e STOP INIZIALE (2,5 x ATR M15 su")
  [void]$R.Add("    questa sedia): la stessa unita' con cui il sorgente calcola TP1/TP2/TPfinal.")
  [void]$R.Add("  * mfe_R e' misurato TICK PER TICK dal contatore dentro l'EA di misura, sui")
  [void]$R.Add("    tick del modello 4. E' la misura migliore disponibile, ma resta una misura")
  [void]$R.Add("    del BANCO: fill ideali, spread corrente, nessuno slippage.")
  [void]$R.Add("  * mfe_R puo' essere NEGATIVO: vuol dire che il prezzo non e' MAI andato a")
  [void]$R.Add("    favore nemmeno di un tick. Non si azzera, o si perderebbe quel fatto.")
  [void]$R.Add("  * tp1_toccato e' il FLAG INTERNO VERO dell'EA (gPart1). >>> E HA UN LIMITE,")
  [void]$R.Add("    DICHIARATO: nel sorgente vivo gPart1 diventa true SOLO SE LA PARZIALE E'")
  [void]$R.Add("    STATA ESEGUITA DAVVERO ('if(parzOK) gPart1=true;'). Al lotto minimo la")
  [void]$R.Add("    parziale arrotonda a zero, non parte, e il flag resta false ANCHE SE il")
  [void]$R.Add("    prezzo aveva toccato 1R. Per questo accanto c'e' SEMPRE la lettura")
  [void]$R.Add("    GEOMETRICA (tp1_geom_1R = mfe_R >= 1R sulla R INIZIALE). Se le due")
  [void]$R.Add("    percentuali divergono molto, la differenza E' un risultato: vuol dire che")
  [void]$R.Add("    il 1R 'contabile' dell'EA e quello geometrico non sono la stessa cosa --")
  [void]$R.Add("    e non lo sono, perche' ManagePos ricalcola R dallo stop CORRENTE, che il")
  [void]$R.Add("    trailing puo' aver gia' spostato.")
  [void]$R.Add("")
  if($SoloControllo){
    [void]$R.Add("--- QUESTO E' UN GIRO A VUOTO ---")
    [void]$R.Add("  -SoloControllo NON apre MT5: NON esiste nessun n, nessun istogramma,")
    [void]$R.Add("  nessuna percentuale, nessuna risposta alla domanda. Puo' confermare solo")
    [void]$R.Add("  gli ARTEFATTI: file prova, sorgente al pin, .ini scritto e verificato.")
    [void]$R.Add("  QUESTO ZIP NON E' IL ROUND e non va mandato come risultato.")
  }
  elseif(-not $Ris.CsvTrovato){
    [void]$R.Add("--- NESSUN NUMERO ---")
    [void]$R.Add("  Il CSV " + $CsvMfe + " non e' stato letto. Nessuna percentuale, nessun")
    [void]$R.Add("  istogramma: non si inventa niente. Il perche' e' nei PROBLEMI qui sotto.")
  }
  else{
    [void]$R.Add("--- IL CAMPIONE ---")
    [void]$R.Add("  operazioni chiuse (righe del CSV) ....  " + $Ris.N)
    [void]$R.Add("  cancello G1 (n >= " + $SogliaG1 + ") ...............  " + $(if($Ris.Misurabile){ "PASSATO" } else { "NON PASSATO -> le percentuali sono NON MISURABILI" }))
    [void]$R.Add("  righe senza mfe_R leggibile ..........  " + $Ris.NSenzaMfe)
    [void]$R.Add("  righe senza realizzato_R leggibile ...  " + $Ris.NSenzaReal)
    [void]$R.Add("  CONTROLLO D'IGIENE ...................  " + $Ris.IgieneStato)
    [void]$R.Add("")
    [void]$R.Add("--- L'ISTOGRAMMA DI mfe_R (il massimo profitto flottante, in R) ---")
    foreach($k in $Ris.Buckets.Keys){
      $c = [int]$Ris.Buckets[$k]
      $q = "n/d"
      if($Ris.N -gt 0){ $q = ([math]::Round(100.0*$c/$Ris.N,1)).ToString("0.0",$INV) + "%" }
      $barra = ""
      if($c -gt 0){ $barra = ("#" * [math]::Min(50,$c)) }
      [void]$R.Add(("  {0,-10} {1,5}  {2,7}  {3}" -f $k,$c,$q,$barra))
    }
    [void]$R.Add("  (intervalli chiusi a sinistra e aperti a destra: 0.5-0.8R vuol dire")
    [void]$R.Add("   0.5 <= mfe_R < 0.8. Il secchio >=1R e' quello che HA toccato il 1o")
    [void]$R.Add("   obiettivo dal punto di vista GEOMETRICO.)")
    [void]$R.Add("")
    [void]$R.Add("--- LA RISPOSTA ALLA DOMANDA ---")
    [void]$R.Add("  operazioni con mfe_R >= 0,5R ..................  " + $Ris.NMfe05)
    [void]$R.Add("  di queste, con tp1_toccato = 0 ................  " + $Ris.NMfe05NoTp1)
    [void]$R.Add("  % SU TUTTE le operazioni ......................  " + (Pct $Ris.PctSuTot))
    [void]$R.Add("       (mfe_R >= 0,5R E tp1_toccato = 0, su n = " + $Ris.N + ")")
    [void]$R.Add("  % SULLE SOLE operazioni arrivate a 0,5R .......  " + (Pct $Ris.PctSuMfe05))
    [void]$R.Add("       (denominatore " + $Ris.NMfe05 + ", non " + $Ris.N + ": e' un'ALTRA frazione, si legge")
    [void]$R.Add("        accanto alla prima e mai al posto suo)")
    [void]$R.Add("  la stessa cosa con la lettura GEOMETRICA ......  " + (Pct $Ris.PctGeomSuTot))
    [void]$R.Add("       (mfe_R >= 0,5R E tp1_geom_1R = 0, su n = " + $Ris.N + " -- vedi il limite di gPart1)")
    [void]$R.Add("")
    [void]$R.Add("  QUANTO VIENE RESTITUITO su quel sottoinsieme:")
    [void]$R.Add("    media di (mfe_R - realizzato_R) .............  " + $(if($Ris.MediaRestit -ge 0){ (Fmt $Ris.MediaRestit 3) + " R" } else { "NON MISURATA" }))
    [void]$R.Add("    calcolata su ................................  " + $Ris.NMediaRestit + " operazioni delle " + $Ris.NMfe05NoTp1 + " del sottoinsieme")
    [void]$R.Add("    (le altre non avevano un realizzato_R leggibile e sono state ESCLUSE,")
    [void]$R.Add("     non contate come zero)")
    [void]$R.Add("")
    [void]$R.Add("--- IL TETTO TEORICO (criteri par. 6) ---")
    [void]$R.Add("  somma dei realizzato_R ........................  " + (Fmt $Ris.SommaReal 2) + " R")
    [void]$R.Add("  somma se OGNI mfe_R >= 1R fosse incassato a 1R   " + (Fmt $Ris.SommaTetto 2) + " R")
    [void]$R.Add("  operazioni che hanno toccato 1R ...............  " + $Ris.NMfe1R)
    [void]$R.Add("  >>> IL SECONDO NUMERO E' UN LIMITE SUPERIORE IRREALIZZABILE, MAI UN")
    [void]$R.Add("      OBIETTIVO OPERATIVO. Nessuno sa in anticipo quale operazione")
    [void]$R.Add("      tocchera' 1R, e incassare sempre a 1R spegnerebbe anche quelle che")
    [void]$R.Add("      poi sono andate a 3R o a 4R. Serve solo a dare la SCALA di cio' di")
    [void]$R.Add("      cui si sta parlando.")
  }
  [void]$R.Add("")
  [void]$R.Add("--- QUELLO CHE QUESTO ROUND NON DICE, DICHIARATO ---")
  [void]$R.Add("  * NON promuove e NON boccia niente, e NON cambia una virgola del forward.")
  [void]$R.Add("    E' informazione su un meccanismo gia' in campo (criteri par. 5).")
  [void]$R.Add("  * NON propone nessuna soglia diversa e NON tocca il trailing. Se questi")
  [void]$R.Add("    numeri suggeriscono un aggiustamento, quella conversazione e' SUCCESSIVA")
  [void]$R.Add("    e SEPARATA, con firma propria (criteri par. 7).")
  [void]$R.Add("  * NON e' un walk-forward e NON e' un'ottimizzazione: UNA passata, i")
  [void]$R.Add("    parametri vivi esatti, zero assi spazzolati.")
  [void]$R.Add("  * UNA SOLA FINESTRA e UN SOLO REGIME (21 mesi di indici): il numero che")
  [void]$R.Add("    esce descrive QUESTA epoca, non la sedia in eterno.")
  [void]$R.Add("  * NON c'e' il controllo delle due passate gemelle (girerebbero sullo")
  [void]$R.Add("    stesso file comune e la seconda cancellerebbe la prima). Al suo posto")
  [void]$R.Add("    c'e' il confronto col conteggio dello storico dei deal, qui sopra.")
  [void]$R.Add("")
  if($Note.Count -gt 0){
    [void]$R.Add("--- NOTE (non sono guasti: sono risultati o limiti dichiarati) ---")
    foreach($n in $Note){ [void]$R.Add("  - " + $n) }
    [void]$R.Add("")
  }
  [void]$R.Add("--- PROBLEMI ---   (" + $Problemi.Count + ")")
  if($Problemi.Count -eq 0){ [void]$R.Add("  nessuno.") }
  foreach($p in $Problemi){ [void]$R.Add("  - " + $p) }
  if($Fatale -ne ""){
    [void]$R.Add("")
    [void]$R.Add("--- FERMATO ---")
    [void]$R.Add("  " + $Fatale)
  }
  [void]$R.Add("")
  [void]$R.Add("--- COSA C'E' IN QUESTO ZIP ---")
  foreach($f in @(Get-ChildItem -LiteralPath $Cart -File -ErrorAction SilentlyContinue | Sort-Object Name)){
    [void]$R.Add(("  {0,-42} {1,10} byte   {2}" -f $f.Name,$f.Length,$f.LastWriteTime.ToString("yyyy-MM-dd HH:mm",$INV)))
  }
  [void]$R.Add("")
  if($SoloControllo){
    [void]$R.Add("ESITO: GIRO A VUOTO -- NESSUNA passata, NESSUN numero. QUESTO ZIP NON E' IL ROUND.")
  } elseif($Fatale -ne ""){
    [void]$R.Add("ESITO: FERMATO -- " + $Fatale)
  } elseif($Problemi.Count -gt 0){
    [void]$R.Add("ESITO: COMPLETO CON RILIEVI -- i " + $Problemi.Count + " rilievi si leggono ACCANTO ai numeri.")
  } elseif(-not $Ris.Misurabile){
    [void]$R.Add("ESITO: NON MISURABILE -- la corsa e' RIUSCITA, il campione e' troppo piccolo (n = " + $Ris.N + " < " + $SogliaG1 + "). E' una risposta, non un guasto: lo zip va mandato lo stesso.")
  } else {
    [void]$R.Add("ESITO: OK")
  }
  Set-Content -LiteralPath $Referto -Value $R -Encoding ASCII

  Remove-Item -LiteralPath $Zip -Force -ErrorAction SilentlyContinue
  Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $Zip -Force
}catch{
  Write-Host ("!! raccolta incompleta: " + $_.Exception.Message) -ForegroundColor Red
}

# =====================================================================
#  9. COSA DEVE VEDERE CLAUDIO SULLO SCHERMO
# =====================================================================
Write-Host ""
Write-Host "=====================================================================" -ForegroundColor White
Write-Host "  R104 - FINE. File da verificare, uno per uno:" -ForegroundColor White
#  >>> NON SI ANNUNCIA UN ARTEFATTO CHE NON ESISTE (checklist 22).
function Riga3($path,$coda){
  if(Test-Path -LiteralPath $path){ Write-Host ("   " + $path + "   " + $coda) -ForegroundColor White }
  else                            { Write-Host ("   " + $path + "   <<< NON ESISTE") -ForegroundColor Red }
}
Riga3 $Cart    ""
Riga3 $Zip     "<- e' questo che mi mandi"
Riga3 $Referto "<- la riga 'data:' deve essere di ADESSO, la riga 'modo:' dice se e' il round o un giro a vuoto"
Write-Host "=====================================================================" -ForegroundColor White
if($SoloControllo){
  Write-Host ("  MODO: " + $Modo + " -- GIRO A VUOTO. NESSUNA passata, NESSUN numero.") -ForegroundColor Yellow
  Write-Host  "        QUESTO ZIP NON E' IL ROUND." -ForegroundColor Yellow
} elseif($Ris.CsvTrovato){
  Write-Host ("  n operazioni ............ " + $Ris.N) -ForegroundColor White
  foreach($k in $Ris.Buckets.Keys){ Write-Host ("   mfe_R " + $k.PadRight(10) + " " + $Ris.Buckets[$k]) -ForegroundColor Gray }
  if($Ris.Misurabile){
    Write-Host ("  mfe_R >= 0,5R E TP1 mai toccato: " + (Pct $Ris.PctSuTot) + " di tutte  |  " + (Pct $Ris.PctSuMfe05) + " di quelle arrivate a 0,5R") -ForegroundColor White
    Write-Host ("  media restituita su quel sottoinsieme: " + $(if($Ris.MediaRestit -ge 0){ (Fmt $Ris.MediaRestit 3) + " R" } else { "NON MISURATA" })) -ForegroundColor White
  } else {
    Write-Host ("  NON MISURABILE: n = " + $Ris.N + " < " + $SogliaG1 + " (cancello G1). E' una risposta, non un guasto.") -ForegroundColor Yellow
  }
  Write-Host ("  igiene .................. " + $Ris.IgieneStato) -ForegroundColor White
}
if($Problemi.Count -gt 0){
  Write-Host ""
  Write-Host "   PROBLEMI DA LEGGERE:" -ForegroundColor Red
  foreach($p in $Problemi){ Write-Host ("    - " + $p) -ForegroundColor Red }
}
Write-Host ""
# =====================================================================
#  L'ESITO IN CONSOLE DICE LE STESSE PAROLE DEL REFERTO, o i due si
#  contraddicono. E OGNI RAMO FINISCE CON UN exit ESPLICITO: senza, il
#  codice d'uscita e' quello dell'ULTIMO comando nativo eseguito (qui
#  metaeditor64, il cui rc NON e' il verdetto della compilazione) e il
#  blocco che si incolla in chat annuncerebbe "PARZIALE O FERMO" su un
#  round andato bene.
#  CODICI: 0 = OK (round completo, o giro a vuoto pulito, o campione
#  troppo piccolo -- che e' una RISPOSTA) | 1 = fermato o con rilievi.
# =====================================================================
if($Fatale -ne ""){ Write-Host ("ESITO: FERMATO -- " + $Fatale) -ForegroundColor Red; exit 1 }
if($SoloControllo){
  if($Problemi.Count -gt 0){
    Write-Host ("ESITO: GIRO A VUOTO CON PROBLEMI (" + $Problemi.Count + ") -- NON lanciare la corsa vera prima di averli letti") -ForegroundColor Yellow
    exit 1
  }
  Write-Host "ESITO: GIRO A VUOTO COMPLETATO -- NESSUNA passata, NESSUN numero. QUESTO ZIP NON E' IL ROUND." -ForegroundColor Green
  exit 0
}
if($Problemi.Count -gt 0){
  Write-Host ("ESITO: COMPLETO CON RILIEVI (" + $Problemi.Count + ") -- lo zip esiste: mandalo, e leggi il referto") -ForegroundColor Yellow
  exit 1
}
if(-not $Ris.Misurabile){
  #  >>> NON e' un fallimento: e' il cancello G1 che ha risposto. Un
  #      codice rosso qui manderebbe Claudio a rilanciare a vuoto una
  #      corsa perfettamente riuscita (checklist 26-bis).
  Write-Host ("ESITO: NON MISURABILE (n = " + $Ris.N + " < " + $SogliaG1 + ") -- la corsa e' RIUSCITA: manda lo zip lo stesso") -ForegroundColor Green
  exit 0
}
Write-Host "ESITO: OK" -ForegroundColor Green
exit 0
