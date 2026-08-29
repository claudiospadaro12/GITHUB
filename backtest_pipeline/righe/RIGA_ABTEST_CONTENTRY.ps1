# =====================================================================
#  MARCATORE_RIGA_ABTEST_CONTENTRY_v1
#  RIGA_ABTEST_CONTENTRY.ps1  --  MISURA A/B del TIMING D'INGRESSO della
#     CONTINUAZIONE di ABTG_BreakingBand (v1.05).
#     GBPUSD, EURUSD, AUDUSD  su H1, tick reali, finestra 2020-2026.6.
#     L'unico parametro-strategia spazzato e' InpContEntryMode (0,1,2):
#        0 = PRIMO tocco storico (1.03)
#        1 = RETEST banda opposta (Leonardo p.4, 1.04)
#        2 = IN-BULGE di Claudio (1.05: primo-tocco-opposta + trend
#            mediana + candela direzionale + range)
#     Tutto il resto = la CELLA VIVA di R103 per ogni simbolo.
#
#  >>> QUESTO NON E' UN ROUND CHE PROMUOVE. E' UNA MISURA A/B. Non tocca
#      il forward, non tocca il .mq5, non taratura, non sceglie una cella.
#      Produce PF/DD/n per (mode x IS/OOS x simbolo) e li mette a referto.
# ---------------------------------------------------------------------
#  DA DOVE NASCE, dichiarato: e' RIGA_R108_BB_M15.ps1
#  (MARCATORE_RIGA_R108_v1) per l'ossatura -- guardie, gate, fabbrica di
#  .ini, parser del CSV di ottimizzazione, raccolta -- TOGLIENDO la
#  macchina M15/PASSO-0 (take-in-pip, durata-in-barre, passata singola,
#  cancello S0a) che qui NON serve, e TENENDO tutti i gate di casa:
#    -Pin senza default, [CmdletBinding()], guardia MT5 E MetaEditor
#    chiusi, cultura INVARIANTE, gate di versione sul .mq5 (marcatore dal
#    sorgente + InpContEntryMode input libero), gate dell'ANTENATO R103
#    sulla cella base, asse dichiarato (InpContEntryMode + InpMagic
#    gemelli, nient'altro), igiene GEMELLI (per mode), magic VERGINI,
#    compilazione DIRETTA con verdetto sul LastWriteTime del .ex5,
#    raccolta SEMPRE su Desktop + zip + referto, -SoloControllo che
#    scrive e VERIFICA gli .ini senza aprire MT5, exit ESPLICITI.
#
#  PERCHE' NON walkforward_generico.ps1: quello sa spazzare un parametro
#  con IS/OOS e produrre il CSV per combo (e sarebbe piu' semplice), MA
#  NON ha nessuno dei gate di casa -- niente pin/versione, niente gate
#  dell'antenato sulla cella R103, niente igiene gemelli, niente controllo
#  di verginita' dei magic, niente raccolta su Desktop+zip+referto. La
#  checklist di casa pretende quei gate su un EA vivo: percio' il driver
#  compatto derivato da R108 e' la scelta CORRETTA, non la piu' comoda.
# =====================================================================
#  ##################################################################
#  #  CRITERI DI LETTURA -- CONGELATI PRIMA DEI NUMERI (regola di casa) #
#  ##################################################################
#  QUALE METRICA DECIDE: il PROFIT FACTOR FUORI CAMPIONE (PF OOS) per
#    mode, letto INSIEME alla COERENZA CROSS-SIMBOLO. Il DD OOS e' il
#    guardrail del rischio (sotto).
#  LA SOGLIA (dichiarata prima): il mode 2 "vince" SOLO se, su ALMENO 2
#    simboli su 3, PF_OOS(2) > PF_OOS(0) E PF_OOS(2) > PF_OOS(1), senza
#    un DD_OOS peggiore del mode che batte. UN SOLO SIMPOLO A FAVORE = NON
#    DIMOSTRATO (Emendamento A: "un simbolo per parte non e' dimostrato").
#    E MAI il picco isolato: senza la coerenza cross-simbolo, un PF_OOS
#    che sporge su un solo simbolo e' rumore, non un edge.
#  CAMPIONE SOTTILE -> MERITO SOSPESO, RISCHIO SEMPRE (Emendamento B):
#    se n_OOS < 150 su un mode/simbolo, il MERITO (PF) NON si legge come
#    verdetto -- si annota e basta. IL RISCHIO invece si legge SEMPRE: un
#    DD_OOS peggiore del DD promesso dalla cella viva di R103 e' un FATTO
#    accaduto, e va segnalato a qualunque n.
#  COSA NON DECIDE QUESTA MISURA: non promuove, non spegne, non tocca il
#    forward. Dice solo se il mode 2 di Claudio merita di essere portato
#    avanti come candidato, oppure no.
# ---------------------------------------------------------------------
#  LA RIGA CHE SI INCOLLA (blocco INTERO, un comando solo). <PIN> = il
#  commit che contiene QUESTO file (l'hash dato in chat). PRIMA il giro a
#  vuoto (-SoloControllo): non apre MT5, scrive e verifica gli .ini.
#
#  & { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
#      if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
#      $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_ABTEST_CONTENTRY.ps1"; Remove-Item $p -EA SilentlyContinue;
#      irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_ABTEST_CONTENTRY.ps1" -OutFile $p;
#      if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_ABTEST_CONTENTRY_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
#      $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo; if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - leggi il REFERTO' } }
# =====================================================================
[CmdletBinding()]
param(
  # -Pin NON ha default: un default silenzioso ("lavoro") farebbe girare
  #  la punta del branch spacciandola per un commit congelato.
  [string]$Pin        = "",
  [double]$OreMax     = 12.0,      # oltre questo NON si iniziano nuovi lavori
  [switch]$SoloControllo,          # giro a vuoto: scrive e verifica gli .ini,
                                   #  NON apre MT5 (il terminale)
  [string]$SoloSimbolo = "",       # "GBPUSD" | "EURUSD" | "AUDUSD", anche in
                                   #  elenco FRA APICI: 'GBPUSD,EURUSD'
  [switch]$Force                   # by-pass della guardia "terminale aperto"
                                   #  (mai in uso normale)
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

$Avvio  = Get-Date
$Stamp  = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
$Dsk    = Join-Path $env:USERPROFILE "Desktop"
$Work   = Join-Path $env:USERPROFILE "abtest_contentry"
$Prove  = Join-Path $Work "prove"
$IniDir = Join-Path $Work "ini"
$SrcDir = Join-Path $Work "src_motori"
$Risult = Join-Path $Work "risultati_prove"
$Sosta  = Join-Path $Work "sosta"
$RawPin = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

$Ea        = "ABTG_BreakingBand"
$EaVer     = "1.05"              # LETTA nel sorgente al pin
$RigheAtte = 76                 # MISURATE sui tre prova A/B (71 di R103 + 5 v1.05)
$Deposito  = 100000             # come R103
$SpreadIni = 0                  # spread CORRENTE, ma SCRITTO nell'ini
$CelleAttese = 6                # 3 mode x 2 gemelli = 6 righe per CSV di ottimizz.

#--- LA FINESTRA e lo split. 40/60 di R103 (stessa convenzione di
#    walkforward_generico), calcolato sul terreno INTERO. NON il 2+2 di
#    R108: quello era una forzatura del tetto 100k barre su M15; qui siamo
#    su H1 e il terreno intero c'e' tutto.
$WinDa      = "2020.01.01"
$WinA       = "2026.06.30"
$FrazioneIS = 0.40
$Inizio = [datetime]::ParseExact($WinDa,"yyyy.MM.dd",$INV)
$Fine   = [datetime]::ParseExact($WinA,"yyyy.MM.dd",$INV)
$Meta   = $Inizio.AddDays([math]::Floor(($Fine-$Inizio).TotalDays*$FrazioneIS))
$IS_Da  = $Inizio.ToString("yyyy.MM.dd",$INV)
$IS_A   = $Meta.ToString("yyyy.MM.dd",$INV)
$OOS_Da = $Meta.AddDays(1).ToString("yyyy.MM.dd",$INV)
$OOS_A  = $Fine.ToString("yyyy.MM.dd",$INV)
$SogliaMerito = 150             # sotto: MERITO sospeso, RISCHIO sempre (Emend. B)

#--- I MAGIC. Blocco 7650xx VERGINE (verificato in tutto il repo: le
#    uniche 765xxx usate sono 765121/765211/765213, tutte SOPRA il blocco).
#    Per simbolo: IS = base/base+1, OOS = base+2/base+3 (per-trade e cache
#    distinti fra le due finestre). L'InpMagic del prova pinna la coppia IS.
$MagicBase = @{}
$MagicBase["GBPUSD"] = 765000
$MagicBase["EURUSD"] = 765010
$MagicBase["AUDUSD"] = 765020

#--- I MAGIC VIETATI. Guardia esplicita sulle sedie vive + un veto di
#    RANGE su tutta la regione dei round BreakingBand gia' fatti
#    (760000-764999: R103 7600xx, R107 7610xx, R108 7620xx, e i round
#    7630xx/7640xx). Il nostro 7650xx sta SOPRA e passa.
$MagicVietatiRangeLo = 760000
$MagicVietatiRangeHi = 764999
$MagicVietati = @(772161,772162,772163,                        # id sedia R103 BB
                  770202,770101,770201,                        # aperture (vive e spente)
                  770611,770601,770411,770901,770511,970913,   # sedie confinanti
                  971501,770402,970901,770532,772341,          # oro / forex vive
                  772601,772602,772611,772612,                 # R54
                  772800,772890,772891,                        # R98
                  773200,773201,773300,773301,                 # R101
                  750010,750011)                               # R104

# =====================================================================
#  LE TRE CELLE A/B. Una per simbolo. Ognuna gira su DUE finestre (IS,
#  OOS), a Model 4 (tick reali), spazzolando InpContEntryMode + InpMagic.
#  Pat = InpPatternMode VIVO di R103 (GBPUSD 2, EURUSD 0, AUDUSD 1).
# =====================================================================
function C([string]$sym,[int]$pat,[string]$prova,[string]$ant,[int]$base){
  return [pscustomobject]@{
    Sym=$sym; Pat=$pat; Prova=$prova; Antenato=$ant; Base=$base;
    Fermo=$false; TickMisurati="NON MISURATA";
    # riempiti durante la corsa, per finestra (IS/OOS): stato gemelli e per-mode
    GemelliIS="NON MISURATO"; GemelliOOS="NON MISURATO";
    # per mode: hashtable mode -> oggetto {Pf,Dd,N,Prof,Pg}
    IS=@{}; OOS=@{}
  }
}
$CELLE = @(
  (C "GBPUSD" 2 "ABTEST_CONTENTRY_ABTG_BreakingBand_GBPUSD_765000.txt" "R103_ABTG_BreakingBand_GBPUSD_772161.txt" 765000),
  (C "EURUSD" 0 "ABTEST_CONTENTRY_ABTG_BreakingBand_EURUSD_765010.txt" "R103_ABTG_BreakingBand_EURUSD_772162.txt" 765010),
  (C "AUDUSD" 1 "ABTEST_CONTENTRY_ABTG_BreakingBand_AUDUSD_765020.txt" "R103_ABTG_BreakingBand_AUDUSD_772163.txt" 765020)
)
#  I SOLI delta ammessi fra la cella base A/B e il suo antenato R103.
#   - InpMagic          : coppia vergine 7650xx (identita' del lancio)
#   - i 5 input NUOVI di v1.05, che nell'antenato R103 (v1.03) NON esistono
$DeltaValoreAmmessi = @("InpMagic")
$NuoviInput_v105 = @("InpContEntryMode","InpTrendSlopeFactor","InpTrendSlopeBars",
                     "InpContEntryMaxRangeATR","InpContRequireMidFirst")

# =====================================================================
#  TUTTO CIO' CHE LA RACCOLTA USA NASCE QUI, PRIMA DEL try.
# =====================================================================
$Problemi  = New-Object System.Collections.ArrayList
$Rilievi   = New-Object System.Collections.ArrayList
$Fatale    = ""
$Terminal  = ""; $MetaEditor = ""; $DataFolder = ""; $InstDir = ""
$MqlFiles  = ""; $CommonFiles = ""
$Vive      = @{}
$Compilato = $false
$SelettoreAVuoto = $false

function Ora(){ return (Get-Date).ToString("HH:mm:ss", $INV) }
function Dico([string]$t,[string]$c="Gray"){ Write-Host ("[" + (Ora) + "] " + $t) -ForegroundColor $c }
function Titolo([string]$t){ Write-Host ""; Write-Host ("=== " + $t + " ===") -ForegroundColor Cyan }

function Scarica([string]$url,[string]$dest,[string]$marcatore){
  Remove-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue
  Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing -ErrorAction Stop
  if(-not (Test-Path -LiteralPath $dest)){ throw ("scarico fallito: " + $url) }
  if($marcatore -ne "" -and -not (Select-String -LiteralPath $dest -SimpleMatch -Pattern $marcatore -Quiet)){
    throw ("file scaricato SENZA il marcatore '" + $marcatore + "': " + $url)
  }
}
function RigheVive([string]$p){
  return @(Get-Content -LiteralPath $p | Where-Object { $_ -notmatch '^\s*#' -and $_ -notmatch '^\s*$' -and $_ -notmatch '^@' })
}
function NomeDi([string]$riga){ return (($riga -split '=')[0]).Trim() }
function ValoreDi([string]$riga){
  $i = $riga.IndexOf("=")
  if($i -lt 0){ return "" }
  $resto = $riga.Substring($i+1)
  return (($resto -split '\|\|')[0]).Trim()
}
function NumInv($s){
  $v = 0.0
  $t = ("" + $s).Replace([string][char]160,"").Replace([string][char]8239,"").Replace([string][char]8201,"").Replace(" ","").Replace("&nbsp;","").Trim()
  if($t -eq ""){ return $null }
  if([double]::TryParse($t,[Globalization.NumberStyles]::Float,$INV,[ref]$v)){ return $v }
  return $null
}
function Fmt2($v){ if($null -eq $v){ return "n/d" }; if([double]$v -lt 0){ return "n/d" }; return ([double]$v).ToString("0.00",$INV) }
function Fmt3($v){ if($null -eq $v){ return "n/d" }; if([double]$v -lt 0){ return "n/d" }; return ([double]$v).ToString("0.000",$INV) }
function FmtN($v){ if($null -eq $v){ return "n/d" }; if([int]$v -lt 0){ return "n/d" }; return ([int]$v).ToString($INV) }
function FmtE($v){ if($null -eq $v){ return "n/d" }; if([double]$v -le -999998.0){ return "n/d" }; return ([double]$v).ToString("+0;-0;0",$INV) }
function FmtPg($v){ if($null -eq $v){ return "n/d" }; if([double]$v -ge 99.0){ return "n/d" }; return ([double]$v).ToString("0.00",$INV) }

# =====================================================================
#  IL PARSER DEL CSV DI OTTIMIZZAZIONE. Le colonne si cercano PER NOME,
#  mai per posizione; se non riconosce le colonne che contano torna $null
#  E DICE QUALI INTESTAZIONI HA VISTO. Estende R108 con la colonna
#  InpContEntryMode (serve a raggruppare le gemelle per mode).
#  Intestazione MISURATA nel sorgente (OPTFRAME inlined):
#    Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,Sharpe
#    Ratio,Equity DD %,Trades,Peggior Giornata %,...,<InputColonne>
# =====================================================================
$script:CsvIntestazioni = @()
function LeggiOpt([string]$path){
  if(-not (Test-Path -LiteralPath $path)){ return $null }
  $righe = @()
  try{ $righe = @(Import-Csv -LiteralPath $path) }catch{ return $null }
  if($righe.Count -eq 0){ return $null }
  $cols = @($righe[0].PSObject.Properties.Name)
  $script:CsvIntestazioni = $cols
  $kProf=$null; $kPf=$null; $kDd=$null; $kN=$null; $kPg=$null; $kMg=$null; $kMode=$null
  foreach($k in $cols){
    $h = ("" + $k).Trim().ToLower()
    if($null -eq $kProf -and ($h -eq "profit" -or $h -eq "profitto")){ $kProf = $k }
    if($null -eq $kPf   -and ($h -eq "profit factor" -or $h -eq "fattore di profitto")){ $kPf = $k }
    if($null -eq $kDd   -and ($h -eq "equity dd %" -or $h -eq "drawdown equity %" -or $h -eq "equity drawdown %" -or $h -eq "drawdown %")){ $kDd = $k }
    if($null -eq $kN    -and ($h -eq "trades" -or $h -eq "operazioni" -or $h -eq "trade")){ $kN = $k }
    if($null -eq $kPg   -and ($h -eq "peggior giornata %" -or $h -eq "worst day %")){ $kPg = $k }
    if($null -eq $kMg   -and ($h -eq "inpmagic")){ $kMg = $k }
    if($null -eq $kMode -and ($h -eq "inpcontentrymode")){ $kMode = $k }
  }
  if($null -eq $kProf -or $null -eq $kPf -or $null -eq $kDd -or $null -eq $kN -or $null -eq $kMode){ return $null }
  $out = New-Object System.Collections.ArrayList
  foreach($r in $righe){
    $pg = $null; if($null -ne $kPg){ $pg = (NumInv $r.$kPg) }
    $mg = ""; if($null -ne $kMg){ $mg = ("" + $r.$kMg).Trim() }
    [void]$out.Add([pscustomobject]@{
      Profit=(NumInv $r.$kProf); Pf=(NumInv $r.$kPf); Dd=(NumInv $r.$kDd)
      N=(NumInv $r.$kN); Pg=$pg; Magic=$mg; Mode=("" + $r.$kMode).Trim()
    })
  }
  return @($out)
}

#  IGIENE GEMELLI PER MODE: a parita' di InpContEntryMode le due righe
#  (i due magic) devono essere IDENTICHE al centesimo su profitto/PF/DD/n.
#  E si pretende che siano ESATTAMENTE DUE per mode, e TRE mode (0,1,2).
#  Torna un oggetto: Stato + per-mode {Pf,Dd,N,Prof,Pg}.
function GemellePerMode($righe){
  $res = [pscustomobject]@{ Stato="NON MISURATO"; PerMode=@{} }
  if($null -eq $righe){ $res.Stato = "NON MISURATO (CSV non letto o colonne non riconosciute)"; return $res }
  $tot = @($righe).Count
  if($tot -ne $CelleAttese){ $res.Stato = ("NON VALIDO: " + $tot + " righe invece di " + $CelleAttese); return $res }
  $gruppi = @{}
  foreach($r in $righe){
    $m = "" + $r.Mode
    if(-not $gruppi.ContainsKey($m)){ $gruppi[$m] = New-Object System.Collections.ArrayList }
    [void]$gruppi[$m].Add($r)
  }
  $modiAttesi = @("0","1","2")
  $manca = @($modiAttesi | Where-Object { -not $gruppi.ContainsKey($_) })
  if($manca.Count -gt 0){ $res.Stato = ("NON VALIDO: mode mancanti [" + ($manca -join ", ") + "]"); return $res }
  foreach($m in $modiAttesi){
    $g = @($gruppi[$m])
    if($g.Count -ne 2){ $res.Stato = ("NON VALIDO: mode " + $m + " ha " + $g.Count + " righe invece di 2 (gemelli mancanti)"); return $res }
    $a = $g[0]; $b = $g[1]
    foreach($ch in @(@("profitto",$a.Profit,$b.Profit),@("PF",$a.Pf,$b.Pf),@("DD",$a.Dd,$b.Dd),@("n",$a.N,$b.N))){
      if($null -eq $ch[1] -or $null -eq $ch[2]){ $res.Stato = ("NON MISURATO (mode " + $m + ", " + $ch[0] + " illeggibile)"); return $res }
      if([math]::Abs([double]$ch[1] - [double]$ch[2]) -gt 0.005){
        $res.Stato = ("DIVERSI su mode " + $m + " (" + $ch[0] + "): " + $ch[1] + " contro " + $ch[2]); return $res
      }
    }
    $res.PerMode[$m] = [pscustomobject]@{ Pf=$a.Pf; Dd=$a.Dd; N=$a.N; Prof=$a.Profit; Pg=$a.Pg }
  }
  $res.Stato = "IDENTICI (3 mode, gemelli identici in ognuno)"
  return $res
}

# =====================================================================
#  LA FABBRICA DELL'.ini DI OTTIMIZZAZIONE. Le righe le detta il FILE
#  PROVA; qui si riscrive SOLO InpMagic sulla coppia della finestra, e i
#  gate sono SULLO STATO FINALE del testo.
# =====================================================================
function IniOtt($cella,[string]$da,[string]$a,[int]$magic,[string]$dest,[string]$report){
  $out = New-Object System.Collections.ArrayList
  foreach($r in $Vive[$cella.Prova]){
    if((NomeDi $r) -eq "InpMagic"){ [void]$out.Add("InpMagic=" + $magic + "||" + $magic + "||1||" + ($magic+1) + "||Y") }
    else { [void]$out.Add($r) }
  }
  $inputs = ($out -join "`r`n")
  if(@($out).Count -ne $RigheAtte){ throw ("ini OTT " + $cella.Prova + ": " + @($out).Count + " parametri invece di " + $RigheAtte) }
  $yy = @([regex]::Matches($inputs,'(?m)^(\w+)=[^\r\n]*\|\|\s*[Yy]\s*\r?$') | ForEach-Object { $_.Groups[1].Value })
  $atteseY = @("InpContEntryMode","InpMagic")
  $mancaY = @($atteseY | Where-Object { $yy -notcontains $_ })
  $extraY = @($yy | Where-Object { $atteseY -notcontains $_ })
  if($mancaY.Count -gt 0 -or $extraY.Count -gt 0){
    throw ("ini OTT " + $cella.Prova + ": assi Y = [" + ($yy -join ", ") + "] invece di [" + ($atteseY -join ", ") + "]. Solo InpContEntryMode (A/B) e InpMagic (gemelli) possono essere Y.")
  }
  if($inputs -notmatch '(?m)^InpContEntryMode=0\|\|0\|\|1\|\|2\|\|Y\r?$'){ throw ("ini OTT " + $cella.Prova + ": InpContEntryMode non e' spazzato 0||0||1||2||Y") }
  if($inputs -notmatch ('(?m)^InpMagic=' + $magic + '\|\|' + $magic + '\|\|1\|\|' + ($magic+1) + '\|\|Y\r?$')){ throw ("ini OTT: InpMagic non pinnato a " + $magic + "/" + ($magic+1)) }
  $testo = @"
[Charts]
MaxBars=2000000000

[Experts]
AllowLiveTrading=false
AllowDllImport=false

[Tester]
Expert=$Ea.ex5
Symbol=$($cella.Sym)
Period=H1
Model=4
Spread=$SpreadIni
Optimization=1
OptimizationCriterion=6
FromDate=$da
ToDate=$a
ForwardMode=0
Deposit=$Deposito
Currency=EUR
Leverage=100
ExecutionMode=0
ReplaceReport=1
ShutdownTerminal=1
Report=$report

[TesterInputs]
$inputs
"@
  Set-Content -LiteralPath $dest -Value $testo -Encoding ASCII
}

# =====================================================================
#  IL FILTRO -SoloSimbolo
# =====================================================================
$Lavori = @($CELLE)
if($SoloSimbolo -ne ""){
  $ss = @(($SoloSimbolo.ToUpper() -split '[,\s]+') | Where-Object { $_ -ne "" })
  $idValidi = @($CELLE | ForEach-Object { $_.Sym })
  $ignoti = @($ss | Where-Object { $idValidi -notcontains $_ })
  if($ignoti.Count -gt 0){
    Write-Host ("!!! -SoloSimbolo contiene simboli inesistenti: " + ($ignoti -join ", ")) -ForegroundColor Red
    Write-Host ("    Validi: " + ($idValidi -join ", ") + ". Elenchi FRA APICI: -SoloSimbolo 'GBPUSD,EURUSD'") -ForegroundColor Yellow
    exit 1
  }
  $Lavori = @($Lavori | Where-Object { $ss -contains $_.Sym })
}
if($Lavori.Count -eq 0){ $SelettoreAVuoto = $true }
$PassateAttese = $Lavori.Count * 2 * $CelleAttese   # 2 finestre x 6 celle per simbolo

Write-Host ""
Write-Host "#####################################################################" -ForegroundColor Cyan
Write-Host "#  MISURA A/B -- InpContEntryMode 0/1/2 su ABTG_BreakingBand H1     #" -ForegroundColor Cyan
Write-Host "#  GBPUSD + EURUSD + AUDUSD.  NON promuove: e' una MISURA.          #" -ForegroundColor Cyan
Write-Host "#####################################################################" -ForegroundColor Cyan
Dico ("pin      : " + $Pin)
Dico ("cartella : " + $Work)

if($SelettoreAVuoto){
  Write-Host ""
  Write-Host "!!! IL SELETTORE -SoloSimbolo NON HA CORRISPOSTO A NESSUN SIMBOLO." -ForegroundColor Red
  Write-Host "ESITO: SELETTORE A VUOTO -- niente da fare, nessun artefatto prodotto." -ForegroundColor Red
  exit 1
}

Titolo "COSA ESCE, DICHIARATO PRIMA DELLA CORSA"
Write-Host ("    simboli ......  " + $Lavori.Count + "   (" + (($Lavori | ForEach-Object { $_.Sym }) -join ", ") + ")") -ForegroundColor White
Write-Host ("    finestra .....  " + $WinDa + " -> " + $WinA + "   split 40/60 di R103") -ForegroundColor White
Write-Host ("        IS  " + $IS_Da + " -> " + $IS_A + "   (qui NON si sceglie: e' un A/B, non un'ottimizzazione)") -ForegroundColor White
Write-Host ("        OOS " + $OOS_Da + " -> " + $OOS_A + "   (la metrica che DECIDE, vedi criteri)") -ForegroundColor White
Write-Host ("    modello ......  4 (TICK REALI)") -ForegroundColor White
Write-Host ("    per simbolo ..  6 celle x finestra (3 mode x 2 gemelli), 2 finestre = 12 pass") -ForegroundColor White
Write-Host ("    pass totali ..  " + $PassateAttese) -ForegroundColor White
Write-Host ("    righe input ..  " + $RigheAtte + " per file prova") -ForegroundColor White
Write-Host ""
Write-Host  "    CRITERI DI LETTURA (congelati PRIMA dei numeri):" -ForegroundColor Yellow
Write-Host  "      - DECIDE: PF OOS per mode + COERENZA CROSS-SIMBOLO." -ForegroundColor Yellow
Write-Host  "      - SOGLIA: mode 2 vince SOLO se batte 0 E 1 sul PF OOS su >=2" -ForegroundColor Yellow
Write-Host  "        simboli su 3, senza DD OOS peggiore. Un solo simbolo = NON" -ForegroundColor Yellow
Write-Host  "        dimostrato (Emendamento A). Mai il picco isolato." -ForegroundColor Yellow
Write-Host ("      - CAMPIONE SOTTILE (n_OOS < " + $SogliaMerito + "): MERITO sospeso, RISCHIO") -ForegroundColor Yellow
Write-Host  "        sempre. Un DD OOS peggiore del promesso e' un FATTO (Emend. B)." -ForegroundColor Yellow
Write-Host  "      - NON promuove, NON tocca il forward, NON tocca il .mq5." -ForegroundColor Yellow

if($Pin -eq ""){
  Write-Host ""
  Write-Host "!!! MANCA -Pin. Questa riga gira SOLO su un commit congelato." -ForegroundColor Red
  exit 1
}

# =====================================================================
#  LA RACCOLTA. Definita PRIMA del try, gira SEMPRE (anche su gate).
# =====================================================================
function Raccolta(){
  Titolo "RACCOLTA (sempre)"
  $destName = "ABTEST_CONTENTRY_" + $Stamp
  $destDir  = Join-Path $Dsk $destName
  New-Item -ItemType Directory -Force -Path $destDir | Out-Null

  #--- il REFERTO
  $ref = New-Object System.Collections.ArrayList
  [void]$ref.Add("# MISURA A/B -- InpContEntryMode (ABTG_BreakingBand v" + $EaVer + ")")
  [void]$ref.Add("")
  [void]$ref.Add("Marcatore: MARCATORE_RIGA_ABTEST_CONTENTRY_v1")
  [void]$ref.Add("Pin: " + $Pin)
  [void]$ref.Add("Avvio: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   Fine referto: " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss",$INV))
  [void]$ref.Add("Finestra: " + $WinDa + " -> " + $WinA + "   IS " + $IS_Da + " -> " + $IS_A + "   OOS " + $OOS_Da + " -> " + $OOS_A)
  [void]$ref.Add("Modello: 4 (tick reali).  Spread ini: " + $SpreadIni + " (corrente, dichiarato).  Deposito: " + $Deposito)
  [void]$ref.Add("")
  [void]$ref.Add("QUESTO NON E' UN ROUND CHE PROMUOVE. E' UNA MISURA A/B. Non tocca il forward ne' il .mq5.")
  if($SoloControllo){ [void]$ref.Add("MODO: -SoloControllo (giro a vuoto). MT5 NON e' stato aperto: nessun numero misurato.") }
  [void]$ref.Add("")
  [void]$ref.Add("## CRITERI DI LETTURA (congelati prima dei numeri)")
  [void]$ref.Add("- DECIDE: Profit Factor OOS per mode, letto con la coerenza cross-simbolo.")
  [void]$ref.Add("- SOGLIA: il mode 2 vince SOLO se PF_OOS(2) > PF_OOS(0) E > PF_OOS(1) su >=2 simboli su 3,")
  [void]$ref.Add("  senza DD_OOS peggiore. Un solo simbolo a favore = NON dimostrato (Emendamento A). Mai il picco isolato.")
  [void]$ref.Add("- CAMPIONE SOTTILE (n_OOS < " + $SogliaMerito + "): MERITO sospeso, RISCHIO sempre (Emendamento B).")
  [void]$ref.Add("  Un DD_OOS peggiore del DD promesso dalla cella viva di R103 e' un fatto accaduto, e va segnalato a qualunque n.")
  [void]$ref.Add("")
  [void]$ref.Add("## TABELLA A/B  (PF | DD% | n, per mode e per finestra)")
  foreach($c in $Lavori){
    [void]$ref.Add("")
    [void]$ref.Add("### " + $c.Sym + "   (InpPatternMode VIVO = " + $c.Pat + ")")
    [void]$ref.Add("gemelli IS: " + $c.GemelliIS + "   |   gemelli OOS: " + $c.GemelliOOS)
    [void]$ref.Add("profondita' TICK: " + $c.TickMisurati)
    [void]$ref.Add("")
    [void]$ref.Add("| mode | IS PF | IS DD% | IS n | OOS PF | OOS DD% | OOS n |")
    [void]$ref.Add("|------|-------|--------|------|--------|---------|-------|")
    foreach($m in @("0","1","2")){
      $etich = @{ "0"="0 primo tocco"; "1"="1 retest"; "2"="2 in-bulge" }[$m]
      $is = $null; if($c.IS.ContainsKey($m)){ $is = $c.IS[$m] }
      $oo = $null; if($c.OOS.ContainsKey($m)){ $oo = $c.OOS[$m] }
      $isPf = "n/d"; $isDd="n/d"; $isN="n/d"; $ooPf="n/d"; $ooDd="n/d"; $ooN="n/d"
      if($null -ne $is){ $isPf=(Fmt3 $is.Pf); $isDd=(Fmt2 $is.Dd); $isN=(FmtN $is.N) }
      if($null -ne $oo){ $ooPf=(Fmt3 $oo.Pf); $ooDd=(Fmt2 $oo.Dd); $ooN=(FmtN $oo.N) }
      $flag = ""
      if($null -ne $oo -and $null -ne $oo.N -and [int]$oo.N -lt $SogliaMerito){ $flag = "  (n_OOS<" + $SogliaMerito + ": merito sospeso)" }
      [void]$ref.Add("| " + $etich + " | " + $isPf + " | " + $isDd + " | " + $isN + " | " + $ooPf + " | " + $ooDd + " | " + $ooN + " |" + $flag)
    }
  }
  [void]$ref.Add("")
  [void]$ref.Add("## RILIEVI")
  if($Rilievi.Count -eq 0){ [void]$ref.Add("- nessuno") } else { foreach($r in $Rilievi){ [void]$ref.Add("- " + $r) } }
  [void]$ref.Add("")
  [void]$ref.Add("## PROBLEMI")
  if($Problemi.Count -eq 0){ [void]$ref.Add("- nessuno") } else { foreach($p in $Problemi){ [void]$ref.Add("- " + $p) } }
  if($Fatale -ne ""){ [void]$ref.Add(""); [void]$ref.Add("## FATALE"); [void]$ref.Add("- " + $Fatale) }
  $refFile = Join-Path $destDir ("REFERTO_ABTEST_CONTENTRY_" + $Stamp + ".md")
  Set-Content -LiteralPath $refFile -Value ($ref -join "`r`n") -Encoding UTF8

  #--- copio gli artefatti (ini, csv, log, prove, sorgente)
  foreach($sub in @($IniDir,$Risult,$Sosta,$Prove,$SrcDir)){
    if(Test-Path -LiteralPath $sub){
      $leaf = Split-Path -Leaf $sub
      $t = Join-Path $destDir $leaf
      Copy-Item -LiteralPath $sub -Destination $t -Recurse -Force -ErrorAction SilentlyContinue
    }
  }
  #--- lo zip
  $zip = Join-Path $Dsk ($destName + ".zip")
  Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
  try{ Compress-Archive -Path (Join-Path $destDir "*") -DestinationPath $zip -Force -ErrorAction Stop }
  catch{ [void]$Problemi.Add("Compress-Archive fallito: " + $_.Exception.Message) }

  Write-Host ""
  Write-Host "=== RACCOLTA FATTA ===" -ForegroundColor Green
  Write-Host ("    cartella : " + $destDir) -ForegroundColor White
  Write-Host ("    zip      : " + $zip) -ForegroundColor White
  Write-Host  "    FILE ATTESI DENTRO LO ZIP (verificali):" -ForegroundColor Gray
  Write-Host  "      - REFERTO_ABTEST_CONTENTRY_*.md" -ForegroundColor Gray
  Write-Host  "      - ini\        (gli .ini di ottimizzazione, 2 per simbolo: IS e OOS)" -ForegroundColor Gray
  Write-Host  "      - risultati_prove\  (OptResults_*_IS.csv / _OOS.csv, se la corsa e' vera)" -ForegroundColor Gray
  Write-Host  "      - prove\      (i 3 file prova A/B e i 3 antenati R103)" -ForegroundColor Gray
  Write-Host  "      - src_motori\ (il sorgente al pin) + sosta\ (log del compilatore)" -ForegroundColor Gray
  try{ Set-Clipboard -Value $destDir }catch{}
}

# =====================================================================
$EsitoFinale = 0
try{

# --- 0. MT5 E METAEDITOR CHIUSI
Titolo "0. MT5 E METAEDITOR CHIUSI"
$vivi = @(Get-Process -Name "terminal64","metaeditor64" -ErrorAction SilentlyContinue)
if($vivi.Count -gt 0 -and -not $Force){
  Write-Host ("!!! APERTO: " + (($vivi | ForEach-Object { $_.ProcessName } | Sort-Object -Unique) -join ", ")) -ForegroundColor Red
  Write-Host "    Col terminale aperto il tester non gira (zero CSV); con MetaEditor aperto" -ForegroundColor Red
  Write-Host "    la compilazione torna subito senza compilare. Chiudi tutto e rilancia." -ForegroundColor Yellow
  $Fatale = "MT5 o MetaEditor aperto all'avvio."
  Raccolta
  exit 1
}
New-Item -ItemType Directory -Force -Path $Work,$Prove,$IniDir,$SrcDir,$Risult,$Sosta | Out-Null

# --- 1. SCARICO AL PIN E GATE SUGLI ARTEFATTI
Titolo "1. SCARICO AL PIN E GATE"
foreach($c in $Lavori){
  Scarica ("$RawPin/backtest_pipeline/prove/" + $c.Prova) (Join-Path $Prove $c.Prova) 'MARCATORE_PROVA_ABTEST_CONTENTRY_v1'
  $rv = RigheVive (Join-Path $Prove $c.Prova)
  if($rv.Count -ne $RigheAtte){ throw ($c.Prova + " ha " + $rv.Count + " righe di input invece di " + $RigheAtte + ": artefatto cambiato.") }
  $Vive[$c.Prova] = $rv
}
Dico ($Lavori.Count.ToString() + " file prova A/B scaricati al pin, " + $RigheAtte + " righe input ciascuno") "Green"

# --- 1a. IL SORGENTE E IL GATE DI VERSIONE
$srcMq5 = Join-Path $SrcDir ($Ea + ".mq5")
Scarica ("$RawPin/mql5/Experts/" + $Ea + ".mq5") $srcMq5 'OPTFRAME'
$txtSrc = Get-Content -LiteralPath $srcMq5 -Raw
$mv = [regex]::Match($txtSrc,'#property\s+version\s+"([^"]+)"')
if(-not $mv.Success){ throw ($Ea + ".mq5 scaricato senza #property version.") }
if($mv.Groups[1].Value -ne $EaVer){ throw ($Ea + ".mq5 dichiara version '" + $mv.Groups[1].Value + "' invece di '" + $EaVer + "'. Pin sbagliato o motore cambiato.") }
foreach($inp in @("InpContEntryMode","InpTrendSlopeFactor","InpTrendSlopeBars","InpContEntryMaxRangeATR","InpContRequireMidFirst","InpPatternMode")){
  if($txtSrc -notmatch ('(?m)^\s*s?input\s+\w+\s+' + $inp + '\s*=')){ throw ($Ea + ".mq5 non ha l'input " + $inp + ": un pin su un input inesistente e' INERTE e MT5 non se ne lamenta.") }
}
Dico ($Ea + ".mq5 al pin, version " + $mv.Groups[1].Value + ", i 5 input di v1.05 esistono") "Green"

# --- 1b. GATE DELL'ANTENATO R103 (per NOME): la cella base A/B e' identica
#     all'antenato R103 salvo InpMagic (valore) e i 5 input nuovi di v1.05.
foreach($c in $Lavori){
  $fileA = Join-Path $Prove ("ANTENATO_" + $c.Antenato)
  Scarica ("$RawPin/backtest_pipeline/prove/" + $c.Antenato) $fileA '@SIMBOLO'
  $hA = @{}; foreach($r in (RigheVive $fileA)){ $hA[(NomeDi $r)] = $r }
  $hB = @{}; foreach($r in $Vive[$c.Prova]){ $hB[(NomeDi $r)] = $r }
  $viol = New-Object System.Collections.ArrayList
  foreach($k in $hA.Keys){
    if(-not $hB.ContainsKey($k)){ [void]$viol.Add("manca nella cella A/B: " + $k); continue }
    if($hA[$k] -ne $hB[$k] -and $DeltaValoreAmmessi -notcontains $k){ [void]$viol.Add("valore diverso non ammesso: " + $k) }
  }
  foreach($k in $hB.Keys){
    if(-not $hA.ContainsKey($k) -and $NuoviInput_v105 -notcontains $k){ [void]$viol.Add("in A/B ma non nell'antenato e non e' un input v1.05: " + $k) }
  }
  if($viol.Count -gt 0){
    throw ($c.Prova + " contro l'antenato " + $c.Antenato + ": [" + ($viol -join " ; ") + "]. La cella base A/B DEVE essere la cella viva di R103 salvo InpMagic e i 5 input di v1.05.")
  }
  Dico ("gate ANTENATO " + $c.Sym + ": base identica a " + $c.Antenato + " (delta: InpMagic + 5 input v1.05)") "Green"
}

# --- 1c. GATE DEI VALORI, DELL'ASSE E DEI MAGIC, letti NEL FILE che gira.
$magicVisti = @()
foreach($c in $Lavori){
  $tx = Get-Content -LiteralPath (Join-Path $Prove $c.Prova) -Raw
  # InpPatternMode VIVO
  if($tx -notmatch ('(?m)^InpPatternMode=' + $c.Pat + '\|\|')){ throw ($c.Prova + ": InpPatternMode non e' il valore VIVO " + $c.Pat + " (GBPUSD 2, EURUSD 0, AUDUSD 1).") }
  # TF del grafico H1 + InpTF H1
  if($tx -notmatch '(?m)^@PERIODO\s+H1\b'){ throw ($c.Prova + ": @PERIODO non e' H1.") }
  if($tx -notmatch '(?m)^InpTF=16385\|\|'){ throw ($c.Prova + ": InpTF non e' 16385 (H1).") }
  if($tx -notmatch ('(?m)^@SIMBOLO\s+' + $c.Sym + '\b')){ throw ($c.Prova + ": @SIMBOLO non e' " + $c.Sym) }
  if($tx -notmatch '(?m)^@DAQUANDO\s+2020\.01\.01\b'){ throw ($c.Prova + ": @DAQUANDO non e' 2020.01.01") }
  # la geometria che NON deve cambiare (o l'A/B misurerebbe altro)
  foreach($sp in @(@("InpMinTPatATR","0.0"),@("InpMinRR","0.0"),@("InpTPMode","0"),
                   @("InpMaxPositions","1"),@("InpRiskPercent","1.0"),@("InpVerbose","true"))){
    if($tx -notmatch ('(?m)^' + $sp[0] + '=' + [regex]::Escape($sp[1]) + '\|\|')){ throw ($c.Prova + ": " + $sp[0] + " non vale " + $sp[1]) }
  }
  # i 4 input del mode 2 ai DEFAULT del sorgente (vincolo)
  foreach($sp in @(@("InpTrendSlopeFactor","0.08"),@("InpTrendSlopeBars","5"),
                   @("InpContEntryMaxRangeATR","2.0"),@("InpContRequireMidFirst","false"))){
    if($tx -notmatch ('(?m)^' + $sp[0] + '=' + [regex]::Escape($sp[1]) + '\|\|' + [regex]::Escape($sp[1]) + '\|\|0\|\|' + [regex]::Escape($sp[1]) + '\|\|N\r?$')){ throw ($c.Prova + ": " + $sp[0] + " non e' pinnato al default " + $sp[1]) }
  }
  # InpContEntryMode spazzato 0||0||1||2||Y
  if($tx -notmatch '(?m)^InpContEntryMode=0\|\|0\|\|1\|\|2\|\|Y\r?$'){ throw ($c.Prova + ": InpContEntryMode non e' spazzato 0||0||1||2||Y") }
  # L'ASSE: esattamente due Y, InpContEntryMode e InpMagic
  $assiY = @([regex]::Matches($tx,'(?m)^(\w+)=[^\r\n]*\|\|\s*[Yy]\s*\r?$') | ForEach-Object { $_.Groups[1].Value } | Sort-Object)
  $atteseY = @("InpContEntryMode","InpMagic") | Sort-Object
  if(($assiY -join ",") -ne ($atteseY -join ",")){
    throw ($c.Prova + ": assi Y = [" + ($assiY -join ", ") + "] invece di [InpContEntryMode, InpMagic]. Nient'altro puo' essere Y.")
  }
  # InpMagic pinnato alla coppia IS del simbolo
  $mg = [regex]::Match($tx,'(?m)^InpMagic=(\d+)\|\|(\d+)\|\|1\|\|(\d+)\|\|Y')
  if(-not $mg.Success){ throw ($c.Prova + ": InpMagic non e' nella forma 'v||v||1||v+1||Y'.") }
  $m0 = [int]$mg.Groups[1].Value; $m1 = [int]$mg.Groups[3].Value
  if($m0 -ne $c.Base){ throw ($c.Prova + ": InpMagic base e' " + $m0 + " ma deve essere " + $c.Base) }
  if($m1 -ne ($m0+1)){ throw ($c.Prova + ": gemello " + $m1 + " invece di " + ($m0+1)) }
  # i 4 magic del simbolo (IS base/base+1, OOS base+2/base+3): unici e vergini
  foreach($mm in @($c.Base,($c.Base+1),($c.Base+2),($c.Base+3))){
    if($magicVisti -contains $mm){ throw ($c.Prova + ": magic " + $mm + " gia' usato da un'altra cella.") }
    if($MagicVietati -contains $mm){ throw ($c.Prova + ": magic " + $mm + " e' di una sedia viva / round precedente.") }
    if($mm -ge $MagicVietatiRangeLo -and $mm -le $MagicVietatiRangeHi){ throw ($c.Prova + ": magic " + $mm + " cade nella regione vietata dei round BB gia' fatti (" + $MagicVietatiRangeLo + "-" + $MagicVietatiRangeHi + ").") }
    $magicVisti += $mm
  }
}
Dico ("valori, pattern VIVO, TF H1, asse doppio (InpContEntryMode+InpMagic) e " + $magicVisti.Count + " magic vergini verificati NEI FILE") "Green"

# --- 2. SCRIVO E VERIFICO GLI .ini (terminal-independent: vale anche in
#        -SoloControllo, ed E' il giro a vuoto richiesto)
Titolo "2. SCRIVO E VERIFICO GLI .ini"
$Finestre = @(
  @{ Tag="IS";  Da=$IS_Da;  A=$IS_A;  Off=0 },
  @{ Tag="OOS"; Da=$OOS_Da; A=$OOS_A; Off=2 }
)
$IniScritti = @()
foreach($c in $Lavori){
  foreach($w in $Finestre){
    $magic = $c.Base + $w.Off
    $tag   = $Ea + "_" + $c.Sym + "_" + $w.Tag
    $ini   = Join-Path $IniDir ("opt_" + $tag + ".ini")
    IniOtt $c $w.Da $w.A $magic $ini ("OptReport_" + $tag)
    if(-not (Test-Path -LiteralPath $ini)){ throw ("ini non scritto: " + $ini) }
    # RILETTURA e VERIFICA dello stato finale
    $tt = Get-Content -LiteralPath $ini -Raw
    if($tt -notmatch '(?m)^Model=4\r?$'){ throw ($ini + ": Model non e' 4 (tick reali).") }
    if($tt -notmatch '(?m)^Optimization=1\r?$'){ throw ($ini + ": Optimization non e' 1.") }
    if($tt -notmatch ('(?m)^FromDate=' + [regex]::Escape($w.Da) + '\r?$')){ throw ($ini + ": FromDate non e' " + $w.Da) }
    if($tt -notmatch ('(?m)^ToDate=' + [regex]::Escape($w.A) + '\r?$')){ throw ($ini + ": ToDate non e' " + $w.A) }
    if($tt -notmatch '(?m)^InpContEntryMode=0\|\|0\|\|1\|\|2\|\|Y\r?$'){ throw ($ini + ": InpContEntryMode non spazzato.") }
    if($tt -notmatch ('(?m)^InpMagic=' + $magic + '\|\|')){ throw ($ini + ": InpMagic non pinnato a " + $magic) }
    $IniScritti += $ini
    Dico ("ini OK: " + (Split-Path -Leaf $ini) + "  (" + $w.Da + " -> " + $w.A + ", magic " + $magic + "/" + ($magic+1) + ")") "Green"
  }
}
Dico ($IniScritti.Count.ToString() + " .ini scritti e verificati in " + $IniDir) "Green"

# --- 3. TERMINALE, INCLUDE, COMPILAZIONE.
#     In -SoloControllo NON e' fatale se il terminale non c'e' (giro a
#     vuoto su una macchina qualsiasi): si annota un rilievo e si va al
#     referto. In corsa vera, se il terminale o la compilazione mancano,
#     si muore (throw).
Titolo "3. TERMINALE E COMPILAZIONE"
$terminaleOk = $false
try{
  $tutti = @(Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue)
  $cand  = @($tutti | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*" })
  if($cand.Count -eq 0){ throw "non trovo il terminale 'BCM Markets MT5 Terminal' (quello NON -V3)." }
  if($cand.Count -gt 1){ throw ("trovati " + $cand.Count + " terminali che corrispondono: ambiguo.") }
  $InstDir    = $cand[0].DirectoryName
  $Terminal   = Join-Path $InstDir "terminal64.exe"
  $MetaEditor = Join-Path $InstDir "metaeditor64.exe"
  if(-not (Test-Path -LiteralPath $MetaEditor)){ throw ("manca metaeditor64.exe in " + $InstDir) }
  $termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
  $DataFolder = Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue | Where-Object {
      $o = Join-Path $_.FullName "origin.txt"; (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $InstDir)
    } | Select-Object -First 1 -ExpandProperty FullName
  if(-not $DataFolder){ throw "cartella dati MT5 non trovata (origin.txt non punta a nessuna cartella)." }
  $MqlExperts = Join-Path $DataFolder "MQL5\Experts"
  $MqlInclude = Join-Path $DataFolder "MQL5\Include"
  $MqlFiles   = Join-Path $DataFolder "MQL5\Files"
  $CommonFiles = Join-Path $termRoot "Common\Files"
  New-Item -ItemType Directory -Force -Path $MqlExperts,$MqlInclude | Out-Null
  Dico ("terminale : " + $Terminal)
  Dico ("dati      : " + $DataFolder)

  # l'include che nessun driver installa (l'EA fa #include <ABTG_PausaGuardian.mqh>)
  $mqh = Join-Path $MqlInclude "ABTG_PausaGuardian.mqh"
  Scarica ("$RawPin/mql5/Include/ABTG_PausaGuardian.mqh") $mqh 'ABTG_GuardiaIngresso'
  $vfy = Get-Item -LiteralPath $mqh
  if($vfy.PSIsContainer){ throw "ABTG_PausaGuardian.mqh: in Include c'e' una CARTELLA con quel nome." }
  if($vfy.Length -lt 4000){ throw ("ABTG_PausaGuardian.mqh e' lungo " + $vfy.Length + " byte: scarico monco.") }
  Dico ("include installato: ABTG_PausaGuardian.mqh (" + $vfy.Length + " byte)") "Green"

  # compilazione DIRETTA, verdetto sul LastWriteTime del .ex5
  $mq5 = Join-Path $MqlExperts ($Ea + ".mq5")
  $ex5 = Join-Path $MqlExperts ($Ea + ".ex5")
  $logC= Join-Path $MqlExperts ($Ea + ".log")
  $bakMq5 = $mq5 + ".prima_abtest_" + $Stamp
  $bakEx5 = $ex5 + ".prima_abtest_" + $Stamp
  if((Test-Path -LiteralPath $mq5) -and -not (Test-Path -LiteralPath $bakMq5)){ Copy-Item -LiteralPath $mq5 -Destination $bakMq5 -Force }
  if((Test-Path -LiteralPath $ex5) -and -not (Test-Path -LiteralPath $bakEx5)){ Copy-Item -LiteralPath $ex5 -Destination $bakEx5 -Force }
  Copy-Item -LiteralPath $srcMq5 -Destination $mq5 -Force
  $lenSrc = (Get-Item -LiteralPath $srcMq5).Length
  $vc = Get-Item -LiteralPath $mq5 -ErrorAction SilentlyContinue
  if(-not $vc -or $vc.PSIsContainer -or $vc.Length -ne $lenSrc){ throw ("copia di " + $Ea + ".mq5 in MQL5\Experts NON verificata.") }
  $ex5Prima = (Get-Date).AddYears(-100)
  if(Test-Path -LiteralPath $ex5){ $ex5Prima = (Get-Item -LiteralPath $ex5).LastWriteTime }
  Remove-Item -LiteralPath $logC -Force -ErrorAction SilentlyContinue
  & $MetaEditor "/compile:$mq5" "/log:$logC" | Out-Null
  $rcMe = $LASTEXITCODE
  $ex5Dopo = $null
  if(Test-Path -LiteralPath $ex5){ $ex5Dopo = (Get-Item -LiteralPath $ex5).LastWriteTime }
  $compileOk = ($null -ne $ex5Dopo) -and ($ex5Dopo -gt $ex5Prima)
  if(Test-Path -LiteralPath $logC){ Copy-Item -LiteralPath $logC -Destination (Join-Path $Sosta "compile_BreakingBand.log") -Force -ErrorAction SilentlyContinue }
  if(-not $compileOk){
    if(Test-Path -LiteralPath $bakMq5){ Copy-Item -LiteralPath $bakMq5 -Destination $mq5 -Force }
    throw ("COMPILAZIONE FALLITA per " + $Ea + " (metaeditor rc=" + $rcMe + ", .ex5 NON riscritto). Sospetto: include mancante o MetaEditor aperto.")
  }
  $Compilato = $true
  $terminaleOk = $true
  Dico ("COMPILATO " + $Ea + " v" + $EaVer + " (.ex5 riscritto adesso, rc=" + $rcMe + ")") "Green"
}catch{
  if($SoloControllo){
    [void]$Rilievi.Add("FASE 3 saltata in -SoloControllo (" + $_.Exception.Message + "). Il giro a vuoto ha comunque scritto e verificato gli .ini; terminale/compilazione si provano nella corsa vera.")
    Dico ("FASE 3 non completata (SoloControllo, non fatale): " + $_.Exception.Message) "Yellow"
  } else {
    throw
  }
}

# --- 4. -SoloControllo si ferma qui (MT5 NON aperto)
if($SoloControllo){
  Titolo "SOLO CONTROLLO: MT5 NON e' stato aperto"
  Write-Host  "    Gli .ini sono scritti e verificati. Nessun numero e' stato misurato:" -ForegroundColor Yellow
  Write-Host  "    senza tester non esiste nessun PF, nessun DD, nessun n." -ForegroundColor Yellow
  Write-Host  "    Se i conteggi tornano, rilancia lo STESSO comando SENZA -SoloControllo." -ForegroundColor Yellow
  Raccolta
  exit 0
}

# --- 5. LA CORSA: per simbolo x finestra, ottimizzazione a 2 assi, poi
#        gemelli-per-mode e PF/DD/n per mode.
Titolo "5. LA CORSA (tick reali)"
# profondita' tick: RILIEVO, non gate (come R108)
foreach($c in $Lavori){
  $tk = Join-Path $Work ("misura_tick_" + $c.Sym + ".csv")
  try{
    Scarica ("$RawPin/backtest_pipeline/risultati_archivio/misura_tick/misura_tick_" + $c.Sym + ".csv") $tk ""
    $riga = @(Get-Content -LiteralPath $tk | Where-Object { $_ -match '(?i)TICK' } | Select-Object -First 1)
    if($riga.Count -gt 0){ $c.TickMisurati = ("" + $riga[0]).Trim() } else { $c.TickMisurati = "file presente ma senza riga TICK" }
  }catch{
    $c.TickMisurati = "NON MISURATA (nessun misura_tick_" + $c.Sym + ".csv al pin)"
    [void]$Rilievi.Add("PROFONDITA' TICK NON MISURATA su " + $c.Sym + ": a Model 4, se i tick reali non ci sono MT5 NON si ferma, ripiega e produce numeri PLAUSIBILI E FALSI. Ogni numero OOS su " + $c.Sym + " va letto con questa riserva.")
  }
}

if($OreMax -le 0){ $OreMax = 12.0 }
foreach($c in $Lavori){
  foreach($w in $Finestre){
    if(((Get-Date) - $Avvio).TotalHours -ge $OreMax){
      [void]$Problemi.Add("-OreMax (" + $OreMax + "h) raggiunto: non inizio " + $c.Sym + " " + $w.Tag + ".")
      continue
    }
    $magic = $c.Base + $w.Off
    $tag   = $Ea + "_" + $c.Sym + "_" + $w.Tag
    $ini   = Join-Path $IniDir ("opt_" + $tag + ".ini")
    # copio l'ex5 e l'ini gia' pronti; svuoto l'OptResults del simbolo
    $optCsv = Join-Path $MqlFiles ("OptResults_" + $Ea + "_" + $c.Sym + ".csv")
    if(Test-Path -LiteralPath $optCsv){ Remove-Item -LiteralPath $optCsv -Force -ErrorAction SilentlyContinue }
    $prima = Get-Date
    Write-Host ""
    Write-Host ("--- " + $tag + "   (" + $w.Da + " -> " + $w.A + ")   " + $CelleAttese + " celle ---") -ForegroundColor Cyan
    (Start-Process -FilePath $Terminal -ArgumentList "/config:`"$ini`"" -PassThru).WaitForExit()
    if(-not (Test-Path -LiteralPath $optCsv)){
      $alt = @(Get-ChildItem $MqlFiles -Filter "OptResults_*.csv" -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -ge $prima } | Sort-Object LastWriteTime -Descending | Select-Object -First 1)
      if($alt.Count -gt 0){ $optCsv = $alt[0].FullName }
    }
    if(-not (Test-Path -LiteralPath $optCsv)){
      [void]$Problemi.Add($tag + ": nessun OptResults CSV (storico mancante su " + $c.Sym + "? MT5 gia' aperto?).")
      if($w.Tag -eq "IS"){ $c.GemelliIS = "NON MISURATO (CSV assente)" } else { $c.GemelliOOS = "NON MISURATO (CSV assente)" }
      continue
    }
    $dest = Join-Path $Risult ("OptResults_" + $c.Sym + "_" + $w.Tag + ".csv")
    Copy-Item -LiteralPath $optCsv -Destination $dest -Force
    $parsed = LeggiOpt $dest
    if($null -eq $parsed){
      [void]$Problemi.Add($tag + ": CSV non parsato. Intestazioni viste: " + ($script:CsvIntestazioni -join " | "))
      if($w.Tag -eq "IS"){ $c.GemelliIS = "NON MISURATO (CSV non parsato)" } else { $c.GemelliOOS = "NON MISURATO (CSV non parsato)" }
      continue
    }
    $gm = GemellePerMode $parsed
    if($w.Tag -eq "IS"){ $c.GemelliIS = $gm.Stato; $c.IS = $gm.PerMode } else { $c.GemelliOOS = $gm.Stato; $c.OOS = $gm.PerMode }
    $col = "Green"; if($gm.Stato -notlike "IDENTICI*"){ $col = "Yellow"; [void]$Problemi.Add($tag + " gemelli: " + $gm.Stato) }
    Dico ($tag + " -> gemelli " + $gm.Stato) $col
  }
}

}catch{
  $Fatale = $_.Exception.Message
  Write-Host ""
  Write-Host ("!!! FATALE: " + $Fatale) -ForegroundColor Red
  $EsitoFinale = 1
}

Raccolta

Write-Host ""
if($Fatale -ne ""){ Write-Host "ESITO: FERMO (leggi FATALE nel referto)." -ForegroundColor Red; exit 1 }
if($Problemi.Count -gt 0){ Write-Host ("ESITO: PARZIALE (" + $Problemi.Count + " problemi nel referto).") -ForegroundColor Yellow; exit 1 }
Write-Host "ESITO: COMPLETO. La tabella A/B e' nel referto." -ForegroundColor Green
exit 0
