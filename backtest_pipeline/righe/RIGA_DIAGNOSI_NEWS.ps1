# =====================================================================
#  MARCATORE_RIGA_DIAGNOSI_NEWS_v1
#  RIGA_DIAGNOSI_NEWS.ps1 -- 19/09/2026
#
#  A COSA SERVE, in una frase: dire COSA ripuntare PRIMA di ripuntarlo.
#
#  IL FATTO CHE LA GENERA (classe 458 della checklist):
#    il riordino a mano del Desktop del VPS del 16/09/2026 alle 19:42 ha
#    spostato dentro Archivio_2026-09-16_1942 la cartella da cui parte
#    l'attivita' pianificata ABTG_AggiornaNews delle 07:20. Da allora
#    l'attivita' esce 4294770688 (= -196608: e' il codice che
#    powershell.exe restituisce quando il file passato a -File NON
#    ESISTE) invece di 0.
#
#  QUESTO SCRIPT NON RIPARA NIENTE. E' SOLA LETTURA:
#    - non sposta, non copia, non cancella, non rinomina niente;
#    - non tocca nessuna attivita' pianificata (solo /Query);
#    - non apre, non chiude e non tocca NESSUN terminale MT5, di nessun
#      conto. Li ELENCA (PID, titolo, cartella) e basta, perche' la
#      regola di casa dice che il riconoscimento deve essere un fatto
#      stampato e non un'inferenza;
#    - l'unica cosa che scrive e' il REFERTO sul Desktop (piu' lo zip),
#      che e' la raccolta imposta dalla regola delle righe di lancio.
#
#  COSA STAMPA, nell'ordine chiesto:
#    (a) il percorso pieno che l'attivita' esegue OGGI;
#    (b) se quel percorso ESISTE;
#    (c) dove sta oggi una copia di aggiorna_news.ps1 (C:\ABTG, Desktop
#        in profondita', quindi anche dentro l'archivio del 16/09), con
#        impronta, data, il BRANCH scritto dentro e se ha i controlli
#        del 12/09;
#    (d) la data dell'ultimo calendario news scritto e DOVE sta, per
#        ogni cartella dati di ogni terminale, piu' Common\Files;
#    (e) se gli EA lo leggono da Common\Files o dalla cartella del loro
#        terminale -- misurato sui sorgenti che stanno sulla macchina,
#        non ricordato.
# =====================================================================
param(
  [string]$Task = "ABTG_AggiornaNews",
  [int]$ProfonditaDesktop = 6
)

$ErrorActionPreference = "Stop"
$INV = [System.Globalization.CultureInfo]::InvariantCulture
$stamp = (Get-Date).ToString("yyyyMMdd_HHmm", $INV)
$dsk = [Environment]::GetFolderPath('Desktop')
$cart = Join-Path $dsk ("DIAGNOSI_NEWS_" + $stamp)
New-Item -ItemType Directory -Force -Path $cart | Out-Null
$referto = Join-Path $cart "diagnosi_news.txt"
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
function Impronta([string]$p){
  try { return (Get-FileHash -LiteralPath $p -Algorithm SHA256).Hash } catch { return "(impronta non calcolabile)" }
}

# --- LE FUNZIONI PURE, quelle su cui girano i contro-esempi -----------
# Sono scritte come funzioni apposta: si possono estrarre e provare su
# un'altra macchina senza Task Scheduler, che e' l'unico modo per far
# girare davvero un contro-esempio invece di raccontarlo.

function EstraiPercorsoDaArgomenti([string]$argomenti){
  # Da "-NoProfile -ExecutionPolicy Bypass -File ""C:\a b\x.ps1"" -Flag"
  # tira fuori C:\a b\x.ps1. Gestisce le virgolette, gli apici e il
  # percorso nudo. Ritorna "" se non c'e' nessun -File.
  if([string]::IsNullOrEmpty($argomenti)){ return "" }
  $m = [regex]::Match($argomenti, '-File\s+(?:"([^"]+)"|''([^'']+)''|(\S+))', 'IgnoreCase')
  if(-not $m.Success){ return "" }
  foreach($g in 1,2,3){
    if($m.Groups[$g].Success){ return $m.Groups[$g].Value }
  }
  return ""
}

function LeggiAttivita([string]$nome){
  # Ritorna un oggetto con: Trovata, Esegue, Argomenti, Fonte.
  # Due strade, e servono tutte e due: il modulo ScheduledTasks quando
  # c'e', schtasks quando il modulo non e' caricabile. Se non si legge
  # niente si DICE, non si tira a indovinare.
  $ris = [pscustomobject]@{ Trovata=$false; Esegue=""; Argomenti=""; Fonte="(nessuna)" }
  try{
    $t = Get-ScheduledTask -TaskName $nome -ErrorAction Stop
    foreach($a in @($t.Actions)){
      if($a.Execute){
        $ris.Trovata = $true
        $ris.Esegue = [string]$a.Execute
        $ris.Argomenti = [string]$a.Arguments
        $ris.Fonte = "Get-ScheduledTask"
        break
      }
    }
    if($ris.Trovata){ return $ris }
  } catch { }
  try{
    # -Width 8000 non e' cosmetico: senza, Out-String manda a capo a 80
    # colonne e un percorso lungo si spezza a meta' (classe 458).
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
          } else {
            $ris.Esegue = $tutto
          }
          break
        }
      }
    }
  } catch { }
  return $ris
}

function DescriviCopia([string]$percorso){
  # La carta d'identita' di una copia di aggiorna_news.ps1: data, peso,
  # impronta, BRANCH scritto dentro, e se ha i controlli del 12/09.
  # Il branch e' la cosa che conta di piu': la copia vecchia puntava a
  # claude/creating-agents-SgGpD, cioe' a un ramo fermo.
  $o = [pscustomobject]@{
    Percorso=$percorso; Esiste=$false; Data=""; Byte=0; Sha=""; Branch="(non trovato)";
    HaVerifica=$false; HaMarcatore=$false
  }
  if(-not (Test-Path -LiteralPath $percorso -PathType Leaf)){ return $o }
  $f = Get-Item -LiteralPath $percorso
  $o.Esiste = $true
  $o.Data = Quando $f.LastWriteTime
  $o.Byte = $f.Length
  $o.Sha = Impronta $percorso
  $testo = ""
  try { $testo = Get-Content -LiteralPath $percorso -Raw } catch { $testo = "" }
  $mb = [regex]::Match($testo, 'raw\.githubusercontent\.com/[^/]+/[^/]+/([^/]+(?:/[^/]+)?)/data/abtg_news\.csv')
  if($mb.Success){ $o.Branch = $mb.Groups[1].Value }
  if($testo -match 'file VUOTO'){ $o.HaVerifica = $true }
  if($testo -match 'MARCATORE_AGGIORNA_NEWS_v2'){ $o.HaMarcatore = $true }
  return $o
}

# =====================================================================
#  (a) e (b) -- COSA ESEGUE L'ATTIVITA' OGGI, E QUEL PERCORSO C'E'?
# =====================================================================
Dico "======================================================================" "Cyan"
Dico ("  DIAGNOSI DEL CANALE NEWS -- " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss", $INV)) "Cyan"
Dico "  SOLA LETTURA: non riparo niente, non tocco nessun terminale MT5." "Cyan"
Dico "======================================================================" "Cyan"

$att = LeggiAttivita $Task
Titolo ("(a) L'ATTIVITA' " + $Task + " OGGI")
Dico ("  letta con     : " + $att.Fonte)
if(-not $att.Trovata){
  Dico "  ATTIVITA' NON TROVATA (o elenco non leggibile da questa console)." "Red"
  Dico "  Rilancia questa riga da una console di Amministratore prima di concludere." "Yellow"
} else {
  Dico ("  esegue        : " + $att.Esegue)
  Dico ("  argomenti     : " + $att.Argomenti)
}
$percorsoTask = EstraiPercorsoDaArgomenti $att.Argomenti
Titolo "(b) QUEL PERCORSO ESISTE?"
if([string]::IsNullOrEmpty($percorsoTask)){
  Dico "  nessun -File negli argomenti: non so quale file esegue." "Red"
} else {
  Dico ("  percorso pieno: " + $percorsoTask) "White"
  $c1 = Test-Path -LiteralPath $percorsoTask -PathType Leaf
  if($c1){
    Dico "  ESISTE        : SI" "Green"
  } else {
    Dico "  ESISTE        : NO   <-- e' questa la causa del 4294770688" "Red"
    $padre = Split-Path -Parent $percorsoTask
    while($padre -and -not (Test-Path -LiteralPath $padre)){ $padre = Split-Path -Parent $padre }
    Dico ("  il pezzo di percorso piu' lungo che esiste ancora: " + $padre) "Yellow"
  }
}

# =====================================================================
#  (c) -- DOVE STA OGGI UNA COPIA DI aggiorna_news.ps1
# =====================================================================
Titolo "(c) LE COPIE DI aggiorna_news.ps1 CHE STANNO SU QUESTA MACCHINA"
$trovate = New-Object System.Collections.ArrayList
$daGuardare = @("C:\ABTG")
foreach($r in $daGuardare){
  if(Test-Path -LiteralPath $r){
    foreach($f in @(Get-ChildItem -LiteralPath $r -Filter "aggiorna_news.ps1" -Recurse -File -Force -ErrorAction SilentlyContinue)){
      [void]$trovate.Add($f.FullName)
    }
  }
}
# il Desktop si guarda in PROFONDITA': dopo il riordino del 16/09 la
# copia vecchia sta dentro Archivio_2026-09-16_1942\<cartella>\..., e
# dopo un secondo riordino starebbe un livello ancora piu' sotto.
foreach($f in @(Get-ChildItem -LiteralPath $dsk -Filter "aggiorna_news.ps1" -Recurse -Depth $ProfonditaDesktop -File -Force -ErrorAction SilentlyContinue)){
  [void]$trovate.Add($f.FullName)
}
if($percorsoTask -and (Test-Path -LiteralPath $percorsoTask -PathType Leaf)){ [void]$trovate.Add($percorsoTask) }
$uniche = @($trovate | Sort-Object -Unique)
if($uniche.Count -eq 0){
  Dico "  NESSUNA COPIA TROVATA ne' in C:\ABTG ne' sul Desktop." "Red"
} else {
  Dico ("  trovate " + $uniche.Count + " copie (profondita' Desktop = " + $ProfonditaDesktop + "):")
  foreach($u in $uniche){
    $d = DescriviCopia $u
    Dico ""
    Dico ("   * " + $d.Percorso) "White"
    Dico ("     data          : " + $d.Data)
    Dico ("     byte          : " + $d.Byte + "    impronta: " + $d.Sha)
    Dico ("     branch dentro : " + $d.Branch)
    Dico ("     ha i controlli del 12/09 (rifiuta un file vuoto/troncato): " + $d.HaVerifica)
    Dico ("     ha MARCATORE_AGGIORNA_NEWS_v2                            : " + $d.HaMarcatore)
    if($u -ieq $percorsoTask){ Dico "     <-- E' QUESTA CHE L'ATTIVITA' ESEGUE" "Magenta" }
  }
}

# =====================================================================
#  (d) -- IL CALENDARIO IN CAMPO: dove sta, di che giorno e', quanto pesa
# =====================================================================
Titolo "(d) IL CALENDARIO abtg_news.csv IN CAMPO"
$termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$bersagli = New-Object System.Collections.ArrayList
if(Test-Path -LiteralPath $termRoot){
  foreach($d in @(Get-ChildItem -LiteralPath $termRoot -Directory -Force -ErrorAction SilentlyContinue)){
    $chi = "(senza origin.txt)"
    $o = Join-Path $d.FullName "origin.txt"
    if(Test-Path -LiteralPath $o){
      try { $chi = (Get-Content -LiteralPath $o -Raw).Trim() } catch { $chi = "(origin.txt illeggibile)" }
    }
    if($d.Name -ieq "Common"){ $chi = "CARTELLA COMUNE (Common\Files: la legge chi apre con FILE_COMMON)" }
    [void]$bersagli.Add([pscustomobject]@{
      Chi = $chi
      Csv = (Join-Path $d.FullName "MQL5\Files\abtg_news.csv")
    })
  }
}
$comune = Join-Path $termRoot "Common\Files\abtg_news.csv"
[void]$bersagli.Add([pscustomobject]@{ Chi="CARTELLA COMUNE (Common\Files)"; Csv=$comune })

$quantiVivi = 0
foreach($b in @($bersagli | Sort-Object Csv -Unique)){
  Dico ""
  Dico ("   cartella di : " + $b.Chi) "White"
  Dico ("   file        : " + $b.Csv)
  if(-not (Test-Path -LiteralPath $b.Csv -PathType Leaf)){
    Dico "   NON C'E'" "DarkGray"
    continue
  }
  $quantiVivi = $quantiVivi + 1
  $fi = Get-Item -LiteralPath $b.Csv
  $nr = 0
  $prime = @()
  try{
    $tutte = @(Get-Content -LiteralPath $b.Csv -ErrorAction SilentlyContinue)
    $nr = $tutte.Count
    if($nr -gt 0){ $prime = @($tutte | Select-Object -First 2) }
  } catch { }
  $col = "Green"
  if($fi.Length -eq 0){ $col = "Red" }
  Dico ("   ULTIMA SCRITTURA: " + (Quando $fi.LastWriteTime) + "   byte: " + $fi.Length + "   righe: " + $nr) $col
  if($fi.Length -eq 0){
    Dico "   FILE VUOTO: per l'EA equivale a NESSUNA NOTIZIA -- il filtro news e' di fatto SPENTO." "Red"
  }
  foreach($p in $prime){ Dico ("     | " + $p) "DarkGray" }
  if($nr -ge 3){ Dico ("     | ... ultima riga: " + $tutte[$nr-1]) "DarkGray" }
  $prima = $b.Csv + ".prima"
  if(Test-Path -LiteralPath $prima -PathType Leaf){
    $fp = Get-Item -LiteralPath $prima
    Dico ("   copia .prima    : " + (Quando $fp.LastWriteTime) + "   byte: " + $fp.Length) "DarkGray"
  }
}
if($quantiVivi -eq 0){ Dico "" ; Dico "   NESSUN abtg_news.csv TROVATO IN NESSUNA CARTELLA DATI." "Red" }

# --- il log che aggiorna_news.ps1 scrive dal 12/09 -------------------
$logDir = Join-Path $env:USERPROFILE "abtg_news_log"
Dico ""
Dico ("   log delle corse : " + $logDir)
if(Test-Path -LiteralPath $logDir){
  $ll = @(Get-ChildItem -LiteralPath $logDir -Filter "aggiorna_news_*.log" -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 3)
  if($ll.Count -eq 0){
    Dico "   la cartella c'e' ma e' VUOTA: nessuna corsa della versione nuova ha mai scritto qui." "Yellow"
  } else {
    foreach($l in $ll){ Dico ("     " + (Quando $l.LastWriteTime) + "  " + $l.Name + "  (" + $l.Length + " byte)") }
    Dico "   ultime righe dell'ultimo log:" "DarkGray"
    foreach($r in @(Get-Content -LiteralPath $ll[0].FullName -Tail 8 -ErrorAction SilentlyContinue)){ Dico ("     | " + $r) "DarkGray" }
  }
} else {
  Dico "   la cartella NON ESISTE: la versione con il log (12/09) non ha mai girato su questa macchina." "Yellow"
}

# =====================================================================
#  (e) -- GLI EA LO LEGGONO DA Common\Files O DALLA LORO CARTELLA?
# =====================================================================
Titolo "(e) DA DOVE LO LEGGONO GLI EA"
Dico "  Si misura sui sorgenti .mq5 che stanno su questa macchina: la riga" "White"
Dico "  che conta e' la FileOpen del file news. Se NON c'e' il flag" "White"
Dico "  FILE_COMMON, l'EA legge da <cartella dati del SUO terminale>\MQL5\Files," "White"
Dico "  e Common\Files non c'entra niente." "White"
$righeOpen = 0
$conComune = 0
if(Test-Path -LiteralPath $termRoot){
  foreach($d in @(Get-ChildItem -LiteralPath $termRoot -Directory -Force -ErrorAction SilentlyContinue)){
    $exp = Join-Path $d.FullName "MQL5\Experts"
    if(-not (Test-Path -LiteralPath $exp)){ continue }
    $chi = $d.Name
    $o = Join-Path $d.FullName "origin.txt"
    if(Test-Path -LiteralPath $o){
      try { $chi = (Get-Content -LiteralPath $o -Raw).Trim() } catch { }
    }
    $trovateQui = @(Select-String -Path (Join-Path $exp "*.mq5") -SimpleMatch -Pattern "FileOpen(InpNewsFile" -ErrorAction SilentlyContinue)
    if($trovateQui.Count -eq 0){ continue }
    Dico ""
    Dico ("   in " + $chi) "White"
    foreach($t in @($trovateQui | Select-Object -First 6)){
      $righeOpen = $righeOpen + 1
      $testo = $t.Line.Trim()
      $etichetta = "legge dalla cartella del SUO terminale"
      if($testo -match "FILE_COMMON"){
        $etichetta = "legge da Common\Files"
        $conComune = $conComune + 1
      }
      Dico ("     " + (Split-Path -Leaf $t.Path) + " r." + $t.LineNumber + "  -> " + $etichetta)
      Dico ("       | " + $testo) "DarkGray"
    }
    if($trovateQui.Count -gt 6){ Dico ("     ... e altri " + ($trovateQui.Count - 6) + " sorgenti con la stessa riga") "DarkGray" }
  }
}
Dico ""
if($righeOpen -eq 0){
  Dico "   NESSUN sorgente .mq5 con quella FileOpen trovato sulla macchina:" "Yellow"
  Dico "   sui terminali in forward spesso ci sono solo gli .ex5 compilati." "Yellow"
  Dico "   Riferimento misurato in repo: mql5\Experts\ABTG_PTE.mq5 r.637" "Yellow"
  Dico "     FileOpen(InpNewsFile,FILE_READ|FILE_CSV|FILE_ANSI,';')  -> NIENTE FILE_COMMON" "Yellow"
} else {
  Dico ("   righe FileOpen esaminate: " + $righeOpen + "   di cui con FILE_COMMON: " + $conComune) "White"
  if($conComune -eq 0){
    Dico "   VERDETTO: si legge dalla cartella dati del PROPRIO terminale (MQL5\Files)." "Green"
  } else {
    Dico "   VERDETTO: ATTENZIONE, almeno un EA legge da Common\Files: i bersagli sono DUE." "Red"
  }
}
Dico ""
Dico "   NOTA che vale per tutti e due i casi: se il file manca o e' VUOTO, l'EA" "Yellow"
Dico "   scrive 'file news non trovato: filtro di fatto spento' e OPERA LO STESSO." "Yellow"
Dico "   Il filtro news fallisce APERTO: nessuna notizia letta = nessun blocco." "Yellow"

# =====================================================================
#  I TERMINALI VIVI -- elencati, non toccati (regola dei tre terminali)
# =====================================================================
Titolo "I TERMINALI MT5 VIVI ADESSO (elencati e basta: PID, titolo, cartella)"
$tt = @(Get-Process -Name terminal64 -ErrorAction SilentlyContinue | Select-Object Id, MainWindowTitle, Path)
if($tt.Count -eq 0){
  Dico "   nessun terminal64 in esecuzione"
} else {
  foreach($t in $tt){ Dico ("   PID " + $t.Id + "  |  " + $t.MainWindowTitle + "  |  " + $t.Path) }
}
Dico ""
Dico "   Questa riga non ne ha aperto, chiuso o toccato nemmeno uno." "Green"

# =====================================================================
#  LA RACCOLTA (regola delle righe di lancio, punto 2)
# =====================================================================
$intestazione = @(
  "DIAGNOSI DEL CANALE NEWS SUL VPS",
  ("data: " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss", $INV) + "   <-- deve essere di ADESSO"),
  ("macchina: " + $env:COMPUTERNAME + "   utente: " + $env:USERNAME),
  ("attivita': " + $Task),
  "sorgente: backtest_pipeline/righe/RIGA_DIAGNOSI_NEWS.ps1 (MARCATORE_RIGA_DIAGNOSI_NEWS_v1)",
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
Write-Host "  file attesi nello zip: diagnosi_news.txt" -ForegroundColor Green
Get-ChildItem -LiteralPath $cart -File | Select-Object Name, Length | Format-Table -AutoSize
Write-Host "  La riga 'data:' in cima al referto deve essere di ADESSO: se porta" -ForegroundColor Magenta
Write-Host "  un'altra ora stai leggendo un referto vecchio." -ForegroundColor Magenta
exit 0
