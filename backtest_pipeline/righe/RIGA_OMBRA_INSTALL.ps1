# =====================================================================
#  MARCATORE_RIGA_OMBRA_INSTALL_v1
#  RIGA_OMBRA_INSTALL.ps1 -- COPIA UN FILE, e basta: ABTG_EMA200_Ombra.mq5
#  (v1.03, commit 81b4329f) in MQL5\Experts del terminale PICCOLO, conto
#  50503392, sul VPS VMI3047753. Decisione di Claudio del 05/10/2026
#  (contro il consiglio dell'agente di usare il 100k 50504263).
# ---------------------------------------------------------------------
#  BERSAGLIO: SOLO una finestra PowerShell sul VPS VMI3047753. Se il nome
#  macchina e' un altro la riga si ferma PRIMA di leggere o scaricare
#  qualunque cosa (sul PC di backtest DESKTOP-H4D7CAJ esiste un terminale
#  con lo STESSO numero di conto 50503392 e lo stesso percorso programma:
#  li' questa riga NON gira).
#  Il terminale e': C:\Program Files\BCM Markets MT5 Terminal, conto
#  50503392, riconosciuto per FATTI (origin.txt + giornale + giornali
#  freschi), mai per nome di cartella.
#  NON TOCCATI, per nome: REALE 10105439 (C:\BCM_Reale), FTMO trial
#  1514806751 (C:\FTMO), 100k 50504263 (BCM Markets MT5 Terminal -V3),
#  manuale 50503635 (C:\MT5_MANUALE), banco 50504400 (C:\MT5_Backtest),
#  Pepperstone, Tickmill, e il PC di backtest DESKTOP-H4D7CAJ.
# ---------------------------------------------------------------------
#  COSA FA, in ordine:
#   1. guardia macchina (throw se COMPUTERNAME != VMI3047753);
#   2. SOLA LETTURA: tabella dei terminal64 in esecuzione (PID, titolo,
#      cartella: il riconoscimento e' un fatto stampato, non un'inferenza),
#      RAM libera del VPS, RAM e CPU del terminal64 del piccolo ("prima");
#   3. SOLA LETTURA: trova la cartella dati del piccolo (origin.txt in
#      %APPDATA%\MetaQuotes\Terminal\<hash>\ di OGNI profilo utente) e la
#      conferma dal GIORNALE (ultimo login = 50503392, giornali freschi
#      entro 72 ore = e' il terminale VIVO e non una copia morta). Se le
#      candidate sono zero o piu' di una, o il conto non si legge: STOP,
#      NIENTE scritto;
#   4. scarica il .mq5 dal commit pinnato (SHA256 + versione + nessuna
#      chiamata di trading nel codice) e lo scrive in <dati>\MQL5\Experts\
#      con CreateNew (mai sovrascrive). Se esiste gia' uguale: lo dice e non
#      riscrive. Se esiste DIVERSO (o e' una cartella): STOP, non scrive,
#      non fa copie con altro nome: decide Claudio;
#   5. sola lettura: sedie del profilo attivo (da .chr), soglie di allarme
#      calcolate sui numeri di partenza;
#   6. referto + zip sul Desktop: ABTG_OMBRA_INSTALL_<ora>.txt/.zip
#  NON COMPILA (niente .ex5), NON ATTACCA l'EA, NON apre/chiude/riavvia
#  nessun programma, NON tocca grafici, profili, .chr, preset, EA esistenti,
#  Guardian, config. Scrive nel terminale UN SOLO file (il .mq5) e sul
#  Desktop il referto e lo zip.
# ---------------------------------------------------------------------
#  PERCHE' NON SERVE MT5 CHIUSO (checklist punto 7): la regola vale per i
#  file che MT5 RISCRIVE all'uscita (.chr, config). Un .mq5 nuovo in
#  MQL5\Experts non e' uno di quelli. Se MetaEditor e' aperto il suo
#  Navigatore non vede il file nuovo (punto 27-bis): si dice nel referto.
#  PERCHE' LA FRESCHEZZA NON E' "OGGI" (checklist punto 29): e' l'eta'
#  dell'ultimo giornale rispetto ad ADESSO, perche' misura se il terminale
#  e' vivo adesso.
#  LIMITI DICHIARATI: Windows PowerShell 5.1 e un Windows vero non sono
#  provati dal banco (Get-Process .Path puo' essere negato; Get-CimInstance;
#  Compress-Archive); il numero di sedie viene dai .chr salvati e puo' essere
#  vecchio; un profilo utente non leggibile e' un rilievo, non un blocco.
#  NIENTE `exit` (la riga gira con Invoke-Expression nella console di
#  Claudio), NIENTE param(): pin e impronta arrivano dal bootstrap nelle
#  variabili OMBRA_PIN e OMBRA_SHA, se ci sono.
#  ASCII PURO (Windows PowerShell 5.1 legge i .ps1 come ANSI).
# =====================================================================
$ErrorActionPreference = 'Stop'
if($env:COMPUTERNAME -ne 'VMI3047753'){
  throw ('QUESTA RIGA GIRA SOLO SUL VPS VMI3047753. Qui la macchina si chiama: ' + $env:COMPUTERNAME + '. Sul PC di backtest DESKTOP-H4D7CAJ esiste un terminale con lo STESSO conto 50503392: li non si lancia mai. Non ho letto, scaricato o scritto niente.')
}
$INV = [Globalization.CultureInfo]::InvariantCulture

# --- il bersaglio e l'artefatto: costanti, scritte UNA volta
$TermBcm   = 'C:\Program Files\BCM Markets MT5 Terminal'
$ContoAtt  = '50503392'
$EaPin     = '81b4329fbc33af87957d89198a2a4af127693ecc'
$EaSha     = 'FD7AACD694E3CE9E7D4F95C7A4C9881464A89B376AE1919B0A05C5241E0596F4'
$EaRel     = 'mql5/Experts/ABTG_EMA200_Ombra.mq5'
$EaNome    = 'ABTG_EMA200_Ombra.mq5'
$EaVer     = '1.03'
$RawBase   = 'https://raw.githubusercontent.com/claudiospadaro12/GITHUB/'
$EtaMaxOre = 72
$PatTrading = 'OrderSend|CTrade|Trade\.mqh|#include|Position(Open|Close|Modify|Select)|Order(Delete|Modify|Select)|OrdersTotal|PositionsTotal|HistorySelect|(Buy|Sell)(Limit|Stop)|GlobalVariable|Guardia|[Mm]agic|WebRequest|SendNotification|SendMail|ObjectCreate|ChartSetSymbolPeriod'
$RxLogin   = "'(\d{6,12})'\s*:\s*(?:login|authorized|connesso|previous)[^\r\n]*"
$CampioneSec = 5

$T0    = Get-Date
$Stamp = $T0.ToString('yyyyMMdd_HHmmss', $INV)
$Dsk   = Join-Path $env:USERPROFILE 'Desktop'
if(-not (Test-Path -LiteralPath $Dsk)){ $Dsk = $env:USERPROFILE }
$PinRiga = 'non dichiarato (script lanciato senza bootstrap)'
$ShaRiga = 'non dichiarata'
if($null -ne (Get-Variable -Name OMBRA_PIN -ErrorAction SilentlyContinue)){ $PinRiga = '' + $OMBRA_PIN }
if($null -ne (Get-Variable -Name OMBRA_SHA -ErrorAction SilentlyContinue)){ $ShaRiga = '' + $OMBRA_SHA }

# --- tutto quello che la RACCOLTA usa nasce QUI, prima di ogni try (classi 125 / 1117)
$R         = New-Object System.Collections.ArrayList     # il referto
$Pri       = New-Object System.Collections.ArrayList     # i numeri di partenza
$Problemi  = New-Object System.Collections.ArrayList
$Rilievi   = New-Object System.Collections.ArrayList
$Fatale    = ''
$Esito     = ''
$Scelta    = $null
$Cand      = New-Object System.Collections.ArrayList
$Illeggibili = New-Object System.Collections.ArrayList
$ExpDir    = ''
$Dest      = ''
$destNative = ''
$Creato    = $false
$Installato = $false
$GiaUguale = $false
$Rimosso   = $false
$Bytes     = $null
$HScaricato = ''
$NostriN   = 0
$WsNostro  = $null
$PmNostro  = $null
$CpuPct    = $null
$LiberaMB  = $null
$TotaleMB  = $null
$Sedie     = $null
$SedieNota = ''
$RefTxt    = ''
$PriTxt    = ''
$Zip       = ''
$ZipOk     = $false
$ZipPresenti = ''
$ZipMancanti = ''

function Pulisci([string]$t){ if($null -eq $t){ return '' }; return ($t -replace '[^\x20-\x7E]', '?') }
function Dico([string]$t, [string]$c = 'Gray'){ $p = Pulisci $t; [void]$R.Add($p); Write-Host $p -ForegroundColor $c }
function DicoP([string]$t, [string]$c = 'Gray'){ $p = Pulisci $t; [void]$R.Add($p); [void]$Pri.Add($p); Write-Host $p -ForegroundColor $c }
function Titolo([string]$t){ Dico ''; Dico ('=== ' + $t + ' ===') 'Cyan' }
function MbDa([double]$b){ return ([math]::Round($b / 1MB, 0)).ToString('0', $INV) }
function Norm([string]$p){ if($null -eq $p){ return '' }; return (($p -replace '/', '\').TrimEnd('\')).ToLower() }
# identita' di una cartella: il percorso RISOLTO (due scritture diverse della stessa cartella non devono contare due volte)
function Chiave([string]$p){ try{ return (Norm (Convert-Path -LiteralPath $p)) }catch{ return (Norm $p) } }
function Sha256Di([byte[]]$b){ $s = [Security.Cryptography.SHA256]::Create(); return [BitConverter]::ToString($s.ComputeHash($b)).Replace('-', '') }

# lettura CONDIVISA con riconoscimento UTF-16 (origin.txt, log, ini di MT5); il BOM si TOGLIE (classe 1110)
function Leggi-Condiviso($path){
  $b = $null
  try{
    $path = (Convert-Path -LiteralPath $path)
    $fs = [IO.File]::Open($path, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
    $b  = New-Object byte[] $fs.Length
    [void]$fs.Read($b, 0, $b.Length)
    $fs.Close()
  } catch { return '' }
  if($null -eq $b -or $b.Count -lt 2){ return '' }
  if($b[0] -eq 0xFF -and $b[1] -eq 0xFE){ return ([Text.Encoding]::Unicode.GetString($b)).TrimStart([char]0xFEFF) }
  $zeri = 0; $n = [math]::Min(400, $b.Count)
  for($i = 1; $i -lt $n; $i += 2){ if($b[$i] -eq 0){ $zeri++ } }
  if($zeri -gt ($n / 4)){ return ([Text.Encoding]::Unicode.GetString($b)).TrimStart([char]0xFEFF) }
  return ([Text.Encoding]::UTF8.GetString($b)).TrimStart([char]0xFEFF)
}

# i byte di un file, in lettura condivisa (con MT5 aperto la lettura condivisa riesce dove Copy-Item puo' fallire)
function Leggi-Bytes($path){
  $path = (Convert-Path -LiteralPath $path)
  $fs = [IO.File]::Open($path, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
  try{ $b = New-Object byte[] $fs.Length; [void]$fs.Read($b, 0, $b.Length) } finally { $fs.Close() }
  return ,$b
}

# giornali di una cartella dati: ultimo login letto, tutti i conti visti, eta' dell'ultimo giornale
function Scansiona-Giornali([string]$dati, [datetime]$adesso){
  $o = @{ Conti = @{}; Ultimo = ''; File = ''; NFile = 0; Eta = $null; Note = '' }
  $limite = $adesso.AddDays(-90)
  $dl = Join-Path $dati 'logs'
  if(Test-Path -LiteralPath $dl){
    $fl = @(Get-ChildItem -LiteralPath $dl -Filter '*.log' -File -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -ge $limite -and $_.Length -lt 60000000 } | Sort-Object LastWriteTime -Descending | Select-Object -First 60)
    $o.NFile = $fl.Count
    foreach($f in $fl){
      $t = Leggi-Condiviso $f.FullName
      if(-not $t){ continue }
      $mm = [regex]::Matches($t, $RxLogin)
      foreach($m in $mm){ $o.Conti[$m.Groups[1].Value] = 1 }
      if($o.Ultimo -eq '' -and $mm.Count -gt 0){ $o.Ultimo = $mm[$mm.Count - 1].Groups[1].Value; $o.File = $f.Name }
    }
  } else { $o.Note = 'logs\ assente' }
  $nuovo = $null
  foreach($sub in @('logs', 'MQL5\Logs')){
    $dd = Join-Path $dati $sub
    if(-not (Test-Path -LiteralPath $dd)){ continue }
    foreach($f in @(Get-ChildItem -LiteralPath $dd -Filter '*.log' -File -ErrorAction SilentlyContinue)){
      if($null -eq $nuovo -or $f.LastWriteTime -gt $nuovo){ $nuovo = $f.LastWriteTime }
    }
  }
  if($null -ne $nuovo){ $o.Eta = [math]::Round(($adesso - $nuovo).TotalHours, 1) }
  return $o
}

Write-Host ''
Dico 'ABTG OMBRA -- INSTALLAZIONE DI UN FILE (sola copia, NON compila, NON attacca)'
Dico ('BERSAGLIO: VPS VMI3047753, terminale piccolo conto ' + $ContoAtt + ' (' + $TermBcm + '), file ' + $EaNome + ' v' + $EaVer + ', commit ' + $EaPin.Substring(0, 8) + '.') 'Yellow'
Dico 'NON TOCCATI: REALE 10105439 (C:\BCM_Reale), FTMO 1514806751 (C:\FTMO), 100k 50504263 (BCM Markets MT5 Terminal -V3), manuale 50503635 (C:\MT5_MANUALE), banco 50504400 (C:\MT5_Backtest), Pepperstone, Tickmill, PC di backtest DESKTOP-H4D7CAJ.' 'Yellow'
Titolo '0. LA RIGA'
Dico ('macchina ........ ' + $env:COMPUTERNAME + '   (ammessa: VMI3047753)')
Dico ('utente .......... ' + $env:USERNAME + '   APPDATA ' + $env:APPDATA)
Dico ('ora locale ...... ' + $T0.ToString('yyyy-MM-dd HH:mm:ss', $INV) + '   (i giornali di MT5 sono in ora locale, il grafico in ora server)')
Dico ('pin riga ........ ' + $PinRiga)
Dico ('sha256 riga ..... ' + $ShaRiga)
Dico ('pin file EA ..... ' + $EaPin)
Dico ('sha256 file EA .. ' + $EaSha + '   (atteso)')

# =====================================================================
Titolo '1. TERMINALI IN ESECUZIONE, RAM E CPU (sola lettura: il riconoscimento e un FATTO stampato)'
try{
  $procs = @(Get-Process -Name terminal64 -ErrorAction SilentlyContinue)
  DicoP ('terminal64 in esecuzione: ' + $procs.Count + '   (stringa equivalente: Get-Process terminal64 | select Id, MainWindowTitle, Path)')
  $nostri = New-Object System.Collections.ArrayList
  foreach($p in $procs){
    $path = '?'; try{ if($p.Path){ $path = [string]$p.Path } }catch{}
    $cart = '?'; if($path.LastIndexOf('\') -gt 0){ $cart = $path.Substring(0, $path.LastIndexOf('\')) }
    $tit = ''; try{ $tit = [string]$p.MainWindowTitle }catch{}
    $ws = 'NON LETTO'; try{ $ws = (MbDa $p.WorkingSet64) + ' MB' }catch{}
    $pm = 'NON LETTO'; try{ $pm = (MbDa $p.PrivateMemorySize64) + ' MB' }catch{}
    $mio = ((Norm $cart) -eq (Norm $TermBcm))
    $marca = ''; if($mio){ $marca = '   <== IL NOSTRO (piccolo, conto ' + $ContoAtt + ')'; [void]$nostri.Add($p) }
    DicoP ('   PID ' + $p.Id + '  | titolo: ' + $tit + '  | cartella: ' + $cart + '  | working set ' + $ws + '  | memoria privata ' + $pm + $marca)
  }
  $NostriN = $nostri.Count
  DicoP ('terminal64 con la cartella del piccolo (confronto sulla cartella INTERA, non sul prefisso): ' + $NostriN)
  if($NostriN -eq 0){ [void]$Rilievi.Add('nessun terminal64 col percorso del piccolo (spento, oppure Path illeggibile da questa sessione): RAM e CPU del terminale NON MISURATE.') }
  if($NostriN -gt 1){ [void]$Rilievi.Add('PIU di un terminal64 col percorso del piccolo: due istanze? Riconoscere a mano quale.') }
  $me = @(Get-Process -Name metaeditor64 -ErrorAction SilentlyContinue)
  Dico ('metaeditor64 in esecuzione: ' + $me.Count + '   (se MetaEditor e aperto il suo Navigatore NON vede il file nuovo: tasto destro su Experts -> Aggiorna, oppure chiuderlo e riaprirlo)')
  if($NostriN -ge 1){
    $p0 = $nostri[0]
    try{ $WsNostro = [double]$p0.WorkingSet64 / 1MB }catch{}
    try{ $PmNostro = [double]$p0.PrivateMemorySize64 / 1MB }catch{}
    $c0 = $null; try{ $c0 = [double]$p0.CPU }catch{}
    Start-Sleep -Seconds $CampioneSec
    $p1 = $null; try{ $p1 = Get-Process -Id $p0.Id -ErrorAction Stop }catch{}
    $c1 = $null; if($null -ne $p1){ try{ $c1 = [double]$p1.CPU }catch{} }
    if($null -ne $c0 -and $null -ne $c1){ $CpuPct = [math]::Round(($c1 - $c0) / $CampioneSec * 100, 1) }
  }
}
catch{ [void]$Problemi.Add('processi: ' + (Pulisci ('' + $_.Exception.Message))); Dico ('  !!! passo processi FALLITO: ' + (Pulisci ('' + $_.Exception.Message)) + '  -> NON MISURATO') 'Red' }
try{
  $os = @(Get-CimInstance Win32_OperatingSystem -ErrorAction Stop)[0]
  $LiberaMB = [math]::Round([double]$os.FreePhysicalMemory / 1024, 0)
  $TotaleMB = [math]::Round([double]$os.TotalVisibleMemorySize / 1024, 0)
}
catch{ [void]$Problemi.Add('ram: ' + (Pulisci ('' + $_.Exception.Message))) }
$nCore = 0; [void][int]::TryParse(('' + $env:NUMBER_OF_PROCESSORS), [Globalization.NumberStyles]::Integer, $INV, [ref]$nCore)
DicoP ('RAM del VPS: ' + $(if($null -ne $TotaleMB){ 'totale ' + $TotaleMB.ToString('0', $INV) + ' MB, libera ' + $LiberaMB.ToString('0', $INV) + ' MB [MISURATO]' }else{ 'NON MISURATO (Get-CimInstance Win32_OperatingSystem non ha risposto)' }))
DicoP ('terminal64 del piccolo, working set: ' + $(if($null -ne $WsNostro){ ([math]::Round($WsNostro, 0)).ToString('0', $INV) + ' MB [MISURATO]' }else{ 'NON MISURATO' }) + '   memoria privata: ' + $(if($null -ne $PmNostro){ ([math]::Round($PmNostro, 0)).ToString('0', $INV) + ' MB [MISURATO]' }else{ 'NON MISURATO' }))
DicoP ('terminal64 del piccolo, CPU media su ' + $CampioneSec + ' secondi: ' + $(if($null -ne $CpuPct){ $CpuPct.ToString('0.0', $INV) + ' % di UN core' + $(if($nCore -gt 0){ ' = ' + ([math]::Round($CpuPct / $nCore, 1)).ToString('0.0', $INV) + ' % su ' + $nCore + ' core (come la Gestione attivita)' }else{ ' (numero di core NON noto)' }) + ' [MISURATO, campione breve]' }else{ 'NON MISURATO' }))

# =====================================================================
Titolo '2. CARTELLA DATI DEL PICCOLO (sola lettura): origin.txt + giornale + freschezza'
try{
  $Drive = $env:SystemDrive; if(-not $Drive){ $Drive = 'C:' }
  $radici = New-Object System.Collections.ArrayList
  $rApp = Join-Path $env:APPDATA 'MetaQuotes\Terminal'
  try{
    foreach($u in @(Get-ChildItem -LiteralPath ($Drive + '\Users') -Directory -ErrorAction Stop)){
      [void]$radici.Add(@{ Root = (Join-Path $u.FullName 'AppData\Roaming\MetaQuotes\Terminal'); Utente = $u.Name })
    }
  }catch{ [void]$Rilievi.Add('elenco dei profili utente (' + $Drive + '\Users) NON leggibile: vedo solo il profilo di questa sessione.') }
  $giaApp = $false
  foreach($x in $radici){ if((Chiave $x.Root) -eq (Chiave $rApp)){ $giaApp = $true } }
  if(-not $giaApp){ [void]$radici.Add(@{ Root = $rApp; Utente = ('APPDATA di ' + $env:USERNAME) }) }
  $visti = @{}
  foreach($x in $radici){
    if(-not (Test-Path -LiteralPath $x.Root)){ continue }
    $dirs = @()
    try{ $dirs = @(Get-ChildItem -LiteralPath $x.Root -Directory -ErrorAction Stop) }
    catch{ [void]$Illeggibili.Add($x.Utente); [void]$Rilievi.Add('profilo ' + $x.Utente + ': ' + $x.Root + ' NON leggibile (' + (Pulisci ('' + $_.Exception.Message)) + '): se contenesse una seconda copia viva non l ho vista.'); continue }
    foreach($d in $dirs){
      if(@('Common', 'Community', 'Help') -contains $d.Name){ continue }
      if(-not (Test-Path -LiteralPath (Join-Path $d.FullName 'MQL5'))){ continue }
      $kd = Chiave $d.FullName
      if($visti.ContainsKey($kd)){ continue }
      $visti[$kd] = 1
      $o = ''
      $of = Join-Path $d.FullName 'origin.txt'
      if(Test-Path -LiteralPath $of){ $o = (Leggi-Condiviso $of).Trim() }
      $sess = ((Chiave $x.Root) -eq (Chiave $rApp))
      $c = @{ Cartella = $d.FullName; Nome = $d.Name; Utente = $x.Utente; Sessione = $sess; Origine = $o; Candidata = $false; Eleggibile = $false; Motivi = (New-Object System.Collections.ArrayList); Giorn = $null; IniLogin = '' }
      if((Norm $o) -eq (Norm $TermBcm)){ $c.Candidata = $true }
      [void]$Cand.Add($c)
      Dico ('   dati ' + $d.Name + '  profilo ' + $x.Utente + $(if($sess){ ' (SESSIONE CORRENTE)' }else{ '' }) + '  programma: ' + $(if($o){ (Pulisci $o) }else{ '(origin.txt assente)' }))
    }
  }
  $mie = @($Cand | Where-Object { $_.Candidata })
  Dico ('cartelle dati scandite: ' + $Cand.Count + '   con origin.txt = ' + $TermBcm + ' : ' + $mie.Count)
  foreach($c in $mie){
    $ex = Join-Path $c.Cartella 'MQL5\Experts'
    if(-not (Test-Path -LiteralPath $ex)){ [void]$c.Motivi.Add('manca MQL5\Experts') }
    $g = Scansiona-Giornali $c.Cartella $T0
    $c.Giorn = $g
    $ini = Join-Path $c.Cartella 'config\common.ini'
    if(Test-Path -LiteralPath $ini){
      $mL = [regex]::Match((Leggi-Condiviso $ini), '(?im)^[ \t]*Login[ \t]*=[ \t]*(\d{5,12})')
      if($mL.Success){ $c.IniLogin = $mL.Groups[1].Value }
    }
    if($g.Ultimo -eq ''){ [void]$c.Motivi.Add('conto NON trovato nei giornali (' + $(if($g.Note){ $g.Note }else{ $g.NFile.ToString($INV) + ' giornali letti, nessuna riga di login' }) + ')') }
    elseif($g.Ultimo -ne $ContoAtt){ [void]$c.Motivi.Add('l ULTIMO login nei giornali e ' + $g.Ultimo + ', non ' + $ContoAtt) }
    if($c.IniLogin -ne '' -and $c.IniLogin -ne $ContoAtt){ [void]$c.Motivi.Add('config\common.ini ha Login=' + $c.IniLogin + ', non ' + $ContoAtt + ' (conti discordanti)') }
    if($null -eq $g.Eta){ [void]$c.Motivi.Add('nessun giornale (logs\ o MQL5\Logs): non e un terminale vivo') }
    elseif($g.Eta -gt $EtaMaxOre){ [void]$c.Motivi.Add('giornali vecchi di ' + $g.Eta.ToString('0.0', $INV) + ' ore (soglia ' + $EtaMaxOre + '): non e il terminale VIVO, e una copia ferma') }
    if($c.Motivi.Count -eq 0){ $c.Eleggibile = $true }
    $cs = ''; foreach($k in ($g.Conti.Keys | Sort-Object)){ $cs = $cs + $k + ' ' }
    Dico ('   CANDIDATA ' + $c.Nome + ' (profilo ' + $c.Utente + '): ultimo login ' + $(if($g.Ultimo){ $g.Ultimo }else{ '-' }) + ' (giornale ' + $(if($g.File){ $g.File }else{ '-' }) + '); conti visti: ' + $(if($cs){ $cs.Trim() }else{ 'nessuno' }) + '; common.ini Login ' + $(if($c.IniLogin){ $c.IniLogin }else{ '-' }) + '; ultimo giornale di ' + $(if($null -ne $g.Eta){ $g.Eta.ToString('0.0', $INV) + ' ore fa' }else{ 'NESSUNO' }))
    if($c.Eleggibile){ Dico '      -> ELEGGIBILE: origin giusto, conto confermato dal giornale, giornali freschi' 'Green' }
    else { Dico ('      -> NON ELEGGIBILE (NON TOCCATA): ' + ($c.Motivi -join ' | ')) 'Yellow' }
  }
  $el = @($mie | Where-Object { $_.Eleggibile })
  if($mie.Count -eq 0){ $Fatale = 'nessuna cartella dati ha origin.txt = ' + $TermBcm + ': non so dove sta il piccolo, non scrivo niente' }
  elseif($el.Count -eq 0){ $Fatale = $mie.Count.ToString($INV) + ' cartelle con l origin del piccolo ma NESSUNA eleggibile (conto, freschezza o Experts: vedi sopra): non scrivo niente' }
  elseif($el.Count -gt 1){ $Fatale = 'DUE cartelle eleggibili (' + (($el | ForEach-Object { $_.Nome + ' ' + $_.Utente }) -join ' ; ') + '): ambiguo, non scrivo niente' }
  else {
    $Scelta = $el[0]
    Dico ('CARTELLA DATI SCELTA: ' + $Scelta.Cartella + '   (profilo ' + $Scelta.Utente + $(if($Scelta.Sessione){ ', e quello di questa sessione' }else{ ', NON e il profilo di questa sessione' }) + ')') 'Green'
    Dico ('   questo nome cartella (' + $Scelta.Nome + ') e quello che MT5 mostra con File > Apri cartella dati nel terminale 50503392: deve coincidere.')
    foreach($c in @($mie | Where-Object { -not $_.Eleggibile })){ [void]$Rilievi.Add('copia NON toccata: ' + $c.Cartella + ' (' + ($c.Motivi -join ' | ') + ')') }
    if(-not $Scelta.Sessione){ [void]$Rilievi.Add('la cartella scelta sta sotto un ALTRO profilo utente rispetto a questa sessione: e quella con i giornali freschi, ma controlla il nome cartella con File > Apri cartella dati.') }
  }
}
catch{ $Fatale = 'passo cartella dati MORTO: ' + (Pulisci ('' + $_.Exception.Message)) + ' (non scrivo niente)'; [void]$Problemi.Add($Fatale) }
if($Fatale -ne ''){ Dico ('STOP: ' + $Fatale) 'Red' }

# =====================================================================
if($Fatale -eq ''){
  Titolo '3. IL FILE: scarica al commit pinnato, controlla, scrivi con CreateNew'
  try{
    $url = $RawBase + $EaPin + '/' + $EaRel
    Dico ('scarico ' + $url)
    try{ [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 }catch{}
    $wc = New-Object Net.WebClient
    $Bytes = $wc.DownloadData($url)
    $HScaricato = Sha256Di $Bytes
    Dico ('scaricati ' + $Bytes.Length + ' byte; SHA256 ' + $HScaricato)
    if($HScaricato -ne $EaSha){ throw ('IMPRONTA DIVERSA: attesa ' + $EaSha + ', scaricata ' + $HScaricato + '. Non scrivo niente.') }
    # Latin1 e' una mappa 1:1 byte->carattere: ASCII.GetString trasformerebbe ogni byte oltre 127 in '?' e il controllo non vedrebbe MAI niente
    $txt = [Text.Encoding]::GetEncoding(28591).GetString($Bytes)
    if([regex]::IsMatch($txt, '[^\x09\x0A\x0D\x20-\x7E]')){ throw 'il file scaricato non e ASCII puro: non scrivo niente.' }
    if(-not [regex]::IsMatch($txt, ('(?m)^#property\s+version\s+"' + [regex]::Escape($EaVer) + '"'))){ throw ('manca #property version "' + $EaVer + '" nel file scaricato: non scrivo niente.') }
    if(-not [regex]::IsMatch($txt, ('(?m)^#define\s+OMBRA_VER\s+"' + [regex]::Escape($EaVer) + '"'))){ throw ('manca #define OMBRA_VER "' + $EaVer + '" nel file scaricato: non scrivo niente.') }
    $codice = (($txt -split "`n") | ForEach-Object { $_ -replace '//.*$', '' }) -join "`n"
    $nTr = [regex]::Matches($codice, $PatTrading).Count
    Dico ('chiamate di trading / include / magic / Guardian nel codice senza commenti: ' + $nTr + '   (deve essere 0, come la sez. 1.2 del documento dell EA)')
    if($nTr -ne 0){ throw ('il file contiene ' + $nTr + ' occorrenze di chiamate di trading o simili: NON e l ombra. Non scrivo niente.') }
    Dico ('verifiche del file: impronta OK, ASCII, versione ' + $EaVer + ', zero chiamate di trading.') 'Green'

    $ExpDir = Join-Path $Scelta.Cartella 'MQL5\Experts'
    $Dest   = Join-Path $ExpDir $EaNome
    Dico ('destinazione: ' + $Dest)
    if(Test-Path -LiteralPath $Dest){
      $it = Get-Item -LiteralPath $Dest -Force
      if($it.PSIsContainer){ throw ('in destinazione esiste una CARTELLA con il nome del file: non scrivo niente.') }
      $old = Leggi-Bytes $Dest
      $hOld = Sha256Di $old
      if($hOld -eq $EaSha){
        $GiaUguale = $true
        Dico ('il file e GIA PRESENTE ed e UGUALE (SHA256 ' + $hOld + ', ' + $it.Length + ' byte, modificato ' + $it.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss', $INV) + '): NON lo riscrivo.') 'Green'
      } else {
        $vv = ''; $mv = [regex]::Match([Text.Encoding]::ASCII.GetString($old), '(?m)^#property\s+version\s+"([^"]*)"'); if($mv.Success){ $vv = $mv.Groups[1].Value }
        throw ('in destinazione esiste GIA un file con quel nome ma DIVERSO (' + $it.Length + ' byte, SHA256 ' + $hOld + ', modificato ' + $it.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss', $INV) + ', versione dichiarata ' + $(if($vv){ $vv }else{ '?' }) + '). NON lo sovrascrivo e NON faccio copie con altro nome: decide Claudio.')
      }
    } else {
      $destNative = Join-Path (Convert-Path -LiteralPath $ExpDir) $EaNome
      $fs = $null
      try{
        $fs = [IO.File]::Open($destNative, [IO.FileMode]::CreateNew, [IO.FileAccess]::Write, [IO.FileShare]::None)
        $Creato = $true
        $fs.Write($Bytes, 0, $Bytes.Length)
        $fs.Flush()
        $fs.Close(); $fs = $null
        $v = Get-Item -LiteralPath $Dest -Force
        if($v.PSIsContainer -or $v.Length -ne $Bytes.Length){ throw ('copia NON verificata: lunghezza ' + $v.Length + ' invece di ' + $Bytes.Length) }
        $hv = Sha256Di (Leggi-Bytes $Dest)
        if($hv -ne $EaSha){ throw ('copia NON verificata: SHA256 riletto ' + $hv + ' invece di ' + $EaSha) }
        $Installato = $true
        Dico ('INSTALLATO: ' + $Dest + '   ' + $Bytes.Length + ' byte, SHA256 riletto dal disco = atteso') 'Green'
      }
      catch{
        $m1 = Pulisci ('' + $_.Exception.Message)
        if($null -ne $fs){ try{ $fs.Close() }catch{} }
        if($Creato -and -not $Installato){ try{ [IO.File]::Delete($destNative); $Rimosso = $true }catch{ $Rimosso = $false } }
        throw ('scrittura fallita (' + $m1 + '). ' + $(if($Creato){ if($Rimosso){ 'Il file parziale creato da questa corsa e stato TOLTO.' }else{ 'ATTENZIONE: il file parziale creato da questa corsa NON e stato tolto: NON compilarlo, cancellalo a mano.' } }else{ 'Questa corsa NON ha creato nessun file (esisteva gia o non si poteva creare): non ho toccato niente.' }))
      }
    }
    $ex5 = Join-Path $ExpDir 'ABTG_EMA200_Ombra.ex5'
    if(Test-Path -LiteralPath $ex5){ Dico ('esiste GIA un ABTG_EMA200_Ombra.ex5 (modificato ' + (Get-Item -LiteralPath $ex5 -Force).LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss', $INV) + '): non l ho creato io; F7 lo rifara dal sorgente.') 'Yellow' }
    else { Dico 'ABTG_EMA200_Ombra.ex5: NON esiste (ne creato ne compilato da questa riga: il Navigatore di MT5 elenca gli .ex5, quindi prima serve F7 in MetaEditor).' }
    Dico 'copiato in 1 terminale (50503392); compilato in 0: F7 si fa UNA volta, in MetaEditor aperto da QUEL terminale (checklist 27).'
  }
  catch{ $Fatale = Pulisci ('' + $_.Exception.Message); [void]$Problemi.Add($Fatale); Dico ('STOP: ' + $Fatale) 'Red' }
}

# =====================================================================
if($null -ne $Scelta){
  Titolo '4. SEDIE DEL PROFILO ATTIVO (sola lettura, dai .chr salvati: puo essere una FOTO VECCHIA)'
  try{
    $prof = ''
    $ini = Join-Path $Scelta.Cartella 'config\common.ini'
    if(Test-Path -LiteralPath $ini){
      $mP = [regex]::Match((Leggi-Condiviso $ini), '(?im)^[ \t]*ProfileLast[ \t]*=[ \t]*(.+?)[ \t\r]*$')
      if($mP.Success){ $prof = $mP.Groups[1].Value.Trim() }
    }
    if($prof -eq ''){ $SedieNota = 'profilo attivo NON determinato (ProfileLast assente in config\common.ini): numero di sedie NON MISURATO' }
    else {
      $cr = Join-Path $Scelta.Cartella ('MQL5\Profiles\Charts\' + $prof)
      if(-not (Test-Path -LiteralPath $cr)){ $SedieNota = 'cartella dei grafici del profilo ' + $prof + ' assente: numero di sedie NON MISURATO' }
      else {
        $n = 0; $ill = 0; $tot = 0; $ultimo = $null; $gia = New-Object System.Collections.ArrayList
        foreach($f in @(Get-ChildItem -LiteralPath $cr -File -Filter 'chart*.chr' -ErrorAction SilentlyContinue)){
          $tot++
          if($null -eq $ultimo -or $f.LastWriteTime -gt $ultimo){ $ultimo = $f.LastWriteTime }
          $t = Leggi-Condiviso $f.FullName
          if(-not $t){ $ill++; continue }
          if($t -match '<expert>'){
            $nm = ''; $mm = [regex]::Match($t, '(?s)<expert>\s*name=([^\r\n<]*)'); if($mm.Success){ $nm = $mm.Groups[1].Value.Trim() }
            if($nm -ne 'Main'){ $n++ }
            if($nm -like '*EMA200_Ombra*'){ [void]$gia.Add($f.Name) }
          }
        }
        $Sedie = $n
        $SedieNota = 'sedie nel profilo attivo ' + $prof + ' (grafici con un EA, dai .chr salvati): ' + $n + '   su ' + $tot + ' grafici, illeggibili ' + $ill + '   [FOTO: ultimo .chr salvato ' + $(if($null -ne $ultimo){ $ultimo.ToString('yyyy-MM-dd HH:mm', $INV) + ', ' + ([math]::Round(($T0 - $ultimo).TotalHours, 1)).ToString('0.0', $INV) + ' ore fa' }else{ 'NESSUNO' }) + '; i .chr si aggiornano solo quando MT5 salva il profilo, la conta vera sono le faccine nel terminale]'
        if($gia.Count -gt 0){ [void]$Rilievi.Add('NEL PROFILO ATTIVO C E GIA UN GRAFICO CON L OMBRA (' + ($gia -join ', ') + '): non trascinarla una seconda volta.') }
      }
    }
  }
  catch{ $SedieNota = 'passo sedie MORTO: ' + (Pulisci ('' + $_.Exception.Message)) + ' -> NON MISURATO'; [void]$Problemi.Add($SedieNota) }
  DicoP $SedieNota
}

# =====================================================================
Titolo '5. SOGLIE DI ALLARME (scritte PRIMA di attaccare, calcolate sui numeri di partenza qui sopra)'
$RossoLibera = 1024
if($null -ne $LiberaMB){ $RossoLibera = [math]::Max(1024, $LiberaMB - 800) }
DicoP ('RAM libera del VPS: ROSSO se scende sotto ' + $RossoLibera.ToString('0', $INV) + ' MB (pavimento 1024 MB, oppure 800 MB meno del numero di partenza ' + $(if($null -ne $LiberaMB){ $LiberaMB.ToString('0', $INV) + ' MB' }else{ 'NON MISURATO' }) + ').')
if($null -ne $WsNostro){ DicoP ('working set del terminal64 del piccolo: GIALLO oltre ' + ([math]::Round($WsNostro + 500, 0)).ToString('0', $INV) + ' MB (+500 = oltre la stima peggiore del documento, 200-500 MB), ROSSO oltre ' + ([math]::Round($WsNostro + 800, 0)).ToString('0', $INV) + ' MB (+800).') }
else { DicoP 'working set del terminal64 del piccolo: numero di partenza NON MISURATO: giallo = +500 MB e rosso = +800 MB rispetto a quello che leggi nella Gestione attivita PRIMA di trascinare l EA.' }
DicoP ('CPU del terminal64 del piccolo: ROSSO se resta oltre il numero di partenza di piu di ' + $(if($nCore -gt 0){ ([math]::Round(30 / $nCore, 1)).ToString('0.0', $INV) + ' punti percentuali su ' + $nCore + ' core' }else{ '30 % di UN core' }) + ' (= 30 % di UN core, il tetto dichiarato dall EA) per 5 minuti di fila, valutando dal minuto 10 dopo l attacco (il calcolo iniziale degli indicatori e un picco una tantum).')
DicoP 'giro dell EA (ombra_battito.txt): ROSSO se giro_ultimo_ms supera 1000 in due battiti di fila dopo il minuto 10.'
DicoP 'ROSSO = si chiude SOLO il grafico dell ombra (mai il bottone Algo Trading) e si manda lo screenshot. Dettaglio: report/OMBRA_ATTACCO_A_MANO_2026-10-05.md'
if($null -ne $LiberaMB -and $LiberaMB -lt 1024){ [void]$Rilievi.Add('la RAM libera e GIA sotto il pavimento di 1024 MB: NON attaccare l ombra finche non si libera RAM.') }
if($null -ne $LiberaMB -and $LiberaMB -ge 1024 -and $LiberaMB -lt 1800){ [void]$Rilievi.Add('RAM libera ' + $LiberaMB.ToString('0', $INV) + ' MB: poco margine sopra il pavimento (la stima dell ombra e 200-500 MB, NON MISURATA): attaccare e guardare la Gestione attivita subito.') }

# =====================================================================
Titolo '6. ESITO'
if($Rilievi.Count -gt 0){ Dico ('RILIEVI (' + $Rilievi.Count + '):'); foreach($x in $Rilievi){ Dico ('  ~ ' + $x) 'Yellow' } }
if($Problemi.Count -gt 0){ Dico ('PASSI FALLITI (' + $Problemi.Count + '):'); foreach($x in $Problemi){ Dico ('  - ' + $x) 'Red' } }
if($Fatale -ne ''){ $Esito = 'FERMATO -- ' + $Fatale }
elseif($Installato){ $Esito = 'INSTALLATO' }
elseif($GiaUguale){ $Esito = 'GIA PRESENTE UGUALE (non riscritto)' }
else { $Esito = 'FERMATO -- esito non determinato' }
if($Installato -or $GiaUguale){
  Dico ''
  Dico ('PROSSIMO PASSO (a mano, DENTRO MT5 del conto 50503392, cartella dati ' + $Scelta.Nome + '): MetaEditor (F4) -> aggiorna Experts -> apri ABTG_EMA200_Ombra.mq5 -> F7 -> riporta la riga del risultato (0 errori / 0 errors) e i warning; POI un grafico NUOVO e trascinaci l EA. Mai su un grafico che ha gia un EA. Passi completi, soglie e come fermarlo: report/OMBRA_ATTACCO_A_MANO_2026-10-05.md. NON e stato compilato ne attaccato niente da questa riga.') 'Cyan'
}
Dico ''
Dico ('ESITO OMBRA INSTALL: ' + $Esito) $(if($Installato -or $GiaUguale){ 'Green' }else{ 'Red' })

# =====================================================================
#  RACCOLTA SUL DESKTOP + ZIP (regola delle righe di lancio): SEMPRE, anche dopo un STOP.
# =====================================================================
try{
  Write-Host ''
  Write-Host '=== RACCOLTA ===' -ForegroundColor Cyan
  $base = Join-Path $Dsk ('ABTG_OMBRA_INSTALL_' + $Stamp)
  $RefTxt = $base + '.txt'; $PriTxt = $base + '_PRIMA.txt'; $Zip = $base + '.zip'; $k = 1
  while((Test-Path -LiteralPath $RefTxt) -or (Test-Path -LiteralPath $PriTxt) -or (Test-Path -LiteralPath $Zip)){ $k++; $RefTxt = $base + '_' + $k + '.txt'; $PriTxt = $base + '_' + $k + '_PRIMA.txt'; $Zip = $base + '_' + $k + '.zip' }
  Set-Content -LiteralPath $RefTxt -Value ($R -join "`r`n") -Encoding ASCII
  Set-Content -LiteralPath $PriTxt -Value ($Pri -join "`r`n") -Encoding ASCII
  Compress-Archive -LiteralPath $RefTxt, $PriTxt -DestinationPath $Zip -Force
  Add-Type -AssemblyName System.IO.Compression.FileSystem
  $zz = [IO.Compression.ZipFile]::OpenRead((Convert-Path -LiteralPath $Zip))
  $presenti = @($zz.Entries | ForEach-Object { $_.Name })
  $zz.Dispose()
  $attesi = @((Split-Path -Leaf $RefTxt), (Split-Path -Leaf $PriTxt))
  $mancanti = @($attesi | Where-Object { $presenti -notcontains $_ })
  $ZipPresenti = ($presenti -join ', ')
  $ZipMancanti = $(if($mancanti.Count -gt 0){ ($mancanti -join ', ') }else{ 'nessuno' })
  $ZipOk = ((Test-Path -LiteralPath $Zip) -and ($mancanti.Count -eq 0))
  Write-Host ('REFERTO: ' + $RefTxt) -ForegroundColor Green
  Write-Host ('ZIP DA MANDARE: ' + $Zip) -ForegroundColor Green
  Write-Host ('FILE ATTESI: ' + ($attesi -join ', '))
  Write-Host ('FILE PRESENTI NELLO ZIP (letti dallo zip, non dal piano): ' + $ZipPresenti)
  Write-Host ('MANCANTI: ' + $ZipMancanti + '   (lo zip porta nel nome l ora di avvio al secondo: non puo essere quello di una corsa vecchia)')
  if(-not $ZipOk){ Write-Host 'ZIP NON VALIDO: manca qualcosa. NON mandarlo: rilancia.' -ForegroundColor Red }
}
catch{
  Write-Host ('!!! RACCOLTA FALLITA: ' + (Pulisci ('' + $_.Exception.Message))) -ForegroundColor Red
  Write-Host 'Il referto e stato comunque stampato qui sopra: copia la console intera.' -ForegroundColor Red
}
Write-Host ''
if($Installato -or $GiaUguale){ Write-Host ('ESITO OMBRA INSTALL: ' + $Esito) -ForegroundColor Green }
else { Write-Host ('ESITO OMBRA INSTALL: ' + $Esito) -ForegroundColor Red }
