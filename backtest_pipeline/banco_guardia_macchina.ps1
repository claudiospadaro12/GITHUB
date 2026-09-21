# =====================================================================
#  MARCATORE_BANCO_GUARDIA_MACCHINA_v2
#  banco_guardia_macchina.ps1 -- I CONTRO-ESEMPI DELLA GUARDIA v2,
#  RIGIRATI SU TUTTE E TRE LE COPIE
# ---------------------------------------------------------------------
#  PERCHE' ESISTE (21/09/2026)
#  La guardia decide QUALE terminale MT5 si puo' chiudere e dentro quale
#  si puo' compilare. Dal 21/09 non guarda piu' solo il percorso ma anche
#  LA MACCHINA, perche' lo stesso percorso (C:\Program Files\BCM Markets
#  MT5 Terminal) e' il BERSAGLIO sul PC di backtest e il PICCOLO 50503392
#  -- con sedie vive -- sul VPS.
#  Una guardia cosi' NON si legge: si ESEGUE contro i casi che la
#  farebbero sbagliare (regola del contro-esempio, 10/09/2026).
#
#  COSA CAMBIA NELLA v2 DI QUESTO BANCO, ed e' la ragione per cui e' stato
#  riscritto: LA GUARDIA VIVE IN TRE FILE.
#     backtest_pipeline\righe\RIGA_ROUND_VPS.ps1      (l'originale)
#     backtest_pipeline\walkforward_generico.ps1      (il driver)
#     backtest_pipeline\righe\RIGA_SCAN_GESTIONE.ps1  (lo studio uscite)
#  La v1 di questo banco ne provava UNA SOLA, e intanto le altre due erano
#  rimaste indietro di dieci giorni -- cablate sul banco del VPS. Risultato
#  MISURATO: un round su DESKTOP-H4D7CAJ passava la guardia nuova e poi
#  moriva DENTRO IL DRIVER. Falliva chiuso (nessun pericolo) ma non
#  girava, e la firma di Claudio del 21/09 restava non eseguibile.
#  Da oggi il banco fa DUE cose, e servono tutte e due:
#    1. CONFRONTA LE IMPRONTE SHA-256 del blocco condiviso nei tre file.
#       Se divergono, FALLISCE. E' il controllo che mancava: cosi' la
#       divergenza si vede oggi invece di scoprirsi a marzo;
#    2. ESEGUE TUTTI I CASI SU TUTTE E TRE LE COPIE, una per una. Il
#       punto 1 da solo basterebbe (se sono identiche, cio' che vale per
#       una vale per tutte) -- ma un'impronta uguale prova che i byte
#       sono gli stessi, non che quei byte facciano la cosa giusta. Il
#       costo e' qualche secondo, e la prova diventa diretta.
#
#  COME LO FA, e perche' non e' una copia
#  Estrae da OGNI file il blocco fra i due marcatori "BLOCCO COLLAUDABILE
#  OFFLINE" e lo esegue COSI' COM'E'. Se domani qualcuno cambia la
#  guardia, questo banco prova la guardia NUOVA: non c'e' nessuna seconda
#  stesura che possa divergere.
#  Il blocco e' PURO: non legge il disco, non tocca processi, non stampa.
#  Percio' gira su Linux con pwsh, senza MT5 e senza VPS.
#
#  COSA NON COPRE (dichiarato, non nascosto)
#   - il gradino della JUNCTION (ReparsePoint) NON e' qui: sta fuori dal
#     blocco puro perche' e' il DISCO a doverlo dire, e su Linux non c'e'
#     niente da chiedere. Resta [NON MISURATO] da questo banco;
#   - non collauda l'esistenza vera delle cartelle ne' i processi;
#   - non collauda gli ADATTATORI, cioe' le righe che ogni file scrive
#     FUORI dal blocco per leggere $env:COMPUTERNAME e usare la costante
#     della tabella. Quelle sono tre, e sono diverse per forza: si
#     leggono a mano.
#
#  USO:  pwsh -NoProfile -File backtest_pipeline/banco_guardia_macchina.ps1
#  Esce 0 se TUTTO passa, 1 al primo guaio.
#
#  NIENTE EMOJI: Windows PowerShell 5.1 legge i .ps1 come ANSI.
# =====================================================================
param(
  # I TRE FILE, PER NOME. Non "tutto cio' che contiene la guardia": un
  # insieme definito per differenza si trascina dentro quello che non
  # c'entra (classe 180, 10/09/2026). Se nascesse una quarta copia, si
  # aggiunge qui a mano -- ed e' giusto che costi un gesto.
  [string[]]$Files = @(
    "backtest_pipeline/righe/RIGA_ROUND_VPS.ps1",
    "backtest_pipeline/walkforward_generico.ps1",
    "backtest_pipeline/righe/RIGA_SCAN_GESTIONE.ps1"
  )
)
$ErrorActionPreference = "Stop"

$MARC_INI = "BLOCCO COLLAUDABILE OFFLINE: INIZIO"
$MARC_FIN = "BLOCCO COLLAUDABILE OFFLINE: FINE"
$MARC_CON_INI = "GUARDIA_BANCO_POSITIVA_v2 -- INIZIO DEL BLOCCO CONDIVISO"
$MARC_CON_FIN = "GUARDIA_BANCO_POSITIVA_v2 -- FINE DEL BLOCCO CONDIVISO"
$MARC_VECCHIO = "GUARDIA_BANCO_POSITIVA_v1"

function Fallisci([string]$m){ Write-Host ""; Write-Host ("FALLITO: " + $m) -ForegroundColor Red; exit 1 }

# I confini si CONTANO: se un marcatore comparisse DUE volte, il blocco
# estratto sarebbe piu' corto senza dirlo, e il banco misurerebbe un'altra
# cosa. E' successo davvero l'11/09/2026 su un blocco copiato: nove righe
# invece di centocinque, e verdetto sbagliato su tutto.
function Confini($righe,[string]$mIni,[string]$mFin,[string]$file){
  $iIni = @(); $iFin = @()
  for($k=0; $k -lt $righe.Count; $k++){
    if($righe[$k] -like ("*" + $mIni + "*")){ $iIni += $k }
    if($righe[$k] -like ("*" + $mFin + "*")){ $iFin += $k }
  }
  if($iIni.Count -ne 1 -or $iFin.Count -ne 1){
    Fallisci ("in " + $file + " i marcatori '" + $mIni + "' / '" + $mFin + "' non compaiono UNA volta sola (inizio=" + $iIni.Count + ", fine=" + $iFin.Count + ").")
  }
  if($iFin[0] -le $iIni[0]){ Fallisci ("in " + $file + ": marcatore di FINE prima di quello di INIZIO.") }
  return @{ ini = $iIni[0]; fin = $iFin[0] }
}

function Impronta([string]$testo){
  $sha = [System.Security.Cryptography.SHA256]::Create()
  $b   = [System.Text.Encoding]::UTF8.GetBytes($testo)
  $h   = $sha.ComputeHash($b)
  $sha.Dispose()
  return (($h | ForEach-Object { $_.ToString("x2") }) -join "")
}

Write-Host "=== BANCO DELLA GUARDIA PER MACCHINA (v2) -- TRE COPIE ===" -ForegroundColor Cyan
Write-Host ""

# =====================================================================
#  PARTE 1 -- LE TRE COPIE SONO LA STESSA COSA?
#  E' il controllo nuovo del 21/09/2026. Confronta l'impronta SHA-256 del
#  BLOCCO CONDIVISO (marcatori compresi) nei tre file. Se una copia
#  diverge, abbiamo tre guardie diverse che credono di essere la stessa:
#  il difetto peggiore che possa avere un cancello.
# =====================================================================
Write-Host "--- PARTE 1: LE IMPRONTE DELLE TRE COPIE ----------------------------" -ForegroundColor Cyan
$copie = @()
foreach($f in $Files){
  if(-not (Test-Path -LiteralPath $f)){ Fallisci ("non trovo " + $f) }
  $righe = @(Get-Content -LiteralPath $f)

  # 1a. il marcatore VECCHIO non deve piu' esistere: se e' rimasto, quel
  #     file non e' stato aggiornato insieme agli altri.
  $vecchi = @($righe | Where-Object { $_ -like ("*" + $MARC_VECCHIO + "*") })
  if($vecchi.Count -gt 0){
    Fallisci ($f + " porta ancora " + $vecchi.Count + " riga/e col marcatore VECCHIO '" + $MARC_VECCHIO + "'." +
              "`n    Il marcatore sale in TUTTI E TRE i file INSIEME, o le copie divergono.")
  }

  # 1b. ASCII puro (regola del 17/08: Windows PowerShell 5.1 legge i .ps1
  #     come ANSI, e un byte sopra 127 dentro una stringa fa esplodere il
  #     parser con un errore che non nomina la causa).
  $byte = [IO.File]::ReadAllBytes((Resolve-Path -LiteralPath $f))
  $fuori = @()
  for($k=0; $k -lt $byte.Length; $k++){ if($byte[$k] -gt 127){ $fuori += $k; if($fuori.Count -ge 5){ break } } }
  if($fuori.Count -gt 0){
    Fallisci ($f + " NON e' ASCII puro: primo byte fuori scala all'offset " + $fuori[0] + "." +
              "`n    Windows PowerShell 5.1 legge i .ps1 come ANSI: un byte cosi' dentro una stringa rompe il parser.")
  }

  $cCon = Confini $righe $MARC_CON_INI $MARC_CON_FIN $f
  $cEse = Confini $righe $MARC_INI     $MARC_FIN     $f
  if($cEse.ini -lt $cCon.ini -or $cEse.fin -gt $cCon.fin){
    Fallisci ($f + ": il blocco eseguibile non sta DENTRO il blocco condiviso. I marcatori sono fuori posto.")
  }

  $testoCon = ($righe[$cCon.ini..$cCon.fin] -join "`n")
  $testoEse = ($righe[($cEse.ini+1)..($cEse.fin-1)] -join "`n")
  $copie += [pscustomobject]@{
    File      = $f
    RigaIni   = $cCon.ini + 1
    RigaFin   = $cCon.fin + 1
    NRighe    = $cCon.fin - $cCon.ini + 1
    Impronta  = (Impronta $testoCon)
    Eseguibile= $testoEse
    NEseg     = $cEse.fin - $cEse.ini - 1
  }
}

foreach($c in $copie){
  Write-Host ("  " + $c.File.PadRight(48) + " righe " + ("" + $c.RigaIni).PadLeft(5) + "-" + ("" + $c.RigaFin).PadLeft(5) +
              "  (" + $c.NRighe + " righe)  sha256 " + $c.Impronta.Substring(0,16) + "...")
}
$imp = @($copie | ForEach-Object { $_.Impronta } | Select-Object -Unique)
if($imp.Count -ne 1){
  Write-Host ""
  Write-Host "  LE COPIE DIVERGONO. Impronte trovate:" -ForegroundColor Red
  foreach($c in $copie){ Write-Host ("    " + $c.Impronta + "   " + $c.File) -ForegroundColor Red }
  Fallisci ("il blocco condiviso NON e' identico nei " + $copie.Count + " file." +
            "`n    Si modifica in un posto solo e si RICOPIA negli altri due, nello stesso commit.")
}
Write-Host ("  IMPRONTE IDENTICHE: " + $copie.Count + " copie su " + $copie.Count + ", sha256 " + $imp[0]) -ForegroundColor Green
Write-Host "  (nessun marcatore v1 rimasto, tutti e tre ASCII puri)" -ForegroundColor Green
Write-Host ""

# =====================================================================
#  PARTE 2 -- I CONTRO-ESEMPI, SU OGNI COPIA
# =====================================================================
$VPS  = "VMI3047753"
$PCB  = "DESKTOP-H4D7CAJ"
$BANCO   = "C:\MT5_Backtest"
$PICCOLO = "C:\Program Files\BCM Markets MT5 Terminal"

$casi = @(
  # ---- LE SEI PROVE CHIESTE --------------------------------------
  @{ g="1"; mac=$VPS; ber=$BANCO;   att="AMMESSO";   nota="il banco, sul VPS: il caso di sempre" }
  @{ g="2"; mac=$VPS; ber=$PICCOLO; att="RIFIUTATO"; nota="STESSO percorso del caso 3, ma qui e' IL PICCOLO 50503392 con le sedie vive" }
  @{ g="3"; mac=$PCB; ber=$PICCOLO; att="AMMESSO";   nota="STESSO percorso del caso 2: qui e' il terminale del PC di backtest" }
  @{ g="4"; mac=$PCB; ber=$BANCO;   att="RIFIUTATO"; nota="il banco non sta su questa macchina" }
  @{ g="5"; mac=$VPS; ber="C:\BCM_Reale";                             att="RIFIUTATO"; nota="CONTO REALE 10105439" }
  @{ g="5"; mac=$PCB; ber="C:\BCM_Reale";                             att="RIFIUTATO"; nota="CONTO REALE, anche sul PC di backtest" }
  @{ g="5"; mac="PC-SCONOSCIUTO"; ber="C:\BCM_Reale";                 att="RIFIUTATO"; nota="CONTO REALE, anche su una macchina che non conosco" }
  @{ g="5"; mac=$VPS; ber="C:\FTMO";                                  att="RIFIUTATO"; nota="challenge FTMO 541452707, SEI SEDIE VIVE" }
  @{ g="5"; mac=$PCB; ber="C:\FTMO";                                  att="RIFIUTATO"; nota="challenge FTMO" }
  @{ g="5"; mac="PC-SCONOSCIUTO"; ber="C:\FTMO";                      att="RIFIUTATO"; nota="challenge FTMO" }
  @{ g="5"; mac=$VPS; ber="C:\Program Files\BCM Markets MT5 Terminal -V3"; att="RIFIUTATO"; nota="il 100k 50504263" }
  @{ g="5"; mac=$PCB; ber="C:\Program Files\BCM Markets MT5 Terminal -V3"; att="RIFIUTATO"; nota="il 100k: la deroga del PC di backtest NON lo copre" }
  @{ g="5"; mac="PC-SCONOSCIUTO"; ber="C:\Program Files\BCM Markets MT5 Terminal -V3"; att="RIFIUTATO"; nota="il 100k" }
  @{ g="6"; mac="PC-SCONOSCIUTO"; ber=$BANCO;   att="RIFIUTATO"; nota="FAIL-CLOSED: macchina non in tabella" }
  @{ g="6"; mac="PC-SCONOSCIUTO"; ber=$PICCOLO; att="RIFIUTATO"; nota="FAIL-CLOSED" }
  @{ g="6"; mac="PC-SCONOSCIUTO"; ber="D:\QualunqueCosa"; att="RIFIUTATO"; nota="FAIL-CLOSED" }
  @{ g="6"; mac=""; ber=$BANCO; att="RIFIUTATO"; nota="FAIL-CLOSED: COMPUTERNAME vuoto" }

  # ---- E ADESSO PROVO A ROMPERLA ---------------------------------
  @{ g="R"; mac=($PCB + "   "); ber=$PICCOLO; att="AMMESSO";   nota="nome macchina con SPAZI IN CODA: e' la stessa macchina" }
  @{ g="R"; mac="desktop-h4d7caj"; ber=$PICCOLO; att="AMMESSO"; nota="macchina in minuscolo: i nomi NetBIOS non distinguono le maiuscole" }
  @{ g="R"; mac=(" " + $VPS + " "); ber=$PICCOLO; att="RIFIUTATO"; nota="spazi in coda NON devono far perdere il divieto sul VPS" }
  @{ g="R"; mac=$VPS; ber="  C:\MT5_Backtest  "; att="AMMESSO"; nota="spazi attorno al percorso" }
  @{ g="R"; mac=$PCB; ber="C:\PROGRA~1\BCMMAR~1"; att="RIFIUTATO"; nota="nome 8.3: non si indovina, si rifiuta" }
  @{ g="R"; mac=$VPS; ber="C:\PROGRA~1\BCMMAR~1"; att="RIFIUTATO"; nota="nome 8.3, il buco della guardia negativa" }
  @{ g="R"; mac=$PCB; ber="C:/Program Files/BCM Markets MT5 Terminal"; att="AMMESSO"; nota="barre al contrario: STESSO POSTO scritto in un altro modo" }
  @{ g="R"; mac=$VPS; ber="C:/MT5_Backtest/"; att="AMMESSO"; nota="barre al contrario + separatore finale" }
  @{ g="R"; mac=$VPS; ber="C:\MT5_Backtest\..\Program Files\BCM Markets MT5 Terminal"; att="RIFIUTATO"; nota="il '..' porta sul PICCOLO: era il buco trovato l'11/09" }
  @{ g="R"; mac=$PCB; ber="C:\Program Files\BCM Markets MT5 Terminal -V3\..\BCM Markets MT5 Terminal"; att="AMMESSO"; nota="nomina il -V3 ma il '..' ATTERRA sul bersaglio: e' lo stesso posto, ed e' giusto ammetterlo (a valle si usa la COSTANTE, mai questa stringa)" }
  @{ g="R"; mac=$PCB; ber="C:\Program Files\BCM Markets MT5 Terminal\..\BCM Markets MT5 Terminal -V3"; att="RIFIUTATO"; nota="il '..' atterra sul 100k: il nome buono non salva il posto sbagliato" }
  @{ g="R"; mac=$VPS; ber="C:\"; att="RIFIUTATO"; nota="RADICE: la pipe diventerebbe C:\* = ogni terminal64, reale compreso" }
  @{ g="R"; mac=$PCB; ber="C:\"; att="RIFIUTATO"; nota="RADICE" }
  @{ g="R"; mac=$VPS; ber="C:\MT5_Back*"; att="RIFIUTATO"; nota="jolly" }
  @{ g="R"; mac=$VPS; ber="C:\MT5_Backtest\Tester"; att="RIFIUTATO"; nota="sottocartella: non e' la cartella programma" }
  @{ g="R"; mac=$VPS; ber="c:\mt5_backtest"; att="AMMESSO"; nota="percorso in minuscolo: su Windows e' lo stesso posto" }
  @{ g="R"; mac=$VPS; ber="\\VMI3047753\C$\MT5_Backtest"; att="RIFIUTATO"; nota="percorso di rete (UNC)" }
  @{ g="R"; mac=$VPS; ber="C:MT5_Backtest"; att="RIFIUTATO"; nota="senza barra: dipende dalla cartella corrente del disco" }
  @{ g="R"; mac=$VPS; ber=""; att="RIFIUTATO"; nota="bersaglio vuoto" }
  @{ g="R"; mac=$PCB; ber="C:\Program Files\BCM Markets MT5 Terminal\"; att="AMMESSO"; nota="separatore finale" }
  @{ g="R"; mac=$VPS; ber="C:\MT5_MANUALE"; att="RIFIUTATO"; nota="il terminale del trading a mano 50503635" }
  @{ g="R"; mac=$PCB; ber="C:\Users\Master\MT5_Backtest"; att="RIFIUTATO"; nota="un banco fatto in casa non nominato in tabella" }
)

$fallitiTot = 0
$provatiTot = 0
foreach($c in $copie){
  Write-Host ("--- PARTE 2: I CASI SU " + $c.File + " ----") -ForegroundColor Cyan
  Write-Host ("    blocco eseguito: " + $c.NEseg + " righe estratte ed ESEGUITE (non ricopiate)")

  $tmp = Join-Path ([IO.Path]::GetTempPath()) ("guardia_estratta_" + [Guid]::NewGuid().ToString("N") + ".ps1")
  $c.Eseguibile | Set-Content -LiteralPath $tmp -Encoding ASCII
  . $tmp
  Remove-Item -LiteralPath $tmp -Force -ErrorAction SilentlyContinue

  # il guardiano del guardiano, prima dei casi
  $mt = TabellaCoerente
  if($mt -ne ""){ Fallisci ("TabellaCoerente su " + $c.File + " dice -> " + $mt) }
  Write-Host "  TabellaCoerente: OK (nessun doppione, nessun jolly, nessuna radice)" -ForegroundColor Green

  $falliti = 0
  $nCaso = 0
  Write-Host ("  " + "gr".PadRight(3) + "macchina".PadRight(20) + "bersaglio".PadRight(58) + "atteso".PadRight(11) + "esito") -ForegroundColor Gray
  Write-Host ("  " + ("-" * 118)) -ForegroundColor Gray
  foreach($x in $casi){
    $nCaso++
    $motivo = MotivoRifiutoBersaglio $x.ber $x.mac
    $esito  = if($motivo -eq ""){ "AMMESSO" } else { "RIFIUTATO" }
    $ok     = ($esito -eq $x.att)
    if(-not $ok){ $falliti++ }
    $col    = if($ok){ "Green" } else { "Red" }
    $mShow  = "'" + $x.mac + "'"
    $bShow  = "'" + $x.ber + "'"
    if($bShow.Length -gt 56){ $bShow = $bShow.Substring(0,53) + "..." }
    Write-Host ("  " + $x.g.PadRight(3) + $mShow.PadRight(20) + $bShow.PadRight(58) + $x.att.PadRight(11) + $esito + $(if($ok){"  OK"}else{"  <<< FALLITO"})) -ForegroundColor $col
    if(-not $ok){
      Write-Host ("        perche' doveva: " + $x.nota) -ForegroundColor DarkGray
      if($motivo -ne ""){ Write-Host ("        la guardia dice: " + (("" + $motivo) -split "`n")[0]) -ForegroundColor DarkGray }
    }
  }
  $fallitiTot += $falliti
  $provatiTot += $nCaso
  if($falliti -eq 0){ Write-Host ("  " + $nCaso + " casi su " + $nCaso + ": TUTTI PASSATI.") -ForegroundColor Green }
  else            { Write-Host ("  " + $falliti + " casi FALLITI su " + $nCaso + ".") -ForegroundColor Red }
  Write-Host ""
}

if($fallitiTot -eq 0){
  Write-Host ("TUTTO PASSATO: " + $provatiTot + " prove su " + $provatiTot + ", su " + $copie.Count + " copie, piu' il confronto delle impronte.") -ForegroundColor Green
  Write-Host "NON COPERTO DA QUESTO BANCO: il gradino della junction (ReparsePoint), che" -ForegroundColor Yellow
  Write-Host "lo deve dire il DISCO e non la stringa; e gli ADATTATORI fuori dal blocco," -ForegroundColor Yellow
  Write-Host "che sono tre e diversi per forza. Restano [NON MISURATI] da qui." -ForegroundColor Yellow
  exit 0
}
Write-Host ("FALLITI: " + $fallitiTot + " casi su " + $provatiTot + ".") -ForegroundColor Red
exit 1
