# ==========================================================================
#  MARCATORE_RIGA_SALVA_BROKER_ESTERNI_v1
#  (contenuto v1.1 -- il MARCATORE resta identico a posta: se lo si bumpa a
#   _v2 va bumpata ANCHE la riga di lancio che lo controlla, altrimenti il
#   cancello del marcatore fallisce sul VPS.)
#
#  SALVATAGGIO PRIMA DELLA DISINSTALLAZIONE -- Pepperstone + Tickmill
#  Richiesta di Claudio (12/09/2026): "ORA PROVO A DISINSTALLARE PEPPERSTON
#  E TICKMILL SE ESISTONO REALMENTE COSI NON ABBIAMO + PROBLEMI. OK?"
#
#  PERCHE' SERVE: sul terminale Tickmill esiste BREAKOUT_EA_JPY_v3.mq5
#  (v3.00, 1016 righe) che NEL REPO NON C'E' (il repo ha solo la v2.30 e la
#  Multi v2.40). Disinstallare senza salvare = perdere quel sorgente per
#  sempre. Misurato il 12/09 dai log di CODA_01 / CODA_06.
#
#  COSA FA: SOLO LETTURA sui due terminali esterni. Copia FUORI, sul Desktop,
#  i sorgenti .mq5/.mqh, gli .ex5 rimasti orfani (senza il .mq5 gemello nella
#  STESSA cartella), i preset .set e i grafici .chr; stampa le sedie
#  agganciate lette dai .chr; scrive un referto e fa lo zip.
#
#  COSA NON FA: non scrive NIENTE dentro i due terminali, non li apre, non li
#  chiude, non tocca nessun processo. E RIFIUTA le cartelle dati dei quattro
#  terminali BCM (50503392 / 50504263 / 10105439 / 50504400) con DUE prove
#  INDIPENDENTI: il nome del percorso E la presenza di bases\*BCM* (il feed).
#
#  CODICI D'USCITA -- dichiarati, perche' "diverso da zero" e' una lettura
#  troppo grossa (classe 219):
#    0 = salvataggio COMPLETO, oppure -SoloControllo andato a buon fine
#    1 = nessuno dei due terminali e' installato (niente da salvare)
#    2 = PARZIALE: almeno un terminale installato non e' stato salvato
#    3 = INTERROTTO da un errore -- MA referto e zip sono stati scritti
#  In OGNI caso esiste una cartella sul Desktop con il referto dentro.
#
#  NIENTE EMOJI: questo file e' ASCII puro (PS 5.1 legge i .ps1 come ANSI).
# ==========================================================================

param(
  [string]$Pin = '',
  [switch]$SoloControllo
)

$ErrorActionPreference = 'Stop'
$INV = [System.Globalization.CultureInfo]::InvariantCulture
$t0  = Get-Date

# ---- i due bersagli, per NOME (mai "tutto cio' che non e' BCM") -----------
$BERSAGLI = @(
  'C:\Program Files\Pepperstone MetaTrader 5',
  'C:\Program Files\Tickmill Europe MT5 Terminal'
)

# ---- cio' che NON si tocca mai, per NOME ---------------------------------
$VIETATI = @('BCM Markets MT5 Terminal', 'BCM_Reale', 'MT5_Backtest', '-V3')

# ---- ATTESA DICHIARATA PRIMA DEI NUMERI: le due cartelle dati misurate il
#      12/09 dai log di CODA_01/CODA_06. Se la cartella risolta ha un altro
#      id NON si blocca (l'id puo' cambiare legittimamente): si DICE.
$IDATTESI = @('73B7A242', '857385E4')

$Desktop = [Environment]::GetFolderPath('Desktop')
$stamp   = $t0.ToString('yyyyMMdd_HHmmss', $INV)
$cart    = Join-Path $Desktop ('SALVA_BROKER_ESTERNI_' + $stamp)
$refPath = Join-Path $cart 'RIGA_REFERTO_SALVA_BROKER.txt'
$righe   = New-Object System.Collections.Generic.List[string]
$nonCop  = New-Object System.Collections.Generic.List[string]

function Nota([string]$s, [string]$col = 'Gray') {
  Write-Host $s -ForegroundColor $col
  $righe.Add($s) | Out-Null
}

function Referto() {
  if (-not (Test-Path -LiteralPath $cart)) { return }
  Set-Content -LiteralPath $refPath -Value $righe -Encoding ASCII
}

# --- COPIA PROTETTA: un singolo file bloccato (terminale acceso, percorso
#     oltre i 260 caratteri, permessi) NON deve uccidere la corsa e portarsi
#     via referto e zip (classe 249). Ma non si tace nemmeno: cio' che non
#     e' stato copiato finisce in un elenco che va nel referto, perche' un
#     file creduto salvato e poi disinstallato e' una perdita definitiva.
function Copia([string]$da, [string]$a) {
  try {
    $dir = Split-Path $a -Parent
    if (-not (Test-Path -LiteralPath $dir)) {
      New-Item -ItemType Directory -Force -Path $dir | Out-Null
    }
    Copy-Item -LiteralPath $da -Destination $a -Force -ErrorAction Stop
    return $true
  } catch {
    $nonCop.Add($da + '   NON COPIATO: ' + $_.Exception.Message) | Out-Null
    return $false
  }
}

# --- LETTURA CONDIVISA di un file di testo del terminale. Riusata VERBATIM
#     da CODA_01/CODA_06/CODA_08 (nota del verificatore, 19/08): un .chr
#     tenuto aperto da MT5 non deve far morire il censimento, e i .chr sono
#     UTF-16 (con o senza BOM) tanto quanto UTF-8. Get-Content -Raw qui
#     sbaglia due volte: muore sul lock e legge male il senza-BOM.
function Leggi-Condiviso($path) {
  $b = $null
  try {
    $fs = [IO.File]::Open($path, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
    $b  = New-Object byte[] $fs.Length
    [void]$fs.Read($b, 0, $b.Length)
    $fs.Close()
  } catch { return '' }
  if ($null -eq $b -or $b.Count -lt 2) { return '' }
  if ($b[0] -eq 0xFF -and $b[1] -eq 0xFE) { return [Text.Encoding]::Unicode.GetString($b) }
  $zeri = 0; $n = [math]::Min(400, $b.Count)
  for ($i = 1; $i -lt $n; $i += 2) { if ($b[$i] -eq 0) { $zeri++ } }
  if ($zeri -gt ($n / 4)) { return [Text.Encoding]::Unicode.GetString($b) }
  return [Text.Encoding]::UTF8.GetString($b)
}

# --- un campo di un .chr: si resta sulla RIGA. "\s" comprende l'a-capo, e
#     con \s*=\s* un campo VUOTO restituisce il valore della riga DOPO
#     (classe 236, pagata l'11/09 su CODA_08).
function Campo($txt, $chiave) {
  $m = [regex]::Match($txt, '(?im)^[ \t]*' + [regex]::Escape($chiave) + '[ \t]*=[ \t]*(.*?)[ \t]*$')
  if ($m.Success -and $m.Groups[1].Value.Trim().Length -gt 0) { return $m.Groups[1].Value.Trim() }
  return '-'
}

# --- il TF di un grafico si legge da period_type + period_size, NON da un
#     campo "period" (che nei .chr non esiste): difetto D3 di CODA_01 v1.
function TF($tipo, $size) {
  $inv = [Globalization.CultureInfo]::InvariantCulture
  $st  = [Globalization.NumberStyles]::Integer
  $t = 0; $s = 0
  if (-not [int]::TryParse([string]$tipo, $st, $inv, [ref]$t)) { return '?' }
  if (-not [int]::TryParse([string]$size, $st, $inv, [ref]$s)) { return '?' }
  switch ($t) {
    0 { if ($s -eq 0) { return 'M?' }; return ('M' + $s) }
    1 { return ('H' + $s) }
    2 { return ('D' + $s) }
    3 { return ('W' + $s) }
    4 { return ('MN' + $s) }
    default { return ('t' + $tipo + 's' + $s) }
  }
}

function NormalizzaPercorso([string]$x) {
  if ([string]::IsNullOrWhiteSpace($x)) { return '' }
  return ($x.Trim() -replace '/', '\').TrimEnd('\').ToLowerInvariant()
}

New-Item -ItemType Directory -Force -Path $cart | Out-Null

$trovati = 0
$salvati = 0
$totMq5  = 0
$Fatale  = ''

try {

  Nota '======================================================================'
  Nota '  SALVATAGGIO BROKER ESTERNI -- SOLA LETTURA sui terminali'
  Nota ('  data:   ' + $t0.ToString('yyyy-MM-dd HH:mm:ss', $INV))
  Nota ('  pin:    ' + $(if ($Pin) { $Pin } else { '[non dichiarato]' }))
  Nota ('  modo:   ' + $(if ($SoloControllo) { 'SOLO CONTROLLO (non copio niente)' } else { 'SALVATAGGIO' }))
  Nota ('  attesa: cartelle dati con id che inizia per ' + ($IDATTESI -join ' oppure '))
  Nota '======================================================================'

  # ---- la macchina, in sola lettura: chi e' acceso adesso -----------------
  #      Si leggono PID e percorso di TUTTI i terminal64, BCM compresi: e'
  #      la regola di casa dei tre terminali (il riconoscimento e' un fatto
  #      stampato, non un'inferenza). Leggere la lista dei processi NON e'
  #      leggere dentro un terminale, e non ne tocca nessuno.
  Nota ''
  Nota '--- TERMINALI ACCESI ADESSO (sola lettura, non ne tocco nessuno) ---' 'Cyan'
  $proc = @(Get-Process terminal64 -ErrorAction SilentlyContinue)
  if ($proc.Count -eq 0) {
    Nota '    nessun terminale MT5 acceso'
  } else {
    foreach ($prc in $proc) {
      $pth = ''
      try { $pth = $prc.Path } catch { $pth = '[percorso non leggibile]' }
      Nota ('    PID ' + $prc.Id + '   ' + $pth)
    }
    Nota '    (restano tutti accesi: questa riga non chiude niente)' 'Green'
  }

  $root = Join-Path $env:APPDATA 'MetaQuotes\Terminal'

  foreach ($p in $BERSAGLI) {

    Nota ''
    Nota ('=== ' + $p) 'Cyan'

    if (-not (Test-Path -LiteralPath $p -PathType Container)) {
      Nota '    NON INSTALLATO su questa macchina: niente da salvare.' 'Yellow'
      continue
    }
    $trovati++

    # --- cancello 1: il bersaglio non deve essere un terminale BCM --------
    $brutto = $false
    foreach ($v in $VIETATI) { if ($p -like ('*' + $v + '*')) { $brutto = $true } }
    if ($brutto) {
      Nota '    RIFIUTO: questo percorso somiglia a un terminale BCM. NON TOCCO.' 'Red'
      continue
    }

    # --- la cartella dati si RISOLVE da origin.txt, non si indovina -------
    #     confronto NORMALIZZATO (slash, backslash finale, maiuscole): un
    #     origin.txt con la barra finale non deve far dire "non installato"
    #     proprio il giorno in cui il sorgente sta per essere disinstallato.
    $pNorm = NormalizzaPercorso $p
    $cands = @()
    $dati  = @()
    if (Test-Path -LiteralPath $root) {
      foreach ($dc in @(Get-ChildItem -LiteralPath $root -Directory -ErrorAction SilentlyContinue)) {
        $o = Join-Path $dc.FullName 'origin.txt'
        if (-not (Test-Path -LiteralPath $o)) { continue }
        $oTxt = (Leggi-Condiviso $o) -replace '[^\x20-\x7E]', ''
        $cands += ($dc.Name + '  ->  ' + $oTxt.Trim())
        if ((NormalizzaPercorso $oTxt) -eq $pNorm) { $dati += $dc.FullName }
      }
    } else {
      Nota ('    ATTENZIONE: non esiste ' + $root) 'Yellow'
    }

    $d   = ''
    $via = ''
    if ($dati.Count -eq 1) {
      $d = $dati[0]; $via = 'origin.txt (1 corrispondenza esatta)'
    } elseif ($dati.Count -eq 0 -and (Test-Path -LiteralPath (Join-Path $p 'MQL5'))) {
      # ripiego DICHIARATO, non un indovinello: in modo portable la cartella
      # dati sta DENTRO la cartella programma. Resta sola lettura.
      $d = $p; $via = 'PORTABLE (MQL5 dentro la cartella programma, nessun origin.txt)'
    } else {
      Nota ('    cartella dati: ' + $dati.Count + ' corrispondenze in origin.txt e nessun MQL5 dentro la cartella programma -- NON SALVO DA QUI.') 'Red'
      Nota '    ecco TUTTE le cartelle dati viste, con il loro origin.txt: si risolve a mano, non a indovinare.' 'Red'
      if ($cands.Count -eq 0) { Nota '      (nessuna cartella dati con origin.txt)' 'Red' }
      foreach ($c in $cands) { Nota ('      ' + $c) }
      continue
    }

    # --- cancello 2: DUE PROVE INDIPENDENTI che non e' un BCM ------------
    #     (a) il nome scritto in origin.txt. ATTENZIONE: e' la stessa
    #         stringa su cui si e' fatto match, quindi da sola puo' solo
    #         dire si': serve, ma non e' una verifica (classe 255).
    #     (b) bases\*BCM* = il FEED del broker. Questo NON dipende da
    #         origin.txt: e' il fatto forte usato da RIGA_ALLINEALONDRA.
    $orig = '[nessun origin.txt: portable]'
    $oFile = Join-Path $d 'origin.txt'
    if (Test-Path -LiteralPath $oFile) {
      $orig = ((Leggi-Condiviso $oFile) -replace '[^\x20-\x7E]', '').Trim()
    }
    $brutto2 = $false
    foreach ($v in $VIETATI) { if ($orig -like ('*' + $v + '*')) { $brutto2 = $true } }
    if ($brutto2) {
      Nota ('    RIFIUTO (prova a): origin.txt dice ' + $orig + ' -- e'' un BCM. NON TOCCO.') 'Red'
      continue
    }
    $basi = @(Get-ChildItem -LiteralPath (Join-Path $d 'bases') -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -like '*BCM*' })
    if ($basi.Count -gt 0) {
      Nota ('    RIFIUTO (prova b): questa cartella dati ha bases\' + $basi[0].Name + ', cioe'' il feed BCM. NON TOCCO.') 'Red'
      continue
    }

    Nota ('    cartella dati: ' + $d)
    Nota ('    via:           ' + $via)
    Nota ('    origin.txt:    ' + $orig)
    Nota ('    bases\*BCM*:   nessuna (prova b superata)')
    $idOk = $false
    foreach ($idAtt in $IDATTESI) { if ((Split-Path $d -Leaf) -like ($idAtt + '*')) { $idOk = $true } }
    if ($idOk) {
      Nota '    id cartella:   CORRISPONDE all''attesa dichiarata sopra' 'Green'
    } else {
      Nota '    id cartella:   NON corrisponde ai due id misurati il 12/09 -- non blocca, ma va letto' 'Yellow'
    }

    if ($SoloControllo) {
      Nota '    SOLO CONTROLLO: mi fermo qui, non copio niente.' 'Yellow'
      continue
    }

    $nome = (Split-Path $p -Leaf) -replace '[^A-Za-z0-9]', '_'
    $dst  = Join-Path $cart $nome
    New-Item -ItemType Directory -Force -Path $dst | Out-Null

    # --- i sorgenti, con la struttura di cartelle conservata -------------
    foreach ($sub in @('Experts', 'Indicators', 'Include', 'Scripts', 'Libraries')) {
      $src = Join-Path $d ('MQL5\' + $sub)
      if (-not (Test-Path -LiteralPath $src)) {
        Nota ('    ' + $sub + ': la cartella non esiste (' + $src + ')') 'Yellow'
        continue
      }
      $f = @(Get-ChildItem -LiteralPath $src -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $_.Extension -in @('.mq5', '.mqh') })
      $ok = 0
      foreach ($x in $f) {
        $rel = $x.FullName.Substring($src.Length).TrimStart('\')
        $out = Join-Path (Join-Path $dst $sub) $rel
        if (Copia $x.FullName $out) { $ok++ }
      }
      Nota ('    ' + $sub + ': trovati ' + $f.Count + ' sorgenti, SALVATI ' + $ok) $(if ($ok -eq $f.Count) { 'Green' } else { 'Red' })
      $totMq5 += $ok
    }

    # --- gli .ex5 ORFANI: un EA senza sorgente, se lo perdi, e' perso ----
    #     ORFANO = non esiste il .mq5 con lo stesso nome NELLA STESSA
    #     CARTELLA (MetaEditor compila in loco). Un .mqh omonimo o un .mq5
    #     in un'ALTRA cartella non sono il sorgente di questo .ex5: il repo
    #     ha il caso misurato dei due alberi con lo stesso nome e programmi
    #     diversi (CODA_06: ABTG_PostNews 666 righe contro 307).
    $orfani = 0
    $orfSalv = 0
    foreach ($sub in @('Experts', 'Indicators', 'Scripts', 'Libraries')) {
      $src = Join-Path $d ('MQL5\' + $sub)
      if (-not (Test-Path -LiteralPath $src)) { continue }
      $e = @(Get-ChildItem -LiteralPath $src -Recurse -File -Filter '*.ex5' -ErrorAction SilentlyContinue)
      foreach ($x in $e) {
        if (Test-Path -LiteralPath (Join-Path $x.DirectoryName ($x.BaseName + '.mq5'))) { continue }
        $orfani++
        $rel = $x.FullName.Substring($src.Length).TrimStart('\')
        $out = Join-Path (Join-Path (Join-Path $dst 'EX5_SENZA_SORGENTE') $sub) $rel
        if (Copia $x.FullName $out) { $orfSalv++ }
      }
    }
    if ($orfani -gt 0) {
      Nota ('    EX5 SENZA SORGENTE: trovati ' + $orfani + ', SALVATI ' + $orfSalv) $(if ($orfSalv -eq $orfani) { 'Yellow' } else { 'Red' })
    } else {
      Nota '    EX5 SENZA SORGENTE: nessuno (ogni .ex5 ha il suo .mq5 accanto)'
    }

    # --- i preset: sono i PARAMETRI, valgono quanto il codice ------------
    $ps = Join-Path $d 'MQL5\Presets'
    if (Test-Path -LiteralPath $ps) {
      $s = @(Get-ChildItem -LiteralPath $ps -Recurse -File -Filter '*.set' -ErrorAction SilentlyContinue)
      $ok = 0
      foreach ($x in $s) {
        $rel = $x.FullName.Substring($ps.Length).TrimStart('\')
        $out = Join-Path (Join-Path $dst 'Presets') $rel
        if (Copia $x.FullName $out) { $ok++ }
      }
      Nota ('    Presets: trovati ' + $s.Count + ' file .set, SALVATI ' + $ok) $(if ($ok -eq $s.Count) { 'Green' } else { 'Red' })
    } else {
      Nota ('    Presets: la cartella non esiste (' + $ps + ')') 'Yellow'
    }

    # --- i grafici, e le SEDIE che ci stanno sopra -----------------------
    #     MT5 = <dati>\MQL5\Profiles\Charts (classe 222: profiles\charts
    #     minuscolo e' MT4 e da' uno ZERO senza errore).
    $cartChr = Join-Path $d 'MQL5\Profiles\Charts'
    if (-not (Test-Path -LiteralPath $cartChr)) {
      Nota ('    grafici: la cartella dei profili NON ESISTE -- cercata in ' + $cartChr) 'Yellow'
      Nota '    (quindi NON so dire se ci sono sedie: non e'' uno zero, e'' un non misurato)' 'Yellow'
    } else {
      $ch = @(Get-ChildItem -LiteralPath $cartChr -Recurse -File -Filter '*.chr' -ErrorAction SilentlyContinue)
      $ok = 0
      foreach ($x in $ch) {
        $rel = $x.FullName.Substring($cartChr.Length).TrimStart('\')
        $out = Join-Path (Join-Path $dst 'Profili') $rel
        if (Copia $x.FullName $out) { $ok++ }
      }
      Nota ('    grafici: trovati ' + $ch.Count + ' file .chr, SALVATI ' + $ok) $(if ($ok -eq $ch.Count) { 'Green' } else { 'Red' })

      Nota '    --- SEDIE ATTACCATE (lette dai .chr, sola lettura) ---' 'Cyan'
      $sedie = 0
      $illeg = 0
      $noExp = 0
      foreach ($x in $ch) {
        # NB: $rel qui va RICALCOLATO. Riusare il $rel del ciclo di copia
        # qui sopra stamperebbe su ogni sedia il nome dell'ULTIMO file
        # copiato: e' la classe del contatore che sopravvive al suo ciclo.
        $relC = $x.FullName.Substring($cartChr.Length).TrimStart('\')
        $t = Leggi-Condiviso $x.FullName
        if (-not $t) { $illeg++; continue }
        if ($t -notmatch '<expert>') { $noExp++; continue }
        # simbolo e periodo stanno nel blocco del GRAFICO, FUORI da
        # <expert>: si leggono dal file intero (come CODA_01/CODA_08).
        $sy = Campo $t 'symbol'
        $pe = TF (Campo $t 'period_type') (Campo $t 'period_size')
        $m = [regex]::Match($t, '(?s)<expert>(.*?)</expert>')
        while ($m.Success) {
          $blocco = $m.Groups[1].Value
          # il NOME e il MAGIC invece stanno DENTRO il blocco: se li si
          # cercasse nel file intero si prenderebbe 'Main' (la finestra
          # del grafico, difetto D1 di CODA_01) o il magic di un altro.
          $nm = Campo $blocco 'name'
          if ($nm -eq '-') {
            $mp = [regex]::Match($blocco, '(?i)path[ \t]*=[ \t]*Experts\\(.+?)\.ex5')
            if ($mp.Success) { $nm = [IO.Path]::GetFileNameWithoutExtension($mp.Groups[1].Value) }
          }
          if ($nm -ne '-' -and -not ($nm -ieq 'Main')) {
            # ATTENZIONE al \r: i .chr hanno fine riga CRLF e in .NET "$"
            # in modo multilinea si piazza PRIMA del \n, quindi il \r resta
            # da consumare. Con "[ \t]*$" questo match FALLISCE su ogni
            # riga di un file CRLF: misurato su un .chr di prova il
            # 12/09/2026. Il \r va messo nella classe.
            $mg = [regex]::Match($blocco, '(?mi)^[ \t]*[A-Za-z_]*Magic[A-Za-z_]*[ \t]*=[ \t]*([0-9]+)[ \t\r]*$')
            $ma = '-'
            if ($mg.Success) { $ma = $mg.Groups[1].Value }
            Nota ('      ' + $nm + '   ' + $sy + '   ' + $pe + '   magic ' + $ma + '   [' + $relC + ']') 'White'
            $sedie++
          }
          $m = $m.NextMatch()
        }
      }
      # uno ZERO non e' una prova finche' non si dice dove si e' guardato
      # e quanti file non si sono potuti leggere (lezione di CODA_08).
      Nota ('      sedie lette: ' + $sedie + '   su ' + $ch.Count + ' file .chr (illeggibili ' + $illeg + ', senza blocco <expert> ' + $noExp + ')')
      if ($sedie -eq 0 -and $illeg -gt 0) {
        Nota '      ATTENZIONE: ZERO sedie MA ci sono .chr illeggibili: questo NON e'' "nessuna sedia".' 'Red'
      }
      if ($sedie -eq 0 -and $illeg -eq 0) {
        Nota '      nessuna sedia agganciata su questo terminale (tutti i .chr letti)' 'Yellow'
      }
      Nota '      (limite dichiarato: i .chr sono la foto all''ultimo SALVATAGGIO del profilo, non lo stato vivo)'
    }

    $salvati++
  }

} catch {
  $Fatale = $_.Exception.Message
  Nota ''
  Nota ('INTERROTTO DA UN ERRORE: ' + $Fatale) 'Red'
  Nota 'La raccolta qui sotto parte comunque: quello che e'' stato copiato si vede.' 'Yellow'
}

# ---- la raccolta: elenco file, referto, zip ------------------------------
Nota ''
Nota '--- QUELLO CHE C''E'' NELLA CARTELLA ---' 'Cyan'
$tuttiFile = @(Get-ChildItem -LiteralPath $cart -Recurse -File -ErrorAction SilentlyContinue)
foreach ($g in ($tuttiFile | Group-Object DirectoryName | Sort-Object Name)) {
  Nota ('    ' + $g.Count.ToString().PadLeft(4) + ' file  in  ' + $g.Name)
}
Nota ('    TOTALE: ' + $tuttiFile.Count + ' file, di cui ' + $totMq5 + ' sorgenti salvati')

if ($nonCop.Count -gt 0) {
  Nota ''
  Nota ('--- FILE NON COPIATI: ' + $nonCop.Count + ' (questi NON sono al sicuro: NON disinstallare finche'' non si risolvono) ---') 'Red'
  foreach ($r in $nonCop) { Nota ('    ' + $r) 'Red' }
}

$esito = 'COMPLETO'
if ($Fatale -ne '')            { $esito = 'INTERROTTO: ' + $Fatale }
elseif ($SoloControllo)        { $esito = 'SOLO CONTROLLO' }
elseif ($trovati -eq 0)        { $esito = 'NIENTE DA SALVARE: nessuno dei due terminali e'' installato' }
elseif ($salvati -lt $trovati) { $esito = 'PARZIALE: ' + $salvati + ' salvati su ' + $trovati + ' installati' }
elseif ($nonCop.Count -gt 0)   { $esito = 'PARZIALE: ' + $nonCop.Count + ' file non copiati' }

Nota ''
Nota ('terminali installati trovati: ' + $trovati + ' su ' + $BERSAGLI.Count)
Nota ('terminali salvati:            ' + $salvati)
Nota ('file non copiati:             ' + $nonCop.Count)
Nota ('esito: ' + $esito)
Nota ('fine:  ' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss', $INV))
Nota ''
Nota 'NON e'' stato modificato niente nei due terminali: solo letti e copiati fuori.' 'Green'
Nota 'NESSUNA cartella dati o programma di un terminale BCM (50503392 / 50504263 /' 'Green'
Nota '10105439 / 50504400) e'' stata aperta, letta o copiata. Dei terminali BCM' 'Green'
Nota 'questa riga ha letto SOLO PID e percorso dalla lista dei processi, che e''' 'Green'
Nota 'la regola di casa dei tre terminali, e non ne ha toccato nessuno.' 'Green'

Referto

$zip = $cart + '.zip'
Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
$statoZip = 'NON FATTO'
try {
  Compress-Archive -Path (Join-Path $cart '*') -DestinationPath $zip -Force -ErrorAction Stop
  $statoZip = 'FATTO'
} catch {
  $statoZip = 'FALLITO: ' + $_.Exception.Message
}
Add-Content -LiteralPath $refPath -Value ('zip: ' + $statoZip) -Encoding ASCII

Write-Host ''
if ($statoZip -eq 'FATTO') {
  Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $zip) -ForegroundColor Cyan
} else {
  Write-Host ('ZIP ' + $statoZip) -ForegroundColor Yellow
  Write-Host ('MANDAMI QUESTA CARTELLA: ' + $cart) -ForegroundColor Yellow
}
Write-Host ('REFERTO: ' + $refPath) -ForegroundColor Gray
if ($nonCop.Count -gt 0) {
  Write-Host ('ATTENZIONE: ' + $nonCop.Count + ' file NON copiati -- elenco nel referto. NON disinstallare ancora.') -ForegroundColor Red
}

if ($Fatale -ne '')        { exit 3 }
if ($SoloControllo)        { exit 0 }
if ($trovati -eq 0)        { exit 1 }
if ($salvati -lt $trovati) { exit 2 }
if ($nonCop.Count -gt 0)   { exit 2 }
exit 0
