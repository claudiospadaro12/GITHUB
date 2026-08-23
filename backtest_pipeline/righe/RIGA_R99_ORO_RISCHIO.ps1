# =====================================================================
#  MARCATORE_RIGA_R99_v1
#  RIGA_R99_ORO_RISCHIO.ps1  --  R99: la misura del RISCHIO delle sedie
#  oro su 22 anni di storico XAUUSD (2004.06.11 -> 2026.06.30)
# ---------------------------------------------------------------------
#  CRITERI: backtest_pipeline\risultati_archivio\R99_CRITERI.md
#  >>> FIRMATI da Claudio il 23/08/2026 in chat: "FIRMO R99, PARTIAMO
#      CON L'ORO". Questa riga NON cambia i criteri: li traduce in file
#      eseguibili, e ogni traduzione e' DICHIARATA (checklist 57).
#
#  DA DOVE NASCE QUESTO SCRIPT, dichiarato: e' RIGA_R98_MOMENTUM_NASUSD.ps1
#  adattata. Il punto 9 della checklist dice che una riscrittura non puo'
#  perdere le funzioni di sicurezza del gemello: sono state riportate
#  TUTTE, una per una -- guardia MT5/MetaEditor chiusi, download pinnato
#  col marcatore, install dell'include ABTG_PausaGuardian.mqh (l'EA lo
#  usa: verificato negli #include del sorgente), [Charts] MaxBars,
#  compilazione DIRETTA con verdetto LastWriteTime + backup datato +
#  ripristino del .mq5 se fallisce, SOSTA SVUOTATA A OGNI GIRO
#  (checklist 56), artefatti in sosta col nome proprio PRIMA dei gate
#  (checklist 41), funzioni sopra il try (checklist 48), MODO nel nome
#  della cartella e nel referto (checklist 50), log letti A OFFSET
#  (checklist 23-bis), \r? davanti a ogni $ multilinea (checklist 40),
#  cultura INVARIANTE ovunque (checklist 5), raccolta SEMPRE.
#
#  ------------------------------------------------------------------
#  LA COSA CHE COMANDA TUTTO IL DISEGNO, e va letta prima del resto:
#  ABTG_SupertrendReversal_Ottimizzato NON ESPORTA IL PER-TRADE.
#  Verificato nel sorgente: l'unico FileWrite e' quello di
#  OnTesterDeinit (blocco OPTFRAME), che scrive
#  OptResults_<EA>_<Simbolo>.csv e SOLO IN OTTIMIZZAZIONE. Non esiste
#  nessun abtg_trades_*.csv per questo EA.
#  Quindi i tre numeri firmati e i tre gate del PASSO 0 si leggono da
#  TRE artefatti diversi, e ognuno e' dichiarato (criteri par. 5.2):
#    - OptResults (ottimizzazione a 2 celle gemelle) -> n, DD, PF,
#      profitto, e i GEMELLI IDENTICI AL CENTESIMO
#    - log del tester della passata SINGOLA (InpVerbose=true) -> la
#      data della PRIMA OPERAZIONE
#    - report .htm della stessa passata singola -> la PEGGIOR GIORNATA
#      e, come SECONDA misura indipendente, di nuovo la prima data
#  Le due misure della prima data si eseguono SEMPRE tutte e due, fuori
#  dai rami l'una dell'altra (checklist 56-bis): servono a diagnosticare
#  il fallimento, non a sostituirsi.
#  ------------------------------------------------------------------
#
#  COSA FA, in ordine, e DA SOLA:
#    0. si rifiuta di partire se MT5 O MetaEditor sono aperti (checklist 7 e 39)
#    1. scarica AL PIN: file prova, sorgente .mq5, include .mqh,
#       scarica_storico.ps1 e report\CONTRATTI_SEDIE.md
#       - GATE DI VERSIONE sul .mq5: #property version "1.00",
#         InpMagic = 970901 e il marcatore [STReversal]. Se no e' cache
#         CDN o branch sbagliato -> STOP.
#       - 45 RIGHE VIVE nel file prova (3 direttive @ + 42 parametri),
#         MISURATE sull'artefatto, e i valori della cella riletti UNO
#         PER UNO nel file che gira (checklist 34-bis)
#       - IL DD PROMESSO si ESTRAE da CONTRATTI_SEDIE.md al pin, non
#         si scrive a memoria. Se non e' un numero, il referto lo dice
#         e il confronto 2x resta NON CALCOLABILE (criteri par. 3.1).
#    2. FASE COMPILA: metaeditor64 invocato DIRETTO. MAI Start-Process
#       con ArgumentList pre-quotato: sui path con spazi torna rc=0
#       SENZA compilare (pagato il 22/08). Verdetto = LastWriteTime del
#       .ex5 PRIMA/DOPO (checklist 54).
#    3. PASSO 0-A: BARRE M1+H4 di XAUUSD dal 2004.06.11, -SenzaTick.
#       >>> NIENTE TICK. Il round e' a modello OHLC M1 (criteri par. 4):
#           i tick su 22 anni NON ESISTONO e non si scaricano.
#       >>> E IL M1 QUASI CERTAMENTE NON SARA' "COMPLETO", ed e' ATTESO:
#           scarica_storico.ps1 scrive InpTimeoutSec=120 nel preset, cioe'
#           due minuti per timeframe, e 22 anni di M1 non ci stanno. Per
#           questo il verdetto non-COMPLETO sulla riga M1 finisce nelle
#           NOTE e non nei PROBLEMI (checklist 47): una spia che non puo'
#           che essere rossa non la legge piu' nessuno. Il tester completa
#           da solo mentre gira, e la misura che DECIDE resta la data
#           della prima operazione.
#    4. PASSO 0-B: UNA passata SINGOLA (magic 779912, InpVerbose=true)
#       su TUTTA la finestra -> log (prima operazione) e report .htm
#       (peggior giornata + seconda misura della prima operazione).
#    5. PASSO 0-C: UNA ottimizzazione a DUE CELLE GEMELLE (779910/11)
#       su TUTTA la finestra -> OptResults -> n, DD massimo (CRITERIO A)
#       e il gate dei gemelli al centesimo.
#    6. LA CATENA: 4 finestre di regime (CRITERIO C) + 2 finestre
#       DIAGNOSTICHE dell'oro (2008 e 2013) che NON sono criteri.
#    7. raccolta SEMPRE: cartella sul Desktop + zip, coi numeri attesi
#       dichiarati PRIMA, e i TRE NUMERI stampati accanto al DD promesso.
#
#  QUELLO CHE NON FA, dichiarato:
#    - non promuove e non boccia niente: e' un round di RISCHIO
#      (Emendamento regola B). Nessun PF entra in nessun verdetto.
#    - non tocca nessuna sedia viva. Gira su magic VERGINI del blocco
#      7799xx. Vietati e controllati: 970901 (la sedia viva XAUUSD),
#      770901 (la COLLISIONE misurata il 22/08), 770921 e 770924.
#    - non scarica tick e non svuota bases\<server>\ticks
#    - non ammazza un lavoro in corso allo scadere di -OreMax: smette
#      solo di iniziarne di nuovi (checklist 19)
#    - NON MISURA LO SPREAD e non inventa nessun numero che non abbia
#      letto in un artefatto.
#
#  QUANTO CI METTE: [STIMA] 2-6 ore, e la PRIMA passata puo' essere
#  molto piu' lunga delle altre perche' MT5 si scarica le barre M1 di
#  22 anni MENTRE gira. Il PASSO 0-B misura una passata intera e stampa
#  la proiezione. -OreMax e' 12 (tetto sull'INIZIO di nuovi lavori).
#
#  LA RIGA CHE SI INCOLLA (blocco INTERO, un comando solo - checklist 21).
#  <PIN> = il commit che contiene QUESTO file: e' l'hash dato in chat.
#
#  & { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
#      if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
#      $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_R99.ps1"; Remove-Item $p -EA SilentlyContinue;
#      irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R99_ORO_RISCHIO.ps1" -OutFile $p;
#      if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R99_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
#      $global:LASTEXITCODE=0; & $p -Pin $pin; if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - leggi il REFERTO' } }
#
#  GIRO A VUOTO (un minuto, nessuna passata, nessun MT5 che opera):
#    ... & $p -Pin $pin -SoloControllo
#  Il giro a vuoto scrive e verifica GLI STESSI .ini che girano nella
#  corsa vera. Non c'e' un secondo artefatto (checklist 33).
#  >>> E NON MISURA NESSUNO DEI TRE NUMERI: senza tester non esiste
#      nessun DD, nessun n, nessuna giornata. Sta scritto anche nel suo
#      referto, perche' non lo si scambi per il round.
# =====================================================================
param(
  # -Pin NON ha default: un default silenzioso ("lavoro") farebbe girare la
  #  punta del branch spacciandola per un commit congelato. Meglio morire.
  [string]$Pin       = "",
  [double]$OreMax    = 12.0,       # oltre questo NON si iniziano nuove finestre
  [switch]$Rifai,                  # rifa' anche le finestre gia' presenti
  [switch]$SoloControllo,
  [switch]$SenzaStorico,           # salta SOLO il PASSO 0-A (le barre)
  [switch]$SaltaPasso0             # SOLO per riprendere una coda gia' gatata.
                                   #   Se lo usi, il referto lo scrive in rosso
                                   #   E i tre gate NON ci sono.
)
$ErrorActionPreference = "Stop"
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$INV = [Globalization.CultureInfo]::InvariantCulture

$Avvio = Get-Date
$Stamp = $Avvio.ToString("yyyyMMdd_HHmm", $INV)
$Dsk   = Join-Path $env:USERPROFILE "Desktop"
$Work  = Join-Path $env:USERPROFILE "abtg_r99"
$Prove = Join-Path $Work "prove"
$Logs  = Join-Path $Work "log_r99"
$SrcDir= Join-Path $Work "src_motori"
$RawPin= "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"

$Ea       = "ABTG_SupertrendReversal_Ottimizzato"
$VersioneAttesa = "1.00"
$Sym      = "XAUUSD"
$Periodo  = "H4"
$DaQuando = "2004.06.11"      # MISURATO: sonda del 17/08, XAUUSD 22,1 anni
$Fino     = "2026.06.30"      # scritto nel CRITERIO A
$Modello  = 1                 # OHLC M1. E' il criterio par. 4, non una scelta
                              #  di comodo: i tick reali di BCM partono dal
                              #  2024.07.05 e su 22 anni NON ESISTONO. Il
                              #  numero che esce e' un LIMITE INFERIORE del
                              #  rischio, mai un permesso.
$Deposito = 100000            # taglia prop, come i round per-trade (R16/R23).
                              #  A rischio percentuale il DD% e' ~indipendente
                              #  dal deposito (CONTRATTI_SEDIE par. COME
                              #  LEGGERE I NUMERI, punto 1); il deposito grande
                              #  evita che il lotto minimo schiacci il rischio
                              #  nei primi anni, con l'oro a 400 dollari.
$SpreadIni= 0                 # 0 = spread CORRENTE, ma SCRITTO nell'ini invece
                              #  che lasciato allo stato nascosto del terminale.
                              #  NON e' uno stress di spread e NON e' una misura.
$Suffisso = "_ohlc"           # regola di casa: un OHLC non deve nemmeno poter
                              #  finire nella stessa tabella di un tick reale
$CelleAttese = 2              # le due passate GEMELLE di controllo

#--- I MAGIC. Blocco 7799xx, VERGINE: in tutto il repo il blocco contiene
#    solo 779001 (ABTG_Guardian, utility che non trada). Il magic NON
#    cambia il comportamento dell'EA: e' l'etichetta degli ordini e qui
#    l'asse gemello di controllo.
$MagicOptA    = 779910        # finestra INTERA, passata gemella A
$MagicOptB    = 779911        # finestra INTERA, passata gemella B
$MagicSingola = 779912        # finestra INTERA, passata SINGOLA (log+report)
#  >>> Le due fasi NON condividono il magic (checklist 41, pagato in R82).
$MagicVietati = @(970901,770901,770921,770924)
#  970901 = LA SEDIA VIVA (CONTRATTI_SEDIE.md, contratto PARZIALE).
#  770901 = LA COLLISIONE misurata il 22/08 (CENSIMENTO_FREQUENZA_FLOTTA par.5):
#           assegnato in due documenti a due sedie diverse, e ha davvero
#           fatto trade su XAUUSD fino al 31/07.
#  770921 / 770924 = i due SupertrendReversal di forward (preset e Nikkei H4).

#--- I GATE DEL PASSO 0 (criteri par. 5 e 5.1)
$LimiteG2     = "2005.12.31"  # la prima operazione deve cadere entro questa data
$LimiteFatale = "2010.01.01"  # oltre questa la corsa SI FERMA: senza il 2008 e
                              #  senza il 2013 la domanda del round non ha piu'
                              #  senso. >>> E' una TRADUZIONE dichiarata nei
                              #  criteri par. 5.1, non una riga della firma.

#--- RIGHE VIVE ATTESE nel file prova. MISURATA il 23/08/2026 con
#    `grep -vE '^\s*(#|$)' | wc -l` sull'artefatto: 3 direttive @ + 42
#    parametri = 45. NON scritta a memoria (checklist 40-bis).
$RigheAttese  = 45
$ParametriAttesi = 42

#--- LA CELLA, VALORE PER VALORE. Il file prova e' l'artefatto che gira;
#    questa tabella serve a RILEGGERLO (checklist 34-bis): se due valori
#    fossero scambiati o un default cambiasse nel sorgente, il conteggio
#    delle righe resterebbe verde e la cella sarebbe un'altra.
$Cella = @(
  @("InpUsaGuardian","true"),        @("InpTF","16388"),
  @("InpStMult","2.5"),              @("InpStAtrPeriod","7"),
  @("InpNearAtr","1.0"),             @("InpRequireConfirmBody","true"),
  @("InpAllowLong","true"),          @("InpAllowShort","true"),
  @("InpUseConfluence","true"),      @("InpEma1","14"),
  @("InpEma2","89"),                 @("InpEma3","100"),
  @("InpEma4","200"),                @("InpConflAtr","1.5"),
  @("InpFirstFraction","0.3333"),    @("InpUsePending","true"),
  @("InpPendingPips","20"),          @("InpPendingExpiryBars","3"),
  @("InpSLLookback","5"),            @("InpSLBufferPips","3"),
  @("InpTP1_R","1.0"),               @("InpTP1Pct","50"),
  @("InpBreakeven","true"),          @("InpTP_RR","2.5"),
  @("InpTrailOnST","true"),          @("InpExitOnFlip","true"),
  @("InpRiskPercent","1.0"),         @("InpMaxTradesPerDay","0"),
  @("InpUseTimeWindow","false"),     @("InpStartHour","0"),
  @("InpEndHour","24"),              @("InpUseNewsFilter","false"),
  @("InpNewsMinImpact","3"),         @("InpNewsBeforeMin","30"),
  @("InpNewsAfterMin","30"),         @("InpNewsShiftMinutes","0"),
  @("InpMaxSpread","0"),             @("InpVerbose","true")
)
#  (le tre righe di STRINGA -- InpNewsFile, InpNewsCurrencies, InpComment --
#   non stanno in questa tabella perche' non hanno la forma a cinque campi:
#   sono controllate a parte, per nome.)

#--- TUTTO CIO' CHE LA RACCOLTA USA NASCE QUI, PRIMA DEL try (checklist 41-bis),
#    FUNZIONI COMPRESE (checklist 48: in PowerShell una `function` non e'
#    dichiarativa, e' un'istruzione: se il flusso non ci passa sopra, il nome
#    non esiste, e la raccolta esplode proprio nella corsa fermata da un gate).
$Risultati = Join-Path $Work "risultati_prove"
$Sosta     = Join-Path $Work "sosta"
$Problemi  = New-Object System.Collections.ArrayList
$Note      = New-Object System.Collections.ArrayList
$Fatale    = ""
$VersioneLetta = "NON LETTA"

$Passo0 = @{ Fatto=$false; Minuti=0.0; MinutiOpt=0.0; LogLetti=0;
             PrimaDataLog="NON MISURATA"; PrimaDataReport="NON MISURATA";
             PrimaDataUsata="NON MISURATA"; FonteData="nessuna";
             UltimaDataReport="NON MISURATA";
             Ingressi=0; N=-1; NReport=-1;
             DDLungo=-1.0; Profit=0.0; PF=0.0; Recovery=0.0;
             Gemelli="NON MISURATO";
             PeggiorGiornata="NON MISURATA"; PeggiorGiornataPct=0.0;
             PeggiorGiornataData=""; GiorniOperativi=0;
             Finestra="NON MISURATA"; Report="NON TROVATO" }

$Contratto = @{ Riga="NON TROVATA"; DD=-1.0; Stato="NON LETTO"; Fonte="report/CONTRATTI_SEDIE.md" }
$Storico   = @{ Eseguito=$false; Esito="NON ESEGUITO" }

function Ora(){ return (Get-Date).ToString("HH:mm:ss", $INV) }
function Dico($t,$c="Gray"){ Write-Host ("[" + (Ora) + "] " + $t) -ForegroundColor $c }
function Titolo($t){ Write-Host ""; Write-Host ("=== " + $t + " ===") -ForegroundColor Cyan }

function Scarica($url,$dest,$marcatore){
  Remove-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue
  Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing -ErrorAction Stop
  if(-not (Test-Path -LiteralPath $dest)){ throw ("scarico fallito: " + $url) }
  if($marcatore -ne "" -and -not (Select-String -LiteralPath $dest -SimpleMatch -Pattern $marcatore -Quiet)){
    throw ("file scaricato SENZA il marcatore '" + $marcatore + "': " + $url)
  }
}

#  Una finestra di lavoro. Criterio = $true per le QUATTRO finestre di
#  regime (CRITERIO C dei criteri firmati); $false per le due passate
#  DIAGNOSTICHE dell'oro, che i criteri par. 8.1 chiamano per nome:
#  "servono a DICHIARARE, non a decidere" e NON entrano in nessun criterio.
function F($nome,$da,$a,$magic,$criterio,$desc){
  return [pscustomobject]@{ Nome=$nome; Da=$da; A=$a; Magic=$magic;
                            Criterio=$criterio; Desc=$desc;
                            Esito="NON ESEGUITO"; Righe=-1; DD=-1.0;
                            N=-1; Profit=0.0; PF=0.0; Gemelli="-"; Min=0.0 }
}

function CsvDi($nome){ return (Join-Path $Risultati ("R99_" + $Sym + "_" + $nome + $Suffisso + ".csv")) }

function RigheVive($p){
  return @(Get-Content -LiteralPath $p | Where-Object { $_ -notmatch '^\s*#' -and $_ -notmatch '^\s*$' })
}
function ValoreDi($riga){
  $resto = $riga.Substring($riga.IndexOf("=")+1)
  return (($resto -split '\|\|')[0]).Trim()
}
function NomeDi($riga){
  if($riga -match '^@'){ return ($riga -split '\s+')[0] }
  return (($riga -split '=')[0]).Trim()
}
#  un numero NON MISURATO si scrive "n/d", non "-1.00": un meno uno in una
#  colonna di percentuali si legge come un numero (checklist 47, il lato del
#  rumore) e nel referto di un round di RISCHIO sarebbe il peggior refuso
#  possibile.
function Fmt2($v){
  if($v -eq $null){ return "n/d" }
  if([double]$v -lt 0){ return "n/d" }
  return ([double]$v).ToString("0.00",$INV)
}
function NumInv($s){
  $v = 0.0
  $t = ("" + $s).Replace([string][char]160,"").Replace(" ","").Replace("&nbsp;","").Trim()
  if($t -eq ""){ return $null }
  if([double]::TryParse($t,[Globalization.NumberStyles]::Float,$INV,[ref]$v)){ return $v }
  return $null
}

#  LETTURA DEI LOG A OFFSET (checklist 23-bis, nella forma CORRETTA): si
#  legge SOLO cio' che e' stato scritto dopo la fotografia. Un file NON
#  cresciuto non si rilegge da capo, altrimenti il "=== FINITO" di ieri
#  sera passa per quello di adesso. E un file NATO dopo la fotografia ha
#  $da = 0 e si legge TUTTO.
function LeggiNuovo($path,$da){
  $b = $null
  try{
    $fs = [IO.File]::Open($path,[IO.FileMode]::Open,[IO.FileAccess]::Read,[IO.FileShare]::ReadWrite)
    $len = $fs.Length
    if($da % 2 -ne 0){ $da = $da - 1 }
    if($da -ge $len){ $fs.Close(); return "" }
    if($da -gt 0){ [void]$fs.Seek($da,[IO.SeekOrigin]::Begin) }
    $n = [int]($len - $da); $b = New-Object byte[] $n; $letti = 0
    while($letti -lt $n){ $q = $fs.Read($b,$letti,$n-$letti); if($q -le 0){ break }; $letti += $q }
    $fs.Close()
  }catch{ return "" }
  if($b -eq $null -or $b.Count -lt 4){ return "" }
  #  ENCODING SCELTO DAI BYTE, mai per decreto: i log MT5 sono UTF-16LE,
  #  ma non sempre col BOM (e leggendo a offset il BOM non c'e' proprio).
  #  Un -Encoding fisso legge byte a caso e la ricerca esce verde per
  #  ASSENZA (checklist 28-bis).
  $utf16 = ($b[0] -eq 0xFF -and $b[1] -eq 0xFE)
  if(-not $utf16){
    $zeri = 0; $n2 = [math]::Min(400,$b.Count)
    for($i=1;$i -lt $n2;$i+=2){ if($b[$i] -eq 0){ $zeri++ } }
    $utf16 = ($zeri -gt ($n2/4))
  }
  if($utf16){ return [Text.Encoding]::Unicode.GetString($b) }
  return [Text.Encoding]::UTF8.GetString($b)
}

#  --- LA DATA SIMULATA DENTRO UNA RIGA DI LOG ---------------------------
#  Le righe dei log agente hanno DUE date nello stesso formato: quella
#  dell'OROLOGIO REALE (con i MILLESIMI) e quella del TESTER (senza).
#  Prendere la prima che capita vorrebbe dire leggere il 2026 di adesso
#  come "prima operazione del 2004". Qui si scartano quelle coi millesimi
#  e si prende l'ULTIMA rimasta prima del marcatore dell'EA.
function DataSimulata($riga,$marcatore){
  $pre = $riga
  $i = $riga.IndexOf($marcatore)
  if($i -gt 0){ $pre = $riga.Substring(0,$i) }
  $best = $null
  foreach($m in [regex]::Matches($pre,'(\d{4}\.\d{2}\.\d{2})\s+(\d{2}:\d{2}:\d{2})(\.\d+)?')){
    if($m.Groups[3].Success){ continue }          # coi millesimi = orologio reale
    $d = [datetime]::MinValue
    if([datetime]::TryParseExact(($m.Groups[1].Value + " " + $m.Groups[2].Value),"yyyy.MM.dd HH:mm:ss",$INV,[Globalization.DateTimeStyles]::None,[ref]$d)){
      $best = $d
    }
  }
  return $best
}

#  --- I DEAL DEL REPORT .htm --------------------------------------------
#  MT5 scrive il report della passata SINGOLA quando l'ini ha Report= e
#  ReplaceReport=1. Dentro c'e' la tabella dei DEAL, ed e' l'unico posto
#  in cui questo EA lascia le operazioni una per una.
#  IL CONTROLLO POSITIVO E' DENTRO: una riga vale solo se ha una data
#  vera in prima colonna E una cella di direzione 'in'/'out'. Se non ne
#  riconosce nessuna, torna una lista VUOTA e chi chiama scrive "NON
#  MISURATA" -- mai un numero inventato.
function LeggiDeal($path){
  $out = New-Object System.Collections.ArrayList
  $txt = ""
  try{
    $by = [IO.File]::ReadAllBytes($path)
    $txt = [Text.Encoding]::UTF8.GetString($by)
    if($txt -notmatch '<t[dr]'){ $txt = [Text.Encoding]::Unicode.GetString($by) }
    if($txt -notmatch '<t[dr]'){ $txt = [Text.Encoding]::GetEncoding(1252).GetString($by) }
  }catch{ return @() }
  #  --- 1. tutte le righe ridotte a celle, una volta sola
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
  #  --- 2. LE COLONNE SI TROVANO NELL'INTESTAZIONE, MAI PER POSIZIONE.
  #  >>> DIFETTO MISURATO DAL VERIFICATORE IL 23/08, e riprodotto: la tabella
  #      dei deal di MT5 ha una colonna 'Comment'/'Commento' IN FONDO. Contando
  #      dalla fine (Count-2 / Count-1) si legge il SALDO al posto del PROFITTO
  #      e il commento al posto del saldo: la somma giornaliera diventa una
  #      somma di SALDI, sempre positiva, e la peggior giornata usciva
  #      0,00% con la data VUOTA -- un VERDE FALSO stampato al posto di
  #      'NON MISURATA', su uno dei tre numeri FIRMATI e contro un muro prop
  #      del 5%. I criteri par. 5.2 dicono l'opposto: "un numero inventato
  #      dentro un verdetto firmato sarebbe peggio di un numero mancante".
  #  >>> E l'intestazione e' LOCALIZZATA: il terminale puo' essere in italiano.
  $iProf = -1; $iSald = -1
  foreach($celle in $righe){
    if($celle.Count -lt 8){ continue }
    $p = -1; $s = -1
    for($i=0; $i -lt $celle.Count; $i++){
      $h = ("" + $celle[$i]).ToLower().Trim()
      if($h -eq "profit" -or $h -eq "profitto"){ $p = $i }
      if($h -eq "balance" -or $h -eq "saldo"){ $s = $i }
    }
    if($p -ge 0 -and $s -ge 0){ $iProf = $p; $iSald = $s; break }
  }
  #  CONTROLLO POSITIVO (checklist 55): senza intestazione riconosciuta NON si
  #  tira a indovinare la posizione. Si torna VUOTO, e chi chiama scrive
  #  'NON MISURATA' -- che e' la risposta onesta.
  if($iProf -lt 0 -or $iSald -lt 0){ return @() }
  #  --- 3. le righe dei deal, lette PER INDICE DI COLONNA
  foreach($celle in $righe){
    if($celle.Count -le [math]::Max($iProf,$iSald)){ continue }
    if($celle[0] -notmatch '^\d{4}\.\d{2}\.\d{2} \d{2}:\d{2}:\d{2}$'){ continue }
    $dir = ""
    foreach($c in $celle){
      $lc = ("" + $c).ToLower()
      if($lc -eq "in" -or $lc -eq "out" -or $lc -eq "in/out"){ $dir = $lc }
    }
    if($dir -eq ""){ continue }                    # non e' la tabella dei DEAL
    $d = [datetime]::MinValue
    if(-not [datetime]::TryParseExact($celle[0],"yyyy.MM.dd HH:mm:ss",$INV,[Globalization.DateTimeStyles]::None,[ref]$d)){ continue }
    [void]$out.Add([pscustomobject]@{ Q=$d; Dir=$dir; Profit=(NumInv $celle[$iProf]); Saldo=(NumInv $celle[$iSald]) })
  }
  return @($out)
}

Write-Host ""
Write-Host "#####################################################################" -ForegroundColor Cyan
Write-Host "#  R99 - ORO SU 22 ANNI: LA MISURA DEL RISCHIO (XAUUSD H4, OHLC M1) #" -ForegroundColor Cyan
Write-Host "#####################################################################" -ForegroundColor Cyan
Dico ("pin      : " + $Pin)
Dico ("cartella : " + $Work)

# --- LE FINESTRE. Le quattro di regime sono AGLI ATTI: prova_regime.ps1
#     righe 69-75, le stesse di R50/R56/R59. Le due dell'oro sono
#     DIAGNOSTICHE e i criteri par. 8.1 le dichiarano NON criteri.
$Lavori = @(
  (F "ORSO"     "2022.01.01" "2022.10.31" 779920 $true  "CRITERIO C - finestra ORSO (R50/R56/R59)"),
  (F "CROLLO"   "2020.02.01" "2020.04.30" 779930 $true  "CRITERIO C - finestra CROLLO (3 mesi: e' la meta' che l'Emendamento 2 assegna al RISCHIO)"),
  (F "TORO"     "2021.01.01" "2021.12.31" 779940 $true  "CRITERIO C - finestra TORO (R50/R56/R59)"),
  (F "LATERALE" "2019.01.01" "2019.12.31" 779950 $true  "CRITERIO C - finestra LATERALE (R50/R56/R59)"),
  (F "ORO2008"  "2008.07.01" "2008.12.31" 779960 $false "DIAGNOSTICA - il crollo dell'ottobre 2008 nominato dall'IPOTESI  <<< NON E' UN CRITERIO"),
  (F "ORO2013"  "2013.03.01" "2013.06.30" 779970 $false "DIAGNOSTICA - il crollo dell'aprile 2013 nominato dall'IPOTESI   <<< NON E' UN CRITERIO")
)

# =====================================================================
#  I NUMERI ATTESI, DICHIARATI PRIMA. Se a fine corsa non tornano,
#  il round non si legge.
# =====================================================================
$nCrit = @($Lavori | Where-Object { $_.Criterio }).Count
$nDiag = @($Lavori | Where-Object { -not $_.Criterio }).Count
Titolo "NUMERI ATTESI (dichiarati PRIMA della corsa)"
Write-Host ("    finestre .....................  " + $Lavori.Count + "   (" + $nCrit + " di REGIME = criterio C, + " + $nDiag + " DIAGNOSTICHE dell'oro)") -ForegroundColor White
Write-Host  "    piu' la finestra INTERA 2004.06.11 -> 2026.06.30 (criterio A), che gira nel PASSO 0" -ForegroundColor White
Write-Host ("    celle per finestra ...........  " + $CelleAttese + "   (le due passate GEMELLE di controllo, unico asse Y = InpMagic)") -ForegroundColor White
Write-Host ("    passate totali ...............  " + (2*$Lavori.Count + 3) + "   (" + (2*$Lavori.Count) + " delle finestre + 2 gemelle intere + 1 SINGOLA intera)") -ForegroundColor White
Write-Host ("    modello ......................  " + $Modello + " = OHLC su M1   <<< CRITERIO par. 4: i tick su 22 anni NON ESISTONO.") -ForegroundColor White
Write-Host  "                                    Il numero che esce e' un LIMITE INFERIORE del rischio, mai un permesso." -ForegroundColor White
Write-Host ("    deposito .....................  " + $Deposito + "   rischio 1,00% pinnato nel file prova (CRITERIO A)") -ForegroundColor White
Write-Host ("    spread .......................  Spread=" + $SpreadIni + " nell'ini = spread CORRENTE, dichiarato. NON e' una misura.") -ForegroundColor White
Write-Host ""
Write-Host  "    I TRE NUMERI CHE QUESTO ROUND DEVE PRODURRE (criteri par. 3):" -ForegroundColor Yellow
Write-Host  "      A. DD massimo dell'equity su 2004.06.11 -> 2026.06.30 al rischio 1%" -ForegroundColor Yellow
Write-Host  "      B. la PEGGIOR GIORNATA in %  (il muro prop giornaliero e' 5%)" -ForegroundColor Yellow
Write-Host  "      C. il DD massimo dentro ciascuna delle QUATTRO finestre di regime" -ForegroundColor Yellow
Write-Host  "    E UNA SOLA DECISIONE MECCANICA: se il DD lungo supera il DOPPIO del DD" -ForegroundColor Yellow
Write-Host  "    promesso in CONTRATTI_SEDIE.md, la sedia va in REVISIONE (corsia RISCHIO," -ForegroundColor Yellow
Write-Host  "    firma 18/08). Il DD promesso lo ESTRAE questa riga dall'artefatto." -ForegroundColor Yellow
Write-Host ""
Write-Host  "    >>> QUESTO ROUND NON PROMUOVE E NON BOCCIA NIENTE PER MERITO." -ForegroundColor Yellow
Write-Host  "        Emendamento regola B: il VECCHIO giudica il RISCHIO." -ForegroundColor Yellow

if($Pin -eq ""){
  Write-Host ""
  Write-Host "!!! MANCA -Pin. Questa riga gira SOLO su un commit congelato." -ForegroundColor Red
  Write-Host "    Rilancia col blocco intero, che passa -Pin <hash>." -ForegroundColor Yellow
  exit 1
}

try{

# =====================================================================
#  0. MT5 E METAEDITOR CHIUSI. Prima di qualunque altra cosa.
#     MT5 aperto = il tester non parte e escono ZERO risultati (checklist 7).
#     MetaEditor e' SINGLE-INSTANCE: se ne gira gia' una copia, il nostro
#     metaeditor64.exe /compile torna SUBITO senza aver compilato, e la
#     fase 3 dichiarerebbe "COMPILAZIONE FALLITA" su un sorgente sano
#     (checklist 39).
# =====================================================================
$vivi = @(Get-Process -Name "terminal64","metaeditor64" -ErrorAction SilentlyContinue)
if($vivi.Count -gt 0){
  Write-Host ""
  Write-Host ("!!! APERTO: " + (($vivi | ForEach-Object { $_.ProcessName } | Sort-Object -Unique) -join ", ")) -ForegroundColor Red
  Write-Host "    Non parto: col terminale aperto il tester non gira, e con MetaEditor" -ForegroundColor Red
  Write-Host "    aperto la compilazione torna subito senza compilare." -ForegroundColor Red
  Write-Host "    Chiudi MetaTrader E MetaEditor (tutte le istanze) e rilancia." -ForegroundColor Yellow
  #  DICHIARATO AD ALTA VOCE: questo exit 1 sta DENTRO il try e quindi SALTA
  #  LA RACCOLTA - niente cartella, niente referto, niente zip. Qui e'
  #  accettabile ed e' una scelta: siamo a due secondi dal lancio, non e'
  #  stato prodotto NIENTE, e non c'e' niente da raccogliere. Il messaggio a
  #  schermo E' il referto di questo caso.
  exit 1
}

# =====================================================================
#  1. SCARICO AL PIN
# =====================================================================
Titolo "1. SCARICO AL PIN"
New-Item -ItemType Directory -Force -Path $Work,$Prove,$Logs,$SrcDir,$Risultati | Out-Null

# --- 1a. IL FILE PROVA
$ProvaFile = Join-Path $Prove "R99_ORO_22ANNI_RISCHIO.txt"
Scarica ("$RawPin/backtest_pipeline/prove/R99_ORO_22ANNI_RISCHIO.txt") $ProvaFile '@SIMBOLO'
$Vive = RigheVive $ProvaFile
if($Vive.Count -ne $RigheAttese){
  throw ("il file prova ha " + $Vive.Count + " righe vive invece di " + $RigheAttese + ": artefatto cambiato, mi fermo.")
}
$ProvaPar = @($Vive | Where-Object { $_ -notmatch '^@' })
if($ProvaPar.Count -ne $ParametriAttesi){
  throw ("il file prova ha " + $ProvaPar.Count + " parametri invece di " + $ParametriAttesi + ".")
}
Dico ("file prova al pin: " + $Vive.Count + " righe vive (" + $ProvaPar.Count + " parametri + 3 direttive @)") "Green"

# --- 1b. @DAQUANDO / @SIMBOLO / @PERIODO scritti in DUE posti (file prova e
#     questa riga): si CONFRONTANO, non ci si fida del commento "se cambi
#     qui cambia anche li'" (checklist 33).
$txtProva = Get-Content -LiteralPath $ProvaFile -Raw
$m = [regex]::Match($txtProva,'(?m)^@DAQUANDO\s+([0-9]{4}\.[0-9]{2}\.[0-9]{2})')
if(-not $m.Success){ throw "nel file prova manca @DAQUANDO" }
if($m.Groups[1].Value -ne $DaQuando){ throw ("@DAQUANDO e' " + $m.Groups[1].Value + " ma questa riga dice " + $DaQuando) }
$s = [regex]::Match($txtProva,'(?m)^@SIMBOLO\s+(\S+)')
if(-not $s.Success -or $s.Groups[1].Value -ne $Sym){ throw ("@SIMBOLO non e' " + $Sym) }
$p = [regex]::Match($txtProva,'(?m)^@PERIODO\s+(\S+)')
if(-not $p.Success -or $p.Groups[1].Value -ne $Periodo){ throw ("@PERIODO non e' " + $Periodo) }

# --- 1c. I VALORI DELLA CELLA, letti NELL'ARTEFATTO CHE GIRA (checklist
#     34-bis). Il conteggio delle righe dice QUANTE sono; questo dice CHE
#     COSA valgono: con due valori scambiati il conteggio resterebbe verde
#     e la cella sarebbe un'altra.
#     >>> OGNI $ DI UNA REGEX MULTILINEA SI SCRIVE \r?$ (checklist 40): i
#         file arrivano da GitHub con CRLF, e senza \r? il match non
#         avviene MAI e il gate accuserebbe un file sano.
foreach($chk in $Cella){
  $rx = '(?m)^' + $chk[0] + '=' + [regex]::Escape($chk[1]) + '\|\|' + [regex]::Escape($chk[1]) + '\|\|0\|\|' + [regex]::Escape($chk[1]) + '\|\|N\r?$'
  if($txtProva -notmatch $rx){
    throw ("file prova: non trovo la riga '" + $chk[0] + "=" + $chk[1] + "||...||N'. La cella NON e' quella che credo: o un default del sorgente e' cambiato, o il file e' stato toccato.")
  }
}
foreach($nome in @("InpNewsFile","InpNewsCurrencies","InpComment")){
  if($txtProva -notmatch ('(?m)^' + $nome + '=')){ throw ("file prova: manca la riga di stringa " + $nome) }
}
if($txtProva -notmatch '(?m)^InpComment=STREV OTT\r?$'){ throw "file prova: InpComment non e' 'STREV OTT' (e' il commento MISURATO sul grafico vivo nel censimento .chr del 18/08)." }
# --- il rischio: e' il CRITERIO A, non un dettaglio
if($txtProva -notmatch '(?m)^InpRiskPercent=1\.0\|\|'){ throw "file prova: InpRiskPercent non e' 1.0. Il CRITERIO A dice 'al rischio 1%': con un rischio diverso il numero non e' quello firmato." }
# --- il magic: coppia VERGINE, e MAI una sedia viva
$mg = [regex]::Match($txtProva,'(?m)^InpMagic=(\d+)\|\|(\d+)\|\|1\|\|(\d+)\|\|Y\r?$')
if(-not $mg.Success){ throw "file prova: InpMagic non e' nella forma gemella 'm||m||1||m+1||Y'. Senza quell'asse non esistono le due passate gemelle, e il gate 3 del PASSO 0 non ha niente da confrontare." }
$m0 = [int]$mg.Groups[2].Value; $m1 = [int]$mg.Groups[3].Value
if($m0 -ne $MagicOptA -or $m1 -ne $MagicOptB){ throw ("file prova: la coppia gemella e' " + $m0 + "/" + $m1 + " ma questa riga dice " + $MagicOptA + "/" + $MagicOptB) }
foreach($v in $MagicVietati){
  if($txtProva -match ('(?m)^InpMagic=' + $v + '\|\|')){ throw ("file prova: usa il magic " + $v + ", che e' di una SEDIA VIVA o della COLLISIONE del 22/08. Fermo tutto.") }
}
# --- e nessun ALTRO asse Y: questa e' UNA cella, non una griglia
$assiY = @([regex]::Matches($txtProva,'(?m)^(\w+)=[^\r\n]*\|\|\s*[Yy]\s*\r?$') | ForEach-Object { $_.Groups[1].Value })
if($assiY.Count -ne 1 -or $assiY[0] -ne "InpMagic"){
  throw ("file prova: gli assi spazzolati sono [" + ($assiY -join ", ") + "] invece del solo InpMagic. Piu' di un asse vorrebbe dire una GRIGLIA, e i criteri dicono 'Nessuno sweep: questa e' UNA cella'.")
}
Dico ("cella riletta nel file: " + $Cella.Count + " valori + 3 stringhe, rischio 1,00%, unico asse Y = InpMagic " + $m0 + "/" + $m1) "Green"

# --- 1d. IL SORGENTE E IL GATE DI VERSIONE.
$srcMq5 = Join-Path $SrcDir ($Ea + ".mq5")
Scarica ("$RawPin/mql5/Experts/" + $Ea + ".mq5") $srcMq5 '[STReversal]'
$txtSrc = Get-Content -LiteralPath $srcMq5 -Raw
$mv = [regex]::Match($txtSrc,'#property\s+version\s+"([^"]+)"')
if(-not $mv.Success){ throw ($Ea + ".mq5 scaricato senza #property version: non e' il sorgente che credo.") }
$VersioneLetta = $mv.Groups[1].Value
if($VersioneLetta -ne $VersioneAttesa){
  throw ($Ea + ".mq5 dichiara version '" + $VersioneLetta + "' invece di '" + $VersioneAttesa + "'. O la cache di raw.githubusercontent serve una copia vecchia, o il pin e' sbagliato.")
}
if($txtSrc -notmatch 'InpMagic\s*=\s*970901'){ throw ($Ea + ".mq5 non dichiara InpMagic = 970901: non e' il motore della sedia viva (CONTRATTI_SEDIE.md).") }
if($txtSrc -notmatch 'ABTG_PausaGuardian\.mqh'){ throw ($Ea + ".mq5 non include ABTG_PausaGuardian.mqh: il sorgente non e' quello che credo, e l'install dell'include della fase 2a sarebbe inutile.") }
#  >>> IL MARCATORE DELLA RIGA D'INGRESSO, PRESO DAL SORGENTE CHE LA
#      PRODUCE (checklist 55): e' da quella riga che il gate 1 legge la
#      data della prima operazione. Se il testo cambiasse, il gate
#      resterebbe muto e questo throw lo dice PRIMA di due ore di macchina.
if($txtSrc -notmatch '%s mercato %\.2f lot'){ throw ($Ea + ".mq5 non contiene piu' la Log() dell'ingresso a mercato ('%s mercato %.2f lot'): il gate 1 non avrebbe niente da leggere nel log.") }
#  >>> E la conferma che il per-trade NON esiste: e' il fatto su cui e'
#      costruito tutto il disegno (criteri par. 5.2). Se un giorno l'EA
#      guadagnasse un export, questa riga lo fa notare invece di lasciarlo
#      scoprire per caso.
if($txtSrc -match 'abtg_trades_'){
  [void]$Note.Add("IL SORGENTE ORA ESPORTA UN PER-TRADE (trovata la stringa 'abtg_trades_'): il disegno di R99 e' costruito sul fatto che NON lo faccia (criteri par. 5.2). La corsa prosegue e i numeri restano validi, ma il prossimo round su questo EA puo' usare uno strumento migliore.")
}
Dico ($Ea + ".mq5 al pin, version " + $VersioneLetta + " (magic sorgente 970901, include Guardian, Log d'ingresso presente)") "Green"

# --- 1e. IL DD PROMESSO: si ESTRAE DALL'ARTEFATTO, non si scrive a memoria.
#     (criteri par. 3.1). E il parser e' DELIBERATAMENTE STRETTO: nella
#     stessa cella del contratto c'e' il numero 2,74, che e' il PF e NON
#     il DD. Un regex largo lo prenderebbe per denominatore e produrrebbe
#     un verdetto firmato costruito su un numero sbagliato.
$Contr = Join-Path $Work "CONTRATTI_SEDIE.md"
Scarica ("$RawPin/report/CONTRATTI_SEDIE.md") $Contr 'DD promesso'
$righeC = @(Get-Content -LiteralPath $Contr | Where-Object { $_ -match '^\s*\|' -and $_ -match 'ABTG_SupertrendReversal_Ottimizzato' -and $_ -match 'XAUUSD' })
if($righeC.Count -eq 0){
  $Contratto.Stato = "RIGA NON TROVATA"
  [void]$Problemi.Add("CONTRATTO: in CONTRATTI_SEDIE.md non trovo nessuna riga di tabella con 'ABTG_SupertrendReversal_Ottimizzato' e 'XAUUSD'. Il confronto 2x non ha ne' numeratore ne' denominatore, e questo NON e' un via libera: e' un documento cambiato sotto ai piedi del round.")
} else {
  if($righeC.Count -gt 1){
    [void]$Problemi.Add("CONTRATTO: trovate " + $righeC.Count + " righe per questa sedia in CONTRATTI_SEDIE.md. Uso la PRIMA e le riporto tutte nel referto: due contratti per una sedia sola vanno sistemati prima di leggere un verdetto.")
  }
  #  la riga arriva da un .md pieno di accenti ed emoji, e il referto si
  #  scrive in ASCII: si ripulisce QUI, una volta sola, cosi' nel referto
  #  non compaiono punti interrogativi al posto delle parole.
  $Contratto.Riga = ([regex]::Replace($righeC[0].Trim(),'[^\x20-\x7E]','.'))
  $Contratto.Stato = "RIGA TROVATA"
  #  regex STRETTA: un numero decimale seguito da % che segua di poco la
  #  sigla DD, e che NON sia preceduto da 'PF'.
  $mm = [regex]::Match($Contratto.Riga,'DD[^|]{0,24}?(\d+[.,]\d+)\s*%')
  if($mm.Success){
    $pre = $Contratto.Riga.Substring(0,$mm.Groups[1].Index)
    if($pre -match 'PF\s*$'){
      $Contratto.Stato = "NUMERO SCARTATO (era preceduto da PF)"
    } else {
      $v = NumInv ($mm.Groups[1].Value.Replace(",","."))
      if($v -ne $null -and $v -gt 0){ $Contratto.DD = $v; $Contratto.Stato = "DD PROMESSO ESTRATTO" }
    }
  }
  if($Contratto.DD -le 0 -and $Contratto.Stato -eq "RIGA TROVATA"){
    $Contratto.Stato = "DD PROMESSO NON NUMERICO"
  }
}
if($Contratto.DD -gt 0){
  Dico ("DD promesso ESTRATTO dal contratto: " + $Contratto.DD.ToString("0.00",$INV) + "%   -> soglia 2x = " + (2*$Contratto.DD).ToString("0.00",$INV) + "%") "Green"
} else {
  Dico ("DD promesso: " + $Contratto.Stato + " -> il confronto 2x sara' NON CALCOLABILE (criteri par. 3.1). NON e' un via libera.") "Yellow"
  [void]$Note.Add("CONFRONTO 2x NON CALCOLABILE: il contratto di questa sedia e' PARZIALE e il DD promesso NON E' UN NUMERO. Il criterio firmato NON viene toccato: si dichiara che il denominatore non esiste, e questo e' esso stesso un rilievo della corsia RISCHIO (una sedia viva sull'oro senza DD promesso non ha nessun metro). I tre numeri che R99 misura sono CANDIDATI a riempire quel contratto: riempirlo e' una FIRMA NUOVA, non un esito automatico di questo round.")
}

# =====================================================================
#  2. TERMINALE E CARTELLA DATI (per NOME, mai il primo che capita)
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
$MqlInclude = Join-Path $DataFolder "MQL5\Include"
$MqlFiles   = Join-Path $DataFolder "MQL5\Files"
New-Item -ItemType Directory -Force -Path $MqlExperts,$MqlInclude,$MqlFiles,$Sosta | Out-Null

# --- 2-bis. LA SOSTA SI SVUOTA A OGNI GIRO (checklist 56, difetto trovato
#     dal verificatore su R97). Il documento PRESCRIVE il giro a vuoto
#     PRIMA della corsa vera: senza questa pulizia gli .ini del giro a
#     vuoto finirebbero nello zip della corsa vera, indistinguibili da
#     quelli veri. Non si perde niente: la sosta e' una copia di lavoro,
#     l'archivio e' la cartella datata sul Desktop, che non si sovrascrive
#     mai (checklist 12).
$nSosta = @(Get-ChildItem -LiteralPath $Sosta -File -ErrorAction SilentlyContinue).Count
if($nSosta -gt 0){
  Get-ChildItem -LiteralPath $Sosta -File -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
  $nSostaDopo = @(Get-ChildItem -LiteralPath $Sosta -File -ErrorAction SilentlyContinue).Count
  if($nSostaDopo -gt 0){
    [void]$Problemi.Add("sosta: " + $nSostaDopo + " file su " + $nSosta + " di un giro PRECEDENTE non sono stati cancellati. Possono finire nello zip di questo round spacciandosi per artefatti di adesso: controllare le date dentro lo zip prima di leggerlo.")
  }
  Dico ("sosta svuotata: " + $nSosta + " file di un giro precedente rimossi (rimasti: " + $nSostaDopo + ")") "Green"
}
#  OGNI PASSO STAMPA IL BERSAGLIO CHE HA SCELTO (checklist 37).
Dico ("terminale : " + $Terminal)
Dico ("dati      : " + $DataFolder + "   (DEVE restare lo stesso in tutti i passi)")

# --- 2a. L'INCLUDE CHE NESSUN DRIVER INSTALLA (checklist 33-bis).
#     ABTG_SupertrendReversal_Ottimizzato.mq5 fa
#     #include <ABTG_PausaGuardian.mqh> (verificato alla 1d): senza questa
#     riga la compilazione fallisce e il round muore alla prima passata.
#     Pagato due volte (21/08 e 22/08).
#     NOTA: nel tester il Guardian e' FAIL-OPEN TOTALE (le sue
#     GlobalVariable non esistono li'), e il sorgente lo dichiara: non
#     cambia una virgola del backtest.
$mqh = Join-Path $MqlInclude "ABTG_PausaGuardian.mqh"
Scarica ("$RawPin/mql5/Include/ABTG_PausaGuardian.mqh") $mqh 'ABTG_GuardiaIngresso'
$vfy = Get-Item -LiteralPath $mqh
if($vfy.PSIsContainer){ throw "ABTG_PausaGuardian.mqh: in Include c'e' una CARTELLA con quel nome (checklist 27-ter)." }
if($vfy.Length -lt 4000){ throw ("ABTG_PausaGuardian.mqh e' lungo " + $vfy.Length + " byte: troppo poco, scarico monco.") }
Dico ("include installato: ABTG_PausaGuardian.mqh (" + $vfy.Length + " byte)") "Green"

# --- 2b. PULIZIA DEGLI ARTEFATTI VECCHI, PRIMA (checklist 14 e 53).
#     >>> SOLO se si corre davvero: un giro a vuoto che cancella gli
#         artefatti di una corsa vera fatta ieri e' un danno.
#     >>> QUESTO EA NON SCRIVE NESSUN abtg_trades_*: non c'e' niente da
#         cancellare in Common\Files, e quindi NESSUN per-trade di
#         nessuna sedia viva puo' essere toccato da questa riga.
$OptCsv = Join-Path $MqlFiles ("OptResults_" + $Ea + "_" + $Sym + ".csv")
if($SoloControllo){
  Dico "SoloControllo: NON cancello niente (ne' OptResults, ne' Tester\cache)." "Yellow"
} else {
  Remove-Item -LiteralPath $OptCsv -Force -ErrorAction SilentlyContinue
  # --- la CACHE del tester, e SOLO quella. MAI bases\<server>\ticks.
  #  >>> CON -LiteralPath IL * NON E' UN WILDCARD (checklist 46).
  #  >>> E NON SI CREDE ALL'INTENZIONE: si conta PRIMA e DOPO.
  $cache = Join-Path $DataFolder "Tester\cache"
  if(Test-Path -LiteralPath $cache){
    $nc = @(Get-ChildItem -LiteralPath $cache -Force -Recurse -File -ErrorAction SilentlyContinue).Count
    Get-ChildItem -LiteralPath $cache -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    $nr = @(Get-ChildItem -LiteralPath $cache -Force -Recurse -File -ErrorAction SilentlyContinue).Count
    if($nr -gt 0){
      [void]$Problemi.Add("Tester\cache NON svuotata: " + $nr + " file su " + $nc + " sono rimasti. MT5 puo' ripescare passate gia' calcolate e NON riscrivere i frame: l'OptResults uscirebbe con meno righe delle celle chieste (punto 38).")
      Dico ("Tester\cache: " + $nc + " file prima, " + $nr + " RIMASTI. NON e' stata svuotata.") "Red"
    } else {
      Dico ("Tester\cache svuotata: " + $nc + " file prima, " + $nr + " dopo. bases\<server>\ticks NON toccata.") "Green"
    }
  } else { Dico "Tester\cache non esiste: niente da svuotare." "Gray" }
  #  e i report .htm di un giro precedente: un report vecchio letto come
  #  nuovo darebbe la peggior giornata SBAGLIATA (checklist 23).
  foreach($rad in @($InstDir,$DataFolder,$Work)){
    foreach($f in @(Get-ChildItem -LiteralPath $rad -Filter "R99_*.htm*" -File -ErrorAction SilentlyContinue)){
      Remove-Item -LiteralPath $f.FullName -Force -ErrorAction SilentlyContinue
    }
  }
}

# =====================================================================
#  3. FASE COMPILA. .ex5 SCRITTO ADESSO.
#     >>> INVOCAZIONE DIRETTA di metaeditor64.exe (checklist 54 e bug del
#         22/08): con Start-Process -ArgumentList a stringhe pre-quotate,
#         sui path con spazi ("Program Files") torna rc=0 SENZA compilare.
#     >>> E IL VERDETTO E' IL LastWriteTime DEL .ex5 PRIMA/DOPO, non
#         "esiste" e non "e' recente": il file c'era gia'.
#     >>> ATTENZIONE, ed e' scritto anche nella riga di chat: questo EA e'
#         UNA SEDIA VIVA. Il terminale di backtest e' collegato al conto
#         vero. Per questo il .mq5 E il .ex5 vengono salvati in un backup
#         DATATO prima di essere toccati, e se la compilazione fallisce il
#         .mq5 viene RIMESSO com'era: sorgente e binario devono restare la
#         stessa versione, sempre (checklist 54).
# =====================================================================
Titolo "3. FASE COMPILA"
$mq5 = Join-Path $MqlExperts ($Ea + ".mq5")
$ex5 = Join-Path $MqlExperts ($Ea + ".ex5")
$logC= Join-Path $MqlExperts ($Ea + ".log")
$bakMq5 = $mq5 + ".prima_r99_" + $Stamp
$bakEx5 = $ex5 + ".prima_r99_" + $Stamp
if((Test-Path -LiteralPath $mq5) -and -not (Test-Path -LiteralPath $bakMq5)){ Copy-Item -LiteralPath $mq5 -Destination $bakMq5 -Force }
if((Test-Path -LiteralPath $ex5) -and -not (Test-Path -LiteralPath $bakEx5)){ Copy-Item -LiteralPath $ex5 -Destination $bakEx5 -Force }
Copy-Item -LiteralPath $srcMq5 -Destination $mq5 -Force
#  verifica della copia sul CONTENUTO, non sul nome (checklist 27-ter)
$lenSrc = (Get-Item -LiteralPath $srcMq5).Length
$vc = Get-Item -LiteralPath $mq5 -ErrorAction SilentlyContinue
if(-not $vc -or $vc.PSIsContainer -or $vc.Length -ne $lenSrc){ throw "copia del .mq5 in MQL5\Experts NON verificata (lunghezza diversa o e' una cartella)." }
$ex5Prima = (Get-Date).AddYears(-100)
if(Test-Path -LiteralPath $ex5){ $ex5Prima = (Get-Item -LiteralPath $ex5).LastWriteTime }
Remove-Item -LiteralPath $logC -Force -ErrorAction SilentlyContinue
& $MetaEditor "/compile:$mq5" "/log:$logC" | Out-Null
$rcMe = $LASTEXITCODE
$ex5Dopo = $null
if(Test-Path -LiteralPath $ex5){ $ex5Dopo = (Get-Item -LiteralPath $ex5).LastWriteTime }
$compileOk = ($ex5Dopo -ne $null) -and ($ex5Dopo -gt $ex5Prima)
$testoLog = ""
if(Test-Path -LiteralPath $logC){
  try{ $testoLog = (Get-Content -LiteralPath $logC -Raw -Encoding Unicode) }catch{ $testoLog = "" }
  if($testoLog -notmatch '(?i)error'){ try{ $testoLog = (Get-Content -LiteralPath $logC -Raw) }catch{} }
  Copy-Item -LiteralPath $logC -Destination (Join-Path $Sosta "compile_r99.log") -Force -ErrorAction SilentlyContinue
}
if(-not $compileOk){
  if($testoLog -ne ""){
    Write-Host "--- log del compilatore (ultime righe) ---" -ForegroundColor DarkYellow
    foreach($r in @($testoLog -split "\r?\n" | Select-Object -Last 20)){ Write-Host ("   " + $r) -ForegroundColor DarkYellow }
  } else { Write-Host "   (nessun log prodotto da MetaEditor)" -ForegroundColor DarkYellow }
  if(Test-Path -LiteralPath $bakMq5){ Copy-Item -LiteralPath $bakMq5 -Destination $mq5 -Force }
  throw ("COMPILAZIONE FALLITA per " + $Ea + " (metaeditor rc=" + $rcMe + ", .ex5 NON riscritto). Il .mq5 e' stato RIMESSO com'era dal backup: sorgente e binario restano la stessa versione. Il round si ferma qui e il log e' nello zip. Sospetto n.1: MetaEditor gia' aperto, oppure l'include ABTG_PausaGuardian.mqh.")
}
$mw = [regex]::Match($testoLog,'(?i)(\d+)\s+warning')
if($mw.Success -and [int]$mw.Groups[1].Value -gt 0){
  [void]$Note.Add("compilazione: " + $mw.Groups[1].Value + " warning (0 errori). Non fermano il round, ma vanno letti nel log compile_r99.log dello zip.")
}
Dico ("COMPILATO " + $Ea + " v" + $VersioneLetta + " (.ex5 riscritto adesso, metaeditor rc=" + $rcMe + ")") "Green"

# =====================================================================
#  LE DUE FABBRICHE DI .ini. Un solo artefatto: le righe le detta il
#  FILE PROVA, non questa riga (checklist 33).
# =====================================================================
#  (a) OTTIMIZZAZIONE a due celle gemelle -> OptResults con n, DD, PF.
#      Le righe restano in FORMA COMPLETA v||v||0||v||N: un pin scritto
#      "Nome=v" secco imposta il valore ma NON spegne il flag di
#      ottimizzazione che MT5 ricorda dall'ultima griglia di quell'EA
#      (checklist 5), e qui Optimization=1 lo renderebbe letale.
function IniOtt($da,$a,$magic,$dest,$report){
  $out = New-Object System.Collections.ArrayList
  foreach($r in $ProvaPar){
    if((NomeDi $r) -eq "InpMagic"){ [void]$out.Add("InpMagic=" + $magic + "||" + $magic + "||1||" + ($magic+1) + "||Y") }
    else { [void]$out.Add($r) }
  }
  $inputs = ($out -join "`r`n")
  # --- gate sullo STATO FINALE, non sul replace (checklist 33)
  if(@($out).Count -ne $ParametriAttesi){ throw ("ini OTT: " + @($out).Count + " parametri invece di " + $ParametriAttesi) }
  $yy = @([regex]::Matches($inputs,'(?m)^(\w+)=[^\r\n]*\|\|\s*[Yy]\s*\r?$') | ForEach-Object { $_.Groups[1].Value })
  if($yy.Count -ne 1 -or $yy[0] -ne "InpMagic"){ throw ("ini OTT: assi Y = [" + ($yy -join ", ") + "] invece del solo InpMagic.") }
  if($inputs -notmatch ('(?m)^InpMagic=' + $magic + '\|\|' + $magic + '\|\|1\|\|' + ($magic+1) + '\|\|Y\r?$')){ throw ("ini OTT: InpMagic non pinnato a " + $magic + "/" + ($magic+1)) }
  if($inputs -notmatch '(?m)^InpRiskPercent=1\.0\|\|'){ throw "ini OTT: InpRiskPercent non e' 1.0 (CRITERIO A)." }
  foreach($chk in $Cella){
    if($inputs -notmatch ('(?m)^' + $chk[0] + '=' + [regex]::Escape($chk[1]) + '\|\|')){ throw ("ini OTT: " + $chk[0] + " non vale " + $chk[1] + ": NON e' la cella congelata.") }
  }
  $testo = @"
[Charts]
MaxBars=2000000000

[Experts]
AllowLiveTrading=false
AllowDllImport=false

[Tester]
Expert=$Ea.ex5
Symbol=$Sym
Period=$Periodo
Model=$Modello
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

#  (b) PASSATA SINGOLA -> log (righe d'ingresso) e report .htm (i deal).
#      Qui i valori si scrivono SECCHI e Optimization=0: e' una passata
#      sola, e un "||" rimasto vorrebbe dire un'ottimizzazione travestita.
function IniSingola($da,$a,$magic,$dest,$report){
  $out = New-Object System.Collections.ArrayList
  foreach($r in $ProvaPar){
    $nome = NomeDi $r
    if($nome -eq "InpMagic"){ [void]$out.Add("InpMagic=" + $magic) }
    else { [void]$out.Add($nome + "=" + (ValoreDi $r)) }
  }
  $inputs = ($out -join "`r`n")
  if(@($out).Count -ne $ParametriAttesi){ throw ("ini SINGOLA: " + @($out).Count + " parametri invece di " + $ParametriAttesi) }
  if($inputs -match '\|\|'){ throw "ini SINGOLA: e' rimasto uno sweep '||'. Sarebbe un'ottimizzazione, non una passata singola -- e in ottimizzazione le Print non le legge nessuno (checklist 34), cioe' il gate 1 resterebbe muto." }
  if($inputs -notmatch '(?m)^InpVerbose=true\r?$'){ throw "ini SINGOLA: InpVerbose non e' true: l'EA non stamperebbe le righe d'ingresso e la PRIMA OPERAZIONE non sarebbe leggibile." }
  if($inputs -notmatch '(?m)^InpRiskPercent=1\.0\r?$'){ throw "ini SINGOLA: InpRiskPercent non e' 1.0 (CRITERIO A)." }
  if($inputs -notmatch ('(?m)^InpMagic=' + $magic + '\r?$')){ throw ("ini SINGOLA: InpMagic non pinnato a " + $magic) }
  foreach($chk in $Cella){
    if($inputs -notmatch ('(?m)^' + $chk[0] + '=' + [regex]::Escape($chk[1]) + '\r?$')){ throw ("ini SINGOLA: " + $chk[0] + " non vale " + $chk[1] + ": NON e' la cella congelata.") }
  }
  $testo = @"
[Charts]
MaxBars=2000000000

[Experts]
AllowLiveTrading=false
AllowDllImport=false

[Tester]
Expert=$Ea.ex5
Symbol=$Sym
Period=$Periodo
Model=$Modello
Spread=$SpreadIni
Optimization=0
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

#  --- le radici dei log del tester, fotografate a OFFSET
$RadiciLog = @(
  (Join-Path $DataFolder "Tester"),
  (Join-Path $InstDir    "Tester"),
  (Join-Path $env:APPDATA "MetaQuotes\Tester"),
  (Join-Path $DataFolder "MQL5\Logs")
)
function FotografaLog(){
  $h = @{}
  foreach($rad in $RadiciLog){
    if(-not (Test-Path -LiteralPath $rad)){ continue }
    foreach($f in @(Get-ChildItem -LiteralPath $rad -Recurse -Filter "*.log" -File -ErrorAction SilentlyContinue)){ $h[$f.FullName] = $f.Length }
  }
  return $h
}

# =====================================================================
#  4-A. PASSO 0-A -- LE BARRE M1 + H4. NIENTE TICK.
#     Il round e' a modello OHLC M1 (criteri par. 4): il tester costruisce
#     le barre H4 dalle M1, quindi la profondita' che MORDE e' quella
#     dell'M1 (checklist 18). Le barre M1 di 22 anni sono TANTE: qui il
#     -TimeoutMin e' 90, e un timeout NON e' un successo (checklist 19) ->
#     finisce nei PROBLEMI, e il gate vero resta la data della prima
#     operazione.
# =====================================================================
if(-not $SoloControllo -and -not $SaltaPasso0 -and -not $SenzaStorico){
  Titolo "4-A. PASSO 0-A - LE BARRE M1+H4 DI XAUUSD DAL 2004"
  $ScStorico = Join-Path $Work "scarica_storico.ps1"
  $t0A = Get-Date       # serve a distinguere un referto NUOVO da uno di ieri
  try{
    Scarica ("$RawPin/backtest_pipeline/scarica_storico.ps1") $ScStorico 'REFERTO STORICO'
    #  >>> ANCHE QUESTO GEMELLO VA PINNATO (difetto 24). <<<
    $stTxt = Get-Content -LiteralPath $ScStorico -Raw
    $stNew = $stTxt -replace '\$EABranch\s*=\s*"lavoro"', ('$EABranch="' + $Pin + '"')
    if($stNew -eq $stTxt){ throw "non sono riuscito a pinnare EABranch in scarica_storico.ps1: riga non trovata" }
    Set-Content -LiteralPath $ScStorico -Value $stNew -Encoding ASCII
    if(-not (Select-String -LiteralPath $ScStorico -SimpleMatch -Pattern ('$EABranch="' + $Pin + '"') -Quiet)){ throw "pin di EABranch NON verificato in scarica_storico.ps1" }
    #  checklist 51: l'ini che quello script passa a terminal64 /config deve
    #  avere [Experts] AllowLiveTrading=false, o aprire MT5 per MISURARE
    #  riarma il profilo del conto vivo.
    if(-not (Select-String -LiteralPath $ScStorico -SimpleMatch -Pattern 'AllowLiveTrading=false' -Quiet)){
      throw "scarica_storico.ps1 NON scrive [Experts] AllowLiveTrading=false nell'ini: aprirebbe il terminale riarmando la flotta sul conto vivo (checklist 51). Mi fermo."
    }
    Dico ("scarica_storico.ps1 PINNATO e con AllowLiveTrading=false verificato") "Green"
    $global:LASTEXITCODE = 0
    & powershell.exe -ExecutionPolicy Bypass -File $ScStorico -Simboli $Sym -Da $DaQuando -Timeframes "M1,H4" -SenzaTick -Auto -TimeoutMin 90 2>&1 |
      Tee-Object -FilePath (Join-Path $Logs "passo0a_storico.txt") | Out-Host
    $Storico.Eseguito = $true
    $Storico.Esito = "eseguito, uscita " + $LASTEXITCODE
    if($LASTEXITCODE -ne 0){
      $che = "errore"
      if($LASTEXITCODE -eq 2){ $che = "TIMEOUT dei 90 minuti: MT5 fermato a meta', il referto storico e' PARZIALE (ma c'e', e lo leggo lo stesso)" }
      [void]$Problemi.Add("PASSO 0-A: scarica_storico.ps1 e' uscito con codice " + $LASTEXITCODE + " -> " + $che + ". Il gate sulla PRIMA OPERAZIONE resta la misura che decide.")
    }
    #  >>> E ANCHE QUI SI GUARDA LA DATA (checklist 23). <<<
    $csvSt = Join-Path $MqlFiles "ABTG_StoricoScaricato.csv"
    if((Test-Path -LiteralPath $csvSt) -and ((Get-Item -LiteralPath $csvSt).LastWriteTime -lt $t0A)){
      [void]$Problemi.Add("PASSO 0-A: il referto storico e' del " +
                          (Get-Item -LiteralPath $csvSt).LastWriteTime.ToString("yyyy-MM-dd HH:mm",$INV) +
                          ", PRIMA dell'avvio di questo passo: e' STANTIO e NON descrive questa corsa. Non lo leggo.")
      $csvSt = ""
    }
    if($csvSt -ne "" -and (Test-Path -LiteralPath $csvSt)){
      Copy-Item -LiteralPath $csvSt -Destination (Join-Path $Sosta "passo0a_storico.csv") -Force -ErrorAction SilentlyContinue
      #  LE COLONNE VERE le scrive ABTG_HistoryDownloader.mq5:
      #    Simbolo,Timeframe,Barre,PrimaDataLocale,PrimaDataServer,Verdetto
      #  'Stato' NON esiste: PowerShell risponderebbe $null in silenzio
      #  (checklist 46-bis).
      $vistoSym = $false
      foreach($r in (Import-Csv -LiteralPath $csvSt)){
        $sy = ("" + $r.Simbolo).Trim().ToUpper()
        if($sy -ne $Sym){ continue }
        $vistoSym = $true
        $verd = ("" + $r.Verdetto).Trim()
        $vv = $verd
        if($vv -eq ""){ $vv = "VERDETTO VUOTO" }
        [void]$Note.Add("PASSO 0-A: " + $sy + " " + $r.Timeframe + " | barre " + $r.Barre +
                        " | disco " + $r.PrimaDataLocale + " | broker " + $r.PrimaDataServer + " -> " + $vv)
        #  >>> LA GUARDIA SI SCRIVE AL POSITIVO (checklist 40-ter e 47). <<<
        if($verd -like "MANCA STORICO LOCALE*"){
          [void]$Note.Add("PASSO 0-A: " + $sy + " " + $r.Timeframe + " -> '" + $verd + "' (BENIGNO: c'e' sul server, non ancora sul disco. Il tester si scarica il resto da solo -- ed e' anche il motivo per cui la PRIMA passata puo' durare molto piu' delle altre.)")
        }
        elseif($verd -ne "COMPLETO"){
          $che = "'" + $verd + "'"
          if($verd -eq ""){ $che = "VUOTO (formato del referto cambiato: NON e' stato letto)" }
          $testo = "PASSO 0-A: verdetto NON 'COMPLETO' su " + $sy + " " + $r.Timeframe + " -> " + $che +
                   " | barre " + $r.Barre + " | broker " + $r.PrimaDataServer + " | chiesto dal " + $DaQuando +
                   ".  Il gate sulla PRIMA OPERAZIONE e' la misura che decide."
          #  >>> SUL M1 QUESTO E' ATTESO, E VA NELLE NOTE, NON NEI PROBLEMI
          #      (checklist 47, il lato del rumore: una spia che non PUO' che
          #      essere rossa non la legge piu' nessuno).
          #      MISURATO nel gemello: scarica_storico.ps1 scrive nel preset
          #      InpTimeoutSec=120, cioe' DUE MINUTI per timeframe. Ventidue
          #      anni di barre M1 su XAUUSD non ci stanno, e non e' un guasto
          #      di questo round: e' un tetto dello strumento condiviso. Il
          #      tester poi si scarica da solo quello che gli manca mentre
          #      gira -- ed e' anche il motivo per cui la PRIMA passata dura
          #      molto piu' delle altre.
          if(("" + $r.Timeframe).Trim().ToUpper() -eq "M1"){
            [void]$Note.Add($testo + "  ATTESO: scarica_storico.ps1 da' 120 secondi per timeframe (InpTimeoutSec=120 nel preset) e 22 anni di M1 non ci stanno. NON e' un guasto del round: il tester completa da solo, e la misura che decide resta la prima operazione.")
          } else {
            [void]$Problemi.Add($testo)
          }
        }
      }
      if(-not $vistoSym){ [void]$Problemi.Add("PASSO 0-A: nessuna riga per " + $Sym + " nel referto storico.") }
    } else { [void]$Note.Add("PASSO 0-A: ABTG_StoricoScaricato.csv non trovato, referto storico NON letto.") }
  }catch{
    $Storico.Esito = "NON ESEGUITO (" + $_.Exception.Message + ")"
    [void]$Problemi.Add("PASSO 0-A NON ESEGUITO: " + $_.Exception.Message + ". Il gate sulla PRIMA OPERAZIONE resta l'unica misura sulla copertura.")
  }
  Dico ("PASSO 0-A: " + $Storico.Esito) "Gray"
} else {
  $Storico.Esito = "SALTATO (SoloControllo / SaltaPasso0 / SenzaStorico)"
}

# =====================================================================
#  4-B e 4-C. IL PASSO 0 SULLA FINESTRA INTERA.
#    B = UNA passata SINGOLA (log + report)  -> gate 1, criterio B
#    C = DUE passate GEMELLE (ottimizzazione) -> gate 2, gate 3, criterio A
# =====================================================================
$iniSing = Join-Path $Work "passo0_singola.ini"
$iniInt  = Join-Path $Work "passo0_intera.ini"
IniSingola $DaQuando $Fino $MagicSingola $iniSing "R99_singola"
IniOtt     $DaQuando $Fino $MagicOptA    $iniInt  "R99_intera"
Copy-Item -LiteralPath $iniSing -Destination (Join-Path $Sosta "passo0_singola.ini") -Force
Copy-Item -LiteralPath $iniInt  -Destination (Join-Path $Sosta "passo0_intera.ini")  -Force

if($SaltaPasso0){
  [void]$Problemi.Add("PASSO 0 SALTATO SU RICHIESTA: i TRE GATE dei criteri par. 5 (prima operazione entro il 2005.12.31, n totale, gemelli identici al centesimo) NON SONO STATI ESEGUITI IN QUESTA CORSA, e con loro il CRITERIO A (DD lungo) e il CRITERIO B (peggior giornata). Questa corsa non ha guardato. Vale solo per riprendere una coda GIA' gatata in un giro precedente, e il referto lo scrive in rosso.")
  Write-Host "    !! PASSO 0 SALTATO. Il referto lo scrive in rosso." -ForegroundColor Red
}
elseif($SoloControllo){
  Titolo "4. PASSO 0 - GIRO A VUOTO"
  Dico "SoloControllo: i due ini del PASSO 0 sono scritti e verificati, MT5 NON viene aperto." "Yellow"
  Write-Host ("    anteprima [TesterInputs] della passata SINGOLA (" + $ParametriAttesi + " parametri attesi):") -ForegroundColor DarkGray
  Get-Content -LiteralPath $iniSing | Select-Object -Last ($ParametriAttesi + 1) | ForEach-Object { Write-Host ("      " + $_) -ForegroundColor DarkGray }
  [void]$Note.Add("GIRO A VUOTO: il PASSO 0 non e' stato eseguito, quindi NON esiste NESSUNO dei tre numeri firmati (DD lungo, peggior giornata, DD per regime), NESSUN n e NESSUNA data di prima operazione. Il giro a vuoto verifica gli ARTEFATTI (file prova, cella, finestre, magic, ini), non i NUMERI: quelli li misura solo la corsa vera (criteri par. 5.2).")
}
else{
  # -------------------------------------------------------------------
  #  4-B. LA PASSATA SINGOLA
  # -------------------------------------------------------------------
  Titolo "4-B. PASSO 0 - passata SINGOLA su TUTTA la finestra (magic $MagicSingola)"
  Write-Host  "    ATTENZIONE alla durata: e' la PRIMA passata, e MT5 si scarica le barre M1" -ForegroundColor Yellow
  Write-Host  "    di 22 anni MENTRE gira. Puo' durare molto piu' delle successive." -ForegroundColor Yellow
  $tPasso0 = Get-Date
  $primaLen = FotografaLog
  $tp = Get-Date
  (Start-Process -FilePath $Terminal -ArgumentList ("/config:`"" + $iniSing + "`"") -PassThru).WaitForExit()
  $Passo0.Minuti = [math]::Round((New-TimeSpan -Start $tp -End (Get-Date)).TotalMinutes,1)
  Dico ("  ... passata singola: " + $Passo0.Minuti.ToString("0.0",$INV) + " minuti") "Gray"

  # --- (B1) IL LOG: la data della PRIMA OPERAZIONE, misura n.1
  $righeIN = New-Object System.Collections.ArrayList
  $letti = 0
  foreach($rad in $RadiciLog){
    if(-not (Test-Path -LiteralPath $rad)){ continue }
    foreach($lg in @(Get-ChildItem -LiteralPath $rad -Recurse -Filter "*.log" -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime)){
      $da = 0
      if($primaLen.ContainsKey($lg.FullName)){ $da = $primaLen[$lg.FullName] }
      $tx = LeggiNuovo $lg.FullName $da
      if($tx -eq ""){ continue }
      $letti++
      foreach($r in ($tx -split "`r?`n")){
        #  LA RIGA VERA la scrive ABTG_SupertrendReversal_Ottimizzato:
        #    Log(StringFormat("%s mercato %.2f lot @ %s SL %s TP %s", ...))
        #  e Log() antepone "[STReversal] ". Il pattern e' preso DAL
        #  SORGENTE che lo produce, non dalla memoria (checklist 55).
        if($r -match '\[STReversal\]\s+(LONG|SHORT)\s+mercato'){
          $q = DataSimulata $r "[STReversal]"
          [void]$righeIN.Add([pscustomobject]@{ Riga=$r.Trim(); Q=$q })
        }
      }
    }
  }
  $Passo0.LogLetti = $letti
  $Passo0.Ingressi = $righeIN.Count
  $conData = @($righeIN | Where-Object { $_.Q -ne $null })
  if($conData.Count -gt 0){
    $minQ = ($conData | Sort-Object Q | Select-Object -First 1).Q
    $Passo0.PrimaDataLog = $minQ.ToString("yyyy.MM.dd",$INV)
  }
  #  copia in sosta delle prime righe d'ingresso: e' la prova cartacea del
  #  gate, e va messa al sicuro APPENA prodotta (checklist 41), cosi'
  #  esiste anche quando il gate esce ROSSO.
  if($righeIN.Count -gt 0){
    $dump = New-Object System.Collections.ArrayList
    [void]$dump.Add("R99 PASSO 0 - righe d'ingresso lette nel log della passata singola (magic " + $MagicSingola + ")")
    [void]$dump.Add("log letti: " + $letti + "   righe trovate: " + $righeIN.Count)
    [void]$dump.Add("")
    foreach($x in @($righeIN | Select-Object -First 40)){ [void]$dump.Add($x.Riga) }
    Set-Content -LiteralPath (Join-Path $Sosta "passo0_ingressi_log.txt") -Value $dump -Encoding ASCII
  }

  # --- (B2) IL REPORT: i DEAL. Da qui escono la PEGGIOR GIORNATA
  #     (CRITERIO B) e la SECONDA misura indipendente della prima data.
  #     >>> QUESTA MISURA SI FA SEMPRE, fuori dal ramo della prima
  #         (checklist 56-bis): serve a DIAGNOSTICARE il fallimento
  #         dell'altra, non a sostituirla.
  $repFile = ""
  foreach($rad in @($InstDir,$DataFolder,$Work,$MqlFiles)){
    if(-not (Test-Path -LiteralPath $rad)){ continue }
    $c = @(Get-ChildItem -LiteralPath $rad -Filter "R99_singola*.htm*" -File -ErrorAction SilentlyContinue |
           Where-Object { $_.LastWriteTime -ge $tPasso0 } | Sort-Object LastWriteTime -Descending)
    if($c.Count -gt 0){ $repFile = $c[0].FullName; break }
  }
  if($repFile -ne ""){
    $Passo0.Report = $repFile
    Copy-Item -LiteralPath $repFile -Destination (Join-Path $Sosta "passo0_report_singola.htm") -Force -ErrorAction SilentlyContinue
    $deal = @(LeggiDeal $repFile)
    if($deal.Count -eq 0){
      [void]$Problemi.Add("CRITERIO B: il report della passata singola esiste (" + $repFile + ") ma NON ci ho riconosciuto nessuna riga di DEAL (data in prima colonna + colonna direzione in/out). La PEGGIOR GIORNATA resta NON MISURATA: nessun numero inventato. Il report e' nello zip: si guarda a mano.")
    } else {
      $Passo0.PrimaDataReport  = $deal[0].Q.ToString("yyyy.MM.dd",$INV)
      $Passo0.UltimaDataReport = $deal[$deal.Count-1].Q.ToString("yyyy.MM.dd",$INV)
      $Passo0.NReport = @($deal | Where-Object { $_.Dir -eq "out" -or $_.Dir -eq "in/out" }).Count
      #  --- LA PEGGIOR GIORNATA, per giorno di calendario.
      #  [APPROSSIMATO, e il referto lo dice]: e' la peggior giornata sulle
      #  CHIUSURE REALIZZATE, non sull'equity intraday. E' la stessa
      #  approssimazione con cui e' stata misurata la peggior giornata di
      #  portafoglio in R51.
      #  CONTROLLO POSITIVO sulla colonna del profitto (checklist 55): se
      #  NESSUN deal ha un profitto leggibile, la somma per giorno sarebbe
      #  zero ovunque e la peggior giornata uscirebbe "0,00%" -- cioe' un
      #  VERDE FALSO. Zero profitti letti e zero giornate perdenti devono
      #  essere DISTINGUIBILI.
      $conProfitto = @($deal | Where-Object { $_.Profit -ne $null }).Count
      if($conProfitto -eq 0){
        [void]$Problemi.Add("CRITERIO B: nel report ho riconosciuto " + $deal.Count + " deal ma NESSUNO ha un profitto leggibile nella colonna trovata. La PEGGIOR GIORNATA resta NON MISURATA: nessun numero inventato. Il report e' nello zip, si guarda a mano.")
      } else {
      $perGiorno = @{}
      $saldoFine = @{}
      $ordine = New-Object System.Collections.ArrayList
      foreach($d in $deal){
        $g = $d.Q.ToString("yyyy.MM.dd",$INV)
        if(-not $perGiorno.ContainsKey($g)){ $perGiorno[$g] = 0.0; [void]$ordine.Add($g) }
        if($d.Profit -ne $null){ $perGiorno[$g] = $perGiorno[$g] + [double]$d.Profit }
        if($d.Saldo  -ne $null){ $saldoFine[$g] = [double]$d.Saldo }
      }
      $Passo0.GiorniOperativi = $ordine.Count
      $saldoPrec = [double]$Deposito
      #  >>> NIENTE PAVIMENTO A ZERO. Partendo da $peggio = 0.0 una storia
      #      senza giornate perdenti stampa "0,00%" con la DATA VUOTA, che si
      #      legge come una misura ed e' invece un "non ho trovato niente".
      #      Si prende il MINIMO VERO, e se e' positivo si dice che il minimo
      #      e' positivo: e' un'informazione, non un buco.
      $peggio = $null; $peggioG = ""
      foreach($g in $ordine){
        $base = $saldoPrec
        if($base -le 0){ $base = [double]$Deposito }
        $pct = 100.0 * $perGiorno[$g] / $base
        if($peggio -eq $null -or $pct -lt $peggio){ $peggio = $pct; $peggioG = $g }
        if($saldoFine.ContainsKey($g)){ $saldoPrec = $saldoFine[$g] }
      }
      if($peggio -eq $null){
        [void]$Problemi.Add("CRITERIO B: nessuna giornata operativa ricavata dai deal del report. La PEGGIOR GIORNATA resta NON MISURATA.")
      } else {
        $Passo0.PeggiorGiornataPct  = [math]::Round($peggio,2)
        $Passo0.PeggiorGiornataData = $peggioG
        $coda = ""
        if($peggio -ge 0){ $coda = "   <<< NESSUNA giornata in perdita: questo e' il giorno MENO buono, non una perdita" }
        $Passo0.PeggiorGiornata = $Passo0.PeggiorGiornataPct.ToString("0.00",$INV) + "%  (il " + $peggioG + ", su " + $ordine.Count + " giornate operative, " + $conProfitto + " deal con profitto letto)" + $coda
      }
      }
    }
  } else {
    [void]$Problemi.Add("CRITERIO B: NON ho trovato nessun report 'R99_singola*.htm' scritto dopo l'avvio della passata (cercato in " + $InstDir + ", " + $DataFolder + ", " + $Work + ", " + $MqlFiles + "). La PEGGIOR GIORNATA resta NON MISURATA e NON si inventa. COME AVERLA: aprire MT5, Strategy Tester, ricaricare passo0_singola.ini (e' nello zip) in test singolo, tasto destro sul risultato -> Report, e leggere la tabella dei Deal. In alternativa si aggiunge un export per-trade all'EA, ma quella e' una modifica a una SEDIA VIVA e vuole una firma.")
  }

  # -------------------------------------------------------------------
  #  4-C. LE DUE PASSATE GEMELLE (ottimizzazione) SULLA FINESTRA INTERA
  # -------------------------------------------------------------------
  Titolo "4-C. PASSO 0 - due passate GEMELLE su TUTTA la finestra (magic $MagicOptA/$MagicOptB)"
  $csvInt = CsvDi "INTERA"
  #  >>> SI CANCELLA PRIMA, TUTTI E DUE (checklist 23 e 14). Se la passata
  #      non producesse niente, un file di IERI resterebbe li' e verrebbe
  #      letto come il risultato di ADESSO: sarebbe il referto stantio del
  #      17/08, con dentro il numero che decide tutto il round.
  Remove-Item -LiteralPath $OptCsv -Force -ErrorAction SilentlyContinue
  Remove-Item -LiteralPath $csvInt -Force -ErrorAction SilentlyContinue
  $tp = Get-Date
  (Start-Process -FilePath $Terminal -ArgumentList ("/config:`"" + $iniInt + "`"") -PassThru).WaitForExit()
  $Passo0.MinutiOpt = [math]::Round((New-TimeSpan -Start $tp -End (Get-Date)).TotalMinutes,1)
  Dico ("  ... due gemelle: " + $Passo0.MinutiOpt.ToString("0.0",$INV) + " minuti") "Gray"

  if(Test-Path -LiteralPath $OptCsv){
    if((Get-Item -LiteralPath $OptCsv).LastWriteTime -lt $tp){
      [void]$Problemi.Add("PASSO 0-C: l'OptResults e' PIU' VECCHIO dell'avvio delle gemelle: NON e' di questa corsa, non lo leggo.")
    } else {
      Copy-Item -LiteralPath $OptCsv -Destination $csvInt -Force
      Copy-Item -LiteralPath $OptCsv -Destination (Join-Path $Sosta "passo0_intera_optresults.csv") -Force
      Remove-Item -LiteralPath $OptCsv -Force -ErrorAction SilentlyContinue
    }
  }
  if(-not (Test-Path -LiteralPath $csvInt)){
    $Fatale = "PASSO 0-C: nessun OptResults prodotto sulla finestra intera. O lo storico M1 non copre " + $DaQuando + ", o MT5 non e' partito, o la cache ha ripescato passate vecchie senza riscrivere i frame. NON e' un via libera: senza questo file non esistono ne' il n, ne' il DD lungo (CRITERIO A), ne' il gate dei gemelli."
  } else {
    $rows = @(Import-Csv -LiteralPath $csvInt)
    if($rows.Count -ne $CelleAttese){
      $Fatale = "PASSO 0-C: l'OptResults ha " + $rows.Count + " righe invece di " + $CelleAttese + " (le due gemelle). O la cache del tester ha ripescato passate gia' calcolate senza riscrivere i frame, o l'asse InpMagic non ha spazzolato. Il gate 3 dei criteri (gemelli identici al centesimo) non ha niente da confrontare."
    } else {
      #  IL CONTROLLO POSITIVO SUL PARSER (checklist 55, e la stessa forma
      #  usata in R91): prima si verifica che le COLONNE esistano, con i
      #  loro nomi veri. Senza, una colonna rinominata darebbe $null in
      #  silenzio e il DD uscirebbe "non leggibile" senza dire perche'.
      $cols = @($rows | Get-Member -MemberType NoteProperty | ForEach-Object { $_.Name })
      $manca = @()
      foreach($c in @("Profit","Profit Factor","Equity DD %","Trades")){ if($cols -notcontains $c){ $manca += $c } }
      if($manca.Count -gt 0){
        $Fatale = "PASSO 0-C: nell'OptResults mancano le colonne [" + ($manca -join ", ") + "]. Le colonne le scrive l'OPTFRAME dell'EA (OnTesterDeinit): se sono cambiate, e' cambiato il motore. IL GATE NON E' STATO ESEGUITO. Colonne trovate: " + ($cols -join ", ")
      }
      $dd = @(); $pf = @(); $pr = @(); $tr = @(); $rc = @()
      foreach($r in $rows){
        $dd += (NumInv $r.'Equity DD %')
        $pf += (NumInv $r.'Profit Factor')
        $pr += (NumInv $r.'Profit')
        $tr += (NumInv $r.'Trades')
        $rc += (NumInv $r.'Recovery Factor')
      }
      if($Fatale -ne ""){
        #  le colonne non ci sono: il messaggio buono e' gia' quello di sopra,
        #  e NON va sovrascritto da quello generico (checklist 55: un gate
        #  riparato non deve perdere l'informazione che aveva).
      }
      elseif(($dd -contains $null) -or ($pr -contains $null) -or ($tr -contains $null)){
        $Fatale = "PASSO 0-C: le colonne ci sono ma i VALORI non sono numeri leggibili ('Equity DD %' / 'Profit' / 'Trades'). IL GATE NON E' STATO ESEGUITO: non e' un via libera. Il file e' nello zip."
      } else {
        $Passo0.DDLungo  = [math]::Round([double]$dd[0],2)
        $Passo0.PF       = [math]::Round([double]$pf[0],3)
        $Passo0.Profit   = [math]::Round([double]$pr[0],2)
        $Passo0.Recovery = [math]::Round([double]$rc[0],3)
        $Passo0.N        = [int]$tr[0]
        #  --- GATE 3: GEMELLI IDENTICI AL CENTESIMO (criteri par. 5, punto 3)
        $div = New-Object System.Collections.ArrayList
        if([math]::Round([double]$pr[0],2) -ne [math]::Round([double]$pr[1],2)){ [void]$div.Add("Profit") }
        if([math]::Round([double]$dd[0],2) -ne [math]::Round([double]$dd[1],2)){ [void]$div.Add("Equity DD %") }
        if([math]::Round([double]$pf[0],2) -ne [math]::Round([double]$pf[1],2)){ [void]$div.Add("Profit Factor") }
        if([int]$tr[0] -ne [int]$tr[1]){ [void]$div.Add("Trades") }
        if($div.Count -gt 0){
          $Passo0.Gemelli = "DIVERGONO su " + ($div -join ", ")
          $Fatale = "PASSO 0 / GATE 3: le due passate gemelle divergono su [" + ($div -join ", ") + "]. Banco sporco: la stessa cella ha risposto in modo diverso a se stessa, e nessun numero di questo round si legge."
        } else {
          $Passo0.Gemelli = "IDENTICI al centesimo"
        }
      }
    }
  }

  # -------------------------------------------------------------------
  #  4-D. I GATE DEL PASSO 0 (criteri par. 5 e 5.1)
  # -------------------------------------------------------------------
  #  GATE 1: la PRIMA OPERAZIONE. Due misure indipendenti, gia' fatte
  #  tutte e due qui sopra. Adesso si confrontano e si decide.
  $dLog = [datetime]::MinValue; $okLog = $false
  $dRep = [datetime]::MinValue; $okRep = $false
  if($Passo0.PrimaDataLog -ne "NON MISURATA"){
    $okLog = [datetime]::TryParseExact($Passo0.PrimaDataLog,"yyyy.MM.dd",$INV,[Globalization.DateTimeStyles]::None,[ref]$dLog)
  }
  if($Passo0.PrimaDataReport -ne "NON MISURATA"){
    $okRep = [datetime]::TryParseExact($Passo0.PrimaDataReport,"yyyy.MM.dd",$INV,[Globalization.DateTimeStyles]::None,[ref]$dRep)
  }
  if($okLog -and $okRep){
    $scarto = [math]::Abs(($dLog - $dRep).TotalDays)
    if($scarto -gt 1){
      [void]$Problemi.Add("GATE 1: le due misure indipendenti della prima operazione NON coincidono -- log " + $Passo0.PrimaDataLog + " contro report " + $Passo0.PrimaDataReport + " (" + [int]$scarto + " giorni). Uso la PIU' VECCHIA delle due (la piu' prudente sul tetto delle barre) e lo dichiaro, ma questo scarto va capito prima di firmare qualunque conclusione.")
    }
  }
  $dUsata = [datetime]::MinValue
  if($okLog -and $okRep){
    $dUsata = $dLog
    $Passo0.FonteData = "log e report CONCORDI"
    if($dRep -lt $dLog){ $dUsata = $dRep }
    if([math]::Abs(($dLog-$dRep).TotalDays) -gt 1){ $Passo0.FonteData = "log e report DIVERGENTI: uso la piu' vecchia" }
  }
  elseif($okLog){ $dUsata = $dLog; $Passo0.FonteData = "SOLO il log (il report non e' stato letto)" }
  elseif($okRep){ $dUsata = $dRep; $Passo0.FonteData = "SOLO il report (il log non e' stato letto)" }

  if($Fatale -eq ""){
    if(-not $okLog -and -not $okRep){
      $Fatale = "PASSO 0 / GATE 1: la data della PRIMA OPERAZIONE non e' leggibile NE' dal log NE' dal report. Il gate dei criteri par. 5 punto 1 NON HA GUARDATO NIENTE, e un gate che non legge non e' un gate verde. Cause da distinguere prima di rilanciare: (1) l'EA non ha operato affatto su 22 anni; (2) i log stanno in una radice che non guardo; (3) InpVerbose non e' arrivato acceso; (4) il report non e' stato scritto dove lo cerco. In tutti e quattro i casi NON e' un via libera."
    } else {
      $Passo0.PrimaDataUsata = $dUsata.ToString("yyyy.MM.dd",$INV)
      $lim  = [datetime]::ParseExact($LimiteG2,"yyyy.MM.dd",$INV)
      $limF = [datetime]::ParseExact($LimiteFatale,"yyyy.MM.dd",$INV)
      if($dUsata -le $lim){
        $Passo0.Finestra = "PIENA: prima operazione " + $Passo0.PrimaDataUsata + ", entro il limite " + $LimiteG2
      }
      elseif($dUsata -lt $limF){
        $Passo0.Finestra = "ACCORCIATA: prima operazione " + $Passo0.PrimaDataUsata + ", OLTRE il limite " + $LimiteG2
        [void]$Problemi.Add("FINESTRA ACCORCIATA (criteri par. 5): la prima operazione e' del " + $Passo0.PrimaDataUsata + ", oltre il " + $LimiteG2 + ". Il tetto delle 100.000 barre HA MORSO, oppure lo storico M1 non arriva davvero al " + $DaQuando + ". La corsa PROSEGUE -- il criterio dice 'si dichiara accorciata', non 'ci si ferma' -- ma questa riga va scritta ACCANTO A OGNI NUMERO: il DD lungo NON copre 22 anni, ne copre meno.")
      }
      else{
        $Fatale = "PASSO 0 / GATE 1: la prima operazione e' del " + $Passo0.PrimaDataUsata + ", dopo il " + $LimiteFatale + ". La finestra non contiene piu' ne' il crollo dell'ottobre 2008 ne' quello dell'aprile 2013, cioe' i due eventi che l'IPOTESI del round vuole misurare: la domanda di R99 non ha piu' senso su questi dati e i tre numeri descriverebbero un'altra finestra. (Soglia dichiarata nei criteri par. 5.1 come TRADUZIONE, non come firma.)"
      }
    }
  }
  #  --- controllo incrociato sul n (gate 2 + checklist 56-bis)
  if($Passo0.N -ge 0 -and $Passo0.NReport -ge 0){
    if($Passo0.N -ne $Passo0.NReport){
      [void]$Problemi.Add("GATE 2: il n dell'ottimizzazione (" + $Passo0.N + ", colonna Trades) e il n del report della passata singola (" + $Passo0.NReport + ", deal 'out') NON coincidono. Sono la STESSA cella su magic diversi: dovrebbero. Va capito prima di leggere la peggior giornata, che e' calcolata sui deal del report.")
    }
  }
  if($Passo0.N -eq 0){
    [void]$Problemi.Add("GATE 2: n = 0 operazioni su 22 anni. Non c'e' niente da misurare: o lo storico non c'e', o la cella non opera. Non e' un DD basso, e' un DD ASSENTE.")
  }

  Write-Host ""
  Write-Host "    --- ESITO DEL PASSO 0 ---" -ForegroundColor White
  Write-Host ("    prima operazione (log) ..... " + $Passo0.PrimaDataLog) -ForegroundColor White
  Write-Host ("    prima operazione (report) .. " + $Passo0.PrimaDataReport) -ForegroundColor White
  Write-Host ("    -> usata ................... " + $Passo0.PrimaDataUsata + "   (" + $Passo0.FonteData + ")   limite: " + $LimiteG2) -ForegroundColor Yellow
  Write-Host ("    FINESTRA ................... " + $Passo0.Finestra) -ForegroundColor Yellow
  Write-Host ("    n operazioni ............... " + $Passo0.N + "   (report: " + $Passo0.NReport + ")") -ForegroundColor White
  Write-Host ("    gemelli .................... " + $Passo0.Gemelli) -ForegroundColor White
  Write-Host ("    A. DD LUNGO 2004-2026 ...... " + (Fmt2 $Passo0.DDLungo) + "%   al rischio 1,00%") -ForegroundColor Yellow
  Write-Host ("    B. PEGGIOR GIORNATA ........ " + $Passo0.PeggiorGiornata) -ForegroundColor Yellow
  Write-Host ("    (profitto " + $Passo0.Profit.ToString("0.00",$INV) + " EUR su " + $Deposito + ", PF " + $Passo0.PF.ToString("0.000",$INV) + " -- NON entrano in nessun verdetto: regola B)") -ForegroundColor DarkGray
  Write-Host ("    durata: singola " + $Passo0.Minuti.ToString("0.0",$INV) + " min + gemelle " + $Passo0.MinutiOpt.ToString("0.0",$INV) + " min") -ForegroundColor Yellow
  Write-Host ("    proiezione delle " + (2*$Lavori.Count) + " passate di finestra: molto MENO della intera") -ForegroundColor Yellow
  Write-Host  "      (le finestre di regime durano 3-12 mesi l'una, non 22 anni)" -ForegroundColor Yellow
  $Passo0.Fatto = $true

  if($Fatale -ne ""){ throw $Fatale }
  Dico "PASSO 0 SUPERATO: si parte con le finestre." "Green"
}

# =====================================================================
#  5. LA CATENA DELLE FINESTRE. Una alla volta. Mai in parallelo.
# =====================================================================
Titolo ("5. LA CATENA - " + $Lavori.Count + " finestre (" + $nCrit + " criterio C + " + $nDiag + " diagnostiche)")
$idx = 0
foreach($l in $Lavori){
  $idx++
  $trascorse = (New-TimeSpan -Start $Avvio -End (Get-Date)).TotalHours
  if($trascorse -ge $OreMax){
    $l.Esito = "NON INIZIATA (tetto ore raggiunto)"
    [void]$Problemi.Add("TEMPO SCADUTO prima di " + $l.Nome + ": il round NON e' completo.")
    continue
  }
  Write-Host ""
  Write-Host "------------------------------------------------------------------" -ForegroundColor Cyan
  Write-Host ("  [" + $idx + "/" + $Lavori.Count + "]  " + $l.Nome + "   " + $l.Da + " -> " + $l.A) -ForegroundColor Cyan
  Write-Host ("           " + $l.Desc) -ForegroundColor Cyan
  Write-Host "------------------------------------------------------------------" -ForegroundColor Cyan
  $dest = CsvDi $l.Nome
  $ini  = Join-Path $Work ("R99_" + $l.Nome + ".ini")
  IniOtt $l.Da $l.A $l.Magic $ini ("R99_" + $l.Nome)
  Copy-Item -LiteralPath $ini -Destination (Join-Path $Sosta ("R99_" + $l.Nome + ".ini")) -Force

  if($SoloControllo){
    $l.Esito = "SOLO CONTROLLO"
    Write-Host ("    ini scritto e verificato: " + $ini) -ForegroundColor DarkGray
    continue
  }
  if((Test-Path -LiteralPath $dest) -and -not $Rifai){
    #  >>> UN CSV VECCHIO NON E' UN CSV OK: SI GUARDA LA DATA. <<<
    #  La ripresa e' utile (una corsa da ore si puo' interrompere), ma un
    #  file di un lancio precedente non e' un risultato di questo lancio, e
    #  se fra i due lanci fosse cambiato il pin META' ROUND VERREBBE DA UN
    #  ALTRO MOTORE (checklist 15 e 53).
    $l.Esito = "SALTATA (CSV gia' presente del " + (Get-Item -LiteralPath $dest).LastWriteTime.ToString("yyyy-MM-dd HH:mm",$INV) + ")"
    [void]$Problemi.Add($l.Nome + ": " + $l.Esito + ". Le righe tornano ma il file NON e' di questo lancio: rilancia con -Rifai.")
    $r0 = @(Import-Csv -LiteralPath $dest)
    $l.Righe = $r0.Count
    Write-Host ("    " + $l.Esito) -ForegroundColor Yellow
    continue
  }
  $tl = Get-Date
  #  >>> SI CANCELLA PRIMA, TUTTI E DUE (checklist 23). Col solo -Force sulla
  #      copia, una passata che non produce niente lascerebbe in piedi il CSV
  #      del giro precedente, e il DD di questa finestra verrebbe letto li'.
  Remove-Item -LiteralPath $OptCsv -Force -ErrorAction SilentlyContinue
  Remove-Item -LiteralPath $dest   -Force -ErrorAction SilentlyContinue
  (Start-Process -FilePath $Terminal -ArgumentList ("/config:`"" + $ini + "`"") -PassThru).WaitForExit()
  $l.Min = [math]::Round((New-TimeSpan -Start $tl -End (Get-Date)).TotalMinutes,1)
  if(Test-Path -LiteralPath $OptCsv){
    if((Get-Item -LiteralPath $OptCsv).LastWriteTime -lt $tl){
      [void]$Problemi.Add($l.Nome + ": l'OptResults e' piu' vecchio dell'avvio della passata: NON e' di questa finestra, non lo leggo.")
    } else {
      Copy-Item -LiteralPath $OptCsv -Destination $dest -Force
      Remove-Item -LiteralPath $OptCsv -Force -ErrorAction SilentlyContinue
    }
  }
  if(-not (Test-Path -LiteralPath $dest)){
    $l.Esito = "NESSUN CSV"
    [void]$Problemi.Add($l.Nome + ": nessun OptResults prodotto. Storico mancante su quella finestra, oppure MT5 non e' partito.")
  } else {
    $rows = @(Import-Csv -LiteralPath $dest)
    $l.Righe = $rows.Count
    if($rows.Count -ne $CelleAttese){
      $l.Esito = "RIGHE SBAGLIATE (" + $rows.Count + " invece di " + $CelleAttese + ")"
      [void]$Problemi.Add($l.Nome + ": " + $l.Esito + ". E' la CACHE del tester (passate ripescate senza riscrivere i frame) oppure l'asse InpMagic che non ha spazzolato: la finestra NON si legge.")
    } else {
      $ddw = @(); $prw = @(); $trw = @(); $pfw = @()
      foreach($r in $rows){
        $ddw += (NumInv $r.'Equity DD %'); $prw += (NumInv $r.'Profit')
        $trw += (NumInv $r.'Trades');      $pfw += (NumInv $r.'Profit Factor')
      }
      if(($ddw -contains $null) -or ($trw -contains $null)){
        $l.Esito = "COLONNE NON LETTE"
        [void]$Problemi.Add($l.Nome + ": non riesco a leggere 'Equity DD %' / 'Trades'. Il DD di questa finestra NON e' misurato.")
      } else {
        $l.DD = [math]::Round([double]$ddw[0],2)
        $l.N  = [int]$trw[0]
        if($prw[0] -ne $null){ $l.Profit = [math]::Round([double]$prw[0],2) }
        if($pfw[0] -ne $null){ $l.PF = [math]::Round([double]$pfw[0],3) }
        $dv = New-Object System.Collections.ArrayList
        if([math]::Round([double]$ddw[0],2) -ne [math]::Round([double]$ddw[1],2)){ [void]$dv.Add("Equity DD %") }
        if([int]$trw[0] -ne [int]$trw[1]){ [void]$dv.Add("Trades") }
        if($prw[0] -ne $null -and $prw[1] -ne $null -and [math]::Round([double]$prw[0],2) -ne [math]::Round([double]$prw[1],2)){ [void]$dv.Add("Profit") }
        if($dv.Count -gt 0){
          $l.Gemelli = "DIVERGONO (" + ($dv -join ", ") + ")"
          [void]$Problemi.Add($l.Nome + ": le due gemelle divergono su [" + ($dv -join ", ") + "]. Banco sporco su questa finestra: il suo DD non si legge.")
          $l.Esito = "GEMELLI DIVERGENTI"
        } else {
          $l.Gemelli = "IDENTICI"
          $l.Esito = "OK"
        }
      }
    }
  }
  Write-Host ("    esito: " + $l.Esito + "   DD " + (Fmt2 $l.DD) + "%   n " + $l.N + "   [" + $l.Min.ToString("0.0",$INV) + " min]") -ForegroundColor Gray
}

if($SoloControllo){
  $nIni = @(Get-ChildItem -LiteralPath $Sosta -Filter "*.ini" -ErrorAction SilentlyContinue).Count
  $iniAttesi = $Lavori.Count + 2
  if($nIni -ne $iniAttesi){ [void]$Problemi.Add("giro a vuoto: " + $nIni + " ini in sosta invece di " + $iniAttesi + " (" + $Lavori.Count + " finestre + intera gemella + intera singola).") }
  Write-Host ""
  Write-Host ("    ini in sosta: " + $nIni + " su " + $iniAttesi + "   -> " + $Sosta) -ForegroundColor White
  Write-Host  "    >>> COSA SI LEGGE NEGLI INI, e cosa no:" -ForegroundColor Yellow
  Write-Host  "        SI LEGGE: FromDate/ToDate di ogni finestra, Model=1 (OHLC M1)," -ForegroundColor Yellow
  Write-Host  "          Optimization (1 per le gemelle, 0 per la singola), il blocco" -ForegroundColor Yellow
  Write-Host  "          [TesterInputs] con i 42 parametri della cella e il magic." -ForegroundColor Yellow
  Write-Host  "        NON SI LEGGE NESSUNO DEI TRE NUMERI: niente DD, niente peggior" -ForegroundColor Yellow
  Write-Host  "          giornata, niente n, niente data di prima operazione. Il giro a" -ForegroundColor Yellow
  Write-Host  "          vuoto non apre MT5: quei numeri li misura solo la corsa vera." -ForegroundColor Yellow
}

}catch{
  $Fatale = $_.Exception.Message
  Write-Host ""
  Write-Host ("!!! FERMATO: " + $Fatale) -ForegroundColor Red
}

# =====================================================================
#  6. RACCOLTA. Si fa SEMPRE, anche a esito parziale o fermato.
# =====================================================================
Titolo "6. RACCOLTA SUL DESKTOP"
#  >>> OGNI ARTEFATTO DICE IN QUALE MODO E' STATO PRODOTTO (checklist 50). <<<
$Modo = "CORSA"
if($SoloControllo){ $Modo = "CONTROLLO" } elseif($SaltaPasso0){ $Modo = "SENZAPASSO0" }
$Cart = Join-Path $Dsk ("R99_ORO_22ANNI_" + $Modo + "_" + $Stamp)
$Zip  = Join-Path $Dsk ("R99_ORO_22ANNI_" + $Modo + "_" + $Stamp + ".zip")
$Referto = Join-Path $Cart "REFERTO_R99.txt"
try{
  New-Item -ItemType Directory -Force -Path $Cart | Out-Null
  foreach($f in @(Get-ChildItem -LiteralPath $Risultati -Filter "R99_*.csv" -File -ErrorAction SilentlyContinue)){
    Copy-Item -LiteralPath $f.FullName -Destination (Join-Path $Cart $f.Name) -Force
  }
  if($Sosta -and (Test-Path -LiteralPath $Sosta)){
    foreach($f in @(Get-ChildItem -LiteralPath $Sosta -File -ErrorAction SilentlyContinue)){
      Copy-Item -LiteralPath $f.FullName -Destination (Join-Path $Cart $f.Name) -Force
    }
  }

  $R = New-Object System.Collections.ArrayList
  [void]$R.Add("REFERTO R99 - ORO SU 22 ANNI: LA MISURA DEL RISCHIO (XAUUSD H4, OHLC M1)")
  $coda = ""
  if($SoloControllo){ $coda = "   <<< GIRO A VUOTO: NESSUNA passata, NESSUN numero di round qui dentro" }
  [void]$R.Add("modo: " + $Modo + $coda)
  $sw = @()
  if($SoloControllo){ $sw += "-SoloControllo (nessuna passata)" }
  if($SaltaPasso0)  { $sw += "-SaltaPasso0 (I TRE GATE NON ESEGUITI: i criteri par. 5 chiedono il contrario)" }
  if($SenzaStorico) { $sw += "-SenzaStorico (barre NON scaricate: il tester si arrangia, e puo' volerci molto di piu')" }
  if($Rifai)        { $sw += "-Rifai (le finestre gia' presenti sono state rifatte)" }
  if($sw.Count -eq 0){ $sw += "nessuno (corsa piena, PASSO 0 eseguito, ripresa delle finestre gia' presenti ATTIVA)" }
  [void]$R.Add("switch di questo giro: " + ($sw -join " | "))
  [void]$R.Add("data: " + (Get-Date).ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   (questa data deve essere di ADESSO)")
  [void]$R.Add("     ATTENZIONE: la data fresca NON distingue un giro a vuoto da una corsa.")
  [void]$R.Add("     Quello che lo distingue e' la riga 'modo:' qui sopra e il NOME della cartella.")
  [void]$R.Add("avvio: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss",$INV) + "   durata: " + ((New-TimeSpan -Start $Avvio -End (Get-Date)).TotalHours).ToString("0.0",$INV) + " ore")
  [void]$R.Add("pin: " + $Pin)
  [void]$R.Add("criteri: risultati_archivio\R99_CRITERI.md   (FIRMATI il 23/08/2026: 'FIRMO R99, PARTIAMO CON L'ORO')")
  [void]$R.Add("EA: " + $Ea + "   version letta dal sorgente: " + $VersioneLetta + " (attesa " + $VersioneAttesa + ")")
  [void]$R.Add("cella: quella VIVA congelata - 42 input, rischio 1,00% (CRITERIO A), magic VERGINI 7799xx")
  [void]$R.Add("finestra: " + $DaQuando + " -> " + $Fino + "   modello " + $Modello + " = OHLC su M1")
  [void]$R.Add("     I TICK REALI SU 22 ANNI NON ESISTONO (partono dal 2024.07.05): il numero")
  [void]$R.Add("     che segue e' un LIMITE INFERIORE del rischio, MAI UN PERMESSO (criteri par. 4).")
  [void]$R.Add("")
  [void]$R.Add("=====================================================================")
  [void]$R.Add(" I TRE NUMERI FIRMATI (criteri par. 3)")
  [void]$R.Add("=====================================================================")
  [void]$R.Add("")
  [void]$R.Add("  A. DD MASSIMO DELL'EQUITY 2004.06.11 -> 2026.06.30 al rischio 1%")
  if($Passo0.DDLungo -ge 0){ [void]$R.Add("     ->  " + (Fmt2 $Passo0.DDLungo) + " %       (n = " + $Passo0.N + " operazioni)") }
  else                     { [void]$R.Add("     ->  NON MISURATO") }
  [void]$R.Add("")
  [void]$R.Add("  B. PEGGIOR GIORNATA IN %   (il muro prop giornaliero e' 5%)")
  [void]$R.Add("     ->  " + $Passo0.PeggiorGiornata)
  [void]$R.Add("     [APPROSSIMATO]: e' la peggior giornata sulle CHIUSURE REALIZZATE, non")
  [void]$R.Add("     sull'equity intraday, e la percentuale e' sul saldo a inizio giornata.")
  [void]$R.Add("     E' la stessa approssimazione della peggior giornata di portafoglio di R51.")
  [void]$R.Add("")
  [void]$R.Add("  C. DD MASSIMO DENTRO CIASCUNA DELLE QUATTRO FINESTRE DI REGIME")
  [void]$R.Add("     (date agli atti: prova_regime.ps1 righe 69-75, le stesse di R50/R56/R59)")
  [void]$R.Add(("     {0,-10} {1,-24} {2,8}  {3,6}  {4,12}  {5}" -f "FINESTRA","PERIODO","DD %","n","PROFIT","GEMELLI"))
  foreach($l in $Lavori){
    if(-not $l.Criterio){ continue }
    [void]$R.Add(("     {0,-10} {1,-24} {2,8}  {3,6}  {4,12}  {5}" -f $l.Nome,($l.Da + " - " + $l.A),(Fmt2 $l.DD),$l.N,$l.Profit.ToString("0.00",$INV),$l.Gemelli))
  }
  [void]$R.Add("")
  [void]$R.Add("  + LE DUE DIAGNOSTICHE DELL'ORO -- NON SONO CRITERI (par. 8.1)")
  [void]$R.Add("     Le quattro finestre di casa NON contengono i due eventi che l'IPOTESI")
  [void]$R.Add("     nomina (ottobre 2008 e aprile 2013): il criterio A li copre, ma annegati")
  [void]$R.Add("     in vent'anni. Queste due passate li isolano. Servono a DICHIARARE, non a")
  [void]$R.Add("     decidere: non entrano in nessun confronto e in nessun verdetto.")
  foreach($l in $Lavori){
    if($l.Criterio){ continue }
    [void]$R.Add(("     {0,-10} {1,-24} {2,8}  {3,6}  {4,12}  {5}" -f $l.Nome,($l.Da + " - " + $l.A),(Fmt2 $l.DD),$l.N,$l.Profit.ToString("0.00",$INV),$l.Gemelli))
  }
  [void]$R.Add("")
  [void]$R.Add("=====================================================================")
  [void]$R.Add(" LA DECISIONE MECCANICA (criteri par. 3): DD lungo > 2x DD promesso ?")
  [void]$R.Add("=====================================================================")
  [void]$R.Add("")
  [void]$R.Add("  IL DD PROMESSO, letto ADESSO dall'artefatto e non a memoria.")
  [void]$R.Add("  FONTE: " + $Contratto.Fonte + " al pin " + $Pin)
  [void]$R.Add("  stato: " + $Contratto.Stato)
  [void]$R.Add("  riga del contratto, VERBATIM:")
  [void]$R.Add("    " + $Contratto.Riga)
  [void]$R.Add("")
  if($Contratto.DD -gt 0 -and $Passo0.DDLungo -ge 0){
    $soglia = 2.0 * $Contratto.DD
    [void]$R.Add("  DD promesso ............ " + $Contratto.DD.ToString("0.00",$INV) + " %")
    [void]$R.Add("  soglia 2x .............. " + $soglia.ToString("0.00",$INV) + " %")
    [void]$R.Add("  DD lungo misurato ...... " + (Fmt2 $Passo0.DDLungo) + " %")
    if($Passo0.DDLungo -gt $soglia){
      [void]$R.Add("  >>> ESITO MECCANICO: **SUPERATO** -> LA SEDIA VA IN REVISIONE.")
      [void]$R.Add("      Corsia RISCHIO del criterio di uscita firmato il 18/08, senza altre")
      [void]$R.Add("      discussioni. E' un fatto accaduto, non una stima.")
    } else {
      [void]$R.Add("  >>> ESITO MECCANICO: NON superato -> il contratto RESTA, e ora ha")
      [void]$R.Add("      vent'anni sotto. (Ricordando che il modello e' OHLC: e' un LIMITE")
      [void]$R.Add("      INFERIORE del rischio, non un permesso.)")
    }
  } else {
    [void]$R.Add("  >>> 2x NON CALCOLABILE: CONTRATTO SENZA NUMERO.")
    [void]$R.Add("      Il contratto di questa sedia e' PARZIALE (etichetta gialla in")
    [void]$R.Add("      CONTRATTI_SEDIE.md) e il DD promesso NON e'")
    [void]$R.Add("      un numero (a referto solo 'basso', mai quantificato). Il criterio")
    [void]$R.Add("      firmato NON e' stato toccato: si dichiara che il DENOMINATORE non")
    [void]$R.Add("      esiste (criteri par. 3.1).")
    [void]$R.Add("      >>> E QUESTO NON E' UN VIA LIBERA: e' esso stesso un rilievo della")
    [void]$R.Add("      corsia RISCHIO. Una sedia viva sull'oro senza DD promesso non ha")
    [void]$R.Add("      NESSUN metro, e la C3 del 18/08 su di lei non puo' scattare.")
    [void]$R.Add("      >>> COSA PUO' USCIRNE: i tre numeri qui sopra sono CANDIDATI a")
    [void]$R.Add("      riempire quel contratto. Riempirlo e' UNA FIRMA NUOVA di Claudio,")
    [void]$R.Add("      non un esito automatico di questo round.")
  }
  [void]$R.Add("")
  [void]$R.Add("  NOTA SULLA TAGLIA: i numeri sono al rischio 1,00%, che e' anche il rischio")
  [void]$R.Add("  MISURATO sulla sedia viva (censimento .chr del 18/08 00:01). Fino al 17/08")
  [void]$R.Add("  la stessa sedia girava al 2,0% (REFERTO_CENSIMENTO_RISCHIO.md): a quella")
  [void]$R.Add("  taglia tutti i numeri vanno RADDOPPIATI [APPROSSIMATO: scalatura lineare,")
  [void]$R.Add("  convenzione di CONTRATTI_SEDIE.md par. COME LEGGERE I NUMERI punto 2].")
  [void]$R.Add("")
  [void]$R.Add("=====================================================================")
  [void]$R.Add(" IL PASSO 0 (criteri par. 5) - i tre gate")
  [void]$R.Add("=====================================================================")
  [void]$R.Add("  0-A barre M1+H4 ......... " + $Storico.Esito + "   (chieste dal " + $DaQuando + ")")
  [void]$R.Add("      NIENTE TICK: il round e' OHLC M1 per criterio, e i tick su 22 anni")
  [void]$R.Add("      non esistono. Le barre M1 servono davvero: il tester costruisce le H4")
  [void]$R.Add("      dalle M1, quindi la profondita' che MORDE e' quella dell'M1.")
  [void]$R.Add("  eseguito ................ " + $Passo0.Fatto)
  [void]$R.Add("  GATE 1 prima operazione . " + $Passo0.PrimaDataUsata + "   (limite dei criteri: " + $LimiteG2 + ")")
  [void]$R.Add("      misura 1, log del tester ... " + $Passo0.PrimaDataLog + "   (righe d'ingresso lette: " + $Passo0.Ingressi + ", log letti: " + $Passo0.LogLetti + ")")
  [void]$R.Add("      misura 2, report .htm ...... " + $Passo0.PrimaDataReport + "   (ultima: " + $Passo0.UltimaDataReport + ")")
  [void]$R.Add("      fonte usata ................ " + $Passo0.FonteData)
  [void]$R.Add("      >>> FINESTRA: " + $Passo0.Finestra)
  [void]$R.Add("      Le due misure si eseguono SEMPRE tutte e due, fuori dai rami l'una")
  [void]$R.Add("      dell'altra: servono a diagnosticare il fallimento, non a sostituirlo.")
  [void]$R.Add("  GATE 2 n totale ......... " + $Passo0.N + "   (controllo incrociato dal report: " + $Passo0.NReport + ")")
  [void]$R.Add("      'si scrive, non si commenta' -- criteri par. 5, punto 2.")
  [void]$R.Add("  GATE 3 gemelli .......... " + $Passo0.Gemelli)
  [void]$R.Add("      due passate della STESSA cella su magic diversi: Profit, PF, DD e")
  [void]$R.Add("      Trades devono coincidere arrotondati al centesimo.")
  [void]$R.Add("  report .htm usato ....... " + $Passo0.Report)
  [void]$R.Add("     NOTA: 'NON MISURATO' NON e' 'va bene'. Un gate che non legge niente non")
  [void]$R.Add("     e' un gate verde, ed e' un esito FATALE.")
  [void]$R.Add("")
  [void]$R.Add("--- LE FINESTRE, UNA PER UNA ---   (attese: " + $CelleAttese + " righe per CSV)")
  [void]$R.Add(("{0,-10} {1,-24} {2,-6} {3,8} {4,6} {5,7} {6}" -f "FINESTRA","PERIODO","RIGHE","DD %","n","MIN","ESITO"))
  foreach($l in $Lavori){
    [void]$R.Add(("{0,-10} {1,-24} {2,-6} {3,8} {4,6} {5,7} {6}" -f $l.Nome,($l.Da + " - " + $l.A),$l.Righe,(Fmt2 $l.DD),$l.N,$l.Min.ToString("0.0",$INV),$l.Esito))
  }
  [void]$R.Add("")
  [void]$R.Add("--- COME SI LEGGE (e in che ordine) ---")
  [void]$R.Add("  1. IL PASSO 0 PER PRIMO. Se la FINESTRA e' 'ACCORCIATA', quella riga va")
  [void]$R.Add("     scritta ACCANTO A OGNI NUMERO: il DD lungo non copre 22 anni.")
  [void]$R.Add("     Se i GEMELLI divergono, non si legge niente: banco sporco.")
  [void]$R.Add("  2. IL DD LUNGO (A) contro il DD PROMESSO. E' l'unica decisione del round,")
  [void]$R.Add("     ed e' MECCANICA: nessuna discussione, solo il confronto col 2x.")
  [void]$R.Add("  3. LA PEGGIOR GIORNATA (B) contro il muro prop giornaliero del 5%.")
  [void]$R.Add("  4. I QUATTRO DD DI REGIME (C). Qui si guarda se una finestra sola fa il DD")
  [void]$R.Add("     di tutta la storia: sarebbe il segno che il rischio e' concentrato in un")
  [void]$R.Add("     regime, e la flotta ha 12 grafici sull'oro.")
  [void]$R.Add("  5. LE DUE DIAGNOSTICHE 2008/2013: si DICHIARANO. Non decidono niente.")
  [void]$R.Add("  6. IL PROFITTO E IL PF DI TUTTE LE FINESTRE NON SI USANO. Emendamento")
  [void]$R.Add("     regola B: il VECCHIO giudica il RISCHIO, il RECENTE giudica il MERITO.")
  [void]$R.Add("     Sono nel CSV perche' il CSV e' quello che l'EA scrive, non perche'")
  [void]$R.Add("     entrino in un verdetto.")
  [void]$R.Add("  7. QUESTO ROUND NON PROMUOVE E NON BOCCIA NIENTE. Al massimo manda una")
  [void]$R.Add("     sedia in REVISIONE sulla corsia RISCHIO, o propone di riempire un")
  [void]$R.Add("     contratto parziale -- e quella proposta va FIRMATA a parte.")
  [void]$R.Add("  8. E VALE PER UNA SEDIA SOLA. Sull'oro la flotta ne ha molte altre")
  [void]$R.Add("     (FLOTTA_ATTIVA.md: 'Concentrazione ORO altissima'): rifare la stessa")
  [void]$R.Add("     misura sulle altre e' un round nuovo, non un corollario di questo.")
  [void]$R.Add("")
  [void]$R.Add("--- CHE COSA E' [DA CONFERMARE] DELLA CELLA ---")
  [void]$R.Add("  Del grafico vivo il censimento .chr del 18/08 misura SOLO tre cose: magic")
  [void]$R.Add("  970901, rischio 1, commento 'STREV OTT'. Tutte e tre coincidono con questa")
  [void]$R.Add("  cella. Gli ALTRI 39 input sono i DEFAULT DEL SORGENTE al pin: se sul VPS")
  [void]$R.Add("  qualcuno ne ha toccato uno a mano, questo round misura IL SORGENTE e non")
  [void]$R.Add("  LA SEDIA. La conferma vera e' leggere il .chr del grafico XAUUSDH41.")
  [void]$R.Add("  E i LATI (InpAllowLong/InpAllowShort) sono gia' dichiarati [INCERTO] per")
  [void]$R.Add("  questa sedia in prove/R52_CENSIMENTO_LATI.md.")
  [void]$R.Add("")
  [void]$R.Add("--- NOTE ---")
  if($Note.Count -eq 0){ [void]$R.Add("  (nessuna)") }
  foreach($n in $Note){ [void]$R.Add("  - " + $n) }
  [void]$R.Add("")
  [void]$R.Add("--- PROBLEMI ---")
  if($Problemi.Count -eq 0){ [void]$R.Add("  (nessuno)") }
  foreach($p in $Problemi){ [void]$R.Add("  - " + $p) }
  [void]$R.Add("")
  if($Fatale -ne ""){ [void]$R.Add("ESITO: FERMATO -- " + $Fatale) }
  elseif($SoloControllo){
    if($Problemi.Count -gt 0){
      [void]$R.Add("ESITO: GIRO A VUOTO CON PROBLEMI -- " + $Problemi.Count + " problemi nell'elenco qui sopra.")
      [void]$R.Add("       NESSUNA passata, NESSUN numero. IL CONTROLLO NON E' PASSATO: la")
      [void]$R.Add("       corsa vera NON si lancia finche' l'elenco dei PROBLEMI non e' vuoto.")
    } else {
      [void]$R.Add("ESITO: GIRO A VUOTO COMPLETATO -- NESSUNA passata, NESSUN numero di round")
      [void]$R.Add("       in questo file: ne' DD, ne' peggior giornata, ne' n, ne' prima data.")
      [void]$R.Add("       QUESTO ZIP NON E' IL ROUND: non va mandato come risultato.")
    }
  }
  else{
    $ko = @($Lavori | Where-Object { $_.Esito -ne "OK" })
    if($ko.Count -gt 0 -or $Problemi.Count -gt 0){
      [void]$R.Add("ESITO: PARZIALE -- " + $ko.Count + " finestre su " + $Lavori.Count + " non sono OK, e " + $Problemi.Count + " problemi in elenco. NON e' un round completo.")
    }
    else{ [void]$R.Add("ESITO: OK -- tutte le finestre hanno prodotto le righe attese, nessun problema in elenco.") }
  }
  Set-Content -LiteralPath $Referto -Value $R -Encoding ASCII

  Remove-Item -LiteralPath $Zip -Force -ErrorAction SilentlyContinue
  Compress-Archive -Path (Join-Path $Cart "*") -DestinationPath $Zip -Force
  Dico ("zip pronto: " + $Zip) "Green"
}catch{
  Write-Host ("!! raccolta incompleta: " + $_.Exception.Message) -ForegroundColor Red
}

# =====================================================================
#  7. COSA DEVE VEDERE CLAUDIO SULLO SCHERMO
# =====================================================================
Write-Host ""
Write-Host "=====================================================================" -ForegroundColor White
Write-Host "  FINITO. File da verificare, uno per uno:" -ForegroundColor White
#  >>> NON SI ANNUNCIA UN ARTEFATTO CHE NON ESISTE (checklist 22). <<<
function Riga3($path,$coda){
  if(Test-Path -LiteralPath $path){ Write-Host ("   " + $path + "   " + $coda) -ForegroundColor White }
  else                            { Write-Host ("   " + $path + "   <<< NON ESISTE") -ForegroundColor Red }
}
Riga3 $Cart    ""
Riga3 $Zip     "<- e' questo che mi mandi"
Riga3 $Referto "<- la riga 'data:' deve essere di ADESSO, la riga 'modo:' dice se e' il round o un giro a vuoto"
Write-Host "=====================================================================" -ForegroundColor White
if($SoloControllo){
  Write-Host ("  MODO: " + $Modo + " -- GIRO A VUOTO. NESSUNA passata, NESSUN numero di round.") -ForegroundColor Yellow
  Write-Host ("        ini attesi in sosta: " + ($Lavori.Count + 2) + ".  QUESTO ZIP NON E' IL ROUND.") -ForegroundColor Yellow
} else {
  Write-Host ("  MODO: " + $Modo) -ForegroundColor White
  Write-Host  "  I TRE NUMERI:" -ForegroundColor White
  if($Passo0.DDLungo -ge 0){ Write-Host ("    A. DD lungo 2004-2026 ... " + (Fmt2 $Passo0.DDLungo) + "%   (n " + $Passo0.N + ")") -ForegroundColor White }
  else                     { Write-Host  "    A. DD lungo 2004-2026 ... NON MISURATO" -ForegroundColor Red }
  Write-Host ("    B. peggior giornata ..... " + $Passo0.PeggiorGiornata) -ForegroundColor White
  Write-Host  "    C. DD per regime:" -ForegroundColor White
  foreach($l in $Lavori){
    $et = "criterio C"
    if(-not $l.Criterio){ $et = "DIAGNOSTICA - non e' un criterio" }
    Write-Host ("       " + $l.Nome.PadRight(10) + " " + (Fmt2 $l.DD) + "%   n " + $l.N + "   " + $et) -ForegroundColor White
  }
  Write-Host ("  FINESTRA: " + $Passo0.Finestra) -ForegroundColor Yellow
  Write-Host ("  GEMELLI : " + $Passo0.Gemelli) -ForegroundColor Yellow
  if($Contratto.DD -gt 0){
    Write-Host ("  DD PROMESSO: " + $Contratto.DD.ToString("0.00",$INV) + "%  -> soglia 2x = " + (2*$Contratto.DD).ToString("0.00",$INV) + "%") -ForegroundColor Yellow
  } else {
    Write-Host ("  DD PROMESSO: " + $Contratto.Stato + " -> 2x NON CALCOLABILE, e NON e' un via libera") -ForegroundColor Yellow
  }
}
foreach($l in $Lavori){
  $c = "Green"; if($l.Esito -ne "OK" -and $l.Esito -ne "SOLO CONTROLLO"){ $c = "Yellow" }
  Write-Host ("   " + $l.Nome.PadRight(10) + " " + $l.Esito) -ForegroundColor $c
}
if($Problemi.Count -gt 0){
  Write-Host ""
  Write-Host "   PROBLEMI DA LEGGERE:" -ForegroundColor Red
  foreach($p in $Problemi){ Write-Host ("    - " + $p) -ForegroundColor Red }
}
Write-Host ""
#  L'ESITO IN CONSOLE DEVE DIRE LE STESSE PAROLE DEL REFERTO, o i due si
#  contraddicono: chi legge lo schermo e manda lo zip non ha visto il referto.
if($Fatale -ne ""){ Write-Host ("ESITO: FERMATO -- " + $Fatale) -ForegroundColor Red; exit 1 }
$ko = @($Lavori | Where-Object { $_.Esito -ne "OK" -and $_.Esito -ne "SOLO CONTROLLO" })
if($SoloControllo){
  if($ko.Count -gt 0 -or $Problemi.Count -gt 0){
    Write-Host ("ESITO: GIRO A VUOTO CON PROBLEMI (" + $Problemi.Count + ") -- NESSUNA passata, e c'e' da leggere il referto") -ForegroundColor Yellow; exit 1
  }
  Write-Host "ESITO: GIRO A VUOTO COMPLETATO -- NESSUNA passata, NESSUN numero. QUESTO ZIP NON E' IL ROUND." -ForegroundColor Green
  exit 0
}
if($ko.Count -gt 0 -or $Problemi.Count -gt 0){
  Write-Host ("ESITO: PARZIALE (" + $ko.Count + " finestre non OK, " + $Problemi.Count + " problemi)") -ForegroundColor Yellow; exit 1
}
Write-Host "ESITO: OK" -ForegroundColor Green
