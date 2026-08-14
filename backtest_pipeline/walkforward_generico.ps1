# =====================================================================
#  walkforward_generico.ps1  --  UN walk-forward per QUALSIASI EA
# ---------------------------------------------------------------------
#  PERCHE' ESISTE (07/08/2026)
#  Claudio: "puoi creare un agente che mi faccia i backtest, le
#  ottimizzazioni, che trovi i motori in autonomia degli EA che ho?".
#  Il collo di bottiglia non e' l'analisi: e' che finora OGNI EA ha
#  voluto il SUO driver scritto a mano. walkforward_aperture.ps1 sa fare
#  solo le aperture, walkforward_pte.ps1 sa fare solo la PTE. Con 39 EA
#  testabili (scheda_ea.py, 07/08) quello e' un lavoro di sartoria che
#  non finisce mai.
#
#  QUESTO invece non sa niente di nessun EA. Legge il .mq5, si ricava
#  da solo l'elenco degli input e li BLINDA tutti al loro default; poi
#  legge da prove\<EA>.txt le SOLE righe da spazzolare, con l'ipotesi e
#  i criteri gia' scritti sopra. Aggiungere un EA alla coda = scrivere
#  un file di testo, non un driver.
#
#  LE TRE TRAPPOLE CHE BLOCCA, GIA' PAGATE TUTTE E TRE
#   1. SWEEP DEGENERE: flag Y con start == stop, oppure step == 0. Non
#      spazzola niente e su un enum non produce nemmeno un pass. Il
#      07/08 sono usciti QUATTRO CSV VUOTI dopo una notte di macchina.
#   2. PARAMETRO DOPPIO in [TesterInputs]: MT5 fa zero passate.
#   3. NOME SBAGLIATO: un parametro che l'EA non ha viene ignorato in
#      silenzio da MT5, e la fase risponde a una domanda diversa da
#      quella che credevi di fare. Qui e' un errore, non un avviso.
#
#  E DICE QUANTE CELLE ASPETTARSI, PRIMA DI PARTIRE. Sugli enum MT5
#  IGNORA LO STEP e spazzola i membri compresi fra start e stop
#  (misurato il 07/08: InpTrailTF=5||1||4||5||Y ha dato M1..M5, cinque
#  celle, non ventidue). Il conteggio qui sotto lo tiene in conto.
#
#  QUELLO CHE NON FA, dichiarato:
#   - non dice se un EA e' buono. Produce i CSV. Il giudizio si legge
#     dai numeri FUORI campione contro i criteri scritti PRIMA.
#   - non verifica lo storico del simbolo. Quello si misura con
#     scarica_storico.ps1 -Simboli "XXX" -SoloReferto e si passa qui
#     con -DaQuando. Sugli indici il driver diceva 2024.01.01 e i dati
#     partivano dal 26/09/2024: meta' finestra IS non esisteva.
#
#  USO (PC di backtest, MT5 CHIUSO):
#    powershell -ExecutionPolicy Bypass -File .\walkforward_generico.ps1 -Expert ABTG_PTE -SoloControllo
#    powershell -ExecutionPolicy Bypass -File .\walkforward_generico.ps1 -Expert ABTG_PTE -DaQuando 2024.09.26
#
#  -SoloControllo NON apre MT5: scarica, legge, controlla tutto e ti
#  fa vedere l'.ini che lancerebbe. Lancialo SEMPRE prima: costa dieci
#  secondi e ti dice quante celle sono, cioe' quante ore di macchina.
# =====================================================================
param(
  [Parameter(Mandatory=$true,Position=0)][string]$Expert,   # nome del .mq5 senza estensione
  [string]$Simbolo   = "",           # se vuoto lo prende da @SIMBOLO nel file prova
  [string]$DaQuando  = "",           # inizio storico VERO, misurato
  [string]$Fino      = "2026.06.30",
  [string]$Periodo   = "",           # TF del grafico nel tester (@PERIODO nel file prova)
  [double]$FrazioneIS = 0.40,        # 40% dentro campione, 60% fuori
  [int]$Modello      = 4,            # 4 = tick reali (verita'). 1 = OHLC M1: SOLO screening, mai verdetti
  [int]$Deposito     = 10000,        # deposito del tester. 100000 = taglia prop: serve dove il lotto minimo schiaccia il rischio
  [string]$Etichetta = "",           # suffisso nei nomi dei CSV: un round nuovo NON sovrascrive il precedente
  [string]$Prova     = "",           # file prova alternativo (default: prove\<EA>.txt)
  [switch]$SoloControllo,            # controlla e stampa l'ini, NON lancia MT5
  [switch]$Rifai,
  [switch]$UseSpare,[string]$Terminal="",[string]$MetaEditor="",[string]$DataFolder="",[switch]$Force
)
$ErrorActionPreference="Stop"
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
$EABranch="lavoro"
$RawBase="https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$EABranch"
$Work= if($PSScriptRoot){$PSScriptRoot}else{(Get-Location).Path}; Set-Location $Work

function Titolo($t){ Write-Host ""; Write-Host $t -ForegroundColor Cyan }
function Muori($t){ Write-Host ""; Write-Host "!!! $t" -ForegroundColor Red; exit 1 }

Write-Host "=== WALK-FORWARD GENERICO - $Expert ===" -ForegroundColor Cyan

# =====================================================================
#  1. IL SORGENTE
# =====================================================================
$SrcDir=Join-Path $Work "src_prove"
New-Item -ItemType Directory -Force -Path $SrcDir | Out-Null
$srcFile=Join-Path $SrcDir "$Expert.mq5"
try{ Invoke-WebRequest -Uri "$RawBase/mql5/Experts/$Expert.mq5" -OutFile $srcFile -UseBasicParsing }
catch{
  if(-not (Test-Path $srcFile)){
    Muori ("non trovo l'EA '$Expert'. Il nome deve essere quello del file .mq5 SENZA estensione,`n" +
           "    e maiuscole/minuscole contano: es. ABTG_PTE, ABTG_DAX_Apertura_EU.")
  }
  Write-Host "    (download fallito: uso la copia locale gia' scaricata)" -ForegroundColor Yellow
}
$src=Get-Content $srcFile -Raw
Write-Host ("    sorgente: {0} righe" -f (($src -split "`n").Count)) -ForegroundColor DarkGray

# --- l'EA esporta i risultati? senza OnTester non c'e' niente da leggere.
#  Il 07/08 scheda_ea.py ha contato 39 EA su 61 che esportano: gli altri
#  22 NON sono testabili con questa pipeline, e va detto subito, non
#  dopo una notte di macchina.
if($src -notmatch 'double\s+OnTester\s*\('){
  Muori ("$Expert NON esporta i risultati (manca OnTester).`n" +
         "    MT5 girerebbe lo stesso, ma non produrrebbe nessun CSV da leggere.`n" +
         "    Va aggiunto il blocco OnTester all'EA prima di poterlo misurare.")
}

# =====================================================================
#  2. #define, enum, input: letti dal codice, non dichiarati a mano
# =====================================================================
#  ⚠️ vince la PRIMA definizione di un #define, non l'ultima: quelle in
#  fondo stanno dentro un #ifndef e sono il ripiego generico. Prendendo
#  l'ultima, il 07/08 nove EA d'apertura risultavano con lo stesso magic
#  e usciva un falso allarme.
$Defines=@{}
foreach($m in [regex]::Matches($src,'(?m)^\s*#define\s+(\w+)\s+([^\r\n/]+)')){
  $n=$m.Groups[1].Value; $v=$m.Groups[2].Value.Trim()
  if(-not $Defines.ContainsKey($n)){ $Defines[$n]=$v }
}

# --- enum: valore di ogni membro, e i membri IN ORDINE per ogni enum.
#  L'ordine serve per contare le celle: MT5 spazzola i membri fra start
#  e stop, quindi il numero di celle dipende da QUANTI membri ci sono
#  in mezzo, non dallo step.
$EnumVal=@{}          # NOME_MEMBRO -> valore
$EnumMembri=@{}       # NOME_ENUM   -> lista ordinata dei valori
foreach($m in [regex]::Matches($src,'(?s)enum\s+(\w+)\s*\{(.*?)\}')){
  $nomeEnum=$m.Groups[1].Value
  $corpo=$m.Groups[2].Value
  $corpo=[regex]::Replace($corpo,'(?s)/\*.*?\*/','')
  $corpo=[regex]::Replace($corpo,'//[^\r\n]*','')
  $prossimo=0
  $lista=New-Object System.Collections.ArrayList
  foreach($pezzo in ($corpo -split ',')){
    $p=$pezzo.Trim()
    if($p -eq ""){ continue }
    if($p -match '^(\w+)\s*=\s*(-?\d+)'){ $mn=$Matches[1]; $mv=[int]$Matches[2] }
    elseif($p -match '^(\w+)'){ $mn=$Matches[1]; $mv=$prossimo }
    else { continue }
    $prossimo=$mv+1
    $EnumVal[$mn]="$mv"
    [void]$lista.Add($mv)
  }
  if($lista.Count -gt 0){ $EnumMembri[$nomeEnum]=$lista }
}

# --- gli enum di MT5 non stanno nel sorgente: li mettiamo noi.
$TF=[ordered]@{ PERIOD_CURRENT=0; PERIOD_M1=1; PERIOD_M2=2; PERIOD_M3=3; PERIOD_M4=4
  PERIOD_M5=5; PERIOD_M6=6; PERIOD_M10=10; PERIOD_M12=12; PERIOD_M15=15; PERIOD_M20=20
  PERIOD_M30=30; PERIOD_H1=16385; PERIOD_H2=16386; PERIOD_H3=16387; PERIOD_H4=16388
  PERIOD_H6=16390; PERIOD_H8=16392; PERIOD_H12=16396; PERIOD_D1=16408; PERIOD_W1=32769
  PERIOD_MN1=49153 }
$listaTF=New-Object System.Collections.ArrayList
foreach($k in $TF.Keys){ $EnumVal[$k]="$($TF[$k])"; if($TF[$k] -gt 0){ [void]$listaTF.Add($TF[$k]) } }
$EnumMembri["ENUM_TIMEFRAMES"]=($listaTF | Sort-Object)
foreach($kv in @{ MODE_SMA=0; MODE_EMA=1; MODE_SMMA=2; MODE_LWMA=3 }.GetEnumerator()){ $EnumVal[$kv.Key]="$($kv.Value)" }
$EnumMembri["ENUM_MA_METHOD"]=@(0,1,2,3)
foreach($kv in @{ PRICE_CLOSE=1; PRICE_OPEN=2; PRICE_HIGH=3; PRICE_LOW=4
                  PRICE_MEDIAN=5; PRICE_TYPICAL=6; PRICE_WEIGHTED=7 }.GetEnumerator()){ $EnumVal[$kv.Key]="$($kv.Value)" }
$EnumMembri["ENUM_APPLIED_PRICE"]=@(1,2,3,4,5,6,7)
foreach($kv in @{ CALENDAR_IMPORTANCE_NONE=0; CALENDAR_IMPORTANCE_LOW=1
                  CALENDAR_IMPORTANCE_MODERATE=2; CALENDAR_IMPORTANCE_HIGH=3 }.GetEnumerator()){ $EnumVal[$kv.Key]="$($kv.Value)" }
$EnumMembri["ENUM_CALENDAR_EVENT_IMPORTANCE"]=@(0,1,2,3)

function Risolvi([string]$grezzo){
  # da "PERIOD_H4" / "true" / "ABTG_DEF_RANGE 35" al numero che MT5 vuole.
  $t=$grezzo
  $t=[regex]::Replace($t,'//.*$','')
  $t=$t.Trim().TrimEnd(';').Trim()
  # cast alla C: "(ENUM_ABTG_RANGE)ABTG_DEF_RANGE_MODE". Senza toglierlo
  # restavano fuori proprio RangeMode e TrailMode delle nove aperture,
  # cioe' i due parametri su cui abbiamo passato la notte del 07/08.
  $t=[regex]::Replace($t,'^\(\s*[A-Za-z_]\w*\s*\)\s*','').Trim()
  $apice=[char]34
  if($t.StartsWith($apice)){ return @{ ok=$true; tipo="stringa"; val=$t.Trim($apice) } }
  if($t -ieq "true" ){ return @{ ok=$true; tipo="num"; val="1" } }
  if($t -ieq "false"){ return @{ ok=$true; tipo="num"; val="0" } }
  if($t -match '^-?\d+(\.\d+)?$'){ return @{ ok=$true; tipo="num"; val=$t } }
  # un identificatore solo: #define oppure membro di enum. Due giri, perche'
  # un #define puo' puntare a un altro #define.
  for($giro=0; $giro -lt 3; $giro++){
    if($t -notmatch '^[A-Za-z_]\w*$'){ break }
    if($Defines.ContainsKey($t)){ $t=$Defines[$t].Trim(); continue }
    if($EnumVal.ContainsKey($t)){ return @{ ok=$true; tipo="num"; val=$EnumVal[$t] } }
    break
  }
  if($t -match '^-?\d+(\.\d+)?$'){ return @{ ok=$true; tipo="num"; val=$t } }
  if($t -ieq "true" ){ return @{ ok=$true; tipo="num"; val="1" } }
  if($t -ieq "false"){ return @{ ok=$true; tipo="num"; val="0" } }
  return @{ ok=$false; tipo="?"; val=$t }
}

# --- gli input. "input group" non ha l'uguale e non entra.
$Inputs=New-Object System.Collections.ArrayList     # @{ nome; tipo; val; ok }
$NonRisolti=New-Object System.Collections.ArrayList
foreach($m in [regex]::Matches($src,'(?m)^\s*s?input\s+([A-Za-z_]\w*)\s+([A-Za-z_]\w*)\s*=\s*(.+)$')){
  $tipo=$m.Groups[1].Value; $nome=$m.Groups[2].Value
  $r=Risolvi $m.Groups[3].Value
  [void]$Inputs.Add(@{ nome=$nome; tipo=$tipo; val=$r.val; ok=$r.ok; kind=$r.tipo })
  if(-not $r.ok){ [void]$NonRisolti.Add("$nome = $($r.val)") }
}
if($Inputs.Count -eq 0){ Muori "non ho trovato nessun 'input' nel sorgente: il formato non e' quello che mi aspetto." }

$NomiInput=@{}
foreach($i in $Inputs){ $NomiInput[$i.nome]=$i }
$TipoDi=@{}
foreach($i in $Inputs){ $TipoDi[$i.nome]=$i.tipo }

Write-Host ("    input trovati: {0}   (blindati al default: {1})" -f $Inputs.Count, (@($Inputs|Where-Object{$_.ok}).Count)) -ForegroundColor DarkGray
if($NonRisolti.Count -gt 0){
  Write-Host "    NON blindati (MT5 usera' il default compilato, che e' lo stesso valore):" -ForegroundColor DarkYellow
  foreach($n in $NonRisolti){ Write-Host "        $n" -ForegroundColor DarkYellow }
}

# =====================================================================
#  3. IL FILE PROVA: ipotesi, criteri, sweep
# =====================================================================
$ProvaFile= if($Prova){ $Prova } else { Join-Path $Work "prove\$Expert.txt" }
if((-not (Test-Path $ProvaFile)) -and $Prova){ Muori "il file prova che mi hai passato non esiste: $Prova" }
if(-not (Test-Path $ProvaFile)){
  New-Item -ItemType Directory -Force -Path (Join-Path $Work "prove") | Out-Null
  try{ Invoke-WebRequest -Uri "$RawBase/backtest_pipeline/prove/$Expert.txt" -OutFile $ProvaFile -UseBasicParsing }
  catch{
    Muori ("manca il file della prova: prove\$Expert.txt`n" +
           "    Dentro ci vanno TRE cose, in quest'ordine:`n" +
           "      1. l'IPOTESI, in italiano: perche' ci aspettiamo che quel parametro conti`n" +
           "      2. i CRITERI DI ACCETTAZIONE, scritti PRIMA di vedere i numeri`n" +
           "      3. le righe da spazzolare:  Nome=default||start||step||stop||Y`n" +
           "    Tutto il resto viene blindato da solo. Il formato e' in prove\LEGGIMI.md.")
  }
}
$righeProva=Get-Content $ProvaFile

$Direttive=@{}
$RigheProvaUtili=New-Object System.Collections.ArrayList
foreach($r in $righeProva){
  $t=$r.Trim()
  if($t -eq "" ){ continue }
  if($t.StartsWith("#")){ continue }
  if($t.StartsWith("@")){
    if($t -match '^@(\w+)\s+(.+)$'){ $Direttive[$Matches[1].ToUpper()]=$Matches[2].Trim() }
    continue
  }
  if($t -match "="){ [void]$RigheProvaUtili.Add($t) }
}
if($RigheProvaUtili.Count -eq 0){ Muori "in prove\$Expert.txt non c'e' nessuna riga di parametri (Nome=...)." }

if(-not $Simbolo  -and $Direttive.ContainsKey("SIMBOLO")){  $Simbolo =$Direttive["SIMBOLO"] }
if(-not $Periodo  -and $Direttive.ContainsKey("PERIODO")){  $Periodo =$Direttive["PERIODO"] }
if(-not $DaQuando -and $Direttive.ContainsKey("DAQUANDO")){ $DaQuando=$Direttive["DAQUANDO"] }
if(-not $Simbolo){ Muori "manca il simbolo. Passalo con -Simbolo NASUSD, o scrivi '@SIMBOLO NASUSD' nel file della prova." }
if(-not $DaQuando){ Muori ("manca la data di inizio storico.`n" +
    "    NON metterla a caso: misurala prima con`n" +
    "      powershell -ExecutionPolicy Bypass -File .\scarica_storico.ps1 -Simboli `"$Simbolo`" -SoloReferto`n" +
    "    e poi passala con -DaQuando. Sugli indici il driver diceva 2024.01.01`n" +
    "    e i dati partivano dal 26/09/2024: meta' finestra IS non esisteva.") }
if(-not $Periodo){ $Periodo="M5" }

# --- il TF del grafico conta o no? Se l'EA prende il TF da un input, il
#  Period del tester e' quasi ininfluente; se usa PERIOD_CURRENT, il
#  Period del tester E' la strategia.
$haInpTF   = $NomiInput.ContainsKey("InpTF")
$usaCurrent= ($src -match 'PERIOD_CURRENT')
if($usaCurrent -and -not $haInpTF){
  Write-Host ""
  Write-Host "    !! Questo EA usa PERIOD_CURRENT e non ha un input InpTF." -ForegroundColor Yellow
  Write-Host "       Il timeframe operativo E' il Period del tester: adesso e' $Periodo." -ForegroundColor Yellow
  Write-Host "       Se non e' quello su cui gira in forward, la misura non c'entra niente" -ForegroundColor Yellow
  Write-Host "       con l'EA vero. Si cambia con -Periodo M15 o con '@PERIODO M15'." -ForegroundColor Yellow
}

# =====================================================================
#  4. I CONTROLLI. Qui si ferma, non dopo una notte di macchina.
# =====================================================================
Titolo "--- controlli ---"
$Errori=New-Object System.Collections.ArrayList
$Sweep =New-Object System.Collections.ArrayList     # @{ nome; celle }

$Ignoti=New-Object System.Collections.ArrayList
$Degeneri=New-Object System.Collections.ArrayList
foreach($riga in $RigheProvaUtili){
  $nome=($riga -split "=")[0].Trim()
  if(-not $NomiInput.ContainsKey($nome)){ [void]$Ignoti.Add($nome); continue }
  $resto=$riga.Substring($riga.IndexOf("=")+1)
  $campi=$resto -split '\|\|'
  if($campi.Count -lt 5){ continue }                # riga a valore secco: pin, non sweep
  $flag=$campi[4].Trim()
  if($flag -notmatch '^[Yy]'){ continue }           # blindata di proposito
  $start=$campi[1].Trim(); $step=$campi[2].Trim(); $stop=$campi[3].Trim()
  $a=Risolvi $start; $b=Risolvi $stop; $s=Risolvi $step
  if(-not ($a.ok -and $b.ok -and $s.ok)){ [void]$Errori.Add("$nome : start/step/stop non sono numeri"); continue }

  # --- LA TRAPPOLA N.1, quella che e' costata una notte il 07/08.
  if(($a.val -eq $b.val) -or ([double]$s.val -eq 0)){
    [void]$Degeneri.Add($nome); continue
  }

  $tipoP=$TipoDi[$nome]
  if($EnumMembri.ContainsKey($tipoP)){
    # ENUM: MT5 IGNORA LO STEP e spazzola i membri fra start e stop.
    $lo=[math]::Min([double]$a.val,[double]$b.val); $hi=[math]::Max([double]$a.val,[double]$b.val)
    $celle=@($EnumMembri[$tipoP] | Where-Object { $_ -ge $lo -and $_ -le $hi }).Count
    [void]$Sweep.Add(@{ nome=$nome; celle=$celle; nota="enum $tipoP - lo step e' ignorato" })
  }else{
    # +1e-9: senza, uno step tipo 0,1 puo' dare 2,9999999998 e Floor mangia una cella.
    $celle=[math]::Floor([math]::Abs([double]$b.val-[double]$a.val)/[math]::Abs([double]$s.val)+1e-9)+1
    [void]$Sweep.Add(@{ nome=$nome; celle=[int]$celle; nota="" })
  }
}

if($Ignoti.Count -gt 0){
  Write-Host ""
  Write-Host "!!! QUESTI PARAMETRI L'EA NON CE LI HA:" -ForegroundColor Red
  foreach($n in $Ignoti){
    $pezzo= if($n.Length -gt 6){ $n.Substring(3) } else { "" }
    $vicini= if($pezzo){ @($Inputs | Where-Object { $_.nome -like "*$pezzo*" } | Select-Object -First 3 -ExpandProperty nome) } else { @() }
    if($vicini.Count -gt 0){ Write-Host ("      $n   -> forse intendevi: " + ($vicini -join ", ")) -ForegroundColor Red }
    else                   { Write-Host "      $n" -ForegroundColor Red }
  }
  Write-Host "    MT5 li ignorerebbe IN SILENZIO e la fase risponderebbe a un'altra domanda." -ForegroundColor Yellow
  [void]$Errori.Add("parametri inesistenti nel file della prova")
}
if($Degeneri.Count -gt 0){
  Write-Host ""
  Write-Host "!!! SWEEP DEGENERE (flag Y ma non spazzola niente):" -ForegroundColor Red
  foreach($n in $Degeneri){ Write-Host "      $n   -> start == stop, oppure step == 0" -ForegroundColor Red }
  Write-Host "    E' l'errore del 07/08: quattro CSV vuoti dopo una notte di macchina." -ForegroundColor Yellow
  [void]$Errori.Add("sweep degenere")
}
if($Sweep.Count -eq 0 -and $Errori.Count -eq 0){
  [void]$Errori.Add("nessun parametro da spazzolare: sarebbe un backtest singolo, non un walk-forward")
}

# --- il blocco finale: prima le blindature automatiche, poi il file
#  prova, che quindi VINCE sulle blindature (dedup: sopravvive l'ultima).
$Righe=New-Object System.Collections.ArrayList
foreach($i in $Inputs){
  if(-not $i.ok){ continue }
  if($i.kind -eq "stringa"){
    if($i.val -eq ""){ continue }                   # stringa vuota: la lascio al default compilato
    [void]$Righe.Add("$($i.nome)=$($i.val)")
  }
  else { [void]$Righe.Add("$($i.nome)=$($i.val)||$($i.val)||0||$($i.val)||N") }
}
foreach($r in $RigheProvaUtili){
  $n=($r -split "=")[0].Trim()
  if(-not $NomiInput.ContainsKey($n)){ continue }          # gli ignoti sono gia' un errore: non li conto qui
  $resto=$r.Substring($r.IndexOf("=")+1)
  if(($resto -split '\|\|').Count -ge 5){ [void]$Righe.Add($r); continue }
  # PIN SECCO: va blindato in forma completa v||v||0||v||N. Scoperto il
  # 09/08 (pt6c): un pin scritto 'Nome=35' imposta il VALORE ma NON spegne
  # il flag di ottimizzazione che MT5 ricorda dall'ultima griglia di
  # quell'EA -> il tester rispazzola la griglia vecchia nonostante il pin.
  $v=$resto.Trim()
  if($NomiInput[$n].kind -eq "stringa"){ [void]$Righe.Add("$n=$v") }
  else { [void]$Righe.Add("$n=$v||$v||0||$v||N") }
}

$Visti=@{}
$Finali=New-Object System.Collections.ArrayList
for($i=$Righe.Count-1; $i -ge 0; $i--){
  $n=($Righe[$i] -split "=")[0].Trim()
  if(-not $Visti.ContainsKey($n)){ $Visti[$n]=$true; [void]$Finali.Insert(0,$Righe[$i]) }
}
$doppi=@($Finali | ForEach-Object { ($_ -split "=")[0].Trim() } | Group-Object | Where-Object { $_.Count -gt 1 })
if($doppi.Count -gt 0){ [void]$Errori.Add("parametri duplicati: " + ($doppi.Name -join ", ")) }

$NCelle=1
foreach($s in $Sweep){ $NCelle=$NCelle * $s.celle }

# --- 14/08: celle SPENTE per costruzione. Quando si spazzolano ENTRAMBI i
#     lati (AllowLong 0-1 e AllowShort 0-1) la combinazione "0 e 0" non
#     opera: zero trade, nessuna riga utile nel CSV. Il conteggio grezzo
#     faceva scattare l'allarme rosso della cache su un caso normalissimo
#     (8 chieste, 6 righe). Qui si scala la quota di celle mute.
$nomiSweep = @($Sweep | ForEach-Object { $_.nome })
$NMute = 0
if(($nomiSweep -contains "InpAllowLong") -and ($nomiSweep -contains "InpAllowShort")){
  $cL = ($Sweep | Where-Object { $_.nome -eq "InpAllowLong"  }).celle
  $cS = ($Sweep | Where-Object { $_.nome -eq "InpAllowShort" }).celle
  if($cL -ge 2 -and $cS -ge 2){ $NMute = [int]($NCelle / ($cL * $cS)) }
}
$NAttese = $NCelle - $NMute

Write-Host ""
Write-Host "    parametri in [TesterInputs] : $($Finali.Count)" -ForegroundColor Gray
Write-Host "    spazzolati                  : $($Sweep.Count)" -ForegroundColor Gray
foreach($s in $Sweep){
  $nota= if($s.nota){ "   ($($s.nota))" } else { "" }
  Write-Host ("        {0,-24} {1,3} celle{2}" -f $s.nome, $s.celle, $nota) -ForegroundColor Gray
}
if($Sweep.Count -gt 0){
  Write-Host ("    celle per finestra          : $NCelle   ->  " + ($NCelle*2) + " pass a tick reali in tutto") -ForegroundColor White
}

if($Errori.Count -gt 0){
  Write-Host ""
  Write-Host "=== NON LANCIO. Prima si sistemano questi ===" -ForegroundColor Red
  foreach($e in $Errori){ Write-Host "    - $e" -ForegroundColor Red }
  exit 1
}
Write-Host "    controlli passati." -ForegroundColor Green

# =====================================================================
#  5. LE DUE FINESTRE
# =====================================================================
$Inizio=[datetime]::ParseExact($DaQuando,"yyyy.MM.dd",$null)
$FineDt=[datetime]::ParseExact($Fino,"yyyy.MM.dd",$null)
if($FineDt -le $Inizio){ Muori "la data -Fino ($Fino) non e' dopo -DaQuando ($DaQuando)." }
$Meta=$Inizio.AddDays([math]::Floor(($FineDt-$Inizio).TotalDays*$FrazioneIS))
$WF=@(
  @{ Tag="IS";  Da=$Inizio.ToString("yyyy.MM.dd");            A=$Meta.ToString("yyyy.MM.dd") },
  @{ Tag="OOS"; Da=$Meta.AddDays(1).ToString("yyyy.MM.dd");   A=$FineDt.ToString("yyyy.MM.dd") }
)
Write-Host ""
Write-Host "    IS  $($WF[0].Da) - $($WF[0].A)   (qui si sceglie)" -ForegroundColor Gray
Write-Host "    OOS $($WF[1].Da) - $($WF[1].A)   (qui si verifica, e NON si guarda per scegliere)" -ForegroundColor Gray
Write-Host ""
Write-Host "    Lo storico di $Simbolo parte DAVVERO dal $DaQuando ? Se non l'hai MISURATO," -ForegroundColor Yellow
Write-Host "    fermati: sugli indici diceva 2024.01.01 e partiva dal 26/09/2024." -ForegroundColor Yellow

$InputsTxt=($Finali) -join "`n"

# =====================================================================
#  6. -SoloControllo: si ferma qui e fa vedere cosa lancerebbe
# =====================================================================
if($SoloControllo){
  $anteprima=Join-Path $Work "anteprima_$($Expert)_$Simbolo.ini"
@"
[Tester]
Expert=$Expert.ex5
Symbol=$Simbolo
Period=$Periodo
Model=4
Optimization=1
OptimizationCriterion=6
FromDate=$($WF[0].Da)
ToDate=$($WF[0].A)
ForwardMode=0
Deposit=$Deposito
Currency=EUR
Leverage=100
ExecutionMode=0
ReplaceReport=1
ShutdownTerminal=1
Report=OptReport_$($Expert)_$($Simbolo)_IS

[TesterInputs]
$InputsTxt
"@ | Set-Content -Path $anteprima -Encoding ASCII
  Write-Host ""
  Write-Host "=== SOLO CONTROLLO: MT5 non e' stato aperto ===" -ForegroundColor Green
  Write-Host "    L'ini che lancerei e' qui, guardalo:" -ForegroundColor Gray
  Write-Host "      $anteprima" -ForegroundColor White
  Write-Host "    Se il numero di celle ti torna, rilancia lo stesso comando SENZA -SoloControllo." -ForegroundColor Gray
  try{ Set-Clipboard -Value $anteprima }catch{}
  exit 0
}

# =====================================================================
#  7. MT5: trova, compila, gira
# =====================================================================
if(-not $Terminal){
  $allTerm=Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue
  if($UseSpare){$c=$allTerm|Where-Object{$_.DirectoryName -like "*BCM Markets*" -and $_.DirectoryName -like "*-V3*"}|Select-Object -First 1}
  else{$c=$allTerm|Where-Object{$_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*"}|Select-Object -First 1}
  if(-not $c){$c=$allTerm|Where-Object{$_.DirectoryName -like "*BCM Markets*"}|Select-Object -First 1}
  if($c){$Terminal=$c.FullName; $MetaEditor=Join-Path $c.DirectoryName "metaeditor64.exe"}
}
if(-not $Terminal){ Muori "non trovo terminal64.exe. Passalo con -Terminal `"C:\...\terminal64.exe`"." }
if($Terminal -and -not $DataFolder){
  $instDir=Split-Path -Parent $Terminal; $termRoot=Join-Path $env:APPDATA "MetaQuotes\Terminal"
  if(Test-Path $termRoot){$DataFolder=Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue|Where-Object{$o=Join-Path $_.FullName "origin.txt";(Test-Path $o)-and((Get-Content $o -Raw).Trim() -ieq $instDir)}|Select-Object -First 1 -ExpandProperty FullName}
}
if(-not $DataFolder -or -not (Test-Path $DataFolder)){ Muori "cartella dati MT5 non trovata. Passala con -DataFolder." }

# MT5 aperto = il tester non parte e escono ZERO CSV. E' successo.
if((Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) -and -not $Force){
  Muori "chiudi MetaTrader prima di lanciare, altrimenti escono 0 CSV."
}

$MqlExperts=Join-Path $DataFolder "MQL5\Experts"
$MqlFiles  =Join-Path $DataFolder "MQL5\Files"
$Results   =Join-Path $Work "risultati_prove\$Expert"
New-Item -ItemType Directory -Force -Path $MqlExperts,$Results | Out-Null

Copy-Item $srcFile -Destination $MqlExperts -Force
& $MetaEditor "/compile:$(Join-Path $MqlExperts "$Expert.mq5")" "/log" | Out-Null
if(-not (Test-Path (Join-Path $MqlExperts "$Expert.ex5"))){ Muori "compilazione fallita per $Expert. Apri MetaEditor e guarda gli errori." }
Write-Host "    compilato $Expert" -ForegroundColor Green

$Suffisso = if($Modello -eq 4){ "" } else { "_ohlc" }   # un OHLC non deve MAI sovrascrivere un tick reale
if($Etichetta){ $Suffisso = $Suffisso + "_" + $Etichetta }
foreach($w in $WF){
  $tag="$($Expert)_$($Simbolo)_$($w.Tag)$Suffisso"
  $done=Join-Path $Results "$tag.csv"
  if((Test-Path $done) -and -not $Rifai){
    Write-Host "    $tag gia' fatto, salto (usa -Rifai per rifarlo)" -ForegroundColor DarkGray; continue
  }
  if(Test-Path $done){
    $vecchi=Join-Path $Results "vecchi"; New-Item -ItemType Directory -Force -Path $vecchi | Out-Null
    Move-Item $done (Join-Path $vecchi "$tag.csv") -Force
    Write-Host "    ${tag}: il precedente e' finito in 'vecchi\'" -ForegroundColor DarkYellow
  }
  Write-Host ""
  Write-Host "--- $tag   ($($w.Da) -> $($w.A))   $NCelle celle ---" -ForegroundColor Cyan

  $ini=Join-Path $Work "gen_$tag.ini"
@"
[Tester]
Expert=$Expert.ex5
Symbol=$Simbolo
Period=$Periodo
Model=$Modello
Optimization=1
OptimizationCriterion=6
FromDate=$($w.Da)
ToDate=$($w.A)
ForwardMode=0
Deposit=$Deposito
Currency=EUR
Leverage=100
ExecutionMode=0
ReplaceReport=1
ShutdownTerminal=1
Report=OptReport_$tag

[TesterInputs]
$InputsTxt
"@ | Set-Content -Path $ini -Encoding ASCII

  $csv=Join-Path $MqlFiles "OptResults_$($Expert)_$($Simbolo).csv"
  if(Test-Path $csv){ Remove-Item $csv -Force }
  $prima=Get-Date
  $comeGira = if($Modello -eq 4){ "tick reali" } else { "OHLC M1 - SOLO SCREENING, non un verdetto" }
  Write-Host "    avvio $NCelle pass ($comeGira)..." -ForegroundColor Cyan
  (Start-Process -FilePath $Terminal -ArgumentList "/config:`"$ini`"" -PassThru).WaitForExit()

  # l'EA compone il nome del CSV con MQL_PROGRAM_NAME e _Symbol. Se per
  # qualche EA non e' cosi', si ripiega sul piu' recente prodotto ADESSO.
  if(-not (Test-Path $csv)){
    $alt=@(Get-ChildItem $MqlFiles -Filter "OptResults_*.csv" -ErrorAction SilentlyContinue |
           Where-Object { $_.LastWriteTime -ge $prima } | Sort-Object LastWriteTime -Descending | Select-Object -First 1)
    if($alt.Count -gt 0){ $csv=$alt[0].FullName; Write-Host "    (CSV trovato con un altro nome: $($alt[0].Name))" -ForegroundColor DarkYellow }
  }
  if(Test-Path $csv){
    $n=@(Get-Content $csv).Count
    Copy-Item $csv -Destination $done -Force; Remove-Item $csv -Force
    if($n -le 1){ Write-Host "    ATTENZIONE: $tag.csv ha solo l'intestazione, ZERO passate." -ForegroundColor Red }
    else        { Write-Host ("    OK -> $tag.csv   ({0} righe)" -f ($n-1)) -ForegroundColor Green }
    if(($n-1) -eq $NAttese -and $NMute -gt 0){
      Write-Host ("    (regolare: {0} celle chieste meno {1} con ENTRAMBI i lati spenti = {2} righe)" -f $NCelle, $NMute, $NAttese) -ForegroundColor DarkGray
    }
    if(($n-1) -ne $NCelle -and ($n-1) -ne $NAttese){
      Write-Host ("    ATTENZIONE: {0} righe nel CSV ma {1} celle chieste ({2} attese)." -f ($n-1), $NCelle, $NAttese) -ForegroundColor Red
      Write-Host "    E' la CACHE del tester: MT5 ripesca pass gia' calcolati (anche di" -ForegroundColor Red
      Write-Host "    griglie vecchie) e NON riesegue le celle chieste se le ha in cache." -ForegroundColor Red
      Write-Host "    Un pass non rieseguito NON scrive i file per-trade (abtg_trades_*)." -ForegroundColor Red
      Write-Host "    Verifica: se i file abtg_trades_* dei magic chiesti sono comparsi" -ForegroundColor Red
      Write-Host "    freschi in Common\Files, i pass sono girati e va tutto bene." -ForegroundColor Red
      Write-Host "    Se NON ci sono: magic MAI usato prima, oppure svuotare Tester\cache." -ForegroundColor Red
    }
  }else{
    Write-Host "    (nessun CSV per ${tag}: storico mancante su $Simbolo? MT5 gia' aperto?)" -ForegroundColor Yellow
  }
}

# =====================================================================
#  8. IL REFERTO
# =====================================================================
$Attesi=@("$($Expert)_$($Simbolo)_IS$Suffisso.csv","$($Expert)_$($Simbolo)_OOS$Suffisso.csv")
$Mancanti=@($Attesi | Where-Object { -not (Test-Path (Join-Path $Results $_)) })

Write-Host ""
Write-Host "=== FINITO ===" -ForegroundColor White
Write-Host ("    CSV attesi: {0}   presenti: {1}   MANCANTI: {2}" -f $Attesi.Count, ($Attesi.Count-$Mancanti.Count), $Mancanti.Count) -ForegroundColor Gray
if($Mancanti.Count -gt 0){
  Write-Host ""
  Write-Host "!!! QUESTI NON SONO STATI PRODOTTI:" -ForegroundColor Red
  foreach($m in $Mancanti){ Write-Host "      $m" -ForegroundColor Red }
  Write-Host "    Rilancia lo STESSO comando SENZA -Rifai: rifa' solo questi." -ForegroundColor Yellow
}else{
  Write-Host "    Tutti e due prodotti, sono qui:" -ForegroundColor Green
  Write-Host "      $Results" -ForegroundColor White
  try{ Set-Clipboard -Value $Results }catch{}
}
Write-Host ""
Write-Host "    I criteri di accettazione sono scritti in cima a prove\$Expert.txt." -ForegroundColor Gray
Write-Host "    Si leggono PRIMA di guardare la tabella, e non si spostano dopo." -ForegroundColor Gray
