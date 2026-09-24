# =====================================================================
#  MARCATORE_SONDA_BOX_D30EUR_v2
#  SONDA_BOX_D30EUR.ps1 -- IL CENSIMENTO DEL BOX, GIORNO PER GIORNO
#
#  CHE COSA MISURA, e una cosa sola:
#    per ognuna delle SETTE celle dell'asse di R242 (InpBoxStartHour
#    0,3,6,9,12,15,18), l'AMPIEZZA DEL BOX di ogni singola giornata.
#    Da li' si conta quante giornate stanno SOTTO il pavimento
#    InpMinBoxPts=6800 (= 68,0 punti indice), che e' il numero che R242
#    ha dichiarato un BUCO: "la misura esatta non e' estraibile da un
#    CSV di ottimizzazione" (le passate girano in Optimization=1, cioe'
#    sugli agenti, dove le Print non si leggono).
#
#  PERCHE' SERVE: lo short di ABTG_MaxMinNotte riempie 96-130 giornate
#  su ~440 (il 22-30%). Le altre sette su dieci non fanno niente, e non
#  sappiamo quale delle due cause le fermi:
#    (1) il pavimento scarta la giornata PRIMA di piazzare;
#    (2) il pendente non viene toccato entro la scadenza / il cutoff.
#  Questa sonda misura ESATTAMENTE la (1). La (2) si ricava per
#  differenza contro gli n gia' misurati da R242.
#
#  E' DI SOLA LETTURA. Nessun tester, nessun ordine, nessun preset di
#  EA toccato: AllowLiveTrading=false in tutte e sette le corse.
#
#  NIENTE EMOJI QUI DENTRO (regola del 17/08): Windows PowerShell 5.1
#  legge i .ps1 come ANSI e un'emoji dentro una stringa rompe il parser.
# =====================================================================
[CmdletBinding()]
param(
  [Parameter(Mandatory=$true)][string]$Pin,
  [int]$TimeoutMin = 6,
  [int]$GiorniIndietro = 760
)

$ErrorActionPreference = 'Stop'
[Threading.Thread]::CurrentThread.CurrentCulture   = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentUICulture = [Globalization.CultureInfo]::InvariantCulture

$SIMBOLO = 'D30EUR'
$NOMESCRIPT = 'ABTG_Notte_Study'
$CELLE = @(0,3,6,9,12,15,18)
$PAVIMENTO = 6800   # punti, = 68,0 idx (1000 punti = 10 idx sul DAX BCM)

function Dico($t,$c='Gray'){ Write-Host ('   ' + $t) -ForegroundColor $c }
function Titolo($t){ Write-Host ''; Write-Host ('=== ' + $t + ' ===') -ForegroundColor Cyan }

# ---------------------------------------------------------------------
#  0. LA MACCHINA E IL TERMINALE. Fail-closed: se questa macchina non e'
#     il PC di backtest, o se ci trova piu' di un MT5, si ferma.
# ---------------------------------------------------------------------
Titolo '0 - MACCHINA E TERMINALE'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){
  throw ('SONDA_BOX_D30EUR gira SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui la macchina si chiama: ' + $env:COMPUTERNAME + '. Sul VPS VMI3047753 non si lancia: la challenge FTMO 541452707 sta operando.')
}
Dico ('pc   : ' + $env:COMPUTERNAME) 'Green'
Dico ('pin  : ' + $Pin) 'Green'

if((@(Get-Process -Name terminal64 -ErrorAction SilentlyContinue)).Count -gt 0){
  throw 'MT5 risulta APERTO su questo PC. La sonda ne apre una copia sua con /config e poi la chiude: col terminale gia aperto la riga StartUp NON viene letta e la sonda gira a vuoto. Chiudilo A MANO e rilancia.'
}

$InstAttesa = 'C:\Program Files\BCM Markets MT5 Terminal'
$Terminal   = Join-Path $InstAttesa 'terminal64.exe'
$MetaEditor = Join-Path $InstAttesa 'metaeditor64.exe'
if(-not (Test-Path -LiteralPath $Terminal)){
  throw ('terminale non trovato dove la sonda lo aspetta: ' + $Terminal + '. La sonda NON cerca altrove apposta: due ricerche indipendenti sono due occasioni di scegliere il terminale sbagliato.')
}
# Il censimento delle installazioni si fa sugli origin.txt, NON con una
# scansione di C:\: origin.txt e' l'elenco autorevole dei terminali che
# hanno girato su questa macchina, si legge in un istante, e non puo'
# mancare un'installazione fuori dai percorsi che avrei indovinato io.
$DataRoot = Join-Path $env:APPDATA 'MetaQuotes\Terminal'
$origini = @()
foreach($d in @(Get-ChildItem -Path $DataRoot -Directory -ErrorAction SilentlyContinue)){
  $o = Join-Path $d.FullName 'origin.txt'
  if(Test-Path -LiteralPath $o){
    $v = (Get-Content -LiteralPath $o -Raw).Trim()
    if($v -ne ''){ $origini = $origini + @([pscustomobject]@{ Dir = $d.FullName; Inst = $v }) }
  }
}
$diversi = @($origini | Where-Object { $_.Inst -ne $InstAttesa })
if($diversi.Count -gt 0){
  Write-Host '   ATTENZIONE: su questa macchina hanno girato ALTRE installazioni MT5:' -ForegroundColor Red
  foreach($a in $diversi){ Write-Host ('     ' + $a.Inst) -ForegroundColor Red }
  throw 'La sonda si ferma: la riga dichiara che il PC di backtest ha UN SOLO MT5, e qui ce ne sono altri. Finche non si sa QUALE conto e loggato in ognuno, non si apre niente (regola dei terminali multipli).'
}
Dico ('terminale: ' + $Terminal) 'Green'
Dico ('installazioni MT5 viste su questa macchina: ' + $origini.Count) 'Green'

# cartella dati del terminale
$cands = @(Get-ChildItem -Path $DataRoot -Directory -ErrorAction SilentlyContinue | Where-Object {
  $o = Join-Path $_.FullName 'origin.txt'
  (Test-Path -LiteralPath $o) -and ((Get-Content -LiteralPath $o -Raw).Trim() -eq $InstAttesa)
})
if($cands.Count -ne 1){
  throw ('cartella dati NON risolta in modo univoco: trovate ' + $cands.Count + ' candidate per ' + $InstAttesa + '. La sonda si ferma invece di indovinare.')
}
$DataFolder = $cands[0].FullName
$MqlScr = Join-Path $DataFolder 'MQL5\Scripts'
$MqlPre = Join-Path $DataFolder 'MQL5\Presets'
$MqlFil = Join-Path $DataFolder 'MQL5\Files'
New-Item -ItemType Directory -Force -Path $MqlScr,$MqlPre,$MqlFil | Out-Null
Dico ('dati     : ' + $DataFolder) 'Green'

# ---------------------------------------------------------------------
#  1. LO SCRIPT AL PIN, E LA COMPILAZIONE VERIFICATA
# ---------------------------------------------------------------------
Titolo '1 - SCRIPT AL PIN E COMPILAZIONE'
$Work = Join-Path $env:USERPROFILE 'abtg_sonda'
New-Item -ItemType Directory -Force -Path $Work | Out-Null
$srcLoc = Join-Path $Work ($NOMESCRIPT + '.mq5')
Remove-Item -LiteralPath $srcLoc -Force -ErrorAction SilentlyContinue
$url = 'https://raw.githubusercontent.com/claudiospadaro12/GITHUB/' + $Pin + '/mql5/Scripts/' + $NOMESCRIPT + '.mq5?cb=' + [Guid]::NewGuid().ToString('N')
Invoke-RestMethod -Uri $url -OutFile $srcLoc
if(-not (Select-String -LiteralPath $srcLoc -SimpleMatch -Pattern 'InpNightStartHour' -Quiet)){
  throw ($NOMESCRIPT + '.mq5 scaricato ma NON contiene InpNightStartHour: copia sbagliata o cache di GitHub. Non si parte.')
}
Copy-Item -LiteralPath $srcLoc -Destination (Join-Path $MqlScr ($NOMESCRIPT + '.mq5')) -Force

$ex5 = Join-Path $MqlScr ($NOMESCRIPT + '.ex5')
Remove-Item -LiteralPath $ex5 -Force -ErrorAction SilentlyContinue
$logC = Join-Path $Work 'compile.log'
Remove-Item -LiteralPath $logC -Force -ErrorAction SilentlyContinue
# MetaEditor a volte si stacca e -Wait torna subito: il verdetto NON e' il
# suo codice di uscita, e' l'esistenza del .ex5. Si aspetta quello.
$pMe = Start-Process -FilePath $MetaEditor -ArgumentList @('/compile:' + (Join-Path $MqlScr ($NOMESCRIPT + '.mq5')), '/log:' + $logC) -PassThru
$attC = 0
while(-not (Test-Path -LiteralPath $ex5) -and $attC -lt 60){ Start-Sleep -Seconds 2; $attC = $attC + 1 }
if(-not (Test-Path -LiteralPath $ex5)){
  try{ if(-not $pMe.HasExited){ $pMe.Kill() } }catch{ }
  if(Test-Path -LiteralPath $logC){ Get-Content -LiteralPath $logC | Select-Object -Last 15 | ForEach-Object { Write-Host ('     ' + $_) -ForegroundColor DarkYellow } }
  throw ($NOMESCRIPT + '.ex5 NON prodotto dopo 120 secondi. Senza il compilato la sonda non gira: guarda il log qui sopra (MetaEditor aperto a mano da un altra parte?).')
}
Dico ('compilato: ' + $ex5) 'Green'

# ---------------------------------------------------------------------
#  2. LE SETTE CORSE
#     H=0  -> NightEnd=24  (InNotte r.90: 0<=24 -> ora>=0 && ora<24 = tutto il giorno)
#     H>0  -> NightEnd=0   (InNotte r.92: H<=0 falso -> ora>=H || ora<0 = ora>=H)
#     Sono le DUE forme che riproducono il box di R242, verificate nel
#     sorgente r.90-92. Con H=0 e NightEnd=0 la finestra sarebbe VUOTA.
#     RESIDUO, misurato e non assunto: l'EA prende gli estremi su
#     PERIOD_M1 (ABTG_MaxMinNotte r.308-318, il TF e' SCRITTO nel codice,
#     non e' quello del grafico) e include anche la barra del minuto
#     00:00; questo script legge M5 ed esclude l'ora 0. I bordi stanno
#     sull'ora tonda e 5 divide 60, quindi lo scarto sta sotto UNA barra
#     M5 su un box da 6 a 24 ore.
# ---------------------------------------------------------------------
Titolo '2 - LE SETTE CORSE'
$dsk  = [Environment]::GetFolderPath('Desktop')
$Cart = Join-Path $dsk 'SONDA_BOX_D30EUR'
if(Test-Path -LiteralPath $Cart){ Remove-Item -LiteralPath $Cart -Recurse -Force -ErrorAction SilentlyContinue }
New-Item -ItemType Directory -Force -Path $Cart | Out-Null

$csvVivo = Join-Path $MqlFil ('ABTG_Notte_Study_' + $SIMBOLO + '.csv')
$esiti = New-Object System.Collections.ArrayList
$fatti = 0

foreach($H in $CELLE){
  $et = 'H' + ([string]$H).PadLeft(2,'0')
  $fine = if($H -eq 0){ 24 } else { 0 }

  # il .set nomina TUTTI e nove gli input del sorgente: un input che il
  # .set non nomina NON torna al suo default, resta l'ultimo valore usato
  # a mano che MT5 si ricorda (checklist 25).
  $setName = 'abtg_sonda_box_' + $et + '.set'
  $righeSet = @(
    'InpNightStartHour=' + $H,
    'InpNightEndHour=' + $fine,
    'InpFocusHour=2',
    'InpFocusWidth=1',
    'InpSessStartHour=8',
    'InpSessEndHour=17',
    'InpSessEndMin=30',
    'InpSwingMinPts=0',
    'InpDaysBack=' + $GiorniIndietro
  )
  Set-Content -LiteralPath (Join-Path $MqlPre $setName) -Value ($righeSet -join "`r`n") -Encoding Unicode

  # il CSV vivo si CANCELLA prima di ogni corsa: senza questo, una corsa
  # che fallisce lascia il file della corsa PRECEDENTE e la sonda lo
  # rinomina come se fosse il nuovo. Il controllo sulla data da solo non
  # basta: due cinture, non una.
  Remove-Item -LiteralPath $csvVivo -Force -ErrorAction SilentlyContinue

  $ini = Join-Path $Work ('sonda_' + $et + '.ini')
  $testoIni = "[Charts]`r`nMaxBars=2000000000`r`n`r`n" +
              "[Experts]`r`nAllowLiveTrading=false`r`nEnabled=true`r`n`r`n" +
              "[StartUp]`r`nScript=" + $NOMESCRIPT + "`r`n" +
              "ScriptParameters=" + $setName + "`r`n" +
              "Symbol=" + $SIMBOLO + "`r`nPeriod=M15`r`n"
  Set-Content -LiteralPath $ini -Value $testoIni -Encoding Unicode

  $t0 = Get-Date
  Write-Host ''
  Write-Host ('--- ' + $et + '   box ' + $H + ':00 -> 00:00   (NightStart=' + $H + ', NightEnd=' + $fine + ') ---') -ForegroundColor Cyan
  Start-Process -FilePath $Terminal -ArgumentList ('/config:"' + $ini + '"') | Out-Null

  $scade = (Get-Date).AddMinutes($TimeoutMin)
  $ok = $false
  while((Get-Date) -lt $scade){
    Start-Sleep -Seconds 5
    if(Test-Path -LiteralPath $csvVivo){
      if((Get-Item -LiteralPath $csvVivo).LastWriteTime -ge $t0){ Start-Sleep -Seconds 2; $ok = $true; break }
    }
  }

  # chiusura pulita del terminale che ha aperto la sonda
  foreach($p in @(Get-Process -Name terminal64 -ErrorAction SilentlyContinue)){
    try{ [void]$p.CloseMainWindow() }catch{ }
  }
  $att = 0
  while((@(Get-Process -Name terminal64 -ErrorAction SilentlyContinue)).Count -gt 0 -and $att -lt 18){ Start-Sleep -Seconds 5; $att = $att + 1 }
  if((@(Get-Process -Name terminal64 -ErrorAction SilentlyContinue)).Count -gt 0){
    Dico ('IL TERMINALE NON SI E CHIUSO entro 90 secondi dopo ' + $et + '. La cella dopo NON') 'Red'
    Dico ('partira: MT5 non apre una seconda istanza sulla stessa cartella dati, quindi la') 'Red'
    Dico ('riga StartUp non viene letta e TUTTE le celle rimaste usciranno MANCANTI. Non e') 'Red'
    Dico ('un numero sbagliato, e un numero assente: chiudi MT5 a mano e rilancia la sonda.') 'Red'
  }

  if($ok){
    $dest = Join-Path $Cart ('SONDA_BOX_' + $SIMBOLO + '_' + $et + '.csv')
    Move-Item -LiteralPath $csvVivo -Destination $dest -Force
    $nr = (@(Get-Content -LiteralPath $dest)).Count - 1
    [void]$esiti.Add(($et + '  OK   giornate ' + $nr))
    Dico ('CSV raccolto: ' + (Split-Path -Leaf $dest) + '   giornate ' + $nr) 'Green'
    $fatti = $fatti + 1
  } else {
    [void]$esiti.Add(($et + '  MANCANTE  (nessun CSV fresco entro ' + $TimeoutMin + ' minuti)'))
    Dico ('NESSUN CSV FRESCO per ' + $et) 'Red'
  }
}

# ---------------------------------------------------------------------
#  3. LA LETTURA IN CONSOLE. Solo conteggi: la sonda NON giudica.
#
#     ATTENZIONE A COSA E' LA COLONNA "data": e' il giorno in cui il box
#     COMINCIA. La giornata operativa dell'EA e' quella DOPO. Da qui due
#     cose che vanno CONTATE e non assunte (classe 284, denominatore):
#       - una riga datata DOMENICA e' il box del LUNEDI'. Il DAX non
#         quota la domenica, quindi quelle righe NON ESISTONO: il
#         censimento NON VEDE i lunedi'. L'EA invece quel giorno opera,
#         e riceve un box artefatto (iBarShift(...,false) torna all'ultima
#         barra di VENERDI', R242b par.7 "CANCELLO 2"), che il pavimento
#         scarta quasi sempre. Le due popolazioni NON coincidono.
#       - una riga datata VENERDI' e' il box di un SABATO, giornata che
#         l'EA non opera mai: e' in piu', non in meno.
#     Per questo qui si stampa il calendario, non solo la percentuale.
# ---------------------------------------------------------------------
Titolo '3 - IL CENSIMENTO DEL BOX'

$inv    = [Globalization.CultureInfo]::InvariantCulture
# finestra di R242 (@DAQUANDO 2024.09.26 / @FINOA 2026.06.30) tradotta in
# giorni di INIZIO BOX: il box della giornata 2026.06.30 comincia il 29.
$R242Da = New-Object DateTime 2024,9,26
$R242A  = New-Object DateTime 2026,6,29
$NOMIDOW = @('dom','lun','mar','mer','gio','ven','sab')

function Mediana($arr){
  $k = $arr.Count
  if($k -eq 0){ return 0.0 }
  $s = @($arr | Sort-Object)
  if($k % 2 -eq 1){ return [double]$s[[int](($k-1)/2)] }
  return ([double]$s[$k/2 - 1] + [double]$s[$k/2]) / 2.0
}

$righeA = New-Object System.Collections.ArrayList
$righeB = New-Object System.Collections.ArrayList
$righeC = New-Object System.Collections.ArrayList
[void]$righeA.Add('cella  giornate  dal          al           sotto6800    %   mediana | dentro R242: gg  sotto    %')
[void]$righeB.Add('cella   dom(=lun EA)  lun  mar  mer  gio  ven(=sab EA)  sab')
[void]$righeC.Add('cella  finestra coperta   rompeMAX  rompeMIN  nessuno | col box>=6800: MAX   MIN')

foreach($H in $CELLE){
  $et = 'H' + ([string]$H).PadLeft(2,'0')
  $f  = Join-Path $Cart ('SONDA_BOX_' + $SIMBOLO + '_' + $et + '.csv')
  if(-not (Test-Path -LiteralPath $f)){
    [void]$righeA.Add($et + '   -- CSV MANCANTE --')
    [void]$righeB.Add($et + '   -- CSV MANCANTE --')
    [void]$righeC.Add($et + '   -- CSV MANCANTE --')
    continue
  }

  $amp = New-Object System.Collections.ArrayList     # tutte le ampiezze
  $ampR= New-Object System.Collections.ArrayList     # solo dentro la finestra di R242
  $dow = @(0,0,0,0,0,0,0)
  $sotto=0; $sottoR=0; $rMax=0; $rMin=0; $rNo=0; $fMax=0; $fMin=0
  $dMin=$null; $dMax=$null; $senzaData=0
  $primo = $true
  foreach($riga in (Get-Content -LiteralPath $f)){
    if($primo){ $primo = $false; continue }
    $c = $riga -split ';'
    if($c.Count -lt 2){ continue }
    $v = 0.0
    if(-not [double]::TryParse($c[1], [Globalization.NumberStyles]::Float, $inv, [ref]$v)){ continue }
    [void]$amp.Add($v)
    if($v -lt $PAVIMENTO){ $sotto = $sotto + 1 }

    $rot = ''
    if($c.Count -ge 8){ $rot = $c[7].Trim() }
    if($rot -eq 'MAX'){ $rMax = $rMax + 1; if($v -ge $PAVIMENTO){ $fMax = $fMax + 1 } }
    elseif($rot -eq 'MIN'){ $rMin = $rMin + 1; if($v -ge $PAVIMENTO){ $fMin = $fMin + 1 } }
    else { $rNo = $rNo + 1 }

    $d = New-Object DateTime 1,1,1
    if([DateTime]::TryParseExact($c[0].Trim(),'yyyy.MM.dd',$inv,[Globalization.DateTimeStyles]::None,[ref]$d)){
      $dow[[int]$d.DayOfWeek] = $dow[[int]$d.DayOfWeek] + 1
      if($dMin -eq $null -or $d -lt $dMin){ $dMin = $d }
      if($dMax -eq $null -or $d -gt $dMax){ $dMax = $d }
      if($d -ge $R242Da -and $d -le $R242A){
        [void]$ampR.Add($v)
        if($v -lt $PAVIMENTO){ $sottoR = $sottoR + 1 }
      }
    } else { $senzaData = $senzaData + 1 }
  }

  $n = $amp.Count
  if($n -eq 0){
    [void]$righeA.Add($et + '   -- NESSUNA RIGA LEGGIBILE --')
    [void]$righeB.Add($et + '   -- NESSUNA RIGA LEGGIBILE --')
    [void]$righeC.Add($et + '   -- NESSUNA RIGA LEGGIBILE --')
    continue
  }
  $med  = Mediana $amp
  $nR   = $ampR.Count
  $pct  = [math]::Round(100.0*$sotto/$n,1)
  $pctR = if($nR -gt 0){ [math]::Round(100.0*$sottoR/$nR,1) } else { 0.0 }
  $sDa  = if($dMin -ne $null){ $dMin.ToString('yyyy.MM.dd') } else { '??????????' }
  $sA   = if($dMax -ne $null){ $dMax.ToString('yyyy.MM.dd') } else { '??????????' }
  [void]$righeA.Add($et.PadRight(7) + ([string]$n).PadLeft(7) + '  ' + $sDa + '   ' + $sA + '   ' +
                    ([string]$sotto).PadLeft(7) + ([string]$pct).PadLeft(7) +
                    ([string][math]::Round($med,0)).PadLeft(9) + ' |' +
                    ([string]$nR).PadLeft(15) + ([string]$sottoR).PadLeft(7) + ([string]$pctR).PadLeft(7))
  [void]$righeB.Add($et.PadRight(7) + ([string]$dow[0]).PadLeft(9) + ([string]$dow[1]).PadLeft(8) +
                    ([string]$dow[2]).PadLeft(5) + ([string]$dow[3]).PadLeft(5) + ([string]$dow[4]).PadLeft(5) +
                    ([string]$dow[5]).PadLeft(9) + ([string]$dow[6]).PadLeft(12))

  # QUANTA sessione vede davvero la colonna sessione_rompe, cella per cella.
  # Il ciclo r.191-196 del sorgente salta le barre della notte e tiene solo
  # 08:00 <= mm < 17:30. Le ore NON notturne del giorno logico sono 0..H-1
  # (del giorno DOPO), quindi la finestra coperta e' da 08:00 a min(H-1,17).
  $hUlt  = [math]::Min($H-1,17)
  $copre = '-- niente --   '
  if($H -gt 8){
    if($hUlt -ge 17){ $copre = '08:00-17:29    ' }
    else { $copre = '08:00-' + ([string]$hUlt).PadLeft(2,'0') + ':59    ' }
  }
  $nota = ''
  if($H -eq 12){ $nota = '  <== e LA FINESTRA D INGRESSO DELL EA (piazza 07:59, cutoff 12:00)' }
  [void]$righeC.Add($et.PadRight(7) + $copre + ([string]$rMax).PadLeft(8) + ([string]$rMin).PadLeft(10) +
                    ([string]$rNo).PadLeft(9) + ' |' + ([string]$fMax).PadLeft(17) + ([string]$fMin).PadLeft(6) + $nota)
  if($senzaData -gt 0){ [void]$righeB.Add('       (' + $senzaData + ' righe con data illeggibile in ' + $et + ')') }
}

Write-Host ''
Write-Host '   TABELLA A -- IL PAVIMENTO (6800 punti = 68,0 idx)' -ForegroundColor White
foreach($r in $righeA){ Write-Host ('   ' + $r) }
Write-Host ''
Write-Host '   TABELLA B -- CHE GIORNATE SONO (la data e il giorno in cui il box COMINCIA:' -ForegroundColor White
Write-Host '   la giornata operativa dell EA e quella DOPO)' -ForegroundColor White
foreach($r in $righeB){ Write-Host ('   ' + $r) }
Write-Host ''
Write-Host '   TABELLA C -- LA SESSIONE DEL GIORNO DOPO (causa 2), con la finestra che la' -ForegroundColor White
Write-Host '   colonna sessione_rompe copre DAVVERO in quella cella' -ForegroundColor White
foreach($r in $righeC){ Write-Host ('   ' + $r) }

# ---------------------------------------------------------------------
#  3-bis. LE TRE AVVERTENZE CHE DECIDONO SE I NUMERI SONO CONFRONTABILI.
#         Si stampano SEMPRE, anche quando tutto e' andato bene: un
#         elenco di soli difetti descrive male la realta'.
# ---------------------------------------------------------------------
$avv = New-Object System.Collections.ArrayList
[void]$avv.Add('1. LA POPOLAZIONE NON E QUELLA DI R242, e la differenza e i LUNEDI.')
[void]$avv.Add('   Guarda la colonna dom di TABELLA B. Se e ZERO, il censimento non vede')
[void]$avv.Add('   nessun box del lunedi (il DAX non quota di domenica), mentre R242 quei')
[void]$avv.Add('   lunedi li ha contati tutti e li' + " " + 'da per scartati dal pavimento')
[void]$avv.Add('   (R242b par.7 CANCELLO 2: box artefatto da iBarShift, ~20% delle')
[void]$avv.Add('   giornate, tipicamente sotto 68 idx). Quindi:')
[void]$avv.Add('     %scartate DELL EA  =  q_lun + (1 - q_lun) x %scartate DI QUESTA TABELLA')
[void]$avv.Add('   e AL CONTRARIO le soglie di R242, che sono scritte su TUTTE le giornate,')
[void]$avv.Add('   vanno DIVISE per (1 - q_lun) prima di confrontarle con la colonna %:')
[void]$avv.Add('     atteso 3,9%   -> 4,9%   con q_lun = 0,20')
[void]$avv.Add('     cieco  8,8%   -> 11,0%  (LONG)   cieco 10,4% -> 13,0% (SHORT)')
[void]$avv.Add('   Confrontare il numero grezzo con 8,8 e un errore di classe 284.')
[void]$avv.Add('2. LA FINESTRA NON E QUELLA DI R242. Questa corsa arriva a OGGI; R242 si')
[void]$avv.Add('   ferma al 2026.06.30. Per questo TABELLA A porta le due colonne: usa')
[void]$avv.Add('   quelle di destra (dentro R242) per qualunque confronto con i suoi n.')
[void]$avv.Add('3. LA COLONNA sessione_rompe NON E CIECA DAPPERTUTTO, e TABELLA C dice')
[void]$avv.Add('   dove. E vuota solo a H00/H03/H06. A H12 copre 08:00-11:59, che e')
[void]$avv.Add('   ESATTAMENTE la finestra d ingresso dell EA: li la colonna MIN col box')
[void]$avv.Add('   sopra il pavimento e una PREDIZIONE DIRETTA dell n short di R242 (120')
[void]$avv.Add('   a H=12), da leggere come forchetta -- in ECCESSO perche qui non c e il')
[void]$avv.Add('   buffer di 1000 punti, in DIFETTO perche mancano i lunedi.')
Write-Host ''
foreach($r in $avv){ Write-Host ('   ' + $r) -ForegroundColor Yellow }

# ---------------------------------------------------------------------
#  4. RACCOLTA
# ---------------------------------------------------------------------
Titolo '4 - RACCOLTA'
$ri = New-Object System.Collections.ArrayList
[void]$ri.Add('SONDA BOX D30EUR -- il censimento del box, giorno per giorno')
[void]$ri.Add('data: ' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss'))
[void]$ri.Add('pc  : ' + $env:COMPUTERNAME + '   (PC di backtest; VPS VMI3047753 NON toccato)')
[void]$ri.Add('pin : ' + $Pin)
[void]$ri.Add('terminale: ' + $Terminal + '   (conto 50503392, AllowLiveTrading=false in tutte e sette le corse)')
[void]$ri.Add('giorni indietro chiesti: ' + $GiorniIndietro + '   (finestra effettiva: vedi TABELLA A)')
[void]$ri.Add('')
[void]$ri.Add('CORSE ATTESE: 7   RIUSCITE: ' + $fatti)
foreach($z in $esiti){ [void]$ri.Add('  ' + $z) }
[void]$ri.Add('')
[void]$ri.Add('TABELLA A -- IL PAVIMENTO (6800 punti = 68,0 idx):')
foreach($r in $righeA){ [void]$ri.Add('  ' + $r) }
[void]$ri.Add('')
[void]$ri.Add('TABELLA B -- CHE GIORNATE SONO (data = giorno di INIZIO del box):')
foreach($r in $righeB){ [void]$ri.Add('  ' + $r) }
[void]$ri.Add('')
[void]$ri.Add('TABELLA C -- LA SESSIONE DEL GIORNO DOPO (causa 2):')
foreach($r in $righeC){ [void]$ri.Add('  ' + $r) }
[void]$ri.Add('')
[void]$ri.Add('PRIMA DI CONFRONTARE QUESTI NUMERI CON R242:')
foreach($r in $avv){ [void]$ri.Add('  ' + $r) }
[void]$ri.Add('')
[void]$ri.Add('CHE COSA QUESTA SONDA NON DICE:')
[void]$ri.Add('  - non misura la causa 2 in tutte le celle: TABELLA C dice in quali si')
[void]$ri.Add('    puo leggere e su che finestra. Dove la finestra coperta e vuota, la')
[void]$ri.Add('    causa 2 resta una STIMA per differenza, non una misura.')
[void]$ri.Add('  - la geometria del box e riprodotta, non identica: l EA legge gli estremi')
[void]$ri.Add('    su PERIOD_M1 (ABTG_MaxMinNotte r.308-318), questo script su M5, e l EA')
[void]$ri.Add('    include anche la barra del minuto 00:00. Residuo sotto una barra M5.')
[void]$ri.Add('  - non e un round e non promuove niente: nessuna sedia, nessun preset di')
[void]$ri.Add('    EA, nessun ordine e nessun Strategy Tester sono stati toccati.')
($ri -join "`r`n") | Set-Content -LiteralPath (Join-Path $Cart 'RIEPILOGO_SONDA.txt') -Encoding ASCII

$zip = Join-Path $dsk 'SONDA_BOX_D30EUR.zip'
if(Test-Path -LiteralPath $zip){ Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue }
Compress-Archive -Path (Join-Path $Cart '*') -DestinationPath $zip -Force
Write-Host ''
Write-Host ('ZIP PRONTO DA MANDARE: ' + $zip) -ForegroundColor Green
if($fatti -eq 7){ Write-Host 'CATENA COMPLETA: 7 corse su 7.' -ForegroundColor Green }
else { Write-Host ('CATENA INCOMPLETA: attese 7, riuscite ' + $fatti + '. I CSV mancanti sono elencati nel riepilogo.') -ForegroundColor Red }
Write-Host 'FILE ATTESI NELLO ZIP: RIEPILOGO_SONDA.txt + SONDA_BOX_D30EUR_H00/H03/H06/H09/H12/H15/H18.csv' -ForegroundColor Gray
