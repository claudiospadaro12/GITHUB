# =====================================================================
#  PULIZIA_DESKTOP.ps1  --  MARCATORE_PULIZIA_DESKTOP_v1
#
#  COSA FA: prende le CARTELLE di lavoro sparse sul Desktop del VPS e le
#  SPOSTA tutte dentro una sola cartella, Desktop\ARCHIVIO_LAVORI.
#
#  Richiesta di Claudio, 20/09/2026: "archivia tutte le cartelle gialle
#  dei lavori in una unica cartella".
#
#  ---------------------------------------------------------------
#  NON CANCELLA NIENTE. MAI.
#  Non c'e' una sola Remove-Item in questo file: solo Move-Item dentro
#  lo stesso disco, che e' istantaneo e si annulla trascinando indietro.
#  E il referto elenca ogni spostamento, cosi' il ritorno e' possibile
#  anche fra un mese.
#
#  ATTENZIONE, ed e' una cosa che va detta e non nascosta: spostare una
#  cartella DENTRO lo stesso disco NON LIBERA SPAZIO. Riordina e basta.
#  Se il problema e' il disco pieno davvero (e non le icone), serve
#  un'altra riga che comprime o porta via: si chiede e si fa.
#
#  ---------------------------------------------------------------
#  COSA NON TOCCA, elencato per NOME e non "tutto il resto" (classe 180):
#    - i FILE: solo cartelle. Le pagelle, gli zip, i .txt restano dove
#      sono, in vista.
#    - i COLLEGAMENTI (.lnk): sono le icone che servono per lavorare.
#    - qualunque cartella che contenga, a qualsiasi profondita',
#      terminal64.exe o metaeditor64.exe -> e' un MT5 INSTALLATO, e
#      spostarlo gli cambierebbe la cartella dati (l'hash nasce dal
#      percorso del programma) lasciando orfano tutto il resto.
#    - le cartelle il cui nome e' ESATTAMENTE quello di un'installazione
#      nota: FTMO, MT5_Backtest, MT5_MANUALE, BCM_Reale, MetaQuotes,
#      "MetaTrader 5", "Program Files". E' nome ESATTO, non sottostringa:
#      una cartella di RISULTATI come SCHIERA_FTMO_2026-09-20_101118
#      viene archiviata, ed e' giusto -- e' esattamente cio' che Claudio
#      ha chiesto di mettere via.
#    - le giunzioni/collegamenti a cartella (ReparsePoint).
#    - la cartella ARCHIVIO_LAVORI stessa.
#
#  BERSAGLIO: finestra PowerShell sul VPS. NON tocca NESSUN terminale
#  MT5: non apre, non chiude, non compila, non manda ordini. Lavora
#  solo dentro il Desktop dell'utente che la lancia.
#
#  USO:
#    .\PULIZIA_DESKTOP.ps1              -> PROVA A VUOTO (non muove niente)
#    .\PULIZIA_DESKTOP.ps1 -Esegui      -> sposta davvero
#
#  USCITE: 0 fatto (o prova riuscita) . 1 rifiuto . 2 niente da fare
# =====================================================================

param(
  [switch]$Esegui,
  [string]$Archivio = 'ARCHIVIO_LAVORI'
)

$ErrorActionPreference = 'Stop'
$INV = [Globalization.CultureInfo]::InvariantCulture
$CRONO = [Diagnostics.Stopwatch]::StartNew()

# ---------------------------------------------------------------------
# LA PROTEZIONE A NOME E' PER NOME ESATTO, NON PER SOTTOSTRINGA.
# Provato sul banco il 20/09: con la lista a sottostringa ('*FTMO*')
# venivano PROTETTE proprio le cartelle che Claudio vuole archiviare --
# SCHIERA_FTMO_2026-09-20_101118, PREVOLO_FTMO_..., MISURA_LOTTI_... --
# cioe' lo script rifiutava di fare il suo mestiere e lo chiamava
# sicurezza. La vera prova che una cartella e' un MT5 INSTALLATO e'
# l'eseguibile dentro, non il nome: quella resta e basta da sola.
# Qui sotto restano solo i nomi ESATTI delle installazioni note.
# ---------------------------------------------------------------------
$NOMI_ESATTI_PROTETTI = @('FTMO','MT5_Backtest','MT5_MANUALE','BCM_Reale','MetaQuotes','MetaTrader 5','Program Files')
$ESEGUIBILI_MT5 = @('terminal64.exe','metaeditor64.exe','terminal.exe','metaeditor.exe')

$STAMPA = (Get-Date).ToString('yyyy-MM-dd_HHmmss', $INV)
$RIGHE = New-Object System.Collections.ArrayList

function Dillo($t, $c) {
  if($c){ Write-Host $t -ForegroundColor $c } else { Write-Host $t }
  [void]$RIGHE.Add($t)
}

# Il Desktop puo' tornare stringa vuota (profilo non caricato): si
# controlla, non si spera. Stesso ripiego delle altre righe di casa.
$desktop = [Environment]::GetFolderPath('Desktop')
if([string]::IsNullOrWhiteSpace($desktop)){ $desktop = Join-Path $env:USERPROFILE 'Desktop' }

Dillo '=====================================================================' 'Cyan'
Dillo ' PULIZIA DESKTOP -- sposta le cartelle di lavoro in una sola' 'Cyan'
Dillo '=====================================================================' 'Cyan'
Dillo (' Desktop : ' + $desktop) $null
Dillo (' ora     : ' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss', $INV)) $null
if($Esegui){ Dillo ' MODO    : ESEGUI (sposta davvero)' 'Yellow' }
else       { Dillo ' MODO    : PROVA A VUOTO -- non muove niente. Aggiungi -Esegui per farlo.' 'Green' }
Dillo ' NON CANCELLA NIENTE: solo Move-Item dentro lo stesso disco.' 'Green'
Dillo '' $null

if(-not (Test-Path -LiteralPath $desktop)){
  Dillo ('FERMO: non esiste ' + $desktop) 'Red'
  exit 1
}

$dirArch = Join-Path $desktop $Archivio

# ---------------------------------------------------------------------
# LA CERNITA. Ogni cartella o entra in lista, o viene ESCLUSA con il
# motivo stampato: non esistono scarti silenziosi.
# ---------------------------------------------------------------------
$tutte = @(Get-ChildItem -LiteralPath $desktop -Directory -Force -ErrorAction SilentlyContinue)
Dillo ('cartelle sul Desktop: ' + $tutte.Count.ToString($INV)) $null
Dillo '' $null

$daSpostare = @()
foreach($d in $tutte){

  if($d.Name -ieq $Archivio){
    Dillo ('  SALTATA   ' + $d.Name + '   = e la cartella di archivio stessa') 'DarkGray'
    continue
  }

  if(($d.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0){
    Dillo ('  SALTATA   ' + $d.Name + '   = e una giunzione/collegamento a cartella, non una cartella vera') 'Yellow'
    continue
  }

  $protetto = ''
  foreach($n in $NOMI_ESATTI_PROTETTI){ if($d.Name -ieq $n){ $protetto = $n } }
  if($protetto){
    Dillo ('  PROTETTA  ' + $d.Name + '   = nome esatto di un installazione nota') 'Yellow'
    continue
  }

  # Il controllo che conta: dentro c'e' un MT5 installato?
  $exe = ''
  foreach($e in $ESEGUIBILI_MT5){
    $trovato = @(Get-ChildItem -LiteralPath $d.FullName -Filter $e -Recurse -File -Force -ErrorAction SilentlyContinue | Select-Object -First 1)
    if($trovato.Count -gt 0){ $exe = $e; break }
  }
  if($exe){
    Dillo ('  PROTETTA  ' + $d.Name + '   = dentro c e ' + $exe + ': e un MT5 INSTALLATO, spostarlo gli cambia la cartella dati') 'Red'
    continue
  }

  $daSpostare += $d
  Dillo ('  da spostare  ' + $d.Name) 'Cyan'
}

Dillo '' $null
if($daSpostare.Count -eq 0){
  Dillo 'NIENTE DA FARE: nessuna cartella da archiviare.' 'Green'
  exit 2
}
Dillo ('DA SPOSTARE: ' + $daSpostare.Count.ToString($INV) + ' cartelle su ' + $tutte.Count.ToString($INV)) 'Cyan'

if(-not $Esegui){
  Dillo '' $null
  Dillo ('Finirebbero tutte dentro: ' + $dirArch) 'Green'
  Dillo 'NON HO SPOSTATO NIENTE. Per farlo davvero rilancia con  -Esegui .' 'Green'
  exit 0
}

# ---------------------------------------------------------------------
# LO SPOSTAMENTO. Uno per uno, dentro try/catch: se uno fallisce (una
# cartella aperta in Esplora risorse basta), gli altri proseguono e alla
# fine si dice quali sono rimasti indietro -- mai un'eccezione rossa e
# via, senza rendiconto (classe 486).
# ---------------------------------------------------------------------
if(-not (Test-Path -LiteralPath $dirArch)){ [void](New-Item -ItemType Directory -Path $dirArch -Force) }
Dillo '' $null
Dillo ('sposto dentro ' + $dirArch) 'Yellow'

$fatti = 0
$rimasti = @()
foreach($d in $daSpostare){
  $dest = Join-Path $dirArch $d.Name
  try {
    if(Test-Path -LiteralPath $dest){
      $dest = Join-Path $dirArch ($d.Name + '_' + $STAMPA)
      Dillo ('  nome gia presente in archivio: la metto come ' + (Split-Path $dest -Leaf)) 'Yellow'
    }
    Move-Item -LiteralPath $d.FullName -Destination $dest -Force
    Dillo ('  SPOSTATA  ' + $d.Name) 'Green'
    $fatti = $fatti + 1
  } catch {
    Dillo ('  NON SPOSTATA  ' + $d.Name + '   -> ' + $_.Exception.Message) 'Red'
    $rimasti += $d.Name
  }
}

Dillo '' $null
Dillo '---------------------------------------------------------------------' 'Cyan'
Dillo (' SPOSTATE: ' + $fatti.ToString($INV) + '   rimaste indietro: ' + $rimasti.Count.ToString($INV)) 'Cyan'
Dillo (' durata: ' + $CRONO.Elapsed.TotalSeconds.ToString('0.0', $INV) + ' s') 'Cyan'
Dillo '---------------------------------------------------------------------' 'Cyan'
if($rimasti.Count -gt 0){
  Dillo ' Le rimaste indietro sono quasi sempre cartelle APERTE in Esplora' 'Yellow'
  Dillo ' risorse o in un prompt: chiudi la finestra e rilancia, riprende da solo.' 'Yellow'
  foreach($r in $rimasti){ Dillo ('   - ' + $r) 'Yellow' }
}
Dillo '' $null
Dillo ' NIENTE E STATO CANCELLATO. Per riportare indietro una cartella basta' 'Green'
Dillo ' trascinarla fuori da ARCHIVIO_LAVORI: il referto elenca tutti i nomi.' 'Green'

try {
  $f = Join-Path $desktop ('PULIZIA_DESKTOP_' + $STAMPA + '.txt')
  [IO.File]::WriteAllText($f, ($RIGHE -join "`r`n"), [Text.Encoding]::UTF8)
  Write-Host ('referto: ' + $f) -ForegroundColor Green
} catch { Write-Host 'referto non scritto (non e grave: l elenco e qui sopra).' -ForegroundColor Yellow }

if($rimasti.Count -gt 0){ exit 1 }
exit 0
