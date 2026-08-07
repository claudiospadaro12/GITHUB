# =====================================================================
#  coda_weekend.ps1  --  il weekend di test, SENZA nessuno alla tastiera
# ---------------------------------------------------------------------
#  PERCHE' ESISTE (07/08/2026)
#  Claudio: "questo weekend l'agente lanci in autonomia tutti i test,
#  OHLC, tick reali, walk-forward, e poi voglio il report".
#
#  I DUE LIMITI FISICI, DETTI SUBITO:
#   1. MT5 gira solo su questo PC. L'unica cosa che Claudio deve fare
#      e' lanciare QUESTO script una volta e lasciare il PC acceso
#      (MT5 chiuso, sospensione disattivata).
#   2. "Tutte le combinazioni possibili" non esiste: 79 input sono piu'
#      combinazioni che atomi. Si fa quello che ha senso: per ogni EA
#      mai misurato, la domanda FASE 0 ("ha un edge? su quale TF?"),
#      coi criteri di promozione scritti PRIMA nei file prove\*.txt.
#
#  COME LAVORA - due stadi, meccanici:
#   STADIO 1  tutti i 42 lavori di prove\CODA.csv in OHLC M1 (veloce).
#             L'OHLC e' SOLO screening: mai un verdetto.
#   STADIO 2  chi ha almeno una cella con profitto > 0 in ENTRAMBE le
#             finestre (LA STESSA cella) rigira TUTTO a tick reali.
#             Nessuna scelta di celle: si promuove l'EA, non la cella.
#             Scegliere la cella migliore e' il vizio che ci e' gia'
#             costato due volte (trailing M5, RangeMode PREVBAR).
#
#  Ogni CSV finito viene PUBBLICATO sul repo (se c'e' il token), cosi'
#  l'analisi puo' partire da remoto mentre la coda va avanti. Il token
#  e' lo stesso di pubblica_trades: copialo in %USERPROFILE% come
#  .gh_report_token.txt (sul VPS sta gia' li').
#
#  Si puo' SPEGNERE E RIPRENDERE: i CSV gia' fatti non si rifanno.
#
#  USO (PC di backtest, MT5 CHIUSO):
#    powershell -ExecutionPolicy Bypass -File .\coda_weekend.ps1
#  Prova a vuoto (10 secondi, non apre MT5):
#    powershell -ExecutionPolicy Bypass -File .\coda_weekend.ps1 -SoloControllo -Primi 3
# =====================================================================
param(
  [string]$TokenFile = "",
  [switch]$SoloControllo,     # gira i controlli di ogni lavoro senza aprire MT5
  [switch]$SoloOhlc,          # si ferma allo stadio 1
  [int]$Primi = 0,            # solo i primi N lavori (per provare)
  [string]$Branch = "lavoro"
)
$ErrorActionPreference = "Continue"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$RawBase = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Branch"
$ApiBase = "https://api.github.com/repos/claudiospadaro12/GITHUB"
$Work = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }
Set-Location $Work
$Shell = (Get-Process -Id $PID).Path    # lo stesso PowerShell con cui giro io

Write-Host "=== CODA DEL WEEKEND ===" -ForegroundColor Cyan

# --- MT5 chiuso? Se e' aperto ogni lavoro fallira': meglio dirlo ORA.
if ((Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) -and -not $SoloControllo) {
  Write-Host "!!! MetaTrader e' APERTO. Chiudilo e rilancia: col tester aperto escono 0 CSV." -ForegroundColor Red
  exit 1
}

# --- il driver e la coda, freschi dal repo (la copia locale e' il ripiego)
function Scarica($nome, $dest) {
  try { Invoke-WebRequest -Uri "$RawBase/backtest_pipeline/$nome" -OutFile $dest -UseBasicParsing; return $true }
  catch { return (Test-Path $dest) }
}
$Gen = Join-Path $Work "walkforward_generico.ps1"
if (-not (Scarica "walkforward_generico.ps1" $Gen)) { Write-Host "Non ho il driver e non riesco a scaricarlo." -ForegroundColor Red; exit 1 }
New-Item -ItemType Directory -Force -Path (Join-Path $Work "prove") | Out-Null
$CodaFile = Join-Path $Work "prove\CODA.csv"
if (-not (Scarica "prove/CODA.csv" $CodaFile)) { Write-Host "Non ho prove\CODA.csv." -ForegroundColor Red; exit 1 }

$Lavori = @(Get-Content $CodaFile | Where-Object { $_ -notmatch '^\s*#' -and $_ -match ';' } |
  Select-Object -Skip 1 | ForEach-Object {
    $c = $_ -split ';'
    if ($c.Count -ge 4) { [pscustomobject]@{ ea=$c[0].Trim(); sym=$c[1].Trim(); per=$c[2].Trim(); da=$c[3].Trim() } }
  })
if ($Primi -gt 0) { $Lavori = @($Lavori | Select-Object -First $Primi) }
Write-Host ("    lavori in coda: {0}" -f $Lavori.Count) -ForegroundColor Gray

# --- il token per pubblicare man mano (facoltativo ma fortemente utile)
$Token = ""
$Candidati = @()
if ($TokenFile) { $Candidati += $TokenFile }
$Candidati += (Join-Path $env:USERPROFILE ".gh_report_token.txt")
$Candidati += "C:\ABTG\.gh_report_token.txt"
foreach ($c in $Candidati) { if (-not $Token -and (Test-Path $c)) { $Token = (Get-Content $c -Raw).Trim() } }
if ($Token) { Write-Host "    token trovato: pubblico i risultati man mano" -ForegroundColor Green }
else { Write-Host "    NESSUN TOKEN: i risultati restano su questo PC (copia .gh_report_token.txt in $env:USERPROFILE)" -ForegroundColor Yellow }

function Pubblica($locale, $repoPath, $messaggio) {
  if (-not $Token) { return }
  try {
    $hdr = @{ Authorization = "token $Token"; "User-Agent" = "coda-weekend" }
    $b64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes($locale))
    $sha = $null
    try { $cur = Invoke-RestMethod -Method Get -Uri "$ApiBase/contents/$repoPath`?ref=$Branch" -Headers $hdr; $sha = $cur.sha } catch { }
    $body = @{ message = $messaggio; content = $b64; branch = $Branch }
    if ($sha) { $body.sha = $sha }
    Invoke-RestMethod -Method Put -Uri "$ApiBase/contents/$repoPath" -Headers $hdr -Body ($body | ConvertTo-Json) -ContentType "application/json" | Out-Null
    Write-Host "      pubblicato: $repoPath" -ForegroundColor DarkGreen
  } catch { Write-Host "      pubblicazione fallita per $repoPath (proseguo)" -ForegroundColor Yellow }
}

# --- il cancello di promozione: MECCANICO, scritto qui e basta.
#  Promosso = esiste almeno una cella (riga) con Profit > 0 in ENTRAMBE le
#  finestre OHLC. Se c'e' la colonna InpTF le righe si accoppiano per TF,
#  altrimenti riga per riga. NIENTE scelta della cella migliore.
function Promosso($ea, $sym) {
  $dir = Join-Path $Work "risultati_prove\$ea"
  $fis = Join-Path $dir ($ea + "_" + $sym + "_IS_ohlc.csv")
  $fos = Join-Path $dir ($ea + "_" + $sym + "_OOS_ohlc.csv")
  if (-not ((Test-Path $fis) -and (Test-Path $fos))) { return $false }
  function TabellaProfit($f) {
    $r = @(Get-Content $f)
    if ($r.Count -lt 2) { return $null }
    $head = $r[0] -split ','
    $iProfit = [array]::IndexOf($head, "Profit")
    $iTF = [array]::IndexOf($head, "InpTF")
    if ($iProfit -lt 0) { return $null }
    $t = @{}
    $n = 0
    foreach ($riga in ($r | Select-Object -Skip 1)) {
      $c = $riga -split ','
      if ($c.Count -le $iProfit) { continue }
      $chiave = if ($iTF -ge 0 -and $c.Count -gt $iTF) { $c[$iTF] } else { "r$n" }
      $t[$chiave] = [double]$c[$iProfit]; $n++
    }
    return $t
  }
  $tis = TabellaProfit $fis; $tos = TabellaProfit $fos
  if (-not $tis -or -not $tos) { return $false }
  foreach ($k in $tis.Keys) {
    if ($tos.ContainsKey($k) -and $tis[$k] -gt 0 -and $tos[$k] -gt 0) { return $true }
  }
  return $false
}

# --- lo stato, riscritto e ripubblicato dopo OGNI lavoro
$Stato = New-Object System.Collections.ArrayList
$StatoFile = Join-Path $Work "STATO_CODA_WEEKEND.md"
function ScriviStato {
  $testa = @("# CODA DEL WEEKEND - stato vivo","",
    ("aggiornato: " + (Get-Date -Format "yyyy-MM-dd HH:mm") + " (ora del PC di backtest)"),"",
    "Stadio 1 = OHLC M1, SOLO screening. Stadio 2 = tick reali, solo i promossi.",
    "Promozione MECCANICA: una cella con Profit>0 in ENTRAMBE le finestre OHLC.","",
    "| EA | simbolo | OHLC | promosso | tick reali |","|---|---|---|---|---|")
  ($testa + $Stato) -join "`n" | Set-Content -Path $StatoFile -Encoding UTF8
  Pubblica $StatoFile "report/STATO_CODA_WEEKEND.md" "coda weekend: stato"
}

function EseguiGenerico($j, [int]$modello) {
  $argomenti = @("-ExecutionPolicy","Bypass","-File",$Gen,$j.ea,
                 "-Simbolo",$j.sym,"-Periodo",$j.per,"-DaQuando",$j.da,"-Modello",$modello)
  if ($SoloControllo) { $argomenti += "-SoloControllo" }
  & $Shell @argomenti 2>&1 | ForEach-Object { Write-Host "      $_" }
  return $LASTEXITCODE
}

$fatti = 0; $promossi = 0; $falliti = 0
foreach ($j in $Lavori) {
  $fatti++
  Write-Host ""
  Write-Host ("[{0}/{1}] {2} su {3} ({4})" -f $fatti, $Lavori.Count, $j.ea, $j.sym, $j.per) -ForegroundColor Cyan

  # --- stadio 1: OHLC
  $e1 = EseguiGenerico $j 1
  $okOhlc = ($e1 -eq 0)
  if (-not $okOhlc) { $falliti++ }

  if ($SoloControllo) {
    [void]$Stato.Add("| $($j.ea) | $($j.sym) | " + $(if ($okOhlc) { "controllo ok" } else { "CONTROLLO FALLITO" }) + " | - | - |")
    continue
  }

  # --- cancello + stadio 2: tick reali
  $pr = $false; $tick = "-"
  if ($okOhlc) {
    $pr = Promosso $j.ea $j.sym
    if ($pr -and -not $SoloOhlc) {
      $promossi++
      $e2 = EseguiGenerico $j 4
      $tick = if ($e2 -eq 0) { "fatto" } else { "ERRORE" }
    } elseif ($pr) { $tick = "in attesa (-SoloOhlc)" }
  }
  [void]$Stato.Add("| $($j.ea) | $($j.sym) | " + $(if ($okOhlc) { "fatto" } else { "ERRORE" }) + " | " + $(if ($pr) { "SI" } else { "no" }) + " | $tick |")

  # --- pubblica i CSV di questo lavoro (quelli che esistono)
  $dir = Join-Path $Work "risultati_prove\$($j.ea)"
  foreach ($suff in @("_IS_ohlc","_OOS_ohlc","_IS","_OOS")) {
    $f = Join-Path $dir ($j.ea + "_" + $j.sym + $suff + ".csv")
    if (Test-Path $f) {
      Pubblica $f ("backtest_pipeline/risultati_prove/" + $j.ea + "/" + $j.ea + "_" + $j.sym + $suff + ".csv") ("coda weekend: " + $j.ea + " " + $j.sym + $suff)
    }
  }
  ScriviStato
}

if ($SoloControllo) { ScriviStato }
Write-Host ""
Write-Host "=== CODA FINITA ===" -ForegroundColor White
Write-Host ("    lavori: {0}   promossi al tick reale: {1}   falliti: {2}" -f $Lavori.Count, $promossi, $falliti) -ForegroundColor Gray
Write-Host "    Lo stato completo e' in STATO_CODA_WEEKEND.md (e sul repo, se c'era il token)." -ForegroundColor Gray
Write-Host "    Per riprendere dopo uno stop: rilancia LO STESSO comando. I CSV fatti non si rifanno." -ForegroundColor Gray
