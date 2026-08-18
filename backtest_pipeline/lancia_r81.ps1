# =====================================================================
#  lancia_r81.ps1  --  R81-PROCESSO-ALLE-USCITE
#  ROUND 81: sei varianti di USCITA a INGRESSI IDENTICI
#            (ABTG_MaxMinNotte_DAX_Short_Ottimizzato - D30EUR)
# ---------------------------------------------------------------------
#  LA DOMANDA (congelata in prove\R81_USCITE_CRITERI.md, letta PRIMA):
#    "A PARITA' DI INGRESSI, la gestione attuale della sedia viva estrae
#     piu' valore delle alternative?"
#
#  LE SEI VARIANTI (una per file prova, TUTTO il resto blindato):
#    A  r81a  la sedia viva esatta      (parz.50%@1R + BE, 50%@3R, EMA200, trail 2,0)
#    B  r81b  lasciar correre puro      (niente gestione: SL / TP 4R / flat 17:30)
#    C  r81c  solo breakeven poi correre(parziale SIMBOLICA 1% - vedi criteri par.4)
#    D  r81d  come A ma trailing 3,5 ATR
#    E  r81e  come A ma trailing 1,0 ATR
#    F  r81f  TP secco 2R               (InpTPfinal_R=2.0 - vedi criteri par.5)
#
#  COSA FA QUESTO SCRIPT:
#    1. si rifiuta di partire se MetaTrader e' aperto;
#    2. riscarica walkforward_generico.ps1, i sei file prova e i criteri
#       PINNATI allo stesso commit (-Rif): mai la copia vecchia;
#    3. lancia le sei varianti in fila, tick reali, deposito 100k;
#    4. raccoglie i CSV + le serie per-trade sul Desktop e ne fa lo zip,
#       con l'elenco dei file attesi controllato uno per uno.
#
#  DOVE: sul PC di BACKTEST, con MT5 CHIUSO. MAI SUL VPS.
#
#  QUANTO DURA: 6 varianti x 2 finestre x 2 magic = 24 passate a tick
#  reali su D30EUR, 2024.09.26 -> 2026.06.30. STIMA (non misura): 1-3 ore.
#
#  PRIMA SEMPRE IL GIRO A VUOTO (-SoloControllo): non apre MT5, stampa
#  quante celle sono e il BLOCCO USCITE che finirebbe in [TesterInputs]
#  di ogni variante. Costa un minuto e si legge riga per riga.
#
#  QUESTO ROUND NON TOCCA IL FORWARD. Nessuna sedia cambia, nessun .chr
#  viene riscritto, i magic 7781xx sono NUOVI e non esistono in campo.
#  Se una variante vince, fa la trafila della candidata.
# =====================================================================
param(
  [string]$Rif      = "lavoro",                          # commit SHA (o branch)
  [string]$Cartella = (Join-Path $env:USERPROFILE "r81"),
  [int]$Deposito    = 100000,                            # taglia della sedia viva sul dry-run
  [string]$Solo     = "",                                # es. "A" o "A,D": rilancia solo alcune varianti
  [switch]$SoloControllo                                 # stampa e NON apre MT5
)
$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$Raw    = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Rif"
$EA     = "ABTG_MaxMinNotte_DAX_Short_Ottimizzato"
$SIM    = "D30EUR"

function Titolo($t) { Write-Host ""; Write-Host $t -ForegroundColor Cyan }
function Muori($t)  { Write-Host ""; Write-Host "!!! $t" -ForegroundColor Red; exit 1 }

function Trova-Desktop {
  $c = @()
  try { $c += [Environment]::GetFolderPath("Desktop") } catch {}
  $c += (Join-Path $env:USERPROFILE "Desktop")
  $c += (Join-Path $env:USERPROFILE "OneDrive\Desktop")
  foreach ($d in $c) { if ($d -and (Test-Path $d)) { return $d } }
  return $env:USERPROFILE
}

Write-Host "=== ROUND 81 - PROCESSO ALLE USCITE (MaxMin DAX Short) ===" -ForegroundColor Cyan
Write-Host ("MACCHINA: " + $env:COMPUTERNAME + "   utente: " + $env:USERNAME) -ForegroundColor Cyan
Write-Host ("riferimento: " + $Rif) -ForegroundColor DarkGray
Write-Host ("data      : " + (Get-Date -Format "yyyy-MM-dd HH:mm")) -ForegroundColor DarkGray

# --- UNA MACCHINA, UN LAVORO. MT5 aperto = zero CSV.
if (Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) {
  Muori ("MetaTrader e' APERTO. Chiudilo prima di lanciare, altrimenti escono 0 CSV." + "`n" +
         "    (e se sul PC sta girando un altro round, aspetta che finisca: c'e' un solo MT5)")
}

# =====================================================================
#  LE SEI VARIANTI
# =====================================================================
$varianti = @(
  @{ Tag="r81a"; Let="A"; File="R81a_uscita_A_viva.txt";      Nota="la sedia VIVA (baseline esatta)" }
  @{ Tag="r81b"; Let="B"; File="R81b_uscita_B_correre.txt";   Nota="lasciar correre puro" }
  @{ Tag="r81c"; Let="C"; File="R81c_uscita_C_breakeven.txt"; Nota="solo breakeven, poi correre (parz. simbolica 1%)" }
  @{ Tag="r81d"; Let="D"; File="R81d_uscita_D_trail35.txt";   Nota="come A ma trailing 3,5 ATR" }
  @{ Tag="r81e"; Let="E"; File="R81e_uscita_E_trail10.txt";   Nota="come A ma trailing 1,0 ATR" }
  @{ Tag="r81f"; Let="F"; File="R81f_uscita_F_tp2r.txt";      Nota="TP secco 2R (InpTPfinal_R=2.0)" }
)
if ($Solo -ne "") {
  $scelte = @()
  foreach ($s in ($Solo -split ",")) { $scelte += $s.Trim().ToUpper() }
  $varianti = @($varianti | Where-Object { $scelte -contains $_.Let })
  if ($varianti.Count -eq 0) { Muori "il filtro -Solo '$Solo' non seleziona nessuna variante (valide: A B C D E F)." }
  Write-Host ""
  Write-Host ("    -Solo attivo: giro solo " + (($varianti | ForEach-Object { $_.Let }) -join ", ")) -ForegroundColor Yellow
}

# i magic di ogni variante: servono a ripulire le serie per-trade vecchie
# e a raccogliere quelle nuove. Sono NUOVI: non esistono in forward.
$magic = @{ "r81a"=@("778110","778111"); "r81b"=@("778120","778121"); "r81c"=@("778130","778131")
            "r81d"=@("778140","778141"); "r81e"=@("778150","778151"); "r81f"=@("778160","778161") }

# =====================================================================
#  1. ATTREZZI (riscaricati sempre, mai la copia vecchia)
# =====================================================================
Titolo "1) attrezzi (riscaricati sempre, pinnati a $Rif)"
$Prove = Join-Path $Cartella "prove"
New-Item -ItemType Directory -Force -Path $Prove | Out-Null

$file = @{}
$file["walkforward_generico.ps1"] = "$Raw/backtest_pipeline/walkforward_generico.ps1"
$file["prove\R81_USCITE_CRITERI.md"] = "$Raw/backtest_pipeline/prove/R81_USCITE_CRITERI.md"
foreach ($v in $varianti) { $file["prove\" + $v.File] = "$Raw/backtest_pipeline/prove/" + $v.File }

foreach ($k in $file.Keys) {
  $dest = Join-Path $Cartella $k
  Remove-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue   # niente copia vecchia da eseguire
  try {
    Invoke-WebRequest -Uri $file[$k] -OutFile $dest -UseBasicParsing -ErrorAction Stop
    Write-Host ("    ok  " + $k) -ForegroundColor Green
  } catch {
    Muori ("non sono riuscito a scaricare " + $k + " da " + $Rif + "`n    " + $_.Exception.Message)
  }
}
# --- controllo di versione: il file scaricato e' quello NUOVO?
#     (la cache di raw.githubusercontent tiene ~5 minuti dopo un push)
foreach ($v in $varianti) {
  $p = Join-Path $Prove $v.File
  if (-not (Select-String -Path $p -SimpleMatch -Pattern "R81 / VARIANTE" -Quiet)) {
    Muori ("il file prova " + $v.File + " non contiene il marcatore R81: e' una copia sbagliata o vecchia.")
  }
}
$wf = Join-Path $Cartella "walkforward_generico.ps1"
if (-not (Select-String -Path $wf -SimpleMatch -Pattern "WALK-FORWARD GENERICO" -Quiet)) {
  Muori "walkforward_generico.ps1 scaricato non e' quello giusto (manca il marcatore)."
}

# =====================================================================
#  2. LE SERIE PER-TRADE VECCHIE DEI NOSTRI MAGIC (se ci fossero)
#     Un file rimasto da una corsa precedente verrebbe raccolto come se
#     fosse fresco: e' il referto stantio, ma prodotto da noi.
# =====================================================================
$Common = Join-Path $env:APPDATA "MetaQuotes\Terminal\Common\Files"
if ((-not $SoloControllo) -and (Test-Path $Common)) {
  $puliti = 0
  foreach ($v in $varianti) {
    foreach ($m in $magic[$v.Tag]) {
      $f = Join-Path $Common ("abtg_trades_" + $EA + "_" + $SIM + "_" + $m + ".csv")
      if (Test-Path -LiteralPath $f) {
        try { Remove-Item -LiteralPath $f -Force; $puliti++ } catch { Write-Host ("    non riesco a cancellare " + $f) -ForegroundColor Yellow }
      }
    }
  }
  if ($puliti -gt 0) { Write-Host ("    ripulite " + $puliti + " serie per-trade di corse precedenti") -ForegroundColor DarkYellow }
}

# =====================================================================
#  3. LE SEI CORSE
# =====================================================================
$Risultati = Join-Path $Cartella ("risultati_prove\" + $EA)
$falliti = @()
$i = 0
foreach ($v in $varianti) {
  $i++
  Titolo ("2." + $i + ") VARIANTE " + $v.Let + " [" + $v.Tag + "] - " + $v.Nota)
  $arg = @("-ExecutionPolicy","Bypass","-File",$wf,$EA,
           "-Prova",("prove\" + $v.File),
           "-Modello","4",
           "-Deposito","$Deposito",
           "-Etichetta",$v.Tag)
  if ($SoloControllo) { $arg += "-SoloControllo" }

  $global:LASTEXITCODE = 0
  & powershell $arg
  if ($LASTEXITCODE -ne 0) {
    Write-Host ("    variante " + $v.Let + " uscita con codice " + $LASTEXITCODE + ": vado avanti, la raccolta dira' cosa manca.") -ForegroundColor Yellow
    $falliti += $v.Let
    continue
  }

  if ($SoloControllo) {
    # l'anteprima ha SEMPRE lo stesso nome: senza rinomina, le sei
    # varianti si sovrascrivono e non si confronta piu' niente.
    $ant = Join-Path $Cartella ("anteprima_" + $EA + "_" + $SIM + ".ini")
    $mio = Join-Path $Cartella ("anteprima_" + $v.Tag + ".ini")
    if (Test-Path -LiteralPath $ant) { Move-Item -LiteralPath $ant -Destination $mio -Force }
    continue
  }

  # --- serie per-trade: si raccolgono SUBITO, prima della variante dopo
  if (Test-Path $Common) {
    foreach ($m in $magic[$v.Tag]) {
      $f = Join-Path $Common ("abtg_trades_" + $EA + "_" + $SIM + "_" + $m + ".csv")
      if (Test-Path -LiteralPath $f) {
        New-Item -ItemType Directory -Force -Path $Risultati | Out-Null
        Copy-Item -LiteralPath $f -Destination (Join-Path $Risultati ("pertrade_" + $v.Tag + "_" + $m + ".csv")) -Force
        Write-Host ("    serie per-trade raccolta: magic " + $m) -ForegroundColor DarkGray
      }
    }
  }
}

# =====================================================================
#  4a. GIRO A VUOTO: il BLOCCO USCITE di ogni variante, in chiaro
# =====================================================================
if ($SoloControllo) {
  Titolo "3) IL BLOCCO USCITE CHE FINIREBBE IN [TesterInputs] (leggilo riga per riga)"
  $chiavi = "^(InpTP1_R|InpTP1Pct|InpBreakeven|InpTP2_R|InpTP2Pct|InpUseEMA200Target|InpTPfinal_R|InpUseTrailing|InpTrailAtrMult|InpRiskPercent|InpMagic)="
  foreach ($v in $varianti) {
    $mio = Join-Path $Cartella ("anteprima_" + $v.Tag + ".ini")
    Write-Host ""
    Write-Host ("  VARIANTE " + $v.Let + "  (" + $v.Nota + ")") -ForegroundColor White
    if (-not (Test-Path -LiteralPath $mio)) { Write-Host "      (nessuna anteprima prodotta)" -ForegroundColor Red; continue }
    foreach ($r in (Select-String -Path $mio -Pattern $chiavi)) {
      Write-Host ("      " + $r.Line) -ForegroundColor Gray
    }
  }
  Write-Host ""
  Write-Host "  Confronta queste righe con la tabella del par.3 dei criteri." -ForegroundColor Yellow
  Write-Host "  Se anche UNA non coincide, ci si ferma qui: costa un minuto," -ForegroundColor Yellow
  Write-Host "  non due ore di tick reali." -ForegroundColor Yellow
  Write-Host ""
  Write-Host "SoloControllo: MT5 non e' stato aperto, nessun CSV da raccogliere." -ForegroundColor Green
  exit 0
}

# =====================================================================
#  4b. RACCOLTA SUL DESKTOP + ZIP (regola delle righe di lancio)
# =====================================================================
Titolo "3) raccolta sul Desktop"
$desk = Trova-Desktop
$dest = Join-Path $desk "R81_USCITE"
if (Test-Path $dest) { Remove-Item $dest -Recurse -Force -ErrorAction SilentlyContinue }
New-Item -ItemType Directory -Force -Path $dest | Out-Null

$attesi = @()
foreach ($v in $varianti) {
  $attesi += ($EA + "_" + $SIM + "_IS_"  + $v.Tag + ".csv")
  $attesi += ($EA + "_" + $SIM + "_OOS_" + $v.Tag + ".csv")
}

if (Test-Path $Risultati) {
  foreach ($f in (Get-ChildItem $Risultati -Filter "*r81*.csv" -ErrorAction SilentlyContinue)) {
    try { Copy-Item -LiteralPath $f.FullName -Destination (Join-Path $dest $f.Name) -Force } catch { Write-Host ("    non copiato: " + $f.Name) -ForegroundColor Yellow }
  }
}
foreach ($v in $varianti) {
  try { Copy-Item -LiteralPath (Join-Path $Prove $v.File) -Destination $dest -Force } catch {}
}
try { Copy-Item -LiteralPath (Join-Path $Prove "R81_USCITE_CRITERI.md") -Destination $dest -Force } catch {}

Write-Host ""
Write-Host "    FILE ATTESI (controllali uno per uno):" -ForegroundColor White
$mancanti = 0
foreach ($a in $attesi) {
  if (Test-Path (Join-Path $dest $a)) { Write-Host ("      OK      " + $a) -ForegroundColor Green }
  else { Write-Host ("      MANCA  " + $a) -ForegroundColor Red; $mancanti++ }
}
$nPerTrade = @(Get-ChildItem $dest -Filter "pertrade_r81*.csv" -ErrorAction SilentlyContinue).Count
Write-Host ("      (serie per-trade raccolte: " + $nPerTrade + " - sono della SOLA finestra OOS, l'IS viene sovrascritta)") -ForegroundColor DarkGray

# =====================================================================
#  5. TABELLA DI LETTURA - solo stringhe, NESSUN parse numerico
#     (su Windows in italiano un parse senza InvariantCulture legge
#      "2.0" come VENTI: qui il problema non esiste per costruzione,
#      perche' i campi si stampano esattamente come li scrive MT5)
# =====================================================================
Titolo "4) tabella (letta dai CSV, campi NON convertiti)"
Write-Host ("  {0,-9} {1,-4} {2,14} {3,10} {4,9} {5,7}  {6}" -f "variante","fin.","Profit","PF","DD %","trades","magic") -ForegroundColor White
foreach ($v in $varianti) {
  foreach ($w in @("IS","OOS")) {
    $csv = Join-Path $dest ($EA + "_" + $SIM + "_" + $w + "_" + $v.Tag + ".csv")
    if (-not (Test-Path -LiteralPath $csv)) {
      Write-Host ("  {0,-9} {1,-4} {2}" -f $v.Let, $w, "CSV MANCANTE") -ForegroundColor Red
      continue
    }
    $righe = @()
    try { $righe = @(Import-Csv -LiteralPath $csv) } catch { }
    if ($righe.Count -eq 0) {
      Write-Host ("  {0,-9} {1,-4} {2}" -f $v.Let, $w, "ZERO PASSATE (solo intestazione)") -ForegroundColor Red
      continue
    }
    foreach ($r in $righe) {
      Write-Host ("  {0,-9} {1,-4} {2,14} {3,10} {4,9} {5,7}  {6}" -f $v.Let, $w, $r.Profit, $r.'Profit Factor', $r.'Equity DD %', $r.Trades, $r.InpMagic) -ForegroundColor Gray
    }
    # le due passate gemelle DEVONO essere identiche: e' il controllo gratis
    if ($righe.Count -eq 2) {
      if ($righe[0].Profit -ne $righe[1].Profit) {
        Write-Host ("      ATTENZIONE: le due passate gemelle di " + $v.Let + " " + $w + " NON coincidono. Qualcosa e' rotto.") -ForegroundColor Red
      }
    } else {
      Write-Host ("      ATTENZIONE: " + $righe.Count + " righe invece di 2 (cache del tester? magic gia' usato?)") -ForegroundColor Red
    }
  }
}
Write-Host ""
Write-Host "  IGIENE NUMERO UNO: la variante A deve riprodurre i CSV _ptb gia' agli atti" -ForegroundColor Yellow
Write-Host "  (IS +4766,96 PF 1,87803 DD 3,0977 / OOS +6143,38 PF 2,15985 DD 1,9213)." -ForegroundColor Yellow
Write-Host "  Se non li riproduce, il round NON si legge." -ForegroundColor Yellow
Write-Host "  E i 'trades' NON si confrontano fra varianti: A/D/E contano le parziali," -ForegroundColor Yellow
Write-Host "  B e F contano le posizioni (e fra loro DEVONO coincidere)." -ForegroundColor Yellow

# =====================================================================
#  6. REFERTO + ZIP
# =====================================================================
$ref = @()
$ref += "REFERTO DI RACCOLTA - R81 PROCESSO ALLE USCITE (MaxMin DAX Short)"
$ref += ("data: " + (Get-Date -Format "yyyy-MM-dd HH:mm"))
$ref += ("riferimento (commit/branch): " + $Rif)
$ref += ("macchina: " + $env:COMPUTERNAME + "   utente: " + $env:USERNAME)
$ref += ("deposito: " + $Deposito + "   modello: tick reali (4)   simbolo: " + $SIM)
$ref += ("varianti girate: " + (($varianti | ForEach-Object { $_.Let }) -join " "))
$ref += ("CSV attesi: " + $attesi.Count + "   mancanti: " + $mancanti)
$ref += ("serie per-trade raccolte: " + $nPerTrade + " (solo finestra OOS)")
if ($falliti.Count -gt 0) { $ref += ("VARIANTI USCITE IN ERRORE: " + ($falliti -join " ")) }
$ref += ""
$ref += "La riga 'data:' qui sopra deve essere di ADESSO. Se e' vecchia, stai"
$ref += "guardando una raccolta precedente e non i file di questa corsa."
$ref | Set-Content -Path (Join-Path $dest "REFERTO_RACCOLTA_R81.txt") -Encoding ASCII

$zip = Join-Path $desk "R81_USCITE.zip"
if (Test-Path $zip) { Remove-Item $zip -Force -ErrorAction SilentlyContinue }
try {
  Compress-Archive -Path (Join-Path $dest "*") -DestinationPath $zip -Force
  Write-Host ""
  Write-Host ("    ZIP PRONTO DA MANDARE:  " + $zip) -ForegroundColor Cyan
} catch {
  Write-Host ""
  Write-Host ("!!! lo zip NON e' stato creato: " + $_.Exception.Message) -ForegroundColor Red
  Write-Host ("    i file comunque sono qui: " + $dest) -ForegroundColor Yellow
}

Write-Host ""
if ($mancanti -gt 0) {
  Write-Host ("=== " + $mancanti + " CSV su " + $attesi.Count + " MANCANO. Guarda sopra qual e' stato l'errore. ===") -ForegroundColor Red
  Write-Host "    Si rilancia la STESSA riga: i CSV gia' fatti non si rifanno." -ForegroundColor Yellow
  exit 1
} else {
  Write-Host ("=== TUTTI E " + $attesi.Count + " I CSV CI SONO. ===") -ForegroundColor Green
  Write-Host "    I criteri si leggono PRIMA della tabella: prove\R81_USCITE_CRITERI.md" -ForegroundColor Gray
  Write-Host "    Questo round NON tocca il forward: nessuna sedia e' cambiata." -ForegroundColor Gray
}
