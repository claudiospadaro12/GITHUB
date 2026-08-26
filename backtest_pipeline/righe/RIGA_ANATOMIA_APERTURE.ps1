# =====================================================================
#  MARCATORE_RIGA_ANATOMIA_APERTURE_v1
#  RIGA_ANATOMIA_APERTURE.ps1 -- STUDIO ANATOMIA APERTURE, 16 ANNI DI
#                                NASDAQ (FASE 1, DESCRITTIVA)
#                                26/08/2026, PC di backtest
# ---------------------------------------------------------------------
#  PERCHE' ESISTE
#  Richiesta di Claudio del 26/08/2026: analizzare da zero gli ultimi
#  anni di aperture di Nasdaq, DAX e Dow e, in base a quali setup si
#  presentano DI PIU', costruire il motore giusto. La casa lo esegue
#  nel verso anti-overfitting, in DUE FASI:
#    FASE 1 (questa riga): si MISURA cosa fa il mercato all'apertura.
#            Nessun motore, nessun PF, nessuna equity, nessuna
#            promozione. Solo conteggi.
#    FASE 2 (round futuri): le IPOTESI si scrivono SOLO sugli anni
#            2010-2020, e si validano su 2021-2026 e sui tick BCM.
#  Criteri: risultati_archivio\STUDIO_APERTURE_CRITERI.md (letto AL PIN)
#  Strumento: backtest_pipeline\anatomia_aperture.py
#             (marcatore ANATOMIA_APERTURE_v1)
#  Riga da incollare: righe\RIGA_ANATOMIA_APERTURE_DA_MANDARE.md
#
#  ###################################################################
#  #  QUELLO CHE QUESTA RIGA **NON** FA:                             #
#  #  NON apre MT5. NON compila niente. NON tocca un EA, un preset,  #
#  #  un .chr, una GlobalVariable. NON scrive un byte dentro         #
#  #  MetaQuotes\Terminal. NON firma niente e non promuove niente.   #
#  #  NON tocca R110, R111, lo STORICO, RIGA_MISURE_LAMPO,           #
#  #  FvgRetest, VwapRevert: sono altri lavori, e restano dove sono. #
#  #  Legge UN file CSV e scrive sul Desktop.                        #
#  ###################################################################
#
#  MT5 PUO' RESTARE APERTO, ed e' una DICHIARAZIONE non una
#  dimenticanza (checklist 7): qui non si scrive in MetaQuotes\Terminal
#  e non si lancia nessun terminale. Se sul PC sta girando un backtest,
#  questa riga non gli toglie niente di serio: la corsa dura meno di un
#  minuto e la RAM di picco misurata e' ~33 MB (vedi P0).
#
#  IL CANCELLO QUALITA' DEL FEED E' IN VERIFICA, E VA DETTO
#  Le MISURE LAMPO del cancello _EXT (RIGA_MISURE_LAMPO.ps1) stanno
#  esaminando tre eventi anomali, e il cancello ZERO e' ancora CHIUSO.
#  Questo studio gira LO STESSO -- e' descrittivo, non autorizza niente
#  -- ma l'INTERPRETAZIONE dei suoi numeri dipende da quell'esito, e
#  ogni referto lo ripete in testa. Contromisura gia' dentro allo
#  strumento: i giorni con copertura oraria anomala sono ESCLUSI dai
#  conteggi e contati a parte, cosi' lo studio misura da solo quanto
#  pesa la malattia.
#
#  LA MEMORIA, MISURATA E NON STIMATA (checklist 74)
#  Il metro di casa e' 690 byte per barra M1, ed e' misurato sul parser
#  di histdata_m1.py: 5,2 M barre in un dizionario sarebbero ~3,6 GB.
#  anatomia_aperture.py NON tiene le barre in memoria: legge in
#  STREAMING e conserva solo gli aggregati del giorno in corso. Misurato
#  eseguendolo su un file sintetico delle DIMENSIONI VERE (5,95 M barre,
#  386 MB): 14 secondi e 33 MB di RAM di picco. Percio' qui la RAM non
#  e' un cancello che ferma la corsa: e' un numero che si stampa.
#
#  LE FASI
#   P0  pin, cultura invariante, cartelle, spazio e RAM
#   P1  python vero (niente stub del Microsoft Store, checklist 17)
#   P2  anatomia_aperture.py AL PIN + marcatore + autotest 12/12
#   P3  CENSIMENTO DELLA FONTE: si APRE il file e si dichiara il
#       FORMATO, non lo si riconosce dal nome (checklist 83). E se
#       esistono DUE copie con lo stesso nome, si dice quale si usa e
#       perche'.
#   P4  IL LUCCHETTO DEI CRITERI, letto AL PIN (checklist 82)
#   P5  la corsa vera
#   P6  raccolta sul Desktop, zip, ATTESI confrontati coi TROVATI
#   P7  referto del driver
#
#  CODICI D'USCITA (li legge la riga di chat: checklist 13 e 26-bis)
#   0 = misurato, nessun rilievo
#   1 = MISURATO CON RILIEVI: gli artefatti CI SONO e vanno mandati lo
#       stesso. Un rilievo (giorni sospetti, canarino del fuso incerto,
#       righe fuori ordine) E' GIA' UNA RISPOSTA, non un guasto.
#   2 = NON PARTITA (pin, python, strumento, autotest, file assente o
#       nel formato sbagliato, criteri non firmati): non c'e' niente da
#       mandare, si rimedia e si rilancia lo stesso blocco.
# =====================================================================
[CmdletBinding()]
param(
  [string]$Pin           = "",   # OBBLIGATORIO sha40: senza, non parte
  [switch]$SoloControllo,        # giro a vuoto: P0-P4, nessuna misura
  [switch]$CriteriFirmati,       # scappatoia per una firma data IN CHAT
  [string]$CsvStorico    = "",   # default ~\abtg_storico_indici\NASUSD_M1.csv
  [string]$Simbolo       = "NASUSD",
  [string]$OraApertura   = "09:30",   # ORA DEL FILE = NEW YORK. Vedi P3.
  [int]   $BarreAttese   = 5233590,   # quante ne dice il referto agli atti
  [int]   $RamAvvisoMB   = 300,   # NON e' un cancello: e' la soglia di un AVVISO
  [int]   $MinRigheCsv   = 3000       # sotto: il CSV prodotto non e' credibile
)

$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

# ---------------------------------------------------------------------
#  IL PIN. Nessun default, apposta: un default vecchio fa girare il
#  codice di ieri senza che nessuno se ne accorga (checklist 6 e 24).
# ---------------------------------------------------------------------
if($Pin -notmatch '^[0-9a-fA-F]{40}$'){
  Write-Host ""
  Write-Host "!!! PIN MANCANTE O NON VALIDO." -ForegroundColor Red
  Write-Host "    Usa il blocco di lancio del foglio RIGA_ANATOMIA_APERTURE_DA_MANDARE.md," -ForegroundColor Yellow
  Write-Host "    con l'hash dato in chat." -ForegroundColor Yellow
  exit 2
}
$Pin = $Pin.ToLower()

$Avvio   = Get-Date
$Stamp   = $Avvio.ToString("yyyyMMdd_HHmm",$INV)
$Desktop = [Environment]::GetFolderPath("Desktop")
if([string]::IsNullOrWhiteSpace($Desktop)){ $Desktop = Join-Path $env:USERPROFILE "Desktop" }

$CartellaLunga = Join-Path $env:USERPROFILE "abtg_storico_indici"
$CartellaCorta = Join-Path $env:USERPROFILE "histdata_m1"
if([string]::IsNullOrWhiteSpace($CsvStorico)){
  $CsvStorico = Join-Path $CartellaLunga ($Simbolo + "_M1.csv")
}

$Sosta    = Join-Path $Desktop ("ANATOMIA_APERTURE_" + $Stamp)
$SostaLog = Join-Path $Sosta "log"
$Referto  = Join-Path $Sosta "REFERTO_ANATOMIA_APERTURE.txt"
$Censo    = Join-Path $Sosta "CENSIMENTO_FONTE.txt"
$ZipFin   = Join-Path $Desktop ("ANATOMIA_APERTURE_" + $Stamp + ".zip")
$PyFile   = Join-Path $env:USERPROFILE "anatomia_aperture.py"
$CritFile = Join-Path $env:USERPROFILE "STUDIO_APERTURE_CRITERI.md"
$RawPin   = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

# --- TUTTO quello che il referto finale legge nasce QUI, FUORI dal try
#     (checklist 41-bis, 48 e 82 pezzo 4): su un errore a meta' il
#     referto si scrive lo stesso, e soprattutto lo STATO DELLA FIRMA non
#     puo' essere $null (che si leggerebbe come "firmato").
$Problemi   = New-Object System.Collections.ArrayList
$Note       = New-Object System.Collections.ArrayList
$RefRighe   = New-Object System.Collections.ArrayList
$Attesi     = New-Object System.Collections.ArrayList
$Lettura    = New-Object System.Collections.ArrayList
$Python     = ""
$PyVers     = "(non letta)"
$RamLibera  = -1.0
$DiscoLibero= -1.0
$DaFirmare  = $true            # il verso PRUDENTE: finche' non e' letto, e' chiuso
$StatoFirma = "NON LETTO"
$FonteScelta= ""
$FonteComeE = "NON CERCATA"
$FonteStato = "NON CERCATA"
$FonteBarre = -1
$FonteMB    = -1.0
$FonteData  = ""
$FonteFormato = "?"
$FontePrima = ""
$FonteUltima= ""
$RcPython   = -1
$RigheCsvOut= -1
$Uscita     = 0

# ---------------------------------------------------------------------
#  ATTREZZI
# ---------------------------------------------------------------------
function Ora(){ return (Get-Date).ToString("HH:mm:ss",$INV) }
function Dico($testo,$colore="Gray"){ Write-Host ("[" + (Ora) + "] " + $testo) -ForegroundColor $colore }
function Titolo($testo){ Write-Host ""; Write-Host ("=== " + $testo + " ===") -ForegroundColor Cyan }
function N1($valore){ return ([double]$valore).ToString("0.0",$INV) }
function N2($valore){ return ([double]$valore).ToString("0.00",$INV) }

#  un messaggio d'eccezione puo' essere su PIU' RIGHE: infilato in una
#  nota del referto spezza l'elenco e sembra un referto rotto.
function UnaRiga($testo){ return (("" + $testo) -replace '[\r\n]+',' ') }

#  la copia si verifica sul CONTENUTO, non sull'esistenza del nome
#  (checklist 27-ter: se in destinazione c'e' una CARTELLA con quel
#  nome, Copy-Item ci mette il file DENTRO e Test-Path dice OK)
function CopiaVerificata($sorgente,$destinazione){
  $len = (Get-Item -LiteralPath $sorgente).Length
  Copy-Item -LiteralPath $sorgente -Destination $destinazione -Force -ErrorAction Stop
  $v = Get-Item -LiteralPath $destinazione -ErrorAction Stop
  if($v.PSIsContainer -or $v.Length -ne $len){ throw ("copia NON verificata: " + $destinazione) }
  return $true
}

function ContaRighe($file){
  if(-not (Test-Path -LiteralPath $file)){ return -1 }
  $n = 0
  $sr = $null
  try{
    $sr = New-Object System.IO.StreamReader($file)
    while($null -ne $sr.ReadLine()){ $n++ }
  }catch{ $n = -1 }
  finally{ if($sr){ try{ $sr.Close() }catch{ } } }
  return $n
}

#  UN ARTEFATTO NON SI IDENTIFICA DAL NOME: SI APRE (checklist 83).
#  Nel repo ci sono DUE strumenti che scrivono un file chiamato
#  <SIMBOLO>_M1.csv, in DUE formati diversi:
#    importa_storico_esterno.ps1 -> "20190102 000000;1.146000;..."  (';')
#    histdata_m1.py --converti   -> "2019.01.02 00:00,1.146,..."    (',')
#  Solo il secondo e' leggibile da anatomia_aperture.py. Chi passasse il
#  primo si sentirebbe dire "il file manca" mentre il file e' li'.
function AnagraficaCsv($file){
  $ris = [pscustomobject]@{ Esiste=$false; MB=0.0; Scritto=""; Prima=""; Ultima="";
                            Formato="?"; Barre=0 }
  if(-not (Test-Path -LiteralPath $file)){ return $ris }
  $it = Get-Item -LiteralPath $file
  if($it.PSIsContainer){ return $ris }
  $ris.Esiste  = $true
  $ris.MB      = [Math]::Round($it.Length / 1MB, 1)
  $ris.Scritto = $it.LastWriteTime.ToString("yyyy-MM-dd HH:mm",$INV)
  $testa = @(Get-Content -LiteralPath $file -TotalCount 4 -ErrorAction SilentlyContinue)
  foreach($linea in $testa){
    if($linea -match '^\d{4}\.\d{2}\.\d{2} \d{2}:\d{2},'){
      $ris.Formato = "FORMATO1"; if($ris.Prima -eq ""){ $ris.Prima = $linea }
    } elseif($linea -match '^\d{8} \d{6};'){
      $ris.Formato = "HISTDATA_GREZZO"; if($ris.Prima -eq ""){ $ris.Prima = $linea }
    } elseif($linea -match '^Time,'){
      if($ris.Formato -eq "?"){ $ris.Formato = "FORMATO1" }
    }
  }
  #  BARRE STIMATE dalla lunghezza media di riga, non CONTATE: contare
  #  5 milioni di righe qui costerebbe secondi e serve solo l'ordine di
  #  grandezza (il numero VERO lo stampa lo strumento in P5, e i due si
  #  confrontano nel referto).
  $lung = @($testa | Where-Object { $_.Length -gt 0 } | ForEach-Object { $_.Length + 2 })
  if($lung.Count -gt 0){
    $media = 0.0
    foreach($lu in $lung){ $media = $media + $lu }
    $media = $media / $lung.Count
    if($media -gt 0){ $ris.Barre = [int]([Math]::Round($it.Length / $media)) }
  }
  try{ $ris.Ultima = @(Get-Content -LiteralPath $file -Tail 1 -ErrorAction Stop)[0] }
  catch{ $ris.Ultima = "(coda non leggibile)" }
  return $ris
}

function EseguiPython($argv,$logfile){
  $vecchio = $ErrorActionPreference
  $ErrorActionPreference = "Continue"
  $global:LASTEXITCODE = 0
  try{
    & $Python @argv 2>&1 | Out-File -FilePath $logfile -Encoding ascii
    $rc = $LASTEXITCODE
  }catch{
    $rc = 99
    Write-Host ("    eccezione lanciando python: " + $_.Exception.Message) -ForegroundColor Red
  }finally{ $ErrorActionPreference = $vecchio }
  if($null -eq $rc){ $rc = 0 }
  return [int]$rc
}

# =====================================================================
#  P0. INTESTAZIONE, CARTELLE, SPAZIO, RAM
# =====================================================================
Write-Host ""
Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host " ANATOMIA DELLE APERTURE -- 16 ANNI DI NASDAQ (FASE 1: DESCRITTIVA)" -ForegroundColor Cyan
Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host (" pin        : " + $Pin)
Write-Host (" modo       : " + $(if($SoloControllo){ "GIRO A VUOTO (nessuna misura)" }else{ "CORSA VERA" }))
Write-Host (" simbolo    : " + $Simbolo)
Write-Host (" dati da    : " + $CsvStorico)
Write-Host (" apertura   : " + $OraApertura + " ORA DEL FILE = NEW YORK (vedi P3)")
Write-Host (" raccolta in: " + $Sosta)
Write-Host ""
Write-Host " NON e' un backtest: niente profit factor, niente equity, niente motori," -ForegroundColor Yellow
Write-Host " niente promozioni. Si contano i fatti dell'apertura." -ForegroundColor Yellow
Write-Host " NON apre MT5, non compila, non tocca EA/preset/.chr: MT5 puo' restare" -ForegroundColor Yellow
Write-Host " aperto. NON tocca R110/R111/STORICO/MISURE LAMPO/FvgRetest/VwapRevert." -ForegroundColor Yellow
Write-Host " Il cancello qualita' del feed e' IN VERIFICA: lo studio gira lo stesso," -ForegroundColor Yellow
Write-Host " ma l'interpretazione dei numeri dipende da quell'esito. Sta nei referti." -ForegroundColor Yellow

Remove-Item -LiteralPath $Sosta  -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -LiteralPath $ZipFin -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path $Sosta    | Out-Null
New-Item -ItemType Directory -Force -Path $SostaLog | Out-Null

Titolo "P0 - SPAZIO E MEMORIA"
try{
  $os = Get-CimInstance -ClassName Win32_OperatingSystem -ErrorAction Stop
  $RamLibera = [double]$os.FreePhysicalMemory / 1024.0
  Dico ("RAM libera: " + (N2 $RamLibera) + " MB") $(if($RamLibera -ge $RamAvvisoMB){ "Green" }else{ "Yellow" })
}catch{
  [void]$Note.Add("P0: RAM libera NON MISURATA (" + (UnaRiga $_.Exception.Message) + "). Si prosegue: qui la RAM non e' un cancello.")
  Dico "RAM libera: NON MISURATA (si prosegue e si dichiara)" "Yellow"
}
if($RamLibera -ge 0 -and $RamLibera -lt $RamAvvisoMB){
  [void]$Note.Add("P0: RAM libera " + (N2 $RamLibera) + " MB, sotto " + $RamAvvisoMB + " MB. NON e' un cancello: lo strumento legge in streaming e il suo picco MISURATO e' ~33 MB su 5,95 M barre. Si prosegue.")
  Dico ("RAM sotto " + $RamAvvisoMB + " MB: dichiarato, ma lo strumento ne usa ~33. Si prosegue.") "Yellow"
}
try{
  $lettera = (Split-Path -Qualifier $Desktop)
  $disco = Get-CimInstance -ClassName Win32_LogicalDisk -Filter ("DeviceID='" + $lettera + "'") -ErrorAction Stop
  $DiscoLibero = [double]$disco.FreeSpace / 1GB
  Dico ("disco libero su " + $lettera + ": " + (N2 $DiscoLibero) + " GB (servono ~10 MB)") "Green"
}catch{
  [void]$Note.Add("P0: spazio disco NON MISURATO (" + (UnaRiga $_.Exception.Message) + "): la raccolta pesa pochi MB, si prosegue.")
}

# =====================================================================
#  P1. PYTHON VERO (checklist 17: l'interprete si MISURA, e lo stub del
#      Microsoft Store non e' Python)
# =====================================================================
Titolo "P1 - PYTHON"
$Python = (Get-Command python.exe -ErrorAction SilentlyContinue | Where-Object { $_.Source -notlike "*\WindowsApps\*" } | Select-Object -First 1).Source
if(-not $Python){ $Python = (Get-Command py.exe -ErrorAction SilentlyContinue | Select-Object -First 1).Source }
if(-not $Python){ $Python = (Get-Command python3.exe -ErrorAction SilentlyContinue | Where-Object { $_.Source -notlike "*\WindowsApps\*" } | Select-Object -First 1).Source }
if(-not $Python){
  Write-Host "!!! PYTHON ASSENTE: installalo da python.org con 'Add python.exe to PATH'." -ForegroundColor Red
  exit 2
}
$global:LASTEXITCODE = 0
& $Python -c "import sys; sys.exit(0 if sys.version_info>=(3,8) else 1)"
if($LASTEXITCODE -ne 0){
  Write-Host ("!!! PYTHON TROPPO VECCHIO O NON FUNZIONANTE: " + $Python) -ForegroundColor Red
  exit 2
}
$PyVers = (& $Python -c "import sys;print('%d.%d.%d' % sys.version_info[0:3])") 2>$null
Dico ("python: " + $Python + "   versione " + $PyVers) "Green"

# =====================================================================
#  P2. LO STRUMENTO AL PIN + AUTOTEST
#      (checklist 8: si CANCELLA la copia vecchia, si scarica con errore
#      TERMINANTE, si verifica il MARCATORE prima di eseguire)
# =====================================================================
Titolo "P2 - anatomia_aperture.py AL PIN + AUTOTEST"
Remove-Item -LiteralPath $PyFile -Force -ErrorAction SilentlyContinue
try{
  Invoke-WebRequest -Uri ($RawPin + "/backtest_pipeline/anatomia_aperture.py") -OutFile $PyFile -UseBasicParsing -ErrorAction Stop
}catch{
  Write-Host ("!!! DOWNLOAD DELLO STRUMENTO FALLITO: " + $_.Exception.Message) -ForegroundColor Red
  Write-Host "    (pin sbagliato? rete? proxy?) Non si va oltre: la copia vecchia NON si usa." -ForegroundColor Yellow
  exit 2
}
if(-not (Select-String -LiteralPath $PyFile -SimpleMatch -Pattern 'MARCATORE_ANATOMIA_APERTURE_v1' -Quiet)){
  Write-Host "!!! STRUMENTO SBAGLIATO: manca il marcatore ANATOMIA_APERTURE_v1." -ForegroundColor Red
  exit 2
}
Dico "anatomia_aperture.py scaricato al pin, marcatore verificato." "Green"

$logAuto = Join-Path $SostaLog "autotest.log"
$rcAuto  = EseguiPython @("-u",$PyFile,"--autotest") $logAuto
$rigaAuto = @(Select-String -LiteralPath $logAuto -Pattern 'AUTOTEST: ' | ForEach-Object { $_.Line })
if($rcAuto -ne 0){
  Write-Host ("!!! AUTOTEST FALLITO (rc " + $rcAuto + "): NON si misura niente. Guarda " + $logAuto) -ForegroundColor Red
  if($rigaAuto.Count -gt 0){ Write-Host ("    " + $rigaAuto[0]) -ForegroundColor Yellow }
  exit 2
}
if($rigaAuto.Count -gt 0){ Dico ("autotest: " + $rigaAuto[0].Trim()) "Green" } else { Dico "autotest: rc 0" "Green" }
[void]$Attesi.Add("CENSIMENTO_FONTE.txt")
[void]$Attesi.Add("REFERTO_ANATOMIA_APERTURE.txt")

# =====================================================================
#  P3. CENSIMENTO DELLA FONTE.
#      "I dati ci sono" e' un'ASSUNZIONE finche' non si apre il file.
#      E se esistono DUE copie con lo stesso nome, si dice QUALE si usa
#      e PERCHE'. Qui il verso e' l'OPPOSTO di quello delle misure
#      lampo del 26/08: la' serviva la copia CORTA (il confronto col
#      nativo BCM esiste solo dal 26/09/2024), qui serve la piu' LUNGA,
#      perche' il punto dello studio sono i SEDICI ANNI.
# =====================================================================
Titolo "P3 - CENSIMENTO DELLA FONTE (si apre il file, non si guarda il nome)"
$RigheCenso = New-Object System.Collections.ArrayList
[void]$RigheCenso.Add("CENSIMENTO DELLA FONTE -- anatomia delle aperture")
[void]$RigheCenso.Add("data: " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   <-- QUESTA DATA DEVE ESSERE DI ADESSO")
[void]$RigheCenso.Add("macchina: " + $env:COMPUTERNAME + "   utente: " + $env:USERNAME)
[void]$RigheCenso.Add("pin: " + $Pin)
[void]$RigheCenso.Add("")

$Candidate = @($CsvStorico,
               (Join-Path $CartellaLunga ($Simbolo + "_M1.csv")),
               (Join-Path $CartellaCorta ($Simbolo + "_M1.csv")))
$Viste = New-Object System.Collections.ArrayList
foreach($cand in $Candidate){
  if(@($Viste) -contains $cand){ continue }
  [void]$Viste.Add($cand)
  $an = AnagraficaCsv $cand
  if(-not $an.Esiste){
    [void]$RigheCenso.Add("  ASSENTE   " + $cand)
    continue
  }
  [void]$RigheCenso.Add("  TROVATO   " + $cand)
  [void]$RigheCenso.Add("            " + $an.MB + " MB, scritto il " + $an.Scritto + ", formato " + $an.Formato)
  [void]$RigheCenso.Add("            barre STIMATE " + $an.Barre + " (il numero VERO lo conta lo strumento)")
  [void]$RigheCenso.Add("            prima riga di dati: " + $an.Prima)
  [void]$RigheCenso.Add("            ultima riga       : " + $an.Ultima)
  if($an.Formato -ne "FORMATO1"){
    [void]$RigheCenso.Add("            -> NON LEGGIBILE da anatomia_aperture.py.")
    [void]$RigheCenso.Add("               Questo e' il formato che scrive importa_storico_esterno.ps1,")
    [void]$RigheCenso.Add("               non quello di histdata_m1.py --converti. E' un ALTRO file")
    [void]$RigheCenso.Add("               con lo STESSO NOME: non e' un file mancante.")
    [void]$Note.Add("P3: " + $cand + " esiste ma e' in formato " + $an.Formato + ": NON e' una fonte per questo strumento.")
    continue
  }
  if($FonteScelta -eq ""){
    $FonteScelta  = $cand
    $FonteComeE   = "CSV Formato1"
    $FonteStato   = "MISURABILE"
    $FonteBarre   = $an.Barre
    $FonteMB      = $an.MB
    $FonteData    = $an.Scritto
    $FonteFormato = $an.Formato
    $FontePrima   = $an.Prima
    $FonteUltima  = $an.Ultima
    [void]$RigheCenso.Add("            => E' QUESTA LA FONTE USATA.")
  } else {
    [void]$RigheCenso.Add("            -> C'E' ANCHE QUESTA, e NON e' quella usata (si usa " + $FonteScelta + ").")
    [void]$Note.Add("P3: esiste una SECONDA copia leggibile in " + $cand + " (" + $an.MB + " MB, prima riga di dati " + $an.Prima + "). NON e' quella misurata: lo studio vuole la finestra PIU' LUNGA, e la copia scelta e' " + $FonteScelta + ".")
  }
}
[void]$RigheCenso.Add("")
if($FonteStato -eq "MISURABILE"){
  [void]$RigheCenso.Add("FONTE: MISURABILE -- " + $FonteScelta)
  Dico ("fonte MISURABILE: " + $FonteScelta + "  (" + $FonteMB + " MB, " + $FonteFormato + ")") "Green"
  Dico ("  prima riga: " + $FontePrima) "DarkGray"
  Dico ("  ultima riga: " + $FonteUltima) "DarkGray"
  if($BarreAttese -gt 0 -and $FonteBarre -gt 0){
    $scarto = [Math]::Abs($FonteBarre - $BarreAttese)
    if($scarto -gt ($BarreAttese * 0.05)){
      [void]$Note.Add("P3: barre STIMATE " + $FonteBarre + " contro le " + $BarreAttese + " del referto agli atti (25/08). E' una stima dalla lunghezza media di riga, non un conteggio: il numero vero lo dice lo strumento in P5, ed e' li' che va confrontato.")
    }
  }
} else {
  $FonteStato = "NON MISURABILE"
  [void]$RigheCenso.Add("FONTE: NON MISURABILE -- nessun CSV in Formato 1 fra i candidati.")
  [void]$Problemi.Add("P3: nessuna fonte leggibile. Candidati provati: " + ($Viste -join " ; "))
  Dico "FONTE NON MISURABILE: nessun CSV in Formato 1 fra i candidati." "Red"
}
[void]$RigheCenso.Add("")
[void]$RigheCenso.Add("IL FUSO, DICHIARATO (e non e' un dettaglio):")
[void]$RigheCenso.Add("  l'ora scritta in questo CSV e' ORA LOCALE DI NEW YORK. Non e'")
[void]$RigheCenso.Add("  un'assunzione: 8 import HistData su 8 hanno calibrato uno shift")
[void]$RigheCenso.Add("  FISSO +5 contro il nativo BCM, e uno shift fisso su sette anni e'")
[void]$RigheCenso.Add("  possibile solo se il feed segue il DST americano come il server.")
[void]$RigheCenso.Add("  apertura cash Nasdaq = 09:30 New York = 14:30 server BCM = 15:30 italiana.")
[void]$RigheCenso.Add("  Percio' -OraApertura vale " + $OraApertura + " e NON si converte niente.")
[void]$RigheCenso.Add("  Chi passasse 14:30 misurerebbe il primo pomeriggio di New York.")
[void]$RigheCenso.Add("  E lo strumento non si fida nemmeno di questo: il CANARINO DEL FUSO")
[void]$RigheCenso.Add("  misura da solo, mese per mese, se il feed segue il DST.")
Set-Content -LiteralPath $Censo -Encoding ASCII -Value $RigheCenso

# =====================================================================
#  P4. IL LUCCHETTO DEI CRITERI, LETTO AL PIN (checklist 82).
#      Il gate cerca la STRINGA in TUTTO il file, non nel titolo: un
#      lucchetto rimasto in un paragrafo E' un pezzo non firmato.
# =====================================================================
Titolo "P4 - I CRITERI, LETTI AL PIN"
Remove-Item -LiteralPath $CritFile -Force -ErrorAction SilentlyContinue
$Token = '[DA ' + 'FIRMARE]'    # spezzato: questo script NON deve contenere il token
                                # intero, o si autoaccuserebbe (checklist 77)
try{
  Invoke-WebRequest -Uri ($RawPin + "/backtest_pipeline/risultati_archivio/STUDIO_APERTURE_CRITERI.md") -OutFile $CritFile -UseBasicParsing -ErrorAction Stop
  $trovati = @(Select-String -LiteralPath $CritFile -SimpleMatch -Pattern $Token)
  $DaFirmare = ($trovati.Count -gt 0)
  Dico ("criteri scaricati al pin: " + $CritFile) "Green"
  Dico ("lucchetti della firma trovati nel file: " + $trovati.Count) $(if($DaFirmare){ "Yellow" }else{ "Green" })
  foreach($t in $trovati){ Dico ("   riga " + $t.LineNumber + ": " + $t.Line.Trim()) "DarkGray" }
}catch{
  $DaFirmare = $true
  [void]$Problemi.Add("P4: i CRITERI non si sono scaricati al pin (" + (UnaRiga $_.Exception.Message) + "). Nel dubbio il lucchetto resta CHIUSO: non si misura al buio.")
  Dico "criteri NON scaricati: il lucchetto resta CHIUSO (verso prudente)." "Red"
}

#  LE TRE FRASI SI COSTRUISCONO SUL VALORE LETTO, MAI SU UN RAMO SOLO
#  (checklist 82 pezzo 3): uno switch di bypass che si autodescrive
#  sempre allo stesso modo mente meta' delle volte.
if($DaFirmare -and $CriteriFirmati){
  $StatoFirma = "NON FIRMATI NEL FILE -- firma data IN RIGA con -CriteriFirmati"
} elseif($DaFirmare){
  $StatoFirma = "NON FIRMATI (il file porta ancora il lucchetto della firma)"
} elseif($CriteriFirmati){
  $StatoFirma = "FIRMATI NEL FILE -- lo switch -CriteriFirmati e' INERTE, va tolto dalla riga"
  [void]$Note.Add("P4: -CriteriFirmati passato ma il file e' gia' firmato: lo switch e' INERTE. Va TOLTO dalla riga, o diventa un bypass permanente che il giorno di un lucchetto nuovo non fermera' niente.")
} else {
  $StatoFirma = "FIRMATI NEL FILE"
}
Dico ("stato dei criteri: " + $StatoFirma) $(if($DaFirmare -and -not $CriteriFirmati){ "Red" }else{ "Green" })

if($SoloControllo){
  Write-Host ""
  Write-Host "GIRO A VUOTO: qui la corsa vera comincerebbe a misurare. Mi fermo." -ForegroundColor Cyan
  Write-Host ("Censimento scritto in: " + $Censo) -ForegroundColor Cyan
  Write-Host ("Fonte: " + $FonteStato + " -- " + $FonteScelta) -ForegroundColor $(if($FonteStato -eq "MISURABILE"){ "Green" }else{ "Red" })
  Write-Host ("Criteri: " + $StatoFirma) -ForegroundColor $(if($DaFirmare -and -not $CriteriFirmati){ "Yellow" }else{ "Green" })
  #  IL GIRO A VUOTO NON ESCE 0 SE UN PEZZO E' FALLITO (checklist 14), e
  #  i rilievi si stampano QUI: un problema che vive in un file che
  #  nessuno apre e' un problema che non esiste.
  foreach($prob in $Problemi){ Write-Host ("   RILIEVO: " + $prob) -ForegroundColor Yellow }
  foreach($nota in $Note){ Write-Host ("   nota: " + $nota) -ForegroundColor DarkGray }
  if($DaFirmare -and -not $CriteriFirmati){
    Write-Host ""
    Write-Host "I CRITERI NON SONO ANCORA FIRMATI: la CORSA VERA non partirebbe." -ForegroundColor Yellow
    Write-Host "Il giro a vuoto serve proprio a far leggere i criteri PRIMA di firmarli." -ForegroundColor Yellow
  }
  if($Problemi.Count -gt 0 -or $FonteStato -ne "MISURABILE"){ exit 1 }
  exit 0
}

if($DaFirmare -and -not $CriteriFirmati){
  Write-Host ""
  Write-Host "!!! NON PARTO: I CRITERI NON SONO FIRMATI." -ForegroundColor Red
  Write-Host "    Il file STUDIO_APERTURE_CRITERI.md al pin porta ancora il lucchetto" -ForegroundColor Yellow
  Write-Host "    della firma. Si legge, si firma, si ri-pinna, e si rilancia." -ForegroundColor Yellow
  Write-Host "    (Il GIRO A VUOTO -SoloControllo parte lo stesso: serve a questo.)" -ForegroundColor Yellow
  exit 2
}
if($FonteStato -ne "MISURABILE"){
  Write-Host ""
  Write-Host "!!! NON PARTO: NESSUNA FONTE LEGGIBILE. Guarda il censimento:" -ForegroundColor Red
  Write-Host ("    " + $Censo) -ForegroundColor Yellow
  exit 2
}

# =====================================================================
#  P5. LA CORSA VERA
# =====================================================================
Titolo "P5 - LA CORSA (una passata in streaming: attesa meno di un minuto)"
$Uscite = Join-Path $Sosta "misure"
New-Item -ItemType Directory -Force -Path $Uscite | Out-Null
$logRun = Join-Path $SostaLog "anatomia.log"
$Inizio = Get-Date
$RcPython = EseguiPython @("-u",$PyFile,
                           "--file",$FonteScelta,
                           "--simbolo",$Simbolo,
                           "--uscita",$Uscite,
                           "--ora-apertura",$OraApertura) $logRun
Dico ("python uscito con " + $RcPython + " dopo " + (N1 ((New-TimeSpan -Start $Inizio -End (Get-Date)).TotalSeconds)) + " s") `
     $(if($RcPython -eq 0){ "Green" } elseif($RcPython -eq 1){ "Yellow" } else{ "Red" })

#  L'ECO A SCHERMO: le righe che Claudio deve poter leggere SENZA aprire
#  un file. Si prendono dal log della corsa, per schema.
#  ATTENZIONE: I RILIEVI DELLO STRUMENTO CI VANNO DENTRO, e non e' un di piu':
#  un rilievo che vive solo in un file che nessuno apre e' un rilievo che
#  non esiste. Percio' si prendono anche le righe "!!!" (l'avviso
#  sull'ora sbagliata) e i trattini dell'elenco finale dei rilievi.
foreach($linea in @(Get-Content -LiteralPath $logRun -ErrorAction SilentlyContinue)){
  if($linea -match '^\s*(barre lette|giorni BUONI|RAM di picco|ESITO:)' -or
     $linea -match '^\s*!!!' -or
     $linea -match '^\s+- \S' -or
     $linea -match 'INVERNO .* ESTATE ' -or
     $linea -match '-> (coerente col DST|EST FISSO|INCERTO)'){
    Write-Host ("   " + $linea.Trim()) -ForegroundColor DarkGray
    [void]$Lettura.Add($linea.Trim())
  }
}
if($RcPython -eq 2){
  [void]$Problemi.Add("P5: lo strumento e' uscito con 2 = NON PARTITO (file assente, formato sbagliato, zero barre o parametri incoerenti). Guarda log\anatomia.log: il messaggio dice QUALE dei casi.")
} elseif($RcPython -eq 1){
  [void]$Note.Add("P5: lo strumento e' uscito con 1 = MISURATO CON RILIEVI. NON e' un guasto: gli artefatti ci sono e i rilievi sono scritti in fondo a ogni referto.")
} elseif($RcPython -ne 0){
  [void]$Problemi.Add("P5: lo strumento e' uscito con " + $RcPython + ", che non e' un codice previsto (0/1/2). Guarda log\anatomia.log.")
}

# =====================================================================
#  P6. RACCOLTA. Gli ATTESI si costruiscono da quello che c'e' DAVVERO
#      in cartella, e si confrontano coi TROVATI (checklist 70): mai un
#      elenco scritto a mano.
# =====================================================================
Titolo "P6 - RACCOLTA"
$Prodotti = @(Get-ChildItem -LiteralPath $Uscite -File -ErrorAction SilentlyContinue)
if($Prodotti.Count -eq 0){
  [void]$Problemi.Add("P6: lo strumento non ha prodotto NESSUN file in " + $Uscite + ". Non c'e' niente da raccogliere oltre ai log.")
  Dico "nessun file prodotto." "Red"
}
#  i nomi dei file sono UNICI, quindi qui Sort-Object non ha pari da
#  riordinare e l'ordine e' deterministico (checklist 81).
foreach($p in ($Prodotti | Sort-Object Name)){
  [void](CopiaVerificata $p.FullName (Join-Path $Sosta $p.Name))
  [void]$Attesi.Add($p.Name)
  $eta = (New-TimeSpan -Start $p.LastWriteTime -End (Get-Date)).TotalMinutes
  if($eta -gt 30){
    [void]$Problemi.Add("P6: " + $p.Name + " ha " + [int]$eta + " minuti: NON e' stato scritto da questa corsa. E' un artefatto STANTIO.")
  }
  if($p.Name -like "*PERGIORNO*"){
    $RigheCsvOut = (ContaRighe $p.FullName) - 1
    Dico ($p.Name + ": " + $RigheCsvOut + " righe di dati") $(if($RigheCsvOut -ge $MinRigheCsv){ "Green" }else{ "Yellow" })
    if($RigheCsvOut -lt $MinRigheCsv){
      [void]$Problemi.Add("P6: il CSV per-giorno ha " + $RigheCsvOut + " righe, sotto le " + $MinRigheCsv + " attese per 16 anni di borsa (~250 giorni all'anno piu' le domeniche del feed 24h). Il file letto e' quello giusto?")
    }
  } else {
    Dico ($p.Name + ": " + [Math]::Round($p.Length/1KB,1) + " KB") "Green"
  }
}
Remove-Item -LiteralPath $Uscite -Recurse -Force -ErrorAction SilentlyContinue

# =====================================================================
#  P7. REFERTO DEL DRIVER + ZIP
# =====================================================================
Titolo "P7 - REFERTO E ZIP"
[void]$RefRighe.Add("=====================================================================")
[void]$RefRighe.Add(" REFERTO DEL DRIVER -- ANATOMIA DELLE APERTURE (FASE 1)")
[void]$RefRighe.Add("=====================================================================")
[void]$RefRighe.Add("data: " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   <-- QUESTA DATA DEVE ESSERE DI ADESSO")
[void]$RefRighe.Add("avvio: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   durata: " + (N2 ((New-TimeSpan -Start $Avvio -End (Get-Date)).TotalMinutes)) + " min")
[void]$RefRighe.Add("macchina: " + $env:COMPUTERNAME + "   utente: " + $env:USERNAME)
[void]$RefRighe.Add("pin: " + $Pin)
[void]$RefRighe.Add("strumento: anatomia_aperture.py ANATOMIA_APERTURE_v1 (al pin, autotest superato)")
[void]$RefRighe.Add("python: " + $Python + "  " + $PyVers)
[void]$RefRighe.Add("stato dei criteri: " + $StatoFirma)
[void]$RefRighe.Add("switch -CriteriFirmati: " + $(if($CriteriFirmati){ "passato" }else{ "non passato" }))
[void]$RefRighe.Add("")
[void]$RefRighe.Add("!!! QUESTA CORSA NON FIRMA NIENTE E NON PROMUOVE NIENTE.")
[void]$RefRighe.Add("    E' la FASE 1: anatomia descrittiva. Non c'e' un profit factor,")
[void]$RefRighe.Add("    non c'e' un'equity, non c'e' un motore. Una classe frequente NON")
[void]$RefRighe.Add("    e' un edge: e' una frequenza.")
[void]$RefRighe.Add("")
[void]$RefRighe.Add("!!! IL CANCELLO QUALITA' DEL FEED E' IN VERIFICA (misure lampo del")
[void]$RefRighe.Add("    26/08, tre eventi anomali). Lo studio gira lo stesso, ma")
[void]$RefRighe.Add("    L'INTERPRETAZIONE DI QUESTI NUMERI DIPENDE DA QUELL'ESITO.")
[void]$RefRighe.Add("    Contromisura interna: i giorni con copertura oraria anomala sono")
[void]$RefRighe.Add("    esclusi dai conteggi e contati a parte, cosi' il peso della")
[void]$RefRighe.Add("    malattia si LEGGE nella colonna SOSPETTI invece di restare")
[void]$RefRighe.Add("    mescolato ai risultati.")
[void]$RefRighe.Add("")
[void]$RefRighe.Add("!!! LA REGOLA DELLE DUE FASI, che il referto ripete apposta:")
[void]$RefRighe.Add("    le IPOTESI di motore si scrivono SOLO sul referto _IS_ (fino al")
[void]$RefRighe.Add("    2020). Il referto _CASSAFORTE_ (2021-2026) NON si guarda per")
[void]$RefRighe.Add("    costruirle: serve a validarle DOPO che sono congelate. Se le")
[void]$RefRighe.Add("    ipotesi nascono guardando la cassaforte, la cassaforte non e' piu'")
[void]$RefRighe.Add("    una validazione.")
[void]$RefRighe.Add("")
[void]$RefRighe.Add("--- LA FONTE ---")
[void]$RefRighe.Add("  stato   : " + $FonteStato)
[void]$RefRighe.Add("  file    : " + $FonteScelta)
[void]$RefRighe.Add("  formato : " + $FonteFormato + "   (riconosciuto APRENDO il file, non dal nome)")
[void]$RefRighe.Add("  " + $FonteMB + " MB, scritto il " + $FonteData)
[void]$RefRighe.Add("  prima riga di dati: " + $FontePrima)
[void]$RefRighe.Add("  ultima riga       : " + $FonteUltima)
[void]$RefRighe.Add("  barre attese agli atti (referto storico indici 25/08): " + $BarreAttese)
[void]$RefRighe.Add("  Il dettaglio di TUTTI i candidati sta in CENSIMENTO_FONTE.txt.")
[void]$RefRighe.Add("")
[void]$RefRighe.Add("--- IL FUSO ---")
[void]$RefRighe.Add("  ora del file = NEW YORK. apertura cash Nasdaq = 09:30 New York")
[void]$RefRighe.Add("  = 14:30 ora server BCM = 15:30 italiana. -OraApertura passata: " + $OraApertura)
[void]$RefRighe.Add("  Qui NON si converte niente, e lo strumento MISURA la convenzione")
[void]$RefRighe.Add("  da solo (canarino del fuso, mese per mese, in testa a ogni referto).")
[void]$RefRighe.Add("")
[void]$RefRighe.Add("--- LE RIGHE CHIAVE DELLA CORSA (dal log dello strumento) ---")
if($Lettura.Count -eq 0){ [void]$RefRighe.Add("  nessuna: la corsa non e' arrivata a stampare i suoi conteggi.") }
foreach($linea in $Lettura){ [void]$RefRighe.Add("  " + $linea) }
[void]$RefRighe.Add("")
[void]$RefRighe.Add("  righe di dati nel CSV per-giorno: " + $(if($RigheCsvOut -lt 0){ "n/d" }else{ "" + $RigheCsvOut }))
[void]$RefRighe.Add("  codice d'uscita dello strumento : " + $(if($RcPython -lt 0){ "n/d" }else{ "" + $RcPython }))
[void]$RefRighe.Add("  (0 = misurato / 1 = misurato CON RILIEVI, e i rilievi sono una")
[void]$RefRighe.Add("   risposta / 2 = non partito. n/d = non misurato, mai uno zero.)")
[void]$RefRighe.Add("")
[void]$RefRighe.Add("--- COME SI LEGGERA' IL RISULTATO (scritto PRIMA di vederlo) ---")
[void]$RefRighe.Add("  1. Si apre PRIMA il CANARINO DEL FUSO. Se dice EST FISSO, tutto il")
[void]$RefRighe.Add("     resto e' misurato un'ora fuori bersaglio per meta' anno e va")
[void]$RefRighe.Add("     rifatto: non si legge nient'altro.")
[void]$RefRighe.Add("  2. Poi la COPERTURA. Se un anno ha molti giorni sospetti, i suoi")
[void]$RefRighe.Add("     conteggi valgono meno: e' la malattia del feed, misurata.")
[void]$RefRighe.Add("  3. Poi la DISTRIBUZIONE DELLE CLASSI del referto _IS_. La domanda")
[void]$RefRighe.Add("     di Claudio era 'quale setup si presenta di piu''.")
[void]$RefRighe.Add("  4. Una classe frequente NON e' un edge. Le escursioni mediane per")
[void]$RefRighe.Add("     classe dicono se quel movimento e' abbastanza grande da pagare")
[void]$RefRighe.Add("     spread e stop -- e QUELLO si misura in FASE 2, non qui.")
[void]$RefRighe.Add("  5. La colonna 2LATI dice quanto pesa la regola di priorita' della")
[void]$RefRighe.Add("     classificazione: se e' grossa, quella regola e' una scelta che")
[void]$RefRighe.Add("     conta e va discussa, non un dettaglio.")
[void]$RefRighe.Add("")
[void]$RefRighe.Add("--- QUELLO CHE QUESTA CORSA NON PUO' DIRE ---")
[void]$RefRighe.Add("  Un simbolo solo (" + $Simbolo + "): niente DAX e niente Dow. HistData non")
[void]$RefRighe.Add("  ha il Dow, e il DAX (grxeur) e' BOCCIATO in attesa di diagnosi")
[void]$RefRighe.Add("  (decisione D-F, referto storico indici del 25/08). Sono round a se'.")
[void]$RefRighe.Add("  Un feed solo (HistData), che NON e' BCM: spread, orari di seduta e")
[void]$RefRighe.Add("  prezzi non sono quelli su cui si opera.")
[void]$RefRighe.Add("  Nessun costo, nessun fill, nessuna posizione: qui non si puo'")
[void]$RefRighe.Add("  dedurre se un motore guadagnerebbe.")
[void]$RefRighe.Add("")

$TrovatiOra = @(@(Get-ChildItem -LiteralPath $Sosta -File -ErrorAction SilentlyContinue | ForEach-Object { $_.Name }) + @("REFERTO_ANATOMIA_APERTURE.txt") | Sort-Object -Unique)
$QuantiLog  = @(Get-ChildItem -LiteralPath $SostaLog -File -ErrorAction SilentlyContinue).Count
[void]$RefRighe.Add("--- FILE ATTESI E FILE TROVATI ---")
[void]$RefRighe.Add("  attesi : " + (($Attesi | Sort-Object -Unique) -join ", "))
[void]$RefRighe.Add("  trovati: " + ($TrovatiOra -join ", "))
[void]$RefRighe.Add("           (+ la cartella log\ con " + $QuantiLog + " file: l'uscita cruda di ogni chiamata a python)")
[void]$RefRighe.Add("           REFERTO_ANATOMIA_APERTURE.txt e' l'ULTIMO file scritto: se stai leggendo questa riga, c'e'.")
$Mancanti = @($Attesi | Sort-Object -Unique | Where-Object { $TrovatiOra -notcontains $_ })
if($Mancanti.Count -gt 0){
  [void]$Problemi.Add("P7: mancano dalla raccolta: " + ($Mancanti -join ", "))
  [void]$RefRighe.Add("  MANCANTI: " + ($Mancanti -join ", "))
} else {
  [void]$RefRighe.Add("  MANCANTI: nessuno")
}
[void]$RefRighe.Add("")
[void]$RefRighe.Add("--- NOTE ---")
if($Note.Count -eq 0){ [void]$RefRighe.Add("  nessuna") }
foreach($nota in $Note){ [void]$RefRighe.Add("  - " + $nota) }
[void]$RefRighe.Add("")
[void]$RefRighe.Add("--- PROBLEMI ---")
if($Problemi.Count -eq 0){ [void]$RefRighe.Add("  nessuno") }
foreach($prob in $Problemi){ [void]$RefRighe.Add("  - " + $prob) }
[void]$RefRighe.Add("")

if($Problemi.Count -gt 0){
  $Uscita = 1
  [void]$RefRighe.Add("ESITO: PARZIALE -- " + $Problemi.Count + " problemi.")
  [void]$RefRighe.Add("       'non misurabile' E' GIA' UNA RISPOSTA: questo referto va mandato lo stesso.")
} elseif($RcPython -eq 1){
  $Uscita = 1
  [void]$RefRighe.Add("ESITO: MISURATO CON RILIEVI -- la corsa e' riuscita e lo strumento ha")
  [void]$RefRighe.Add("       segnalato dei rilievi (in fondo a ogni referto). Va mandato tutto.")
} else {
  $Uscita = 0
  [void]$RefRighe.Add("ESITO: OK")
}
Set-Content -LiteralPath $Referto -Encoding ASCII -Value $RefRighe

Compress-Archive -Path (Join-Path $Sosta "*") -DestinationPath $ZipFin -Force
#  LO ZIP SI CONTROLLA DENTRO, non sull'esistenza del nome (checklist
#  27-ter): se manca un pezzo si vede ADESSO, non quando Claudio l'ha
#  gia' mandato in chat.
$DentroZip = @()
if(Test-Path -LiteralPath $ZipFin){
  try{ Add-Type -AssemblyName System.IO.Compression.FileSystem -ErrorAction Stop }catch{ }
  $arch = $null
  try{
    $arch = [System.IO.Compression.ZipFile]::OpenRead($ZipFin)
    $DentroZip = @($arch.Entries | ForEach-Object { $_.Name })
  }catch{
    [void]$Note.Add("P7: lo zip non si e' lasciato rileggere (" + (UnaRiga $_.Exception.Message) + "): il contenuto NON e' stato verificato.")
  }finally{ if($null -ne $arch){ try{ $arch.Dispose() }catch{ } } }
}
if(-not (Test-Path -LiteralPath $ZipFin)){
  Write-Host "!!! LO ZIP NON E' STATO CREATO: manda la CARTELLA sul Desktop." -ForegroundColor Red
  $Uscita = 1
} else {
  $FuoriZip = @($Attesi | Sort-Object -Unique | Where-Object { $DentroZip -notcontains $_ })
  if($DentroZip.Count -eq 0){
    Write-Host "ATTENZIONE: contenuto dello zip NON verificato (vedi NOTE del referto)." -ForegroundColor Yellow
  } elseif($FuoriZip.Count -gt 0){
    Write-Host ("!!! NELLO ZIP MANCANO: " + ($FuoriZip -join ", ") + " -- manda anche la CARTELLA " + $Sosta) -ForegroundColor Red
    $Uscita = 1
  } else {
    Write-Host ("contenuto dello zip verificato: " + $DentroZip.Count + " file, ci sono tutti gli attesi.") -ForegroundColor Green
  }
}

Write-Host ""
Write-Host ("REFERTO: " + $Referto) -ForegroundColor Cyan
Write-Host ("ZIP DA MANDARE IN CHAT: " + $ZipFin) -ForegroundColor Cyan
Write-Host "ELENCO FILE ATTESI (prodotto dal codice, non scritto a mano):" -ForegroundColor Cyan
foreach($att in ($Attesi | Sort-Object -Unique)){ Write-Host ("   " + $att) }
Write-Host ""
if($Problemi.Count -gt 0){
  Write-Host ("ESITO: PARZIALE -- " + $Problemi.Count + " problemi. IL REFERTO VA MANDATO LO STESSO:") -ForegroundColor Yellow
  foreach($prob in $Problemi){ Write-Host ("   - " + $prob) -ForegroundColor Yellow }
} elseif($RcPython -eq 1){
  Write-Host "ESITO: MISURATO CON RILIEVI. I rilievi sono in fondo a ogni referto:" -ForegroundColor Yellow
  Write-Host "sono una RISPOSTA, non un guasto. Manda tutto lo stesso." -ForegroundColor Yellow
} else {
  Write-Host "ESITO: OK" -ForegroundColor Green
}
Write-Host ("Nel referto, la riga 'data:' deve dire " + (Get-Date).ToString("yyyy-MM-dd HH:mm",$INV) + " circa: se dice altro, stai guardando un file vecchio.") -ForegroundColor Cyan
exit $Uscita
