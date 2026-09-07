# =====================================================================
#  MARCATORE_CODA_04_CAPACITA_MACCHINA_v1
#  RUNNER_SOLA_LETTURA
# ---------------------------------------------------------------------
#  COSA FA: STAMPA quanto e' grossa questa macchina -- core, RAM, disco
#  libero -- e quanto spazio si stanno gia' mangiando i terminali MT5.
#  Non scrive, non copia, non cancella: STAMPA.
#
#  PERCHE' ESISTE
#  Il 07/09 e' stato deciso di aggiungere un QUARTO MT5 dedicato ai
#  backtest (report/QUARTO_MT5_PIANO.md). La domanda vera non e' "dove
#  lo installo", e' "questa macchina regge un walk-forward a tick reali
#  MENTRE tiene vivi tre terminali con posizioni aperte?".
#  Quella domanda si risponde con un numero, non spostando installazioni.
#
#  I NUMERI CHE SERVONO E PERCHE'
#   - CORE: MT5 usa di default TUTTI i core come agenti del tester. Su
#     una macchina piccola un round affama il forward. Con pochi core la
#     risposta e' "il quarto MT5 sul VPS NON si fa", e il PC di backtest
#     resta l'unico posto.
#   - RAM: un agente del tester per core, ognuno col suo storico.
#   - DISCO: il terminale nuovo RI-SCARICA lo storico da zero. I 252
#     milioni di tick misurati il 03/09 non sono pochi.
#
#  ATTENZIONE, IL LIMITE, DICHIARATO: questa riga misura la MACCHINA,
#  non il CARICO. Dice quanti core ci sono, non quanti ne resterebbero
#  liberi durante un round. Il vero collaudo resta il canarino sul
#  forward DOPO la prima notte di backtest (passo 8 del piano).
# =====================================================================

Write-Host "=== CAPACITA' DELLA MACCHINA ==="
Write-Host ("data lettura: " + (Get-Date -Format "yyyy-MM-dd HH:mm:ss") + "  (ora locale)")
Write-Host ("nome macchina: " + $env:COMPUTERNAME + "   utente: " + $env:USERNAME)

# --- CPU
$core = 0; $logici = 0
try{
  $cpu = @(Get-CimInstance Win32_Processor -ErrorAction SilentlyContinue)
  foreach($c in $cpu){
    Write-Host ("    CPU: " + $c.Name)
    $core   += [int]$c.NumberOfCores
    $logici += [int]$c.NumberOfLogicalProcessors
  }
} catch { }
if($logici -eq 0){ $logici = [int]$env:NUMBER_OF_PROCESSORS }
Write-Host ("    core fisici: " + $core + "   processori logici: " + $logici)
Write-Host ""
if($logici -le 2){
  Write-Host "    VERDETTO CPU: TROPPO PICCOLA. Un walk-forward a tick reali qui"
  Write-Host "    affamerebbe il forward. Il quarto MT5 su questa macchina NON si fa."
} elseif($logici -le 4){
  Write-Host "    VERDETTO CPU: STRETTA. Si puo' fare SOLO con gli agenti del tester"
  Write-Host ("    limitati a " + [math]::Max(1,$logici-2) + " e solo nella finestra 00:00-06:30 server.")
} else {
  Write-Host ("    VERDETTO CPU: SUFFICIENTE. Tetto consigliato agli agenti: " + [math]::Floor($logici/2) + " su " + $logici + ".")
}

# --- RAM
try{
  $os = Get-CimInstance Win32_OperatingSystem -ErrorAction SilentlyContinue
  if($os){
    $tot = [math]::Round($os.TotalVisibleMemorySize/1MB,2)
    $lib = [math]::Round($os.FreePhysicalMemory/1MB,2)
    Write-Host ""
    Write-Host ("    RAM totale: " + $tot + " GB   libera adesso: " + $lib + " GB")
    if($tot -lt 8){ Write-Host "    ATTENZIONE: sotto gli 8 GB un agente del tester per core non ci sta." }
  }
} catch { }

# --- DISCO
Write-Host ""
Write-Host "    DISCHI:"
try{
  foreach($v in @(Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" -ErrorAction SilentlyContinue)){
    $tot = [math]::Round($v.Size/1GB,1); $lib = [math]::Round($v.FreeSpace/1GB,1)
    $pct = if($v.Size -gt 0){ [math]::Round(100*$v.FreeSpace/$v.Size,1) } else { 0 }
    Write-Host ("      " + $v.DeviceID + "  totale " + $tot + " GB   LIBERO " + $lib + " GB (" + $pct + "%)")
    if($v.DeviceID -eq "C:" -and $lib -lt 30){
      Write-Host "      ATTENZIONE: sotto i 30 GB liberi non si aggiunge un terminale che riscarica lo storico."
    }
  }
} catch { }

# --- quanto si mangiano gia' i terminali
Write-Host ""
Write-Host "    QUANTO OCCUPANO GIA' LE CARTELLE DATI MT5:"
$root = Join-Path $env:APPDATA "MetaQuotes\Terminal"
if(Test-Path $root){
  $somma = 0
  foreach($d in @(Get-ChildItem $root -Directory -ErrorAction SilentlyContinue)){
    $b = 0
    foreach($f in @(Get-ChildItem -LiteralPath $d.FullName -Recurse -File -Force -ErrorAction SilentlyContinue)){ $b += $f.Length }
    $gb = [math]::Round($b/1GB,2); $somma += $gb
    Write-Host ("      " + $d.Name + "   " + $gb + " GB")
  }
  Write-Host ("      --- totale: " + [math]::Round($somma,2) + " GB")
  Write-Host "      (un terminale nuovo riscarica il suo storico: conta almeno altrettanto della piu' grossa)"
} else { Write-Host "      nessuna cartella dati trovata" }

Write-Host ""
Write-Host "PROMEMORIA: questa riga misura la MACCHINA, non il CARICO durante un round."
Write-Host "Il collaudo vero resta il canarino sul forward dopo la prima notte."
Write-Host "Questa riga LEGGE E STAMPA: non ha scritto, copiato o modificato niente."
exit 0
