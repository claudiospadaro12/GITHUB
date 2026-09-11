# =====================================================================
#  MARCATORE_RIGA_ROUND_VPS_v1
#  RIGA_ROUND_VPS.ps1 -- UN ROUND QUALUNQUE SUL TERMINALE DA BACKTEST
# ---------------------------------------------------------------------
#  PERCHE' ESISTE (08/09/2026)
#  Oggi il PASSO 7 e' passato: C:\MT5_Backtest (conto demo 50504400) ha
#  riprodotto ALLA CIFRA le due corse di R119 gia' agli atti
#  (report\PASSO7_ANCORA_SUPERATA_2026-09-08.md, RILIEVI 0). Da adesso i
#  round possono girare SUL VPS e non solo sul PC di Claudio.
#  Ma RIGA_ANCORA_R119.ps1 e' CABLATA sulle due sedie dell'ancora e sui
#  loro quattro numeri attesi: serve per il passo 7, non per un round.
#  Questa e' la versione GENERICA: stesse guardie, stessi cancelli,
#  nessun numero atteso.
#
#  COSA FA (e cosa NON fa)
#   - ESEGUE un round: scarica il driver e il file prova dal PIN, chiude
#     SOLO il terminale da backtest, lancia walkforward_generico.ps1,
#     raccoglie i CSV e scrive un referto sul Desktop.
#   - NON GIUDICA. Qui non ci sono numeri attesi ne' confronti: il
#     verdetto si scrive dopo, coi criteri congelati PRIMA del round.
#
#  COSA E' RIUSATO DA RIGA_ANCORA_R119.ps1 v3 (non reinventato)
#   1. le GUARDIE SUL TERMINALE -- riusate, e poi RIFATTE AL CONTRARIO
#      l'11/09/2026 (il perche' sta al PUNTO 1, piu' sotto). L'ancora
#      ELENCAVA i vietati (-V3, BCM_Reale): una lista di divieti non
#      vede il bersaglio che nessuno ci ha ancora messo, e infatti
#      lasciava passare il PICCOLO 50503392, la RADICE di un disco e i
#      nomi 8.3 di Windows. Adesso la guardia AMMETTE il banco
#      C:\MT5_Backtest e uccide tutto il resto; i divieti per nome
#      restano come seconda rete. Restano anche le guardie sulla
#      cartella che non c'e' e su terminal64.exe che manca;
#   2. il PRE-VOLO SUL TETTO BARRE (MaxBars in config\common.ini):
#      classe 160, un tetto a 100.000 fa girare su MENO storico senza
#      dirlo;
#   3. il CENSIMENTO PID PRIMA E DOPO, col confronto fatto DAL CODICE e
#      l'allarme rosso se sparisce un terminale NON bersaglio: e' la
#      prova stampata che il conto reale non e' stato toccato;
#   4. la CHIUSURA CHIRURGICA del solo terminale da backtest (classe
#      159: la guardia del driver e' GLOBALE e sul VPS i terminali sono
#      quattro) e -Force al driver;
#   5. il CONTROLLO DEL MARCATORE del driver scaricato (classe 161:
#      senza la v5 il driver non porta gli #include nostri, l'EA non
#      compila e il round muore con ZERO CSV);
#   6. la RACCOLTA con zip sul Desktop e il REFERTO con la riga 'data:'.
#
#  COSA CAMBIA RISPETTO ALL'ANCORA
#   - niente numeri attesi, niente confronto, niente "RIPRODUCE";
#   - il referto stampa, per OGNI CSV prodotto (IS e OOS): quante righe
#     e, per ognuna, Profit / PF / Equity DD % / Trades. Cosi' il
#     risultato si legge senza aprire il CSV;
#   - IL CANCELLO CHE CONTA: se il CSV non c'e' o Trades = 0, il referto
#     lo dice a chiare lettere ->
#        "Trades=0 non vuol dire nessun edge, vuol dire NON E' GIRATA:
#         guardare il log"
#     E' l'errore del verdetto PostNews del 07/08, gia' pagato una volta.
#
#  CODICI D'USCITA (il gate sta sull'ARTEFATTO, non sul rc del driver --
#  classe 154: il codice che torna dal driver e' quello dell'ultimo .exe
#  lanciato dentro, non il suo)
#     0 = ROUND GIRATO          (i due CSV ci sono, freschi, con Trades>0)
#     2 = NON MISURATO          (CSV assente/vuoto, oppure Trades=0)
#     3 = GIRATO CON RILIEVI    (i numeri ci sono ma qualcosa va guardato)
#     1 = non e' nemmeno partito (pre-volo fallito)
#  La RACCOLTA si fa SEMPRE, anche a esito 2: un round che non e' girato
#  e' gia' una risposta, e il referto va mandato lo stesso (punto 26-bis).
#
#  USO -- IL PRIMO ROUND CHE DEVE LANCIARE (PASSO 0 di conteggio)
#    -Expert "ABTG_OpeningReversalB"
#    -Prova  "ABTG_OpeningReversalB_00_conta.txt"
#    -Etichetta "P0CONTA"
#  (U30USD M5, EA nel repo dal 30/08 e MAI girato; la cella e' gia'
#   committata e validata: 27 input pin, 2 celle, 4 passate.)
#
#  PRIMA LA PROVA A VUOTO (-SoloControllo), SEMPRE. E si sappia cosa NON
#  copre, perche' e' scritto in checklist e non e' cambiato:
#    - punto 39: il -SoloControllo del driver generico NON COMPILA. Un
#      #include mancante salta fuori solo a corsa avviata;
#    - punto 31: nel ramo di prova del driver Model=4 e' HARDCODED, cioe'
#      con -Modello 1 l'anteprima .ini dice comunque Model=4 (Deposit
#      invece e' la variabile vera, verificato riga per riga);
#    - il driver esce PRIMA di scegliere il terminale: il giro a vuoto
#      NON collauda -TerminaleBacktest.
#
#  NIENTE EMOJI: Windows PowerShell 5.1 legge i .ps1 come ANSI.
# =====================================================================

param(
  [Parameter(Mandatory=$true)][string]$Expert,
  [Parameter(Mandatory=$true)][string]$Prova,
  [Parameter(Mandatory=$true)][string]$Etichetta,
  [string]$Pin               = "lavoro",
  [string]$TerminaleBacktest = "C:\MT5_Backtest",
  [int]$Modello              = 4,
  [int]$Deposito             = 10000,
  [string]$Work              = "$env:USERPROFILE\abtg_round",
  [switch]$ChiudiBacktest,
  [switch]$SoloControllo
)

$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$MARC_MIO = "MARCATORE_RIGA_ROUND_VPS_v1"
$MARC_DRV = "MARCATORE_WALKFORWARD_GENERICO_v5_INCLUDE"
$RawBase  = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"
$Avvio    = Get-Date

# Il testo del cancello sta in UNA variabile sola: console e referto non
# possono dire due cose diverse (classe 119-bis).
$TESTO_TRADES0 = "Trades=0 non vuol dire nessun edge, vuol dire NON E' GIRATA: guardare il log"

$RILIEVI = New-Object System.Collections.ArrayList
function Muori($m){ Write-Host ""; Write-Host ("ERRORE: " + $m) -ForegroundColor Red; exit 1 }
function Rilievo($m){ [void]$RILIEVI.Add($m); Write-Host ("    RILIEVO: " + $m) -ForegroundColor DarkYellow }

# =====================================================================
#  FUNZIONI PURE -- stanno qui in cima perche' sono COLLAUDABILI OFFLINE
#  (banco: report\RIGA_ROUND_VPS_2026-09-08.md, sezione COLLAUDI)
# =====================================================================

# Cultura invariante SEMPRE: su it-IT "2.0" letto senza InvariantCulture
# diventa 20 (checklist, punto 5).
function NumInv($s){
  if($null -eq $s){ return $null }
  $t = ("" + $s).Trim().Replace(",",".")
  if($t -eq ""){ return $null }
  $v = 0.0
  if([double]::TryParse($t,[Globalization.NumberStyles]::Float,[Globalization.CultureInfo]::InvariantCulture,[ref]$v)){ return $v }
  return $null
}

# Un nome che finisce in una URL e in un nome di file non puo' contenere
# separatori di percorso ne' spazi.
function NomeValido([string]$s){
  if($null -eq $s){ return $false }
  if($s.Trim() -eq ""){ return $false }
  return ($s -match '^[A-Za-z0-9_.-]+$')
}

# L'etichetta e' il suffisso dei CSV: solo lettere, cifre e underscore.
function EtichettaValida([string]$s){
  if($null -eq $s){ return $false }
  if($s.Trim() -eq ""){ return $false }
  return ($s -match '^[A-Za-z0-9_]+$')
}

# Le direttive @ del file prova, lette RIGA PER RIGA: niente regex
# multilinea, cosi' il CRLF non puo' far fallire il match (classe 40).
function DirettivaProva([string]$file,[string]$nome){
  if(-not (Test-Path -LiteralPath $file -PathType Leaf)){ return "" }
  $righe = @()
  try{ $righe = @(Get-Content -LiteralPath $file -ErrorAction Stop) }catch{ return "" }
  foreach($r in $righe){
    $t = ("" + $r).Trim()
    if(-not $t.StartsWith("@")){ continue }
    if($t -match '^@(\w+)\s+(.+)$'){
      if($Matches[1].ToUpper() -eq $nome.ToUpper()){ return $Matches[2].Trim() }
    }
  }
  return ""
}

# Il tetto delle barre nel grafico, dal config\common.ini della cartella
# dati. Torna $null se la chiave non c'e' (= NON VERIFICATO, che si
# dichiara: non si finge di averlo controllato).
function TettoBarre([string]$dataFolder){
  if(-not $dataFolder){ return $null }
  $ciFile = Join-Path $dataFolder "config\common.ini"
  if(-not (Test-Path -LiteralPath $ciFile)){ return $null }
  $val = $null
  foreach($l in @(Get-Content -LiteralPath $ciFile -ErrorAction SilentlyContinue)){
    if($l -match '^\s*MaxBars(InChart)?\s*=\s*([0-9]+)\s*$'){ $val = [int64]$Matches[2] }
  }
  return $val
}

# Legge un CSV di ottimizzazione e ne tira fuori SOLO quello che serve a
# LEGGERE il round senza aprire il file. Non giudica niente.
function LeggiCsvRound([string]$path,$t0){
  $e = [pscustomobject]@{
    Path       = $path
    Presente   = $false
    Fresco     = $false
    NRighe     = 0
    Righe      = @()
    ConTrades  = 0
    ZeroTrades = 0
    Problema   = ""
  }
  if(-not (Test-Path -LiteralPath $path -PathType Leaf)){
    $e.Problema = "CSV ASSENTE"
    return $e
  }
  $e.Presente = $true
  $it = Get-Item -LiteralPath $path
  if($null -ne $t0 -and $it.LastWriteTime -lt $t0){
    # Classe 155: la cartella di lavoro e' riusabile. Un CSV vecchio col
    # nome giusto non e' il risultato di questa corsa.
    $e.Problema = "CSV NON FRESCO (scritto il " + $it.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss") + ", la corsa e' partita dopo)"
    return $e
  }
  $e.Fresco = $true
  if($it.Length -eq 0){
    $e.Problema = "CSV DA 0 BYTE"
    return $e
  }
  $righe = @()
  try{ $righe = @(Import-Csv -LiteralPath $path -ErrorAction Stop) }catch{
    $e.Problema = "CSV NON LEGGIBILE: " + $_.Exception.Message
    return $e
  }
  $e.NRighe = $righe.Count
  if($righe.Count -eq 0){
    $e.Problema = "ZERO RIGHE (solo intestazione): nessuna passata eseguita"
    return $e
  }
  $out = New-Object System.Collections.ArrayList
  $i = 0
  foreach($r in $righe){
    $pass = ("" + $r.'Pass').Trim()
    if($pass -eq ""){ $pass = ("" + $i) }
    $tr = NumInv $r.'Trades'
    $ri = [pscustomobject]@{
      Pass   = $pass
      Profit = (NumInv $r.'Profit')
      PF     = (NumInv $r.'Profit Factor')
      DD     = (NumInv $r.'Equity DD %')
      Trades = $tr
    }
    if($null -eq $tr){ $e.Problema = "colonna Trades non leggibile (il CSV non ha l'intestazione attesa)" }
    elseif([int]$tr -eq 0){ $e.ZeroTrades = $e.ZeroTrades + 1 }
    else{ $e.ConTrades = $e.ConTrades + 1 }
    [void]$out.Add($ri)
    $i = $i + 1
  }
  $e.Righe = @($out)
  return $e
}

# Le righe del referto per UN CSV. Ritorna un array di stringhe: la
# stessa cosa che finisce a schermo e nel file (nessuna divergenza).
function RigheReferto($e,[string]$nome,[string]$testoTrades0){
  $R = New-Object System.Collections.ArrayList
  [void]$R.Add("--- " + $nome + " ---")
  [void]$R.Add("  file  : " + $e.Path)
  if(-not $e.Presente -or -not $e.Fresco -or $e.NRighe -eq 0){
    [void]$R.Add("  ESITO : NON MISURATO -- " + $e.Problema)
    [void]$R.Add("  >>> " + $testoTrades0)
    return @($R)
  }
  [void]$R.Add("  righe : " + $e.NRighe)
  # ATTENZIONE: la variabile del ciclo NON puo' chiamarsi $r -- PowerShell
  # non distingue le maiuscole e schiaccerebbe $R, l'elenco che stiamo
  # costruendo. Trovato dal banco, non a mente.
  foreach($rg in $e.Righe){
    $vp  = if($null -eq $rg.Profit){ "?" } else { $rg.Profit.ToString([Globalization.CultureInfo]::InvariantCulture) }
    $vpf = if($null -eq $rg.PF)    { "?" } else { $rg.PF.ToString([Globalization.CultureInfo]::InvariantCulture) }
    $vdd = if($null -eq $rg.DD)    { "?" } else { $rg.DD.ToString([Globalization.CultureInfo]::InvariantCulture) }
    $vtr = if($null -eq $rg.Trades){ "?" } else { ([int]$rg.Trades).ToString([Globalization.CultureInfo]::InvariantCulture) }
    [void]$R.Add("    Pass " + ("" + $rg.Pass).PadRight(4) + " Profit " + $vp.PadRight(12) + " PF " + $vpf.PadRight(10) + " Equity DD % " + $vdd.PadRight(10) + " Trades " + $vtr)
  }
  if($e.Problema -ne ""){ [void]$R.Add("  nota  : " + $e.Problema) }
  if($e.ConTrades -eq 0){
    [void]$R.Add("  ESITO : NON MISURATO -- TRADES = 0 su tutte le " + $e.NRighe + " righe")
    [void]$R.Add("  >>> " + $testoTrades0)
  }
  elseif($e.ZeroTrades -gt 0){
    [void]$R.Add("  ESITO : LETTO, ma " + $e.ZeroTrades + " righe su " + $e.NRighe + " hanno Trades = 0")
    [void]$R.Add("  >>> " + $testoTrades0)
  }
  else{
    [void]$R.Add("  ESITO : LETTO -- " + $e.NRighe + " righe, tutte con Trades > 0")
  }
  return @($R)
}

# ---------------------------------------------------------------------
#  IL BANCO. E' UNA COSTANTE, e da qui in avanti e' LA SOLA cosa che il
#  resto dello script usa come bersaglio: la stringa arrivata da fuori
#  serve solo a essere GIUDICATA, mai a essere usata.
# ---------------------------------------------------------------------
$BANCO_PERC  = "C:\MT5_Backtest"
$BANCO_CONTO = "50504400"

# I vietati per NOME. NON decidono piu' niente -- decide la guardia
# positiva qui sotto -- ma servono a due cose che contano: dare il
# messaggio GIUSTO (chi e' il terminale che stavi per toccare, col suo
# numero di conto in chiaro, regola dei terminali multipli del 06/09), e
# fare da seconda rete se un domani qualcuno allentasse il confronto.
$TERMINALI_VIETATI = @(
  @{ p = "BCM_Reale";                chi = "il terminale del conto REALE 10105439" },
  @{ p = "-V3";                      chi = "il terminale del 100k, conto 50504263" },
  @{ p = "BCM Markets MT5 Terminal"; chi = "un terminale con SEDIE VIVE sopra: il piccolo 50503392 (e il 100k, che sta nella stessa famiglia di cartelle)" },
  @{ p = "10105439";                 chi = "il conto REALE" },
  @{ p = "50504263";                 chi = "il 100k" },
  @{ p = "50503392";                 chi = "il piccolo" }
)

# Canonicalizza UNA SCRITTURA DI PERCORSO DI WINDOWS: '/' diventa '\',
# i separatori doppi si collassano, '.' e '..' si risolvono, il
# separatore finale sparisce. Torna "" quando la forma NON e' riducibile
# a un percorso ancorato a una lettera di disco -- e "" vuol dire NO.
# Regola dichiarata: cio' che non so risolvere lo RIFIUTO, non lo
# indovino. L'errore cade sempre verso il no.
#
# PERCHE' NON USO [IO.Path]::GetFullPath(), che farebbe le prime quattro
# cose da solo: perche' il suo risultato DIPENDE DALLA PIATTAFORMA e dal
# runtime. Su Linux -- dove questa guardia e' stata collaudata riga per
# riga -- '\' non e' un separatore e GetFullPath("C:\MT5_Backtest")
# torna "<cartella corrente>/C:\MT5_Backtest"; fra .NET Framework 4 (il
# VPS) e .NET Core cambia anche il trattamento di punti e spazi finali.
# Una guardia il cui significato cambia col runtime e' una guardia che
# non si puo' collaudare, e una che non si puo' collaudare non si sa se
# protegge. Questa fa lo stesso identico conto ovunque.
# Il pezzo che il DISCO deve dire (e che nessuna stringa sa) e' un altro,
# ed e' l'attributo ReparsePoint: sta al PUNTO 1, non qui.
function NormalizzaPercorsoWin([string]$p){
  if($null -eq $p){ return "" }
  $s = ("" + $p).Trim()
  if($s -eq ""){ return "" }
  $s = $s.Replace("/","\")
  if($s.Contains("~")){ return "" }              # nome 8.3 (PROGRA~1): espanderlo richiede Win32, quindi si rifiuta
  if($s -match '[\*\?\[\]"|<>]'){ return "" }    # jolly e caratteri che in un percorso non ci vanno
  if($s -notmatch '^[A-Za-z]:\\'){ return "" }   # solo "X:\...": niente UNC, niente \\?\, niente "C:senza-barra"
  $disco = $s.Substring(0,2).ToUpper()
  $resto = $s.Substring(2)
  if($resto.Contains(":")){ return "" }          # un secondo ':' non e' un percorso (flusso NTFS, argomenti incollati)
  $pezzi = New-Object System.Collections.ArrayList
  foreach($t in $resto.Split("\")){
    if($t -eq "" -or $t -eq "."){ continue }
    if($t -eq ".."){
      if($pezzi.Count -eq 0){ return "" }        # si risale sopra la radice: forma senza senso
      $pezzi.RemoveAt($pezzi.Count - 1)
      continue
    }
    [void]$pezzi.Add($t)
  }
  if($pezzi.Count -eq 0){ return ($disco + "\") }   # la RADICE di un disco: normalizzata, e rifiutata piu' sotto
  return ($disco + "\" + ($pezzi -join "\"))
}

# La radice di un disco ("C:\", "D:\") non e' un terminale: e' TUTTO il
# disco. Ha una riga sua perche' merita un messaggio suo -- con un
# bersaglio cosi' la pipe di chiusura diventa "C:\*", cioe' ogni
# terminal64 della macchina, conto reale compreso.
function RadiceDiDisco([string]$norm){
  if($null -eq $norm){ return $false }
  return ($norm -match '^[A-Za-z]:\\$')
}

# IL VERDETTO SUL BERSAGLIO, in una funzione sola e senza effetti: torna
# "" se il bersaglio E' il banco, altrimenti il MOTIVO del rifiuto.
# L'ordine dei controlli e' scelto: prima i divieti per nome (che sanno
# dire CHI stavi per toccare), poi la normalizzazione, poi il confronto
# positivo. Il confronto positivo da solo basterebbe a rifiutare tutto
# quanto; gli altri servono a dire perche'.
function MotivoRifiutoBanco([string]$chiesto){
  $g = ("" + $chiesto).Trim()
  if($g -eq ""){ return "BERSAGLIO VUOTO: -TerminaleBacktest non dice niente." }
  foreach($v in $TERMINALI_VIETATI){
    if($g -like ("*" + $v.p + "*")){
      return ("TERMINALE VIETATO: '" + $g + "' nomina " + $v.chi + ".")
    }
  }
  $n = NormalizzaPercorsoWin $g
  if($n -eq ""){
    return ("BERSAGLIO NON RICONDUCIBILE A UNA CARTELLA DI WINDOWS: '" + $g + "'." +
            " Un nome 8.3 (PROGRA~1 = C:\Program Files scritto in un altro modo), un" +
            " percorso di rete, un \\?\, un carattere jolly o un percorso non ancorato" +
            " a un disco non si indovinano: si rifiutano.")
  }
  if(RadiceDiDisco $n){
    return ("RADICE DI UN DISCO: '" + $g + "'. Un disco intero non e' un terminale:" +
            " con un bersaglio cosi' la pipe di chiusura diventa '" + $n + "*', cioe'" +
            " OGNI terminal64 della macchina.")
  }
  # Confronto ORDINALE, non -ieq. Il -eq di PowerShell passa dalla CULTURA
  # del thread, e una regola di casa di questo stesso file e' che la cultura
  # non deve mai entrare in un confronto (vedi NumInv, qui sopra): su un
  # confronto culturale certi caratteri invisibili vengono IGNORATI, cioe'
  # due stringhe diverse risultano uguali. Qui si guardano i byte.
  if(-not [string]::Equals($n, $BANCO_PERC, [StringComparison]::OrdinalIgnoreCase)){
    return ("NON E' IL BANCO: '" + $g + "' (normalizzato: '" + $n + "').")
  }
  return ""
}

# =====================================================================
#  0. IL PRE-VOLO SUI PARAMETRI
# =====================================================================
Write-Host "=== ROUND SUL TERMINALE DA BACKTEST ==="
Write-Host ("    " + $MARC_MIO) -ForegroundColor DarkGray
Write-Host ("data: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss"))
Write-Host ("pin : " + $Pin)
Write-Host ("term: " + $TerminaleBacktest)

if(-not (NomeValido $Expert)){ Muori ("nome EA non valido: '" + $Expert + "'. Va passato il nome del .mq5 SENZA estensione e senza percorso (es. ABTG_OpeningReversalB).") }
if(-not (NomeValido $Prova)) { Muori ("nome del file prova non valido: '" + $Prova + "'. Va passato il NOME del file dentro backtest_pipeline\prove\ (es. ABTG_OpeningReversalB_00_conta.txt).") }
if(-not (EtichettaValida $Etichetta)){
  Muori ("etichetta non valida: '" + $Etichetta + "'. Ammesse lettere, cifre e underscore.`n" +
         "    L'etichetta e' il suffisso dei CSV: senza, un round nuovo SOVRASCRIVE il precedente.")
}
if($Modello -lt 0 -or $Modello -gt 4){ Muori ("-Modello ammette 0..4. Ricevuto: " + $Modello + " (4 = tick reali, la verita'; 1 = OHLC M1, SOLO screening).") }
if($Modello -ne 4){
  Write-Host ""
  Write-Host ("    ATTENZIONE: -Modello " + $Modello + ", NON tick reali. I CSV escono col suffisso _ohlc") -ForegroundColor Yellow
  Write-Host "    e servono SOLO a scremare: da qui non esce nessun verdetto." -ForegroundColor Yellow
  Rilievo ("round girato a Modello " + $Modello + " (non tick reali): screening, non verdetto")
}
if($Deposito -le 0){ Muori ("-Deposito deve essere positivo. Ricevuto: " + $Deposito) }

# =====================================================================
#  1. IL TERMINALE: LA GUARDIA E' POSITIVA (rifatta l'11/09/2026)
#
#  PRIMA ERA NEGATIVA, E PERDEVA. Diceva "non deve essere -V3 ne'
#  BCM_Reale". Eseguita con pwsh contro bersagli finti, lasciava passare
#  QUATTRO cose, e tre sono terminali veri di questa macchina:
#    C:\Program Files\BCM Markets MT5 Terminal  -> PASSAVA. E' il
#        PICCOLO 50503392, che ha sedie VIVE sopra.
#    C:\  -> PASSAVA la guardia. E li' il danno non e' teorico: la pipe
#        di chiusura poco piu' sotto e' ($cartellaBT + "\*"), che con la
#        radice diventa "C:\*" = OGNI terminal64 del disco, il conto
#        REALE 10105439 compreso.
#    C:\PROGRA~1\BCMMAR~1 -> PASSAVA. E' lo stesso posto di sopra
#        scritto in nome 8.3: la lista guarda le lettere, non il posto.
#    C:\MT5_Backtest\..\Program Files\BCM Markets MT5 Terminal ->
#        PASSAVA (trovata mentre si riparava): il nome del banco c'e',
#        ma il '..' porta altrove.
#  E' il gemello esatto del buco che il cancello del runner ha riparato
#  la mattina dell'11/09: una lista di divieti non vede il bersaglio che
#  nessuno ci ha ancora messo. Quando e' comparso un QUARTO conto che
#  nessuno conosceva (109k), a fermarlo e' stato il cancello POSITIVO.
#
#  ADESSO DICE UNA COSA SOLA: DEVE ESSERE IL BANCO.
#  Ammesso UN percorso -- C:\MT5_Backtest, demo 50504400 -- confrontato
#  DOPO normalizzazione. Tutto il resto muore, compreso cio' che non e'
#  in nessuna lista e compreso cio' che nascera' domani.
#
#  E LA NORMALIZZAZIONE E' IL PUNTO DELICATO, percio' e' scritta a
#  gradini e OGNI GRADINO CADE VERSO IL NO (NormalizzaPercorsoWin, in
#  cima al file, collaudabile offline):
#    a) passano solo le forme "X:\..."; niente UNC, niente \\?\, niente
#       "C:senza-barra" (che dipende dalla cartella corrente del disco);
#    b) '/' vale '\', i separatori doppi si collassano, '.' e '..' si
#       risolvono: sono MODI DIVERSI DI SCRIVERE LO STESSO POSTO, ed e'
#       giusto che passino -- ma solo se il posto e' il banco;
#    c) il nome 8.3 NON si indovina (espanderlo vuol dire chiamare Win32):
#       si RIFIUTA, e chi ha una ragione per usarlo scrive il nome lungo;
#    d) i jolly (* ? [ ]) si rifiutano: il bersaglio finisce dentro un
#       -like, e li' una parentesi quadra cambia il significato del
#       confronto;
#    e) il confronto e' con la COSTANTE, e da qui in avanti si usa LA
#       COSTANTE: la stringa che arriva da fuori viene giudicata e poi
#       buttata;
#    f) l'ultimo gradino lo fa il DISCO, non la stringa: se il nome
#       giusto fosse una JUNCTION verso un'altra cartella, nessun
#       controllo sul testo se ne accorgerebbe. L'attributo ReparsePoint
#       si'.
# =====================================================================
$motivoNo = MotivoRifiutoBanco $TerminaleBacktest
if($motivoNo -ne ""){
  Muori ($motivoNo + "`n" +
         "    L'UNICO terminale ammesso e' " + $BANCO_PERC + " (demo " + $BANCO_CONTO + ", solo-tester).`n" +
         "    Gli altri MT5 di questa macchina hanno SEDIE VIVE sopra e non si toccano:`n" +
         "    il piccolo 50503392, il 100k 50504263 e il conto REALE 10105439.`n" +
         "    La guardia e' POSITIVA: non elenca i vietati, ammette il banco. Se un`n" +
         "    giorno il banco cambiasse casa, si cambia QUESTA riga, a mano, e si`n" +
         "    ripassa dal cancello.")
}

# LA COSTANTE, NON LA STRINGA DI FUORI. E' questa riga che chiude il buco
# della radice del disco: la pipe qui sotto e' SEMPRE "C:\MT5_Backtest\*"
# e non puo' diventare "C:\*" per colpa di come e' stato scritto un
# argomento. Vale anche per il valore passato al driver, piu' sotto.
$cartellaBT = $BANCO_PERC
Write-Host ("    bersaglio AMMESSO dalla guardia positiva: " + $cartellaBT + "   (conto " + $BANCO_CONTO + ")") -ForegroundColor Green

if(-not (Test-Path -LiteralPath $cartellaBT -PathType Container)){ Muori ("la cartella '" + $cartellaBT + "' non esiste su questa macchina.") }

# IL GRADINO CHE NESSUNA STRINGA PUO' FARE. Un nome giusto puo' puntare
# nel posto sbagliato: basta che la cartella sia una junction o un link
# simbolico. Il testo e' identico, il posto no -- e quello lo sa solo il
# filesystem. Se e' un collegamento non si parte: non si indovina dove va.
$infoBT = $null
try  { $infoBT = Get-Item -LiteralPath $cartellaBT -Force -ErrorAction Stop }
catch{ $infoBT = $null }
if($null -eq $infoBT){
  Muori ("la cartella '" + $cartellaBT + "' non e' leggibile: non posso dire DOVE punta, e quindi non parto.")
}
if((([int]$infoBT.Attributes) -band ([int][IO.FileAttributes]::ReparsePoint)) -ne 0){
  Muori ("IL BANCO E' UN COLLEGAMENTO: '" + $cartellaBT + "' non e' una cartella vera,`n" +
         "    e' una junction (o un link simbolico) che rimanda altrove. Il nome e'`n" +
         "    quello giusto, il posto potrebbe non esserlo, e nessun controllo sulla`n" +
         "    STRINGA se ne accorgerebbe.`n" +
         "    Se il banco 50504400 e' davvero installato cosi', si guarda insieme dove`n" +
         "    punta e si cambia questa riga. Non si tira a indovinare.")
}

$exeBT = Join-Path $cartellaBT "terminal64.exe"
if(-not (Test-Path -LiteralPath $exeBT -PathType Leaf)){ Muori ("in '" + $cartellaBT + "' non c'e' terminal64.exe: va passata la CARTELLA PROGRAMMA del terminale.") }

# --- censimento PRIMA. Il bersaglio e' UNO SOLO: quello sotto $cartellaBT.
function Terminali(){ return @(Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) }
function Bersagli($proc){ return @($proc | Where-Object { $_.Path -and ($_.Path -like ($cartellaBT + "\*")) }) }
function Risparmiati($proc){ return @($proc | Where-Object { -not ($_.Path -and ($_.Path -like ($cartellaBT + "\*"))) }) }

$tutti  = Terminali
$berPri = Bersagli $tutti
$salPri = Risparmiati $tutti
$pidSalvi = @($salPri | ForEach-Object { $_.Id })

Write-Host ""
Write-Host "--- TERMINALI MT5 VISTI ADESSO (PRIMA) ------------------------------" -ForegroundColor Cyan
if($berPri.Count -eq 0){ Write-Host "  BERSAGLIO (terminale da backtest): nessuno vivo. Bene." -ForegroundColor Green }
else{
  Write-Host "  BERSAGLIO (terminale da backtest, l'unico che posso chiudere):" -ForegroundColor Yellow
  $berPri | ForEach-Object { Write-Host ("    PID " + $_.Id + "    " + $_.Path) -ForegroundColor Yellow }
}
Write-Host "  LASCIATI VIVI (forward e CONTO REALE: NON li tocco):" -ForegroundColor Green
if($salPri.Count -eq 0){ Write-Host "    (nessuno)" -ForegroundColor Green }
else{ $salPri | ForEach-Object { Write-Host ("    PID " + $_.Id + "    " + $(if($_.Path){$_.Path}else{"<percorso non leggibile: NON e' un bersaglio>"})) -ForegroundColor Green } }
Write-Host "---------------------------------------------------------------------" -ForegroundColor Cyan

if($berPri.Count -gt 0 -and -not $SoloControllo){
  if($ChiudiBacktest){
    Write-Host ""
    Write-Host "  -ChiudiBacktest: chiudo SOLO il terminale da backtest." -ForegroundColor Yellow
    $berPri | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 6
    $berPri = Bersagli (Terminali)
  }
  if($berPri.Count -gt 0){
    Muori ("il terminale da backtest e' APERTO: il tester non partirebbe e uscirebbero ZERO CSV.`n" +
           "    Chiudi a mano " + $exeBT + " oppure rilancia con -ChiudiBacktest:`n" +
           "    verra' chiuso SOLO quel processo, gli altri terminali (forward e CONTO REALE) restano vivi.")
  }
}

# =====================================================================
#  2. IL TETTO DELLE BARRE NEL GRAFICO (riuso 2 dall'ancora)
#     CLASSE 160: con un tetto a 100.000 il round gira su MENO storico e
#     nessuno lo dice. Su M5 gli indici lo sfondano da soli.
# =====================================================================
$DataFolder = ""
$termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
if(Test-Path -LiteralPath $termRoot){
  foreach($d in @(Get-ChildItem -LiteralPath $termRoot -Directory -ErrorAction SilentlyContinue)){
    if($d.Name -ieq "Common"){ continue }
    $o = Join-Path $d.FullName "origin.txt"
    if(-not (Test-Path -LiteralPath $o)){ continue }
    $inst = ""
    try{ $inst = (Get-Content -LiteralPath $o -Raw -ErrorAction Stop).Trim() }catch{ continue }
    if($inst -ieq $cartellaBT){ $DataFolder = $d.FullName; break }
  }
}
if(-not $DataFolder -and (Test-Path -LiteralPath (Join-Path $cartellaBT "config\common.ini"))){ $DataFolder = $cartellaBT }

$MaxBars = TettoBarre $DataFolder
Write-Host ""
if($null -ne $MaxBars -and $MaxBars -ge 1000 -and $MaxBars -lt 200000){
  Muori ("TETTO BARRE NEL GRAFICO = " + $MaxBars + " (config\common.ini di " + $DataFolder + ").`n" +
         "    Serve ILLIMITATO: su M5 gli indici passano le 130.000 barre.`n" +
         "    Con questo tetto il round gira su MENO storico e nessuno lo dice.`n" +
         "    Apri " + $exeBT + " (conto 50504400), Strumenti > Opzioni > Grafici >`n" +
         "    'Max barre nel grafico' = Illimitato, CHIUDI il terminale, e rilancia.")
}
elseif($null -ne $MaxBars){ Write-Host ("    tetto barre: MaxBars=" + $MaxBars + " -- sufficiente.") -ForegroundColor Green }
else{
  Write-Host "    tetto barre: NON VERIFICABILE da qui (nessuna chiave MaxBars leggibile)." -ForegroundColor Yellow
  Write-Host "    CONTROLLALO A MANO PRIMA DI LASCIAR GIRARE: Strumenti > Opzioni >" -ForegroundColor Yellow
  Write-Host "    Grafici > 'Max barre nel grafico' = Illimitato sul terminale 50504400." -ForegroundColor Yellow
  Rilievo "tetto barre nel grafico NON verificato dal codice (chiave MaxBars non trovata)"
}

# =====================================================================
#  3. DRIVER E FILE PROVA, DAL PIN (regola delle righe di lancio, p.1)
#     (riuso 5 dall'ancora: il marcatore del driver si CONTROLLA)
# =====================================================================
$Prove = Join-Path $Work "prove"
New-Item -ItemType Directory -Force -Path $Work  | Out-Null
New-Item -ItemType Directory -Force -Path $Prove | Out-Null

function Scarica($url,$dst){
  Remove-Item -LiteralPath $dst -Force -ErrorAction SilentlyContinue
  $u = $url + "?cb=" + [Guid]::NewGuid().ToString("N")   # cache di GitHub raw (~5 min)
  try  { Invoke-WebRequest -Uri $u -OutFile $dst -UseBasicParsing -TimeoutSec 120 }
  catch{ Muori ("scarico fallito: " + $url + " -- " + $_.Exception.Message) }
  if(-not (Test-Path -LiteralPath $dst)){ Muori ("file non scaricato: " + $url) }
}

$drv = Join-Path $Work "walkforward_generico.ps1"
Scarica ($RawBase + "/backtest_pipeline/walkforward_generico.ps1") $drv
if(-not (Select-String -LiteralPath $drv -SimpleMatch -Pattern $MARC_DRV -Quiet)){
  Muori ("il driver scaricato NON ha il marcatore " + $MARC_DRV + ": e' una copia vecchia. Senza la v5 non porta gli #include nostri sul terminale, l'EA non compila e il round muore con ZERO CSV. Non si prosegue.")
}
Write-Host ""
Write-Host "    driver: scaricato e marcatore v5 verificato." -ForegroundColor Green

$provaLoc = Join-Path $Prove $Prova
Scarica ($RawBase + "/backtest_pipeline/prove/" + $Prova) $provaLoc
$lenProva = (Get-Item -LiteralPath $provaLoc).Length
Write-Host ("    file prova: " + $Prova + " (" + $lenProva + " byte) dal pin " + $Pin) -ForegroundColor Green
if($lenProva -eq 0){ Muori ("il file prova scaricato e' VUOTO: " + $provaLoc) }

# --- il simbolo serve a NOI per sapere come si chiameranno i CSV. Se
#     manca, il driver morirebbe piu' avanti e noi non sapremmo nemmeno
#     cosa cercare: meglio fermarsi adesso, e dire cosa manca.
$Simbolo  = DirettivaProva $provaLoc "SIMBOLO"
$Periodo  = DirettivaProva $provaLoc "PERIODO"
$DaQuando = DirettivaProva $provaLoc "DAQUANDO"
if(-not $Simbolo){ Muori ("nel file prova " + $Prova + " non c'e' la direttiva '@SIMBOLO <SIM>': senza, non so nemmeno come si chiameranno i CSV.") }
if(-not $DaQuando){
  Muori ("nel file prova " + $Prova + " non c'e' la direttiva '@DAQUANDO aaaa.mm.gg'.`n" +
         "    NON si mette a caso: la profondita' vera si MISURA (scarica_storico.ps1 -SoloReferto).")
}
if(-not $Periodo){ $Periodo = "M5 (default del driver)" }
Write-Host ("    prova: simbolo " + $Simbolo + " . periodo " + $Periodo + " . da " + $DaQuando) -ForegroundColor Green

# --- i CSV che questa corsa DEVE produrre. Il suffisso lo decide il
#     driver: "" a tick reali, "_ohlc" altrimenti, poi "_" + etichetta.
$suffMod = if($Modello -eq 4){ "" } else { "_ohlc" }
$Ris     = Join-Path $Work ("risultati_prove\" + $Expert)
$csvIS   = Join-Path $Ris ($Expert + "_" + $Simbolo + "_IS"  + $suffMod + "_" + $Etichetta + ".csv")
$csvOOS  = Join-Path $Ris ($Expert + "_" + $Simbolo + "_OOS" + $suffMod + "_" + $Etichetta + ".csv")

# CLASSE 155, in forma CHIRURGICA: la cartella di lavoro e' riusabile, e
# la raccolta copia PER NOME. Qui NON si rade al suolo risultati_prove
# (ci vivono gli altri round): si cancellano SOLO i due file che questa
# corsa deve riscrivere, e la freschezza si ricontrolla comunque per data.
foreach($f in @($csvIS,$csvOOS)){
  if(Test-Path -LiteralPath $f){
    Remove-Item -LiteralPath $f -Force -ErrorAction SilentlyContinue
    Write-Host ("    tolto il CSV omonimo di una corsa precedente: " + (Split-Path -Leaf $f)) -ForegroundColor DarkYellow
  }
}
$anteprima = Join-Path $Work ("anteprima_" + $Expert + "_" + $Simbolo + ".ini")
Remove-Item -LiteralPath $anteprima -Force -ErrorAction SilentlyContinue

# =====================================================================
#  4. LA CORSA
#     -Force: la guardia "MT5 aperto" del driver e' GLOBALE (classe 159)
#     e sul VPS i terminali sono quattro. Quella CHIRURGICA l'ha gia'
#     fatta questo script: il bersaglio e' chiuso, gli altri restano vivi.
#     -Rifai: senza, il driver SALTA i CSV gia' presenti (classe 15).
# =====================================================================
$arg = @("-NoProfile","-ExecutionPolicy","Bypass","-File",$drv,
         "-Expert",$Expert,"-Prova",$provaLoc,
         "-Etichetta",$Etichetta,"-Modello",("" + $Modello),"-Deposito",("" + $Deposito),
         "-Rifai","-Force","-TerminaleBacktest",$cartellaBT)
if($SoloControllo){ $arg += "-SoloControllo" }

Write-Host ""
Write-Host ("--- " + $Expert + " " + $Simbolo + "   etichetta " + $Etichetta + "   modello " + $Modello + "   deposito " + $Deposito + " ---") -ForegroundColor Cyan
$t0 = Get-Date
$proc = Start-Process -FilePath "powershell.exe" -ArgumentList $arg -NoNewWindow -PassThru -Wait
$rc = $proc.ExitCode
# CLASSE 154: questo rc NON e' il codice del driver, e' quello dell'ultimo
# .exe lanciato dentro (metaeditor esce diverso da 0 anche sui soli
# avvisi). Si STAMPA come informazione; il gate sta sull'ARTEFATTO.
Write-Host ("    rc del driver: " + $rc + "   (informativo: il verdetto sta sui CSV, non qui)") -ForegroundColor DarkGray

# =====================================================================
#  5. IL GIRO A VUOTO: il suo esito dipende dall'ARTEFATTO (classe 14)
# =====================================================================
if($SoloControllo){
  Write-Host ""
  Write-Host "=== GIRO A VUOTO (-SoloControllo): MT5 NON e' stato aperto ===" -ForegroundColor Yellow
  $antOk = (Test-Path -LiteralPath $anteprima) -and ((Get-Item -LiteralPath $anteprima).LastWriteTime -ge $t0)
  if(-not $antOk){
    Write-Host ("  NESSUNA ANTEPRIMA FRESCA in " + $anteprima) -ForegroundColor Red
    Write-Host "  Il giro a vuoto NON e' passato: leggi l'errore del driver qui sopra." -ForegroundColor Red
    exit 1
  }
  Write-Host ("  anteprima .ini fresca: " + $anteprima) -ForegroundColor Green
  Write-Host ""
  Write-Host "  CONTROLLA QUI SOPRA, PRIMA DI LANCIARE LA CORSA VERA:" -ForegroundColor Yellow
  Write-Host "    a) il conto delle CELLE e delle PASSATE torna col file prova;" -ForegroundColor Yellow
  Write-Host "    b) le finestre IS/OOS partono dalla @DAQUANDO misurata;" -ForegroundColor Yellow
  Write-Host ("    c) Symbol=" + $Simbolo + " e Deposit=" + $Deposito + " nell'anteprima.") -ForegroundColor Yellow
  Write-Host "  E QUELLO CHE QUESTO GIRO **NON** COPRE, dichiarato:" -ForegroundColor Yellow
  Write-Host "    - NON compila (checklist 39): un #include mancante salta fuori dopo;" -ForegroundColor Yellow
  Write-Host "    - nell'anteprima Model=4 e' HARDCODED (checklist 31): con -Modello 1" -ForegroundColor Yellow
  Write-Host "      l'anteprima dice comunque 4;" -ForegroundColor Yellow
  Write-Host "    - il driver esce PRIMA di scegliere il terminale: -TerminaleBacktest" -ForegroundColor Yellow
  Write-Host "      NON e' collaudato da questo giro." -ForegroundColor Yellow
  exit 0
}

# =====================================================================
#  6. I CSV: SI LEGGONO, NON SI GIUDICANO
# =====================================================================
$eIS  = LeggiCsvRound $csvIS  $t0
$eOOS = LeggiCsvRound $csvOOS $t0

$blocchi = New-Object System.Collections.ArrayList
foreach($b in (RigheReferto $eIS  "IS  (dentro campione)" $TESTO_TRADES0)){ [void]$blocchi.Add($b) }
[void]$blocchi.Add("")
foreach($b in (RigheReferto $eOOS "OOS (fuori campione)" $TESTO_TRADES0)){ [void]$blocchi.Add($b) }

Write-Host ""
Write-Host "--- I NUMERI, COSI' COME SONO USCITI --------------------------------" -ForegroundColor Cyan
foreach($r in $blocchi){
  $col = "White"
  if($r -like "*NON MISURATO*"){ $col = "Red" }
  elseif($r -like "*>>> Trades=0*"){ $col = "Red" }
  elseif($r -like "*ESITO : LETTO*"){ $col = "Green" }
  Write-Host ("  " + $r) -ForegroundColor $col
}
Write-Host "---------------------------------------------------------------------" -ForegroundColor Cyan

# =====================================================================
#  7. IL CONTO REALE E' INTATTO? SI CONTA, NON SI SPERA (riuso 3)
# =====================================================================
$dopo    = Terminali
$salDopo = Risparmiati $dopo
$pidDopo = @($salDopo | ForEach-Object { $_.Id })
$persi   = @($pidSalvi | Where-Object { $pidDopo -notcontains $_ })
Write-Host ""
Write-Host "--- TERMINALI MT5 (DOPO) --------------------------------------------" -ForegroundColor Cyan
Write-Host ("  PID vivi PRIMA (non bersaglio): " + $(if($pidSalvi.Count -gt 0){$pidSalvi -join " . "}else{"nessuno"}))
Write-Host ("  PID vivi DOPO  (non bersaglio): " + $(if($pidDopo.Count -gt 0){$pidDopo -join " . "}else{"nessuno"}))
if($persi.Count -eq 0){ Write-Host "  STESSI PID: forward e conto reale NON sono stati toccati." -ForegroundColor Green }
else{
  Write-Host ("  MANCANO ALL'APPELLO: " + ($persi -join " . ")) -ForegroundColor Red
  Rilievo ("terminali NON bersaglio spariti durante la corsa: PID " + ($persi -join ", ") + " -- CONTROLLA SUBITO IL CONTO REALE 10105439")
}
Write-Host "---------------------------------------------------------------------" -ForegroundColor Cyan

# =====================================================================
#  8. L'ESITO. Il gate e' sull'ARTEFATTO.
# =====================================================================
$mancanti = @()
if(-not $eIS.Fresco  -or $eIS.NRighe  -eq 0){ $mancanti += "IS" }
if(-not $eOOS.Fresco -or $eOOS.NRighe -eq 0){ $mancanti += "OOS" }
$zero = @()
if($eIS.Fresco  -and $eIS.NRighe  -gt 0 -and $eIS.ConTrades  -eq 0){ $zero += "IS" }
if($eOOS.Fresco -and $eOOS.NRighe -gt 0 -and $eOOS.ConTrades -eq 0){ $zero += "OOS" }

if($mancanti.Count -gt 0){
  $esitoFinale = "NON MISURATO -- CSV mancanti o vuoti: " + ($mancanti -join ", ")
}
elseif($zero.Count -gt 0){
  $esitoFinale = "NON MISURATO -- Trades = 0 su: " + ($zero -join ", ")
}
elseif($persi.Count -gt 0 -or $RILIEVI.Count -gt 0){
  $esitoFinale = "ROUND GIRATO CON RILIEVI (" + $RILIEVI.Count + ")"
}
else{
  $esitoFinale = "ROUND GIRATO"
}

# =====================================================================
#  9. REFERTO + RACCOLTA (riuso 6: regola delle righe di lancio, p.2 e 3)
#     LA RACCOLTA SI FA SEMPRE, anche quando l'esito e' NON MISURATO:
#     "non e' girata" e' gia' una risposta, e il referto va mandato lo
#     stesso (checklist, punto 26-bis).
# =====================================================================
$dsk = [Environment]::GetFolderPath("Desktop")
$d   = Join-Path $dsk ("ROUND_" + $Etichetta)
if(Test-Path -LiteralPath $d){ Remove-Item -LiteralPath $d -Recurse -Force }
New-Item -ItemType Directory -Force -Path $d | Out-Null

$R = New-Object System.Collections.ArrayList
function W($t){ [void]$R.Add($t) }
W ("REFERTO ROUND SUL TERMINALE DA BACKTEST")
W ("marcatore riga  : " + $MARC_MIO)
W ("marcatore driver: " + $MARC_DRV)
W ("pin             : " + $Pin)
W ("data            : " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss") + "   <-- SE QUESTA DATA NON E' DI OGGI, IL FILE E' VECCHIO")
W ("terminale       : " + $exeBT)
W ("tetto barre     : " + $(if($null -ne $MaxBars){"MaxBars=" + $MaxBars}else{"NON VERIFICATO (chiave MaxBars non trovata)"}))
W ("")
W ("EA              : " + $Expert)
W ("file prova      : " + $Prova + "   (" + $lenProva + " byte, dal pin)")
W ("etichetta       : " + $Etichetta)
W ("simbolo         : " + $Simbolo)
W ("periodo         : " + $Periodo)
W ("da quando       : " + $DaQuando)
W ("modello         : " + $Modello + $(if($Modello -eq 4){"  (tick reali)"}else{"  (NON tick reali: screening, non verdetto)"}))
W ("deposito        : " + $Deposito)
W ("rc del driver   : " + $rc + "   (informativo -- classe 154: e' l'ultimo .exe lanciato dentro, NON il verdetto)")
W ("")
W ("QUESTO REFERTO NON GIUDICA: dice cosa e' uscito. Il verdetto si scrive")
W ("dopo, coi criteri congelati PRIMA del round.")
W ("")
foreach($b in $blocchi){ W ($b) }
W ("")
W ("PID non bersaglio PRIMA: " + $(if($pidSalvi.Count -gt 0){$pidSalvi -join ", "}else{"nessuno"}))
W ("PID non bersaglio DOPO : " + $(if($pidDopo.Count -gt 0){$pidDopo -join ", "}else{"nessuno"}))
W ("")
W ("RILIEVI: " + $RILIEVI.Count)
foreach($x in $RILIEVI){ W ("  - " + $x) }
W ("")
W ("ESITO: " + $esitoFinale)
$ref = Join-Path $d ("REFERTO_ROUND_" + $Etichetta + ".txt")
($R -join "`r`n") | Set-Content -LiteralPath $ref -Encoding ASCII

# I CSV si copiano solo se sono di QUESTA corsa (per DATA, non per nome).
$n = 0
foreach($f in @($csvIS,$csvOOS)){
  if((Test-Path -LiteralPath $f) -and ((Get-Item -LiteralPath $f).LastWriteTime -ge $t0)){ Copy-Item -LiteralPath $f -Destination $d -Force; $n++ }
}
Copy-Item -LiteralPath $provaLoc -Destination $d -Force -ErrorAction SilentlyContinue

$zip = Join-Path $dsk ("ROUND_" + $Etichetta + ".zip")
if(Test-Path -LiteralPath $zip){ Remove-Item -LiteralPath $zip -Force }
Compress-Archive -Path (Join-Path $d "*") -DestinationPath $zip -Force

Write-Host ""
Write-Host ("RACCOLTA: " + $d)
Write-Host ("CSV di QUESTA corsa copiati: " + $n + "   (attesi 2: IS + OOS)")
Write-Host ("ZIP PRONTO DA MANDARE: " + $zip) -ForegroundColor Green
Write-Host "FILE ATTESI NELLO ZIP:" -ForegroundColor Gray
Write-Host ("   REFERTO_ROUND_" + $Etichetta + ".txt") -ForegroundColor Gray
Write-Host ("   " + (Split-Path -Leaf $csvIS)) -ForegroundColor Gray
Write-Host ("   " + (Split-Path -Leaf $csvOOS)) -ForegroundColor Gray
Write-Host ("   " + $Prova) -ForegroundColor Gray
# Out-Host: senza, Format-Table esce DOPO le Write-Host che seguono e
# l'ESITO finirebbe stampato sopra la tabella.
Get-ChildItem -LiteralPath $d | Select-Object Name,Length,LastWriteTime | Format-Table -AutoSize | Out-Host

Write-Host ""
$colEsito = "Yellow"
if($esitoFinale -eq "ROUND GIRATO"){ $colEsito = "Green" }
elseif($esitoFinale -like "NON MISURATO*"){ $colEsito = "Red" }
Write-Host ("ESITO: " + $esitoFinale) -ForegroundColor $colEsito
if($esitoFinale -like "NON MISURATO*"){
  Write-Host ("  " + $TESTO_TRADES0) -ForegroundColor Red
  Write-Host "  Il log del tester sta in <cartella dati>\Tester\ e nei log per-agente" -ForegroundColor Red
  Write-Host "  (%APPDATA%\MetaQuotes\Tester\Agent-127.0.0.1-30xx\logs\)." -ForegroundColor Red
  Write-Host "  MANDA LO ZIP LO STESSO: 'non e' girata' e' gia' una risposta." -ForegroundColor Yellow
}
Write-Host ("Nel referto la riga 'data:' dice " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss") + ": e' quella da leggere per sapere se il file e' di oggi.") -ForegroundColor Gray

if($esitoFinale -eq "ROUND GIRATO"){ exit 0 }
if($esitoFinale -like "NON MISURATO*"){ exit 2 }
exit 3
