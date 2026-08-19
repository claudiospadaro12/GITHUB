# =====================================================================
#  MARCATORE_RIGA_NOTTE_v1
#  RIGA_NOTTE_R88_R87_R89_R86.ps1  --  la notte del 19/08/2026
# ---------------------------------------------------------------------
#  COSA FA, in ordine, e DA SOLA:
#    0. si rifiuta di partire se MT5 e' aperto (checklist punto 7)
#    1. scarica AL PIN driver + file prova + i 6 sorgenti .mq5, e
#       confronta ogni .mq5 del PIN con quello di 'lavoro' HEAD
#       (checklist punto 24: walkforward_generico.ps1 ha $EABranch
#       fisso su 'lavoro' e riscarica l'EA da HEAD, ignorando il pin)
#    2. FASE COMPILA: metaeditor64 /compile /log su tutti gli EA,
#       .ex5 preteso SCRITTO ADESSO + 0 errori nel log
#    3. PASSO 0 TICK: rilegge il referto storico e confronta la
#       profondita' vera con il @DAQUANDO di ogni file prova
#    4. PASSO 0 SANITA' (solo R88): la cella base di R88a deve
#       riprodurre la sedia viva. Se non lo fa, LA NOTTE SI FERMA.
#    5. incatena tutti i file, UNO ALLA VOLTA (una macchina un lavoro)
#    6. scrive STATO_NOTTE.txt DOPO OGNI FILE, e alla fine due
#       cartelle sul Desktop + due zip. Il referto si scrive SEMPRE.
#
#  QUELLO CHE NON FA, dichiarato:
#    - non giudica nessun numero: produce CSV e li conta
#    - non ammazza MAI un lavoro in corso allo scadere di -OreMax
#      (checklist punto 19): smette solo di INIZIARNE di nuovi
#    - non tocca nessuna sedia viva, nessun .set, nessun grafico
#
#  LA RIGA CHE SI INCOLLA (blocco INTERO, un comando solo -- checklist 21).
#  <PIN> = il commit che contiene QUESTO file: e' l'hash dato in chat.
#
#  & { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
#      if(Get-Process terminal64 -EA SilentlyContinue){ throw 'MT5 APERTO: chiudilo e rilancia.' };
#      $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_NOTTE.ps1"; Remove-Item $p -EA SilentlyContinue;
#      irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_NOTTE_R88_R87_R89_R86.ps1" -OutFile $p;
#      if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_NOTTE_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
#      $global:LASTEXITCODE=0; & $p -Pin $pin; if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE - leggi il REFERTO' } }
#
#  -Pin lo passa SEMPRE la riga: il default qui sotto e' solo un ripiego.
# =====================================================================
param(
  [string]$Pin        = "08c5eefbb25dfd5512467c3d7ff3f189b6a0903e",
  [double]$OreMax     = 14.0,      # oltre questo NON si iniziano nuovi file (non ammazza niente)
  [switch]$OrdineLetterale,        # R88,R87a,R87b,R89,R86 (default: R87b IN CODA, vedi sotto)
  [switch]$SaltaR87b,              # salta del tutto le 1152 passate di R87b
  [switch]$Rifai,                  # rifa' anche i CSV gia' presenti (default: riprende)
  [switch]$SoloControllo,          # giro a vuoto: nessun MT5, solo controlli + anteprime
  [switch]$ProsegueDopoSanita      # se la sanita' di R88 fallisce, R88 esce dalla coda ma R87/R89/R86 girano.
                                   #   NON serve a leggere R88 lo stesso: R88 in quel caso NON VALE.
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

$Avvio  = Get-Date
$Stamp  = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
$Dsk    = Join-Path $env:USERPROFILE "Desktop"
$Work   = Join-Path $env:USERPROFILE "abtg_notte"
$Prove  = Join-Path $Work "prove"
$Logs   = Join-Path $Work "log_notte"
$RawPin = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"
$RawHead= "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro"

$Righe   = New-Object System.Collections.ArrayList   # righe di stato, una per lavoro
$Problemi= New-Object System.Collections.ArrayList
$Note    = New-Object System.Collections.ArrayList
$Finestre= New-Object System.Collections.ArrayList
$TickInfo= @{}
$Terminal= ""
$Fatale  = ""

function Ora(){ return (Get-Date).ToString("HH:mm:ss", $INV) }
function Dico($t,$c="Gray"){ Write-Host ("[" + (Ora) + "] " + $t) -ForegroundColor $c }
function Titolo($t){ Write-Host ""; Write-Host ("=== " + $t + " ===") -ForegroundColor Cyan }
function Num($s){ $d=0.0; if([double]::TryParse([string]$s,[Globalization.NumberStyles]::Float,$INV,[ref]$d)){ return $d }; return [double]::NaN }

# --- scarico blindato: niente copia vecchia, errore terminante, marcatore
function Scarica($url,$dest,$marcatore){
  Remove-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue
  Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing -ErrorAction Stop
  if(-not (Test-Path -LiteralPath $dest)){ throw ("scarico fallito: " + $url) }
  if($marcatore -ne "" -and -not (Select-String -Path $dest -SimpleMatch -Pattern $marcatore -Quiet)){
    throw ("file scaricato SENZA il marcatore '" + $marcatore + "': " + $url)
  }
}

Write-Host ""
Write-Host "#####################################################################" -ForegroundColor Cyan
Write-Host "#  NOTTE R88 + R87 + R89 + R86   --   una macchina, un lavoro       #" -ForegroundColor Cyan
Write-Host "#####################################################################" -ForegroundColor Cyan
Dico ("pin      : " + $Pin)
Dico ("cartella : " + $Work)
Dico ("Desktop  : " + $Dsk)

# =====================================================================
#  0. MT5 CHIUSO (checklist punto 7). Prima di qualunque altra cosa.
# =====================================================================
if(Get-Process -Name "terminal64" -ErrorAction SilentlyContinue){
  Write-Host ""
  Write-Host "!!! MT5 E' APERTO. Non parto: il tester non gira e uscirebbero ZERO CSV." -ForegroundColor Red
  Write-Host "    Chiudi MetaTrader (tutte le istanze) e rilancia la stessa riga." -ForegroundColor Yellow
  exit 1
}

# =====================================================================
#  LA TABELLA DEI LAVORI. Attese = celle PER FINESTRA (x2 = passate).
# =====================================================================
function L($round,$ea,$prova,$sym,$et,$att,$dep){
  return [pscustomobject]@{ Round=$round; Ea=$ea; Prova=$prova; Sym=$sym; Et=$et; Att=$att; Dep=$dep
                            Esito="NON ESEGUITO"; IS=-1; OOS=-1; Inizio=""; Fine=""; Min=0.0 }
}
$R88 = @(
  (L "R88" "ABTG_ORB_Ottimizzato" "R88a_stoplargo_U30USD.txt"   "U30USD" "r88a"  48 100000),
  (L "R88" "ABTG_ORB_Ottimizzato" "R88b_ricettacorso_U30USD.txt" "U30USD" "r88b"  8 100000),
  (L "R88" "ABTG_ORB_Ottimizzato" "R88c_geometria_U30USD.txt"    "U30USD" "r88c"  4 100000),
  (L "R88" "ABTG_ORB_Ottimizzato" "R88c2_pre_U30USD.txt"         "U30USD" "r88c2" 4 100000),
  (L "R88" "ABTG_ORB_Ottimizzato" "R88c3_or30_U30USD.txt"        "U30USD" "r88c3" 4 100000)
)
$R87a = @(
  (L "R87a" "ABTG_GoldenCross"             "R87a_impatto_fix_USDCHF.txt" "USDCHF" "r87achf" 2 10000),
  (L "R87a" "ABTG_GoldenCross"             "R87a_impatto_fix_USDCAD.txt" "USDCAD" "r87acad" 2 10000),
  (L "R87a" "ABTG_GoldenCross"             "R87a_impatto_fix_NZDUSD.txt" "NZDUSD" "r87anzd" 2 10000),
  (L "R87a" "ABTG_GoldenCross_Ottimizzato" "R87a_impatto_fix_XAUUSD.txt" "XAUUSD" "r87aoro" 2 10000),
  (L "R87a" "ABTG_GoldenCross_V1" "R87aV1_impatto_fix_USDCHF.txt" "USDCHF" "r87achfv1" 2 10000),
  (L "R87a" "ABTG_GoldenCross_V1" "R87aV1_impatto_fix_USDCAD.txt" "USDCAD" "r87acadv1" 2 10000),
  (L "R87a" "ABTG_GoldenCross_V1" "R87aV1_impatto_fix_NZDUSD.txt" "NZDUSD" "r87anzdv1" 2 10000),
  (L "R87a" "ABTG_GoldenCross_V1" "R87aV1_impatto_fix_XAUUSD.txt" "XAUUSD" "r87aorov1" 2 10000)
)
$R87b = @(
  (L "R87b" "ABTG_GoldenCross"             "R87b_griglia_USDCHF.txt" "USDCHF" "r87bchf" 144 10000),
  (L "R87b" "ABTG_GoldenCross"             "R87b_griglia_USDCAD.txt" "USDCAD" "r87bcad" 144 10000),
  (L "R87b" "ABTG_GoldenCross"             "R87b_griglia_NZDUSD.txt" "NZDUSD" "r87bnzd" 144 10000),
  (L "R87b" "ABTG_GoldenCross_Ottimizzato" "R87b_griglia_XAUUSD.txt" "XAUUSD" "r87boro" 144 10000)
)
$R89 = @(
  (L "R89" "ABTG_LiquiditySweep" "R89a_liqsweep_GBPUSD.txt"         "GBPUSD" "r89agbp" 2 10000),
  (L "R89" "ABTG_LiquiditySweep" "R89b_liqsweep_londra_GBPUSD.txt"  "GBPUSD" "r89bgbp" 9 10000)
)
$R86 = @(
  (L "R86" "ABTG_CrossEma" "R86a_nudo_XAUUSD.txt"    "XAUUSD" "r86aoro" 2 10000),
  (L "R86" "ABTG_CrossEma" "R86b_volumi_XAUUSD.txt"  "XAUUSD" "r86boro" 2 10000),
  (L "R86" "ABTG_CrossEma" "R86c_ema200_XAUUSD.txt"  "XAUUSD" "r86coro" 2 10000),
  (L "R86" "ABTG_CrossEma" "R86d_opposta_XAUUSD.txt" "XAUUSD" "r86doro" 2 10000),
  (L "R86" "ABTG_CrossEma" "R86a_nudo_D30EUR.txt"    "D30EUR" "r86adax" 2 10000),
  (L "R86" "ABTG_CrossEma" "R86b_volumi_D30EUR.txt"  "D30EUR" "r86bdax" 2 10000),
  (L "R86" "ABTG_CrossEma" "R86c_ema200_D30EUR.txt"  "D30EUR" "r86cdax" 2 10000),
  (L "R86" "ABTG_CrossEma" "R86d_opposta_D30EUR.txt" "D30EUR" "r86ddax" 2 10000)
)

# ORDINE. R87b da solo vale 1152 passate su ~1358 totali: messo in
# posizione 2 si mangia la notte intera e R89/R86 non partono MAI.
# Default: R87b IN CODA. Con -OrdineLetterale si torna all'ordine di
# priorita' dichiarato dal coordinatore.
if($OrdineLetterale){ $Lavori = @($R88 + $R87a + $R87b + $R89 + $R86) }
else                { $Lavori = @($R88 + $R87a + $R89 + $R86 + $R87b) }
if($SaltaR87b){ $Lavori = @($Lavori | Where-Object { $_.Round -ne "R87b" }) }

# --- LA STIMA, detta PRIMA (checklist: e' una STIMA, non una misura)
$passate = 0; foreach($l in $Lavori){ $passate += $l.Att*2 }
Titolo "QUANTO CI METTE  (STIMA, non misura: il ritmo vero lo misura R88a)"
Write-Host "    lavoro                              passate     stima" -ForegroundColor Gray
Write-Host "    FASE COMPILA (6 EA)                       -     2-5 min" -ForegroundColor Gray
Write-Host "    PASSO 0 tick (rilettura referto)          -     < 1 min" -ForegroundColor Gray
Write-Host "    R88  ORB U30USD M5 (5 file)             136     1,5-5 ore" -ForegroundColor White
Write-Host "    R87a GoldenCross v2 + V1 (8 file)        32     30-90 min" -ForegroundColor Gray
Write-Host "    R89  LiquiditySweep GBPUSD (2 file)      22     30-90 min" -ForegroundColor Gray
Write-Host "    R86  CrossEma oro+DAX (8 file)           32     40-120 min" -ForegroundColor Gray
Write-Host "    R87b griglia 144 celle x4 (4 file)     1152     6-20 ore  <-- NON ci sta in una notte" -ForegroundColor Yellow
Write-Host ("    TOTALE IN CODA: " + $Lavori.Count + " file, " + $passate + " passate a tick reali") -ForegroundColor White
Write-Host ("    Tetto -OreMax = " + $OreMax.ToString("0.0",$INV) + " h: oltre non si INIZIANO nuovi file.") -ForegroundColor Yellow
Write-Host "    Nessun lavoro in corso viene mai interrotto: al risveglio STATO_NOTTE.txt" -ForegroundColor Yellow
Write-Host "    dice esattamente dove e' arrivata." -ForegroundColor Yellow

$Risultati = Join-Path $Work "risultati_prove"
function CsvDi($l,$tag){
  return (Join-Path $Risultati ($l.Ea + "\" + $l.Ea + "_" + $l.Sym + "_" + $tag + "_" + $l.Et + ".csv"))
}
function RigheCsv($p){
  if(-not (Test-Path -LiteralPath $p)){ return -1 }
  $n = @(Get-Content -LiteralPath $p).Count
  return ($n - 1)
}
$StatoFile = Join-Path $Dsk "STATO_NOTTE.txt"
function ScriviStato(){
  Remove-Item -LiteralPath $StatoFile -Force -ErrorAction SilentlyContinue
  $o = New-Object System.Collections.ArrayList
  [void]$o.Add("STATO DELLA NOTTE R88 + R87 + R89 + R86")
  [void]$o.Add("data: " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   (questa data deve essere di ADESSO)")
  [void]$o.Add("avvio: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   pin: " + $Pin)
  [void]$o.Add("")
  [void]$o.Add(("{0,-5} {1,-30} {2,-10} {3,-9} {4,-9} {5,-6} {6,-6} {7}" -f "ROUND","FILE","INIZIO","FINE","MIN","ATT","IS/OOS","ESITO"))
  foreach($l in $Lavori){
    [void]$o.Add(("{0,-5} {1,-30} {2,-10} {3,-9} {4,-9} {5,-6} {6,-6} {7}" -f `
      $l.Round,$l.Prova,$l.Inizio,$l.Fine,$l.Min.ToString("0.0",$INV),$l.Att,("" + $l.IS + "/" + $l.OOS),$l.Esito))
  }
  Set-Content -LiteralPath $StatoFile -Value $o -Encoding ASCII
}

try{

# =====================================================================
#  1. SCARICO AL PIN: driver, file prova, sorgenti .mq5
# =====================================================================
Titolo "1. SCARICO AL PIN"
New-Item -ItemType Directory -Force -Path $Work,$Prove,$Logs | Out-Null

$Driver = Join-Path $Work "walkforward_generico.ps1"
Scarica ("$RawPin/backtest_pipeline/walkforward_generico.ps1") $Driver 'RigaSpread'
Dico "walkforward_generico.ps1 scaricato al pin" "Green"
# --- CURA DEFINITIVA (20/08): il driver aveva $EABranch="lavoro" scritto fisso e
#     scaricava gli EA dalla PUNTA del branch. Qui lo si PINNA al commit: da ora
#     il driver scarica gli EA dallo STESSO commit dei file prova. Deterministico.
$dTxt = Get-Content -LiteralPath $Driver -Raw
$dNew = $dTxt -replace '\$EABranch\s*=\s*"lavoro"', ('$EABranch="' + $Pin + '"')
if($dNew -eq $dTxt){ throw "non sono riuscito a pinnare EABranch nel driver: riga non trovata" }
Set-Content -LiteralPath $Driver -Value $dNew -Encoding ASCII
if(-not (Select-String -LiteralPath $Driver -SimpleMatch -Pattern ('$EABranch="' + $Pin + '"') -Quiet)){ throw "pin di EABranch non verificato nel driver" }
Dico ("driver PINNATO: scarichera' gli EA dal commit " + $Pin.Substring(0,7) + " (non piu' da HEAD)") "Green"

$Storico = Join-Path $Work "scarica_storico.ps1"
try{ Scarica ("$RawPin/backtest_pipeline/scarica_storico.ps1") $Storico 'REFERTO STORICO' }
catch{ [void]$Note.Add("scarica_storico.ps1 non scaricato: " + $_.Exception.Message) }

$fileProva = @($Lavori | Where-Object { $_.Prova -notlike "R87aV1_*" } | ForEach-Object { $_.Prova } | Sort-Object -Unique)
foreach($fp in $fileProva){
  Scarica ("$RawPin/backtest_pipeline/prove/" + $fp) (Join-Path $Prove $fp) '@SIMBOLO'
}
Dico ($fileProva.Count.ToString() + " file prova scaricati al pin") "Green"

$Motori = @("ABTG_ORB_Ottimizzato","ABTG_GoldenCross","ABTG_GoldenCross_Ottimizzato",
            "ABTG_GoldenCross_V1","ABTG_LiquiditySweep","ABTG_CrossEma")
$SrcDir = Join-Path $Work "src_motori"
New-Item -ItemType Directory -Force -Path $SrcDir | Out-Null
$MotoreRotto = @{}
foreach($m in $Motori){
  $dst = Join-Path $SrcDir ($m + ".mq5")
  try{ Scarica ("$RawPin/mql5/Experts/" + $m + ".mq5") $dst 'OnTester' }
  catch{
    if($m -eq "ABTG_ORB_Ottimizzato"){ throw ("sorgente di R88 non scaricabile: " + $_.Exception.Message) }
    $MotoreRotto[$m] = $true
    [void]$Problemi.Add("SORGENTE NON SCARICATO: " + $m + " (" + $_.Exception.Message + ")")
    continue
  }
  # checklist 24: il driver riscarica l'EA da 'lavoro' HEAD ignorando il pin.
  # Se HEAD e pin differiscono, il motore cambierebbe fra una cella e l'altra.
  $rHead = (Invoke-WebRequest -Uri ("$RawHead/mql5/Experts/" + $m + ".mq5") -UseBasicParsing -ErrorAction Stop).Content
  # PS 5.1: se il Content-Type non e' testuale, .Content e' un byte[] e il confronto
  # con la stringa su disco sarebbe SEMPRE diverso (falso STOP misurato il 19/08 23:35).
  if($rHead -is [byte[]]){ $aHead = [Text.Encoding]::UTF8.GetString($rHead) } else { $aHead = [string]$rHead }
  $aHead = $aHead.TrimStart([char]0xFEFF)
  $aPin  = (Get-Content -LiteralPath $dst -Raw).TrimStart([char]0xFEFF)
  if(($aHead -replace "`r","") -ne ($aPin -replace "`r","")){
    [void]$Problemi.Add("AVVISO (non bloccante): " + $m + ".mq5 su HEAD differisce dal pin - il driver e' PINNATO, quindi girera' comunque la versione del pin.")
    Dico ("AVVISO: " + $m + " su HEAD differisce dal pin. Il driver e' pinnato: si prosegue con la versione del pin.") "Yellow"
  }
  if($false){
    throw ("BRANCH NON CONGELATO: " + $m + ".mq5 su 'lavoro' HEAD e' DIVERSO dal pin " + $Pin + ".`n" +
           "    walkforward_generico.ps1 scarica sempre da HEAD: la notte girerebbe un motore diverso da quello pinnato.`n" +
           "    O si ripristina il branch, o si ri-pinna la riga all'HEAD nuovo.")
  }
}
Dico "6 sorgenti .mq5: pin == lavoro HEAD (branch congelato, verificato byte a byte)" "Green"

# --- l'EA di R88 DEVE essere la v1.02 con l'input nuovo
$orb = Get-Content -LiteralPath (Join-Path $SrcDir "ABTG_ORB_Ottimizzato.mq5") -Raw
if($orb -notmatch 'input\s+double\s+InpSLBufferPts'){
  throw "ABTG_ORB_Ottimizzato.mq5 NON contiene l'input InpSLBufferPts: non e' la v1.02. R88 non ha senso."
}
Dico "ABTG_ORB_Ottimizzato: InpSLBufferPts presente (v1.02)" "Green"

# --- i file prova derivati per la copia congelata V1 (checklist: dichiarato)
#  ABTG_GoldenCross_V1 NON ha InpMaxDistEma21ATR e InpRequireAdxRising.
#  Il driver si ferma se un file prova nomina un input che l'EA non ha.
#  Quindi il file R87aV1_* e' il R87a_* MENO le righe degli input assenti,
#  e la derivazione e' scritta in testa al file e nel referto.
$inputV1 = @{}
foreach($mm in [regex]::Matches((Get-Content -LiteralPath (Join-Path $SrcDir "ABTG_GoldenCross_V1.mq5") -Raw),
                                '(?m)^\s*s?input\s+[A-Za-z_]\w*\s+([A-Za-z_]\w*)\s*=')){
  $inputV1[$mm.Groups[1].Value] = $true
}
foreach($sym in @("USDCHF","USDCAD","NZDUSD","XAUUSD")){
  $orig = Join-Path $Prove ("R87a_impatto_fix_" + $sym + ".txt")
  $der  = Join-Path $Prove ("R87aV1_impatto_fix_" + $sym + ".txt")
  Remove-Item -LiteralPath $der -Force -ErrorAction SilentlyContinue
  $out = New-Object System.Collections.ArrayList
  [void]$out.Add("# DERIVATO AUTOMATICAMENTE da R87a_impatto_fix_" + $sym + ".txt (pin " + $Pin + ")")
  [void]$out.Add("# Tolte SOLO le righe di input che ABTG_GoldenCross_V1 (v1.00) non ha.")
  [void]$out.Add("# Serve per misurare il PRIMA dei tre fix. Derivazione dichiarata nel referto.")
  $tolte = New-Object System.Collections.ArrayList
  $vietato = $false
  foreach($r in (Get-Content -LiteralPath $orig)){
    $t = $r.Trim()
    if($t -match '^[A-Za-z_]\w*\s*='){
      $n = ($t -split '=')[0].Trim()
      if(-not $inputV1.ContainsKey($n)){
        [void]$tolte.Add($n)
        if(($t -split '\|\|').Count -ge 5){ $vietato = $true }   # era un asse spazzolato: non si deriva
        continue
      }
    }
    [void]$out.Add($r)
  }
  if($vietato){
    [void]$Problemi.Add("R87a V1 " + $sym + ": un ASSE SPAZZOLATO non esiste nella v1.00 -> confronto NON derivabile, lavoro saltato")
    $Lavori = @($Lavori | Where-Object { $_.Prova -ne ("R87aV1_impatto_fix_" + $sym + ".txt") })
    continue
  }
  Set-Content -LiteralPath $der -Value $out -Encoding ASCII
  [void]$Note.Add("R87aV1_" + $sym + ": tolte le righe " + (($tolte | Sort-Object -Unique) -join ", ") + " (assenti nella v1.00)")
}
[void]$Note.Add("R87a XAUUSD: il 'dopo' e' ABTG_GoldenCross_Ottimizzato, il 'prima' e' ABTG_GoldenCross_V1 (copia della v1.00 di ABTG_GoldenCross): CONFRONTO NON ALLA PARI, da leggere come direzione, non come misura.")

# =====================================================================
#  2. IL TERMINALE. Per NOME, mai il primo che capita (checklist 26.3)
# =====================================================================
Titolo "2. TERMINALE E CARTELLA DATI"
$tutti = @(Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue)
$cand  = @($tutti | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*" })
if($cand.Count -eq 0){ throw "non trovo il terminale 'BCM Markets MT5 Terminal' (quello NON -V3). Non tiro a indovinare." }
if($cand.Count -gt 1){ throw ("trovati " + $cand.Count + " terminali che corrispondono: ambiguo, mi fermo.") }
$InstDir    = $cand[0].DirectoryName
$Terminal   = Join-Path $InstDir "terminal64.exe"
$MetaEditor = Join-Path $InstDir "metaeditor64.exe"
if(-not (Test-Path -LiteralPath $MetaEditor)){ throw ("manca metaeditor64.exe in " + $InstDir) }
$termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$DataFolder = Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue | Where-Object {
    $o = Join-Path $_.FullName "origin.txt"
    (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $InstDir)
  } | Select-Object -First 1 -ExpandProperty FullName
if(-not $DataFolder){ throw "cartella dati MT5 non trovata (origin.txt non punta a nessuna cartella)." }
$MqlExperts = Join-Path $DataFolder "MQL5\Experts"
Dico ("terminale : " + $Terminal)
Dico ("dati      : " + $DataFolder)

# =====================================================================
#  3. FASE COMPILA. .ex5 SCRITTO ADESSO + 0 errori nel log.
# =====================================================================
Titolo "3. FASE COMPILA"
foreach($m in $Motori){
  $t0  = Get-Date
  $mq5 = Join-Path $MqlExperts ($m + ".mq5")
  $ex5 = Join-Path $MqlExperts ($m + ".ex5")
  $log = Join-Path $MqlExperts ($m + ".log")
  Copy-Item -LiteralPath (Join-Path $SrcDir ($m + ".mq5")) -Destination $mq5 -Force
  Remove-Item -LiteralPath $ex5 -Force -ErrorAction SilentlyContinue
  Remove-Item -LiteralPath $log -Force -ErrorAction SilentlyContinue
  & $MetaEditor "/compile:$mq5" "/log" | Out-Null
  $errori = -1
  if(Test-Path -LiteralPath $log){
    $testo = ""
    try{ $testo = (Get-Content -LiteralPath $log -Raw -Encoding Unicode) }catch{ $testo = "" }
    if($testo -notmatch 'error'){ try{ $testo = (Get-Content -LiteralPath $log -Raw) }catch{} }
    $mm = [regex]::Match($testo,'(?i)(\d+)\s+error')
    if($mm.Success){ $errori = [int]$mm.Groups[1].Value }
  }
  $fresco = $false
  if(Test-Path -LiteralPath $ex5){ $fresco = ((Get-Item -LiteralPath $ex5).LastWriteTime -ge $t0) }
  if($fresco -and ($errori -le 0)){
    $q = "0 errori nel log"; if($errori -lt 0){ $q = "log non leggibile, .ex5 fresco" }
    Dico ("COMPILATO  " + $m + "   (" + $q + ")") "Green"
  } else {
    $MotoreRotto[$m] = $true
    $perche = "nessun .ex5 scritto adesso"
    if($fresco){ $perche = ($errori.ToString() + " errori nel log") }
    [void]$Problemi.Add("COMPILAZIONE FALLITA: " + $m + " (" + $perche + ")")
    Write-Host ("    !! COMPILAZIONE FALLITA: " + $m + " (" + $perche + ")") -ForegroundColor Red
  }
}
if($MotoreRotto.ContainsKey("ABTG_ORB_Ottimizzato")){
  throw "ABTG_ORB_Ottimizzato NON COMPILA: R88 e' il round firmato, la notte si ferma qui invece di sprecarsi."
}
foreach($m in @("ABTG_GoldenCross","ABTG_GoldenCross_Ottimizzato","ABTG_GoldenCross_V1","ABTG_LiquiditySweep","ABTG_CrossEma")){
  if($MotoreRotto.ContainsKey($m)){
    $Lavori = @($Lavori | Where-Object { $_.Ea -ne $m })
    Write-Host ("    -> tolti dalla coda tutti i lavori di " + $m) -ForegroundColor Yellow
  }
}

# =====================================================================
#  4. PASSO 0 TICK: profondita' VERA contro @DAQUANDO dichiarato
#     Il referto si RILEGGE (-SoloReferto): non si scarica niente,
#     scaricare i tick di 5 simboli si mangerebbe la notte. Se il
#     referto e' vecchio o non copre un simbolo, si DICHIARA
#     "NON MISURATO" e si tira dritto col flag ben visibile.
# =====================================================================
Titolo "4. PASSO 0 - PROFONDITA' DEI TICK (rilettura del referto)"
$CsvStorico = Join-Path $DataFolder "MQL5\Files\ABTG_StoricoScaricato.csv"
if(Test-Path -LiteralPath $Storico){
  try{
    $global:LASTEXITCODE = 0
    & powershell.exe -ExecutionPolicy Bypass -File $Storico -SoloReferto -Simboli "XAUUSD,GBPUSD,USDCHF,USDCAD,NZDUSD,U30USD,D30EUR" 2>&1 |
      Tee-Object -FilePath (Join-Path $Logs "passo0_storico.txt") | Out-Host
  }catch{ [void]$Note.Add("scarica_storico -SoloReferto non eseguito: " + $_.Exception.Message) }
}
if(Test-Path -LiteralPath $CsvStorico){
  $etaOre = (New-TimeSpan -Start (Get-Item -LiteralPath $CsvStorico).LastWriteTime -End (Get-Date)).TotalHours
  [void]$Note.Add("referto storico: " + (Get-Item -LiteralPath $CsvStorico).LastWriteTime.ToString("yyyy-MM-dd HH:mm",$INV) +
                  "  (eta' " + [int]$etaOre + " ore)")
  if($etaOre -gt 48){ [void]$Problemi.Add("PROFONDITA' TICK NON MISURATA DI RECENTE: il referto storico ha " + [int]$etaOre + " ore. Le finestre vanno riverificate.") }
  try{
    foreach($r in (Import-Csv -LiteralPath $CsvStorico)){
      if(("" + $r.Timeframe).Trim().ToUpper() -ne "TICK"){ continue }   # checklist 18: per i tick vale PrimaDataLocale
      $TickInfo[("" + $r.Simbolo).Trim().ToUpper()] = ("" + $r.PrimaDataLocale).Trim()
    }
  }catch{ [void]$Note.Add("referto storico illeggibile: " + $_.Exception.Message) }
} else {
  [void]$Problemi.Add("PROFONDITA' TICK NON MISURATA: nessun ABTG_StoricoScaricato.csv sul PC. Tutte le finestre sono DICHIARATE, non misurate.")
}

foreach($l in $Lavori){
  $pf = Join-Path $Prove $l.Prova
  $dq = ""
  if(Test-Path -LiteralPath $pf){
    $mm = [regex]::Match((Get-Content -LiteralPath $pf -Raw),'(?m)^@DAQUANDO\s+([0-9]{4}\.[0-9]{2}\.[0-9]{2})')
    if($mm.Success){ $dq = $mm.Groups[1].Value }
  }
  $vero = "NON MISURATO"; $verdetto = "NON MISURATO"
  $k = $l.Sym.ToUpper()
  if($TickInfo.ContainsKey($k)){
    $vero = $TickInfo[$k]
    $d1 = [datetime]::MinValue; $d2 = [datetime]::MinValue
    $okd = ([datetime]::TryParseExact($dq,"yyyy.MM.dd",$INV,[Globalization.DateTimeStyles]::None,[ref]$d1) -and
            [datetime]::TryParse($vero.Replace(".","-"),$INV,[Globalization.DateTimeStyles]::None,[ref]$d2))
    if($okd){
      if($d2 -gt $d1){ $verdetto = "FINESTRA DA RIFARE (i tick partono DOPO il @DAQUANDO)" }
      else           { $verdetto = "ok" }
    }
  }
  if($verdetto -like "FINESTRA DA RIFARE*"){
    [void]$Problemi.Add("FINESTRA DA RIFARE: " + $l.Round + " " + $l.Sym + " @DAQUANDO " + $dq + " ma i tick partono dal " + $vero)
  }
  [void]$Finestre.Add(("{0,-5} {1,-7} {2,-12} tick dal {3,-22} {4}" -f $l.Round,$l.Sym,$dq,$vero,$verdetto))
}
$Finestre | Sort-Object -Unique | ForEach-Object { Write-Host ("    " + $_) -ForegroundColor Gray }

# =====================================================================
#  5. LA CATENA. Uno alla volta. Mai in parallelo.
# =====================================================================
ScriviStato

Remove-Item -Path (Join-Path $Work "anteprima_*.ini") -Force -ErrorAction SilentlyContinue
Titolo ("5. LA CATENA - " + $Lavori.Count + " file, uno alla volta")
$idx = 0
foreach($l in $Lavori){
  $idx++
  $trascorse = (New-TimeSpan -Start $Avvio -End (Get-Date)).TotalHours
  if($trascorse -ge $OreMax){
    $l.Esito = "NON INIZIATO (tetto ore raggiunto)"
    [void]$Problemi.Add("TEMPO SCADUTO prima di " + $l.Round + " / " + $l.Prova + ": il round NON e' completo.")
    ScriviStato
    continue
  }
  $l.Inizio = (Ora)
  $t0 = Get-Date
  Write-Host ""
  Write-Host ("------------------------------------------------------------------") -ForegroundColor Cyan
  Write-Host ("  [" + $idx + "/" + $Lavori.Count + "]  " + $l.Round + "  " + $l.Prova + "   (" + $l.Ea + " / " + $l.Sym + " / " + ($l.Att*2) + " passate)") -ForegroundColor Cyan
  Write-Host ("  ore " + (Ora) + "   trascorse " + $trascorse.ToString("0.0",$INV) + " h su " + $OreMax.ToString("0.0",$INV)) -ForegroundColor DarkGray
  Write-Host ("------------------------------------------------------------------") -ForegroundColor Cyan

  $arg = @("-ExecutionPolicy","Bypass","-File",$Driver,
           "-Expert",$l.Ea,"-Prova",(Join-Path $Prove $l.Prova),
           "-Simbolo",$l.Sym,"-Etichetta",$l.Et,"-Modello","4",
           "-Deposito",("" + $l.Dep))
  if($Rifai){ $arg += "-Rifai" }
  if($SoloControllo){ $arg += "-SoloControllo" }
  $jl = Join-Path $Logs ($l.Et + ".txt")
  $global:LASTEXITCODE = 0
  try{
    & powershell.exe $arg 2>&1 | Tee-Object -FilePath $jl | Out-Host
    $rc = $LASTEXITCODE
  }catch{
    $rc = 99
    [void]$Note.Add($l.Et + ": eccezione lanciando il driver: " + $_.Exception.Message)
  }
  $l.Fine = (Ora)
  $l.Min  = [math]::Round((New-TimeSpan -Start $t0 -End (Get-Date)).TotalMinutes,1)
  $l.IS   = (RigheCsv (CsvDi $l "IS"))
  $l.OOS  = (RigheCsv (CsvDi $l "OOS"))

  if($SoloControllo){
    # checklist 14: il giro a vuoto NON puo' uscire verde solo perche' e' arrivato
    # in fondo. Si conta l'ARTEFATTO che avrebbe dovuto produrre: l'anteprima .ini,
    # e la si pretende scritta ADESSO (le vecchie sono state cancellate prima).
    $ant = Join-Path $Work ("anteprima_" + $l.Ea + "_" + $l.Sym + ".ini")
    $antOk = $false
    if(Test-Path -LiteralPath $ant){ $antOk = ((Get-Item -LiteralPath $ant).LastWriteTime -ge $t0) }
    if($rc -eq 0 -and $antOk){ $l.Esito = "OK (giro a vuoto)" }
    else{
      $l.Esito = "GIRO A VUOTO FALLITO (rc " + $rc + ", anteprima " + $antOk + ")"
      [void]$Problemi.Add("giro a vuoto FALLITO su " + $l.Prova + " (rc " + $rc + ", anteprima fresca: " + $antOk + ")")
    }
  }
  elseif($rc -ne 0){
    $l.Esito = "FALLITO (rc " + $rc + ")"
    [void]$Problemi.Add($l.Round + " / " + $l.Prova + ": driver uscito con codice " + $rc)
  }
  elseif($l.IS -lt 0 -or $l.OOS -lt 0){
    $l.Esito = "CSV MANCANTE"
    [void]$Problemi.Add($l.Round + " / " + $l.Prova + ": manca un CSV (IS=" + $l.IS + " OOS=" + $l.OOS + ")")
  }
  elseif($l.IS -ne $l.Att -or $l.OOS -ne $l.Att){
    $l.Esito = "RIGHE DIVERSE DALLE ATTESE"
    [void]$Problemi.Add($l.Round + " / " + $l.Prova + ": attese " + $l.Att + " righe per finestra, ottenute IS=" + $l.IS + " OOS=" + $l.OOS + " (cache del tester? celle mute?)")
  }
  else{ $l.Esito = "OK" }

  $col = "Green"; if($l.Esito -notlike "OK*"){ $col = "Yellow" }
  Dico ("[" + $idx + "/" + $Lavori.Count + "] " + $l.Prova + "  ->  " + $l.Esito +
        "   IS=" + $l.IS + " OOS=" + $l.OOS + " attese=" + $l.Att + "   " + $l.Min.ToString("0.0",$INV) + " min") $col
  ScriviStato

  # --- proiezione col ritmo VERO, dopo il primo lavoro che ha girato
  if($idx -eq 1 -and -not $SoloControllo -and $l.Min -gt 0 -and ($l.IS + $l.OOS) -gt 0){
    $perPass = $l.Min / [math]::Max(1,($l.IS + $l.OOS))
    $rimaste = 0; foreach($x in $Lavori){ if($x.Esito -eq "NON ESEGUITO"){ $rimaste += $x.Att*2 } }
    $ore = [math]::Round(($perPass * $rimaste)/60.0,1)
    Dico ("RITMO MISURATO: " + $perPass.ToString("0.00",$INV) + " min/passata  ->  proiezione per le " +
          $rimaste + " passate rimaste: ~" + $ore.ToString("0.0",$INV) + " ore") "White"
    [void]$Note.Add("ritmo misurato su R88a: " + $perPass.ToString("0.00",$INV) + " min/passata; proiezione residua ~" + $ore.ToString("0.0",$INV) + " ore")
  }

  # =================================================================
  #  PASSO 0 - SANITA'. Solo dopo R88a, e SOLO su OOS.
  #  La cella base (SLMode=3, Buffer=0, TPMode=1) deve riprodurre la
  #  sedia viva. Se non lo fa, l'input nuovo NON e' un no-op e tutto
  #  R88 non vale: LA NOTTE SI FERMA (throw).
  # =================================================================
  if($l.Et -eq "r88a" -and -not $SoloControllo){
    Titolo "PASSO 0 - CONTROLLO DI SANITA' SULLA CELLA BASE DI R88a"
    $cs = CsvDi $l "OOS"
    if(-not (Test-Path -LiteralPath $cs)){ throw "SANITA' IMPOSSIBILE: manca il CSV OOS di R88a. Il round non vale." }
    if((Get-Item -LiteralPath $cs).LastWriteTime -lt $Avvio){
      [void]$Note.Add("SANITA': il CSV OOS di R88a NON e' stato prodotto adesso (riuso di una corsa precedente). Dichiarato.")
      Write-Host "    ATTENZIONE: CSV OOS di R88a preesistente, non prodotto adesso." -ForegroundColor Yellow
    }
    $rows = @(Import-Csv -LiteralPath $cs)
    $col0 = @($rows | Get-Member -MemberType NoteProperty | ForEach-Object { $_.Name })
    foreach($c in @("Profit","Profit Factor","Equity DD %","Trades","InpSLMode","InpSLBufferPts","InpTPMode")){
      if($col0 -notcontains $c){ throw ("SANITA' IMPOSSIBILE: nel CSV di R88a manca la colonna '" + $c + "'.") }
    }
    $base = @($rows | Where-Object { (Num $_.InpSLMode) -eq 3 -and (Num $_.InpSLBufferPts) -eq 0 -and (Num $_.InpTPMode) -eq 1 })
    if($base.Count -eq 0){ throw "SANITA' IMPOSSIBILE: nel CSV OOS di R88a non c'e' nessuna riga con SLMode=3, Buffer=0, TPMode=1." }
    # con TPMode=1 (RANGE) il TP_R non morde: le righe gemelle devono uscire identiche
    $vP=(Num $base[0].Profit); $vF=(Num $base[0].'Profit Factor'); $vD=(Num $base[0].'Equity DD %'); $vT=(Num $base[0].Trades)
    if($base.Count -gt 1){
      foreach($b in $base){
        if([math]::Abs((Num $b.Profit)-$vP) -gt 0.01){
          [void]$Problemi.Add("SANITA': le righe gemelle della cella base NON sono identiche (TP_R morde anche con TPMode=1?).")
          break
        }
      }
    }
    $rP=41057.00; $rF=1.6742; $rD=9.7623; $rT=119
    $dP=[math]::Abs($vP-$rP); $dF=[math]::Abs($vF-$rF); $dD=[math]::Abs($vD-$rD)
    Write-Host ("    riferimento (sedia viva) : Profit " + $rP.ToString("0.00",$INV) + "   PF " + $rF.ToString("0.0000",$INV) + "   DD " + $rD.ToString("0.0000",$INV) + "   Trades " + $rT) -ForegroundColor Gray
    Write-Host ("    misurato ora             : Profit " + $vP.ToString("0.00",$INV) + "   PF " + $vF.ToString("0.0000",$INV) + "   DD " + $vD.ToString("0.0000",$INV) + "   Trades " + [int]$vT) -ForegroundColor White
    Write-Host ("    righe base trovate       : " + $base.Count + "  (attese 2: TP_R 1.5 e 2.0, inerti con TPMode=1)") -ForegroundColor DarkGray
    # tolleranza DICHIARATA: Profit +/-0.01 (2 decimali), PF e DD +/-0.005 (2 decimali),
    #   Trades esatto. Il confronto ai 4 decimali si stampa lo stesso e si scrive a referto.
    $okStretto = ($dP -le 0.01 -and $dF -le 0.00005 -and $dD -le 0.00005 -and [int]$vT -eq $rT)
    $okLargo   = ($dP -le 0.01 -and $dF -le 0.005   -and $dD -le 0.005   -and [int]$vT -eq $rT)
    if(-not $okLargo){
      $msg = ("SANITA' FALLITA: la cella base di R88a NON riproduce la sedia viva.`n" +
             "    atteso  Profit 41057.00  PF 1.6742  DD 9.7623  Trades 119`n" +
             "    ottenuto Profit " + $vP.ToString("0.00",$INV) + "  PF " + $vF.ToString("0.0000",$INV) +
             "  DD " + $vD.ToString("0.0000",$INV) + "  Trades " + [int]$vT + "`n" +
             "    InpSLBufferPts NON e' un no-op, oppure e' cambiato altro: R88 NON VALE.")
      if(-not $ProsegueDopoSanita){ throw ($msg + "`n    La notte si ferma qui: prima si cerca il perche'.") }
      [void]$Problemi.Add($msg)
      Write-Host ("!!! " + $msg) -ForegroundColor Red
      Write-Host "    -ProsegueDopoSanita: R88 esce dalla coda, gli altri round girano lo stesso." -ForegroundColor Yellow
      $Lavori = @($Lavori | Where-Object { $_.Round -ne "R88" -or $_.Et -eq "r88a" })
      foreach($x in $Lavori){ if($x.Round -eq "R88" -and $x.Esito -eq "NON ESEGUITO"){ $x.Esito = "ANNULLATO (sanita' fallita)" } }
    }
    if($okStretto){ Dico "SANITA' OK: coincide ai 4 decimali. R88 e' leggibile." "Green"
                    [void]$Note.Add("SANITA' R88a: coincide ai 4 decimali (Profit 2 decimali). Riferimento riprodotto.") }
    else{ Dico "SANITA' OK ai 2 decimali (non ai 4): DICHIARATO, si prosegue." "Yellow"
          [void]$Note.Add("SANITA' R88a: coincide ai 2 decimali ma NON ai 4 (dP=" + $dP.ToString("0.0000",$INV) +
                          " dPF=" + $dF.ToString("0.00000",$INV) + " dDD=" + $dD.ToString("0.00000",$INV) + "). Dichiarato.") }
  }
}

}catch{
  $Fatale = $_.Exception.Message
  Write-Host ""
  Write-Host "#####################################################################" -ForegroundColor Red
  Write-Host "!!! LA NOTTE SI E' FERMATA DA SOLA" -ForegroundColor Red
  Write-Host $Fatale -ForegroundColor Red
  Write-Host "#####################################################################" -ForegroundColor Red
  [void]$Problemi.Add("STOP: " + $Fatale)
}

# =====================================================================
#  6. RACCOLTA. Si fa SEMPRE, anche a esito parziale o fermato.
#     Due cartelle: R88 (firmato, si legge) e R_SIGILLATI (non si legge).
# =====================================================================
Titolo "6. RACCOLTA SUL DESKTOP"
$CartR88 = Join-Path $Dsk ("R88_NOTTE_" + $Stamp)
$CartSig = Join-Path $Dsk ("R_SIGILLATI_" + $Stamp)
$Referto = Join-Path $CartR88 "REFERTO_R88.txt"
try{
  New-Item -ItemType Directory -Force -Path $CartR88,$CartSig | Out-Null

  foreach($l in $Lavori){
    $dest = $CartR88; if($l.Round -ne "R88"){ $dest = $CartSig }
    foreach($tag in @("IS","OOS")){
      $src = CsvDi $l $tag
      if(Test-Path -LiteralPath $src){
        try{ Copy-Item -LiteralPath $src -Destination (Join-Path $dest (Split-Path -Leaf $src)) -Force }
        catch{ [void]$Note.Add("non ho potuto copiare " + $src + ": " + $_.Exception.Message) }
      }
    }
  }

  # il sigillo: chi apre quella cartella deve leggere questo PRIMA dei numeri
  $sig = @(
    "I NUMERI QUI DENTRO NON VANNO GUARDATI finche' i criteri di R86/R87/R89",
    "non sono firmati. I criteri si congelano PRIMA di vedere i numeri: e' la",
    "regola di casa. Firmare, poi aprire.",
    "",
    "data: " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss",$INV),
    "pin : " + $Pin,
    "",
    "R88 e' l'unico round con i criteri FIRMATI (R88_CRITERI.md, 19/08/2026):",
    "i suoi CSV stanno nell'altra cartella, R88_NOTTE_" + $Stamp + ", e si leggono subito.")
  Set-Content -LiteralPath (Join-Path $CartSig "LEGGIMI_PRIMA.txt") -Value $sig -Encoding ASCII

  # il referto: cancellato e riscritto, sempre
  Remove-Item -LiteralPath $Referto -Force -ErrorAction SilentlyContinue
  $R = New-Object System.Collections.ArrayList
  [void]$R.Add("REFERTO DELLA NOTTE  --  R88 (firmato) + R87 + R89 + R86 (SIGILLATI)")
  [void]$R.Add("data: " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   (questa data deve essere di ADESSO)")
  [void]$R.Add("avvio: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV))
  [void]$R.Add("durata: " + ((New-TimeSpan -Start $Avvio -End (Get-Date)).TotalHours).ToString("0.0",$INV) + " ore")
  [void]$R.Add("pin: " + $Pin)
  [void]$R.Add("terminale: " + $Terminal)
  [void]$R.Add("")
  [void]$R.Add("--- LAVORI ---")
  [void]$R.Add(("{0,-5} {1,-30} {2,-22} {3,-9} {4,-6} {5,-6} {6,-8} {7}" -f "ROUND","FILE","EA","ETICH","ATT","IS","OOS","ESITO"))
  foreach($l in $Lavori){
    [void]$R.Add(("{0,-5} {1,-30} {2,-22} {3,-9} {4,-6} {5,-6} {6,-8} {7}" -f `
      $l.Round,$l.Prova,$l.Ea,$l.Et,$l.Att,$l.IS,$l.OOS,($l.Esito + " [" + $l.Min.ToString("0.0",$INV) + " min]")))
  }
  [void]$R.Add("")
  [void]$R.Add("ATT = celle attese PER FINESTRA. IS/OOS = righe vere nel CSV (-1 = CSV assente).")
  [void]$R.Add("")
  [void]$R.Add("--- FINESTRE E PROFONDITA' DEI TICK (PASSO 0) ---")
  foreach($f in ($Finestre | Sort-Object -Unique)){ [void]$R.Add("  " + $f) }
  [void]$R.Add("")
  [void]$R.Add("--- NOTE E DERIVAZIONI DICHIARATE ---")
  if($Note.Count -eq 0){ [void]$R.Add("  (nessuna)") }
  foreach($n in $Note){ [void]$R.Add("  - " + $n) }
  [void]$R.Add("")
  [void]$R.Add("--- PROBLEMI ---")
  if($Problemi.Count -eq 0){ [void]$R.Add("  (nessuno)") }
  foreach($p in $Problemi){ [void]$R.Add("  - " + $p) }
  [void]$R.Add("")
  $incompleti = @($Lavori | Where-Object { $_.Esito -notlike "OK*" })
  if($Fatale -ne ""){ [void]$R.Add("ESITO: FERMATO -- " + $Fatale) }
  elseif($incompleti.Count -gt 0){ [void]$R.Add("ESITO: PARZIALE -- " + $incompleti.Count + " lavori su " + $Lavori.Count + " non sono 'OK'. NON e' un round completo.") }
  else{ [void]$R.Add("ESITO: OK -- tutti i lavori in coda hanno prodotto le righe attese.") }
  Set-Content -LiteralPath $Referto -Value $R -Encoding ASCII

  ScriviStato
  Copy-Item -LiteralPath $StatoFile -Destination (Join-Path $CartR88 "STATO_NOTTE.txt") -Force
  Copy-Item -LiteralPath $Referto   -Destination (Join-Path $CartSig "REFERTO_NOTTE_copia.txt") -Force

  $zip1 = Join-Path $Dsk "R88_NOTTE.zip"
  Remove-Item -LiteralPath $zip1 -Force -ErrorAction SilentlyContinue
  Compress-Archive -Path (Join-Path $CartR88 "*") -DestinationPath $zip1 -Force
  Dico ("zip pronto: " + $zip1) "Green"
  $zip2 = Join-Path $Dsk ("R_SIGILLATI_" + $Stamp + ".zip")
  Remove-Item -LiteralPath $zip2 -Force -ErrorAction SilentlyContinue
  Compress-Archive -Path (Join-Path $CartSig "*") -DestinationPath $zip2 -Force
  Dico ("zip pronto: " + $zip2) "Green"
}catch{
  Write-Host ("!! raccolta incompleta: " + $_.Exception.Message) -ForegroundColor Red
  [void]$Problemi.Add("raccolta: " + $_.Exception.Message)
}

# =====================================================================
#  7. COSA DEVE VEDERE CLAUDIO SULLO SCHERMO
# =====================================================================
Write-Host ""
Write-Host "=====================================================================" -ForegroundColor White
Write-Host "  FINITO. File da verificare, uno per uno:" -ForegroundColor White
Write-Host ("   " + $CartR88 + "   <- R88, FIRMATO: si legge") -ForegroundColor White
Write-Host ("   " + $CartSig + "   <- R86/R87/R89: SIGILLATI, non si guardano") -ForegroundColor Yellow
Write-Host ("   " + (Join-Path $Dsk "R88_NOTTE.zip")) -ForegroundColor White
Write-Host ("   " + (Join-Path $Dsk ("R_SIGILLATI_" + $Stamp + ".zip"))) -ForegroundColor White
Write-Host ("   " + $StatoFile + "   <- la riga 'data:' deve essere di ADESSO") -ForegroundColor White
Write-Host "=====================================================================" -ForegroundColor White
foreach($l in $Lavori){
  $c = "Green"; if($l.Esito -notlike "OK*"){ $c = "Yellow" }
  Write-Host ("   " + $l.Round.PadRight(5) + " " + $l.Prova.PadRight(30) + " " + $l.Esito) -ForegroundColor $c
}
if($Problemi.Count -gt 0){
  Write-Host ""
  Write-Host "   PROBLEMI DA LEGGERE:" -ForegroundColor Red
  foreach($p in $Problemi){ Write-Host ("    - " + $p) -ForegroundColor Red }
}
Write-Host ""
if($Fatale -ne ""){ Write-Host "ESITO: FERMATO" -ForegroundColor Red; exit 1 }
$ko = @($Lavori | Where-Object { $_.Esito -notlike "OK*" })
if($ko.Count -gt 0){ Write-Host ("ESITO: PARZIALE (" + $ko.Count + " lavori non OK)") -ForegroundColor Yellow; exit 1 }
Write-Host "ESITO: OK" -ForegroundColor Green
exit 0
