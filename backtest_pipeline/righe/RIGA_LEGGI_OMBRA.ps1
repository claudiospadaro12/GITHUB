# =====================================================================
#  RIGA_LEGGI_OMBRA.ps1 -- lettura di SOLA LETTURA dei file dell'ombra EMA200
#  MARCATORE_RIGA_LEGGI_OMBRA_v2
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
#  v2 (cancello 06/10): i file vivi si aprono SOLO per copiarli, in FileAccess.Read con
#  FileShare ReadWrite+Delete (l'EA apre in scrittura con FILE_SHARE_READ: la nostra
#  lettura deve concedergli scrittura E rinomina), chiusi in finally; battito, log e
#  conteggi si leggono dalle COPIE sul Desktop. ombra_stato.txt e ombra_stato.tmp NON si
#  aprono: l'EA li sostituisce con FileMove(FILE_REWRITE) ogni 15 s e una rinomina su un
#  file aperto da un altro processo puo' fallire anche con FileShare.Delete.
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
  try {
    $o = Get-CimInstance Win32_OperatingSystem -ErrorAction Stop
    Write-Host ("RAM DISPONIBILE del VPS: " + [math]::Round($o.FreePhysicalMemory / 1024) + " MB") -ForegroundColor Cyan
  } catch {
    Write-Host ("RAM non leggibile (" + $_.Exception.Message + "): proseguo con la copia.") -ForegroundColor Yellow
  }
  Write-Host (Get-Process terminal64 -ErrorAction SilentlyContinue | Select-Object Id, @{n="WorkingSet_MB";e={[math]::Round($_.WorkingSet64 / 1MB)}}, @{n="CPU_secondi";e={[math]::Round($_.CPU)}}, Path | Format-Table -AutoSize | Out-String -Width 250)
  Write-Host "Il terminale dell'ombra e' quello con cartella C:\Program Files\BCM Markets MT5 Terminal (senza -V3)."
  $fs = @(Get-ChildItem -LiteralPath $dir -File)
  Write-Host ("FILE DELL'OMBRA (" + $fs.Count + "):")
  Write-Host ($fs | Select-Object Name, Length, LastWriteTime | Format-Table -AutoSize | Out-String -Width 250)
  $null = New-Item -ItemType Directory -Path $cart -Force
  $cond = [IO.FileShare]::ReadWrite -bor [IO.FileShare]::Delete
  $copiati = 0
  $saltati = 0
  foreach ($f in $fs) {
    if ($f.Name -like "ombra_stato.*") {
      Write-Host ("  non aperto apposta (l'EA lo rinomina ogni 15 s): " + $f.Name + " -- " + $f.Length + " byte, scritto " + $f.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss", [Globalization.CultureInfo]::InvariantCulture)) -ForegroundColor DarkGray
      continue
    }
    if ($f.Length -gt 50MB) {
      Write-Host ("  NON copiato (oltre 50 MB): " + $f.Name) -ForegroundColor Yellow
      $saltati++
      continue
    }
    $in = $null
    $out = $null
    try {
      $in = [IO.File]::Open($f.FullName, [IO.FileMode]::Open, [IO.FileAccess]::Read, $cond)
      $out = [IO.File]::Create((Join-Path $cart $f.Name))
      $in.CopyTo($out)
      $copiati++
    } catch {
      Write-Host ("  COPIA FALLITA (non e' un guasto dell'ombra, si rilancia la riga): " + $f.Name + " -- " + $_.Exception.Message) -ForegroundColor Red
      $saltati++
    } finally {
      if ($null -ne $in) { $in.Dispose() }
      if ($null -ne $out) { $out.Dispose() }
    }
  }
  Write-Host ("Copiati " + $copiati + " file, non copiati " + $saltati + " in " + $cart)
  $bat = Join-Path $cart "ombra_battito.txt"
  if (Test-Path -LiteralPath $bat) {
    Write-Host "--- ombra_battito.txt (copia, tutto) ---" -ForegroundColor Cyan
    Get-Content -LiteralPath $bat | ForEach-Object { Write-Host $_ }
  } else {
    Write-Host "ombra_battito.txt NON copiato o NON presente" -ForegroundColor Yellow
  }
  $lg = Join-Path $cart "ombra_log.txt"
  if (Test-Path -LiteralPath $lg) {
    Write-Host "--- ombra_log.txt (copia, ultime 30 righe) ---" -ForegroundColor Cyan
    Get-Content -LiteralPath $lg -Tail 30 | ForEach-Object { Write-Host $_ }
  } else {
    Write-Host "ombra_log.txt NON copiato o NON presente" -ForegroundColor Yellow
  }
  Write-Host "--- RIGHE DEI CSV COPIATI (intestazione inclusa) ---" -ForegroundColor Cyan
  foreach ($c in @(Get-ChildItem -LiteralPath $cart -File -Filter "*.csv")) {
    $n = 0
    Get-Content -LiteralPath $c.FullName -ReadCount 1000 | ForEach-Object { $n += $_.Count }
    Write-Host ("  " + $c.Name + " : " + $n + " righe")
  }
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
  if (Test-Path -LiteralPath $zip) {
    Write-Host "FINE. Da mandare a Claude: lo zip sul Desktop del VPS:"
    Write-Host ("  " + $zip)
  } else {
    Write-Host ("ZIP NON creato: manda a Claude la cartella " + $cart + " e il file " + $log) -ForegroundColor Red
  }
  Write-Host "Da guardare in console: il blocco ombra_battito.txt (giri_oltre_tetto: era 13) e la riga Copiati."
}
