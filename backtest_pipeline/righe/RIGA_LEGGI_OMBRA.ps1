# =====================================================================
#  RIGA_LEGGI_OMBRA.ps1 -- lettura di SOLA LETTURA dei file dell'ombra EMA200
#  MARCATORE_RIGA_LEGGI_OMBRA_v1
#
#  BERSAGLIO: SOLO una finestra PowerShell sul VPS VMI3047753.
#  Legge e COPIA (senza modificarli) i file dell'ombra nella cartella dati del
#  terminale 50503392 (C:\Program Files\BCM Markets MT5 Terminal, cartella dati
#  215D85D767A1C39E22D242C8114BF9F5, sottocartella MQL5\Files\ABTG_Ombra) in una
#  cartella OMBRA_LETTURA_* sul Desktop del VPS, con transcript e zip.
#  NON apre, NON chiude, NON attacca e NON stacca nessun EA o terminale.
#  NON tocca 50504263 (-V3), 10105439 (C:\BCM_Reale, REALE), 1514806751 (C:\FTMO),
#  50503635 (C:\MT5_MANUALE), 50504400 (C:\MT5_Backtest), Pepperstone, Tickmill.
#  NON lancia nessun processo, NON scrive nella cartella dati del terminale.
#  ASCII puro. Niente exit (chiuderebbe la finestra). Nessuna riga vuota nei blocchi.
# =====================================================================
$ErrorActionPreference = "Continue"
if ($env:COMPUTERNAME -ne "VMI3047753") {
  throw ("QUESTA RIGA GIRA SOLO SUL VPS VMI3047753. Qui la macchina si chiama: " + $env:COMPUTERNAME + ". Non ho letto niente.")
}
$dd = "215D85D767A1C39E22D242C8114BF9F5"
$dir = Join-Path $env:APPDATA ("MetaQuotes\Terminal\" + $dd + "\MQL5\Files\ABTG_Ombra")
if (-not (Test-Path -LiteralPath $dir)) {
  throw ("Cartella dell'ombra NON trovata: " + $dir + " (ombra mai partita o cartella diversa). Non ho letto altro.")
}
$desk = [Environment]::GetFolderPath("Desktop")
$ts = Get-Date -Format "yyyyMMdd_HHmmss"
$cart = Join-Path $desk ("OMBRA_LETTURA_" + $ts)
$log = $cart + ".txt"
Start-Transcript -LiteralPath $log | Out-Null
try {
  $o = Get-CimInstance Win32_OperatingSystem
  Write-Host ("RAM DISPONIBILE del VPS: " + [math]::Round($o.FreePhysicalMemory / 1024) + " MB") -ForegroundColor Cyan
  Write-Host (Get-Process terminal64 | Select-Object Id, @{n="WorkingSet_MB";e={[math]::Round($_.WorkingSet64 / 1MB)}}, @{n="CPU_secondi";e={[math]::Round($_.CPU)}}, Path | Format-Table -AutoSize | Out-String -Width 250)
  Write-Host "Il terminale dell'ombra e' quello con cartella C:\Program Files\BCM Markets MT5 Terminal (senza -V3)."
  $fs = @(Get-ChildItem -LiteralPath $dir -File)
  Write-Host ("FILE DELL'OMBRA (" + $fs.Count + "):")
  Write-Host ($fs | Select-Object Name, Length, LastWriteTime | Format-Table -AutoSize | Out-String -Width 250)
  $bat = Join-Path $dir "ombra_battito.txt"
  if (Test-Path -LiteralPath $bat) {
    Write-Host "--- ombra_battito.txt (tutto) ---" -ForegroundColor Cyan
    Get-Content -LiteralPath $bat | ForEach-Object { Write-Host $_ }
  } else {
    Write-Host "ombra_battito.txt NON presente" -ForegroundColor Yellow
  }
  $lg = Join-Path $dir "ombra_log.txt"
  if (Test-Path -LiteralPath $lg) {
    Write-Host "--- ombra_log.txt (ultime 30 righe) ---" -ForegroundColor Cyan
    Get-Content -LiteralPath $lg -Tail 30 | ForEach-Object { Write-Host $_ }
  } else {
    Write-Host "ombra_log.txt NON presente" -ForegroundColor Yellow
  }
  $conta = {
    $s = [IO.File]::Open($args[0], [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
    $r = New-Object IO.StreamReader($s)
    $n = 0
    while ($null -ne $r.ReadLine()) { $n++ }
    $r.Close()
    $s.Close()
    $n
  }
  Write-Host "--- RIGHE DEI CSV (intestazione inclusa) ---" -ForegroundColor Cyan
  foreach ($f in ($fs | Where-Object { $_.Extension -eq ".csv" })) {
    $n = -1
    try { $n = & $conta $f.FullName } catch { Write-Host ("  lettura fallita: " + $f.Name) -ForegroundColor Yellow }
    Write-Host ("  " + $f.Name + " : " + $n + " righe")
  }
  $null = New-Item -ItemType Directory -Path $cart -Force
  $copiati = 0
  $saltati = 0
  foreach ($f in $fs) {
    if ($f.Length -gt 50MB) {
      Write-Host ("  NON copiato (oltre 50 MB): " + $f.Name) -ForegroundColor Yellow
      $saltati++
      continue
    }
    try {
      $in = [IO.File]::Open($f.FullName, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
      $out = [IO.File]::Create((Join-Path $cart $f.Name))
      $in.CopyTo($out)
      $out.Close()
      $in.Close()
      $copiati++
    } catch {
      Write-Host ("  COPIA FALLITA: " + $f.Name + " -- " + $_.Exception.Message) -ForegroundColor Red
      $saltati++
    }
  }
  Write-Host ("Copiati " + $copiati + " file, non copiati " + $saltati + " in " + $cart)
  Write-Host ("ora locale " + (Get-Date).ToString("HH:mm:ss") + " -- SOLA LETTURA: nella cartella dati del terminale non ho scritto ne toccato niente.")
} finally {
  Stop-Transcript | Out-Null
}
if (-not (Test-Path -LiteralPath $log)) {
  Write-Host ("ATTENZIONE: il file " + $log + " NON e' stato creato: copia a mano tutta la finestra e mandala a Claude.") -ForegroundColor Red
} else {
  $zip = $cart + ".zip"
  Compress-Archive -LiteralPath @($cart, $log) -DestinationPath $zip -Force
  Write-Host ""
  Write-Host "FINE. Da mandare a Claude: lo zip sul Desktop del VPS:"
  Write-Host ("  " + $zip)
  Write-Host "Da guardare in console: il blocco ombra_battito.txt (giri_oltre_tetto: era 13) e la riga Copiati."
}
