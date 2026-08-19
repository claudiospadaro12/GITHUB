# =====================================================================
#  lancia_r84bis.ps1  --  R84-BIS: LA VALIDAZIONE DEL RIDUTTORE-DI-PERDITA
#  Scritto sul modello di lancia_r84.ps1 (stessa struttura, stesso pin).
# ---------------------------------------------------------------------
#  LA DOMANDA (congelata in prove\R84BIS_VALIDAZIONE_D_CRITERI.md, letta
#  PRIMA dei numeri):
#    "La cella D di R84 (volumi OPPURE ATR) contiene INFORMAZIONE VERA,
#     o e' FORTUNA DELLA FINESTRA?"
#
#  PERCHE' ESISTE: R84 ha trovato UNA cella su nove che passa i quattro
#  cancelli congelati (D: PF totale 1,104 contro 0,988 del nudo, DD
#  dimezzato, n=311) - ma con l'OOS ANCORA NEGATIVO (-287, PF 0,924).
#  D riduce la perdita, NON crea un guadagno. Questo round chiede se
#  quella riduzione ha dentro dell'informazione.
#
#  QUESTO SCRIPT NON TOCCA NESSUN EA E NESSUNA SEDIA.
#  Non puo' produrre una sedia nuova: al massimo UNA RIGA DI PIANO.
#  La 770201 (Nasdaq Apertura US) e' SPENTA dal 18/08 e resta spenta.
#
#  LE PROVE, IN ORDINE DI INFORMAZIONE PER MINUTO:
#    passo 1  canarino C4  lo spread forzato MORDE a tick reali? (1 cella)
#    passo 2  canarino C3  A e D con Spread=0 SCRITTO riproducono R84? (2)
#    passo 3  TRASFERIBILITA' sul DAX, base POSITIVA - LA PROVA CHIAVE (4)
#    passo 4  ROBUSTEZZA dei due moltiplicatori, vicini stretti      (4)
#    passo 5  SCALA DI SPREAD comparativa A contro D                 (5)
#    passo 6  SPLIT alternativo 55/45                                (2)
#  Totale 18 celle. A ~7 min/cella misurati: circa 2 ore.
#
#  ORDINE DI RINUNCIA se il tempo macchina e' poco: prima il 6, poi il
#  5, poi il 4. IL PASSO 3 NON SI SALTA MAI: e' quello che risponde alla
#  domanda del round.
#
#  DOVE: sul PC di BACKTEST, con MT5 CHIUSO. MAI SUL VPS.
#  UNA MACCHINA, UN LAVORO: c'e' un solo MT5, niente in parallelo.
#
#  PRIMA SEMPRE IL GIRO A VUOTO (-SoloControllo): non apre MT5, stampa
#  le celle e le anteprime .ini. Se una cella non produce l'anteprima
#  questo script esce 1 (un giro a vuoto che esce 0 e' un guard finto).
#
#  I CANARINI: tre celle di questo round rigirano una configurazione GIA'
#  MISURATA e devono ritrovarne i numeri AL CENTESIMO. Lo script li
#  confronta da solo e stampa CANARINO OK / CANARINO FALLITO. Se un
#  canarino fallisce, quella gamba NON SI LEGGE - e non si spiega dopo.
#
#  NOTA CULTURA INVARIANTE: nessun numero dei CSV viene convertito. Sono
#  stampati e confrontati come STRINGHE, esattamente come li scrive MT5
#  (su Windows in italiano un parse senza InvariantCulture leggerebbe
#  "2.0" come VENTI). L'unica conversione e' sulle DATE del PASSO 0.
# =====================================================================
param(
  [string]$Rif      = "lavoro",                             # commit SHA (o branch)
  [string]$Cartella = (Join-Path $env:USERPROFILE "r84bis"),
  [int]$Deposito    = 10000,
  [int]$Modello     = 4,                                    # 4 = tick reali. 1 = OHLC: SOLO screening, e va DICHIARATO
  [string]$Solo     = "",                                   # es. "T0,T1"
  [string]$Passo    = "",                                   # es. "3" oppure "1,2,3"
  [switch]$Rifai,
  [switch]$SoloControllo,
  [switch]$SaltaPassoZero
)
$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$Raw = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Rif"

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

Write-Host "=== R84-BIS - VALIDAZIONE DELLA CELLA D (riduttore di perdita) ===" -ForegroundColor Cyan
Write-Host ("MACCHINA: " + $env:COMPUTERNAME + "   utente: " + $env:USERNAME) -ForegroundColor Cyan
Write-Host ("riferimento: " + $Rif) -ForegroundColor DarkGray
Write-Host ("data      : " + (Get-Date -Format "yyyy-MM-dd HH:mm")) -ForegroundColor DarkGray

if (Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) {
  Muori ("MetaTrader e' APERTO. Chiudilo prima di lanciare, altrimenti escono 0 CSV." + "`n" +
         "    (e se sul PC sta girando un altro lavoro - HistData, Dukascopy, un altro" + "`n" +
         "     round - aspetta che finisca: c'e' un solo MT5)")
}

# =====================================================================
#  LE 18 CELLE
#
#  Spr = riga Spread dell'.ini:  -1 non la scrive (come tutti i round
#        fino al 18/08)  |  0 spread corrente dichiarato  |  N stress.
#  Fis = frazione IS del walk-forward (0,40 = come R83/R84).
#  Att = i numeri che una cella CANARINO deve ritrovare, presi dai CSV
#        gia' in archivio. Formato: "ISprofit|ISpf|ISn|OOSprofit|OOSpf|OOSn".
# =====================================================================
$celle = @(
  # --- passo 1: il canarino dello spread forzato -------------------
  @{ K="S3A"; P=1; EA="ABTG_Nasdaq_Apertura_US"; Sym="NASUSD"; File="R84a_base_NASUSD.txt";
     Tag="r84bs3a"; Mag=@("776010","776011"); Spr=400; Fis=0.40; Att="";
     Cosa="CANARINO C4: cella A con spread FORZATO a 400 pt (4,0 punti indice)" }

  # --- passo 2: il canarino di riproducibilita' --------------------
  @{ K="S0A"; P=2; EA="ABTG_Nasdaq_Apertura_US"; Sym="NASUSD"; File="R84a_base_NASUSD.txt";
     Tag="r84bs0a"; Mag=@("776010","776011"); Spr=0; Fis=0.40;
     Att="686.35|1.25367|156|-795.03|0.87315|291";
     Cosa="CANARINO C3: cella A con Spread=0 scritto (deve riprodurre R84)" }
  @{ K="S0D"; P=2; EA="ABTG_Nasdaq_Apertura_US"; Sym="NASUSD"; File="R84d_volatr_NASUSD.txt";
     Tag="r84bs0d"; Mag=@("776040","776041"); Spr=0; Fis=0.40;
     Att="858.34|1.51444|110|-287.19|0.92450|201";
     Cosa="CANARINO C3: cella D con Spread=0 scritto (deve riprodurre R84)" }

  # --- passo 3: TRASFERIBILITA' - la prova chiave -------------------
  @{ K="T0"; P=3; EA="ABTG_Apertura_3Ingressi"; Sym="D30EUR"; File="R83d0_stop_D30EUR.txt";
     Tag="r84bt0"; Mag=@("777110","777111"); Spr=-1; Fis=0.40;
     Att="203.66|1.04668|220|251.22|1.04089|325";
     Cosa="CANARINO C1: DAX breakout NUDO (baseline positiva di T1)" }
  @{ K="T1"; P=3; EA="ABTG_Apertura_3Ingressi"; Sym="D30EUR"; File="R84BIS_T1_volatr_D30EUR.txt";
     Tag="r84bt1"; Mag=@("776120","776121"); Spr=-1; Fis=0.40; Att="";
     Cosa="DAX breakout + CELLA D PIENA (volumi OR ATR) - la prova piu' informativa" }
  @{ K="T2"; P=3; EA="ABTG_DAX_Apertura_EU"; Sym="D30EUR"; File="R83v_vivo_D30EUR.txt";
     Tag="r84bt2"; Mag=@("777190","777191"); Spr=-1; Fis=0.40;
     Att="282.12|1.07810|197|999.42|1.18776|311";
     Cosa="CANARINO C2: DAX retest NUDO = la sedia viva 770101 (baseline di T3)" }
  @{ K="T3"; P=3; EA="ABTG_DAX_Apertura_EU"; Sym="D30EUR"; File="R84BIS_T3_volumi_D30EUR.txt";
     Tag="r84bt3"; Mag=@("776140","776141"); Spr=-1; Fis=0.40; Att="";
     Cosa="DAX retest + SOLA GAMBA VOLUMI (sul retest ATR e ConfirmMode sono INERTI)" }

  # --- passo 4: ROBUSTEZZA dei parametri ---------------------------
  @{ K="B1"; P=4; EA="ABTG_Nasdaq_Apertura_US"; Sym="NASUSD"; File="R84BIS_B1_volmult125_NASUSD.txt";
     Tag="r84bb1"; Mag=@("776150","776151"); Spr=-1; Fis=0.40; Att="";
     Cosa="vicino: InpVolMult 1,5 -> 1,25 (volumi piu' permissivi)" }
  @{ K="B2"; P=4; EA="ABTG_Nasdaq_Apertura_US"; Sym="NASUSD"; File="R84BIS_B2_volmult175_NASUSD.txt";
     Tag="r84bb2"; Mag=@("776160","776161"); Spr=-1; Fis=0.40; Att="";
     Cosa="vicino: InpVolMult 1,5 -> 1,75 (volumi piu' severi)" }
  @{ K="B3"; P=4; EA="ABTG_Nasdaq_Apertura_US"; Sym="NASUSD"; File="R84BIS_B3_atrmult090_NASUSD.txt";
     Tag="r84bb3"; Mag=@("776170","776171"); Spr=-1; Fis=0.40; Att="";
     Cosa="vicino: InpAtrFilterMult 1,0 -> 0,9 (ATR piu' permissivo)" }
  @{ K="B4"; P=4; EA="ABTG_Nasdaq_Apertura_US"; Sym="NASUSD"; File="R84BIS_B4_atrmult110_NASUSD.txt";
     Tag="r84bb4"; Mag=@("776180","776181"); Spr=-1; Fis=0.40; Att="";
     Cosa="vicino: InpAtrFilterMult 1,0 -> 1,1 (ATR piu' severo)" }

  # --- passo 5: SCALA DI SPREAD (A@400 e' gia' il canarino S3A) -----
  @{ K="S1A"; P=5; EA="ABTG_Nasdaq_Apertura_US"; Sym="NASUSD"; File="R84a_base_NASUSD.txt";
     Tag="r84bs1a"; Mag=@("776010","776011"); Spr=100; Fis=0.40; Att="";
     Cosa="scala spread: cella A a 100 pt (1,0 punto indice)" }
  @{ K="S2A"; P=5; EA="ABTG_Nasdaq_Apertura_US"; Sym="NASUSD"; File="R84a_base_NASUSD.txt";
     Tag="r84bs2a"; Mag=@("776010","776011"); Spr=200; Fis=0.40; Att="";
     Cosa="scala spread: cella A a 200 pt (2,0 punti indice)" }
  @{ K="S1D"; P=5; EA="ABTG_Nasdaq_Apertura_US"; Sym="NASUSD"; File="R84d_volatr_NASUSD.txt";
     Tag="r84bs1d"; Mag=@("776040","776041"); Spr=100; Fis=0.40; Att="";
     Cosa="scala spread: cella D a 100 pt (1,0 punto indice)" }
  @{ K="S2D"; P=5; EA="ABTG_Nasdaq_Apertura_US"; Sym="NASUSD"; File="R84d_volatr_NASUSD.txt";
     Tag="r84bs2d"; Mag=@("776040","776041"); Spr=200; Fis=0.40; Att="";
     Cosa="scala spread: cella D a 200 pt (2,0 punti indice)" }
  @{ K="S3D"; P=5; EA="ABTG_Nasdaq_Apertura_US"; Sym="NASUSD"; File="R84d_volatr_NASUSD.txt";
     Tag="r84bs3d"; Mag=@("776040","776041"); Spr=400; Fis=0.40; Att="";
     Cosa="scala spread: cella D a 400 pt (4,0 punti indice)" }

  # --- passo 6: SPLIT alternativo ----------------------------------
  @{ K="W1"; P=6; EA="ABTG_Nasdaq_Apertura_US"; Sym="NASUSD"; File="R84a_base_NASUSD.txt";
     Tag="r84bw1"; Mag=@("776010","776011"); Spr=-1; Fis=0.55; Att="";
     Cosa="split 55/45: cella A (il totale NON cambia, cambia la decomposizione)" }
  @{ K="W2"; P=6; EA="ABTG_Nasdaq_Apertura_US"; Sym="NASUSD"; File="R84d_volatr_NASUSD.txt";
     Tag="r84bw2"; Mag=@("776040","776041"); Spr=-1; Fis=0.55; Att="";
     Cosa="split 55/45: cella D (regge la coerenza fra le meta' al nuovo confine?)" }
)

# --- selezione: -Passo prima, -Solo dopo (si possono combinare)
if ($Passo -ne "") {
  $pp = @()
  foreach ($s in ($Passo -split ",")) { $pp += [int]$s.Trim() }
  $celle = @($celle | Where-Object { $pp -contains $_.P })
  if ($celle.Count -eq 0) { Muori "il filtro -Passo '$Passo' non seleziona nessuna cella (validi: 1 2 3 4 5 6)." }
  Write-Host ("  -Passo attivo: " + ($pp -join ", ")) -ForegroundColor Yellow
}
if ($Solo -ne "") {
  $scelti = @()
  foreach ($s in ($Solo -split ",")) { $scelti += $s.Trim().ToUpper() }
  $celle = @($celle | Where-Object { $scelti -contains $_.K })
  if ($celle.Count -eq 0) { Muori "il filtro -Solo '$Solo' non seleziona nessuna cella." }
  Write-Host ("  -Solo attivo: giro solo " + (($celle | ForEach-Object { $_.K }) -join ", ")) -ForegroundColor Yellow
}

Write-Host ""
Write-Host ("  celle da girare: " + $celle.Count + "   modello: " + $Modello + "   deposito: " + $Deposito) -ForegroundColor White
Write-Host ("  stima a 7 min/cella: circa " + [math]::Round($celle.Count * 7 / 60.0, 1) + " ore") -ForegroundColor White
if ($Modello -ne 4) {
  Write-Host "  ATTENZIONE: NON stai girando a tick reali. Ogni numero di questa corsa" -ForegroundColor Yellow
  Write-Host "  va scritto con accanto 'OHLC, non tick'. L'illusione OHLC ha gia'" -ForegroundColor Yellow
  Write-Host "  revocato una promozione in questa casa (SupRev DOW H4)." -ForegroundColor Yellow
}

# =====================================================================
#  1. ATTREZZI (riscaricati sempre, mai la copia vecchia)
# =====================================================================
Titolo "1) attrezzi (riscaricati sempre, pinnati a $Rif)"
$Prove = Join-Path $Cartella "prove"
New-Item -ItemType Directory -Force -Path $Prove | Out-Null

$file = @{}
$file["walkforward_generico.ps1"] = "$Raw/backtest_pipeline/walkforward_generico.ps1"
$file["prove\R84BIS_VALIDAZIONE_D_CRITERI.md"] = "$Raw/backtest_pipeline/prove/R84BIS_VALIDAZIONE_D_CRITERI.md"
foreach ($c in $celle) { $file["prove\" + $c.File] = "$Raw/backtest_pipeline/prove/" + $c.File }

foreach ($k in $file.Keys) {
  $dest = Join-Path $Cartella $k
  Remove-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue
  try {
    Invoke-WebRequest -Uri $file[$k] -OutFile $dest -UseBasicParsing -ErrorAction Stop
    Write-Host ("    ok  " + $k) -ForegroundColor Green
  } catch {
    Muori ("non sono riuscito a scaricare " + $k + " da " + $Rif + "`n    " + $_.Exception.Message)
  }
}

# --- controllo di versione: e' il file NUOVO? (la cache di raw tiene ~5 minuti)
#     Ogni file prova deve contenere il marcatore del round da cui viene:
#     i file riusati sono di R83/R84 e NON hanno il marcatore R84BIS. E'
#     voluto: si riusano INVARIATI, e' il modo in cui i canarini sono
#     riproducibili per costruzione.
foreach ($c in $celle) {
  $p = Join-Path $Prove $c.File
  $ok = $false
  foreach ($mark in @("R84BIS", "R84 / ABLAZIONE", "R83 / DUELLO")) {
    if (Select-String -Path $p -SimpleMatch -Pattern $mark -Quiet) { $ok = $true }
  }
  if (-not $ok) { Muori ("il file prova " + $c.File + " non contiene nessun marcatore R84BIS/R84/R83: e' una copia sbagliata o vecchia.") }
}
$wf = Join-Path $Cartella "walkforward_generico.ps1"
if (-not (Select-String -Path $wf -SimpleMatch -Pattern "WALK-FORWARD GENERICO" -Quiet)) {
  Muori "walkforward_generico.ps1 scaricato non e' quello giusto (manca il marcatore)."
}
# --- e deve avere il -Spread, altrimenti la scala di stress esce SILENZIOSAMENTE
#     uguale alla base: e' il difetto n.14 (guard finto) applicato ai numeri.
$vuoleSpread = @($celle | Where-Object { $_.Spr -ge 0 }).Count
if ($vuoleSpread -gt 0 -and -not (Select-String -Path $wf -SimpleMatch -Pattern '$Spread' -Quiet)) {
  Muori ("il walkforward_generico.ps1 scaricato da '" + $Rif + "' NON ha il parametro -Spread." + "`n" +
         "    " + $vuoleSpread + " celle di questo round chiedono uno spread esplicito: senza quel" + "`n" +
         "    parametro girerebbero TUTTE alla base e la scala uscirebbe piatta - cioe' un" + "`n" +
         "    numero falso. Pinna un -Rif che contenga la modifica (o usa 'lavoro').")
}

Get-ChildItem -Path $Cartella -Filter "anteprima_*.ini" -ErrorAction SilentlyContinue | ForEach-Object {
  try { Remove-Item -LiteralPath $_.FullName -Force } catch {}
}

# =====================================================================
#  PASSO 0 - LA PROFONDITA' DEI TICK, MISURATA (difetto n.18)
#  Qui i simboli sono DUE (NASUSD e D30EUR) e vanno controllati tutti e
#  due: R83/R84 hanno gia' promosso il 2024.09.26 per entrambi, ma un
#  round che si fida di una promozione altrui e' un round che non
#  controlla.
# =====================================================================
$desk = Trova-Desktop
$CsvStorico = Join-Path $desk "storico_bcm\ABTG_StoricoScaricato.csv"
$simboli = @($celle | ForEach-Object { $_.Sym } | Select-Object -Unique)

if ($Modello -eq 4 -and -not $SaltaPassoZero) {
  Titolo ("0) PASSO 0 - profondita' dei TICK di " + ($simboli -join " e ") + " (misurata, non ipotizzata)")
  if (-not (Test-Path -LiteralPath $CsvStorico)) {
    Muori ("il referto della profondita' storica non c'e': " + $CsvStorico + "`n" +
           "    Lancialo PRIMA (MT5 chiuso), col timeout dimensionato sulla stima:`n" +
           "      powershell -ExecutionPolicy Bypass -File `"$PSScriptRoot\scarica_storico.ps1`" -Simboli `"" + ($simboli -join ",") + "`" -Da 2024.01.01 -TimeoutMin 180 -Auto`n" +
           "    Poi si LEGGONO le righe  <SIMBOLO>,TICK  (colonna PrimaDataLocale), NON le M1.`n" +
           "    Se i tick degli indici non esistono, si rilancia con -Modello 1 -SaltaPassoZero`n" +
           "    e OGNI numero porta scritto 'OHLC, non tick'.")
  }
  $righeStorico = @()
  try { $righeStorico = @(Import-Csv -LiteralPath $CsvStorico) } catch { Muori ("il referto storico non e' leggibile: " + $_.Exception.Message) }
  foreach ($sy in $simboli) {
    $rigaTick = @($righeStorico | Where-Object { $_.Simbolo -eq $sy -and $_.Timeframe -eq "TICK" })
    if ($rigaTick.Count -eq 0) { Muori ("nel referto " + $CsvStorico + " non c'e' la riga  " + $sy + ",TICK.") }
    $dataTick = ($rigaTick[0].PrimaDataLocale + "").Trim()
    Write-Host ("    riga misurata: " + $sy + ",TICK  barre/tick=" + $rigaTick[0].Barre + "  PrimaDataLocale=" + $dataTick) -ForegroundColor Gray
    if ($dataTick -eq "" -or $dataTick -eq "-") {
      Muori ("la colonna PrimaDataLocale della riga TICK di " + $sy + " e' vuota: i tick NON ci sono sul disco.")
    }
    # la finestra si legge DAL FILE PROVA di quel simbolo, non da qui
    $provaSy = @($celle | Where-Object { $_.Sym -eq $sy })[0].File
    $provaLocale = Join-Path $Prove $provaSy
    $daQuando = ""
    if (Test-Path -LiteralPath $provaLocale) {
      $m = Select-String -Path $provaLocale -Pattern '^@DAQUANDO\s+(\S+)'
      if ($m) { $daQuando = $m.Matches[0].Groups[1].Value }
    }
    if ($daQuando -eq "") { Write-Host "    (nessun @DAQUANDO leggibile: confronto saltato per $sy)" -ForegroundColor DarkYellow; continue }
    $inv = [Globalization.CultureInfo]::InvariantCulture
    $dT = $null; $dW = $null
    try { $dT = [datetime]::ParseExact($dataTick, "yyyy.MM.dd", $inv) } catch {}
    try { $dW = [datetime]::ParseExact($daQuando, "yyyy.MM.dd", $inv) } catch {}
    if ($dT -eq $null -or $dW -eq $null) {
      Write-Host ("    non riesco a confrontare le due date ('" + $dataTick + "' e '" + $daQuando + "'): controllale a mano.") -ForegroundColor Yellow
    } elseif ($dT -gt $dW) {
      Muori ("I TICK DI " + $sy + " PARTONO DOPO LA FINESTRA DEL ROUND.`n" +
             "    tick da  : " + $dataTick + "`n" +
             "    finestra : " + $daQuando + "`n" +
             "    Cosi' la prima parte della finestra e' VUOTA. Si riscrive il @DAQUANDO,`n" +
             "    si aggiornano i criteri, e SI RILANCIA.")
    } else {
      Write-Host ("    ok: i tick di " + $sy + " partono dal " + $dataTick + ", la finestra dal " + $daQuando + ".") -ForegroundColor Green
    }
  }
} elseif ($SaltaPassoZero) {
  Write-Host ""
  Write-Host "  -SaltaPassoZero: il controllo sulla profondita' dei tick E' STATO SALTATO." -ForegroundColor Yellow
  Write-Host "  Va detto in chat accanto ai risultati, altrimenti nessuno sa su che dati girano." -ForegroundColor Yellow
}

# =====================================================================
#  2. LE SERIE PER-TRADE VECCHIE DEI NOSTRI MAGIC
# =====================================================================
$Common = Join-Path $env:APPDATA "MetaQuotes\Terminal\Common\Files"
if ((-not $SoloControllo) -and (Test-Path $Common)) {
  $puliti = 0
  foreach ($c in $celle) {
    foreach ($m in $c.Mag) {
      $f = Join-Path $Common ("abtg_trades_" + $c.EA + "_" + $c.Sym + "_" + $m + ".csv")
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
$falliti = @()
$i = 0
foreach ($c in $celle) {
  $i++
  Titolo ("2." + $i + ") CELLA " + $c.K + " [passo " + $c.P + "] - " + $c.Cosa + "   [" + $c.Tag + "]")
  Write-Host ("      EA " + $c.EA + " | " + $c.Sym + " | prova " + $c.File) -ForegroundColor DarkGray
  $comeSpr = if ($c.Spr -lt 0) { "riga Spread ASSENTE (come R83/R84)" } elseif ($c.Spr -eq 0) { "Spread=0 (corrente, dichiarato)" } else { "Spread=" + $c.Spr + " punti (STRESS)" }
  Write-Host ("      " + $comeSpr + " | frazione IS " + $c.Fis) -ForegroundColor DarkGray

  $arg = @("-ExecutionPolicy","Bypass","-File",$wf,$c.EA,
           "-Prova",("prove\" + $c.File),
           "-Modello","$Modello",
           "-Deposito","$Deposito",
           "-FrazioneIS",("" + $c.Fis),
           "-Etichetta",$c.Tag)
  if ($c.Spr -ge 0)   { $arg += @("-Spread", ("" + $c.Spr)) }
  if ($SoloControllo) { $arg += "-SoloControllo" }
  if ($Rifai)         { $arg += "-Rifai" }

  $global:LASTEXITCODE = 0
  & powershell $arg
  if ($LASTEXITCODE -ne 0) {
    Write-Host ("    cella " + $c.K + " uscita con codice " + $LASTEXITCODE + ": vado avanti, la raccolta dira' cosa manca.") -ForegroundColor Yellow
    $falliti += $c.K
    continue
  }
  if ($SoloControllo) { continue }

  $Risultati = Join-Path $Cartella ("risultati_prove\" + $c.EA)
  if (Test-Path $Common) {
    foreach ($m in $c.Mag) {
      $f = Join-Path $Common ("abtg_trades_" + $c.EA + "_" + $c.Sym + "_" + $m + ".csv")
      if (Test-Path -LiteralPath $f) {
        New-Item -ItemType Directory -Force -Path $Risultati | Out-Null
        Copy-Item -LiteralPath $f -Destination (Join-Path $Risultati ("pertrade_" + $c.Tag + "_" + $m + ".csv")) -Force
        Write-Host ("    serie per-trade raccolta: magic " + $m) -ForegroundColor DarkGray
      }
    }
  }
}

# =====================================================================
#  4a. GIRO A VUOTO: il codice d'uscita DIPENDE dalle celle
# =====================================================================
if ($SoloControllo) {
  Titolo "3) ANTEPRIME PRODOTTE"
  $senzaAnteprima = @()
  foreach ($sy in $simboli) {
    foreach ($ea in @($celle | Where-Object { $_.Sym -eq $sy } | ForEach-Object { $_.EA } | Select-Object -Unique)) {
      $ant = Join-Path $Cartella ("anteprima_" + $ea + "_" + $sy + ".ini")
      Write-Host ""
      Write-Host ("    --- " + $ea + " / " + $sy + " ---") -ForegroundColor White
      if (-not (Test-Path -LiteralPath $ant)) {
        Write-Host "      (nessuna anteprima prodotta: qualcosa si e' fermato prima)" -ForegroundColor Red
        $senzaAnteprima += ($ea + "/" + $sy)
      } else {
        $chiavi = "^(InpEntryMode|InpRangeMode|InpBufferPoints|InpUseVolumeFilter|InpVolMult|InpUseAtrFilter|InpAtrFilterMult|InpConfirmMode|InpUseEmaFilter|InpUseSupertrend|InpUseCorrelation|InpUseNewsFilter|InpUseRoundLevels|InpRiskPercent|InpSessionHour|InpMagic)="
        foreach ($r in (Select-String -Path $ant -Pattern $chiavi)) { Write-Host ("      " + $r.Line) -ForegroundColor Gray }
        foreach ($r in (Select-String -Path $ant -Pattern "^(Symbol|Period|FromDate|ToDate|Spread)=")) { Write-Host ("      " + $r.Line) -ForegroundColor DarkGray }
      }
    }
  }
  Write-Host ""
  Write-Host "  Le righe qui sopra sono dell'ULTIMA cella girata a vuoto per quella coppia" -ForegroundColor Yellow
  Write-Host "  EA/simbolo. Il confronto cella per cella si fa sui file prova scaricati in:" -ForegroundColor Yellow
  Write-Host ("     " + $Prove) -ForegroundColor Yellow
  Write-Host "  CONTROLLO CHE VALE LA PENA FARE A MANO, e' due secondi:" -ForegroundColor Yellow
  Write-Host "     InpSessionHour deve essere 8 sul DAX e 14 sul Nasdaq (ORA SERVER)." -ForegroundColor Yellow
  Write-Host "     Se legge 9 o 15, la corsa e' da cestinare." -ForegroundColor Yellow
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
$nomeCartella = "R84BIS_VALIDAZIONE_D"
$dest = Join-Path $desk $nomeCartella
if (Test-Path $dest) { Remove-Item $dest -Recurse -Force -ErrorAction SilentlyContinue }
New-Item -ItemType Directory -Force -Path $dest | Out-Null

$suff = if ($Modello -eq 4) { "" } else { "_ohlc" }
$attesi = @()
foreach ($c in $celle) {
  $attesi += ($c.EA + "_" + $c.Sym + "_IS"  + $suff + "_" + $c.Tag + ".csv")
  $attesi += ($c.EA + "_" + $c.Sym + "_OOS" + $suff + "_" + $c.Tag + ".csv")
}

foreach ($ea in @($celle | ForEach-Object { $_.EA } | Select-Object -Unique)) {
  $Risultati = Join-Path $Cartella ("risultati_prove\" + $ea)
  if (Test-Path $Risultati) {
    foreach ($f in (Get-ChildItem $Risultati -Filter "*r84b*.csv" -ErrorAction SilentlyContinue)) {
      try { Copy-Item -LiteralPath $f.FullName -Destination (Join-Path $dest $f.Name) -Force } catch { Write-Host ("    non copiato: " + $f.Name) -ForegroundColor Yellow }
    }
  }
}
foreach ($c in $celle) { try { Copy-Item -LiteralPath (Join-Path $Prove $c.File) -Destination $dest -Force } catch {} }
try { Copy-Item -LiteralPath (Join-Path $Prove "R84BIS_VALIDAZIONE_D_CRITERI.md") -Destination $dest -Force } catch {}

Write-Host ""
Write-Host "    FILE ATTESI (controllali uno per uno):" -ForegroundColor White
$mancanti = 0
foreach ($a in $attesi) {
  if (Test-Path (Join-Path $dest $a)) { Write-Host ("      OK      " + $a) -ForegroundColor Green }
  else { Write-Host ("      MANCA  " + $a) -ForegroundColor Red; $mancanti++ }
}
$nPerTrade = @(Get-ChildItem $dest -Filter "pertrade_r84b*.csv" -ErrorAction SilentlyContinue).Count
Write-Host ("      (serie per-trade raccolte: " + $nPerTrade + " - sono della SOLA finestra OOS, l'IS viene sovrascritta)") -ForegroundColor DarkGray

# =====================================================================
#  5. TABELLA + CANARINI - solo stringhe, NESSUN parse numerico
# =====================================================================
Titolo "4) tabella (letta dai CSV, campi NON convertiti)"
Write-Host ("  {0,-4} {1,-3} {2,-4} {3,14} {4,10} {5,9} {6,7} {7,8}  {8}" -f "cella","pas","fin.","Profit","PF","DD %","trades","spread","magic") -ForegroundColor White
$canariniFalliti = @()
foreach ($c in $celle) {
  $letti = @{}
  $spr = if ($c.Spr -lt 0) { "assente" } else { "" + $c.Spr }
  foreach ($w in @("IS","OOS")) {
    $csv = Join-Path $dest ($c.EA + "_" + $c.Sym + "_" + $w + $suff + "_" + $c.Tag + ".csv")
    if (-not (Test-Path -LiteralPath $csv)) {
      Write-Host ("  {0,-4} {1,-3} {2,-4} {3}" -f $c.K, $c.P, $w, "CSV MANCANTE") -ForegroundColor Red
      continue
    }
    $righe = @()
    try { $righe = @(Import-Csv -LiteralPath $csv) } catch { }
    if ($righe.Count -eq 0) {
      Write-Host ("  {0,-4} {1,-3} {2,-4} {3}" -f $c.K, $c.P, $w, "ZERO PASSATE (solo intestazione)") -ForegroundColor Red
      continue
    }
    foreach ($r in $righe) {
      Write-Host ("  {0,-4} {1,-3} {2,-4} {3,14} {4,10} {5,9} {6,7} {7,8}  {8}" -f $c.K, $c.P, $w, $r.Profit, $r.'Profit Factor', $r.'Equity DD %', $r.Trades, $spr, $r.InpMagic) -ForegroundColor Gray
    }
    $letti[$w] = $righe[0]
    if ($righe.Count -eq 2) {
      if ($righe[0].Profit -ne $righe[1].Profit) {
        Write-Host ("      ATTENZIONE: le due passate gemelle della cella " + $c.K + " " + $w + " NON coincidono. Qualcosa e' rotto.") -ForegroundColor Red
      }
    } else {
      Write-Host ("      ATTENZIONE: " + $righe.Count + " righe invece di 2 (cache del tester? magic gia' usato?)") -ForegroundColor Red
    }
  }

  # --- IL CANARINO: confronto come STRINGHE con i numeri gia' in archivio
  if ($c.Att -ne "" -and $letti.ContainsKey("IS") -and $letti.ContainsKey("OOS")) {
    $a = $c.Att -split "\|"
    $vis = @(("" + $letti["IS"].Profit), ("" + $letti["IS"].'Profit Factor'), ("" + $letti["IS"].Trades),
             ("" + $letti["OOS"].Profit), ("" + $letti["OOS"].'Profit Factor'), ("" + $letti["OOS"].Trades))
    $diversi = @()
    for ($j = 0; $j -lt 6; $j++) { if ($vis[$j].Trim() -ne $a[$j].Trim()) { $diversi += ($a[$j] + " -> " + $vis[$j]) } }
    if ($diversi.Count -eq 0) {
      Write-Host ("      CANARINO OK: " + $c.K + " ha ritrovato i numeri in archivio al centesimo.") -ForegroundColor Green
    } else {
      Write-Host ("      CANARINO FALLITO su " + $c.K + ": " + ($diversi -join " ; ")) -ForegroundColor Red
      $canariniFalliti += $c.K
    }
  }
  if ($c.K -eq "S3A") {
    Write-Host "      (S3A e' il canarino C4: NON deve coincidere con la cella A di R84." -ForegroundColor Yellow
    Write-Host "       Se coincide, MT5 IGNORA la riga Spread a tick reali e la scala di" -ForegroundColor Yellow
    Write-Host "       stress NON E' ESEGUIBILE cosi': va dichiarato, non letto come" -ForegroundColor Yellow
    Write-Host "       'robusto allo spread'. Confronto: IS 686.35 / OOS -795.03.)" -ForegroundColor Yellow
  }
}

Write-Host ""
Write-Host "  I CRITERI SI LEGGONO PRIMA DELLA TABELLA: prove\R84BIS_VALIDAZIONE_D_CRITERI.md" -ForegroundColor Yellow
Write-Host "  Cancello T (decisivo, sul DAX): DD OOS giu' di almeno il 25% relativo," -ForegroundColor Yellow
Write-Host "  profitto totale conservato almeno all'85%, n totale almeno 150." -ForegroundColor Yellow
Write-Host "  Cancello R: almeno 2 vicini su 4 sopra PF totale 1,088." -ForegroundColor Yellow
Write-Host "  Cancello S: comparativo, D deve degradare MENO di A su 2 gradini su 3." -ForegroundColor Yellow
Write-Host "  Sotto 150 operazioni il MERITO e' sospeso; il RISCHIO si legge SEMPRE." -ForegroundColor Yellow
Write-Host "  E questa finestra contiene UN REGIME E MEZZO: nessun numero di qui e'" -ForegroundColor Yellow
Write-Host "  robusto, e NESSUNA cella va in forward da qui. Al massimo una riga di piano." -ForegroundColor Yellow

# =====================================================================
#  6. REFERTO + ZIP
# =====================================================================
$ref = @()
$ref += "REFERTO DI RACCOLTA - R84-BIS VALIDAZIONE DELLA CELLA D"
$ref += ("data: " + (Get-Date -Format "yyyy-MM-dd HH:mm"))
$ref += ("riferimento (commit/branch): " + $Rif)
$ref += ("macchina: " + $env:COMPUTERNAME + "   utente: " + $env:USERNAME)
$ref += ("deposito: " + $Deposito + "   modello: " + $Modello)
$ref += ("celle girate: " + (($celle | ForEach-Object { $_.K }) -join " "))
$ref += ("CSV attesi: " + $attesi.Count + "   mancanti: " + $mancanti)
$ref += ("serie per-trade raccolte: " + $nPerTrade + " (solo finestra OOS)")
$ref += ""
$ref += "RIGA SPREAD EFFETTIVA, CELLA PER CELLA (igiene nuova di R84-bis:"
$ref += "nessun round di questa casa produce piu' numeri con lo spread in"
$ref += "stato nascosto):"
foreach ($c in $celle) {
  $s = if ($c.Spr -lt 0) { "ASSENTE (MT5 usa il valore che ha in memoria)" } else { "Spread=" + $c.Spr }
  $ref += ("  " + $c.K + "  " + $c.Tag + "  " + $s + "   frazioneIS=" + $c.Fis)
}
$ref += ""
if ($Modello -ne 4)  { $ref += "ATTENZIONE: modello " + $Modello + " = NON tick reali. Ogni numero va letto come 'OHLC, non tick'." }
if ($SaltaPassoZero) { $ref += "ATTENZIONE: PASSO 0 SALTATO: la profondita' dei tick non e' stata verificata in questa corsa." }
if ($falliti.Count -gt 0)        { $ref += ("CELLE USCITE IN ERRORE: " + ($falliti -join " ")) }
if ($canariniFalliti.Count -gt 0){ $ref += ("CANARINI FALLITI: " + ($canariniFalliti -join " ") + "  -> quelle gambe NON SI LEGGONO.") }
$ref += ""
$ref += "La riga 'data:' qui sopra deve essere di ADESSO. Se e' vecchia, stai"
$ref += "guardando una raccolta precedente e non i file di questa corsa."
$ref | Set-Content -Path (Join-Path $dest "REFERTO_RACCOLTA_R84BIS.txt") -Encoding ASCII

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
if ($canariniFalliti.Count -gt 0) {
  Write-Host ("=== CANARINI FALLITI: " + ($canariniFalliti -join " ") + " ===") -ForegroundColor Red
  Write-Host "    Una gamba il cui canarino non riproduce l'archivio NON SI LEGGE." -ForegroundColor Red
  Write-Host "    Non si spiega a posteriori: si cerca la divergenza." -ForegroundColor Red
}
if ($mancanti -gt 0 -or $falliti.Count -gt 0) {
  Write-Host ("=== " + $mancanti + " CSV su " + $attesi.Count + " MANCANO. Guarda sopra qual e' stato l'errore. ===") -ForegroundColor Red
  Write-Host "    Si rilancia la STESSA riga: i CSV gia' fatti non si rifanno" -ForegroundColor Yellow
  Write-Host "    (per rifarli davvero serve -Rifai: senza, il driver li salta)." -ForegroundColor Yellow
  exit 1
} else {
  Write-Host ("=== TUTTI E " + $attesi.Count + " I CSV CI SONO. ===") -ForegroundColor Green
  Write-Host "    Questo round NON tocca il forward: nessuna sedia e' cambiata." -ForegroundColor Gray
}
if ($canariniFalliti.Count -gt 0) { exit 1 }
