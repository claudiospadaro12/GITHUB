# =====================================================================
#  MARCATORE_INSTALLA_SPREADLOGGER_REALE_v1
#  INSTALLA E COMPILA ABTG_SpreadLogger.mq5 (logger di SOLA LETTURA dello
#  spread) nel SOLO terminale REALE C:\BCM_Reale, conto 10105439, sul VPS.
#
#  COSA FA, in ordine (e SOLO questo):
#   1. scarica il .mq5 dal pin, controlla impronta SHA256 e marcatore;
#   2. prova che il terminale giusto e' VIVO: un terminal64.exe col Path
#      esatto C:\BCM_Reale\terminal64.exe e il titolo che comincia col conto;
#   3. trova la SUA cartella dati: origin.txt uguale a C:\BCM_Reale E
#      config\common.ini con Login=10105439. Una sola candidata, altrimenti
#      si ferma;
#   4. scrive UN file: MQL5\Experts\ABTG_SpreadLogger.mq5 (se esiste gia' un
#      file con quel nome o col suo .ex5, si ferma: non sovrascrive);
#   5. lo compila con il metaeditor64.exe di QUELLA installazione;
#   6. se la compilazione non da' un .ex5 fresco con "0 errors", RIMUOVE i
#      due file appena creati.
#
#  COSA NON FA: non tocca il processo del terminale, non lo chiude, non lo
#  riavvia, non apre grafici, non attacca nessun EA, non tocca Presets,
#  Profiles, config, .chr, le sedie, il Guardian. L'EA si attacca A MANO.
#  Nessuna chiamata di rete oltre al download del sorgente.
#  ASCII puro (Windows PowerShell 5.1 legge i .ps1 come ANSI).
# =====================================================================
param(
  [Parameter(Mandatory=$true)][string]$Pin,
  [string]$InstallDir = 'C:\BCM_Reale',
  [string]$Conto = '10105439',
  [string]$RadiceDati = '',
  [object[]]$TestoProcessi = $null,
  [int]$TimeoutSec = 180
)
$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
[Threading.Thread]::CurrentThread.CurrentCulture = [Globalization.CultureInfo]::InvariantCulture

$SHA_ATTESA = 'D2D0389E6FEDDFD01F0E952AE8A7BCFEC529309A61EAE9FA4DE0BAC45FA54071'
$MARCATORE  = 'MARCATORE_ABTG_SPREADLOGGER_v1'
$NOME       = 'ABTG_SpreadLogger'
$righe = New-Object System.Collections.ArrayList
function Dico([string]$t,[string]$colore){ [void]$righe.Add($t); Write-Host $t -ForegroundColor $colore }
$creati = New-Object System.Collections.ArrayList
$stamp = (Get-Date).ToString('yyyyMMdd_HHmmss')
$dsk = [Environment]::GetFolderPath('Desktop')
$ref = Join-Path $dsk ($NOME + '_INSTALL_REALE_' + $stamp + '.txt')

try {
  Dico ('INSTALLA ' + $NOME + ' nel SOLO terminale REALE ' + $InstallDir + ' (conto ' + $Conto + ') -- ' + $stamp) 'Cyan'
  if($Pin -notmatch '^[0-9a-f]{40}$'){ throw ('-Pin deve essere un commit di 40 caratteri esadecimali, ricevuto: ' + $Pin) }

  # 1. sorgente
  $u = 'https://raw.githubusercontent.com/claudiospadaro12/GITHUB/' + $Pin + '/mql5/Experts/' + $NOME + '.mq5?cb=' + [Guid]::NewGuid().ToString('N')
  $b = (New-Object Net.WebClient).DownloadData($u)
  $h = [BitConverter]::ToString((New-Object Security.Cryptography.SHA256Managed).ComputeHash($b)).Replace('-','')
  if($h -ne $SHA_ATTESA){ throw ('IMPRONTA DIVERSA (' + $h + '): copia vecchia o cache di GitHub. Non installo niente.') }
  $t = [Text.Encoding]::ASCII.GetString($b)
  if(-not ($t | Select-String -SimpleMatch -Quiet -Pattern $MARCATORE)){ throw ('Marcatore ' + $MARCATORE + ' ASSENTE nel sorgente scaricato.') }
  Dico ('sorgente: ' + $b.Length + ' byte, impronta ' + $h.Substring(0,8) + ' OK, marcatore OK') 'Green'

  # 2. il terminale giusto e' vivo
  $exeAtteso = Join-Path $InstallDir 'terminal64.exe'
  if($null -ne $TestoProcessi){ $tutti = @($TestoProcessi) } else { $tutti = @(Get-Process -Name terminal64 -ErrorAction SilentlyContinue) }
  $vivi = @($tutti | Where-Object { $_.Path -and ($_.Path -ieq $exeAtteso) })
  if($vivi.Count -ne 1){ throw ('Mi aspetto UN terminal64.exe con Path ' + $exeAtteso + ' e ne vedo ' + $vivi.Count + '. Non installo niente.') }
  if(-not ([string]$vivi[0].MainWindowTitle).StartsWith($Conto)){ throw ('Il terminale ' + $exeAtteso + ' ha il titolo "' + $vivi[0].MainWindowTitle + '", che NON comincia con ' + $Conto + '. Non installo niente.') }
  Dico ('terminale reale vivo: PID ' + $vivi[0].Id + ', titolo "' + $vivi[0].MainWindowTitle + '"') 'Green'

  # MetaEditor e' single-instance: se e' aperto, non si parte
  $med = @(Get-Process -Name metaeditor64 -ErrorAction SilentlyContinue)
  if($med.Count -gt 0){ throw ('MetaEditor e APERTO (PID ' + (($med | ForEach-Object { $_.Id }) -join ',') + '): chiudilo A MANO e rilancia. Non installo niente.') }
  $me = Join-Path $InstallDir 'metaeditor64.exe'
  if(-not (Test-Path -LiteralPath $me)){ throw ('metaeditor64.exe non trovato in ' + $InstallDir + ': senza il SUO compilatore non installo niente.') }

  # 3. la cartella dati del reale
  if($RadiceDati -eq ''){ $RadiceDati = Join-Path (Join-Path $env:APPDATA 'MetaQuotes') 'Terminal' }
  $cand = New-Object System.Collections.ArrayList
  if(Test-Path -LiteralPath $RadiceDati){
    foreach($d in @(Get-ChildItem -LiteralPath $RadiceDati -Directory -ErrorAction SilentlyContinue)){
      $o = Join-Path $d.FullName 'origin.txt'
      if(-not (Test-Path -LiteralPath $o)){ continue }
      $orig = ''
      try { $orig = ([string](Get-Content -LiteralPath $o -Raw -ErrorAction Stop)).Trim() } catch { $orig = '' }
      if($orig.TrimEnd('\','/') -ine $InstallDir.TrimEnd('\','/')){ continue }
      $ini = Join-Path (Join-Path $d.FullName 'config') 'common.ini'
      $login = ''
      if(Test-Path -LiteralPath $ini){
        try { foreach($r in @(Get-Content -LiteralPath $ini -ErrorAction Stop)){ if(([string]$r).Trim() -match '^Login=(\d+)$'){ $login = $Matches[1] } } } catch { $login = '' }
      }
      [void]$cand.Add([pscustomobject]@{ Percorso = $d.FullName; Login = $login })
    }
  }
  $buone = @($cand | Where-Object { $_.Login -eq $Conto })
  if($buone.Count -ne 1){ throw ('Cartelle dati con origin.txt = ' + $InstallDir + ': ' + $cand.Count + ', di cui col Login=' + $Conto + ': ' + $buone.Count + '. Ne serve UNA sola. Non installo niente.') }
  $dati = $buone[0].Percorso
  Dico ('cartella dati del reale: ' + $dati + ' (origin.txt = ' + $InstallDir + ', Login=' + $Conto + ')') 'Green'

  # 4. scrittura di UN file
  $mql = Join-Path $dati 'MQL5'
  $dirExp = Join-Path $mql 'Experts'
  if(-not (Test-Path -LiteralPath $dirExp)){ throw ('Manca la cartella ' + $dirExp + '. Non installo niente.') }
  $mq5 = Join-Path $dirExp ($NOME + '.mq5')
  $ex5 = Join-Path $dirExp ($NOME + '.ex5')
  if((Test-Path -LiteralPath $mq5) -or (Test-Path -LiteralPath $ex5)){ throw ('Esiste gia un ' + $NOME + ' (.mq5 o .ex5) in ' + $dirExp + ': non sovrascrivo. Guardalo a mano.') }
  [IO.File]::WriteAllBytes($mq5, $b)
  [void]$creati.Add($mq5)
  $h2 = (Get-FileHash -LiteralPath $mq5 -Algorithm SHA256).Hash
  if($h2 -ne $SHA_ATTESA){ throw ('Il file scritto ha un altra impronta (' + $h2 + ').') }
  Dico ('scritto ' + $mq5 + ' (impronta verificata)') 'Green'

  # 5. compilazione con il compilatore di QUELLA installazione
  $log = Join-Path $env:TEMP ($NOME + '_compila_' + $stamp + '.log')
  Remove-Item -LiteralPath $log -Force -ErrorAction SilentlyContinue
  $t0 = Get-Date
  Dico ('compilo con ' + $me) 'Yellow'
  $ErrorActionPreference = 'Continue'
  & $me ('/compile:' + $mq5) ('/inc:' + $mql) ('/log:' + $log) | Out-Null
  $rc = $LASTEXITCODE
  $ErrorActionPreference = 'Stop'
  $fresco = $false
  while($true){
    if((Test-Path -LiteralPath $ex5) -and ((Get-Item -LiteralPath $ex5).LastWriteTime -ge $t0.AddSeconds(-2))){ $fresco = $true; break }
    if(((Get-Date) - $t0).TotalSeconds -ge $TimeoutSec){ break }
    Start-Sleep -Seconds 2
  }
  if(Test-Path -LiteralPath $ex5){ [void]$creati.Add($ex5) }
  $testoLog = ''
  if(Test-Path -LiteralPath $log){ try { $testoLog = [string](Get-Content -LiteralPath $log -Raw -ErrorAction Stop) } catch { $testoLog = '' } }
  $res = ''
  if($testoLog -match 'Result:\s*(\d+)\s+errors?,\s*(\d+)\s+warnings?'){ $res = 'Result: ' + $Matches[1] + ' errors, ' + $Matches[2] + ' warnings'; $nErr = [int]$Matches[1] } else { $nErr = -1 }
  Dico ('codice di uscita di metaeditor64: ' + $rc + ' (non decide: decidono .ex5 fresco e la riga Result). .ex5 fresco: ' + $fresco + '. Log: ' + $(if($res -ne ''){ $res } else { 'NESSUNA riga Result' })) 'Yellow'
  if(-not $fresco){ throw 'Il compilatore non ha prodotto un .ex5 fresco: installazione ANNULLATA.' }
  if($nErr -ne 0){ throw ('La compilazione non dice 0 errors (' + $(if($res -ne ''){ $res } else { 'riga Result assente' }) + '): installazione ANNULLATA.') }

  Dico 'FATTO: ABTG_SpreadLogger.mq5 e .ex5 sono nella cartella Experts del terminale REALE. NIENTE e stato attaccato a nessun grafico: manca il passo a mano (nuovo grafico XAUUSD, trascina l EA, InpSimboli=XAUUSD, InpAggiungiMarketWatch=false).' 'Green'
  $esito = 0
}
catch {
  Dico ('FERMATO: ' + $_.Exception.Message) 'Red'
  foreach($f in @($creati)){
    try {
      if(Test-Path -LiteralPath $f){ Remove-Item -LiteralPath $f -Force; Dico ('rimosso (creato da questo giro): ' + $f) 'Yellow' }
    } catch { Dico ('NON riesco a rimuovere ' + $f + ': ' + $_.Exception.Message + ' -- toglilo a mano.') 'Red' }
  }
  $esito = 1
}
try { Set-Content -LiteralPath $ref -Value @($righe) -Encoding ASCII; Write-Host ('referto sul Desktop: ' + $ref) -ForegroundColor Gray } catch { Write-Host ('referto NON scritto: ' + $_.Exception.Message) -ForegroundColor Red }
Write-Host ('INSTALLA SPREADLOGGER REALE rc ' + $esito + '   (0 = installato e compilato; 1 = fermato, e se ha creato qualcosa l ha rimosso)') -ForegroundColor Cyan
exit $esito
