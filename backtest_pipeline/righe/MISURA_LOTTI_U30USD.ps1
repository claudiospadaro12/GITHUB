# =====================================================================
#  MARCATORE_MISURA_LOTTI_U30USD_v1
#
#  MISURA DEL DELTA LOTTI su U30USD -- sedie 771531 (EMA200) e 770511
#  (SuperWave DOW H1 Ott). QUATTRO corse nel tester, e una tabella.
#
#  Firma di Claudio (19/09/2026): "Misura prima, lancia la corsa nel
#  tester". Referto: report/MISURA_LOTTI_U30USD_2026-09-19.md
#  Pacchetto che questa misura sblocca:
#  report/COMPILAZIONE_771531_770511_2026-09-19.md
#
#  LA DOMANDA, ED E' UNA SOLA:
#      di quanti LOTTI cambia il volume piazzato, a parita' di segnale,
#      passando dal sizing del binario IN CAMPO (344a11b9) a quello dei
#      pin che stiamo per compilare (26a18566 e 872dba82)?
#  NON misura PF, NON misura DD, NON misura frequenza.
#
#  COME, E PERCHE' COSI':
#    - due EA di MISURA (ABTG_MIS_SIZING_EMA200, ABTG_MIS_SIZING_SWDOW).
#      Ognuno e' il .mq5 al pin COPIATO SENZA TOCCARE NIENTE, con in piu'
#      l'input InpSizingVecchio che sceglie il ramo di sizing;
#    - le due gambe del confronto girano quindi con LO STESSO BINARIO:
#      il segnale e' identico per COSTRUZIONE, non per speranza. Se il
#      numero di operazioni delle due gambe differisce, NON e' sizing:
#      e' un DIFETTO, e la tabella lo dice a caratteri cubitali;
#    - due DEPOSITI (100000 e 10000). Il difetto del pavimento scatta
#      SOLO dove il lotto e' piccolo: misurare a un deposito solo vuol
#      dire rischiare di certificare "nessuna differenza" proprio sul
#      caso in cui non ce n'e' (classe 178).
#
#  QUINDI: 2 EA x 2 depositi = QUATTRO chiamate al driver di round, e
#  ogni chiamata gira 2 celle x 2 finestre = 4 passate. 16 passate in
#  tutto.
#
#  COSA NON FA, ED E' UNA PROMESSA VERIFICABILE:
#    - NON tocca nessuna sedia, nessun preset, nessun .set, nessuna
#      taglia in campo. Non scrive NIENTE in nessuna cartella dati che
#      non sia quella del banco;
#    - NON chiude nessun terminale di persona: quel mestiere lo fa
#      RIGA_ROUND_VPS.ps1, che chiude SOLO C:\MT5_Backtest e stampa i
#      PID prima e dopo. Questo script quei PID li RILEGGE e si ferma
#      se e' sparito un terminale che non era il banco;
#    - NON giudica. Produce una tabella. Il verdetto si scrive dopo.
#
#  BERSAGLIO UNICO: banco da backtest C:\MT5_Backtest, demo 50504400.
#  VIETATI: 50503392 (piccolo), 50504263 (100k), 10105439 (REALE),
#  C:\MT5_MANUALE, Pepperstone, Tickmill.
#
#  ASCII PURO: niente emoji, niente accentate (PS 5.1 legge i .ps1 come
#  ANSI -- regola di casa del 17/08).
# =====================================================================

param(
  [Parameter(Mandatory=$true)][string]$Pin,
  [int]$TettoMinutiPerCorsa = 20,
  [switch]$SoloElenco
)

$ErrorActionPreference = 'Stop'
$INV = [Globalization.CultureInfo]::InvariantCulture
try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 } catch { }

$BANCO      = 'C:\MT5_Backtest'
$CONTO      = '50504400'
$VIETATI    = @('BCM Markets MT5 Terminal', 'BCM_Reale', 'MT5_MANUALE', 'Pepperstone', 'Tickmill')
$REPO_RAW   = 'https://raw.githubusercontent.com/claudiospadaro12/GITHUB'
$MARC_ROUND = 'MARCATORE_RIGA_ROUND_VPS_v1'

# EA | file prova | etichetta di base | magic dello strumento
$CORSE = @(
  [pscustomobject]@{ Ea='ABTG_MIS_SIZING_EMA200'; Prova='MIS_SIZING_EMA200_U30USD.txt'; Tag='MISEMA'; Magic='778411'; Sedia='771531 EMA200 Dow' },
  [pscustomobject]@{ Ea='ABTG_MIS_SIZING_SWDOW';  Prova='MIS_SIZING_SWDOW_U30USD.txt';  Tag='MISSW';  Magic='778412'; Sedia='770511 SuperWave DOW H1' }
)
$DEPOSITI = @(100000, 10000)

function Muori($msg) {
  Write-Host ''
  Write-Host '=====================================================================' -ForegroundColor Red
  Write-Host ('FERMO: ' + $msg) -ForegroundColor Red
  Write-Host '=====================================================================' -ForegroundColor Red
  exit 1
}

# ---------------------------------------------------------------------
# I NUMERI DEL CSV SONO SCRITTI COL PUNTO (DoubleToString di MQL5).
# Su un VPS in ITALIANO [double]"0.30" fa TRENTA. Quindi si passa
# SEMPRE da qui, mai da un cast nudo. E' la classe 3 della checklist,
# pagata il 17/08 di notte.
# ---------------------------------------------------------------------
function NumInv($s) {
  if($null -eq $s){ return 0.0 }
  $t = ([string]$s).Trim()
  if($t -eq ''){ return 0.0 }
  $v = 0.0
  if([double]::TryParse($t, [Globalization.NumberStyles]::Float, $INV, [ref]$v)){ return $v }
  return [double]::NaN
}

function Dec($v, $n) {
  if([double]::IsNaN($v)){ return 'n/d' }
  return $v.ToString('F' + $n.ToString($INV), $INV)
}

Write-Host '====================================================================='
Write-Host ' MISURA DEL DELTA LOTTI su U30USD -- 771531 (EMA200) e 770511 (SW DOW)'
Write-Host (' bersaglio : banco da backtest ' + $BANCO + ', demo ' + $CONTO)
Write-Host ' VIETATI   : 50503392 piccolo, 50504263 100k, 10105439 REALE,'
Write-Host '             C:\MT5_MANUALE, Pepperstone, Tickmill'
Write-Host (' pin       : ' + $Pin)
Write-Host (' tetto     : ' + $TettoMinutiPerCorsa.ToString($INV) + ' minuti PER CORSA, 4 corse')
Write-Host (' ora       : ' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss', $INV) + '  (ora locale del VPS)')
Write-Host '====================================================================='
Write-Host ''
Write-Host ' QUESTA CORSA NON GIUDICA NIENTE. Misura i LOTTI, e basta.'
Write-Host ' Non tocca nessuna sedia, nessun preset, nessuna taglia in campo.'
Write-Host ''

# =====================================================================
# PASSO 1 -- IL BANCO, e il rifiuto di tutto il resto
# =====================================================================
if(-not (Test-Path -LiteralPath $BANCO)){
  Muori ('non esiste ' + $BANCO + '. Il banco da backtest non e su questa macchina: la misura non si fa altrove, e men che meno su un terminale vivo.')
}
foreach($v in $VIETATI){
  if($BANCO -like ('*' + $v + '*')){
    Muori ('il percorso del banco contiene "' + $v + '": non e il banco. Non si tocca.')
  }
}
# LE DUE VARIABILI D'AMBIENTE SU CUI POGGIA TUTTO, controllate QUI e
# una volta sola. Se una e' vuota, ogni Join-Path che la usa esplode con
# "Cannot bind argument to parameter 'Path' because it is an empty
# string": un messaggio che non nomina ne' la variabile ne' questo
# script. Meglio morire subito e dicendo quale manca.
if([string]::IsNullOrWhiteSpace($env:USERPROFILE)){
  Muori 'la variabile d ambiente USERPROFILE e vuota: non so dove mettere la cartella di lavoro ne la raccolta. Non si parte.'
}
if([string]::IsNullOrWhiteSpace($env:APPDATA)){
  Muori 'la variabile d ambiente APPDATA e vuota: non so dove sta la cartella comune di MetaQuotes, che e da dove si leggono i file per-trade. Non si parte.'
}

$med = Join-Path $BANCO 'metaeditor64.exe'
if(-not (Test-Path -LiteralPath $med)){
  Muori ('manca ' + $med + '. Senza compilatore gli EA di misura non si compilano e la corsa morirebbe con ZERO CSV.')
}
Write-Host ('[1/5] banco trovato: ' + $BANCO) -ForegroundColor Green

# =====================================================================
# PASSO 2 -- LA FOTOGRAFIA DEI TERMINALI, PRIMA
#            Si LEGGE e basta: qui dentro non si termina nessun
#            processo. Serve a poter dire DOPO, con un fatto e non con
#            una speranza, che non e' sparito niente che non fosse il
#            banco.
# =====================================================================
$prima = @(Get-Process terminal64 -ErrorAction SilentlyContinue | Select-Object Id, Path)
$nonBanco = @($prima | Where-Object { $_.Path -and ($_.Path -notlike ($BANCO + '\*')) })
Write-Host ('[2/5] terminali vivi adesso: ' + $prima.Count.ToString($INV) + ', di cui NON del banco: ' + $nonBanco.Count.ToString($INV)) -ForegroundColor Green
foreach($t in $nonBanco){ Write-Host ('      da NON toccare: PID ' + $t.Id.ToString($INV) + '  ' + $t.Path) }

# =====================================================================
# PASSO 3 -- IL DRIVER DI ROUND, dal pin e col suo marcatore
# =====================================================================
$work = Join-Path $env:USERPROFILE 'abtg_misura'
[void](New-Item -ItemType Directory -Force -Path $work)
$drv = Join-Path $work 'RIGA_ROUND_VPS.ps1'
Remove-Item -LiteralPath $drv -Force -ErrorAction SilentlyContinue
$urlDrv = $REPO_RAW + '/' + $Pin + '/backtest_pipeline/righe/RIGA_ROUND_VPS.ps1'
try {
  Invoke-WebRequest -Uri $urlDrv -OutFile $drv -UseBasicParsing
} catch {
  Muori ('non sono riuscito a scaricare il driver di round da ' + $urlDrv + ' -- ' + $_.Exception.Message)
}
if(-not (Select-String -Path $drv -SimpleMatch -Pattern $MARC_ROUND -Quiet)){
  Muori ('il driver scaricato non ha il marcatore ' + $MARC_ROUND + ': e una copia vecchia. Non si prosegue.')
}
Write-Host ('[3/5] driver di round scaricato e verificato (' + $MARC_ROUND + ')') -ForegroundColor Green

$comune = Join-Path $env:APPDATA 'MetaQuotes\Terminal\Common\Files'

# ---------------------------------------------------------------------
# IL DESKTOP NON SI DA' PER PRESENTE.
# GetFolderPath('Desktop') puo' tornare STRINGA VUOTA (profilo anomalo,
# cartelle reindirizzate, sessione di servizio). Se succede, il primo
# Join-Path esplode con "Cannot bind argument to parameter 'Path'
# because it is an empty string": un messaggio che non nomina ne' il
# Desktop ne' questo script, e che arriva DOPO aver gia' fatto il
# lavoro. Quindi: ripiego, e se anche quello manca si muore SUBITO e
# dicendo perche'. Trovato dal giro a vuoto, non in produzione.
# ---------------------------------------------------------------------
$dsk = [Environment]::GetFolderPath('Desktop')
if([string]::IsNullOrWhiteSpace($dsk) -and -not [string]::IsNullOrWhiteSpace($env:USERPROFILE)){
  $dsk = Join-Path $env:USERPROFILE 'Desktop'
  if(-not (Test-Path -LiteralPath $dsk)){ $dsk = $env:USERPROFILE }
}
if([string]::IsNullOrWhiteSpace($dsk)){
  Muori 'non riesco a trovare una cartella dove scrivere la raccolta: ne il Desktop ne USERPROFILE sono leggibili. Senza posto dove posare i risultati la corsa non si avvia nemmeno.'
}

$stamp  = (Get-Date).ToString('yyyy-MM-dd_HHmmss', $INV)
$racc   = Join-Path $dsk ('MISURA_LOTTI_U30USD_' + $stamp)
[void](New-Item -ItemType Directory -Force -Path $racc)

if($SoloElenco){
  Write-Host ''
  Write-Host 'GIRO A VUOTO (-SoloElenco): ecco le quattro corse che FAREI, e non ne faccio nessuna.' -ForegroundColor Yellow
  foreach($c in $CORSE){ foreach($d in $DEPOSITI){
    Write-Host ('   ' + $c.Ea.PadRight(24) + ' prova=' + $c.Prova.PadRight(30) + ' deposito=' + $d.ToString($INV).PadLeft(7) + '  etichetta=' + $c.Tag + $d.ToString($INV))
  }}
  Write-Host ('   raccolta: ' + $racc)
  Write-Host ('   cartella comune letta: ' + $comune)
  exit 0
}

# =====================================================================
# PASSO 4 -- LE QUATTRO CORSE
# =====================================================================
Write-Host ('[4/5] quattro corse. Raccolta in: ' + $racc) -ForegroundColor Green
$righeTab = @()
$fatte = 0
$rilievi = @()

foreach($c in $CORSE){
  foreach($dep in $DEPOSITI){
    $et = $c.Tag + $dep.ToString($INV)
    Write-Host ''
    Write-Host ('--- CORSA ' + $et + ' : ' + $c.Ea + ' deposito ' + $dep.ToString($INV) + ' ---') -ForegroundColor Cyan

    # LA PULIZIA PRIMA, e non e' pignoleria: un file per-trade rimasto
    # da una corsa precedente verrebbe letto come se fosse di questa
    # (classe 23, l'artefatto scaduto che il passo dopo mangia senza
    # guardare la data). Si cancella PRIMA, cosi' cio' che si trova
    # DOPO puo' solo essere di adesso.
    $vecchi = @(Get-ChildItem -LiteralPath $comune -Filter ('abtg_mis_' + $c.Ea + '_*.csv') -File -ErrorAction SilentlyContinue)
    foreach($v in $vecchi){ Remove-Item -LiteralPath $v.FullName -Force -ErrorAction SilentlyContinue }
    if($vecchi.Count -gt 0){ Write-Host ('    ripuliti ' + $vecchi.Count.ToString($INV) + ' file per-trade di corse precedenti') -ForegroundColor DarkGray }

    $t0 = Get-Date
    $a = @('-NoProfile','-ExecutionPolicy','Bypass','-File',('"' + $drv + '"'),
           '-Expert',$c.Ea,'-Prova',$c.Prova,'-Etichetta',$et,'-Pin',$Pin,
           '-TerminaleBacktest',$BANCO,'-Modello','4','-Deposito',$dep.ToString($INV),'-ChiudiBacktest')
    $pr = Start-Process powershell -ArgumentList $a -NoNewWindow -PassThru
    if(-not $pr.WaitForExit($TettoMinutiPerCorsa * 60 * 1000)){
      Write-Host ('    TETTO DI ' + $TettoMinutiPerCorsa.ToString($INV) + ' MINUTI SFONDATO su ' + $et + ': fermo QUESTA corsa.') -ForegroundColor Red
      Write-Host '    E UN RISULTATO, NON UN GUASTO: quella gamba resta NON MISURATA e si va avanti.' -ForegroundColor Red
      $rilievi += ($et + ': tetto di ' + $TettoMinutiPerCorsa.ToString($INV) + ' minuti sfondato, gamba NON MISURATA')
      try { Stop-Process -Id $pr.Id -Force -ErrorAction SilentlyContinue } catch { }
      # si chiude SOLO cio' che sta sotto il percorso del banco: filtro
      # su una COSTANTE, mai su una variabile che arriva da fuori.
      Get-Process metatester64,terminal64 -ErrorAction SilentlyContinue |
        Where-Object { $_.Path -and ($_.Path -like ($BANCO + '\*')) } |
        Stop-Process -Force -ErrorAction SilentlyContinue
      try { $pr.WaitForExit() } catch { }
    }
    $rc = $pr.ExitCode
    if($null -eq $rc){ $rc = -1 }
    Write-Host ('    codice del driver: ' + $rc.ToString($INV) + '   (0=girato  2=non misurato  3=girato con rilievi)')

    # LA RACCOLTA: si prendono SOLO i file scritti DOPO l'avvio di
    # QUESTA corsa. La data, non il nome (la pulizia di prima gia'
    # basterebbe: questo e' il secondo giro di chiave).
    $nuovi = @(Get-ChildItem -LiteralPath $comune -Filter ('abtg_mis_' + $c.Ea + '_*.csv') -File -ErrorAction SilentlyContinue |
               Where-Object { $_.LastWriteTime -ge $t0 })
    if($nuovi.Count -eq 0){
      Write-Host ('    NESSUN file per-trade prodotto da ' + $et + '. Questa gamba e NON MISURATA.') -ForegroundColor Red
      $rilievi += ($et + ': zero file per-trade (EA non compilato, zero operazioni, o corsa non partita)')
    }
    foreach($f in $nuovi){
      Copy-Item -LiteralPath $f.FullName -Destination (Join-Path $racc $f.Name) -Force
      # aggregazione: una riga per file
      $righe = @(Import-Csv -LiteralPath $f.FullName -Delimiter ';')
      $tot = 0.0; $primo = [double]::NaN; $pos = @{}
      foreach($r in $righe){
        $v = NumInv $r.volume
        if([double]::IsNaN($v)){ continue }
        $tot += $v
        if([double]::IsNaN($primo)){ $primo = $v }
        $pid2 = [string]$r.position_id
        if($pos.ContainsKey($pid2)){ $pos[$pid2] = $pos[$pid2] + $v } else { $pos[$pid2] = $v }
      }
      $ramo = 'SIZNEW'; if($f.Name -like '*_SIZOLD_*'){ $ramo = 'SIZOLD' }
      $righeTab += [pscustomobject]@{
        Ea=$c.Ea; Sedia=$c.Sedia; Etichetta=$et; Deposito=$dep; Ramo=$ramo
        File=$f.Name; Deal=$righe.Count; Posizioni=$pos.Keys.Count
        VolTot=$tot; VolPrimo=$primo
      }
      Write-Host ('    raccolto ' + $f.Name + '  deal=' + $righe.Count.ToString($INV) + '  posizioni=' + $pos.Keys.Count.ToString($INV) + '  volume totale=' + (Dec $tot 2)) -ForegroundColor Green
    }
    $fatte++
  }
}

# =====================================================================
# PASSO 5 -- LA TABELLA, e il controllo che non e' un dettaglio
# =====================================================================
$dopo = @(Get-Process terminal64 -ErrorAction SilentlyContinue | Select-Object Id, Path)
$persi = @($nonBanco | Where-Object { $dopo.Id -notcontains $_.Id })

$R = New-Object System.Collections.ArrayList
function W($t){ [void]$R.Add($t); Write-Host $t }

W ''
W '====================================================================='
W ' MISURA DEL DELTA LOTTI -- U30USD H1'
W ('data: ' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss', $INV) + '   <-- SE NON E DI OGGI, STAI LEGGENDO UN FILE VECCHIO')
W ('pin : ' + $Pin)
W '====================================================================='
W ''
W 'QUESTA TABELLA NON GIUDICA. Dice quanti lotti piazzano le due gambe.'
W 'SIZOLD = il sizing del binario che gira ADESSO in campo (344a11b9).'
W 'SIZNEW = il sizing dei pin che si vogliono compilare.'
W ''

if($persi.Count -gt 0){
  W 'ALLARME: sono spariti terminali che NON erano il banco. Controlla subito:'
  foreach($p in $persi){ W ('   PID ' + $p.Id.ToString($INV) + '  ' + $p.Path) }
  W ''
} else {
  W ('OK: i ' + $nonBanco.Count.ToString($INV) + ' terminali NON di banco sono ancora vivi, stessi PID di prima.')
  W ''
}

foreach($c in $CORSE){
  foreach($dep in $DEPOSITI){
    $g = @($righeTab | Where-Object { $_.Ea -eq $c.Ea -and $_.Deposito -eq $dep })
    W ('--- ' + $c.Sedia + '   deposito ' + $dep.ToString($INV) + ' ---')
    if($g.Count -eq 0){ W '    NON MISURATA: nessun file per-trade.'; W ''; continue }
    $old = @($g | Where-Object { $_.Ramo -eq 'SIZOLD' })
    $new = @($g | Where-Object { $_.Ramo -eq 'SIZNEW' })
    $vo = 0.0; foreach($x in $old){ $vo += $x.VolTot }
    $vn = 0.0; foreach($x in $new){ $vn += $x.VolTot }
    $do2 = 0;  foreach($x in $old){ $do2 += $x.Deal }
    $dn = 0;   foreach($x in $new){ $dn += $x.Deal }
    $po = 0;   foreach($x in $old){ $po += $x.Posizioni }
    $pn = 0;   foreach($x in $new){ $pn += $x.Posizioni }
    W ('    SIZOLD  volume totale ' + (Dec $vo 2).PadLeft(10) + '   deal ' + $do2.ToString($INV).PadLeft(5) + '   posizioni ' + $po.ToString($INV).PadLeft(5))
    W ('    SIZNEW  volume totale ' + (Dec $vn 2).PadLeft(10) + '   deal ' + $dn.ToString($INV).PadLeft(5) + '   posizioni ' + $pn.ToString($INV).PadLeft(5))
    if($vo -gt 0){
      $rap = $vn / $vo
      W ('    DELTA   SIZNEW / SIZOLD = ' + (Dec $rap 4) + '   (1.0000 = nessuna differenza)')
    } else {
      W '    DELTA   non calcolabile: SIZOLD ha volume totale zero.'
    }
    if($do2 -ne $dn){
      W ''
      W '    >>> ATTENZIONE, E NON E UN DETTAGLIO: le due gambe hanno un NUMERO'
      W '        DI OPERAZIONI DIVERSO. Il binario e lo stesso e l unica cosa che'
      W '        cambia e il sizing, quindi il segnale DOVEVA essere identico.'
      W '        Questo NON e un effetto del sizing: e un DIFETTO, e la misura'
      W '        del delta lotti qui sopra NON e valida finche non si spiega.'
      $rilievi += ($c.Sedia + ' dep ' + $dep.ToString($INV) + ': deal SIZOLD=' + $do2.ToString($INV) + ' contro SIZNEW=' + $dn.ToString($INV))
    }
    W ''
  }
}

W 'DETTAGLIO, file per file (il primo volume e quello a bilanci ANCORA IDENTICI):'
foreach($r in $righeTab){
  W ('   ' + $r.Ramo + '  dep ' + $r.Deposito.ToString($INV).PadLeft(7) + '  deal ' + $r.Deal.ToString($INV).PadLeft(5) +
     '  vol.tot ' + (Dec $r.VolTot 2).PadLeft(10) + '  1o vol ' + (Dec $r.VolPrimo 2).PadLeft(7) + '  ' + $r.File)
}
W ''
W 'COME SI LEGGE, e i limiti sono dichiarati PRIMA dei numeri:'
W '  - il confronto e ESATTO solo sulla PRIMA operazione: li i due bilanci'
W '    sono identici per costruzione. Dopo la prima operazione che differisce'
W '    i bilanci divergono, e il lotto si calcola sul bilancio: il volume'
W '    totale e un effetto CUMULATIVO, non un rapporto istantaneo;'
W '  - IS e OOS sono due campioni della STESSA configurazione, cioe DUE'
W '    REPLICHE della stessa misura su finestre che non si sovrappongono;'
W '  - il per-trade esporta i deal in USCITA: su SuperWave una posizione puo'
W '    chiudersi in piu deal (parziale al 50%), quindi il volume di una'
W '    posizione e la SOMMA dei suoi deal (classe 454).'
W ''
W ('RILIEVI: ' + $rilievi.Count.ToString($INV))
foreach($x in $rilievi){ W ('   - ' + $x) }
W ''
W ('corse fatte: ' + $fatte.ToString($INV) + ' su 4')

$ref = Join-Path $racc 'REFERTO_MISURA_LOTTI.txt'
($R -join "`r`n") | Set-Content -LiteralPath $ref -Encoding ASCII

$zip = Join-Path $dsk ('MISURA_LOTTI_U30USD_' + $stamp + '.zip')
if(Test-Path -LiteralPath $zip){ Remove-Item -LiteralPath $zip -Force }
Compress-Archive -Path (Join-Path $racc '*') -DestinationPath $zip -Force

Write-Host ''
Write-Host ('[5/5] RACCOLTA: ' + $racc) -ForegroundColor Green
Write-Host ('      ZIP PRONTO DA MANDARE: ' + $zip) -ForegroundColor Green
Write-Host '      FILE ATTESI NELLA CARTELLA:'
Write-Host '         REFERTO_MISURA_LOTTI.txt   (leggi la riga data: DEVE essere di oggi)'
Write-Host '         abtg_mis_*.csv             (attesi 8: 2 EA x 2 depositi x 2 rami)'
Get-ChildItem -LiteralPath $racc -ErrorAction SilentlyContinue | Select-Object Name, Length, LastWriteTime | Format-Table -AutoSize

if($persi.Count -gt 0){ exit 2 }
if($rilievi.Count -gt 0){ exit 3 }
if($righeTab.Count -eq 0){ exit 2 }
exit 0
