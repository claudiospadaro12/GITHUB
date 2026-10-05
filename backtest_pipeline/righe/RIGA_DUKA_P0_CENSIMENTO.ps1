# =====================================================================
#  MARCATORE_RIGA_DUKA_P0_v3
#  RIGA_DUKA_P0_CENSIMENTO.ps1 -- P0 di report/PIANO_REGIME_DOW_DUKASCOPY_2026-10-05.md
#  (par. 3.1): CENSIMENTO DI SOLA LETTURA del PC di backtest prima di
#  toccare il Dow Dukascopy. NESSUN download, NESSUN MT5 aperto, NESSUN
#  python lanciato, NESSUN processo chiuso, NESSUN file scritto o copiato
#  fuori da: la cartella DUKA_P0_<data> sul Desktop e il suo zip.
# ---------------------------------------------------------------------
#  BERSAGLIO: SOLO una finestra PowerShell sul PC di backtest
#  DESKTOP-H4D7CAJ. Se il nome macchina e' un altro la riga si ferma PRIMA
#  di leggere qualunque cosa (sul VPS VMI3047753 non si lancia: la trial
#  FTMO 1514806751 sta operando, firma 21/09/2026).
#  NON TOCCATI, per nome: il VPS e tutti i suoi terminali (50503392
#  piccolo, 50504263 100k, 10105439 REALE C:\BCM_Reale, 50504400 banco
#  C:\MT5_Backtest, C:\FTMO), Pepperstone, Tickmill.
#  Su questo PC il terminale e' C:\Program Files\BCM Markets MT5 Terminal,
#  demo 50503392 (LO STESSO numero del piccolo del VPS: due macchine,
#  stesso conto): il censimento dei grafici serve a vedere se ci sono sedie
#  attaccate PRIMA che P1 apra il terminale.
# ---------------------------------------------------------------------
#  COSA MISURA (e per quale ragione del piano):
#   1. nome macchina, utente, conto del terminale (dal giornale, mai a occhio)
#   2. spazio libero sui dischi, e su quello di dukascopy_lavoro e dei dati MT5
#      (il tetto di F1 e' 12 GB liberi; il backup dei CSV del 03/09 per la
#      F2 punto 2 pesa quanto la cartella tick\)
#   3. la cache raw\USA30IDXUSD dei 222 giorni 2024-10-01 -> 2025-06-16
#      (sabati esclusi, come giorni() di dukascopy_tick.py): file, byte,
#      slot orari mancanti / a zero byte / .assente, e i 9 giorni della
#      sonda PER NOME (i 4 nuovi: 2024.12.10 2025.01.14 2025.02.11 e
#      2025.03.12, il giorno del controllo negativo)
#   4. i CSV U30USD_DK_ticks_*.csv di tick\ e di MQL5\Files: nome, byte,
#      righe, data del file, primo e ultimo tick; il referto del .py
#      (con quale calendario DST furono scritti)
#   5. MT5: processi aperti, cartelle dati, grafici salvati con un EA
#      attaccato (lettura dei .chr, come le guardie di R280/DAXAP02), i
#      file mensili dei tick NATIVI di U30USD (presenza, non contenuto) e
#      i residui custom U30USD_DK / U30USD_DKNEG
#   5b. MaxBars di config\common.ini (tetto barre: classe 160)
#   6. python e curl.exe: SOLO se ci sono (Get-Command / Test-Path), mai
#      eseguiti (l'alias python.exe dello Store apre il Microsoft Store)
# ---------------------------------------------------------------------
#  LIMITI DICHIARATI (non sono difetti, sono cio' che questa riga NON sa):
#   - i .bi5 non si decodificano qui (lzma): "slot pieno" = file con byte,
#     non "file valido"; la validita' la guarda dukascopy_tick.py --solo-cache
#     (che butta le cache illeggibili e conta i buchi);
#   - un file mensile .tkc nativo presente NON prova che il giorno
#     2024.11.20 ci sia dentro: lo dice solo la sonda ("tick nativi=0 ->
#     NON confrontabile");
#   - i .chr si aggiornano solo quando MT5 salva il profilo: un grafico
#     aperto e mai salvato non compare; con MT5 aperto la foto dei .chr
#     puo' essere vecchia;
#   - "ZERO grafici letti" = NON VERIFICABILE, mai "nessuna sedia".
#  NIENTE `exit` (la riga gira con Invoke-Expression dentro la console di
#  Claudio: un exit chiuderebbe la finestra), NIENTE param(): il pin e
#  l'impronta arrivano dal bootstrap nelle variabili DUKA_P0_PIN e
#  DUKA_P0_SHA, se ci sono.
#  ASCII PURO (Windows PowerShell 5.1 legge i .ps1 come ANSI).
# =====================================================================
$ErrorActionPreference = 'Stop'
$INV = [Globalization.CultureInfo]::InvariantCulture
$MacchinaAmmessa = 'DESKTOP-H4D7CAJ'
if($env:COMPUTERNAME -ne $MacchinaAmmessa){
  throw ('QUESTA RIGA GIRA SOLO SUL PC DI BACKTEST ' + $MacchinaAmmessa + '. Qui la macchina si chiama: ' + $env:COMPUTERNAME + '. Sul VPS VMI3047753 non si lancia mai (firma del 21/09/2026). Non ho letto, creato o scritto niente.')
}

$T0     = Get-Date
$Stamp  = $T0.ToString('yyyyMMdd_HHmmss', $INV)
$Dsk    = Join-Path $env:USERPROFILE 'Desktop'
if(-not (Test-Path -LiteralPath $Dsk)){ $Dsk = $env:USERPROFILE }
$Lavoro = Join-Path $env:USERPROFILE 'dukascopy_lavoro'
$SogliaLiberiGB = 12
$Giorno1 = '2024-10-01'
$Giorno2 = '2025-06-16'
$GiorniSonda = @('2024.11.20','2025.06.10','2024.10.29','2024.10.31','2025.03.12','2025.03.25','2024.12.10','2025.01.14','2025.02.11')
$GiorniNuovi = @('2024.12.10','2025.01.14','2025.02.11','2025.03.12')
$MesiNativi  = @('202410','202411','202412','202501','202502','202503','202506')
$PinRiga = 'non dichiarato (script lanciato senza bootstrap)'
$ShaRiga = 'non dichiarata'
if($null -ne (Get-Variable -Name DUKA_P0_PIN -ErrorAction SilentlyContinue)){ $PinRiga = '' + $DUKA_P0_PIN }
if($null -ne (Get-Variable -Name DUKA_P0_SHA -ErrorAction SilentlyContinue)){ $ShaRiga = '' + $DUKA_P0_SHA }

$R         = New-Object System.Collections.ArrayList     # il referto
$Problemi  = New-Object System.Collections.ArrayList
$CsvCache  = New-Object System.Collections.ArrayList     # P0_CACHE_PER_GIORNO.csv
$CsvTick   = New-Object System.Collections.ArrayList     # P0_CSV_TICK.csv
$S         = @{}                                         # i risultati, riletti dalla SINTESI
$Fatale    = ''
$Cart      = ''
$Zip       = ''
$ZipOk     = $false
$ZipPresenti = ''
$ZipMancanti = ''

function Pulisci([string]$t){ if($null -eq $t){ return '' }; return ($t -replace '[^\x20-\x7E]', '?') }
function Dico([string]$t, [string]$c = 'Gray'){ $p = Pulisci $t; [void]$R.Add($p); Write-Host $p -ForegroundColor $c }
function Titolo([string]$t){ Dico ''; Dico ('=== ' + $t + ' ===') 'Cyan' }
function Gb([double]$b){ return ([math]::Round($b / 1GB, 2)).ToString('0.00', $INV) }
function Mb([double]$b){ return ([math]::Round($b / 1MB, 1)).ToString('0.0', $INV) }

# lettura CONDIVISA con riconoscimento UTF-16 (origin.txt, log, ini di MT5)
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
  # il BOM (U+FEFF) si TOGLIE: Trim() non lo toglie, e -ieq lo ignora o no a seconda della cultura (il selettore del terminale confronta origin.txt)
  if($b[0] -eq 0xFF -and $b[1] -eq 0xFE){ return ([Text.Encoding]::Unicode.GetString($b)).TrimStart([char]0xFEFF) }
  $zeri = 0; $n = [math]::Min(400, $b.Count)
  for($i = 1; $i -lt $n; $i += 2){ if($b[$i] -eq 0){ $zeri++ } }
  if($zeri -gt ($n / 4)){ return ([Text.Encoding]::Unicode.GetString($b)).TrimStart([char]0xFEFF) }
  return ([Text.Encoding]::UTF8.GetString($b)).TrimStart([char]0xFEFF)
}

# un passo che muore non uccide gli altri: il difetto e' scritto e il passo e' NON MISURATO
function Passo([string]$nome, [scriptblock]$corpo){
  try{ & $corpo }
  catch{
    $m = Pulisci ('' + $_.Exception.Message)
    [void]$Problemi.Add($nome + ': ' + $m)
    Dico ('  !!! passo "' + $nome + '" FALLITO: ' + $m + '  -> NON MISURATO') 'Red'
  }
}

# conta le righe e legge primo/ultimo tick di un CSV, senza caricarlo in memoria
function Leggi-CsvTick([string]$path){
  $o = @{ Righe = [long]0; Primo = '-'; Ultimo = '-' }
  $path = (Convert-Path -LiteralPath $path)
  $fs = [IO.File]::Open($path, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
  $sr = New-Object IO.StreamReader($fs, [Text.Encoding]::ASCII, $false, 1048576)
  try{
    $n = [long]0; $prima = $null; $ult = $null
    while($null -ne ($l = $sr.ReadLine())){
      $n++
      if($n -eq 2){ $prima = $l }
      $ult = $l
    }
    $o.Righe = [math]::Max([long]0, $n - 1)       # senza l'intestazione
    if($null -ne $prima){ $o.Primo = ($prima.Split(','))[0] }
    if($null -ne $ult -and $n -ge 2){ $o.Ultimo = ($ult.Split(','))[0] }
  } finally { $sr.Close(); $fs.Close() }
  return $o
}

try{
  Titolo 'DUKA P0 -- CENSIMENTO DI SOLA LETTURA (piano Dow Dukascopy 05/10/2026, par. 3.1)'
  Dico ('avvio ........ ' + $T0.ToString('yyyy-MM-dd HH:mm:ss', $INV) + '  (ora del PC)')
  Dico ('pin riga ..... ' + $PinRiga)
  Dico ('sha256 riga .. ' + $ShaRiga)
  Dico 'perimetro ... SOLA LETTURA: nessun download, nessun MT5 aperto, nessun python lanciato, nessun processo chiuso.'

  # -------------------------------------------------------------------
  Titolo '1. MACCHINA E UTENTE'
  Passo 'macchina' {
    Dico ('nome macchina ..... ' + $env:COMPUTERNAME + '   (ammessa: ' + $MacchinaAmmessa + ')')
    Dico ('utente ............ ' + $env:USERNAME)
    Dico ('profilo ........... ' + $env:USERPROFILE)
    Dico ('cartella lavoro ... ' + $Lavoro + '   esiste: ' + (Test-Path -LiteralPath $Lavoro))
    $S.macchina = $env:COMPUTERNAME
  }

  # -------------------------------------------------------------------
  Titolo '2. SPAZIO LIBERO SUI DISCHI'
  Passo 'dischi' {
    $dischi = @(Get-CimInstance Win32_LogicalDisk -Filter 'DriveType=3' -ErrorAction Stop)
    if($dischi.Count -eq 0){ throw 'nessun disco fisso letto da Win32_LogicalDisk' }
    $S.dischi = @{}
    foreach($v in $dischi){
      $S.dischi[('' + $v.DeviceID).ToUpper()] = [double]$v.FreeSpace
      Dico ('  ' + $v.DeviceID + '  totale ' + (Gb ([double]$v.Size)) + ' GB   LIBERO ' + (Gb ([double]$v.FreeSpace)) + ' GB   (' + ([double]$v.FreeSpace).ToString('0', $INV) + ' byte)')
    }
    $lettera = ''
    if($Lavoro -match '^([A-Za-z]:)'){ $lettera = $Matches[1].ToUpper() }
    if($S.dischi.ContainsKey($lettera)){
      $lib = $S.dischi[$lettera]
      $S.liberi_lavoro_gb = $lib / 1GB
      Dico ('disco di dukascopy_lavoro (' + $lettera + '): LIBERO ' + (Gb $lib) + ' GB  -- soglia del piano per F1 (NON ancora firmata): ' + $SogliaLiberiGB + ' GB liberi')
    } else {
      Dico ('disco di dukascopy_lavoro: lettera "' + $lettera + '" NON trovata fra i dischi letti -> NON MISURATO') 'Yellow'
    }
    $lettD = ''
    if(('' + $env:APPDATA) -match '^([A-Za-z]:)'){ $lettD = $Matches[1].ToUpper() }
    Dico ('disco dei dati MT5 (APPDATA, dove finisce la base tick del custom, ~2,6 GB del nucleo): ' + $(if($lettD -eq ''){ 'NON MISURATO' }elseif(-not $S.dischi.ContainsKey($lettD)){ $lettD + ' NON trovato fra i dischi letti -> NON MISURATO' }elseif($lettD -eq $lettera){ 'lo STESSO di dukascopy_lavoro (' + $lettD + '): i 12 GB si contano su un disco solo' }else{ $lettD + ' LIBERO ' + (Gb $S.dischi[$lettD]) + ' GB (disco DIVERSO da dukascopy_lavoro)' }))
  }

  # -------------------------------------------------------------------
  Titolo '3. CACHE raw\USA30IDXUSD DEI 222 GIORNI 2024-10-01 -> 2025-06-16'
  Passo 'cache raw' {
    $raw  = Join-Path $Lavoro 'raw'
    $rawS = Join-Path $raw 'USA30IDXUSD'
    $S.cache_esiste = (Test-Path -LiteralPath $rawS)
    Dico ('cartella ' + $rawS + '  esiste: ' + $S.cache_esiste)
    if(Test-Path -LiteralPath $raw){
      $altri = @(Get-ChildItem -LiteralPath $raw -Directory -ErrorAction SilentlyContinue | ForEach-Object { $_.Name })
      Dico ('simboli presenti in raw\ : ' + ($altri -join ', '))
    }
    if(-not $S.cache_esiste){
      if(Test-Path -LiteralPath $Lavoro){
        $sott = @(Get-ChildItem -LiteralPath $Lavoro -Directory -ErrorAction SilentlyContinue | Sort-Object Name | ForEach-Object { $_.Name })
        Dico ('cartelle in dukascopy_lavoro (dove sta la cache, se non e qui?): ' + ($sott -join ', '))
      }
      Dico 'CACHE ASSENTE: se la cache non c e, P1 diventa un RISCARICO di 222 giorni (~15-59 ore, piano par. 3.1): si ridiscute, non si scarica da qui.' 'Yellow'
      $S.cache_giorni_attesi = 0
      return
    }
    $d0 = [datetime]::ParseExact($Giorno1, 'yyyy-MM-dd', $INV)
    $d1 = [datetime]::ParseExact($Giorno2, 'yyyy-MM-dd', $INV)
    $giorni = New-Object System.Collections.ArrayList
    for($d = $d0; $d -le $d1; $d = $d.AddDays(1)){
      if($d.DayOfWeek -ne [DayOfWeek]::Saturday){ [void]$giorni.Add($d) }       # come giorni() di dukascopy_tick.py
    }
    $S.cache_giorni_attesi = $giorni.Count
    Dico ('giorni attesi (sabati esclusi): ' + $giorni.Count + '   (il piano dice 222)   slot orari attesi: ' + ($giorni.Count * 24))
    [void]$CsvCache.Add('Giorno,Cartella,Bi5,Zero,Assenti,Buchi,Doppi,Tmp,Byte')
    $tot = @{ bi5 = 0; zero = 0; ass = 0; buchi = 0; doppi = 0; tmp = 0; byte = [long]0; completi = 0; senzaCartella = 0 }
    $perGiorno = @{}
    $conBuchi = New-Object System.Collections.ArrayList
    $conZero  = New-Object System.Collections.ArrayList
    $finestra = @{}
    foreach($d in $giorni){
      # LAYOUT della cache come lo scrive dukascopy_tick.py (percorso_cache): raw\<SIMBOLO>\AAAA\MM\GG\HHh_ticks.bi5 con MM = mese di CALENDARIO
      # (ottobre = 10). Il mese ZERO-BASED e' solo nell'URL di Dukascopy, NON nella cartella (errore preso e corretto il 05/10: classe 1114).
      $dir = Join-Path $rawS ($d.Year.ToString('0000', $INV) + '\' + $d.Month.ToString('00', $INV) + '\' + $d.Day.ToString('00', $INV))
      $nomi = @{}
      $esisteDir = Test-Path -LiteralPath $dir
      if($esisteDir){
        foreach($f in @(Get-ChildItem -LiteralPath $dir -File -Force -ErrorAction SilentlyContinue)){ $nomi[$f.Name] = [long]$f.Length; $finestra[$f.FullName] = 1 }
      } else { $tot.senzaCartella++ }
      $c = @{ bi5 = 0; zero = 0; ass = 0; buchi = 0; doppi = 0; tmp = 0; byte = [long]0 }
      $oreBuco = New-Object System.Collections.ArrayList
      $oreZero = New-Object System.Collections.ArrayList
      for($h = 0; $h -lt 24; $h++){
        $n  = $h.ToString('00', $INV) + 'h_ticks.bi5'
        $ha = $nomi.ContainsKey($n); $hs = $nomi.ContainsKey($n + '.assente')
        if($nomi.ContainsKey($n + '.tmp')){ $c.tmp++ }
        if($ha -and $hs){ $c.doppi++; [void]$oreBuco.Add($h.ToString('00', $INV) + 'h=DOPPIO') }
        if($ha){
          if($nomi[$n] -gt 0){ $c.bi5++; $c.byte += $nomi[$n] } else { $c.zero++; [void]$oreZero.Add($h.ToString('00', $INV) + 'h') }
        } elseif($hs){ $c.ass++ }
        else { $c.buchi++; [void]$oreBuco.Add($h.ToString('00', $INV) + 'h') }
      }
      $chiave = $d.ToString('yyyy.MM.dd', $INV)
      $perGiorno[$chiave] = $c
      foreach($k in @('bi5','zero','ass','buchi','doppi','tmp')){ $tot[$k] += $c[$k] }
      $tot.byte += $c.byte
      # ZERO BYTE = ora vuota LEGITTIMA (200 di lunghezza zero) oppure file troncato: da qui sono INDISTINGUIBILI (checklist 16, "vuoto e distrutto hanno la stessa faccia").
      # Non e' un buco: il giorno e' completo se ogni slot ha il suo file e nessuno e' doppio. Gli zero byte si elencano a parte.
      $completo = ($c.buchi -eq 0 -and $c.doppi -eq 0)
      if($completo){ $tot.completi++ } else { [void]$conBuchi.Add($chiave + ' [' + ($oreBuco -join ' ') + ']' + $(if($c.doppi -gt 0){ ' DOPPI=' + $c.doppi }else{ '' })) }
      if($c.zero -gt 0){ [void]$conZero.Add($chiave + ' [' + ($oreZero -join ' ') + ']') }
      [void]$CsvCache.Add($chiave + ',' + $esisteDir + ',' + $c.bi5 + ',' + $c.zero + ',' + $c.ass + ',' + $c.buchi + ',' + $c.doppi + ',' + $c.tmp + ',' + $c.byte)
    }
    $S.cache_completi = $tot.completi
    $S.cache_buchi = $tot.buchi
    $S.cache_zero = $tot.zero
    $S.cache_doppi = $tot.doppi
    $S.cache_perGiorno = $perGiorno
    Dico ('giorni con cartella: ' + ($giorni.Count - $tot.senzaCartella) + '   senza cartella: ' + $tot.senzaCartella)
    Dico ('giorni COMPLETI (24 slot ciascuno col suo file, nessun buco, nessun doppio; gli zero byte NON sono buchi): ' + $tot.completi + ' su ' + $giorni.Count)
    Dico ('slot: bi5 con byte ' + $tot.bi5 + ' | .assente ' + $tot.ass + ' | bi5 a ZERO BYTE (ora vuota o troncata: indistinguibili) ' + $tot.zero + ' | BUCHI (ne bi5 ne .assente) ' + $tot.buchi + ' | DOPPI (bi5 e .assente) ' + $tot.doppi + ' | .tmp residui ' + $tot.tmp)
    Dico ('byte dei .bi5 nella finestra: ' + $tot.byte + '  (' + (Mb $tot.byte) + ' MB)')
    # tutto l'albero di USA30IDXUSD, anche fuori finestra
    $tutti = @(Get-ChildItem -LiteralPath $rawS -Recurse -File -Force -ErrorAction SilentlyContinue)
    $totByte = [long]0; foreach($f in $tutti){ $totByte += [long]$f.Length }
    $fuori = 0; foreach($f in $tutti){ if(-not $finestra.ContainsKey($f.FullName)){ $fuori++ } }
    Dico ('albero USA30IDXUSD: ' + $tutti.Count + ' file, ' + $totByte + ' byte (' + (Mb $totByte) + ' MB); fuori dai 222 giorni: ' + $fuori + ' file')
    $rawR = (Convert-Path -LiteralPath $rawS)
    $camp = @($tutti | Select-Object -First 5 | ForEach-Object { $_.FullName.Substring($rawR.Length).TrimStart('\', '/').Replace('/', '\') })
    Dico ('esempi di percorso nell albero (primi 5, relativi a USA30IDXUSD: AAAA\MM\GG\HHh_ticks.bi5, MM = mese di calendario): ' + ($camp -join ' | '))
    if($conBuchi.Count -gt 0){
      Dico ('giorni NON completi: ' + $conBuchi.Count)
      $k = 0
      foreach($g in $conBuchi){ $k++; if($k -le 40){ Dico ('   ' + $g) 'Yellow' } }
      if($conBuchi.Count -gt 40){ Dico ('   ... e altri ' + ($conBuchi.Count - 40) + ' (tutti in P0_CACHE_PER_GIORNO.csv)') 'Yellow' }
    }
    if($conZero.Count -gt 0){
      Dico ('giorni con ore a ZERO BYTE: ' + $conZero.Count + '  (ora senza quotazioni oppure file troncato: da qui non si distingue; la validita la guarda dukascopy_tick.py)')
      $k = 0
      foreach($g in $conZero){ $k++; if($k -le 15){ Dico ('   ' + $g) } }
      if($conZero.Count -gt 15){ Dico ('   ... e altri ' + ($conZero.Count - 15) + ' (conteggi in P0_CACHE_PER_GIORNO.csv, colonna Zero)') }
    }
    Dico ''
    Dico 'I 9 GIORNI DELLA SONDA, PER NOME (4 nuovi segnati con *):'
    foreach($g in $GiorniSonda){
      $c = $perGiorno[$g]
      $mark = $(if($GiorniNuovi -contains $g){ '*' }else{ ' ' })
      if($null -eq $c){ Dico ('  ' + $mark + ' ' + $g + '  FUORI dai giorni attesi (sabato o fuori finestra) -> NON MISURATO') 'Yellow'; continue }
      $ok = ($c.buchi -eq 0 -and $c.doppi -eq 0)
      Dico ('  ' + $mark + ' ' + $g + '  bi5 ' + $c.bi5 + '  assenti ' + $c.ass + '  zero ' + $c.zero + '  buchi ' + $c.buchi + '  doppi ' + $c.doppi + '   -> ' + $(if($ok){ 'COMPLETO in cache' }else{ 'NON COMPLETO' })) $(if($ok){ 'Gray' }else{ 'Yellow' })
    }
    Dico 'Un bi5 "con byte" NON e provato valido (qui non si decodifica lzma): la validita la conta dukascopy_tick.py --solo-cache (buchi_cache, cache illeggibile).'
  }

  # -------------------------------------------------------------------
  Titolo '4. CSV U30USD_DK_ticks_*.csv (nome, byte, righe, data del file, primo/ultimo tick)'
  Passo 'csv tick' {
    $tick = Join-Path $Lavoro 'tick'
    $S.tick_esiste = (Test-Path -LiteralPath $tick)
    Dico ('cartella ' + $tick + '  esiste: ' + $S.tick_esiste)
    [void]$CsvTick.Add('Posto,Nome,Byte,UltimaScrittura,Righe,Primo,Ultimo')
    $S.csv_n = 0; $S.csv_righe = [long]0; $S.csv_byte = [long]0; $S.csv_nonlette = 0
    if($S.tick_esiste){
      Dico '(conto le righe di ogni CSV: sono centinaia di MB, puo volerci qualche minuto; non scrive niente)' 'DarkGray'
      $fs = @(Get-ChildItem -LiteralPath $tick -Filter 'U30USD_DK_ticks_*.csv' -File -ErrorAction SilentlyContinue | Sort-Object Name)
      Dico ('CSV in tick\ : ' + $fs.Count)
      foreach($f in $fs){
        $S.csv_n++; $S.csv_byte += [long]$f.Length
        $dt = $f.LastWriteTime.ToString('yyyy-MM-dd HH:mm', $INV)
        # un CSV che non si apre (bloccato da un altro processo) NON ferma il conteggio degli altri: il file si conta, le sue righe NO (e la sintesi dice PARZIALE)
        $i = $null; $err = ''
        try{ $i = Leggi-CsvTick $f.FullName } catch { $err = Pulisci ('' + $_.Exception.Message) }
        if($null -eq $i){
          $S.csv_nonlette++
          [void]$Problemi.Add('csv tick, ' + $f.Name + ': righe NON MISURATE (file non apribile): ' + $err)
          Dico ('   ' + $f.Name + '  ' + $f.Length + ' byte (' + (Mb ([double]$f.Length)) + ' MB)  scritto ' + $dt + '  righe NON MISURATE (file non apribile: ' + $err + ')') 'Yellow'
          [void]$CsvTick.Add('tick,' + $f.Name + ',' + $f.Length + ',' + $dt + ',NON_MISURATO,-,-')
          continue
        }
        $S.csv_righe += $i.Righe
        Dico ('   ' + $f.Name + '  ' + $f.Length + ' byte (' + (Mb ([double]$f.Length)) + ' MB)  scritto ' + $dt + '  righe ' + $i.Righe + '  primo ' + $i.Primo + '  ultimo ' + $i.Ultimo)
        [void]$CsvTick.Add('tick,' + $f.Name + ',' + $f.Length + ',' + $dt + ',' + $i.Righe + ',' + $i.Primo + ',' + $i.Ultimo)
      }
      Dico ('totale tick\ : ' + $S.csv_n + ' file, ' + $S.csv_righe + ' righe' + $(if($S.csv_nonlette -gt 0){ ' (SENZA le righe di ' + $S.csv_nonlette + ' file non apribili)' }else{ '' }) + ', ' + $S.csv_byte + ' byte (' + (Gb ([double]$S.csv_byte)) + ' GB)  -- il backup dei CSV del 03/09 per la F2 punto 2 pesa questo')
      $altriNomi = @(Get-ChildItem -LiteralPath $tick -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -notlike 'U30USD_DK_ticks_*.csv' } | ForEach-Object { $_.Name })
      if($altriNomi.Count -gt 0){ Dico ('altri file in tick\ : ' + ($altriNomi -join ', ')) }
      $negs = @(Get-ChildItem -LiteralPath $tick -Filter '*DKNEG*' -ErrorAction SilentlyContinue | ForEach-Object { $_.Name })
      Dico ('residui DKNEG in tick\ : ' + $(if($negs.Count -gt 0){ ($negs -join ', ') }else{ 'nessuno' }))
      $rf = Join-Path $tick 'referto_dukascopy_tick.txt'
      if(Test-Path -LiteralPath $rf){
        Dico 'referto_dukascopy_tick.txt (prime righe, per sapere con quale calendario DST sono stati scritti):'
        foreach($l in @(Get-Content -LiteralPath $rf -TotalCount 12 -ErrorAction SilentlyContinue)){ Dico ('   | ' + $l) }
      } else { Dico 'referto_dukascopy_tick.txt: NON presente in tick\ (il calendario DST dei CSV non e agli atti qui)' 'Yellow' }
    }
    $bak = @(Get-ChildItem -LiteralPath $Lavoro -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -like 'tick_*' -or $_.Name -like '*backup*' } | ForEach-Object { $_.Name })
    Dico ('cartelle di backup / tick_* in dukascopy_lavoro : ' + $(if($bak.Count -gt 0){ ($bak -join ', ') }else{ 'nessuna' }))
    $S.csv_completo = $true      # solo se il passo arriva in fondo: un passo morto a meta' NON e' [MISURATO] nella sintesi
  }

  # -------------------------------------------------------------------
  Titolo '5. MT5: PROCESSI, CARTELLE DATI, GRAFICI CON EA, CONTO, TICK NATIVI, CUSTOM'
  Passo 'processi' {
    $nomiP = @('terminal64','metaeditor64','metatester64','python','pythonw','curl')
    $viv = @(Get-Process -ErrorAction SilentlyContinue | Where-Object { $nomiP -contains $_.ProcessName })
    $S.mt5_aperto = (@($viv | Where-Object { $_.ProcessName -eq 'terminal64' }).Count -gt 0)
    $S.pr_download = (@($viv | Where-Object { $_.ProcessName -in @('python','pythonw','curl') }).Count -gt 0)
    Dico ('processi di interesse vivi: ' + $viv.Count)
    foreach($p in $viv){
      $path = '?'; try{ if($p.Path){ $path = $p.Path } }catch{}
      Dico ('   PID ' + $p.Id + '  ' + $p.ProcessName + '  ' + $path)
    }
    Dico ('MT5 (terminal64) APERTO: ' + $S.mt5_aperto + '   --  la riga di import di P1 pretende MT5 e MetaEditor CHIUSI')
    if($S.pr_download){ Dico 'ATTENZIONE: c e un python/curl vivo: se e un download Dukascopy, NON lanciare un altro (classe 853, doppia esecuzione).' 'Yellow' }
  }

  $root = Join-Path $env:APPDATA 'MetaQuotes\Terminal'
  $TermBcm = 'C:\Program Files\BCM Markets MT5 Terminal'
  $dati = New-Object System.Collections.ArrayList
  Passo 'cartelle dati' {
    Dico ('radice ' + $root + '  esiste: ' + (Test-Path -LiteralPath $root))
    foreach($d in @(Get-ChildItem -LiteralPath $root -Directory -ErrorAction SilentlyContinue | Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName 'MQL5') })){
      $o = ''
      $of = Join-Path $d.FullName 'origin.txt'
      if(Test-Path -LiteralPath $of){ $o = (Leggi-Condiviso $of).Trim() }
      [void]$dati.Add(@{ Cartella = $d.FullName; Nome = $d.Name; Origine = $o })
      Dico ('   dati ' + $d.Name + '   programma: ' + $(if($o){ (Pulisci $o) }else{ '(origin.txt assente)' }))
    }
    $S.dati_n = $dati.Count
    $mio = @($dati | Where-Object { $_.Origine -ieq $TermBcm })
    $S.dati_bcm_n = $mio.Count
    Dico ('cartelle dati del terminale ' + $TermBcm + ' : ' + $mio.Count)
    if($mio.Count -ne 1){ Dico 'ATTESA UNA SOLA cartella dati per il terminale BCM: con zero o piu di una i passi che seguono sono NON MISURATI per quel terminale.' 'Yellow' }
  }

  Passo 'conto del terminale' {
    foreach($x in @($dati | Where-Object { $_.Origine -ieq $TermBcm })){
      $conti = @{}
      $ini = Join-Path $x.Cartella 'config\common.ini'
      if(Test-Path -LiteralPath $ini){
        $ti = Leggi-Condiviso $ini
        $mL = [regex]::Match($ti, '(?im)^[ \t]*Login[ \t]*=[ \t]*(\d{5,12})')
        $mS = [regex]::Match($ti, '(?im)^[ \t]*Server[ \t]*=[ \t]*(.+?)[ \t\r]*$')
        if($mL.Success){ Dico ('   conto da config\common.ini : ' + $mL.Groups[1].Value + $(if($mS.Success){ '   server ' + $mS.Groups[1].Value }else{ '' })); $S.conto_ini = $mL.Groups[1].Value }
        else { Dico '   conto da config\common.ini : Login NON trovato' }
        # MaxBars (piano par. 3.1 P0): un tetto basso fa girare il tester su MENO storico senza dirlo (classe 160, checklist 36)
        $mB = [regex]::Matches($ti, '(?im)^[ \t]*MaxBars(?:InChart)?[ \t]*=[ \t]*(\d+)')
        if($mB.Count -gt 0){ $S.maxbars = [int64]$mB[$mB.Count - 1].Groups[1].Value; Dico ('   MaxBars da config\common.ini : ' + $S.maxbars) }
        else { Dico '   MaxBars da config\common.ini : chiave NON trovata (NON VERIFICATO: il valore in uso non e leggibile da qui)' 'Yellow' }
      } else { Dico '   config\common.ini : assente (conto e MaxBars NON MISURATI)' }
      $dl = Join-Path $x.Cartella 'logs'
      if(Test-Path -LiteralPath $dl){
        $fl = @(Get-ChildItem -LiteralPath $dl -Filter *.log -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 5)
        foreach($f in $fl){
          $t = Leggi-Condiviso $f.FullName
          if(-not $t){ continue }
          foreach($m in [regex]::Matches($t, "'(\d{6,12})'\s*:\s*(?:login|authorized|connesso|previous)[^\r\n]*")){ $conti[$m.Groups[1].Value] = $m.Value.Trim() }
        }
        if($conti.Count -eq 0){ Dico '   conto dal giornale (logs\) : NON TROVATO nei 5 giornali piu recenti (non vuol dire che non ci sia)' }
        foreach($k in ($conti.Keys | Sort-Object)){ Dico ('   conto dal giornale (logs\) : ' + $k + '   | ' + (Pulisci $conti[$k])) }
        $S.conto_log = (@($conti.Keys) -join ',')
      } else { Dico '   logs\ : assente (terminale mai avviato?)' }
      if($S.ContainsKey('conto_ini') -and $S.ContainsKey('conto_log') -and $S.conto_log -ne '' -and (-not ($S.conto_log.Split(',') -contains $S.conto_ini))){
        Dico '   ATTENZIONE: il Login di common.ini NON e fra i conti dei giornali: non assumere quale conto e collegato.' 'Yellow'
      }
    }
  }

  Passo 'grafici con EA' {
    $S.chr_letti = 0; $S.chr_con_ea = 0; $S.chr_illeggibili = 0
    foreach($x in @($dati | Where-Object { $_.Origine -ieq $TermBcm })){
      $cr = Join-Path $x.Cartella 'MQL5\Profiles\Charts'
      Dico ('   grafici salvati: ' + $cr + '  esiste: ' + (Test-Path -LiteralPath $cr))
      if(-not (Test-Path -LiteralPath $cr)){ continue }
      foreach($f in @(Get-ChildItem -LiteralPath $cr -Recurse -File -Filter '*.chr' -ErrorAction SilentlyContinue)){
        $S.chr_letti++
        $t = Leggi-Condiviso $f.FullName
        if(-not $t){ $S.chr_illeggibili++; Dico ('     ' + $f.Directory.Name + '\' + $f.Name + '  ILLEGGIBILE: non verificabile, conta come EA possibile') 'Yellow'; continue }
        if($t -match '<expert>'){
          $S.chr_con_ea++
          $nm = '?'; $mm = [regex]::Match($t, '(?s)<expert>\s*name=([^\r\n<]*)'); if($mm.Success){ $nm = $mm.Groups[1].Value.Trim() }
          $sy = '-'; $ms = [regex]::Match($t, '(?im)^[ \t]*symbol[ \t]*=[ \t]*(\S+)'); if($ms.Success){ $sy = $ms.Groups[1].Value }
          $mg = '-'; $mq = [regex]::Match($t, '(?im)^[ \t]*InpMagic[ \t]*=[ \t]*(\S+)'); if($mq.Success){ $mg = $mq.Groups[1].Value }
          Dico ('     EA ATTACCATO: ' + $f.Directory.Name + '\' + $f.Name + '   ' + $nm + '   ' + $sy + '   magic ' + $mg) 'Red'
        }
      }
    }
    Dico ('grafici .chr letti: ' + $S.chr_letti + '   con un EA attaccato: ' + $S.chr_con_ea + '   illeggibili: ' + $S.chr_illeggibili)
    if($S.chr_letti -eq 0){ Dico 'ZERO grafici letti: NON VERIFICABILE se ci sono sedie attaccate (non e "nessuna sedia").' 'Yellow' }
    Dico 'Limite: i .chr si aggiornano solo quando MT5 salva il profilo; con MT5 aperto la foto puo essere vecchia.'
  }

  Passo 'tick nativi e custom' {
    foreach($x in @($dati | Where-Object { $_.Origine -ieq $TermBcm })){
      $bases = Join-Path $x.Cartella 'bases'
      Dico ('   bases: ' + $bases + '  esiste: ' + (Test-Path -LiteralPath $bases))
      if(-not (Test-Path -LiteralPath $bases)){
        Dico '   bases\ ASSENTE: tick nativi di U30USD e custom U30USD_DK NON MISURATI (non vuol dire che manchino: il terminale non ha mai scaricato tick?)' 'Yellow'
        continue
      }
      $S.nativi_mesi = @{}
      $S.nativi_zero = @{}
      $basesR = (Convert-Path -LiteralPath $bases)
      $cartU = @(Get-ChildItem -LiteralPath $bases -Directory -Recurse -Depth 3 -ErrorAction SilentlyContinue | Where-Object { $_.Name -like 'U30USD*' })
      Dico ('   cartelle U30USD* sotto bases\ (profondita 3): ' + $cartU.Count)
      # TICK = cartella U30USD* il cui GENITORE si chiama ticks (bases\<server>\ticks\U30USD\AAAAMM.tkc, bases\Custom\ticks\U30USD_DK).
      # Su un MT5 vero accanto c'e' SEMPRE history\U30USD (barre M1, AAAA.hcc) con lo STESSO nome: contarla come "tick" e' la classe 1119.
      foreach($c in $cartU){
        $rel = $c.FullName.Substring($basesR.Length).TrimStart('\', '/')
        $files = @(Get-ChildItem -LiteralPath $c.FullName -File -ErrorAction SilentlyContinue | Sort-Object Name)
        $b = [long]0; foreach($f in $files){ $b += [long]$f.Length }
        $tipo = $(if($c.Parent.Name -ieq 'ticks'){ 'TICK' }elseif($c.Parent.Name -ieq 'history'){ 'barre M1' }else{ 'altro' })
        Dico ('     bases\' + $rel + '   [' + $tipo + ']   ' + $files.Count + ' file, ' + (Mb ([double]$b)) + ' MB')
        foreach($f in $files){
          $mese = ''; if($f.Name -match '^(\d{6})\.'){ $mese = $Matches[1] }
          $nota = ''
          # un .tkc a ZERO BYTE e' vuoto o troncato (checklist 16): si elenca, ma NON conta come mese presente nella sintesi
          if($mese -ne '' -and ($MesiNativi -contains $mese) -and $c.Name -eq 'U30USD' -and $tipo -eq 'TICK'){
            if([long]$f.Length -gt 0){ $nota = '   <-- mese di un giorno della sonda'; $S.nativi_mesi[$mese] = [long]$f.Length }
            else { $nota = '   <-- mese di un giorno della sonda, file a ZERO BYTE (vuoto o troncato): NON contato come presente'; $S.nativi_zero[$mese] = 0 }
          }
          Dico ('        ' + $f.Name + '  ' + $f.Length + ' byte  ' + $f.LastWriteTime.ToString('yyyy-MM-dd HH:mm', $INV) + $nota)
        }
      }
      $nat = @($cartU | Where-Object { $_.Name -eq 'U30USD' -and $_.Parent.Name -ieq 'ticks' })
      $S.nativi_cartelle = $nat.Count
      if($nat.Count -eq 0){ Dico '   cartella dei tick NATIVI U30USD: NON TROVATA sotto bases\ (cercata: <server>\ticks\U30USD; una history\U30USD sono barre M1, NON tick) -> tick nativi di 2024.11.20 NON MISURATO (non vuol dire che manchino: il percorso e quello noto di MT5, non verificato qui)' 'Yellow' }
      $dk = @($cartU | Where-Object { $_.Name -eq 'U30USD_DK' -and $_.Parent.Name -ieq 'ticks' }).Count
      $dkH = @($cartU | Where-Object { $_.Name -eq 'U30USD_DK' -and $_.Parent.Name -ieq 'history' }).Count
      $neg = @($cartU | Where-Object { $_.Name -like 'U30USD_DKNEG*' }).Count
      $S.custom_dk = $dk; $S.custom_neg = $neg
      Dico ('   custom U30USD_DK presente: ' + ($dk -gt 0) + '  (con TICK, cartella ticks\U30USD_DK; barre M1 history\U30USD_DK: ' + ($dkH -gt 0) + ')   residui U30USD_DKNEG: ' + $(if($neg -gt 0){ 'PRESENTI (da capire prima di P1)' }else{ 'nessuno' }))
    }
    if($S.dati_bcm_n -eq 0){ Dico '   nessuna cartella dati del terminale BCM: tick nativi e custom NON MISURATI' 'Yellow' }
    Dico 'Un file mensile nativo presente NON prova che 2024.11.20 ci sia dentro: lo dice solo la sonda ("tick nativi=0 -> NON confrontabile").'
  }

  Passo 'MQL5 Files' {
    foreach($x in @($dati | Where-Object { $_.Origine -ieq $TermBcm })){
      $ff = Join-Path (Join-Path $x.Cartella 'MQL5') 'Files'
      if(-not (Test-Path -LiteralPath $ff)){ Dico '   MQL5\Files: assente'; continue }
      $cs = @(Get-ChildItem -LiteralPath $ff -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -like 'U30USD_DK*' -or $_.Name -like 'ABTG_ImportTick*' } | Sort-Object Name)
      Dico ('   MQL5\Files: ' + $cs.Count + ' file U30USD_DK* / ABTG_ImportTick*')
      foreach($f in $cs){
        $dt = $f.LastWriteTime.ToString('yyyy-MM-dd HH:mm', $INV)
        $righe = '-'
        if($f.Name -like 'U30USD_DK_ticks_*.csv'){
          $i = $null; $err = ''
          try{ $i = Leggi-CsvTick $f.FullName } catch { $err = Pulisci ('' + $_.Exception.Message) }
          if($null -eq $i){
            $righe = 'NON MISURATE (file non apribile: ' + $err + ')'
            [void]$Problemi.Add('MQL5 Files, ' + $f.Name + ': righe NON MISURATE (file non apribile): ' + $err)
            [void]$CsvTick.Add('MQL5Files,' + $f.Name + ',' + $f.Length + ',' + $dt + ',NON_MISURATO,-,-')
          } else {
            $righe = '' + $i.Righe
            [void]$CsvTick.Add('MQL5Files,' + $f.Name + ',' + $f.Length + ',' + $dt + ',' + $i.Righe + ',' + $i.Primo + ',' + $i.Ultimo)
          }
        }
        Dico ('        ' + $f.Name + '  ' + $f.Length + ' byte  scritto ' + $dt + '  righe ' + $righe)
      }
    }
  }

  # -------------------------------------------------------------------
  Titolo '6. PYTHON E CURL (solo presenza: NON eseguiti)'
  Passo 'python e curl' {
    $py = @(Get-Command python, py -ErrorAction SilentlyContinue)
    if($py.Count -eq 0){ Dico 'python / py: NON trovati nel PATH' 'Yellow'; $S.python = 'assente' }
    foreach($c in $py){
      $p = '' + $c.Source
      $store = ($p -match 'WindowsApps')
      Dico ('   ' + $c.Name + '  ' + $p + $(if($store){ '   <-- ALIAS DELLO STORE: non e un python vero (lanciarlo apre il Microsoft Store)' }else{ '' }))
      if(-not $store){ $S.python = $p }
    }
    if(-not $S.ContainsKey('python')){ $S.python = 'solo alias dello Store' }
    $cu = Join-Path $env:SystemRoot 'System32\curl.exe'
    $S.curl = (Test-Path -LiteralPath $cu)
    Dico ('   curl.exe in System32: ' + $S.curl + '  (' + $cu + ')')
  }
}
catch{
  $Fatale = Pulisci ('' + $_.Exception.Message)
  Dico ('!!! FERMATO: ' + $Fatale) 'Red'
}

# =====================================================================
#  SINTESI: fatti, ciascuno con la sua etichetta. NON e un verdetto sul
#  cancello F2 (quello e di P1): e lo stato del PC prima di P1.
# =====================================================================
try{
  Titolo 'SINTESI DI P0 (fatti letti; "NON MISURATO" = la riga non ha potuto leggerlo)'
  $mis = '[MISURATO]'; $nonm = '[NON MISURATO]'
  if($S.ContainsKey('liberi_lavoro_gb')){
    $ok = ($S.liberi_lavoro_gb -ge $SogliaLiberiGB)
    Dico ('spazio libero su dukascopy_lavoro : ' + ([math]::Round($S.liberi_lavoro_gb, 2)).ToString('0.00', $INV) + ' GB ' + $mis + '   (soglia F1 non firmata ' + $SogliaLiberiGB + ' GB: ' + $(if($ok){ 'raggiunta' }else{ 'NON raggiunta' }) + ')')
    Dico ('   -> per F1: ' + $(if($ok){ 'la condizione di disco di F1 (almeno 12 GB liberi) e soddisfatta; il nucleo stimato e ~8,4 GB (piano par. 3.5)' }else{ 'la condizione di disco di F1 NON e soddisfatta: si riduce il nucleo (W1 da sola ~1,5-2 GB) o si libera disco PRIMA di firmare' }))
  } else { Dico ('spazio libero su dukascopy_lavoro : ' + $nonm + '   -> per F1: senza questo numero il tetto di 12 GB non si firma') }
  if($S.ContainsKey('cache_completi')){
    Dico ('cache 222 giorni : completi ' + $S.cache_completi + ' su ' + $S.cache_giorni_attesi + '  (buchi ' + $S.cache_buchi + ', doppi ' + $S.cache_doppi + '; ore a zero byte ' + $S.cache_zero + ': vuote o troncate, indistinguibili) ' + $mis)
    $sonda = @()
    foreach($g in $GiorniSonda){ $c = $S.cache_perGiorno[$g]; if($null -ne $c -and $c.buchi -eq 0 -and $c.doppi -eq 0){ $sonda += $g } }
    Dico ('giorni della sonda completi in cache : ' + $sonda.Count + ' su ' + $GiorniSonda.Count + ' ' + $mis + '   mancanti: ' + $(if($sonda.Count -eq $GiorniSonda.Count){ 'nessuno' }else{ (@($GiorniSonda | Where-Object { $sonda -notcontains $_ }) -join ' ') }))
    Dico ('   -> per P1: ' + $(if($sonda.Count -eq $GiorniSonda.Count -and $S.cache_completi -eq $S.cache_giorni_attesi){ 'la riconversione --solo-cache dei 222 giorni e la sonda sui 9 giorni partono senza scaricare un byte (validita dei bi5 da confermare con dukascopy_tick.py --solo-cache)' }else{ 'un giorno non completo in cache NON si riscarica sotto F2 (zero download): per quel giorno P1 si ferma e si ridiscute; se e un giorno della sonda, la condizione per nome della F2 non si puo verificare' }))
  } elseif($S.ContainsKey('cache_esiste') -and (-not $S.cache_esiste)){ Dico ('cache raw\USA30IDXUSD : ASSENTE ' + $mis + '  -> STOP di P0: P1 sarebbe un riscarico, si ridiscute') }
  else { Dico ('cache 222 giorni : ' + $nonm) }
  if($S.ContainsKey('csv_n')){
    $etCsv = $(if(-not $S.ContainsKey('csv_completo')){ '[PARZIALE: passo csv tick interrotto a meta, vedi PASSI FALLITI]' }elseif($S.csv_nonlette -gt 0){ '[PARZIALE: righe di ' + $S.csv_nonlette + ' file NON contate, file non apribili]' }else{ $mis })
    Dico ('CSV U30USD_DK in tick\ : ' + $S.csv_n + ' file, ' + $S.csv_righe + ' righe ' + $etCsv)
  } else { Dico ('CSV U30USD_DK in tick\ : ' + $nonm) }
  if($S.ContainsKey('csv_n')){ Dico ('   -> per P1: il backup dei CSV del 03/09 (F2 punto 2) occupa ' + (Gb ([double]$S.csv_byte)) + ' GB in piu sul disco di dukascopy_lavoro, e va fatto PRIMA di riconvertire') }
  if($S.ContainsKey('mt5_aperto')){ Dico ('MT5 aperto : ' + $S.mt5_aperto + ' ' + $mis + $(if($S.mt5_aperto){ '   -> per P1: va CHIUSO prima dell import (stampa PID + titolo + cartella, mai a occhio)' }else{ '' })) } else { Dico ('MT5 aperto : ' + $nonm) }
  if($S.ContainsKey('chr_letti')){
    $ver = $(if($S.chr_letti -eq 0){ 'NON VERIFICABILE (zero grafici letti)' }else{ '' + $S.chr_con_ea + ' grafici con EA, ' + $S.chr_illeggibili + ' illeggibili' })
    Dico ('sedie attaccate (dai .chr salvati) : ' + $ver + ' ' + $(if($S.chr_letti -eq 0){ $nonm }else{ $mis }))
    if($S.chr_letti -eq 0 -or $S.chr_con_ea -gt 0 -or $S.chr_illeggibili -gt 0){ Dico '   -> per P1: sedie attaccate o non verificabili: prima di aprire MT5 per l import si guarda il terminale (piano par. 4 punto 10, ordini veri del 14/08 da questa macchina)' 'Yellow' }
  } else { Dico ('sedie attaccate : ' + $nonm) }
  if($S.ContainsKey('maxbars')){ Dico ('MaxBars (config\common.ini) : ' + $S.maxbars + ' ' + $mis + $(if($S.maxbars -lt 200000){ '   -> per P2/P6: tetto BASSO, il tester girerebbe su meno storico senza dirlo (classe 160): va alzato prima dei round' }else{ '' })) } else { Dico ('MaxBars : ' + $nonm + '   -> per P2/P6: da verificare prima dei round (classe 160)') }
  if($S.ContainsKey('custom_dk')){ Dico ('custom U30USD_DK con tick (bases\Custom\ticks) : ' + ($S.custom_dk -gt 0) + ', residui DKNEG: ' + $S.custom_neg + ' ' + $mis) } else { Dico ('custom U30USD_DK : ' + $nonm) }
  if($S.ContainsKey('nativi_cartelle')){ Dico ('tick nativi U30USD sotto bases\ : cartelle ' + $S.nativi_cartelle + ', mesi della sonda con file ' + $S.nativi_mesi.Count + ' su ' + $MesiNativi.Count + ' (presenza del mese, NON del giorno 2024.11.20; file a zero byte NON contati: ' + $S.nativi_zero.Count + ') ' + $mis) } else { Dico ('tick nativi U30USD : ' + $nonm) }
  Dico 'tetto di 250 ore di F1 : NON lo misura P0 (e il RITMO di download: lo misura il canarino P3, oggi 4,1-16,0 min/giorno = 90-348 h per il nucleo, piano par. 3.4)'
  if($Problemi.Count -gt 0){ Dico ('PASSI FALLITI: ' + $Problemi.Count); foreach($p in $Problemi){ Dico ('  - ' + $p) } }
  Dico 'Questa riga ha LETTO e basta: oltre al Desktop (cartella DUKA_P0_* e zip) non ha scritto, copiato, cancellato, chiuso o lanciato niente.'
}
catch{ [void]$Problemi.Add('sintesi: ' + (Pulisci ('' + $_.Exception.Message))) }

# =====================================================================
#  RACCOLTA SUL DESKTOP + ZIP (regola delle righe di lancio): SEMPRE, anche
#  dopo un fatale. Le variabili usate qui nascono PRIMA del try (classe 125).
# =====================================================================
try{
  Write-Host ''
  Write-Host '=== RACCOLTA ===' -ForegroundColor Cyan
  $base = Join-Path $Dsk ('DUKA_P0_' + $Stamp)
  $Cart = $base; $k = 1
  while(Test-Path -LiteralPath $Cart){ $k++; $Cart = $base + '_' + $k }
  New-Item -ItemType Directory -Path $Cart | Out-Null
  $Zip = $Cart + '.zip'
  Set-Content -LiteralPath (Join-Path $Cart 'REFERTO_DUKA_P0.txt') -Value ($R -join "`r`n") -Encoding ASCII
  Set-Content -LiteralPath (Join-Path $Cart 'P0_CACHE_PER_GIORNO.csv') -Value ($CsvCache -join "`r`n") -Encoding ASCII
  Set-Content -LiteralPath (Join-Path $Cart 'P0_CSV_TICK.csv') -Value ($CsvTick -join "`r`n") -Encoding ASCII
  Compress-Archive -Path (Join-Path $Cart '*') -DestinationPath $Zip -Force
  Add-Type -AssemblyName System.IO.Compression.FileSystem
  $zz = [IO.Compression.ZipFile]::OpenRead((Convert-Path -LiteralPath $Zip))
  $presenti = @($zz.Entries | ForEach-Object { $_.Name })
  $zz.Dispose()
  $attesi = @('REFERTO_DUKA_P0.txt', 'P0_CACHE_PER_GIORNO.csv', 'P0_CSV_TICK.csv')
  $mancanti = @($attesi | Where-Object { $presenti -notcontains $_ })
  $ZipPresenti = ($presenti -join ', ')
  $ZipMancanti = $(if($mancanti.Count -gt 0){ ($mancanti -join ', ') }else{ 'nessuno' })
  $ZipOk = ((Test-Path -LiteralPath $Zip) -and ($mancanti.Count -eq 0))
  Write-Host ('CARTELLA: ' + $Cart) -ForegroundColor Green
  Write-Host ('ZIP DA MANDARE: ' + $Zip) -ForegroundColor Green
  Write-Host ('FILE ATTESI: ' + ($attesi -join ', '))
  Write-Host ('FILE PRESENTI NELLO ZIP (letti dallo zip, non dal piano): ' + $ZipPresenti)
  Write-Host ('MANCANTI: ' + $ZipMancanti + '   (lo zip porta nel nome l ora di avvio al secondo: non puo essere quello di una corsa vecchia)')
  if(-not $ZipOk){ Write-Host 'ZIP NON VALIDO: manca qualcosa. NON mandarlo: rilancia.' -ForegroundColor Red }
}
catch{
  Write-Host ('!!! RACCOLTA FALLITA: ' + (Pulisci ('' + $_.Exception.Message))) -ForegroundColor Red
  Write-Host 'Il referto e stato comunque stampato qui sopra: copia la console intera.' -ForegroundColor Red
}

Write-Host ''
if($Fatale -ne ''){ Write-Host ('ESITO P0: FERMATO -- ' + $Fatale) -ForegroundColor Red }
elseif($Problemi.Count -gt 0){ Write-Host ('ESITO P0: CENSIMENTO PARZIALE (' + $Problemi.Count + ' passi falliti, vedi sopra)') -ForegroundColor Yellow }
else { Write-Host 'ESITO P0: CENSIMENTO COMPLETO (solo lettura). La lettura per P1 la fa chi riceve lo zip.' -ForegroundColor Green }
