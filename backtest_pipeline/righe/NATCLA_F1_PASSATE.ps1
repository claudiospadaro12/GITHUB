# =====================================================================
#  MARCATORE_NATCLA_F1_PASSATE_v1
#  NATCLA_F1_PASSATE.ps1 -- FASE F1 DI 'Ea Nat&Cla': LA PRIMA MISURA DEL MERITO A TICK REALI E LE TRE REGOLE DI STOP
#
#  CHE COSA FA, e una cosa sola:
#    per ogni passata di UN LOTTO del file prova backtest_pipeline/prove/NATCLA_F1_STOP_2026-10-09.txt
#    (passata = simbolo x config x lato x modo di stop) lancia UNA passata SINGOLA del tester (Optimization=0,
#    Model=4 = ogni tick basato su tick reali, deposito 1000000 EUR, InpSoloConta=false: l'EA manda ordini
#    SOLO dentro il tester), poi RACCOGLIE il report .htm, il CSV per-setup natcla_setup_*, il per-trade
#    abtg_trades_*, le righe [NatCla]/[NATCLA-IMBUTO] del giornale con l'ora simulata, e le righe del tester
#    (finestra, tick, soldi), e mette tutto in uno zip sul Desktop. Dice per ogni passata se e' AFFIDABILE (OK)
#    o no (KO). NON giudica niente: PF, DD, n per gamba, i verdetti e il confronto dei modi li fa
#    leggi_natcla_f1.py, con le soglie scritte nel file prova PRIMA dei numeri.
#
#  PERCHE' NON IL DRIVER DEI ROUND (misurato sul sorgente, 09/10): EA_NatCla v1.11 HA OnTester/FrameAdd, ma
#  (a) OptFrame da' PF e operazioni per DEAL, la specifica 5.5 vuole n e PF per SETUP; (b) il CSV per-setup si
#  scrive SOLO fuori dall'ottimizzazione (EA r.1327); (c) in ottimizzazione ogni passata riscrive gli stessi
#  file (nome = simbolo + magic). Il driver dei round (walkforward_generico.ps1, congelato per il P0) non si tocca.
#
#  DERIVATO DA NATCLA_F0_PASSATE.ps1 (blocchi del file prova, guardie di macchina, compilazione verificata,
#  scoperta dei log una volta per lotto) e da GBA_R0_PASSATE.ps1 v3 (report .htm, Modello 4, profondita' dei
#  tick sul SOLO simbolo della prova, rete KO su soldi/margine, numeri con InvariantCulture). DEVIAZIONI:
#   1. Passata = (simbolo, config, lato, modo). I lotti sono nei blocchi '# @F1-LOTTO' del file prova (la SOLA
#      fonte): o una lista esplicita 'passate=SIM:CFG:LATO:MODO,...' o il prodotto simboli x configs x lati x modi,
#      dove un modo che la config non ammette (M2: niente PIU, identico a LINEA) si SALTA e si conta.
#   2. Il driver sostituisce SOLO cinque input: InpModalita e InpTF (config), InpDirezione (lato), InpStopModo
#      (modo), InpInclMinAtr (soglia P50 della famiglia x config, blocco @F1-INCL). Tutti gli altri sono i pin.
#   3. Modello 4. KO se il report non dice 100% ticks reali; KO se 'ticks data begins from' del SIMBOLO DELLA
#      PROVA cade dopo l'inizio della finestra (la riga del simbolo di conversione non conta: classe 1205).
#   4. Deposito 1000000 EUR riletto dal report ('Deposito Iniziale'): diverso = KO. Il deposito qui serve a che
#      l'arrotondamento per difetto dei lotti (step 0,01) non scarti ordini ne' deformi R (file prova, contro-esempio
#      sull'oro): una riga 'lotto sotto il minimo' dell'EA = KO.
#   5. Rete delle uscite silenziose (classe 1204/1208), elencate dal sorgente dell'EA (grep ERRORE|FALLIT|SCARTAT|
#      AVVISO): 'stop out', 'no money', 'not enough money' nel giornale = KO; '[NatCla] INVIO FALLITO' con retcode
#      10019 = KO; gli altri INVIO FALLITO si contano (colonna invio_fallito); 'lotto sotto il minimo' = KO;
#      'AVVISO SEMAFORO SFORATO' e 'quadratura ROTTA' dell'imbuto si contano. AVVIO RIFIUTATO / ERRORE = KO.
#   6. Le righe del giornale si deduplicano per (ora SIMULATA + testo) e, nella stessa ora simulata, una riga che e'
#      PREFISSO di una piu' lunga e' la sua copia TRONCATA (classe 1173) e si toglie: a tick reali l'EA stampa migliaia
#      di righe e molte hanno testo uguale in ore diverse (RIEMPITO ST25 LONG ...), che la deduplica per solo testo di F0
#      avrebbe fuso; e la chiave sui primi 70 caratteri del GBA non riconosce la copia troncata di una riga CORTA
#      (provato: INVIO FALLITO di 68 caratteri troncato a 59 contava due volte).
#   7. Controlli per passata: riga AVVIO v1.11 (modalita, simbolo, TF, magic, unita' per classe, linee, ADX,
#      ingresso, rischio 0.25, solo conta 'no', placebo 0, stop del MODO con 20.00 u); righe CFG InpDirezione e
#      CFG Inclinazione (soglia della famiglia); VERIFICA ADX 'formula MetaQuotes'; finestra girata dal giornale;
#      report di EA_NatCla, simbolo, periodo e finestra giusti; CSV per-setup FRESCO (scritto dopo l'avvio) senza
#      righe CONTA; somma dei riempiti delle righe SETUP fra (operazioni del report - 3) e operazioni del report
#      (un setup aperto a fine test non ha riga); somma degli esiti in soldi entro 2 rischi del profitto del report.
#   8. I due CSV dell'EA hanno nome = simbolo + magic, UGUALE per i tre modi e i due lati: si copiano SUBITO dopo
#      ogni passata con il nome della passata (csv\<tag>.csv, trades\<tag>.csv), e devono essere FRESCHI.
#   9. Mutex Global\ABTG_NATCLA_F1; e se un giro NATCLA_F0 o GBA_R0 ha il suo mutex vivo su questo PC, ci si ferma.
#  10. Numeri SEMPRE con InvariantCulture: Parse con $IC e .ToString(formato, $IC), mai '-f' su decimali (classe 5).
#  INVARIATI da F0/GBA: guardia macchina DESKTOP-H4D7CAJ, tutti gli MT5 e MetaEditor chiusi, installazioni censite
#  il 05/10 ammesse PER NOME (C:\MT5_Backtest, C:\FundedNext_Manuale: chiuse, non toccate), cartella dati risolta
#  per origin.txt, nessun EA sui grafici salvati, AllowLiveTrading=false, pin di 40 esadecimali, SHA256 di EA/
#  include/prova passati dalla riga e ricontrollati, compilazione = .ex5 NUOVO + log letto in inglese e italiano
#  (zip del log se fallisce), CloseMainWindow e MAI Stop-Process sul terminale, TLS 1.2 qui dentro, cartella e zip
#  esistenti RINOMINATI con la data e mai cancellati, tetto di minuti per lotto (ferma l'avvio, non la fine).
#
#  E' UN BACKTEST, NON UN ORDINE. [Experts] AllowLiveTrading=false nel .ini: il terminale del PC di backtest e'
#  loggato sul DEMO 50503392 e il 14/08/2026 da questa macchina sono partiti ordini VERI.
#
#  NON TOCCA, per nome: PRIMA SU QUESTO PC le installazioni C:\MT5_Backtest (cartella dati 04C7A32B) e
#  C:\FundedNext_Manuale (cartella dati 2B8180C3); POI il VPS VMI3047753 e TUTTE le sue cartelle dati (FTMO in
#  C:\FTMO, trial 1514806751, REALE 10105439 in C:\BCM_Reale, 100k 50504263, piccolo 50503392 sul VPS, manuale
#  50503635 in C:\MT5_MANUALE, banco 50504400 in C:\MT5_Backtest, Pepperstone, Tickmill). Scrive SOLO: la cartella
#  %USERPROFILE%\abtg_passata, MQL5\Experts e MQL5\Include del terminale BCM di questa macchina, i report .htm che
#  il tester scrive nella cartella dati (Report=), il Desktop. I CSV natcla_setup_* e abtg_trades_* in Common\Files
#  li scrive l'EA nel tester: questo script li COPIA (non li cancella ne' li sposta). NON legge ne' scrive conti,
#  ordini, posizioni, preset di nessuna sedia. NON tocca CODA.txt ne' il runner notturno (che gira sul VPS).
#
#  NIENTE EMOJI QUI DENTRO (regola del 17/08): Windows PowerShell 5.1 legge i .ps1 come ANSI.
# =====================================================================
[CmdletBinding()]
param(
  [Parameter(Mandatory=$true)][string]$Pin,
  [Parameter(Mandatory=$true)][string]$Lotto,
  [Parameter(Mandatory=$true)][string]$ShaEA,
  [Parameter(Mandatory=$true)][string]$ShaInc,
  [Parameter(Mandatory=$true)][string]$ShaProva,
  [int]$TimeoutRunMin = 45
)

$ErrorActionPreference = 'Stop'
$IC = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentCulture   = $IC
[Threading.Thread]::CurrentThread.CurrentUICulture = $IC
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

$EXPERT = 'EA_NatCla'
$PROVA  = 'NATCLA_F1_STOP_2026-10-09.txt'
$VERSIONE_ATTESA = '1.11'
$DATA_A = '2025.06.30'
$ASSE_ATTESO = 'InpMagic=0||0||1||1||Y'
$N_PIN_ATTESI = 73
$DEPOSITO = 1000000
$MODELLO = 4
$STOP_U = '20.00'
$SOSTITUITI = @('InpModalita', 'InpTF', 'InpDirezione', 'InpStopModo', 'InpInclMinAtr')
if($Pin -notmatch '^[0-9a-fA-F]{40}$'){ throw '-Pin obbligatorio e di 40 caratteri esadecimali: senza, girerebbe la punta del branch spacciandola per un commit congelato.' }
$Pin = $Pin.ToLower()
if($Lotto -notmatch '^(P|O|FA|FB|I)$'){ throw ('-Lotto deve essere P, O, FA, FB o I (e ' + $Lotto + ').') }
foreach($hx in @($ShaEA, $ShaInc, $ShaProva)){ if($hx -notmatch '^[0-9a-fA-F]{64}$'){ throw '-ShaEA, -ShaInc e -ShaProva devono essere di 64 caratteri esadecimali (SHA256 calcolato dal commit, mai dal disco).' } }
$ShaEA = $ShaEA.ToUpper(); $ShaInc = $ShaInc.ToUpper(); $ShaProva = $ShaProva.ToUpper()
if($TimeoutRunMin -lt 1 -or $TimeoutRunMin -gt 120){ throw '-TimeoutRunMin fuori da 1-120 minuti.' }
$RAW = 'https://raw.githubusercontent.com/claudiospadaro12/GITHUB/' + $Pin + '/'

function Dico($t,$c='Gray'){ Write-Host ('   ' + $t) -ForegroundColor $c }
function Titolo($t){ Write-Host ''; Write-Host ('=== ' + $t + ' ===') -ForegroundColor Cyan }
function Num($s){ return [double]::Parse($s, [Globalization.NumberStyles]::Float, $IC) }
function Fmt($x, $f){ return ([double]$x).ToString($f, $IC) }
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
# i blocchi leggibili a macchina del file prova: '#  @F1-TIPO k=v k=v ...'
function BloccoF1($riga){
  $h = @{}
  foreach($kv in ($riga -split '\s+')){
    if($kv -eq ''){ continue }
    $p = $kv -split '=', 2
    if($p.Count -ne 2){ throw ('blocco @F1 malformato: ' + $riga) }
    if($h.ContainsKey($p[0])){ throw ('blocco @F1 con chiave doppia ' + $p[0] + ': ' + $riga) }
    $h[$p[0]] = $p[1]
  }
  return $h
}
# il CSV per-setup della passata: intestazione, righe #AVVIO/#cfg, righe SETUP (somma riempiti ed esiti in soldi), righe CONTA (devono essere 0)
function ContaSetup($path){
  $r = @{ Ok = $true; Motivo = ''; Header = $false; Avvio = ''; Cfg = 0; Setup = 0; Conta = 0; Riempiti = 0; Soldi = 0.0; RischioMax = 0.0; CfgDir = ''; CfgIncl = ''; CfgStop = '' }
  $fs = $null
  try{
    $fs = [IO.File]::Open($path, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
    $sr = New-Object IO.StreamReader($fs, [Text.Encoding]::ASCII)
    $iR = -1; $iS = -1; $iK = -1; $nCol = 0
    while($true){
      $ln = $sr.ReadLine()
      if($null -eq $ln){ break }
      if($ln.StartsWith('tipo;barra;linea;lato;', [StringComparison]::Ordinal)){
        $r.Header = $true
        $cols = $ln.Split(';'); $nCol = $cols.Count
        $iR = [array]::IndexOf($cols, 'n_riempiti'); $iS = [array]::IndexOf($cols, 'esito_soldi'); $iK = [array]::IndexOf($cols, 'rischio_soldi')
        continue
      }
      if($ln.StartsWith('#AVVIO', [StringComparison]::Ordinal)){ if($r.Avvio -eq ''){ $r.Avvio = $ln }; continue }
      if($ln.StartsWith('#cfg;', [StringComparison]::Ordinal)){
        $r.Cfg = $r.Cfg + 1
        if($ln.StartsWith('#cfg;InpDirezione;', [StringComparison]::Ordinal)){ $r.CfgDir = $ln }
        if($ln.StartsWith('#cfg;Inclinazione;', [StringComparison]::Ordinal)){ $r.CfgIncl = $ln }
        if($ln.StartsWith('#cfg;Stop;', [StringComparison]::Ordinal)){ $r.CfgStop = $ln }
        continue
      }
      if($ln.StartsWith('CONTA;', [StringComparison]::Ordinal)){ $r.Conta = $r.Conta + 1; continue }
      if($ln.StartsWith('SETUP;', [StringComparison]::Ordinal)){
        if($iR -lt 0 -or $iS -lt 0 -or $iK -lt 0){ $r.Ok = $false; $r.Motivo = 'riga SETUP prima di un intestazione con n_riempiti/esito_soldi/rischio_soldi'; break }
        $c = $ln.Split(';')
        if($c.Count -ne $nCol){ $r.Ok = $false; $r.Motivo = ('riga SETUP con ' + $c.Count + ' campi invece di ' + $nCol); break }
        $r.Setup = $r.Setup + 1
        $r.Riempiti = $r.Riempiti + [int]$c[$iR]
        $r.Soldi = $r.Soldi + (Num $c[$iS])
        $rk = Num $c[$iK]; if($rk -gt $r.RischioMax){ $r.RischioMax = $rk }
      }
    }
  } catch { $r.Ok = $false; $r.Motivo = ('CSV illeggibile: ' + $_.Exception.Message) } finally { if($null -ne $fs){ $fs.Close() } }
  return $r
}
# il report .htm di MT5: tabella di celle label / valore. Si tolgono i tag, si cerca "|ETICHETTA:|valore|". Etichette italiane e inglesi.
function CercaCella([string]$t, [string[]]$etichette){
  foreach($e in $etichette){
    $m = [regex]::Match($t, '\|' + $e + ':\|([^|]*)\|')
    if($m.Success){ return (([regex]::Replace($m.Groups[1].Value, '\s', ''))) }
  }
  return $null
}
function LeggiReport($path){
  $r = @{ Ok = $false; Trades = $null; Profitto = $null; PF = ''; Qualita = ''; Deposito = $null; Ticks = $null; Motivo = ''; Expert = $null; Simbolo = $null; Periodo = $null }
  $testo = Leggi-Condiviso $path
  if([string]::IsNullOrEmpty($testo)){ $r.Motivo = 'report vuoto o illeggibile'; return $r }
  $t = [regex]::Replace($testo, '<[^>]+>', '|')
  $t = [regex]::Replace($t, '\s*\|[\s|]*', '|')
  $vt = CercaCella $t @('Numero di Operazioni di Trading Totali', 'Total Trades')
  $vp = CercaCella $t @('Profitto Totale Netto', 'Total Net Profit')
  $vf = CercaCella $t @('Fattore di Profitto', 'Profit Factor')
  $vq = CercaCella $t @('Qualit. dello Storico', 'History Quality')
  $vd = CercaCella $t @('Deposito Iniziale', 'Initial Deposit')
  $vk = CercaCella $t @('Ticks')
  if($null -ne $vf){ $r.PF = $vf }
  if($null -ne $vq){ $r.Qualita = $vq }
  if($null -ne $vk -and $vk -match '^[0-9]+$'){ $r.Ticks = [long]$vk }
  if($null -ne $vd -and $vd -match '^-?[0-9]+(\.[0-9]+)?$'){ $r.Deposito = Num $vd }
  $r.Expert  = CercaCella $t @('Expert')
  $r.Simbolo = CercaCella $t @('Simbolo', 'Symbol')
  $r.Periodo = CercaCella $t @('Periodo', 'Period')
  if($null -eq $vt){ $r.Motivo = 'etichetta del totale operazioni (Numero di Operazioni di Trading Totali / Total Trades) NON trovata'; return $r }
  if($null -eq $vp){ $r.Motivo = 'etichetta del profitto netto (Profitto Totale Netto / Total Net Profit) NON trovata'; return $r }
  if($vt -notmatch '^[0-9]+$'){ $r.Motivo = 'totale operazioni non numerico: "' + $vt + '"'; return $r }
  if($vp -notmatch '^-?[0-9]+(\.[0-9]+)?$'){ $r.Motivo = 'profitto netto non numerico: "' + $vp + '"'; return $r }
  $r.Trades = [int]$vt
  $r.Profitto = Num $vp
  $r.Ok = $true
  return $r
}

# ---------------------------------------------------------------------
#  0. LA MACCHINA E IL TERMINALE. Fail-closed, come NATCLA_F0 e GBA_R0.
# ---------------------------------------------------------------------
Titolo '0 - MACCHINA E TERMINALE'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){
  throw ('NATCLA_F1_PASSATE gira SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui la macchina si chiama: ' + $env:COMPUTERNAME + '. Sul VPS VMI3047753 non si lancia: la challenge FTMO sta operando (firma del 21/09/2026: i round girano sul PC di backtest).')
}
Dico ('pc   : ' + $env:COMPUTERNAME) 'Green'
Dico ('pin  : ' + $Pin) 'Green'
Dico ('lotto: ' + $Lotto) 'Green'
foreach($altro in @('Global\ABTG_NATCLA_F0', 'Global\ABTG_GBA_R0')){
  $mx = $null
  if([System.Threading.Mutex]::TryOpenExisting($altro, [ref]$mx)){
    try{ $mx.Dispose() }catch{ }
    throw ('Un giro che tiene il blocco ' + $altro + ' e VIVO su questo PC: un solo giro di tester alla volta (classe 853). Aspetta che finisca, NON chiudere il suo terminale.')
  }
}
$Mutex = New-Object System.Threading.Mutex($false, 'Global\ABTG_NATCLA_F1')
$preso = $false
# un giro precedente interrotto (finestra chiusa, Ctrl+C, crash) lascia il blocco ABBANDONATO: .NET lo segnala con un'eccezione e il blocco e comunque nostro
try{ $preso = $Mutex.WaitOne(0) } catch [System.Threading.AbandonedMutexException] { $preso = $true; Dico 'il blocco Global\ABTG_NATCLA_F1 era stato lasciato da un giro INTERROTTO: lo riprendo (nessun altro giro sta girando)' 'Yellow' }
if(-not $preso){
  throw 'Un ALTRO giro di NATCLA_F1 sta gia girando su questo PC (mutex Global\ABTG_NATCLA_F1 occupato). Un solo giro alla volta: aspetta che finisca, NON chiudere il suo terminale.'
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
# le ALTRE installazioni MT5 di questo PC: il censimento P0 del 05/10/2026 (risultati_archivio/DUKA_P0_20261005_171046/REFERTO_DUKA_P0.txt, sez. 5)
# ne ha trovate DUE oltre al BCM: C:\MT5_Backtest e C:\FundedNext_Manuale. Sono AMMESSE PER NOME (chiuse, non toccate); una NON in elenco ferma tutto (classe 1157).
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
$MqlInc = Join-Path (Join-Path $DataFolder 'MQL5') 'Include'
$MqlFiles = Join-Path (Join-Path $DataFolder 'MQL5') 'Files'
$CommonFiles = Join-Path $env:APPDATA 'MetaQuotes\Terminal\Common\Files'
New-Item -ItemType Directory -Force -Path $MqlExp,$MqlInc | Out-Null
Dico ('terminale: ' + $Terminal) 'Green'
Dico ('dati     : ' + $DataFolder) 'Green'
Dico ('grafici salvati letti: ' + $nChr + ', nessun EA attaccato') 'Green'

# ---------------------------------------------------------------------
#  1. EA, INCLUDE E FILE PROVA AL PIN (SHA256 dalla riga), E COMPILAZIONE VERIFICATA
# ---------------------------------------------------------------------
Titolo '1 - SORGENTI AL PIN E COMPILAZIONE'
$Work = Join-Path $env:USERPROFILE 'abtg_passata'
New-Item -ItemType Directory -Force -Path $Work | Out-Null
$srcEA  = Join-Path $Work ($EXPERT + '.mq5')
$srcInc = Join-Path $Work 'ABTG_PausaGuardian.mqh'
$fileProva = Join-Path $Work $PROVA
Scarica ('mql5/Experts/' + $EXPERT + '.mq5') $srcEA 'NC_VER'
Scarica 'mql5/Include/ABTG_PausaGuardian.mqh' $srcInc 'ABTG_GuardiaIngresso'
Scarica ('backtest_pipeline/prove/' + $PROVA) $fileProva '@F1-LOTTO'
foreach($ck in @(@($srcEA, $ShaEA, 'EA_NatCla.mq5'), @($srcInc, $ShaInc, 'ABTG_PausaGuardian.mqh'), @($fileProva, $ShaProva, $PROVA))){
  $hh = (Get-FileHash -LiteralPath $ck[0] -Algorithm SHA256).Hash
  if($hh -ne $ck[1]){ throw ($ck[2] + ' scaricato al pin ha SHA256 ' + $hh + ' invece di ' + $ck[1] + ' (quello calcolato dal commit): copia sbagliata o cache di GitHub. Non si parte.') }
  Dico ($ck[2] + ': SHA256 ' + $hh.Substring(0,12) + ' = quello della riga') 'Green'
}
if(-not (Select-String -LiteralPath $srcEA -SimpleMatch -Pattern ('#define NC_VER "' + $VERSIONE_ATTESA + '"') -Quiet)){ throw ('il sorgente dell EA non dichiara NC_VER ' + $VERSIONE_ATTESA + '. Non si parte.') }

# --- il file prova: pin, asse tecnico, blocchi F1
$pinProva = New-Object System.Collections.ArrayList
$assi = New-Object System.Collections.ArrayList
$blocchi = @{ CONFIG = @(); SIMBOLO = @(); LOTTO = @(); MODO = @(); LATO = @(); INCL = @(); ATTESA = @() }
foreach($r in (Get-Content -LiteralPath $fileProva)){
  $t = $r.Trim()
  if($t -match '^#\s*@F1-(CONFIG|SIMBOLO|LOTTO|MODO|LATO|INCL|ATTESA)\s+(.*)$'){ $tipoB = $Matches[1]; $corpoB = $Matches[2]; $blocchi[$tipoB] = @($blocchi[$tipoB]) + @((BloccoF1 $corpoB)); continue }
  if($t -eq '' -or $t.StartsWith('#')){ continue }
  if($t -match '^(Inp[A-Za-z0-9_]+)=(.*)$'){
    if($t.EndsWith('||Y')){ [void]$assi.Add($t) } else { [void]$pinProva.Add(@($Matches[1], $Matches[2])) }
  }
}
if($assi.Count -ne 1 -or $assi[0] -ne $ASSE_ATTESO){ throw ('asse del file prova diverso da ' + $ASSE_ATTESO + ': ' + ($assi -join ' ; ')) }
if($pinProva.Count -ne $N_PIN_ATTESI){ throw ('pin letti dal file prova: ' + $pinProva.Count + ' invece di ' + $N_PIN_ATTESI + ': file prova tronco o cambiato. Non si parte.') }
$doppi = @($pinProva | ForEach-Object { $_[0] } | Group-Object | Where-Object { $_.Count -gt 1 })
if($doppi.Count -gt 0){ throw ('parametri DOPPI nel file prova: ' + (($doppi | ForEach-Object { $_.Name }) -join ', ') + '. Non si parte.') }
$pinH = @{}; foreach($pp in $pinProva){ $pinH[$pp[0]] = $pp[1] }
foreach($kk in $SOSTITUITI){ if(-not $pinH.ContainsKey($kk)){ throw ('il file prova non ha il pin ' + $kk + ' (lo script lo sostituisce a ogni passata). Non si parte.') } }
# i pin che decidono se la passata misura la cosa dichiarata: se uno e diverso, il file prova non e quello che lo script si aspetta
$pinFissi = @{ InpSoloConta = 'false'; InpRischioSetupPct = '0.25'; InpStopOltreU = '20.0'; InpVerbose = 'true'; InpLogImbuto = 'true'; InpPlaceboAtr = '0'; InpUnita = '0'; InpTPDistanza = '10'; InpScalaAnticipo = '5'; InpScalaOltre = '5'; InpMaxSetupAperti = '1'; InpDurataMaxMin = '0'; InpTPCriterio = '-1'; InpSLCriterio = '-1'; InpPesiScala = '0'; InpAdxMax = '20'; InpAdxPeriodo = '14'; InpAdxTipo = '0'; InpUsaGuardian = 'true' }
foreach($kk in @($pinFissi.Keys)){
  if(-not $pinH.ContainsKey($kk)){ throw ('il file prova non ha il pin ' + $kk + '. Non si parte.') }
  if($pinH[$kk] -ne $pinFissi[$kk]){ throw ('il pin ' + $kk + ' del file prova e ' + $pinH[$kk] + ' invece di ' + $pinFissi[$kk] + ': la passata non misurerebbe la base dichiarata. Non si parte.') }
}
if(@($blocchi.CONFIG).Count -ne 4 -or @($blocchi.MODO).Count -ne 3 -or @($blocchi.LATO).Count -ne 2 -or @($blocchi.SIMBOLO).Count -ne 11 -or @($blocchi.INCL).Count -ne 12 -or @($blocchi.LOTTO).Count -ne 5){
  throw ('blocchi @F1 letti: config ' + @($blocchi.CONFIG).Count + ' (attese 4), modi ' + @($blocchi.MODO).Count + ' (3), lati ' + @($blocchi.LATO).Count + ' (2), simboli ' + @($blocchi.SIMBOLO).Count + ' (11), incl ' + @($blocchi.INCL).Count + ' (12), lotti ' + @($blocchi.LOTTO).Count + ' (5). Non si parte.')
}
$cfgDef = @{}; foreach($c in $blocchi.CONFIG){ $cfgDef[$c['nome']] = $c }
$modoDef = @{}; foreach($c in $blocchi.MODO){ $modoDef[$c['nome']] = $c }
$latoDef = @{}; foreach($c in $blocchi.LATO){ $latoDef[$c['nome']] = $c }
$simDef = @{}; foreach($c in $blocchi.SIMBOLO){ $simDef[$c['nome']] = $c }
$inclDef = @{}
foreach($c in $blocchi.INCL){
  if($c['soglia'] -notmatch '^[0-9]+\.[0-9]{3}$'){ throw ('soglia @F1-INCL non a 3 decimali col punto: ' + $c['famiglia'] + ' ' + $c['config'] + ' ' + $c['soglia']) }
  $chiave = $c['famiglia'] + '|' + $c['config']
  if($inclDef.ContainsKey($chiave)){ throw ('soglia @F1-INCL doppia per ' + $chiave) }
  $inclDef[$chiave] = $c['soglia']
}
foreach($s in $blocchi.SIMBOLO){
  if($s['da'] -notmatch '^\d{4}\.\d\d\.\d\d$'){ throw ('simbolo ' + $s['nome'] + ': data d inizio non aaaa.mm.gg.') }
  if([string]::CompareOrdinal($s['da'], $DATA_A) -ge 0){ throw ('simbolo ' + $s['nome'] + ': finestra VUOTA (' + $s['da'] + ' -> ' + $DATA_A + ').') }
  foreach($cn in @($cfgDef.Keys)){ if(-not $inclDef.ContainsKey($s['famiglia'] + '|' + $cn)){ throw ('manca la soglia @F1-INCL per famiglia ' + $s['famiglia'] + ' config ' + $cn) } }
}
$lottoDef = @($blocchi.LOTTO | Where-Object { $_['nome'] -eq $Lotto })
if($lottoDef.Count -ne 1){ throw ('lotto ' + $Lotto + ' non trovato (o doppio) nel file prova.') }
$lottoDef = $lottoDef[0]
$tettoMin = [int]$lottoDef['tetto_min']
$runs = New-Object System.Collections.ArrayList
$saltati = 0
function AggiungiPassata($sn, $cn, $ln, $mn){
  if(-not $simDef.ContainsKey($sn)){ throw ('simbolo ' + $sn + ' del lotto ' + $Lotto + ' senza blocco @F1-SIMBOLO.') }
  if(-not $cfgDef.ContainsKey($cn)){ throw ('config ' + $cn + ' del lotto ' + $Lotto + ' inesistente.') }
  if(-not $latoDef.ContainsKey($ln)){ throw ('lato ' + $ln + ' del lotto ' + $Lotto + ' inesistente.') }
  if(-not $modoDef.ContainsKey($mn)){ throw ('modo ' + $mn + ' del lotto ' + $Lotto + ' inesistente.') }
  [void]$runs.Add([pscustomobject]@{ Sim = $simDef[$sn]; Cfg = $cfgDef[$cn]; Lato = $latoDef[$ln]; Modo = $modoDef[$mn]; Soglia = $inclDef[$simDef[$sn]['famiglia'] + '|' + $cn] })
}
if($lottoDef.ContainsKey('passate')){
  if($lottoDef.ContainsKey('simboli') -or $lottoDef.ContainsKey('configs') -or $lottoDef.ContainsKey('lati') -or $lottoDef.ContainsKey('modi')){ throw ('lotto ' + $Lotto + ': o passate=, o simboli/configs/lati/modi, mai tutte e due.') }
  foreach($voce in ($lottoDef['passate'] -split ',')){
    $pz = $voce -split ':'
    if($pz.Count -ne 4){ throw ('voce di passata malformata (attesa SIM:CFG:LATO:MODO): ' + $voce) }
    if((($cfgDef[$pz[1]]['modi']) -split ',') -notcontains $pz[3]){ throw ('passata ' + $voce + ': la config ' + $pz[1] + ' non ammette il modo ' + $pz[3]) }
    AggiungiPassata $pz[0] $pz[1] $pz[2] $pz[3]
  }
} else {
  foreach($kk in @('simboli','configs','lati','modi')){ if(-not $lottoDef.ContainsKey($kk)){ throw ('lotto ' + $Lotto + ': manca ' + $kk + '=') } }
  foreach($sn in ($lottoDef['simboli'] -split ',')){
    foreach($cn in ($lottoDef['configs'] -split ',')){
      if(-not $cfgDef.ContainsKey($cn)){ throw ('config ' + $cn + ' del lotto ' + $Lotto + ' inesistente.') }
      $ammessi = ($cfgDef[$cn]['modi']) -split ','
      foreach($ln in ($lottoDef['lati'] -split ',')){
        foreach($mn in ($lottoDef['modi'] -split ',')){
          if($ammessi -notcontains $mn){ $saltati = $saltati + 1; continue }
          AggiungiPassata $sn $cn $ln $mn
        }
      }
    }
  }
}
$visti = @{}
foreach($ru in $runs){ $kv = $ru.Sim['nome'] + '|' + $ru.Cfg['nome'] + '|' + $ru.Lato['nome'] + '|' + $ru.Modo['nome']; if($visti.ContainsKey($kv)){ throw ('passata DOPPIA nel lotto: ' + $kv) }; $visti[$kv] = $true }
Dico ('file prova letto: ' + $pinProva.Count + ' pin + asse tecnico; lotto ' + $Lotto + ': ' + $runs.Count + ' passate (modi non ammessi dalla config saltati: ' + $saltati + '), Modello ' + $MODELLO + ', deposito ' + $DEPOSITO + ' EUR, tetto ' + $tettoMin + ' minuti') 'Green'

Copy-Item -LiteralPath $srcEA  -Destination (Join-Path $MqlExp ($EXPERT + '.mq5')) -Force
Copy-Item -LiteralPath $srcInc -Destination (Join-Path $MqlInc 'ABTG_PausaGuardian.mqh') -Force

$ex5 = Join-Path $MqlExp ($EXPERT + '.ex5')
$logC = Join-Path $Work 'compile_natcla_f1.log'
# il verdetto NON e' il codice d'uscita di MetaEditor (a volte si stacca): e' l'esistenza dell'.ex5 appena prodotto. Ogni argomento fra parentesi (classe 1152).
# COMPILAZIONE FALLITA: e' la PRIMA compilazione vera della v1.11 (v1.10/v1.11 mai compilate). Il log di MetaEditor va in uno zip sul Desktop.
function FermaCompilazione($perche){
  $dskC  = [Environment]::GetFolderPath('Desktop')
  $CartC = Join-Path $dskC ('NATCLA_F1_' + $Lotto + '_COMPILAZIONE_FALLITA')
  $zipC  = $CartC + '.zip'
  $stC   = (Get-Date).ToString('yyyyMMdd_HHmmss')
  try{
    if(Test-Path -LiteralPath $CartC){ Move-Item -LiteralPath $CartC -Destination ($CartC + '_VECCHIA_' + $stC) -Force }
    if(Test-Path -LiteralPath $zipC){ Move-Item -LiteralPath $zipC -Destination ($CartC + '_VECCHIO_' + $stC + '.zip') -Force }
    New-Item -ItemType Directory -Force -Path $CartC | Out-Null
    $haLog = Test-Path -LiteralPath $logC
    $righeLog = @()
    if($haLog){
      Copy-Item -LiteralPath $logC -Destination (Join-Path $CartC 'compile_natcla_f1.log') -Force
      $righeLog = @(((Leggi-Condiviso $logC) -split "`r?`n") | Where-Object { $_ -match '(?i)error|errori|warning|avvis|result|risultato' } | Select-Object -First 60)
    }
    $testaC = @(('NATCLA F1 lotto ' + $Lotto + ': COMPILAZIONE DI EA_NatCla v' + $VERSIONE_ATTESA + ' FALLITA. Nessuna passata lanciata, nessun ordine.'), ('motivo: ' + $perche), ('pin: ' + $Pin + '   pc: ' + $env:COMPUTERNAME + '   data: ' + $stC), ('log di MetaEditor presente: ' + $haLog), '', 'righe di errore/avviso del log (il log intero e compile_natcla_f1.log):')
    (($testaC + $righeLog) -join "`r`n") | Set-Content -LiteralPath (Join-Path $CartC 'COMPILAZIONE_FALLITA.txt') -Encoding ASCII
    Compress-Archive -Path (Join-Path $CartC '*') -DestinationPath $zipC -Force
    Write-Host ('   ZIP DA MANDARE (compilazione fallita): ' + $zipC) -ForegroundColor Red
  } catch { Write-Host ('   zip della compilazione NON creato (' + $_.Exception.Message + '): il log e in ' + $logC) -ForegroundColor Red }
  throw ('COMPILAZIONE FALLITA: ' + $perche + ' Nessuna passata e partita. Manda lo zip NATCLA_F1_' + $Lotto + '_COMPILAZIONE_FALLITA.zip dal Desktop.')
}
Remove-Item -LiteralPath $logC -Force -ErrorAction SilentlyContinue
Remove-Item -LiteralPath $ex5 -Force -ErrorAction SilentlyContinue
# classe 1168 (i): un .ex5 VECCHIO (v1.05 di F0) che resta sul disco passerebbe per il compilato nuovo
if(Test-Path -LiteralPath $ex5){ FermaCompilazione 'il vecchio .ex5 non si cancella: un compilato vecchio passerebbe per nuovo.' }
$pMe = Start-Process -FilePath $MetaEditor -ArgumentList @(('/compile:' + (Join-Path $MqlExp ($EXPERT + '.mq5'))), ('/log:' + $logC)) -PassThru
$attC = 0
while(-not (Test-Path -LiteralPath $ex5) -and $attC -lt 60){ Start-Sleep -Seconds 2; $attC = $attC + 1 }
if(-not (Test-Path -LiteralPath $ex5)){
  try{ if(-not $pMe.HasExited){ $pMe.Kill() } }catch{ }
  if(Test-Path -LiteralPath $logC){ (Leggi-Condiviso $logC) -split "`r?`n" | Select-Object -Last 20 | ForEach-Object { Write-Host ('     ' + $_) -ForegroundColor DarkYellow } }
  FermaCompilazione ($EXPERT + '.ex5 NON prodotto dopo 120 secondi. Senza il compilato il giro non parte: il log di MetaEditor e qui sopra.')
}
# classe 1168 (ii): si aspetta che MetaEditor ESCA prima di leggere il log (al massimo 60 secondi)
$attE = 0
while(-not $pMe.HasExited -and $attE -lt 30){ Start-Sleep -Seconds 2; $attE = $attE + 1 }
Start-Sleep -Seconds 3
$testoLogC = ''
if(Test-Path -LiteralPath $logC){ $testoLogC = Leggi-Condiviso $logC }
$compErr = -1; $compWarn = -1
# classe 1168 (iii): la riga del risultato in inglese e in italiano, anche al singolare
$mRes = [regex]::Match($testoLogC, '(\d+)\s+(?:errors?|errori|errore),\s*(\d+)\s+(?:warnings?|avvisi|avviso)')
if($mRes.Success){ $compErr = [int]$mRes.Groups[1].Value; $compWarn = [int]$mRes.Groups[2].Value }
if($compErr -gt 0){
  ($testoLogC -split "`r?`n") | Where-Object { $_ -match '(?i)error|errori' } | Select-Object -First 20 | ForEach-Object { Write-Host ('     ' + $_) -ForegroundColor DarkYellow }
  FermaCompilazione ('MetaEditor ha prodotto l.ex5 ma il log dice ' + $compErr + ' errori: non si usa un compilato dubbio.')
}
Dico ('compilato: ' + $ex5 + '   SHA256 .ex5 ' + (Get-FileHash -LiteralPath $ex5 -Algorithm SHA256).Hash.Substring(0,12)) 'Green'
if($compErr -eq 0){ Dico ('log di compilazione: 0 errori, ' + $compWarn + ' avvisi') $(if($compWarn -eq 0){'Green'}else{'Yellow'}) }
else { Dico 'log di compilazione: riga del risultato NON letta (formato diverso?): il verdetto e l esistenza dell .ex5 appena prodotto (quello vecchio e stato cancellato prima)' 'Yellow' }
foreach($lw in @(($testoLogC -split "`r?`n") | Where-Object { $_ -match '(?i)warning|avviso|avvisi' -and $_ -notmatch '\d+\s+(?:errors?|errori|errore),' } | Select-Object -First 12)){ Dico ('   ' + $lw) 'Yellow' }

# ---------------------------------------------------------------------
#  2. LE PASSATE SINGOLE (Optimization=0, Modello 4, ordini SOLO nel tester)
# ---------------------------------------------------------------------
$dsk  = [Environment]::GetFolderPath('Desktop')
$Cart = Join-Path $dsk ('NATCLA_F1_' + $Lotto)
$zip  = Join-Path $dsk ('NATCLA_F1_' + $Lotto + '.zip')
$stampa = (Get-Date).ToString('yyyyMMdd_HHmmss')
if(Test-Path -LiteralPath $Cart){ Move-Item -LiteralPath $Cart -Destination ($Cart + '_VECCHIA_' + $stampa) -Force; Dico ('cartella di un giro PRECEDENTE rinominata: ' + $Cart + '_VECCHIA_' + $stampa) 'Yellow' }
if(Test-Path -LiteralPath $zip){ Move-Item -LiteralPath $zip -Destination (Join-Path $dsk ('NATCLA_F1_' + $Lotto + '_VECCHIO_' + $stampa + '.zip')) -Force; Dico ('zip di un giro PRECEDENTE rinominato con la data') 'Yellow' }
New-Item -ItemType Directory -Force -Path $Cart | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $Cart 'csv'), (Join-Path $Cart 'trades'), (Join-Path $Cart 'report'), (Join-Path $Cart 'log'), (Join-Path $Cart 'ini') | Out-Null
Copy-Item -LiteralPath $fileProva -Destination $Cart -Force
if(Test-Path -LiteralPath $logC){ Copy-Item -LiteralPath $logC -Destination (Join-Path $Cart 'compile_natcla_f1.log') -Force }

$LogRoot = Join-Path $env:APPDATA 'MetaQuotes'
$RadiciLog = @($LogRoot, (Join-Path $InstAttesa 'Tester'))
$reAvvio = New-Object Text.RegularExpressions.Regex("^\[NatCla\] AVVIO v(?<v>[0-9.]+) \| modalita' (?<mod>\w+) \| (?<sym>\S+) PERIOD_(?<tf>\w+) \| 1 u = (?<u>[0-9.]+) \((?<descr>.*?)\) \| 1 pip = (?<pip>[0-9.]+) \| magic (?<mg>[0-9]+) \| linee (?<linee>.*?)\s*\| ADX (?<adx>ACCESO|spento), (?<tipo>iADX MetaQuotes|iADXWilder), max (?<max>[0-9.]+), periodo (?<per>[0-9]+) \| ingresso (?<ing>\w+) \| rischio setup (?<risk>[0-9.]+)% .*?\| guardian .*?\| solo conta (?<sc>\w+) \| placebo (?<pl>[0-9.]+) ATR(?<resto>.*)$")
$reVerifica = New-Object Text.RegularExpressions.Regex('^\[NatCla\] VERIFICA ADX barra (?<barra>\d{4}\.\d\d\.\d\d \d\d:\d\d) .*il terminale coincide con: (?<chi>.*)$')
$reRiga = New-Object Text.RegularExpressions.Regex('(?<st>\d{4}\.\d\d\.\d\d \d\d:\d\d:\d\d)\s+(?<msg>\[(?:NatCla|NATCLA-IMBUTO)\].*)$')
$reFin = New-Object Text.RegularExpressions.Regex(('Tester\s+(?<sim>[A-Za-z0-9_.#-]+),(?<tf>[A-Za-z0-9]+)(?:\s+\([^)]*\))?:\s+testing of Experts\\' + [regex]::Escape($EXPERT) + '\.ex5 from (?<da>\d{4}\.\d\d\.\d\d) (?<ha>\d\d:\d\d) to (?<a>\d{4}\.\d\d\.\d\d) (?<hb>\d\d:\d\d)'), [Text.RegularExpressions.RegexOptions]::IgnoreCase)
$reBarre = New-Object Text.RegularExpressions.Regex('(?<sim>[A-Za-z0-9_.#-]+),(?<tf>[A-Za-z0-9]+): (?<tick>\d+) ticks, (?<barre>\d+) bars generated')
$reTickIni = New-Object Text.RegularExpressions.Regex('(?<sim>[A-Za-z0-9_.#-]+): ticks data begins from (?<d>\d{4}\.\d\d\.\d\d)')
$reInvio = New-Object Text.RegularExpressions.Regex('^\[NatCla\] INVIO FALLITO (?<cm>\S+): retcode (?<rc>\d+)')

# la scoperta ricorsiva dei .log si fa UNA VOLTA a inizio lotto e ricorda le CARTELLE (NATCLA_F0, deviazione 11)
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
  # i log di MT5 sono UTF-16 LE con BOM: la codifica si legge dal BOM all'inizio del FILE, poi si salta all'offset registrato prima della passata
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
# i controlli dell'AVVIO, uno per uno, contro la passata (config, simbolo, modo)
function ControllaAvvio($ma, $cfg, $sim, $modo){
  $mot = New-Object System.Collections.ArrayList
  $G = $ma.Groups
  if($G['v'].Value -ne $VERSIONE_ATTESA){ [void]$mot.Add('versione EA ' + $G['v'].Value + ' invece di ' + $VERSIONE_ATTESA) }
  $modAtt = 'AUDIO'; if($cfg['modalita'] -eq '2'){ $modAtt = 'EMA200' }
  if($G['mod'].Value -ne $modAtt){ [void]$mot.Add('modalita ' + $G['mod'].Value + ' invece di ' + $modAtt) }
  if($G['sym'].Value -ne $sim['nome']){ [void]$mot.Add('simbolo ' + $G['sym'].Value + ' invece di ' + $sim['nome']) }
  if($G['tf'].Value -ne $cfg['periodo']){ [void]$mot.Add('TF PERIOD_' + $G['tf'].Value + ' invece di PERIOD_' + $cfg['periodo']) }
  if($G['mg'].Value -ne $cfg['magic']){ [void]$mot.Add('magic ' + $G['mg'].Value + ' invece di ' + $cfg['magic']) }
  $lnL = (@($G['linee'].Value -split '\s+' | Where-Object { $_ -ne '' }) -join ',')
  if($lnL -ne $cfg['linee']){ [void]$mot.Add('linee ' + $lnL + ' invece di ' + $cfg['linee']) }
  if($G['adx'].Value -ne $cfg['adx']){ [void]$mot.Add('ADX ' + $G['adx'].Value + ' invece di ' + $cfg['adx']) }
  if($G['tipo'].Value -ne 'iADX MetaQuotes'){ [void]$mot.Add('tipo ADX ' + $G['tipo'].Value + ' invece di iADX MetaQuotes') }
  if((Num $G['max'].Value) -ne 20.0 -or [int]$G['per'].Value -ne 14){ [void]$mot.Add('ADX max/periodo ' + $G['max'].Value + '/' + $G['per'].Value + ' invece di 20/14') }
  if($G['ing'].Value -ne 'SCALA3_PENDENTI'){ [void]$mot.Add('ingresso ' + $G['ing'].Value + ' invece di SCALA3_PENDENTI') }
  if((Num $G['risk'].Value) -ne 0.25){ [void]$mot.Add('rischio setup ' + $G['risk'].Value + ' invece di 0.25') }
  if($G['sc'].Value -ne 'no'){ [void]$mot.Add('solo conta ' + $G['sc'].Value + ' invece di no: NESSUN ORDINE, nessun merito') }
  if((Num $G['pl'].Value) -ne 0.0){ [void]$mot.Add('placebo ' + $G['pl'].Value + ' invece di 0') }
  # lo stop sta in CODA alla riga AVVIO (v1.10): se la copia del giornale e' TRONCATA (classe 1173) il pezzo manca; allora lo dicono la riga CFG Stop e il #AVVIO del CSV, controllati a parte
  $stopAtt = $modo['avvio']; if($modo['avvio'] -ne 'GEOMETRIA_ATTUALE'){ $stopAtt = $modo['avvio'] + ' ' + $STOP_U + ' u' }
  $resto = $G['resto'].Value
  $iSt = $resto.IndexOf('| stop ', [StringComparison]::Ordinal)
  if($iSt -ge 0){ $stopLetto = $resto.Substring($iSt + 7).Trim(); if($stopLetto -ne $stopAtt){ [void]$mot.Add('stop ' + $stopLetto + ' invece di ' + $stopAtt) } }
  $uAtt = Num $sim['u']
  if([math]::Abs((Num $G['u'].Value) - $uAtt) -gt 1e-9){ [void]$mot.Add('1 u = ' + $G['u'].Value + ' invece di ' + $sim['u'] + ' (classe ' + $sim['classe'] + ')') }
  $dsc = $G['descr'].Value
  $dAtt = 'AUTO_CLASSE forex'
  if($sim['classe'] -eq 'ORO'){ $dAtt = 'AUTO_CLASSE metallo' }
  if($sim['classe'] -eq 'IDX'){ $dAtt = 'AUTO_CLASSE indice/CFD' }
  if(-not $dsc.StartsWith($dAtt)){ [void]$mot.Add('descrizione unita "' + $dsc + '" non comincia per ' + $dAtt) }
  return ,$mot
}
# un file scritto DOPO l'avvio della passata: Common\Files, MQL5\Files, poi gli agenti locali (percorso con caratteri jolly, nessuna ricorsione sui tick)
function TrovaFresco($nome, $tDa){
  foreach($d0 in @($CommonFiles, $MqlFiles)){
    $p = Join-Path $d0 $nome
    if(Test-Path -LiteralPath $p){ $it = Get-Item -LiteralPath $p; if($it.LastWriteTime -ge $tDa){ return $it } }
  }
  $ag = Join-Path $LogRoot 'Tester'
  foreach($it in @(Get-ChildItem -Path (Join-Path $ag ('*\Agent-*\MQL5\Files\' + $nome)) -File -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -ge $tDa } | Sort-Object LastWriteTime -Descending)){ return $it }
  return $null
}

Titolo ('2 - LOTTO ' + $Lotto + ': ' + $runs.Count + ' PASSATE SINGOLE (Modello 4 = tick reali, deposito ' + $DEPOSITO + ' EUR, ordini SOLO nel tester)')
$TLotto = Get-Date
$manifest = New-Object System.Collections.ArrayList
[void]$manifest.Add('lotto;passata;simbolo;config;lato;modo;magic;soglia_incl;da;a;t_avvio;durata_s;stato;trades_report;profitto_report;pf_report;qualita;deposito;ticks_report;barre_gen;ticks_inizio;setup_righe;riempiti_somma;soldi_somma;invio_fallito;lotto_min;semaforo;imbuto_rotte;righe_ea;avvio_ok;adx_verifica;finestra;motivi')
# la coda di una riga NON_LANCIATA dopo le 10 colonne della passata: t_avvio vuoto, durata 0, stato, 16 colonne vuote (trades_report..righe_ea), avvio_ok no, adx e finestra vuote, poi il motivo (33 colonne in tutto)
$codaNonLanciata = ';;0;NON_LANCIATA' + (';' * 16) + ';no;;;'
$nOk = 0; $nKo = 0; $nNon = 0; $sommaDur = 0.0; $nDur = 0
$abort = $false
$k = 0
foreach($ru in $runs){
  $k = $k + 1
  $sim = $ru.Sim; $cfg = $ru.Cfg; $lato = $ru.Lato; $modo = $ru.Modo
  $tag = $Lotto + '_' + $k.ToString('000') + '_' + $sim['nome'] + '_' + $cfg['nome'] + '_' + $lato['nome'] + '_' + $modo['nome']
  $etich = '[' + $k + '/' + $runs.Count + '] ' + $sim['nome'] + ' ' + $cfg['nome'] + ' ' + $lato['nome'] + ' ' + $modo['nome']
  $base = $Lotto + ';' + $tag + ';' + $sim['nome'] + ';' + $cfg['nome'] + ';' + $lato['nome'] + ';' + $modo['nome'] + ';' + $cfg['magic'] + ';' + $ru.Soglia + ';' + $sim['da'] + ';' + $DATA_A
  $minDa = ((Get-Date) - $TLotto).TotalMinutes
  if($abort -or $minDa -ge $tettoMin){
    $nNon = $nNon + 1
    $why = 'tetto di ' + $tettoMin + ' minuti'; if($abort){ $why = 'lotto fermato' }
    [void]$manifest.Add($base + $codaNonLanciata + $why)
    Write-Host ('   ' + $etich + '  NON LANCIATA (' + $why + ', minuto ' + [int]$minDa + ')') -ForegroundColor Red
    continue
  }
  if((@(Get-Process -Name terminal64 -ErrorAction SilentlyContinue)).Count -gt 0){
    Write-Host ('   ' + $etich + '  un terminal64 e ancora VIVO prima della passata: il lotto si ferma, non apro un secondo terminale.') -ForegroundColor Red
    $abort = $true; $nNon = $nNon + 1
    [void]$manifest.Add($base + $codaNonLanciata + 'terminale ancora vivo')
    continue
  }
  # --- l'ini: i 73 pin del file prova, con SOLO i cinque input della passata sostituiti, e il magic automatico (primo valore dell'asse tecnico)
  $righeIn = New-Object System.Collections.ArrayList
  foreach($pp in $pinProva){
    $val = $pp[1]
    if($pp[0] -eq 'InpModalita'){ $val = $cfg['modalita'] }
    if($pp[0] -eq 'InpTF'){ $val = $cfg['tf'] }
    if($pp[0] -eq 'InpDirezione'){ $val = $lato['valore'] }
    if($pp[0] -eq 'InpStopModo'){ $val = $modo['valore'] }
    if($pp[0] -eq 'InpInclMinAtr'){ $val = $ru.Soglia }
    [void]$righeIn.Add($pp[0] + '=' + $val)
  }
  [void]$righeIn.Add('InpMagic=0')
  $nomeRep = 'NATCLA_F1_' + $tag
  $iniF = Join-Path $Work ('f1_' + $tag + '.ini')
  $testoIni = "[Experts]`r`nAllowLiveTrading=false`r`nAllowDllImport=false`r`n`r`n" +
              "[Tester]`r`nExpert=" + $EXPERT + ".ex5`r`nSymbol=" + $sim['nome'] + "`r`nPeriod=" + $cfg['periodo'] + "`r`nModel=" + $MODELLO + "`r`n" +
              "Optimization=0`r`nFromDate=" + $sim['da'] + "`r`nToDate=" + $DATA_A + "`r`nForwardMode=0`r`nDeposit=" + $DEPOSITO + "`r`nCurrency=EUR`r`nLeverage=100`r`n" +
              "ExecutionMode=0`r`nReplaceReport=1`r`nShutdownTerminal=1`r`nReport=" + $nomeRep + "`r`n`r`n" +
              "[TesterInputs]`r`n" + ($righeIn -join "`r`n") + "`r`n"
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
    if(-not $p.HasExited){ $abort = $true; Write-Host '   il terminale NON si e chiuso: il lotto si ferma qui, la riga NON lo chiude con la forza (guarda i grafici e chiudilo A MANO).' -ForegroundColor Red }
  }
  Start-Sleep -Seconds 8   # l'agente del tester scarica i log su disco dopo la chiusura
  $dur = ((Get-Date) - $tRun).TotalSeconds

  # --- lettura delle sole righe scritte DOPO la fotografia (dedupe per ora simulata + primi 70 caratteri, si tiene la piu' lunga: classe 1173)
  $eaMsg = @{}; $eaSt = @{}; $eaOrd = New-Object System.Collections.ArrayList; $nGrezze = 0
  $fin = @{}; $evTester = @{}; $barreGen = $null; $tickGen = $null; $tickIni = @{}; $illeggibili = 0; $nSoldi = 0
  foreach($f in @(ElencoLog)){
    $off = 0; if($foto.ContainsKey($f.FullName)){ $off = [long]$foto[$f.FullName] }
    if($f.Length -le $off){ continue }
    try{ $testo = LeggiCoda $f.FullName $off }catch{ $illeggibili = $illeggibili + 1; continue }
    foreach($riga in ($testo -split "`r?`n")){
      if($riga.Length -lt 12){ continue }
      $mr = $reRiga.Match($riga)
      if($mr.Success){
        $nGrezze = $nGrezze + 1
        $msg = $mr.Groups['msg'].Value.TrimEnd()
        $st = $mr.Groups['st'].Value
        $kk2 = $st + '|' + $msg
        if(-not $eaMsg.ContainsKey($kk2)){ $eaMsg[$kk2] = $msg; $eaSt[$kk2] = $st; [void]$eaOrd.Add($kk2) }
        continue
      }
      # deposito/margine esaurito o ordine rifiutato per soldi: n e PF della passata sarebbero TRONCATI in silenzio (classe 1204)
      if($riga -match '(?i)stop out|no money|not enough money'){ $nSoldi = $nSoldi + 1; if($evTester.Count -lt 60){ $evTester[$riga.Trim()] = $true }; continue }
      $mf = $reFin.Match($riga)
      if($mf.Success){ $fin[($mf.Groups['sim'].Value + '|' + $mf.Groups['tf'].Value + '|' + $mf.Groups['da'].Value + '|' + $mf.Groups['ha'].Value + '|' + $mf.Groups['a'].Value + '|' + $mf.Groups['hb'].Value)] = $mf; continue }
      $mb = $reBarre.Match($riga)
      if($mb.Success -and $mb.Groups['sim'].Value -eq $sim['nome']){ $barreGen = [long]$mb.Groups['barre'].Value; $tickGen = [long]$mb.Groups['tick'].Value; $evTester[$riga.Trim()] = $true; continue }
      $mt = $reTickIni.Match($riga)
      if($mt.Success){ $tickIni[$mt.Groups['sim'].Value + ' ' + $mt.Groups['d'].Value] = $true; $evTester[$riga.Trim()] = $true; continue }
      if($evTester.Count -lt 60 -and $riga -match "`tTester`t" -and $riga -match '(?i)history|no data|cannot|failed|error|stopped|not found|disconnect|authoriz|synchron|download|no memory|final balance|Test passed'){ $evTester[$riga.Trim()] = $true }
    }
  }
  # classe 1173: la stessa riga puo' stare in DUE log, una TRONCATA. Nella stessa ora simulata, una riga che e' PREFISSO di un'altra piu' lunga e' la sua
  # copia troncata e si toglie (si tiene la piu' lunga). Il confronto e' per PREFISSO e non sui primi N caratteri: una riga corta troncata ha un'altra chiave.
  $perSt = @{}
  foreach($kq in $eaOrd){ $s0 = $eaSt[$kq]; if(-not $perSt.ContainsKey($s0)){ $perSt[$s0] = New-Object System.Collections.ArrayList }; [void]$perSt[$s0].Add($kq) }
  $tronche = @{}
  foreach($s0 in @($perSt.Keys)){
    if($perSt[$s0].Count -lt 2){ continue }
    $grp = @($perSt[$s0] | Sort-Object -Property @{ Expression = { $eaMsg[$_].Length } } -Descending)
    $tenute = New-Object System.Collections.ArrayList
    foreach($kq in $grp){
      $mq = $eaMsg[$kq]; $tr = $false
      foreach($kt in $tenute){ $mt2 = $eaMsg[$kt]; if($mt2.Length -gt $mq.Length -and $mt2.StartsWith($mq, [StringComparison]::Ordinal)){ $tr = $true; break } }
      if($tr){ $tronche[$kq] = $true } else { [void]$tenute.Add($kq) }
    }
  }
  $eaOrd2 = New-Object System.Collections.ArrayList
  foreach($kq in $eaOrd){ if(-not $tronche.ContainsKey($kq)){ [void]$eaOrd2.Add($kq) } }
  $eaOrd = $eaOrd2
  $motivi = New-Object System.Collections.ArrayList
  if($timeout){ [void]$motivi.Add('timeout di ' + $TimeoutRunMin + ' minuti') }
  # --- il giornale dell'EA: AVVIO, CFG, VERIFICA ADX, rete delle uscite silenziose
  $avvi = New-Object System.Collections.ArrayList; $ver = New-Object System.Collections.ArrayList
  $nInvio = 0; $nInvioSoldi = 0; $nLottoMin = 0; $nSemaforo = 0; $nImbRotte = 0; $nRifiuti = 0
  $cfgDirOk = $false; $cfgInclOk = $false; $cfgStopOk = $false
  $stopAtt = $modo['avvio']; if($modo['avvio'] -ne 'GEOMETRIA_ATTUALE'){ $stopAtt = $modo['avvio'] + ' ' + $STOP_U + ' u' }
  $inclAtt = '[NatCla] CFG Inclinazione = ACCESA, N 20, soglia ' + $ru.Soglia + ' ATR, verso NC_INCL_QUALSIASI'
  foreach($kk2 in $eaOrd){
    $m3 = $eaMsg[$kk2]
    if($m3.StartsWith('[NatCla] AVVIO v', [StringComparison]::Ordinal)){ [void]$avvi.Add($m3); continue }
    if($m3.StartsWith('[NatCla] VERIFICA ADX', [StringComparison]::Ordinal)){ [void]$ver.Add($m3); continue }
    if($m3.StartsWith('[NatCla] CFG InpDirezione = ', [StringComparison]::Ordinal)){ if($m3.StartsWith('[NatCla] CFG InpDirezione = ' + $lato['cfg'] + ' ', [StringComparison]::Ordinal)){ $cfgDirOk = $true } else { [void]$motivi.Add('CFG InpDirezione diversa da ' + $lato['cfg'] + ': ' + $m3.Substring(0, [math]::Min(90, $m3.Length))) } ; continue }
    if($m3.StartsWith('[NatCla] CFG Inclinazione = ', [StringComparison]::Ordinal)){ if($m3.StartsWith($inclAtt, [StringComparison]::Ordinal)){ $cfgInclOk = $true } else { [void]$motivi.Add('CFG Inclinazione diversa da soglia ' + $ru.Soglia + ': ' + $m3.Substring(0, [math]::Min(110, $m3.Length))) } ; continue }
    if($m3.StartsWith('[NatCla] CFG Stop = ', [StringComparison]::Ordinal)){ if($m3.StartsWith('[NatCla] CFG Stop = ' + $stopAtt + ' ', [StringComparison]::Ordinal)){ $cfgStopOk = $true } else { [void]$motivi.Add('CFG Stop diverso da ' + $stopAtt) } ; continue }
    $mi = $reInvio.Match($m3)
    if($mi.Success){ $nInvio = $nInvio + 1; if($mi.Groups['rc'].Value -eq '10019'){ $nInvioSoldi = $nInvioSoldi + 1 }; continue }
    if($m3.IndexOf('lotto sotto il minimo', [StringComparison]::Ordinal) -ge 0){ $nLottoMin = $nLottoMin + 1; continue }
    if($m3.IndexOf('SEMAFORO SFORATO', [StringComparison]::Ordinal) -ge 0){ $nSemaforo = $nSemaforo + 1; continue }
    if($m3.StartsWith('[NATCLA-IMBUTO]', [StringComparison]::Ordinal)){ if($m3.IndexOf('quadratura ROTTA', [StringComparison]::Ordinal) -ge 0){ $nImbRotte = $nImbRotte + 1 }; continue }
    if($m3 -match '^\[NatCla\] (AVVIO RIFIUTATO|ERRORE)'){ $nRifiuti = $nRifiuti + 1; if($nRifiuti -le 3){ [void]$motivi.Add('EA: ' + $m3.Substring(0, [math]::Min(140, $m3.Length))) } }
  }
  $avvioOk = 'no'
  if($avvi.Count -eq 0){ [void]$motivi.Add('riga AVVIO dell EA NON trovata nei log (l EA non e partito? compilazione? ini ignorata?)') }
  elseif($avvi.Count -gt 1){ [void]$motivi.Add('PIU righe AVVIO distinte (' + $avvi.Count + '): log di due passate mescolati') }
  else {
    $ma = $reAvvio.Match($avvi[0])
    if(-not $ma.Success){ [void]$motivi.Add('riga AVVIO in un formato che lo script non riconosce: ' + $avvi[0].Substring(0, [math]::Min(140, $avvi[0].Length))) }
    else {
      $mm = ControllaAvvio $ma $cfg $sim $modo   # la funzione torna ,$mot (ArrayList intera): SENZA @() qui (classe 237/62)
      if($mm.Count -eq 0){ $avvioOk = 'si' } else { foreach($x in $mm){ [void]$motivi.Add('AVVIO: ' + $x) } }
    }
  }
  if(-not $cfgDirOk){ [void]$motivi.Add('riga CFG InpDirezione = ' + $lato['cfg'] + ' NON trovata: il lato della passata non e verificato') }
  if(-not $cfgInclOk){ [void]$motivi.Add('riga CFG Inclinazione con soglia ' + $ru.Soglia + ' NON trovata: la base P50 non e verificata') }
  if(-not $cfgStopOk){ [void]$motivi.Add('riga CFG Stop = ' + $stopAtt + ' NON trovata') }
  $adxV = 'assente'
  if($ver.Count -eq 1){
    $mv = $reVerifica.Match($ver[0])
    if($mv.Success){ $chi = $mv.Groups['chi'].Value; if($chi -like 'formula MetaQuotes*'){ $adxV = 'MetaQuotes' } elseif($chi -like 'formula di Wilder*'){ $adxV = 'Wilder' } else { $adxV = 'NESSUNA' } }
    else { $adxV = 'illeggibile' }
    if($adxV -ne 'MetaQuotes'){ [void]$motivi.Add('VERIFICA ADX: il terminale coincide con ' + $adxV + ': FERMARSI, nessun numero di ADX si legge') }
  } elseif($ver.Count -eq 0){ [void]$motivi.Add('riga VERIFICA ADX NON trovata (l EA non ha mai avuto dati sufficienti: 300 barre del TF)') }
  else { [void]$motivi.Add('PIU righe VERIFICA ADX distinte') }
  if($nSoldi -gt 0 -or $nInvioSoldi -gt 0){ [void]$motivi.Add('SOLDI/MARGINE: ' + $nSoldi + ' righe stop out / no money nel giornale e ' + $nInvioSoldi + ' INVIO FALLITO con retcode 10019: n e PF di questa passata sono TRONCATI') }
  if($nLottoMin -gt 0){ [void]$motivi.Add('LOTTO SOTTO IL MINIMO: ' + $nLottoMin + ' righe: con il deposito dichiarato non deve succedere (file prova, contro-esempio sull oro): ordini scartati = n e R deformati') }
  # finestra girata, dal giornale del tester
  $finest = 'non letta'
  if($fin.Count -eq 1){
    $mf = $fin.Values | Select-Object -First 1
    if($mf.Groups['sim'].Value -eq $sim['nome'] -and $mf.Groups['tf'].Value -eq $cfg['periodo'] -and $mf.Groups['da'].Value -eq $sim['da'] -and $mf.Groups['a'].Value -eq $DATA_A -and $mf.Groups['ha'].Value -eq '00:00' -and $mf.Groups['hb'].Value -eq '00:00'){ $finest = $sim['da'] + '-' + $DATA_A }
    else { $finest = 'DIVERSA: ' + $mf.Groups['sim'].Value + ',' + $mf.Groups['tf'].Value + ' ' + $mf.Groups['da'].Value + '-' + $mf.Groups['a'].Value; [void]$motivi.Add('finestra girata ' + $finest + ' invece di ' + $sim['nome'] + ',' + $cfg['periodo'] + ' ' + $sim['da'] + '-' + $DATA_A) }
  } elseif($fin.Count -gt 1){ $finest = 'AMBIGUA'; [void]$motivi.Add('PIU intestazioni di passata nel giornale del tester: finestra non attribuibile') }
  # profondita' dei tick: SOLO il simbolo della prova (la riga del simbolo di conversione non conta, classe 1205)
  $tickIniTxt = (($tickIni.Keys | Sort-Object) -join ' / ')
  $okTick = $false; $nTickSim = 0
  foreach($tk in @($tickIni.Keys)){ $pz2 = $tk -split ' '; if($pz2[0] -eq $sim['nome']){ $nTickSim = $nTickSim + 1; if([string]::CompareOrdinal($pz2[1], $sim['da']) -le 0){ $okTick = $true } } }
  if($nTickSim -eq 0){ Dico ('   (la riga "ticks data begins from" di ' + $sim['nome'] + ' non e nel giornale di questa passata (altre: ' + $tickIniTxt + '): succede se i tick erano gia in cache; la qualita 100% del report la riconferma)') 'Yellow' }
  elseif(-not $okTick){ [void]$motivi.Add('ticks data begins from ' + $tickIniTxt + ': DOPO l inizio della finestra ' + $sim['da'] + ' (prima di quella data MT5 genera i tick: non sono reali)') }
  # il report .htm
  $rep = $null
  foreach($rad in @($DataFolder, $InstAttesa, $Work, $MqlFiles, (Join-Path $env:USERPROFILE 'Desktop'))){
    if(-not (Test-Path -LiteralPath $rad)){ continue }
    $cr = @(Get-ChildItem -LiteralPath $rad -Filter ($nomeRep + '*.htm*') -File -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -ge $tRun } | Sort-Object LastWriteTime -Descending)
    if($cr.Count -gt 0){ $rep = $cr[0]; break }
  }
  $lr = $null; $nTrades = ''; $profitto = ''; $pfRep = ''; $qual = ''; $depRep = ''; $tickRep = ''
  if($null -eq $rep){ [void]$motivi.Add('report .htm della passata NON trovato (Report=' + $nomeRep + '): senza report non c e misura') }
  else {
    Copy-Item -LiteralPath $rep.FullName -Destination (Join-Path (Join-Path $Cart 'report') ($tag + '.htm')) -Force
    $lr = LeggiReport $rep.FullName
    if(-not $lr.Ok){ [void]$motivi.Add('report illeggibile: ' + $lr.Motivo) }
    else {
      $nTrades = [string]$lr.Trades; $profitto = Fmt $lr.Profitto '0.00'; $pfRep = $lr.PF; $qual = $lr.Qualita
      if($null -ne $lr.Deposito){ $depRep = Fmt $lr.Deposito '0.00' }
      if($null -ne $lr.Ticks){ $tickRep = [string]$lr.Ticks }
      if($null -ne $lr.Expert -and $lr.Expert -ne $EXPERT){ [void]$motivi.Add('il report e di un altro EA (' + $lr.Expert + ')') }
      if($null -ne $lr.Simbolo -and $lr.Simbolo -ne $sim['nome']){ [void]$motivi.Add('il report e di un altro simbolo (' + $lr.Simbolo + ')') }
      if($null -eq $lr.Deposito -or [math]::Abs($lr.Deposito - $DEPOSITO) -gt 0.5){ [void]$motivi.Add('deposito del report ' + $depRep + ' invece di ' + $DEPOSITO + ': il .ini non e stato applicato come dichiarato (classe 1208)') }
      if($null -ne $lr.Periodo){
        $mpd = [regex]::Match($lr.Periodo, '^' + $cfg['periodo'] + '\((\d{4}\.\d\d\.\d\d)-(\d{4}\.\d\d\.\d\d)\)')
        if(-not $mpd.Success){ [void]$motivi.Add('il periodo del report e "' + $lr.Periodo + '" invece di ' + $cfg['periodo'] + ' (' + $sim['da'] + ' - ' + $DATA_A + ')') }
        else {
          $dA = [datetime]::ParseExact($mpd.Groups[2].Value, 'yyyy.MM.dd', $IC); $dB = [datetime]::ParseExact($DATA_A, 'yyyy.MM.dd', $IC)
          if($mpd.Groups[1].Value -ne $sim['da'] -or [math]::Abs(($dA - $dB).TotalDays) -gt 1){ [void]$motivi.Add('il periodo del report e "' + $lr.Periodo + '" invece di ' + $cfg['periodo'] + ' (' + $sim['da'] + ' - ' + $DATA_A + ')') }
        }
      } else { [void]$motivi.Add('periodo del report NON letto') }
      if($lr.Qualita -notmatch '^100%'){ [void]$motivi.Add('qualita dello storico "' + $lr.Qualita + '" invece di 100% ticks reali: il verdetto a tick reali NON vale') }
    }
  }
  # il CSV per-setup e il per-trade dell'EA: nome = simbolo + magic, uguale per i 3 modi e i 2 lati -> devono essere FRESCHI e si copiano col nome della passata
  $nomeCsv = 'natcla_setup_' + $sim['nome'] + '_' + $cfg['magic'] + '.csv'
  $nomeTr = 'abtg_trades_' + $EXPERT + '_' + $sim['nome'] + '_' + $cfg['magic'] + '.csv'
  $cs = $null
  $csvIt = TrovaFresco $nomeCsv $tRun
  if($null -eq $csvIt){ [void]$motivi.Add('CSV ' + $nomeCsv + ' NON trovato fresco (scritto dopo l avvio della passata)') }
  else {
    $cs = ContaSetup $csvIt.FullName
    Copy-Item -LiteralPath $csvIt.FullName -Destination (Join-Path (Join-Path $Cart 'csv') ($tag + '.csv')) -Force
    if(-not $cs.Ok){ [void]$motivi.Add('CSV per-setup: ' + $cs.Motivo) }
    if(-not $cs.Header){ [void]$motivi.Add('CSV senza intestazione tipo;barra;linea;lato') }
    if($cs.Avvio -eq ''){ [void]$motivi.Add('CSV senza la riga #AVVIO in testa') }
    elseif($cs.Avvio.IndexOf('| stop ' + $stopAtt, [StringComparison]::Ordinal) -lt 0 -or $cs.Avvio.IndexOf('#AVVIO v' + $VERSIONE_ATTESA + ' ', [StringComparison]::Ordinal) -ne 0){ [void]$motivi.Add('riga #AVVIO del CSV senza "v' + $VERSIONE_ATTESA + '" o senza "| stop ' + $stopAtt + '": il CSV non e di questa passata') }
    if($cs.Cfg -lt 20){ [void]$motivi.Add('CSV con solo ' + $cs.Cfg + ' righe #cfg (attese >= 20)') }
    if($cs.CfgDir -notlike ('#cfg;InpDirezione;' + $lato['cfg'] + ';*')){ [void]$motivi.Add('#cfg;InpDirezione del CSV diverso da ' + $lato['cfg']) }
    if($cs.Conta -gt 0){ [void]$motivi.Add('CSV con ' + $cs.Conta + ' righe CONTA: l EA era in SOLO CONTA, nessun ordine, nessun merito') }
  }
  $trIt = TrovaFresco $nomeTr $tRun
  if($null -eq $trIt){ Dico ('   per-trade ' + $nomeTr + ' NON trovato fresco: il lettore usa report e CSV per-setup (avviso, non KO)') 'Yellow' }
  else { Copy-Item -LiteralPath $trIt.FullName -Destination (Join-Path (Join-Path $Cart 'trades') ($tag + '.csv')) -Force }
  # coerenza fra le due fonti: righe SETUP (EA) contro report (tester). Un setup aperto a fine test non ha riga SETUP: al massimo 3 posizioni e 2 rischi di scarto
  $setupN = ''; $riemp = ''; $soldiS = ''
  if($null -ne $cs -and $cs.Ok -and $null -ne $lr -and $lr.Ok){
    $setupN = [string]$cs.Setup; $riemp = [string]$cs.Riempiti; $soldiS = Fmt $cs.Soldi '0.00'
    $dTr = $lr.Trades - $cs.Riempiti
    if($dTr -lt 0 -or $dTr -gt 3){ [void]$motivi.Add('operazioni del report ' + $lr.Trades + ' contro riempiti delle righe SETUP ' + $cs.Riempiti + ' (attese uguali, fino a 3 in piu nel report per un setup aperto a fine test): la colla ordini -> CSV non torna') }
    $tolS = 2.0 * $cs.RischioMax + 1.0
    if($cs.Setup -eq 0){ $tolS = 0.02 * $DEPOSITO }
    if([math]::Abs($lr.Profitto - $cs.Soldi) -gt $tolS){ [void]$motivi.Add('profitto del report ' + (Fmt $lr.Profitto '0.00') + ' contro somma degli esiti delle righe SETUP ' + (Fmt $cs.Soldi '0.00') + ' (tolleranza ' + (Fmt $tolS '0.00') + ' = 2 rischi): la colla ordini -> CSV non torna') }
  }
  # il log dell'EA di questa passata, per intero (ora simulata + riga)
  $lg = New-Object System.Collections.ArrayList
  [void]$lg.Add('# passata ' + $etich + '   ini f1_' + $tag + '.ini   durata ' + [int]$dur + ' s   righe EA uniche ' + $eaOrd.Count + ' (grezze ' + $nGrezze + ')   INVIO FALLITO ' + $nInvio + ' (retcode 10019: ' + $nInvioSoldi + ')   lotto<min ' + $nLottoMin + '   semaforo sforato ' + $nSemaforo + '   imbuto ROTTA ' + $nImbRotte + '   soldi/stop out ' + $nSoldi + '   log illeggibili ' + $illeggibili)
  foreach($e in $evTester.Keys){ [void]$lg.Add('# TESTER ' + $e) }
  foreach($e in $fin.Keys){ [void]$lg.Add('# FINESTRA ' + $e) }
  foreach($kk2 in $eaOrd){ [void]$lg.Add($eaSt[$kk2] + '   ' + $eaMsg[$kk2]) }
  ($lg -join "`r`n") | Set-Content -LiteralPath (Join-Path (Join-Path $Cart 'log') ($tag + '.txt')) -Encoding ASCII

  $stato = 'OK'
  if($motivi.Count -gt 0){ $stato = 'KO' }
  if($finest -eq 'non letta' -and $motivi.Count -eq 0){ $stato = 'OK_FINESTRA_NON_LETTA' }
  if($stato -like 'OK*'){ $nOk = $nOk + 1; $sommaDur = $sommaDur + $dur; $nDur = $nDur + 1 } else { $nKo = $nKo + 1 }
  $bgTxt = ''; if($null -ne $barreGen){ $bgTxt = [string]$barreGen }
  [void]$manifest.Add($base + ';' + $tRun.ToString('yyyy-MM-dd HH:mm:ss', $IC) + ';' + [int]$dur + ';' + $stato + ';' + $nTrades + ';' + $profitto + ';' + $pfRep + ';' + $qual + ';' + $depRep + ';' + $tickRep + ';' + $bgTxt + ';' + $tickIniTxt + ';' + $setupN + ';' + $riemp + ';' + $soldiS + ';' + $nInvio + ';' + $nLottoMin + ';' + $nSemaforo + ';' + $nImbRotte + ';' + $eaOrd.Count + ';' + $avvioOk + ';' + $adxV + ';' + $finest + ';' + (($motivi -join ' | ') -replace ';', ','))
  $col = 'Green'; if($stato -ne 'OK'){ $col = 'Red' }
  Write-Host ('   ' + $etich + '  ' + $stato + '   ' + [int]$dur + ' s   operazioni ' + $nTrades + '   setup ' + $setupN + '   profitto ' + $profitto + '   PF(deal) ' + $pfRep + '   AVVIO ' + $avvioOk + '   ADX ' + $adxV + '   finestra ' + $finest) -ForegroundColor $col
  foreach($x in $motivi){ Write-Host ('        - ' + $x) -ForegroundColor Red }
  if($stato -like 'KO*'){ foreach($x in @($evTester.Keys | Select-Object -First 5)){ Write-Host ('        tester: ' + $x) -ForegroundColor DarkYellow } }
}
$durTot = ((Get-Date) - $TLotto).TotalMinutes

# ---------------------------------------------------------------------
#  3. RACCOLTA
# ---------------------------------------------------------------------
Titolo '3 - RACCOLTA'
$mediaS = 0.0; if($nDur -gt 0){ $mediaS = $sommaDur / $nDur }
$testa = @(
  ('NATCLA F1 -- lotto ' + $Lotto + ': EA_NatCla v' + $VERSIONE_ATTESA + ', Modello 4 (tick reali), IS fino al ' + $DATA_A + ', deposito ' + $DEPOSITO + ' EUR, rischio per setup 0,25% (SEGNAPOSTO)'),
  ('data: ' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss', $IC) + '   pc: ' + $env:COMPUTERNAME + '   pin: ' + $Pin),
  ('EA_NatCla.mq5 SHA256 ' + $ShaEA + '  (NC_VER ' + $VERSIONE_ATTESA + ')   compilazione: ' + $compErr + ' errori, ' + $compWarn + ' avvisi (-1 = non letto)'),
  ('passate del lotto ' + $runs.Count + ': OK ' + $nOk + ', KO ' + $nKo + ', NON LANCIATE ' + $nNon + '   durata totale ' + [int]$durTot + ' minuti   media per passata OK ' + [int]$mediaS + ' secondi'),
  ('STIMA DEL PIANO INTERO (200 passate) con la media di questo lotto: ' + [int](200 * $mediaS / 60.0) + ' minuti (valida solo se il lotto e rappresentativo: oro, forex e indici hanno quantita di tick diverse)'),
  'Guardian nel tester: FAIL-OPEN (specifica 2.5): il DD del tester NON e ridotto da pausa B1 ne da cap C1.',
  ''
)
(($testa + $manifest + @('',
  'COME SI LEGGE: python3 backtest_pipeline/leggi_natcla_f1.py <questo zip o la cartella> [altri zip]. Prima lo STATO di ogni passata (OK / KO / NON_LANCIATA) e i motivi,',
  'poi la colla (righe SETUP = operazioni del report, soldi = profitto), poi n per gamba contro le attese, poi PF_R, DD in R, verdetti e confronto dei modi con le soglie del file prova.',
  'Questo script RACCOGLIE e dice se ogni passata e affidabile: NON giudica, NON promuove, NON sceglie nessun modo.')) -join "`r`n") | Set-Content -LiteralPath (Join-Path $Cart 'RIEPILOGO_F1.txt') -Encoding ASCII
(($manifest) -join "`r`n") | Set-Content -LiteralPath (Join-Path $Cart 'MANIFEST_F1.csv') -Encoding ASCII
Compress-Archive -Path (Join-Path $Cart '*') -DestinationPath $zip -Force
Write-Host ''
Write-Host ('passate OK ' + $nOk + ', KO ' + $nKo + ', NON LANCIATE ' + $nNon + ' su ' + $runs.Count + '   durata ' + [int]$durTot + ' minuti   media per passata OK ' + [int]$mediaS + ' s') -ForegroundColor Cyan
Write-Host ('ZIP PRONTO DA MANDARE: ' + $zip) -ForegroundColor Green
Write-Host 'FILE ATTESI NELLO ZIP: RIEPILOGO_F1.txt + MANIFEST_F1.csv + il file prova + compile_natcla_f1.log + per passata: csv\<passata>.csv + trades\<passata>.csv + report\<passata>.htm + log\<passata>.txt + ini\f1_<passata>.ini' -ForegroundColor Gray
try{ $Mutex.ReleaseMutex() }catch{ }
$tutteOk = ($nKo -eq 0 -and $nNon -eq 0 -and $nOk -eq $runs.Count)
if($tutteOk){ Write-Host 'ESITO F1: TUTTE LE PASSATE OK (rc 0)' -ForegroundColor Green; exit 0 }
Write-Host 'ESITO F1: ALMENO UNA PASSATA KO O NON LANCIATA (rc 3): lo zip esce lo stesso, il MANIFEST dice quali e perche.' -ForegroundColor Red
exit 3
