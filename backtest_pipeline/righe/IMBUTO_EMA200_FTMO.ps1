# =====================================================================
#  MARCATORE_IMBUTO_EMA200_FTMO_v2
#  RUNNER_SOLA_LETTURA
#  (v2, 22/09/2026, dal cancello di giudizio: classe 562 -- il campione di
#   righe grezze era preso dal fondo di un testo concatenato AL CONTRARIO e
#   mostrava i giorni piu' VECCHI; piu' il filtro per SIMBOLO al passo 5, il
#   ripiego del referto che ora si rifiuta di scrivere dentro un terminale,
#   e gli zeri del passo 4 che adesso hanno le loro cause scritte.)
# ---------------------------------------------------------------------
#  COSA FA: conta quante volte la sedia EMA200 Dow (magic 771531) ha
#  PIAZZATO i suoi due ordini limite e quante volte quegli ordini sono
#  stati RIEMPITI invece che scaduti inevasi. Cioe' risponde a una
#  domanda sola: QUANTO SPESSO IL PREZZO CI SCHIVA.
#
#  PERCHE' ESISTE -- Claudio, 22/09/2026 ore 11:05, foto del telefono:
#     "Mi ha schivato l'ordine pendente. Come mai?"
#  Quel giorno il ritorno si e' fermato sotto il primo limite a
#  52157,36. La domanda "perche' quella volta" ha una risposta
#  aneddotica; la domanda che conta -- "quante volte su quante" -- e' un
#  NUMERO, e l'EA lo sta gia' scrivendo da solo (InpLogImbuto=true).
#  Questa riga va a prenderlo. Non lo stima.
#
#  NON SCRIVE NIENTE DENTRO NESSUNA CARTELLA DATI. Legge e stampa.
#  L'unica scrittura e' il referto sul Desktop, fuori dai terminali.
#  Non attacca EA, non tocca preset, non manda ordini, non chiude
#  processi.
#
#  >>> E QUESTO COMMENTO NON NOMINA IL VERBO CHE CHIUDE I PROCESSI, DI
#      PROPOSITO (classe 563, 22/09/2026). La riga di lancio ha un bollo
#      che RIFIUTA di eseguire questo file se ci trova dentro quel nome,
#      con Select-String -SimpleMatch: e un confronto di TESTO, non di
#      codice, e non sa distinguere un commento da una chiamata. Nella v1
#      qui c'era scritto "non c'e' una sola <quel nome> in tutto il file":
#      la frase che GIURAVA l'innocenza faceva scattare il bollo e la riga
#      si rifiutava di eseguire il proprio script. Misurato eseguendo la
#      riga intera, non lo script da solo.
#
#  >>> SI LEGGE IN CONDIVISIONE (classe 163). I log del giorno corrente
#      sono APERTI dal terminale vivo: Get-Content e ReadAllBytes
#      falliscono. Leggi-Testo apre in FileShare::ReadWrite.
#
#  >>> LA CARTELLA FTMO NON SI INDOVINA: SI CERTIFICA. Stessa scoperta
#      gia' collaudata in SCHIERA_FTMO.ps1 e PREVOLO_FTMO.ps1: si
#      elencano le cartelle dati, si ESCLUDONO per hash quelle di casa
#      (compreso il REALE 10105439), e si tiene solo quella il cui
#      GIORNALE contiene il numero di conto atteso E la parola FTMO. Se
#      nessuna certifica, la riga MUORE invece di leggere a caso.
#
#  ===================================================================
#  I LIMITI, DICHIARATI PRIMA DEI NUMERI
#  ===================================================================
#  (L1) L'IMBUTO DI OGGI NON ESISTE ANCORA. ImbutoGiro() (r.239-248 di
#       ABTG_EMA200.mq5) stampa la riga di un giorno SOLO quando il
#       giorno CAMBIA. Quindi il giorno completo piu' recente e' IERI, e
#       di oggi c'e' al massimo un "parziale" scritto da OnDeinit se
#       l'EA e' stato staccato. Chi legge la riga piu' in basso e la
#       chiama "oggi" ripete la classe 162.
#
#  (L2) DUE OROLOGI NELLA STESSA RIGA, E SONO DIVERSI. Il PREFISSO di
#       ogni riga di log e' in ORA LOCALE DEL PC (sul VPS: ora
#       italiana). Il campo "giorno AAAA.MM.GG" dentro la riga viene da
#       TimeCurrent(), cioe' ORA SERVER (FTMO = italiana +1). Non sono
#       lo stesso numero e non vanno confrontati. Qui si stampano tutti
#       e due, etichettati.
#
#  (L3) IL GIORNALE NON PORTA IL MAGIC. Su US30.cash operano TRE sedie
#       (770202 Dow Apertura, 770511 SuperWave, 771531 EMA200) e tutte e
#       tre usano ordini pendenti. Quindi le righe "expired" del
#       giornale NON sono separabili per sedia: si stampano GREZZE e
#       contate, con questo avviso attaccato. Il numero separato per
#       sedia e' quello dell'IMBUTO, che e' per-EA.
#
#  (L4) IL CSV DEL TradeExporter CONTIENE SOLO LE POSIZIONI CHIUSE
#       (ABTG_TradeExporter.mq5 r.182: salta chi non ha hasIn E hasOut).
#       Una posizione ancora APERTA non c'e'. Quindi "piazzati meno
#       aperti" SOVRASTIMA gli schivati finche' ci sono posizioni vive.
#       Il CSV si riesporta ogni 30 minuti (InpExportMinutes=30): puo'
#       essere vecchio fino a mezz'ora.
#
#  (L5) QUESTA RIGA NON DECIDE NIENTE. Non propone di cambiare
#       InpOrder1Atr ne' nessun altro parametro. Misura e stampa.
#
#  (L6) IL CSV DI Common\Files NON E' CERTIFICABILE SUL CONTO. Common\Files
#       e' CONDIVISA fra tutti gli MT5 della macchina e il file non porta
#       il numero di conto: il giornale si certifica (conto + FTMO), questo
#       no. E il magic 771531 esiste ANCHE sulla sedia BCM del piccolo
#       50503392 (simbolo U30USD). Quindi al passo 5 si filtra ANCHE per
#       SIMBOLO, che e' il solo discriminante che il file offre, e se
#       compaiono altri simboli con lo stesso magic si dice a schermo.
#
#  (L7) LE FINESTRE DEI TRE PASSI NON COINCIDONO. Passo 3 e passo 4 leggono
#       gli ultimi -Giorni file di log; il passo 5 legge TUTTO lo storico
#       esportato nel CSV, senza ritaglio di date. "PIAZZATI meno posizioni"
#       sottrae due periodi diversi se le date non si controllano: sono
#       stampate, e vanno guardate.
# =====================================================================

param(
  [string]$ContoAtteso = '541452707',
  [int]   $Giorni      = 10,
  [int]   $Magic       = 771531,
  [string]$Simbolo     = 'US30.cash'
)

$ErrorActionPreference = 'Stop'
$INV = [Globalization.CultureInfo]::InvariantCulture

# Cartelle dati DI CASA: si escludono per hash, prima di leggere.
$HASH_NOTI = @{
  '215D85D767A1C39E22D242C8114BF9F5' = '50503392  piccolo demo      (C:\Program Files\BCM Markets MT5 Terminal)'
  'BCA8AD18563BF5B64A433C2662D0A104' = '50504263  100k demo         (C:\Program Files\BCM Markets MT5 Terminal -V3)'
  'E23E1504A8D02A22179395F0652B86B6' = '10105439  *** REALE ***     (C:\BCM_Reale)'
  '04C7A32B575E40027B4FF8724D14D702' = '50504400  banco di backtest (C:\MT5_Backtest)'
  'CF6C240A869369695913FB76DA84BD22' = '50503635  manuale           (C:\MT5_MANUALE)'
  '73B7A2420D6397DFF9014A20F1201F97' = 'broker esterno Pepperstone'
  '857385E4B0F2356AD99AA95CDF40FAE9' = 'broker esterno Tickmill'
}
$NOMI_VIETATI  = @('BCM', 'Pepperstone', 'Tickmill', 'MT5_Backtest', 'MT5_MANUALE')
$CONTI_DI_CASA = @('50503392', '50504263', '10105439', '50504400', '50503635')

$RIGHE = New-Object System.Collections.ArrayList

function Dillo($testo, $colore) {
  [void]$RIGHE.Add($testo)
  if($colore){ Write-Host $testo -ForegroundColor $colore } else { Write-Host $testo }
}

# Lettura CONDIVISA: i log sono aperti dal terminale in questo istante.
function Leggi-Testo($path) {
  $b = $null
  try { $fs = [IO.File]::Open($path, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite) }
  catch { return '' }
  try {
    $b = New-Object byte[] $fs.Length
    $letti = 0
    while($letti -lt $b.Length){
      $q = $fs.Read($b, $letti, $b.Length - $letti)
      if($q -le 0){ break }
      $letti += $q
    }
  } finally { $fs.Close() }
  if($null -eq $b -or $b.Count -lt 2){ return '' }
  if($b[0] -eq 0xFF -and $b[1] -eq 0xFE){ return [Text.Encoding]::Unicode.GetString($b) }
  $zeri = 0
  $n = [math]::Min(400, $b.Count)
  for($i = 1; $i -lt $n; $i += 2){ if($b[$i] -eq 0){ $zeri++ } }
  if($zeri -gt ($n / 4)){ return [Text.Encoding]::Unicode.GetString($b) }
  return [Text.Encoding]::UTF8.GetString($b)
}

function Posa-Referto {
  try {
    # Il Desktop e' OBBLIGATORIO (regola delle righe di lancio, punto 3: ogni
    # risultato destinato a Claudio arriva SEMPRE anche sul Desktop). Ma
    # GetFolderPath puo' tornare stringa vuota: allora si ripiega, e si DICE
    # dove e' finito, invece di morire con un errore di binding.
    $dsk = [Environment]::GetFolderPath('Desktop')
    if([string]::IsNullOrWhiteSpace($dsk)){ $dsk = Join-Path $env:USERPROFILE 'Desktop' }
    if([string]::IsNullOrWhiteSpace($dsk) -or -not (Test-Path -LiteralPath $dsk)){
      $dsk = (Get-Location).Path
      Write-Host ('ATTENZIONE: Desktop non risolto. Il referto va in ' + $dsk) -ForegroundColor Yellow
    }
    # IL BOLLO "SOLA LETTURA" SI FA RISPETTARE, non si promette. Il ripiego qui sopra
    # e' l'UNICO punto in cui la destinazione non e' una costante: se la cartella di
    # lavoro fosse per caso dentro una cartella dati o dentro un terminale, la sonda
    # scriverebbe dove ha giurato di non scrivere. Allora NON scrive e lo dice.
    # Si NORMALIZZANO i separatori prima di confrontare: un percorso con '/' non
    # deve far perdere la guardia (e' la stessa classe delle grafie di INDURIMENTO,
    # dove 6 forme su 8 passavano un gate scritto sull'uguaglianza esatta).
    $dskN = ($dsk -replace '/', '\')
    $vietati = @('MetaQuotes\Terminal', 'BCM_Reale', 'BCM_RE~', 'MT5_Backtest', 'MT5_BA~',
                 'MT5_MANUALE', 'BCM Markets MT5 Terminal', '\FTMO', 'Pepperstone', 'Tickmill')
    foreach($v in $vietati){
      if($dskN -like ('*' + $v + '*')){
        Write-Host ('REFERTO NON SCRITTO: la destinazione "' + $dsk + '" e dentro "' + $v + '".') -ForegroundColor Red
        Write-Host 'Questa sonda e di SOLA LETTURA e non scrive li. Il referto e tutto a schermo qui sopra:' -ForegroundColor Red
        Write-Host 'copialo a mano, oppure rilancia da una cartella qualsiasi fuori dai terminali.' -ForegroundColor Red
        return
      }
    }
    $st  = Get-Date -Format 'yyyy-MM-dd_HHmmss'
    $car = Join-Path $dsk ('IMBUTO_EMA200_FTMO_' + $st)
    New-Item -ItemType Directory -Force -Path $car | Out-Null
    $f   = Join-Path $car ('IMBUTO_EMA200_FTMO_' + $st + '_referto.txt')
    $RIGHE | Set-Content -LiteralPath $f -Encoding UTF8
    $zip = Join-Path $dsk ('IMBUTO_EMA200_FTMO_' + $st + '.zip')
    Compress-Archive -Path (Join-Path $car '*') -DestinationPath $zip -Force
    Write-Host ''
    Write-Host ('REFERTO:  ' + $f) -ForegroundColor Green
    Write-Host ('ZIP PRONTO DA MANDARE:  ' + $zip) -ForegroundColor Green
  } catch {
    Write-Host ('referto non posato: ' + $_.Exception.Message) -ForegroundColor Yellow
  }
}

function Muori($msg) {
  Dillo '' $null
  Dillo ('FERMO: ' + $msg) 'Red'
  Posa-Referto
  exit 2
}

# =====================================================================
Dillo '=====================================================================' $null
Dillo ' IMBUTO EMA200 DOW -- QUANTO SPESSO IL PREZZO CI SCHIVA' $null
Dillo ' SONDA DI SOLA LETTURA. Non scrive in nessuna cartella dati.' $null
Dillo '=====================================================================' $null
Dillo ('lanciata il : ' + (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') + '   (ORA LOCALE del PC)') $null
Dillo ('macchina    : ' + $env:COMPUTERNAME + '   utente: ' + $env:USERNAME) $null
Dillo ('bersaglio   : conto ' + $ContoAtteso + ' (FTMO), magic ' + $Magic.ToString($INV) + ', simbolo ' + $Simbolo) $null
Dillo ('finestra    : ultimi ' + $Giorni.ToString($INV) + ' file di log') $null
Dillo '' $null
Dillo 'NON VIENE TOCCATO NIENTE: ne il REALE 10105439, ne il piccolo 50503392,' $null
Dillo 'ne il 100k 50504263, ne il banco 50504400, ne Pepperstone, ne Tickmill.' $null
Dillo 'Le loro cartelle dati vengono ESCLUSE PER HASH prima di aprire un file.' $null
Dillo '' $null

if($CONTI_DI_CASA -contains $ContoAtteso){
  Muori ('-ContoAtteso vale ' + $ContoAtteso + ', che e UN CONTO DI CASA. Questa sonda cerca il terminale FTMO.')
}

# ---------------------------------------------------------------------
# PASSO 1 -- LA SCOPERTA: si elenca e si esclude, non si indovina.
# ---------------------------------------------------------------------
$radice = Join-Path $env:APPDATA 'MetaQuotes\Terminal'
if(-not (Test-Path -LiteralPath $radice)){
  Muori ('non esiste ' + $radice + '. Nessun MT5 per questo utente (sto girando come ' + $env:USERNAME + ').')
}
$cartelle = @(Get-ChildItem -LiteralPath $radice -Directory -ErrorAction SilentlyContinue |
              Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName 'MQL5') })
Dillo ('[1/5] cartelle dati sotto ' + $radice + ': ' + $cartelle.Count.ToString($INV)) $null

$candidate = @()
foreach($d in $cartelle){
  $noto = ''
  foreach($k in $HASH_NOTI.Keys){ if($d.Name -eq $k){ $noto = $HASH_NOTI[$k] } }
  if($noto){ Dillo ('      ESCLUSA  ' + $d.Name + '  = ' + $noto) $null; continue }
  $fOrig = Join-Path $d.FullName 'origin.txt'
  $prog  = ''
  if(Test-Path -LiteralPath $fOrig){ $prog = ((Leggi-Testo $fOrig) -replace '[^\u0020-\u007E]', '').Trim() }
  $vietato = ''
  foreach($v in $NOMI_VIETATI){ if($prog -like ('*' + $v + '*')){ $vietato = $v } }
  if($vietato){ Dillo ('      ESCLUSA  ' + $d.Name + '  = "' + $prog + '" contiene "' + $vietato + '"') $null; continue }
  $candidate += [pscustomobject]@{ Hash = $d.Name; Path = $d.FullName; Prog = $prog }
  Dillo ('      candidata ' + $d.Name + '  = "' + $prog + '"') 'Cyan'
}
if($candidate.Count -eq 0){ Muori 'zero candidate: nessuna cartella dati che non sia gia di casa.' }

# ---------------------------------------------------------------------
# PASSO 2 -- LA CERTIFICAZIONE dal GIORNALE (<dati>\logs, NON MQL5\Logs)
# ---------------------------------------------------------------------
Dillo '' $null
Dillo ('[2/5] certificazione dal giornale (<dati>\logs): serve il conto ' + $ContoAtteso + ' E la parola FTMO') $null
$confermate = @()
foreach($c in $candidate){
  $dirLog = Join-Path $c.Path 'logs'
  $testo = ''; $nlog = 0
  if(Test-Path -LiteralPath $dirLog){
    # SI PRENDONO i $Giorni piu' RECENTI (Descending + First) MA SI CONCATENANO
    # IN ORDINE CRESCENTE, e non e' un dettaglio di stile (classe 562).
    # Concatenando dal piu' nuovo al piu' vecchio, il "Select-Object -Last 40" del
    # PASSO 4 mostra le 40 righe piu' VECCHIE spacciandole per le ultime. MISURATO
    # su albero finto: con 65 righe "expired" su 10 giorni, il campione conteneva
    # solo il 13-17/09 e SALTAVA il 18, 19, 20 e 21 -- cioe' proprio i giorni della
    # domanda. Il "+ newline" chiude anche la giunzione fra due file quando il
    # primo non finisce con a capo (altrimenti due righe diventano una sola).
    $files = @(Get-ChildItem -LiteralPath $dirLog -Filter *.log -ErrorAction SilentlyContinue |
               Sort-Object LastWriteTime -Descending | Select-Object -First $Giorni |
               Sort-Object LastWriteTime)
    $nlog = $files.Count
    foreach($f in $files){ $t1 = Leggi-Testo $f.FullName; if($t1 -ne ''){ $testo = $testo + $t1 + "`r`n" } }
  }
  $haConto = ($testo -match ('(?<![0-9])' + [regex]::Escape($ContoAtteso) + '(?![0-9])'))
  $haFtmo  = (($testo -match '(?i)ftmo') -or ($c.Prog -match '(?i)ftmo'))
  $c | Add-Member -NotePropertyName Giornale -NotePropertyValue $testo -Force
  $riga = '      ' + $c.Hash + '  giornali ' + $nlog.ToString($INV)
  if($haConto){ $riga = $riga + '  conto: TROVATO' } else { $riga = $riga + '  conto: non trovato' }
  if($haFtmo){  $riga = $riga + '  |  FTMO: nominato' } else { $riga = $riga + '  |  FTMO: non nominato' }
  if($haConto -and $haFtmo){ Dillo ($riga + '  -> CONFERMATA') 'Green'; $confermate += $c }
  else { Dillo ($riga + '  -> scartata') 'Yellow' }
}
if($confermate.Count -eq 0){
  Dillo '' $null
  Dillo '      Le cause possibili, in ordine, PRIMA di concludere qualcosa:' 'Yellow'
  Dillo ('      1. il terminale del conto ' + $ContoAtteso + ' non e installato per questo utente;') 'Yellow'
  Dillo '      2. e PORTABLE: i dati stanno dentro la cartella del programma (es. C:\FTMO\logs),' 'Yellow'
  Dillo '         NON sotto %APPDATA%\MetaQuotes\Terminal, e questa sonda guarda solo li;' 'Yellow'
  Dillo '      3. sto girando come un utente diverso da quello che ha avviato MT5;' 'Yellow'
  Dillo ('      4. i giornali piu recenti (' + $Giorni.ToString($INV) + ' file) non nominano il conto.') 'Yellow'
  Muori ('nessuna cartella certificata per il conto ' + $ContoAtteso + '. Non leggo a caso.')
}
if($confermate.Count -gt 1){ Muori ('DUE cartelle certificate per lo stesso conto: non scelgo io. Elencate sopra.') }
$FT = $confermate[0]
Dillo '' $null
Dillo ('      cartella dati FTMO: ' + $FT.Path) 'Green'

# ---------------------------------------------------------------------
# PASSO 3 -- L'IMBUTO (scheda Esperti: <dati>\MQL5\Logs). PER-EA.
# ---------------------------------------------------------------------
Dillo '' $null
Dillo '[3/5] IMBUTO EMA200 -- dalla scheda Esperti (<dati>\MQL5\Logs). Questa fonte e PER-EA.' $null
Dillo '      ATTENZIONE (L1): la riga di un giorno la scrive il PRIMO tick del giorno DOPO.' 'Yellow'
Dillo '      Quindi il giorno completo piu recente e IERI. Di oggi c e al massimo un "parziale".' 'Yellow'
Dillo '      ATTENZIONE (L2): il prefisso della riga e ORA LOCALE DEL PC; il campo "giorno" dentro' 'Yellow'
Dillo '      la riga e ORA SERVER (FTMO = italiana +1). Sono due orologi diversi.' 'Yellow'
Dillo '' $null

$dirExp = Join-Path $FT.Path 'MQL5\Logs'
$nImb = 0; $piazzatiTot = 0; $tentatiTot = 0; $armateTot = 0; $nRotte = 0
if(-not (Test-Path -LiteralPath $dirExp)){
  Dillo ('      MANCA ' + $dirExp + ': nessuna scheda Esperti.') 'Red'
} else {
  $fe = @(Get-ChildItem -LiteralPath $dirExp -Filter *.log -ErrorAction SilentlyContinue |
          Sort-Object Name -Descending | Select-Object -First $Giorni)
  Dillo ('      file di log letti: ' + $fe.Count.ToString($INV)) $null
  foreach($f in ($fe | Sort-Object Name)){
    $txt = Leggi-Testo $f.FullName
    if($txt -eq ''){ Dillo ('      ' + $f.Name + '  [NON LEGGIBILE]') 'Yellow'; continue }
    $hit = @($txt -split "`r?`n" | Where-Object { $_ -match '\[EMA200-IMBUTO\]' })
    Dillo ('      --- file ' + $f.Name + '  (nome file = data in ORA LOCALE) -- righe imbuto: ' + $hit.Count.ToString($INV)) 'Cyan'
    foreach($h in $hit){
      $nImb++
      Dillo ('          ' + $h.Trim()) $null
      if($h -match '\|\s*PIAZZATI\s+(\d+)'){ $piazzatiTot += [int]$Matches[1] }
      if($h -match '\|\s*ORDINI tentati\s+(\d+)'){ $tentatiTot += [int]$Matches[1] }
      if($h -match '\|\s*ARMATE\s+(\d+)'){ $armateTot += [int]$Matches[1] }
      # L'EA SI CONTROLLA DA SOLO e scrive l'esito nella riga: se la somma dei rami
      # non torna al totale, stampa "quadratura ROTTA". Se lo ignorassi, sommerei
      # numeri che l'EA stesso dichiara incoerenti e li consegnerei come misura.
      if($h -match '(?i)quadratura ROTTA'){ $nRotte++ }
    }
  }
}
Dillo '' $null
if($nImb -eq 0){
  Dillo '      ZERO righe imbuto trovate. Le cause possibili, in ordine:' 'Yellow'
  Dillo '      1. InpLogImbuto e false nel preset in campo (nel .set di repo e true);' 'Yellow'
  Dillo '      2. la sedia non e attaccata, o e attaccata ma muta (Algo Trading spento);' 'Yellow'
  Dillo '      3. il giorno non e ancora cambiato da quando e stata attaccata (L1);' 'Yellow'
  Dillo '      4. il binario in campo e piu vecchio del sorgente e non ha l imbuto.' 'Yellow'
  Dillo '      NESSUNA di queste e "non ci schiva mai": zero righe NON e un numero.' 'Red'
} else {
  Dillo ('      TOTALE sulla finestra letta:  ARMATE ' + $armateTot.ToString($INV) +
         '   ORDINI tentati ' + $tentatiTot.ToString($INV) +
         '   PIAZZATI ' + $piazzatiTot.ToString($INV)) 'Green'
  Dillo ('      righe imbuto lette: ' + $nImb.ToString($INV) + '   di cui con QUADRATURA ROTTA: ' + $nRotte.ToString($INV)) $null
  if($nRotte -gt 0){
    Dillo '      QUADRATURA ROTTA su almeno una riga: e l EA che dichiara che i suoi rami non' 'Red'
    Dillo '      sommano al totale. Finche non e spiegata, questi totali sono [NON MISURATO],' 'Red'
    Dillo '      non un numero piu basso o piu alto. Leggere le righe grezze qui sopra.' 'Red'
  }
}

# ---------------------------------------------------------------------
# PASSO 4 -- IL DESTINO DEI PENDENTI (giornale). NON separabile per sedia.
# ---------------------------------------------------------------------
Dillo '' $null
Dillo '[4/5] DESTINO DEI PENDENTI -- dal giornale (<dati>\logs).' $null
Dillo ('      AVVISO (L3): il giornale NON porta il magic. Su ' + $Simbolo + ' operano TRE sedie') 'Yellow'
Dillo '      (770202 Dow Apertura, 770511 SuperWave, 771531 EMA200) e TUTTE usano pendenti.' 'Yellow'
Dillo '      Quindi questi conteggi NON sono separabili per sedia: si leggono come totale di' 'Yellow'
Dillo '      simbolo. Il numero per-sedia e quello del PASSO 3.' 'Yellow'
Dillo '' $null
$g = $FT.Giornale
$righeSim = @($g -split "`r?`n" | Where-Object { $_ -match [regex]::Escape($Simbolo) })
$nLimit   = @($righeSim | Where-Object { $_ -match '(?i)(buy|sell)\s+limit' }).Count
$nExpired = @($righeSim | Where-Object { $_ -match '(?i)expired' }).Count
$nCancel  = @($righeSim | Where-Object { $_ -match '(?i)cancel' }).Count
$nDeal    = @($righeSim | Where-Object { $_ -match '(?i)deal\s+#' }).Count
Dillo ('      righe di giornale che nominano ' + $Simbolo + ': ' + $righeSim.Count.ToString($INV)) $null
Dillo ('        di cui "limit"   : ' + $nLimit.ToString($INV)) $null
Dillo ('        di cui "expired" : ' + $nExpired.ToString($INV) + '   <-- pendenti SCADUTI INEVASI (tutte le sedie)') 'Cyan'
Dillo ('        di cui "cancel"  : ' + $nCancel.ToString($INV)) $null
Dillo ('        di cui "deal #"  : ' + $nDeal.ToString($INV)) $null
Dillo '' $null
if($righeSim.Count -eq 0){
  Dillo '      ZERO righe di giornale nominano il simbolo. NON vuol dire "non ha mai operato":' 'Red'
  Dillo ('      su questo terminale il simbolo potrebbe chiamarsi diversamente da ' + $Simbolo) 'Red'
  Dillo '      (su BCM la stessa sedia gira su U30USD). Controllare il nome prima di concludere.' 'Red'
} elseif($nExpired -eq 0){
  Dillo '      ZERO righe "expired". NON e "non ci schiva mai": puo anche voler dire che questo' 'Red'
  Dillo '      giornale non registra la SCADENZA dei pendenti (e un evento del server, e la sua' 'Red'
  Dillo '      riga non e garantita), oppure che nella finestra letta non e scaduto niente.' 'Red'
  Dillo '      Il numero che risponde per davvero e PIAZZATI (passo 3) contro le posizioni (passo 5):' 'Red'
  Dillo '      se qui c e zero e li i due numeri non tornano, il verdetto e [NON MISURATO].' 'Red'
}
Dillo '' $null
Dillo '      righe grezze di SCADENZA/CANCELLAZIONE (le 40 piu RECENTI, cosi le leggi tu e non ti fidi di me):' $null
$grezze = @($righeSim | Where-Object { $_ -match '(?i)(expired|cancel)' } | Select-Object -Last 40)
if($grezze.Count -eq 0){ Dillo '          (nessuna)' $null }
foreach($r in $grezze){ Dillo ('          ' + $r.Trim()) $null }

# ---------------------------------------------------------------------
# PASSO 5 -- LE POSIZIONI VERE (TradeExporter, Common\Files). PER-MAGIC.
# ---------------------------------------------------------------------
Dillo '' $null
Dillo '[5/5] POSIZIONI VERE -- dal CSV del TradeExporter (Common\Files). Questa fonte e PER-MAGIC.' $null
Dillo '      AVVISO (L4): il CSV contiene SOLO le posizioni CHIUSE e si riesporta ogni 30 minuti.' 'Yellow'
Dillo '      Una posizione ancora APERTA non c e: "piazzati meno aperti" SOVRASTIMA gli schivati.' 'Yellow'
Dillo '      AVVISO (L6): Common\Files e CONDIVISA FRA TUTTI GLI MT5 DELLA MACCHINA, e questo file' 'Yellow'
Dillo ('      NON porta il numero di conto: non e certificabile come il giornale. Il magic ' + $Magic.ToString($INV)) 'Yellow'
Dillo '      e lo STESSO anche sulla sedia BCM del piccolo 50503392 (U30USD). Per questo qui si' 'Yellow'
Dillo ('      filtra ANCHE per simbolo (' + $Simbolo + '), che e il solo discriminante disponibile.') 'Yellow'
Dillo '      AVVISO (L7): il CSV NON e ritagliato sulla finestra dei log. Il passo 3 legge gli ultimi' 'Yellow'
Dillo ('      ' + $Giorni.ToString($INV) + ' file; qui c e TUTTO lo storico esportato. I due numeri si sottraggono solo se le') 'Yellow'
Dillo '      date stampate qui sotto stanno dentro quella finestra: si guardano, non si assumono.' 'Yellow'
Dillo '' $null
$csv = Join-Path $env:APPDATA 'MetaQuotes\Terminal\Common\Files\ABTG_Trades_FTMO.csv'
if(-not (Test-Path -LiteralPath $csv)){
  Dillo ('      MANCA ' + $csv) 'Yellow'
  Dillo '      Le cause, e sono TRE, non due:' 'Yellow'
  Dillo '      1. il TradeExporter non e attaccato;' 'Yellow'
  Dillo '      2. e attaccato ma non ha ancora esportato (primo giro a 30 minuti);' 'Yellow'
  Dillo '      3. e attaccato SENZA il suo preset: InpFile torna al default ABTG_Trades.csv,' 'Yellow'
  Dillo '         che su questa macchina e anche il file di BCM. Ecco cosa c e davvero:' 'Yellow'
  $dirCom = Join-Path $env:APPDATA 'MetaQuotes\Terminal\Common\Files'
  if(Test-Path -LiteralPath $dirCom){
    $altriCsv = @(Get-ChildItem -LiteralPath $dirCom -Filter 'ABTG_*.csv' -ErrorAction SilentlyContinue)
    if($altriCsv.Count -eq 0){ Dillo '         (nessun ABTG_*.csv in Common\Files)' 'Yellow' }
    foreach($a in $altriCsv){ Dillo ('         ' + $a.Name + '   ' + $a.Length.ToString($INV) + ' byte   ' + $a.LastWriteTime.ToString('yyyy-MM-dd HH:mm', $INV)) $null }
    Dillo '         NB: un ABTG_Trades.csv qui NON e certificabile come FTMO (nessun conto dentro):' 'Yellow'
    Dillo '         non lo leggo al posto del file atteso. Sarebbe leggere a caso.' 'Yellow'
  } else { Dillo ('         non esiste nemmeno ' + $dirCom) 'Yellow' }
} else {
  $eta = [math]::Round(((Get-Date) - (Get-Item -LiteralPath $csv).LastWriteTime).TotalMinutes, 1)
  Dillo ('      file: ' + $csv) $null
  Dillo ('      scritto ' + $eta.ToString($INV) + ' minuti fa (ORA LOCALE)') $null
  $testoCsv = Leggi-Testo $csv
  # Si converte IN MEMORIA: niente file temporaneo. Due ragioni, e la seconda
  # e' stata misurata in collaudo: (a) questa e' una sonda di SOLA LETTURA e
  # non deve scrivere nemmeno in TEMP; (b) con $env:TEMP non valorizzato
  # Join-Path esplode e il referto -- gia' pieno di numeri buoni -- si perde.
  try {
    $rows = @($testoCsv -split "`r?`n" | Where-Object { $_.Trim() -ne '' } | ConvertFrom-Csv -Delimiter ';')
    $soloMagic = @($rows | Where-Object { $_.magic -eq $Magic.ToString($INV) })
    $mie  = @($soloMagic | Where-Object { $_.symbol -eq $Simbolo })
    Dillo ('      posizioni CHIUSE nel CSV: totali ' + $rows.Count.ToString($INV) +
           '   con magic ' + $Magic.ToString($INV) + ': ' + $soloMagic.Count.ToString($INV) +
           '   di cui su ' + $Simbolo + ': ' + $mie.Count.ToString($INV)) 'Green'
    if($soloMagic.Count -ne $mie.Count){
      $altri = @($soloMagic | Where-Object { $_.symbol -ne $Simbolo } | ForEach-Object { $_.symbol } | Sort-Object -Unique)
      Dillo ('      ATTENZIONE: nello stesso file ci sono righe con magic ' + $Magic.ToString($INV) +
             ' su altri simboli (' + ($altri -join ', ') + ').') 'Red'
      Dillo '      Questo file NON e del solo terminale FTMO: e un CSV di Common\Files scritto da' 'Red'
      Dillo '      piu MT5. Le righe di sopra sono scartate e NON entrano in nessun conto.' 'Red'
    }
    if($mie.Count -gt 0){
      $pl = 0.0
      foreach($m in $mie){ $pl += [double]::Parse($m.profit, $INV) }
      Dillo ('      P/L di quelle posizioni: ' + $pl.ToString('0.00', $INV)) $null
      Dillo '      ultime 15:' $null
      foreach($m in ($mie | Select-Object -Last 15)){
        Dillo ('          ' + $m.open_time + '  ' + $m.side + '  vol ' + $m.volume +
               '  apertura ' + $m.open_price + '  chiusura ' + $m.close_price +
               '  P/L ' + $m.profit + '  (' + $m.close_reason + ')') $null
      }
    }
  } catch {
    Dillo ('      CSV non interpretabile: ' + $_.Exception.Message) 'Yellow'
  }
}

Dillo '' $null
Dillo '=====================================================================' $null
Dillo ' COME SI LEGGE, E COSA NON DICE' $null
Dillo '=====================================================================' $null
Dillo ' Il numero che risponde alla domanda di Claudio e:' $null
Dillo '     PIAZZATI (passo 3, per-sedia)  contro  posizioni aperte (passo 5, per-magic)' $null
Dillo ' Quello che manca alla somma sono i pendenti SCADUTI INEVASI: gli schivati.' $null
Dillo '' $null
Dillo ' MA NON SI SOTTRAE A OCCHI CHIUSI:' $null
Dillo '   - il passo 5 vede solo le posizioni CHIUSE (L4): una viva non c e;' $null
Dillo '   - il passo 4 non separa le tre sedie del simbolo (L3);' $null
Dillo '   - l imbuto di oggi non esiste ancora (L1);' $null
Dillo '   - LE DUE FINESTRE NON SONO LA STESSA (L7): il passo 3 legge gli ultimi file di' $null
Dillo '     log, il passo 5 tutto lo storico del CSV. Sottrarre due periodi diversi da' $null
Dillo '     un numero che sembra una risposta e non lo e;' $null
Dillo '   - il passo 5 non e certificato sul conto come il giornale (L6): lo e per simbolo.' $null
Dillo '' $null
Dillo ' E UNO ZERO NON E UN NUMERO, in nessuno dei tre passi: zero righe imbuto, zero' 'Red'
Dillo ' expired e zero posizioni hanno OGNUNO le loro cause, elencate sopra dove capitano.' 'Red'
Dillo ' Se le tre fonti non tornano, il verdetto e [NON MISURATO], non una media.' $null
Dillo '' $null
Dillo ' E QUESTA RIGA NON PROPONE NIENTE. Se il rapporto fosse brutto, la manopola' $null
Dillo ' che lo governa e InpOrder1Atr (oggi 0.20, default dell EA 0.10) -- ma spostarla' $null
Dillo ' e un ROUND, non una modifica in campo, e la decide Claudio.' $null
Dillo '=====================================================================' $null

Posa-Referto
exit 0
