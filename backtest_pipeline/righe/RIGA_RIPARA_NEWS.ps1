# =====================================================================
#  MARCATORE_RIGA_RIPARA_NEWS_v1
#  RIGA_RIPARA_NEWS.ps1 -- 19/09/2026
#
#  COSA FA, in una frase: rimette l'attivita' pianificata
#  ABTG_AggiornaNews su una copia STABILE di aggiorna_news.ps1 fuori dal
#  Desktop (C:\ABTG), e poi fa girare l'aggiornamento UNA VOLTA per
#  vedere che cosa risponde davvero.
#
#  PERCHE' (classe 458): il riordino del Desktop del 16/09/2026 alle
#  19:42 ha spostato la cartella da cui partiva l'attivita'. Da allora
#  l'esito e' 4294770688 (= -196608, il codice di powershell.exe quando
#  il file passato a -File non esiste). Il Desktop e' un posto dove le
#  cartelle si spostano: il codice in produzione non ci sta.
#
#  COSA NON FA, MAI:
#    - non apre, non chiude, non ricompila e non tocca NESSUN terminale
#      MT5, di nessun conto. Non li elenca nemmeno: non gli servono;
#    - non cancella niente di Claudio. La cartella archiviata il 16/09
#      NON viene letta, NON viene spostata e NON viene cancellata: la
#      copia buona arriva dal repo, non da li';
#    - non tocca nessun'altra attivita' pianificata;
#    - non scrive dentro MQL5\Files: quello lo fa aggiorna_news.ps1, che
#      ha le sue guardie e il suo bersaglio.
#
#  E' RI-ESEGUIBILE: se e' gia' tutto a posto lo dice e non ripunta
#  niente; la copia in C:\ABTG viene comunque riverificata sull'impronta.
#
#  LE GUARDIE:
#    1) il pin dev'essere un commit a 40 esadecimali e l'impronta un
#       SHA256 a 64: due stringhe storte e non si parte;
#    2) il file scaricato passa CINQUE controlli (impronta, marcatore,
#       ASCII puro, parser di PowerShell, e il BRANCH scritto dentro)
#       PRIMA di essere copiato in C:\ABTG;
#    3) la cartella di destinazione non puo' stare sul Desktop, dentro
#       MetaQuotes o dentro Program Files, e non puo' avere spazi;
#    4) la definizione dell'attivita' viene salvata in XML sul Desktop
#       PRIMA di toccarla, e la riga per tornare indietro viene stampata;
#    5) il ripuntamento si verifica sull'ARTEFATTO (si rilegge
#       l'attivita'), non sul codice di uscita di schtasks;
#    6) niente euristiche del silenzio: si aspetta che lo STATO
#       dell'attivita' torni diverso da Running, con un tetto dichiarato.
#       Se il tetto scade si scrive TIMEOUT, non "fatto".
#
#  L'ESITO DELLA CORSA DI PROVA HA TRE FORME, ed e' importante saperlo
#  PRIMA di leggerlo (misurato il 19/09/2026 sul repo):
#    A = esito 0 e calendario con la data di oggi -> canale vivo;
#    B = esito 1 con "file VUOTO (0 byte)" -> il PERCORSO e' riparato ma
#        la SORGENTE (data/abtg_news.csv sul branch lavoro) e' VUOTA da
#        luglio: lo script si RIFIUTA di mettere in campo un file vuoto
#        e lascia in pace quello vecchio. E' il comportamento giusto, e
#        va riparata la sorgente (workflow news-export.yml);
#    C = qualunque altra cosa -> si legge il log e si torna indietro.
# =====================================================================
param(
  [Parameter(Mandatory=$true)][string]$Pin,
  [Parameter(Mandatory=$true)][string]$Impronta,
  [string]$Task = "ABTG_AggiornaNews",
  [string]$DestDir = "C:\ABTG",
  [int]$AttesaMax = 180
)

$ErrorActionPreference = "Stop"
$INV = [System.Globalization.CultureInfo]::InvariantCulture
$MARCATORE = "MARCATORE_AGGIORNA_NEWS_v2"
$BRANCH_ATTESO = "/lavoro/data/abtg_news.csv"

# =====================================================================
#  LE FUNZIONI PURE -- quelle su cui girano i contro-esempi.
#  Stanno qui, in cima e separate, perche' un contro-esempio si ESEGUE:
#  si estraggono da questo file e si provano anche su una macchina senza
#  Task Scheduler. Un contro-esempio raccontato non vale niente.
# =====================================================================

function EstraiPercorsoDaArgomenti([string]$argomenti){
  if([string]::IsNullOrEmpty($argomenti)){ return "" }
  $m = [regex]::Match($argomenti, '-File\s+(?:"([^"]+)"|''([^'']+)''|(\S+))', 'IgnoreCase')
  if(-not $m.Success){ return "" }
  foreach($g in 1,2,3){
    if($m.Groups[$g].Success){ return $m.Groups[$g].Value }
  }
  return ""
}

function ArgomentiAttesi([string]$destFile){
  return ("-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File " + $destFile)
}

function PercorsoAmmesso([string]$d){
  $o = [pscustomobject]@{ Ok=$true; Perche="" }
  if([string]::IsNullOrEmpty($d)){ $o.Ok=$false; $o.Perche="cartella vuota"; return $o }
  if($d -match '\s'){ $o.Ok=$false; $o.Perche="il percorso contiene SPAZI: schtasks e le righe -File ci inciampano"; return $o }
  foreach($v in @("Desktop","MetaQuotes","Program Files","OneDrive")){
    if($d -like ("*" + $v + "*")){
      $o.Ok=$false
      $o.Perche=("il percorso contiene '" + $v + "': e' proprio il tipo di posto che si riordina o che appartiene a una piattaforma")
      return $o
    }
  }
  if($d -notmatch '^[A-Za-z]:\\[^\\]'){ $o.Ok=$false; $o.Perche="non e' un percorso assoluto tipo C:\ABTG"; return $o }
  return $o
}

function DecidiRipuntamento([bool]$esisteTask, [string]$argCorrenti, [string]$destFile){
  # Tre risposte, e una sola per ogni situazione.
  if(-not $esisteTask){ return "CREA_A_MANO" }
  $ora = EstraiPercorsoDaArgomenti $argCorrenti
  if($ora -and ($ora.TrimEnd('\','/') -ieq $destFile.TrimEnd('\','/'))){ return "GIA_A_POSTO" }
  return "RIPUNTA"
}

function VerificaScaricato([string]$file, [string]$improntaAttesa, [string]$marcatore, [string]$branchAtteso){
  # CINQUE controlli, e nessuno e' decorativo:
  #   1 esiste e non e' vuoto      -> un download troncato a zero byte
  #   2 impronta SHA256            -> un download troncato A META'
  #   3 marcatore                  -> pin e versione sono la stessa cosa
  #   4 ASCII puro                 -> PS 5.1 legge i .ps1 come ANSI
  #   5 parser + branch scritto dentro
  $g = New-Object System.Collections.ArrayList
  if(-not (Test-Path -LiteralPath $file -PathType Leaf)){
    [void]$g.Add("il file non esiste")
    return [pscustomobject]@{ Ok=$false; Guasti=@($g); Sha="" }
  }
  $len = (Get-Item -LiteralPath $file).Length
  if($len -eq 0){ [void]$g.Add("file VUOTO (0 byte)") }
  $sha = (Get-FileHash -LiteralPath $file -Algorithm SHA256).Hash
  if($sha -ine $improntaAttesa){
    [void]$g.Add("IMPRONTA DIVERSA: attesa " + $improntaAttesa + ", trovata " + $sha)
  }
  $dati = [System.IO.File]::ReadAllBytes($file)
  $fuori = 0
  foreach($b in $dati){ if($b -gt 127){ $fuori = $fuori + 1 } }
  if($fuori -gt 0){ [void]$g.Add("contiene " + $fuori + " byte non-ASCII: PowerShell 5.1 legge i .ps1 come ANSI") }
  $testo = [System.IO.File]::ReadAllText($file)
  if($testo -notmatch [regex]::Escape($marcatore)){ [void]$g.Add("manca il marcatore " + $marcatore + ": il pin non e' la versione che credi") }
  if($testo -notmatch [regex]::Escape($branchAtteso)){ [void]$g.Add("dentro non c'e' '" + $branchAtteso + "': sta puntando a un altro branch") }
  $err = $null
  $tok = $null
  try{
    [System.Management.Automation.Language.Parser]::ParseFile($file, [ref]$tok, [ref]$err) | Out-Null
    if($err -and $err.Count -gt 0){
      [void]$g.Add("il file NON COMPILA: " + $err.Count + " errori, il primo a r." + $err[0].Extent.StartLineNumber)
    }
  } catch {
    [void]$g.Add("parser non eseguibile: " + $_.Exception.Message)
  }
  return [pscustomobject]@{ Ok=($g.Count -eq 0); Guasti=@($g); Sha=$sha }
}

function InstallaCopia([string]$sorgente, [string]$destDir, [string]$improntaAttesa, [string]$stamp){
  # Idempotente, e con la copia di prima tenuta da parte. Se qualcosa non
  # torna, il file in campo NON resta a meta': si rimette il vecchio.
  $sha0 = (Get-FileHash -LiteralPath $sorgente -Algorithm SHA256).Hash
  if($sha0 -ine $improntaAttesa){
    throw ("NON INSTALLO NIENTE: la sorgente ha impronta " + $sha0 + " invece di " + $improntaAttesa)
  }
  New-Item -ItemType Directory -Force -Path $destDir | Out-Null
  $dest = Join-Path $destDir "aggiorna_news.ps1"
  $backup = ""
  $eraUguale = $false
  if(Test-Path -LiteralPath $dest -PathType Leaf){
    $shaPrima = (Get-FileHash -LiteralPath $dest -Algorithm SHA256).Hash
    $eraUguale = ($shaPrima -ieq $improntaAttesa)
    if(-not $eraUguale){
      $backup = $dest + ".prima_" + $stamp
      Copy-Item -LiteralPath $dest -Destination $backup -Force
    }
  }
  Copy-Item -LiteralPath $sorgente -Destination $dest -Force
  $sha1 = (Get-FileHash -LiteralPath $dest -Algorithm SHA256).Hash
  if($sha1 -ine $improntaAttesa){
    if($backup -and (Test-Path -LiteralPath $backup -PathType Leaf)){
      Copy-Item -LiteralPath $backup -Destination $dest -Force
    }
    throw ("COPIA NON RIUSCITA: in " + $dest + " c'e' " + $sha1 + " invece di " + $improntaAttesa + " (ho rimesso la copia di prima)")
  }
  return [pscustomobject]@{ Dest=$dest; Backup=$backup; Sha=$sha1; EraGiaUguale=$eraUguale }
}

function ClassificaEsito([long]$codice, [string]$logCorsa, [long]$byteCsv, [string]$dataCsv, [string]$oggi){
  if($codice -eq 0 -and $byteCsv -gt 0 -and $dataCsv -eq $oggi){ return "A" }
  if($codice -ne 0 -and $logCorsa -match 'file VUOTO'){ return "B" }
  if($codice -ne 0 -and $logCorsa -match 'SCARICATO MA NON VALIDO'){ return "B" }
  return "C"
}

# =====================================================================
#  DA QUI IN GIU': IL LAVORO
# =====================================================================
$righe = New-Object System.Collections.ArrayList
function Dico([string]$t, [string]$c = "Gray"){
  Write-Host $t -ForegroundColor $c
  [void]$righe.Add($t)
}
function Titolo([string]$t){
  Dico "" "Gray"
  Dico ("=== " + $t + " ===") "Cyan"
}
function Quando($o){
  if($null -eq $o){ return "(mai)" }
  return ([datetime]$o).ToString("yyyy-MM-dd HH:mm:ss", $INV)
}

function LeggiAttivita([string]$nome){
  $ris = [pscustomobject]@{ Trovata=$false; Esegue=""; Argomenti=""; Fonte="(nessuna)" }
  try{
    $t = Get-ScheduledTask -TaskName $nome -ErrorAction Stop
    foreach($a in @($t.Actions)){
      if($a.Execute){
        $ris.Trovata=$true; $ris.Esegue=[string]$a.Execute; $ris.Argomenti=[string]$a.Arguments; $ris.Fonte="Get-ScheduledTask"
        break
      }
    }
    if($ris.Trovata){ return $ris }
  } catch { }
  try{
    $q = (& schtasks.exe /Query /TN $nome /V /FO LIST 2>$null | Out-String -Width 8000)
    if($q -and $q.Length -gt 50){
      $ris.Fonte = "schtasks /Query"
      foreach($r in ($q -split "`r?`n")){
        $mm = [regex]::Match($r, '^\s*(?:Task To Run|Attivit.*da eseguire)\s*:\s*(.+)$')
        if($mm.Success){
          $tutto = $mm.Groups[1].Value.Trim()
          $ris.Trovata = $true
          $me = [regex]::Match($tutto, '^\s*(?:"([^"]+)"|(\S+))\s*(.*)$')
          if($me.Success){
            if($me.Groups[1].Success){ $ris.Esegue = $me.Groups[1].Value } else { $ris.Esegue = $me.Groups[2].Value }
            $ris.Argomenti = $me.Groups[3].Value
          } else { $ris.Esegue = $tutto }
          break
        }
      }
    }
  } catch { }
  return $ris
}

function StatoAttivita([string]$nome){
  $s = [pscustomobject]@{ Stato="(ignoto)"; Esito=$null; UltimaCorsa=$null }
  try{
    $i = Get-ScheduledTaskInfo -TaskName $nome -ErrorAction Stop
    $s.Esito = $i.LastTaskResult
    $s.UltimaCorsa = $i.LastRunTime
    $t = Get-ScheduledTask -TaskName $nome -ErrorAction SilentlyContinue
    if($t){ $s.Stato = [string]$t.State }
    return $s
  } catch { }
  try{
    $q = (& schtasks.exe /Query /TN $nome /V /FO LIST 2>$null | Out-String -Width 8000)
    foreach($r in ($q -split "`r?`n")){
      $m1 = [regex]::Match($r, '^\s*(?:Last Result|Ultimo risultato)\s*:\s*(-?\d+)\s*$')
      if($m1.Success){ $s.Esito = [long]::Parse($m1.Groups[1].Value, $INV) }
      $m2 = [regex]::Match($r, '^\s*(?:Status|Stato)\s*:\s*(.+)$')
      if($m2.Success){ $s.Stato = $m2.Groups[1].Value.Trim() }
    }
  } catch { }
  return $s
}

$stamp = (Get-Date).ToString("yyyyMMdd_HHmm", $INV)
$oggi  = (Get-Date).ToString("yyyy-MM-dd", $INV)

# --- GUARDIA 1: pin e impronta sono quello che dicono di essere? ------
if($Pin -notmatch '^[0-9a-fA-F]{40}$'){ throw ("PIN STORTO: '" + $Pin + "' non e' un commit a 40 esadecimali. Non parto.") }
if($Impronta -notmatch '^[0-9a-fA-F]{64}$'){ throw ("IMPRONTA STORTA: '" + $Impronta + "' non e' uno SHA256 a 64 esadecimali. Non parto.") }
$amm = PercorsoAmmesso $DestDir
if(-not $amm.Ok){ throw ("CARTELLA DI DESTINAZIONE RIFIUTATA (" + $DestDir + "): " + $amm.Perche) }

$dsk = [Environment]::GetFolderPath('Desktop')
$cart = Join-Path $dsk ("RIPARA_NEWS_" + $stamp)
New-Item -ItemType Directory -Force -Path $cart | Out-Null

Dico "======================================================================" "Cyan"
Dico ("  RIPARAZIONE DEL CANALE NEWS -- " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss", $INV)) "Cyan"
Dico ("  attivita': " + $Task + "   destinazione: " + $DestDir) "Cyan"
Dico "  Nessun terminale MT5 viene aperto, chiuso o toccato." "Cyan"
Dico "======================================================================" "Cyan"

# Da qui in giu' si chiamano comandi NATIVI (schtasks, powershell): con
# $ErrorActionPreference='Stop' lo stderr di un nativo diventa errore
# TERMINANTE su PS 5.1 e ammazza il resto della riga (classe 165). I
# controlli che contano sono espliciti, non affidati alla preferenza.
$ErrorActionPreference = "Continue"

# =====================================================================
#  PRIMA
# =====================================================================
Titolo "PRIMA -- com'e' adesso"
$prima = LeggiAttivita $Task
if($prima.Trovata){
  Dico ("  letta con   : " + $prima.Fonte)
  Dico ("  esegue      : " + $prima.Esegue)
  Dico ("  argomenti   : " + $prima.Argomenti)
  $pPrima = EstraiPercorsoDaArgomenti $prima.Argomenti
  Dico ("  file -File  : " + $pPrima)
  if($pPrima -and (Test-Path -LiteralPath $pPrima -PathType Leaf)){
    Dico "  quel file   : ESISTE" "Green"
  } else {
    Dico "  quel file   : NON ESISTE  <-- ecco il 4294770688" "Red"
  }
  $st = StatoAttivita $Task
  Dico ("  stato       : " + $st.Stato + "   ultimo esito: " + $st.Esito + "   ultima corsa: " + (Quando $st.UltimaCorsa))
  $xml = Join-Path $cart ("ATTIVITA_COME_ERA_" + $stamp + ".xml")
  $q = (& schtasks.exe /Query /TN $Task /XML 2>$null | Out-String -Width 8000)
  if($q -and $q.Length -gt 50){
    Set-Content -LiteralPath $xml -Value $q -Encoding ASCII
    Dico ("  COME SI TORNA INDIETRO: la definizione di adesso e' salvata in") "Yellow"
    Dico ("    " + $xml) "Yellow"
    Dico ("    schtasks /Create /TN " + $Task + " /XML """ + $xml + """ /F") "Yellow"
  } else {
    Dico "  ATTENZIONE: non sono riuscito a salvare l'XML dell'attivita'." "Yellow"
  }
} else {
  Dico ("  L'ATTIVITA' " + $Task + " NON RISULTA (o l'elenco non e' leggibile da questa console).") "Red"
}
$destFile = Join-Path $DestDir "aggiorna_news.ps1"
if(Test-Path -LiteralPath $destFile -PathType Leaf){
  $fi = Get-Item -LiteralPath $destFile
  Dico ("  copia gia' in " + $DestDir + ": " + (Quando $fi.LastWriteTime) + "  impronta " + (Get-FileHash -LiteralPath $destFile -Algorithm SHA256).Hash)
} else {
  Dico ("  in " + $DestDir + " non c'e' ancora nessun aggiorna_news.ps1")
}

# =====================================================================
#  SCARICO E VERIFICO -- prima di mettere qualunque cosa in C:\ABTG
# =====================================================================
Titolo "LO SCRIPT DAL PIN"
$tmp = Join-Path $cart "aggiorna_news_dal_pin.ps1"
$url = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/" + $Pin + "/backtest_pipeline/aggiorna_news.ps1"
Dico ("  pin      : " + $Pin)
Dico ("  url      : " + $url)
try{
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
  Invoke-WebRequest -Uri ($url + "?cb=" + [guid]::NewGuid().ToString('N')) -OutFile $tmp -UseBasicParsing -TimeoutSec 60 -ErrorAction Stop
} catch {
  throw ("DOWNLOAD FALLITO dal pin: " + $_.Exception.Message + " -- non ho toccato niente")
}
$ver = VerificaScaricato $tmp $Impronta $MARCATORE $BRANCH_ATTESO
if(-not $ver.Ok){
  foreach($g in $ver.Guasti){ Dico ("  GUASTO: " + $g) "Red" }
  throw "IL FILE SCARICATO NON PASSA I CONTROLLI: non installo niente, non ripunto niente."
}
Dico ("  impronta : " + $ver.Sha + "   (uguale a quella attesa)") "Green"
Dico ("  marcatore " + $MARCATORE + ": c'e'") "Green"
Dico ("  ASCII puro, compila, e dentro punta a " + $BRANCH_ATTESO) "Green"

# =====================================================================
#  INSTALLO
# =====================================================================
Titolo ("INSTALLO IN " + $DestDir)
$ins = InstallaCopia $tmp $DestDir $Impronta $stamp
Dico ("  installato  : " + $ins.Dest) "Green"
if($ins.EraGiaUguale){
  Dico "  era GIA' identico: nessuna copia di sicurezza da fare (riga ri-eseguibile)." "Green"
} elseif($ins.Backup){
  Dico ("  copia di prima tenuta da parte: " + $ins.Backup) "Yellow"
} else {
  Dico "  non c'era niente da salvare: prima installazione." "Yellow"
}

# =====================================================================
#  RIPUNTO L'ATTIVITA' -- e verifico sull'ARTEFATTO
# =====================================================================
Titolo "RIPUNTO L'ATTIVITA'"
$attesi = ArgomentiAttesi $ins.Dest
$decisione = DecidiRipuntamento $prima.Trovata $prima.Argomenti $ins.Dest
Dico ("  argomenti che voglio: " + $attesi)
Dico ("  decisione           : " + $decisione) "White"
$ripuntata = $false
$comeFatto = ""
if($decisione -eq "GIA_A_POSTO"){
  Dico ("  l'attivita' PUNTA GIA' a " + $ins.Dest + ": non la tocco.") "Green"
  $ripuntata = $true
  $comeFatto = "(gia' a posto)"
} elseif($decisione -eq "CREA_A_MANO"){
  Dico "  NON CREO NESSUNA ATTIVITA' DA SOLO: un'attivita' nuova porta con se'" "Red"
  Dico "  l'utente con cui gira, i privilegi e l'orario, e quelle sono decisioni." "Red"
  Dico "  La riga da usare, se l'attivita' va ricreata (07:20 = ora di Windows," "Yellow"
  Dico "  che sul VPS e' l'ora ITALIANA, ed e' quella che aveva prima):" "Yellow"
  Dico ("    schtasks /Create /TN " + $Task + " /TR ""powershell.exe " + $attesi + """ /SC DAILY /ST 07:20 /RL HIGHEST /F") "Yellow"
} else {
  # tentativo 1: il modulo ScheduledTasks (conserva trigger e principal)
  try{
    $t = Get-ScheduledTask -TaskName $Task -ErrorAction Stop
    $az = New-ScheduledTaskAction -Execute "powershell.exe" -Argument $attesi
    $t.Actions = @($az)
    Set-ScheduledTask -InputObject $t -ErrorAction Stop | Out-Null
    $comeFatto = "Set-ScheduledTask"
  } catch {
    Dico ("  Set-ScheduledTask non ha funzionato: " + $_.Exception.Message) "Yellow"
  }
  $dopo1 = LeggiAttivita $Task
  if((EstraiPercorsoDaArgomenti $dopo1.Argomenti) -ieq $ins.Dest){ $ripuntata = $true }
  # tentativo 2: schtasks /Change
  if(-not $ripuntata){
    $null = (& schtasks.exe /Change /TN $Task /TR ("powershell.exe " + $attesi) 2>&1 | Out-String -Width 8000)
    $dopo2 = LeggiAttivita $Task
    if((EstraiPercorsoDaArgomenti $dopo2.Argomenti) -ieq $ins.Dest){ $ripuntata = $true; $comeFatto = "schtasks /Change" }
  }
  if($ripuntata){
    Dico ("  RIPUNTATA con " + $comeFatto) "Green"
  } else {
    Dico "  NON SONO RIUSCITO A RIPUNTARE L'ATTIVITA'." "Red"
    Dico "  Nessun danno: la copia in C:\ABTG e' installata e l'attivita' e' rimasta com'era." "Yellow"
    Dico "  Rilancia da una console di AMMINISTRATORE, oppure fallo a mano con:" "Yellow"
    Dico ("    schtasks /Change /TN " + $Task + " /TR ""powershell.exe " + $attesi + """") "Yellow"
  }
}

# la verifica che conta: si RILEGGE l'attivita', non si crede al comando
$dopo = LeggiAttivita $Task
Dico ("  ADESSO esegue   : " + $dopo.Esegue)
Dico ("  ADESSO argomenti: " + $dopo.Argomenti)

# =====================================================================
#  LA CORSA DI PROVA -- una sola, adesso
# =====================================================================
Titolo "FACCIO GIRARE L'AGGIORNAMENTO UNA VOLTA"
$inizio = Get-Date
# [long] e NON [int]: l'ultimo esito di questa attivita' e' 4294770688,
# che in Int32 NON CI STA -- un [int] su quel numero non e' un numero
# sbagliato, e' un'eccezione di overflow che ammazza la riga sul piu' bello.
[long]$codice = -1
$comeCorso = ""
if($ripuntata -and $prima.Trovata){
  # si lancia L'ATTIVITA', non lo script: cosi' si prova la catena INTERA
  # (percorso, utente, privilegi), che e' quella che si rompe alle 07:20.
  $comeCorso = "l'ATTIVITA' pianificata"
  $partita = $false
  try{
    Start-ScheduledTask -TaskName $Task -ErrorAction Stop
    $partita = $true
  } catch {
    $null = (& schtasks.exe /Run /TN $Task 2>&1 | Out-String -Width 8000)
    $partita = $true
  }
  Dico ("  partita: " + $partita + " -- aspetto che lo STATO torni diverso da Running (tetto " + $AttesaMax + "s)")
  # NIENTE euristiche del silenzio: si guarda lo STATO, e il tetto e' un
  # TIMEOUT dichiarato, non un "sara' finito".
  $scaduto = $true
  $giri = [int][math]::Ceiling($AttesaMax / 3.0)
  for($k=0; $k -lt $giri; $k++){
    Start-Sleep -Seconds 3
    $s = StatoAttivita $Task
    if($s.Stato -ne "Running" -and $s.UltimaCorsa -ne $null -and $s.UltimaCorsa -ge $inizio.AddSeconds(-5)){
      $codice = [long]$s.Esito
      $scaduto = $false
      break
    }
  }
  if($scaduto){
    $s = StatoAttivita $Task
    Dico ("  TIMEOUT dopo " + $AttesaMax + "s: stato '" + $s.Stato + "'. NON dico che e' andata bene: dico che non lo so.") "Red"
    if($s.Esito -ne $null){ $codice = [long]$s.Esito }
  } else {
    Dico ("  finita. CODICE D'USCITA DELL'ATTIVITA': " + $codice) "White"
  }
} else {
  $comeCorso = "lo script direttamente (l'attivita' non e' ripuntata)"
  $global:LASTEXITCODE = 0
  & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $ins.Dest
  $codice = [long]$LASTEXITCODE
  Dico ("  corsa diretta. CODICE D'USCITA: " + $codice) "White"
}

# --- il log della corsa: e' l'unico posto dove si vede cosa ha detto --
$logTesto = ""
$cartelleLog = New-Object System.Collections.ArrayList
[void]$cartelleLog.Add((Join-Path $env:USERPROFILE "abtg_news_log"))
foreach($u in @(Get-ChildItem -LiteralPath "C:\Users" -Directory -Force -ErrorAction SilentlyContinue)){
  [void]$cartelleLog.Add((Join-Path $u.FullName "abtg_news_log"))
}
$ultimoLog = $null
foreach($cl in @($cartelleLog | Sort-Object -Unique)){
  if(-not (Test-Path -LiteralPath $cl)){ continue }
  foreach($f in @(Get-ChildItem -LiteralPath $cl -Filter "aggiorna_news_*.log" -File -ErrorAction SilentlyContinue)){
    if($f.LastWriteTime -ge $inizio.AddSeconds(-30)){
      if($null -eq $ultimoLog -or $f.LastWriteTime -gt $ultimoLog.LastWriteTime){ $ultimoLog = $f }
    }
  }
}
Dico ""
if($null -eq $ultimoLog){
  Dico "  NESSUN log di questa corsa trovato: o la corsa non e' partita, o gira" "Yellow"
  Dico "  con un altro utente e il suo profilo non e' leggibile da qui." "Yellow"
} else {
  Dico ("  log della corsa: " + $ultimoLog.FullName) "White"
  Copy-Item -LiteralPath $ultimoLog.FullName -Destination (Join-Path $cart $ultimoLog.Name) -Force -ErrorAction SilentlyContinue
  try { $logTesto = Get-Content -LiteralPath $ultimoLog.FullName -Raw } catch { $logTesto = "" }
  foreach($r in @(Get-Content -LiteralPath $ultimoLog.FullName -ErrorAction SilentlyContinue)){ Dico ("   | " + $r) "DarkGray" }
}

# =====================================================================
#  IL CALENDARIO IN CAMPO, DOPO
# =====================================================================
Titolo "IL CALENDARIO DOPO LA CORSA"
$termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$byteCsv = 0
$dataCsv = "(nessun file)"
$csvPiuNuovo = $null
if(Test-Path -LiteralPath $termRoot){
  foreach($d in @(Get-ChildItem -LiteralPath $termRoot -Directory -Force -ErrorAction SilentlyContinue)){
    $csv = Join-Path $d.FullName "MQL5\Files\abtg_news.csv"
    if(-not (Test-Path -LiteralPath $csv -PathType Leaf)){ continue }
    $fi = Get-Item -LiteralPath $csv
    $chi = $d.Name
    $o = Join-Path $d.FullName "origin.txt"
    if(Test-Path -LiteralPath $o){ try { $chi = (Get-Content -LiteralPath $o -Raw).Trim() } catch { } }
    Dico ("   " + $csv)
    Dico ("     terminale: " + $chi)
    Dico ("     scritto  : " + (Quando $fi.LastWriteTime) + "   byte: " + $fi.Length)
    if($null -eq $csvPiuNuovo -or $fi.LastWriteTime -gt $csvPiuNuovo.LastWriteTime){ $csvPiuNuovo = $fi }
  }
}
if($null -ne $csvPiuNuovo){
  $byteCsv = [long]$csvPiuNuovo.Length
  $dataCsv = $csvPiuNuovo.LastWriteTime.ToString("yyyy-MM-dd", $INV)
} else {
  Dico "   nessun abtg_news.csv trovato in nessuna cartella dati." "Red"
}

# =====================================================================
#  IL VERDETTO
# =====================================================================
$classe = ClassificaEsito $codice $logTesto $byteCsv $dataCsv $oggi
Titolo ("VERDETTO: " + $classe)
$uscita = 3
if($classe -eq "A"){
  Dico "  A = CANALE VIVO. Esito 0 e calendario con la data di OGGI." "Green"
  $uscita = 0
} elseif($classe -eq "B"){
  Dico "  B = PERCORSO RIPARATO, SORGENTE VUOTA." "Yellow"
  Dico ("     L'attivita' adesso parte da " + $ins.Dest + " (e questo e' fatto),") "Yellow"
  Dico "     ma data/abtg_news.csv sul branch lavoro NON HA EVENTI: lo script si" "Yellow"
  Dico "     RIFIUTA di mettere in campo un file vuoto e lascia in pace quello" "Yellow"
  Dico "     vecchio. E' il comportamento giusto (12/09), non un guasto nuovo." "Yellow"
  Dico "     DA FARE: rigenerare data/abtg_news.csv (workflow news-export.yml)," "Yellow"
  Dico "     poi rilanciare questa stessa riga: e' ri-eseguibile." "Yellow"
  $uscita = 2
} else {
  Dico "  C = NON DIMOSTRATO. Leggi il log qui sopra e, se serve, torna indietro" "Red"
  Dico "     con l'XML salvato in questa cartella." "Red"
  $uscita = 3
}
Dico ("  codice d'uscita della corsa: " + $codice + "   calendario: " + $byteCsv + " byte, scritto il " + $dataCsv + "   (oggi e' " + $oggi + ")")
Dico ("  corsa eseguita tramite: " + $comeCorso)

# =====================================================================
#  LA RACCOLTA
# =====================================================================
$referto = Join-Path $cart "riparazione_news.txt"
$intestazione = @(
  "RIPARAZIONE DEL CANALE NEWS SUL VPS",
  ("data: " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss", $INV) + "   <-- deve essere di ADESSO"),
  ("macchina: " + $env:COMPUTERNAME + "   utente: " + $env:USERNAME),
  ("attivita': " + $Task + "   destinazione: " + $DestDir),
  ("pin: " + $Pin),
  ("verdetto: " + $classe + "   codice corsa: " + $codice),
  "sorgente: backtest_pipeline/righe/RIGA_RIPARA_NEWS.ps1 (MARCATORE_RIGA_RIPARA_NEWS_v1)",
  "----------------------------------------------------------------------"
)
Set-Content -LiteralPath $referto -Value $intestazione -Encoding ASCII
Add-Content -LiteralPath $referto -Value $righe -Encoding ASCII
$zip = $cart + ".zip"
Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
Compress-Archive -Path (Join-Path $cart "*") -DestinationPath $zip -Force
Write-Host ""
Write-Host "=== RACCOLTA ===" -ForegroundColor Cyan
Write-Host ("  referto : " + $referto) -ForegroundColor Green
Write-Host ("  zip     : " + $zip) -ForegroundColor Green
Write-Host "  file attesi: riparazione_news.txt, ATTIVITA_COME_ERA_*.xml, aggiorna_news_dal_pin.ps1, aggiorna_news_*.log" -ForegroundColor Green
Get-ChildItem -LiteralPath $cart -File | Select-Object Name, Length | Format-Table -AutoSize
Write-Host "  La riga 'data:' in cima al referto deve essere di ADESSO." -ForegroundColor Magenta
exit $uscita
