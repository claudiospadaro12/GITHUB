# =====================================================================
#  archivia_test_desktop.ps1 -- MARCATORE_ARCHIVIA_V2
#  Mette ORDINE sul Desktop del PC di backtest: tutte le cartelle e gli
#  zip dei TEST finiscono in UNA cartella sola (Desktop\ARCHIVIO_TEST),
#  rinominati con la data davanti (aaaa-mm-gg_hhmm_nome) cosi' l'ordine
#  alfabetico E' l'ordine cronologico: il meno recente in cima, l'ultimo
#  test sempre IN FONDO alla sequenza.
#
#  Richiesta di Claudio del 23/08/2026: "metti in una cartella sola in
#  ordine dal meno recente le cartelle dei test... e quando facciamo un
#  test la cartella zippata deve finire alla fine della sequenza".
#
#  COME FUNZIONA:
#  - SPOSTA (mai cancella) dal Desktop dentro ARCHIVIO_TEST tutto cio'
#    che corrisponde ai pattern dei NOSTRI test (lista chiusa, sotto):
#    niente pattern = niente spostamento. Le cartelle personali non
#    vengono toccate.
#  - Il prefisso data e' l'ULTIMA MODIFICA VERA (per le cartelle: il
#    massimo ricorsivo, non il LastWriteTime della radice, che NON si
#    aggiorna quando si scrive dentro una sottocartella).
#  - E' RIESEGUIBILE: ogni nuovo lancio raccoglie solo i test nuovi
#    comparsi sul Desktop e li accoda (la data li mette in fondo da soli).
#  - `-Installa` copia lo script in C:\ABTG e crea un'attivita'
#    pianificata giornaliera (23:30) che lo rilancia da sola
#    (stesso schema di scarica_pagella.ps1 -Installa).
#
#  SICUREZZE (le stesse del gemello riordina_desktop.ps1 del 14/08):
#  - `-Prova`   : anteprima, non muove niente;
#  - LOG CSV    : Origine,Destinazione di ogni spostamento;
#  - `-Annulla` : rimette tutto com'era leggendo l'ultimo log;
#  - programmi, script e collegamenti NON si toccano MAI
#    (.ps1 .py .exe .bat .cmd .lnk .url .msi .mq5 .mqh .ex5 .dll):
#    sul Desktop ci vivono gli STRUMENTI delle righe di lancio
#    (conferma_apertura_*.ps1, walkforward_*, verifica_*.ps1...) e
#    spostarli rompe le righe che li invocano per percorso fisso;
#  - una corsa IN CORSO non viene archiviata: tutto cio' che e' stato
#    scritto negli ultimi -MinutiFermo minuti (default 30) si SALTA.
#    L'attivita' delle 23:30 cade in mezzo ai round da 2-6 ore, che
#    scrivono le loro cartelle sul Desktop mentre girano.
#
#  PERIMETRO: si scandiscono TUTTI i Desktop distinti che esistono
#  (GetFolderPath + %USERPROFILE%\Desktop + OneDrive\Desktop), perche'
#  le righe di round scrivono in %USERPROFILE%\Desktop mentre
#  GetFolderPath puo' puntare altrove se il Desktop e' reindirizzato.
#
#  NON tocca MT5, non tocca il repo, non cancella niente.
#
#  USO:
#    powershell -ExecutionPolicy Bypass -File .\archivia_test_desktop.ps1 -Prova
#    powershell -ExecutionPolicy Bypass -File .\archivia_test_desktop.ps1
#    powershell -ExecutionPolicy Bypass -File .\archivia_test_desktop.ps1 -Installa
#    powershell -ExecutionPolicy Bypass -File .\archivia_test_desktop.ps1 -Annulla
# =====================================================================
param(
  [switch]$Installa,
  [switch]$Prova,
  [switch]$Annulla,
  [int]$MinutiFermo = 30
)
$ErrorActionPreference = "Stop"
$INV = [System.Globalization.CultureInfo]::InvariantCulture

# --- i Desktop: TUTTI quelli distinti che esistono davvero ------------
function Trova-Desktop {
  $lista = New-Object System.Collections.ArrayList
  $cand = @()
  try { $cand += [Environment]::GetFolderPath("Desktop") } catch {}
  $cand += (Join-Path $env:USERPROFILE "Desktop")
  $cand += (Join-Path $env:USERPROFILE "OneDrive\Desktop")
  foreach ($p in $cand) {
    if (-not $p) { continue }
    if (-not (Test-Path -LiteralPath $p)) { continue }
    $full = (Get-Item -LiteralPath $p).FullName.TrimEnd('\')
    $gia = $false
    foreach ($q in $lista) { if ($q -eq $full) { $gia = $true } }
    if (-not $gia) { [void]$lista.Add($full) }
  }
  return @($lista)
}
# @(...) OBBLIGATORIO: con UN solo Desktop (il caso normale) PowerShell
# srotola l'array in una STRINGA e $Desktops[0] tornerebbe il primo
# CARATTERE ("C"), facendo nascere l'archivio in "C\ARCHIVIO_TEST".
$Desktops = @(Trova-Desktop)
if ($Desktops.Count -eq 0) {
  Write-Host "NESSUN Desktop trovato: non c'e' niente da archiviare." -ForegroundColor Red
  exit 2
}
$Principale = $Desktops[0]
$Archivio = Join-Path $Principale "ARCHIVIO_TEST"
$LogDir   = Join-Path $Archivio "_log"

# --- ANNULLA: rimette tutto com'era leggendo l'ultimo log CSV ---------
if ($Annulla) {
  # l'ultimo log NON VUOTO: un giro che non ha mosso niente non deve
  # coprire il log del giro che invece aveva mosso (altrimenti -Annulla
  # e' un comando decorativo che dice "0 rimessi a posto" per sempre).
  $ultimo = Get-ChildItem -LiteralPath $LogDir -Filter "archivio_*.csv" -ErrorAction SilentlyContinue |
            Sort-Object LastWriteTime -Descending |
            Where-Object { @(Import-Csv -LiteralPath $_.FullName).Count -gt 0 } |
            Select-Object -First 1
  if (-not $ultimo) { Write-Host "Nessuno spostamento da annullare in $LogDir" -ForegroundColor Yellow; exit 0 }
  Write-Host ("ANNULLO usando " + $ultimo.Name) -ForegroundColor Cyan
  $n = 0; $ko = 0
  foreach ($r in (Import-Csv -LiteralPath $ultimo.FullName)) {
    if (-not (Test-Path -LiteralPath $r.Destinazione)) { continue }
    try {
      $padre = Split-Path -Parent $r.Origine
      if (-not (Test-Path -LiteralPath $padre)) { New-Item -ItemType Directory -Force -Path $padre | Out-Null }
      if (Test-Path -LiteralPath $r.Origine) { throw "l'originale esiste gia': non sovrascrivo" }
      Move-Item -LiteralPath $r.Destinazione -Destination $r.Origine -ErrorAction Stop
      $n++
    } catch {
      Write-Host ("  NON riportato: " + $r.Destinazione + " -- " + $_.Exception.Message) -ForegroundColor Yellow
      $ko++
    }
  }
  Write-Host ("Rimessi a posto: " + $n + "   non riportati: " + $ko)
  if ($ko -gt 0) { exit 1 }
  exit 0
}

New-Item -ItemType Directory -Force -Path $Archivio | Out-Null
New-Item -ItemType Directory -Force -Path $LogDir   | Out-Null

# --- la LISTA CHIUSA dei nomi dei nostri test -------------------------
#  ATTENZIONE: sono REGEX (-match), NON wildcard (-like). In -like le
#  parentesi quadre sono un set di UN carattere e il '+' e' LETTERALE:
#  'R[0-9]+_*' matcherebbe solo 'R5+_...' e NON prenderebbe mai R97_/R100_.
#  Verificato eseguendo, 23/08/2026.
#  'pagella_' NON e' in lista di proposito: la pagella serale la scrive
#  l'attivita' delle 23:15 sul Desktop e recupera_100k.ps1 la CERCA li'.
$Regex = @(
  '^R[0-9]+[_-]',      # R97_ORB_NASUSD_CORSA_*, R100_ORO_FLOTTA_*, ecc.
  '^risultati_',       # test_orb_toolkit e simili
  '^verifica_',        # verifica_orb*, verifica_autotest_*, verifica_a1_*
  '^config_dax',
  '^config_in_uso',
  '^OptReport',
  '^ini_orb',
  '^src_v2',
  '^walkforward_',
  '^censimento_',
  '^referto_'
)
# --- cio' che non si tocca MAI (esclusioni dichiarate dal gemello) ----
$EstensioniMai = @('.ps1','.py','.exe','.bat','.cmd','.lnk','.url','.msi','.mq5','.mqh','.ex5','.dll','.sys')
$NomiMai = @('ARCHIVIO_TEST','ABTG_RISULTATI','ABTG_ZIP','ABTG_DOCUMENTI','ABTG_VARIE','ABTG_ORDINE_LOG','desktop.ini')

# ultima modifica VERA: per una cartella il LastWriteTime della radice
# NON cambia quando si scrive dentro una sottocartella (verificato).
function Ultima-Modifica($v) {
  $t = $v.LastWriteTime
  if ($v.PSIsContainer) {
    $figli = @(Get-ChildItem -LiteralPath $v.FullName -Recurse -Force -ErrorAction SilentlyContinue)
    foreach ($f in $figli) { if ($f.LastWriteTime -gt $t) { $t = $f.LastWriteTime } }
  }
  return $t
}

$stamp   = (Get-Date).ToString("yyyy-MM-dd_HHmm", $INV)
$LogCsv  = Join-Path $LogDir ("archivio_" + $stamp + ".csv")
$Righe   = New-Object System.Collections.ArrayList
$mossi = 0; $saltati = 0; $inCorso = 0; $strumenti = 0
$adesso = Get-Date

Write-Host ""
Write-Host "=== PERIMETRO SCANDITO ===" -ForegroundColor Cyan
foreach ($d in $Desktops) { Write-Host ("  " + $d) }
Write-Host ("  archivio  : " + $Archivio)
if ($Prova) { Write-Host "  MODO      : PROVA (non muovo niente)" -ForegroundColor Yellow }
Write-Host ""

foreach ($Desktop in $Desktops) {
  $voci = @(Get-ChildItem -LiteralPath $Desktop -Force -ErrorAction SilentlyContinue)
  foreach ($v in $voci) {

    $salta = $false
    foreach ($nm in $NomiMai) { if ($v.Name -eq $nm) { $salta = $true } }
    if ($salta) { continue }
    if ($v.FullName -like ($Archivio + '*')) { continue }

    # il nome corrisponde a un test? (REGEX, non wildcard)
    $match = $false
    foreach ($rx in $Regex) { if ($v.Name -match $rx) { $match = $true; break } }
    if (-not $match) { continue }

    # gli STRUMENTI non si archiviano: le righe di lancio li invocano
    # per percorso fisso sul Desktop.
    if (-not $v.PSIsContainer) {
      $est = $v.Extension.ToLowerInvariant()
      $vietata = $false
      foreach ($e in $EstensioniMai) { if ($est -eq $e) { $vietata = $true } }
      if ($vietata) {
        Write-Host ("  NON archiviato (e' uno strumento, non un risultato): " + $v.Name) -ForegroundColor Gray
        $strumenti++
        continue
      }
    }

    # una corsa ancora in scrittura non si sposta sotto i piedi al driver
    $ultima = Ultima-Modifica $v
    $eta = (New-TimeSpan -Start $ultima -End $adesso).TotalMinutes
    if ($eta -lt $MinutiFermo) {
      Write-Host ("  SALTATO (scritto " + [int]$eta + " min fa: corsa in corso?): " + $v.Name) -ForegroundColor Yellow
      $inCorso++
      continue
    }

    $prefisso = $ultima.ToString("yyyy-MM-dd_HHmm", $INV)
    if ($v.Name -match '^\d{4}-\d{2}-\d{2}_\d{4}_') { $nuovo = $v.Name }   # gia' prefissato
    else { $nuovo = $prefisso + "_" + $v.Name }

    $dest = Join-Path $Archivio $nuovo
    $k = 1; $libero = $true
    while (Test-Path -LiteralPath $dest) {
      if ($k -gt 99) { $libero = $false; break }
      $dest = Join-Path $Archivio ($nuovo + "_" + $k)
      $k++
    }
    if (-not $libero) {
      Write-Host ("  NON archiviato (100 nomi gia' occupati): " + $v.Name) -ForegroundColor Yellow
      $saltati++
      continue
    }

    if ($Prova) {
      Write-Host ("  [PROVA] " + $v.Name + "  ->  " + (Split-Path -Leaf $dest)) -ForegroundColor Cyan
      $mossi++
      continue
    }

    try {
      Move-Item -LiteralPath $v.FullName -Destination $dest -ErrorAction Stop
      # la verifica si fa sul RISULTATO, non sul nome: Move-Item su una
      # destinazione che esiste come cartella ci INFILA dentro la roba
      # senza errore (verificato).
      if (-not (Test-Path -LiteralPath $dest)) { throw "spostato ma non trovato in destinazione" }
      [void]$Righe.Add((New-Object PSObject -Property @{ Origine = $v.FullName; Destinazione = $dest }))
      Write-Host ("  archiviato: " + $v.Name + "  ->  " + (Split-Path -Leaf $dest)) -ForegroundColor Green
      $mossi++
    } catch {
      Write-Host ("  NON spostato (in uso?): " + $v.Name + "  -- " + $_.Exception.Message) -ForegroundColor Yellow
      $saltati++
    }
  }
}

# il log si scrive solo se c'e' qualcosa da annullare (vedi -Annulla)
if (-not $Prova -and $Righe.Count -gt 0) {
  $Righe | Select-Object Origine, Destinazione | Export-Csv -LiteralPath $LogCsv -NoTypeInformation -Encoding UTF8
} else { $LogCsv = "(niente spostato: nessun log)" }

$tot = @(Get-ChildItem -LiteralPath $Archivio -Force -ErrorAction SilentlyContinue |
         Where-Object { $_.Name -ne '_log' -and $_.Name -ne '_ultimo_archivio.txt' }).Count

$referto = Join-Path $Archivio "_ultimo_archivio.txt"
$R = New-Object System.Collections.ArrayList
[void]$R.Add("data: " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss", $INV))
[void]$R.Add("modo: " + $(if ($Prova) { "PROVA" } else { "REALE" }))
foreach ($d in $Desktops) { [void]$R.Add("desktop scandito: " + $d) }
[void]$R.Add("archiviati in questo giro : " + $mossi)
[void]$R.Add("saltati corsa in corso    : " + $inCorso)
[void]$R.Add("strumenti non toccati     : " + $strumenti)
[void]$R.Add("non spostati (in uso)     : " + $saltati)
[void]$R.Add("totale in ARCHIVIO_TEST   : " + $tot)
[void]$R.Add("log annullabile           : " + $(if ($Prova) { "(nessuno: era una prova)" } else { $LogCsv }))
if (-not $Prova) { Set-Content -LiteralPath $referto -Value $R -Encoding UTF8 }

Write-Host ""
Write-Host ("=== ARCHIVIO TEST ===") -ForegroundColor Cyan
$R | ForEach-Object { Write-Host ("  " + $_) }
Write-Host ("  cartella                  : " + $Archivio)
if ($saltati -gt 0) { Write-Host "  (chiudi i programmi che tengono aperti i file saltati e rilancia)" -ForegroundColor Yellow }
Write-Host ("  Ordina per NOME in Esplora risorse. ATTENZIONE: Esplora mette") -ForegroundColor Gray
Write-Host ("  PRIMA tutte le cartelle e POI tutti i file, quindi l'ultimo test") -ForegroundColor Gray
Write-Host ("  e' in fondo AL SUO GRUPPO (ultima cartella, oppure ultimo .zip).") -ForegroundColor Gray
if (-not $Prova) {
  Write-Host ("  Per annullare TUTTO questo giro:") -ForegroundColor Gray
  Write-Host ("    powershell -ExecutionPolicy Bypass -File <script> -Annulla") -ForegroundColor Gray
}

# --- -Installa: copia stabile in C:\ABTG + attivita' giornaliera 23:30 -
#  Come scarica_pagella.ps1: l'attivita' NON puo' puntare alla copia nel
#  profilo, che la riga di lancio cancella e riscarica a ogni giro.
if ($Installa) {
  $DestDir = "C:\ABTG"
  New-Item -ItemType Directory -Force -Path $DestDir | Out-Null
  $dest = Join-Path $DestDir "archivia_test_desktop.ps1"
  $me = $PSCommandPath
  if (-not $me) { $me = $MyInvocation.MyCommand.Path }
  if (-not $me -or -not (Test-Path -LiteralPath $me)) {
    Write-Host "Impossibile installare: script senza percorso (eseguito inline?). Scaricalo con -OutFile e rilancia." -ForegroundColor Red
    exit 1
  }
  Copy-Item -LiteralPath $me -Destination $dest -Force
  $len = (Get-Item -LiteralPath $me).Length
  $ver = Get-Item -LiteralPath $dest -ErrorAction SilentlyContinue
  if (-not $ver -or $ver.PSIsContainer -or $ver.Length -ne $len) {
    Write-Host "COPIA IN C:\ABTG NON VERIFICATA: non installo l'attivita'." -ForegroundColor Red
    exit 1
  }

  $task = "ABTG_ArchiviaTestDesktop"
  $azione = "powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File $dest"
  $eaOld = $ErrorActionPreference; $ErrorActionPreference = "SilentlyContinue"
  cmd /c "schtasks /Delete /TN $task /F" 2>&1 | Out-Null
  $out = cmd /c "schtasks /Create /TN $task /TR ""$azione"" /SC DAILY /ST 23:30 /F" 2>&1
  $rc = $LASTEXITCODE
  $ErrorActionPreference = $eaOld
  if ($rc -ne 0) {
    Write-Host "ERRORE schtasks:" -ForegroundColor Red
    $out | ForEach-Object { Write-Host ("  " + $_) }
    exit 1
  }
  Write-Host ""
  Write-Host ("Attivita' '" + $task + "' creata: tutti i giorni alle 23:30.") -ForegroundColor Green
  Write-Host ("  script usato dall'attivita': " + $dest) -ForegroundColor Gray
  Write-Host "  LIMITE: gira con l'utente corrente e SOLO se la sua sessione" -ForegroundColor Yellow
  Write-Host "  Windows e' attiva (stesso limite di ABTG_ScaricaPagella). Se il PC" -ForegroundColor Yellow
  Write-Host "  e' spento o l'utente e' disconnesso alle 23:30, il giro si salta:" -ForegroundColor Yellow
  Write-Host "  non si perde niente, riordina il giorno dopo." -ForegroundColor Yellow
}
exit 0
