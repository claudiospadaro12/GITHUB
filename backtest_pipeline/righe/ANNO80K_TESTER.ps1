# =====================================================================
#  MARCATORE_ANNO80K_TESTER_TRANCHE_v1
#  ANNO80K_TESTER_TRANCHE.ps1 -Ex5Nome '<file>.ex5' -- TEST A FONDO di UN EA del MQL5 Market (demo, solo tester) nello Strategy Tester del PC di backtest DESKTOP-H4D7CAJ.
#  VARIANTE di ARENA5K_MESE (conto prop 80.000 EUR, 26/10/2026): UN SOLO ANNO scelto con -Anno AAAA (e -Modello, default 1, -Periodo, default H1) a conto vuoto; stesse guardie. Previsioni: report/MARKET_TEST_80K_ATTESE_2026-10-19.md. Originale: 21 tranche MENSILI (ognuna a conto vuoto) piu UNA corsa CONTINUA 2025.01.01 -> 2026.10.01, XAUUSD H1, ticks reali, nessun input imposto.
#  v4 ANNO80K (26/10/2026, notte): -Imposti ammette il tipo s (stringa; i separatori del valore sono +, nel .ini diventano ; con ; finale) per OneChartSetup_Pairs.
#  v3 ANNO80K (26/10/2026, sera): -Simbolo (default XAUUSD) per gli EA da forex con OneChartSetup (Luna AI Pro: grafico EURUSD M5 e le 8 coppie negli input). Cambia SOLO il simbolo del grafico e il testo.
#  v2 ANNO80K (26/10/2026, 15:00): -Periodo ammette D1 (il report del tester lo scrive Daily: campo Ril), correzione dopo che le 5 passate di Goldbot One si sono fermate sul controllo del periodo.
#  v1 ANNO80K (26/10/2026): copia di ANNO5K_TESTER.ps1 con DEPOSITO 80.000 EUR (prop FTMO). Serve per Gold Reaper, Goldbot One, Prop Firm Gold sui tre anni 2013/2018/2020 + calibrazione 2025 (Modello 1 contro Modello 4). Stesse guardie, stesso -Imposti, -Modello (4 = tick reali) e -Periodo (D1 per Goldbot One). v3: la finestra del giornale si confronta con Ril (Daily per D1), cosi D1 non da piu KO di etichetta.
#  DERIVATO da SCREEN_TESTER_TRANCHE.ps1 (stesse guardie). Regole e soglie scritte PRIMA dei numeri: report/MARKET_SELEZIONE_PER_ACQUISTO_ATTESE_2026-10-19.md.
#  E' UN BACKTEST: AllowLiveTrading=false. NON TOCCA C:\MT5_Backtest, C:\FundedNext_Manuale, il VPS. NIENTE EMOJI QUI DENTRO (regola del 17/08).
# =====================================================================
[CmdletBinding()]
param(
  [Parameter(Mandatory=$true)][string]$Pin,
  [Parameter(Mandatory=$true)][string]$Ex5Nome,
  [int]$TimeoutTrancheMin = 600,
  [string]$Tranche = '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22',
  [string]$Imposti = '',
  [string]$Anno = '',
  [int]$Modello = 1,
  [string]$Periodo = 'H1',
  [string]$Simbolo = 'XAUUSD',
  [string]$Base = ''
)

$ErrorActionPreference = 'Stop'
$IC = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentCulture   = $IC
[Threading.Thread]::CurrentThread.CurrentUICulture = $IC

if($Ex5Nome -notmatch '^[\x20-\x7E]+\.ex5$' -or $Ex5Nome -match '[\\/;="]'){ throw ('-Ex5Nome "' + $Ex5Nome + '" non valido: serve il nome del file .ex5 (solo ASCII, senza cartelle, senza ; = o virgolette).') }
$TOK = [regex]::Replace([IO.Path]::GetFileNameWithoutExtension($Ex5Nome), '[^A-Za-z0-9]', '')
if($TOK.Length -lt 1){ throw ('-Ex5Nome "' + $Ex5Nome + '": nessun carattere alfanumerico per fare il nome della cartella.') }
if($TOK.Length -gt 24){ $TOK = $TOK.Substring(0, 24) }
$TOKU = $TOK.ToUpper(); $TOKL = $TOK.ToLower()
$TOKEXP = [regex]::Replace([IO.Path]::GetFileNameWithoutExtension($Ex5Nome), '[^A-Za-z0-9]', '').ToLower()
$NOME_D   = 'ANNO80K_' + $TOKU
if($Simbolo -notmatch '^[A-Za-z0-9._]{3,14}$'){ throw ('-Simbolo "' + $Simbolo + '" non valido') }
$SIMBOLO  = $Simbolo
# NIENTE $PERIODO qui: questo giro ha DUE periodi del grafico e li porta ognuna la sua voce di $SONDE ($s.Per). Una variabile
# unica di periodo sarebbe falsa e finirebbe nei titoli e nel referto (classe 1499: i conteggi e le etichette si COSTRUISCONO).
$MODELLO  = $Modello
$DEPOSITO = 80000
$VALUTA   = 'EUR'
$LEVA     = 100
$TETTO_BARRE  = 100000
$AVVISO_BARRE = 95000
# NESSUN input imposto: si prova coi default dell'EA, fa fede il report (G1). Tipo: b = bool, i = intero, d = decimale.
# ATTENZIONE: il referto NON scrive a mano "input imposti: NESSUNO", COSTRUISCE la riga da $INPUT_IMPOSTI (classe 1480,
# recidiva 1497): se un giorno questa lista si riempie, il referto lo dice da solo invece di mentire.
$INPUT_IMPOSTI = @()
# v5 (25/10/2026): -Imposti 'Nome=valore:tipo;Nome=valore:tipo' (tipo b = bool, i = intero, d = decimale) per imporre il SET del venditore. Il referto lo riporta e il report lo conferma o la passata e KO. Senza -Imposti: nessun input imposto come prima.
if($Imposti -ne ''){ foreach($p in ($Imposti -split ';')){ $m = [regex]::Match($p, '^([A-Za-z0-9_]+)=([^:;]+):([bids])$'); if(-not $m.Success){ throw ('-Imposti: voce non valida "' + $p + '" (attesa Nome=valore:tipo, tipo b, i, d o s; per s i separatori del valore sono +)') }; $INPUT_IMPOSTI += ,@($m.Groups[1].Value, $m.Groups[2].Value, $m.Groups[3].Value) } }
$INPUT_ENUM = @()

if($Pin -notmatch '^[0-9a-fA-F]{40}$' -or $Pin -match '^0{40}$'){ throw '-Pin obbligatorio, di 40 caratteri esadecimali e NON fatto di zeri: il pin di zeri e il segnaposto della BOZZA, non un commit.' }
$Pin = $Pin.ToLower()
if($TimeoutTrancheMin -lt 1 -or $TimeoutTrancheMin -gt 900){ throw '-TimeoutTrancheMin fuori da 1-900 minuti.' }
if($Tranche -notmatch '^[0-9]{1,2}(,[0-9]{1,2})*$'){ throw ('-Tranche ' + $Tranche + ' non valido: servono numeri da 1 a 22 separati da virgola.') }
$TrScelte = @($Tranche -split ',')
if(@($TrScelte | Select-Object -Unique).Count -ne $TrScelte.Count){ throw ('-Tranche ' + $Tranche + ' ha una tranche ripetuta.') }
# DUE passate sulla STESSA finestra (2026.01.01 -> 2026.03.01, cioe gennaio e febbraio 2026), ognuna a CONTO VUOTO (deposito 80000 EUR), che
# differiscono SOLO per il periodo del grafico: H1 e M15. NON sono tranche mensili e non sono in sequenza: non si sommano, si CONFRONTANO.
# QUANTE e QUALI passate le dice l elenco qui sotto, non questo commento; e le frasi del REFERTO che descrivono la natura del giro si
# COSTRUISCONO da $SONDE_TUTTE (classi 1498 e 1499: la prosa ereditata da un altro giro aveva scritto "TRE tranche MENSILI ... luglio,
# agosto, settembre 2026" sopra questo stesso elenco). 'A' e il primo giorno dopo l ultimo incluso (il report scrive l estremo 'A' come
# data finale; l ultimo giorno incluso e quello prima).
$SONDE = @(
  [pscustomobject]@{ Nome = 'TRANCHE1'; Per = 'H1'; Da = '2025.01.01'; A = '2025.02.01'; Timeout = $TimeoutTrancheMin; Cosa = 'mese 2025-01, H1' },
  [pscustomobject]@{ Nome = 'TRANCHE2'; Per = 'H1'; Da = '2025.02.01'; A = '2025.03.01'; Timeout = $TimeoutTrancheMin; Cosa = 'mese 2025-02, H1' },
  [pscustomobject]@{ Nome = 'TRANCHE3'; Per = 'H1'; Da = '2025.03.01'; A = '2025.04.01'; Timeout = $TimeoutTrancheMin; Cosa = 'mese 2025-03, H1' },
  [pscustomobject]@{ Nome = 'TRANCHE4'; Per = 'H1'; Da = '2025.04.01'; A = '2025.05.01'; Timeout = $TimeoutTrancheMin; Cosa = 'mese 2025-04, H1' },
  [pscustomobject]@{ Nome = 'TRANCHE5'; Per = 'H1'; Da = '2025.05.01'; A = '2025.06.01'; Timeout = $TimeoutTrancheMin; Cosa = 'mese 2025-05, H1' },
  [pscustomobject]@{ Nome = 'TRANCHE6'; Per = 'H1'; Da = '2025.06.01'; A = '2025.07.01'; Timeout = $TimeoutTrancheMin; Cosa = 'mese 2025-06, H1' },
  [pscustomobject]@{ Nome = 'TRANCHE7'; Per = 'H1'; Da = '2025.07.01'; A = '2025.08.01'; Timeout = $TimeoutTrancheMin; Cosa = 'mese 2025-07, H1' },
  [pscustomobject]@{ Nome = 'TRANCHE8'; Per = 'H1'; Da = '2025.08.01'; A = '2025.09.01'; Timeout = $TimeoutTrancheMin; Cosa = 'mese 2025-08, H1' },
  [pscustomobject]@{ Nome = 'TRANCHE9'; Per = 'H1'; Da = '2025.09.01'; A = '2025.10.01'; Timeout = $TimeoutTrancheMin; Cosa = 'mese 2025-09, H1' },
  [pscustomobject]@{ Nome = 'TRANCHE10'; Per = 'H1'; Da = '2025.10.01'; A = '2025.11.01'; Timeout = $TimeoutTrancheMin; Cosa = 'mese 2025-10, H1' },
  [pscustomobject]@{ Nome = 'TRANCHE11'; Per = 'H1'; Da = '2025.11.01'; A = '2025.12.01'; Timeout = $TimeoutTrancheMin; Cosa = 'mese 2025-11, H1' },
  [pscustomobject]@{ Nome = 'TRANCHE12'; Per = 'H1'; Da = '2025.12.01'; A = '2026.01.01'; Timeout = $TimeoutTrancheMin; Cosa = 'mese 2025-12, H1' },
  [pscustomobject]@{ Nome = 'TRANCHE13'; Per = 'H1'; Da = '2026.01.01'; A = '2026.02.01'; Timeout = $TimeoutTrancheMin; Cosa = 'mese 2026-01, H1' },
  [pscustomobject]@{ Nome = 'TRANCHE14'; Per = 'H1'; Da = '2026.02.01'; A = '2026.03.01'; Timeout = $TimeoutTrancheMin; Cosa = 'mese 2026-02, H1' },
  [pscustomobject]@{ Nome = 'TRANCHE15'; Per = 'H1'; Da = '2026.03.01'; A = '2026.04.01'; Timeout = $TimeoutTrancheMin; Cosa = 'mese 2026-03, H1' },
  [pscustomobject]@{ Nome = 'TRANCHE16'; Per = 'H1'; Da = '2026.04.01'; A = '2026.05.01'; Timeout = $TimeoutTrancheMin; Cosa = 'mese 2026-04, H1' },
  [pscustomobject]@{ Nome = 'TRANCHE17'; Per = 'H1'; Da = '2026.05.01'; A = '2026.06.01'; Timeout = $TimeoutTrancheMin; Cosa = 'mese 2026-05, H1' },
  [pscustomobject]@{ Nome = 'TRANCHE18'; Per = 'H1'; Da = '2026.06.01'; A = '2026.07.01'; Timeout = $TimeoutTrancheMin; Cosa = 'mese 2026-06, H1' },
  [pscustomobject]@{ Nome = 'TRANCHE19'; Per = 'H1'; Da = '2026.07.01'; A = '2026.08.01'; Timeout = $TimeoutTrancheMin; Cosa = 'mese 2026-07, H1' },
  [pscustomobject]@{ Nome = 'TRANCHE20'; Per = 'H1'; Da = '2026.08.01'; A = '2026.09.01'; Timeout = $TimeoutTrancheMin; Cosa = 'mese 2026-08, H1' },
  [pscustomobject]@{ Nome = 'TRANCHE21'; Per = 'H1'; Da = '2026.09.01'; A = '2026.10.01'; Timeout = $TimeoutTrancheMin; Cosa = 'mese 2026-09, H1' },
  [pscustomobject]@{ Nome = 'TRANCHE22'; Per = 'H1'; Da = '2025.01.01'; A = '2026.10.01'; Timeout = ($TimeoutTrancheMin * 4); Cosa = 'corsa CONTINUA 21 mesi, H1' }
)
# v1 (26/10/2026): UN SOLO ANNO SOLARE a conto vuoto (80000 EUR), scelto con -Anno AAAA, -Modello (default 1 = OHLC 1 minuto; 0 = tutti i tick generati; 4 = tick reali) e -Periodo (default H1). La passata si chiama ancora TRANCHE22 per il lettore.
if($Anno -notmatch '^20(0[5-9]|1[0-9]|2[0-5])$'){ throw ('-Anno "' + $Anno + '" non valido: serve un anno fra 2005 e 2025, per esempio 2013') }
if($Modello -notin @(0,1,4)){ throw ('-Modello ' + $Modello + ' non ammesso (0, 1 o 4)') }
if($Periodo -notmatch '^(M1|M5|M15|M30|H1|H4|D1)$'){ throw ('-Periodo "' + $Periodo + '" non ammesso (M1, M5, M15, M30, H1, H4, D1)') }
$SONDE_TUTTE = @([pscustomobject]@{ Nome = 'TRANCHE22'; Per = $Periodo; Ril = $(if($Periodo -eq 'D1'){ 'Daily' } else { $Periodo }); Da = ($Anno + '.01.01'); A = ((([int]$Anno) + 1).ToString() + '.01.01'); Timeout = $TimeoutTrancheMin; Cosa = ('anno ' + $Anno + ' ' + $Periodo + ' Modello ' + $Modello) })
$Tranche = '22'
$TrScelte = @('22')
$SONDE = @($SONDE_TUTTE | Where-Object { $TrScelte -contains $_.Nome.Substring(7) })
# classe 1502 (seconda guardia, dopo il -notmatch di -Tranche qui sopra): mai produrre referto, MANIFEST e zip con ZERO passate lanciate.
if($SONDE.Count -lt 1){ throw ('-Tranche ' + $Tranche + ' non seleziona NESSUNA delle passate disponibili (' + (@($SONDE_TUTTE | ForEach-Object { $_.Nome + '=' + $_.Per }) -join ', ') + '): non lancio un giro che non misura niente (classe 1502).') }

function Dico($t,$c='Gray'){ Write-Host ('   ' + $t) -ForegroundColor $c }
function Titolo($t){ Write-Host ''; Write-Host ('=== ' + $t + ' ===') -ForegroundColor Cyan }
function Num($s){ return [double]::Parse($s, [Globalization.NumberStyles]::Float, $IC) }
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
# D3: la TESTA del report (impostazioni, input, risultati stanno prima delle tabelle Ordini/Affari): al massimo $maxB byte
function Leggi-Testa($path, $maxB){
  $fs = [IO.File]::Open($path, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
  try{
    $n = [int][math]::Min([long]$fs.Length, [long]$maxB)
    $b = New-Object byte[] $n
    $letti = 0
    while($letti -lt $n){ $r = $fs.Read($b, $letti, $n - $letti); if($r -le 0){ break }; $letti = $letti + $r }
  } finally { $fs.Close() }
  if($letti -lt 2){ return '' }
  if($b[0] -eq 0xFF -and $b[1] -eq 0xFE){ $q = $letti - 2; if($q % 2 -eq 1){ $q = $q - 1 }; return [Text.Encoding]::Unicode.GetString($b, 2, $q) }
  $zeri = 0; $nb = [math]::Min(400, $letti)
  for($i = 1; $i -lt $nb; $i += 2){ if($b[$i] -eq 0){ $zeri++ } }
  if($zeri -gt ($nb / 4)){ $q = $letti; if($q % 2 -eq 1){ $q = $q - 1 }; return [Text.Encoding]::Unicode.GetString($b, 0, $q) }
  return ([Text.Encoding]::UTF8.GetString($b, 0, $letti)).TrimStart([char]0xFEFF)
}
function CercaCella([string]$t, [string[]]$etichette){
  foreach($e in $etichette){
    $m = [regex]::Match($t, '\|' + $e + ':\|([^|]*)\|')
    if($m.Success){ return (([regex]::Replace($m.Groups[1].Value, '\s', ''))) }
  }
  return $null
}
function LeggiReport($path){
  $r = @{ Ok = $false; Motivo = ''; Trades = $null; Profitto = $null; PF = ''; Qualita = ''; Barre = ''; Ticks = ''; Expert = $null; NExpert = 0; Simbolo = $null; Periodo = $null; Deposito = $null; Leva = $null; Valuta = $null; DDEq = ''; DDBil = ''; Input = @{}; InputOrd = @() }
  $testo = ''
  try{ $testo = Leggi-Testa $path 1048576 }catch{ $r.Motivo = 'report illeggibile: ' + $_.Exception.Message; return $r }
  if([string]::IsNullOrEmpty($testo)){ $r.Motivo = 'report vuoto o illeggibile'; return $r }
  $t = [regex]::Replace($testo, '<[^>]+>', '|')
  $t = [regex]::Replace($t, '\s*\|[\s|]*', '|')
  $r.NExpert = ([regex]::Matches($t, '\|Expert:\|')).Count
  $r.Expert   = CercaCella $t @('Expert')
  $r.Simbolo  = CercaCella $t @('Simbolo', 'Symbol')
  $r.Periodo  = CercaCella $t @('Periodo', 'Period')
  $r.Deposito = CercaCella $t @('Deposito Iniziale', 'Initial Deposit')
  $r.Leva     = CercaCella $t @('Leva', 'Leverage')
  $r.Valuta   = CercaCella $t @('Valuta', 'Currency')
  $vq = CercaCella $t @('Qualit. dello Storico', 'History Quality'); if($null -ne $vq){ $r.Qualita = $vq }
  $vb = CercaCella $t @('Barre', 'Bars'); if($null -ne $vb){ $r.Barre = $vb }
  $vk = CercaCella $t @('Ticks'); if($null -ne $vk){ $r.Ticks = $vk }
  $vf = CercaCella $t @('Fattore di Profitto', 'Profit Factor'); if($null -ne $vf){ $r.PF = $vf }
  $ve = CercaCella $t @('Equit. Drawdown Massima', 'Equity Drawdown Maximal'); if($null -ne $ve){ $r.DDEq = $ve }
  $vd = CercaCella $t @('Bilancio Drawdown Massimo', 'Balance Drawdown Maximal'); if($null -ne $vd){ $r.DDBil = $vd }
  # gli input come il tester li ha usati ('Dati in ingresso'): celle 'Nome=valore'. Il lookahead non consuma il separatore (celle adiacenti)
  foreach($mi in [regex]::Matches($t, '\|([A-Za-z_][A-Za-z0-9_]*)=([^|]*)(?=\|)')){
    $kI = $mi.Groups[1].Value
    if(-not $r.Input.ContainsKey($kI)){ $r.Input[$kI] = $mi.Groups[2].Value.Trim(); $r.InputOrd = $r.InputOrd + @($kI) }
  }
  $vt = CercaCella $t @('Numero di Operazioni di Trading Totali', 'Total Trades')
  $vp = CercaCella $t @('Profitto Totale Netto', 'Total Net Profit')
  if($null -eq $vt){ $r.Motivo = 'etichetta del totale operazioni (Numero di Operazioni di Trading Totali / Total Trades) NON trovata'; return $r }
  if($null -eq $vp){ $r.Motivo = 'etichetta del profitto netto (Profitto Totale Netto / Total Net Profit) NON trovata'; return $r }
  if($vt -notmatch '^[0-9]+$'){ $r.Motivo = 'totale operazioni non numerico: "' + $vt + '"'; return $r }
  if($vp -notmatch '^-?[0-9]+(\.[0-9]+)?$'){ $r.Motivo = 'profitto netto non numerico: "' + $vp + '"'; return $r }
  $r.Trades = [int]$vt
  $r.Profitto = Num $vp
  $r.Ok = $true
  return $r
}
# un valore imposto contro quello che il report dice: '' se coincide, altrimenti il motivo
function InputDiverso($nome, $atteso, $tipo, $visto){
  if($null -eq $visto){ return ($nome + ' ASSENTE dai Dati in ingresso del report') }
  if($tipo -eq 's'){ $va = ($atteso -replace '\+', ';').TrimEnd(';'); $vs = $visto.Trim().TrimEnd(';'); if($vs -ne $va){ return ($nome + '=' + $visto + ' invece di ' + $va) }; return '' }
  if($tipo -eq 'b'){ if($visto.ToLower() -ne $atteso){ return ($nome + '=' + $visto + ' invece di ' + $atteso) }; return '' }
  $v = 0.0
  if(-not [double]::TryParse($visto, [Globalization.NumberStyles]::Float, $IC, [ref]$v)){ return ($nome + '=' + $visto + ': non numerico (atteso ' + $atteso + ')') }
  if([math]::Abs($v - (Num $atteso)) -gt 1e-9){ return ($nome + '=' + $visto + ' invece di ' + $atteso) }
  return ''
}

# ---------------------------------------------------------------------
#  0. LA MACCHINA E IL TERMINALE. Fail-closed, come GBA_R0_PASSATE v5.
# ---------------------------------------------------------------------
Titolo '0 - MACCHINA E TERMINALE'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){
  throw ('ANNO80K_TESTER_TRANCHE gira SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui la macchina si chiama: ' + $env:COMPUTERNAME + '. Sul VPS VMI3047753 non si lancia: la challenge FTMO sta operando (firma del 21/09/2026: i giri del tester stanno sul PC di backtest).')
}
Dico ('pc   : ' + $env:COMPUTERNAME) 'Green'
Dico ('pin  : ' + $Pin) 'Green'
foreach($altro in @('Global\ABTG_NATCLA_F0', 'Global\ABTG_NATCLA_F1', 'Global\ABTG_BULGE_TEL_P0', 'Global\ABTG_AZZURRA_FREQ', 'Global\CLAU12_EXPORT_BARRE')){
  $mx = $null
  if([System.Threading.Mutex]::TryOpenExisting($altro, [ref]$mx)){
    try{ $mx.Dispose() }catch{ }
    throw ('Un giro che tiene il blocco ' + $altro + ' e VIVO su questo PC: un solo giro di tester alla volta (classe 853). Aspetta la sua riga finale con rc, NON chiudere il suo terminale.')
  }
}
$Mutex = New-Object System.Threading.Mutex($false, 'Global\ABTG_GBA_R0')
$preso = $false
try{ $preso = $Mutex.WaitOne(0) } catch [System.Threading.AbandonedMutexException] { $preso = $true; Dico 'il blocco Global\ABTG_GBA_R0 era stato lasciato da un giro INTERROTTO: lo riprendo (nessun altro giro sta girando)' 'Yellow' }
if(-not $preso){
  throw 'Un giro GBA (o un altro giro del tester) sta gia girando su questo PC (blocco Global\ABTG_GBA_R0 occupato). Un solo giro alla volta: aspetta la sua riga finale con rc, NON chiudere il suo terminale.'
}
$aperti = @(Get-Process -Name terminal64, metaeditor64, metatester64 -ErrorAction SilentlyContinue)
if($aperti.Count -gt 0){
  $aperti | Select-Object Id, ProcessName, MainWindowTitle, Path | Format-Table -AutoSize | Out-String -Width 300 | Write-Host
  throw 'MT5, METAEDITOR o un AGENTE DEL TESTER risulta APERTO su questo PC (PID, titolo, cartella qui sopra). Se sta lavorando NON chiuderlo: aspetta la sua riga finale con rc. Se e un MT5 aperto a vuoto (per esempio quello usato per installare l EA scelto dal Market), chiudilo A MANO riconoscendolo dal PID e dalla cartella, e rilancia.'
}

$InstAttesa = 'C:\Program Files\BCM Markets MT5 Terminal'
$Terminal   = Join-Path $InstAttesa 'terminal64.exe'
if(-not (Test-Path -LiteralPath $Terminal)){ throw ('terminale non trovato dove la sonda lo aspetta: ' + $Terminal + '. Non si cerca altrove apposta.') }
$DataRoot = Join-Path $env:APPDATA 'MetaQuotes\Terminal'
$origini = @()
foreach($d in @(Get-ChildItem -Path $DataRoot -Directory -ErrorAction SilentlyContinue)){
  $o = Join-Path $d.FullName 'origin.txt'
  if(Test-Path -LiteralPath $o){
    $v = (Leggi-Condiviso $o).Trim()
    if($v -ne ''){ $origini = $origini + @([pscustomobject]@{ Dir = $d.FullName; Inst = $v }) }
  }
}
# le ALTRE installazioni di questo PC, censite il 05/10/2026 (risultati_archivio/DUKA_P0_20261005_171046/REFERTO_DUKA_P0.txt, sez. 5): AMMESSE PER NOME, chiuse, non toccate
$Censite = @('C:\MT5_Backtest', 'C:\FundedNext_Manuale')
# v3 (14/10/2026): una cartella dati con origin.txt = C:\Users\Master\Desktop (nata dopo le 19:28, nessun conto, nessun processo aperto) e ammessa SOLO se
# il suo common.ini non ha nessun Login= : senza conto non puo operare. Se un giorno ha un Login=, o se common.ini esiste ma non si legge, ci si ferma.
$CensiteSenzaConto = @('C:\Users\Master\Desktop')
$diversi = @($origini | Where-Object { $_.Inst -ne $InstAttesa })
$ignote = @($diversi | Where-Object { ($Censite -notcontains $_.Inst.TrimEnd('\')) -and ($CensiteSenzaConto -notcontains $_.Inst.TrimEnd('\')) })
foreach($dv in @($diversi | Where-Object { $CensiteSenzaConto -contains $_.Inst.TrimEnd('\') })){
  $cini = Join-Path $dv.Dir 'config\common.ini'
  if(Test-Path -LiteralPath $cini){
    $txc = Leggi-Condiviso $cini
    if([string]::IsNullOrEmpty($txc)){ throw ('l installazione ' + $dv.Inst + ' (cartella dati ' + (Split-Path -Leaf $dv.Dir) + ') ha un common.ini che NON si legge: non posso dire che non ha un conto. Mi fermo.') }
    if($txc -match '(?im)^\s*Login\s*=\s*\d'){ throw ('l installazione ' + $dv.Inst + ' (cartella dati ' + (Split-Path -Leaf $dv.Dir) + ') ha un CONTO salvato (Login=): non e piu quella censita il 14/10 senza conto. Mi fermo.') }
  }
  Dico ('installazione censita il 14/10 SENZA CONTO (nessun Login= in common.ini), nessun processo aperto, NON TOCCATA: ' + $dv.Inst + '  (cartella dati ' + (Split-Path -Leaf $dv.Dir) + ')') 'Yellow'
}
foreach($dv in @($diversi | Where-Object { $Censite -contains $_.Inst.TrimEnd('\') })){ Dico ('altra installazione di questo PC, censita il 05/10, CHIUSA e NON TOCCATA: ' + $dv.Inst + '  (cartella dati ' + (Split-Path -Leaf $dv.Dir) + ')') 'Yellow' }
if($ignote.Count -gt 0){
  foreach($dv in $ignote){ Write-Host ('     installazione NON censita: ' + $dv.Inst) -ForegroundColor Red }
  throw 'Mi fermo: oltre al BCM, alle due censite il 05/10 (C:\MT5_Backtest, C:\FundedNext_Manuale) e a quella senza conto del 14/10 (C:\Users\Master\Desktop) qui ci sono ALTRE installazioni MT5 (regola dei terminali multipli).'
}
$cands = @($origini | Where-Object { $_.Inst -eq $InstAttesa })
if($cands.Count -ne 1){ throw ('cartella dati NON risolta in modo univoco: trovate ' + $cands.Count + ' candidate per ' + $InstAttesa + '. Mi fermo invece di indovinare.') }
$DataFolder = $cands[0].Dir
$chrRoot = Join-Path (Join-Path (Join-Path $DataFolder 'MQL5') 'Profiles') 'Charts'
$nChr = 0; $conEA = @()
if(Test-Path -LiteralPath $chrRoot){
  foreach($fc in @(Get-ChildItem -LiteralPath $chrRoot -Recurse -File -Filter '*.chr' -ErrorAction SilentlyContinue)){
    $nChr = $nChr + 1
    $tx = Leggi-Condiviso $fc.FullName
    if(-not $tx){ $conEA = $conEA + @($fc.Directory.Name + '\' + $fc.Name + '  ILLEGGIBILE: conta come EA attaccato'); continue }
    if($tx -match '<expert>'){ $conEA = $conEA + @($fc.Directory.Name + '\' + $fc.Name + '  EA ATTACCATO') }
  }
}
if($nChr -le 0){ throw ('ho letto ZERO grafici salvati sotto ' + $chrRoot + ': una guardia che non legge niente non ha verificato niente. Non si parte.') }
if($conEA.Count -gt 0){ throw ('EA ATTACCATI ai grafici salvati del terminale BCM (' + ($conEA -join '; ') + '). Staccali prima: aprire il terminale col profilo li rimetterebbe in marcia sul demo 50503392 (14/08/2026). Se hai attaccato l EA scelto (o un altro EA) a un grafico di questo PC, toglilo dal grafico, chiudi MT5 e rilancia.') }
Dico ('terminale: ' + $Terminal) 'Green'
Dico ('dati     : ' + $DataFolder) 'Green'
Dico ('grafici salvati letti: ' + $nChr + ', nessun EA attaccato') 'Green'

# ---------------------------------------------------------------------
#  1. IL .EX5 DELL EA SCELTO: SOLO in MQL5\Experts\Market, ESATTAMENTE UNO
# ---------------------------------------------------------------------
Titolo '1 - IL FILE DELL EA SCELTO (MQL5\Experts\Market di QUESTO terminale)'
$MsgInstalla = 'Installa l EA (la DEMO gratuita va bene) dal Market su QUESTO terminale: apri MT5 dalla cartella C:\Program Files\BCM Markets MT5 Terminal (conto demo 50503392 di QUESTO PC DESKTOP-H4D7CAJ), scheda Market -> Acquistati (o la pagina del prodotto dell EA) -> Demo/Installa [NON VERIFICATO nei dettagli del menu]; NON attaccarlo a nessun grafico; chiudi MT5 e rilancia questa riga. La demo del Market gira solo nel tester [NON VERIFICATO che includa tutte le funzioni].'
$MqlExp = Join-Path (Join-Path $DataFolder 'MQL5') 'Experts'
$MktDir = Join-Path $MqlExp 'Market'
if(-not (Test-Path -LiteralPath $MqlExp)){ throw ('la cartella ' + $MqlExp + ' NON esiste o non si legge: il terminale BCM di questa macchina non ha MQL5\Experts. Mi fermo.') }
$errMkt = @()
$tuttiMkt = @()
if(Test-Path -LiteralPath $MktDir){
  $tuttiMkt = @(Get-ChildItem -LiteralPath $MktDir -Recurse -File -Filter '*.ex5' -ErrorAction SilentlyContinue -ErrorVariable errMkt)
} else {
  $sondaE = @(Get-ChildItem -LiteralPath $MqlExp -ErrorAction SilentlyContinue -ErrorVariable errMkt)
  Dico ('la cartella ' + $MktDir + ' NON esiste: su questo terminale non e installato nessun prodotto del Market (MQL5\Experts letta: ' + $sondaE.Count + ' voci, errori di lettura ' + @($errMkt).Count + ')') 'Yellow'
}
if(@($errMkt).Count -gt 0){ throw ('errori di lettura nella cartella del Market (' + @($errMkt).Count + ', il primo: ' + @($errMkt)[0].Exception.Message + '): l elenco e INCOMPLETO e non dico ne trovato ne assente. Mi fermo.') }
$ger = @($tuttiMkt | Where-Object { $_.Name -eq $Ex5Nome } | Sort-Object LastWriteTime -Descending)
if($ger.Count -ne 1){
  Write-Host ('   .ex5 col nome ' + $Ex5Nome + ' in ' + $MktDir + ': ' + $ger.Count + ' (ne serve ESATTAMENTE uno)') -ForegroundColor Red
  foreach($fa in $ger){ Write-Host ('     ' + $fa.FullName.Substring($MqlExp.Length + 1) + '   ' + $fa.Length + ' byte   ' + $fa.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss', $IC) + '   SHA256 ' + (Get-FileHash -LiteralPath $fa.FullName -Algorithm SHA256).Hash) -ForegroundColor Red }
  $altri = @($tuttiMkt | Where-Object { $_.Name -ne $Ex5Nome } | Sort-Object LastWriteTime -Descending)
  Write-Host ('   TUTTI gli altri .ex5 del Market su questo terminale (' + $altri.Count + ', dal piu recente, NON contati: se l EA scelto c e con un altro nome, e qui):') -ForegroundColor Yellow
  foreach($fa in $altri){ Write-Host ('     ' + $fa.FullName.Substring($MqlExp.Length + 1) + '   ' + $fa.Length + ' byte   ' + $fa.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss', $IC)) -ForegroundColor Yellow }
  if($ger.Count -eq 0){ throw ('NESSUN .ex5 col nome ' + $Ex5Nome + ' in ' + $MktDir + '. ' + $MsgInstalla + ' Nessun tester e partito.') }
  throw ('PIU di un .ex5 col nome ' + $Ex5Nome + ' (' + $ger.Count + ', elencati qui sopra con data e SHA256): non scelgo io quale provare. Manda la foto di questa finestra: si decide quale tenere. Nessun tester e partito.')
}
$Ex5 = $ger[0]
if(-not $Ex5.FullName.StartsWith($MqlExp + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)){ throw ('il .ex5 trovato (' + $Ex5.FullName + ') non sta sotto ' + $MqlExp + ': non so scrivere il percorso relativo per il .ini. Mi fermo.') }
$RelEx5 = $Ex5.FullName.Substring($MqlExp.Length + 1)
if($RelEx5 -match '[^\x20-\x7E]' -or $RelEx5 -match '[;="]'){ throw ('il nome del .ex5 (' + $RelEx5 + ') ha caratteri che non si scrivono in un .ini ASCII (non ASCII, ; = o virgolette): non lo rinomino (e di terzi). Manda la foto: si decide come procedere. Nessun tester e partito.') }
$ShaEx5 = (Get-FileHash -LiteralPath $Ex5.FullName -Algorithm SHA256).Hash
$DataEx5 = $Ex5.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss', $IC)
Dico ('trovato : ' + $RelEx5) 'Green'
Dico ('byte    : ' + $Ex5.Length + '   data file ' + $DataEx5) 'Green'
Dico ('SHA256  : ' + $ShaEx5 + '   (binario di TERZI: va nel referto, NON nello zip ne in repo)') 'Green'
if($RelEx5.Contains(' ')){ Dico 'il nome ha degli SPAZI: il .ini lo scrive cosi com e (Expert=Market\...). Che il tester lo accetti e [NON VERIFICATO]: se non lo trova, la passata esce senza report e il giornale lo dice.' 'Yellow' }

# ---------------------------------------------------------------------
#  2. LE PASSATE (una per PERIODO DEL GRAFICO, stessa finestra; passate singole, Optimization=0, ognuna a conto vuoto)
# ---------------------------------------------------------------------
$Stamp = (Get-Date).ToString('yyyyMMdd_HHmmss', $IC)
$Work = Join-Path $env:USERPROFILE ('abtg_anno80k_' + $TOKL)
New-Item -ItemType Directory -Force -Path $Work | Out-Null
$dsk  = [Environment]::GetFolderPath('Desktop')
# v4 (25/10/2026): -Base = cartella UNICA dei risultati di questo giro, ammessa SOLO sotto Desktop\ABTG_RISULTATI (richiesta di Claudio: niente cartelle sparse sul Desktop). Senza -Base: Desktop come prima.
if($Base -ne ''){ $radR = Join-Path $dsk 'ABTG_RISULTATI'; $bn = [IO.Path]::GetFullPath($Base).TrimEnd([IO.Path]::DirectorySeparatorChar); if(-not $bn.StartsWith($radR + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)){ throw ('-Base ' + $Base + ' non ammessa: deve stare sotto ' + $radR) }; New-Item -ItemType Directory -Force -Path $bn | Out-Null; $dsk = $bn }
$Cart = Join-Path $dsk $NOME_D
$zip  = Join-Path $dsk ($NOME_D + '.zip')
if(Test-Path -LiteralPath $Cart){ Move-Item -LiteralPath $Cart -Destination ($Cart + '_VECCHIA_' + $Stamp); Dico ('cartella di un giro PRECEDENTE rinominata: ' + $Cart + '_VECCHIA_' + $Stamp) 'Yellow' }
if(Test-Path -LiteralPath $zip){ $zz = Join-Path $dsk ($NOME_D + '_VECCHIO_' + $Stamp + '.zip'); Move-Item -LiteralPath $zip -Destination $zz; Dico ('zip di un giro PRECEDENTE rinominato: ' + $zz) 'Yellow' }
New-Item -ItemType Directory -Force -Path $Cart | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $Cart 'report'), (Join-Path $Cart 'log'), (Join-Path $Cart 'ini') | Out-Null

$LogRoot = Join-Path $env:APPDATA 'MetaQuotes'
$RadiciLog = @($LogRoot, (Join-Path $InstAttesa 'Tester'))
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
$ExpEsc = [regex]::Escape('Experts\' + $RelEx5)
$reChiave = New-Object Text.RegularExpressions.Regex('(?i)stop ?out|no money|not enough money|margin|started with inputs|testing of|ticks data begins|bars generated|final balance|test passed|last test|history|quality|error|failed|cannot|not found|invalid|licen|dll|removed|initiali|deinit|disconnect|synchron|critical|stopped|expired')
$reFin = New-Object Text.RegularExpressions.Regex(('(?<sim>[A-Za-z0-9_.#-]+),(?<tf>[A-Za-z0-9]+)(?:\s+\([^)]*\))?:\s+testing of ' + $ExpEsc + ' from (?<da>\d{4}\.\d\d\.\d\d) (?<ha>\d\d:\d\d) to (?<a>\d{4}\.\d\d\.\d\d) (?<hb>\d\d:\d\d)'), [Text.RegularExpressions.RegexOptions]::IgnoreCase)
$reBarre = New-Object Text.RegularExpressions.Regex('(?<sim>[A-Za-z0-9_.#-]+),(?<tf>[A-Za-z0-9]+): (?<tick>\d+) ticks, (?<barre>\d+) bars generated')
$reTickIni = New-Object Text.RegularExpressions.Regex('(?<sim>[A-Za-z0-9_.#-]+): ticks data begins from (?<d>\d{4}\.\d\d\.\d\d)')
$rePassed = New-Object Text.RegularExpressions.Regex('Test passed in (?<h>\d+):(?<m>\d\d):(?<s>\d\d)(?:\.(?<ms>\d+))?')
$reInp = New-Object Text.RegularExpressions.Regex('^\s*(?<k>[A-Za-z_][A-Za-z0-9_]*)=(?<v>.*)$')
# l'estratto di UN giornale, letto riga per riga dalla coda dopo la fotografia: testa (3000 righe), righe chiave (al massimo 20000), coda (1000)
function EstraiLog($f, $offset, $dest, $st){
  $fs = [IO.File]::Open($f.FullName, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
  $testa = New-Object 'System.Collections.Generic.List[string]'
  $coda  = New-Object 'System.Collections.Generic.Queue[string]'
  $chiave = New-Object 'System.Collections.Generic.List[string]'
  $n = 0; $dopoInp = 0
  try{
    $b = New-Object byte[] 2
    [void]$fs.Read($b, 0, 2)
    $enc = [Text.Encoding]::UTF8
    if($b[0] -eq 0xFF -and $b[1] -eq 0xFE){ $enc = [Text.Encoding]::Unicode }
    elseif($b[0] -eq 0xFE -and $b[1] -eq 0xFF){ $enc = [Text.Encoding]::BigEndianUnicode }
    $da = [long]$offset
    if($da -lt 2 -and $enc -ne [Text.Encoding]::UTF8){ $da = 2 }
    [void]$fs.Seek($da, [IO.SeekOrigin]::Begin)
    $sr = New-Object IO.StreamReader($fs, $enc, $false)
    while($true){
      $l = $sr.ReadLine()
      if($null -eq $l){ break }
      $n = $n + 1
      if($testa.Count -lt 3000){ $testa.Add($l) }
      $coda.Enqueue($l); if($coda.Count -gt 1000){ [void]$coda.Dequeue() }
      $msg = $l; $ut = $l.LastIndexOf("`t"); if($ut -ge 0){ $msg = $l.Substring($ut + 1) }
      if($dopoInp -gt 0){
        $dopoInp = $dopoInp - 1
        $mI = $reInp.Match($msg)
        if($mI.Success){ $st.InputLog[$mI.Groups['k'].Value] = $mI.Groups['v'].Value.Trim(); if($chiave.Count -lt 20000){ $chiave.Add($l) }; continue }
      }
      if(-not $reChiave.IsMatch($l)){ continue }
      if($chiave.Count -lt 20000){ $chiave.Add($l) }
      if($l.IndexOf('started with inputs', [StringComparison]::OrdinalIgnoreCase) -ge 0){ $dopoInp = 80 }
      if($l -match '(?i)stop ?out'){ $st.StopOut = $st.StopOut + 1 }
      if($l -match '(?i)no money|not enough money'){ $st.NoMoney = $st.NoMoney + 1 }
      $mf = $reFin.Match($l)
      if($mf.Success){ $st.Fin[($mf.Groups['sim'].Value + '|' + $mf.Groups['tf'].Value + '|' + $mf.Groups['da'].Value + '|' + $mf.Groups['ha'].Value + '|' + $mf.Groups['a'].Value + '|' + $mf.Groups['hb'].Value)] = $true }
      $mb = $reBarre.Match($l)
      if($mb.Success -and $mb.Groups['sim'].Value -eq $SIMBOLO){ $st.Barre = [long]$mb.Groups['barre'].Value; $st.Tick = [long]$mb.Groups['tick'].Value }
      $mt = $reTickIni.Match($l)
      if($mt.Success){ $st.TickIni[$mt.Groups['sim'].Value + ' ' + $mt.Groups['d'].Value] = $true }
      $mp = $rePassed.Match($l)
      if($mp.Success){
        $sec = [int]$mp.Groups['h'].Value * 3600 + [int]$mp.Groups['m'].Value * 60 + [int]$mp.Groups['s'].Value
        if($sec -gt $st.TestSec){ $st.TestSec = $sec }
      }
      if($l -match '(?i)final balance'){ $st.Finale = $msg.Trim() }
      if($st.Errori.Count -lt 40 -and $l -match '(?i)error|failed|cannot|not found|invalid|licen|dll|critical|expired|removed'){ [void]$st.Errori.Add($msg.Trim()) }
    }
  } finally { $fs.Close() }
  $out = New-Object 'System.Collections.Generic.List[string]'
  $out.Add('# giornale ' + $f.FullName + '   offset ' + $offset + '   righe lette dopo la fotografia ' + $n)
  if($n -le 4000){
    $out.Add('# === TUTTE LE RIGHE (' + $n + ') ===')
    foreach($x in $testa){ $out.Add($x) }
    if($n -gt $testa.Count){ $skip = $testa.Count - ($n - $coda.Count); $i = 0; foreach($x in $coda){ if($i -ge $skip){ $out.Add($x) }; $i = $i + 1 } }
  } else {
    $out.Add('# === TESTA (prime ' + $testa.Count + ' righe) ===')
    foreach($x in $testa){ $out.Add($x) }
    $out.Add('# === RIGHE CHIAVE (' + $chiave.Count + ', al massimo 20000, nell ordine del giornale) ===')
    foreach($x in $chiave){ $out.Add($x) }
    $out.Add('# === CODA (ultime ' + $coda.Count + ' righe) ===')
    foreach($x in $coda){ $out.Add($x) }
  }
  Set-Content -LiteralPath $dest -Value $out -Encoding ASCII
  return $n
}
function TestoIni($s, $nomeRep){
  $r = New-Object System.Collections.ArrayList
  foreach($x in @('[Experts]', 'AllowLiveTrading=false', 'AllowDllImport=false', '', '[Tester]', ('Expert=' + $RelEx5), ('Symbol=' + $SIMBOLO), ('Period=' + $s.Per), ('Model=' + $MODELLO), 'Optimization=0', ('FromDate=' + $s.Da), ('ToDate=' + $s.A), 'ForwardMode=0', ('Deposit=' + $DEPOSITO), ('Currency=' + $VALUTA), ('Leverage=' + $LEVA), 'ExecutionMode=0', 'Visual=0', 'ReplaceReport=1', 'ShutdownTerminal=1', ('Report=' + $nomeRep), '', '[TesterInputs]')){ [void]$r.Add($x) }
  foreach($ip in $INPUT_IMPOSTI){ if($ip[2] -eq 's'){ [void]$r.Add($ip[0] + '=' + (($ip[1] -replace '\+', ';') + ';')) } else { [void]$r.Add($ip[0] + '=' + $ip[1]) } }
  return (($r -join "`r`n") + "`r`n")
}

$manifest = New-Object System.Collections.ArrayList
[void]$manifest.Add('sonda;da;a;timeout_min;t_avvio;durata_s;test_s;stato;report;trades;profitto;pf;dd_equita;dd_saldo;qualita;barre_report;ticks_report;barre_gen;ticks_gen;ticks_inizio;finestra;stop_out_log;no_money_log;input_ok;enum;motivi')
$referto = New-Object System.Collections.ArrayList
$esiti = @{}; foreach($sx in $SONDE_TUTTE){ $esiti[$sx.Nome] = 'SALTATA' }
$fermaEx5 = ''
foreach($s in $SONDE){
  Titolo ('2 - ' + $s.Nome + ' (' + $s.Cosa + '): ' + $s.Da + ' -> ' + $s.A + ', ' + $SIMBOLO + ' ' + $s.Per + ', Modello ' + $MODELLO + ', deposito ' + $DEPOSITO + ' EUR, leva 1:100, timeout ' + $s.Timeout + ' minuti')
  $esiti[$s.Nome] = 'NON_LANCIATA'
  if($fermaEx5 -ne ''){
    # v2 (classe 1438): niente ore di tester su un binario che non e' quello dell'impronta
    Write-Host ('   ' + $s.Nome + ' NON LANCIATA: ' + $fermaEx5) -ForegroundColor Red
    [void]$manifest.Add($s.Nome + ';' + $s.Da + ';' + $s.A + ';' + $s.Timeout + ';;0;;NON_LANCIATA;;;;;;;;;;;;;;;;;;' + ($fermaEx5 -replace ';', ','))
    [void]$referto.Add($s.Nome + ': NON LANCIATA -- ' + $fermaEx5)
    continue
  }
  if((@(Get-Process -Name terminal64, metaeditor64 -ErrorAction SilentlyContinue)).Count -gt 0){
    $why = 'un terminal64 o un metaeditor64 e VIVO prima della passata: non apro un secondo terminale'
    Write-Host ('   ' + $s.Nome + ' NON LANCIATA: ' + $why) -ForegroundColor Red
    @(Get-Process -Name terminal64, metaeditor64 -ErrorAction SilentlyContinue) | Select-Object Id, ProcessName, MainWindowTitle, Path | Format-Table -AutoSize | Out-String -Width 300 | Write-Host
    [void]$manifest.Add($s.Nome + ';' + $s.Da + ';' + $s.A + ';' + $s.Timeout + ';;0;;NON_LANCIATA;;;;;;;;;;;;;;;;;;' + $why)
    [void]$referto.Add($s.Nome + ': NON LANCIATA -- ' + $why)
    continue
  }
  $nomeRep = 'ANNO80K_' + $TOKU + '_' + $s.Nome + '_' + $Stamp
  $iniF = Join-Path $Work ('anno80k_' + $TOKL + '_' + $s.Nome + '_' + $Stamp + '.ini')
  Set-Content -LiteralPath $iniF -Value (TestoIni $s $nomeRep) -Encoding ASCII -NoNewline
  Copy-Item -LiteralPath $iniF -Destination (Join-Path (Join-Path $Cart 'ini') ('anno80k_' + $TOKL + '_' + $s.Nome + '.ini'))
  $foto = Fotografia
  $tRun = Get-Date
  Dico ('avvio ' + $tRun.ToString('HH:mm:ss', $IC) + '   ini ' + $iniF + '   report atteso ' + $nomeRep + '.htm') 'Green'
  $p = Start-Process -FilePath $Terminal -ArgumentList ('/config:"' + $iniF + '"') -PassThru
  $scade = $tRun.AddMinutes($s.Timeout)
  while(-not $p.HasExited -and (Get-Date) -lt $scade){ Start-Sleep -Seconds 5 }
  $timeout = $false; $nonChiuso = $false
  if(-not $p.HasExited){
    $timeout = $true
    Write-Host ('   TIMEOUT: dopo ' + $s.Timeout + ' minuti il tester e ancora aperto. Lo chiudo con CloseMainWindow (MAI Stop-Process sul terminale). Un tester interrotto NON scrive il report.') -ForegroundColor Red
    try{ [void]$p.CloseMainWindow() }catch{ }
    $att = 0; while(-not $p.HasExited -and $att -lt 18){ Start-Sleep -Seconds 5; $att = $att + 1 }
    if(-not $p.HasExited){ $nonChiuso = $true; Write-Host ('   il terminale (PID ' + $p.Id + ') NON si e chiuso: la riga NON lo chiude con la forza. Chiudilo A MANO a fine riga riconoscendolo dal PID ' + $p.Id + ' e dalla cartella C:\Program Files\BCM Markets MT5 Terminal, MAI dal solo titolo.') -ForegroundColor Red }
  }
  Start-Sleep -Seconds 8
  $dur = [int]((Get-Date) - $tRun).TotalSeconds

  # --- i giornali: solo la coda scritta dopo la fotografia, estratto per file
  $st = @{ StopOut = 0; NoMoney = 0; Fin = @{}; Barre = $null; Tick = $null; TickIni = @{}; TestSec = -1; Finale = ''; Errori = (New-Object System.Collections.ArrayList); InputLog = @{} }
  $kf = 0; $righeTot = 0
  foreach($f in @(ElencoLog)){
    $off = 0; if($foto.ContainsKey($f.FullName)){ $off = [long]$foto[$f.FullName] }
    if($f.Length -le $off){ continue }
    $kf = $kf + 1
    $nomeL = $s.Nome + '_' + $kf.ToString('00') + '_' + (Split-Path -Leaf $f.DirectoryName) + '_' + $f.Name + '.txt'
    try{ $righeTot = $righeTot + (EstraiLog $f $off (Join-Path (Join-Path $Cart 'log') $nomeL) $st) }catch{ Dico ('giornale ' + $f.FullName + ' NON letto: ' + $_.Exception.Message) 'Yellow' }
  }
  $motivi = New-Object System.Collections.ArrayList
  if($timeout){ [void]$motivi.Add('timeout di ' + $s.Timeout + ' minuti (report non scritto da un tester interrotto)') }
  if($nonChiuso){ [void]$motivi.Add('terminale PID ' + $p.Id + ' NON chiuso: da chiudere A MANO per PID e cartella') }
  # v2: il binario provato e' quello dell'impronta? (il terminale, aprendosi, puo' aggiornare un prodotto del Market)
  $shaDopo = ''
  try{ $shaDopo = [string](Get-FileHash -LiteralPath $Ex5.FullName -Algorithm SHA256).Hash }catch{ $shaDopo = '' }
  $ex5Cambiato = $false
  if($shaDopo -ne $ShaEx5){
    $ex5Cambiato = $true
    $vistoDopo = $shaDopo; if($vistoDopo -eq ''){ $vistoDopo = 'FILE ASSENTE O ILLEGGIBILE' }
    [void]$motivi.Add('il .ex5 e CAMBIATO durante la passata (SHA256 prima ' + $ShaEx5 + ', dopo ' + $vistoDopo + '): il binario provato NON e quello del referto (aggiornamento dal Market?)')
    $fermaEx5 = ('il .ex5 dell EA e CAMBIATO (o sparito) durante la ' + $s.Nome + ': le tranche dopo NON partono, non si spendono ore su un binario diverso da quello dell impronta (classe 1438)')
  }
  $finest = 'non letta'
  if($st.Fin.Count -ge 1){
    $kk = @($st.Fin.Keys)
    $giuste = @($kk | Where-Object { $_ -eq ($SIMBOLO + '|' + $s.Ril + '|' + $s.Da + '|00:00|' + $s.A + '|00:00') })
    if($giuste.Count -eq $kk.Count){ $finest = $s.Da + '-' + $s.A } else { $finest = 'DIVERSA: ' + ($kk -join ' / '); [void]$motivi.Add('finestra girata ' + ($kk -join ' / ') + ' invece di ' + $SIMBOLO + ',' + $s.Per + ' ' + $s.Da + '-' + $s.A) }
  }
  if($null -ne $st.Barre){
    if($st.Barre -ge $TETTO_BARRE){ [void]$motivi.Add('barre generate ' + $st.Barre + ' >= ' + $TETTO_BARRE + ': finestra TRONCATA dal tetto del tester') }
    elseif($st.Barre -ge $AVVISO_BARRE){ Dico ('ATTENZIONE: barre generate ' + $st.Barre + ' fra ' + $AVVISO_BARRE + ' e ' + $TETTO_BARRE + ': vicino al tetto') 'Yellow' }
  }
  $tickIniTxt = (($st.TickIni.Keys | Sort-Object) -join ' / ')
  $okTick = $false; $nTickSim = 0
  foreach($tk in @($st.TickIni.Keys)){ $pz2 = $tk -split ' '; if($pz2[0] -eq $SIMBOLO){ $nTickSim = $nTickSim + 1; if([string]::CompareOrdinal($pz2[1], $s.Da) -le 0){ $okTick = $true } } }
  if($MODELLO -eq 4 -and $nTickSim -gt 0 -and -not $okTick){ [void]$motivi.Add('ticks data begins from ' + $tickIniTxt + ': DOPO l inizio della finestra ' + $s.Da + ' (prima di quella data MT5 GENERA i tick: non sono reali)') }

  # --- il report
  $rep = $null
  foreach($rad in @($DataFolder, $InstAttesa, $Work, (Join-Path (Join-Path $DataFolder 'MQL5') 'Files'), $dsk)){
    if(-not (Test-Path -LiteralPath $rad)){ continue }
    $cr = @(Get-ChildItem -LiteralPath $rad -Filter ($nomeRep + '*.htm*') -File -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -ge $tRun } | Sort-Object LastWriteTime -Descending)
    if($cr.Count -gt 0){
      $rep = $cr[0]
      foreach($im in @(Get-ChildItem -LiteralPath $rad -Filter ($nomeRep + '*.png') -File -ErrorAction SilentlyContinue)){ Copy-Item -LiteralPath $im.FullName -Destination (Join-Path (Join-Path $Cart 'report') $im.Name) -Force }
      break
    }
  }
  $lr = $null; $inputOk = 'no'; $enumTxt = ''
  if($null -eq $rep){ [void]$motivi.Add('report .htm NON trovato (Report=' + $nomeRep + '): senza report non c e misura. Se il giornale dice che l EA non e partito (licenza, DLL, simbolo), e una MISURA MANCANTE, non un errore') }
  else {
    Copy-Item -LiteralPath $rep.FullName -Destination (Join-Path (Join-Path $Cart 'report') $rep.Name) -Force
    $lr = LeggiReport $rep.FullName
    if(-not $lr.Ok){ [void]$motivi.Add('report illeggibile: ' + $lr.Motivo) }
    else {
      if($lr.NExpert -ne 1){ [void]$motivi.Add('il report ha ' + $lr.NExpert + ' celle Expert: un report con due EA non e questa sonda') }
      if($null -eq $lr.Expert){ [void]$motivi.Add('il report non ha la cella Expert') } elseif(([regex]::Replace($lr.Expert, '[^A-Za-z0-9]', '').ToLower()) -ne $TOKEXP -and -not ([regex]::Replace($lr.Expert, '[^A-Za-z0-9]', '').ToLower()).Contains($TOKEXP) -and -not $TOKEXP.Contains([regex]::Replace($lr.Expert, '[^A-Za-z0-9]', '').ToLower())){ Dico ('AVVISO: la cella Expert del report (' + $lr.Expert + ') non coincide col nome del file (' + $Ex5Nome + '): il nome del report e unico di questo giro, quindi e quasi certo il suo; confronta a mano') 'Yellow' }
      if($lr.Simbolo -ne $SIMBOLO){ [void]$motivi.Add('il report e di un altro simbolo (' + $lr.Simbolo + ')') }
      if($null -ne $lr.Periodo){
        $mpd = [regex]::Match($lr.Periodo, '^' + $s.Ril + '\((\d{4}\.\d\d\.\d\d)-(\d{4}\.\d\d\.\d\d)\)')
        $okP = $false
        if($mpd.Success -and $mpd.Groups[1].Value -eq $s.Da){
          $dA = [datetime]::ParseExact($mpd.Groups[2].Value, 'yyyy.MM.dd', $IC); $dB = [datetime]::ParseExact($s.A, 'yyyy.MM.dd', $IC)
          if([math]::Abs(($dA - $dB).TotalDays) -le 1){ $okP = $true }
        }
        if(-not $okP){ [void]$motivi.Add('il periodo del report e "' + $lr.Periodo + '" invece di ' + $s.Per + ' (' + $s.Da + ' - ' + $s.A + ')') }
      } else { [void]$motivi.Add('periodo del report non letto') }
      if($MODELLO -eq 4 -and $lr.Qualita -notmatch '^100%'){ [void]$motivi.Add('qualita dello storico "' + $lr.Qualita + '" invece di 100% ticks reali') }
      $depN = $null; if($null -ne $lr.Deposito){ $dd0 = 0.0; if([double]::TryParse($lr.Deposito, [Globalization.NumberStyles]::Float, $IC, [ref]$dd0)){ $depN = $dd0 } }
      if($null -eq $depN -or [math]::Abs($depN - $DEPOSITO) -gt 0.005){ [void]$motivi.Add('deposito del report "' + $lr.Deposito + '" invece di ' + $DEPOSITO + ': il .ini non e stato applicato come dichiarato') }
      if($lr.Leva -ne ('1:' + $LEVA)){ [void]$motivi.Add('leva del report "' + $lr.Leva + '" invece di 1:' + $LEVA) }
      $diff = @()
      foreach($ip in $INPUT_IMPOSTI){ $vv = $null; if($lr.Input.ContainsKey($ip[0])){ $vv = $lr.Input[$ip[0]] }; $dx = InputDiverso $ip[0] $ip[1] $ip[2] $vv; if($dx -ne ''){ $diff = $diff + @($dx) } }
      if($INPUT_IMPOSTI.Count -eq 0){ $inputOk = 'nessuno_imposto' } elseif($diff.Count -eq 0){ $inputOk = 'si' } else { [void]$motivi.Add('INPUT NON APPLICATI come dichiarato (' + $diff.Count + '): ' + (($diff | Select-Object -First 6) -join ' ## ')) }
      if($lr.Trades -eq 0){ [void]$motivi.Add('ZERO operazioni nel report (attesa A non verificata: e una MISURA MANCANTE -- l EA nel tester non opera o rifiuta il tester -- non un errore della riga)') }
    }
  }
  $enumTxt = (@($INPUT_ENUM | ForEach-Object { $ev = 'NON NEL REPORT'; if($null -ne $lr -and $lr.Input.ContainsKey($_)){ $ev = $lr.Input[$_] }; $el = 'NON NEL GIORNALE'; if($st.InputLog.ContainsKey($_)){ $el = $st.InputLog[$_] }; ($_ + ' report=' + $ev + ' giornale=' + $el) }) -join ' | ')
  $stato = 'OK'
  if($motivi.Count -gt 0){ $stato = 'KO' }
  $esiti[$s.Nome] = $stato
  $tTxt = ''; $pTxt = ''; $pfTxt = ''; $deTxt = ''; $dbTxt = ''; $qTxt = ''; $brTxt = ''; $tkTxt = ''
  if($null -ne $lr -and $lr.Ok){ $tTxt = [string]$lr.Trades; $pTxt = $lr.Profitto.ToString('0.00', $IC); $pfTxt = $lr.PF; $deTxt = $lr.DDEq; $dbTxt = $lr.DDBil; $qTxt = $lr.Qualita; $brTxt = $lr.Barre; $tkTxt = $lr.Ticks }
  $bgTxt = ''; if($null -ne $st.Barre){ $bgTxt = [string]$st.Barre }
  $tgTxt = ''; if($null -ne $st.Tick){ $tgTxt = [string]$st.Tick }
  $repNome = ''; if($null -ne $rep){ $repNome = $rep.Name }
  [void]$manifest.Add(($s.Nome + ';' + $s.Da + ';' + $s.A + ';' + $s.Timeout + ';' + $tRun.ToString('yyyy-MM-dd HH:mm:ss', $IC) + ';' + $dur + ';' + $st.TestSec + ';' + $stato + ';' + $repNome + ';' + $tTxt + ';' + $pTxt + ';' + $pfTxt + ';' + $deTxt + ';' + $dbTxt + ';' + $qTxt + ';' + $brTxt + ';' + $tkTxt + ';' + $bgTxt + ';' + $tgTxt + ';' + $tickIniTxt + ';' + $finest + ';' + $st.StopOut + ';' + $st.NoMoney + ';' + $inputOk + ';' + ($enumTxt -replace ';', ',') + ';' + (($motivi -join ' | ') -replace ';', ',')))
  [void]$referto.Add($s.Nome + ' (' + $s.Cosa + ')  ' + $s.Da + ' -> ' + $s.A + '   STATO ' + $stato)
  $esitoEx5 = 'UGUALE'; if($ex5Cambiato){ $esitoEx5 = 'DIVERSO' }
  $shaTxt = $shaDopo; if($shaTxt -eq ''){ $shaTxt = 'ASSENTE' }
  [void]$referto.Add('EX5_DOPO ' + $s.Nome + ': ' + $shaTxt + ' ' + $esitoEx5)
  [void]$referto.Add('   durata ' + $dur + ' s (orologio), test ' + $st.TestSec + ' s (riga Test passed del giornale; -1 = non letta)   giornali letti ' + $kf + ', righe ' + $righeTot)
  [void]$referto.Add('   report ' + $repNome + '   operazioni ' + $tTxt + '   netto ' + $pTxt + '   PF ' + $pfTxt + '   DD equita ' + $deTxt + '   DD saldo ' + $dbTxt)
  [void]$referto.Add('   qualita ' + $qTxt + '   barre report ' + $brTxt + '   ticks report ' + $tkTxt + '   barre generate ' + $bgTxt + '   ticks generati ' + $tgTxt + '   inizio tick ' + $tickIniTxt + '   finestra ' + $finest)
  [void]$referto.Add('   input imposti confermati dal report: ' + $inputOk + '   ENUM (NON imposti: il tester usa il default dell EA o l ultimo valore salvato nel tester, NON VERIFICATO quale; fa fede il report): ' + $enumTxt)
  if($null -ne $lr -and $lr.Ok){ [void]$referto.Add('   TUTTI gli input del report: ' + (@($lr.InputOrd | ForEach-Object { $_ + '=' + $lr.Input[$_] }) -join ' ; ')) }
  if($st.InputLog.Count -gt 0){ [void]$referto.Add('   input stampati dal giornale (dopo started with inputs): ' + (@($st.InputLog.Keys | Sort-Object | ForEach-Object { $_ + '=' + $st.InputLog[$_] }) -join ' ; ')) } else { [void]$referto.Add('   input stampati dal giornale: NESSUNA riga Nome=valore letta dopo started with inputs (formato [NON VERIFICATO]: fa fede il report)') }
  [void]$referto.Add('   righe stop out nei giornali ' + $st.StopOut + ', no money ' + $st.NoMoney + ' (somma sui giornali: la stessa riga puo stare in due giornali). Lo STOP OUT NON e un KO: e la coda cercata (D4)')
  if($st.Finale -ne ''){ [void]$referto.Add('   ' + $st.Finale) }
  foreach($x in @($st.Errori | Select-Object -First 15)){ [void]$referto.Add('   giornale: ' + $x) }
  foreach($x in $motivi){ [void]$referto.Add('   - ' + $x) }
  $col = 'Green'; if($stato -ne 'OK'){ $col = 'Red' }
  Write-Host ('   ' + $s.Nome + '  ' + $stato + '   ' + $dur + ' s   operazioni ' + $tTxt + '   netto ' + $pTxt + '   PF ' + $pfTxt + '   DD equita ' + $deTxt + '   stop out nel giornale ' + $st.StopOut) -ForegroundColor $col
  Dico ('ENUM non imposti, valore usato dal tester: ' + $enumTxt) 'Gray'
  foreach($x in $motivi){ Write-Host ('        - ' + $x) -ForegroundColor Red }
  if($stato -ne 'OK'){ foreach($x in @($st.Errori | Select-Object -First 5)){ Write-Host ('        giornale: ' + $x) -ForegroundColor DarkYellow } }
}

# ---------------------------------------------------------------------
#  3. RACCOLTA
# ---------------------------------------------------------------------
Titolo '3 - RACCOLTA'
$testa = @(
  ('ANNO80K TESTER TRANCHE (' + $Ex5Nome + ') -- EA di TERZI dal MQL5 Market, scatola nera, NESSUN sorgente. Script MARCATORE_ANNO80K_TESTER_TRANCHE_v1, pin ' + $Pin),
  ('data: ' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss', $IC) + '   pc: ' + $env:COMPUTERNAME + '   terminale: ' + $InstAttesa + ' (demo 50503392 di questo PC)   cartella dati ' + (Split-Path -Leaf $DataFolder)),
  ('EX5: ' + $RelEx5 + '   byte ' + $Ex5.Length + '   data file ' + $DataEx5 + '   SHA256 ' + $ShaEx5 + '   (binario di terzi: NON nello zip; impronta presa PRIMA delle passate e ricontrollata DOPO ognuna: righe EX5_DOPO)'),
  ('tester: ' + $SIMBOLO + ' ' + (@($SONDE_TUTTE | ForEach-Object { $_.Per }) -join ',') + ', Modello ' + $MODELLO + ' (' + $(if($MODELLO -eq 4){ 'ticks reali' } else { 'NON tick reali: barre o tick generati dal tester, qualita dello storico quella scritta nel report' }) + '), deposito ' + $DEPOSITO + ' ' + $VALUTA + ', leva 1:' + $LEVA + ' (leva che il tester ha STAMPATO il 14/10 nella SONDA1 con 500 nel .ini; il MARGINE dell oro nel tester NON e prezzo x contratto / 100: R114 del 27/08 ha letto 8580,52 EUR per 1 lotto = 10000 USD fissi a lotto, circa 1:45 sul nozionale [DERIVATO, non riletto oggi]; la leva del conto demo e [NON VISTA]), ExecutionMode=0 (nessun ritardo di esecuzione: nessuno slippage di latenza), Optimization=0, Visual=0'),
  ('input imposti dal .ini (' + $INPUT_IMPOSTI.Count + '): ' + (@($INPUT_IMPOSTI | ForEach-Object { $_[0] + '=' + $_[1] }) -join ' ; ') + '   (lista vuota = NESSUNO imposto: default dell EA, o ultimo valore salvato nel tester per questo EA su questo PC [NON VERIFICATO quale]). Tutti gli ALTRI input NON sono imposti. Fanno fede gli input del REPORT: vedi la riga TUTTI gli input del report e, per ogni passata, la riga input imposti confermati dal report (si = il tester li ha applicati davvero; se un nome non esiste nell EA la passata va KO).'),
  ('EA scelto (' + $Ex5Nome + '): EA di TERZI dal Market, scatola nera. UN MESE a conto vuoto: ' + $SONDE_TUTTE[0].Cosa + ', input imposti dal .ini: ' + $INPUT_IMPOSTI.Count + ' (0 = NESSUNO imposto: restano quelli salvati dal tester per questo EA su questo PC, e si CONFRONTANO nel report prima di leggere i numeri). Regole scritte PRIMA dei numeri: report/MARKET_SELEZIONE_PER_ACQUISTO_ATTESE_2026-10-19.md. Questo script RACCOGLIE, non giudica.'),
  ('tranche scelte: ' + $Tranche + ' (le altre: SALTATA, non lanciate per scelta)'),
  ('esiti: ' + (@($SONDE_TUTTE | ForEach-Object { $_.Nome + ' (' + $_.Per + ') ' + $esiti[$_.Nome] }) -join '   ')),
  ('ATTENZIONE: questo NON e un giro di tranche MENSILI e non e una corsa continua. Sono ' + $SONDE_TUTTE.Count + ' passate INDIPENDENTI sulla STESSA finestra (' + $SONDE_TUTTE[0].Da + ' -> ' + $SONDE_TUTTE[0].A + '), ognuna a CONTO VUOTO (deposito ' + $DEPOSITO + ' ' + $VALUTA + '), e cambia SOLO il periodo del grafico: ' + (@($SONDE_TUTTE | ForEach-Object { $_.Nome + '=' + $_.Per }) -join ', ') + '. Nessuna passata eredita il conto dell altra e uno stop out in una non fa morire le altre: i loro numeri NON si sommano, si CONFRONTANO fra loro. Se il .ex5 cambia in una passata, le passate dopo NON partono (v2).'),
  ''
)
(($testa + $referto + @('', 'COME SI LEGGE: il lettore lo scrivo io quando lo zip torna (report, MANIFEST e REFERTO sono il materiale). Questo script RACCOGLIE: non giudica, non promuove, non archivia niente.')) -join "`r`n") | Set-Content -LiteralPath (Join-Path $Cart 'REFERTO_ANNO80K_TRANCHE.txt') -Encoding ASCII
(($manifest) -join "`r`n") | Set-Content -LiteralPath (Join-Path $Cart 'MANIFEST_ANNO80K.csv') -Encoding ASCII
Compress-Archive -Path (Join-Path $Cart '*') -DestinationPath $zip
Write-Host ''
foreach($x in $testa){ if($x -ne ''){ Write-Host ('   ' + $x) } }
Write-Host ''
Write-Host ('ZIP PRONTO DA MANDARE: ' + $zip) -ForegroundColor Green
Write-Host ('FILE ATTESI NELLO ZIP: REFERTO_ANNO80K_TRANCHE.txt + MANIFEST_ANNO80K.csv + per ognuna delle passate LANCIATE (' + (@($SONDE | ForEach-Object { $_.Nome + '=' + $_.Per }) -join ', ') + '): ini\anno80k_' + $TOKL + '_<passata>.ini, report\SCREEN_' + $TOKU + '_<passata>_<data>.htm (+ le .png) se il tester li ha scritti, log\<passata>_*.txt') -ForegroundColor Gray
try{ $Mutex.ReleaseMutex() }catch{ }
$nSc = @($TrScelte | Where-Object { $esiti['TRANCHE' + $_] -eq 'OK' }).Count
if($nSc -eq $TrScelte.Count){ Write-Host ('ESITO DEEP TRANCHE: le ' + $TrScelte.Count + ' tranche scelte (' + $Tranche + ') sono OK (rc 0)') -ForegroundColor Green; exit 0 }
Write-Host 'ESITO DEEP TRANCHE: almeno una delle tranche scelte KO o NON LANCIATA (rc 3): lo zip esce lo stesso, il REFERTO e il MANIFEST dicono quale e perche.' -ForegroundColor Red
exit 3
