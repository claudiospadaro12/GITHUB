# =====================================================================
#  MARCATORE_RIGA_DIAG_GBPUSD_v2
#  RIGA_DIAG_GBPUSD.ps1  --  IL PIANO DIAGNOSTICO DELLA CELLA GBPUSD LENTA
#  (report/DIAGNOSI_GBPUSD_LENTA_2026-09-02.md, paragrafo 5)
# ---------------------------------------------------------------------
#  QUESTO NON E' UN ROUND, NON E' LA SONDA DELL'OROLOGIO E NON DA'
#  NESSUN VERDETTO SU NESSUN MOTORE. Misura UNA cosa sola: QUANTO COSTA
#  una passata di ABTG_SondaOrologio su GBPUSD, e in quale tratto di
#  storico il costo esplode. Produce un CRONOMETRO e una tabella di
#  campioni del banco, non un P/L.
#
#  I QUATTRO PASSI (uno per lancio, si scelgono con -Passo):
#    A  rilegge l'ultimo censimento dello storico (scarica_storico.ps1
#       -SoloReferto) e DATA il file prima di leggerlo. NON apre MT5.
#       -> primo sguardo su H2, e costa un minuto.
#       ESITO GIA' AGLI ATTI (02/09 08:40): "GBPUSD M1 NON CENSITO" --
#       il censimento piu' recente e' del 30/08 e contiene SOLO i tre
#       indici. H2 e' rimasta APERTA, ed e' per questo che esiste A2.
#    A2 MISURA FRESCA del pavimento M1 di GBPUSD ed EURUSD (li chiede
#       nella STESSA corsa, dal 2010.01.01, SENZA tick). APRE MT5 ed e'
#       questione di minuti.
#       -> CHIUDE H2: pavimento dopo il 2011 = H2 confermata;
#          pavimento prima del 2011 = H2 esclusa, restano H1 e H3.
#    B  4 passate su GBPUSD nella finestra RECENTE 2024.10.01 ->
#       2026.06.30, cioe' DENTRO la base a tick reali (pavimento
#       MISURATO il 01/09: 2024.07.05, Diario del tester).
#       -> risponde a P1b
#    C  4 passate su GBPUSD nella finestra VECCHIA 2011.01.01 ->
#       2013.01.01, cioe' SOLO tick GENERATI dalle M1.
#       -> risponde a P1a
#
#  IL METRO DICHIARATO: la ricognizione EURUSD del 31/08 ha fatto
#  218 s per 4 passate su 15,5 anni (54 s a passata). Le finestre B e C
#  sono 9 e 8 volte piu' corte: su un banco sano 4 passate devono
#  costare DECINE di secondi, non minuti. Il referto stampa il rapporto.
#
#  ------------------------------------------------------------------
#  PERCHE' ESISTE QUESTO FILE E NON SI CHIAMA walkforward_generico.ps1
#  A MANO. Sei motivi, tutti e sei pagati altrove:
#
#   1. IL GENERICO NON HA UN CRONOMETRO. Stampa "avvio N pass..." e poi
#      aspetta in silenzio. Ma il numero che questa diagnosi cerca E'
#      il tempo: senza cronometro la corsa non misura niente.
#
#   2-bis. E IL SUO CODICE DI USCITA, SU 5.1, PUO' NON ESSERCI. Misurato
#      sul PC di Claudio il 02/09 alle 08:36: `Start-Process -PassThru`
#      senza `-Wait` ha restituito ExitCode VUOTO anche a processo
#      finito, e `$null -ne 0` e' VERO. Qui il codice di uscita ha TRE
#      stati (0 / diverso da 0 / NON LETTO) e il verdetto si appoggia
#      sempre a un ARTEFATTO DATATO, mai al numero.
#
#   2. IL GENERICO NON HA UN TIMEOUT. Fa (Start-Process ...).WaitForExit()
#      e basta. L'ipotesi H1 dice che la corsa PUO' incagliarsi per ore
#      (il 01/09: 3,5 ore senza completare, stima MT5 64 ore). Qui la
#      corsa ha un tetto (-TimeoutMin) e, se lo sfonda, si FERMA e
#      "INCAGLIATA" diventa IL RISULTATO, non un errore. Senza tetto il
#      piano da "10 minuti" si mangia la notte.
#
#   3. IL GENERICO NON DATA I CSV CHE LEGGE. Classe del 31/08 (il CSV
#      stantio): -Rifai copre il generico che SALTA, non il generico che
#      MUORE. Qui si prende $tCorsa PRIMA della fase e ogni CSV si data:
#      assente / STANTIO / fresco, tre esiti e non due, e le due date
#      finiscono nel referto.
#
#   4. IL GENERICO NON SVUOTA Tester\cache. Il CSV di questa famiglia
#      nasce dai FRAME: un pass ripescato dalla cache NON chiama
#      OnTester(), non manda il frame e la sua riga SPARISCE dal CSV --
#      con la corsa verde e il cronometro che segna un tempo FALSO
#      (sarebbe proprio la spiegazione (i) delle "4 passate veloci" del
#      01/09). Qui la cache si svuota, coi DUE conteggi nel referto.
#
#   5. IL GENERICO NON GUARDA LA MACCHINA. La diagnosi chiede 30 secondi
#      di Task Manager durante lo stallo. Qui la macchina si campiona da
#      sola ogni 20 secondi (RAM libera, commit, agenti e loro CPU/RSS,
#      crescita di bases\<server>\<SIMBOLO>, byte di rete) e i campioni
#      finiscono nel referto: disco/memoria = H1/H3, crescita di bases +
#      rete = H2. Il Task Manager resta come conferma a occhio.
#
#   6. IL GENERICO NON RACCOGLIE I LOG DEL TESTER. "no memory for ticks
#      generating" e il conteggio dei tick stanno nel Giornale e nei log
#      degli AGENT, che NON stanno sotto la cartella dati (checklist
#      34-ter): si scandiscono tutte e tre le radici e il conteggio dei
#      log raccolti finisce nel referto, cosi' lo zero si LEGGE.
#
#  ------------------------------------------------------------------
#  QUELLO CHE QUESTA RIGA NON PUO' DIRE, detto prima:
#   - NON e' la cella 00_gemelli della SONDA DELL'OROLOGIO. Riusa lo
#     STESSO file prova (SONDA_OROLOGIO_00_GEMELLI.txt, magic gemelli
#     777290/777291) ma su un ALTRO SIMBOLO e su ALTRE FINESTRE. I
#     numeri che escono NON entrano nel round della sonda e non si
#     confrontano con la sua tabella: il file prova dichiara
#     @SIMBOLO EURUSD / @DAQUANDO 2011.01.01 / @FINOA 2026.06.30 e qui
#     tutti e tre vengono SCAVALCATI dai parametri di riga di comando
#     (walkforward_generico.ps1 righe 303-305). Il referto lo scrive in
#     testa come RILIEVO, perche' una prosa e un parametro che dicono
#     due finestre diverse sono la classe del 31/08.
#   - NON tocca i CSV del round orologio: l'etichetta e la cartella di
#     lavoro sono altre (vedi "DOVE SCRIVE" qui sotto).
#   - NON giudica nessun motore, non promuove e non boccia niente, non
#     tocca nessuna sedia viva. Il driver generico scrive
#     AllowLiveTrading=false in ogni .ini (riga 638).
#   - NON scarica storico e NON scrive MAI dentro bases\: le legge la
#     dimensione e basta.
#   - il PASSO A rilegge un censimento GIA' FATTO. Se il censimento non
#     contiene GBPUSD, questa riga lo DICE ("NON CENSITO") e non finge
#     che "tutto completo" voglia dire "GBPUSD completa": la misura
#     fresca del pavimento e' un altro lancio (scarica_storico.ps1
#     -Simboli "GBPUSD,EURUSD" -SenzaTick), e costa minuti, non secondi.
#
#  ------------------------------------------------------------------
#  DOVE SCRIVE, e perche' NON sporca il round della sonda:
#   - cartella di lavoro:  %USERPROFILE%\abtg_diag_gbpusd
#     (la sonda usa %USERPROFILE%\abtg_sonda_orologio: alberi separati,
#      quindi anche risultati_prove\ e' un altro)
#   - CSV prodotti:  risultati_prove\ABTG_SondaOrologio\
#       ABTG_SondaOrologio_<SIM>_IS_diagB_recente.csv   (e _OOS_)
#       ABTG_SondaOrologio_<SIM>_OOS_diagC_vecchia.csv  (e _IS_)
#     L'etichetta entra nel nome (walkforward_generico.ps1 righe 607-613)
#     e il simbolo pure: nessuno di questi nomi puo' coincidere con i
#     CSV della sonda, che portano l'Id della cella (03_gbpusd_long...).
#   - COSA CONDIVIDE COL ROUND, e va detto: Tester\cache (che questa
#     riga SVUOTA) e la cartella MQL5\Experts (l'.ex5 ricompilato dallo
#     STESSO sorgente allo STESSO pin). Conseguenza dichiarata: la cache
#     delle celle gia' girate della sonda se ne va, e le celle 03/04
#     GBPUSD del round orologio SONO COMUNQUE DA RIFARE (non sono mai
#     arrivate a un CSV: e' il fatto da cui nasce questa diagnosi).
# =====================================================================
[CmdletBinding()]
param(
  # -Pin NON ha default: un default silenzioso ("lavoro") farebbe girare
  #  la punta del branch spacciandola per un commit congelato.
  [string]$Pin        = "",
  # -Passo NON ha default: "quale dei tre" e' una decisione, non un
  #  ripiego. Un default farebbe partire il passo sbagliato in silenzio.
  [string]$Passo      = "",
  [string]$Simbolo    = "GBPUSD",
  # IL TETTO DELLA CORSA. Non e' una precauzione generica: l'ipotesi che
  # si sta misurando dice che la corsa puo' NON finire. Allo scadere si
  # ferma tutto e "INCAGLIATA" e' il risultato.
  [int]$TimeoutMin    = 15,
  [int]$CampioneSec   = 20,
  [switch]$SoloControllo,          # B/C: gate + compilazione, NON apre il tester
  [int]$Deposito      = 100000,
  [string]$Periodo    = "H1",
  [int]$Modello       = 4
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

$EA      = "ABTG_SondaOrologio"
$Prova   = "SONDA_OROLOGIO_00_GEMELLI.txt"
$Avvio   = Get-Date
# I SECONDI NEL TIMBRO, non solo i minuti: i tre passi si lanciano di
# fila e due giri dello STESSO passo nello stesso minuto scriverebbero
# nella stessa cartella e nello stesso zip, cioe' il secondo referto
# coprirebbe il primo. Un artefatto che sovrascrive il precedente e'
# la classe del giro a vuoto che si porta via il referto della notte
# prima (31/08).
$Stamp   = $Avvio.ToString("yyyyMMdd_HHmmss", $INV)
$Dsk     = Join-Path $env:USERPROFILE "Desktop"
$Work    = Join-Path $env:USERPROFILE "abtg_diag_gbpusd"
$ProveD  = Join-Path $Work "prove"
$RawPin  = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/" + $Pin

# IL METRO, DICHIARATO E NON DEDOTTO: ricognizione EURUSD del 31/08.
$MetroSec      = 218.0        # 4 passate EURUSD su 15,5 anni
$MetroAnni     = 15.5
$TickPavimento = "2024.07.05" # MISURATO il 01/09 (Diario del tester), non dedotto
# L'INIZIO DELLA FINESTRA DELLA SONDA, contro cui si giudica il pavimento
# M1. E' scritto qui e non ereditato: e' il numero che decide H2.
$FinestraSonda = [datetime]::ParseExact("2011.01.01","yyyy.MM.dd",$INV)

# --- TUTTO CIO' CHE LA RACCOLTA USA NASCE QUI, PRIMA DEL try.
#     In PowerShell una `function` non e' dichiarativa, e' un'ISTRUZIONE:
#     se il flusso non ci passa sopra il nome non esiste, e la raccolta
#     esploderebbe proprio nella corsa fermata da un gate, cioe' l'unica
#     in cui il referto serve davvero.
$Problemi   = New-Object System.Collections.ArrayList
$Rilievi    = New-Object System.Collections.ArrayList
$Campioni   = New-Object System.Collections.ArrayList
$RigheLog   = New-Object System.Collections.ArrayList
$CensRighe  = New-Object System.Collections.ArrayList
$Artefatti  = New-Object System.Collections.ArrayList
$Fatale     = ""
# I VALORI DI PARTENZA DICONO "NON CI SONO ARRIVATO", mai "e' andata
# male": un campo lasciato al default in un giro fermato prima NEGHEREBBE
# AGLI ATTI un gate che invece ha girato (punto 94). "NON TENTATA" e
# "TENTATA E FALLITA" sono due fatti diversi e si scrivono diversi.
$Terminale  = "n/d (non cercato: la corsa si e' fermata prima)"
$Compilato  = "NON TENTATA (la corsa si e' fermata prima)"
$CacheTxt   = "NON RAGGIUNTA (la corsa si e' fermata prima)"
$Cronometro = "non misurato"
$EsitoCorsa = "NON ESEGUITA"
$FrescoTxt  = "NON RAGGIUNTA (la corsa non e' arrivata a leggere nessun CSV)"
$RigheCsv   = "n/d"
$Gemelli    = "NON MISURATO (la corsa non e' arrivata a leggere il CSV)"
$PavimentoTxt = "NON MISURATO (nessun pavimento M1 letto in questo giro)"
$RadiciLog  = @()
$LenPrima   = @{}
$RcTxt      = "non pertinente (nessun processo figlio lanciato in questo passo)"
$Secondi    = -1.0
$LogRaccolti= -1
$DaQuando   = ""
$Fino       = ""
$Etichetta  = ""
$Titolo     = ""

function Ora(){ return (Get-Date).ToString("HH:mm:ss", $INV) }
function Dico([string]$t,[string]$c="Gray"){ Write-Host ("[" + (Ora) + "] " + $t) -ForegroundColor $c }
function Testata([string]$t){ Write-Host ""; Write-Host ("=== " + $t + " ===") -ForegroundColor Cyan }

function Scarica([string]$url,[string]$dest){
  Remove-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue
  Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing -ErrorAction Stop
  if(-not (Test-Path -LiteralPath $dest)){ throw ("scarico fallito: " + $url) }
}

function RigheVive([string]$p){
  return @(Get-Content -LiteralPath $p | Where-Object { $_ -notmatch '^\s*#' -and $_ -notmatch '^\s*$' })
}

# --- LA CONVENZIONE DI SENTINELLA. Un numero non misurato non esce mai
#     come numero plausibile: esce "n/d". Un conteggio negativo non
#     esiste, quindi il negativo E' la sentinella.
function FmtN($v){ if($null -eq $v){ return "n/d" }; if([int]$v -lt 0){ return "n/d" }; return ([int]$v).ToString($INV) }
function Fmt1($v){ if($null -eq $v){ return "n/d" }; return ([double]$v).ToString("0.0",$INV) }
function Fmt2($v){ if($null -eq $v){ return "n/d" }; return ([double]$v).ToString("0.00",$INV) }
# Fmt1S: grandezze che possono essere negative per davvero (delta di
#   rete, delta di dimensione): qui il negativo NON e' sentinella e non
#   si tocca. Applicare la sentinella di FmtN cancellerebbe meta' della
#   misura scambiandola per un dato mancante (punto 66 al rovescio).
function Fmt1S($v){ if($null -eq $v){ return "n/d" }; return ([double]$v).ToString("0.0",$INV) }

# --- NUMERI DAL CSV: SEMPRE con InvariantCulture. Sul PC in italiano
#     [double]"2.0" senza cultura fa VENTI (difetto del 17/08 notte).
function NumInv($s){
  $v = 0.0
  $t = ("" + $s).Replace([string][char]160,"").Replace(" ","").Trim()
  if($t -eq ""){ return $null }
  if([double]::TryParse($t,[Globalization.NumberStyles]::Float,$INV,[ref]$v)){ return $v }
  return $null
}

# =====================================================================
#  IL CAMPIONATORE DEL BANCO. E' il Task Manager, misurato.
#  Niente Get-Counter: i nomi dei contatori di prestazione sono
#  LOCALIZZATI e su Windows in italiano '\Memory\Committed Bytes' non
#  esiste (si chiama '\Memoria\Byte di commit'). Le classi CIM invece
#  hanno lo stesso nome in tutte le lingue.
# =====================================================================
function DimBases([string]$dataFolder,[string]$sym){
  # SOLO LETTURA. bases\ non si tocca MAI in scrittura (regola di casa).
  $tot = [double]0
  $trovata = $false
  $b = Join-Path $dataFolder "bases"
  if(-not (Test-Path -LiteralPath $b)){ return -1.0 }
  try{
    foreach($srv in @(Get-ChildItem -LiteralPath $b -Directory -ErrorAction SilentlyContinue)){
      foreach($sub in @("history","ticks")){
        $p = Join-Path (Join-Path $srv.FullName $sub) $sym
        if(-not (Test-Path -LiteralPath $p)){ continue }
        $trovata = $true
        $m = Get-ChildItem -LiteralPath $p -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum
        if($m -and $m.Sum){ $tot += [double]$m.Sum }
      }
    }
  }catch{ return -1.0 }
  if(-not $trovata){ return -1.0 }
  return ($tot/1MB)
}

function BytesRete(){
  try{
    $n = @(Get-CimInstance Win32_PerfRawData_Tcpip_NetworkInterface -ErrorAction Stop)
    $s = [double]0
    foreach($i in $n){ $s += [double]$i.BytesTotalPersec }
    return $s
  }catch{ return -1.0 }
}

function Campiona([datetime]$t0,[string]$dataFolder,[string]$sym,[double]$netZero){
  $sec = (New-TimeSpan -Start $t0 -End (Get-Date)).TotalSeconds
  $ramLib = $null; $commit = $null
  try{
    $os = Get-CimInstance Win32_OperatingSystem -ErrorAction Stop
    $ramLib = [double]$os.FreePhysicalMemory/1024.0
    # commit USATO = limite di commit meno commit libero. Sono KB.
    $commit = ([double]$os.TotalVirtualMemorySize - [double]$os.FreeVirtualMemory)/1024.0
  }catch{}
  $np = 0; $cpu = 0.0; $rss = 0.0
  try{
    $pl = @(Get-Process metatester64,terminal64 -ErrorAction SilentlyContinue)
    $np = @($pl).Count
    foreach($pr in $pl){
      try{ if($null -ne $pr.CPU){ $cpu += [double]$pr.CPU } }catch{}
      try{ $w = [double]$pr.WorkingSet64/1MB; if($w -gt $rss){ $rss = $w } }catch{}
    }
  }catch{}
  $bas = DimBases $dataFolder $sym
  $net = BytesRete
  $dnet = $null
  if($net -ge 0 -and $netZero -ge 0){ $dnet = ($net - $netZero)/1MB }
  $riga = "[" + (Ora) + "] +" + (Fmt1 $sec) + " s" +
          " | RAM libera " + (Fmt1 $ramLib) + " MB" +
          " | commit " + (Fmt1 $commit) + " MB" +
          " | proc tester " + $np + " (CPU " + (Fmt1 $cpu) + " s, RSS max " + (Fmt1 $rss) + " MB)" +
          " | bases " + $sym + " " + (Fmt1 $bas) + " MB" +
          " | rete +" + (Fmt1S $dnet) + " MB"
  return $riga
}

# =====================================================================
#  I LOG DEL TESTER. LE RADICI SONO CINQUE, e gli AGENT NON stanno sotto
#  la cartella dati (checklist 34-ter: la radice sbagliata). Si fotografa
#  la lunghezza PRIMA e si legge SOLO cio' che e' cresciuto: un file non
#  cresciuto e' il log di IERI, e leggerlo da capo e' il difetto del
#  18/08 (il "=== FINITO" di ieri preso per quello di oggi).
# =====================================================================
function FotografaLog([string]$dataFolder,[string]$instDir){
  $script:RadiciLog = @(
    (Join-Path $env:APPDATA "MetaQuotes\Tester"),
    (Join-Path $dataFolder "Tester"),
    (Join-Path $instDir "Tester"),
    (Join-Path $dataFolder "Logs"),
    (Join-Path $dataFolder "MQL5\Logs")
  )
  $script:LenPrima = @{}
  foreach($rad in $script:RadiciLog){
    if(-not (Test-Path -LiteralPath $rad)){ continue }
    foreach($f in @(Get-ChildItem -LiteralPath $rad -Recurse -File -Filter "*.log" -ErrorAction SilentlyContinue)){
      $script:LenPrima[$f.FullName] = $f.Length
    }
  }
  Dico ("log gia' presenti nelle 5 radici, fotografati: " + $script:LenPrima.Count) "DarkGray"
}

function RaccogliLog(){
  $script:LogRaccolti = 0
  $pattern = 'tick|ticks|memory|generat|history|Symbol|core|agent|EURUSD|' + [regex]::Escape($Simbolo)
  foreach($rad in $script:RadiciLog){
    if(-not (Test-Path -LiteralPath $rad)){ continue }
    foreach($f in @(Get-ChildItem -LiteralPath $rad -Recurse -File -Filter "*.log" -ErrorAction SilentlyContinue)){
      $da = 0
      if($script:LenPrima.ContainsKey($f.FullName)){ $da = [int64]$script:LenPrima[$f.FullName] }
      if($f.Length -le $da){ continue }
      $script:LogRaccolti++
      $testo = ""
      try{
        $fs = New-Object System.IO.FileStream($f.FullName,[System.IO.FileMode]::Open,[System.IO.FileAccess]::Read,[System.IO.FileShare]::ReadWrite)
        if($da -gt 0){ [void]$fs.Seek($da,[System.IO.SeekOrigin]::Begin) }
        $sr = New-Object System.IO.StreamReader($fs)
        $testo = $sr.ReadToEnd(); $sr.Close(); $fs.Close()
      }catch{}
      foreach($l in ($testo -split "`r?`n")){
        if($l -match $pattern){ [void]$RigheLog.Add(($f.Name + ": " + $l.Trim())) }
      }
      try{ Copy-Item -LiteralPath $f.FullName -Destination (Join-Path $Work ("log_" + $f.Name)) -Force -ErrorAction SilentlyContinue }catch{}
    }
  }
  Dico ("log CRESCIUTI in questo giro (5 radici): " + $script:LogRaccolti + "   righe interessanti: " + $RigheLog.Count) "Cyan"
  if($script:LogRaccolti -eq 0){
    [void]$Rilievi.Add("NESSUN log e' cresciuto durante questo giro nelle cinque radici scandite (" + ($script:RadiciLog -join " ; ") + "). Zero non vuol dire 'non e' successo niente': vuol dire che non ho trovato traccia scritta. Il conteggio dei tick e l'eventuale 'no memory for ticks generating' vanno cercati a mano nel Diario di MT5.")
  }
}

# =====================================================================
#  IL TERMINALE. UN SOLO SELETTORE PER TUTTI I PASSI, ed e' copiato
#  RIGA PER RIGA da walkforward_generico.ps1 (righe 545-548) e da
#  RIGA_SONDA_OROLOGIO.ps1 (681-683). Su una macchina con due istanze
#  due selettori diversi scelgono terminali diversi: e' il punto 37.
# =====================================================================
function TrovaTerminale(){
  $allTerm = @(Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue)
  $cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*" } | Select-Object -First 1
  if(-not $cand){ $cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets*" } | Select-Object -First 1 }
  if(-not $cand){ throw "terminale BCM non trovato: e' lo stesso selettore di walkforward_generico.ps1 (righe 545-548)." }
  $inst = $cand.DirectoryName
  $tr   = Join-Path $env:APPDATA "MetaQuotes\Terminal"
  $dati = (Get-ChildItem -LiteralPath $tr -Directory -ErrorAction SilentlyContinue | Where-Object { $o = Join-Path $_.FullName "origin.txt"; (Test-Path -LiteralPath $o) -and ((Get-Content -LiteralPath $o -Raw).Trim() -ieq $inst) } | Select-Object -First 1 -ExpandProperty FullName)
  if(-not $dati){ throw ("cartella dati MT5 non trovata per " + $inst) }
  return @{ Inst=$inst; Dati=$dati }
}

# =====================================================================
#  LANCIA UN FIGLIO CON GUARDIA DI TEMPO E CAMPIONAMENTO DEL BANCO,
#  E LEGGE IL CODICE DI USCITA IN MODO **5.1-SAFE**.
# ---------------------------------------------------------------------
#  DIFETTO PAGATO IL 02/09/2026, ORE 08:36, SUL PC DI CLAUDIO (v1 di
#  questa stessa riga -- primo giro a vuoto):
#    Windows PowerShell 5.1 ha restituito **ExitCode VUOTO** ($null) su
#    un processo avviato con `Start-Process -PassThru` senza `-Wait`,
#    ANCHE dopo che `$proc.HasExited` era diventato vero. La v1 faceva
#      try{ $rc = $proc.ExitCode }catch{ $rc = -1 };  if($rc -ne 0){ ... }
#    e su PowerShell **`$null -ne 0` e' VERO**: il giro a vuoto e'
#    uscito "FERMATA DAL DRIVER GENERICO (codice )" -- con la parentesi
#    VUOTA -- mentre il driver generico aveva fatto tutto giusto in 9,1
#    secondi. Un FALSO ALLARME che ha bloccato la serata.
#  LE DUE REGOLE CHE NE ESCONO, applicate qui:
#   1. TRE STATI, NON DUE: 0 / N diverso da 0 / **NON LETTO**. Un codice
#      non letto NON e' un fallimento, ed esce scritto "NON LETTO" nel
#      referto, mai come una parentesi vuota che nessuno sa leggere.
#   2. IL VERDETTO NON SI APPOGGIA AL NUMERO, SI APPOGGIA A UN
#      **ARTEFATTO DATATO**. Il codice di uscita, quando c'e', conferma;
#      quando non c'e', si tira avanti e decide l'artefatto.
# =====================================================================
function EseguiConGuardia($argv,[string]$dataFolder,[string]$sym){
  $tCorsa  = Get-Date
  $netZero = BytesRete
  $proc = Start-Process -FilePath "powershell" -ArgumentList $argv -NoNewWindow -PassThru
  $scade = $tCorsa.AddMinutes($TimeoutMin)
  $incagliata = $false
  $prossimo = (Get-Date).AddSeconds($CampioneSec)
  while(-not $proc.HasExited){
    Start-Sleep -Milliseconds 500
    if((Get-Date) -ge $prossimo){
      $riga = Campiona $tCorsa $dataFolder $sym $netZero
      [void]$Campioni.Add($riga)
      Write-Host $riga -ForegroundColor DarkCyan
      $prossimo = (Get-Date).AddSeconds($CampioneSec)
    }
    if((Get-Date) -ge $scade){ $incagliata = $true; break }
  }
  $sec = (New-TimeSpan -Start $tCorsa -End (Get-Date)).TotalSeconds
  $rc = -1; $rcLetto = $false; $rcTxt = ""
  if($incagliata){
    $riga = Campiona $tCorsa $dataFolder $sym $netZero
    [void]$Campioni.Add("ULTIMO CAMPIONE PRIMA DI FERMARE: " + $riga)
    Write-Host ""
    Dico ("TETTO DI " + $TimeoutMin + " MINUTI SFONDATO: fermo tutto. QUESTO E' IL RISULTATO, non un guasto.") "Red"
    try{ Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue }catch{}
    Start-Sleep -Seconds 2
    Get-Process metatester64,terminal64 -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 3
    $rcTxt = "non pertinente: la corsa e' stata FERMATA dal tetto, non e' uscita da sola"
  }
  else{
    # WaitForExit() su un processo gia' uscito costa zero e FORZA la
    # sincronizzazione dell'oggetto: e' il gesto che su 5.1 fa la
    # differenza fra un ExitCode leggibile e uno vuoto. Non basta da
    # solo -- per questo sotto c'e' comunque il ramo "NON LETTO".
    try{ $proc.WaitForExit() }catch{}
    try{ $proc.Refresh() }catch{}
    $grezzo = $null
    try{ $grezzo = $proc.ExitCode }catch{ $grezzo = $null }
    if($null -ne $grezzo -and (("" + $grezzo).Trim()) -match '^-?\d+$'){
      $rc = [int](("" + $grezzo).Trim()); $rcLetto = $true; $rcTxt = "" + $rc
    }
    else{
      # LA RIGA DEL REFERTO RESTA CORTA E LEGGIBILE; la spiegazione lunga
      # sta UNA volta sola, nei RILIEVI. Un referto in cui una riga di
      # intestazione e' un paragrafo non lo rilegge nessuno.
      $rcTxt = "NON LETTO (ExitCode vuoto su PS 5.1) -- NON e' un fallimento: vedi RILIEVI"
      [void]$Rilievi.Add("CODICE DI USCITA DEL FIGLIO NON LEGGIBILE (ExitCode vuoto su Windows PowerShell 5.1, Start-Process -PassThru). Non e' un fallimento e non e' un successo: e' un dato che non c'e'. Il verdetto di questo passo e' stato preso sugli ARTEFATTI datati (vedi le righe 'date:' / 'righe:' qui sotto), come prescrive la regola.")
    }
    Dico ("figlio uscito dopo " + (Fmt1 $sec) + " s -- codice di uscita: " + $rcTxt) "Cyan"
  }
  return @{ TCorsa=$tCorsa; Secondi=$sec; Incagliata=$incagliata; Rc=$rc; RcLetto=$rcLetto; RcTxt=$rcTxt }
}

# =====================================================================
#  LEGGI IL CENSIMENTO DELLO STORICO -- la usano il PASSO A (rilettura di
#  quello che c'e' gia') e il PASSO A2 (misura appena fatta).
#    $tMin = $null  -> si legge il piu' recente e se ne DICHIARA l'eta'
#    $tMin = data   -> il CSV DEVE essere piu' NUOVO di quella data:
#                      se e' piu' vecchio e' di un ALTRO giro e NON si
#                      legge (classe CSV stantio del 31/08).
#  Scrive in $script:EsitoCorsa e $script:PavimentoTxt; riempie
#  $CensRighe / $Problemi / $Artefatti, che sono ArrayList: si MUTANO,
#  non si riassegnano, quindi dalla funzione si vedono senza $script:.
# =====================================================================
function CensimentoLeggi($tMin){
  $fresco = ($null -ne $tMin)
  $tag = 'A'
  if($fresco){ $tag = 'A2' }
  $termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
  $trovati = @()
  if(Test-Path -LiteralPath $termRoot){
    $trovati = @(Get-ChildItem -LiteralPath $termRoot -Directory -ErrorAction SilentlyContinue | ForEach-Object {
      $csv = Join-Path $_.FullName "MQL5\Files\ABTG_StoricoScaricato.csv"
      if(Test-Path -LiteralPath $csv){
        $org = "origin.txt assente"
        $o = Join-Path $_.FullName "origin.txt"
        if(Test-Path -LiteralPath $o){ try{ $org = (Get-Content -LiteralPath $o -Raw).Trim() }catch{} }
        [pscustomobject]@{ Csv=$csv; Origine=$org; Quando=(Get-Item -LiteralPath $csv).LastWriteTime }
      }
    })
  }
  if(@($trovati).Count -eq 0){
    $script:EsitoCorsa = "" + $tag + ": CENSIMENTO ASSENTE"
    [void]$Problemi.Add("Nessun ABTG_StoricoScaricato.csv sotto " + $termRoot + ": il censimento dello storico NON esiste su questa macchina. Il pavimento M1 di " + $Simbolo + " non e' misurato, e H2 resta APERTA. Prossimo passo: scarica_storico.ps1 -Simboli " + [char]34 + "GBPUSD,EURUSD" + [char]34 + " -SenzaTick (minuti, apre MT5).")
    Dico "NESSUN CENSIMENTO TROVATO." "Red"
  }
  else{
    foreach($t in @($trovati | Sort-Object Quando -Descending)){
      $eta = (New-TimeSpan -Start $t.Quando -End $Avvio).TotalDays
      [void]$CensRighe.Add("CSV: " + $t.Csv)
      [void]$CensRighe.Add("  origine ......... " + $t.Origine)
      [void]$CensRighe.Add("  scritto il ...... " + $t.Quando.ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   (" + (Fmt1 $eta) + " giorni fa)")
      Dico ("censimento: " + $t.Csv) "Cyan"
      Dico ("  scritto il " + $t.Quando.ToString("yyyy-MM-dd HH:mm:ss",$INV) + " (" + (Fmt1 $eta) + " giorni fa) -- origine " + $t.Origine) "Yellow"
    }
    # SI LEGGE IL PIU' RECENTE, e si dice che e' quello.
    $capo = @($trovati | Sort-Object Quando -Descending)[0]
    $etaCapo = (New-TimeSpan -Start $capo.Quando -End $Avvio).TotalDays
    # --- IL CANCELLO DI FRESCHEZZA DEL PASSO A2. Qui non e' una nota:
    #     se il CSV e' PRECEDENTE all'avvio della misura, la misura NON
    #     e' avvenuta e questo file e' quello di prima. Si esce senza
    #     leggere nemmeno una riga: leggerlo darebbe numeri plausibili e
    #     di un altro giorno (classe CSV stantio del 31/08).
    if($fresco -and $capo.Quando -lt $tMin){
      [void]$CensRighe.Add("")
      [void]$CensRighe.Add("!!! CSV STANTIO: scritto il " + $capo.Quando.ToString("yyyy-MM-dd HH:mm:ss",$INV) + ", cioe' PRIMA dell'avvio di questa misura (" + ([datetime]$tMin).ToString("yyyy-MM-dd HH:mm:ss",$INV) + ").")
      [void]$CensRighe.Add("    NON e' stato letto: e' il censimento di PRIMA.")
      $script:EsitoCorsa = "" + $tag + ": CSV STANTIO (la misura non ha prodotto niente)"
      $script:PavimentoTxt = "NON MISURATO: il CSV e' quello di prima (vedi PROBLEMI)."
      [void]$Problemi.Add("IL CENSIMENTO NON E' STATO RISCRITTO: il CSV e' del " + $capo.Quando.ToString("yyyy-MM-dd HH:mm:ss",$INV) + ", questa misura e' partita alle " + ([datetime]$tMin).ToString("yyyy-MM-dd HH:mm:ss",$INV) + ". Vuol dire che ABTG_HistoryDownloader non e' mai arrivato a scrivere (MT5 non e' partito, lo script non e' stato eseguito dal profilo, la compilazione e' fallita). Il pavimento M1 di " + $Simbolo + " resta NON MISURATO e H2 resta APERTA. Guarda i log nello zip.")
      [void]$Artefatti.Add($capo.Csv)
      return
    }
    $righeCens = @()
    try{ $righeCens = @(Import-Csv -LiteralPath $capo.Csv) }catch{ $righeCens = @() }
    [void]$CensRighe.Add("")
    [void]$CensRighe.Add("LETTO IL PIU' RECENTE: " + $capo.Csv + "  (" + $capo.Quando.ToString("yyyy-MM-dd HH:mm:ss",$INV) + ")")
    [void]$CensRighe.Add("righe totali: " + @($righeCens).Count)
    if(@($righeCens).Count -eq 0){
      $script:EsitoCorsa = "" + $tag + ": CENSIMENTO ILLEGGIBILE"
      [void]$Problemi.Add("Il CSV del censimento c'e' (" + $capo.Csv + ", del " + $capo.Quando.ToString("yyyy-MM-dd HH:mm",$INV) + ") ma NON si legge come CSV o e' vuoto: il pavimento M1 di " + $Simbolo + " resta NON MISURATO.")
    }
    else{
      $cols = @($righeCens[0].PSObject.Properties.Name)
      [void]$CensRighe.Add("colonne: " + ($cols -join " | "))
      # Le colonne si cercano PER NOME. Se mancano, e' un PROBLEMA, non
      # un trattino silenzioso (punto 80).
      $manc = @()
      foreach($c in @("Simbolo","Timeframe","PrimaDataLocale")){ if($cols -notcontains $c){ $manc += $c } }
      if(@($manc).Count -gt 0){
        $script:EsitoCorsa = "" + $tag + ": CENSIMENTO SENZA LE COLONNE ATTESE"
        [void]$Problemi.Add("Il censimento non ha le colonne " + ($manc -join ", ") + ": intestazioni viste = " + ($cols -join " | ") + ". Non si legge nessun pavimento da questo file.")
      }
      else{
        $simIntr = @($Simbolo,"EURUSD")
        $vistoBersaglio = $false
        # LE RIGHE SI CONTANO, non si fa Test-Path sul file: la classe
        # 106 dice che il file c'e' sempre e parla dei simboli dell'ULTIMA
        # corsa. La domanda e' "c'e' la RIGA <SIM> M1?", e per il passo A2
        # la risposta deve essere SI per TUTTI E DUE i simboli, perche'
        # scarica_storico.ps1 azzera il CSV (riga 230): se li avessimo
        # chiesti in due lanci, il secondo avrebbe cancellato il primo.
        $nM1 = @{}
        foreach($s in $simIntr){ $nM1[$s] = 0 }
        [void]$CensRighe.Add("")
        [void]$CensRighe.Add("RIGHE M1 DEI SIMBOLI CHE CONTANO:")
        Write-Host ""
        Write-Host "    simbolo  TF   barre        PrimaDataLocale   PrimaDataServer   verdetto" -ForegroundColor Gray
        foreach($s in $simIntr){
          $rr = @($righeCens | Where-Object { ("" + $_.Simbolo).Trim() -ieq $s -and ("" + $_.Timeframe).Trim() -ieq "M1" })
          if(@($rr).Count -eq 0){
            [void]$CensRighe.Add("  " + $s + " M1: NON CENSITO (nessuna riga in questo CSV)")
            Write-Host ("    " + $s + "  M1   -- NON CENSITO in questo CSV --") -ForegroundColor Red
            if($s -ieq $Simbolo){
              [void]$Problemi.Add($s + " M1 NON E' NEL CENSIMENTO piu' recente (" + $capo.Quando.ToString("yyyy-MM-dd HH:mm",$INV) + "): scarica_storico.ps1 cancella il CSV a ogni corsa (riga 230) e ci mette SOLO i simboli di QUELLA corsa. Un referto 'tutto COMPLETO' su altri simboli NON dice niente su " + $s + ". Il pavimento M1 di " + $s + " resta NON MISURATO e H2 resta APERTA: la misura fresca e' scarica_storico.ps1 -Simboli " + [char]34 + "GBPUSD,EURUSD" + [char]34 + " -SenzaTick (minuti, apre MT5).")
            }
          }
          else{
            $nM1[$s] = @($rr).Count
            foreach($r in $rr){
              $vistoBersaglio = $true
              $barre = "" + $r.Barre
              $pdl   = ("" + $r.PrimaDataLocale).Trim()
              $pds   = ""
              if($cols -contains "PrimaDataServer"){ $pds = ("" + $r.PrimaDataServer).Trim() }
              $vrd   = ""
              if($cols -contains "Verdetto"){ $vrd = ("" + $r.Verdetto).Trim() }
              [void]$CensRighe.Add("  " + $s + " M1: barre " + $barre + " | PrimaDataLocale " + $pdl + " | PrimaDataServer " + $pds + " | " + $vrd)
              Write-Host ("    " + $s + "  M1   " + $barre + "   " + $pdl + "   " + $pds + "   " + $vrd) -ForegroundColor White
              if($s -ieq $Simbolo){
                # IL CONFRONTO CHE DECIDE H2: il pavimento M1 LOCALE
                # contro il 2011.01.01 della finestra della sonda.
                $d = $null
                try{ $d = [datetime]::ParseExact($pdl.Substring(0,10),"yyyy.MM.dd",$INV) }catch{
                  try{ $d = [datetime]::Parse($pdl,$INV) }catch{ $d = $null }
                }
                if($null -eq $d){
                  [void]$Problemi.Add($s + " M1: PrimaDataLocale = '" + $pdl + "' non si legge come data. Il pavimento resta NON MISURATO.")
                }
                elseif($d -gt $FinestraSonda){
                  $script:PavimentoTxt = "PAVIMENTO M1 LOCALE DI " + $s + " = " + $d.ToString("yyyy.MM.dd",$INV) + "  ->  E' DOPO il " + $FinestraSonda.ToString("yyyy.MM.dd",$INV) + " della finestra della sonda."
                  if($fresco){ $script:PavimentoTxt = $script:PavimentoTxt + "  ==> H2 CONFERMATA." }
                  else       { $script:PavimentoTxt = $script:PavimentoTxt + "  (misura VECCHIA: indizio per H2, non conferma.)" }
                  [void]$Problemi.Add("PAVIMENTO M1 LOCALE DI " + $s + " = " + $d.ToString("yyyy.MM.dd",$INV) + ", cioe' DOPO il " + $FinestraSonda.ToString("yyyy.MM.dd",$INV) + " su cui gira la finestra della sonda. E' la predizione P2a. Il pavimento si MISURA e la finestra si DICHIARA da li' (regola di casa: la profondita' si misura, non si assume).")
                }
                else{
                  $script:PavimentoTxt = "PAVIMENTO M1 LOCALE DI " + $s + " = " + $d.ToString("yyyy.MM.dd",$INV) + "  ->  COPRE il " + $FinestraSonda.ToString("yyyy.MM.dd",$INV) + " della finestra della sonda."
                  if($fresco){ $script:PavimentoTxt = $script:PavimentoTxt + "  ==> H2 ESCLUSA: le M1 ci sono. Restano H1 e H3, e le decidono i PASSI B e C." }
                  else       { $script:PavimentoTxt = $script:PavimentoTxt + "  (misura VECCHIA: non chiude H2, che chiede 'ci sono ANCORA?'.)" }
                  Dico ("pavimento M1 locale di " + $s + " = " + $d.ToString("yyyy.MM.dd",$INV) + ": COPRE il " + $FinestraSonda.ToString("yyyy.MM.dd",$INV) + " della finestra della sonda.") "Green"
                }
              }
            }
          }
        }
        [void]$CensRighe.Add("")
        [void]$CensRighe.Add("conteggio righe M1: " + (($simIntr | ForEach-Object { $_ + "=" + $nM1[$_] }) -join "  "))
        # --- IL PASSO A2 PRETENDE TUTTI E DUE I SIMBOLI, e li pretende
        #     nella STESSA corsa: uno solo vorrebbe dire che il confronto
        #     GBPUSD-contro-EURUSD, che e' meta' della domanda, non si puo'
        #     fare -- e rifarlo dopo cancellerebbe questo (classe 106).
        if($fresco){
          $mancaM1 = @($simIntr | Where-Object { $nM1[$_] -lt 1 })
          if(@($mancaM1).Count -gt 0){
            [void]$Problemi.Add("LA MISURA FRESCA NON HA PRODOTTO LA RIGA M1 DI: " + ($mancaM1 -join ", ") + " (conteggio: " + (($simIntr | ForEach-Object { $_ + "=" + $nM1[$_] }) -join ", ") + "). Il downloader non e' arrivato in fondo su quel simbolo. ATTENZIONE: non basta rilanciare per il simbolo mancante -- scarica_storico.ps1 AZZERA il CSV a ogni corsa (riga 230), quindi si rilancia il PASSO A2 INTERO, con tutti e due i simboli insieme.")
          }
        }
        if($etaCapo -gt 2.0 -and -not $fresco){
          [void]$Problemi.Add("CENSIMENTO STANTIO: il CSV letto e' del " + $capo.Quando.ToString("yyyy-MM-dd HH:mm",$INV) + ", cioe' " + (Fmt1 $etaCapo) + " giorni fa. Dice cosa c'era sul disco ALLORA, non oggi -- ed e' esattamente la domanda di H2 ('ci sono ANCORA?'). Si legge come indizio, non come misura di oggi.")
        }
        if($vistoBersaglio -and $Problemi.Count -eq 0){ $script:EsitoCorsa = "" + $tag + ": CENSIMENTO LETTO E FRESCO" }
        elseif($vistoBersaglio){ $script:EsitoCorsa = "" + $tag + ": CENSIMENTO LETTO CON RISERVE" }
        else{ $script:EsitoCorsa = "" + $tag + ": " + $Simbolo + " M1 NON CENSITO" }
      }
    }
    [void]$Artefatti.Add($capo.Csv)
  }
}
# =====================================================================
#  LE DUE FINESTRE, SCRITTE QUI E NON EREDITATE DA NESSUN DEFAULT.
#  Classe del 31/08: "nessuna data di un wrapper e' un default
#  ereditato". Che 2026.06.30 sia anche il default di
#  walkforward_generico.ps1 (riga 62) e' una coincidenza, e qui e' una
#  coincidenza DICHIARATA: la finestra B finisce li' perche' li'
#  finisce la finestra della sonda che si sta diagnosticando.
# =====================================================================
if($Passo -eq "B"){
  $DaQuando = "2024.10.01"; $Fino = "2026.06.30"; $Etichetta = "diagB_recente"
  $Titolo = "B -- FINESTRA RECENTE (dentro la base a TICK REALI, pavimento misurato " + $TickPavimento + ")"
}
if($Passo -eq "C"){
  $DaQuando = "2011.01.01"; $Fino = "2013.01.01"; $Etichetta = "diagC_vecchia"
  $Titolo = "C -- FINESTRA VECCHIA (SOLO tick GENERATI dalle barre M1)"
}
if($Passo -eq "A"){  $Titolo = "A -- CENSIMENTO DELLO STORICO GIA' FATTO (nessun MT5 aperto)" }
if($Passo -eq "A2"){ $Titolo = "A2 -- CENSIMENTO FRESCO: misura del PAVIMENTO M1 di " + $Simbolo + " e EURUSD (APRE MT5, minuti)" }

try{
  Testata ("DIAGNOSI GBPUSD LENTA -- PASSO " + $Passo)

  # -------------------------------------------------------------------
  #  0. LE GUARDIE, PRIMA DI TOCCARE QUALUNQUE COSA
  # -------------------------------------------------------------------
  if($Pin -eq ""){ throw "-Pin obbligatorio: senza, girerebbe la punta del branch spacciandola per un commit congelato." }
  if($Pin -notmatch '^[0-9a-f]{40}$'){ throw ("-Pin deve essere un commit di 40 caratteri esadecimali, ricevuto: " + $Pin) }
  if(@("A","A2","B","C") -notcontains $Passo){ throw ("-Passo deve essere A, A2, B o C, ricevuto: '" + $Passo + "'. A = rilettura del censimento gia' fatto (NON apre MT5); A2 = censimento FRESCO, misura del pavimento M1 (APRE MT5, minuti); B = 4 passate finestra RECENTE; C = 4 passate finestra VECCHIA.") }
  if($Simbolo -notmatch '^[A-Za-z0-9_]{3,20}$'){ throw ("-Simbolo non e' un simbolo: '" + $Simbolo + "'") }
  if($TimeoutMin -lt 1 -or $TimeoutMin -gt 180){ throw ("-TimeoutMin fuori scala: " + $TimeoutMin + " (ammessi 1-180)") }
  if($CampioneSec -lt 5 -or $CampioneSec -gt 120){ throw ("-CampioneSec fuori scala: " + $CampioneSec + " (ammessi 5-120)") }
  if($Periodo -ne "H1"){ throw ("-Periodo e' " + $Periodo + ": il file prova dichiara @PERIODO H1 e il cronometro va confrontato col metro EURUSD, che e' H1. Su un altro TF il numero non si confronta con niente.") }
  # LA GUARDIA CHE PROTEGGE ANCHE DAL VPS: sul VPS terminal64 e' SEMPRE
  # aperto (ci girano gli EA in forward), quindi questa riga li' si
  # rifiuta di partire PRIMA di poter fare qualunque danno. E sul PC di
  # backtest e' la guardia di sempre: col terminale aperto il tester non
  # gira e escono zero CSV.
  if(Get-Process terminal64,metaeditor64 -ErrorAction SilentlyContinue){
    throw "MT5 O METAEDITOR APERTO: col terminale aperto il tester non gira (zero CSV) e con MetaEditor aperto la compilazione torna subito senza compilare. Chiudili e rilancia. (E se stai leggendo questo SUL VPS: questa riga sul VPS non ci va mai.)"
  }

  Dico ("pin ......... " + $Pin)
  Dico ("passo ....... " + $Titolo)
  Dico ("simbolo ..... " + $Simbolo)
  New-Item -ItemType Directory -Force -Path $Work,$ProveD | Out-Null

  # --- se il pin cambia, gli artefatti scaricati e i CSV vanno via:
  #     senza, i file di ieri passerebbero i gate di oggi e il gate di
  #     idempotenza del driver generico riproporrebbe CSV vecchi.
  $pinFile = Join-Path $Work "pin_corrente.txt"
  $pinVecchio = ""
  if(Test-Path -LiteralPath $pinFile){ $pinVecchio = (Get-Content -LiteralPath $pinFile -Raw).Trim() }
  if($pinVecchio -ne $Pin){
    Remove-Item -LiteralPath $ProveD -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath (Join-Path $Work "risultati_prove") -Recurse -Force -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Force -Path $ProveD | Out-Null
    if($pinVecchio -ne ""){ Dico ("pin cambiato (" + $pinVecchio + " -> " + $Pin + "): artefatti scaricati e CSV CANCELLATI.") "Yellow" }
    Set-Content -LiteralPath $pinFile -Value $Pin -Encoding ASCII
  }

  # ===================================================================
  #  PASSO A -- IL CENSIMENTO GIA' FATTO, DATATO PRIMA DI LEGGERLO
  # ===================================================================
  if($Passo -eq "A"){
    Testata "A1. SCARICO scarica_storico.ps1 AL PIN"
    $ss = Join-Path $Work "scarica_storico.ps1"
    Scarica ($RawPin + "/backtest_pipeline/scarica_storico.ps1") $ss
    $txtSs = Get-Content -LiteralPath $ss -Raw
    # IL PARAMETRO ESISTE DAVVERO? Non si lancia un interruttore letto in
    # un commento: si guarda il param(). E lo script SENZA [CmdletBinding()]
    # non rifiuta i parametri che non conosce (punto 71): un refuso qui
    # diventerebbe la CORSA VERA, cioe' MT5 aperto e ore di download.
    if($txtSs -notmatch '(?m)^\s*\[switch\]\s*\$SoloReferto\s*,?\s*$'){
      throw 'scarica_storico.ps1 al pin NON dichiara [switch] $SoloReferto nel param(): non lancio niente. Senza quell''interruttore lo script partirebbe in modalita'' INSTALLA/SCARICA, che apre MT5 e costa minuti.'
    }
    if($txtSs -notmatch 'PrimaDataLocale'){
      throw "scarica_storico.ps1 al pin non nomina la colonna PrimaDataLocale: non e' lo strumento che il piano diagnostico chiede."
    }
    Dico "scarica_storico.ps1 scaricato al pin, -SoloReferto e PrimaDataLocale VERIFICATI nel file" "Green"

    Testata "A2. IL REFERTO UFFICIALE (scarica_storico.ps1 -SoloReferto)"
    Write-Host "    (questo ramo NON apre MT5: legge il CSV e stampa. Vedi -SoloReferto, riga 132)" -ForegroundColor DarkGray
    # IL CODICE DI USCITA SI LEGGE IN MODO 5.1-SAFE ANCHE QUI, dove non
    # e' un gate: su Windows PowerShell 5.1 $LASTEXITCODE puo' restare
    # $null (prima invocazione della sessione, o figlio che non lo
    # imposta), e "" + $null stampa il VUOTO -- cioe' una riga di referto
    # che nessuno sa leggere. Tre stati, non due: qui e ovunque.
    $global:LASTEXITCODE = 0
    & powershell @("-ExecutionPolicy","Bypass","-File",('"' + $ss + '"'),"-SoloReferto")
    $grezzoSs = $LASTEXITCODE
    $rcSs = "NON LETTO"
    if($null -ne $grezzoSs -and (("" + $grezzoSs).Trim()) -match '^-?\d+$'){ $rcSs = ("" + $grezzoSs).Trim() }
    # E LA RIGA DEL REFERTO DICE CHE UN FIGLIO C'E' STATO: lasciarla al
    # valore di partenza ("nessun processo figlio lanciato") negherebbe
    # agli atti una chiamata che invece e' avvenuta (punto 94).
    $RcTxt = $rcSs + "  (scarica_storico.ps1 -SoloReferto; NON e' un gate, vedi RILIEVI)"
    # IL CODICE DI USCITA DI QUESTO RAMO NON E' UN GATE, ED E' MISURATO:
    # scarica_storico.ps1 riga 132 fa "Mostra-Referto; exit 0" SEMPRE,
    # anche quando il CSV non esiste o non e' leggibile. Quindi "esce 0"
    # qui NON vuol dire "il censimento c'e'": il verdetto del passo A lo
    # da' la lettura qui sotto, non lui.
    [void]$Rilievi.Add("scarica_storico.ps1 -SoloReferto esce SEMPRE 0 (riga 132: 'Mostra-Referto; exit 0'), anche a CSV assente o illeggibile: il suo codice di uscita (" + $rcSs + ") NON e' il verdetto del PASSO A. Il verdetto lo da' la lettura DATATA qui sotto.")

    Testata "A3. IL CSV DEL CENSIMENTO: DOVE STA, DI QUANDO E', COSA CONTIENE"
    CensimentoLeggi $null
  }

  # ===================================================================
  #  PASSO A2 -- IL CENSIMENTO FRESCO (apre MT5, minuti)
  # ===================================================================
  #  Nasce dal risultato del PASSO A del 02/09 mattina: "GBPUSD M1 NON
  #  CENSITO". Il censimento piu' recente sul PC di backtest e' del
  #  30/08 e contiene SOLO i tre indici -- conferma piena della classe
  #  106 (l'artefatto che si svuota a ogni corsa letto come registro).
  #  Quindi il pavimento M1 di GBPUSD non e' MAI stato misurato su quel
  #  terminale, e H2 e' rimasta APERTA: qui si chiude.
  #
  #  DUE COSE CHE QUESTO PASSO DEVE FARE E CHE NESSUNO FAREBBE DA SOLO:
  #   1. I DUE SIMBOLI NELLA STESSA CORSA. scarica_storico.ps1 riga 230
  #      CANCELLA il CSV all'inizio: se GBPUSD ed EURUSD si chiedessero
  #      in due lanci, il secondo cancellerebbe il primo e li avremmo
  #      di nuovo non confrontabili. Un solo -Simboli "GBPUSD,EURUSD".
  #   2. IL PIN DEVE COPRIRE ANCHE IL .mq5 CHE LO SCRIPT SI SCARICA DA
  #      SOLO (punto 24: il pin che non copre il pezzo piu' importante
  #      perche' lo scarica il gemello). scarica_storico.ps1 riga 55 ha
  #      $EABranch = "lavoro" e da li' prende ABTG_HistoryDownloader.mq5:
  #      senza riscrivere quella riga, il pin varrebbe per il driver e
  #      NON per lo strumento che fa la misura.
  # ===================================================================
  if($Passo -eq "A2"){
    Testata "A2-1. SCARICO E PINNO scarica_storico.ps1"
    $ss = Join-Path $Work "scarica_storico.ps1"
    Scarica ($RawPin + "/backtest_pipeline/scarica_storico.ps1") $ss
    $txtSs = Get-Content -LiteralPath $ss -Raw
    # I PARAMETRI ESISTONO DAVVERO? Si guarda il param(), non i commenti.
    # E qui morde: questo script NON ha [CmdletBinding()], quindi NON
    # rifiuta i parametri che non conosce (punto 71). Un refuso in
    # -SenzaTick lo farebbe scaricare anche i TICK: da minuti a ore.
    foreach($sw in @('SenzaTick','Auto','ChiudiMT5','SoloReferto')){
      if($txtSs -notmatch ('(?m)^\s*\[switch\]\s*\$' + $sw + '\s*,?\s*$')){
        throw ("scarica_storico.ps1 al pin NON dichiara [switch] $" + $sw + " nel param(): non lancio niente. Questo script non ha [CmdletBinding()], quindi un interruttore che non esiste verrebbe IGNORATO IN SILENZIO -- e senza -SenzaTick scaricherebbe anche i tick, che sono ore.")
      }
    }
    foreach($pr in @('Simboli','Da','Timeframes')){
      if($txtSs -notmatch ('(?m)^\s*\[string\]\s*\$' + $pr + '\s*=')){
        throw ("scarica_storico.ps1 al pin NON dichiara [string] $" + $pr + " nel param(): non lancio niente.")
      }
    }
    if($txtSs -notmatch '(?m)^\s*\[int\]\s*\$TimeoutMin\s*='){ throw 'scarica_storico.ps1 al pin NON dichiara [int] $TimeoutMin nel param().' }
    if($txtSs -notmatch 'PrimaDataLocale'){ throw "scarica_storico.ps1 al pin non nomina la colonna PrimaDataLocale: non e' lo strumento che questo passo chiede." }
    # E LA RIGA CHE CANCELLA IL CSV: se un giorno sparisse, il censimento
    # diventerebbe cumulativo e meta' dei ragionamenti di questa riga
    # (classe 106) non varrebbero piu'. Meglio accorgersene qui.
    if($txtSs -notmatch 'Remove-Item\s+\$CsvOut'){
      [void]$Rilievi.Add("scarica_storico.ps1 al pin NON contiene piu' la riga che cancella il CSV prima della corsa (era la riga 230). Se lo strumento e' diventato CUMULATIVO, la classe 106 non si applica piu' e il conteggio delle righe qui sotto va riletto con quella luce.")
    }
    # IL PIN SUL PEZZO CHE SI SCARICA DA SOLO (punto 24).
    if($txtSs -notmatch '\$EABranch\s*=\s*"lavoro"'){ throw 'scarica_storico.ps1 non ha la riga $EABranch = "lavoro" attesa: non lo posso pinnare, e senza pin si scaricherebbe ABTG_HistoryDownloader.mq5 dalla PUNTA del branch.' }
    $txtSs = $txtSs -replace '\$EABranch\s*=\s*"lavoro"', ('$EABranch = "' + $Pin + '"')
    Set-Content -LiteralPath $ss -Value $txtSs -Encoding ASCII
    Dico "scarica_storico.ps1 scaricato, PARAMETRI VERIFICATI nel param() e PINNATO (riscarica ABTG_HistoryDownloader.mq5 al pin)" "Green"

    Testata "A2-2. IL TERMINALE (serve per sapere DOVE nascera' il CSV)"
    $cercaT = TrovaTerminale
    $instDir    = $cercaT.Inst
    $dataFolder = $cercaT.Dati
    $Terminale  = $instDir
    Dico ("terminale scelto: " + $instDir) "Yellow"
    Dico ("cartella dati:    " + $dataFolder) "DarkGray"
    $CsvCens = Join-Path $dataFolder "MQL5\Files\ABTG_StoricoScaricato.csv"
    $etaPrima = "ASSENTE"
    if(Test-Path -LiteralPath $CsvCens){ $etaPrima = (Get-Item -LiteralPath $CsvCens).LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss",$INV) }
    Dico ("censimento PRIMA di questa corsa: " + $etaPrima + "   (scarica_storico.ps1 lo cancella e lo riscrive)") "DarkGray"
    [void]$CensRighe.Add("censimento PRIMA di questa corsa: " + $etaPrima)

    Testata "A2-3. LA MISURA FRESCA DEL PAVIMENTO M1"
    Write-Host ""
    Write-Host "###################################################################" -ForegroundColor Yellow
    Write-Host "#  QUESTO PASSO APRE MT5 DA SOLO e scarica barre M1 dal broker.   #" -ForegroundColor Yellow
    Write-Host "#  NON toccare il terminale mentre gira, e NON aprirne un altro.  #" -ForegroundColor Yellow
    Write-Host "#  Sono MINUTI, non secondi: -SenzaTick evita le ore dei tick.    #" -ForegroundColor Yellow
    Write-Host "###################################################################" -ForegroundColor Yellow
    Write-Host ""
    # -Da 2010.01.01: il pavimento si misura CHIEDENDO piu' indietro della
    #  finestra che si vuole giustificare (2011.01.01 della sonda). Con il
    #  default -Da 2023.01.01 il 2011 non verrebbe MAI chiesto e
    #  PrimaDataLocale direbbe 2023 su un feed che magari ha il 1993.
    # -Timeframes "M1": la domanda e' sul pavimento M1. Gli altri sei TF
    #  del default sarebbero sei volte il lavoro per una risposta che
    #  nessuno legge (e il tetto barre morde per TF: punto 18/36).
    # -TimeoutMin INTERNO piu' corto del mio tetto: cosi' e' LUI a
    #  fermarsi e a scrivere il suo referto parziale, invece che essere
    #  ammazzato da me a meta'.
    FotografaLog $dataFolder $instDir
    $timeoutInterno = [math]::Max(5, $TimeoutMin - 5)
    $argv = @("-ExecutionPolicy","Bypass","-File",('"' + $ss + '"'),
              "-Auto",
              "-Simboli",('"' + $Simbolo + ',EURUSD"'),
              "-Timeframes",'"M1"',
              "-Da","2010.01.01",
              "-SenzaTick",
              "-TimeoutMin",("" + $timeoutInterno))
    Dico ("argv: powershell " + ($argv -join " ")) "DarkGray"
    $esec = EseguiConGuardia $argv $dataFolder $Simbolo
    $Secondi = $esec.Secondi
    $RcTxt   = $esec.RcTxt
    $Cronometro = "durata della misura: " + (Fmt1 $Secondi) + " s   (non e' il cronometro di una passata: qui si scarica storico, non si simula)"
    if($esec.Incagliata){
      $EsitoCorsa = "A2: INCAGLIATA (fermata dopo " + $TimeoutMin + " minuti)"
      [void]$Problemi.Add("LO SCARICO DELLE M1 NON E' FINITO entro " + $TimeoutMin + " minuti ed e' stato FERMATO. Il censimento che trovi qui sotto, se c'e', e' PARZIALE. Guarda i campioni: se 'bases " + $Simbolo + "' stava crescendo, stava lavorando davvero e basta ridargli piu' tempo (-TimeoutMin piu' alto); se era fermo, il broker non stava mandando niente.")
    }
    elseif($esec.RcLetto -and $esec.Rc -eq 2){
      [void]$Problemi.Add("scarica_storico.ps1 e' uscito con codice 2: la sua riga di chiusura '=== FINITO' non e' mai arrivata e MT5 e' stato fermato dal SUO timeout (" + $timeoutInterno + " min). IL REFERTO E' PARZIALE, e il pavimento letto qui sotto puo' essere piu' recente del vero.")
    }
    elseif($esec.RcLetto -and $esec.Rc -ne 0){
      [void]$Problemi.Add("scarica_storico.ps1 e' uscito con codice " + $esec.Rc + ": lo scarico non e' andato a fondo (MT5 gia' aperto? terminale non trovato? compilazione del downloader fallita?). Quello che segue NON e' una misura fresca.")
    }
    RaccogliLog
    # IL VERDETTO NON LO DA' IL CODICE DI USCITA, LO DA' L'ARTEFATTO:
    # il CSV deve esistere, essere piu' NUOVO dell'avvio della corsa, e
    # contenere DAVVERO le righe M1 dei due simboli, CONTATE.
    CensimentoLeggi $esec.TCorsa
  }

  # ===================================================================
  #  PASSI B e C -- LE 4 PASSATE CRONOMETRATE
  # ===================================================================
  if($Passo -eq "B" -or $Passo -eq "C"){
    Testata "B1. SCARICO AL PIN E GATE SUL FILE PROVA"
    $drv = Join-Path $Work "walkforward_generico.ps1"
    Scarica ($RawPin + "/backtest_pipeline/walkforward_generico.ps1") $drv
    $testoDrv = Get-Content -LiteralPath $drv -Raw
    # il driver generico riscarica il .mq5 da un branch: senza questa
    # riscrittura il pin varrebbe per il driver e NON per l'EA misurato.
    # APICI SINGOLI: in una stringa fra doppi apici '\$EABranch' NON e' un
    # escape (PowerShell usa il backtick), quindi il '\' resterebbe e
    # $EABranch verrebbe ESPANSO a vuoto: il messaggio perderebbe proprio
    # il nome che deve dire. (Lo stesso messaggio, in doppi apici, e' in
    # RIGA_SONDA_OROLOGIO.ps1 riga 522: li' esce "la riga \ attesa".)
    if($testoDrv -notmatch '\$EABranch\s*=\s*"lavoro"'){ throw 'walkforward_generico.ps1 non ha la riga $EABranch = "lavoro" attesa: non lo posso pinnare.' }
    # E IL PARAMETRO SU CUI SI REGGE TUTTO IL PASSO: -Simbolo, -DaQuando,
    # -Fino, -Etichetta e -Rifai devono ESISTERE nel param() del driver
    # che sto per lanciare, non in quello che ricordo io.
    foreach($p in @('\$Simbolo','\$DaQuando','\$Fino','\$Etichetta','\$Rifai','\$Modello','\$Deposito','\$Prova')){
      if($testoDrv -notmatch ('(?m)^\s*\[[A-Za-z\[\]]+\]' + $p + '\b')){
        throw ("walkforward_generico.ps1 al pin non dichiara il parametro " + ($p -replace '\\','') + " nel suo param(): la riga passerebbe un interruttore che il driver non ha.")
      }
    }
    $testoDrv = $testoDrv -replace '\$EABranch\s*=\s*"lavoro"', ('$EABranch="' + $Pin + '"')
    Set-Content -LiteralPath $drv -Value $testoDrv -Encoding ASCII
    Dico "driver generico scaricato, PARAMETRI VERIFICATI e PINNATO" "Green"

    $prvPath = Join-Path $ProveD $Prova
    Scarica ($RawPin + "/backtest_pipeline/prove/" + $Prova) $prvPath

    # --- I GATE SUL FILE PROVA. Girano PRIMA di aprire MT5.
    #     Questo file NON e' nostro: e' la cella 00_gemelli della sonda.
    #     Si controlla che sia ANCORA quella (magic gemelli, un asse
    #     solo, i pin della baseline), e si DICHIARA cosa si scavalca.
    $righeP = RigheVive $prvPath
    $dir = @{}
    $assiY = New-Object System.Collections.ArrayList
    $pinnati = @{}
    foreach($r in $righeP){
      if($r -match '^@'){
        $parti = ($r -split '\s+',2)
        if($dir.ContainsKey($parti[0])){ throw ($Prova + ": DUE direttive '" + $parti[0] + "'.") }
        $dir[$parti[0]] = $parti[1].Trim()
        continue
      }
      if($r -notmatch "="){ continue }
      $nome = ($r -split "=")[0].Trim()
      $resto = $r.Substring($r.IndexOf("=")+1).Trim()
      $pinnati[$nome] = $resto
      $campi = $resto -split '\|\|'
      if(@($campi).Count -ge 5 -and $campi[4].Trim() -match '^[Yy]'){ [void]$assiY.Add($nome) }
      # LA FORMA A CINQUE CAMPI: una riga pinnata con QUATTRO campi
      # viene riscritta storta dal driver generico e MT5 la ignora IN
      # SILENZIO (e' scritto nel file prova stesso, righe 22-30).
      if(@($campi).Count -ne 1 -and @($campi).Count -ne 5){
        throw ($Prova + ": la riga '" + $nome + "' ha " + @($campi).Count + " campi separati da '||'. Ammessi: 1 (pin secco) o 5 (v||start||step||stop||flag). Con quattro campi MT5 la legge storta senza dire niente.")
      }
    }
    foreach($d in @("@SIMBOLO","@PERIODO","@DAQUANDO","@FINOA")){
      if(-not $dir.ContainsKey($d)){ throw ($Prova + ": manca la direttiva " + $d + " NUDA.") }
    }
    if($dir["@PERIODO"] -ne "H1"){ throw ($Prova + ": @PERIODO e' " + $dir["@PERIODO"] + ", atteso H1.") }
    # L'ASSE: uno solo, ed e' InpMagic sui due gemelli. Se qualcuno
    # cambiasse la griglia, "4 passate" smetterebbe di essere vero e il
    # cronometro misurerebbe un'altra cosa.
    if(@($assiY).Count -ne 1 -or $assiY[0] -ne "InpMagic"){
      throw ($Prova + ": gli assi con flag Y sono [" + (@($assiY) -join ", ") + "], atteso ESATTAMENTE [InpMagic]. Il cronometro di questa diagnosi vale 4 passate: con un altro asse non sarebbero 4.")
    }
    if($pinnati["InpMagic"] -ne "777290||777290||1||777291||Y"){
      throw ($Prova + ": InpMagic e' '" + $pinnati["InpMagic"] + "', atteso '777290||777290||1||777291||Y' (i due magic GEMELLI VERGINI).")
    }
    # LA BASELINE: gli stessi valori dichiarati nel driver della sonda.
    # Si confronta con QUESTI, letterali qui dentro, non con un file
    # gemello: una corruzione simmetrica passerebbe un diff (R108/R110).
    $Baseline = [ordered]@{
      "InpAllowLong"="1||1||0||1||N"; "InpAllowShort"="0||0||0||0||N"
      "InpRiskPercent"="1.0||1.0||0||1.0||N"; "InpSLatrMult"="10.0||10.0||0||10.0||N"
      "InpATRPeriod"="14||14||0||14||N"; "InpTPatrMult"="0.0||0.0||0||0.0||N"
      "InpMaxPositions"="1||1||0||1||N"; "InpMaxTradesPerDay"="1||1||0||1||N"
      "InpMaxSpreadPts"="0||0||0||0||N"; "InpFlatAnticipoMin"="30||30||0||30||N"
      "InpOraIngresso"="8||8||0||8||N"; "InpOreDurata"="8||8||0||8||N"
    }
    foreach($k in $Baseline.Keys){
      if(-not $pinnati.ContainsKey($k)){ throw ($Prova + ": manca il pin " + $k + ".") }
      if($pinnati[$k] -ne $Baseline[$k]){ throw ($Prova + ": " + $k + " e' '" + $pinnati[$k] + "', atteso '" + $Baseline[$k] + "'.") }
    }
    # L'ELENCO CHIUSO: un nome fuori da qui ferma tutto, anche se l'EA
    # quel parametro ce l'ha. Serve a impedire che entri una condizione
    # di PREZZO in una cella che deve misurare solo il tempo.
    $Ammessi = @("InpOraIngresso","InpOreDurata","InpAllowLong","InpAllowShort",
                 "InpRiskPercent","InpSLatrMult","InpATRPeriod","InpTPatrMult",
                 "InpMaxPositions","InpMaxTradesPerDay","InpMaxSpreadPts",
                 "InpFlatAnticipoMin","InpMagic")
    foreach($k in $pinnati.Keys){
      if($Ammessi -notcontains $k){ throw ($Prova + ": parametro '" + $k + "' fuori dall'elenco chiuso di questa sonda.") }
    }
    Dico ("gate sul file prova: PASSATI (direttive, un solo asse Y = InpMagic 777290/777291, baseline " + $Baseline.Count + " pin, elenco chiuso)") "Green"

    # --- IL RILIEVO CHE NON SI PUO' NON SCRIVERE: qui si SCAVALCA il
    #     file prova su simbolo e finestra. Prosa e parametri che dicono
    #     due geometrie diverse sono la classe del 31/08: la divergenza
    #     non si nasconde, si DICHIARA e si stampa accanto al numero.
    [void]$Rilievi.Add("QUESTA NON E' LA CELLA 00_gemelli DELLA SONDA. Il file prova " + $Prova + " dichiara @SIMBOLO " + $dir["@SIMBOLO"] + ", @DAQUANDO " + $dir["@DAQUANDO"] + ", @FINOA " + $dir["@FINOA"] + "; questa corsa gira su " + $Simbolo + " " + $DaQuando + " -> " + $Fino + " perche' i parametri di riga di comando VINCONO sulle direttive @ (walkforward_generico.ps1 righe 303-305; @FINOA il generico non la legge affatto e prende -Fino). I numeri che escono NON entrano nel round della sonda e non si confrontano con la sua tabella: qui si misura un TEMPO, non un orologio.")
    if($Passo -eq "C"){
      [void]$Rilievi.Add("FINESTRA C INTERAMENTE PRIMA DEL PAVIMENTO DEI TICK REALI (" + $TickPavimento + ", MISURATO il 01/09 nel Diario del tester): a Modello 4 MT5 NON si ferma, GENERA i tick dalle barre M1 e non lo dice. E' VOLUTO -- e' proprio il tratto che si sta cronometrando -- ma qualunque colonna che dipende dallo spread (Spread Mediano Ingresso, Rapporto Lordo Su Spread) in questa corsa NON e' lo spread del feed e non si legge. Qui si legge il CRONOMETRO.")
    }
    if($Passo -eq "B"){
      [void]$Rilievi.Add("FINESTRA B INTERAMENTE DOPO IL PAVIMENTO DEI TICK REALI (" + $TickPavimento + "): questa corsa gira su tick NATIVI. E' la meta' di controllo del confronto, e per costruzione dice anche se il DOWNLOAD dei tick reali (non la loro generazione) e' il collo di bottiglia.")
    }

    Testata "B2. TERMINALE E COMPILAZIONE"
    $cercaT = TrovaTerminale
    $instDir    = $cercaT.Inst
    $dataFolder = $cercaT.Dati
    $MetaEditor = Join-Path $instDir "metaeditor64.exe"
    $Terminale  = $instDir
    Dico ("terminale scelto: " + $instDir + "   (DEVE essere lo stesso che stampa poi il driver generico)") "Yellow"
    Dico ("cartella dati:    " + $dataFolder) "DarkGray"

    # L'.ex5 SI CANCELLA PRIMA: senza, un binario vecchio farebbe passare
    # per riuscita una compilazione fallita (punto 23 / punto 54).
    $mq5 = Join-Path $Work ($EA + ".mq5")
    Scarica ($RawPin + "/mql5/Experts/" + $EA + ".mq5") $mq5
    $dstExp = Join-Path $dataFolder "MQL5\Experts"
    New-Item -ItemType Directory -Force -Path $dstExp | Out-Null
    $dstMq5 = Join-Path $dstExp ($EA + ".mq5")
    Copy-Item $mq5 -Destination $dstMq5 -Force
    $ex5 = Join-Path $dstExp ($EA + ".ex5")
    Remove-Item -LiteralPath $ex5 -Force -ErrorAction SilentlyContinue
    $tC = Get-Date
    & $MetaEditor ("/compile:" + $dstMq5) "/log" | Out-Null
    while((-not (Test-Path -LiteralPath $ex5)) -and ((New-TimeSpan -Start $tC -End (Get-Date)).TotalSeconds -lt 180)){ Start-Sleep -Seconds 2 }
    if(-not (Test-Path -LiteralPath $ex5)){
      # IL CAMPO SI AGGIORNA PRIMA DEL throw. Lasciandolo al valore di
      # partenza il referto direbbe "compilazione: NON TENTATA" proprio
      # nel giro in cui la compilazione E' STATA TENTATA ed e' fallita:
      # e' il punto 94 (il valore di partenza che NEGA AGLI ATTI il gate
      # che invece ha girato). Trovato eseguendo, sul banco stubbato.
      $Compilato = "TENTATA E FALLITA (dopo 180 s l'.ex5 non era comparso)"
      $logC = Join-Path $dstExp ($EA + ".log")
      if(Test-Path -LiteralPath $logC){
        Copy-Item $logC -Destination (Join-Path $Work "COMPILAZIONE_FALLITA.log") -Force
        Get-Content -LiteralPath $logC -Tail 40 | ForEach-Object { Write-Host $_ -ForegroundColor Red }
      }
      throw ("COMPILAZIONE FALLITA di " + $EA + ". Gli errori sono qui sopra e in COMPILAZIONE_FALLITA.log dentro lo zip.")
    }
    $Compilato = "OK (" + [int]((Get-Item -LiteralPath $ex5).Length/1024) + " KB, " + (Get-Item -LiteralPath $ex5).LastWriteTime.ToString("HH:mm:ss",$INV) + ")"
    Dico ("compilato " + $EA + ": " + $Compilato) "Green"

    Testata "B3. Tester\cache -- SI SVUOTA, COI DUE CONTEGGI"
    # Il CSV di questa famiglia nasce dai FRAME: un pass ripescato dalla
    # cache NON chiama OnTester(), non manda il frame e la sua riga
    # SPARISCE dal CSV -- e il cronometro segnerebbe un tempo che non
    # corrisponde a nessuna passata eseguita. E' anche la spiegazione (i)
    # delle "4 passate veloci" del 01/09. Si svuota SOLO Tester\cache,
    # MAI bases\<server>\ticks (quello e' lo storico: riscaricarlo costa ore).
    $cacheT = Join-Path $dataFolder "Tester\cache"
    if(Test-Path -LiteralPath $cacheT){
      $ncPrima = @(Get-ChildItem -LiteralPath $cacheT -Recurse -File -ErrorAction SilentlyContinue).Count
      Remove-Item (Join-Path $cacheT "*") -Recurse -Force -ErrorAction SilentlyContinue
      $ncDopo  = @(Get-ChildItem -LiteralPath $cacheT -Recurse -File -ErrorAction SilentlyContinue).Count
      $CacheTxt = "prima " + $ncPrima + " file, dopo " + $ncDopo
      if($ncDopo -gt 0){
        [void]$Problemi.Add("Tester\cache NON si e' svuotata (prima " + $ncPrima + ", dopo " + $ncDopo + "): un pass ripescato dalla cache non chiama OnTester(), non manda il frame e SPARISCE dal CSV. Il cronometro di questo giro puo' misurare passate MAI ESEGUITE.")
        Dico ("Tester\cache NON SVUOTATA: " + $CacheTxt) "Red"
      }
      else{ Dico ("Tester\cache svuotata: " + $CacheTxt) "Green" }
    }
    else{
      $CacheTxt = "cartella assente (" + $cacheT + "): niente da svuotare"
      Dico ("Tester\cache: " + $CacheTxt) "Yellow"
    }

    FotografaLog $dataFolder $instDir

    Testata "B4. LA CORSA (4 passate: 2 magic gemelli x 2 finestre del driver generico)"
    Write-Host ""
    Write-Host "###################################################################" -ForegroundColor Yellow
    Write-Host "#  DA ADESSO E FINO ALLA FINE: NON APRIRE MT5.                    #" -ForegroundColor Yellow
    Write-Host ("#  Se la corsa sfonda il tetto di " + $TimeoutMin + " minuti questa riga") -ForegroundColor Yellow
    Write-Host "#  chiude terminal64 e metatester64 PER FERMARE LA MISURA, e      #" -ForegroundColor Yellow
    Write-Host "#  chiuderebbe anche un MT5 aperto a mano nel frattempo.          #" -ForegroundColor Yellow
    Write-Host "#  SE SI INCAGLIA: apri il Task Manager (scheda Prestazioni) e    #" -ForegroundColor Yellow
    Write-Host "#  guarda 30 secondi. I campioni qui sotto dicono la stessa cosa, #" -ForegroundColor Yellow
    Write-Host "#  ma l'occhio vede anche il DISCO, che qui non si misura.        #" -ForegroundColor Yellow
    Write-Host "###################################################################" -ForegroundColor Yellow
    Write-Host ""

    $Risultati = Join-Path $Work ("risultati_prove\" + $EA)
    $csvIS  = Join-Path $Risultati ($EA + "_" + $Simbolo + "_IS_"  + $Etichetta + ".csv")
    $csvOOS = Join-Path $Risultati ($EA + "_" + $Simbolo + "_OOS_" + $Etichetta + ".csv")

    # -Rifai STA SEMPRE NELL'ARGV (classe zombie-run del 31/08): senza,
    # il generico troverebbe i CSV del giro prima, stamperebbe "gia'
    # fatto, salto" in grigio, uscirebbe 0, e il cronometro segnerebbe
    # il tempo di una lettura di directory.
    # Ogni percorso va fra virgolette: Start-Process unisce gli elementi
    # dell'array con uno spazio e NON li quota, e %USERPROFILE% puo'
    # contenere uno spazio.
    $argv = @("-ExecutionPolicy","Bypass","-File",('"' + $drv + '"'),
              "-Expert",$EA,
              "-Prova",('"' + $prvPath + '"'),
              "-Etichetta",$Etichetta,
              "-Simbolo",$Simbolo,
              "-Periodo",$Periodo,
              "-DaQuando",$DaQuando,
              "-Fino",$Fino,
              "-Modello",("" + $Modello),
              "-Deposito",("" + $Deposito),
              "-Rifai")
    if($SoloControllo){ $argv += "-SoloControllo" }
    Dico ("argv: powershell " + ($argv -join " ")) "DarkGray"

    $esec = EseguiConGuardia $argv $dataFolder $Simbolo
    $tCorsa     = $esec.TCorsa        # <- LA DATA CONTRO CUI SI GIUDICA OGNI ARTEFATTO
    $Secondi    = $esec.Secondi
    $RcTxt      = $esec.RcTxt
    $incagliata = $esec.Incagliata
    $rc         = $esec.Rc
    # TRE STATI, NON DUE. "corsaFallita" e' VERO solo quando il codice di
    # uscita e' stato LETTO DAVVERO ed e' diverso da zero. Un codice NON
    # LETTO non e' un fallimento: si tira avanti e decide l'ARTEFATTO.
    # (Difetto pagato il 02/09 alle 08:36: "FERMATA DAL DRIVER GENERICO
    #  (codice )" su un giro a vuoto perfettamente riuscito.)
    $corsaFallita = ($esec.RcLetto -and $rc -ne 0)
    if($incagliata){
      $EsitoCorsa = "INCAGLIATA (fermata dopo " + $TimeoutMin + " minuti)"
      [void]$Problemi.Add("LA CORSA NON E' FINITA entro " + $TimeoutMin + " minuti ed e' stata FERMATA. Non e' un guasto da riparare: e' LA MISURA. Metro: 4 passate EURUSD su " + (Fmt1 $MetroAnni) + " anni costano " + (Fmt1 $MetroSec) + " s. Questa finestra e' molto piu' corta e ha sfondato. Nessun CSV, nessun cronometro valido, e i campioni del banco qui sotto sono l'unica cosa da leggere.")
    }
    elseif($corsaFallita){
      $EsitoCorsa = "FERMATA DAL DRIVER GENERICO (codice " + $rc + ")"
      [void]$Problemi.Add("il driver generico e' uscito con codice " + $rc + ": la corsa NON e' andata a fondo. Il tempo di " + (Fmt1 $Secondi) + " s NON e' un cronometro (e' il tempo di un fallimento), e i CSV eventualmente presenti sono di un ALTRO giro.")
    }
    elseif($SoloControllo){
      # --- LA PROVA D'ARRIVO DEL GIRO A VUOTO E' UN ARTEFATTO, NON UN
      #     NUMERO. -SoloControllo del driver generico scrive l'anteprima
      #     dell'.ini e poi esce (walkforward_generico.ps1 righe 503-538):
      #     quel file, DATATO, e' la prova che i gate sono stati passati e
      #     che il driver e' arrivato in fondo al suo mestiere. Senza
      #     questo, il giro a vuoto si reggeva su un ExitCode che su 5.1
      #     puo' non esserci.
      $Anteprima = Join-Path $Work ("anteprima_" + $EA + "_" + $Simbolo + ".ini")
      $antOk = $false
      $antTxt = "ASSENTE"
      if(Test-Path -LiteralPath $Anteprima){
        $lwA = (Get-Item -LiteralPath $Anteprima).LastWriteTime
        $antTxt = "scritta il " + $lwA.ToString("yyyy-MM-dd HH:mm:ss",$INV)
        if($lwA -ge $tCorsa){ $antOk = $true; $antTxt = "FRESCA, " + $antTxt }
        else{ $antTxt = "STANTIA, " + $antTxt }
      }
      $FrescoTxt = "anteprima .ini: " + $antTxt + "   [corsa avviata alle " + $tCorsa.ToString("yyyy-MM-dd HH:mm:ss",$INV) + "]"
      if(-not $antOk){
        $EsitoCorsa = "CONTROLLO NON ARRIVATO IN FONDO"
        [void]$Problemi.Add("IL GIRO A VUOTO NON HA PRODOTTO L'ANTEPRIMA FRESCA " + $Anteprima + " (" + $antTxt + "). Il driver generico non e' arrivato al suo ramo -SoloControllo: guarda le sue righe rosse qui sopra, sono il risultato.")
      }
      else{
        # E L'ANTEPRIMA SI GUARDA DENTRO, non si conta soltanto: un file
        # fresco con dentro un'altra geometria e' la stessa bugia scritta
        # meglio (punto 31: l'anteprima che non rispecchia i parametri).
        $tAnt = Get-Content -LiteralPath $Anteprima -Raw
        $attesiAnt = @(("Symbol=" + $Simbolo), ("Period=" + $Periodo), ("FromDate=" + $DaQuando), "AllowLiveTrading=false", "InpMagic=777290||777290||1||777291||Y")
        $mancaAnt = @($attesiAnt | Where-Object { $tAnt -notmatch [regex]::Escape($_) })
        if(@($mancaAnt).Count -gt 0){
          $EsitoCorsa = "CONTROLLO CON ANTEPRIMA DIVERSA DA QUELLO CHE HO CHIESTO"
          [void]$Problemi.Add("l'anteprima .ini non contiene: " + ($mancaAnt -join " ; ") + ". Il driver generico avrebbe lanciato una corsa DIVERSA da quella chiesta.")
        }
        else{
          $EsitoCorsa = "CONTROLLO OK (anteprima .ini fresca e coerente; il tester NON e' stato aperto)"
          Dico "GIRO A VUOTO COMPLETATO. NON e' il risultato: qui non e' girata nessuna passata." "Green"
        }
        # E QUESTO L'ANTEPRIMA NON PUO' DIRLO, quindi si dichiara:
        [void]$Rilievi.Add("L'ANTEPRIMA NON DIMOSTRA IL MODELLO. walkforward_generico.ps1 scrive 'Model=4' LETTERALE nell'anteprima (riga 514) mentre nell'.ini vero scrive 'Model=$Modello' (riga 645): un 'Model=4' nell'anteprima e' vero per costruzione e non prova niente su -Modello. Qui -Modello e' " + $Modello + ", e lo si legge dal parametro, non dall'anteprima. (punto 31)")
      }
      $Cronometro = "non pertinente: -SoloControllo non apre il tester. Cronometrare un giro a vuoto darebbe un numero plausibile e falso (checklist 101-bis)."
      [void]$Artefatti.Add($Anteprima)
    }

    RaccogliLog

    # --- I CSV SI DATANO SEMPRE, ANCHE QUANDO LA CORSA E' MORTA.
    #     Classe del 31/08 (il CSV stantio), regola 2: "le due date
    #     finiscono NEL REFERTO, non solo nella logica". Il ramo che
    #     serviva davvero e' proprio questo: generico morto + CSV del
    #     giro prima ancora al suo posto. Se la data non si stampa qui,
    #     chi legge il referto non ha modo di accorgersene.
    if(-not $SoloControllo){
      $dateTxt0 = @()
      foreach($f in @($csvIS,$csvOOS)){
        $nomeF = Split-Path $f -Leaf
        if(-not (Test-Path -LiteralPath $f)){ $dateTxt0 += ($nomeF + " ASSENTE"); continue }
        $lw0 = (Get-Item -LiteralPath $f).LastWriteTime
        $et0 = "FRESCO"
        if($lw0 -lt $tCorsa){ $et0 = "STANTIO" }
        $dateTxt0 += ($nomeF + " " + $et0 + ", scritto il " + $lw0.ToString("yyyy-MM-dd HH:mm:ss",$INV))
      }
      $FrescoTxt = ($dateTxt0 -join "   |   ") + "   [corsa avviata alle " + $tCorsa.ToString("yyyy-MM-dd HH:mm:ss",$INV) + "]"
      if($incagliata -or $corsaFallita){
        [void]$Problemi.Add("I CSV DI QUESTA ETICHETTA, DATATI: " + $FrescoTxt + ". La corsa NON e' andata a fondo, quindi qualunque CSV FRESCO qui e' PARZIALE e qualunque CSV STANTIO e' di un ALTRO giro: in tutti e due i casi NON SI LEGGE NESSUN NUMERO.")
      }
    }
    # SI LEGGONO I NUMERI SOLO SE LA CORSA NON E' INCAGLIATA E NON E'
    # FALLITA CON CODICE LETTO. Un codice NON LETTO non blocca la lettura:
    # a decidere sono i CSV datati e contati qui sotto.
    if(-not $SoloControllo -and -not $incagliata -and -not $corsaFallita){
      $mancanti = @()
      foreach($f in @($csvIS,$csvOOS)){ if(-not (Test-Path -LiteralPath $f)){ $mancanti += (Split-Path $f -Leaf) } }
      if(@($mancanti).Count -gt 0){
        $EsitoCorsa = "CSV MANCANTE"
        $FrescoTxt = "NON PERTINENTE (i CSV non ci sono)"
        [void]$Problemi.Add("CSV NON PRODOTTI: " + ($mancanti -join ", ") + ". Storico mancante su " + $Simbolo + " in questa finestra, MT5 aperto, oppure la corsa non e' mai partita. Il tempo di " + (Fmt1 $Secondi) + " s NON e' un cronometro.")
      }
      else{
        $stantii = @()
        foreach($f in @($csvIS,$csvOOS)){
          $lw = (Get-Item -LiteralPath $f).LastWriteTime
          if($lw -lt $tCorsa){ $stantii += (Split-Path $f -Leaf) }
        }
        if(@($stantii).Count -gt 0){
          $EsitoCorsa = "CSV STANTIO"
          [void]$Problemi.Add("CSV STANTIO: " + ($stantii -join ", ") + " sono PRECEDENTI all'avvio di questa corsa (" + $tCorsa.ToString("yyyy-MM-dd HH:mm:ss",$INV) + ") e il driver generico e' stato chiamato con -Rifai. La passata NON e' partita e questi numeri vengono da un ALTRO giro: NON SI LEGGONO, e il cronometro non vale.")
          $Cronometro = "NON MISURATO: i CSV sono di un altro giro (vedi PROBLEMI)."
        }
        else{
          # SI CONTA, E POI SI GUARDA DENTRO.
          $nIS = 0; $nOOS = 0; $rIS = @(); $rOOS = @()
          try{ $rIS = @(Import-Csv -LiteralPath $csvIS); $nIS = @($rIS).Count }catch{}
          try{ $rOOS = @(Import-Csv -LiteralPath $csvOOS); $nOOS = @($rOOS).Count }catch{}
          $RigheCsv = $nIS.ToString($INV) + " (IS) / " + $nOOS.ToString($INV) + " (OOS), attese 2 per finestra"
          if($nIS -ne 2 -or $nOOS -ne 2){
            [void]$Problemi.Add("righe nel CSV " + $RigheCsv + ". Un pass ripescato dalla CACHE del tester non chiama OnTester(), non manda il frame e la sua riga SPARISCE: meno di 2 righe vuol dire che meno di 4 passate sono davvero girate, e il cronometro conta un lavoro che non e' stato fatto.")
            $EsitoCorsa = "MISURATA CON RIGHE MANCANTI"
          }
          else{ $EsitoCorsa = "MISURATA" }
          # I GEMELLI: le due righe devono uscire identiche. E ZERO
          # CONTRO ZERO NON E' 'IDENTICO': e' 'non ho misurato niente'
          # (checklist 93), e su questa diagnosi sarebbe il segnale piu'
          # importante di tutti (storico assente in questa finestra).
          if($nOOS -eq 2){
            $cols = @($rOOS[0].PSObject.Properties.Name)
            if($cols -notcontains "Giornate Operate"){
              $Gemelli = "NON MISURATO (il CSV non ha la colonna 'Giornate Operate': intestazioni viste = " + ($cols -join " | ") + ")"
              [void]$Problemi.Add("il CSV c'e' ma non ha le colonne di questo EA: l'.ex5 che ha girato non e' " + $EA + "?")
            }
            else{
              $a = NumInv $rOOS[0]."Giornate Operate"
              $b = NumInv $rOOS[1]."Giornate Operate"
              if($null -eq $a -or $null -eq $b){ $Gemelli = "NON MISURATO (giornate operate illeggibili)" }
              elseif($a -le 0 -and $b -le 0){
                $Gemelli = "NON MISURATO: ZERO operazioni in tutte e due le passate"
                $EsitoCorsa = "MISURATA MA VUOTA (zero giornate operate)"
                [void]$Problemi.Add("ZERO GIORNATE OPERATE su tutte e due le passate gemelle della finestra OOS. Due corse vuote escono identiche per costruzione e non dicono niente sul determinismo -- ma dicono molto su questa diagnosi: su " + $Simbolo + " in " + $DaQuando + " -> " + $Fino + " il tester NON HA TROVATO STORICO USABILE. E' la predizione P2a (H2), e va guardata prima di qualunque cronometro.")
              }
              elseif([math]::Abs([double]$a - [double]$b) -gt 0.005){ $Gemelli = "DIVERSI su giornate operate: " + (Fmt2 $a) + " contro " + (Fmt2 $b) + " -- il banco NON e' deterministico" }
              else{ $Gemelli = "IDENTICI (" + (Fmt2 $a) + " giornate operate per passata)" }
            }
          }
          # IL CRONOMETRO, e il confronto col METRO DICHIARATO.
          # Si calcola anche quando la corsa e' VUOTA -- perche' li' il
          # numero e' la MEZZA misura piu' importante di tutte ("veloce
          # perche' non c'era niente da fare") -- ma esce ETICHETTATO.
          if($EsitoCorsa -eq "MISURATA" -or $EsitoCorsa -eq "MISURATA MA VUOTA (zero giornate operate)"){
            $perPassata = $Secondi/4.0
            $anniFin = ([datetime]::ParseExact($Fino,"yyyy.MM.dd",$INV) - [datetime]::ParseExact($DaQuando,"yyyy.MM.dd",$INV)).TotalDays/365.25
            $attesoScala = ($MetroSec/4.0) * ($anniFin/$MetroAnni)
            $rapporto = $null
            if($attesoScala -gt 0){ $rapporto = $perPassata/$attesoScala }
            $Cronometro = (Fmt1 $Secondi) + " s per 4 passate = " + (Fmt1 $perPassata) + " s a passata su " + (Fmt1 $anniFin) + " anni." +
                          "  METRO: la ricognizione EURUSD del 31/08 ha fatto " + (Fmt1 $MetroSec) + " s per 4 passate su " + (Fmt1 $MetroAnni) + " anni = " + (Fmt1 ($MetroSec/4.0)) + " s a passata;" +
                          " scalato a questa finestra sarebbero " + (Fmt1 $attesoScala) + " s a passata." +
                          "  RAPPORTO MISURATO/ATTESO = " + (Fmt2 $rapporto) + "x." +
                          "  (Il metro e' un'ALTRA finestra e un ALTRO simbolo: la scalatura lineare sugli anni e' un'APPROSSIMAZIONE dichiarata, non una legge. Si legge l'ordine di grandezza, non la seconda cifra.)"
            if($EsitoCorsa -ne "MISURATA"){
              $Cronometro = "[ATTENZIONE: LE PASSATE SONO USCITE VUOTE -- questo tempo NON e' il costo di una passata, e' il costo di NON AVERE NIENTE DA MACINARE] " + $Cronometro
            }
          }
        }
      }
      foreach($f in @($csvIS,$csvOOS)){ if(Test-Path -LiteralPath $f){ [void]$Artefatti.Add($f) } }
    }
  }
}
catch{
  $Fatale = ("" + $_.Exception.Message)
  Write-Host ""
  Write-Host ("!!! FERMATO: " + $Fatale) -ForegroundColor Red
}

# =====================================================================
#  RACCOLTA -- SEMPRE, anche quando la corsa si e' fermata a meta'.
#  Regola di casa (CLAUDE.md, righe di lancio punto 2).
# =====================================================================
Testata "RACCOLTA"
# IL NOME DELLA CARTELLA NON PRENDE $Passo GREZZO: la raccolta gira DOPO
# il catch, cioe' ANCHE quando il gate su -Passo ha gia' detto di no, e un
# valore con '..' o '\' dentro costruirebbe un percorso fuori dal Desktop.
$PassoTag = ($Passo -replace '[^A-Za-z0-9]','')
if($PassoTag -eq ""){ $PassoTag = "X" }
$Cart = Join-Path $Dsk ("DIAG_GBPUSD_" + $PassoTag + "_" + $Stamp)
New-Item -ItemType Directory -Force -Path $Cart | Out-Null

$R = New-Object System.Collections.ArrayList
[void]$R.Add("=====================================================================")
[void]$R.Add(" DIAGNOSI DELLA CELLA GBPUSD LENTA -- PASSO " + $Passo)
[void]$R.Add(" (report/DIAGNOSI_GBPUSD_LENTA_2026-09-02.md, paragrafo 5)")
[void]$R.Add("=====================================================================")
[void]$R.Add("data: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   <- SE QUESTA NON E' L'ORA DI ADESSO, IL FILE E' VECCHIO")
[void]$R.Add("pin:  " + $Pin)
[void]$R.Add("passo: " + $Titolo)
[void]$R.Add("simbolo: " + $Simbolo)
if($Passo -eq "A2"){
  [void]$R.Add("misura: barre M1 di " + $Simbolo + " e EURUSD, chieste dal 2010.01.01 (piu' indietro della finestra della sonda, apposta), SENZA tick")
  [void]$R.Add("strumento: scarica_storico.ps1 -Auto -Simboli " + [char]34 + $Simbolo + ",EURUSD" + [char]34 + " -Timeframes " + [char]34 + "M1" + [char]34 + " -Da 2010.01.01 -SenzaTick, PINNATO anche nel .mq5 che si scarica da solo (punto 24)")
  [void]$R.Add("tetto: " + $TimeoutMin + " minuti miei (il suo interno e' piu' corto, cosi' e' LUI a fermarsi e a scrivere)")
  [void]$R.Add("terminale: " + $Terminale)
  [void]$R.Add("i DUE simboli sono stati chiesti nella STESSA corsa: scarica_storico.ps1 azzera il CSV a ogni lancio (riga 230), quindi due lanci separati si cancellerebbero a vicenda (classe 106)")
}
if($Passo -eq "B" -or $Passo -eq "C"){
  [void]$R.Add("finestra: " + $DaQuando + " -> " + $Fino + "   (split 40/60 del driver generico: 2 finestre x 2 magic gemelli = 4 passate)")
  [void]$R.Add("etichetta CSV: " + $Etichetta + "   -> risultati_prove\" + $EA + "\" + $EA + "_" + $Simbolo + "_IS_" + $Etichetta + ".csv (e _OOS_)")
  [void]$R.Add("banco: Modello " + $Modello + ", deposito " + $Deposito + ", periodo " + $Periodo + ", AllowLiveTrading=false (scritto dal driver generico, riga 638)")
  [void]$R.Add("tetto: " + $TimeoutMin + " minuti (oltre, la corsa si FERMA e 'INCAGLIATA' e' il risultato)")
  [void]$R.Add("terminale: " + $Terminale)
  [void]$R.Add("compilazione: " + $Compilato)
  [void]$R.Add("cache tester: " + $CacheTxt)
  [void]$R.Add("rifai: il driver generico e' chiamato SEMPRE con -Rifai (mai una passata saltata e spacciata per fresca)")
  [void]$R.Add("log cresciuti in questo giro: " + (FmtN $LogRaccolti) + " su 5 radici scandite")
}
[void]$R.Add("codice di uscita del figlio: " + $RcTxt)
[void]$R.Add("esito: " + $EsitoCorsa)
[void]$R.Add("")
[void]$R.Add("QUESTO NON E' UN ROUND E NON DA' NESSUN VERDETTO SU NESSUN MOTORE.")
[void]$R.Add("Misura QUANTO COSTA una passata, e in quale tratto di storico il")
[void]$R.Add("costo esplode. Nessuna sedia viva viene toccata, niente va in forward.")
[void]$R.Add("")

if($Passo -eq "A" -or $Passo -eq "A2"){
  [void]$R.Add("--- IL CENSIMENTO DELLO STORICO ------------------------------------")
  if($CensRighe.Count -eq 0){ [void]$R.Add("  (nessun censimento trovato o leggibile)") }
  foreach($l in $CensRighe){ [void]$R.Add("  " + $l) }
  [void]$R.Add("")
  [void]$R.Add("--- IL PAVIMENTO M1, E COSA DECIDE ---------------------------------")
  [void]$R.Add("  " + $PavimentoTxt)
  [void]$R.Add("")
  [void]$R.Add("COME SI LEGGE:")
  [void]$R.Add("  PrimaDataLocale della riga M1 = il PAVIMENTO che il terminale ha")
  [void]$R.Add("  SUL DISCO. Se e' piu' recente del " + $FinestraSonda.ToString("yyyy.MM.dd",$INV) + " su cui gira la")
  [void]$R.Add("  sonda, la finestra della sonda parte da dove i dati non ci sono.")
  if($Passo -eq "A"){
    [void]$R.Add("  ATTENZIONE: questo passo rilegge un file GIA' SCRITTO, quindi dice")
    [void]$R.Add("  cosa c'era ALLORA, non oggi -- e la domanda di H2 e' 'ci sono")
    [void]$R.Add("  ANCORA?'. A quella risponde solo il PASSO A2 (misura fresca).")
    [void]$R.Add("  E il file contiene SOLO i simboli dell'ULTIMA corsa di")
    [void]$R.Add("  scarica_storico.ps1, che lo AZZERA ogni volta (riga 230): un")
    [void]$R.Add("  'tutto COMPLETO' su altri simboli non dice niente su " + $Simbolo + ".")
  }
  else{
    [void]$R.Add("  QUESTA E' LA MISURA FRESCA: il CSV e' stato riscritto in questo")
    [void]$R.Add("  giro (vedi le due date qui sopra) e contiene i due simboli chiesti")
    [void]$R.Add("  insieme. Se il pavimento COPRE la finestra della sonda, H2 e'")
    [void]$R.Add("  ESCLUSA e restano H1 e H3, che le decidono i PASSI B e C. Se il")
    [void]$R.Add("  pavimento e' PIU' RECENTE, H2 e' CONFERMATA e la finestra della")
    [void]$R.Add("  sonda va RIDICHIARATA da li' (la profondita' si misura).")
  }
  [void]$R.Add("")
  [void]$R.Add("--- I CAMPIONI DEL BANCO DURANTE LA MISURA -------------------------")
  if($Campioni.Count -eq 0){ [void]$R.Add("  (nessun campione: il passo A non lancia niente, oppure il figlio e' finito prima del primo intervallo)") }
  foreach($l in $Campioni){ [void]$R.Add("  " + $l) }
  if($Passo -eq "A2"){
    [void]$R.Add("")
    [void]$R.Add("--- RIGHE DEI LOG DI MT5 SCRITTE IN QUESTO GIRO --------------------")
    if($RigheLog.Count -eq 0){ [void]$R.Add("  (nessuna riga trovata: NON vuol dire 'non e' successo niente', vuol dire che non ho trovato traccia scritta)") }
    foreach($l in @($RigheLog | Select-Object -First 400)){ [void]$R.Add("  " + $l) }
  }
}
else{
  [void]$R.Add("--- IL CRONOMETRO --------------------------------------------------")
  [void]$R.Add("  " + $Cronometro)
  [void]$R.Add("")
  [void]$R.Add("--- I CSV ----------------------------------------------------------")
  [void]$R.Add("  righe: " + $RigheCsv)
  [void]$R.Add("  date:  " + $FrescoTxt)
  [void]$R.Add("  gemelli (finestra OOS): " + $Gemelli)
  [void]$R.Add("")
  [void]$R.Add("--- I CAMPIONI DEL BANCO (il Task Manager, misurato) ----------------")
  [void]$R.Add("  commit vicino al limite + RAM libera a zero = SWAP (H1/H3)")
  [void]$R.Add("  CPU degli agent che sale e RAM tranquilla   = macina tick (H1)")
  [void]$R.Add("  tutto fermo ma bases " + $Simbolo + " che CRESCE e rete che sale = sync dal server (H2)")
  if($Campioni.Count -eq 0){ [void]$R.Add("  (nessun campione: la corsa e' finita prima del primo intervallo, oppure non e' mai partita)") }
  foreach($l in $Campioni){ [void]$R.Add("  " + $l) }
  [void]$R.Add("")
  [void]$R.Add("--- RIGHE DEI LOG DI MT5 SCRITTE IN QUESTO GIRO --------------------")
  [void]$R.Add("  (cercate: tick / ticks / memory / generating / history / " + $Simbolo + ")")
  if($RigheLog.Count -eq 0){ [void]$R.Add("  (nessuna riga trovata: NON vuol dire 'non e' successo niente', vuol dire che non ho trovato traccia scritta)") }
  foreach($l in @($RigheLog | Select-Object -First 400)){ [void]$R.Add("  " + $l) }
  if($RigheLog.Count -gt 400){ [void]$R.Add("  ... e altre " + ($RigheLog.Count-400) + " righe: i log interi sono nello zip.") }
}
[void]$R.Add("")
if($Fatale -ne ""){
  [void]$R.Add("!!! FERMATO: " + $Fatale)
  [void]$R.Add("")
}
[void]$R.Add("PROBLEMI: " + $Problemi.Count)
foreach($p in $Problemi){ [void]$R.Add("  - " + $p) }
[void]$R.Add("RILIEVI: " + $Rilievi.Count)
foreach($p in $Rilievi){ [void]$R.Add("  - " + $p) }
[void]$R.Add("")
[void]$R.Add("COME SI RIPRENDE: la riga di lancio dei tre passi sta in")
[void]$R.Add("report/DIAGNOSI_GBPUSD_LENTA_2026-09-02.md (paragrafo 5) e nel")
[void]$R.Add("messaggio del verificatore che l'ha consegnata. I tre passi si")
[void]$R.Add("lanciano UNO ALLA VOLTA, in ordine A -> B -> C, e ognuno ha il suo zip.")

$refPath = Join-Path $Cart ("REFERTO_DIAG_GBPUSD_" + $PassoTag + ".txt")
Set-Content -LiteralPath $refPath -Value ($R -join "`r`n") -Encoding ASCII
Write-Host ($R -join "`r`n")

foreach($a in $Artefatti){
  if(Test-Path -LiteralPath $a){ Copy-Item -LiteralPath $a -Destination $Cart -Force -ErrorAction SilentlyContinue }
}
foreach($f in @(Get-ChildItem -LiteralPath $Work -File -Filter "log_*.log" -ErrorAction SilentlyContinue)){
  Copy-Item -LiteralPath $f.FullName -Destination $Cart -Force -ErrorAction SilentlyContinue
}
# Gli artefatti dei passi B/C NON entrano nello zip del passo A: la
# cartella di lavoro e' la stessa, e un file rimasto li' da un altro
# giro dentro questo zip e' un artefatto di un'altra corsa spacciato
# per parte di questa (e' il referto stantio, in forma di allegato).
if($Passo -eq "B" -or $Passo -eq "C"){
  foreach($f in @("COMPILAZIONE_FALLITA.log",$Prova)){
    foreach($base in @($Work,$ProveD)){
      $src = Join-Path $base $f
      if(Test-Path -LiteralPath $src){ Copy-Item -LiteralPath $src -Destination $Cart -Force -ErrorAction SilentlyContinue }
    }
  }
  foreach($f in @(Get-ChildItem -LiteralPath $Work -File -Filter "gen_*.ini" -ErrorAction SilentlyContinue)){
    Copy-Item -LiteralPath $f.FullName -Destination $Cart -Force -ErrorAction SilentlyContinue
  }
}

$zip = $Cart + ".zip"
Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
try{ Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $zip -Force }catch{
  Write-Host ("lo zip non e' riuscito: " + $_.Exception.Message) -ForegroundColor Yellow
}
Write-Host ""
Write-Host ("CARTELLA: " + $Cart) -ForegroundColor Green
if(Test-Path -LiteralPath $zip){ Write-Host ("ZIP DA MANDARE: " + $zip) -ForegroundColor Green }
# L'ELENCO DEGLI ATTESI SI GENERA DAI FILE CHE ESISTONO DAVVERO IN QUESTO
# RAMO, mai da una lista costante scritta per il ramo piu' ricco: una
# lista a mano esce rossa su un giro perfettamente verde (classe 89-ter).
$dentro = @(Get-ChildItem -LiteralPath $Cart -File | Sort-Object Name)
Write-Host ("FILE NELLO ZIP: " + @($dentro).Count) -ForegroundColor Gray
foreach($f in $dentro){ Write-Host ("   " + $f.Name + "   (" + [int]($f.Length/1024) + " KB)") -ForegroundColor Gray }

if($Fatale -ne ""){ Write-Host "ESITO: FERMATO" -ForegroundColor Red; exit 1 }
if($Problemi.Count -gt 0){ Write-Host "ESITO: COMPLETATO CON PROBLEMI (lo zip c'e' lo stesso: MANDALO)" -ForegroundColor Yellow; exit 1 }
Write-Host ("ESITO: PASSO " + $Passo + " COMPLETATO") -ForegroundColor Green
exit 0
