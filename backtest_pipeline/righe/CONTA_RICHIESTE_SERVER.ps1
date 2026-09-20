# MARCATORE_CONTA_RICHIESTE_SERVER_v1
#=====================================================================
#  CONTA_RICHIESTE_SERVER.ps1  --  20/09/2026
#
#  A COSA SERVE
#  ------------
#  FTMO, Forbidden Trading Practices, voce 4: sono vietati gli EA che
#  rendono il conto "hyperactive" con PIU' DI 2.000 richieste al server
#  al giorno su ordini e pendenti. In casa questo numero non e' MAI
#  stato contato (grep del 20/09: la regola e' citata in tre referti,
#  misurata in zero).
#
#  Questa riga CONTA le richieste vere di una giornata leggendo il
#  GIORNALE DEL TERMINALE, cioe' <cartella dati>\logs\AAAAMMGG.log.
#  Non il log degli Esperti (<dati>\MQL5\Logs): li' ci sono le Print()
#  degli EA, non il traffico verso il server.
#
#  COSA NON FA -- dichiarato, non sottinteso
#  -----------------------------------------
#   - NON apre, NON chiude e NON pilota nessun MT5;
#   - NON scrive UNA SOLA riga dentro una cartella dati: legge i .log
#     in sola lettura (FileShare ReadWrite, perche' il terminale li
#     tiene aperti) e scrive SOLO sul Desktop;
#   - NON manda ordini, NON tocca preset, NON tocca EA;
#   - NON sa quale terminale vuoi: la cartella dati va passata a mano
#     con -CartellaDati. Non indovina, non cerca, non sceglie.
#     Sul VPS convivono SETTE cartelle dati: "gira sul VPS" e' un
#     indirizzo, non un bersaglio.
#
#  STATO: SCRITTO IL 20/09/2026, *** MAI LANCIATO ***.
#  Nessun numero prodotto da questo file esiste ancora. Prima di
#  lanciarlo deve passare dal cancello (controlla_riga.py + agente
#  controllo-preventivo), come tutto il resto.
#
#  IL PUNTO DELICATO, E VA LETTO PRIMA DEI NUMERI
#  ----------------------------------------------
#  MT5 scrive DUE righe per ogni operazione di trading:
#    (1) la RICHIESTA   : "'541452707': modify #123 buy 0.10 GER40.cash sl: ..."
#    (2) l' ESITO       : "... done in 45.678 ms"  oppure  "... failed [Invalid stops]"
#  Contare tutte e due = contare il doppio. Qui si contano le righe di
#  ESITO, perche':
#    a) sono UNA per richiesta;
#    b) l'esito con "done in <n> ms" DIMOSTRA il giro di rete, cioe'
#       che la richiesta il server l'ha vista davvero;
#    c) un rifiuto senza tempo di rete e' il sospetto di rifiuto
#       LOCALE del terminale -- che, se cosi' fosse, al server non
#       arriva e per FTMO non conta. La riga separa i due casi invece
#       di deciderlo a tavolino, perche' a tavolino NON SI SA
#       (dichiarato [NON NOTO] nel referto).
#  Vengono stampati tutti e tre i conti (esiti, verbi, falliti) e
#  trenta righe grezze di campione: se il formato del giornale di
#  FTMO e' diverso da quello atteso, si vede a occhio e non si crede
#  a un numero sbagliato.
#=====================================================================

[CmdletBinding()]
param(
  # Cartella DATI del terminale (quella che contiene 'logs' e 'MQL5'),
  # NON la cartella di installazione. Obbligatoria: niente scoperta
  # automatica, niente default.
  [Parameter(Mandatory=$true)][string]$CartellaDati,

  # Numero di conto atteso. Serve a due cose: filtrare le righe di
  # QUEL conto, e rifiutare in partenza i conti di casa.
  [Parameter(Mandatory=$true)][string]$ContoAtteso,

  # Giorni da leggere: 'AAAAMMGG' (uno) oppure 'TUTTI' (tutti i .log
  # presenti). Default: il giorno di oggi in ora locale del PC.
  [string]$Giorno = (Get-Date -Format 'yyyyMMdd'),

  # Soglia FTMO. Si puo' abbassare per vedere il margine con piu' aria.
  [int]$Soglia = 2000,

  # Se presente, stampa e basta: nessun file sul Desktop.
  [switch]$SoloSchermo,

  # Conferma esplicita per misurare un conto DI CASA (BCM). Serve:
  # il giornale BCM e' la fonte migliore che abbiamo per stimare il
  # traffico PRIMA di lunedi (stesso codice, stessi simboli, tick
  # veri). Ma un numero letto sul terminale sbagliato e' peggio di
  # nessun numero, quindi lo si dice a voce alta.
  [switch]$ForzaContoDiCasa
)

$ErrorActionPreference = 'Stop'
$ESITO = 0

function Dillo([string]$t, [string]$c='Gray'){ Write-Host $t -ForegroundColor $c }
function Muori([string]$t){ Dillo '' ; Dillo ('FERMATO: ' + $t) 'Red' ; exit 1 }

Dillo ''
Dillo '=====================================================================' 'Cyan'
Dillo '  CONTA RICHIESTE SERVER -- voce 4 delle Forbidden Practices FTMO' 'Cyan'
Dillo '  SOLA LETTURA: nessun MT5 toccato, nessuna scrittura in cartella dati' 'Cyan'
Dillo '=====================================================================' 'Cyan'

#---------------------------------------------------------------------
# SERRATURA 0 -- i conti di casa non si contano qui.
#   Non perche' faccia danno (la riga legge e basta), ma perche' un
#   numero letto sul terminale sbagliato e' peggio di nessun numero:
#   sembra una misura e non lo e'.
#---------------------------------------------------------------------
$contiDiCasa = @('50503392','50504263','10105439','50504400','50503635')
if($contiDiCasa -contains $ContoAtteso){
  Dillo ('  Il conto ' + $ContoAtteso + ' e un conto DI CASA (BCM), non la challenge.') 'Yellow'
  Dillo '  Questo NON e un errore se lo stai facendo apposta: il giornale BCM e la' 'Yellow'
  Dillo '  fonte migliore che abbiamo per stimare il traffico PRIMA di lunedi,' 'Yellow'
  Dillo '  perche gira lo STESSO codice sugli STESSI simboli con tick veri.' 'Yellow'
  Dillo '  Passa -ForzaContoDiCasa per confermare. Senza, mi fermo.' 'Yellow'
  if(-not $ForzaContoDiCasa){ Muori 'conto di casa senza conferma esplicita (-ForzaContoDiCasa).' }
  if($ContoAtteso -eq '10105439'){
    Muori 'il conto 10105439 e il REALE: qui non si misura, nemmeno in sola lettura. Se serve, lo chiede Claudio a voce.'
  }
  Dillo '  confermato: misuro un conto di casa in SOLA LETTURA.' 'Green'
}

#---------------------------------------------------------------------
# SERRATURA 1 -- la cartella dati deve essere una cartella dati.
#---------------------------------------------------------------------
if(-not (Test-Path -LiteralPath $CartellaDati)){ Muori ('cartella non trovata: ' + $CartellaDati) }
$dirLog = Join-Path $CartellaDati 'logs'
if(-not (Test-Path -LiteralPath $dirLog)){
  Muori ('non c e la sottocartella logs in ' + $CartellaDati + '. Hai passato la cartella di INSTALLAZIONE invece della cartella DATI? La cartella dati e quella che contiene logs\ e MQL5\.')
}
Dillo ('  cartella dati : ' + $CartellaDati)
Dillo ('  giornale      : ' + $dirLog)
Dillo ('  conto         : ' + $ContoAtteso)
Dillo ('  soglia        : ' + $Soglia + ' richieste/giorno')

#---------------------------------------------------------------------
# I FILE DA LEGGERE
#---------------------------------------------------------------------
if($Giorno -eq 'TUTTI'){
  $files = @(Get-ChildItem -LiteralPath $dirLog -Filter '*.log' -File | Sort-Object Name)
}else{
  if($Giorno -notmatch '^\d{8}$'){ Muori ('-Giorno deve essere AAAAMMGG oppure TUTTI. Ricevuto: ' + $Giorno) }
  $files = @(Get-ChildItem -LiteralPath $dirLog -Filter ($Giorno + '.log') -File)
}
if($files.Count -eq 0){ Muori ('nessun file .log da leggere in ' + $dirLog + ' per il giorno ' + $Giorno) }
Dillo ('  file da leggere: ' + $files.Count)

#---------------------------------------------------------------------
# LETTURA CONDIVISA -- il terminale tiene i .log APERTI. Senza
# FileShare ReadWrite, Get-Content fallisce con "file in uso".
#---------------------------------------------------------------------
function LeggiCondiviso([string]$path){
  $righe = New-Object System.Collections.Generic.List[string]
  $fs = $null; $sr = $null
  try{
    $fs = New-Object System.IO.FileStream($path,[System.IO.FileMode]::Open,[System.IO.FileAccess]::Read,[System.IO.FileShare]::ReadWrite)
    $sr = New-Object System.IO.StreamReader($fs)
    while(-not $sr.EndOfStream){ [void]$righe.Add($sr.ReadLine()) }
  } finally {
    if($sr -ne $null){ $sr.Close() }
    if($fs -ne $null){ $fs.Close() }
  }
  return ,$righe
}

#---------------------------------------------------------------------
# I PATTERN
#   Nessuna dipendenza dalle COLONNE del giornale (cambiano fra build):
#   si cerca dentro il testo della riga.
#---------------------------------------------------------------------
$reConto   = [regex]::new("'" + [regex]::Escape($ContoAtteso) + "'")
$reEsitoOk = [regex]::new('done in\s+([0-9]+(?:\.[0-9]+)?)\s*ms')
$reFallito = [regex]::new('(?i)\b(failed|rejected|invalid)\b')
$reOra     = [regex]::new('([0-2][0-9]):([0-5][0-9]):([0-5][0-9])')

# verbi di richiesta: uno per famiglia di operazione
$verbi = @(
  @{ Nome='MERCATO  (Buy/Sell)';        Re=[regex]::new('(?i)\b(instant|market|request)\s+(buy|sell)\b') },
  @{ Nome='PENDENTE (Limit/Stop)';      Re=[regex]::new('(?i)\b(buy|sell)\s+(limit|stop)\b') },
  @{ Nome='MODIFY   (PositionModify)';  Re=[regex]::new('(?i)\bmodify\b') },
  @{ Nome='DELETE   (OrderDelete)';     Re=[regex]::new('(?i)\b(delete|cancel)\b') },
  @{ Nome='CLOSE    (PositionClose)';   Re=[regex]::new('(?i)\bclose\b') }
)

$perGiorno = @{}
$campioni  = New-Object System.Collections.Generic.List[string]
$righeTot  = 0

foreach($f in $files){
  $giorno = [System.IO.Path]::GetFileNameWithoutExtension($f.Name)
  if(-not $perGiorno.ContainsKey($giorno)){
    $perGiorno[$giorno] = [pscustomobject]@{
      Giorno=$giorno; Esiti=0; EsitiConRete=0; Falliti=0; Verbi=0
      PerVerbo=@{}; PerOra=@{}; PerSimbolo=@{}
    }
  }
  $g = $perGiorno[$giorno]

  $righe = LeggiCondiviso $f.FullName
  foreach($r in $righe){
    $righeTot++
    if([string]::IsNullOrEmpty($r)) { continue }
    if(-not $reConto.IsMatch($r))   { continue }   # righe di ALTRI conti: fuori

    $mEsito = $reEsitoOk.Match($r)
    $isFall = $reFallito.IsMatch($r)
    $isVerbo = $false
    foreach($v in $verbi){ if($v.Re.IsMatch($r)){ $isVerbo = $true; break } }
    if(-not ($isVerbo -or $mEsito.Success -or $isFall)){ continue }

    $isEsito = ($mEsito.Success -or $isFall)
    if($mEsito.Success){ $g.Esiti++; $g.EsitiConRete++ }
    elseif($isFall)    { $g.Esiti++; $g.Falliti++ }     # esito senza tempo di rete
    # VERBI conta SOLO le righe di RICHIESTA (quelle senza esito):
    # se contasse anche gli esiti verrebbe il doppio e non sarebbe
    # piu' una controprova di niente.
    if($isVerbo -and -not $isEsito){ $g.Verbi++ }

    # la ripartizione per tipo si fa sugli ESITI, cioe' sulle richieste
    # che sono davvero partite: e' la stessa base del totale.
    if($isEsito){
      $classificato = $false
      foreach($v in $verbi){
        if($v.Re.IsMatch($r)){
          if(-not $g.PerVerbo.ContainsKey($v.Nome)){ $g.PerVerbo[$v.Nome]=0 }
          $g.PerVerbo[$v.Nome]++
          $classificato = $true
          break
        }
      }
      if(-not $classificato){
        # NON si butta via: un esito che non riconosco resta contato nel
        # totale e finisce qui, dove si vede. Una ripartizione che non
        # fa somma col totale e' una ripartizione che mente.
        if(-not $g.PerVerbo.ContainsKey('ALTRO    (non riconosciuto)')){ $g.PerVerbo['ALTRO    (non riconosciuto)']=0 }
        $g.PerVerbo['ALTRO    (non riconosciuto)']++
      }
    }
    if($isEsito){
      $mo = $reOra.Match($r)
      if($mo.Success){
        $h = $mo.Groups[1].Value
        if(-not $g.PerOra.ContainsKey($h)){ $g.PerOra[$h]=0 }
        $g.PerOra[$h]++
      }
      # simbolo: prima parola che assomiglia a un ticker (maiuscole,
      # eventualmente con .cash / .spot). Se non lo trova, non inventa.
      $ms = [regex]::Match($r,'\b([A-Z][A-Z0-9]{2,9}(?:\.[a-z]{3,6})?)\b')
      if($ms.Success){
        $s = $ms.Groups[1].Value
        if(-not $g.PerSimbolo.ContainsKey($s)){ $g.PerSimbolo[$s]=0 }
        $g.PerSimbolo[$s]++
      }
    }
    if($campioni.Count -lt 30){ [void]$campioni.Add($r) }
  }
}

#---------------------------------------------------------------------
# REFERTO
#---------------------------------------------------------------------
$out = New-Object System.Collections.Generic.List[string]
function Riga([string]$t,[string]$c='Gray'){ Dillo $t $c; [void]$out.Add($t) }

Riga ''
Riga ('righe di giornale lette: ' + $righeTot)
Riga ''
Riga 'CONTO PER GIORNATA  (la colonna che conta per FTMO e ESITI)' 'Cyan'
Riga '  ESITI      = una riga per richiesta andata al server (done/failed)'
Riga '  di cui RETE= con "done in <n> ms": giro di rete DIMOSTRATO'
Riga '  FALLITI    = esito negativo. Senza tempo di rete puo essere un'
Riga '               rifiuto LOCALE del terminale: in quel caso al server'
Riga '               non arriva. [NON NOTO] a tavolino: qui si vede.'
Riga '  VERBI      = righe di RICHIESTA. Serve come controprova: se e'
Riga '               molto diverso da ESITI, il formato non e quello atteso.'
Riga ''
Riga ('{0,-10} {1,8} {2,8} {3,8} {4,8}   {5}' -f 'GIORNO','ESITI','RETE','FALLITI','VERBI','ESITO vs SOGLIA')
Riga ('{0,-10} {1,8} {2,8} {3,8} {4,8}   {5}' -f '----------','--------','--------','--------','--------','---------------')

$peggiore = 0; $giornoPeggiore = ''
foreach($k in ($perGiorno.Keys | Sort-Object)){
  $g = $perGiorno[$k]
  $stato = if($g.Esiti -ge $Soglia){ 'SFONDATA' } elseif($g.Esiti -ge [int]($Soglia*0.5)){ 'META SOGLIA' } else { 'sotto' }
  $marg  = $Soglia - $g.Esiti
  Riga ('{0,-10} {1,8} {2,8} {3,8} {4,8}   {5} (margine {6})' -f $g.Giorno,$g.Esiti,$g.EsitiConRete,$g.Falliti,$g.Verbi,$stato,$marg) `
       $(if($g.Esiti -ge $Soglia){'Red'} elseif($g.Esiti -ge [int]($Soglia*0.5)){'Yellow'} else {'Green'})
  if($g.Esiti -gt $peggiore){ $peggiore = $g.Esiti; $giornoPeggiore = $g.Giorno }
}

if($giornoPeggiore -ne ''){
  $gp = $perGiorno[$giornoPeggiore]
  Riga ''
  Riga ('DETTAGLIO DELLA GIORNATA PEGGIORE: ' + $giornoPeggiore + '  (' + $gp.Esiti + ' richieste)') 'Cyan'
  Riga '  per tipo di operazione:'
  foreach($n in ($gp.PerVerbo.Keys | Sort-Object)){ Riga ('    ' + $n.PadRight(28) + ' ' + $gp.PerVerbo[$n]) }
  Riga '  per ora (ora LOCALE del PC, non ora server):'
  foreach($h in ($gp.PerOra.Keys | Sort-Object)){
    $n = $gp.PerOra[$h]
    $barra = '#' * [Math]::Min(60,[int]($n/5)+1)
    Riga ('    ' + $h + ':00  ' + ('{0,6}' -f $n) + '  ' + $barra)
  }
  Riga '  per simbolo (i primi dieci):'
  foreach($s in ($gp.PerSimbolo.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 10)){
    Riga ('    ' + $s.Key.PadRight(14) + ' ' + $s.Value)
  }
}

Riga ''
Riga 'TRENTA RIGHE GREZZE DI CAMPIONE -- guardale. Se non assomigliano a' 'Cyan'
Riga 'righe di trading, il conto qui sopra NON vale e va buttato.' 'Cyan'
foreach($c in $campioni){ Riga ('  | ' + $c) }

Riga ''
Riga 'CIO CHE QUESTA RIGA NON COPRE, dichiarato:' 'Yellow'
Riga '  - non sa se FTMO conti come noi (richieste al server) o conti'
Riga '    anche altro traffico: la definizione esatta non e pubblica.'
Riga '  - un rifiuto LOCALE del terminale potrebbe non arrivare al'
Riga '    server: qui compare fra i FALLITI senza tempo di rete, ma'
Riga '    che FTMO lo conti o no e [NON NOTO].'
Riga '  - conta il traffico di TUTTI gli EA di quel conto insieme,'
Riga '    come fa FTMO: il limite e per CONTO, non per sedia.'

if(-not $SoloSchermo){
  $desk = [Environment]::GetFolderPath('Desktop')
  $stamp = Get-Date -Format 'yyyy-MM-dd_HHmm'
  $dest = Join-Path $desk ('RICHIESTE_SERVER_' + $ContoAtteso + '_' + $stamp)
  New-Item -ItemType Directory -Path $dest -Force | Out-Null
  $fileTxt = Join-Path $dest 'referto.txt'
  $out | Set-Content -LiteralPath $fileTxt -Encoding UTF8
  $zip = $dest + '.zip'
  if(Test-Path -LiteralPath $zip){ Remove-Item -LiteralPath $zip -Force }
  Compress-Archive -Path $dest -DestinationPath $zip
  Dillo ''
  Dillo ('Referto sul Desktop: ' + $fileTxt) 'Green'
  Dillo ('Zip pronto da mandare: ' + $zip) 'Green'
  Dillo 'File attesi nello zip: referto.txt  (1 file)' 'Green'
}

if($peggiore -ge $Soglia){
  Dillo ''
  Dillo ('*** GIORNATA SOPRA LA SOGLIA FTMO: ' + $peggiore + ' >= ' + $Soglia + ' ***') 'Red'
  $ESITO = 2
}
exit $ESITO
