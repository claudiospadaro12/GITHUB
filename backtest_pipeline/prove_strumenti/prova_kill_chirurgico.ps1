# =====================================================================
#  MARCATORE_PROVA_KILL_CHIRURGICO_v1
#  CONTRO-ESEMPIO ESEGUIBILE sul filtro della chiusura chirurgica.
#
#  Perche esiste. Il 12/09/2026 sono stati tolti da questo repo 11 kill
#  incondizionati del tipo
#      Get-Process -Name "terminal64" | Stop-Process -Force
#  che non sbagliavano terminale: li ammazzavano TUTTI, conto REALE
#  10105439 compreso, mentre ha posizioni aperte. E non e teoria: il
#  10/09 e successo davvero (runner_abtg.ps1 riga 139).
#
#  Al loro posto c e un FILTRO. Un filtro LETTO non e un filtro PROVATO:
#  questo script lo ESEGUE contro la lista dei quattro terminali che sul
#  VPS esistono davvero, e verifica CHI viene selezionato.
#
#  Si rilancia cosi, e non tocca NIENTE (i processi sono FINTI):
#      pwsh -NoProfile -File backtest_pipeline/prove_strumenti/prova_kill_chirurgico.ps1
#
#  ASCII PURO (regola di casa: i .ps1 si scrivono in ASCII).
# =====================================================================
# esistono DAVVERO (quattro terminali) e verifica CHI viene selezionato.
$finti = @(
  [pscustomobject]@{ Id=1001; Path='C:\MT5_Backtest\terminal64.exe';                                   Chi='BANCO 50504400 (il bersaglio)' }
  [pscustomobject]@{ Id=1002; Path='C:\Program Files\BCM Markets MT5 Terminal\terminal64.exe';         Chi='PICCOLO 50503392 (40 sedie VIVE)' }
  [pscustomobject]@{ Id=1003; Path='C:\Program Files\BCM Markets MT5 Terminal -V3\terminal64.exe';     Chi='100k 50504263' }
  [pscustomobject]@{ Id=1004; Path='C:\BCM_Reale\terminal64.exe';                                      Chi='REALE 10105439' }
  [pscustomobject]@{ Id=1005; Path=$null;                                                              Chi='processo senza Path (accade davvero)' }
)

function Prova($nome, $sel, $attesi){
  $presi = @($sel | ForEach-Object { $_.Id })
  $ok = (@(Compare-Object $presi $attesi -SyncWindow 0).Count -eq 0)
  Write-Host ("  " + $(if($ok){'OK  '}else{'X   '}) + $nome) -ForegroundColor $(if($ok){'Green'}else{'Red'})
  Write-Host ("        presi: " + ($(if($presi.Count){$presi -join ','}else{'nessuno'})) + "   attesi: " + ($(if($attesi.Count){$attesi -join ','}else{'nessuno'})))
  foreach($p in $finti){ if($presi -contains $p.Id){ Write-Host ("        -> MUORE: " + $p.Chi) -ForegroundColor Yellow } }
  return $ok
}

$tutti = $true

Write-Host "--- 1. IL VECCHIO codice (nessuna condizione): che cosa ammazzava ---" -ForegroundColor Cyan
$vecchio = @($finti)
$tutti = (Prova "il vecchio kill prende TUTTI e cinque" $vecchio @(1001,1002,1003,1004,1005)) -and $tutti

Write-Host ""
Write-Host "--- 2. IL NUOVO, forma 'Path uguale all'exe avviato' ---" -ForegroundColor Cyan
$Terminal = 'C:\MT5_Backtest\terminal64.exe'
$sel = @($finti | Where-Object { $_.Path -and ($_.Path -ieq $Terminal) })
$tutti = (Prova "prende SOLO il banco" $sel @(1001)) -and $tutti

Write-Host ""
Write-Host "--- 3. IL NUOVO, forma 'Path sotto la cartella scelta' ---" -ForegroundColor Cyan
$BANCO_PERC = 'C:\MT5_Backtest'
$sel = @($finti | Where-Object { $_.Path -and ($_.Path -like ($BANCO_PERC + "\*")) })
$tutti = (Prova "prende SOLO il banco" $sel @(1001)) -and $tutti

Write-Host ""
Write-Host "--- 4. E SE IL BERSAGLIO FOSSE IL PICCOLO? il filtro deve seguirlo ---" -ForegroundColor Cyan
Write-Host "    (prova che il filtro NON e' una lista nera cablata: segue la variabile)" -ForegroundColor DarkGray
$Terminal = 'C:\Program Files\BCM Markets MT5 Terminal\terminal64.exe'
$sel = @($finti | Where-Object { $_.Path -and ($_.Path -ieq $Terminal) })
$tutti = (Prova "prende SOLO il piccolo, e NON il reale" $sel @(1002)) -and $tutti

Write-Host ""
Write-Host "--- 5. LA TRAPPOLA: il banco NON deve catturare il '-V3' per prefisso ---" -ForegroundColor Cyan
$finti2 = $finti + [pscustomobject]@{ Id=1006; Path='C:\MT5_Backtest_V3\terminal64.exe'; Chi='una SECONDA cartella che comincia uguale' }
$sel = @($finti2 | Where-Object { $_.Path -and ($_.Path -like ('C:\MT5_Backtest' + "\*")) })
$tutti = (Prova "il backslash impedisce il falso positivo" $sel @(1001)) -and $tutti

Write-Host ""
if($tutti){ Write-Host "ESITO: 5 prove su 5. Il filtro fa quello che promette." -ForegroundColor Green }
else      { Write-Host "ESITO: QUALCOSA NON TORNA -- non si consegna." -ForegroundColor Red; exit 1 }
