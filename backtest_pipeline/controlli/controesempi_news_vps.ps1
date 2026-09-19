# =====================================================================
#  controesempi_news_vps.ps1 -- 19/09/2026
#
#  I CONTRO-ESEMPI della riparazione del canale news, ESEGUITI.
#  Regola del 10/09/2026: "prima di consegnare, devo costruire IO il
#  contro-esempio che lo farebbe sbagliare, e far vedere che non
#  sbaglia". Un contro-esempio raccontato non vale niente.
#
#  COSA PROVA: le funzioni pure di RIGA_RIPARA_NEWS.ps1, estratte dal
#  file vero (non ricopiate: se il file cambia, cambia anche cio' che
#  si prova). Gira anche su una macchina SENZA Task Scheduler, quindi
#  anche fuori da Windows: e' per questo che quelle decisioni sono
#  state scritte come funzioni separate.
#
#  COSA NON PROVA, e va detto: lo strato che parla con Task Scheduler
#  (Get-ScheduledTask / schtasks / Start-ScheduledTask) qui non gira.
#  Quello si verifica sul VPS, sull'ARTEFATTO, ed e' per questo che la
#  riga rilegge sempre l'attivita' dopo averla toccata.
#
#  USO:  pwsh -NoProfile -File backtest_pipeline/controlli/controesempi_news_vps.ps1
#  USCITA: 0 = tutti passati, 1 = almeno uno fallito.
# =====================================================================
$ErrorActionPreference = "Stop"
$qui = Split-Path -Parent $PSCommandPath
$sorgente = Join-Path (Split-Path -Parent $qui) "righe\RIGA_RIPARA_NEWS.ps1"
if(-not (Test-Path -LiteralPath $sorgente)){
  $sorgente = (Join-Path (Split-Path -Parent $qui) "righe/RIGA_RIPARA_NEWS.ps1")
}
if(-not (Test-Path -LiteralPath $sorgente)){ throw ("non trovo " + $sorgente) }
$testo = Get-Content -LiteralPath $sorgente -Raw
$i = $testo.IndexOf("function EstraiPercorsoDaArgomenti")
$j = $testo.IndexOf("#  DA QUI IN GIU")
if($i -lt 0 -or $j -le $i){ throw "non riesco a isolare le funzioni pure nel file sorgente" }
$blocco = $testo.Substring($i, $j - $i)
$k = $blocco.LastIndexOf("# =====")
if($k -gt 0){ $blocco = $blocco.Substring(0, $k) }
$quante = ([regex]::Matches($blocco, '(?m)^function\s')).Count
Write-Host ("funzioni pure estratte da " + (Split-Path -Leaf $sorgente) + ": " + $quante) -ForegroundColor Cyan
if($quante -ne 7){ throw ("mi aspettavo 7 funzioni pure, ne ho estratte " + $quante + ": il file e' cambiato, aggiorna i contro-esempi") }
$tmpF = Join-Path ([System.IO.Path]::GetTempPath()) ("funzioni_news_" + [guid]::NewGuid().ToString('N') + ".ps1")
Set-Content -LiteralPath $tmpF -Value $blocco -Encoding ASCII
. $tmpF

$script:n = 0
$script:ko = 0
function Prova([string]$nome, $atteso, $avuto){
  $script:n = $script:n + 1
  $ok = (("" + $atteso) -eq ("" + $avuto))
  if(-not $ok){ $script:ko = $script:ko + 1 }
  $e = "FALLITO"
  if($ok){ $e = "ok    " }
  Write-Host ("  [" + $e + "] " + $nome + "   atteso='" + $atteso + "' avuto='" + $avuto + "'")
}
function ProvaContiene([string]$nome, [string]$pezzo, $elenco){
  $script:n = $script:n + 1
  $t = ($elenco -join " | ")
  $ok = ($t -match [regex]::Escape($pezzo))
  if(-not $ok){ $script:ko = $script:ko + 1 }
  $e = "FALLITO"
  if($ok){ $e = "ok    " }
  Write-Host ("  [" + $e + "] " + $nome + "   -> '" + $t + "'")
}

$scriptNews = Join-Path (Split-Path -Parent $qui) "aggiorna_news.ps1"
if(-not (Test-Path -LiteralPath $scriptNews)){ throw ("non trovo " + $scriptNews) }
$labA = Join-Path ([System.IO.Path]::GetTempPath()) ("lab_news_a_" + [guid]::NewGuid().ToString('N'))
$labB = Join-Path ([System.IO.Path]::GetTempPath()) ("lab_news_b_" + [guid]::NewGuid().ToString('N'))
Write-Host "--- 1. EstraiPercorsoDaArgomenti (la cartella VECCHIA ha spazi e parentesi) ---"
$vecchio = '-NoProfile -ExecutionPolicy Bypass -File "C:\Users\Administrator\Desktop\GITHUB-claude-creating-agents-SgGpD (1)\GITHUB-claude-creating-agents-SgGpD\backtest_pipeline\aggiorna_news.ps1"'
Prova "percorso fra virgolette con spazi" "C:\Users\Administrator\Desktop\GITHUB-claude-creating-agents-SgGpD (1)\GITHUB-claude-creating-agents-SgGpD\backtest_pipeline\aggiorna_news.ps1" (EstraiPercorsoDaArgomenti $vecchio)
Prova "percorso nudo con -WindowStyle" "C:\ABTG\aggiorna_news.ps1" (EstraiPercorsoDaArgomenti '-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File C:\ABTG\aggiorna_news.ps1')
Prova "percorso fra apici + altri argomenti" "C:\ABTG\pubblica_trades.ps1" (EstraiPercorsoDaArgomenti "-NoProfile -File 'C:\ABTG\pubblica_trades.ps1' -Branch lavoro")
Prova "nessun -File" "" (EstraiPercorsoDaArgomenti '-NoProfile -Command "Write-Host ciao"')
Prova "argomenti vuoti" "" (EstraiPercorsoDaArgomenti "")

Write-Host "--- 2. PercorsoAmmesso (dove NON si mette il codice in produzione) ---"
Prova "C:\ABTG ammesso" "True" ((PercorsoAmmesso "C:\ABTG").Ok)
Prova "sul Desktop RIFIUTATO" "False" ((PercorsoAmmesso "C:\Users\Administrator\Desktop\ABTG").Ok)
Prova "dentro MetaQuotes RIFIUTATO" "False" ((PercorsoAmmesso "C:\Users\a\AppData\Roaming\MetaQuotes\ABTG").Ok)
Prova "con spazi RIFIUTATO" "False" ((PercorsoAmmesso "C:\Program Files\ABTG").Ok)
Prova "relativo RIFIUTATO" "False" ((PercorsoAmmesso "ABTG").Ok)
Prova "vuoto RIFIUTATO" "False" ((PercorsoAmmesso "").Ok)

Write-Host "--- 3. DecidiRipuntamento (i tre casi, compresa la doppia corsa) ---"
Prova "attivita' ASSENTE" "CREA_A_MANO" (DecidiRipuntamento $false $vecchio "C:\ABTG\aggiorna_news.ps1")
Prova "punta alla cartella vecchia -> RIPUNTA" "RIPUNTA" (DecidiRipuntamento $true $vecchio "C:\ABTG\aggiorna_news.ps1")
Prova "seconda corsa di fila -> GIA_A_POSTO" "GIA_A_POSTO" (DecidiRipuntamento $true (ArgomentiAttesi "C:\ABTG\aggiorna_news.ps1") "C:\ABTG\aggiorna_news.ps1")
Prova "maiuscole diverse -> GIA_A_POSTO" "GIA_A_POSTO" (DecidiRipuntamento $true '-NoProfile -File c:\abtg\AGGIORNA_NEWS.PS1' "C:\ABTG\aggiorna_news.ps1")
Prova "argomenti senza -File -> RIPUNTA" "RIPUNTA" (DecidiRipuntamento $true '-NoProfile -Command x' "C:\ABTG\aggiorna_news.ps1")
$MARC = "MARCATORE_AGGIORNA_NEWS_v2"
$BR   = "/lavoro/data/abtg_news.csv"
$w = $labA
Remove-Item -LiteralPath $w -Recurse -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path $w | Out-Null
$buono = Join-Path $w "buono.ps1"
Copy-Item -LiteralPath $scriptNews -Destination $buono -Force
$shaBuono = (Get-FileHash -LiteralPath $buono -Algorithm SHA256).Hash

Write-Host "--- 4. VerificaScaricato: cinque modi di rompere un download ---"
$r = VerificaScaricato $buono $shaBuono $MARC $BR
Prova "file buono passa" "True" $r.Ok

$mezzo = Join-Path $w "mezzo.ps1"
$tutto = [System.IO.File]::ReadAllBytes($buono)
[System.IO.File]::WriteAllBytes($mezzo, $tutto[0..([int]($tutto.Length/2))])
$r = VerificaScaricato $mezzo $shaBuono $MARC $BR
Prova "CLONE A META': rifiutato" "False" $r.Ok
ProvaContiene "CLONE A META': dice perche'" "IMPRONTA DIVERSA" $r.Guasti

$vuoto = Join-Path $w "vuoto.ps1"
Set-Content -LiteralPath $vuoto -Value "" -NoNewline
$r = VerificaScaricato $vuoto ((Get-FileHash -LiteralPath $vuoto -Algorithm SHA256).Hash) $MARC $BR
Prova "file VUOTO: rifiutato" "False" $r.Ok
ProvaContiene "file VUOTO: dice perche'" "file VUOTO" $r.Guasti

$assente = Join-Path $w "non_esiste.ps1"
$r = VerificaScaricato $assente $shaBuono $MARC $BR
Prova "file ASSENTE: rifiutato" "False" $r.Ok
ProvaContiene "file ASSENTE: dice perche'" "non esiste" $r.Guasti

$senzaMarc = Join-Path $w "senza_marcatore.ps1"
(Get-Content -LiteralPath $buono -Raw).Replace($MARC,"MARCATORE_VECCHIO_v1") | Set-Content -LiteralPath $senzaMarc -NoNewline
$r = VerificaScaricato $senzaMarc ((Get-FileHash -LiteralPath $senzaMarc -Algorithm SHA256).Hash) $MARC $BR
Prova "VERSIONE VECCHIA (impronta giusta, marcatore no): rifiutata" "False" $r.Ok
ProvaContiene "versione vecchia: dice perche'" "manca il marcatore" $r.Guasti

$altroBranch = Join-Path $w "altro_branch.ps1"
(Get-Content -LiteralPath $buono -Raw).Replace("/lavoro/data/abtg_news.csv","/claude/creating-agents-SgGpD/data/abtg_news.csv") | Set-Content -LiteralPath $altroBranch -NoNewline
$r = VerificaScaricato $altroBranch ((Get-FileHash -LiteralPath $altroBranch -Algorithm SHA256).Hash) $MARC $BR
Prova "BRANCH VECCHIO dentro lo script: rifiutato" "False" $r.Ok
ProvaContiene "branch vecchio: dice perche'" "sta puntando a un altro branch" $r.Guasti

$conEmoji = Join-Path $w "con_emoji.ps1"
$b = [System.IO.File]::ReadAllBytes($buono)
$piu = New-Object byte[] ($b.Length + 4)
[Array]::Copy($b,$piu,$b.Length)
$piu[$b.Length]=240; $piu[$b.Length+1]=159; $piu[$b.Length+2]=148; $piu[$b.Length+3]=180
[System.IO.File]::WriteAllBytes($conEmoji,$piu)
$r = VerificaScaricato $conEmoji ((Get-FileHash -LiteralPath $conEmoji -Algorithm SHA256).Hash) $MARC $BR
Prova "BYTE NON-ASCII: rifiutato" "False" $r.Ok
ProvaContiene "non-ASCII: dice perche'" "non-ASCII" $r.Guasti

$rotto = Join-Path $w "rotto.ps1"
((Get-Content -LiteralPath $buono -Raw) + "`nfunction {`n") | Set-Content -LiteralPath $rotto -NoNewline
$r = VerificaScaricato $rotto ((Get-FileHash -LiteralPath $rotto -Algorithm SHA256).Hash) $MARC $BR
Prova "FILE CHE NON COMPILA: rifiutato" "False" $r.Ok
ProvaContiene "non compila: dice perche'" "NON COMPILA" $r.Guasti
$w = $labB
Remove-Item -LiteralPath $w -Recurse -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path $w | Out-Null
$sorg = Join-Path $w "sorgente.ps1"
Copy-Item -LiteralPath $scriptNews -Destination $sorg -Force
$sha = (Get-FileHash -LiteralPath $sorg -Algorithm SHA256).Hash

Write-Host "--- 5. InstallaCopia ---"
$dest = Join-Path $w "ABTG_NON_ESISTE"
Prova "la cartella NON esiste prima" "False" (Test-Path -LiteralPath $dest)
$r1 = InstallaCopia $sorg $dest $sha "20260919_1700"
Prova "cartella creata e file installato" "True" (Test-Path -LiteralPath $r1.Dest)
Prova "impronta del file installato" $sha $r1.Sha
Prova "nessun backup alla prima installazione" "" $r1.Backup
Prova "non era gia' uguale" "False" $r1.EraGiaUguale

Write-Host "--- 5b. LA STESSA RIGA LANCIATA DUE VOLTE DI FILA ---"
$r2 = InstallaCopia $sorg $dest $sha "20260919_1701"
Prova "seconda corsa: riconosce che era gia' uguale" "True" $r2.EraGiaUguale
Prova "seconda corsa: nessun backup inutile" "" $r2.Backup
Prova "seconda corsa: impronta ancora giusta" $sha $r2.Sha
Prova "nessun file .prima_ sparso" 0 (@(Get-ChildItem -LiteralPath $dest -Filter "*.prima_*" -ErrorAction SilentlyContinue).Count)

Write-Host "--- 5c. C'E' GIA' UNA COPIA VECCHIA DIVERSA ---"
Set-Content -LiteralPath (Join-Path $dest "aggiorna_news.ps1") -Value "# roba vecchia" -NoNewline
$r3 = InstallaCopia $sorg $dest $sha "20260919_1702"
Prova "la copia vecchia viene salvata" "True" (Test-Path -LiteralPath $r3.Backup)
Prova "il backup contiene la roba vecchia" "# roba vecchia" (Get-Content -LiteralPath $r3.Backup -Raw)
Prova "in campo c'e' quella nuova" $sha $r3.Sha

Write-Host "--- 5d. IL CLONE FALLISCE A META': la sorgente non e' quella attesa ---"
$mezzo = Join-Path $w "mezzo.ps1"
$b = [System.IO.File]::ReadAllBytes($sorg)
[System.IO.File]::WriteAllBytes($mezzo, $b[0..([int]($b.Length/2))])
$prima = (Get-FileHash -LiteralPath (Join-Path $dest "aggiorna_news.ps1") -Algorithm SHA256).Hash
$eccezione = ""
try { InstallaCopia $mezzo $dest $sha "20260919_1703" | Out-Null } catch { $eccezione = $_.Exception.Message }
Prova "si rifiuta e lo dice" "True" ($eccezione -match "NON INSTALLO NIENTE")
$dopo = (Get-FileHash -LiteralPath (Join-Path $dest "aggiorna_news.ps1") -Algorithm SHA256).Hash
Prova "IL FILE IN CAMPO NON E' STATO TOCCATO" $prima $dopo

Write-Host "--- 6. ClassificaEsito ---"
Prova "esito 0 + calendario di oggi = A" "A" (ClassificaEsito 0 "OK: abtg_news.csv aggiornato (31 eventi)" 4210 "2026-09-19" "2026-09-19")
Prova "esito 1 + 'file VUOTO' = B (sorgente vuota)" "B" (ClassificaEsito 1 "SCARICATO MA NON VALIDO: non tocco il file in campo. - file VUOTO (0 byte)" 0 "2026-09-16" "2026-09-19")
Prova "esito 4294770688 (percorso mancante) = C" "C" (ClassificaEsito 4294770688 "" 0 "2026-09-16" "2026-09-19")
Prova "esito 0 ma calendario di ieri = C (non mi accontento)" "C" (ClassificaEsito 0 "" 4210 "2026-09-18" "2026-09-19")
Prova "esito 1 senza spiegazione = C" "C" (ClassificaEsito 1 "Download fallito" 4210 "2026-09-19" "2026-09-19")
Prova "esito 0 ma file VUOTO in campo = C" "C" (ClassificaEsito 0 "" 0 "2026-09-19" "2026-09-19")

Remove-Item -LiteralPath $labA -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -LiteralPath $labB -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -LiteralPath $tmpF -Force -ErrorAction SilentlyContinue
Write-Host ""
Write-Host ("CONTRO-ESEMPI PROVATI: " + $script:n + "   FALLITI: " + $script:ko) -ForegroundColor Cyan
if($script:ko -gt 0){ exit 1 }
exit 0
