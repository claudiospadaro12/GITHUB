# =====================================================================
#  riestrai_v21.ps1 -- riestrae la config del NasdaqOpeningBreakout v21
#  dal BACKUP del Desktop (backup_v21_*), la riscrive in
#  Desktop\v21_config.txt e la STAMPA in console (basta lo screenshot).
#  Da lanciare SUL VPS (dove e' stato fatto lo spegnimento delle 14:22).
# =====================================================================
$ErrorActionPreference = "Stop"

Write-Host ("PC: " + $env:COMPUTERNAME + "  utente: " + $env:USERNAME) -ForegroundColor Gray

$desk = Join-Path $env:USERPROFILE "Desktop"
$bkps = Get-ChildItem $desk -Directory -Filter "backup_v21_*" -ErrorAction SilentlyContinue |
  Sort-Object Name -Descending
if (-not $bkps) {
  Write-Host "NESSUN backup_v21_* su questo Desktop: SEI SUL PC SBAGLIATO? Lo spegnimento e' stato fatto sul VPS." -ForegroundColor Red
  exit 1
}
$bk = $bkps[0]
Write-Host ("backup: " + $bk.FullName) -ForegroundColor Gray

$chr = Get-ChildItem $bk.FullName -Filter "*.chr" | Select-Object -First 1
if (-not $chr) { Write-Host "Backup trovato ma senza .chr dentro: mandami lo screenshot della cartella." -ForegroundColor Red; exit 1 }

$txt = Get-Content $chr.FullName -Raw
$righe = @("; CONFIG NasdaqOpeningBreakout v21 -- riestratta da " + $chr.Name)
$pm = [regex]::Match($txt, "period=([0-9]+)")
if ($pm.Success) { $righe += ("; period grafico = " + $pm.Groups[1].Value) }
$sm = [regex]::Match($txt, "symbol=([A-Za-z0-9#\.]+)")
if ($sm.Success) { $righe += ("; simbolo = " + $sm.Groups[1].Value) }
$im = [regex]::Match($txt, "(?s)<expert>.*?<inputs>(.*?)</inputs>")
if ($im.Success) {
  foreach ($l in ($im.Groups[1].Value -split "\r?\n")) {
    if ($l -match "^\s*[A-Za-z0-9_]+=") { $righe += $l.Trim() }
  }
} else { $righe += "; ATTENZIONE: blocco <inputs> non trovato nel .chr" }

$out = Join-Path $desk "v21_config.txt"
$righe -join "`r`n" | Set-Content -Path $out -Encoding ASCII
Write-Host ("SCRITTO: " + $out + " (" + $righe.Count + " righe)") -ForegroundColor Green
Write-Host ""
Write-Host "=== CONTENUTO (fai screenshot se non riesci a mandare il file) ===" -ForegroundColor White
$righe | ForEach-Object { Write-Host $_ }
