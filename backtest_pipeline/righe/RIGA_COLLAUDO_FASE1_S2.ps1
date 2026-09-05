# =====================================================================
#  RIGA_COLLAUDO_FASE1_S2.ps1
#  MARCATORE-VERSIONE-SCRIPT: MARCATORE_RIGA_COLLAUDO_FASE1_S2_v1
# ---------------------------------------------------------------------
#  A COSA SERVE (05/09/2026):
#  e' lo strumento di LETTURA della SESSIONE 2 del collaudo enforcement
#  fase 1 (criterio 5 = LA PAUSA B1 CHE MORDE, criterio 6 = LE POSIZIONI
#  APERTE RESTANO GESTITE DURANTE LA PAUSA), pacchetto
#  report/COLLAUDO_ENFORCEMENT_FASE1_2026-09-02.md, procedure 2.3 e 2.4,
#  azione G3. E' il GEMELLO della SESSIONE 1 (cap C1 + fail-open,
#  RIGA_COLLAUDO_FASE1_S1.ps1 v2, gia' passata dal verificatore): stessa
#  ossatura, stessa scoperta della cartella dati, stesso artefatto come
#  input. Cambia CIO' CHE SI MISURA.
#
#  DOVE GIRA: sul VPS, sull'istanza -V3 del terminale del conto 100k
#  (50504263), CHE E' IL FORWARD.
#
#  ==> QUESTA RIGA E' DI SOLA LETTURA. <==
#  Non apre MT5, non lo chiude, non scrive NIENTE dentro
#  %APPDATA%\MetaQuotes\Terminal, non tocca nessun .chr, nessun .set,
#  nessun grafico, nessun EA, nessun ordine, e NON tocca NESSUNA
#  GlobalVariable (in particolare non cancella la pausa: quello e' un
#  gesto di Claudio da F3, a due passi). Legge i log (con
#  FileShare::ReadWrite: MT5 puo' e DEVE restare aperto) e i referti del
#  canarino, e scrive SOLO sul Desktop (cartella + zip).
#  Ogni gesto che CAMBIA STATO sul 100k (abbassare la soglia di pausa,
#  rialzarla, cancellare le due GV) lo fa Claudio A MANO, con la legge
#  dello screenshot: qui non c'e' una sola riga che possa farlo.
#
#  LA SCOPERTA DELLA CARTELLA DATI E' QUELLA DELLA S1 v2 (03/09/2026,
#  dopo la FERMATA IN CAMPO delle 10:45:10 sul VPS, pin 223e1f7): NON si
#  fa per NOME ("-V3" dentro origin.txt sotto %APPDATA%), che sul VPS
#  reale non combacia. Si scandisce LARGO (processi terminal64 vivi,
#  cartelle dati di tutti i profili utente, installazioni PORTABLE sotto
#  C:\Program Files*, C:\ e D:\) e si sceglie STRETTO, su un FATTO: il
#  conto 50504263 nei log, la riga "filo verificato ... (conto 50504263)"
#  e i referti del canarino intestati a quel login. Se le candidate con
#  evidenza sono ZERO o PIU' DI UNA ci si FERMA, stampando l'elenco
#  COMPLETO di cosa e' stato guardato -- e la cartella si puo' imporre
#  con -CartellaDati senza aspettare un altro giro di push.
#
#  ----------------------------------------------------------------
#  QUATTRO COSE CHE QUESTA RIGA FA E LA S1 NON FACEVA, e il perche':
#
#  (A) IL GATE DELLA GIORNATA IN PERDITA (precondizione fisica del
#      criterio 5). ABTG_Guardian.mq5 riga 400:
#        if(InpDailyPausePct>0 && dailyPct>=InpDailyPausePct)
#      e InpDailyPausePct=0 vuol dire SPENTA. Quindi la pausa e'
#      innescabile SOLO se la giornata e' in perdita di una frazione
#      qualsiasi (dailyPct>0). Qui si legge il campo dayLoss= delle
#      righe periodiche del Guardian e si dice, PRIMA di ogni gesto, se
#      la prova e' innescabile oggi. E' una SPIA campionata ogni 300 s:
#      il numero che decide resta quello del PANNELLO (P-4), letto da
#      Claudio adesso.
#
#  (B) IL CONTROLLO DEL LATCH (rilievo R2, ed e' il rischio X7 del
#      piano: il 100k che resta in pausa fino al reset). La pausa NON
#      si spegne rialzando la soglia: SetPausa scrive GV_PAUSA e nessuno
#      la azzera fino al cambio di giorno prop (Guardian righe 187-199 e
#      349-350); riavviare il Guardian NON basta (OnInit azzera la pausa
#      solo se cambia la chiave del giorno, righe 273-280). L'uscita e' a
#      DUE passi e in QUEST'ORDINE: 1) InpDailyPausePct=4.0, 2) cancellare
#      da F3 ABTG_PAUSA_GIORNO_<login> e ABTG_PAUSA_FINO_<login>.
#      Qui si controlla a macchina che dopo il ritorno a 4.00 NON sia
#      ricomparsa nessuna riga di accensione della pausa (se ricompare,
#      le GV sono state cancellate PRIMA di rialzare la soglia e il giro
#      di timer successivo le ha riscritte: il 100k e' ANCORA in pausa).
#
#  (C) LA PROVA DEL CRITERIO 6 CHE UNA MACCHINA PUO' DARE: il confronto
#      degli SL POSIZIONE PER POSIZIONE fra le corse del canarino. Il
#      canarino stampa "pos #<ticket> ... sl=<valore>": due corse
#      ENTRAMBE dentro la pausa con lo stesso ticket e un SL DIVERSO
#      sono un evento di gestione avvenuto DURANTE la pausa -- che e'
#      esattamente la prova di forza 1 del paragrafo 2.4. Il resto
#      (scheda Trade, Storico) resta agli screenshot di Claudio.
#
#  (D) IL PERIMETRO TEMPORALE DELLA PAUSA, calcolato dai log: inizio =
#      la riga "* PAUSA NUOVI INGRESSI attiva:" dentro la sessione, fine
#      = il ritorno della soglia a 4.00 (o "adesso" se non e' ancora
#      avvenuto). Dentro quella finestra si contano le righe dei 5 EA
#      (i cui nomi si leggono DALL'ARTEFATTO, non da qui) e le righe di
#      modifica del GIORNALE: materiale del criterio 6, dichiarato come
#      SPIA e non come prova.
#  ----------------------------------------------------------------
#
#  TRE MODI (uno per volta):
#    (nessuno)  LETTURA PRIMA   -- prerequisiti P-1..P-5 leggibili dal log,
#                                 GATE della giornata in perdita, righe
#                                 VIETATE, traccia delle soglie, e scrive
#                                 il SEGNAPOSTO d'inizio sessione
#    -Presidio  PRESIDIO        -- coda dal vivo del log Esperti per N minuti
#                                 (-Minuti, default 20): stampa le righe
#                                 [GUARDIAN] / [GUARDIA] / [CANARINO] man mano
#    -Chiusura  RACCOLTA FINALE -- censimento contro l'artefatto delle attese,
#                                 lettura dei referti del canarino, verdetto
#                                 a TRE STATI e zip sul Desktop
#
#  L'ARTEFATTO E' L'INPUT, NON UNA COPIA: le stringhe che fanno fede si
#  scaricano dal pin (backtest_pipeline/attese_enforcement_fase1.txt) e si
#  cercano per SOTTOSTRINGA, come dice l'artefatto stesso. Qui dentro NON
#  c'e' nessuna copia a mano di quelle frasi: se l'artefatto cambia,
#  cambia il censimento, e non c'e' niente da tenere allineato a mano.
#
#  USO (sempre col pin, dalla pagina
#  backtest_pipeline/righe/COLLAUDO_FASE1_SESSIONE2_DA_MANDARE.md):
#    powershell -ExecutionPolicy Bypass -File .\RIGA_COLLAUDO_FASE1_S2.ps1 -Pin <sha>
#  e, se la scoperta si ferma, la stessa riga con in coda:
#    -CartellaDati '<cartella dati dell'istanza del 100k>'
#
#  ASCII PURO (Windows PowerShell 5.1 legge i .ps1 in ANSI: niente emoji,
#  niente lettere accentate). Cultura INVARIANTE su ogni numero.
# =====================================================================
param(
  [string] $Pin          = "",
  [switch] $Presidio,
  [switch] $Chiusura,
  [int]    $Minuti       = 20,
  [string] $OraGesto     = "",     # facoltativa: l'ora (locale VPS) in cui Claudio
                                   # ha abbassato InpDailyPausePct, come l'ha annotata.
                                   # NON serve al verdetto: l'inizio della pausa lo
                                   # dice la riga del Guardian, che e' piu' precisa.
  [string] $CartellaDati = ""      # la cartella dati dell'istanza del 100k, da usare
)                                  # SOLO se la scoperta automatica si ferma

$ErrorActionPreference = "Continue"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$INV   = [System.Globalization.CultureInfo]::InvariantCulture
$Avvio = Get-Date
$stamp = $Avvio.ToString("yyyyMMdd_HHmmss", $INV)

$CONTO_COLLAUDO = "50504263"
$RAW_BASE       = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB"
$ART_PATH       = "backtest_pipeline/attese_enforcement_fase1.txt"

# --- i quattro PASSI del referto: TRE STATI ciascuno, timbrati sul ramo
#     che li decide (checklist 94-ter). Il valore di partenza dice la
#     verita' anche quando lo script muore prima.
$P_modo       = "NON DECISO"
$P_terminale  = "NON TENTATO"
$P_conto      = "NON TENTATO"
$P_artefatto  = "NON TENTATO"
$P_log        = "NON TENTATO"
$P_censimento = "NON TENTATO"
$P_canarino   = "NON TENTATO"
$P_zip        = "NON TENTATO"
$Esito        = "NON ARRIVATO IN FONDO"
$CodiceUscita = 1

# =====================================================================
#  UTILITA'
# =====================================================================
$OUT = New-Object System.Collections.ArrayList
function Riga($t, $col = "Gray") {
  Write-Host $t -ForegroundColor $col
  [void]$OUT.Add([string]$t)
}
function RigaSoloFile($t) { [void]$OUT.Add([string]$t) }

function Trova-Desktop {
  foreach ($p in @([Environment]::GetFolderPath("Desktop"),
                   (Join-Path $env:USERPROFILE "Desktop"),
                   (Join-Path $env:USERPROFILE "OneDrive\Desktop"))) {
    if ($p -and (Test-Path $p)) { return $p }
  }
  return $env:USERPROFILE
}

# lettura CONDIVISA: MT5 tiene i log aperti in scrittura. Senza
# FileShare::ReadWrite la lettura fallisce con "file in uso" (14/08).
function Leggi-Bytes($path, $da) {
  try {
    $fs = [IO.File]::Open($path, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
  } catch { return $null }
  try {
    $len = $fs.Length
    if ($da -lt 0) { $da = 0 }
    if ($da % 2 -ne 0) { $da = $da - 1 }
    if ($da -ge $len) { $fs.Close(); return (New-Object byte[] 0) }
    if ($da -gt 0) { [void]$fs.Seek($da, [IO.SeekOrigin]::Begin) }
    $n = [int]($len - $da)
    $b = New-Object byte[] $n
    $letti = 0
    while ($letti -lt $n) {
      $q = $fs.Read($b, $letti, $n - $letti)
      if ($q -le 0) { break }
      $letti += $q
    }
    $fs.Close()
    return $b
  } catch { try { $fs.Close() } catch { }; return $null }
}

# i log di MT5 sono UTF-16 (con o senza BOM): la codifica sbagliata
# non trova NIENTE e il censimento esce verde per cecita'.
function Bytes-Testo($b, $daZero) {
  if ($null -eq $b) { return "" }
  if ($b.Count -lt 4) { return "" }
  $utf16 = ($daZero -and $b[0] -eq 0xFF -and $b[1] -eq 0xFE)
  if (-not $utf16) {
    $zeri = 0; $n = [math]::Min(400, $b.Count)
    for ($i = 1; $i -lt $n; $i += 2) { if ($b[$i] -eq 0) { $zeri++ } }
    $utf16 = ($zeri -gt ($n / 4))
  }
  # il BOM decodificato resta come carattere U+FEFF in testa alla prima
  # riga: va tolto, altrimenti finisce nel referto (scritto in ASCII) e
  # sporca la prima riga citata come prova.
  if ($utf16) { return ([Text.Encoding]::Unicode.GetString($b)).TrimStart([char]0xFEFF) }
  return ([Text.Encoding]::UTF8.GetString($b)).TrimStart([char]0xFEFF)
}
function Leggi-Testo($path) {
  $b = Leggi-Bytes $path 0
  return (Bytes-Testo $b $true)
}
function Leggi-TestoDa($path, $da) {
  $b = Leggi-Bytes $path $da
  return (Bytes-Testo $b ($da -eq 0))
}

# l'ora di una riga di log MT5: e' l'ora LOCALE del VPS (= ora italiana).
# Il grafico e le GlobalVariable sono in ora SERVER (= italiana meno 1).
function Ora-Riga($riga) {
  $m = [regex]::Match($riga, "(\d{2}):(\d{2}):(\d{2})\.\d{3}")
  if ($m.Success) { return ($m.Groups[1].Value + ":" + $m.Groups[2].Value + ":" + $m.Groups[3].Value) }
  return ""
}
function Contiene($riga, $testo) {
  if ([string]::IsNullOrEmpty($testo)) { return $false }
  return ($riga.IndexOf($testo, [System.StringComparison]::OrdinalIgnoreCase) -ge 0)
}
# il contesto MT5 della riga: "NomeProgramma (SIMBOLO,TF)" -- spia (non
# prova) di DUE Guardian sullo stesso conto: la prova e' il menu Finestra.
function Contesto-Riga($riga) {
  $tagli = @("[GUARDIAN]", "[GUARDIA]", "[CANARINO]")
  $pos = -1
  foreach ($t in $tagli) {
    $p = $riga.IndexOf($t, [System.StringComparison]::OrdinalIgnoreCase)
    if ($p -ge 0 -and ($pos -lt 0 -or $p -lt $pos)) { $pos = $p }
  }
  if ($pos -le 0) { return "" }
  $testa = $riga.Substring(0, $pos)
  $m = [regex]::Match($testa, "([A-Za-z0-9_]+\s*\([^)]+\))\s*$")
  if ($m.Success) { return $m.Groups[1].Value.Trim() }
  return ""
}
# quante righe di questa voce del contratto cadono DENTRO la sessione
# (cioe' dopo il segnaposto). Senza segnaposto il perimetro e' la
# giornata intera, e lo si dichiara: e' una lettura piu' larga, non un
# errore -- ma un verdetto di sessione non si da' su righe di stamattina.
function Conta-Dopo($voce, $inizio) {
  if (-not $inizio) { return $voce.Righe.Count }
  $n = 0
  foreach ($rr in $voce.Righe) {
    $o = Ora-Riga $rr
    if ($o -and ($o -ge $inizio)) { $n++ }
  }
  return $n
}

function Num-Inv($s) {
  $v = 0.0
  if ([double]::TryParse($s, [System.Globalization.NumberStyles]::Float, $INV, [ref]$v)) { return $v }
  return [double]::NaN
}

# =====================================================================
#  0) MODO E CARTELLA DI RACCOLTA (creata SUBITO: cosi' ogni ramo che
#     muore dopo lascia comunque referto + zip -- checklist 94-bis)
# =====================================================================
if ($Presidio -and $Chiusura) {
  Write-Host "RIFIUTO: -Presidio e -Chiusura insieme non hanno senso. Un modo per volta." -ForegroundColor Red
  exit 1
}
$P_modo = "LETTURA PRIMA"
if ($Presidio) { $P_modo = "PRESIDIO" }
if ($Chiusura) { $P_modo = "RACCOLTA FINALE" }

$desktop = Trova-Desktop
$cart    = Join-Path $desktop ("COLLAUDO_FASE1_S2_" + $stamp)
$zip     = Join-Path $desktop ("COLLAUDO_FASE1_S2_" + $stamp + ".zip")
$segnPath= Join-Path $desktop "COLLAUDO_FASE1_S2_SEGNAPOSTO.txt"
try { New-Item -ItemType Directory -Force -Path $cart | Out-Null } catch { }

Riga "===============================================================" "Cyan"
Riga ("COLLAUDO ENFORCEMENT FASE 1 -- SESSIONE 2 (pausa B1 + posizioni gestite)") "Cyan"
Riga ("modo: " + $P_modo + "   -- SOLA LETTURA, non tocca MT5") "Cyan"
Riga ("data: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss", $INV) + "   (ora LOCALE del VPS = ora italiana; il GRAFICO e' un'ora indietro)") "Cyan"
Riga "===============================================================" "Cyan"
Riga ""

# --- il pin serve DAVVERO: senza, l'artefatto delle attese non si scarica
if ($Pin -notmatch "^[0-9a-fA-F]{7,40}$") {
  Riga "FERMO: -Pin assente o malformato. Serve lo sha del commit (7-40 esadecimali)." "Red"
  Riga "       L'artefatto delle attese si scarica DAL PIN: senza pin non c'e' contratto da leggere." "Red"
  $Esito = "FERMATA: pin assente/malformato"
} else {

# =====================================================================
#  1) LA CARTELLA DATI DEL 100k -- SCOPERTA PER FATTI, NON PER NOME.
#
#  PERCHE' e' cambiata (03/09/2026, driver v1 -> v2): la v1 cercava la
#  stringa "-V3" dentro origin.txt sotto %APPDATA%\MetaQuotes\Terminal,
#  e sul VPS di Claudio ha risposto "cartella dati -V3 non trovata"
#  (referto delle 10:45:10, pin 223e1f7). IL NOME NON E' UN FATTO:
#   - un'installazione PORTABLE non ha nessun origin.txt e tiene i dati
#     DENTRO la cartella d'installazione;
#   - la cartella dati puo' stare sotto un ALTRO profilo utente;
#   - l'istanza puo' chiamarsi in qualunque modo.
#  Il FATTO, invece, e' il conto: il login 50504263 nei log, il referto
#  del canarino intestato a quel login, la riga "filo verificato ...
#  (conto 50504263)" scritta dal Guardian.
#
#  REGOLA DI QUESTA SCOPERTA: si scandisce LARGO e si sceglie STRETTO.
#  Se le candidate con evidenza sono ZERO o PIU' DI UNA, NON si indovina:
#  ci si ferma stampando TUTTE le cartelle guardate e cosa c'era dentro,
#  cosi' la cartella giusta la riconosce Claudio con uno sguardo (e la
#  puo' imporre con -CartellaDati, senza aspettare un altro giro).
# =====================================================================
$CAND = New-Object System.Collections.ArrayList

function Aggiungi-Candidata($percorso, $origine) {
  if ([string]::IsNullOrEmpty($percorso)) { return }
  $full = $percorso
  try {
    if (-not (Test-Path -LiteralPath $percorso)) { return }
    $full = (Get-Item -LiteralPath $percorso -ErrorAction Stop).FullName
  } catch { return }
  foreach ($c in $CAND) {
    if ($c.Percorso -ieq $full) { $c.Origine = $c.Origine + " + " + $origine; return }
  }
  # una cartella entra nell'elenco se ha ALMENO UNA delle tre tracce di un
  # terminale: logs\, MQL5\, terminal64.exe. Quelle con l'exe ma senza dati
  # NON si buttano via in silenzio: si stampano scartate, col perche' --
  # sono proprio il caso che fa dire a Claudio "ah, i dati stanno altrove".
  $lg  = (Test-Path -LiteralPath (Join-Path $full "logs"))
  $mq  = (Test-Path -LiteralPath (Join-Path $full "MQL5"))
  $exe = (Test-Path -LiteralPath (Join-Path $full "terminal64.exe"))
  if (-not $lg -and -not $mq -and -not $exe) { return }
  [void]$CAND.Add([pscustomobject]@{
    Percorso    = $full
    Origine     = $origine
    HaExe       = $exe
    HaLogs      = $lg
    HaMql       = $mq
    Origin      = ""
    FileLog     = 0
    Logins      = ""
    UltimoLogin = ""
    ContoVisto  = $false
    FiloConto   = $false
    Canarini    = 0
    UltimoCanarino = ""
    UltimaAttivita = ""
    Eleggibile  = $false
    Scarto      = ""
  })
}

#--- SCAN 1. I PROCESSI VIVI: e' il fatto piu' forte di tutti (se MT5 gira,
#    la sua cartella d'installazione esiste di sicuro e la sappiamo).
foreach ($pr in @(Get-Process -Name terminal64 -ErrorAction SilentlyContinue)) {
  $exe = ""
  try { $exe = $pr.Path } catch { $exe = "" }
  if ($exe) { Aggiungi-Candidata (Split-Path -Parent $exe) ("processo terminal64 pid " + $pr.Id + " (portable?)") }
}

#--- SCAN 2/3. Le cartelle dati classiche, di QUESTO utente e degli altri.
$radiciTerminal = New-Object System.Collections.ArrayList
if ($env:APPDATA) { [void]$radiciTerminal.Add((Join-Path $env:APPDATA "MetaQuotes\Terminal")) }
try {
  foreach ($u in @(Get-ChildItem "C:\Users" -Directory -ErrorAction SilentlyContinue)) {
    [void]$radiciTerminal.Add((Join-Path $u.FullName "AppData\Roaming\MetaQuotes\Terminal"))
  }
} catch { }
foreach ($rt in $radiciTerminal) {
  if (-not (Test-Path -LiteralPath $rt)) { continue }
  foreach ($d in @(Get-ChildItem -LiteralPath $rt -Directory -ErrorAction SilentlyContinue)) {
    if ($d.Name -ieq "Common") { continue }
    Aggiungi-Candidata $d.FullName ("cartella dati sotto " + $rt)
  }
}

#--- SCAN 4. Le INSTALLAZIONI (per il caso portable: i dati stanno li' dentro).
#    "Program Files" si scende SEMPRE di un livello (il broker puo'
#    chiamarsi in qualunque modo: C:\Program Files\<Broker>\<Terminal>),
#    e li' sotto entra chi ha terminal64.exe o un nome parlante.
#    Su C:\ e D:\ si resta ai nomi parlanti: scendere ovunque vorrebbe
#    dire elencare mezzo disco per niente.
$radiciProfonde   = @("C:\Program Files", "C:\Program Files (x86)")
$radiciSuperficie = @("C:\", "D:\")
$paroleChiave = @("MT5", "BCM", "MetaTrader", "MetaQuotes", "Terminal")
foreach ($ri in ($radiciProfonde + $radiciSuperficie)) {
  if (-not (Test-Path -LiteralPath $ri)) { continue }
  $profonda = ($radiciProfonde -contains $ri)
  foreach ($d1 in @(Get-ChildItem -LiteralPath $ri -Directory -ErrorAction SilentlyContinue)) {
    $nome1 = $false
    foreach ($k in $paroleChiave) { if ($d1.Name -like ("*" + $k + "*")) { $nome1 = $true } }
    if ($nome1 -or (Test-Path -LiteralPath (Join-Path $d1.FullName "terminal64.exe"))) {
      Aggiungi-Candidata $d1.FullName ("installazione in " + $ri)
    }
    if (-not $profonda -and -not $nome1) { continue }
    foreach ($d2 in @(Get-ChildItem -LiteralPath $d1.FullName -Directory -ErrorAction SilentlyContinue)) {
      $interessa2 = (Test-Path -LiteralPath (Join-Path $d2.FullName "terminal64.exe"))
      if (-not $interessa2) {
        foreach ($k in $paroleChiave) { if ($d2.Name -like ("*" + $k + "*")) { $interessa2 = $true } }
      }
      if ($interessa2) { Aggiungi-Candidata $d2.FullName ("installazione in " + $d1.FullName) }
    }
  }
}

#--- SCAN 5. La cartella IMPOSTA A MANO da Claudio (quando la sa lui).
if ($CartellaDati) { Aggiungi-Candidata $CartellaDati "IMPOSTA A MANO con -CartellaDati" }

#--- LE EVIDENZE, una candidata per volta. Tutto in sola lettura.
$limiteGiorni = (Get-Date).AddDays(-20)
foreach ($c in $CAND) {
  if (-not $c.HaLogs -and -not $c.HaMql) { $c.Scarto = "c'e' terminal64.exe ma NESSUNA cartella logs\ ne' MQL5\: i dati di questa istanza stanno altrove (non e' portable)"; continue }
  $o = Join-Path $c.Percorso "origin.txt"
  if (Test-Path -LiteralPath $o) {
    try { $c.Origin = ([string](Get-Content -LiteralPath $o -Raw -ErrorAction SilentlyContinue)).Trim() } catch { $c.Origin = "" }
  }
  $loginSet = @{}
  $ultimaScrittura = $null
  foreach ($sub in @("logs", "MQL5\Logs")) {
    $dir = Join-Path $c.Percorso $sub
    if (-not (Test-Path -LiteralPath $dir)) { continue }
    $files = @(Get-ChildItem -LiteralPath $dir -Filter "*.log" -File -ErrorAction SilentlyContinue |
               Where-Object { $_.LastWriteTime -ge $limiteGiorni -and $_.Length -lt 60000000 } |
               Sort-Object LastWriteTime -Descending | Select-Object -First 8)
    $c.FileLog = $c.FileLog + $files.Count
    foreach ($f in $files) {
      if ($null -eq $ultimaScrittura -or $f.LastWriteTime -gt $ultimaScrittura) { $ultimaScrittura = $f.LastWriteTime }
      $txt = Leggi-Testo $f.FullName
      if (-not $txt) { continue }
      # 1) il conto come SOTTOSTRINGA: vale anche se il formato della
      #    riga di collegamento cambia da una build all'altra
      if ($txt.IndexOf($CONTO_COLLAUDO, [System.StringComparison]::OrdinalIgnoreCase) -ge 0) { $c.ContoVisto = $true }
      # 2) la riga del Guardian che nomina il conto: e' il filo del collaudo
      if ($txt.IndexOf("filo verificato", [System.StringComparison]::OrdinalIgnoreCase) -ge 0 -and
          $txt.IndexOf("(conto " + $CONTO_COLLAUDO + ")", [System.StringComparison]::OrdinalIgnoreCase) -ge 0) { $c.FiloConto = $true }
      # 3) tutti i login visti, per far vedere a Claudio DI CHI e' la cartella
      foreach ($m in [regex]::Matches($txt, "'(\d{5,})': (?:login|authorized) on")) {
        $loginSet[$m.Groups[1].Value] = 1
        $c.UltimoLogin = $m.Groups[1].Value
      }
    }
  }
  if ($loginSet.Keys.Count -gt 0) { $c.Logins = (($loginSet.Keys | Sort-Object) -join ",") }
  if ($null -ne $ultimaScrittura) { $c.UltimaAttivita = $ultimaScrittura.ToString("yyyy-MM-dd HH:mm", $INV) }
  $fdir = Join-Path $c.Percorso "MQL5\Files"
  if (Test-Path -LiteralPath $fdir) {
    $can = @(Get-ChildItem -LiteralPath $fdir -Filter ("ABTG_Canarino_" + $CONTO_COLLAUDO + "_*.txt") -File -ErrorAction SilentlyContinue |
             Sort-Object LastWriteTime -Descending)
    $c.Canarini = $can.Count
    if ($can.Count -gt 0) { $c.UltimoCanarino = $can[0].Name }
  }
  $c.Eleggibile = ($c.ContoVisto -or $c.FiloConto -or ($c.Canarini -gt 0))
  if (-not $c.Eleggibile) { $c.Scarto = "nessuna traccia del conto " + $CONTO_COLLAUDO }
}

#--- L'ELENCO COMPLETO: si stampa SEMPRE, anche quando la scelta e' facile.
#    E' l'artefatto che permette a Claudio di dire "e' quella" in un colpo.
Riga "=== CARTELLE GUARDATE (scoperta per FATTI: il conto, non il nome) ===" "Cyan"
Riga ("  conto cercato: " + $CONTO_COLLAUDO + "   candidate esaminate: " + $CAND.Count) "Gray"
foreach ($c in $CAND) {
  $col = "Gray"
  if ($c.Eleggibile) { $col = "Green" }
  Riga ("  --- " + $c.Percorso) $col
  Riga ("      trovata come : " + $c.Origine)
  Riga ("      terminal64.exe=" + $c.HaExe + "  logs\=" + $c.HaLogs + "  MQL5\=" + $c.HaMql + "  file di log guardati=" + $c.FileLog + "  ultima scrittura=" + $c.UltimaAttivita)
  if ($c.Origin) { Riga ("      origin.txt   : " + $c.Origin) }
  Riga ("      login visti  : " + $(if ($c.Logins) { $c.Logins } else { "nessuno" }) + "   ultimo=" + $(if ($c.UltimoLogin) { $c.UltimoLogin } else { "-" }))
  Riga ("      conto " + $CONTO_COLLAUDO + " nei log: " + $c.ContoVisto + "   filo verificato con quel conto: " + $c.FiloConto + "   referti canarino: " + $c.Canarini)
  if ($c.UltimoCanarino) { Riga ("      ultimo canarino: " + $c.UltimoCanarino) }
  if ($c.Scarto) { Riga ("      SCARTATA: " + $c.Scarto) "Yellow" }
}
Riga ""

$eleggibili = @($CAND | Where-Object { $_.Eleggibile })
$DataFolder = ""
$comeTrovato = ""
if ($CartellaDati) {
  $imposta = @($CAND | Where-Object { $_.Origine -like "*IMPOSTA A MANO*" })
  if ($imposta.Count -eq 1) {
    $DataFolder = $imposta[0].Percorso
    $comeTrovato = "IMPOSTA A MANO con -CartellaDati"
    if (-not $imposta[0].Eleggibile) {
      Riga ("ATTENZIONE: la cartella imposta a mano NON ha nessuna traccia del conto " + $CONTO_COLLAUDO + ".") "Yellow"
      Riga "            Vado avanti perche' l'hai chiesto tu, ma il referto lo dice." "Yellow"
      $comeTrovato = $comeTrovato + " (SENZA evidenza del conto: dichiarato)"
    }
  } else {
    Riga ("FERMO: -CartellaDati punta a una cartella che non esiste o non e' una cartella dati: " + $CartellaDati) "Red"
  }
} elseif ($eleggibili.Count -eq 1) {
  $DataFolder = $eleggibili[0].Percorso
  $comeTrovato = "UNICA candidata con evidenza del conto " + $CONTO_COLLAUDO +
                 " (log=" + $eleggibili[0].ContoVisto + ", filo=" + $eleggibili[0].FiloConto + ", canarini=" + $eleggibili[0].Canarini + ")"
} elseif ($eleggibili.Count -gt 1) {
  $comeTrovato = "AMBIGUO: " + $eleggibili.Count + " cartelle con evidenza del conto " + $CONTO_COLLAUDO
  Riga ("FERMO -- " + $comeTrovato + ". NON indovino quale sia: le due potrebbero essere") "Red"
  Riga "la stessa istanza vista due volte, oppure due terminali sullo stesso conto (violazione B9)." "Red"
  foreach ($e in $eleggibili) { Riga ("   candidata: " + $e.Percorso) "Red" }
  Riga "Rilancia la stessa riga aggiungendo   -CartellaDati '<il percorso giusto>'   (quello dell'istanza del 100k)." "Yellow"
} else {
  $comeTrovato = "NESSUNA cartella con evidenza del conto " + $CONTO_COLLAUDO
  Riga ("FERMO -- " + $comeTrovato + ".") "Red"
  Riga "Sopra c'e' l'elenco COMPLETO di quello che ho guardato e di cosa c'era dentro: se riconosci" "Yellow"
  Riga "la cartella dell'istanza del 100k, rilancia la stessa riga aggiungendo" "Yellow"
  Riga "   -CartellaDati 'C:\...\<cartella dati dell'istanza del 100k>'" "Yellow"
  Riga "Se invece non c'e' proprio, il percorso lo si legge in MT5: File > Apri la cartella dei dati." "Yellow"
}

if (-not $DataFolder) {
  $P_terminale = "FALLITO (" + $comeTrovato + ", candidate esaminate " + $CAND.Count + ")"
  $Esito = "FERMATA: cartella dati del 100k non identificata"
} else {
  $P_terminale = "OK (" + (Split-Path -Leaf $DataFolder) + " -- " + $comeTrovato + ")"
  Riga ("cartella dati del 100k : " + $DataFolder) "Green"
  Riga ("come trovata           : " + $comeTrovato) "Gray"

  # MT5 deve restare APERTO: qui non si chiude niente, ma se e' chiuso il
  # forward e' fermo e va DETTO (non e' un rifiuto: e' un avviso).
  $mt5 = @(Get-Process -Name terminal64 -ErrorAction SilentlyContinue)
  if ($mt5.Count -eq 0) {
    Riga "AVVISO: nessun processo terminal64 in esecuzione. Sul VPS vuol dire FORWARD FERMO." "Yellow"
    Riga "        Questa riga legge lo stesso i log, ma il dato e' di un terminale spento: dichiaralo." "Yellow"
  } else {
    Riga ("processi terminal64 vivi: " + $mt5.Count + " (questa riga NON ne tocca nessuno)") "Gray"
  }

  # ---------------------------------------------------------------
  #  2) IL CONTO (P-1). Le GlobalVariable portano il login nel nome:
  #     su un conto diverso il canale NON esiste e passa tutto in
  #     silenzio (fail-open muto).
  # ---------------------------------------------------------------
  $giornaleDir = Join-Path $DataFolder "logs"
  $espertiDir  = Join-Path $DataFolder "MQL5\Logs"
  $contoAttivo = ""
  $serverConto = ""
  $quandoConto = ""
  # v2: si guarda nel GIORNALE **e** in MQL5\Logs. Su un'installazione
  # portable, o con una build che scrive il collegamento altrove, la
  # riga di login puo' non stare dove la cercava la v1 -- e "non letto"
  # su un terminale sanissimo e' un allarme falso.
  foreach ($dirLog in @($giornaleDir, $espertiDir)) {
    if (-not (Test-Path -LiteralPath $dirLog)) { continue }
    foreach ($f in @(Get-ChildItem -LiteralPath $dirLog -Filter "*.log" -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime)) {
      $txt = Leggi-Testo $f.FullName
      if (-not $txt) { continue }
      $mm = [regex]::Matches($txt, "'(\d{5,})': (?:login|authorized) on ([^\r\n\(]+)")
      if ($mm.Count -gt 0) {
        $u = $mm[$mm.Count - 1]
        $contoAttivo = $u.Groups[1].Value
        $serverConto = $u.Groups[2].Value.Trim()
        $quandoConto = $f.BaseName + " (" + (Split-Path -Leaf $dirLog) + ")"
      }
    }
  }
  # ripiego dichiarato: se nessuna riga di collegamento esiste, il conto
  # lo dice comunque il Guardian nella sua riga "filo verificato".
  $scelta = @($CAND | Where-Object { $_.Percorso -ieq $DataFolder })
  if (-not $contoAttivo -and $scelta.Count -eq 1 -and $scelta[0].FiloConto) {
    $contoAttivo = $CONTO_COLLAUDO
    $serverConto = "(non letto: nessuna riga di collegamento)"
    $quandoConto = "riga [GUARDIAN] filo verificato ... (conto " + $CONTO_COLLAUDO + ")"
  }
  if ($contoAttivo -eq $CONTO_COLLAUDO) {
    $P_conto = "OK (" + $contoAttivo + " su " + $serverConto + ", ultimo collegamento nel giornale del " + $quandoConto + ")"
    Riga ("P-1 CONTO ATTIVO  : " + $contoAttivo + "  server " + $serverConto + "   ATTESO " + $CONTO_COLLAUDO) "Green"
  } elseif ($contoAttivo) {
    $P_conto = "ROSSO (letto " + $contoAttivo + ", atteso " + $CONTO_COLLAUDO + ")"
    Riga ("P-1 CONTO ATTIVO  : " + $contoAttivo + " -- NON E' IL CONTO DEL COLLAUDO (" + $CONTO_COLLAUDO + ")") "Red"
    Riga "    Su un altro login le GlobalVariable del canale NON esistono: il collaudo non misura niente." "Red"
  } else {
    $P_conto = "NON LETTO (nessuna riga di collegamento nel giornale)"
    Riga "P-1 CONTO ATTIVO  : NON LETTO dal giornale (ne' verde ne' rosso: non misurato)" "Yellow"
  }

  # ---------------------------------------------------------------
  #  3) L'ARTEFATTO DELLE ATTESE, DAL PIN (e' l'INPUT del censimento)
  # ---------------------------------------------------------------
  $artLocale = Join-Path $cart "attese_enforcement_fase1.txt"
  $ATTESE = New-Object System.Collections.ArrayList
  # I NOMI DEI 5 EA SI LEGGONO DALL'ARTEFATTO (righe "EA.n | NOME | <nome>"),
  # non si scrivono qui: servono al criterio 6 per riconoscere le righe di
  # giornale dei 5 mirror dentro la finestra di pausa. Se un domani un mirror
  # cambia nome, cambia l'artefatto e questa riga lo segue da sola.
  $EANOMI = New-Object System.Collections.ArrayList
  try {
    Invoke-WebRequest -Uri ($RAW_BASE + "/" + $Pin + "/" + $ART_PATH) -OutFile $artLocale -UseBasicParsing -ErrorAction Stop
    $artTxt = Get-Content -LiteralPath $artLocale -Raw -ErrorAction Stop
    foreach ($l in ($artTxt -split "`r?`n")) {
      if ($l -match "^\s*#") { continue }
      $mn = [regex]::Match($l, "^\s*(EA\.\d+)\s*\|\s*NOME\s*\|\s*(\S+)\s*$")
      if ($mn.Success) { [void]$EANOMI.Add($mn.Groups[2].Value); continue }
      $m = [regex]::Match($l, "^\s*([A-Za-z0-9._]+)\s*\|\s*(ATTESA|VIETATA|CAMPO)\s*\|\s*(.+?)\s*$")
      if (-not $m.Success) { continue }
      $testo = $m.Groups[3].Value
      $troncata = "no"
      $lt = $testo.IndexOf("<")
      if ($lt -ge 0) { $testo = $testo.Substring(0, $lt).TrimEnd(); $troncata = "si (al segnaposto)" }
      if ([string]::IsNullOrEmpty($testo)) { continue }
      [void]$ATTESE.Add([pscustomobject]@{
        Chiave = $m.Groups[1].Value
        Tipo   = $m.Groups[2].Value
        Testo  = $testo
        Troncata = $troncata
        Righe  = (New-Object System.Collections.ArrayList)
      })
    }
    $nA = @($ATTESE | Where-Object { $_.Tipo -eq "ATTESA"  }).Count
    $nV = @($ATTESE | Where-Object { $_.Tipo -eq "VIETATA" }).Count
    $nC = @($ATTESE | Where-Object { $_.Tipo -eq "CAMPO"   }).Count
    if ($ATTESE.Count -lt 10) {
      $P_artefatto = "SOSPETTO (solo " + $ATTESE.Count + " voci lette: artefatto troncato?)"
      Riga ("ARTEFATTO: solo " + $ATTESE.Count + " voci lette dal pin -- NON mi fido, il censimento sarebbe cieco.") "Red"
    } else {
      $P_artefatto = "OK (" + $nA + " ATTESA, " + $nV + " VIETATA, " + $nC + " CAMPO, " + $EANOMI.Count + " NOMI EA, dal pin " + $Pin + ")"
      Riga ("ARTEFATTO dal pin : " + $nA + " ATTESA, " + $nV + " VIETATA, " + $nC + " CAMPO, " + $EANOMI.Count + " nomi EA") "Green"
      if ($EANOMI.Count -eq 0) {
        Riga "  NESSUN nome EA letto dall'artefatto: il criterio 6 perde il conteggio delle righe dei 5 mirror" "Yellow"
        Riga "  dentro la pausa (resta tutto il resto). Non e' un rosso: e' una misura in meno, dichiarata." "Yellow"
      } else {
        Riga ("  nomi EA letti dall'artefatto: " + ($EANOMI -join " ")) "Gray"
      }
    }
  } catch {
    $P_artefatto = "FALLITO (" + $_.Exception.Message + ")"
    Riga ("ARTEFATTO NON SCARICATO dal pin: " + $_.Exception.Message) "Red"
    Riga "Senza l'artefatto il censimento non si fa: le frasi che fanno fede stanno LI', non qui dentro." "Red"
  }

  # ---------------------------------------------------------------
  #  4) I LOG DI OGGI (Esperti = dove scrivono Guardian, EA e canarino)
  # ---------------------------------------------------------------
  $oggiFile = $Avvio.ToString("yyyyMMdd", $INV)
  $logEsperti = Join-Path $espertiDir ($oggiFile + ".log")
  $logGiornale= Join-Path $giornaleDir ($oggiFile + ".log")
  $RIGHE = @()
  $dataLog = $oggiFile
  if (Test-Path $logEsperti) {
    $t = Leggi-Testo $logEsperti
    $RIGHE = @($t -split "`r?`n" | Where-Object { $_.Trim().Length -gt 0 })
    $P_log = "OK (" + (Split-Path -Leaf $logEsperti) + ", " + $RIGHE.Count + " righe)"
    Riga ("LOG ESPERTI -V3   : " + $logEsperti) "Gray"
    Riga ("                    " + $RIGHE.Count + " righe, ultima scrittura " + (Get-Item $logEsperti).LastWriteTime.ToString("HH:mm:ss", $INV)) "Gray"
  } else {
    $ultimi = @(Get-ChildItem $espertiDir -Filter "*.log" -ErrorAction SilentlyContinue | Sort-Object Name -Descending)
    if ($ultimi.Count -gt 0) {
      $logEsperti = $ultimi[0].FullName
      $dataLog = $ultimi[0].BaseName
      $t = Leggi-Testo $logEsperti
      $RIGHE = @($t -split "`r?`n" | Where-Object { $_.Trim().Length -gt 0 })
      $P_log = "RIPIEGO (nessun log di OGGI: letto " + $dataLog + ", " + $RIGHE.Count + " righe)"
      Riga ("ATTENZIONE: nessun log Esperti di OGGI (" + $oggiFile + "). Letto il piu' recente: " + $dataLog) "Yellow"
      Riga "            Un log che non e' di oggi NON misura la sessione di oggi: dichiaralo." "Yellow"
    } else {
      $P_log = "FALLITO (nessun log Esperti nella cartella " + $espertiDir + ")"
      Riga ("NESSUN LOG ESPERTI in " + $espertiDir) "Red"
    }
  }

  # ---------------------------------------------------------------
  #  5) IL SEGNAPOSTO: separa "prima" e "durante" la sessione.
  # ---------------------------------------------------------------
  $inizioSessione = ""
  if ($P_modo -eq "LETTURA PRIMA") {
    try {
      @("inizio sessione 2 (ora LOCALE VPS): " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss", $INV)) |
        Set-Content -Path $segnPath -Encoding ASCII
      $inizioSessione = $Avvio.ToString("HH:mm:ss", $INV)
      Riga ("SEGNAPOSTO scritto: " + $segnPath + "  (ora " + $inizioSessione + ")") "Gray"
    } catch {
      Riga ("SEGNAPOSTO non scritto: " + $_.Exception.Message + " -- la raccolta finale censira' TUTTA la giornata.") "Yellow"
    }
  } else {
    if (Test-Path $segnPath) {
      $sg = ""
      try { $sg = (Get-Content -LiteralPath $segnPath -ErrorAction Stop | Select-Object -First 1) } catch { $sg = "" }
      $m = [regex]::Match([string]$sg, "(\d{4}-\d{2}-\d{2}) (\d{2}:\d{2}:\d{2})")
      if ($m.Success) {
        if ($m.Groups[1].Value -eq $Avvio.ToString("yyyy-MM-dd", $INV)) {
          $inizioSessione = $m.Groups[2].Value
          Riga ("SEGNAPOSTO d'inizio sessione: " + $inizioSessione + " (ora locale VPS)") "Gray"
        } else {
          Riga ("SEGNAPOSTO di un ALTRO GIORNO (" + $m.Groups[1].Value + "): ignorato, censimento su tutta la giornata.") "Yellow"
        }
      }
    }
    if (-not $inizioSessione) {
      Riga "SEGNAPOSTO assente: il censimento copre TUTTA la giornata (lettura piu' larga, dichiarata)." "Yellow"
    }
  }

  # ---------------------------------------------------------------
  #  6) MODO PRESIDIO -- coda dal vivo, senza euristiche del silenzio
  # ---------------------------------------------------------------
  if ($P_modo -eq "PRESIDIO") {
    if ($Minuti -lt 1)  { $Minuti = 1 }
    if ($Minuti -gt 60) { $Minuti = 60 }
    Riga ""
    Riga ("=== PRESIDIO: " + $Minuti + " minuti di coda dal vivo sul log Esperti ===") "Cyan"
    Riga "Stampo SOLO le righe nuove che contengono [GUARDIAN], [GUARDIA] o [CANARINO]," "Gray"
    Riga "piu' la spia A1 (tetto di esposizione per simbolo)." "Gray"
    Riga "Ctrl+C interrompe: non si perde niente, il log resta dov'e'." "Gray"
    Riga ""
    $lung = 0
    if (Test-Path $logEsperti) { $lung = (Get-Item $logEsperti).Length }
    $fine = $Avvio.AddMinutes($Minuti)
    $nNuove = 0
    while ((Get-Date) -lt $fine) {
      Start-Sleep -Seconds 10
      if (-not (Test-Path $logEsperti)) { continue }
      $len = (Get-Item $logEsperti).Length
      if ($len -le $lung) { continue }
      $t = Leggi-TestoDa $logEsperti $lung
      $lung = $len
      foreach ($r in ($t -split "`r?`n")) {
        if ($r.Trim().Length -eq 0) { continue }
        $interessa = $false
        foreach ($tk in @("[GUARDIAN]", "[GUARDIA]", "[CANARINO]", "fra posizioni e pendenti (tetto")) {
          if (Contiene $r $tk) { $interessa = $true }
        }
        if (-not $interessa) { continue }
        $nNuove++
        $col = "White"
        if (Contiene $r "INGRESSO BLOCCATO") { $col = "Green" }
        if (Contiene $r "via libera")        { $col = "Green" }
        if (Contiene $r "SFONDAT")           { $col = "Red" }
        if (Contiene $r "FILO ROTTO")        { $col = "Red" }
        Riga ("  " + $r.Trim()) $col
      }
    }
    Riga ""
    Riga ("PRESIDIO FINITO: " + $nNuove + " righe nuove di interesse in " + $Minuti + " minuti.") "Cyan"
    if ($nNuove -eq 0) {
      Riga "ZERO RIGHE NUOVE NON E' UN PASS: e' NON MISURATO." "Yellow"
      Riga "Il silenzio e' compatibile sia con 'l'enforcement funziona' sia con 'nessun EA voleva entrare'." "Yellow"
      Riga "La prova del criterio 7 lato EA si ripete in un'altra finestra d'ingresso (vedi la pagina)." "Yellow"
    }
    # rileggo tutto il file per il censimento finale di questo referto
    if (Test-Path $logEsperti) {
      $t = Leggi-Testo $logEsperti
      $RIGHE = @($t -split "`r?`n" | Where-Object { $_.Trim().Length -gt 0 })
    }
  }

  # ---------------------------------------------------------------
  #  7) CENSIMENTO CONTRO L'ARTEFATTO (sottostringa, come dice lui)
  # ---------------------------------------------------------------
  if ($ATTESE.Count -ge 10 -and $RIGHE.Count -gt 0) {
    foreach ($r in $RIGHE) {
      foreach ($a in $ATTESE) {
        if (Contiene $r $a.Testo) { [void]$a.Righe.Add($r.Trim()) }
      }
    }
    $P_censimento = "OK (" + $RIGHE.Count + " righe di log passate su " + $ATTESE.Count + " voci del contratto)"

    Riga ""
    Riga ("=== CENSIMENTO DELLE RIGHE CHE FANNO FEDE (log di " + $dataLog + ", ora LOCALE VPS) ===") "Cyan"
    foreach ($a in $ATTESE) {
      $n = $a.Righe.Count
      $nDopo = 0
      if ($inizioSessione) { $nDopo = Conta-Dopo $a $inizioSessione }
      $etichetta = ("  " + $a.Chiave.PadRight(14) + $a.Tipo.PadRight(9) + "trovate " + $n)
      if ($inizioSessione) { $etichetta = $etichetta + "  (dopo il segnaposto: " + $nDopo + ")" }
      $col = "Gray"
      if ($a.Tipo -eq "VIETATA") { if ($n -gt 0) { $col = "Red" } else { $col = "Green" } }
      if ($a.Tipo -eq "ATTESA")  { if ($n -gt 0) { $col = "Green" } else { $col = "Yellow" } }
      Riga $etichetta $col
      $mostra = 0
      foreach ($rr in $a.Righe) {
        if ($mostra -ge 6) { RigaSoloFile ("      ... (" + ($n - 6) + " righe non stampate a video, tutte nello zip)"); break }
        Riga ("      " + $rr) $col
        $mostra++
      }
    }
  } elseif ($RIGHE.Count -eq 0) {
    $P_censimento = "NON FATTO (nessuna riga di log)"
  } else {
    $P_censimento = "NON FATTO (artefatto non disponibile)"
  }

  # --- le VIETATE: se una compare, ci si ferma. E' la regola dell'artefatto.
  $vietateTrovate = 0
  foreach ($a in $ATTESE) { if ($a.Tipo -eq "VIETATA") { $vietateTrovate += $a.Righe.Count } }

  # ---------------------------------------------------------------
  #  8) TRACCIA DELLE SOGLIE E DEGLI AVVII DEL GUARDIAN
  #     (e' il diario a macchina dei gesti di Claudio sulla PAUSA:
  #      ogni cambio di parametri riavvia il Guardian e ristampa
  #      la riga delle soglie col valore NUOVO. Il cap si stampa lo
  #      stesso, perche' in questa sessione NON deve muoversi: se si
  #      muove, e' stato toccato il campo sbagliato.)
  # ---------------------------------------------------------------
  Riga ""
  Riga "=== TRACCIA DEL GUARDIAN: avvii e soglie (ora LOCALE VPS) ===" "Cyan"
  $contesti = @{}
  $nAvvii = 0
  $ultimoCap   = [double]::NaN
  $ultimaPausa = [double]::NaN
  $capMosso = $false
  $SOGLIE = New-Object System.Collections.ArrayList   # (Ora, Pausa, Cap) in ordine di log
  foreach ($r in $RIGHE) {
    if (Contiene $r "[GUARDIAN] avviato. Saldo iniziale=") {
      $nAvvii++
      $c = Contesto-Riga $r
      if ($c) { $contesti[$c] = 1 }
      Riga ("  " + (Ora-Riga $r) + "  AVVIO   " + $r.Trim()) "White"
    }
    if (Contiene $r "pausa morbida=") {
      $m = [regex]::Match($r, "pausa morbida=([0-9.]+)%\s+cap rischio aperto=([0-9.]+)%")
      if ($m.Success) {
        $pausa = Num-Inv $m.Groups[1].Value
        $cap   = Num-Inv $m.Groups[2].Value
        $ultimoCap = $cap
        $ultimaPausa = $pausa
        if ($cap -ne 3.25) { $capMosso = $true }
        [void]$SOGLIE.Add([pscustomobject]@{ Ora = (Ora-Riga $r); Pausa = $pausa; Cap = $cap })
        $nota = ""
        if ($pausa -eq 4.00 -and $cap -eq 3.25) { $nota = "  <-- configurazione FIRMATA (4,0 / 3,25)" }
        elseif ($pausa -lt 4.00) { $nota = "  <-- PAUSA ABBASSATA per la prova (criterio 5)" }
        if ($cap -ne 3.25) { $nota = $nota + "   !! IL CAP NON E' 3,25: in questa sessione NON doveva essere toccato" }
        Riga ("  " + (Ora-Riga $r) + "  SOGLIE  pausa=" + $pausa.ToString("0.00", $INV) + "%  cap=" + $cap.ToString("0.00", $INV) + "%" + $nota) "White"
      }
    }
  }
  if ($nAvvii -eq 0) { Riga "  nessuna riga di avvio del Guardian nel log di questa giornata." "Yellow" }
  Riga ("  avvii del Guardian nella giornata: " + $nAvvii + "   (uno per ogni riavvio/cambio parametri/riattacco)") "Gray"
  if ($contesti.Keys.Count -gt 1) {
    Riga ("  SPIA B9: contesti DIVERSI che scrivono [GUARDIAN]: " + ($contesti.Keys -join " | ")) "Red"
    Riga "  Due Guardian sullo stesso conto si timbrano addosso. La PROVA e' il menu Finestra (P-2)." "Red"
  } elseif ($contesti.Keys.Count -eq 1) {
    Riga ("  contesto unico che scrive [GUARDIAN]: " + ($contesti.Keys -join "") + " (spia coerente con UN SOLO Guardian; la prova resta P-2)") "Green"
  }
  if (-not [double]::IsNaN($ultimaPausa)) {
    if ($ultimaPausa -eq 4.00) { Riga ("  ULTIMA soglia di PAUSA dichiarata nel log: " + $ultimaPausa.ToString("0.00", $INV) + "% = configurazione firmata") "Green" }
    else { Riga ("  ULTIMA soglia di PAUSA dichiarata nel log: " + $ultimaPausa.ToString("0.00", $INV) + "% -- NON e' il 4,0 firmato: il passo 1 del ripristino MANCA.") "Red" }
  }
  if (-not [double]::IsNaN($ultimoCap)) {
    if ($ultimoCap -eq 3.25) { Riga ("  ULTIMO cap dichiarato nel log: " + $ultimoCap.ToString("0.00", $INV) + "% = configurazione firmata (in questa sessione non doveva cambiare, e infatti non e' cambiato)") "Green" }
    else { Riga ("  ULTIMO cap dichiarato nel log: " + $ultimoCap.ToString("0.00", $INV) + "% -- NON e' il 3,25 firmato: il 100k NON e' tornato a casa.") "Red" }
  }
  if ($capMosso) {
    Riga "  ATTENZIONE: nella giornata il cap ha assunto un valore diverso da 3,25. La sessione 2 tocca SOLO" "Yellow"
    Riga "  InpDailyPausePct: se il cap si e' mosso oggi, o e' rimasto un residuo della sessione 1, oppure e'" "Yellow"
    Riga "  stato toccato il campo sbagliato. Va spiegato nel verbale prima di dare qualunque verdetto." "Yellow"
  }

  # ---------------------------------------------------------------
  #  8-bis) IL LATCH DELLA PAUSA (rilievo R2 / rischio X7).
  #
  #  QUESTO E' IL CONTROLLO PIU' IMPORTANTE DELL'INTERA SESSIONE 2, e
  #  non riguarda il criterio: riguarda il fatto che il 100k torni a
  #  operare. La pausa NON si spegne rialzando la soglia. L'uscita e' a
  #  due passi: 1) InpDailyPausePct=4.0, 2) cancellare le due GV da F3.
  #  Se si fa il 2 PRIMA dell'1, il giro di timer successivo (1 s) le
  #  riscrive e RISTAMPA la riga di accensione (SetPausa, Guardian riga
  #  189: la riga esce solo alla PRIMA accensione, cioe' quando la GV
  #  e' tornata a zero). Percio': UNA RIGA DI ACCENSIONE DELLA PAUSA
  #  DOPO IL RITORNO A 4.00 = LE GV SONO STATE CANCELLATE TROPPO PRESTO
  #  E LA PAUSA E' ANCORA ACCESA.
  #
  #  LIMITE DICHIARATO: questa riga NON puo' leggere le GlobalVariable
  #  (stanno dentro il terminale). La PROVA che il latch e' spento e'
  #  la corsa del canarino DOPO il passo 2, che stampa
  #  "PAUSA B1 grezzo(ts>0)=NO". Qui c'e' l'indizio dai log; la misura
  #  e' piu' sotto, nella sezione dei referti del canarino.
  # ---------------------------------------------------------------
  $oraAbbassata   = ""      # ultima riga soglie con pausa < 4.00
  $oraRitorno     = ""      # prima riga soglie con pausa = 4.00 DOPO l'abbassamento
  foreach ($s in $SOGLIE) { if ($s.Pausa -lt 4.00) { $oraAbbassata = $s.Ora } }
  if ($oraAbbassata) {
    foreach ($s in $SOGLIE) {
      if ($s.Pausa -eq 4.00 -and $s.Ora -and ($s.Ora -gt $oraAbbassata) -and (-not $oraRitorno)) { $oraRitorno = $s.Ora }
    }
  }
  $accensioni = @($RIGHE | Where-Object { Contiene $_ "* PAUSA NUOVI INGRESSI attiva:" })
  $accensioniDopoRitorno = @()
  if ($oraRitorno) {
    $accensioniDopoRitorno = @($accensioni | Where-Object { $o = Ora-Riga $_; $o -and ($o -ge $oraRitorno) })
  }
  Riga ""
  Riga "=== IL LATCH DELLA PAUSA: i due passi del ripristino, letti dai log ===" "Cyan"
  Riga ("  soglia ABBASSATA (ultima riga con pausa < 4,00) : " + $(if ($oraAbbassata) { $oraAbbassata } else { "MAI in questo log" }))
  Riga ("  soglia RIMESSA a 4,00 dopo l'abbassamento       : " + $(if ($oraRitorno) { $oraRitorno } else { "NON ANCORA" })) (@{$true="Green";$false="Yellow"}[[bool]$oraRitorno])
  Riga ("  accensioni della pausa nel log della giornata   : " + $accensioni.Count)
  foreach ($x in $accensioni) { Riga ("    " + (Ora-Riga $x) + "  " + $x.Trim()) "White" }
  if ($oraAbbassata -and -not $oraRitorno) {
    Riga "  PASSO 1 DEL RIPRISTINO NON ANCORA FATTO: la soglia e' ancora bassa. Se la sessione e' finita," "Red"
    Riga "  il 100k resta in pausa fino al reset del giorno prop. Rimettere InpDailyPausePct=4.0, POI F3." "Red"
  }
  if ($accensioniDopoRitorno.Count -gt 0) {
    Riga ("  *** ROSSO: " + $accensioniDopoRitorno.Count + " accensione/i della pausa DOPO il ritorno a 4,00. ***") "Red"
    Riga "  Vuol dire che le due GlobalVariable sono state cancellate PRIMA di rialzare la soglia (ordine" "Red"
    Riga "  invertito, rilievo R2): il Guardian le ha riscritte al giro di timer successivo e IL 100k E'" "Red"
    Riga "  ANCORA IN PAUSA. Rifare l'uscita nell'ordine giusto: 1) soglia a 4.0, 2) F3." "Red"
    foreach ($x in $accensioniDopoRitorno) { Riga ("    " + (Ora-Riga $x) + "  " + $x.Trim()) "Red" }
  } elseif ($oraRitorno) {
    Riga "  nessuna accensione della pausa dopo il ritorno a 4,00: coerente con un'uscita nell'ordine giusto." "Green"
    Riga "  (La PROVA che le due GV sono sparite resta la corsa del canarino con PAUSA B1 grezzo=NO.)" "Gray"
  }

  # ---------------------------------------------------------------
  #  9) L'ULTIMA FOTO PERIODICA DEL GUARDIAN (eq=, ogni 300 s se
  #     InpVerbose=true): il MASSIMO di rischioAperto della giornata
  #     E -- per questa sessione -- IL GATE DELLA GIORNATA IN PERDITA
  # ---------------------------------------------------------------
  Riga ""
  Riga "=== FOTO PERIODICHE DEL GUARDIAN: perdita del giorno e rischio aperto ===" "Cyan"
  $maxRischio = [double]::NaN
  $ultimoDayLoss = [double]::NaN
  $maxDayLoss = [double]::NaN
  $ultimaEq = ""
  $ultimaEqOra = ""
  $nPeriodiche = 0
  foreach ($r in $RIGHE) {
    if (-not (Contiene $r "rischioAperto=")) { continue }
    $nPeriodiche++
    $ultimaEq = $r.Trim(); $ultimaEqOra = Ora-Riga $r
    $m = [regex]::Match($r, "rischioAperto=(-?[0-9.]+)%")
    if ($m.Success) {
      $v = Num-Inv $m.Groups[1].Value
      if (-not [double]::IsNaN($v)) {
        if ([double]::IsNaN($maxRischio) -or $v -gt $maxRischio) { $maxRischio = $v }
      }
    }
    # dayLoss e' POSITIVO quando la giornata e' IN PERDITA:
    # dailyPct = 100*(saldo a inizio giornata - equity)/saldo iniziale
    # (ABTG_Guardian.mq5 righe 366-369). Un numero NEGATIVO = giornata in UTILE.
    $md = [regex]::Match($r, "dayLoss=(-?[0-9.]+)%")
    if ($md.Success) {
      $d = Num-Inv $md.Groups[1].Value
      if (-not [double]::IsNaN($d)) {
        $ultimoDayLoss = $d
        if ([double]::IsNaN($maxDayLoss) -or $d -gt $maxDayLoss) { $maxDayLoss = $d }
      }
    }
  }
  if ($ultimaEq) {
    Riga ("  righe periodiche lette: " + $nPeriodiche + "   ULTIMA (" + $ultimaEqOra + "): " + $ultimaEq) "White"
    if ([double]::IsNaN($maxRischio)) {
      Riga "  rischioAperto non estratto: formato inatteso." "Yellow"
    } else {
      Riga ("  MASSIMO rischioAperto della giornata: " + $maxRischio.ToString("0.00", $INV) + "%   (cancello di fase: <= 3,25%)") "White"
    }
    Riga "  CAVEAT DA RIPETERE SEMPRE INSIEME AL NUMERO (R7): (a) campionamento ogni 300 s, i picchi" "Gray"
    Riga "  fra due campioni non si vedono; (b) il cap e' CIECO SUI PENDENTI (buco B6): e' un LIMITE INFERIORE." "Gray"
  } else {
    Riga "  nessuna riga periodica trovata: InpVerbose potrebbe essere false, oppure il Guardian non gira." "Yellow"
    Riga "  Perdita del giorno e rischio aperto li dicono comunque il PANNELLO (P-4/P-5) e il CANARINO." "Yellow"
  }

  # ---------------------------------------------------------------
  #  9-bis) IL GATE DELLA SESSIONE 2: LA GIORNATA DEV'ESSERE IN PERDITA
  #
  #  Precondizione FISICA, non preferenza (ABTG_Guardian.mq5 riga 400):
  #      if(InpDailyPausePct>0 && dailyPct>=InpDailyPausePct)
  #  e InpDailyPausePct=0 significa "pausa spenta". Quindi non esiste
  #  nessun valore della soglia che accenda la pausa se dailyPct<=0.
  #  Se la giornata non e' in perdita, la prova SI RIMANDA: non e' un
  #  difetto dell'enforcement, e' il criterio che non e' innescabile.
  #
  #  QUESTA E' UNA SPIA, NON IL NUMERO CHE DECIDE: dayLoss= e' campionato
  #  ogni 300 s, quindi puo' essere vecchio di 5 minuti. Il numero che
  #  decide e' il campo "Perdita oggi" del PANNELLO, che Claudio legge
  #  ADESSO (prerequisito P-4).
  # ---------------------------------------------------------------
  Riga ""
  Riga "=== GATE DELLA SESSIONE 2: la giornata e' in perdita? (criterio 5) ===" "Cyan"
  if ([double]::IsNaN($ultimoDayLoss)) {
    Riga "  dayLoss NON LETTO dai log (nessuna riga periodica, o formato inatteso)." "Yellow"
    Riga "  GATE NON MISURATO A MACCHINA: decide il campo 'Perdita oggi' del pannello (P-4)." "Yellow"
    Riga "  Se il pannello dice 'Perdita oggi' <= 0, LA SESSIONE SI RIMANDA: la pausa non e' innescabile." "Yellow"
  } else {
    Riga ("  ULTIMO dayLoss letto (" + $ultimaEqOra + "): " + $ultimoDayLoss.ToString("0.00", $INV) + "%   [positivo = giornata IN PERDITA]") "White"
    Riga ("  MASSIMO dayLoss della giornata           : " + $maxDayLoss.ToString("0.00", $INV) + "%") "White"
    if ($ultimoDayLoss -gt 0.0) {
      Riga ("  GATE APERTO (spia): la giornata e' in perdita. Soglia suggerita per la prova: un valore") "Green"
      Riga ("  POSITIVO e chiaramente SOTTO la perdita letta dal PANNELLO adesso (esempio: pannello -0,06% -> 0,03).") "Green"
      Riga  "  Il perche' del 'chiaramente sotto': dailyPct si muove a ogni tick con l'equity; una soglia" "Gray"
      Riga  "  incollata al valore letto puo' non mordere piu' un secondo dopo, e la prova sembrerebbe fallita." "Gray"
    } else {
      Riga ("  GATE CHIUSO (spia): dayLoss = " + $ultimoDayLoss.ToString("0.00", $INV) + "% <= 0 -> LA PAUSA NON E' INNESCABILE.") "Yellow"
      Riga  "  NON E' UN FALLIMENTO DELL'ENFORCEMENT: e' la precondizione fisica del criterio 5 (Guardian riga 400)." "Yellow"
      Riga  "  Si RIMANDA la sessione a una giornata in perdita, anche di una frazione (il 03/09 bastava -0,06%)." "Yellow"
      Riga  "  Prima di rimandare, guarda il PANNELLO: il log e' vecchio fino a 5 minuti, il pannello e' di adesso." "Yellow"
    }
  }

  # ---------------------------------------------------------------
  # 10) I REFERTI DEL CANARINO (la parte DETERMINISTICA dei criteri 7/8)
  # ---------------------------------------------------------------
  Riga ""
  Riga "=== REFERTI DEL CANARINO (MQL5\Files\ABTG_Canarino_*.txt) ===" "Cyan"
  $filesDir = Join-Path $DataFolder "MQL5\Files"
  $daQuando = $Avvio.Date
  if ($inizioSessione) {
    try { $daQuando = [datetime]::ParseExact($Avvio.ToString("yyyy-MM-dd", $INV) + " " + $inizioSessione, "yyyy-MM-dd HH:mm:ss", $INV) } catch { $daQuando = $Avvio.Date }
  }
  $canFiles = @()
  if (Test-Path $filesDir) {
    $canFiles = @(Get-ChildItem $filesDir -Filter "ABTG_Canarino_*.txt" -ErrorAction SilentlyContinue |
                  Where-Object { $_.LastWriteTime -ge $daQuando } | Sort-Object LastWriteTime)
  }
  if ($canFiles.Count -eq 0) {
    $P_canarino = "NESSUN REFERTO dopo le " + $daQuando.ToString("HH:mm:ss", $INV)
    Riga ("  nessun referto del canarino scritto dopo le " + $daQuando.ToString("HH:mm:ss", $INV) + " (ora locale VPS).") "Yellow"
    Riga "  Nel modo LETTURA PRIMA e' NORMALE (il canarino lo lanci tu dopo). Nella RACCOLTA FINALE" "Yellow"
    Riga "  vuol dire che le corse del canarino non ci sono: manca la parte deterministica del criterio 5" "Yellow"
    Riga "  E manca la sola misura a macchina del criterio 6 (il confronto degli SL fra due corse)." "Yellow"
  } else {
    $P_canarino = $canFiles.Count.ToString() + " referti letti"
    $riass = New-Object System.Collections.ArrayList
    foreach ($f in $canFiles) {
      $txt = ""
      try { $txt = (Get-Content -LiteralPath $f.FullName -Raw -ErrorAction Stop) } catch { $txt = "" }
      $rr = @($txt -split "`r?`n")
      $login = ""; $canale = ""; $motivo = ""; $esito = ""; $gvRisk = ""
      $capG = ""; $capC = ""; $vivoG = ""; $vivoC = ""; $pausaG = ""; $pausaC = ""
      $rilievi = "?"; $autotest = "?"; $rosso = 0; $fail = 0; $fuori = 0
      $timbroCap = ""; $secFa = ""
      $accensPausa = ""; $scadenzaPausa = ""
      # LE POSIZIONI DI QUESTA CORSA: e' il materiale del criterio 6.
      # Il canarino stampa, per ogni posizione aperta:
      #   [CANARINO]   pos #<ticket> magic=<n> <SIMBOLO> BUY|SELL vol=.. apert=.. corr=.. sl=<valore|NESSUNO> ...
      $POS = @{}
      foreach ($l in $rr) {
        if ($l.Trim().Length -eq 0) { continue }
        if (-not $l.StartsWith("[CANARINO]")) { $fuori++ }
        if ($l -match "login=(\d+)") { if (-not $login) { $login = $Matches[1] } }
        if ($l -match "ABTG_CanaleEsiste\(\)\s*=\s*(SI|NO)") { $canale = $Matches[1] }
        $mc = [regex]::Match($l, "^\[CANARINO\]\s+(PAUSA B1|CAP C1|GUARDIAN VIVO)\s+grezzo\(ts>0\)=(SI|NO)\s+\S+\s*=\s*(SI|NO)")
        if ($mc.Success) {
          if ($mc.Groups[1].Value -eq "CAP C1")        { $capG = $mc.Groups[2].Value;  $capC = $mc.Groups[3].Value }
          if ($mc.Groups[1].Value -eq "GUARDIAN VIVO") { $vivoG = $mc.Groups[2].Value; $vivoC = $mc.Groups[3].Value }
          if ($mc.Groups[1].Value -eq "PAUSA B1")      { $pausaG = $mc.Groups[2].Value; $pausaC = $mc.Groups[3].Value }
        }
        if ($l -match "MOTIVO con pretendi_guardian=false[^:]*:\s*(\d+)\s*=\s*(.+)$") { $motivo = $Matches[1] + " = " + $Matches[2].Trim() }
        if ($l -match "ESITO PER UN EA ADESSO: un ingresso sarebbe (PERMESSO|FERMATO)") { $esito = $Matches[1] }
        if ($l -match "scritto dal Guardian \(GV\.4\)\s*:\s*(-?[0-9.]+)%") { $gvRisk = $Matches[1] }
        if ($l -match "ultimo timbro (\d{4}\.\d{2}\.\d{2} \d{2}:\d{2}:\d{2}), cioe' (-?\d+) secondi fa") { $timbroCap = $Matches[1]; $secFa = $Matches[2] }
        if ($l -match "dettaglio: accensione=(.+?)\s+scadenza=(.+?)\s+adesso=") { $accensPausa = $Matches[1]; $scadenzaPausa = $Matches[2] }
        $mp = [regex]::Match($l, "pos #(\d+) magic=(-?\d+)\s+(\S+)\s+(BUY|SELL)\s+vol=([0-9.]+)\s+apert=([0-9.]+)\s+corr=([0-9.]+)\s+sl=(\S+)")
        if ($mp.Success) {
          $POS[$mp.Groups[1].Value] = [pscustomobject]@{
            Ticket = $mp.Groups[1].Value; Magic = $mp.Groups[2].Value; Simbolo = $mp.Groups[3].Value
            Lato = $mp.Groups[4].Value;   Vol = $mp.Groups[5].Value;   Apert = $mp.Groups[6].Value
            Corr = $mp.Groups[7].Value;   SL = $mp.Groups[8].Value }
        }
        if ($l -match "RILIEVI:\s*(\d+)") { $rilievi = $Matches[1] }
        if (Contiene $l "nessun rilievo") { $rilievi = "0" }
        if ($l -match "AUTOTEST:\s*(\d+) blocchi su (\d+) passati \(falliti (\d+), attesi (\d+)\)") { $autotest = $Matches[1] + "/" + $Matches[2] + " passati, falliti " + $Matches[3] + ", attesi " + $Matches[4] }
        if (Contiene $l "*** ROSSO CANARINO ***") { $rosso++ }
        if (Contiene $l "*** FAIL ***") { $fail++ }
      }
      $tipo = "NON CLASSIFICATO"
      if ($capG -eq "SI" -and $capC -eq "SI") { $tipo = "CORSA CON CAP ATTIVO (criterio 7)" }
      elseif ($capG -eq "SI" -and $capC -eq "NO") { $tipo = "CORSA DI FAIL-OPEN: timbro vecchio, cap SCADUTO (criterio 8)" }
      elseif ($capG -eq "NO") { $tipo = "corsa con cap SPENTO (fotografia)" }
      Riga ("  --- " + $f.Name + "   (scritto alle " + $f.LastWriteTime.ToString("HH:mm:ss", $INV) + " locali)") "White"
      Riga ("      classificazione : " + $tipo) "White"
      Riga ("      login           : " + $login + "   canale esiste: " + $canale) (@{$true="Green";$false="Red"}[($login -eq $CONTO_COLLAUDO -and $canale -eq "SI")])
      Riga ("      PAUSA B1        : grezzo=" + $pausaG + "  ricalcolato=" + $pausaC)
      Riga ("      CAP C1          : grezzo=" + $capG + "  ricalcolato=" + $capC)
      Riga ("      GUARDIAN VIVO   : grezzo=" + $vivoG + "  ricalcolato=" + $vivoC)
      if ($timbroCap) { Riga ("      ultimo timbro cap: " + $timbroCap + " (ora SERVER), cioe' " + $secFa + " secondi prima della corsa  [tolleranza 120 s]") "White" }
      Riga ("      MOTIVO (come i 5 mirror): " + $motivo)
      Riga ("      ESITO per un EA adesso  : " + $esito) (@{$true="Green";$false="Yellow"}[($esito -ne "")])
      Riga ("      rischio aperto GV.4     : " + $gvRisk + "%")
      Riga ("      rilievi: " + $rilievi + "   autotest: " + $autotest + "   ROSSO CANARINO: " + $rosso + "   '*** FAIL ***': " + $fail + "   righe fuori invariante: " + $fuori)
      if ($rosso -gt 0) { Riga "      AUTOTEST DEL CANARINO ROSSO: lo strumento di misura si e' dichiarato rotto. Non si legge niente." "Red" }
      if ($fail -gt 0)  { Riga "      ATTENZIONE: il referto del canarino contiene '*** FAIL ***', che e' la riga VIETATA STOP.AUTOTEST." "Red" }
      if ($fuori -gt 0) { Riga ("      " + $fuori + " righe NON iniziano con [CANARINO]: invariante del canarino violata, da dichiarare.") "Yellow" }
      [void]$riass.Add([pscustomobject]@{
        File=$f.Name; Ora=$f.LastWriteTime.ToString("HH:mm:ss",$INV); Tipo=$tipo; Login=$login;
        CapG=$capG; CapC=$capC; VivoG=$vivoG; VivoC=$vivoC; Motivo=$motivo; Esito=$esito;
        Rosso=$rosso; SecFa=$secFa; Timbro=$timbroCap })
      try { Copy-Item -LiteralPath $f.FullName -Destination (Join-Path $cart $f.Name) -Force } catch { }
    }
    $global:CAN_RIASS = $riass
  }

  # ---------------------------------------------------------------
  # 11) BLOCCHI E CAUSE (materiale del criterio 9, utile gia' oggi)
  # ---------------------------------------------------------------
  Riga ""
  Riga "=== BLOCCHI DEGLI EA E LORO CAUSA ===" "Cyan"
  $blocchi = @($RIGHE | Where-Object { Contiene $_ "INGRESSO BLOCCATO --" })
  $cause   = @($RIGHE | Where-Object { (Contiene $_ "* PAUSA NUOVI INGRESSI attiva:") -or (Contiene $_ "* CAP RISCHIO APERTO attivo:") })
  Riga ("  righe INGRESSO BLOCCATO nella giornata : " + $blocchi.Count)
  Riga ("  righe di CAUSA del Guardian            : " + $cause.Count)
  if ($blocchi.Count -gt 0) {
    $orfaniMinuto = 0
    $orfaniVigente = 0
    foreach ($b in $blocchi) {
      $ob = Ora-Riga $b
      $minB = ""
      if ($ob.Length -ge 5) { $minB = $ob.Substring(0,5) }
      $trovata = $false
      $trovataVig = $false
      foreach ($c in $cause) {
        $oc = Ora-Riga $c
        if ($oc.Length -ge 5 -and $minB -and $oc.Substring(0,5) -eq $minB) { $trovata = $true }
        if ($oc -and $ob -and ($oc -le $ob)) { $trovataVig = $true }
      }
      if (-not $trovata)    { $orfaniMinuto++ }
      if (-not $trovataVig) { $orfaniVigente++ }
      Riga ("    " + $ob + "  " + $b.Trim())
    }
    Riga ("  blocchi SENZA causa NELLO STESSO MINUTO (regola LETTERALE dell'artefatto): " + $orfaniMinuto) (@{$true="Yellow";$false="Green"}[($orfaniMinuto -gt 0)])
    Riga ("  blocchi SENZA NESSUNA CAUSA PRIMA (regola CAUSA VIGENTE, piu' fedele al codice): " + $orfaniVigente) (@{$true="Red";$false="Green"}[($orfaniVigente -gt 0)])
    Riga "  RILIEVO DI LETTURA (verificatore, 03/09): la regola letterale 'stessa causa nello stesso minuto'" "Yellow"
    Riga "  dell'artefatto e' PIU' SEVERA del codice: il Guardian stampa la causa UNA VOLTA SOLA, al CAMBIO" "Yellow"
    Riga "  di stato (righe 415-421), mentre gli EA possono bloccare molti minuti dopo. Un blocco senza causa" "Yellow"
    Riga "  nello stesso minuto NON e' automaticamente orfano: si guarda la causa VIGENTE (l'ultima accensione" "Yellow"
    Riga "  senza rientro prima di quel blocco). Da decidere PRIMA della sessione del criterio 9." "Yellow"
  }
  $spieA1 = @($RIGHE | Where-Object { Contiene $_ "fra posizioni e pendenti (tetto" })
  Riga ("  spia A1 (tetto per simbolo, InpMaxPosSimbolo>0) nella giornata: " + $spieA1.Count) (@{$true="Yellow";$false="Green"}[($spieA1.Count -gt 0)])
  foreach ($s in $spieA1) { Riga ("    " + $s.Trim()) "Yellow" }
  if ($spieA1.Count -gt 0) {
    Riga "  Se un EA non ha tentato l'ingresso PER IL TETTO A1, il suo silenzio NON e' un fail del cap:" "Yellow"
    Riga "  e' NON MISURATO, e va scritto nel verbale (nota ROUND.PRECEDENZA dell'artefatto)." "Yellow"
  }

  # ---------------------------------------------------------------
  # 12) VERDETTO A TRE STATI -- solo la parte che una macchina PUO' dire
  # ---------------------------------------------------------------
  if ($P_modo -eq "RACCOLTA FINALE") {
    Riga ""
    Riga "=== VERDETTO (parte a macchina). PASS / NON MISURATO / ROSSO ===" "Cyan"

    $canCap  = 0; $canFail = 0; $secFailOpen = ""
    if ($null -ne $global:CAN_RIASS) {
      foreach ($c in $global:CAN_RIASS) {
        if ($c.CapG -eq "SI" -and $c.CapC -eq "SI") { $canCap++ }
        if ($c.CapG -eq "SI" -and $c.CapC -eq "NO") { $canFail++; $secFailOpen = $c.SecFa }
      }
    }
    $c7Guardian = 0; $c7Ea = 0; $c8Rientro = 0
    foreach ($a in $ATTESE) {
      if ($a.Chiave -eq "C7.GUARDIAN") { $c7Guardian = Conta-Dopo $a $inizioSessione }
      if ($a.Chiave -eq "C7.EA")       { $c7Ea       = Conta-Dopo $a $inizioSessione }
      if ($a.Chiave -eq "C8.RIENTRO")  { $c8Rientro  = Conta-Dopo $a $inizioSessione }
    }
    if ($inizioSessione) {
      Riga ("  perimetro del verdetto: SOLO le righe dopo il segnaposto delle " + $inizioSessione + " (ora locale VPS)") "Gray"
    } else {
      Riga "  perimetro del verdetto: TUTTA la giornata (segnaposto assente: lettura piu' larga, dichiarata)" "Yellow"
    }

    # UN VERDETTO SUI LOG SI DA' SOLO SE IL CENSIMENTO E' AVVENUTO.
    # Senza artefatto (o senza log) tutti i contatori sono ZERO PER CECITA':
    # leggerli come "non misurato" sarebbe una diagnosi inventata.
    $censimentoFatto = ($P_censimento -like "OK*")
    if (-not $censimentoFatto) {
      Riga ("  VERDETTO SUI LOG: NON DATO. Il censimento non e' avvenuto (" + $P_censimento + ").") "Red"
      Riga "  I contatori sarebbero ZERO PER CECITA', non per assenza di eventi. Rilancia col pin giusto." "Red"
      Riga "  Sotto resta SOLO la parte che viene dai referti del canarino, che non dipende dall'artefatto." "Red"
    }

    if (-not $censimentoFatto) {
      Riga "  righe VIETATE: NON CONTROLLATE (censimento non fatto)" "Red"
    } elseif ($vietateTrovate -gt 0) {
      Riga ("  ROSSO: " + $vietateTrovate + " righe VIETATE nel log. CI SI FERMA (regola dell'artefatto).") "Red"
    } else {
      Riga "  righe VIETATE: 0 (nessun FILO ROTTO, nessuna soglia dura sfondata)" "Green"
    }

    Riga ""
    Riga "  CRITERIO 7 -- il cap che rifiuta l'ingresso" "White"
    Riga ("    [GUARDIAN] * CAP RISCHIO APERTO attivo   : " + $c7Guardian) (@{$true="Green";$false="Yellow"}[($c7Guardian -gt 0)])
    Riga ("    [GUARDIA] INGRESSO BLOCCATO ... (firma C1): " + $c7Ea) (@{$true="Green";$false="Yellow"}[($c7Ea -gt 0)])
    Riga ("    corse del canarino col cap ATTIVO         : " + $canCap) (@{$true="Green";$false="Yellow"}[($canCap -gt 0)])
    if (-not $censimentoFatto) {
      Riga "    -> le due righe di log qui sopra NON sono state cercate: verdetto sul criterio 7 NON DATO." "Red"
    } elseif ($c7Guardian -gt 0 -and $c7Ea -gt 0) {
      Riga "    -> la catena e' COMPLETA a macchina: il Guardian ha alzato la bandiera e un EA VERO l'ha letta." "Green"
      Riga "       Manca solo l'occhio: NESSUN ORDINE NUOVO nella scheda Trade/Storico dentro la finestra (screenshot)." "Green"
    } elseif ($c7Guardian -gt 0 -and $canCap -gt 0) {
      Riga "    -> NON MISURATO sul lato EA: la bandiera c'era e il CANALE risponde (canarino), ma nessun EA" "Yellow"
      Riga "       ha tentato di entrare in quella finestra. NON e' un PASS e NON e' un FAIL: si ripete." "Yellow"
    } elseif ($c7Guardian -eq 0) {
      Riga "    -> NON MISURATO: il cap non e' mai stato ATTIVO nel log di oggi (soglia non abbassata," "Yellow"
      Riga "       oppure rischio aperto 0,00% = criterio non innescabile, R1)." "Yellow"
    }

    Riga ""
    Riga "  CRITERIO 8 -- fail-open (si prova col CAP, MAI con la PAUSA)" "White"
    Riga ("    corse del canarino con cap SCADUTO per anzianita': " + $canFail) (@{$true="Green";$false="Yellow"}[($canFail -gt 0)])
    if ($canFail -gt 0 -and $secFailOpen) {
      Riga ("    attesa misurata fra l'ultimo timbro del cap e la corsa: " + $secFailOpen + " secondi (tolleranza 120 s)") "Green"
      Riga "    -> il cap e' scaduto DA SOLO col Guardian rimosso: il fail-open del CANALE e' MISURATO." "Green"
    }
    Riga ("    [GUARDIA] via libera ... (CAP RISCHIO APERTO)     : " + $c8Rientro) (@{$true="Green";$false="Yellow"}[($c8Rientro -gt 0)])
    if (-not $censimentoFatto) {
      Riga "    -> la riga di rientro dell'EA NON e' stata cercata: la parte EA del criterio 8 e' NON DATA." "Red"
    } elseif ($c8Rientro -gt 0) {
      Riga "    -> PASS PIENO: un EA vero, che era bloccato, ha scritto il rientro dopo la rimozione." "Green"
      if ($OraRimozione) { Riga ("       Confronta l'ora della riga con l'ora di rimozione che hai annotato: " + $OraRimozione) "Green" }
    } elseif ($canFail -gt 0) {
      Riga "    -> NON MISURATO sul lato EA (nessun EA ha richiamato la guardia nei minuti della rimozione)." "Yellow"
      Riga "       La parte deterministica (canale + include) e' verde: il canarino l'ha misurata." "Yellow"
    } else {
      Riga "    -> NON MISURATO: manca la corsa del canarino oltre i 120 s dalla rimozione del Guardian." "Yellow"
    }

    Riga ""
    Riga "  C7.RIENTRO -- ATTESA NON OTTENIBILE IN QUESTA SESSIONE, e non e' un difetto del collaudo:" "Yellow"
    Riga "  la riga '[GUARDIAN] cap rischio aperto rientrato:' la stampa il ramo else del timer SOLO se" "Yellow"
    Riga "  GV_CAP e' ancora > 0 (ABTG_Guardian.mq5 righe 425-428). Ma OGNI cambio di parametri e OGNI" "Yellow"
    Riga "  riattacco passano da OnInit, che azzera GV_CAP IN SILENZIO (riga 283): quando il cap torna a" "Yellow"
    Riga "  3,25 la bandiera e' gia' a zero e la riga non esce. Comparirebbe solo se il rischio scendesse" "Yellow"
    Riga "  sotto la soglia col Guardian ancora vivo e la soglia ancora bassa (una posizione che si chiude)." "Yellow"
    Riga "  -> la sua assenza NON si conta come FAIL del criterio 7." "Yellow"

    Riga ""
    Riga "  E LA PARTE CHE NESSUNA MACCHINA PUO' DIRE (la fa Claudio, con gli screenshot):" "White"
    Riga "   - nessun ORDINE NUOVO nella scheda Trade/Storico dentro la finestra di blocco;" "White"
    Riga "   - un solo Guardian nel menu Finestra (P-2);" "White"
    Riga "   - il pannello e' tornato a 4,9 / 9,9 / pausa 4,0 / cap 3,25 con Azione CHIUDI+BLOCCA (C-5)." "White"
  }

  # --- esito e codice d'uscita, a tre stati ---
  if ($vietateTrovate -gt 0) {
    $Esito = "ROSSO: righe VIETATE trovate (" + $vietateTrovate + ")"
    $CodiceUscita = 1
  } elseif ($P_conto -like "ROSSO*") {
    $Esito = "ROSSO: conto sbagliato"
    $CodiceUscita = 1
  } elseif ($P_log -like "FALLITO*" -or $P_artefatto -like "FALLITO*" -or $P_artefatto -like "SOSPETTO*") {
    $Esito = "PARZIALE: lettura incompleta (vedi i PASSI)"
    $CodiceUscita = 2
  } else {
    $Esito = "LETTURA COMPLETA"
    $CodiceUscita = 0
  }
}
}

# =====================================================================
#  RACCOLTA: referto + copie + zip sul Desktop (regola di casa, punto 2)
# =====================================================================
$Fine = Get-Date
$testa = New-Object System.Collections.ArrayList
[void]$testa.Add("data: " + $Avvio.ToString("yyyy-MM-dd HH:mm:ss", $INV) + "   (ora di AVVIO, ora LOCALE del VPS)")
[void]$testa.Add("fine: " + $Fine.ToString("yyyy-MM-dd HH:mm:ss", $INV))
[void]$testa.Add("modo: " + $P_modo)
[void]$testa.Add("pin:  " + $Pin)
[void]$testa.Add("terminale:  " + $P_terminale)
[void]$testa.Add("conto:      " + $P_conto)
[void]$testa.Add("artefatto:  " + $P_artefatto)
[void]$testa.Add("log:        " + $P_log)
[void]$testa.Add("censimento: " + $P_censimento)
[void]$testa.Add("canarino:   " + $P_canarino)
[void]$testa.Add("zip:        DA SCRIVERE")
[void]$testa.Add("esito: " + $Esito)
[void]$testa.Add("")
[void]$testa.Add("NOTA ORE: le righe di log di MT5 sono in ORA LOCALE del VPS (= ora italiana).")
[void]$testa.Add("Il grafico, le GlobalVariable e i referti del canarino sono in ORA SERVER (= italiana meno 1).")
[void]$testa.Add("")

$refPath = Join-Path $cart "RIGA_REFERTO_COLLAUDO_FASE1_S2.txt"
try {
  $tutto = New-Object System.Collections.ArrayList
  foreach ($t in $testa) { [void]$tutto.Add($t) }
  foreach ($t in $OUT)   { [void]$tutto.Add($t) }
  $tutto | Set-Content -Path $refPath -Encoding ASCII
} catch {
  Write-Host ("REFERTO NON SCRITTO: " + $_.Exception.Message) -ForegroundColor Red
}

# copie dei log della giornata (non e' una raccolta di massa: due file)
try {
  if ($logEsperti -and (Test-Path $logEsperti)) {
    $b = Leggi-Bytes $logEsperti 0
    $t = Bytes-Testo $b $true
    $t -split "`r?`n" | Set-Content -Path (Join-Path $cart ("esperti_" + $dataLog + ".txt")) -Encoding ASCII
  }
  if ($logGiornale -and (Test-Path $logGiornale)) {
    $b = Leggi-Bytes $logGiornale 0
    $t = Bytes-Testo $b $true
    $t -split "`r?`n" | Set-Content -Path (Join-Path $cart ("giornale_" + $dataLog + ".txt")) -Encoding ASCII
  }
} catch { }

try {
  if (Test-Path $zip) { Remove-Item $zip -Force }
  Compress-Archive -Path (Join-Path $cart "*") -DestinationPath $zip -Force -ErrorAction Stop
  $P_zip = "OK"
  (Get-Content -LiteralPath $refPath) -replace "^zip:        DA SCRIVERE", "zip:        OK" |
    Set-Content -Path $refPath -Encoding ASCII
  Write-Host ""
  Write-Host ("MANDA IN CHAT QUESTO FILE: " + $zip) -ForegroundColor Cyan
} catch {
  $P_zip = "FALLITO (" + $_.Exception.Message + ")"
  Write-Host ""
  Write-Host ("ZIP NON FATTO: " + $_.Exception.Message) -ForegroundColor Yellow
  Write-Host ("Mandami questa cartella: " + $cart) -ForegroundColor Yellow
}

Write-Host ("referto: " + $refPath) -ForegroundColor Gray
Write-Host ("esito:   " + $Esito) -ForegroundColor Cyan
exit $CodiceUscita
