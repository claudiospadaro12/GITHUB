# =====================================================================
#  RINOMINA_CLAU12.ps1  --  MARCATORE_RINOMINA_CLAU12_v1
#
#  COSA FA: rinomina i SETTE .mq5 delle sedie da "ABTG_..." a
#  "CLAU12_..." DENTRO LA SOLA CARTELLA DATI DEL TERMINALE FTMO, e
#  toglie di mezzo i .ex5 col nome vecchio.
#
#  PERCHE' ESISTE: richiesta di Claudio del 20/09/2026 -- "clau12 e'
#  tipo un mio nickname". Sul FTMO e BASTA: in repo e su tutti i
#  terminali di casa i file restano ABTG_, perche' i pin, gli SHA e
#  centinaia di righe di lancio li cercano con quel nome.
#
#  ---------------------------------------------------------------
#  LE CINQUE SERRATURE (le prime quattro sono copiate alla lettera da
#  SCHIERA_FTMO.ps1, che ha gia' girato due volte su questa macchina):
#    1. -ContoAtteso deve essere un numero e NON uno dei cinque conti
#       di casa;
#    2. la cartella dati si SCOPRE per esclusione delle sette note,
#       e deve avere origin.txt;
#    3. il GIORNALE (<dati>\logs) deve contenere il numero di conto
#       E la parola FTMO;
#    4. zero candidate o piu' di una -> RIFIUTO, non si indovina;
#    5. NUOVA E PROPRIA DI QUESTO SCRIPT -- ogni .mq5 viene rinominato
#       SOLO SE il suo SHA256 combacia con quello installato dallo
#       schieramento. Se un file e' diverso, non e' il nostro: si
#       lascia dov'e' e si dice.
#
#  ---------------------------------------------------------------
#  PERCHE' CANCELLA I .ex5 (e perche' NON e' distruttivo)
#  Rinominare il .mq5 NON rinomina il binario gia' compilato. Se
#  lasciassi ABTG_EMA200.ex5 sul disco, nel Navigatore di MT5
#  resterebbero DUE voci -- la vecchia compilata (attaccabile!) e la
#  nuova ancora da compilare -- e la trappola sarebbe attaccare al
#  grafico il binario vecchio credendo sia il nuovo.
#  Quindi i .ex5 col nome vecchio vanno via, MA PRIMA vengono COPIATI
#  nella cartella dei risultati sul Desktop: niente e' irrecuperabile,
#  e comunque si rigenerano con un F7.
#  CONSEGUENZA DICHIARATA: dopo questo script il Navigatore non mostra
#  nessuno dei sette finche' non si rifa' F7. E' voluto: meglio vuoto
#  che ambiguo.
#
#  ---------------------------------------------------------------
#  COSA NON TOCCA, e sono scelte, non dimenticanze:
#    - ABTG_PausaGuardian.mqh  -> e' l'INCLUDE, non un EA. Rinominarlo
#      romperebbe la riga #include di tutti e sette: F7 morirebbe con
#      "cannot open include file".
#    - ABTG_PrevoloFTMO_Specifiche.mq5 -> e' lo SCRIPT del prevolo,
#      gia' compilato e ancora DA LANCIARE. E' sulla strada critica
#      della serata: non gli si cambia il nome adesso.
#    - i .set dei preset -> restano ABTG_*.set. Su MT5 il nome del
#      preset NON deve combaciare col nome dell'EA: si carica col
#      pulsante Load e funziona uguale. Verificato che dentro i .set
#      la stringa "ABTG_" compare SOLO in righe di commento (";").
#    - i MAGIC, le TAGLIE, qualunque parametro -> mai toccati. Questo
#      script rinomina file e basta.
#
#  ---------------------------------------------------------------
#  EFFETTO COLLATERALE MISURATO (uno solo, ed e' cosmetico)
#  Sei dei sette EA costruiscono il nome dei CSV di diario cosi':
#      "abtg_trades_" + MQLInfoString(MQL_PROGRAM_NAME) + ...
#      "OptResults_"  + MQLInfoString(MQL_PROGRAM_NAME) + ...
#  Dopo la rinomina la parte centrale diventa CLAU12_*: i file si
#  chiameranno abtg_trades_CLAU12_EMA200_U30USD_771531.csv. Il
#  prefisso "abtg_trades_" e' una costante nel sorgente, quindi i
#  nostri strumenti che cercano abtg_trades_* continuano a trovarli.
#  Nessun effetto sul trading.
#
#  USO:
#    .\RINOMINA_CLAU12.ps1 -ContoAtteso 541452707              (PROVA)
#    .\RINOMINA_CLAU12.ps1 -ContoAtteso 541452707 -Esegui      (FA)
#  Senza -Esegui NON scrive niente: stampa quello che farebbe.
#
#  USCITE: 0 fatto (o prova riuscita) . 1 rifiuto . 2 gia' fatto
# =====================================================================

param(
  [Parameter(Mandatory=$true)][string]$ContoAtteso,
  [switch]$Esegui,
  [switch]$AncheSeAperto
)

$ErrorActionPreference = 'Stop'
$INV = [Globalization.CultureInfo]::InvariantCulture
$CRONO = [Diagnostics.Stopwatch]::StartNew()

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

# ---------------------------------------------------------------------
# LA TAVOLA DELLA RINOMINA. Sha = impronta del file COME INSTALLATO
# dallo schieramento (stessi numeri di SCHIERA_FTMO.ps1, tavola
# $SORGENTI). Se il file sul disco ha un altro SHA, NON si rinomina.
# ---------------------------------------------------------------------
$RINOMINE = @(
  [pscustomobject]@{ Vecchio='ABTG_DAX_Apertura_EU.mq5';                   Nuovo='CLAU12_DAX_Apertura_EU.mq5';                   Sedia='770101 DAX Apertura EU  D30EUR M5';  Righe=2425; Sha='59B67F5F912476E270C62079C80799B3E86F696AEE2F17BD158E2B4828BAD692' },
  [pscustomobject]@{ Vecchio='ABTG_MaxMinNotte_DAX_Short_Ottimizzato.mq5'; Nuovo='CLAU12_MaxMinNotte_DAX_Short_Ottimizzato.mq5'; Sedia='770411 MaxMin DAX Short  D30EUR M15'; Righe=619;  Sha='B4A56E089F001C3E9E7DA51F24CE713FA34CDCFD58A917159611038D4DF8563A' },
  [pscustomobject]@{ Vecchio='ABTG_Dow_Apertura_US.mq5';                   Nuovo='CLAU12_Dow_Apertura_US.mq5';                   Sedia='770202 Dow Apertura US   U30USD M5';  Righe=2205; Sha='0BF7A1B3466DA1A0807421B3CFAF59A0455276B2DD98CA8FBF610FEB391019B1' },
  [pscustomobject]@{ Vecchio='ABTG_EMA200.mq5';                            Nuovo='CLAU12_EMA200.mq5';                            Sedia='771531 EMA200 Dow       U30USD H1';  Righe=552;  Sha='5CA99D90A5F34E9630083C91E16A5E7F2DA48FC77EF63B138C5C2C3485BE85F4' },
  [pscustomobject]@{ Vecchio='ABTG_SuperWave_DOW_H1_Ottimizzato.mq5';      Nuovo='CLAU12_SuperWave_DOW_H1_Ottimizzato.mq5';      Sedia='770511 SuperWave DOW     U30USD H1';  Righe=645;  Sha='3C487F289023CEDC87375A6E589C7C8C43423A38151F19A8436A218F3EE7C18B' },
  [pscustomobject]@{ Vecchio='ABTG_Nasdaq_Apertura_US.mq5';                Nuovo='CLAU12_Nasdaq_Apertura_US.mq5';                Sedia='770260 Nasdaq RETEST     NASUSD M5';  Righe=2624; Sha='87BD4B187CCE6195D5F328FD833E61EF3B741FAED7FB2C7CD18AA3AE60CCB8A8' },
  [pscustomobject]@{ Vecchio='ABTG_Guardian.mq5';                          Nuovo='CLAU12_Guardian.mq5';                          Sedia='779001 Guardian v1.12   (non trada)'; Righe=498;  Sha='A457F2CDF211F312A4F6BEACC3D2B72B07B068EE2C5BC38514924693EE6B7DF8' }
)

# File che NON si toccano, elencati PER NOME (mai "tutto il resto").
$INTOCCABILI = @(
  'ABTG_PausaGuardian.mqh          -- INCLUDE: rinominarlo rompe #include in tutti e sette',
  'ABTG_PrevoloFTMO_Specifiche.mq5 -- SCRIPT del prevolo, ancora da lanciare',
  'ABTG_*.set                      -- i preset si caricano col pulsante Load, il nome non deve combaciare'
)

$STAMPA  = (Get-Date).ToString('yyyy-MM-dd_HHmmss', $INV)
$CARTREF = Join-Path ([Environment]::GetFolderPath('Desktop')) ('RINOMINA_CLAU12_' + $STAMPA)
$RIGHE_REFERTO = New-Object System.Collections.ArrayList

function Dillo($testo, $colore) {
  if($colore){ Write-Host $testo -ForegroundColor $colore } else { Write-Host $testo }
  [void]$RIGHE_REFERTO.Add($testo)
}

function Leggi-Testo($path) {
  $b = $null
  try {
    $fs = [IO.File]::Open($path, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
    try { $b = New-Object byte[] $fs.Length; [void]$fs.Read($b, 0, $b.Length) } finally { $fs.Close() }
  } catch { return '' }
  if($b -eq $null){ return '' }
  return [Text.Encoding]::UTF8.GetString($b)
}

function Sha-Di($path) {
  try { return (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash.ToUpperInvariant() } catch { return '' }
}

function Posa-Referto {
  try {
    if(-not (Test-Path -LiteralPath $CARTREF)){ [void](New-Item -ItemType Directory -Path $CARTREF -Force) }
    $f = Join-Path $CARTREF ('RINOMINA_CLAU12_' + $STAMPA + '_referto.txt')
    [IO.File]::WriteAllText($f, ($RIGHE_REFERTO -join "`r`n"), [Text.Encoding]::UTF8)
    return $f
  } catch { return '' }
}

function Muori($msg) {
  Dillo '' $null
  Dillo '=====================================================================' 'Red'
  Dillo ('FERMO: ' + $msg) 'Red'
  Dillo 'NESSUN FILE E STATO RINOMINATO NE CANCELLATO.' 'Red'
  Dillo '=====================================================================' 'Red'
  $f = Posa-Referto
  if($f){ Write-Host ('referto di questo rifiuto: ' + $f) -ForegroundColor Yellow }
  exit 1
}

Dillo '=====================================================================' 'Cyan'
Dillo ' RINOMINA ABTG_ -> CLAU12_  (solo terminale FTMO)' 'Cyan'
Dillo '=====================================================================' 'Cyan'
Dillo (' conto atteso : ' + $ContoAtteso) $null
Dillo (' ora          : ' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss', $INV)) $null
if($Esegui){ Dillo ' MODO         : ESEGUI (rinomina davvero)' 'Yellow' }
else       { Dillo ' MODO         : PROVA A VUOTO (non scrive niente). Aggiungi -Esegui per farlo davvero.' 'Green' }
Dillo '' $null

# =====================================================================
# SERRATURA 1 -- il numero di conto
# =====================================================================
if($ContoAtteso -notmatch '^[0-9]{6,12}$'){
  Muori ('-ContoAtteso vale "' + $ContoAtteso + '", che non e un numero di conto (servono 6-12 cifre).')
}
foreach($c in $CONTI_DI_CASA){
  if($ContoAtteso -eq $c){
    Muori ('-ContoAtteso vale ' + $ContoAtteso + ', che e UN CONTO DI CASA (BCM), non FTMO. Se avessi accettato, avrei rinominato i file di un terminale che non si tocca.')
  }
}
Dillo ('[0/6] -ContoAtteso ' + $ContoAtteso + ' accettato: e un numero, e NON e nessuno dei cinque conti di casa.') 'Green'

# =====================================================================
# SERRATURA 2 -- LA SCOPERTA per esclusione
# =====================================================================
$radice = Join-Path $env:APPDATA 'MetaQuotes\Terminal'
if(-not (Test-Path -LiteralPath $radice)){
  Muori ('non esiste ' + $radice + '. Questa riga sta girando sull utente sbagliato, oppure su una macchina senza MT5.')
}
$cartelle = @(Get-ChildItem -LiteralPath $radice -Directory -ErrorAction SilentlyContinue |
              Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName 'MQL5') })
Dillo ('[1/6] cartelle dati sotto ' + $radice + ': ' + $cartelle.Count.ToString($INV)) $null

$candidate = @()
foreach($d in $cartelle){
  $nome = $d.Name
  $noto = ''
  foreach($k in $HASH_NOTI.Keys){ if($nome -eq $k){ $noto = $HASH_NOTI[$k] } }
  if($noto){ Dillo ('      ESCLUSA  ' + $nome + '  = ' + $noto) $null; continue }

  $fOrig = Join-Path $d.FullName 'origin.txt'
  if(-not (Test-Path -LiteralPath $fOrig)){
    Dillo ('      ESCLUSA  ' + $nome + '  = manca origin.txt: senza certificato non si tocca.') 'Yellow'; continue
  }
  $prog = ((Leggi-Testo $fOrig) -replace '[^\u0020-\u007E]', '').Trim()

  $vietato = ''
  foreach($v in $NOMI_VIETATI){ if($prog -like ('*' + $v + '*')){ $vietato = $v } }
  if($vietato){
    Dillo ('      ESCLUSA  ' + $nome + '  = "' + $prog + '" contiene "' + $vietato + '": e una cartella di casa.') $null; continue
  }
  $candidate += [pscustomobject]@{ Hash = $nome; Path = $d.FullName; Prog = $prog }
  Dillo ('      candidata ' + $nome + '  = "' + $prog + '"') 'Cyan'
}
if($candidate.Count -eq 0){ Muori 'zero candidate: nessuna cartella dati che non sia gia di casa.' }

# =====================================================================
# SERRATURA 3 e 4 -- la certificazione dal giornale, e una sola
# =====================================================================
Dillo ('[2/6] certificazione dal giornale (<dati>\logs), candidate: ' + $candidate.Count.ToString($INV)) $null
$confermate = @()
foreach($c in $candidate){
  $dirLog = Join-Path $c.Path 'logs'
  $testo = ''
  $nlog = 0
  if(Test-Path -LiteralPath $dirLog){
    $files = @(Get-ChildItem -LiteralPath $dirLog -Filter *.log -ErrorAction SilentlyContinue |
               Sort-Object LastWriteTime -Descending | Select-Object -First 10)
    $nlog = $files.Count
    foreach($f in $files){ $testo = $testo + (Leggi-Testo $f.FullName) }
  }
  $haConto = ($testo -match ('(?<![0-9])' + [regex]::Escape($ContoAtteso) + '(?![0-9])'))
  $haFtmo  = (($testo -match '(?i)ftmo') -or ($c.Prog -match '(?i)ftmo'))
  $riga = '      ' + $c.Hash + '  giornali ' + $nlog.ToString($INV)
  if($haConto){ $riga = $riga + '  conto ' + $ContoAtteso + ': TROVATO' } else { $riga = $riga + '  conto ' + $ContoAtteso + ': non trovato' }
  if($haFtmo){  $riga = $riga + '  |  FTMO: nominato' }             else { $riga = $riga + '  |  FTMO: non nominato' }
  if($haConto -and $haFtmo){ Dillo ($riga + '  -> CONFERMATA') 'Green'; $confermate += $c }
  else { Dillo ($riga + '  -> scartata') 'Yellow' }
}
if($confermate.Count -eq 0){
  Muori ('nessuna delle ' + $candidate.Count.ToString($INV) + ' candidate porta nel giornale il conto ' + $ContoAtteso + ' insieme al nome FTMO.')
}
if($confermate.Count -gt 1){
  foreach($c in $confermate){ Dillo ('      ' + $c.Hash + '  ' + $c.Prog) 'Red' }
  Muori ('CONFERMATE ' + $confermate.Count.ToString($INV) + ' cartelle diverse: non si indovina su un conto che costa soldi veri.')
}

$dati = $confermate[0].Path
$prog = $confermate[0].Prog
$dirE = Join-Path $dati 'MQL5\Experts'
Dillo '' $null
Dillo ('[2/6] BERSAGLIO CERTIFICATO -- conto ' + $ContoAtteso) 'Green'
Dillo ('      programma     : ' + $prog) 'Green'
Dillo ('      cartella dati : ' + $dati) 'Green'
Dillo ('      si tocca SOLO : ' + $dirE) 'Green'
Dillo ('      le altre ' + ($cartelle.Count - 1).ToString($INV) + ' cartelle dati non vengono nemmeno riaperte.') 'Green'
if(-not (Test-Path -LiteralPath $dirE)){ Muori ('non esiste ' + $dirE + ': lo schieramento non e mai arrivato qui.') }

# =====================================================================
# [3/6] -- IL TERMINALE E' APERTO? Rinominare e cancellare binari sotto
#          un terminale vivo e' il modo piu' facile per ritrovarsi un
#          EA staccato a meta'. Si chiede di chiuderlo: costa 30 s.
# =====================================================================
$aperto = $false
try {
  $pr = @(Get-Process terminal64 -ErrorAction SilentlyContinue)
  foreach($p in $pr){
    $pp = ''
    try { $pp = $p.Path } catch { $pp = '' }
    if($pp -and $prog -and ($pp -eq $prog)){ $aperto = $true }
  }
} catch { }
if($aperto){
  Dillo ('[3/6] il terminale FTMO ' + $ContoAtteso + ' risulta APERTO (' + $prog + ').') 'Yellow'
  if(-not $AncheSeAperto){
    Dillo '' $null
    Dillo '      CHIUDILO e rilancia questa riga. Sono 30 secondi, e tolgono di mezzo' 'Yellow'
    Dillo '      il caso peggiore: MetaEditor che tiene aperto un .mq5 mentre lo rinomino,' 'Yellow'
    Dillo '      o un EA attaccato a un grafico che si ritrova il binario sparito sotto.' 'Yellow'
    Dillo '      Se sai gia che non c e nessun EA attaccato e MetaEditor e chiuso,' 'Yellow'
    Dillo '      puoi forzare con  -AncheSeAperto .' 'Yellow'
    Muori 'terminale FTMO aperto. Chiudilo (o usa -AncheSeAperto).'
  }
  Dillo '      -AncheSeAperto: proseguo lo stesso, come richiesto.' 'Yellow'
} else {
  Dillo '[3/6] il terminale FTMO risulta CHIUSO: e la condizione buona.' 'Green'
}

# =====================================================================
# [4/6] -- SERRATURA 5: lo SHA di ogni file, uno per uno.
# =====================================================================
Dillo '' $null
Dillo '[4/6] controllo dei sette file (SHA256 contro l impronta installata)' $null
$daFare   = @()
$giaFatti = 0
$problemi = @()
foreach($r in $RINOMINE){
  $pV = Join-Path $dirE $r.Vecchio
  $pN = Join-Path $dirE $r.Nuovo
  $cV = Test-Path -LiteralPath $pV
  $cN = Test-Path -LiteralPath $pN

  if($cN -and -not $cV){
    Dillo ('      GIA FATTO  ' + $r.Nuovo) 'Green'
    $giaFatti = $giaFatti + 1
    continue
  }
  if($cN -and $cV){
    $problemi += ('ESISTONO TUTTI E DUE: ' + $r.Vecchio + ' e ' + $r.Nuovo + '. Non scelgo io quale sopravvive.')
    Dillo ('      DOPPIONE   ' + $r.Vecchio + '  +  ' + $r.Nuovo + '  -> lo salto') 'Red'
    continue
  }
  if(-not $cV){
    $problemi += ('MANCA: ' + $r.Vecchio + ' non e in ' + $dirE)
    Dillo ('      MANCA      ' + $r.Vecchio) 'Red'
    continue
  }

  $sha = Sha-Di $pV
  if($sha -ne $r.Sha){
    $problemi += ('SHA DIVERSO: ' + $r.Vecchio + ' -- atteso ' + $r.Sha.Substring(0,16) + '... trovato ' + $(if($sha){$sha.Substring(0,16)+'...'}else{'(illeggibile)'}) + '. Non e il file che abbiamo installato: NON lo rinomino.')
    Dillo ('      SHA DIVERSO ' + $r.Vecchio + '  -> lo salto') 'Red'
    continue
  }
  Dillo ('      ok         ' + $r.Vecchio + '  ->  ' + $r.Nuovo + '   (' + $r.Sedia + ')') 'Cyan'
  $daFare += $r
}

if($problemi.Count -gt 0){
  Dillo '' $null
  Dillo '      PROBLEMI TROVATI:' 'Red'
  foreach($p in $problemi){ Dillo ('        - ' + $p) 'Red' }
  Muori ('' + $problemi.Count.ToString($INV) + ' file su ' + $RINOMINE.Count.ToString($INV) + ' non sono nello stato atteso. Non rinomino NIENTE finche non e chiaro perche: una rinomina a meta e peggio di nessuna rinomina.')
}

if($daFare.Count -eq 0 -and $giaFatti -eq $RINOMINE.Count){
  Dillo '' $null
  Dillo ('GIA FATTO: tutti e ' + $giaFatti.ToString($INV) + ' i file sono gia CLAU12_. Non c e niente da fare.') 'Green'
  $f = Posa-Referto
  if($f){ Write-Host ('referto: ' + $f) -ForegroundColor Green }
  exit 2
}

# =====================================================================
# [5/6] -- L'AZIONE. Copia di sicurezza dei .ex5, poi rinomina.
# =====================================================================
Dillo '' $null
if(-not $Esegui){
  Dillo '[5/6] PROVA A VUOTO: ecco cosa farei, e mi fermo qui.' 'Green'
  foreach($r in $daFare){
    Dillo ('      rinomina  ' + $r.Vecchio + '  ->  ' + $r.Nuovo) $null
    $pX = Join-Path $dirE ([IO.Path]::GetFileNameWithoutExtension($r.Vecchio) + '.ex5')
    if(Test-Path -LiteralPath $pX){ Dillo ('      salva+togli ' + [IO.Path]::GetFileName($pX) + '  (binario vecchio)') $null }
  }
  Dillo '' $null
  Dillo '      NON HO SCRITTO NIENTE. Per farlo davvero rilancia con  -Esegui .' 'Green'
  $f = Posa-Referto
  if($f){ Write-Host ('referto: ' + $f) -ForegroundColor Green }
  exit 0
}

if(-not (Test-Path -LiteralPath $CARTREF)){ [void](New-Item -ItemType Directory -Path $CARTREF -Force) }
$backup = Join-Path $CARTREF 'ex5_vecchi'
[void](New-Item -ItemType Directory -Path $backup -Force)

Dillo '[5/6] eseguo.' 'Yellow'
$fatti = 0
foreach($r in $daFare){
  $pV = Join-Path $dirE $r.Vecchio
  $pX = Join-Path $dirE ([IO.Path]::GetFileNameWithoutExtension($r.Vecchio) + '.ex5')

  if(Test-Path -LiteralPath $pX){
    Copy-Item -LiteralPath $pX -Destination $backup -Force
    Remove-Item -LiteralPath $pX -Force
    Dillo ('      binario vecchio salvato e tolto: ' + [IO.Path]::GetFileName($pX)) $null
  } else {
    Dillo ('      nessun .ex5 per ' + $r.Vecchio + ' (non era compilato)') $null
  }

  Rename-Item -LiteralPath $pV -NewName $r.Nuovo -Force
  Dillo ('      RINOMINATO ' + $r.Vecchio + '  ->  ' + $r.Nuovo) 'Green'
  $fatti = $fatti + 1
}

# =====================================================================
# [6/6] -- LA CONTROPROVA: si rilegge il disco, non la memoria.
# =====================================================================
Dillo '' $null
Dillo '[6/6] controprova -- rileggo la cartella dal disco' $null
$male = 0
foreach($r in $RINOMINE){
  $pN = Join-Path $dirE $r.Nuovo
  $pV = Join-Path $dirE $r.Vecchio
  $okN = Test-Path -LiteralPath $pN
  $okV = Test-Path -LiteralPath $pV
  if($okN -and -not $okV){
    $sha = Sha-Di $pN
    if($sha -eq $r.Sha){ Dillo ('      OK  ' + $r.Nuovo + '  SHA invariato (il contenuto non e stato toccato)') 'Green' }
    else { Dillo ('      ATTENZIONE ' + $r.Nuovo + '  SHA CAMBIATO') 'Red'; $male = $male + 1 }
  } else {
    Dillo ('      ATTENZIONE ' + $r.Nuovo + '  nuovo:' + $okN.ToString() + ' vecchio:' + $okV.ToString()) 'Red'
    $male = $male + 1
  }
}

Dillo '' $null
Dillo '---------------------------------------------------------------------' 'Cyan'
Dillo (' RINOMINATI: ' + $fatti.ToString($INV) + '   gia fatti prima: ' + $giaFatti.ToString($INV) + '   problemi in controprova: ' + $male.ToString($INV)) 'Cyan'
Dillo (' durata: ' + $CRONO.Elapsed.TotalSeconds.ToString('0.0', $INV) + ' s') 'Cyan'
Dillo '---------------------------------------------------------------------' 'Cyan'
Dillo '' $null
Dillo ' NON TOCCATI, e sono scelte:' 'Yellow'
foreach($i in $INTOCCABILI){ Dillo ('   - ' + $i) 'Yellow' }
Dillo '' $null
Dillo ' ADESSO SERVE RIFARE F7, ed e la parte importante:' 'Yellow'
Dillo '   i .ex5 col nome vecchio sono stati tolti, quindi in questo momento' 'Yellow'
Dillo '   nel Navigatore di MT5 NON compare nessuna delle sette sedie.' 'Yellow'
Dillo '   E voluto: meglio un Navigatore vuoto che uno ambiguo.' 'Yellow'
Dillo '   1. riapri il terminale FTMO e il suo MetaEditor' 'Yellow'
Dillo '   2. F7 su CLAU12_Guardian.mq5 per primo (e il primo che usa l include)' 'Yellow'
Dillo '   3. F7 sugli altri sei' 'Yellow'
Dillo '   4. i preset si caricano col pulsante Load: restano ABTG_*.set, va bene cosi' 'Yellow'
Dillo '' $null
Dillo ' ATTENZIONE PER IL FUTURO:' 'Yellow'
Dillo '   se un giorno rilanci SCHIERA_FTMO.ps1, quello rimette i file col nome' 'Yellow'
Dillo '   ABTG_ accanto ai CLAU12_, e ti ritrovi i doppioni. Rilancia questa riga' 'Yellow'
Dillo '   subito dopo, e torna tutto a posto.' 'Yellow'

$f = Posa-Referto
if($f){ Write-Host ('referto: ' + $f) -ForegroundColor Green }
try {
  $zip = Join-Path ([Environment]::GetFolderPath('Desktop')) ('RINOMINA_CLAU12_' + $STAMPA + '.zip')
  Compress-Archive -Path (Join-Path $CARTREF '*') -DestinationPath $zip -Force
  Write-Host ('zip pronto da mandare: ' + $zip) -ForegroundColor Green
} catch { Write-Host 'zip non creato (non e grave: il referto e nella cartella).' -ForegroundColor Yellow }

if($male -gt 0){ exit 1 }
exit 0
