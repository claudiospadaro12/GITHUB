# =====================================================================
#  MARCATORE_RIGA_PREOPEN_DAX_v1
#  RIGA_PREOPEN_DAX.ps1  --  IL LIVELLO PRE-APERTURA SUL DAX
#  ABTG_DAX_Apertura_EU  su  D30EUR  M15, TICK REALI
#  Gemello di RIGA_PREOPEN_DOW.ps1 (Dow, 28/08 mattina): STESSA forma,
#  STESSI criteri, altro mercato e altra sedia viva.
#
#  >>> QUESTO E' UN ROUND CON CRITERI DI MERITO GIA' CONGELATI.
#      NON e' un conta-operazioni come i tre PASSO 0 preparati oggi.
#      I criteri stanno in prove\PREOPEN_RETEST_DAX_M15.txt, sezioni
#      "CRITERI DI ACCETTAZIONE" e "COME PUO' MORIRE", e quel file porta
#      in testa il cartello "NON DEVE GIRARE FINCHE' I CRITERI NON SONO
#      FIRMATI". Questa riga li APPLICA: chi la lancia senza averli
#      letti si trova un verdetto in mano senza sapere cosa vuol dire.
#      La pagina da leggere PRIMA e' righe\RIGA_PREOPEN_DAX_DA_MANDARE.md
#
# ---------------------------------------------------------------------
#  COSA MISURA (e l'ordine NON e' negoziabile: e' il PASSO 0 del file
#  prova, "OBBLIGATORIO, PRIMA DI LEGGERE QUALUNQUE PF")
#
#   FASE COSTO  (0b) una PASSATA SINGOLA sulla cella centro della
#               griglia -> report .htm -> mediana del take LORDO in
#               punti indice. Se FALLITO, IL ROUND SI FERMA QUI e non
#               viene stampato nessun PF di nessuna griglia.
#   FASE METRO  (0c) la cella viva (InpRangeMode=0) rifatta SU M15, sui
#               due lati: e' il denominatore del criterio "+0,10 di PF".
#   FASE GRIGLIA     la griglia 2 assi (InpPrevWindowMin x
#               InpRetestOffsetPts) sui due lati.
#   POI (0a)    si contano le operazioni: n(OOS) < 30 -> valvola R59,
#               niente verdetto di MERITO. Il RISCHIO si legge lo
#               stesso, perche' e' un fatto accaduto.
#   POI         i criteri di accettazione, applicati dal codice e
#               stampati riga per riga col numero accanto.
#
# ---------------------------------------------------------------------
#  QUELLO CHE NON FA, dichiarato:
#   - NON tocca il forward e NON tocca la sedia viva. Il magic vivo
#     (770101) e' nella lista dei VIETATI, e con lui il 770411 della
#     sedia ABTG_MaxMinNotte_DAX_Short_Ottimizzato (l'altra sedia viva
#     sul DAX, quella del sospetto doppione): se uno dei due comparisse
#     in un file prova il round si ferma prima di aprire MT5.
#   - NON scrive una riga di MQL5. L'interruttore InpRangeMode=1 esiste
#     gia' nel sorgente dal primo giorno (ComputeLevels, ramo
#     ABTG_RANGE_PREV): questo round lo ACCENDE, non lo costruisce.
#   - NON scarica storico e non svuota bases\<server>\ticks. I tick di
#     D30EUR dal 2024.09.26 sono agli atti (sonda del 17/08, COMPLETO).
#   - NON misura la SOVRAPPOSIZIONE con ABTG_MaxMinNotte_DAX_Short. La
#     stampa nel referto e' una tabella di CALENDARIO (quanti minuti
#     della finestra del livello cadono dentro il box notturno di quella
#     sedia), non una misura di trade in comune. Le GIORNATE in comune
#     sono il passo successivo, e servono due passate per-trade.
#   - NON misura lo spread. Lo spread di S0a e' DICHIARATO 2,0 punti
#     indice (lato alto della forchetta 1-2 di R98_CRITERI) e ogni
#     verdetto del cancello esce con l'etichetta [SPREAD NON MISURATO].
#   - NON promuove niente in forward. Un round che passa produce una
#     cella candidata, non una sedia.
#
#  QUANTO CI METTE [STIMA, non una previsione]:
#     1 passata singola (costo) + 2x(3x2)x2 = 24 passate di metro
#     + 2x(5x3x2)x2 = 120 passate di griglia = 145 passate a tick reali
#     su 21 mesi di M15. R107 ne fece 24 sulla stessa finestra in 9
#     minuti: stima 50-120 minuti, piu' la compilazione.
#
#  LA RIGA CHE SI INCOLLA sta in righe\RIGA_PREOPEN_DAX_DA_MANDARE.md
# =====================================================================
[CmdletBinding()]
param(
  # -Pin NON ha default: un default silenzioso ("lavoro") farebbe girare
  #  la punta del branch spacciandola per un commit congelato.
  [string]$Pin           = "",
  [switch]$SoloControllo,            # giro a vuoto: NON apre MT5 per misurare
  [switch]$Rifai,                    # rifa' anche i CSV gia' presenti
  [string]$SoloFase      = "",       # "" = tutto | COSTO | METRO | GRIGLIA
  [string]$Simbolo       = "D30EUR",
  [string]$Periodo       = "M15",
  [string]$DaQuando      = "2024.09.26",
  [string]$Fino          = "2026.06.30",
  [int]$Deposito         = 100000,
  [int]$Spread           = 0         # 0 = spread CORRENTE, ma SCRITTO nell'ini
                                     #  invece di restare lo stato nascosto del
                                     #  terminale. E' quello che ha fatto R101,
                                     #  cioe' il round da cui viene il metro.
)
$ErrorActionPreference = "Stop"
# --- LA RETE DI SICUREZZA SUL CODICE D'USCITA.
#     MISURATO il 28/08 eseguendo questa riga: un errore fuori dai try
#     (bastava una funzione che si chiamava come un ALIAS) faceva morire
#     lo script DOPO il "FERMATO" e PRIMA dell'exit 1, e pwsh usciva con
#     codice 0. Cioe' il caso peggiore: una corsa esplosa che si presenta
#     come riuscita. Con questo trap un'uscita anomala e' SEMPRE 1.
trap {
  Write-Host ""
  Write-Host ("!!! ERRORE NON GESTITO: " + $_.Exception.Message) -ForegroundColor Red
  Write-Host ("    " + $_.InvocationInfo.PositionMessage) -ForegroundColor DarkRed
  Write-Host "ESITO: FERMATO (errore non gestito) -- il referto potrebbe essere incompleto." -ForegroundColor Red
  exit 1
}
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

$EA     = "ABTG_DAX_Apertura_EU"
$Avvio  = Get-Date
$Stamp  = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
$Dsk    = Join-Path $env:USERPROFILE "Desktop"
$Work   = Join-Path $env:USERPROFILE "abtg_preopen_dax"
$Prove  = Join-Path $Work "prove"
$RawPin = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

# --- TUTTO CIO' CHE LA RACCOLTA USA NASCE QUI, PRIMA DEL try.
#     In PowerShell una `function` non e' dichiarativa, e' un'ISTRUZIONE:
#     se il flusso non ci passa sopra il nome non esiste, e la raccolta
#     esploderebbe proprio nella corsa fermata da un gate, cioe' l'unica
#     in cui il referto serve davvero.
$Problemi  = New-Object System.Collections.ArrayList
$Rilievi   = New-Object System.Collections.ArrayList
$Fatale    = ""
$Include   = "NON INSTALLATO"
$Terminale = "n/d"
$Compilato = "NON TENTATA"
$RiskEA    = "n/d"
$IS_Da = "n/d"; $IS_A = "n/d"; $OOS_Da = "n/d"; $OOS_A = "n/d"
$Modo      = "CORSA"
if($SoloControllo){ $Modo = "CONTROLLO" }

# =====================================================================
#  I NUMERI DEL ROUND. Stanno tutti qui, in cima, e ognuno ha la sua
#  fonte accanto: un numero senza fonte e' un numero pescato.
# =====================================================================
#--- S0a, il cancello del costo (PASSO 0b del file prova)
$SpreadDich  = 2.0     # punti indice. [SPREAD NON MISURATO] lato alto
                       #  della forchetta 1-2 di R98_CRITERI.
$S0aMult     = 3.0     # take LORDO mediano >= 3 x spread  (R109_CRITERI S0a)
$S0aBanda    = 0.5     # dentro 3,0 +- 0,5 il verdetto e' SOSPESO, non secco:
                       #  la soglia poggia su uno spread NON MISURATO.
$SogliaTake  = $S0aMult * $SpreadDich    # = 6,0 punti indice, la "soglia
                       #  operativa" scritta nel file prova. CALCOLATA, non
                       #  ricopiata: se qualcuno cambia lo spread dichiarato
                       #  la soglia si muove da sola e non diverge.
$PuntoIndice = 1.0     # 1 punto indice = 1,00 di PREZZO su D30EUR.
                       #  MISURATO: cifre=2, tick=0.10 -> 1 punto indice =
                       #  100 punti MT5 (R97/R98, R109_CRITERI par. 308-311,
                       #  README_ABTG_Aperture riga 141). Vale identico su
                       #  D30EUR, U30USD e NASUSD. Su un indice il "pip"
                       #  NON ESISTE.

#--- i criteri di accettazione (PASSA, dal file prova). Copiati UNA volta
#    sola, qui, e stampati nel referto accanto ai numeri misurati.
$CritPF      = 1.10    # PF >= 1,10   (pavimento di casa)
$CritN       = 30      # n  >= 30     (sotto i 30 non e' un verdetto: R59)
$CritDD      = 8.0     # DD <  8%     a rischio 1%
$CritPegg    = -2.0    # peggior giornata > -2,0%  (cancello prop inasprito)
$CritRegione = 3       # >= 3 celle ADIACENTI
$CritDeltaPF = 0.10    # e la regione deve BATTERE il metro di +0,10 di PF
$FattoreProp = 0.65    # per rileggere il DD a taglia 100k (rischio 0,65%)

#--- gli assi della griglia. NON scritti a memoria: si RICAVANO dal file
#    prova (funzione AssiDi) e questi qui sono solo l'ATTESO con cui si
#    confrontano. Se il file prova cambia, il gate lo dice.
$PWattesi = @(60,120,180,240,300)
$ROattesi = @(200,400,600)

#--- I MAGIC VIETATI. Un'identita' non in campo resta comunque occupata.
#    770101 e' IL MAGIC VIVO di questa sedia e 770411 quello dell'ALTRA
#    sedia viva sul DAX (MaxMinNotte Short): se uno dei due comparisse in
#    un file prova, il tester incrocerebbe i deal del forward.
#    Sono VIETATI anche i magic gia' BRUCIATI da un round precedente
#    (R101, R107, e i cinque blocchi del round PREOPEN DOW del 28/08):
#    riusarli mescolerebbe i deal di due misure diverse nella cache del
#    tester e negli export per-trade, che portano il magic nel nome.
$MagicVietati = @(770101,                                  # <<< LA SEDIA VIVA DAX
                  770411,                                  # <<< L'ALTRA SEDIA VIVA SUL DAX
                                                           #     (MaxMinNotte DAX Short:
                                                           #      e' il sospetto doppione,
                                                           #      e non deve nemmeno poter
                                                           #      girare per sbaglio qui)
                  770202,770201,770511,770601,770611,770901,
                  971501,770402,970901,970912,970913,770532,
                  773200,773201,773230,773231,             # R101 metro DAX (bruciati)
                  773300,773301,                           # R101 metro Dow
                  773500,773501,773600,773601,             # round PREOPEN DOW (28/08)
                  773700,773701,773800,773801,773900,773901,
                  761200,761201,                           # R107 (bruciati)
                  750010,                                  # default del MaxMinNotte _MFE
                  772341,772601,772602,772611,772612,
                  774401,775501,
                  776000,776001,776100,776101,776400,776401)

#--- IL BOX NOTTURNO DELLA SEDIA VIVA GEMELLA, in minuti dalla
#    mezzanotte SERVER. LETTO NEL SORGENTE il 28/08
#    (ABTG_MaxMinNotte_DAX_Short_Ottimizzato_MFE.mq5, righe 71-74:
#     InpBoxStartHour=23 InpBoxStartMin=0 / InpBoxEndHour=4
#     InpBoxEndMin=59). Ordini STOP posati alle 07:59 (righe 79-80),
#    cutoff ingressi 08:30 (righe 81-82), flat 17:30, SHORT ONLY
#    (righe 91-92). Serve per la TABELLA DI CALENDARIO del referto.
$BoxDaMin  = 23*60 + 0        # 23:00 server
$BoxAMin   = 4*60 + 59 + 1    # 04:59 compreso -> estremo alto esclusivo
$AperturaMin = 8*60 + 0       # 08:00 server: l'apertura del DAX

# Quanti minuti della finestra [aperturaMin - pw, aperturaMin) cadono
# dentro il box notturno. Il box ATTRAVERSA LA MEZZANOTTE, quindi si
# conta come DUE intervalli: [BoxDaMin,1440) e [0,BoxAMin).
function MinutiNelBox([int]$pw){
  $da = $AperturaMin - $pw
  $a  = $AperturaMin
  if($da -lt 0){ return -1 }        # non gestito: finestra che scavalla
  $tot = 0
  foreach($seg in @(@($BoxDaMin,1440), @(0,$BoxAMin))){
    $lo = [math]::Max($da, $seg[0])
    $hi = [math]::Min($a,  $seg[1])
    if($hi -gt $lo){ $tot += ($hi - $lo) }
  }
  return $tot
}
function OraDiMin([int]$m){
  $mm = (($m % 1440) + 1440) % 1440
  return ("{0:00}:{1:00}" -f [int]([math]::Floor($mm/60)), [int]($mm % 60))
}

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
function Fmt3($v){ if($null -eq $v){ return "n/d" }; if([double]$v -lt 0){ return "n/d" }; return ([double]$v).ToString("0.000",$INV) }
function FmtE($v){ if($null -eq $v){ return "n/d" }; if([double]$v -le -999998.0){ return "n/d" }; return ([double]$v).ToString("+0;-0;0",$INV) }
# la PEGGIOR GIORNATA e' NEGATIVA per costruzione: il sentinella non puo'
# essere "minore di zero" (sarebbe tutto). Il sentinella e' +99.9, e il
# numero esce COL SEGNO, perche' il criterio si legge "> -2,00" e un
# numero senza segno darebbe il verdetto rovesciato (checklist 87).
function FmtPg($v){ if($null -eq $v){ return "n/d" }; if([double]$v -ge 99.0){ return "n/d" }; return ([double]$v).ToString("+0.00;-0.00;0.00",$INV) }

function Mediana($lista){
  $a = @($lista)
  if($a.Count -eq 0){ return $null }
  # Sort-Object su NUMERI e' sicuro (non ci sono chiavi uguali che devono
  # restare in ordine: qui l'ordine di partenza non porta informazione).
  $s = @($a | Sort-Object)
  $m = [int]([math]::Floor($s.Count / 2))
  if($s.Count % 2 -eq 1){ return [double]$s[$m] }
  return ([double]$s[$m-1] + [double]$s[$m]) / 2.0
}

# =====================================================================
#  IL PARSER DEL CSV DI OTTIMIZZAZIONE.
#  Le colonne si cercano PER NOME, mai per posizione. Se non le riconosce
#  torna $null E DICE quali intestazioni ha visto, invece di indovinare.
#  L'intestazione VERA di questo EA, LETTA NEL SORGENTE (OnTesterDeinit,
#  variabile 'head'), e' a UNDICI colonne fisse piu' una colonna per ogni
#  parametro spazzolato, e CONTIENE 'Peggior Giornata %':
#    Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,
#    Sharpe Ratio,Equity DD %,Trades,Peggior Giornata %,
#    Perdite Consecutive Max,Serie Perdente Peggiore,<parametri...>
#  Non e' ereditata da un round gemello (checklist 80).
# =====================================================================
$script:CsvIntestazioni = @()
function LeggiOpt([string]$path){
  if(-not (Test-Path -LiteralPath $path)){ return $null }
  $righe = @()
  try{ $righe = @(Import-Csv -LiteralPath $path) }catch{ return $null }
  if($righe.Count -eq 0){ return $null }
  $cols = @($righe[0].PSObject.Properties.Name)
  $script:CsvIntestazioni = $cols
  $kProf=$null; $kPf=$null; $kDd=$null; $kN=$null; $kPg=$null; $kMg=$null; $kPw=$null; $kRo=$null
  foreach($k in $cols){
    $l = ("" + $k).Trim().ToLower()
    if($l -eq "profit" -or $l -eq "profitto"){ $kProf = $k }
    if($l -eq "profit factor" -or $l -eq "fattore di profitto"){ $kPf = $k }
    if($l -eq "equity dd %" -or $l -eq "drawdown equity %"){ $kDd = $k }
    if($l -eq "trades" -or $l -eq "operazioni"){ $kN = $k }
    if($l -eq "peggior giornata %" -or $l -eq "worst day %"){ $kPg = $k }
    if($l -eq "inpmagic"){ $kMg = $k }
    if($l -eq "inpprevwindowmin"){ $kPw = $k }
    if($l -eq "inpretestoffsetpts"){ $kRo = $k }
  }
  if($null -eq $kProf -or $null -eq $kPf -or $null -eq $kDd -or $null -eq $kN){ return $null }
  $out = New-Object System.Collections.ArrayList
  foreach($r in $righe){
    $pg = $null; if($null -ne $kPg){ $pg = (NumInv $r.$kPg) }
    $mg = "";    if($null -ne $kMg){ $mg = ("" + $r.$kMg).Trim() }
    $pw = $null; if($null -ne $kPw){ $pw = (NumInv $r.$kPw) }
    $ro = $null; if($null -ne $kRo){ $ro = (NumInv $r.$kRo) }
    [void]$out.Add([pscustomobject]@{
      Profit = (NumInv $r.$kProf); Pf = (NumInv $r.$kPf); Dd = (NumInv $r.$kDd)
      N = (NumInv $r.$kN); Pg = $pg; Magic = $mg; Pw = $pw; Ro = $ro })
  }
  return @($out)
}

# --- I GEMELLI: due righe con lo STESSO (Pw,Ro) e magic diverso devono
#     uscire IDENTICHE AL CENTESIMO. E' il controllo d'igiene del banco:
#     se non lo sono, il tester non e' deterministico e nessun numero di
#     quella cella si legge.
$TolGemelli = 0.005
function Gemelli($a,$b){
  if($null -eq $a -or $null -eq $b){ return "NON MISURATO (una delle due righe manca)" }
  foreach($ch in @(@("profitto",$a.Profit,$b.Profit),@("PF",$a.Pf,$b.Pf),@("DD",$a.Dd,$b.Dd),@("n",$a.N,$b.N))){
    if($null -eq $ch[1] -or $null -eq $ch[2]){ return ("NON MISURATO (" + $ch[0] + " illeggibile)") }
    if([math]::Abs([double]$ch[1] - [double]$ch[2]) -gt $TolGemelli){
      return ("DIVERSI su " + $ch[0] + ": " + $ch[1] + " contro " + $ch[2])
    }
  }
  return "IDENTICI"
}

# =====================================================================
#  LETTURA DI UN FILE DI TESTO DI MT5 (report .htm).
#  L'ORDINE NON SI CAMBIA: MISURATO in R99 che il report puo' essere
#  UTF-16, e il tentativo UTF8 su byte UTF-16 produce "<\0t\0r\0", quindi
#  il match fallisce correttamente e si passa a Unicode.
# =====================================================================
function TestoDi([string]$path,[string]$sonda){
  try{
    $by = [IO.File]::ReadAllBytes($path)
    $t = [Text.Encoding]::UTF8.GetString($by)
    if($t -notmatch $sonda){ $t = [Text.Encoding]::Unicode.GetString($by) }
    if($t -notmatch $sonda){ $t = [Text.Encoding]::GetEncoding(1252).GetString($by) }
    return $t
  }catch{ return "" }
}

# =====================================================================
#  IL PARSER DEI DEAL DEL REPORT .htm  (quello di R100/R102/R103/R108/
#  R109, che nasce dal bug di R99: il parser cercava 'balance'/'saldo' e
#  MT5 in italiano scrive BILANCIO, quindi tornava una lista vuota su una
#  tabella perfettamente leggibile).
#  Legge anche Tipo, Volume e PREZZO: senza il PREZZO non esiste nessun
#  take in punti indice, cioe' non esiste il cancello del costo.
# =====================================================================
$script:DealIntestazioni = @()
$script:DealColonne = ""
function LeggiDeal([string]$path){
  $txt = TestoDi $path '<t[dr]'
  if($txt -eq ""){ return @() }
  $righe = New-Object System.Collections.ArrayList
  foreach($tr in [regex]::Matches($txt,'(?s)<tr[^>]*>(.*?)</tr>')){
    $celle = New-Object System.Collections.ArrayList
    foreach($td in [regex]::Matches($tr.Groups[1].Value,'(?s)<t[dh][^>]*>(.*?)</t[dh]>')){
      $c = $td.Groups[1].Value
      $c = [regex]::Replace($c,'<[^>]+>','')
      $c = $c.Replace("&nbsp;"," ").Replace([string][char]160," ").Trim()
      [void]$celle.Add($c)
    }
    [void]$righe.Add(@($celle))
  }
  $iOra=-1; $iDir=-1; $iProf=-1; $iSald=-1; $iComm=-1; $iSwap=-1; $iPrez=-1; $iVol=-1; $iTipo=-1
  $viste = New-Object System.Collections.ArrayList
  foreach($celle in $righe){
    if($celle.Count -lt 8){ continue }
    $o=-1; $dz=-1; $p=-1; $s=-1; $c=-1; $w=-1; $pz=-1; $vl=-1; $tp=-1
    for($i=0; $i -lt $celle.Count; $i++){
      $h = ("" + $celle[$i]).ToLower().Trim()
      if($h -eq "time" -or $h -eq "ora" -or $h -eq "orario"){ $o = $i }
      if($h -eq "direction" -or $h -eq "direzione"){ $dz = $i }
      if($h -eq "profit" -or $h -eq "profitto" -or $h -eq "utile"){ $p = $i }
      if($h -eq "balance" -or $h -eq "saldo" -or $h -eq "bilancio"){ $s = $i }
      if($h -eq "commission" -or $h -eq "commissione" -or $h -eq "commissioni"){ $c = $i }
      if($h -eq "swap"){ $w = $i }
      if($h -eq "price" -or $h -eq "prezzo"){ $pz = $i }
      if($h -eq "volume" -or $h -eq "volumi"){ $vl = $i }
      if($h -eq "type" -or $h -eq "tipo"){ $tp = $i }
    }
    # LE INTESTAZIONI SI RACCOLGONO SEMPRE, non solo quando qualcosa e'
    # stato riconosciuto: se NESSUNA colonna viene riconosciuta il
    # messaggio d'errore uscirebbe VUOTO, ed e' il caso in cui serve di
    # piu' (il 23/08 e' servito aprire lo zip a mano per trovare la parola).
    if($viste.Count -lt 6){ [void]$viste.Add(($celle -join " | ")) }
    if($p -ge 0 -and $s -ge 0){ $iOra=$o; $iDir=$dz; $iProf=$p; $iSald=$s; $iComm=$c; $iSwap=$w; $iPrez=$pz; $iVol=$vl; $iTipo=$tp; break }
  }
  $script:DealIntestazioni = @($viste | Select-Object -First 6)
  if($iProf -lt 0 -or $iSald -lt 0){ $script:DealColonne = "PROFITTO/BILANCIO non trovati nell'intestazione."; return @() }
  if($iOra -lt 0){ $iOra = 0 }        # MISURATO: 'Ora' e' la prima colonna
  if($iPrez -lt 0){
    $script:DealColonne = "PREZZO NON TROVATO nell'intestazione: senza il prezzo il take in punti indice NON esiste."
    return @()
  }
  if($iVol -lt 0){
    $script:DealColonne = "VOLUME NON TROVATO nell'intestazione: con le PARZIALI accese, senza il volume le uscite non si accoppiano."
    return @()
  }
  $script:DealColonne = ("Ora=" + $iOra + " Direzione=" + $iDir + " Tipo=" + $iTipo +
                         " Volume=" + $iVol + " Prezzo=" + $iPrez + " Profitto=" + $iProf +
                         " Bilancio=" + $iSald + " Commissioni=" + $iComm + " Swap=" + $iSwap)
  $tutti = @($iOra,$iDir,$iProf,$iSald,$iComm,$iSwap,$iPrez,$iVol,$iTipo)
  $maxi = @($tutti | Measure-Object -Maximum).Maximum
  $out = New-Object System.Collections.ArrayList
  foreach($celle in $righe){
    if($celle.Count -le $maxi){ continue }
    if($celle[$iOra] -notmatch '^\d{4}\.\d{2}\.\d{2} \d{2}:\d{2}:\d{2}$'){ continue }
    # la direzione si legge NELLA SUA COLONNA, non scandendo tutte le
    # celle: un 'in' dentro la colonna COMMENTO farebbe passare per deal
    # una riga qualunque (checklist 58).
    $dir = ""
    if($iDir -ge 0){ $dir = ("" + $celle[$iDir]).ToLower().Trim() }
    if($dir -ne "in" -and $dir -ne "out" -and $dir -ne "in/out"){ continue }
    $d = [datetime]::MinValue
    if(-not [datetime]::TryParseExact($celle[$iOra],"yyyy.MM.dd HH:mm:ss",$INV,[Globalization.DateTimeStyles]::None,[ref]$d)){ continue }
    $pr = (NumInv $celle[$iProf])
    $cm = $null; if($iComm -ge 0){ $cm = (NumInv $celle[$iComm]) }
    $sw = $null; if($iSwap -ge 0){ $sw = (NumInv $celle[$iSwap]) }
    $netto = 0.0
    if($null -ne $pr){ $netto += [double]$pr }
    if($null -ne $cm){ $netto += [double]$cm }
    if($null -ne $sw){ $netto += [double]$sw }
    $tipo = ""; if($iTipo -ge 0){ $tipo = ("" + $celle[$iTipo]).ToLower().Trim() }
    $vol = (NumInv $celle[$iVol])
    $prz = (NumInv $celle[$iPrez])
    # IL CONTROLLO POSITIVO SUL *VALORE*, non solo sulla COLONNA: una
    # cella PIENA che non si converte (decimali in un formato diverso)
    # farebbe uscire zeri PLAUSIBILI E FALSI. Una cella VUOTA vale zero
    # ed e' normale (MT5 lascia vuoto il profitto della riga 'in').
    $illeg = $false
    if($iProf -ge 0 -and $null -eq $pr -and ("" + $celle[$iProf]).Trim() -ne ""){ $illeg = $true }
    if($iComm -ge 0 -and $null -eq $cm -and ("" + $celle[$iComm]).Trim() -ne ""){ $illeg = $true }
    if($iSwap -ge 0 -and $null -eq $sw -and ("" + $celle[$iSwap]).Trim() -ne ""){ $illeg = $true }
    if($null -eq $prz -and ("" + $celle[$iPrez]).Trim() -ne ""){ $illeg = $true }
    if($null -eq $vol -and ("" + $celle[$iVol]).Trim() -ne ""){ $illeg = $true }
    [void]$out.Add([pscustomobject]@{
      Ora=$d; Dir=$dir; Tipo=$tipo; Volume=$vol; Prezzo=$prz; Netto=$netto; Illeggibile=$illeg })
  }
  return @($out)
}

# =====================================================================
#  IL PASSO 0b -- ACCOPPIA I DEAL E TIRA FUORI IL TAKE.
#
#  >>> QUESTA SEDIA HA LE PARZIALI ACCESE, e cambia la matematica.
#      InpTP1_ClosePct=50 + InpBreakevenAtTP1=1: una posizione produce
#      PIU' DI UNA uscita. R109 misurava un motore SENZA parziali e
#      poteva scrivere "volume di 'in' e 'out' diversi -> NON
#      AFFIDABILE"; qui quella regola direbbe NON AFFIDABILE su un
#      motore perfettamente sano. Percio' l'accoppiamento e' a VOLUME
#      RESIDUO, e l'anomalia e' un'altra: un'uscita che chiude PIU' di
#      quanto e' aperto, o un ingresso mentre c'e' gia' una posizione.
#
#  >>> E LA DEFINIZIONE DEL TAKE VA DICHIARATA PRIMA DEI NUMERI, perche'
#      con le parziali non ce n'e' una sola e la scelta NON e' neutra:
#        take_gamba   = |prezzo_out - prezzo_in| di OGNI uscita con
#                       netto > 0. E' la piu' CONSERVATIVA (la prima
#                       parziale e' la piu' corta ed e' quella piu'
#                       esposta al costo) ed e' quella che FA IL
#                       VERDETTO.
#        take_posizione = media PESATA SUI VOLUMI delle uscite di una
#                       stessa posizione, sulle posizioni con netto
#                       totale > 0. E' informativa e si stampa accanto,
#                       cosi' si vede subito se un eventuale FALLITO
#                       dipende dalla definizione invece che dal motore.
#      Le due si stampano tutte e due, SEMPRE. Il verdetto usa la prima.
#
#  >>> NIENTE Sort-Object sull'ORA, ed e' una correzione pagata
#      (R109_INDAGINE_DEAL_2026-08-26): Sort-Object non e' STABILE e sui
#      deal a pari secondo INVENTA anomalie. I deal arrivano dall'.htm in
#      ordine di TICKET, che e' cronologico e non ha pari. Si CONTROLLA
#      che sia cosi' e, se non lo e', NON SI ORDINA ALLA CIECA: si
#      dichiara e non si misura.
# =====================================================================
function PassoCosto($deal,[double]$punto){
  $r = [pscustomobject]@{
    Stato="NON MISURATO"; N=-1; NGambe=-1; Anomalie=0; Prima="n/d"; Ultima="n/d"
    TakeGambaMed=-1.0; TakePosMed=-1.0; PerdGambaMed=-1.0
    VolMin=-1.0; VolMax=-1.0; NVolDistinti=-1 }
  if($null -eq $deal -or @($deal).Count -eq 0){ $r.Stato = "NON MISURATO (nessun deal letto dal report)"; return $r }
  if($punto -le 0){ $r.Stato = "NON MISURATO (punto indice non valido)"; return $r }
  $ordinati = @($deal)
  $fuoriOrdine = 0
  for($i=1; $i -lt $ordinati.Count; $i++){
    if($ordinati[$i].Ora -lt $ordinati[$i-1].Ora){ $fuoriOrdine++ }
  }
  if($fuoriOrdine -gt 0){
    $r.Stato = "NON MISURATO: i deal del report NON arrivano in ordine cronologico (" + $fuoriOrdine + " salti all'indietro). Si assume l'ordine di TICKET dell'.htm e NON si riordina, perche' un Sort-Object sull'ORA non e' stabile e sui deal a pari secondo inventa anomalie."
    return $r
  }
  $apPrezzo = $null; $apResto = 0.0; $apNetto = 0.0; $apPti = 0.0; $apVolTot = 0.0
  $gambeTake = New-Object System.Collections.ArrayList
  $gambePerd = New-Object System.Collections.ArrayList
  $posTake   = New-Object System.Collections.ArrayList
  $volumi    = New-Object System.Collections.ArrayList
  $nPos = 0; $nGambe = 0; $anom = 0; $illegN = 0
  $prima = $null; $ultima = $null
  foreach($d in $ordinati){
    if($d.Illeggibile){ $illegN++ }
    if($d.Dir -eq "in/out"){ $anom++; continue }   # inversione: questo EA non la fa
    if($d.Dir -eq "in"){
      if($apResto -gt 0.000001){ $anom++ }         # due 'in' con una posizione aperta
      if($null -eq $d.Prezzo -or $null -eq $d.Volume){ $anom++; continue }
      $apPrezzo = [double]$d.Prezzo
      $apResto  = [double]$d.Volume
      $apVolTot = [double]$d.Volume
      $apNetto  = [double]$d.Netto
      $apPti    = 0.0
      [void]$volumi.Add([double]$d.Volume)
      if($null -eq $prima){ $prima = $d.Ora }
      continue
    }
    if($d.Dir -eq "out"){
      if($null -eq $apPrezzo -or $apResto -le 0.000001){ $anom++; continue }
      if($null -eq $d.Prezzo -or $null -eq $d.Volume){ $anom++; continue }
      $vOut = [double]$d.Volume
      if($vOut -gt $apResto + 0.000001){ $anom++; $vOut = $apResto }
      $pti = [math]::Abs([double]$d.Prezzo - $apPrezzo) / $punto
      $nGambe++
      if([double]$d.Netto -gt 0){ [void]$gambeTake.Add($pti) } else { [void]$gambePerd.Add($pti) }
      $apPti   += $pti * $vOut
      $apNetto += [double]$d.Netto
      $apResto -= $vOut
      $ultima = $d.Ora
      if($apResto -le 0.000001){
        $nPos++
        if($apNetto -gt 0 -and $apVolTot -gt 0){ [void]$posTake.Add($apPti / $apVolTot) }
        $apPrezzo = $null; $apResto = 0.0; $apNetto = 0.0; $apPti = 0.0; $apVolTot = 0.0
      }
    }
  }
  if($apResto -gt 0.000001){ $anom++ }    # posizione rimasta aperta a fine report
  $r.N = $nPos
  $r.NGambe = $nGambe
  $r.Anomalie = $anom + $illegN
  if($null -ne $prima){ $r.Prima = $prima.ToString("yyyy.MM.dd",$INV) }
  if($null -ne $ultima){ $r.Ultima = $ultima.ToString("yyyy.MM.dd",$INV) }
  # I NUMERI ILLEGGIBILI VENGONO PRIMA DI TUTTO IL RESTO: se il formato
  # dei numeri non e' quello che crediamo, NIENTE di questo blocco si
  # legge, e in particolare il take non esce "0,0" (numero plausibile e
  # falso) ma "n/d".
  if($illegN -gt 0){
    $r.Stato = "NON AFFIDABILE: " + $illegN + " deal hanno numeri PRESENTI ma NON CONVERTIBILI (profitto/commissione/swap/prezzo/volume). Il formato dei numeri del report NON e' quello atteso. Nessuna misura del cancello si da'."
    return $r
  }
  if($anom -gt 0){
    $r.Stato = "NON AFFIDABILE: " + $anom + " deal non accoppiabili (ingresso con posizione gia' aperta, uscita senza ingresso, uscita piu' grande del residuo, o posizione rimasta aperta). Con UNA posizione alla volta questo non deve succedere: la misura NON si da' e non si stima."
    return $r
  }
  if($nPos -eq 0){ $r.Stato = "ZERO OPERAZIONI nella finestra"; return $r }
  $r.TakeGambaMed = -1.0
  $mm = (Mediana $gambeTake); if($null -ne $mm){ $r.TakeGambaMed = [double]$mm }
  $mm = (Mediana $posTake);   if($null -ne $mm){ $r.TakePosMed   = [double]$mm }
  $mm = (Mediana $gambePerd); if($null -ne $mm){ $r.PerdGambaMed = [double]$mm }
  if($volumi.Count -gt 0){
    $r.VolMin = [double](@($volumi | Measure-Object -Minimum).Minimum)
    $r.VolMax = [double](@($volumi | Measure-Object -Maximum).Maximum)
    $r.NVolDistinti = @($volumi | Select-Object -Unique).Count
  }
  $r.Stato = "MISURATO"
  return $r
}

# =====================================================================
#  IL VERDETTO DEL CANCELLO S0a. E' una FUNZIONE e non tre righe in
#  mezzo al flusso, per due motivi: la regola sta in UN posto solo, ed e'
#  PROVABILE senza aprire MT5 (un cancello che non e' mai stato fatto
#  scattare non e' dimostrato).
#  Torna un oggetto, mai una stringa sola: chi chiama ha bisogno anche
#  del lordo e del rapporto per la tabella.
# =====================================================================
function VerdettoS0a([double]$takeNetMed){
  $etich = "  [SPREAD NON MISURATO: " + $SpreadDich.ToString("0.0",$INV) + " punti indice DICHIARATI, R98_CRITERI / METRO_PROP D4]"
  if($takeNetMed -lt 0){
    return [pscustomobject]@{ Lordo=-1.0; Rapporto=-1.0; Esito="NONMISURATO"
      Verdetto=("NON MISURATO (nessuna gamba vincente, o prezzi illeggibili)." + $etich) }
  }
  $lordo = $takeNetMed + $SpreadDich
  $rap   = $lordo / $SpreadDich
  $coda  = ("take LORDO mediano per gamba " + $lordo.ToString("0.0",$INV) + " punti indice = " +
            $rap.ToString("0.00",$INV) + "x lo spread (soglia operativa " + $SogliaTake.ToString("0.0",$INV) + " punti indice = " +
            $S0aMult.ToString("0.0",$INV) + "x)")
  # LA BANDA VIENE PRIMA DEL CONFRONTO, ed e' voluto: un rapporto 3,01x
  # non e' "superato", e' "non lo sappiamo" -- perche' la soglia poggia
  # su uno spread NON MISURATO. Dare un verdetto secco su un numero
  # dentro l'incertezza del suo metro e' il modo piu' elegante di
  # sbagliare (R109_CRITERI S0a, tre stati).
  if([math]::Abs($rap - $S0aMult) -le $S0aBanda){
    return [pscustomobject]@{ Lordo=$lordo; Rapporto=$rap; Esito="SOSPESO"
      Verdetto=("SOSPESO -- " + $coda + ", cioe' DENTRO la banda " +
        ($S0aMult-$S0aBanda).ToString("0.0",$INV) + "-" + ($S0aMult+$S0aBanda).ToString("0.0",$INV) +
        "x: il verdetto NON si da', si misura lo spread e si rilegge." + $etich) }
  }
  if($rap -ge $S0aMult){
    return [pscustomobject]@{ Lordo=$lordo; Rapporto=$rap; Esito="SUPERATO"
      Verdetto=("SUPERATO -- " + $coda + "." + $etich) }
  }
  return [pscustomobject]@{ Lordo=$lordo; Rapporto=$rap; Esito="FALLITO"
    Verdetto=("FALLITO -- " + $coda + ", SOTTO la soglia." + $etich) }
}

# =====================================================================
#  I GATE SULLE DATE. La finestra e' la meta' di quello che un backtest
#  MISURA: se non e' quella dichiarata, il numero non risponde alla
#  domanda -- e MT5 con un ToDate invalido non si sa cosa faccia, quindi
#  non e' nemmeno un errore rumoroso (lezione pagata su R109).
#  Uno guarda gli ARGOMENTI, l'altro l'ARTEFATTO CHE GIRA.
# =====================================================================
function GateDate([string]$eti,[string]$da,[string]$a){
  if($da -notmatch '^\d{4}\.\d{2}\.\d{2}$'){ throw ($eti + ": FromDate non e' una data 'aaaa.mm.gg' ma [" + $da + "].") }
  if($a  -notmatch '^\d{4}\.\d{2}\.\d{2}$'){ throw ($eti + ": ToDate non e' una data 'aaaa.mm.gg' ma [" + $a + "].") }
  $d1 = [datetime]::MinValue; $d2 = [datetime]::MinValue
  if(-not [datetime]::TryParseExact($da,"yyyy.MM.dd",$INV,[Globalization.DateTimeStyles]::None,[ref]$d1)){ throw ($eti + ": FromDate [" + $da + "] ha la forma di una data ma non e' un giorno che esiste.") }
  if(-not [datetime]::TryParseExact($a ,"yyyy.MM.dd",$INV,[Globalization.DateTimeStyles]::None,[ref]$d2)){ throw ($eti + ": ToDate [" + $a + "] ha la forma di una data ma non e' un giorno che esiste.") }
  if($d2 -le $d1){ throw ($eti + ": ToDate (" + $a + ") non e' DOPO FromDate (" + $da + "): la finestra e' vuota o rovesciata.") }
}
function GateDateIni([string]$eti,[string]$testo,[string]$da,[string]$a){
  if($testo -notmatch ('(?m)^FromDate=' + [regex]::Escape($da) + '\r?$')){ throw ($eti + ": nell'ini la riga FromDate non e' 'FromDate=" + $da + "'.") }
  if($testo -notmatch ('(?m)^ToDate='   + [regex]::Escape($a)  + '\r?$')){ throw ($eti + ": nell'ini la riga ToDate non e' 'ToDate=" + $a + "'.") }
  $nf = @([regex]::Matches($testo,'(?m)^FromDate=')).Count
  $nt = @([regex]::Matches($testo,'(?m)^ToDate=')).Count
  if($nf -ne 1 -or $nt -ne 1){ throw ($eti + ": nell'ini ci sono " + $nf + " righe FromDate e " + $nt + " righe ToDate invece di una ciascuna.") }
}

# --- TROVA IL REPORT .htm SCRITTO DOPO $dopo. MT5 lo scrive dove gli
#     pare (install dir, cartella dati, cartella di lavoro): si cerca in
#     tutte, E SI GUARDA LA DATA -- un .htm di ieri non e' un report.
function TrovaReport([string]$nome,[datetime]$dopo,$radici){
  foreach($rad in @($radici)){
    if([string]::IsNullOrEmpty($rad)){ continue }
    if(-not (Test-Path -LiteralPath $rad)){ continue }
    $c = @(Get-ChildItem -LiteralPath $rad -Filter ($nome + "*.htm*") -File -ErrorAction SilentlyContinue |
           Where-Object { $_.LastWriteTime -ge $dopo } | Sort-Object LastWriteTime -Descending)
    if($c.Count -gt 0){ return $c[0].FullName }
  }
  return ""
}

# =====================================================================
#  GLI ASSI DELLA GRIGLIA, RICAVATI DAL FILE PROVA E NON SCRITTI A
#  MEMORIA (checklist 40-bis: il numero atteso di un gate si CONTA
#  sull'artefatto, non si ricorda).
# =====================================================================
function AssiDi($mappa,[string]$nome){
  $riga = $mappa[$nome]
  if($null -eq $riga){ return @() }
  $c = $riga -split '\|\|'
  if($c.Count -lt 5){ return @() }
  if($c[4].Trim() -notmatch '^[Yy]'){ return @() }
  $a = (NumInv $c[1]); $s = (NumInv $c[2]); $b = (NumInv $c[3])
  if($null -eq $a -or $null -eq $s -or $null -eq $b){ return @() }
  if([double]$s -eq 0){ return @() }
  $out = New-Object System.Collections.ArrayList
  $v = [double]$a
  while($v -le [double]$b + 0.000001){ [void]$out.Add([double]$v); $v = $v + [double]$s }
  return @($out)
}

# =====================================================================
#  LA RICERCA DELLE REGIONI. 4-vicini (su/giu'/destra/sinistra), MAI in
#  diagonale: due celle che si toccano solo per un vertice non hanno
#  nessun parametro in comune, e chiamarle "adiacenti" gonfierebbe le
#  regioni con celle scollegate.
#  IL CENTRO SI CALCOLA, NON SI PESCA: e' la cella della regione piu'
#  vicina al baricentro della regione stessa, e a parita' vince quella
#  con indici piu' bassi (regola deterministica, dichiarata prima).
#  "Centro dell'altopiano, MAI il picco" -- dodici Spearman IS->OOS
#  negative su tredici.
# =====================================================================
function TrovaRegioni($ok,[int]$nPw,[int]$nRo){
  $visto = @{}
  $regioni = New-Object System.Collections.ArrayList
  for($i=0; $i -lt $nPw; $i++){
    for($j=0; $j -lt $nRo; $j++){
      $k = "$i,$j"
      if($visto.ContainsKey($k)){ continue }
      if(-not $ok["$i,$j"]){ continue }
      $coda = New-Object System.Collections.ArrayList
      [void]$coda.Add(@($i,$j))
      $visto[$k] = $true
      $membri = New-Object System.Collections.ArrayList
      while($coda.Count -gt 0){
        $cur = $coda[0]; $coda.RemoveAt(0)
        [void]$membri.Add($cur)
        foreach($dxy in @(@(1,0),@(-1,0),@(0,1),@(0,-1))){
          $ni = $cur[0] + $dxy[0]; $nj = $cur[1] + $dxy[1]
          if($ni -lt 0 -or $ni -ge $nPw -or $nj -lt 0 -or $nj -ge $nRo){ continue }
          $nk = "$ni,$nj"
          if($visto.ContainsKey($nk)){ continue }
          if(-not $ok[$nk]){ continue }
          $visto[$nk] = $true
          [void]$coda.Add(@($ni,$nj))
        }
      }
      # il baricentro, e poi la cella DELLA REGIONE piu' vicina
      $si = 0.0; $sj = 0.0
      foreach($m in $membri){ $si += $m[0]; $sj += $m[1] }
      $ci = $si / $membri.Count; $cj = $sj / $membri.Count
      $best = $null; $bestD = 1e18
      foreach($m in $membri){
        $d = ($m[0]-$ci)*($m[0]-$ci) + ($m[1]-$cj)*($m[1]-$cj)
        if($d -lt $bestD - 0.000001){ $bestD = $d; $best = $m }
      }
      [void]$regioni.Add([pscustomobject]@{ Membri=@($membri); Centro=$best })
    }
  }
  return @($regioni)
}

$RefTxt = New-Object System.Collections.ArrayList
function ScriviRef([string]$t){ [void]$RefTxt.Add($t) }

# --- costruisce la griglia (Pw x Ro) da un CSV, con gemelli
function Griglia($righe,$pwList,$roList){
  $g = @{}
  if($null -eq $righe){ return $g }
  for($i=0; $i -lt @($pwList).Count; $i++){
    for($j=0; $j -lt @($roList).Count; $j++){
      $pw = [double]$pwList[$i]; $ro = [double]$roList[$j]
      $sel = @($righe | Where-Object {
        $null -ne $_.Pw -and $null -ne $_.Ro -and
        [math]::Abs([double]$_.Pw - $pw) -lt 0.5 -and [math]::Abs([double]$_.Ro - $ro) -lt 0.5 })
      $cel = [pscustomobject]@{ Pw=$pw; Ro=$ro; NRighe=@($sel).Count; Gem="NON MISURATO"
        Profit=$null; Pf=$null; Dd=$null; N=$null; Pg=$null }
      if(@($sel).Count -ge 1){
        $cel.Profit=$sel[0].Profit; $cel.Pf=$sel[0].Pf; $cel.Dd=$sel[0].Dd; $cel.N=$sel[0].N; $cel.Pg=$sel[0].Pg
      }
      if(@($sel).Count -eq 2){ $cel.Gem = Gemelli $sel[0] $sel[1] }
      elseif(@($sel).Count -gt 2){ $cel.Gem = "NON VALIDO: " + @($sel).Count + " righe invece di 2" }
      elseif(@($sel).Count -eq 1){ $cel.Gem = "NON VALIDO: 1 riga invece di 2" }
      else { $cel.Gem = "ASSENTE" }
      $g["$i,$j"] = $cel
    }
  }
  return $g
}

# =====================================================================
#  I LAVORI. 'Diff' = gli input che DEVONO differire dal file LONG del
#  round, e NESSUN ALTRO. Contare "tre righe diverse" non basterebbe:
#  tre righe SBAGLIATE darebbero lo stesso conteggio. 'VLong'/'VShort'
#  dicono quanto devono VALERE i due lati in quel file: se due file
#  fossero SCAMBIATI il diff resterebbe verde e questo no.
# =====================================================================
function Lav([string]$id,[string]$file,[string]$fase,[string]$lato,[string]$desc,
           [int]$m1,[int]$m2,[string]$vLong,[string]$vShort,[string]$vRange,$diff){
  return [pscustomobject]@{
    Id=$id; Prova=$file; Fase=$fase; Lato=$lato; Desc=$desc; M1=$m1; M2=$m2
    VLong=$vLong; VShort=$vShort; VRange=$vRange; Diff=@($diff)
    Esito="NON ESEGUITA"; CelleAttese=-1; RigheIS=-1; RigheOOS=-1
    Gemelli="NON MISURATO"; DatiIS=$null; DatiOOS=$null }
}
$LAVORI = @()
$LAVORI += (Lav "metro_long"   "PREOPEN_METRO_DAX_M15.txt"        "METRO"   "LONG"  "METRO 0c: livello ORB (RangeMode=0) su M15, lato LONG"  781800 781801 "1" "0" "0" @("InpRangeMode","InpPrevWindowMin"))
$LAVORI += (Lav "metro_short"  "PREOPEN_METRO_DAX_M15_SHORT.txt"  "METRO"   "SHORT" "METRO 0c: livello ORB (RangeMode=0) su M15, lato SHORT" 781900 781901 "0" "1" "0" @("InpRangeMode","InpPrevWindowMin","InpAllowLong","InpAllowShort"))
$LAVORI += (Lav "griglia_long" "PREOPEN_RETEST_DAX_M15.txt"       "GRIGLIA" "LONG"  "LA GRIGLIA: livello PRE-apertura, lato LONG"            781600 781601 "1" "0" "1" @())
$LAVORI += (Lav "griglia_short" "PREOPEN_RETEST_DAX_M15_SHORT.txt" "GRIGLIA" "SHORT" "LA GRIGLIA: livello PRE-apertura, lato SHORT"          781700 781701 "0" "1" "1" @("InpAllowLong","InpAllowShort"))
$ProvaCosto = "PREOPEN_COSTO_DAX_M15.txt"
$ProvaBase  = "PREOPEN_RETEST_DAX_M15.txt"

$Fasi = @("COSTO","METRO","GRIGLIA")
$FaseSel = $SoloFase.ToUpper().Trim()

# --- TUTTO QUELLO CHE LA LETTURA E LA RACCOLTA USANO NASCE QUI, PRIMA
#     DEL try. Le variabili nate DENTRO il try non esistono se il try
#     muore prima di arrivarci, e la lettura esploderebbe proprio nella
#     corsa fermata da un gate -- cioe' l'unica in cui il referto serve
#     davvero (checklist 41-bis / 48).
$S0aStato   = "NON ESEGUITO"
$S0aVerd    = $null
$S0aMis     = $null
$IniCosto   = "n/d"
$RepCosto   = "n/d"
$PWvals     = @()          # gli assi VERI, letti nel file prova
$ROvals     = @()
$pwCentro   = -1           # la cella del cancello, CALCOLATA sugli assi
$roCentro   = -1
$MagicCosto = -1
$PwMetro    = -1           # il valore a cui il metro pinna InpPrevWindowMin
$DatiDaDisco = $false      # vero se un CSV NON e' di questo lancio
$Verdetti    = @{}         # NASCE QUI, non dentro il try: il blocco del VERDETTO lo
                           #  legge FUORI. Nato dentro, un errore nella LETTURA DEL
                           #  METRO lo lasciava $null e "$Verdetti.ContainsKey(...)"
                           #  moriva fuori da ogni try -> niente referto e niente zip,
                           #  cioe' proprio nel caso in cui servono (checklist 48).
                           #  RIPRODOTTO eseguendo il 28/08.
$MetroPf     = @{}         # spostati fuori per simmetria con $Verdetti
$MetroCel    = @{}

try{
  Titolo ("PREOPEN DAX -- il livello pre-apertura -- modo " + $Modo)

  # -------------------------------------------------------------------
  #  0. LE GUARDIE, PRIMA DI TOCCARE QUALUNQUE COSA
  # -------------------------------------------------------------------
  if($Pin -eq ""){ throw "-Pin obbligatorio: senza, girerebbe la punta del branch spacciandola per un commit congelato." }
  if($Pin -notmatch '^[0-9a-f]{40}$'){ throw ("-Pin deve essere un commit di 40 caratteri esadecimali, ricevuto: " + $Pin) }
  if($FaseSel -ne "" -and -not ($Fasi -contains $FaseSel)){
    throw ("-SoloFase '" + $SoloFase + "' non esiste. Validi: " + ($Fasi -join ", ") + " (oppure niente = tutte).")
  }
  if(Get-Process terminal64,metaeditor64 -ErrorAction SilentlyContinue){
    throw "MT5 O METAEDITOR APERTO: col terminale aperto il tester non gira (zero CSV), con MetaEditor aperto la compilazione torna subito senza compilare."
  }
  if($Periodo -ne "M15"){
    throw ("-Periodo e' " + $Periodo + ": i file prova dichiarano @PERIODO M15 e il metro 0c esiste PROPRIO per confrontare a pari TF. Su un TF diverso il round non risponde alla domanda che ha scritto.")
  }
  GateDate "argomenti della riga" $DaQuando $Fino

  # le due finestre, CALCOLATE con la stessa formula del driver generico
  # (FrazioneIS 0.40) e poi confrontate con quelle agli atti di R101: se
  # divergono, il metro di questo round non e' confrontabile con quello.
  $dtIn  = [datetime]::ParseExact($DaQuando,"yyyy.MM.dd",$INV)
  $dtFi  = [datetime]::ParseExact($Fino,"yyyy.MM.dd",$INV)
  $dtMet = $dtIn.AddDays([math]::Floor(($dtFi-$dtIn).TotalDays*0.40))
  $IS_Da = $dtIn.ToString("yyyy.MM.dd",$INV)
  $IS_A  = $dtMet.ToString("yyyy.MM.dd",$INV)
  $OOS_Da= $dtMet.AddDays(1).ToString("yyyy.MM.dd",$INV)
  $OOS_A = $dtFi.ToString("yyyy.MM.dd",$INV)
  if($IS_A -ne "2025.06.09" -or $OOS_Da -ne "2025.06.10"){
    [void]$Rilievi.Add("LE FINESTRE NON SONO QUELLE DI R101: qui IS finisce " + $IS_A + " e OOS parte " + $OOS_Da +
      ", agli atti di R101 (da cui viene il metro della sedia viva) erano 2025.06.09 / 2025.06.10. O e' cambiata la FrazioneIS del driver generico, o e' cambiata la finestra passata a questa riga: il confronto col metro agli atti NON e' piu' a pari finestra.")
  }

  Dico ("pin ......... " + $Pin)
  Dico ("fasi ........ " + $(if($FaseSel -eq ""){ "COSTO -> METRO -> GRIGLIA (tutte)" } else { "SOLO " + $FaseSel }))
  Dico ("finestra .... " + $DaQuando + " -> " + $Fino)
  Dico ("   IS ....... " + $IS_Da + " - " + $IS_A + "   (split 40/60 del driver generico)")
  Dico ("   OOS ...... " + $OOS_Da + " - " + $OOS_A)
  Dico ("banco ....... Modello 4 (TICK REALI), deposito " + $Deposito + ", Spread=" + $Spread + " scritto nell'ini")

  # -------------------------------------------------------------------
  #  1. SCARICO AL PIN
  # -------------------------------------------------------------------
  Titolo "1. SCARICO AL PIN"
  New-Item -ItemType Directory -Force -Path $Work,$Prove | Out-Null

  $drv = Join-Path $Work "walkforward_generico.ps1"
  Scarica ($RawPin + "/backtest_pipeline/walkforward_generico.ps1") $drv
  # il driver generico pinna il branch da cui riscarica il .mq5: senza
  # questo, il pin varrebbe per il driver e NON per l'EA misurato.
  $txtDrv = Get-Content -LiteralPath $drv -Raw
  if($txtDrv -notmatch '\$EABranch\s*=\s*"lavoro"'){ throw "walkforward_generico.ps1 non ha la riga \$EABranch attesa: non lo posso pinnare." }
  $txtDrv = $txtDrv -replace '\$EABranch\s*=\s*"lavoro"', ('$EABranch="' + $Pin + '"')
  Set-Content -LiteralPath $drv -Value $txtDrv -Encoding ASCII
  Dico "driver generico scaricato e PINNATO (riscarica l'EA al pin, non dalla punta del branch)" "Green"

  foreach($nf in @($ProvaBase,$ProvaCosto,"PREOPEN_RETEST_DAX_M15_SHORT.txt","PREOPEN_METRO_DAX_M15.txt","PREOPEN_METRO_DAX_M15_SHORT.txt")){
    Scarica ($RawPin + "/backtest_pipeline/prove/" + $nf) (Join-Path $Prove $nf)
  }
  Dico ("file prova scaricati: " + @(Get-ChildItem -LiteralPath $Prove -Filter *.txt).Count + " (tutti e cinque servono SEMPRE: il file LONG e' il termine di paragone dei gate della stella, anche quando gira una fase sola)") "Green"

  $incSrc = Join-Path $Work "ABTG_PausaGuardian.mqh"
  Scarica ($RawPin + "/mql5/Include/ABTG_PausaGuardian.mqh") $incSrc
  Dico ("include scaricato: ABTG_PausaGuardian.mqh (" + (Get-Item -LiteralPath $incSrc).Length + " byte)") "Green"

  $mq5 = Join-Path $Work ($EA + ".mq5")
  Scarica ($RawPin + "/mql5/Experts/" + $EA + ".mq5") $mq5
  $srcEA = Get-Content -LiteralPath $mq5 -Raw
  # il default di InpRiskPercent e' scritto come #define, non come numero:
  # se esce un NOME invece di un numero si risolve il #define, altrimenti
  # il referto stamperebbe "rischio ABTG_DEF_RISK%", che non e' un numero
  # e non e' nemmeno un'assenza dichiarata.
  $mRisk = [regex]::Match($srcEA,'input\s+double\s+InpRiskPercent\s*=\s*([A-Za-z0-9_.]+)')
  if($mRisk.Success){
    $RiskEA = $mRisk.Groups[1].Value
    if($RiskEA -notmatch '^\d+(\.\d+)?$'){
      $mDef = [regex]::Match($srcEA,'(?m)^\s*#define\s+' + [regex]::Escape($RiskEA) + '\s+([0-9.]+)')
      if($mDef.Success){ $RiskEA = $mDef.Groups[1].Value } else { $RiskEA = "n/d (#define " + $RiskEA + " non risolto)" }
    }
  }
  # l'interruttore del round DEVE esistere nel sorgente al pin: se un
  # domani sparisse, il round misurerebbe un motore che non c'e' piu'.
  if($srcEA -notmatch 'ABTG_RANGE_PREV'){ throw ("nel sorgente al pin non c'e' ABTG_RANGE_PREV: l'interruttore che questo round accende NON esiste in questa versione dell'EA.") }
  if($srcEA -notmatch 'InpPrevWindowMin'){ throw "nel sorgente al pin non c'e' InpPrevWindowMin: l'asse (a) del round non esiste." }
  if($srcEA -notmatch 'InpRetestOffsetPts'){ throw "nel sorgente al pin non c'e' InpRetestOffsetPts: l'asse (c) del round non esiste." }
  # InpAllowReverse esiste SOLO nel DAX (non nel Dow, non nel Nasdaq) e i
  # file prova lo pinnano: se sparisse dal sorgente sarebbe un PARAMETRO
  # ORFANO, e MT5 lo ignorerebbe in silenzio.
  if($srcEA -notmatch 'InpAllowReverse'){ throw "nel sorgente al pin non c'e' InpAllowReverse: i file prova di questo round lo pinnano, e un parametro che l'EA non ha viene ignorato IN SILENZIO da MT5." }
  Dico ("sorgente EA al pin: " + (($srcEA -split "`n").Count) + " righe, InpRiskPercent di default " + $RiskEA + "%") "Green"

  # -------------------------------------------------------------------
  #  2. I GATE SUI FILE PROVA -- girano PRIMA di aprire MT5
  # -------------------------------------------------------------------
  Titolo "2. GATE SUI FILE PROVA"
  $mappe = @{}
  $magicVisti = @{}
  foreach($f in @(Get-ChildItem -LiteralPath $Prove -Filter *.txt)){
    $righeF = RigheVive $f.FullName
    $h = @{}
    $nY = 0
    $nomiY = New-Object System.Collections.ArrayList
    foreach($rr in $righeF){
      if($rr -match '^@'){
        $parti = ($rr -split '\s+',2)
        $h[$parti[0]] = $parti[1].Trim()
        continue
      }
      $ie = $rr.IndexOf("=")
      if($ie -lt 0){ continue }
      $nome = $rr.Substring(0,$ie).Trim()
      $val  = $rr.Substring($ie+1).Trim()
      if($h.ContainsKey($nome)){ throw ($f.Name + ": DUE righe per '" + $nome + "'. In [TesterInputs] un parametro doppio fa fare a MT5 ZERO passate.") }
      $h[$nome] = $val
      if($val -match '\|\|\s*[Yy]\s*$'){ $nY++; [void]$nomiY.Add($nome) }
    }
    if($nY -lt 1){ throw ($f.Name + ": nessun asse con flag Y. Senza almeno un asse spazzolato il driver generico si rifiuta di partire e MT5 rispazzola la griglia vecchia.") }
    if(-not (@($nomiY) -contains "InpMagic")){ throw ($f.Name + ": InpMagic non e' spazzolato. Lo sweep gemello sui due magic e' IL controllo d'igiene del banco: senza, i numeri non si leggono.") }
    $mappe[$f.Name] = $h
  }

  $hBase = $mappe[$ProvaBase]
  if($null -eq $hBase){ throw ("manca la mappa di " + $ProvaBase + ": senza, i gate della stella non sono eseguibili.") }

  # gli assi VERI del round, letti nel file LONG e confrontati con l'atteso
  $PWvals = @(AssiDi $hBase "InpPrevWindowMin")
  $ROvals = @(AssiDi $hBase "InpRetestOffsetPts")
  if(@($PWvals).Count -eq 0 -or @($ROvals).Count -eq 0){ throw ($ProvaBase + ": non riesco a ricavare i due assi della griglia (InpPrevWindowMin / InpRetestOffsetPts).") }
  if((($PWvals | ForEach-Object { [int]$_ }) -join ",") -ne ($PWattesi -join ",")){
    [void]$Rilievi.Add("L'asse InpPrevWindowMin del file prova e' [" + (($PWvals | ForEach-Object { [int]$_ }) -join ", ") + "], questa riga si aspettava [" + ($PWattesi -join ", ") + "]. La griglia si costruisce sui valori DEL FILE PROVA (che comanda), ma la differenza va letta: se il file e' cambiato dopo la firma, i criteri sono stati firmati su un'altra griglia.")
  }
  if((($ROvals | ForEach-Object { [int]$_ }) -join ",") -ne ($ROattesi -join ",")){
    [void]$Rilievi.Add("L'asse InpRetestOffsetPts del file prova e' [" + (($ROvals | ForEach-Object { [int]$_ }) -join ", ") + "], questa riga si aspettava [" + ($ROattesi -join ", ") + "]. Vale la stessa avvertenza.")
  }
  $nPw = @($PWvals).Count
  $nRo = @($ROvals).Count
  Dico ("assi letti nel file prova: InpPrevWindowMin " + $nPw + " valori, InpRetestOffsetPts " + $nRo + " valori -> " + ($nPw*$nRo) + " celle x 2 gemelli = " + ($nPw*$nRo*2) + " passate per finestra e per lato") "Yellow"

  # --- L'ORA DELLA TABELLA DI CALENDARIO SI LEGGE NEL FILE PROVA, NON SI
  #     SCRIVE A MEMORIA (checklist 40-quater: l'atteso calcolato con una
  #     formula che non e' quella dell'artefatto che gira). $AperturaMin
  #     serve solo alla tabella della sovrapposizione col box notturno: se
  #     divergesse dall'ora di sessione del file prova, quella tabella
  #     descriverebbe un'apertura che il round non usa.
  $apDaProva = [int](($hBase["InpSessionHour"] -split '\|\|')[0]) * 60 + [int](($hBase["InpSessionMin"] -split '\|\|')[0])
  if($apDaProva -ne $AperturaMin){
    throw ("l'apertura del file prova e' " + (OraDiMin $apDaProva) + " server ma questa riga calcola la sovrapposizione col box notturno su " + (OraDiMin $AperturaMin) + ". Sono due orologi diversi: la tabella non descriverebbe questo round.")
  }
  Dico ("apertura confermata sul file prova: " + (OraDiMin $AperturaMin) + " server  (box della sedia gemella 770411: " + (OraDiMin $BoxDaMin) + " - " + (OraDiMin ($BoxAMin-1)) + ")") "Green"

  foreach($lv in $LAVORI){
    $h = $mappe[$lv.Prova]
    if($null -eq $h){ throw ("mappa mancante per " + $lv.Prova) }

    # GATE GEOMETRIA: simbolo, periodo, storico
    if($h["@SIMBOLO"]  -ne $Simbolo){  throw ($lv.Prova + ": @SIMBOLO e' " + $h["@SIMBOLO"] + ", atteso " + $Simbolo) }
    if($h["@PERIODO"]  -ne $Periodo){  throw ($lv.Prova + ": @PERIODO e' " + $h["@PERIODO"] + ", atteso " + $Periodo) }
    if($h["@DAQUANDO"] -ne $DaQuando){ throw ($lv.Prova + ": @DAQUANDO e' " + $h["@DAQUANDO"] + ", atteso " + $DaQuando) }

    # GATE DEI VALORI: quanto valgono i due lati e il RANGE MODE in QUESTO
    # file. Prende il caso che il diff non puo' vedere: due file SCAMBIATI.
    $vl = ($h["InpAllowLong"]  -split '\|\|')[0]
    $vs = ($h["InpAllowShort"] -split '\|\|')[0]
    $vr = ($h["InpRangeMode"]  -split '\|\|')[0]
    if($vl -ne $lv.VLong){  throw ($lv.Prova + ": InpAllowLong vale "  + $vl + ", il lavoro " + $lv.Id + " lo vuole " + $lv.VLong) }
    if($vs -ne $lv.VShort){ throw ($lv.Prova + ": InpAllowShort vale " + $vs + ", il lavoro " + $lv.Id + " lo vuole " + $lv.VShort) }
    if($vr -ne $lv.VRange){ throw ($lv.Prova + ": InpRangeMode vale "  + $vr + ", il lavoro " + $lv.Id + " lo vuole " + $lv.VRange + " (0=ORB, il metro; 1=pre-apertura, il candidato). E' L'UNICA cosa che il round sta misurando: se e' sbagliata qui, non c'e' niente da leggere.") }

    # GATE DELLA BASELINE: l'ingresso al RETEST e i due orari di sessione
    # sono la baseline dichiarata. Se qualcuno li muove, il round sta
    # misurando un altro motore.
    if(($h["InpEntryMode"]   -split '\|\|')[0] -ne "2"){  throw ($lv.Prova + ": InpEntryMode deve essere 2 (RETEST): e' la modalita' viva e la tesi del round.") }
    if(($h["InpSessionHour"] -split '\|\|')[0] -ne "8"){  throw ($lv.Prova + ": InpSessionHour deve essere 8 (ORA SERVER BCM = 09:00 italiane, apertura di Francoforte). 9 sarebbe l'ora italiana: cestinare (CLAUDE.md, FUSO ORARIO BCM).") }
    if(($h["InpSessionMin"]  -split '\|\|')[0] -ne "0"){  throw ($lv.Prova + ": InpSessionMin deve essere 0.") }
    if(($h["InpCloseAtEnd"]  -split '\|\|')[0] -ne "1"){  throw ($lv.Prova + ": InpCloseAtEnd deve essere 1: 'motore intraday, mai overnight' e' il requisito che ha fatto nascere il candidato.") }
    # >>> QUI IL DAX E' DIVERSO DAL DOW, E NON E' UNA SVISTA:
    #     la sedia viva DAX ha InpMinStopPts=0 e InpSkipIfTight=1 (il Dow
    #     ha 500 e 0). Il contratto della 770101 (DD 6,25% R16 / 7,23%
    #     R46) e' stato misurato COSI'. Mettere qui il pavimento del Dow
    #     vorrebbe dire cambiare DUE cose insieme (livello + stop) e
    #     rendere illeggibile il confronto col metro.
    if(($h["InpMinStopPts"]  -split '\|\|')[0] -ne "0"){  throw ($lv.Prova + ": InpMinStopPts deve essere 0 sul DAX (e' la sedia viva; 500 e' il valore del DOW). Con un pavimento diverso dal metro il confronto non e' a pari motore.") }
    if(($h["InpSkipIfTight"] -split '\|\|')[0] -ne "1"){  throw ($lv.Prova + ": InpSkipIfTight deve essere 1 sul DAX (e' la sedia viva; 0 e' il valore del DOW).") }
    if(($h["InpAllowReverse"] -split '\|\|')[0] -ne "0"){ throw ($lv.Prova + ": InpAllowReverse deve essere 0. A 1 il retest farebbe DUE cicli al giorno invece di uno (tetto rigido, riga 637 del .mq5): sarebbe un altro MOTORE, non un altro livello, e il confronto col metro non varrebbe piu'.") }

    # GATE DELLA STELLA: contro il file LONG cambia SOLO cio' che e'
    # dichiarato in Diff, piu' InpMagic. Confronto PER NOME, mai per
    # posizione: un file con una riga in piu' sfaserebbe tutto il resto.
    $ammessi = @("InpMagic") + @($lv.Diff)
    foreach($k in @($h.Keys)){
      if($k -match '^@'){ continue }
      if($ammessi -contains $k){ continue }
      if($hBase[$k] -ne $h[$k]){ throw ($lv.Prova + ": '" + $k + "' differisce dal file LONG del round e NON e' un delta dichiarato (dichiarati: " + (@($lv.Diff) -join ", ") + ").") }
    }
    foreach($k in @($lv.Diff)){
      if($hBase[$k] -eq $h[$k]){ throw ($lv.Prova + ": '" + $k + "' DOVEVA differire dal file LONG e non differisce.") }
    }
    # e il file LONG deve avere le stesse CHIAVI degli altri: una riga in
    # piu' o in meno passerebbe il confronto sui valori senza farsi vedere.
    if(@($h.Keys).Count -ne @($hBase.Keys).Count){
      throw ($lv.Prova + ": ha " + @($h.Keys).Count + " righe, il file LONG ne ha " + @($hBase.Keys).Count + ". I file di questo round devono avere lo STESSO elenco di parametri.")
    }

    # GATE DEI MAGIC: vergini, unici, mai uno vietato.
    $mg = $h["InpMagic"] -split '\|\|'
    foreach($v in @($mg[1],$mg[3])){
      $nMg = [int]$v
      if($MagicVietati -contains $nMg){ throw ($lv.Prova + ": magic " + $nMg + " e' VIETATO (sedia viva, round recente o default di un altro EA).") }
      if($magicVisti.ContainsKey($nMg)){ throw ("magic " + $nMg + " usato in due file: " + $magicVisti[$nMg] + " e " + $lv.Prova) }
      $magicVisti[$nMg] = $lv.Prova
    }
    if([int]$mg[1] -ne $lv.M1 -or [int]$mg[3] -ne $lv.M2){
      throw ($lv.Prova + ": i magic gemelli sono " + $mg[1] + "/" + $mg[3] + ", il lavoro " + $lv.Id + " li vuole " + $lv.M1 + "/" + $lv.M2)
    }
    # quante celle deve produrre questo file, CONTATE sul file stesso
    $nCelle = 1
    foreach($nomeAsse in @("InpPrevWindowMin","InpRetestOffsetPts","InpMagic")){
      $vv = @(AssiDi $h $nomeAsse)
      if(@($vv).Count -gt 0){ $nCelle = $nCelle * @($vv).Count }
    }
    $lv.CelleAttese = $nCelle
  }

  # --- A QUALE VALORE IL METRO PINNA InpPrevWindowMin. Non si scrive a
  #     memoria: si LEGGE nei due file metro, e i due devono dire lo
  #     stesso. Serve per ritrovare le righe del metro dentro il CSV,
  #     che porta una colonna per OGNI input (MISURATO su un CSV vero di
  #     questo EA: 11 colonne di statistiche + 80 di parametri).
  foreach($nfM in @("PREOPEN_METRO_DAX_M15.txt","PREOPEN_METRO_DAX_M15_SHORT.txt")){
    $hM = $mappe[$nfM]
    if($null -eq $hM){ throw ("manca la mappa di " + $nfM) }
    if(@(AssiDi $hM "InpPrevWindowMin").Count -gt 0){ throw ($nfM + ": InpPrevWindowMin e' ancora un ASSE. Con InpRangeMode=0 e' INERTE (ComputeLevels lo legge solo nel ramo ABTG_RANGE_PREV): spazzolarlo produrrebbe righe identiche e farebbe credere a una griglia che non c'e'.") }
    $vM = [int](($hM["InpPrevWindowMin"] -split '\|\|')[0])
    if($PwMetro -lt 0){ $PwMetro = $vM }
    elseif($PwMetro -ne $vM){ throw ("i due file METRO pinnano InpPrevWindowMin a valori diversi (" + $PwMetro + " e " + $vM + "): i due lati non sarebbero la stessa cella.") }
  }

  # il file del CANCELLO DEL COSTO ha i suoi gate, diversi: e' l'unico
  # che pinna i due assi invece di spazzolarli.
  $hCosto = $mappe[$ProvaCosto]
  if($null -eq $hCosto){ throw ("manca la mappa di " + $ProvaCosto) }
  if(@($hCosto.Keys).Count -ne @($hBase.Keys).Count){
    throw ($ProvaCosto + ": ha " + @($hCosto.Keys).Count + " righe, il file LONG ne ha " + @($hBase.Keys).Count + ". I file di questo round devono avere lo STESSO elenco di parametri.")
  }
  foreach($k in @($hCosto.Keys)){
    if($k -match '^@'){ continue }
    if(@("InpMagic","InpPrevWindowMin","InpRetestOffsetPts") -contains $k){ continue }
    if($hBase[$k] -ne $hCosto[$k]){ throw ($ProvaCosto + ": '" + $k + "' differisce dal file LONG e NON e' un delta dichiarato. Il cancello misurerebbe il costo di un altro motore.") }
  }
  $pwCosto = ($hCosto["InpPrevWindowMin"]   -split '\|\|')[0]
  $roCosto = ($hCosto["InpRetestOffsetPts"] -split '\|\|')[0]
  if(@(AssiDi $hCosto "InpPrevWindowMin").Count   -gt 0){ throw ($ProvaCosto + ": InpPrevWindowMin e' ancora un ASSE. Nella passata singola dev'essere PINNATO.") }
  if(@(AssiDi $hCosto "InpRetestOffsetPts").Count -gt 0){ throw ($ProvaCosto + ": InpRetestOffsetPts e' ancora un ASSE. Nella passata singola dev'essere PINNATO.") }
  $pwCentro = [int]$PWvals[[int]([math]::Floor(@($PWvals).Count / 2))]
  $roCentro = [int]$ROvals[[int]([math]::Floor(@($ROvals).Count / 2))]
  if([int]$pwCosto -ne $pwCentro){ throw ($ProvaCosto + ": InpPrevWindowMin e' " + $pwCosto + " ma il CENTRO dell'asse della griglia e' " + $pwCentro + ". La cella del cancello si dichiara PRIMA dei numeri ed e' il centro: sceglierne un'altra vuol dire pescare quella che fa passare il cancello.") }
  if([int]$roCosto -ne $roCentro){ throw ($ProvaCosto + ": InpRetestOffsetPts e' " + $roCosto + " ma il CENTRO dell'asse della griglia e' " + $roCentro + ".") }
  if(($hCosto["InpRangeMode"] -split '\|\|')[0] -ne "1"){ throw ($ProvaCosto + ": InpRangeMode deve essere 1. Il cancello deve misurare il costo DEL MOTORE DEL ROUND, non di un altro.") }
  $mgCosto = $hCosto["InpMagic"] -split '\|\|'
  foreach($v in @($mgCosto[1],$mgCosto[3])){
    $nMg = [int]$v
    if($MagicVietati -contains $nMg){ throw ($ProvaCosto + ": magic " + $nMg + " e' VIETATO.") }
    if($magicVisti.ContainsKey($nMg)){ throw ("il magic del cancello " + $nMg + " e' usato anche in " + $magicVisti[$nMg] + ". CHECKLIST 41: la corsa cancellerebbe la prova del gate (l'export per-trade porta il magic nel nome).") }
    $magicVisti[$nMg] = $ProvaCosto
  }
  $MagicCosto = [int]$mgCosto[1]
  Dico ("geometria, lati, RangeMode, baseline, stella, magic e assi: TUTTI PASSATI  (cella del cancello: PrevWindowMin=" + $pwCentro + ", RetestOffsetPts=" + $roCentro + ", magic " + $MagicCosto + ")") "Green"

  # -------------------------------------------------------------------
  #  3. TERMINALE, INCLUDE, COMPILAZIONE
  # -------------------------------------------------------------------
  Titolo "3. TERMINALE, INCLUDE, COMPILAZIONE"
  # IL SELETTORE E' LO STESSO, RIGA PER RIGA, DI walkforward_generico.ps1.
  # Su una macchina con DUE istanze BCM (la -V3 del 100k esiste) due
  # selettori diversi possono scegliere TERMINALI DIVERSI: include
  # installato in uno, compilazione fatta nell'altro, e il referto che
  # stampa "INSTALLATO" in verde. Se il selettore del driver generico
  # cambia, cambia anche questo: si toccano insieme.
  $allTerm = @(Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue)
  $cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*" } | Select-Object -First 1
  if(-not $cand){ $cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets*" } | Select-Object -First 1 }
  if(-not $cand){ throw "terminale BCM non trovato: e' lo stesso selettore di walkforward_generico.ps1." }
  $instDir    = $cand.DirectoryName
  $Terminal   = $cand.FullName
  $MetaEditor = Join-Path $instDir "metaeditor64.exe"
  $termRoot   = Join-Path $env:APPDATA "MetaQuotes\Terminal"
  $dataFolder = (Get-ChildItem -LiteralPath $termRoot -Directory -ErrorAction SilentlyContinue | Where-Object { $o = Join-Path $_.FullName "origin.txt"; (Test-Path -LiteralPath $o) -and ((Get-Content -LiteralPath $o -Raw).Trim() -ieq $instDir) } | Select-Object -First 1 -ExpandProperty FullName)
  if(-not $dataFolder){ throw ("cartella dati non trovata per " + $instDir) }
  $Terminale = $instDir
  $MqlFiles  = Join-Path $dataFolder "MQL5\Files"
  Dico ("terminale scelto: " + $instDir + "  (DEVE essere lo stesso che stampa il driver generico)") "Yellow"

  # LA COPIA SI VERIFICA SUL CONTENUTO, NON SUL NOME: se in Include
  # esistesse una CARTELLA con quel nome, Copy-Item ci metterebbe il file
  # DENTRO e Test-Path direbbe verde lo stesso.
  $incDir = Join-Path $dataFolder "MQL5\Include"
  New-Item -ItemType Directory -Force -Path $incDir | Out-Null
  $lenInc = (Get-Item -LiteralPath $incSrc).Length
  Copy-Item -LiteralPath $incSrc -Destination $incDir -Force
  $vInc = Get-Item -LiteralPath (Join-Path $incDir "ABTG_PausaGuardian.mqh") -ErrorAction Stop
  if($vInc.PSIsContainer -or $vInc.Length -ne $lenInc){ throw "include copiato ma NON verificato (lunghezza diversa)." }
  $Include = "INSTALLATO e VERIFICATO in " + $incDir
  Dico $Include "Green"

  # --- LA COMPILAZIONE, IN ENTRAMBI I RAMI (controllo E corsa vera).
  #     Questo EA E' GIA' VIVO in produzione, quindi un .ex5 in quella
  #     cartella c'e' quasi sicuramente. Ed e' proprio per questo che si
  #     compila anche nel giro a vuoto: un .ex5 VECCHIO sotto un .mq5
  #     NUOVO non e' un no-op, e' un binario che OPERA mentendo sulla
  #     versione (checklist 54). L'.ex5 si CANCELLA prima: senza, un
  #     binario vecchio farebbe passare per riuscita una compilazione
  #     fallita (checklist 23).
  $dstExp = Join-Path $dataFolder "MQL5\Experts"
  New-Item -ItemType Directory -Force -Path $dstExp | Out-Null
  $dstMq5 = Join-Path $dstExp ($EA + ".mq5")
  Copy-Item -LiteralPath $mq5 -Destination $dstMq5 -Force
  $ex5 = Join-Path $dstExp ($EA + ".ex5")
  Remove-Item -LiteralPath $ex5 -Force -ErrorAction SilentlyContinue
  $t0 = Get-Date
  & $MetaEditor ("/compile:" + $dstMq5) "/log" | Out-Null
  while((-not (Test-Path -LiteralPath $ex5)) -and ((New-TimeSpan -Start $t0 -End (Get-Date)).TotalSeconds -lt 180)){ Start-Sleep -Seconds 2 }
  if(-not (Test-Path -LiteralPath $ex5)){
    $logC = Join-Path $dstExp ($EA + ".log")
    if(Test-Path -LiteralPath $logC){
      Copy-Item -LiteralPath $logC -Destination (Join-Path $Work "COMPILAZIONE_FALLITA.log") -Force
      Get-Content -LiteralPath $logC -Tail 40 | ForEach-Object { Write-Host $_ -ForegroundColor Red }
    }
    throw ("COMPILAZIONE FALLITA per " + $EA + ". Sospetti in ordine: (1) l'include ABTG_PausaGuardian.mqh non e' quello che il sorgente si aspetta; (2) MetaEditor gia' aperto; (3) un errore vero del sorgente al pin. Gli errori sono qui sopra e in COMPILAZIONE_FALLITA.log dentro lo zip.")
  }
  $Compilato = "OK (" + [int]((Get-Item -LiteralPath $ex5).Length/1024) + " KB, " + (Get-Item -LiteralPath $ex5).LastWriteTime.ToString("HH:mm:ss",$INV) + ")"
  Dico ("compilato " + $EA + ": " + $Compilato) "Green"

  # -------------------------------------------------------------------
  #  4. FASE COSTO -- IL CANCELLO 0b, PRIMA DI QUALUNQUE PF
  # -------------------------------------------------------------------
  if($FaseSel -eq "" -or $FaseSel -eq "COSTO"){
    Titolo "4. FASE COSTO -- cancello 0b (passata SINGOLA, report .htm)"

    # L'elenco COMPLETO dei parametri lo costruisce il DRIVER GENERICO
    # (che risolve #define, enum e default del sorgente), non questa riga:
    # riscrivere qui quel resolver vorrebbe dire avere due verita' che
    # prima o poi divergono. Si prende la sua ANTEPRIMA e la si converte
    # in passata singola.
    # >>> E SI PRENDE SUBITO: il nome dell'anteprima NON contiene
    #     l'etichetta (checklist 96), quindi ogni altra chiamata con
    #     -SoloControllo la sovrascriverebbe.
    $argvA = @("-ExecutionPolicy","Bypass","-File",$drv,
               "-Expert",$EA,
               "-Prova",(Join-Path $Prove $ProvaCosto),
               "-Etichetta","costo",
               "-Simbolo",$Simbolo,"-Periodo",$Periodo,
               "-DaQuando",$DaQuando,"-Fino",$Fino,
               "-Modello","4","-Deposito",("" + $Deposito),"-Spread",("" + $Spread),
               "-SoloControllo")
    $global:LASTEXITCODE = 0
    & powershell $argvA
    if($LASTEXITCODE -ne 0){ throw ("il driver generico e' uscito con codice " + $LASTEXITCODE + " sul file del cancello (" + $ProvaCosto + "): senza la sua anteprima non posso costruire l'ini della passata singola.") }
    $antep = Join-Path $Work ("anteprima_" + $EA + "_" + $Simbolo + ".ini")
    if(-not (Test-Path -LiteralPath $antep)){ throw ("il driver generico non ha scritto l'anteprima attesa: " + $antep) }
    $antepMio = Join-Path $Work "anteprima_costo.ini"
    Copy-Item -LiteralPath $antep -Destination $antepMio -Force

    $testoA = Get-Content -LiteralPath $antepMio -Raw
    $posTI = $testoA.IndexOf("[TesterInputs]")
    if($posTI -lt 0){ throw "nell'anteprima non c'e' la sezione [TesterInputs]." }
    $blocco = $testoA.Substring($posTI + "[TesterInputs]".Length)
    $righeA = @($blocco -split "`r?`n" | Where-Object { $_.Trim() -ne "" })
    if(@($righeA).Count -lt 50){ throw ("l'anteprima ha solo " + @($righeA).Count + " parametri: e' troppo poco per questo EA e vuol dire che il resolver del driver generico non ha letto il sorgente.") }
    $singole = New-Object System.Collections.ArrayList
    foreach($ra in $righeA){
      $ie = $ra.IndexOf("=")
      if($ie -lt 0){ continue }
      $nm = $ra.Substring(0,$ie).Trim()
      $vv = $ra.Substring($ie+1)
      if($vv -match '\|\|'){ $vv = ($vv -split '\|\|')[0] }
      [void]$singole.Add($nm + "=" + $vv.Trim())
    }
    $inputsC = (@($singole) -join "`r`n")
    # I GATE SULLO STATO FINALE DEL TESTO, non sul replace.
    if(@($singole).Count -ne @($righeA).Count){ throw ("conversione dell'anteprima: " + @($singole).Count + " righe invece di " + @($righeA).Count + ".") }
    if($inputsC -match '\|\|'){ throw "ini SINGOLA: e' rimasto uno sweep '||'. Sarebbe un'OTTIMIZZAZIONE TRAVESTITA, e in ottimizzazione non esiste nessun report .htm da leggere: il cancello resterebbe muto e nessuno saprebbe perche'." }
    foreach($att in @(@("InpMagic",("" + $MagicCosto)),@("InpRangeMode","1"),@("InpEntryMode","2"),
                      @("InpPrevWindowMin",("" + $pwCentro)),@("InpRetestOffsetPts",("" + $roCentro)),
                      @("InpAllowLong","1"),@("InpAllowShort","0"),@("InpCloseAtEnd","1"))){
      if($inputsC -notmatch ('(?m)^' + [regex]::Escape($att[0]) + '=' + [regex]::Escape($att[1]) + '\r?$')){
        throw ("ini SINGOLA: la riga '" + $att[0] + "=" + $att[1] + "' non c'e'. Il cancello girerebbe su una cella che non e' quella dichiarata.")
      }
    }
    $repCostoNome = "PREOPEN_COSTO_" + $MagicCosto + "_" + $Stamp
    $iniC = Join-Path $Work ("gen_preopen_costo.ini")
    GateDate "ini SINGOLA (costo)" $DaQuando $Fino
    $testoC = @"
[Charts]
MaxBars=2000000000

[Experts]
AllowLiveTrading=false
AllowDllImport=false

[Tester]
Expert=$EA.ex5
Symbol=$Simbolo
Period=$Periodo
Model=4
Spread=$Spread
Optimization=0
FromDate=$DaQuando
ToDate=$Fino
ForwardMode=0
Deposit=$Deposito
Currency=EUR
Leverage=100
ExecutionMode=0
ReplaceReport=1
ShutdownTerminal=1
Report=$repCostoNome

[TesterInputs]
$inputsC
"@
    GateDateIni "ini SINGOLA (costo)" $testoC $DaQuando $Fino
    if($testoC -notmatch '(?m)^Optimization=0\r?$'){ throw "ini SINGOLA: Optimization non e' 0." }
    if($testoC -notmatch '(?m)^AllowLiveTrading=false\r?$'){ throw "ini SINGOLA: manca AllowLiveTrading=false. Aprire MT5 per MISURARE riarmerebbe la flotta (checklist 51)." }
    Set-Content -LiteralPath $iniC -Value $testoC -Encoding ASCII
    $IniCosto = $iniC
    Dico ("ini della passata singola scritto e verificato: " + $iniC) "Green"
    Dico ("   finestra del cancello: " + $DaQuando + " -> " + $Fino + " INTERA (non IS/OOS): il costo e' una proprieta' STRUTTURALE del meccanismo, e piu' operazioni fanno una mediana piu' stabile.")

    if($SoloControllo){
      $S0aStato = "NON ESEGUITO (giro a vuoto: l'ini c'e' ed e' passato tutti i gate, MT5 non e' stato aperto)"
      Dico $S0aStato "Yellow"
    }else{
      $tPrima = Get-Date
      (Start-Process -FilePath $Terminal -ArgumentList ("/config:`"" + $iniC + "`"") -PassThru).WaitForExit()
      $rep = TrovaReport $repCostoNome $tPrima @($instDir,$dataFolder,$Work,$MqlFiles)
      if($rep -eq ""){
        $S0aStato = "NON MISURATO (nessun report .htm scritto dopo l'avvio)"
        [void]$Problemi.Add("CANCELLO DEL COSTO: NON ho trovato nessun report '" + $repCostoNome + "*.htm' scritto dopo l'avvio della passata (cercato in " + $instDir + ", " + $dataFolder + ", " + $Work + ", " + $MqlFiles + "). Il cancello 0b resta NON MISURATO e NON si inventa. COME AVERLO A MANO: aprire MT5, Strategy Tester, ricaricare gen_preopen_costo.ini (e' nello zip) in test SINGOLO, tasto destro sul risultato -> Report.")
      }else{
        $RepCosto = $rep
        Copy-Item -LiteralPath $rep -Destination (Join-Path $Work "REPORT_COSTO.htm") -Force -ErrorAction SilentlyContinue
        $deal = LeggiDeal $rep
        if(@($deal).Count -eq 0){
          $S0aStato = "NON MISURATO (deal non riconosciuti nel report)"
          [void]$Problemi.Add("CANCELLO DEL COSTO: il report .htm c'e' ma non ne ho riconosciuto nessun deal. Colonne: " + $script:DealColonne + " | prime intestazioni viste: " + ($script:DealIntestazioni -join " // "))
        }else{
          $S0aMis = PassoCosto $deal $PuntoIndice
          if($S0aMis.Stato -ne "MISURATO"){
            $S0aStato = $S0aMis.Stato
            [void]$Problemi.Add("CANCELLO DEL COSTO: " + $S0aMis.Stato)
          }else{
            $S0aVerd = VerdettoS0a ([double]$S0aMis.TakeGambaMed)
            $S0aStato = $S0aVerd.Esito
            Dico ("cancello 0b -> " + $S0aVerd.Verdetto) $(if($S0aVerd.Esito -eq "SUPERATO"){"Green"}elseif($S0aVerd.Esito -eq "FALLITO"){"Red"}else{"Yellow"})
            Dico ("   operazioni " + $S0aMis.N + " (gambe di uscita " + $S0aMis.NGambe + "), take mediano per POSIZIONE " + (Fmt2 $S0aMis.TakePosMed) + " punti indice, perdita mediana per gamba " + (Fmt2 $S0aMis.PerdGambaMed))
            Dico ("   volumi: min " + (Fmt2 $S0aMis.VolMin) + " max " + (Fmt2 $S0aMis.VolMax) + ", valori distinti " + (FmtN $S0aMis.NVolDistinti))
          }
        }
      }
      # >>> IL CANCELLO MORDE DAVVERO: "Sotto, il round si ferma qui".
      if($S0aStato -eq "FALLITO"){
        throw ("CANCELLO DEL COSTO FALLITO -- il round si ferma qui, come dice il PASSO 0b del file prova. " + $S0aVerd.Verdetto +
               "  Nessun PF di nessuna griglia viene letto: un motore che non copre il proprio costo non ha bisogno di una griglia per essere bocciato.")
      }
      if($S0aStato -ne "SUPERATO"){
        [void]$Rilievi.Add("CANCELLO DEL COSTO non SUPERATO ma nemmeno FALLITO (stato: " + $S0aStato + "). Il round PROSEGUE, ma ogni numero che segue va letto con questo cappello: il costo del meccanismo non e' stato dimostrato sopra la soglia.")
      }
    }
  }else{
    $S0aStato = "SALTATA (-SoloFase " + $FaseSel + ")"
    [void]$Rilievi.Add("FASE COSTO SALTATA per -SoloFase: il PASSO 0b del file prova la vuole PRIMA di leggere qualunque PF. I numeri di questo referto NON sono un verdetto di round finche' il cancello non e' stato eseguito.")
  }

  # -------------------------------------------------------------------
  #  5. LE CORSE (METRO e GRIGLIA), via driver generico
  # -------------------------------------------------------------------
  $Risultati = Join-Path $Work ("risultati_prove\" + $EA)
  foreach($lv in $LAVORI){
    if($FaseSel -ne "" -and $FaseSel -ne $lv.Fase){
      # NON GIRA IN QUESTO LANCIO. Ma se il CSV di un lancio precedente
      # e' ancora a disco lo si LEGGE, perche' altrimenti una ripresa
      # perderebbe il metro e nessun confronto sarebbe piu' possibile.
      # >>> E LO SI MARCA: "non di questo lancio" e' un fatto, e da qui
      #     in poi nessun verdetto di questo referto e' definitivo.
      $lv.Esito = "SALTATA (-SoloFase " + $FaseSel + ")"
      $pathIS  = Join-Path $Risultati ($EA + "_" + $Simbolo + "_IS_"  + $lv.Id + ".csv")
      $pathOOS = Join-Path $Risultati ($EA + "_" + $Simbolo + "_OOS_" + $lv.Id + ".csv")
      if((Test-Path -LiteralPath $pathIS) -and (Test-Path -LiteralPath $pathOOS)){
        $dIS  = LeggiOpt $pathIS
        $dOOS = LeggiOpt $pathOOS
        if($null -ne $dIS -and $null -ne $dOOS){
          $lv.DatiIS = $dIS; $lv.DatiOOS = $dOOS
          $lv.RigheIS = @($dIS).Count; $lv.RigheOOS = @($dOOS).Count
          $lv.Esito = "DA DISCO " + (Get-Item -LiteralPath $pathOOS).LastWriteTime.ToString("dd/MM HH:mm",$INV)
          $DatiDaDisco = $true
          [void]$Rilievi.Add($lv.Id + ": i CSV NON sono di questo lancio, sono quelli gia' a disco del " +
            (Get-Item -LiteralPath $pathOOS).LastWriteTime.ToString("yyyy-MM-dd HH:mm",$INV) +
            ". Il PIN con cui sono stati prodotti NON e' agli atti di questo referto: si leggono, ma nessun verdetto qui e' DEFINITIVO finche' non girano tutte le fasi in un lancio solo.")
        }
      }
      continue
    }
    Titolo ("5. " + $lv.Id + " -- " + $lv.Desc)
    Dico ("celle attese per finestra: " + $lv.CelleAttese + " (contate sul file prova, non a memoria)")
    # NON si chiama $args: e' una VARIABILE AUTOMATICA di PowerShell.
    $argv = @("-ExecutionPolicy","Bypass","-File",$drv,
              "-Expert",$EA,
              "-Prova",(Join-Path $Prove $lv.Prova),
              "-Etichetta",$lv.Id,
              "-Simbolo",$Simbolo,"-Periodo",$Periodo,
              "-DaQuando",$DaQuando,"-Fino",$Fino,
              "-Modello","4","-Deposito",("" + $Deposito),"-Spread",("" + $Spread))
    if($SoloControllo){ $argv += "-SoloControllo" }
    if($Rifai){ $argv += "-Rifai" }
    $global:LASTEXITCODE = 0
    & powershell $argv
    $rc = $LASTEXITCODE
    if($rc -ne 0){
      $lv.Esito = "FERMATA (codice " + $rc + ")"
      [void]$Problemi.Add($lv.Id + ": il driver generico e' uscito con codice " + $rc)
      continue
    }
    if($SoloControllo){ $lv.Esito = "CONTROLLO OK"; continue }

    $csvIS  = Join-Path $Risultati ($EA + "_" + $Simbolo + "_IS_"  + $lv.Id + ".csv")
    $csvOOS = Join-Path $Risultati ($EA + "_" + $Simbolo + "_OOS_" + $lv.Id + ".csv")
    $rIS  = LeggiOpt $csvIS
    $rOOS = LeggiOpt $csvOOS
    if($null -eq $rIS -or $null -eq $rOOS){
      $lv.Esito = "CSV NON LEGGIBILE"
      [void]$Problemi.Add($lv.Id + ": CSV mancante o intestazioni non riconosciute. Viste: " + ($script:CsvIntestazioni -join " | "))
      continue
    }
    $lv.DatiIS  = $rIS
    $lv.DatiOOS = $rOOS
    $lv.RigheIS  = @($rIS).Count
    $lv.RigheOOS = @($rOOS).Count
    $lv.Esito = "MISURATA"
    if(@($rOOS).Count -ne $lv.CelleAttese){
      [void]$Problemi.Add($lv.Id + ": il CSV OOS ha " + @($rOOS).Count + " righe ma le celle chieste sono " + $lv.CelleAttese +
        ". E' la CACHE del tester (MT5 ripesca pass gia' calcolati) oppure celle mute. Con magic VERGINI la cache non dovrebbe mordere: va guardato prima di leggere qualunque numero.")
    }
    if(@($rIS).Count -ne $lv.CelleAttese){
      [void]$Rilievi.Add($lv.Id + ": il CSV IS ha " + @($rIS).Count + " righe invece di " + $lv.CelleAttese + ".")
    }
  }

  Dico "corse concluse" "Green"
}
catch{
  $Fatale = ("" + $_.Exception.Message)
  Write-Host ""
  Write-Host ("!!! FERMATO: " + $Fatale) -ForegroundColor Red
}

# =====================================================================
#  LA LETTURA: griglia, gemelli, PASSO 0a, criteri di accettazione.
#  Sta FUORI dal try, come la raccolta: un round fermato a meta' deve
#  comunque stampare quello che ha misurato.
# =====================================================================
# --- GLI ASSI CON CUI SI LEGGE LA GRIGLIA. Quelli VERI ($PWvals /
#     $ROvals) li ha letti il gate dentro il file prova: sono la verita'.
#     Se il round si e' fermato PRIMA di quel gate quelle liste sono
#     vuote, e allora si ripiega sull'ATTESO di questa riga -- ma la
#     tabella che ne esce sara' tutta "n/d", che e' esattamente quello
#     che deve succedere: NON si stima una griglia che non e' stata
#     letta.
$PWuso = @($PWattesi)
$ROuso = @($ROattesi)
if(@($PWvals).Count -gt 0){ $PWuso = @($PWvals) }
if(@($ROvals).Count -gt 0){ $ROuso = @($ROvals) }
if($PwMetro -lt 0){ $PwMetro = 60 }

Titolo "RACCOLTA"
$Cart = Join-Path $Dsk ("PREOPEN_DAX_" + $Modo + "_" + $Stamp)
New-Item -ItemType Directory -Force -Path $Cart | Out-Null

ScriviRef "====================================================================="
ScriviRef (" PREOPEN DAX -- il livello PRE-APERTURA su " + $Simbolo + " " + $Periodo)
ScriviRef (" EA " + $EA + "  --  InpRangeMode 0 (ORB) contro 1 (pre-apertura)")
ScriviRef "====================================================================="
ScriviRef ("modo: " + $Modo + "   <- CONTROLLO = giro a vuoto, NON e' il risultato")
ScriviRef ("data: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV))
ScriviRef ("pin:  " + $Pin)
ScriviRef ("finestra: " + $DaQuando + " -> " + $Fino)
ScriviRef ("   IS  " + $IS_Da + " - " + $IS_A)
ScriviRef ("   OOS " + $OOS_Da + " - " + $OOS_A + "   <- i criteri si applicano QUI")
ScriviRef ("banco: Modello 4 TICK REALI, deposito " + $Deposito + ", Spread=" + $Spread + " scritto nell'ini, rischio " + $RiskEA + "% (default del .mq5; i file prova lo pinnano a 1.0)")
ScriviRef ("terminale: " + $Terminale)
ScriviRef ("include: " + $Include)
ScriviRef ("compilazione: " + $Compilato)
ScriviRef ("fasi richieste: " + $(if($FaseSel -eq ""){ "tutte" } else { $FaseSel }))
ScriviRef ""
# IL "FERMATO" VA IN CIMA, non solo in fondo: un referto che si apre come
# tutti gli altri e confessa in fondo di essere monco e' un referto che
# verra' letto come completo (checklist 50).
if($Fatale -ne ""){
  ScriviRef "#####################################################################"
  ScriviRef "#  QUESTA CORSA E' STATA FERMATA. IL REFERTO E' MONCO."
  ScriviRef ("#  " + $Fatale)
  ScriviRef "#  Tutto quello che segue e' quello che era stato misurato FINO A"
  ScriviRef "#  QUEL PUNTO. Non e' un verdetto di round."
  ScriviRef "#####################################################################"
  ScriviRef ""
}
ScriviRef "---------------------------------------------------------------------"
ScriviRef " ATTENZIONE, PRIMA DI LEGGERE QUALUNQUE NUMERO"
ScriviRef "---------------------------------------------------------------------"
ScriviRef " Questo E' un round con criteri di MERITO gia' congelati. I criteri"
ScriviRef " NON stanno qui: stanno in prove\PREOPEN_RETEST_DAX_M15.txt, sezioni"
ScriviRef " CRITERI DI ACCETTAZIONE e COME PUO' MORIRE. Questo referto li"
ScriviRef " APPLICA e stampa il numero accanto a ognuno."
ScriviRef " La regola di casa e' che i criteri si leggono PRIMA della tabella e"
ScriviRef " non si spostano dopo."
ScriviRef ""
ScriviRef "--- PASSO 0b -- IL CANCELLO DEL COSTO (S0a) ---"
ScriviRef ("stato: " + $S0aStato)
if($null -ne $S0aVerd){ ScriviRef ("  " + $S0aVerd.Verdetto) }
ScriviRef ("ini della passata singola: " + $IniCosto)
ScriviRef ("report .htm letto:        " + $RepCosto)
if($null -ne $S0aMis -and $S0aMis.Stato -eq "MISURATO"){
  ScriviRef ("  cella del cancello: InpPrevWindowMin=" + $pwCentro + "  InpRetestOffsetPts=" + $roCentro + "  (CENTRO della griglia, CALCOLATO sugli assi del file prova e dichiarato PRIMA dei numeri)")
  ScriviRef ("  finestra: " + $DaQuando + " -> " + $Fino + " INTERA (una passata singola, non IS/OOS)")
  ScriviRef ("  operazioni chiuse ...................... " + (FmtN $S0aMis.N) + "   (prima " + $S0aMis.Prima + ", ultima " + $S0aMis.Ultima + ")")
  ScriviRef ("  gambe di uscita (le parziali contano) .. " + (FmtN $S0aMis.NGambe))
  ScriviRef ("  take mediano per GAMBA (netto) ......... " + (Fmt2 $S0aMis.TakeGambaMed) + " punti indice   <- E' QUESTO CHE FA IL VERDETTO")
  ScriviRef ("  take mediano per POSIZIONE (pesato) .... " + (Fmt2 $S0aMis.TakePosMed) + " punti indice   <- informativo")
  ScriviRef ("  perdita mediana per gamba .............. " + (Fmt2 $S0aMis.PerdGambaMed) + " punti indice")
  ScriviRef ("  volumi: min " + (Fmt2 $S0aMis.VolMin) + "  max " + (Fmt2 $S0aMis.VolMax) + "  valori distinti " + (FmtN $S0aMis.NVolDistinti))
  ScriviRef ("     >>> se i valori distinti sono 1 e il volume e' il minimo del")
  ScriviRef ("         broker, il lotto e' andato a sbattere sul PAVIMENTO")
  ScriviRef ("         VOLUME_MIN: in CalcLotByRisk c'e' un MathMax(minLot,...),")
  ScriviRef ("         quindi in quel caso il rischio VERO per operazione e'")
  ScriviRef ("         PIU' ALTO dell'1% dichiarato e i DD di questo round")
  ScriviRef ("         sottostimano. E' un fatto del motore, va letto, e sui")
  ScriviRef ("         bordi larghi della griglia (PrevWindowMin 300 = stop piu'")
  ScriviRef ("         largo = lotto piu' piccolo) NON E' MISURATO qui.")
}
ScriviRef ""
ScriviRef "--- LE DEFINIZIONI DEL TAKE, dichiarate PRIMA dei numeri ---"
ScriviRef " Questa sedia ha la PARZIALE ACCESA (InpTP1_ClosePct=50) e il"
ScriviRef " breakeven al primo obiettivo: una posizione produce PIU' DI UNA"
ScriviRef " uscita, quindi 'il take' non e' un numero solo."
ScriviRef "   take per GAMBA  = |prezzo_out - prezzo_in| di ogni uscita con"
ScriviRef "                     netto > 0. E' la piu' CONSERVATIVA (la prima"
ScriviRef "                     parziale e' la piu' corta) ed e' quella che FA"
ScriviRef "                     IL VERDETTO."
ScriviRef "   take per POSIZIONE = media pesata sui volumi delle uscite di una"
ScriviRef "                     stessa posizione. E' informativa."
ScriviRef " Se il verdetto e' FALLITO sulla prima e sarebbe SUPERATO sulla"
ScriviRef " seconda, il round si e' fermato per una DEFINIZIONE e non per il"
ScriviRef " motore: e' scritto qui apposta perche' si veda."
ScriviRef ""

# --- la tabella dei lavori
ScriviRef "--- LE CORSE ---"
ScriviRef "lavoro          esito            celle attese   righe IS   righe OOS"
foreach($lv in $LAVORI){
  ScriviRef ("{0,-15} {1,-16} {2,12} {3,10} {4,11}" -f $lv.Id, $lv.Esito, (FmtN $lv.CelleAttese), (FmtN $lv.RigheIS), (FmtN $lv.RigheOOS))
}
ScriviRef ""

# --- il metro, lato per lato
try{
  $MetroPf.Clear()   # gia' creato PRIMA del try -- "LATO,roIdx" -> PF OOS del metro
  $MetroCel.Clear()
  ScriviRef ">>> UN CONFONDIMENTO VERO, misurato nel sorgente (ABTG_DAX_Apertura_EU.mq5,"
  ScriviRef "    riga 674 e righe 709-737: refEndMin = openMin quando RangeMode non e'"
  ScriviRef "    OPENING): il candidato (InpRangeMode=1) arma alle 08:00 server e chiude"
  ScriviRef "    la finestra alle 17:30 (9h30); il metro (InpRangeMode=0,"
  ScriviRef "    InpRangeMinutes=35) arma alle 08:35 e chiude alla stessa ora (8h55). Il"
  ScriviRef "    delta fra candidato e metro e' in parte TEMPO (+35 min, +6,5% di"
  ScriviRef "    finestra), non solo LIVELLO."
  ScriviRef "    >>> E' MOLTO MENO GRAVE CHE SUL DOW, dove gli stessi 35 minuti valevano"
  ScriviRef "    +24% perche' la finestra del Dow e' di 3 ore invece di 9 e mezza. Resta"
  ScriviRef "    dichiarato: chi legge un vantaggio del candidato sul metro deve sapere"
  ScriviRef "    che una parte non misurata di quel vantaggio potrebbe essere la finestra"
  ScriviRef "    piu' lunga, e qui quella parte e' piccola ma non nulla."
  ScriviRef ""
  ScriviRef ">>> LA SOVRAPPOSIZIONE DI CALENDARIO CON LA SEDIA VIVA GEMELLA"
  ScriviRef "    ABTG_MaxMinNotte_DAX_Short_Ottimizzato (magic 770411, SHORT ONLY, box"
  ScriviRef "    notturno 23:00-04:59 server letto nel sorgente, ordini STOP alle 07:59,"
  ScriviRef "    cutoff ingressi 08:30). Per ogni valore dell'asse (a), quanti minuti"
  ScriviRef "    della finestra da cui il CANDIDATO ricava il livello cadono DENTRO quel"
  ScriviRef "    box:"
  ScriviRef "      prevWin   finestra del livello    minuti nel box 23:00-04:59"
  foreach($pwv in @($PWuso)){
    $mb = MinutiNelBox ([int]$pwv)
    $da = OraDiMin ($AperturaMin - [int]$pwv)
    $a  = OraDiMin $AperturaMin
    $q  = "n/d"
    if($mb -ge 0){ $q = ("" + $mb) }
    ScriviRef ("      {0,7}   {1} - {2}          {3}" -f [int]$pwv, $da, $a, $q)
  }
  ScriviRef "    >>> QUESTA E' UNA TABELLA DI CALENDARIO, NON UNA MISURA DI TRADE IN"
  ScriviRef "    COMUNE. Dice che le celle larghe costruiscono il livello dentro il box"
  ScriviRef "    della sedia viva; NON dice se i due motori operano negli stessi GIORNI."
  ScriviRef "    Quella misura vuole i due export per-trade e si fa DOPO, e SOLO se il"
  ScriviRef "    round passa (vedi la coda di questo referto)."
  ScriviRef "    >>> E il rischio e' ASIMMETRICO: la 770411 e' SHORT ONLY, quindi sul"
  ScriviRef "    lato LONG di questo round un doppione di lato NON PUO' esistere; sul"
  ScriviRef "    lato SHORT e' il caso peggiore possibile (stesso simbolo, stesso lato,"
  ScriviRef "    stessa mezz'ora, livello dalla stessa finestra)."
  ScriviRef ""
  foreach($lato in @("LONG","SHORT")){
    $lv = @($LAVORI | Where-Object { $_.Fase -eq "METRO" -and $_.Lato -eq $lato })[0]
    ScriviRef ("--- PASSO 0c -- IL METRO A PARI TF (M15), lato " + $lato + " ---")
    if($null -eq $lv -or $null -eq $lv.DatiOOS){
      ScriviRef ("  NON MISURATO (" + $(if($null -eq $lv){"lavoro assente"}else{$lv.Esito}) + "): senza il metro il criterio '+0,10 di PF' NON E' CALCOLABILE su questo lato.")
      ScriviRef ""
      continue
    }
    $gm   = Griglia $lv.DatiOOS @($PwMetro) $ROuso
    $gmIS = Griglia $lv.DatiIS  @($PwMetro) $ROuso
    ScriviRef ("  (le righe del metro si ritrovano nel CSV con InpPrevWindowMin=" + $PwMetro + ", che li' e' INERTE)")
    ScriviRef "  offset    IS: prof / PF / DD% / n           OOS: prof / PF / DD% / n     peggGio%   gemelli"
    for($j=0; $j -lt @($ROuso).Count; $j++){
      $c     = $gm["0,$j"]
      $celIS = $gmIS["0,$j"]
      if($null -eq $c){ continue }
      if($null -ne $c.Pf){ $MetroPf[($lato + "," + $j)] = [double]$c.Pf }
      $MetroCel[($lato + "," + $j)] = $c
      ScriviRef ("  {0,6}    {1,8} / {2,5} / {3,5} / {4,4}        {5,8} / {6,5} / {7,5} / {8,4}    {9,7}   {10}" -f `
         ([int]($ROuso[$j]), (FmtE $(if($null -eq $celIS){$null}else{$celIS.Profit})), (Fmt3 $(if($null -eq $celIS){$null}else{$celIS.Pf})),
          (Fmt2 $(if($null -eq $celIS){$null}else{$celIS.Dd})), (FmtN $(if($null -eq $celIS){$null}else{$celIS.N})),
          (FmtE $c.Profit), (Fmt3 $c.Pf), (Fmt2 $c.Dd), (FmtN $c.N), (FmtPg $c.Pg), $c.Gem))
      if($c.Gem -ne "IDENTICI" -and $c.Gem -ne "NON MISURATO"){
        [void]$Problemi.Add("METRO " + $lato + " offset " + [int]($ROuso[$j]) + ": gemelli " + $c.Gem + " -- il banco non e' deterministico, il numero non si legge.")
      }
    }
    if($lato -eq "LONG"){
      ScriviRef "  ATTESA DICHIARATA (non un gate): su M5 la stessa cella e' agli atti in"
      ScriviRef "  R101 con IS +3.789 / PF 1,126 / DD 5,44% / n 175 e OOS +18.030 / PF 1,397"
      ScriviRef "  / DD 7,23% / n 270, offset 200 (il valore VIVO del DAX: e' la COLONNA 200"
      ScriviRef "  che riproduce la sedia, non la 400). Riprodotti al millesimo anche da"
      ScriviRef "  R107 (G0 DAX). Se qui su M15 esce vicino, il TF su questo motore e' quasi"
      ScriviRef "  neutro; se esce lontano, il TF conta -- ed e' esattamente perche' il metro"
      ScriviRef "  0c e' stato preteso. In tutti e due i casi il metro del round e' IL NUMERO"
      ScriviRef "  MISURATO QUI, non quello di R101."
      ScriviRef "  >>> E QUESTA E' LA BARRA VERA DEL ROUND, LATO LONG: col metro a PF 1,397"
      ScriviRef "  il criterio '+0,10 di PF' chiede al candidato circa 1,50. Non e' un"
      ScriviRef "  cancello che si supera per caso, e non e' un difetto del round: e' che la"
      ScriviRef "  sedia viva del DAX e' forte."
    }else{
      ScriviRef "  PROMEMORIA -- E QUI IL DAX NON E' IL DOW: il filtro EMA su questa sedia"
      ScriviRef "  e' SPENTO, quindi il lato short ENTRA (non e' il caso del Dow, dove"
      ScriviRef "  l'EMA H4 accesa lo taglia quasi tutto). Il numero agli atti su M5 e'"
      ScriviRef "  R107: IS -996 / PF 0,965 / n 138 e OOS -1.865 / PF 0,957 / DD 12,31% /"
      ScriviRef "  n 257 -- verdetto 'NIENTE EDGE, e stavolta e' misurato' (n 257 = merito"
      ScriviRef "  misurabile per l'Emendamento A), rosso anche nell'IS che contiene la"
      ScriviRef "  discesa feb-apr 2025."
      ScriviRef "  >>> Conseguenza sul cancello: il metro short sta SOTTO 1, quindi"
      ScriviRef "  'batterlo di +0,10' darebbe ~1,06, che e' SOTTO il pavimento 1,10. Su"
      ScriviRef "  questo lato il cancello che morde e' il PF>=1,10 ASSOLUTO, e vanno"
      ScriviRef "  superati TUTTI E DUE. E se il metro short ha n(OOS) sotto 30 il"
      ScriviRef "  confronto '+0,10 di PF' non si fa proprio."
    }
    ScriviRef ""
  }

  # =====================================================================
  #  I CRITERI DI ACCETTAZIONE, applicati lato per lato.
  # =====================================================================
  $Verdetti.Clear()   # gia' creato PRIMA del try
  foreach($lato in @("LONG","SHORT")){
    $lv = @($LAVORI | Where-Object { $_.Fase -eq "GRIGLIA" -and $_.Lato -eq $lato })[0]
    ScriviRef ("=====================================================================")
    ScriviRef (" LA GRIGLIA, lato " + $lato + "  --  InpPrevWindowMin (righe) x InpRetestOffsetPts (colonne)")
    ScriviRef ("=====================================================================")
    if($null -eq $lv -or $null -eq $lv.DatiOOS){
      $Verdetti[$lato] = "NON GIUDICABILE (griglia non misurata)"
      ScriviRef ("  NON MISURATA (" + $(if($null -eq $lv){"lavoro assente"}else{$lv.Esito}) + ").")
      ScriviRef ""
      continue
    }
    $gOOS = Griglia $lv.DatiOOS $PWuso $ROuso
    $gIS  = Griglia $lv.DatiIS  $PWuso $ROuso

    ScriviRef "  IS -- profitto / PF / DD% / n"
    ScriviRef ("  prevWin |" + (($ROuso | ForEach-Object { "{0,26}" -f ("offset " + [int]$_) }) -join ""))
    for($i=0; $i -lt @($PWuso).Count; $i++){
      $riga = "  {0,7} |" -f [int]$PWuso[$i]
      for($j=0; $j -lt @($ROuso).Count; $j++){
        $c = $gIS["$i,$j"]
        if($null -eq $c){ $riga += "{0,26}" -f "n/d"; continue }
        $riga += "{0,26}" -f ((FmtE $c.Profit) + "/" + (Fmt3 $c.Pf) + "/" + (Fmt2 $c.Dd) + "/" + (FmtN $c.N))
      }
      ScriviRef $riga
    }
    ScriviRef ""
    ScriviRef "  OOS -- profitto / PF / DD% / n / peggGiornata%     <<< I CRITERI SI APPLICANO QUI"
    ScriviRef ("  prevWin |" + (($ROuso | ForEach-Object { "{0,34}" -f ("offset " + [int]$_) }) -join ""))
    $ok = @{}
    $nSotto30 = 0; $nLette = 0; $nGemBad = 0
    for($i=0; $i -lt @($PWuso).Count; $i++){
      $riga = "  {0,7} |" -f [int]($PWuso[$i])
      for($j=0; $j -lt @($ROuso).Count; $j++){
        $c = $gOOS["$i,$j"]
        $ok["$i,$j"] = $false
        if($null -eq $c){ $riga += "{0,34}" -f "n/d"; continue }
        $nLette++
        if($c.Gem -ne "IDENTICI"){ $nGemBad++ }
        $riga += "{0,34}" -f ((FmtE $c.Profit) + "/" + (Fmt3 $c.Pf) + "/" + (Fmt2 $c.Dd) + "/" + (FmtN $c.N) + "/" + (FmtPg $c.Pg))
        if($null -eq $c.N -or [double]$c.N -lt $CritN){ $nSotto30++ }
        # UNA CELLA QUALIFICA SOLO SE TUTTI E CINQUE I CRITERI SONO
        # MISURATI E PASSATI. Un criterio NON MISURATO non e' un criterio
        # passato (checklist 28-bis: il verde per assenza).
        $q = ($null -ne $c.Profit) -and ($null -ne $c.Pf) -and ($null -ne $c.Dd) -and ($null -ne $c.N) -and ($null -ne $c.Pg) -and ($c.Gem -eq "IDENTICI")
        if($q){
          $q = ([double]$c.Profit -gt 0) -and ([double]$c.Pf -ge $CritPF) -and ([double]$c.N -ge $CritN) -and
               ([double]$c.Dd -lt $CritDD) -and ([double]$c.Pg -gt $CritPegg)
        }
        $ok["$i,$j"] = $q
      }
      ScriviRef $riga
    }
    ScriviRef ""
    ScriviRef ("  celle lette: " + $nLette + "   con n(OOS) sotto " + $CritN + ": " + $nSotto30 + "   con gemelli NON identici: " + $nGemBad)
    ScriviRef "  criteri per cella (tutti insieme, in OOS):"
    ScriviRef ("    Profit > 0        |  PF >= " + $CritPF.ToString("0.00",$INV) + "  |  n >= " + $CritN +
       "  |  DD < " + $CritDD.ToString("0.0",$INV) + "%  |  Peggior Giornata % > " + $CritPegg.ToString("0.0",$INV))
    $celleOk = @()
    for($i=0; $i -lt @($PWuso).Count; $i++){ for($j=0; $j -lt @($ROuso).Count; $j++){ if($ok["$i,$j"]){ $celleOk += ("prevWin " + [int]($PWuso[$i]) + " / offset " + [int]($ROuso[$j])) } } }
    ScriviRef ("  celle che passano TUTTI i criteri: " + @($celleOk).Count)
    foreach($cel in $celleOk){ ScriviRef ("     - " + $cel) }
    ScriviRef ""

    # --- LA VALVOLA R59, prima del merito
    if($nLette -gt 0 -and $nSotto30 -eq $nLette){
      $Verdetti[$lato] = "MERITO SOSPESO (valvola R59: tutte le celle hanno n(OOS) < " + $CritN + ")"
      ScriviRef ("  >>> VALVOLA R59: TUTTE le celle hanno meno di " + $CritN + " operazioni fuori campione.")
      ScriviRef ("      NIENTE VERDETTO DI MERITO su questo lato. Il RISCHIO si legge lo")
      ScriviRef ("      stesso, perche' un drawdown e' un fatto accaduto: guarda le colonne")
      ScriviRef ("      DD e peggior giornata qui sopra.")
      ScriviRef ""
      continue
    }

    # --- le regioni
    $regioni = TrovaRegioni $ok @($PWuso).Count @($ROuso).Count
    $regBuone = @($regioni | Where-Object { @($_.Membri).Count -ge $CritRegione })
    ScriviRef ("  REGIONI di celle ADIACENTI (4 vicini, mai in diagonale) che passano tutti i criteri: " + @($regioni).Count)
    ScriviRef ("  di cui con almeno " + $CritRegione + " celle: " + @($regBuone).Count)
    $passa = $false
    $dettagli = New-Object System.Collections.ArrayList
    foreach($rg in $regioni){
      $mem = @($rg.Membri | ForEach-Object { "(" + [int]($PWuso[$_[0]]) + "," + [int]($ROuso[$_[1]]) + ")" })
      ScriviRef ("     regione di " + @($rg.Membri).Count + " celle: " + ($mem -join " "))
      if(@($rg.Membri).Count -lt $CritRegione){ ScriviRef ("        -> troppo piccola (servono " + $CritRegione + "): NON e' un altopiano, e' una cella che sporge."); continue }
      $ci = [int]$rg.Centro[0]; $cj = [int]$rg.Centro[1]
      $cc = $gOOS["$ci,$cj"]
      $ddProp = $null
      if($null -ne $cc.Dd){ $ddProp = [double]$cc.Dd * $FattoreProp }
      ScriviRef ("        centro (calcolato, MAI il picco): prevWin " + [int]($PWuso[$ci]) + " / offset " + [int]($ROuso[$cj]) +
         "  ->  PF " + (Fmt3 $cc.Pf) + "  n " + (FmtN $cc.N) + "  DD " + (Fmt2 $cc.Dd) + "%  (a taglia 100k, x" + $FattoreProp.ToString("0.00",$INV) + ": " + (Fmt2 $ddProp) + "%)")
      $kMetro = $lato + "," + $cj
      if(-not $MetroPf.ContainsKey($kMetro)){
        ScriviRef ("        confronto col METRO: NON CALCOLABILE (il metro a offset " + [int]($ROuso[$cj]) + " su questo lato non e' stato misurato). La regione NON si promuove: un candidato senza denominatore non e' un candidato.")
        [void]$dettagli.Add("regione di " + @($rg.Membri).Count + " celle: metro mancante")
        continue
      }
      $mCel = $MetroCel[$kMetro]
      $pfMetro = [double]$MetroPf[$kMetro]
      $dPF = [double]$cc.Pf - $pfMetro
      ScriviRef ("        METRO a pari offset (RangeMode=0, M15): PF " + (Fmt3 $pfMetro) + "  n " + (FmtN $mCel.N))
      ScriviRef ("        DELTA PF = " + $dPF.ToString("+0.000;-0.000;0.000",$INV) + "   soglia richiesta: >= +" + $CritDeltaPF.ToString("0.00",$INV))
      if($null -eq $mCel.N -or [double]$mCel.N -lt $CritN){
        ScriviRef ("        -> IL METRO HA n = " + (FmtN $mCel.N) + " (sotto " + $CritN + "): il denominatore non regge un confronto di MERITO (valvola R59 applicata al METRO). La regione NON si promuove.")
        [void]$dettagli.Add("regione di " + @($rg.Membri).Count + " celle: metro con n insufficiente")
        continue
      }
      if($dPF -ge $CritDeltaPF){
        ScriviRef ("        -> QUESTA REGIONE PASSA: >= " + $CritRegione + " celle adiacenti, tutti i criteri, e BATTE il metro di " + $dPF.ToString("+0.000",$INV) + " di PF.")
        $passa = $true
        [void]$dettagli.Add("regione di " + @($rg.Membri).Count + " celle, centro prevWin " + [int]($PWuso[$ci]) + " / offset " + [int]($ROuso[$cj]) + ", dPF " + $dPF.ToString("+0.000",$INV))
      }else{
        ScriviRef ("        -> NON passa: pareggia o sta sotto il metro. 'Se pareggia il metro, il livello nuovo non serve' (file prova).")
        [void]$dettagli.Add("regione di " + @($rg.Membri).Count + " celle: dPF " + $dPF.ToString("+0.000",$INV) + " sotto soglia")
      }
    }
    if($passa){ $Verdetti[$lato] = "PASSA (" + (@($dettagli) -join " ; ") + ")" }
    else      { $Verdetti[$lato] = "NON PASSA" + $(if(@($dettagli).Count -gt 0){ " (" + (@($dettagli) -join " ; ") + ")" } else { "" }) }
    ScriviRef ""
    ScriviRef "  LA LETTURA WALK-FORWARD, che NON e' il criterio firmato ma serve a"
    ScriviRef "  non prendere una fortuna per un edge. Il criterio del file prova"
    ScriviRef "  cerca la regione DENTRO l'OOS, cioe' e' uno SCREENING, non una"
    ScriviRef "  selezione fuori campione. Qui sotto la cella che l'IS avrebbe"
    ScriviRef "  scelto (centro dell'altopiano IS) e come si e' comportata in OOS:"
    $okIS = @{}
    for($i=0; $i -lt @($PWuso).Count; $i++){
      for($j=0; $j -lt @($ROuso).Count; $j++){
        $c = $gIS["$i,$j"]
        $okIS["$i,$j"] = ($null -ne $c) -and ($null -ne $c.Profit) -and ($null -ne $c.Pf) -and ($null -ne $c.N) -and
                         ([double]$c.Profit -gt 0) -and ([double]$c.Pf -ge $CritPF) -and ([double]$c.N -ge $CritN)
      }
    }
    $regIS = @(TrovaRegioni $okIS @($PWuso).Count @($ROuso).Count | Where-Object { @($_.Membri).Count -ge $CritRegione })
    if(@($regIS).Count -eq 0){
      ScriviRef "    nessuna regione IS da >= 3 celle: l'IS non avrebbe scelto niente."
    }else{
      foreach($rg in $regIS){
        $ci = [int]$rg.Centro[0]; $cj = [int]$rg.Centro[1]
        $celA = $gIS["$ci,$cj"]; $celB = $gOOS["$ci,$cj"]
        ScriviRef ("    IS sceglie prevWin " + [int]($PWuso[$ci]) + " / offset " + [int]($ROuso[$cj]) +
           "  (IS: PF " + (Fmt3 $celA.Pf) + " n " + (FmtN $celA.N) + ")  ->  OOS: PF " + (Fmt3 $(if($null -eq $celB){$null}else{$celB.Pf})) +
           " n " + (FmtN $(if($null -eq $celB){$null}else{$celB.N})) + " DD " + (Fmt2 $(if($null -eq $celB){$null}else{$celB.Dd})) +
           "% peggGio " + (FmtPg $(if($null -eq $celB){$null}else{$celB.Pg})))
      }
    }
    ScriviRef ""
  }
}
catch{
  # UN DIFETTO NELL'ANALISI NON DEVE PORTARSI VIA IL REFERTO E LO ZIP:
  # senza questo blocco un'eccezione qui uscirebbe dallo script DOPO che
  # il referto e' stato composto a meta' e PRIMA che venga scritto -- e
  # PowerShell uscirebbe con un codice che non dice niente.
  $msg = ("" + $_.Exception.Message)
  ScriviRef ("!!! LETTURA INTERROTTA: " + $msg)
  [void]$Problemi.Add("la LETTURA della griglia si e' interrotta: " + $msg + ". Il referto e' quello che era stato composto fino a quel punto: NON e' un verdetto.")
}

ScriviRef "====================================================================="
ScriviRef " IL VERDETTO, criterio per criterio"
ScriviRef "====================================================================="
ScriviRef ("  PASSO 0b costo ....... " + $S0aStato)
foreach($lato in @("LONG","SHORT")){
  $vd = "NON GIUDICATO"
  if($Verdetti.ContainsKey($lato)){ $vd = $Verdetti[$lato] }
  ScriviRef ("  lato " + $lato + " ........... " + $vd)
}
ScriviRef ""
ScriviRef "  >>> I DUE CAPPELLI CHE VANNO INSIEME ALLA PAROLA 'PASSA':"
ScriviRef "      1. 35 MINUTI: il candidato opera dalle 08:00, il metro dalle 08:35"
ScriviRef "         (misurato nel sorgente). Parte del delta e' TEMPO, non LIVELLO,"
ScriviRef "         ed e' +6,5% di finestra (sul Dow erano +24%)."
ScriviRef "      2. SCREENING: la regione e' stata cercata DENTRO l'OOS, come dice il"
ScriviRef "         criterio firmato. NON e' una selezione walk-forward. La lettura"
ScriviRef "         walk-forward e' stampata sotto ogni griglia, qui sopra."
if($DatiDaDisco){
  ScriviRef ""
  ScriviRef "  >>> NESSUNO DEI VERDETTI QUI SOPRA E' DEFINITIVO: almeno un CSV di"
  ScriviRef "      questo referto NON e' di questo lancio (vedi RILIEVI). Il pin"
  ScriviRef "      con cui e' stato prodotto non e' agli atti. Per un verdetto"
  ScriviRef "      valido servono tutte le fasi in un lancio solo, senza -SoloFase."
}
if($S0aStato -ne "SUPERATO"){
  ScriviRef ""
  ScriviRef "  >>> E IL CANCELLO DEL COSTO NON E' 'SUPERATO' (stato qui sopra):"
  ScriviRef "      il PASSO 0b del file prova viene PRIMA di qualunque PF. Finche'"
  ScriviRef "      non e' superato, quello che c'e' scritto sopra e' una MISURA,"
  ScriviRef "      non una promozione."
}
ScriviRef ""
ScriviRef " E QUELLO CHE QUESTO ROUND NON DICE, dichiarato:"
ScriviRef "  - un round che PASSA produce una CELLA CANDIDATA, non una sedia. La"
ScriviRef "    promozione in forward e' un'altra decisione, con un'altra firma."
ScriviRef "  - il DOPPIONE con ABTG_MaxMinNotte_DAX_Short_Ottimizzato (magic"
ScriviRef "    770411, SEDIA VIVA, SHORT ONLY) NON e' misurato qui. La tabella"
ScriviRef "    di calendario stampata sopra dice solo QUANTI MINUTI della"
ScriviRef "    finestra del livello cadono dentro il box notturno di quella"
ScriviRef "    sedia: NON dice se i due motori operano negli stessi GIORNI."
ScriviRef "    Se coincidessero, il candidato andrebbe SCARTATO per correlazione"
ScriviRef "    (ROTTA_PROP regola 1) anche coi numeri buoni, perche' il drawdown"
ScriviRef "    della prop e' UNO."
ScriviRef "    >>> IL PASSO SUCCESSIVO, GIA' PROGRAMMATO E NON FATTO QUI:"
ScriviRef "        due PASSATE SINGOLE sulla stessa finestra (la cella promossa"
ScriviRef "        con un magic vergine, e la cella viva 770411 con un ALTRO"
ScriviRef "        magic vergine -- mai il 770411 vero), poi i due export"
ScriviRef "        per-trade abtg_trades_<EA>_D30EUR_<magic>.csv in"
ScriviRef "        Common\\Files, e il conto delle GIORNATE in comune."
ScriviRef "        Nota di onesta': sovrapposizione_sedie.py NON serve a"
ScriviRef "        questo -- legge gli statement del FORWARD"
ScriviRef "        (data/statements/trades_auto.csv), non i per-trade di un"
ScriviRef "        backtest. Quel pezzo di codice va scritto."
ScriviRef "  - il gemello NASDAQ e' un round A PARTE (RIGA_PREOPEN_NAS.ps1),"
ScriviRef "    preparato insieme a questo, e li' la sedia e' SPENTA dal 18/08."
ScriviRef "  - lo spread NON e' misurato: e' DICHIARATO 2,0 punti indice."
ScriviRef ""
if($Fatale -ne ""){
  ScriviRef ("!!! FERMATO: " + $Fatale)
  ScriviRef ""
}
ScriviRef ("PROBLEMI: " + $Problemi.Count)
foreach($p in $Problemi){ ScriviRef ("  - " + $p) }
ScriviRef ("RILIEVI: " + $Rilievi.Count)
foreach($p in $Rilievi){ ScriviRef ("  - " + $p) }
ScriviRef ""
ScriviRef 'COME SI RIPRENDE: si riparte dalla pagina righe/RIGA_PREOPEN_DAX_DA_MANDARE.md,'
ScriviRef 'NON da questa riga. Per rifare una fase sola: -SoloFase COSTO|METRO|GRIGLIA.'

$refPath = Join-Path $Cart "REFERTO_PREOPEN_DAX.txt"
Set-Content -LiteralPath $refPath -Value ($RefTxt -join "`r`n") -Encoding ASCII
Write-Host ($RefTxt -join "`r`n")

# --- gli artefatti: solo cio' che ha girato, copiato PER NOME.
foreach($f in @("REPORT_COSTO.htm","gen_preopen_costo.ini","anteprima_costo.ini","COMPILAZIONE_FALLITA.log")){
  $src = Join-Path $Work $f
  if(Test-Path -LiteralPath $src){ Copy-Item -LiteralPath $src -Destination $Cart -Force }
}
foreach($nf in @($ProvaBase,$ProvaCosto,"PREOPEN_RETEST_DAX_M15_SHORT.txt","PREOPEN_METRO_DAX_M15.txt","PREOPEN_METRO_DAX_M15_SHORT.txt")){
  $src = Join-Path $Prove $nf
  if(Test-Path -LiteralPath $src){ Copy-Item -LiteralPath $src -Destination $Cart -Force }
}
foreach($lv in $LAVORI){
  foreach($tag in @("IS","OOS")){
    $f = Join-Path $Work ("risultati_prove\" + $EA + "\" + $EA + "_" + $Simbolo + "_" + $tag + "_" + $lv.Id + ".csv")
    if(Test-Path -LiteralPath $f){ Copy-Item -LiteralPath $f -Destination $Cart -Force }
  }
}
$zip = $Cart + ".zip"
Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $zip -Force
Write-Host ""
Write-Host ("CARTELLA: " + $Cart) -ForegroundColor Green
Write-Host ("ZIP DA MANDARE: " + $zip) -ForegroundColor Green
Write-Host "FILE ATTESI NELLO ZIP: REFERTO_PREOPEN_DAX.txt + i 5 file prova + gli 8 CSV IS/OOS + gen_preopen_costo.ini + REPORT_COSTO.htm" -ForegroundColor Gray

# --- IL CODICE D'USCITA HA UN SIGNIFICATO SOLO, e va scritto:
#     0 = un round COMPLETO, in UN LANCIO SOLO, senza problemi.
#     1 = tutto il resto, comprese le riprese e i giri a fasi.
#     Cosi' un "0" non puo' MAI voler dire "ho letto meta' round e ho
#     dato un verdetto": e' il difetto per cui un referto parziale si
#     legge come completo.
if($Fatale -ne ""){ Write-Host "ESITO: FERMATO" -ForegroundColor Red; exit 1 }
if($Problemi.Count -gt 0){ Write-Host "ESITO: COMPLETATO CON PROBLEMI" -ForegroundColor Yellow; exit 1 }
if($DatiDaDisco){ Write-Host "ESITO: PARZIALE -- almeno un CSV NON e' di questo lancio: nessun verdetto qui e' definitivo." -ForegroundColor Yellow; exit 1 }
if($FaseSel -ne ""){ Write-Host ("ESITO: PARZIALE -- e' girata la sola fase " + $FaseSel + ". Un verdetto di round vuole tutte le fasi in un lancio solo.") -ForegroundColor Yellow; exit 1 }
Write-Host ("ESITO: " + $Modo + " COMPLETATO") -ForegroundColor Green
exit 0
