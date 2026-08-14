# =====================================================================
#  elenco_ea_attaccati.ps1  --  quali EA girano DAVVERO sul VPS
# ---------------------------------------------------------------------
#  PERCHE' ESISTE (07/08/2026)
#  flotta_attesa.csv l'ho costruito da quello che AVEVO: la riga
#  CONFIG IN USO nei log e le posizioni aperte. Ma un EA attaccato che
#  non ha ancora operato e' INVISIBILE da li'. Venti righe su trentaquattro
#  sono marcate "storico", cioe' IPOTESI.
#
#  !! RISCRITTO LA SERA DEL 07/08, DOPO UN FALLIMENTO.
#  La prima versione leggeva solo i file di profilo .chr e ha trovato
#  ZERO EA su ventinove grafici -- anche sul VPS, dove ce ne girano piu'
#  di trenta. Il motivo quasi certo: MT5 salva le stringhe nei .chr in
#  UTF-16 (un byte utile, uno a zero), e io leggevo i byte "stampabili"
#  uno per uno, quindi "ABTG_PTE" mi arrivava come "A B T G _ P T E" e
#  nessuna espressione lo riconosceva. Adesso i .chr si leggono in TUTTI
#  E DUE i modi.
#
#  Ma soprattutto: e' stata aggiunta una SECONDA FONTE, piu' affidabile.
#
#    FONTE 1 - I LOG  (MQL5\Logs\AAAAMMGG.log)
#      Ogni riga di log porta scritto in testa CHI l'ha scritta, nella
#      forma  Nome (SIMBOLO,TF).  Lo scrive MT5, non l'EA: anche un EA
#      che non stampa niente di suo compare quando viene caricato
#      ("loaded successfully"). E' la fonte piu' solida che abbiamo.
#      LIMITE: dice chi ha GIRATO nei giorni letti, non chi e' attaccato
#      adesso. Un EA staccato stamattina compare lo stesso.
#
#    FONTE 2 - I PROFILI  (MQL5\Profiles\Charts\<prof>\chart*.chr)
#      Dice cosa e' ATTACCATO al grafico. LIMITE: MT5 riscrive i .chr
#      quando salva il profilo (chiusura, cambio profilo). Se MT5 e'
#      aperto, possono essere vecchi.
#
#  Le due fonti insieme dicono piu' di ciascuna: chi c'e' nei log e non
#  nei profili e' probabilmente stato staccato; chi c'e' nei profili e
#  non nei log e' attaccato ma muto.
#
#  USO (sul VPS):
#    powershell -ExecutionPolicy Bypass -File .\elenco_ea_attaccati.ps1
#    powershell -ExecutionPolicy Bypass -File .\elenco_ea_attaccati.ps1 -Giorni 7
#    powershell -ExecutionPolicy Bypass -File .\elenco_ea_attaccati.ps1 -Diagnostica
#
#  Scrive %USERPROFILE%\ea_attaccati.txt, pronto da mandare.
# =====================================================================
param(
  [int]$Giorni = 3,      # quanti giorni di log leggere all'indietro
  [switch]$Tutto,        # mostra anche i grafici senza EA
  [switch]$Diagnostica   # se non trova niente: fa vedere cosa c'e' DENTRO un .chr
)
$ErrorActionPreference = "Continue"

$termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
if (-not (Test-Path $termRoot)) { Write-Host "Cartella MetaQuotes non trovata." -ForegroundColor Red; exit 1 }

$out = New-Object System.Collections.ArrayList
function Riga($t, $col = "Gray") { Write-Host $t -ForegroundColor $col; [void]$out.Add($t) }

Riga "=== EA CHE GIRANO SUL TERMINALE ===" "Cyan"
# 14/08: due referti identici nell'aspetto arrivavano da DUE MACCHINE diverse
# (VPS e PC di backtest) e non c'era modo di distinguerli. Il nome del computer
# in testa costa niente e toglie l'ambiguita' alla radice.
Riga ("MACCHINA: " + $env:COMPUTERNAME + "   utente: " + $env:USERNAME) "Cyan"
Riga ("letto il  " + (Get-Date -Format "yyyy-MM-dd HH:mm:ss") + "  (ora locale del PC)")
Riga ""

$mt5Aperto = [bool](Get-Process -Name "terminal64" -ErrorAction SilentlyContinue)

# =====================================================================
#  FONTE 1 - I LOG. Ogni riga porta in testa "Nome (SIMBOLO,TF)".
# =====================================================================
# --- lettura CONDIVISA (14/08/2026) ---------------------------------
#  [IO.File]::ReadAllBytes apre in lettura esclusiva: se MT5 e' aperto e
#  sta scrivendo il log, la chiamata fallisce con "il processo non puo'
#  accedere al file perche' e' in uso da un altro processo". E' successo
#  la sera del 14/08 sul terminale Pepperstone. Con FileShare::ReadWrite
#  si legge anche un file che qualcun altro tiene aperto in scrittura.
function Leggi-Bytes($path) {
  try {
    $fs = [IO.File]::Open($path, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
    $b  = New-Object byte[] $fs.Length
    [void]$fs.Read($b, 0, $b.Length)
    $fs.Close()
    return $b
  } catch { return $null }
}

function Leggi-Log($path) {
  # L'encoding NON si indovina provando: un file UTF-8 letto come Unicode da'
  # caratteri strani ma NESSUN byte nullo, quindi il controllo "ci sono zeri?"
  # lo accetterebbe per buono. Si guarda il BOM, e senza BOM si contano gli
  # zeri in posizione dispari: in UTF-16 latino un byte su due e' zero.
  $b = Leggi-Bytes $path
  if ($null -eq $b) { return $null }
  if ($b.Count -lt 4) { return $null }
  $utf16 = ($b[0] -eq 0xFF -and $b[1] -eq 0xFE)
  if (-not $utf16) {
    $zeri = 0; $n = [math]::Min(400, $b.Count)
    for ($i = 1; $i -lt $n; $i += 2) { if ($b[$i] -eq 0) { $zeri++ } }
    $utf16 = ($zeri -gt ($n/4))
  }
  $enc = if ($utf16) { [Text.Encoding]::Unicode } else { [Text.Encoding]::UTF8 }
  return ($enc.GetString($b) -split "`r?`n")
}

# --- di CHE CONTO e' questo terminale? --------------------------------
#  14/08: la prima versione aggregava tutti i terminali insieme. Con due
#  conti sulla stessa macchina (il piccolo e il 100k) usciva UNA riga per
#  EA+simbolo e non si capiva su quale conto girasse: proprio la domanda
#  che stavamo cercando di chiudere sul DAX Apertura.
function Trova-Conto($dirTerminale) {
  foreach ($f in @((Join-Path $dirTerminale "config\accounts.ini"),
                   (Join-Path $dirTerminale "config\common.ini"))) {
    if (-not (Test-Path $f)) { continue }
    foreach ($enc in @("Unicode", "UTF8", "Default")) {
      try {
        $t = Get-Content -Path $f -Encoding $enc -ErrorAction Stop
        $m = $t | Select-String -Pattern "Login\s*=\s*(\d{4,})" | Select-Object -First 1
        if ($m) { return $m.Matches[0].Groups[1].Value }
      } catch { }
    }
  }
  return ""
}

$daLog = @{}     # "CONTO|Nome|SIMBOLO" -> @{ conto; ea; sym; tf; righe }
$eaSymLog = @{}  # "Nome|SIMBOLO" senza conto: serve al confronto con i .chr
$logLetti = 0
$giorniCercati = @(0..($Giorni-1) | ForEach-Object { (Get-Date).AddDays(-$_).ToString("yyyyMMdd") })

foreach ($dir in (Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue)) {
  $logDir = Join-Path $dir.FullName "MQL5\Logs"
  if (-not (Test-Path $logDir)) { continue }
  $conto = Trova-Conto $dir.FullName
  if (-not $conto) { $conto = $dir.Name.Substring(0, [Math]::Min(8, $dir.Name.Length)) }
  foreach ($g in $giorniCercati) {
    $f = Join-Path $logDir "$g.log"
    if (-not (Test-Path $f)) { continue }
    $righe = Leggi-Log $f
    if (-not $righe) { continue }
    $logLetti++
    foreach ($r in $righe) {
      # "ABTG_PTE (XAUUSD,H4)".
      #  !! NIENTE SPAZI nel nome: la riga di MT5 e' "expert ABTG_PTE (XAUUSD,H4)
      #  loaded successfully", e permettendo gli spazi usciva un EA fantasma
      #  chiamato "expert ABTG_PTE". Nessuno dei 61 .mq5 ha spazi nel nome,
      #  quindi vietarli e' gratis e toglie il problema alla radice.
      $m = [regex]::Match($r, '(?<ea>[A-Za-z][A-Za-z0-9_\-]{1,60})\s\((?<sym>[A-Z0-9][A-Z0-9._#]{2,14}),(?<tf>M\d+|H\d+|D1|W1|MN1)\)')
      if (-not $m.Success) { continue }
      $ea = $m.Groups["ea"].Value.Trim()
      if ($ea -match '^\d') { continue }
      # 14/08, SECONDA CORREZIONE: la chiave era conto+EA+simbolo e il TF
      # veniva SOVRASCRITTO a ogni riga. Cosi' due grafici dello stesso EA
      # sullo stesso simbolo ma su timeframe diversi (il caso vero: DAX
      # Apertura su M5 e su M3) collassavano in UNA riga, e il TF mostrato
      # era quello dell'ultima riga letta. Cioe' lo strumento nascondeva
      # proprio il doppione che doveva far vedere. Ora il TF e' nella chiave.
      $k = "$conto|$ea|$($m.Groups["sym"].Value)|$($m.Groups["tf"].Value)"
      $eaSymLog["$ea|$($m.Groups["sym"].Value)"] = $true
      if (-not $daLog.ContainsKey($k)) {
        $daLog[$k] = [pscustomobject]@{ conto=$conto; ea=$ea; sym=$m.Groups["sym"].Value; tf=$m.Groups["tf"].Value; righe=0; giorno=$g }
      }
      $daLog[$k].righe++
    }
  }
}

Riga "--- FONTE 1: i log degli ultimi $Giorni giorni ($logLetti file letti) ---" "Yellow"
if ($daLog.Count -eq 0) {
  Riga "    nessuna riga di log riconosciuta." "Yellow"
  Riga "    Se il terminale e' partito oggi, prova ad allargare:  -Giorni 7" "Yellow"
} else {
  Riga ("    {0,-10} {1,-38} {2,-9} {3,-5} {4}" -f "CONTO", "EA", "SIMBOLO", "TF", "righe di log")
  foreach ($v in ($daLog.Values | Sort-Object conto, ea, sym, tf)) {
    Riga ("    {0,-10} {1,-38} {2,-9} {3,-5} {4}" -f $v.conto, $v.ea, $v.sym, $v.tf, $v.righe) "Green"
  }
  Riga ""
  Riga ("    TOTALE dai log: $($daLog.Count) coppie EA+simbolo") "Cyan"
  Riga "    !! i log dicono chi ha GIRATO in questi giorni, non chi e' attaccato ADESSO." "DarkYellow"
}
Riga ""

# =====================================================================
#  FONTE 2 - I PROFILI. Cosa e' ATTACCATO al grafico.
# =====================================================================
Riga "--- FONTE 2: i profili dei grafici (.chr) ---" "Yellow"
if ($mt5Aperto) {
  Riga "    !! MT5 e' APERTO: i .chr possono essere vecchi. Per un elenco certo, chiudilo." "Yellow"
}

$noti = @('D30EUR','NASUSD','U30USD','XAUUSD','EURUSD','GBPUSD','F40EUR','SPXUSD','USTEC','GER40',
          'AUDCAD','AUDNZD','AUDUSD','AUDJPY','CADCHF','GBPJPY','NZDJPY','USDJPY','USDCAD','USDCHF')
$trovati = 0
$primoChr = $true
$daChr = New-Object System.Collections.ArrayList

foreach ($dir in (Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue)) {
  $profili = Join-Path $dir.FullName "MQL5\Profiles\Charts"
  if (-not (Test-Path $profili)) { continue }

  foreach ($prof in (Get-ChildItem $profili -Directory -ErrorAction SilentlyContinue)) {
    $chr = @(Get-ChildItem $prof.FullName -Filter "chart*.chr" -ErrorAction SilentlyContinue)
    if ($chr.Count -eq 0) { continue }
    Riga ("    profilo '" + $prof.Name + "'   (" + $chr.Count + " grafici)") "DarkYellow"

    foreach ($f in ($chr | Sort-Object Name)) {
      $bytes = [IO.File]::ReadAllBytes($f.FullName)

      # (a) byte stampabili, uno per uno -- va bene se le stringhe sono a 8 bit
      $sbA = New-Object Text.StringBuilder
      foreach ($b in $bytes) {
        if ($b -ge 32 -and $b -le 126) { [void]$sbA.Append([char]$b) } else { [void]$sbA.Append(' ') }
      }
      # (b) UTF-16: e' come MT5 salva le stringhe. SENZA QUESTO la prima
      #     versione leggeva "A B T G _ P T E" e non riconosceva niente.
      #     !! E VA FATTO SU TUTTI E DUE GLI ALLINEAMENTI: dentro un .chr le
      #     stringhe non cominciano per forza a un offset pari. Provato con un
      #     file finto: con il solo allineamento 0 trovava ZERO EA su tre.
      function Stampabili($s) {
        $sb = New-Object Text.StringBuilder
        foreach ($ch in $s.ToCharArray()) {
          $c = [int]$ch
          if ($c -ge 32 -and $c -le 126) { [void]$sb.Append($ch) } else { [void]$sb.Append(' ') }
        }
        return $sb.ToString()
      }
      $sbU  = Stampabili ([Text.Encoding]::Unicode.GetString($bytes))
      $sbU2 = if ($bytes.Count -gt 2) { Stampabili ([Text.Encoding]::Unicode.GetString($bytes, 1, $bytes.Count-1)) } else { "" }
      $txt = $sbA.ToString() + "  ##  " + $sbU + "  ##  " + $sbU2

      $sym = "?"
      foreach ($n in $noti) { if ($txt -match [regex]::Escape($n)) { $sym = $n; break } }
      if ($sym -eq "?") {
        $mSym = [regex]::Match($txt, '(?<![A-Z0-9])[A-Z][A-Z0-9]{4,8}(?![A-Z0-9])')
        if ($mSym.Success) { $sym = $mSym.Value }
      }

      $ea = $null
      $m1 = [regex]::Match($txt, '([A-Za-z][A-Za-z0-9_\-]{2,60})\.ex5')
      if ($m1.Success) { $ea = $m1.Groups[1].Value.Trim() }
      if (-not $ea) {
        $m2 = [regex]::Match($txt, '(ABTG_[A-Za-z0-9_]+|BULGE[A-Za-z0-9_]*|DAX_MASTER[A-Za-z0-9_]*|Gold_[A-Za-z0-9_]+|IchiCross[A-Za-z0-9_]*|IchiTrend[A-Za-z0-9_]*|NQ_[A-Za-z0-9_]+|SuperWave[A-Za-z0-9_]*|NIGHT[A-Za-z0-9_]*)')
        if ($m2.Success) { $ea = $m2.Groups[1].Value }
      }

      if ($Diagnostica -and $primoChr) {
        $primoChr = $false
        Riga "" ; Riga ("      [DIAGNOSTICA] " + $f.Name + " (" + $bytes.Count + " byte)") "Magenta"
        Riga "      -- letto come byte singoli:" "Magenta"
        foreach ($p in @($sbA.ToString() -split ' +' | Where-Object { $_.Length -ge 4 } | Select-Object -Unique -First 25)) { Riga ("         " + $p) "DarkMagenta" }
        Riga "      -- letto come UTF-16 (allineamento pari):" "Magenta"
        foreach ($p in @($sbU -split ' +' | Where-Object { $_.Length -ge 4 } | Select-Object -Unique -First 25)) { Riga ("         " + $p) "DarkMagenta" }
        Riga "      -- letto come UTF-16 (allineamento dispari):" "Magenta"
        foreach ($p in @($sbU2 -split ' +' | Where-Object { $_.Length -ge 4 } | Select-Object -Unique -First 25)) { Riga ("         " + $p) "DarkMagenta" }
        Riga ""
      }

      if ($ea) {
        $trovati++
        [void]$daChr.Add("$ea|$sym")
        Riga ("      {0,-10}  {1}" -f $sym, $ea) "Green"
      } elseif ($Tutto) {
        Riga ("      {0,-10}  (nessun EA)" -f $sym) "DarkGray"
      }
    }
  }
}

Riga ""
Riga ("    TOTALE dai profili: $trovati grafici con un EA attaccato") "Cyan"
if ($trovati -eq 0) {
  Riga "    I .chr non mi dicono niente. Se la FONTE 1 qui sopra ha trovato degli EA," "Yellow"
  Riga "    va bene lo stesso: quella e' la fonte buona. Se vuoi che sistemi anche" "Yellow"
  Riga "    questa, rilancia con -Diagnostica e mandami l'output." "Yellow"
}

# =====================================================================
#  LE DUE FONTI A CONFRONTO
# =====================================================================
if ($daLog.Count -gt 0 -and $trovati -gt 0) {
  Riga ""
  Riga "--- le due fonti a confronto ---" "Yellow"
  $soloLog = @($eaSymLog.Keys | Where-Object { $daChr -notcontains $_ })
  $soloChr = @($daChr | Where-Object { -not $eaSymLog.ContainsKey($_) })
  if ($soloLog.Count -gt 0) {
    Riga "    ha girato ma NON risulta attaccato (staccato? profilo non salvato?):" "DarkYellow"
    foreach ($k in $soloLog) { Riga "      $k" "DarkYellow" }
  }
  if ($soloChr.Count -gt 0) {
    Riga "    attaccato ma MUTO nei log (non ha mai scritto niente):" "DarkYellow"
    foreach ($k in $soloChr) { Riga "      $k" "DarkYellow" }
  }
  if ($soloLog.Count -eq 0 -and $soloChr.Count -eq 0) { Riga "    le due fonti coincidono." "Green" }
}

Riga ""
Riga "Confronta questo elenco con backtest_pipeline/flotta_attesa.csv:"
Riga "  - qui e NON nel csv  -> gira qualcosa di non dichiarato"
Riga "  - nel csv e NON qui  -> il csv dichiara un EA che non gira"

$dest = Join-Path $env:USERPROFILE "ea_attaccati.txt"
$out | Set-Content -Path $dest -Encoding UTF8

# --- raccolta sul Desktop + zip (regola delle righe di lancio) -------
#  14/08, PRIMA STESURA SBAGLIATA: il Desktop lo chiedevo solo a
#  [Environment]::GetFolderPath("Desktop"), e ogni passo aveva
#  -ErrorAction SilentlyContinue. Risultato: se quella chiamata torna
#  vuota (Desktop reindirizzato, OneDrive, profilo di servizio) non
#  usciva nessuno zip E NESSUN MOTIVO. Adesso il Desktop si cerca in
#  tre modi, e se qualcosa fallisce lo dice a voce alta.
function Trova-Desktop {
  foreach ($p in @([Environment]::GetFolderPath("Desktop"),
                   (Join-Path $env:USERPROFILE "Desktop"),
                   (Join-Path $env:USERPROFILE "OneDrive\Desktop"))) {
    if ($p -and (Test-Path $p)) { return $p }
  }
  # nessun Desktop utilizzabile: si ripiega sulla home, che c'e' sempre
  return $env:USERPROFILE
}

$desktop = Trova-Desktop
$cart = Join-Path $desktop "ea_attaccati"
$zip  = Join-Path $desktop "ea_attaccati.zip"
$zipOk = $false
$motivo = ""
try {
  if (Test-Path $cart) { Remove-Item $cart -Recurse -Force -ErrorAction Stop }
  New-Item -ItemType Directory -Path $cart -Force -ErrorAction Stop | Out-Null
  Copy-Item $dest $cart -Force -ErrorAction Stop
  if (Test-Path $zip) { Remove-Item $zip -Force -ErrorAction Stop }
  Compress-Archive -Path (Join-Path $cart "*") -DestinationPath $zip -Force -ErrorAction Stop
  $zipOk = Test-Path $zip
} catch {
  $motivo = $_.Exception.Message
}

Write-Host ""
if ($zipOk) {
  Write-Host "=====================================================" -ForegroundColor Green
  Write-Host " IL FILE DA MANDARMI E' QUESTO:" -ForegroundColor Green
  Write-Host "   $zip" -ForegroundColor White
  Write-Host "=====================================================" -ForegroundColor Green
  Write-Host "File attesi nello zip (1):" -ForegroundColor Gray
  Get-ChildItem $cart -ErrorAction SilentlyContinue | ForEach-Object {
    Write-Host ("   {0}  ({1} byte)" -f $_.Name, $_.Length)
  }
} else {
  Write-Host "=====================================================" -ForegroundColor Yellow
  Write-Host " LO ZIP NON E' STATO CREATO." -ForegroundColor Yellow
  if ($motivo) { Write-Host ("   motivo: " + $motivo) -ForegroundColor Red }
  Write-Host "   Desktop usato : $desktop" -ForegroundColor Gray
  Write-Host " MANDAMI DIRETTAMENTE QUESTO FILE, va bene uguale:" -ForegroundColor Yellow
  Write-Host "   $dest" -ForegroundColor White
  Write-Host "=====================================================" -ForegroundColor Yellow
}
Write-Host ""
Write-Host "Se la finestra si e' fermata a meta' e il titolo diceva" -ForegroundColor DarkYellow
Write-Host "'Seleziona Windows PowerShell', l'avevi cliccata dentro:" -ForegroundColor DarkYellow
Write-Host "la console si mette in pausa e lo script NON va avanti." -ForegroundColor DarkYellow
Write-Host "Si sblocca con ESC (o tasto destro). Per non rischiare," -ForegroundColor DarkYellow
Write-Host "rilancia mandando l'output su file:  ... -Giorni 30 *> out.txt" -ForegroundColor DarkYellow

try { Start-Process notepad.exe $dest } catch { }
try { Set-Clipboard -Value $dest } catch { }
