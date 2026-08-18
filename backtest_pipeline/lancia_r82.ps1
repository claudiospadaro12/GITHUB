# =====================================================================
#  lancia_r82.ps1  --  R82 TORNEO JPY
#  I 7 CROSS CON LO YEN, STESSO MOTORE, STESSA FINESTRA, UNA CELLA SOLA
#  EA: ABTG_BreakoutCorso (strategia BREAKOUT del corso di Manuela Negro,
#      implementazione fedele alla spec prove\BREAKOUT_CORSO_SPEC.md)
# ---------------------------------------------------------------------
#  LA DOMANDA (congelata in prove\TORNEO_JPY_CRITERI.md, letta PRIMA):
#    "Esiste UN cross (al massimo uno) su cui questo motore, implementato
#     fedelmente, ha edge?"
#  E la regola di portafoglio, firmata PRIMA dei numeri: dalla famiglia
#  JPY entra al massimo UNA sedia, mai il paniere.
#
#  DUE GIRI, e nessuno dei due da' da solo un verdetto:
#    -Giro 1  SCREENING   modello 1 (OHLC M1), finestra 2007.02.12 ->
#             2026.06.30 IDENTICA per tutti e sette. Serve a CONTARE le
#             operazioni e a vedere il segno su piu' regimi.
#    -Giro 2  VERDETTO    modello 4 (tick reali), finestra 2024.07.05 ->
#             2026.06.30, perche' a BCM i tick veri partono da li'
#             (misurato: R58/R72/R76/R78). SOLO sui sopravvissuti al
#             giro 1: -Solo e' OBBLIGATORIO.
#
#  COSA FA QUESTO SCRIPT:
#    1. si rifiuta di partire se MetaTrader e' aperto;
#    2. riscarica walkforward_generico.ps1, i file prova e i criteri
#       PINNATI allo stesso commit (-Rif): mai la copia vecchia;
#    3. lancia i cross in fila con modello e finestra del giro scelto;
#    4. raccoglie i CSV + le serie per-trade sul Desktop e ne fa lo zip,
#       con l'elenco dei file attesi controllato uno per uno.
#
#  DOVE: sul PC di BACKTEST, con MT5 CHIUSO. MAI SUL VPS.
#
#  PASSO 0, PRIMA DI TUTTO E FUORI DA QUESTO SCRIPT:
#    lo storico dei 7 cross a BCM e' "da scaricare (parziale)" (sonda del
#    17/08): sul server c'e', sul disco no. Prima del giro 1 si scarica e
#    SI LEGGE IL REFERTO. Se un simbolo non arriva al 2007.02.12 il round
#    si ferma e la finestra si ridichiara: mezza finestra vuota ha gia'
#    rovinato un round sugli indici.
#      powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\scarica_storico.ps1" `
#        -Simboli "USDJPY,EURJPY,GBPJPY,AUDJPY,CHFJPY,CADJPY,NZDJPY" -Da 2007.01.01 -Auto
#
#  PRIMA SEMPRE IL GIRO A VUOTO (-SoloControllo): non apre MT5, stampa
#  quante celle sono e la cella congelata che finirebbe in [TesterInputs].
#  ATTENZIONE, difetto noto del driver: nell'anteprima .ini la riga
#  "Model=4" e' SCRITTA FISSA, non e' il modello del giro. Il modello vero
#  e' quello stampato qui sotto da questo script.
#
#  QUESTO ROUND NON TOCCA IL FORWARD. La sedia BREAKOUT_EA_JPY_v3 e'
#  SPENTA dal 18/08 (FIRMA 5) e resta spenta: un eventuale vincitore
#  rientra con firma di Claudio e contratto, non da qui.
#
#  NOTA CULTURA INVARIANTE: questo script NON converte mai un numero.
#  I campi dei CSV si stampano come stringhe, esattamente come li scrive
#  MT5 (su Windows in italiano un parse senza InvariantCulture leggerebbe
#  "2.0" come VENTI).
# =====================================================================
param(
  [string]$Rif      = "lavoro",                          # commit SHA (o branch)
  [ValidateSet("1","2")][string]$Giro = "1",             # 1 = screening OHLC, 2 = verdetto tick reali
  [string]$Cartella = (Join-Path $env:USERPROFILE "r82"),
  [int]$Deposito    = 10000,                             # deposito del tester
  [string]$Solo     = "",                                # es. "USDJPY,EURJPY" (OBBLIGATORIO nel giro 2)
  [switch]$Rifai,                                        # rifa' anche i CSV gia' presenti
  [switch]$SoloControllo                                 # stampa e NON apre MT5
)
$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$Raw = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Rif"
$EA  = "ABTG_BreakoutCorso"

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

Write-Host "=== ROUND 82 - TORNEO JPY (Breakout del corso) ===" -ForegroundColor Cyan
Write-Host ("MACCHINA: " + $env:COMPUTERNAME + "   utente: " + $env:USERNAME) -ForegroundColor Cyan
Write-Host ("riferimento: " + $Rif) -ForegroundColor DarkGray
Write-Host ("data      : " + (Get-Date -Format "yyyy-MM-dd HH:mm")) -ForegroundColor DarkGray

# --- UNA MACCHINA, UN LAVORO. MT5 aperto = zero CSV.
if (Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) {
  Muori ("MetaTrader e' APERTO. Chiudilo prima di lanciare, altrimenti escono 0 CSV." + "`n" +
         "    (e se sul PC sta girando un altro lavoro - stanotte il download Dukascopy -" + "`n" +
         "     aspetta che finisca: c'e' un solo MT5)")
}

# =====================================================================
#  I SETTE CROSS - nomi BCM esatti, misurati dalla sonda del 17/08
# =====================================================================
$cross = @(
  @{ Sym="USDJPY"; Scr="R82a_scr_USDJPY.txt"; TagS="r82a"; MagS=@("779110","779111"); Tick="R82h_tick_USDJPY.txt"; TagT="r82h"; MagT=@("779210","779211"); Broker="1971.01.03" }
  @{ Sym="EURJPY"; Scr="R82b_scr_EURJPY.txt"; TagS="r82b"; MagS=@("779120","779121"); Tick="R82i_tick_EURJPY.txt"; TagT="r82i"; MagT=@("779220","779221"); Broker="1993.04.26" }
  @{ Sym="GBPJPY"; Scr="R82c_scr_GBPJPY.txt"; TagS="r82c"; MagS=@("779130","779131"); Tick="R82l_tick_GBPJPY.txt"; TagT="r82l"; MagT=@("779230","779231"); Broker="1993.04.18" }
  @{ Sym="AUDJPY"; Scr="R82d_scr_AUDJPY.txt"; TagS="r82d"; MagS=@("779140","779141"); Tick="R82m_tick_AUDJPY.txt"; TagT="r82m"; MagT=@("779240","779241"); Broker="1993.05.16" }
  @{ Sym="CHFJPY"; Scr="R82e_scr_CHFJPY.txt"; TagS="r82e"; MagS=@("779150","779151"); Tick="R82n_tick_CHFJPY.txt"; TagT="r82n"; MagT=@("779250","779251"); Broker="1992.02.18" }
  @{ Sym="CADJPY"; Scr="R82f_scr_CADJPY.txt"; TagS="r82f"; MagS=@("779160","779161"); Tick="R82o_tick_CADJPY.txt"; TagT="r82o"; MagT=@("779260","779261"); Broker="2007.02.12" }
  @{ Sym="NZDJPY"; Scr="R82g_scr_NZDJPY.txt"; TagS="r82g"; MagS=@("779170","779171"); Tick="R82p_tick_NZDJPY.txt"; TagT="r82p"; MagT=@("779270","779271"); Broker="2007.02.12" }
)

$Modello = if ($Giro -eq "2") { 4 } else { 1 }
$NomeGiro = if ($Giro -eq "2") { "GIRO 2 - VERDETTO (tick reali, 2024.07.05 ->)" } else { "GIRO 1 - SCREENING (OHLC M1, 2007.02.12 ->)" }
Write-Host ""
Write-Host ("  " + $NomeGiro) -ForegroundColor White
Write-Host ("  modello passato al driver: " + $Modello + "   deposito: " + $Deposito) -ForegroundColor White

# --- il giro 2 costa ore di tick reali: si fa SOLO sui sopravvissuti.
if ($Giro -eq "2" -and $Solo -eq "") {
  Muori ("nel GIRO 2 il parametro -Solo e' OBBLIGATORIO." + "`n" +
         "    Il verdetto a tick reali si gira SOLO sui cross sopravvissuti al giro 1" + "`n" +
         "    (criteri par.3.3). Esempio:  -Giro 2 -Solo `"USDJPY`"")
}

if ($Solo -ne "") {
  $scelti = @()
  foreach ($s in ($Solo -split ",")) { $scelti += $s.Trim().ToUpper() }
  $cross = @($cross | Where-Object { $scelti -contains $_.Sym })
  if ($cross.Count -eq 0) { Muori "il filtro -Solo '$Solo' non seleziona nessun cross (validi: USDJPY EURJPY GBPJPY AUDJPY CHFJPY CADJPY NZDJPY)." }
  Write-Host ("  -Solo attivo: giro solo " + (($cross | ForEach-Object { $_.Sym }) -join ", ")) -ForegroundColor Yellow
}

# =====================================================================
#  1. ATTREZZI (riscaricati sempre, mai la copia vecchia)
# =====================================================================
Titolo "1) attrezzi (riscaricati sempre, pinnati a $Rif)"
$Prove = Join-Path $Cartella "prove"
New-Item -ItemType Directory -Force -Path $Prove | Out-Null

$file = @{}
$file["walkforward_generico.ps1"] = "$Raw/backtest_pipeline/walkforward_generico.ps1"
$file["prove\TORNEO_JPY_CRITERI.md"] = "$Raw/backtest_pipeline/prove/TORNEO_JPY_CRITERI.md"
foreach ($c in $cross) {
  $f = if ($Giro -eq "2") { $c.Tick } else { $c.Scr }
  $file["prove\" + $f] = "$Raw/backtest_pipeline/prove/" + $f
}

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
foreach ($c in $cross) {
  $f = if ($Giro -eq "2") { $c.Tick } else { $c.Scr }
  $p = Join-Path $Prove $f
  if (-not (Select-String -Path $p -SimpleMatch -Pattern "R82 / TORNEO JPY" -Quiet)) {
    Muori ("il file prova " + $f + " non contiene il marcatore R82: e' una copia sbagliata o vecchia.")
  }
}
$wf = Join-Path $Cartella "walkforward_generico.ps1"
if (-not (Select-String -Path $wf -SimpleMatch -Pattern "WALK-FORWARD GENERICO" -Quiet)) {
  Muori "walkforward_generico.ps1 scaricato non e' quello giusto (manca il marcatore)."
}

# --- le anteprime VECCHIE si buttano PRIMA: un'anteprima rimasta dal giro
#     precedente si legge come se fosse di adesso (referto stantio).
Get-ChildItem -Path $Cartella -Filter "anteprima_*.ini" -ErrorAction SilentlyContinue | ForEach-Object {
  try { Remove-Item -LiteralPath $_.FullName -Force } catch {}
}

# =====================================================================
#  2. LE SERIE PER-TRADE VECCHIE DEI NOSTRI MAGIC (se ci fossero)
# =====================================================================
$Common = Join-Path $env:APPDATA "MetaQuotes\Terminal\Common\Files"
if ((-not $SoloControllo) -and (Test-Path $Common)) {
  $puliti = 0
  foreach ($c in $cross) {
    $mm = if ($Giro -eq "2") { $c.MagT } else { $c.MagS }
    foreach ($m in $mm) {
      $f = Join-Path $Common ("abtg_trades_" + $EA + "_" + $c.Sym + "_" + $m + ".csv")
      if (Test-Path -LiteralPath $f) {
        try { Remove-Item -LiteralPath $f -Force; $puliti++ } catch { Write-Host ("    non riesco a cancellare " + $f) -ForegroundColor Yellow }
      }
    }
  }
  if ($puliti -gt 0) { Write-Host ("    ripulite " + $puliti + " serie per-trade di corse precedenti") -ForegroundColor DarkYellow }
}

# =====================================================================
#  3. LE CORSE
# =====================================================================
$Risultati = Join-Path $Cartella ("risultati_prove\" + $EA)
$falliti = @()
$i = 0
foreach ($c in $cross) {
  $i++
  $fProva = if ($Giro -eq "2") { $c.Tick } else { $c.Scr }
  $tag    = if ($Giro -eq "2") { $c.TagT } else { $c.TagS }
  Titolo ("2." + $i + ") " + $c.Sym + " [" + $tag + "]   (storico broker: " + $c.Broker + ")")

  $arg = @("-ExecutionPolicy","Bypass","-File",$wf,$EA,
           "-Prova",("prove\" + $fProva),
           "-Modello","$Modello",
           "-Deposito","$Deposito",
           "-Etichetta",$tag)
  if ($SoloControllo) { $arg += "-SoloControllo" }
  if ($Rifai)         { $arg += "-Rifai" }

  $global:LASTEXITCODE = 0
  & powershell $arg
  if ($LASTEXITCODE -ne 0) {
    Write-Host ("    " + $c.Sym + " uscito con codice " + $LASTEXITCODE + ": vado avanti, la raccolta dira' cosa manca.") -ForegroundColor Yellow
    $falliti += $c.Sym
    continue
  }
  if ($SoloControllo) { continue }

  # --- serie per-trade: si raccolgono SUBITO, prima del cross dopo
  if (Test-Path $Common) {
    $mm = if ($Giro -eq "2") { $c.MagT } else { $c.MagS }
    foreach ($m in $mm) {
      $f = Join-Path $Common ("abtg_trades_" + $EA + "_" + $c.Sym + "_" + $m + ".csv")
      if (Test-Path -LiteralPath $f) {
        New-Item -ItemType Directory -Force -Path $Risultati | Out-Null
        Copy-Item -LiteralPath $f -Destination (Join-Path $Risultati ("pertrade_" + $tag + "_" + $m + ".csv")) -Force
        Write-Host ("    serie per-trade raccolta: magic " + $m) -ForegroundColor DarkGray
      }
    }
  }
}

# =====================================================================
#  4a. GIRO A VUOTO: si controlla che OGNI cross abbia prodotto la sua
#      anteprima, e il codice d'uscita DIPENDE da quello (difetto n.14
#      della checklist: un giro a vuoto che esce 0 anche se un pezzo e'
#      fallito e' un guard decorativo).
# =====================================================================
if ($SoloControllo) {
  Titolo "3) ANTEPRIME PRODOTTE (una per cross) e cella congelata"
  $senzaAnteprima = @()
  foreach ($c in $cross) {
    $ant = Join-Path $Cartella ("anteprima_" + $EA + "_" + $c.Sym + ".ini")
    Write-Host ""
    Write-Host ("  " + $c.Sym) -ForegroundColor White
    if (-not (Test-Path -LiteralPath $ant)) {
      Write-Host "      (nessuna anteprima prodotta)" -ForegroundColor Red
      $senzaAnteprima += $c.Sym
      continue
    }
    $chiavi = "^(InpWilliamsPeriod|InpSuperTrendATR|InpSuperTrendMult|InpCandeleRettangolo|InpIncludiCandelaRottura|InpAttesaCandeleZona|InpTargetR|InpMinRR|InpChiudiSuSegnaleContrario|InpChiudiSuWilliamsOpposto|InpRischioMode|InpRiskPercent|InpMagic)="
    foreach ($r in (Select-String -Path $ant -Pattern $chiavi)) {
      Write-Host ("      " + $r.Line) -ForegroundColor Gray
    }
    foreach ($r in (Select-String -Path $ant -Pattern "^(Symbol|Period|FromDate|ToDate)=")) {
      Write-Host ("      " + $r.Line) -ForegroundColor DarkGray
    }
  }
  Write-Host ""
  Write-Host "  Confronta queste righe con la tabella del par.4 dei criteri." -ForegroundColor Yellow
  Write-Host "  La riga 'Model=' dell'anteprima e' SCRITTA FISSA a 4 dal driver:" -ForegroundColor Yellow
  Write-Host ("  il modello VERO di questo giro e' " + $Modello + ".") -ForegroundColor Yellow
  Write-Host ""
  if ($falliti.Count -gt 0 -or $senzaAnteprima.Count -gt 0) {
    Write-Host ("=== GIRO A VUOTO FALLITO: " + (($falliti + $senzaAnteprima | Select-Object -Unique) -join " ") + " ===") -ForegroundColor Red
    exit 1
  }
  Write-Host "SoloControllo: MT5 non e' stato aperto, nessun CSV da raccogliere." -ForegroundColor Green
  exit 0
}

# =====================================================================
#  4b. RACCOLTA SUL DESKTOP + ZIP (regola delle righe di lancio)
# =====================================================================
Titolo "3) raccolta sul Desktop"
$desk = Trova-Desktop
$nomeCartella = "R82_TORNEO_JPY_giro" + $Giro
$dest = Join-Path $desk $nomeCartella
if (Test-Path $dest) { Remove-Item $dest -Recurse -Force -ErrorAction SilentlyContinue }
New-Item -ItemType Directory -Force -Path $dest | Out-Null

# suffisso dei CSV: il driver antepone "_ohlc" a tutto cio' che NON e' tick reali
$suff = if ($Modello -eq 4) { "" } else { "_ohlc" }
$attesi = @()
foreach ($c in $cross) {
  $tag = if ($Giro -eq "2") { $c.TagT } else { $c.TagS }
  $attesi += ($EA + "_" + $c.Sym + "_IS"  + $suff + "_" + $tag + ".csv")
  $attesi += ($EA + "_" + $c.Sym + "_OOS" + $suff + "_" + $tag + ".csv")
}

if (Test-Path $Risultati) {
  foreach ($f in (Get-ChildItem $Risultati -Filter "*r82*.csv" -ErrorAction SilentlyContinue)) {
    try { Copy-Item -LiteralPath $f.FullName -Destination (Join-Path $dest $f.Name) -Force } catch { Write-Host ("    non copiato: " + $f.Name) -ForegroundColor Yellow }
  }
}
foreach ($c in $cross) {
  $fProva = if ($Giro -eq "2") { $c.Tick } else { $c.Scr }
  try { Copy-Item -LiteralPath (Join-Path $Prove $fProva) -Destination $dest -Force } catch {}
}
try { Copy-Item -LiteralPath (Join-Path $Prove "TORNEO_JPY_CRITERI.md") -Destination $dest -Force } catch {}

Write-Host ""
Write-Host "    FILE ATTESI (controllali uno per uno):" -ForegroundColor White
$mancanti = 0
foreach ($a in $attesi) {
  if (Test-Path (Join-Path $dest $a)) { Write-Host ("      OK      " + $a) -ForegroundColor Green }
  else { Write-Host ("      MANCA  " + $a) -ForegroundColor Red; $mancanti++ }
}
$nPerTrade = @(Get-ChildItem $dest -Filter "pertrade_r82*.csv" -ErrorAction SilentlyContinue).Count
Write-Host ("      (serie per-trade raccolte: " + $nPerTrade + " - sono della SOLA finestra OOS, l'IS viene sovrascritta)") -ForegroundColor DarkGray

# =====================================================================
#  5. TABELLA DI LETTURA - solo stringhe, NESSUN parse numerico
# =====================================================================
Titolo "4) tabella (letta dai CSV, campi NON convertiti)"
Write-Host ("  {0,-8} {1,-4} {2,14} {3,10} {4,9} {5,7}  {6}" -f "cross","fin.","Profit","PF","DD %","trades","magic") -ForegroundColor White
foreach ($c in $cross) {
  $tag = if ($Giro -eq "2") { $c.TagT } else { $c.TagS }
  foreach ($w in @("IS","OOS")) {
    $csv = Join-Path $dest ($EA + "_" + $c.Sym + "_" + $w + $suff + "_" + $tag + ".csv")
    if (-not (Test-Path -LiteralPath $csv)) {
      Write-Host ("  {0,-8} {1,-4} {2}" -f $c.Sym, $w, "CSV MANCANTE") -ForegroundColor Red
      continue
    }
    $righe = @()
    try { $righe = @(Import-Csv -LiteralPath $csv) } catch { }
    if ($righe.Count -eq 0) {
      Write-Host ("  {0,-8} {1,-4} {2}" -f $c.Sym, $w, "ZERO PASSATE (solo intestazione)") -ForegroundColor Red
      continue
    }
    foreach ($r in $righe) {
      Write-Host ("  {0,-8} {1,-4} {2,14} {3,10} {4,9} {5,7}  {6}" -f $c.Sym, $w, $r.Profit, $r.'Profit Factor', $r.'Equity DD %', $r.Trades, $r.InpMagic) -ForegroundColor Gray
    }
    # le due passate gemelle DEVONO essere identiche: e' il controllo gratis
    if ($righe.Count -eq 2) {
      if ($righe[0].Profit -ne $righe[1].Profit) {
        Write-Host ("      ATTENZIONE: le due passate gemelle di " + $c.Sym + " " + $w + " NON coincidono. Qualcosa e' rotto.") -ForegroundColor Red
      }
    } else {
      Write-Host ("      ATTENZIONE: " + $righe.Count + " righe invece di 2 (cache del tester? magic gia' usato?)") -ForegroundColor Red
    }
  }
}
Write-Host ""
Write-Host "  I CRITERI SI LEGGONO PRIMA DELLA TABELLA: prove\TORNEO_JPY_CRITERI.md" -ForegroundColor Yellow
if ($Giro -eq "1") {
  Write-Host "  E il giro 1 NON promuove: e' OHLC, serve a contare le operazioni e" -ForegroundColor Yellow
  Write-Host "  a vedere il segno. Il verdetto e' il giro 2, a tick reali." -ForegroundColor Yellow
} else {
  Write-Host "  Dentro questa finestra NON c'e' ne' il 2020 ne' il 2022: valida il" -ForegroundColor Yellow
  Write-Host "  RIEMPIMENTO, mai la robustezza di regime. Va scritto accanto al numero." -ForegroundColor Yellow
}
Write-Host "  Vince AL MASSIMO UN cross (regola di portafoglio firmata prima)." -ForegroundColor Yellow
Write-Host "  ZERO vincitori e' un verdetto valido: la famiglia JPY resta spenta." -ForegroundColor Yellow

# =====================================================================
#  6. REFERTO + ZIP
# =====================================================================
$ref = @()
$ref += "REFERTO DI RACCOLTA - R82 TORNEO JPY (Breakout del corso)"
$ref += ("data: " + (Get-Date -Format "yyyy-MM-dd HH:mm"))
$ref += ("giro: " + $Giro + "   " + $NomeGiro)
$ref += ("riferimento (commit/branch): " + $Rif)
$ref += ("macchina: " + $env:COMPUTERNAME + "   utente: " + $env:USERNAME)
$ref += ("deposito: " + $Deposito + "   modello: " + $Modello + "   EA: " + $EA)
$ref += ("cross girati: " + (($cross | ForEach-Object { $_.Sym }) -join " "))
$ref += ("CSV attesi: " + $attesi.Count + "   mancanti: " + $mancanti)
$ref += ("serie per-trade raccolte: " + $nPerTrade + " (solo finestra OOS)")
if ($falliti.Count -gt 0) { $ref += ("CROSS USCITI IN ERRORE: " + ($falliti -join " ")) }
$ref += ""
$ref += "La riga 'data:' qui sopra deve essere di ADESSO. Se e' vecchia, stai"
$ref += "guardando una raccolta precedente e non i file di questa corsa."
$ref | Set-Content -Path (Join-Path $dest ("REFERTO_RACCOLTA_R82_giro" + $Giro + ".txt")) -Encoding ASCII

$zip = Join-Path $desk ($nomeCartella + ".zip")
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
if ($mancanti -gt 0 -or $falliti.Count -gt 0) {
  Write-Host ("=== " + $mancanti + " CSV su " + $attesi.Count + " MANCANO. Guarda sopra qual e' stato l'errore. ===") -ForegroundColor Red
  Write-Host "    Si rilancia la STESSA riga: i CSV gia' fatti non si rifanno" -ForegroundColor Yellow
  Write-Host "    (per rifarli davvero serve -Rifai: senza, il driver li salta)." -ForegroundColor Yellow
  exit 1
} else {
  Write-Host ("=== TUTTI E " + $attesi.Count + " I CSV CI SONO. ===") -ForegroundColor Green
  Write-Host "    Questo round NON tocca il forward: nessuna sedia e' cambiata." -ForegroundColor Gray
}
