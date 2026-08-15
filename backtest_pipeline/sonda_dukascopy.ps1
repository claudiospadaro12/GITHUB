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
  [int]    $Ora     = 15
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
$candidati = @(
  @{ N="USA30IDXUSD";   Che="Dow Jones 30" },
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
function Chiedi([string]$sym, [int]$anno, [int]$mese1, [int]$giorno, [int]$ora) {
  $url = "https://datafeed.dukascopy.com/datafeed/{0}/{1:0000}/{2:00}/{3:00}/{4:00}h_ticks.bi5" -f `
         $sym, $anno, ($mese1 - 1), $giorno, $ora
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
    return @{ Esito=("ERRORE " + $cod + " " + $_.Exception.Message); Byte=0; Url=$url }
  }
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
Riga "1) quali di questi nomi esistono davvero (sonda su giugno dell'anno piu' recente)" "Yellow"
$annoRecente = ($anniLista | Select-Object -Last 1)
$vivi = New-Object System.Collections.ArrayList
foreach ($c in $candidati) {
  $r = ChiediAnno $c.N $annoRecente $Ora
  $col = if ($r.Esito -eq "OK") { "Green" } elseif ($r.Esito -like "ERRORE*") { "Red" } else { "DarkGray" }
  Riga ("   {0,-16} {1,-28} {2}  ({3} byte)" -f $c.N, $c.Che, $r.Esito, $r.Byte) $col
  if ($r.Esito -eq "OK") { [void]$vivi.Add($c) }
}

$ctrl = @($candidati | Where-Object { $_.N -eq "EURUSD" })
$ctrlOk = @($vivi | Where-Object { $_.N -eq "EURUSD" }).Count -gt 0
Riga ""
if (-not $ctrlOk) {
  Riga "!!! IL CONTROLLO POSITIVO E' FALLITO: nemmeno EURUSD risponde." "Red"
  Riga "    Quindi NON e' Dukascopy che non ha i dati: e' la connessione." "Red"
  Riga "    Nessun 'ASSENTE' di questa corsa vale niente. Controlla rete/proxy" "Red"
  Riga "    e rilancia. (Se sei dietro un proxy aziendale, provalo da casa.)" "Red"
  Riga ""
}

# --- 2. fin dove indietro? -------------------------------------------
Riga "2) per i simboli vivi: fin dove arriva lo storico" "Yellow"
$righe = New-Object System.Collections.ArrayList
foreach ($c in $vivi) {
  Riga ("   --- " + $c.N + "  (" + $c.Che + ") ---") "White"
  $primoAnnoOk = 0
  foreach ($anno in $anniLista) {
    $r = ChiediAnno $c.N $anno $Ora
    $col = if ($r.Esito -eq "OK") { "Green" } else { "DarkGray" }
    Riga ("       {0}   {1,-10} {2} byte" -f $anno, $r.Esito, $r.Byte) $col
    [void]$righe.Add([pscustomobject]@{
      Simbolo=$c.N; Che=$c.Che; Anno=$anno; Esito=$r.Esito; Byte=$r.Byte; Url=$r.Url
    })
    if ($r.Esito -eq "OK" -and $primoAnnoOk -eq 0) { $primoAnnoOk = $anno }
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
  [void]$sb.AppendLine(("{0,-16} {1}  {2,-10} {3} byte" -f $r.Simbolo, $r.Anno, $r.Esito, $r.Byte))
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
