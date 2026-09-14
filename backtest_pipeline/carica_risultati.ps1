# =====================================================================
#  carica_risultati.ps1 -- i CSV dei round girati sul VPS entrano nel repo
#  (nasce dalla classe 307: il runner pubblica il REFERTO, mai i CSV)
#
#  BERSAGLIO: finestra PowerShell sul VPS.
#  NON tocca NESSUN terminale MT5 (ne' 50503392 BCM Markets MT5 Terminal,
#  ne' 50504263 -V3, ne' 10105439 C:\BCM_Reale, ne' 50504400
#  C:\MT5_Backtest): legge file dal disco e parla con l'API GitHub.
#  Zero Start-Process, zero ordini, zero scritture su disco.
#
#  Si puo' ESEGUIRE come file o INCOLLARE in console:
#   - niente param(), niente exit (exit chiuderebbe la finestra);
#   - le guardie non contano sul "return" per fermare le righe dopo (in
#     console ogni statement top-level gira per conto suo): se manca il
#     token o la sorgente, la LISTA resta vuota e il ciclo non parte;
#   - nessuna riga VUOTA dentro un blocco multiriga (nella console 5.1
#     una riga vuota chiude l'input in continuazione e spezza il blocco):
#     dentro i blocchi i separatori sono righe di commento.
# =====================================================================
$ErrorActionPreference = "Continue"
# TLS 1.2: senza questa riga Windows PowerShell 5.1 puo' presentarsi a
# api.github.com con TLS 1.0 e si prende "Could not create SSL/TLS secure
# channel" su OGNI chiamata -- zero file caricati. E' la stessa riga di
# runner_abtg.ps1 r.104, pubblica_trades.ps1 r.57, RIGA_ROUND_VPS.ps1 r.101.
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$Owner  = "claudiospadaro12"
$Repo   = "github"
$Branch = "lavoro"
$GiorniIndietro = 30
$MaxMB   = 20
$MaxFile = 300
# Pausa fra due SCRITTURE: 400 ms e' il ritmo misurato il 13/09 su 98 file
# senza incappare nell'abuse detection. Le scritture ora sono molte meno
# (i file identici non si riscrivono: vedi piu' sotto).
$PausaMs = 400

$SorgenteLocale = Join-Path $env:USERPROFILE "abtg_round\risultati_prove"
# Sottoalbero DEDICATO all'origine. L'archivio curato sta in
# backtest_pipeline/risultati_prove/<EA>/ e NON si tocca: la PUT con lo
# "sha" presente AGGIORNA, e un aggiornamento silenzioso su una fonte
# curata e' una perdita di dati travestita da successo (classe 311).
$DestPrefix = "backtest_pipeline/risultati_prove/dal_vps"

# Ritorna il PERCORSO del file token, mai il token: cosi' il token non
# puo' finire per sbaglio in un output, in un oggetto o in un log.
function TrovaTokenFile {
  $candidati = @(
    (Join-Path $env:USERPROFILE ".gh_report_token.txt"),
    "C:\Users\Administrator\.gh_report_token.txt"
  )
  foreach ($c in $candidati) {
    if (Test-Path -LiteralPath $c) {
      $t = (Get-Content -LiteralPath $c -Raw).Trim()
      if ($t.Length -gt 0) { return $c }
    }
  }
  return $null
}

# Ogni SEGMENTO codificato per conto suo: le "/" separatrici restano tali.
function UrlPath([string]$p) {
  $parti = $p -split "/"
  $enc = $parti | ForEach-Object { [Uri]::EscapeDataString($_) }
  return ($enc -join "/")
}

# Lo "sha" che l'API dei contents restituisce e' lo sha del BLOB git:
# sha1("blob <lunghezza>\0" + contenuto). Calcolandolo in locale si sa
# PRIMA di scrivere se il file nel repo e' gia' identico -- niente commit
# inutili e niente chiamate di scrittura sprecate.
# Verificato contro "git hash-object": stesso digest, cifra per cifra.
function BlobSha([byte[]]$dati) {
  $hdr = [System.Text.Encoding]::ASCII.GetBytes("blob " + $dati.Length + [char]0)
  $tot = New-Object byte[] ($hdr.Length + $dati.Length)
  [Array]::Copy($hdr, 0, $tot, 0, $hdr.Length)
  [Array]::Copy($dati, 0, $tot, $hdr.Length, $dati.Length)
  $alg = [System.Security.Cryptography.SHA1]::Create()
  $h = $alg.ComputeHash($tot)
  $alg.Dispose()
  return ([BitConverter]::ToString($h).Replace("-", "").ToLowerInvariant())
}

$fileToken = TrovaTokenFile
$tok = $null
if ($fileToken) { $tok = (Get-Content -LiteralPath $fileToken -Raw).Trim() }
$headers = $null
if ($tok) {
  $headers = @{ Authorization = "token $tok"; "User-Agent" = "ABTG-Carica"; Accept = "application/vnd.github+json" }
}
$apiBase = "https://api.github.com/repos/$Owner/$Repo"

$tutti = @()
$scanTot = 0
$scartEta = 0
$scartDim = 0
$scartTetto = 0
if (-not $tok) {
  Write-Host "NESSUN TOKEN nei percorsi noti (%USERPROFILE%\.gh_report_token.txt" -ForegroundColor Red
  Write-Host "oppure C:\Users\Administrator\.gh_report_token.txt): non carico niente." -ForegroundColor Red
} elseif (-not (Test-Path -LiteralPath $SorgenteLocale)) {
  Write-Host ("Cartella sorgente non trovata: " + $SorgenteLocale) -ForegroundColor Red
  Write-Host "E' la cartella in cui scrive il driver dei round (-Work): non c'e' niente da caricare." -ForegroundColor Red
} else {
  Write-Host ("token letto da : " + $fileToken + "   (il token non viene MAI stampato ne' scritto)")
  # Estensione confrontata a mano: -Filter "*.csv" sul provider FileSystem
  # pesca anche per nome 8.3 (e' il classico "*.doc" che tira dentro i .docx).
  $grezzi = @(Get-ChildItem -LiteralPath $SorgenteLocale -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $_.Extension -eq ".csv" })
  $scanTot = $grezzi.Count
  $soglia = (Get-Date).AddDays(-$GiorniIndietro)
  $vivi = @($grezzi | Where-Object { $_.LastWriteTime -ge $soglia })
  $scartEta = $scanTot - $vivi.Count
  $piccoli = @($vivi | Where-Object { $_.Length -le ($MaxMB * 1MB) })
  $scartDim = $vivi.Count - $piccoli.Count
  if ($piccoli.Count -gt $MaxFile) {
    $tutti = @($piccoli | Sort-Object LastWriteTime -Descending | Select-Object -First $MaxFile)
    $scartTetto = $piccoli.Count - $MaxFile
  } else {
    $tutti = $piccoli
  }
}

Write-Host ""
Write-Host ("SORGENTE     : " + $SorgenteLocale)
Write-Host ("DESTINAZIONE : " + $DestPrefix + "/   (ramo " + $Branch + ") -- sottoalbero dedicato: l'archivio curato non viene toccato")
Write-Host ("DA CARICARE  : " + $tutti.Count + " CSV, su " + $scanTot + " trovati sotto la sorgente")

$nuovi = 0
$aggiornati = 0
$identici = 0
$falliti = 0
$saltati = 0

foreach ($f in $tutti) {
  # Guardia sul prefisso: senza, un FullName che non cominci per
  # $SorgenteLocale farebbe tagliare a Substring caratteri a caso e il
  # file finirebbe in un percorso repo sbagliato, in silenzio.
  if (-not $f.FullName.StartsWith($SorgenteLocale, [StringComparison]::OrdinalIgnoreCase)) {
    Write-Host ("  SALTATO (fuori dalla cartella sorgente): " + $f.FullName) -ForegroundColor Yellow
    $saltati++
    continue
  }
  $relativo = $f.FullName.Substring($SorgenteLocale.Length).TrimStart("\", "/") -replace "\\", "/"
  $percorsoRepo = "$DestPrefix/$relativo"
  $urlEnc = UrlPath $percorsoRepo
  $bytes = $null
  try {
    $bytes = [System.IO.File]::ReadAllBytes($f.FullName)
  } catch {
    Write-Host ("  SALTATO (lettura file fallita): " + $relativo) -ForegroundColor Yellow
    $saltati++
    continue
  }
  if ($null -eq $bytes) {
    Write-Host ("  SALTATO (lettura file fallita): " + $relativo) -ForegroundColor Yellow
    $saltati++
    continue
  }
  $shaLocale = BlobSha $bytes
  # GET dello sha gia' nel repo. 404 = file nuovo, ed e' il caso normale.
  # Un codice DIVERSO da 404 non e' "nuovo": e' una chiamata andata storta,
  # e va detto invece di essere scambiato per un file che non c'e'.
  $shaEsistente = $null
  $codiceGet = 0
  try {
    $ris = Invoke-RestMethod -Uri ("$apiBase/contents/" + $urlEnc + "?ref=$Branch") -Headers $headers -Method Get -ErrorAction Stop
    $shaEsistente = $ris.sha
    $codiceGet = 200
  } catch {
    $shaEsistente = $null
    try { $codiceGet = [int]$_.Exception.Response.StatusCode } catch { $codiceGet = 0 }
    if ($codiceGet -ne 404) {
      Write-Host ("  NOTA: lettura sha non riuscita (codice " + $codiceGet + ") su " + $relativo + " -- provo a scriverlo come nuovo") -ForegroundColor DarkYellow
    }
  }
  if ($shaEsistente -and ($shaEsistente -eq $shaLocale)) {
    Write-Host ("  IDENTICO (gia' nel repo, non riscrivo): " + $relativo) -ForegroundColor DarkGray
    $identici++
    continue
  }
  $corpo = @{
    message = "Risultati dal VPS: $($f.Name) ($(Get-Date -Format 'yyyy-MM-dd HH:mm'))"
    content = [Convert]::ToBase64String($bytes)
    branch  = $Branch
  }
  if ($shaEsistente) { $corpo["sha"] = $shaEsistente }
  $corpoJson = $corpo | ConvertTo-Json -Compress
  try {
    Invoke-RestMethod -Uri ("$apiBase/contents/" + $urlEnc) -Headers $headers -Method Put -Body $corpoJson -ContentType "application/json; charset=utf-8" -ErrorAction Stop | Out-Null
    if ($shaEsistente) {
      Write-Host ("  AGGIORNATO: " + $relativo) -ForegroundColor Cyan
      $aggiornati++
    } else {
      Write-Host ("  NUOVO     : " + $relativo) -ForegroundColor Green
      $nuovi++
    }
  } catch {
    Write-Host ("  FALLITO   : " + $relativo + " -- " + $_.Exception.Message) -ForegroundColor Red
    $falliti++
  }
  # La pausa sta DOPO una scrittura vera: i file identici non la pagano.
  Start-Sleep -Milliseconds $PausaMs
}

Write-Host ""
Write-Host "===== RIEPILOGO ====="
Write-Host ("CSV TROVATI sotto la sorgente : " + $scanTot)
if ($scartEta -gt 0) {
  Write-Host ("  NON guardati, piu' vecchi di " + $GiorniIndietro + " giorni : " + $scartEta) -ForegroundColor Yellow
} else {
  Write-Host ("  NON guardati, piu' vecchi di " + $GiorniIndietro + " giorni : 0")
}
if ($scartDim -gt 0) {
  Write-Host ("  NON guardati, piu' grandi di " + $MaxMB + " MB        : " + $scartDim) -ForegroundColor Yellow
} else {
  Write-Host ("  NON guardati, piu' grandi di " + $MaxMB + " MB        : 0")
}
if ($scartTetto -gt 0) {
  Write-Host ("  NON guardati, oltre il tetto di " + $MaxFile + " file    : " + $scartTetto) -ForegroundColor Yellow
} else {
  Write-Host ("  NON guardati, oltre il tetto di " + $MaxFile + " file    : 0")
}
Write-Host ("ESAMINATI                     : " + $tutti.Count)
Write-Host ("  NUOVI                       : " + $nuovi)
Write-Host ("  AGGIORNATI                  : " + $aggiornati)
Write-Host ("  IDENTICI (nessuna scrittura): " + $identici)
Write-Host ("  FALLITI                     : " + $falliti)
Write-Host ("  SALTATI                     : " + $saltati)
Write-Host ("SCRITTI DAVVERO NEL REPO      : " + ($nuovi + $aggiornati))
$contati = $nuovi + $aggiornati + $identici + $falliti + $saltati
if ($contati -ne $tutti.Count) {
  Write-Host ("ATTENZIONE: i conti NON tornano (" + $contati + " contati contro " + $tutti.Count + " esaminati): non fidarti di questo riepilogo.") -ForegroundColor Red
}
if ($falliti -gt 0) {
  Write-Host "Ci sono FALLITI: rilancia pure la stessa riga, i file gia' identici non vengono riscritti." -ForegroundColor Yellow
}
if (($scartEta + $scartDim + $scartTetto) -gt 0) {
  Write-Host "ATTENZIONE: dei CSV sono rimasti FUORI per i filtri qui sopra -- non e' 'tutto caricato'." -ForegroundColor Yellow
}
