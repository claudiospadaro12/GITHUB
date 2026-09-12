# =====================================================================
#  installa_script.ps1  --  installa e compila TUTTI gli script ABTG
# ---------------------------------------------------------------------
#  Copia mql5\Scripts\ABTG_*.mq5 nel terminale BCM e li compila, cosi'
#  compaiono in "Navigatore > Script" pronti da trascinare su un grafico.
#  (scarica-storico, studio NFP, ecc.). MT5 puo' restare aperto.
# =====================================================================
$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "=== INSTALLO GLI SCRIPT ABTG ===" -ForegroundColor Cyan

# rileva terminale BCM + cartella dati
# ---------------------------------------------------------------------
#  IL BERSAGLIO (riscritto il 12/09/2026)
#  Questo script COPIA e RICOMPILA dentro la cartella dati del terminale
#  che scegli qui. Il bersaglio giusto E' il piccolo 50503392 -- e' il
#  mandato di questo script: installare nel terminale che Claudio usa a
#  mano. Quello NON si cambia.
#  Si cambiano le DUE scorciatoie che stavano qui, e sono difetti veri:
#   1. il RIPIEGO "*BCM Markets*" ALLARGAVA il bersaglio e prendeva
#      anche il 100k -V3 (50504263). Un ripiego che allarga il bersaglio
#      di uno script che RICOMPILA non e' un ripiego: e' un incidente
#      rimandato. Tolto: se il piccolo non c'e', si muore.
#   2. "-First 1" SENZA ordinamento vuol dire "quello che il filesystem
#      ha restituito per primo". Su un insieme trovato per RICERCA non e'
#      una scelta: e' un SORTEGGIO. Adesso, se ne trova piu' di uno, si
#      ferma e li stampa -- il modello e' RIGA_R96_APERTURA_USA.ps1:417.
# ---------------------------------------------------------------------
$allTerm = @(Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue)
$candidati = @($allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*" })
if ($candidati.Count -eq 0) {
  Write-Host "Terminale del piccolo (50503392) non trovato." -ForegroundColor Red
  Write-Host "  cercato: una cartella *BCM Markets MT5 Terminal* che NON sia *-V3*." -ForegroundColor Red
  Write-Host "  NON allargo la ricerca a *BCM Markets*: li' dentro c'e' anche il 100k" -ForegroundColor Red
  Write-Host "  50504263, e questo script COMPILA nel terminale che sceglie." -ForegroundColor Red
  exit 1
}
if ($candidati.Count -gt 1) {
  Write-Host "AMBIGUO: trovati $($candidati.Count) terminali che corrispondono. Mi fermo." -ForegroundColor Red
  foreach ($c in $candidati) { Write-Host ("  " + $c.DirectoryName) -ForegroundColor Red }
  Write-Host "  Un '-First 1' qui sarebbe un sorteggio, e questo script RICOMPILA." -ForegroundColor Red
  exit 1
}
$cand = $candidati[0]
$MetaEditor = Join-Path $cand.DirectoryName "metaeditor64.exe"
$instDir = $cand.DirectoryName
$termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$DataFolder = Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue | Where-Object {
    $o = Join-Path $_.FullName "origin.txt"
    (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $instDir)
} | Select-Object -First 1 -ExpandProperty FullName
if (-not $DataFolder) { Write-Host "Cartella dati non trovata." -ForegroundColor Red; exit 1 }

# installa sia gli Script sia gli Indicatori ABTG
$folders = @(
    @{ src = "..\mql5\Scripts";     dst = "MQL5\Scripts";     nome = "Script" },
    @{ src = "..\mql5\Indicators";  dst = "MQL5\Indicators";  nome = "Indicatori" }
)
$tot = 0
foreach ($fo in $folders) {
    $Src = Join-Path $RepoRoot $fo.src
    if (-not (Test-Path $Src)) { continue }
    $Dst = Join-Path $DataFolder $fo.dst
    New-Item -ItemType Directory -Force -Path $Dst | Out-Null
    $files = Get-ChildItem -Path $Src -Filter "ABTG_*.mq5" -ErrorAction SilentlyContinue
    if (-not $files) { continue }
    Write-Host "`n[$($fo.nome)]" -ForegroundColor Yellow
    foreach ($f in $files) {
        Copy-Item $f.FullName -Destination $Dst -Force
        $s = Join-Path $Dst $f.Name
        & $MetaEditor "/compile:$s" "/log" | Out-Null
        $ex5 = [System.IO.Path]::ChangeExtension($s, ".ex5")
        if (Test-Path $ex5) { Write-Host "   OK  $($f.Name)" -ForegroundColor Green; $tot++ }
        else { Write-Host "   ERRORE $($f.Name)" -ForegroundColor Red }
    }
}
Write-Host "`nFatto ($tot compilati). In MT5: Navigatore > Script / Indicatori (tasto destro > Aggiorna)." -ForegroundColor Cyan
