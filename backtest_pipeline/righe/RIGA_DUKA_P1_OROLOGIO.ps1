# =====================================================================
#  MARCATORE_RIGA_DUKA_P1_v1
#  RIGA_DUKA_P1_OROLOGIO.ps1 -- P1 di report/PIANO_REGIME_DOW_DUKASCOPY_2026-10-05.md (par. 3.1):
#  il CANCELLO ZERO di U30USD_DK con l'OROLOGIO CORRETTO (UTC+1 fisso), a ZERO DOWNLOAD.
#  Esegue la regola della F2 "FIRMO CANCELLO DK DOW" (appendice del piano, par. 5) e ne legge l'esito col
#  valutatore meccanico dukascopy\leggi_f2_dk.py. Prima di toccare qualunque cosa il piano va firmato da
#  Claudio (F2) e questa riga e' passata dal cancello (verificatore-stringhe + controllo-preventivo).
# ---------------------------------------------------------------------
#  BERSAGLIO: SOLO una finestra PowerShell sul PC di backtest DESKTOP-H4D7CAJ; apre e chiude da sola, tramite la
#  riga figlia RIGA_DUKA_IMPORT_SONDA.ps1 v2, il terminale C:\Program Files\BCM Markets MT5 Terminal (demo
#  50503392: LO STESSO numero del piccolo del VPS; il 14/08 da questa macchina sono partiti ordini veri, percio'
#  la riga SI FERMA se un grafico salvato ha un EA attaccato). NON TOCCATI, per nome: il VPS VMI3047753 e tutte le
#  sue cartelle dati -- FTMO trial 1514806751 (C:\FTMO, ex challenge 541452707), REALE 10105439 (C:\BCM_Reale),
#  piccolo 50503392 sul VPS (BCM Markets MT5 Terminal), 100k 50504263 (BCM Markets MT5 Terminal -V3), manuale
#  50503635 (C:\MT5_MANUALE), banco 50504400 (C:\MT5_Backtest), Pepperstone, Tickmill. Nessun preset, EA, taglia,
#  rischio, conto toccato. NESSUN download di dati Dukascopy: solo i 3 file del progetto al pin (curl/python-urllib
#  non si usano; --solo-cache non apre la rete).
# ---------------------------------------------------------------------
#  COSA SCRIVE (e dove): in dukascopy_lavoro\ -- tick_0309_backup\ (copia dei CSV del 03/09 + MANIFEST_SHA256.txt,
#  creata UNA volta e mai sovrascritta), tick\ (i 9 CSV mensili RICONVERTITI, riscritti in modo atomico),
#  dukascopy_neg\ (una sola giornata di cache copiata + il suo CSV U30USD_DKNEG, mai dentro tick\); in
#  abtg_duka_p1\ (i file al pin e i log); nel terminale BCM il custom U30USD_DK reimportato e il custom NUOVO
#  U30USD_DKNEG (resta nel terminale: P1 non lo cancella, e' innocuo e si toglie a mano); sul Desktop la cartella
#  DUKA_P1_<data> + zip, e le due cartelle/zip della riga figlia. MQL5\Files: i CSV copiati dalla figlia; quelli
#  del negativo li toglie la figlia (-PulisciFiles), quelli di U30USD_DK restano come il 03/09.
#  ORDINE (ogni fase ha il suo gate; il primo che fallisce FERMA, nessuna fase "tira dritto"):
#   A guardie (macchina, MT5 chiuso, nessun EA sui grafici salvati, python vero, pin e impronte)
#   B i 3 file al pin con SHA256 atteso + marcatore; autotest di dukascopy_tick.py e di leggi_f2_dk.py
#   C --verifica-cache dei 222 giorni (rc 0 = nessun buco, nessun illeggibile) e i 9 giorni della sonda per nome
#   D spazio libero (calcolato, dichiarato) e stato di tick\ (9 CSV attesi, scritti col calendario 'usa')
#   E copia di sicurezza dei CSV del 03/09 + SHA256 + MANIFEST (mai sovrascritta; se i CSV sono gia' 'fisso': STOP)
#   F riconversione --dst fisso --solo-cache (222 giorni, zero rete) e gate sull'ARTEFATTO (referto fresco, 9 CSV nuovi)
#   G confronto byte per byte dei giorni (condizione (2) della F2)
#   H import + sonda di U30USD_DK sui 9 giorni NOMINATI (riga figlia v2)
#   I il controllo negativo: copia della sola giornata 2025.03.12 e conversione in UTC+0 in cartella e nome SEPARATI
#   J import + sonda di U30USD_DKNEG (figlia v2, -PulisciFiles); tick\ e' ricontrollato per SHA: non e' cambiato
#   K valutazione con leggi_f2_dk.py (PASSA / NON PASSA / NON VALUTABILE) -- lo stampa e lo salva, NON decide altro
#   L raccolta sul Desktop (cartella + zip, elenco dei file letto DALLO ZIP)
#  K0b (lag di correlazione per giorno) NON e' in questa riga: "serve dopo", solo se il negativo risulta debole.
#  Codici d'uscita: 0 = tutte le fasi eseguite (il verdetto F2 e' stampato, e puo' essere NON PASSA); 1 = FERMATA da un gate;
#  2 = fasi eseguite ma l'esito F2 e' NON VALUTABILE. ASCII PURO (Windows PowerShell 5.1 legge i .ps1 come ANSI).
# =====================================================================
param(
  [string]$Pin    = "",
  [string]$ShaPy  = "",
  [string]$ShaF2  = "",
  [string]$ShaImp = "",
  [string]$ShaMq5 = "",
  [switch]$SoloControllo
)
$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture
$MacchinaAmmessa = "DESKTOP-H4D7CAJ"
if($env:COMPUTERNAME -ne $MacchinaAmmessa){
  throw ("QUESTA RIGA GIRA SOLO SUL PC DI BACKTEST " + $MacchinaAmmessa + ". Qui la macchina si chiama: " + $env:COMPUTERNAME + ". Sul VPS VMI3047753 non si lancia mai (firma del 21/09/2026). Non ho letto, creato o scritto niente.")
}

$Avvio  = Get-Date
$Stamp  = $Avvio.ToString("yyyyMMdd_HHmmss", $INV)
$Dsk    = Join-Path $env:USERPROFILE "Desktop"
if(-not (Test-Path -LiteralPath $Dsk)){ $Dsk = $env:USERPROFILE }
$Lavoro  = Join-Path $env:USERPROFILE "dukascopy_lavoro"
$RawDir  = Join-Path $Lavoro "raw"
$TickDir = Join-Path $Lavoro "tick"
$Backup  = Join-Path $Lavoro "tick_0309_backup"
$NegDir  = Join-Path $Lavoro "dukascopy_neg"
$P1Work  = Join-Path $env:USERPROFILE "abtg_duka_p1"
$RawPin  = ""
$Mesi    = @("2024-10","2024-11","2024-12","2025-01","2025-02","2025-03","2025-04","2025-05","2025-06")
$Giorni9 = @("2024.11.20","2025.06.10","2024.10.29","2024.10.31","2025.03.12","2025.03.25","2024.12.10","2025.01.14","2025.02.11")
$GiornoNeg = "2025.03.12"
$SimDK  = "U30USD_DK"
$SimNeg = "U30USD_DKNEG"
$Da = "2024-10-01"
$A  = "2025-06-16"
$TermBcm = "C:\Program Files\BCM Markets MT5 Terminal"

# tutto cio' che la RACCOLTA usa nasce QUI, prima del try (classe 125)
$R         = New-Object System.Collections.ArrayList
$Problemi  = New-Object System.Collections.ArrayList
$Fasi      = New-Object System.Collections.ArrayList     # "X nome : esito"
$Cart      = ""
$Zip       = ""
$Python    = ""
$EsitoF2   = "NON ESEGUITA"
$RcF2      = -1
$Fatale    = ""
$Codice    = 1
$CartFiles = New-Object System.Collections.ArrayList     # file da mettere nello zip: percorsi veri
$FigliDesktop = New-Object System.Collections.ArrayList  # le cartelle/zip delle righe figlie

function Pulisci([string]$t){ if($null -eq $t){ return "" }; return ($t -replace '[^\x20-\x7E]', '?') }
function Dico([string]$t, [string]$c = "Gray"){ $p = Pulisci $t; [void]$R.Add($p); Write-Host $p -ForegroundColor $c }
function Titolo([string]$t){ Dico ""; Dico ("=== " + $t + " ===") "Cyan" }
function Fase([string]$sigla, [string]$testo){ [void]$Fasi.Add($sigla + " " + $testo); Dico ("FASE " + $sigla + ": " + $testo) "White" }
function Reale([string]$p){ return (Convert-Path -LiteralPath $p) }     # per i percorsi dati a un processo NATIVO (python)

function Leggi-Condiviso($path){
  $b = $null
  try{
    $path = (Convert-Path -LiteralPath $path)
    $fs = [IO.File]::Open($path, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
    $b  = New-Object byte[] $fs.Length
    [void]$fs.Read($b, 0, $b.Length)
    $fs.Close()
  } catch { return "" }
  if($null -eq $b -or $b.Count -lt 2){ return "" }
  if($b[0] -eq 0xFF -and $b[1] -eq 0xFE){ return ([Text.Encoding]::Unicode.GetString($b)).TrimStart([char]0xFEFF) }
  $zeri = 0; $n = [math]::Min(400, $b.Count)
  for($i = 1; $i -lt $n; $i += 2){ if($b[$i] -eq 0){ $zeri++ } }
  if($zeri -gt ($n / 4)){ return ([Text.Encoding]::Unicode.GetString($b)).TrimStart([char]0xFEFF) }
  return ([Text.Encoding]::UTF8.GetString($b)).TrimStart([char]0xFEFF)
}

# scarico blindato: niente copia vecchia, errore terminante, SHA256 ATTESO e marcatore
function Gate([bool]$cond, [string]$sigla, [string]$msg){
  if(-not $cond){ [void]$Fasi.Add($sigla + " FERMATA: " + $msg); throw ("[" + $sigla + "] " + $msg) }
}

function Scarica-AlPin([string]$relativo, [string]$dest, [string]$shaAtteso, [string]$marcatore){
  Remove-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue
  try{ Invoke-WebRequest -Uri ($RawPin + "/" + $relativo) -OutFile $dest -UseBasicParsing -ErrorAction Stop }
  catch{ Gate $false "B" ("scarico fallito di " + $relativo + ": " + (Pulisci ("" + $_.Exception.Message))) }
  Gate (Test-Path -LiteralPath $dest) "B" ("scarico fallito: " + $relativo)
  $h = (Get-FileHash -LiteralPath $dest -Algorithm SHA256).Hash
  Gate ($h -ieq $shaAtteso) "B" ("IMPRONTA DIVERSA per " + $relativo + ": letta " + $h + ", attesa " + $shaAtteso + ". Non eseguo niente.")
  Gate ([bool](Select-String -LiteralPath $dest -SimpleMatch -Quiet -Pattern $marcatore)) "B" ("file scaricato SENZA il marcatore '" + $marcatore + "': " + $relativo)
  Dico ("   " + $relativo + "  impronta OK " + $h.Substring(0, 8) + "  marcatore '" + $marcatore + "' presente") "Green"
}

# lancio di un eseguibile ESTERNO con log e codice d'uscita onesto (abbassa la guardia SOLO intorno alla chiamata: classe 154/165)
function Esegui-Nativo($exe, $argv, [string]$logfile){
  $vecchio = $ErrorActionPreference
  $ErrorActionPreference = "Continue"
  $global:LASTEXITCODE = 0
  try{
    & $exe @argv 2>&1 | Tee-Object -FilePath $logfile | Out-Host
    $rc = $LASTEXITCODE
  }catch{
    $rc = 99
    Write-Host ("    eccezione lanciando " + $exe + ": " + $_.Exception.Message) -ForegroundColor Red
  }finally{
    $ErrorActionPreference = $vecchio
  }
  if($null -eq $rc){ $rc = 0 }
  return [int]$rc
}

try{
  Titolo "DUKA P1 -- CANCELLO ZERO DI U30USD_DK CON L'OROLOGIO UTC+1 FISSO (F2, zero download)"
  Dico ("avvio ........ " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss", $INV) + "  (ora del PC)  macchina " + $env:COMPUTERNAME)
  Dico ("modo ......... " + $(if($SoloControllo){ "GIRO A VUOTO (-SoloControllo): guardie, file al pin, autotest, verifica cache, spazio. NIENTE backup, NIENTE riconversione, NIENTE MT5." }else{ "CORSA COMPLETA" }))

  # ===================================================================
  Titolo "A. GUARDIE"
  Gate ($Pin -match '^[0-9a-fA-F]{40}$') "A" "-Pin obbligatorio e di 40 caratteri esadecimali: senza, girerebbe la punta del branch spacciandola per un commit congelato."
  $Pin = $Pin.ToLower()
  $RawPin = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/" + $Pin
  foreach($x in @(@("ShaPy", $ShaPy), @("ShaF2", $ShaF2), @("ShaImp", $ShaImp), @("ShaMq5", $ShaMq5))){
    Gate ($x[1] -match '^[0-9a-fA-F]{64}$') "A" ("-" + $x[0] + " obbligatorio (SHA256 di 64 caratteri esadecimali): i file al pin si verificano uno per uno.")
  }
  Dico ("pin ........... " + $Pin)
  $viv = @(Get-Process -Name terminal64, metaeditor64 -ErrorAction SilentlyContinue)
  Gate ($viv.Count -eq 0) "A" ("MT5 O METAEDITOR APERTO (" + $viv.Count + " processi). Questa riga APRE il terminale con la riga figlia: prima GUARDA I GRAFICI (sedie attaccate?) e chiudilo a mano; se invece e' una riga di round a tenerlo aperto, NON chiuderlo e aspetta (classe 853). Il PC e' di BACKTEST, ma il demo 50503392 e' lo stesso numero del piccolo del VPS.")
  Dico "MT5 / MetaEditor chiusi: OK" "Green"
  # nessun EA sui grafici salvati del terminale BCM (la figlia apre il terminale con /config: riaprirebbe il profilo)
  $root = Join-Path $env:APPDATA "MetaQuotes\Terminal"
  $dati = @()
  foreach($d in @(Get-ChildItem -LiteralPath $root -Directory -ErrorAction SilentlyContinue)){
    $of = Join-Path $d.FullName "origin.txt"
    if((Test-Path -LiteralPath $of) -and ((Leggi-Condiviso $of).Trim() -ieq $TermBcm)){ $dati += $d.FullName }
  }
  Gate ($dati.Count -eq 1) "A" ("cartelle dati del terminale " + $TermBcm + ": " + $dati.Count + " (ne serve UNA). Senza, non posso sapere se ai grafici salvati ci sono EA attaccati.")
  $chrRoot = Join-Path (Join-Path (Join-Path $dati[0] "MQL5") "Profiles") "Charts"
  $nChr = 0; $conEA = @()
  if(Test-Path -LiteralPath $chrRoot){
    foreach($f in @(Get-ChildItem -LiteralPath $chrRoot -Recurse -File -Filter "*.chr" -ErrorAction SilentlyContinue)){
      $nChr++
      $tx = Leggi-Condiviso $f.FullName
      if(-not $tx){ $conEA += ($f.Directory.Name + "\" + $f.Name + "  ILLEGGIBILE: non verificabile, conta come EA attaccato"); continue }
      if($tx -match '<expert>'){ $conEA += ($f.Directory.Name + "\" + $f.Name + "  EA ATTACCATO") }
    }
  }
  Gate ($nChr -gt 0) "A" ("ho letto ZERO grafici salvati sotto " + $chrRoot + ": una guardia che non legge niente non ha verificato niente. Non si parte.")
  Gate ($conEA.Count -eq 0) "A" ("SEDIE ATTACCATE ai grafici salvati del terminale BCM (" + ($conEA -join "; ") + "). Staccale prima: aprire il terminale col profilo le rimetterebbe in marcia (demo 50503392, 14/08).")
  Dico ("grafici salvati letti: " + $nChr + ", nessun EA attaccato: OK") "Green"
  # python VERO (non l'alias dello Store)
  $Python = (Get-Command python.exe -ErrorAction SilentlyContinue | Where-Object { $_.Source -notlike "*\WindowsApps\*" } | Select-Object -First 1 -ExpandProperty Source)
  if(-not $Python){ $Python = (Get-Command py.exe -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty Source) }
  Gate ([bool]$Python) "A" "PYTHON ASSENTE (o solo l'alias dello Store): installalo da python.org con 'Add python.exe to PATH'."
  New-Item -ItemType Directory -Force -Path $P1Work | Out-Null
  $rcv = Esegui-Nativo $Python @("-c", "import sys; print(sys.version); sys.exit(0 if sys.version_info>=(3,8) else 1)") (Join-Path $P1Work "python_versione.txt")
  Gate ($rcv -eq 0) "A" ("python troppo vecchio o non funzionante (serve >= 3.8): " + $Python)
  Dico ("python: " + $Python) "Green"
  Fase "A" "guardie passate"

  # ===================================================================
  Titolo "B. I FILE AL PIN (impronta SHA256 attesa + marcatore) E I LORO AUTOTEST"
  $DukaPy = Join-Path $P1Work "dukascopy_tick.py"
  $LeggiF2 = Join-Path $P1Work "leggi_f2_dk.py"
  $Imp = Join-Path $P1Work "RIGA_DUKA_IMPORT_SONDA.ps1"
  Scarica-AlPin "backtest_pipeline/dukascopy/dukascopy_tick.py" $DukaPy $ShaPy "DUKA-TICK-v3"
  Scarica-AlPin "backtest_pipeline/dukascopy/leggi_f2_dk.py" $LeggiF2 $ShaF2 "MARCATORE_LEGGI_F2_DK_v1"
  Scarica-AlPin "backtest_pipeline/righe/RIGA_DUKA_IMPORT_SONDA.ps1" $Imp $ShaImp "MARCATORE_RIGA_DUKA_IMPORT_SONDA_v2"
  $logA1 = Join-Path $P1Work "autotest_dukascopy_tick.txt"
  $rc1 = Esegui-Nativo $Python @("-u", (Reale $DukaPy), "--autotest") $logA1
  Gate (($rc1 -eq 0) -and (Select-String -LiteralPath $logA1 -SimpleMatch -Quiet -Pattern "AUTOTEST: TUTTO OK.")) "B" ("autotest di dukascopy_tick.py FALLITO (rc " + $rc1 + "): leggi " + $logA1)
  $logA2 = Join-Path $P1Work "autotest_leggi_f2_dk.txt"
  $rc2 = Esegui-Nativo $Python @("-u", (Reale $LeggiF2), "--autotest") $logA2
  Gate (($rc2 -eq 0) -and (Select-String -LiteralPath $logA2 -SimpleMatch -Quiet -Pattern "TUTTO OK")) "B" ("autotest di leggi_f2_dk.py FALLITO (rc " + $rc2 + "): leggi " + $logA2)
  Dico "autotest dukascopy_tick.py e leggi_f2_dk.py: TUTTO OK" "Green"
  [void]$CartFiles.Add($logA1); [void]$CartFiles.Add($logA2)
  Fase "B" "file al pin verificati, autotest verdi"

  # ===================================================================
  Titolo "C. LA CACHE DEI 222 GIORNI (sola lettura, layout VERO via dukascopy_tick.py)"
  Gate (Test-Path -LiteralPath (Join-Path $RawDir "USA30IDXUSD")) "C" ("manca " + (Join-Path $RawDir "USA30IDXUSD") + ": la cache del 03/09 non c'e'. P1 diventerebbe un riscarico di 222 giorni (~15-59 ore): si ridiscute, NON si scarica da qui.")
  $logC = Join-Path $P1Work "verifica_cache.txt"
  $rcC = Esegui-Nativo $Python @("-u", (Reale $DukaPy), "--verifica-cache", "--simboli", "USA30IDXUSD", "--da", $Da, "--a", $A, "--cartella", (Reale $Lavoro), "--giorni", ($Giorni9 -join ",")) $logC
  Gate ($rcC -eq 0) "C" ("la cache ha buchi o file illeggibili (rc " + $rcC + "): una riconversione --solo-cache PERDEREBBE quelle ore. Leggi " + $logC + ". Non si scarica da qui: si ridiscute.")
  Gate (Select-String -LiteralPath $logC -SimpleMatch -Quiet -Pattern "giorni 222,") "C" "la verifica non ha visto 222 giorni (finestra diversa da quella del piano)"
  Dico "cache dei 222 giorni: nessun buco, nessun illeggibile: OK" "Green"
  [void]$CartFiles.Add($logC)
  Fase "C" "cache verificata (222 giorni, nessun buco)"

  # ===================================================================
  Titolo "D. SPAZIO E STATO DI tick\ (i 9 CSV del 03/09)"
  Gate (Test-Path -LiteralPath $TickDir) "D" ("manca " + $TickDir)
  $nomiAttesi = @($Mesi | ForEach-Object { $SimDK + "_ticks_" + $_ + ".csv" })
  $csvNow = @(Get-ChildItem -LiteralPath $TickDir -Filter "*_ticks_*.csv" -File -ErrorAction SilentlyContinue | Sort-Object Name)
  $nomiNow = @($csvNow | ForEach-Object { $_.Name })
  Gate (($nomiAttesi -join "|") -eq ($nomiNow -join "|")) "D" ("i CSV in tick\ NON sono esattamente i 9 attesi (" + ($nomiAttesi -join ", ") + "): trovati " + ($nomiNow -join ", "))
  $csvByte = [long]0; foreach($f in $csvNow){ $csvByte += [long]$f.Length }
  Gate ($csvByte -gt 0) "D" "i CSV in tick\ sono vuoti"
  $csvGB = $csvByte / 1GB
  $serveGB = [math]::Max(5.0, 3.2 * $csvGB)       # backup (1x) + riconversione/tmp (1x) + copia in MQL5\Files (1x) + base MT5 del custom (~0.5x) + margine: stima MIA, dichiarata
  $disco = $null
  if($Lavoro -match '^([A-Za-z]:)'){
    $dd = @(Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" -ErrorAction Stop | Where-Object { ("" + $_.DeviceID).ToUpper() -eq $Matches[1].ToUpper() })
    if($dd.Count -eq 1){ $disco = [double]$dd[0].FreeSpace }
  }
  Gate ($null -ne $disco) "D" "non riesco a leggere lo spazio libero del disco di dukascopy_lavoro: non parto a meta'."
  Dico ("CSV in tick\ : 9 file, " + $csvByte + " byte (" + ([math]::Round($csvGB, 2)).ToString("0.00", $INV) + " GB)")
  Dico ("spazio libero: " + ([math]::Round($disco / 1GB, 2)).ToString("0.00", $INV) + " GB   necessario (stima mia = max(5, 3.2 x CSV)): " + ([math]::Round($serveGB, 2)).ToString("0.00", $INV) + " GB")
  Gate (($disco / 1GB) -ge $serveGB) "D" "spazio libero INSUFFICIENTE: libera disco e rilancia, non parto a meta'."
  $refOld = Join-Path $TickDir "referto_dukascopy_tick.txt"
  $refTxt = ""; if(Test-Path -LiteralPath $refOld){ $refTxt = Leggi-Condiviso $refOld }
  $giaFisso = ($refTxt -match 'calendario DST fisso' -or $refTxt -match '(?m)^DST:\s*fisso')
  $eraUsa   = ($refTxt -match 'calendario DST usa')
  Dico ("referto del .py in tick\ : " + $(if($refTxt -eq ""){ "ASSENTE" }elseif($giaFisso){ "dice DST FISSO (gia' riconvertito)" }elseif($eraUsa){ "dice DST usa (CSV del 03/09)" }else{ "calendario non riconosciuto" }))
  if(-not (Test-Path -LiteralPath $Backup)){
    Gate (-not $giaFisso) "D" "i CSV in tick\ sono GIA' riconvertiti con DST fisso e NON esiste la copia del 03/09: la copia di sicurezza prenderebbe i CSV nuovi spacciandoli per vecchi. STOP: serve prima ricostruire i CSV del 03/09 (--dst usa --solo-cache)."
    Gate $eraUsa "D" "il referto del .py in tick\ non dice 'calendario DST usa': non posso dichiarare che questi CSV sono quelli del 03/09. STOP."
  }
  Fase "D" "spazio e stato di tick\ verificati"

  if($SoloControllo){
    Titolo "GIRO A VUOTO: TUTTE LE GUARDIE E TUTTI I GATE PRECEDENTI PASSATI"
    Dico "Nessun backup fatto, nessun CSV riconvertito, MT5 mai aperto. La corsa vera e' la riga senza -SoloControllo." "Green"
    $EsitoF2 = "NON ESEGUITA (giro a vuoto)"
    $Codice = 0
  }else{

  # ===================================================================
  Titolo "E. COPIA DI SICUREZZA DEI CSV DEL 03/09 (prima di riconvertire: serve al confronto byte per byte)"
  $manifest = Join-Path $Backup "MANIFEST_SHA256.txt"
  if(Test-Path -LiteralPath $Backup){
    Dico ("la copia esiste gia' (" + $Backup + "): NON la riscrivo, la verifico contro il suo manifest.") "Yellow"
    Gate (Test-Path -LiteralPath $manifest) "E" "la cartella di backup esiste ma senza MANIFEST_SHA256.txt: non so cosa contiene. STOP."
    $man = @(Get-Content -LiteralPath $manifest | Where-Object { $_ -match '^[0-9A-Fa-f]{64}  ' })
    Gate ($man.Count -eq 10) "E" ("il manifest ha " + $man.Count + " righe invece di 10 (9 CSV + il referto del .py).")
    foreach($mm in $man){
      $sh = $mm.Substring(0, 64); $nm = $mm.Substring(66).Trim()
      $pf = Join-Path $Backup $nm
      Gate (Test-Path -LiteralPath $pf) "E" ("nel backup manca " + $nm)
      Gate (((Get-FileHash -LiteralPath $pf -Algorithm SHA256).Hash) -ieq $sh) "E" ("nel backup " + $nm + " NON ha piu' la sua impronta: la copia del 03/09 e' alterata. STOP.")
    }
    $bk = Leggi-Condiviso (Join-Path $Backup "referto_dukascopy_tick.txt")
    Gate ($bk -match 'calendario DST usa') "E" "il referto nella copia non dice 'calendario DST usa': non e' la copia dei CSV del 03/09."
    Dico "copia del 03/09 verificata (10 file, impronte uguali al manifest): OK" "Green"
  }else{
    New-Item -ItemType Directory -Path $Backup | Out-Null
    $righeMan = New-Object System.Collections.ArrayList
    $daCopiare = @($csvNow | ForEach-Object { $_.FullName }) + @($refOld)
    foreach($src in $daCopiare){
      Gate (Test-Path -LiteralPath $src) "E" ("manca il file da copiare: " + $src)
      $nm = Split-Path $src -Leaf
      $dst = Join-Path $Backup $nm
      $h0 = (Get-FileHash -LiteralPath $src -Algorithm SHA256).Hash
      Copy-Item -LiteralPath $src -Destination $dst
      $h1 = (Get-FileHash -LiteralPath $dst -Algorithm SHA256).Hash
      Gate ($h0 -ieq $h1) "E" ("la copia di " + $nm + " NON ha la stessa impronta dell'originale: copia fallita. STOP, i CSV non sono stati toccati.")
      [void]$righeMan.Add($h1 + "  " + $nm)
    }
    Set-Content -LiteralPath $manifest -Value $righeMan -Encoding ASCII
    Dico ("copia fatta: " + $Backup + " (9 CSV + referto, impronte uguali alle originali, MANIFEST_SHA256.txt)") "Green"
  }
  [void]$CartFiles.Add($manifest)
  Fase "E" "copia del 03/09 al sicuro e verificata"

  # ===================================================================
  Titolo "F. RICONVERSIONE DAI 222 GIORNI DI CACHE CON --dst fisso (UTC+1), ZERO RETE"
  $t0F = Get-Date
  Remove-Item -LiteralPath $refOld -Force -ErrorAction SilentlyContinue
  $logF = Join-Path $P1Work "riconversione_fisso.txt"
  $rcF = Esegui-Nativo $Python @("-u", (Reale $DukaPy), "--simboli", "USA30IDXUSD", "--da", $Da, "--a", $A, "--dst", "fisso", "--fuso", "server", "--solo-cache", "--senza-raccolta", "--cartella", (Reale $Lavoro)) $logF
  Gate ($rcF -eq 0) "F" ("la riconversione e' uscita con rc " + $rcF + " (3 = buchi, 1 = fallita): i CSV in tick\ possono essere MISTI vecchi/nuovi. Leggi " + $logF + "; la copia del 03/09 e' in " + $Backup + ".")
  Gate (Test-Path -LiteralPath $refOld) "F" "il .py non ha riscritto referto_dukascopy_tick.txt"
  # (nessun gate di "freschezza" del referto: e' stato CANCELLATO prima della corsa, quindi se esiste lo ha scritto questa corsa; un gate che nessun input puo' far scattare sarebbe un finto cancello, classe 1113.
  #  Quello che conta e' che i CSV siano stati RISCRITTI: gate qui sotto sui 9 file.)
  $refNew = Leggi-Condiviso $refOld
  Gate ($refNew -match '(?m)^ESITO\s*:\s*OK') "F" "il referto del .py non dice 'ESITO : OK'"
  Gate ($refNew -match '(?m)^DST:\s*fisso') "F" "il referto del .py non dice 'DST: fisso': la conversione non e' quella voluta"
  $csvNew = @(Get-ChildItem -LiteralPath $TickDir -Filter "*_ticks_*.csv" -File | Sort-Object Name)
  Gate (($nomiAttesi -join "|") -eq (@($csvNew | ForEach-Object { $_.Name }) -join "|")) "F" "dopo la riconversione i CSV in tick\ non sono esattamente i 9 attesi"
  foreach($f in $csvNew){ Gate ($f.LastWriteTime -ge $t0F) "F" ("il CSV " + $f.Name + " NON e' stato riscritto da questa corsa (data " + $f.LastWriteTime.ToString("yyyy-MM-dd HH:mm", $INV) + ")") }
  $shaTick = @{}
  foreach($f in $csvNew){ $shaTick[$f.Name] = (Get-FileHash -LiteralPath $f.FullName -Algorithm SHA256).Hash }
  Dico ("riconversione OK: 9 CSV riscritti da questa corsa, referto fresco con 'DST: fisso'") "Green"
  [void]$CartFiles.Add($logF); [void]$CartFiles.Add($refOld)
  Fase "F" "riconversione con DST fisso eseguita e verificata sull'artefatto"

  # ===================================================================
  Titolo "G. CONFRONTO BYTE PER BYTE DEI GIORNI (condizione (2) della F2)"
  $ResDir = Join-Path $P1Work ("risultati_" + $Stamp)
  New-Item -ItemType Directory -Force -Path $ResDir | Out-Null
  $confCsv = Join-Path (Reale $ResDir) "confronto_giorni.csv"
  $logG = Join-Path $P1Work "confronto_giorni.txt"
  $rcG = Esegui-Nativo $Python @("-u", (Reale $DukaPy), "--confronta-giorni", (Reale $Backup), (Reale $TickDir), "--giorni", ($Giorni9 -join ","), "--csv-out", $confCsv) $logG
  Gate ($rcG -eq 0) "G" ("il confronto e' uscito con rc " + $rcG + ": leggi " + $logG)
  Gate (Test-Path -LiteralPath $confCsv) "G" "il confronto non ha scritto confronto_giorni.csv"
  [void]$CartFiles.Add($logG); [void]$CartFiles.Add($confCsv)
  Fase "G" "confronto dei giorni scritto (il giudizio e' del valutatore, fase K)"

  # ===================================================================
  Titolo ("H. IMPORT + SONDA DI " + $SimDK + " SUI 9 GIORNI NOMINATI (riga figlia v2)")
  $ImpWork = Join-Path $P1Work "import_dk"
  $t0H = Get-Date
  $global:LASTEXITCODE = 0
  & $Imp -Pin $Pin -ShaMq5 $ShaMq5 -SimboloDK $SimDK -GiorniSonda ($Giorni9 -join ";") -WorkDir $ImpWork
  $rcH = $LASTEXITCODE
  $giorniDk = Join-Path $ImpWork ("ABTG_ImportTick_giorni_" + $SimDK + ".csv")
  Gate (Test-Path -LiteralPath $giorniDk) "H" ("la riga figlia (rc " + $rcH + ") non e' arrivata a scrivere il file per giorno di " + $SimDK + ": l'import o la sonda non sono partiti. Leggi la sua cartella sul Desktop.")
  Gate ((Get-Item -LiteralPath $giorniDk).LastWriteTime -ge $t0H) "H" "il file per giorno di U30USD_DK NON e' fresco: e' quello di un'altra corsa"
  Copy-Item -LiteralPath $giorniDk -Destination $ResDir -Force
  [void]$CartFiles.Add($giorniDk)
  Dico ("riga figlia: rc " + $rcH + "  (0 = verdetto OK e i 9 dentro per nome; 4 = verdetto OK ma non tutti; 3 = quasi; 1/2 = chiuso/non misurabile). Il giudizio e' della fase K.") "White"
  Fase "H" ("import e sonda di " + $SimDK + " eseguiti (rc figlia " + $rcH + ")")

  # ===================================================================
  Titolo ("I. IL CONTROLLO NEGATIVO: " + $GiornoNeg + " in UTC+0 (sbagliato apposta), cartella e simbolo SEPARATI")
  # prima di CANCELLARE una cartella (solo se esiste da una corsa precedente MIA) se ne controlla la forma: .../dukascopy_lavoro/dukascopy_neg, mai una radice
  $negOk = (((Split-Path $NegDir -Leaf) -eq "dukascopy_neg") -and ((Split-Path (Split-Path $NegDir -Parent) -Leaf) -eq "dukascopy_lavoro") -and ((Split-Path $NegDir -Parent) -eq $Lavoro))
  Gate $negOk "I" "percorso della cartella del negativo non e' .../dukascopy_lavoro/dukascopy_neg: non cancello niente"
  if(Test-Path -LiteralPath $NegDir){
    Dico ("la cartella del negativo esiste gia' (" + $NegDir + "): e' un artefatto di una corsa precedente MIO, la rifaccio da capo.") "Yellow"
    Remove-Item -LiteralPath $NegDir -Recurse -Force
  }
  New-Item -ItemType Directory -Path $NegDir | Out-Null
  $logI1 = Join-Path $P1Work "negativo_copia_cache.txt"
  $rcI1 = Esegui-Nativo $Python @("-u", (Reale $DukaPy), "--copia-cache-giorno", (Reale $NegDir), "--giorni", $GiornoNeg, "--simboli", "USA30IDXUSD", "--cartella", (Reale $Lavoro)) $logI1
  Gate ($rcI1 -eq 0) "I" ("la copia della giornata di cache del negativo e' uscita con rc " + $rcI1 + " (3 = ore mancanti: niente si riscarica). Leggi " + $logI1)
  $logI2 = Join-Path $P1Work "negativo_conversione_utc.txt"
  $rcI2 = Esegui-Nativo $Python @("-u", (Reale $DukaPy), "--simboli", "USA30IDXUSD", "--da", "2025-03-12", "--a", "2025-03-12", "--fuso", "utc", "--solo-cache", "--senza-raccolta", "--nome-uscita", $SimNeg, "--cartella", (Reale $NegDir)) $logI2
  Gate ($rcI2 -eq 0) "I" ("la conversione del negativo e' uscita con rc " + $rcI2 + ": leggi " + $logI2)
  $negTick = Join-Path $NegDir "tick"
  $negFiles = @(Get-ChildItem -LiteralPath $negTick -Filter "*_ticks_*.csv" -File -ErrorAction SilentlyContinue | ForEach-Object { $_.Name })
  Gate (($negFiles.Count -eq 1) -and ($negFiles[0] -eq ($SimNeg + "_ticks_2025-03.csv"))) "I" ("in " + $negTick + " attesi esattamente " + $SimNeg + "_ticks_2025-03.csv, trovati: " + ($negFiles -join ", "))
  Dico ("negativo pronto: " + (Join-Path $negTick $negFiles[0]) + "  (UTC puro, un'ora fuori dall'orologio BCM)") "Green"
  [void]$CartFiles.Add($logI1); [void]$CartFiles.Add($logI2)
  Fase "I" "giornata del negativo copiata e convertita in UTC+0 in cartella e nome separati"

  # ===================================================================
  Titolo ("J. IMPORT + SONDA DI " + $SimNeg + " (riga figlia v2, -PulisciFiles) E tick\ NON TOCCATO")
  $ImpWorkN = Join-Path $P1Work "import_neg"
  $t0J = Get-Date
  $global:LASTEXITCODE = 0
  & $Imp -Pin $Pin -ShaMq5 $ShaMq5 -SimboloDK $SimNeg -CartellaSorgente $negTick -GiorniSonda $GiornoNeg -PulisciFiles -WorkDir $ImpWorkN
  $rcJ = $LASTEXITCODE
  $giorniNeg = Join-Path $ImpWorkN ("ABTG_ImportTick_giorni_" + $SimNeg + ".csv")
  Gate (Test-Path -LiteralPath $giorniNeg) "J" ("la riga figlia (rc " + $rcJ + ") non e' arrivata a scrivere il file per giorno di " + $SimNeg)
  Gate ((Get-Item -LiteralPath $giorniNeg).LastWriteTime -ge $t0J) "J" "il file per giorno di U30USD_DKNEG NON e' fresco"
  Copy-Item -LiteralPath $giorniNeg -Destination $ResDir -Force
  [void]$CartFiles.Add($giorniNeg)
  # il marzo buono NON e' cambiato di un byte (impronte prese in F, ricontrollate ora)
  foreach($f in @(Get-ChildItem -LiteralPath $TickDir -Filter "*_ticks_*.csv" -File)){
    Gate ($shaTick.ContainsKey($f.Name) -and (((Get-FileHash -LiteralPath $f.FullName -Algorithm SHA256).Hash) -eq $shaTick[$f.Name])) "J" ("il CSV " + $f.Name + " in tick\ e' CAMBIATO durante il controllo negativo: il negativo non doveva toccarlo")
  }
  Dico "i 9 CSV in tick\ hanno le stesse impronte di prima del negativo: OK" "Green"
  Fase "J" ("import e sonda di " + $SimNeg + " eseguiti (rc figlia " + $rcJ + "); tick\ intatto")

  # ===================================================================
  Titolo "K. VALUTAZIONE DELLA F2 (leggi_f2_dk.py): PASSA / NON PASSA / NON VALUTABILE"
  $f2Out = Join-Path $ResDir "F2_VALUTAZIONE.txt"
  $logK = Join-Path $P1Work "valutazione_f2.txt"
  $RcF2 = Esegui-Nativo $Python @("-u", (Reale $LeggiF2), "--cartella", (Reale $ResDir), "--out", (Join-Path (Reale $ResDir) "F2_VALUTAZIONE.txt")) $logK
  if($RcF2 -eq 0){ $EsitoF2 = "PASSA" } elseif($RcF2 -eq 1){ $EsitoF2 = "NON PASSA" } elseif($RcF2 -eq 2){ $EsitoF2 = "NON VALUTABILE" } else { $EsitoF2 = "ERRORE DEL VALUTATORE (rc " + $RcF2 + ")" }
  Dico ("ESITO F2: " + $EsitoF2) $(if($RcF2 -eq 0){ "Green" }else{ "Yellow" })
  if(Test-Path -LiteralPath $f2Out){ [void]$CartFiles.Add($f2Out) }
  [void]$CartFiles.Add($logK)
  Fase "K" ("valutazione F2: " + $EsitoF2)
  $Codice = $(if($RcF2 -eq 0 -or $RcF2 -eq 1){ 0 }elseif($RcF2 -eq 2){ 2 }else{ 1 })
  }
}
catch{
  $Fatale = Pulisci ("" + $_.Exception.Message)
  Dico ("!!! FERMATA: " + $Fatale) "Red"
  $Codice = 1
}

# =====================================================================
#  L. RACCOLTA SUL DESKTOP + ZIP: SEMPRE, anche dopo un fatale
# =====================================================================
try{
  Write-Host ""
  Write-Host "=== L. RACCOLTA ===" -ForegroundColor Cyan
  $base = Join-Path $Dsk ("DUKA_P1_" + $Stamp)
  $Cart = $base; $k = 1
  while(Test-Path -LiteralPath $Cart){ $k++; $Cart = $base + "_" + $k }
  New-Item -ItemType Directory -Path $Cart | Out-Null
  $Zip = $Cart + ".zip"
  $T = New-Object System.Collections.ArrayList
  [void]$T.Add("DUKA P1 -- CANCELLO ZERO DI U30USD_DK CON L'OROLOGIO UTC+1 FISSO")
  [void]$T.Add("avvio: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss", $INV) + "  macchina " + $env:COMPUTERNAME + "  pin " + $Pin)
  [void]$T.Add("sha attesi: py " + $ShaPy + " | f2 " + $ShaF2 + " | imp " + $ShaImp + " | mq5 " + $ShaMq5)
  [void]$T.Add("ESITO F2: " + $EsitoF2 + "   (il verdetto vero e' in F2_VALUTAZIONE.txt; qui e' solo riportato)")
  [void]$T.Add("ESITO RIGA: " + $(if($Fatale -ne ""){ "FERMATA -- " + $Fatale }else{ "tutte le fasi eseguite (codice " + $Codice + ")" }))
  [void]$T.Add("")
  [void]$T.Add("FASI ESEGUITE (in ordine):")
  foreach($f in $Fasi){ [void]$T.Add("  " + $f) }
  [void]$T.Add("")
  [void]$T.Add("CONSOLE DELLA RIGA:")
  foreach($l in $R){ [void]$T.Add("  " + $l) }
  Set-Content -LiteralPath (Join-Path $Cart "REFERTO_DUKA_P1.txt") -Value ($T -join "`r`n") -Encoding ASCII
  $attesi = New-Object System.Collections.ArrayList
  [void]$attesi.Add("REFERTO_DUKA_P1.txt")
  foreach($src in $CartFiles){
    if($src -and (Test-Path -LiteralPath $src)){ Copy-Item -LiteralPath $src -Destination $Cart -Force; [void]$attesi.Add((Split-Path $src -Leaf)) }
  }
  Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $Zip -Force
  Add-Type -AssemblyName System.IO.Compression.FileSystem
  $zz = [IO.Compression.ZipFile]::OpenRead((Convert-Path -LiteralPath $Zip))
  $presenti = @($zz.Entries | ForEach-Object { $_.Name })
  $zz.Dispose()
  $mancanti = @($attesi | Where-Object { $presenti -notcontains $_ })
  Write-Host ("CARTELLA: " + $Cart) -ForegroundColor Green
  Write-Host ("ZIP DA MANDARE: " + $Zip) -ForegroundColor Green
  Write-Host ("FILE PRESENTI NELLO ZIP (letti dallo zip, non dal piano): " + ($presenti -join ", "))
  Write-Host ("ATTESI MA MANCANTI: " + $(if($mancanti.Count -gt 0){ ($mancanti -join ", ") }else{ "nessuno" }))
  $figli = @(Get-ChildItem -LiteralPath $Dsk -Filter "DUKA_IMPORT_SONDA_*" -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -ge $Avvio } | ForEach-Object { $_.Name })
  Write-Host ("Le righe figlie hanno scritto sul Desktop (da mandare anche queste): " + $(if($figli.Count -gt 0){ ($figli -join ", ") }else{ "(niente)" }))
  if($mancanti.Count -gt 0){ Write-Host "ZIP NON COMPLETO: NON mandarlo." -ForegroundColor Red }
}
catch{
  Write-Host ("!!! RACCOLTA FALLITA: " + (Pulisci ("" + $_.Exception.Message))) -ForegroundColor Red
  Write-Host "La console qui sopra contiene tutto: copiala intera." -ForegroundColor Red
}

Write-Host ""
if($Fatale -ne ""){ Write-Host ("ESITO P1: FERMATA -- " + $Fatale) -ForegroundColor Red }
else { Write-Host ("ESITO P1: " + $(if($SoloControllo){ "GIRO A VUOTO VERDE" }else{ "fasi eseguite, ESITO F2 = " + $EsitoF2 })) -ForegroundColor $(if($RcF2 -eq 0 -or ($SoloControllo -and $Codice -eq 0)){ "Green" }else{ "Yellow" }) }
exit $Codice
