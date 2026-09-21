# =====================================================================
#  MARCATORE_BANCO_GUARDIA_MACCHINA_v1
#  banco_guardia_macchina.ps1 -- I CONTRO-ESEMPI DELLA GUARDIA v2
# ---------------------------------------------------------------------
#  PERCHE' ESISTE (21/09/2026)
#  righe\RIGA_ROUND_VPS.ps1 decide QUALE terminale MT5 si puo' chiudere.
#  Dal 21/09 la sua guardia non guarda piu' solo il percorso ma anche LA
#  MACCHINA, perche' lo stesso percorso (C:\Program Files\BCM Markets MT5
#  Terminal) e' il BERSAGLIO sul PC di backtest e il PICCOLO 50503392 --
#  con sedie vive -- sul VPS.
#  Una guardia cosi' NON si legge: si ESEGUE contro i casi che la
#  farebbero sbagliare (regola del contro-esempio, 10/09/2026).
#
#  COME LO FA, e perche' non e' una copia
#  Estrae da RIGA_ROUND_VPS.ps1 il blocco fra i due marcatori
#  "BLOCCO COLLAUDABILE OFFLINE: INIZIO/FINE" e lo esegue COSI' COM'E'.
#  Se domani qualcuno cambia la guardia, questo banco prova la guardia
#  NUOVA: non c'e' nessuna seconda stesura che possa divergere.
#  Il blocco e' PURO: non legge il disco, non tocca processi, non stampa.
#  Percio' gira su Linux con pwsh, senza MT5 e senza VPS.
#
#  COSA NON COPRE (dichiarato, non nascosto)
#   - il gradino della JUNCTION (ReparsePoint) NON e' qui: sta fuori dal
#     blocco puro perche' e' il DISCO a doverlo dire, e su Linux non c'e'
#     niente da chiedere. Resta [NON MISURATO] da questo banco;
#   - non collauda l'esistenza vera delle cartelle ne' i processi.
#
#  USO:  pwsh -NoProfile -File backtest_pipeline/banco_guardia_macchina.ps1
#  Esce 0 se TUTTI i casi passano, 1 al primo fallito.
#
#  NIENTE EMOJI: Windows PowerShell 5.1 legge i .ps1 come ANSI.
# =====================================================================
param(
  [string]$File = "backtest_pipeline/righe/RIGA_ROUND_VPS.ps1"
)
$ErrorActionPreference = "Stop"

$MARC_INI = "BLOCCO COLLAUDABILE OFFLINE: INIZIO"
$MARC_FIN = "BLOCCO COLLAUDABILE OFFLINE: FINE"

if(-not (Test-Path -LiteralPath $File)){ Write-Host ("ERRORE: non trovo " + $File) -ForegroundColor Red; exit 1 }
$righe = @(Get-Content -LiteralPath $File)

# I confini si contano: se un marcatore comparisse DUE volte, il blocco
# estratto sarebbe piu' corto senza dirlo, e il banco misurerebbe un'altra
# cosa. E' successo davvero l'11/09/2026 su un blocco copiato: nove righe
# invece di centocinque, e verdetto sbagliato su tutto.
$iIni = @(); $iFin = @()
for($k=0; $k -lt $righe.Count; $k++){
  if($righe[$k] -like ("*" + $MARC_INI + "*")){ $iIni += $k }
  if($righe[$k] -like ("*" + $MARC_FIN + "*")){ $iFin += $k }
}
if($iIni.Count -ne 1 -or $iFin.Count -ne 1){
  Write-Host ("ERRORE: i marcatori del blocco non compaiono UNA volta sola (inizio=" + $iIni.Count + ", fine=" + $iFin.Count + ").") -ForegroundColor Red
  exit 1
}
if($iFin[0] -le $iIni[0]){ Write-Host "ERRORE: marcatore di FINE prima di quello di INIZIO." -ForegroundColor Red; exit 1 }

$blocco = $righe[($iIni[0]+1)..($iFin[0]-1)]
$tmp = Join-Path ([IO.Path]::GetTempPath()) ("guardia_estratta_" + [Guid]::NewGuid().ToString("N") + ".ps1")
($blocco -join "`n") | Set-Content -LiteralPath $tmp -Encoding ASCII
. $tmp

Write-Host "=== BANCO DELLA GUARDIA PER MACCHINA (v2) ===" -ForegroundColor Cyan
Write-Host ("    file   : " + $File)
Write-Host ("    blocco : righe " + ($iIni[0]+2) + "-" + $iFin[0] + " del file, " + $blocco.Count + " righe estratte ed ESEGUITE")
Write-Host ""

# --- prima di tutto: la tabella e' coerente? (il guardiano del guardiano)
$mt = TabellaCoerente
if($mt -ne ""){ Write-Host ("FALLITO subito: TabellaCoerente dice -> " + $mt) -ForegroundColor Red; exit 1 }
Write-Host "  TabellaCoerente: OK (tabella scritta bene: nessun doppione, nessun jolly, nessuna radice)" -ForegroundColor Green
Write-Host ""

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

$falliti = 0
$nCaso = 0
Write-Host ("  " + "gr".PadRight(3) + "macchina".PadRight(20) + "bersaglio".PadRight(58) + "atteso".PadRight(11) + "esito") -ForegroundColor Gray
Write-Host ("  " + ("-" * 118)) -ForegroundColor Gray
foreach($c in $casi){
  $nCaso++
  $motivo = MotivoRifiutoBersaglio $c.ber $c.mac
  $esito  = if($motivo -eq ""){ "AMMESSO" } else { "RIFIUTATO" }
  $ok     = ($esito -eq $c.att)
  if(-not $ok){ $falliti++ }
  $col    = if($ok){ "Green" } else { "Red" }
  $mShow  = "'" + $c.mac + "'"
  $bShow  = "'" + $c.ber + "'"
  if($bShow.Length -gt 56){ $bShow = $bShow.Substring(0,53) + "..." }
  Write-Host ("  " + $c.g.PadRight(3) + $mShow.PadRight(20) + $bShow.PadRight(58) + $c.att.PadRight(11) + $esito + $(if($ok){"  OK"}else{"  <<< FALLITO"})) -ForegroundColor $col
  Write-Host ("        perche': " + $c.nota) -ForegroundColor DarkGray
  if($motivo -ne ""){
    $prima = (("" + $motivo) -split "`n")[0]
    Write-Host ("        la guardia dice: " + $prima) -ForegroundColor DarkGray
  }
}

Remove-Item -LiteralPath $tmp -Force -ErrorAction SilentlyContinue
Write-Host ""
if($falliti -eq 0){
  Write-Host ("TUTTI PASSATI: " + $nCaso + " casi su " + $nCaso + ".") -ForegroundColor Green
  Write-Host "NON COPERTO DA QUESTO BANCO: il gradino della junction (ReparsePoint), che" -ForegroundColor Yellow
  Write-Host "lo deve dire il DISCO e non la stringa. Resta [NON MISURATO] da qui." -ForegroundColor Yellow
  exit 0
}
Write-Host ("FALLITI: " + $falliti + " casi su " + $nCaso + ".") -ForegroundColor Red
exit 1
