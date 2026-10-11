# =====================================================================
#  MARCATORE_LOG_AGENTI_P003_v1
#  LOG_AGENTI_P003.ps1 -- SOLA LETTURA dei log GREZZI degli agenti del Strategy Tester
#
#  PERCHE' ESISTE (report/NATCLA_P003_DIAGNOSI_2026-10-11.md, par. 3.3 e 4(a)):
#   la diagnosi del caso P_003 di EA_NatCla dice che "la cancellazione dei pendenti fallisce a mercato chiuso" e'
#   INFERITO, non FATTO: il retcode di OrderDelete non e' scritto in nessun file letto finora (l'EA non lo scrive,
#   e il driver delle passate scarta tutte le righe senza il prefisso [NatCla]). La riga CTrade con il motivo
#   (formato visto in repo: "CTrade::OrderSend: ... [invalid stops]") potrebbe stare nei log GREZZI dell'agente
#   del tester, nel profilo utente di QUESTO PC. Questo script li cerca. Se non ci sono, dice NON TROVATO.
#
#  COSA FA, e una cosa sola:
#   1. elenca TUTTI i file .log sotto una cartella Tester di %APPDATA%\MetaQuotes (data e dimensione) e li
#      dichiara, anche quelli che non legge;
#   2. dei file chiamati <AAAAMMGG>.log per i giorni di -Giorni (default 20261011) legge ogni riga
#      (sola lettura, condivisione ReadWrite: un agente ancora aperto non viene disturbato);
#   3. cerca le righe che contengono il NUMERO di uno dei 33 ticket della tabella qui sotto (9 episodi di
#      adozione: P_003 e le passate M30_002 / M30_003) con una parola chiave (cancel, delete, remove, OrderSend,
#      failed, market closed, 10018, retcode, reject, invalid, error, expired), piu' 3 righe di contesto prima e
#      dopo, e conta i testi d'errore;
#   4. scrive tutto in Desktop\LOG_AGENTI_P003\ e crea Desktop\LOG_AGENTI_P003.zip.
#  NON giudica la causa: dice QUALI RIGHE ci sono. Se la riga col motivo c'e', la leggera' chi legge il file.
#
#  COME SI EVITANO LE FALSE TROVATE (classe nuova, collaudata con un log finto):
#   - i numeri di ticket si ripetono fra PASSATE diverse nello stesso file del giorno: ogni riga si attribuisce alla
#     passata dalla riga [NatCla] AVVIO che la precede (simbolo, TF, magic, modo di stop); una riga con lo stesso
#     numero in un'ALTRA passata si conta a parte e NON vale come trovata;
#   - il numero si cerca come numero INTERO, non dentro un prezzo ("2466.50") ne' dentro un numero piu' lungo;
#   - la riga vale solo se l'ora SIMULATA cade nella finestra di vita del ticket (piazzato -1 min .. fine +2 min,
#     dalla tabella Ordini del report .htm); una riga con ora simulata assente o fuori finestra si conta a parte.
#
#  NON TOCCA: nessun processo (non apre MT5, MetaEditor, tester), nessun file di log (mai cancellato, spostato o
#  modificato), nessun terminale, nessun conto, CODA.txt, runner, preset, sedie. Scrive SOLO il Desktop
#  (cartella LOG_AGENTI_P003 e zip). Una cartella o uno zip gia' presenti con quel nome si RINOMINANO con la data,
#  mai sovrascritti. Gira SOLO sul PC di backtest DESKTOP-H4D7CAJ: mai sul VPS VMI3047753, mai sul conto reale.
#
#  NIENTE EMOJI QUI DENTRO (regola del 17/08): Windows PowerShell 5.1 legge i .ps1 come ANSI. Sorgente ASCII puro.
# =====================================================================
[CmdletBinding()]
param(
  [Parameter(Mandatory=$true)][string]$Pin,
  [string]$Giorni = '20261011',
  [int]$Contesto = 3
)

$ErrorActionPreference = 'Stop'
$IC = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentCulture   = $IC
[Threading.Thread]::CurrentThread.CurrentUICulture = $IC

if($Pin -notmatch '^[0-9a-fA-F]{40}$'){ throw '-Pin obbligatorio e di 40 caratteri esadecimali.' }
$Pin = $Pin.ToLower()
if($Giorni -notmatch '^[0-9]{8}(,[0-9]{8})*$'){ throw ('-Giorni deve essere AAAAMMGG oppure AAAAMMGG,AAAAMMGG (e ' + $Giorni + ').') }
if($Contesto -lt 0 -or $Contesto -gt 10){ throw '-Contesto deve stare fra 0 e 10 righe.' }
if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ throw ('QUESTO SCRIPT GIRA SOLO SUL PC DI BACKTEST DESKTOP-H4D7CAJ. Qui la macchina si chiama: ' + $env:COMPUTERNAME + '. Sul VPS VMI3047753 non si lancia mai.') }
$ListaGiorni = @($Giorni -split ',')
$MAXHIT = 4000
$MAXFILE = 600

function NuovoCnt(){ return @{ righe = 0; ctrade = 0; cancel = 0; mc = 0; f10018 = 0; failed = 0; ticket = 0 } }
function Dico($t, $col){ Write-Host $t -ForegroundColor $col }
function Asc($s){
  if($null -eq $s){ return '' }
  $x = ([string]$s).Replace("`t", ' | ').Replace("`r", ' ').Replace("`n", ' ')
  return [regex]::Replace($x, '[^\x20-\x7E]', '?')
}
function Tronca($s, $n){ $s = Asc $s; if($s.Length -gt $n){ return $s.Substring(0, $n) + ' [...]' }; return $s }

# ---------------------------------------------------------------------
#  0. LA TABELLA DEI TICKET: dalle tabelle Ordini dei report .htm di P (pilota H1) e M (lotto M30) del 11/10/2026,
#     ricavata dagli episodi "guardia anti-duplicato" -> "ADOTTATO" dei log delle passate: gli ordini vivi alla
#     riga di guardia e finiti entro 8 ore dall'adozione. Tutti i valori sono ORA DEL TESTER (= ora server).
# ---------------------------------------------------------------------
$TabellaCsv = @'
caso;passata;simbolo;tf;magic;stop;ticket;piazzato;fine;stato;commento
P_003_20250302;P_003;EURUSD;H1;778601;OLTRE_LINEA_ESTERNA;4603;2025.02.28 21:00:00;2025.03.02 23:05:00;filled;NATCLA_A_ST25_O1
P_003_20250302;P_003;EURUSD;H1;778601;OLTRE_LINEA_ESTERNA;4604;2025.02.28 21:00:00;2025.03.03 00:08:00;filled;NATCLA_A_ST25_O2
P_003_20250302;P_003;EURUSD;H1;778601;OLTRE_LINEA_ESTERNA;4605;2025.02.28 21:00:00;2025.03.03 00:08:59;filled;NATCLA_A_ST25_O3
M30_002_20240915;M30_002;XAUUSD;M30;778603;GEOMETRIA_ATTUALE;1966;2024.09.13 21:30:00;2024.09.15 23:10:00;filled;NATCLA_A_ST25_O1
M30_002_20240915;M30_002;XAUUSD;M30;778603;GEOMETRIA_ATTUALE;1967;2024.09.13 21:30:00;2024.09.16 03:12:31;canceled;NATCLA_A_ST25_O2
M30_002_20240915;M30_002;XAUUSD;M30;778603;GEOMETRIA_ATTUALE;1968;2024.09.13 21:30:00;2024.09.16 03:12:31;canceled;NATCLA_A_ST25_O3
M30_002_20240915;M30_002;XAUUSD;M30;778603;GEOMETRIA_ATTUALE;1969;2024.09.13 21:30:00;2024.09.15 23:10:01;canceled;NATCLA_A_ST30_O1
M30_002_20240915;M30_002;XAUUSD;M30;778603;GEOMETRIA_ATTUALE;1970;2024.09.13 21:30:00;2024.09.15 23:10:01;canceled;NATCLA_A_ST30_O2
M30_002_20240915;M30_002;XAUUSD;M30;778603;GEOMETRIA_ATTUALE;1971;2024.09.13 21:30:00;2024.09.15 23:10:01;canceled;NATCLA_A_ST30_O3
M30_002_20241013;M30_002;XAUUSD;M30;778603;GEOMETRIA_ATTUALE;2466;2024.10.11 21:30:00;2024.10.13 23:10:00;filled;NATCLA_A_ST25_O1
M30_002_20241013;M30_002;XAUUSD;M30;778603;GEOMETRIA_ATTUALE;2467;2024.10.11 21:30:00;2024.10.13 23:10:38;filled;NATCLA_A_ST25_O2
M30_002_20241013;M30_002;XAUUSD;M30;778603;GEOMETRIA_ATTUALE;2468;2024.10.11 21:30:00;2024.10.14 01:00:00;canceled;NATCLA_A_ST25_O3
M30_002_20241013;M30_002;XAUUSD;M30;778603;GEOMETRIA_ATTUALE;2469;2024.10.11 21:30:00;2024.10.13 23:10:00;filled;NATCLA_A_ST30_O1
M30_002_20241013;M30_002;XAUUSD;M30;778603;GEOMETRIA_ATTUALE;2470;2024.10.11 21:30:00;2024.10.13 23:15:34;filled;NATCLA_A_ST30_O2
M30_002_20241013;M30_002;XAUUSD;M30;778603;GEOMETRIA_ATTUALE;2471;2024.10.11 21:30:00;2024.10.14 01:30:00;canceled;NATCLA_A_ST30_O3
M30_002_20250525;M30_002;XAUUSD;M30;778603;GEOMETRIA_ATTUALE;9736;2025.05.23 20:30:00;2025.05.25 23:10:01;filled;NATCLA_A_ST30_O1
M30_002_20250525;M30_002;XAUUSD;M30;778603;GEOMETRIA_ATTUALE;9737;2025.05.23 20:30:00;2025.05.25 23:23:32;filled;NATCLA_A_ST30_O2
M30_002_20250525;M30_002;XAUUSD;M30;778603;GEOMETRIA_ATTUALE;9738;2025.05.23 20:30:00;2025.05.26 01:00:00;canceled;NATCLA_A_ST30_O3
M30_003_20240915;M30_003;XAUUSD;M30;778603;OLTRE_PIU_ESTERNA;1696;2024.09.13 21:30:00;2024.09.15 23:10:00;filled;NATCLA_A_ST25_O1
M30_003_20240915;M30_003;XAUUSD;M30;778603;OLTRE_PIU_ESTERNA;1697;2024.09.13 21:30:00;2024.09.16 03:12:31;canceled;NATCLA_A_ST25_O2
M30_003_20240915;M30_003;XAUUSD;M30;778603;OLTRE_PIU_ESTERNA;1698;2024.09.13 21:30:00;2024.09.16 03:12:31;canceled;NATCLA_A_ST25_O3
M30_003_20240915;M30_003;XAUUSD;M30;778603;OLTRE_PIU_ESTERNA;1699;2024.09.13 21:30:00;2024.09.15 23:10:01;canceled;NATCLA_A_ST30_O1
M30_003_20240915;M30_003;XAUUSD;M30;778603;OLTRE_PIU_ESTERNA;1700;2024.09.13 21:30:00;2024.09.15 23:10:01;canceled;NATCLA_A_ST30_O2
M30_003_20240915;M30_003;XAUUSD;M30;778603;OLTRE_PIU_ESTERNA;1701;2024.09.13 21:30:00;2024.09.15 23:10:01;canceled;NATCLA_A_ST30_O3
M30_003_20241013;M30_003;XAUUSD;M30;778603;OLTRE_PIU_ESTERNA;2190;2024.10.11 21:30:00;2024.10.13 23:10:00;filled;NATCLA_A_ST25_O1
M30_003_20241013;M30_003;XAUUSD;M30;778603;OLTRE_PIU_ESTERNA;2191;2024.10.11 21:30:00;2024.10.13 23:10:38;filled;NATCLA_A_ST25_O2
M30_003_20241013;M30_003;XAUUSD;M30;778603;OLTRE_PIU_ESTERNA;2192;2024.10.11 21:30:00;2024.10.14 01:00:00;canceled;NATCLA_A_ST25_O3
M30_003_20241013;M30_003;XAUUSD;M30;778603;OLTRE_PIU_ESTERNA;2193;2024.10.11 21:30:00;2024.10.13 23:10:00;filled;NATCLA_A_ST30_O1
M30_003_20241013;M30_003;XAUUSD;M30;778603;OLTRE_PIU_ESTERNA;2194;2024.10.11 21:30:00;2024.10.13 23:15:34;filled;NATCLA_A_ST30_O2
M30_003_20241013;M30_003;XAUUSD;M30;778603;OLTRE_PIU_ESTERNA;2195;2024.10.11 21:30:00;2024.10.14 01:30:00;canceled;NATCLA_A_ST30_O3
M30_003_20250525;M30_003;XAUUSD;M30;778603;OLTRE_PIU_ESTERNA;8667;2025.05.23 20:30:00;2025.05.25 23:10:01;filled;NATCLA_A_ST30_O1
M30_003_20250525;M30_003;XAUUSD;M30;778603;OLTRE_PIU_ESTERNA;8668;2025.05.23 20:30:00;2025.05.25 23:23:32;filled;NATCLA_A_ST30_O2
M30_003_20250525;M30_003;XAUUSD;M30;778603;OLTRE_PIU_ESTERNA;8669;2025.05.23 20:30:00;2025.05.26 01:00:00;canceled;NATCLA_A_ST30_O3
'@
$FMT_SIM = 'yyyy.MM.dd HH:mm:ss'
$Tick = @{}      # numero ticket (stringa) -> riga della tabella
$TickOrd = New-Object System.Collections.Generic.List[string]
foreach($rg in @(($TabellaCsv -split "`r?`n") | Where-Object { $_.Trim() -ne '' } | Select-Object -Skip 1)){
  $c = $rg.Split(';')
  if($c.Count -ne 11){ throw ('Tabella ticket: riga con ' + $c.Count + ' campi invece di 11: ' + $rg) }
  $o = New-Object PSObject -Property @{
    caso = $c[0]; passata = $c[1]; simbolo = $c[2]; tf = $c[3]; magic = $c[4]; stop = $c[5]; ticket = $c[6]
    piazzato = [datetime]::ParseExact($c[7], $FMT_SIM, $IC); fine = [datetime]::ParseExact($c[8], $FMT_SIM, $IC)
    stato = $c[9]; commento = $c[10]
    n_coer = 0; n_coer_kw = 0; n_fail = 0; n_cancel = 0; n_fuori = 0; n_altro_seg = 0; n_senza_ora = 0; n_seg_ignoto = 0
  }
  if($Tick.ContainsKey($o.ticket)){ throw ('Tabella ticket: ticket doppio ' + $o.ticket) }
  $Tick[$o.ticket] = $o
  [void]$TickOrd.Add($o.ticket)
}
if($TickOrd.Count -ne 33){ throw ('Tabella ticket: attesi 33 ticket, trovati ' + $TickOrd.Count) }

# ---------------------------------------------------------------------
#  1. LE REGEX (compilate una volta)
# ---------------------------------------------------------------------
$Opz = [Text.RegularExpressions.RegexOptions]::Compiled
$OpzI = $Opz -bor [Text.RegularExpressions.RegexOptions]::IgnoreCase
# il numero INTERO: non preceduto da cifra, ne' da "cifra." / "cifra,"; non seguito da cifra, ne' da ".cifra" / ",cifra" (prezzi, numeri piu' lunghi)
$reTicket = New-Object Text.RegularExpressions.Regex(('(?<![0-9])(?<![0-9][.,])(?:' + ($TickOrd -join '|') + ')(?![0-9])(?![.,][0-9])'), $Opz)
$reKw     = New-Object Text.RegularExpressions.Regex('cancel|delete|remove|OrderSend|failed|market closed|10018|retcode|reject|invalid|error|expired', $OpzI)
$reFail   = New-Object Text.RegularExpressions.Regex('failed|market closed|10018|reject|invalid|error|retcode\s*:?\s*(?!10008|10009)[0-9]+', $OpzI)
$reCancel = New-Object Text.RegularExpressions.Regex('cancel|delete|remove', $OpzI)
$reSim    = New-Object Text.RegularExpressions.Regex('[0-9]{4}\.[0-9]{2}\.[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}', $Opz)
$reAvvio  = New-Object Text.RegularExpressions.Regex('\[NatCla\] AVVIO v[0-9.]+ ', $Opz)
$reAvSim  = New-Object Text.RegularExpressions.Regex('\| (?<sym>[A-Za-z0-9_.#-]+) PERIOD_(?<tf>[A-Za-z0-9]+) \|', $Opz)
$reAvMg   = New-Object Text.RegularExpressions.Regex('\| magic (?<mg>[0-9]+) \|', $Opz)
$reAvStop = New-Object Text.RegularExpressions.Regex('\| stop (?<st>[A-Za-z0-9_]+)', $Opz)
$reBrac   = New-Object Text.RegularExpressions.Regex('\[(?<t>[^\]]{1,80})\]\s*$', $Opz)
$reRet    = New-Object Text.RegularExpressions.Regex('retcode\s*:?\s*(?<n>[0-9]+)', $OpzI)
$reCTrade = New-Object Text.RegularExpressions.Regex('CTrade::', $Opz)
$reMC     = New-Object Text.RegularExpressions.Regex('market closed', $OpzI)

function ChiaveErrore($msg){
  $m = $reBrac.Match($msg)
  if($m.Success){ return ('[' + $m.Groups['t'].Value.ToLowerInvariant() + ']') }
  $m = $reRet.Match($msg)
  if($m.Success){ return ('retcode ' + $m.Groups['n'].Value) }
  if($reMC.IsMatch($msg)){ return 'market closed (senza altro)' }
  if($msg.IndexOf('10018') -ge 0){ return '10018 (senza altro)' }
  if($msg.ToLowerInvariant().IndexOf('failed') -ge 0){ return 'failed (senza motivo fra parentesi quadre)' }
  return 'altro'
}

# ---------------------------------------------------------------------
#  2. I FILE: elenco di TUTTI i .log sotto una cartella Tester del profilo, poi lettura dei soli giorni richiesti
# ---------------------------------------------------------------------
$Ap = $env:APPDATA
if([string]::IsNullOrWhiteSpace($Ap)){ throw 'APPDATA vuoto: non so dove cercare nel profilo utente.' }
$MQ = Join-Path $Ap 'MetaQuotes'
Dico ('pc  : ' + $env:COMPUTERNAME) 'Green'
Dico ('pin : ' + $Pin) 'Green'
Dico ('cerco i .log sotto una cartella Tester di: ' + $MQ) 'Cyan'
$Trovati = New-Object System.Collections.Generic.List[object]
if(Test-Path -LiteralPath $MQ){
  foreach($lf in @(Get-ChildItem -LiteralPath $MQ -Recurse -Filter '*.log' -File -ErrorAction SilentlyContinue)){
    $parti = @($lf.FullName -split '[\\/]')
    if($parti -contains 'Tester'){ [void]$Trovati.Add($lf) }
  }
}
$Trovati = @($Trovati | Sort-Object FullName)
$DaLeggere = @($Trovati | Where-Object { $ListaGiorni -contains $_.BaseName })
Dico ('file .log trovati sotto Tester: ' + $Trovati.Count + '   di cui dei giorni richiesti (' + ($ListaGiorni -join ',') + '): ' + $DaLeggere.Count) 'Cyan'
foreach($f in $DaLeggere){ Dico ('   DA LEGGERE  ' + $f.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss', $IC) + '  ' + $f.Length.ToString($IC) + ' byte  ' + $f.FullName) 'Gray' }
if($DaLeggere.Count -eq 0){ Dico ('NESSUN file ' + (($ListaGiorni | ForEach-Object { $_ + '.log' }) -join ' / ') + ' sotto una cartella Tester di ' + $MQ + ': i risultati diranno NON VERIFICABILE, non NON TROVATO.') 'Red' }

# ---------------------------------------------------------------------
#  3. LA LETTURA RIGA PER RIGA
# ---------------------------------------------------------------------
function ApriLettore($path){
  $fs = [IO.File]::Open($path, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
  $b = New-Object byte[] 4
  $n = $fs.Read($b, 0, 4)
  $enc = [Text.Encoding]::UTF8
  if($n -ge 2 -and $b[0] -eq 0xFF -and $b[1] -eq 0xFE){ $enc = [Text.Encoding]::Unicode }
  elseif($n -ge 2 -and $b[0] -eq 0xFE -and $b[1] -eq 0xFF){ $enc = [Text.Encoding]::BigEndianUnicode }
  elseif($n -ge 3 -and $b[0] -eq 0xEF -and $b[1] -eq 0xBB -and $b[2] -eq 0xBF){ $enc = [Text.Encoding]::UTF8 }
  else {
    $zeri = 0
    for($i = 1; $i -lt $n; $i += 2){ if($b[$i] -eq 0){ $zeri++ } }
    if($n -ge 2 -and $zeri -ge [math]::Ceiling($n / 4)){ $enc = [Text.Encoding]::Unicode }
  }
  [void]$fs.Seek(0, [IO.SeekOrigin]::Begin)
  return (New-Object IO.StreamReader($fs, $enc, $true))
}

$Hits = New-Object System.Collections.Generic.List[object]     # ogni riga con un numero di ticket
$Blocchi = New-Object System.Collections.Generic.List[object]  # righe coerenti con parola chiave + contesto
$HitTroncati = 0
$ErrTicket = @{}      # testo d'errore -> conteggio, righe coerenti in finestra con parola di fallimento
$ErrGlobale = @{}     # testo d'errore -> conteggio, TUTTE le righe CTrade/failed del giorno (non legate ai ticket)
$Sonda = New-Object System.Collections.Generic.List[object]  # per file e passata: contatori globali
$FileEsito = New-Object System.Collections.Generic.List[object]

foreach($f in $DaLeggere){
  $righe = 0; $lett = $true; $errLett = ''
  $seg = 'SEGMENTO IGNOTO (nessun AVVIO prima in questo file)'; $segSim = ''; $segTf = ''; $segMg = ''; $segSt = ''
  $segIdx = 0
  $ring = New-Object System.Collections.Generic.Queue[string]
  $attivi = New-Object System.Collections.Generic.List[object]
  $cnt = NuovoCnt
  $segEtich = $seg
  $sr = $null
  try{
    $sr = ApriLettore $f.FullName
    $nr = 0
    while($true){
      $ln = $sr.ReadLine()
      if($null -eq $ln){ break }
      $nr++; $righe++
      # il contesto "dopo" delle righe gia' registrate
      if($attivi.Count -gt 0){
        for($ia = $attivi.Count - 1; $ia -ge 0; $ia--){
          $at = $attivi[$ia]
          [void]$at['dopo'].Add((Tronca $ln 400))
          if($at['dopo'].Count -ge $Contesto){ $attivi.RemoveAt($ia) }
        }
      }
      # una riga AVVIO apre una nuova passata: si chiude il contatore della precedente PRIMA di contare questa riga
      if($ln.IndexOf('[NatCla] AVVIO') -ge 0 -and $reAvvio.IsMatch($ln)){
        if($cnt['righe'] -gt 0){ [void]$Sonda.Add(@{ file = $f.FullName; segmento = $segEtich; c = $cnt }) }
        $cnt = NuovoCnt
        $segIdx++
        $ms = $reAvSim.Match($ln); $mm = $reAvMg.Match($ln); $mt = $reAvStop.Match($ln)
        $segSim = ''; $segTf = ''; $segMg = ''; $segSt = ''
        if($ms.Success){ $segSim = $ms.Groups['sym'].Value; $segTf = $ms.Groups['tf'].Value }
        if($mm.Success){ $segMg = $mm.Groups['mg'].Value }
        if($mt.Success){ $segSt = $mt.Groups['st'].Value }
        $segEtich = ('#' + $segIdx + ' ' + $segSim + ' ' + $segTf + ' magic ' + $segMg + ' stop ' + $segSt + ' (riga ' + $nr + ')')
      }
      $cnt['righe']++
      $haCT = $false
      if($ln.IndexOf('CTrade::') -ge 0){ $haCT = $true; $cnt['ctrade']++ }
      if($reCancel.IsMatch($ln)){ $cnt['cancel']++ }
      if($reMC.IsMatch($ln)){ $cnt['mc']++ }
      if($ln.IndexOf('10018') -ge 0){ $cnt['f10018']++ }
      $haFailed = ($ln.IndexOf('failed') -ge 0 -or $ln.IndexOf('Failed') -ge 0)
      if($haFailed){ $cnt['failed']++ }
      if($haCT -or $haFailed){
        $kg = ChiaveErrore $ln
        if($ErrGlobale.ContainsKey($kg)){ $ErrGlobale[$kg] = $ErrGlobale[$kg] + 1 } else { $ErrGlobale[$kg] = 1 }
      }
      # i ticket
      $mt2 = $reTicket.Matches($ln)
      if($mt2.Count -gt 0){
        $cnt['ticket']++
        $viste = @{}
        foreach($mx in $mt2){ $viste[$mx.Value] = $true }
        $sim = $null
        $ms2 = $reSim.Match($ln)
        if($ms2.Success){ $sim = [datetime]::ParseExact($ms2.Value, $FMT_SIM, $IC) }
        $kw = $reKw.IsMatch($ln)
        $fail = $reFail.IsMatch($ln)
        $canc = $reCancel.IsMatch($ln)
        foreach($tk in @($viste.Keys)){
          $row = $Tick[$tk]
          $classe = ''
          if($null -eq $sim){ $classe = 'SENZA_ORA'; $row.n_senza_ora++ }
          elseif($sim -lt $row.piazzato.AddMinutes(-1) -or $sim -gt $row.fine.AddMinutes(2)){ $classe = 'FUORI_FINESTRA'; $row.n_fuori++ }
          elseif($segSim -eq ''){ $classe = 'SEGMENTO_IGNOTO'; $row.n_seg_ignoto++ }
          elseif($segSim -ne $row.simbolo -or $segTf -ne $row.tf -or $segMg -ne $row.magic -or $segSt -ne $row.stop){ $classe = 'ALTRO_SEGMENTO'; $row.n_altro_seg++ }
          else {
            $classe = 'COERENTE'; $row.n_coer++
            if($kw){ $row.n_coer_kw++ }
            if($fail){ $row.n_fail++ }
            if($canc){ $row.n_cancel++ }
          }
          if($Hits.Count -lt $MAXHIT){
            [void]$Hits.Add(@{ file = $f.FullName; riga = $nr; segmento = $segEtich; ticket = $tk; caso = $row.caso; classe = $classe; kw = $kw; fail = $fail
              sim = $(if($null -eq $sim){ '' } else { $sim.ToString($FMT_SIM, $IC) }); testo = (Tronca $ln 600) })
          } else { $HitTroncati++ }
          if($classe -eq 'COERENTE' -and $kw -and $Blocchi.Count -lt $MAXHIT){
            $prima = @($ring.ToArray() | Select-Object -Last $Contesto)
            $bl = @{ file = $f.FullName; riga = $nr; segmento = $segEtich; ticket = $tk; caso = $row.caso; fail = $fail; testo = (Tronca $ln 600); prima = $prima; dopo = (New-Object System.Collections.Generic.List[string]) }
            [void]$Blocchi.Add($bl)
            if($Contesto -gt 0){ [void]$attivi.Add($bl) }
            if($fail){
              $kk = ChiaveErrore $ln
              if($ErrTicket.ContainsKey($kk)){ $ErrTicket[$kk] = $ErrTicket[$kk] + 1 } else { $ErrTicket[$kk] = 1 }
            }
          }
        }
      }
      # l'anello delle ultime righe (contesto "prima")
      [void]$ring.Enqueue((Tronca $ln 400))
      while($ring.Count -gt $Contesto){ [void]$ring.Dequeue() }
    }
    if($cnt['righe'] -gt 0){ [void]$Sonda.Add(@{ file = $f.FullName; segmento = $segEtich; c = $cnt }) }
  } catch {
    $lett = $false; $errLett = $_.Exception.Message
    Dico ('   ILLEGGIBILE ' + $f.FullName + ': ' + $errLett) 'Red'
  } finally {
    if($null -ne $sr){ $sr.Close() }
  }
  [void]$FileEsito.Add(@{ f = $f; righe = $righe; segmenti = $segIdx; letto = $lett; errore = $errLett })
  Dico ('   letto ' + $f.FullName + ': ' + $righe + ' righe, ' + $segIdx + ' passate (AVVIO)' + $(if($lett){ '' } else { '  *** NON LETTO ***' })) 'Gray'
}

# ---------------------------------------------------------------------
#  4. I VERDETTI PER TICKET (RACCOGLIE e non giudica la causa)
# ---------------------------------------------------------------------
$nLetti = @($FileEsito | Where-Object { $_['letto'] }).Count
function Verdetto($row){
  if($nLetti -eq 0){ return 'NON VERIFICABILE (nessun file log del giorno letto)' }
  if($row.n_fail -gt 0){ return ('TROVATO: ' + $row.n_fail + ' righe con testo di fallimento') }
  if($row.n_coer_kw -gt 0){ return ('TROVATO SOLO senza fallimento: ' + $row.n_coer_kw + ' righe con parola chiave') }
  if($row.n_coer -gt 0){ return ('TROVATO solo il numero, senza parola chiave: ' + $row.n_coer + ' righe') }
  $scartate = $row.n_fuori + $row.n_altro_seg + $row.n_senza_ora + $row.n_seg_ignoto
  if($scartate -gt 0){ return ('NON TROVATO (ma ' + $scartate + ' righe con quel numero SCARTATE: fuori finestra ' + $row.n_fuori + ', altra passata ' + $row.n_altro_seg + ', senza ora ' + $row.n_senza_ora + ', passata ignota ' + $row.n_seg_ignoto + ': vedi RIGHE_TROVATE.csv)') }
  return 'NON TROVATO'
}
$nFail = 0; $nKwOnly = 0; $nNum = 0; $nNon = 0
foreach($tk in $TickOrd){
  $r = $Tick[$tk]
  if($nLetti -gt 0){
    if($r.n_fail -gt 0){ $nFail++ } elseif($r.n_coer_kw -gt 0){ $nKwOnly++ } elseif($r.n_coer -gt 0){ $nNum++ } else { $nNon++ }
  }
}

# ---------------------------------------------------------------------
#  5. L'USCITA: cartella e zip sul Desktop (rinominati se gia' esistono, mai sovrascritti)
# ---------------------------------------------------------------------
$dsk  = [Environment]::GetFolderPath('Desktop')
if([string]::IsNullOrWhiteSpace($dsk)){ throw 'Desktop non risolto: non scrivo da nessuna parte.' }
$Cart = Join-Path $dsk 'LOG_AGENTI_P003'
$zip  = Join-Path $dsk 'LOG_AGENTI_P003.zip'
$stampa = (Get-Date).ToString('yyyyMMdd_HHmmss', $IC)
if(Test-Path -LiteralPath $Cart){
  $nuovo = $Cart + '_VECCHIA_' + $stampa
  if(Test-Path -LiteralPath $nuovo){ throw ('Esiste gia ' + $nuovo + ': non sovrascrivo nulla, mi fermo.') }
  Move-Item -LiteralPath $Cart -Destination $nuovo
  Dico ('cartella di un giro PRECEDENTE rinominata: ' + $nuovo) 'Yellow'
}
if(Test-Path -LiteralPath $zip){
  $nuovoZ = Join-Path $dsk ('LOG_AGENTI_P003_VECCHIO_' + $stampa + '.zip')
  if(Test-Path -LiteralPath $nuovoZ){ throw ('Esiste gia ' + $nuovoZ + ': non sovrascrivo nulla, mi fermo.') }
  Move-Item -LiteralPath $zip -Destination $nuovoZ
  Dico ('zip di un giro PRECEDENTE rinominato con la data: ' + $nuovoZ) 'Yellow'
}
if(Test-Path -LiteralPath $Cart){ throw 'La cartella LOG_AGENTI_P003 esiste ancora dopo la rinomina: mi fermo.' }
if(Test-Path -LiteralPath $zip){ throw 'Lo zip LOG_AGENTI_P003.zip esiste ancora dopo la rinomina: mi fermo.' }
New-Item -ItemType Directory -Path $Cart | Out-Null

# 5a. FILE_LOG_TROVATI.csv: TUTTI i .log sotto Tester, con data e dimensione, e se sono stati letti
$esitoPerPath = @{}
foreach($e in $FileEsito){ $esitoPerPath[$e['f'].FullName] = $e }
$csvF = New-Object System.Collections.Generic.List[string]
[void]$csvF.Add('percorso;ultima_modifica;byte;giorno_richiesto;letto;righe;passate_AVVIO;errore')
$nTutti = 0
foreach($f in $Trovati){
  $nTutti++
  if($nTutti -gt $MAXFILE -and -not ($ListaGiorni -contains $f.BaseName)){ continue }
  $rich = ($ListaGiorni -contains $f.BaseName)
  $letto = 'no'; $nri = ''; $nse = ''; $er = ''
  if($esitoPerPath.ContainsKey($f.FullName)){ $ee = $esitoPerPath[$f.FullName]; if($ee['letto']){ $letto = 'si' } else { $letto = 'ERRORE' }; $nri = [string]$ee['righe']; $nse = [string]$ee['segmenti']; $er = (Tronca $ee['errore'] 200).Replace(';', ',') }
  [void]$csvF.Add(((Asc $f.FullName).Replace(';', ',') + ';' + $f.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss', $IC) + ';' + $f.Length.ToString($IC) + ';' + $(if($rich){ 'si' } else { 'no' }) + ';' + $letto + ';' + $nri + ';' + $nse + ';' + $er))
}
if($Trovati.Count -gt $MAXFILE){ [void]$csvF.Add('# elenco TRONCATO a ' + $MAXFILE + ' file (restano elencati tutti quelli dei giorni richiesti); file totali sotto Tester: ' + $Trovati.Count) }
($csvF -join "`r`n") | Set-Content -LiteralPath (Join-Path $Cart 'FILE_LOG_TROVATI.csv') -Encoding ASCII

# 5b. TICKET_ATTESI.csv: la tabella usata, con i contatori
$csvT = New-Object System.Collections.Generic.List[string]
[void]$csvT.Add('caso;passata;simbolo;tf;magic;stop;ticket;piazzato;fine;stato;commento;righe_coerenti;con_parola_chiave;con_fallimento;con_cancel;fuori_finestra;altro_segmento;senza_ora;segmento_ignoto;verdetto')
foreach($tk in $TickOrd){
  $r = $Tick[$tk]
  [void]$csvT.Add(($r.caso + ';' + $r.passata + ';' + $r.simbolo + ';' + $r.tf + ';' + $r.magic + ';' + $r.stop + ';' + $r.ticket + ';' + $r.piazzato.ToString($FMT_SIM, $IC) + ';' + $r.fine.ToString($FMT_SIM, $IC) + ';' + $r.stato + ';' + $r.commento + ';' + $r.n_coer + ';' + $r.n_coer_kw + ';' + $r.n_fail + ';' + $r.n_cancel + ';' + $r.n_fuori + ';' + $r.n_altro_seg + ';' + $r.n_senza_ora + ';' + $r.n_seg_ignoto + ';' + (Verdetto $r)))
}
($csvT -join "`r`n") | Set-Content -LiteralPath (Join-Path $Cart 'TICKET_ATTESI.csv') -Encoding ASCII

# 5c. RIGHE_TROVATE.csv: ogni riga con un numero di ticket, con la classe
$csvH = New-Object System.Collections.Generic.List[string]
[void]$csvH.Add('file;riga;segmento;ticket;caso;classe;parola_chiave;fallimento;ora_simulata;testo')
foreach($h in $Hits){
  [void]$csvH.Add(((Asc $h['file']).Replace(';', ',') + ';' + $h['riga'] + ';' + (Asc $h['segmento']).Replace(';', ',') + ';' + $h['ticket'] + ';' + $h['caso'] + ';' + $h['classe'] + ';' + $(if($h['kw']){ 'si' } else { 'no' }) + ';' + $(if($h['fail']){ 'si' } else { 'no' }) + ';' + $h['sim'] + ';' + ([string]$h['testo']).Replace(';', ',')))
}
if($HitTroncati -gt 0){ [void]$csvH.Add('# TRONCATO: oltre ' + $MAXHIT + ' righe, altre ' + $HitTroncati + ' non registrate') }
($csvH -join "`r`n") | Set-Content -LiteralPath (Join-Path $Cart 'RIGHE_TROVATE.csv') -Encoding ASCII

# 5d. RIGHE_CON_CONTESTO.txt: le righe COERENTI con parola chiave, con le righe prima e dopo
$tx = New-Object System.Collections.Generic.List[string]
[void]$tx.Add('RIGHE COERENTI CON PAROLA CHIAVE (ticket intero + ora simulata in finestra + passata giusta), con ' + $Contesto + ' righe di contesto prima e dopo.')
[void]$tx.Add('Le righe sono quelle del file di log GREZZO, con i TAB resi " | " e i caratteri non ASCII resi "?". Blocchi: ' + $Blocchi.Count)
[void]$tx.Add('')
if($Blocchi.Count -eq 0){ [void]$tx.Add('(nessun blocco: NESSUNA riga coerente con parola chiave per nessuno dei 33 ticket)') }
$bn = 0
foreach($b in $Blocchi){
  $bn++
  [void]$tx.Add('=== blocco ' + $bn + '  ticket ' + $b['ticket'] + '  caso ' + $b['caso'] + '  ' + $(if($b['fail']){ 'FALLIMENTO' } else { 'senza testo di fallimento' }))
  [void]$tx.Add('    file ' + (Asc $b['file']) + '  riga ' + $b['riga'] + '  passata ' + (Asc $b['segmento']))
  foreach($p in $b['prima']){ [void]$tx.Add('    - ' + $p) }
  [void]$tx.Add('    > ' + $b['testo'])
  foreach($p in $b['dopo']){ [void]$tx.Add('    + ' + $p) }
}
($tx -join "`r`n") | Set-Content -LiteralPath (Join-Path $Cart 'RIGHE_CON_CONTESTO.txt') -Encoding ASCII

# 5e. RIEPILOGO_LOG_AGENTI_P003.txt
$sha = ''
try{ $sha = (Get-FileHash -LiteralPath $PSCommandPath -Algorithm SHA256).Hash } catch { $sha = '(non calcolabile)' }
$rp = New-Object System.Collections.Generic.List[string]
[void]$rp.Add('LOG_AGENTI_P003 -- ricerca nei log GREZZI degli agenti del Strategy Tester (SOLA LETTURA)')
[void]$rp.Add('pc ' + $env:COMPUTERNAME + '   data ' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss', $IC) + '   pin ' + $Pin + '   script SHA256 ' + $sha)
[void]$rp.Add('scopo: trasformare l INFERITO "la cancellazione fallisce a mercato chiuso" (report/NATCLA_P003_DIAGNOSI_2026-10-11.md par. 4a) in FATTO, o in NON TROVATO')
[void]$rp.Add('giorni cercati: ' + ($ListaGiorni -join ',') + '   file .log sotto Tester nel profilo: ' + $Trovati.Count + '   file dei giorni richiesti: ' + $DaLeggere.Count + '   letti: ' + $nLetti)
[void]$rp.Add('')
[void]$rp.Add('1. FILE DEI GIORNI RICHIESTI (data, byte, righe, passate AVVIO)')
if($DaLeggere.Count -eq 0){ [void]$rp.Add('   NESSUNO. Cercati: ' + (($ListaGiorni | ForEach-Object { $_ + '.log' }) -join ', ') + ' sotto ' + (Asc $MQ) + ' (cartelle con un componente Tester). Il silenzio NON e una smentita: i log possono essere stati ruotati o cancellati, o stare in un altro profilo/terminale.') }
foreach($e in $FileEsito){
  $ff = $e['f']
  [void]$rp.Add('   ' + $ff.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss', $IC) + '  ' + $ff.Length.ToString($IC) + ' byte  ' + $e['righe'] + ' righe  ' + $e['segmenti'] + ' passate  ' + $(if($e['letto']){ 'letto' } else { 'NON LETTO: ' + (Tronca $e['errore'] 200) }) + '  ' + (Asc $ff.FullName))
}
[void]$rp.Add('   (elenco di TUTTI i .log sotto Tester, anche non letti: FILE_LOG_TROVATI.csv)')
[void]$rp.Add('')
[void]$rp.Add('2. SONDA GLOBALE per passata (righe del file, NON legate ai ticket): serve a leggere un NON TROVATO')
[void]$rp.Add('   se CTrade e cancel sono ZERO su tutto il file, il tester NON scrive quelle righe e il NON TROVATO non smentisce niente')
foreach($s in $Sonda){
  $c = $s['c']
  [void]$rp.Add('   passata ' + (Asc $s['segmento']) + ': righe ' + $c['righe'] + ', CTrade:: ' + $c['ctrade'] + ', con cancel/delete/remove ' + $c['cancel'] + ', market closed ' + $c['mc'] + ', 10018 ' + $c['f10018'] + ', failed ' + $c['failed'] + ', con un numero di ticket della tabella ' + $c['ticket'] + '   [file ' + (Asc $s['file']) + ']')
}
if($Sonda.Count -eq 0){ [void]$rp.Add('   (nessuna riga letta)') }
[void]$rp.Add('')
[void]$rp.Add('3. VERDETTO PER TICKET (33 ticket: P_003 4603-4605; M30_002 1966-1971 2466-2471 9736-9738; M30_003 1696-1701 2190-2195 8667-8669)')
[void]$rp.Add('   COERENTI = ticket intero + ora simulata nella finestra di vita (piazzato -1 min .. fine +2 min) + passata giusta (simbolo, TF, magic, stop dalla riga AVVIO)')
[void]$rp.Add('   ticket  caso                stato      coer  kw  fall  canc  fuori  altro_seg  senza_ora  verdetto')
foreach($tk in $TickOrd){
  $r = $Tick[$tk]
  [void]$rp.Add('   ' + $r.ticket.PadRight(7) + ' ' + $r.caso.PadRight(19) + ' ' + $r.stato.PadRight(9) + ' ' + ([string]$r.n_coer).PadLeft(4) + ' ' + ([string]$r.n_coer_kw).PadLeft(3) + ' ' + ([string]$r.n_fail).PadLeft(5) + ' ' + ([string]$r.n_cancel).PadLeft(5) + ' ' + ([string]$r.n_fuori).PadLeft(6) + ' ' + ([string]$r.n_altro_seg).PadLeft(10) + ' ' + ([string]$r.n_senza_ora).PadLeft(10) + '  ' + (Verdetto $r))
}
[void]$rp.Add('')
if($nLetti -gt 0){
  [void]$rp.Add('   TOTALE su 33: TROVATO con testo di fallimento ' + $nFail + ' | TROVATO senza fallimento ' + $nKwOnly + ' | solo il numero ' + $nNum + ' | NON TROVATO ' + $nNon)
} else {
  [void]$rp.Add('   TOTALE su 33: NON VERIFICABILE (nessun file letto)')
}
[void]$rp.Add('   (fuori = ora simulata fuori finestra, altro_seg = stesso numero in un altra passata del file, senza_ora = riga senza ora simulata: SONO CONTATE A PARTE e non valgono come trovate; elenco in RIGHE_TROVATE.csv)')
[void]$rp.Add('')
[void]$rp.Add('4. CONTEGGIO PER TESTO D ERRORE')
[void]$rp.Add('   4a. righe COERENTI dei 33 ticket con parola di fallimento (failed, market closed, 10018, reject, invalid, error, retcode diverso da 10008/10009):')
if($ErrTicket.Count -eq 0){ [void]$rp.Add('      nessuna') }
foreach($k in @($ErrTicket.Keys | Sort-Object { -1 * $ErrTicket[$_] }, { $_ })){ [void]$rp.Add('      ' + ([string]$ErrTicket[$k]).PadLeft(6) + '  ' + (Asc $k)) }
[void]$rp.Add('   4b. TUTTE le righe del giorno con CTrade:: o failed (non legate ai ticket), per testo (primi 25):')
if($ErrGlobale.Count -eq 0){ [void]$rp.Add('      nessuna') }
$kg25 = @($ErrGlobale.Keys | Sort-Object { -1 * $ErrGlobale[$_] }, { $_ } | Select-Object -First 25)
foreach($k in $kg25){ [void]$rp.Add('      ' + ([string]$ErrGlobale[$k]).PadLeft(6) + '  ' + (Asc $k)) }
[void]$rp.Add('')
[void]$rp.Add('5. LE RIGHE COERENTI (primi 40 blocchi; tutti, con il contesto, in RIGHE_CON_CONTESTO.txt)')
$k2 = 0
foreach($b in $Blocchi){
  $k2++; if($k2 -gt 40){ break }
  [void]$rp.Add('   ticket ' + $b['ticket'] + ' ' + $b['caso'] + ' riga ' + $b['riga'] + ' ' + $(if($b['fail']){ '[FALLIMENTO] ' } else { '' }) + $b['testo'])
}
if($Blocchi.Count -eq 0){ [void]$rp.Add('   nessuna') }
[void]$rp.Add('')
[void]$rp.Add('COME SI LEGGE: TROVATO con fallimento = esiste una riga del log grezzo, nella passata giusta e nell ora giusta, che porta il numero del ticket e un testo di fallimento: il TESTO fra parentesi quadre o il retcode e il dato che mancava; leggerlo nel blocco. NON TROVATO = nessuna riga: vale come "non trovato", NON come smentita, se la sonda globale mostra CTrade/cancel a zero o se il file del giorno manca.')
[void]$rp.Add('Questo script RACCOGLIE e non giudica la causa. Nessun file di log e stato toccato.')
($rp -join "`r`n") | Set-Content -LiteralPath (Join-Path $Cart 'RIEPILOGO_LOG_AGENTI_P003.txt') -Encoding ASCII

# 5f. lo zip, poi l'elenco dei file attesi VERIFICATO
Compress-Archive -Path (Join-Path $Cart '*') -DestinationPath $zip
$attesi = @('RIEPILOGO_LOG_AGENTI_P003.txt', 'RIGHE_CON_CONTESTO.txt', 'RIGHE_TROVATE.csv', 'FILE_LOG_TROVATI.csv', 'TICKET_ATTESI.csv')
Write-Host ''
Dico ('file nella cartella ' + $Cart + ':') 'Cyan'
$manca = 0
foreach($a in $attesi){
  $pa = Join-Path $Cart $a
  if(Test-Path -LiteralPath $pa){ Dico ('   OK     ' + $a + '  ' + (Get-Item -LiteralPath $pa).Length.ToString($IC) + ' byte') 'Green' } else { Dico ('   MANCA  ' + $a) 'Red'; $manca++ }
}
Add-Type -AssemblyName System.IO.Compression.FileSystem
$za = [IO.Compression.ZipFile]::OpenRead($zip)
try{
  $voci = @($za.Entries | ForEach-Object { $_.Name })
  Dico ('voci nello zip: ' + $voci.Count) 'Cyan'
  foreach($a in $attesi){ if($voci -contains $a){ Dico ('   nello zip OK     ' + $a) 'Green' } else { Dico ('   nello zip MANCA  ' + $a) 'Red'; $manca++ } }
} finally { $za.Dispose() }
Write-Host ''
if($nLetti -eq 0){
  Dico 'ESITO: NON VERIFICABILE -- nessun file log dei giorni richiesti sotto una cartella Tester del profilo. Lo zip dice cosa e stato cercato e cosa c e.' 'Red'
} else {
  Dico ('ESITO su 33 ticket: TROVATO con testo di fallimento ' + $nFail + ' | TROVATO senza fallimento ' + $nKwOnly + ' | solo il numero ' + $nNum + ' | NON TROVATO ' + $nNon) 'Cyan'
}
Dico ('ZIP PRONTO DA MANDARE: ' + $zip) 'Green'
Dico 'FILE ATTESI NELLO ZIP: RIEPILOGO_LOG_AGENTI_P003.txt + RIGHE_CON_CONTESTO.txt + RIGHE_TROVATE.csv + FILE_LOG_TROVATI.csv + TICKET_ATTESI.csv' 'Gray'
if($manca -gt 0){ Dico ('ATTENZIONE: ' + $manca + ' file attesi MANCANO: lo zip va mandato lo stesso, con il messaggio rosso qui sopra.') 'Red'; exit 3 }
exit 0
