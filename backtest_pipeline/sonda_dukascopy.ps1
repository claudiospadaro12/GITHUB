# =====================================================================
#  sonda_dukascopy.ps1  --  FIN DOVE ARRIVA LO STORICO DUKASCOPY
#                           SUGLI INDICI? (misurato, non ricordato)
# ---------------------------------------------------------------------
#  PERCHE' ESISTE (15/08/2026)
#    Domanda di Claudio: "se non si potra' fare, non si poteva scaricare
#    tipo da Dukascopy?". La risposta onesta e' che NON LO SAPPIAMO:
#    Dukascopy e' citato in 5 file del repo ma non e' MAI stato misurato,
#    e nessuno ha mai controllato se i suoi indici arrivano al 2020/2022.
#    Questo script non chiede a nessuno di ricordare: CHIEDE AL SERVER.
#
#  COME FUNZIONA
#    Dukascopy pubblica i tick grezzi a questo indirizzo:
#      datafeed.dukascopy.com/datafeed/<SIMBOLO>/<AAAA>/<MM-1>/<GG>/<HH>h_ticks.bi5
#    ATTENZIONE al mese: e' ZERO-BASED (gennaio = 00, dicembre = 11).
#    Un file che c'e' torna 200 con dei byte dentro; uno che non c'e'
#    torna 404. Sonda l'ora 15 UTC, che e' dentro la seduta americana
#    in tutte e due le stagioni ed e' anche dentro quella tedesca.
#
#  CONTROLLO POSITIVO (regola di progetto)
#    In ogni caccia si sonda anche qualcosa di cui si conosce gia' la
#    risposta. Qui e' EURUSD: se EURUSD non risponde, non e' Dukascopy
#    che non ha i dati, e' la connessione che non funziona - e nessun
#    "non trovato" di questa corsa vale niente.
#
#  COSA NON FA
#    Non scarica storico, non decomprime niente, non tocca MT5. E' solo
#    una domanda ripetuta: "questa data c'e'?". Poche centinaia di KB.
#
#  USO (PC di backtest o VPS, indifferente: non apre MT5)
#    powershell -ExecutionPolicy Bypass -File .\sonda_dukascopy.ps1
#
#  VARIANTI
#    -Simboli "USA30IDXUSD,DEUIDXEUR"   sonda solo questi
#    -Anni "2020,2022,2024"             sonda solo questi anni
#    -Ora 15                            ora UTC da sondare
# =====================================================================
param(
  [string] $Simboli = "",
  [string] $Anni    = "2008,2010,2012,2015,2018,2020,2022,2024,2025",
  [int]    $Ora     = 15,
  [int]    $PausaMs = 250,      # respiro fra una richiesta e l'altra
  [switch] $ProsegiuComunque    # prosegue anche se il controllo positivo fallisce
)
$ErrorActionPreference = "Continue"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

function Riga($t, $c = "Gray") { Write-Host $t -ForegroundColor $c }

Riga "=== SONDA DUKASCOPY: fin dove arriva lo storico? ===" "Cyan"
Riga ("MACCHINA: " + $env:COMPUTERNAME + "   utente: " + $env:USERNAME) "Cyan"
Riga ("letto il  " + (Get-Date -Format "yyyy-MM-dd HH:mm:ss")) "Cyan"
Riga ""

# --- i candidati -----------------------------------------------------
#  ATTENZIONE: questi nomi sono CANDIDATI, non fatti. Il nome con cui
#  Dukascopy chiama il DAX non lo sappiamo: lo scopre questa sonda.
#  EURUSD in fondo NON e' un candidato: e' il controllo positivo.
# NOTA 15/08/2026: nella prima corsa USA30IDXUSD e GERIDXEUR non hanno
# risposto, mentre gli altri sette indici si'. Il Dow e' il nostro cavallo
# sull'ORB e sull'Apertura US: prima di dire "Dukascopy non ha il Dow" si
# provano tutte le grafie plausibili.
$candidati = @(
  @{ N="USA30IDXUSD";   Che="Dow Jones 30" },
  @{ N="US30IDXUSD";    Che="Dow (grafia alt. 1)" },
  @{ N="USA30USD";      Che="Dow (grafia alt. 2)" },
  @{ N="DJIIDXUSD";     Che="Dow (grafia alt. 3)" },
  @{ N="WS30IDXUSD";    Che="Dow (grafia alt. 4)" },
  @{ N="USA2000IDXUSD"; Che="Russell 2000 (controllo di schema)" },
  @{ N="USATECHIDXUSD"; Che="Nasdaq 100" },
  @{ N="USA500IDXUSD";  Che="S&P 500" },
  @{ N="DEUIDXEUR";     Che="DAX 40" },
  @{ N="GERIDXEUR";     Che="DAX (nome alternativo)" },
  @{ N="JPNIDXJPY";     Che="Nikkei 225" },
  @{ N="EUSIDXEUR";     Che="Euro Stoxx 50" },
  @{ N="GBRIDXGBP";     Che="FTSE 100" },
  @{ N="FRAIDXEUR";     Che="CAC 40" },
  @{ N="EURUSD";        Che="<<< CONTROLLO POSITIVO >>>" }
)
if ($Simboli) {
  $lista = @()
  foreach ($s in ($Simboli -split ",")) {
    $s = $s.Trim(); if ($s) { $lista += @{ N=$s; Che="(richiesto a mano)" } }
  }
  $lista += @{ N="EURUSD"; Che="<<< CONTROLLO POSITIVO >>>" }
  $candidati = $lista
}

$anniLista = @()
foreach ($a in ($Anni -split ",")) { $a = $a.Trim(); if ($a) { $anniLista += [int]$a } }
$anniLista = $anniLista | Sort-Object

# --- una domanda sola ------------------------------------------------
#  Torna un oggetto: Esito = OK / VUOTO / ASSENTE / ERRORE, e i byte.
#  IL 503 NON E' UN "NON C'E'" (imparato il 15/08/2026, secondo giro).
#  Dopo la prima richiesta andata a buon fine, Dukascopy ha risposto
#  "503 Server non disponibile" a TUTTO, controllo positivo compreso:
#  e' rate limiting, non assenza di dati. Un 404 dice "questo file non
#  esiste"; un 503 dice "adesso no". Confonderli vorrebbe dire cancellare
#  simboli veri dal catalogo - lo stesso errore, per la terza volta oggi.
#  Quindi: sui codici temporanei si RITENTA con attesa crescente, e solo
#  dopo si dichiara errore.
$script:AttesePost503 = @(2, 5, 15, 30)   # secondi

function Chiedi([string]$sym, [int]$anno, [int]$mese1, [int]$giorno, [int]$ora) {
  $url = "https://datafeed.dukascopy.com/datafeed/{0}/{1:0000}/{2:00}/{3:00}/{4:00}h_ticks.bi5" -f `
         $sym, $anno, ($mese1 - 1), $giorno, $ora
  $ultimo = ""
  for ($t = 0; $t -le $script:AttesePost503.Count; $t++) {
    if ($PausaMs -gt 0) { Start-Sleep -Milliseconds $PausaMs }
    try {
      $r = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 25 -ErrorAction Stop
      $n = 0
      if ($r.Content -ne $null) { $n = $r.Content.Length }
      if ($n -gt 0) { return @{ Esito="OK"; Byte=$n; Url=$url } }
      return @{ Esito="VUOTO"; Byte=0; Url=$url }
    } catch {
      $cod = 0
      try { $cod = [int]$_.Exception.Response.StatusCode } catch { }
      if ($cod -eq 404) { return @{ Esito="ASSENTE"; Byte=0; Url=$url } }
      $ultimo = ("ERRORE " + $cod + " " + $_.Exception.Message)
      # 429/500/502/503/504 e i guasti di rete (cod 0) sono TEMPORANEI
      $temporaneo = ($cod -eq 0 -or $cod -eq 429 -or ($cod -ge 500 -and $cod -le 504))
      if (-not $temporaneo) { return @{ Esito=$ultimo; Byte=0; Url=$url } }
      if ($t -lt $script:AttesePost503.Count) {
        $att = $script:AttesePost503[$t]
        Write-Host ("       ({0}: il server dice {1}, riprovo fra {2} s)" -f $sym, $cod, $att) -ForegroundColor DarkYellow
        Start-Sleep -Seconds $att
      }
    }
  }
  return @{ Esito=$ultimo; Byte=0; Url=$url }
}

# Un giorno solo non basta: puo' essere festivo. Si provano tre giorni
# infrasettimanali dello stesso mese e vale il migliore.
function ChiediAnno([string]$sym, [int]$anno, [int]$ora) {
  $migliore = @{ Esito="ASSENTE"; Byte=0; Url="" }
  foreach ($g in @(15, 16, 17, 18, 19)) {
    $d = Get-Date -Year $anno -Month 6 -Day $g -Hour 0 -Minute 0 -Second 0
    if ($d.DayOfWeek -eq "Saturday" -or $d.DayOfWeek -eq "Sunday") { continue }
    $r = Chiedi $sym $anno 6 $g $ora
    if ($r.Esito -eq "OK") { return $r }
    if ($r.Esito -like "ERRORE*" -and $migliore.Esito -eq "ASSENTE") { $migliore = $r }
    if ($r.Esito -eq "VUOTO") { $migliore = $r }
  }
  return $migliore
}

# --- 1. il simbolo esiste? (data recente) ----------------------------
$annoRecente = ($anniLista | Select-Object -Last 1)
$vivi  = New-Object System.Collections.ArrayList
$righe = New-Object System.Collections.ArrayList

# --- 0. IL CONTROLLO POSITIVO VA PER PRIMO ---------------------------
#  Il 15/08 (secondo giro) era in fondo alla lista: quando ha fallito,
#  lo script aveva gia' sprecato tutte le altre richieste E ha continuato
#  lo stesso con la fase 2, producendo un referto di soli errori.
#  Se il metro non funziona, non si misura niente.
Riga "0) controllo positivo (EURUSD): se non risponde lui, non si misura niente" "Yellow"
$rc = ChiediAnno "EURUSD" $annoRecente $Ora
[void]$righe.Add([pscustomobject]@{
  Simbolo="EURUSD"; Che="<<< CONTROLLO POSITIVO >>>"; Anno=$annoRecente;
  Esito=$rc.Esito; Byte=$rc.Byte; Url=$rc.Url; Fase="0-controllo"
})
$ctrlOk = ($rc.Esito -eq "OK")
if ($ctrlOk) {
  Riga ("   EURUSD risponde: {0} byte. Si puo' misurare." -f $rc.Byte) "Green"
} else {
  Riga ("   EURUSD NON risponde: {0}" -f $rc.Esito) "Red"
  Riga ""
  Riga "!!! IL CONTROLLO POSITIVO E' FALLITO. MI FERMO QUI." "Red"
  Riga "    NON e' Dukascopy che non ha i dati: e' la connessione, o il" "Red"
  Riga "    server che sta rifiutando le richieste (503 = rate limiting)." "Red"
  Riga "    Continuare produrrebbe solo un referto di errori scambiabili" "Red"
  Riga "    per assenze. Aspetta qualche minuto e rilancia." "Yellow"
  Riga "    (Per forzare comunque: -ProsegiuComunque)" "DarkGray"
}

Riga ""
Riga "1) quali di questi nomi esistono davvero (sonda su giugno dell'anno piu' recente)" "Yellow"
if (-not $ctrlOk -and -not $ProsegiuComunque) {
  Riga "   saltata: il controllo positivo e' fallito." "DarkGray"
  $candidati = @()
}
foreach ($c in $candidati) {
  if ($c.N -eq "EURUSD") { continue }
  $r = ChiediAnno $c.N $annoRecente $Ora
  $col = if ($r.Esito -eq "OK") { "Green" } elseif ($r.Esito -like "ERRORE*") { "Red" } else { "DarkGray" }
  Riga ("   {0,-16} {1,-28} {2}  ({3} byte)" -f $c.N, $c.Che, $r.Esito, $r.Byte) $col
  # ANCHE I FALLITI VANNO NEL REFERTO (difetto trovato il 15/08: USA30IDXUSD
  # e GERIDXEUR erano spariti dal CSV senza lasciare traccia, e nel file
  # sembrava che non fossero mai stati chiesti).
  [void]$righe.Add([pscustomobject]@{
    Simbolo=$c.N; Che=$c.Che; Anno=$annoRecente; Esito=$r.Esito; Byte=$r.Byte; Url=$r.Url; Fase="1-esiste?"
  })
  if ($r.Esito -eq "OK") { [void]$vivi.Add($c) }
}

Riga ""
# --- 2. fin dove indietro? -------------------------------------------
Riga "2) per i simboli vivi: fin dove arriva lo storico" "Yellow"
foreach ($c in $vivi) {
  Riga ("   --- " + $c.N + "  (" + $c.Che + ") ---") "White"
  $primoAnnoOk = 0
  $ultimoNo    = 0
  $precedente  = 0
  foreach ($anno in $anniLista) {
    $r = ChiediAnno $c.N $anno $Ora
    $col = if ($r.Esito -eq "OK") { "Green" } else { "DarkGray" }
    Riga ("       {0}   {1,-10} {2} byte" -f $anno, $r.Esito, $r.Byte) $col
    [void]$righe.Add([pscustomobject]@{
      Simbolo=$c.N; Che=$c.Che; Anno=$anno; Esito=$r.Esito; Byte=$r.Byte; Url=$r.Url; Fase="2-scala"
    })
    if ($r.Esito -eq "OK" -and $primoAnnoOk -eq 0) { $primoAnnoOk = $anno; $ultimoNo = $precedente }
    if ($r.Esito -ne "OK") { $precedente = $anno }
  }

  # --- STRINGI: fra l'ultimo anno senza dati e il primo con dati puo'
  #     esserci di mezzo un buco di due o tre anni. Qui si dimezza finche'
  #     non resta un anno solo, cosi' la prima data e' un numero, non un
  #     intervallo.
  if ($primoAnnoOk -gt 0 -and $ultimoNo -gt 0 -and ($primoAnnoOk - $ultimoNo) -gt 1) {
    $lo = $ultimoNo; $hi = $primoAnnoOk
    while (($hi - $lo) -gt 1) {
      $mid = [int][Math]::Floor(($lo + $hi) / 2)
      $r = ChiediAnno $c.N $mid $Ora
      $col = if ($r.Esito -eq "OK") { "Green" } else { "DarkGray" }
      Riga ("       {0}   {1,-10} {2} byte   (stringo)" -f $mid, $r.Esito, $r.Byte) $col
      [void]$righe.Add([pscustomobject]@{
        Simbolo=$c.N; Che=$c.Che; Anno=$mid; Esito=$r.Esito; Byte=$r.Byte; Url=$r.Url; Fase="3-stringo"
      })
      if ($r.Esito -eq "OK") { $hi = $mid } else { $lo = $mid }
    }
    $primoAnnoOk = $hi
  }
  if ($primoAnnoOk -gt 0) {
    $col = if ($primoAnnoOk -le 2020) { "Green" } else { "Yellow" }
    Riga ("       -> il piu' vecchio anno SONDATO con dati: {0}" -f $primoAnnoOk) $col
    if ($primoAnnoOk -gt 2022) {
      Riga  "          NON copre il 2022 (orso): per la prova di regime non basta." "Yellow"
    }
  }
}

# --- 3. raccolta sul Desktop (regola delle righe di lancio) ----------
$dest = Join-Path ([Environment]::GetFolderPath("Desktop")) "sonda_dukascopy"
New-Item -ItemType Directory -Force -Path $dest | Out-Null
$csv = Join-Path $dest "sonda_dukascopy.csv"
$righe | Export-Csv -Path $csv -NoTypeInformation -Encoding ASCII

$txt = Join-Path $dest "sonda_dukascopy.txt"
$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine("=== SONDA DUKASCOPY ===")
[void]$sb.AppendLine("macchina : " + $env:COMPUTERNAME)
[void]$sb.AppendLine("letto il : " + (Get-Date -Format "yyyy-MM-dd HH:mm:ss"))
[void]$sb.AppendLine("ora UTC sondata: " + $Ora)
[void]$sb.AppendLine("controllo positivo EURUSD: " + $(if ($ctrlOk) { "OK" } else { "FALLITO - la corsa non vale" }))
[void]$sb.AppendLine("")
foreach ($r in $righe) {
  [void]$sb.AppendLine(("{0,-16} {1}  {2,-10} {3,-9} byte  {4}" -f $r.Simbolo, $r.Anno, $r.Esito, $r.Byte, $r.Fase))
}
[System.IO.File]::WriteAllText($txt, $sb.ToString(), [System.Text.Encoding]::ASCII)

$zip = Join-Path ([Environment]::GetFolderPath("Desktop")) "sonda_dukascopy.zip"
try { Compress-Archive -Path (Join-Path $dest "*") -DestinationPath $zip -Force } catch { }

Riga ""
Riga ("RACCOLTA: " + $dest) "Green"
Riga ("ZIP PRONTO DA MANDARE: " + $zip) "Green"
Riga "Verifica che dentro ci siano:" "DarkGray"
Riga "   - sonda_dukascopy.csv" "DarkGray"
Riga "   - sonda_dukascopy.txt" "DarkGray"
Riga ""
Riga "COSA VUOL DIRE:" "Cyan"
Riga "  OK      = quel giorno/ora c'e', quindi lo storico arriva li'" "Gray"
Riga "  ASSENTE = 404, il file non esiste (simbolo sbagliato o anno troppo vecchio)" "Gray"
Riga "  VUOTO   = risposta senza byte: di solito festivo o mercato fermo" "Gray"
Riga "  ERRORE  = rete/proxy. Se compare sul CONTROLLO POSITIVO, butta la corsa." "Gray"
