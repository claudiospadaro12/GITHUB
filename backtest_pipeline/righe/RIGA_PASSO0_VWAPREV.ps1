# =====================================================================
#  MARCATORE_RIGA_PASSO0_VWAPREV_v3
#  RIGA_PASSO0_VWAPREV.ps1  --  PASSO 0 DEL MOTORE VWAP REVERT
#  ABTG_VwapRevert  su  D30EUR  M15, TICK REALI, quattro celle:
#     00_nudo       long + short insieme, flat ON   magic 773400/773401
#     01_long       solo long,            flat ON   magic 773410/773411
#     02_short      solo short,           flat ON   magic 773420/773421
#     03_overnight  long + short,         flat OFF  magic 773430/773431
# ---------------------------------------------------------------------
#  QUESTO NON E' UN ROUND E NON DA' NESSUN VERDETTO.
#  E' il PASSO 0 preteso dal dossier della caccia M5/M15 INDICI del
#  25/08/2026 (caccia_strategie\CACCIA_M5M15_INDICI_2026-08-25.md,
#  par. 6, paletto 2):
#     "PASSO 0 obbligatorio: contare le operazioni prima di leggere il
#      PF. Se n IS < 150 scatta la valvola R59."
#  Il PF che esce dal CSV si LEGGE ma NON si giudica: i criteri di
#  merito della BOZZA (S3/S4/S5/S6) sono [DA FIRMARE], e quattro celle
#  non sono un round.
#
#  LA BOZZA prove\VWAPREVERT_DAX_M15_BOZZA.txt RESTA FERMA. Questo
#  giro non la sblocca: la BOZZA e' una GRIGLIA da 18 celle che sceglie
#  una taratura, e una griglia si lancia dopo la firma. Qui l'unico
#  asse spazzolato e' InpMagic, e il driver SI FERMA se ne trova un
#  secondo.
#
#  L'IPOTESI, i tre esiti A/B/C, il cancello S0 (costo) e l'avvertenza
#  di REGIME stanno scritti in testa a prove\ABTG_VwapRevert.txt e NON
#  si riscrivono qui: un criterio ricopiato in quattro posti e' un
#  criterio che prima o poi diverge.
#
#  ------------------------------------------------------------------
#  PERCHE' ESISTE QUESTO FILE invece di quattro righe di
#  walkforward_generico.ps1 incollate a mano. Gli stessi tre motivi
#  MISURATI del PASSO 0 FVG:
#
#   1. L'INCLUDE. ABTG_VwapRevert.mq5 fa
#        #include <ABTG_PausaGuardian.mqh>
#      e walkforward_generico.ps1 NON lo installa (verificato: nel
#      driver generico la stringa 'PausaGuardian' non compare). Se quel
#      file non e' gia' in MQL5\Include la compilazione fallisce, e il
#      driver generico muore con "compilazione fallita" senza dire
#      perche'.
#
#   2. I GATE SUI FILE PROVA. Il driver generico controlla il formato,
#      non il PERIMETRO: non sa che le quattro celle devono differire
#      di due righe sole, non sa quali magic sono vietati, non sa che
#      @PERIODO deve essere M15, e non sa che il FLAT DI FINE SEDUTA e'
#      il punto di questo giro.
#
#   3. LA RACCOLTA. Regola di casa (CLAUDE.md, regola delle righe di
#      lancio, punto 2): a fine test i risultati finiscono in una
#      cartella sul Desktop e in uno zip pronto da mandare. Sempre,
#      anche quando la corsa si ferma a meta'.
#  ------------------------------------------------------------------
#
#  QUELLO CHE NON FA, dichiarato:
#   - NON GIUDICA e non promuove niente. Conta le operazioni e mette il
#     numero accanto alla soglia dei 150 dell'Emendamento regola A.
#   - NON tocca nessuna sedia viva. Gli otto magic sono VERGINI (blocco
#     7734xx, cercati uno per uno in tutto il repo il 28/08/2026: zero
#     occorrenze operative). I magic delle sedie vive e quelli dei
#     round recenti sono nella lista dei VIETATI qui sotto.
#   - NON scarica storico e non svuota bases\<server>\ticks. I tick di
#     D30EUR dal 2024.09.26 sono agli atti (sonda del 17/08, COMPLETO).
#   - NON misura lo spread e NON converte punti MT5 in punti indice su
#     D30EUR: quel rapporto NON E' AGLI ATTI (R97 lo ha misurato su
#     U30USD e NASUSD, non sul DAX). Percio' il cancello S0 di questo
#     motore resta NON ADJUDICABILE, e il referto lo scrive.
#   - non scrive una riga di MQL5.
#
#  RISCHIO DICHIARATO: l'EA non e' MAI STATO COMPILATO da nessuno --
#  scritto il 25/08/2026, modificato il 28/08 (flat di fine seduta), e
#  in quell'ambiente non esiste MetaEditor. PER QUESTO IL GIRO DI
#  CONTROLLO (-SoloControllo) ADESSO COMPILA DAVVERO: la compilazione e'
#  il primo risultato vero di questo PASSO 0, e si scopre in un minuto,
#  non dopo mezz'ora di tick reali. Se MetaEditor si lamenta, lo script
#  stampa le ultime 40 righe del log e SI FERMA.
#
#  DOVE SI LEGGE SE IL MOTORE RAGIONA: NON nella scheda Esperti.
#  In OTTIMIZZAZIONE le Print girano sugli agent e non le legge nessuno
#  (CHECKLIST punto 34). L'autotest e il flat escono in TRE COLONNE del
#  CSV -- 'Autotest Falliti', 'Flat Giorni', 'Flat Chiusure' -- e questo
#  script ci fa un GATE:
#    Autotest Falliti  = 0   -> i numeri si leggono
#    Autotest Falliti  > 0   -> DIVERGE, i numeri NON si leggono
#    Autotest Falliti  = -1  -> autotest non eseguito: nessun gate
#    Flat Giorni       = 0 con flat ACCESO -> rilievo
#    Flat Giorni       > 0 con flat SPENTO -> problema (non morde)
#
#  QUANTO CI METTE [STIMA, non una previsione]:
#   - GIRO DI CONTROLLO (-SoloControllo): ~1 minuto. NON e' piu' un giro a
#     vuoto: scarica, passa i gate sui file prova, installa l'include E
#     COMPILA DAVVERO. La compilazione e' il primo risultato vero.
#   - CORSA VERA: 8 passate a tick reali (4 celle x 2 finestre) x 2
#     gemelle = 16 passate su 21 mesi di M15. R107 fece 24 passate a tick
#     reali sulla stessa finestra in 9 minuti. Stima 15-40 minuti.
#
#  LA RIGA CHE SI INCOLLA sta in righe\RIGA_PASSO0_VWAPREV_DA_MANDARE.md
# =====================================================================
[CmdletBinding()]
param(
  # -Pin NON ha default: un default silenzioso ("lavoro") farebbe girare
  #  la punta del branch spacciandola per un commit congelato.
  [string]$Pin           = "",
  [switch]$SoloControllo,          # giro a vuoto: NON apre MT5
  [switch]$Rifai,                  # rifa' anche i CSV gia' presenti
  [string]$SoloCella     = "",     # "00_nudo" | "01_long" | "02_short" | "03_overnight"
  [string]$Simbolo       = "D30EUR",
  [string]$Periodo       = "M15",
  [string]$DaQuando      = "2024.09.26",
  [string]$Fino          = "2026.06.30",
  [int]$Deposito         = 100000
  # NIENTE -Rischio: era un PARAMETRO ORFANO (CHECKLIST punto 97). Non
  # veniva passato a nessuno, veniva solo STAMPATO nel referto -- cioe'
  # un numero mai applicato scritto accanto a numeri veri. Il rischio che
  # morde davvero e' InpRiskPercent, pinnato nei file prova, e il referto
  # lo legge da li' dichiarando la fonte.
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

$EA     = "ABTG_VwapRevert"
$Avvio  = Get-Date
$Stamp  = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
$Dsk    = Join-Path $env:USERPROFILE "Desktop"
$Work   = Join-Path $env:USERPROFILE "abtg_passo0_vwaprev"
$Prove  = Join-Path $Work "prove"
$RawPin = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

# --- TUTTO CIO' CHE LA RACCOLTA USA NASCE QUI, PRIMA DEL try.
#     In PowerShell una `function` non e' dichiarativa, e' un'ISTRUZIONE:
#     se il flusso non ci passa sopra il nome non esiste, e la raccolta
#     esploderebbe proprio nella corsa fermata da un gate, cioe' l'unica
#     in cui il referto serve davvero.
$Problemi = New-Object System.Collections.ArrayList
$Rilievi  = New-Object System.Collections.ArrayList
$Fatale   = ""
$Include  = "NON INSTALLATO"
$Compilazione = "NON TENTATA"
$Modo     = "CORSA"
if($SoloControllo){ $Modo = "CONTROLLO" }

function Ora(){ return (Get-Date).ToString("HH:mm:ss", $INV) }
function Dico([string]$t,[string]$c="Gray"){ Write-Host ("[" + (Ora) + "] " + $t) -ForegroundColor $c }
function Titolo([string]$t){ Write-Host ""; Write-Host ("=== " + $t + " ===") -ForegroundColor Cyan }

function Scarica([string]$url,[string]$dest){
  Remove-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue
  Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing -ErrorAction Stop
  if(-not (Test-Path -LiteralPath $dest)){ throw ("scarico fallito: " + $url) }
}

function RigheVive([string]$p){
  return @(Get-Content -LiteralPath $p | Where-Object { $_ -notmatch '^\s*#' -and $_ -notmatch '^\s*$' })
}

function NumInv($s){
  $v = 0.0
  $t = ("" + $s).Replace([string][char]160,"").Replace(" ","").Trim()
  if($t -eq ""){ return $null }
  if([double]::TryParse($t,[Globalization.NumberStyles]::Float,$INV,[ref]$v)){ return $v }
  return $null
}

# --- LA CONVENZIONE DI SENTINELLA, e vale per TUTTE le colonne.
#     Un numero non misurato non deve MAI uscire come numero plausibile:
#     in R103 il PF non misurato usciva "0.000", che si legge "ha perso
#     tutto". Qui esce "n/d".
function FmtN($v){ if($null -eq $v){ return "n/d" }; if([int]$v -lt 0){ return "n/d" }; return ([int]$v).ToString($INV) }
function Fmt2($v){ if($null -eq $v){ return "n/d" }; if([double]$v -lt 0){ return "n/d" }; return ([double]$v).ToString("0.00",$INV) }
function FmtE($v){ if($null -eq $v){ return "n/d" }; if([double]$v -le -999998.0){ return "n/d" }; return ([double]$v).ToString("+0;-0;0",$INV) }
function FmtPg($v){ if($null -eq $v){ return "n/d" }; if([double]$v -ge 99.0){ return "n/d" }; return ([double]$v).ToString("0.00",$INV) }
# --- LE COLONNE DI COLLAUDO hanno una sentinella DIVERSA: qui il -1 e'
#     un'INFORMAZIONE ("autotest non eseguito"), non un buco. Se lo
#     passassi a FmtN uscirebbe "n/d" e si confonderebbe col caso
#     "colonna assente", che e' un'altra cosa e va detta.
function FmtCol($v){ if($null -eq $v){ return "assente" }; if([int]$v -lt 0){ return "non-eseg" }; return ([int]$v).ToString($INV) }

# --- IL PARSER DEL CSV DI OTTIMIZZAZIONE.
#     Le colonne si cercano PER NOME, mai per posizione. Se non le
#     riconosce torna $null E DICE quali intestazioni ha visto, invece di
#     indovinare.
#     L'intestazione VERA di questo EA, LETTA NEL SORGENTE (OnTester,
#     'double stats[13]'), e' a QUATTORDICI colonne e CONTIENE
#     'Peggior Giornata %' piu' le tre di COLLAUDO ('Autotest Falliti',
#     'Flat Giorni', 'Flat Chiusure'). Non e' ereditata da un round
#     gemello.
#     Le tre di collaudo si leggono PER NOME come le altre, e sono
#     FACOLTATIVE nel parser: se mancano, il ciclo delle celle lo
#     dichiara come PROBLEMA ("autotest non eseguito"), invece di far
#     fallire la lettura di tutto il CSV.
$script:CsvIntestazioni = @()
function LeggiOpt([string]$path){
  if(-not (Test-Path -LiteralPath $path)){ return $null }
  $righe = @()
  try{ $righe = @(Import-Csv -LiteralPath $path) }catch{ return $null }
  if($righe.Count -eq 0){ return $null }
  $cols = @($righe[0].PSObject.Properties.Name)
  $script:CsvIntestazioni = $cols
  $kProf = $null; $kPf = $null; $kDd = $null; $kN = $null; $kPg = $null; $kMg = $null
  $kAt = $null; $kFg = $null; $kFc = $null
  foreach($k in $cols){
    $l = ("" + $k).Trim().ToLower()
    if($l -eq "profit" -or $l -eq "profitto"){ $kProf = $k }
    if($l -eq "profit factor" -or $l -eq "fattore di profitto"){ $kPf = $k }
    if($l -eq "equity dd %" -or $l -eq "drawdown equity %"){ $kDd = $k }
    if($l -eq "trades" -or $l -eq "operazioni"){ $kN = $k }
    if($l -eq "peggior giornata %" -or $l -eq "worst day %"){ $kPg = $k }
    if($l -eq "inpmagic"){ $kMg = $k }
    if($l -eq "autotest falliti"){ $kAt = $k }
    if($l -eq "flat giorni"){ $kFg = $k }
    if($l -eq "flat chiusure"){ $kFc = $k }
  }
  if($null -eq $kProf -or $null -eq $kPf -or $null -eq $kDd -or $null -eq $kN){ return $null }
  $out = New-Object System.Collections.ArrayList
  foreach($r in $righe){
    $pg = $null
    if($null -ne $kPg){ $pg = (NumInv $r.$kPg) }
    $mg = ""
    if($null -ne $kMg){ $mg = ("" + $r.$kMg).Trim() }
    $at = $null; $fg = $null; $fc = $null
    if($null -ne $kAt){ $at = (NumInv $r.$kAt) }
    if($null -ne $kFg){ $fg = (NumInv $r.$kFg) }
    if($null -ne $kFc){ $fc = (NumInv $r.$kFc) }
    [void]$out.Add([pscustomobject]@{
      Profit = (NumInv $r.$kProf); Pf = (NumInv $r.$kPf); Dd = (NumInv $r.$kDd)
      N = (NumInv $r.$kN); Pg = $pg; Magic = $mg
      Autotest = $at; FlatGiorni = $fg; FlatChiusure = $fc })
  }
  return @($out)
}

# --- I GEMELLI: le due righe devono essere IDENTICHE AL CENTESIMO.
#     E' il cancello S2 della BOZZA, ed e' il motivo per cui l'unico
#     asse spazzolato e' InpMagic.
#     "Una riga sola" NON e' "gemelli ok": e' uno sweep che non ha
#     spazzolato.
$TolGemelli = 0.005
function Gemelli($righe){
  if($null -eq $righe){ return "NON MISURATO (CSV non letto)" }
  if(@($righe).Count -ne 2){ return ("NON VALIDO: " + @($righe).Count + " righe invece di 2") }
  $a = $righe[0]; $b = $righe[1]
  foreach($ch in @(@("profitto",$a.Profit,$b.Profit),@("PF",$a.Pf,$b.Pf),@("DD",$a.Dd,$b.Dd),@("n",$a.N,$b.N))){
    if($null -eq $ch[1] -or $null -eq $ch[2]){ return ("NON MISURATO (" + $ch[0] + " illeggibile)") }
    if([math]::Abs([double]$ch[1] - [double]$ch[2]) -gt $TolGemelli){
      return ("DIVERSI su " + $ch[0] + ": " + $ch[1] + " contro " + $ch[2])
    }
  }
  return "IDENTICI"
}

# =====================================================================
#  LE QUATTRO CELLE. 'Diff' = gli input che DEVONO differire dal
#  00_nudo, e NESSUN ALTRO. Contare "due righe diverse" non basterebbe:
#  DUE righe SBAGLIATE darebbero lo stesso conteggio. 'VLong'/'VShort'/
#  'VFlat' dicono quanto devono VALERE quei tre interruttori IN QUEL
#  FILE: se due file fossero SCAMBIATI il diff resterebbe verde e
#  questo no.
# =====================================================================
function C([string]$id,[string]$file,[string]$desc,[int]$m1,[int]$m2,
          [string]$vLong,[string]$vShort,[string]$vFlat,$diff){
  return [pscustomobject]@{
    Id=$id; Prova=$file; Desc=$desc; M1=$m1; M2=$m2;
    VLong=$vLong; VShort=$vShort; VFlat=$vFlat; Diff=@($diff);
    Esito="NON ESEGUITA"; Gemelli="NON MISURATO";
    NIS=-1; NOOS=-1; PfIS=-1.0; PfOOS=-1.0; DdIS=-1.0; DdOOS=-1.0;
    ProfIS=-999999.0; ProfOOS=-999999.0; PgOOS=99.9;
    Autotest=$null; FlatGiorni=$null; FlatChiusure=$null }
}
$CELLE = @()
$CELLE += (C "00_nudo"      "ABTG_VwapRevert.txt"                "IL MOTORE, due lati insieme, INTRADAY -- porta i gemelli" 773400 773401 "1" "1" "1" @())
$CELLE += (C "01_long"      "PASSO0_VWAPREV_01_long.txt"         "SOLO LONG -- la frequenza del lato long"                  773410 773411 "1" "0" "1" @("InpAllowShort"))
$CELLE += (C "02_short"     "PASSO0_VWAPREV_02_short.txt"        "SOLO SHORT -- la frequenza del lato short"                773420 773421 "0" "1" "1" @("InpAllowLong"))
$CELLE += (C "03_overnight" "PASSO0_VWAPREV_03_overnight.txt"    "FLAT SPENTO -- quanto costa la regola intraday"           773430 773431 "1" "1" "0" @("InpFlatFineSeduta"))

# --- LA BASELINE ASSOLUTA. Il gate della stella confronta ogni cella
#     col 00_nudo: NON puo' accorgersi di niente che sia storto ALLO
#     STESSO MODO in tutti e quattro i file (lezione R110). Questi
#     valori sono dichiarati QUI, in assoluto, e prendono proprio quel
#     caso. Sono i default d'autore del porting piu' le due regole di
#     casa (cap giornaliero, flat di fine seduta).
$Baseline = @{
  "InpSigmaMult"             = "1.0"
  "InpTpR"                   = "2.0"
  "InpSlAtrFloor"            = "0.2"
  "InpLookback"              = "20"
  "InpAtrPeriod"             = "10"
  "InpAtrMult"               = "1.5"
  "InpOrderLifeBars"         = "3"
  "InpSlFloorMode"           = "0"
  "InpUsePartial"            = "0"
  "InpUseTrailAtr"           = "0"
  "InpMinSessionBars"        = "0"
  "InpSessionStartHour"      = "-1"
  "InpUseHourFilter"         = "0"
  "InpEngulfingOnly"         = "0"
  "InpFridayClose"           = "0"
  "InpRiskPercent"           = "1.0"
  "InpMaxTradesPerDay"       = "2"
  "InpFlatOra"               = "20"
  "InpFlatMinuto"            = "45"
  "InpStopNuoviMinPrimaFlat" = "0"
}

# --- I MAGIC VIETATI: i magic delle sedie vive, dei round recenti e
#     del PASSO 0 gemello (FVG, blocco 776xxx). Un'identita' non in
#     campo resta comunque occupata.
$MagicVietati = @(775501, 776000, 776001, 776100, 776101, 776200, 776201, 776400, 776401,
                  763000,763010,763020,763100,763110,763120,
                  763200,763210,763220,763300,763310,763320,
                  773200,773201,773230,773231,773300,773301,
                  770101,770511,771531,970911,970912,970913)

$Ordinati = @($CELLE)
if($SoloCella -ne ""){
  $Ordinati = @($CELLE | Where-Object { $_.Id -eq $SoloCella })
}

try{
  Titolo "PASSO 0 -- VWAP REVERT (ABTG_VwapRevert) -- modo $Modo"

  # -------------------------------------------------------------------
  #  0. LE GUARDIE, PRIMA DI TOCCARE QUALUNQUE COSA
  # -------------------------------------------------------------------
  if($Pin -eq ""){ throw "-Pin obbligatorio: senza, girerebbe la punta del branch spacciandola per un commit congelato." }
  if($Pin -notmatch '^[0-9a-f]{40}$'){ throw ("-Pin deve essere un commit di 40 caratteri esadecimali, ricevuto: " + $Pin) }
  if(Get-Process terminal64,metaeditor64 -ErrorAction SilentlyContinue){
    throw "MT5 O METAEDITOR APERTO: col terminale aperto il tester non gira (zero CSV), con MetaEditor aperto la compilazione torna subito senza compilare."
  }
  if($SoloCella -ne "" -and @($Ordinati).Count -eq 0){
    throw ("-SoloCella '" + $SoloCella + "' non esiste. Validi: 00_nudo, 01_long, 02_short, 03_overnight.")
  }
  if($Periodo -ne "M15"){
    [void]$Rilievi.Add("PERIODO diverso da M15 (" + $Periodo + "): i file prova dichiarano @PERIODO M15 e il gate lo confronta.")
  }

  Dico ("pin ......... " + $Pin)
  Dico ("celle ....... " + @($Ordinati).Count + " su 4")
  Dico ("finestra .... " + $DaQuando + " -> " + $Fino + " (split 40/60 del driver generico)")
  Dico ("banco ....... Modello 4 (TICK REALI), deposito " + $Deposito + ", rischio " + $Baseline["InpRiskPercent"] + "% (letto dal file prova, non da un parametro)")

  # -------------------------------------------------------------------
  #  1. SCARICO AL PIN
  # -------------------------------------------------------------------
  Titolo "1. SCARICO AL PIN"
  # --- LA CACHE SI BUTTA QUANDO CAMBIA IL PIN (CHECKLIST punti 14 e 23).
  #     $Work sopravvive fra un lancio e l'altro: senza questo, i CSV e i
  #     file prova del pin VECCHIO resterebbero sul disco e il gate di
  #     idempotenza del driver generico ("il CSV c'e' gia', salto") li
  #     riproporrebbe come se fossero del pin nuovo. E' il referto stantio
  #     del 17/08 travestito da ripresa di corsa.
  $pinFile = Join-Path $Work "pin_corrente.txt"
  $pinVecchio = ""
  if(Test-Path -LiteralPath $pinFile){ $pinVecchio = (Get-Content -LiteralPath $pinFile -Raw).Trim() }
  if($pinVecchio -ne $Pin){
    Remove-Item -LiteralPath $Prove -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath (Join-Path $Work "risultati_prove") -Recurse -Force -ErrorAction SilentlyContinue
    Dico ("pin cambiato (" + $pinVecchio + " -> " + $Pin + "): artefatti del pin vecchio CANCELLATI") "Yellow"
  }
  New-Item -ItemType Directory -Force -Path $Work,$Prove | Out-Null
  Set-Content -LiteralPath $pinFile -Value $Pin -Encoding ASCII

  $drv = Join-Path $Work "walkforward_generico.ps1"
  Scarica ($RawPin + "/backtest_pipeline/walkforward_generico.ps1") $drv
  # il driver generico pinna il branch da cui riscarica il .mq5: senza
  # questo, il pin varrebbe per il driver e NON per l'EA misurato.
  $t = Get-Content -LiteralPath $drv -Raw
  if($t -notmatch '\$EABranch\s*=\s*"lavoro"'){ throw "walkforward_generico.ps1 non ha la riga \$EABranch attesa: non lo posso pinnare." }
  $t = $t -replace '\$EABranch\s*=\s*"lavoro"', ('$EABranch="' + $Pin + '"')
  Set-Content -LiteralPath $drv -Value $t -Encoding ASCII
  Dico "driver generico scaricato e PINNATO (riscarica l'EA al pin, non dalla punta del branch)" "Green"

  foreach($c in $Ordinati){
    Scarica ($RawPin + "/backtest_pipeline/prove/" + $c.Prova) (Join-Path $Prove $c.Prova)
  }
  # il 00_nudo serve SEMPRE: e' il termine di paragone del gate della
  # stella, anche quando gira una cella sola. E si riscarica SEMPRE, non
  # "solo se non c'e'": una copia rimasta da un pin precedente farebbe
  # confrontare le celle di oggi con la baseline di ieri, e il gate
  # direbbe verde a un delta che nessuno ha dichiarato.
  $fNudo = Join-Path $Prove "ABTG_VwapRevert.txt"
  Scarica ($RawPin + "/backtest_pipeline/prove/ABTG_VwapRevert.txt") $fNudo
  Dico ("file prova scaricati: " + @(Get-ChildItem $Prove -Filter *.txt).Count) "Green"

  $incSrc = Join-Path $Work "ABTG_PausaGuardian.mqh"
  Scarica ($RawPin + "/mql5/Include/ABTG_PausaGuardian.mqh") $incSrc
  Dico ("include scaricato: ABTG_PausaGuardian.mqh (" + (Get-Item $incSrc).Length + " byte)") "Green"

  # -------------------------------------------------------------------
  #  2. I GATE SUI FILE PROVA -- girano PRIMA di aprire MT5
  # -------------------------------------------------------------------
  Titolo "2. GATE SUI FILE PROVA"
  $mappe = @{}
  $magicVisti = @{}
  foreach($f in @(Get-ChildItem $Prove -Filter *.txt)){
    $righe = RigheVive $f.FullName
    $h = @{}
    $nY = 0
    $nomeY = ""
    foreach($r in $righe){
      if($r -match '^@'){
        $parti = ($r -split '\s+',2)
        $h[$parti[0]] = $parti[1].Trim()
        continue
      }
      $i = $r.IndexOf("=")
      if($i -lt 0){ continue }
      $nome = $r.Substring(0,$i).Trim()
      $val  = $r.Substring($i+1).Trim()
      if($h.ContainsKey($nome)){ throw ($f.Name + ": DUE righe per '" + $nome + "'. In [TesterInputs] un parametro doppio fa fare a MT5 ZERO passate.") }
      $h[$nome] = $val
      if($val -match '\|\|Y\s*$'){ $nY++; $nomeY = $nome }
    }
    if($nY -ne 1){ throw ($f.Name + ": deve avere ESATTAMENTE un asse con flag Y, trovati " + $nY + ".") }
    if($nomeY -ne "InpMagic"){ throw ($f.Name + ": l'unico asse Y deve essere InpMagic, invece e' " + $nomeY + ". Questo e' un PASSO 0, non la griglia della BOZZA.") }
    $mappe[$f.Name] = $h
  }

  $hNudo = $mappe["ABTG_VwapRevert.txt"]
  if($null -eq $hNudo){ throw "manca la mappa del 00_nudo: senza, il gate della stella non e' eseguibile." }

  foreach($c in $Ordinati){
    $h = $mappe[$c.Prova]
    if($null -eq $h){ throw ("mappa mancante per " + $c.Prova) }

    # GATE GEOMETRIA: simbolo, periodo, storico
    if($h["@SIMBOLO"]  -ne $Simbolo){  throw ($c.Prova + ": @SIMBOLO e' " + $h["@SIMBOLO"] + ", atteso " + $Simbolo) }
    if($h["@PERIODO"]  -ne $Periodo){  throw ($c.Prova + ": @PERIODO e' " + $h["@PERIODO"] + ", atteso " + $Periodo + " (trappola R102)") }
    if($h["@DAQUANDO"] -ne $DaQuando){ throw ($c.Prova + ": @DAQUANDO e' " + $h["@DAQUANDO"] + ", atteso " + $DaQuando) }

    # GATE DEI VALORI: quanto valgono i tre interruttori IN QUESTO FILE.
    # Prende il caso che il diff non puo' vedere: due file SCAMBIATI.
    $vl = ($h["InpAllowLong"]      -split '\|\|')[0]
    $vs = ($h["InpAllowShort"]     -split '\|\|')[0]
    $vf = ($h["InpFlatFineSeduta"] -split '\|\|')[0]
    if($vl -ne $c.VLong){  throw ($c.Prova + ": InpAllowLong vale "      + $vl + ", la cella " + $c.Id + " lo vuole " + $c.VLong) }
    if($vs -ne $c.VShort){ throw ($c.Prova + ": InpAllowShort vale "     + $vs + ", la cella " + $c.Id + " lo vuole " + $c.VShort) }
    if($vf -ne $c.VFlat){  throw ($c.Prova + ": InpFlatFineSeduta vale " + $vf + ", la cella " + $c.Id + " lo vuole " + $c.VFlat) }

    # GATE DELLA BASELINE ASSOLUTA. E' quello che prende la corruzione
    # SIMMETRICA: una riga storta UGUALE in tutti e quattro i file
    # passerebbe il gate della stella a mani basse.
    foreach($k in @($Baseline.Keys)){
      if(-not $h.ContainsKey($k)){ throw ($c.Prova + ": manca il pin di '" + $k + "'. Senza il pin in forma completa MT5 rispazzola il flag che ricorda dall'ultima griglia di questo EA.") }
      $v = ($h[$k] -split '\|\|')[0]
      if($v -ne $Baseline[$k] -and -not (@($c.Diff) -contains $k)){
        throw ($c.Prova + ": '" + $k + "' vale " + $v + ", la baseline dichiarata di questo PASSO 0 lo vuole " + $Baseline[$k] + ".")
      }
    }

    # GATE DELLA STELLA: contro il 00_nudo cambia SOLO cio' che e'
    # dichiarato in Diff, piu' InpMagic. Confronto PER NOME, mai per
    # posizione: un file con una riga in piu' sfaserebbe tutto il resto.
    $ammessi = @("InpMagic") + @($c.Diff)
    foreach($k in @($h.Keys)){
      if($k -match '^@'){ continue }
      if($ammessi -contains $k){ continue }
      if($hNudo[$k] -ne $h[$k]){ throw ($c.Prova + ": '" + $k + "' differisce dal 00_nudo e NON e' un delta dichiarato.") }
    }
    foreach($k in @($c.Diff)){
      if($hNudo[$k] -eq $h[$k]){ throw ($c.Prova + ": '" + $k + "' DOVEVA differire dal 00_nudo e non differisce.") }
    }

    # GATE DEI MAGIC: vergini, unici, mai uno vietato.
    $mg = $h["InpMagic"] -split '\|\|'
    foreach($v in @($mg[1],$mg[3])){
      $n = [int]$v
      if($MagicVietati -contains $n){ throw ($c.Prova + ": magic " + $n + " e' VIETATO (sedia viva, round recente o PASSO 0 gemello).") }
      if($magicVisti.ContainsKey($n)){ throw ("magic " + $n + " usato in due celle: " + $magicVisti[$n] + " e " + $c.Prova) }
      $magicVisti[$n] = $c.Prova
    }
    if([int]$mg[1] -ne $c.M1 -or [int]$mg[3] -ne $c.M2){
      throw ($c.Prova + ": i magic gemelli sono " + $mg[1] + "/" + $mg[3] + ", la cella " + $c.Id + " li vuole " + $c.M1 + "/" + $c.M2)
    }
  }
  Dico "geometria, valori dei tre interruttori, baseline assoluta, stella e magic: TUTTI PASSATI" "Green"

  # -------------------------------------------------------------------
  #  3. L'INCLUDE E LA COMPILAZIONE -- i due pezzi che il driver
  #     generico non fa (l'include) o fa troppo tardi (la compilazione).
  # -------------------------------------------------------------------
  Titolo "3. INSTALLO L'INCLUDE E COMPILO"
  # IL SELETTORE E' LO STESSO, RIGA PER RIGA, DI walkforward_generico.ps1
  # (righe 545-549 e 586-589). Prima qui c'era "il primo origin.txt che
  # contiene BCM": su una macchina con due istanze (la -V3 del 100k
  # esiste, CHECKLIST punto 26) i due script potevano scegliere
  # TERMINALI DIVERSI -- l'include installato in uno e la compilazione
  # fatta nell'altro, cioe' il difetto del punto 27 con l'aggravante che
  # nessuno se ne accorge. Se il selettore del driver cambia, cambia
  # anche questo: si toccano insieme.
  $allTerm = @(Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue)
  $c = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*" } | Select-Object -First 1
  if(-not $c){ $c = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets*" } | Select-Object -First 1 }
  if(-not $c){ throw "terminale BCM non trovato: e' lo stesso selettore di walkforward_generico.ps1." }
  $instDir = $c.DirectoryName
  $MetaEditor = Join-Path $instDir "metaeditor64.exe"
  $termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
  $dataFolder = (Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue | Where-Object { $o = Join-Path $_.FullName "origin.txt"; (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $instDir) } | Select-Object -First 1 -ExpandProperty FullName)
  if(-not $dataFolder){ throw ("cartella dati non trovata per " + $instDir) }
  Dico ("terminale scelto: " + $instDir + "  (DEVE essere lo stesso che stampa il driver generico)") "Yellow"

  # LA COPIA SI VERIFICA SUL CONTENUTO, NON SUL NOME (punto 27-ter): se
  # in Include esistesse una CARTELLA con quel nome, Copy-Item ci
  # metterebbe il file DENTRO e Test-Path direbbe verde lo stesso.
  $incDir = Join-Path $dataFolder "MQL5\Include"
  New-Item -ItemType Directory -Force -Path $incDir | Out-Null
  $len = (Get-Item -LiteralPath $incSrc).Length
  Copy-Item $incSrc -Destination $incDir -Force
  $v = Get-Item -LiteralPath (Join-Path $incDir "ABTG_PausaGuardian.mqh") -ErrorAction Stop
  if($v.PSIsContainer -or $v.Length -ne $len){ throw "include copiato ma NON verificato (lunghezza diversa)." }
  $Include = "INSTALLATO e VERIFICATO in " + $incDir
  Dico $Include "Green"

  # --- LA COMPILAZIONE, IN ENTRAMBI I RAMI (controllo E corsa vera).
  #     QUESTO EA NON E' MAI STATO COMPILATO DA NESSUNO. Un giro di
  #     controllo che non compila non controlla la cosa piu' probabile
  #     che vada storta: costava un minuto scoprirlo, e invece si
  #     scopriva a corsa avviata dentro il driver generico, che muore con
  #     "compilazione fallita" senza dire perche' (punto 20/27).
  #     L'.ex5 si CANCELLA prima: senza, un binario vecchio farebbe
  #     passare per riuscita una compilazione fallita (punto 23).
  $mq5 = Join-Path $Work "ABTG_VwapRevert.mq5"
  Scarica ($RawPin + "/mql5/Experts/ABTG_VwapRevert.mq5") $mq5
  $dstMq5 = Join-Path $dataFolder "MQL5\Experts\ABTG_VwapRevert.mq5"
  New-Item -ItemType Directory -Force -Path (Join-Path $dataFolder "MQL5\Experts") | Out-Null
  Copy-Item $mq5 -Destination $dstMq5 -Force
  $ex5 = Join-Path $dataFolder "MQL5\Experts\ABTG_VwapRevert.ex5"
  Remove-Item -LiteralPath $ex5 -Force -ErrorAction SilentlyContinue
  $t0 = Get-Date
  & $MetaEditor ("/compile:" + $dstMq5) "/log" | Out-Null
  while((-not (Test-Path -LiteralPath $ex5)) -and ((New-TimeSpan -Start $t0 -End (Get-Date)).TotalSeconds -lt 180)){ Start-Sleep -Seconds 2 }
  if(-not (Test-Path -LiteralPath $ex5)){
    $log = Join-Path $dataFolder "MQL5\Experts\ABTG_VwapRevert.log"
    if(Test-Path $log){ Get-Content $log -Tail 40 | ForEach-Object { Write-Host $_ -ForegroundColor Red } }
    throw "COMPILAZIONE FALLITA: l'EA non era mai stato compilato. Gli errori sono qui sopra."
  }
  Dico "compilato: ABTG_VwapRevert.ex5" "Green"
  $Compilazione = "OK (" + $ex5 + ")"

  # -------------------------------------------------------------------
  #  4. LE CORSE
  # -------------------------------------------------------------------
  Titolo "4. LE CORSE"
  $Risultati = Join-Path $Work ("risultati_prove\" + $EA)
  foreach($c in $Ordinati){
    Dico ("cella " + $c.Id + " -- " + $c.Desc) "Cyan"
    # NON si chiama $args: e' una VARIABILE AUTOMATICA di PowerShell, e
    # riusarla come nome proprio e' la classe di difetto che la checklist
    # di casa vieta.
    $argv = @("-ExecutionPolicy","Bypass","-File",$drv,
              "-Expert",$EA,
              "-Prova",(Join-Path $Prove $c.Prova),
              "-Etichetta",$c.Id,
              "-Simbolo",$Simbolo,
              "-Periodo",$Periodo,
              "-DaQuando",$DaQuando,
              "-Fino",$Fino,
              "-Modello","4",
              "-Deposito",("" + $Deposito))
    if($SoloControllo){ $argv += "-SoloControllo" }
    if($Rifai){ $argv += "-Rifai" }
    $global:LASTEXITCODE = 0
    & powershell $argv
    $rc = $LASTEXITCODE
    if($rc -ne 0){
      $c.Esito = "FERMATA (codice " + $rc + ")"
      [void]$Problemi.Add("cella " + $c.Id + ": il driver generico e' uscito con codice " + $rc)
      continue
    }
    if($SoloControllo){ $c.Esito = "CONTROLLO OK"; continue }

    $csvIS  = Join-Path $Risultati ($EA + "_" + $Simbolo + "_IS_"  + $c.Id + ".csv")
    $csvOOS = Join-Path $Risultati ($EA + "_" + $Simbolo + "_OOS_" + $c.Id + ".csv")
    $rIS  = LeggiOpt $csvIS
    $rOOS = LeggiOpt $csvOOS
    if($null -eq $rIS -or $null -eq $rOOS){
      $c.Esito = "CSV NON LEGGIBILE"
      [void]$Problemi.Add("cella " + $c.Id + ": CSV mancante o intestazioni non riconosciute. Viste: " + ($script:CsvIntestazioni -join " | "))
      continue
    }
    $c.Gemelli = Gemelli $rOOS
    $c.NIS   = $rIS[0].N;   $c.NOOS   = $rOOS[0].N
    $c.PfIS  = $rIS[0].Pf;  $c.PfOOS  = $rOOS[0].Pf
    $c.DdIS  = $rIS[0].Dd;  $c.DdOOS  = $rOOS[0].Dd
    $c.ProfIS= $rIS[0].Profit; $c.ProfOOS = $rOOS[0].Profit
    if($null -ne $rOOS[0].Pg){ $c.PgOOS = $rOOS[0].Pg }
    $c.Autotest     = $rOOS[0].Autotest
    $c.FlatGiorni   = $rOOS[0].FlatGiorni
    $c.FlatChiusure = $rOOS[0].FlatChiusure
    $c.Esito = "MISURATA"
    if($c.Gemelli -ne "IDENTICI"){
      [void]$Problemi.Add("cella " + $c.Id + ": gemelli " + $c.Gemelli + " -- il banco non e' deterministico, il numero non si legge (cancello S2).")
    }

    # --- I GATE DI COLLAUDO. Sono la ragione per cui l'autotest e il
    #     flat sono usciti in colonna: in ottimizzazione le Print degli
    #     agent non le legge nessuno (CHECKLIST punto 34), quindi
    #     "l'autotest e' verde" non era MAI stato verificato da niente.
    if($null -eq $c.Autotest -or $c.Autotest -lt 0){
      [void]$Problemi.Add("cella " + $c.Id + ": AUTOTEST NON ESEGUITO (colonna assente o -1): i numeri non hanno gate.")
    }
    elseif($c.Autotest -gt 0){
      [void]$Problemi.Add("cella " + $c.Id + ": AUTOTEST DIVERGE (" + $c.Autotest + " blocchi falliti): i numeri NON si leggono.")
    }
    # la gamba IS gira con lo stesso binario: se li' l'autotest diverge,
    # e' lo stesso codice a essere rotto, e va detto anche se l'OOS tace.
    if($null -ne $rIS[0].Autotest -and $rIS[0].Autotest -gt 0){
      [void]$Problemi.Add("cella " + $c.Id + ": AUTOTEST DIVERGE nella gamba IS (" + $rIS[0].Autotest + " blocchi falliti).")
    }
    if($c.VFlat -eq "1" -and $c.FlatGiorni -eq 0){
      [void]$Rilievi.Add("cella " + $c.Id + ": flat ACCESO ma scattato in ZERO giornate.")
    }
    if($c.VFlat -eq "0" -and $c.FlatGiorni -gt 0){
      [void]$Problemi.Add("cella " + $c.Id + ": flat SPENTO eppure scattato: l'interruttore non morde.")
    }
  }
}
catch{
  $Fatale = ("" + $_.Exception.Message)
  Write-Host ""
  Write-Host ("!!! FERMATO: " + $Fatale) -ForegroundColor Red
}

# =====================================================================
#  RACCOLTA -- SEMPRE, anche quando la corsa si e' fermata a meta'.
#  Regola di casa: i risultati finiscono sul Desktop e in uno zip.
# =====================================================================
Titolo "RACCOLTA"
$Cart = Join-Path $Dsk ("PASSO0_VWAPREV_" + $Modo + "_" + $Stamp)
New-Item -ItemType Directory -Force -Path $Cart | Out-Null

$RefTxt = New-Object System.Collections.ArrayList
[void]$RefTxt.Add("=====================================================================")
[void]$RefTxt.Add(" PASSO 0 -- VWAP REVERT (ABTG_VwapRevert) su " + $Simbolo + " " + $Periodo)
[void]$RefTxt.Add("=====================================================================")
[void]$RefTxt.Add("modo: " + $Modo + "   <- CONTROLLO = giro a vuoto, NON e' il risultato")
[void]$RefTxt.Add("data: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV))
[void]$RefTxt.Add("pin:  " + $Pin)
[void]$RefTxt.Add("finestra: " + $DaQuando + " -> " + $Fino + "  (split 40/60)")
[void]$RefTxt.Add("banco: Modello 4 TICK REALI, deposito " + $Deposito + ", rischio " + $Baseline["InpRiskPercent"] + "% (letto dal file prova, non da un parametro)")
[void]$RefTxt.Add("include: " + $Include)
[void]$RefTxt.Add("compilazione: " + $Compilazione)
[void]$RefTxt.Add("")
[void]$RefTxt.Add("QUESTO NON E' UN ROUND E NON DA' NESSUN VERDETTO.")
[void]$RefTxt.Add("E' un CONTA-OPERAZIONI: misura la FREQUENZA del motore VWAP REVERT")
[void]$RefTxt.Add("e il COSTO della regola intraday. Il PF qui sotto si LEGGE ma NON si")
[void]$RefTxt.Add("giudica: i criteri di merito della BOZZA sono [DA FIRMARE], e quattro")
[void]$RefTxt.Add("celle non sono un round.")
[void]$RefTxt.Add("")
[void]$RefTxt.Add("LA DOMANDA DEL PASSO 0 (dossier P1): quante operazioni per lato?")
[void]$RefTxt.Add("  A. n per lato >= 150 IS -> campione c'e', il round si puo' disegnare")
[void]$RefTxt.Add("  B. n per lato <  150 IS -> MERITO SOSPESO (valvola R59 / regola B),")
[void]$RefTxt.Add("                             il RISCHIO si giudica lo stesso")
[void]$RefTxt.Add("  C. n enorme             -> alzare InpSigmaMult (banda piu' selettiva),")
[void]$RefTxt.Add("                             NON il rischio e NON un filtro nuovo")
[void]$RefTxt.Add("")
[void]$RefTxt.Add("--- LA TABELLA ---")
[void]$RefTxt.Add("cella         n IS   n OOS   PF IS   PF OOS  DD OOS%  Prof OOS  PeggGio%  gemelli")
foreach($c in $CELLE){
  $riga = ("{0,-12} {1,6} {2,7} {3,7} {4,8} {5,8} {6,9} {7,9}  {8}" -f `
           $c.Id, (FmtN $c.NIS), (FmtN $c.NOOS), (Fmt2 $c.PfIS), (Fmt2 $c.PfOOS),
           (Fmt2 $c.DdOOS), (FmtE $c.ProfOOS), (FmtPg $c.PgOOS), $c.Gemelli)
  [void]$RefTxt.Add($riga)
  # LE TRE COLONNE DI COLLAUDO, lette dal CSV (gamba OOS). Non sono
  # metriche di merito: dicono se le altre si possono leggere.
  [void]$RefTxt.Add(("              collaudo: autotest falliti = {0} (atteso 0) | flat giorni = {1} | flat chiusure = {2}   [flat dichiarato: {3}]" -f `
                     (FmtCol $c.Autotest), (FmtCol $c.FlatGiorni), (FmtCol $c.FlatChiusure), $c.VFlat))
  [void]$RefTxt.Add("              esito: " + $c.Esito + "  |  " + $c.Desc)
}
[void]$RefTxt.Add("")
[void]$RefTxt.Add("--- COME SI LEGGE, e sono quattro avvertenze, non quattro note ---")
[void]$RefTxt.Add("1. n(01_long) + n(02_short) NON FA n(00_nudo), e NON e' un guasto.")
[void]$RefTxt.Add("   MISURATO NEL SORGENTE (OnNewBar): il giro esce con")
[void]$RefTxt.Add("   'if(CountPositions()>0) return' PRIMA di guardare il lato, e dopo")
[void]$RefTxt.Add("   un PiazzaOrdine long fa 'return' senza valutare lo short (una sola")
[void]$RefTxt.Add("   decisione per barra). Con un lato spento lo slot resta libero.")
[void]$RefTxt.Add("2. LA FINESTRA E' UN SOLO REGIME RIALZISTA (21 mesi di feed BCM sugli")
[void]$RefTxt.Add("   indici). Il lato SHORT parte svantaggiato PER REGIME, non per")
[void]$RefTxt.Add("   merito del motore. Un 'niente edge short' letto qui chiude la")
[void]$RefTxt.Add("   domanda per QUESTA EPOCA, non in assoluto.")
[void]$RefTxt.Add("3. LA CELLA 03_overnight NON PUO' VINCERE. Anche se facesse meglio del")
[void]$RefTxt.Add("   00_nudo NON diventa la cella da mandare in campo: tenere posizioni")
[void]$RefTxt.Add("   overnight e' incompatibile con FTMO Standard (leva 1:100) sul conto")
[void]$RefTxt.Add("   finanziato, che e' il posto per cui questo candidato esiste. Serve a")
[void]$RefTxt.Add("   sapere QUANTO stiamo pagando per restare a 1:100. Se il divario")
[void]$RefTxt.Add("   fosse enorme, la conseguenza e' 'questo non e' un motore intraday',")
[void]$RefTxt.Add("   non 'accendiamo l'overnight'.")
[void]$RefTxt.Add("   E IL COSTO NON E' UN COSTO PURO: il costo si legge come delta di Prof")
[void]$RefTxt.Add("   OOS e di n fra 00_nudo e 03_overnight. Non e' un costo puro: col flat")
[void]$RefTxt.Add("   spento la posizione notturna tiene occupato lo slot")
[void]$RefTxt.Add("   (if(CountPositions()>0) return) e blocca gli ingressi del giorno dopo")
[void]$RefTxt.Add("   -- un n piu' basso qui e' anche meccanica dello slot, non solo")
[void]$RefTxt.Add("   mercato. Il P&L delle sole posizioni che attraversano la notte questo")
[void]$RefTxt.Add("   giro non lo misura.")
[void]$RefTxt.Add("4. IL CANCELLO S0 (il costo) NON E' ADJUDICABILE OGGI, e non si stima:")
[void]$RefTxt.Add("   lo spread medio di BCM su " + $Simbolo + " in M15 NON e' misurato in casa, e")
[void]$RefTxt.Add("   il rapporto punti MT5 / punti indice su " + $Simbolo + " NON e' agli atti")
[void]$RefTxt.Add("   (R97 lo ha misurato su U30USD e NASUSD, non sul DAX). Si legge la")
[void]$RefTxt.Add("   mediana del take LORDO nell'export per-trade in Common\Files:")
[void]$RefTxt.Add("     abtg_trades_ABTG_VwapRevert_" + $Simbolo + "_<magic>.csv")
[void]$RefTxt.Add("   ATTENZIONE: quel file porta il MAGIC nel nome, non la finestra: la")
[void]$RefTxt.Add("   gamba OOS SOVRASCRIVE la gamba IS dello stesso magic.")
[void]$RefTxt.Add("")
[void]$RefTxt.Add("--- LE TRE COLONNE DI COLLAUDO, e non si guardano nella scheda Esperti ---")
[void]$RefTxt.Add("In OTTIMIZZAZIONE le Print girano sugli agent e NON LE LEGGE NESSUNO.")
[void]$RefTxt.Add("Percio' l'autotest e il flat escono in COLONNA nel CSV, e questo referto")
[void]$RefTxt.Add("le stampa sotto ogni cella:")
[void]$RefTxt.Add("  'autotest falliti' = 0  -> la riga 'esito motore:' dell'EA dice DIECI")
[void]$RefTxt.Add("                            BLOCCHI SU DIECI: i numeri si leggono.")
[void]$RefTxt.Add("  'autotest falliti' > 0  -> DIVERGE: i numeri di questa tabella NON si")
[void]$RefTxt.Add("                            leggono, c'e' da guardare il codice.")
[void]$RefTxt.Add("  'autotest falliti' non-eseg / assente -> nessun gate: il numero e'")
[void]$RefTxt.Add("                            senza collaudo, e va detto.")
[void]$RefTxt.Add("  'flat giorni' = giornate in cui il flat e' scattato. Col flat ACCESO")
[void]$RefTxt.Add("                  uno zero e' un rilievo; col flat SPENTO un valore >0 e'")
[void]$RefTxt.Add("                  un problema: l'interruttore non morde.")
[void]$RefTxt.Add("  'flat chiusure' = posizioni davvero chiuse dal flat, in totale.")
[void]$RefTxt.Add("")
if($Fatale -ne ""){
  [void]$RefTxt.Add("!!! FERMATO: " + $Fatale)
  [void]$RefTxt.Add("")
}
[void]$RefTxt.Add("PROBLEMI: " + $Problemi.Count)
foreach($p in $Problemi){ [void]$RefTxt.Add("  - " + $p) }
[void]$RefTxt.Add("RILIEVI: " + $Rilievi.Count)
foreach($p in $Rilievi){ [void]$RefTxt.Add("  - " + $p) }
[void]$RefTxt.Add("")
[void]$RefTxt.Add('COME SI RIPRENDE: si riparte dalla pagina righe/RIGA_PASSO0_VWAPREV_DA_MANDARE.md,')
[void]$RefTxt.Add('NON da questa riga: $p e $pin nascono dentro il blocco e non sopravvivono.')

$refPath = Join-Path $Cart "REFERTO_PASSO0_VWAPREV.txt"
Set-Content -LiteralPath $refPath -Value ($RefTxt -join "`r`n") -Encoding ASCII
Write-Host ($RefTxt -join "`r`n")

# --- gli artefatti: solo cio' che ha girato, copiato PER NOME.
foreach($c in $Ordinati){
  $src = Join-Path $Prove $c.Prova
  if(Test-Path -LiteralPath $src){ Copy-Item $src -Destination $Cart -Force }
  foreach($tag in @("IS","OOS")){
    $f = Join-Path $Work ("risultati_prove\" + $EA + "\" + $EA + "_" + $Simbolo + "_" + $tag + "_" + $c.Id + ".csv")
    if(Test-Path -LiteralPath $f){ Copy-Item $f -Destination $Cart -Force }
  }
}
$zip = $Cart + ".zip"
Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $zip -Force
Write-Host ""
Write-Host ("CARTELLA: " + $Cart) -ForegroundColor Green
Write-Host ("ZIP DA MANDARE: " + $zip) -ForegroundColor Green
Write-Host "FILE ATTESI NELLO ZIP: REFERTO_PASSO0_VWAPREV.txt + i file prova girati + i CSV IS/OOS" -ForegroundColor Gray

if($Fatale -ne ""){ Write-Host "ESITO: FERMATO" -ForegroundColor Red; exit 1 }
if($Problemi.Count -gt 0){ Write-Host "ESITO: COMPLETATO CON PROBLEMI" -ForegroundColor Yellow; exit 1 }
Write-Host ("ESITO: " + $Modo + " COMPLETATO") -ForegroundColor Green
exit 0
