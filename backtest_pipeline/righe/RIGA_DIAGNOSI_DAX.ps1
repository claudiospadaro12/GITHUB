# =====================================================================
#  MARCATORE_RIGA_DIAGNOSI_DAX_v1
#  RIGA_DIAGNOSI_DAX.ps1  --  LA DIAGNOSI DEL DAX HISTDATA (grxeur)
#                             (26/08/2026, PC di backtest)
# ---------------------------------------------------------------------
#  PERCHE' ESISTE, E CHI L'HA AUTORIZZATA
#  STORICO_INDICI_CRITERI.md porta la decisione D-F, gia' FIRMATA da
#  Claudio il 25/08 ("FIRMO CON PROPOSTE"):
#        @DECISIONE D-F CHIAVE=STRADA_DAX VALORE=diagnosi_prima
#  cioe': prima di qualunque import del DAX si fa la DIAGNOSI dei dati.
#  QUESTA RIGA E' QUELLA DIAGNOSI. Non aggiunge nessuna decisione nuova
#  e non chiede nessuna firma nuova: cita quella che c'e' gia' e la
#  LEGGE al pin (se D-F non fosse piu' firmata, la diagnosi non parte).
#
#  IL FATTO DA CUI SI PARTE (REFERTO_HISTDATA_FATTIBILITA.md par. 13):
#  nella corsa del 18/08 il DAX di HistData (grxeur) e' stato BOCCIATO
#  dai cancelli dello strumento, per DUE motivi:
#    1. prezzo minimo 2.906,949 -- un DAX sotto 8.000 non esiste nel
#       2019-2026 (minimo Covid ~8.255);
#    2. apertura di seduta modale 00:00 fino a 2020-05, POI 02:00 da
#       2020-06 a 2023-11, POI di nuovo 00:00 (le altre tre serie
#       promosse sono 00:00 fisse).
#  Da allora NESSUNO ha guardato DOVE stanno quelle righe e COSA copre
#  davvero quella sessione: il modo --diagnosi di histdata_m1.py
#  (HD-M1-v4) esiste dal 19/08 e NON e' MAI STATO ESEGUITO SUI DATI
#  VERI. Qui si esegue.
#
#  LE TRE DOMANDE, SCRITTE PRIMA DI GUARDARE I NUMERI
#   Q1  I prezzi impossibili: in QUALI ANNI? E sono un problema di
#       SCALA/VALUTA (giornate intere a un valore diverso) o
#       SPAZZATURA (pochi tick isolati)?
#   Q2  La sessione ballerina 2020-2023: QUALI ORE coprono i giorni?
#       E' un CAMBIO DI CONVENZIONE (orari del CFD cambiati, giornate
#       piene ma spostate) o sono BUCHI DI FEED (stesse ore, meno
#       barre)?
#   Q3  Esiste un SOTTOINSIEME SANO dichiarabile (anni + ore) che
#       reggerebbe i cancelli dello strumento?
#  Il verdetto ha TRE esiti, e sono decisi qui, prima della misura:
#       SANO PARZIALE (elenco anni) / RIPARABILE (la convenzione X) /
#       MARCIO.
#
#  ###################################################################
#  #  QUELLO CHE QUESTA RIGA **NON** FA:                             #
#  #  NON importa niente in MT5. NON crea nessun simbolo _EXT. NON   #
#  #  autorizza l'uso di nessun dato: il CANCELLO ZERO sugli indici  #
#  #  _EXT resta CHIUSO (0,061-0,101% contro <=0,05%) e la D-C dice  #
#  #  SOLO_PROVA_REGIME. Qui si produce un REFERTO, e basta.         #
#  #  NON tocca R110/R111/RIGA_STORICO/MISURE_LAMPO/ANATOMIA.        #
#  ###################################################################
#
#  NIENTE MT5, ED E' UNA DICHIARAZIONE (checklist 7)
#  Questa riga non apre MetaTrader ne' MetaEditor e non scrive un byte
#  dentro MetaQuotes\Terminal: legge ZIP e scrive sul Desktop. MT5 puo'
#  restare aperto. L'unica risorsa contesa e' la RAM (histdata_m1.py
#  tiene in memoria le barre del pezzo che analizza: ~690 byte a barra,
#  MISURATO, checklist 74) -- e qui si analizza UN ANNO ALLA VOLTA,
#  cioe' ~330.000 barre = ~230 MB. La RAM libera si misura prima.
#
#  LA RETE: SOLO SE LA CHIEDI, E DICHIARATA
#  Di suo questa corsa e' OFFLINE (a parte lo scarico dello strumento e
#  dei criteri al pin): diagnostica gli ZIP grxeur GIA' SUL DISCO
#  (2019-2026, scaricati il 18/08). Con -EstendiIndietro scarica anche
#  gli anni mancanti della finestra (2010-2018) -- ~10 s per anno,
#  misurati il 25/08 -- e li DIAGNOSTICA nella stessa corsa: e' uno
#  scarico che serve alla diagnosi, non un import. Ha il suo canarino
#  di ritmo, con la soglia FIRMATA in D-E.
#
#  QUELLO CHE LO STRUMENTO PUO' CANCELLARE (checklist 26: "oltre a
#  stampare, cosa FA?"): histdata_m1.py, quando ingerisce una cartella
#  di ZIP, CANCELLA quelli che non riesce ad aprire. Per questo la
#  diagnosi NON gli fa mai vedere la cache: ogni anno viene COPIATO in
#  una cartella di lavoro usa-e-getta. Lo strumento puo' cancellare
#  solo le nostre copie; la cache di ~\histdata_m1 non si tocca.
#
#  COSA E' STATO PROVATO PRIMA DI MANDARLA, E COSA NO (26/08)
#    PROVATO ESEGUENDO, su un banco sintetico costruito apposta:
#      - histdata_m1.py --diagnosi su un anno finto di grxeur: gira,
#        esce con codice 0 ANCHE quando trova barre fuori banda (le
#        barre marce sono il risultato, non un guasto), e ingerisce gli
#        ZIP quando in cartella non c'e' nessun CSV. Tempo misurato:
#        3,7 s per 266.000 barre, cioe' ~5 s per un anno vero.
#      - le NOVE espressioni regolari con cui questo driver legge quel
#        referto: 9 su 9 agganciano la riga giusta, zero falsi positivi
#        (provate sul referto VERO prodotto dallo strumento, non su uno
#        finto scritto da me).
#      - la LOGICA della mappa e della classificazione, riscritta in
#        python e fatta girare su QUATTRO anni finti: sano / sessione
#        spostata ma piena / buchi (25 barre l'ora) / spike isolati.
#        Quattro classi su quattro giuste -- ma solo DOPO due difetti
#        trovati proprio li', ed e' il motivo per cui il banco esisteva:
#        (1) con la sola soglia "ora piena" un anno tutto a buchi non
#            aveva NESSUNA ora coperta -> finestra e densita' n/d, cioe'
#            "non lo so" proprio sulla domanda Q2. Da qui le DUE misure
#            (ore toccate / ore piene).
#        (2) due GIORNATE intere fuori banda sono lo 0,77% delle barre:
#            con la regola "poche barre E pochi giorni" finivano MARCIO,
#            mentre si escludono con due date. Da qui la regola OPPURE.
#    ESEGUITO DAVVERO IL 26/08 (verificatore, pwsh 7.4.6 + histdata_m1.py
#      VERO + banchi di ZIP sintetici, con stub solo su rete/RAM/Desktop):
#      parse reale del file, giro a vuoto (BLOCCO 1), giro completo
#      (BLOCCO 2) su 5 anni finti, i tre rami di D-F piu' il file dei
#      criteri illeggibile, zip rotto, cache vuota, controllo positivo
#      nei DUE versi, e il CSV avvelenato nella cache (cl.83: la diagnosi
#      per anno NON lo legge, come promesso -- verificato dalla riga
#      "fonte: ZIP in ...anno_AAAA" di ogni referto). Quattro difetti
#      trovati COSI', e tutti e quattro invisibili a rileggere il codice:
#        1. l'elenco dei giorni sporchi dello strumento e' TRONCATO a 40
#           e ordinato per barre: Q1 rispondeva "e' SCALA/VALUTA" con 19
#           giorni di spike buttati via dal taglio;
#        2. la guardia-sulla-guardia sulla densita' viveva dentro
#           "if(controllo positivo esiste)": senza zip nsxusd in cache un
#           MARCIO usciva con PROBLEMI nessuno ed ESITO OK (uscita 0);
#        3. la console stampava "ESITO: OK" verde mentre lo script usciva
#           1 (cache vuota): due esiti da due espressioni diverse;
#        4. la colonna 'finestra' del referto non diceva in che OROLOGIO
#           sono scritte le ore (sono NY, non ora server BCM).
#    NON PROVATO, e va detto: -EstendiIndietro (P5) non e' stato
#      esercitato -- serve la rete di HistData; il ramo "ZIP API non
#      caricata" non e' stato forzato; e nessuna di queste corse e' mai
#      girata su Windows PowerShell 5.1, che resta il primo giro vero.
#      Percio' il BLOCCO 1 esiste: non misura niente e serve solo a
#      vedere se sta in piedi sulla macchina di Claudio.
#
#  LE FASI
#   P0  pin, cultura invariante, cartelle, RAM, ZIP API
#   P1  python vero (checklist 17: si MISURA, non si deduce)
#   P2  histdata_m1.py AL PIN + marcatore HD-M1-v4 + autotest 11/11
#       + la BANDA DI PREZZO letta DAL SORGENTE (mai riscritta qui)
#   P3  CRITERI al pin: D-F letta a macchina. Non firmata -> la
#       diagnosi NON parte e il referto lo scrive.
#   P4  CENSIMENTO: ogni ZIP si APRE e si legge il nome del CSV che ha
#       DENTRO (e' la regola dello strumento). Tre stati per anno.
#   P5  (solo con -EstendiIndietro) canarino + scarico degli anni
#       mancanti, uno per volta, con battito sulla CRESCITA dei file
#   P6  DIAGNOSI ANNO PER ANNO (histdata_m1.py --diagnosi)
#   P7  MAPPA DELLE SESSIONI (la misura che lo strumento NON ha): per
#       anno e per mese, quali ore sono coperte e con quante barre.
#       Piu' il CONTROLLO POSITIVO su nsxusd (la serie promossa).
#   P8  VERDETTO a tre esiti, con le regole dichiarate qui sopra
#   P9  referto + zip + elenco attesi confrontato coi trovati
#
#  CODICI D'USCITA (li legge la riga di chat, checklist 13 e 26-bis)
#   0 = diagnosi completa
#   1 = parziale (un anno non misurabile, D-F non firmata, uno zip
#       rotto): IL REFERTO C'E' LO STESSO E VA MANDATO -- "non
#       misurabile" e' gia' una risposta
#   2 = NON PARTITA (pin, python, strumento, autotest, RAM): non c'e'
#       niente da mandare, si rimedia e si rilancia
#
#  LA RIGA CHE SI INCOLLA sta in
#  backtest_pipeline\righe\RIGA_DIAGNOSI_DAX_DA_MANDARE.md
#  (blocco INTERO, un comando solo: checklist 21).
# =====================================================================
[CmdletBinding()]
param(
  [string]$Pin              = "",     # OBBLIGATORIO sha40: senza, non parte
  [switch]$SoloControllo,             # giro a vuoto: P0-P4, nessuna diagnosi
  [switch]$EstendiIndietro,           # scarica gli anni mancanti della finestra (rete!)
  [switch]$SaltaControllo,            # salta il controllo positivo su nsxusd (piu' veloce)
  [int]   $AnnoDa           = 0,      # 0 = tutti gli anni trovati in cache
  [int]   $AnnoA            = 0,      # 0 = fino all'anno corrente
  [string]$CartellaHD       = "",     # default ~\histdata_m1        (cache 18/08)
  [string]$CartellaLunga    = "",     # default ~\abtg_storico_indici (corsa 25/08)
  [string]$Cartella         = "",     # cartella di lavoro (default ~\abtg_diagnosi_dax)
  [int]   $MinRamMB         = 1000,   # un anno = ~330k barre = ~230 MB, x3 di margine
  [int]   $MinBarrePerOra   = 30,     # "ora piena": la stessa soglia di vol_oraria nel .py
  [double]$SogliaDensita    = 55.0,   # barre medie per ora coperta: sotto = BUCHI DI FEED
  [double]$SogliaFuoriBanda = 0.10,   # % di barre fuori banda sotto cui lo sporco e' ISOLATO
  [int]   $MaxGiorniSporchi = 5,      # e in quanti giorni al massimo, per dirlo isolato
  [double]$OreMax           = 3.0,    # tetto: non si INIZIA niente di nuovo oltre
  [int]   $FermoMinuti      = 10,     # battito dello scarico: minuti di NON crescita
  [int]   $PausaMs          = 0       # 0 = lascia il default dello strumento (1500)
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
  Write-Host "    Usa il blocco di lancio del foglio RIGA_DIAGNOSI_DAX_DA_MANDARE.md," -ForegroundColor Yellow
  Write-Host "    con l'hash dato in chat. Girare al pin sbagliato vuol dire girare" -ForegroundColor Yellow
  Write-Host "    codice di ieri senza saperlo." -ForegroundColor Yellow
  exit 2
}
$Pin = $Pin.ToLower()

$Avvio   = Get-Date
$Stamp   = $Avvio.ToString("yyyyMMdd_HHmm",$INV)
$Desktop = [Environment]::GetFolderPath("Desktop")
if([string]::IsNullOrWhiteSpace($Desktop)){ $Desktop = Join-Path $env:USERPROFILE "Desktop" }

if([string]::IsNullOrWhiteSpace($CartellaHD))   { $CartellaHD    = Join-Path $env:USERPROFILE "histdata_m1" }
if([string]::IsNullOrWhiteSpace($CartellaLunga)){ $CartellaLunga = Join-Path $env:USERPROFILE "abtg_storico_indici" }
if([string]::IsNullOrWhiteSpace($Cartella))     { $Cartella      = Join-Path $env:USERPROFILE "abtg_diagnosi_dax" }

$Sosta    = Join-Path $Desktop ("DIAGNOSI_DAX_" + $Stamp)
$SostaLog = Join-Path $Sosta "log"
$SostaAnni= Join-Path $Sosta "anni"
$Referto  = Join-Path $Sosta "REFERTO_DIAGNOSI_DAX.txt"
$Censo    = Join-Path $Sosta "CENSIMENTO_ZIP_DAX.txt"
$Mappa    = Join-Path $Sosta "MAPPA_SESSIONI.txt"
$ZipFin   = Join-Path $Desktop ("DIAGNOSI_DAX_" + $Stamp + ".zip")
$PyFile   = Join-Path $Cartella "histdata_m1.py"
$FileCrit = Join-Path $Cartella "STORICO_INDICI_CRITERI.md"
$RawPin   = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

$PairDax  = "grxeur"
$PairCtrl = "nsxusd"
$BcmDax   = "D30EUR"
$BcmCtrl  = "NASUSD"

# --- TUTTO quello che il referto finale legge nasce QUI, FUORI dal try
#     (checklist 48 e 82 pezzo 4): su un errore a meta' il referto si
#     scrive lo stesso e non esplode su una variabile mai creata.
$Problemi   = New-Object System.Collections.ArrayList
$Note       = New-Object System.Collections.ArrayList
$Attesi     = New-Object System.Collections.ArrayList
$Lettura    = New-Object System.Collections.ArrayList
$RigheCenso = New-Object System.Collections.ArrayList
$RigheMappa = New-Object System.Collections.ArrayList
$Anni       = New-Object System.Collections.ArrayList   # una riga per anno grxeur
$AnniCtrl   = New-Object System.Collections.ArrayList   # controllo positivo nsxusd
$Python     = ""
$PyVers     = "(non letta)"
$RamLibera  = -1.0
$RamStato   = "NON MISURATA"
$ZipApi     = $false
$BandaLo    = -1.0
$BandaHi    = -1.0
$BandaFonte = "(non letta)"
$DecStato   = "NON LETTA"
$DecValore  = "(non letto)"
$DecFrase   = "la decisione D-F non e' stata letta: la diagnosi non e' autorizzata."
$PuoDiagnosticare = $false
$Canarino   = "NON MISURATO (nessuno scarico chiesto)"
$Proiezione = -1.0
$SogliaOre  = 20.0
$VerdettoQ1 = "NON MISURATA"
$VerdettoQ2 = "NON MISURATA"
$VerdettoQ3 = "NON MISURATO"
$Verdetto   = "NON MISURATO"
$ConvenzDa  = ""
$ConvenzA   = ""
$OraModale  = -1
$Uscita     = 0

# ---------------------------------------------------------------------
#  ATTREZZI (i primi copiati da RIGA_MISURE_LAMPO.ps1 e
#  RIGA_STORICO_INDICI.ps1, gia' girati sul PC di Claudio)
# ---------------------------------------------------------------------
function Ora(){ return (Get-Date).ToString("HH:mm:ss",$INV) }
function Dico($testo,$colore="Gray"){ Write-Host ("[" + (Ora) + "] " + $testo) -ForegroundColor $colore }
function Titolo($testo){ Write-Host ""; Write-Host ("=== " + $testo + " ===") -ForegroundColor Cyan }
function N1($valore){ return ([double]$valore).ToString("0.0",$INV) }
function N2($valore){ return ([double]$valore).ToString("0.00",$INV) }
function N3($valore){ return ([double]$valore).ToString("0.000",$INV) }
function Trascorse(){ return (New-TimeSpan -Start $Avvio -End (Get-Date)).TotalHours }

#  un numero NON MISURATO si scrive n/d, MAI 0: un numero plausibile al
#  posto di un buco e' il peggior refuso possibile (checklist 66)
function Nd($valore,$decimali){
  if([double]$valore -lt 0){ return "n/d" }
  if($decimali -eq 0){ return ([int]$valore).ToString($INV) }
  return ([double]$valore).ToString(("0." + ("0" * $decimali)),$INV)
}
function OraTxt($h){
  if([int]$h -lt 0){ return "n/d" }
  return ("{0:00}:00" -f [int]$h)
}
#  un messaggio d'eccezione puo' essere su PIU' RIGHE: infilato in una
#  nota del referto spezza l'elenco e sembra un referto rotto.
function UnaRiga($testo){ return (("" + $testo) -replace '[\r\n]+',' ') }

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

#  IL REFERTO NUOVO NON SI PESCA COL SORT.
#  histdata_m1.py scrive referto_histdata_<data>_<HHMM>.txt nella
#  --cartella: due chiamate nello STESSO MINUTO producono lo STESSO
#  NOME e la seconda sovrascrive la prima (checklist 26). Qui ogni anno
#  ha la SUA cartella, quindi il caso non puo' capitare -- ma la
#  guardia resta, perche' "non puo' capitare" non e' una verifica.
#  Niente Sort-Object sulle date: sui pari e' arbitrario (checklist 81).
function RefertoFresco($cartella,$prima,$inizio){
  $ris = [pscustomobject]@{ File=""; Stato="NESSUN REFERTO"; Nota="" }
  $tutti = @(Get-ChildItem -LiteralPath $cartella -Filter "referto_histdata_*.txt" -ErrorAction SilentlyContinue)
  $nuovi = @($tutti | Where-Object { $prima -notcontains $_.Name -and $_.LastWriteTime -ge $inizio })
  $sovr  = @($tutti | Where-Object { $prima -contains $_.Name -and $_.LastWriteTime -ge $inizio })
  $scelto = $null
  foreach($f in $nuovi){ if($null -eq $scelto -or $f.LastWriteTime -gt $scelto.LastWriteTime){ $scelto = $f } }
  if($null -eq $scelto){
    foreach($f in $sovr){ if($null -eq $scelto -or $f.LastWriteTime -gt $scelto.LastWriteTime){ $scelto = $f } }
    if($null -ne $scelto){ $ris.Nota = "il referto ha SOVRASCRITTO un file dello stesso minuto (" + $scelto.Name + "): il contenuto e' di adesso" }
  }
  if($null -eq $scelto){ return $ris }
  if(($nuovi.Count + $sovr.Count) -gt 1){
    $ris.Nota = $ris.Nota + " [attenzione: " + ($nuovi.Count + $sovr.Count) + " referti freschi nella stessa cartella]"
  }
  $ris.File  = $scelto.FullName
  $ris.Stato = "OK"
  return $ris
}

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

function ByteCartella($path){
  if(-not (Test-Path -LiteralPath $path)){ return [int64]0 }
  $s = [int64]0
  try{
    foreach($f in (Get-ChildItem -LiteralPath $path -Recurse -File -ErrorAction SilentlyContinue)){ $s += $f.Length }
  }catch{ }
  return $s
}
function Virgoletta($a){
  $s = [string]$a
  if($s -match '\s'){ return ('"' + $s + '"') }
  return $s
}

#  IL BATTITO GUARDA LA CRESCITA DEI FILE, mai il tempo (checklist 30):
#  una corsa sana puo' stare zitta, ma non puo' smettere di far crescere
#  la cache. Serve solo allo scarico (P5).
function EseguiConBattito($exe,$argv,$logfile,$sorveglia,$timeoutMin,$fermoMin){
  $errfile = $logfile + ".err"
  Remove-Item -LiteralPath $logfile,$errfile -Force -ErrorAction SilentlyContinue
  $cmd = @($argv | ForEach-Object { Virgoletta $_ })
  $p = Start-Process -FilePath $exe -ArgumentList $cmd -NoNewWindow -PassThru `
                     -RedirectStandardOutput $logfile -RedirectStandardError $errfile
  $t0 = Get-Date
  $ultimoByte = -1
  $ultimaCrescita = Get-Date
  $esito = "OK"
  while($true){
    try{ $p.Refresh() }catch{ }
    if($p.HasExited){ break }
    Start-Sleep -Seconds 5
    $b = (ByteCartella $sorveglia)
    if(Test-Path -LiteralPath $logfile){ $b += (Get-Item -LiteralPath $logfile).Length }
    if($b -gt $ultimoByte){ $ultimoByte = $b; $ultimaCrescita = Get-Date }
    $fermoDa = (New-TimeSpan -Start $ultimaCrescita -End (Get-Date)).TotalMinutes
    $andata  = (New-TimeSpan -Start $t0 -End (Get-Date)).TotalMinutes
    if($andata -ge $timeoutMin){ $esito = "TIMEOUT dopo " + (N1 $andata) + " min"; break }
    if($fermoDa -ge $fermoMin){ $esito = "FERMO: nessun byte nuovo da " + (N1 $fermoDa) + " min"; break }
  }
  try{ $p.Refresh() }catch{ }
  if(-not $p.HasExited){
    Write-Host ("    !! " + $esito + " -- chiudo il processo.") -ForegroundColor Red
    try{ Stop-Process -Id $p.Id -Force -ErrorAction SilentlyContinue }catch{ }
    Start-Sleep -Seconds 2
    return @{ Rc = 98; Esito = $esito }
  }
  $rc = $p.ExitCode
  if($null -eq $rc){ $rc = 0 }
  if(Test-Path -LiteralPath $errfile){
    $e = Get-Content -LiteralPath $errfile -Raw -ErrorAction SilentlyContinue
    if($e -and $e.Trim() -ne ""){ Add-Content -LiteralPath $logfile -Value ("`r`n--- stderr ---`r`n" + $e) }
    Remove-Item -LiteralPath $errfile -Force -ErrorAction SilentlyContinue
  }
  return @{ Rc = [int]$rc; Esito = "uscito con " + $rc }
}

# ---------------------------------------------------------------------
#  UNO ZIP SI IDENTIFICA APRENDOLO, NON DAL NOME (checklist 83).
#  E' la stessa regola di histdata_m1.py (ingerisci_zip): il simbolo e
#  l'anno si leggono dal nome del CSV che sta DENTRO lo zip
#  (DAT_ASCII_GRXEUR_M1_2020.csv), cosi' uno zip rinominato dal browser
#  viene smistato lo stesso.
#  Torna una lista di righe: una per CSV trovato dentro lo zip.
# ---------------------------------------------------------------------
function DentroLoZip($file){
  $out = New-Object System.Collections.ArrayList
  if(-not $ZipApi){
    [void]$out.Add([pscustomobject]@{ Pair="?"; Anno=0; Mese=0; Stato="NON VERIFICATO"; Nota="ZIP API non caricata: si guarda solo il nome" })
    return $out
  }
  $arch = $null
  try{
    $arch = [System.IO.Compression.ZipFile]::OpenRead($file)
    foreach($e in $arch.Entries){
      if($e.Name -notmatch '(?i)\.csv$'){ continue }
      $m = [regex]::Match($e.Name.ToUpper(),'DAT_ASCII_([A-Z]{6})_M1_(\d{4})(\d{2})?')
      if($m.Success){
        $mese = 0
        if($m.Groups[3].Success){ $mese = [int]$m.Groups[3].Value }
        [void]$out.Add([pscustomobject]@{ Pair=$m.Groups[1].Value.ToLower(); Anno=[int]$m.Groups[2].Value; Mese=$mese; Stato="OK"; Nota=$e.Name })
      } else {
        $m2 = [regex]::Match($e.Name.ToUpper(),'([A-Z]{6})')
        $pp = "?"
        if($m2.Success){ $pp = $m2.Groups[1].Value.ToLower() }
        [void]$out.Add([pscustomobject]@{ Pair=$pp; Anno=0; Mese=0; Stato="ANNO NON LEGGIBILE"; Nota=$e.Name })
      }
    }
  }catch{
    [void]$out.Add([pscustomobject]@{ Pair="?"; Anno=0; Mese=0; Stato="ILLEGGIBILE"; Nota=(UnaRiga $_.Exception.Message) })
  }finally{ if($null -ne $arch){ try{ $arch.Dispose() }catch{ } } }
  return $out
}

# ---------------------------------------------------------------------
#  LA MISURA CHE LO STRUMENTO NON HA: LA MAPPA DELLE SESSIONI.
#  histdata_m1.py --diagnosi dice l'ORA DI APERTURA modale mese per mese
#  (misura_fuso) e i prezzi fuori banda, ma NON dice quali ore sono
#  coperte dentro la giornata e con quante barre -- che e' esattamente
#  la domanda Q2 (convenzione diversa o buchi di feed?).
#  Percio' questa parte si fa QUI, leggendo lo ZIP riga per riga, e
#  senza toccare il .py (che resta quello collaudato, al pin).
#
#  ATTENZIONE, ED E' DICHIARATO: questo conteggio NON e' identico a
#  quello del .py. Il .py scarta anche le righe con OHLC incoerenti
#  (high<low, ecc.); qui si contano tutte le righe con timestamp e
#  prezzi leggibili. E' un CENSIMENTO DI COPERTURA, non la stessa
#  selezione: i due totali possono differire di poche barre.
#
#  Formato della riga HistData grezza (dentro lo zip):
#      20200602 020000;12345.6;12350.0;12340.1;12349.9;0
#      0123456789...
#  cioe': AAAA MM GG spazio HH MM SS ; open ; high ; low ; close ; vol
# ---------------------------------------------------------------------
#  La griglia e' un array PIATTO, non a tre dimensioni: in PowerShell
#  5.1 gli array multidimensionali si creano e si incrementano in modi
#  che cambiano da versione a versione, e qui non c'e' modo di provarli
#  prima. Un int[] con l'indice calcolato a mano funziona ovunque.
#  indice = ((mese * 32) + giorno) * 24 + ora     (13*32*24 = 9984 celle)
function LeggiGriglia($files,$pair,$lo,$hi){
  $ris = [pscustomobject]@{
    Righe=0; NonRiconosciute=0; FuoriBanda=-1; Griglia=$null
    FuoriOra=$null; MinPrezzo=-1.0; MaxPrezzo=-1.0; Stato="NON LETTA" }
  if(-not $ZipApi){ $ris.Stato = "ZIP API non caricata"; return $ris }
  $grid = New-Object 'int[]' 9984
  $fuoriOra = New-Object 'int[]' 24
  $bandaOk = ($lo -gt 0 -and $hi -gt 0)
  $fuori = 0
  $pmin = [double]::MaxValue
  $pmax = [double]::MinValue
  $mese = 0; $giorno = 0; $ora = 0
  $vhi = 0.0; $vlo = 0.0
  foreach($file in $files){
    $arch = $null
    try{
      $arch = [System.IO.Compression.ZipFile]::OpenRead($file)
      foreach($e in $arch.Entries){
        if($e.Name -notmatch '(?i)\.csv$'){ continue }
        if($e.Name -notmatch ("(?i)" + [regex]::Escape($pair))){ continue }
        $st = $e.Open()
        $sr = New-Object System.IO.StreamReader($st)
        while($null -ne ($linea = $sr.ReadLine())){
          if($linea.Length -lt 20){ continue }
          if(-not ([int]::TryParse($linea.Substring(4,2),[ref]$mese))){ $ris.NonRiconosciute = $ris.NonRiconosciute + 1; continue }
          if(-not ([int]::TryParse($linea.Substring(6,2),[ref]$giorno))){ $ris.NonRiconosciute = $ris.NonRiconosciute + 1; continue }
          if(-not ([int]::TryParse($linea.Substring(9,2),[ref]$ora))){ $ris.NonRiconosciute = $ris.NonRiconosciute + 1; continue }
          if($mese -lt 1 -or $mese -gt 12 -or $giorno -lt 1 -or $giorno -gt 31 -or $ora -lt 0 -or $ora -gt 23){
            $ris.NonRiconosciute = $ris.NonRiconosciute + 1; continue
          }
          #  il separatore e' ';' su tutti i file visti finora, ma
          #  leggi_righe_histdata() del .py accetta anche la virgola:
          #  qui si fa lo stesso, altrimenti un file a virgole darebbe
          #  "zero barre" invece di dire che non lo sa leggere.
          $campi = $linea.Split(';')
          if($campi.Count -lt 5){ $campi = $linea.Split(',') }
          if($campi.Count -lt 5){ $ris.NonRiconosciute = $ris.NonRiconosciute + 1; continue }
          if($bandaOk){
            if(-not ([double]::TryParse($campi[2],[Globalization.NumberStyles]::Float,$INV,[ref]$vhi))){ $ris.NonRiconosciute = $ris.NonRiconosciute + 1; continue }
            if(-not ([double]::TryParse($campi[3],[Globalization.NumberStyles]::Float,$INV,[ref]$vlo))){ $ris.NonRiconosciute = $ris.NonRiconosciute + 1; continue }
            if($vlo -lt $pmin){ $pmin = $vlo }
            if($vhi -gt $pmax){ $pmax = $vhi }
            if($vlo -lt $lo -or $vhi -gt $hi){ $fuori++; $fuoriOra[$ora] = $fuoriOra[$ora] + 1 }
          }
          $idx = ((($mese * 32) + $giorno) * 24) + $ora
          $grid[$idx] = $grid[$idx] + 1
          $ris.Righe = $ris.Righe + 1
        }
        $sr.Close()
        $st.Close()
      }
    }catch{
      $ris.Stato = "ERRORE leggendo " + (Split-Path -Leaf $file) + ": " + (UnaRiga $_.Exception.Message)
      if($null -ne $arch){ try{ $arch.Dispose() }catch{ } }
      return $ris
    }finally{ if($null -ne $arch){ try{ $arch.Dispose() }catch{ } } }
  }
  $ris.Griglia  = $grid
  $ris.FuoriOra = $fuoriOra
  if($bandaOk){
    $ris.FuoriBanda = $fuori
    if($ris.Righe -gt 0){ $ris.MinPrezzo = $pmin; $ris.MaxPrezzo = $pmax }
  }
  $ris.Stato = "OK"
  return $ris
}

#  Da una griglia (mese,giorno,ora) alle metriche di sessione.
#   - un'ora e' COPERTA se ha almeno $soglia barre in almeno META' dei
#     giorni con barre;
#   - la DENSITA' e' la media di barre per ora coperta: 60 = giornata
#     piena, molto meno = buchi.
#
#  LA FUNZIONE SI CHIAMA DUE VOLTE, ed e' una correzione trovata
#  PROVANDO (banco del 26/08, anno finto con 25 barre l'ora):
#  con la sola soglia "ora PIENA" (30 barre) un anno tutto a buchi non
#  ha NESSUNA ora coperta -> finestra n/d e densita' n/d, cioe' lo
#  strumento risponde "non lo so" proprio nel caso che la domanda Q2
#  cerca. Percio':
#    soglia 30 -> ORE PIENE   (quante ore sono vere ore di mercato)
#    soglia 1  -> ORE TOCCATE (dove il feed mette qualcosa: e' la
#                 FINESTRA di sessione, e c'e' sempre se ci sono barre)
#  La densita' si misura sulle ore TOCCATE: cosi' esiste sempre, e
#  25 barre/ora si legge come 25, non come "non misurato".
function MetricheDaGriglia($grid,$mDa,$mA,$soglia){
  $ris = [pscustomobject]@{ Giorni=0; Barre=0; Prima=-1; Ultima=-1; OreCoperte=0; Densita=-1.0; Coperte=$null }
  if($null -eq $grid){ return $ris }
  $giorniPerOra = New-Object 'int[]' 24
  $barrePerOra  = New-Object 'int[]' 24
  #  le variabili di ciclo NON si chiamano come quelle di fuori: qui
  #  siamo in una funzione (che ha il suo scope), ma il difetto 79 e'
  #  costato una corsa e la regola si applica anche dove non morde.
  for($mm = $mDa; $mm -le $mA; $mm++){
    for($gg = 1; $gg -le 31; $gg++){
      $base = ((($mm * 32) + $gg) * 24)
      $tot = 0
      for($hh = 0; $hh -le 23; $hh++){ $tot += $grid[$base + $hh] }
      if($tot -le 0){ continue }
      $ris.Giorni = $ris.Giorni + 1
      $ris.Barre += $tot
      for($hh = 0; $hh -le 23; $hh++){
        $n = $grid[$base + $hh]
        if($n -le 0){ continue }
        $barrePerOra[$hh] = $barrePerOra[$hh] + $n
        if($n -ge $soglia){ $giorniPerOra[$hh] = $giorniPerOra[$hh] + 1 }
      }
    }
  }
  if($ris.Giorni -eq 0){ return $ris }
  $soglia = $ris.Giorni / 2.0
  $coperte = New-Object System.Collections.ArrayList
  $barreCoperte = 0
  for($hh = 0; $hh -le 23; $hh++){
    if($giorniPerOra[$hh] -ge $soglia){
      [void]$coperte.Add($hh)
      $barreCoperte += $barrePerOra[$hh]
      if($ris.Prima -lt 0){ $ris.Prima = $hh }
      $ris.Ultima = $hh
    }
  }
  $ris.OreCoperte = $coperte.Count
  $ris.Coperte = $coperte
  if($ris.OreCoperte -gt 0){
    $ris.Densita = [double]$barreCoperte / ([double]$ris.Giorni * [double]$ris.OreCoperte)
  }
  return $ris
}

# =====================================================================
#  P0. INTESTAZIONE, CARTELLE, RAM
# =====================================================================
Write-Host ""
Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host " DIAGNOSI DEL DAX HISTDATA (grxeur) -- decisione D-F, gia' firmata" -ForegroundColor Cyan
Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host (" pin        : " + $Pin)
Write-Host (" modo       : " + $(if($SoloControllo){ "GIRO A VUOTO (censimento, nessuna diagnosi)" }else{ "CORSA VERA" }))
Write-Host (" rete       : " + $(if($EstendiIndietro){ "SI -- -EstendiIndietro scarica gli anni mancanti (canarino + soglia D-E)" }else{ "NO -- solo strumento e criteri al pin; la diagnosi e' OFFLINE" }))
Write-Host (" cache HD   : " + $CartellaHD)
Write-Host (" lavoro     : " + $Cartella)
Write-Host (" raccolta   : " + $Sosta)
Write-Host ""
Write-Host " NON importa niente in MT5, NON crea simboli _EXT, NON autorizza" -ForegroundColor Yellow
Write-Host " l'uso di nessun dato: il cancello ZERO resta chiuso. Qui si" -ForegroundColor Yellow
Write-Host " produce un REFERTO." -ForegroundColor Yellow
Write-Host " MT5 puo' restare aperto (non si scrive in MetaQuotes\Terminal)." -ForegroundColor Yellow

Remove-Item -LiteralPath $Sosta  -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -LiteralPath $ZipFin -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path $Sosta,$SostaLog,$SostaAnni,$Cartella | Out-Null

#  La raccolta AUTOMATICA dello strumento (Desktop\histdata_m1 +
#  Desktop\histdata_m1.zip) si toglie di mezzo PRIMA: histdata_m1.py la
#  rifa' a ogni chiamata e la sua stampa dice "ZIP PRONTO DA MANDARE".
#  Uno zip vecchio li' sopra e' il referto stantio pronto a partire
#  (checklist 23). Lo zip buono e' UNO SOLO ed e' il nostro.
$RaccoltaStrumento    = Join-Path $Desktop "histdata_m1"
$RaccoltaStrumentoZip = Join-Path $Desktop "histdata_m1.zip"
Remove-Item -LiteralPath $RaccoltaStrumento    -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -LiteralPath $RaccoltaStrumentoZip -Force -ErrorAction SilentlyContinue

Titolo "P0 - RAM E LETTURA DEGLI ZIP"
try{
  $os = Get-CimInstance -ClassName Win32_OperatingSystem -ErrorAction Stop
  $RamLibera = [double]$os.FreePhysicalMemory / 1024.0
  if($RamLibera -ge $MinRamMB){ $RamStato = "OK" } else { $RamStato = "SOTTO SOGLIA" }
  Dico ("RAM libera: " + (N2 $RamLibera) + " MB   (serve almeno " + $MinRamMB + " MB: un anno = ~330k barre = ~230 MB, x3 di margine)") $(if($RamStato -eq "OK"){ "Green" }else{ "Red" })
}catch{
  $RamStato = "NON MISURATA"
  [void]$Note.Add("P0: RAM libera NON MISURATA (" + (UnaRiga $_.Exception.Message) + "): la diagnosi parte lo stesso, e se esce un MemoryError e' questo.")
  Dico "RAM libera: NON MISURATA (si prosegue e si dichiara)" "Yellow"
}
if($RamStato -eq "SOTTO SOGLIA"){
  Write-Host ""
  Write-Host ("!!! RAM LIBERA " + (N2 $RamLibera) + " MB, sotto -MinRamMB " + $MinRamMB + ".") -ForegroundColor Red
  Write-Host "    La diagnosi carica un anno di barre per volta: cosi' morirebbe di" -ForegroundColor Yellow
  Write-Host "    MemoryError DOPO la parte lunga. Chiudi qualcosa e rilancia." -ForegroundColor Yellow
  exit 2
}
try{
  Add-Type -AssemblyName System.IO.Compression.FileSystem -ErrorAction Stop
  $ZipApi = $true
  Dico "lettura degli ZIP: OK (System.IO.Compression.FileSystem caricata)" "Green"
}catch{
  $ZipApi = $false
  [void]$Problemi.Add("P0: System.IO.Compression.FileSystem NON caricata (" + (UnaRiga $_.Exception.Message) + "): gli zip non si aprono da PowerShell. Il censimento guardera' solo i NOMI e la MAPPA DELLE SESSIONI non si potra' fare. La diagnosi di python parte lo stesso.")
  Dico "lettura degli ZIP: NON DISPONIBILE (la mappa delle sessioni salta)" "Red"
}

# =====================================================================
#  P1. PYTHON VERO (checklist 17: l'interprete si MISURA)
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
#  P2. LO STRUMENTO AL PIN + AUTOTEST + LA BANDA LETTA DAL SORGENTE
#      (checklist 6 e 8). La banda di prezzo NON si riscrive qui: si
#      LEGGE dalla tabella STRUMENTI di histdata_m1.py, che e' l'unica
#      fonte di verita'. Due copie dello stesso numero divergono.
# =====================================================================
Titolo "P2 - histdata_m1.py AL PIN + AUTOTEST + BANDA"
Remove-Item -LiteralPath $PyFile -Force -ErrorAction SilentlyContinue
try{
  Invoke-WebRequest -Uri ($RawPin + "/backtest_pipeline/dukascopy/histdata_m1.py") -OutFile $PyFile -UseBasicParsing -ErrorAction Stop
}catch{
  Write-Host ("!!! DOWNLOAD DELLO STRUMENTO FALLITO: " + $_.Exception.Message) -ForegroundColor Red
  Write-Host "    (pin sbagliato? rete? proxy?) Non si va oltre: la copia vecchia NON si usa." -ForegroundColor Yellow
  exit 2
}
if(-not (Select-String -LiteralPath $PyFile -SimpleMatch -Pattern 'HD-M1-v4' -Quiet)){
  Write-Host "!!! STRUMENTO SBAGLIATO: manca il marcatore HD-M1-v4." -ForegroundColor Red
  exit 2
}
Dico "histdata_m1.py scaricato al pin, marcatore HD-M1-v4 verificato." "Green"

$logAuto  = Join-Path $SostaLog "autotest.log"
$rcAuto   = EseguiPython @("-u",$PyFile,"--autotest") $logAuto
$rigaAuto = @(Select-String -LiteralPath $logAuto -Pattern 'AUTOTEST: ' | ForEach-Object { $_.Line })
if($rcAuto -ne 0){
  Write-Host ("!!! AUTOTEST FALLITO (rc " + $rcAuto + "): NON si diagnostica niente. Guarda " + $logAuto) -ForegroundColor Red
  if($rigaAuto.Count -gt 0){ Write-Host ("    " + $rigaAuto[0]) -ForegroundColor Yellow }
  exit 2
}
if($rigaAuto.Count -gt 0){ Dico ("autotest: " + $rigaAuto[0].Trim()) "Green" } else { Dico "autotest: rc 0" "Green" }

foreach($linea in @(Get-Content -LiteralPath $PyFile -ErrorAction SilentlyContinue)){
  $mB = [regex]::Match($linea,'"grxeur"\s*:\s*\(\s*"D30EUR"\s*,\s*([0-9.]+)\s*,\s*([0-9.]+)\s*,')
  if($mB.Success){
    $BandaLo = [double]::Parse($mB.Groups[1].Value,[Globalization.NumberStyles]::Float,$INV)
    $BandaHi = [double]::Parse($mB.Groups[2].Value,[Globalization.NumberStyles]::Float,$INV)
    $BandaFonte = "tabella STRUMENTI di histdata_m1.py al pin"
    break
  }
}
if($BandaLo -gt 0){
  Dico ("banda di prezzo attesa per il DAX: " + (N1 $BandaLo) + " - " + (N1 $BandaHi) + "  (letta dal sorgente)") "Green"
} else {
  [void]$Problemi.Add("P2: la banda di prezzo di grxeur NON e' stata letta dal sorgente di histdata_m1.py (tabella cambiata?). La mappa oraria non potra' contare le barre fuori banda: NON invento un numero. La diagnosi di python la calcola comunque per conto suo.")
  Dico "banda di prezzo: NON LETTA dal sorgente (si dichiara, non si inventa)" "Yellow"
}

# =====================================================================
#  P3. LA DECISIONE CHE AUTORIZZA QUESTA CORSA (D-F), LETTA AL PIN
#      Non si aggiunge nessun lucchetto nuovo: D-F e' gia' firmata dal
#      25/08. Qui si VERIFICA che lo sia ancora, e si scrivono le frasi
#      del referto sul VALORE LETTO, mai su un ramo solo (checklist 82).
# =====================================================================
Titolo "P3 - LA DECISIONE D-F (STORICO_INDICI_CRITERI.md, al pin)"
try{
  Invoke-WebRequest -Uri ($RawPin + "/backtest_pipeline/risultati_archivio/STORICO_INDICI_CRITERI.md") -OutFile $FileCrit -UseBasicParsing -ErrorAction Stop
  if(-not (Select-String -LiteralPath $FileCrit -SimpleMatch -Pattern '@DECISIONE' -Quiet)){
    throw "il file dei criteri non contiene nessuna riga di decisione leggibile"
  }
  [void](CopiaVerificata $FileCrit (Join-Path $Sosta "STORICO_INDICI_CRITERI.md"))
  [void]$Attesi.Add("STORICO_INDICI_CRITERI.md")
}catch{
  Write-Host ("!!! CRITERI NON LETTI: " + $_.Exception.Message) -ForegroundColor Red
  Write-Host "    Senza il file firmato non si sa se questa diagnosi e' autorizzata:" -ForegroundColor Yellow
  Write-Host "    non parte. (E' lo stesso file che legge RIGA_STORICO_INDICI.)" -ForegroundColor Yellow
  exit 2
}

$Decisioni = New-Object System.Collections.ArrayList
foreach($linea in (Get-Content -LiteralPath $FileCrit)){
  $m = [regex]::Match($linea,'^@DECISIONE\s+(\S+)\s+CHIAVE=(\S+)\s+VALORE=(\S+)\s+STATO=(\S+)\s*$')
  if($m.Success){
    [void]$Decisioni.Add([pscustomobject]@{ Id=$m.Groups[1].Value; Chiave=$m.Groups[2].Value
                                            Valore=$m.Groups[3].Value; Stato=$m.Groups[4].Value.ToUpper() })
  }
}
Write-Host ("   {0,-5} {1,-22} {2,-24} {3}" -f "ID","CHIAVE","VALORE","STATO") -ForegroundColor Gray
foreach($d in $Decisioni){
  $col = if($d.Stato -eq "FIRMATO"){ "Green" } else { "Yellow" }
  Write-Host ("   {0,-5} {1,-22} {2,-24} {3}" -f $d.Id,$d.Chiave,$d.Valore,$d.Stato) -ForegroundColor $col
  if($d.Id -eq "D-F"){ $DecStato = $d.Stato; $DecValore = $d.Valore }
  if($d.Id -eq "D-E"){ [void][double]::TryParse($d.Valore,[Globalization.NumberStyles]::Float,$INV,[ref]$SogliaOre) }
}
#  TRE rami, non due: firmata e giusta / firmata ma con un'altra strada /
#  non firmata. Uno switch che si autodescrive sempre uguale mente meta'
#  delle volte (checklist 82 pezzo 3).
if($DecStato -eq "FIRMATO" -and $DecValore -eq "diagnosi_prima"){
  $PuoDiagnosticare = $true
  $DecFrase = "D-F FIRMATA con VALORE=diagnosi_prima (firma di Claudio del 25/08, letta al pin): questa diagnosi E' l'azione autorizzata."
  Dico "D-F firmata (diagnosi_prima): la diagnosi e' autorizzata." "Green"
} elseif($DecStato -eq "FIRMATO"){
  $PuoDiagnosticare = $false
  $DecFrase = "D-F e' FIRMATA ma con VALORE=" + $DecValore + ", che NON e' 'diagnosi_prima': la strada del DAX e' un'altra e questa riga non e' quella giusta. Non ho diagnosticato niente."
  [void]$Problemi.Add("P3: " + $DecFrase)
  Dico ("D-F firmata ma VALORE=" + $DecValore + ": NON e' la strada di questa riga.") "Red"
} else {
  $PuoDiagnosticare = $false
  $DecFrase = "D-F risulta " + $DecStato + " nel file al pin: la diagnosi NON parte. Si firma nel file dei criteri, si pusha, si rilancia col pin nuovo."
  [void]$Problemi.Add("P3: " + $DecFrase)
  Dico ("D-F " + $DecStato + ": la diagnosi non parte (si firma nei criteri, non dalla console).") "Red"
}

# =====================================================================
#  P4. CENSIMENTO: OGNI ZIP SI APRE (checklist 83)
#      "I dati ci sono gia'" e' un'ASSUNZIONE finche' non si apre il
#      file. Qui ogni anno esce con UNO di tre stati.
# =====================================================================
Titolo "P4 - CENSIMENTO DEGLI ZIP grxeur (tre stati per anno)"
[void]$RigheCenso.Add("CENSIMENTO DEGLI ZIP -- diagnosi del DAX HistData (grxeur)")
[void]$RigheCenso.Add("data: " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   <-- QUESTA DATA DEVE ESSERE DI ADESSO")
[void]$RigheCenso.Add("macchina: " + $env:COMPUTERNAME + "   utente: " + $env:USERNAME)
[void]$RigheCenso.Add("pin: " + $Pin)
[void]$RigheCenso.Add("")
[void]$RigheCenso.Add("Regola: il simbolo e l'anno si leggono dal nome del CSV DENTRO lo zip")
[void]$RigheCenso.Add("(DAT_ASCII_GRXEUR_M1_2020.csv), come fa histdata_m1.py: cosi' uno zip")
[void]$RigheCenso.Add("rinominato dal browser viene riconosciuto lo stesso.")
[void]$RigheCenso.Add("PERIMETRO, dichiarato: si guardano i file .zip che stanno NELLA cartella,")
[void]$RigheCenso.Add("non nelle sue sottocartelle. Se degli zip del DAX fossero finiti in una")
[void]$RigheCenso.Add("sottocartella di tranche, questa corsa NON li vede e li conta MANCANTI.")
[void]$RigheCenso.Add("")

$Trovati  = New-Object System.Collections.ArrayList   # righe: Pair, Anno, Mese, File
$Cartelle = @($CartellaHD, $CartellaLunga)
foreach($cart in $Cartelle){
  [void]$RigheCenso.Add("--- cartella: " + $cart + " ---")
  if(-not (Test-Path -LiteralPath $cart)){
    [void]$RigheCenso.Add("    NON ESISTE.")
    continue
  }
  #  il CSV gia' prodotto si DICHIARA ma NON si usa come fonte, e il
  #  motivo va scritto: carica_barre_offline() del .py PREFERISCE il CSV
  #  agli ZIP, e quel CSV contiene TUTTI gli anni insieme. Con il CSV in
  #  cartella, "--diagnosi di un anno" leggerebbe in silenzio l'intera
  #  serie e ogni riga per anno sarebbe la stessa (checklist 83: due
  #  fonti con lo stesso nome, e chi legge non se ne accorge).
  foreach($nomeCsv in @(($BcmDax + "_M1.csv"), ($BcmCtrl + "_M1.csv"))){
    $csv = Join-Path $cart $nomeCsv
    if(Test-Path -LiteralPath $csv){
      $it = Get-Item -LiteralPath $csv
      $primaRiga = ""
      try{ $primaRiga = @(Get-Content -LiteralPath $csv -TotalCount 2 -ErrorAction Stop)[-1] }catch{ $primaRiga = "(non letta)" }
      [void]$RigheCenso.Add("    CSV " + $nomeCsv + ": " + [Math]::Round($it.Length/1MB,1) + " MB, scritto il " +
                            $it.LastWriteTime.ToString("yyyy-MM-dd HH:mm",$INV))
      [void]$RigheCenso.Add("        prima riga di dati: " + $primaRiga)
      [void]$RigheCenso.Add("        -> DICHIARATO, ma NON e' la fonte di questa diagnosi: contiene tutti gli")
      [void]$RigheCenso.Add("           anni insieme e lo strumento lo preferirebbe agli ZIP. Qui si va")
      [void]$RigheCenso.Add("           ANNO PER ANNO, copiando gli zip in cartelle usa-e-getta.")
    }
  }
  $zips = @(Get-ChildItem -LiteralPath $cart -Filter "*.zip" -File -ErrorAction SilentlyContinue)
  [void]$RigheCenso.Add("    zip presenti: " + $zips.Count)
  $rotti = 0
  foreach($z in $zips){
    $dentro = @(DentroLoZip $z.FullName)
    foreach($d in $dentro){
      if($d.Stato -eq "ILLEGGIBILE"){
        $rotti++
        [void]$RigheCenso.Add("    ROTTO  " + $z.Name + "   " + $d.Nota)
        [void]$Problemi.Add("P4: " + $z.Name + " in " + $cart + " NON SI APRE (" + $d.Nota + "). Quell'anno risulta MANCANTE. Nota: histdata_m1.py cancella gli zip illeggibili che ingerisce -- ma qui NON gli si fa mai vedere la cache, quindi il file resta dov'e'.")
        continue
      }
      if($d.Pair -ne $PairDax -and $d.Pair -ne $PairCtrl){ continue }
      if($d.Anno -le 0){
        [void]$RigheCenso.Add("    ?      " + $z.Name + "   " + $d.Pair + ", anno non leggibile dal nome interno (" + $d.Nota + ")")
        [void]$Note.Add("P4: " + $z.Name + ": dentro c'e' " + $d.Pair + " ma l'ANNO non si legge dal nome del CSV interno: quello zip non entra in nessun anno.")
        continue
      }
      #  LO STESSO PEZZO IN DUE CARTELLE NON SI CONTA DUE VOLTE.
      #  histdata_m1.py deduplica le barre da solo, quindi il risultato
      #  non cambierebbe -- ma il conteggio degli zip nel referto si',
      #  e un "14 zip" dove ce ne sono 7 e' un numero che mente.
      $gia = $null
      foreach($t in $Trovati){ if($t.Pair -eq $d.Pair -and $t.Anno -eq $d.Anno -and $t.Mese -eq $d.Mese){ $gia = $t } }
      if($null -ne $gia){
        [void]$Note.Add("P4: " + $d.Pair + " " + $d.Anno + $(if($d.Mese -gt 0){ "-" + ("{0:00}" -f $d.Mese) }else{ "" }) +
                        ": c'e' anche in " + $z.FullName + ", ma si usa quello gia' trovato (" + $gia.File + ").")
        continue
      }
      [void]$Trovati.Add([pscustomobject]@{ Pair=$d.Pair; Anno=$d.Anno; Mese=$d.Mese; File=$z.FullName
                                            Scritto=$z.LastWriteTime.ToString("yyyy-MM-dd HH:mm",$INV); MB=[Math]::Round($z.Length/1MB,2) })
    }
  }
  [void]$RigheCenso.Add("    di cui ILLEGGIBILI: " + $rotti)
  [void]$RigheCenso.Add("")
}

#  gli anni si elencano ORDINATI ALLA FONTE: un elenco che esce
#  dall'iterazione di una raccolta non ha ordine garantito (checklist
#  70-bis). Qui la chiave e' unica (l'anno), quindi Sort-Object non ha
#  pari da riordinare (checklist 81).
$AnniDax  = @(@($Trovati | Where-Object { $_.Pair -eq $PairDax  } | ForEach-Object { $_.Anno }) | Sort-Object -Unique)
$AnniNas  = @(@($Trovati | Where-Object { $_.Pair -eq $PairCtrl } | ForEach-Object { $_.Anno }) | Sort-Object -Unique)

$AnnoDaEff = $AnnoDa
$AnnoAEff  = $AnnoA
if($AnnoAEff -le 0){ $AnnoAEff = (Get-Date).Year }
if($AnnoDaEff -le 0){
  if($EstendiIndietro){ $AnnoDaEff = 2010 }
  elseif($AnniDax.Count -gt 0){ $AnnoDaEff = [int](@($AnniDax)[0]) }
  else{ $AnnoDaEff = 2019 }
}
if($AnnoDaEff -lt 2010){ $AnnoDaEff = 2010 }   # HistData pubblica gli indici da 2010-11
#  un intervallo alla rovescia in PowerShell NON e' vuoto: conta
#  all'INDIETRO. Senza questa guardia -AnnoDa 2024 -AnnoA 2020 avrebbe
#  prodotto una lista di anni discendente e un referto plausibile.
if($AnnoAEff -lt $AnnoDaEff){
  [void]$Problemi.Add("P4: finestra chiesta alla rovescia (" + $AnnoDaEff + " -> " + $AnnoAEff + "): la riduco a un anno solo (" + $AnnoDaEff + ").")
  $AnnoAEff = $AnnoDaEff
}

$AnniChiesti = @($AnnoDaEff..$AnnoAEff)
$AnniPronti  = @($AnniChiesti | Where-Object { $AnniDax -contains $_ })
$AnniMancano = @($AnniChiesti | Where-Object { $AnniDax -notcontains $_ })

[void]$RigheCenso.Add("--- GLI ANNI DEL DAX (grxeur) ---")
[void]$RigheCenso.Add("finestra chiesta: " + $AnnoDaEff + " -> " + $AnnoAEff)
foreach($annoIt in $AnniChiesti){
  $pezzi = @($Trovati | Where-Object { $_.Pair -eq $PairDax -and $_.Anno -eq $annoIt })
  if($pezzi.Count -gt 0){
    $mb = 0.0
    foreach($p in $pezzi){ $mb += $p.MB }
    [void]$RigheCenso.Add(("    {0}  PRONTO   {1} zip, {2} MB, il piu' recente scritto il {3}" -f `
      $annoIt, $pezzi.Count, (N2 $mb), (@($pezzi | ForEach-Object { $_.Scritto } | Sort-Object -Unique | Select-Object -Last 1))))
  } else {
    [void]$RigheCenso.Add(("    {0}  MANCANTE (nessuno zip grxeur in cache)" -f $annoIt))
  }
}
[void]$RigheCenso.Add("")
[void]$RigheCenso.Add("controllo positivo nsxusd: anni in cache " + $(if($AnniNas.Count -gt 0){ ($AnniNas -join ", ") }else{ "NESSUNO" }))
Set-Content -LiteralPath $Censo -Encoding ASCII -Value $RigheCenso
[void]$Attesi.Add("CENSIMENTO_ZIP_DAX.txt")
[void]$Attesi.Add("REFERTO_DIAGNOSI_DAX.txt")

Dico ("anni grxeur PRONTI  : " + $(if($AnniPronti.Count -gt 0){ ($AnniPronti -join ", ") }else{ "NESSUNO" })) $(if($AnniPronti.Count -gt 0){ "Green" }else{ "Red" })
Dico ("anni grxeur MANCANTI: " + $(if($AnniMancano.Count -gt 0){ ($AnniMancano -join ", ") }else{ "nessuno" })) $(if($AnniMancano.Count -gt 0){ "Yellow" }else{ "Green" })
if($AnniMancano.Count -gt 0 -and -not $EstendiIndietro){
  [void]$Note.Add("P4: " + $AnniMancano.Count + " anni della finestra non sono in cache (" + ($AnniMancano -join ", ") + ") e -EstendiIndietro NON e' stato chiesto: NON sono stati scaricati e NON sono stati diagnosticati. Dichiarato, non taciuto.")
}

if($SoloControllo){
  Write-Host ""
  Write-Host "GIRO A VUOTO: qui la corsa vera comincerebbe a diagnosticare. Mi fermo." -ForegroundColor Cyan
  Write-Host ("Censimento scritto in: " + $Censo) -ForegroundColor Cyan
  foreach($prob in $Problemi){ Write-Host ("   RILIEVO: " + $prob) -ForegroundColor Yellow }
  foreach($nota in $Note){ Write-Host ("   nota: " + $nota) -ForegroundColor DarkGray }
  if($Problemi.Count -gt 0 -or $AnniPronti.Count -eq 0){ exit 1 }
  exit 0
}

if(-not $PuoDiagnosticare){
  Write-Host ""
  Write-Host "!!! LA DIAGNOSI NON PARTE: vedi la riga D-F qui sopra." -ForegroundColor Red
  Write-Host "    Il censimento e' stato fatto lo stesso ed e' nella raccolta." -ForegroundColor Yellow
}

# =====================================================================
#  P5. SCARICO DEGLI ANNI MANCANTI -- solo con -EstendiIndietro.
#      E' uno scarico che serve alla DIAGNOSI (gli anni scaricati
#      vengono diagnosticati in questa stessa corsa), non un import:
#      D-F chiede la diagnosi prima dell'import, e nessun import
#      avviene qui.
# =====================================================================
if($PuoDiagnosticare -and $EstendiIndietro -and $AnniMancano.Count -gt 0){
  Titolo "P5 - CANARINO DI RITMO E SCARICO DEGLI ANNI MANCANTI"
  Write-Host ("   soglia canarino: " + (N1 $SogliaOre) + " ore (D-E, firmata)") -ForegroundColor White
  $logCan = Join-Path $SostaLog "canarino.log"
  $t0 = Get-Date
  $argv = @("-u",$PyFile,"--esplora","--simboli",$PairDax,"--da",("" + $AnnoDaEff),"--a",("" + $AnnoAEff),"--cartella",$CartellaHD)
  if($PausaMs -gt 0){ $argv += @("--pausa-ms",("" + $PausaMs)) }
  $rcCan = EseguiPython $argv $logCan
  $sec = (New-TimeSpan -Start $t0 -End (Get-Date)).TotalSeconds
  #  l'esplorazione fa 1 richiesta per anno, lo scarico ne fa 1 per anno
  #  piu' il file vero da trasferire: x6 di margine, DICHIARATO.
  $Proiezione = ($sec * 6.0) / 3600.0
  if($rcCan -ne 0){
    $Canarino = "ROSSO (esplorazione uscita con " + $rcCan + ")"
    [void]$Problemi.Add("P5 CANARINO ROSSO: --esplora e' uscito con " + $rcCan + " (canale HistData chiuso da questo PC?). NIENTE SCARICO: gli anni gia' in cache si diagnosticano lo stesso. Guarda log\canarino.log")
  } elseif($Proiezione -gt $SogliaOre){
    $Canarino = "ROSSO (" + (N1 $Proiezione) + " ore > " + (N1 $SogliaOre) + ")"
    [void]$Problemi.Add("P5 CANARINO ROSSO: lo scarico proietta " + (N1 $Proiezione) + " ore, sopra la soglia FIRMATA di " + (N1 $SogliaOre) + ". Non si scarica niente.")
  } else {
    $Canarino = "VERDE (" + (N1 $Proiezione) + " ore <= " + (N1 $SogliaOre) + ")"
  }
  Dico ("canarino: " + $Canarino) $(if($Canarino -like "VERDE*"){ "Green" }else{ "Red" })

  if($Canarino -like "VERDE*"){
    foreach($annoIt in $AnniMancano){
      if((Trascorse) -ge $OreMax){
        [void]$Problemi.Add("P5: " + $annoIt + " NON SCARICATO (tetto -OreMax " + (N1 $OreMax) + " h). Rilancia la stessa riga: la cache riprende da dove era.")
        break
      }
      $logAnno = Join-Path $SostaLog ("scarico_" + $annoIt + ".log")
      $argv = @("-u",$PyFile,"--scarica","--simboli",$PairDax,"--da",("" + $annoIt),"--a",("" + $annoIt),"--cartella",$CartellaHD)
      if($PausaMs -gt 0){ $argv += @("--pausa-ms",("" + $PausaMs)) }
      $r = EseguiConBattito $Python $argv $logAnno $CartellaHD 30 $FermoMinuti
      #  IL GATE STA SULL'ARTEFATTO, non sul codice d'uscita: si guarda
      #  se in cartella e' comparso uno zip di quell'anno, aprendolo.
      $nuovi = @(Get-ChildItem -LiteralPath $CartellaHD -Filter ("DAT_ASCII_" + $PairDax.ToUpper() + "_M1_" + $annoIt + "*.zip") -File -ErrorAction SilentlyContinue)
      $buoni = 0
      foreach($z in $nuovi){
        foreach($d in @(DentroLoZip $z.FullName)){
          if($d.Pair -eq $PairDax -and $d.Anno -eq $annoIt){
            $buoni++
            [void]$Trovati.Add([pscustomobject]@{ Pair=$d.Pair; Anno=$d.Anno; Mese=$d.Mese; File=$z.FullName
                                                  Scritto=$z.LastWriteTime.ToString("yyyy-MM-dd HH:mm",$INV); MB=[Math]::Round($z.Length/1MB,2) })
          }
        }
      }
      if($buoni -gt 0){
        Dico ("   " + $annoIt + ": " + $buoni + " zip in cache (rc " + $r.Rc + ")") "Green"
      } else {
        [void]$Problemi.Add("P5: " + $annoIt + ": nessuno zip grxeur apribile dopo lo scarico (rc " + $r.Rc + ", " + $r.Esito + "). Puo' essere che HistData non pubblichi quell'anno: guarda log\scarico_" + $annoIt + ".log, riga 'assente'.")
        Dico ("   " + $annoIt + ": NIENTE ARTEFATTO (rc " + $r.Rc + ")") "Yellow"
      }
    }
    $AnniDax    = @(@($Trovati | Where-Object { $_.Pair -eq $PairDax } | ForEach-Object { $_.Anno }) | Sort-Object -Unique)
    $AnniPronti = @($AnniChiesti | Where-Object { $AnniDax -contains $_ })
  }
} elseif($EstendiIndietro) {
  #  il messaggio dice il motivo VERO, non uno dei due a caso: senza
  #  questa distinzione "nessun anno mancante" finirebbe nel referto
  #  anche quando lo scarico non e' partito perche' D-F non autorizza.
  if(-not $PuoDiagnosticare){
    $Canarino = "NON MISURATO (la decisione D-F non autorizza questa corsa: niente scarico)"
  } else {
    $Canarino = "NON MISURATO (nessun anno mancante da scaricare)"
  }
}

# =====================================================================
#  P6 + P7. DIAGNOSI ANNO PER ANNO E MAPPA DELLE SESSIONI.
#  Si fanno nello stesso giro perche' guardano lo stesso anno: prima
#  parla lo strumento (--diagnosi), poi la mappa oraria che lo strumento
#  non ha.
# =====================================================================
if($PuoDiagnosticare -and $AnniPronti.Count -gt 0){
  Titolo ("P6+P7 - DIAGNOSI E MAPPA, ANNO PER ANNO (" + $AnniPronti.Count + " anni)")
  [void]$RigheMappa.Add("MAPPA DELLE SESSIONI -- diagnosi del DAX HistData (grxeur)")
  [void]$RigheMappa.Add("data: " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   <-- QUESTA DATA DEVE ESSERE DI ADESSO")
  [void]$RigheMappa.Add("")
  [void]$RigheMappa.Add("Due misure, non una (e il perche' e' scritto nel driver):")
  [void]$RigheMappa.Add("  ORE TOCCATE = ore con almeno 1 barra in almeno META' dei giorni del")
  [void]$RigheMappa.Add("    periodo. Sono la FINESTRA di sessione, e ci sono sempre se c'e' un dato.")
  [void]$RigheMappa.Add("  ORE PIENE   = ore con almeno " + $MinBarrePerOra + " barre in almeno META' dei giorni")
  [void]$RigheMappa.Add("    (" + $MinBarrePerOra + " e' la stessa soglia che histdata_m1.py usa in vol_oraria per")
  [void]$RigheMappa.Add("    dire 'ora piena'). Un anno tutto a buchi ne ha ZERO.")
  [void]$RigheMappa.Add("DENSITA' = barre medie per ora TOCCATA: 60 = giornata piena; molto meno =")
  [void]$RigheMappa.Add("buchi dentro le ore. E' il numero che separa le due ipotesi di Q2:")
  [void]$RigheMappa.Add("  finestra DIVERSA + densita' ALTA -> cambio di CONVENZIONE (sessione spostata)")
  [void]$RigheMappa.Add("  finestra UGUALE  + densita' BASSA -> BUCHI DI FEED")
  [void]$RigheMappa.Add("Le ore sono quelle SCRITTE NEL FILE, cioe' ora locale di New York")
  [void]$RigheMappa.Add("(ora server BCM = NY+5, o NY+4 nelle finestre DST sfasate).")
  [void]$RigheMappa.Add("")

  foreach($annoIt in $AnniPronti){
    if((Trascorse) -ge $OreMax){
      [void]$Problemi.Add("P6: dall'anno " + $annoIt + " in poi NON diagnosticato (tetto -OreMax " + (N1 $OreMax) + " h). Rilancia la stessa riga.")
      break
    }
    $riga = [pscustomobject]@{
      Anno=$annoIt; Barre=-1; Prima=""; Ultima=""; PrezzoMin=-1.0; PrezzoMax=-1.0
      Allarme="n/d"; FuoriBarre=-1; FuoriGiorni=-1; FuoriPct=-1.0; GiorniInteri=-1; GiorniSpike=-1
      Buchi=-1; FerialiVuoti=-1; Verdetto=""; Mesi=""; OraPrima=-1; OraUltima=-1; OreCoperte=-1; OrePiene=-1
      Densita=-1.0; GiorniMappa=-1; Classe="NON CLASSIFICABILE"; Perche="" }

    # ---------- P6: histdata_m1.py --diagnosi su UN anno ----------
    $cartAnno = Join-Path $Cartella ("anno_" + $annoIt)
    Remove-Item -LiteralPath $cartAnno -Recurse -Force -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Force -Path $cartAnno | Out-Null
    $pezzi = @($Trovati | Where-Object { $_.Pair -eq $PairDax -and $_.Anno -eq $annoIt })
    $fileZip = New-Object System.Collections.ArrayList
    $quante = 0
    foreach($pz in $pezzi){
      $quante = $quante + 1
      $dest = Join-Path $cartAnno ("copia_" + $quante + "_" + (Split-Path -Leaf $pz.File))
      try{
        [void](CopiaVerificata $pz.File $dest)
        [void]$fileZip.Add($dest)
      }catch{
        [void]$Problemi.Add("P6: " + $annoIt + ": non ho potuto copiare " + $pz.File + " (" + (UnaRiga $_.Exception.Message) + "): quel pezzo non entra nella diagnosi.")
      }
    }
    if($fileZip.Count -eq 0){
      [void]$Problemi.Add("P6: " + $annoIt + ": nessuno zip copiato: anno NON diagnosticato.")
      [void]$Anni.Add($riga)
      continue
    }
    Dico ("anno " + $annoIt + ": " + $fileZip.Count + " zip -> --diagnosi (lo strumento carica ~330k barre: qualche secondo)") "Gray"
    $logD = Join-Path $SostaLog ("diagnosi_" + $annoIt + ".log")
    $prima = @(Get-ChildItem -LiteralPath $cartAnno -Filter "referto_histdata_*.txt" -ErrorAction SilentlyContinue | ForEach-Object { $_.Name })
    $inizio = Get-Date
    $rcD = EseguiPython @("-u",$PyFile,"--diagnosi","--simboli",$PairDax,"--cartella",$cartAnno) $logD
    $rf  = RefertoFresco $cartAnno $prima $inizio
    if($rf.Stato -ne "OK"){
      [void]$Problemi.Add("P6: " + $annoIt + ": NESSUN REFERTO scritto adesso (rc " + $rcD + "). Guarda log\diagnosi_" + $annoIt + ".log")
      [void]$Anni.Add($riga)
      Remove-Item -LiteralPath $cartAnno -Recurse -Force -ErrorAction SilentlyContinue
      continue
    }
    if($rf.Nota -ne ""){ [void]$Note.Add("P6: " + $annoIt + ": " + $rf.Nota) }
    $nomeRef = "diagnosi_grxeur_" + $annoIt + ".txt"
    [void](CopiaVerificata $rf.File (Join-Path $SostaAnni $nomeRef))
    if($rcD -ne 0){
      [void]$Note.Add("P6: " + $annoIt + ": lo strumento e' uscito con " + $rcD + ". Attenzione: le barre fuori banda TROVATE non sono un errore (sono il risultato); un rc diverso da 0 qui vuol dire 'nessuna barra da analizzare'. Il referto e' nella raccolta.")
    }

    # --- lettura del referto dello strumento. Quello che non si legge
    #     resta n/d: non si inventa (checklist 66).
    $mesiTxt = New-Object System.Collections.ArrayList
    foreach($linea in @(Get-Content -LiteralPath (Join-Path $SostaAnni $nomeRef) -ErrorAction SilentlyContinue)){
      $m1 = [regex]::Match($linea,'^\s*barre fuori banda:\s*(\d+), in (\d+) giorni\.')
      if($m1.Success){ $riga.FuoriBarre = [int]$m1.Groups[1].Value; $riga.FuoriGiorni = [int]$m1.Groups[2].Value; continue }
      $m2 = [regex]::Match($linea,'^\s*nessuna barra fuori banda su (\d+) barre\.')
      if($m2.Success){ $riga.FuoriBarre = 0; $riga.FuoriGiorni = 0; continue }
      $m3 = [regex]::Match($linea,'^\S+ \(\w+\): (\d+) barre M1, dal (\d{4}\.\d{2}\.\d{2} \d{2}:\d{2}) al (\d{4}\.\d{2}\.\d{2} \d{2}:\d{2})')
      if($m3.Success){ $riga.Barre = [int]$m3.Groups[1].Value; $riga.Prima = $m3.Groups[2].Value; $riga.Ultima = $m3.Groups[3].Value; continue }
      $m4 = [regex]::Match($linea,'^\s*prezzo minimo ([0-9.]+)\s+massimo ([0-9.]+)')
      if($m4.Success){
        $riga.PrezzoMin = [double]::Parse($m4.Groups[1].Value,[Globalization.NumberStyles]::Float,$INV)
        $riga.PrezzoMax = [double]::Parse($m4.Groups[2].Value,[Globalization.NumberStyles]::Float,$INV)
        continue
      }
      if($linea -match 'ALLARME: prezzi FUORI'){ $riga.Allarme = "SI"; continue }
      if($linea -match 'ordine di grandezza dentro la banda'){ $riga.Allarme = "no"; continue }
      $m5 = [regex]::Match($linea,'^\s*(\d{4})-(\d{2})\s+apertura modale (\d{2}):(\d{2})\s+\(su (\d+) giorni\)')
      if($m5.Success){ [void]$mesiTxt.Add($m5.Groups[1].Value + "-" + $m5.Groups[2].Value + "=" + $m5.Groups[3].Value + ":" + $m5.Groups[4].Value); continue }
      $m6 = [regex]::Match($linea,'^\s*buchi intragiornalieri > 60 min: (\d+)')
      if($m6.Success){ $riga.Buchi = [int]$m6.Groups[1].Value; continue }
      $m7 = [regex]::Match($linea,'^\s*giorni feriali SENZA nessuna barra: (\d+)')
      if($m7.Success){ $riga.FerialiVuoti = [int]$m7.Groups[1].Value; continue }
      $m8 = [regex]::Match($linea,'^\s*VERDETTO FUSO: (.+)$')
      if($m8.Success -and $riga.Verdetto -eq ""){ $riga.Verdetto = $m8.Groups[1].Value.Trim(); continue }
      #  i GIORNI peggiori: "2020-06-15   1380 barre  min 2906.949  max 3100.000"
      $m9 = [regex]::Match($linea,'^\s*(\d{4}-\d{2}-\d{2})\s+(\d+) barre\s+min ([0-9.]+)\s+max ([0-9.]+)')
      if($m9.Success){
        $nb = [int]$m9.Groups[2].Value
        if($riga.GiorniInteri -lt 0){ $riga.GiorniInteri = 0; $riga.GiorniSpike = 0 }
        #  500 barre in un giorno = piu' di 8 ore di quotazioni fuori
        #  banda: e' una GIORNATA, non un tick storto. Sotto 500 si
        #  conta come sporco isolato. Soglia dichiarata qui.
        if($nb -ge 500){ $riga.GiorniInteri = $riga.GiorniInteri + 1 } else { $riga.GiorniSpike = $riga.GiorniSpike + 1 }
        continue
      }
    }
    $riga.Mesi = ($mesiTxt -join " ")
    if($riga.Barre -gt 0 -and $riga.FuoriBarre -ge 0){
      $riga.FuoriPct = 100.0 * [double]$riga.FuoriBarre / [double]$riga.Barre
    }
    if($riga.Barre -lt 0){
      [void]$Problemi.Add("P6: " + $annoIt + ": dal referto dello strumento NON ho letto il numero di barre (formato cambiato?). I numeri di quell'anno restano n/d: non li invento.")
    }

    # ---------- P7: la mappa oraria dello stesso anno ----------
    if($ZipApi){
      $g = LeggiGriglia $fileZip $PairDax $BandaLo $BandaHi
      if($g.Stato -eq "OK"){
        #  due letture della stessa griglia: la FINESTRA dalle ore
        #  toccate (soglia 1: esiste sempre), le ORE PIENE dalla soglia
        #  vera. Vedi il commento di MetricheDaGriglia.
        $mAnno  = MetricheDaGriglia $g.Griglia 1 12 1
        $mPiene = MetricheDaGriglia $g.Griglia 1 12 $MinBarrePerOra
        $riga.OraPrima    = $mAnno.Prima
        $riga.OraUltima   = $mAnno.Ultima
        $riga.OreCoperte  = $mAnno.OreCoperte
        $riga.OrePiene    = $mPiene.OreCoperte
        $riga.Densita     = $mAnno.Densita
        $riga.GiorniMappa = $mAnno.Giorni
        [void]$RigheMappa.Add("=== grxeur " + $annoIt + " ===")
        [void]$RigheMappa.Add(("  ANNO: {0} giorni con barre, {1} righe lette, finestra {2}-{3} ({4} ore toccate, {5} ore PIENE da {6} barre), densita' {7} barre/ora toccata" -f `
          $mAnno.Giorni, $g.Righe, (OraTxt $mAnno.Prima), (OraTxt $mAnno.Ultima), $mAnno.OreCoperte, $mPiene.OreCoperte, $MinBarrePerOra, (Nd $mAnno.Densita 1)))
        if($g.FuoriBanda -ge 0){
          [void]$RigheMappa.Add(("  barre fuori banda {0}-{1}: {2}" -f (N1 $BandaLo),(N1 $BandaHi),$g.FuoriBanda))
          if($g.FuoriBanda -gt 0){
            $dettaglio = New-Object System.Collections.ArrayList
            for($hh = 0; $hh -le 23; $hh++){
              if($g.FuoriOra[$hh] -gt 0){ [void]$dettaglio.Add((OraTxt $hh) + "=" + $g.FuoriOra[$hh]) }
            }
            [void]$RigheMappa.Add("  e in quali ORE stanno: " + ($dettaglio -join "  "))
          }
        }
        [void]$RigheMappa.Add("  mese      gg  finestra     tocc piene     barre  b/giorno  densita'")
        for($m = 1; $m -le 12; $m++){
          $mm = MetricheDaGriglia $g.Griglia $m $m 1
          if($mm.Giorni -eq 0){ continue }
          $mp = MetricheDaGriglia $g.Griglia $m $m $MinBarrePerOra
          $bg = [double]$mm.Barre / [double]$mm.Giorni
          [void]$RigheMappa.Add(("  {0}-{1:00}  {2,3}  {3}-{4}  {5,4} {6,5}  {7,8}  {8,8}  {9}" -f `
            $annoIt, $m, $mm.Giorni, (OraTxt $mm.Prima), (OraTxt $mm.Ultima), $mm.OreCoperte, $mp.OreCoperte, $mm.Barre, (N1 $bg), (Nd $mm.Densita 1)))
        }
        [void]$RigheMappa.Add("")
      } else {
        [void]$Problemi.Add("P7: " + $annoIt + ": mappa oraria NON MISURATA (" + $g.Stato + ").")
      }
    }

    Remove-Item -LiteralPath $cartAnno -Recurse -Force -ErrorAction SilentlyContinue
    [void]$Anni.Add($riga)
    [void]$Attesi.Add("anni\" + $nomeRef)
    Dico (("   " + $annoIt + ": barre {0}, fuori banda {1} in {2} giorni, finestra {3}-{4}, densita' {5}" -f `
      (Nd $riga.Barre 0), (Nd $riga.FuoriBarre 0), (Nd $riga.FuoriGiorni 0), (OraTxt $riga.OraPrima), (OraTxt $riga.OraUltima), (Nd $riga.Densita 1))) "White"
  }
}

# ---------------------------------------------------------------------
#  IL CONTROLLO POSITIVO: la stessa mappa su nsxusd, la serie PROMOSSA
#  (banda OK, DST 91/91 mesi, 0 righe scartate). Serve a leggere i
#  numeri del DAX contro un metro, non contro le nostre aspettative:
#  se anche il Nasdaq avesse densita' 40, allora 40 non vorrebbe dire
#  "malato", vorrebbe dire "cosi' scrive HistData".
# ---------------------------------------------------------------------
if($PuoDiagnosticare -and -not $SaltaControllo -and $ZipApi -and $AnniPronti.Count -gt 0){
  Titolo "P7-bis - CONTROLLO POSITIVO (nsxusd, la serie promossa)"
  [void]$RigheMappa.Add("=== CONTROLLO POSITIVO: nsxusd (NASUSD), stessa misura, stessi anni ===")
  foreach($annoIt in $AnniPronti){
    if((Trascorse) -ge $OreMax){ break }
    $pezzi = @($Trovati | Where-Object { $_.Pair -eq $PairCtrl -and $_.Anno -eq $annoIt })
    if($pezzi.Count -eq 0){
      [void]$RigheMappa.Add(("  nsxusd " + $annoIt + ": nessuno zip in cache -- controllo non fatto per quest'anno"))
      continue
    }
    $g = LeggiGriglia @($pezzi | ForEach-Object { $_.File }) $PairCtrl -1.0 -1.0
    if($g.Stato -ne "OK"){
      [void]$Note.Add("P7-bis: nsxusd " + $annoIt + ": mappa non misurata (" + $g.Stato + ").")
      continue
    }
    $mAnno  = MetricheDaGriglia $g.Griglia 1 12 1
    $mPiene = MetricheDaGriglia $g.Griglia 1 12 $MinBarrePerOra
    [void]$AnniCtrl.Add([pscustomobject]@{ Anno=$annoIt; Prima=$mAnno.Prima; Ultima=$mAnno.Ultima
                                           Ore=$mAnno.OreCoperte; Piene=$mPiene.OreCoperte
                                           Densita=$mAnno.Densita; Giorni=$mAnno.Giorni })
    [void]$RigheMappa.Add(("  nsxusd {0}: {1} giorni, finestra {2}-{3}, {4} ore toccate, {5} piene, densita' {6}" -f `
      $annoIt, $mAnno.Giorni, (OraTxt $mAnno.Prima), (OraTxt $mAnno.Ultima), $mAnno.OreCoperte, $mPiene.OreCoperte, (Nd $mAnno.Densita 1)))
    Dico (("   nsxusd " + $annoIt + ": finestra {0}-{1}, densita' {2}" -f (OraTxt $mAnno.Prima),(OraTxt $mAnno.Ultima),(Nd $mAnno.Densita 1))) "DarkGray"
  }
  [void]$RigheMappa.Add("")
}
if($SaltaControllo){
  [void]$Note.Add("P7-bis: controllo positivo su nsxusd SALTATO (-SaltaControllo): i numeri del DAX restano senza metro di confronto interno. Dichiarato.")
}

if($RigheMappa.Count -gt 0){
  Set-Content -LiteralPath $Mappa -Encoding ASCII -Value $RigheMappa
  [void]$Attesi.Add("MAPPA_SESSIONI.txt")
}

# =====================================================================
#  P8. IL VERDETTO. Le regole sono quelle scritte in testa al file,
#      decise PRIMA di vedere i numeri, e i valori sono parametri
#      dichiarati (-SogliaDensita, -SogliaFuoriBanda, -MaxGiorniSporchi):
#      non sono criteri firmati, e il referto lo dice.
#
#      CLASSE DI UN ANNO
#        SANO       : 0 barre fuori banda, finestra di sessione uguale
#                     a quella MODALE della serie, densita' >= soglia
#        RIPARABILE : i difetti sono tutti DICHIARABILI, cioe'
#                     (a) sporco ISOLATO: pochi GIORNI (<= MaxGiorniSporchi,
#                         si escludono per data) OPPURE poche BARRE
#                         (<= SogliaFuoriBanda % del totale, si scartano
#                         le barre fuori banda). Basta UNA delle due.
#                     (b) finestra DIVERSA ma DENSA (densita' >= soglia:
#                         e' una convenzione, non buchi)
#        MARCIO     : tutto il resto (sporco diffuso, o densita' bassa)
#        NON CLASSIFICABILE: manca un pezzo di misura (mai un verdetto
#                     su un buco)
# =====================================================================
if($Anni.Count -gt 0){
  Titolo "P8 - VERDETTO"
  #  la finestra MODALE della serie: la coppia (prima,ultima) piu'
  #  frequente fra gli anni misurati. L'elenco si costruisce ordinato
  #  (checklist 70-bis): niente chiavi di hashtable stampate.
  $finestre = New-Object System.Collections.ArrayList
  foreach($r in $Anni){
    if($r.OraPrima -lt 0){ continue }
    $chiave = ("{0:00}-{1:00}" -f $r.OraPrima, $r.OraUltima)
    $trovato = $null
    foreach($f in $finestre){ if($f.Chiave -eq $chiave){ $trovato = $f } }
    if($null -eq $trovato){
      $trovato = [pscustomobject]@{ Chiave=$chiave; Quanti=0; Prima=$r.OraPrima; Ultima=$r.OraUltima; Anni=New-Object System.Collections.ArrayList }
      [void]$finestre.Add($trovato)
    }
    $trovato.Quanti = $trovato.Quanti + 1
    [void]$trovato.Anni.Add($r.Anno)
  }
  $modale = $null
  foreach($f in $finestre){ if($null -eq $modale -or $f.Quanti -gt $modale.Quanti){ $modale = $f } }
  if($null -ne $modale){ $OraModale = $modale.Prima }

  foreach($r in $Anni){
    $difetti = New-Object System.Collections.ArrayList
    $riparabile = $true
    $misurato = ($r.Barre -gt 0 -and $r.FuoriBarre -ge 0 -and $r.OraPrima -ge 0 -and $r.Densita -ge 0)
    if(-not $misurato){
      $r.Classe = "NON CLASSIFICABILE"
      $r.Perche = "manca una misura (barre, fuori banda, finestra o densita'): vedi PROBLEMI"
      continue
    }
    #  SPORCO ISOLATO = si puo' DICHIARARE, e ci sono due modi, non uno
    #  (trovato provando, banco del 26/08): due GIORNATE intere sbagliate
    #  sono lo 0,77% delle barre dell'anno -- con la regola "pct E
    #  giorni" finivano MARCIO, mentre si escludono con due date.
    #  Percio' basta UNA delle due condizioni, e la ricetta di bonifica
    #  e' diversa:
    #    pochi GIORNI  -> si escludono i giorni (elencati nel referto)
    #    poche BARRE   -> si scartano le barre fuori banda (bonifica per
    #                     barra, strada 3 della D-F)
    #  MARCIO solo quando sono TANTI giorni E TANTE barre.
    if($r.FuoriBarre -gt 0){
      $pochiGiorni = ($r.FuoriGiorni -ge 0 -and $r.FuoriGiorni -le $MaxGiorniSporchi)
      $pocheBarre  = ($r.FuoriPct -ge 0 -and $r.FuoriPct -le $SogliaFuoriBanda)
      if($pochiGiorni -or $pocheBarre){
        $come = $(if($pochiGiorni){ "escludendo " + $r.FuoriGiorni + " giorni" }else{ "scartando le barre fuori banda" })
        [void]$difetti.Add("sporco ISOLATO (" + $r.FuoriBarre + " barre = " + (N3 $r.FuoriPct) + "% in " + $r.FuoriGiorni + " giorni; si dichiara " + $come + ")")
      } else {
        [void]$difetti.Add("sporco DIFFUSO (" + $r.FuoriBarre + " barre = " + (N3 $r.FuoriPct) + "% in " + $r.FuoriGiorni + " giorni)")
        $riparabile = $false
      }
    }
    $finestraDiversa = $false
    if($null -ne $modale -and ($r.OraPrima -ne $modale.Prima -or $r.OraUltima -ne $modale.Ultima)){
      $finestraDiversa = $true
      [void]$difetti.Add("finestra " + (OraTxt $r.OraPrima) + "-" + (OraTxt $r.OraUltima) + " diversa dalla modale " + (OraTxt $modale.Prima) + "-" + (OraTxt $modale.Ultima))
    }
    if($r.Densita -lt $SogliaDensita){
      [void]$difetti.Add("densita' " + (N1 $r.Densita) + " barre/ora sotto " + (N1 $SogliaDensita) + " = BUCHI dentro le ore")
      $riparabile = $false
    }
    if($difetti.Count -eq 0){
      $r.Classe = "SANO"
      $r.Perche = "0 fuori banda, finestra modale, densita' " + (N1 $r.Densita)
    } elseif($riparabile){
      $r.Classe = "RIPARABILE"
      $r.Perche = ($difetti -join "; ")
      if($finestraDiversa){ $r.Perche = $r.Perche + " -- ma DENSA (" + (N1 $r.Densita) + "): e' una CONVENZIONE diversa, non buchi" }
    } else {
      $r.Classe = "MARCIO"
      $r.Perche = ($difetti -join "; ")
    }
  }

  $sani       = @($Anni | Where-Object { $_.Classe -eq "SANO" }        | ForEach-Object { $_.Anno })
  $riparabili = @($Anni | Where-Object { $_.Classe -eq "RIPARABILE" }  | ForEach-Object { $_.Anno })
  $marci      = @($Anni | Where-Object { $_.Classe -eq "MARCIO" }      | ForEach-Object { $_.Anno })
  $ignoti     = @($Anni | Where-Object { $_.Classe -eq "NON CLASSIFICABILE" } | ForEach-Object { $_.Anno })

  if($sani.Count -gt 0){
    $Verdetto = "SANO PARZIALE -- anni sani: " + ($sani -join ", ")
  } elseif($riparabili.Count -gt 0){
    $Verdetto = "RIPARABILE -- nessun anno pulito, ma i difetti sono dichiarabili: " + ($riparabili -join ", ")
  } elseif($marci.Count -gt 0){
    $Verdetto = "MARCIO -- nessun anno sano ne' riparabile"
  } else {
    $Verdetto = "NON MISURATO -- nessun anno classificabile"
  }

  #  ################################################################
  #  LA GUARDIA CHE CONTROLLA LA GUARDIA (checklist 81-bis: quando
  #  scatta un allarme, la prima domanda non e' "e' troppo severo?" ma
  #  "chi ha toccato il dato prima?" -- qui: "la soglia descrive questo
  #  feed?").
  #  HistData NON scrive le barre dei minuti senza scambi: se anche il
  #  NASDAQ -- che e' la serie PROMOSSA, quella sana -- avesse densita'
  #  sotto la soglia, allora sotto soglia ci sta il FEED, non il DAX, e
  #  ogni "MARCIO per densita'" di qui sopra sarebbe un falso allarme.
  #  Non si aggiusta la soglia da soli: si DICHIARA e si dice come
  #  rifare la corsa.
  #  ################################################################
  #  IL CANCELLO SI CALCOLA SEMPRE, ANCHE (SOPRATTUTTO) QUANDO IL METRO
  #  NON C'E' -- checklist 84. Prima questo blocco stava tutto dentro
  #  "if($AnniCtrl.Count -gt 0)": la guardia esisteva solo nel ramo
  #  fortunato, e nel caso che costa (nessuno zip nsxusd in cache, o
  #  -SaltaControllo) NON esisteva affatto. MISURATO il 26/08 su un banco
  #  con i soli zip grxeur a densita' 25 e 50: VERDETTO MARCIO, PROBLEMI
  #  nessuno, ESITO OK, uscita 0 -- cioe' due notti di crawl Dukascopy
  #  (strada 2 della D-F) decise da una soglia mai confrontata con
  #  niente, su una corsa che si presentava pulita.
  $marciPerDensita = @($Anni | Where-Object { $_.Classe -eq "MARCIO" -and $_.Perche -like "*BUCHI dentro le ore*" })
  $ctrlPeggiore = -1.0
  foreach($c in $AnniCtrl){
    if($c.Densita -lt 0){ continue }
    if($ctrlPeggiore -lt 0 -or $c.Densita -lt $ctrlPeggiore){ $ctrlPeggiore = $c.Densita }
  }
  if($ctrlPeggiore -lt 0){
    #  nessun metro: -SogliaDensita non e' un criterio firmato e su
    #  questo feed non e' MAI stata misurata. Senza controllo positivo un
    #  MARCIO per densita' non e' un verdetto: e' una soglia che parla
    #  da sola.
    if($marciPerDensita.Count -gt 0){
      [void]$Problemi.Add("P8: " + $marciPerDensita.Count + " anni sono MARCIO per DENSITA', ma il controllo positivo nsxusd NON e' stato misurato (nessuno zip nsxusd in cache per quegli anni, oppure -SaltaControllo): la soglia " + (N1 $SogliaDensita) + " non e' stata confrontata con NIENTE. Quel pezzo di verdetto e' SOSPESO, non confermato.")
      [void]$Lettura.Add("ATTENZIONE: i " + $marciPerDensita.Count + " anni marcati MARCIO per densita' lo sono per la sola soglia " + (N1 $SogliaDensita) + ", che qui non ha avuto nessun metro. HistData non scrive le barre dei minuti senza scambi, quindi una densita' bassa puo' essere COME SCRIVE IL FEED e non un difetto del DAX. Prima di dare per morto il DAX HistData (e pagare le ~25 ore di crawl della strada 2), va rifatta questa stessa corsa con gli zip nsxusd degli stessi anni in cache.")
      foreach($r in $marciPerDensita){ $r.Perche = $r.Perche + "  [SOSPESO: soglia senza metro, controllo positivo non misurato]" }
    } else {
      [void]$Note.Add("P8: controllo positivo nsxusd non misurato, ma nessun anno e' MARCIO per densita': la soglia " + (N1 $SogliaDensita) + " non ha deciso niente in questa corsa.")
    }
  } elseif($ctrlPeggiore -lt $SogliaDensita){
    [void]$Lettura.Add("ATTENZIONE ALLA SOGLIA, NON AI DATI: il controllo positivo nsxusd -- che e' la serie PROMOSSA -- ha densita' minima " + (N1 $ctrlPeggiore) + ", cioe' anche LUI sotto la soglia " + (N1 $SogliaDensita) + ". Vuol dire che sotto soglia ci sta il FEED (HistData non scrive i minuti senza scambi), non il DAX: i " + $marciPerDensita.Count + " anni marcati MARCIO per densita' NON sono un verdetto valido. Si rilancia la stessa riga con -SogliaDensita di poco sotto " + (N1 $ctrlPeggiore) + ", e si dichiara il valore usato.")
    if($marciPerDensita.Count -gt 0){
      [void]$Problemi.Add("P8: " + $marciPerDensita.Count + " anni sono MARCIO per densita', ma la soglia " + (N1 $SogliaDensita) + " boccia anche il controllo positivo (minimo " + (N1 $ctrlPeggiore) + "): quel pezzo di verdetto e' SOSPESO, non confermato.")
      foreach($r in $marciPerDensita){ $r.Perche = $r.Perche + "  [SOSPESO: la soglia boccia anche il controllo positivo]" }
    }
  } else {
    [void]$Lettura.Add("La soglia di densita' " + (N1 $SogliaDensita) + " e' compatibile con questo feed: il controllo positivo nsxusd sta sopra (minimo " + (N1 $ctrlPeggiore) + ") in tutti gli anni misurati. Quindi una densita' bassa sul DAX e' una differenza DEL DAX.")
  }

  # --- Q1: prezzi impossibili
  $anniSporchi = @($Anni | Where-Object { $_.FuoriBarre -gt 0 } | ForEach-Object { $_.Anno })
  if($anniSporchi.Count -eq 0){
    $VerdettoQ1 = "NESSUNA barra fuori banda negli anni misurati."
  } else {
    $interi = 0; $spike = 0; $oltre = 0
    foreach($r in $Anni){
      if($r.GiorniInteri -gt 0){ $interi += $r.GiorniInteri }
      if($r.GiorniSpike -gt 0){ $spike += $r.GiorniSpike }
      #  L'ELENCO DELLO STRUMENTO E' TRONCATO, E IL TAGLIO NON E' NEUTRO.
      #  diagnosi_fuori_banda() stampa "i GIORNI peggiori (max 40,
      #  ordinati per barre fuori banda)": oltre il quarantesimo i giorni
      #  esistono ma NON sono nel referto, quindi non sono in questo
      #  conto. E siccome l'ordine e' per barre DECRESCENTI, quello che
      #  si perde sono i giorni con POCHE barre, cioe' proprio gli SPIKE:
      #  il troncamento pende tutto dalla parte di "GIORNATE INTERE".
      #  MISURATO il 26/08 su un anno finto con 45 giornate intere e 19
      #  di spike: il referto diceva "intere 40, isolati 0" e concludeva
      #  SCALA/VALUTA, cioe' una delle due risposte di Q1 scelta da un
      #  troncamento. Il buco si conta dal totale, che invece e' completo
      #  (riga "barre fuori banda: N, in M giorni").
      if($r.FuoriGiorni -ge 0 -and $r.GiorniInteri -ge 0){
        $fuoriElenco = $r.FuoriGiorni - ($r.GiorniInteri + $r.GiorniSpike)
        if($fuoriElenco -gt 0){ $oltre += $fuoriElenco }
      }
    }
    $VerdettoQ1 = "barre fuori banda negli anni: " + ($anniSporchi -join ", ") +
                  ". Sui giorni ELENCATI dallo strumento (che ne stampa al massimo 40 per anno): " +
                  "giornate INTERE fuori banda (>=500 barre in un giorno): " + $interi +
                  "; giorni con sporco isolato (<500 barre): " + $spike + "."
    if($oltre -gt 0){
      $VerdettoQ1 = $VerdettoQ1 + " ATTENZIONE: altri " + $oltre + " giorni sporchi NON sono in quell'elenco" +
                    " (lo strumento taglia a 40 ordinando per barre fuori banda, quindi il taglio butta via" +
                    " i giorni con POCHE barre = gli spike): la ripartizione qui sopra NON e' completa e Q1 resta SOSPESA."
      [void]$Problemi.Add("P8 Q1: l'elenco dei giorni sporchi e' TRONCATO -- " + $oltre + " giorni oltre il quarantesimo non compaiono nel referto dello strumento, e il taglio (ordinato per barre) toglie proprio gli spike. La divisione fra GIORNATE INTERE e SPAZZATURA e' misurata solo sui giorni elencati: Q1 NON e' sciolta. Per scioglierla serve la lista completa dell'anno colpito (i suoi numeri totali, quelli si', sono nella tabella).")
      [void]$Lettura.Add("Q1: NON concludo fra SCALA/VALUTA e SPAZZATURA. I giorni sporchi sono piu' di quanti lo strumento ne elenchi (" + $oltre + " oltre il taglio dei 40), e il taglio e' sbilanciato verso le giornate intere: qualunque conclusione qui sarebbe un artefatto del troncamento, non una misura. I TOTALI (barre e giorni fuori banda) restano validi e stanno nella tabella.")
    } elseif($interi -gt 0 -and $spike -eq 0){
      [void]$Lettura.Add("Q1: le barre impossibili coprono GIORNATE INTERE, non tick isolati -> non e' spazzatura, e' un problema di SCALA/VALUTA o di strumento diverso in quei giorni. Da confrontare con il prezzo del giorno prima e del giorno dopo (i valori stanno nei referti per anno).")
    } elseif($interi -eq 0 -and $spike -gt 0){
      [void]$Lettura.Add("Q1: le barre impossibili sono POCHE e in giorni isolati -> SPAZZATURA (tick storti), non un cambio di scala. Sono escludibili elencandoli.")
    } elseif($interi -gt 0 -and $spike -gt 0){
      [void]$Lettura.Add("Q1: ci sono TUTTE E DUE le cose: giornate intere fuori scala E giorni con pochi tick storti. Vanno trattate separatamente: la lista giorno per giorno sta nei referti per anno.")
    }
  }

  # --- Q2: la sessione. Il periodo della convenzione diversa si legge
  #     dai MESI, non si assume: primo e ultimo mese con apertura
  #     diversa dalla modale.
  $mesiDiversi = New-Object System.Collections.ArrayList
  foreach($r in $Anni){
    if($r.Mesi -eq ""){ continue }
    foreach($pezzo in ($r.Mesi -split " ")){
      $mm = [regex]::Match($pezzo,'^(\d{4}-\d{2})=(\d{2}):(\d{2})$')
      if(-not $mm.Success){ continue }
      $oraMese = [int]$mm.Groups[2].Value
      if($OraModale -ge 0 -and $oraMese -ne $OraModale){ [void]$mesiDiversi.Add($mm.Groups[1].Value) }
    }
  }
  $mesiOrd = @($mesiDiversi | Sort-Object -Unique)
  if($mesiOrd.Count -gt 0){
    $ConvenzDa = $mesiOrd[0]
    $ConvenzA  = $mesiOrd[$mesiOrd.Count - 1]
  }
  $densiDiversi = @($Anni | Where-Object { $_.OraPrima -ge 0 -and $null -ne $modale -and $_.OraPrima -ne $modale.Prima -and $_.Densita -ge $SogliaDensita })
  $buchiVeri    = @($Anni | Where-Object { $_.Densita -ge 0 -and $_.Densita -lt $SogliaDensita })
  if($mesiOrd.Count -eq 0 -and $buchiVeri.Count -eq 0){
    $VerdettoQ2 = "la sessione e' la STESSA in tutti i mesi misurati: nessuna anomalia di orario."
  } else {
    $VerdettoQ2 = "mesi con apertura diversa dalla modale: " + $mesiOrd.Count
    if($ConvenzDa -ne ""){ $VerdettoQ2 = $VerdettoQ2 + " (dal " + $ConvenzDa + " al " + $ConvenzA + ")" }
    $VerdettoQ2 = $VerdettoQ2 + "; anni con densita' sotto " + (N1 $SogliaDensita) + ": " + $buchiVeri.Count + "."
    if($densiDiversi.Count -gt 0 -and $buchiVeri.Count -eq 0){
      [void]$Lettura.Add("Q2: le giornate del periodo diverso sono PIENE (densita' sopra la soglia) ma spostate di orario -> e' un CAMBIO DI CONVENZIONE del feed, NON buchi. Cioe' quei dati ci sono tutti: manca la fascia oraria che il feed non copriva piu'.")
    } elseif($buchiVeri.Count -gt 0 -and $densiDiversi.Count -eq 0){
      [void]$Lettura.Add("Q2: la finestra non cambia ma le ore sono MENO PIENE -> BUCHI DI FEED, non una convenzione. Un buco di feed non si 'dichiara': si esclude il periodo.")
    } elseif($buchiVeri.Count -gt 0 -and $densiDiversi.Count -gt 0){
      [void]$Lettura.Add("Q2: ci sono TUTTE E DUE le cose: anni con sessione spostata ma piena (convenzione) e anni con ore mezze vuote (buchi). Vanno trattati separatamente, anno per anno: la tabella qui sotto dice quale e' quale.")
    }
  }

  # --- Q3
  if($sani.Count -gt 0){
    $VerdettoQ3 = "SI: gli anni " + ($sani -join ", ") + " passerebbero i cancelli dello strumento cosi' come sono."
    if($riparabili.Count -gt 0){ $VerdettoQ3 = $VerdettoQ3 + " In piu' " + ($riparabili -join ", ") + " sarebbero usabili DICHIARANDO il difetto." }
  } elseif($riparabili.Count -gt 0){
    $VerdettoQ3 = "NON cosi' come sono, ma " + ($riparabili -join ", ") + " lo diventerebbero dichiarando la convenzione/i giorni esclusi."
  } else {
    $VerdettoQ3 = "NO: nessun anno misurato regge i cancelli."
  }
  if($ignoti.Count -gt 0){ $VerdettoQ3 = $VerdettoQ3 + " Restano NON CLASSIFICABILI: " + ($ignoti -join ", ") + "." }

  Write-Host ("   VERDETTO: " + $Verdetto) -ForegroundColor $(if($Verdetto -like "SANO*"){ "Green" }elseif($Verdetto -like "RIPARABILE*"){ "Yellow" }else{ "Red" })
}

# =====================================================================
#  P9. REFERTO + ZIP + ATTESI/TROVATI
# =====================================================================
Titolo "P9 - REFERTO E RACCOLTA"
$RefRighe = New-Object System.Collections.ArrayList
[void]$RefRighe.Add("=====================================================================")
[void]$RefRighe.Add(" REFERTO -- DIAGNOSI DEL DAX HISTDATA (grxeur)")
[void]$RefRighe.Add("=====================================================================")
[void]$RefRighe.Add("data: " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   <-- QUESTA DATA DEVE ESSERE DI ADESSO")
[void]$RefRighe.Add("avvio: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   durata: " + (N2 ((New-TimeSpan -Start $Avvio -End (Get-Date)).TotalMinutes)) + " min")
[void]$RefRighe.Add("macchina: " + $env:COMPUTERNAME + "   utente: " + $env:USERNAME)
[void]$RefRighe.Add("pin: " + $Pin)
[void]$RefRighe.Add("strumento: histdata_m1.py HD-M1-v4 (al pin, autotest verificato)")
[void]$RefRighe.Add("python: " + $Python + "  " + $PyVers)
[void]$RefRighe.Add("banda di prezzo usata: " + $(if($BandaLo -gt 0){ (N1 $BandaLo) + " - " + (N1 $BandaHi) + "  [" + $BandaFonte + "]" }else{ "NON LETTA" }))
[void]$RefRighe.Add("modo: " + $(if($EstendiIndietro){ "con -EstendiIndietro: gli anni mancanti sono stati CHIESTI a HistData e i loro zip stanno nella cache " + $CartellaHD }else{ "OFFLINE: nessun byte di dati scaricato, si sono usati solo gli zip gia' in cache" }))
[void]$RefRighe.Add("canarino di ritmo: " + $Canarino)
[void]$RefRighe.Add("")
[void]$RefRighe.Add("!!! QUESTA CORSA NON IMPORTA NIENTE E NON AUTORIZZA NIENTE.")
[void]$RefRighe.Add("    Nessun simbolo _EXT e' stato creato o toccato; MT5 non e' stato")
[void]$RefRighe.Add("    aperto. Il CANCELLO ZERO sugli indici _EXT resta CHIUSO e la")
[void]$RefRighe.Add("    decisione D-C dice SOLO_PROVA_REGIME: usare un eventuale")
[void]$RefRighe.Add("    sottoinsieme sano richiede una FIRMA a parte, che qui non c'e'.")
[void]$RefRighe.Add("")
[void]$RefRighe.Add("!!! I DATI SONO DI HISTDATA, NON DI BCM: spread, orari di seduta e")
[void]$RefRighe.Add("    prezzi non sono quelli del broker su cui si trada.")
[void]$RefRighe.Add("")
[void]$RefRighe.Add("--- L'AUTORIZZAZIONE (letta al pin, non assunta) ---")
[void]$RefRighe.Add("  " + $DecFrase)
foreach($d in $Decisioni){
  [void]$RefRighe.Add(("    {0,-5} {1,-22} {2,-24} {3}" -f $d.Id,$d.Chiave,$d.Valore,$d.Stato))
}
[void]$RefRighe.Add("")
[void]$RefRighe.Add("--- LE TRE DOMANDE (scritte PRIMA di guardare i numeri) ---")
[void]$RefRighe.Add("  Q1 i prezzi impossibili: in quali anni, e scala/valuta o spazzatura?")
[void]$RefRighe.Add("     RISPOSTA: " + $VerdettoQ1)
[void]$RefRighe.Add("  Q2 la sessione ballerina: quali ore coprono i giorni, e convenzione o buchi?")
[void]$RefRighe.Add("     RISPOSTA: " + $VerdettoQ2)
[void]$RefRighe.Add("  Q3 esiste un sottoinsieme sano dichiarabile?")
[void]$RefRighe.Add("     RISPOSTA: " + $VerdettoQ3)
[void]$RefRighe.Add("")
[void]$RefRighe.Add("--- LETTURA GIA' FATTA DAL CODICE (dove i numeri bastano) ---")
if($Lettura.Count -eq 0){ [void]$RefRighe.Add("  nessuna: non c'erano abbastanza misure per concludere da soli.") }
foreach($linea in $Lettura){ [void]$RefRighe.Add("  - " + $linea) }
[void]$RefRighe.Add("")
[void]$RefRighe.Add("--- ANNO PER ANNO (grxeur) ---")
[void]$RefRighe.Add(("  {0,-5} {1,9} {2,8} {3,7} {4,8} {5,-11} {6,5} {7,8} {8,-12} {9}" -f `
  "anno","barre","fuoriB","giorni","fuori%","finestra","piene","dens","classe","perche'"))
foreach($r in $Anni){
  [void]$RefRighe.Add(("  {0,-5} {1,9} {2,8} {3,7} {4,8} {5,-11} {6,5} {7,8} {8,-12} {9}" -f `
    $r.Anno, (Nd $r.Barre 0), (Nd $r.FuoriBarre 0), (Nd $r.FuoriGiorni 0), (Nd $r.FuoriPct 3),
    ((OraTxt $r.OraPrima) + "-" + (OraTxt $r.OraUltima)), (Nd $r.OrePiene 0), (Nd $r.Densita 1), $r.Classe, $r.Perche))
}
if($Anni.Count -eq 0){ [void]$RefRighe.Add("  nessun anno diagnosticato.") }
[void]$RefRighe.Add("")
[void]$RefRighe.Add("  n/d = NON MISURATO (mai uno zero al posto di un buco).")
[void]$RefRighe.Add("  'finestra' = prima e ultima ora TOCCATA dal feed; 'piene' = quante di")
[void]$RefRighe.Add("  quelle ore hanno almeno " + $MinBarrePerOra + " barre in meta' dei giorni; 'dens' =")
[void]$RefRighe.Add("  barre medie per ora toccata (60 = giornata piena, molto meno = buchi).")
#  OGNI ORA DICHIARA IL SUO FUSO, anche qui: la colonna 'finestra' e'
#  l'unico posto del referto dove Claudio legge degli ORARI, e senza
#  questa riga li leggerebbe in ora server BCM (l'ora di casa: DAX 8,
#  Nasdaq 14). Sono NY: 02:00 NY cade dentro la mattina europea, cioe'
#  la "sessione ballerina" 2020-2023 racconta una storia diversa a
#  seconda dell'orologio con cui la si legge.
[void]$RefRighe.Add("  ATTENZIONE ALL'OROLOGIO: le ore della colonna 'finestra' sono quelle")
[void]$RefRighe.Add("  SCRITTE NEL FILE HISTDATA, cioe' ORA LOCALE DI NEW YORK. NON sono ora")
[void]$RefRighe.Add("  server BCM e NON sono ora italiana. Ora server BCM = NY+5 (NY+4 nelle")
[void]$RefRighe.Add("  finestre in cui il DST americano e quello europeo sono sfasati); ora")
[void]$RefRighe.Add("  italiana = server BCM + 1. Esempio: 02:00 NY = 07:00 server = 08:00 IT.")
[void]$RefRighe.Add("  'fuoriB' e 'giorni' vengono dal referto di histdata_m1.py --diagnosi;")
[void]$RefRighe.Add("  'finestra' e 'dens' dalla mappa oraria calcolata da questa riga sugli")
[void]$RefRighe.Add("  ZIP (conteggio di COPERTURA: non applica il filtro OHLC del .py, quindi")
[void]$RefRighe.Add("  i totali possono differire di poche barre. Dichiarato).")
[void]$RefRighe.Add("")
[void]$RefRighe.Add("--- PREZZI E FUSO, ANNO PER ANNO (come li ha scritti lo strumento) ---")
foreach($r in $Anni){
  [void]$RefRighe.Add(("  {0}: prezzo {1} - {2}, ALLARME banda {3}, buchi>60min {4}, feriali vuoti {5}" -f `
    $r.Anno, (Nd $r.PrezzoMin 2), (Nd $r.PrezzoMax 2), $r.Allarme, (Nd $r.Buchi 0), (Nd $r.FerialiVuoti 0)))
  if($r.Verdetto -ne ""){ [void]$RefRighe.Add("        verdetto fuso dello strumento: " + $r.Verdetto) }
  if($r.Mesi -ne ""){ [void]$RefRighe.Add("        apertura modale mese per mese: " + $r.Mesi) }
}
[void]$RefRighe.Add("")
[void]$RefRighe.Add("--- CONTROLLO POSITIVO: nsxusd (NASUSD), la serie PROMOSSA ---")
if($AnniCtrl.Count -eq 0){
  [void]$RefRighe.Add("  NON FATTO (saltato o nessuno zip nsxusd in cache): i numeri del DAX")
  [void]$RefRighe.Add("  restano senza metro di confronto interno.")
} else {
  [void]$RefRighe.Add(("  {0,-5} {1,7} {2,-11} {3,5} {4,6} {5,8}" -f "anno","giorni","finestra","tocc","piene","dens"))
  foreach($c in $AnniCtrl){
    [void]$RefRighe.Add(("  {0,-5} {1,7} {2,-11} {3,5} {4,6} {5,8}" -f `
      $c.Anno, $c.Giorni, ((OraTxt $c.Prima) + "-" + (OraTxt $c.Ultima)), $c.Ore, $c.Piene, (Nd $c.Densita 1)))
  }
  [void]$RefRighe.Add("  Serve a questo: se il DAX ha densita' 40 e il Nasdaq pure, allora 40")
  [void]$RefRighe.Add("  e' 'come scrive HistData', non 'malato'. Se il Nasdaq sta a 59 e il")
  [void]$RefRighe.Add("  DAX a 40, la differenza e' del DAX.")
}
[void]$RefRighe.Add("")
[void]$RefRighe.Add("--- IL VERDETTO, TRE ESITI (regole dichiarate PRIMA della misura) ---")
[void]$RefRighe.Add("  " + $Verdetto)
[void]$RefRighe.Add("")
[void]$RefRighe.Add("  Le regole, e i valori con cui e' girata questa corsa:")
[void]$RefRighe.Add("    SANO       = 0 barre fuori banda + finestra uguale alla MODALE della")
[void]$RefRighe.Add("                 serie + densita' >= " + (N1 $SogliaDensita) + " barre/ora coperta")
[void]$RefRighe.Add("    RIPARABILE = solo difetti DICHIARABILI:")
[void]$RefRighe.Add("                 - sporco ISOLATO: in <= " + $MaxGiorniSporchi + " giorni (si escludono per data)")
[void]$RefRighe.Add("                   OPPURE <= " + (N2 $SogliaFuoriBanda) + "% delle barre (si scartano le barre")
[void]$RefRighe.Add("                   fuori banda). Basta UNA delle due: sono due bonifiche diverse.")
[void]$RefRighe.Add("                 - e/o finestra diversa dalla modale ma DENSA (= convenzione)")
[void]$RefRighe.Add("    MARCIO     = sporco diffuso (tanti giorni E tante barre), oppure")
[void]$RefRighe.Add("                 densita' sotto soglia (buchi dentro le ore)")
[void]$RefRighe.Add("    NON CLASSIFICABILE = manca una misura. Non e' un verdetto: e' un buco.")
[void]$RefRighe.Add("  Queste soglie sono PARAMETRI di questa riga (-SogliaDensita,")
[void]$RefRighe.Add("  -SogliaFuoriBanda, -MaxGiorniSporchi), NON criteri firmati: si")
[void]$RefRighe.Add("  possono discutere, e i numeri grezzi qui sopra restano validi comunque.")
$OraModaleSrv = -1
if($OraModale -ge 0){ $OraModaleSrv = ($OraModale + 5) % 24 }
if($ConvenzDa -ne ""){
  [void]$RefRighe.Add("")
  [void]$RefRighe.Add("  LA CONVENZIONE DIVERSA, MISURATA: dal " + $ConvenzDa + " al " + $ConvenzA +
                      " l'apertura modale non e' quella della serie (" + (OraTxt $OraModale) + " ora di NEW YORK, = " +
                      (OraTxt $OraModaleSrv) + " ora server BCM).")
}
[void]$RefRighe.Add("")
[void]$RefRighe.Add("--- QUELLO CHE QUESTA CORSA NON PUO' DIRE ---")
[void]$RefRighe.Add("  1. Vede UN SOLO FEED (HistData). Che il DAX vero di quei giorni")
[void]$RefRighe.Add("     valesse X lo dicono altri feed: Dukascopy (DEUIDXEUR, strada 2")
[void]$RefRighe.Add("     della D-F) o il grafico BCM nativo dal 26/09/2024 in poi.")
[void]$RefRighe.Add("  2. Non dice se il DAX HistData e' lo STESSO STRUMENTO del CFD BCM:")
[void]$RefRighe.Add("     fra indice e future c'e' il basis, e quello nessun orario lo cura.")
[void]$RefRighe.Add("  3. Non misura il CANCELLO ZERO (diff media contro il nativo): quello")
[void]$RefRighe.Add("     si misura solo importando, e importare qui e' vietato da D-F")
[void]$RefRighe.Add("     finche' questa diagnosi non e' letta e firmata.")
[void]$RefRighe.Add("  4. Gli anni non presenti in cache NON sono stati guardati: se il")
[void]$RefRighe.Add("     referto non li nomina, non esistono per questa misura.")
[void]$RefRighe.Add("  5. LA BANDA PRENDE SOLO GLI ERRORI GROSSOLANI. E' un controllo di")
[void]$RefRighe.Add("     ORDINE DI GRANDEZZA (becca il fattore 1.000 o un 2.906 su un DAX")
[void]$RefRighe.Add("     da 13.000), NON un giudizio sul prezzo: un anno quotato, che so,")
[void]$RefRighe.Add("     a meta' valore ma dentro 4000-45000 passerebbe la banda senza")
[void]$RefRighe.Add("     fiatare. Per questo il referto stampa il MINIMO e il MASSIMO di")
[void]$RefRighe.Add("     ogni anno qui sopra: se un anno ha estremi che non stanno con")
[void]$RefRighe.Add("     quelli degli anni vicini, e' un sospetto che la banda non vede.")
[void]$RefRighe.Add("")
[void]$RefRighe.Add("--- PROPOSTA PER IL PROSSIMO PASSO (proposta, NON una firma) ---")
[void]$RefRighe.Add("  Se il verdetto e' SANO PARZIALE o RIPARABILE, il passo successivo NON")
[void]$RefRighe.Add("  e' importare: e' scrivere in STORICO_INDICI_CRITERI.md una decisione")
[void]$RefRighe.Add("  nuova che dica ESATTAMENTE quale sottoinsieme si usa (anni + ore +")
[void]$RefRighe.Add("  giorni esclusi) e con quale limite d'uso. Finche' quella firma non")
[void]$RefRighe.Add("  c'e', il DAX HistData resta dov'e'.")
[void]$RefRighe.Add("  Se il verdetto e' MARCIO, la strada 2 della D-F (Dukascopy DEUIDXEUR")
[void]$RefRighe.Add("  sulle sole finestre di regime, ~25 ore di crawl) diventa quella buona.")
[void]$RefRighe.Add("")

$TrovatiOra = @(@(Get-ChildItem -LiteralPath $Sosta -File -ErrorAction SilentlyContinue | ForEach-Object { $_.Name }) +
                @(Get-ChildItem -LiteralPath $SostaAnni -File -ErrorAction SilentlyContinue | ForEach-Object { "anni\" + $_.Name }))
$TrovatiOra = @($TrovatiOra + @("REFERTO_DIAGNOSI_DAX.txt") | Sort-Object -Unique)
$QuantiLog  = @(Get-ChildItem -LiteralPath $SostaLog -File -ErrorAction SilentlyContinue).Count
[void]$RefRighe.Add("--- FILE ATTESI E FILE TROVATI ---")
[void]$RefRighe.Add("  attesi : " + ((@($Attesi | Sort-Object -Unique)) -join ", "))
[void]$RefRighe.Add("  trovati: " + ($TrovatiOra -join ", "))
[void]$RefRighe.Add("           (+ la cartella log\ con " + $QuantiLog + " file: l'uscita cruda di ogni chiamata a python)")
[void]$RefRighe.Add("           REFERTO_DIAGNOSI_DAX.txt e' l'ULTIMO file scritto: se stai leggendo questa riga, c'e'.")
$Mancanti = @(@($Attesi | Sort-Object -Unique) | Where-Object { $TrovatiOra -notcontains $_ })
if($Mancanti.Count -gt 0){
  [void]$Problemi.Add("P9: mancano dalla raccolta: " + ($Mancanti -join ", "))
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
$AnniFatti = @($Anni | Where-Object { $_.Barre -gt 0 }).Count
if($Problemi.Count -gt 0 -or -not $PuoDiagnosticare -or $AnniFatti -eq 0){
  $Uscita = 1
  [void]$RefRighe.Add("ESITO: PARZIALE -- " + $Problemi.Count + " problemi, anni diagnosticati " + $AnniFatti + " su " + $AnniChiesti.Count + " chiesti.")
  [void]$RefRighe.Add("       'non misurabile' E' GIA' UNA RISPOSTA: questo referto va mandato lo stesso.")
} else {
  $Uscita = 0
  [void]$RefRighe.Add("ESITO: OK -- anni diagnosticati " + $AnniFatti + " su " + $AnniChiesti.Count + " chiesti.")
}
Set-Content -LiteralPath $Referto -Encoding ASCII -Value $RefRighe

Compress-Archive -Path (Join-Path $Sosta "*") -DestinationPath $ZipFin -Force
#  LO ZIP SI CONTROLLA DENTRO, non sull'esistenza del nome (checklist
#  27-ter): se manca un pezzo si vede ADESSO, non quando Claudio l'ha
#  gia' mandato in chat.
$DentroZip = @()
if(Test-Path -LiteralPath $ZipFin){
  $arch = $null
  try{
    $arch = [System.IO.Compression.ZipFile]::OpenRead($ZipFin)
    $DentroZip = @($arch.Entries | ForEach-Object { $_.FullName -replace '/','\' })
  }catch{
    [void]$Note.Add("P9: lo zip non si e' lasciato rileggere (" + (UnaRiga $_.Exception.Message) + "): il contenuto NON e' stato verificato.")
  }finally{ if($null -ne $arch){ try{ $arch.Dispose() }catch{ } } }
}
if(-not (Test-Path -LiteralPath $ZipFin)){
  Write-Host "!!! LO ZIP NON E' STATO CREATO: manda la CARTELLA sul Desktop." -ForegroundColor Red
  $Uscita = 1
} else {
  $FuoriZip = @(@($Attesi | Sort-Object -Unique) | Where-Object { $DentroZip -notcontains $_ })
  if($DentroZip.Count -eq 0){
    Write-Host "ATTENZIONE: contenuto dello zip NON verificato (vedi NOTE del referto)." -ForegroundColor Yellow
  } elseif($FuoriZip.Count -gt 0){
    Write-Host ("!!! NELLO ZIP MANCANO: " + ($FuoriZip -join ", ") + " -- manda anche la CARTELLA " + $Sosta) -ForegroundColor Red
    $Uscita = 1
  } else {
    Write-Host ("contenuto dello zip verificato: " + $DentroZip.Count + " voci, ci sono tutti gli attesi.") -ForegroundColor Green
  }
  #  la raccolta automatica dello strumento si toglie di mezzo SOLO dopo
  #  che il nostro zip esiste: due zip sul Desktop, uno solo dei quali
  #  buono, e' il modo di far mandare il file sbagliato.
  Remove-Item -LiteralPath $RaccoltaStrumento    -Recurse -Force -ErrorAction SilentlyContinue
  Remove-Item -LiteralPath $RaccoltaStrumentoZip -Force -ErrorAction SilentlyContinue
  if(Test-Path -LiteralPath $RaccoltaStrumentoZip){
    [void]$Note.Add("P9: Desktop\histdata_m1.zip non si e' lasciato cancellare: NON e' quello da mandare.")
    Write-Host "ATTENZIONE: sul Desktop e' rimasto anche histdata_m1.zip (dello strumento): NON e' quello da mandare." -ForegroundColor Yellow
  }
}

Write-Host ""
Write-Host ("VERDETTO : " + $Verdetto) -ForegroundColor $(if($Verdetto -like "SANO*"){ "Green" }elseif($Verdetto -like "RIPARABILE*"){ "Yellow" }else{ "Red" })
Write-Host ("REFERTO  : " + $Referto) -ForegroundColor Cyan
Write-Host ("ZIP DA MANDARE IN CHAT: " + $ZipFin) -ForegroundColor Cyan
Write-Host "ELENCO FILE ATTESI (prodotto dal codice, non scritto a mano):" -ForegroundColor Cyan
foreach($att in @($Attesi | Sort-Object -Unique)){ Write-Host ("   " + $att) }
Write-Host ""
#  L'ESITO A SCHERMO E QUELLO DEL REFERTO NASCONO DALLO STESSO NUMERO
#  (checklist 22 e 84 pezzo 2). Prima questo ramo guardava
#  $Problemi.Count mentre il referto e l'uscita guardavano anche
#  $PuoDiagnosticare e $AnniFatti: con la cache vuota la console
#  stampava un "ESITO: OK" VERDE e lo script usciva 1 -- MISURATO il
#  26/08. Due esiti calcolati da due espressioni diverse ne hanno sempre
#  uno che mente, ed e' quello che si legge a schermo.
if($Uscita -ne 0){
  Write-Host ("ESITO: PARZIALE (uscita " + $Uscita + ") -- " + $Problemi.Count + " problemi, anni diagnosticati " + $AnniFatti + " su " + $AnniChiesti.Count + " chiesti. IL REFERTO VA MANDATO LO STESSO:") -ForegroundColor Yellow
  foreach($prob in $Problemi){ Write-Host ("   - " + $prob) -ForegroundColor Yellow }
  if($Problemi.Count -eq 0){
    Write-Host "   - nessun problema elencato, ma non e' stato diagnosticato NESSUN anno (cache vuota, o D-F non autorizza): vedi il referto." -ForegroundColor Yellow
  }
} else {
  Write-Host "ESITO: OK" -ForegroundColor Green
}
Write-Host ("Nel referto la riga 'data:' deve dire " + (Get-Date).ToString("yyyy-MM-dd HH:mm",$INV) + " circa: se dice altro, stai guardando un file vecchio.") -ForegroundColor Cyan
exit $Uscita
