# =====================================================================
#  MARCATORE_RIGA_CALENDARIO_ECB_1009_v1
#  Scrive nel calendario l'evento BCE del 10/09/2026, per far girare
#  la sedia PostNews ECB 771201 sul DEMO piccolo 50503392.
#  07/09/2026, su richiesta di Claudio ("il 10 c'e' la BCE, testiamolo").
# ---------------------------------------------------------------------
#  PERCHE' SERVE CREARLO E NON RIPRISTINARLO
#  L'evento BCE nel calendario NON C'E' MAI STATO:
#    - Common\Files\abtg_news.csv NON ESISTE;
#    - la copia nella sandbox del piccolo era a ZERO righe.
#  Ripristinare il .bak del 07/09 rimetterebbe un file vuoto. Va CREATA
#  la riga. (Verbale: report/POSTNEWS_NEUTRALIZZATE_2026-09-07.md)
#
#  LA RIGA, E PERCHE' E' FATTA COSI' -- tutto verificato nel sorgente:
#     2026.09.10 12:15;High;EUR;ECB Interest Rate Decision
#   - FORMATO: 4 colonne separate da ';' -- come le righe gia' presenti
#     nel file dell'NFP (header "Data Ora;Impatto;Valuta;Titolo").
#   - "High" -> ImpactToInt (r.598) torna 3, e il preset chiede >=3. OK.
#   - "EUR"  -> NewsToday fa StringFind(InpNewsCurrencies, gNewsCcy):
#     cerca la valuta del CSV DENTRO la lista del preset (InpNewsCurrencies=EUR). OK.
#   - "ECB Interest Rate Decision" -> il preset ha InpNewsTitleMatch=ECB e
#     il confronto e' StringFind(titolo,"ECB"), CASE SENSITIVE (r.272).
#     Scrivere "BCE" NON funzionerebbe.
#   - L'ORA: NewsToday (r.274) confronta SOLO anno/mese/giorno. L'ora NON
#     decide niente sull'armamento, che avviene a InpActionHour=14 ORA
#     SERVER (= 15:00 italiane). L'ora nel file e' quindi COSMETICA.
#     [DEDOTTO, non misurato] Ho usato 12:15 perche' la riga NFP gia' nel
#     file dice "2026.09.04 12:30" e l'NFP e' alle 14:30 italiane: quel
#     file e' scritto in UTC. La BCE decide alle 14:15 italiane = 12:15
#     UTC. Se la convenzione fosse un'altra, NON cambia niente per
#     l'armamento -- ma va detto invece di farlo sembrare misurato.
#
#  >>> DOVE SCRIVE: nel Common\Files E nella sandbox MQL5\Files di ogni
#      cartella dati, esattamente come ha fatto la riga che ha svuotato.
#      Cosi' qualunque dei due percorsi legga l'EA, l'evento c'e'.
#  >>> SICURA: senza -EseguiDavvero guarda e non tocca.
#  >>> Fa una COPIA DATATA di ogni file prima di scriverci.
#  >>> RILEGGE il file dopo aver scritto e lo dichiara: una riga scritta
#      ma non rileggibile e' una riga che non esiste.
#
#  ATTENZIONE, COSA NON FA: non riarma l'EA. Il calendario si ricarica al CAMBIO
#    DI GIORNO (r.230) o a un OnInit. Scritto oggi 07/09, sara' in
#    memoria dall'08/09 -- in tempo per il 10.
# =====================================================================

param([switch]$EseguiDavvero)

$ErrorActionPreference = "Stop"
$FILE   = "abtg_news.csv"
$HEADER = "Data Ora;Impatto;Valuta;Titolo"
$RIGA   = "2026.09.10 12:15;High;EUR;ECB Interest Rate Decision"
$stamp  = Get-Date -Format "yyyy-MM-dd_HHmmss"

Write-Host ""
Write-Host "=== CALENDARIO: evento BCE del 10/09/2026 (sedia 771201) ===" -ForegroundColor Cyan
Write-Host "    MARCATORE_RIGA_CALENDARIO_ECB_1009_v1" -ForegroundColor DarkGray
Write-Host ("    riga da scrivere:  " + $RIGA) -ForegroundColor White
if(-not $EseguiDavvero){ Write-Host "    MODALITA' GUARDA E BASTA. Per agire: -EseguiDavvero" -ForegroundColor Yellow }

$root = Join-Path $env:APPDATA "MetaQuotes\Terminal"
if(-not (Test-Path $root)){ Write-Host "!!! nessuna cartella MetaQuotes\Terminal" -ForegroundColor Red; exit 1 }

$posti = New-Object System.Collections.ArrayList
[void]$posti.Add((Join-Path $root "Common\Files"))
foreach($d in @(Get-ChildItem $root -Directory -ErrorAction SilentlyContinue | Where-Object { Test-Path (Join-Path $_.FullName "MQL5") })){
  $p = Join-Path $d.FullName "MQL5\Files"
  if(Test-Path -LiteralPath $p){ [void]$posti.Add($p) }
}

$scritti = 0; $gia = 0; $falliti = 0
foreach($p in $posti){
  if(-not (Test-Path -LiteralPath $p)){ Write-Host ("  (non esiste, salto) " + $p) -ForegroundColor DarkGray; continue }
  $f = Join-Path $p $FILE
  Write-Host ""
  Write-Host ("  " + $f) -ForegroundColor Yellow
  $esisteva = Test-Path -LiteralPath $f
  $righe = if($esisteva){ @(Get-Content -LiteralPath $f -ErrorAction SilentlyContinue) } else { @() }
  Write-Host ("     stato: " + $(if($esisteva){"esiste, " + $righe.Count + " righe"}else{"NON esiste -- lo creo"}))
  if($righe -contains $RIGA){
    $gia++
    Write-Host "     LA RIGA C'E' GIA': non la duplico." -ForegroundColor Green
    continue
  }
  if(-not $EseguiDavvero){ Write-Host "     -> ci scriverei la riga. Adesso non tocco niente." -ForegroundColor Cyan; continue }

  if($esisteva){
    $bak = $f + ".PRIMA_DI_ECB_" + $stamp + ".bak"
    Copy-Item -LiteralPath $f -Destination $bak -Force
    if(-not (Test-Path -LiteralPath $bak)){ $falliti++; Write-Host "     !!! BACKUP FALLITO: NON scrivo." -ForegroundColor Red; continue }
  }
  $nuovo = New-Object System.Collections.ArrayList
  if($righe.Count -gt 0){ foreach($r in $righe){ [void]$nuovo.Add($r) } } else { [void]$nuovo.Add($HEADER) }
  [void]$nuovo.Add($RIGA)
  Set-Content -LiteralPath $f -Value $nuovo -Encoding ASCII

  # RILETTURA: una riga scritta ma non rileggibile e' una riga che non esiste
  $dopo = @(Get-Content -LiteralPath $f -ErrorAction SilentlyContinue)
  if($dopo -contains $RIGA){
    $scritti++
    Write-Host ("     SCRITTA e RILETTA. righe adesso: " + $dopo.Count) -ForegroundColor Green
    foreach($r in $dopo){ Write-Host ("       | " + $r) -ForegroundColor Gray }
  } else {
    $falliti++
    Write-Host "     !!! SCRITTA MA NON RILETTA: non contarla." -ForegroundColor Red
  }
}

Write-Host ""
if(-not $EseguiDavvero){
  Write-Host "ESITO: GUARDATO E BASTA. Niente e' stato toccato." -ForegroundColor Cyan
  Write-Host "  Per agire: rilancia la stessa riga aggiungendo  -EseguiDavvero" -ForegroundColor Cyan
  exit 0
}
Write-Host ("ESITO: scritti " + $scritti + "   gia' presenti " + $gia + "   falliti " + $falliti) -ForegroundColor $(if($falliti -eq 0 -and ($scritti+$gia) -gt 0){"Green"}else{"Red"})
if($falliti -gt 0){ exit 3 }
if(($scritti + $gia) -eq 0){ Write-Host "  NESSUN file scritto: FERMATI e dillo." -ForegroundColor Red; exit 2 }
Write-Host ""
Write-Host "ADESSO, PER FAR VALERE LA MODIFICA:" -ForegroundColor Yellow
Write-Host "  il calendario si ricarica al CAMBIO DI GIORNO o a un OnInit dell'EA." -ForegroundColor Yellow
Write-Host "  Scritto oggi, sara' in memoria da domani: in tempo per il 10/09." -ForegroundColor Yellow
Write-Host "  Per vederlo SUBITO: nella finestra dell'EA premi OK (rifa' OnInit)," -ForegroundColor Yellow
Write-Host "  poi in ESPERTI cerca la riga  [PostNews][NEWS] letto da ... UTILI ..." -ForegroundColor Yellow
Write-Host "  UTILI deve essere >= 1. Se dice 0, c'e' il CANARINO ROSSO e non e' armata." -ForegroundColor Yellow
exit 0
