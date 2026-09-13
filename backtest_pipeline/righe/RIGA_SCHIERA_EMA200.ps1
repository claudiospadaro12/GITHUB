# =====================================================================
#  MARCATORE_SCHIERA_EMA200_v1
#
#  SCHIERAMENTO DI ABTG_EMA200 su U30USD H1, magic 771531.
#  Ricompila la sedia con il Guardian, partendo dal SORGENTE PINNATO
#  al commit 26a1856 -- che e' ESATTAMENTE quello misurato a R112
#  (PF OOS 1,52365, DD OOS 7,8323%, 30/30 PASS a walk-forward tick).
#
#  ATTENZIONE, ed e' la ragione per cui questo script esiste:
#  NON si compila HEAD. Fra il commit misurato e HEAD c'e' b45dd00,
#  che nel suo messaggio dice "IN CORSO D'OPERA -- NON COMPILARE",
#  non e' mai passato dal cancello e non e' mai stato compilato da
#  nessuno. Qui il sorgente si scarica appuntato al commit e se ne
#  verifica lo SHA256 PRIMA di compilare: se l'impronta non torna,
#  lo script si ferma e non tocca niente.
#
#  NIENTE EMOJI IN QUESTO FILE: Windows PowerShell 5.1 legge i .ps1
#  come ANSI e un'emoji dentro una stringa rompe il parser.
#
#  PASSI (uno per lancio, in quest'ordine):
#    -Passo backup     salva ex5 + mq5 + mqh + profili sul Desktop
#    -Passo compila    scarica pinnato, verifica impronte, compila
#    -Passo raccolta   log + impronte sul Desktop, piu' lo zip
#    -Passo ritorno    rimette i file salvati da -Passo backup
#    -Passo profili    rimette i .chr salvati (TERMINALE CHIUSO)
#
#  QUELLO CHE NON FA, dichiarato:
#    - NON apre e NON chiude nessun terminale MetaTrader;
#    - NON attacca e NON stacca nessun EA da nessun grafico;
#    - NON carica nessun preset e NON cambia nessuna taglia;
#    - NON misura niente: qui non gira nessun backtest.
# =====================================================================
param(
  [ValidateSet('backup','compila','raccolta','ritorno','profili')]
  [string]$Passo = 'backup',
  [string]$Pin   = '',
  [string]$Backup = ''
)

$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#  Il commit del SORGENTE dell'EA: e' la versione MISURATA a R112.
#  Non e' un branch e non e' HEAD: e' un commit, e non si cambia.
$PIN_EA    = '26a185661c120de6fa0a33b79279595740e264e8'
$PIN_RESTO = '077afd0671d1634d6232631b0c05214a43089cb6'
$BASE      = 'https://raw.githubusercontent.com/claudiospadaro12/GITHUB'

# =====================================================================
#  IL BERSAGLIO SI SCEGLIE DA origin.txt, NON A OCCHIO.
#  Ogni cartella dati di MT5 contiene un origin.txt con la cartella
#  programma che la possiede: e' il legame DETERMINISTICO fra le sei
#  cartelle dati del VPS e i terminali. Se le candidate non sono
#  esattamente UNA, lo script MUORE: non si tira a indovinare, perche'
#  qui si scrive dentro la cartella di un conto in forward.
#  Il conto reale e' fuori perimetro: il selettore e' POSITIVO (accetta
#  solo cio' che corrisponde), quindi non puo' raggiungerlo.
# =====================================================================
function Trova-CartellaDati {
  $radice = Join-Path $env:APPDATA 'MetaQuotes\Terminal'
  if(-not (Test-Path $radice)){ throw "VIETATO proseguire: non trovo la radice delle cartelle dati di MetaTrader." }
  $cand = @(Get-ChildItem $radice -Directory -ErrorAction SilentlyContinue | Where-Object {
      $o = Join-Path $_.FullName 'origin.txt'
      if(-not (Test-Path $o)){ return $false }
      $t = (Get-Content $o -Raw -ErrorAction SilentlyContinue)
      if($null -eq $t){ return $false }
      $t = $t.Trim()
      ($t -like '*BCM Markets MT5 Terminal*') -and ($t -notlike '*-V3*')
    })
  if($cand.Count -eq 0){ throw "VIETATO proseguire: nessuna cartella dati corrisponde al terminale bersaglio (quello SENZA -V3). Mi fermo." }
  if($cand.Count -gt 1){ throw ("VIETATO proseguire: trovate " + $cand.Count + " cartelle dati che corrispondono. Ambiguo: mi fermo senza toccare niente.") }
  return $cand[0].FullName
}

function Scrivi-Titolo($t){
  Write-Host ""
  Write-Host ("==== " + $t + " ====") -ForegroundColor Cyan
}

$D = Trova-CartellaDati
$prog = (Get-Content (Join-Path $D 'origin.txt') -Raw).Trim()
Scrivi-Titolo ("PASSO: " + $Passo)
Write-Host ("CARTELLA PROGRAMMA : " + $prog)
Write-Host ("CARTELLA DATI      : " + $D)
Write-Host  "NON tocco nessun altro profilo dati, nessun altro terminale, nessun grafico."

$EX5 = Join-Path $D 'MQL5\Experts\ABTG_EMA200.ex5'
$MQ5 = Join-Path $D 'MQL5\Experts\ABTG_EMA200.mq5'
$MQH = Join-Path $D 'MQL5\Include\ABTG_PausaGuardian.mqh'
$SET = Join-Path $D 'MQL5\Presets\ABTG_EMA200_U30USD_H1_771531_VIVA.set'
$Desktop = [Environment]::GetFolderPath('Desktop')

# =====================================================================
#  PASSO BACKUP -- la rete del ritorno indietro.
#  Legge dalla cartella dati e scrive SOLO sul Desktop.
# =====================================================================
if($Passo -eq 'backup'){
  $bk = Join-Path $Desktop ("BACKUP_EMA200_" + (Get-Date -Format 'yyyyMMdd_HHmmss'))
  New-Item -ItemType Directory -Path $bk -Force | Out-Null
  foreach($f in @($EX5,$MQ5,$MQH)){
    if(Test-Path $f){
      Copy-Item $f (Join-Path $bk (Split-Path $f -Leaf)) -Force
      $i = Get-Item $f
      Write-Host ("  SALVATO  " + (Split-Path $f -Leaf) + "   " + $i.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss') + "   " + $i.Length + " byte") -ForegroundColor Green
    } else {
      Write-Host ("  ASSENTE  " + (Split-Path $f -Leaf) + "   (annotato: al ritorno NON va inventato)") -ForegroundColor DarkYellow
    }
  }
  $prof = Join-Path $D 'MQL5\Profiles\Charts'
  if(Test-Path $prof){
    Copy-Item $prof (Join-Path $bk 'Profiles_Charts') -Recurse -Force
    Write-Host "  SALVATO  Profiles\Charts  (i parametri salvati dei grafici: e' il ritorno ESATTO)" -ForegroundColor Green
  }
  $D | Out-File (Join-Path $bk 'CARTELLA_DATI.txt') -Encoding ASCII
  Get-ChildItem $bk -Recurse -File | Get-FileHash -Algorithm SHA256 |
    Select-Object Hash, Path | Format-Table -AutoSize |
    Out-File (Join-Path $bk 'IMPRONTE_BACKUP.txt') -Encoding ASCII
  Scrivi-Titolo "BACKUP FATTO"
  Write-Host ("ANNOTA QUESTO PERCORSO, serve al ritorno indietro:") -ForegroundColor Yellow
  Write-Host ("   " + $bk) -ForegroundColor Yellow
  exit 0
}

# =====================================================================
#  PASSO COMPILA
#  1. MetaEditor NON deve girare: e' single-instance, e con una copia
#     gia' aperta /compile torna SUBITO senza aver compilato. Senza
#     questo controllo si dichiarerebbe un successo falso (checklist 39).
#  2. Tre file scaricati APPUNTATI A UN COMMIT e verificati per SHA256.
#  3. Verdetto su TRE segnali: log, data dell'ex5, dimensione dell'ex5.
# =====================================================================
if($Passo -eq 'compila'){
  if(Get-Process metaeditor64 -ErrorAction SilentlyContinue){
    throw "VIETATO proseguire: METAEDITOR E' APERTO. E' single-instance: il nostro /compile tornerebbe subito senza compilare e io dichiarerei un successo FALSO. Chiudilo e rilancia."
  }
  $me = Join-Path $prog 'metaeditor64.exe'
  if(-not (Test-Path $me)){ throw ("VIETATO proseguire: non trovo metaeditor64.exe in " + $prog) }

  $tmp = Join-Path $env:TEMP ("ema200_" + (Get-Date -Format 'yyyyMMdd_HHmmss'))
  New-Item -ItemType Directory -Path $tmp -Force | Out-Null

  $att = @(
    @{ n='ABTG_EMA200.mq5'; u=($BASE + '/' + $PIN_EA + '/mql5/Experts/ABTG_EMA200.mq5');
       lf='29cb8955dd11215c60cdbb11879c909780d049bb740783e6d62dbddbf698c202';
       cr='85d7c6be02bcf62bb89f2bc5ba23fe7a4dd0599c35faa1c3b83a1136716213b3';
       dest=(Join-Path $D 'MQL5\Experts') },
    @{ n='ABTG_PausaGuardian.mqh'; u=($BASE + '/' + $PIN_RESTO + '/mql5/Include/ABTG_PausaGuardian.mqh');
       lf='3ec971152e85e0082488cc4243ff45ae09948c191d52ab96050b48f94641a737';
       cr='932d05789c33fc543f1cb1242578ebfbbcece74c121702774ca7c340c84cb595';
       dest=(Join-Path $D 'MQL5\Include') },
    @{ n='ABTG_EMA200_U30USD_H1_771531_VIVA.set'; u=($BASE + '/' + $PIN_RESTO + '/mql5/Presets/ABTG_EMA200_U30USD_H1_771531_VIVA.set');
       lf='206cc0a6700779ffc33bf0474e34351c162291e2f543c076c272785b14eb4e7f';
       cr='d77ed5c7354e58932ce295c3421447bb7bb66d850b6a5632625e2793b6ea02ae';
       dest=(Join-Path $D 'MQL5\Presets') }
  )

  Scrivi-Titolo "SCARICO E VERIFICO LE IMPRONTE (prima di toccare qualunque cosa)"
  foreach($a in $att){
    $p = Join-Path $tmp $a.n
    Invoke-RestMethod $a.u -OutFile $p
    $h = (Get-FileHash $p -Algorithm SHA256).Hash.ToLower()
    $forma = ''
    if($h -eq $a.lf){ $forma = 'LF' }
    elseif($h -eq $a.cr){ $forma = 'CRLF' }
    else { throw ("VIETATO proseguire: IMPRONTA SBAGLIATA su " + $a.n + ". Trovata " + $h + ". NON e' il file appuntato al commit: mi fermo e non compilo niente. Manda questa riga al socio.") }
    Write-Host ("  OK  " + $a.n + "   SHA256 verificato (forma " + $forma + ")") -ForegroundColor Green
  }

  Scrivi-Titolo "INSTALLO I SORGENTI VERIFICATI"
  foreach($a in $att){
    if(-not (Test-Path $a.dest)){ New-Item -ItemType Directory -Path $a.dest -Force | Out-Null }
    Copy-Item (Join-Path $tmp $a.n) (Join-Path $a.dest $a.n) -Force
    Write-Host ("  INSTALLATO  " + $a.n)
  }
  Write-Host "  (il preset e' solo COPIATO su disco: NON viene caricato. Caricarlo e' un click di Claudio.)" -ForegroundColor DarkYellow

  $primaData = $null
  if(Test-Path $EX5){
    $i = Get-Item $EX5
    $primaData = $i.LastWriteTime
    Write-Host ("  ex5 PRIMA : " + $primaData.ToString('yyyy-MM-dd HH:mm:ss') + "   " + $i.Length + " byte")
  } else { Write-Host "  ex5 PRIMA : non presente" }

  Scrivi-Titolo "COMPILO"
  $log = Join-Path $tmp 'compila.log'
  #  NB: la variabile NON si chiama $args -- quello e' un nome AUTOMATICO di
  #  PowerShell (gli argomenti non dichiarati dello script) e riusarlo e' un
  #  modo elegante di prendersi un difetto che il parser non segnala.
  $argomenti = @(('/compile:"' + $MQ5 + '"'), ('/inc:"' + $D + '\MQL5"'), ('/log:"' + $log + '"'))
  $pr = Start-Process -FilePath $me -ArgumentList $argomenti -Wait -PassThru -WindowStyle Hidden
  Write-Host ("  codice di uscita di MetaEditor: " + $pr.ExitCode)

  $testo = ''
  if(Test-Path $log){
    $testo = Get-Content $log -Encoding Unicode -Raw -ErrorAction SilentlyContinue
    if([string]::IsNullOrWhiteSpace($testo)){ $testo = Get-Content $log -Raw -ErrorAction SilentlyContinue }
  }
  Write-Host "---- LOG DELLA COMPILAZIONE ----" -ForegroundColor DarkCyan
  Write-Host $testo
  Write-Host "--------------------------------" -ForegroundColor DarkCyan

  $nerr = -1
  if($testo -match '(\d+)\s+error'){ $nerr = [int]$Matches[1] }

  if(-not (Test-Path $EX5)){ throw "VIETATO dichiarare fatto: NESSUN .ex5 PRODOTTO. La compilazione e' fallita: leggi il log qui sopra." }
  $i = Get-Item $EX5
  Write-Host ("  ex5 DOPO  : " + $i.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss') + "   " + $i.Length + " byte")
  if(($null -ne $primaData) -and ($i.LastWriteTime -le $primaData)){
    throw "VIETATO dichiarare fatto: l'ex5 NON e' stato riscritto (data invariata). E' il sintomo tipico di MetaEditor gia' aperto. Chiudilo e rilancia."
  }
  if($nerr -gt 0){ throw ("VIETATO proseguire: COMPILAZIONE CON " + $nerr + " ERRORI. Non attaccare niente: vai al paragrafo del RITORNO INDIETRO.") }

  Scrivi-Titolo "PROVA IN PIU' -- NON E' IL VERDETTO"
  $b = [IO.File]::ReadAllBytes($EX5)
  $s1 = [Text.Encoding]::ASCII.GetString($b)
  $s2 = [Text.Encoding]::Unicode.GetString($b)
  if(($s1 -like '*InpUsaGuardian*') -or ($s2 -like '*InpUsaGuardian*')){
    Write-Host "  la stringa InpUsaGuardian SI LEGGE dentro l'ex5." -ForegroundColor Green
  } else {
    Write-Host "  la stringa InpUsaGuardian NON si legge nei byte dell'ex5." -ForegroundColor DarkYellow
    Write-Host "  ATTENZIONE: NON vuol dire che manchi. L'ex5 e' compresso, quindi" -ForegroundColor DarkYellow
    Write-Host "  l'ASSENZA NON PROVA NIENTE. La prova vera e' la scheda Input." -ForegroundColor DarkYellow
  }
  Scrivi-Titolo "COMPILAZIONE OK"
  Write-Host "Ora tocca a te: attacca l'EA e controlla la scheda Input." -ForegroundColor Green
  Write-Host ("sorgenti scaricati e log: " + $tmp)
  exit 0
}

# =====================================================================
#  PASSO RACCOLTA -- i risultati arrivano SEMPRE anche sul Desktop del
#  VPS, piu' lo zip pronto da mandare (regola di casa dell'11/08).
# =====================================================================
if($Passo -eq 'raccolta'){
  $out = Join-Path $Desktop ("PACCHETTO_EMA200_" + (Get-Date -Format 'yyyyMMdd_HHmmss'))
  New-Item -ItemType Directory -Path $out -Force | Out-Null
  $oggi = Get-Date -Format 'yyyyMMdd'
  foreach($sub in @('MQL5\Logs','Logs')){
    $f = Join-Path $D ($sub + '\' + $oggi + '.log')
    if(Test-Path $f){ Copy-Item $f (Join-Path $out ((Split-Path $sub -Leaf) + '_' + $oggi + '.log')) -Force }
  }
  $righe = @()
  $righe += ("cartella dati : " + $D)
  if(Test-Path $EX5){
    $i = Get-Item $EX5
    $righe += ("ex5 data      : " + $i.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss'))
    $righe += ("ex5 byte      : " + $i.Length)
    $righe += ("ex5 sha256    : " + (Get-FileHash $EX5 -Algorithm SHA256).Hash)
  } else { $righe += "ex5           : ASSENTE (la compilazione non e' andata)" }
  if(Test-Path $MQ5){
    $righe += ("mq5 sha256    : " + (Get-FileHash $MQ5 -Algorithm SHA256).Hash)
    $righe +=  "mq5 ATTESO    : 29CB8955DD11215C60CDBB11879C909780D049BB740783E6D62DBDDBF698C202"
    $righe +=  "                (commit 26a1856, forma LF -- la versione MISURATA a R112)"
  }
  if(Test-Path $SET){ $righe += ("preset sha256 : " + (Get-FileHash $SET -Algorithm SHA256).Hash) }
  $righe | Out-File (Join-Path $out 'IMPRONTE_DOPO.txt') -Encoding ASCII
  Get-ChildItem $D -Filter 'ABTG_EMA200*' -Recurse -File -ErrorAction SilentlyContinue |
    Select-Object FullName, LastWriteTime, Length | Format-Table -AutoSize |
    Out-File (Join-Path $out 'FILE_EMA200.txt') -Encoding ASCII
  $zip = $out + '.zip'
  Compress-Archive -Path (Join-Path $out '*') -DestinationPath $zip -Force
  Scrivi-Titolo "RACCOLTA FATTA -- controlla a occhio che ci siano questi file"
  Get-ChildItem $out -File | Select-Object Name, Length | Format-Table -AutoSize
  Write-Host "ATTESI: IMPRONTE_DOPO.txt, FILE_EMA200.txt, almeno un *_AAAAMMGG.log" -ForegroundColor Yellow
  Write-Host ("CARTELLA : " + $out) -ForegroundColor Green
  Write-Host ("ZIP      : " + $zip) -ForegroundColor Green
  exit 0
}

# =====================================================================
#  PASSO RITORNO -- rimette i file salvati da -Passo backup.
#  PRIMA di lanciarlo l'EA va staccato dal grafico a mano: finche' e'
#  attaccato MetaTrader tiene aperto l'ex5 e la copia puo' fallire.
# =====================================================================
if($Passo -eq 'ritorno'){
  if([string]::IsNullOrWhiteSpace($Backup)){ throw "VIETATO proseguire: manca -Backup con il percorso stampato dal passo backup." }
  if(-not (Test-Path $Backup)){ throw ("VIETATO proseguire: cartella di backup non trovata: " + $Backup) }
  $segnato = Join-Path $Backup 'CARTELLA_DATI.txt'
  if(Test-Path $segnato){
    $vecchia = (Get-Content $segnato -Raw).Trim()
    if($vecchia -ne $D){ throw ("VIETATO proseguire: il backup era stato preso da '" + $vecchia + "' ma adesso il bersaglio e' '" + $D + "'. Non rimetto file di un terminale dentro un altro.") }
  }
  $coppie = @(
    @{ src=(Join-Path $Backup 'ABTG_EMA200.ex5');        dst=$EX5 },
    @{ src=(Join-Path $Backup 'ABTG_EMA200.mq5');        dst=$MQ5 },
    @{ src=(Join-Path $Backup 'ABTG_PausaGuardian.mqh'); dst=$MQH }
  )
  foreach($c in $coppie){
    if(Test-Path $c.src){
      Copy-Item $c.src $c.dst -Force
      Write-Host ("  RIMESSO   " + (Split-Path $c.dst -Leaf)) -ForegroundColor Green
    } else {
      Write-Host ("  NON C'ERA nel backup: " + (Split-Path $c.src -Leaf) + " -> lo lascio com'e', non lo invento.") -ForegroundColor DarkYellow
    }
  }
  if(Test-Path $EX5){
    $i = Get-Item $EX5
    Write-Host ("  ex5 ORA : " + $i.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss') + "   " + $i.Length + " byte")
    Write-Host ("  sha256  : " + (Get-FileHash $EX5 -Algorithm SHA256).Hash)
  }
  Scrivi-Titolo "RITORNO FATTO SUI FILE"
  Write-Host "Adesso riattacca l'EA a mano. I PARAMETRI non li tocca questo script:" -ForegroundColor Yellow
  Write-Host "vanno rimessi da te (tabella del paragrafo 6.3 del pacchetto)." -ForegroundColor Yellow
  exit 0
}

# =====================================================================
#  PASSO PROFILI -- il ritorno ESATTO anche dei PARAMETRI del grafico.
#  I parametri di un EA attaccato stanno nei .chr di MQL5\Profiles\Charts,
#  che MetaTrader legge all'AVVIO e riscrive alla CHIUSURA. Rimetterli
#  mentre il terminale gira non serve a niente: verrebbero sovrascritti.
#  Percio' qui si PRETENDE il terminale chiuso, e lo si verifica invece
#  di darlo per fatto.
#  ATTENZIONE, va detto e non nascosto: chiudere quel terminale ferma il
#  forward di TUTTI gli EA che ci girano, non solo di questa sedia. E'
#  una decisione di Claudio, non un passaggio automatico.
# =====================================================================
if($Passo -eq 'profili'){
  if([string]::IsNullOrWhiteSpace($Backup)){ throw "VIETATO proseguire: manca -Backup con il percorso stampato dal passo backup." }
  $srcP = Join-Path $Backup 'Profiles_Charts'
  if(-not (Test-Path $srcP)){ throw "VIETATO proseguire: nel backup non c'e' Profiles_Charts. Usa il solo -Passo ritorno e rimetti i parametri a mano." }
  $vivo = @(Get-Process terminal64 -ErrorAction SilentlyContinue | Where-Object { $_.Path -like ($prog + '*') })
  if($vivo.Count -gt 0){
    throw ("VIETATO proseguire: il terminale bersaglio risulta ANCORA APERTO (PID " + (($vivo | ForEach-Object { $_.Id }) -join ', ') + "). Chiudilo a mano, altrimenti alla chiusura riscrive lui i .chr sopra i miei.")
  }
  $dstP = Join-Path $D 'MQL5\Profiles\Charts'
  if(-not (Test-Path $dstP)){ New-Item -ItemType Directory -Path $dstP -Force | Out-Null }
  Copy-Item (Join-Path $srcP '*') $dstP -Recurse -Force
  Scrivi-Titolo "PROFILI RIMESSI"
  Write-Host "Riapri il terminale bersaglio: i grafici tornano come li avevi." -ForegroundColor Green
  exit 0
}
