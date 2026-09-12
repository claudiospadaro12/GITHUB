# =====================================================================
#  MARCATORE_RIGA_COLLAUDO_RICOMPILA_v1
#  RIGA_COLLAUDO_RICOMPILA.ps1 -- COMPILAZIONE DI COLLAUDO degli 11
#  bersagli elencati in report/RIMETTERE_IL_CAMPO_IN_PARI_2026-09-12.md
#  paragrafo 4.1, sul BANCO DI BACKTEST.
#
#  >>> BERSAGLIO: conto 50504400, cartella C:\MT5_Backtest.
#      NON TOCCA: il demo piccolo, il dry-run 100k, il conto REALE,
#      Pepperstone, Tickmill. Sono SEI cartelle dati sul VPS: "gira sul
#      VPS" non e' un bersaglio, e' un indirizzo. Qui il bersaglio e'
#      UNO e la riga si ferma se il percorso passato non e' quello.
#
#  >>> QUESTA RIGA NON INSTALLA NIENTE, NON FA NESSUN DEPLOY, NON
#      ATTACCA E NON STACCA NESSUNA SEDIA.
#      I sorgenti vengono scaricati in un ALBERO DI LAVORO sotto
#      %USERPROFILE%\abtg_collaudo_ricompila\MQL5\ (Experts\ e Include\),
#      che e' il path RELATIVO che il compilatore si aspetta, e
#      metaeditor64.exe viene chiamato con /inc su QUELL'albero.
#      Il MQL5\Experts di ogni terminale resta come sta: la riga lo
#      DIMOSTRA con un INVENTARIO PER FILE (percorso, byte, data di
#      ogni file, piu' conteggio, byte totali e impronta SHA256
#      dell'elenco) preso PRIMA e RIFATTO DOPO, non con una frase.
#      >>> CLASSE 260, PAGATA QUI: la prima stesura fotografava la
#      CARTELLA. Non e' una prova: il LastWriteTime di una directory
#      cambia solo se una voce viene AGGIUNTA, TOLTA o RINOMINATA, e
#      una SOVRASCRITTURA IN LOCO di un .ex5 che c'era gia' -- cioe'
#      l'unico evento che questo collaudo esiste per escludere -- la
#      lascia IDENTICA. E $i.Length su una DirectoryInfo non esiste:
#      stampava un campo vuoto fra due virgole.
#
#  >>> PERCHE' ESISTE: il 12/09 e' stato misurato che HEAD **NON E' UN
#      BERSAGLIO DI COMPILAZIONE**. Due commit dichiarano da soli di non
#      esserlo: b45dd00 ("IN CORSO D'OPERA -- NON COMPILARE") e b5d904a
#      (WIP del 29/08, ed e' ancora HEAD per il Nasdaq).
#      IL PESO, CONTATO SULL'INSIEME CHE UN F7 TOCCA DAVVERO (classe
#      261): b45dd00 dichiara "10 EA" nel titolo ma ne tocca 11, e le
#      2.208 righe del suo --stat comprendono 664 righe di .py e .ps1
#      che nessun F7 compila. Codice EA non verificato: 1.544 righe
#      (b45dd00, 11 file) + 198 (b5d904a, il Nasdaq) = 1.742 su 12 file.
#      Quindi ogni sorgente si scarica al SUO commit bersaglio, che e'
#      l'ultimo NON-WIP che tocca quel file.
#      E L'INSIEME NON E' LO STESSO: 3 dei bersagli qui sotto
#      (SupRev_DAX_H4_Ott, SupRev_NAS_H1_Ott, ORB_Ottimizzato) non sono
#      toccati da nessun WIP, e 4 file del WIP (PTE_Ottimizzato,
#      SuperWave_DAX_H4_Ottimizzato, CostToCost, GapContinuation) non
#      sono bersagli. Due insiemi da 11 che NON coincidono.
#
#  >>> IL PIN E IL BERSAGLIO SONO DUE COSE DIVERSE, ed e' voluto:
#      -Pin appunta QUESTO script e l'include condiviso al commit da cui
#      sono stati letti (cosi' la corsa e' riproducibile). I SORGENTI EA
#      no: ognuno ha il suo commit, scritto nella tabella qui sotto e
#      STAMPATO a schermo. Il conteggio righe atteso e' la prova che il
#      blob scaricato e' quello: se non torna, la riga si ferma.
#
#  >>> LEZIONE DEL 22/08, INCORPORATA: metaeditor64.exe DEVE ESSERE
#      CHIUSO. Con l'editor aperto la compilazione da riga di comando
#      torna rc=0 SENZA compilare niente ("rc=0 muto"), e un rc=0 muto
#      letto come successo e' peggio di un errore.
#
#  >>> SECONDA LEZIONE DEL 22/08: GLI INCLUDE SI CENSISCONO, NON SI
#      INDOVINANO. Il primo giro fallii perche' lo script installava
#      l'EA e non ABTG_PausaGuardian.mqh. Qui ogni #include di ogni
#      sorgente viene LETTO ed elencato: se compare un include ABTG_ che
#      questa riga non scarica, si FERMA PRIMA di compilare e dice il
#      nome.
#
#  >>> LIMITE DICHIARATO, e conta: l'include condiviso viene scaricato a
#      -Pin (il repo di OGGI), non alla data di ogni bersaglio. E'
#      VOLUTO: e' esattamente l'accoppiata che un deploy fatto oggi
#      produrrebbe (EA al suo commit non-WIP + include di oggi). La
#      riga lo STAMPA come avvertenza, non lo nasconde.
#
#  Nessuna emoji: i .ps1 di casa si scrivono in ASCII puro (Windows
#  PowerShell 5.1 legge i .ps1 come ANSI, e un'emoji dentro una stringa
#  rompe il parser).
# =====================================================================
param(
  # -Pin NON ha default: un default silenzioso ("lavoro") farebbe girare
  #  la punta del branch spacciandola per un commit congelato.
  [string]$Pin         = "",
  [switch]$SoloControllo,
  # -Terminale: si usa SOLO se la scelta automatica si ferma perche' non
  #  ha un FATTO per decidere. La riga stampa l'elenco e il path da
  #  incollare qui. Il valore ammesso e' UNO SOLO (vedi la guardia).
  [string]$Terminale   = "",
  [int]$TimeoutSec     = 180
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

# ---------------------------------------------------------------------
#  I BERSAGLI. Ogni riga e' un FATTO misurato il 12/09 e scritto nel
#  referto: nome, commit NON-WIP, versione attesa, righe attese (wc -l,
#  NON il conteggio di CODA_06 che vale wc -l + 1).
#  La colonna "perche'" dice quale riparazione entra con quel bersaglio.
# ---------------------------------------------------------------------
$BERSAGLI = @(
  @{ Nome="ABTG_SupertrendReversal";                 Commit="872dba82d7b3b345c8ae15cb1033b66df6066ae5"; Ver="1.01"; Righe=665;  Perche="lotto doppio (fix 872dba8)" },
  @{ Nome="ABTG_SupertrendReversal_Ottimizzato";     Commit="872dba82d7b3b345c8ae15cb1033b66df6066ae5"; Ver="1.01"; Righe=614;  Perche="lotto doppio (fix 872dba8)" },
  @{ Nome="ABTG_SuperWave";                          Commit="872dba82d7b3b345c8ae15cb1033b66df6066ae5"; Ver="1.01"; Righe=637;  Perche="lotto doppio (fix 872dba8)" },
  @{ Nome="ABTG_SuperWave_DOW_H1_Ottimizzato";       Commit="872dba82d7b3b345c8ae15cb1033b66df6066ae5"; Ver="1.01"; Righe=645;  Perche="lotto doppio (fix 872dba8)" },
  @{ Nome="ABTG_SupRev_DAX_H4_Ottimizzato";          Commit="872dba82d7b3b345c8ae15cb1033b66df6066ae5"; Ver="1.01"; Righe=615;  Perche="lotto doppio (fix 872dba8)" },
  @{ Nome="ABTG_SupRev_NAS_H1_Ottimizzato";          Commit="872dba82d7b3b345c8ae15cb1033b66df6066ae5"; Ver="1.01"; Righe=652;  Perche="lotto doppio (fix 872dba8)" },
  @{ Nome="ABTG_PTE";                                Commit="26a185661c120de6fa0a33b79279595740e264e8"; Ver="1.01"; Righe=649;  Perche="sizing OrderCalcProfit (fix 3af47ed)" },
  @{ Nome="ABTG_EMA200";                             Commit="26a185661c120de6fa0a33b79279595740e264e8"; Ver="1.00"; Righe=552;  Perche="sizing OrderCalcProfit (fix 3af47ed)" },
  @{ Nome="ABTG_EMA200_Ottimizzato";                 Commit="65de32c06f19450f579d14071a24c8117a99f514"; Ver="1.00"; Righe=606;  Perche="sizing + fix errore di compilazione di 6ee2ec0" },
  @{ Nome="ABTG_Nasdaq_Apertura_US";                 Commit="d83c1960deb961e575e1ae0fb946dbc1af7149e9"; Ver="1.02"; Righe=2382; Perche="guardia A4 storicoOk (8b92214). ATTENZIONE: porta DEF_RISK 2.0 -- serve la firma C4-bis" },
  @{ Nome="ABTG_ORB_Ottimizzato";                    Commit="19312c8bb745e954c5456f9dba382416502d5bc6"; Ver="1.04"; Righe=1463; Perche="hedge-safe per TICKET" }
)
# Gli include NOSTRI che questa riga scarica (a -Pin). Se un sorgente ne
# nomina uno che non e' in questa lista, si ferma e dice il nome.
$INCLUDE_NOSTRI = @("ABTG_PausaGuardian.mqh")

# I percorsi che NON si toccano MAI. Qui stanno per essere RIFIUTATI.
$VIETATI = @("BCM Markets MT5 Terminal", "-V3", "BCM_Reale", "Pepperstone", "Tickmill")
$SOLO_QUESTO = "C:\MT5_Backtest"

$Avvio = Get-Date
$Stamp = $Avvio.ToString("yyyyMMdd_HHmm", $INV)

# IL DESKTOP SI CERCA, NON SI ASSUME: con OneDrive il Desktop vero non e'
# %USERPROFILE%\Desktop, e una New-Item -Force ne creerebbe uno finto in
# cui Claudio non troverebbe mai lo zip.
function TrovaDesktop(){
  foreach($p in @([Environment]::GetFolderPath("Desktop"),
                  (Join-Path $env:USERPROFILE "Desktop"),
                  (Join-Path $env:USERPROFILE "OneDrive\Desktop"))){
    if($p -and (Test-Path -LiteralPath $p)){ return $p }
  }
  return $env:USERPROFILE
}
$Dsk  = TrovaDesktop
$Work = Join-Path $env:USERPROFILE "abtg_collaudo_ricompila"
$MqlW = Join-Path $Work "MQL5"
$ExpW = Join-Path $MqlW "Experts"
$IncW = Join-Path $MqlW "Include"

# --- tutto cio' che la raccolta usa nasce QUI, prima del try: la
#     raccolta gira SEMPRE, anche nel giro fermato da una guardia, e
#     ogni campo parte da uno stato VERO ("non ci siamo arrivati"), mai
#     da uno stato che somigli a un risultato.
$Problemi   = New-Object System.Collections.ArrayList
$Rilievi    = New-Object System.Collections.ArrayList
$Esiti      = New-Object System.Collections.ArrayList
$Fatale     = ""
$TermScelto = "NON SCELTO"
$LibStd     = "NON COPIATA"
$IncTxt     = "NON SCARICATO"
$FotoPrima  = "NON PRESA"
$FotoDopo   = "NON PRESA"
$DetPrima   = @("non ci siamo arrivati")
$DetDopo    = @("non ci siamo arrivati")
$DataFolder = "NON RISOLTA"
$BaseTerm   = "NON RISOLTA"
$Modo = "CORSA"
if($SoloControllo){ $Modo = "CONTROLLO" }

function Ora(){ return (Get-Date).ToString("HH:mm:ss", $INV) }
function Dico([string]$t,[string]$c="Gray"){ Write-Host ("[" + (Ora) + "] " + $t) -ForegroundColor $c }
function Titolo([string]$t){ Write-Host ""; Write-Host ("=== " + $t + " ===") -ForegroundColor Cyan }

function Scarica([string]$url,[string]$dest){
  try{
    Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing -TimeoutSec 60
    if(-not (Test-Path -LiteralPath $dest)){ return "SCARICO FALLITO (nessun file): " + $url }
    if((Get-Item -LiteralPath $dest).Length -le 0){ return "SCARICO VUOTO (0 byte): " + $url }
    return ""
  }
  catch{ return ("SCARICO FALLITO: " + $url + " -- " + $_.Exception.Message) }
}

function Descrivi([string]$path){
  if(-not (Test-Path -LiteralPath $path)){ return "ASSENTE" }
  $i = Get-Item -LiteralPath $path
  return ("esiste, " + $i.Length + " byte, " + $i.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss", $INV))
}

# INVENTARIO PER FILE di una radice del terminale: E' LA PROVA del
# "nessun deploy", e va fatta per FILE (classe 260). Torna un riassunto
# corto e confrontabile (conteggio + byte totali + impronta SHA256
# dell'elenco) e il DETTAGLIO riga per riga, che finisce nel referto:
# l'impronta dice SE e' cambiato, l'elenco dice COSA.
function Inventario([string]$radice){
  if(-not (Test-Path -LiteralPath $radice)){
    return @{ Riassunto = ("ASSENTE (la cartella non esiste): " + $radice); Dettaglio = @("-- cartella assente --") }
  }
  $det = New-Object System.Collections.ArrayList
  $n = 0
  $tot = 0
  foreach($f in @(Get-ChildItem -LiteralPath $radice -Recurse -File -ErrorAction SilentlyContinue | Sort-Object FullName)){
    $n = $n + 1
    $tot = $tot + $f.Length
    $rel = $f.FullName
    if($rel.Length -gt $radice.Length){ $rel = $rel.Substring($radice.Length).TrimStart("\") }
    [void]$det.Add($rel + " | " + $f.Length + " byte | " + $f.LastWriteTimeUtc.ToString("yyyy-MM-dd HH:mm:ss", $INV) + "Z")
  }
  $imp = "cartella vuota"
  if($n -gt 0){
    $alg = [Security.Cryptography.SHA256]::Create()
    $byt = [Text.Encoding]::UTF8.GetBytes(($det -join "`n"))
    $imp = ([BitConverter]::ToString($alg.ComputeHash($byt))).Replace("-","").Substring(0,16)
  }
  if($det.Count -eq 0){ [void]$det.Add("-- nessun file --") }
  return @{ Riassunto = ($radice + " -> " + $n + " file, " + $tot + " byte totali, impronta " + $imp); Dettaglio = $det }
}

function LeggiTesto([string]$path){
  if(-not (Test-Path -LiteralPath $path)){ return @() }
  try{ return @(Get-Content -LiteralPath $path -Encoding UTF8 -ErrorAction Stop) }
  catch{ return @() }
}

function ContaRighe([string]$path){
  # wc -l, cioe' il NUMERO DI A-CAPO. E' il conteggio del repo, NON
  # quello di CODA_06 (che vale wc -l + 1 perche' lo split lascia un
  # elemento vuoto in coda). La differenza e' misurata e dichiarata.
  $t = [IO.File]::ReadAllText($path)
  $n = 0
  foreach($ch in $t.ToCharArray()){ if($ch -eq "`n"){ $n = $n + 1 } }
  return $n
}

function VersioneDi([string]$path){
  foreach($r in (LeggiTesto $path)){
    if($r -match '#property\s+version\s+"([^"]+)"'){ return $Matches[1] }
  }
  return "NON LETTA"
}

function CensisciInclude([string]$path){
  $lista = New-Object System.Collections.ArrayList
  foreach($r in (LeggiTesto $path)){
    if($r -match '^\s*#include\s*[<"]([^>"]+)[>"]'){ [void]$lista.Add($Matches[1]) }
  }
  return $lista
}

function Compila([string]$exe,[string]$mq5,[string]$ex5,[string]$log,[int]$tetto){
  Remove-Item -LiteralPath $ex5 -Force -ErrorAction SilentlyContinue
  Remove-Item -LiteralPath $log -Force -ErrorAction SilentlyContinue
  $t0 = Get-Date
  $argomenti = @(("/compile:" + $mq5), ("/inc:" + $MqlW), ("/log:" + $log))
  Dico ("  metaeditor64 " + ($argomenti -join " ")) "Yellow"
  $global:LASTEXITCODE = $null
  # INVOCAZIONE DIRETTA: e' PowerShell a quotare ogni argomento (i path
  # hanno gli spazi di "Program Files"). MAI Start-Process con la
  # stringa di argomenti montata a mano: 22/08, rc=0 e zero compilazioni.
  & $exe @argomenti | Out-Null
  $rc = $LASTEXITCODE
  $muto = $false
  while($true){
    if((Test-Path -LiteralPath $ex5) -and ((Get-Item -LiteralPath $ex5).LastWriteTime -ge $t0)){ break }
    $r = LeggiTesto $log
    if((@($r).Count -gt 0) -and ((@($r) -match 'Result:').Count -gt 0)){ break }
    $sec = (New-TimeSpan -Start $t0 -End (Get-Date)).TotalSeconds
    if((@($r).Count -eq 0) -and ($sec -ge 25)){ $muto = $true; break }
    if($sec -ge $tetto){ break }
    Start-Sleep -Seconds 2
  }
  $fresco = $false
  if((Test-Path -LiteralPath $ex5) -and ((Get-Item -LiteralPath $ex5).LastWriteTime -ge $t0)){ $fresco = $true }
  return @{ Ex5 = $fresco; Rc = $rc; Muto = $muto; Log = (LeggiTesto $log) }
}

try{
  Titolo ("COLLAUDO DI RICOMPILAZIONE -- " + $BERSAGLI.Count + " bersagli -- modo " + $Modo)
  Write-Host "NESSUN DEPLOY, NESSUNA SEDIA TOCCATA: si compila in una cartella di lavoro." -ForegroundColor Yellow
  Write-Host "Bersaglio ammesso: il solo banco di backtest (conto 50504400)." -ForegroundColor Yellow

  # -------------------------------------------------------------------
  #  0. LE GUARDIE
  # -------------------------------------------------------------------
  Titolo "0. GUARDIE"
  if($Pin -eq ""){ throw "-Pin obbligatorio: senza, girerebbe la punta del branch spacciandola per un commit congelato." }
  if($Pin -notmatch '^[0-9a-f]{40}$'){ throw ("-Pin deve essere un commit di 40 caratteri esadecimali, ricevuto: " + $Pin) }
  $RawPin = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/" + $Pin

  # ogni bersaglio deve avere un commit COMPLETO: uno abbreviato o
  # riempito di zeri non e' un pin, e qui si rifiuta invece di scaricare
  # una 404 e chiamarla "errore di rete".
  foreach($b in $BERSAGLI){
    if($b.Commit -notmatch '^[0-9a-f]{40}$'){ throw ("bersaglio " + $b.Nome + ": il commit non e' un sha di 40 esadecimali (" + $b.Commit + ").") }
    if($b.Commit -match '0{12}$'){ throw ("bersaglio " + $b.Nome + ": il commit e' un segnaposto riempito di zeri. VA COMPLETATO con lo sha intero prima di lanciare: " + $b.Commit) }
  }

  # LA GUARDIA SUL BERSAGLIO. I terminali vivi non si toccano: qui i
  # loro percorsi vengono NOMINATI per essere RIFIUTATI.
  if($Terminale -ne ""){
    foreach($v in $VIETATI){
      if($Terminale -like ("*" + $v + "*")){ throw ("BERSAGLIO VIETATO: '" + $Terminale + "' contiene '" + $v + "'. Questa riga compila SOLO sul banco di backtest " + $SOLO_QUESTO + ". Il demo piccolo, il dry-run 100k e il conto REALE non si toccano.") }
    }
    if($Terminale -ne $SOLO_QUESTO){ throw ("BERSAGLIO NON AMMESSO: '" + $Terminale + "'. L'unico valore ammesso e' " + $SOLO_QUESTO + " (conto 50504400).") }
  }

  if(Get-Process metaeditor64 -ErrorAction SilentlyContinue){
    throw "METAEDITOR APERTO: con l'editor gia' aperto la compilazione da riga di comando torna subito SENZA compilare niente (rc=0 muto, lezione del 22/08). Chiudi MetaEditor e rilancia."
  }
  if(Get-Process terminal64 -ErrorAction SilentlyContinue){
    [void]$Rilievi.Add("terminal64 e' APERTO: qui e' TOLLERATO e dichiarato -- questo giro compila in una cartella di lavoro e non scrive niente nelle cartelle di nessun terminale. La foto prima/dopo lo dimostra.")
  }
  Dico ("pin (script e include) ... " + $Pin)
  Dico ("cartella di lavoro ....... " + $Work)

  # -------------------------------------------------------------------
  #  1. IL BANCO DI BACKTEST
  # -------------------------------------------------------------------
  Titolo "1. metaeditor64.exe DEL BANCO DI BACKTEST"
  $Me = ""
  if($Terminale -ne ""){
    $Me = Join-Path $Terminale "metaeditor64.exe"
    if(-not (Test-Path -LiteralPath $Me)){ throw ("-Terminale '" + $Terminale + "' non contiene metaeditor64.exe.") }
    $TermScelto = $Terminale
  }
  else{
    $cand = Join-Path $SOLO_QUESTO "metaeditor64.exe"
    if(Test-Path -LiteralPath $cand){ $Me = $cand; $TermScelto = $SOLO_QUESTO }
    else{ throw ("metaeditor64.exe non trovato in " + $SOLO_QUESTO + ". L'ambiente non si indovina: se il banco sta altrove, passalo con -Terminale, e il valore verra' comunque confrontato con quello ammesso.") }
  }
  Dico ("banco scelto ... " + $TermScelto) "Green"

  # LA CARTELLA DATI SI RISOLVE, NON SI ASSUME (classe 260 punto 4).
  # MQL5\Experts e MQL5\Include vivono nella CARTELLA DATI
  # (%APPDATA%\MetaQuotes\Terminal\<hash>, appaiata all'installazione da
  # origin.txt) e stanno accanto all'exe SOLO in un'installazione
  # portable. Il modello di casa che lo fa giusto era nella stessa
  # cartella: RIGA_COMPILA_ORB104.ps1 r.426-436. Se qui si guardasse
  # solo <installazione>\MQL5\Experts, su un'installazione normale la
  # foto uscirebbe ASSENTE prima e ASSENTE dopo, "coinciderebbero", e il
  # referto stamperebbe la prova avendo guardato il vuoto (classe 117).
  $termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
  foreach($d in @(Get-ChildItem -LiteralPath $termRoot -Directory -ErrorAction SilentlyContinue)){
    $o = Join-Path $d.FullName "origin.txt"
    if(Test-Path -LiteralPath $o){
      $org = (Get-Content -LiteralPath $o -Raw -ErrorAction SilentlyContinue)
      if($null -ne $org){
        if($org.Trim().TrimEnd("\") -ieq $TermScelto.TrimEnd("\")){ $DataFolder = $d.FullName }
      }
    }
  }
  if(($DataFolder -ne "NON RISOLTA") -and (Test-Path -LiteralPath (Join-Path $DataFolder "MQL5\Include\Trade\Trade.mqh"))){
    $BaseTerm = $DataFolder
    Dico ("cartella dati .. " + $DataFolder + "  (appaiata da origin.txt)") "Green"
  }
  elseif(Test-Path -LiteralPath (Join-Path $TermScelto "MQL5\Include\Trade\Trade.mqh")){
    $BaseTerm = $TermScelto
    [void]$Rilievi.Add("libreria standard e MQL5 presi dalla cartella di INSTALLAZIONE (" + $TermScelto + "): installazione portable o senza cartella dati appaiata. Dichiarato, non assunto.")
    Dico ("cartella dati .. " + $TermScelto + "  (RIPIEGO portable)") "Yellow"
  }
  else{
    throw ("LIBRERIA STANDARD NON TROVATA: ne' in " + (Join-Path $DataFolder "MQL5\Include\Trade\Trade.mqh") + " ne' in " + (Join-Path $TermScelto "MQL5\Include\Trade\Trade.mqh") + ". Senza <Trade/Trade.mqh> non compila NIENTE: mi fermo qui senza toccare niente. Il repo ha agli atti che " + $SOLO_QUESTO + " e' stata un'installazione NUOVA E VUOTA (RIGA_ANCORA_R119.ps1 r.60-64), cioe' proprio questo caso. La cartella dati si stampa con: Get-ChildItem (Join-Path $env:APPDATA 'MetaQuotes\Terminal') -Directory | ForEach-Object { $_.FullName + ' <- ' + (Get-Content (Join-Path $_.FullName 'origin.txt') -Raw -EA SilentlyContinue) }")
  }
  $LibSorg = Join-Path $BaseTerm "MQL5\Include"

  # -------------------------------------------------------------------
  #  2. INVENTARIO PRIMA -- la prova che non tocchiamo il terminale
  # -------------------------------------------------------------------
  Titolo "2. INVENTARIO PRIMA (MQL5\Experts e MQL5\Include del banco, PER FILE)"
  $ExpTerm = Join-Path $BaseTerm "MQL5\Experts"
  $IncTerm = Join-Path $BaseTerm "MQL5\Include"
  $iE = Inventario $ExpTerm
  $iI = Inventario $IncTerm
  $FotoPrima = $iE.Riassunto + "  ;;  " + $iI.Riassunto
  $DetPrima  = @("[Experts] " + $iE.Riassunto) + @($iE.Dettaglio | ForEach-Object { "    " + $_ }) + @("[Include] " + $iI.Riassunto) + @($iI.Dettaglio | ForEach-Object { "    " + $_ })
  Write-Host ("  " + $iE.Riassunto)
  Write-Host ("  " + $iI.Riassunto)
  Write-Host "  (il dettaglio per file sta nel referto: l'impronta dice SE, l'elenco dice COSA)" -ForegroundColor DarkGray

  # -------------------------------------------------------------------
  #  3. ALBERO DI LAVORO, RIFATTO DA ZERO
  # -------------------------------------------------------------------
  Titolo "3. ALBERO DI LAVORO, rifatto da zero"
  # si rifa' da zero apposta: un .ex5 di un giro precedente rimasto qui
  # dentro sarebbe il reperto che fa passare per fresco un giro morto.
  Remove-Item -LiteralPath $Work -Recurse -Force -ErrorAction SilentlyContinue
  New-Item -ItemType Directory -Path $ExpW -Force | Out-Null
  New-Item -ItemType Directory -Path $IncW -Force | Out-Null
  # LIBRERIA STANDARD. $LibSorg e' gia' stato RISOLTO e VERIFICATO su
  # Trade\Trade.mqh nella sezione 1: qui si copia soltanto.
  # FORMA NON AMBIGUA: si copia il CONTENUTO (\*) in una Include che
  # esiste gia'. La forma -LiteralPath <cartella> -Destination <cartella>
  # su PS 5.1 puo' annidare (Include\Include) quando la destinazione
  # contiene gia' una cartella con quel nome, ed e' per questo che il
  # modello provato (RIGA_COMPILA_ORB104.ps1 r.437) usa il \*.
  Copy-Item -Path (Join-Path $LibSorg "*") -Destination $IncW -Recurse -Force -ErrorAction Stop
  # UNA COPIA NON SI DICHIARA: SI VERIFICA. Senza questo controllo un
  # annidamento uscirebbe come "COPIATA" e morirebbe dopo, in
  # compilazione, con un messaggio che accusa il sorgente.
  if(-not (Test-Path -LiteralPath (Join-Path $IncW "Trade\Trade.mqh"))){
    throw ("COPIA DELLA LIBRERIA STANDARD NON VERIFICATA: nell'albero di lavoro manca Trade\Trade.mqh dopo la copia da " + $LibSorg + ". NON compilo.")
  }
  $nLib = @(Get-ChildItem -LiteralPath $IncW -Recurse -File -ErrorAction SilentlyContinue).Count
  $LibStd = "COPIATA da " + $LibSorg + " -- " + $nLib + " file nell'albero di lavoro, verificata su Trade\Trade.mqh"
  Dico $LibStd

  # -------------------------------------------------------------------
  #  4. GLI INCLUDE NOSTRI, a -Pin
  # -------------------------------------------------------------------
  Titolo "4. INCLUDE NOSTRI (a -Pin, cioe' il repo di oggi)"
  [void]$Rilievi.Add("L'include condiviso e' scaricato a -Pin (repo di oggi), non alla data di ogni bersaglio: e' VOLUTO, e' l'accoppiata che un deploy fatto oggi produrrebbe. Dichiarato, non nascosto.")
  foreach($n in $INCLUDE_NOSTRI){
    $dest = Join-Path $IncW $n
    $err  = Scarica ($RawPin + "/mql5/Include/" + $n) $dest
    if($err -ne ""){ throw $err }
    Dico ("  " + $n + " -> " + (Descrivi $dest))
  }
  $IncTxt = "SCARICATI: " + ($INCLUDE_NOSTRI -join ", ")

  # -------------------------------------------------------------------
  #  5. I SORGENTI, OGNUNO AL SUO COMMIT BERSAGLIO
  # -------------------------------------------------------------------
  Titolo "5. SORGENTI, ognuno al SUO commit bersaglio"
  foreach($b in $BERSAGLI){
    $dest = Join-Path $ExpW ($b.Nome + ".mq5")
    $url  = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/" + $b.Commit + "/mql5/Experts/" + $b.Nome + ".mq5"
    $err  = Scarica $url $dest
    if($err -ne ""){ throw $err }
    $rig = ContaRighe $dest
    $ver = VersioneDi $dest
    $ok  = "SI"
    if($rig -ne $b.Righe){ $ok = "NO"; [void]$Problemi.Add($b.Nome + ": righe " + $rig + " invece di " + $b.Righe + " -- il blob scaricato NON e' il bersaglio dichiarato. FERMO.") }
    if($ver -ne $b.Ver){   $ok = "NO"; [void]$Problemi.Add($b.Nome + ": versione " + $ver + " invece di " + $b.Ver + " -- il blob scaricato NON e' il bersaglio dichiarato. FERMO.") }
    Write-Host ("  " + $b.Nome.PadRight(40) + " v" + $ver + "  " + $rig + " righe  atteso v" + $b.Ver + "/" + $b.Righe + "  combacia=" + $ok)
    Write-Host ("      porta: " + $b.Perche) -ForegroundColor DarkGray
    # censimento degli include: un include ABTG_ non previsto ferma tutto
    foreach($i in (CensisciInclude $dest)){
      $nudo = Split-Path $i -Leaf
      if($nudo -like "ABTG_*"){
        if($INCLUDE_NOSTRI -notcontains $nudo){
          [void]$Problemi.Add($b.Nome + ": nomina l'include NOSTRO '" + $nudo + "' che questa riga NON scarica. Va aggiunto a INCLUDE_NOSTRI prima di compilare.")
        }
      }
      else{
        $stdp = Join-Path $IncW $i
        if(-not (Test-Path -LiteralPath $stdp)){
          [void]$Problemi.Add($b.Nome + ": l'include di libreria '" + $i + "' NON esiste nell'albero di lavoro (" + $stdp + ").")
        }
      }
    }
  }
  if($Problemi.Count -gt 0){ throw ("i sorgenti o gli include non combaciano: " + $Problemi.Count + " problemi. NON compilo. Vedi l'elenco nel referto.") }

  # -------------------------------------------------------------------
  #  6. COMPILAZIONE, una per una
  # -------------------------------------------------------------------
  if($SoloControllo){
    Dico "modo CONTROLLO: mi fermo qui, senza compilare." "Yellow"
  }
  else{
    Titolo "6. COMPILAZIONE (metaeditor64, invocazione diretta)"
    foreach($b in $BERSAGLI){
      $mq5 = Join-Path $ExpW ($b.Nome + ".mq5")
      $ex5 = Join-Path $ExpW ($b.Nome + ".ex5")
      $log = Join-Path $Work ($b.Nome + ".compile.log")
      Dico ($b.Nome) "Cyan"
      $r = Compila $Me $mq5 $ex5 $log $TimeoutSec
      $res = "NON LETTA"
      foreach($l in $r.Log){ if($l -match 'Result:'){ $res = $l.Trim() } }
      $esito = "FALLITA"
      if($r.Muto){
        $esito = "FALLITA -- METAEDITOR MUTO (rc=0 senza log e senza .ex5): non e' un errore del sorgente, e' il caso del 22/08. Controlla che metaeditor64 sia chiuso davvero e rilancia."
      }
      elseif($r.Ex5){
        $esito = "OK -- .ex5 fresco"
        if($res -match '([0-9]+)\s+error'){
          if([int]$Matches[1] -gt 0){ $esito = "ERRORI: " + $res }
        }
      }
      else{ $esito = "FALLITA -- nessun .ex5 fresco. " + $res }
      if($esito -notlike "OK*"){ [void]$Problemi.Add($b.Nome + ": " + $esito) }
      [void]$Esiti.Add(@{ Nome=$b.Nome; Ver=$b.Ver; Rc=$r.Rc; Res=$res; Esito=$esito; Ex5=(Descrivi $ex5) })
      Write-Host ("  -> " + $esito)
      Write-Host ("     " + $res) -ForegroundColor DarkGray
    }
  }

  # -------------------------------------------------------------------
  #  7. FOTO DOPO -- la prova che il terminale non e' stato toccato
  # -------------------------------------------------------------------
  Titolo "7. INVENTARIO DOPO (le stesse due cartelle di prima, PER FILE)"
  $jE = Inventario $ExpTerm
  $jI = Inventario $IncTerm
  $FotoDopo = $jE.Riassunto + "  ;;  " + $jI.Riassunto
  $DetDopo  = @("[Experts] " + $jE.Riassunto) + @($jE.Dettaglio | ForEach-Object { "    " + $_ }) + @("[Include] " + $jI.Riassunto) + @($jI.Dettaglio | ForEach-Object { "    " + $_ })
  Write-Host ("  " + $jE.Riassunto)
  Write-Host ("  " + $jI.Riassunto)
  if($FotoPrima -ne $FotoDopo){
    [void]$Rilievi.Add("L'INVENTARIO PRIMA E QUELLO DOPO NON COINCIDONO (conteggio, byte o impronta dell'elenco). Questa riga non scrive in quelle cartelle: se sono cambiate, qualcos'altro le ha toccate mentre girava. Confronta i due elenchi per file qui sotto e capisci COSA e' cambiato PRIMA di fidarti di questo referto.")
    Write-Host "  ATTENZIONE: inventario CAMBIATO. Vedi i due elenchi nel referto." -ForegroundColor Red
  }
  else{ Write-Host "  coincidono: nessun file aggiunto, toccato o rimosso nelle due cartelle del banco." -ForegroundColor Green }
}
catch{
  $Fatale = $_.Exception.Message
  Write-Host ""
  Write-Host ("FERMATO: " + $Fatale) -ForegroundColor Red
}

# =====================================================================
#  RACCOLTA -- gira SEMPRE, anche sul giro fermato da una guardia.
#  Regola di casa: i risultati finiscono sul Desktop, e lo zip e' pronto
#  da mandare. Copia RISULTATI: non tocca nessun terminale.
# =====================================================================
$Cart = Join-Path $Dsk ("collaudo_ricompila_" + $Stamp)
New-Item -ItemType Directory -Path $Cart -Force | Out-Null
$Ref  = Join-Path $Cart ("REFERTO_collaudo_ricompila_" + $Stamp + ".txt")

$out = New-Object System.Collections.ArrayList
[void]$out.Add("======================================================================")
[void]$out.Add("  COLLAUDO DI RICOMPILAZIONE -- SOLA COMPILAZIONE, NESSUN DEPLOY")
[void]$out.Add("  marcatore: MARCATORE_RIGA_COLLAUDO_RICOMPILA_v1")
[void]$out.Add("  avvio: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss", $INV))
[void]$out.Add("  fine : " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss", $INV))
[void]$out.Add("  modo : " + $Modo)
[void]$out.Add("  pin (script e include): " + $Pin)
[void]$out.Add("======================================================================")
[void]$out.Add("")
[void]$out.Add("QUELLO CHE QUESTA CORSA NON HA FATTO:")
[void]$out.Add("  non ha installato niente, non ha fatto nessun deploy, non ha")
[void]$out.Add("  attaccato ne' staccato nessuna sedia, non ha toccato nessun")
[void]$out.Add("  preset. Bersaglio unico: il banco di backtest (conto 50504400).")
[void]$out.Add("")
[void]$out.Add("banco scelto ..... " + $TermScelto)
[void]$out.Add("libreria std ..... " + $LibStd)
[void]$out.Add("include nostri ... " + $IncTxt)
[void]$out.Add("cartella dati .... " + $DataFolder)
[void]$out.Add("radice usata ..... " + $BaseTerm)
[void]$out.Add("inventario PRIMA . " + $FotoPrima)
[void]$out.Add("inventario DOPO .. " + $FotoDopo)
if($FotoPrima -eq $FotoDopo){ [void]$out.Add("  -> COINCIDONO: nessun file aggiunto, toccato o rimosso nel banco.") }
else{ [void]$out.Add("  -> NON COINCIDONO: vedi i due elenchi per file qui sotto.") }
[void]$out.Add("")
[void]$out.Add("=== INVENTARIO PER FILE -- PRIMA ===")
[void]$out.Add("  (la prova del 'nessun deploy' e' questo elenco, non la data di una")
[void]$out.Add("   cartella: il LastWriteTime di una directory NON cambia se un file")
[void]$out.Add("   che c'era gia' viene SOVRASCRITTO IN LOCO. Classe 260.)")
foreach($r in $DetPrima){ [void]$out.Add("  " + $r) }
[void]$out.Add("")
[void]$out.Add("=== INVENTARIO PER FILE -- DOPO ===")
foreach($r in $DetDopo){ [void]$out.Add("  " + $r) }
[void]$out.Add("")
[void]$out.Add("=== ESITI, bersaglio per bersaglio ===")
if($Esiti.Count -eq 0){ [void]$out.Add("  nessuna compilazione tentata.") }
foreach($e in $Esiti){
  [void]$out.Add("  " + $e.Nome.PadRight(40) + " v" + $e.Ver + "  rc=" + $e.Rc)
  [void]$out.Add("      esito: " + $e.Esito)
  [void]$out.Add("      log  : " + $e.Res)
  [void]$out.Add("      ex5  : " + $e.Ex5)
}
[void]$out.Add("")
[void]$out.Add("=== PROBLEMI BLOCCANTI (" + $Problemi.Count + ") ===")
if($Problemi.Count -eq 0){ [void]$out.Add("  nessuno.") }
foreach($p in $Problemi){ [void]$out.Add("  - " + $p) }
[void]$out.Add("")
[void]$out.Add("=== RILIEVI, non bloccanti (" + $Rilievi.Count + ") ===")
if($Rilievi.Count -eq 0){ [void]$out.Add("  nessuno.") }
foreach($r in $Rilievi){ [void]$out.Add("  - " + $r) }
[void]$out.Add("")
if($Fatale -ne ""){ [void]$out.Add("FERMATO DA UNA GUARDIA: " + $Fatale) }
[void]$out.Add("")
[void]$out.Add("LIMITE DICHIARATO: 0 errori qui NON e' una promessa sul")
[void]$out.Add("comportamento. Dice che il sorgente bersaglio COMPILA. Che il")
[void]$out.Add("fix MORDA si vede in campo, e la decisione di portarlo in campo")
[void]$out.Add("e' una firma di Claudio, non di questa riga.")
[void]$out.Add("CORSA COMPLETA: se questa riga MANCA, il referto e' TRONCATO.")

Set-Content -LiteralPath $Ref -Value $out -Encoding ASCII

# i log di compilazione viaggiano col referto: e' li' che sta il perche'
if(Test-Path -LiteralPath $Work){
  foreach($f in @(Get-ChildItem -LiteralPath $Work -Filter "*.compile.log" -ErrorAction SilentlyContinue)){
    Copy-Item -LiteralPath $f.FullName -Destination $Cart -Force
  }
}

$Zip = Join-Path $Dsk ("collaudo_ricompila_" + $Stamp + ".zip")
Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $Zip -Force

Titolo "RACCOLTA"
Write-Host ("  cartella: " + $Cart)
Write-Host ("  zip     : " + $Zip) -ForegroundColor Green
Write-Host "  file attesi da controllare in console:" -ForegroundColor Yellow
foreach($f in @(Get-ChildItem -LiteralPath $Cart -ErrorAction SilentlyContinue)){
  Write-Host ("    " + $f.Name + "  (" + $f.Length + " byte)")
}
Write-Host ""
if($Fatale -ne ""){ Write-Host "ESITO: FERMATO DA UNA GUARDIA. Vedi il referto." -ForegroundColor Red }
elseif($Problemi.Count -gt 0){ Write-Host ("ESITO: " + $Problemi.Count + " PROBLEMI BLOCCANTI. Vedi il referto.") -ForegroundColor Red }
else{ Write-Host "ESITO: nessun problema bloccante. Manda lo zip." -ForegroundColor Green }
