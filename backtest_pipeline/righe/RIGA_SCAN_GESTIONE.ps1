# =====================================================================
#  MARCATORE_RIGA_SCAN_GESTIONE_v1
#  RIGA_SCAN_GESTIONE.ps1 -- lo STUDIO DELLA GESTIONE sul terminale da
#  backtest, con le guardie di RIGA_ROUND_VPS.ps1 (non reinventate).
# ---------------------------------------------------------------------
#  PERCHE' ESISTE (09/09/2026)
#  scan_gestione.ps1 e' scritto dal 14/08 e NON E' MAI STATO LANCIATO
#  (audit delle uscite, report\AUDIT_USCITE_2026-09-09.md). Ma e' del
#  tempo in cui c'era UN SOLO MT5: lanciato oggi sul VPS avrebbe
#  ricompilato l'EA dentro la cartella del PICCOLO (50503392), che ha le
#  sedie VIVE. La v2 dello script chiude quel buco alla radice; questa
#  riga aggiunge il resto del cinturone gia' collaudato:
#    - LA GUARDIA POSITIVA sul bersaglio (11/09/2026): non elenca i
#      vietati, AMMETTE il solo banco C:\MT5_Backtest (demo 50504400) e
#      uccide tutto il resto -- il piccolo 50503392, il 100k 50504263, il
#      REALE 10105439, la radice di un disco, i nomi 8.3 e la fuga col
#      '..'. E' la copia dichiarata di quella di RIGA_ROUND_VPS.ps1;
#    - censimento PID PRIMA e DOPO, con allarme rosso se sparisce un
#      terminale NON bersaglio: e' la prova STAMPATA che il reale non e'
#      stato toccato;
#    - chiusura CHIRURGICA del solo terminale da backtest (classe 159);
#    - PIN di commit sullo script e sull'EA (classe 164);
#    - raccolta con ZIP sul Desktop, sempre, anche se una corsa fallisce.
#
#  COSA MISURA (e cosa NO)
#    48 combinazioni di USCITA a tick reali, INGRESSO FISSATO ai default:
#      parziale 0/50% x BE-dopo-parziale x BE indipendente x
#      trailing OFF/ATR/PREVBAR/FIXED.
#    NON tocca l'ingresso, NON promuove niente, NON scrive in forward.
#    Il metro esiste gia': R46 ha misurato che la sola struttura d'uscita
#    sposta il DAX da PF 0,88 a PF 1,49 fuori campione. Qui si cerca il
#    CENTRO DELL'ALTOPIANO, mai il picco.
#
#  NIENTE EMOJI: Windows PowerShell 5.1 legge i .ps1 come ANSI.
# =====================================================================
param(
  [string]$Pin               = "lavoro",
  [string]$TerminaleBacktest = "C:\MT5_Backtest",
  [string]$Work              = "$env:USERPROFILE\abtg_gestione",
  [string]$Fase              = "struttura",
  [switch]$ChiudiBacktest,
  [switch]$SoloControllo
)
$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$MARC_MIO = "MARCATORE_RIGA_SCAN_GESTIONE_v1"
$MARC_SCN = "MARCATORE_SCAN_GESTIONE_v2_VPS"
$RawBase  = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"
$Avvio    = Get-Date

function Muori($m){ Write-Host ""; Write-Host ("ERRORE: " + $m) -ForegroundColor Red; exit 1 }

# --- LE DUE CORSE. Ora SERVER BCM (= italiana - 1): DAX 8, Nasdaq 14.
$CORSE = @(
  @{ Robot="ABTG_DAX_Apertura_EU";    Symbol="D30EUR"; Ora=8  },
  @{ Robot="ABTG_Nasdaq_Apertura_US"; Symbol="NASUSD"; Ora=14 }
)

Write-Host ""
Write-Host "=== STUDIO GESTIONE -- fase '$Fase' -- pin $Pin ===" -ForegroundColor Cyan

# =====================================================================
#  GUARDIA_BANCO_POSITIVA_v1 -- INIZIO DEL BLOCCO COPIATO
#
#  QUESTA E' UNA COPIA, NON CODICE NUOVO, e non va "migliorata" qui.
#  ORIGINALE: backtest_pipeline\righe\RIGA_ROUND_VPS.ps1, righe 282-386
#  al commit e2d5dc3be1c05d275d8c45c353caa46f929f846e (11/09/2026).
#  Le righe fra questo marcatore e quello di FINE sono IDENTICHE BYTE
#  PER BYTE all'originale, e si verifica cosi' (zero differenze attese):
#     sed -n '282,386p' backtest_pipeline/righe/RIGA_ROUND_VPS.ps1 > /tmp/a
#     sed -n '<prima riga di codice>,<ultima>p' QUESTO_FILE > /tmp/b
#     diff /tmp/a /tmp/b
#  (i due numeri si leggono qui accanto ai marcatori; il comando per
#   intero sta nel referto di consegna dell'11/09/2026).
#
#  NOTA PER CHI TOCCA QUESTE RIGHE: il marcatore di INIZIO e quello di
#  FINE devono comparire in questo file UNA VOLTA SOLA CIASCUNO. Sono
#  presi come confini da chi estrae il blocco per rigirarci sopra i
#  contro-esempi, e una seconda occorrenza dentro un commento accorcia il
#  blocco estratto senza dire niente. Misurato l'11/09/2026, sbagliando:
#  la prima stesura di questa intestazione citava i due marcatori per
#  esteso dentro un esempio di comando, e il banco di prova ha estratto
#  NOVE righe invece di centocinque -- verdetto "RIFIUTATO" su tutto,
#  banco compreso, per un difetto del banco e non della guardia.
#
#  PERCHE' COPIATA E NON INCLUSA -- scelta dichiarata, col suo costo.
#  Un include sarebbe UNA DIPENDENZA IN PIU' DA PINNARE, e qui il pin e'
#  la sola cosa che lega il codice che gira al codice che qualcuno ha
#  letto: RIGA_SOTTILE_ROUND.ps1 inchioda al byte (SHA-256 + pin di
#  commit) i .ps1 che esegue, e RIGA_ROUND_VPS.ps1 scarica questo driver
#  da solo, un file alla volta. Con un include il file incluso o viaggia
#  NON pinnato -- e allora il pin non vuol dire piu' niente -- oppure va
#  aggiunto a mano a ogni catena di scaricamento e a ogni elenco di
#  impronte: tre punti nuovi in cui sbagliare, per risparmiare una copia.
#  Fra comodo e stretto, stretto: si duplica, e si DICHIARA.
#
#  IL COSTO DELLA COPIA, detto per intero: se un giorno la guardia si
#  corregge, va corretta in TUTTI i posti che portano questo marcatore.
#  Si trovano con:
#     grep -rn "GUARDIA_BANCO_POSITIVA_v1" backtest_pipeline
#  L'originale NON porta il marcatore (la sua impronta e' gia' pinnata
#  altrove e toccarlo vorrebbe dire ri-pinnare tutta la catena): sta
#  scritto qui sopra col nome e col commit, ed e' il primo posto da
#  aprire.
# =====================================================================
$BANCO_PERC  = "C:\MT5_Backtest"
$BANCO_CONTO = "50504400"

# I vietati per NOME. NON decidono piu' niente -- decide la guardia
# positiva qui sotto -- ma servono a due cose che contano: dare il
# messaggio GIUSTO (chi e' il terminale che stavi per toccare, col suo
# numero di conto in chiaro, regola dei terminali multipli del 06/09), e
# fare da seconda rete se un domani qualcuno allentasse il confronto.
$TERMINALI_VIETATI = @(
  @{ p = "BCM_Reale";                chi = "il terminale del conto REALE 10105439" },
  @{ p = "-V3";                      chi = "il terminale del 100k, conto 50504263" },
  @{ p = "BCM Markets MT5 Terminal"; chi = "un terminale con SEDIE VIVE sopra: il piccolo 50503392 (e il 100k, che sta nella stessa famiglia di cartelle)" },
  @{ p = "10105439";                 chi = "il conto REALE" },
  @{ p = "50504263";                 chi = "il 100k" },
  @{ p = "50503392";                 chi = "il piccolo" }
)

# Canonicalizza UNA SCRITTURA DI PERCORSO DI WINDOWS: '/' diventa '\',
# i separatori doppi si collassano, '.' e '..' si risolvono, il
# separatore finale sparisce. Torna "" quando la forma NON e' riducibile
# a un percorso ancorato a una lettera di disco -- e "" vuol dire NO.
# Regola dichiarata: cio' che non so risolvere lo RIFIUTO, non lo
# indovino. L'errore cade sempre verso il no.
#
# PERCHE' NON USO [IO.Path]::GetFullPath(), che farebbe le prime quattro
# cose da solo: perche' il suo risultato DIPENDE DALLA PIATTAFORMA e dal
# runtime. Su Linux -- dove questa guardia e' stata collaudata riga per
# riga -- '\' non e' un separatore e GetFullPath("C:\MT5_Backtest")
# torna "<cartella corrente>/C:\MT5_Backtest"; fra .NET Framework 4 (il
# VPS) e .NET Core cambia anche il trattamento di punti e spazi finali.
# Una guardia il cui significato cambia col runtime e' una guardia che
# non si puo' collaudare, e una che non si puo' collaudare non si sa se
# protegge. Questa fa lo stesso identico conto ovunque.
# Il pezzo che il DISCO deve dire (e che nessuna stringa sa) e' un altro,
# ed e' l'attributo ReparsePoint: sta al PUNTO 1, non qui.
function NormalizzaPercorsoWin([string]$p){
  if($null -eq $p){ return "" }
  $s = ("" + $p).Trim()
  if($s -eq ""){ return "" }
  $s = $s.Replace("/","\")
  if($s.Contains("~")){ return "" }              # nome 8.3 (PROGRA~1): espanderlo richiede Win32, quindi si rifiuta
  if($s -match '[\*\?\[\]"|<>]'){ return "" }    # jolly e caratteri che in un percorso non ci vanno
  if($s -notmatch '^[A-Za-z]:\\'){ return "" }   # solo "X:\...": niente UNC, niente \\?\, niente "C:senza-barra"
  $disco = $s.Substring(0,2).ToUpper()
  $resto = $s.Substring(2)
  if($resto.Contains(":")){ return "" }          # un secondo ':' non e' un percorso (flusso NTFS, argomenti incollati)
  $pezzi = New-Object System.Collections.ArrayList
  foreach($t in $resto.Split("\")){
    if($t -eq "" -or $t -eq "."){ continue }
    if($t -eq ".."){
      if($pezzi.Count -eq 0){ return "" }        # si risale sopra la radice: forma senza senso
      $pezzi.RemoveAt($pezzi.Count - 1)
      continue
    }
    [void]$pezzi.Add($t)
  }
  if($pezzi.Count -eq 0){ return ($disco + "\") }   # la RADICE di un disco: normalizzata, e rifiutata piu' sotto
  return ($disco + "\" + ($pezzi -join "\"))
}

# La radice di un disco ("C:\", "D:\") non e' un terminale: e' TUTTO il
# disco. Ha una riga sua perche' merita un messaggio suo -- con un
# bersaglio cosi' la pipe di chiusura diventa "C:\*", cioe' ogni
# terminal64 della macchina, conto reale compreso.
function RadiceDiDisco([string]$norm){
  if($null -eq $norm){ return $false }
  return ($norm -match '^[A-Za-z]:\\$')
}

# IL VERDETTO SUL BERSAGLIO, in una funzione sola e senza effetti: torna
# "" se il bersaglio E' il banco, altrimenti il MOTIVO del rifiuto.
# L'ordine dei controlli e' scelto: prima i divieti per nome (che sanno
# dire CHI stavi per toccare), poi la normalizzazione, poi il confronto
# positivo. Il confronto positivo da solo basterebbe a rifiutare tutto
# quanto; gli altri servono a dire perche'.
function MotivoRifiutoBanco([string]$chiesto){
  $g = ("" + $chiesto).Trim()
  if($g -eq ""){ return "BERSAGLIO VUOTO: -TerminaleBacktest non dice niente." }
  foreach($v in $TERMINALI_VIETATI){
    if($g -like ("*" + $v.p + "*")){
      return ("TERMINALE VIETATO: '" + $g + "' nomina " + $v.chi + ".")
    }
  }
  $n = NormalizzaPercorsoWin $g
  if($n -eq ""){
    return ("BERSAGLIO NON RICONDUCIBILE A UNA CARTELLA DI WINDOWS: '" + $g + "'." +
            " Un nome 8.3 (PROGRA~1 = C:\Program Files scritto in un altro modo), un" +
            " percorso di rete, un \\?\, un carattere jolly o un percorso non ancorato" +
            " a un disco non si indovinano: si rifiutano.")
  }
  if(RadiceDiDisco $n){
    return ("RADICE DI UN DISCO: '" + $g + "'. Un disco intero non e' un terminale:" +
            " con un bersaglio cosi' la pipe di chiusura diventa '" + $n + "*', cioe'" +
            " OGNI terminal64 della macchina.")
  }
  # Confronto ORDINALE, non -ieq. Il -eq di PowerShell passa dalla CULTURA
  # del thread, e una regola di casa di questo stesso file e' che la cultura
  # non deve mai entrare in un confronto (vedi NumInv, qui sopra): su un
  # confronto culturale certi caratteri invisibili vengono IGNORATI, cioe'
  # due stringhe diverse risultano uguali. Qui si guardano i byte.
  if(-not [string]::Equals($n, $BANCO_PERC, [StringComparison]::OrdinalIgnoreCase)){
    return ("NON E' IL BANCO: '" + $g + "' (normalizzato: '" + $n + "').")
  }
  return ""
}
# ---------------------------------------------------------------------
#  GUARDIA_BANCO_POSITIVA_v1 -- FINE DEL BLOCCO COPIATO
# ---------------------------------------------------------------------

# =====================================================================
#  1. IL TERMINALE: LA GUARDIA E' POSITIVA (rifatta l'11/09/2026)
# =====================================================================
# PRIMA ERA NEGATIVA, ED ERA LA COPIA LETTERALE DELLA GUARDIA VECCHIA:
# "-like *-V3* oppure *BCM_Reale*". Eseguita contro bersagli finti,
# lasciava passare QUATTRO cose, e tre sono terminali VERI del VPS:
#   C:\Program Files\BCM Markets MT5 Terminal -> il PICCOLO 50503392, che
#       ha le sedie VIVE sopra ed e' proprio quello che questa riga e'
#       nata per NON toccare (vedi l'intestazione, 09/09/2026);
#   C:\  -> la RADICE di un disco, e qui il danno non e' teorico: la pipe
#       di Bersagli()/Risparmiati() qui sotto e' ($cartellaBT + "\*"), che
#       con la radice diventa "C:\*" = OGNI terminal64 della macchina,
#       conto REALE 10105439 compreso, e li chiude tutti con -ChiudiBacktest;
#   C:\PROGRA~1\BCMMAR~1 -> lo stesso posto del piccolo scritto in nome
#       8.3: una lista di divieti guarda le LETTERE, non il POSTO;
#   C:\MT5_Backtest\..\Program Files\BCM Markets MT5 Terminal -> nomina il
#       banco, ma il '..' porta altrove.
# Adesso dice UNA COSA SOLA: DEVE ESSERE IL BANCO. Ed e' la forma giusta
# per QUESTA riga, che non e' uno scandaglio di sola lettura: compila un
# EA dentro la cartella dati del terminale bersaglio e ci fa girare il
# tester. Un bersaglio diverso dal banco qui non ha nessun uso legittimo.
$motivoNo = MotivoRifiutoBanco $TerminaleBacktest
if($motivoNo -ne ""){
  Muori ($motivoNo + "`n" +
         "    L'UNICO terminale ammesso e' " + $BANCO_PERC + " (demo " + $BANCO_CONTO + ", solo-tester).`n" +
         "    Gli altri MT5 di questa macchina hanno SEDIE VIVE sopra e non si toccano:`n" +
         "    il piccolo 50503392, il 100k 50504263 e il conto REALE 10105439.`n" +
         "    La guardia e' POSITIVA: non elenca i vietati, ammette il banco. Se un`n" +
         "    giorno il banco cambiasse casa, si cambia QUELLA COSTANTE, a mano, e si`n" +
         "    ripassa dal cancello.")
}
# LA COSTANTE, NON LA STRINGA DI FUORI. E' questa riga che chiude il buco
# della radice del disco: la pipe qui sotto e' SEMPRE "C:\MT5_Backtest\*"
# e non puo' diventare "C:\*" per colpa di come e' stato scritto un
# argomento. Vale anche per $exeBT e $medBT, che nascono da qui.
$cartellaBT = $BANCO_PERC
Write-Host ("  bersaglio AMMESSO dalla guardia positiva: " + $cartellaBT + "   (conto " + $BANCO_CONTO + ")") -ForegroundColor Green
if(-not (Test-Path -LiteralPath $cartellaBT -PathType Container)){ Muori ("la cartella '" + $cartellaBT + "' non esiste.") }
# --- GUARDIA_BANCO_POSITIVA_v1, GRADINO f: COPIA da RIGA_ROUND_VPS.ps1
#     righe 480-497 al commit e2d5dc3 (stesse regole di sopra). E' il
#     gradino che la sola stringa NON puo' fare: un nome giusto puo'
#     puntare nel posto sbagliato se la cartella e' una junction.
# IL GRADINO CHE NESSUNA STRINGA PUO' FARE. Un nome giusto puo' puntare
# nel posto sbagliato: basta che la cartella sia una junction o un link
# simbolico. Il testo e' identico, il posto no -- e quello lo sa solo il
# filesystem. Se e' un collegamento non si parte: non si indovina dove va.
$infoBT = $null
try  { $infoBT = Get-Item -LiteralPath $cartellaBT -Force -ErrorAction Stop }
catch{ $infoBT = $null }
if($null -eq $infoBT){
  Muori ("la cartella '" + $cartellaBT + "' non e' leggibile: non posso dire DOVE punta, e quindi non parto.")
}
if((([int]$infoBT.Attributes) -band ([int][IO.FileAttributes]::ReparsePoint)) -ne 0){
  Muori ("IL BANCO E' UN COLLEGAMENTO: '" + $cartellaBT + "' non e' una cartella vera,`n" +
         "    e' una junction (o un link simbolico) che rimanda altrove. Il nome e'`n" +
         "    quello giusto, il posto potrebbe non esserlo, e nessun controllo sulla`n" +
         "    STRINGA se ne accorgerebbe.`n" +
         "    Se il banco 50504400 e' davvero installato cosi', si guarda insieme dove`n" +
         "    punta e si cambia questa riga. Non si tira a indovinare.")
}
$exeBT = Join-Path $cartellaBT "terminal64.exe"
$medBT = Join-Path $cartellaBT "metaeditor64.exe"
if(-not (Test-Path -LiteralPath $exeBT -PathType Leaf)){ Muori ("in '" + $cartellaBT + "' non c'e' terminal64.exe.") }
if(-not (Test-Path -LiteralPath $medBT -PathType Leaf)){ Muori ("in '" + $cartellaBT + "' non c'e' metaeditor64.exe: senza compilatore lo studio non parte.") }

function Terminali(){ return @(Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) }
function Bersagli($p){ return @($p | Where-Object { $_.Path -and ($_.Path -like ($cartellaBT + "\*")) }) }
function Risparmiati($p){ return @($p | Where-Object { -not ($_.Path -and ($_.Path -like ($cartellaBT + "\*"))) }) }

$tutti = Terminali; $berPri = Bersagli $tutti; $salPri = Risparmiati $tutti
$pidSalvi = @($salPri | ForEach-Object { $_.Id })

Write-Host ""
Write-Host "--- TERMINALI MT5 VISTI ADESSO (PRIMA) ------------------------------" -ForegroundColor Cyan
if($berPri.Count -eq 0){ Write-Host "  BERSAGLIO (backtest): nessuno vivo. Bene." -ForegroundColor Green }
else{ Write-Host "  BERSAGLIO (backtest, l'unico che posso chiudere):" -ForegroundColor Yellow
      $berPri | ForEach-Object { Write-Host ("    PID " + $_.Id + "    " + $_.Path) -ForegroundColor Yellow } }
Write-Host "  LASCIATI VIVI (forward e CONTO REALE: NON li tocco):" -ForegroundColor Green
if($salPri.Count -eq 0){ Write-Host "    (nessuno)" -ForegroundColor Green }
else{ $salPri | ForEach-Object { Write-Host ("    PID " + $_.Id + "    " + $(if($_.Path){$_.Path}else{"<percorso non leggibile: NON e' un bersaglio>"})) -ForegroundColor Green } }
Write-Host "---------------------------------------------------------------------" -ForegroundColor Cyan

if($berPri.Count -gt 0 -and -not $SoloControllo){
  if(-not $ChiudiBacktest){ Muori "il terminale da backtest e' aperto: rilancia con -ChiudiBacktest (chiudo SOLO quello)." }
  Write-Host "  chiudo SOLO il bersaglio..." -ForegroundColor Yellow
  $berPri | ForEach-Object { try{ Stop-Process -Id $_.Id -Force -ErrorAction Stop }catch{} }
  Start-Sleep -Seconds 4
}

# --- CARTELLA DATI: prima il portable (MQL5 dentro l'installazione), poi
#     origin.txt in APPDATA. Si STAMPA quale delle due ha vinto.
$DataFolder = ""; $viaDati = ""
if(Test-Path -LiteralPath (Join-Path $cartellaBT "MQL5") -PathType Container){
  $DataFolder = $cartellaBT; $viaDati = "PORTABLE (MQL5 dentro l'installazione)"
} else {
  $termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
  if(Test-Path $termRoot){
    $d = Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue | Where-Object {
           $o = Join-Path $_.FullName "origin.txt"
           (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $cartellaBT)
         } | Select-Object -First 1
    if($d){ $DataFolder = $d.FullName; $viaDati = "APPDATA via origin.txt" }
  }
}
if(-not $DataFolder){ Muori "cartella dati MT5 non trovata ne' portable ne' via origin.txt." }
Write-Host ("  cartella dati : " + $DataFolder + "   [" + $viaDati + "]") -ForegroundColor Gray

# =====================================================================
#  2. LO SCRIPT DALLO STESSO PIN, COL SUO MARCATORE
# =====================================================================
New-Item -ItemType Directory -Force -Path $Work | Out-Null
$scn = Join-Path $Work "scan_gestione.ps1"
Remove-Item $scn -ErrorAction SilentlyContinue
$u = $RawBase + "/backtest_pipeline/scan_gestione.ps1?cb=" + [guid]::NewGuid().ToString()
try{ Invoke-WebRequest -Uri $u -OutFile $scn -UseBasicParsing }catch{ Muori ("download di scan_gestione.ps1 fallito dal pin " + $Pin) }
if(-not (Select-String -Path $scn -SimpleMatch -Pattern $MARC_SCN -Quiet)){
  Muori ("scan_gestione.ps1 scaricato NON e' la v2 (manca " + $MARC_SCN + "): la v1 puo' ricompilare dentro il terminale del PICCOLO. Fermato.")
}
Write-Host ("  scan_gestione : v2 verificata (" + $MARC_SCN + ")") -ForegroundColor Green

if($SoloControllo){
  Write-Host ""
  Write-Host "GIRO A VUOTO: guardie passate, dati e script a posto. Niente e' stato lanciato." -ForegroundColor Cyan
  Write-Host "ATTENZIONE: il giro a vuoto NON compila e NON collauda il tester." -ForegroundColor Yellow
  exit 0
}

# =====================================================================
#  3. LE DUE CORSE
# =====================================================================
$esiti = @()
foreach($c in $CORSE){
  Write-Host ""
  Write-Host ("=== CORSA: " + $c.Robot + " su " + $c.Symbol + "   (SessionHour SERVER=" + $c.Ora + ") ===") -ForegroundColor Cyan
  & powershell -NoProfile -ExecutionPolicy Bypass -File $scn `
      -Robot $c.Robot -Symbol $c.Symbol -SessionHour $c.Ora -Fase $Fase -Pin $Pin `
      -Terminal $exeBT -MetaEditor $medBT -DataFolder $DataFolder -Force
  $rc = $LASTEXITCODE
  $esiti += [pscustomobject]@{ Robot=$c.Robot; Symbol=$c.Symbol; Rc=$rc }
  Write-Host ("--- ESITO " + $c.Symbol + ": rc=" + $rc) -ForegroundColor Cyan
}

# =====================================================================
#  4. CENSIMENTO DOPO -- LA PROVA STAMPATA
# =====================================================================
$dopo = Terminali; $salDopo = Risparmiati $dopo
$pidDopo = @($salDopo | ForEach-Object { $_.Id })
$spariti = @($pidSalvi | Where-Object { $pidDopo -notcontains $_ })
Write-Host ""
Write-Host ("PID non bersaglio PRIMA: " + ($pidSalvi -join ", ")) -ForegroundColor Gray
Write-Host ("PID non bersaglio DOPO : " + ($pidDopo  -join ", ")) -ForegroundColor Gray
if($spariti.Count -gt 0){
  Write-Host ("!!! ALLARME: sono spariti terminali NON bersaglio: " + ($spariti -join ", ")) -ForegroundColor Red
} else {
  Write-Host "OK: nessun terminale non bersaglio e' stato toccato." -ForegroundColor Green
}

# =====================================================================
#  5. RACCOLTA -- SEMPRE, anche se una corsa e' fallita
# =====================================================================
$dsk = [Environment]::GetFolderPath("Desktop")
$dir = Join-Path $dsk ("GESTIONE_" + $Fase.ToUpper())
if(Test-Path -LiteralPath $dir){ Remove-Item -LiteralPath $dir -Recurse -Force }
New-Item -ItemType Directory -Force -Path $dir | Out-Null

$sorgente = Join-Path $Work "risultati_gestione"
$copiati = 0
if(Test-Path -LiteralPath $sorgente){
  Get-ChildItem -LiteralPath $sorgente -Filter *.csv -ErrorAction SilentlyContinue |
    Where-Object { $_.LastWriteTime -ge $Avvio } |
    ForEach-Object { Copy-Item $_.FullName -Destination $dir -Force; $copiati++ }
}
$ref = Join-Path $dir "REFERTO_GESTIONE.txt"
$righe = @()
$righe += "REFERTO STUDIO GESTIONE"
$righe += ("marcatore riga  : " + $MARC_MIO)
$righe += ("marcatore script: " + $MARC_SCN)
$righe += ("pin             : " + $Pin)
$righe += ("data            : " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss") + "   <-- SE NON E' DI OGGI, IL FILE E' VECCHIO")
$righe += ("terminale       : " + $exeBT)
$righe += ("cartella dati   : " + $DataFolder + "   [" + $viaDati + "]")
$righe += ("fase            : " + $Fase)
$righe += ""
foreach($e in $esiti){ $righe += ("  " + $e.Robot + " / " + $e.Symbol + "   rc=" + $e.Rc) }
$righe += ""
$righe += ("CSV raccolti    : " + $copiati)
if($copiati -eq 0){ $righe += "  ATTENZIONE: zero CSV. NON vuol dire 'nessun edge': vuol dire NON E' GIRATA. Guardare il log." }
$righe += ""
$righe += ("PID non bersaglio PRIMA: " + ($pidSalvi -join ", "))
$righe += ("PID non bersaglio DOPO : " + ($pidDopo  -join ", "))
# NOTA: niente "(if ...)" come espressione fra parentesi -- pwsh 7 lo
# accetta, Windows PowerShell 5.1 no. Sul VPS gira la 5.1.
if($spariti.Count -gt 0){ $righe += ("ALLARME: spariti " + ($spariti -join ", ")) }
else                    { $righe += "OK: nessun terminale non bersaglio toccato." }
$righe | Set-Content -Path $ref -Encoding ASCII

$zip = Join-Path $dsk ("GESTIONE_" + $Fase.ToUpper() + ".zip")
if(Test-Path -LiteralPath $zip){ Remove-Item -LiteralPath $zip -Force }
Compress-Archive -Path (Join-Path $dir "*") -DestinationPath $zip -Force
Write-Host ""
Write-Host ("ZIP PRONTO DA MANDARE: " + $zip) -ForegroundColor Green
Write-Host ("  CSV dentro: " + $copiati) -ForegroundColor Gray
Write-Host "  REFERTO_GESTIONE.txt" -ForegroundColor Gray
if($copiati -eq 0){ exit 2 } else { exit 0 }
