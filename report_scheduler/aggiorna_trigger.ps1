# =====================================================================
#  aggiorna_trigger.ps1  --  RIMETTE I TRIGGER SUL BRANCH GIUSTO
# ---------------------------------------------------------------------
#  PERCHE' ESISTE (15/08/2026)
#    La pagella settimanale del 15/08 e' uscita VUOTA ("Nessuno
#    statement con trade nel periodo", "lo statement arriva solo al
#    2026/07/24") e consigliava di riesportare lo storico da MT5.
#    Il consiglio mandava nel posto sbagliato: lo storico c'era.
#
#    La causa era una riga in trigger_weekly.ps1:
#        $ref = "claude/creating-agents-SgGpD"
#    cioe' il VECCHIO branch di default, ultimo commit 31/07, dove
#    trades_auto.csv finisce il 2026.07.24 - esattamente la data
#    stampata sul PDF. Il workflow girava su un repo di due settimane
#    e mezzo fa. Stesso difetto sulla pagella giornaliera.
#
#  COSA FA QUESTO SCRIPT
#    1. cerca nel Task Scheduler i task che lanciano i trigger e legge
#       da li' il PERCORSO VERO dei file (niente percorsi indovinati);
#    2. riscarica trigger_weekly.ps1 e trigger_report.ps1 dal commit
#       indicato, nella loro cartella;
#    3. VERIFICA che dentro ci sia $ref = "lavoro" e lo dice.
#
#  Se i task non esistono, cerca i file nei posti soliti e in ogni caso
#  stampa cosa ha fatto. Non tocca il Task Scheduler: sostituisce solo
#  il contenuto dei file, quindi le attivita' pianificate restano.
#
#  USO (sul VPS):
#    powershell -ExecutionPolicy Bypass -File .\aggiorna_trigger.ps1 -Rif <SHA>
# =====================================================================
param(
  [string] $Rif = "lavoro",     # commit SHA (o branch) da cui pescare
  [string] $Cartella = ""       # forza la cartella, se la trovi tu
)
$ErrorActionPreference = "Continue"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$Raw   = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Rif"
$files = @("trigger_weekly.ps1", "trigger_report.ps1")

function Riga($t, $c = "Gray") { Write-Host $t -ForegroundColor $c }

Riga "=== RIMETTO I TRIGGER SUL BRANCH GIUSTO ===" "Cyan"
Riga ("MACCHINA: " + $env:COMPUTERNAME + "   utente: " + $env:USERNAME) "Cyan"
Riga ("riferimento: " + $Rif) "DarkGray"
Riga ""

# --- 1. dove sono i file, secondo il Task Scheduler -------------------
$cartelle = New-Object System.Collections.ArrayList
if ($Cartella) { [void]$cartelle.Add($Cartella) }

Riga "1) cerco i task pianificati che lanciano i trigger" "Yellow"
try {
  foreach ($t in (Get-ScheduledTask -ErrorAction SilentlyContinue)) {
    foreach ($a in $t.Actions) {
      $arg = "" + $a.Arguments
      if ($arg -match "trigger_weekly\.ps1|trigger_report\.ps1") {
        Riga ("   task: " + $t.TaskName) "Green"
        if ($arg -match '["'']?([A-Za-z]:\\[^"'']*?)\\trigger_(?:weekly|report)\.ps1') {
          $dir = $matches[1]
          if (-not $cartelle.Contains($dir)) { [void]$cartelle.Add($dir) }
          Riga ("     -> cartella: " + $dir) "Green"
        } else {
          Riga ("     (non riesco a estrarre il percorso da: " + $arg + ")") "Yellow"
        }
      }
    }
  }
} catch { Riga ("   Task Scheduler non interrogabile: " + $_.Exception.Message) "Yellow" }

# --- ripiego: i posti soliti -----------------------------------------
foreach ($d in @((Join-Path $env:USERPROFILE "report_scheduler"),
                 (Join-Path $env:USERPROFILE "GITHUB\report_scheduler"),
                 (Join-Path $env:USERPROFILE "Desktop\report_scheduler"),
                 "C:\report_scheduler")) {
  if ((Test-Path (Join-Path $d "trigger_weekly.ps1")) -and -not $cartelle.Contains($d)) {
    [void]$cartelle.Add($d); Riga ("   trovata anche: " + $d) "Green"
  }
}

if ($cartelle.Count -eq 0) {
  Riga ""
  Riga "NON HO TROVATO i file da nessuna parte." "Red"
  Riga "Cercali tu con questa riga e rilancia con -Cartella <percorso>:" "Yellow"
  Riga '   Get-ChildItem C:\ -Recurse -Filter trigger_weekly.ps1 -EA SilentlyContinue | Select FullName' "White"
  exit 1
}

# --- 2. riscarico ----------------------------------------------------
Riga ""
Riga "2) riscarico i trigger dal commit indicato" "Yellow"
$scaricati = 0
foreach ($dir in $cartelle) {
  foreach ($f in $files) {
    $dest = Join-Path $dir $f
    if (-not (Test-Path $dest)) { continue }
    try {
      Copy-Item $dest ($dest + ".prima_del_15-08") -Force -EA SilentlyContinue
      Invoke-WebRequest -Uri "$Raw/report_scheduler/$f" -OutFile $dest -UseBasicParsing
      Riga ("   ok  " + $dest) "Green"
      $scaricati++
    } catch {
      Riga ("   NON scaricato " + $f + ": " + $_.Exception.Message) "Red"
    }
  }
}

# --- 3. la verifica che conta ----------------------------------------
Riga ""
Riga "3) verifica: dentro ci deve essere  \$ref = ""lavoro""" "Yellow"
$ok = 0; $ko = 0
foreach ($dir in $cartelle) {
  foreach ($f in $files) {
    $dest = Join-Path $dir $f
    if (-not (Test-Path $dest)) { continue }
    $riga = (Select-String -Path $dest -Pattern '^\s*\$ref\s*=' -EA SilentlyContinue | Select-Object -First 1).Line
    if ($riga -match '"lavoro"') { Riga ("   OK      " + $f + "   -> " + $riga.Trim()) "Green"; $ok++ }
    else { Riga ("   SBAGLIATO " + $f + "   -> " + ("" + $riga).Trim()) "Red"; $ko++ }
  }
}

Riga ""
if ($ko -eq 0 -and $ok -gt 0) {
  Riga "=== FATTO: $ok file su 'lavoro'. ===" "Green"
  Riga "Adesso rilancia la pagella settimanale:" "Cyan"
  Riga ("   powershell -ExecutionPolicy Bypass -File """ + (Join-Path $cartelle[0] "trigger_weekly.ps1") + """") "White"
  Riga "Nel PDF nuovo la sezione 'Andamento dei trade' NON deve piu' essere vuota." "Gray"
  Riga "Le copie di prima sono salvate accanto, con estensione .prima_del_15-08" "Gray"
} else {
  Riga "=== ATTENZIONE: $ko file NON sono a posto. Guarda le righe rosse. ===" "Red"
}
