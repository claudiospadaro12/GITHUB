# =====================================================================
#  MARCATORE_RUNNER_ABTG_v3
#  runner_abtg.ps1 -- ESEGUE DA SOLO LA CODA, e pubblica i referti sul
#  repo. Nato il 07/09/2026 dalla domanda di Claudio: "puoi lanciarle tu
#  le stringhe per me?".
# ---------------------------------------------------------------------
#  LA RISPOSTA VERA A QUELLA DOMANDA
#  Claude gira in un container nel cloud e il VPS non lo vede: nessuna
#  firma crea un collegamento. Ma META' del collegamento ESISTE GIA' ED
#  E' IN PRODUZIONE: `pubblica_trades.ps1` gira come attivita'
#  pianificata alle 22:45 e carica i CSV sul repo via API GitHub col
#  token che sta sul VPS (commit "Aggiornamento automatico trades",
#  verificati fino al 05/09/2026). Manca il verso opposto: SCARICARE una
#  coda ed ESEGUIRLA. Questo file e' quel verso.
#
#  IL CICLO, UNA VOLTA INSTALLATO:
#    Claude scrive la coda -> pusha su 'lavoro'
#    il VPS, da solo: scarica, esegue in ordine, raccoglie
#    il VPS, da solo: pubblica i referti sul repo
#    Claude legge i referti e scrive la coda dopo
#  Claudio lo installa UNA VOLTA e non tocca piu' niente.
#
# =====================================================================
#  >>> COSA CAMBIA NELLA v3 (11/09/2026) E PERCHE'
#      Claudio ha firmato l'allargamento del perimetro: da "legge e
#      fotografa" a "legge, fotografa E LANCIA BACKTEST SUL SOLO
#      TERMINALE DA BACKTEST" (report/IL_TAPPO_2026-09-11.md). Il motivo
#      e' misurato: R125, R126 e R127 sono pronti, costano ~17 minuti di
#      macchina in tutto, e non girano perche' nessuno e' davanti al PC.
#
#      >>> L'ALLARGAMENTO NON E' UN ALLENTAMENTO. <<<
#      Il cancello di sola lettura NON e' stato toccato: stessi divieti,
#      stesso marcatore, stessi esiti sugli stessi casi. L'allargamento e'
#      una SECONDA CORSIA SEPARATA, con un marcatore diverso e una lista
#      di regole propria. Un cancello con una lista di DEROGHE e' un
#      cancello che si aggira; due cancelli distinti no.
#
#  LE DUE CORSIE, e uno script sta in UNA SOLA
#   * CORSIA LETTURA -- marcatore  # RUNNER_SOLA_LETTURA
#       Legge, conta, STAMPA. Non avvia niente, non scrive niente.
#       E' il perimetro firmato il 07/09 (report/PERIMETRO_RUNNER.md),
#       invariato.
#   * CORSIA ROUND   -- marcatore  # RUNNER_ROUND_BACKTEST
#       In piu' puo': avviare il tester (Start-Process, terminal64,
#       metatester) e scrivere/copiare file (Set-Content, Add-Content,
#       Out-File, Copy-Item). E BASTA.
#   >>> SE UNO SCRIPT HA TUTTI E DUE I MARCATORI E' RIFIUTATO.
#       L'ambiguita' non si interpreta: si rifiuta.
#
#  I CANCELLI, INDIPENDENTI, TUTTI CODICE (classe 151)
#   G0. sorgente non vuoto.
#   G1. IL MARCATORE. Opt-in deliberato: uno script non entra per
#       sbaglio. Uno solo dei due, mai entrambi.
#   G2. LA SCANSIONE DEI DIVIETI, riga per riga, saltando i commenti di
#       riga intera. La lista dipende dalla corsia. Il NUCLEO (conti e
#       cartelle dei tre terminali vivi, esecuzione di testo arbitrario,
#       ordini, attivita' pianificate, Stop-Process) e' IDENTICO nelle
#       due corsie e non si tocca.
#   G3. IL CANCELLO POSITIVO (solo corsia ROUND). Non basta non fare
#       danni: bisogna DIMOSTRARE di puntare al banco. Lo script deve
#       nominare C:\MT5_Backtest (o il conto 50504400) in CODICE, e ogni
#       riga che nomina terminal64 / metatester / Stop-Process deve
#       puntare li' -- sulla riga stessa o tramite una variabile che
#       porta QUEL percorso letterale.
#   G4. GLI ARGOMENTI DELLA RIGA DI CODA passano dagli stessi divieti, e
#       in corsia ROUND non possono contenere percorsi fuori dal banco.
#       (Buco chiuso nella v3: fino alla v2 il terzo campo della riga di
#       coda arrivava allo script SENZA nessun controllo, e i round
#       prendono il bersaglio da li'.)
#
#  >>> STOP-PROCESS RESTA VIETATO ANCHE IN CORSIA ROUND. <<<
#      Non per distrazione: per scelta dichiarata. Un cancello TESTUALE
#      non puo' garantire QUALI processi colpira' un Stop-Process a
#      corsa: `$lista | Stop-Process` non dice da dove viene $lista. Il
#      10/09 un ChiudiMT5Pulito ha ammazzato OGNI terminal64 della
#      macchina, conto REALE compreso. Meglio un round che non si
#      pulisce da solo (e muore dicendo "il banco e' aperto") che una
#      flotta chiusa di notte.
#
#  >>> COLLAUDABILE SENZA NIENTE: -CollaudoCancelli fa girare G0..G4 su
#      una batteria di casi finti (buoni, cattivi e INSIDIOSI) e dice
#      cosa avrebbe fatto. Un cancello che nessuno ha visto scattare non
#      e' un cancello dimostrato.
#
#  NIENTE EMOJI, NIENTE ACCENTI: sul VPS gira Windows PowerShell 5.1 che
#  legge i .ps1 come ANSI. Questo file e' ASCII puro.
# =====================================================================

param(
  [switch]$Installa,                 # registra l'attivita' pianificata e esce
  [string]$Ora        = "03:30",     # ora VPS della corsa notturna
  [string]$DestDir    = "C:\ABTG",
  [string]$Owner      = "claudiospadaro12",
  [string]$Repo       = "github",
  [string]$Branch     = "lavoro",
  [string]$CodaPath   = "backtest_pipeline/coda/CODA.txt",
  [string]$TokenFile  = "",
  [switch]$SoloControllo,            # scarica e VAGLIA la coda, non esegue niente
  [switch]$CollaudoCancelli,         # esegue SOLO i cancelli su casi finti
  [switch]$NonPubblicare             # esegue ma non carica sul repo
)

$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$MARC = "MARCATORE_RUNNER_ABTG_v3"

# I due marcatori di corsia. Uno solo per script, mai tutti e due.
$MARC_LETTURA = "RUNNER_SOLA_LETTURA"
$MARC_ROUND   = "RUNNER_ROUND_BACKTEST"

# Il BANCO, e solo il banco: cartella programma e conto del terminale
# demo solo-tester (PASSO 7 del 08/09: riproduce alla cifra le corse gia'
# agli atti). Sono le due uniche stringhe che aprono la corsia ROUND.
$BANCO_PERC  = 'C:\MT5_Backtest'
$BANCO_CONTO = '50504400'

# =====================================================================
#  I DIVIETI. Ogni voce: il modello, PERCHE' e' vietato, e se vale
#  ANCHE in corsia ROUND (round=$true) oppure se la corsia ROUND lo
#  permette (round=$false).
#  Sono cercati come TESTO nel sorgente dello script, senza eseguirlo.
#  >>> L'ORDINE NON SI CAMBIA: e' l'ordine in cui il motivo viene
#      riportato nel referto, e i collaudi del 07/09 lo citano.
#      Le voci NUOVE si aggiungono IN FONDO.
# =====================================================================
$DIVIETI = @(
  @{ p='BCM_Reale';                 round=$true;  why='tocca il terminale del CONTO REALE 10105439' },
  @{ p='10105439';                  round=$true;  why='nomina il CONTO REALE' },
  @{ p='E23E1504A8D02A22179395F0652B86B6'; round=$true; why='e'' la cartella dati del CONTO REALE' },
  @{ p='OrderSend';                 round=$true;  why='invia ordini' },
  @{ p='PositionClose';             round=$true;  why='chiude posizioni' },
  @{ p='OrderDelete';               round=$true;  why='cancella ordini' },
  @{ p='ExpertRemove';              round=$true;  why='stacca un EA' },
  @{ p='ChartApplyTemplate';        round=$true;  why='cambia cosa gira su un grafico' },
  @{ p='ChartOpen';                 round=$true;  why='apre grafici sul terminale vivo' },
  @{ p='EseguiDavvero';             round=$true;  why='e'' uno script che AGISCE sulle sedie: nemmeno un round ne ha bisogno' },
  @{ p='schtasks';                  round=$true;  why='registra o cancella attivita'' pianificate' },
  @{ p='Register-ScheduledTask';    round=$true;  why='registra attivita'' pianificate' },
  @{ p='Stop-Process';              round=$true;  why='puo'' uccidere un terminale MT5 vivo, e un cancello TESTUALE non puo'' dire quale (10/09: ChiudiMT5Pulito ammazzo'' anche il REALE)' },
  @{ p='terminal64.exe';            round=$false; why='avvia o pilota un terminale' },
  @{ p='Start-Process';             round=$false; why='avvia programmi: nella corsia di sola lettura non serve a nessuna lettura' },
  @{ p='Remove-Item';               round=$true;  why='cancella file' },
  @{ p='Set-Content';               round=$false; why='scrive file' },
  @{ p='Add-Content';               round=$false; why='scrive file' },
  @{ p='Out-File';                  round=$false; why='scrive file' },
  @{ p='Copy-Item';                 round=$false; why='copia file: in sola lettura la raccolta la fa il runner' },
  @{ p='Move-Item';                 round=$true;  why='sposta file' },
  @{ p='Invoke-Expression';         round=$true;  why='esegue testo arbitrario: qualunque scansione diventa inutile' },
  @{ p='iex ';                      round=$true;  why='alias di Invoke-Expression' },
  @{ p='DownloadString';            round=$true;  why='scarica ed esegue codice fuori dalla coda' },
  # --- AGGIUNTE DELLA v3 (11/09/2026), valide in ENTRAMBE le corsie ---
  # Il buco trovato leggendo la lista: c'era il conto REALE e NON c'era
  # il 100k 50504263, che ha posizioni VIVE (dry-run FTMO). Un round
  # lanciato li' chiuderebbe delle sedie.
  @{ p='50504263';                  round=$true;  why='nomina il conto 100k 50504263, che ha POSIZIONI VIVE' },
  # NB: si vieta 'MT5 Terminal -V3', NON il nudo '-V3'. Misurato sul
  # repo: il nudo '-V3' compare in 27 righe LEGITTIME che lo usano per
  # ESCLUDERE il 100k (-notlike "*-V3*"), e -match e' insensibile al
  # maiuscolo quindi prenderebbe anche 'HD-M1-v3' e 'R93-LANCIO-v3'.
  # Vietare il nudo '-V3' avrebbe bocciato le guardie, cioe' il codice
  # scritto BENE. La forma lunga e' il nome vero della cartella:
  # C:\Program Files\BCM Markets MT5 Terminal -V3.
  @{ p='MT5 Terminal -V3';          round=$true;  why='e'' la cartella programma del 100k 50504263' },
  @{ p='BCA8AD18563BF5B64A433C2662D0A104'; round=$true; why='e'' la cartella dati del 100k 50504263 (misurata: CODA_03 del 11/09)' },
  # Buco della corsia di SOLA LETTURA, chiuso qui: terminal64.exe era
  # vietato ma metatester/metaeditor no, e si lanciano anche col solo
  # operatore di chiamata '&', senza Start-Process.
  @{ p='metatester';                round=$false; why='avvia il tester: in sola lettura non serve' },
  @{ p='metaeditor';                round=$false; why='avvia il compilatore: in sola lettura non serve' }
)

# =====================================================================
#  DIVIETI IN PIU' DELLA SOLA CORSIA ROUND (difesa in profondita').
#  Non sono deroghe: sono strette. Un round non ha NESSUN motivo di
#  nominare gli altri due terminali, e nemmeno di aprire una shell che
#  non sia powershell.
#  Non toccano la corsia di lettura, dove nominare il piccolo e'
#  legittimo e misurato (VERIFICA_SW_DAX_770512.ps1 lo fa).
# =====================================================================
$DIVIETI_SOLO_ROUND = @(
  @{ p='50503392';                  why='nomina il conto PICCOLO 50503392: ha sedie vive, non e'' il banco' },
  @{ p='215D85D767A1C39E22D242C8114BF9F5'; why='e'' la cartella dati del piccolo 50503392' },
  @{ p='BCM Markets MT5 Terminal';  why='e'' la cartella programma dei terminali in FORWARD (piccolo e 100k)' },
  @{ p='cmd.exe';                   why='apre una shell fuori controllo' },
  @{ p='cmd /c';                    why='apre una shell fuori controllo' },
  # Gli ALIAS di Start-Process e i modi di lanciare qualcosa senza
  # scrivere 'Start-Process': il cancello G3 guarda quel nome, e questi
  # lo aggirerebbero senza toccare una virgola della scansione.
  @{ p='saps';                      why='alias di Start-Process' },
  @{ p='start ';                    why='alias di Start-Process' },
  @{ p='Invoke-Item';               why='apre un file con il programma associato' },
  @{ p='Invoke-Command';            why='esegue un blocco altrove' },
  @{ p='Start-Job';                 why='esegue un blocco in un processo separato, fuori dal log' },
  # E i modi di cambiare una variabile SENZA scrivere '$nome =': senza
  # questi, la squalifica della variabile di G3 si aggira in una riga.
  @{ p='Set-Variable';              why='cambia una variabile senza che G3 lo veda' },
  @{ p='New-Variable';              why='crea una variabile senza che G3 lo veda' }
)

function DivietiDi([string]$corsia){
  $l = @($DIVIETI | Where-Object { $corsia -ne "ROUND" -or $_.round })
  if($corsia -eq "ROUND"){ $l = @($l) + @($DIVIETI_SOLO_ROUND) }
  return $l
}

function Titolo($t){ Write-Host ""; Write-Host ("=== " + $t + " ===") -ForegroundColor Cyan }

# =====================================================================
#  TOGLI IL COMMENTO IN CODA A UNA RIGA -- senza tagliare dentro le
#  stringhe. Serve SOLO al cancello POSITIVO G3, e il motivo e' il caso
#  piu' insidioso di tutti:
#      Start-Process (Join-Path $b "terminal64.exe")   # C:\MT5_Backtest
#  Un commento non esegue niente: se il bersaglio lo si "dimostra" con
#  un commento, non lo si e' dimostrato affatto.
#  >>> ASIMMETRIA VOLUTA: i DIVIETI (G2) continuano a leggere la riga
#      INTERA, commento compreso. Per dire "e' cattivo" si guarda tutto;
#      per dire "e' buono" si guarda solo cio' che esegue.
# =====================================================================
function TogliCommento([string]$riga){
  if($null -eq $riga){ return "" }
  $sq = $false; $dq = $false
  for($i=0; $i -lt $riga.Length; $i++){
    $ch = $riga[$i]
    if($ch -eq '`' -and $dq){ $i++; continue }     # escape dentro doppi apici
    if($ch -eq "'" -and -not $dq){ $sq = -not $sq; continue }
    if($ch -eq '"' -and -not $sq){ $dq = -not $dq; continue }
    if($ch -eq '#' -and -not $sq -and -not $dq){ return $riga.Substring(0,$i) }
  }
  return $riga
}

# Il bersaglio nominato per esteso: il percorso del banco o il suo conto.
function NominaIlBanco([string]$s){
  if([string]::IsNullOrEmpty($s)){ return $false }
  if($s -match 'MT5_Backtest'){ return $true }
  if($s -match $BANCO_CONTO){ return $true }
  return $false
}

# =====================================================================
#  COME SI SCRIVE IL NOME DI UNA VARIABILE, IN TUTTI I MODI CHE CONTANO
#  Trovato provando a ROMPERE il cancello, non leggendolo:
#    $BT = 'C:\MT5_Backtest'        -> approvata
#    ${BT} = 'D:\Altro'             -> con la regex ingenua NON si vede
#    $script:BT = 'D:\Altro'        -> nemmeno
#    Start-Process (Join-Path $BT 'terminal64.exe')   -> PASSAVA.
#  Cioe' due modi legali di scrivere la stessa variabile bastavano ad
#  aggirare la squalifica. Qui la forma ${...} si riconosce, e il
#  prefisso di AMBITO (global:/script:/local:/private:/using:/variable:)
#  si toglie, cosi' $BT e $script:BT sono la STESSA chiave.
#  NB: 'env:' e gli altri drive NON si tolgono: $env:BT e $BT sono due
#  cose diverse davvero, e confonderle aprirebbe un buco al contrario.
# =====================================================================
$RX_VAR = '\$\{?([A-Za-z_][A-Za-z0-9_:]*)\}?'
$AMBITI = @('global','script','local','private','using','variable')
function NomeVar([string]$raw){
  $s = ("" + $raw)
  $i = $s.IndexOf(':')
  if($i -gt 0){
    $pre = $s.Substring(0,$i).ToLower()
    if($AMBITI -contains $pre){ return $s.Substring($i+1) }
  }
  return $s
}

# Una assegnazione vale come "porta il banco" SOLO se e':
#   a) il percorso LETTERALE del banco (con o senza virgolette), oppure
#   b) un Join-Path su una variabile GIA' approvata.
# Non basta che il testo a destra CONTENGA 'MT5_Backtest': se bastasse,
#   $b = $b -replace "MT5_Backtest","Altro"
# terrebbe la variabile approvata mentre il valore vero cambia.
function RhsPortaIlBanco([string]$rhs,[hashtable]$approvate){
  $s = ("" + $rhs).Trim()
  if($s -match '^[''"]?C:\\MT5_Backtest'){ return $true }
  $m = [regex]::Match($s, '^\(?\s*Join-Path\s+' + $RX_VAR)
  if($m.Success -and $approvate.ContainsKey((NomeVar $m.Groups[1].Value))){ return $true }
  return $false
}

# Una riga "punta al banco" se lo NOMINA, oppure se usa una variabile
# che porta il banco. Sta fuori da BersaglioOk apposta: una funzione
# annidata che legge le variabili del chiamante funziona in PowerShell,
# ma e' il genere di cosa che si rompe in silenzio.
function PuntaAlBanco([string]$riga,[hashtable]$buone){
  if(NominaIlBanco $riga){ return $true }
  foreach($mm in [regex]::Matches($riga, $RX_VAR)){
    if($buone.ContainsKey((NomeVar $mm.Groups[1].Value))){ return $true }
  }
  return $false
}

# =====================================================================
#  G3 -- IL CANCELLO POSITIVO DELLA CORSIA ROUND.
#  Torna @{ ok=...; motivo=... }
# =====================================================================
function BersaglioOk([string]$testo){
  $righe = @($testo -split "`r?`n")
  $codice = New-Object System.Collections.ArrayList   # solo cio' che ESEGUE
  $n = 0
  foreach($r in $righe){
    $n++
    if($r.Trim().StartsWith("#")){ continue }          # commento di riga intera
    $c = (TogliCommento $r).Trim()
    if($c -eq ""){ continue }
    [void]$codice.Add(@{ n=$n; t=$c })
  }

  # --- G3a: il bersaglio va DICHIARATO, e in codice.
  $dichiarato = $false
  foreach($e in $codice){ if(NominaIlBanco $e.t){ $dichiarato = $true; break } }
  if(-not $dichiarato){
    return @{ ok=$false; motivo=("G3: nessun bersaglio dichiarato. Un round deve nominare '" + $BANCO_PERC + "' o il conto " + $BANCO_CONTO + " in CODICE (non in un commento).") }
  }

  # --- le variabili che portano il banco, lette dall'alto in basso.
  #     Una variabile RIASSEGNATA a qualcos'altro viene SQUALIFICATA e
  #     non torna piu' buona: e' il caso "$b = banco; $b = altro".
  $approvate = @{}
  $bocciate  = @{}
  foreach($e in $codice){
    $m = [regex]::Match($e.t, $RX_VAR + '\s*(\+?=)\s*(.+)$')
    if(-not $m.Success){ continue }
    $nome = NomeVar $m.Groups[1].Value
    $segno= $m.Groups[2].Value
    $rhs  = $m.Groups[3].Value
    $buona = $false
    if($segno -eq '='){ $buona = RhsPortaIlBanco $rhs $approvate }   # '+=' non e' mai verificabile
    if($buona){ $approvate[$nome] = $true }
    else { $bocciate[$nome] = $true }
  }
  $buone = @{}
  foreach($k in $approvate.Keys){ if(-not $bocciate.ContainsKey($k)){ $buone[$k] = $true } }

  foreach($e in $codice){
    # --- G3b: chi nomina un terminale deve dire QUALE.
    if($e.t -match 'terminal64' -or $e.t -match 'metatester' -or $e.t -match 'Stop-Process'){
      if(-not (PuntaAlBanco $e.t $buone)){
        return @{ ok=$false; motivo=("G3: riga " + $e.n + " nomina un terminale senza puntare al banco. Serve '" + $BANCO_PERC + "' sulla riga stessa, o una variabile assegnata a QUEL percorso letterale.") }
      }
    }
    # --- G3c: si avvia solo roba riconoscibile. Vale per Start-Process
    #     E per l'OPERATORE DI CHIAMATA ( & "..." / & $var ), che lancia
    #     esattamente come Start-Process e che la v2 non guardava.
    #     '& {' (blocco di script) resta permesso: quel codice sta nel
    #     file e quindi e' gia' passato dalla scansione.
    $chiamata = ($e.t -match 'Start-Process') -or ($e.t -match '(^|[\s\(\|;=])&\s*["''\$]')
    if($chiamata){
      $exeNoto = ($e.t -match 'powershell\.exe' -or $e.t -match 'terminal64' -or $e.t -match 'metatester' -or $e.t -match 'metaeditor')
      if(-not $exeNoto -and -not (PuntaAlBanco $e.t $buone)){
        return @{ ok=$false; motivo=("G3: riga " + $e.n + " avvia un programma non riconoscibile. In corsia ROUND si avviano solo powershell.exe, terminal64, metatester, metaeditor o una variabile che porta il banco.") }
      }
    }
  }
  return @{ ok=$true; motivo="G3 passato: bersaglio dichiarato e coerente" }
}

# =====================================================================
#  I CANCELLI G0-G3. Funzione unica, usata sia dalla corsa sia dal
#  collaudo. Torna @{ ok=$true/$false; motivo="..."; corsia="..." }
# =====================================================================
function VagliaScript([string]$testo,[string]$nome){
  if([string]::IsNullOrWhiteSpace($testo)){
    return @{ ok=$false; motivo="G0: sorgente vuoto o non scaricato"; corsia="?" }
  }
  # G1 -- il marcatore di opt-in: UNO, e uno solo.
  $haL = ($testo -match [regex]::Escape($MARC_LETTURA))
  $haR = ($testo -match [regex]::Escape($MARC_ROUND))
  if($haL -and $haR){
    return @{ ok=$false; motivo=("G1: lo script ha TUTTI E DUE i marcatori ('" + $MARC_LETTURA + "' e '" + $MARC_ROUND + "'). L'ambiguita' non si interpreta: si rifiuta."); corsia="?" }
  }
  if(-not $haL -and -not $haR){
    return @{ ok=$false; motivo=("G1: manca il marcatore '" + $MARC_LETTURA + "' (corsia lettura) oppure '" + $MARC_ROUND + "' (corsia round). Uno script non entra in coda per sbaglio."); corsia="?" }
  }
  $corsia = "LETTURA"
  if($haR){ $corsia = "ROUND" }
  $lista = DivietiDi $corsia

  # G2 -- la scansione dei divieti, RIGA PER RIGA, saltando i commenti
  $n = 0
  foreach($riga in ($testo -split "`r?`n")){
    $n++
    $pulita = $riga.Trim()
    if($pulita.StartsWith("#")){ continue }         # i commenti spiegano, non eseguono
    foreach($d in $lista){
      if($pulita -match [regex]::Escape($d.p)){
        return @{ ok=$false; motivo=("G2: riga " + $n + " contiene '" + $d.p + "' -- " + $d.why); corsia=$corsia }
      }
    }
  }

  # G3 -- il cancello POSITIVO, solo per la corsia ROUND
  if($corsia -eq "ROUND"){
    $b = BersaglioOk $testo
    if(-not $b.ok){ return @{ ok=$false; motivo=$b.motivo; corsia=$corsia } }
    return @{ ok=$true; motivo=("G1, G2 e " + $b.motivo); corsia=$corsia }
  }
  return @{ ok=$true; motivo="G1 e G2 passati"; corsia=$corsia }
}

# =====================================================================
#  G4 -- GLI ARGOMENTI DELLA RIGA DI CODA.
#  Fino alla v2 il terzo campo della riga di coda arrivava allo script
#  SENZA nessun controllo. In sola lettura contava poco; in corsia ROUND
#  e' esattamente da li' che passa il BERSAGLIO
#  (-TerminaleBacktest <cartella>): un cancello che vaglia il sorgente e
#  lascia passare gli argomenti non vaglia niente.
# =====================================================================
function VagliaArgomenti([string]$argomenti,[string]$corsia){
  if([string]::IsNullOrWhiteSpace($argomenti)){ return @{ ok=$true; motivo="G4: nessun argomento" } }
  foreach($d in (DivietiDi $corsia)){
    if($argomenti -match [regex]::Escape($d.p)){
      return @{ ok=$false; motivo=("G4: gli argomenti contengono '" + $d.p + "' -- " + $d.why) }
    }
  }
  if($corsia -eq "ROUND"){
    foreach($m in [regex]::Matches($argomenti, '[A-Za-z]:\\[^"'' ]*')){
      if($m.Value -notmatch '^[Cc]:\\MT5_Backtest'){
        return @{ ok=$false; motivo=("G4: gli argomenti portano un percorso fuori dal banco: '" + $m.Value + "'. In corsia ROUND si passa solo roba sotto " + $BANCO_PERC + ".") }
      }
    }
  }
  return @{ ok=$true; motivo="G4 passato" }
}

# =====================================================================
#  RAMO DI COLLAUDO -- non serve ne' rete ne' MT5
# =====================================================================
if($CollaudoCancelli){
  Titolo "COLLAUDO DEI CANCELLI G0-G4 (nessuna rete, nessun MT5)"
  Write-Host ("  " + $MARC) -ForegroundColor DarkGray

  # ---- PARTE 1: gli 11 casi del 07/09, INVARIATI. Se anche uno solo
  #      cambia esito, la corsia di sola lettura e' stata allentata.
  $casi = @(
    @{ nome="BUONO: legge e stampa";         atteso=$true;  txt="# RUNNER_SOLA_LETTURA`nGet-ChildItem C:\ | Select-Object Name`nWrite-Host 'ciao'" },
    @{ nome="CATTIVO: manca il marcatore";   atteso=$false; txt="Get-ChildItem C:\ | Select-Object Name" },
    @{ nome="CATTIVO: tocca il REALE";       atteso=$false; txt="# RUNNER_SOLA_LETTURA`nGet-ChildItem 'C:\BCM_Reale'" },
    @{ nome="CATTIVO: nomina il conto reale";atteso=$false; txt="# RUNNER_SOLA_LETTURA`n`$c = 10105439" },
    @{ nome="CATTIVO: scrive un file";       atteso=$false; txt="# RUNNER_SOLA_LETTURA`nSet-Content -Path x.txt -Value 'a'" },
    @{ nome="CATTIVO: cancella";             atteso=$false; txt="# RUNNER_SOLA_LETTURA`nRemove-Item x.txt" },
    @{ nome="CATTIVO: esegue testo";         atteso=$false; txt="# RUNNER_SOLA_LETTURA`nInvoke-Expression `$roba" },
    @{ nome="CATTIVO: avvia un processo";    atteso=$false; txt="# RUNNER_SOLA_LETTURA`nStart-Process terminal64.exe" },
    @{ nome="CATTIVO: -EseguiDavvero";       atteso=$false; txt="# RUNNER_SOLA_LETTURA`nparam([switch]`$EseguiDavvero)" },
    @{ nome="BUONO: il divieto e' in un COMMENTO"; atteso=$true; txt="# RUNNER_SOLA_LETTURA`n# qui NON usiamo Remove-Item, mai`nGet-Date" },
    @{ nome="CATTIVO: sorgente vuoto";       atteso=$false; txt="" }
  )

  # ---- PARTE 2: la corsia ROUND, e le prove che NON si e' allentata
  #      quella vecchia. Il round "buono" e' la forma vera del mestiere:
  #      dichiara il banco, scarica il driver, lo lancia con powershell.
  $roundBuono = "# RUNNER_ROUND_BACKTEST`n" +
                "`$BT = 'C:\MT5_Backtest'`n" +
                "`$drv = Join-Path `$env:USERPROFILE 'abtg_round\driver.ps1'`n" +
                "Invoke-WebRequest -Uri `$url -OutFile `$drv -UseBasicParsing`n" +
                "Start-Process powershell.exe -ArgumentList @('-File',`$drv,'-TerminaleBacktest',`$BT) -Wait -NoNewWindow`n" +
                "Write-Host 'fatto'"

  $casi2 = @(
    @{ nome="ROUND BUONO: punta al banco";   atteso=$true;  txt=$roundBuono },
    @{ nome="ROUND BUONO: Join-Path del banco"; atteso=$true; txt="# RUNNER_ROUND_BACKTEST`n`$BT = `"C:\MT5_Backtest`"`n`$exe = Join-Path `$BT 'terminal64.exe'`nWrite-Host `$exe" },
    @{ nome="ROUND CATTIVO: bersaglio 100k"; atteso=$false; txt="# RUNNER_ROUND_BACKTEST`n`$BT = 'C:\MT5_Backtest'`nStart-Process powershell.exe -ArgumentList @('-File',`$d,'-T','50504263')" },
    @{ nome="ROUND CATTIVO: cartella -V3";   atteso=$false; txt="# RUNNER_ROUND_BACKTEST`n`$BT = 'C:\Program Files\BCM Markets MT5 Terminal -V3'`nStart-Process (Join-Path `$BT 'terminal64.exe')" },
    @{ nome="ROUND CATTIVO: cartella REALE"; atteso=$false; txt="# RUNNER_ROUND_BACKTEST`n`$BT = 'C:\BCM_Reale'`nStart-Process (Join-Path `$BT 'terminal64.exe')" },
    @{ nome="ROUND CATTIVO: conto REALE";    atteso=$false; txt="# RUNNER_ROUND_BACKTEST`n`$BT = 'C:\MT5_Backtest'`nWrite-Host 'conto 10105439'" },
    @{ nome="ROUND CATTIVO: conto piccolo";  atteso=$false; txt="# RUNNER_ROUND_BACKTEST`n`$BT = 'C:\MT5_Backtest'`nWrite-Host 'conto 50503392'" },
    @{ nome="ROUND CATTIVO: nessun bersaglio"; atteso=$false; txt="# RUNNER_ROUND_BACKTEST`n`$BT = `$env:BERSAGLIO`nStart-Process powershell.exe -ArgumentList @('-File',`$d)" },
    @{ nome="ROUND CATTIVO: Invoke-Expression"; atteso=$false; txt="# RUNNER_ROUND_BACKTEST`n`$BT = 'C:\MT5_Backtest'`nInvoke-Expression `$roba" },
    @{ nome="ROUND CATTIVO: Stop-Process";   atteso=$false; txt="# RUNNER_ROUND_BACKTEST`n`$BT = 'C:\MT5_Backtest'`nGet-Process terminal64 | Stop-Process -Force" },
    @{ nome="ROUND CATTIVO: Remove-Item";    atteso=$false; txt="# RUNNER_ROUND_BACKTEST`n`$BT = 'C:\MT5_Backtest'`nRemove-Item `$BT -Recurse" },
    @{ nome="ROUND CATTIVO: avvia un exe qualunque"; atteso=$false; txt="# RUNNER_ROUND_BACKTEST`n`$BT = 'C:\MT5_Backtest'`nStart-Process 'C:\roba\strano.exe'" },
    @{ nome="CATTIVO: TUTTI E DUE i marcatori"; atteso=$false; txt="# RUNNER_SOLA_LETTURA`n# RUNNER_ROUND_BACKTEST`n`$BT = 'C:\MT5_Backtest'`nGet-Date" },
    @{ nome="LETTURA CATTIVO: avvia un processo"; atteso=$false; txt="# RUNNER_SOLA_LETTURA`n`$BT = 'C:\MT5_Backtest'`nStart-Process powershell.exe -ArgumentList '-File x.ps1'" },
    @{ nome="LETTURA CATTIVO: avvia metatester"; atteso=$false; txt="# RUNNER_SOLA_LETTURA`n& 'C:\MT5_Backtest\metatester64.exe'" },
    @{ nome="LETTURA CATTIVO: scrive con Out-File"; atteso=$false; txt="# RUNNER_SOLA_LETTURA`n'x' | Out-File referto.txt" },
    @{ nome="LETTURA BUONO: nomina il piccolo"; atteso=$true; txt="# RUNNER_SOLA_LETTURA`nWrite-Host 'la sedia deve stare sul piccolo 50503392'" },

    # ---- I TRE INSIDIOSI. Sono i casi che mi fanno piu' paura, perche'
    #      passerebbero in un cancello scritto in modo ragionevole.
    #  (1) IL DECOY IN CODA ALLA RIGA. Il bersaglio "dichiarato" dentro
    #      un commento di fine riga: un cancello che salta solo i
    #      commenti di RIGA INTERA lo accetta, e il round parte su un
    #      terminale che non e' il banco. E' il piu' insidioso di tutti
    #      perche' il testo giusto E' nel file, alla riga giusta.
    @{ nome="INSIDIOSO 1: bersaglio nel commento in CODA"; atteso=$false;
       txt="# RUNNER_ROUND_BACKTEST`n`$b = 'D:\MT5_Altro'`nStart-Process (Join-Path `$b 'terminal64.exe')   # bersaglio C:\MT5_Backtest, giuro" },
    #  (2) LA RIASSEGNAZIONE. La variabile nasce buona e cambia dopo:
    #      chi guarda solo "e' mai stata assegnata al banco?" passa.
    @{ nome="INSIDIOSO 2: variabile riassegnata"; atteso=$false;
       txt="# RUNNER_ROUND_BACKTEST`n`$BT = 'C:\MT5_Backtest'`n`$BT = 'D:\MT5_Altro'`nStart-Process (Join-Path `$BT 'terminal64.exe')" },
    #  (3) LA STRINGA RICUCITA. 'MT5_Backtest' resta nel testo ma il
    #      valore vero e' un altro: un cancello che cerca la sottostringa
    #      nella parte destra dell'assegnazione ci casca.
    @{ nome="INSIDIOSO 3: percorso ricucito a runtime"; atteso=$false;
       txt="# RUNNER_ROUND_BACKTEST`n`$BT = 'C:\MT5_Backtest'`n`$BT = `$BT -replace 'MT5_Backtest','MT5_Altro'`nStart-Process (Join-Path `$BT 'terminal64.exe')" },
    #  (4) LA STESSA VARIABILE SCRITTA IN UN ALTRO MODO LEGALE. ${BT} e
    #      $script:BT sono $BT: chi cerca solo '$BT =' non vede la
    #      riassegnazione e la variabile resta approvata. Questi due casi
    #      PASSAVANO nella prima stesura di oggi.
    @{ nome="INSIDIOSO 4: riassegnata con la forma graffa"; atteso=$false;
       txt="# RUNNER_ROUND_BACKTEST`n`$BT = 'C:\MT5_Backtest'`n`${BT} = 'D:\MT5_Altro'`nStart-Process (Join-Path `$BT 'terminal64.exe')" },
    @{ nome="INSIDIOSO 5: riassegnata con l'ambito"; atteso=$false;
       txt="# RUNNER_ROUND_BACKTEST`n`$BT = 'C:\MT5_Backtest'`n`$script:BT = 'D:\MT5_Altro'`nStart-Process (Join-Path `$BT 'terminal64.exe')" },
    #  (6) IL LANCIO SENZA Start-Process: l'operatore di chiamata.
    @{ nome="INSIDIOSO 6: lancia con l'operatore &"; atteso=$false;
       txt="# RUNNER_ROUND_BACKTEST`n`$BT = 'C:\MT5_Backtest'`n& 'C:\Windows\System32\wscript.exe' 'roba.vbs'" },
    #  (7) IL PERCORSO VIETATO SPEZZATO IN DUE: la scansione a
    #      sottostringa non lo vede, e infatti NON e' G2 a fermarlo: e'
    #      G3, perche' quella variabile non porta il banco.
    @{ nome="INSIDIOSO 7: percorso vietato spezzato"; atteso=$false;
       txt="# RUNNER_ROUND_BACKTEST`n`$BT = 'C:\MT5_Backtest'`n`$x = 'C:\BCM_' + 'Reale'`nStart-Process (Join-Path `$x 'terminal64.exe')" },
    #  (8) IL CAMBIO DI VARIABILE PER VIA INDIRETTA.
    @{ nome="INSIDIOSO 8: Set-Variable"; atteso=$false;
       txt="# RUNNER_ROUND_BACKTEST`n`$BT = 'C:\MT5_Backtest'`nSet-Variable -Name BT -Value 'D:\MT5_Altro'`nStart-Process (Join-Path `$BT 'terminal64.exe')" },
    #  (9) L'ALIAS DI Start-Process.
    @{ nome="INSIDIOSO 9: alias saps"; atteso=$false;
       txt="# RUNNER_ROUND_BACKTEST`n`$BT = 'C:\MT5_Backtest'`nsaps 'C:\roba\strano.exe'" },
    # E la prova che G3b non e' aria: il banco nominato SOLO altrove non
    # basta se la riga che lancia il terminale non ci punta.
    @{ nome="ROUND CATTIVO: banco dichiarato ma riga cieca"; atteso=$false;
       txt="# RUNNER_ROUND_BACKTEST`nWrite-Host 'banco C:\MT5_Backtest'`nStart-Process (Join-Path `$env:TEMP 'terminal64.exe')" }
  )

  $ok=0; $ko=0
  foreach($c in ($casi + $casi2)){
    $r = VagliaScript $c.txt $c.nome
    $giusto = ($r.ok -eq $c.atteso)
    if($giusto){ $ok++ } else { $ko++ }
    $col = if($giusto){"Green"}else{"Red"}
    Write-Host ("  [{0}] {1,-42} -> {2}" -f $(if($giusto){"OK "}else{"KO "}), $c.nome, $r.motivo) -ForegroundColor $col
  }

  # ---- PARTE 3: gli ARGOMENTI della riga di coda (G4)
  Write-Host ""
  Write-Host "  --- G4: GLI ARGOMENTI DELLA RIGA DI CODA ---" -ForegroundColor Cyan
  $casi3 = @(
    @{ nome="ARG BUONO: etichetta e basta";  corsia="ROUND";   atteso=$true;  arg="-Etichetta R125a -Modello 4" },
    @{ nome="ARG BUONO: il banco esplicito"; corsia="ROUND";   atteso=$true;  arg="-TerminaleBacktest C:\MT5_Backtest" },
    @{ nome="ARG CATTIVO: bersaglio REALE";  corsia="ROUND";   atteso=$false; arg="-TerminaleBacktest C:\BCM_Reale" },
    @{ nome="ARG CATTIVO: bersaglio 100k";   corsia="ROUND";   atteso=$false; arg="-TerminaleBacktest C:\Program Files\BCM Markets MT5 Terminal -V3" },
    @{ nome="ARG CATTIVO: percorso estraneo";corsia="ROUND";   atteso=$false; arg="-Cartella D:\roba\altro" },
    @{ nome="ARG CATTIVO: esegue testo";     corsia="ROUND";   atteso=$false; arg="-X Invoke-Expression" },
    @{ nome="ARG CATTIVO (lettura): scrive"; corsia="LETTURA"; atteso=$false; arg="-Out Set-Content" }
  )
  foreach($c in $casi3){
    $r = VagliaArgomenti $c.arg $c.corsia
    $giusto = ($r.ok -eq $c.atteso)
    if($giusto){ $ok++ } else { $ko++ }
    $col = if($giusto){"Green"}else{"Red"}
    Write-Host ("  [{0}] {1,-42} -> {2}" -f $(if($giusto){"OK "}else{"KO "}), $c.nome, $r.motivo) -ForegroundColor $col
  }

  Write-Host ""
  Write-Host ("COLLAUDO: " + $ok + " giusti, " + $ko + " sbagliati su " + ($ok+$ko)) -ForegroundColor $(if($ko -eq 0){"Green"}else{"Red"})
  if($ko -gt 0){ exit 1 }
  exit 0
}

# =====================================================================
#  -Installa : registra l'attivita' pianificata e finisce qui.
#  Stesso schema di pubblica_trades.ps1, che sul VPS funziona dall'11/08.
# =====================================================================
if($Installa){
  Titolo "INSTALLAZIONE DELL'ATTIVITA' PIANIFICATA"
  New-Item -ItemType Directory -Force -Path $DestDir | Out-Null
  $dest = Join-Path $DestDir "runner_abtg.ps1"
  Copy-Item -LiteralPath $PSCommandPath -Destination $dest -Force
  Write-Host ("  copiato in: " + $dest)
  $task   = "ABTG_Runner"
  $azione = "powershell -NoProfile -ExecutionPolicy Bypass -File $dest"

  # 07/09/2026, DIFETTO PAGATO AL PRIMO INSTALL. schtasks scrive su stderr
  # anche quando va tutto bene -- il /Delete di un'attivita' che NON ESISTE
  # ANCORA (cioe' sempre, al primo giro) stampa "Impossibile trovare il file
  # specificato". Con $ErrorActionPreference='Stop' quello diventa un errore
  # TERMINANTE e la corsa muore PRIMA del /Create. Il commento di
  # pubblica_trades.ps1 lo diceva gia' ("schtasks scrive su stderr anche
  # quando va tutto bene") e io avevo copiato lo schema senza la protezione.
  # Qui: stderr viene inghiottito DENTRO cmd (>nul 2>nul), cosi' PowerShell
  # non lo vede proprio, e l'EAP viene abbassato solo per queste due righe.
  #
  # >>> ONESTA': IL DIFETTO NON E' STATO RIPRODOTTO AL BANCO. Chi scrive gira
  #     PowerShell 7 su Linux e li' il caso A (stderr visibile, EAP=Stop) NON
  #     muore. Sul VPS gira Windows PowerShell 5.1, che si comporta
  #     diversamente. Cio' che E' un fatto e' DOVE e' morto: il messaggio
  #     diceva "runner_abtg.ps1:175 car:3" e la 175 era esattamente la riga
  #     del /Delete. Quindi questa correzione e' una IPOTESI ben motivata,
  #     non una riparazione dimostrata -- ed e' il motivo per cui subito
  #     sotto c'e' la VERIFICA sull'artefatto: se l'ipotesi fosse sbagliata,
  #     la riga lo DICE invece di lasciare mezza installazione.
  $eapPrima = $ErrorActionPreference
  $ErrorActionPreference = "Continue"
  cmd /c "schtasks /Delete /TN $task /F >nul 2>nul" | Out-Null
  $out = cmd /c "schtasks /Create /TN $task /TR ""$azione"" /SC DAILY /ST $Ora /F 2>&1"
  $ErrorActionPreference = $eapPrima

  # E IL VERDETTO STA SULL'ARTEFATTO, NON SUL CODICE DI USCITA (classe 154):
  # si interroga l'attivita' e si pretende di ritrovarla.
  $ErrorActionPreference = "Continue"
  $q = cmd /c "schtasks /Query /TN $task 2>&1"
  $ErrorActionPreference = $eapPrima
  $registrata = @($q | Where-Object { $_ -match [regex]::Escape($task) }).Count -gt 0
  if(-not $registrata){
    Write-Host "ERRORE: l'attivita' NON risulta registrata. Uscita di schtasks:" -ForegroundColor Red
    $out | ForEach-Object { Write-Host ("  " + $_) -ForegroundColor Red }
    Write-Host "  (se dice 'Accesso negato': lancia PowerShell come AMMINISTRATORE)" -ForegroundColor Yellow
    exit 1
  }
  Write-Host ("  attivita' '" + $task + "' REGISTRATA E RITROVATA, ogni giorno alle " + $Ora) -ForegroundColor Green
  $q | Where-Object { $_ -match [regex]::Escape($task) } | ForEach-Object { Write-Host ("    " + $_) -ForegroundColor Gray }
  Write-Host "  Da adesso il VPS esegue la coda da solo e pubblica i referti." -ForegroundColor Green
  Write-Host "  Per toglierla:  schtasks /Delete /TN ABTG_Runner /F" -ForegroundColor Gray
  exit 0
}

# =====================================================================
#  LA CORSA
# =====================================================================
$avvio = Get-Date
$Lavoro = Join-Path $env:USERPROFILE "abtg_runner"
New-Item -ItemType Directory -Force -Path $Lavoro | Out-Null
$RawBase = "https://raw.githubusercontent.com/$Owner/$Repo"

Titolo ("RUNNER ABTG -- " + $avvio.ToString("yyyy-MM-dd HH:mm:ss"))
Write-Host ("    " + $MARC) -ForegroundColor DarkGray
Write-Host ("    perimetro: SOLA LETTURA + ROUND sul solo banco " + $BANCO_PERC + " (conto " + $BANCO_CONTO + ")") -ForegroundColor DarkGray

$R = New-Object System.Collections.ArrayList
function W($t){ [void]$R.Add($t); Write-Host $t }

W ("REFERTO RUNNER ABTG -- " + $avvio.ToString("yyyy-MM-dd HH:mm:ss") + " (ora locale VPS)")
W ("marcatore : " + $MARC)
W ("branch    : " + $Branch)
W ("perimetro : SOLA LETTURA (report/PERIMETRO_RUNNER.md) + corsia ROUND sul solo " + $BANCO_PERC)
W ("")

# --- la coda
$urlCoda = $RawBase + "/" + $Branch + "/" + $CodaPath + "?cb=" + [Guid]::NewGuid().ToString("N")
$coda = $null
try { $coda = (Invoke-WebRequest -Uri $urlCoda -UseBasicParsing -TimeoutSec 90).Content }
catch { W ("!!! CODA NON SCARICATA: " + $_.Exception.Message); W ("ESITO: NON ESEGUITO"); $coda = $null }

$eseguiti = 0; $rifiutati = 0; $falliti = 0; $nRound = 0
$righe = @()
if($coda){
  $righe = @($coda -split "`r?`n" | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" -and -not $_.StartsWith("#") })
  W ("righe di coda: " + $righe.Count)
}

foreach($riga in $righe){
  # formato:  <pin 40 hex> | <percorso nel repo> | <argomenti opzionali>
  $parti = @($riga -split '\|') | ForEach-Object { $_.Trim() }
  W ("")
  W ("--- " + $riga)
  if($parti.Count -lt 2){ $rifiutati++; W ("    RIFIUTATO: riga malformata (servono pin|percorso)"); continue }
  $pin = $parti[0]; $perc = $parti[1]
  # NB: la variabile si chiama $argomenti e NON $args: $args e'
  # automatica in PowerShell e scriverci dentro e' un modo elegante di
  # farsi male in silenzio.
  $argomenti = if($parti.Count -ge 3){ $parti[2] } else { "" }
  if($pin -notmatch '^[0-9a-f]{40}$'){ $rifiutati++; W ("    RIFIUTATO: il pin non e' uno SHA da 40 esadecimali"); continue }
  if($perc -notmatch '^backtest_pipeline/righe/[A-Za-z0-9_.-]+\.ps1$'){
    $rifiutati++; W ("    RIFIUTATO: percorso fuori da backtest_pipeline/righe/ oppure non .ps1"); continue
  }

  $url = $RawBase + "/" + $pin + "/" + $perc + "?cb=" + [Guid]::NewGuid().ToString("N")
  $testo = $null
  try { $testo = (Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 90).Content }
  catch { $rifiutati++; W ("    RIFIUTATO: scarico fallito -- " + $_.Exception.Message); continue }

  $v = VagliaScript $testo $perc
  if(-not $v.ok){ $rifiutati++; W ("    RIFIUTATO -- " + $v.motivo); continue }
  W ("    corsia  : " + $v.corsia)
  W ("    cancelli: " + $v.motivo)

  $va = VagliaArgomenti $argomenti $v.corsia
  if(-not $va.ok){ $rifiutati++; W ("    RIFIUTATO -- " + $va.motivo); continue }
  if($argomenti){ W ("    argomenti: " + $va.motivo) }

  if($SoloControllo){ W ("    (SoloControllo: non lo eseguo)"); continue }
  if($v.corsia -eq "ROUND"){ $nRound++ }

  $nome = [IO.Path]::GetFileNameWithoutExtension($perc)
  $file = Join-Path $Lavoro ($nome + ".ps1")
  [IO.File]::WriteAllText($file, $testo)
  $log  = Join-Path $Lavoro ($nome + "_" + $avvio.ToString("yyyyMMdd_HHmmss") + ".log")
  $argv = @("-NoProfile","-ExecutionPolicy","Bypass","-File",$file)
  if($argomenti){ $argv += ($argomenti -split '\s+') }
  $t0 = Get-Date
  $p = Start-Process -FilePath "powershell.exe" -ArgumentList $argv -NoNewWindow -PassThru -Wait `
        -RedirectStandardOutput $log -RedirectStandardError ($log + ".err")
  $sec = [int]((Get-Date) - $t0).TotalSeconds
  if($p.ExitCode -eq 0){ $eseguiti++; W ("    ESEGUITO in " + $sec + "s, uscita 0") }
  else { $falliti++; W ("    ESEGUITO in " + $sec + "s, uscita " + $p.ExitCode + " -- guarda il log") }
  W ("    log: " + (Split-Path $log -Leaf))
}

W ("")
W ("--- RIEPILOGO ---")
W ("eseguiti  : " + $eseguiti + "   (di cui in corsia ROUND: " + $nRound + ")")
W ("rifiutati : " + $rifiutati)
W ("falliti   : " + $falliti)
$esito = if($righe.Count -eq 0){ "CODA VUOTA -- niente da fare" }
         elseif($eseguiti -eq 0){ "NESSUNO ESEGUITO" }
         elseif($rifiutati -gt 0 -or $falliti -gt 0){ "PARZIALE" }
         else { "COMPLETO" }
W ("ESITO: " + $esito)

$ref = Join-Path $Lavoro ("REFERTO_RUNNER_" + $avvio.ToString("yyyyMMdd_HHmmss") + ".txt")
$R -join "`r`n" | Set-Content -LiteralPath $ref -Encoding UTF8
Write-Host ""
Write-Host ("referto: " + $ref) -ForegroundColor Cyan

# =====================================================================
#  PUBBLICAZIONE SUL REPO -- stesso meccanismo di pubblica_trades.ps1
# =====================================================================
if($NonPubblicare){ Write-Host "  (-NonPubblicare: non carico niente)" -ForegroundColor DarkGray; exit 0 }

$cand = @($TokenFile, "C:\Users\Administrator\.gh_report_token.txt", (Join-Path $env:USERPROFILE ".gh_report_token.txt"))
$tok = $null
foreach($c in $cand){ if($c -and (Test-Path -LiteralPath $c)){ $tok = (Get-Content -LiteralPath $c -Raw).Trim(); break } }
if(-not $tok){ Write-Host "TOKEN NON TROVATO: il referto resta solo sul VPS." -ForegroundColor Yellow; exit 4 }

$headers = @{ Authorization = "token $tok"; "User-Agent" = "ABTG-Runner"; Accept = "application/vnd.github+json" }
$apiBase = "https://api.github.com/repos/$Owner/$Repo"

function PubblicaFile([string]$locale,[string]$repoPath){
  $b64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes($locale))
  $sha = $null
  try { $sha = (Invoke-RestMethod -Method Get -Uri "$apiBase/contents/$repoPath`?ref=$Branch" -Headers $headers).sha } catch {}
  $body = @{ message = ("Runner ABTG: referto automatico (" + (Get-Date -Format 'yyyy-MM-dd HH:mm') + ")")
             content = $b64; branch = $Branch }
  if($sha){ $body.sha = $sha }
  try {
    Invoke-RestMethod -Method Put -Uri "$apiBase/contents/$repoPath" -Headers $headers -Body ($body | ConvertTo-Json) -ContentType "application/json" | Out-Null
    Write-Host ("  OK pubblicato: " + $repoPath) -ForegroundColor Green
    return $true
  } catch {
    Write-Host ("  PUBBLICAZIONE FALLITA (" + $repoPath + "): " + $_.Exception.Message) -ForegroundColor Red
    return $false
  }
}

Titolo "PUBBLICAZIONE"
$base = "backtest_pipeline/coda/referti/"
[void](PubblicaFile $ref ($base + (Split-Path $ref -Leaf)))
foreach($l in @(Get-ChildItem $Lavoro -Filter "*.log" -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -ge $avvio })){
  [void](PubblicaFile $l.FullName ($base + $l.Name))
}
Write-Host ""
Write-Host ("ESITO: " + $esito) -ForegroundColor $(if($esito -eq "COMPLETO"){"Green"}else{"Yellow"})
exit 0
