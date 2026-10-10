# =====================================================================
#  MARCATORE_GBA_R0_PASSATE_v5
#  GBA_R0_PASSATE.ps1 -- PASSO 0 (sonda), PASSO 1 (replica) E PASSO 2 (R2: una variabile per file) DI 'GoldBreakoutATR' (ABTG_GoldBreakoutATR v1.10)
#
#  CHE COSA FA, e una cosa sola:
#    per ogni passata di UN LOTTO del file prova backtest_pipeline/prove/GBA_R0_REPLICA_2026-10-09.txt lancia UNA passata SINGOLA del tester
#    (Optimization=0, Modello 1 = OHLC su M1 per la sonda S0, Modello 4 = ticks reali per la replica R1A/R1B, deposito 1000000 EUR, un solo
#    input diverso fra una cella e l'altra: InpSpreadMaxATR), poi RACCOGLIE il report .htm del tester, le righe [GBA...] del giornale
#    dell'EA (tutte: una per segnale, una per ingresso, AVVIO, AUTOTEST, [GBA-CONTA]) e le righe del tester (ticks data begins,
#    N ticks M bars generated, finestra girata), le mette in un zip sul Desktop e dice per ogni passata se e' AFFIDABILE (OK) o no (KO).
#    NON giudica niente: la tabella (n, PF, DD, costo stop/spread, ora, lato, concentrazione, cancelli G0/G1/G2) la fa leggi_gba_r0.py.
#
#  PERCHE' NON IL DRIVER DEI ROUND (walkforward_generico*.ps1 / RIGA_ROUND_*): MISURATO sul sorgente. Il driver dei round scrive SEMPRE
#  Optimization=1 (walkforward_generico.ps1 r.1015 e r.2013) e legge il risultato SOLO da OptResults_<EA>_<simbolo>.csv, che l'EA scrive con
#  FrameAdd/OnTesterDeinit. ABTG_GoldBreakoutATR.mq5 v1.10 non ha ne' OnTester* ne' FrameAdd (report/EA_GBA_NOTE_2026-10-09.md par. 2.16):
#  col driver dei round la prova uscirebbe con un CSV da zero byte (classe 134). L'EA NON e' stato toccato (richiesta del 09/10): il report si
#  legge dal tester. Il driver dei round non si tocca (SHA256 pinnati).
#
#  DERIVATO DA NATCLA_F0_PASSATE.ps1 (passata singola per lotto, gia' passata dal cancello e girata il 07-08/10). DEVIAZIONI, tutte dichiarate:
#   1. EA = ABTG_GoldBreakoutATR (versione attesa 1.10, '#property version "1.10"'), simbolo fisso XAUUSD, TF M1, include ABTG_PausaGuardian.mqh
#      (stesso file, SHA256 passato dalla riga). Nessun CSV dell'EA: l'EA non ne scrive.
#   2. Le passate vengono dal blocco '# @GBA-LOTTO' del file prova (la SOLA fonte: nessuna lista doppia qui): ogni voce e' CELLA:TRANCHE[:magic]. Le celle
#      sono blocchi '# @GBA-CELLA nome=.. InpSpreadMaxATR=..': un blocco che dichiari QUALUNQUE altro input fa MORIRE lo script (una variabile per file).
#      Le tranche sono blocchi '# @GBA-TRANCHE nome=.. da=.. a=..'. Il magic e' quello dell'asse tecnico (775800 o 775850) e basta.
#   3. Modello per lotto dal file prova (1 o 4). Con Modello 4 la passata e' KO se il report non dice '100% ticks reali' o se 'ticks data begins from'
#      cade DOPO l'inizio della tranche.
#   4. Il REPORT .htm (Report=GBA_R0_<tag>, ReplaceReport=1) e' raccolto e copiato nello zip, e se ne leggono: operazioni, profitto, fattore di profitto,
#      qualita' dello storico, barre, ticks, Expert, Simbolo, Periodo. Report assente, illeggibile, di un altro EA/simbolo/periodo = KO. (NATCLA_F0 non
#      lo voleva: qui senza report non c'e' misura.)
#   5. Il giornale: si tengono TUTTE le righe '[GBA' (una per segnale: sono migliaia) deduplicate per (ora simulata + inizio riga), con la regola della
#      riga TRONCATA (si tiene la piu' lunga, classe 1173) fatta con un dizionario e non con il doppio ciclo di NATCLA_F0 (con migliaia di righe sarebbe quadratico).
#      Si scrivono per intero in log\GBA_<tag>.txt; il lettore le analizza (segnali per ora, spread/ATR, stop/spread).
#   6. Controlli per passata, tutti contro la CELLA: riga AVVIO v1.10 e le righe SEGNALE/LATI/USCITE/BREAKEVEN/ESECUZIONE/RISCHIO/IDENTITA' con TUTTI i valori
#      dei pin scritti come l'EA li stampa (spread a 3 decimali, il resto a 2); AUTOTEST 'VERDETTO: PASS'; riga [GBA-CONTA] FINE; finestra girata uguale alla
#      tranche; barre generate < 100.000 (a >= 100.000 la finestra e' TRONCATA = KO; fra 95.000 e 100.000 avviso); ingressi del giornale = operazioni del report
#      (+/-1: una posizione aperta a fine test).
#   7. G1 (solo lotto S0): le due passate gemelle (stessa cella, stessa tranche, magic 775800 e 775850) devono avere operazioni, profitto e fattore di profitto
#      IDENTICI nel report; lo script lo dice nel RIEPILOGO. Il lettore lo rifa' da capo sui deal.
#   8. Guardie di NATCLA_F0 INVARIATE: macchina DESKTOP-H4D7CAJ, nessun terminal64/metaeditor64 vivo, installazioni MT5 non censite = stop (C:\MT5_Backtest e
#      C:\FundedNext_Manuale ammesse PER NOME, chiuse, non toccate), cartella dati risolta per origin.txt, nessun EA sui grafici salvati, AllowLiveTrading=false,
#      Mutex Global\ABTG_GBA_R0 (un solo giro alla volta, classe 853), pin di 40 esadecimali, SHA256 di EA/include/prova passati dalla riga (classe 166),
#      compilazione verificata dall'esistenza dell' .ex5 NUOVO (classe 1168), log di MetaEditor letto in inglese e italiano, CloseMainWindow e MAI
#      Stop-Process sul terminale, TLS 1.2 qui dentro (classe 1156), cartella e zip esistenti RINOMINATI con la data e mai cancellati.
#   9. (v2, verificatore-stringhe 09/10) DEPOSITO ESAURITO = KO: a lotto fisso 1,00 e migliaia di operazioni le celle larghe possono consumare il deposito
#      (proxy: fino a ~-76.000 USD per tranche su 100000 EUR). Allora l'EA salta gli ingressi ('[GBA] MARGINE INSUFFICIENTE') o il tester fa stop out, e n e PF
#      escono TRONCATI senza nessun errore. Ogni riga '[GBA] MARGINE INSUFFICIENTE', 'stop out', 'no money', 'not enough money' o '[GUARDIA] ... INGRESSO' del
#      giornale della passata = KO. Le righe '[GBA] ERRORE ordine' si contano nella testa del log (non KO).
#  10. (v2) la profondita' dei tick (Modello 4) si giudica SOLO sulla riga di XAUUSD: la riga 'EURUSD: ticks data begins from' (simbolo di conversione, conto in EUR)
#      non conta. I due formati delle soglie AVVIO usano InvariantCulture esplicita (non l'operatore -f).
#  11. (v3, controllo-preventivo 09/10) DEPOSITO 1000000 EUR invece di 100000, PRIMA di qualunque corsa: a lotto FISSO 1,00 il deposito non cambia n, PF,
#      DD in valuta ne' nessun numero letto; serve solo a non far scattare il margine. Il proxy (C035 T1 ~-76.000 USD, piu' fino a ~18.000 EUR di commissione
#      [NON MISURATA]) arrivava a un fattore ~1,1-1,5 dal fondo di 100000: il 'canarino' di S0 (classe 1204, soglia 50.000 EUR) era PREVISTO scattare e
#      avrebbe imposto una v3 fra S0 e R1B, e la regola non stava nella riga di R1B (classe 1206). La deviazione 9 (KO su margine/stop out) RESTA come rete.
#      Le righe '-- ordine saltato' dell'EA diverse dal margine (SL troppo vicino, lotto nullo, OrderCalcMargin, prezzi/ATR) si CONTANO nella testa del log.
#  12. (v4, 10/10) PARAMETRO -Prova: la v3 aveva il NOME del file prova ($PROVA), i tre lotti ammessi (S0|R1A|R1B) e i CONTEGGI dei blocchi (3 tranche, 4 celle,
#      3 lotti) scritti nel sorgente: non poteva leggere il file del lotto R2REG (GBA_R2_REGIME_2026-10-10.txt: 6 tranche, 2 celle, 1 lotto). Ora una tabella
#      ($PROVE_AMMESSE) lega ogni file prova ai suoi lotti e ai suoi conteggi; il DEFAULT di -Prova e' il file della v3, quindi una riga vecchia (S0/R1A/R1B)
#      si comporta come prima. Un -Prova fuori tabella ferma tutto. Nient'altro e' cambiato: stessi 30 pin, stesso asse tecnico, stessi controlli, stessa
#      cella REPL. Cio' che resta cablato e DICHIARATO: EA, simbolo XAUUSD, M1, versione 1.10, deposito 1000000, lotto fisso 1,00.
#  13. (v5, 10/10, BOZZA) FILE PROVA DICHIARATIVO per il piano R2 (report/GBA_R2_PIANO_2026-10-10.md par. 3.5): la v4 accettava come variabile di cella SOLO
#      InpSpreadMaxATR e aveva simbolo/TF cablati. Ora i file prova sono di DUE specie, e nient'altro:
#      (a) STORICI, per nome, nella tabella $PROVE_AMMESSE (GBA_R0_REPLICA_2026-10-09.txt, GBA_R2_REGIME_2026-10-10.txt): leggono ESATTAMENTE come in v4
#          (asse InpSpreadMaxATR, conteggi dalla tabella, cella REPL obbligatoria, InpSymbol=XAUUSD, InpSignalTF=1). Un blocco @GBA-ASSE in un file storico = stop.
#      (b) DICHIARATIVI: qualunque altro nome (solo lettere, cifre, _ . -, finale .txt) e un blocco OBBLIGATORIO
#          '# @GBA-ASSE chiave=<InpXxx> tranche=<n> celle=<n> lotti=<n>': la chiave e' la SOLA variabile del file (una per file, regola di casa), i conteggi
#          sono la guardia contro un file tronco (oltre allo SHA256 della riga). Le chiavi ammesse come asse sono in $TIPI_INPUT (22 input dell'EA, ognuno col
#          suo tipo e la sua riga AVVIO); NON sono ammesse come asse: InpLotMode, InpLots, InpRiskPct (rischio: decisione di Claudio 09/10, lotto fisso 1,00),
#          InpMagic (asse tecnico), InpComment, InpUsaGuardian, InpVerbose, InpAutoTest, InpCheckFreeMargin. La cella REPL e' FACOLTATIVA (l'ancora puo' venire
#          da R1A, il lettore la trova dall'ini), ma se c'e' deve coincidere col pin; una cella col valore del pin sotto un altro nome, o due celle con lo stesso
#          valore = stop. I lotti di un file dichiarativo NON possono chiamarsi S0, R1A, R1B, R2REG (il lettore da' a quei nomi una semantica fissa).
#      SIMBOLO E TF PER PASSATA: Symbol= e Period= del .ini vengono da InpSymbol e InpSignalTF EFFETTIVI della passata (pin, o cella se l'asse e' uno dei due);
#      il grafico del tester gira sul TF del SEGNALE (per i file storici e' M1 come prima). Tutti i controlli sul simbolo e sul periodo (report, finestra girata,
#      barre generate, inizio dei tick) usano quelli della passata. InpSignalTF=0 (PERIOD_CURRENT) e' vietato: il TF del segnale va scritto.
#      CONTROLLI IN PIU' (i file storici li passano tutti: provato con pwsh, NON su Windows PowerShell 5.1): nomi doppi di tranche/celle/lotti, tranche con
#      da >= a, voci di passata doppie, tipi e intervalli dei 22 input. AVVIO: ogni valore atteso deve essere seguito da un carattere che NON e' una cifra
#      o un punto (in v4 'InpHourEnd=2' sarebbe stato trovato dentro 'InpHourEnd=24': con l'orario come asse e' un falso OK).
#      MANIFEST: cinque colonne IN CODA (asse;valore_asse;simbolo;periodo;prova); le 27 colonne di v4 restano identiche e nello stesso ordine.
#      G1: oltre al lotto S0 (invariato), ogni lotto dichiarativo con due gemelle (stessa cella e tranche, magic 775800 e 775850) le confronta.
#
#  E' UN BACKTEST, NON UN ORDINE. [Experts] AllowLiveTrading=false nel .ini: il terminale del PC di backtest e' loggato sul DEMO 50503392 e il 14/08/2026
#  da questa macchina sono partiti ordini VERI.
#
#  NON TOCCA, per nome: PRIMA SU QUESTO PC le installazioni C:\MT5_Backtest (cartella dati 04C7A32B) e C:\FundedNext_Manuale (cartella dati 2B8180C3);
#  POI il VPS VMI3047753 e TUTTE le sue cartelle dati (FTMO 541452707 in C:\FTMO, trial 1514806751, REALE 10105439 in C:\BCM_Reale, 100k 50504263, piccolo
#  50503392 sul VPS, manuale 50503635 in C:\MT5_MANUALE, banco 50504400 in C:\MT5_Backtest, Pepperstone, Tickmill). Scrive SOLO: la cartella
#  %USERPROFILE%\abtg_passata, MQL5\Experts e MQL5\Include del terminale BCM di questa macchina, i report .htm che il tester scrive nella cartella dati (Report=),
#  il Desktop. NON legge ne' scrive conti, ordini, posizioni, preset di nessuna sedia. NON tocca CODA.txt ne' il runner notturno (che gira sul VPS).
#
#  NIENTE EMOJI QUI DENTRO (regola del 17/08): Windows PowerShell 5.1 legge i .ps1 come ANSI e un'emoji dentro una stringa rompe il parser.
# =====================================================================
[CmdletBinding()]
param(
  [Parameter(Mandatory=$true)][string]$Pin,
  [Parameter(Mandatory=$true)][string]$Lotto,
  [Parameter(Mandatory=$true)][string]$ShaEA,
  [Parameter(Mandatory=$true)][string]$ShaInc,
  [Parameter(Mandatory=$true)][string]$ShaProva,
  [int]$TimeoutRunMin = 30,
  [string]$Prova = 'GBA_R0_REPLICA_2026-10-09.txt'
)

$ErrorActionPreference = 'Stop'
$IC = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentCulture   = $IC
[Threading.Thread]::CurrentThread.CurrentUICulture = $IC
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

$EXPERT = 'ABTG_GoldBreakoutATR'
# (v4) i file prova STORICI: nome -> numero di blocchi attesi (guardia contro un file tronco o cambiato) e lotti che contiene. Letti ESATTAMENTE come in v4.
$PROVE_AMMESSE = @{
  'GBA_R0_REPLICA_2026-10-09.txt' = @{ Tr = 3; Ce = 4; Lo = 3; Lotti = '^(S0|R1A|R1B)$' }
  'GBA_R2_REGIME_2026-10-10.txt'  = @{ Tr = 6; Ce = 2; Lo = 1; Lotti = '^(R2REG)$' }
}
$LOTTI_STORICI = @('S0', 'R1A', 'R1B', 'R2REG')
# (v5) un file prova DICHIARATIVO: nome semplice (finisce nel percorso e nell'URL al pin), conteggi e lotti dal suo blocco @GBA-ASSE
if($Prova -notmatch '^[A-Za-z0-9_.-]{1,80}\.txt$' -or $Prova.Contains('..')){ throw ('-Prova ' + $Prova + ': nome non ammesso (solo lettere, cifre, _ . -, finale .txt, niente cartelle).') }
$STORICA = $PROVE_AMMESSE.ContainsKey($Prova)
$PROVA  = $Prova
$CFG_PROVA = $null
if($STORICA){ $CFG_PROVA = $PROVE_AMMESSE[$Prova] }
$VERSIONE_ATTESA = '1.10'
# (v5) SIMBOLO e PERIODO del file (dai pin); quelli di OGNI passata stanno in $ru.Simbolo / $ru.Periodo (l'asse puo' essere InpSymbol o InpSignalTF)
$SIMBOLO = 'XAUUSD'
$PERIODO = 'M1'
# (v5) codici ENUM_TIMEFRAMES di MQL5 -> nome del periodo (ini del tester, report, giornale). 0 = PERIOD_CURRENT, ammesso solo per InpTrendTF/InpAtrTF.
$TF_NOMI = @{ 1 = 'M1'; 2 = 'M2'; 3 = 'M3'; 4 = 'M4'; 5 = 'M5'; 6 = 'M6'; 10 = 'M10'; 12 = 'M12'; 15 = 'M15'; 20 = 'M20'; 30 = 'M30'; 16385 = 'H1'; 16386 = 'H2'; 16387 = 'H3'; 16388 = 'H4'; 16390 = 'H6'; 16392 = 'H8'; 16396 = 'H12'; 16408 = 'D1'; 32769 = 'W1'; 49153 = 'MN1' }
# (v5) gli input che possono fare da ASSE, col loro tipo (validazione del valore e formato della riga AVVIO). Gli altri 8 pin NON sono assi (intestazione, dev. 13).
$TIPI_INPUT = @{
  InpSymbol = 'simbolo'; InpSignalTF = 'tf'; InpTrendTF = 'tf0'; InpAtrTF = 'tf0'
  InpChannelBars = 'int'; InpEmaPeriod = 'int'; InpAtrPeriod = 'int'; InpSpreadMaxATR = 'spread'
  InpAllowLong = 'bool'; InpAllowShort = 'bool'
  InpSL_ATR = 'dec'; InpTrail_ATR = 'dec'; InpTrailAtrMode = 'int01'; InpTimeExitBars = 'int'
  InpUseBreakeven = 'bool'; InpBE_TriggerATR = 'dec'; InpBE_OffsetATR = 'dec'
  InpSlippagePoints = 'int'; InpMaxDailyLoss = 'dec'; InpMaxTradesPerDay = 'int'; InpHourStart = 'ora0_23'; InpHourEnd = 'ora0_24'
}
$ASSE_ATTESO = 'InpMagic=775800||775800||50||775850||Y'
$MAGIC_AMMESSI = @('775800', '775850')
$N_PIN_ATTESI = 30
$TETTO_BARRE = 100000
$AVVISO_BARRE = 95000
if($Pin -notmatch '^[0-9a-fA-F]{40}$'){ throw '-Pin obbligatorio e di 40 caratteri esadecimali: senza, girerebbe la punta del branch spacciandola per un commit congelato.' }
$Pin = $Pin.ToLower()
if($STORICA){
  if($Lotto -cnotmatch $CFG_PROVA.Lotti){ throw ('-Lotto ' + $Lotto + ' non e un lotto del file prova ' + $PROVA + ' (ammessi: ' + $CFG_PROVA.Lotti + ').') }
} else {
  # (v5) il lotto deve esistere nel file (si verifica dopo averlo letto); qui solo il formato e i nomi riservati
  if($Lotto -cnotmatch '^[A-Z0-9]{1,12}$'){ throw ('-Lotto ' + $Lotto + ': nome non ammesso (1-12 maiuscole o cifre).') }
  if($LOTTI_STORICI -contains $Lotto){ throw ('-Lotto ' + $Lotto + ' e un nome RISERVATO ai file prova storici (' + ($LOTTI_STORICI -join ', ') + '): il lettore gli da una semantica fissa.') }
}
foreach($hx in @($ShaEA, $ShaInc, $ShaProva)){ if($hx -notmatch '^[0-9a-fA-F]{64}$'){ throw '-ShaEA, -ShaInc e -ShaProva devono essere di 64 caratteri esadecimali (SHA256 calcolato dal commit, mai dal disco).' } }
$ShaEA = $ShaEA.ToUpper(); $ShaInc = $ShaInc.ToUpper(); $ShaProva = $ShaProva.ToUpper()
if($TimeoutRunMin -lt 1 -or $TimeoutRunMin -gt 90){ throw '-TimeoutRunMin fuori da 1-90 minuti.' }
$RAW = 'https://raw.githubusercontent.com/claudiospadaro12/GITHUB/' + $Pin + '/'

function Dico($t,$c='Gray'){ Write-Host ('   ' + $t) -ForegroundColor $c }
function Titolo($t){ Write-Host ''; Write-Host ('=== ' + $t + ' ===') -ForegroundColor Cyan }
function Num($s){ return [double]::Parse($s, [Globalization.NumberStyles]::Float, $IC) }
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
# i blocchi leggibili a macchina del file prova: '#  @GBA-TIPO k=v k=v ...'
function BloccoGba($riga){
  $h = @{}
  foreach($kv in ($riga -split '\s+')){
    if($kv -eq ''){ continue }
    $p = $kv -split '=', 2
    if($p.Count -ne 2){ throw ('blocco @GBA malformato: ' + $riga) }
    if($h.ContainsKey($p[0])){ throw ('blocco @GBA con chiave doppia ' + $p[0] + ': ' + $riga) }
    $h[$p[0]] = $p[1]
  }
  return $h
}
# (v5) un valore di input contro il suo tipo: '' se va bene, altrimenti il motivo
function ValoreNonValido($chiave, $v){
  if(-not $TIPI_INPUT.ContainsKey($chiave)){ return '' }
  switch($TIPI_INPUT[$chiave]){
    'simbolo' { if($v -notmatch '^[A-Za-z0-9_.#-]{1,30}$'){ return ($chiave + '=' + $v + ': simbolo non valido (vuoto vietato: il simbolo va scritto)') } }
    'tf'      { if($v -notmatch '^[0-9]{1,5}$' -or -not $TF_NOMI.ContainsKey([int]$v)){ return ($chiave + '=' + $v + ': non e un codice ENUM_TIMEFRAMES (0 = PERIOD_CURRENT vietato per il TF del segnale)') } }
    'tf0'     { if($v -notmatch '^[0-9]{1,5}$' -or ([int]$v -ne 0 -and -not $TF_NOMI.ContainsKey([int]$v))){ return ($chiave + '=' + $v + ': non e un codice ENUM_TIMEFRAMES (0 = PERIOD_CURRENT)') } }
    'int'     { if($v -notmatch '^[0-9]{1,6}$'){ return ($chiave + '=' + $v + ': intero non negativo atteso') } }
    'int01'   { if($v -notmatch '^[01]$'){ return ($chiave + '=' + $v + ': ammessi 0 e 1') } }
    'ora0_23' { if($v -notmatch '^[0-9]{1,2}$' -or [int]$v -gt 23){ return ($chiave + '=' + $v + ': ora 0-23') } }
    'ora0_24' { if($v -notmatch '^[0-9]{1,2}$' -or [int]$v -gt 24){ return ($chiave + '=' + $v + ': ora 0-24') } }
    'bool'    { if($v -cnotmatch '^(true|false)$'){ return ($chiave + '=' + $v + ': ammessi true e false') } }
    'dec'     { if($v -notmatch '^[0-9]{1,4}\.[0-9]{1,2}$'){ return ($chiave + '=' + $v + ': decimale col punto, al massimo 2 decimali (l EA lo stampa a 2: un terzo decimale renderebbe la riga AVVIO non verificabile)') } }
    'spread'  { if($v -notmatch '^[0-9]{1,2}\.[0-9]{1,3}$'){ return ($chiave + '=' + $v + ': decimale col punto, al massimo 3 decimali (l EA lo stampa a 3)') } }
  }
  return ''
}
# (v5) nome del TF come lo stampa EnumToString dell'EA
function TfEnum($v){ if([int]$v -eq 0){ return 'PERIOD_CURRENT' }; return ('PERIOD_' + $TF_NOMI[[int]$v]) }
# il report .htm di MT5: tabella di celle label / valore. Si tolgono i tag, si cerca "|ETICHETTA:|valore|". Etichette italiane e inglesi.
function CercaCella([string]$t, [string[]]$etichette){
  foreach($e in $etichette){
    $m = [regex]::Match($t, '\|' + $e + ':\|([^|]*)\|')
    if($m.Success){ return (([regex]::Replace($m.Groups[1].Value, '\s', ''))) }
  }
  return $null
}
function LeggiReport($path){
  $r = @{ Ok = $false; Trades = $null; Profitto = $null; PF = ''; Qualita = ''; Barre = $null; Ticks = $null; Motivo = ''; Expert = $null; Simbolo = $null; Periodo = $null }
  $testo = Leggi-Condiviso $path
  if([string]::IsNullOrEmpty($testo)){ $r.Motivo = 'report vuoto o illeggibile'; return $r }
  $t = [regex]::Replace($testo, '<[^>]+>', '|')
  $t = [regex]::Replace($t, '\s*\|[\s|]*', '|')
  $vt = CercaCella $t @('Numero di Operazioni di Trading Totali', 'Total Trades')
  $vp = CercaCella $t @('Profitto Totale Netto', 'Total Net Profit')
  $vf = CercaCella $t @('Fattore di Profitto', 'Profit Factor')
  $vq = CercaCella $t @('Qualit. dello Storico', 'History Quality')
  $vb = CercaCella $t @('Barre', 'Bars')
  $vk = CercaCella $t @('Ticks')
  if($null -ne $vf){ $r.PF = $vf }
  if($null -ne $vq){ $r.Qualita = $vq }
  if($null -ne $vb -and $vb -match '^[0-9]+$'){ $r.Barre = [long]$vb }
  if($null -ne $vk -and $vk -match '^[0-9]+$'){ $r.Ticks = [long]$vk }
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
#  0. LA MACCHINA E IL TERMINALE. Fail-closed, come NATCLA_F0_PASSATE.
# ---------------------------------------------------------------------
Titolo '0 - MACCHINA E TERMINALE'
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){
  throw ('GBA_R0_PASSATE gira SOLO sul PC di backtest DESKTOP-H4D7CAJ. Qui la macchina si chiama: ' + $env:COMPUTERNAME + '. Sul VPS VMI3047753 non si lancia: la challenge FTMO sta operando (firma del 21/09/2026: i round girano sul PC di backtest).')
}
Dico ('pc   : ' + $env:COMPUTERNAME) 'Green'
Dico ('pin  : ' + $Pin) 'Green'
Dico ('lotto: ' + $Lotto) 'Green'
$Mutex = New-Object System.Threading.Mutex($false, 'Global\ABTG_GBA_R0')
$preso = $false
# un giro precedente interrotto (finestra chiusa, Ctrl+C, crash) lascia il blocco ABBANDONATO: .NET lo segnala con un'eccezione e il blocco e comunque nostro
try{ $preso = $Mutex.WaitOne(0) } catch [System.Threading.AbandonedMutexException] { $preso = $true; Dico 'il blocco Global\ABTG_GBA_R0 era stato lasciato da un giro INTERROTTO: lo riprendo (nessun altro giro sta girando)' 'Yellow' }
if(-not $preso){
  throw 'Un ALTRO giro di GBA_R0 sta gia girando su questo PC (mutex Global\ABTG_GBA_R0 occupato). Un solo giro alla volta: aspetta che finisca, NON chiudere il suo terminale.'
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
Scarica ('mql5/Experts/' + $EXPERT + '.mq5') $srcEA 'GbaDecidi'
Scarica 'mql5/Include/ABTG_PausaGuardian.mqh' $srcInc 'ABTG_GuardiaIngresso'
Scarica ('backtest_pipeline/prove/' + $PROVA) $fileProva '@GBA-LOTTO'
foreach($ck in @(@($srcEA, $ShaEA, ($EXPERT + '.mq5')), @($srcInc, $ShaInc, 'ABTG_PausaGuardian.mqh'), @($fileProva, $ShaProva, $PROVA))){
  $hh = (Get-FileHash -LiteralPath $ck[0] -Algorithm SHA256).Hash
  if($hh -ne $ck[1]){ throw ($ck[2] + ' scaricato al pin ha SHA256 ' + $hh + ' invece di ' + $ck[1] + ' (quello calcolato dal commit): copia sbagliata o cache di GitHub. Non si parte.') }
  Dico ($ck[2] + ': SHA256 ' + $hh.Substring(0,12) + ' = quello della riga') 'Green'
}
if(-not (Select-String -LiteralPath $srcEA -Pattern ('#property\s+version\s+"' + [regex]::Escape($VERSIONE_ATTESA) + '"') -Quiet)){ throw ('il sorgente dell EA non dichiara #property version "' + $VERSIONE_ATTESA + '". Non si parte.') }

# --- il file prova: pin, asse tecnico, blocchi GBA
# >>> PARSING DEL FILE PROVA (v5: storico = come v4; dichiarativo = @GBA-ASSE). Il pezzo fra '>>>' e '<<<' e' quello provato con pwsh (dev. 13).
$pinProva = New-Object System.Collections.ArrayList
$assi = New-Object System.Collections.ArrayList
$blocchi = @{ TRANCHE = @(); CELLA = @(); LOTTO = @(); ASSE = @() }
foreach($r in (Get-Content -LiteralPath $fileProva)){
  $t = $r.Trim()
  if($t -match '^#\s*@GBA-(TRANCHE|CELLA|LOTTO|ASSE)\s+(.*)$'){ $tipoB = $Matches[1]; $corpoB = $Matches[2]; $blocchi[$tipoB] = @($blocchi[$tipoB]) + @((BloccoGba $corpoB)); continue }
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
foreach($kk in @('InpSymbol','InpSignalTF','InpChannelBars','InpEmaPeriod','InpAtrPeriod','InpSpreadMaxATR','InpSL_ATR','InpTrail_ATR','InpTimeExitBars','InpUseBreakeven','InpBE_TriggerATR','InpBE_OffsetATR','InpLotMode','InpLots','InpUsaGuardian','InpVerbose','InpAutoTest','InpHourStart','InpHourEnd','InpMaxTradesPerDay','InpMaxDailyLoss','InpAllowLong','InpAllowShort','InpSlippagePoints','InpCheckFreeMargin','InpTrailAtrMode','InpTrendTF','InpAtrTF','InpRiskPct','InpComment')){
  if(-not $pinH.ContainsKey($kk)){ throw ('il file prova non ha il pin ' + $kk + ': non e il file che lo script si aspetta. Non si parte.') }
}
# (v5) i 22 input con un tipo si validano gia' sui PIN (un pin storto farebbe girare l'EA con un valore che la riga AVVIO non puo' confermare)
foreach($kk in @($TIPI_INPUT.Keys | Sort-Object)){ $mv = ValoreNonValido $kk $pinH[$kk]; if($mv -ne ''){ throw ('pin non valido nel file prova: ' + $mv + '. Non si parte.') } }
if($STORICA){
  # file STORICO: identico a v4 (simbolo e TF cablati, asse InpSpreadMaxATR, conteggi dalla tabella)
  if(@($blocchi.ASSE).Count -ne 0){ throw ('il file prova storico ' + $PROVA + ' contiene un blocco @GBA-ASSE: un file storico e letto come in v4 e non ne ha. File cambiato? Non si parte.') }
  if($pinH['InpSymbol'] -ne $SIMBOLO){ throw ('InpSymbol del file prova e ' + $pinH['InpSymbol'] + ' invece di ' + $SIMBOLO + '. Non si parte.') }
  if($pinH['InpSignalTF'] -ne '1'){ throw 'InpSignalTF del file prova non e 1 (PERIOD_M1). Non si parte.' }
  $ASSE = 'InpSpreadMaxATR'
  $attTr = $CFG_PROVA.Tr; $attCe = $CFG_PROVA.Ce; $attLo = $CFG_PROVA.Lo
} else {
  # file DICHIARATIVO: un solo blocco '@GBA-ASSE chiave=.. tranche=.. celle=.. lotti=..'
  if(@($blocchi.ASSE).Count -ne 1){ throw ('il file prova ' + $PROVA + ' non e fra i file storici e ha ' + @($blocchi.ASSE).Count + ' blocchi @GBA-ASSE (ne serve UNO: la sola variabile del file). Non si parte.') }
  $bA = @($blocchi.ASSE)[0]
  if(@($bA.Keys).Count -ne 4 -or -not $bA.ContainsKey('chiave') -or -not $bA.ContainsKey('tranche') -or -not $bA.ContainsKey('celle') -or -not $bA.ContainsKey('lotti')){ throw 'il blocco @GBA-ASSE non ha esattamente chiave, tranche, celle, lotti.' }
  $ASSE = $bA['chiave']
  if(-not $TIPI_INPUT.ContainsKey($ASSE)){ throw ('chiave dell asse ' + $ASSE + ' non ammessa: gli assi possibili sono ' + (($TIPI_INPUT.Keys | Sort-Object) -join ', ') + ' (rischio, magic, commento, Guardian, stampe e margine NON sono assi).') }
  $ASSE = @($TIPI_INPUT.Keys | Where-Object { $_ -ceq $ASSE })
  if($ASSE.Count -ne 1){ throw ('chiave dell asse ' + $bA['chiave'] + ': maiuscole/minuscole diverse dal nome dell input (MT5 le distingue).') }
  $ASSE = $ASSE[0]
  foreach($cn in @('tranche', 'celle', 'lotti')){ if($bA[$cn] -notmatch '^[1-9][0-9]?$'){ throw ('@GBA-ASSE ' + $cn + '=' + $bA[$cn] + ': conteggio 1-99 atteso.') } }
  $attTr = [int]$bA['tranche']; $attCe = [int]$bA['celle']; $attLo = [int]$bA['lotti']
}
if($pinH['InpVerbose'] -ne 'true'){ throw 'InpVerbose del file prova non e true: senza, il giornale non ha le righe dei segnali. Non si parte.' }
if($pinH['InpLotMode'] -ne '0' -or (Num $pinH['InpLots']) -ne 1.0){ throw 'il file prova non ha lotto fisso 1,00 (InpLotMode=0, InpLots=1.0): decisione di Claudio del 09/10. Non si parte.' }
if(@($blocchi.TRANCHE).Count -ne $attTr -or @($blocchi.CELLA).Count -ne $attCe -or @($blocchi.LOTTO).Count -ne $attLo){ throw ('blocchi @GBA letti: tranche ' + @($blocchi.TRANCHE).Count + ' (attese ' + $attTr + '), celle ' + @($blocchi.CELLA).Count + ' (attese ' + $attCe + '), lotti ' + @($blocchi.LOTTO).Count + ' (attesi ' + $attLo + ') nel file prova ' + $PROVA + '. Non si parte.') }
$trDef = @{}
foreach($b in $blocchi.TRANCHE){
  if(@($b.Keys).Count -ne 3 -or -not $b.ContainsKey('nome') -or -not $b.ContainsKey('da') -or -not $b.ContainsKey('a')){ throw 'un blocco @GBA-TRANCHE non ha esattamente nome, da, a.' }
  if($b['da'] -notmatch '^\d{4}\.\d\d\.\d\d$' -or $b['a'] -notmatch '^\d{4}\.\d\d\.\d\d$'){ throw ('tranche ' + $b['nome'] + ': date non aaaa.mm.gg.') }
  if([string]::CompareOrdinal($b['da'], $b['a']) -ge 0){ throw ('tranche ' + $b['nome'] + ': da ' + $b['da'] + ' non e prima di a ' + $b['a'] + '.') }
  # (v5, classe 1251) il nome entra nel tag, quindi nei PERCORSI di ini/log/report e nelle colonne del MANIFEST: '..\', '/', ';', spazi e '$(' non devono passare
  if($b['nome'] -cnotmatch '^[A-Za-z0-9]{1,10}$'){ throw ('tranche ' + $b['nome'] + ': nome non ammesso (1-10 lettere o cifre).') }
  if($trDef.ContainsKey($b['nome'])){ throw ('tranche ' + $b['nome'] + ' dichiarata DUE volte nel file prova.') }
  $trDef[$b['nome']] = $b
}
# confronto di due valori dello stesso input, col suo tipo (0.5 = 0.50; 'true' distinto da 'True')
function StessoValore($chiave, $x, $y){
  switch($TIPI_INPUT[$chiave]){
    'spread' { return ((Num $x) -eq (Num $y)) }
    'dec'    { return ((Num $x) -eq (Num $y)) }
    'simbolo'{ return ($x -ceq $y) }
    'bool'   { return ($x -ceq $y) }
  }
  return ([long]$x -eq [long]$y)
}
$ceDef = @{}
foreach($b in $blocchi.CELLA){
  # UNA variabile per file prova: la cella puo' dichiarare SOLO nome e la chiave dell'asse
  if(@($b.Keys).Count -ne 2 -or -not $b.ContainsKey('nome') -or -not $b.ContainsKey($ASSE)){ throw ('la cella ' + $b['nome'] + ' dichiara qualcosa di diverso da ' + $ASSE + ': una variabile per file prova, lo script si ferma.') }
  if($STORICA){
    if($b['InpSpreadMaxATR'] -notmatch '^[0-9]+\.[0-9]+$'){ throw ('cella ' + $b['nome'] + ': InpSpreadMaxATR non e un decimale col punto.') }
  } else {
    if(-not ($b.Keys -ccontains $ASSE)){ throw ('la cella ' + $b['nome'] + ' scrive la chiave dell asse con maiuscole/minuscole diverse da ' + $ASSE + '.') }
    if($b['nome'] -cnotmatch '^[A-Za-z0-9]{1,10}$'){ throw ('cella ' + $b['nome'] + ': nome non ammesso (1-10 lettere o cifre).') }
    $mv = ValoreNonValido $ASSE $b[$ASSE]; if($mv -ne ''){ throw ('cella ' + $b['nome'] + ': ' + $mv) }
  }
  if($ceDef.ContainsKey($b['nome'])){ throw ('cella ' + $b['nome'] + ' dichiarata DUE volte nel file prova.') }
  $ceDef[$b['nome']] = $b
}
if($STORICA){
  if((Num $ceDef['REPL']['InpSpreadMaxATR']) -ne (Num $pinH['InpSpreadMaxATR'])){ throw 'la cella REPL non coincide col pin InpSpreadMaxATR del file prova: la replica non e la replica. Non si parte.' }
} else {
  if($ceDef.ContainsKey('REPL') -and -not (StessoValore $ASSE $ceDef['REPL'][$ASSE] $pinH[$ASSE])){ throw ('la cella REPL (' + $ASSE + '=' + $ceDef['REPL'][$ASSE] + ') non coincide col pin ' + $ASSE + '=' + $pinH[$ASSE] + ': la replica non e la replica. Non si parte.') }
  $nomiC = @($ceDef.Keys | Sort-Object)
  for($i = 0; $i -lt $nomiC.Count; $i++){
    $ci = $ceDef[$nomiC[$i]]
    if($nomiC[$i] -cne 'REPL' -and (StessoValore $ASSE $ci[$ASSE] $pinH[$ASSE])){ throw ('la cella ' + $nomiC[$i] + ' ha il valore del pin (' + $ASSE + '=' + $pinH[$ASSE] + '): e la REPL sotto un altro nome. Si chiama REPL, o cambia valore.') }
    for($j = $i + 1; $j -lt $nomiC.Count; $j++){
      if(StessoValore $ASSE $ci[$ASSE] $ceDef[$nomiC[$j]][$ASSE]){ throw ('le celle ' + $nomiC[$i] + ' e ' + $nomiC[$j] + ' hanno lo stesso valore di ' + $ASSE + ': sarebbero la stessa passata due volte.') }
    }
  }
}
$nomiLotti = @{}
foreach($b in $blocchi.LOTTO){
  if($nomiLotti.ContainsKey($b['nome'])){ throw ('lotto ' + $b['nome'] + ' dichiarato DUE volte nel file prova.') }
  $nomiLotti[$b['nome']] = $true
  if(-not $STORICA){
    if(@($b.Keys).Count -ne 4 -or -not $b.ContainsKey('nome') -or -not $b.ContainsKey('modello') -or -not $b.ContainsKey('tetto_min') -or -not $b.ContainsKey('passate')){ throw ('il blocco @GBA-LOTTO ' + $b['nome'] + ' non ha esattamente nome, modello, tetto_min, passate.') }
    if($b['nome'] -cnotmatch '^[A-Z0-9]{1,12}$' -or $LOTTI_STORICI -contains $b['nome']){ throw ('lotto ' + $b['nome'] + ': nome non ammesso in un file dichiarativo (1-12 maiuscole o cifre, non ' + ($LOTTI_STORICI -join '/') + ').') }
    if($b['tetto_min'] -notmatch '^[0-9]{1,3}$' -or [int]$b['tetto_min'] -lt 1){ throw ('lotto ' + $b['nome'] + ': tetto_min ' + $b['tetto_min'] + ' non e un numero di minuti 1-999.') }
  }
}
$lottoDef = @($blocchi.LOTTO | Where-Object { $_['nome'] -eq $Lotto })
if($lottoDef.Count -ne 1){ throw ('lotto ' + $Lotto + ' non trovato (o doppio) nel file prova.') }
$lottoDef = $lottoDef[0]
$tettoMin = [int]$lottoDef['tetto_min']
$modello = [int]$lottoDef['modello']
if($modello -ne 1 -and $modello -ne 4){ throw ('modello del lotto ' + $Lotto + ' = ' + $modello + ': ammessi 1 (OHLC su M1) e 4 (ticks reali).') }
$runs = New-Object System.Collections.ArrayList
$vociViste = @{}
foreach($voce in ($lottoDef['passate'] -split ',')){
  $pz = $voce -split ':'
  if($pz.Count -lt 2 -or $pz.Count -gt 3){ throw ('voce di passata malformata: ' + $voce) }
  if(-not $ceDef.ContainsKey($pz[0])){ throw ('cella ' + $pz[0] + ' del lotto ' + $Lotto + ' inesistente.') }
  if(-not $trDef.ContainsKey($pz[1])){ throw ('tranche ' + $pz[1] + ' del lotto ' + $Lotto + ' inesistente.') }
  $mg = '775800'; if($pz.Count -eq 3){ $mg = $pz[2] }
  if($MAGIC_AMMESSI -notcontains $mg){ throw ('magic ' + $mg + ' non ammesso (solo i due dell asse tecnico: ' + ($MAGIC_AMMESSI -join ', ') + ').') }
  $kv = $pz[0] + ':' + $pz[1] + ':' + $mg
  if($vociViste.ContainsKey($kv)){ throw ('passata ' + $kv + ' scritta DUE volte nel lotto ' + $Lotto + ': la stessa misura girerebbe due volte e il lettore la conterebbe doppia.') }
  $vociViste[$kv] = $true
  # (v5) i pin EFFETTIVI della passata: quelli del file, con la chiave dell'asse presa dalla cella
  $eff = @{}; foreach($pk in @($pinH.Keys)){ $eff[$pk] = $pinH[$pk] }
  $eff[$ASSE] = $ceDef[$pz[0]][$ASSE]
  [void]$runs.Add([pscustomobject]@{ Cella = $ceDef[$pz[0]]; Tranche = $trDef[$pz[1]]; Magic = $mg; Eff = $eff; Simbolo = $eff['InpSymbol']; Periodo = $TF_NOMI[[int]$eff['InpSignalTF']] })
}
$SIMBOLO = $pinH['InpSymbol']; $PERIODO = $TF_NOMI[[int]$pinH['InpSignalTF']]
$simTf = ((@($runs | ForEach-Object { $_.Simbolo }) | Select-Object -Unique) -join '/') + ' ' + ((@($runs | ForEach-Object { $_.Periodo }) | Select-Object -Unique) -join '/')
# <<< PARSING DEL FILE PROVA
Dico ('file prova letto: ' + $pinProva.Count + ' pin + asse tecnico; lotto ' + $Lotto + ': ' + $runs.Count + ' passate, Modello ' + $modello + ', tetto ' + $tettoMin + ' minuti') 'Green'
Dico ('variabile del file: ' + $ASSE + $(if($STORICA){ ' (file prova storico, letto come in v4)' } else { ' (file prova dichiarativo, @GBA-ASSE)' }) + '   simbolo/TF delle passate: ' + $simTf) 'Green'

Copy-Item -LiteralPath $srcEA  -Destination (Join-Path $MqlExp ($EXPERT + '.mq5')) -Force
Copy-Item -LiteralPath $srcInc -Destination (Join-Path $MqlInc 'ABTG_PausaGuardian.mqh') -Force

$ex5 = Join-Path $MqlExp ($EXPERT + '.ex5')
$logC = Join-Path $Work 'compile_gba.log'
# il verdetto NON e' il codice d'uscita di MetaEditor (a volte si stacca): e' l'esistenza dell'.ex5 appena prodotto. Ogni argomento fra parentesi (classe 1152).
# COMPILAZIONE FALLITA: e' la PRIMA compilazione vera di ABTG_GoldBreakoutATR (mai compilato: report/EA_GBA_NOTE_2026-10-09.md par. 3). Il log di MetaEditor
# va in uno zip sul Desktop (GBA_R0_<lotto>_COMPILAZIONE_FALLITA.zip), non solo nella finestra; nessuna passata parte.
function FermaCompilazione($perche){
  $dskC  = [Environment]::GetFolderPath('Desktop')
  $CartC = Join-Path $dskC ('GBA_R0_' + $Lotto + '_COMPILAZIONE_FALLITA')
  $zipC  = $CartC + '.zip'
  $stC   = (Get-Date).ToString('yyyyMMdd_HHmmss')
  try{
    if(Test-Path -LiteralPath $CartC){ Move-Item -LiteralPath $CartC -Destination ($CartC + '_VECCHIA_' + $stC) -Force }
    if(Test-Path -LiteralPath $zipC){ Move-Item -LiteralPath $zipC -Destination ($CartC + '_VECCHIO_' + $stC + '.zip') -Force }
    New-Item -ItemType Directory -Force -Path $CartC | Out-Null
    $haLog = Test-Path -LiteralPath $logC
    $righeLog = @()
    if($haLog){
      Copy-Item -LiteralPath $logC -Destination (Join-Path $CartC 'compile_gba.log') -Force
      $righeLog = @(((Leggi-Condiviso $logC) -split "`r?`n") | Where-Object { $_ -match '(?i)error|errori|warning|avvis|result|risultato' } | Select-Object -First 60)
    }
    $testaC = @(('GBA R0 lotto ' + $Lotto + ': COMPILAZIONE DI ' + $EXPERT + ' FALLITA. Nessuna passata lanciata, nessun ordine.'), ('motivo: ' + $perche), ('pin: ' + $Pin + '   pc: ' + $env:COMPUTERNAME + '   data: ' + $stC), ('log di MetaEditor presente: ' + $haLog), '', 'righe di errore/avviso del log (il log intero e compile_gba.log):')
    (($testaC + $righeLog) -join "`r`n") | Set-Content -LiteralPath (Join-Path $CartC 'COMPILAZIONE_FALLITA.txt') -Encoding ASCII
    Compress-Archive -Path (Join-Path $CartC '*') -DestinationPath $zipC -Force
    Write-Host ('   ZIP DA MANDARE (compilazione fallita): ' + $zipC) -ForegroundColor Red
  } catch { Write-Host ('   zip della compilazione NON creato (' + $_.Exception.Message + '): il log e in ' + $logC) -ForegroundColor Red }
  throw ('COMPILAZIONE FALLITA: ' + $perche + ' Nessuna passata e partita. Manda lo zip GBA_R0_' + $Lotto + '_COMPILAZIONE_FALLITA.zip dal Desktop.')
}
Remove-Item -LiteralPath $logC -Force -ErrorAction SilentlyContinue
Remove-Item -LiteralPath $ex5 -Force -ErrorAction SilentlyContinue
# classe 1168 (i): un .ex5 VECCHIO che resta sul disco passerebbe per il compilato nuovo
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
#  2. LE PASSATE SINGOLE (Optimization=0)
# ---------------------------------------------------------------------
$dsk  = [Environment]::GetFolderPath('Desktop')
$Cart = Join-Path $dsk ('GBA_R0_' + $Lotto)
$zip  = Join-Path $dsk ('GBA_R0_' + $Lotto + '.zip')
$stampa = (Get-Date).ToString('yyyyMMdd_HHmmss')
if(Test-Path -LiteralPath $Cart){ Move-Item -LiteralPath $Cart -Destination ($Cart + '_VECCHIA_' + $stampa) -Force; Dico ('cartella di un giro PRECEDENTE rinominata: ' + $Cart + '_VECCHIA_' + $stampa) 'Yellow' }
if(Test-Path -LiteralPath $zip){ Move-Item -LiteralPath $zip -Destination (Join-Path $dsk ('GBA_R0_' + $Lotto + '_VECCHIO_' + $stampa + '.zip')) -Force; Dico ('zip di un giro PRECEDENTE rinominato con la data') 'Yellow' }
New-Item -ItemType Directory -Force -Path $Cart | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $Cart 'report'), (Join-Path $Cart 'log'), (Join-Path $Cart 'ini') | Out-Null
Copy-Item -LiteralPath $fileProva -Destination $Cart -Force
if(Test-Path -LiteralPath $logC){ Copy-Item -LiteralPath $logC -Destination (Join-Path $Cart 'compile_gba.log') -Force }

$LogRoot = Join-Path $env:APPDATA 'MetaQuotes'
$RadiciLog = @($LogRoot, (Join-Path $InstAttesa 'Tester'))
$reFin = New-Object Text.RegularExpressions.Regex(('Tester\s+(?<sim>[A-Za-z0-9_.#-]+),(?<tf>[A-Za-z0-9]+)(?:\s+\([^)]*\))?:\s+testing of Experts\\' + [regex]::Escape($EXPERT) + '\.ex5 from (?<da>\d{4}\.\d\d\.\d\d) (?<ha>\d\d:\d\d) to (?<a>\d{4}\.\d\d\.\d\d) (?<hb>\d\d:\d\d)'), [Text.RegularExpressions.RegexOptions]::IgnoreCase)
$reGba = New-Object Text.RegularExpressions.Regex('(?<st>\d{4}\.\d\d\.\d\d \d\d:\d\d:\d\d)\s+(?<msg>\[GBA.*)$')
$reBarre = New-Object Text.RegularExpressions.Regex('(?<sim>[A-Za-z0-9_.#-]+),(?<tf>[A-Za-z0-9]+): (?<tick>\d+) ticks, (?<barre>\d+) bars generated')
$reTickIni = New-Object Text.RegularExpressions.Regex('(?<sim>[A-Za-z0-9_.#-]+): ticks data begins from (?<d>\d{4}\.\d\d\.\d\d)')
$reIngresso = New-Object Text.RegularExpressions.Regex('^\[GBA\] (BUY|SELL) [0-9.]+ lotti @')

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
# la riga AVVIO e le righe dei parametri, scritte come l'EA le stampa (PrintFormat: spread a 3 decimali, gli altri decimali a 2)
function Dec2($s){ return (Num $s).ToString('0.00', $IC) }
# (v5) dai pin EFFETTIVI della passata ($eff = pin del file con la chiave dell'asse presa dalla cella): ogni input con un tipo ha la sua riga attesa,
# compresi simbolo e TF (PERIOD_CURRENT -> TF del segnale, come l'EA). Per i file storici le stringhe sono IDENTICHE a quelle di v4 (provato con pwsh).
function Int0($s){ return ([long]$s).ToString($IC) }
function NeedlesAvvio($eff, $magic){
  $n = New-Object System.Collections.ArrayList
  $sig = TfEnum $eff['InpSignalTF']
  [void]$n.Add('AVVIO v' + $VERSIONE_ATTESA)
  [void]$n.Add('InpSymbol="' + $eff['InpSymbol'] + '" -> simbolo ' + $eff['InpSymbol'])
  [void]$n.Add('InpSignalTF=' + $sig + ' -> ' + $sig)
  foreach($kt in @('InpTrendTF', 'InpAtrTF')){
    $ris = $sig; if([int]$eff[$kt] -ne 0){ $ris = TfEnum $eff[$kt] }
    [void]$n.Add($kt + '=' + (TfEnum $eff[$kt]) + ' -> ' + $ris)
  }
  [void]$n.Add('InpChannelBars=' + (Int0 $eff['InpChannelBars']) + ' (')
  [void]$n.Add('InpEmaPeriod=' + (Int0 $eff['InpEmaPeriod']) + ' |')
  [void]$n.Add('InpAtrPeriod=' + (Int0 $eff['InpAtrPeriod']) + ' |')
  [void]$n.Add('InpSpreadMaxATR=' + (Num $eff['InpSpreadMaxATR']).ToString('0.000', $IC))
  [void]$n.Add('InpAllowLong=' + $eff['InpAllowLong'] + ' | InpAllowShort=' + $eff['InpAllowShort'])
  [void]$n.Add('InpSL_ATR=' + (Dec2 $eff['InpSL_ATR']) + ' |')
  [void]$n.Add('InpTrail_ATR=' + (Dec2 $eff['InpTrail_ATR']) + ' |')
  [void]$n.Add('InpTrailAtrMode=' + (Int0 $eff['InpTrailAtrMode']) + ' (')
  [void]$n.Add('InpTimeExitBars=' + (Int0 $eff['InpTimeExitBars']))
  [void]$n.Add('InpUseBreakeven=' + $eff['InpUseBreakeven'] + ' |')
  [void]$n.Add('InpBE_TriggerATR=' + (Dec2 $eff['InpBE_TriggerATR']) + ' |')
  [void]$n.Add('InpBE_OffsetATR=' + (Dec2 $eff['InpBE_OffsetATR']))
  [void]$n.Add('InpSlippagePoints=' + (Int0 $eff['InpSlippagePoints']) + ' |')
  [void]$n.Add('InpMaxDailyLoss=' + (Dec2 $eff['InpMaxDailyLoss']))
  [void]$n.Add('InpMaxTradesPerDay=' + (Int0 $eff['InpMaxTradesPerDay']))
  [void]$n.Add('InpCheckFreeMargin=' + $eff['InpCheckFreeMargin'] + ' |')
  [void]$n.Add('InpHourStart=' + (Int0 $eff['InpHourStart']) + ' |')
  [void]$n.Add('InpHourEnd=' + (Int0 $eff['InpHourEnd']))
  [void]$n.Add('InpLotMode=' + $eff['InpLotMode'] + ' (')
  [void]$n.Add('InpLots=' + (Dec2 $eff['InpLots']) + ' |')
  [void]$n.Add('InpMagic=' + $magic + ' |')
  [void]$n.Add('InpComment="' + $eff['InpComment'] + '"')
  [void]$n.Add('InpUsaGuardian=' + $eff['InpUsaGuardian'])
  [void]$n.Add('InpVerbose=' + $eff['InpVerbose'])
  [void]$n.Add('InpAutoTest=' + $eff['InpAutoTest'])
  return $n
}
# (v5) un valore atteso e' presente solo se NON e' seguito da una cifra o da un punto: 'InpHourEnd=2' non si trova piu' dentro 'InpHourEnd=24'
function TrovaNeedle([string]$testo, [string]$nd){ return [regex]::IsMatch($testo, [regex]::Escape($nd) + '(?![0-9.])') }
# (v5) il .ini della passata: i 30 pin del file prova, con SOLO la chiave dell'asse dalla cella e il magic della passata (asse tecnico)
function TestoIni($ru, $nomeRep){
  $righeIn = New-Object System.Collections.ArrayList
  foreach($pp in $pinProva){
    $val = $pp[1]
    if($pp[0] -eq $ASSE){ $val = $ru.Cella[$ASSE] }
    [void]$righeIn.Add($pp[0] + '=' + $val)
  }
  [void]$righeIn.Add('InpMagic=' + $ru.Magic)
  return ("[Experts]`r`nAllowLiveTrading=false`r`nAllowDllImport=false`r`n`r`n" +
          "[Tester]`r`nExpert=" + $EXPERT + ".ex5`r`nSymbol=" + $ru.Simbolo + "`r`nPeriod=" + $ru.Periodo + "`r`nModel=" + $modello + "`r`n" +
          "Optimization=0`r`nFromDate=" + $ru.Tranche['da'] + "`r`nToDate=" + $ru.Tranche['a'] + "`r`nForwardMode=0`r`nDeposit=1000000`r`nCurrency=EUR`r`nLeverage=100`r`n" +
          "ExecutionMode=0`r`nReplaceReport=1`r`nShutdownTerminal=1`r`nReport=" + $nomeRep + "`r`n`r`n" +
          "[TesterInputs]`r`n" + ($righeIn -join "`r`n") + "`r`n")
}

Titolo ('2 - LOTTO ' + $Lotto + ': ' + $runs.Count + ' PASSATE SINGOLE (Modello ' + $modello + ', deposito 1000000 EUR, lotto fisso 1,00)')
$TLotto = Get-Date
$manifest = New-Object System.Collections.ArrayList
[void]$manifest.Add('lotto;passata;cella;spread_max_atr;tranche;da;a;modello;magic;t_avvio;durata_s;stato;trades_report;profitto_report;pf_report;qualita;barre_report;ticks_report;barre_gen;ticks_gen;ticks_inizio;righe_gba;ingressi_log;avvio_ok;autotest;finestra;motivi;asse;valore_asse;simbolo;periodo;prova')
$nOk = 0; $nKo = 0; $nNon = 0; $sommaDur = 0.0; $nDur = 0
$abort = $false
$k = 0
$riassunti = @{}
foreach($ru in $runs){
  $k = $k + 1
  $cella = $ru.Cella; $tr = $ru.Tranche; $mg = $ru.Magic
  $SIMP = $ru.Simbolo; $PERP = $ru.Periodo
  # (v5) colonne in coda al manifest: asse;valore_asse;simbolo;periodo;prova (le 27 di v4 restano identiche)
  $coda = ';' + $ASSE + ';' + $cella[$ASSE] + ';' + $SIMP + ';' + $PERP + ';' + $PROVA
  $spreadEff = $ru.Eff['InpSpreadMaxATR']
  $tag = $Lotto + '_' + $k.ToString('00') + '_' + $cella['nome'] + '_' + $tr['nome'] + '_m' + $mg
  $etich = '[' + $k + '/' + $runs.Count + '] ' + $cella['nome'] + ' ' + $tr['nome'] + ' magic ' + $mg
  $minDa = ((Get-Date) - $TLotto).TotalMinutes
  if($abort -or $minDa -ge $tettoMin){
    $nNon = $nNon + 1
    $why = 'tetto di ' + $tettoMin + ' minuti'; if($abort){ $why = 'lotto fermato' }
    [void]$manifest.Add($Lotto + ';' + $tag + ';' + $cella['nome'] + ';' + $spreadEff + ';' + $tr['nome'] + ';' + $tr['da'] + ';' + $tr['a'] + ';' + $modello + ';' + $mg + ';;0;NON_LANCIATA;;;;;;;;;;0;0;no;no;;' + $why + $coda)
    Write-Host ('   ' + $etich + '  NON LANCIATA (' + $why + ', minuto ' + [int]$minDa + ')') -ForegroundColor Red
    continue
  }
  if((@(Get-Process -Name terminal64 -ErrorAction SilentlyContinue)).Count -gt 0){
    Write-Host ('   ' + $etich + '  un terminal64 e ancora VIVO prima della passata: il lotto si ferma, non apro un secondo terminale.') -ForegroundColor Red
    $abort = $true; $nNon = $nNon + 1
    [void]$manifest.Add($Lotto + ';' + $tag + ';' + $cella['nome'] + ';' + $spreadEff + ';' + $tr['nome'] + ';' + $tr['da'] + ';' + $tr['a'] + ';' + $modello + ';' + $mg + ';;0;NON_LANCIATA;;;;;;;;;;0;0;no;no;;terminale ancora vivo' + $coda)
    continue
  }
  # --- l'ini: i 30 pin del file prova, con SOLO la chiave dell'asse dalla cella e il magic della passata (asse tecnico); simbolo e TF della passata (v5)
  $nomeRep = 'GBA_R0_' + $tag
  $iniF = Join-Path $Work ('gba_' + $tag + '.ini')
  $testoIni = TestoIni $ru $nomeRep
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

  # --- lettura delle sole righe scritte DOPO la fotografia
  $gbaMsg = @{}; $gbaSt = @{}; $gbaOrd = New-Object System.Collections.ArrayList; $nGrezze = 0
  $fin = @{}; $evTester = @{}; $barreGen = $null; $tickGen = $null; $tickIni = @{}; $illeggibili = 0; $nSoldi = 0
  foreach($f in @(ElencoLog)){
    $off = 0; if($foto.ContainsKey($f.FullName)){ $off = [long]$foto[$f.FullName] }
    if($f.Length -le $off){ continue }
    try{ $testo = LeggiCoda $f.FullName $off }catch{ $illeggibili = $illeggibili + 1; continue }
    foreach($riga in ($testo -split "`r?`n")){
      if($riga.Length -lt 12){ continue }
      $mg2 = $reGba.Match($riga)
      if($mg2.Success){
        $nGrezze = $nGrezze + 1
        $msg = $mg2.Groups['msg'].Value.TrimEnd()
        $st = $mg2.Groups['st'].Value
        $kk2 = $st + '|' + $msg.Substring(0, [math]::Min(70, $msg.Length))
        if(-not $gbaMsg.ContainsKey($kk2)){ $gbaMsg[$kk2] = $msg; $gbaSt[$kk2] = $st; [void]$gbaOrd.Add($kk2) }
        elseif($msg.Length -gt $gbaMsg[$kk2].Length){ $gbaMsg[$kk2] = $msg }
        continue
      }
      # deposito esaurito / ordine rifiutato per soldi / Guardian che blocca: n e PF della passata sarebbero TRONCATI in silenzio (deviazione 9)
      if($riga -match '(?i)stop out|no money|not enough money|\[GUARDIA\].*INGRESSO'){ $nSoldi = $nSoldi + 1; if($evTester.Count -lt 60){ $evTester[$riga.Trim()] = $true }; continue }
      $mf = $reFin.Match($riga)
      if($mf.Success){ $fin[($mf.Groups['sim'].Value + '|' + $mf.Groups['tf'].Value + '|' + $mf.Groups['da'].Value + '|' + $mf.Groups['ha'].Value + '|' + $mf.Groups['a'].Value + '|' + $mf.Groups['hb'].Value)] = $mf; continue }
      $mb = $reBarre.Match($riga)
      if($mb.Success -and $mb.Groups['sim'].Value -eq $SIMP){ $barreGen = [long]$mb.Groups['barre'].Value; $tickGen = [long]$mb.Groups['tick'].Value; $evTester[$riga.Trim()] = $true; continue }
      $mt = $reTickIni.Match($riga)
      if($mt.Success){ $tickIni[$mt.Groups['sim'].Value + ' ' + $mt.Groups['d'].Value] = $true; $evTester[$riga.Trim()] = $true; continue }
      # le righe del TESTER che raccontano un guasto (storia mancante, errore, memoria, terminale non collegato): servono a capire una passata morta
      if($evTester.Count -lt 60 -and $riga -match "`tTester`t" -and $riga -match '(?i)history|no data|cannot|failed|error|stopped|not found|disconnect|authoriz|synchron|download|no memory|final balance|Test passed'){ $evTester[$riga.Trim()] = $true }
    }
  }
  $motivi = New-Object System.Collections.ArrayList
  if($timeout){ [void]$motivi.Add('timeout di ' + $TimeoutRunMin + ' minuti') }
  # --- il giornale dell'EA: AVVIO, AUTOTEST, CONTA FINE, ingressi
  $testoAvvio = ''; $nIngr = 0; $autoPass = 0; $autoFail = 0; $contaFine = 0; $avvioRighe = 0; $nMargine = 0; $nErrOrd = 0; $nSaltati = 0
  foreach($kk2 in $gbaOrd){
    $m3 = $gbaMsg[$kk2]
    if($m3.StartsWith('[GBA] MARGINE INSUFFICIENTE')){ $nMargine = $nMargine + 1 }
    if($m3.StartsWith('[GBA] ERRORE ordine')){ $nErrOrd = $nErrOrd + 1 }
    elseif($m3.IndexOf('ordine saltato', [StringComparison]::Ordinal) -ge 0 -and -not $m3.StartsWith('[GBA] MARGINE INSUFFICIENTE')){ $nSaltati = $nSaltati + 1 }
    if($m3.StartsWith('[GBA] AVVIO v')){ $avvioRighe = $avvioRighe + 1 }
    if($m3 -match '^\[GBA\] (AVVIO|SEGNALE|SPREAD|LATI|USCITE|BREAKEVEN|ESECUZIONE|RISCHIO|IDENTITA)'){ $testoAvvio = $testoAvvio + $m3 + "`n" }
    if($reIngresso.IsMatch($m3)){ $nIngr = $nIngr + 1 }
    if($m3.IndexOf('[GBA][AUTOTEST] VERDETTO: PASS', [StringComparison]::Ordinal) -ge 0){ $autoPass = $autoPass + 1 }
    if($m3.IndexOf('[GBA][AUTOTEST]', [StringComparison]::Ordinal) -ge 0 -and $m3.IndexOf('FAIL', [StringComparison]::Ordinal) -ge 0){ $autoFail = $autoFail + 1 }
    if($m3.StartsWith('[GBA-CONTA] FINE')){ $contaFine = $contaFine + 1 }
  }
  $avvioOk = 'no'
  if($avvioRighe -eq 0){ [void]$motivi.Add('riga AVVIO dell EA NON trovata nei log (l EA non e partito? compilazione? ini ignorata?)') }
  elseif($avvioRighe -gt 1){ [void]$motivi.Add('PIU righe AVVIO distinte (' + $avvioRighe + '): log di due passate mescolati') }
  else {
    $mancano = @()
    foreach($nd in (NeedlesAvvio $ru.Eff $mg)){ if(-not (TrovaNeedle $testoAvvio $nd)){ $mancano = $mancano + @($nd) } }
    if($mancano.Count -eq 0){ $avvioOk = 'si' } else { [void]$motivi.Add('AVVIO: nella configurazione stampata dall EA mancano ' + $mancano.Count + ' valori attesi: ' + (($mancano | Select-Object -First 6) -join ' ## ')) }
  }
  $autoOk = 'no'
  if($autoFail -gt 0){ [void]$motivi.Add('AUTOTEST dell EA: FAIL (' + $autoFail + ' righe): il compilato non fa quello che dice') }
  elseif($autoPass -ne 1){ [void]$motivi.Add('AUTOTEST: righe VERDETTO PASS = ' + $autoPass + ' (attesa 1)') }
  else { $autoOk = 'si' }
  if($contaFine -lt 1){ [void]$motivi.Add('riga [GBA-CONTA] FINE assente (OnDeinit non girato? passata interrotta?)') }
  if($nMargine -gt 0 -or $nSoldi -gt 0){ [void]$motivi.Add('DEPOSITO NON BASTATO: ' + $nMargine + ' ingressi saltati per MARGINE INSUFFICIENTE (EA) e ' + $nSoldi + ' righe stop out / no money / Guardian nel giornale: n e PF di questa passata sono TRONCATI. Si rifa con un deposito piu alto, non si legge') }
  # finestra girata, dal giornale del tester
  $finest = 'non letta'
  if($fin.Count -eq 1){
    $mf = $fin.Values | Select-Object -First 1
    $daG = $tr['da']; $aG = $tr['a']
    if($mf.Groups['sim'].Value -eq $SIMP -and $mf.Groups['tf'].Value -eq $PERP -and $mf.Groups['da'].Value -eq $daG -and $mf.Groups['a'].Value -eq $aG -and $mf.Groups['ha'].Value -eq '00:00' -and $mf.Groups['hb'].Value -eq '00:00'){ $finest = $daG + '-' + $aG }
    else { $finest = 'DIVERSA: ' + $mf.Groups['sim'].Value + ',' + $mf.Groups['tf'].Value + ' ' + $mf.Groups['da'].Value + '-' + $mf.Groups['a'].Value; [void]$motivi.Add('finestra girata ' + $finest + ' invece di ' + $SIMP + ',' + $PERP + ' ' + $daG + '-' + $aG) }
  } elseif($fin.Count -gt 1){ $finest = 'AMBIGUA'; [void]$motivi.Add('PIU intestazioni di passata nel giornale del tester: finestra non attribuibile') }
  # barre generate e profondita' dei tick
  if($null -eq $barreGen){ [void]$motivi.Add('riga "N ticks, M bars generated" NON trovata nel giornale del tester: il conto delle barre contro il tetto non e verificabile') }
  elseif($barreGen -ge $TETTO_BARRE){ [void]$motivi.Add('barre generate ' + $barreGen + ' >= ' + $TETTO_BARRE + ': la finestra e stata TRONCATA dal tetto del tester, la tranche va accorciata') }
  elseif($barreGen -ge $AVVISO_BARRE){ Dico ('   ATTENZIONE: barre generate ' + $barreGen + ' fra ' + $AVVISO_BARRE + ' e ' + $TETTO_BARRE + ': vicino al tetto') 'Yellow' }
  $tickIniTxt = (($tickIni.Keys | Sort-Object) -join ' / ')
  if($modello -eq 4){
    $okTick = $false; $nTickSim = 0
    foreach($tk in @($tickIni.Keys)){ $pz2 = $tk -split ' '; if($pz2[0] -eq $SIMP){ $nTickSim = $nTickSim + 1; if([string]::CompareOrdinal($pz2[1], $tr['da']) -le 0){ $okTick = $true } } }
    # conta SOLO la riga del simbolo della passata: quella di EURUSD (conversione, conto in EUR) non dice niente sui suoi tick
    if($nTickSim -eq 0){ Dico ('   (la riga "ticks data begins from" di ' + $SIMP + ' non e nel giornale di questa passata (altre: ' + $tickIniTxt + '): succede se i tick erano gia in cache; si riconferma dal report)') 'Yellow' }
    elseif(-not $okTick){ [void]$motivi.Add('ticks data begins from ' + $tickIniTxt + ': DOPO l inizio della tranche ' + $tr['da'] + ' (prima di quella data MT5 genera i tick: non sono reali)') }
  }
  # il report .htm
  $rep = $null
  foreach($rad in @($DataFolder, $InstAttesa, $Work, $MqlFiles, (Join-Path $env:USERPROFILE 'Desktop'))){
    if(-not (Test-Path -LiteralPath $rad)){ continue }
    $cr = @(Get-ChildItem -LiteralPath $rad -Filter ($nomeRep + '*.htm*') -File -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -ge $tRun } | Sort-Object LastWriteTime -Descending)
    if($cr.Count -gt 0){ $rep = $cr[0]; break }
  }
  $lr = $null; $nTrades = ''; $profitto = ''; $pfRep = ''; $qual = ''; $barRep = ''; $tickRep = ''
  if($null -eq $rep){ [void]$motivi.Add('report .htm della passata NON trovato (Report=' + $nomeRep + '): senza report non c e misura') }
  else {
    Copy-Item -LiteralPath $rep.FullName -Destination (Join-Path (Join-Path $Cart 'report') $rep.Name) -Force
    $lr = LeggiReport $rep.FullName
    if(-not $lr.Ok){ [void]$motivi.Add('report illeggibile: ' + $lr.Motivo) }
    else {
      $nTrades = [string]$lr.Trades; $profitto = [string]$lr.Profitto; $pfRep = $lr.PF; $qual = $lr.Qualita
      if($null -ne $lr.Barre){ $barRep = [string]$lr.Barre }
      if($null -ne $lr.Ticks){ $tickRep = [string]$lr.Ticks }
      if($null -ne $lr.Expert -and $lr.Expert -ne $EXPERT){ [void]$motivi.Add('il report e di un altro EA (' + $lr.Expert + ')') }
      if($null -ne $lr.Simbolo -and $lr.Simbolo -ne $SIMP){ [void]$motivi.Add('il report e di un altro simbolo (' + $lr.Simbolo + ')') }
      if($null -ne $lr.Periodo){
        $mpd = [regex]::Match($lr.Periodo, '^' + $PERP + '\((\d{4}\.\d\d\.\d\d)-(\d{4}\.\d\d\.\d\d)\)')
        if(-not $mpd.Success){ [void]$motivi.Add('il periodo del report e "' + $lr.Periodo + '" invece di ' + $PERP + ' (' + $tr['da'] + ' - ' + $tr['a'] + ')') }
        else {
          $dA = [datetime]::ParseExact($mpd.Groups[2].Value, 'yyyy.MM.dd', $IC); $dB = [datetime]::ParseExact($tr['a'], 'yyyy.MM.dd', $IC)
          if($mpd.Groups[1].Value -ne $tr['da'] -or [math]::Abs(($dA - $dB).TotalDays) -gt 1){ [void]$motivi.Add('il periodo del report e "' + $lr.Periodo + '" invece di ' + $PERP + ' (' + $tr['da'] + ' - ' + $tr['a'] + ')') }
        }
      }
      if($modello -eq 4 -and $lr.Qualita -notmatch '^100%'){ [void]$motivi.Add('qualita dello storico "' + $lr.Qualita + '" invece di 100% ticks reali: il verdetto a ticks reali NON vale') }
      if($lr.Trades -eq 0){ [void]$motivi.Add('ZERO operazioni nel report') }
      if([math]::Abs($lr.Trades - $nIngr) -gt 1){ [void]$motivi.Add('operazioni del report ' + $lr.Trades + ' contro ingressi del giornale ' + $nIngr + ' (attesi uguali, +/-1): righe del giornale perse o report di un altra passata') }
    }
  }
  # il log dell'EA di questa passata, per intero
  $lg = New-Object System.Collections.ArrayList
  [void]$lg.Add('# passata ' + $etich + '   ini gba_' + $tag + '.ini   durata ' + [int]$dur + ' s   righe [GBA] uniche ' + $gbaOrd.Count + ' (grezze ' + $nGrezze + ')   margine insufficiente ' + $nMargine + '   stop out/no money/Guardian ' + $nSoldi + '   errori d ordine ' + $nErrOrd + '   altri ordini saltati ' + $nSaltati)
  foreach($e in $evTester.Keys){ [void]$lg.Add('# TESTER ' + $e) }
  foreach($e in $fin.Keys){ [void]$lg.Add('# FINESTRA ' + $e) }
  foreach($kk2 in $gbaOrd){ [void]$lg.Add($gbaSt[$kk2] + '   ' + $gbaMsg[$kk2]) }
  ($lg -join "`r`n") | Set-Content -LiteralPath (Join-Path (Join-Path $Cart 'log') ('GBA_' + $tag + '.txt')) -Encoding ASCII

  $stato = 'OK'
  if($motivi.Count -gt 0){ $stato = 'KO' }
  if($finest -eq 'non letta' -and $motivi.Count -eq 0){ $stato = 'OK_FINESTRA_NON_LETTA' }
  if($stato -like 'OK*'){ $nOk = $nOk + 1; $sommaDur = $sommaDur + $dur; $nDur = $nDur + 1 } else { $nKo = $nKo + 1 }
  $bgTxt = ''; if($null -ne $barreGen){ $bgTxt = [string]$barreGen }
  $tgTxt = ''; if($null -ne $tickGen){ $tgTxt = [string]$tickGen }
  [void]$manifest.Add($Lotto + ';' + $tag + ';' + $cella['nome'] + ';' + $spreadEff + ';' + $tr['nome'] + ';' + $tr['da'] + ';' + $tr['a'] + ';' + $modello + ';' + $mg + ';' + $tRun.ToString('yyyy-MM-dd HH:mm:ss') + ';' + [int]$dur + ';' + $stato + ';' + $nTrades + ';' + $profitto + ';' + $pfRep + ';' + $qual + ';' + $barRep + ';' + $tickRep + ';' + $bgTxt + ';' + $tgTxt + ';' + $tickIniTxt + ';' + $gbaOrd.Count + ';' + $nIngr + ';' + $avvioOk + ';' + $autoOk + ';' + $finest + ';' + (($motivi -join ' | ') -replace ';', ',') + $coda)
  if($lr -and $lr.Ok){ $riassunti[$cella['nome'] + '|' + $tr['nome'] + '|' + $mg] = $lr }
  $col = 'Green'; if($stato -ne 'OK'){ $col = 'Red' }
  Write-Host ('   ' + $etich + '  ' + $stato + '   ' + [int]$dur + ' s   operazioni ' + $nTrades + '   profitto ' + $profitto + '   PF ' + $pfRep + '   righe GBA ' + $gbaOrd.Count + '   barre ' + $bgTxt + '   AVVIO ' + $avvioOk + '   AUTOTEST ' + $autoOk + '   finestra ' + $finest) -ForegroundColor $col
  foreach($x in $motivi){ Write-Host ('        - ' + $x) -ForegroundColor Red }
  if($stato -like 'KO*'){ foreach($x in @($evTester.Keys | Select-Object -First 5)){ Write-Host ('        tester: ' + $x) -ForegroundColor DarkYellow } }
}
$durTot = ((Get-Date) - $TLotto).TotalMinutes

# G1 (S0; v5: anche ogni lotto dichiarativo con gemelle): le due gemelle sul magic devono dare lo stesso report
$g1 = ''; $g1Ko = $false; $g1Righe = @()
if($Lotto -eq 'S0'){
  $a1 = $riassunti['REPL|T1|775800']; $b1 = $riassunti['REPL|T1|775850']
  if($null -eq $a1 -or $null -eq $b1){ $g1 = 'G1 NON VERIFICABILE: manca il report di una delle due gemelle (REPL su T1, magic 775800 e 775850).' }
  elseif($a1.Trades -eq $b1.Trades -and $a1.Profitto -eq $b1.Profitto -and $a1.PF -eq $b1.PF){ $g1 = 'G1 VERDE: le due gemelle hanno operazioni ' + $a1.Trades + ', profitto ' + $a1.Profitto + ', PF ' + $a1.PF + ' IDENTICI.' }
  else { $g1 = 'G1 ROSSO: gemella 775800 operazioni ' + $a1.Trades + ' profitto ' + $a1.Profitto + ' PF ' + $a1.PF + ' contro gemella 775850 operazioni ' + $b1.Trades + ' profitto ' + $b1.Profitto + ' PF ' + $b1.PF + ': il Modello 1 non e riproducibile, NESSUN conteggio di questo lotto si usa.' }
  $colg = 'Green'; if($g1 -notlike 'G1 VERDE*'){ $colg = 'Red' }
  Write-Host ('   ' + $g1) -ForegroundColor $colg
  $g1Ko = ($g1 -notlike 'G1 VERDE*')
  $g1Righe = @($g1)
} elseif(-not $STORICA){
  # (v5) file dichiarativo: ogni gemella 775850 si confronta con la sua 775800 se e' nello stesso lotto; se non c'e' (ancora in R1A) lo fa il lettore sui due zip
  foreach($ru2 in @($runs | Where-Object { $_.Magic -eq '775850' })){
    $kb = $ru2.Cella['nome'] + '|' + $ru2.Tranche['nome']
    $nomeG = 'G1 (cella ' + $ru2.Cella['nome'] + ', tranche ' + $ru2.Tranche['nome'] + ', Modello ' + $modello + ')'
    $haA = (@($runs | Where-Object { $_.Magic -eq '775800' -and $_.Cella['nome'] -eq $ru2.Cella['nome'] -and $_.Tranche['nome'] -eq $ru2.Tranche['nome'] })).Count -gt 0
    $a1 = $riassunti[$kb + '|775800']; $b1 = $riassunti[$kb + '|775850']
    if(-not $haA){ $rg = $nomeG + ': la gemella 775800 NON e in questo lotto (di solito e in R1A): il confronto lo fa il lettore leggi_gba_r0.py caricando i due zip.'; $colg = 'Yellow' }
    elseif($null -eq $a1 -or $null -eq $b1){ $rg = $nomeG + ' NON VERIFICABILE: manca il report di una delle due gemelle.'; $g1Ko = $true; $colg = 'Red' }
    elseif($a1.Trades -eq $b1.Trades -and $a1.Profitto -eq $b1.Profitto -and $a1.PF -eq $b1.PF){ $rg = $nomeG + ' VERDE: operazioni ' + $a1.Trades + ', profitto ' + $a1.Profitto + ', PF ' + $a1.PF + ' IDENTICI sulle due gemelle.'; $colg = 'Green' }
    else { $rg = $nomeG + ' ROSSO: gemella 775800 operazioni ' + $a1.Trades + ' profitto ' + $a1.Profitto + ' PF ' + $a1.PF + ' contro 775850 operazioni ' + $b1.Trades + ' profitto ' + $b1.Profitto + ' PF ' + $b1.PF + ': la passata non e riproducibile, NESSUN numero di questo lotto si usa.'; $g1Ko = $true; $colg = 'Red' }
    $g1Righe = $g1Righe + @($rg)
    Write-Host ('   ' + $rg) -ForegroundColor $colg
  }
}

# ---------------------------------------------------------------------
#  3. RACCOLTA
# ---------------------------------------------------------------------
Titolo '3 - RACCOLTA'
$mediaS = 0.0; if($nDur -gt 0){ $mediaS = $sommaDur / $nDur }
$testa = @(
  ('GBA R0 -- lotto ' + $Lotto + ': ' + $EXPERT + ' v' + $VERSIONE_ATTESA + ' su ' + $simTf + ', Modello ' + $modello + ', lotto fisso 1,00, deposito 1000000 EUR, UNA variabile (' + $ASSE + ')'),
  ('data: ' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss') + '   pc: ' + $env:COMPUTERNAME + '   pin: ' + $Pin),
  ($EXPERT + '.mq5 SHA256 ' + $ShaEA + '   compilazione: ' + $compErr + ' errori, ' + $compWarn + ' avvisi (-1 = non letto)'),
  ('passate del lotto ' + $runs.Count + ': OK ' + $nOk + ', KO ' + $nKo + ', NON LANCIATE ' + $nNon + '   durata totale ' + [int]$durTot + ' minuti   media per passata OK ' + [int]$mediaS + ' secondi'),
  $(if($Lotto -eq 'R2REG'){ ('LOTTO R2REG: ' + $runs.Count + ' passate a ticks reali (nessun piano da 17 passate: la stima e nel file prova ' + $PROVA + ')') } elseif(-not $STORICA){ ('LOTTO ' + $Lotto + ' (file prova dichiarativo ' + $PROVA + ', asse ' + $ASSE + '): ' + $runs.Count + ' passate a Modello ' + $modello + ' (nessun piano da 17 passate: la stima e nel file prova)') } else { ('STIMA DEL PIANO INTERO (17 passate: S0 5 + R1A 3 + R1B 9) con la media di questo lotto: ' + [int](17 * $mediaS / 60.0) + ' minuti (valida solo se il Modello e lo stesso: S0 e OHLC, R1 e a ticks reali)') }),
  'Guardian nel tester: FAIL-OPEN (irrilevante: nel tester non c e nessun altro EA).'
)
if($g1Righe.Count -gt 0){ $testa = $testa + $g1Righe }
$testa = $testa + @('')
(($testa + $manifest + @('',
  'COME SI LEGGE: python3 backtest_pipeline/leggi_gba_r0.py <questo zip o la cartella>. Prima lo STATO di ogni passata (OK / KO / NON_LANCIATA) e i motivi; poi i cancelli G0/G1/G2,',
  'n, frequenza, COSTO (stop/spread) PRIMA del PF, PF e DD, lato, concentrazione, ora (6 fasce), contro le attese e le soglie SCRITTE nel file prova prima dei numeri.',
  'Questo script RACCOGLIE e dice se ogni passata e affidabile: NON giudica, NON promuove, NON sceglie nessuna cella.')) -join "`r`n") | Set-Content -LiteralPath (Join-Path $Cart 'RIEPILOGO_R0.txt') -Encoding ASCII
(($manifest) -join "`r`n") | Set-Content -LiteralPath (Join-Path $Cart 'MANIFEST_R0.csv') -Encoding ASCII
Compress-Archive -Path (Join-Path $Cart '*') -DestinationPath $zip -Force
Write-Host ''
Write-Host ('passate OK ' + $nOk + ', KO ' + $nKo + ', NON LANCIATE ' + $nNon + ' su ' + $runs.Count + '   durata ' + [int]$durTot + ' minuti   media per passata OK ' + [int]$mediaS + ' s') -ForegroundColor Cyan
Write-Host ('ZIP PRONTO DA MANDARE: ' + $zip) -ForegroundColor Green
Write-Host 'FILE ATTESI NELLO ZIP: RIEPILOGO_R0.txt + MANIFEST_R0.csv + il file prova + compile_gba.log + report\GBA_R0_<passata>.htm + log\GBA_<passata>.txt + ini\gba_<passata>.ini (un report, un log e un ini per passata)' -ForegroundColor Gray
try{ $Mutex.ReleaseMutex() }catch{ }
$tutteOk = ($nKo -eq 0 -and $nNon -eq 0 -and $nOk -eq $runs.Count)
if($g1Ko){ $tutteOk = $false }
if($tutteOk){ Write-Host 'ESITO GBA_R0: TUTTE LE PASSATE OK (rc 0)' -ForegroundColor Green; exit 0 }
Write-Host 'ESITO GBA_R0: ALMENO UNA PASSATA KO O NON LANCIATA, O G1 NON VERDE (rc 3): lo zip esce lo stesso, il MANIFEST dice quali e perche.' -ForegroundColor Red
exit 3
