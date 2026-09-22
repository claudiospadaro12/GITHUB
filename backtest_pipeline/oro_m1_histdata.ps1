# MARCATORE_ORO_M1_HISTDATA_v1
# =====================================================================
#  oro_m1_histdata.ps1  --  SCARICA L'ORO M1 2021-2026 DA HISTDATA
#                           E PREPARA LO ZIP DA MANDARE
# ---------------------------------------------------------------------
#  PERCHE' ESISTE (22/09/2026)
#  report\ANATOMIA_ESPLOSIONI_ORO_2026-09-22.md gira su 4.884.366 barre
#  M1 di feed Oanda, marzo 2006 -> maggio 2020. Il 2021-2026 manca:
#  dalla sessione di sviluppo Dukascopy, HistData, Stooq, Yahoo e
#  Binance sono tutti murati dal proxy (connect_rejected per policy);
#  passa solo raw.githubusercontent.com, da cui viene l'Oanda.
#  HistData invece si raggiunge da questa macchina: lo dimostra il
#  15/08/2026, quando da qui sono arrivate 2.432.995 barre M1 di
#  XAUUSD (backtest_pipeline\risultati_archivio\REFERTO_IMPORT_6_SIMBOLI.md).
#
#  #################################################################
#  #  LA REGOLA CHE VIENE PRIMA DI TUTTO:                          #
#  #  IL 2021-2026 NON SI CONCATENA CON L'OANDA 2006-2020.         #
#  #  Sono due feed diversi: quote, spread e perfino il minuto di   #
#  #  stacco cambiano, e una discontinuita' di feed puo' spostare   #
#  #  le percentuali orarie SENZA che il mercato sia cambiato.      #
#  #  Si misura come FINESTRA SEPARATA e si CONFRONTA: se il        #
#  #  ritrovamento delle 09:30 di New York si riproduce su un ALTRO #
#  #  feed in un'ALTRA epoca, vale piu' di una serie piu' lunga.    #
#  #################################################################
#
#  CHE COSA FA, IN ORDINE
#   1. si rifiuta di girare su una macchina che non sia il PC di
#      backtest (fail-closed: stampa il nome trovato ed esce)
#   2. scarica gli ZIP M1 di HistData: ANNUALI per gli anni chiusi,
#      MENSILI per l'anno in corso (HistData pubblica cosi')
#   3. VERIFICA ogni zip: firma PK, dimensione minima, e lo apre per
#      contare le righe e leggere la PRIMA e l'ULTIMA
#   4. scrive RIEPILOGO.txt con righe, prima/ultima data e SHA256
#   5. mette tutto sul Desktop e crea lo ZIP pronto da mandare
#
#  CHE COSA NON FA -- ed e' la ragione per cui e' scritto cosi'
#   NON apre nessun terminale. NON ne chiude nessuno. NON compila
#   niente. NON scrive dentro nessuna cartella dati di MT5. NON tocca
#   nessun grafico, nessun preset, nessun parametro di rischio.
#   La prova si fa col grep, non con la fiducia: in questo file NON
#   compare nessun cmdlet che avvia o termina processi, ne' il nome di
#   nessun eseguibile di MT5. I nomi NON si scrivono nemmeno qui in
#   negativo (classe 564: il bollo di sicurezza trova la stringa
#   proibita proprio nel commento che dichiara di non usarla, e la
#   riga si rifiuta di eseguire il proprio script). Il verso giusto e'
#   la RICERCA sul file, ed e' scritta nel documento di consegna.
#   Quindi qualunque cosa stia operando su questa macchina o altrove
#   NON viene sfiorata da questa riga.
#
#  COME SI LANCIA
#  La riga vera sta in report\ORO_M1_2021_2026_PIANO_2026-09-22.md, par. 5,
#  ed e' PINNATA A UN COMMIT (non al branch) e controlla il MARCATORE qui
#  sopra prima di eseguire. Qui NON se ne scrive una copia: una copia in un
#  commento invecchia, resta pinnata al branch e qualcuno la incolla.
#
#  VARIANTI
#   -Da 2021 -A 2026      anni da prendere (default 2021-2026)
#   -SaltaDownload        usa solo gli zip gia' in cartella
#   -SoloRaccolta         non scarica: rifa' solo verifica + zip
#   -CartellaZip "..."    dove stanno (o dove finiscono) gli zip
#
#  NIENTE EMOJI IN QUESTO FILE: Windows PowerShell 5.1 legge i .ps1
#  come ANSI e un'emoji dentro una stringa fa esplodere il parser
#  (regola di casa del 17/08). ASCII puro, senza eccezioni.
# =====================================================================
param(
  [int]    $Da          = 2021,
  [int]    $A           = 2026,
  [string] $Simbolo     = "XAUUSD",
  [string] $CartellaZip = "",
  [switch] $SaltaDownload,
  [switch] $SoloRaccolta
)

$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

function Muori($t){ Write-Host ""; Write-Host ("!!! " + $t) -ForegroundColor Red; exit 1 }

# ---------------------------------------------------------------------
# 1. LA GUARDIA DELLA MACCHINA -- fail-closed, nessun ripiego
# ---------------------------------------------------------------------
#  Questa riga ha senso su UNA macchina sola: quella da cui HistData si
#  raggiunge, cioe' il PC di backtest. Altrove non deve nemmeno provare
#  a scaricare. Il confronto e' ORDINALE (come nel blocco condiviso dei
#  tre .ps1 di sicurezza): il -eq di PowerShell passa dalla cultura del
#  thread, e sotto certe culture due stringhe DIVERSE risultano uguali.
#  IgnoreCase si', perche' i nomi NetBIOS non distinguono maiuscole.
#  Se il nome non corrisponde NON si indovina e NON si forza: si stampa
#  il nome trovato e ci si ferma, cosi' chi legge ha un fatto in mano.
# ---------------------------------------------------------------------
$MACCHINA_ATTESA = "DESKTOP-H4D7CAJ"
$macchina = ""
if ($env:COMPUTERNAME) { $macchina = ([string]$env:COMPUTERNAME).Trim() }
if (-not [string]::Equals($macchina, $MACCHINA_ATTESA, [StringComparison]::OrdinalIgnoreCase)) {
  Write-Host ""
  Write-Host "STOP: questa riga gira SOLO sul PC di backtest." -ForegroundColor Red
  Write-Host ("    macchina attesa : " + $MACCHINA_ATTESA) -ForegroundColor Red
  Write-Host ("    macchina trovata: '" + $macchina + "'") -ForegroundColor Red
  Write-Host "    NON forzo e NON indovino: se il PC e' stato rinominato, manda" -ForegroundColor Red
  Write-Host "    questo nome e la riga torna aggiornata dal cancello." -ForegroundColor Red
  exit 1
}

$Work = Join-Path $env:USERPROFILE "abtg_oro_m1"
New-Item -ItemType Directory -Force -Path $Work | Out-Null
if ([string]::IsNullOrWhiteSpace($CartellaZip)) { $CartellaZip = Join-Path $Work "zip" }
New-Item -ItemType Directory -Force -Path $CartellaZip | Out-Null

Write-Host ""
Write-Host "=== ORO M1 DA HISTDATA ==============================================" -ForegroundColor Cyan
Write-Host ("    macchina : " + $macchina) -ForegroundColor White
Write-Host ("    simbolo  : " + $Simbolo) -ForegroundColor White
Write-Host ("    anni     : " + $Da + " - " + $A) -ForegroundColor White
Write-Host ("    zip in   : " + $CartellaZip) -ForegroundColor White
Write-Host "    NESSUN terminale viene aperto, chiuso o toccato da questa riga." -ForegroundColor White
Write-Host "=====================================================================" -ForegroundColor Cyan

# ---------------------------------------------------------------------
# 2. L'ELENCO DEI PEZZI DA PRENDERE
# ---------------------------------------------------------------------
#  HistData pubblica gli anni CHIUSI in un unico zip annuale, e l'anno
#  IN CORSO un mese per volta. Chiedere l'annuale dell'anno in corso
#  torna una pagina, non uno zip: per questo i due casi sono separati.
#  L'anno in corso si spezza nei mesi gia' pubblicati, cioe' fino al
#  mese PRECEDENTE a quello di oggi compreso (il mese corrente viene
#  tentato lo stesso: se non c'e' ancora, finisce nella lista di quelli
#  da prendere a mano e NON blocca il resto).
# ---------------------------------------------------------------------
$oggi = Get-Date
$pezzi = @()
for ($y = $Da; $y -le $A; $y++) {
  if ($y -lt $oggi.Year) {
    $pezzi += ,@($y, 0, ("HISTDATA_COM_ASCII_{0}_M1_{1}.zip" -f $Simbolo, $y), ("{0}" -f $y), 500000)
  } elseif ($y -eq $oggi.Year) {
    for ($m = 1; $m -le $oggi.Month; $m++) {
      $per = "{0}{1:D2}" -f $y, $m
      $pezzi += ,@($y, $m, ("HISTDATA_COM_ASCII_{0}_M1_{1}.zip" -f $Simbolo, $per), $per, 20000)
    }
  } else {
    Write-Host ("  " + $y + ": e' nel futuro, salto.") -ForegroundColor DarkGray
  }
}
if ($pezzi.Count -eq 0) { Muori "nessun anno da prendere: controlla -Da e -A." }

# ---------------------------------------------------------------------
# 3. DOWNLOAD
# ---------------------------------------------------------------------
#  HistData non espone un link diretto: il bottone DOWNLOAD e' un form
#  che fa POST a get.php con un token 'tk' generato nella pagina, e il
#  server rifiuta senza Referer. E' la STESSA meccanica gia' usata e
#  gia' riuscita da questa macchina il 15/08/2026 in
#  importa_storico_esterno.ps1: qui non c'e' niente di nuovo, c'e' solo
#  un altro elenco di periodi. Se il sito cambia, NON si insiste: si
#  passa alla strada a mano, che e' scritta per esteso piu' sotto.
# ---------------------------------------------------------------------
function Url-Pagina($sym, $per) {
  $s = $sym.ToLower()
  if ($per.Length -eq 6) {
    return ("https://www.histdata.com/download-free-forex-historical-data/?/ascii/1-minute-bar-quotes/" + $s + "/" + $per.Substring(0,4) + "/" + [int]$per.Substring(4,2))
  }
  return ("https://www.histdata.com/download-free-forex-historical-data/?/ascii/1-minute-bar-quotes/" + $s + "/" + $per)
}

function Prova-Download($sym, $per, $destZip, $minByte) {
  $pagina = Url-Pagina $sym $per
  try {
    $sess = $null
    $r = Invoke-WebRequest -Uri $pagina -SessionVariable sess -UseBasicParsing -TimeoutSec 60
    $tk = [regex]::Match($r.Content, 'id="tk"[^>]*value="([^"]+)"').Groups[1].Value
    if (-not $tk) { $tk = [regex]::Match($r.Content, 'name="tk"[^>]*value="([^"]+)"').Groups[1].Value }
    if (-not $tk) { return $false }
    $anno = $per.Substring(0,4)
    $mese = ""
    if ($per.Length -eq 6) { $mese = ([int]$per.Substring(4,2)).ToString() }
    $body = @{
      tk        = $tk
      date      = $anno
      datemonth = $per
      platform  = "ASCII"
      timeframe = "M1"
      fxpair    = $sym.ToUpper()
    }
    if ($mese -ne "") { $body["datemonth"] = ($anno + $mese.PadLeft(2,'0')) }
    $hdr = @{ Referer = $pagina; "User-Agent" = "Mozilla/5.0" }
    Invoke-WebRequest -Uri "https://www.histdata.com/get.php" -Method Post -Body $body `
                      -WebSession $sess -Headers $hdr -OutFile $destZip -UseBasicParsing -TimeoutSec 600
    if (-not (Test-Path $destZip)) { return $false }
    # se il sito risponde HTML il file esiste lo stesso: si guarda la firma
    $fs = [System.IO.File]::OpenRead($destZip)
    $b1 = $fs.ReadByte(); $b2 = $fs.ReadByte(); $fs.Close()
    if ($b1 -ne 0x50 -or $b2 -ne 0x4B) { Remove-Item $destZip -Force -ErrorAction SilentlyContinue; return $false }
    if ((Get-Item $destZip).Length -lt $minByte) { Remove-Item $destZip -Force -ErrorAction SilentlyContinue; return $false }
    return $true
  } catch {
    if (Test-Path $destZip) { Remove-Item $destZip -Force -ErrorAction SilentlyContinue }
    return $false
  }
}

$mancanti = @()
if (-not $SoloRaccolta) {
  Write-Host ""
  Write-Host "--- DOWNLOAD --------------------------------------------------------" -ForegroundColor Cyan
  foreach ($p in $pezzi) {
    $nome = $p[2]; $per = $p[3]; $minByte = $p[4]
    $dest = Join-Path $CartellaZip $nome
    if (Test-Path $dest) { Write-Host ("  gia' presente: " + $nome) -ForegroundColor DarkGray; continue }
    if ($SaltaDownload)  { $mancanti += ,@($nome, (Url-Pagina $Simbolo $per)); continue }
    Write-Host ("  scarico " + $nome + " ...") -ForegroundColor DarkGray
    if (Prova-Download $Simbolo $per $dest $minByte) {
      Write-Host ("  OK  " + $nome) -ForegroundColor Green
    } else {
      Write-Host ("  NON riuscito: " + $nome) -ForegroundColor Yellow
      $mancanti += ,@($nome, (Url-Pagina $Simbolo $per))
    }
  }
}

if ($mancanti.Count -gt 0) {
  Write-Host ""
  Write-Host "--- QUESTI VANNO PRESI A MANO (bastano pochi minuti) ----------------" -ForegroundColor Yellow
  Write-Host "Per ognuno: apri il link, premi DOWNLOAD, salva lo ZIP SENZA" -ForegroundColor Yellow
  Write-Host "rinominarlo dentro questa cartella:" -ForegroundColor Yellow
  Write-Host ("   " + $CartellaZip) -ForegroundColor White
  Write-Host ""
  foreach ($m in $mancanti) {
    Write-Host ("   " + $m[0]) -ForegroundColor White
    Write-Host ("      " + $m[1]) -ForegroundColor DarkGray
  }
  Write-Host ""
  Write-Host "Poi rilancia la STESSA riga aggiungendo -SoloRaccolta." -ForegroundColor Yellow
  Write-Host "---------------------------------------------------------------------" -ForegroundColor Yellow
}

# ---------------------------------------------------------------------
# 4. VERIFICA -- si apre ogni zip e si CONTA, non si assume
# ---------------------------------------------------------------------
#  Uno zip valido che contiene il simbolo sbagliato, o mezzo anno, o
#  una pagina d'errore rinominata, pesa e si apre lo stesso. L'unica
#  prova che dentro ci sia quello che crediamo e' leggere la prima e
#  l'ultima riga e contare quelle in mezzo. Il numero atteso per un
#  anno pieno di oro M1 e' dell'ordine di 340.000-380.000 barre; un
#  mese sta sui 28.000-33.000. Numeri molto piu' bassi si vedono qui,
#  non dopo il viaggio.
# ---------------------------------------------------------------------
$Estratti = Join-Path $Work "estratti"
if (Test-Path $Estratti) { Remove-Item $Estratti -Recurse -Force -ErrorAction SilentlyContinue }
New-Item -ItemType Directory -Force -Path $Estratti | Out-Null

$rip = New-Object System.Collections.ArrayList
$totRighe = 0
$zipBuoni = 0

Write-Host ""
Write-Host "--- VERIFICA --------------------------------------------------------" -ForegroundColor Cyan
foreach ($p in $pezzi) {
  $nome = $p[2]
  $zipPath = Join-Path $CartellaZip $nome
  if (-not (Test-Path $zipPath)) {
    [void]$rip.Add(("{0,-44} MANCANTE" -f $nome))
    Write-Host ("  " + $nome + " : MANCANTE") -ForegroundColor Yellow
    continue
  }
  $sha = (Get-FileHash -Path $zipPath -Algorithm SHA256).Hash
  $kb  = [int]((Get-Item $zipPath).Length / 1KB)
  $dirP = Join-Path $Estratti ($nome -replace '\.zip$','')
  New-Item -ItemType Directory -Force -Path $dirP | Out-Null
  # Expand-Archive e non [ZipFile]::ExtractToDirectory: la seconda, sul
  # .NET Framework che sta sotto PowerShell 5.1, SOLLEVA un'eccezione se
  # la cartella di destinazione esiste gia' -- e qui la creiamo noi una
  # riga sopra. Expand-Archive -Force e' anche quella gia' usata e gia'
  # riuscita da questa macchina il 15/08 in importa_storico_esterno.ps1.
  try {
    Expand-Archive -Path $zipPath -DestinationPath $dirP -Force
  } catch {
    [void]$rip.Add(("{0,-44} ZIP ILLEGGIBILE (riscaricalo)" -f $nome))
    Write-Host ("  " + $nome + " : ZIP ILLEGGIBILE") -ForegroundColor Red
    continue
  }
  $csv = Get-ChildItem $dirP -Filter "*.csv" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
  if (-not $csv) {
    [void]$rip.Add(("{0,-44} NESSUN CSV DENTRO" -f $nome))
    Write-Host ("  " + $nome + " : NESSUN CSV DENTRO") -ForegroundColor Red
    continue
  }
  $n = 0; $prima = ""; $ultima = ""
  $sr = New-Object System.IO.StreamReader($csv.FullName)
  while (($riga = $sr.ReadLine()) -ne $null) {
    if ($riga.Length -lt 10) { continue }
    if ($n -eq 0) { $prima = $riga }
    $ultima = $riga
    $n++
  }
  $sr.Close()
  $totRighe += $n
  $zipBuoni++
  [void]$rip.Add(("{0,-44} {1,8} righe  {2}  ->  {3}  [{4} KB]  SHA256 {5}" -f `
                  $nome, $n, $prima.Substring(0,[Math]::Min(15,$prima.Length)), `
                  $ultima.Substring(0,[Math]::Min(15,$ultima.Length)), $kb, $sha))
  Write-Host ("  " + $nome + " : " + $n + " righe   " + $prima.Substring(0,[Math]::Min(15,$prima.Length)) + " -> " + $ultima.Substring(0,[Math]::Min(15,$ultima.Length))) -ForegroundColor Green
}

if ($zipBuoni -eq 0) { Muori "nessuno zip valido: non c'e' niente da mandare." }

# ---------------------------------------------------------------------
# 5. RACCOLTA SUL DESKTOP + ZIP PRONTO DA MANDARE
# ---------------------------------------------------------------------
$Desktop = [Environment]::GetFolderPath("Desktop")
$dest = Join-Path $Desktop "ORO_M1_HISTDATA"
if (Test-Path $dest) { Remove-Item $dest -Recurse -Force -ErrorAction SilentlyContinue }
New-Item -ItemType Directory -Force -Path $dest | Out-Null

foreach ($p in $pezzi) {
  $src = Join-Path $CartellaZip $p[2]
  if (Test-Path $src) { Copy-Item $src -Destination $dest -Force }
}

$riepilogo = Join-Path $dest "RIEPILOGO.txt"
$testa = @()
$testa += "MARCATORE_ORO_M1_HISTDATA_v1"
$testa += ("generato il  : " + (Get-Date -Format "yyyy-MM-dd HH:mm:ss"))
$testa += ("macchina     : " + $macchina)
$testa += ("simbolo      : " + $Simbolo)
$testa += ("anni chiesti : " + $Da + " - " + $A)
$testa += ("zip validi   : " + $zipBuoni + " su " + $pezzi.Count)
$testa += ("righe M1 tot : " + $totRighe)
$testa += ""
$testa += "FUSO DEI FILE: i timestamp HistData sono ORA LOCALE DI NEW YORK,"
$testa += "calendario DST USA (misurato in casa il 18/08/2026). La conversione"
$testa += "a UTC NON viene fatta qui: la fa histdata_oro_verso_utc.py, che la"
$testa += "COLLAUDA su due ancore prima di scrivere. Questi file NON sono in UTC."
$testa += ""
$testa += "FORMATO DELLE RIGHE: AAAAMMGG HHMMSS;O;H;L;C;V  (punto e virgola)."
$testa += ""
$testa += "DETTAGLIO PER FILE"
($testa + $rip) | Set-Content -Path $riepilogo -Encoding ASCII

$zipFinale = Join-Path $Desktop "oro_m1_histdata.zip"
if (Test-Path $zipFinale) { Remove-Item $zipFinale -Force }
Compress-Archive -Path (Join-Path $dest "*") -DestinationPath $zipFinale -Force

Write-Host ""
Write-Host "--- COSA C'E' NELLA CARTELLA ----------------------------------------" -ForegroundColor Cyan
Get-ChildItem $dest | Select-Object Name, Length | Format-Table -AutoSize
$mb = [math]::Round((Get-Item $zipFinale).Length / 1MB, 1)
Write-Host ""
Write-Host ("ZIP PRONTO DA MANDARE: " + $zipFinale + "  (" + $mb + " MB)") -ForegroundColor Green
Write-Host ("Dentro: RIEPILOGO.txt + " + $zipBuoni + " zip HistData.") -ForegroundColor Green
Write-Host ("Righe M1 in tutto: " + $totRighe) -ForegroundColor Green
if ($mancanti.Count -gt 0) {
  Write-Host ("ATTENZIONE: " + $mancanti.Count + " pezzi non scaricati (elenco qui sopra).") -ForegroundColor Yellow
  Write-Host "Si puo' mandare lo stesso: la finestra sara' piu' corta, e il" -ForegroundColor Yellow
  Write-Host "RIEPILOGO.txt dice esattamente quali mancano." -ForegroundColor Yellow
}
Write-Host ""
