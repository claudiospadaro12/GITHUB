# =====================================================================
#  MARCATORE_NATCLA_DIAG_U30_v1
#  NATCLA_DIAG_U30.ps1 -- DIAGNOSI DEL KO U30USD DEL PILOTA F0 DI 'Ea Nat&Cla'
#
#  CHE COSA FA, e una cosa sola:
#    lancia 6 passate SINGOLE del tester (Optimization=0, Model=1 = OHLC su M1)
#    dell'EA diagnostico mql5/Experts/EA_NatCla_Diag.mq5 (SOLA LETTURA: nessun
#    ordine, nessun file, nessuna CTrade; fuori dal tester rifiuta di partire)
#    e raccoglie dal log dell'agente la sua UNICA riga riassuntiva
#    '[NatCla-DIAG] RIASSUNTO k=v ...', le righe di transizione
#    '[NatCla-DIAG-EV]', la riga '[NatCla-DIAG-AVVIO]' e le righe del tester
#    che parlano del simbolo o di un guasto. Mette tutto in un zip sul Desktop.
#    NON giudica: dice, per ogni passata, quante barre la CATENA di
#    CaricaDati() (EA_NatCla r.1262-1280) avrebbe chiuso su ognuna delle
#    quattro condizioni (r.1266 n<300, r.1267 BarsCalculated, r.1270
#    CopyRates, r.1274-1276 CopyBuffer) e quando passano TUTTE la prima volta.
#
#  LE 6 PASSATE (fisse, scritte qui: nessun file prova, nessuna lista doppia):
#    (a) U30USD H1 dal 2024.09.26 -- riproduce il KO del pilota (stessa finestra)
#    (b) U30USD H1 dal 2025.01.02 -- ~3 mesi di storia BCM PRIMA di FromDate
#    (c) D30EUR H1 dal 2024.09.26 -- secondo indice, stessa storia dal 2024.09.26
#    (d) EURUSD H1 dal 2024.09.26 -- CONTROLLO POSITIVO (forex, storia prima di FromDate)
#    (e) U30USD H1 dal 2024.09.26 -- come (a) ma InpVerificheSeparate=false: SOLO la
#        catena = EA_NatCla alla lettera (la passata FEDELE, classe 1171)
#    (f) D30EUR H1 dal 2024.09.26 -- come (c), SOLO la catena
#    tutte fino al 2026.06.30. Input dell'EA = quelli del file prova F0
#    (NATCLA_F0_conteggio_2026-10-07.txt r.157-161, 176, 178): EMA 200, EMA14/89
#    creati, contesto si, ATR 14, ADX 14 iADX MetaQuotes; TF H1 (16385).
#    (a)-(d) con InpVerificheSeparate=true, (e)-(f) con false. PERCHE' (classe 1171,
#    cancello 07/10): nel tester gli indicatori si calcolano SOLO quando si chiede
#    un buffer (manuale MQL5, 'The Calculation of Indicators During Testing'); le
#    verifiche separate chiamano CopyBuffer anche quando la catena si ferma, e
#    quindi potrebbero GUARIRE proprio il guasto da misurare. La passata fedele
#    gira nello STESSO giro, non in un secondo.
#
#  DERIVATO DA NATCLA_F0_PASSATE.ps1 (pin e2f0506b, NON toccato), stesse guardie.
#  DEVIAZIONI, tutte dichiarate:
#   1. 6 passate fisse invece dei lotti del file prova; nessun CSV di setup.
#   2. UN solo sorgente scaricato (l'EA diagnostico non ha include) e
#      controllato per SHA256 PASSATO DALLA RIGA (-ShaEA, calcolato dal commit)
#      e per NCD_VER 1.00.
#   3. Compilazione con le tre correzioni proposte dalla lettura del pilota
#      (par. 7): (i) se il vecchio .ex5 non si cancella ci si ferma (un compilato
#      vecchio passerebbe per nuovo); (ii) si aspetta che MetaEditor esca prima
#      di leggere il log; (iii) la riga del risultato si legge in inglese E in
#      italiano, anche al singolare ('errors/errori/errore', 'warnings/avvisi/avviso',
#      classe 1168).
#   4. Si tengono le righe d'errore dell'EA e del terminale ('critical',
#      'array out of range', 'zero divide', ...) e le righe del tester sul
#      simbolo: il pilota le aveva buttate, ed e' per questo che il KO non si
#      e' potuto spiegare.
#   5. Mutex: lo STESSO del driver F0 ('Global\ABTG_NATCLA_F0'), apposta: la
#      diagnosi e un lotto F0 non devono mai girare insieme su questo PC.
#   6. La finestra girata letta dal giornale e' SOLO informativa (nel pilota la
#      regex non ha mai trovato la riga): lo stato della passata non ne dipende.
#  INVARIATI: guardia macchina DESKTOP-H4D7CAJ, tutti gli MT5 e MetaEditor
#  chiusi (le due installazioni censite il 05/10 ammesse PER NOME, classe 1157),
#  nessuna installazione non censita, cartella dati risolta per origin.txt,
#  nessun EA sui grafici salvati del terminale BCM, AllowLiveTrading=false,
#  TLS 1.2 impostato QUI DENTRO (classe 1156), fotografia dei log prima di ogni
#  passata e lettura della sola coda, timeout per passata con CloseMainWindow
#  (MAI Stop-Process sul terminale), zip/cartella vecchi rinominati, mai cancellati.
#
#  E' UN BACKTEST, NON UN ORDINE. [Experts] AllowLiveTrading=false nel .ini, e
#  l'EA diagnostico non contiene nessuna funzione d'ordine: il terminale del PC
#  di backtest e' loggato sul DEMO 50503392 e il 14/08/2026 da questa macchina
#  sono partiti ordini VERI.
#
#  NON TOCCA, per nome: PRIMA SU QUESTO PC le installazioni C:\MT5_Backtest
#  (cartella dati 04C7A32B) e C:\FundedNext_Manuale (cartella dati 2B8180C3);
#  POI il VPS VMI3047753 e TUTTE le sue cartelle dati (FTMO 541452707 in
#  C:\FTMO, trial 1514806751, REALE 10105439 in C:\BCM_Reale, 100k 50504263,
#  piccolo 50503392 sul VPS, manuale 50503635 in C:\MT5_MANUALE, banco
#  50504400 in C:\MT5_Backtest, Pepperstone, Tickmill). NON tocca EA_NatCla.mq5
#  ne' il suo .ex5. Scrive SOLO: la cartella %USERPROFILE%\abtg_passata,
#  MQL5\Experts\EA_NatCla_Diag.mq5/.ex5 del terminale BCM di questa macchina,
#  il Desktop (cartella e zip NATCLA_DIAG_U30).
#  NON legge ne' scrive conti, ordini, posizioni, preset di nessuna sedia.
#  NON tocca CODA.txt ne' il runner notturno (che gira sul VPS).
#
#  NIENTE EMOJI QUI DENTRO (regola del 17/08): Windows PowerShell 5.1 legge i
#  .ps1 come ANSI e un'emoji dentro una stringa rompe il parser.
# =====================================================================
[CmdletBinding()]
param(
  [Parameter(Mandatory=$true)][string]$Pin,
  [Parameter(Mandatory=$true)][string]$ShaEA,
  [int]$TimeoutRunMin = 20
)

$ErrorActionPreference = 'Stop'
$IC = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentCulture   = $IC
[Threading.Thread]::CurrentThread.CurrentUICulture = $IC
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

$EXPERT = 'EA_NatCla_Diag'
$VERSIONE_ATTESA = '1.00'
$DATA_A = '2026.06.30'
$TETTO_MIN = 40
$NOME = 'NATCLA_DIAG_U30'
if($Pin -notmatch '^[0-9a-fA-F]{40}$'){ throw '-Pin obbligatorio e di 40 caratteri esadecimali: senza, girerebbe la punta del branch spacciandola per un commit congelato.' }
$Pin = $Pin.ToLower()
if($ShaEA -notmatch '^[0-9a-fA-F]{64}$'){ throw '-ShaEA deve essere di 64 caratteri esadecimali (SHA256 calcolato dal commit, mai dal disco).' }
$ShaEA = $ShaEA.ToUpper()
if($TimeoutRunMin -lt 1 -or $TimeoutRunMin -gt 60){ throw '-TimeoutRunMin fuori da 1-60 minuti.' }
$RAW = 'https://raw.githubusercontent.com/claudiospadaro12/GITHUB/' + $Pin + '/'

# le 6 passate: (a) riproduce il KO, (b) storia davanti, (c) secondo indice, (d) controllo positivo, (e)(f) = (a)(c) con SOLO la catena (EA_NatCla alla lettera)
$Passate = @(
  [pscustomobject]@{ Id = 'a'; Sim = 'U30USD'; Da = '2024.09.26'; Sep = 'true'; Ruolo = 'riproduce il KO del pilota (stessa finestra), con verifiche separate' },
  [pscustomobject]@{ Id = 'b'; Sim = 'U30USD'; Da = '2025.01.02'; Sep = 'true'; Ruolo = 'circa 3 mesi di storia BCM prima di FromDate' },
  [pscustomobject]@{ Id = 'c'; Sim = 'D30EUR'; Da = '2024.09.26'; Sep = 'true'; Ruolo = 'secondo indice, storia BCM dal 2024.09.26' },
  [pscustomobject]@{ Id = 'd'; Sim = 'EURUSD'; Da = '2024.09.26'; Sep = 'true'; Ruolo = 'CONTROLLO POSITIVO: forex con storia prima di FromDate' },
  [pscustomobject]@{ Id = 'e'; Sim = 'U30USD'; Da = '2024.09.26'; Sep = 'false'; Ruolo = 'come (a) ma SOLO la catena: EA_NatCla alla lettera (passata FEDELE, classe 1171)' },
  [pscustomobject]@{ Id = 'f'; Sim = 'D30EUR'; Da = '2024.09.26'; Sep = 'false'; Ruolo = 'come (c) ma SOLO la catena: EA_NatCla alla lettera' }
)
# gli input dell'EA diagnostico = quelli del file prova F0 (r.157-161, 176, 178) + InpMaxEventi; InpVerificheSeparate si aggiunge PER PASSATA (campo Sep)
$Ingressi = @('InpTF=16385', 'InpEmaLentaPeriodo=200', 'InpEmaTp1=14', 'InpEmaTp2=89', 'InpLogContesto=true', 'InpAtrNormPeriodo=14', 'InpAdxPeriodo=14', 'InpAdxTipo=0', 'InpMaxEventi=20')
# le chiavi della riga RIASSUNTO, nell'ordine delle colonne di DIAG_RIASSUNTO.csv (il collaudo le confronta con quelle che l'EA stampa)
$CHIAVI = @('v','sym','tf','adx','sep','motivo_deinit','tick','tick_t0zero','nuove','prima','ultima','cd_ok','cd_n','cd_bc','cd_cr','cd_cb','primo_ok','primo_ok_barre','cade_n','cade_bc','cade_bc_k','cade_cr','cade_cb','cade_cb_k','copia_saltata','incoerenze','max_barre','min_bc','max_bc','i0_first','i0_tfirst','i0_count','u_first','u_tfirst','maxbars_term','i0_barre','i0_n','i0_bc','i0_cr','i0_cb','u_barre','u_n','u_bc','u_cr','u_cb','ok_barre','ok_n','ok_bc','ok_cr','ok_cb','eventi','fine')

function Dico($t,$c='Gray'){ Write-Host ('   ' + $t) -ForegroundColor $c }
function Titolo($t){ Write-Host ''; Write-Host ('=== ' + $t + ' ===') -ForegroundColor Cyan }
function Scarica($rel, $dest, $firma){
  Remove-Item -LiteralPath $dest -Force -ErrorAction SilentlyContinue
  Invoke-RestMethod -Uri ($RAW + $rel + '?cb=' + [Guid]::NewGuid().ToString('N')) -OutFile $dest
  if(-not (Select-String -LiteralPath $dest -SimpleMatch -Pattern $firma -Quiet)){
    throw ($rel + ' scaricato ma NON contiene "' + $firma + '": copia sbagliata o cache di GitHub. Non si parte.')
  }
}
function Leggi-Condiviso($path){
  $b = $null
  try{
    $path = (Convert-Path -LiteralPath $path)
    $fs = [IO.File]::Open($path, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
    $b  = New-Object byte[] $fs.Length
    [void]$fs.Read($b, 0, $b.Length)
    $fs.Close()
  } catch { return '' }
  if($null -eq $b -or $b.Count -lt 2){ return '' }
  if($b[0] -eq 0xFF -and $b[1] -eq 0xFE){ return ([Text.Encoding]::Unicode.GetString($b)).TrimStart([char]0xFEFF) }
  $zeri = 0; $nb = [math]::Min(400, $b.Count)
  for($i = 1; $i -lt $nb; $i += 2){ if($b[$i] -eq 0){ $zeri++ } }
  if($zeri -gt ($nb / 4)){ return ([Text.Encoding]::Unicode.GetString($b)).TrimStart([char]0xFEFF) }
  return ([Text.Encoding]::UTF8.GetString($b)).TrimStart([char]0xFEFF)
}

# ---------------------------------------------------------------------
#  0. LA MACCHINA E IL TERMINALE. Fail-closed, come NATCLA_F0_PASSATE.
# ---------------------------------------------------------------------
Titolo '0 - MACCHINA E TERMINALE'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){
  throw ('NATCLA_DIAG_U30 gira SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui la macchina si chiama: ' + $env:COMPUTERNAME + '. Sul VPS VMI3047753 non si lancia: la challenge FTMO sta operando (firma del 21/09/2026: i round girano sul PC di backtest).')
}
Dico ('pc   : ' + $env:COMPUTERNAME) 'Green'
Dico ('pin  : ' + $Pin) 'Green'
$Mutex = New-Object System.Threading.Mutex($false, 'Global\ABTG_NATCLA_F0')
$preso = $false
# un giro precedente interrotto lascia il blocco ABBANDONATO: .NET lo segnala con un'eccezione e il blocco e comunque nostro
try{ $preso = $Mutex.WaitOne(0) } catch [System.Threading.AbandonedMutexException] { $preso = $true; Dico 'il blocco Global\ABTG_NATCLA_F0 era stato lasciato da un giro INTERROTTO: lo riprendo (nessun altro giro sta girando)' 'Yellow' }
if(-not $preso){
  throw 'Un ALTRO giro NATCLA (lotto F0 o diagnosi) sta gia girando su questo PC (mutex Global\ABTG_NATCLA_F0 occupato). Un solo giro alla volta: aspetta che finisca, NON chiudere il suo terminale.'
}
if((@(Get-Process -Name terminal64, metaeditor64 -ErrorAction SilentlyContinue)).Count -gt 0){
  throw 'MT5 O METAEDITOR risulta APERTO su questo PC. Ogni passata ne apre una copia sua con /config: col terminale gia aperto il tester non parte. GUARDA I GRAFICI (sedie attaccate?), chiudilo A MANO e rilancia.'
}

$InstAttesa = 'C:\Program Files\BCM Markets MT5 Terminal'
$Terminal   = Join-Path $InstAttesa 'terminal64.exe'
$MetaEditor = Join-Path $InstAttesa 'metaeditor64.exe'
if(-not (Test-Path -LiteralPath $Terminal)){
  throw ('terminale non trovato dove la passata lo aspetta: ' + $Terminal + '. Non si cerca altrove apposta.')
}
$DataRoot = Join-Path $env:APPDATA 'MetaQuotes\Terminal'
$origini = @()
foreach($d in @(Get-ChildItem -Path $DataRoot -Directory -ErrorAction SilentlyContinue)){
  $o = Join-Path $d.FullName 'origin.txt'
  if(Test-Path -LiteralPath $o){
    $v = (Leggi-Condiviso $o).Trim()
    if($v -ne ''){ $origini = $origini + @([pscustomobject]@{ Dir = $d.FullName; Inst = $v }) }
  }
}
# le ALTRE installazioni MT5 di questo PC, censite il 05/10/2026 (REFERTO_DUKA_P0.txt sez. 5): AMMESSE PER NOME, chiuse e non toccate
$Censite = @('C:\MT5_Backtest', 'C:\FundedNext_Manuale')
$diversi = @($origini | Where-Object { $_.Inst -ne $InstAttesa })
$ignote = @($diversi | Where-Object { $Censite -notcontains $_.Inst.TrimEnd('\') })
foreach($dv in @($diversi | Where-Object { $Censite -contains $_.Inst.TrimEnd('\') })){ Dico ('altra installazione di questo PC, censita il 05/10, CHIUSA e NON TOCCATA: ' + $dv.Inst + '  (cartella dati ' + (Split-Path -Leaf $dv.Dir) + ')') 'Yellow' }
if($ignote.Count -gt 0){
  Write-Host '   ATTENZIONE: su questa macchina hanno girato installazioni MT5 NON censite:' -ForegroundColor Red
  foreach($dv in $ignote){ Write-Host ('     ' + $dv.Inst) -ForegroundColor Red }
  throw 'Il giro si ferma: oltre al BCM e alle due censite il 05/10 (C:\MT5_Backtest, C:\FundedNext_Manuale) qui ci sono ALTRE installazioni MT5 (regola dei terminali multipli).'
}
$cands = @($origini | Where-Object { $_.Inst -eq $InstAttesa })
if($cands.Count -ne 1){
  throw ('cartella dati NON risolta in modo univoco: trovate ' + $cands.Count + ' candidate per ' + $InstAttesa + '. Il giro si ferma invece di indovinare.')
}
$DataFolder = $cands[0].Dir
# nessun EA sui grafici salvati: ogni passata apre il terminale col suo profilo
$chrRoot = Join-Path (Join-Path (Join-Path $DataFolder 'MQL5') 'Profiles') 'Charts'
$nChr = 0; $conEA = @()
if(Test-Path -LiteralPath $chrRoot){
  foreach($fc in @(Get-ChildItem -LiteralPath $chrRoot -Recurse -File -Filter '*.chr' -ErrorAction SilentlyContinue)){
    $nChr = $nChr + 1
    $tx = Leggi-Condiviso $fc.FullName
    if(-not $tx){ $conEA = $conEA + @($fc.Directory.Name + '\' + $fc.Name + '  ILLEGGIBILE: non verificabile, conta come EA attaccato'); continue }
    if($tx -match '<expert>'){ $conEA = $conEA + @($fc.Directory.Name + '\' + $fc.Name + '  EA ATTACCATO') }
  }
}
if($nChr -le 0){ throw ('ho letto ZERO grafici salvati sotto ' + $chrRoot + ': una guardia che non legge niente non ha verificato niente. Non si parte.') }
if($conEA.Count -gt 0){ throw ('SEDIE ATTACCATE ai grafici salvati del terminale BCM (' + ($conEA -join '; ') + '). Staccale prima: aprire il terminale col profilo le rimetterebbe in marcia (demo 50503392, 14/08/2026).') }
$MqlExp = Join-Path (Join-Path $DataFolder 'MQL5') 'Experts'
New-Item -ItemType Directory -Force -Path $MqlExp | Out-Null
Dico ('terminale: ' + $Terminal) 'Green'
Dico ('dati     : ' + $DataFolder) 'Green'
Dico ('grafici salvati letti: ' + $nChr + ', nessun EA attaccato') 'Green'

# ---------------------------------------------------------------------
#  1. EA DIAGNOSTICO AL PIN (SHA256 dalla riga) E COMPILAZIONE VERIFICATA
# ---------------------------------------------------------------------
Titolo '1 - SORGENTE AL PIN E COMPILAZIONE'
$Work = Join-Path $env:USERPROFILE 'abtg_passata'
New-Item -ItemType Directory -Force -Path $Work | Out-Null
$srcEA = Join-Path $Work ($EXPERT + '.mq5')
Scarica ('mql5/Experts/' + $EXPERT + '.mq5') $srcEA 'NCD_VER'
$hh = (Get-FileHash -LiteralPath $srcEA -Algorithm SHA256).Hash
if($hh -ne $ShaEA){ throw ($EXPERT + '.mq5 scaricato al pin ha SHA256 ' + $hh + ' invece di ' + $ShaEA + ' (quello calcolato dal commit): copia sbagliata o cache di GitHub. Non si parte.') }
Dico ($EXPERT + '.mq5: SHA256 ' + $hh.Substring(0,12) + ' = quello della riga') 'Green'
if(-not (Select-String -LiteralPath $srcEA -SimpleMatch -Pattern ('#define NCD_VER "' + $VERSIONE_ATTESA + '"') -Quiet)){ throw ('il sorgente dell EA diagnostico non dichiara NCD_VER ' + $VERSIONE_ATTESA + '. Non si parte.') }
Copy-Item -LiteralPath $srcEA -Destination (Join-Path $MqlExp ($EXPERT + '.mq5')) -Force

$ex5 = Join-Path $MqlExp ($EXPERT + '.ex5')
$logC = Join-Path $Work 'compile_natcla_diag.log'
# COMPILAZIONE FALLITA: il log di MetaEditor va in uno zip sul Desktop, non solo nella finestra; nessuna passata parte.
function FermaCompilazione($perche){
  $dskC  = [Environment]::GetFolderPath('Desktop')
  $CartC = Join-Path $dskC ($NOME + '_COMPILAZIONE_FALLITA')
  $zipC  = $CartC + '.zip'
  $stC   = (Get-Date).ToString('yyyyMMdd_HHmmss')
  try{
    if(Test-Path -LiteralPath $CartC){ Move-Item -LiteralPath $CartC -Destination ($CartC + '_VECCHIA_' + $stC) -Force }
    if(Test-Path -LiteralPath $zipC){ Move-Item -LiteralPath $zipC -Destination ($CartC + '_VECCHIO_' + $stC + '.zip') -Force }
    New-Item -ItemType Directory -Force -Path $CartC | Out-Null
    $haLog = Test-Path -LiteralPath $logC
    $righeLog = @()
    if($haLog){
      Copy-Item -LiteralPath $logC -Destination (Join-Path $CartC 'compile_natcla_diag.log') -Force
      $righeLog = @(((Leggi-Condiviso $logC) -split "`r?`n") | Where-Object { $_ -match '(?i)error|errori|warning|avvis|result' } | Select-Object -First 60)
    }
    $testaC = @(('NATCLA DIAG U30: COMPILAZIONE DI EA_NatCla_Diag FALLITA. Nessuna passata lanciata, nessun ordine.'), ('motivo: ' + $perche), ('pin: ' + $Pin + '   pc: ' + $env:COMPUTERNAME + '   data: ' + $stC), ('log di MetaEditor presente: ' + $haLog), '', 'righe di errore/avviso del log (il log intero e compile_natcla_diag.log):')
    (($testaC + $righeLog) -join "`r`n") | Set-Content -LiteralPath (Join-Path $CartC 'COMPILAZIONE_FALLITA.txt') -Encoding ASCII
    Compress-Archive -Path (Join-Path $CartC '*') -DestinationPath $zipC -Force
    Write-Host ('   ZIP DA MANDARE (compilazione fallita): ' + $zipC) -ForegroundColor Red
  } catch { Write-Host ('   zip della compilazione NON creato (' + $_.Exception.Message + '): il log e in ' + $logC) -ForegroundColor Red }
  throw ('COMPILAZIONE FALLITA: ' + $perche + ' Nessuna passata e partita. Manda lo zip ' + $NOME + '_COMPILAZIONE_FALLITA.zip dal Desktop.')
}
Remove-Item -LiteralPath $ex5 -Force -ErrorAction SilentlyContinue
# correzione (i): un .ex5 vecchio che resta sul disco passerebbe per il compilato nuovo
if(Test-Path -LiteralPath $ex5){ FermaCompilazione 'il vecchio .ex5 non si cancella: un compilato vecchio passerebbe per nuovo.' }
Remove-Item -LiteralPath $logC -Force -ErrorAction SilentlyContinue
# il verdetto NON e' il codice d'uscita di MetaEditor: e' l'esistenza del .ex5 appena prodotto. Ogni argomento fra parentesi (classe 1152).
$pMe = Start-Process -FilePath $MetaEditor -ArgumentList @(('/compile:' + (Join-Path $MqlExp ($EXPERT + '.mq5'))), ('/log:' + $logC)) -PassThru
$attC = 0
while(-not (Test-Path -LiteralPath $ex5) -and $attC -lt 60){ Start-Sleep -Seconds 2; $attC = $attC + 1 }
if(-not (Test-Path -LiteralPath $ex5)){
  try{ if(-not $pMe.HasExited){ $pMe.Kill() } }catch{ }
  if(Test-Path -LiteralPath $logC){ (Leggi-Condiviso $logC) -split "`r?`n" | Select-Object -Last 20 | ForEach-Object { Write-Host ('     ' + $_) -ForegroundColor DarkYellow } }
  FermaCompilazione ($EXPERT + '.ex5 NON prodotto dopo 120 secondi. Senza il compilato il giro non parte: il log di MetaEditor e qui sopra.')
}
# correzione (ii): si aspetta che MetaEditor ESCA prima di leggere il log (al massimo 60 secondi)
$attE = 0
while(-not $pMe.HasExited -and $attE -lt 30){ Start-Sleep -Seconds 2; $attE = $attE + 1 }
Start-Sleep -Seconds 3
$testoLogC = ''
if(Test-Path -LiteralPath $logC){ $testoLogC = Leggi-Condiviso $logC }
$compErr = -1; $compWarn = -1
# correzione (iii): la riga del risultato in inglese e in italiano
$mRes = [regex]::Match($testoLogC, '(\d+)\s+(?:errors?|errori|errore),\s*(\d+)\s+(?:warnings?|avvisi|avviso)')
if($mRes.Success){ $compErr = [int]$mRes.Groups[1].Value; $compWarn = [int]$mRes.Groups[2].Value }
if($compErr -gt 0){
  ($testoLogC -split "`r?`n") | Where-Object { $_ -match '(?i)error|errori' } | Select-Object -First 20 | ForEach-Object { Write-Host ('     ' + $_) -ForegroundColor DarkYellow }
  FermaCompilazione ('MetaEditor ha prodotto l.ex5 ma il log dice ' + $compErr + ' errori: non si usa un compilato dubbio.')
}
Dico ('compilato: ' + $ex5 + '   SHA256 .ex5 ' + (Get-FileHash -LiteralPath $ex5 -Algorithm SHA256).Hash.Substring(0,12)) 'Green'
if($compErr -eq 0){ Dico ('log di compilazione: 0 errori, ' + $compWarn + ' avvisi') $(if($compWarn -eq 0){'Green'}else{'Yellow'}) }
else { Dico 'log di compilazione: riga del risultato NON letta (formato diverso?): il verdetto e l esistenza dell .ex5' 'Yellow' }
foreach($lw in @(($testoLogC -split "`r?`n") | Where-Object { $_ -match '(?i)warning|avviso' -and $_ -notmatch '\d+\s+(?:errors?|errori|errore),' } | Select-Object -First 12)){ Dico ('   ' + $lw) 'Yellow' }

# ---------------------------------------------------------------------
#  2. LE 6 PASSATE SINGOLE (Optimization=0, Model=1, EA di sola lettura)
# ---------------------------------------------------------------------
$dsk  = [Environment]::GetFolderPath('Desktop')
$Cart = Join-Path $dsk $NOME
$zip  = Join-Path $dsk ($NOME + '.zip')
$stampa = (Get-Date).ToString('yyyyMMdd_HHmmss')
if(Test-Path -LiteralPath $Cart){ Move-Item -LiteralPath $Cart -Destination ($Cart + '_VECCHIA_' + $stampa) -Force; Dico ('cartella di un giro PRECEDENTE rinominata: ' + $Cart + '_VECCHIA_' + $stampa) 'Yellow' }
if(Test-Path -LiteralPath $zip){ Move-Item -LiteralPath $zip -Destination (Join-Path $dsk ($NOME + '_VECCHIO_' + $stampa + '.zip')) -Force; Dico ('zip di un giro PRECEDENTE rinominato con la data') 'Yellow' }
New-Item -ItemType Directory -Force -Path $Cart | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $Cart 'log'), (Join-Path $Cart 'ini') | Out-Null
Copy-Item -LiteralPath $srcEA -Destination $Cart -Force
if(Test-Path -LiteralPath $logC){ Copy-Item -LiteralPath $logC -Destination (Join-Path $Cart 'compile_natcla_diag.log') -Force }

$LogRoot = Join-Path $env:APPDATA 'MetaQuotes'
$RadiciLog = @($LogRoot, (Join-Path $InstAttesa 'Tester'))
$reRias  = New-Object Text.RegularExpressions.Regex('\[NatCla-DIAG\]\s+(RIASSUNTO\s.*)')
$reEv    = New-Object Text.RegularExpressions.Regex('\[NatCla-DIAG-EV\]\s+(.*)')
$reAvvio = New-Object Text.RegularExpressions.Regex('\[NatCla-DIAG-AVVIO\]\s+(.*)')
$reGuasto = New-Object Text.RegularExpressions.Regex('(?i)critical|array out of range|zero divide|invalid pointer|stack overflow|cannot load|initialization failed|init failed|OnInit .*fail')
$reFin = New-Object Text.RegularExpressions.Regex(('Experts\\' + [regex]::Escape($EXPERT) + '\.ex5 on (?<sim>[A-Za-z0-9_.#-]+),(?<tf>[A-Za-z0-9]+) from (?<da>\d{4}\.\d\d\.\d\d) (?<ha>\d\d:\d\d) to (?<a>\d{4}\.\d\d\.\d\d) (?<hb>\d\d:\d\d)'), [Text.RegularExpressions.RegexOptions]::IgnoreCase)

# la scoperta ricorsiva dei .log si fa UNA VOLTA all'inizio e ricorda le CARTELLE (come NATCLA_F0_PASSATE, deviazione 11)
$DirLog = @{}
foreach($rad in $RadiciLog){
  if(-not (Test-Path -LiteralPath $rad)){ continue }
  foreach($lf in @(Get-ChildItem -Path $rad -Recurse -Filter '*.log' -File -ErrorAction SilentlyContinue)){ $DirLog[$lf.DirectoryName] = $true }
}
$PatLog = @((Join-Path $LogRoot 'Tester\*\Agent-*\logs'), (Join-Path $InstAttesa 'Tester\Agent-*\logs'), (Join-Path $InstAttesa 'Tester\logs'), (Join-Path $DataFolder 'Tester\logs'), (Join-Path $DataFolder 'logs'), (Join-Path (Join-Path $DataFolder 'MQL5') 'Logs'))
function ElencoLog(){
  $dirs = @{}
  foreach($dk in @($DirLog.Keys)){ $dirs[$dk] = $true }
  foreach($pt in $PatLog){ foreach($it in @(Get-Item -Path $pt -ErrorAction SilentlyContinue)){ if($it.PSIsContainer){ $dirs[$it.FullName] = $true } } }
  $v = @()
  foreach($dk in @($dirs.Keys)){ $v = $v + @(Get-ChildItem -LiteralPath $dk -Filter '*.log' -File -ErrorAction SilentlyContinue) }
  return $v
}
function Fotografia(){
  $h = @{}
  foreach($f in @(ElencoLog)){ $h[$f.FullName] = $f.Length }
  return $h
}
function LeggiCoda($path, $offset){
  # i log di MT5 sono UTF-16 LE con BOM: la codifica si legge dal BOM all'inizio del FILE, poi si salta all'offset della fotografia
  $fs = [IO.File]::Open($path,[IO.FileMode]::Open,[IO.FileAccess]::Read,[IO.FileShare]::ReadWrite)
  try{
    $b = New-Object byte[] 2
    [void]$fs.Read($b,0,2)
    $enc = [Text.Encoding]::UTF8
    if($b[0] -eq 0xFF -and $b[1] -eq 0xFE){ $enc = [Text.Encoding]::Unicode }
    elseif($b[0] -eq 0xFE -and $b[1] -eq 0xFF){ $enc = [Text.Encoding]::BigEndianUnicode }
    $da = [long]$offset
    if($da -lt 2 -and $enc -ne [Text.Encoding]::UTF8){ $da = 2 }
    [void]$fs.Seek($da,[IO.SeekOrigin]::Begin)
    $sr = New-Object IO.StreamReader($fs, $enc, $false)
    return $sr.ReadToEnd()
  } finally { $fs.Close() }
}
# la riga RIASSUNTO in k=v (valori senza spazi)
function LeggiRiassunto($testo){
  $h = @{}
  foreach($tk in ($testo -split '\s+')){
    $p = $tk -split '=', 2
    if($p.Count -eq 2 -and $p[0] -ne ''){ $h[$p[0]] = $p[1] }
  }
  return $h
}

Titolo ('2 - ' + $Passate.Count + ' PASSATE SINGOLE (Modello 1, OHLC su M1, EA_NatCla_Diag di sola lettura, nessun ordine)')
$TGiro = Get-Date
$manifest = New-Object System.Collections.ArrayList
[void]$manifest.Add('passata;simbolo;da;a;t_avvio;durata_s;stato;cd_ok;cd_n;cd_bc;cd_cr;cd_cb;primo_ok;finestra;motivi')
$riass = New-Object System.Collections.ArrayList
[void]$riass.Add('passata;simbolo;da;stato;' + ($CHIAVI -join ';'))
$nOk = 0; $nKo = 0; $nNon = 0
$abort = $false
$k = 0
foreach($ps in $Passate){
  $k = $k + 1
  $tag = $ps.Id + '_' + $ps.Sim + '_' + $ps.Da.Replace('.', '')
  $etich = '[' + $ps.Id + '] ' + $ps.Sim + ' H1 dal ' + $ps.Da
  $minDa = ((Get-Date) - $TGiro).TotalMinutes
  if($abort -or $minDa -ge $TETTO_MIN){
    $nNon = $nNon + 1
    $why = 'tetto di ' + $TETTO_MIN + ' minuti'; if($abort){ $why = 'giro fermato' }
    [void]$manifest.Add($ps.Id + ';' + $ps.Sim + ';' + $ps.Da + ';' + $DATA_A + ';;0;NON_LANCIATA;;;;;;;;' + $why)
    [void]$riass.Add($ps.Id + ';' + $ps.Sim + ';' + $ps.Da + ';NON_LANCIATA' + (';' * $CHIAVI.Count))
    Write-Host ('   ' + $etich + '  NON LANCIATA (' + $why + ', minuto ' + [int]$minDa + ')') -ForegroundColor Red
    continue
  }
  if((@(Get-Process -Name terminal64 -ErrorAction SilentlyContinue)).Count -gt 0){
    Write-Host ('   ' + $etich + '  un terminal64 e ancora VIVO prima della passata: il giro si ferma, non apro un secondo terminale.') -ForegroundColor Red
    $abort = $true; $nNon = $nNon + 1
    [void]$manifest.Add($ps.Id + ';' + $ps.Sim + ';' + $ps.Da + ';' + $DATA_A + ';;0;NON_LANCIATA;;;;;;;;terminale ancora vivo')
    [void]$riass.Add($ps.Id + ';' + $ps.Sim + ';' + $ps.Da + ';NON_LANCIATA' + (';' * $CHIAVI.Count))
    continue
  }
  $iniF = Join-Path $Work ('diag_' + $tag + '.ini')
  $testoIni = "[Experts]`r`nAllowLiveTrading=false`r`nAllowDllImport=false`r`n`r`n" +
              "[Tester]`r`nExpert=" + $EXPERT + ".ex5`r`nSymbol=" + $ps.Sim + "`r`nPeriod=H1`r`nModel=1`r`n" +
              "Optimization=0`r`nFromDate=" + $ps.Da + "`r`nToDate=" + $DATA_A + "`r`nForwardMode=0`r`nDeposit=10000`r`nCurrency=EUR`r`nLeverage=100`r`n" +
              "ExecutionMode=0`r`nShutdownTerminal=1`r`n`r`n" +
              "[TesterInputs]`r`n" + ($Ingressi -join "`r`n") + "`r`nInpVerificheSeparate=" + $ps.Sep + "`r`n"
  Set-Content -LiteralPath $iniF -Value $testoIni -Encoding ASCII
  Copy-Item -LiteralPath $iniF -Destination (Join-Path $Cart 'ini') -Force

  $foto = Fotografia
  $tRun = Get-Date
  $p = Start-Process -FilePath $Terminal -ArgumentList ('/config:"' + $iniF + '"') -PassThru
  $scade = $tRun.AddMinutes($TimeoutRunMin)
  while(-not $p.HasExited -and (Get-Date) -lt $scade){ Start-Sleep -Seconds 5 }
  $timeout = $false
  if(-not $p.HasExited){
    $timeout = $true
    Write-Host ('   ' + $etich + '  TIMEOUT: dopo ' + $TimeoutRunMin + ' minuti il tester e ancora aperto. Lo chiudo con CloseMainWindow (MAI Stop-Process sul terminale).') -ForegroundColor Red
    try{ [void]$p.CloseMainWindow() }catch{ }
    $att = 0; while(-not $p.HasExited -and $att -lt 18){ Start-Sleep -Seconds 5; $att = $att + 1 }
    if(-not $p.HasExited){ $abort = $true; Write-Host '   il terminale NON si e chiuso: il giro si ferma qui, la riga NON lo chiude con la forza (guarda i grafici e chiudilo A MANO).' -ForegroundColor Red }
  }
  Start-Sleep -Seconds 8   # l'agente del tester scarica i log su disco dopo la chiusura
  $dur = ((Get-Date) - $tRun).TotalSeconds

  # --- lettura delle sole righe scritte DOPO la fotografia; doppioni (agente + copia del terminale) tolti per contenuto
  $rias = New-Object System.Collections.ArrayList; $visti = @{}
  $avvi = New-Object System.Collections.ArrayList
  $evs = New-Object System.Collections.ArrayList
  $guasti = New-Object System.Collections.ArrayList
  $tester = New-Object System.Collections.ArrayList
  $fin = @{}; $illeggibili = 0
  foreach($f in @(ElencoLog)){
    $off = 0; if($foto.ContainsKey($f.FullName)){ $off = [long]$foto[$f.FullName] }
    if($f.Length -le $off){ continue }
    try{ $testo = LeggiCoda $f.FullName $off }catch{ $illeggibili = $illeggibili + 1; continue }
    foreach($riga in ($testo -split "`r?`n")){
      if($riga.Trim() -eq ''){ continue }
      $mr = $reRias.Match($riga)
      if($mr.Success){ $c0 = 'R|' + $mr.Groups[1].Value.TrimEnd(); if(-not $visti.ContainsKey($c0)){ $visti[$c0] = $true; [void]$rias.Add($mr.Groups[1].Value.TrimEnd()) }; continue }
      $ma = $reAvvio.Match($riga)
      if($ma.Success){ $c0 = 'A|' + $ma.Groups[1].Value.TrimEnd(); if(-not $visti.ContainsKey($c0)){ $visti[$c0] = $true; [void]$avvi.Add($ma.Groups[1].Value.TrimEnd()) }; continue }
      $me = $reEv.Match($riga)
      if($me.Success){ $c0 = 'E|' + $me.Groups[1].Value.TrimEnd(); if(-not $visti.ContainsKey($c0)){ $visti[$c0] = $true; [void]$evs.Add($me.Groups[1].Value.TrimEnd()) }; continue }
      $mf = $reFin.Match($riga)
      if($mf.Success){ $fin[($mf.Groups['sim'].Value + '|' + $mf.Groups['tf'].Value + '|' + $mf.Groups['da'].Value + '|' + $mf.Groups['ha'].Value + '|' + $mf.Groups['a'].Value + '|' + $mf.Groups['hb'].Value)] = $mf }
      if($reGuasto.IsMatch($riga)){ $c0 = 'G|' + $riga.Trim(); if(-not $visti.ContainsKey($c0) -and $guasti.Count -lt 40){ $visti[$c0] = $true; [void]$guasti.Add($riga.Trim()) }; continue }
      if($riga -match "`tTester`t" -and ($riga.IndexOf($ps.Sim) -ge 0 -or $riga -match '(?i)history|no data|cannot|failed|error|stopped|not found|disconnect|synchron|download|generated|passed')){
        $c0 = 'T|' + $riga.Trim(); if(-not $visti.ContainsKey($c0) -and $tester.Count -lt 80){ $visti[$c0] = $true; [void]$tester.Add($riga.Trim()) }
      }
    }
  }
  $motivi = New-Object System.Collections.ArrayList
  if($timeout){ [void]$motivi.Add('timeout di ' + $TimeoutRunMin + ' minuti') }
  if($illeggibili -gt 0){ [void]$motivi.Add('' + $illeggibili + ' file di log illeggibili') }
  if($avvi.Count -eq 0){ [void]$motivi.Add('riga [NatCla-DIAG-AVVIO] NON trovata nei log (l EA non e partito? ini ignorata?)') }
  foreach($a in $avvi){ if($a -match 'RIFIUTATO|ERRORE'){ [void]$motivi.Add('AVVIO: ' + $a) } }
  if($avvi.Count -gt 1){ [void]$motivi.Add('PIU righe AVVIO distinte (' + $avvi.Count + '): log di due passate mescolati') }
  $R = @{}
  if($rias.Count -eq 0){ [void]$motivi.Add('riga [NatCla-DIAG] RIASSUNTO NON trovata (OnDeinit non stampato? log non scaricato?)') }
  elseif($rias.Count -gt 1){ [void]$motivi.Add('PIU righe RIASSUNTO distinte (' + $rias.Count + '): log di due passate mescolati') }
  else {
    $R = LeggiRiassunto $rias[0]
    if($R['fine'] -ne '1'){ [void]$motivi.Add('riga RIASSUNTO TRONCATA (manca fine=1)') }
    if($R['v'] -ne $VERSIONE_ATTESA){ [void]$motivi.Add('versione EA diagnostico ' + $R['v'] + ' invece di ' + $VERSIONE_ATTESA) }
    if($R['sym'] -ne $ps.Sim){ [void]$motivi.Add('simbolo ' + $R['sym'] + ' invece di ' + $ps.Sim) }
    if($R['tf'] -ne 'PERIOD_H1'){ [void]$motivi.Add('TF ' + $R['tf'] + ' invece di PERIOD_H1') }
    $sepAtteso = '0'; if($ps.Sep -eq 'true'){ $sepAtteso = '1' }
    if($R['sep'] -ne $sepAtteso){ [void]$motivi.Add('verifiche separate ' + $R['sep'] + ' invece di ' + $sepAtteso) }
    $mancano = @($CHIAVI | Where-Object { -not $R.ContainsKey($_) })
    if($mancano.Count -gt 0){ [void]$motivi.Add('chiavi assenti nel RIASSUNTO: ' + ($mancano -join ',')) }
    if($R.ContainsKey('nuove') -and $R['nuove'] -eq '0'){ [void]$motivi.Add('ZERO barre nuove viste dall EA: la passata non ha girato sul TF') }
  }
  # finestra girata: SOLO informativa (nel pilota la regex non l'ha mai trovata)
  $finest = 'non letta'
  if($fin.Count -eq 1){ $mf = $fin.Values | Select-Object -First 1; $finest = $mf.Groups['sim'].Value + ',' + $mf.Groups['tf'].Value + ' ' + $mf.Groups['da'].Value + '-' + $mf.Groups['a'].Value }
  elseif($fin.Count -gt 1){ $finest = 'AMBIGUA (' + $fin.Count + ' intestazioni)' }

  # il log di questa passata
  $lg = New-Object System.Collections.ArrayList
  [void]$lg.Add('passata ' + $etich + ' (' + $ps.Ruolo + ')   ini diag_' + $tag + '.ini   durata ' + [int]$dur + ' s   finestra letta: ' + $finest)
  foreach($a in $avvi){ [void]$lg.Add('[NatCla-DIAG-AVVIO] ' + $a) }
  foreach($a in $evs){ [void]$lg.Add('[NatCla-DIAG-EV] ' + $a) }
  foreach($a in $rias){ [void]$lg.Add('[NatCla-DIAG] ' + $a) }
  foreach($a in $guasti){ [void]$lg.Add('GUASTO ' + $a) }
  foreach($a in $tester){ [void]$lg.Add('TESTER ' + $a) }
  ($lg -join "`r`n") | Set-Content -LiteralPath (Join-Path (Join-Path $Cart 'log') ('DIAG_' + $tag + '.txt')) -Encoding ASCII

  $stato = 'OK'
  if($motivi.Count -gt 0){ $stato = 'KO' }
  if($stato -eq 'OK'){ $nOk = $nOk + 1 } else { $nKo = $nKo + 1 }
  $vals = @(); foreach($ck in $CHIAVI){ $vv = ''; if($R.ContainsKey($ck)){ $vv = $R[$ck] }; $vals = $vals + @($vv -replace ';', ',') }
  [void]$riass.Add($ps.Id + ';' + $ps.Sim + ';' + $ps.Da + ';' + $stato + ';' + ($vals -join ';'))
  [void]$manifest.Add($ps.Id + ';' + $ps.Sim + ';' + $ps.Da + ';' + $DATA_A + ';' + $tRun.ToString('yyyy-MM-dd HH:mm:ss') + ';' + [int]$dur + ';' + $stato + ';' + $R['cd_ok'] + ';' + $R['cd_n'] + ';' + $R['cd_bc'] + ';' + $R['cd_cr'] + ';' + $R['cd_cb'] + ';' + $R['primo_ok'] + ';' + ($finest -replace ';', ',') + ';' + (($motivi -join ' | ') -replace ';', ','))
  $col = 'Green'; if($stato -ne 'OK'){ $col = 'Red' }
  Write-Host ('   ' + $etich + '  ' + $stato + '   ' + [int]$dur + ' s   barre nuove ' + $R['nuove'] + '   CATENA: OK ' + $R['cd_ok'] + ' | n<300 ' + $R['cd_n'] + ' | BarsCalculated ' + $R['cd_bc'] + ' | CopyRates ' + $R['cd_cr'] + ' | CopyBuffer ' + $R['cd_cb'] + '   prima barra tutta OK: ' + $R['primo_ok'] + '   max barre ' + $R['max_barre']) -ForegroundColor $col
  foreach($x in $motivi){ Write-Host ('        - ' + $x) -ForegroundColor Red }
  foreach($x in @($guasti | Select-Object -First 5)){ Write-Host ('        guasto: ' + $x) -ForegroundColor DarkYellow }
}
$durTot = ((Get-Date) - $TGiro).TotalMinutes

# ---------------------------------------------------------------------
#  3. RACCOLTA
# ---------------------------------------------------------------------
Titolo '3 - RACCOLTA'
$testa = @(
  ('NATCLA DIAG U30 -- quale delle 4 condizioni di CaricaDati() (EA_NatCla v1.04 r.1262-1280) cade sugli indici BCM (Modello 1 OHLC su M1, EA_NatCla_Diag di SOLA LETTURA, NESSUN ordine)'),
  ('data: ' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss') + '   pc: ' + $env:COMPUTERNAME + '   pin: ' + $Pin),
  ('EA_NatCla_Diag.mq5 SHA256 ' + $ShaEA + '  (NCD_VER ' + $VERSIONE_ATTESA + ')   compilazione: ' + $compErr + ' errori, ' + $compWarn + ' avvisi (-1 = non letto)'),
  ('passate ' + $Passate.Count + ': OK ' + $nOk + ', KO ' + $nKo + ', NON LANCIATE ' + $nNon + '   durata ' + [int]$durTot + ' minuti'),
  ''
)
$attese = @(
  'ATTESE SCRITTE PRIMA DEI NUMERI (lo script NON giudica: queste righe dicono come si legge):',
  ' (d) EURUSD dal 2024.09.26 = CONTROLLO POSITIVO: cd_ok > 0 e primo_ok alla PRIMA barra della finestra. Se (d) non passa, la diagnosi e rotta e NESSUN numero di (a)(b)(c) si legge.',
  ' (e) U30USD dal 2024.09.26 con SOLO la catena (= EA_NatCla alla lettera) deve RIPRODURRE il KO del pilota: cd_ok = 0. E la passata FEDELE: comanda lei.',
  ' (a) e (e) insieme (ipotesi principale, documentata: nel tester gli indicatori si calcolano SOLO quando si chiede un buffer, classe 1171):',
  '     se (a) ha cd_ok > 0 e (e) ha cd_ok = 0 con cd_bc circa nuove-301 e min_bc/max_bc dell EMA200 fermi a -1 o bassi, la causa e BarsCalculated chiesto PRIMA di',
  '     CopyBuffer nel tester pigro: rimedio in EA_NatCla v1.05, e il lotto C resta FERMO fino ad allora.',
  '     se (e) ha cd_ok > 0, il KO del pilota NON e in CaricaDati: si leggono le righe GUASTO e TESTER del log delle passate.',
  ' Come si legge (a): la colonna cd_* che porta tutte le barre nuove e la condizione che cade. cd_n su tutte con max_barre < 302 = Bars() non cresce dentro la finestra;',
  '     cd_bc con min_bc/max_bc = -1 o fermi = indicatori mai calcolati; cd_cr / cd_cb = copia rifiutata (il codice d errore e nelle colonne u_cr / u_cb, valore/errore).',
  ' (b) U30USD dal 2025.01.02: se primo_ok cade alla PRIMA barra, con storia davanti il simbolo funziona e il guasto e il riscaldamento DENTRO la finestra (tocca H4/H12/D1 di tutti gli indici).',
  '     Se (b) resta a cd_ok = 0, il guasto e del SIMBOLO (o della classe), non della finestra.',
  ' (c) D30EUR dal 2024.09.26 e (f) uguale con SOLO la catena: dicono se e la classe degli indici BCM (stesso esito di (a) e (e)) o il solo U30USD.',
  ' (b) e (d) sono fedeli all EA se primo_ok cade alla PRIMA barra della finestra (prima del primo CopyBuffer delle verifiche separate).',
  ' RIGA RIASSUNTO TRONCATA: le chiavi cd_* stanno nei primi ~300 caratteri e restano nel DIAG_RIASSUNTO.csv. La passata esce KO ma NON si butta: si leggono le chiavi presenti.',
  ''
)
(($testa + $manifest + @('') + $attese + @(
  'FILE: MANIFEST_DIAG.csv (stato per passata), DIAG_RIASSUNTO.csv (tutte le chiavi della riga RIASSUNTO, una colonna per chiave), log\DIAG_<passata>.txt (AVVIO, transizioni EV, RIASSUNTO, righe di guasto e del tester).',
  'Questo script CONTA e dice se ogni passata e leggibile: NON giudica, NON promuove, NON tocca EA_NatCla.')) -join "`r`n") | Set-Content -LiteralPath (Join-Path $Cart 'RIEPILOGO_DIAG.txt') -Encoding ASCII
(($manifest) -join "`r`n") | Set-Content -LiteralPath (Join-Path $Cart 'MANIFEST_DIAG.csv') -Encoding ASCII
(($riass) -join "`r`n") | Set-Content -LiteralPath (Join-Path $Cart 'DIAG_RIASSUNTO.csv') -Encoding ASCII
Compress-Archive -Path (Join-Path $Cart '*') -DestinationPath $zip -Force
Write-Host ''
Write-Host ('passate OK ' + $nOk + ', KO ' + $nKo + ', NON LANCIATE ' + $nNon + ' su ' + $Passate.Count + '   durata ' + [int]$durTot + ' minuti') -ForegroundColor Cyan
Write-Host ('ZIP PRONTO DA MANDARE: ' + $zip) -ForegroundColor Green
Write-Host 'FILE ATTESI NELLO ZIP: RIEPILOGO_DIAG.txt + MANIFEST_DIAG.csv + DIAG_RIASSUNTO.csv + EA_NatCla_Diag.mq5 + compile_natcla_diag.log + log\DIAG_<passata>.txt x 6 + ini\diag_<passata>.ini x 6' -ForegroundColor Gray
try{ $Mutex.ReleaseMutex() }catch{ }
if($nKo -eq 0 -and $nNon -eq 0 -and $nOk -eq $Passate.Count){ Write-Host 'ESITO DIAG: TUTTE LE PASSATE LEGGIBILI (rc 0). Il verdetto lo danno le colonne cd_* lette con le ATTESE del RIEPILOGO.' -ForegroundColor Green; exit 0 }
Write-Host 'ESITO DIAG: ALMENO UNA PASSATA KO O NON LANCIATA (rc 3): lo zip esce lo stesso, il MANIFEST dice quali e perche.' -ForegroundColor Red
exit 3
