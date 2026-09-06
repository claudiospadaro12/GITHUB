# =====================================================================
#  MARCATORE_RIORDINA_DESKTOP_v2
#  riordina_desktop.ps1 -- mette in ordine il Desktop (14/08/2026, corretto 06/09/2026)
#  Richiesta di Claudio: "tutto in cartelle in ordine, niente file sparsi".
#
#  COSA FA (in questo ordine):
#    1) crea la struttura ABTG_RISULTATI\<famiglia>, ABTG_ZIP,
#       ABTG_DOCUMENTI (+ ABTG_VARIE solo con -Tutto);
#    2) sposta le cartelle dei round riconosciute dal NOME (bb_, gap_,
#       cost_, larry_, ez_, orb_, oro_, ...) nella famiglia giusta;
#    3) sposta gli .zip in ABTG_ZIP e i documenti sparsi in ABTG_DOCUMENTI;
#    4) scrive un LOG CSV di ogni spostamento riuscito, cosi' si puo'
#       ANNULLARE, e un referto .txt/.zip sul Desktop con l'esito vero.
#
#  COSA NON TOCCA MAI (per non rompere il Desktop):
#    - collegamenti e programmi (.lnk .url .exe .msi .bat .cmd), ANCHE con -Tutto
#    - le cartelle gia' tematiche di Claudio (EASYTREND, INDICATORI,
#      PIANO DI TRADING, ...) e le cartelle-destinazione del gemello
#      RIGA_ORGANIZZA_DESKTOP.ps1 (Slippage_Spread, Collaudo, ...):
#      sono gia' ordine, non si spostano MAI, nemmeno con -Tutto
#    - desktop.ini e i file nascosti/di sistema
#    - una cartella scritta negli ultimi -MinutiFermo minuti (default 30):
#      potrebbe essere un round ancora in corso
#
#  USO (PC di backtest o VPS, PowerShell normale):
#    powershell -ExecutionPolicy Bypass -File .\riordina_desktop.ps1
#        -> ANTEPRIMA: stampa cosa farebbe, NON muove niente
#    powershell -ExecutionPolicy Bypass -File .\riordina_desktop.ps1 -Esegui
#        -> esegue davvero e scrive il log
#    powershell -ExecutionPolicy Bypass -File .\riordina_desktop.ps1 -Esegui -Tutto
#        -> come sopra, ma sposta in ABTG_VARIE anche cio' che non
#           riconosce (sempre tranne programmi, cartelle tematiche e
#           le cartelle-destinazione, MAI incluse anche con -Tutto)
#    powershell -ExecutionPolicy Bypass -File .\riordina_desktop.ps1 -Annulla
#        -> rilegge l'ultimo log NON VUOTO e rimette tutto com'era
# =====================================================================
param(
  [switch]$Esegui,
  [switch]$Tutto,
  [switch]$Annulla,
  [string]$Desktop = "",
  [int]$MinutiFermo = 30
)
$ErrorActionPreference = "Continue"
$INV = [System.Globalization.CultureInfo]::InvariantCulture

if(-not $Desktop -or -not (Test-Path -LiteralPath $Desktop)){
  $Desktop = [Environment]::GetFolderPath("Desktop")
}
if(-not (Test-Path -LiteralPath $Desktop)){ Write-Host "Desktop non trovato." -ForegroundColor Red; exit 1 }

$LogDir = Join-Path $Desktop "ABTG_ORDINE_LOG"
# timbro al SECONDO con cultura invariante: due lanci nello stesso minuto
# non devono sovrascrivere il log/referto l'uno dell'altro (classe 140).
$stamp  = (Get-Date).ToString("yyyy-MM-dd_HHmmss", $INV)

function NomeSenzaCollisione($cartella, $base, $coda) {
  # classe 143-bis: se due giri cadono nello stesso SECONDO, non si vuole
  # che il secondo scavalchi il file/log del primo. Tentativi numerati.
  $cand = Join-Path $cartella ($base + $coda)
  $k = 0
  while(Test-Path -LiteralPath $cand){
    $k++
    $cand = Join-Path $cartella ($base + "_" + $k + $coda)
  }
  return $cand
}

# --- ANNULLA: rilegge l'ultimo log NON VUOTO, NON GIA' USATO, e riporta tutto indietro ---
if($Annulla){
  $ultimo = Get-ChildItem -LiteralPath $LogDir -Filter "riordino_*.csv" -ErrorAction SilentlyContinue |
            Sort-Object LastWriteTime -Descending |
            Where-Object { @(Import-Csv -LiteralPath $_.FullName -ErrorAction SilentlyContinue).Count -gt 0 } |
            Select-Object -First 1
  if(-not $ultimo){
    Write-Host "Nessun log di riordino da annullare (o sono tutti vuoti/gia' usati)." -ForegroundColor Yellow
    $fileA0 = NomeSenzaCollisione $Desktop "annulla_riordino" ("_" + $stamp + ".txt")
    Set-Content -LiteralPath $fileA0 -Value @("ESITO ANNULLAMENTO riordina_desktop","data: " + (Get-Date).ToString("yyyy.MM.dd HH:mm:ss", $INV),"Nessun log da annullare (o tutti gia' usati/vuoti).") -Encoding UTF8
    Write-Host ("Referto: " + $fileA0) -ForegroundColor Gray
    exit 0
  }
  Write-Host ("ANNULLO usando " + $ultimo.Name) -ForegroundColor Cyan
  $n = 0; $ko = 0
  $rilievi = New-Object System.Collections.ArrayList
  foreach($r in (Import-Csv -LiteralPath $ultimo.FullName)){
    try{
      if(-not (Test-Path -LiteralPath $r.Destinazione)){ throw "non e' piu' dove l'avevo messa (spostata a mano dopo il giro?)" }
      if(Test-Path -LiteralPath $r.Origine){ throw "esiste di nuovo qualcosa al posto di origine: NON annido dentro, va risolto a mano" }
      $cartellaOrig = Split-Path -Parent $r.Origine
      if(-not (Test-Path -LiteralPath $cartellaOrig)){ New-Item -ItemType Directory -Force -Path $cartellaOrig | Out-Null }
      Move-Item -LiteralPath $r.Destinazione -Destination $r.Origine -ErrorAction Stop
      $n++
    } catch {
      $m = "  NON rimesso: " + $r.Destinazione + "  --  " + $_.Exception.Message
      Write-Host $m -ForegroundColor Yellow
      [void]$rilievi.Add($m)
      $ko++
    }
  }
  Write-Host ("Rimessi a posto: " + $n + "   NON rimessi: " + $ko) -ForegroundColor White
  # log CONSUMATO: rinominato cosi' un -Annulla successivo non lo ripesca
  # (il -Filter "riordino_*.csv" non prende piu' "usato_riordino_...").
  $logUsato = NomeSenzaCollisione $ultimo.DirectoryName ("usato_" + [IO.Path]::GetFileNameWithoutExtension($ultimo.Name)) ".csv"
  Move-Item -LiteralPath $ultimo.FullName -Destination $logUsato -ErrorAction SilentlyContinue
  $fileA = NomeSenzaCollisione $Desktop "annulla_riordino" ("_" + $stamp + ".txt")
  $righeA = New-Object System.Collections.ArrayList
  [void]$righeA.Add("ESITO ANNULLAMENTO riordina_desktop")
  [void]$righeA.Add("data: " + (Get-Date).ToString("yyyy.MM.dd HH:mm:ss", $INV))
  [void]$righeA.Add("log usato: " + $ultimo.Name)
  [void]$righeA.Add("rimessi a posto: " + $n + "   non rimessi: " + $ko)
  foreach($m in $rilievi){ [void]$righeA.Add($m) }
  Set-Content -LiteralPath $fileA -Value $righeA -Encoding UTF8
  Write-Host ("Referto: " + $fileA) -ForegroundColor Gray
  if($ko -gt 0){ Write-Host "ESITO: PARZIALE -- leggi le righe gialle sopra e il referto." -ForegroundColor Red; exit 1 }
  Write-Host "ESITO: OK" -ForegroundColor Green
  exit 0
}

# --- le famiglie: NOME CARTELLA -> lista di pattern sul nome -------------
# ORDINE = PRIORITA': la prima che combacia vince. "orb_pt7e*" sta SOPRA
# "orb_*" apposta (altrimenti non vincerebbe mai, classe 101 - codice morto).
$Famiglie = [ordered]@{
  "BREAKING_BAND" = @("bb_*","breaking*","funnel_bb*","cal_bb*")
  "GAP_FILL"      = @("gap_*")
  "PUNTE_LARRY"   = @("larry_*","notte_larry*","*_larry")
  "COST_TO_COST"  = @("cost_*")
  "EASY_TREND"    = @("ez_*","easytrend_*","valid_ABTG_EasyTrend*")
  "ALTRI_ROUND"   = @("r19*","r22*","r33*","ibex_*","suprev_*","gbpjpy_*","fuorilista*","v21_*",
                      "backup_v21*","trades_port*","raccolta_*","verifica_viv*","weekend*","coda_*",
                      "orb_pt7e*","src_v2*","ini_studio*","ini_valid*","test_pagella*")
  "APERTURE_ORB"  = @("orb_*","orl_*","fade_*","target_*","londra_*","r35_*","gest_*","pertrade_r4*",
                      "dow_*","apert*","ini_apert*","conferma_*","src_dow*")
  "ORO_METALLI"   = @("oro_*","xau*","maxmin*","notte_oro*")
}

$EstensioniProgrammi = @(".lnk",".url",".exe",".msi",".bat",".cmd",".ps1xml")
$EstensioniDocumenti = @(".md",".txt",".csv",".docx",".doc",".pdf",".xlsx",".xls",".json",".ini",".set",".mq5",".ex5",".algo")

# --- cartelle che NON si toccano MAI, nemmeno con -Tutto ------------------
# le nostre di lavoro + le cartelle-destinazione del gemello RIGA_ORGANIZZA_DESKTOP.ps1
# (06/09): -Tutto non deve seppellire il riordino gia' fatto oggi (classe 142).
$NonToccare = @(
  "ABTG_RISULTATI","ABTG_ZIP","ABTG_DOCUMENTI","ABTG_VARIE","ABTG_ORDINE_LOG",
  "ARCHIVIO_DESKTOP","ARCHIVIO_TEST",
  "Slippage_Spread","Collaudo","Canarino","Migrazione","Verifica_ORB","Censimenti","Pulizia_VPS",
  "Backup","R81_Uscite","Relativo_R117","PostNews","Caccia_Ticket","Pagelle","Backtest","Config",
  "Fantasmi","Trades"
)
# tematiche di Claudio (righe 15-16 sopra): a PREFISSO, confronto ORDINALE
# (non la cultura it-IT del VPS: su una blacklist non si vuole quel confronto).
$NonToccarePrefisso = @(
  "EASYTREND","INDICATORI","BREAKOUT","NOTTE","PROCE","ALTA VELOCIT",
  "NASDAQ APERTU","DAX E NASD","PIANO DI TRADI","FILE WORD","FILE CHE SCARICO"
)
# classe 143: i referti che questo script (e il suo gemello) scrivono sul
# Desktop non sono materiale da spostare -- altrimenti un secondo giro non
# vuoto sposta i PROPRI referti, scrive un log-spazzatura da 1-2 righe che
# SCAVALCA quello vero, e -Annulla rimette a posto la cosa sbagliata.
$NonToccareFilePrefisso = @(
  "anteprima_riordino_","esito_riordino_","annulla_riordino_","usato_riordino_",
  "piano_desktop_","esito_desktop_","annulla_desktop_"
)
# file personali/clienti di Claudio (nulla a che fare col trading ABTG):
# richiesto il 06/09 di escluderli dal sacco ABTG_DOCUMENTI. Sottostringa,
# confronto SENZA cultura (i nomi hanno spazi e maiuscole miste).
$NonToccareFileContiene = @("cliente","clienti","claudio")
$NonToccareFileEsatto = @("DUPLICATI_SCARTATI.xlsx","lista-emilia-romagna--20260717-090319.xlsx")

function Famiglia($nome){
  foreach($f in $Famiglie.Keys){
    foreach($pat in $Famiglie[$f]){ if($nome -like $pat){ return $f } }
  }
  return $null
}

$piano   = New-Object System.Collections.ArrayList
$inCorso = New-Object System.Collections.ArrayList
$voci    = Get-ChildItem -LiteralPath $Desktop -Force -ErrorAction SilentlyContinue | Where-Object { -not $_.Attributes.ToString().Contains("System") }

foreach($v in $voci){
  if($NonToccare -contains $v.Name){ continue }
  if($v.Name -eq "desktop.ini"){ continue }
  $prot = $false
  foreach($pp in $NonToccarePrefisso){ if($v.Name.ToUpperInvariant().StartsWith($pp,[System.StringComparison]::Ordinal)){ $prot = $true; break } }
  if($prot){ continue }
  if(-not $v.PSIsContainer){
    $mio = $false
    foreach($pp in $NonToccareFilePrefisso){ if($v.Name.StartsWith($pp,[System.StringComparison]::OrdinalIgnoreCase)){ $mio = $true; break } }
    if($mio){ continue }
    $personale = $false
    if($NonToccareFileEsatto -contains $v.Name){ $personale = $true }
    if(-not $personale){ foreach($k in $NonToccareFileContiene){ if($v.Name.ToLowerInvariant().Contains($k)){ $personale = $true; break } } }
    if($personale){ continue }
  }

  if($v.PSIsContainer){
    # corsa/round ANCORA IN CORSO: si guarda l'ultima scrittura, cartella E contenuto.
    $ultimaScrittura = $v.LastWriteTime
    foreach($f in @(Get-ChildItem -LiteralPath $v.FullName -Recurse -Force -ErrorAction SilentlyContinue)){
      if($f.LastWriteTime -gt $ultimaScrittura){ $ultimaScrittura = $f.LastWriteTime }
    }
    if((New-TimeSpan -Start $ultimaScrittura -End (Get-Date)).TotalMinutes -lt $MinutiFermo){
      [void]$inCorso.Add($v.Name + "  (ultima scrittura " + $ultimaScrittura.ToString("yyyy-MM-dd HH:mm:ss", $INV) + ")")
      continue
    }
    $fam = Famiglia $v.Name
    if($fam){
      [void]$piano.Add([pscustomobject]@{ Nome=$v.Name; Tipo="cartella round"; Dove="ABTG_RISULTATI\$fam"; Origine=$v.FullName })
    } elseif($Tutto){
      [void]$piano.Add([pscustomobject]@{ Nome=$v.Name; Tipo="cartella"; Dove="ABTG_VARIE"; Origine=$v.FullName })
    }
    continue
  }

  $ext = $v.Extension.ToLower()
  if($EstensioniProgrammi -contains $ext){ continue }        # collegamenti e programmi: MAI, nemmeno con -Tutto
  if($ext -eq ".zip" -or $ext -eq ".7z" -or $ext -eq ".rar"){
    [void]$piano.Add([pscustomobject]@{ Nome=$v.Name; Tipo="archivio"; Dove="ABTG_ZIP"; Origine=$v.FullName })
  } elseif($EstensioniDocumenti -contains $ext){
    [void]$piano.Add([pscustomobject]@{ Nome=$v.Name; Tipo="documento"; Dove="ABTG_DOCUMENTI"; Origine=$v.FullName })
  } elseif($Tutto){
    [void]$piano.Add([pscustomobject]@{ Nome=$v.Name; Tipo="file"; Dove="ABTG_VARIE"; Origine=$v.FullName })
  }
}

Write-Host ""
Write-Host ("=== RIORDINO DESKTOP: " + $Desktop + " ===") -ForegroundColor Cyan
Write-Host ("data: " + (Get-Date).ToString("yyyy.MM.dd HH:mm:ss", $INV)) -ForegroundColor Gray
if($inCorso.Count -gt 0){
  Write-Host ""
  Write-Host ("=== IN CORSO (scritte da meno di " + $MinutiFermo + " minuti, SALTATE) (" + $inCorso.Count + ") ===") -ForegroundColor Yellow
  $inCorso | Sort-Object | ForEach-Object { Write-Host ("    - " + $_) }
}
if($piano.Count -eq 0){
  Write-Host ""
  Write-Host "Niente da spostare: il Desktop e' gia' in ordine (o tutto e' IN CORSO / protetto)." -ForegroundColor Green
} else {
  $piano | Group-Object Dove | Sort-Object Name | ForEach-Object {
    Write-Host ""
    Write-Host ("  -> " + $_.Name + "   (" + $_.Count + " elementi)") -ForegroundColor White
    $_.Group | Select-Object -First 12 | ForEach-Object { Write-Host ("       " + $_.Nome) -ForegroundColor DarkGray }
    if($_.Count -gt 12){ Write-Host ("       ... e altri " + ($_.Count-12)) -ForegroundColor DarkGray }
  }
  Write-Host ""
  Write-Host ("TOTALE: " + $piano.Count + " elementi da sistemare.") -ForegroundColor Yellow
  Write-Host "NON verranno toccati: collegamenti, programmi, le tue cartelle tematiche e le cartelle-destinazione (nemmeno con -Tutto)." -ForegroundColor Gray
}

# --- raccolta: referto su Desktop, SEMPRE (anteprima ed esecuzione, anche
# a piano vuoto: la riga di lancio cerca un file fresco e non deve trovare
# il nulla su un giro pulito, classe 143-ter) -------------------------------
$prefissoRef = if($Esegui){ "esito_riordino" } else { "anteprima_riordino" }
$fileOut = NomeSenzaCollisione $Desktop $prefissoRef ("_" + $stamp + ".txt")
$righe = New-Object System.Collections.ArrayList
if($Esegui){ [void]$righe.Add("ESITO ESECUZIONE riordina_desktop - elenco PIANIFICATO; esito REALE in fondo") }
else       { [void]$righe.Add("ANTEPRIMA riordina_desktop - nessun elemento spostato") }
[void]$righe.Add("data: " + (Get-Date).ToString("yyyy.MM.dd HH:mm:ss", $INV))
[void]$righe.Add("Desktop: " + $Desktop)
$piano | Group-Object Dove | Sort-Object Name | ForEach-Object {
  [void]$righe.Add("")
  [void]$righe.Add($_.Name + " (" + $_.Count + ")")
  $_.Group | Sort-Object Nome | ForEach-Object { [void]$righe.Add("    - " + $_.Nome) }
}
if($inCorso.Count -gt 0){
  [void]$righe.Add("")
  [void]$righe.Add("IN CORSO, SALTATE (" + $inCorso.Count + "): " + (($inCorso | Sort-Object) -join " | "))
}

if(-not $Esegui){
  Set-Content -LiteralPath $fileOut -Value $righe -Encoding UTF8
  $zipOut = NomeSenzaCollisione $Desktop $prefissoRef ("_" + $stamp + ".zip")
  Compress-Archive -LiteralPath $fileOut -DestinationPath $zipOut -Force
  Write-Host ""
  Write-Host "Questa era solo l'ANTEPRIMA: non ho spostato niente." -ForegroundColor Yellow
  Write-Host "Per farlo davvero rilancia la stessa riga aggiungendo  -Esegui" -ForegroundColor Yellow
  Write-Host ("File attesi sul Desktop: " + (Split-Path -Leaf $fileOut) + " | " + (Split-Path -Leaf $zipOut)) -ForegroundColor Magenta
  exit 0
}

New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
$log = New-Object System.Collections.ArrayList
$falliti = New-Object System.Collections.ArrayList
$rinominati = New-Object System.Collections.ArrayList
foreach($p in $piano){
  try{
    $destDir = Join-Path $Desktop $p.Dove
    New-Item -ItemType Directory -Force -Path $destDir | Out-Null
    $dest = Join-Path $destDir $p.Nome
    # anti-collisione: cartelle mai per estensione (una cartella "oro_v1.2"
    # non e' un file con estensione ".2"), tentativi multipli, MAI -Force
    # (che su un file esistente sovrascrive in silenzio, classe 142-bis).
    if($p.Tipo -like "cartella*"){ $base = $p.Nome; $coda = "" }
    else { $base = [IO.Path]::GetFileNameWithoutExtension($p.Nome); $coda = [IO.Path]::GetExtension($p.Nome) }
    $i = 0
    while(Test-Path -LiteralPath $dest){
      $i++
      $dest = Join-Path $destDir ($base + "_" + $stamp + "_" + $i + $coda)
    }
    Move-Item -LiteralPath $p.Origine -Destination $dest -ErrorAction Stop
    [void]$log.Add([pscustomobject]@{ Origine=$p.Origine; Destinazione=$dest })
    if($i -gt 0){ [void]$rinominati.Add("  rinominato per collisione: " + $p.Nome + "  ->  " + (Split-Path -Leaf $dest)) }
  } catch {
    $m = "  NON spostato: " + $p.Nome + " (verso " + $p.Dove + ")  --  " + $_.Exception.Message
    Write-Host $m -ForegroundColor Yellow
    [void]$falliti.Add($m)
  }
}
if($log.Count -gt 0){
  $logFile = NomeSenzaCollisione $LogDir "riordino" ("_" + $stamp + ".csv")
  $log | Export-Csv -LiteralPath $logFile -NoTypeInformation -Encoding UTF8
} else {
  $logFile = "(niente spostato in questo giro: nessun log nuovo, quello del giro precedente resta valido per -Annulla)"
}

[void]$righe.Add("")
[void]$righe.Add("ESITO REALE -- spostati con successo: " + $log.Count + "   NON spostati: " + $falliti.Count)
foreach($m in $falliti){ [void]$righe.Add($m) }
foreach($m in $rinominati){ [void]$righe.Add($m) }
[void]$righe.Add("(i NON spostati sono rimasti dove erano e NON sono nel log di annullamento)")
[void]$righe.Add("Log per annullare: " + $logFile)
Set-Content -LiteralPath $fileOut -Value $righe -Encoding UTF8
$zipOut = NomeSenzaCollisione $Desktop $prefissoRef ("_" + $stamp + ".zip")
Compress-Archive -LiteralPath $fileOut -DestinationPath $zipOut -Force

Write-Host ""
Write-Host ("FATTO: " + $log.Count + " elementi sistemati.   NON spostati: " + $falliti.Count) -ForegroundColor Green
Write-Host ("Log (serve per annullare): " + $logFile) -ForegroundColor Gray
Write-Host ("File attesi sul Desktop: " + (Split-Path -Leaf $fileOut) + " | " + (Split-Path -Leaf $zipOut)) -ForegroundColor Magenta
Write-Host "Se qualcosa non ti piace:  riordina_desktop.ps1 -Annulla   rimette tutto com'era." -ForegroundColor Gray

if($falliti.Count -gt 0){ exit 1 }
exit 0
