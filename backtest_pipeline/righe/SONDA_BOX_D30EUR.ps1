# =====================================================================
#  MARCATORE_SONDA_BOX_D30EUR_v1
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
# ---------------------------------------------------------------------
Titolo '3 - QUANTE GIORNATE SCARTA IL PAVIMENTO (6800 punti = 68,0 idx)'
$tab = New-Object System.Collections.ArrayList
[void]$tab.Add('cella   giornate   sotto 6800   %scartate   mediana pts')
foreach($H in $CELLE){
  $et = 'H' + ([string]$H).PadLeft(2,'0')
  $f = Join-Path $Cart ('SONDA_BOX_' + $SIMBOLO + '_' + $et + '.csv')
  if(-not (Test-Path -LiteralPath $f)){ [void]$tab.Add(($et + '     -- CSV MANCANTE --')); continue }
  $amp = New-Object System.Collections.ArrayList
  $primo = $true
  foreach($riga in (Get-Content -LiteralPath $f)){
    if($primo){ $primo = $false; continue }
    $c = $riga -split ';'
    if($c.Count -lt 2){ continue }
    $v = 0.0
    if([double]::TryParse($c[1], [Globalization.NumberStyles]::Float, [Globalization.CultureInfo]::InvariantCulture, [ref]$v)){ [void]$amp.Add($v) }
  }
  $n = $amp.Count
  if($n -eq 0){ [void]$tab.Add(($et + '     -- NESSUNA RIGA LEGGIBILE --')); continue }
  $sotto = @($amp | Where-Object { $_ -lt $PAVIMENTO }).Count
  $ord = @($amp | Sort-Object)
  $med = if($n % 2 -eq 1){ $ord[[int](($n-1)/2)] } else { ($ord[$n/2 - 1] + $ord[$n/2]) / 2.0 }
  [void]$tab.Add(($et.PadRight(8) + ([string]$n).PadLeft(8) + ([string]$sotto).PadLeft(13) +
                  ([string][math]::Round(100.0*$sotto/$n,1)).PadLeft(12) + ([string][math]::Round($med,0)).PadLeft(14)))
}
foreach($r in $tab){ Write-Host ('   ' + $r) }

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
[void]$ri.Add('giorni indietro chiesti: ' + $GiorniIndietro)
[void]$ri.Add('')
[void]$ri.Add('CORSE ATTESE: 7   RIUSCITE: ' + $fatti)
foreach($z in $esiti){ [void]$ri.Add('  ' + $z) }
[void]$ri.Add('')
[void]$ri.Add('QUANTE GIORNATE SCARTA IL PAVIMENTO (6800 punti = 68,0 idx):')
foreach($r in $tab){ [void]$ri.Add('  ' + $r) }
[void]$ri.Add('')
[void]$ri.Add('CHE COSA QUESTA SONDA NON DICE, e va letto prima di usarla:')
[void]$ri.Add('  - la colonna sessione_rompe NON E UTILIZZABILE per le celle H=0..H=15.')
[void]$ri.Add('    Il giorno logico dello script parte a NightStartHour: per H basso la')
[void]$ri.Add('    sessione del giorno dopo cade in un ALTRO giorno logico e la colonna')
[void]$ri.Add('    esce sempre nessuno. Non e un difetto della sonda: e la geometria.')
[void]$ri.Add('    La colonna che conta qui e ampiezza_notte_pts, e quella e giusta')
[void]$ri.Add('    per tutte e sette le celle.')
[void]$ri.Add('  - la sonda misura il PAVIMENTO (causa 1). La causa 2 -- il pendente che')
[void]$ri.Add('    scade senza essere toccato -- si ricava per DIFFERENZA contro gli n')
[void]$ri.Add('    gia misurati da R242, non la misura questa corsa.')
($ri -join "`r`n") | Set-Content -LiteralPath (Join-Path $Cart 'RIEPILOGO_SONDA.txt') -Encoding ASCII

$zip = Join-Path $dsk 'SONDA_BOX_D30EUR.zip'
if(Test-Path -LiteralPath $zip){ Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue }
Compress-Archive -Path (Join-Path $Cart '*') -DestinationPath $zip -Force
Write-Host ''
Write-Host ('ZIP PRONTO DA MANDARE: ' + $zip) -ForegroundColor Green
if($fatti -eq 7){ Write-Host 'CATENA COMPLETA: 7 corse su 7.' -ForegroundColor Green }
else { Write-Host ('CATENA INCOMPLETA: attese 7, riuscite ' + $fatti + '. I CSV mancanti sono elencati nel riepilogo.') -ForegroundColor Red }
Write-Host 'FILE ATTESI NELLO ZIP: RIEPILOGO_SONDA.txt + SONDA_BOX_D30EUR_H00/H03/H06/H09/H12/H15/H18.csv' -ForegroundColor Gray
