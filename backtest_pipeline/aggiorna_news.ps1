# =====================================================================
#  aggiorna_news.ps1  --  porta abtg_news.csv dentro MT5 (filtro news EA)
# ---------------------------------------------------------------------
#  Scarica il file news generato dall'agente (data/abtg_news.csv nel repo)
#  e lo copia in MQL5\Files del terminale BCM. Da schedulare ogni mattina
#  sul VPS (dopo il report). L'EA PostNews lo ricarica da solo ogni giorno.
# =====================================================================
param(
  # 12/09/2026: opzionale. Senza, si usa il selettore stretto piu' sotto.
  #  NB: questo blocco DEVE stare prima di qualunque istruzione. Messo dopo,
  #  PowerShell lo legge come una CHIAMATA DI COMANDO "param(...)": il
  #  parser non da' errore e il parametro NON ESISTE. Trovato il 12/09
  #  proprio cosi' -- "0 errori dal parser" su un file rotto. Il parser e'
  #  necessario, non sufficiente: qui serviva chiedere al parser se il
  #  PARAM BLOCK viene riconosciuto, non solo se il file compila.
  [string]$TerminaleDati = ""
)

$ErrorActionPreference = "Stop"
#  IL BRANCH (corretto il 15/08/2026, dopo una pagella vuota)
#  Qui c'era "claude/creating-agents-SgGpD", il vecchio branch di default:
#  fermo al 31/07, con trades_auto.csv che si ferma al 24/07. La pagella
#  settimanale del 15/08 e' uscita con "Nessuno statement con trade nel
#  periodo" per QUESTO - non per un problema di export, di parser o di
#  MT5. Il lavoro sta tutto su `lavoro`.
$RawUrl = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/data/abtg_news.csv"

# =====================================================================
#  IL LOG, e non e' un vezzo (classe 251, 12/09/2026)
#  Questo script gira da un'ATTIVITA' PIANIFICATA (ABTG_AggiornaNews,
#  ogni giorno alle 07:20). In Task Scheduler il Write-Host VA NEL NULLA:
#  finora, se qualcosa andava storto, non se ne accorgeva nessuno --
#  e il file che questo script scrive lo leggono 55 EA di questo repo.
#  Quindi tutto quello che si stampa finisce ANCHE in un log datato.
# =====================================================================
$LogDir = Join-Path $env:USERPROFILE "abtg_news_log"
New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
$LogFile = Join-Path $LogDir ("aggiorna_news_" + (Get-Date -Format "yyyyMMdd_HHmmss") + ".log")
function Dico([string]$t,[string]$c="Gray"){
  Write-Host $t -ForegroundColor $c
  try { Add-Content -LiteralPath $LogFile -Value ((Get-Date -Format "HH:mm:ss") + "  " + $t) -Encoding ASCII } catch { }
}
Dico "=== AGGIORNO abtg_news.csv IN MT5 ===" "Cyan"
Dico ("log di questa corsa: " + $LogFile) "DarkGray"

# --- rileva il terminale BCM + la sua cartella dati ------------------
$allTerm = Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Recurse -Filter "terminal64.exe" -ErrorAction SilentlyContinue
$cand = $allTerm | Where-Object { $_.DirectoryName -like "*BCM Markets MT5 Terminal*" -and $_.DirectoryName -notlike "*-V3*" } | Select-Object -First 1
# 12/09/2026: TOLTO IL RIPIEGO CHE ALLARGAVA IL BERSAGLIO.
# Qui c'era: se il selettore stretto non ha trovato niente, cerca
# "*BCM Markets*" e prendi il PRIMO. Due difetti in una riga sola:
#  - "*BCM Markets*" comprende anche il 100k -V3 (50504263);
#  - "-First 1" su un insieme trovato per RICERCA non e' una scelta, e'
#    un SORTEGGIO: nessun ordinamento, cioe' "quello che il filesystem ha
#    restituito per primo".
# E questo script SCRIVE e RICOMPILA dentro il terminale che sceglie.
# Adesso il bersaglio non si allarga mai da solo: si muore.
if(-not $cand){
  # 12/09/2026 (cancello): qui avevo messo "exit 1", e in 30 script su 84
  # quel blocco sta DENTRO un try{} il cui catch{} scrive il referto e fa
  # lo zip da mandare. Con exit il processo muore sul posto: niente catch,
  # niente referto, NIENTE ZIP -- cioe' la regola delle righe di lancio
  # (punto 2: si raccoglie sempre) annullata proprio nel caso in cui serve
  # di piu'. Con throw il catch la raccoglie e la raccolta parte; e dove il
  # try non c'e', throw termina comunque lo script. Sicuro in tutti e due.
  throw "Terminale non trovato col selettore stretto, e NON allargo la ricerca: il ripiego '*BCM Markets*' comprendeva anche il 100k -V3 (50504263), e questo script scrive e compila dentro il terminale che sceglie. Nomina il terminale a mano, oppure passa il banco C:\MT5_Backtest."
}
$instDir = $cand.DirectoryName
# --- LA GUARDIA SUL BERSAGLIO, e si DICE quale e' (classe 251) --------
#  Questo script scrive dentro MQL5\Files del terminale che scegli qui, e
#  quel file lo leggono 55 EA. Il bersaglio LEGITTIMO e' il piccolo
#  50503392 (e' il mandato: aggiornare il calendario delle sedie vive).
#  Ma finora nessuno STAMPAVA quale terminale fosse stato scelto: se il
#  selettore avesse preso un altro, non si sarebbe saputo.
#  Si puo' anche nominarlo a mano con -TerminaleDati, e il reale e il 100k
#  sono rifiutati PER NOME in tutti i casi.
if($TerminaleDati){
  $instDir = $TerminaleDati.TrimEnd('\','/')
  Dico ("terminale NOMINATO a mano: " + $instDir) "Yellow"
}
if($instDir -like "*BCM_Reale*" -or $instDir -like "*-V3*"){
  Dico ("TERMINALE VIETATO: " + $instDir) "Red"
  Dico "  Questo script sovrascrive il calendario che gli EA leggono. Il conto" "Red"
  Dico "  REALE 10105439 e il 100k 50504263 non si toccano da qui." "Red"
  exit 1
}
Dico ("bersaglio scelto : " + $instDir) "White"
$termRoot = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$DataFolder = Get-ChildItem $termRoot -Directory -ErrorAction SilentlyContinue | Where-Object {
    $o = Join-Path $_.FullName "origin.txt"
    (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $instDir)
} | Select-Object -First 1 -ExpandProperty FullName
if (-not $DataFolder) { Write-Host "Cartella dati non trovata." -ForegroundColor Red; exit 1 }

$FilesDir = Join-Path $DataFolder "MQL5\Files"
New-Item -ItemType Directory -Force -Path $FilesDir | Out-Null
$Dest = Join-Path $FilesDir "abtg_news.csv"

# =====================================================================
#  SCARICO IN DUE TEMPI -- RIPARATO IL 12/09/2026 (classe 251)
# ---------------------------------------------------------------------
#  QUI C'ERA: Invoke-WebRequest -OutFile $Dest, cioe' il download scritto
#  DIRETTAMENTE SUL BERSAGLIO. E il bersaglio non e' un file di lavoro:
#  e' abtg_news.csv dentro MQL5\Files del terminale con le SEDIE VIVE, e
#  lo leggono 55 EA di questo repo (misurato).
#  Un download spezzato a meta' -- rete che cade, 502, timeout dopo i
#  primi byte -- lasciava quel file TRONCATO sotto 55 sedie, e il retry
#  ripartiva su un file gia' rovinato. In piu' questo script gira da
#  un'ATTIVITA' PIANIFICATA (07:20): il Write-Host di controllo va nel
#  nulla, quindi non se ne accorgeva nessuno.
#  ADESSO: si scarica in un file TEMPORANEO, lo si VERIFICA, e solo se
#  passa si sostituisce quello vero (tenendo la copia precedente).
#  Se la verifica non passa, il file in campo NON VIENE TOCCATO: meglio
#  news di ieri che un file troncato.
# =====================================================================
$Tmp  = Join-Path $env:TEMP ("abtg_news_" + (Get-Date -Format "yyyyMMdd_HHmmss") + ".tmp")
$ok = $false
for ($i=1; $i -le 4 -and -not $ok; $i++) {
    try {
        if (Test-Path -LiteralPath $Tmp) { Remove-Item -LiteralPath $Tmp -Force -ErrorAction SilentlyContinue }
        Invoke-WebRequest -Uri $RawUrl -OutFile $Tmp -UseBasicParsing -TimeoutSec 30
        $ok = $true
    } catch {
        Write-Host "   tentativo $i fallito, riprovo..." -ForegroundColor Yellow
        Start-Sleep -Seconds ([math]::Pow(2,$i))
    }
}
if (-not $ok) {
    Write-Host "Download fallito: il file in campo NON e' stato toccato." -ForegroundColor Red
    if (Test-Path -LiteralPath $Dest) { Write-Host ("   resta in campo quello di prima: " + (Get-Item -LiteralPath $Dest).LastWriteTime) -ForegroundColor Yellow }
    exit 1
}

# --- LA VERIFICA, prima di toccare il file che leggono 55 EA ----------
$guasti = @()
if (-not (Test-Path -LiteralPath $Tmp -PathType Leaf)) { $guasti += "il file scaricato non esiste" }
else {
    $len = (Get-Item -LiteralPath $Tmp).Length
    if ($len -eq 0) { $guasti += "file VUOTO (0 byte)" }
    $righe = @(Get-Content -LiteralPath $Tmp -ErrorAction SilentlyContinue)
    if ($righe.Count -lt 2) { $guasti += ("solo " + $righe.Count + " righe: un CSV di news ne ha almeno 2 (intestazione + un evento)") }
    # ogni riga viva deve avere lo stesso numero di separatori della prima:
    # un troncamento a meta' riga si vede QUI e non in campo
    $vive = @($righe | Where-Object { $_ -and $_.Trim() -ne "" })
    if ($vive.Count -ge 2) {
        $sep0 = ($vive[0].ToCharArray() | Where-Object { $_ -eq ',' -or $_ -eq ';' }).Count
        $storte = @($vive | Where-Object { (($_.ToCharArray() | Where-Object { $_ -eq ',' -or $_ -eq ';' }).Count) -ne $sep0 })
        if ($storte.Count -gt 0) { $guasti += ($storte.Count + " righe con un numero di separatori diverso dalla prima: il file e' TRONCATO o malformato") }
    }
}
if ($guasti.Count -gt 0) {
    Write-Host "" 
    Write-Host "SCARICATO MA NON VALIDO: non tocco il file in campo." -ForegroundColor Red
    foreach ($g in $guasti) { Write-Host ("   - " + $g) -ForegroundColor Red }
    Write-Host "   Meglio le news di ieri che un file troncato sotto 55 sedie." -ForegroundColor Yellow
    if (Test-Path -LiteralPath $Dest) { Write-Host ("   resta in campo quello di prima: " + (Get-Item -LiteralPath $Dest).LastWriteTime) -ForegroundColor Yellow }
    Remove-Item -LiteralPath $Tmp -Force -ErrorAction SilentlyContinue
    exit 1
}

# --- SOSTITUZIONE, con la copia di prima tenuta da parte -------------
if (Test-Path -LiteralPath $Dest) {
    Copy-Item -LiteralPath $Dest -Destination ($Dest + ".prima") -Force -ErrorAction SilentlyContinue
}
Move-Item -LiteralPath $Tmp -Destination $Dest -Force
Write-Host "   verificato e messo in campo (la copia di prima e' in abtg_news.csv.prima)" -ForegroundColor Green

$n = (Get-Content $Dest | Measure-Object -Line).Lines
Dico "OK: abtg_news.csv aggiornato ($n eventi) in:" "Green"
Dico ("   " + $Dest)
Dico "L'EA PostNews lo ricaricera' automaticamente." "White"
