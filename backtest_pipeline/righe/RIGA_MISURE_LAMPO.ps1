# =====================================================================
#  MARCATORE_RIGA_MISURE_LAMPO_v1
#  RIGA_MISURE_LAMPO.ps1  --  LE DUE MISURE LAMPO DEL CANCELLO _EXT
#                             (26/08/2026, PC di backtest DESKTOP-H4D7CAJ)
# ---------------------------------------------------------------------
#  PERCHE' ESISTE
#  ANALISI_CANCELLO_ZERO_EXT_2026-08-25.md par. 5(b) dice che per
#  decidere fra metro ASSOLUTO (0,05% fisso) e metro RELATIVO
#  (0,20 x range H1 medio) mancano DUE misure, mai eseguite:
#    1. --vol-oraria  : il range orario VERO di nsxusd/jpxjpy/spxusd e
#                       di eurusd (il controllo positivo forex), che
#                       sostituisce le bande [INFERITO] del par. 3;
#    2. --estrai      : l'anatomia dei TRE eventi con la diff max
#                       (2026.03.23 e 2025.11.20), per capire se sono
#                       buchi di feed, eventi macro o sessioni storte.
#  Le righe erano gia' abbozzate in REFERTO_HISTDATA_FATTIBILITA.md
#  par. 16.1 e 16.2. Questo driver le esegue TUTTE E DUE in un colpo,
#  con una raccolta sola.
#
#  ###################################################################
#  #  QUELLO CHE QUESTA RIGA **NON** FA:                             #
#  #  NON firma niente. Il cancello zero resta 0,05% e i tre indici   #
#  #  _EXT restano IN FRIGO finche' Claudio non firma un altro metro. #
#  #  Qui si PRODUCONO i numeri che servono per decidere, e basta.    #
#  #  NON tocca R110/R111/STORICO/VWAP, non tocca nessun EA, non      #
#  #  scrive un byte dentro MetaQuotes\Terminal.                      #
#  ###################################################################
#
#  MT5 PUO' RESTARE APERTO -- e questa e' una DICHIARAZIONE, non una
#  dimenticanza (checklist 7). Qui non si scrive niente in
#  MetaQuotes\Terminal: si leggono CSV/ZIP e si scrive sul Desktop.
#  L'unica cosa che MT5 si porta via e' la RAM, e quella e' un cancello
#  vero: --vol-oraria tiene tutte le barre del simbolo in memoria
#  (~690 byte a barra MISURATI il 25/08, checklist 74), cioe' ~1,7 GB
#  per un indice da 2,5 M barre. Percio' la RAM libera si MISURA prima
#  e sotto -MinRamMB la fase non parte (si dichiara, non si tenta).
#
#  QUELLO CHE LO STRUMENTO PUO' CANCELLARE (checklist 26, la domanda
#  "oltre a stampare, cosa FA?"): histdata_m1.py, quando ingerisce una
#  cartella di ZIP, CANCELLA gli zip che non riesce ad aprire (e' il
#  suo modo, giusto, di non avvelenare la cache -- checklist 16). Se
#  succede su uno zip forex, il referto lo scrive fra i PROBLEMI con
#  nome e cognome: quello zip andra' riscaricato la prossima volta che
#  serve un import forex.
#
#  LE FASI
#   P0  pin, cultura invariante, cartelle, RAM
#   P1  python vero (niente stub del Microsoft Store, checklist 17)
#   P2  histdata_m1.py AL PIN + marcatore HD-M1-v4 + autotest 11/11
#   P3  CENSIMENTO DELLE FONTI: per ogni simbolo si dice DOVE stanno i
#       dati e SE sono leggibili. Tre stati, mai un'assunzione.
#   P4  --vol-oraria (una chiamata per cartella, referto messo subito
#       in sosta con nome proprio: checklist 26)
#   P5  --estrai dei TRE eventi
#   P6  la tabella dei rapporti diff/vol, con n/d dove non e' uscito
#   P7  referto + zip + elenco ATTESI confrontato coi TROVATI
#
#  CODICI D'USCITA (li legge la riga di chat, checklist 13 e 26-bis)
#   0 = tutto misurato
#   1 = qualcosa NON misurato: IL REFERTO C'E' LO STESSO E VA MANDATO
#       ("non misurabile" e' gia' una risposta, non un guasto)
#   2 = NON PARTITA (pin, python, strumento, autotest, RAM): non c'e'
#       niente da mandare, si rimedia e si rilancia
#
#  LA RIGA CHE SI INCOLLA sta in
#  backtest_pipeline\righe\RIGA_MISURE_LAMPO_DA_MANDARE.md
#  (blocco INTERO, un comando solo: checklist 21).
# =====================================================================
[CmdletBinding()]
param(
  [string]$Pin            = "",   # OBBLIGATORIO sha40: senza, non parte
  [switch]$SoloControllo,         # giro a vuoto: P0-P3, nessuna misura
  [string]$CartellaIndici = "",   # default ~\histdata_m1        (CSV 18/08, 2019-2026)
  [string]$CartellaForex  = "",   # default ~\abtg_storico_esterno (import forex 15/08)
  [string]$CartellaLunga  = "",   # default ~\abtg_storico_indici  (NASUSD 17 anni, 25/08)
  [int]   $MinRamMB       = 2000  # sotto questa RAM libera la fase vol NON parte
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
  Write-Host "    Usa il blocco di lancio del foglio RIGA_MISURE_LAMPO_DA_MANDARE.md," -ForegroundColor Yellow
  Write-Host "    con l'hash dato in chat." -ForegroundColor Yellow
  exit 2
}
$Pin = $Pin.ToLower()

$Avvio   = Get-Date
$Stamp   = $Avvio.ToString("yyyyMMdd_HHmm",$INV)
$Desktop = [Environment]::GetFolderPath("Desktop")
if([string]::IsNullOrWhiteSpace($Desktop)){ $Desktop = Join-Path $env:USERPROFILE "Desktop" }

if([string]::IsNullOrWhiteSpace($CartellaIndici)){ $CartellaIndici = Join-Path $env:USERPROFILE "histdata_m1" }
if([string]::IsNullOrWhiteSpace($CartellaForex)) { $CartellaForex  = Join-Path $env:USERPROFILE "abtg_storico_esterno" }
if([string]::IsNullOrWhiteSpace($CartellaLunga)) { $CartellaLunga  = Join-Path $env:USERPROFILE "abtg_storico_indici" }
$CartellaForexZip = Join-Path $CartellaForex "zip"

$Sosta    = Join-Path $Desktop ("MISURE_LAMPO_" + $Stamp)
$SostaLog = Join-Path $Sosta "log"
$Referto  = Join-Path $Sosta "REFERTO_MISURE_LAMPO.txt"
$Censo    = Join-Path $Sosta "CENSIMENTO_FONTI.txt"
$ZipFin   = Join-Path $Desktop ("MISURE_LAMPO_" + $Stamp + ".zip")
$PyFile   = Join-Path $env:USERPROFILE "histdata_m1.py"
$RawPin   = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

# --- TUTTO quello che il referto finale legge nasce QUI, FUORI dal try
#     (checklist 48 e 82 pezzo 4): su un errore a meta' il referto si
#     scrive lo stesso e non esplode su una variabile mai creata.
$Problemi  = New-Object System.Collections.ArrayList
$Note      = New-Object System.Collections.ArrayList
$RefRighe  = New-Object System.Collections.ArrayList
$Attesi    = New-Object System.Collections.ArrayList
$Lettura   = New-Object System.Collections.ArrayList
$Python    = ""
$PyVers    = "(non letta)"
$RamLibera = -1.0
$RamStato  = "NON MISURATA"
$Uscita    = 0

# ---------------------------------------------------------------------
#  LA TAVOLA DEI SIMBOLI -- un ARRAY ORDINATO, mai le chiavi di un
#  hashtable: quelle non hanno ordine e cambiano a ogni processo
#  (checklist 70-bis, misurato).
#  DiffAtti = la diff media agli atti, in % del prezzo. Fonti:
#    NASUSD/SPXUSD/225JPY -> import_ext_v2_referto_2026-08-19.csv,
#      colonna FUORI finestre DST (e' il numero giusto per il confronto:
#      l'evento del 23/03 cade DENTRO la finestra di marzo)
#    EURUSD -> PROVA_REGIME_CRITERI.md par.2 (v1, intero periodo)
# ---------------------------------------------------------------------
$Tavola = @(
  [pscustomobject]@{ Bcm="NASUSD"; Hd="nsxusd"; Gruppo="INDICI"; DiffAtti=0.0662; FonteDiff="v2 19/08, fuori finestre DST"; Cart=""; Fonte="NON CERCATA"; Stato="NON CERCATA"; VolTot=-1.0; Vol2025=-1.0; VolAnni="" },
  [pscustomobject]@{ Bcm="225JPY"; Hd="jpxjpy"; Gruppo="INDICI"; DiffAtti=0.0871; FonteDiff="v2 19/08, fuori finestre DST"; Cart=""; Fonte="NON CERCATA"; Stato="NON CERCATA"; VolTot=-1.0; Vol2025=-1.0; VolAnni="" },
  [pscustomobject]@{ Bcm="SPXUSD"; Hd="spxusd"; Gruppo="INDICI"; DiffAtti=0.0527; FonteDiff="v2 19/08, fuori finestre DST"; Cart=""; Fonte="NON CERCATA"; Stato="NON CERCATA"; VolTot=-1.0; Vol2025=-1.0; VolAnni="" },
  [pscustomobject]@{ Bcm="EURUSD"; Hd="eurusd"; Gruppo="FOREX";  DiffAtti=0.0041; FonteDiff="v1 15/08, intero periodo"; Cart=""; Fonte="NON CERCATA"; Stato="NON CERCATA"; VolTot=-1.0; Vol2025=-1.0; VolAnni="" }
)

# ---------------------------------------------------------------------
#  I TRE EVENTI.
#  L'ora di --estrai va data COME E' SCRITTA NEL CSV, cioe' ORA LOCALE
#  DI NEW YORK (histdata_m1.py righe 12-16). Le diff max dei referti di
#  import sono invece in ORA SERVER (verificato nel sorgente:
#  ABTG_ImportaStoricoEsterno.mq5 riga 505, qmax = tnat, cioe' il
#  timestamp GIA' spostato nel fuso del nativo).
#
#  LA CONVERSIONE, UNA PER EVENTO, FATTA SUL CALENDARIO E NON A MEMORIA
#  (server = calendario europeo: UTC+0 d'inverno, UTC+1 d'estate;
#   NY = EST UTC-5 d'inverno, EDT UTC-4 d'estate. DST USA 2026: 8 marzo
#   - 1 novembre. DST Europa 2026: 29 marzo - 25 ottobre. Le "finestre
#   sfasate" sono le settimane in cui uno e' passato e l'altro no):
#    A) 2026.03.23 11:00 server -> 06:00 NY (+5) oppure 07:00 NY (+4).
#       23/03 e' DENTRO la finestra sfasata (8-29 marzo): shift ambiguo.
#    B) 2025.11.20 16:00 server -> 11:00 NY (+5). Il 20/11 i due
#       calendari sono gia' riallineati (USA 2/11, Europa 26/10):
#       niente ambiguita', ma il centro copre lo stesso il +4.
#    C) 2026.01.09 14:00 server -> 09:00 NY (+5). A gennaio NESSUNO dei
#       due e' in DST: shift +5 certo. E' il punto che rende C diverso
#       da A: qui il DST NON puo' entrarci, quindi se la diff e' grossa
#       la causa e' un'ALTRA (sessioni, barre marce). 09/01/2026 e'
#       un VENERDI', giorno di mercato normale.
#  Il CENTRO e' scelto in modo che la stampa barra-per-barra, che va da
#  -30 a +60 minuti dal centro (histdata_m1.py righe 717-718), copra
#  ENTRAMBE le candidate (+5 e +4): A -> 05:30-07:00, B -> 10:30-12:00,
#  C -> 08:30-10:00.
#
#  Atteso = ordine di grandezza [DERIVATO dagli atti], per non leggere
#  "e' tanto" o "e' poco" a occhio: diff max in punti / prezzo medio
#  confrontato (algebra del CSV d'import: prezzo = 100 x DiffMediaPunti
#  / DiffMediaPct, stesso periodo di sovrapposizione 2024-09 -> 2026-07).
# ---------------------------------------------------------------------
$Eventi = @(
  [pscustomobject]@{ Nome="A_20260323"; CentroNy="2026.03.23 06:00"; Ore=3; Server="2026.03.23 11:00";
                     Perche="diff max SIMULTANEA sui tre indici (72.856 pt NASUSD, 1.964 pt 225JPY, 18.615 pt SPXUSD -- import_ext_v2 19/08)";
                     Atteso="se e' movimento vero: range dell'ora ~3,1% su NASUSD, ~4,2% su 225JPY, ~2,9% su SPXUSD. DENTRO la finestra DST sfasata: l'ora giusta puo' essere 06:00 o 07:00 NY." },
  [pscustomobject]@{ Nome="B_20251120"; CentroNy="2025.11.20 11:00"; Ore=3; Server="2025.11.20 16:00";
                     Perche="diff max di NASUSD_EXT (60.221,8 pt) nei DUE import: v1 18/08 e 17 anni del 25/08";
                     Atteso="se e' movimento vero: range dell'ora ~2,5% su NASUSD (60.221,8 pt su ~2.375.000). Fuori dalle finestre DST: lo shift +5 e' certo." },
  [pscustomobject]@{ Nome="C_20260109"; CentroNy="2026.01.09 09:00"; Ore=3; Server="2026.01.09 14:00";
                     Perche="diff max di 225JPY_EXT nell'import v1 del 18/08 (1.526,5 pt) -- e cade FUORI dalle finestre DST, quindi il colpevole NON puo' essere il calendario: e' la pista SESSIONI (la malattia gia' vista sul GRXEUR, e la domanda D-F sulla strada del DAX)";
                     Atteso="se e' movimento vero: range dell'ora ~3,2% su 225JPY (1.526,5 pt su ~47.220). Ma l'ipotesi in testa qui e' la TERZA (sessione storta): guarda il CONTEGGIO delle barre per ora, non solo il range -- 60 attese, molte meno = il feed non copriva quell'ora." }
)

# ---------------------------------------------------------------------
#  ATTREZZI (i primi due copiati da RIGA_STORICO_INDICI.ps1, gia' girati
#  sul PC di Claudio il 25/08)
# ---------------------------------------------------------------------
function Ora(){ return (Get-Date).ToString("HH:mm:ss",$INV) }
function Dico($testo,$colore="Gray"){ Write-Host ("[" + (Ora) + "] " + $testo) -ForegroundColor $colore }
function Titolo($testo){ Write-Host ""; Write-Host ("=== " + $testo + " ===") -ForegroundColor Cyan }
function N2($valore){ return ([double]$valore).ToString("0.00",$INV) }
function N4($valore){ return ([double]$valore).ToString("0.0000",$INV) }

#  un numero NON MISURATO si scrive n/d, MAI 0.00: un numero plausibile
#  al posto di un buco e' il peggior refuso possibile (checklist 66)
function Num4($valore){
  if([double]$valore -lt 0){ return "n/d" }
  return (N4 $valore) + "%"
}
function Rap($diff,$vol){
  if([double]$vol -le 0){ return "n/d" }
  return (N2 ([double]$diff / [double]$vol))
}

#  un messaggio d'eccezione puo' essere su PIU' RIGHE: infilato dentro
#  una nota del referto spezza l'elenco e sembra un referto rotto.
function UnaRiga($testo){
  return (("" + $testo) -replace '[\r\n]+',' ')
}

#  L'ECO A SCHERMO DICE SEMPRE DI CHI E' IL NUMERO.
#  Il referto dello strumento e' a sezioni ("====== NASUSD (nsxusd) ======")
#  e le righe interessanti (TOTALE, BUCO, ...) non nominano il simbolo:
#  tre righe uguali di fila, e non si sa quale sia quale. Si porta
#  dietro l'intestazione di sezione (checklist 70: quello che Claudio
#  legge a schermo deve bastare a se stesso).
function EcoConSimbolo($file,$schema){
  $corrente = "?"
  foreach($linea in @(Get-Content -LiteralPath $file -ErrorAction SilentlyContinue)){
    $mS = [regex]::Match($linea,'^=+\s+(\S+)\s+\((\w+)\)\s+=+$')
    if($mS.Success){ $corrente = $mS.Groups[1].Value; continue }
    if($linea -match $schema){
      Write-Host ("      " + $corrente.PadRight(8) + $linea.Trim()) -ForegroundColor DarkGray
    }
  }
}

#  ################################################################
#  IL MESSAGGIO SBAGLIATO DELLO STRUMENTO, SMASCHERATO QUI.
#  Con il solo --estrai, histdata_m1.py prende la strada veloce e
#  legge SOLO la finestra chiesta (riga 857-864). Se in quella
#  finestra non c'e' NIENTE, `barre` e' vuoto e il codice cade nel
#  ramo generico che stampa:
#        "NESSUNA BARRA: manca <SYM>_M1.csv e non ci sono ZIP utili."
#  Cioe' accusa un FILE MANCANTE quando il file c'e' -- ed e'
#  proprio il caso che stiamo cercando: finestra vuota = BUCO DI
#  FEED = ipotesi 1 del par. 16.1. Chi legge quella frase conclude
#  "i dati non ci sono", riscarica, e la risposta buona resta sul
#  disco. Il driver lo sa, perche' il censimento ha gia' aperto quel
#  file: qui lo dice.
#  (Verificato ESEGUENDO su un banco con la finestra svuotata.)
#  ################################################################
function SmascheraVuote($fileReferto,$evNome){
  $out = New-Object System.Collections.ArrayList
  $corrente = "?"
  foreach($linea in @(Get-Content -LiteralPath $fileReferto -ErrorAction SilentlyContinue)){
    $mS = [regex]::Match($linea,'^=+\s+(\S+)\s+\((\w+)\)\s+=+$')
    if($mS.Success){ $corrente = $mS.Groups[1].Value; continue }
    #  -cmatch e ANCORATO a inizio riga, tutti e due obbligatori: in
    #  PowerShell -match e' CASE-INSENSITIVE, e in fondo al referto lo
    #  strumento elenca i problemi ("- NASUSD: nessuna barra da
    #  analizzare"). Senza ancora e senza -c quelle righe rientravano
    #  nel conto e venivano attribuite all'ULTIMO simbolo della
    #  scansione: tre righe fantasma tutte intestate a SPXUSD.
    #  (Visto ESEGUENDO, non rileggendo.)
    if($linea -cmatch '^ESITO'){ break }
    if($linea -cnotmatch '^NESSUNA BARRA'){ continue }
    $csvAtteso = ""
    foreach($sm in $Tavola){ if($sm.Bcm -eq $corrente){ $csvAtteso = Join-Path $sm.Cart ($sm.Bcm + "_M1.csv") } }
    if($csvAtteso -ne "" -and (Test-Path -LiteralPath $csvAtteso)){
      [void]$out.Add($evNome + " " + $corrente + ": FINESTRA VUOTA -- zero barre M1 nell'intervallo chiesto.")
      [void]$out.Add("      Lo strumento ha scritto 'manca " + $corrente + "_M1.csv': E' UN MESSAGGIO SBAGLIATO.")
      [void]$out.Add("      Il file C'E' (" + $csvAtteso + "): col solo --estrai lo strumento legge SOLO")
      [void]$out.Add("      la finestra, e quando la finestra e' vuota riusa il messaggio del file mancante.")
      [void]$out.Add("      LETTURA: IPOTESI 1 (buco di feed) CONFERMATA su questo simbolo, in quell'ora.")
    } else {
      [void]$out.Add($evNome + " " + $corrente + ": nessuna barra, e la fonte NON e' un CSV ma degli ZIP:")
      [void]$out.Add("      qui il messaggio dello strumento puo' essere vero. Guarda il log della chiamata.")
    }
  }
  return $out
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
#  NOME e la seconda sovrascrive la prima (checklist 26, riprodotto il
#  19/08). Percio': (a) si fotografa l'elenco PRIMA, (b) dopo si cerca
#  il nome NUOVO, (c) se non ce n'e' nessuno di nuovo si accetta un
#  nome gia' visto ma con LastWriteTime dopo l'inizio della chiamata
#  (= sovrascritto adesso), e lo si DICHIARA. Niente Sort-Object sulle
#  date: sui pari e' arbitrario (checklist 81).
function RefertoFresco($cartella,$prima,$inizio){
  $ris = [pscustomobject]@{ File=""; Stato="NESSUN REFERTO"; Nota="" }
  $tutti = @(Get-ChildItem -LiteralPath $cartella -Filter "referto_histdata_*.txt" -ErrorAction SilentlyContinue)
  $nuovi = @($tutti | Where-Object { $prima -notcontains $_.Name -and $_.LastWriteTime -ge $inizio })
  $sovr  = @($tutti | Where-Object { $prima -contains $_.Name -and $_.LastWriteTime -ge $inizio })
  $scelto = $null
  foreach($f in $nuovi){ if($null -eq $scelto -or $f.LastWriteTime -gt $scelto.LastWriteTime){ $scelto = $f } }
  if($null -eq $scelto){
    foreach($f in $sovr){ if($null -eq $scelto -or $f.LastWriteTime -gt $scelto.LastWriteTime){ $scelto = $f } }
    if($null -ne $scelto){ $ris.Nota = "il referto ha SOVRASCRITTO un file dello stesso minuto (nome " + $scelto.Name + "): il contenuto e' di adesso" }
  }
  if($null -eq $scelto){ return $ris }
  if($nuovi.Count + $sovr.Count -gt 1){
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

#  Le prime/ultime righe di un CSV, per dire CHE VINTAGE e' il file.
#  Un CSV di misura porta le date del DOMINIO, non la propria data di
#  produzione (checklist 78): qui si stampano tutte e due le cose, e la
#  data di produzione e' il LastWriteTime, DICHIARATO come tale.
function AnagraficaCsv($file){
  $ris = [pscustomobject]@{ Esiste=$false; MB=0.0; Scritto=""; Prima=""; Ultima=""; Formato="?"; Barre=0; RamMB=0.0 }
  if(-not (Test-Path -LiteralPath $file)){ return $ris }
  $it = Get-Item -LiteralPath $file
  $ris.Esiste  = $true
  $ris.MB      = [Math]::Round($it.Length / 1MB, 1)
  $ris.Scritto = $it.LastWriteTime.ToString("yyyy-MM-dd HH:mm",$INV)
  $testa = @(Get-Content -LiteralPath $file -TotalCount 4 -ErrorAction SilentlyContinue)
  #  BARRE E RAM STIMATE (non contate: contare 5 milioni di righe costa
  #  secondi e qui serve solo l'ORDINE DI GRANDEZZA). 690 byte di RAM
  #  per barra e' MISURATO sul parser vero (checklist 74, 25/08).
  #  Serve a beccare il caso brutto: se in questa cartella fosse finito
  #  il CSV da 17 anni (5,2 M barre) invece di quello da 7, la misura
  #  chiederebbe ~3,6 GB invece di ~1,7 e morirebbe di MemoryError DOPO
  #  la parte lunga.
  $lunghezze = @($testa | Where-Object { $_.Length -gt 0 } | ForEach-Object { $_.Length + 2 })
  if($lunghezze.Count -gt 0){
    $media = 0.0
    foreach($lu in $lunghezze){ $media = $media + $lu }
    $media = $media / $lunghezze.Count
    if($media -gt 0){
      $ris.Barre = [int]([Math]::Round($it.Length / $media))
      $ris.RamMB = [Math]::Round($ris.Barre * 690.0 / 1MB, 0)
    }
  }
  foreach($linea in $testa){
    if($linea -match '^\d{4}\.\d{2}\.\d{2} \d{2}:\d{2},'){ $ris.Formato = "FORMATO1"; if($ris.Prima -eq ""){ $ris.Prima = $linea } }
    elseif($linea -match '^\d{8} \d{6};'){ $ris.Formato = "HISTDATA_GREZZO"; if($ris.Prima -eq ""){ $ris.Prima = $linea } }
    elseif($linea -match '^Time,'){ if($ris.Formato -eq "?"){ $ris.Formato = "FORMATO1" } }
  }
  try{ $ris.Ultima = @(Get-Content -LiteralPath $file -Tail 1 -ErrorAction Stop)[0] }catch{ $ris.Ultima = "(coda non leggibile)" }
  return $ris
}

#  Una cartella e' una fonte ZIP per <pair> se contiene almeno uno zip
#  che si APRE e che ha dentro un CSV di quel pair. Il nome dello zip
#  NON basta: importa_storico_esterno.ps1 li chiama
#  HISTDATA_COM_ASCII_EURUSD_M1_2019.zip, histdata_m1.py li chiama
#  DAT_ASCII_NSXUSD_M1_2019.zip, e histdata_m1.py legge comunque il
#  nome del CSV DENTRO lo zip (funzione ingerisci_zip).
function ZipDelPair($cartella,$pair){
  $ris = [pscustomobject]@{ Quanti=0; Nota="" }
  if(-not (Test-Path -LiteralPath $cartella)){ $ris.Nota = "la cartella non esiste"; return $ris }
  $zips = @(Get-ChildItem -LiteralPath $cartella -Filter "*.zip" -ErrorAction SilentlyContinue)
  if($zips.Count -eq 0){ $ris.Nota = "nessuno zip nella cartella"; return $ris }
  $candidati = @($zips | Where-Object { $_.Name -match ("(?i)" + [regex]::Escape($pair)) })
  if($candidati.Count -eq 0){
    $ris.Nota = "" + $zips.Count + " zip, nessuno col nome di " + $pair
    return $ris
  }
  $apribili = 0
  $rotti    = 0
  foreach($z in $candidati){
    $arch = $null
    try{
      $arch = [System.IO.Compression.ZipFile]::OpenRead($z.FullName)
      $dentro = @($arch.Entries | Where-Object { $_.Name -match ("(?i)" + [regex]::Escape($pair)) -and $_.Name -match '(?i)\.csv$' })
      if($dentro.Count -gt 0){ $apribili++ }
    }catch{ $rotti++ }
    finally{ if($null -ne $arch){ try{ $arch.Dispose() }catch{ } } }
  }
  $ris.Quanti = $apribili
  $ris.Nota   = "" + $candidati.Count + " zip col nome giusto, " + $apribili + " con un CSV di " + $pair + " dentro"
  if($rotti -gt 0){ $ris.Nota = $ris.Nota + ", " + $rotti + " ILLEGGIBILI (histdata_m1.py li CANCELLERA')" }
  return $ris
}

# =====================================================================
#  P0. INTESTAZIONE E CARTELLE
# =====================================================================
Write-Host ""
Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host (" MISURE LAMPO DEL CANCELLO _EXT -- vol oraria + anatomia di " + $Eventi.Count + " eventi") -ForegroundColor Cyan
Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host (" pin        : " + $Pin)
Write-Host (" modo       : " + $(if($SoloControllo){ "GIRO A VUOTO (nessuna misura)" }else{ "CORSA VERA" }))
Write-Host (" indici da  : " + $CartellaIndici)
Write-Host (" forex da   : " + $CartellaForex)
Write-Host (" raccolta in: " + $Sosta)
Write-Host ""
Write-Host " NON firma niente: il cancello zero resta 0,05% e i tre _EXT restano" -ForegroundColor Yellow
Write-Host " in frigo. Qui si producono solo i numeri per decidere." -ForegroundColor Yellow
Write-Host " MT5 puo' restare aperto (qui non si scrive in MetaQuotes\Terminal)," -ForegroundColor Yellow
Write-Host " ma se sta girando un backtest la RAM e' contesa: vedi P0." -ForegroundColor Yellow

Remove-Item -LiteralPath $Sosta  -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -LiteralPath $ZipFin -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path $Sosta    | Out-Null
New-Item -ItemType Directory -Force -Path $SostaLog | Out-Null

#  La raccolta AUTOMATICA dello strumento (Desktop\histdata_m1 +
#  Desktop\histdata_m1.zip) si cancella PRIMA: histdata_m1.py la rifa'
#  a ogni chiamata in modo "w" (tronca), quindi alla fine conterrebbe
#  solo l'ULTIMA misura, e la sua stampa dice "ZIP PRONTO DA MANDARE".
#  Uno zip vecchio del 18/08 li' sopra e' il referto stantio pronto a
#  partire (checklist 23). Lo zip buono e' UNO SOLO ed e' il nostro.
$RaccoltaStrumento    = Join-Path $Desktop "histdata_m1"
$RaccoltaStrumentoZip = Join-Path $Desktop "histdata_m1.zip"
Remove-Item -LiteralPath $RaccoltaStrumento    -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -LiteralPath $RaccoltaStrumentoZip -Force -ErrorAction SilentlyContinue

Titolo "P0 - RAM LIBERA (cancello della fase vol, checklist 74)"
try{
  $os = Get-CimInstance -ClassName Win32_OperatingSystem -ErrorAction Stop
  $RamLibera = [double]$os.FreePhysicalMemory / 1024.0
  if($RamLibera -ge $MinRamMB){ $RamStato = "OK" } else { $RamStato = "SOTTO SOGLIA" }
  Dico ("RAM libera: " + (N2 $RamLibera) + " MB   (serve almeno " + $MinRamMB + " MB: ~690 byte a barra x 2,5 M barre)") $(if($RamStato -eq "OK"){ "Green" }else{ "Red" })
}catch{
  $RamStato = "NON MISURATA"
  [void]$Note.Add("P0: RAM libera NON MISURATA (" + (UnaRiga $_.Exception.Message) + "): la fase vol parte lo stesso, e se esce un MemoryError e' questo.")
  Dico "RAM libera: NON MISURATA (si prosegue e si dichiara)" "Yellow"
}
if($RamStato -eq "SOTTO SOGLIA"){
  Write-Host ""
  Write-Host ("!!! RAM LIBERA " + (N2 $RamLibera) + " MB, sotto -MinRamMB " + $MinRamMB + ".") -ForegroundColor Red
  Write-Host "    --vol-oraria carica TUTTE le barre del simbolo in memoria: cosi' finirebbe" -ForegroundColor Yellow
  Write-Host "    in MemoryError DOPO la parte lunga. Chiudi MT5/Chrome e rilancia la stessa riga." -ForegroundColor Yellow
  exit 2
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
#  P2. LO STRUMENTO AL PIN (checklist 6 e 8: cancella, scarica con
#      errore TERMINANTE, verifica il MARCATORE prima di eseguire)
# =====================================================================
Titolo "P2 - histdata_m1.py AL PIN + AUTOTEST"
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

$logAuto = Join-Path $SostaLog "autotest.log"
$rcAuto  = EseguiPython @("-u",$PyFile,"--autotest") $logAuto
$rigaAuto = @(Select-String -LiteralPath $logAuto -Pattern 'AUTOTEST: ' | ForEach-Object { $_.Line })
if($rcAuto -ne 0){
  Write-Host ("!!! AUTOTEST FALLITO (rc " + $rcAuto + "): NON si misura niente. Guarda " + $logAuto) -ForegroundColor Red
  if($rigaAuto.Count -gt 0){ Write-Host ("    " + $rigaAuto[0]) -ForegroundColor Yellow }
  exit 2
}
if($rigaAuto.Count -gt 0){ Dico ("autotest: " + $rigaAuto[0].Trim()) "Green" } else { Dico "autotest: rc 0" "Green" }

# =====================================================================
#  P3. CENSIMENTO DELLE FONTI -- il cuore della riga.
#      "I dati ci sono gia'" e' un'ASSUNZIONE finche' non si apre il
#      file: qui ogni simbolo esce con UNO di tre stati, e il motivo.
#      Nessun simbolo sparisce dall'elenco (regola di casa).
# =====================================================================
Titolo "P3 - CENSIMENTO DELLE FONTI (tre stati, niente assunzioni)"
try{ Add-Type -AssemblyName System.IO.Compression.FileSystem -ErrorAction Stop }catch{
  [void]$Note.Add("P3: System.IO.Compression.FileSystem non caricato (" + (UnaRiga $_.Exception.Message) + "): gli ZIP non si aprono per la verifica, si guarda solo il nome.")
}

$RigheCenso = New-Object System.Collections.ArrayList
[void]$RigheCenso.Add("CENSIMENTO DELLE FONTI -- misure lampo del cancello _EXT")
[void]$RigheCenso.Add("data: " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   <-- QUESTA DATA DEVE ESSERE DI ADESSO")
[void]$RigheCenso.Add("macchina: " + $env:COMPUTERNAME + "   utente: " + $env:USERNAME)
[void]$RigheCenso.Add("")

foreach($sm in $Tavola){
  [void]$RigheCenso.Add("--- " + $sm.Bcm + " (" + $sm.Hd + ") ---")
  $candidate = @()
  if($sm.Gruppo -eq "INDICI"){
    $candidate = @($CartellaIndici, $CartellaLunga)
  } else {
    $candidate = @($CartellaForex, $CartellaForexZip, $CartellaIndici)
  }
  $scelta = ""
  $comeF  = ""
  foreach($cart in $candidate){
    $csv = Join-Path $cart ($sm.Bcm + "_M1.csv")
    $an  = AnagraficaCsv $csv
    if($an.Esiste){
      [void]$RigheCenso.Add("  CSV  " + $csv)
      [void]$RigheCenso.Add("       " + $an.MB + " MB, scritto il " + $an.Scritto + ", formato " + $an.Formato)
      [void]$RigheCenso.Add("       barre STIMATE " + $an.Barre + " -> RAM stimata per --vol-oraria ~" + $an.RamMB + " MB (690 byte/barra, misurati)")
      [void]$RigheCenso.Add("       prima riga di dati: " + $an.Prima)
      [void]$RigheCenso.Add("       ultima riga       : " + $an.Ultima)
      if($an.Formato -eq "FORMATO1"){
        if($scelta -eq ""){
          $scelta = $cart; $comeF = "CSV Formato1 in " + $cart
          if($RamLibera -gt 0 -and $an.RamMB -gt $RamLibera){
            [void]$Problemi.Add("P4 (previsto in P3): " + $sm.Bcm + ": il CSV scelto (" + $an.MB + " MB, ~" + $an.Barre +
                                " barre) chiedera' circa " + $an.RamMB + " MB di RAM e ne sono liberi " + (N2 $RamLibera) +
                                ". La vol oraria puo' morire di MemoryError DOPO la parte lunga: chiudi qualcosa e rilancia.")
            [void]$RigheCenso.Add("       -> ATTENZIONE: RAM stimata " + $an.RamMB + " MB > RAM libera " + (N2 $RamLibera) + " MB")
          }
        } else {
          #  UNA SECONDA COPIA LEGGIBILE NON SI TACE. Su NASUSD ce ne
          #  sono DUE: quella del 18/08 (2019-2026, 2,5 M barre) e
          #  quella del 25/08 (2010-2026, 5,2 M barre). Si misura la
          #  PRIMA, e il motivo va scritto: (a) il perimetro del
          #  confronto col nativo BCM parte dal 26/09/2024, quindi gli
          #  anni 2010-2018 non c'entrano; (b) 5,2 M barre sarebbero
          #  ~3,6 GB di RAM contro ~1,7 GB (checklist 74).
          [void]$RigheCenso.Add("       -> C'E' ANCHE QUESTA, e NON e' quella misurata (si usa " + $scelta + ").")
          [void]$Note.Add("P3: " + $sm.Bcm + ": esiste una SECONDA copia leggibile in " + $cart + " (" + $an.MB + " MB, prima riga " + $an.Prima.Substring(0,[Math]::Min(16,$an.Prima.Length)) + "). NON e' quella misurata: si e' usata " + $scelta + ", perche' il confronto col nativo BCM esiste solo dal 26/09/2024 e perche' il file piu' corto costa meta' RAM.")
        }
      } elseif($an.Formato -eq "HISTDATA_GREZZO"){
        [void]$RigheCenso.Add("       -> NON LEGGIBILE da histdata_m1.py: e' il formato HistData grezzo")
        [void]$RigheCenso.Add("          ('AAAAMMGG HHMMSS;o;h;l;c;v', separatore ';'). leggi_csv_formato1")
        [void]$RigheCenso.Add("          splitta sulle VIRGOLE e scarta ogni riga: uscirebbe 'NESSUNA BARRA'")
        [void]$RigheCenso.Add("          con un messaggio che dice che il file MANCA. Si usano gli ZIP.")
        [void]$Note.Add("P3: " + $sm.Bcm + ": " + $csv + " esiste ma e' in formato HistData grezzo (lo scrive importa_storico_esterno.ps1): NON e' una fonte per questo strumento.")
      } else {
        [void]$RigheCenso.Add("       -> formato NON RICONOSCIUTO: non si usa.")
      }
    } else {
      [void]$RigheCenso.Add("  CSV  " + $csv + "   ASSENTE")
    }
    $zp = ZipDelPair $cart $sm.Hd
    [void]$RigheCenso.Add("  ZIP  " + $cart + "   " + $zp.Nota)
    if($zp.Quanti -gt 0 -and $scelta -eq ""){ $scelta = $cart; $comeF = "" + $zp.Quanti + " ZIP in " + $cart }
    if($zp.Nota -match 'ILLEGGIBIL'){
      [void]$Problemi.Add("P3: in " + $cart + " ci sono ZIP illeggibili col nome di " + $sm.Hd + ": se la misura li ingerisce, histdata_m1.py LI CANCELLA (per progetto). Vanno riscaricati quando serviranno.")
    }
  }
  if($scelta -ne ""){
    $sm.Cart  = $scelta
    $sm.Fonte = $comeF
    $sm.Stato = "MISURABILE"
    [void]$RigheCenso.Add("  => MISURABILE: " + $comeF)
    Dico ($sm.Bcm.PadRight(8) + "MISURABILE   " + $comeF) "Green"
  } else {
    $sm.Stato = "NON MISURABILE STASERA"
    $sm.Fonte = "nessuna fonte leggibile fra: " + ($candidate -join " ; ")
    [void]$RigheCenso.Add("  => NON MISURABILE STASERA: nessuna fonte leggibile.")
    [void]$Problemi.Add("P3: " + $sm.Bcm + " NON MISURABILE STASERA: " + $sm.Fonte)
    Dico ($sm.Bcm.PadRight(8) + "NON MISURABILE STASERA") "Red"
  }
  [void]$RigheCenso.Add("")
}
Set-Content -LiteralPath $Censo -Encoding ASCII -Value $RigheCenso
[void]$Attesi.Add("CENSIMENTO_FONTI.txt")
#  il referto entra nell'elenco degli ATTESI SUBITO, anche se sara'
#  l'ultimo file scritto: un elenco che non nomina il pezzo piu'
#  importante e' un elenco che nessuno puo' usare per controllare.
[void]$Attesi.Add("REFERTO_MISURE_LAMPO.txt")

if($SoloControllo){
  Write-Host ""
  Write-Host "GIRO A VUOTO: qui la corsa vera comincerebbe a misurare. Mi fermo." -ForegroundColor Cyan
  Write-Host ("Censimento scritto in: " + $Censo) -ForegroundColor Cyan
  $mancano = @($Tavola | Where-Object { $_.Stato -ne "MISURABILE" })
  Write-Host ("Simboli misurabili: " + (@($Tavola | Where-Object { $_.Stato -eq "MISURABILE" }).Count) + " su " + $Tavola.Count) -ForegroundColor $(if($mancano.Count -eq 0){ "Green" }else{ "Yellow" })
  foreach($sm in $mancano){ Write-Host ("   NON MISURABILE: " + $sm.Bcm + " -- " + $sm.Fonte) -ForegroundColor Yellow }
  #  IL GIRO A VUOTO NON ESCE 0 SE UN PEZZO E' FALLITO (checklist 14), e
  #  i rilievi si stampano QUI, non solo dentro il file: un problema che
  #  vive in un file che nessuno apre e' un problema che non esiste.
  foreach($prob in $Problemi){ Write-Host ("   RILIEVO: " + $prob) -ForegroundColor Yellow }
  foreach($nota in $Note){ Write-Host ("   nota: " + $nota) -ForegroundColor DarkGray }
  if($mancano.Count -gt 0 -or $Problemi.Count -gt 0){ exit 1 }
  exit 0
}

# =====================================================================
#  P4. --vol-oraria. Una chiamata per CARTELLA, e il referto va SUBITO
#      in sosta con un nome PROPRIO (checklist 26: la seconda chiamata
#      sovrascrive la prima, gia' riprodotto il 19/08).
# =====================================================================
Titolo "P4 - VOLATILITA' ORARIA (la misura che sostituisce le bande [INFERITO])"
$VolFatte = New-Object System.Collections.ArrayList
$gruppi = New-Object System.Collections.ArrayList
foreach($sm in $Tavola){
  if($sm.Stato -ne "MISURABILE"){ continue }
  $trovato = $null
  foreach($gr in $gruppi){ if($gr.Cart -eq $sm.Cart){ $trovato = $gr } }
  if($null -eq $trovato){
    $trovato = [pscustomobject]@{ Cart=$sm.Cart; Pairs=New-Object System.Collections.ArrayList }
    [void]$gruppi.Add($trovato)
  }
  [void]$trovato.Pairs.Add($sm.Hd)
}
foreach($gr in $gruppi){
  $lista = ($gr.Pairs -join ",")
  $nomeFile = "vol_" + ($gr.Pairs -join "-") + ".txt"
  $logv = Join-Path $SostaLog ("vol_" + ($gr.Pairs -join "-") + ".log")
  Dico ("misuro la vol oraria di " + $lista + " da " + $gr.Cart + " (~25 s a simbolo; la RAM stimata sta nel censimento, un simbolo per volta)") "Gray"
  $prima  = @(Get-ChildItem -LiteralPath $gr.Cart -Filter "referto_histdata_*.txt" -ErrorAction SilentlyContinue | ForEach-Object { $_.Name })
  $inizio = Get-Date
  $rcv = EseguiPython @("-u",$PyFile,"--vol-oraria","--simboli",$lista,"--cartella",$gr.Cart) $logv
  $rf  = RefertoFresco $gr.Cart $prima $inizio
  if($rf.Stato -ne "OK"){
    [void]$Problemi.Add("P4: " + $lista + ": NESSUN REFERTO scritto adesso in " + $gr.Cart + " (rc " + $rcv + "). Guarda log\" + (Split-Path -Leaf $logv))
    Dico ("   NESSUN REFERTO: rc " + $rcv) "Red"
    continue
  }
  if($rf.Nota -ne ""){ [void]$Note.Add("P4: " + $lista + ": " + $rf.Nota) }
  [void](CopiaVerificata $rf.File (Join-Path $Sosta $nomeFile))
  [void]$Attesi.Add($nomeFile)
  [void]$VolFatte.Add((Join-Path $Sosta $nomeFile))
  if($rcv -ne 0){
    [void]$Problemi.Add("P4: " + $lista + ": lo strumento e' uscito con " + $rcv + " (un simbolo senza barre?). Il referto c'e' e i simboli riusciti sono dentro.")
    Dico ("   rc " + $rcv + " -- referto raccolto lo stesso: " + $nomeFile) "Yellow"
  } else {
    Dico ("   OK -> " + $nomeFile) "Green"
  }
  EcoConSimbolo (Join-Path $Sosta $nomeFile) '^\s*(TOTALE: media|NESSUNA BARRA)'
}

# =====================================================================
#  P5. --estrai dei TRE eventi.
#      Attenzione: una FINESTRA VUOTA e' l'ipotesi 1 (buco di feed),
#      cioe' UNA RISPOSTA, e lo strumento la conta come problema e esce
#      1. Qui NON si muore su quel codice: si raccoglie e si dichiara
#      (checklist 26-bis).
# =====================================================================
Titolo ("P5 - ANATOMIA DEGLI EVENTI: " + $Eventi.Count + " (le barre M1 intorno alla diff max)")
$IndiciOk = @($Tavola | Where-Object { $_.Gruppo -eq "INDICI" -and $_.Stato -eq "MISURABILE" })
if($IndiciOk.Count -eq 0){
  [void]$Problemi.Add("P5: nessun indice misurabile: l'anatomia degli eventi NON e' stata fatta.")
  Dico "nessun indice misurabile: salto tutti e due gli eventi." "Red"
} else {
  foreach($ev in $Eventi){
    $gruppiEv = New-Object System.Collections.ArrayList
    foreach($sm in $IndiciOk){
      $trovato = $null
      foreach($gr in $gruppiEv){ if($gr.Cart -eq $sm.Cart){ $trovato = $gr } }
      if($null -eq $trovato){
        $trovato = [pscustomobject]@{ Cart=$sm.Cart; Pairs=New-Object System.Collections.ArrayList }
        [void]$gruppiEv.Add($trovato)
      }
      [void]$trovato.Pairs.Add($sm.Hd)
    }
    foreach($gr in $gruppiEv){
      $lista = ($gr.Pairs -join ",")
      $nomeFile = "estrai_" + $ev.Nome + "_" + ($gr.Pairs -join "-") + ".txt"
      $logEv = Join-Path $SostaLog ("estrai_" + $ev.Nome + ".log")
      Dico ("evento " + $ev.Nome + ": centro " + $ev.CentroNy + " NY (= " + $ev.Server + " server), +/- " + $ev.Ore + " ore, su " + $lista) "Gray"
      $prima  = @(Get-ChildItem -LiteralPath $gr.Cart -Filter "referto_histdata_*.txt" -ErrorAction SilentlyContinue | ForEach-Object { $_.Name })
      $inizio = Get-Date
      $rce = EseguiPython @("-u",$PyFile,"--estrai",$ev.CentroNy,"--ore",("" + $ev.Ore),"--simboli",$lista,"--cartella",$gr.Cart) $logEv
      $rf  = RefertoFresco $gr.Cart $prima $inizio
      if($rf.Stato -ne "OK"){
        [void]$Problemi.Add("P5: evento " + $ev.Nome + ": NESSUN REFERTO scritto adesso in " + $gr.Cart + " (rc " + $rce + "). Guarda log\" + (Split-Path -Leaf $logEv))
        Dico ("   NESSUN REFERTO: rc " + $rce) "Red"
        continue
      }
      if($rf.Nota -ne ""){ [void]$Note.Add("P5: evento " + $ev.Nome + ": " + $rf.Nota) }
      [void](CopiaVerificata $rf.File (Join-Path $Sosta $nomeFile))
      [void]$Attesi.Add($nomeFile)
      if($rce -ne 0){
        [void]$Note.Add("P5: evento " + $ev.Nome + ": rc " + $rce + " = almeno un simbolo NON HA BARRE nella finestra. NON e' un guasto: e' l'ipotesi 1 (buco di feed) confermata. Il referto e' dentro lo zip.")
        Dico ("   rc " + $rce + " -> FINESTRA VUOTA su almeno un simbolo: E' GIA' UNA RISPOSTA. Raccolto: " + $nomeFile) "Yellow"
      } else {
        Dico ("   OK -> " + $nomeFile) "Green"
      }
      EcoConSimbolo (Join-Path $Sosta $nomeFile) '^\s*(NESSUNA BARRA|buchi > 1 min|BUCO|salto massimo)'
      #  @( ) obbligatorio: una funzione che torna UNA riga sola, senza,
      #  si srotola in una stringa e il foreach gira sui CARATTERI
      #  (checklist 62).
      foreach($linea in @(SmascheraVuote (Join-Path $Sosta $nomeFile) $ev.Nome)){
        [void]$Lettura.Add($linea)
        Write-Host ("      " + $linea) -ForegroundColor Yellow
      }
    }
  }
}

# =====================================================================
#  P6. LA TABELLA DEI RAPPORTI.
#      I numeri si leggono DAL REFERTO dello strumento, con cultura
#      INVARIANTE (su it-IT "0.0662" letto senza InvariantCulture fa
#      662: checklist 5). Dove il numero non esce si scrive n/d, mai
#      uno zero plausibile (checklist 66).
#      PERIMETRO (checklist 28): la diff agli atti e' misurata SOLO
#      dove il nativo BCM ha barre, cioe' dal 26/09/2024 in poi. La
#      colonna che conta e' quindi quella del 2025 (l'unico anno intero
#      dentro il periodo di confronto), non il TOTALE della finestra
#      del CSV, che comprende anni in cui il confronto non esiste.
# =====================================================================
Titolo "P6 - RAPPORTO diff / volatilita' oraria"
foreach($volFile in $VolFatte){
  $corrente = ""
  foreach($linea in @(Get-Content -LiteralPath $volFile -ErrorAction SilentlyContinue)){
    $mS = [regex]::Match($linea,'^=+\s+(\S+)\s+\((\w+)\)\s+=+$')
    if($mS.Success){ $corrente = $mS.Groups[1].Value; continue }
    if($corrente -eq ""){ continue }
    $mA = [regex]::Match($linea,'^\s+(\d{4}): media ([0-9]+\.[0-9]+)%\s+\(su (\d+) ore\)')
    if($mA.Success){
      foreach($sm in $Tavola){
        if($sm.Bcm -ne $corrente){ continue }
        $sm.VolAnni = $sm.VolAnni + " " + $mA.Groups[1].Value + "=" + $mA.Groups[2].Value
        if($mA.Groups[1].Value -eq "2025"){
          $sm.Vol2025 = [double]::Parse($mA.Groups[2].Value,[Globalization.NumberStyles]::Float,$INV)
        }
      }
      continue
    }
    $mT = [regex]::Match($linea,'^\s+TOTALE: media ([0-9]+\.[0-9]+)%\s+mediana')
    if($mT.Success){
      foreach($sm in $Tavola){
        if($sm.Bcm -ne $corrente){ continue }
        $sm.VolTot = [double]::Parse($mT.Groups[1].Value,[Globalization.NumberStyles]::Float,$INV)
      }
    }
  }
}
foreach($sm in $Tavola){
  if($sm.Stato -eq "MISURABILE" -and $sm.VolTot -lt 0){
    [void]$Problemi.Add("P6: " + $sm.Bcm + ": la vol oraria NON e' stata letta dal referto (formato cambiato? simbolo senza barre?). Resta n/d: NON si inventa un numero.")
  }
  if($sm.Stato -eq "MISURABILE" -and $sm.VolTot -ge 0 -and $sm.Vol2025 -lt 0){
    [void]$Note.Add("P6: " + $sm.Bcm + ": nel referto non c'e' la riga dell'anno 2025 (il CSV non copre quell'anno?): il rapporto sul perimetro del confronto resta n/d.")
  }
}

$Intestazione = ("{0,-8} {1,-10} {2,-12} {3,-12} {4,-10} {5,-10} {6}" -f "SIM","diff atti","vol TOTALE","vol 2025","rap/TOT","rap/2025","metro 0,20 x vol (SOLO INFORMATIVO)")
$RigheTab = New-Object System.Collections.ArrayList
[void]$RigheTab.Add($Intestazione)
foreach($sm in $Tavola){
  $verdetto = "n/d"
  if($sm.Vol2025 -gt 0){
    $r = [double]$sm.DiffAtti / [double]$sm.Vol2025
    if($r -le 0.20){ $verdetto = "sotto 0,20" } else { $verdetto = "SOPRA 0,20" }
  } elseif($sm.VolTot -gt 0){
    $r = [double]$sm.DiffAtti / [double]$sm.VolTot
    if($r -le 0.20){ $verdetto = "sotto 0,20 (su TOTALE)" } else { $verdetto = "SOPRA 0,20 (su TOTALE)" }
  }
  [void]$RigheTab.Add(("{0,-8} {1,-10} {2,-12} {3,-12} {4,-10} {5,-10} {6}" -f `
    $sm.Bcm, ((N4 $sm.DiffAtti) + "%"), (Num4 $sm.VolTot), (Num4 $sm.Vol2025), `
    (Rap $sm.DiffAtti $sm.VolTot), (Rap $sm.DiffAtti $sm.Vol2025), $verdetto))
}
foreach($linea in $RigheTab){ Write-Host ("  " + $linea) }

# =====================================================================
#  P7. REFERTO + ZIP + ELENCO ATTESI CONFRONTATO COI TROVATI
#      (checklist 70: l'elenco non si scrive a mano nel foglio, lo
#      produce e lo confronta il codice)
# =====================================================================
Titolo "P7 - REFERTO E RACCOLTA"
[void]$RefRighe.Add("=====================================================================")
[void]$RefRighe.Add(" REFERTO -- MISURE LAMPO DEL CANCELLO ZERO _EXT")
[void]$RefRighe.Add("=====================================================================")
[void]$RefRighe.Add("data: " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   <-- QUESTA DATA DEVE ESSERE DI ADESSO")
[void]$RefRighe.Add("avvio: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   durata: " + (N2 ((New-TimeSpan -Start $Avvio -End (Get-Date)).TotalMinutes)) + " min")
[void]$RefRighe.Add("macchina: " + $env:COMPUTERNAME + "   utente: " + $env:USERNAME)
[void]$RefRighe.Add("pin: " + $Pin)
[void]$RefRighe.Add("strumento: histdata_m1.py HD-M1-v4 (scaricato al pin, autotest 11/11)")
[void]$RefRighe.Add("python: " + $Python + "  " + $PyVers)
[void]$RefRighe.Add("RAM libera all'avvio: " + $(if($RamLibera -lt 0){ "NON MISURATA" }else{ (N2 $RamLibera) + " MB" }) + " (soglia " + $MinRamMB + " MB)")
[void]$RefRighe.Add("")
[void]$RefRighe.Add("!!! QUESTA CORSA NON FIRMA NIENTE. Il cancello zero resta 0,05% e i")
[void]$RefRighe.Add("    tre indici _EXT restano IN FRIGO. Qui ci sono i numeri che")
[void]$RefRighe.Add("    servono a decidere fra metro assoluto e metro relativo, e basta.")
[void]$RefRighe.Add("")
[void]$RefRighe.Add("!!! I DATI SONO DI HISTDATA, NON DI BCM. La vol misurata qui e' quella")
[void]$RefRighe.Add("    del feed esterno: sul periodo comune i due feed hanno per")
[void]$RefRighe.Add("    definizione range simili, ma il numero NON e' BCM. Dichiarato.")
[void]$RefRighe.Add("")
[void]$RefRighe.Add("--- LE FONTI, SIMBOLO PER SIMBOLO (nessuno sparisce) ---")
foreach($sm in $Tavola){
  [void]$RefRighe.Add(("  {0,-8} {1,-24} {2}" -f $sm.Bcm, $sm.Stato, $sm.Fonte))
}
[void]$RefRighe.Add("")
[void]$RefRighe.Add("--- MISURA 1: VOLATILITA' ORARIA (range H1 medio, % del prezzo) ---")
[void]$RefRighe.Add("  Il perimetro della diff agli atti e' il PERIODO IN CUI IL NATIVO BCM")
[void]$RefRighe.Add("  ESISTE: dal 26/09/2024 in poi. Percio' la colonna da leggere e'")
[void]$RefRighe.Add("  'vol 2025' (l'unico anno intero dentro quel periodo). Il TOTALE e'")
[void]$RefRighe.Add("  su tutta la finestra del CSV e comprende anni in cui il confronto")
[void]$RefRighe.Add("  col nativo non esiste: si stampa per contesto, non per decidere.")
[void]$RefRighe.Add("")
foreach($linea in $RigheTab){ [void]$RefRighe.Add("  " + $linea) }
[void]$RefRighe.Add("")
[void]$RefRighe.Add("  ATTENZIONE AL PERIMETRO, e' diverso fra indici e forex:")
[void]$RefRighe.Add("   - i tre INDICI: il nativo BCM parte dal 26/09/2024, quindi la diff")
[void]$RefRighe.Add("     agli atti e' misurata solo li' -> si legge 'rap/2025'.")
[void]$RefRighe.Add("   - EURUSD: il nativo BCM copre tutto il periodo importato, quindi la")
[void]$RefRighe.Add("     sua diff e' su tutto -> per lui il numero coerente e' 'rap/TOT'.")
[void]$RefRighe.Add("  n/d = NON MISURATO (mai uno zero al posto di un buco).")
[void]$RefRighe.Add("  La colonna 'metro 0,20' e' SOLO INFORMATIVA: la soglia 0,20 x vol e'")
[void]$RefRighe.Add("  una PROPOSTA (REFERTO_HISTDATA par. 16.2), non un criterio firmato.")
[void]$RefRighe.Add("")
[void]$RefRighe.Add("  vol per anno, come letta dal referto dello strumento:")
foreach($sm in $Tavola){
  if($sm.VolAnni -ne ""){ [void]$RefRighe.Add("    " + $sm.Bcm + ":" + $sm.VolAnni) }
}
[void]$RefRighe.Add("")
[void]$RefRighe.Add("--- MISURA 2: ANATOMIA DEGLI EVENTI (" + $Eventi.Count + ") ---")
foreach($ev in $Eventi){
  [void]$RefRighe.Add("  " + $ev.Nome + "  centro " + $ev.CentroNy + " (ora NY, come e' scritta nel CSV)")
  [void]$RefRighe.Add("            = " + $ev.Server + " ORA SERVER, +/- " + $ev.Ore + " ore")
  [void]$RefRighe.Add("            perche': " + $ev.Perche)
  [void]$RefRighe.Add("            atteso : " + $ev.Atteso)
}
[void]$RefRighe.Add("")
[void]$RefRighe.Add("  COME SI LEGGE (le tre ipotesi del par. 16.1, scritte PRIMA di guardare):")
[void]$RefRighe.Add("   1. BUCO DI FEED: nel riquadro 'buchi > 1 min' compare un buco che")
[void]$RefRighe.Add("      copre l'ora dell'evento, o la finestra e' VUOTA -> il confronto")
[void]$RefRighe.Add("      metteva a fronte ore diverse. E' l'ipotesi principale.")
[void]$RefRighe.Add("   2. EVENTO VERO: le barre ci sono tutte e il range dell'ora e' del")
[void]$RefRighe.Add("      2-4% -> il movimento e' reale e la diff nasce solo dall'ora di")
[void]$RefRighe.Add("      disallineamento durante il botto. Si conferma sul grafico BCM.")
[void]$RefRighe.Add("   3. SESSIONE STORTA: barre presenti ma il conteggio orario e' molto")
[void]$RefRighe.Add("      sotto le 60 attese, o le ore intorno sono asimmetriche.")
[void]$RefRighe.Add("  E c'e' una DOMANDA IN PIU', che l'evento C serve a decidere:")
[void]$RefRighe.Add("   A cade DENTRO una finestra DST sfasata, C cade FUORI e in un mese in")
[void]$RefRighe.Add("   cui nessuno dei due calendari e' in ora legale. Se anche C e' malato,")
[void]$RefRighe.Add("   il DST NON E' LA CAUSA (o non e' l'unica) e la pista giusta e' quella")
[void]$RefRighe.Add("   delle SESSIONI del feed -- la stessa malattia che ha bocciato GRXEUR,")
[void]$RefRighe.Add("   cioe' la domanda D-F sulla strada del DAX. Se invece C e' sano, il")
[void]$RefRighe.Add("   sospetto torna tutto sul calendario.")
[void]$RefRighe.Add("")
[void]$RefRighe.Add("  LETTURA GIA' FATTA DAL DRIVER (dove ha potuto):")
if($Lettura.Count -eq 0){ [void]$RefRighe.Add("    nessuna finestra vuota: le barre ci sono su tutti i simboli chiesti.") }
foreach($linea in $Lettura){ [void]$RefRighe.Add("    " + $linea) }
[void]$RefRighe.Add("")
[void]$RefRighe.Add("  L'ordine di grandezza atteso [DERIVATO dagli atti] sta scritto qui")
[void]$RefRighe.Add("  sopra, riga 'atteso' di OGNI evento: e' li' e non in questa prosa")
[void]$RefRighe.Add("  apposta, cosi' un evento aggiunto domani porta con se' il suo numero.")
[void]$RefRighe.Add("")
[void]$RefRighe.Add("--- QUELLO CHE QUESTA CORSA NON PUO' DIRE ---")
[void]$RefRighe.Add("  Qui si vede UN SOLO FEED: HistData. Se le barre esterne sono sane,")
[void]$RefRighe.Add("  il colpevole puo' essere il NATIVO BCM, e quello si guarda solo sui")
[void]$RefRighe.Add("  grafici (par. 16.1: H1 di NASUSD/225JPY/SPXUSD e dei tre _EXT, barre")
[void]$RefRighe.Add("  10:00-11:00-12:00 SERVER del giorno dell'evento, Ctrl+D).")
[void]$RefRighe.Add("")

#  i nomi dei file sono UNICI, quindi Sort-Object qui non ha pari da
#  riordinare (checklist 81): l'ordine e' deterministico.
$TrovatiOra = @(@(Get-ChildItem -LiteralPath $Sosta -File -ErrorAction SilentlyContinue | ForEach-Object { $_.Name }) + @("REFERTO_MISURE_LAMPO.txt") | Sort-Object)
$QuantiLog  = @(Get-ChildItem -LiteralPath $SostaLog -File -ErrorAction SilentlyContinue).Count
[void]$RefRighe.Add("--- FILE ATTESI E FILE TROVATI ---")
[void]$RefRighe.Add("  attesi : " + (($Attesi | Sort-Object) -join ", "))
[void]$RefRighe.Add("  trovati: " + ($TrovatiOra -join ", "))
[void]$RefRighe.Add("           (+ la cartella log\ con " + $QuantiLog + " file: l'uscita cruda di ogni chiamata a python)")
[void]$RefRighe.Add("           REFERTO_MISURE_LAMPO.txt e' l'ULTIMO file scritto: se stai leggendo questa riga, c'e'.")
[void]$RefRighe.Add("  Il controllo di COSA C'E' DENTRO LO ZIP viene dopo questo referto (lo")
[void]$RefRighe.Add("  zip contiene il referto, quindi non puo' stare qui): e' stampato a")
[void]$RefRighe.Add("  schermo come 'contenuto dello zip verificato: N file'.")
$Mancanti = @($Attesi | Where-Object { $TrovatiOra -notcontains $_ })
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

$MisurabiliN = @($Tavola | Where-Object { $_.Stato -eq "MISURABILE" }).Count
$MisuratiN   = @($Tavola | Where-Object { $_.VolTot -ge 0 }).Count
if($Problemi.Count -gt 0){
  $Uscita = 1
  [void]$RefRighe.Add("ESITO: PARZIALE -- " + $Problemi.Count + " problemi (vol misurata su " + $MisuratiN + " simboli su " + $Tavola.Count + ")")
  [void]$RefRighe.Add("       'non misurabile' E' GIA' UNA RISPOSTA: questo referto va mandato lo stesso.")
} else {
  $Uscita = 0
  [void]$RefRighe.Add("ESITO: OK -- vol misurata su " + $MisuratiN + " simboli su " + $Tavola.Count + " (misurabili " + $MisurabiliN + ")")
}
Set-Content -LiteralPath $Referto -Encoding ASCII -Value $RefRighe

Compress-Archive -Path (Join-Path $Sosta "*") -DestinationPath $ZipFin -Force
#  LO ZIP SI CONTROLLA DENTRO, non sull'esistenza del nome (checklist
#  27-ter). Se manca un pezzo si vede ADESSO, non quando Claudio l'ha
#  gia' mandato in chat.
$DentroZip = @()
if(Test-Path -LiteralPath $ZipFin){
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
  $FuoriZip = @($Attesi | Where-Object { $DentroZip -notcontains $_ })
  if($DentroZip.Count -eq 0){
    Write-Host "ATTENZIONE: contenuto dello zip NON verificato (vedi NOTE del referto)." -ForegroundColor Yellow
  } elseif($FuoriZip.Count -gt 0){
    Write-Host ("!!! NELLO ZIP MANCANO: " + ($FuoriZip -join ", ") + " -- manda anche la CARTELLA " + $Sosta) -ForegroundColor Red
    $Uscita = 1
  } else {
    Write-Host ("contenuto dello zip verificato: " + $DentroZip.Count + " file, ci sono tutti gli attesi.") -ForegroundColor Green
  }
  #  la raccolta automatica dello strumento si toglie di mezzo SOLO dopo
  #  che il nostro zip esiste: due zip sul Desktop, uno solo dei quali
  #  buono, e' esattamente il modo di far mandare il file sbagliato.
  Remove-Item -LiteralPath $RaccoltaStrumento    -Recurse -Force -ErrorAction SilentlyContinue
  Remove-Item -LiteralPath $RaccoltaStrumentoZip -Force -ErrorAction SilentlyContinue
  if(Test-Path -LiteralPath $RaccoltaStrumentoZip){
    [void]$Note.Add("P7: Desktop\histdata_m1.zip non si e' lasciato cancellare: NON e' quello da mandare.")
    Write-Host "ATTENZIONE: sul Desktop e' rimasto anche histdata_m1.zip (dello strumento): NON e' quello da mandare." -ForegroundColor Yellow
  }
}

Write-Host ""
Write-Host ("REFERTO: " + $Referto) -ForegroundColor Cyan
Write-Host ("ZIP DA MANDARE IN CHAT: " + $ZipFin) -ForegroundColor Cyan
Write-Host "ELENCO FILE ATTESI (prodotto dal codice, non scritto a mano):" -ForegroundColor Cyan
foreach($att in ($Attesi | Sort-Object)){ Write-Host ("   " + $att) }
Write-Host ""
if($Problemi.Count -gt 0){
  Write-Host ("ESITO: PARZIALE -- " + $Problemi.Count + " problemi. IL REFERTO VA MANDATO LO STESSO:") -ForegroundColor Yellow
  foreach($prob in $Problemi){ Write-Host ("   - " + $prob) -ForegroundColor Yellow }
} else {
  Write-Host "ESITO: OK" -ForegroundColor Green
}
Write-Host ("Nel referto, la riga 'data:' deve dire " + (Get-Date).ToString("yyyy-MM-dd HH:mm",$INV) + " circa: se dice altro, stai guardando un file vecchio.") -ForegroundColor Cyan
exit $Uscita
