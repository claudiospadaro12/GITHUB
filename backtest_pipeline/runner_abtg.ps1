# =====================================================================
#  MARCATORE_RUNNER_ABTG_v2
#  runner_abtg.ps1 -- ESEGUE DA SOLO LA CODA, e pubblica i referti sul
#  repo. Nato il 07/09/2026 dalla domanda di Claudio: "puoi lanciarle tu
#  le stringhe per me?".
# ---------------------------------------------------------------------
#  LA RISPOSTA VERA A QUELLA DOMANDA
#  Claude gira in un container nel cloud e il VPS non lo vede: nessuna
#  firma crea un collegamento. Ma META' del collegamento ESISTE GIA' ED
#  E' IN PRODUZIONE: `pubblica_trades.ps1` gira come attivita'
#  pianificata alle 22:45 e carica i CSV sul repo via API GitHub col
#  token che sta sul VPS (commit "Aggiornamento automatico trades",
#  verificati fino al 05/09/2026). Manca il verso opposto: SCARICARE una
#  coda ed ESEGUIRLA. Questo file e' quel verso.
#
#  IL CICLO, UNA VOLTA INSTALLATO:
#    Claude scrive la coda -> pusha su 'lavoro'
#    il VPS, da solo: scarica, esegue in ordine, raccoglie
#    il VPS, da solo: pubblica i referti sul repo
#    Claude legge i referti e scrive la coda dopo
#  Claudio lo installa UNA VOLTA e non tocca piu' niente.
#
# =====================================================================
#  >>> v1 E' STRETTAMENTE DI SOLA LETTURA. NON E' UNA LIMITAZIONE
#      TEMPORANEA DA ALLARGARE ALLA PRIMA OCCASIONE: e' il perimetro
#      firmato (report/PERIMETRO_RUNNER.md). Uno script che gira da
#      solo, di notte, su una macchina con tre terminali VIVI, e' la
#      cosa piu' pericolosa che questo progetto abbia mai costruito.
#      Il perimetro si allarga con una firma nuova, MAI di corsa.
#
#  I DUE CANCELLI, INDIPENDENTI, ENTRAMBI CODICE (classe 151):
#   G1. IL MARCATORE. Lo script in coda deve contenere la riga
#         # RUNNER_SOLA_LETTURA
#       Non e' cosmetica: e' un OPT-IN che qualcuno deve avere scritto
#       DELIBERATAMENTE in quel file. Uno script nuovo non entra per
#       sbaglio.
#   G2. LA SCANSIONE DEI DIVIETI. Il testo dello script viene letto e
#       cercato per i modi noti di fare danno. Se ne trova UNO, lo
#       script e' RIFIUTATO, il motivo finisce nel referto, e la coda
#       PROSEGUE con gli altri (un rifiuto non ferma la notte).
#
#  >>> I DUE CANCELLI SONO IN AND. Un marcatore senza scansione sarebbe
#      una promessa; una scansione senza marcatore lascerebbe entrare
#      qualunque file di sola lettura che nessuno ha esaminato.
#
#  >>> COLLAUDABILE SENZA NIENTE: -CollaudoCancelli fa girare G1 e G2 su
#      una batteria di casi finti (buoni e cattivi) e dice cosa avrebbe
#      fatto. Un cancello che nessuno ha visto scattare non e' un
#      cancello dimostrato.
# =====================================================================

param(
  [switch]$Installa,                 # registra l'attivita' pianificata e esce
  [string]$Ora        = "03:30",     # ora VPS della corsa notturna
  [string]$DestDir    = "C:\ABTG",
  [string]$Owner      = "claudiospadaro12",
  [string]$Repo       = "github",
  [string]$Branch     = "lavoro",
  [string]$CodaPath   = "backtest_pipeline/coda/CODA.txt",
  [string]$TokenFile  = "",
  [switch]$SoloControllo,            # scarica e VAGLIA la coda, non esegue niente
  [switch]$CollaudoCancelli,         # esegue SOLO i cancelli su casi finti
  [switch]$NonPubblicare             # esegue ma non carica sul repo
)

$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$MARC = "MARCATORE_RUNNER_ABTG_v2"
$MARC_RICHIESTO = "RUNNER_SOLA_LETTURA"

# =====================================================================
#  I DIVIETI. Ogni voce: il modello, e PERCHE' e' vietato.
#  Sono cercati come TESTO nel sorgente dello script, senza eseguirlo.
# =====================================================================
$DIVIETI = @(
  @{ p='BCM_Reale';                 why='tocca il terminale del CONTO REALE 10105439' },
  @{ p='10105439';                  why='nomina il CONTO REALE' },
  @{ p='E23E1504A8D02A22179395F0652B86B6'; why='e'' la cartella dati del CONTO REALE' },
  @{ p='OrderSend';                 why='invia ordini' },
  @{ p='PositionClose';             why='chiude posizioni' },
  @{ p='OrderDelete';               why='cancella ordini' },
  @{ p='ExpertRemove';              why='stacca un EA' },
  @{ p='ChartApplyTemplate';        why='cambia cosa gira su un grafico' },
  @{ p='ChartOpen';                 why='apre grafici sul terminale vivo' },
  @{ p='EseguiDavvero';             why='e'' uno script che AGISCE: la v1 esegue solo letture' },
  @{ p='schtasks';                  why='registra o cancella attivita'' pianificate' },
  @{ p='Register-ScheduledTask';    why='registra attivita'' pianificate' },
  @{ p='Stop-Process';              why='puo'' uccidere un terminale MT5 vivo' },
  @{ p='terminal64.exe';            why='avvia o pilota un terminale' },
  @{ p='Start-Process';             why='avvia programmi: nella v1 non serve a nessuna lettura' },
  @{ p='Remove-Item';               why='cancella file' },
  @{ p='Set-Content';               why='scrive file' },
  @{ p='Add-Content';               why='scrive file' },
  @{ p='Out-File';                  why='scrive file' },
  @{ p='Copy-Item';                 why='copia file: nella v1 la raccolta la fa il runner' },
  @{ p='Move-Item';                 why='sposta file' },
  @{ p='Invoke-Expression';         why='esegue testo arbitrario: qualunque scansione diventa inutile' },
  @{ p='iex ';                      why='alias di Invoke-Expression' },
  @{ p='DownloadString';            why='scarica ed esegue codice fuori dalla coda' }
)

function Titolo($t){ Write-Host ""; Write-Host ("=== " + $t + " ===") -ForegroundColor Cyan }

# =====================================================================
#  I CANCELLI. Funzione unica, usata sia dalla corsa sia dal collaudo.
#  Torna @{ ok=$true/$false; motivo="..." }
# =====================================================================
function VagliaScript([string]$testo,[string]$nome){
  if([string]::IsNullOrWhiteSpace($testo)){
    return @{ ok=$false; motivo="G0: sorgente vuoto o non scaricato" }
  }
  # G1 -- il marcatore di opt-in
  if($testo -notmatch [regex]::Escape($MARC_RICHIESTO)){
    return @{ ok=$false; motivo=("G1: manca il marcatore '" + $MARC_RICHIESTO + "'. Uno script non entra in coda per sbaglio.") }
  }
  # G2 -- la scansione dei divieti, RIGA PER RIGA, saltando i commenti
  $n = 0
  foreach($riga in ($testo -split "`r?`n")){
    $n++
    $pulita = $riga.Trim()
    if($pulita.StartsWith("#")){ continue }         # i commenti spiegano, non eseguono
    foreach($d in $DIVIETI){
      if($pulita -match [regex]::Escape($d.p)){
        return @{ ok=$false; motivo=("G2: riga " + $n + " contiene '" + $d.p + "' -- " + $d.why) }
      }
    }
  }
  return @{ ok=$true; motivo="G1 e G2 passati" }
}

# =====================================================================
#  RAMO DI COLLAUDO -- non serve ne' rete ne' MT5
# =====================================================================
if($CollaudoCancelli){
  Titolo "COLLAUDO DEI CANCELLI G1 e G2 (nessuna rete, nessun MT5)"
  $casi = @(
    @{ nome="BUONO: legge e stampa";         atteso=$true;  txt="# RUNNER_SOLA_LETTURA`nGet-ChildItem C:\ | Select-Object Name`nWrite-Host 'ciao'" },
    @{ nome="CATTIVO: manca il marcatore";   atteso=$false; txt="Get-ChildItem C:\ | Select-Object Name" },
    @{ nome="CATTIVO: tocca il REALE";       atteso=$false; txt="# RUNNER_SOLA_LETTURA`nGet-ChildItem 'C:\BCM_Reale'" },
    @{ nome="CATTIVO: nomina il conto reale";atteso=$false; txt="# RUNNER_SOLA_LETTURA`n`$c = 10105439" },
    @{ nome="CATTIVO: scrive un file";       atteso=$false; txt="# RUNNER_SOLA_LETTURA`nSet-Content -Path x.txt -Value 'a'" },
    @{ nome="CATTIVO: cancella";             atteso=$false; txt="# RUNNER_SOLA_LETTURA`nRemove-Item x.txt" },
    @{ nome="CATTIVO: esegue testo";         atteso=$false; txt="# RUNNER_SOLA_LETTURA`nInvoke-Expression `$roba" },
    @{ nome="CATTIVO: avvia un processo";    atteso=$false; txt="# RUNNER_SOLA_LETTURA`nStart-Process terminal64.exe" },
    @{ nome="CATTIVO: -EseguiDavvero";       atteso=$false; txt="# RUNNER_SOLA_LETTURA`nparam([switch]`$EseguiDavvero)" },
    @{ nome="BUONO: il divieto e' in un COMMENTO"; atteso=$true; txt="# RUNNER_SOLA_LETTURA`n# qui NON usiamo Remove-Item, mai`nGet-Date" },
    @{ nome="CATTIVO: sorgente vuoto";       atteso=$false; txt="" }
  )
  $ok=0; $ko=0
  foreach($c in $casi){
    $r = VagliaScript $c.txt $c.nome
    $giusto = ($r.ok -eq $c.atteso)
    if($giusto){ $ok++ } else { $ko++ }
    $col = if($giusto){"Green"}else{"Red"}
    Write-Host ("  [{0}] {1,-42} -> {2}" -f $(if($giusto){"OK "}else{"KO "}), $c.nome, $r.motivo) -ForegroundColor $col
  }
  Write-Host ""
  Write-Host ("COLLAUDO: " + $ok + " giusti, " + $ko + " sbagliati su " + $casi.Count) -ForegroundColor $(if($ko -eq 0){"Green"}else{"Red"})
  if($ko -gt 0){ exit 1 }
  exit 0
}

# =====================================================================
#  -Installa : registra l'attivita' pianificata e finisce qui.
#  Stesso schema di pubblica_trades.ps1, che sul VPS funziona dall'11/08.
# =====================================================================
if($Installa){
  Titolo "INSTALLAZIONE DELL'ATTIVITA' PIANIFICATA"
  New-Item -ItemType Directory -Force -Path $DestDir | Out-Null
  $dest = Join-Path $DestDir "runner_abtg.ps1"
  Copy-Item -LiteralPath $PSCommandPath -Destination $dest -Force
  Write-Host ("  copiato in: " + $dest)
  $task   = "ABTG_Runner"
  $azione = "powershell -NoProfile -ExecutionPolicy Bypass -File $dest"

  # 07/09/2026, DIFETTO PAGATO AL PRIMO INSTALL. schtasks scrive su stderr
  # anche quando va tutto bene -- il /Delete di un'attivita' che NON ESISTE
  # ANCORA (cioe' sempre, al primo giro) stampa "Impossibile trovare il file
  # specificato". Con $ErrorActionPreference='Stop' quello diventa un errore
  # TERMINANTE e la corsa muore PRIMA del /Create. Il commento di
  # pubblica_trades.ps1 lo diceva gia' ("schtasks scrive su stderr anche
  # quando va tutto bene") e io avevo copiato lo schema senza la protezione.
  # Qui: stderr viene inghiottito DENTRO cmd (>nul 2>nul), cosi' PowerShell
  # non lo vede proprio, e l'EAP viene abbassato solo per queste due righe.
  #
  # >>> ONESTA': IL DIFETTO NON E' STATO RIPRODOTTO AL BANCO. Chi scrive gira
  #     PowerShell 7 su Linux e li' il caso A (stderr visibile, EAP=Stop) NON
  #     muore. Sul VPS gira Windows PowerShell 5.1, che si comporta
  #     diversamente. Cio' che E' un fatto e' DOVE e' morto: il messaggio
  #     diceva "runner_abtg.ps1:175 car:3" e la 175 era esattamente la riga
  #     del /Delete. Quindi questa correzione e' una IPOTESI ben motivata,
  #     non una riparazione dimostrata -- ed e' il motivo per cui subito
  #     sotto c'e' la VERIFICA sull'artefatto: se l'ipotesi fosse sbagliata,
  #     la riga lo DICE invece di lasciare mezza installazione.
  $eapPrima = $ErrorActionPreference
  $ErrorActionPreference = "Continue"
  cmd /c "schtasks /Delete /TN $task /F >nul 2>nul" | Out-Null
  $out = cmd /c "schtasks /Create /TN $task /TR ""$azione"" /SC DAILY /ST $Ora /F 2>&1"
  $ErrorActionPreference = $eapPrima

  # E IL VERDETTO STA SULL'ARTEFATTO, NON SUL CODICE DI USCITA (classe 154):
  # si interroga l'attivita' e si pretende di ritrovarla.
  $ErrorActionPreference = "Continue"
  $q = cmd /c "schtasks /Query /TN $task 2>&1"
  $ErrorActionPreference = $eapPrima
  $registrata = @($q | Where-Object { $_ -match [regex]::Escape($task) }).Count -gt 0
  if(-not $registrata){
    Write-Host "ERRORE: l'attivita' NON risulta registrata. Uscita di schtasks:" -ForegroundColor Red
    $out | ForEach-Object { Write-Host ("  " + $_) -ForegroundColor Red }
    Write-Host "  (se dice 'Accesso negato': lancia PowerShell come AMMINISTRATORE)" -ForegroundColor Yellow
    exit 1
  }
  Write-Host ("  attivita' '" + $task + "' REGISTRATA E RITROVATA, ogni giorno alle " + $Ora) -ForegroundColor Green
  $q | Where-Object { $_ -match [regex]::Escape($task) } | ForEach-Object { Write-Host ("    " + $_) -ForegroundColor Gray }
  Write-Host "  Da adesso il VPS esegue la coda da solo e pubblica i referti." -ForegroundColor Green
  Write-Host "  Per toglierla:  schtasks /Delete /TN ABTG_Runner /F" -ForegroundColor Gray
  exit 0
}

# =====================================================================
#  LA CORSA
# =====================================================================
$avvio = Get-Date
$Lavoro = Join-Path $env:USERPROFILE "abtg_runner"
New-Item -ItemType Directory -Force -Path $Lavoro | Out-Null
$RawBase = "https://raw.githubusercontent.com/$Owner/$Repo"

Titolo ("RUNNER ABTG -- " + $avvio.ToString("yyyy-MM-dd HH:mm:ss"))
Write-Host ("    " + $MARC) -ForegroundColor DarkGray
Write-Host ("    perimetro: SOLA LETTURA (report/PERIMETRO_RUNNER.md)") -ForegroundColor DarkGray

$R = New-Object System.Collections.ArrayList
function W($t){ [void]$R.Add($t); Write-Host $t }

W ("REFERTO RUNNER ABTG -- " + $avvio.ToString("yyyy-MM-dd HH:mm:ss") + " (ora locale VPS)")
W ("marcatore : " + $MARC)
W ("branch    : " + $Branch)
W ("perimetro : SOLA LETTURA -- report/PERIMETRO_RUNNER.md")
W ("")

# --- la coda
$urlCoda = $RawBase + "/" + $Branch + "/" + $CodaPath + "?cb=" + [Guid]::NewGuid().ToString("N")
$coda = $null
try { $coda = (Invoke-WebRequest -Uri $urlCoda -UseBasicParsing -TimeoutSec 90).Content }
catch { W ("!!! CODA NON SCARICATA: " + $_.Exception.Message); W ("ESITO: NON ESEGUITO"); $coda = $null }

$eseguiti = 0; $rifiutati = 0; $falliti = 0
$righe = @()
if($coda){
  $righe = @($coda -split "`r?`n" | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" -and -not $_.StartsWith("#") })
  W ("righe di coda: " + $righe.Count)
}

foreach($riga in $righe){
  # formato:  <pin 40 hex> | <percorso nel repo> | <argomenti opzionali>
  $parti = @($riga -split '\|') | ForEach-Object { $_.Trim() }
  W ("")
  W ("--- " + $riga)
  if($parti.Count -lt 2){ $rifiutati++; W ("    RIFIUTATO: riga malformata (servono pin|percorso)"); continue }
  $pin = $parti[0]; $perc = $parti[1]
  $args = if($parti.Count -ge 3){ $parti[2] } else { "" }
  if($pin -notmatch '^[0-9a-f]{40}$'){ $rifiutati++; W ("    RIFIUTATO: il pin non e' uno SHA da 40 esadecimali"); continue }
  if($perc -notmatch '^backtest_pipeline/righe/[A-Za-z0-9_.-]+\.ps1$'){
    $rifiutati++; W ("    RIFIUTATO: percorso fuori da backtest_pipeline/righe/ oppure non .ps1"); continue
  }

  $url = $RawBase + "/" + $pin + "/" + $perc + "?cb=" + [Guid]::NewGuid().ToString("N")
  $testo = $null
  try { $testo = (Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 90).Content }
  catch { $rifiutati++; W ("    RIFIUTATO: scarico fallito -- " + $_.Exception.Message); continue }

  $v = VagliaScript $testo $perc
  if(-not $v.ok){ $rifiutati++; W ("    RIFIUTATO -- " + $v.motivo); continue }
  W ("    cancelli: " + $v.motivo)

  if($SoloControllo){ W ("    (SoloControllo: non lo eseguo)"); continue }

  $nome = [IO.Path]::GetFileNameWithoutExtension($perc)
  $file = Join-Path $Lavoro ($nome + ".ps1")
  [IO.File]::WriteAllText($file, $testo)
  $log  = Join-Path $Lavoro ($nome + "_" + $avvio.ToString("yyyyMMdd_HHmmss") + ".log")
  $argv = @("-NoProfile","-ExecutionPolicy","Bypass","-File",$file)
  if($args){ $argv += ($args -split '\s+') }
  $t0 = Get-Date
  $p = Start-Process -FilePath "powershell.exe" -ArgumentList $argv -NoNewWindow -PassThru -Wait `
        -RedirectStandardOutput $log -RedirectStandardError ($log + ".err")
  $sec = [int]((Get-Date) - $t0).TotalSeconds
  if($p.ExitCode -eq 0){ $eseguiti++; W ("    ESEGUITO in " + $sec + "s, uscita 0") }
  else { $falliti++; W ("    ESEGUITO in " + $sec + "s, uscita " + $p.ExitCode + " -- guarda il log") }
  W ("    log: " + (Split-Path $log -Leaf))
}

W ("")
W ("--- RIEPILOGO ---")
W ("eseguiti  : " + $eseguiti)
W ("rifiutati : " + $rifiutati)
W ("falliti   : " + $falliti)
$esito = if($righe.Count -eq 0){ "CODA VUOTA -- niente da fare" }
         elseif($eseguiti -eq 0){ "NESSUNO ESEGUITO" }
         elseif($rifiutati -gt 0 -or $falliti -gt 0){ "PARZIALE" }
         else { "COMPLETO" }
W ("ESITO: " + $esito)

$ref = Join-Path $Lavoro ("REFERTO_RUNNER_" + $avvio.ToString("yyyyMMdd_HHmmss") + ".txt")
$R -join "`r`n" | Set-Content -LiteralPath $ref -Encoding UTF8
Write-Host ""
Write-Host ("referto: " + $ref) -ForegroundColor Cyan

# =====================================================================
#  PUBBLICAZIONE SUL REPO -- stesso meccanismo di pubblica_trades.ps1
# =====================================================================
if($NonPubblicare){ Write-Host "  (-NonPubblicare: non carico niente)" -ForegroundColor DarkGray; exit 0 }

$cand = @($TokenFile, "C:\Users\Administrator\.gh_report_token.txt", (Join-Path $env:USERPROFILE ".gh_report_token.txt"))
$tok = $null
foreach($c in $cand){ if($c -and (Test-Path -LiteralPath $c)){ $tok = (Get-Content -LiteralPath $c -Raw).Trim(); break } }
if(-not $tok){ Write-Host "TOKEN NON TROVATO: il referto resta solo sul VPS." -ForegroundColor Yellow; exit 4 }

$headers = @{ Authorization = "token $tok"; "User-Agent" = "ABTG-Runner"; Accept = "application/vnd.github+json" }
$apiBase = "https://api.github.com/repos/$Owner/$Repo"

function PubblicaFile([string]$locale,[string]$repoPath){
  $b64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes($locale))
  $sha = $null
  try { $sha = (Invoke-RestMethod -Method Get -Uri "$apiBase/contents/$repoPath`?ref=$Branch" -Headers $headers).sha } catch {}
  $body = @{ message = ("Runner ABTG: referto automatico (" + (Get-Date -Format 'yyyy-MM-dd HH:mm') + ")")
             content = $b64; branch = $Branch }
  if($sha){ $body.sha = $sha }
  try {
    Invoke-RestMethod -Method Put -Uri "$apiBase/contents/$repoPath" -Headers $headers -Body ($body | ConvertTo-Json) -ContentType "application/json" | Out-Null
    Write-Host ("  OK pubblicato: " + $repoPath) -ForegroundColor Green
    return $true
  } catch {
    Write-Host ("  PUBBLICAZIONE FALLITA (" + $repoPath + "): " + $_.Exception.Message) -ForegroundColor Red
    return $false
  }
}

Titolo "PUBBLICAZIONE"
$base = "backtest_pipeline/coda/referti/"
[void](PubblicaFile $ref ($base + (Split-Path $ref -Leaf)))
foreach($l in @(Get-ChildItem $Lavoro -Filter "*.log" -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -ge $avvio })){
  [void](PubblicaFile $l.FullName ($base + $l.Name))
}
Write-Host ""
Write-Host ("ESITO: " + $esito) -ForegroundColor $(if($esito -eq "COMPLETO"){"Green"}else{"Yellow"})
exit 0
